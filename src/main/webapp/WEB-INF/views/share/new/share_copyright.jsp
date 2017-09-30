<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>${internationalConfig.版权信息}</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript" src="/js/dict.js" charset="utf-8"></script>
    <script type="text/javascript">
        var dataGrid;
        $(function () {

            dataGrid = $('#dataGrid').datagrid({
                url: '/new/share_copyright_config/search',
                fit: true,
                fitColumns: true,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 10,
                pageList: [10, 20, 30, 40, 50],
                sortName: 'createTime',
                sortOrder: 'desc',
                checkOnSelect: false,
                selectOnCheck: false,
                singleSelect: true,
                nowrap: false,
                rownumbers: true,
                frozenColumns: [
                    [
                        {
                            field: 'id',
                            title: '${internationalConfig.编号}',
                            width: 50,
                            hidden: true
                        }
                    ]
                ],
                columns: [[{
                    field: 'id',
                    title: 'CPID',
                    width: 30
                }, {
                    field: 'cpId',
                    title: '${internationalConfig.全球CPID}',
                    width: 30
                }, {
                    field: 'nameEn',
                    title: '${internationalConfig.CP英文全名}',
                    width: 150
                }, {
                    field: 'name',
                    title: '${internationalConfig.CP中文全名}',
                    width: 250
                }, {
                    field: 'country',
                    title: '${internationalConfig.所属国家}',
                    width: 100,
                    formatter: function (value, row, index) {
                        return Dict.getName("country", value);
                    }
                }, {
                    field: 'type',
                    title: '${internationalConfig.类别}',
                    width: 50,
                    formatter: function (value, row, index) {
                        switch (value) {
                            case 1:
                                return '${internationalConfig.默认分类}';
                            case 2:
                                return '${internationalConfig.影业}';
                            case 3:
                                return '${internationalConfig.动漫}';
                            case 4:
                                return '${internationalConfig.音乐}';
                            case 5:
                                return 'PGC';
                            default:
                                return '${internationalConfig.未定义}';
                        }
                    }
                }, {
                    field: 'timeSpan',
                    title: '${internationalConfig.有效期}',
                    width: 250
                }, {
                    field: 'action',
                    title: '${internationalConfig.操作}',
                    width: 100,
                    formatter: function (value, row, index) {
                        var str = String.format("<a href='javascript:void(0);' onclick='updateFun({0})' class='propsOperation'>${internationalConfig.修改}</a>", row.id);
                        //str += String.format("<a href='javascript:void(0);' onclick='deleteFun({0});' class='propsOperation'>删除</a>", row.id);
                        return str;
                    }
                }]],
                toolbar: '#toolbar',
                onLoadSuccess: function () {
                    $('#searchForm table').show();
                    parent.$.messager.progress('close');
                },
                onRowContextMenu: function (e, rowIndex, rowData) {
                    e.preventDefault();
                    $(this).datagrid('unselectAll');
                    $(this).datagrid('selectRow', rowIndex);
                    $('#menu').menu('show', {
                        left: e.pageX,
                        top: e.pageY
                    });
                }
            });
        });


        function updateFun(updateId) {
            parent.$.modalDialog({
                title: '${internationalConfig.CP基本信息}',
                width: 950,
                height: 600,
                href: '/new/share_copyright_config/update_copyright?copyrightId=' + updateId,
                buttons: [{
                    text: '${internationalConfig.提交}',
                    handler: function () {
                        parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#form');
                        f.submit();
                    }
                }]
            });
        }


        function deleteFun(deleteId) {
            parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.您是否要删除当前配置}', function (b) {
                if (b) {
                    parent.$.messager.progress({
                        title: '${internationalConfig.提示}',
                        text: '${internationalConfig.数据处理中请稍后}'
                    });
                    $.get('${pageContext.request.contextPath}/new/share_copyright_config/delete', {copyrightId:deleteId}, function (result) {
                        if (result.code == 0) {
                            parent.$.messager.alert('${internationalConfig.提示}', "${internationalConfig.操作成功}", 'info');
                            dataGrid.datagrid('reload');
                        }
                        parent.$.messager.progress('close');
                    }, 'JSON');
                }
            });
        }

        function searchFun() {
            dataGrid.datagrid({
                url: '/new/share_copyright_config/search',
                queryParams: $.serializeObject($('#searchForm'))
            });
        }


        function cleanFun() {
            $('#searchForm input').val('');
            $('#searchForm select').val('0');
            dataGrid.datagrid('load', {});
        }


    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false" style="height: 120px; overflow: hidden;">
        <form id="searchForm">
            <table class="table-more">
                <tr>
                    <td>${internationalConfig.所属国家地区}：
                        <select name="country">
                            <option selected value="0">${internationalConfig.全部}</option>
                            <option value='86'>${internationalConfig.中国大陆}</option>
                            <option value='1'>${internationalConfig.美国}</option>
                            <option value='852'>${internationalConfig.香港}</option>
                            <option value='91'>${internationalConfig.印度}</option>
                        </select>
                    </td>
                    <td>${internationalConfig.类别}：
                        <select name="type">
                            <option value="">${internationalConfig.全部}</option>
                            <option value="1">${internationalConfig.默认分类}</option>
                            <option value="2">${internationalConfig.影业}</option>
                            <option value="3">${internationalConfig.动漫}</option>
                            <option value="4">${internationalConfig.音乐}</option>
                            <option value="5">PGC</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>BOSSCPID ：<input name="id"class="span2"/></td>
                    <td>CPID ：<input name="cpId"class="span2"/></td>
                    <td>${internationalConfig.CP名称} ：<input name="name" class="span2"/></td>
                </tr>
            </table>
        </form>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>
<div id="toolbar" style="display: none;">

    <a onclick="updateFun(0);" href="javascript:void(0);" class="easyui-linkbutton"
       data-options="plain:true,iconCls:'pencil_add'">${internationalConfig.添加}</a>


    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true"
       onclick="searchFun();">${internationalConfig.查询}</a><a href="javascript:void(0);" class="easyui-linkbutton"
                                         data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">${internationalConfig.清空条件}</a>
</div>

</body>
</html>
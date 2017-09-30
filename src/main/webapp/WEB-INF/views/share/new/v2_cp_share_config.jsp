<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>${internationalConfig.版权分成配置}</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">
        var dataGrid;
        $(function () {

            dataGrid = $('#dataGrid').datagrid({
                url: '/new/v2_cp_share_config/search',
                fit: true,
                fitColumns: true,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 10,
                pageList: [10, 20, 30, 40, 50],
                checkOnSelect: false,
                selectOnCheck: false,
                singleSelect: true,
                nowrap: false,
                rownumbers: true,
                sortName: 'id',
                sortOrder: 'desc',
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
                    title: '${internationalConfig.规则ID}',
                    width: 200
                }, {
                    field: 'cid',
                    title: 'CPID',
                    width: 200
                }, {
                    field: 'cpName',
                    title: '${internationalConfig.CP中文全名}',
                    width: 200
                }, {
                    field: 'albumId',
                    title: '${internationalConfig.专辑ID}',
                    width: 200,
                    formatter: function (value, row, index) {
                        return value == '0' ? '' : value;
                    }
                }, {
                    field: 'albumName',
                    title: '${internationalConfig.专辑名称}',
                    width: 200
                }, {
                    field: 'cpType',
                    title: '${internationalConfig.类别}',
                    width: 100,
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
                    title: '${internationalConfig.时间段}',
                    width: 200
                }, {
                    field: 'ratio',
                    title: '${internationalConfig.系统系数}',
                    width: 200
                }, {
                    field: 'maxLimit',
                    title: '${internationalConfig.上限预警}',
                    width: 200
                }, {
                    field: 'configType',
                    title: '${internationalConfig.分成类型}',
                    width: 200,
                    formatter: function (value, row, index) {
                        var str = '';
                        if (value == 1) {
                            str = '${internationalConfig.付费分成}';
                        } else if (value == 2) {
                            str = '${internationalConfig.CPM分成}';
                        } else if (value == 3) {
                            str = '${internationalConfig.播放分成}';
                        } else if (value == 4) {
                            str = '${internationalConfig.累计时长分成}';
                        } else if (value == 5) {
                            str = '${internationalConfig.会员订单分成}';
                        } else if (value == 6) {
                            str = '${internationalConfig.业务订单分成}';
                        } else {
                            str = '${internationalConfig.其它}';
                        }
                        return str;
                    }
                }, {
                    field: 'status',
                    title: '${internationalConfig.状态}',
                    width: 200,
                    formatter: function (value, row, index) {
                        var str = '';
                        if (!value) {
                            return '${internationalConfig.未生效}';
                        }

                        if (value == 0) {
                            str = '${internationalConfig.未生效}';
                        } else if (value == 1) {
                            str = '${internationalConfig.生效中}';
                        } else if (value == 2) {
                            str = '${internationalConfig.已失效}';
                        } else {
                            str = '${internationalConfig.其它}';
                        }
                        return str;
                    }
                }, {
                    field: 'action',
                    title: '${internationalConfig.操作}',
                    width: 200,
                    formatter: function (value, row, index) {
                        var str = String.format("<a href='javascript:void(0);' onclick='updateFun({0})' class='propsOperation'>${internationalConfig.修改}</a> | ", row.id);
                        str += String.format("<a href='javascript:void(0);' onclick='deleteFun({0});' class='propsOperation'>${internationalConfig.删除}</a>", row.id);
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
                title: '${internationalConfig.分成配置}',
                width: 820,
                height: 600,
                href: '/new/v2_cp_share_config/update?id=' + updateId,
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
                    $.get('${pageContext.request.contextPath}/new/v2_cp_share_config/delete?id=' + deleteId, function (result) {
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
            var startTime = $("input[name='startTimeLimit']").val();
            var endTime = $("input[name='endTimeLimit']").val();
            if ((startTime || endTime) && (!startTime || !endTime)) {
                parent.$.messager.alert('${internationalConfig.提示}', "${internationalConfig.请补全查询开始或结束时间}", 'info');
                return;
            }

            var albumId = $("input[name='albumId']").val();
            var reg = new RegExp("^[0-9]*$");
            if (!reg.test(albumId)) {
                parent.$.messager.alert('${internationalConfig.提示}', "${internationalConfig.专辑ID只能输入数字}", 'info');
                return;
            }

            if (albumId == '0') {
                parent.$.messager.alert('${internationalConfig.提示}', "${internationalConfig.专辑ID不能为0}", 'info');
                return;
            }

            dataGrid.datagrid({
                url: '/new/v2_cp_share_config/search',
                queryParams: $.serializeObject($('#searchForm'))
            });
        }


        function cleanFun() {
            $('#searchForm input').val('');
            $('#searchForm select').val('');
            dataGrid.datagrid('load', {});
        }


    </script>
</head>
<body>
<style>
    .start-time,.end-time{width: 100px;}
    select{width:186px;}
</style>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false" style="height: 120px; overflow: hidden;">
        <form id="searchForm">
            <table class="table-more">
                <tr>
                    <td>${internationalConfig.时间段}：<input name="startTimeLimit" class="easyui-datebox"/> - <input name="endTimeLimit"
                                                                                            class="easyui-datebox"/>
                    </td>
                    <td>${internationalConfig.类别}：
                        <select name="cpType">
                            <option value="">${internationalConfig.全部}</option>
                            <option value="1">${internationalConfig.默认分类}</option>
                            <option value="2">${internationalConfig.影业}</option>
                            <option value="3">${internationalConfig.动漫}</option>
                            <option value="4">${internationalConfig.音乐}</option>
                            <option value="5">PGC</option>
                        </select>
                    </td>
                    <td>${internationalConfig.分成类型}：
                        <select name="configType">
                            <option value="">${internationalConfig.全部}</option>
                            <option value="1">${internationalConfig.付费分成}</option>
                            <option value="2">${internationalConfig.CPM分成}</option>
                            <option value="3">${internationalConfig.播放分成}</option>
                            <option value="4">${internationalConfig.累计时长分成}</option>
                            <option value="5">${internationalConfig.会员订单分成}</option>
                            <option value="6">${internationalConfig.业务订单分成}</option>
                        </select>
                    </td>
                    <td>${internationalConfig.状态}：<select name="status">
                        <option value="">${internationalConfig.全部}</option>
                        <option value="0">${internationalConfig.未生效}</option>
                        <option value="1">${internationalConfig.生效中}</option>
                        <option value="2">${internationalConfig.已失效}</option>
                    </select></td>
                </tr>
                <tr>
                    <td>CPID ：<input name="cid" placeholder="${internationalConfig.请输入CPID}" class="span2"/></td>
                    <td>${internationalConfig.CP名称} ：<input name="cpName" placeholder="${internationalConfig.请输入CP名称}" class="span2"/></td>
                    <td>${internationalConfig.专辑ID} ：<input name="albumId" placeholder="${internationalConfig.请输入专辑ID}" class="span2"/></td>
                    <td>${internationalConfig.专辑名称} ：<input name="albumName" placeholder="${internationalConfig.专辑名称}" class="span2"/></td>
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
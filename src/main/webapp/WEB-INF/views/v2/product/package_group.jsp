<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>${internationalConfig.PriceMovieManage}</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript"  src="/js/dict.js"></script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false" style="height: 120px; overflow: hidden;">
        <form id="searchForm">
            <table class="table-td-four" style="display: none;">
                <tr>
                    <td>${internationalConfig.套餐分组名称}：<input name="groupName" class="span2"/></td>
                    <td>${internationalConfig.套餐分组ID}：<input name="decryptId" class="span2"/></td>
                    <td>${internationalConfig.发布状态}：
                        <select name="status" class="span2">
                            <option value="0" selected>${internationalConfig.全部}</option>
                            <option value="1">${internationalConfig.未发布}</option>
                            <option value="3">${internationalConfig.已发布}</option>
                        </select>
                    </td>
                    <td>
                        ${internationalConfig.套餐ID}：<input name="packageId" class="span2">
                    </td>
                </tr>
            </table>
        </form>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>
<div id="toolbar" style="display: none;">
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'pencil_add',plain:true"
       onclick="addFun(0);">${internationalConfig.增加}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true"
       onclick="searchFun();">${internationalConfig.查询}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true"
       onclick="cleanFun();">${internationalConfig.清空条件}</a>
</div>

</body>
<script type="text/javascript">
    var dataGrid;
    $(function () {
        dataGrid = $('#dataGrid').datagrid({
            url: '/v2/product/packageGroup/dataGrid',
            fit: true,
            fitColumns: true,
            border: false,
            pagination: true,
            idField: 'id',
            pageSize: 20,
            pageList: [10, 20, 30, 40, 50],
            sortName: 'id',
            sortOrder: 'asc',
            checkOnSelect: false,
            selectOnCheck: false,
            singleSelect: true,
            nowrap: false,
            striped: true,
            rownumbers: true,
            singleSelect: true,
            frozenColumns: [
                [
                    {
                        field: 'id',
                        title: '${internationalConfig.序号}',
                        width: 50,
                        hidden: true
                    }
                ]
            ],
            columns: [[
                {
                    field: 'id',
                    title: '${internationalConfig.套餐分组ID}',
                    width: 50,
                    sortable: true
                },
                {
                    field: 'encryptId',
                    title: '${internationalConfig.加密ID}',
                    width: 50,
                    sortable: true
                },
                {
                    field: 'groupName',
                    title: '${internationalConfig.套餐分组名称}',
                    width: 180
                },
                {
                    field: 'status',
                    title: '${internationalConfig.发布状态}',
                    width: 100,
                    formatter: function (value) {
                        var str = '';
                        if("1" == value) {
                            str = "${internationalConfig.未发布}";
                        }else if("3" == value) {
                            str = "${internationalConfig.已发布}";
                        }
                        return str;
                    }
                },
                {
                    field: 'operater',
                    title: '${internationalConfig.创建人}',
                    width: 100,
                    sortable: false
                },
                {
                    field: 'updateTime',
                    title: '${internationalConfig.更新时间}',
                    width: 100,
                    sortable: false
                },
                {
                    field: 'action',
                    title: '${internationalConfig.操作}',
                    width: 80,
                    formatter: function (value, row, index) {
                        var name=row.groupName.replace(new RegExp("'", 'g'),"&#39;");
                        name = name.replace(new RegExp('"', 'g'),'&amp;quot;');
                        name = name.replace(new RegExp('\\s', 'g'),'&nbsp;');
                        var str = $.formatString('<img onclick=editFun(\"{0}\",\"{1}\"); src="{2}" title="${internationalConfig.编辑}"/>', row.id, name, '/static/style/images/extjs_icons/pencil.png');
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

    function submitFun(f, type) {
        if (f.form("validate")) {
            parent.$.messager.progress({
                title : '${internationalConfig.提示}',
                text : '${internationalConfig.数据处理中}....'
            });

            var successStr;
            if(type == 1){
                successStr = "${internationalConfig.添加成功}";
            }else if(type == 2){
                successStr = "${internationalConfig.修改成功}";
            }
            $.ajax({
                url : "/v2/product/packageGroup/save",
                type : "post",
                data : f.serializeJson(),
                dataType : "json",
                success : function(result) {
                    parent.$.messager.progress('close');
                    if (result.code == 0) {
                        parent.$.messager.alert('${internationalConfig.成功}', successStr, 'success');
                        parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                        parent.$.modalDialog.handler.dialog('close');
                    } else {
                        parent.$.messager.alert('${internationalConfig.错误}', '<div style="word-break:break-all;">'+result.msg+'</div>', 'error');
                    }
                },

                error : function() {}
            })
        }
    }

    function addFun(id, groupName){
        groupName = groupName?'('+groupName+')':'';
        parent.iframeTab.init({url:'/v2/product/packageGroup/editPackageGroup?id='+id,text:'编辑分组内容'+groupName});
    }
    function editFun(id, groupName){
        addFun(id, groupName);
    }
    function searchFun() {
        dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
    }
    function cleanFun() {
        $('#searchForm input').val('');
        $('#searchForm select').val('0');
        dataGrid.datagrid('load', {});
    }
</script>
</html>
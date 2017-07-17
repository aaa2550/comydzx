<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>${internationalConfig.支付成功页活动配置}</title>
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
    <style>
        .search-title{
            width: 80px;
            margin-right: 10px;
            text-align: right;
        }
    </style>
</head>
<body>
    <div class="easyui-layout" data-options="fit : true,border : false">
        <div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false" style="height: 100px; overflow: hidden;">
            <form id="searchForm">
                <table class="table-more" style="display: none;">
                    <tr>

                        <td><span class="search-title">${internationalConfig.活动名称}</span><input name="activityName" class="span2" /></td>
                        <td><span class="search-title">${internationalConfig.状态}</span>
                            <select name="status" id="status" class="span2">
                                <option value="-1">${internationalConfig.全部}</option>
                                <option value="1">${internationalConfig.已发布}</option>
                                <option value="0">${internationalConfig.未发布}</option>
                            </select>
                        </td>
                        <td><span class="search-title">${internationalConfig.会员名称}</span>
                            <select id="vipTypeId" name="vipTypeId" class="span2">
                                    <option value="">${internationalConfig.全部}</option>
                                <c:forEach var="item" items="${vipPackageTypes}">
                                    <option value="${item.id}">${item.name}</option>
                                </c:forEach>
                            </select>
                        </td>
                        <td><span class="search-title">${internationalConfig.套餐内容}</span>
                            <select id="vipPackageId" name="vipPackageId" style="width:350px">
                            </select>
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
        <m:auth uri="/v2/activity_success_cfg/edit">
            <a onclick="editFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'pencil_add'">${internationalConfig.添加}</a>
        </m:auth>
        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_go',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">${internationalConfig.清空条件}</a>
    </div>
</body>
<script>
    var vipTypes={<c:forEach items="${vipPackageTypes}" var="item">${item.id}:'${fn:replace(item.name, '\'', '\\\'')}',</c:forEach>};
    var vipPackages={<c:forEach items="${vipPackages}" var="item">${item.id}:{typeId:${item.typeId}, content:'${item.id} - ${fn:replace(item.name, '\'', '\\\'')} - ${fn:replace(item.durationName, '\'', '\\\'')} - ${item.price}'<c:if test="${item.autoRenew==1}">+$.formatString(' - ${internationalConfig.自动续费X期}', '${item.autoRenewPeriod}')</c:if>, shortContent:'${fn:replace(item.name, '\'', '\\\'')} ${fn:replace(item.durationName, '\'', '\\\'')}'},</c:forEach>};
    var dataGrid;
    $(document).ready(function(){
        $('#vipTypeId').change(function(){
            var vipTypeId=$(this).val();
            var packageInput=$('#vipPackageId');
            packageInput.empty();
            packageInput.append($('<option>',{value:'', text:'${internationalConfig.全部}'}));
            $.each(vipPackages, function(id, obj){
                if (obj.typeId==vipTypeId)
                    packageInput.append($('<option>',{value:id, text:obj.content}));
            });
        });
        //$('#vipTypeId').trigger('change');
        searchFun();
    });
    function renderDataGrid(url) {
        return $('#dataGrid').datagrid({
            url : url,
            fit : true,
            fitColumns : true,
            border : false,
            pagination : true,
            idField : 'id',
            pageSize : 20,
            pageList : [ 10, 20, 30, 40, 50 ],
            sortName : 'id',
            sortOrder : 'desc',
            checkOnSelect : false,
            selectOnCheck : false,
            singleSelect: true,
            nowrap: false,
            striped: true,
            rownumbers: true,
            singleSelect: true,
            frozenColumns: [
                []
            ],
            columns : [ [
                {
                    field: 'id',
                    title: '${internationalConfig.配置ID}',
                    width: 50,
                    sortable: true
                }, {
                    field : 'activityName',
                    title : '${internationalConfig.活动名称}',
                    width : 100,
                    sortable : true
                }, {
                    field : 'vipTypeId',
                    title : '${internationalConfig.会员名称}',
                    width : 100,
                    formatter: function (value) {
                        return vipTypes[value];
                    }
                }, {
                    field : 'vipPackageId',
                    title : '${internationalConfig.套餐信息}',
                    width : 100,
                    formatter: function (value) {
                        var pkg=vipPackages[value];
                        return pkg ? pkg.shortContent : pkg;
                    }
                }, {
                    field : 'terminals',
                    title : '${internationalConfig.支持终端}',
                    width : 100,
                    formatter: function (value) {
                        var terminals={<c:forEach items="${terminals}" var="item">${item.terminalId}:"${item.terminalName}",</c:forEach>};
                        var text = [];
                        if(value) {
                            var items = value.split(/\s*,\s*/);
                            for (var i in items){
                                text.push(terminals[items[i]]);
                            }
                        }
                        return text.join(', ');
                    }
                }, {
                    field : 'status',
                    title : '${internationalConfig.状态}',
                    width : 50,
                    formatter : function(value) {
                        var statuses = {0:'${internationalConfig.未发布}',1:'${internationalConfig.已发布}'};
                        return statuses[value];
                    }
                }, {
                    field : 'action',
                    title : '${internationalConfig.操作}',
                    width : 100,
                    formatter : function(value, row, index) {
                        var html = '';
                        <m:auth uri="/v2/activity_success_cfg/edit">
                        html += $.formatString('<a href="javascript:void(0)" onclick="editFun(\'{0}\')">${internationalConfig.编辑}</a>', row.id);
                        html += "&nbsp;&nbsp;&nbsp;&nbsp;";
                        html += $.formatString('<a href="javascript:void(0)" onclick="deleteFun(\'{0}\')">${internationalConfig.删除}</a>', row.id);
                        </m:auth>
                        return html;
                    }
                } ] ],
            toolbar : '#toolbar',
            onLoadSuccess : function() {
                $('#searchForm table').show();
                parent.$.messager.progress('close');
            },
            onRowContextMenu : function(e, rowIndex, rowData) {
                e.preventDefault();
                $(this).datagrid('unselectAll');
                $(this).datagrid('selectRow', rowIndex);
                $('#menu').menu('show', {
                    left : e.pageX,
                    top : e.pageY
                });
            }
        });
    }

    function searchFun(){
        dataGrid = renderDataGrid('/v2/activity_success_cfg/datagrid?' + $('#searchForm').serialize());
       //dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
    }
    function editFun(id){
        parent.$.modalDialog({
            title: id==undefined ? '${internationalConfig.新增支付成功配置页}' : '${internationalConfig.编辑支付成功配置页}',
            width: 600,
            height: 500,
            resizable: true,
            href: '/v2/activity_success_cfg/edit' + (id == undefined ? '' : '?id='+id),
            onClose : function() {
                this.parentNode.removeChild(this);
            },
            buttons: [{
                text: '${internationalConfig.保存}',
                handler: function () {
                    parent.$.modalDialog.openner_dataGrid = dataGrid;
                    var f = parent.$.modalDialog.handler.find('#form');
                    f.submit();
                }
            }, {
                text: "${internationalConfig.关闭}",
                handler: function () {
                    parent.$.modalDialog.handler.dialog('close');
                }
            }]
        });
    }
    function deleteFun(id){
        parent.$.messager.confirm('${internationalConfig.询问}','${internationalConfig.您是否要删除当前配置}',
                function(b) {
                    if (b) {
                        parent.$.messager.progress({
                            title : '${internationalConfig.提示}',
                            text : '${internationalConfig.数据处理中}....'
                        });
                        $.post('/v2/activity_success_cfg/delete',
                                {id : id},
                                function(result) {
                                    if (result.code == 0) {
                                        parent.$.messager.alert('${internationalConfig.提示}','${internationalConfig.删除成功}','info');
                                        dataGrid.datagrid('reload');
                                    }
                                    parent.$.messager.progress('close');
                                },
                         'JSON');
                    }
                });
    }
    function cleanFun(){
        $('input').val('');
        $('select').val('');
        $('#status').val('-1');
    }
</script>
</html>
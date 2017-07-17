<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>${internationalConfig.点播定价}</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
<script type="text/javascript"  src="/js/dict.js"></script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false" style="height: 120px; overflow: hidden;">
        <form id="searchForm">
            <table class="table-td-four" style="display: none;">
                <tr>

                    <td>${internationalConfig.内容名称}&nbsp;<input name="name" class="span2"/></td>
                    <td>${internationalConfig.VIDPID}&nbsp;<input name="id" class="span2 easyui-numberbox" data-options="precision:0,min:1"/></td>
                    <td>${internationalConfig.内容分类}&nbsp;
                        <select name="chargeRule" class="span2">
                            <option value="1">${internationalConfig.专辑}</option>
                            <option value="3">${internationalConfig.视频}</option>
                        </select>
                    </td>
                    <td>${internationalConfig.频道}&nbsp;
                        <select name="channel" class="span2">
                            <option value="-1" selected>${internationalConfig.全部}</option>
                            <c:forEach items="${dict.channel}" var="channel">
                                <option value="${channel.key}">${channel.value}</option>
                            </c:forEach>
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
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true"
       onclick="searchFun();">${internationalConfig.查询}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true"
       onclick="cleanFun();">${internationalConfig.清空条件}</a>
</div>

</body>
<script type="text/javascript">
    var dataGrid;
    function renderDataGrid() {
        dataGrid = $('#dataGrid').datagrid({
            url: '/v2/product/video/vrs_search/datagrid',
            fit: true,
            queryParams:$.serializeObject($('#searchForm')),
            fitColumns: true,
            border: false,
            pagination: true,
            idField: 'id',
            pageSize: 20,
            pageList: [10, 20, 30, 40, 50],
            sortName: 'id',
            sortOrder: 'desc',
            checkOnSelect: false,
            selectOnCheck: false,
            singleSelect: true,
            nowrap: false,
            striped: true,
            rownumbers: true,
            singleSelect: true,
            columns: [[
                {
                    field: 'id',
                    title: '${internationalConfig.内容ID}',
                    width: 80
                },
                {
                    field: 'nameEn',
                    title: '${internationalConfig.内容名称}',
                    width: 100,
                    formatter: function(value,row,index){
                        <c:choose>
                            <c:when test="${currentCountry==86 || currentCountry == 852}">
                        return row.nameCn ? row.nameCn : row.nameEn;
                            </c:when><c:otherwise>
                        return row.nameEn ? row.nameEn : row.nameCn;
                            </c:otherwise>
                        </c:choose>
                    }
                },{
                    field: 'albumOrVideo',
                    title: '${internationalConfig.内容分类}',
                    width: 50,
                    formatter: function(value,row,index){
                        return value == 'video' ? '${internationalConfig.视频}':'${internationalConfig.专辑}';
                    }
                },{
                    field: 'category',
                    title: '${internationalConfig.频道}',
                    width: 50,
                    formatter: function (value) {
                        //return Dict.getName("channel",value);
                        for (var key in value)
                            return value[key];
                    }
                }, {
                    field: 'syncStatus',
                    title: '${internationalConfig.同步状态}',
                    width: 50,
                    formatter: function (value) {
                        return value == 1 ? '${internationalConfig.已同步}' : '${internationalConfig.未同步}';
                    }
                }, {
                    field: 'syncTime',
                    title: '${internationalConfig.同步时间}',
                    width: 150
                }, {
                    field: 'isPay',
                    title : '${internationalConfig.是否收费}',
                    width : 50,
                    formatter : function(value){
                        if(value == 0){
                            return "${internationalConfig.免费}"
                        } else if(value == 1){
                            return "${internationalConfig.付费}"
                        }else{
                            return "${internationalConfig.未知}"
                        }
                    }
                }, {
                    field: 'action',
                    title: '${internationalConfig.操作}',
                    width: 80,
                    formatter: function (value, row, index) {
                        var str = $.formatString('<a onclick="editFun(\'{0}\',{1});" href="javascript:void(0)" title="${internationalConfig.编辑付费信息}">${internationalConfig.编辑付费信息}</a>', row.id, row.chargeRule);
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
    }

    //编辑信息
    function editFun(id,chargeRule) {
        if (id == undefined) {
            var rows = dataGrid.datagrid('getSelections');
            id = rows[0].id;
            alert(id);
        }
        parent.$.modalDialog({
            title: '${internationalConfig.点播内容定价}',
            width: 800,
            height: 550,
            resizable: true,
            href: $.formatString('/v2/product/video/v2/edit?id={0}&chargeRule={1}',id,chargeRule),
            buttons: [{
                text: '${internationalConfig.保存}',
                handler: function () {
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

    $(function(){
        renderDataGrid();
    });

    function searchFun() {
        renderDataGrid();
    }
    function cleanFun() {
        $('#searchForm input').val('');
        $('#searchForm select').val('-1');
        $('#searchForm select[name="chargeRule"]').val('1');
        dataGrid.datagrid('load', {});
    }
</script>
</html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <title>${internationalConfig.任务管理}</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
</head>
<style>
    select{
        width:100px;
    }
    #searchTable{
        width: 90%;
        margin:10px 10px 10px 10px;
        line-height: 40px;
        overflow: auto;
    }
    .title-span {
        width: 80px;
    }
</style>
<body>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false" style="height: 120px; overflow: hidden;">
        <form id="searchForm">
            <table id="searchTable" style="display: block;">
                <tr>
                    <td><span class="title-span">${internationalConfig.任务创建时间}:</span><input class="easyui-datetimebox" name="createTimeFrom"></td>
                    <td>&nbsp;&nbsp;&nbsp;${internationalConfig.到}:&nbsp;&nbsp;&nbsp;<input class="easyui-datetimebox" name="createTimeTo"></td>
                    <td><span class="title-span">${internationalConfig.任务类型}:</span><select name="type" id="type">
                            <option value="">${internationalConfig.全部}</option>
                            <option value="v2_coupon_export">${internationalConfig.V2代金券导出}</option>
                            <option value="lecard_export">${internationalConfig.乐卡信息导出}</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td><span class="title-span">${internationalConfig.任务ID}:</span><input class="span2" name="id"></td>
                    <td><span class="title-span">${internationalConfig.任务名称}:</span><input class="span2" name="name"></td>
                    <c:if test="${sessionInfo.superMan}">
                    <td><span class="title-span">${internationalConfig.操作人}:</span><input class="span2" name="operator"/></td>
                    </c:if>
                    <td><span class="title-span">${internationalConfig.状态}:</span>
                        <select name="status" id="status">
                            <option value="-1">${internationalConfig.全部}</option>
                            <option value="0">${internationalConfig.未处理}</option>
                            <option value="1">${internationalConfig.处理中}</option>
                            <option value="2">${internationalConfig.已完成}</option>
                            <option value="3">${internationalConfig.处理失败}</option>
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
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_go',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">${internationalConfig.清空条件}</a>
</div>

<script type="text/javascript">
    var dataGrid;
    $(function () {
        dataGrid = renderDataGrid('/customTasks/datagrid?' + $('#searchForm').serialize());
    });

    function renderDataGrid(url) {
        return $('#dataGrid').datagrid({
            url: url,
            fit: true,
            fitColumns: true,
            border: false,
            pagination: true,
            idField: 'batchId',
            pageSize: 10,
            pageList: [ 10, 20, 30, 40, 50 ],
            sortName: 'createTime',
            sortOrder: 'desc',
            checkOnSelect: false,
            selectOnCheck: false,
            nowrap: false,
            striped: true,
            rownumbers: true,
            singleSelect: true,
            remoteSort: false,
            method: 'get',
            frozenColumns: [
                []
            ],
            columns: [
                [
                    {
                        field: 'id',
                        title: '${internationalConfig.任务ID}',
                        width: 50,
                        sortable: true
                    },
                    {
                        field: 'type',
                        title: '${internationalConfig.任务类型}',
                        width: 50,
                        sortable: true,
                        formatter: function(value){
                            var dict={"lecard_export":"${internationalConfig.乐卡信息导出}","v2_coupon_export":"${internationalConfig.V2代金券导出}"};
                            return dict[value];
                        }
                    },
                    {
                        field: 'name',
                        title: '${internationalConfig.任务名称}',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'createTime',
                        title: '${internationalConfig.创建时间}',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'finishTime',
                        title: '${internationalConfig.更新时间}',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'status',
                        title: '${internationalConfig.任务状态}',
                        width: 100,
                        sortable: true,
                        formatter: function (value,row,index) {
                            var statuses={0:'${internationalConfig.未处理}',1:'${internationalConfig.处理中}',2:'${internationalConfig.已完成}',3:'${internationalConfig.处理失败}'};
                            return statuses[value];
                        }
                    },<c:if test="${sessionInfo.superMan}">
                    {
                        field: 'operator',
                        title: '${internationalConfig.操作人}',
                        width: 100,
                        sortable: true
                    },</c:if>
                    {
                        field: 'capacity',
                        title: '${internationalConfig.大小}(M)',
                        width: 50
                    },
                    {
                        field: 'loadCount',
                        title: '${internationalConfig.下载次数}',
                        width: 50
                    },
                    {
                        field: 'action',
                        title: '${internationalConfig.操作}',
                        width: 120,
                        formatter: function (value, row, index) {
                            var str = '';
                            if(row.status==2)
                                str += $.formatString('<a href="#" onclick="exportFile({0})">${internationalConfig.下载}<a>',row.id);
                            return str;
                        }
                    }
                ]
            ],
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


    function exportFile(id) {
        var url = '${pageContext.request.contextPath}/customTasks/exportFile?id=' + id;
        location.href = url;
    }

    function searchFun() {
        dataGrid = renderDataGrid('/customTasks/datagrid?' + $('#searchForm').serialize());
    }
    function cleanFun() {
        $('#searchForm input').val('');
        $('#type').val('');
        $('#status').val('-1');
        dataGrid.datagrid('load', {});
    }
</script>
</body>
</html>
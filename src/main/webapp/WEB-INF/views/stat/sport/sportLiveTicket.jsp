<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>影片收入明细</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script src="${pageContext.request.contextPath}/static/lib/select2.full.js" type="text/javascript"></script>
	<link href="${pageContext.request.contextPath}/static/style/select2.min.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript">
    
	    $(function () {
	    	$('#deviceType').select2();
		});
	    
        var dataGrid;
        $(function () {
            parent.$.messager.progress('close');
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/sport/sportLiveTicket/dataGrid');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').datagrid({
                url: url,
                fit: true,
                fitColumns: false,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 30,
                pageList: [30, 60, 90, 120, 150],
                sortName: 'payPrice',
                sortOrder: 'desc',
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                striped: true,
                rownumbers: true,
                singleSelect: true,
                remoteSort: false,
                frozenColumns: [[]],
                columns: [
                    [
                        {
                            field: 'screening',
                            title: '场次ID',
                            width: '250',
                            sortable: true
                        },
                        {
                            field: 'orderName',
                            title: '场次名称',
                            width: '500',
                            sortable: true
                        },
                        {
                            field: 'userCount',
                            title: '购买人数',
                            width: '120',
                            sortable: true
                        },
                        {
                            field: 'payPrice',
                            title: '总金额',
                            width: '120',
                            sortable: true
                        }
                    ]
                ],
                toolbar: '#toolbar',
                onLoadSuccess: function (data) {
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

        function exportExcel() {
            var url = '${pageContext.request.contextPath}/tj/sport/sportLiveTicket/excel?' + $('#searchForm').serialize();
            location.href = url;
        }

        function searchFun() {
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false"
         style="height: 115px; overflow: auto;">
        <form id="searchForm">
            <table class="table table-hover table-condensed">
                <tr>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>终端</td>
                    <td>场次ID</td>
                    <td>场次名称</td>
                </tr>
                <tr>
                    <td>
                        <input id="dateStart" name="dateStart" class="easyui-datebox" data-options="required:true" value="${dateStart}"
                               style="width: 120px; height: 29px"/>
                    </td>
                    <td>
                        <input id="dateEnd" name="dateEnd" class="easyui-datebox" data-options="required:true" value="${dateEnd}"
                               style="width: 120px; height: 29px">
                    </td>
                    <td>
                        <select id="deviceType" name="deviceType" style="width: 150px">
                          <option value="-2">全部</option>
                          <option value="0">0-PC</option>
                          <option value="1">1-Mobile</option>
                          <option value="2">2-TV</option>
                          <option value="3">3-M站</option>
                        </select>
                    </td>
                    <td>
                        <input id="screening" class="easyui-textbox" name="screening" style="width: 120px; height: 29px"/>
                    </td>
                    <td>
                        <input id="orderName" class="easyui-textbox" name="orderName" style="width: 120px; height: 29px"/>
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
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="exportExcel();">导出excel</a>
</div>
</body>
</html>
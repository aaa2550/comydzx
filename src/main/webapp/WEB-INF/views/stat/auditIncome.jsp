<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>月收入查询</title>
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js" type="text/javascript"></script>
	<script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>
       <script type="text/javascript">
        /**
         * 待绑定行数据
         */
        var rows;

        var dataGrid;
        $(function () {
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/orderPaySuccController/auditIncomeQuery');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').datagrid({
                url: url,
                fit: false,
                fitColumns: false,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 20,
                pageList: [ 20, 40, 50 ],
                sortName: 'monthStr',
                sortOrder: 'asc',
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                striped: true,
                rownumbers: true,
                singleSelect: true,
                remoteSort: false,
                frozenColumns: [
                    [
                    ]
                ],
                columns: [
                    [
                        {
                            field: 'monthStr',
                            title: '月份',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'paytypeName',
                            title: '支付渠道',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'money',
                            title: '收入',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'paytype',
                            title: '收入明细',
                            width: 100,
                            formatter: function (value, row, index) {
                                var str = '&nbsp;&nbsp;&nbsp;' + $.formatString('<a onclick="incomeDetail(\'{0}\', \'{1}\');"  title="查看明细">查看明细</a>', row.paytype, row.monthStr);
                                //if(row.paytype == '1' || row.paytype == '2')
                                	return str;
                                //else	return '';
                            }
                        }
                    ]
                ],
                toolbar: '#toolbar',
                onLoadSuccess: function (data) {
                    parent.$.messager.progress('close');
                    rows = data['rows'];
                },
                onRowContextMenu: function (e, rowIndex, rowData) {
                    e.preventDefault();
                    $(this).datagrid('unselectAll');
                    $(this).datagrid('selectRow', rowIndex);
                    $('#menu').menu('show', {
                        left: e.pageX,
                        top: e.pageY
                    });
                },
                queryParams:{
                    paytype:$("#paytype").val()
            	}
            });
        }
        
        function incomeDetail(paytype, month){
        	if(paytype == '1' || paytype == '2'){
	        	var url = '${pageContext.request.contextPath}/tj/orderPaySuccController/auditIncomeDetailExcel?paytype='
					+ paytype + '&month=' + month;
	        	location.href = url;
        	} else {
        		alert("该渠道暂无法提供明细数据,请联系管理!");
        		return ;
        	}
        }

        function searchFun() {
              dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }
        

        $(function () {
            parent.$.messager.progress('close');
        });
        
       
       
    </script>
    

    <style>
        .span {
            padding: 10px;
        }
    </style>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false"
         style="height: 120px; overflow: auto;">
        <form id="searchForm">
            <table class="table table-hover table-condensed">
                <tr>
                    <td>支付渠道</td>
                    <td>月份</td>
                </tr>
                <tr>
                	<td>
                        <select name="paytype" style="width: 160px" id="paytype">
                            <option value="">全部</option>
                            <option value="1" selected>支付宝</option>
                            <option value="2">财付通</option>
                            <option value="3">苹果</option>
                            <option value="4">其它</option>
                        </select>
                    </td>
                    <td>
                        <select name="month" style="width: 160px" id="month">
                            <option value="">2015年度</option>
                            <option value="2015-01">2015-01</option>
                            <option value="2015-02">2015-02</option>
                            <option value="2015-03">2015-03</option>
                            <option value="2015-04">2015-04</option>
                            <option value="2015-05">2015-05</option>
                            <option value="2015-06">2015-06</option>
                            <option value="2015-07">2015-07</option>
                            <option value="2015-08">2015-08</option>
                            <option value="2015-09">2015-09</option>
                            <option value="2015-10">2015-10</option>
                            <option value="2015-11">2015-11</option>
                            <option value="2015-12">2015-12</option>
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
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>
		
</div>


</body>
</html>
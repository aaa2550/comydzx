<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>订单转化率统计</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            parent.$.messager.progress('close');
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/hookstat/suitBuyTrend/dataGrid');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').datagrid({
                url: url,
                fit: false,
                fitColumns: false,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 10,
                pageList: [10, 20, 30, 40, 50],
                sortName: 'date',
                sortOrder: 'asc',
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                striped: true,
                rownumbers: true,
                singleSelect: true,
                remoteSort: false,
                frozenColumns: [
                    []
                ],
                queryParams: $.serializeObject($('#searchForm')),
                columns: [
                    [
                        {
                            field: 'date',
                            title: '日期',
                            width: '120',
                            sortable: true
                        },
                        {
                            field: "pv",
                            title: 'PV',
                            width: '120',
                            sortable: true
                        },
                        {
                            field: "uv",
                            title: 'UV',
                            width: '120',
                            sortable: true
                        },
                        {
                            field: "orderCount",
                            title: '订单数',
                            width: '120',
                            sortable: true
                        },
                        {
                            field: "orderRate",
                            title: '订单转化率',
                            width: '100',
                            sortable: true,
                            formatter: function (value, row, index) {
                                return value + "%";
                            }
                        }
                    ]
                ],
                toolbar: '#toolbar',
                onLoadSuccess: function (data) {
                    parent.$.messager.progress('close');
                    loadChart(data)
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
        	location.href = '${pageContext.request.contextPath}/tj/hookstat/suitBuyTrend/excel?' + $('#searchForm').serialize();
        }

        function searchFun() {
            var s = $("input[name=dateStart]").val();
            var s1 = $("input[name=dateEnd]").val();
            if (Math.abs(((new Date(Date.parse(s1)) - new Date(Date.parse(s))) / 1000 / 60 / 60 / 24)) - 120 < 0) {
                dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
            } else {
                alert("查询时间范围是120天!!!");
            }
        }

        function loadChart(data) {
        	
        	var rows = data['rows'];
        	$('#container').highcharts({
    	        chart: {
    	            zoomType: 'xy'
    	        },
    	        title: {
    	            text: '流量数据和转化率'
    	        },
    	        subtitle: {
    	            
    	        },
    	        credits: {
	   	            enabled:false
	   	        },
    	        xAxis: [{
    	            categories: $.map(rows, function (element) {
                        return element['date'];
                    }),
    	        }],
    	        yAxis: [{ // Primary yAxis
    	            labels: {
    	                format: '{value}',
    	                style: {
    	                    //color: '#89A54E'
    	                }
    	            },
    	            title: {
    	                text: '流量数据',
    	                style: {
    	                    //color: '#89A54E'
    	                }
    	            }
    	        }, { // Secondary yAxis
    	            title: {
    	                text: '转化率(%)',
    	                style: {
    	                    color: '#4572A7'
    	                }
    	            },
    	            labels: {
    	                format: '{value}',
    	                style: {
    	                    color: '#4572A7'
    	                }
    	            },
    	            opposite: true
    	        }],
    	        tooltip: {
    	            shared: true
    	        },
    	        legend: {
    	            layout: 'vertical',
    	            align: 'left',
    	            x: 120,
    	            verticalAlign: 'top',
    	            y: 100,
    	            floating: true,
    	            backgroundColor: '#FFFFFF'
    	        },
    	        series: [{
    	            name: '转化率',
    	            color: '#51A7F9',
    	            type: 'column',
    	            yAxis: 1,
    	            data: $.map(rows, function (element) {
                        return element['orderRate'];
                    }),
    	            tooltip: {
    	                valueSuffix: ' %'
    	            }
    	        },
    			{
    				name: 'PV',
    				color: '#22BA66',
    				type: 'spline',
    				data: $.map(rows, function (element) {
                        return element['pv'];
                    }),
    				tooltip: {
    					valueSuffix: ' 次'
    				}
    			}, {
    				name: 'UV',
    				color: '#FFCB30',
    				type: 'spline',
    				data: $.map(rows, function (element) {
                        return element['uv'];
                    }),
    				tooltip: {
    					valueSuffix: ' 次'
    				}
    			}, {
    				name: '订单数',
    				color: '#E741C6',
    				type: 'spline',
    				data: $.map(rows, function (element) {
                        return element['orderCount'];
                    }),
    				tooltip: {
    					valueSuffix: ' 个'
    				}
    			}
    			]
    	    });
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false"
         style="height: 120px; overflow: auto;">
        <form id="searchForm">
            <table class="table table-hover table-condensed">
                <tr>
                    <td>开始时间</td>
                    <td>结束时间</td>
                    <td>终端</td>
                    <td>会员类型</td>
                    <td>套餐</td>
                </tr>
                <tr>
                    <td>
                        <input name="dateStart" class="easyui-datebox" data-options="required:true" value="${dateStart}" style="width: 160px; height: 29px"/>
                    </td>

                    <td>
                        <input name="dateEnd" class="easyui-datebox" data-options="required:true" value="${dateEnd}" style="width: 160px; height: 29px">
                    </td>
                    <td>
                        <select name="terminal" style="width: 160px">
                            <c:forEach items="${terminals}" var = "terminal">
                            	<option value="${terminal.key}">${terminal.value}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                    	<select name="viptype" style="width: 160px">
                            <c:forEach items="${viptypes}" var = "viptype">
                            	<option value="${viptype.key}">${viptype.value}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                    	<select name="monthlyPackage" style="width: 160px">
                            <c:forEach items="${monthlyPackages}" var = "monthlyPackage">
                            	<option value="${monthlyPackage.key}">${monthlyPackage.value}</option>
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
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="exportExcel();">导出excel</a>
    <div id="container" style="min-width: 310px; height: 300px; margin: 0 auto; overflow: auto"></div>
</div>
</body>
</html>
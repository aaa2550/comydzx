<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>支付成功率查询</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>
<script type="text/javascript">
<m:auth uri="/hades/payment/view.json">  $.canView = true;</m:auth>
	var dataGrid;
	$(function () {
	    dataGrid = renderDataGrid('${pageContext.request.contextPath}/hades/payment/payment_succ.json');
	});

	function renderDataGrid(url) {
	    return $('#dataGrid').datagrid({
	        url: url,
	        fit: true,
	        fitColumns: false,
	        border: false,
	        pagination: true,
	        idField: 'id',
	        pageSize: 10,
	        pageList: [ 10, 20, 30, 40, 50 ],
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
	            [
	            ]
	        ],
	        columns: [
	            [
					{
					    field: 'date',
					    title: '日期',
					    width: '150',
					    sortable: true
					},
					{
	                    field: 'totalOrders',
	                    title: '总订单数',
	                    width: '150',
	                    sortable: true
	                },
	                {
	                    field: 'succOrders',
	                    title: '支付成功数',
	                    width: '150',
	                    sortable: true
	                },
					{
	                    field: "succRate",
	                    title: '支付成功率',
	                    width: '150',
	                    sortable: true,
	                    formatter: function (value, row, index) {
	                        return $.formatString('{0}%', row.succRate);
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

	function searchFun() {
		var s = $("input[name=beginDate]").val();
	    var s1 = $("input[name=endDate]").val();
	    dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
	}
	function cleanFun() {
	    $('#searchForm input').val('');
	    dataGrid.datagrid('load', {});
	}


	$(function () {
	    parent.$.messager.progress('close');
	});


	function loadChart(data) {
	    var rows = data['rows']
	    $('#container').highcharts({
	        title: {
	            text: '支付成功率'
	        },
	        legend: {
	            layout: 'vertical',
	            align: 'right',
	            verticalAlign: 'middle',
	            width: 100,
	            borderWidth: 0
	        },
	        xAxis: {
	        	categories: $.map(rows, function (element) {
	                return element['date'];
	            }),
	            title: {
	                text: '日期'
	            }
	        },
	        /*tooltip: {
	        	pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.y:,.2f}%</b><br/>',
	            crosshairs: true,
	            shared: true
	        },*/
	        yAxis: {
	            title: {
	                text: '成功率(%)'
	            },
	            labels: {
	                formatter: function () {
	                    return this.value
	                }
	            },
	            plotLines: [
	                {
	                    value: 0,
	                    width: 1,
	                    color: '#808080'
	                }
	            ],
	            min: Math.min.apply(null, $.map(rows, function (element) {
	                return element['succRate'];
	            })),
	            max: Math.max.apply(null, $.map(rows, function (element) {
	                return element['succRate'];
	            })) 
	        },
	        series: [                 
			        {
			            type: 'line',
			            name: '支付成功率',
			            data: $.map(rows, function (element) {
		                    return element['succRate'];
		                }),
			            marker: {
			                lineWidth: 2,
			                lineColor: Highcharts.getOptions().colors[3],
			                fillColor: 'white'
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
                    <td>起始时间</td>
                    <td>截止时间</td>
                    <td>支付渠道</td>
                    <td>业务类型</td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <input name="start" class="easyui-datebox" data-options="required:true" value="${start}" style="width: 160px; height: 29px"/>
                    </td>

                    <td>
                        <input name="end" class="easyui-datebox" data-options="required:true" value="${end}" style="width: 160px; height: 29px">
                    </td>
                    <td>
                    	<select name="paymentType" style="width: 160px" id="one">
                    		<option value="">全部</option>
                            <option value="ALI">阿里</option>
                            <option value="WX">微信</option>
                            <option value="DUMMY">0元购</option>
                        </select>
                    </td>
                    <td>
                    	<select name="category" style="width: 160px">
                    		<option value="">全部</option>
                            <option value="theme">主题</option>
                            <option value="game">游戏</option>
                        </select>
                    </td>
                    <td></td>
                    <td></td>
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
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a><a
        href="javascript:void(0);" class="easyui-linkbutton"
        data-options="iconCls:'brick_delete',plain:true"
        onclick="cleanFun();">清空条件</a>

     <div id="container" style="min-width: 310px; height: 300px; margin: 0 auto; overflow: auto"></div> 
</div>


</body>
</html>
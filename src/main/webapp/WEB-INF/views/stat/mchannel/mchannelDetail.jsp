<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>会员收入</title>
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
        //	var id = $("#cid").val() ;
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/mobileChannel/mdetail/dataGrid');
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        });

        function renderDataGrid(url) {
            return $('#dataGrid').datagrid({
                url: url,
                fit: true,
                fitColumns: false,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 20,
                pageList: [ 10, 20, 30, 40, 50 ],
                sortName: 'statDate',
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
						    field: 'statDate',
						    title: '日期',
						    width: 100,
						    sortable: true
						},
						{
						    field: 'channelName',
						    title: '功能项',
						    width: 200,
						    sortable: true
						},
                        {
                            field: 'pv',
                            title: '次数',
                            width: 80,
                            sortable: true
                        },{
                            field: 'uv',
                            title: '人数',
                            width: 80,
                            sortable: true
                        },
                        {
                            field: 'newOrderCnt',
                            title: '新增订单数',
                            width: 80,
                            sortable: true
                        },
                        {
                            field: 'oldOrderCnt', 
                            title: '续费订单数',
                            width: 80,
                            sortable: true
                        },
                        {
                            field: 'newMoney',
                            title: '新增收入',
                            width: 80,
                            sortable: true
                        },
                        {
                            field: 'oldMoney',
                            title: '续费金额',
                            width: 80,
                            sortable: true
                        },
                        {
                            field: 'totalIncome',
                            title: '总收入',
                            width: 80,
                            sortable: true
                        },
                        {
                            field: 'newRate',
                            title: '新增转化率',
                            width: 80,
                            formatter: function (value, row, index) {
                                return $.formatString('{0}%', row.newRate);
                            },
                            sortable: true
                        },
                        {
                            field: 'allRate',
                            title: '总转化率',
                            width: 80,
                            formatter: function (value, row, index) {
                                return $.formatString('{0}%', row.allRate);
                            } ,
                            sortable: true
                        },
                        {
                            field: 'cpmIncome',
                            title: '千人收入',
                            width: 80,
                            sortable: true
                        },
                        {
                            field: 'actCodeName',
                            title: '动作类型',
                            width: 80,
                            sortable: true
                        },
                        {
                            field: 'actLoc',
                            title: '渠道代号',
                            width: 300,
                            sortable: true
                        }
                    ]
                ],
                toolbar: '#toolbar',
                onLoadSuccess: function (data) {
                    parent.$.messager.progress('close');
                    rows = data['rows'];
                    loadChart(data) ;
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
        	var s = $("input[name=startDate]").val();
            var s1 = $("input[name=endDate]").val();
            if(Math.abs(((new Date(Date.parse(s1)) - new Date(Date.parse(s)))/1000/60/60/24)) - 30 < 0){
                dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        	}else{
        	       alert("查询时间范围是30天!!!");
        	}
            // dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        } 
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }
		
        function exportExcel() {
        	var startDate = $('#startDate').datetimebox("getValue");
        	var endDate = $('#endDate').datetimebox("getValue");;
        	var id = $('#cid').val();
        	var url = '${pageContext.request.contextPath}/tj/mobileChannel/mdetail/excel?id='+id+'&startDate='
        			+ startDate + '&endDate='+ endDate;
        	location.href = url;
        }
        
        $(function () {
            parent.$.messager.progress('close');
        });
        
        function loadChart(data) {
	   		var rows = data['rows'] ;
	   	    $('#container').highcharts({
	   	    	chart: {
	   	            //type: 'column'
	   	        },
	   	        title: {
	   	            text: '移动端渠道转化率',
	   	            x: -20 //center
	   	        },
	   	        xAxis: {
	   	        	categories: $.map(rows, function (element) {
	   	                return element['statDate'] ;
	   	            })
	   	        },
	   	        yAxis: {
	   	            title: {
	   	                text: ''
	   	            },
	   	            plotLines: [{
	   	                value: 0,
	   	                width: 1,
	   	                color: '#808080'
	   	            }]
	   	        },
	   	        credits: {
	   	            enabled:false
	   	        },
	   	        tooltip: {
	   	         	valueSuffix: '%' ,
	   	          //  valueSuffix: '（访问次数）' ,
	   	            pointFormat: '{series.name}: <b>{point.y}</b><br/>',
	   	            shared: true
	   	        },
	   			
	   	        legend: {
	   	            layout: 'vertical',
	   	            align: 'right',
	   	            verticalAlign: 'middle',
	   	            borderWidth: 1 ,
	   	            borderRadius:5
	   	        },
	   	        series: [{
	   	        	//color:'#00EEEE',
	   	        	//type: 'column',
	   	             name: '移动端渠道转化率',
	   	             data: $.map(rows, function (element) {
	   	            		//console.info(element) ;
							return Number(element['allRate']) ; 
	   	                })
	   	        },]
	   	    });
	   	}

        
    </script>
    
    <style>
        .span {
            padding: 10px;
        }
    </style>
    
</head>

<body>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
	<div data-options="region:'north',title:'查询条件',border:false"
         style="height: 130px; overflow: auto;">
        <form id="searchForm">
        	
            <table class="table table-hover table-condensed">
                <tr>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                  
                        <input name="startDate" id="startDate" class="easyui-datebox" data-options="required:true" value="${startDate}" style="width: 160px; height: 29px"/>
                    </td>

                    <td>
                        <input name="endDate" id="endDate" class="easyui-datebox" data-options="required:true" value="${endDate}" style="width: 160px; height: 29px">
                    </td>
                    <td>  <input name="id" value="${id}" type="hidden" id="cid" /></td>
                    <td></td>
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
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>
        
        <a href="javascript:void(0);" class="easyui-linkbutton"
		data-options="iconCls:'brick_delete',plain:true"
		onclick="exportExcel();">导出excel</a>
        <div id="container" style="min-width: 310px; height: 300px; margin: 0 auto; overflow: auto"></div>
</div>


</body>
</html>
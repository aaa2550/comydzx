<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>${internationalConfig.日支付实时统计}</title>
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
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/jtStatController/payStatQueryList');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').datagrid({
                url: url,
                fit: false,
                fitColumns: false,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 50,
                pageList: [  50,100 ],
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
                            field: 'type',
                            title: '${internationalConfig.支付系统}',
                            width: 100,
                            sortable: false,
                            formatter: function (value, row, index) {
                            	if(row.type == 1){
                            		return "${internationalConfig.旧支付系统}";
                            	} else if(row.type == 2){
                                	return "${internationalConfig.新支付系统}";
                            	} else if(row.type == 3){
                                	return "boss${internationalConfig.新支付系统}";
                            	}
                            }
                        },
                        {
                            field: 'companyName',
                            title: '${internationalConfig.商户名称}',
                            width: 150,
                            sortable: false
                        },
                        {
                            field: 'payName',
                            title: '${internationalConfig.支付方式}',
                            width: 200,
                            sortable: false
                        },
                        {
                            field: 'orders',
                            title: '${internationalConfig.支付订单数}',
                            width: 100,
                            sortable: false
                        },
                        {
                            field: 'money',
                            title: '${internationalConfig.订单金额}',
                            width: 100,
                            sortable: false
                        },
                        {
                            field: 'failOrders',
                            title: '${internationalConfig.未支付订单数}',
                            width: 100,
                            sortable: false
                        },
                        {
                            field: 'rate',
                            title: '${internationalConfig.支付成功率}',
                            width: 100,
                            sortable: false,
                            formatter: function (value, row, index) {
                                return $.formatString('{0}%', row.rate);
                            }
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

       
        function loadChart(data) {
	   		var temp = data['rows'].slice(0); //深度拷贝
	   		var total = temp.pop(); //删除并返回最后一个元素
	   		var rows = new Array();
	   		for(var i=0;i<15&&i<temp.length;i++){
	   			rows.push(temp[i]);
	   		} 
	   		$('#container').highcharts({
	   	        chart: {
	   	            zoomType: 'xy'
	   	        },
	   	        title: {
	   	            text: '${internationalConfig.支付数据实时统计}'
	   	        },
	   	        subtitle: {
	   	            
	   	        },
	   	        xAxis: {
	   	        	categories: $.map(rows, function (element) {
	   	                return element['payName'] ;
	   	            })
	   	        },
	   	        yAxis: [{ // Primary yAxis
	   	            gridLineWidth: 0,
	   	            title: {
	   	                text: '${internationalConfig.支付订单金额}',
	   	                style: {
	   	                     color: '#4572A7',
	   	                }
	   	            },
	   	            labels: {
	   	                format: '{value}',
	   	                style: {
	   	                     color: '#4572A7',
	   	                }
	   	            },
	   	            opposite: true

	   	        }, { // Secondary yAxis
	   	            title: {
	   	                text: '${internationalConfig.支付成功率}',
	   	                style: {
	   	                    color: '#AA4643',
	   	                }
	   	            },
	   	            labels: {
	   	                format: '{value}%',
	   	                style: {
	   	                    color: '#AA4643',
	   	                }
	   	            },
	   	            opposite: true
	   	        }, { // Tertiary yAxis
	   	            labels: {
	   	                format: '{value}',
	   	                style: {
	   	                   color: '#89A54E',
	   	                }
	   	            },
	   	            title: {
	   	                text: '${internationalConfig.支付订单数}',
	   	                style: {
	   	                    color: '#89A54E',
	   	                }
	   	            }
	   	        }],
	   	        tooltip: {
	   	                
	   	            shared: true
	   	        },
	   	        labels: {                                                                                                            
	   	        }, 
	   	        legend: {

	   	        },
	   	        series: [{
	   	            name: '${internationalConfig.支付订单数}',
	   	            color: '#89A54E',
	   	            yAxis: 2,
	   	            type: 'column',    
	   	            data: $.map(rows, function (element) {
	                	  return Number(element['orders']) ; 
	                   })

	   	        }, {
	   	            name: '${internationalConfig.支付订单金额}',
	   	            color: '#4572A7',
	   	            type: 'spline',
	   	            data: $.map(rows, function (element) {
	                	  return Number(element['money']) ; 
	                   }),
	   	            tooltip: {
	   	                valueSuffix: ''
	   	            }

	   	        }, {
	   	            name: '${internationalConfig.支付成功率}',
	   	            color: '#AA4643',
	   	            type: 'spline',
	   	            yAxis: 1,
	   	            data: $.map(rows, function (element) {
	                	  return Number(element['rate']) ; 
	                   }),
	   	            marker: {
	   	                enabled: true
	   	            },
	   	            dashStyle: 'shortdot',
	   	            tooltip: {
	   	                valueSuffix: '%'
	   	            }
	   	        }, {                                                              
	   	            type: 'pie',                                                  
	   	            name: '${internationalConfig.占比}',                                    
	   	            data: [{                                                      
	   	                name: '${internationalConfig.新支付系统}',                                             
	   	                y: 100-total['newOldRate'],                                                    
	   	                color: Highcharts.getOptions().colors[3] // Jane's color  
	   	            }, {                                                          
	   	                name: '${internationalConfig.旧支付系统}',                                             
	   	                y: total['newOldRate'],                                                    
	   	                color: Highcharts.getOptions().colors[4] // John's color  
	   	            }],                                                           
	   	            center: [750, 60],                                            
	   	            size: 100,                                                    
	   	            showInLegend: false,                                          
	   	            dataLabels: {                                                 
	   	                enabled: true                                            
	   	            }                                                             
	   	        }]
	   	    });
	   	}


        $(function () {
            parent.$.messager.progress('close');
        });

        function loadCompanyName() {
            var systemSelect = $("#systemType");
            var systemType = systemSelect.val();
            var companySelect = $("#companyId");

            $.getJSON("${pageContext.request.contextPath}/tj/jtStatController/queryCompanyName", {systemType: systemType}, function (modules) {
                var options = "";
                modules = modules['rows'];
                var size = modules.length;
                if (size > 0) {
                	options += "<option value=-2>${internationalConfig.全部}</option>";
                    for (var i = 0; i < size; i++) {
                        var module = modules[i];
                        options += "<option value=" + module['ID'] + ">" + module['NAME'] + "</option>";
                    }
                    companySelect.html(options);
                } else {
                	companySelect.html(options);
                	if(systemType == '-2'){
		            	options = "";
		            	options += "<option value=-2>${internationalConfig.全部}</option>";
		            	options += "<option value=1,C001>${internationalConfig.乐视网}</option>";
		            	options += "<option value=99,C003,C002,C062,C063>${internationalConfig.乐视商城}</option>";
		            	options += "<option value=26,C019>${internationalConfig.乐视移动}</option>";
		            	companySelect.html(options);
		            	
		            }

                }
            });
            
            
        }
        
        function searchFun() {
        	var s = $("#begin").val();
		     var s1 = $("#end").val(); 
		     if(Math.abs(((new Date(Date.parse(s1.substring(0,10))) - new Date(Date.parse(s.substring(0,10))))/1000/61/60/24)) - 61 < 0){
              dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
		     }else{
		       alert("${internationalConfig.查询时间范围是61天}");
		     }
        }
        
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }
        

    </script>
    
    <style>
        .span {
            padding: 10px;
        }
    </style>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'">
        <form id="searchForm">
            <table class="table table-hover table-condensed">
                <tr>
                    <td>${internationalConfig.开始日期}</td>
                    <td>${internationalConfig.结束日期}</td>
                    <td>${internationalConfig.支付系统}</td>
                    <td>${internationalConfig.商户名称}</td>
                </tr>
                <tr>
                    <td>
                        <input name="beginDate" id="begin" class="easyui-datetimebox" validType="TimeCheck" invalidMessage="${internationalConfig.查询时间范围是61天}" data-options="required:true" value="${startTime}" style="width: 160px; height: 29px"/>
                    </td>

                    <td>
                        <input name="endDate" id="end" class="easyui-datetimebox" validType="TimeCheck" invalidMessage="${internationalConfig.查询时间范围是61天}" data-options="required:true" value="${endTime}" style="width: 160px; height: 29px">
                    </td>
                    <td>
                        <select name="systemType" id="systemType" style="width: 160px" id="one" onchange="loadCompanyName()">
                            <option value="-2">${internationalConfig.全部}</option>
                            <option value="1">${internationalConfig.旧支付系统}</option>
                            <option value="2">${internationalConfig.新支付系统}</option>
                            <option value="3">boss${internationalConfig.新支付系统}</option>
                        </select>
                    </td>
                    <td><select name="companyId" style="width: 140px" id="companyId" >
							<option value="-2" selected>${internationalConfig.全部}</option>
							<option value="1,C001">${internationalConfig.乐视网}</option>
			            	<option value="99,C003,C002,C062,C063">${internationalConfig.乐视商城}</option>
			            	<option value="26,C019">${internationalConfig.乐视移动}</option>
						</select></td>
                </tr>
            </table>
        </form>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>


</div>
<div id="toolbar" style="display: none;">
	<div id="container" style="min-width: 800px; height: 450px; margin: 0 auto; overflow: auto"></div>
	<a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
</div>


</body>
</html>
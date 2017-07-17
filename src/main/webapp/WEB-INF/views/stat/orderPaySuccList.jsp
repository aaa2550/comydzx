<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<html>
<head>
<title>订单成功率查询</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>

<script type="text/javascript">
	var dataGrid;
	
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '${pageContext.request.contextPath}/tj/orderPaySuccController/packageList',
							fit : false,
							fitColumns : true,
							border : false,
							pagination : true,
							idField : 'id',
							pageSize : 50,
							pageList : [ 10, 20, 30, 40, 50 ],
							sortName: 'date',
					        sortOrder: 'desc',
							checkOnSelect : false,
							selectOnCheck : false,
							nowrap : false,
							striped : true,
							rownumbers : true,
							singleSelect : true,
							frozenColumns : [ [ {
								field: 'id',
			                    title: '编号',
			                    width: 150,
			                    hidden: true
							} ] ],
							columns : [ [
									{
										field: 'date',
					                    title: '日期',
					                    width: 120,
					                    sortable: true
									},
									{
										field : 'succRate',
										title : '总支付成功率',
										width : 120,
										sortable : true,
									},
									{
										field : 'superSuccRate',
										title : '全屏影视成功率',
										width : 130,
										sortable : true
									},
									{
										field : 'generalSuccRate',
										title : '移动影视成功率',
										width : 130,
										sortable : true
									},
									{
										field : 'singleSuccRate',
										title : '单点成功率',
										width : 120,
										sortable : true
									},
									{
										field : 'upSuccRate',
										title : '升级成功率',
										width : 120,
										sortable : true
									},
									{
										field : 'sum',
										title : '订单总数',
										width : 120,
										sortable : true
									},
									{
										field : 'superSum',
										title : '全屏影视会员订单数',
										width : 150,
										sortable : true
									},
									{
										field : 'generalSum',
										title : '移动影视会员订单数',
										width : 150,
										sortable : true
									},
									{
										field : 'singleSum',
										title : '单点订单数',
										width : 120,
										sortable : true
									},
									{
										field : 'upSum',
										title : '升级订单数',
										width : 120,
										sortable : true
									},
									{
										field : 'succSum',
										title : '成功订单总数',
										width : 120,
										sortable : true
									},
									{
										field : 'succSuperSum',
										title : '全屏影视订单成功数',
										width : 150,
										sortable : true
									},
									{
										field : 'succGeneralSum',
										title : '移动影视订单成功数',
										width : 150,
										sortable : true
									},
									{
										field : 'succSingleSum',
										title : '单点成功订单数',
										width : 150,
										sortable : true
									},
									{
										field : 'succUpSum',
										title : '升级成功订单数',
										width : 150,
										sortable : true
									}
							] ],
							toolbar : '#toolbar',
							onLoadSuccess : function(data) {
								//console.info(data) ;
								$('#searchForm table').show();
								parent.$.messager.progress('close');
								loadChart(data) 
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
	});
	
	//终端-联动设备
    $(function(){
    	$("#one").change(function(){
    			var m=$(this).children('option:selected').val();
    			if(m==130){ //mobile
    				$("#two").empty();
    				$("#two").append("<option value='-2' >全部</option>");
    				$("#two").append("<option value='47'>android</option>");
    				$("#two").append("<option value='42'>iphone</option>");
    				$("#two").append("<option value='41'>ipad</option>");
    				$("#three").empty();
     				$("#three").append("<option value='-2' >全部</option>");
     				$("#four").empty();
     				$("#four").append("<option value='-2' >全部</option>");
    			 }else if(m==111){ //tv
    				$("#two").empty();
     				$("#two").append("<option value='-2' >全部</option>");
     				$("#two").append("<option value='200'>超级电视</option>");
     				$("#two").append("<option value='201'>乐视盒子</option>");
     				$("#two").append("<option value='202'>第三方电视</option>");
     				$("#three").empty();
     				$("#three").append("<option value='-2' >全部</option>");
     				$("#four").empty();
     				$("#four").append("<option value='-2' >全部</option>");
    			 }else{
    				$("#two").empty();
     				$("#two").append("<option value='-2' >全部</option>");
     				$("#three").empty();
     				$("#three").append("<option value='-2' >全部</option>");
     				$("#four").empty();
     				$("#four").append("<option value='-2' >全部</option>");
    			 }
    			
    		});
          }
    	);
	
	//设备-联动品牌
	$(function(){
    	$("#two").change(function(){
    			var m=$(this).children('option:selected').val();
    			if(m==200){ //超级电视
    				$("#three").empty();
    				$("#three").append("<option value='300'>乐视</option>");
    				$("#four").empty();
    				$("#four").append("<option value='-3' >全部</option>");
    				$("#four").append("<option value='52'>s40</option>");
    				$("#four").append("<option value='51'>s50</option>");
    				$("#four").append("<option value='50'>x60</option>");
    				$("#four").append("<option value='57'>c70</option>");
    				$("#four").append("<option value='58'>s50aire</option>");
    			 }else if(m==201){//乐视盒子
    				$("#three").empty();
     				$("#three").append("<option value='301'>乐视</option>");
     				$("#four").empty();
     				$("#four").append("<option value='-4' >全部</option>");
     				$("#four").append("<option value='53'>S10</option>");
     				$("#four").append("<option value='54'>ST1</option>");
     				$("#four").append("<option value='55'>C1</option>");
     				$("#four").append("<option value='56'>C1S</option>");
     				
    			 }else if(m==202){ //第三方电视
    				$("#three").empty();
     				$("#three").append("<option value='-5' >全部</option>");
     				$("#three").append("<option value='0'>海信</option>");
     				$("#three").append("<option value='1'>海尔</option>");
     				$("#three").append("<option value='3'>创维</option>");
     				$("#three").append("<option value='4'>康佳</option>");
     				$("#three").append("<option value='5'>清华同方</option>");
     				$("#three").append("<option value='8'>长虹</option>");
     				$("#three").append("<option value='9'>panda</option>");
     				$("#three").append("<option value='10'>小米</option>");
     				$("#four").empty();
     				$("#four").append("<option value='-2' >全部</option>");
    			 }else{
    				$("#three").empty();
     				$("#three").append("<option value='-2' >全部</option>");
     				$("#four").empty();
     				$("#four").append("<option value='-2' >全部</option>");
    			 }
    			
    		});
          }
    	);
    
    //支付通道联动
    $(function(){
    	$("#orderone").change(function(){
    			var m=$(this).children('option:selected').val();
    			if(m==2){
    				$("#ordertwo").empty();
    				$("#ordertwo").append("<option value='-2' >全部</option>");
    				<c:forEach items="${payTypeList}" var="var">
    				$("#ordertwo").append("<option value='${var.type}' >${var.description}</option>");
                    </c:forEach>

    			 }else{
    				$("#ordertwo").empty();
     				$("#ordertwo").append("<option value='-2' >全部</option>");
    			 }
    			
    		});
          }
    	);
	
	function searchFun() {
		dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
	}
	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}
	

	function loadChart(data) {
		 var rows = data['rows'] ;
	    $('#container').highcharts({
	        title: {
	            text: '订单支付成功率趋势图',
	            x: -20 //center
	        },
	        xAxis: {
	        	//maxTickLength: 10,
	           // minorTickWidth: 1 ,
	            //minRange: 10 ,
	            //minorTickInterval:'auto' ,
	            //tickInterval:rows.length/7,
	            // type: 'datetime', 
	           // labels: { 
          		//   step:rows.length/7	
          		  // x:45 
                   /* formatter: function() { 
					return  Highcharts.dateFormat('%Y-%m-%d', this.value); 
					}  */
	           // },
	        	categories: $.map(rows, function (element) {
	                return element['date'] ;
	            })
	        },
	        yAxis: {
	            title: {
	                text: '转化率(%)'
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
	            crosshairs: true ,
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
	            name: '总支付成功率',
	             data: $.map(rows, function (element) {
	            	 
	            		//console.info(element['singleSum']);
	            		//console.info(element) ;
	            		var succPerTemp= Number(element['succSum']/element['sum']*100) ;
	            		//var succPer = succPerTemp.toFixed(2) ;
	                	return Number(succPerTemp.toFixed(2))
	                })
	            //data:['7.0', '6.9', '9.5', '14.5', '18.2', '21.5', '25.2']
	        },
	        {
	        name: '全屏影视会员支付成功率',
            data: $.map(rows, function (element) {
           	 
           		//console.info(element['singleSum']);
           		var succPerTemp= Number(element['succSuperSum']/element['superSum']*100) ;
           		//var succPer = succPerTemp.toFixed(2) ;
               	return Number(succPerTemp.toFixed(2))
               })
           //data:['7.0', '6.9', '9.5', '14.5', '18.2', '21.5', '25.2']
       	   },
       		{
   	        name: '移动影视会员支付成功率',
               data: $.map(rows, function (element) {
              	 
              		//console.info(element['singleSum']);
              		var succPerTemp= Number(element['succGeneralSum']/element['generalSum']*100) ;
              		//var succPer = succPerTemp.toFixed(2) ;
                  	return Number(succPerTemp.toFixed(2))
                  })
              //data:['7.0', '6.9', '9.5', '14.5', '18.2', '21.5', '25.2']
          	   },
          	 {
          	        name: '单点支付成功率',
                      data: $.map(rows, function (element) {
                     	 
                     		//console.info(element['singleSum']);
                     		var succPerTemp= Number(element['succSingleSum']/element['singleSum']*100) ;
                     		//var succPer = succPerTemp.toFixed(2) ;
                         	return Number(succPerTemp.toFixed(2))
                         })
                     //data:['7.0', '6.9', '9.5', '14.5', '18.2', '21.5', '25.2']
                },
               /*  {
        	        name: '升级支付成功率',
                    data: $.map(rows, function (element) {
                   	 
                   		//console.info(element['singleSum']);
                   		var succPerTemp= Number(element['succUpSum']/element['upSum']*100) ;
                   		//var succPer = succPerTemp.toFixed(2) ;
                       	return Number(succPerTemp.toFixed(2))
                       })
                   //data:['7.0', '6.9', '9.5', '14.5', '18.2', '21.5', '25.2']
                }, */
	        ]
	        
	        /* data: $.map(rows, function (element) {
            	console.info(element['succRate']);
                return element['succRate']
            }) */
	    });
	}
		
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'查询条件',border:false"
			style="height: 130px; overflow: auto;">
			<form id="searchForm">
				<table class="table table-hover table-condensed">
				    <tr>
	                    <td>开始日期：</td>
	                    <td>结束日期：</td>
	                    <td>终端：</td>
	                    <td>设备</td>
	                    <td>品牌：</td>
	                    <td>型号：</td>
	                    <td>支付方式：</td>
	                    <td>支付渠道：</td>
	                </tr>
					<tr>
						<td><input id="begin" name="beginDate" value="${start}"
							class="easyui-datebox" style="width: 140px; height: 29px"></input></td>
						<td><input id="end" name="endDate" value="${end}"
							class="easyui-datebox" style="width: 140px; height: 29px"></input></td>
						<td><select name="terminal" style="width: 140px;" id="one">
								<option value="-2" selected>全部</option>
								<option value="112">PC</option>
								<option value="111">TV</option>
								<option value="130">Mobile</option>
								<option value="113">M站</option>
						</select>
						</td>
						<td><select name="terminal2" style="width: 140px;" id="two">
								<option value="-2" selected>全部</option>
						</select>
						</td>
						<td><select name="brand" style="width: 140px;" id="three">
								<option value="-2" selected>全部</option>
						</select>
						</td>
						<td><select name="model" style="width: 140px;" id="four">
								<option value="-2" selected>全部</option>
						</select>
						</td>
						<td><select name="orderpaytype" style="width: 140px" id="orderone">
                            <option value="-2">全部</option>
                            <option value="-1">免费</option>
                            <option value="0">兑换码</option>
                            <option value="1">乐点</option>
                            <option value="2"  selected>现金</option>
                        </select>
                        <td><select name="orderpaytype1" style="width: 140px" id="ordertwo">
                            <option value="-2">全部</option>
                          <c:forEach items="${payTypeList}" var="var">
        				    <option value='${var.type}' >${var.description}</option>
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
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a><a
			href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_delete',plain:true"
			onclick="cleanFun();">清空条件</a>
		<div id="container" style="min-width: 310px; height: 300px; margin: 0 auto; overflow: auto"></div> 
	</div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
<title>boss会员指标-周期内活跃用户数</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<link href="${pageContext.request.contextPath}/static/style/js/stat/style.css" rel="stylesheet" type="text/css" />

<script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>

<style type="text/css">
.f_sj{ width:95%; height:66px;padding-left: 10px}
.f_sj table{ background-color:#ddd; width:100%; height:66px;}
.f_sj table tr td{ background-color:#f1f1f1; width:20%; height:46px; text-align:left; padding:8px;border: 1px solid #ccc}

.ks{ background:url(${pageContext.request.contextPath}/static/style/images/stat/png_tips_02.png) no-repeat 0 0;z-index:10;width:185px; height:51px; overflow:hidden; color:#b4923b; padding:10px; position:absolute; top:166px; left:3%; z-index:999;}
	#fd2{ left:25%;}
	#fd3{ left:45%;}
	#fd4{ left:63%}
	#fd5{ left:84%;}
	
	.panel-fit, .panel-fit body {
		height: 100%;
		margin: 0;
		padding: 0;
		border: 0;
		overflow: auto;
	}
	.panel-noscroll {
	 overflow: auto; 
	}
	.ulli ul{
		list-style: none ;
	} 
	.ulli li {
		float: left ;
	}
</style>


<script type="text/javascript">

	 function fixWidthTable(percent){  
	    return getWidth(1) * percent;  
	}  

	function getWidth(percent){  
		return $(window).width() * percent;  
	}  
	
	/**
	 * 待绑定行数据
	 */
	var rows;
	
	var dataGrid;
	$(function () {
		 $(window).resize(function(){  
			    //alert("change....");  
				 $("#dataGrid").datagrid("resize",{width:getWidth(1)}); 
		 });
	    dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/statzb/vip_retention_user/dataGrid');
		// dataGrid = renderDataGrid('${pageContext.request.contextPath}/celery/stat/data/stat-zhibiao-vipday-vip_activity_user?method=vvvv');
	});
	
	function renderDataGrid(url) {
	      return $('#dataGrid').datagrid({
	        url: url,
	        //fit: true,
	        //fitColumns: true,  
	        width: getWidth(1),  
            height: 'auto',  
	        fitColumns: true,
	        border: false,
	        pagination: true,
	        idField: 'createDate',
	        pageSize: 15,
	        pageList: [ 15, 30, 45 ],
	        sortName: 'createDate',
	        sortOrder: 'asc',
	      //  fit:true ,
	    //    width:auto ,             
	     //   height:auto,    
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
					    field: 'createDate',
					    title: '日期',
					    width:fixWidthTable(0.125) ,
				//	    width: 200,
					    sortable: true
					},
	                {
	                    field: 'd_00012',
	                    title: '7日会员活跃基数',
	                    width:fixWidthTable(0.125) ,
	               //     width: 200,
	                    sortable: false
	                },{
	                    field: 'd_00013',
	                    title: '15日会员活跃基数',
	                    width:fixWidthTable(0.125) ,
	             //       width: 200,
	                    sortable: false
	                },
	                {
	                    field: 'd_00014',
	                    title: '30日会员活跃基数',
	                    width:fixWidthTable(0.125) ,
	              //      width: 200,
	                    sortable: false
	                }
	            ]
	        ],
	        toolbar: '#toolbar',
	        onLoadSuccess: function (data) {
	            parent.$.messager.progress('close') ;
	            rows = data['rows'];
	            console.log(rows) ;
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
	     dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
	} 
	function cleanFun() {
	    $('#searchForm input').val('');
	    dataGrid.datagrid('load', {});
	}
	
	$(function () {
	    parent.$.messager.progress('close');
	});
	
	function exportExcel() {
    	var sdate = $('#sdate').datetimebox("getValue");
    	var edate = $('#edate').datetimebox("getValue");
    	var isnew = $('#isnew').val();
    	var paytype = $("input[name='paytype']:checked").val();
    	var terminal =  $("#terminalid").val();
    	var device =  $("#deviceid").val();
    	//var expire =  $("input[name='expire']:checked").val();
    	//var zhibiao =  $("#zhibiaoid").val();
    	var url = '${pageContext.request.contextPath}/tj/statzb/vip_retention_user/export?paytype='+paytype+'&sdate='
    			+ sdate + '&edate='+ edate + '&terminal='+ terminal +'&device=' + device +'&isnew='+ isnew ;
    	location.href = url;
    }
 
</script>

<script type="text/javascript">
	function loadChart(data) {
		 Highcharts.setOptions({
    		 colors: ['#5CACEE','#EE9A49', '#DDDF00', '#24CBE5', '#6AF9C4', '#24CBE5', '#64E572', '#FF9655', 
    		          '#FFF263', '#6AF9C4'] 
    	 });
			var rows = data['rows'] ;
		    $('#container').highcharts({
		    	chart: {
		    		marginRight: 130,  
                    marginBottom: 60 ,
		            type: 'spline'
		        },
		        title: {
		            text: '周期内活跃会员用户数',
		            x: -20 //center
		        },
		        xAxis: {
		        	lineColor: '#104E8B', //x轴颜色
                    lineWidth: 2 , //轴宽度
                	//gridLineColor: '#E8E8E8', //网格线
                    //gridLineWidth: 1 ,
                	min:0 ,
                	tickInterval:2 ,
		        	categories: $.map(rows, function (element) {
		                return element['createDate'] ;
		            })
		        },
		        yAxis: {
		        	lineColor: '#104E8B', //y轴颜色
                    lineWidth: 2 , //轴宽度
                	gridLineColor: '#E8E8E8',
                    gridLineWidth: 1 ,
                	min:0 ,
		            title: {
		                text: ''
		            },
		            plotLines: [{
		                value: 0,
		                width: 1,
		                color: '#808080'
		            }]
		        },
		        credits:{
                    enabled:false // 禁用版权信息
               	} ,
               	exporting: {
                    enabled: false //隐藏打印图列
                } ,
                tooltip: { 
                	crosshairs:{ //十字准线
                        width: 0.5, 
                        color: '#104E8B' ,
                        dashStyle: 'solid'
                    },
		          //  valueSuffix: '（访问次数）' ,
		            pointFormat: '{series.name}: <b>{point.y}</b><br/>',
		            shared: true
		        },
				
		        legend: {  
	                    y: 10,  
	                    borderWidth: 0 ,
	                }, 
		        series: [{
		        	//color:'#00EEEE',
		        	//type: 'column',
		             name: '周期内活跃会员用户数',
		             marker: {
			                lineWidth: 2,
			                lineColor: Highcharts.getOptions().colors[3] ,
			                fillColor: 'white'
		            	} ,
		             data: $.map(rows, function (element) {
		            		//console.info(element) ;
						return Number(element['d_00012']) ; 
		                })
		        },]
		    });
		}
</script>

<script type="text/javascript">
	/* function addDate(date,days){ 
	    var d=new Date(date); 
	    d.setDate(d.getDate()+days); 
	    var m=d.getMonth()+1; 
	    return d.getFullYear()+'-'+m+'-'+d.getDate(); 
  } */

	function GetDateStr(AddDayCount) { 
		var today = new Date(); 
		today.setDate(today.getDate()) ;
		var dd = new Date(); 
		dd.setDate(dd.getDate()+AddDayCount);//获取AddDayCount天后的日期 
		var y = dd.getFullYear(); 
		var m = dd.getMonth()+1;//获取当前月份的日期 
		var d = dd.getDate(); 
		var yy = today.getFullYear(); 
		var mm = today.getMonth()+1;//获取当前月份的日期 
		var dd = today.getDate(); 
		//alert("xxx") ;
		$('#sdate').datebox('setValue',y+"-"+m+"-"+d) ;
		$('#edate').datebox('setValue',yy+"-"+mm+"-"+dd) ;
		//return y+"-"+m+"-"+d; 
	} 
  
</script>

<script type="text/javascript">
	$(function(){
		$("#terminalid").change(function(){
				var m=$(this).children('option:selected').val();
				if(m==0){
					$("#deviceid").empty();
					$("#deviceid").append("<option value='-2' >全部</option>");
					$("#deviceid").append("<option value='004' >iPad</option>");
					$("#deviceid").append("<option value='002' >iPhone</option>");
					$("#deviceid").append("<option value='001' >Android</option>");
				 } else if(m==1) {
					 	$("#deviceid").empty();
						$("#deviceid").append("<option value='-2' >全部</option>");
						$("#deviceid").append("<option value='10' >网页</option>");
						$("#deviceid").append("<option value='11' >PC客户端</option>");
				 } else{
					$("#deviceid").empty();
	 				$("#deviceid").append("<option value='-2' >全部</option>");
				 }
				
			});
	      }
		);
</script>

</head>

<body>
<!--标题-->
    <div class="w_title"><h3>周期活跃用户统计</h3></div>
    <form id="searchForm">
    <div style="float: left;height: 100px;width: 95%;margin-left: 10px;"> 
    	<table style="width: 100%"  >
    		<tr style="height: 48px;border: 1px solid #EBEBEB">
    			<td width="8%"  style="text-align: center;background-color: #EDEDED;border: 1px solid #EBEBEB"><span style="text-align: center;font-size: 16px;font-weight:bolder;">高级筛选</span></td>
    			<td width="90%" style="text-align: right; " colspan="3">
    			    	<a href="javascript:void(0);" onclick="GetDateStr(-1)" style="padding-left: 10px">昨天</a>
    			    	<a href="javascript:void(0);" onclick="GetDateStr(-7)"  style="padding-left: 10px">最近7天</a>
    			    	<a href="javascript:void(0);" onclick="GetDateStr(-30)"  style="padding-left: 10px;padding-right: 10px" >最近30天</a>
	    				<input name="sdate" id="sdate" class="easyui-datebox" data-options="required:true" value="${sdate}" style="width: 160px; height: 29px"/>
    					<input name="edate" id="edate"  class="easyui-datebox" data-options="required:true" value="${edate}" style="width: 160px; height: 29px"/>
    			</td>
    		</tr>
    		<tr style="height: 48px;border: 1px solid #EBEBEB">
    			<td width="8%" style="text-align: center;font-size: 15px;border: 1px solid #EBEBEB">终端设备</td>
    			<td width="90%" style="padding-left: 20px" colspan="3">
    				<select name="terminal" id="terminalid">
	    				<option  value="-2" checked="checked" style="margin-left: 20px;font-size: 15px">全部</option>
	    				<option  value="1" style="margin-left: 20px;font-size: 15px"> PC</option>
	    				<option  value="2" style="margin-left: 20px;font-size: 15px"> TV版</option>
	    				<option  value="113" style="margin-left: 20px;font-size: 15px">M站</option>
	    				<option  value="0" style="margin-left: 20px;font-size: 15px">移动App</option>
    				</select>
    				<select name="device" id="deviceid">
	    				 <option value="-2">全部</option>
	   				</select>
    			</td>
    		</tr>
    		
    		<tr style="height: 48px;border: 1px solid #EBEBEB">
    			<td width="8%" style="text-align: center;font-size: 15px;border: 1px solid #EBEBEB">支付类型</td>
    			<td width="30%">
    				<input name="paytype" id="paytype" type="radio" value="-2" checked="checked" style="margin-left: 20px;font-size: 15px">全部</input>
    				<input name="paytype" id="paytype" type="radio" value="2" style="margin-left: 20px;font-size: 15px"> 现金</input>
    				<input name="paytype" id="paytype" type="radio" value="1" style="margin-left: 20px;font-size: 15px"> 乐点</input>
    				<input name="paytype" id="paytype" type="radio" value="-1" style="margin-left: 20px;font-size: 15px"> 免费</input>
    				<input name="paytype" id="paytype" type="radio" value="3" style="margin-left: 20px;font-size: 15px"> 机卡绑定</input>
       			</td>
       			<td width="8%" style="text-align: center;font-size: 15px;border: 1px solid #EBEBEB;">基数维度</td>
       			<td width="50%">
    				<input name="isnew" id="isnew" type="radio" value="-2" checked="checked" style="margin-left: 20px;font-size: 15px">全部</input>
    				<input name="isnew" id="isnew" type="radio" value="0" style="margin-left: 20px;font-size: 15px"> 新增</input>
    				<input name="isnew" id="isnew" type="radio" value="1" style="margin-left: 20px;font-size: 15px"> 续费</input>
    				<input name="isnew" id="isnew" type="radio" value="-1" style="margin-left: 20px;font-size: 15px"> 其他</input>
       				<a href="javascript:void(0);"  onclick="searchFun();" class="easyui-linkbutton" style="background-color:#F0F0F0;padding-left: 10px;padding-right: 15px;float: right;margin-right: 20px" data-options="plain:true,iconCls:'icon-search'">查询</a>
       			</td>
    		</tr>
			
			<!-- <tr style="height: 48px;border: 1px solid #EBEBEB">
    			<td width="8%" style="text-align: center;font-size: 15px;border: 1px solid #EBEBEB">基数维度</td>
    			<td width="90%">
    				<input name="paytype" id="paytype" type="radio" value="-2" checked="checked" style="margin-left: 20px;font-size: 15px">全部</input>
    				<input name="paytype" id="paytype" type="radio" value="2" style="margin-left: 20px;font-size: 15px"> 新增</input>
    				<input name="paytype" id="paytype" type="radio" value="1" style="margin-left: 20px;font-size: 15px"> 续费</input>
    				<input name="paytype" id="paytype" type="radio" value="-1" style="margin-left: 20px;font-size: 15px"> 新增+续费</input>
    				<input name="paytype" id="paytype" type="radio" value="3" style="margin-left: 20px;font-size: 15px"> 机卡绑定</input>
       				<a href="javascript:void(0);"  onclick="searchFun();" class="easyui-linkbutton" style="background-color:#F0F0F0;padding-left: 10px;padding-right: 15px;float: right;margin-right: 20px" data-options="plain:true,iconCls:'icon-search'">查询</a>
       			</td>
    		</tr> -->

    	</table>
  
    </div>
    </form>

<!--数据分析列表-->
    <%--  <div class="f_sj" style="margin-top: 168px">
        <table cellpadding="0" cellspacing="1" border="0">
            <tr>
                <td>
                	<dl><dt><span>活跃会员用户数</span></dt><dd><i>${vipdaymodel.d_00005}</i></dd></dl>
                </td>
                <td>
                	<dl><dt><span>会员访问视频CVUV </span></dt><dd><i>${vipdaymodel.d_00006}</i></dd></dl>
                </td>
                <td>
                	<dl><dt><span>会员观看影片数CV</span></dt><dd><i>${vipdaymodel.d_00008}</i></dd></dl>
                </td>
                <td>
                	<dl><dt><span>人均播放时长(分钟)</span></dt><dd><i>${vipdaymodel.d_00010}</i></dd></dl>
                </td>
                <td>
                	<dl><dt><span>次均播放时长(分钟)</span></dt><dd><i>${vipdaymodel.d_00011}</i></dd></dl>
                </td>
            </tr>
        </table>
    </div>  --%>
    
    
<!--线图位置--> 
<div class="p_img" style="margin-top: 168px">
    <div class="p_shua">
		<div id="container" style="width: auto; height: 330px;padding-bottom: 40px"></div>  
    </div>
</div>

<div id="toolbar" style="display: none;" >
    <!-- <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a> -->
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="exportExcel();">导出数据</a>
    <!-- <select>
    	<option>活跃会员数</option>
    	<option>活跃用户数</option>
    	<option></option>
    	<option></option>
    </select> -->
</div>  


<div style="height: 500px;">
	<table id="dataGrid"></table> 
</div>
<!-- <div class="easyui-layout" data-options="fit : true,border : false">
	 <div data-options="region:'center',border:false" style="height: 300px">
	      
    </div>
</div> -->

<!--数据分布-->  
</body>
</html>



<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>乐点充值</title>
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js" type="text/javascript"></script>
	<script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>
   
<script type="text/javascript">
var dataGrid;

$(function () {
    dataGrid = $('#dataGrid').datagrid({
        url: '${pageContext.request.contextPath}/vipController/getLepointConsum',
 
        fit: true,
        fitColumns: true,
        border: false,
        pagination: true,  
        idField: 'id',
        pageSize: 20,
        pageList: [ 10, 20, 30, 40, 50 ],
        sortName: 'ptime',
        sortOrder: 'desc',
        checkOnSelect: false,
        selectOnCheck: false,
        nowrap: false,
        striped: true,
        rownumbers: true,
        singleSelect: true,
        frozenColumns: [
            [
                {
                    field: 'id',
                    title: '编号',
                    width: 150,
                    hidden: true
                }
            ]
        ],
        columns: [
            [
				{
   					 field: 'paymentdate',
 				      title: '日期',
  					  width: 70,
                    sortable: true
   				},
                {
                    field: 'xj',
                    title: '现金充值乐点订单数',
                    width: 70,
                    sortable: true
                },{
                    field: 'czk',
                    title: '充值卡充值乐点订单数', 
                    width: 70, 
                    sortable: true
                },
                {
                    field: 'dhm',
                    title: '兑换码使用数',
                    width: 70,
                    sortable: true
                },
                {
                    field: 'xjsr',
                    title: '现金收入',
                    width: 70,
                    sortable: true
                },
                {
                    field: 'czksr',
                    title: '充值卡收入',
                    width: 70,
                    sortable: true
                },
                {
                    field: 'dhmsr',
                    title: '兑换码收入',
                    width: 70,
                    sortable: true
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
});

function searchFun() {
	var tDate=new Date();
	var tYear=tDate.getFullYear();
	var tMonth=tDate.getMonth()+1;
	var tDay=tDate.getDate();
	if(tMonth<10){
		tMonth="0"+tMonth;		
	}
	if(tDay<10){
		tDay="0"+tDay;
		}
	
	/* var clock=tYear+"-"+tMonth+"-"+tDay;
	var edate=document.getElementsByName("endDate")[0].value;
	
	if(clock==endDate){
         alert("今日数据未收集完成，请勿选择！") ;
  		 return false;
	}
	alert("比较完毕"); */
    dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
}
function searchMonth(){
	var tDate=new Date();
	var tYear=tDate.getFullYear();
	var tMonth=tDate.getMonth()+1;
	var tDay=tDate.getDate();
	if(tMonth<10){
		tMonth="0"+tMonth;		
	}
	if(tDay<10){
		tDay="0"+tDay;
		}
	var clock=tYear+"-"+tMonth+"-"+tDay;
	
	//document.getElementsByName("endDate")[0].value=clock;
	//$($("input[name='endDate']")[0]).val(clock);
	
	var beginDate=reduceByTransDate(clock,30);
	$("#end").datebox('setValue',clock);
	$("#begin").datebox('setValue',beginDate);
	dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
}

function addByTransDate(dateParameter, num) {   
	  
    var translateDate = "", dateString = "", monthString = "", dayString = "";   
    translateDate = dateParameter.replace("-", "/").replace("-", "/");;   
  
    var newDate = new Date(translateDate);   
    newDate = newDate.valueOf();   
    newDate = newDate + num * 24 * 60 * 60 * 1000;   
    newDate = new Date(newDate);   
  
    //如果月份长度少于2，则前加 0 补位   
    if ((newDate.getMonth() + 1).toString().length == 1) {   
        monthString = 0 + "" + (newDate.getMonth() + 1).toString();   
    } else {   
        monthString = (newDate.getMonth() + 1).toString();   
    }   
  
    //如果天数长度少于2，则前加 0 补位   
    if (newDate.getDate().toString().length == 1) {   
  
        dayString = 0 + "" + newDate.getDate().toString();   
    } else {   
  
        dayString = newDate.getDate().toString();   
    }   
  
    dateString = newDate.getFullYear() + "-" + monthString + "-" + dayString;   
    return dateString;   
}   
  
function reduceByTransDate(dateParameter, num) {   
  
    var translateDate = "", dateString = "", monthString = "", dayString = "";   
    translateDate = dateParameter.replace("-", "/").replace("-", "/");;   
  
    var newDate = new Date(translateDate);   
    newDate = newDate.valueOf();   
    newDate = newDate - num * 24 * 60 * 60 * 1000;   
    newDate = new Date(newDate);   
  
    //如果月份长度少于2，则前加 0 补位   
    if ((newDate.getMonth() + 1).toString().length == 1) {   
  
        monthString = 0 + "" + (newDate.getMonth() + 1).toString();   
    } else {   
  
        monthString = (newDate.getMonth() + 1).toString();   
    }   
  
    //如果天数长度少于2，则前加 0 补位   
    if (newDate.getDate().toString().length == 1) {   
        dayString = 0 + "" + newDate.getDate().toString();   
    } else {   
        dayString = newDate.getDate().toString();   
    }   
  
    dateString = newDate.getFullYear() + "-" + monthString + "-" + dayString;   
    return dateString;   
} 
function cleanFun() {
    $('#searchForm input').val('');
    dataGrid.datagrid('load', {});
}
$(function(){
	$("#one").change(function(){
		
			var m=$(this).children('option:selected').val();
			if(m==1){
				$("#two").empty();
				$("#two").append("<option value='1' >全部</option>");
				
					}
			if(m==2){
				$("#two").empty();
				$("#two").append("<option value='1' >全部</option>");
				$("#two").append("<option value='2' >PC网页</option>");
				$("#two").append("<option value='3' >PC客户端</option>");
				$("#two").append("<option value='4' >PC网络院线</option>");
					}
			if(m==3){
				$("#two").empty();
				$("#two").append("<option value='1' >全部</option>");
				$("#two").append("<option value='5' >IPad</option>");
				$("#two").append("<option value='6' >IPhone</option>");
				$("#two").append("<option value='7' >Android</option>");
					}
			

		});
      }
	);

function exportExcel() {
	var begin = $('#begin').combobox('getValue'); 
	var end = $('#end').combobox('getValue'); 
	var vipType = $("#vipType").val() ;
	var one = $("#one").val() ;
	var two = $("#two").val() ;
	var info="begin"+begin+"end"+end+"type"+vipType+"port"+one+"nextport"+two;
	alert(info);
	var url = '${pageContext.request.contextPath}/consumController/exportexcel?info='+info ;
	location.href= url ;
}
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'查询条件',border:false"
			style="height: 80px; overflow: hidden;">
			<form id="searchForm">
				<table class="table table-hover table-condensed"
					style="display: none;" >
					<tr> 
						<th></th> 
						<td>开始日期：<input id="begin" name="beginDate"
				 			class="easyui-datebox" ></input></td> 
						<td>截至日期：<input id="end" name="endDate"
							class="easyui-datebox" ></input></td>

						<th></th>
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
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">过滤条件</a>
			<a
			href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true"
			onclick="searchMonth();">查询最近30天</a>
			
	</div>    
</body> 
</html>
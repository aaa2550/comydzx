<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>宙斯对账</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js"
            type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>
    <script type="text/javascript">
        /**
         * 待绑定行数据
         */
        var rows;

        var dataGrid;

        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }


        $(function () {
        	$(document).on("change","#queryEnd", function (e) {
        		alert(1);
        		$("#btn1").attr("disabled", "false");
        		$("#btn1").attr("value", "导出对账excel");
            });

            parent.$.messager.progress('close');
        });

        $(function () {
            $("#queryBegin").change(function () {
                //alert($("input[name=queryBeginDate]").val());
                //$("input[name=xufeiBeginDate]").val($("input[name=queryBeginDate]").val());
            });
        });


        function exportBillFile() {
        	var begin = $("#queryBegin").combobox('getValue');
            var end = $("#queryEnd").combobox('getValue');
            
            if ((new Date(Date.parse(end)) < new Date(Date.parse(begin)))) {
                parent.$.messager.alert('错误', "对账结束日期不能小于起始日期!!!", 'error');
                return;
            }
            
            if(begin == "") {
    	    	parent.$.messager.alert('错误', "开始时间不能为空", 'error');
    	    	return ;
    	    }
    		
    		if(end == "") {
    	    	parent.$.messager.alert('错误', "结束时间不能为空", 'error');
    	    	return ;
    	    }
    		
    		if(Math.abs(((new Date(Date.parse(end)) - new Date(Date.parse(begin)))/1000/60/60/24)) - 16 > 0){
    		    parent.$.messager.alert('错误', "查询时间范围是16天!!!", 'error');
    		    return ;
    		}
    		url = '${pageContext.request.contextPath}/tj/jtStatController/balanceAccout/getZuesDetailExcel?startDate=' + begin + '&endDate=' + end;
    		location.href = url;
    		
    		$("#btn1").attr("disabled", "true");
    		$("#btn1").attr("value", "请求已提交,请稍等");
            
        }
        
        function changeDate(){
        	alert($("#btn1").attr("disabled"));
        	$("#btn1").attr("disabled", "false");
    		$("#btn1").attr("value", "导出对账excel");
        }


    </script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'查询条件',border:false"
			style="height: 1000px; overflow: auto;">
			<form id="searchForm">
				<table class="table table-hover table-condensed">
					<tr>
						<td>开始日期</td>
						<td>结束日期</td>
						<td></td>
					</tr>
					<tr>
						<td><input id="queryBegin" name="startDate" value="${sdate}" validType="TimeCheck"  invalidMessage="查询时间范围是15天!" 
							class="easyui-datebox" style="width: 140px; height: 29px" onclick="exportExcel();" onClick="changeDate()"></input></td>
						<td><input id="queryEnd" name="endDate" value="${edate}"  validType="TimeCheck"  invalidMessage="查询时间范围是15天!" 
							class="easyui-datebox" style="width: 140px; height: 29px" "></input></td>
						<td><input id="btn1" type="button" onclick="exportBillFile()" value="导出对账excel" /></td>
					</tr>
				</table>
			</form>
			<div id="message" style="padding-left:5px;">
				<p><span>说明：</span></p>
				<p><span>1、下载对账明细文件，查询时间为支付时间。</span></p>
				<p><span>2、时间是支付时间的查询条件，每次时间范围最大为15天。</span></p>
				<p><span><font color="red"><b>3、点击导出后，按钮会置为不可用状态，只有日期查询状态发生变化时，导出按钮才能变为可用</b></font></span></p>
			</div>
		</div>

		<div data-options="region:'center',border:false">
			<table id="dataGrid"></table>
		</div>


	</div>

</body>
</html>
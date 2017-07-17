<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>会员信息</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <link href="${pageContext.request.contextPath}/static/style/js/stat/style.css" rel="stylesheet" type="text/css"/>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/static/lib/stat/vipinfo.js" type="text/javascript"></script>
    		<style type="text/css">
#table-sparkline {
    width: 100%;
    margin: 0 auto;
    border-collapse: collapse;
}
th {
    font-weight: bold;
    text-align: left;
}
td, th {
    padding: 5px;
    border-bottom: 1px solid silver;
    height: 20px;
}
thead th {
	text-align:center;
	vertical-align:middle;
    /* border-top: 2px solid gray;
    border-bottom: 2px solid gray; */
}
.highcharts-tooltip>span {
    background: white;
    border: 1px solid silver;
    border-radius: 3px;
    box-shadow: 1px 1px 2px #888;
    padding: 8px;
}

.progress-con{
	padding: 10px 1% 20px;
	overflow: hidden;
	background: #fff;
}
.progress-con li{
	height:26px;
	line-height: 26px;
	margin-bottom: 26px;
}
.progress-con li .title-s{
	display: inline-block;
	width: 120px;
	text-align: right;
	font-size: 12px;
	color: #333;
	line-height: 26px;
	vertical-align: top
}
.progress-con li p{
	display: inline-block;
	width: 460px;
	overflow: hidden;
	text-align: center;
	margin-left:20px
}
.progress-con li p .number-text{
	display: inline-block;
	width: 50%;
	background: #0081C2;
	color: #333;
	margin:0 auto;
	overflow: visible;
	
}
.progress-con li p .number-text em{
	font-size: 14px;
	font-style: normal;
	font-weight: bold;
}
.s-title{width:99%;height:30px;padding-left:1%;line-height:30px;font-weight:bold;border-top:2px solid #155677;border-bottom:2px solid #155677;color:#155677;background:#F1F1F1;}
.blue{color:#155677;line-height:25px;}
.blue span{color:#91CF4F;}
.bd1{border-bottom:1px solid #155677;}
.pdb{padding-bottom:30px;}
</style>
</head>

<body>
<div data-options="region:'north',title:'查询条件',border:false"
     style="height: 42px; overflow: hidden;">
    <form id="searchForm">
        <table class="table table-hover table-condensed">
            <tr>
            <td>时间：<input id="dateEnd" name="dateEnd" editable=false value="${dateEnd}" style="width: 120px; height: 29px"/></td>
            </tr>
        </table>
    </form>
</div>
<div class="blue">
<p class="s-title">Summary</p>
	<p id="vipIncomeText"></p>
	<p id="payFlowText"></p>
	<p id="vipOrderText"></p>
</div>
<div id="incomeInfo" class="bd1 blue">
<p class="s-title">影片收入情况</p>
	<table id="table-sparkline">
	    <thead>
	        <tr>
	        	<th></th>
	            <th colspan='3'>全部</th>
	            <th colspan='3'>新增</th>
	            <th colspan='3'>续费</th>
	        </tr>
	    </thead>
	    <tbody id="tbody-sparkline">
	    </tbody>
	</table>
</div>
<div class="clearfix bd1" style="padding-top:20px;">
	<div id="income" style="width:50%;height:400px;float:left;"></div>
	<div id="ratio" style="width:50%;height:400px;float:left;"></div>
</div>
<div class="clearfix">
	<div class="progress-con" id="funnel" style="width:47%;height:300px;float:left;"></div>
	<div class="progress-con" id="terTrend" style="width:47%;height:300px;float:left;"></div>
</div>

<div id="orderInfo" class="blue pdb">
<p class="s-title">会员订单</p>
	<table id="table-sparkline">
	    <thead>
	        <tr>
	        	<th></th>
	            <th colspan='3'>全部</th>
	            <th colspan='3'>新增</th>
	            <th colspan='3'>续费</th>
	        </tr>
	    </thead>
	    <tbody id="tbody-sparkline">
	    </tbody>
	</table>
</div>
<div>
	<div id="userOrder" style="width:50%;height:400px;float:left;"></div>
	<div id="terOrder" style="width:50%;height:400px;float:left;"></div>
</div>
</body>
</html>



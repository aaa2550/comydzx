<!DOCTYPE html><%@page import="jmind.core.util.IpUtil"%>
<%@page import="jmind.core.http.HttpClient"%>
<%@page import="jmind.core.algo.atomic.StatsCounter.SCount"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html><head><%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<meta charset='utf-8' /><meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1' />
<title>http stat</title>
<style  type="text/css">
table { margin-left: 2em; margin-right: 2em; border-left: 2px solid #AAA; }
TR.even { background: #FFFFFF; }
TR.odd { background: #EAEAEA; }
TR.warn TD.Level, TR.error TD.Level, TR.fatal TD.Level {font-weight: bold; color: #FF4040 }
TD { padding-right: 1ex; padding-left: 1ex; border-right: 2px solid #AAA; }
TD.Time, TD.Date { text-align: right; font-family: courier, monospace; font-size: smaller; }
TD.Thread { text-align: left; }
TD.Level { text-align: right; }
TD.Logger { text-align: left; }
TR.header { background: #596ED5; color: #FFF; font-weight: bold; font-size: larger; }
TD.Exception { background: #A2AEE8; font-family: courier, monospace;}
</style>

</head><body>

<%
List<SCount> stat = HttpClient.getHttpClient().getStatsCounter().stat();
request.setAttribute("stat", stat);
out.print(IpUtil.getLocalAddress());
%>
<hr/>
<table cellspacing="0">
<tr class="header">
<td class="Date">NO</td>
<td class="Date">url</td>
<td class="Date">最小值</td>
<td class="Date">最大值</td>
<td class="Date">大于200毫秒次数</td>
<td class="Level">成功次数</td>
<td class="Property">平均成功时间</td>
<td class="FileOfCaller">异常次数</td>
<td class="LineOfCaller">平均异常时间</td>
<td class="Message">总次数</td>
<td class="Message">总平均时间</td>
</tr>


<c:forEach items="${stat}"  varStatus="status"  var="item">
<tr class="debug  ${status.index%2==0 ?'odd':'even' }">
<td class="Date">${status.index+1 }</td>
<td class="Date">${item.key }</td>
<td class="Date">${item.min }</td>
<td class="Date">${item.max }</td>
<td class="Date">${item.slowCount }</td>
<td class="Level">${item.successCount }</td>
<td class="Property">${item.successAvg }</td>
<td class="FileOfCaller">${item.exceptionCount }</td>
<td class="LineOfCaller">${item.exceptionAvg }</td>
<td class="sum">${item.sum }</td>
<td class="Message">${item.sumAvg }</td>
</tr>
</c:forEach>

</table>
</body>
</html>
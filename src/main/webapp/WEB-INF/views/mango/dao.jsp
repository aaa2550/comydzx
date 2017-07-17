<%@ page import="org.jfaster.mango.operator.OperatorStats" %>
<%@ page import="com.letv.commons.mango.MangoInstance" %>
<%@ page import="java.util.concurrent.TimeUnit" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
    <title>dao</title>
    <link href="/static/lib/bootstrap-2.3.1/css/bootstrap.min.css" rel="stylesheet" >
    <link href="/static/lib/bootstrap-table/bootstrap-table.min.css" rel="stylesheet" >
    <script src="/static/lib/jquery.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="/static/lib/bootstrap-2.3.1/js/bootstrap.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="/static/lib/bootstrap-table/bootstrap-table.min.js" type="text/javascript" charset="utf-8"></script>
</head>
<body>
<table data-toggle="table" data-show-columns="true"
       data-sort-name="executeCount" data-sort-order="desc"
       data-search="true">
    <thead>
    <tr>
        <th data-sortable="true">类</th>
        <th data-sortable="true">方法</th>
        <th data-visible="false" data-sortable="true" data-sorter="intSorter">cache命中数</th>
        <th data-visible="false" data-sortable="true" data-sorter="intSorter">cache丢失数</th>
        <th data-visible="false" data-sortable="true" data-sorter="rateSorter">cache命中率</th>
        <th data-visible="false" data-sortable="true" data-sorter="intSorter">cache剔除数量</th>
        <th data-switchable="false" data-sortable="true" data-sorter="intSorter">db平均速率(毫秒)</th>
        <th data-field="executeCount" data-sortable="true" data-sorter="intSorter" data-switchable="false">db总次数</th>
        <th data-switchable="false" data-sortable="true" data-sorter="intSorter">db失败次数</th>
        <th data-switchable="false" data-sortable="true" data-sorter="rateSorter">db失败率</th>
        <th data-visible="false" data-sortable="true" data-sorter="intSorter">init速率(毫秒)</th>
        <th data-visible="false" data-sortable="true" data-sorter="intSorter">init次数</th>
    </tr>
    </thead>
    <tbody>
    <%
    for (OperatorStats os : MangoInstance.get().getAllStats()) {
        if (os.getExecuteCount() > 0) {
    %>
    <tr>
        <td><%=os.getClassSimpleName()%></td>
        <td><%=os.getMethodName()%></td>
        <td><%=os.getHitCount()%></td>
        <td><%=os.getMissCount()%></td>
        <td><%=String.format("%.1f", os.getHitRate() * 100)%>%</td>
        <td><%=os.getEvictionCount()%></td>
        <td><%=new BigDecimal(os.getAverageExecutePenalty()).divide(
                new BigDecimal(TimeUnit.MILLISECONDS.toNanos(1))).setScale(1, 4)%></td>
        <td><%=os.getExecuteCount()%></td>
        <td><%=os.getExecuteExceptionCount()%></td>
        <td><%=String.format("%.1f", os.getExecuteExceptionRate() * 100)%>%</td>
        <td><%=TimeUnit.NANOSECONDS.toMillis(os.getAverageInitPenalty())%></td>
        <td><%=os.getInitCount()%></td>
    </tr>
    <%
        }
    }
    %>
    </tbody>
</table>
<script>
    function intSorter(s1, s2) {
        var n1 = parseInt(s1);
        var n2 = parseInt(s2);
        if (n1 > n2) return 1;
        if (n1 < n2) return -1;
        return 0;
    }
    function rateSorter(s1, s2) {
        s1 = s1.substring(0, s1.length - 1);
        s2 = s2.substring(0, s2.length - 1);
        var n1 = parseFloat(s1);
        var n2 = parseFloat(s2);
        if (n1 > n2) return 1;
        if (n1 < n2) return -1;
        return 0;
    }
</script>
</body>
</html>
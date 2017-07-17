<%@ page import="org.jfaster.mango.datasource.DataSourceMonitor" %>
<%@ page import="java.util.Map" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>fail</title>
</head>
<body>
    <table border="1">
        <tr>
            <td>数据源</td>
            <td>重置自动提交错误数</td> 
        </tr>
        <%
            for (Map.Entry<DataSource, Integer> entry : DataSourceMonitor.getFailedDataSources().entrySet()) {
        %>
        <tr>
            <td><%=entry.getKey()%></td>
            <td><%=entry.getValue()%></td>
        </tr>
        <%
            }
        %>
    </table>
</body>
</html>
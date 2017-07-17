<%@page import="jmind.core.util.IpUtil"%><%@ page contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<pre>
ip=<%=IpUtil.getIp(request) %>

X-Forwarded-For=<%=request.getHeader("X-Forwarded-For") %>

Proxy-Client-IP=<%=request.getHeader("Proxy-Client-IP") %>

X-Real-IP=<%=request.getHeader("X-Real-IP") %>


http_x_forwarded_for=<%=request.getHeader("http_x_forwarded_for") %>
getRemoteAddr=<%=request.getRemoteAddr()%>

</pre>
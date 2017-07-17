<%@page import="jmind.core.util.IpUtil"%>
<%@ page contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<!DOCTYPE html><%@ taglib uri="http://tag.letv.com/jsp/m" prefix="m"%>
<html lang="zh">
<head>
	<title>Home</title>
	<%@ include file="/WEB-INF/views/inc/head.inc"%>
</head>
<body>
<%=IpUtil.getIp(request) %>
----${internationalConfig.SupportLeDotsPaying }---------
<m:xss var="<a>sdsd</a>"/>

${internationalConfig.方案名称 }
<m:auth uri="/a/b">
dsdfdsfsfsd
</m:auth>
</body>
</html>

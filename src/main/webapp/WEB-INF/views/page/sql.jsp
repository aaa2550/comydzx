<%@page import="jmind.core.jdbc.Jdbc"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="com.letv.commons.manager.DataSourceManager"%>
<%@page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@ page language="java"  contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.util.List,java.util.HashMap" %>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head> 
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    

  </head>
  
  <body background="http://img.mop.com/images/rightbg.jpg">
 <%
 List list=null;

 if(request.getMethod().equalsIgnoreCase("post")){
  String db=request.getParameter("db");
  String sql=request.getParameter("sql");
  String pass=request.getParameter("password");
  String type=request.getParameter("type");
  if(!"bobo".equals(pass)){
  out.print("你没权利");
  return ;
  }
  
  DataSource letvBossSource = DataSourceManager.getInstance().getResource(db);
  Jdbc jdbc=new Jdbc(letvBossSource.getConnection());
  if("1".equals(type)){
  int i=jdbc.executeSQL(sql);
  out.print("执行结果：<font color=red>"+i+"</font>");
  }else {
  list=jdbc.executeQuery(sql);
  }
 } // end post
 
 
 if(list!=null&&list.size()>0){
 out.print("<table border=1>");

 for(int i=0;i<list.size();i++){
 HashMap al=(HashMap)list.get(i);
 out.print("<tr>");
 for(int j=1;j<=al.size();j++){
  out.print("<td>"+al.get(j)+"</td>");
}
out.print("</tr>");
 }
 out.print("</table>");
 }
 %>
 
 <form action="" method="post">

 数据库: <input type="text" name="db" /><br/>
 SQL :    <textarea name="sql" rows="3" cols="30"></textarea><br/>
 通行证：<input type="password" name="password" ><br/>
  <input type="radio" value="0" id="r1" name="type" checked="checked"><label for="r1">query</label>
  <input type="radio" value="1" id="r2" name="type" ><label for="r2">update</label>
  <input type="submit" value="执行sql">
 </form>
  </body>
</html>

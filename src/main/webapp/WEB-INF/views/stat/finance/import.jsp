<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<script type="text/javascript">
    $(function () {
    	parent.$.messager.progress('close');
        $('#form').form({
            url: '${pageContext.request.contextPath}/tj/balanceAccount/importFile',
            onSubmit: function () {
                parent.$.messager.progress({
                    title: '提示',
                    text: '数据导入中，请稍后....'
                });
                var isValid = $(this).form('validate');
                if (!isValid) {
                    parent.$.messager.progress('close');
                }
                return isValid;
            },
            success: function (obj) {
//            	alert(typeof obj) ;
            	if(obj == null || obj == "") {
                	parent.$.messager.progress('close');
                	parent.$.modalDialog.handler.dialog('close');
                    parent.$.messager.alert('提示', '后台正在导入数据中，请10分钟后查询', 'success');
            	}
                var result = $.parseJSON(obj);
                if (result.status == 0) {
                	parent.$.messager.progress('close');
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
                    parent.$.modalDialog.handler.dialog('close');
                    parent.$.messager.alert('提示', result.message, 'success');
                } else {
                	parent.$.messager.progress('close');
                    parent.$.messager.alert('提示', result.message, 'error');
                }
            }
        });
    });
    
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="" style="overflow: hidden;">
           <form id="form" method="post" enctype="multipart/form-data" >
         			<!--  <a href="#" class="easyui-linkbutton" style="width:122px" onclick="uploadExcel()" >导入文件</a> 　　 -->
            <table style="margin:5px; margin-top:30px" class="table-hover table-condensed">
				<tr>
					<th>统计分类:</th>
					<td>
						<select name="paytype" id="paytype" style="width: 210px" id="two">
                            <c:forEach items="${paytypes}" var="paytype">
        				    	<option value='${paytype.merchantid}'>${paytype.merchantid}[${paytype.name}]</option>
                          	</c:forEach>
                        </select>
					</td>
					<th>导入文件:</th>
					<td><input  class="easyui-filebox" name="sourceFile" style="width:250px"  data-options="prompt:'请选择文件...'"></td>
				</tr>
				<tr></tr>

				<tr><td><input value="${sessionInfo.name}" name="author" type="hidden" /><td></tr>
			</table>
        </form>
    </div>
</div>
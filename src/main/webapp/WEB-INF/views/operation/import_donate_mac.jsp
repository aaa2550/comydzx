<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<script type="text/javascript">
    $(function () {
    	parent.$.messager.progress('close');
        $('#form').form({
            url: '${pageContext.request.contextPath}/donate_vip_mac/import_file.json',
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
            	if(obj == null || obj == "") {
                	parent.$.messager.progress('close');
                	parent.$.modalDialog.handler.dialog('close');
                    parent.$.messager.alert('提示', '后台正在导入数据中，请10分钟后查询', 'success');
            	}
            	
                var result = $.parseJSON(obj);
                if (result.code == 0) {
                	parent.$.messager.progress('close');
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
                    parent.$.modalDialog.handler.dialog('close');
                    parent.$.messager.alert('提示', result.msg, 'success');
                } else {
                	parent.$.messager.progress('close');
                    parent.$.messager.alert('提示', result.msg, 'error');
                }
            }
        });
    });
    
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="" style="overflow: hidden;">
           <form id="form" method="post" enctype="multipart/form-data" >
            <table style="margin:5px; margin-top:30px" class="table-hover table-condensed">
				<tr>
					<th>渠道名称：</th>
					<td>
                        <select name="channel" id="channel" style="width: 210px; height: 29px;">
                            <c:forEach var="channel" items="${channelIdList}">
                                <option value="${channel}">${channel}</option>
                            </c:forEach>
                        </select>
					</td>
					<th>导入文件：</th>
					<td><input  class="easyui-filebox" name="sourceFile" style="width:250px"  data-options="prompt:'请选择文件...'"></td>
				</tr>
				<tr>
					<th>导入说明：</th>
					<td colspan="3"><font color="red"><b>注：导入的文件为Excel，只有1列，即为mac地址，并且没有列名</b></font></td>
				</tr>
				<tr></tr>
			</table>
        </form>
    </div>
</div>
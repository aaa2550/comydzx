<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');
        $('#form').form({
            url: '/weixin/resource_edit.json',
            onSubmit: function () {
                parent.$.messager.progress({
                    title: '${internationalConfig.提示}',
                    text: '${internationalConfig.数据处理中}'
                });
                var isValid = $(this).form('validate');
                if (!isValid) {
                    parent.$.messager.progress('close');
                }
                return isValid;
            },
            success: function (result) {
                parent.$.messager.progress('close');
                result = $.parseJSON(result);
                if (result.success) {
                	parent.$.messager.alert('${internationalConfig.成功}', result.msg, 'success');
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
                }
            }
        });
    });
</script>
<div class="easyui-layout" data-options="fit:true,border:false" style="width: 800px; height: 600px">
    <div data-options="region:'center',border:true" title="" style="overflow: hidden;">
        <form id="form" method="post">
            <table class="table table-hover table-condensed" style="width: 100%; height: 100%">
            	<tr>
            		<td><input name="id" type="hidden" value="${empty resource ? 0 : resource.id}"/></td>
            	</tr>
                <tr>
                    <th>${internationalConfig.消息标题}</th>
                    <td><input name="title" class="easyui-validatebox" type="text" value="${resource.title}" data-options="required:true"></td>
                    <th>${internationalConfig.消息描述}</th>
                    <td>
                       <input name="description" class="easyui-validatebox" type="text" value="${resource.description}">
                    </td>
                </tr>
				<tr>
					<th>${internationalConfig.序列号}</th>
					<td><input name="windex" type="text" value="${resource.windex}"></td>
					<th>${internationalConfig.图片地址}</th>
					<td><input name="picurl" type="text" value="${resource.picurl}"></td>
				</tr>
				<tr>
					<th>${internationalConfig.图文连接}</th>
					<td colspan="3"><input name="descripturl" type="text" value="${resource.descripturl}"></td>
				</tr>
            </table>
        </form>
    </div>
</div>
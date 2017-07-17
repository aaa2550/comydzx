<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');
        $('#form').form({
            url: '/weixin/menu_add.json',
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
                    <th>${internationalConfig.菜单名称}</th>
                    <td><input name="name" class="easyui-validatebox" type="text" data-options="required:true"></td>
                    <th>${internationalConfig.菜单级别}</th>
                    <td>
                       <input name="mlevel" id="mlevel" class="easyui-validatebox" type="radio" value="1" data-options="required:true" checked="checked"/>${internationalConfig.一级菜单}
                       <input name="mlevel" id="mlevel" class="easyui-validatebox" type="radio" value="2" data-options="required:true"/>${internationalConfig.二级菜单}
                    </td>
                </tr>
                <tr>
                	<th>${internationalConfig.菜单类型}</th>
                	<td>
                		<input name="type" id="type" class="easyui-validatebox" type="radio" value="1" data-options="required:true" checked="checked"/>click
						<input name="type" id="type" class="easyui-validatebox" type="radio" value="2" data-options="required:true"/>view
                	</td>
					<th>${internationalConfig.菜单}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>KEY</th>
                   	<td><input name="key" type="text"></td>
                </tr>
                <tr>
                	<th>${internationalConfig.菜单}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>URL</th>
                	<td><input name="url" type="text"></td>
                   	<th>${internationalConfig.状态}</th>
                   	<td>
                    <input name="status" class="easyui-validatebox" type="radio" value="0" data-options="required:true" checked="checked"/>${internationalConfig.有效}
                    <input name="status" class="easyui-validatebox" type="radio" value="1" data-options="required:true"/>${internationalConfig.失效}
                    </td>
                </tr>
                <tr>
                	<th>${internationalConfig.序列号}</th>
                	<td><input name="windex" type="text" class="easyui-validatebox" data-options="required:true"></td>
                   	<th></th>
                   	<td>
                 	</td>
                </tr>
            </table>
        </form>
    </div>
</div>
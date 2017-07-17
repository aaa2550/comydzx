<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');
        $('#form').form({
            url: '${pageContext.request.contextPath}/income_channel/edit/submit.json',
            onSubmit: function () {
                parent.$.messager.progress({
                    title: '提示',
                    text: '数据处理中，请稍后....'
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
				if (result.code == 0) {
					parent.$.messager.alert('成功', result.msg, 'success');
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');
					parent.$.modalDialog.handler.dialog('close');
				} else {
					parent.$.messager.alert('错误', result.msg,'error');
				}
            }
        });
    });
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="">
        <form id="form" method="post">
            <input type="hidden" value="${channel.id}" name="id"/>
            <table class="table table-form">
				<colgroup>
					<col width="70">
					<col width="200">
					<col width="70">
					<col width="*">
				</colgroup>
                <tr>
                    <th>渠道ID</th>
                    <td>
                        ${channel.id}
                    </td>
                    <th>更新时间</th>
                    <td>
                        ${channel.updateTime}
                    </td>
                </tr>
                <tr>
                    <th>渠道名称</th>
                    <td>
                        <label>
                            <input type="text" name="channelName" style="width: 150px" class="easyui-validatebox"
                                   data-options="required:true" value="${channel.channelName}"/>
                        </label>
                    </td>
                    <th>渠道状态</th>
                    <td>
                        <label>
                            <select name="status">
                            <c:if test="${channel.status == 0}">
                            		<option value="0" selected="selected">正常</option>
                                    <option value="1">失效</option>
                            </c:if>  
                             <c:if test="${channel.status == 1}">
                            		<option value="0">正常</option>
                                    <option value="1" selected="selected">失效</option>
                            </c:if>                                        
                            </select>
                        </label>
                    </td>
                </tr>
                <tr>
                    <th colspan="4">
                        添加模块
                    </th>
                </tr>
                <tr>
                    <th>
                       模块名称
                    </th>
                    <td>
                        <label>
                            <input name="moduleName"  class="easyui-validatebox"/>
                        </label>
                    </td>
                    <th>
                       模块模式
                    </th>
                    <td>
                        <label>
                            <input name="urlPattern" title="ref=xxxx" data-options="required:true"/>(ref=xxx)
                        </label>
                    </td>
                </tr>
                <tr>
                    <th>站内站外</th>
                    <td>
                        <label>
                            <select name="siteFlag" title="ex:360,baidu为站外">
                                <option value="0">站内</option>
                                <option value="1">站外</option>
                            </select>
                        </label>
                    </td>
                    <td></td>
                    <td></td>
                </tr>
            </table>
        </form>
    </div>
</div>
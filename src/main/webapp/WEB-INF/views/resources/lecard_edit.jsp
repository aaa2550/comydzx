<%--
  Created by IntelliJ IDEA.
  User: kangxiongwei3
  Date: 2016/5/10
  Time: 15:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/inc/jstl.inc" %>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false">
        <form id="form" method="post" action="/lecard/lecard_edit">
            <table style="width: 100%" class="table">
                <tr>
                    <th>${internationalConfig.乐卡编号}</th>
                    <td><input name="number" type="text" readonly value="${number}" class="span2" /></td>
                </tr>
                <tr>
                    <th>${internationalConfig.用户ID}</th>
                    <td><input name="uid" type="text" class="easyui-validatebox span2" data-options="required:true" /></td>
                </tr>
                <tr>
                    <th>${internationalConfig.状态}</th>
                    <td>
                        <select name="flag" class="easyui-validatebox, span2" data-options="required:true">
                            <option value="1">${internationalConfig.未使用}</option>
                            <option value="2">${internationalConfig.已使用}</option>
                        </select>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');
        $('#form').form({
            url: '${pageContext.request.contextPath}/lecard/lecard_edit',
            onSubmit: function () {
                parent.$.messager.progress({
                    title: '${internationalConfig.提示}',
                    text: '${internationalConfig.数据处理中}....'
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
                    parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.操作成功}', 'success');
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
                }
            }
        });
    });
</script>


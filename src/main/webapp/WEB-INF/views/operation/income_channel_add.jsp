<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');
        $('#form').form({
            url: '${pageContext.request.contextPath}/income_channel/add/submit.json',
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
            <table class="table table-form">
				<colgroup>
					<col width="70">
					<col width="*">
				</colgroup>
                <tr>
                    <th>渠道名称</th>
                    <td>
                        <label>
                            <input type="text" name="channelName" style="width: 150px" class="easyui-validatebox"
                                   data-options="required:true"/>
                        </label>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<script type="text/javascript">
    $(function () {
    	parent.$.messager.progress('close');
        $('#form').form({
            url: '${pageContext.request.contextPath}/tj/mobileChannel/mchannel/create',
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
            success: function (obj) {
                parent.$.messager.progress('close');
                var result = $.parseJSON(obj);
                if (result.status == 0) {
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    parent.$.messager.alert('页面错误', result.message, 'error');
                }
            }
        });
    });
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="" style="overflow: hidden;">
        <form id="form" method="post" action="${pageContext.request.contextPath}/tj/mobileChannel/mchannel/create">
            <table style="margin:5px; margin-top:30px" class="table-hover table-condensed">
				<tr>
					<th>动作类型:</th>
					<td><select id="actCode" name="actCode"
						style="width: 160px">
							<option value="0" selected="selected">点击</option>
							<option value="17">推荐点击</option>
							<option value="19">曝光</option>
							<option value="25">推荐曝光</option>
					</select></td>
					<th>统计分类:</th>
					<td>
						<select name="fmFlag" style="width: 160px" id="orderone">
                            <option value="0" selected="selected">fragid</option>
                            <option value="1">name</option>
                        </select>
					</td>
				</tr>
				<tr></tr>

				<tr>
					<th>pageid:</th>
					<td><input type="text" name="actPageid" style="width: 160px"
						class="easyui-validatebox" data-options="required:true" /></td>
					<th>fl:</th>
					<td><input type="text" name="actFl" style="width: 160px"
						class="easyui-validatebox" data-options="required:true" />
					</td>
				</tr>
				<tr>
					<th>fragid or name:</th>
					<td><input type="text" name="actFragidName" style="width: 160px"
						class="easyui-validatebox" data-options="required:false" />
					</td>

					<th>wz:</th>
					<td><input type="text" name="actWz" style="width: 160px"
						class="easyui-validatebox" data-options="required:false" />
					</td>
				</tr>
				<tr>
					<th>渠道名称:</th>
					<td><input type="text" name="channelName" style="width: 250px"
						class="easyui-validatebox" data-options="required:true" />
					</td>
				</tr>
				<tr><td><input value="${sessionInfo.name}" name="author" type="hidden" /><td></tr>
			</table>
        </form>
    </div>
</div>
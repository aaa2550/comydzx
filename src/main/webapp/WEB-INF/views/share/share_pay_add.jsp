<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');
        $('#form').form({
            url: '${pageContext.request.contextPath}/share_pay_config/add_submit.json',
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
				} else {
					parent.$.messager.alert('错误', result.msg,'error');
				}
				parent.$.modalDialog.openner_dataGrid.datagrid('reload');
				parent.$.modalDialog.handler.dialog('close');
            }
        });
    });

</script>
<div class="easyui-layout" data-options="fit:true,border:false" style="width: 1000px; height: 650px">
    <div data-options="region:'center',border:true" title="" style="overflow: hidden;">
        <form id="form" method="post">
            <table class="table table-hover table-condensed" style="width: 100%; height: 100%">
                <tr>
                    <th>专辑id</th>
                    <td><input name="albumId" type="text" id="albumId">
                    </td>
                </tr>
                <tr>
                    <th>付费分成时间</th>
                    <td>
                        <input type="text" name="payBeginTime" id="payBeginTime" class="easyui-datebox" style="width:100px"/>
                         ~
                         <input type="text" name="payEndTime" id="payEndTime" class="easyui-datebox" style="width:100px"/>
                    </td>
                </tr>
                 <tr>
                    <th>分成单价</th>
                    <td><input name="price" type="text" id="price">
                    </td>
                </tr>
                <tr>
                    <th>会员播放定义</th>
                    <td>播放
                    	<select name="effectiveMinute">
			            	<c:forEach items="${effectiveMinutes}" var="minuteTemp">
                    			<option value="${minuteTemp}">${minuteTemp}</option>
							</c:forEach>
						</select> 分钟后就算
                    </td>
                </tr>
                <tr>
                    <th>付费分成系数</th>
                    <td>
                      <input type="text" name="ratio" id="ratio" value='0' />
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="easyui-layout" data-options="fit:true,border:false" style="width: 800px; height: 600px">
    <div data-options="region:'center',border:true" title="">
        <form id="form" method="post">
        	<input type="hidden" name="id" value="${movieChannel.id}" >
            <table style="width: 100%;" class="table table-form">
				<colgroup>
					<col width="111">
					<col width="230">
					<col width="70">
					<col width="*">
				</colgroup>
                <tr>
                    <th>${internationalConfig.频道}：</th>
                    <td>
                    	<input type="text" value="${movieChannel.channelName}" readonly="readonly" >
                    </td>
                    <th>${internationalConfig.价格}：</th>
					<td><input type="text" name="price" class="easyui-validatebox" value="${movieChannel.price }"
						data-options="required:true,validType:'number'" /></td>
                </tr>
                <tr>
                    <th>${internationalConfig.付费类型}：</th>
                    <td>
                        <%-- <input name="chargeType" type="radio" value="0" <c:if test="${movieChannel.chargeType == 0}"> checked="checked" </c:if> />点播 --%>
                        <input name="chargeType" type="radio" value="1" <c:if test="${movieChannel.chargeType == 1}"> checked="checked" </c:if>/>${internationalConfig.点播且包月}
                        <input name="chargeType" type="radio" value="2" <c:if test="${movieChannel.chargeType == 2}"> checked="checked" </c:if>/>${internationalConfig.包月}
                        <%-- <input name="chargeType" type="radio" value="3" <c:if test="${movieChannel.chargeType == 3}"> checked="checked" </c:if>/>免费但TV包月收费 --%>
                        <%-- <input name="chargeType" type="radio" value="4" <c:if test="${movieChannel.chargeType == 4}"> checked="checked" </c:if>/>包年 --%>
                        <%-- <input name="chargeType" type="radio" value="5" <c:if test="${movieChannel.chargeType == 5}"> checked="checked" </c:if>/>码流付费 --%>
                    </td>
                    <th style="vertical-align: middle;">${internationalConfig.是否收费}：</th>
                    <td>
                       <input name="isCharge" type="radio" value="1" <c:if test="${movieChannel.isCharge == 1}"> checked="checked" </c:if> />${internationalConfig.付费}
                       <input name="isCharge" type="radio" value="0" <c:if test="${movieChannel.isCharge == 0}"> checked="checked" </c:if>/>${internationalConfig.免费}
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
            url: '/movie_channel/update.json',
            onSubmit: function () {
                parent.$.messager.progress({
                    title: '${internationalConfig.提示}',
                    text: '${internationalConfig.数据处理中}....'
                });
                var isValid = $(this).form('validate');
                if (!isValid) {
                    parent.$.messager.progress('close');
                }
                
                if($("#chargeId").val() == 0) {
                	parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.定价方案不能为空}', 'error');
					parent.$.messager.progress('close');
					return false;
                }
                
                return isValid;
            },
            success: function (result) {
                parent.$.messager.progress('close');
                result = $.parseJSON(result);
                if (result.code == 0) {
					parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.编辑成功}', 'success');
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
                }
            }
        });
    });
    
  //增加自定义的表单验证规则
	$.extend($.fn.validatebox.defaults.rules, {
		number : {
			validator : function(value, param) {
				var reg = new RegExp("^[0-9]+(.[0-9]+)?$");
				return reg.test(value);
			},
			message : '${internationalConfig.请输入合法数字}'
		}
	});
	$.extend($.fn.validatebox.defaults.rules, {
		int : {
			validator : function(value, param) {
				var reg = new RegExp("^[0-9]+$");
				return reg.test(value);
			},
			message : '${internationalConfig.请输入合法整数}'
		}
	});
</script>
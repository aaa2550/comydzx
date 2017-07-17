<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');
        $('#form').form({
            url: '${pageContext.request.contextPath}/share_cpm_config/edit_submit.json',
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
        	<input type="hidden" value="${shareCpmConfig.id}" name="id" />
            <table class="table table-hover table-condensed" style="width: 100%; height: 100%">
                <tr>
                    <th>专辑id</th>
                    <td><input name="albumId" type="text" value="${shareCpmConfig.albumId}" readonly="readonly" id="movieId">
                    </td>
                </tr>
                <tr>
                    <th>CPM分成时间</th>
                    <td>
                        <input type="text" name="cpmBeginTime" id="cpmBeginTime"
                               value="<fmt:formatDate pattern="yyyy-MM-dd" value="${shareCpmConfig.cpmBeginTime}"/>"
                               class="easyui-datebox" style="width:100px"/>
                         ~
                         <input type="text" name="cpmEndTime" id="cpmEndTime"
                               value="<fmt:formatDate pattern="yyyy-MM-dd" value="${shareCpmConfig.cpmEndTime}"/>"
                               class="easyui-datebox" style="width:100px"/>
                    </td>
                </tr>
            	<c:forEach items="${terminals}" var="terminal">
	                <tr>
	                	<th>${terminal}端分成价格(元)</th>
	                	<td>
	                         	暂停 <input type="text" name="cpmPricesMap[${terminal}].pausePrice" id="cpmPricesMap[${terminal}].pausePrice" value="${cpmPriceHolder.cpmPricesMap[terminal].pausePrice}" style="width:60px"/>
								&nbsp;5秒  <input type="text" name="cpmPricesMap[${terminal}].fivePrice" id="cpmPricesMap[${terminal}].fivePrice" value="${cpmPriceHolder.cpmPricesMap[terminal].fivePrice}" style="width:60px"/>
								&nbsp;10秒 <input type="text" name="cpmPricesMap[${terminal}].tenPrice" id="cpmPricesMap[${terminal}].tenPrice" value="${cpmPriceHolder.cpmPricesMap[terminal].tenPrice}" style="width:60px"/>
								&nbsp;15秒 <input type="text" name="cpmPricesMap[${terminal}].fifteenPrice" id="cpmPricesMap[${terminal}].fifteenPrice" value="${cpmPriceHolder.cpmPricesMap[terminal].fifteenPrice}" style="width:60px"/>
								&nbsp;30秒 <input type="text" name="cpmPricesMap[${terminal}].thirtyPrice" id="cpmPricesMap[${terminal}].thirtyPrice" value="${cpmPriceHolder.cpmPricesMap[terminal].thirtyPrice}" style="width:60px"/>
								&nbsp;60秒 <input type="text" name="cpmPricesMap[${terminal}].sixtyPrice" id="cpmPricesMap[${terminal}].sixtyPrice" value="${cpmPriceHolder.cpmPricesMap[terminal].sixtyPrice}" style="width:60px"/>
								&nbsp;75秒 <input type="text" name="cpmPricesMap[${terminal}].seventyFivePrice" id="cpmPricesMap[${terminal}].seventyFivePrice" value="${cpmPriceHolder.cpmPricesMap[terminal].seventyFivePrice}" style="width:60px"/>
	                    </td>
	                </tr>
				</c:forEach>
                <tr>
                    <th>CPM分成上限(元)</th>
                    <td>
                      <input type="text" name="upperLimitMoney" id="upperLimitMoney" value="${shareCpmConfig.upperLimitMoney}" />
                    </td>
                </tr>
                 <tr>
                    <th>CPM分成系数</th>
                    <td>
                      <input type="text" name="ratio" id="ratio" value='${shareCpmConfig.ratio}' />
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
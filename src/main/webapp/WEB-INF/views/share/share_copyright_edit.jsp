<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');
        $('#form').form({
            url: '${pageContext.request.contextPath}/share_copyright_config/edit_submit.json',
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
                    <th>版权方</th>
                    <td>
						<input name="copyrightCompany" type="text" value="${shareCopyrightRatio.copyrightCompany}" readonly="readonly" id="shareCopyrightRatioConfig.copyrightCompany">
                    </td>
                </tr>
                <tr>
                    <th>展示系数</th>
                    <td>
                        <input type="text" name="ratio" id="ratio" value="${ratio}" style="width:100px"/>
                    </td>
                </tr>
                <tr>
                    <th>历史修改记录</th>
                    <td>
                    	<div style="position:absolute; height:400px; width:500px; overflow:auto">
                    	<table>
                    		<thead>
                    			<tr>
                    				<td>开始时间</td>
                    				<td>结束时间</td>
                    				<td>版权系数</td>
                    				<td>修改时间</td>
                    				<td>操作人</td>
                    			</tr>
                    		</thead>
                    		<tbody>
                    			<c:forEach items="${ratioInfoHolder.sharedPeroidInfos}" var="ratioInfo">
                    				<tr>
                    				<td><fmt:formatDate pattern="yyyy-MM-dd" value="${ratioInfo.beginDay}"/></td>
                    				<td><fmt:formatDate pattern="yyyy-MM-dd" value="${ratioInfo.endDay}"/></td>
                    				<td>${ratioInfo.value}</td>
                    				<td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${ratioInfo.updateTime}"/></td>
                    				<td>${ratioInfo.operateUser}</td>
                    				</tr>
								</c:forEach>
                    		</tbody>
                    	</table>
                    	</div>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');
        $('#form').form({
            url: '${pageContext.request.contextPath}/share_play_config/edit_submit.json',
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
        	<input type="hidden" value="${sharePlayConfig.id}" name="id" />
            <table class="table table-hover table-condensed" style="width: 100%; height: 100%">
                <tr>
                    <th>专辑id</th>
                    <td><input name="albumId" type="text" value="${sharePlayConfig.albumId}" readonly="readonly" id="movieId">
                    </td>
                </tr>
                <tr>
                    <th>播放分成时间</th>
                    <td>
                        <input type="text" name="playBeginTime" id="playBeginTime"
                               value="<fmt:formatDate pattern="yyyy-MM-dd" value="${sharePlayConfig.playBeginTime}"/>"
                               class="easyui-datebox" style="width:100px"/>
                         ~
                         <input type="text" name="playEndTime" id="playEndTime"
                               value="<fmt:formatDate pattern="yyyy-MM-dd" value="${sharePlayConfig.playEndTime}"/>"
                               class="easyui-datebox" style="width:100px"/>
                    </td>
                </tr>
                <tr>
                    <th>PC端分成单价(元/千次)</th>
                    <td><input name="pcPrice" type="text" id="pcPrice" value = "${sharePlayConfig.pcPrice}"></td>
                </tr>
                <tr>
                    <th>移动端分成单价(元/千次)</th>
                    <td><input name="mobilePrice" type="text" id="mobilePrice" value= "${sharePlayConfig.mobilePrice}"></td>
                </tr>
                <tr>
                    <th>TV端分成单价(元/千次)</th>
                    <td><input name="tvPrice" type="text" id="tvPrice" value="${sharePlayConfig.tvPrice}"></td>
                </tr>
                
               <tr>
                    <th>有效播放定义</th>
                    <td>播放
                    	<select name="effectiveMinute">
			            	<c:forEach items="${effectiveMinutes}" var="minuteTemp">
                    			<option value="${minuteTemp}" 
                    				<c:if test="${minuteTemp==effectiveMinute}">  selected="selected"</c:if>
                    			>
                    			${minuteTemp}
                    			</option>
							</c:forEach>
						</select> 分钟后就算
                    </td>
                </tr>
                <tr>
                    <th>历史修改记录</th>
                    <td>
                    <div style="position:absolute; height:100px; width: 500px; overflow:auto">
                    	<table>
                    		<thead>
                    			<tr>
                    				<td>开始时间</td>
                    				<td>结束时间</td>
                    				<td>有效播放分钟</td>
                    				<td>修改时间</td>
                    				<td>操作人</td>
                    			</tr>
                    		</thead>
                    		<tbody>
                    			<c:forEach items="${mintuesInfoHolder.sharedPeroidInfos}" var="mintueInfo">
                    				<tr>
                    				<td><fmt:formatDate pattern="yyyy-MM-dd" value="${mintueInfo.beginDay}"/></td>
                    				<td><fmt:formatDate pattern="yyyy-MM-dd" value="${mintueInfo.endDay}"/></td>
                    				<td>${mintueInfo.value}</td>
                    				<td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${mintueInfo.updateTime}"/></td>
                    				<td>${mintueInfo.operateUser}</td>
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
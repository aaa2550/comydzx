<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script type="text/javascript" src="/static/lib/activityBuysend.js" charset="utf-8"></script>
<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');
        $('#form').form({
            url: '${pageContext.request.contextPath}/activity/buysend/addSubmit.json',
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
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="">
        <form id="form" method="post" action="${pageContext.request.contextPath}/activity/buysend/addSubmit.json">
            <table class="table table-hover table-condensed" style="width: 100%; height: 100%">
                <tr>
                    <th>活动名称</th>
                    <td><input name="name" type="text" id="name">
                    </td>
                    <th>活动状态</th>
                    <td><select name="status" style="width:80px">
                    		<option value="1">上线</option>
                    		<option value="0">下线</option>
                    	</select>
                    </td>
                </tr>
                <tr>
                    <th>活动目的</th>
                    <td>
                        <input type="text" name="purpose" id="purpose" style="width:200px"/>
                    </td>
                </tr>
                 <tr>
                    <th>活动时间</th>
                    <td>
                        <input type="text" name="startTime" id="startTime" class="easyui-datetimebox" style="width:100px"/>
                         ~
                         <input type="text" name="endTime" id="endTime" class="easyui-datetimebox" style="width:100px"/>
                    </td>
                </tr>
                <tr>
                    <th>活动方式</th>
                    <td>
                    	<select name="activityMode">
			            	<c:forEach items="${activityModes}" var="activityMode">
                    			<option value="${activityMode.value}">${activityMode.description}</option>
							</c:forEach>
						</select>
                    </td>
                    <th>是否支持乐点</th>
                    <td>
                    	<input name="isSupportLedian" class="easyui-validatebox" type="radio" value="1" data-options="required:true" checked="checked"/>支持
                    	<input name="isSupportLedian" class="easyui-validatebox" type="radio" value="0" data-options="required:true"/>不支持
                    </td>
                </tr>
                <tr>
                    <th>活动模板</th>
                    <td>
                    	<select name="templateId">
			            	<c:forEach items="${templates}" var="template">
                    			<option value="${template.templateId}">${template.name}</option>
							</c:forEach>
						</select>
                    </td>
                </tr>
                <tr>
                    <th>推广终端</th>
                    <td>
                    	<c:forEach items="${terminals}" var="terminal">
                    	<input type="checkbox"
										name="terminals" value="${terminal.terminalId}" />&nbsp${terminal.terminalName}
						</c:forEach>
                    </td>
                </tr>
                 <tr>
                    <th>与其他活动互斥/th>
                    <td>
                    	<input name="isExclusion" class="easyui-validatebox" type="radio" value="1" data-options="required:true" checked="checked"/>否
                    	<input name="isExclusion" class="easyui-validatebox" type="radio" value="0" data-options="required:true"/>是
                    	<select name="exclusionIds" multiple="multiple">
                    		<option value="-1">选择</option>
                    		<option value="0">全部</option>
                    		<c:forEach items="${activityIds}" var="activityId">
                    			<option value="${activityId}">活动Id${activityId}</option>
                    		</c:forEach>
                    	</select>
                    </td>
                </tr>
            </table>
            
			<table id="addPartQualification" style="width: 780" class="table table-form">
            	<tr><td><a href="javascript:void(0)" onclick="addRowPartQualification();">新增参与资格</a></td></tr>
            	<tr><th>主套餐类型</th><th>子套餐类型</th><th>套餐明细</th><th>活动期间参与次数</th><th>对应赠品</th><th>操作</th></tr>            	   
			</table>
            
			<table id="addPopupType" style="width: 780" class="table table-form">
            	<tr><td><a href="javascript:void(0)" onclick="addRowPopupType();">新增弹窗类型</a><td></tr>
            	<tr><th>需弹窗类型</th><th>弹窗样式</th><th>弹窗文案</th><th>左按钮文案</th><th>右按钮文案</th><th>操作</th></tr>            	
            	</table>			
        </form>
    </div>
</div>
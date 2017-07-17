<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script type="text/javascript">

    $(function () {
        parent.$.messager.progress('close');
        $('#form').form({
        	
        	
            url: '/activity_pop_config/createOrUpdate.json',
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
                if (result.code==0) {
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
                    parent.$.modalDialog.handler.dialog('close');
                    var batch = result.msg;
                } else {
                    parent.$.messager.alert('页面错误', result.msg, 'error');
                }
            }
        });
    });

</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title=""
		style="overflow: auto;">
		<form id="form" method="post"
			action="/activity_pop_config/create.json" class="easyui-form">
			<table style="margin-left: 30px; margin-top: 20px" class = "recommend-dialog-add">
				<tr class="pannel-tr pannel-with-out">
					<c:if test="${not empty activityPopConfig}">
					
						<td  class="pannel-td">
							<span class="content-sp" >项目名称</span>
						 	<input type="text" title="" name="title" style="width: 150px" class="easyui-validatebox" value="${activityPopConfig.title }" data-options="required:true">
						</td>
						<td  class="pannel-td">
							<span class="content-sp">项目ID</span>
							<input type="text" name="id" style="width: 150px" value="${activityPopConfig.id }" class="easyui-validatebox">
						</td>
					</c:if>
					<c:if test="${empty activityPopConfig}">
					
						<td  class="pannel-td" colspan="2">
							<span class="content-sp" >项目名称</span>
						 	<input type="text" title="" name="title" style="width: 150px" class="easyui-validatebox" value="${activityPopConfig.title }" data-options="required:true">
						</td>
					</c:if>
					
				</tr>
                <tr class="pannel-tr pannel-with-out" >
			  		<td class="pannel-td">
			  		 	<span class="content-sp">失效日期</span>
                        <input type="text" class="easyui-datebox datebox-f combo-f textbox-f" data-options="required:true" style="width: 165px; display: none;" id="expireTime" name="expireTime" textboxname="expireTime" comboname="expireTime" value="${activityPopConfig.expireTime }">
                    </td>
					<td style="padding-right:20px" class="pannel-td"> 
						<span class="content-sp">权重</span>
						<input type="text" data-options="required:true" class="easyui-validatebox"  value="${activityPopConfig.weight }" style="width: 150px" name="weight">
					</td>
				</tr>
				<tr class="pannel-tr" >
					<td  class="pannel-td">
						<span class="content-sp">大图片链接</span> 
						<input type="text" data-options="required:true" class="easyui-validatebox" style="width: 150px" name="popPicBigAddress" value="${activityPopConfig.popPicBigAddress }">
					</td>
					<td  class="pannel-td">
						<span class="content-sp">大图片链接到</span> 
						<input type="text" data-options="required:true" class="easyui-validatebox" style="width: 150px" name="popPicBigLink" value="${activityPopConfig.popPicBigLink }">
					</td>
				</tr>
				<tr class="pannel-tr" >
					<td  class="pannel-td">
						<span class="content-sp">按钮名称</span> 
						<input type="text" data-options="required:true" class="easyui-validatebox" style="width: 150px" name="popButtonName" value="${activityPopConfig.popButtonName }">
					</td>
					<td  class="pannel-td">
						<span class="content-sp">按钮跳转到</span> 
						<input type="text" data-options="required:true" class="easyui-validatebox" style="width: 150px" name="popButtonLink" value="${activityPopConfig.popButtonLink }">
					</td>
				</tr>
				<tr class="pannel-tr pannel-with-in" >
					<td  class="pannel-td" colspan="2">
						<span class="content-sp" >弹窗次数</span>
						<input type="text" data-options="required:true" class="easyui-validatebox" style="width: 150px" name="popCount" value="${activityPopConfig.popCount }">
					</td>
				</tr>
			
            </table>
        </form>
    </div>
</div>
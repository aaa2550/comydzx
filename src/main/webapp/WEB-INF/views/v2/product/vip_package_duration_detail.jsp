<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<%@ include file="/WEB-INF/views/inc/jstl.inc"%>

<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
	
		var dedefineTime=$(".defineTime_box").find('.defineTime').clone(true);
	      
	      var dedefineTimeBox=$(".defineTime_box");
	      dedefineTimeBox.find('.defineTime').eq(1).remove();
	      
	      <%--$("input[name='durationType']").click(function(){
	        dedefineTimeBox.html('');
	        var index=$(this).index();
	        console.log($(dedefineTime).eq(index));
	        $(dedefineTime).eq(index).appendTo(dedefineTimeBox);
	        dedefineTimeBox.find('input').validatebox({
	        	require:true
	        });
	        
	      }) 
		$("input[name='durationType']:checked").get(0).click();--%>
		 $('#form').form({
			url : '/v2/product/vipDuration/save',
			onSubmit : function() {
			
				parent.$.messager.progress({
					title : '${internationalConfig.提示}',
					text : '${internationalConfig.数据处理中}....'
				});
				
				var isValid = $(this).form('validate');
				if (!isValid) {
					parent.$.messager.progress('close');
				}
				return isValid;
			},
			success : function(result) {
				parent.$.messager.progress('close');
				result = $.parseJSON(result);
				if (result.code == 0) {
                	parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.添加成功}', 'success');
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
					parent.$.modalDialog.handler.dialog('close');
				} else {
					parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
				}
			}
		});
	});


	$.extend($.fn.validatebox.defaults.rules, {
		specificNo : {
			validator : function(value, param) {
				var reg = new RegExp("^\\s*[0-9]*[1-9][0-9]*\\s*$");
				console.log(reg.test(value))
				return reg.test(value);
			},
			message : '${internationalConfig.请输入合法整数}'
		}
	});
	
  /* //校验套餐时长名称是否存在
  function isExistDuration(){
		 var durationName = document.getElementById("durationName").value;
		//去除前后空白
		 durationName = $.trim(durationName);
		 if(durationName == "")
		 {
			 $("#message").html(" 名称不能为空");
		 	return;
		 }
		 $.ajax({
		 		type: "POST",    
		         url: "/v2/product/vipDuration/ajaxQueryDurationName",    
		         data: "durationName="+durationName, 
		         success: function(data){
			    if(data=="true" || data==true){   
			    	$("#message").html("");  
			    }else{   
			    	$("#message").html(" 该名称已存在");  
		    	} 
		  		}          
		        });   
		} */
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post"
			action="/mealController/create">
			<table style="width: 100%" class="table table-form">
				<colgroup>
					<col width="90">
					<col width="140">
					<col width="*">
				</colgroup>
				<input type="hidden" name="id" value="${packageDurationInfo.id}"/>
				<tr>
					<th><b style="color: red">*</b>${internationalConfig.套餐时长名称}</th>
					<td><input type="text" id= "durationName"  name="durationName" value="${packageDurationInfo.durationName}" class="easyui-validatebox"
						data-options="required:true,"/> <span id="message" style="color: red;font-size: 12px"></span></td>
				</tr>

				<%--<tr>
					<th><b style="color: red">*</b>${internationalConfig.时长类型}</th>
					<td>
						<input name="durationType" checked='checked' <c:if test="${packageDurationInfo.durationType==2}">checked='checked'</c:if>  value="2" type="radio">${internationalConfig.按自然2}&nbsp;&nbsp;<input name="durationType" <c:if test="${packageDurationInfo.durationType=='1'}">checked="checked"</c:if> type="radio" value="1">${internationalConfig.按自定义日}
					</td>
				</tr>--%>
				
				<tr>
					<th><b style="color: red">*</b>${internationalConfig.时长定义}</th>
					<td>
						<div class="defineTime_box">
							<div class="defineTime" >
								<input name="durationType" type="hidden" value="2">
								<input class="duration_1" type="text" name="duration" value="${packageDurationInfo.duration}" class="easyui-validatebox" data-options="required:true" validType="specificNo" style='width:50px; height:15px;'/>&nbsp;&nbsp;&nbsp;
								<select class='field_1' name="field" style="width:100px;">
								<c:choose>
									<c:when test="${packageDurationInfo.field == 'year'}">
									    <option value="year" selected="selected">${internationalConfig.年}</option>
										<option value="month">${internationalConfig.月}</option>
										<option value="date">${internationalConfig.日}</option>
									</c:when>
									<c:when test="${packageDurationInfo.field == 'month'}">
									    <option value="year">${internationalConfig.年}</option>
										<option value="month" selected="selected">${internationalConfig.月}</option>
										<option value="date">${internationalConfig.日}</option>
									</c:when>
									<c:when test="${packageDurationInfo.field == 'date'}">
									    <option value="year">${internationalConfig.年}</option>
										<option value="month">${internationalConfig.月}</option>
										<option value="date" selected="selected">${internationalConfig.日}</option>
									</c:when>
									<c:otherwise>
									     <option value="year">${internationalConfig.年}</option>
										<option value="month">${internationalConfig.月}</option>
										<option value="date">${internationalConfig.日}</option>
									</c:otherwise>
								</c:choose>
	
								</select>
							</div>
							<div class="defineTime" style="display:block;">
	
								<input class="duration_1" name="duration" type="text" class="easyui-validatebox" data-options="required:true" value='${packageDurationInfo.duration}' validType="specificNo" style='width:50px; height:15px;'/>${internationalConfig.天}&nbsp;&nbsp;&nbsp;
								<input class='field_1' type="hidden" name="field" value="date" class="easyui-validatebox" data-options="required:true" style='width:50px; height:15px;'/>
	
							</div>
						</div>
						
					</td>
					
				</tr>
				
			</table>
		</form>
	</div>
</div>
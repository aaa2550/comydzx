<%@page import="jmind.core.security.MD5"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post">
			<table class="table table-form" style="width:100%">
				<tr>
					<td >
						<span>${internationalConfig.规则名称}：</span>
						<input name="id" type="hidden"  value="${channel.id }">
						<input name="name" type="text" class="easyui-validatebox span2"  value="${channel.name }">
					</td>
					<td>
						<span>${internationalConfig.销售渠道}：</span>
						<select name="channel" style="height:30px;width:140px;">		
							<c:forEach items="${ channels}" var="item">
								<option value="${item.id }"    ${item.id==channel.channel ? "selected" : "" } >${item.name }</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>					
					<td >
						<span>${internationalConfig.申请人}：</span>
						<input type="text"  name="principal"  value="${channel.principal }"/>
					</td>
					<td >
						<span>${internationalConfig.生效时间}：</span>
						<input type="text" name="effectiveDate"  style="width: 140px;height:30px;" class="easyui-datebox" class="easyui-validatebox"   value="${channel.effectiveDate }"/>
					</td>
				</tr>
				<tr>
					<td colspan="2">${internationalConfig.结算模板配置}</td>
				</tr>
				<c:forEach items="${statementType }"  var="item">
					<tr data-type="${item.type }">		
						<td ><span><input type="checkbox"  name="type"   value="${item.type }"   ${  templates[item.type].type==item.type ? "checked" : ""  } ></span>${item.desc }  ${templates[item.type].templateId }</td>
						<td><input type="radio"  name="${item.type }-templateId"   value="1"   ${  templates[item.type].templateId==1 ? "checked" : ""  } >${internationalConfig.模板}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>A &nbsp;&nbsp;&nbsp;&nbsp;<input type="radio"  name="${item.type }-templateId"  ${  templates[item.type].templateId==2 ? "checked" : ""  }  value="2">${internationalConfig.模板}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>B</td>
		     		</tr>
		     	<tr  style="display:none" class="temp-${item.type }"  data-temp="1">
					 <td colspan="2">
						 <div >
							 <span class="">${internationalConfig.每张卡分成金额}：</span> <input name="${item.type }-1-price"  class="easyui-numberbox"	data-options="min:0,max:1000,precision:0,width:80,height:30"   value="${  templates[item.type].price   }">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							 <span>${internationalConfig.分成有效期}：</span><input name="${item.type }-1-effectiveDays"   class="easyui-numberbox" 	data-options="min:0,max:1000,precision:0,height:30"  value="${ templates[item.type].effectiveDays }" > <font color="red">${internationalConfig.距设备首次激活时间}</font>
						 </div>
					 </td>
				 </tr>
				 <tr class="temp-${item.type }"  style="display:none" data-temp="2">
					 <td colspan="2">
						 <div  >
							 <span> ${internationalConfig.每订单分成比例}：</span><input name="${item.type }-2-price" class="easyui-numberbox" 	data-options="min:0,max:1,precision:2,width:80,height:30"  value="${  templates[item.type].price   }">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							 <span>${internationalConfig.分成有效期}：</span><input name="${item.type }-2-effectiveDays" class="easyui-numberbox" 	data-options="min:0,max:1000,precision:0,height:30"  value="${ templates[item.type].effectiveDays }" > <font color="red">${internationalConfig.距设备首次激活时间}</font>
						 </div>
						 <div  class="templateId_2" style="margin-top:10px;" >
						 	<span>${internationalConfig.冲抵回溯期}：</span> <input name="${item.type }-2-recallDays"   class="easyui-numberbox" 	data-options="min:0,max:1000,precision:0,height:30" value="${  templates[item.type].recallDays   }">  <font color="red">${internationalConfig.订单退款冲抵回溯时限}</font>
						 </div>
					</td>
				</tr>
				</c:forEach>
			</table>
		</form>
	</div>
</div>
<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form')
				.form(
						{
							url : '/rebate//settlement/edit',
							onSubmit : function() {
								parent.$.messager.progress({
									title : '${internationalConfig.提示}',
									text : '${internationalConfig.数据处理中}'
								});
								var isValid = $(this).form('validate');
								if (!isValid) {
									parent.$.messager.progress('close');
								}
								// alert(isValid);
								return isValid;
							},
							success : function(result) {
								parent.$.messager.progress('close');
								result = $.parseJSON(result);
								if (result.code == 0) {
									parent.$.messager.alert('${internationalConfig.成功}', result.msg, 'success');
									parent.$.modalDialog.openner_dataGrid.datagrid('reload');
									parent.$.modalDialog.handler.dialog('close');
								} else {
									parent.$.messager.alert('${internationalConfig.错误}', result.msg,'error');
								}
							}
						});
	});
	
	
	
$(":radio").on("click",function(){
	var t=$(this).val();
	var type=$(this).parents("tr").data("type");
	$(".temp-"+type).each(function(){
		if($(this).data("temp")==t){
			$(this).show();
		}else{
			$(this).hide();
		}
	});
});
	
$(":radio[checked]").each(function(){
	var t=$(this).val();
	var type=$(this).parents("tr").data("type");
	$(".temp-"+type).each(function(){
		if($(this).data("temp")==t){
			$(this).show();
		}else{
			$(this).hide();
		}
	});
});
</script>
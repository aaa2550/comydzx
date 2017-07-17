<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script src="/static/lib/swfupload/swfupload.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" src="/static/lib/uploadImg.js?v=20150408.01" charset="utf-8"></script>

<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form').form({
			url : '${pageContext.request.contextPath}/play_package/update.json',
			onSubmit : function() {
				//去除两个默认checkbox的disabled属性，让后台能够得到这两个值
				$("#feature30").attr("disabled", false);
				$("#feature31").attr("disabled", false);
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
	
	//终端设备联动
    $(function(){
    	$("#matchid").change(function(){
    		var matchid = $("#matchid").val();
    		$
    				.ajax({
    					url : "/play_package/get_match_info.json",
    					data : {
    						'pid' : matchid
    					},
    					success : function(result) {
    						var directIndex = null;
    						var optionsHtml = "";
    						$("#itemid").empty();
    						for (directIndex in result) {
    							var directModel = result[directIndex];
    							var optionHtml = '<option value="'+directModel.id+'">'
    									+ directModel.description + '</option>';
    							optionsHtml += optionHtml;
    						}
    						var optionhtml = '<option value="-1" selected="selected">${internationalConfig.全部}</option>';
                            optionsHtml += optionhtml;
    						$("#itemid").html(optionsHtml);
    						var optionhtml1 = '<option value="-1" selected="selected">${internationalConfig.全部} </option>';
    						$("#sessionid").html(optionhtml1);
    					},
    					dataType : "json",
    					cache : false
    				});
    			
    		});
          }
    	);
	
  //终端设备联动
    $(function(){
    	$("#itemid").change(function(){
    		var matchid = $("#itemid").val();
    		$
    				.ajax({
    					url : "${pageContext.request.contextPath}/play_package/get_match_info.json",
    					data : {
    						'pid' : matchid
    					},
    					success : function(result) {
    						var directIndex = null;
    						var optionsHtml = "";
    						$("#sessionid").empty();
    						for (directIndex in result) {
    							var directModel = result[directIndex];
    							var optionHtml = '<option value="'+directModel.id+'">'
    									+ directModel.description + '</option>';
    							optionsHtml += optionHtml;
    						}
    						var optionhtml = '<option value="-1" selected="selected">${internationalConfig.全部} </option>';
                            optionsHtml += optionhtml;
    						$("#sessionid").html(optionsHtml);
    					},
    					dataType : "json",
    					cache : false
    				});
    			
    		});
          }
    	);
</script>
<style type="text/css">
#form table tr th{
	vertical-align:middle;
	width:90px;
}
#form table tr td select{
	width:180px;
}
</style>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post"
			action="${pageContext.request.contextPath}/play_package/update.json">
			<input type="hidden" name="packageId" value="${eplPackage.id}" />
			<input type="hidden" name="matchid" value="${eplPackage.matchid}" />
			<input type="hidden" name="itemid" value="${eplPackage.itemid}" />
			<input type="hidden" name="sessionid" value="${eplPackage.sessionid}" />
			<input type="hidden" name="type" value="${eplPackage.type}" />
			<input type="hidden" name="counts" value="${eplPackage.counts}" />
			<input type="hidden" name="rounds" value="${eplPackage.rounds}" />
			<input type="hidden" name="play_number" value="${eplPackage.play_number}" />
			<table style="width: 100%" class="table table-form">
				<colgroup>
					<col width="70">
					<col width="220">
					<col width="95">
					<col width="*">
				</colgroup>
			    <tr>
					<th>${internationalConfig.频道}</th>
					<td>
					<select disabled="disabled">
						<option value="${eplPackage.matchid}" selected="selected">${eplPackage.matchname}</option>
					</select>
					</td>
					<th>${internationalConfig.赛事}</th>
					<td>
					  <select  disabled="disabled">
								<option value=" ${eplPackage.itemid}" selected="selected"> ${eplPackage.itemname}</option>
					  </select>
					</td>
				</tr>
				<tr>
				   <th>${internationalConfig.赛季}</th>
					<td>
					  <select  disabled="disabled">
								<option value="${eplPackage.sessionid}" selected="selected">${eplPackage.sessionname}</option>
					  </select>
					</td>
					<th>${internationalConfig.套餐名称}</th>
					<td>
					<select  disabled="disabled">
						<option value="${eplPackage.type}">${eplPackage.name}</option>
					</select>
					</td>
				</tr>
				<c:if test="${eplPackage.matchid == '09'}">
				<tr id="round_number">
				   <th>${internationalConfig.轮次}</th>
				   <td>
					 <select name="rounds" id="rounds" style="margin-top: 5px" disabled="disabled">
						<option value="${eplPackage.rounds}"> ${internationalConfig.第}${eplPackage.rounds}${internationalConfig.轮次}</option>
					 </select>
					</td>
					<th>${internationalConfig.场次}</th>
					<td>
					<select name="play_number" id="type" disabled="disabled">
						<option value="${eplPackage.play_number}"> ${internationalConfig.第}${eplPackage.play_number}${internationalConfig.场次}</option>
					 </select>
					</td>
				</tr>
				</c:if>
				<tr>
					<th>${internationalConfig.套餐状态}</th>
					<td>
					  <select name="status">
						<c:if test="${eplPackage.status == 0}">
					       <option value="${eplPackage.status}">${internationalConfig.上线}</option>
					       <option value="1">${internationalConfig.下线}</option>
					   </c:if>
					   <c:if test="${eplPackage.status != 0}">
					       <option value="${eplPackage.status}">${internationalConfig.下线}</option>
					       <option value="0">${internationalConfig.上线}</option>
					   </c:if>
					   
					  </select>
					</td>
					<th>${internationalConfig.直播券张数}</th>

					<td>
					<select disabled="disabled">
					            <option value="${eplPackage.counts}" selected="selected">${eplPackage.counts}${internationalConfig.张}</option>
					</select>
					</td>
				</tr>
				<tr>
					<th>${internationalConfig.付费类型}</th>
					<td colspan="3">
						<%--<input name="payType" type="radio" value="1" <c:if test="${eplPackage.payType == 1 }">checked="checked"</c:if> />${internationalConfig.包年及以上免费}
                        <input name="payType" type="radio" value="2" <c:if test="${eplPackage.payType == 2 }">checked="checked"</c:if> />${internationalConfig.包年及以上免费且可单点}--%>
                        <%--<input name="payType" type="radio" value="3" <c:if test="${eplPackage.payType == 3 }">checked="checked"</c:if> />${internationalConfig.会员免费}
                        <input name="payType" type="radio" value="4" <c:if test="${eplPackage.payType == 4 }">checked="checked"</c:if> />${internationalConfig.会员免费且可单点}--%>
                        <input name="payType" type="radio" value="5" <c:if test="${eplPackage.payType == 5 }">checked="checked"</c:if> />${internationalConfig.单点}
                         <%--<input name="payType" type="radio" value="6" <c:if test="${eplPackage.payType == 6 }">checked="checked"</c:if> />${internationalConfig.全屏包年及以上免费且可单点}--%>
                    </td>
				</tr>
				<tr>
					<th>${internationalConfig.原价}：</th>
					<td colspan="3"><input type="text" name="origin_price" class="easyui-validatebox" 	data-options="required:true,validType:'number'" value="${eplPackage.origin_price}" /></td>
				</tr>
				<tr>
					
					<th>VIP${internationalConfig.价格}</th>
					<td><input type="text" name="vip_price" class="easyui-validatebox"
						data-options="required:true,validType:'number'" value="${eplPackage.vip_price}"/></td>
						<th>${internationalConfig.非会员价格}</th>
					<td><input type="text" name="regular_price"
						class="easyui-validatebox"
						data-options="required:true,validType:'number'"  value="${eplPackage.regular_price}"/></td>
				</tr>
				
				<tr id="app_id">
				   <th>APP_PRODUCT_ID</th>
				   <td><input type="text" name="app_product_id" class="easyui-validatebox"
						data-options="required:false" value="${eplPackage.app_product_id}" /></td>
					<th>APP_${internationalConfig.价格}</th>
					 <td><input type="text" name="app_price" class="easyui-validatebox"
						data-options="validType:'number'" value="${eplPackage.app_price}" />
					 </td>
				</tr>
				
				<tr id="ipad_id">
				   <th>IPAD_PRODUCT_ID</th>
				   <td><input type="text" name="ipadProductId" class="easyui-validatebox"
						data-options="required:false" value="${eplPackage.ipadProductId}" /></td>
					<th>IPAD_${internationalConfig.价格}</th>
					 <td><input type="text" name="ipadPrice" class="easyui-validatebox"
						data-options="validType:'number'" value="${eplPackage.ipadPrice}" />
					 </td>
				</tr>

				<tr>
					<th>${internationalConfig.直播卷有效时长}</th>
					<td><input type="text" name="validate_days" class="easyui-validatebox"
						data-options="required:true,validType:'int'" value="${eplPackage.validate_days}" /></td>
						<th>${internationalConfig.赛季结束时间}</th>
					<td><label> <input type="text" name="session_end_time"
							id="expireDate" value="${endTime}" class="easyui-datebox"
							class="easyui-validatebox" data-options="required:true,width:165,height:30" />
					</label></td>
				</tr>
				<tr>
					<th>${internationalConfig.分成比例}：</th>
					<td>
					<input type="text" required="true" name="dividedProportion" 
					class="easyui-numberbox" precision="2" value="<c:if test="${eplPackage.dividedProportion == null}">0.1</c:if><c:if test="${eplPackage.dividedProportion != null}">${eplPackage.dividedProportion}</c:if>" />
					</td>
					<th>${internationalConfig.直播名称}：</th>
					<td><input type="text" name="playName" value="${eplPackage.playName}"
						class="easyui-validatebox" data-options="required:true"/></td>
				</tr>
				<tr>
					<th>${internationalConfig.移动端图片}：</th>
					<td ><input type="text" id="mobileImg" name="mobileImg" value="${eplPackage.mobileImg}"/></td>
					<td>
						<input class="buttoncenter" type="button" value="上传文件" id="mobile_upload_btn" />
					</td>
		            <td><div id="img-mobile" name="img-mobile" ><c:if test="${not empty eplPackage.mobileImg}"><a href="${eplPackage.mobileImg}" target="_blank">${internationalConfig.查看图片}</a></c:if></div></td>
				</tr>
				<tr>
					<th>${internationalConfig.超级移动端图片}：</th>
					<td ><input type="text" id="superMobileImg" name="superMobileImg" value="${eplPackage.superMobileImg}"/></td>
					<td>
						<input class="buttoncenter" type="button" value="上传文件" id="super_mobile_upload_btn" />
					</td>
		            <td><div id="img-super-mobile" name="img-super-mobile" ><c:if test="${not empty eplPackage.superMobileImg}"><a href="${eplPackage.superMobileImg}" target="_blank">${internationalConfig.查看图片}</a></c:if></div></td>
				</tr>
				<tr>
					<th>${internationalConfig.套餐描述}：</th>
					<td colspan="3"><textarea name="playDesc" class="txt-middle">${eplPackage.playDesc}</textarea></td>
				</tr>
			</table>
		</form>
	</div>
</div>
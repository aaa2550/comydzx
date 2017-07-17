<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/WEB-INF/views/inc/jstl.inc"%>

<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$.fn.serializeJson = function() {
			var serializeObj = {};
			var array = this.serializeArray();
			$(array).each(function() { // 遍历数组的每个元素 {name : xx , value : xxx}
				if (serializeObj[this.name]) { // 判断对象中是否已经存在 name，如果存在name
					serializeObj[this.name] += "," + this.value;
				} else {
					serializeObj[this.name] = this.value; // 如果元素name不存在，添加一个属性 name:value
				}
			});
			return serializeObj;
		}

		var value = $("input[name='transferType']:checked").val();
		if(value==1){
			$(".days").val("").attr("disabled",true);
			$(".days").validatebox({
				required: false,
				validType: ''
			});
		}else{
			$(".days").attr("disabled",false);
			$(".days").validatebox({
				required: true,
				validType: 'less'
			});
		}
		$("input[name='transferType']").change(function () {
			var value = $("input[name='transferType']:checked").val();
			if(value==1){
				$(".days").val("").attr("disabled",true);
				$(".days").validatebox({
					required: false,
					validType: ''
				});
			}else{
				$(".days").attr("disabled",false);
				$(".days").validatebox({
					required: true,
					validType: 'less'
				});
			}
		});
		var remainingDays = $("#remainingDays").val();
		if(remainingDays==0){
			var length = $(".window").length;
			for(var i=0;i<length;i++){
				if($($(".window")[i]).is(":visible")){
					$($($(".window")[i]).find(".l-btn-left")[0]).hide();
				}
			}
		}
		/*$(".days").change(function () {
			$(".edit-num").val($(this).val());
		})*/

	});
	//增加自定义的表单验证规则
	$.extend($.fn.validatebox.defaults.rules, {
		less : {
			validator : function(value, param) {
				var time =parseInt($(".lessthan").val());
				return (value<=time);
			},
			message : '${internationalConfig.输入天数小于可转天数}'
		},
		vailUid:{
			validator : function(value, param) {
				return (parseInt(value)!=${param.userId});
			},
			message : '${internationalConfig.转入用户id不能等于转出用户id}'
		}
	});
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post">
				<input type="hidden" name="productId" value="${param.productId}">
			<table style="width: 100%" class="table table-form">
				<tr>
					<th>${internationalConfig.会员名称}：</th>
					<td><input type="text" value="${param.productName}" readonly="readonly" /></td>
					<th>${internationalConfig.通用会员过期时间}：</th>
					<td><input value="<fmt:formatDate value="${endTime}" pattern="yyyy-MM-dd HH:mm:ss"/>" readonly="readonly"/></td>
				</tr>
				<tr>
					<th>${internationalConfig.转出用户id}：</th>
					<td><input type="text" id="virtualUserId" name="virtualUserId" value="${param.userId}" readonly="readonly" /></td>
					<th>${internationalConfig.转入用户id}：</th>
					<td><input type="text" id="realUserId" name="realUserId" class="easyui-validatebox" onkeyup="this.value=this.value.replace(/\D/g,'')" data-options="required:true,validType:'vailUid'"/></td>
				</tr>
				<tr>
					<th>${internationalConfig.可转时间}：</th>
					<td><input type="text" id="remainingDays" class="lessthan" name="jsOpTime" value="${remainingDays}" readonly="readonly"/>${internationalConfig.天}</td>
					<th>${internationalConfig.可转类型}：</th>
					<td>
						<input type="radio" name="transferType" value="1" checked/>${internationalConfig.全转}
						<input type="radio" class="edit-num" name="transferType" value="2" style="margin-left: 20px"/>
						<input type="text" name="transferDays" class="days" style="width: 30px" onkeyup="this.value=this.value.replace(/\D/g,'')" class="easyui-validatebox" data-options="required:true,validType:'less'"/>${internationalConfig.天}
					</td>
				</tr>
				<tr>
					<th>${internationalConfig.自动续费}</th>
					<td colspan="3"><input type="text" value="${param.isSubscribe==2?"yes":"no"}" readonly="readonly" /></td>
				</tr>
				<tr>
					<td colspan="4"><span style="color: red">*</span>${internationalConfig.请注意用户的自动续费状态转移后可能会很快发起扣款请提醒用户}</td>
				</tr>
			</table>
		</form>
	</div>
</div>
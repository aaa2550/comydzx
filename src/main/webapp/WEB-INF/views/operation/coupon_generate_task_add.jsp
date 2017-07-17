<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<script type="text/javascript">
	$.extend($.fn.datebox.defaults.rules,
			{
				gtStartDate : {
					validator : function(value, param) {//
						if (param[0] && value) {
							if (value.length > 10) {
								value = value.substring(0, 10);
							}
							var ed_arr = value.split('-');
							var endDate = new Date(ed_arr[0], ed_arr[1] - 1,
									ed_arr[2]);
							var sDate = $(param[0]).datebox('getValue');
							if (sDate) {
								if (sDate.length > 10) {
									sDate = sDate.substring(0, 10);
								}
								var sd_arr = sDate.split('-');
								var startDate = new Date(sd_arr[0],
										sd_arr[1] - 1, sd_arr[2]).getTime();
								if ((endDate.getTime() - startDate) > 0) {
									return true;
								}
							}
						}
						return false;
					},
					message : "${internationalConfig.结束时间必须大于开始时间或者日期}"
				}
			});
	$(function() {
		parent.$.messager.progress('close');
		$('#form').form({
			url : '${pageContext.request.contextPath}/coupon_generate_task/add.json',
			onSubmit : function() {
				parent.$.messager.progress({
					title : '${internationalConfig.提示}',
					text : '${internationalConfig.数据处理中}'
				});

				var isValid = $(this).form('validate');
				if (!isValid) {
					parent.$.messager.progress('close');
				}
				return isValid;
			},
			success : function(obj) {
				parent.$.messager.progress('close');
				var result = $.parseJSON(obj);
				if (result.success) {
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
					parent.$.modalDialog.handler.dialog('close');
				} else {
					parent.$.messager.alert('${internationalConfig.页面错误}', result.msg, 'error');
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
	$.extend($.fn.validatebox.defaults.rules, {
		amount : {
			validator : function(value, param) {
				var reg = new RegExp("^-?[0-9]+(.[0-9]+)?$");
				return reg.test(value);
			},
			message : '${internationalConfig.请输入合法金额}'
		}
	});
	$.extend($.fn.validatebox.defaults.rules, {
		discount : {
			validator : function(value, param) {
				var reg = new RegExp("^[0-1]+(.[0-9]+)?$");
				return reg.test(value);
			},
			message : '${internationalConfig.请输入合法折扣}'
		}
	});

	//注册按照卡类型进行页面控制的回调方法。
	$('input:radio[name=applyType]').click(function() {
		var value = $(this).val();
		//激活码
		var dhtc = $("#dhtc");
		var sqme = $("#sqme");
		if (value == 1) {
			dhtc.hide();
			sqme.show();
		}
		//兑换码
		if (value == 2) {
			dhtc.show();
			sqme.hide();
		}
	});
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post"
			action="${pageContext.request.contextPath}/coupon_generate_task/add.json">
			<table class="table table-form">
				<colgroup>
					<col width="100">
					<col width="*">
				</colgroup>
				<tr>
					<th>${internationalConfig.代金券名称}</th>
					<td><label> <input type="text" name="name"
							class="easyui-validatebox" data-options="required:true" />
					</label></td>
				</tr>
				<tr>
					<th>${internationalConfig.代金券面额}</th>
					<td><label> <input class="easyui-numberbox"
							data-options="min:1,max:10000,precision:1,required:true"
							type="text" name="amount" />
					</label></td>
				</tr>
				<tr>
					<th>${internationalConfig.有效日期}</th>
					<td><label> <input name="startTime"
							class="easyui-datebox" style="width: 120px"
							data-options="required:true"> <span style="padding: 5px">-</span>
							<input name="endTime" class="easyui-datebox" style="width: 120px"
							data-options="required:true">
					</label></td>

				</tr>
				<tr>
					<th style="vertical-align: text-top">${internationalConfig.使用限制}</th>
					<td>
						<table>
							<tr>
								<td>${internationalConfig.用户限额}: <input class="easyui-numberbox"
									data-options="min:0,max:10000,precision:0,required:false"
									type="text" name="userQuota" />(0${internationalConfig.代表没限制})
								</td>
							</tr>
							<tr>
								<td>${internationalConfig.移动影视会员}: <c:forEach items="${commonPackageInfos}" var="var">
										<input name="commonRules" type="checkbox" value="${var.duration}">${var.description}
									</c:forEach>
								</td>
							</tr>
							<tr>
								<td>${internationalConfig.全屏影视会员}: <c:forEach items="${advancedPackageInfos}"
										var="var">
										<input name="advancedRules" type="checkbox"
											value="${var.duration}">${var.description}
									</c:forEach>
								</td>
							</tr>
							<tr>
								<td>${internationalConfig.电影}: <input name="movieRule" type="checkbox" value="1">${internationalConfig.支持单片}
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<th>${internationalConfig.使用平台}</th>
					<td><c:forEach items="${terminals}" var="var">
							<input name="terminals" type="checkbox" value="${var.terminalId}"> ${var.terminalName }
                        </c:forEach></td>
				</tr>
				<tr>
					<th>${internationalConfig.发放方}</th>
					<td><label> <select name="issuer">
								<c:forEach items="${issuers}" var="var">
									<option value="${var.value}">${var.name}</option>
								</c:forEach>
						</select>
					</label></td>
				</tr>
				<tr>
					<th>${internationalConfig.制定数量}</th>
					<td><label> <input class="easyui-numberbox"
							data-options="min:1,max:500000,precision:0,required:true"
							type="text" name="num" />
					</label></td>
				</tr>
				<tr>
					<th>${internationalConfig.备注}</th>
					<td><label> <textarea name="ext" class="txt-middle"></textarea>
					</label></td>
				</tr>
			</table>
		</form>
	</div>
</div>
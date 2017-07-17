<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<title>XML<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.数据查找工具}</title>
<script type="text/javascript">
	$(function() {
		$('#form').form({
			url : '${pageContext.request.contextPath}/machine_card_donate/update.json',
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
			success : function(result) {
				parent.$.messager.progress('close');
				result = $.parseJSON(result);
				if (result.code == 0) {
                	parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.编辑成功}', 'success');
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
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
	
	function invokeForm() {
		var f = $('#form');
		f.submit();
	}
	
</script>
</head>
<body>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div title="" data-options="region:'center',border:false" class="panel-body panel-body-noheader panel-body-noborder layout-body">
        <form action="" method="post" id="form">
			<input type="hidden" name="phoneNewId" value="1" />
			<input type="hidden" name="phoneRenewId" value="2" />
			<input type="hidden" name="tvNewId" value="3" />
			<input type="hidden" name="tvRenewId" value="4" />
			<h3 class="pz_member_title">${internationalConfig.手机会员}(${internationalConfig.机卡绑定})${internationalConfig.赠送配置}</h3>
			<table class="table table-form table_noborder">
				<tr>
					<th align="left">${internationalConfig.手机会员新购}</th><th align="left">${internationalConfig.手机会员续费}</th>
				</tr>
				<tr>
					<td>
						<input type="checkbox" name="phoneNewDonatePcVip" <c:if test="${phoneNewInfo['pcVip'] == 1}"> checked="checked" </c:if> value="1" />&nbsp;${internationalConfig.是否赠送}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>PC<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.会员}
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					${internationalConfig.赠送比例}：<select name="phoneNewPcRate" style="width:100px;">
								<option value="1" <c:if test="${phoneNewInfo['pcRate'] == 1}">selected</c:if> >1/12</option>
								<option value="2" <c:if test="${phoneNewInfo['pcRate'] == 2}">selected</c:if> >2/12</option>
								<option value="3" <c:if test="${phoneNewInfo['pcRate'] == 3}">selected</c:if> >3/12</option>
								<option value="4" <c:if test="${phoneNewInfo['pcRate'] == 4}">selected</c:if> >4/12</option>
								<option value="5" <c:if test="${phoneNewInfo['pcRate'] == 5}">selected</c:if> >5/12</option>
								<option value="6" <c:if test="${phoneNewInfo['pcRate'] == 6}">selected</c:if> >6/12</option>
								<option value="7" <c:if test="${phoneNewInfo['pcRate'] == 7}">selected</c:if> >7/12</option>
								<option value="8" <c:if test="${phoneNewInfo['pcRate'] == 8}">selected</c:if> >8/12</option>
								<option value="9" <c:if test="${phoneNewInfo['pcRate'] == 9}">selected</c:if> >9/12</option>
								<option value="10" <c:if test="${phoneNewInfo['pcRate'] == 10}">selected</c:if> >10/12</option>
								<option value="11" <c:if test="${phoneNewInfo['pcRate'] == 11}">selected</c:if> >11/12</option>
								<option value="12" <c:if test="${phoneNewInfo['pcRate'] == 12}">selected</c:if> >12/12</option>
							</select>
					</td>
					<td>
						<input type="checkbox" name="phoneRenewForceBind" <c:if test="${phoneRenewInfo['forceBind'] == 1}"> checked="checked" </c:if> value="1" />&nbsp;${internationalConfig.续费手机会员是否强制机卡绑定}
					</td>
				</tr>
				<tr>
					<td>
						<input type="checkbox" name="phoneNewDonateTvVip" <c:if test="${phoneNewInfo['tvVip'] == 1}"> checked="checked" </c:if> value="1" />&nbsp;${internationalConfig.是否赠送}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>TV<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.会员}
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					${internationalConfig.赠送比例}：<select name="phoneNewTvRate" style="width:100px;">
								<option value="1" <c:if test="${phoneNewInfo['tvRate'] == 1}">selected</c:if> >1/12</option>
								<option value="2" <c:if test="${phoneNewInfo['tvRate'] == 2}">selected</c:if> >2/12</option>
								<option value="3" <c:if test="${phoneNewInfo['tvRate'] == 3}">selected</c:if> >3/12</option>
								<option value="4" <c:if test="${phoneNewInfo['tvRate'] == 4}">selected</c:if> >4/12</option>
								<option value="5" <c:if test="${phoneNewInfo['tvRate'] == 5}">selected</c:if> >5/12</option>
								<option value="6" <c:if test="${phoneNewInfo['tvRate'] == 6}">selected</c:if> >6/12</option>
								<option value="7" <c:if test="${phoneNewInfo['tvRate'] == 7}">selected</c:if> >7/12</option>
								<option value="8" <c:if test="${phoneNewInfo['tvRate'] == 8}">selected</c:if> >8/12</option>
								<option value="9" <c:if test="${phoneNewInfo['tvRate'] == 9}">selected</c:if> >9/12</option>
								<option value="10" <c:if test="${phoneNewInfo['tvRate'] == 10}">selected</c:if> >10/12</option>
								<option value="11" <c:if test="${phoneNewInfo['tvRate'] == 11}">selected</c:if> >11/12</option>
								<option value="12" <c:if test="${phoneNewInfo['tvRate'] == 12}">selected</c:if> >12/12</option>
							</select>
					</td>
					<td>
						<input type="checkbox" name="phoneRenewDonatePcVip" <c:if test="${phoneRenewInfo['pcVip'] == 1}"> checked="checked" </c:if> value="1" />&nbsp;${internationalConfig.是否赠送}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>PC<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.会员}
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					${internationalConfig.赠送比例}：<select name="phoneRenewPcRate" style="width:100px;">
								<option value="1" <c:if test="${phoneRenewInfo['pcRate'] == 1}">selected</c:if> >1/12</option>
								<option value="2" <c:if test="${phoneRenewInfo['pcRate'] == 2}">selected</c:if> >2/12</option>
								<option value="3" <c:if test="${phoneRenewInfo['pcRate'] == 3}">selected</c:if> >3/12</option>
								<option value="4" <c:if test="${phoneRenewInfo['pcRate'] == 4}">selected</c:if> >4/12</option>
								<option value="5" <c:if test="${phoneRenewInfo['pcRate'] == 5}">selected</c:if> >5/12</option>
								<option value="6" <c:if test="${phoneRenewInfo['pcRate'] == 6}">selected</c:if> >6/12</option>
								<option value="7" <c:if test="${phoneRenewInfo['pcRate'] == 7}">selected</c:if> >7/12</option>
								<option value="8" <c:if test="${phoneRenewInfo['pcRate'] == 8}">selected</c:if> >8/12</option>
								<option value="9" <c:if test="${phoneRenewInfo['pcRate'] == 9}">selected</c:if> >9/12</option>
								<option value="10" <c:if test="${phoneRenewInfo['pcRate'] == 10}">selected</c:if> >10/12</option>
								<option value="11" <c:if test="${phoneRenewInfo['pcRate'] == 11}">selected</c:if> >11/12</option>
								<option value="12" <c:if test="${phoneRenewInfo['pcRate'] == 12}">selected</c:if> >12/12</option>
							</select>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>
						<input type="checkbox" name="phoneRenewDonateTvVip" <c:if test="${phoneRenewInfo['tvVip'] == 1}"> checked="checked" </c:if> value="1" />&nbsp;${internationalConfig.是否赠送}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>TV<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.会员}
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					${internationalConfig.赠送比例}：<select name="phoneRenewTvRate" style="width:100px;">
								<option value="1" <c:if test="${phoneRenewInfo['tvRate'] == 1}">selected</c:if> >1/12</option>
								<option value="2" <c:if test="${phoneRenewInfo['tvRate'] == 2}">selected</c:if> >2/12</option>
								<option value="3" <c:if test="${phoneRenewInfo['tvRate'] == 3}">selected</c:if> >3/12</option>
								<option value="4" <c:if test="${phoneRenewInfo['tvRate'] == 4}">selected</c:if> >4/12</option>
								<option value="5" <c:if test="${phoneRenewInfo['tvRate'] == 5}">selected</c:if> >5/12</option>
								<option value="6" <c:if test="${phoneRenewInfo['tvRate'] == 6}">selected</c:if> >6/12</option>
								<option value="7" <c:if test="${phoneRenewInfo['tvRate'] == 7}">selected</c:if> >7/12</option>
								<option value="8" <c:if test="${phoneRenewInfo['tvRate'] == 8}">selected</c:if> >8/12</option>
								<option value="9" <c:if test="${phoneRenewInfo['tvRate'] == 9}">selected</c:if> >9/12</option>
								<option value="10" <c:if test="${phoneRenewInfo['tvRate'] == 10}">selected</c:if> >10/12</option>
								<option value="11" <c:if test="${phoneRenewInfo['tvRate'] == 11}">selected</c:if> >11/12</option>
								<option value="12" <c:if test="${phoneRenewInfo['tvRate'] == 12}">selected</c:if> >12/12</option>
							</select>
					</td>
				</tr>
				
			</table>
			
			<h3 class="pz_member_title">TV<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.会员}(${internationalConfig.机卡绑定})${internationalConfig.赠送配置}</h3>
			<table class="table table-form table_noborder">
				<tr>
					<th align="left">TV<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.会员新购}</th>
					<th align="left">TV<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.会员续费}</th>
				</tr>
				<tr>
					<td>
						<input type="checkbox" name="tvNewDonatePhoneVip" <c:if test="${tvNewInfo['phoneVip'] == 1}"> checked="checked" </c:if> value="1" />&nbsp;${internationalConfig.是否赠送手机会员}
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					${internationalConfig.赠送比例}：<select name="tvNewPhoneRate" style="width:100px;">
								<option value="1" <c:if test="${tvNewInfo['phoneRate'] == 1}">selected</c:if> >1/12</option>
								<option value="2" <c:if test="${tvNewInfo['phoneRate'] == 2}">selected</c:if> >2/12</option>
								<option value="3" <c:if test="${tvNewInfo['phoneRate'] == 3}">selected</c:if> >3/12</option>
								<option value="4" <c:if test="${tvNewInfo['phoneRate'] == 4}">selected</c:if> >4/12</option>
								<option value="5" <c:if test="${tvNewInfo['phoneRate'] == 5}">selected</c:if> >5/12</option>
								<option value="6" <c:if test="${tvNewInfo['phoneRate'] == 6}">selected</c:if> >6/12</option>
								<option value="7" <c:if test="${tvNewInfo['phoneRate'] == 7}">selected</c:if> >7/12</option>
								<option value="8" <c:if test="${tvNewInfo['phoneRate'] == 8}">selected</c:if> >8/12</option>
								<option value="9" <c:if test="${tvNewInfo['phoneRate'] == 9}">selected</c:if> >9/12</option>
								<option value="10" <c:if test="${tvNewInfo['phoneRate'] == 10}">selected</c:if> >10/12</option>
								<option value="11" <c:if test="${tvNewInfo['phoneRate'] == 11}">selected</c:if> >11/12</option>
								<option value="12" <c:if test="${tvNewInfo['phoneRate'] == 12}">selected</c:if> >12/12</option>
							</select>
					</td>
					<td>
						<input type="checkbox" name="tvRenewDonatePhoneVip" <c:if test="${tvRenewInfo['phoneVip'] == 1}"> checked="checked" </c:if> value="1" />&nbsp;${internationalConfig.是否赠送手机会员}
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					${internationalConfig.赠送比例}：<select name="tvRenewPhoneRate" style="width:100px;">
								<option value="1" <c:if test="${tvRenewInfo['phoneRate'] == 1}">selected</c:if> >1/12</option>
								<option value="2" <c:if test="${tvRenewInfo['phoneRate'] == 2}">selected</c:if> >2/12</option>
								<option value="3" <c:if test="${tvRenewInfo['phoneRate'] == 3}">selected</c:if> >3/12</option>
								<option value="4" <c:if test="${tvRenewInfo['phoneRate'] == 4}">selected</c:if> >4/12</option>
								<option value="5" <c:if test="${tvRenewInfo['phoneRate'] == 5}">selected</c:if> >5/12</option>
								<option value="6" <c:if test="${tvRenewInfo['phoneRate'] == 6}">selected</c:if> >6/12</option>
								<option value="7" <c:if test="${tvRenewInfo['phoneRate'] == 7}">selected</c:if> >7/12</option>
								<option value="8" <c:if test="${tvRenewInfo['phoneRate'] == 8}">selected</c:if> >8/12</option>
								<option value="9" <c:if test="${tvRenewInfo['phoneRate'] == 9}">selected</c:if> >9/12</option>
								<option value="10" <c:if test="${tvRenewInfo['phoneRate'] == 10}">selected</c:if> >10/12</option>
								<option value="11" <c:if test="${tvRenewInfo['phoneRate'] == 11}">selected</c:if> >11/12</option>
								<option value="12" <c:if test="${tvRenewInfo['phoneRate'] == 12}">selected</c:if> >12/12</option>
							</select>
					</td>
				</tr>
				
				<m:auth uri="/machine_card_donate/update.json">
					<tr>
	                    <td colspan="2" align="center">
	                        <input type="button" value="${internationalConfig.保存配置}" onclick="invokeForm()" class="bcpz_btn">
	                     </td>
	                </tr>
				</m:auth>
			</table>
		</form>
	</div>
</div>
</body>
</html>
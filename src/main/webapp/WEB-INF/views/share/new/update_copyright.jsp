<%@ page import="com.letv.boss.LetvEnv" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript">

	var lineManCount = ${linkMans != null && fn:length(linkMans) > 0 ? fn:length(linkMans) : 1};

	$(function() {

		init();

		reSortLinkManFormName();

		parent.$.messager.progress('close');
		$('#form').form({
			url : '/new/share_copyright_config/update_copyright',
			onSubmit : function() {
				parent.$.messager.progress({
					title : '${internationalConfig.提示}',
					text : '${internationalConfig.数据处理中请稍后}'
				});
				var isValid = $(this).form('validate');

				var isBusinessValid = businessValid();

				if (!isValid || !isBusinessValid) {
					parent.$.messager.progress('close');
				}

				return isValid && isBusinessValid;
			},
			success : function(result) {
				parent.$.messager.progress('close');
				result = $.parseJSON(result);
				if (result.code==0) {
					parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.操作成功}', 'success');
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
					parent.$.modalDialog.handler.dialog('close');
				} else {
					parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
				}
			}
		});
	});

	function businessValid() {
		var name = $("input[name='name']").val();
		var startTimeLimit = $("input[name='startTimeLimit']").val();
		var endTimeLimit = $("input[name='endTimeLimit']").val();
		var payNumber = $("input[name='payNumber']").val();

		var isChecked = $("input[name='acls']").is(':checked');

		if (!name) {
			parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.必须填写中文名称}", 'error');
			return false;
		}

		if (!startTimeLimit || !endTimeLimit) {
			parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.请完善有效日期}", 'error');
			return false;
		}

		if (startTimeLimit > endTimeLimit) {
			parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.结束时间不能大于开始时间}", 'error');
			return false;
		}

		var reg = new RegExp("^[0-9]*$");
		if (payNumber && !reg.test(payNumber)) {
			parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.对公帐号必需为纯数字}", 'error');
			return false;
		}

		var mails = $("textarea[name='mails']").val();
		if (mails) {
			var arr = mails.split(",");
			var reg = /^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(.[a-zA-Z0-9_-])+/;
			if (arr.length > 5) {
				parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.最多支持5个邮箱}", 'error');
				return false;
			}
			for(var i = 0; i < arr.length; i++) {
				if (!reg.test(arr[i])) {
					parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.报警邮箱格式不匹配或未按逗号分隔}", 'error');
					return false;
				}
			}
		}

		try {
			$("[name^=linkMans]").each(function(i, e){
				var name = $(e).attr("name");
				var value = $(e).val();
				if (!(i%4) && !value) {
					parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.请输入联系人姓名}", 'error');
					throw '${internationalConfig.请输入联系人姓名}';
				}
			});
		} catch (e) {
			return false;
		}
		if (!isChecked) {
			parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.至少选择一个访问分成类型}", 'error');
			return false;
		}
		return true;
	}

	function init() {
		if (${copyright.id}) {
			$("select[name='country']").val(${copyright.country});
			$("select[name='type']").val(${copyright.type});
		} else {
			changeAddType(1);
		}
		initAccountAddressType();
	}

	function initAccountAddressType() {
		var accountAddressTypeValue = $("input[name='accountAddressType']:checked").val();
		if (accountAddressTypeValue == '0') {
			$("#orderAddress1").hide();
			$("#orderAddress2").hide();
			$("#orderAddress3").hide();
		} else {
			$("#orderAddress1").show();
			$("#orderAddress2").show();
			$("#orderAddress3").show();
		}
	}

	function bind() {
		if (${copyright.id}) {
			return;
		}
		var cpId = $("input[name='cpId']").val();
		$.get("/new/share_copyright_config/bind?cpId=" + cpId, function(result){
			var json = $.parseJSON(result);
			if(json.code == 0){
				$("input[name='nameEn']").val(json.data.value);
				$("input[name='name']").val(json.data.value);
			} else {
				parent.$.messager.alert('${internationalConfig.Error}', json.msg, 'error');
			}
		});
	}

	function changeAddType(addType) {
		$("tr[class^='addType']").hide();
		$(".addType" + addType).show();
	}

	function addLinkMan() {
		var str = "<tr class=\"linkMan"+lineManCount+"\">"
					+ "<th><input type=\"button\" value=\"${internationalConfig.删除}\" onclick=\"removelinkMan("+lineManCount+");\"/></th>"
					+ "<td>${internationalConfig.姓名}：<input name=\"linkMans["+lineManCount+"].name\"/> ${internationalConfig.职位}：<input name=\"linkMans["+lineManCount+"].position\"/></td>"
				+ "</tr>"
				+ "<tr class=\"linkMan"+lineManCount+"\">"
					+ "<th></th>"
					+ "<td>${internationalConfig.邮箱}：<input name=\"linkMans["+lineManCount+"].mail\"/> ${internationalConfig.电话号码}：<input name=\"linkMans["+lineManCount+"].tel\"/></td>"
				+ "</tr>"
		lineManCount++;
		$("#addLinkManButton").before(str);
		reSortLinkManFormName();
	}

	function removelinkMan(linkManId) {
		$("tr[class='linkMan"+linkManId+"']").remove();
        lineManCount--;
		reSortLinkManFormName();
	}

	function reSortLinkManFormName() {
		$("[name^=linkMans]").each(function(i, e){
			var name = $(e).attr("name");
			name = name.substring(name.indexOf('.'));
			$(e).attr("name","linkMans["+(Math.floor(i/4))+"]" + name);
		});
	}
</script>
<style>
	.table tr{border:0 none;}
</style>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post">
			<input name="id" type="hidden" value="${copyright.id}">
			<table class="table">
				<tr ${copyright.id > 0 ? "style='display:none'" : ""}>
					<th></th>
					<td><input type="radio" name="addType" onclick="changeAddType(1)" checked value="1">${internationalConfig.绑定CPID}<input type="radio" name="addType" onclick="changeAddType(2)" value="2">${internationalConfig.匹配CP名称}</td>
				</tr>
				<tr class="addType1">
					<th>${internationalConfig.全球CPID}：</th>
					<td><input name="cpId" value="${copyright.cpId}" type="text" ${copyright.id > 0 ? 'readonly="readonly"':''}>
						<input type="button" value="${internationalConfig.绑定}" onclick="bind();"></td>
				</tr>
				<tr class="addType1">
					<th>${internationalConfig.CP英文名称}：</th>
					<td><input name="nameEn" value="${copyright.nameEn}" type="text" ${copyright.id > 0 ? 'readonly="readonly"':''}></td>
				</tr>
				<tr class="addType2">
					<th>${internationalConfig.CP中文名称}：</th>
					<td><input name="name" value="${copyright.name}" type="text" ${copyright.id > 0 ? 'readonly="readonly"':''}></td>
				</tr>
				<tr>
					<th>${internationalConfig.所属国家地区}：</th>
					<td>
						<select name="country">
							<option value='86'>${internationalConfig.中国大陆}</option>
							<option value='1'>${internationalConfig.美国}</option>
							<option value='852'>${internationalConfig.香港}</option>
							<option value='91'>${internationalConfig.印度}</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>${internationalConfig.类别}：</th>
					<td>
						<select name="type">
							<option value='1'>${internationalConfig.默认分类}</option>
							<option value='2'>${internationalConfig.影业}</option>
							<option value='3'>${internationalConfig.动漫}</option>
							<option value='4'>${internationalConfig.音乐}</option>
							<option value='5'>${internationalConfig.PGC}</option>
						</select>
					</td>
				</tr>
				<tr>
					<th><b style="color: red">*</b>${internationalConfig.签约日期}：</th>
					<td><input name="contractDate" value="${copyrightInfo.contractDate}" class="easyui-datebox"/></td>
				</tr>
				<tr>
					<th><b style="color: red">*</b>${internationalConfig.有效期}：</th>
					<td><input name="startTimeLimit" value="${copyright.startTimeLimit}" class="easyui-datebox"/> - <input name="endTimeLimit" value="${copyright.endTimeLimit}" class="easyui-datebox"/></td>
				</tr>
				<tr>
					<th><b style="color: red">*</b>${internationalConfig.分成类型}：</th>
			<%--		<td><input name="acls" type="checkbox" value="1" ${fn:contains(copyright.acl, '.1.') ? 'checked' : ''}/>${internationalConfig.付费分成}
						<input name="acls" type="checkbox" value="3" ${fn:contains(copyright.acl, '.3.') ? 'checked' : ''}/>${internationalConfig.播放分成}
						<input name="acls" type="checkbox" value="4" ${fn:contains(copyright.acl, '.4.') ? 'checked' : ''}/>${internationalConfig.累计时长分成}
						<input name="acls" type="checkbox" value="2" ${fn:contains(copyright.acl, '.2.') ? 'checked' : ''}/>${internationalConfig.CPM分成}
						<input name="acls" type="checkbox" value="5" ${fn:contains(copyright.acl, '.5.') ? 'checked' : ''}/>${internationalConfig.会员订单分成}
						<input name="acls" type="checkbox" value="6" ${fn:contains(copyright.acl, '.6.') ? 'checked' : ''}/>${internationalConfig.业务订单分成}
					</td>--%>
					<td>
						<c:forEach var="type" items="${ruleList}">
							<input name="acls" type="checkbox" value="${type.id}" ${fn:contains(copyright.acl, '.'.concat(type.id).concat('.')) ? 'checked' : ''}/>${type.name}
						</c:forEach>
					</td>
				</tr>
				<tr>
					<td><br></td>
				</tr>
				<tr>
					<th>${internationalConfig.商务负责人}：</th>
					<td><input name="bdName" value="${copyrightInfo.bdName}"/></td>
				</tr>
				<tr>
					<th>${internationalConfig.公司网站}：</th>
					<td><input name="companyUrl" value="${copyrightInfo.companyUrl}"/></td>
				</tr>
				<tr>
					<th>${internationalConfig.公司地址1}：</th>
					<td><input name="companyAddress1" value="${copyrightInfo.companyAddress1}"/></td>
				</tr>
				<tr>
					<th>${internationalConfig.公司地址2}：</th>
					<td><input name="companyAddress2" value="${copyrightInfo.companyAddress2}"/></td>
				</tr>
				<tr>
					<th>${internationalConfig.市省邮编}：</th>
					<td><input name="companyCity" value="${copyrightInfo.companyCity}"/>&nbsp<input name="companyProvince" value="${copyrightInfo.companyProvince}"/>&nbsp<input name="companyPostalcode" value="${copyrightInfo.companyPostalcode}"/></td>
				</tr>
				<tr>
					<th>${internationalConfig.账单地址}：</th>
					<td><input name="accountAddressType" ${copyrightInfo == null || copyrightInfo.accountAddressType == 0 ? 'checked' : ''} type="radio" value="0" onchange="initAccountAddressType()"/>${internationalConfig.同公司地址} <input name="accountAddressType" ${copyrightInfo.accountAddressType == 1 ? 'checked' : ''} type="radio" value="1" onchange="initAccountAddressType()"/>${internationalConfig.使用其他地址}</td>
				</tr>
				<tr id="orderAddress1">
					<th>${internationalConfig.账单地址1}：</th>
					<td><input name="accountAddress1" value="${copyrightInfo.accountAddress1}"/></td>
				</tr>
				<tr id="orderAddress2">
					<th>${internationalConfig.账单地址2}：</th>
					<td><input name="accountAddress2" value="${copyrightInfo.accountAddress2}"/></td>
				</tr>
				<tr id="orderAddress3">
					<th>${internationalConfig.市省邮编}：</th>
					<td><input name="accountCity" value="${copyrightInfo.accountCity}"/>&nbsp<input name="accountProvince" value="${copyrightInfo.accountProvince}"/>&nbsp<input name="accountPostalcode" value="${copyrightInfo.accountPostalcode}"/></td>
				</tr>
				<c:choose>
					<c:when test="${linkMans != null && fn:length(linkMans) > 0}">
						<c:forEach items="${linkMans}" var="lm" varStatus="varStatus">
							<tr class="linkMan${varStatus.index}">
								<th><c:choose>
										<c:when test="${varStatus.index==0}">
											${internationalConfig.联系人信息}：
										</c:when>
										<c:otherwise>
											<input type="button" value="${internationalConfig.删除}" onclick="removelinkMan(${varStatus.index});"/>
										</c:otherwise>
									</c:choose></th>
								<td>${internationalConfig.姓名}：<input name="linkMans[${varStatus.index}].name" value="${lm.name}"/> ${internationalConfig.职位}：<input name="linkMans[${varStatus.index}].position" value="${lm.position}"/></td>
							</tr>
							<tr class="linkMan${varStatus.index}">
								<th></th>
								<td>${internationalConfig.邮箱}：<input name="linkMans[${varStatus.index}].mail" value="${lm.mail}"/> ${internationalConfig.电话号码}：<input name="linkMans[${varStatus.index}].tel" value="${lm.tel}"/></td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<tr>
							<th>${internationalConfig.联系人信息}：</th>
							<td>${internationalConfig.姓名}：<input name="linkMans[0].name"/> ${internationalConfig.职位}：<input name="linkMans[0].position"/></td>
						</tr>
						<tr>
							<th></th>
							<td>${internationalConfig.邮箱}：<input name="linkMans[0].mail"/> ${internationalConfig.电话号码}：<input name="linkMans[0].tel"/></td>
						</tr>
					</c:otherwise>
				</c:choose>
				<tr id="addLinkManButton">
					<th></th>
					<td><input type="button" value="${internationalConfig.添加联系人}" onclick="addLinkMan()"/></td>
				</tr>
				<tr>
					<td><br></td>
				</tr>
				<tr>
					<th>${internationalConfig.支付方式}：</th>
					<td><input name="payType" ${copyrightInfo == null || copyrightInfo.payType == 0 ? 'checked' : ''} type="radio" value="0"/>${internationalConfig.电汇} <input name="payType" ${copyrightInfo.payType == 1 ? 'checked' : ''} type="radio" value="1"/>${internationalConfig.支票}</td>
				</tr>
				<tr>
					<th></th>
					<td>
					    <span style="display:inline-block;padding:3px;">${internationalConfig.账号姓名}：<input name="bankUserName" value="${copyrightInfo.bankUserName}"/></span>
					    <span style="display:inline-block;padding:3px;">${internationalConfig.银行名称}：<input name="bankName" value="${copyrightInfo.bankName}"/></span>
                    </td>
				</tr>
				<tr>
					<th></th>
					<td>
					    <span style="display:inline-block;padding:3px;">${internationalConfig.账号}：<input name="bankId" value="${copyrightInfo.bankId}"/></span>
					    <span style="display:inline-block;padding:3px;">${internationalConfig.Rounting码}：<input name="rountingCode" value="${copyrightInfo.rountingCode}"/></span>
                    </td>
				</tr>
				<tr>
					<th></th>
					<td>${internationalConfig.SWFT码}：<input name="swftCode" value="${copyrightInfo.swftCode}"/></td>
				</tr>
				<tr>
					<th>${internationalConfig.预警邮箱}：</th>
					<td><textarea name="mails" placeholder="${internationalConfig.逗号分割不能换行最多5个邮箱}" style="width: 360px; height: 80px" onchange="this.value=this.value.substring(0, 200)"
								  onkeydown="this.value=this.value.substring(0, 200);"
								  onkeyup="this.value=this.value.substring(0, 200);">${copyright.mails}</textarea></td>
				</tr>
				<tr>
					<th>${internationalConfig.备注}：</th>
					<td><textarea name="description" placeholder="${internationalConfig.请输入0200字符}" style="width: 360px; height: 80px" onchange="this.value=this.value.substring(0, 200)"
								  onkeydown="this.value=this.value.substring(0, 200);"
								  onkeyup="this.value=this.value.substring(0, 200);">${copyright.description}</textarea></td>
				</tr>
			</table>
		</form>
	</div>
</div>
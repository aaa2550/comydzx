<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form').form({
			url : '/cxll/edit',
			onSubmit : function() {
				parent.$.messager.progress({
					title : '提示',
					text : '数据处理中，请稍后....'
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
				if (result.code == 0) {
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
		style="overflow: hidden;">
		<form id="form" method="post">
			<table class="table table-form" style="width:100%">
				<tr>
					<td>
						<span class="left_span">渠道商：</span>
						<input name="id"  value="${item.id }"  type="hidden">
						<select name="channel" class="rebate_select">
								<c:forEach items="${dict.operator}" var="operator">
									<option value="${operator.key}" ${item.channel== operator.key?"selected":""}>${operator.value}</option>
								</c:forEach>
						</select>
					</td>
					<td>
						<span class="left_span">省份：</span>
						<select name="province" class="rebate_select">
								<c:forEach items="${dict.province}" var="operator">
									<option value="${operator.key}" ${item.channel== operator.key?"selected":""}   >${operator.value}</option>
								</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td>
						<span class="left_span">套餐：</span>
						<select name="applyPackage" id="applyPackage" class="rebate_select">
							<option value="12"  ${item.applyPackage== 12?"selected":""}   >移动影视会员包月</option>
							<option value="13" ${item.applyPackage== 13?"selected":""} >移动影视会员包季</option>
							<option value="14" ${item.applyPackage== 14?"selected":""} >移动影视会员包半年</option>
							<option value="15" ${item.applyPackage== 15?"selected":""} >移动影视会员包一年</option>
						</select>
					</td>
					<td>
						<span class="left_span">价格：</span>
						<input type="text" name="price"  value="${item.price }" id="price" class="easyui-numberbox"
							data-options="min:0,max:10000,precision:2,required:true;width:160" />
					</td>
				</tr>
				<tr>
					<td>
						<span class="left_span">流量ID：</span>
						<input type="text" name="itemId"  value="${item.itemId }" class="easyui-validatebox"
								data-options="required:true;width:160" />
					</td>
					<td>
						<span class="left_span">流量：</span>
						<select name="traffic" class="rebate_select">
							<c:forEach begin="1" end="20"  var="i">
								<option   value="${i }G"  >${i }G</option>
							</c:forEach>
						</select>
					</td>
				</tr>
					<tr>
					<td colspan="2">
						<span class="left_span">状态</span>
						<span class="left_span"><input type="radio"  value="1"  name="flag"  id="flag1"  ${item.flag==1 ? "checked":"" }><b for="flag1">上线</b></span>
						<span class="left_span"><input type="radio"  value="2"  name="flag"  id="flag2"   ${item.flag==2? "checked":"" }> <b for="flag2">下线</b></span>
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>
<c:if test="${! empty item }">
<script>
$("select[name=traffic]").val("${item. traffic}");
</script>
</c:if>
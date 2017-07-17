<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form').form({
			url : '/mall/add_item',
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
			<table style="margin-left: 30px; margin-top: 20px">
				<tr>
					<th>商品编码</th>
					<td><label> <input type="text" name="itemId"  value="${item.itemId }"
							style="width: 150px" class="easyui-validatebox"
							data-options="required:true" />
					</label></td>
				</tr>
				<tr>
					<th>渠道商</th>
					<td><label> <select name="channel"
							style="width: 165px">
								<c:forEach items="${dict.operator}" var="operator">
									<option value="${operator.key}" ${item.channel== operator.key?"selected":""}   >${operator.value}</option>
								</c:forEach>
						</select>
					</label></td>
				</tr>
				<tr>
					<th>套餐</th>
					<td><label> <select name="applyPackage"
							style="width: 165px;" id="applyPackage">
								<c:forEach items="${applyPackageList}" var="applyPackage">
			<option		value="${applyPackage.key}"      ${item.applyPackage== applyPackage.key?"selected":""} >${applyPackage.value.packageNameDesc}</option>
								
								</c:forEach>
						</select>
					</label></td>
				</tr>
				<tr>
					<th>套餐价格</th>
					<td><label> <input type="text" name="price"  value="${item.price }"
							id="price" style="width: 150px" class="easyui-numberbox"
							data-options="min:0,max:10000,precision:2,required:true" />
					</label></td>
				</tr>
				<tr>
					<th>折扣比例</th>
					<td><label> <input type="text" name="discount"  value="${item.discount }"
							 id="discount" style="width: 150px"
							class="easyui-numberbox"
							data-options="min:0,max:1,precision:2,required:true" />
					</label></td>
				</tr>
			</table>
		</form>
	</div>
</div>
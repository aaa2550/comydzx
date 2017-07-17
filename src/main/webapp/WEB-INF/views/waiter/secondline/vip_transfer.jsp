<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.会员服务转移}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '${pageContext.request.contextPath}/vip_transfer/data_grid.json',
							fit : true,
							fitColumns : true,
							border : false,
							pagination : true,
							idField : 'id',
							pageSize : 50,
							pageList : [ 10, 20, 30, 40, 50 ],
							checkOnSelect : false,
							selectOnCheck : false,
							nowrap : false,
							striped : true,
							rownumbers : true,
							singleSelect : true,
							frozenColumns : [ [

							] ],
							columns : [ [
									{
										field : 'orderid',
										title : '${internationalConfig.订单}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID',
										width : 100
									},
									{
										field : 'userid',
										title : '${internationalConfig.用户}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID',
										width : 60
									},
									{
										field : 'username',
										title : '${internationalConfig.用户名}',
										width : 200
									},
									{
										field : 'ordername',
										title : '${internationalConfig.订单名称}',
										width : 60
									},
									{
										field : 'money',
										title : '${internationalConfig.费用}',
										width : 60
									},
									{
										field : 'status',
										title : '${internationalConfig.状态}',
										width : 60,
										formatter : function(value) {
											if (value == '0') {
												return "${internationalConfig.未开通}"
											} else {
												return "${internationalConfig.已开通}"
											}

										}
									},
									{
										field : 'orderfrom',
										title : 'vip${internationalConfig.等级}',
										width : 60,
										formatter : function(value, row, index) {
											if (value == '1' || value == '2' || value == '4' || value == '5') {
												return "${internationalConfig.普通vip}"
											} else {
												return "${internationalConfig.高级vip}"
											}

										}
									},
									{
										field : 'createtime',
										title : '${internationalConfig.开始时间}',
										width : 120
									},
									{
										field : 'canceltime',
										title : '${internationalConfig.结束时间}',
										width : 120
									},
									{
										field : 'paytime',
										title : '${internationalConfig.支付时间}',
										width : 120
									},
									{
										field : 'operation',
										title : '${internationalConfig.操作}',
										width : 60,
										formatter : function(value, row, index) {
											var str = '&nbsp;&nbsp;&nbsp;';
											if (row.status == -1) {

												return str += '<a href="javascript:void(0);"onclick="statusUpdateAlert();"><font color="#FF0000">${internationalConfig.转账}</font></a>';
											}  else {
												return str += $
														.formatString('<a href="javascript:void(0);"class="easyui-linkbutton"data-options="iconCls:'
																+ 'brick_add,plain:true" onclick="transferFunction(\''+row.orderid+'\',\''+row.userid+'\')">${internationalConfig.转账}</a>');
											}
										}
									}

							] ],
							toolbar : '#toolbar',
							onLoadSuccess : function() {
								$('#searchForm table').show();
								parent.$.messager.progress('close');
							},
							onRowContextMenu : function(e, rowIndex, rowData) {
								e.preventDefault();
								$(this).datagrid('unselectAll');
								$(this).datagrid('selectRow', rowIndex);
								$('#menu').menu('show', {
									left : e.pageX,
									top : e.pageY
								});
							}
						});
	});
	function statusUpdateAlert() {
		jQuery.messager.alert('${internationalConfig.提示}:', '${internationalConfig.该用户订单中包含升级订单},${internationalConfig.不能转移服务},${internationalConfig.可联系技术人员进行处理}!');
	}
	function createDateAlert() {
		jQuery.messager.alert('${internationalConfig.提示}:', '${internationalConfig.该订单已开通超过7天},${internationalConfig.不能再转移}!');
	}
	function searchFun() {
		dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
	}
	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}
	function transferFunction(orderid,userid) {
		parent.$
				.modalDialog({
					title : '${internationalConfig.转移}vip${internationalConfig.服务}',
					width : 380,
					height : 300,
					href : '${pageContext.request.contextPath}/vip_transfer/transfer.json?orderid='
							+ orderid+'&userid='+userid,
					buttons : [ {
						text : '${internationalConfig.确定}',
						handler : function() {
							parent.$.modalDialog.openner_dataGrid = dataGrid;//${internationalConfig.因为添加成功之后}，${internationalConfig.需要刷新这个}dataGrid，${internationalConfig.所以先预定义好}
							var f = parent.$.modalDialog.handler.find('#form');
							f.submit();
						}
					} ]
				});

	}
	
	
	function formatterdate(val) {
		if (val == null) {
			return "";
		}
		var date = new Date(val);
		return date.format("yyyy-MM-dd hh:mm:ss");
	}
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
			style="height: 80px; overflow: hidden;">
			<form id="searchForm">
				<table class="table-td-two"
					style="display: none;">
					<tr>
						<td>${internationalConfig.转出用户}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID <input id="srcUsernameOrUserId" name="userId"
							class="span2" />
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div data-options="region:'center',border:false">
			<table id="dataGrid"></table>
		</div>
		<br />

	</div>
	<div id="toolbar" style="display: none;">
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_delete',plain:true"
			onclick="cleanFun();">${internationalConfig.清空条件}</a>
	</div>
</body>
</html>
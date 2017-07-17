<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.话费支付}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>

<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '/phone_pay/data_grid.json',
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
							frozenColumns : [ [ {
								field : 'id',
								title : '${internationalConfig.编号}',
								width : 150,
								hidden : true
							} ] ],
							columns : [ [ {
								field : 'userid',
								title : '${internationalConfig.用户ID}',
								width : 120,
								sortable : true,
							}, {
								field : 'productname',
								title : '${internationalConfig.购买商品名}',
								width : 180,
								sortable : true
							}, {
								field : 'ordernumber',
								title : '${internationalConfig.订单号}',
								width : 240,
								sortable : true
							}, {
								field : 'corderid',
								title : '${internationalConfig.商户订单号}',
								width : 180,
								sortable : true
							}, {
								field : 'price',
								title : '${internationalConfig.支付金额}',
								width : 150,
								sortable : true
							}, {
								field : 'paymentdate',
								title : '${internationalConfig.支付时间}',
								width : 180,
								sortable : true
							}, {
								field : 'submitdate',
								title : '${internationalConfig.提交订单时间}',
								width : 180,
								sortable : true
							}, {
								field : 'ip',
								title : '${internationalConfig.用户IP}',
								width : 180,
								sortable : true
							}, {
								field : 'paytype',
								title : '${internationalConfig.支付方式}',
								width : 150,
								sortable : true,
								formatter : function(value, row) {
									var str = '';
									if ("38" == value) {
										str = "${internationalConfig.凤凰话费支付}";
									} else if ("31" == value) {
										str = "${internationalConfig.联通支付}";
									}
									return str;
								}
							}, {
								field : 'status',
								title : '${internationalConfig.支付状态}',
								width : 150,
								sortable : true,
								formatter : function(value) {
									var str = '';
									if ("0" == value) {
										str = "${internationalConfig.支付失败}";
									} else if ("1" == value) {
										str = "${internationalConfig.支付成功}";
									} else if ("3" == value) {
										str = "${internationalConfig.退款成功}";
									} else {
										str = "${internationalConfig.通知失败}";
									}
									return str;
								}
							} ] ],
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

	function searchFun() {
		dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
	}

	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}

	function openService() {
		var uid = $('#uid').val();
		var phone = $('#phone').val();
		if (uid == '') {
			alert("${internationalConfig.请输入正确的用户}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID");
			return;
		}
		if (phone == '') {
			alert("${internationalConfig.请输入正确的手机号}");
			return;
		}

		parent.$.messager
				.confirm(
						'${internationalConfig.询问}',
						'${internationalConfig.您是否要为该用户开通会员服务}？',
						function(b) {
							if (b) {
								parent.$.messager.progress({
									title : '${internationalConfig.提示}',
									text : '${internationalConfig.数据处理中}....'
								});

								$
										.post(
												'${pageContext.request.contextPath}/phone_pay/open_service.json',
												{
													uid : uid,
													phone : phone
												},
												function(obj) {
													var msg = decodeURIComponent(obj.msg);
													if (obj.code == 0) {
														alert(msg);
														parent.$.messager
																.progress('close');
														dataGrid
																.datagrid(
																		'load',
																		$
																				.serializeObject($('#searchForm')));
													} else {
														alert(msg);
														parent.$.messager
																.progress('close');
														dataGrid
																.datagrid(
																		'load',
																		$
																				.serializeObject($('#searchForm')));
													}
												}, 'JSON');
							}
						});
	}
	
	function refundService() {
		var uid = $('#uid').val();
		var phone = $('#phone').val();
		if (uid == '') {
			alert("${internationalConfig.请输入正确的用户}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID");
			return;
		}
		if (phone == '') {
			alert("${internationalConfig.请输入正确的手机号}");
			return;
		}

		parent.$.messager
				.confirm(
						'${internationalConfig.询问}',
						'${internationalConfig.您是否要为该用户退订会员服务}？</br><span style="color:#F00">(${internationalConfig.仅支持通过收银台进行话费支付的用户})</span>',
						function(b) {
							if (b) {
								parent.$.messager.progress({
									title : '${internationalConfig.提示}',
									text : '${internationalConfig.数据处理中}....'
								});

								$
										.post(
												'/phone_pay/refund_service.json',
												{
													uid : uid,
													phone : phone
												},
												function(obj) {
													var msg = decodeURIComponent(obj.msg);
													if (obj.code == 0) {
														alert(msg);
														parent.$.messager
																.progress('close');
														dataGrid
																.datagrid(
																		'load',
																		$
																				.serializeObject($('#searchForm')));
													} else {
														alert(msg);
														parent.$.messager
																.progress('close');
														dataGrid
																.datagrid(
																		'load',
																		$
																				.serializeObject($('#searchForm')));
													}
												}, 'JSON');
							}
						});
	}
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
			style="height: 100px; overflow: hidden;">
			<form id="searchForm">
				<table class="table-td-three" style="display: none;">
					<tr>
						<td style="white-space: nowrap;">${internationalConfig.用户}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID：<input id="uid"
							name="uid" class="span2"></input><span style="color: red;">(${internationalConfig.请输入正确的用户}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID)</span>
						</td>
						<td style="white-space: nowrap;">${internationalConfig.手机号}：<input id="phone"
							name="phone" class="span2"></input><span style="color: red;">(${internationalConfig.仅支持移动和联通手机话费支付})</span>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div data-options="region:'center',border:false">
			<table id="dataGrid"></table>
		</div>
	</div>
	<div id="toolbar" style="display: none;">
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_delete',plain:true"
			onclick="cleanFun();">${internationalConfig.清空条件}</a> 
		<a href="javascript:void(0);"
			class="easyui-linkbutton"
			data-options="iconCls:'brick_delete',plain:true"
			onclick="openService();">${internationalConfig.开通服务}</a>
		<a href="javascript:void(0);"
			class="easyui-linkbutton"
			data-options="iconCls:'brick_delete',plain:true"
			onclick="refundService();">${internationalConfig.退订服务}</a>
	</div>
</body>
</html>
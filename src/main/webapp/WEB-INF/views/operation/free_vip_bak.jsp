<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>免费会员</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
<m:auth uri="/free_vip/send_sms.json">
	$.canEdit = true;
</m:auth>
</script>

<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '/free_vip/data_grid.json',
							queryParams:$.serializeObject($('#searchForm')),
							fit : true,
							fitColumns : true,
							border : false,
							pagination : true,
							idField : 'id',
							pageSize : 20,
							pageList : [ 10, 20, 30, 40, 50 ],
							sortName : 'createTime',
							sortOrder : 'asc',
							checkOnSelect : false,
							selectOnCheck : false,
							singleSelect : true,
							nowrap : false,
							striped : true,
							rownumbers : true,
							singleSelect : true,
							frozenColumns : [ [ {
								field : 'id',
								title : '编号',
								width : 50,
								hidden : true
							} ] ],
							columns : [ [
									{
										field : 'phoneNo',
										title : '电话号码',
										width : 60,
										sortable : false
									},{
										field : 'userId',
										title : '用户ID',
										width : 60,
										sortable : true
									},{
										field : 'createTime',
										title : '增加时间',
										width : 60,
										sortable : true
									},
									{
										field : 'days',
										title : '增加服务期',
										width : 80,
										formatter : function(value,row) {
											var type="全屏影视会员" ;											
											if(row.vipType==1){
												type="移动影视会员";
											}else if(row.vipType==2){
												type="超级手机会员";
											}											
											return value + "天"+type;
										}
									},
									{
										field : 'validTime',
										title : '会员有效期',
										width : 60,
										sortable : true
									},
									{
										field : 'orderId',
										title : '订单号',
										width : 60
									},
									{
										field : 'action',
										title : '操作',
										width : 60,
										formatter : function(value, row, index) {
											var str = '';
											
											if ($.canEdit && row.phoneNo != '') {
												str += $
														.formatString(
																'<img onclick="sendMessage(\'{0}\');" src="{1}" title="发送短信"/>',
																row.id,
																'${pageContext.request.contextPath}/static/style/images/extjs_icons/book_go.png');
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
	
	function sendMessage(id) {
 		$.messager.confirm('确认', '确定发送短信？', function(r) {
			if(r) {
				$.ajax({  
					   type: 'GET',  
					   url: '/free_vip/send_sms.json?id='+id,
					   dataType: 'html',
					   success: function(result){  
						    result = $.parseJSON(result);
						    if (result.code == 0) {
								parent.$.messager.alert('成功', result.msg, 'success');
							} else {
								parent.$.messager.alert('错误', result.msg, 'error');
							}
					   }  
					}); 
			}
		}); 
	}

	function searchFun() {
		dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
	}
	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}
	function addServiceFun(){
		parent.$.modalDialog({
			title : '增加服务',
			width : 600,
			height : 350,
			href : '/free_vip/vip_send.json',
			buttons : [ {
				text : '增加服务时长',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			} ]
		});
	}
	
	function addServiceFun7(){
		parent.$.modalDialog({
			title : '增加7天服务',
			width : 600,
			height : 350,
			href : '/free_vip/free_vip_add.json',
			buttons : [ {
				text : '增加服务时长',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			} ]
		});
	}
	
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'查询条件',border:false"
			style="height: 80px; overflow: hidden;">
			<form id="searchForm">
				<table class="table-td-two"
					style="display: none;">
					<tr>
						<td>手机号：<input name="phoneNo" class="span2"/></td>
						<td>用户ID：<input name="userId" value="${param.userId}" class="span2"/></td>
					</tr>
				</table>
			</form>
		</div>
		<div data-options="region:'center',border:false">
			<table id="dataGrid"></table>
		</div>
	</div>
	<div id="toolbar" style="display: none;">
	  <m:auth uri="/free_vip/vip_send.json">
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'pencil_add',plain:true" onclick="addServiceFun();">增加服务</a>
	</m:auth>
	<%-- 
	 <m:auth uri="/free_vip/free_vip_add.json">
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'pencil_add',plain:true" onclick="addServiceFun7();">增加7天免费会员</a>
	</m:auth>
	--%>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_delete',plain:true"
			onclick="cleanFun();">清空条件</a>
	</div>
</body>
</html>
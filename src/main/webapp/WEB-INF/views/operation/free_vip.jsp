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
		parent.$.messager.progress('close');
		dataGrid = $('#dataGrid')
				.datagrid(
						{						
							fit : true,
							fitColumns : true,
							border : false,
							pagination : true,
							idField : 'id',
							pageSize : 20,
							pageList : [ 10, 20, 30, 40, 50 ],
							
							checkOnSelect : false,
							selectOnCheck : false,
							singleSelect : true,
							nowrap : false,
							striped : true,
							rownumbers : true,
							singleSelect : true,
							frozenColumns : [ [ {
								field : 'id',
								title : '${internationalConfig.编号}',
								width : 50,
								hidden : true
							} ] ],
							columns : [ [
									{
										field : 'payChannel',
										title : '${internationalConfig.渠道}ID',
										width : 20
								
									},{
										field : 'userId',
										title : '${internationalConfig.用户ID}',
										width : 60
									
									},
									/**
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
											}else if(row.vipType==8){
												type="超级体育会员";
											}											
											return value + "天"+type;
										}
									}, **/
									{
										field : 'orderName',
										title : '${internationalConfig.开通免费会员名称}',
										width : 80
									
									},
									{
										field : 'createTime',
										title : '${internationalConfig.增加时间}',
										width : 60,
										sortable : true
									},
									{
										field : 'cancelTime',
										title : '${internationalConfig.会员有效期}',
										width : 60,
										sortable : true
									},
									{
										field : 'orderId',
										title : '${internationalConfig.订单号}',
										width : 60
									},{
									    field: 'reason',
                                        title: '${internationalConfig.赠送理由}',
                                        width : 60
                                    },{
                                        field: 'operator',
                                        title: '${internationalConfig.操作人}',
                                        width : 60
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
	
	function sendMessage(id) {
 		$.messager.confirm('${internationalConfig.确认}', '${internationalConfig.确定发送短信}', function(r) {
			if(r) {
				$.ajax({  
					   type: 'GET',  
					   url: '/free_vip/send_sms.json?id='+id,
					   dataType: 'html',
					   success: function(result){  
						    result = $.parseJSON(result);
						    if (result.code == 0) {
								parent.$.messager.alert('${internationalConfig.成功}', result.msg, 'success');
							} else {
								parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
							}
					   }  
					}); 
			}
		}); 
	}

	function searchFun() {
		dataGrid.datagrid({url:"/free_vip/list_record",queryParams:$.serializeObject($('#searchForm'))});
	//	dataGrid.datagrid("load", $.serializeObject($('#searchForm')));
	}
	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}
	function addServiceFun(){
		parent.$.modalDialog({
			title : '${internationalConfig.增加服务}',
			width : 600,
			height : 350,
			href : '/free_vip/vip_send.json',
			buttons : [ {
				text : '${internationalConfig.增加服务时长}',
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
			title : '${internationalConfig.增加7天服务}',
			width : 600,
			height : 350,
			href : '/free_vip/free_vip_add.json',
			buttons : [ {
				text : '${internationalConfig.增加服务时长}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			} ]
		});
	}
	
	function addGiveVipFun(){
		parent.$.modalDialog({
			title : '${internationalConfig.赠送服务}',
			width : 600,
			height : 450,
			href : '/free_vip/vip_give.json',
			buttons : [ {
				text : '${internationalConfig.赠送会员}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			}, {
				text : "${internationalConfig.取消}",
				handler : function() {
					parent.$.modalDialog.handler.dialog('close');
				}
			} ]
		});
	}
	
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
			style="height: 120px; overflow: hidden;">
			<form id="searchForm">
				<table class="table-td-two">
					<tr><td>${internationalConfig.查询后台赠送记录渠道号填1}</td></tr>
					<tr>
						<td>${internationalConfig.渠道号}：<input name="channel" class="span2"  value="1" /></td>				
						<td>${internationalConfig.用户ID}：<input name="userId" value="${param.userId}" class="span2"/></td>
					</tr>
				</table>
			</form>
		</div>
		<div data-options="region:'center',border:false">
			<table id="dataGrid"></table>
		</div>
	</div>
	<div id="toolbar" style="display: none;">
	  <%-- <m:auth uri="/free_vip/vip_send.json">
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'pencil_add',plain:true" onclick="addServiceFun();" >增加服务</a>
	</m:auth> --%>
	<m:auth uri="/free_vip/vip_give.json">
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'pencil_add',plain:true" onclick="addGiveVipFun();">${internationalConfig.赠送会员}</a>
	</m:auth>

		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_delete',plain:true"
			onclick="cleanFun();">${internationalConfig.清空条件}</a>
	</div>
</body>
</html>
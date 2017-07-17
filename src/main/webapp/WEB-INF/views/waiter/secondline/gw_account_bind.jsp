<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.新版商城信用卡解除绑定}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
			style="height: 80px; overflow: hidden;">
			<form id="searchForm">
				<table class="table-td-two"
					style="display: none;">
					<tr>
					<td>${internationalConfig.用户}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID：<input name="userId" value="${param.userId}" class="span2"/></td>
					<td>${internationalConfig.手机号}：<input name="phone" class="span2"/></td>						
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
	</div>
</body>
<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '/gw_account_bind/bind_info',
							queryParams:$.serializeObject($('#searchForm')),
							fit : true,
							fitColumns : true,
							border : false,
							pagination : true,
						
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
											field : 'id',
											title : '${internationalConfig.绑定}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID',
											width : 80
										},
									{
										field : 'userId',
										title : '${internationalConfig.用户}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID',
										width : 80
									},{ 
										field : 'phone',
										title : '${internationalConfig.电话号码}',
										width : 80
									
									},
									/**
									{
										field : 'paymodeRuleId',
										title : '${internationalConfig.规则}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID',
										width : 80
										
									},	
									{
										field : 'cardType',
										title : '${internationalConfig.卡类型}',
										width : 80
									},
																		
									**/					
									{
										field : 'cardNo',
										title : '${internationalConfig.卡号}',
										width : 80
										
									},
									{
										field : 'bankName',
										title : '${internationalConfig.绑定银行}',
										width : 80
									},
								
									
									{
										field : 'lastUpdateDate',
										title : '${internationalConfig.跟新时间}',
										width : 80
									
									},
									{
										field : 'status',
										title : '${internationalConfig.状态}',
										width : 30,
										formatter : function(value, row, index) {
										  if(value==0){
											  return "${internationalConfig.初始}";
										  }else if(value==1){
											  return "${internationalConfig.绑定}";
										  }else if(value==2){
											  return "${internationalConfig.已解绑}";
										  }
										}
									},
								
									{
										field : 'action',
										title : '${internationalConfig.操作}',
										width : 80,
										formatter : function(value, row, index) {
											var str="";
											if(row.status==1){
												str = '<a href="javascript:;" onclick=unbind("'+row.id+'","'+row.paymodeRuleId+'")>${internationalConfig.解绑}</a>';			
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

	
	function unbind(id,paymodeRuleId){
	   if(window.confirm("${internationalConfig.确定解绑}?")){
		   $.get("/gw_account_bind/unbind",{id:id,paymodeRuleId:paymodeRuleId},function(data){		
			   parent.$.messager.alert("${internationalConfig.提示}",data.code==0? "${internationalConfig.成功}":"${internationalConfig.失败}");
		   },"json");
	   }
	}
	
</script>
</html>
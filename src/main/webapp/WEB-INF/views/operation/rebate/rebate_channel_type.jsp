<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.免费会员}-${internationalConfig.渠道管理}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '/rebate/channel/type_list',
							queryParams:$.serializeObject($('#searchForm')),
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
							rownumbers : false,
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
										title : '${internationalConfig.类型}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>id',
										width : 60,
										sortable : false
									},{
										field : 'type',
										title : '${internationalConfig.渠道类型}',
										width : 60,
									},{
										field : 'description',
										title : '${internationalConfig.渠道描述}',
										width : 200,
									},
									{
										field : 'operator',
										title : '${internationalConfig.操作者}',
										width : 80
									},
									{
										field : 'updateTime',
										title : '${internationalConfig.更新时间}',
										width : 60,
										sortable : true
									},
									{
										field : 'action',
										title : '${internationalConfig.操作}',
										width : 60,
										formatter : function(value, row, index) {
											var str= $.formatString('<img onclick="addFun(\'{0}\');" src="{1}" title="${internationalConfig.编辑}"/>', row.id, '/static/style/images/extjs_icons/pencil.png');
											str += $.formatString(	'<img onclick="deleteFun(\'{0}\');" src="{1}" title="${internationalConfig.删除}"/>',row.id,'/static/style/images/extjs_icons/cancel.png');
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
	function addFun(id){
		parent.$.modalDialog({
			title : '${internationalConfig.渠道类型}',
			width :600,
			height : 400,
			href : '/rebate/channel/type_edit?id='+id,
			buttons : [ {
				text : '${internationalConfig.保存}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			} ]
		});
	}
	function deleteFun(id){
		if(window.confirm("${internationalConfig.确定删除吗}？")){
			$.get("/rebate/channel/delete/"+id+"?type=channelType",function(){
				parent.$.messager.alert("${internationalConfig.提示}","${internationalConfig.删除成功}!");
				dataGrid.datagrid('reload');
			});
		
		}
	}
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
			style="height: 80px; overflow: hidden;">
			<form id="searchForm">
				<table class="table-td-two"
				>
					<tr>
						<td>${internationalConfig.渠道类型}：<input name="type" class="span2"/></td>
					
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
			data-options="iconCls:'pencil_add',plain:true" onclick="addFun(0);">${internationalConfig.增加渠道类型}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_delete',plain:true"
			onclick="cleanFun();">${internationalConfig.清空条件}</a>
	</div>
</body>
</html>
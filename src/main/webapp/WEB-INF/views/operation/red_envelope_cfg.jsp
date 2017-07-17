<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>红包配置</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'查询条件',border:false"
			style="overflow: hidden; height: 90px">
        	<form id="searchForm">
           		<table class="table-more" style="display: none;">
				<tr>					
					<td><span>类型：</span>
						<select name="type">	
						    <option value="">全部</option>			
							<option value="1">红包配置</option>
							<option value="2">赠送观影卷</option>
							</select>
					</td>		
					<td><span>终端：</span>		   
					   <select name="terminal">
					     <option value=""	>全部</option>
										<c:forEach items="${terminals }" var="item">
											<option value="${item.key }"		>${item.value }</option>
										</c:forEach>
								</select>
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
			data-options="iconCls:'pencil_add',plain:true" onclick="addFun(0,0);">增加</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_delete',plain:true"
			onclick="cleanFun();">清空条件</a>
	</div>
</body>
<script type="text/javascript">
var terminal = ${terminals};	
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '/red_envelope_cfg/list',
							queryParams:$.serializeObject($('#searchForm')),
							fit : true,
							fitColumns : true,
							border : false,
							pagination : true,
							pageSize : 30,
							pageList : [ 30, 50,100 ],
						//	sortName : 'id',
					//		sortOrder : 'asc',
							checkOnSelect : false,
							selectOnCheck : false,
							singleSelect : true,
							nowrap : false,
							striped : true,
							rownumbers : false,
							singleSelect : true,
							frozenColumns : [ [ {
								field : 'pid',
								title : '编号',
								width : 50,
								hidden : true
							} ] ],
							columns : [ [
									{
										field : 'type',
										title : '类型',
										width : 30,
										formatter : function(value, row, index) {
											return value==1 ? "红包配置" : "赠送观影卷" ;
										}
									},
									{
										field : 'terminal',
										title : '终端',
										width : 30,
										formatter : function(value, row, index) {
											return terminal[value]
										}
									},
									{
										field : 'keyValue',
										title : '秘钥',
										width : 30,
									},
									{
										field : 'activityId',
										title : '活动id',
										width : 20
									},
									{
										field : 'support',
										title : '状态',
										width : 20,
										formatter : function(value, row, index) {
											return value==0 ? "不支持" : "支持" ;
										}
									},
									{
										field : 'imgUrl',
										title : '焦点图',
										width : 200
									},
									{
										field : 'updateTime',
										title : '更新时间',
										width : 60,
										sortable : true
									},
									{
										field : 'action',
										title : '操作',
										width : 60,
										formatter : function(value, row, index) {
											var str="" ;
												 str+= $.formatString('<img onclick="addFun(\'{0}\',{2});" src="{1}" title="编辑"/>', row.terminal, '/static/style/images/extjs_icons/pencil.png',row.type);
													str += $.formatString(	'<img onclick="deleteFun(\'{0}\',{2});" src="{1}" title="删除"/>',row.terminal,'/static/style/images/extjs_icons/cancel.png',row.type);	
															
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
	function addFun(terminal,type){
		parent.$.modalDialog({
			title : '渠道类型',
			width : 600,
			height : 400,
			href : '/red_envelope_cfg/update?terminal='+terminal+"&type="+type,
			buttons : [ {
				text : '保存',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			} ]
		});
	}
	function deleteFun(terminal,type){
		if(window.confirm("确定删除吗？")){
			$.get("/red_envelope_cfg/delete",{terminal:terminal,type:type},function(){
				parent.$.messager.alert("提示","删除成功!");
				dataGrid.datagrid('reload');
			});
		
		}
	}


</script>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>弹窗提醒配置</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
	var terminal = ${terminal};	
	var dataGrid;
	$(function () {
	    dataGrid = renderDataGrid('/reminder_pop/list');
	});

	function renderDataGrid(url) {
	    return $('#dataGrid').datagrid({
	        url: url,
	        fit: true,
	        fitColumns: false,
	        border: false,
	        pagination: true,
	        idField: 'id',
	        pageSize: 10,
	        pageList: [ 10, 20, 30, 40, 50 ],
	        checkOnSelect: false,
	        selectOnCheck: false,
	        nowrap: false,
	        striped: true,
	        rownumbers: true,
	        singleSelect: true,
	        remoteSort: false,
							frozenColumns : [ [ {
								field : 'id',
								title : '编号',
								width : 50,
								hidden : true
							} ] ],
							columns : [ [
									{
										field : 'id',
										title : 'id',
										width : 60
									},
									{
										field : 'terminal',
										title : '终端',
										width : 60,
										formatter : function(value, row, index) {
											return terminal[value]
										}
									},
									{
										field : 'userType',
										title : '弹出用户类型',
										width : 100,
										formatter : function(value, row, index) {
											// //过滤用户类型 1：全部用户 ，2 过期用户，3 一直非会员用户 ，4 根据条件过滤
											if (value == 1) {
												return "全部用户";
											} else if (value == 2) {
												return "过期用户"
											} else if (value == 3) {
												return "一直非会员用户";
											} else if (value == 4) {
												var s = "";
												if (row.start1 > 0) {
													s += "　会员有效期剩余 "
															+ row.start1
															+ "天一 " + row.end1
															+ "天的用户　"
												}
												if (row.end2 > 0) {
													s += "　会员有效期过期 "
															+ row.start2
															+ "天一 " + row.end2
															+ "天的用户　"
												}
												return s;
											}
											return value ;
										}
									},
									{
										field : 'startTime',
										title : '开始时间',
										width : 100
									},
									{
										field : 'endTime',
										title : '结束时间',
										width : 100
									},
									{
										field : 'weight',
										title : '优先级',
										width : 60
									},
									{
										field : 'dailyCount',
										title : '每日弹出次数',
										width : 80
									},
									{
										field : 'totalCount',
										title : '总次数',
										width : 60
									},
									{
										field : 'price',
										title : '减免价格',
										width : 60
									},

									{
										field : 'action',
										title : '操作',
										width : 60,
										formatter : function(value, row, index) {
											var str = '';

											str += $
													.formatString(
															'<img onclick="addFun(\'{0}\');" src="{1}" title="编辑"/>',
															row.id,
															'/static/style/images/extjs_icons/pencil.png');
											str += $
													.formatString(
															'<img onclick="deleteFun(\'{0}\');" src="{1}" title="删除"/>',
															row.id,
															'/static/style/images/extjs_icons/cancel.png');
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
	}

	function searchFun() {
		dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
	}
	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}
	function addFun(id) {
		parent.$.modalDialog({
			title : '配置信息',
			width : 800,
			height : 600,
			href : '/reminder_pop/edit?id=' + id,
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
	
	function deleteFun(id){
		if(window.confirm("确定删除吗？")){
			$.get("/reminder_pop/delete/"+id,function(){
				parent.$.messager.alert("提示","删除成功!");
				dataGrid.datagrid('reload');
			});
		
		}
	}
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'查询条件',border:false"
			style="height: 80px; overflow: hidden;">
			<form id="searchForm">
				<table class="table-td-more">
					<tr>
						<td>终端： <select name="terminal">
								<c:forEach items="${terminal }" var="item">
									<option value="${item.key }"		>${item.value }</option>
								</c:forEach>
						</select>
						</td>
                   <td>状态：<select name="status">
								<option value="0"	>全部</option>
								<option value="1"	>在线</option>
								<option value="2"	>下线</option>
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
			data-options="iconCls:'pencil_add',plain:true" onclick="addFun(0);">增加</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_delete',plain:true"
			onclick="cleanFun();">清空条件</a>
	</div>
</body>
</html>
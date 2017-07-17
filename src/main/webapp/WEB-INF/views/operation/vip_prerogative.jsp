<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>会员等级管理</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script src="/js/dict.js"></script>
<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '/vip_prerogative/list',
							queryParams : $.serializeObject($('#searchForm')),
							fit : true,
							fitColumns : true,
							border : false,
							pagination : true,
							pageSize : 20,
							pageList : [ 10, 20, 30, 40, 50 ],
							selectOnCheck : false,
							singleSelect : true,
							nowrap : false,
							striped : true,
							rownumbers : false,
							singleSelect : true,
						
							columns : [ [
									{
										field : 'level',
										title : '${internationalConfig.等级级数}',
										width : 60,
										sortable : true
									},
									{
										field : 'vipPrerogativeType',
										title : '${internationalConfig.等级类型}',
										width : 100,
										sortable : true,
										formatter : function (value) {
											return Dict.getName('vip_level_type', value);
										}
									},
									{
										field : 'name',
										title : '${internationalConfig.等级名称}',
										width : 100

									},
									{
										field : 'description',
										title : '${internationalConfig.等级描述}',
										width : 200
									},
									{
										field : 'operator',
										title : '${internationalConfig.操作者}',
										width : 100
									},
								    {
										field : 'forceTime',
										title : '${internationalConfig.生效时间}',
										width : 100,
										sortable : true
									},
									{
										field : 'updateTime',
										title : '${internationalConfig.更新时间}',
										width : 100,
										sortable : true
									},
									{
										field : 'action',
										title : '${internationalConfig.操作}',
										width : 60,
										formatter : function(value, row, index) {
											var str = '';
											str += $.formatString('<img onclick="editFun(\'{0}\',\'{1}\');" src="{2}" title="${internationalConfig.编辑}"/>',
															row.vipPrerogativeType, row.level, '/static/style/images/extjs_icons/pencil.png');
											<%--str += "&nbsp;&nbsp;"+ $.formatString('<img onclick="delFun(\'{0}\');" src="{1}" title="${internationalConfig.删除}"/>',
																	row.level,'/static/style/images/extjs_icons/cancel.png');--%>

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
	function editFun(vipPrerogativeType, level) {
		var url = $.formatString("/vip_prerogative/edit?vipPrerogativeType={0}&level={1}", vipPrerogativeType, level);
		parent.$.modalDialog({
			title : '${internationalConfig.编辑}',
			width : 600,
			height : 600,
			href : url,
			buttons : [ {
				text : '${internationalConfig.保存}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			} ]/*,
			onBeforeClose : function() {
				return confirm('${internationalConfig.确定放弃编辑吗}');
			}*/
		});
	}

	function addFun() {
		var type = 1;
		var url = "/vip_prerogative/edit";

		parent.$.modalDialog({
			title : '${internationalConfig.增加}',
			width : 600,
			height : 600,
			href : url,
			buttons : [ {
				text : '${internationalConfig.保存}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			} ]/*,
			onBeforeClose : function() {
				return confirm('${internationalConfig.确定放弃编辑吗}');
			}*/
		});
	}
	<%--
	function delFun(level) {
		parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.您是否要删除当前会员等级}',
				function(b) {
					if (b) {
						parent.$.messager.progress({
							title : '${internationalConfig.提示}',
							text : '${internationalConfig.数据处理中}....'
						});
						$.post(
								'/vip_prerogative/delete',
								{level: level},
								function(result) {
									if (result.code == 0) {
										parent.$.messager
												.alert(
												'${internationalConfig.提示}',
												'${internationalConfig.删除成功}',
												'info');
										dataGrid.datagrid('reload');
									} else {
										parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.删除失败}', 'error');
									}
									parent.$.messager
											.progress('close');
								}, 'JSON');
					}
				});
	}--%>
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
			style="height: 80px; overflow: hidden;">
			<form id="searchForm">
				<table class="table-td-two">
					<tr>
						<td>
							${internationalConfig.等级名称}：
							<input name="name" class="span2" type="text"/>
						</td>
						<td>
							${internationalConfig.等级级数}：
							<input name="level" class="span2" type="text"/>
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
			data-options="iconCls:'pencil_add',plain:true" onclick="addFun();">${internationalConfig.增加}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_delete',plain:true"
			onclick="cleanFun();">${internationalConfig.清空条件}</a>
	</div>
</body>
</html>
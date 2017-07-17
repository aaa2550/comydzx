<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.分成角色管理}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
<m:auth uri="/share_role/add.json">  $.canAdd = true;</m:auth>
<m:auth uri="/share_role/delete.json">  $.canDelete = true;</m:auth>
<m:auth uri="/share_role/modify.json">  $.canModify = true;</m:auth>
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '${pageContext.request.contextPath}/share_role/data_grid.json',
							fit : true,
							fitColumns : true,
							border : false,
							pagination : true,
							idField : 'id',
							pageSize : 10,
							pageList : [ 10, 20, 30, 40, 50 ],
							checkOnSelect : false,
							selectOnCheck : false,
							nowrap : false,
							striped : true,
							rownumbers : true,
							singleSelect : true,
							frozenColumns : [ [ {
								field: 'id',
			                    title: '${internationalConfig.编号}',
			                    width: 150,
			                    hidden: true
							} ] ],
							columns : [ [
									{
										field: 'name',
					                    title: '${internationalConfig.角色名}',
					                    width: 80
									},
									{
										field : 'menus',
										title : '${internationalConfig.菜单权限}',
										width : 180
									},
									{
										field : 'copyrights',
										title : '${internationalConfig.所属版权方}',
										width : 100,
										formatter : function(value, row, index) {
											if (value == '不限版权方') {
												return '${internationalConfig.不限版权方}';
											}
											return value;
										}
									},
									{
										field : 'rebateChannels',
										title : '${internationalConfig.返利渠道}',
										width : 80,
										formatter : function(value, row, index) {
											if (value == '不限渠道') {
												return '${internationalConfig.不限渠道}';
											}
											return value;
										}
									},
									{
										field : 'channels',
										title : '${internationalConfig.所属频道}',
										width : 80,
										formatter : function(value, row, index) {
											if (value == '不限频道') {
												return '${internationalConfig.不限频道}';
											}
											return value;
										}
									},
									{
										field : 'enabledNature',
										title : '${internationalConfig.是否可查看自然数据}',
										width : 30,
										formatter : function(value, row, index) {
											if (value == '是') {
												return '${internationalConfig.是}';
											} else {
												return '${internationalConfig.否}';
											}
											return value;
										}
									},
									{
										field : 'remark',
										title : '${internationalConfig.备注}',
										width : 40
									},
									{
										field : 'action',
										title : '${internationalConfig.操作}',
										width : 30,
										formatter : function(value, row, index) {
											var str = '';
											if ($.canModify) {
												str += $.formatString('<img onclick="modifyFun(\'{0}\');" src="{1}" title="${internationalConfig.修改}"/>', row.id, '${pageContext.request.contextPath}/static/style/images/extjs_icons/pencil.png');
											}
											
											str += '&nbsp;&nbsp;&nbsp;';
											if ($.canDelete) {
												str += $.formatString('<img onclick="deleteFun(\'{0}\');" src="{1}" title="${internationalConfig.删除}"/>', row.id, '${pageContext.request.contextPath}/static/style/images/extjs_icons/cancel.png');
											}
											return str;
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
	
	function searchFun() {
		dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
	}
	
	function addFun() {
		parent.$.modalDialog({
			title : '${internationalConfig.添加角色}',
			width : 500,
			height : 400,
			href : '${pageContext.request.contextPath}/share_role/add.json',
			buttons : [ {
				text : '${internationalConfig.添加}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#addform');
					f.submit();
				}
			} ]
		});
	}
	
	function deleteFun(id) {
		parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.您是否要删除当前角色}', function(b) {
			if (b) {
				parent.$.messager.progress({
					title : '${internationalConfig.提示}',
					text : '${internationalConfig.数据处理中请稍后}'
				});
				$.post('${pageContext.request.contextPath}/share_role/delete.json', {
					id : id
				}, function(result) {
					if (result.success) {
						dataGrid.datagrid('reload');
					}
					parent.$.messager.alert('${internationalConfig.提示}', result.msg, 'info');
					parent.$.messager.progress('close');
				}, 'JSON');
			}
		});
	}
	
	function modifyFun(id) {
		parent.$.modalDialog({
			title : '${internationalConfig.修改角色}',
			width : 500,
			height : 400,
			href : '${pageContext.request.contextPath}/share_role/modify.json?id=' + id,
			buttons : [ {
				text : '${internationalConfig.修改}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
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
		<div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
			style="height: 100px; overflow: hidden;">
			<form id="searchForm">
				<table class="table table-hover table-condensed"
					style="display: none;">
					<tr>
						<th></th>
                        <td>${internationalConfig.角色选择}：<select name="roleId" style="width: 160px">
                            <option value="-1" selected>${internationalConfig.全部}</option>
                          <c:forEach items="${roleList}" var="var">
        				    <option value='${var.id}' >${var.name}</option>
                          </c:forEach>
                        </select>
						</td>
						<th></th>
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
			data-options="iconCls:'bug_add',plain:true" onclick="addFun();">${internationalConfig.增加}</a>
	</div>
</body>
</html>
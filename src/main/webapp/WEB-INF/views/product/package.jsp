<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.套餐管理}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>

<script type="text/javascript">
<m:auth uri="/package/package_edit.json">
	$.canEdit = true;
</m:auth>
<m:auth uri="/package/delete.json">
	$.canDelete = true;
</m:auth>
<m:auth uri="/package/package_view.json">
	$.canView = true;
</m:auth>
</script>

<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = renderDataGrid('/package/data_grid.json');
	});

	function renderDataGrid(url) {
		return $('#dataGrid')
				.datagrid(
						{
							url : url,
							fit : true,
							fitColumns : true,
							border : false,
							pagination : true,
							idField : 'id',
							pageSize : 50,
							pageList : [ 50, 100 ],
							sortName : 'packageName',
							sortOrder : 'asc',
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
							columns : [ [
							         	{
											field : 'id',
											title : '${internationalConfig.套餐Id}',
											width : 50,
											sortable : false
										},
									{
										field : 'packageNameDesc',
										title : '${internationalConfig.套餐类型}',
										width : 200,
										sortable : false
									},
									{
										field : 'durationDesc',
										title : '${internationalConfig.套餐名称}',
										width : 150,
										sortable : false

									},
									{
										field : 'vipDesc',
										title : '${internationalConfig.套餐描述}',
										width : 150,
										sortable : false

									},
									{
										field : 'sort',
										title : '${internationalConfig.排序}',
										width : 100,
										sortable : false

									},
									{
										field : 'days',
										title : '${internationalConfig.套餐时长}',
										width : 100,
										sortable : false

									},
									{
										field : 'terminalList',
										title : '${internationalConfig.终端}',
										width : 180,
										formatter : function(terminalsList) {
											return $
													.map(
															terminalsList,
															function(terminal) {
																return terminal.terminalName;
															}).join(", ");
										}
									},
									{
										field : 'groupIdsDesc',
										title : '${internationalConfig.所属分组}',
										width : 100,
									},
						/*  套餐功能		
									{
										field : 'featureList',
										title : '${internationalConfig.功能}',
										width : 150,
										formatter : function(featureList) {
											return $
													.map(
															featureList,
															function(feature) {
																return feature.description;
															}).join(", ");

										}
									},
						*/	
									{
										field : 'ruleList',
										title : '${internationalConfig.规则}',
										width : 150,
										formatter : function(ruleList) {
											return $
													.map(
															ruleList,
															function(rule) {
																return rule.description;
															}).join(", ");

										}
									},
									{
										field : 'price',
										title : '${internationalConfig.价格}(${internationalConfig.元})',
										width : 120
									},
									{
										field : 'status',
										title : '${internationalConfig.套餐状态}',
										width : 150,
										sortable : false,
										formatter : function(data) {
											if (data == 20) {
			                                    return "${internationalConfig.上线}"
			                                } else if (data == 21) {
			                                    return "${internationalConfig.下线}"
			                                }
										}
									},
									{
										field : 'updateTime',
										title : '${internationalConfig.最后修改时间}',
										width : 150,
										sortable : true
									},
									/*  {
									      field: 'username',
									      title: "责任人",
									      width: 150,
									      sortable: true
									  },*/
									{
										field : 'action',
										title : '${internationalConfig.操作}',
										width : 140,
										formatter : function(value, row, index) {
											var str = '';
											
											if ($.canEdit) {
												str += $
														.formatString(
																'<img onclick="editFun(\'{0}\');" src="{1}" title="${internationalConfig.编辑}"/>',
																row.id,
																'/static/style/images/extjs_icons/bug/bug_edit.png');
											}
											 str += '&nbsp;';
											 if ($.canDelete) {
											     str += $.formatString('<img onclick="deleteFun(\'{0}\');" src="{1}" title="${internationalConfig.删除}"/>', row.id, '/static/style/images/extjs_icons/bug/bug_delete.png');
											 }
											str += '&nbsp;';
											
											if ($.canView) {
												str += $
														.formatString(
																'<img onclick="viewFun(\'{0}\');" src="{1}" title="${internationalConfig.查看}"/>',
																row.id,
																'/static/style/images/extjs_icons/bug/bug_link.png');
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
	}

	function deleteFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		}
		parent.$.messager
				.confirm(
						'${internationalConfig.询问}',
						'${internationalConfig.您是否要删除当前套餐}',
						function(b) {
							if (b) {
								parent.$.messager.progress({
									title : '${internationalConfig.提示}',
									text : '${internationalConfig.数据处理中}....'
								});
								$
										.post(
												'/package/delete.json',
												{
													packageId : id
												},
												function(result) {
													if (result.code == 0) {
														parent.$.messager
																.alert(
																		'${internationalConfig.提示}',
																		'${internationalConfig.删除成功}',
																		'info');
														dataGrid
																.datagrid('reload');
													}
													parent.$.messager
															.progress('close');
												}, 'JSON');
							}
						});
	}

	function editFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		}

		parent.$.modalDialog({
			title : '${internationalConfig.编辑套餐}',
			width : 780,
			height : 500,
			href : '/package/package_edit.json?packageId='
					+ id,
			onClose:function(){
				this.parentNode.removeChild(this);
			},		
			buttons : [ {
				text : '${internationalConfig.保存}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
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

	function viewFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		}
		parent.$.modalDialog({
			title : '${internationalConfig.查看套餐}',
			width : 780,
			height : 500,
			href : '/package/package_view.json?packageId='
					+ id,
			buttons : [ 
			{
				text : "${internationalConfig.关闭}",
				handler : function() {
					parent.$.modalDialog.handler.dialog('close');
				}
			} ]
		});
	}

	function addFun() {
		parent.$.modalDialog({
			title : '${internationalConfig.添加套餐}',
			width : 780,
			height : 500,
			href : '/package/package_add.json',
			onClose:function(){
				this.parentNode.removeChild(this);
			},	
			buttons : [ {
				text : '${internationalConfig.增加}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
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

	function searchFun() {
		parent.$.messager.progress({
			title : '${internationalConfig.提示}',
			text : '${internationalConfig.数据处理中}....'
		});
		renderDataGrid('/package/search.json?'
				+ $('#searchForm').serialize());
		parent.$.messager.progress('close');
	}
	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'">
			<form id="searchForm">
				<table  class="table-more">
					<tr>
						<td>${internationalConfig.套餐类型}：<select class="span2" name="packageName" style="margin-top: 5px">
								<option value="-1" selected="selected">${internationalConfig.所有套餐}</option>
								<c:forEach items="${packageNames}" var="packageName">
									<option value="${packageName.id}">${packageName.description}</option>
								</c:forEach>
						</select></td>
						<td>${internationalConfig.状态}：<select class="span2" name="status" style="margin-top: 5px">
								<option value="-1" selected="selected">${internationalConfig.所有状态}</option>
								   <option value="21">${internationalConfig.下线}</option>
                                   <option value="20">${internationalConfig.上线}</option>
						</select></td>
						<td>${internationalConfig.所属分组}：<select class="span2" name="groupId" style="margin-top: 5px">
								<option value="0" selected="selected">${internationalConfig.所有分组}</option>
								<c:forEach items="${packageGroups}" var="pg">
									<c:if test="${pg == '1'}">
										<option value="${pg}">${internationalConfig.默认}</option>
									</c:if>
									<c:if test="${pg != '1'}">
									<option value="${pg}">${pg}</option>
									</c:if>
								</c:forEach>
						</select></td>
						<td>${internationalConfig.终端}：<c:forEach items="${terminals}" var="terminal">
							<input type="checkbox" value="${terminal.terminalId}"
								name="terminals"> <span>${terminal.terminalName}</span>
							
						</c:forEach></td>
					</tr>
				</table>
			</form>
		</div>
		<div data-options="region:'center',border:false">
			<table id="dataGrid"></table>
		</div>
	</div>
	<div id="toolbar" style="display: none;">
		<m:auth uri="/package/add.json">
			<a onclick="addFun();" href="javascript:void(0);"
				class="easyui-linkbutton"
				data-options="plain:true,iconCls:'pencil_add'">${internationalConfig.增加}</a>
		</m:auth>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
	</div>
</body>
</html>
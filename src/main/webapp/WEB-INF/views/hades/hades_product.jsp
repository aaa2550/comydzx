<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<title>商品管理</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>

<script type="text/javascript">
<m:auth uri="/hades/product/hades_product_edit.json">
	$.canEdit = true;
</m:auth>
</script>

<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = renderDataGrid('${pageContext.request.contextPath}/hades/product/data_grid.json?'+ $('#searchForm').serialize());
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
							pageSize : 10,
							pageList : [ 10, 20, 30, 40, 50 ],
							sortName : 'id',
							sortOrder : 'asc',
							checkOnSelect : false,
							selectOnCheck : false,
							striped : true,
							rownumbers : true,
							singleSelect : true,
							frozenColumns : [ [ {
								field : 'id',
								title : '编号',
								width : 150,
								hidden : true
							} ] ],
							columns : [ [
									{
										field : 'id',
										title : '商品ID',
										width : 150,
										sortable : true
									},
									{
										field : 'marketName',
										title : '商品名称',
										width : 150,
										sortable : true

									},
									{
										field : 'sku',
										title : 'sku',
										width : 150,
										sortable : true,
										styler: function(value,row,index){
											return {'class':'text-ellipsis'}
											}

									},
									{
										field : 'displayPrice',
										title : '显示价格',
										width : 50,
										sortable : true
									},
									{
										field : 'status',
										title : '状态',
										width : 52,
										sortable : true,
										formatter : function(status) {
											if(status == "ONLINE") {
												return $.formatString('<font style="color:green;">上线</font>');
											} else {
												return $.formatString('<font style="color:red;">下线</font>');
											}
										}
									},
									{
										field : 'prdImg',
										title : '商品图片',
										width : 150,
										sortable : true,
										formatter : function(prdImg) {
											
											if(!prdImg) {
												return "";
											}
											
											return $
											.formatString(
													'<a href="{0}" target="_blank"><img src="{1}" title="商品图片"/></a>',
													prdImg,
													prdImg);

										}
									},
									{
										field : 'downloadUrl',
										title : '商品下载地址',
										width : 50,
										sortable : true,
										formatter : function(downloadUrl) {
											if(!downloadUrl) {
												return "";
											}
											
											return $
											.formatString(
													'<a href="{0}">打开</a>',
													downloadUrl);

										}
									},
									{
										field : 'productCategory',
										title : '分类',
										width : 80,
										sortable : true
									},
									{
										field : 'dividedProportion',
										title : '分成比例',
										width : 80,
										sortable : true
									},
									{
										field : 'fulfillmentType',
										title : '商品处理方式',
										width : 150,
										sortable : true,
										formatter : function(fulfillmentType) {
											if(fulfillmentType == "D") {
												return $.formatString('<font style="color:green;">无需配送</font>');
											} else if(fulfillmentType == "E") {
												return $.formatString('<font style="color:red;">第三方配送</font>');
											} else {
												return $.formatString(fulfillmentType);
											}
										}
									},{
									      field: 'startActiveTime',
									      title: "起始时间",
									      width: 150,
									      sortable: true
									  },
									  {
									      field: 'endActiveTime',
									      title: "截止时间",
									      width: 150,
									      sortable: true
									  },
									  {
									      field: 'createTime',
									      title: "创建时间",
									      width: 150,
									      sortable: true
									  },
									  {
									      field: 'updateTime',
									      title: "更新时间",
									      width: 150,
									      sortable: true
									  },
									  {
									      field: 'updatedBy',
									      title: "操作者",
									      width: 150,
									      sortable: true
									  },
									{
										field : 'action',
										title : '操作',
										width : 100,
										formatter : function(value, row, index) {
											var str = '';
											
											if ($.canEdit) {
												str += $
														.formatString(
																'<img onclick="editFun(\'{0}\');" src="{1}" title="编辑"/>',
																row.id,
																'${pageContext.request.contextPath}/static/style/images/extjs_icons/bug/bug_edit.png');
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

	function editFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		}
		
		var appId = $("#appId").val();
		
		var dg = parent.$.modalDialog({
			title : '商品编辑',
			width : 800,
			height : 600,
			href : '${pageContext.request.contextPath}/hades/product/hades_product_edit.json?id=' + id + '&appId=' + appId,
			buttons : [ {
				text : '保存',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			} ],
            onClose : function() {
                parent.swfupload.destroy(false);
                parent.$.modalDialog.handler.dialog('destroy');
            }
		});
	}
	
	//分成比例
	function dividedProportion() {
		var appId = $("#appId").val();

		parent.$.modalDialog({
			title : '分成比例批量编辑',
			width : 400,
			height : 300,
			href : '${pageContext.request.contextPath}/hades/product/divided_proportion.json?appId=' + appId,
			buttons : [ {
				text : '保存',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			} ],
            onClose : function() {
                parent.swfupload.destroy(false);
                parent.$.modalDialog.handler.dialog('destroy');
            }
		});
	}
	
	function addFun() {
		var appId = $("#appId").val();
		
		parent.$.modalDialog({
			title : '商品编辑',
			width : 800,
			height : 600,
			href : '${pageContext.request.contextPath}/hades/product/hades_product_edit.json?appId=' + appId,
			buttons : [ {
				text : '保存',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			} ],
            onClose : function() {
                parent.swfupload.destroy(false);
                parent.$.modalDialog.handler.dialog('destroy');
            }
		});
	}
	
	function searchFun() {
		parent.$.messager.progress({
			title : '提示',
			text : '数据处理中，请稍后....'
		});
		renderDataGrid('${pageContext.request.contextPath}/hades/product/data_grid.json?'
				+ $('#searchForm').serialize());
		parent.$.messager.progress('close');
	}
	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}
	$(function(){
    	var co = new Boss.util.combo()
    	
    	$(co).bind('select',function(eventName,el){
    		$('#appId').val(el.attr('data-id'));
    		searchFun()				
    	})
    });
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'查询条件',border:false" style="height: 80px; overflow: hidden;">
			<form id="searchForm" onsubmit="return false;">
				<table class="table-td-two">
					<tr>
					<td>应用名称：<input id="inputSearch"  class="span2 input-box" autocomplete="off"/>
								<input type="hidden" name="appId" id="appId" class="span2" /></td>
				</tr>
				</table>
			</form>
		</div>
		<div data-options="region:'center',border:false">
			<table id="dataGrid"></table>
		</div>
	</div>
	<div id="toolbar" style="display: none;">
		<m:auth uri="/hades/product/hades_product_edit.json">
			<a onclick="addFun();" href="javascript:void(0);"
				class="easyui-linkbutton"
				data-options="plain:true,iconCls:'bug_add'">添加</a>
		</m:auth>
		<m:auth uri="/hades/product/divided_proportion.json">
			<a onclick="dividedProportion();" href="javascript:void(0);"
				class="easyui-linkbutton"
				data-options="plain:true,iconCls:'bug_add'">分成比例批量修改</a>
		</m:auth>
	</div>
</body>
</html>
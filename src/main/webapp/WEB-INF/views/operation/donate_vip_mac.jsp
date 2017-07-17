<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<title>套餐管理</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>

<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = renderDataGrid('${pageContext.request.contextPath}/donate_vip_mac/data_grid.json');
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
							checkOnSelect : false,
							selectOnCheck : false,
							nowrap : false,
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
										field : 'mac',
										title : 'MAC',
										width : 150,
										sortable : false
									},
									{
										field : 'channel',
										title : '渠道',
										width : 150,
										sortable : false

									},
									{
										field : 'existFlag',
										title : '是否已经领取',
										width : 50,
										formatter : function(value) {
											var str = '';
											if("0" == value) {
												str = "否";
											}else if("1" == value) {
												str = "是";
											}
											
											return str;
										}
									},
									{
										field : 'userId',
										title : '用户id',
										width : 150,
										sortable : false

									},
									{
										field : 'userName',
										title : '用户名',
										width : 150,
										sortable : false

									},
									{
										field : 'payTime',
										title : '下单时间',
										width : 150,
										sortable : false

									},  {
										field : 'action',
										title : '操作',
										width : 80,
										formatter : function(value, row, index) {
											var str = '';
											if (row.existFlag == 1) {
												str += $.formatString('<img onclick="unbindFun(\'{0}\', \'{1}\');" src="{2}" title="解绑"/>', row.mac, row.channel, '${pageContext.request.contextPath}/static/style/images/extjs_icons/pencil.png');
											}
											
											return str;
										}
									}]],
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
	
	function unbindFun(mac, channel) {
		if (mac == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			mac = rows[0].mac;
		}
		if (channel == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			channel = rows[0].channel;
		}
		
		parent.$.messager
				.confirm(
						'询问',
						'您确定要解绑次mac吗？',
						function(b) {
							if (b) {
								parent.$.messager.progress({
									title : '提示',
									text : '数据处理中，请稍后....'
								});
								$
										.post(
												'${pageContext.request.contextPath}/donate_vip_mac/unbind.json',
												{
													channel : channel,
													mac : mac
												},
												function(result) {
													if (result.code == 0) {
														parent.$.messager
																.alert(
																		'提示',
																		'解绑成功',
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

	function searchFun() {
		dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
	}
	
	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}

	function importUnbindFile() {
		parent.$.modalDialog({
			title: '导入解绑文件',
			width: 680,
			height: 300,
			href: '${pageContext.request.contextPath}/donate_vip_mac/unbind_donate_mac.json',
			buttons: [
				{
					text: '导入解绑文件',
					handler: function () {
						parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
						var f = parent.$.modalDialog.handler.find('#form');
						f.submit();
					}
				},
				{
					text: "关闭",
					handler: function () {
						parent.$.modalDialog.handler.dialog('close');
					}
				}
			]
		});
	}
	
	function importFile() {
        parent.$.modalDialog({
            title: '导入对账文件',
            width: 680,
            height: 300,
            href: '${pageContext.request.contextPath}/donate_vip_mac/import_donate_mac.json',
            buttons: [
                {
                    text: '导入文件',
                    handler: function () {
                        parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#form');
                        f.submit();
                    }
                },
                {
                    text: "关闭",
                    handler: function () {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                }
            ]
        });
    }
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'查询条件',border:false"
			style="overflow: hidden;height:85px;">
			<form id="searchForm">
				<table  class="table-td-two">
					<tr>
						<td>MAC地址：<input type="text" name="mac" ></td>
						<td>渠道：<input type="text" name="channel" ></td>
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
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>
		<m:auth uri="/donate_vip_mac/import_donate_mac.json">
			<a onclick="importFile();" href="javascript:void(0);"
				class="easyui-linkbutton"
				data-options="plain:true,iconCls:'bug_add'">导入mac</a>
		</m:auth>
		<m:auth uri="/donate_vip_mac/unbind_donate_mac.json">
			<a onclick="importUnbindFile();" href="javascript:void(0);"
			   class="easyui-linkbutton"
			   data-options="plain:true,iconCls:'bug_add'">解绑mac</a>
		</m:auth>
	</div>
</body>
</html>
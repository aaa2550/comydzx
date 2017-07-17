<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>积分商城-商品管理</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript" src="/js/dict.js"></script>
<script type="text/javascript" src="/js/kv/packages.js"></script>
<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '/mall/data_grid',
							queryParams:$.serializeObject($('#searchForm')),
							fit : true,
							fitColumns : true,
							border : false,
							pagination : true,
							pageSize : 20,
							pageList : [ 10, 20, 30, 40, 50 ],
							sortName : 'channel',
							sortOrder : 'asc',
							checkOnSelect : false,
							selectOnCheck : false,
							singleSelect : true,
							nowrap : false,
							striped : true,
							rownumbers : true,
							singleSelect : true,
							columns : [ [
									{
										field : 'itemId',
										title : '商品号',
										width : 60
									},{
										field : 'channel',
										title : '渠道商',
										width : 60,
									 	formatter: function(value){
									 		return Dict.getName("operator",value);
					                    }
									},{
										field : 'applyPackage',
										title : '套餐',
										width : 60,
									 	formatter: function(value){
					                    	return Dict.packages[value];
					                    }
									},
									{
										field : 'price',
										title : '价格',
										width : 60
									},
									{
										field : 'discount',
										title : '折扣',
										width : 60
									},
									{
										field : 'updateTime',
										title : '更新时间',
										width : 60,
										sortable : true
									},
									{
										field : 'operatorId',
										title : '操作者',
										width : 60
									
									} 
									,
									{
										field : 'action',
										title : '操作',
										width : 60,
										formatter : function(value, row, index) {
											var str = '';
											
											str += $.formatString('<img onclick="addLecardItemFun(\'{0}\',{1});" src="{2}" title="编辑"/>', row.itemId,row.channel, '/static/style/images/extjs_icons/pencil.png');
											str += $.formatString('<img onclick="delFun(\'{0}\',{1})" src="{2}" title="删除"/>', row.itemId,row.channel, '/static/style/images/extjs_icons/cancel.png');
										
											return str;
										}
									}] ],
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
	function addLecardItemFun(item,channel){
		
		var url="/mall/add_item" ;
		if(item){
			url+="?itemId="+item+"&channel="+channel ;
		}
		parent.$.modalDialog({
			title : '编辑商品',
			width : 600,
			height : 350,
			href : url,
			buttons : [ {
				text : '保存商品',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			} ]
		});
	}
	
	function delFun(item,channel){
		if(window.confirm("确定删除吗?")){
			$.post("/mall/del_item",{itemId:item,channel:channel},function(result){
				parent.$.messager.alert('成功', result.msg, 'success');
				dataGrid.datagrid('reload'); 
			},"JSON");
		}
		
	}
	
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'查询条件',border:false"
			style="height: 80px; overflow: hidden;">
			<form id="searchForm">
				<table class="table-td-three"
					style="display: none;">
					<tr>
						<td>渠道商：
						<select name="channel"
							style="width: 165px">
							<option value="0">全部</option>
								<c:forEach items="${dict.operator}" var="operator">
									<option value="${operator.key}">${operator.value}</option>
								</c:forEach>
						</select>
						</td>
						<td>商品编码：<input name="itemId" class="span2"/></td>
						
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
			data-options="iconCls:'pencil_add',plain:true" onclick="addLecardItemFun();">增加商品</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_delete',plain:true"
			onclick="cleanFun();">清空条件</a>
	</div>
</body>
</html>
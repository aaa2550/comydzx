<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.渠道返利}-${internationalConfig.设备销售}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript" src="/js/kv/rebateChannel.js"></script>
<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '/rebate/channel/device_list',
							queryParams:$.serializeObject($('#searchForm')),
							fit : true,
							fitColumns : true,
							border : false,
							pagination : true,
							idField : 'id',
							pageSize : 30,
							pageList : [ 20, 30, 40, 50 ],
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
								field : 'id',
								title : '${internationalConfig.编号}',
								width : 50,
								hidden : true
							} ] ],
							columns : [ [
									{
										field : 'id',
										title : 'id',
										width : 60,
										sortable : false
									},
									{
										field : 'name',
										title : '${internationalConfig.批次标识}',
										width : 200,
									},
									{
										field : 'channel',
										title : '${internationalConfig.渠道}',
										width : 200,
										formatter:function(value){
										 	return Dict.rebateChannel[value];
									}
									},
									{
										field : 'status',
										title : '${internationalConfig.状态}',
										width : 200,
										formatter : function(value, row, index) {
											  if(value==1){
												  return "${internationalConfig.有效}";
											  }else if(value==2){
												  return "${internationalConfig.失效}";
											  }
											  return "${internationalConfig.暂停}";
											}
									},
									{
										field : 'principal',
										title : '${internationalConfig.销售人}',
										width : 80
									},
									{
										field : 'devicetype',
										title : '${internationalConfig.设备类型}',
										width : 80,
										formatter : function(value, row, index) {
											  if(value==1){
												  return "${internationalConfig.超级电视}";
											  }else if(value==2){
												  return "${internationalConfig.超级手机}";
											  }
											  return "${internationalConfig.暂停}";
											}
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
						 			//	str += $.formatString(	'<img onclick="deleteFun(\'{0}\');" src="{1}" title="${internationalConfig.删除}"/>',row.id,'/static/style/images/extjs_icons/cancel.png');
									str += "&nbsp;&nbsp;"+$.formatString('<img onclick="exportExcel(\'{0}\');" src="{1}" title="${internationalConfig.导出excel}"/>', row.id, '/static/style/images/extjs_icons/bug/bug_edit.png');
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
			width : 600,
			height : 400,
			href : '/rebate/channel/device_edit?id='+id,
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
			$.get("/rebate/channel/delete/"+id+"?type=device",function(){
				parent.$.messager.alert("${internationalConfig.提示}","${internationalConfig.删除成功}!");
				dataGrid.datagrid('reload');
			});
		
		}
	}
	
	function exportExcel(batch) {	   
	    var url = '/rebate/export/devices.do?batchId=' + batch;
	    location.href = url;
	}
</script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
			style="overflow: hidden; height: 145px">
        <form id="searchForm">
            <table class="table-more" style="display: none;">

							<tr>
					
				<td ><span>${internationalConfig.批次标识}：</span><input name="name" type="text" class="easyui-validatebox span2"  value="${channel.name }"></td>
						
				 <td><span>${internationalConfig.销售渠道}：</span>
				<select name="channel">		
				<option value="0">${internationalConfig.全部}</option>
				<c:forEach items="${ channels}" var="item">
					<option value="${item.id }"   >${item.name }</option>
					</c:forEach>
					</select>
				</td>
								
			     <td>	<span>${internationalConfig.状态}：</span>
				<select name="status">	
				    <option value="0">${internationalConfig.全部}</option>
					<option value="1">${internationalConfig.有效}</option>
					<option value="2">${internationalConfig.失效}</option>
					<option value="3">${internationalConfig.暂停}</option>
					</select>
				</td>
				</tr>
				<tr>
					
					<td>	<span>${internationalConfig.更新时间}：</span>
				
				     <input type="text" name="createTime"  style="width: 165px"
                                   class="easyui-datebox" class="easyui-validatebox"   />-
                                        <input type="text" name="updateTime"   style="width: 165px"
                                   class="easyui-datebox" class="easyui-validatebox"  />
				</td>
								
					<td ><span>${internationalConfig.销售人}：</span><input type="text"  name="principal"  value="${channel.principal }"     /></td>
										<td ><span>${internationalConfig.设备类型}：</span>
					
				<select name="devicetype">				
				  <option value="0">${internationalConfig.全部}</option>
				<option value="1">${internationalConfig.超级电视}</option>
				<option value="2">${internationalConfig.超级手机}</option>
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
			data-options="iconCls:'pencil_add',plain:true" onclick="addFun(0);">${internationalConfig.增加}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_delete',plain:true"
			onclick="cleanFun();">${internationalConfig.清空条件}</a>
	</div>
</body>
</html>
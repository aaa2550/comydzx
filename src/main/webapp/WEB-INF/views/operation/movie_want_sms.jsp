<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.电影频道}-${internationalConfig.预约影片用户短信触达设置}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
			style="overflow: hidden; height: 145px">
        <form id="searchForm">
            <table class="table-more" style="display: none;">
							<tr>					
					<td ><span>pid：</span><input name="pid" type="text" class="easyui-validatebox span2"  value=""></td>		
			     <td>	<span>${internationalConfig.状态}：</span>
				<select name="flag">	
				    <option value="0">${internationalConfig.全部}</option>
					<option value="1">${internationalConfig.未发送}</option>
					<option value="2">${internationalConfig.已发送}</option>
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
			data-options="iconCls:'pencil_add',plain:true" onclick="addFun(0);">${internationalConfig.增加渠道}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_delete',plain:true"
			onclick="cleanFun();">${internationalConfig.清空条件}</a>
	</div>
</body>
<script type="text/javascript">

	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '/movie_want/sms/list',
							queryParams:$.serializeObject($('#searchForm')),
							fit : true,
							fitColumns : true,
							border : false,
							pagination : true,
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
								field : 'pid',
								title : '${internationalConfig.编号}',
								width : 50,
								hidden : true
							} ] ],
							columns : [ [
									{
										field : 'pid',
										title : 'pid',
										width : 60,
										sortable : false
									},{
										field : 'content',
										title : '${internationalConfig.短信内容}',
										width : 200
									},{
										field : 'opTime',
										title : '${internationalConfig.发送时间}',
										width : 200,
									},
									{
										field : 'flag',
										title : '${internationalConfig.状态}',
										width : 200,
										formatter : function(value, row, index) {
											  if(value==1){
												  return "${internationalConfig.未发送}";
											  }
											  return "${internationalConfig.已发送}";
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
											var str="" ;
											if(row.flag==1){
												 str+= $.formatString('<img onclick="addFun(\'{0}\');" src="{1}" title="${internationalConfig.编辑}"/>', row.pid, '/static/style/images/extjs_icons/pencil.png');
													str += $.formatString(	'<img onclick="deleteFun(\'{0}\');" src="{1}" title="${internationalConfig.删除}"/>',row.pid,'/static/style/images/extjs_icons/cancel.png');
											}else{
												str="${internationalConfig.已发送}";
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
			href : '/movie_want/sms/edit?id='+id,
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
			$.get("/movie_want/sms/delete/"+id,function(){
				parent.$.messager.alert("${internationalConfig.提示}","${internationalConfig.删除成功}!");
				dataGrid.datagrid('reload');
			});
		
		}
	}
</script>
</html>
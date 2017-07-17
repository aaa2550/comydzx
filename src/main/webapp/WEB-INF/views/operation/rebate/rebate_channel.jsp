<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.渠道返利}-${internationalConfig.渠道配置}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
var channelType=${channelType} ;
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '/rebate/channel/list',
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
										title : '${internationalConfig.渠道}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>id',
										width : 60,
										sortable : false
									},{
										field : 'type',
										title : '${internationalConfig.渠道类型}',
										width : 60,
										formatter : function(value, row, index) {
											  return channelType[value] ;
											}
									},{
										field : 'name',
										title : '${internationalConfig.渠道名称}',
										width : 200,
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
										title : '${internationalConfig.负责人}',
										width : 80
									},
									{
										field : 'level',
										title : '${internationalConfig.渠道级别}',
										width : 80
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
											str += $.formatString(	'<img onclick="deleteFun(\'{0}\');" src="{1}" title="${internationalConfig.删除}"/>',row.id,'/static/style/images/extjs_icons/cancel.png');
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
			href : '/rebate/channel/edit?id='+id,
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
			$.get("/rebate/channel/delete/"+id,function(){
				parent.$.messager.alert("${internationalConfig.提示}","${internationalConfig.删除成功}!");
				dataGrid.datagrid('reload');
			});
		
		}
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
					
					<td ><span>${internationalConfig.渠道名称}：</span><input name="name" type="text" class="easyui-validatebox span2"  value="${channel.name }"></td>
						
				 <td><span>${internationalConfig.渠道类型}：</span>
				<select name="type">		
			  <option value="0">${internationalConfig.全部}</option>
				<c:forEach items="${ channelType}" var="item">
					<option value="${item.key }"   >${item.value }</option>
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
					
					<td>	<span>${internationalConfig.区域}：</span>
				
				<select name="area">	
					  <option value="0">${internationalConfig.全部}</option>
					<c:forEach items="${ province}" var="item">
					<option value="${item.key }"   >${item.value }</option>
					</c:forEach>
					</select>
				</td>
								
					<td ><span>${internationalConfig.负责人}：</span><input type="text"  name="principal"  value="${channel.principal }"     /></td>
										<td ><span>${internationalConfig.渠道级别}：</span>
					
				<select name="level">				
				  <option value="0">${internationalConfig.全部}</option>
					<c:forEach begin="1"  end="10" var="item">
					<option value="${item }"   >${item }<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.级}</option>
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
			data-options="iconCls:'pencil_add',plain:true" onclick="addFun(0);">${internationalConfig.增加渠道}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_delete',plain:true"
			onclick="cleanFun();">${internationalConfig.清空条件}</a>
	</div>
</body>
</html>
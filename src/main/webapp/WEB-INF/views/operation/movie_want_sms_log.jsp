<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.电影频道}-${internationalConfig.预约影片用户信息查询}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
			style="overflow: hidden; height: 145px">
        <form id="searchForm">
            <table class="table-more" style="display: none;">
							<tr>					
					<td ><span>pid：</span>		<input name="pid" type="text"  value=""   class="easyui-numberbox"   data-options="min:1,required:true" ></td>		
			   
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
			data-options="iconCls:'brick_delete',plain:true"
			onclick="cleanFun();">${internationalConfig.清空条件}</a>
			<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'pencil_add',plain:true" onclick="exportExcel();">${internationalConfig.导出}</a>
	</div>
</body>
<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '/movie_want/sms/list_log',
							queryParams:$.serializeObject($('#searchForm')),
							fit : true,
							fitColumns : true,
							border : false,
							pagination : true,
							pageSize : 100,
							pageList : [ 100,200, 300, 400, 500 ],
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
										field : 'uid',
										title : 'UID',
										width : 60,
										sortable : false
									},{
										field : 'mobile',
										title : '${internationalConfig.手机号}',
										width : 60,
										formatter : function(value, row, index) {
											  return channelType[value] ;
											}
									},{
										field : 'opTime',
										title : '${internationalConfig.发送时间}',
										width : 200,
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
	
	function exportExcel() {
		 var batch=$("input[name=pid]").val();
		 if(batch==''){
			 parent.$.messager.alert("${internationalConfig.提示}","${internationalConfig.请输入}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>Pid!");
			 return ;
		 }
	    var url = '/movie_want/sms/export/' + batch;
	    //alert(url) ;
	    location.href = url;
	}

</script>
</html>
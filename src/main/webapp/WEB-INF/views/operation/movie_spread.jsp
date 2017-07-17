<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>付费影片推广</title>
<%@ include file="/WEB-INF/views/inc/head.inc" %>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'查询条件',border:false" style="height: 80px; overflow: hidden;">
			<form id="searchForm">
				<table class="table-more"
					style="display: none">
					<tr>
					<td>合作方：<select class="span2" id="cooperationID" name="cooperationID">
							<option value="360">360</option>
							<option  value="baidu_home">百度首页</option>
							<option  value="baidu_video">百度视频首页</option>
					</select>
					</td>
					<td>频道：<input type="radio" name="channel" id="album" value="movie" checked="checked">&nbsp;&nbsp;电影
					</td>
					<td>VID：<input type="text" class="span2" name="vid" id="vid" value=""></td>
					<td>影片名称：<input width="10px" class="span2" type="text" value="" id="title" name="title"></td>
				
				</tr>
				</table>
			</form>
		</div>
		<div data-options="region:'center'" style="height: 150px">
			<table id="dataGrid" style="height: 150px"></table>
		</div>
	</div>

	<div id="toolbar" style="display: none;">
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>
			<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="linkFun();">查看源文件</a>
	</div>
<script type="text/javascript">
var dataGrid;
$(function() {
	dataGrid = $('#dataGrid')
			.datagrid(
					{
						url : '${pageContext.request.contextPath}/movie_spread/data_grid.json',
						fitColumns : true,
						border : false,
						idField : 'id',
						checkOnSelect : false,
						selectOnCheck : false,
						nowrap : false,
						striped : true,
						rownumbers : true,
						singleSelect : true,
						frozenColumns : [ [

						] ],
						columns : [ [
								{
									field : 'movieName',
									title : '影片名称',
									width : 200
								},
								{
									field : 'indexUrl',
									title : '索引页',
									width : 300
								},
								{
									field : 'playLinkUrl',
									title : '链接',
									width : 300
								},
								{
									field : 'price',
									title : '价格',
									width : 30
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
function linkFun(){	
	var cooperationID=$("#cooperationID").val();
	var url="http://yuanxian.letv.com"; 
	if(cooperationID=="baidu_home"){
		url+="/letv/cintv.ldo?type=baidusearch";
	}else if(cooperationID=="baidu_video"){
		url+="/letv/cintv.ldo?type=cooperate&cooper=baidu&deleted=0";
	}else {
		/* if($("#fileType").val()=="total"){
			url+="/api/360xml/360_total.xml";
		}else{ */
			url+="/api/360xml/360_add.xml";
		}
	window.open(url);
}
</script>
</body>
</html>
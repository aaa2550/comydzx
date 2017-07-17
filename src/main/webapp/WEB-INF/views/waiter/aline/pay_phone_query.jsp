<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.付费手机号查询}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
</script>

<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '/pay_phone_query/data_grid.json',
							queryParams:$.serializeObject($('#searchForm')),
							fit : true,
							fitColumns : true,
							border : false,
							pagination : true,
							idField : 'id',
							pageSize : 50,
							pageList : [ 10, 20, 30, 40, 50 ],
							checkOnSelect : false,
							selectOnCheck : false,
							sortName : 'sp',
							sortOrder : 'desc',
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
										field : 'phone',
										title : '${internationalConfig.付费手机号}',
										width : 120,
										sortable : false
									},	
									{
										field : 'userid',
										title : '${internationalConfig.用户ID}',
										width : 120,
										sortable : false
									},
									{
										field : 'ordernumber',
										title : '${internationalConfig.订单号}',
										width : 200,
										sortable : false
									},
									{
										field : 'channelid',
										title : '${internationalConfig.支付通道名称}',
										width : 120,
										sortable : false,
										formatter : function(value) {
											if(value=='68'){
												return "${internationalConfig.移动}";
											}else if(value=='69'){
												return "${internationalConfig.联通}";
											}else if(value=='70'){
												return "${internationalConfig.电信}";
											}else if(value=='268'){
												return "${internationalConfig.移动}-v1";
											}else if(value=='269'){
												return "${internationalConfig.联通}-v1";
											}else if(value=='270'){
												return "${internationalConfig.电信}-v1";
											}
											return value;
										}
									},
									{
										field : 'createtime',
										title : '${internationalConfig.创建时间}',
										width : 120,
										sortable : false
									},
									{
										field : 'updatetime',
										title : '${internationalConfig.更新时间}',
										width : 120,
										sortable : false
									},
									{
										field : 'renewflag',
										title : '${internationalConfig.订购状态}',
										width : 180,
										sortable : false,
										formatter : function(value,row) {
											if(value==0){
												return "${internationalConfig.退订}";
											}else if(value==1){
												return "${internationalConfig.订购中}";
											}
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
	Date.prototype.format = function(format) {
		if (!format) {
			format = "yyyy-MM-dd hh:mm:ss";
		}
		var o = {
			"M+" : this.getMonth() + 1, // month
			"d+" : this.getDate(), // day
			"h+" : this.getHours(), // hour
			"m+" : this.getMinutes(), // minute
			"s+" : this.getSeconds(), // second
			"q+" : Math.floor((this.getMonth() + 3) / 3), // quarter
			"S" : this.getMilliseconds()
		// millisecond
		};
		if (/(y+)/.test(format)) {
			format = format.replace(RegExp.$1, (this.getFullYear() + "")
					.substr(4 - RegExp.$1.length));
		}
		for ( var k in o) {
			if (new RegExp("(" + k + ")").test(format)) {
				format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k]
						: ("00" + o[k]).substr(("" + o[k]).length));
			}
		}
		return format;
	};
	function formatterdate(val, row) {
		var date = new Date(val);
		if (date = "Invalid Date") {
			return "";
		}
		return date.format("yyyy-MM-dd hh:mm:ss");
	}
	function searchFun() {
		var userId = $('#userid').val().trim();
		var phone = $('#phone').val().trim();
		if('' == userId && '' == phone){
			$.messager.alert('${internationalConfig.错误}', '${internationalConfig.请输入用户ID或者付费手机号}', 'error');
			return;
		}
		dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
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
				<table class="table-td-more">
					<tr>
						<td>${internationalConfig.用户ID}：<input id="userid" name="userid" value="${param.userId}" class="span2"/>
						</td>
						<td>${internationalConfig.付费手机号}：<input id="phone" name="phone" class="span2"/>
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
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a><a
			href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_delete',plain:true"
			onclick="cleanFun();">${internationalConfig.清空条件}</a>
	</div>
	<!-- <div id="win" class="easyui-window" title="输入提示框" closed="true" 
	 collapsible="false" minimizable="false" maximizable="false" style="width:300px;height:100px;padding:5px;color: red;">  
	<font size="2">请输入完整的用户名! </font>  
    </div>  -->
</body>
</html>
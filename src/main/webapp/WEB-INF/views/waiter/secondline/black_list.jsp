<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.黑名单}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
<m:auth uri="/black_list/allow.json">  $.canAllow = true;</m:auth>
	var dataGrid;
	var dataGridLogs;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '/black_list/data_grid.json',
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
										field : 'userId',
										title : '${internationalConfig.用户}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID',
										width : 100
									},
									{
										field : 'forbidden',
										title : '${internationalConfig.用户是否被禁用}',
										width : 150,
										formatter : function(value, row, index) {
											if (value == true) {
												return "${internationalConfig.被禁用}";
											} else {
												return "${internationalConfig.未被禁用}";
											}
										}
									},
									{
										field : 'action',
										title : '${internationalConfig.操作}',
										width : 180,
										formatter : function(value, row, index) {
											var str = '';
											if ($.canAllow
													&& row.forbidden == true) {
												str += $
														.formatString(
																'<img onclick="allow(\'{0}\');" src="{1}" title="${internationalConfig.解禁}"/>',
																row.userId,
																'${pageContext.request.contextPath}/static/style/images/extjs_icons/pencil.png');
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
	
		dataGridLogs = $('#dataGridLogs').datagrid({
			url : '${pageContext.request.contextPath}/black_list/logs.json',
			fit : true,
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
			columns : [ [ {
				field : 'userId',
				title : '${internationalConfig.用户}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID',
				width : 50
			}, {
				field : 'operateType',
				title : '${internationalConfig.操作类型}',
				width : 50
			}, {
				field : 'operateName',
				title : '${internationalConfig.操作描述}',
				width : 50
			}, {
				field : 'createTime',
				title : '${internationalConfig.创建时间}',
				width : 100,
				formatter : formatterdate
			}, {
				field : 'detail',
				title : '${internationalConfig.详情}',
				width : 500
			} ] ],
			onLoadSuccess : function() {
				$('#searchForm table').show();
				parent.$.messager.progress('close');
			}
		});
	});

	function allow(userId) {
		parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.您是否要解禁当前用户}？', function(b) {
			if (b) {
				parent.$.messager.progress({
					title : '${internationalConfig.提示}',
					text : '${internationalConfig.数据处理中}....'
				});
				$.post('/black_list/allow.json', {
					'userId' : userId
				}, function(result) {
					var msg = result.msg;
					parent.$.messager.alert('${internationalConfig.提示}', msg, 'info');
					parent.$.messager.progress('close');
					dataGrid.datagrid('reload');
				}, 'JSON');
			}
		});
	}

	function searchFun() {
		dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
		dataGridLogs.datagrid('load', $.serializeObject($('#searchForm')));
	}
	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}
	
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
		if (val == null) {
			return "";
		}
		var date = new Date(val);
		return date.format("yyyy-MM-dd hh:mm:ss");
	}
</script>
</head>
<body>
	<div class="easyui-layout" style="height: 800px">
		<div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
			style="height: 100px; width: 500px; overflow: hidden;">
			<form id="searchForm">
				<table class="table-td-two"
					style="width: 800px">
					<tr>
						<td>${internationalConfig.用户}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID<input id="userId" name="userId"
							class="span2" />
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div data-options="region:'center'" style="height: 150px">
			<table id="dataGrid" style="height: 150px"></table>
		</div>
		<div data-options="region:'south',title:'${internationalConfig.日志}',collapsible:false" style="height: 500px">
			
			<table dada id="dataGridLogs" ></table>
		</div>
	</div>

	<div id="toolbar" style="display: none;">
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_delete',plain:true"
			onclick="cleanFun();">${internationalConfig.清空条件}</a>
	</div>
</body>
</html>
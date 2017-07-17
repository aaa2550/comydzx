<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/inc/head.inc" %>
<script type="text/javascript">
	<m:auth uri="/coupon_generate_task/export.do">
	    $.canExport = true;
	</m:auth>
</script>
<script type="text/javascript">
    $.canShow = true;
</script>
<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = renderDataGrid('/coupon_generate_task/query.json');
	});

	function renderDataGrid(url) {
		return $('#dataGrid')
				.datagrid(
						{
							url : url,
							fit : true,
							fitColumns : false,
							border : false,
							pagination : true,
							idField : 'id',
							pageSize : 10,
							pageList : [ 10, 20, 30, 40, 50 ],
							sortName : 'createTime',
							sortOrder : 'desc',
							checkOnSelect : false,
							selectOnCheck : false,
							nowrap : false,
							striped : true,
							rownumbers : true,
							singleSelect : true,
							remoteSort : false,
							method : 'get',
							frozenColumns : [ [] ],
							columns : [ [
									{
										field : 'id',
										title : '${internationalConfig.任务ID}',
										width : 80,
										sortable : false
									},
									{
										field : 'name',
										title : '${internationalConfig.代金券名称}',
										width : 100
									},
									{
										field : 'couponTemplateId',
										title : '${internationalConfig.模板}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID',
										width : 80
									},
									{
										field : 'amountFmt',
										title : '${internationalConfig.代金券面额}',
										width : 80,
										formatter : function(value) {
											return value + "${internationalConfig.元}";
										}
									},
									{
										field : 'startTime',
										title : '${internationalConfig.有效开始时间}',
										width : 100
									},
									{
										field : 'endTime',
										title : '${internationalConfig.有效结束时间}',
										width : 100
									},
									{
										field : 'createTime',
										title : '${internationalConfig.创建时间}',
										width : 100,
										sortable : true
									},
									{
										field : 'statusName',
										title : '${internationalConfig.状态}',
										width : 80,
										sortable : true
									},
									{
										field : 'ext',
										title : '${internationalConfig.备注}',
										width : 100,
										sortable : true
									},
									{
										field : 'num',
										title : '${internationalConfig.制定数量}',
										width : 100,
										sortable : true
									},
									{
										field : 'action',
										title : '${internationalConfig.操作}',
										width : 100,
										formatter : function(value, row, index) {
											var str = '&nbsp;&nbsp;&nbsp;';
											if ($.canRestart && !row.alive) {
												str += $
														.formatString(
																'<a href="#" onclick="restart(\'{0}\');" src="{1}" title="${internationalConfig.重启任务}">${internationalConfig.重启任务}</a>',
																row.id,
																'${pageContext.request.contextPath}/style/images/extjs_icons/bug/bug_delete.png');
											}

											if ($.canExport && row.status == 3 ) {
												str += '&nbsp;'
												str += $
														.formatString(
																'<a href="#" onclick="exportExcel(\'{0}\');" src="{1}" title="${internationalConfig.导出}">${internationalConfig.导出}</a>',
																row.id,
																'${pageContext.request.contextPath}/style/images/extjs_icons/bug/bug_delete.png');
											}

											if ($.canShow) {
												str += '&nbsp;'
												str += $
														.formatString(
																'<a href="${pageContext.request.contextPath}/coupon_generate_task/'+row.id+'/detail.do" target="_blank" src="{1}" title="${internationalConfig.查看}">${internationalConfig.查看}</a>',
																row.id,
																'${pageContext.request.contextPath}/style/images/extjs_icons/bug/bug_delete.png');
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
		var payDate = new Date(val);
		return payDate.format("yyyy-MM-dd");
	}

	function exportExcel(taskId) {
		if (taskId == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			taskId = rows[0].id;
		}
		var url = '/coupon_generate_task/export.do?taskId=' + taskId;
		//alert(url) ;
		location.href = url;
	}

	function editFun(id) {
		parent.$.modalDialog({
			title : '${internationalConfig.修改}',
			width : 680,
			height : 500,
			href : '${pageContext.request.contextPath}/voucher/template/' + id
					+ '/editing',
			buttons : [ {
				text : '${internationalConfig.确定}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			} ]
		});
	}

	function addFun() {
		parent.$.modalDialog({
			title : '${internationalConfig.代金券兑换码生成}',
			width : 680,
			height : 500,
			href : '${pageContext.request.contextPath}/coupon_generate_task/add.do',
			method : 'get',
			buttons : [ {
				text : '${internationalConfig.添加}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			} ]
		});
	}

	function show(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		}

		parent.$.modalDialog({
			title : '${internationalConfig.代金券兑换码任务查看}',
			width : 680,
			height : 500,
			href : '${pageContext.request.contextPath}/voucher/gen-task/' + id,
			method : 'get'
		});
	}

	function searchFun() {
		dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
	}
	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}

	//重启任务
	function restart(taskId) {

		parent.$.messager.confirm('${internationalConfig.询问}',
				'${internationalConfig.任务ID} :' + taskId + ',${internationalConfig.确认重启}？', function(b) {
					if (b) {
						parent.$.messager.progress({
							title : '${internationalConfig.提示}',
							text : '${internationalConfig.数据处理中}'
						});
						$.post(
								'${pageContext.request.contextPath}/voucher/gen-task/'
										+ taskId + '/restart',
								function(result) {
									if (result.success) {
										searchFun();
									} else {
										parent.$.messager.alert('${internationalConfig.页面错误}',
												result.msg, 'error');
									}
									parent.$.messager.progress('close');
								}, 'JSON');
					}
				});
	}
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false" style="height: 135px; overflow: hidden;">
			<form id="searchForm">
				<table class="table-more"
					style="display: none;">
					<tr>
						<td><label>${internationalConfig.发放方}: <select name="issuer" class="span2">
									<option value="0">${internationalConfig.全部}</option>
									<option value="1">${internationalConfig.会员运营}</option>
							</select>
						</label></td>
						<td>${internationalConfig.任务状态}： <select name="status" class="span2">
								<option value="-1">${internationalConfig.全部}</option>
								<option value="0">${internationalConfig.未开始}</option>
								<option value="1">${internationalConfig.未完成}</option>
								<option value="2">${internationalConfig.进行中}</option>
								<option value="3">${internationalConfig.已完成}</option>
						</select>
						</td>
</tr>
					<tr>
						<td>${internationalConfig.生成日期}: <input name="createDateBegin"
							class="easyui-datebox" value=""> <span
							style="padding: 5px">-</span> <input name="createDateEnd"
							class="easyui-datebox" value="">
						</td>

						<td>${internationalConfig.有效日期}: <input name="startTime" class="easyui-datebox"
							value=""> <span style="padding: 5px">-</span> <input
							name="endTime" class="easyui-datebox" value="">
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
		<a onclick="addFun();" href="javascript:void(0);"
			class="easyui-linkbutton" data-options="plain:true,iconCls:'bug_add'">${internationalConfig.代金券任务创建}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a><a
			href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_delete',plain:true"
			onclick="cleanFun();">${internationalConfig.清空条件}</a>
	</div>


</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.奖项管理}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '${pageContext.request.contextPath}/lotteryconf/award/allByPage.json',
							fit : true,
							fitColumns : true,
							border : false,
							pagination : true,
							idField : 'id',
							pageSize : 10,
							pageList : [ 10, 20, 50, 100, 200 ],
							checkOnSelect : false,
							selectOnCheck : false,
							nowrap : false,
							striped : true,
							rownumbers : true,
							singleSelect : true,
							frozenColumns : [ [ {
								field : 'id',
								title : '${internationalConfig.奖项ID}',
								width : 80,
								hidden : false
							} ] ],
							columns : [ [
									{
										field : 'awardName',
										title : '${internationalConfig.名称}',
										width : 80,
										sortable : false
									},
									{
										field : 'lottery',
										title : '${internationalConfig.抽奖活动}',
										width : 80,
										sortable : false,
										formatter : function(value, row, index) {
											return value.lotteryName;
										}
									},
									{
										field : 'awardGrade',
										title : '${internationalConfig.等级}',
										width : 60,
										sortable : false,
										formatter : function(value, row, index) {
											if (value == 0)
												return "${internationalConfig.特等奖}";
											else {
												return value + "<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.等奖}";
											}
										}
									},
									{
										field : 'limited',
										title : '${internationalConfig.数量限制}',
										width : 60,
										sortable : false,
										formatter : function(value, row, index) {
											if (value == 1)
												return "${internationalConfig.无限制}";
											if (value == 2)
												return "${internationalConfig.有限制}";
											return "${internationalConfig.未知}";
										}
									},

									{
										field : 'total',
										title : '${internationalConfig.总数}',
										width : 60,
										sortable : false

									},
									{
										field : 'createTime',
										title : '${internationalConfig.添加时间}',
										width : 60,
										sortable : false
									},
									{
										field : 'updateTime',
										title : '${internationalConfig.更新时间}',
										width : 60,
										sortable : false
									},
									{
										field : 'action',
										title : '${internationalConfig.操作}',
										width : 60,
										formatter : function(value, row, index) {
											var str = '&nbsp;&nbsp;&nbsp;';
											str += $
													.formatString(
															'<img onclick="editFun(\'{0}\');" src="{1}" title="${internationalConfig.编辑}"/>',
															index,
															'${pageContext.request.contextPath}/static/style/images/extjs_icons/bug/bug_edit.png');
											str += '&nbsp;&nbsp;&nbsp;';
											str += $
													.formatString(
															'<img onclick="deleteFun(\'{0}\');" src="{1}" title="${internationalConfig.删除}"/>',
															row.id,
															'${pageContext.request.contextPath}/static/style/images/extjs_icons/bug/bug_delete.png');
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

	function addFun() {
		parent.$
				.modalDialog({
					title : '${internationalConfig.添加奖项}',
					width : 330,
					height : 360,
					href : '${pageContext.request.contextPath}/lotteryconf/award/getaddpanel.do',
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

	function editFun(index) {

		var rows = dataGrid.datagrid('getRows');
		var row = rows[index];
		parent.$
				.modalDialog({
					title : '${internationalConfig.编辑}',
					width : 330,
					height : 360,
					href : '${pageContext.request.contextPath}/lotteryconf/award/geteditpanel.do?id='
							+ row.id,
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

	//冻结操作
	function deleteFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		}
		parent.$.messager
				.confirm(
						'${internationalConfig.询问}',
						'${internationalConfig.您是否要删除当前抽奖活动}？',
						function(flag) {
							if (flag) {
								parent.$.messager.progress({
									title : '${internationalConfig.提示}',
									text : '${internationalConfig.数据处理中}'
								});
								$
										.post(
												'${pageContext.request.contextPath}/lotteryconf/award/delete.do',
												{
													id : id
												},
												function(obj) {
													//alert(obj.code);
													//var result = $.parseJSON(obj);
													//alert(result);
													parent.$.messager
															.progress('close');
													if (obj.code == 0) {
														searchFun();
													} else {
														parent.$.messager
																.alert(
																		'${internationalConfig.页面错误}',
																		obj.msg,
																		'error');
													}
												}, 'JSON');
							}
						});
	}

	function cleanFun() {
		$('#searchForm input').val('');
		$('#searchForm select').val('0');
		dataGrid.datagrid('load', {});
	}

	function dynamicChangeAward() {
		var lotteryId = $("#lotteryId").val();
		$
				.ajax({
					url : "${pageContext.request.contextPath}/lotteryconf/awardconf/getAwardsByLotteryId.json",
					data : {
						'lotteryId' : lotteryId
					},
					success : function(result) {
						var awardIndex = null;
						var optionsHtml = "";
						for (awardIndex in result.rows) {
							var award = result.rows[awardIndex];
							var optionHtml = '<option value="'+award.id+'">'
									+ award.awardName + '</option>';
							optionsHtml += optionHtml;
						}
						$("#awardId").html(
								'<option value="0" selected="selected">${internationalConfig.全部}</option>'
										+ optionsHtml);
					},
					dataType : "json",
					cache : false
				});
	}
</script>
</head>

<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
			style="height: 70px; overflow: hidden;">
			<form id="searchForm">
				<table class="table table-hover table-condensed"
					style="display: none;">
					<tr></tr>
					<tr>
						<th></th>
						<td>${internationalConfig.活动名称}<select id="lotteryId" name="lotteryId"
							onchange="dynamicChangeAward()" style="width: 165px;height:24px">
								<option value="0" selected="selected">${internationalConfig.全部}</option>
								<c:forEach items="${lotteries}" var="var">
									<option value="${var.id}">${var.lotteryName}</option>
								</c:forEach>
						</select>
						</td>

						<th></th>
						<td>${internationalConfig.奖项名称} <select id="awardId" name="awardId"
							style="width: 165px;height:24px">
								<option value="0" selected="selected">${internationalConfig.全部}</option>
						</select></td>
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
			data-options="iconCls:'brick_add',plain:true" onclick="addFun();">${internationalConfig.添加}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="cleanFun();">${internationalConfig.清除条件}</a>

	</div>

</body>
</html>
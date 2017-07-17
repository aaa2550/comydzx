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
							url : '${pageContext.request.contextPath}/lotteryconf/prize/allByPage.json',
							fit : true,
							fitColumns : false,
							border : false,
							pagination : true,
							idField : 'id',
							pageSize : 15,
							pageList : [ 15, 30, 60, 120, 240 ],
							checkOnSelect : false,
							selectOnCheck : false,
							nowrap : false,
							striped : true,
							rownumbers : true,
							singleSelect : true,
							frozenColumns : [ [ {
								field : 'id',
								title : '${internationalConfig.奖项ID}',
								width : 100,
								hidden : false
							} ] ],
							columns : [ [ {
								field : 'award',
								title : '${internationalConfig.抽奖活动}',
								width : 100,
								sortable : false,
								formatter : function(value, row, index) {
									return value.lottery.lotteryName;
								}
							}, {
								field : 'award1',
								title : '${internationalConfig.奖项名称}',
								width : 100,
								sortable : false,
								formatter : function(value, row, index) {
									return row.award.awardName;
								}
							}, {
								field : 'award2',
								title : '${internationalConfig.奖项等级}',
								width : 100,
								sortable : false,
								formatter : function(value, row, index) {
									if (row.award.awardGrade == 0)
										return "${internationalConfig.特等奖}";
									else
										return row.award.awardGrade + "<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.等奖}";
								}
							}, {
								field : 'total',
								title : '${internationalConfig.总数}',
								width : 60,
								sortable : false

							}, {
								field : 'leftTotal',
								title : '${internationalConfig.剩余量}',
								width : 60,
								sortable : false

							}, {
								field : 'prizeDetail',
								title : '${internationalConfig.详细}',
								width : 220,
								sortable : false

							}, {
								field : 'createTime',
								title : '${internationalConfig.生成时间}',
								width : 160,
								sortable : false							}

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
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="cleanFun();">${internationalConfig.清除条件}</a>
	</div>

</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.中奖信息}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '${pageContext.request.contextPath}/lotteryconf/wininfo/allByPage.json',
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
								title : '${internationalConfig.奖品}id',
								width : 100,
								hidden : false
							} ] ],
							columns : [ [
									{
										field : 'userId',
										title : '${internationalConfig.用户ID}',
										width : 120,
										sortable : false,
										formatter : function(value, row, index) {
											return value;
										}
									},
									{
										field : 'lotteryName',
										title : '${internationalConfig.抽奖活动}',
										width : 100,
										sortable : false,
										formatter : function(value, row, index) {
											return row.prize.award.lottery.lotteryName;
										}
									},
									{
										field : 'awardName',
										title : '${internationalConfig.奖项名称}',
										width : 100,
										sortable : false,
										formatter : function(value, row, index) {
											return row.prize.award.awardName;
										}
									},
									{
										field : 'award2',
										title : '${internationalConfig.奖项等级}',
										width : 100,
										sortable : false,
										formatter : function(value, row, index) {
											if (row.prize.award.awardGrade == 0)
												return "${internationalConfig.特等奖}";
											else
												return row.prize.award.awardGrade
														+ "<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.等奖}";
										}
									}, {
										field : 'winTime',
										title : '${internationalConfig.中奖时间}',
										width : 160,
										sortable : false									} ] ],
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
		if (val == null) {
			return "";
		}
		var date = new Date(val);
		return date.format("yyyy-MM-dd");
	}

	function formatterdateTime(val) {
		if (val == null) {
			return "";
		}
		var date = new Date(val);
		return date.format("yyyy-MM-dd hh:mm:ss");
	}

	function formatterdate(val) {
		if (val == null) {
			return "";
		}
		var date = new Date(val);
		return date.format("yyyy-MM-dd");
	}

	function searchFun() {
		dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
	}

	function cleanFun() {
		$('#searchForm input').val('');
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
	function exportExcel() {
		var isValid = $("#searchForm").form('validate');
        if (!isValid) {
            return;
        }
		var url = '${pageContext.request.contextPath}/lotteryconf/wininfo/export.do?'+$('#searchForm').serialize();
		location.href= url ;
	}
</script>
</head>

<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
			style="height: 130px; overflow: hidden;">
			<form id="searchForm">
				<table class="table-more">
					<tr>
						<td>${internationalConfig.活动名称}：<select id="lotteryId" name="lotteryId"
								onchange="dynamicChangeAward()" style="width: 165px;height:24px">
									<option value="0" selected="selected">${internationalConfig.全部}</option>
									<c:forEach items="${lotteries}" var="var">
										<option value="${var.id}">${var.lotteryName}</option>
									</c:forEach>
							</select>
						</td>
						<td>${internationalConfig.奖项名称}： <select id="awardId" name="awardId"
							style="width: 165px;height:24px">
								<option value="0" selected="selected">${internationalConfig.全部}</option>
						</select></td>
	                    <td>${internationalConfig.用户ID}：<input id="userId" name="userId"
							class="span2"></td>
					</tr>
					<tr>
	                    <td>${internationalConfig.起始时间}：<input id="startTime" name="startTime"
							class="easyui-datebox" class="easyui-validatebox" data-options="width:165"></input>
						</td>
						<td>${internationalConfig.截止时间}：<input id="endTime" name="endTime"
							class="easyui-datebox" class="easyui-validatebox" data-options="width:165"></input>
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
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="cleanFun();">${internationalConfig.清除条件}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="exportExcel();">${internationalConfig.导出excel}</a>

	</div>

</body>
</html>
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
							url : '${pageContext.request.contextPath}/lotteryconf/prize/censusPrize.json',
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

							}
							/**
							, {
								field : 'createTime',
								title : '生成时间',
								width : 160,
								sortable : false,
								formatter : formatterdateTime
							}
							*/

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
</script>
</head>

<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
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
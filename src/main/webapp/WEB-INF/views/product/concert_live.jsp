<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.直播内容管理}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>

<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid').datagrid({
			url : '/concert_live/data_grid.json',
			fit : true,
			fitColumns : true,
			border : false,
			pagination : true,
			idField : 'id',
			pageSize : 20,
			pageList : [ 10, 20, 30, 40, 50 ],
			sortName : 'm.movie_id',
			sortOrder : 'asc',
			checkOnSelect : false,
			selectOnCheck : false,
			singleSelect: true,
			nowrap: false,
	        striped: true,
	        rownumbers: true,
	        singleSelect: true,
			frozenColumns: [
            [
                {
                    field: 'id',
                    title: '${internationalConfig.编号}',
                    width: 50,
                    hidden: true
                }
            ]
        ],
			columns : [ [ 
			{
				field : 'movieId',
				title : '${internationalConfig.直播ID}',
				width : 60,
				sortable : false
			},
			{
				field : 'movieName',
				title : '${internationalConfig.直播名称}',
				width : 80,
				sortable : true
			},
			{
				field : 'liveType',
				title : '${internationalConfig.直播类型}',
				width : 50,
				formatter : function(value) {
					var str = '';
					if("1" == value) {
						str = "${internationalConfig.演唱会直播}";
					}else if("2" == value) {
						str = "${internationalConfig.体育直播}";
					}else{
						str = "${internationalConfig.未知}";
					}
					return str;
				}
			}, 
			{
				field : 'liveTime',
				title : '${internationalConfig.直播时间}',
				width : 60
			},
			{
				field : 'payBeginTime',
				title : '${internationalConfig.直播试看时间}',
				width : 60
			},
			{
				field : 'activityStartTime',
				title : '${internationalConfig.活动开始时间}',
				width : 60
			},
			{
				field : 'activityEndTime',
				title : '${internationalConfig.活动结束时间}',
				width : 60
			},
			{
				field : 'featureListDesc',
				title : '${internationalConfig.附加参与方式}',
				width : 100,
				formatter : function(featureListDesc) {
					return $
							.map(
									featureListDesc,
									function(feature) {
										return feature;
									}).join(", ");

				}
			}
			,{
				field : 'status',
				title : '${internationalConfig.发布状态}',
				width : 50,
				formatter : function(value) {
					var str = '';
					if("0" == value) {
						str = "${internationalConfig.未发布}";
					}else if("1" == value) {
						str = "${internationalConfig.已发布}";
					}else{
						str = "${internationalConfig.未知}";					
					}
					return str;
				}
			},
            {
                field : 'isCharge',
                title : '${internationalConfig.是否收费}',
                width : 50,
                formatter : function(value){
                    if(value == 0){
                        return "${internationalConfig.免费}";
                    }
                    else if(value == 1){
                        return "${internationalConfig.付费}";
                    }else{
                        return "${internationalConfig.未知}";
                    }
                }
            },
            {
				field : 'chargeType',
				title : '${internationalConfig.付费类型}',
				width : 50,
				formatter : function(value) {
					var str = '';
					if("0" == value) {
						str = "${internationalConfig.点播}";
					}else if("4" == value) {
						str = "${internationalConfig.点播且演唱会直播包月}";
					}else if("5" == value) {
						str = "${internationalConfig.点播且NBA直播包月}";
					}
					return str;
				}
			}, 
			{
				field : 'extendId',
				title : '${internationalConfig.场次ID}',
				width : 200
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
	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'" >
			<form id="searchForm">
				<table class="table-td-four">
					<tr>
					    
						<td>${internationalConfig.直播名称}：<input name="movieName" class="span2" /></td>     
						<td>  ${internationalConfig.直播ID}：<input name="movieId" class="span2" /></td>
						<td>${internationalConfig.场次ID}：<input name="extendId" class="span2" /></td>
						<td>${internationalConfig.发布状态}：
						<select name="status" class="span2">
						        <option value="-1" selected>${internationalConfig.全部}</option>
								<option value="0" >${internationalConfig.未发布}</option>
								<option value="1">${internationalConfig.已发布}</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>${internationalConfig.是否收费}：
					    <select name="isCharge" class="span2">
						        <option value="-1" selected>${internationalConfig.全部}</option>
								<option value="0" >${internationalConfig.免费}</option>
								<option value="1">${internationalConfig.付费}</option>
							</select>
					    </td>
					    <td>${internationalConfig.付费类型}：
							<select name="chargeType" class="span2">
							    <option value="-1" selected>${internationalConfig.全部}</option>
								<option value="0" >${internationalConfig.点播}</option>
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
		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">${internationalConfig.清空条件}</a>
	</div>

	<div id="menu" class="easyui-menu" style="width: 120px; display: none;">
		<div onclick="editFun();" data-options="iconCls:'pencil'">${internationalConfig.编辑}</div>
	</div>
</body>
</html>
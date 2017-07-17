<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.影视剧价格管理}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>

<script type="text/javascript">
<m:auth uri="/movie_channel/movie_channel_edit.json">
	$.canEdit = true;
</m:auth>
<m:auth uri="/movie_channel/delete.json">
	$.canDelete = true;
</m:auth>
</script>

<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid').datagrid({
			url : '/movie_channel/data_grid.json',
			fit : true,
			fitColumns : true,
			border : false,
			pagination : true,
			idField : 'id',
			pageSize : 20,
			pageList : [ 10, 20, 30, 40, 50 ],
			sortName : 'updateTime',
			sortOrder : 'desc',
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
				field : 'channelId',
				title : '${internationalConfig.频道ID}',
				width : 80,
				sortable : true
			},
			{
				field : 'channelName',
				title : '${internationalConfig.频道名称}',
				width : 100,
				sortable : true
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
					}else if("1" == value) {
						str = "${internationalConfig.点播且包月}";
					}else if("2" == value) {
						str = "${internationalConfig.包月}";
					}else if("3" == value) {
						str = "${internationalConfig.免费但TV包月收费}";
					} else if("4" == value) {
						str="${internationalConfig.包年}";
					} else if("5" == value) {
						str = "${internationalConfig.码流付费}";
					}
					return str;
				}
			},  {
				field : 'price',
				title : '${internationalConfig.价格}',
				width : 50
			},
			{
				field : 'createTime',
				title : '${internationalConfig.创建时间}',
				width : 100,
				sortable : true
			},
			{
				field : 'updateTime',
				title : '${internationalConfig.更新时间}',
				width : 100,
				sortable : true
			},  {
				field : 'action',
				title : '${internationalConfig.操作}',
				width : 80,
				formatter : function(value, row, index) {
					var str = '';
					if ($.canEdit) {
						str += $.formatString('<img onclick="editFun(\'{0}\');" src="{1}" title="${internationalConfig.编辑}"/>', row.id, '${pageContext.request.contextPath}/static/style/images/extjs_icons/bug/bug_edit.png');
					}
					
					if($.canDelete) {
						str += '&nbsp;&nbsp;';
						str += $.formatString('<img onclick="deleteFun(\'{0}\');" src="{1}" title="${internationalConfig.删除}"/>', row.id, '${pageContext.request.contextPath}/static/style/images/extjs_icons/bug/bug_delete.png');
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
	});
	
	function addFun() {
		parent.$.modalDialog({
			title : '${internationalConfig.添加频道}',
			width : 600,
			height : 260,
			href : '/movie_channel/movie_channel_add.json',
			onClose:function(){
				this.parentNode.removeChild(this);
			},	
			buttons : [ {
				text : '${internationalConfig.增加}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			}, {
				text : "${internationalConfig.取消}",
				handler : function() {
					parent.$.modalDialog.handler.dialog('close');
				}
			} ]
		});
	}

	//编辑信息
	function editFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].movieId;
		}
		parent.$.modalDialog({
			title : '${internationalConfig.编辑频道}',
			width : 600,
			height : 260,
			resizable : true,
			href : '/movie_channel/movie_channel_edit.json?id=' + id,
			buttons : [ {
				text : '${internationalConfig.保存}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			}, {
				text : "${internationalConfig.取消}",
				handler : function() {
					parent.$.modalDialog.handler.dialog('close');
				}
			} ]
		});
	}
	
	function deleteFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		}
		parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.您确定要删除当前配置吗}',
		function(b) {
			if (b) {
				parent.$.messager.progress({
					title : '${internationalConfig.提示}',
					text : '${internationalConfig.数据处理中}....'
				});
				$.post(
					'/movie_channel/delete.json',
					{
						cid : id
					},
					function(result) {
						if (result.code == 0) {
							parent.$.messager
									.alert(
											'${internationalConfig.提示}',
											'${internationalConfig.删除成功}',
											'info');
							dataGrid
									.datagrid('reload');
						} else {
							parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.删除失败}', 'error');
						}
						parent.$.messager
								.progress('close');
					}, 'JSON');
			}
		});
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
		<div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'">
			<form id="searchForm">
				<table class="table-more">
					<tr>
						<td>${internationalConfig.频道名称}：<input name="channelName" class="span2" /></td>
						<td>${internationalConfig.频道ID}：<input name="channelId" class="span2" /></td>
						<td>${internationalConfig.付费类型}：
							<select name="chargeType" class="span2"> 
							    <option value="-1" selected>${internationalConfig.全部}</option>
								<!-- <option value="0" >点播</option> -->
								<option value="1">${internationalConfig.点播且包月}</option>
								<option value="2">${internationalConfig.包月}</option>
								<!-- <option value="3">免费但TV包月收费</option> -->
								<!-- <option value="4">码流付费</option> -->
							</select>
						</td>
						<td>${internationalConfig.是否收费}：
					    <select name="isCharge" class="span2">
						        <option value="-1" selected>${internationalConfig.全部}</option>
								<option value="0" >${internationalConfig.免费}</option>
								<option value="1">${internationalConfig.付费}</option>
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
		<m:auth uri="/movie_channel/add.json">
			<a onclick="addFun();" href="javascript:void(0);"
				class="easyui-linkbutton"
				data-options="plain:true,iconCls:'pencil_add'">${internationalConfig.增加}</a>
		</m:auth>
		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">${internationalConfig.清空条件}</a>
	</div>
</body>
</html>
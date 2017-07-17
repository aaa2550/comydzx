<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.影视剧价格管理}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript"  src="/js/dict.js"></script>

<script type="text/javascript">
<m:auth uri="/movie/movie_edit.json">
	$.canEdit = true;
</m:auth>
<m:auth uri="/movie/movie_video_edit.json">
	$.canMovieEdit = true;
</m:auth>
</script>

<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid').datagrid({
			url : '${pageContext.request.contextPath}/movie/data_grid.json',
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
				field : 'movieId',
				title : '${internationalConfig.专辑ID}',
				width : 80,
				sortable : true
			},
			{
				field : 'movieName',
				title : '${internationalConfig.专辑名称}',
				width : 100,
				sortable : true
			},
			{
				field : 'contentType',
				title : '${internationalConfig.频道}',
				width : 50,
				formatter : function(value) {
					 return Dict.getName("channel",value);
				}
			}, {
				field : 'status',
				title : '${internationalConfig.发布状态}',
				width : 150,
				formatter : function(value) {
					var str = '';
					if("0" == value) {
						str = "${internationalConfig.未发布}";
					}else if("1" == value) {
						str = "${internationalConfig.已发布}";
					}else if("2" == value) {
						str = "${internationalConfig.定时发布}";
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
                        return "${internationalConfig.免费}"
                    }
                    else if(value == 1){
                        return "${internationalConfig.付费}"
                    }else{
                        return "${internationalConfig.未知}"
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
					}
					else if("3" == value) {
						str = "${internationalConfig.免费但TV包月收费}";
					}else if("4" == value) {
						str = "${internationalConfig.包年}";
					}
					return str;
				}
			},  {
				field : 'chargeName',
				title : '${internationalConfig.价格}',
				width : 50
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
						str += $.formatString('<img onclick="editFun(\'{0}\');" src="{1}" title="${internationalConfig.编辑}"/>', row.movieId, '${pageContext.request.contextPath}/static/style/images/extjs_icons/bug/bug_edit.png');
					}
					
					//付费电视剧
					if($.canMovieEdit && row.contentType == 2) {
						str += $.formatString('&nbsp;&nbsp;&nbsp;&nbsp;<img onclick="editVideoFun(\'{0}\');" src="{1}" title="${internationalConfig.编辑视频免费规则}"/>', row.movieId, '${pageContext.request.contextPath}/static/style/images/extjs_icons/bug/bug_go.png');
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

	function batchDeleteFun() {
		var rows = dataGrid.datagrid('getChecked');
		var ids = [];
		if (rows.length > 0) {
			parent.$.messager.confirm('${internationalConfig.确认}', '${internationalConfig.您是否要删除当前项目}', function(r) {
				if (r) {
					parent.$.messager.progress({
						title : '${internationalConfig.提示}',
						text : '${internationalConfig.数据处理中}....'
					});
					var currentUserId = '${sessionInfo.uid}';/*当前登录用户的ID*/
					var flag = false;
					for ( var i = 0; i < rows.length; i++) {
						if (currentUserId != rows[i].id) {
							ids.push(rows[i].id);
						} else {
							flag = true;
						}
					}
					$.getJSON('${pageContext.request.contextPath}/movieController/batchDelete', {
						ids : ids.join(',')
					}, function(result) {
						if (result.success) {
							dataGrid.datagrid('load');
							dataGrid.datagrid('uncheckAll').datagrid('unselectAll').datagrid('clearSelections');
						}
						if (flag) {
							parent.$.messager.show({
								title : '${internationalConfig.提示}',
								msg : '${internationalConfig.不可以删除自己}！'
							});
						} else {
							parent.$.messager.alert('${internationalConfig.提示}', result.msg, 'info');
						}
						parent.$.messager.progress('close');
					});
				}
			});
		} else {
			parent.$.messager.show({
				title : '${internationalConfig.提示}',
				msg : '${internationalConfig.请勾选要删除的记录}！'
			});
		}
	}
	//编辑信息
	function editFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].movieId;
		}
		parent.$.modalDialog({
			title : '${internationalConfig.编辑影片价格}',
			width : 800,
			height : 550,
			resizable : true,
			href : '${pageContext.request.contextPath}/movie/movie_edit.json?movieId=' + id,
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
	
	//编辑信息
	function editVideoFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].movieId;
		}
		parent.$.modalDialog({
			title : '${internationalConfig.编辑视频免费规则}',
			width : 650,
			height : 450,
			resizable : true,
			href : '${pageContext.request.contextPath}/movie/movie_video_edit.json?movieId=' + id,
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

	function batchGrantFun() {
		var rows = dataGrid.datagrid('getChecked');
		var ids = [];
		if (rows.length > 0) {
			for ( var i = 0; i < rows.length; i++) {
				ids.push(rows[i].id);
			}
			parent.$.modalDialog({
				title : '${internationalConfig.用户授权}',
				width : 500,
				height : 300,
				href : '${pageContext.request.contextPath}/movieController/grantPage?ids=' + ids.join(','),
				buttons : [ {
					text : '${internationalConfig.授权}',
					handler : function() {
						parent.$.modalDialog.openner_dataGrid = dataGrid;//因为授权成功之后，需要刷新这个dataGrid，所以先预定义好
						var f = parent.$.modalDialog.handler.find('#form');
						f.submit();
					}
				}, {
					text : "${internationalConfig.关闭}",
					handler : function() {
						parent.$.modalDialog.handler.dialog('close');
					}
				} ]
			});
		} else {
			parent.$.messager.show({
				title : '${internationalConfig.提示}',
				msg : '${internationalConfig.请勾选要授权的记录}！'
			});
		}
	}

	function grantFun(id) {
		parent.$.modalDialog({
			title : '${internationalConfig.用户授权}',
			width : 500,
			height : 300,
			href : '${pageContext.request.contextPath}/movieController/grantPage?ids=' + id,
			buttons : [ {
				text : '${internationalConfig.授权}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为授权成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			} ]
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
				<table class="table-td-more">
					<tr>
					    
						<td>${internationalConfig.专辑名称}：<input name="movieName" class="span2" /></td>
						<td>${internationalConfig.专辑ID}：<input name="movieId" class="span2" /></td>
						<td>${internationalConfig.频道}：
							<select name="contentType" class="span2">
							    <option value="-1" selected>${internationalConfig.全部}</option>
								<c:forEach items="${dict.channel}" var="channel">
									<option value="${channel.key}" >${channel.value}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<td>${internationalConfig.专辑状态}：
						<select name="status" class="span2">
						        <option value="-1" selected>${internationalConfig.全部}</option>
								<option value="0" >${internationalConfig.未发布}</option>
								<option value="1">${internationalConfig.已发布}</option>
								<option value="2" >${internationalConfig.定时发布}</option>
							</select>
						</td>
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
								<option value="1">${internationalConfig.点播且包月}</option>
								<option value="2">${internationalConfig.包月}</option>
								<option value="3">${internationalConfig.免费但TV包月收费}</option>
								<option value="4">${internationalConfig.包年}</option>
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
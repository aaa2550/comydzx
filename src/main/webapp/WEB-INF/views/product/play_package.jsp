<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.直播套餐管理}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
<m:auth uri="/play_package/play_package_edit.do">
	$.canEdit = true;
</m:auth>
<m:auth uri="/play_package/play_package_view.do">
	$.canView = true;
</m:auth>
<m:auth uri="/play_package/delete.json">
	$.canDelete = true;
</m:auth>
</script>
<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = renderDataGrid('/play_package/package_list.json');
	});

	function renderDataGrid(url) {
		return $('#dataGrid')
				.datagrid(
						{
							url : url,
							fit : true,
							fitColumns : true,
							border : false,
							pagination : true,
							idField : 'id',
							pageSize : 10,
							pageList : [ 10, 20, 30, 40, 50 ],
							sortName : 'id',
							sortOrder : 'desc',
							checkOnSelect : false,
							selectOnCheck : false,
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
										field : 'playName',
										title : '${internationalConfig.直播名称}',
										width : 150,
										sortable : true
									},
									{
										field : 'extendId',
										title : '${internationalConfig.场次ID}',
										width : 150,
										sortable : false
									},
									{
										field : 'matchname',
										title : '${internationalConfig.频道}',
										width : 120,
										sortable : true
									},
									{
										field : 'itemname',
										title : '${internationalConfig.赛事}',
										width : 120,
										sortable : true
									
									},
									{
										field : 'sessionname',
										title : '${internationalConfig.赛季}',
										width : 150,
										sortable : true
									
									},
									{
										field : 'name',
										title : '${internationalConfig.套餐名称}',
										width : 150,
										sortable : true

									},
									{
										field : 'payType',
										title : '${internationalConfig.付费类型}',
										width : 120,
										formatter: function (data) {
			                                if (data == 1) {
			                                    return "${internationalConfig.包年及以上免费}";
			                                } else if (data == 2) {
			                                    return "${internationalConfig.包年及以上免费且可单点}";
			                                } else if(data == 3) {
			                                	return "${internationalConfig.会员免费}";
			                                } else if(data == 4) {
			                                	return "${internationalConfig.会员免费且可单点}";
			                                } else if(data == 5) {
			                                	return "${internationalConfig.单点}";
			                                }else if(data==6){
			                                	return "${internationalConfig.全屏包年及以上免费且可单点}" ;
			                                }
			                            }
									},
									{
										field : 'vip_price',
										title : '${internationalConfig.会员价格}',
										width : 120
									},
									{
										field : 'regular_price',
										title : '${internationalConfig.非会员价格}',
										width : 120
									},
									{
										field : 'dividedProportion',
										title : '${internationalConfig.分成比例}',
										width : 80
									},
									{
										field : 'status',
										title : '${internationalConfig.套餐状态}',
										width : 120,
										formatter: function (data) {
			                                if (data == 0) {
			                                    return "${internationalConfig.上线}"
			                                } else if (data == 1) {
			                                    return "${internationalConfig.下线}"
			                                } 
			                            }
									},
									{
										field : 'action',
										title : '${internationalConfig.操作}',
										width : 100,
										formatter : function(value, row, index) {
											var str = '';
											if ($.canEdit) {
												str += $
														.formatString(
																'<img onclick="editFun(\'{0}\');" src="{1}" title="${internationalConfig.编辑}"/>',
																row.id,
																'${pageContext.request.contextPath}/static/style/images/extjs_icons/bug/bug_edit.png');
											}
											str += '&nbsp;';
											 if ($.canDelete) {
											     str += $.formatString('<img onclick="deleteFun(\'{0}\');" src="{1}" title="${internationalConfig.删除}"/>', row.id, '${pageContext.request.contextPath}/static/style/images/extjs_icons/bug/bug_delete.png');
											 }
											str += '&nbsp;';
											if ($.canView) {
												str += $
														.formatString(
																'<img onclick="viewFun(\'{0}\');" src="{1}" title="${internationalConfig.查看}"/>',
																row.id,
																'${pageContext.request.contextPath}/static/style/images/extjs_icons/bug/bug_link.png');
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

	function editFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		}

		parent.$.modalDialog({
			title : '${internationalConfig.编辑套餐}',
			width : 720,
			height : 580,
			href : '/play_package/play_package_edit.do?id='
					+ id,
			buttons : [ {
				text : '${internationalConfig.保存}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			} , {
				text : "${internationalConfig.取消}",
				handler : function() {
					parent.$.modalDialog.handler.dialog('close');
				}
			} ]
		});
	}

	function viewFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		}
		parent.$.modalDialog({
			title : '${internationalConfig.查看套餐}',
			width : 780,
			height : 500,
			href : '/play_package/play_package_view.do?id='
					+ id,
			buttons : [ {
				text : "${internationalConfig.关闭}",
				handler : function() {
					parent.$.modalDialog.handler.dialog('close');
				}
			} ]
		});
	}

	function addFun() {
		parent.$.modalDialog({
			title : '${internationalConfig.添加套餐}',
			width : 700,
			height : 550,
			href : '/play_package/play_package_add.do',
			buttons : [ {
				text : '${internationalConfig.增加}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			} , {
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
		parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.您是否要删除当前套餐}',
		function(b) {
			if (b) {
				parent.$.messager.progress({
					title : '${internationalConfig.提示}',
					text : '${internationalConfig.数据处理中}....'
				});
				$.post(
					'/play_package/delete.json',
					{
						playPackageId : id
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
		parent.$.messager.progress({
			title : '${internationalConfig.提示}',
			text : '${internationalConfig.数据处理中}....'
		});
		renderDataGrid('/play_package/package_list.json?'
				+ $('#searchForm').serialize());
		parent.$.messager.progress('close');
	}
	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}
	
	
	//终端设备联动
    $(function(){
    	$("#matchid").change(function(){
    		var matchid = $("#matchid").val();
    		$
    				.ajax({
    					url : "/play_package/get_match_info.json",
    					data : {
    						'pid' : matchid
    					},
    					success : function(result) {
    						var directIndex = null;
    						var optionsHtml = "";
    						$("#itemid").empty();
    						for (directIndex in result) {
    							var directModel = result[directIndex];
    							var optionHtml = '<option value="'+directModel.id+'">'
    									+ directModel.description + '</option>';
    							optionsHtml += optionHtml;
    						}
    						var optionhtml = '<option value="-1" selected="selected">${internationalConfig.全部}</option>';
                            optionsHtml += optionhtml;
    						$("#itemid").html(optionsHtml);
    						
    						var optionhtml1 = '<option value="-1" selected="selected">${internationalConfig.全部}</option>';
    						$("#sessionid").html(optionhtml1);
    						
    					},
    					dataType : "json",
    					cache : false
    				});
    			
    		});
          }
    	);
	
  //终端设备联动
    $(function(){
    	$("#itemid").change(function(){
    		var matchid = $("#itemid").val();
    		$
    				.ajax({
    					url : "/play_package/get_match_info.json",
    					data : {
    						'pid' : matchid
    					},
    					success : function(result) {
    						var directIndex = null;
    						var optionsHtml = "";
    						$("#sessionid").empty();
    						for (directIndex in result) {
    							var directModel = result[directIndex];
    							var optionHtml = '<option value="'+directModel.id+'">'
    									+ directModel.description + '</option>';
    							optionsHtml += optionHtml;
    						}
    						var optionhtml = '<option value="-1" selected="selected">${internationalConfig.全部}</option>';
                            optionsHtml += optionhtml;
    						$("#sessionid").html(optionsHtml);
    					},
    					dataType : "json",
    					cache : false
    				});
    			
    		});
          }
    	);
	
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'">
			<form id="searchForm">
				<table class="table-td-four">
					<tr>
						<td>${internationalConfig.频道}：<select class="span2" name="matchid" id="matchid">
						<option value="-1"> ${internationalConfig.全部}</option>
						        <c:forEach items="${directList}" var="var">
								    <option value="${var.id}">${var.description}</option>
								</c:forEach>
						</select></td>
						<td>${internationalConfig.赛事}：<select class="span2" name="itemid" id="itemid">
								<option value="-1">  ${internationalConfig.全部}</option>
						</select></td>
						<td>${internationalConfig.赛季}：<select class="span2" name="sessionid" id="sessionid">
								<option value="-1">  ${internationalConfig.全部}</option>
						</select></td>
						<td>${internationalConfig.套餐状态}：<select class="span2" name="status">
						        <option value="-1"> ${internationalConfig.全部}</option>
								<option value="0">${internationalConfig.上线}</option>
								<option value="1">${internationalConfig.下线}</option>
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

			<a onclick="addFun();" href="javascript:void(0);"
				class="easyui-linkbutton"
				data-options="plain:true,iconCls:'pencil_add'">${internationalConfig.增加}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
		<%--    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true"
           onclick="searchFun();">过滤条件</a><a href="javascript:void(0);" class="easyui-linkbutton"
                                             data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">清空条件</a>--%>
	</div>

	<div id="menu" class="easyui-menu" style="width: 120px; display: none;">
		<div onclick="addFun();" data-options="iconCls:'pencil_add'">${internationalConfig.增加}</div>
		<div onclick="deleteFun();" data-options="iconCls:'pencil_delete'">${internationalConfig.删除}</div>
		<div onclick="editFun();" data-options="iconCls:'pencil'">${internationalConfig.编辑}</div>
	</div>
</body>
</html>
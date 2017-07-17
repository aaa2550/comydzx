<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.套餐时长管理}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
$.canEdit = true;
$.canDelete = true;
$.canView = true;
	var dataGrid;
	
	$(function() {
		   
		dataGrid = renderDataGrid('/v2/product/vipDuration/dataGrid');
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
							pageSize : 50,
							pageList : [ 50, 100 ],
							sortName : 'id',
							sortOrder : 'asc',
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
							columns : [[{
											field : 'id',
											title : '${internationalConfig.时长ID}',
											width : 50,
											sortable : true,
											hidden : false
										},
							         	{
											field : 'durationName',
											title : '${internationalConfig.套餐时长名称}',
											width : 100,
											sortable : false
										},
										<%--{
											field : 'durationType',
											title : '${internationalConfig.时长类型}',
											width : 80,
											sortable : false,
											formatter : function(value) {
												  if (value == 1) {
							                        return "${internationalConfig.按自定义}";
							                      }
							                      if (value == 2) {
							                        return "${internationalConfig.按自然}";
							                      }
											}
										},--%>
										{
											field : 'action',
											title : '${internationalConfig.操作}',
											width : 140,
											formatter : function(value, row, index) {
												var str = '';

												if ($.canEdit) {
													str += $
															.formatString(
																	'<img onclick="editFun(\'{0}\');" src="{1}" title="${internationalConfig.编辑}"/>',
																	row.id,
																	'/static/style/images/extjs_icons/bug/bug_edit.png');
												}

												str += '&nbsp;';
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

	function deleteFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		}
		parent.$.messager
				.confirm(
						'${internationalConfig.询问}',
						'${internationalConfig.您是否要删除当前套餐}',
						function(b) {
							if (b) {
								parent.$.messager.progress({
									title : '${internationalConfig.提示}',
									text : '${internationalConfig.数据处理中}....'
								});
								$
										.post(
												'/v2/product/vipPackage/delete',
												{
													id : id
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
													}
													parent.$.messager
															.progress('close');
												}, 'JSON');
							}
						});
	}

	function editFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		}

		parent.$.modalDialog({
			title : '${internationalConfig.编辑时长套餐}',
			width : 420,
			height : 200,
			href : '/v2/product/vipDuration/packageDurationInfo?id='
					+ id,
			onClose:function(){
				this.parentNode.removeChild(this);
			},
			buttons : [ {
				text : '${internationalConfig.保存}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#form');
					submitFun(f);
				}
			}, {
				text : "${internationalConfig.取消}",
				handler : function() {
					parent.$.modalDialog.handler.dialog('close');
				}
			} ]
		});
	}


	function addFun(id) {
		parent.$.modalDialog({
			title : '${internationalConfig.添加时长套餐}',
			width : 380,
			height : 200,
			href : '/v2/product/vipDuration/packageDurationInfo?id=',
			onClose:function(){
				this.parentNode.removeChild(this);
			},
			buttons : [ {
				text : '${internationalConfig.增加}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#form');
					//f.submit();
					submitFun(f);

				}
			}, {
				text : "${internationalConfig.取消}",
				handler : function() {
					parent.$.modalDialog.handler.dialog('close');
				}
			} ]
		});
	}
	function submitFun(f){
	    if(f.form("validate")){
	      parent.$.messager.progress({
	        title : '${internationalConfig.提示}',
	        text : '${internationalConfig.数据处理中}....'
	      });

	      $.ajax({
	        url:'/v2/product/vipDuration/save',
	        type:"post",
	        data:f.serialize(),
	        dataType:"json",
	        success:function(result){
	          parent.$.messager.progress('close');
	          /* result = $.parseJSON(result); */
	          if (result.code == 0) {
	                    parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.添加成功}', 'success');
	            parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
	            parent.$.modalDialog.handler.dialog('close');
	          } else {
	            parent.$.messager.alert('${internationalConfig.错误}','${internationalConfig.该套餐已存在}', 'error');
	          }
	        },
	        error:function(){

	        }


	      })
	    }
	  }


	function searchFun() {
		parent.$.messager.progress({
			title : '${internationalConfig.提示}',
			text : '${internationalConfig.数据处理中}....'
		});

		renderDataGrid('/v2/product/vipDuration/dataGrid?'
				+ $('#searchForm').serialize());
		parent.$.messager.progress('close');
	}
	function cleanFun() {
		$('#searchForm input').val('');
		renderDataGrid('/v2/product/vipDuration/dataGrid');
	}
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.套餐时长管理}',border:false,height:'auto'">
			<form id="searchForm">
				<table  class="table-more">
					<tr>
						<td>${internationalConfig.套餐时长名称}：<input name="durationName" class="span2" /></td>
						<td>${internationalConfig.时长类型}：<select class="span2" name="durationType">
								<option value="0" selected="selected">${internationalConfig.全部状态}</option>
                                <option value="1">${internationalConfig.按自定义}</option>
                                <option value="2">${internationalConfig.按自然}</option>
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
		<%-- <m:auth uri="/package/add.json"> --%>
			<a onclick="addFun();" href="javascript:void(0);"
				class="easyui-linkbutton"
				data-options="plain:true,iconCls:'pencil_add'">${internationalConfig.增加}</a>
		<%-- </m:auth> --%>
		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">${internationalConfig.清空条件}</a>
			
	</div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<title>内容包管理</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
	var dataGrid;
	(function($) {
		$.fn.serializeJson = function() {

			var serializeObj = {};
			var array = this.serializeArray();
			$(array).each(function() { // 遍历数组的每个元素 {name : xx , value : xxx} 
				if (serializeObj[this.name]) { // 判断对象中是否已经存在 name，如果存在name 
					serializeObj[this.name] += "," + this.value;
				} else {
					serializeObj[this.name] = this.value; // 如果元素name不存在，添加一个属性 name:value 
				}
			});
			return serializeObj;
		}
	})(jQuery)

	$(function() {
		dataGrid = renderDataGrid('/v2/product/aggPackage/dataGrid');
	});

	function renderDataGrid(url, data, method) {
		return $('#dataGrid')
				.datagrid(
						{
							url : url,
							fit : true,
							queryParams : data || "",
							fitColumns : true,
							border : false,
							method : method || 'post',
							pagination : true,
							idField : 'id',
							pageSize : 50,
							pageList : [ 50, 100 ],
							sortName : 'pk_agg_package',
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
										field : 'pk_agg_package',
										title : '${internationalConfig.内容包ID}',
										width : 100,
										sortable : true,
										formatter : function(val, row) {
											return row.id;
										}
									},
									{
										field : 'aggPackageName',
										title : '${internationalConfig.内容包名称}',
										width : 100,
										sortable : false
									},
									{
										field : 'state',
										title : '${internationalConfig.状态}',
										width : 100,
										sortable : false,
										formatter : function(val) {
											var str = '';
					                        if ("1" == val) {
					                            str = "${internationalConfig.正常}";
					                        } else if ("2" == val) {
					                            str = "${internationalConfig.停止}";
					                        } else {
					                            str = "${internationalConfig.未知}";
					                        }
					                        return str;
										}
									},
									/*{
										field : 'isAllVideo',
										title : '是否全片库',
										width : 100,
										sortable : false,
										formatter : function(val) {
											var str = '';
					                        if ("1" == val) {
					                            str = "是";
					                        } else if ("2" == val) {
					                            str = "否";
					                        } else {
					                            str = "${internationalConfig.未知}";
					                        }
					                        return str;
										}
									},*/
									{
										field : 'desc',
										title : '${internationalConfig.描述信息}',
										width : 100,
										sortable : false
									},
									{
										field : 'action',
										title : '${internationalConfig.操作}',
										width : 140,
										formatter : function(val, row, index) {
											var str = '';
											if (row.state == 1) {
											    str = $.formatString('<img onclick="displayFun(\'{0}\');" src="{1}" title="${internationalConfig.查看}"/>',
														row.id, '/static/style/images/extjs_icons/driver/drive_disk.png');
					                            str += '&nbsp;';
					                            str += $.formatString('<img onclick="offShelf(\'{0}\');" src="{1}" title="${internationalConfig.下架}"/>',
					                            		row.id, '/static/style/images/extjs_icons/lock/lock.png');
					                            str += '&nbsp;';
					                        	str += $.formatString('<img onclick="editFun(\'{0}\');" src="{1}" title="${internationalConfig.编辑}"/>',
					                                	row.id, '/static/style/images/extjs_icons/bug/bug_edit.png');
					                        } else {
					                        	 str += $.formatString('<img onclick="onShelf(\'{0}\');" src="{1}" title="${internationalConfig.上架}"/>',
					                            		row.id, '/static/style/images/extjs_icons/lock/lock_break.png');
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

	function displayFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		}

		parent.$.modalDialog({
			title : '${internationalConfig.展示内容包信息}',
			width : 700,
			height : 500,
			href : '/v2/product/aggPackage/display?id=' + id,
			onClose : function() {
				this.parentNode.removeChild(this);
			},
			buttons : [ {
				text : "${internationalConfig.关闭}",
				handler : function() {
					parent.$.modalDialog.handler.dialog('close');
				}
			} ]
		});
	}

	function offShelf(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		}
		
		$.messager.confirm('${internationalConfig.确认}', '${internationalConfig.确认要下架该内容包吗}', function(r) {
			if (r){
				$.ajax({
				    type: 'POST',
				    cache: false,
				    url: '/v2/product/aggPackage/offShelf',
				    data: {'id': id},
				    dataType: 'json',
				    success: function(data) {
				    	if(data.code == 0 ) {
				    		var timestamp=new Date().getTime();
				    		parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.下架成功}', 'success');
				    		renderDataGrid('/v2/product/aggPackage/dataGrid?timestamp='+timestamp+'&', $('#searchForm').serializeJson(), "get");
				    	} else {
				    		parent.$.messager.alert('${internationalConfig.错误}', data.msg || "${internationalConfig.下架失败}", 'error');
				    	}
				    }
				});
			}
		});
	}

	function onShelf(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		}
		
		$.messager.confirm('${internationalConfig.确认}', '${internationalConfig.确认要上架该内容包吗}', function(r) {
			if (r){
				$.ajax({
				    type: 'POST',
				    cache: false,
				    url: '/v2/product/aggPackage/onShelf',
				    data: {'id': id},
				    dataType: 'json',
				    success: function(data) {  
				    	if(data.code == 0 ){
				    		var timestamp=new Date().getTime();
				    		parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.上架成功}', 'success');
				    		console.log($('#searchForm').serializeJson())
				    		renderDataGrid('/v2/product/aggPackage/dataGrid?timestamp='+timestamp+'&', $('#searchForm').serializeJson(), "get");
				    	} else {
				    		parent.$.messager.alert('${internationalConfig.错误}', data.msg || "${internationalConfig.上架失败}", 'error');
				    	}
				    }
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
			title : '${internationalConfig.编辑内容包}',
			width :650,
			height : 500,
			href : '/v2/product/aggPackage/editAggPackage?id=' + id,
			onClose : function() {
				this.parentNode.removeChild(this);
			},
			buttons : [ {
				text : '${internationalConfig.保存}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;
					var f = parent.$.modalDialog.handler.find('#form');
					submitFun(f, 2);
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
			title : '${internationalConfig.添加内容包}',
			width : 650,
			height : 500,
			href : '/v2/product/aggPackage/editAggPackage?id=',
			onClose : function() {
				this.parentNode.removeChild(this);
			},
			buttons : [ {
				text : '${internationalConfig.增加}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid; // 因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#form');
					submitFun(f, 1);
				}
			}, {
				text : "${internationalConfig.取消}",
				handler : function() {
					parent.$.modalDialog.handler.dialog('close');
				}
			} ]
		});
	}

	/*function importFun(f) {
		if (f.form("validate")) {
			parent.$.messager.progress({
				title : '${internationalConfig.提示}',
				text : '${internationalConfig.数据处理中}....'
			});

			$.ajax({
				//url : "/v2/product/aggPackage/doImport",
				url : "/v2/product/aggPackage/save",
				type : "post",
				data : f.serializeJson(),
				dataType : "json",
				success : function(result) {
					parent.$.messager.progress('close');
					if (result.code == 0) {
						parent.$.messager.alert('${internationalConfig.成功}', '导入成功', 'success');
						parent.$.modalDialog.openner_dataGrid.datagrid('reload');
						parent.$.modalDialog.handler.dialog('close');
					} else {
						parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
					}
				},

				error : function() {}
			})
		}
	}*/

	function submitFun(f, type) {
		if (f.form("validate")) {
			parent.$.messager.progress({
				title : '${internationalConfig.提示}',
				text : '${internationalConfig.数据处理中}....'
			});

			var successStr;
			if(type == 1){
				successStr = "${internationalConfig.添加成功}";
			}else if(type == 2){
				successStr = "${internationalConfig.修改成功}";
			}
			$.ajax({
				url : "/v2/product/aggPackage/save",
				type : "post",
				data : f.serializeJson(),
				dataType : "json",
				success : function(result) {
					parent.$.messager.progress('close');
					if (result.code == 0) {
						parent.$.messager.alert('${internationalConfig.成功}', successStr, 'success');
						parent.$.modalDialog.openner_dataGrid.datagrid('reload');
						parent.$.modalDialog.handler.dialog('close');
					} else {
						parent.$.messager.alert('${internationalConfig.错误}', '<div style="word-break:break-all;">'+result.msg+'</div>', 'error');
					}
				},

				error : function() {}
			})
		}
	}

	function searchFun() {
		parent.$.messager.progress({
			title : '${internationalConfig.提示}',
			text : '${internationalConfig.数据处理中}....'
		});
		renderDataGrid('/v2/product/aggPackage/dataGrid?', $('#searchForm').serializeJson(), "get");
		parent.$.messager.progress('close');
	}

	function cleanFun() {
		$('#searchForm input').val('');
		renderDataGrid('/v2/product/aggPackage/dataGrid');
	}
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit:true, border:false">
		<div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.内容包管理}',border:false,height:'auto'">
			<form id="searchForm">
				<table  width="500" cellspacing="5">
					<tr>
						<td>${internationalConfig.内容包名称}:</td>
						<td><input name="aggPackageName" class="span2" /></td>
						<td>${internationalConfig.状态}:</td>
						<td>
							<select name="state" style="width: 120px">
								<option value="">${internationalConfig.全部}</option>
								<option value="1">${internationalConfig.上架}</option>
								<option value="2">${internationalConfig.下架}</option>
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
		<a href="javascript:void(0);" class="easyui-linkbutton" onclick="addFun(0);"
			data-options="plain:true,iconCls:'pencil_add'">${internationalConfig.增加}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton" onclick="searchFun();"
			data-options="iconCls:'brick_add',plain:true">${internationalConfig.查询}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton" onclick="cleanFun();"
			data-options="iconCls:'brick_delete',plain:true">${internationalConfig.清空条件}</a>

	</div>
</body>
</html>

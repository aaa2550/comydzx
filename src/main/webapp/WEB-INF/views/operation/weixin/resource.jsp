<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<title>${internationalConfig.图文信息管理}</title>
<m:auth uri="/weixin/resource_edit.json">
	<script type="text/javascript">
		$.canEdit = true;
	</script>
</m:auth>
<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid').datagrid({
			url : '/weixin/resource.json',
			fit : true,
			fitColumns : true,
			border : false,
			pagination : true,
			idField : 'id',
			pageSize : 20,
			pageList : [ 10, 20, 30, 40, 50 ],
			sortName : 'windex',
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
				field : 'title',
				title : '${internationalConfig.消息标题}',
				width : 60
			},
			{
				field : 'description',
				title : '${internationalConfig.消息描述}',
				width : 80
			},{
				field : 'picurl',
				title : '${internationalConfig.图片地址}',
				width : 110
			},{
				field : 'descripturl',
				title : '${internationalConfig.图文连接}',
				width : 110
			},{
				field : 'windex',
				title : '${internationalConfig.序列号}',
				width : 40
			},{
				field : 'action',
				title : '${internationalConfig.操作}',
				width : 100,
				formatter : function(value, row, index) {
					var str = '';
					if ($.canEdit) {
						str += $.formatString('<img onclick="editFun(\'{0}\');" src="{1}" title="${internationalConfig.编辑图文信息}"/>', row.id, '/static/style/images/extjs_icons/pencil.png');
						str += "&nbsp;";
						str += $.formatString('<img onclick="deleteFun(\'{0}\');" src="{1}" title="${internationalConfig.删除图文信息}"/>', row.id, '/static/style/images/extjs_icons/cancel.png');
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
	
	function deleteFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		}
		parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.您是否要删除此图文信息}？', function(b) {
			if (b) {
			parent.$.messager.progress({
				title : '${internationalConfig.提示}',
				text : '${internationalConfig.数据处理中}'
			});
			$.post('/weixin/resource_del.json', {
				id : id
			}, function(result) {
				if (result.success) {
					parent.$.messager.alert('${internationalConfig.提示}', result.msg, 'info');
					dataGrid.datagrid('reload');
				}else{
					parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
				}
				parent.$.messager.progress('close');
			}, 'JSON');
		} 
		});
	}

	//编辑信息
	function editFun(id) {
		
		parent.$.modalDialog({
			title : '${internationalConfig.编辑图文信息}',
			width : 1100,
			height : 400,
			resizable : true,
			href : '/weixin/resource_edit?id=' + id,
			buttons : [ {
				text : '${internationalConfig.保存}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			} ]
		});
	}

	//增加信息
	function addFun(id) {

		parent.$.modalDialog({
			title : '${internationalConfig.新增图文信息}',
			width : 1100,
			height : 400,
			resizable : true,
			href : '/weixin/resource_edit?id=' + id,
			buttons : [ {
				text : '${internationalConfig.保存}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
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
		<div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false" style="height: 80px; overflow: hidden;">
			<form id="searchForm">
				<table class="table table-hover table-condensed" style="display: none;">
					<tr>
						<td>${internationalConfig.消息标题}：<input name="title" class="span2" /></td>
					</tr>
				</table>
			</form>
		</div>
		<div data-options="region:'center',border:false">
			<table id="dataGrid"></table>
		</div>
	</div>
	<div id="toolbar" style="display: none;">
		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="addFun(0);">${internationalConfig.新增图文信息}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">${internationalConfig.清空条件}</a>
	</div>
</body>
</html>
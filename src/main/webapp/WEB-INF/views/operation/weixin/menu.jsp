<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<title>${internationalConfig.自定义菜单管理}</title>
<m:auth uri="/weixin/menu_edit.json">
	<script type="text/javascript">
		$.canEdit = true;
	</script>
</m:auth>
<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid').datagrid({
			url : '/weixin/menu.json',
			fit : true,
			fitColumns : true,
			border : false,
			pagination : true,
			idField : 'id',
			pageSize : 20,
			pageList : [ 10, 20, 30, 40, 50 ],
			sortName : 'name',
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
				field : 'name',
				title : '${internationalConfig.菜单名称}',
				width : 60
			},
			{
				field : 'mlevel',
				title : '${internationalConfig.菜单级别}',
				width : 80,
				formatter : function(value) {
					var str = '';
					if("1" == value) {
						str = "${internationalConfig.一级菜单}";
					}else if("2" == value) {
						str = "${internationalConfig.二级菜单}";
					}else{
						str = "${internationalConfig.未知}";
					}
					return str;
				}
			},{
				field : 'type',
				title : '${internationalConfig.菜单类型}',
				width : 60,
				formatter : function(value) {
					var str = '';
					if("1" == value) {
						str = "click";
					}else if("2" == value) {
						str = "view";
					}else{
						str = "${internationalConfig.未知}";
					}
					return str;
				}
			},{
				field : 'key',
				title : '${internationalConfig.菜单}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>KEY',
				width : 60
			},
			{
				field : 'url',
				title : '${internationalConfig.菜单}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>URL',
				width : 80
			},{
				field : 'status',
				title : '${internationalConfig.状态}',
				width : 50,
				formatter : function(value) {
					var str = '';
					if("0" == value) {
						str = "${internationalConfig.有效}";
					}else if("1" == value) {
						str = "${internationalConfig.失效}";
					}else{
						str = "${internationalConfig.未知}";
					}
					return str;
				}
			},   {
				field : 'description',
				title : '${internationalConfig.菜单描述}',
				width : 140
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
						str += $.formatString('<img onclick="editFun(\'{0}\');" src="{1}" title="${internationalConfig.编辑}"/>', row.id, '/static/style/images/extjs_icons/pencil.png');
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

	//编辑信息
	function editFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].movieId;
		}
		parent.$.modalDialog({
			title : '${internationalConfig.编辑自定义菜单}',
			width : 1100,
			height : 400,
			resizable : true,
			href : '/weixin/menu_edit?id=' + id,
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
	
	function addMenuFun(){
		parent.$.modalDialog({
			title : '${internationalConfig.新增自定义菜单}',
			width : 1100,
			height : 400,
			href : '/weixin/menu_add',
			buttons : [ {
				text : '${internationalConfig.添加}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			} ]
		});
	}
	
	function sendMenuFun(){
		parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.您是否发布自定义菜单到微信服务中心}？', function(b) {
			if (b) {
			parent.$.messager.progress({
				title : '${internationalConfig.提示}',
				text : '${internationalConfig.数据处理中}'
			});
			$.post('/weixin/send.json', {
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
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false" style="height: 80px; overflow: hidden;">
			<form id="searchForm">
				<table class="table table-hover table-condensed" style="display: none;">
					<tr>
						<td>${internationalConfig.菜单名称}：<input name="name" class="span2" /></td>
					</tr>
				</table>
			</form>
		</div>
		<div data-options="region:'center',border:false">
			<table id="dataGrid"></table>
		</div>
	</div>
	<div id="toolbar" style="display: none;">
		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="addMenuFun();">${internationalConfig.新增自定义菜单}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'book_go',plain:true" onclick="sendMenuFun();">${internationalConfig.发布自定义菜单}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">${internationalConfig.清空条件}</a>
	</div>
	<div id="menu" class="easyui-menu" style="width: 120px; display: none;">
		<div onclick="editFun();" data-options="iconCls:'pencil'">${internationalConfig.编辑}</div>
	</div>
</body>
</html>
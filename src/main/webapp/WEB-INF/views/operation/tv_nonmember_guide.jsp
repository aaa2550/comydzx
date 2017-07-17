<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.活动成功页配置管理}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>

<script type="text/javascript">
<m:auth uri="/tv_nonmember_guide/tv_nonmember_guide_edit.json">
	$.canEdit = true;
</m:auth>
<m:auth uri="/tv_nonmember_guide/tv_nonmember_guide_delete.json">
	$.canDelete = true;
</m:auth>
</script>

<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid').datagrid({
			url : '${pageContext.request.contextPath}/tv_nonmember_guide/data_grid.json',
			fit : true,
			fitColumns : true,
			border : false,
			pagination : true,
			idField : 'id',
			pageSize : 20,
			pageList : [ 10, 20, 30, 40, 50 ],
			sortName : 'id',
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
				field : 'userType',
				title : '${internationalConfig.付费播放场景引导}',
				width : 150,
				formatter : function(value) {
					var str = '';
					if("1" == value) {
						str = "${internationalConfig.前贴片广告}";
					}else if("2" == value) {
						str = "${internationalConfig.码流付费}";
					}else if("3" == value) {
						str = "${internationalConfig.单点影片}";
					}else if("4" == value) {
						str = "${internationalConfig.卡顿}";
					}
					
					return str;
				}
			},
			{
				field : 'mainTitle',
				title : '${internationalConfig.主标题}',
				width : 100,
				sortable : true
			},
			{
				field : 'subTitle',
				title : '${internationalConfig.副标题}',
				width : 100,
				sortable : true
			},
			{
				field : 'payType',
				title : '${internationalConfig.支付方式}',
				width : 100,
				formatter : function(value) {
					var str = '';
					if("41,42" == value) {
						str = "${internationalConfig.信用卡}";
					}else if("24" == value) {
						str = "${internationalConfig.微信}";
					}else if("5" == value) {
						str = "${internationalConfig.支付宝}";
					}else if("33" == value) {
						str = "${internationalConfig.乐点}";
					}else if("-1" == value) {
						str = "${internationalConfig.暂无}";
					}
					
					return str;
				}
			},
			{
				field : 'packageType',
				title : '${internationalConfig.全屏套餐}',
				width : 100,
				formatter : function(value) {
					var str = '';
					if("2" == value) {
						str = "${internationalConfig.包月}";
					}else if("3" == value) {
						str = "${internationalConfig.包季}";
					}else if("5" == value) {
						str = "${internationalConfig.包年}";
					}else if("-1" == value) {
						str = "${internationalConfig.暂无}";
					}
					
					return str;
				}
			},
			{
				field : 'imgUrl',
				title : '${internationalConfig.图片地址}',
				width : 150
			},
			{
				field : 'keyDesc',
				title : '${internationalConfig.按键文案配置}',
				width : 100,
				sortable : true
			},  {
				field : 'action',
				title : '${internationalConfig.操作}',
				width : 50,
				formatter : function(value, row, index) {
					var str = '';
					if ($.canEdit) {
						str += $.formatString('<img onclick="editFun(\'{0}\');" src="{1}" title="${internationalConfig.编辑}"/>', row.id, '${pageContext.request.contextPath}/static/style/images/extjs_icons/pencil.png');
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

	//编辑信息
	function editFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		}
		parent.$.modalDialog({
			title : '${internationalConfig.编辑}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>tv<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.非会员引导页配置}',
			width : 550,
			height : 450,
			resizable : true,
			href : '${pageContext.request.contextPath}/tv_nonmember_guide/tv_nonmember_guide_edit.json?tvNonmemberGuideId=' + id,
			onClose:function(){
				this.parentNode.removeChild(this);
			},
			buttons : [ {
				text : '${internationalConfig.保存}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
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
	}
	
	function addFun() {
		parent.$.modalDialog({
			title : '${internationalConfig.添加}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>tv<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.非会员引导页配置}',
			width : 550,
			height : 450,
			href : '${pageContext.request.contextPath}/tv_nonmember_guide/tv_nonmember_guide_add.json',
			onClose:function(){
				this.parentNode.removeChild(this);
			},
			buttons : [ {
				text : '${internationalConfig.添加}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
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
	}

	function deleteFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		}
		parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.您确定要删除当前配置吗}？',
		function(b) {
			if (b) {
				parent.$.messager.progress({
					title : '${internationalConfig.提示}',
					text : '${internationalConfig.数据处理中}'
				});
				$.post(
					'${pageContext.request.contextPath}/tv_nonmember_guide/delete.json',
					{
						tvNonmemberGuideId : id
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
							parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.请确认该配置处于线下状态}', 'error');
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
		<div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false" style="height: 80px; overflow: hidden;">
			<form id="searchForm">
				<table class="table-td-three" style="display: none;">
					<tr>
						<td>${internationalConfig.付费播放场景引导}：
							<select name="userType" class="span2">
							    <option value="-1" selected>${internationalConfig.全部}</option>
							    <option value="1">${internationalConfig.前贴片广告}</option>
							    <option value="2">${internationalConfig.码流付费}</option>
							    <option value="3">${internationalConfig.单点影片}</option>
							    <option value="4">${internationalConfig.卡顿}</option>
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
		<m:auth uri="/tv_nonmember_guide/tv_nonmember_guide_add.json">
			<a onclick="addFun();" href="javascript:void(0);"
				class="easyui-linkbutton"
				data-options="plain:true,iconCls:'bug_add'">${internationalConfig.添加}</a>
		</m:auth>
		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">${internationalConfig.清空条件}</a>
	</div>

	<div id="menu" class="easyui-menu" style="width: 120px; display: none;">
		<div onclick="editFun();" data-options="iconCls:'pencil'">${internationalConfig.编辑}</div>
	</div>
</body>
</html>
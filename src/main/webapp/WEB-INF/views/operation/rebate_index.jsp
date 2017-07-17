<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.积分商城}-${internationalConfig.商品管理}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript"   src="/js/kv/vip.js"></script>
<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '/rebate/list',
							fit : true,
							fitColumns : true,
							border : false,
							pagination : true,
							pageSize : 20,
							pageList : [ 10, 20, 30, 40, 50 ],
							sortName : 'updateTime',
							sortOrder : 'asc',
							checkOnSelect : false,
							selectOnCheck : false,
							singleSelect : true,
							nowrap : false,
							striped : true,
							rownumbers : true,
							singleSelect : true,
							columns : [ [
									{
										field : 'vipType',
										title : '${internationalConfig.会员类型}',
										width : 100,
									 	formatter: function(value){
					                    return Dict.vip[value] ;
					                
					                    }
									},{
										field : 'month',
										title : '${internationalConfig.连续月份}',
										width : 100
									},
									{
										field : 'price',
										title : '${internationalConfig.价格}',
										width : 100
									},
							
									{
										field : 'updateTime',
										title : '${internationalConfig.更新时间}',
										width : 100,
										sortable : true
									},
									{
										field : 'operator',
										title : '${internationalConfig.操作者}',
										width : 100
									
									},
									{
										field : 'action',
										title : '${internationalConfig.操作}',
										width : 60,
										formatter : function(value, row, index) {
											var str = '';
											
											str += $.formatString('<img onclick="addFun({0},{1});" src="{2}" title="${internationalConfig.编辑}"/>', row.vipType,row.month, '/static/style/images/extjs_icons/pencil.png');
											str += $.formatString('<img onclick="delFun({0},{1});" src="{2}" title="${internationalConfig.删除}"/>', row.vipType,row.month, '/static/style/images/extjs_icons/cancel.png');
										
											return str;
										}
									}									
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
	

	function searchFun() {
		dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
	}
	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}
	function addFun(vipType,month){
		var url='/rebate/save';
		if(vipType && month){
			url+="?vipType="+vipType+"&month="+month ;
		}
		parent.$.modalDialog({
			title : '${internationalConfig.编辑}',
			width : 600,
			height : 350,
			href : url,
			buttons : [ {
				text : '${internationalConfig.保存}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			} ]
		});
	}
	
	function delFun(vipType,month){
		if(window.confirm("${internationalConfig.确定删除吗}?")){
			$.post("/rebate/del",{vipType:vipType,month:month},function(result){
				parent.$.messager.alert('${internationalConfig.成功}', result.msg, 'success');
				dataGrid.datagrid('reload'); 
			},"JSON");
		}
		
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
			data-options="iconCls:'pencil_add',plain:true" onclick="addFun();">${internationalConfig.增加}</a>
		
	</div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.用户支付信息查询}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<style>
.table-td-more tr td{
	width:20%;
}
</style>
<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '/device/list.json',
							fit : true,
							fitColumns : true,
							border : false,
							pagination : true,
							idField : 'id',
							pageSize : 50,
							pageList : [ 20, 50, 100, 1000 ],
							checkOnSelect : false,
							selectOnCheck : false,
							nowrap : false,
							striped : true,
							rownumbers : true,
							singleSelect : true,
							frozenColumns : [ [ {
								field : 'id',
								title : '${internationalConfig.编号}',
								width : 80,
								hidden : true
							} ] ],
							columns : [ [ {
								field : 'sn',
								title : '${internationalConfig.SN码}',
								width : 50
							
							}, {
								field : 'mac',
								title : '${internationalConfig.MAC地址}',
								width : 50
							
							}, {
								field : 'key',
								title : '${internationalConfig.设备暗码}',
								width : 50
						
							}, {
								field : 'devicetype',
								title : '${internationalConfig.类型}',
								width : 20,
								formatter : function(value) {
									var str = '';
									if (1 == value) {
										str = "TV";
									} else if (2 == value) {
										str = "${internationalConfig.手机}";
									}else if(3==value){
										str="${internationalConfig.盒子}" ;
									} else if(4==value){
										str="${internationalConfig.路由器}" ;
									}
									return str;
								}
						
							}
							, {
								field : 'createTime',
								title : '${internationalConfig.上传时间}',
								width : 50,
								sortable : true
							}, 
							{
								field : 'activeTime',
								title : '${internationalConfig.激活时间}',
								width : 50
							},
							
							{
								field : 'ifsync',
								title : '${internationalConfig.同步状态}',
								width : 20,
								sortable : true,
								formatter : function(value) {
									var str = '';
									if ("0" == value) {
										str = "${internationalConfig.同步中}";
									} else if ("1" == value) {
										str = "${internationalConfig.同步成功}";
									} 
									return str;
								}
							},
						     {
			                    field: 'action',
			                    title: '${internationalConfig.操作}',
			                    width: 20,
			                    formatter: function (value, row, index) {                   
			                       var     str = $.formatString('<img onclick="updateActive(\'{0}\',{2});" src="{1}" title="${internationalConfig.更新激活时间}"/>', row.mac, '/static/style/images/extjs_icons/pencil.png',row.devicetype);
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
	function uploadDevice() {
	    parent.$.modalDialog({
	        title: '${internationalConfig.上传设备信息}',
	        width: 520,
	        height: 250,
	        href: '/device/toupload',
	        buttons: [
	            {
	                text: '${internationalConfig.上传}',
	                handler: function () {
	                    parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
	                    var f = parent.$.modalDialog.handler.find('#form');
	                    f.submit();
	                }
	            }
	        ]
	    });
	}
	
	function checkDevice() {
	    parent.$.modalDialog({
	        title: '${internationalConfig.核对设备信息}',
	        width: 520,
	        height: 250,
	        href: '/device/tocheck',
	        buttons: [
	            {
	                text: '${internationalConfig.校验}',
	                handler: function () {
	                    parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
	                    var f = parent.$.modalDialog.handler.find('#form');
	                    f.submit();
	                }
	            }
	        ]
	    });
	}
	
	//导出设备信息
	function exportDevice() {
		var createDate = $('#createTime').datebox('getValue');
		var deviceType = $('#devicetype').val() ;
	    if (createDate == undefined || createDate == '') {
	       alert('${internationalConfig.请选择上传日期}') ;
	       return ;
	    }
	    var url = '${pageContext.request.contextPath}/device/exportDevice.json?createTime=' + createDate+'&devicetype='+deviceType;
	    location.href = url;
	}
	
	function updateActive(mac,devicetype) {
		  if(window.confirm("${internationalConfig.确定要更新此设备的激活时间吗}？")){
			  $.post("/device/update_active",{"mac":mac,"devicetype":devicetype},function(){				  
				  parent.$.messager.alert('success',mac+"${internationalConfig.激活时间更新成功}");
			  });
		  }
		}
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
			style="height: 80px; overflow: hidden;">
			<form id="searchForm">
				<table class="table-td-more table-more"  style="display: none;">
					<tr>
						<td>SN：<input id="sn" name="sn" class="span2"></input>
						</td>
						<td>MAC：<input id="mac" name="mac" class="span2"></input>
						</td>
						<td>${internationalConfig.设备暗码}：<input id="key" name="key" class="span2"></input>
						</td>
						<td><span>${internationalConfig.设备类型}：</span> <select style="width: 100px"
							name="devicetype" id="devicetype">
								<option value="0" selected="selected">${internationalConfig.全部}</option>
								<option value="1">${internationalConfig.超级电视}</option>
								<option value="2">${internationalConfig.超级手机}</option>
								<option value="3">${internationalConfig.盒子}</option>
								<option value="4">${internationalConfig.路由器}</option>
						</select></td>
						<td><span>${internationalConfig.上传日期}：</span> <input type="text" name="createTime"
							id="createTime" class="easyui-datebox" class="easyui-validatebox" /></td>
					</tr>
				</table>
			</form>
		</div>
		<div data-options="region:'center',border:false">
			<table id="dataGrid"></table>
		</div>
	</div>
	<div id="toolbar" style="display: none;">
		<a onclick="uploadDevice();" href="javascript:void(0);"
			class="easyui-linkbutton" data-options="plain:true,iconCls:'bug_add'">${internationalConfig.上传设备信息}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a><a
			href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_delete',plain:true"
			onclick="cleanFun();">${internationalConfig.清除条件}</a> <a onclick="checkDevice();"
			href="javascript:void(0);" class="easyui-linkbutton"
			data-options="plain:true,iconCls:'bug_add'">${internationalConfig.核对设备信息}</a> <a
			onclick="exportDevice();" href="javascript:void(0);"
			class="easyui-linkbutton" data-options="plain:true,iconCls:'bug_add'">${internationalConfig.按日期导出设备}</a>

	</div>
</body>
</html>
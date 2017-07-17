<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.用户拆分}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '/device/query_user_split_list',
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
								width : 180
							}, {
								field : 'mac',
								title : '${internationalConfig.MAC地址}',
								width : 150
							}, {
								field : 'bindtime',
								title : '${internationalConfig.售卖绑定时长}',
								width : 100,
								formatter:function(value){
									if(value>0){
										return (value/31)+"${internationalConfig.个月}" ;
									}else{
										return "" ;
									}
								}
							}, {
								field : 'contracttime',
								title : '${internationalConfig.合约兑换时长}',
								width : 100,
								formatter:function(value){
									if(value>0){
										return (value/31)+"${internationalConfig.个月}" ;
									}else{
										return "" ;
									}
								}
							}, {
								field : 'bindUserid',
								title : '${internationalConfig.绑定用户ID}',
								width : 100
							}, {
								field : 'activetime',
								title : '${internationalConfig.用户激活时间}',
								width : 150,
								formatter:function(value){
									if(value>0)
									return new Date(value).format() ;
								}
							}, {
								field : 'endtime',
								title : '${internationalConfig.移动会员有效期}',
								width : 150,
								formatter:function(value){
									if(value>0)
									return new Date(value).format() ;
								}
							}, {
								field : 'seniorendtime',
								title : '${internationalConfig.机卡绑定会员有效期}',
								width : 150,
								formatter:function(value){
									if(value>0)
									return new Date(value).format() ;
								}
							},
			                {
			                    field: 'action',
			                    title: '${internationalConfig.操作}',
			                    width: 100,
			                    formatter: function (value, row, index) {
			                        var str = '&nbsp;&nbsp;&nbsp;';
			                        if ((row.bindtime + row.contracttime) / 31 > 12) {
			                        str += $.formatString('<img onclick="splitFun(\'{0}\',\'{1}\',\'{2}\');" src="{3}" title="${internationalConfig.拆分}"/>', row.mac, row.bindtime, row.contracttime, '/static/style/images/extjs_icons/bug/bug_delete.png');
			                        }
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
		var uid = $("#uid").val();
		var mac = $("#mac").val();
		
		if(uid == "" || mac == "") {
			parent.$.messager
			.alert("${internationalConfig.查询失败}","${internationalConfig.用户ID}${internationalConfig.和}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>MAC/IMEI<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.都不能为空}",'error');
			return ;
		}
		
		dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
	}
	function cleanFun() {
		$('#searchForm input').val('');
	}
	
	function splitFun(mac, bindtime, contracttime) {
		parent.$
				.modalDialog({
					title : '${internationalConfig.用户时长拆分}',
					scroll : true,
					width : 850,
					height : 500,
					resizable : true,
					maximizable : true,
					href : '${pageContext.request.contextPath}/device/query_user_split_edit.json?mac=' + mac + "&monthTotal=" + (parseInt(bindtime) + parseInt(contracttime)),
					buttons : [ {
						text : '${internationalConfig.确定}',
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
					}

					]
				});
	}
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
			style="height: 80px; overflow: hidden;">
			<form id="searchForm">
				<table class="table-td-two"
					style="display: none;">
					<tr>
						<th></th>
						<td>${internationalConfig.用户ID}：<input id="uid" name="userId" class="easyui-validatebox" data-options="required:true"></input>
						</td>
						<td>MAC / IMEI：<input id="mac" name="mac" class="easyui-validatebox" data-options="required:true"></input>
						</td>
						<th></th>
					</tr>
				</table>
			</form>
		</div>
		<div data-options="region:'center',border:false">
			<table id="dataGrid"></table>
		</div>
	</div>
	<div id="toolbar" style="display: none;">
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a><a
			href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_delete',plain:true"
			onclick="cleanFun();">${internationalConfig.清除条件}</a>
	</div>
</body>
</html>
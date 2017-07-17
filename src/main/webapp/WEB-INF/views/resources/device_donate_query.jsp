<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.机卡查询解绑}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '/device/donate_query_list',
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
								field : 'vipType',
								title : '${internationalConfig.会员类型}',
								width : 150,
								formatter:function(value){
									if(value==1){
										return "${internationalConfig.乐次元影视会员}" ;
									}else if(value==2){
										return "${internationalConfig.超级影视会员}" ;
									}else if(value==3){
										return "${internationalConfig.乐视超级体育会员}";
									}
								}
							},{
								field : 'deviceInfo',
								title : '${internationalConfig.手机IMEI}',
								width : 180
							}, {
								field : 'deviceVersion',
								title : '${internationalConfig.手机型号}',
								width : 150,
								hidden : true
							}, {
								field : 'presentDeviceInfo',
								title : '${internationalConfig.电视MAC}',
								width : 100
							}, {
								field : 'presentType',
								title : '${internationalConfig.领取设备类型}',
								width : 100,
								formatter:function(value){
									if(value==9){
										return "${internationalConfig.超级电视}";
									}else if(value==2){
										return "${internationalConfig.超级手机}";
									}else{
										return "";
									}
								}
							}, {
								field : 'presentDuration',
								title : '${internationalConfig.领取时长}',
								width : 100,
								formatter:function(value){
									if(value>0){
										return (value/31)+"${internationalConfig.个月}" ;
									}else{
										return "" ;
									}
								}
							},{
								field : 'presentDurationGet',
								title : '${internationalConfig.实际领取时长}',
								width : 100,
								formatter:function(value){
									if(value>0){
										return (value/31)+"${internationalConfig.个月}" ;
									}else{
										return "" ;
									}
								}
							}, {
								field : 'createTime',
								title : '${internationalConfig.创建时间}',
								width : 150
							},/*  {
								field : 'presentExpiredTime',
								title : '${internationalConfig.领取过期时间}',
								width : 150
							}, */ {
								field : 'presentTime',
								title : '${internationalConfig.领取时间}',
								width : 150
							}, {
								field : 'status',
								title : '${internationalConfig.设备状态}',
								width : 150,
								 formatter: function(value){
				                    	//  申请用途 1 正常 2 激活 3 退货
				                    	if(value==0){
				                    		return "${internationalConfig.未领取}";
				                    	}else if(value==1){
				                    		return "${internationalConfig.已领取}";
				                    	}
				                    	return "${internationalConfig.其它}"
				                    }
							},
			                {
			                    field: 'action',
			                    title: '${internationalConfig.操作}',
			                    width: 100,
			                    formatter: function (value, row, index) {
			                        var str = '&nbsp;&nbsp;&nbsp;';
			                        if (row.deviceInfo && row.Id != '' ) {
			                        str += $.formatString('<img onclick="unbindFun(\'{0}\',\'{1}\',\'{2}\');" src="{3}" title="${internationalConfig.解绑}"/>', row.deviceInfo,row.id,row.mac, '/static/style/images/extjs_icons/bug/bug_delete.png');
			                        }else{
			                        	 str += $.formatString('<img onclick="syscTime(\'{2}\');" src="{3}" title="${internationalConfig.同步时长}"/>', row.bindUserid,row.sn,row.mac, '/static/style/images/extjs_icons/bug/bug_delete.png');
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
		dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
	}
	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}
	
	/* //同步时长
	function syscTime(mac) {
	    parent.$.modalDialog({
	        title: '同步设备时长',
	        width: 320,
	        height: 200,
	        href: '/device/tosynctime?mac='+mac,
	        buttons: [
	            {
	                text: '提交',
	                handler: function () {
	                    parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
	                    var f = parent.$.modalDialog.handler.find('#form');
	                    f.submit();
	                }
	            }
	        ]
	    });
	} */
	
	
	//解绑操作
	function unbindFun(id,deviceInfo) {
	    parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.询问是否解除绑定}？', function (b) {
	        if (b) {
	            parent.$.messager.progress({
	                title: '${internationalConfig.提示}',
	                text: '${internationalConfig.数据处理中}'
	            });
	            $.post( '/device/card_Unbundling.do', {
	            	presentid:deviceInfo,mac:id
	            }, function (obj) {
	                if (obj.code == 0) {
	                	parent.$.messager
						.alert(
								'${internationalConfig.解绑成功}',
								obj.msg,
								'success');
	                    searchFun();
	                }else {
						parent.$.messager
						.alert(
								'${internationalConfig.解绑失败}',
								obj.msg,
								'obj.value');
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
		<div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
			style="height: 80px; overflow: hidden;">
			<form id="searchForm">
				<table class="table-td-two"
					style="display: none;">
					<tr>
						<th></th>
						<td>${internationalConfig.用户ID}：<input id="uid" name="userId" class="easyui-validatebox"></input>
						</td>
						<td>${internationalConfig.手机IMEI}：<input id="mac" name="deviceInfo" class="easyui-validatebox" ></input>
						</td>
						<td>${internationalConfig.电视MAC}：<input id="pmac" name="presentDeviceInfo" class="easyui-validatebox" ></input>
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
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.机卡绑定信息查询}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '/device/query_list',
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
							},] ],
							columns : [[{
								field : 'devicetype',
								title : '${internationalConfig.绑定设备类型}',
								width : 100,
								formatter:function(value){
									if(value==1){
										return "${internationalConfig.超级电视}" ;
									}else if(value==2){
										return "${internationalConfig.超级手机}" ;
									}else if(value==3){
										return "${internationalConfig.盒子}" ;
									}else if(value==4){
										return "${internationalConfig.路由器}" ;
									}
								}
							},{
								field : 'sn',
								title : '${internationalConfig.SN码}',
								width : 180
							},{
								field : 'mac',
								title : '${internationalConfig.MAC地址}',
								width : 150
							},{
								field : 'bindtime',
								title : '${internationalConfig.售卖绑定时长}',
								width : 100,
								formatter:function(value){
									if(value>0){
										return (value/31)+"${internationalConfig.个月}" ;
									}else{
										return "0" ;
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
										return "0" ;
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
							}, {
								field : 'endtime',
								title : '${internationalConfig.会员有效期}',
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
							},{
								field : 'status',
								title : '${internationalConfig.设备状态}',
								width : 150,
								 formatter: function(value, row,index){
				                    	//  申请用途 1 正常 2 激活 3 退货
				                    	/*  if(value==3){
				                    		return "已退货";
				                    	}else if(row.bindUserid != ''){
				                    		return "已激活";
				                    	}if(row.bindUserid == ''){
				                    		return "正常";
				                    	}  */

				                    	 if(value==1){
				                    		return "${internationalConfig.正常}";
				                    	}else if(value==2){
				                    		return "${internationalConfig.已激活}";
				                    	}else if(value==3){
				                    		return "${internationalConfig.已退货}";
				                    	}
				                    	return "${internationalConfig.其它}"
				                    }
							},
			                {
			                    field: 'action',
			                    title: '${internationalConfig.操作}',
			                    width: 300,
			                    formatter: function (value, row, index) {
			                        var str = '&nbsp;&nbsp;&nbsp;';
			                        /* if (row.status==2) {


			                        }else{
			                        	 str += $.formatString('<a href="javascript:void(0);" onclick="syscTime(\'{2}\',\'{3}\');">同步时长</a>', row.bindUserid,row.sn,row.mac,row.vipType);

			                        } */
			                        if(row.devicetype==1 || row.devicetype==3){
			                        	if(row.status==3){
			                        		str += $.formatString('<a href="javascript:void(0);" onclick="syscTime(\'{2}\',\'{3}\');">${internationalConfig.同步时长}</a>', row.bindUserid,row.sn,row.mac,row.vipType);
			                        	}else{
			                        		if(row.status==1){
			                        			str += $.formatString('<a href="javascript:void(0);" onclick="syscTime(\'{2}\',\'{3}\');">${internationalConfig.同步时长}</a>', row.bindUserid,row.sn,row.mac,row.vipType);
			                        		}else if(row.status==2){
			                        			 str += $.formatString('<a href="javascript:void(0);" onclick="unbindFun(\'{0}\',\'{1}\',\'{2}\');">${internationalConfig.解绑}</a>', row.bindUserid,row.sn,row.mac);
			                        		 }
			                        		str += '&nbsp;';
					                        str += $.formatString('<a href="javascript:void(0);" onclick="returnTV(\'{0}\',\'{1}\');">${internationalConfig.退货}</a>',row.mac,row.devicetype);
			                        	str += '&nbsp;';
				                            str += $.formatString('<a href="javascript:void(0);" onclick="changeB2B(\'{0}\',\'{1}\');">B2B${internationalConfig.换货}</a>',row.mac,row.devicetype);
				                        str += '&nbsp;';
				                            str += $.formatString('<a href="javascript:void(0);" onclick="changeB2C(\'{0}\',\'{1}\');">B2C${internationalConfig.换货}</a>',row.mac,row.devicetype);
			                        	}

			                        } else if(row.devicetype==2){
			                        	if(row.status==3){
			                        		str += $.formatString('<a href="javascript:void(0);" onclick="syscTime(\'{2}\',\'{3}\');">${internationalConfig.同步时长}</a>', row.bindUserid,row.sn,row.mac,row.vipType);
			                        	}else{
			                        		if(row.status==1){
			                        			str += $.formatString('<a href="javascript:void(0);" onclick="syscTime(\'{2}\',\'{3}\');">${internationalConfig.同步时长}</a>', row.bindUserid,row.sn,row.mac,row.vipType);
			                        		}else if(row.status==2){
			                        			str += $.formatString('<a href="javascript:void(0);" onclick="unbindFun(\'{0}\',\'{1}\',\'{2}\');">${internationalConfig.解绑}</a>', row.bindUserid,row.sn,row.mac);
			                        		 }
			                        	str += '&nbsp;';
					                        str += $.formatString('<a href="javascript:void(0);" onclick="returnM(\'{0}\',\'{1}\');">${internationalConfig.退货}</a>',row.mac,row.devicetype);
			                        	str += '&nbsp;';
				                            str += $.formatString('<a href="javascript:void(0);" onclick="changeM(\'{0}\',\'{1}\');">${internationalConfig.换货}</a>',row.mac,row.devicetype);
				                        str += '&nbsp;';
				                            str += $.formatString('<a href="javascript:void(0);" onclick="repairM(\'{0}\',\'{1}\');">${internationalConfig.维修}</a>',row.mac,row.devicetype);
			                        	}

			                        } else if(row.devicetype==4){
			                        	if(row.status==3){
			                        		str += $.formatString('<a href="javascript:void(0);" onclick="syscTime(\'{2}\',\'{3}\');">${internationalConfig.同步时长}</a>', row.bindUserid,row.sn,row.mac,row.vipType);
			                        	}else{
			                        		if(row.status==1){
			                        			str += $.formatString('<a href="javascript:void(0);" onclick="syscTime(\'{2}\',\'{3}\');">${internationalConfig.同步时长}</a>', row.bindUserid,row.sn,row.mac,row.vipType);
			                        		}else if(row.status==2){
			                        			str += $.formatString('<a href="javascript:void(0);" onclick="unbindFun(\'{0}\',\'{1}\',\'{2}\');">${internationalConfig.解绑}</a>', row.bindUserid,row.sn,row.mac);
			                        		 }
			                        		str += '&nbsp;';
					                        str += $.formatString('<a href="javascript:void(0);" onclick="returnTV(\'{0}\',\'{1}\');">${internationalConfig.退货}</a>',row.mac,row.devicetype);
			                        	str += '&nbsp;';
				                            str += $.formatString('<a href="javascript:void(0);" onclick="changeB2B(\'{0}\',\'{1}\');">${internationalConfig.换货}</a>',row.mac,row.devicetype);
			                        	}

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
		var data=$.serializeObject($('#searchForm'));
		//console.log(data);
		if(data.sn==""&&data.mac==''){
			$('#lt').hide();
		}else{
			$('#lt').show();
		}
		dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
	}
	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}
	function longTime() {

		if($('#mac').val()!=''){
			 parent.$.modalDialog({
			        title: '${internationalConfig.同步设备时长}',
			        width: 390,
			        height: 400,
			        href: '/device/tolongtime?mac='+$('#mac').val(),
			        buttons: [
			            {
			                text: '${internationalConfig.提交}',
			                handler: function () {
			                    parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
			                    var f = parent.$.modalDialog.handler.find('#form');
			                    f.submit();
			                }
			            }
			        ]
			    });

		}




	}




	//同步时长
	function syscTime(mac,vipType) {
	    parent.$.modalDialog({
	        title: '${internationalConfig.同步设备时长}',
	        width: 320,
	        height: 200,
	        href: '/device/tosynctime?mac='+mac+'&vipType='+vipType,
	        buttons: [
	            {
	                text: '${internationalConfig.提交}',
	                handler: function () {
	                    parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
	                    var f = parent.$.modalDialog.handler.find('#form');
	                    f.submit();
	                }
	            }
	        ]
	    });
	}


	//解绑操作
	function unbindFun(bindUserid,sn,mac) {
	    parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.询问是否解除绑定}', function (b) {
	        if (b) {
	            parent.$.messager.progress({
	                title: '${internationalConfig.提示}',
	                text: '${internationalConfig.数据处理中}'
	            });
	            $.post('/device/unbind.json', {
	            	bindUserid: bindUserid,sn:sn,mac:mac
	            }, function (obj) {
	                if (obj.code == 0) {
	                    searchFun();
	                }else {
						parent.$.messager
						.alert(
								'${internationalConfig.解绑失败}',
								obj.msg,
								'error');
			           }
	                parent.$.messager.progress('close');
	            }, 'JSON');
	        }
	    });
	};

	//电视、盒子退货操作
	function returnTV(mac,devicetype) {
	    parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.您是否确认退货}？', function (b) {
	        if (b) {
	            parent.$.messager.progress({
	                title: '${internationalConfig.提示}',
	                text: '${internationalConfig.数据处理中}'
	            });
	            $.post('/device/return_tv.json', {
	            	mac:mac,deviceType:devicetype
	            }, function (obj) {
	                if (obj.code == 0) {
	                	parent.$.messager.alert('${internationalConfig.退货成功}',obj.msg,'success');
	                    searchFun();
	                }else {
						parent.$.messager.alert('${internationalConfig.退货失败}',obj.msg);
			           }
	                parent.$.messager.progress('close');
	            }, 'JSON');
	        }
	    });
	};
	//电视、盒子B2B换货操作
 	function changeB2B(mac,devicetype) {
	    parent.$.modalDialog({
	        title: '${internationalConfig.换货}',
	        width: 320,
	        height: 200,
	        href: '/device/tochangeb?mac='+mac+'&deviceType='+devicetype,
	        buttons: [
	            {
	                text: '${internationalConfig.提交}',
	                handler: function () {
	                    parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
	                    var f = parent.$.modalDialog.handler.find('#form');
	                    f.submit();
	                }
	            }
	        ]
	    });
	}
 	//电视、盒子B2C换货操作
 	function changeB2C(mac,devicetype) {
	    parent.$.modalDialog({
	        title: 'B2C<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.换货}',
	        width: 320,
	        height: 200,
	        href: '/device/tochangec?mac='+mac+'&deviceType='+devicetype,
	        buttons: [
	            {
	                text: '${internationalConfig.提交}',
	                handler: function () {
	                    parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
	                    var f = parent.$.modalDialog.handler.find('#form');
	                    f.submit();
	                }
	            }
	        ]
	    });
	}
	//手机退货操作
	function returnM(mac,devicetype) {
	    parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.您是否确认退货}？', function (b) {
	        if (b) {
	            parent.$.messager.progress({
	                title: '${internationalConfig.提示}',
	                text: '${internationalConfig.数据处理中}'
	            });
	            $.post('/device/return_mobile.json', {
	            	mac:mac,deviceType:devicetype
	            }, function (obj) {
	                if (obj.code == 0) {
	                	parent.$.messager.alert('${internationalConfig.退货成功}',obj.msg,'success');
	                    searchFun();
	                }else {
						parent.$.messager.alert('${internationalConfig.退货失败}',obj.msg);
			           }
	                parent.$.messager.progress('close');
	            }, 'JSON');
	        }
	    });
	};
 	//手机换货操作
 	function changeM(mac,devicetype) {
	    parent.$.modalDialog({
	        title: '${internationalConfig.换货}',
	        width: 320,
	        height: 200,
	        href: '/device/tochangeMobile?mac='+mac+'&deviceType='+devicetype,
	        buttons: [
	            {
	                text: '${internationalConfig.提交}',
	                handler: function () {
	                    parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
	                    var f = parent.$.modalDialog.handler.find('#form');
	                    f.submit();
	                }
	            }
	        ]
	    });
	}

 	//手机维修操作
 	function repairM(mac,devicetype) {
	    parent.$.modalDialog({
	        title: '${internationalConfig.维修}',
	        width: 320,
	        height: 200,
	        href: '/device/torepairMobile?mac='+mac+'&deviceType='+devicetype,
	        buttons: [
	            {
	                text: '${internationalConfig.提交}',
	                handler: function () {
	                    parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
	                    var f = parent.$.modalDialog.handler.find('#form');
	                    f.submit();
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
				<table class="table-td-three"
					style="display: none;">
					<tr>
						<td>${internationalConfig.用户ID}：<input id="uid" name="bindUserid" class="easyui-validatebox"></input>
						</td>
						<td>SN：<input id="sn" name="sn" class="easyui-validatebox" ></input>
						</td>
						<td>MAC / IMEI：<input id="mac" name="mac" class="easyui-validatebox" ></input>
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
			onclick="cleanFun();">${internationalConfig.清除条件}</a><a href="javascript:void(0);" id="lt" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true"
			onclick="longTime();">${internationalConfig.同步时长}</a>
	</div>

</body>
</html>
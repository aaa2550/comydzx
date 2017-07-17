<%@page import="com.letv.boss.LetvEnv"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head> 
<title>${internationalConfig.用户支付信息查询}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
<m:auth uri="/consume/open_service.json">
	$.canOpen = true;
</m:auth>
<m:auth uri="/consume/close_service.json">
	$.canClose = true;
</m:auth>
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'">
			<form id="searchForm">
				<table class="table-td-four"
					style="width:100%;">
					<tr>
						<td style="width:20%;">${internationalConfig.用户}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID：<input id="userId" name="userid" value="${param.userId}" class="span2" data-options="required:true"></input></td>
						<td style="width:20%;">${internationalConfig.消费订单号}：<input id="productid" name="orderid" class="span2" ></input></td>
						<%-- <td style="width:20%;">${internationalConfig.设备标识}：<input id="aid2" name="aid2" class="span2" ></input></td> --%>
						<td style="width:20%;">${internationalConfig.订单状态}：
							<select name="status" class="span2">
									<option value="0">${internationalConfig.全部}</option>
									<option value="1">${internationalConfig.未开通}</option>
									<option value="2">${internationalConfig.已开通}</option>
							</select>
						</td>
						<td style="width:20%;">${internationalConfig.会员类型}:
							<select name="type" class="span2">
								<option value="1">${internationalConfig.影视会员}</option>
								<c:choose>
									<c:when test='${fn:contains(env,"hk") }'>								
										<option value="2">${internationalConfig.体育会员}</option>
									</c:when>
									<c:otherwise>
										<option value="8">${internationalConfig.体育会员}</option>
									</c:otherwise>
								</c:choose>

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
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">${internationalConfig.清空条件}</a> 
	</div>
	
	<div id="mydialog" style="display:none;padding:5px;width:400px;height:200px;" title="${internationalConfig.退款}"> 
<input id="txRoleID" type="hidden" runat="server" value="0" /> 
<label class="lbInfo">${internationalConfig.退款金额}：</label> 
<input id="refund_fee_id" type="text" class="easyui-validatebox" required="true" runat="server" /><br /> 
<label class="lbInfo"> </label>
<label id="lbmsg" runat="server"></label> 
</div> 

<script type="text/javascript">

	var dataGrid;
	$(function() {
	
		
		dataGrid = $('#dataGrid').datagrid({
				url : '/consume/data_grid.json',
				queryParams:$.serializeObject($('#searchForm')),
				fit : true,
				fitColumns : true,
				border : false,
				pagination : true,
				idField : 'id',
				pageSize : 10,
				pageList : [ 10, 20, 30, 40, 50 ],
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
				columns : [ [ {
					field : 'orderid',
					title : '${internationalConfig.订单号}',
					width : 180,
					sortable : true
				}, {
					field : 'ordername',
					title : '${internationalConfig.订单名}',
					width : 150,
					sortable : true
				},{ 
					field : 'money',
					title : '${internationalConfig.价格}',
					width : 80,
					sortable : true
				}, {
					field : 'paytime', 
					title : '${internationalConfig.下单时间}',
					width : 100,
					sortable : true
				},/*{
			          field : 'type',
			          title : '${internationalConfig.会员类型}',
			          width : 150,
			          formatter:function(value){
							if(value==1 ||value==0){
								return "${internationalConfig.非体育会员}";	
							}else if(value==8){
								return "${internationalConfig.体育会员}";
							}
						}
			      },*/{
					field : 'createtime', 
					title : '${internationalConfig.订单起始时间}',
					width : 180,
					sortable : true
				}, {
					field : 'canceltime', 
					title : '${internationalConfig.截至有效时间}',
					width : 180,
					sortable : true
				}, {
					field : 'ordertype',
					title : '${internationalConfig.订单类型}',
					width : 120,
					sortable : true,
					formatter : function(value, row, index) {
						var str = '';
						if ("0" == value) {
							str = "${internationalConfig.单片}";
						}else if ("2" == value) {
							str = "${internationalConfig.包月}";
						} else if ("3" == value) {
							str = "${internationalConfig.包季}";
						} else if ("4" == value) {
							str = "${internationalConfig.包半年}";
						} else if ("5" == value || "8" == value) {
							str = "${internationalConfig.包年}";
						} else if ("6" == value) {
							str = "${internationalConfig.包三年}";
						} else if ("7" == value) {
							str = "${internationalConfig.包两年}";
						}else if ("53" == value) {
							str = "${internationalConfig.包15个月}";
						}else if ("54" == value) {
							str = "${internationalConfig.包18个月}";
						}else if ("55" == value) {
							str = "${internationalConfig.包30个月}";
						} else if("1001" == value){
							str = "${internationalConfig.直播}";
						} else if("40" == value){
							str = "${internationalConfig.七天高级免费VIP}";
						} else if("2000" == value) {
							str = "${internationalConfig.组合套餐}";
						}else if("101" == value){
							str = "${internationalConfig.会员套餐}";
						}else if("102" == value){
							str = "${internationalConfig.点播}";
						}else if("103" == value){
							str = "${internationalConfig.直播}";
						}
						if(row.orderfrom=='13'){
							str = '${internationalConfig.超级电视机卡}' ;
						}else if(row.orderfrom=='14'){
							str = '${internationalConfig.超级手机机卡}' ;
						}else if(row.orderfrom=='15'){
							str = '${internationalConfig.路由器机卡}' ;
						}
						return str;
					}
				}, {
					field : 'userid',
					title : '${internationalConfig.用户ID}',
					width : 110,
					sortable : true
				},{
					field : 'status',
					title : '${internationalConfig.订单状态}',
					width : 90,
					sortable : true,
					formatter : function(value) {
						var str = '';
						if ("0" == value) {
							str = "${internationalConfig.未开通}";
						} else if ("1" == value) {
							str = "${internationalConfig.已开通}";
						} else if("4" == value || "3" == value) {
							str = "${internationalConfig.关闭}";
						} else if("5" == value){
							str = "${internationalConfig.会员转入}";
						} else if("6" == value){
							str = "${internationalConfig.会员转出}";
						}
						
						return str;
					}
				}
				    <c:if test="${currentCountry!=86}">
					, {
						field : 'action',
						title : '${internationalConfig.操作}',
						width : 100,
						formatter : function(value, row, index) {
							var str = '';
							if (($.canOpen && row.status == 0) || row.status == 3) {
								str += $.formatString('<img onclick="editOpen(\'{0}\',\'{1}\',\'{2}\');" src="{3}" title="${internationalConfig.开通}"/>', row.orderid,row.userid,row.money,'/static/style/images/extjs_icons/pencil.png');
							}
							str += '&nbsp;';
							if ($.canClose && ((row.status == 1))) {
								str += $.formatString('<img onclick="editClose(\'{0}\',\'{1}\');" src="{2}" title="${internationalConfig.关闭}"/>', row.orderid,row.userid,'/static/style/images/extjs_icons/cancel.png');
							}

							return str;
						}
					}
					</c:if>
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
		userId = $('#userId').val();
		if('' == userId){
			$.messager.alert('${internationalConfig.错误}', "${internationalConfig.用户ID不能为空}", 'error');
			return;
		}
		dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
	}
	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}
	
	function editOpen(id,userid,money) {
 		$.messager.confirm('${internationalConfig.确认}', '${internationalConfig.确定开通此订单的服务}', function(r) {
			if(r) {
				$.ajax({  
					   type: 'GET',  
					   url: '/consume/open_service.json?orderid='+id+'&userid='+userid+'&money='+money+'&type='+$("select[name=type]").val(),
					   dataType: 'html',
					   success: function(result){  
						    result = $.parseJSON(result);
							if (result.code == 0) {
								parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.关闭订单成功}', 'success');
								dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
							} else {
								parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.关闭订单失败}', 'error');
							}
					   }  
					}); 
			}
		}); 
	}
	
	
	
	function Open_Dialog(id) { 
	
	$('#mydialog').show();
		$('#mydialog').dialog({
			collapsible : true,
			minimizable : true,
			maximizable : true,
			buttons : [ {
				text : '${internationalConfig.提交}',
				handler : function() {
					var refund_fee_id = $('#refund_fee_id').val();
					var refundurl = "http://api.zhifu.letv.com/pay/refund?corderid="+id+"&companyid=1&sign=1&refund_fee="+refund_fee_id;
					$.ajax({  
						   type: 'GET',  
						   url: refundurl,
						   dataType: 'json',
						   success: function(result){  
								if (result.status==1) {
									alert("${internationalConfig.退款成功}");
									$('#mydialog').dialog("close");
								} else {
									alert("${internationalConfig.退款成功},${internationalConfig.原因}:"+result.errormsg);
								}
						   }  ,
						   error: function(result){  
							   alert(json2str(result));
							   if (result.status==1) {
									alert("${internationalConfig.退款成功}");
									$('#mydialog').dialog("close");
								} else {
									alert("${internationalConfig.退款失败},${internationalConfig.原因}:"+result.errormsg);
								}
							  
						   }  
						}); 
				
				}
			} ]
		});
	}
	
	  function json2str(o) {
		               var arr = [];
		               var fmt = function(s) {
		                   if (typeof s == 'object' && s != null) return json2str(s);
		                   return /^(string|number)$/.test(typeof s) ? "'" + s + "'" : s;
		                }
		               for (var i in o) arr.push("'" + i + "':" + fmt(o[i]));
		               return '{' + arr.join(',') + '}';
		            }

	function editClose(id,userid) {
		$.messager
				.confirm(
						'${internationalConfig.确认}',
						'${internationalConfig.确定关闭此订单}',
						function(r) {
							if (r) {
								$
										.ajax({
											type : 'GET',
											url : '${pageContext.request.contextPath}/consume/close_service.json?orderid='
													+ id+'&userid='+userid+'&type='+$("select[name=type]").val(),
											dataType : 'html',
											success : function(result) {
												result = $.parseJSON(result);
												if (result.code == 0) {
													parent.$.messager.alert('${internationalConfig.成功}', result.msg, 'success');
													dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
												} else {
													parent.$.messager.alert(
															'${internationalConfig.错误}', result.msg,
															'error');
												}
											}
										});
							}
						});
	}
</script>
</body>
</html>
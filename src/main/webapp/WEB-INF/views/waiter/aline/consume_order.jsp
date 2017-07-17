<%@page import="com.letv.boss.LetvEnv"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
	<title>${internationalConfig.消费订单查询}</title>
	<%@ include file="/WEB-INF/views/inc/head.inc"%>
	<script type="text/javascript">
		/* <m:auth uri="/consume/open">
		 $.canOpen = true;
		</m:auth> */
		<m:auth uri="/consume/close">
		$.canClose = true;
		</m:auth>
		<m:auth uri="/consume/refund.do">
		$.canRefund = true;
		</m:auth>
	</script>
</head>
<body>
<style>
	.datagrid-row-over .tips{display: block;color:#00438a}
	.datagrid-row-selected .tips{color:#00438a;}
	.tips_par{position: absolute;width: 0;height:0;}
	.tips{position: absolute;width: 180px;padding: 10px 20px;border:1px solid #ccc;background: #fff7d8;border-radius: 5px;top:-30px;left:-237px;box-shadow: 0 0 3px #ccc;display: none;}
</style>
<div class="easyui-layout" data-options="fit : true,border : false">
	<div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'">
		<form id="searchForm">
			<table class="table-td-four"
				   style="width:100%;">
				<tr>
					<td>
						<select id="userInfo" class="span2 js_key" style="width:140px;margin-right:5px;">
							<option value="uid" <c:if test="${param.userInfo=='uid'}">selected</c:if>>${internationalConfig.用户ID}</option>
							<option value="email" <c:if test="${param.userInfo=='email'}">selected</c:if>>${internationalConfig.邮箱}</option>
							<option value="mobile" <c:if test="${param.userInfo=='mobile'}">selected</c:if>>${internationalConfig.电话号码}</option>
						</select>
						<input id="userid" class="span2 js_value" value="${param.uid}"/>
					</td>
					<td style="width:20%;">${internationalConfig.消费订单号}：<input id="productid" name="orderid" class="span2" /></td>
					<%-- <td style="width:20%;">${internationalConfig.设备标识}：<input id="aid2" name="aid2" class="span2" ></input></td> --%>
					<td style="width:20%;">${internationalConfig.订单状态}：
						<select name="status" class="span2">
							<option value="-1">${internationalConfig.全部}</option>
							<option value="0">${internationalConfig.未开通}</option>
							<option value="1">${internationalConfig.已开通}</option>
							<option value="2">${internationalConfig.已关闭}</option>
						</select>
					</td>
					<td></td>
				</tr>
				<tr>
					<td style="width:20%;">${internationalConfig.商品类型}:
						<select name="productType" class="span2">
							<option value="-1">${internationalConfig.全部}</option>
							<option value="100">${internationalConfig.会员}</option>
							<option value="200">${internationalConfig.直播劵}</option>
							<option value="4">${internationalConfig.直播场次}</option>
							<option value="3">${internationalConfig.视频}</option>
							<option value="1">${internationalConfig.专辑}</option>
							<option value="2">${internationalConfig.轮播台}</option>
							<%--<option value="5">${internationalConfig.赛事}</option> --%>
						</select>
					</td>
					<td style="width:20%;">${internationalConfig.获取方式}:
						<select name="payChannel" class="span2">
							<option value="">${internationalConfig.全部}</option>
							<option value="1">${internationalConfig.用户购买}</option>
							<option value="0">${internationalConfig.机卡领取}</option>
							<option value="-1">${internationalConfig.会员兑换码}</option>
							<option value="-2">${internationalConfig.合作渠道}</option>
							<option value="-3">${internationalConfig.观影券}</option>
							<option value="-4">${internationalConfig.直播券兑换码}</option>
							<option value="-5">${internationalConfig.活动赠送}</option>
							<option value="-6">${internationalConfig.直转点赠送}</option>
							<option value="-7">${internationalConfig.机卡会员兑换码}</option>
							<option value="-8">${internationalConfig.消费查询设备赠送}</option>
							<option value="-100">${internationalConfig.消费查询2B合作通道}</option>
							<option value="-101">${internationalConfig.大屏商业平台}</option>
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

<script type="text/javascript">
    var userId = $('#userid').val();
    var userInfo =$("#userInfo").val();
    var inSearchData = $.serializeObject($('#searchForm'));
    inSearchData[userInfo] = userId;
	var dataGrid;
	$(function() {


		dataGrid = $('#dataGrid').datagrid({
			url : '/consume/dataGrid',
			queryParams:inSearchData,
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
			columns : [ [
				{
					field : 'userId',
					title : '${internationalConfig.用户ID}',
					width : 100,
					sortable : true
				}, {
					field : 'orderid',
					title : '${internationalConfig.消费订单号}',
					sortable : true
				}, {
					field : 'orderName',
					title : '${internationalConfig.商品名称}',
					width : 100,
					sortable : true
				}, {
					field : 'productDuration',
					title : '${internationalConfig.商品周期}',
					width : 50,
					sortable : true,
					formatter : function(value, row, index) {
						if(row.productDurationType==1){
							return value+"${internationalConfig.年}";
						}
						if(row.productDurationType==2){
							return value+"${internationalConfig.月}";
						}
						if(row.productDurationType==5){
							return value+"${internationalConfig.日}";
						}
					}
				},
				{
					field : 'productType',
					title : '${internationalConfig.商品类型}',
					width : 50,
					sortable : true,
					formatter:function(value){
						if(value==1){
							return "${internationalConfig.专辑}";
						}else if(value==2){
							return "${internationalConfig.轮播台}";
						}else if(value==3){
							return "${internationalConfig.视频}";
						}else if(value==4){
							return "${internationalConfig.直播场次}";
						}else if(value==5){
							return "${internationalConfig.赛事}";
						}else if(value==100){
							return "${internationalConfig.会员}";
						}else if(value==200){
							return "${internationalConfig.直播劵}";
						}
					}
				},
				{
					field : 'payChannel',
					title : '${internationalConfig.获取方式}',
					width : 100,
					sortable : true,
					formatter : function(value, row) {
						if(row.status == "0"){
							return "";
						}else{
							if(value == "-1"){
								return "${internationalConfig.会员兑换码}";
							}else if(value == "0"){
								return "${internationalConfig.机卡领取}";
							}else if(value == "-2"){
								return "${internationalConfig.合作渠道}";
							}else if(value == "-3"){
								return "${internationalConfig.观影券}";
							}else if(value == "-4"){
								return "${internationalConfig.直播券兑换码}";
							}else if(value == "-5"){
								return "${internationalConfig.活动赠送}";
							}else if(value == "-6"){
								return "${internationalConfig.直转点赠送}";
							}else if(value == "-7"){
								return "${internationalConfig.机卡会员兑换码}";
							}else if(value == "-8"){
								return "${internationalConfig.消费查询设备赠送}";
							}else if(value == "-100"){
                                return "${internationalConfig.消费查询2B合作通道}";
							}else if(value == "-101"){
                                return "${internationalConfig.大屏商业平台}";
							}else if(value>0){
                                <c:if test="${currentCountry==86}">
                                  return row.payChannelName;
                                </c:if>
								return "${internationalConfig.用户购买}";
							}
						}
					}
				},
				{
					field : 'payPrice',
					title : '${internationalConfig.支付价格}',
					width : 50,
					sortable : true
				}, {
					field : 'createTime',
					title : '${internationalConfig.下单时间}',
					width : 100,
					sortable : true
				},{
					field : 'startTime',
					title : '${internationalConfig.服务开始时间}',
					width : 100,
					sortable : true
				}, {
					field : 'endTime',
					title : '${internationalConfig.服务结束时间}',
					width : 100,
					sortable : true
				}, {
					field : 'isRefund',
					title : '${internationalConfig.退款状态}',
					width : 50,
					sortable : true,
					formatter: function(value){
						if(value==0){
                            return "${internationalConfig.未退款}";
						}
						if(value==1){
							return "${internationalConfig.已退款}";
						}
					}
				}, {
					field : 'isRenew',
					title : '${internationalConfig.订单类型}',
					sortable: true,
					formatter: function(value){
						var map = {0:"${internationalConfig.普通}", 1:"${internationalConfig.订阅}", 2:"${internationalConfig.自扣费}"};
						return map[value];
					}
				},{
					field : 'status',
					title : '${internationalConfig.订单状态}',
					width : 50,
					sortable : true,
					formatter : function(value) {
						var str = '';
						if ("0" == value) {
							str = "${internationalConfig.未开通}";
						} else if ("1" == value) {
							str = "${internationalConfig.已开通}";
						} else if("2" == value) {
							str = "${internationalConfig.已关闭}";
						}
						return str;
					}
				}, {
					field : 'action',
					title : '${internationalConfig.操作}',
					width : 100,
					formatter : function(value, row, index) {
						var str = '';
						str += $.formatString('<img onclick="detail(\'{0}\',\'{1}\',\'{2}\',\'{3}\');" src="{4}" title="${internationalConfig.详情}"/>', row.orderid,row.userId,row.productType,row.status,'/static/style/images/extjs_icons/bug/bug_link.png');
						str += '&nbsp;&nbsp;';
						if($.canRefund && row.payChannel>0 && row.status!="0" && row.payChannel!='40' && row.payChannel!='44' && row.payChannel!='58'){
							str += $.formatString(
									'<img onclick="editFun(\'{0}\', \'{1}\',\'{2}\');" src="{3}" title="${internationalConfig.退款}"/>',row.orderid,row.userId,row.payPrice,'/static/style/images/extjs_icons/bug/bug_delete.png');
						}else if(row.payChannel>0 && row.status!="0" && (row.payChannel=='40' || row.payChannel=='44' || row.payChannel=='58')){
							str += $.formatString(
									'<div class="tips_par"><div class="tips">{0}${internationalConfig.不支持退款请走线下退款}</div></div>',row.payChannelName);
						}else if(row.payChannel<=0 && row.status!="0"){
							str += $.formatString(
									'<div class="tips_par"><div class="tips">${internationalConfig.非支付通道不支持退款}</div></div>');
						}
						str += '&nbsp;&nbsp;';
						if ($.canClose && ((row.status == 1)) && row.payChannel!='0') {
							str += $.formatString('<img onclick="editClose(\'{0}\',\'{1}\',\'{2}\');" src="{3}" title="${internationalConfig.关闭}"/>', row.orderid,row.userId,row.isRenew,'/static/style/images/extjs_icons/cancel.png');
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


	function searchFun() {
		var userId = $('#userid').val();
		var userInfo =$("#userInfo").val();
		var data = $.serializeObject($('#searchForm'));
		data[userInfo] = userId;
		var text = "";
		if(userInfo=="uid"){
			text = "${internationalConfig.用户ID不能为空}";
		}else if(userInfo=="email"){
			text = "${internationalConfig.邮箱不能为空}";
		}else if(userInfo=="mobile"){
			text = "${internationalConfig.电话号不能为空}";
		}
		if(userId==''||userId==undefined){
			$.messager.alert('${internationalConfig.错误}', text, 'error');
			return;
		}
		dataGrid.datagrid('load', data);
	}
	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}
	function detail(orderid,userid,productType,status){//详情跳转
		parent.iframeTab.init({url:'/consume/consumeOrderInfo?userId=' + userid+'&orderid='+orderid+'&productType='+productType+'&status='+status,text:'${internationalConfig.消费订单详情}'});
	}
	function editOpen(orderid,userid,payPrice,payChannel,payChannelDesc,payOrderid) {
		if(payChannelDesc == "undefined" || payChannelDesc == undefined){
			payChannelDesc='';
		}
 		$.messager.confirm('${internationalConfig.确认}', '${internationalConfig.确定开通此订单的服务}', function(r) {
			if(r) {
				$.ajax({
					   type: 'GET',
					   url: '/consume/open?orderid='+orderid+'&userId='+userid+'&payPrice='+payPrice+'&payChannel='+payChannel+'&payChannelDesc='+payChannelDesc+'&payOrderid='+payOrderid,
					   dataType: 'html',
					   success: function(result){
						    result = $.parseJSON(result);
							if (result.code == 0) {
								parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.开通订单成功}', 'success');
								dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
							} else {
								parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.开通订单失败}', 'error');
							}
					   }
					});
			}
		});
	}

	function editClose(orderid,userid,isRenew) {
		parent.$.modalDialog({
			title : '${internationalConfig.关闭操作}',
			width : 600,
			height : 200,
			href : '/consume/close_order?orderid='+orderid+'&userid='+userid+'&isRenew='+isRenew,
			onClose:function(){
				this.parentNode.removeChild(this);
			},
			buttons : [ {
				text : '${internationalConfig.确定}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			}, {
				text : "${internationalConfig.取消}",
				handler : function() {
					parent.$.modalDialog.handler.dialog('close');
				}
			} ]
		});
	}

	function editFun(orderid,userId,payPrice) {
		parent.$.modalDialog({
			title : '${internationalConfig.退费操作}',
			width : 800,
			height : 400,
			href : '/consume/refund_order?orderid=' + orderid + "&userId=" + userId + "&payPrice=" + payPrice,
			onClose:function(){
				this.parentNode.removeChild(this);
			},
			buttons : [ {
				text : '${internationalConfig.退款}',
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

	function json2str(o) {
        var arr = [];
        var fmt = function(s) {
            if (typeof s == 'object' && s != null) return json2str(s);
            return /^(string|number)$/.test(typeof s) ? "'" + s + "'" : s;
         }
        for (var i in o) arr.push("'" + i + "':" + fmt(o[i]));
        return '{' + arr.join(',') + '}';
     }

</script>
</body>
</html>
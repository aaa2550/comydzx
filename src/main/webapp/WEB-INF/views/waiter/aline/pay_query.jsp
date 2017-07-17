<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>CorderId${internationalConfig.用户支付信息查询}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
<m:auth uri="/pay_query/refund.json">
	$.canRefund = true;
</m:auth>
</script>

<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '/pay_query/data_grid.json',
							queryParams:$.serializeObject($('#searchForm')),
							fit : true,
							fitColumns : true,
							border : false,
							pagination : true,
							idField : 'id',
							pageSize : 50,
							pageList : [ 10, 20, 30, 40, 50 ],
							checkOnSelect : false,
							selectOnCheck : false,
							sortName : 'paymentdate',
							sortOrder : 'desc',
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
										field : 'userid',
										title : '${internationalConfig.用户ID}',
										width : 120,
										sortable : false,
									},
									{
										field : 'productname',
										title : '${internationalConfig.购买商品名}',
										width : 180,
										sortable : false
									},
									{
										field : 'ordernumber',
										title : '${internationalConfig.支付流水号}',
										width : 240,
										sortable : false
									},
									{
										field : 'corderid',
										title : '${internationalConfig.商户订单号}',
										width : 180,
										sortable : false
									},
									{
										field : 'price',
										title : '${internationalConfig.支付金额}',
										width : 150,
										sortable : false
									},
									{
										field : 'paymentdate',
										title : '${internationalConfig.支付时间}',
										width : 180,
										sortable : true
									},
									{
										field : 'submitdate',
										title : '${internationalConfig.提交订单时间}',
										width : 180,
										sortable : true
									},
									{
										field : 'ip',
										title : '${internationalConfig.用户} IP',
										width : 180,
										sortable : false
									},
									{
										field : 'transeq',
										title : '${internationalConfig.第三方交易流水号}',
										width : 180,
										sortable : false
									},
									{
										field : 'deptid',
										title : '${internationalConfig.支付终端}',
										width : 150,
										sortable : false,
										formatter : function(value,row) {
											if(row.dataSource==2){
												return value;
											}else{
												var str = value;
												if ("112" == value) {
													str = "PC";
												} else if ("130" == value) {
													str = "MOBILE";
												}  else if ("111" == value) {
													str = "TV";
												} else if ("113" == value) {
													str = "${internationalConfig.M站}";
												} else if ("118" == value) {
													str = "LEUI";
												} else if ("119" == value) {
													str = "LELIVE";
												} else if ("120" == value) {
													str = "LEPRO";
												}
												return str;
											}
										}
											
									},{
										field : 'businessName',
										title : '${internationalConfig.业务线名称}',
										width : 180,
										sortable : false
									},
									/*{
										field : 'paytype',
										title : '${internationalConfig.支付方式}',
										width : 150,
										sortable : false,
										formatter : function(value,row) {
											if(row.dataSource==2){
												var channelId = row.channelId;
												if(channelId==2){
													return "财付通网关支付";
												}else if(channelId==4){
													return "支付宝WAP花呗支付";
												}else if(channelId==5){
													return "app花呗分期支付";
												}else if(channelId==6){
													return "支付宝网关支付";
												}else if(channelId==7){
													return "花呗分期支付";
												}else if(channelId==8){
													return "支付宝APP支付";
												}else if(channelId==13){
													return "支付宝WAP支付";
												}else if(channelId==24){
													return "微信APP支付";
												}else if(channelId==25){
													return "微信WAP支付";
												}else if(channelId==26){
													return "微信NATIVE支付";
												}else if(channelId==28){
													return "支付宝扫码支付";
												}else if(channelId==35){
													return "中行网关支付";
												}else if(channelId==40){
													return "IAP支付";
												}else if(channelId==61){
													return "易宝网关支付";
												}else if(channelId==71){
													return "小贷支付";
												}else if(channelId==92){
													return "易宝-快捷绑卡支付";
												}else if(channelId==93){
													return "易宝-信用卡快捷支付";
												}else if(channelId==95){
													return "易宝-储蓄卡快捷支付";
												}else if(channelId==100){
													return "cybersource支付";
												}else if(channelId==101){
													return "payU支付";
												}else if(channelId==102){
													return "paypal支付";
												}else if(channelId==106){
													return "翼支付pc支付";
												}
											}
											var str = '${internationalConfig.未知}';
											if ("6" == value || "3" == value) {
												str = "${internationalConfig.支付宝}";
											} else if ("5" == value) {
												str = "${internationalConfig.TV版支付宝}";
											}  else if ("50" == value) {
												str = "${internationalConfig.支付宝手机}";
											} else if ("32" == value
													|| "33" == value) {
												str = "${internationalConfig.乐点}";
											} else if ("7" == value) {
												str = "${internationalConfig.一键签约}";
											} else if ("8" == value) {
												str = "${internationalConfig.一键}";
											} else if ("9" == value) {
												str = "${internationalConfig.快钱}";
											} else if ("40" == value) {
												str = "IAP";
											} else if ("2" == value) {
												str = "${internationalConfig.财付通}";
											} else if ("51" == value) {
												if(row.chargetype == '1'){
													str = "${internationalConfig.充值码}";
												}else{										
													str = "${internationalConfig.兑换码}";
												}												
											}else if ("21" == value||"23" == value||"24" == value||"25" == value||"95"==value) {
												str = "${internationalConfig.微信支付}";
											}else if ("31" == value) {
												str = "${internationalConfig.联通话费支付}";
											}else if ("34" == value) {
												str = "${internationalConfig.手机号Payment}";
											}else if ("35" == value) {
												str = "${internationalConfig.电信话费支付}";
											}else if ("36" == value) {
												str = "${internationalConfig.付费400}";
											}else if ("13" == value) {
												str = "${internationalConfig.支付宝}";
											}else if("53" == value){
												str = "${internationalConfig.客服营销}";
											}else if("44" == value) {
												str = "${internationalConfig.商城支付}";
											} else if("46" == value){
												str = "TV华数支付";
											} else if("62" == value){
												str = "乐视网手机支付宝-新";
											}else if("61" == value){
												str = "乐视网支付宝-新";
											}else if("58" == value){
												str = "无需支付的通道";
											}else if("63" == value){
												str = "支付宝极简收银台-影业";
											}else if("52" == value){
												str = "红包余额支付";
											}else if("29" == value){
												str = "奇虎360手机助手支付";
											}else if("57" == value){
												str = "超级LIVE酷派版微信支付APP";
											}else if("28" == value){
												str = "电信翼比特支付";
											}else if("77" == value){
												str = "老版一键签约";
											}else if("45" == value){
												str = "领先版一键自动支付";
											}else if("15" == value){
												str = "领先版一键支付";
											}else if("18" == value){
												str = "光大银行-瞬时贷-乐视志新";
											}else if("19" == value){
												str = "光大银行-乐卡签约";
											}else if("30" == value){
												str = "移动手机话费支付";
											}else if("11" == value){
												str = "阿里TV盒子支付";
											}else if("38" == value){
												str = "凤凰网手机话费";
											}else if("43" == value){
												str = "Web手机支付-移动点播";
											}else if("1" == value){
												str = "支付宝快捷支付-乐视网";
											}else if("22" == value){
												str = "银联在线-乐视网";
											}else if("16" == value){
												str = "拉卡拉-乐视网";
											}else if("4" == value){
												str = "易保支付";
											}else if("10" == value){
												str = "一键支付解除绑定";
											}else if("12" == value){
												str = "一键支付-短信确认";
											}else if("17" == value){
												str = "光大银行-分期付款";
											}else if("60" == value){
												str = "乐视网安徽电信";
											}else if("26" == value){
												str = "拉卡拉扫码支付";
											}else if("27" == value){
												str = "拉卡拉账单支付";
											}else if("37" == value){
												str = "Web手机支付-WO商店";
											}else if("20" == value){
												str = "国广财付通-微信支付公共账号-Native方式";
											}else if("39" == value){
												str = "paypal签约支付";
											}else if("49" == value){
												str = "paypal一键支付";
											}else if("54" == value){
												str = "乐视手机用户中心微信支付APP";
											}else if("55" == value){
												str = "移动领先版微信支付APP";
											}else if("56" == value){
												str = "乐视手机超级LIVE微信支付APP";
											}else if("41" == value){
												str = "易宝信用卡签约支付";
											}else if("42" == value){
												str = "易宝信用卡一键支付";
											}else if("47" == value){
												str = "天猫直冲";
											}else if("90" == value){
												str = "乐视网微信native-新";
											}else if("93" == value){
												str = "乐视网微信签约";
											}else if("94" == value){
												str = "乐视网微信代扣";
											}else if("83" == value){
												str = "翼支付";
											}
											return str;
										}
										
									},*/
									{
										field : 'payName',
										title : '${internationalConfig.支付方式}',
										width : 150,
										sortable : false
									} ,
									{
										field : 'status',
										title : '${internationalConfig.支付状态}',
										width : 150,
										sortable : true,
										formatter : function(value) {
											var str = '';
											if ("-1" == value) {
												str = "${internationalConfig.未支付}";
											} else if ("0" == value) {
												str = "${internationalConfig.支付失败}";
											} else if ("1" == value) {
												str = "${internationalConfig.支付成功}";
											} else if ("3" == value) {
												str = "${internationalConfig.退款成功}";
											} else {
												str = "${internationalConfig.通知失败}";
											}
											return str;
										}
									},
									{
										field : 'action',
										title : '${internationalConfig.操作}',
										width : 120,
										formatter : function(value, row, index) {
											var str = '&nbsp;&nbsp;&nbsp;';
											if($.canRefund && row.status==1 && row.dataSource==2){
												str += $
												.formatString(
														'<img onclick="editFun(\'{0}\', \'{1}\',\'{2}\');" src="{3}" title="${internationalConfig.退款}"/>',
														row.lePayOrderNo,
														row.price,
														row.businessId,
														'/static/style/images/extjs_icons/bug/bug_delete.png');
											}else if ($.canRefund && row.validatePrice > 0
													&& (row.status == 1 || row.status == 2 || row.status == 3) && (row.paytype!=32 && row.paytype!=33 && row.paytype!=51)) {
												str += $
														.formatString(
																'<img onclick="editFun(\'{0}\', \'{1}\',\'{2}\',\'{3}\');" src="{4}" title="${internationalConfig.退款}"/>',
																row.corderid,
																row.validatePrice,
																'',
																row.companyid,
																'/static/style/images/extjs_icons/bug/bug_delete.png');
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
	Date.prototype.format = function(format) {
		if (!format) {
			format = "yyyy-MM-dd hh:mm:ss";
		}
		var o = {
			"M+" : this.getMonth() + 1, // month
			"d+" : this.getDate(), // day
			"h+" : this.getHours(), // hour
			"m+" : this.getMinutes(), // minute
			"s+" : this.getSeconds(), // second
			"q+" : Math.floor((this.getMonth() + 3) / 3), // quarter
			"S" : this.getMilliseconds()
		// millisecond
		};
		if (/(y+)/.test(format)) {
			format = format.replace(RegExp.$1, (this.getFullYear() + "")
					.substr(4 - RegExp.$1.length));
		}
		for ( var k in o) {
			if (new RegExp("(" + k + ")").test(format)) {
				format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k]
						: ("00" + o[k]).substr(("" + o[k]).length));
			}
		}
		return format;
	};
	//$('#win').window({    
	//    collapsible:false,    
	//    minimizable:false,    
	//   maximizable:false    
	//}); 
	function formatterdate(val, row) {
		var date = new Date(val);
		if (date = "Invalid Date") {
			return "";
		}
		return date.format("yyyy-MM-dd hh:mm:ss");
	}
	function searchFun() {
		var name = $('#userId').val();
		//if (name.length <= 0) {
		//$('#win').window('open'); 
		//alert('请输入完整的用户名！') ;
		//} else {
		dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
		//}
	}
	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}
	
	function editFun(corderid, validatePrice ,businessId,companyid) {
		/* if (corderid == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			corderid = rows[0].corderid;
		}
		
		if (validatePrice == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			validatePrice = rows[0].validatePrice;
		}
		
        if(businessId!=undefined){
        	var rows = dataGrid.datagrid('getSelections');
        	
        	validatePrice = rows[0].price;
		}
		if (businessId == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			businessId = rows[0] && rows[0].businessId || "";
		} */
		if(businessId == undefined){
			businessId='';
		}
		if(companyid == undefined){
			companyid = 0;
		}
		parent.$.modalDialog({
			title : '${internationalConfig.退费操作}',
			width : 600,
			height : 200,
			href : '/pay_query/refund_edit.json?corderid='
					+ corderid + "&validatePrice=" + validatePrice + "&businessId=" + businessId + "&companyid="+companyid,
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

</script>
</head>
<body  >
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'">
			<form id="searchForm">
				<table class="table-td-more">
					<tr>
						<td>${internationalConfig.用户ID}：<input id="userid" name="userid" value="${param.userId}"
							class="span2"/>
						</td>
						<td>${internationalConfig.商户订单号}：<input id="corderid" name="corderid"
							class="span2"/>
						</td>
						<td>${internationalConfig.支付状态}： <select name="paystaus" class="span2">
								<option value="2" selected>${internationalConfig.已支付}</option>
								<option value="1">${internationalConfig.未支付}</option>
						</select>
						</td>
						<td>${internationalConfig.支付流水号}：<input id="ordernumber" name="ordernumber"
							class="span2"/>
						</td>
						</tr>
						<tr>
						<td>${internationalConfig.第三方序列号}：<input id="transeq" name="transeq"
							class="span2"/>
						</td>
						<td>${internationalConfig.开始付费日期}：<input id="begin" name="beginDate"
							class="easyui-datebox" data-options="width:94,height:26"></input></td>
						<td>${internationalConfig.截止付费日期}：<input id="end" name="endDate"
							class="easyui-datebox" data-options="width:94,height:26"></input></td>
					    <td style='display:${  appMap["boss_country"]==86 ?"block":"none" }'>${internationalConfig.订单来源}：
					    	<select name="dataSource"  class="span2">
					    	<c:if test='${appMap["boss_country"]==86 }'>
					    	<option value="0" selected>${internationalConfig.老通道}</option>
					    	</c:if>
					    	<option value="${busIds}">${internationalConfig.新通道}</option>
						    </select>
						</td>
						<td></td>
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
			onclick="cleanFun();">${internationalConfig.清空条件}</a>
	</div>
	<!-- <div id="win" class="easyui-window" title="输入提示框" closed="true" 
	 collapsible="false" minimizable="false" maximizable="false" style="width:300px;height:100px;padding:5px;color: red;">  
	<font size="2">请输入完整的用户名! </font>  
    </div>  -->
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:if test="${not empty param.singlePage}">
	<%@ include file="/WEB-INF/views/inc/head.inc"%>
</c:if>
<script src="/static/lib/swfupload/swfupload.js" type="text/javascript" charset="utf-8"></script>
<%--<script type="text/javascript" src="/static/lib/uploadImgCommon.js?v=20150408.01" charset="utf-8"></script>--%>
<script src="/static/lib/json2.min.js"></script>
<%@ include file="/WEB-INF/views/inc/jstl.inc"%>
<style>
	input[type="text"], select{
		padding: 0px !important;
		height:20px !important;
	}
	#memberPriceInfoTR td:first-child div{
		margin:-2px 8px 1px 0px;
	}
	#memberPriceInfoTR td:first-child div span{
		font-weight:bold;
		margin:8px 81px 8px 0px;
	}
	.hb-table th,.hb-table td{padding:3px 8px;}
	.blockRow{display:table-row}
	.hiddenRow{display:none}
</style>
<script type="text/javascript">
    var beTrue = 0;
	var beTrueImg = 0;
	$(function() {
		parent.$.messager.progress('close');
		
		(function($){
			  $.fn.serializeJson=function(){ 
		 
			      var serializeObj={};  
			      var array=this.serializeArray();  
			      // var str=this.serialize(); 
			      $(array).each(function(){ // 遍历数组的每个元素 {name : xx , value : xxx} 
			              if(serializeObj[this.name]){ // 判断对象中是否已经存在 name，如果存在name 
			                    /* if($.isArray(serializeObj[this.name])){ 
			                           serializeObj[this.name].push(this.value); // 追加一个值 hobby : ['音乐','体育'] 
			                    }else{ 
			                            // 将元素变为 数组 ，hobby : ['音乐','体育'] 
			                            serializeObj[this.name]=[serializeObj[this.name],this.value]; 
			                    }  */
			                  serializeObj[this.name]+=","+this.value;
			              }else{ 
			                      serializeObj[this.name]=this.value; // 如果元素name不存在，添加一个属性 name:value 
			              } 
			      });
			      return serializeObj;
			  }
			})(jQuery)
		  $('#form').form({
			url : '/v2/product/vipPackage/save',
			onSubmit : function() {
                //自动续费未填续费价，将现售价设置为续费价
                if($('input[name="autoRenew"]').is(":checked")){
                    if($("input[name=renewingPrice]").val()==""){
                        $("input[name=renewingPrice]").val($("#now_price").val());
                    }
                } else {
					$("input[name=renewingPrice]").val('');
				}
				parent.$.messager.progress({
					title : '${internationalConfig.提示}',
					text : '${internationalConfig.数据处理中}....'
				});
				var isValid = $(this).form('validate');
				if (!isValid) {
					parent.$.messager.progress('close');
					return isValid;
				} else {
                    //提交前,去除三个默认checkbox的disabled属性，让后台能够得到这两个值
					$("#typeId").attr("disabled", false);
					$("#feature30").attr("disabled", false);
					$("#feature31").attr("disabled", false);
					checkAndSetPosters();
                    checkAndSetCustomFields();
                    if(beTrue==1||beTrueImg==1){
                        parent.$.messager.progress('close');
                        return false;
                    }else{
					    return validateMemberPrice();
                    }
				}
			},
			success : function(result) {
				parent.$.messager.progress('close');
				result = $.parseJSON(result);
				if (result.code == 0) {
                	parent.$.messager.alert('${internationalConfig.成功}', '${packageInfo==null?internationalConfig.添加成功:internationalConfig.编辑成功}', 'success');
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
					parent.$.modalDialog.handler.dialog('close');
				} else if(result.code == 2){
                    parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.套餐描述文字过长}', 'error');
                } else if(result.code == 1){
                    parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.该套餐已存在}', 'error');
                } else {
                    parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
                }
			}
		}); 
		
	});
	checkTerminals();
	checkAutoRenew();
	 function checkTerminals() {
		$.terminals = "${packageInfo.terminal}";
	
		$('.ter_checkbox').each(function(){
			if($.terminals.indexOf($(this).val())>-1){
				$(this).attr('checked','checked');
			}
		})
	}
	 function checkAutoRenew() {
			$.autoRenew = "${packageInfo.autoRenew}";
			if($.autoRenew==1){
				$('.auto_checkbox').attr('checked','checked');
			}
		}
	function checkVipInterest(){
		parent.$.modalDialog({
			title : '${internationalConfig.编辑套餐}',
			width : 780,
			height : 500,
			href : '/package/package_edit.json?packageId='
					+ id,
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
				text : "${internationalConfig.取消}",
				handler : function() {
					parent.$.modalDialog.handler.dialog('close');
				}
			} ]
		});
	}

	//增加自定义的表单验证规则
	$.extend($.fn.validatebox.defaults.rules, {
		number : {
			validator : function(value, param) {
				var reg = new RegExp("^[0-9]+(.[0-9]+)?$");
				return reg.test(value);
			},
			message : '${internationalConfig.请输入合法数字}'
		}
	});
	$.extend($.fn.validatebox.defaults.rules, {
		int : {
			validator : function(value, param) {
				var reg = new RegExp("^[0-9]+$");
				return reg.test(value);
			},
			message : '${internationalConfig.请输入合法整数}'
		}
	});
	$.extend($.fn.validatebox.defaults.rules, {
		biggerThan: { 
			validator: function(value, param){ 
				return value*1 >=$(param[0]).val()*1; 
			}, 
			message: '${internationalConfig.请输入大于现售价的数字}' 
		},
		lessThan: { 
			validator: function(value, param){ 
				var arr=param[0].split(',');
				for(var i=0;i<arr.length;i++){
					if(value*1<=0||$(arr[i]).val()*1<=value*1){
						return false;
					}
				}
				return true;
				
			}, 
			//message: '${internationalConfig.请输入小于现售价和原价的数字}'
			message: '${internationalConfig.会员折扣价格必须介于零和套餐价格之间}'
		},
		checkPackage: {
			validator: function (value, param) {
				var frm = param[0], groupname = param[1], checkNum = 0;
				$('input[name="' + groupname + '"]', document[frm]).each(function () { //查找表单中所有此名称的checkbox
					if (this.checked) checkNum++;
				});

				return checkNum > 0;
			},
			message: '${internationalConfig.请至少选择一个会员套餐分组}'
		},
		//终端必选
		checkbox: {
            validator: function (value, param) {

                var frm = param[0], groupname = param[1], checkNum = 0;
                $('input[name="' + groupname + '"]', document[frm]).each(function () { //查找表单中所有此名称的checkbox
                    if (this.checked) checkNum++;
                });

                return checkNum > 0;
            },
            message: '${internationalConfig.请选择至少一项所支持的终端}'
        },
		urlRequired: {
			validator: function(value, param){
        		return ($.trim(value)==''||$.trim($(param[0]).val())!='');
			},
			message: '${internationalConfig.需要上传海报图片}'
		}
	});

  
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post" name = "packageForm"
			action="/mealController/create">
			<table style="width: 100%" class="table table-form">
				<colgroup>
					<col width="90">
					<col width="100">
					<col width="80">
					<col width="*">
				</colgroup>
				
				<tr>
				<th>${internationalConfig.会员套餐名称}</th>
					<td colspan="3"><input type="text" name="packageName" value="${packageInfo.packageName}"/></td>
				</tr>
				
				<tr>
					<td colspan="4" style="border-top:none">
						<h5>01${internationalConfig.会员类型设置}</h5>
					</td>
				</tr>
				<tr>
				    <input type="hidden" name="id" value="${packageInfo.id}"/>
					<th><b style="color: red">*</b>${internationalConfig.会员名称}</th>
					<td><select id="typeId" name="typeId" >
							<c:forEach items="${vipPackageType}" var="packageType">
	                            <c:choose>
									<c:when test="${packageInfo.typeId == packageType.id}">
										<option value="${packageType.id}" selected="selected">${packageType.name}</option>
									</c:when>
									<c:otherwise>
										<option value="${packageType.id}">${packageType.name}</option>
									</c:otherwise>
								</c:choose>						
							</c:forEach>
					</select></td>
                    <c:choose>
                    <c:when test="${currentCountry==86||currentCountry==852}">
					<th>${internationalConfig.套餐类型}</th>
                    <td>
                        <select class="span2" name="packageCategory">
                            <option value="1" <c:if test="${packageInfo.packageCategory==1}">selected</c:if>>${internationalConfig.常规套餐}</option>
                            <option value="2" <c:if test="${packageInfo==null||packageInfo.packageCategory==2}">selected</c:if>>${internationalConfig.活动套餐}</option>
                        </select>
                    </td>
                    </c:when>
                    <c:otherwise>
                    <td colspan="2">&nbsp;</td>
                    </c:otherwise>
                    </c:choose>
				</tr>
				<!-- <tr >
					<th style="vertical-align: middle;text-align: right;border-top:none;"></th>
					<td style="border-top:none;"><input type="button" value="查询会员权益" onclick="checkVipInterest()" style="width: 100px; font-family: 'Microsoft YaHei'"></td>
				</tr>
				<tr style="border-top:1px dashed #ccc">
					<td colspan="4" style="border-top:none"></td>
				</tr> -->
				<%--<tr>
					<td colspan="4" style="border-top:none">
						<h5>02${internationalConfig.会员套餐分组配置}</h5>
					</td>
				</tr>
				<tr>
					<th><b style="color: red">*</b>${internationalConfig.会员套餐分组}</th>
					<td colspan="3">
						<c:forEach items="${packageGroups}" var="packageGroup">
							<input type="checkbox" id="packageGroup_${packageGroup.id}" name="packageGroupIds" value="${packageGroup.id}" class="easyui-validatebox" <c:if test="${m:IsContains(packageInfo.packageGroupIds, packageGroup.id)}">checked="checked"</c:if> validType="checkPackage['packageForm','packageGroupIds']">${packageGroup.groupName} &nbsp;&nbsp;
						</c:forEach>
					</td>
				</tr>--%>

				<tr>
					<td colspan="4" style="border-top:none">
						<h5>02${internationalConfig.套餐内容设置}</h5>
					</td>
				</tr>
				
				<tr>
					<th><b style="color: red">*</b>${internationalConfig.支持终端}</th>
					<td colspan="3">
						<input type="checkbox" name="terminal" value="141001" class="ter_checkbox span2 easyui-validatebox" validType="checkbox['packageForm','terminal']">Web&nbsp;&nbsp;
						<input type="checkbox" name="terminal" value="141002" class="ter_checkbox span2 easyui-validatebox">PC&nbsp;&nbsp;
						<input type="checkbox" name="terminal" value="141003" class="ter_checkbox span2 easyui-validatebox">${internationalConfig.安卓手机}&nbsp;&nbsp;
						<input type="checkbox" name="terminal" value="141004" class="ter_checkbox span2 easyui-validatebox">${internationalConfig.超级手机}&nbsp;&nbsp;
						<input type="checkbox" name="terminal" value="141005" class="ter_checkbox span2 easyui-validatebox">Pad&nbsp;&nbsp;
						<input type="checkbox" name="terminal" value="141006" class="ter_checkbox span2 easyui-validatebox">${internationalConfig.M站}&nbsp;&nbsp;
                        <input type="checkbox" name="terminal" value="141008" class="ter_checkbox span2 easyui-validatebox">Apple iPad&nbsp;&nbsp;
                        <input type="checkbox" name="terminal" value="141009" class="ter_checkbox span2 easyui-validatebox">Apple iPhone&nbsp;&nbsp;
						<input type="checkbox" name="terminal" value="141007" class="ter_checkbox span2 easyui-validatebox">${internationalConfig.超级TV}

						<%-- <c:forEach items="${terminals}" var="terminal"
							varStatus="varStatus">
							<td style="padding-right: 5px"><input type="checkbox"
								name="terminals" value="${terminal.terminalId}" />&nbsp${terminal.terminalName}
							</td>
						</c:forEach> --%>
						
					</td>
				</tr>
				<tr>
					<th><b style="color: red">*</b>${internationalConfig.套餐时长名称}</th>
					<td><select id="durationId" name="durationId" style="width:155px">
							<c:forEach items="${vipPackageDurationList}" var="vipPackageDuration">
	                            <c:choose>
									<c:when test="${packageInfo.durationId == vipPackageDuration.id}">
										<option value="${vipPackageDuration.id}" selected="selected">${vipPackageDuration.durationName}</option>
									</c:when>
									<c:otherwise>
										<option value="${vipPackageDuration.id}">${vipPackageDuration.durationName}</option>
									</c:otherwise>
								</c:choose>						
							</c:forEach>
					</select> <span id="message" style="color: red;font-size: 12px"></span></td>
					
					<th><input class="auto_checkbox" type="checkbox" name="autoRenew" value="1" class="span2">${internationalConfig.是否自动续费}</th>
					<th class=""><input type="text" name="autoRenewPeriod" class="span2 easyui-validatebox times"  validType="number" value="${packageInfo.autoRenewPeriod}">${internationalConfig.期数}
						<div>(${internationalConfig.零代表不限制期数})</div>
					</th>
					
				</tr>
				
				<tr>
					<th>IPHONE_PRODUCT_ID</th>
					<td><input type="text" name="appId" value="${appleyKey.appId}"/></td>
					<th>IPAD_PRODUCT_ID</th>
					<td><input type="text" name="ipadId" value="${appleyKey.ipadId}"/></td>
				</tr>
				<tr>
					<th>GOOGLE_PRODUCT_ID</th>
					<td colspan="3"><input type="text" name="googleProductId" value="${appleyKey.googleProductId}"/></td>
				</tr>
				<tr>
					<th><b style="color: red">*</b>${internationalConfig.现售价}</th>
					<td>
					<input type="text" id="now_price" name="price" value="${packageInfo.price}" class="easyui-validatebox easyui-numberbox" precision="2" data-options="required:true,validate:'digits',min:0.01,precision:2,validType:'number'"/></td>
					<th class="renewingPrice"><b style="color: red">*</b>${internationalConfig.续费价}</th>
					<td class="renewingPrice"><input type="text" id="renewingPrice" name="renewingPrice" value="${packageInfo.renewingPrice}" class="span2 easyui-validatebox easyui-numberbox" data-options="min:0.01,precision:2"/></td>
					<%--<th><b style="color: red">*</b>${internationalConfig.原价}</th>
					<td><input type="text" id="ori_price" name="originalPrice" validType="biggerThan['#now_price']" value="${packageInfo.originalPrice}"
						class="easyui-validatebox easyui-numberbox" data-options="required:true,validate:'digits',min:0,precision:2" type="number"/></td>--%>
				</tr>
				<c:set var="vipDiscountPriceInfo" value="${packageInfo.vipDiscountPriceInfoObject}"/>
				<tr id="memberPriceInfoTR">
					<td colspan="4">
						<div>
							<span>${internationalConfig.会员价设置}</span>
							<span>
								<input type="button" class="shortcut-item boss-btn" value="${internationalConfig.新增会员价}" onclick="addMemberPrice()">
							</span>
						</div>
						<table id="memberPriceInfoTable" style="width:100%;">
								
						<c:if test="${vipDiscountPriceInfo!= null && vipDiscountPriceInfo.getClass().name=='com.alibaba.fastjson.JSONArray'}">
						<c:forEach items="${vipDiscountPriceInfo}" var="item" varStatus="status">
							<tr>
								<td>${internationalConfig.依赖会员}</td>
								<td><select id="discountVipId${status.count}" validType="checkRequired" style="width:180px;">
									<c:forEach items="${vipPackageType}" var="pt">
										<option value="${pt.id}" <c:if test="${pt.id==item.vipId}">selected</c:if>>
											${pt.name}
										</option>
									</c:forEach>
								</select>
								</td>
								<td>${internationalConfig.会员价格}</td>
								<td class="xf_before">
									<input id="discountPrice${status.count}" type="text" style="width:100px;" value="${item.price}" class="easyui-validatebox easyui-numberbox" data-options="required:true,validate:'digits',min:0.01,precision:2,validType:'lessThan[\'#now_price\']'">
								</td>
                                <c:if test="${item.renewingPrice!= null}">
								<td class='xf_input'>${internationalConfig.会员续费价}</td>
								<td class='xf_input'>
									<input id="renewingPrice${status.count}" type="text" style="width:100px;" value="${item.renewingPrice}" class="easyui-validatebox easyui-numberbox" data-options="min:0.01,precision:2">
								</td>
                                </c:if>
								<td><img onclick="delmemberPrice(this);" src="/static/style/images/extjs_icons/cancel.png" title="${internationalConfig.删除}"></td>
							</tr>
							<c:set var="nextIndex" value="${status.count}"/>
						</c:forEach>
						</c:if>
						</table>
						<input type="hidden" id="vipDiscountPriceInfo" name="vipDiscountPriceInfo">
					</td>
				</tr>
				<tr>

					<th>${internationalConfig.图片1}：</th>
					<td ><input type="text" id="common_pic" class="easyui-validatebox" data-options="required:true" name="pic" value="${packageInfo.pic}"/></td>
					<td>
						<input class="buttoncenter" type="button" value="${internationalConfig.上传文件}" id="common_upload_btn" />
					</td>
					<td>${internationalConfig.图片尺寸限制为414_233}</td>
		            <td><div id="common_preview" name="img-mobile" ><c:if test="${not empty eplPackage.mobileImg}"><a href="${eplPackage.mobileImg}" target="_blank">${internationalConfig.查看图片}</a></c:if></div></td>
				</tr>
				<tr>

					<th>${internationalConfig.图片2}：</th>
					<td ><input type="text" id="common_pic2" class="easyui-validatebox" data-options="required:true" name="pic2" value="${packageInfo.pic2}"/></td>
					<td>
						<input class="buttoncenter" type="button" value="${internationalConfig.上传文件}" id="common_upload_btn2" />
					</td>
					<td>${internationalConfig.图片尺寸限制为100_100}</td>
					<td><div id="common_preview2" name="img-mobile" ><c:if test="${not empty eplPackage.mobileImg}"><a href="${eplPackage.mobileImg}" target="_blank">${internationalConfig.查看图片}</a></c:if></div></td>
				</tr>
				<tr>

					<th>${internationalConfig.图片3}：</th>
					<td ><input type="text" id="common_pic3" class="easyui-validatebox" data-options="required:true" name="pic3" value="${packageInfo.pic3}"/></td>
					<td>
						<input class="buttoncenter" type="button" value="${internationalConfig.上传文件}" id="common_upload_btn3" />
					</td>
					<td>${internationalConfig.图片尺寸限制为800_800}</td>
					<td><div id="common_preview3" name="img-mobile" ><c:if test="${not empty eplPackage.mobileImg}"><a href="${eplPackage.mobileImg}" target="_blank">${internationalConfig.查看图片}</a></c:if></div></td>
				</tr>
				
				<tr>
					<th><b style="color: red">*</b>${internationalConfig.套餐状态}</th>
					<td><select name="status" style="width:155px">
					        <c:choose>
								<c:when test="${packageInfo.status == 1}">
									<option value="1" selected="selected">${internationalConfig.未发布}</option>
									<option value="3">${internationalConfig.已发布}</option>
								</c:when>
								<c:when test="${packageInfo.status == 3}">
									<option value="1">${internationalConfig.未发布}</option>
									<option value="3" selected="selected">${internationalConfig.已发布}</option>
								</c:when>
								<c:otherwise>
									<option value="3" selected="selected">${internationalConfig.已发布}</option>
									<option value="1">${internationalConfig.未发布}</option>
								</c:otherwise>
							</c:choose>
						</select></td>
					<th><c:if test="${currentCountry==852}"><b style="color: red">*</b>${internationalConfig.排序}</c:if></th>
					<td>
						<c:choose><c:when test="${currentCountry==852}">
						<input type="text" name="weight" value="${packageInfo.weight}"
							   class="easyui-validatebox" data-options="required:true,validate:'digits'" onkeyup="this.value=this.value.replace(/\D/g,'')"
							   onafterpaste="this.value=this.value.replace(/\D/g,'')" type="number"/>
						</c:when><c:otherwise><input type="hidden" name="weight" value="${packageInfo.weight}"></c:otherwise></c:choose>
					</td>
				</tr>
				
				<tr>
					<th>${internationalConfig.套餐描述}：</th>
					<td colspan="3"><textarea name="ext" class="txt-middle">${packageInfo.ext}</textarea></td>
				</tr>

                <c:set var="customFields" value="${packageInfo.customFieldsObject}"/>
                <tr>
                    <th>${internationalConfig.套餐自定义字段}</th>
                    <td><input type="button" class="shortcut-item boss-btn" value="${internationalConfig.增加}" onclick="upplementaryField()"></td>
                </tr>
                <tr style="border-top:0">
                    <td></td>
                    <td colspan="3">
                        <table id="upplementary" class="hb-table">
                            <tr style="border-width:0;">
                                <th width="50">${internationalConfig.序号}</th>
                                <th width="100">${internationalConfig.字段定义}</th>
                                <th width="100">${internationalConfig.字段信息}</th>
                                <th></th>
                            </tr>
                            <c:if test="${customFields!= null && customFields.getClass().name=='com.alibaba.fastjson.JSONArray'}">
                                <c:forEach items="${customFields}" var="item" varStatus="status">
                                    <tr style="border-width:0;">
                                        <td width="50"></td>
                                        <td>
                                            <input  name="jsonKey" type="text" value="${item.jsonKey}">
                                        </td>
                                        <td>
                                            <input name="jsonValue" type="text" value="${item.jsonValue}">
                                        </td>
                                        <td><img onclick="delField(this);" src="/static/style/images/extjs_icons/cancel.png" title="${internationalConfig.删除}"></td>
                                    </tr>
                                </c:forEach>
                            </c:if>
                            <c:if test="${customFields== null}">
                                <tr style="border-width:0;">
                                    <td width="50">1</td>
                                    <td>
                                        <input  name="jsonKey" type="text">
                                    </td>
                                    <td>
                                        <input name="jsonValue" type="text">
                                    </td>
                                    <td><img onclick="delField(this);" src="/static/style/images/extjs_icons/cancel.png" title="${internationalConfig.删除}"></td>
                                </tr>
                            </c:if>
                        </table>
                        <input type="hidden" id="customFields" name="customFields" value="${packageInfo.customFields}"/>
                    </td>
                </tr>

				<tr>

					<th valign="top" style="vertical-align:top">${internationalConfig.套餐海报}：</th>
					<td valign="top" style="vertical-align:top">
						<div class="l-btn-left"><input class="shortcut-item boss-btn" type="button" value="${internationalConfig.增加}" id="add-pic" />
						</div>
					</td>
					<td align="left">
						<input type="hidden" id="posters" name="posters" value="${packageInfo.posters}"/>
					</div></td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr style="border-width:0;">
					<td></td>
					<td colspan="3">
						<table class="hb-table">
							<tr style="border-width:0;">
								<th>${internationalConfig.序号}</th>
								<th>${internationalConfig.海报名称}</th>
								<th colspan="2">${internationalConfig.图片链接}(${internationalConfig.JPG格式500K以下})</th>
							</tr>
							<c:set var="posters" value="${packageInfo.postersArray}"/>
							<c:set var="postersCount" value="${0}"/>
							<c:forEach items="${posters}" var="poster">
								<c:set var="postersCount" value="${postersCount + 1}"/>
								<tr style="border-width:0" class="blockRow">
									<td>${postersCount}</td>
									<td><input type="text" name="posterName${postersCount}" id="posterName${postersCount}" value="${fn:replace(poster.name,'\"','&quot;')}" class="easyui-validatebox" data-options="validType:'urlRequired[\'#posterUrl${postersCount}\']'" /></td>
									<td><input type="text" name="posterUrl${postersCount}" id="posterUrl${postersCount}" value="${poster.url}" class="easyui-validatebox" data-options="validType:'url'"></td>
									<td nowrap="nowrap"><input class="buttoncenter" type="button" value="${internationalConfig.上传文件}" id="poster_upload_btn${postersCount}">
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        <img class="remove-poster" src="/static/style/images/extjs_icons/cancel.png" title="${internationalConfig.删除}">
                                    </td>
								</tr>
							</c:forEach>
							<c:set var="maxPosterCount" value="${10}"/>
							<c:forEach begin="${postersCount + 1}" end="${maxPosterCount}" step="1"><%-- 预先绘出能支持的最多列海报 --%>
								<c:set var="postersCount" value="${postersCount + 1}"/>
								<tr style="border-width:0;" class="hiddenRow">
									<td>${postersCount}</td>
									<td><input type="text" name="posterName${postersCount}" id="posterName${postersCount}" class="easyui-validatebox" data-options="validType:'urlRequired[\'#posterUrl${postersCount}\']'"></td>
									<td><input type="text" name="posterUrl${postersCount}" id="posterUrl${postersCount}" class="easyui-validatebox" data-options="validType:'url'"></td>
									<td nowrap="nowrap"><input class="buttoncenter" type="button" value="${internationalConfig.上传文件}" id="poster_upload_btn${postersCount}">
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        <img class="remove-poster" src="/static/style/images/extjs_icons/cancel.png" title="${internationalConfig.删除}">
                                    </td>
								</tr>
							</c:forEach>
						</table>
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>
<script>
	function newCommonUploadBtn(buttonId,inputId,previewId){
		new SWFUpload({
			button_placeholder_id: buttonId,
			flash_url: "/static/lib/swfupload/swfupload.swf?rt=" + Math.random(),
			upload_url: '/upload?cdn=sync',
			button_image_url: Boss.util.defaults.upload.button_image,
			button_cursor: SWFUpload.CURSOR.HAND,
			button_action: SWFUpload.BUTTON_ACTION.SELECT_FILE,
			file_size_limit: '8 MB',
			button_width: "61",
			button_height: "24",
			file_post_name: "myfile",
			file_types: "*.jpg;*.jpeg;*.png;*.bmp;*.gif",
			file_types_description: "All Image Files",
			button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
			upload_start_handler: function () {
			},
			upload_success_handler: function (file, response) {
				if (response.indexOf("http")!=0){
					alert("${internationalConfig.上传失败请稍后重试}");
					return;
				}
				if (previewId) {
					var HTML_VIEWS = '<a href=' + response + ' target="_blank">${internationalConfig.查看图片}</a>&nbsp;&nbsp;&nbsp;&nbsp;';
					$("#" + previewId).html(HTML_VIEWS);
				}
				$("#"+inputId).val(response);
			},
			file_queued_handler: function () {
				this.startUpload();
			},
			upload_error_handler: function (file, code, msg) {
				var message = '${internationalConfig.UploadFailed}' + code + ': ' + msg + ', ' + file.name;
				alert(message);
			}
		});
	}

	function initPosterButton(){
		for (var i = 1;i <= ${maxPosterCount}; i++)
			newCommonUploadBtn("poster_upload_btn"+i, "posterUrl"+i, null);
	}

(function(){
	var typeId = $("#typeId");
	if($("#now_price").val()!=""){
		typeId.attr("disabled","true");
	}

	var autoRenew = $('input[name="autoRenew"]')
	if(autoRenew.is(":checked")){
		$(".times").show();
		$(".renewingPrice").show();
	}else{
		$(".times").hide();
		$(".renewingPrice").hide();
	}
	if($('input[name="autoRenewPeriod"]').val()==""){
		$('input[name="autoRenewPeriod"]').val("0");
	}
	$('input[name="autoRenew"]').change(function(){
        var tabletr = $("#memberPriceInfoTable tr");
		if($(this).is(":checked")){
			$(".times").show();
			$(".renewingPrice").show();
            var i = 1;
            tabletr.each(function(){
            	var td1 = $("<td class='xf_input'/>");
				td1.html('<td class="xf_input">${internationalConfig.会员续费价}</td>');
				var td2 = $("<td class='xf_input'/>");
				var renewingInput = $($.formatString('<input id="renewingPrice{0}" style="width:100px" type="text" class="easyui-validatebox easyui-numberbox" data-options="min:0.01,precision:2">', i));
				$.parser.parse(td2.append(renewingInput));
                if($(this).find(".xf_input").length==0){
                    $(this).find(".xf_before").after(td1,td2);
                }
                i++;
            });
            //$("#memberPriceInfoTable").children().remove();
		}else{
			$(".times").hide();
			$(".renewingPrice").hide();
            tabletr.each(
                function(){$(".xf_input").remove();}
            )
            //$("#memberPriceInfoTable").children().remove();
		}
	});
	//图片1
	newCommonUploadBtn('common_upload_btn','common_pic','common_preview')
	//图片2
	newCommonUploadBtn('common_upload_btn2','common_pic2','common_preview2')
	//图片3
	newCommonUploadBtn('common_upload_btn3','common_pic3','common_preview3')
	//海报
	initPosterButton();
	if ($(".blockRow").length==0){
		var row = $(".hiddenRow:first");
		row.attr('class', 'blockRow');
	} else if ($(".blockRow").length==${maxPosterCount}){
		$("#add-pic").hide();
	}
	$("#add-pic").click(function(){
		var row = $(".hiddenRow:first");
		row.attr('class', 'blockRow');
		if ($(".blockRow").length==${maxPosterCount}){
			$("#add-pic").hide();
		}
	});
    $(".remove-poster").click(function(){
        var replaceWithNextRow=function(thisRow){
            var nextRow=thisRow.next();
            thisRow.find("input[name^='posterName']").val(nextRow.find("input[name^='posterName']").val());
            thisRow.find("input[name^='posterUrl']").val(nextRow.find("input[name^='posterUrl']").val());
        }
        var thisRow=$(this).closest("tr");
        replaceWithNextRow(thisRow);
        thisRow.nextUntil(".hiddenRow").each(function(){
            replaceWithNextRow($(this));
        });
        var lastBlockRow=$(".blockRow:last");
        lastBlockRow.attr('class', 'hiddenRow');
        lastBlockRow.find("input[type=text]").each(function () {
            $(this).val("");
        });
        $("#add-pic").show();
    });
	$("input[name^=posterUrl]").dblclick(function(){
		window.open($(this).val());
	})
})();
$(document).ready(function(){
});
var nextIndex=${nextIndex==null?0:nextIndex};
var packageTypes=[<c:forEach items="${vipPackageType}" var="packageType">{id:"${packageType.id}",name:"${fn:replace(packageType.name,'\"','\\\"')}"},</c:forEach>];
function addMemberPrice(){
	nextIndex=nextIndex+1;
	$("#memberPriceInfoTR").show();
	var td0 = $("<td/>");
	td0.text("${internationalConfig.依赖会员}");
	var td1 = $("<td/>");
	var select1 = $($.formatString("<select id=\"discountVipId{0}\" validType=\"checkRequired\" style='width:180px;'>", nextIndex));
	$.each(packageTypes, function(i,item){
		var option={value:item.id,text:item.name};
		select1.append($("<option>", option));
	})
	$.parser.parse(td1.append(select1));
	var td2 = $("<td/>");
	td2.text("${internationalConfig.会员价格}");
	var td3 = $("<td class='xf_before'/>");
	var priceInput = $($.formatString('<input id="discountPrice{0}" type="text" style="width:100px" class="easyui-validatebox easyui-numberbox" data-options="required:true,validate:\'digits\',min:0.01,precision:2,validType:\'lessThan[\\\'#now_price\\\']\'">', nextIndex));
	$.parser.parse(td3.append(priceInput));
	var td4 = "";
	var td5 = "";
	if($('input[name="autoRenew"]').is(":checked")){
		td4 = $("<td class='xf_input'/>");
        td4.text("${internationalConfig.会员续费价}");
        td5 = $("<td class='xf_input'/>");
		var renewingInput = $($.formatString('<input id="renewingPrice{0}" style="width:100px" type="text" class="easyui-validatebox easyui-numberbox" data-options="min:0.01,precision:2">', nextIndex));
		$.parser.parse(td5.append(renewingInput));
	}
    var td6 = $("<td/>");
	var img = $('<img style="width:16px;height:16px;" onclick="delmemberPrice(this);" src="/static/style/images/extjs_icons/cancel.png" title="${internationalConfig.删除}">');
	td6.append(img);
	var tr = $("<tr/>");
	tr.append(td0);
	tr.append(td1);
	tr.append(td2);
	tr.append(td3);
	tr.append(td4);
	tr.append(td5);
    tr.append(td6);
	var table = $("#memberPriceInfoTable");
	table.append(tr);
}
function delmemberPrice(img){
	var tr=$(img).closest("tr");
    tr.remove();
}
function upplementaryField(){
        nextIndex=nextIndex+1;
        var num = 1
        var length = $("#upplementary tr").length;
        if(length<11){
            if($("#upplementary tr:last td:first").html()!=undefined){
                num = parseInt($("#upplementary tr:last td:first").html())+1
            }
            var tr = $("<tr/>");
            tr.css("border-width","0");
            var td = '<td width="50">'+num+'</td><td><input name="jsonKey" type="text" value=""></td>'+
                    '<td><input name="jsonValue" type="text" value=""></td>'+
                    '<td><img onclick="delField(this);" src="/static/style/images/extjs_icons/cancel.png" title="${internationalConfig.删除}"></td>';
            tr.append(td);
            var table = $("#upplementary");
            table.append(tr);
        }
}
var length = $("#upplementary tr").length;
for(var i=0;i<length;i++){
    $($($("#upplementary tr")[i]).find("td")[0]).html(i);
}
function delField(img){
        var tr=$(img).closest("tr");
        tr.remove();
        var length = $("#upplementary tr").length;
        for(var i=0;i<length;i++){
            $($($("#upplementary tr")[i]).find("td")[0]).html(i);
        }
}
function validateMemberPrice(){
	var vipDiscountPriceInfo = [];
	var discountVipIds = $("[id^='discountVipId']");
	for (var i=0;i<discountVipIds.length;i++) {
		var discountVipIdInput=$(discountVipIds[i]);
		var index=discountVipIdInput.attr("id").substring('discountVipId'.length);
		var discountVipId = discountVipIdInput.val();
		var mainPackageTypeId = $("#typeId").val();
		var discountPrice = parseFloat($("#discountPrice"+index).val());
		if (mainPackageTypeId == discountVipId) {
			parent.$.messager.progress('close');
			parent.$.messager.alert("${internationalConfig.错误}","${internationalConfig.依赖会员不得和主会员相同}", 'error');
			return false;
		} else if (discountPrice <= 0 || discountPrice >= parseFloat($("#now_price").val())) {
			parent.$.messager.progress('close');
			parent.$.messager.alert("${internationalConfig.错误}","${internationalConfig.会员折扣价格必须介于零和套餐价格之间}", 'error');
			return false;
		}
		for (var j in vipDiscountPriceInfo) {
			if (vipDiscountPriceInfo[j].vipId==discountVipId) {
				parent.$.messager.progress('close');
				parent.$.messager.alert("${internationalConfig.错误}","${internationalConfig.重复的会员价格}", 'error');
				return false;
			}
		}
		var vipDiscountPriceInfoItem = {vipId: parseInt(discountVipId),price: discountPrice};
		if($('input[name="autoRenew"]').is(":checked")){
			var renewingPrice = $("#renewingPrice"+index).val();
			vipDiscountPriceInfoItem.renewingPrice = renewingPrice === '' ? vipDiscountPriceInfoItem.price : parseFloat(renewingPrice);
		}
		vipDiscountPriceInfo.push(vipDiscountPriceInfoItem);
	}
	if (vipDiscountPriceInfo.length!=0) {
		$("#vipDiscountPriceInfo").val(JSON.stringify(vipDiscountPriceInfo));
	}
	return true;
}
function checkAndSetPosters(){
    var posters = [];
    for(var i=1;i<=${maxPosterCount};i++){
        var posterName = $.trim($("#posterName"+i).val());
        var posterUrl = $.trim($("#posterUrl"+i).val());
        if (posterName!=''||posterUrl!=''){
            posters.push({name:posterName,url:posterUrl});
        }
    }
    var jsontree = {};
    for(var i=0;i<posters.length;i++){
    	if(jsontree[posters[i].name]){
    		beTrueImg = 1;
			parent.$.messager.alert("${internationalConfig.错误}","${internationalConfig.套餐海报名称重复}", 'error',function(){beTrueImg=0});
			return false;
		}else {
			jsontree[posters[i].name] = posters[i].url;
		}
	}
    $("#posters").val(posters.length==0?'':JSON.stringify(posters));
}
    function checkAndSetCustomFields(){
        var customFields = [];
        var length = $("#upplementary tr").length;
        for(var i=1;i<=length-1;i++){
            var jsonKey = $.trim($($("#upplementary tr")[i]).find("[name='jsonKey']")[0].value);
            var jsonValue = $.trim($($("#upplementary tr")[i]).find("[name='jsonValue']")[0].value);
            if (jsonKey!=''||jsonValue!=''){
                customFields.push({jsonKey:jsonKey,jsonValue:jsonValue});
            }
        }
        for(var i = 0; i < customFields.length; i++){
            for(var j=i+1;j<customFields.length;j++) {
                if(customFields[i].jsonKey==customFields[j].jsonKey){
                    beTrue = 1;
                    parent.$.messager.alert("${internationalConfig.错误}","${internationalConfig.套餐自定义字段定义重复}", 'error',function(){beTrue=0});
                    return false;
                }
            }
        }

        $("#customFields").val(customFields.length==0?'':JSON.stringify(customFields));
    }
</script>
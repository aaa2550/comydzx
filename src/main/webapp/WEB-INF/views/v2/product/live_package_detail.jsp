<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:if test="${not empty param.singlePage}">
	<%@ include file="/WEB-INF/views/inc/head.inc"%>
</c:if>
<script src="/static/lib/swfupload/swfupload.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
	$(function() {
		//填写场次后，直播券张数为1且不可更改
		var extendId = $("input[name='extendId']");
		var counts =$("input[name='counts']");
		if(extendId.val()!=""){
			counts.val("1")
			counts.attr("readonly","readonly");
		}

		extendId.change(function(){
			if(extendId.val()!=""){
				counts.val("1")
				counts.attr("readonly","readonly");
			}else{
				counts.attr("readonly",false);
			}

		});
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
			})(jQuery);

        $('#form1').form({
            url : '/v2/product/livePackage/save',
            onSubmit : function() {
				parent.$.messager.progress({
					title : '${internationalConfig.提示}',
					text : '${internationalConfig.数据处理中}....'
				});
				var vipPrice=$('input[name=vipPrice]').val();
				$('#vipCategory').validatebox({novalidate:vipPrice==''});
				var isValid = $(this).form('validate');
				if (!isValid) {
					parent.$.messager.progress('close');
				}
				if(vipPrice!=''){
					var vipPriceSet = {vipPrice:parseFloat(vipPrice),vipCategory:parseInt($('#vipCategory').val())};
					var vipAppId = $('input[name=vipAppId]').val().trim();
					if (vipAppId != '') vipPriceSet.vipAppId = vipAppId;
					var vipIpadId = $('input[name=vipIpadId]').val().trim();
					if (vipIpadId != '') vipPriceSet.vipIpadId = vipIpadId;
					$('#vipPriceSet').val(JSON.stringify(vipPriceSet));
				} else {
					$('#vipPriceSet').val('{}');
				}
				return isValid;
            },
            success : function(result) {
                parent.$.messager.progress('close');
				result = $.parseJSON(result);
				if (result.code == 0) {
					if($('#id').val()==''){
						parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.添加成功}', 'success');
					}else{
						parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.编辑成功}', 'success');
					}
					parent.$.modalDialog2.handler.dialog('close');
				} else {
					parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
				}
            },
			error: function(result) {
            	parent.$.messager.progress('close');
				try {
					result = $.parseJSON(result);
					parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
				}catch(e){
					parent.$.messager.alert('${internationalConfig.错误}', result, 'error');
				}
			}
		});

		$('#vipCategory').validatebox({novalidate:$('input[name=vipPrice]').val()==''});
	});
	<%--checkTerminals();--%>
	<%--function checkTerminals() {--%>
		<%--value = '${livePackageInfo.payType}';--%>

		<%--$(".payType_check").each(function(){--%>
			<%--if(value.indexOf($(this).val())>-1){--%>
				<%--$(this).attr('checked',"checked");--%>
			<%--}--%>
		<%--})--%>

	<%--}--%>
	//增加自定义的表单验证规则
	$.extend($.fn.validatebox.defaults.rules, {
		number : {
			validator : function(value, param) {
				var reg = new RegExp("^[0-9]+(.[0-9]+)?$");
				return reg.test(value);
			},
			message : '${internationalConfig.请输入合法数字}'
		},
		longThan : {
			validator : function(value, param) {
				var matchId = $("#matchId").val();
				var itemId =$("#itemId").val();
				var judge = true;
				if(itemId.length=4){
					var six = value.substring(0,6);
					if((matchId+itemId)!=six){
						judge = false;
					}
				}
				return ((value.length>=param)&&judge);
			},
			message : '${internationalConfig.请输入合法的场次ID}'
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
	
	//终端设备联动
    $(function(){
    	$("#matchId").change(function(){
    		var matchId = $("#matchId").val();
    			$.ajax({
					url : "/v2/product/livePackage/get_match_info",
					data : {
						'pid' : matchId
					},
					success : function(result) {
						var directIndex = null;
						var optionsHtml = "";
						var optionhtml = '<option value="-1" selected="selected">${internationalConfig.全部}</option>';
                        optionsHtml += optionhtml;
						$("#itemId").empty();
						for (directIndex in result) {
							var directModel = result[directIndex];
							var optionHtml = '<option value="'+directModel.id+'">'
									+ directModel.description + '</option>';
							optionsHtml += optionHtml;
						}

						$("#itemId").html(optionsHtml);
					},
					dataType : "json",
					cache : false
				});
    	});
    });


 // 场次轮次事件
    $(function(){
    	$("#matchId,#itemId").change(function(){
    		var matchId = $("#matchId").val();
    		var itemId = $("#itemId").val();
    		//var type = $("#type").val();
    		var roundNumber = $("#round_number");
    		if(matchId == '09' && itemId == '001'){
    			$('#rounds').attr("disabled",false);
    			$('#play_number').attr("disabled",false);
    			roundNumber.show();
    		}else{
    			$('#rounds').attr("disabled",true);
    			$('#play_number').attr("disabled",true);
    			roundNumber.hide();
    		}
    		});
          }
    	);
    	
    	$.extend($.fn.validatebox.defaults.rules, {
            //频道，赛事必选
    	    selectRequire: {
    	        validator: function (value, param) {
    	            if(value=="-1"){
    	            	return false;
    	            }else{
    	            	return true;
    	            }
    	        },
    	        message: '${internationalConfig.请选择}'
    	    }
        });
</script>
<style type="text/css">
	table{
		table-layout: auto;
		width:100%;
	}
	.form-div{
		width:100%;
		margin: 5px 5px 5px 0px;
		padding-bottom: 5px;
		border-bottom:1px dashed #aaa;
	}
	.form-div:last-child{
		border-bottom:none;
	}
	select{
		width:155px;
	}

	.form-table th, .form-table td {
		border:0;
		vertical-align: middle;
		padding: 5px;
		white-space: nowrap;
	}
	.form-table td{
		width: 200px;
	}
	.form-table th{
		width: 90px;
	}
	.form-table td:first-child{
		width: 10px !important;
	}
</style>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form1" method="post" action="/play_package/create.json">
			<div class="form-div">
				<input type="hidden" name="id" id="id" value="${livePackageInfo.id}"/>
				<table class="form-table">
					<tr>
						<th colspan="5"><h5>${internationalConfig.基本信息}</h5></th>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<th><b style="color: red">*</b>${internationalConfig.直播名称}</th>
						<c:choose><c:when test="${not empty livePackageInfo}"><c:set var="name" value="${livePackageInfo.name}"/></c:when><c:otherwise><c:set var="name" value="${param.name}"/></c:otherwise></c:choose>
						<td colspan="3"><input name="name" type="text" value="${name}" <c:if test="${param.baseInfoReadOnly=='true'}"></c:if>/></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<th><b style="color: red">*</b>${internationalConfig.频道}</th>
						<c:choose><c:when test="${not empty livePackageInfo}"><c:set var="matchId" value="${livePackageInfo.matchId}"/></c:when><c:otherwise><c:set var="matchId" value="${param.matchId}"/></c:otherwise></c:choose>
						<td>
							<c:choose>
								<c:when test="${param.baseInfoReadOnly=='true'}">
									<c:forEach items="${directList}" var="packageType"><c:if test="${matchId == packageType.id}"><c:set var="matchName" value="${internationalConfig[packageType.description]}"/></c:if></c:forEach>
									<input readonly="readonly" value="${matchName}">
									<input type="hidden" name="matchId" id="matchId" value="${matchId}">
								</c:when>
								<c:otherwise>
									<select name="matchId" id="matchId" style="margin-top: 5px" class="easyui-validatebox" data-options="validType:'selectRequire'">
										<option value="-1">${internationalConfig.全部}</option>
										<c:forEach items="${directList}" var="packageType">
											<option value="${packageType.id}" <c:if test="${matchId == packageType.id}">selected="selected" </c:if>>${internationalConfig[packageType.description]}</option>
										</c:forEach>
									</select>
								</c:otherwise>
							</c:choose>
						</td>
						<th><b style="color: red">*</b>${internationalConfig.赛事}</th>
						<c:choose><c:when test="${not empty livePackageInfo}"><c:set var="itemId" value="${livePackageInfo.itemId}"/></c:when><c:otherwise><c:set var="itemId" value="${param.itemId}"/></c:otherwise></c:choose>
						<td>
							<c:choose>
								<c:when test="${param.baseInfoReadOnly=='true'}">
									<c:forEach items="${seasonList}" var="livePackage"><c:if test="${itemId == livePackage.id}"><c:set var="itemName" value="${livePackage.description}"/></c:if></c:forEach>
									<input readonly="readonly" value="${itemName}">
									<input type="hidden" name="itemId" id="itemId" value="${itemId}">
								</c:when>
								<c:otherwise>
									<select name="itemId" id="itemId" style="margin-top: 5px" class="easyui-validatebox" data-options="validType:'selectRequire'">
										<option value="-1">${internationalConfig.全部}</option>
										<c:forEach items="${seasonList}" var="livePackage">
											<option value="${livePackage.id}" <c:if test="${itemId == livePackage.id}"> selected="selected"</c:if>>${livePackage.description}</option>
										</c:forEach>
									</select>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<th>${internationalConfig.场次ID_1}</th>
						<td>
							<c:choose><c:when test="${not empty livePackageInfo}"><c:set var="extendId" value="${livePackageInfo.packageType == 2 ? livePackageInfo.extendId :''}"/></c:when><c:otherwise><c:set var="extendId" value="${param.extendId}"/></c:otherwise></c:choose>
							<input name="extendId"  class="easyui-validatebox" validType="longThan(16)" type="text" value='${extendId}' onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}" onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}" <c:if test="${param.baseInfoReadOnly=='true'}">readonly="readonly"</c:if>/>
						</td>
						<th>${internationalConfig.直播券张数}</th>

						<td>
						<input name="counts" type="text" value="${livePackageInfo.counts}" class="easyui-validatebox" data-options="required:true,validType:'number'"/>
						</td>
					</tr>
				</table>
			</div>

			<div class="form-div">
				<table class="form-table">
					<tr>
						<th colspan="5"><h5>${internationalConfig.价格设置}</h5></th>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<th><b style="color: red">*</b>${internationalConfig.现售价}</th>
						<td colspan="3"><input type="text" name="price" id="price" value="${livePackageInfo.price}" class="easyui-validatebox easyui-numberbox" precision="2" data-options="required:true,validType:'number',min:0.01,height:30"></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<th>${internationalConfig.iPhone产品ID}</th>
						<td><input type="text" name="appId" value="${appleyKey.appId}"/></td>
						<th>${internationalConfig.iPad产品ID}</th>
						<td><input type="text" name="ipadId" value="${appleyKey.ipadId}"/></td>
					</tr>
					<tr>
						<th colspan="5"><h5>${internationalConfig.会员价设置}</h5></th>
					</tr>
					<tr>
						<td>&nbsp;<input type="hidden" name="vipPriceSet" id="vipPriceSet"> </td>
						<th>${internationalConfig.适用会员价类别}</th>
                        <c:set var="vipPriceSet" value="${livePackageInfo.vipPriceSetObject}"/>
						<td><select id="vipCategory" name="vipCategory" class="easyui-validatebox" data-options="required:true">
							<option value="">${internationalConfig.请选择}</option>
								<c:forEach items="${vipCategories}" var="vipCategory" >
									<option value="${vipCategory.category}" <c:if test="${vipPriceSet.vipCategory==vipCategory.category}">selected="selected"</c:if>> ${internationalConfig[vipCategory.name]}</option>
								</c:forEach>
							</select>
						</td>
						<th>${internationalConfig.会员价}</th>
						<td><input type="text" name="vipPrice" class="easyui-numberbox" data-options="min:0.01,precision:2,validType:'lessThan[\'#price\']',height:30" value="${vipPriceSet.vipPrice}"></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<th>VIP ${internationalConfig.iPhone产品ID}</th>
						<td><input type="text" name="vipAppId" value="${vipPriceSet.vipAppId}"/></td>
						<th>VIP ${internationalConfig.iPad产品ID}</th>
						<td><input type="text" name="vipIpadId" value="${vipPriceSet.vipIpadId}"/></td>
					</tr>
				</table>
			</div>

			<div class="form-div">
				<table class="form-table">
					<tr>
						<th colspan="5"><h5>${internationalConfig.状态设置}</h5></th>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<th><b style="color: red">*</b>${internationalConfig.直播券有效期}</th>
						<td><input type="text" name="validateDays" class="easyui-validatebox"
								   data-options="required:true,validType:'int'" value="${livePackageInfo.validateDays}" />&nbsp;&nbsp;${internationalConfig.天}
						</td>
						<th>${internationalConfig.套餐状态}</th>
						<td>
							<select name="status">
								<c:choose>
									<c:when test="${livePackageInfo.status == 1}">
										<option value="1" selected="selected">${internationalConfig.未发布}</option>
										<option value="3">${internationalConfig.已发布}</option>
									</c:when>
									<c:when test="${livePackageInfo.status == 3}">
										<option value="1">${internationalConfig.未发布}</option>
										<option value="3" selected="selected">${internationalConfig.已发布}</option>
									</c:when>
									<c:otherwise>
										<option value="1">${internationalConfig.未发布}</option>
										<option value="3">${internationalConfig.已发布}</option>
									</c:otherwise>
								</c:choose>
							</select>
						</td>
					</tr>
				</table>
			</div>
		</form>
	</div>
</div>
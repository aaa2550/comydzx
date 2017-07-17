<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:if test="${not empty param.singlePage}">
<%@ include file="/WEB-INF/views/inc/head.inc"%>
</c:if>
<script src="/static/lib/swfupload/swfupload.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" src="/static/lib/uploadImgCommon.js?v=20150408.01" charset="utf-8"></script>

<style>
.table_border {
  border: solid 1px #B4B4B4;
  border-collapse: collapse;
  width:100%;
}

.table_border tr th {
  padding-left: 4px;
  height: 20px;
  border: solid 1px #B4B4B4;
}

.table_border tr td {
  line-height: 20px;
  padding: 4px;
  border: solid 1px #B4B4B4;
  text-align:center
}
.short_select {
	width:126px;
}
.top-align{vertical-align: top !important}
.bold-font{
	font-weight: bold;
}
</style>
<c:if test="${not empty activity && not empty activity.copywritings}">
	<c:set var="copywritings" value="${activity.parsedCopywritings}"/>
</c:if>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="">
        <form id="form" method="post" name = "activityForm"
              action="/v2/activity/save.json">
            <table style="width: 100%" class="table table-form">
                <colgroup>
                    <col width="90">
                    <col width="100">
                    <col width="80">
                    <col width="*">
                </colgroup>

                <!--<tr>
                    <td colspan="4" style="border-top:none">
                        <h5>${internationalConfig.添加活动}</h5>
                    </td>
                </tr>-->
                <tr>
                    <input type="hidden" name="id" value="${activity.id}"/>
                    <th><b style="color: red">*</b>${internationalConfig.活动类型}</th>
                    <td colspan="3"><select id="type" name="type" class="short_select">
                        <c:forEach items="${dict['v2_activity_type']}" var="item">
                            <option value="${item.key}">${item.value}</option>
                        </c:forEach>
                    </select></td>
                </tr>
                <tr>
                    <th colspan="4" style="border-top:none">
                        <h5>${internationalConfig.基本参数}</h5>
                    </th>
                </tr>

                <tr>
                    <th><b style="color: red">*</b>${internationalConfig.活动标题}</th>
                    <td colspan="3">
                        <input  id="title" name="title" value="${activity.title}" class="easyui-validatebox span2" data-options="required:true" maxlength="255">
                    </td>
                </tr>
                <tr>
                    <th class="top-align">${internationalConfig.活动描述}</th>
                    <td colspan="3">
                        <textarea id="description" name="description" class="text-area" rows="3" style="width: 420px !important;">${activity.description}</textarea>
                    </td>
                </tr>
                <tr>
                    <th nowrap="nowwrap">${internationalConfig.活动文案}1</th>
                    <td><input id="copywritings_label1" name="copywritings_label1" value="${copywritings.label1}" class="span2"></td>
                    <th nowrap="nowwrap">${internationalConfig.活动文案}2</th>
                    <td><input id="copywritings_label2" name="copywritings_label2" value="${copywritings.label2}" class="span2"></td>
                </tr>
				
				<tr>
					<th nowrap="nowwrap">${internationalConfig.活动图片}</th>
                    <td nowrap="nowwrap"><input id="common_pic" name="common_pic" value="${copywritings.pic1}" readonly="readonly" ondblclick="window.open(this.value,'_blank')" class="span2"/>
						<!--<div id="common_preview"><c:if test="${not empty copywritings && not empty copywritings.pic1}">
						<a href="${copywritings.pic1}" target="_blank">${internationalConfig.查看图片}
						</c:if></div>-->
						<input class="buttoncenter" type="button" value="${internationalConfig.上传文件}" id="common_upload_btn" />
					</td>
					
					<th nowrap="nowwrap">${internationalConfig.活动详情url}</th>
                    <td nowrap="nowwrap"><input name="detailUrl" id="detailUrl" value="${activity.detailUrl}" class="span2">
					</td>
				</tr>
				<tr>
					<th nowrap="nowrap"><b style="color: red">*</b>${internationalConfig.活动终端}</th>
					<td colspan="3">
						<c:forEach items="${terminals}" var="item">
							<input type="checkbox" id="terminal${item.terminalId}" name="terminal" value="${item.terminalId}">&nbsp;${item.terminalName}&nbsp;
						</c:forEach>
						<input type="hidden" id="terminals" name="terminals">
					</td>
				</tr>
                <tr>
                    <th nowrap="nowwrap"><b style="color: red">*</b>${internationalConfig.开始日期}</th>
                    <td nowrap="nowwrap"><input id="beginDate" name="beginDate" class="easyui-datebox span2" value="<fmt:formatDate pattern="yyyy-MM-dd" value="${activity.beginDate}"/>" data-options="required:true"></td>
                    <th nowrap="nowwrap"><b style="color: red">*</b>${internationalConfig.结束日期}</th>
					<td nowrap="nowwrap"><input id="endDate" name="endDate" class="easyui-datebox span2" value="<fmt:formatDate pattern="yyyy-MM-dd" value="${activity.endDate}"/>" data-options="required:true,validType:'timeLaterThan[\'input[name=beginDate]\',\'yyyy-MM-dd\']'"></td>
                </tr>
				
				<tr>
                    <th nowrap="nowwrap"><b style="color: red">*</b>${internationalConfig.每日开始时间}</th>
                    <td nowrap="nowwrap"><input id="beginTime" name="beginTime"  class="easyui-validatebox span2" value="<fmt:formatDate pattern="HH:mm" value="${activity.beginTime}"/>" data-options="required:true,validType:'time'"></td>
                    <th nowrap="nowwrap"><b style="color: red">*</b>${internationalConfig.每日结束时间}</th>
					<td nowrap="nowwrap"><input id="endTime" name="endTime"  class="easyui-validatebox span2" value="<fmt:formatDate pattern="HH:mm" value="${activity.endTime}"/>" data-options="required:true,validType:['time','timeLaterThan[\'input[name=beginTime]\',\'HH:mm\']']"></td>
                </tr>

                <tr>
                    <th>${internationalConfig.活动促销状态}</th>
                    <td>
						<select name="status" class="short_select">
                            <option value="1" <c:if test="${activity.status==1}">selected="selected"</c:if>>${internationalConfig.未发布}</option>
                            <option value="3" <c:if test="${activity.status==3}">selected="selected"</c:if>>${internationalConfig.已发布}</option>
						</select>
					</td>
					<th style="width:100px;">
						<input class="coupon_checkbox" type="checkbox" name="coupon" value="1" class="span2">${internationalConfig.允许代金券}
					</th>
                </tr>
				
				<tr>
                    <th colspan="4" style="border-top:none">
                        <h5>${internationalConfig.活动套餐信息}</h5>
                    </th>
				</tr>
				<tr>
					<td colspan="4">
						<div class="bold-font">&middot;${internationalConfig.活动主体}</div>
						<table id="activity_body" class="table_border" style="width:94%;margin-left:20px;">
							<tr>
								<td>${internationalConfig.套餐类型}</td>
								<td>${internationalConfig.套餐内容}</td>
								<td>${internationalConfig.现价_}</td>
								<td>${internationalConfig.操作}</td>
							</tr>
							<tr>
								<td width="240"><select id="vipCategory" name="vipCategory" onchange="retrieveVipPackagesByCategory(this.value,'vipPackageId','packagePriceTd')" data-options="required:true">
                                        <option value="">${internationalConfig.请选择会员类型}</option>
										<c:forEach items="${vipCategories}" var="category">
											<option value="${category.category}" <c:if test="${vipPackage.category==category.category}">selected</c:if>>${internationalConfig[category.name]}</value></option>
										</c:forEach>
									</select>
								</td>
								<td width="240"><select id="vipPackageId" name="vipPackageId" onchange="changeVipPackageId(this,'packagePriceTd')" class="easyui-validatebox" value='${activity.vipPackageId}' data-options="required:true">
                                    <option value="">${internationalConfig.请选择套餐内容}</option>
                                </select></td>
								<td id="packagePriceTd">${vipPackage.price}</td>
								<td><a href="javascript:void(0)" onclick="resetVipPackageId()">${internationalConfig.重置}</a></td>
							</tr>
						</table>
						<div style="margin-left:20px"><input type="checkbox" name="availableForAutoPay" id="availableForAutoPay" value="1" <c:if test="${activity.availableForAutoPay==1}">checked="checked"</c:if>>${internationalConfig.平台自动扣费订单是否参与此活动}</div>
						<div><div style="float:left" class="bold-font">&middot;${internationalConfig.赠送会员送实物活动可不选择}</div>
							<div style="float:right;margin-right:50px">
								<c:if test="${not empty activity && not empty activity.content}">
									<c:set var="content" value="${activity.parsedContent}"/>
								</c:if>
								<a onclick="addContent('${internationalConfig.内容}');" href="javascript:void(0);" class="easyui-linkbutton bold-font" data-options="plain:true,iconCls:'pencil_add'">${internationalConfig.增加}</a>
							</div>
						</div>
						<div id="contentDIV" data-options="region:'center',border:false" style="display:<c:choose><c:when test="${not empty content}">block;</c:when><c:otherwise>none;</c:otherwise></c:choose>margin-left:10px">
							<table id="contentTable" width="100%">
								<c:forEach items="${content}" var="item" varStatus="varStatus">
								<tr>
									<th>${internationalConfig.内容}${varStatus.count}</th>
									<td>
										<select id="contentCategory${varStatus.count}" name="contentCategory${varStatus.count}" onchange="retrieveVipPackageTypes(this.value,'extPackageTypeId${varStatus.count}')" class="easyui-validatebox short_select" data-options="required:true">
										<c:forEach items="${vipCategories}" var="category">
											<option value="${category.category}" <c:if test="${item.getClass().name=='com.alibaba.fastjson.JSONObject'&&item.categoryId==category.category}">selected</c:if>>${internationalConfig[category.name]}</value></option>
										</c:forEach>
									</select>
									<c:set var="nextContentIdIndex" value="${varStatus.count}"/>
									</td>
									<td><select id="extPackageTypeId${varStatus.count}" name="extPackageTypeId${varStatus.count}" class="easyui-validatebox short_select" data-options="required:true">
									</select>
									</td>
									<td><select id="extDurationId${varStatus.count}" name="extDurationId${varStatus.count}" class="easyui-validatebox short_select" data-options="required:true">
									<c:forEach items="${packageDurations}" var="duration">
										<option value="${duration.id}" <c:if test="${item.getClass().name=='com.alibaba.fastjson.JSONObject'&&item.durationId==duration.id}">selected="selected"</c:if>>
											${duration.durationName}
										</option>
									</c:forEach>
									</select></td>
									<td><img onclick="delContent(this);" src="/static/style/images/extjs_icons/cancel.png" title="${internationalConfig.删除}"/></td>
								</tr>
								</c:forEach>
							</table>
						</div>
					</td>
                </tr>

                <tr>
                </tr>
            </table>
			<input type="hidden" id="content" name="content" value="">
			<input type="hidden" id="copywritings" name="copywritings" value="">
        </form>
    </div>
</div>
<script src="/static/lib/json2.min.js"></script>
<script src="/static/lib/date.js"></script>
<script src="/static/v2/v2Activity.js"></script>
<script src="/static/i18n/i18n_${currentLanguage}.js"></script>
<script type="text/javascript">
    var common_pic = common_pic || null;
	//var common_pic2=initUploadFunc("common_upload_btn2","common_pic2");
	$.extend($.fn.validatebox.defaults.rules, {
    time : {
        validator : function(value, param) {
            var reg = new RegExp(
                '(^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$)|(^24:00$)');
            return reg.test(value);
        },
        message : '${internationalConfig.请输入合法时间}'
    },
        timeLaterThan: {
            validator: function(value, param) {
                var tmThis=Date.parse(value.replace("24:00","23:59"), param[1]);
                var valueCompare=/^\d/.test(param[0])?param[0]:$(param[0]).val();
                if(valueCompare)valueCompare.replace("24:00","23:59");
                var tmCompare=Date.parse(valueCompare, param[1]);
                return tmThis>=tmCompare;
            },
            message: "${internationalConfig.结束时间不能早于开始时间}"
        }
	});
	var successMsg='<c:choose><c:when test="${not empty activity}">${internationalConfig.修改成功}</c:when><c:otherwise>${internationalConfig.添加成功}</c:otherwise></c:choose>';
	var packageCategories=[<c:forEach items="${vipCategories}" var="category" varStatus="varStatus"><c:if test="${varStatus.index!=0}">,</c:if>{category:${category.category},name:"${fn:replace(internationalConfig[category.name],'\"','\\\"')}"}</c:forEach>];
	var packageDurations=[<c:forEach items="${packageDurations}" var="duration" varStatus="varStatus"><c:if test="${varStatus.index!=0}">,</c:if>{id:${duration.id},name:"${fn:replace(duration.durationName,'\"','\\\"')}"}</c:forEach>];
	var nextContentIdIndex=${nextContentIdIndex==null?1:nextContentIdIndex};
	$(document).ready(function(){
	    <c:if test="${activity!=null}">(function(){if($("#endTime").val()=='00:00')$("#endTime").val("24:00")})();</c:if>
        <c:if test="${activity==null}">(function(){$("#beginTime").val('00:00');$("#endTime").val("24:00")})();</c:if>
		<c:choose><c:when test="${activity!=null&&activity.vipPackageId!=null}">
		retrieveVipPackagesByCategory('${vipPackage.category}','vipPackageId','packagePriceTd','${activity.vipPackageId}');
		</c:when><%--<c:otherwise>
		retrieveVipPackagesByCategory(packageCategories[0].category,'vipPackageId','packagePriceTd',null);
		</c:otherwise>--%>
		</c:choose>
		<c:forEach items="${content}" var="item" varStatus="varStatus">
			retrieveVipPackageTypes(<c:choose><c:when test="${item.getClass().name=='com.alibaba.fastjson.JSONObject'}">'${item.categoryId}'</c:when><c:otherwise>packageCategories[0].category</c:otherwise></c:choose>,'extPackageTypeId${varStatus.count}','<c:if test="${item.getClass().name=='com.alibaba.fastjson.JSONObject'}">${item.packageTypeId}</c:if>');
		</c:forEach>
	});
	$(document).ready(function(){
		(function(){
			var supportedTerminals = '${activity.terminals}'.split(/\s*,\s*/);
			if (supportedTerminals)
				for ( var i = 0; i < supportedTerminals.length; i++) {
					$("#terminal" + supportedTerminals[i]).prop("checked", true);
				}
		})();
	});
	checkCoupon();
	function checkCoupon() {
		$.coupon = "${activity.coupon}";
		if($.coupon==1){
			$('.coupon_checkbox').attr('checked','checked');
		}
	}
</script>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="easyui-layout" data-options="fit:true,border:false" style="width: 800px; height: 600px">
    <div data-options="region:'center',border:true" title="">
        <form id="form" method="post">
                   <input name="frountCovering" type="hidden" value="${movie.frountCovering}"  />
                    <input name="contentType" type="hidden" value="${movie.contentType}">
                    <input name="stream" type="hidden" value="${movie.stream}">
                    <input name="terminal" type="hidden" value="${movie.terminal}">
                    <input name="chargeName" type="hidden" value="${movie.chargeName}">
        
            <table style="width: 100%;" class="table table-form">
			
                <tr>
                    <th>${internationalConfig.专辑名称}</th>
                    <td><input name="movieName" type="text" value="${movie.movieName}" readonly="readonly"></td>
                    <th>${internationalConfig.专辑ID}</th>
                    <td><input name="movieId" type="text" value="${movie.movieId}" readonly="readonly" id="movieId">
                    </td>
                </tr>

                <tr>
                    <th>${internationalConfig.内容类型}</th>
                    <td>
                        <c:choose>
                            <c:when test="${movie.contentType == 1}">
                                ${internationalConfig.电影}
                            </c:when>
                            <c:when test="${movie.contentType == 2}">
                                ${internationalConfig.电视剧}
                            </c:when>

                            <c:otherwise>
                                ${internationalConfig.电影}
                            </c:otherwise>
                        </c:choose>
                    </td>
         
                    <th>${internationalConfig.专辑缩略图}</th>
                    <td><img src="${movie.frountCovering}" style="width: 120px;height: 160px;"/></td>
                </tr>

                <%-- <tr>
                    <th>${internationalConfig.片长}</th>
                    <td><input name="movieTime" type="text" value="${movie.movieTime}" class="easyui-numberbox"
                               readonly="readonly">
                    </td>
                  
                    <th>${internationalConfig.试看时间段}</th>
                    <td><input name="previewStart" type="text" value="${movie.previewStart}"
                                           class="easyui-numberbox" readonly="readonly" style="width: 60px;">~<input
                            name="previewEnd" type="text" value="${movie.previewEnd}" class="easyui-numberbox"
                            style="width: 60px;" readonly="readonly"/></td>
                </tr> --%>
                <tr>
                   <th>${internationalConfig.试看时长}</th>
                     <td colspan="3"><input name="tryLookTime" type="text" value="${movie.tryLookTime}" class="easyui-numberbox"  data-options="min:0,max:360,required:true" >
                    </td>
                </tr>
              
                <tr>
                    <th>${internationalConfig.播放平台}</th>
                    <td colspan="3">
                        <table class="no-border-table">
                            <tr>
                                <c:forEach items="${playPlatform}" var="pp">
                                    <td>
                                        <c:choose>
                                            <c:when test="${fn:contains(selectedPlayPlatform, pp)}">
                                                <input type="checkbox"
                                                       name="playPlatformIds"
                                                       checked="checked"
                                                       value="${pp.code}" />${pp.value}
                                            </c:when>
                                            <c:otherwise>
                                                <input type="checkbox"
                                                       name="playPlatformIds"
                                                       value="${pp.code}" />${pp.value}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </c:forEach>
                            </tr>
                        </table>
                    </td>
                </tr>
				<%-- <tr>
                    <th>${internationalConfig.导演}</th>
                    <td colspan="3">
                        ${movie.director}
                    </td>
                </tr>
                <tr>
                    <th>${internationalConfig.主演}</th>
                    <td colspan="3">
                        ${movie.actor}
                    </td>
                </tr> --%>
                <tr>
                    <th>${internationalConfig.付费类型}</th>
                	<td>
                                <input name="chargeType" type="radio" value="0"/>${internationalConfig.点播}
                                <input name="chargeType" type="radio" value="1"/>${internationalConfig.点播且包月}
                                <input name="chargeType" type="radio" value="2"/>${internationalConfig.包月}
                                <input name="chargeType" type="radio" value="3"/>${internationalConfig.免费但TV包月收费}
                                <input name="chargeType" type="radio" value="4"/>${internationalConfig.包年}
                           
                    </td>
                    <th style="text-align: right;vertical-align: middle;">${internationalConfig.是否收费}</th>
                    <td>
                                <input name="isCharge" type="radio" value="1" />${internationalConfig.付费}
                                <input name="isCharge" type="radio" value="0"/>${internationalConfig.免费}
                         
                    </td>
                </tr>
                <tr>
                    <th>${internationalConfig.收费平台}</th>
                    <td colspan="20">
                        <table class="no-border-table">
                            <tr>
                                <c:forEach items="${terminalList}" var="terminal">
                                    <td>
                                        <c:choose>
                                            <c:when test="${fn:contains(selectedTerminalIds, terminal.terminalId)}">
                                                <input id="terminal${terminal.terminalId}" type="checkbox"
                                                       name="terminalList"
                                                       checked="checked"
                                                       value="${terminal.terminalId}" onchange="payTerminal(${terminal.terminalId})"/>${terminal.terminalName}
                                            </c:when>
                                            <c:otherwise>
                                                <input id="terminal${terminal.terminalId}" type="checkbox"
                                                       name="terminalList"
                                                       value="${terminal.terminalId}"  onchange="payTerminal(${terminal.terminalId})"/>${terminal.terminalName}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </c:forEach>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <th>${internationalConfig.定价方案}</th>
                    <td>
                        <select name="chargeId" id="chargeId">
                            <c:choose>
                                <c:when test="${movie.chargeId==0}">
                                    <option value="0" selected="selected">无</option>
                                </c:when>
                                <c:otherwise>
                                    <option value="0">无</option>
                                </c:otherwise>
                            </c:choose>
                            <c:forEach var="charge" items="${charges}">
                          <option value="${charge.chargeId }"   ${charge.chargeId == movie.chargeId ? "selected":"" }>${charge.chargeName }</option>              
                            </c:forEach>
                        </select>
                    </td>
                    <th style="vertical-align: middle;text-align: right;">${internationalConfig.状态}</th>
                    <td>
                        <select name="status" id="status" onchange="releaseStatus()">
                            <option value="0" >${internationalConfig.未发布}</option>
                            <option value="1" >${internationalConfig.已发布}</option>
                            <option value="2" >${internationalConfig.定时发布}</option>
                        </select>
                    </td>
                </tr>
                <tr id="fixedTimeText" <c:if test="${movie.status != 2 }">style="display:none"</c:if>>
					<th>${internationalConfig.定时发送时间}</th>
					<td colspan="4"><input type="text" name="fixedTime" id="fixedTime"
						value="<fmt:formatDate value="${movie.fixedTime}" type="both"/>"
						class="easyui-datetimebox"/>
					</td>
				</tr>
                <c:if test="${charge!=null}">
                    <tr>
                        <th>${internationalConfig.有效期}</th>
                        <td>${charge.validTime} ${internationalConfig.天}</td>
                        <th style="width:22%;vertical-align: middle;text-align: right;">${internationalConfig.会员优惠}</th>
                        <td>
                            <c:choose>
                                <c:when test="${charge.memberDiscounts == 0}">
                                    ${internationalConfig.原价}
                                </c:when>
                                <c:when test="${charge.memberDiscounts == 1}">
                                    ${internationalConfig.半价}
                                </c:when>
                            </c:choose>
                        </td>
                    </tr>
                </c:if>
                <tr>
                    <th>${internationalConfig.百度推广状态}：</th>
                    <td colspan="3">
                        <select name="spread">
                            <option value="0"
                                    <c:if test="${empty movieSpread or movieSpread.isSpread == 0 }">selected</c:if>>${internationalConfig.不推广}
                            </option>
                            <option value="1"
                                    <c:if test="${ movieSpread.isSpread == 1 }">selected</c:if>>${internationalConfig.推广}
                            </option>
                        </select>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
<script type="text/javascript">

    $("input[name=isCharge][value=${movie.isCharge}]").attr("checked",true); 
	$("input[name=chargeType][value=${movie.chargeType}]").attr("checked",true); 
	$("#status").val('${movie.status}');
	 
    $(function () {
        parent.$.messager.progress('close');
        $('#form').form({
            url: '${pageContext.request.contextPath}/movie/update.json',
            onSubmit: function () {
                parent.$.messager.progress({
                    title: '${internationalConfig.提示}',
                    text: '${internationalConfig.数据处理中}....'
                });
                var isValid = $(this).form('validate');
                if (!isValid) {
                    parent.$.messager.progress('close');
                }
                
                if($("#chargeId").val() == 0) {
                	parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.定价方案不能为空}', 'error');
					parent.$.messager.progress('close');
					return false;
                }
                
                var isCharge = $('input:radio[name="isCharge"]:checked').val();
                var isTrue = true;
                if(isCharge == 1) { //付费
                    $($("input:checkbox[name='terminalList']")).each(function(){
                       if($(this).is(':checked')) {
                         isTrue = false;
                       }                        
                    }); 

                    if(isTrue) {
                      parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.必须选择支付平台}', 'error');
                      parent.$.messager.progress('close');
                        return false;
                    }
                } else if(isCharge == 0) { //免费
                    $($("input:checkbox[name='terminalList']")).each(function(){
                       if($(this).is(':checked')) {
                         isTrue = false;
                       }                        
                    });

                    if(!isTrue) {
                      parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.不应勾选付费平台}', 'error');
                      parent.$.messager.progress('close');
                        return false;
                    }
                }
                
                return isValid;
            },
            success: function (result) {
                parent.$.messager.progress('close');
                result = $.parseJSON(result);
                if (result.code == 0) {
					parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.编辑成功}', 'success');
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
                }
            }
        });
    });
    
    function releaseStatus() {
    	var status = $("#status").val();
    	if(status == 2) {
    		$("#fixedTimeText").show();
    	} else {
    		$("#fixedTimeText").hide();
    	}
    };

    function payTerminal(terminalid){    	
    	if(terminalid == '141001'){
    		if($("#terminal141001").is(':checked')){
    			$("#terminal141005").prop('checked', true);
        		$("#terminal141003").prop('checked', true);
        		$("#terminal141001").prop('checked', true);
        	}else{
        		$("#terminal141005").prop('checked', false);
        		$("#terminal141003").prop('checked', false);
        		$("#terminal141001").prop('checked', false);
        	}
    	}
    	
    	if(terminalid == '141003'){
    		if($("#terminal141003").is(':checked')){
    			$("#terminal141005").prop('checked', true);
        		$("#terminal141003").prop('checked', true);
        		$("#terminal141001").prop('checked', true);
        	}else{
        		$("#terminal141005").prop('checked', false);
        		$("#terminal141003").prop('checked', false);
        		$("#terminal141001").prop('checked', false);
        	}
    	}
    	
    	if(terminalid == '141005'){
    		if($("#terminal141005").is(':checked')){
    			$("#terminal141005").prop('checked', true);
        		$("#terminal141003").prop('checked', true);
        		$("#terminal141001").prop('checked', true);
        	}else{
        		$("#terminal141005").prop('checked', false);
        		$("#terminal141003").prop('checked', false);
        		$("#terminal141001").prop('checked', false);
        	}
    	}

    }
</script>
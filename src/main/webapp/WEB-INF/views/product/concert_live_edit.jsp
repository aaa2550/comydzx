<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');
        $('#form').form({
            url: '/concert_live/update.json',
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
                
                return isValid;
            },
            success: function (result) {
                parent.$.messager.progress('close');
                result = $.parseJSON(result);
                if (result.code == 0) {
                	parent.$.messager.alert('${internationalConfig.成功}', "${internationalConfig.编辑成功}", 'success');
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
                }
            }
        });
    });

    //    checkTerminals();

    function checkTerminals() {
        $.getJSON('${pageContext.request.contextPath}/movieController/terminals?movieId=' + $('#movieId').val() + "&timestamp=" + new Date().getTime(), {}, function (terminals) {
            for (var i = 0; i < terminals.length; i++) {
                $("#terminal" + terminals[i].terminalId).attr("checked", true);
            }
        })
    }
    
    function payTerminal(terminalid){    	
    	if(terminalid == '141001'){
    		if($("#terminal141001").is(':checked')){
    			$("#terminal141005").prop("checked",true);
        		$("#terminal141003").prop("checked",true);
        		$("#terminal141001").prop("checked",true);
        	}else{
        		$("#terminal141005").prop("checked",false);
            	$("#terminal141003").prop("checked",false);
            	$("#terminal141001").prop("checked",false);
        	}
    	}
    	
    	if(terminalid == '141003'){
    		if($("#terminal141003").is(':checked')){
    			$("#terminal141005").prop("checked",true);
        		$("#terminal141003").prop("checked",true);
        		$("#terminal141001").prop("checked",true);
        	}else{
        		$("#terminal141005").prop("checked",false);
            	$("#terminal141003").prop("checked",false);
            	$("#terminal141001").prop("checked",false);
        	}
    	}
    	
    	if(terminalid == '141005'){
    		if($("#terminal141005").is(':checked')){
    			$("#terminal141005").prop("checked",true);
        		$("#terminal141003").prop("checked",true);
        		$("#terminal141001").prop("checked",true);
        	}else{
        		$("#terminal141005").prop("checked",false);
            	$("#terminal141003").prop("checked",false);
            	$("#terminal141001").prop("checked",false);
        	}
    	}

    }
</script>
<div class="easyui-layout" data-options="fit:true,border:false" style="width: 800px; height: 600px">
    <div data-options="region:'center',border:true" title="" style="overflow: hidden;">
        <form id="form" method="post">
            <table class="table table-form">
				<colgroup>
					<col width="80">
					<col width="100">
					<col width="94">
					<col width="*">
				</colgroup>
                <tr>
                    <th>${internationalConfig.直播名称}</th>
                    <td><input name="movieName" type="text" value="${movie.movieName}" readonly="readonly"></td>
                    <th>${internationalConfig.直播ID}</th>
                    <td><input name="movieId" type="text" value="${movie.movieId}" readonly="readonly" id="movieId">
                    </td>
                </tr>

                <tr>
                    <th>${internationalConfig.直播类型}</th>
                    <td>
                        <c:choose>
                            <c:when test="${movie.liveType == 1}">
${internationalConfig.演唱会直播}</c:when>
                            <c:when test="${movie.liveType == 2}">${internationalConfig.体育直播}
</c:when>
                            <c:otherwise>${internationalConfig.演唱会直播}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <input name="frountCovering" type="hidden" value="${movie.frountCovering}">
                    <input name="contentType" type="hidden" value="${movie.contentType}">
                    <input name="stream" type="hidden" value="${movie.stream}">
                    <input name="terminal" type="hidden" value="${movie.terminal}">
                    <input name="chargeName" type="hidden" value="${movie.chargeName}">
                    <th>${internationalConfig.直播缩略图}</th>
                    <td><img src="${movie.frountCovering}" style="width: 120px;height: 160px;"/></td>
                </tr>
                <tr>
                	<th>${internationalConfig.直播时间}</th>
                    <td>
                    <input type="text" name="liveTime" id="liveTime"
						value="<fmt:formatDate value="${movie.liveTime}" type="both"/>"
						class="easyui-datetimebox" data-options="required:true" />
                    </td>
                    <th/>
                    <td/>
                </tr>
				<tr>
					<th>${internationalConfig.活动开始时间}</th>
					<td><input type="text" name="activityStartTime" id="activityStartTime"
						value="<fmt:formatDate value="${movie.activityStartTime}" type="both"/>"
						class="easyui-datetimebox" data-options="required:true" />
					</td>
					<th>${internationalConfig.活动结束时间}</th>
					<td><input type="text" name="activityEndTime" id="activityEndTime"
						value="<fmt:formatDate value="${movie.activityEndTime}" type="both"/>"
						class="easyui-datetimebox" data-options="required:true" />
					</td>
				</tr>
				<tr>
					<th>${internationalConfig.附加参与方式}</th>
					<td colspan="20">
						<table class="no-border-table">
							<tr>
								<c:forEach items="${allAddtionMovieTypes}"
									var="addctionMovieType">
									<td><c:choose>
											<c:when
												test="${fn:contains(selectedAddtionMovieTypes, addctionMovieType.type)}">
												<input id="addtionMovieType${addctionMovieType.type}"
													type="checkbox" name="addctionMovieTypeList"
													checked="checked" value="${addctionMovieType.type}" />${addctionMovieType.description}
                                            </c:when>
											<c:otherwise>
												<input id="addtionMovieType${addctionMovieType.type}"
													type="checkbox" name="addctionMovieTypeList"
													value="${addctionMovieType.type}" />${addctionMovieType.description}
                                            </c:otherwise>
										</c:choose></td>
								</c:forEach>
							</tr>
						</table>
					</td>
				</tr>
                <tr>
                    <th>${internationalConfig.付费类型}</th>
                    <td>
                        <c:choose>
                            <c:when test="${movie.chargeType == 0}">
                                <input name="chargeType" type="radio" value="0" checked="checked"/>${internationalConfig.点播}
                            </c:when>
                            <c:otherwise>
                               <input name="chargeType" type="radio" value="0"/>${internationalConfig.点播}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <th>${internationalConfig.是否收费}</th>
                    <td>
                        <c:choose>
                            <c:when test="${movie.isCharge == 1}">
                                <input name="isCharge" type="radio" value="1" checked="checked"/>${internationalConfig.付费}
                                <input name="isCharge" type="radio" value="0"/>${internationalConfig.免费}
                            </c:when>
                            <c:when test="${movie.isCharge ==0}">
                                <input name="isCharge" type="radio" value="1"/>${internationalConfig.付费}
                                <input name="isCharge" type="radio" value="0" checked="checked"/>${internationalConfig.免费}
                            </c:when>
                            <c:otherwise>
                                <input name="isCharge" type="radio" value="1" checked="checked"/>${internationalConfig.付费}
                                <input name="isCharge" type="radio" value="0"/>${internationalConfig.免费}
                            </c:otherwise>
                        </c:choose>
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
                    <th>${internationalConfig.方案名称}</th>
                    <td>
                        <select name="chargeId" id="chargeId">
                            <c:choose>
                                <c:when test="${movie.chargeId==0}">
                                    <option value="0" selected="selected">${internationalConfig.无}</option>
                                </c:when>
                                <c:otherwise>
                                    <option value="0">${internationalConfig.无}</option>
                                </c:otherwise>
                            </c:choose>
                            <c:forEach var="charge" items="${charges}">
                                <c:choose>
                                    <c:when test="${charge.chargeId == movie.chargeId }">
                                        <option value="${charge.chargeId }" selected>${charge.chargeName }</option>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="${charge.chargeId }">${charge.chargeName }</option>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </select>
                    </td>
                    <th>${internationalConfig.状态}</th>
                    <td>
                        <select name="status">
                            <option value="0" <c:if test="${movie.status == 0 }">selected</c:if>>${internationalConfig.未发布}</option>
                            <option value="1" <c:if test="${movie.status == 1 }">selected</c:if>>${internationalConfig.已发布}</option>
                        </select>
                    </td>
                </tr>
                <c:if test="${charge!=null}">
                    <tr>
                        <th>${internationalConfig.有效期}</th>
                        <td>${charge.validTime} ${internationalConfig.天}</td>
                        <th>${internationalConfig.会员优惠}</th>
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
            </table>
        </form>
    </div>
</div>
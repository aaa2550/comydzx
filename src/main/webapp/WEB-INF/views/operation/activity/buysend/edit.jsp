<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script type="text/javascript" src="/static/lib/activityBuysend.js" charset="utf-8"></script>
<script type="text/javascript">
	function checkTerminals() {
		$.terminals = ${activity.terminalList};
		
		for ( var i = 0; i < $.terminals.length; i++) {
			$("#terminal" + $.terminals[i]).prop(
					"checked", true);
		}
	}
	
	checkTerminals();
	
	function checkExclusionIds() {
		$.exclusions = ${activity.exclusionIdList};
		
		for ( var i = 0; i < $.exclusions.length; i++) {
			$("#activity" + $.exclusions[i]).prop(
					"selected", true);
		}
	}
	
	checkExclusionIds();
	
    
	function search() {
		var inputSearchArray = getClass("input", "span2 input-box");
		var packageDetailArray = getClass("input", "span2");
		var subptypeArray = getClass("input","span2 subtype");
		for (var i = 0, n = inputSearchArray.length; i < n; i++) {
			bindSearchMovieName(inputSearchArray[i].id, subptypeArray[i].value,
					packageDetailArray[i].id);
		}

	}

	search();

	function getClass(tagName, className) //获得标签名为tagName,类名className的元素
	{
		if (document.getElementsByClassName) //支持这个函数
		{
			return document.getElementsByClassName(className);
		} else {
			var tags = document.getElementsByTagName(tagName);//获取标签
			var tagArr = [];//用于返回类名为className的元素
			for (var i = 0; i < tags.length; i++) {
				if (tags[i].class == className) {
					tagArr[tagArr.length] = tags[i];//保存满足条件的元素
				}
			}
			return tagArr;
		}

	}
</script>
<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');
        $('#form').form({
            url: '${pageContext.request.contextPath}/activity/buysend/editSubmit.json',
            onSubmit: function () {
                parent.$.messager.progress({
                    title: '提示',
                    text: '数据处理中，请稍后....'
                });
                var isValid = $(this).form('validate');
                if (!isValid) {
                    parent.$.messager.progress('close');
                }
                return isValid;
            },
            success: function (result) {
            	parent.$.messager.progress('close');
				result = $.parseJSON(result);
				if (result.code == 0) {
					parent.$.messager.alert('成功', result.msg, 'success');									
				} else {
					parent.$.messager.alert('错误', result.msg,'error');
				}
				parent.$.modalDialog.openner_dataGrid.datagrid('reload');
				parent.$.modalDialog.handler.dialog('close');
            }
        });
    });

</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="">
        <form id="form" method="post" action="${pageContext.request.contextPath}/activity/buysend/addSubmit.json">
            <table class="table table-hover table-condensed" style="width: 100%; height: 100%">
                <tr>
                    <th>活动名称</th>
                    <td><input name="name" type="text" id="name" value="${activity.name}"/>
                    	<input type="hidden" name="id" value="${activity.id}" />
                    </td>
                    <th>活动状态</th>
                    <td><select name="status" style="width:80px">
                    		<option value="1" <c:if test="${activity.status == 1}">selected</c:if> >上线</option>
                    		<option value="0" <c:if test="${activity.status == 0}">selected</c:if>>下线</option>
                    	</select>
                    </td>
                </tr>
                <tr>
                    <th>活动目的</th>
                    <td>
                        <input type="text" name="purpose" id="purpose" style="width:200px" value="${activity.purpose }"/>
                    </td>
                </tr>
                 <tr>
                    <th>活动时间</th>
                    <td>
                        <input type="text" name="startTime" id="startTime" class="easyui-datetimebox" style="width:100px" value="${activity.startTime}"/>
                         ~
                         <input type="text" name="endTime" id="endTime" class="easyui-datetimebox" style="width:100px" value="${activity.endTime}"/>
                    </td>
                </tr>
                <tr>
                    <th>活动方式</th>
                    <td>
                    	<select name="activityMode">
			            	<c:forEach items="${activityModes}" var="activityMode">
                    			<option value="${activityMode.value}" <c:if test="${activity.activityMode == activityMode.value}">selected</c:if>>${activityMode.description}</option>
							</c:forEach>
						</select>
                    </td>
                    <th>是否支持乐点</th>
                    <td>
                    	<input name="isSupportLedian" class="easyui-validatebox" type="radio" value="1" data-options="required:true" <c:if test="${activity.isSupportLedian == 1 }">checked="checked"</c:if>/>支持
                    	<input name="isSupportLedian" class="easyui-validatebox" type="radio" value="0" data-options="required:true" <c:if test="${activity.isSupportLedian == 0 }">checked="checked"</c:if>/>不支持
                    </td>
                </tr>
                <tr>
                    <th>活动模板</th>
                    <td>
                    	<select name="templateId">
			            	<c:forEach items="${templates}" var="template">
                    			<option value="${template.templateId}" <c:if test="${activity.templateId == template.templateId}">selected</c:if>>${template.name}</option>
							</c:forEach>
						</select>
                    </td>
                </tr>
                <tr>
                    <th>推广终端</th>
                    <td>
                    	<c:forEach items="${terminals}" var="terminal">
                    	<input type="checkbox" id="terminal${terminal.terminalId}"
										name="terminals" value="${terminal.terminalId}" />&nbsp${terminal.terminalName}
						</c:forEach>
                    </td>
                </tr>
                 <tr>
                    <th>与其他活动互斥/th>
                    <td>
                    	<input name="isExclusion" class="easyui-validatebox" type="radio" value="1" data-options="required:true" <c:if test="${activity.isExclusion == 1}">checked="checked"</c:if>/>否
                    	<input name="isExclusion" class="easyui-validatebox" type="radio" value="0" data-options="required:true" <c:if test="${activity.isExclusion == 0}">checked="checked"</c:if>/>是
                    	<select name="exclusionIds" multiple="multiple">
                    	 <c:choose>
                    		<c:when test='${fn:contains(activity.exclusionIds,0)}'>
								<option id="exclusion0" value="0" selected="selected">全部</option>
							</c:when>
							<c:otherwise>
							<option id="exclusion0" value="0">全部</option>
							</c:otherwise>
						 </c:choose>
                    		<c:forEach items="${activityIds}" var="activityId">
                    		  <c:choose>
                    			<c:when test='${fn:contains(activity.exclusionIds,activityId)}'>
                    			<option id="exclusion${activityId}" value="${activityId}" selected="selected">活动Id${activityId}</option>
								</c:when>
								<c:otherwise>
								<option id="exclusion${activityId}" value="${activityId}">活动Id${activityId}</option>
								</c:otherwise>
							 </c:choose>
                    		</c:forEach>
                    	</select>
                    </td>
                </tr>
            </table>
            
			<table id="addPartQualification" style="width: 780" class="table table-form">
            	<tr><td><a href="javascript:void(0)" onclick="addRowPartQualification();">新增参与资格</a></td></tr>
            	<tr><th>主套餐类型</th><th>子套餐类型</th><th>套餐明细</th><th>活动期间参与次数</th><th>对应赠品</th><th>操作</th></tr>
            	<c:forEach items="${activity.activityBuySend}" var="abs" varStatus="status">
            		<tr>
            		<td><select onChange="packType(this)" style="width: 100px"> 
            				<option value="-1" <c:if test="${abs.packageType == -1}">selected</c:if>>选择套餐类型</option>
            				<option value="1" <c:if test="${abs.packageType == 1}">selected</c:if>>会员套餐</option>
            				<option value="2" <c:if test="${abs.packageType == 2}">selected</c:if>>影视剧</option>
            			</select>
            		</td>
            		<td>
            			<c:if test="${abs.packageType == 1 }">
            				<select name="subPackageType" onChange="vipPackage(1, this)" style="width: 100px">
            					<option <c:if test="${abs.subPackageType == -1 }">selected</c:if> value="-1">选择</option>
								<option <c:if test="${abs.subPackageType == 1 }">selected</c:if> value="1">移动影视会员</option>
								<option <c:if test="${abs.subPackageType == 9 }">selected</c:if> value="9">全屏影视会员</option>							
            				</select>
            			</c:if>
            			<c:if test="${abs.packageType == 2 }">
            				<select name="subPackageType" onChange="vipPackage(2, this)" style="width: 100px">
            					<option <c:if test="${abs.subPackageType == -1 }">selected</c:if> value="-1">选择</option>
								<option <c:if test="${abs.subPackageType == 1 }">selected</c:if> value="1">电影</option>
								<option <c:if test="${abs.subPackageType == 2 }">selected</c:if> value="2">电视剧</option>
            				</select>
            			</c:if>            		
            		</td>            			
            		<td>
            			<c:if test="${abs.packageType == 1 }">
            				<select name="packageDetail" style="width: 100px">
            				    <c:if test="${abs.subPackageType == 1 }">
            				    	<c:forEach items="${packageList1}" var="pack">
            				    		<option value="${pack.duration}" <c:if test="${pack.duration == abs.packageDetail }">selected</c:if>>${pack.durationDesc}</option>
            				    	</c:forEach>
            				    </c:if> 
            				    <c:if test="${abs.subPackageType == 9 }">
            				    	<c:forEach items="${packageList9}" var="pack">
            				    		<option value="${pack.duration}" <c:if test="${pack.duration == abs.packageDetail }">selected</c:if>>${pack.durationDesc}</option>
            				    	</c:forEach>
            				    </c:if>            		           					
            				</select>
            			</c:if>
            			<c:if test="${abs.packageType == 2 }">
            				<input type="text" id="inputSearch${status.index}" class="span2 input-box"  value="${abs.movieName }"/>
							<input type="hidden" name="packageDetail" id="packageDetail${status.index }" class="span2"  value="${abs.packageDetail}"/>	
							<input type="hidden" name="subptype" id="subptype${status.index }" class="span2 subtype"  value="${abs.subPackageType}"/>			
            			</c:if>
            		</td>
            		<td><select name="joinTimes" style="width: 100px">
            				<option value="-1" <c:if test="${abs.joinTimes == -1}">selected</c:if>>新增订单多一次机会</option></select></td>
            		<td><input type="text" name="giftNames" style="width: 100px" value="${abs.giftNames }"/></td>
            		<td><img onclick="delTr(this);" src="/static/style/images/extjs_icons/cancel.png" title="删除"/></td>
            		<td><input type="hidden" name="packageType" value="${abs.packageType}"/></td>
            		</tr>
            	</c:forEach>            	   
			</table>
            
			<table id="addPopupType" style="width: 780" class="table table-form">
            	<tr><td><a href="javascript:void(0)" onclick="addRowPopupType();">新增弹窗类型</a><td></tr>
            	<tr><th>需弹窗类型</th><th>弹窗样式</th><th>弹窗文案</th><th>左按钮文案</th><th>右按钮文案</th><th>操作</th></tr>  
            	<c:forEach items="${activity.activityPopup}" var="app">
            	<tr>
            	  <td>
            	  <select onChange="popType(this)" style="width: 100px">
            			<option value="-1" <c:if test="${app.type == -1}">selected</c:if>>选择弹窗类型</option>
						<option value="1" <c:if test="${app.type == 1}">selected</c:if>>无参与资格</option>
						<option value="2" <c:if test="${app.type == 2}">selected</c:if>>收集用户信息</option>
						<option value="3" <c:if test="${app.type == 3}">selected</c:if>>提交信息</option>
						<option value="4" <c:if test="${app.type == 4}">selected</c:if>>活动结束</option>
				  </select></td> 
				  <td>
				  <select name="popupMode" style="width: 100px">
						<option value="-1" <c:if test="${app.mode == -1}">selected</c:if>>选择</option>
						<c:if test="${app.type == 1}">
							<option value="1" <c:if test="${app.mode == 1}">selected</c:if>>只买会员</option>
							<option value="2" <c:if test="${app.mode == 2}">selected</c:if>>买会员+单点</option>
						</c:if>
						<c:if test="${app.type == 2}">
							<option value="1" <c:if test="${app.mode == 1}">selected</c:if>>只有手机号码</option>
							<option value="2" <c:if test="${app.mode == 2}">selected</c:if>>手机号码+姓名+地址</option>
						</c:if>
						<c:if test="${app.type == 3}">
							<option value="1" <c:if test="${app.mode == 1}">selected</c:if>>提交成功</option>
						</c:if>
						<c:if test="${app.type == 4}">
							<option value="1" <c:if test="${app.mode == 1}">selected</c:if>>只关闭</option>
							<option value="2" <c:if test="${app.mode == 2}">selected</c:if>>关闭+买会员</option>
						</c:if>
				  </select>
				  </td>
				  <td><input type="text" name="popupText" style="width: 150px" value="${app.popupText}"/></td>
				  <td><input type="text" name="leftButtonText" style="width: 80px" value="${app.leftButtonText }"/></td>
				  <td><input type="text" name="rightButtonText" style="width: 80px" value="${app.rightButtonText }"/></td>
				  <td><img onclick="delTr(this);" src="/static/style/images/extjs_icons/cancel.png" title="删除"/></td>
				  <td><input type="hidden" name="popupType" value="${app.type}"/></td>
				  </tr>
            	</c:forEach>         	
            </table>			
        </form>
    </div>
</div>
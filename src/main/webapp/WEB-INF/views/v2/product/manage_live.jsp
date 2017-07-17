<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:if test="${not empty param.singlePage}">
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
</c:if>

<style>
    .stbl{
        width: 100%;
    }
    td {
        padding: 5px;
    }
    .lable{
        margin-right: 10px;
    }
    input[type=text] {
        width: 180px;
        padding-top: 0px;
        padding-bottom: 0px;
    }
    #tryViewTime{
        width: 60px;
    }
    a.underline {
        text-decoration: underline;
    }
    .ui-checkbox input[type="checkbox"]{display:none}
    .ui-checkbox{
        background-color: #fff;
        border:1px solid #1073c2;
        width:13px;
        height:13px;
        display: inline-block;
        text-align: center;
        vertical-align: middle;
        line-height: 12px;
    }
    label.checked{
        background-color: #fff;
    }
    label.checked:after{
        font-size:13px;
        color:#1073c2;
        content:"\2714";
    }
</style>
<c:if test="${not empty activity && not empty activity.copywritings}">
    <c:set var="copywritings" value="${activity.parsedCopywritings}"/>
</c:if>
<div class="easyui-layout" data-options="fit:true,border:false" style="margin-left: 5px;">
    <div data-options="region:'center',border:false" title="">
        <form id="form" method="post" name = "liveVideoForm"
              action="/v2/product/sport_live/manage_live?extendId=${live.extendId}">
            <div>
                <h5>${internationalConfig.直播后台透传信息}</h5>
            </div>
            <div style="margin: 5px;">
                <table class="stbl">
                    <tr>
                        <td>${internationalConfig.场次ID}:</td>
                        <td><input type="text" value="${live.extendId}" readonly="readonly"></td>
                        <td>${internationalConfig.直播名称}:</td>
                        <td><input type="text" value="${live.name}" readonly="readonly"></td>
                    </tr>
                    <tr>
                        <td>${internationalConfig.直播频道}:</td>
                        <c:forEach var="channel" items="${channels}">
                            <c:if test="${channel.type==live.liveType}"><c:set var="channelName" value="${internationalConfig[channel.name]}"/></c:if>
                        </c:forEach>
                        <td><input type="text" value="${channelName}" readonly="readonly"></td>
                        <td>${internationalConfig.直播类型}:</td>
                        <td><input type="text" id="liveClass" value="${liveClass}" readonly="readonly"></td>
                    </tr>
                </table>
            </div>
            <hr style="border-top: dotted 1px;" />
            <div style="margin: 5px;">
                <span class="lable"><b style="color: red">*</b>${internationalConfig.直播试看时长}:</span>
                <input type="text" name="tryViewTime" id="tryViewTime" value="${live.tryViewTime}" class="easyui-validatebox easyui-numberbox" precision="0" min="0" data-options="required:true">&nbsp;&nbsp;${internationalConfig.分钟}
            </div>
            <div style="margin: 5px;">
                <table width="100%">
                    <tr>
                        <td nowrap="nowrap" valign="top">${internationalConfig.内容权益}:</td>
                        <td>
                            <c:forEach items="${aggPackageList}" var="aggPackage">
                                <c:set var="matchPid" value="0" />
                                <c:forEach items="${aggPackageIdList}" var="aggPackageIds">
                                    <c:if test="${aggPackage.id==aggPackageIds}">
                                        <c:set var="matchPid" value="1" />
                                    </c:if>
                                </c:forEach>
                                <c:set var="match" value="0" />
                                <c:forEach var="i" items="${bindedAggPackageIdList}">
                                    <c:if test="${aggPackage.id==i}">
                                        <c:set var="match" value="1" />
                                    </c:if>
                                </c:forEach>
                                <c:choose>
                                    <c:when test="${matchPid==1}">
                                <label class="ui-checkbox checked"> <input type="checkbox" value="${aggPackage.id}" checked="checked"></label><span class="lable">${aggPackage.aggPackageName}</span>
                                    </c:when>
                                    <c:when test="${match==1}">
                                        <input type="checkbox" name="aggPackage" value="${aggPackage.id}" checked="checked"><span class="lable">${aggPackage.aggPackageName}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <input type="checkbox" name="aggPackage" value="${aggPackage.id}"><span class="lable">${aggPackage.aggPackageName}</span>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                            <input type="hidden" name="aggPackages" id="aggPackages" value="${live.aggPackages}">
                        </td>
                    </tr>
                </table>
            </div>
            <div style="margin-top: 10px; margin-bottom: 5px;"><a href="javascript:void(0);" onclick="editLivePackage()" class="underline">${internationalConfig.设置该场次直播券}</a></div>
            <div style="margin: 5px;">
                ${internationalConfig.直播管理_说明}
            </div>
        </form>
    </div>
</div>
<script type="text/javascript">
    $(document).ready(function () {
        parent.$.messager.progress('close');
        $('#form').form({
            url : '/v2/product/sport_live/manage_live?extendId=${live.extendId}',
            onSubmit : function() {
                parent.$.messager.progress({
                    title : '${internationalConfig.提示}',
                    text : '${internationalConfig.数据处理中}....'
                });
                var isValid = $(this).form('validate');
                if (!isValid) {
                    parent.$.messager.progress('close');
                } else {
                    var aggPackages = [];
                    $("input:checked[name='aggPackage']").each(function () {
                        aggPackages.push($(this).val());
                    });
                    var joined = '';
                    if(aggPackages.length!=0)
                        joined = aggPackages.join(',');
                    $("#aggPackages").val(joined);
                }

                return isValid;
            },
            success : function(result) {
                parent.$.messager.progress('close');
                result = $.parseJSON(result);
                if (result.code == 0) {
                    parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.编辑成功}', 'success');
                    parent.$.modalDialog.handler.dialog('close');
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                } else {
                    parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
                }
            },
            error: function(result){
                parent.$.messager.progress('close');
                parent.$.messager.alert('${internationalConfig.错误}', result, 'error');
            }
        });
    });
    function editLivePackage(){
        parent.$.modalDialog2({
            title : '直播套餐设置',
            width : 780,
            height : 580,
            href : '${pageContext.request.contextPath}/v2/product/livePackage/livePackageInfo?id=0&extendId=${live.extendId}&pid=${live.matchId}&matchId=${live.matchId}&itemId=${live.itemId}&baseInfoReadOnly=true&name='+encodeURIComponent('${live.name}'),
            buttons : [ {
                text : '${internationalConfig.保存}',
                handler : function() {
                    var f = parent.$.modalDialog2.handler.find('#form1');
                    f.submit();
                }
            } , {
                text : "${internationalConfig.取消}",
                handler : function() {
                    parent.$.modalDialog2.handler.dialog('close');
                }
            } ]
        });
    }
    /*$('.ui-checkbox').unbind('click').click(function(e){
        if(e.target.tagName.toUpperCase()=='LABEL'){
            $(this).toggleClass('checked');
        }
    })*/
</script>
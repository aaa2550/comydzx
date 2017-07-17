<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script src="/static/lib/swfupload/swfupload.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
    $(function() {
        parent.$.messager.progress('close');
        (function($){
            $.fn.serializeJson=function(){

                var serializeObj={};
                var array=this.serializeArray();
                $(array).each(function(){ // 遍历数组的每个元素 {name : xx , value : xxx}
                    if(serializeObj[this.name]){ // 判断对象中是否已经存在 name，如果存在name
                        serializeObj[this.name]+=","+this.value;
                    }else{
                        serializeObj[this.name]=this.value; // 如果元素name不存在，添加一个属性 name:value
                    }
                });
                return serializeObj;
            }
            /*$('.ui-checkbox').unbind('click').click(function(e){
                if(e.target.tagName.toUpperCase()=='LABEL'){
                    $(this).toggleClass('checked');
                }
            })*/
        })(jQuery)

    });
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
        },
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
	    /*//付费类型必选
	    checkbox: {
            validator: function (value, param) {
                var frm = param[0], groupname = param[1], checkNum = 0;
                $('input[name="' + groupname + '"]', document[frm]).each(function () { //查找表单中所有此名称的checkbox
                    if (this.checked) checkNum++;
                });
                return checkNum > 0;
            },
            message: '请选择付费类型'
        }*/
    });
    function editLivePackage(){
        parent.$.modalDialog2({
            title : '直播套餐设置',
            width : 780,
            height : 580,
            href : '${pageContext.request.contextPath}/v2/product/livePackage/livePackageInfo?pid=${matchId}&matchId=${matchId}&itemId=${itemId}&baseInfoReadOnly=true&name='+encodeURIComponent('${param.description}'),
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
</script>

<style type="text/css">
    #form table tr th{
        vertical-align:middle;
        width:90px;
    }
    #form table tr td select{
        width:180px;
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
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="">
        <form id="form" method="post" name="matchForm"
              action="/play_package/create.json">
            <table style="width: 100%" class="table table-form">
                <input type="hidden" name="matchId" readonly value="${matchId}"/>
                <tr>
                    <th>${internationalConfig.赛事}ID</th>
                    <td colspan="3"><input type="text" name="itemId" readonly value="${itemId}"/></td>
                </tr>
                <tr>
                    <th>${internationalConfig.赛事名称}</th>
                    <td colspan="3"><input type="text" id="itemName" readonly name="itemName" value="${param.description}"/></td>
                </tr>
                <tr>
                    <th>${internationalConfig.内容特权}</th>
                    <td colspan="3" >
                        <p>
                            <c:forEach items="${aggPackageList}" var="aggPackage">
                                <span style="display: inline-block">
                                	<c:set var="match" value="0" />
			        		        <c:forEach items="${aggPackageContent}" var="bindedId">
                                        <c:if test="${aggPackage.id==bindedId.aggPackageId}">
                                            <c:set var="match" value="1" />
                                        </c:if>
                                    </c:forEach>

                                    <c:set var="matchPid" value="0" />
                                    <c:forEach items="${aggPackageIdList}" var="aggPackageIds">
                                        <c:if test="${aggPackage.id==aggPackageIds}">
                                            <c:set var="matchPid" value="1" />
                                        </c:if>
                                </c:forEach>

                                <c:choose>
                                    <c:when test="${matchPid==1}">
                                        <label class="ui-checkbox checked"><input id="aggPackage_${aggPackage.id}" type="checkbox" checked="checked" value="${aggPackage.id}"/></label>${aggPackage.aggPackageName} &nbsp;&nbsp;
                                    </c:when>
                                    <c:when test="${match==1}">
                                        <input id="aggPackage_${aggPackage.id}" type="checkbox" name="aggPackageIdList" checked="checked" value="${aggPackage.id}"/>${aggPackage.aggPackageName} &nbsp;&nbsp;
                                    </c:when>
                                    <c:otherwise>
                                        <input id="aggPackage_${aggPackage.id}" type="checkbox" name="aggPackageIdList" value="${aggPackage.id}"/>${aggPackage.aggPackageName} &nbsp;&nbsp;
                                    </c:otherwise>
                                </c:choose>

                                </span>
                            </c:forEach>
                        <p>
                    </td>
                </tr>
                <tr>
                    <td colspan="5">
                        <div style="margin-top: 5px; margin-bottom: 5px"><a href="javascript:void(0);" onclick="editLivePackage()" class="underline">${internationalConfig.设置该赛事直播券}</a></div>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
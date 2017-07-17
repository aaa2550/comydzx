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
    .red_star{
        margin-right: 5px;
        color: red;
    }
    .short_input{
        width: 140px;
    }
    .main_table{
        margin:10px 0 10px 10px;
        line-height: 30px;
        overflow: hidden;
    }
    input[type=text]{
        padding-top: 0;
        padding-bottom: 0;
    }
</style>
<c:choose>
    <c:when test="${not empty coupon}"><c:set var="action" value="edit"/></c:when>
    <c:otherwise><c:set var="action" value="create"/></c:otherwise>
</c:choose>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="">
        <form id="form" method="post" name = "activityForm" action="/v2/coupon/header/${action}">
            <input type="hidden" name="type" value="${action=='create'?param.type:coupon.type}">
            <table class="main_table">
                <c:if test="${coupon!=null}">
                    <td width="100">
                        <span class="red_star">*</span>
                            ${internationalConfig.批次号}
                    </td>
                    <td><input type="text" name="batchId" value="${coupon.batchId}" readonly="readonly"></td>
                </c:if>
                <tr>
                    <td width="100">
                        <span class="red_star">*</span>
                        ${internationalConfig.代金券名称}
                    </td>
                    <td><input type="text" name="name" id="name" class="easyui-validatebox" data-options="required:true" value="${coupon.name}"></td>
                </tr>
                <tr>
                    <td>
                        <span class="red_star">*</span>
                        ${internationalConfig.代金券面额}
                    </td>
                    <td>
                        <input type="text" name="amount" value="${coupon.amount}" class="easyui-validatebox easyui-numberbox" data-options="required:true,min:0.01" precision="2">&nbsp;${internationalConfig.元}
                    </td>
                </tr>
                <c:if test="${param.type==2||(coupon!=null&&coupon.type==2)}">
                    <tr>
                        <td>
                            <span class="red_star">*</span>
                                ${internationalConfig.代金券有效期}
                        </td>
                        <td>
                            <input type="text" name="validDays" value="${coupon.validDays}" class="easyui-validatebox easyui-numberbox" data-options="required:true,min:1" precision="0">&nbsp;${internationalConfig.天}
                        </td>
                    </tr>
                </c:if>
                <tr>
                    <td>
                        <span class="red_star">*</span>
                        <c:choose><c:when test="${(coupon==null&&param.type==1)||(coupon!=null&&coupon.type==1)}">${internationalConfig.代金券有效期}</c:when>
                            <c:otherwise>${internationalConfig.实时抽取有效期}</c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <input name="validStartTime" id="validStartTime" value="<fmt:formatDate value="${coupon.validStartTime}" pattern="yyyy-MM-dd HH:mm:ss"/>" <c:if test="${empty coupon}"> class="short_input easyui-datetimebox" data-options="required:true,validType:'timeNoEarlierThanToday[\'yyyy-MM-dd HH:mm:ss\']'"</c:if>>
                        &nbsp;&nbsp;${internationalConfig.到}&nbsp;&nbsp;
                        <input name="validEndTime" id="validEndTime" value="<fmt:formatDate value="${coupon.validEndTime}" pattern="yyyy-MM-dd HH:mm:ss"/>" <c:if test="${empty coupon}"> class="short_input easyui-datetimebox" data-options="required:true,validType:'timeLaterThan[\'input[name=validStartTime]\',\'yyyy-MM-dd HH:mm:ss\']'"</c:if>>
                    </td>
                </tr>
                <c:if test="${(coupon!=null&&coupon.type==2)||(coupon==null&&param.type==2)}">
                    <tr>
                        <td>
                            <span class="red_star">*</span>
                                ${internationalConfig.同一用户限制}
                        </td>
                        <td>
                            <input type="text" name="sameUserQtyLimit" value="${coupon.sameUserQtyLimit}" class="easyui-validatebox easyui-numberbox" data-options="required:true,min:0" precision="0">&nbsp;${internationalConfig.零为不限制}
                        </td>
                    </tr>
                </c:if>
                <tr>
                    <td valign="top">
                        <span class="red_star">*</span>
                        ${internationalConfig.应用范围}
                    </td>
                    <td>
                        <div><input type="radio" name="businessTypesOption" id="businessTypesOption1" value="1">${internationalConfig.生态通用}</div>
                        <div style="float: left"><input type="radio" name="businessTypesOption" id="businessTypesOption2" value="2">${internationalConfig.业务专享}</div>
                        <div style="float:left;width: 220px;margin-left: 10px">
                            <input type="checkbox" name="businessTypes2" value="1">${internationalConfig.影视会员}&nbsp;&nbsp;
                            <input type="checkbox" name="businessTypes2" value="2">${internationalConfig.体育会员}&nbsp;&nbsp;
                            <input type="checkbox" name="businessTypes2" value="4">${internationalConfig.音乐会员}&nbsp;&nbsp;
                            <input type="checkbox" name="businessTypes2" value="8">${internationalConfig.单片购买}&nbsp;&nbsp;
                            <input type="checkbox" name="businessTypes2" value="16">${internationalConfig.直播券购买}
                        </div>
                        <input type="hidden" name="businessTypes" id="businessTypes">
                    </td>
                </tr>
                <tr>
                    <td valign="top">
                        <span class="red_star">*</span>
                        ${internationalConfig.使用条件}
                    </td>
                    <td>
                        <div><input type="radio" name="amountLimit" id="amountLimitOption1" value="1">${internationalConfig.满减限制}&nbsp;&nbsp;
                            ${internationalConfig.订单满}<input type="text" name="_orderAmountLimit" id="_orderAmountLimit" value="${coupon.orderAmountLimit>0.00?coupon.orderAmountLimit:''}" <c:if test="${empty coupon}">class="easyui-numberbox" data-options="validType:'requiredAmountLimit',min:0.01" precision="2"</c:if>>${internationalConfig.元可用}
                        </div>
                        <div>
                            <input type="radio" name="amountLimit" id="amountLimitOption2" value="2">${internationalConfig.无条件使用}
                        </div>
                        <input type="hidden" name="orderAmountLimit" id="orderAmountLimit" value="${coupon.orderAmountLimit}">
                    </td>
                </tr>
                <tr>
                    <td>
                        <span class="red_star">*</span>
                        ${internationalConfig.发行量}
                    </td>
                    <td>
                        <input type="text" name="totalQty" value="${coupon.totalQty}" class="easyui-validatebox easyui-numberbox" data-options="required:true,min:1" precision="0">&nbsp;${internationalConfig.张}
                    </td>
                </tr>
                <tr>
                    <td>
                        <span class="red_star">&nbsp;</span>
                        ${internationalConfig.申请人}
                    </td>
                    <td>
                        <input type="text" name="applicant" id="applicant" value="${coupon.applicant}">
                    </td>
                </tr>
                <tr>
                    <td>
                        <span class="red_star">&nbsp;</span>
                        ${internationalConfig.关联活动}
                    </td>
                    <td>
                        <input type="text" name="relatedActivity" id="relatedActivity" value="${coupon.relatedActivity}">
                    </td>
                </tr>
                <tr>
                    <td>
                        <span class="red_star">&nbsp;</span>
                        ${internationalConfig.备注}
                    </td>
                    <td>
                        <textarea name="remarks" id="remarks" style="width: 250px;height: 50px">${coupon.remarks}</textarea>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
<script src="/static/lib/date.js"></script>
<script>
    $.extend($.fn.validatebox.defaults.rules, {
        requiredAmountLimit: {
            validator: function (value, param) {
                if($("#amountLimitOption1").is(":checked").length!=0) {
                    return $.trim(value).length!='';
                } else
                    return true;
            },
            message: $.fn.validatebox.defaults.missingMessage
        },
        timeLaterThan: {
            validator: function(value, param) {
                var tmThis=Date.parse(value, param[1]);
                var valueCompare=/^\d/.test(param[0])?param[0]:$(param[0]).val();
                var tmCompare=Date.parse(valueCompare, param[1]);
                return tmThis>tmCompare;
            },
            message: "${internationalConfig.结束时间不能早于开始时间}"
        },
        timeNoEarlierThanToday: {
            validator: function(value, param) {
                var tmThis=Date.parse(value, param[0]);
                return tmThis>=Date.today();
            },
            message: "${internationalConfig.起始时间不能早于当前时间}"
        }
    });
    $(document).ready(function() {
        parent.$.messager.progress('close');
        <c:choose><c:when test="${readOnly=='Y'}">setAllReadOnly();</c:when>
        <c:otherwise>
        /*自动去除前后空白*/
        $("input[type=text]").change(function(){
            var _self=$(this);
            _self.val($.trim(_self.val()));
        });
        </c:otherwise>
        </c:choose>
        <c:if test="${coupon!=null}">
        //初始化单选/复选框
        initCheckBoxes();
        </c:if>
        <c:if test="${readOnly!='Y'&&coupon!=null}">
        setAllReadOnly(['name','remarks','applicant','relatedActivity']);
        </c:if>
        <c:if test="${empty coupon}">
        $('input[name=businessTypes2]').click(function(){
            var btClass=$("input[name=businessTypesOption]:checked");
            if (btClass.length==0||btClass.val()=='1')
                return false;
        });
        $('#businessTypesOption1').click(function() {
            // ”生态通用“被选中，则取消业务专享的选中状态
            $('input[name=businessTypes2]').removeAttr("checked");
        });
        $('input[name=amountLimit]').click(function() {
            var _orderAmountLimit=$('#_orderAmountLimit');
            var actualInput=_orderAmountLimit.parent().find("input[type=text]"); // easyui 会将原始input替换掉，所以改变原ID的属性达不到目的
            if($(this).val()==='1') {
                actualInput.removeAttr('readonly');
            } else {
                _orderAmountLimit.numberbox('setValue', '');
                actualInput.val('');
                actualInput.attr('readonly','readonly');
            }
        });
        // 初始情况下没有任务满减条件被选中，满减输入框置灰
        setTimeout(function(){$('#_orderAmountLimit').parent().find("input[type=text]").attr('readonly','readonly')}, 100);
        </c:if>
        <c:if test="${readOnly!='Y'}">
        $('#name').change(function(){
            var value = $(this).val();
            $.getJSON('/v2/coupon/header/validate/name',{name:value<c:if test="${coupon!=null}">,batchId:$('#batchId').val()</c:if>}, function(result){
                if(result.code==1) {
                    parent.$.messager.alert("${internationalConfig.错误}", "${internationalConfig.代金券名称已存在}", 'error');
                }
            });
        });
        </c:if>
    });
    function setAllReadOnly(excludeIds){
        $("input").each(function(){
            var _self = $(this);
            if(excludeIds) {
                for(var i in excludeIds)
                    if(excludeIds[i]==_self.attr('id'))
                        return;
            }
            _self.attr("readonly", "readonly");
        });
        $(':radio,:checkbox').click(function(){
            return false;
        });
        if ($.inArray('remarks', excludeIds) === -1)
            $('textarea').attr("readonly", "readonly");
    }
    <c:if test="${coupon!=null}">
    function initCheckBoxes(){
        var businessTypes=${coupon.businessTypes};
        if(businessTypes==0x7FFFFFFF){
            $("#businessTypesOption1").attr("checked", "checked");
        } else {
            $("#businessTypesOption2").attr("checked", "checked");
            $("input[name=businessTypes2]").each(function() {
                var _self=$(this);
                if(parseInt(_self.val())&businessTypes){
                    _self.attr("checked", "checked");
                }
            });
        }

        var orderAmountLimit=${coupon.orderAmountLimit};
        if (orderAmountLimit!=0.00)
            $("#amountLimitOption1").attr("checked", "checked");
        else
            $("#amountLimitOption2").attr("checked", "checked");
    }
    </c:if>

    $(function onSubmit() {
        $('#form').form({
            url : '/v2/coupon/header/${action}',
            method: "POST",
            onSubmit : function() {
                parent.$.messager.progress({
                    title : "${internationalConfig.提示}",
                    text : "${internationalConfig.数据处理中}"
                });
                var isValid = true;
                <c:if test="${action=='create'}">
                isValid = $(this).form('validate');
                if (!isValid) {
                    parent.$.messager.progress('close');
                    return isValid;
                }
                var bt=$("input[name=businessTypesOption]:checked");
                if(bt.length==0) {
                    parent.$.messager.progress('close');
                    parent.$.messager.alert("${internationalConfig.错误}", "${internationalConfig.应用范围必选}", 'error');
                    return false;
                } else if(bt.val()=='1') {
                    var value = 0x7FFFFFFF;
                    $("#businessTypes").val(value);
                } else if(bt.val()=='2'){
                    var businessTypes = $("input[name=businessTypes2]:checked");
                    if (businessTypes.length==0) {
                        parent.$.messager.progress('close');
                        parent.$.messager.alert("${internationalConfig.错误}", "${internationalConfig.应用范围必选}", 'error');
                        return false;
                    } else {
                        var btsValues = 0;
                        businessTypes.each(function(){
                            var value = parseInt($(this).val());
                            btsValues=btsValues|value;
                        });
                        $("#businessTypes").val(btsValues);
                    }
                }
                var amountLimitType = $("input[name=amountLimit]:checked");
                if (amountLimitType.length==0) {
                    parent.$.messager.progress('close');
                    parent.$.messager.alert("${internationalConfig.错误}", "${internationalConfig.使用条件必选}", 'error');
                    return false;
                } else if(amountLimitType.val()=='1'&&$("#_orderAmountLimit").val()=='') {
                    parent.$.messager.progress('close');
                    parent.$.messager.alert("${internationalConfig.错误}", "${internationalConfig.满减条件不能为空}", 'error');
                    return false;
                } else {
                    if(amountLimitType.val()=='1')
                        $("#orderAmountLimit").val($("#_orderAmountLimit").val());
                    else
                        $("#orderAmountLimit").val("0.00");
                }
                </c:if>
                return isValid;
            },
            success : function(result) {
                parent.$.messager.progress('close');
                result = $.parseJSON(result);
                if (result.code == 0) {
                    parent.$.messager.alert("${internationalConfig.成功}", '${action}'=='create'?'${internationalConfig.创建成功}':'${internationalConfig.编辑成功}', 'success');
                    parent.$.modalDialog.handler.dialog('close');
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
                } else {
                    parent.$.messager.alert("${internationalConfig.错误}", result.msg, 'error');
                }
            },
            error: function(result){
                parent.$.messager.progress('close');
                parent.$.messager.alert("${internationalConfig.错误}", result, 'error');
            }
        });
    });

</script>
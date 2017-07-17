<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:if test="${param.singlePage==1}">
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
</c:if>
<style>
    .main_table tr{
        line-height: 30px;
        overflow: hidden;
    }
    .main_table th, .table td {
        border:0;
        vertical-align: middle;
        padding: 5px;
    }
    .single_line_table td{
        padding-left: 10px;
    }
    .top_border_line{
        border-top: 1px solid #ddd;
    }
    .narrowbox {
        width: 40px;
        padding-top: 0px !important;
        padding-bottom: 0px !important;
    }
</style>

<div class="easyui-layout" data-options="fit:true,border:false" style="width: 800px; height: 600px">
    <div data-options="region:'center',border:true" title="">
        <form id="form" method="post">
            <input name="chargePlatform" type="hidden" value="">

            <table style="width: 100%;" class="main_table table-form">
                <tr>
                    <th width="120px">${internationalConfig.内容名称}</th>
                    <td><input name="name" type="text" value="${movie.name}" readonly="readonly"></td>

                    <td rowspan="5" style="vertical-align:middle;text-align:center;">${internationalConfig.缩略图}&nbsp;&nbsp;<img src="${movie.pic}" style="width: 120px;height: 160px;" alt="${internationalConfig.无}"/></td>
                </tr>
                <tr>
                    <th>${internationalConfig.内容ID}</th>
                    <td><input name="id" type="text" value="${movie.id}" readonly="readonly"></td>
                </tr>
                <tr>
                    <th>${internationalConfig.内容分类}</th>
                    <td><input type="text" value="${movie.chargeRule==3?internationalConfig.视频:internationalConfig.视频}" readonly="readonly"></td>
                </tr>
                <tr>
                    <th>${internationalConfig.频道}</th>
                    <td><input type="text" value="${dict["channel"][movie.channel ] }" readonly="readonly"></td>

                </tr>
                <tr>
                    <th>${internationalConfig.试看时长}</th>
                    <td><input name="tryLookTime" type="text" value="${movie.tryLookTime}" class="easyui-numberbox" data-options="min:0,max:360,required:true"></td>
                </tr>


                <tr class="top_border_line">
                	<th>${internationalConfig.是否收费}</th>
                    <td>
                        <input name="isCharge" type="radio" value="1" <c:if test="${movie.isCharge==1}">checked="checked"</c:if>/>${internationalConfig.付费}&nbsp;&nbsp;
                        <input name="isCharge" type="radio" value="0" <c:if test="${movie.isCharge==0}">checked="checked"</c:if>/>${internationalConfig.免费}
                    </td>
                    <td>
                        <input type="checkbox" id="supportTicket" name="supportTicket" value="1" ${movie.chargeType==0?(movie.supportTicket==1?'checked':''):'disabled'}>&nbsp;${internationalConfig.支持观影券}
                    </td>
                </tr>
                <tr>
                    <th>${internationalConfig.播放平台}</th>
                    <td colspan="3">
                        <c:forEach items="${terminalList}" var="terminal">
                            <input type="checkbox" disabled="disabled" value="${terminal.terminalId}" <c:if test="${fn:contains(selectedPlayPlatforms, terminal.terminalId)}">checked="checked"</c:if>>${terminal.terminalName}&nbsp;&nbsp;&nbsp;&nbsp;
                        </c:forEach>
                    </td>
                </tr>
                <tr>
                    <th>${internationalConfig.收费平台}</th>
                    <td colspan="2">
                        <c:forEach items="${terminalList}" var="terminal">
                            <input type="checkbox" name="terminalList" value="${terminal.terminalId}" <c:if test="${fn:contains(selectedTerminalIds, terminal.terminalId)}">checked="checked"</c:if>>${terminal.terminalName}&nbsp;&nbsp;&nbsp;&nbsp;
                        </c:forEach>
                    </td>
                </tr>
                <tr>
                    <th>${internationalConfig.付费类型}</th>
                    <td colspan="2">
                        <input type="hidden" id="chargeType" name="chargeType" value="${movie.chargeType}">
                        <input id="chargeType_t" name="chargeType_" type="checkbox" value="0" <c:if test="${movie.chargeType==0 || movie.chargeType==1}">checked="checked"</c:if>/>
                        ${internationalConfig.单片购买定价方案}&nbsp;
                        <select name="chargeId" id="chargeId">
                            <option value="0" <c:if test="${movie.chargeId==0}">selected="selected"</c:if>>${internationalConfig.无}</option>
                            <c:forEach var="charge" items="${charges}">
                                <option value="${charge.chargeId }"   ${charge.chargeId == movie.chargeId ? "selected":"" }>${charge.chargeName }</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>&nbsp;</th>
                    <td colspan="2">
                        <input id="chargeType_v" name="chargeType_" type="checkbox" value="2" <c:if test="${movie.chargeType==1 || movie.chargeType==2}">checked="checked"</c:if>/>${internationalConfig.会员购买}
                        <p style="margin-left: 20px">
                            <c:forEach items="${aggPackageList}" var="aggPackage">
                                <span style="display:inline-block">
                                	<c:set var="match" value="0" />
			        		        <c:forEach items="${bindedAggPackageIdList}" var="bindedId">
                                        <c:if test="${aggPackage.id==bindedId}">
                                            <c:set var="match" value="1" />
                                        </c:if>
                                    </c:forEach>
	        		        		<input id="aggPackage_${aggPackage.id}" type="checkbox" name="aggPackageList" value="${aggPackage.id}" <c:if test="${movie.chargeType == 0 }"> </c:if> <c:if test="${match==1}"> checked="checked" </c:if> /> ${aggPackage.aggPackageName} &nbsp;&nbsp;
                                </span>
                            </c:forEach>
                        </p>
                    </td>
                </tr>
                <c:choose>
                <c:when test="${movie.chargeRule==3}">
                <tr style="display: none"><td colspan="3">
                    <input type="hidden" name="chargeRule" value="3">
                </td></tr>
                </c:when><c:otherwise>
                <tr class="top_border_line">
                    <th colspan="4">${internationalConfig.专辑内付费视频定义}</th>
                </tr>
                <tr>
                    <td></td>
                    <td colspan="2">
                        <input name="chargeRule" type="radio" value="1" <c:if test="${fromVrs==false&&movie.chargeRule==1}">checked="checked"</c:if>>${internationalConfig.全部正片}&nbsp;&nbsp;&nbsp;&nbsp;
                        <input name="chargeRule" type="radio" value="4" <c:if test="${fromVrs==false&&movie.chargeRule==4}">checked="checked"</c:if>>${internationalConfig.全部视频}&nbsp;&nbsp;&nbsp;&nbsp;
                        <input name="chargeRule" type="radio" value="5" <c:if test="${fromVrs==false&&movie.chargeRule==5}">checked="checked"</c:if>>${internationalConfig.自定义}&nbsp;&nbsp;&nbsp;&nbsp;
                        <input name="chargeRule" type="radio" value="2" <c:if test="${fromVrs==false&&movie.chargeRule==2}">checked="checked"</c:if>>${internationalConfig.付费规则C}
                    </td>
                </tr>
                <tr id="videosTr">
                    <td></td>
                    <td colspan="2">
                        <div id="videosDiv" class="easyui-layout" data-options="fit:true,border:false" style="height: 200px;">
                            <div data-options="region:'center',border:false">
                                <table id="dg2"></table>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr class="chargeRuleDetailTr" style="${movie.chargeRule==2?'display: table-row;':'display: none;'}">
                    <th>${internationalConfig.付费规则C}</th>
                    <td colspan="2">
                        <input name="ruleType" type="hidden" value="4"/>
                        ${internationalConfig.前}&nbsp;<input type="text" id="preEpisodesFree" name="preEpisodesFree" class="easyui-numberbox narrowbox required-when-rule" data-options="precision:0,min:0" value="${movieVideoRule.totalFreeCount==0?movieVideoRule.preEpisodesFree:movieVideoRule.totalFreeCount}">&nbsp;${internationalConfig.集免费}，${internationalConfig.仅最新}&nbsp;
                        <input type="text" id="latestEpisodesPay" name="latestEpisodesPay" class="easyui-numberbox narrowbox" data-options="precision:0,min:1" validType="choice" value="${movieVideoRule.latestEpisodesPay==0?'':movieVideoRule.latestEpisodesPay}">&nbsp;${internationalConfig.集} / ${internationalConfig.最近}&nbsp;
                        <input type="text" id="dayCycle" name="dayCycle" class="easyui-numberbox narrowbox" data-options="precision:0,min:1" validType="choice" value="${movieVideoRule.dayCycle==0?'':movieVideoRule.dayCycle}">&nbsp;${internationalConfig.天内容需要付费}
                    </td>
                </tr>
                <tr class="chargeRuleDetailTr" style="${movie.chargeRule==2?'display: table-row;':'display: none;'}">
                    <td></td>
                    <td colspan="2">
                        ${internationalConfig.规则应用时间}&nbsp;<input type="text" id="regularTime" name="regularTime" value="${movieVideoRule.regularTime}" class="easyui-validatebox narrowbox required-when-rule" validType="regularTime"/>
                    </td>
                </tr>
                </c:otherwise>
                </c:choose>

                <tr class="top_border_line">
                    <th style="text-align: center !important;">${internationalConfig.状态}</th>
                    <td>
                        <select name="status" id="status">
                            <option value="0" <c:if test="${movie.status==0}">selected="selected"</c:if>>${internationalConfig.未发布}</option>
                            <option value="1" <c:if test="${movie.status==1}">selected="selected"</c:if>>${internationalConfig.已发布}</option>
                            <option value="2" <c:if test="${movie.status==2}">selected="selected"</c:if>>${internationalConfig.定时发布}</option>
                        </select>
                    </td>
                    <td nowrap="nowrap"><span class="fixedTimeSpan" <c:if test="${movie.status != 2 }">style="display:none"</c:if>>
                        ${internationalConfig.定时发送时间}&nbsp;&nbsp;
                        <input type="text" name="fixedTime" id="fixedTime" value="<fmt:formatDate value="${movie.fixedTime}" type="both"/>" class="easyui-datetimebox"/>
                        </span>
                    </td>
                </tr>
            </table>
            <span id="videoChargeInfoSpan" style="display: none"></span>
        </form>
    </div>
</div>
<script type="text/javascript">
    $(document).ready(function(){
        <c:if test="${movie.chargeRule!=3}">
        (function() {
            $('#dg2').datagrid({
                url: '/v2/product/video/listVrsAlbumVideos?pid=${movie.id}&all=true&_t=<%=System.currentTimeMillis()%>',
                method: 'GET',
                fit: true,
                fitColumns: true,
                border: false,
                idField: 'id',
                pagination : false,
                checkOnSelect: true,
                selectOnCheck: true,
                singleSelect: true,
                nowrap: false,
                striped: true,
                rownumbers: true,
                columns: [[
                    {
                        field: 'porder',
                        title: '<span id="ckAllSpan"></span>',
                        width: 30,
                        align: 'center',
                        formatter: function(value,row,index) {
                            var html = $.formatString('<input type="checkbox" name="vids" id="vid_{0}" value="{1}" chcked="{2}" {3}>', index, row.id, row.isPay==0?'false':'true', row.isPay==0?'':'checked="checked"');
                            return html;
                        }
                    },{
                        field: 'id',
                        title: 'VID',
                        width: 100
                    },{
                        field: 'nameCn',
                        title: '${internationalConfig.视频名称}',
                        width: 200,
                        formatter: function(value,row,index){
                            <c:choose>
                            <c:when test="${currentCountry==86 || currentCountry == 852}">
                            return row.nameCn ? row.nameCn : row.nameEn;
                            </c:when><c:otherwise>
                            return row.nameEn ? row.nameEn : row.nameCn;
                            </c:otherwise>
                            </c:choose>
                        }
                    },{
                        field: 'videoType',
                        title: '${internationalConfig.视频类型}',
                        width: 100,
                        formatter: function(value,row,index) {
                            for (var key in value)
                                return value[key];
                        }
                    },{
                        field: 'isPay',
                        title: '${internationalConfig.当前付费状态}',
                        width: 100,
                        formatter: function(value) {
                            return value==0?'${internationalConfig.免费}':'${internationalConfig.付费}';
                        }
                    }
                ]],
                onLoadSuccess : function(data) {
                    if(!data.rows||data.rows.length==0){
                        //$('#videosTr').hide();
                        parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.专辑下没有视频}', 'error');
                    }else{
                        $('#ckAllSpan').html('<input type="checkbox" id="ckAll">');
                        $('#ckAll').click(function(){
                            var checked=$(this).prop('checked');
                            var vids = $('[id^=vid_]');
                            vids.prop('checked', checked);
                            vids.attr('chcked', checked?"true":"false");
                        });
                        var allSelected = true;
                        for(var i in data.rows){
                            if(data.rows[i].isPay==0){
                                allSelected = false;
                                break;
                            }
                        };
                        if(allSelected) $('#ckAll').prop("checked", true);
                    }
                },
                onSelect:function(index, row){
                    var ck = $('#vid_'+index);
                    var checkedEarlier = ck.attr("chcked") == 'true';
                    ck.prop('checked', !checkedEarlier);
                    ck.attr("chcked", !checkedEarlier);
                    if (checkedEarlier){
                        $('#ckAll').prop("checked", false);
                    } else if ($('[id^=vid_]').not(":checked").length==0) {
                        $('#ckAll').prop("checked", true);
                    }
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
        })();
        </c:if>
    });
    $(function(){
        <%-- 是否付费变化 --%>
        $("input[name=isCharge]").change(function(){
            var _self = $(this);
            if (_self.val()==='0'){
                $("input[name=terminalList],input[name=aggPackageList]").each(function(){
                    $(this).prop("checked", false);
                });
            }
        });
        <%-- 状态变化 --%>
        $('#status').change(function() {
            var status = $("#status").val();
            if (status == 2) {
                $(".fixedTimeSpan").show();
            } else {
                $(".fixedTimeSpan").hide();
            }
        });
        <%-- 付费类型变化 兼容老版本。单片付费0，会员购买2，两者都选1--%>
        $('input:checkbox[name=chargeType_]').click(function(){
            var chargeTypeHidden = $('#chargeType');
            var checkboxes=$('input:checkbox[name=chargeType_]:checked');
            if (checkboxes.length==0){
                chargeTypeHidden.val('');
            }else if(checkboxes.length==2){
                chargeTypeHidden.val('1');
            }else if(checkboxes.length==1){
                var self=$(this);
                var checked = self.prop('checked');
                if (checked) {
                    chargeTypeHidden.val(self.val()=='0'?'0':'2');
                } else {
                    chargeTypeHidden.val(self.val()=='0'?'2':'0');
                }
            }
            var self=$(this);
            if(self.attr("id")=='chargeType_v'){
                var checked = self.prop("checked");
                var st = $('#supportTicket');
                st.prop('checked', false);
                st.prop('disabled', checked);
            }
        });
        <%-- 付费规则变化 --%>
        <c:if test="${movie.chargeRule==2}">
        $('.required-when-rule').validatebox({required:true});
        </c:if>
        $('#latestEpisodesPay').numberbox({
            onChange: function(newValue,oldValue){
                if(newValue!=''){
                    $('#dayCycle').numberbox('setValue', '');
                }
            }
        });
        $('#dayCycle').numberbox({
            onChange: function(newValue,oldValue){
                if(newValue!=''){
                    $('#latestEpisodesPay').numberbox('setValue', '');
                }
            }
        });
        $('input[name=chargeRule]').click(function(){
            var value = $(this).val();
            var dg = $('#dg2');
            var rows = dg.datagrid("getRows");
            switch(parseInt(value)){
                case 1: // 全部正片
                    for(var i in rows){
                        var videoType=rows[i].videoType;
                        var vidCheckbox = $('#vid_'+i);
                        var checked = videoType&&videoType.hasOwnProperty('180001');
                        vidCheckbox.prop('checked', checked);
                        vidCheckbox.attr('chcked', checked?'true':'false');
                    }
                    $('.required-when-rule').validatebox({required:false});
                    $('.chargeRuleDetailTr').hide();
                    break;
                case 2: // 付费规则
                    $('.chargeRuleDetailTr').show();
                    $('.required-when-rule').validatebox({required:true});
                    break;
                case 4: // 全部视频
                    var vids = $('[id^=vid_]');
                    vids.prop('checked', true);
                    vids.attr('chcked', 'true');
                    $('.required-when-rule').validatebox({required:false});
                    $('.chargeRuleDetailTr').hide();
                    break;
                case 5: // 自定义
                    $('.required-when-rule').validatebox({required:false});
                    $('.chargeRuleDetailTr').hide();
                    break;
            }
        });
    });

    $(function () {
        parent.$.messager.progress('close');
        $('#form').form({
            url: '/v2/product/video/v2/save',
            onSubmit: function () {
                parent.$.messager.progress({
                    title: '${internationalConfig.提示}',
                    text: '${internationalConfig.数据处理中}....'
                });

                var isValid = $(this).form('validate');
                if (!isValid) {
                    parent.$.messager.progress('close');
                    return isValid;
                }

                <c:if test="${movie.chargeRule!=3}">
                if ($('#dg2').datagrid("getRows").length==0){
                    parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.专辑下没有视频}', 'error');
                    parent.$.messager.progress('close');
                    return false;
                }
                </c:if>

                var isCharge = $('input:radio[name="isCharge"]:checked').val();
                var chargePlatformMissing = true;
                var chargeTypeMissing = true;
                var packagesMissing = true;
                var chargeRuleMissing = true;
                if (isCharge == 1) { //付费
                    var str = '';
                    $($("input:checkbox[name='terminalList']")).each(function (index, element) {
                        if ($(this).is(':checked')) {	//选中收费平台
                            chargePlatformMissing = false;
                            if (str) {
                                str += ',';
                            }
                            str += element.value;
                        }
                    });
                    $($("input[name='chargeType_']")).each(function (index, element) {
                        if ($(this).is(':checked')) {	//选中付费类型
                            chargeTypeMissing = false;
                        }
                    });
                    $($("input[name='chargeRule']")).each(function (index, element) {
                        if ($(this).is(':checked')) {	//选中付费规则
                            chargeRuleMissing = false;
                        }
                    });
                    var chargeType = $('#chargeType').val();
                    if(chargeType==1||chargeType==2){
                    	$($("input:checkbox[name='aggPackageList']")).each(function (index, element) {
                            if ($(this).is(':checked')) {	//选中内容特权
                            	packagesMissing = false;
                            }
                        });
                    }
                    if (chargePlatformMissing||chargeTypeMissing) {
                    	parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.必须选择付费平台和付费类型}', 'error');
                        parent.$.messager.progress('close');
                        return false;
                    } else if((chargeType==1||chargeType==2)&&packagesMissing){
                    	parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.必须选择内容特权}', 'error');
                        parent.$.messager.progress('close');
                        return false;
                    } else if(chargeRuleMissing){
                    	parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.必须选择付费规则}', 'error');
                        parent.$.messager.progress('close');
                        return false;
                    } else {
                        $("input[name='chargePlatform']").val(str);
                    }
                    if($("input[name='chargeRule']:checked").val()=='2'&&!validateRuleType()) {
                        parent.$.messager.progress('close');
                        return false;
                    }
                    var span=$('#videoChargeInfoSpan');
                    span.empty();
                    if($("input[name='chargeRule']:checked").val()=='5'){
                        $('[id^=vid_]').each(function(){
                            var self=$(this);
                            if(self.is(':checked'))
                                span.append($($.formatString('<input type="hidden" name="chargeVids" value="{0}">', self.val())));
                            else
                                span.append($($.formatString('<input type="hidden" name="freeVids" value="{0}">', self.val())));
                        });
                    }
                } else if (isCharge == 0) { //免费
                    $("input[name=terminalList],input[name=aggPackageList]").each(function(){
                        $(this).prop("checked", false);
                    });
                    <c:if test="${movie.chargeRule!=3}">
                    if($('input[name=chargeRule]:checked').length==0){
                        $('input[name=chargeRule]:first').prop('checked', true);
                    }
                    </c:if>
                }

                return isValid;
            },
            success: function (result) {
                parent.$.messager.progress('close');
                result = $.parseJSON(result);
                if (result.code == 0) {
                    parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.编辑成功}', 'success');
                    //parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
                    parent.$.modalDialog.handler.dialog('close');

                } else {
                    parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
                }
            }
        });
    });
    $.extend($.fn.validatebox.defaults.rules, {
        requiredWhen: {
            validator: function (value, param) {
                if($("input[name='chargeRule']:checked").val()=='2') {
                    return value != '';
                }
                return true;
            },
            message: $.fn.validatebox.defaults.missingMessage
        },
        choice: {
            validator: function (value, param) {
                if($("input[name='chargeRule']:checked").val()=='2') {
                    var latestEpisodesPay = $('#latestEpisodesPay').val();
                    var dayCycle = $('#dayCycle').val();
                    return latestEpisodesPay != '' || dayCycle != '';
                }
                return true;
            },
            message: '${internationalConfig.请至少填写一项}'
        },
        regularTime: {
            validator: function (value, param) {
                if($("input[name='chargeRule']:checked").val()=='2') {
                    return /^\d{1,2}:\d{1,2}$/.test(value);
                }
                return true;
            },
            message: '${internationalConfig.时间格式不正确}'
        }
    });
    function validateRuleType(){
        var flag = true;
        var preEpisodesFree = $('#preEpisodesFree').val();
        if (preEpisodesFree == '') {
            parent.$.messager.alert('${internationalConfig.错误}', $.fn.validatebox.defaults.missingMessage + ': ${internationalConfig.免费集数}' , 'error');
            flag = false;
        }
        var latestEpisodesPay = $('#latestEpisodesPay').val();
        var dayCycle = $('#dayCycle').val();
        if (latestEpisodesPay == '' && dayCycle == '') {
            parent.$.messager.alert('${internationalConfig.错误}', $.fn.validatebox.defaults.missingMessage + ': ${internationalConfig.免费规则}' , 'error');
            flag = false;
        }

        return flag;
    }

</script>
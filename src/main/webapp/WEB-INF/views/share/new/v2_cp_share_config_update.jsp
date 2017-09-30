<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<style type="text/css">
    .cpmClass {
        width: 30px;
    }
</style>
<script type="text/javascript">
    $(function () {
        $("#com_name").combobox({
            url:'/new/share_copyright_config/all',
            valueField:'id',
            textField:'name',
            disabled : ${v2CpShareConfig.id}
        });
        initType();
        initConfigType();
        initDate();
        parent.$.messager.progress('close');
        $('#form').form({
            url: '/new/v2_cp_share_config/update_submit',
            onSubmit: function () {
                parent.$.messager.progress({
                    title: '${internationalConfig.提示}',
                    text: '${internationalConfig.数据处理中请稍后}'
                });
                var isValid = $(this).form('validate');
                var isBusinessValid = businessValid();
                if (!isValid || !isBusinessValid) {
                    parent.$.messager.progress('close');
                }

                return isValid && isBusinessValid;
            },
            success: function (result) {
                parent.$.messager.progress('close');
                result = $.parseJSON(result);
                if (result.code == 0) {
                    parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.操作成功}', 'success');
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
                }
            }
        });
    });

    function albumIdDisabled(isChecked) {
        if (isChecked) {
            $("input[name='albumId']").attr('disabled', false);
        } else {
            $("input[name='albumId']").attr('disabled', 'disabled');
        }
    }

    function searchCp() {
        var cpName = $("input[name='cpName']").val();
        $.get("/new/share_copyright_config/searchCp?cpName=" + cpName, function (result) {
            var json = $.parseJSON(result);
            if (json.code == 0) {
                $("input[name='cid']").val(json.data.id);
                parent.$.messager.alert('${internationalConfig.Success}', '${internationalConfig.绑定成功}', 'success');
            } else {
                parent.$.messager.alert('${internationalConfig.Error}', json.msg, 'error');
            }
        });
    }

    function initType() {
        $("td[id^='type']").hide();
        if (${v2CpShareConfig.id}) {
            $("#type" + ${v2CpShareConfig.type}).show();
            $("input[name='type']").attr('disabled', 'disabled');
            $("input[name='type']").prop('checked', false);
            $("input[name='type'][value='" + ${v2CpShareConfig.type} +"']").prop('checked', 'checked');
            $("input[name='type'][value='" + ${v2CpShareConfig.type} +"']").attr('disabled', false);
            $("#com_name").combobox('setValue', ${v2CpShareConfig.cid});
            $("tr[id^='configType']").hide();
            $("#configType${v2CpShareConfig.type}").show();
        } else {
            $("#type2").show();
            $("input[name='type']").click(function () {
                $("td[id^='type']").hide();
                $("#type" + this.value).show();
                //如果是CP  必须选择会员订单配置
                if (this.value == '1') {
                    $("#configType1").show();
                    $("#configType2").hide();
                    $("div[id^='configDiv']").hide();
                    $("#configDiv5").show();
                    $("input[name='configType']").prop('checked', false);
                    $("input[name='configType'][value='5']").prop('checked', 'checked');
                    $("#configTypeTr").hide();
                    //$("input[name='cpName']").combobox('setValues',t);
                } else {
                    $("#configType1").hide();
                    $("#configType2").show();
                    $("div[id^='configDiv']").hide();
                    $("#configDiv1").show();
                    $("input[name='configType']").prop('checked', false);
                    $("input[name='configType'][value='1']").prop('checked', 'checked');
                    $("#configTypeTr").show();
                }
            });
        }
    }

    function initConfigType() {
        $("div[id^='configDiv']").hide();
        $("tr[id^='payConfig']").hide();
        $("tr[id^='playConfig']").hide();
        $("tr[id^='keepConfig']").hide();
        $("tr[id^='orderConfig']").hide();
        $("tr[id^='businessConfig']").hide();
        if (${v2CpShareConfig.id}) {
            $("#configDiv" + ${v2CpShareConfig.configType}).show();
            $("input[name='configType']").attr('disabled', 'disabled');
            $("input[name='configType']").prop('checked', false);
            $("input[name='configType'][value='" + ${v2CpShareConfig.configType} +"']").prop('checked', 'checked');
            $("input[name='configType'][value='" + ${v2CpShareConfig.configType} +"']").attr('disabled', false);

            var configType = ${v2CpShareConfig.configType};
            if (configType == 1) {
                $("select[name='payConfig.duration']").find("option[value='" + ${v2CpShareConfig.payConfig.duration} +"']").attr('selected', true);
                if (${v2CpShareConfig.payConfig.stimulate}) {
                    $("tr[id^='payConfig']").show();
                } else {
                    $("tr[id^='payConfig']").hide();
                }
            } else if (configType == 2) {

            } else if (configType == 3) {
                $("select[name='playConfig.duration']").find("option[value='" + ${v2CpShareConfig.playConfig.duration} +"']").attr('selected', true);
                if (${v2CpShareConfig.playConfig.stimulate}) {
                    $("tr[id^='playConfig']").show();
                } else {
                    $("tr[id^='playConfig']").hide();
                }
            } else if (configType == 4) {
                $("select[name='keepConfig.duration']").find("option[value='" + ${v2CpShareConfig.keepConfig.duration} +"']").attr('selected', true);
                if (${v2CpShareConfig.keepConfig.stimulate}) {
                    $("tr[id^='keepConfig']").show();
                } else {
                    $("tr[id^='keepConfig']").hide();
                }
            } else if (configType == 5) {
                $("select[name='memberType']").find("option[value='" + ${v2CpShareConfig.memberType} +"']").attr('selected', true);
                if (${v2CpShareConfig.orderConfig.stimulate}) {
                    $("tr[id^='orderConfig']").show();
                } else {
                    $("tr[id^='orderConfig']").hide();
                }
                $("select[id^='memberType']").attr("disabled", 'disabled');
                $("#memberType" + this.value).attr("disabled", false);
            } else if (configType == 6) {
                $("select[name='memberType']").find("option[value='" + ${v2CpShareConfig.memberType} +"']").attr('selected', true);
                if (${v2CpShareConfig.businessConfig.stimulate}) {
                    $("tr[id^='businessConfig']").show();
                } else {
                    $("tr[id^='businessConfig']").hide();
                }
                $("select[id^='memberType']").attr("disabled", 'disabled');
                $("#memberType" + this.value).attr("disabled", false);
            } else {
                parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.程序有误请刷新页面重试}", 'error');
                return false;
            }
        } else {
            $("#configType1").hide();
            $("#configDiv1").show();
        }
        $("input[name='configType']").click(function () {
            $("div[id^='configDiv']").hide();
            $("#configDiv" + this.value).show();
            if (this.value == '6' || this.value == '5') {
                $("select[id^='memberType']").attr("disabled", 'disabled');
                $("#memberType" + this.value).attr("disabled", false);
            }
        });
        $("input[name='payConfig.stimulate']").click(function () {
            if (this.checked) {
                $("tr[id^='payConfig']").show();
            } else {
                $("tr[id^='payConfig']").hide();
            }
        });
        $("input[name='playConfig.stimulate']").click(function () {
            if (this.checked) {
                $("tr[id^='playConfig']").show();
            } else {
                $("tr[id^='playConfig']").hide();
            }
        });
        $("input[name='keepConfig.stimulate']").click(function () {
            if (this.checked) {
                $("tr[id^='keepConfig']").show();
            } else {
                $("tr[id^='keepConfig']").hide();
            }
        });
        $("input[name='orderConfig.stimulate']").click(function () {
            if (this.checked) {
                $("tr[id^='orderConfig']").show();
            } else {
                $("tr[id^='orderConfig']").hide();
            }
        });
        $("input[name='businessConfig.stimulate']").click(function () {
            if (this.checked) {
                $("tr[id^='businessConfig']").show();
            } else {
                $("tr[id^='businessConfig']").hide();
            }
        });
    }
    function getNowDate() {
        var today = new Date().format();
    }
    function businessValid() {
        //类型验证
        var type = $("input[name='type']:checked").val();
        if (type == '2') {
            if (!$("input[name='albumId']").val()) {
                parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.专辑ID不能为空}", 'error');
                return false;
            }
        } else {
            if (!$("input[name='cid']").val()) {
                parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.版权公司不能为空}", 'error');
                return false;
            }
        }

        //时间段验证
        var beginTime = $("input[name='beginTime']").val();
        var endTime = $("input[name='endTime']").val();

        if (!beginTime || !endTime) {
            parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.开始时间和结束时间不能为空}", 'error');
            return false;
        } else if (beginTime >= endTime) {
            parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.开始时间必须早于结束时间}", 'error');
            return false;
        }
        //校验系数的日期不能小于当前日期
        var validRatioDate = true;
        var today = new Date().format("yyyy-MM-dd");
        $(".validRatioDate[readonly!=readonly]").each(function (i, e) {
            var date = $(this).datebox("getValue");
            if (date != '' && date < today) {
                validRatioDate = false;
                return;
            }
        });
        if (!validRatioDate) {
            parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.系数生效时间必须大于当前时间}", 'error');
            return false;
        }
        //系数和限制验证
        var configType = $("input[name='configType']:checked").val();
        if (configType == '1') {
            /*if (!$("input[name='payConfig.price']").val()) {
                parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.付费规则单价不能为空}", 'error');
                return false;
            }*/
            if ($("input[name='payConfig.stimulate']").is(':checked')) {
                if (!$("input[name='payConfig.limit1']").val() || !$("input[name='payConfig.limitBase1']").val()) {
                    parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.至少填一项激励规则}", 'error');
                    return false;
                }
            } else {
                if (!$("input[name='payConfig.base']").val()) {
                    parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.分成规则值为必填}", 'error');
                    return false;
                }
            }
        } else if (configType == '2') {
            if (!$("input[name='cpmConfig.pc']").val()
                    || !$("input[name='cpmConfig.pc5']").val()
                    || !$("input[name='cpmConfig.pc10']").val()
                    || !$("input[name='cpmConfig.pc15']").val()
                    || !$("input[name='cpmConfig.pc30']").val()
                    || !$("input[name='cpmConfig.pc60']").val()
                    || !$("input[name='cpmConfig.pc75']").val()) {
                parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.CPM规则PC端千次单价不能为空}", 'error');
                return false;
            }
            if (!$("input[name='cpmConfig.phone']").val()
                    || !$("input[name='cpmConfig.phone5']").val()
                    || !$("input[name='cpmConfig.phone10']").val()
                    || !$("input[name='cpmConfig.phone15']").val()
                    || !$("input[name='cpmConfig.phone30']").val()
                    || !$("input[name='cpmConfig.phone60']").val()
                    || !$("input[name='cpmConfig.phone75']").val()) {
                parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.CPM规则移动端千次单价不能为空}", 'error');
                return false;
            }
            if (!$("input[name='cpmConfig.tv']").val()
                    || !$("input[name='cpmConfig.tv5']").val()
                    || !$("input[name='cpmConfig.tv10']").val()
                    || !$("input[name='cpmConfig.tv15']").val()
                    || !$("input[name='cpmConfig.tv30']").val()
                    || !$("input[name='cpmConfig.tv60']").val()
                    || !$("input[name='cpmConfig.tv75']").val()) {
                parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.CPM规则TV端千次单价不能为空}", 'error');
                return false;
            }
        } else if (configType == '3') {
            /*if (!$("input[name='playConfig.price']").val()) {
                parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.播放分成规则单价价不能为空}", 'error');
                return false;
            }*/
            /*if (!$("input[name='playConfig.phone']").val()) {
                parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.播放分成规则移动端单价不能为空}", 'error');
                return false;
            }
            if (!$("input[name='playConfig.tv']").val()) {
                parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.播放分成规则TV端单价不能为空}", 'error');
                return false;
            }*/
            if ($("input[name='playConfig.stimulate']").is(':checked')) {
                if (!$("input[name='playConfig.limit1']").val() || !$("input[name='playConfig.limitBase1']").val()) {
                    parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.至少填一项激励规则}", 'error');
                    return false;
                }
            } else {
                if (!$("input[name='playConfig.base']").val()) {
                    parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.分成规则值为必填}", 'error');
                    return false;
                }
            }
        } else if (configType == '4') {
            /*if ($("input[name='keepConfig.minute1']").val() && !$("input[name='keepConfig.money1']").val()
                    || $("input[name='keepConfig.minute2']").val() && !$("input[name='keepConfig.money2']").val()
                    || $("input[name='keepConfig.minute3']").val() && !$("input[name='keepConfig.money3']").val()
                    || $("input[name='keepConfig.minute4']").val() && !$("input[name='keepConfig.money4']").val()
                    || $("input[name='keepConfig.minute5']").val() && !$("input[name='keepConfig.money5']").val()) {
                parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.请填写分成价格}", 'error');
                return false;
            }

            if (!$("input[name='keepConfig.minute1']").val() && $("input[name='keepConfig.money1']").val()
                    || !$("input[name='keepConfig.minute2']").val() && $("input[name='keepConfig.money2']").val()
                    || !$("input[name='keepConfig.minute3']").val() && $("input[name='keepConfig.money3']").val()
                    || !$("input[name='keepConfig.minute4']").val() && $("input[name='keepConfig.money4']").val()
                    || !$("input[name='keepConfig.minute5']").val() && $("input[name='keepConfig.money5']").val()) {
                parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.请填写时长信息}", 'error');
                return false;
            }

            if (!(($("input[name='keepConfig.minute1']").val() && $("input[name='keepConfig.money1']").val())
                    || ($("input[name='keepConfig.minute2']").val() && $("input[name='keepConfig.money2']").val())
                    || ($("input[name='keepConfig.minute3']").val() && $("input[name='keepConfig.money3']").val())
                    || ($("input[name='keepConfig.minute4']").val() && $("input[name='keepConfig.money4']").val())
                    || ($("input[name='keepConfig.minute5']").val() && $("input[name='keepConfig.money5']").val()))) {
                parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.至少填写一项用户累计信息}", 'error');
                return false;
            }*/
            if ($("input[name='keepConfig.stimulate']").is(':checked')) {
                if (!$("input[name='keepConfig.limit1']").val() || !$("input[name='keepConfig.limitBase1']").val()) {
                    parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.至少填一项激励规则}", 'error');
                    return false;
                }
            } else {
                if (!$("input[name='keepConfig.base']").val()) {
                    parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.分成规则值为必填}", 'error');
                    return false;
                }
            }
        } else if (configType == '5') {
            if ($("input[name='orderConfig.stimulate']").is(':checked')) {
                if (!$("input[name='orderConfig.limit1']").val() || !$("input[name='orderConfig.limitBase1']").val()) {
                    parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.至少填一项激励规则}", 'error');
                    return false;
                }
            } else {
                if (!$("input[name='orderConfig.base']").val()) {
                    parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.分成规则值为必填}", 'error');
                    return false;
                }
            }
            var memberTypeName = $("#memberType5").find("option:selected").text();
            $("input[name='memberTypeName']").val(memberTypeName);
        } else if (configType == '6') {
            if ($("input[name='businessConfig.stimulate']").is(':checked')) {
                if (!$("input[name='businessConfig.limit1']").val() || !$("input[name='businessConfig.limitBase1']").val()) {
                    parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.至少填一项激励规则}", 'error');
                    return false;
                }
            } else {
                if (!$("input[name='businessConfig.base']").val()) {
                    parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.分成规则值为必填}", 'error');
                    return false;
                }
            }
            var memberTypeName = $("#memberType6").find("option:selected").text();
            $("input[name='memberTypeName']").val(memberTypeName);
        } else {
            parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.没有这个配置类型}", 'error');
            return false;
        }
    }

    //无语的需求,要求失效时全部不能编辑,生效中只有结束时间可以编辑,未生效的全部都能编辑
    function initDate() {
        var status = ${status};
        switch (status) {
            case -1:
                break;
            case 0:
                break;
            case 1: //全部不可配置
                $("input").attr('readonly', 'readonly');
                $("select").attr('readonly', 'readonly');
                $("input[name='ratioNodeDate']").attr('readonly', false);
                break;
            case 2: //结束时间和系数可以配置
                $("input").not(".ratio").attr('readonly', 'readonly');
                $("select").attr('readonly', 'readonly');
                $("input[name='endTime']").attr('readonly', false);
                $("input[name='ratio']").attr('readonly', false);
                $("input[name='ratioNodeDate']").attr('readonly', false);
                $("input[name='ratios[${fn:length(v2CpShareConfig.ratios)}].ratio']").attr('readonly', false);
                $("input[name='ratios[${fn:length(v2CpShareConfig.ratios)}].ratioNodeDate']").attr('readonly', false);
                break;
            case 3: //除了类型专辑和CP都可以配置
                $("input[name='albumId']").attr('readonly', 'readonly');
                $("input[name='com_name']").attr('readonly', 'readonly');
                $("select[name='memberType']").attr('readonly', 'readonly');
                break;
        }
    }

    function addRatios() {
        var htm = "<tr class=\"ratio\"> <td>${internationalConfig.系数生效日期}：<input name=\"ratios.ratioNodeDate\" value=\"<fmt:formatDate value='${v2CpShareConfig.ratioNodeDate}' pattern='yyyy-MM-dd'/>\" class=\"easyui-datebox\"/>"
            + " <td>${internationalConfig.系数配置}：<input name=\"ratios.ratio\" class=\"easyui-numberspinner\""
            + " value=\"${v2CpShareConfig.ratio == null ? 1 : v2CpShareConfig.ratio}\""
            + " data-options=\"precision:1,min:0.1,max:1.0,increment:0.1\"/>0.1-1${internationalConfig.之间}"
            + " </td>"
            + " <td> <input type=\"button\" onclick=\"delRatios();\" id=\"addRatio\" value=\"删除\">"
            + " </td>"
            + " </tr>";
        $(".ratio").last().after(htm);
        $.parser.parse(".ratio");
    }
</script>
<div class="easyui-layout" data-options="fit:true,border:false" style="overflow-y: scroll">
    <div style="position:absolute; height:500px;">
        <form id="form" method="post">
            <input name="id" value="${v2CpShareConfig.id}" type="hidden"/>
            <input name="memberTypeName" value="${v2CpShareConfig.memberTypeName}" type="hidden"/>
            <%--<input name="cid" value="${v2CpShareConfig.cid}" type="hidden"/>--%>

            <div>
                <table class="table-more">
                    <tr>
                        <td><b style="color: red">*</b>${internationalConfig.分成维度}：<input type="radio" name="type" value="2"
                                                                   checked="checked"/>${internationalConfig.单个专辑} <input type="radio"
                                                                                                  name="type"
                                                                                                  value="1"/>${internationalConfig.单个CP}
                        </td>
                    </tr>
                    <tr>
                        <td id="type2"><b style="color: red">*</b>${internationalConfig.专辑ID}：<input name="albumId"
                                                   value="${v2CpShareConfig.albumId == 0 ? null : v2CpShareConfig.albumId}" class="easyui-numberbox"
                                                                              min="0" max="999999999">
                        </td>
                        <td id="type1"><%--<input name="cpName" value="${v2CpShareConfig.name}" placeholder="请输入CP名称检索"/>
                            <input type="button"
                                   value="绑定"
                                   onclick="searchCp();">--%>
                            <b style="color: red">*</b>${internationalConfig.版权公司}：
                            
                            <select id="com_name" name="cid"></select>
                        </td>
                    </tr>
                    <tr>
                        <td><b style="color: red">*</b>${internationalConfig.时间段}：<input name="beginTime" value="${v2CpShareConfig.beginTime}"
                                                                  class="easyui-datebox"/> -
                            <input name="endTime" value="${v2CpShareConfig.endTime}"
                                   class="easyui-datebox"/>
                        </td>
                    </tr>
                    <!--付费分成系数配置 update by zzj-->

                        <c:forEach var="config" items="${v2CpShareConfig.ratios}" varStatus="status">
                            <tr>
                                <td>${internationalConfig.系数生效日期}：<input name="ratios[${status.index}].ratioNodeDate" ${config.edit ? '':'readonly'} value="<fmt:formatDate value='${config.ratioNodeDate}' pattern='yyyy-MM-dd'/>" class="easyui-datebox ratio validRatioDate"/>
                                        ${internationalConfig.系数配置}：<input name="ratios[${status.index}].ratio" ${config.edit ? '':'readonly'} class="easyui-numberspinner ratio" value="${config.ratio}" data-options="precision:1,min:0.1,max:1.0,increment:0.1"/>0.1-1${internationalConfig.之间}
                                </td>
                            </tr>
                        </c:forEach>
                        <tr class="ratio">
                            <td>${internationalConfig.系数生效日期}：<input name="ratios[${fn:length(v2CpShareConfig.ratios)}].ratioNodeDate" value="" class="easyui-datebox validRatioDate"/>
                                    ${internationalConfig.系数配置}：<input name="ratios[${fn:length(v2CpShareConfig.ratios)}].ratio" class="easyui-numberspinner" value="1" data-options="precision:1,min:0.1,max:1.0,increment:0.1"/>0.1-1${internationalConfig.之间}
                            </td>
                        </tr>
                    <tr>
                        <td>${internationalConfig.上限预警}：<input name="maxLimit"
                                       value="${v2CpShareConfig.maxLimit}"
                                       class="easyui-numberbox"
                                       min="0" max="99999999"/>${internationalConfig.金额达到上限后系统发送邮件到指定邮箱}</td>
                    </tr>
                    <tr id="configType2">
                        <td><input type="radio" name="configType" checked="checked" value="1"> ${internationalConfig.付费分成}
                            <input type="radio" name="configType" value="3"> ${internationalConfig.播放分成}
                            <input type="radio" name="configType" value="4"> ${internationalConfig.累计时长分成}
                            <input type="radio" name="configType" value="2"> ${internationalConfig.CPM分成}
                        </td>
                    </tr>
                    <tr id="configType1">
                        <td>
                            <input type="radio" name="configType" value="5"> ${internationalConfig.会员订单分成}
                            <input type="radio" name="configType" value="6"> ${internationalConfig.业务订单分成}
                        </td>
                    </tr>
                </table>
            </div>
            <!-- 付费分成配置 -->
            <div id="configDiv1" title="${internationalConfig.付费分成配置}">
                <table class="table-more">
                    <tr>
                        <td><b style="color: red">*</b>${internationalConfig.规则}：</td>
                        <td>
                            <input name="payConfig.base" value="${v2CpShareConfig.payConfig.base}" class="easyui-numberbox" precision="2"
                                   min="0.00" max="9999.99"> ${internationalConfig.priceUnit}${internationalConfig.每个}${internationalConfig.有效播放人数}
                            <%--<input type="checkbox" name="payConfig.stimulate" ${v2CpShareConfig.payConfig.stimulate ? 'checked' : ''} ${v2CpShareConfig.id > 0 && status != 3 ? 'onclick="return false;"' : ''}> ${internationalConfig.是否激励}--%>
                        </td>
                    </tr>
                    <%--<tr id="payConfiglimit1">
                        <td></td>
                        <td>
                            ${internationalConfig.达到}<input name="payConfig.limit1" value="${v2CpShareConfig.payConfig.limit1}" class="easyui-numberbox"
                                     min="0" max="9999999999"> ${internationalConfig.人数},${internationalConfig.按}
                            <input name="payConfig.limitBase1" value="${v2CpShareConfig.payConfig.limitBase1}" class="easyui-numberbox" precision="2"
                                   min="0.00" max="9999.99"> ${internationalConfig.priceUnit}
                        </td>
                    </tr>
                    <tr id="payConfiglimit2">
                        <td></td>
                        <td>
                            ${internationalConfig.达到}<input name="payConfig.limit2" value="${v2CpShareConfig.payConfig.limit2}" class="easyui-numberbox"
                                     min="0" max="9999999999"> ${internationalConfig.人数},${internationalConfig.按}
                            <input name="payConfig.limitBase2" value="${v2CpShareConfig.payConfig.limitBase2}" class="easyui-numberbox" precision="2"
                                   min="0.00" max="9999.99"> ${internationalConfig.priceUnit}
                        </td>
                    </tr>--%>
                    <tr>
                        <td>${internationalConfig.有效播放规则}：
                        </td>
                        <td><select name="payConfig.duration"
                                    value="${v2CpShareConfig.payConfig.duration}" ${status == 1 || status == 2 ? 'onfocus="this.defaultIndex=this.selectedIndex;" onchange="this.selectedIndex=this.defaultIndex;"' : ''}>
                            <option value="0">0${internationalConfig.分钟}</option>
                            <option value="3">3${internationalConfig.分钟}</option>
                            <option value="6">6${internationalConfig.分钟}</option>
                            <option value="10">10${internationalConfig.分钟}</option>
                            <option value="20">20${internationalConfig.分钟}</option>
                        </select>
                        </td>
                    </tr>
                </table>
            </div>
            <!-- CPM分成配置 -->
            <div id="configDiv2" title="${internationalConfig.CPM分成配置}">
                <table class="table-more">
                    <tr>
                        <td><b style="color: red">*</b>${internationalConfig.PC端千次单价}：${internationalConfig.暂停}<input name="cpmConfig.pc"
                                                                        value="${v2CpShareConfig.cpmConfig.pc}"
                                                                        class="easyui-numberbox cpmClass" precision="2"
                                                                        min="0.00" max="9999.99"/>${internationalConfig.priceUnit},
                            5${internationalConfig.秒}<input name="cpmConfig.pc5" value="${v2CpShareConfig.cpmConfig.pc5}"
                                     class="easyui-numberbox cpmClass" precision="2" min="0.00" max="9999.99"/>${internationalConfig.priceUnit},
                            10${internationalConfig.秒}<input name="cpmConfig.pc10" value="${v2CpShareConfig.cpmConfig.pc10}"
                                      class="easyui-numberbox cpmClass" precision="2" min="0.00" max="9999.99"/>${internationalConfig.priceUnit},
                            15${internationalConfig.秒}<input name="cpmConfig.pc15" value="${v2CpShareConfig.cpmConfig.pc15}"
                                      class="easyui-numberbox cpmClass" precision="2" min="0.00" max="9999.99"/>${internationalConfig.priceUnit},
                            30${internationalConfig.秒}<input name="cpmConfig.pc30" value="${v2CpShareConfig.cpmConfig.pc30}"
                                      class="easyui-numberbox cpmClass" precision="2" min="0.00" max="9999.99"/>${internationalConfig.priceUnit},
                            60${internationalConfig.秒}<input name="cpmConfig.pc60" value="${v2CpShareConfig.cpmConfig.pc60}"
                                      class="easyui-numberbox cpmClass" precision="2" min="0.00" max="9999.99"/>${internationalConfig.priceUnit},
                            75${internationalConfig.秒}<input name="cpmConfig.pc75" value="${v2CpShareConfig.cpmConfig.pc75}"
                                      class="easyui-numberbox cpmClass" precision="2" min="0.00" max="9999.99"/>${internationalConfig.priceUnit}
                        </td>
                    </tr>
                    <tr>
                        <td><b style="color: red">*</b>${internationalConfig.移动端千次单价}：${internationalConfig.暂停}<input name="cpmConfig.phone"
                                                                        value="${v2CpShareConfig.cpmConfig.phone}"
                                                                        class="easyui-numberbox cpmClass" precision="2"
                                                                        min="0.00" max="9999.99"/>${internationalConfig.priceUnit},
                            5${internationalConfig.秒}<input name="cpmConfig.phone5"
                                     value="${v2CpShareConfig.cpmConfig.phone5}" class="easyui-numberbox cpmClass"
                                     precision="2" min="0.00" max="9999.99"/>${internationalConfig.priceUnit},
                            10${internationalConfig.秒}<input name="cpmConfig.phone10"
                                      value="${v2CpShareConfig.cpmConfig.phone10}" class="easyui-numberbox cpmClass"
                                      precision="2" min="0.00" max="9999.99"/>${internationalConfig.priceUnit},
                            15${internationalConfig.秒}<input name="cpmConfig.phone15"
                                      value="${v2CpShareConfig.cpmConfig.phone15}" class="easyui-numberbox cpmClass"
                                      precision="2" min="0.00" max="9999.99"/>${internationalConfig.priceUnit},
                            30${internationalConfig.秒}<input name="cpmConfig.phone30"
                                      value="${v2CpShareConfig.cpmConfig.phone30}" class="easyui-numberbox cpmClass"
                                      precision="2" min="0.00" max="9999.99"/>${internationalConfig.priceUnit},
                            60${internationalConfig.秒}<input name="cpmConfig.phone60"
                                      value="${v2CpShareConfig.cpmConfig.phone60}" class="easyui-numberbox cpmClass"
                                      precision="2" min="0.00" max="9999.99"/>${internationalConfig.priceUnit},
                            75${internationalConfig.秒}<input name="cpmConfig.phone75"
                                      value="${v2CpShareConfig.cpmConfig.phone75}" class="easyui-numberbox cpmClass"
                                      precision="2" min="0.00" max="9999.99"/>${internationalConfig.priceUnit}
                        </td>
                    </tr>
                    <tr>
                        <td><b style="color: red">*</b>${internationalConfig.TV端千次单价}：${internationalConfig.暂停}<input name="cpmConfig.tv"
                                                                        value="${v2CpShareConfig.cpmConfig.tv}"
                                                                        class="easyui-numberbox cpmClass" precision="2"
                                                                        min="0.00" max="9999.99"/>${internationalConfig.priceUnit},
                            5${internationalConfig.秒}<input name="cpmConfig.tv5" value="${v2CpShareConfig.cpmConfig.tv5}"
                                     class="easyui-numberbox cpmClass" precision="2" min="0.00" max="9999.99"/>${internationalConfig.priceUnit},
                            10${internationalConfig.秒}<input name="cpmConfig.tv10" value="${v2CpShareConfig.cpmConfig.tv10}"
                                      class="easyui-numberbox cpmClass" precision="2" min="0.00" max="9999.99"/>${internationalConfig.priceUnit},
                            15${internationalConfig.秒}<input name="cpmConfig.tv15" value="${v2CpShareConfig.cpmConfig.tv15}"
                                      class="easyui-numberbox cpmClass" precision="2" min="0.00" max="9999.99"/>${internationalConfig.priceUnit},
                            30${internationalConfig.秒}<input name="cpmConfig.tv30" value="${v2CpShareConfig.cpmConfig.tv30}"
                                      class="easyui-numberbox cpmClass" precision="2" min="0.00" max="9999.99"/>${internationalConfig.priceUnit},
                            60${internationalConfig.秒}<input name="cpmConfig.tv60" value="${v2CpShareConfig.cpmConfig.tv60}"
                                      class="easyui-numberbox cpmClass" precision="2" min="0.00" max="9999.99"/>${internationalConfig.priceUnit},
                            75${internationalConfig.秒}<input name="cpmConfig.tv75" value="${v2CpShareConfig.cpmConfig.tv75}"
                                      class="easyui-numberbox cpmClass" precision="2" min="0.00" max="9999.99"/>${internationalConfig.priceUnit}
                        </td>
                    </tr>
                </table>
            </div>
            <!-- 播放分成 -->
            <div id="configDiv3" title="${internationalConfig.播放分成配置}">
                <table class="table-more">
                    <%--<tr>
                        <td><b style="color: red">*</b>PC端单价：<input name="playConfig.price"
                                                                    value="${v2CpShareConfig.playConfig.price}"
                                                                    class="easyui-numberbox" precision="2"
                                                                    min="0.00" max="99.99"/></td>
                    </tr>--%>
                        <tr>
                            <td><b style="color: red">*</b>${internationalConfig.规则}：</td>
                            <td>
                                <input name="playConfig.base" value="${v2CpShareConfig.playConfig.base}" class="easyui-numberbox" precision="2"
                                       min="0.00" max="9999.99"> ${internationalConfig.priceUnit}${internationalConfig.每个}${internationalConfig.千次}
                                <%--<input type="checkbox" name="playConfig.stimulate" ${v2CpShareConfig.playConfig.stimulate ? 'checked' : ''} ${v2CpShareConfig.id > 0 && status != 3 ? 'onclick="return false;"' : ''}> ${internationalConfig.是否激励}--%>
                            </td>
                        </tr>
                        <%--<tr id="playConfiglimit1">
                            <td></td>
                            <td>
                                ${internationalConfig.达到}<input name="playConfig.limit1" value="${v2CpShareConfig.playConfig.limit1}" class="easyui-numberbox"
                                         min="0" max="9999999999"> ${internationalConfig.千次},${internationalConfig.按}
                                <input name="playConfig.limitBase1" value="${v2CpShareConfig.playConfig.limitBase1}" class="easyui-numberbox" precision="2"
                                       min="0.00" max="9999.99"> ${internationalConfig.priceUnit}
                            </td>
                        </tr>
                        <tr id="playConfiglimit2">
                            <td></td>
                            <td>
                                ${internationalConfig.达到}<input name="playConfig.limit2" value="${v2CpShareConfig.playConfig.limit2}" class="easyui-numberbox"
                                         min="0" max="9999999999"> ${internationalConfig.千次},${internationalConfig.按}
                                <input name="playConfig.limitBase2" value="${v2CpShareConfig.playConfig.limitBase2}" class="easyui-numberbox" precision="2"
                                       min="0.00" max="9999.99"> ${internationalConfig.priceUnit}
                            </td>
                        </tr>--%>
                    <tr>
                        <td>${internationalConfig.有效播放规则}：
                        </td>
                        <td>
                            <select name="playConfig.duration"
                                    value="${v2CpShareConfig.playConfig.duration}" ${status == 1 || status == 2 ? 'onfocus="this.defaultIndex=this.selectedIndex;" onchange="this.selectedIndex=this.defaultIndex;"' : ''}>
                                <option value="0">0${internationalConfig.分钟}</option>
                                <option value="3">3${internationalConfig.分钟}</option>
                                <option value="6">6${internationalConfig.分钟}</option>
                                <option value="10">10${internationalConfig.分钟}</option>
                                <option value="20">20${internationalConfig.分钟}</option>
                            </select>
                        </td>
                    </tr>
                </table>
            </div>
            <!-- 累计时长分成 -->
            <div id="configDiv4" title="${internationalConfig.累计时长分成配置}">
                <table class="table-more">
                    <%--<tr>
                        <td><b style="color: red">*</b>PC端单价：<input name="playConfig.price"
                                                                    value="${v2CpShareConfig.playConfig.price}"
                                                                    class="easyui-numberbox" precision="2"
                                                                    min="0.00" max="99.99"/></td>
                    </tr>--%>
                    <tr>
                        <td><b style="color: red">*</b>${internationalConfig.规则}：</td>
                        <td>
                            <input name="keepConfig.base" value="${v2CpShareConfig.keepConfig.base}" class="easyui-numberbox" precision="2"
                                   min="0.00" max="9999.99"> ${internationalConfig.priceUnit}${internationalConfig.每个}${internationalConfig.有效累计小时}
                            <%--<input type="checkbox" name="keepConfig.stimulate" ${v2CpShareConfig.keepConfig.stimulate ? 'checked' : ''} ${v2CpShareConfig.id > 0 && status != 3 ? 'onclick="return false;"' : ''}> ${internationalConfig.是否激励}--%>
                        </td>
                    </tr>
                    <%--<tr id="keepConfiglimit1">
                        <td></td>
                        <td>
                            ${internationalConfig.达到}<input name="keepConfig.limit1" value="${v2CpShareConfig.keepConfig.limit1}" class="easyui-numberbox"
                                     min="0" max="9999999999"> ${internationalConfig.小时},${internationalConfig.按}
                            <input name="keepConfig.limitBase1" value="${v2CpShareConfig.keepConfig.limitBase1}" class="easyui-numberbox" precision="2"
                                   min="0.00" max="9999.99"> ${internationalConfig.priceUnit}
                        </td>
                    </tr>
                    <tr id="keepConfiglimit2">
                        <td></td>
                        <td>
                            ${internationalConfig.达到}<input name="keepConfig.limit2" value="${v2CpShareConfig.keepConfig.limit2}" class="easyui-numberbox"
                                     min="0" max="9999999999"> ${internationalConfig.小时},${internationalConfig.按}
                            <input name="keepConfig.limitBase2" value="${v2CpShareConfig.keepConfig.limitBase2}" class="easyui-numberbox" precision="2"
                                   min="0.00" max="9999.99"> ${internationalConfig.priceUnit}
                        </td>
                    </tr>--%>
                    <tr>
                        <td>${internationalConfig.有效播放规则}：
                        </td>
                        <td>
                            <select name="keepConfig.duration"
                                    value="${v2CpShareConfig.keepConfig.duration}" ${status == 1 || status == 2 ? 'onfocus="this.defaultIndex=this.selectedIndex;" onchange="this.selectedIndex=this.defaultIndex;"' : ''}>
                                <option value="0">0${internationalConfig.分钟}</option>
                                <option value="3">3${internationalConfig.分钟}</option>
                                <option value="6">6${internationalConfig.分钟}</option>
                                <option value="10">10${internationalConfig.分钟}</option>
                                <option value="20">20${internationalConfig.分钟}</option>
                            </select>
                        </td>
                    </tr>
                </table>
            </div>
            <%--<div id="configDiv4" title="累计时长配置">
                <table class="table-more">
                    <tr>
                        <td><b style="color: red">*</b>每月/每个用户累计：</td>
                        <td><input name="keepConfig.minute1" value="${v2CpShareConfig.keepConfig.minute1}"
                                   class="easyui-numberbox" min="0" max="999"/>分,分成<input name="keepConfig.money1"
                                                                                          value="${v2CpShareConfig.keepConfig.money1}"
                                                                                          class="easyui-numberbox"
                                                                                          precision="2" min="0.00"
                                                                                          max="999.99"/>priceUnit
                        </td>
                        &lt;%&ndash;<td><input type="checkbox" name="keepConfig.sameIncrease" ${v2CpShareConfig.keepConfig.sameIncrease ? 'checked':''}/>相同阶梯递增</td>&ndash;%&gt;
                    </tr>
                    &lt;%&ndash;<tr>
                        <td></td>
                        <td><input name="keepConfig.minute2" value="${v2CpShareConfig.keepConfig.minute2}" class="easyui-numberbox" min="0" max="999"/>分,分成<input name="keepConfig.money2" value="${v2CpShareConfig.keepConfig.money2}" class="easyui-numberbox" precision="2" min="0.00" max="999.99"/>priceUnit</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td><input name="keepConfig.minute3" value="${v2CpShareConfig.keepConfig.minute3}" class="easyui-numberbox" min="0" max="999"/>分,分成<input name="keepConfig.money3" value="${v2CpShareConfig.keepConfig.money3}" class="easyui-numberbox" precision="2" min="0.00" max="999.99"/>priceUnit</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td><input name="keepConfig.minute4" value="${v2CpShareConfig.keepConfig.minute4}" class="easyui-numberbox" min="0" max="999"/>分,分成<input name="keepConfig.money4" value="${v2CpShareConfig.keepConfig.money4}" class="easyui-numberbox" precision="2" min="0.00" max="999.99"/>priceUnit</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td><input name="keepConfig.minute5" value="${v2CpShareConfig.keepConfig.minute5}" class="easyui-numberbox" min="0" max="999"/>分,分成<input name="keepConfig.money5" value="${v2CpShareConfig.keepConfig.money5}" class="easyui-numberbox" precision="2" min="0.00" max="999.99"/>priceUnit</td>
                        <td></td>
                    </tr>&ndash;%&gt;
                    &lt;%&ndash;<tr>
                        <td>最大累计时长</td>
                        <td><input name="keepConfig.maxMinuteLimit" value="${v2CpShareConfig.keepConfig.maxMinuteLimit}" class="easyui-numberbox" min="0" max="999"/></td>
                        <td></td>
                    </tr>&ndash;%&gt;
                    <tr>
                        <td>有效播放规则：</td>
                        <td><select name="keepConfig.duration"
                                    value="${v2CpShareConfig.keepConfig.duration}" ${status == 1 || status == 2 ? 'onfocus="this.defaultIndex=this.selectedIndex;" onchange="this.selectedIndex=this.defaultIndex;"' : ''}>
                            <option value="0">0分钟</option>
                            <option value="3">3分钟</option>
                            <option value="6">6分钟</option>
                            <option value="10">10分钟</option>
                            <option value="20">20分钟</option>
                        </select>后才算
                        </td>
                    </tr>
                </table>
            </div>--%>
            <!-- 会员订单配置 -->
            <div id="configDiv5" title="${internationalConfig.会员订单分成配置}">
                <table class="table-more">
                    <tr>
                        <td><b style="color: red">*</b>${internationalConfig.会员类型}：</td>
                        <td>
                            <select id="memberType5" name="memberType">
                                <c:forEach items="${memberTypes}" var="m">
                                    <option value="${m.id}" ${m.id == v2CpShareConfig.memberType ? 'selected' : ''}>${m.name}</option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td><b style="color: red">*</b>${internationalConfig.规则}：</td>
                        <td>
                            <input name="orderConfig.base" value="${v2CpShareConfig.orderConfig.base}" class="easyui-numberbox" precision="2"
                                   min="0.00" max="100.00"> %${internationalConfig.每个}${internationalConfig.有效订单}
                            <%--<input type="checkbox" name="orderConfig.stimulate" ${v2CpShareConfig.orderConfig.stimulate ? 'checked' : ''} ${v2CpShareConfig.id > 0 && status != 3 ? 'onclick="return false;"' : ''}> ${internationalConfig.是否激励}--%>
                        </td>
                    </tr>
                    <%--<tr id="orderConfiglimit1">
                        <td></td>
                        <td>
                            ${internationalConfig.达到}<input name="orderConfig.limit1" value="${v2CpShareConfig.orderConfig.limit1}" class="easyui-numberbox"
                                     min="0" max="9999999999"> ${internationalConfig.订单},${internationalConfig.按}
                            <input name="orderConfig.limitBase1" value="${v2CpShareConfig.orderConfig.limitBase1}" class="easyui-numberbox" precision="2"
                                   min="0.00" max="9999.99"> ${internationalConfig.priceUnit}
                        </td>
                    </tr>
                    <tr id="orderConfiglimit2">
                        <td></td>
                        <td>
                            ${internationalConfig.达到}<input name="orderConfig.limit2" value="${v2CpShareConfig.orderConfig.limit2}" class="easyui-numberbox"
                                     min="0" max="9999999999"> ${internationalConfig.订单},${internationalConfig.按}
                            <input name="orderConfig.limitBase2" value="${v2CpShareConfig.orderConfig.limitBase2}" class="easyui-numberbox" precision="2"
                                   min="0.00" max="9999.99"> ${internationalConfig.priceUnit}
                        </td>
                    </tr>--%>
                    <%--<tr>
                        <td>每笔封顶：</td>
                        <td><input name="orderConfig.maxLimitMoney" value="${v2CpShareConfig.orderConfig.maxLimitMoney}"
                                   class="easyui-numberbox" min="0" max="9999999999"/>priceUnit
                        </td>
                    </tr>
                    <tr>
                        <td>订单金额达到：</td>
                        <td><input name="orderConfig.minLimitMoney" value="${v2CpShareConfig.orderConfig.minLimitMoney}"
                                   class="easyui-numberbox" min="0" max="9999999999"/>priceUnit后才算
                        </td>
                    </tr>--%>
                </table>
            </div>
            <!-- 业务订单配置 -->
            <div id="configDiv6" title="${internationalConfig.业务订单分成配置}">
                <table class="table-more">
                    <tr>
                        <td><b style="color: red">*</b>${internationalConfig.类别}：</td>
                        <td>
                            <select id="memberType6" name="memberType" disabled>
                                <option value="1">hungama</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td><b style="color: red">*</b>${internationalConfig.规则}：</td>
                        <td>
                            <input name="businessConfig.base" value="${v2CpShareConfig.businessConfig.base}" class="easyui-numberbox" precision="2"
                                   min="0.00" max="9999.99"> ${internationalConfig.priceUnit}${internationalConfig.每个}${internationalConfig.有效订单}
                            <%--<input type="checkbox" name="businessConfig.stimulate" ${v2CpShareConfig.businessConfig.stimulate ? 'checked' : ''} ${v2CpShareConfig.id > 0 && status != 3 ? 'onclick="return false;"' : ''}> ${internationalConfig.是否激励}--%>
                        </td>
                    </tr>
                    <%--<tr id="businessConfiglimit1">
                        <td></td>
                        <td>
                            ${internationalConfig.达到}<input name="businessConfig.limit1" value="${v2CpShareConfig.businessConfig.limit1}" class="easyui-numberbox"
                                     min="0" max="9999999999"> ${internationalConfig.订单},${internationalConfig.按}
                            <input name="businessConfig.limitBase1" value="${v2CpShareConfig.businessConfig.limitBase1}" class="easyui-numberbox" precision="2"
                                   min="0.00" max="9999.99"> ${internationalConfig.priceUnit}
                        </td>
                    </tr>
                    <tr id="businessConfiglimit2">
                        <td></td>
                        <td>
                            ${internationalConfig.达到}<input name="businessConfig.limit2" value="${v2CpShareConfig.businessConfig.limit2}" class="easyui-numberbox"
                                     min="0" max="9999999999"> ${internationalConfig.订单},${internationalConfig.按}
                            <input name="businessConfig.limitBase2" value="${v2CpShareConfig.businessConfig.limitBase2}" class="easyui-numberbox" precision="2"
                                   min="0.00" max="9999.99"> ${internationalConfig.priceUnit}
                        </td>
                    </tr>--%>
                    <%--<tr>
                        <td>每笔封顶：</td>
                        <td><input name="businessConfig.maxLimitMoney" value="${v2CpShareConfig.businessConfig.maxLimitMoney}" class="easyui-numberbox"
                                   min="0" max="9999999999"/>priceUnit
                        </td>
                    </tr>
                    <tr>
                        <td>订单金额达到：</td>
                        <td><input name="businessConfig.minLimitMoney" value="${v2CpShareConfig.businessConfig.minLimitMoney}" class="easyui-numberbox"
                                   min="0" max="9999999999"/>priceUnit后才算
                        </td>
                    </tr>--%>
                </table>
            </div>
        </form>
    </div>
</div>
<script>
//easyui查询下拉框 

</script>
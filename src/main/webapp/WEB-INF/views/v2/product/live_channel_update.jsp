<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<style>
	input, textarea, .uneditable-input{width:210px;}
</style>
<div class="easyui-layout" data-options="fit:true,border:false" style="width: 800px; height: 600px">
    <div data-options="region:'center',border:true" title="">
        <form id="form" method="post">
            <input name="chargePlatform" type="hidden" value="">

            <table style="width: 100%;" class="table table-form">

                <tr>
                    <th>${internationalConfig.Channel名称}</th>
                    <td><input name="channelName" type="text" value="${liveChannel.channelName}" readonly="readonly"></td>
                    <th>CHANNEL ID</th>
                    <td><input name="channelId" type="text" value="${liveChannel.channelId}" readonly="readonly">
                    </td>
                </tr>
                <tr>
                    <th>${internationalConfig.总试看时长}</th>

                    <td colspan="3"><input name="tryViewTime" type="text" value="${liveChannel.tryViewTime}" readonly="readonly">
                </tr>
                <tr>
                    <th>${internationalConfig.付费类型}</th>
                    <td colspan="3">
                        <input id="chargeType_v" name="chargeType" type="checkbox" checked="checked"  value="2" on onchange="chargeTypeChange(this)" />${internationalConfig.会员}
                    </td>
                </tr>
                <tr>
                    <th>${internationalConfig.内容特权}</th>
                    <td colspan="3" >
                        <p>
                            <c:forEach items="${aggPackageList}" var="aggPackage">
                                <span style="display: inline-block">
                                	<c:set var="match" value="0" />
			        		        <c:forEach items="${bindedAggPackageIdList}" var="bindedId">
			        		        	<c:if test="${aggPackage.id==bindedId}">
			        		        		<c:set var="match" value="1" />
			        		        	</c:if>
			        		        </c:forEach>
                                    <input id="aggPackage_${aggPackage.id}" type="checkbox" name="aggPackageList" value="${aggPackage.id}" <c:if test="${movie.chargeType == 0 }"> disabled='true' </c:if> <c:if test="${match==1}"> checked="checked" </c:if> /> ${aggPackage.aggPackageName} &nbsp;&nbsp;
                                </span>
                            </c:forEach>
                        <p>
                    </td>
                </tr>
                <!-- 
                <tr>
                    <th>可看会员</th>
                    <td>
                        <input id="chargeVipType" class="easyui-combobox" name="chargeVipType"/>
                    </td>
              	</tr>
              	-->
              	<tr>
                    <th>${internationalConfig.收费平台}</th>
                    <td colspan="20">
                        <table class="no-border-table">
                            <tr style="border:0;">
                                <c:forEach items="${terminalList}" var="terminal">
                                    <td style="padding-right:10px;">
                                        <c:choose>
                                            <c:when test="${fn:contains(selectedTerminalIds, terminal.terminalId)}">
                                                <input id="terminal${terminal.terminalId}" type="checkbox"
                                                       name="terminalList" checked="checked" value="${terminal.terminalId}"
                                                       onchange="payTerminal(${terminal.terminalId})"/>${terminal.terminalName}
                                            </c:when>
                                            <c:otherwise>
                                                <input id="terminal${terminal.terminalId}" type="checkbox"
                                                       name="terminalList" value="${terminal.terminalId}"
                                                       onchange="payTerminal(${terminal.terminalId})"/>${terminal.terminalName}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </c:forEach>
                            </tr>
                        </table>
                    </td>
                </tr>
              	<tr>
                    <th>${internationalConfig.是否收费}</th>
                    <td colspan="3">
                        <input name="isPay" type="radio" disabled value="1"/>${internationalConfig.付费}
                        <input name="isPay" type="radio" disabled value="0" style="margin-left:10px"/>${internationalConfig.免费}
                    </td>
                </tr>
                <tr>
                    <th>${internationalConfig.状态}</th>
                    <td colspan="3">
                        <select name="status" id="status" >
                            <option value="1">${internationalConfig.未发布}</option>
                            <option value="3">${internationalConfig.已发布}</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>${internationalConfig.描述信息}</th>
                     <td colspan="3"	><textarea   name="ext"  style="width: 219px; height: 66px;">${liveChannel.ext}</textarea></td>
                </tr>
            </table>
        </form>
    </div>
</div>
<script type="text/javascript">

    $("input[name=isPay][value=${liveChannel.isPay}]").attr("checked", true);
    $("input[name=chargeType][value='${liveChannel.chargeType}']").attr("checked", true);
    $("#status").val('${liveChannel.status}');
    /*
    $("#chargeVipType").combobox({
        data:${vipPackageTypes},
        valueField: 'id',
        textField: 'name',
        multiple: true,
        panelHeight: 'auto'
    });
    */

    $(function () {
        parent.$.messager.progress('close');
        $('#form').form({
            url: '/v2/product/live_channel/save',
            onSubmit: function () {
                parent.$.messager.progress({
                    title: '${internationalConfig.提示}',
                    text: '${internationalConfig.数据处理中}....'
                });
                var isValid = $(this).form('validate');
                if (!isValid) {
                    parent.$.messager.progress('close');
                }

                var isCharge = $('input:radio[name="isPay"]:checked').val();
                var isTrue = true;
                if (isCharge == 1) { //付费
                    var str = '';
                    $($("input:checkbox[name='terminalList']")).each(function (index, element) {
                        if ($(this).is(':checked')) {
                            isTrue = false;
                            if (str) {
                                str += ',';
                            }
                            str += element.value;
                        }
                    });

                    if (isTrue) {
                        parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.必须选择付费平台}', 'error');
                        parent.$.messager.progress('close');
                        return false;
                    } else {
                        $("input[name='chargePlatform']").val(str);
                    }
                } else if (isCharge == 0) { //免费
                    $($("input:checkbox[name='terminalList']")).each(function () {
                        if ($(this).is(':checked')) {
                            isTrue = false;
                        }
                    });

                    if (!isTrue) {
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
    
    function chargeTypeChange(chargeTypeComp) {
    	// alert(chargeTypeComp.checked);
		// alert(chargeTypeComp.value);
    	var aggPackageListComp = document.getElementsByName('aggPackageList');
    	if (chargeTypeComp.checked) {
    		// 会员
    		for (var i = 0; i < aggPackageListComp.length; i++) {
    			aggPackageListComp[i].disabled = false;
    		}
    	} else {
    		for (var i = 0; i < aggPackageListComp.length; i++) {
    			aggPackageListComp[i].disabled = true;
    		}
    	}
    }

    function payTerminal(terminalid) {
        if (terminalid == '141001') {
            if ($("#terminal141001").is(':checked')) {
                $("#terminal141005").prop('checked', true);
                $("#terminal141003").prop('checked', true);
                $("#terminal141001").prop('checked', true);
            } else {
                $("#terminal141005").prop('checked', false);
                $("#terminal141003").prop('checked', false);
                $("#terminal141001").prop('checked', false);
            }
        }

        if (terminalid == '141003') {
            if ($("#terminal141003").is(':checked')) {
                $("#terminal141005").prop('checked', true);
                $("#terminal141003").prop('checked', true);
                $("#terminal141001").prop('checked', true);
            } else {
                $("#terminal141005").prop('checked', false);
                $("#terminal141003").prop('checked', false);
                $("#terminal141001").prop('checked', false);
            }
        }

        if (terminalid == '141005') {
            if ($("#terminal141005").is(':checked')) {
                $("#terminal141005").prop('checked', true);
                $("#terminal141003").prop('checked', true);
                $("#terminal141001").prop('checked', true);
            } else {
                $("#terminal141005").prop('checked', false);
                $("#terminal141003").prop('checked', false);
                $("#terminal141001").prop('checked', false);
            }
        }

    }
</script>
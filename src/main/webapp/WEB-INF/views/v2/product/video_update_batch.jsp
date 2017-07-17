<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="easyui-layout" data-options="fit:true,border:false" style="width: 800px; height: 600px">
    <div data-options="region:'center',border:true" title="">
        <form id="form" method="post">
            <input name="chargePlatform" type="hidden" value="">

            <table style="width: 100%;" class="table table-form">

                <tr>
                    <th>${internationalConfig.试看时长}</th>
                    <td colspan="3"><input name="tryLookTime" type="text" class="easyui-numberbox" data-options="min:0,max:360,required:true">
                    </td>
                </tr>

                <tr>
                	<th>${internationalConfig.是否收费}</th>
                    <td>

                        <input name="isCharge" type="radio" value="1" checked>${internationalConfig.付费}
                        <input name="isCharge" type="radio" value="0">${internationalConfig.免费}

                    </td>
                    <th>${internationalConfig.付费类型}</th>
                    <td>
                        <input id="chargeType_t" name="chargeType" type="radio" value="0">${internationalConfig.点播}
                        <input id="chargeType_tv" name="chargeType" type="radio" value="1">${internationalConfig.点播或会员}
                        <input id="chargeType_v" name="chargeType" type="radio" value="2" checked>${internationalConfig.会员}
                    </td>
                </tr>

				<tr>
                    <th>${internationalConfig.内容特权}</th>
                    <td colspan="3">
                    	<p>
                            <c:forEach items="${aggPackageList}" var="aggPackage">
                                <span style="display:inline-block">
	        		        		<input id="aggPackage_${aggPackage.id}" type="checkbox" name="aggPackageList" value="${aggPackage.id}"> ${aggPackage.aggPackageName} &nbsp;&nbsp;
                                </span>
                            </c:forEach>
                        </p>
                    </td>
                </tr>

                <tr>
                    <th>${internationalConfig.收费平台}</th>
                    <td colspan="3">
                        <table class="no-border-table">
                            <tr>
                                <c:forEach items="${terminalList}" var="terminal">
                                    <td>
                                        <input id="terminal${terminal.terminalId}" type="checkbox" name="terminalList" value="${terminal.terminalId}" <%--onchange="payTerminal(${terminal.terminalId})"--%>/>${terminal.terminalName}
                                    </td>
                                </c:forEach>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <th>${internationalConfig.付费规则}</th>
                    <td>
                        <input name="chargeRule" type="radio" value="1" onchange="judge()"/>${internationalConfig.全部正片付费}
                        <c:if test="${currentCountry==86 || currentCountry==852 || currentCountry==1}">
                            <input name="chargeRule" type="radio" value="2" onchange="judge()"/>${internationalConfig.专辑多视频付费}
                        </c:if>
                        <input name="chargeRule" type="radio" value="3" onchange="judge()"/>${internationalConfig.视频付费}
                        <input name="chargeRule" type="radio" value="4" onchange="judge()"/>${internationalConfig.非正片付费}
                    </td>
                    <th>${internationalConfig.是否支持观影券}</th>
                    <td>
                        <input name="supportTicket" type="radio" value="1" checked="checked">${internationalConfig.支持}
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <input name="supportTicket" type="radio" value="0">${internationalConfig.不支持}
                    </td>
                </tr>
                <tr>
                    <th>${internationalConfig.定价方案}</th>
                    <td>
                        <select name="chargeId" id="chargeId">
                            <option value="0">${internationalConfig.无}</option>
                            <c:forEach var="charge" items="${charges}">
                                <option value="${charge.chargeId }">${charge.chargeName }</option>
                            </c:forEach>
                        </select>
                    </td>
                    <th>${internationalConfig.状态}</th>
                    <td>
                        <select name="status" id="status" onchange="releaseStatus()">
                            <option value="0">${internationalConfig.未发布}</option>
                            <option value="1">${internationalConfig.已发布}</option>
                            <option value="2">${internationalConfig.定时发布}</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th width="65" nowrap="nowrap">${internationalConfig.专辑ID列表}<br>(${internationalConfig.多个ID按行分隔})</th>
                    <td colspan="3"><textarea name="id" type="text" rows="8" class='easyui-validatebox' data-options="required:true"></textarea></td>
                </tr>
            </table>
        </form>
    </div>
</div>
<script type="text/javascript">

    var chargeRule = 0;
    $(function () {
        parent.$.messager.progress('close');
        $('#form').form({
            url: '/v2/product/video/batch_update/${copyright}.do',
            onSubmit: function () {
                parent.$.messager.progress({
                    title: '${internationalConfig.提示}',
                    text: '${internationalConfig.数据处理中}....'
                });
                var isValid = $(this).form('validate');
                if (!isValid) {
                    parent.$.messager.progress('close');
                }


                var isCharge = $('input:radio[name="isCharge"]:checked').val();
                var chargeType = $('input:radio[name="chargeType"]:checked').val();
                var isTrue = true;
                var isTrue2 = true;
                //var isTrue3 = true;
                var isTrue4 = true;
                if (isCharge == 1) { //付费
                    var str = '';
                    $($("input:checkbox[name='terminalList']")).each(function (index, element) {
                        if ($(this).is(':checked')) {	//选中收费平台
                            isTrue = false;	
                            if (str) {
                                str += ',';
                            }
                            str += element.value;
                        }
                    });
                    $($("input[name='chargeType']")).each(function (index, element) {
                        if ($(this).is(':checked')) {	//选中付费类型
                            isTrue2 = false;
                        }
                    });
                    $($("input[name='chargeRule']")).each(function (index, element) {
                    	//alert(isTrue4)
                        if ($(this).is(':checked')) {	//选中付费规则
                            isTrue4 = false;
                            //alert(isTrue4)
                        }
                    });
                    /* if(chargeType==1||chargeType==2){
                    	$($("input:checkbox[name='aggPackageList']")).each(function (index, element) {
                            if ($(this).is(':checked')) {	//选中内容特权
                            	isTrue3 = false;
                                 if (str) {
                                    str += ',';
                                }
                                str += element.value; 
                            }
                        });
                    } */
                    if (isTrue||isTrue2) {
                    	parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.必须选择付费平台和付费类型}', 'error');
                        parent.$.messager.progress('close');
                        return false;
                    } /* else if((chargeType==1||chargeType==2)&&isTrue3){
                    	parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.必须选择内容特权}', 'error');
                        parent.$.messager.progress('close');
                        return false;
                    } */ else if(isTrue4){
                    	parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.必须选择付费规则}', 'error');
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

    function releaseStatus() {
        var status = $("#status").val();
        if (status == 2) {
            $("#fixedTimeText").show();
        } else {
            $("#fixedTimeText").hide();
        }
    }

    function chargeTypeChange(chargeTypeId) {
    	var aggPackageListComp = document.getElementsByName('aggPackageList');
    	if ('chargeType_t' == chargeTypeId) {
    		// 点播
    		for (var i = 0; i < aggPackageListComp.length; i++) {
    			aggPackageListComp[i].disabled = true;
    		}
    	} else {
    		// 点播或会员、会员
    		for (var i = 0; i < aggPackageListComp.length; i++) {
    			aggPackageListComp[i].disabled = false;
    		}
    	}
    }

    function judge(){
        var newChargeRule = $("input[name='chargeRule']:checked").val();

        if(chargeRule == 4){
            if(!confirm('确定要将付费规则由非正片付费改为其他类型吗？')){
                $("input[name='chargeRule']:checked").prop("checked","");
                $("input[name='chargeRule'][value='4']").prop("checked", "checked");
                newChargeRule = $("input[name='chargeRule']:checked").val();
            }
            /*parent.$.messager.confirm('询问', '确定要将付费规则由非正片付费改为其他类型吗？', function (b) {
                if (!b){
                    $("input[name='chargeRule']:checked").prop("checked","");
                    $("input[name='chargeRule'][value='4']").prop("checked", "checked");
                    newChargeRule = $("input[name='chargeRule']:checked").val();
                }
            });*/
        }
        chargeRule = newChargeRule;

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
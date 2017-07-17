<%@page import="jmind.core.security.MD5" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');
        $('#form')
                .form(
                {
                    url: '/free_vip/channel/save',
                    onSubmit: function () {
                        parent.$.messager.progress({
                            title: '${internationalConfig.提示}',
                            text: '${internationalConfig.数据处理中请稍后}....'
                        });
                        var isValid = $(this).form('validate');
                        if (!isValid) {
                            parent.$.messager.progress('close');
                        }
                        // alert(isValid);
                        return isValid;
                    },
                    success: function (result) {
                        parent.$.messager.progress('close');
                        result = $.parseJSON(result);
                        if (result.code == 0) {
                            parent.$.messager.alert('${internationalConfig.成功}', result.msg, 'success');
                            parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                            parent.$.modalDialog.handler.dialog('close');
                        } else {
                            parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
                        }
                    }
                });
    });


</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title=""
         style="overflow: auto;">
        <form id="form" method="post">
            <table class="table table-form" style="width:100%">
                <colgroup>
                    <col width="250">
                    <col width="*">
                </colgroup>
                <tr>

                    <td colspan="2"><span>${internationalConfig.渠道名称}：</span><input name="name" type="text" class="easyui-validatebox span2" value="${channel.name }">
                        <span style="font-weight: bold; color: red">* ${internationalConfig.请填写合作公司全称}</span>
                    </td>
                </tr>
                <tr>
                    <td><span>${internationalConfig.渠道描述}：</span><input name="description" type="text" class="easyui-validatebox span2" value="${channel.description }"></td>
                </tr>
                <tr>
                    <td><span>${internationalConfig.需求部门}：</span><input name="department" value="${channel.department}" type="text" class="easyui-validatebox span2" data-options="required:true"></td>
                    <td><span>${internationalConfig.需求申请人}：</span><input name="proposer" value="${channel.proposer}" type="text" class="easyui-validatebox span2" data-options="required:true" placeholder="@le.com"></td>
                </tr>
                <tr>
                    <td><span>${internationalConfig.产品负责人}：</span><input name="productOwner" value="${channel.productOwner}" type="text" class="easyui-validatebox span2" data-options="required:true" placeholder="@le.com"></td>
                    <td><span>${internationalConfig.技术负责人}：</span><input name="technicalDirector" value="${channel.technicalDirector}" type="text" class="easyui-validatebox span2" data-options="required:true" placeholder="@le.com"></td>
                </tr>
                <tr>
                    <td><span>${internationalConfig.开始时间}：</span><input name="start" id="start" value="${channel.start }" class="easyui-datetimebox " data-options="required:true"></td>
                    <td><span>${internationalConfig.结束时间}：</span><input name="end" id="end" value="${channel.end }" class="easyui-datetimebox " data-options="required:true"></td>
                </tr>
                <tr>
                    <td colspan="2"><span>${internationalConfig.会员}：</span>
                        <select name="vipType" style="width:200px;">
                            <%-- 这个不能去，也不能判断不选择，要不boss后台赠送就挂了 --%>
                            <option value="0">${internationalConfig.请选择会员}</option>
                            <c:forEach items="${vptList}" var="item">
                                <option value="${item.id }"   ${channel.vipType==item.id ?"selected" :"" }  >${item.name}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <input type="hidden" name="area" value="0"/>
                <%-- <tr>
                    <td>	<span>${internationalConfig.会员生效区域}：</span>
                        <select name="area">
                            <option value="0"    ${channel.area==0 ?"selected" :"" }>${internationalConfig.通用}</option>
                            <option value="1"    ${channel.area==1 ?"selected" :"" }>${internationalConfig.移动端APP}</option>
                            <option value="2"    ${channel.area==2?"selected" :"" } >${internationalConfig.机卡绑定}</option>
                        </select>
                    </td>
                </tr> --%>
                <tr>
                    <td colspan="2">
                        <span>${internationalConfig.品牌联营}：</span>
                        <select name="platformType" style="width:100px;">
                            <option value="0"   ${channel.platformType==0 ?"selected" :"" }>${internationalConfig.非品牌联营}</option>
                            <option value="1"   ${channel.platformType==1 ?"selected" :"" }>${internationalConfig.品牌联营}</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>
                        <span>${internationalConfig.第三方售卖价格}：</span>
                        <input type="text" name="price" value="${channel.price }" class="tabla_form_input_px  easyui-numberbox" data-options="min:0,required:true"/>
                    </td>
                    <td>
                        <span>${internationalConfig.结算方式}：</span>
                        <select name="clearingForm" style="width:100px;">
                            <option value="1"   ${channel.clearingForm==1 ?"selected" :"" }>${internationalConfig.前置付费}</option>
                            <option value="2"   ${channel.clearingForm==2 ?"selected" :"" }>${internationalConfig.后置付费}</option>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td colspan="2"><span>${internationalConfig.服务时长}：</span><input type="text" name="days" value="${channel.days }" class="tabla_form_input_px  easyui-numberbox"
                                                                        data-options="min:0,max:365,required:true"/>${internationalConfig.天}<%-- ，
                        &nbsp;&nbsp;&nbsp;<span>${internationalConfig.赠送观影卷}：</span><input type="text" name="ticket" value="${channel.ticket }" class="tabla_form_input_px  easyui-numberbox"
                                                                                           data-options="min:0,max:100,required:true"/>${internationalConfig.张}--%></td>
                </tr>
                <tr>
                    <td colspan="2"><span>${internationalConfig.同一用户限制}：</span><input type="text" name="uidLimit" value="${channel.uidLimit }" class="tabla_form_input_px  easyui-numberbox"
                                                                           data-options="min:0,required:true"/>（${internationalConfig.不限制}, ${internationalConfig.同一uidmacdeviceId均视为同一用户}）</td>
                 </tr>
                 <tr>
                     <td colspan="2">
                        <span>${internationalConfig.同一ip限制}：</span><input type="text" name="ipLimit" value="${channel.ipLimit }" class="tabla_form_input_px  easyui-numberbox"
                                                                          data-options="min:0,required:true"/>（${internationalConfig.不限制}）
                    </td>
                </tr>

                <tr>
                    <td colspan="2">
                        <span>${internationalConfig.同一签名限制}：</span><input type="text" name="signLimit" value="${channel.signLimit }" class="tabla_form_input_px  easyui-numberbox"
                                                                          data-options="min:0,required:true"/>（${internationalConfig.不限制}）
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <span>${internationalConfig.每日总数限制}：</span><input type="text" name="dailyLimit" value="${channel.dailyLimit }" class="tabla_form_input_px  easyui-numberbox"
                                                                          data-options="min:0,required:true"/>（${internationalConfig.不限制}），
                        <span>${internationalConfig.总数限制}：</span><input type="text" name="sumLimit" value="${channel.sumLimit}" class="tabla_form_input_px  easyui-numberbox"
                                                                        data-options="min:0,required:true"/>（${internationalConfig.不限制}）
                    </td>
                </tr>
                <c:if test="${ ! empty channel && ! empty channel.secret}">
                    <tr>
                        <td colspan="2" style="text-align: left"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${internationalConfig.秘钥}：</span><input type="hidden" value="${channel.id }" name="id"><span
                                style="display:none">${signUrl }</span>
                            <input name="secret" type="text" readonly="readonly" value="${channel.secret}"></td>
                    </tr>

                </c:if>

            </table>
        </form>
    </div>
</div>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<script type="text/javascript">
    $(function () {
        var machineCardInfoList = $("#machineCardInfoList").val();

        parent.$.messager.progress('close');
        $('#form').form({
            url: '/v2/machine_card/toSyncTime',
            onSubmit: function () {
                parent.$.messager.progress({
                    title: '${internationalConfig.提示}',
                    text: '${internationalConfig.数据处理中请稍后}....'
                });
            },
            success: function (obj) {
                parent.$.messager.progress('close');
                var result = $.parseJSON(obj);
                if (result.code==0) {
                    parent.$.messager.alert('${internationalConfig.同步时长结果}', '${internationalConfig.同步时长成功}', 'success');
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                    var batch = result.msg;
                } else {
                    if(machineCardInfoList == ""){
                        parent.$.messager.alert('${internationalConfig.同步时长结果}', '${internationalConfig.请先配置会员列表}', 'error');
                    }else{
                        parent.$.messager.alert('${internationalConfig.同步时长结果}', '${internationalConfig.同步时长失败}', 'error');
                    }
                }
            }
        });
    });

</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title=""
         style="overflow: auto;">
        <form id="form" method="post"
              action="/v2/machine_card/toSyncTime"   onsubmit="return false;">
            <input name="deviceKey" type="hidden" value="${deviceKey}"/>
            <input name="mac" type="hidden" value="${mac}"/>
            <input id="machineCardInfoList" type="hidden" value="${machineCardInfoList}"/>

            <table style="margin-left: 30px; margin-top: 40px">
                <tr>
                    <th>${internationalConfig.限制规则}</th>
                    <td>
                        <input name="isBindDevice" checked='checked' value="1" type="radio">${internationalConfig.不限设备}&nbsp;&nbsp;<input name="isBindDevice"  type="radio" value="2">${internationalConfig.限制设备}
                    </td>
                </tr>
                <c:if test="${machineCardInfoList!=null }">
                    <c:forEach items="${machineCardInfoList}" var="info">
                        <tr>
                            <th><input name="productId" type="hidden" value="${info.productId}"/>${info.productName}：</th>
                            <td>
                                <label>
                                    <c:choose>
                                        <c:when test="${info.bindDuration>0}">
                                            <c:choose>
                                                <c:when test="${info.bindDurationUnit==1}">
                                                    <input type="text" name="bindDuration"
                                                           style="width: 120px" class="easyui-numberbox" value="${info.bindDuration}" />${internationalConfig.年}
                                                    <input name="durationUnit" type="hidden" value="1"/>
                                                </c:when>
                                                <c:when test="${info.bindDurationUnit==2}">
                                                    <input type="text" name="bindDuration"
                                                           style="width: 120px" class="easyui-numberbox" value="${info.bindDuration}" />${internationalConfig.个月}
                                                    <input name="durationUnit" type="hidden" value="2"/>
                                                </c:when>
                                                <c:when test="${info.bindDurationUnit==5}">
                                                    <input type="text" name="bindDuration"
                                                           style="width: 120px" class="easyui-numberbox" value="${info.bindDuration}" />${internationalConfig.天}
                                                    <input name="durationUnit" type="hidden" value="5"/>
                                                </c:when>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <input type="text" name="bindDuration"
                                                style="width: 120px" class="easyui-numberbox"/>${internationalConfig.个月}
                                            <input name="durationUnit" type="hidden" value="2"/>
                                        </c:otherwise>
                                    </c:choose>
                                </label>
                            </td>
                        </tr>
                    </c:forEach>
                </c:if>
            </table>
            <p style="padding:0 15px;line-height:14px; font-size:12px;margin-top:30px;">${internationalConfig.说明}：${internationalConfig.可在此处手动增加机卡绑定的该类会员时长}</p>
        </form>
    </div>
</div>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script type="text/javascript">
$(function () {
    parent.$.messager.progress('close');
    $('#form').form({
        url: '/lecard/update.json',
        onSubmit: function () {
            parent.$.messager.progress({
                title: '${internationalConfig.提示}',
                text: '${internationalConfig.数据处理中}'
            });



            var isValid = $(this).form('validate');
            if (!isValid) {
                parent.$.messager.progress('close');
            }
            return isValid;
        },
        success: function (obj) {
            parent.$.messager.progress('close');
            var result = $.parseJSON(obj);
            if (result.code==0) {
                parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
                parent.$.modalDialog.handler.dialog('close');
                var batch = result.msg;
            } else {
                parent.$.messager.alert('${internationalConfig.页面错误}', result.msg, 'error');
            }
        }
    });
});


</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="" >
        <form id="form" method="post"   action="/lecard/update.json">
            <input type="hidden" name="batch" value="${lecardApply.batch}"/>
            <table class="table table-form">
                <tr>
                    <th width="100">${internationalConfig.申请人姓名}:</th>
                    <td>
                        <label>
                            ${lecardApply.applicant}
                        </label>
                    </td>
                </tr>
                 <tr>
                    <th>${internationalConfig.制卡人}:</th>
                    <td>
                        <label>
                            ${lecardApply.uname}
                        </label>
                    </td>
                </tr>
                <tr>
                    <th>${internationalConfig.申请部门}:</th>
                    <td>
                        <label>
                            ${dict['department'][lecardApply.department]}
                        </label>
                    </td>
                </tr>

                <c:choose>
                    <c:when test="${lecardApply.channelAssociationId == 0}">
                        <tr>
                            <th>${internationalConfig.合作公司}:</th>
                            <td>
                                <label>
                                        ${internationalConfig.未知}
                                </label>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <th>${internationalConfig.合作公司}:</th>
                            <td>
                                <label>
                                        ${camap[lecardApply.channelAssociationId]}
                                </label>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                <tr>
                    <th>${internationalConfig.乐卡类型}:</th>
                    <td>
                        <label>
                            ${lecardApply.applyType==1 ? internationalConfig.充值码 :internationalConfig.兑换码}
                        </label>
                    </td>
                </tr>
                <c:choose>
                    <c:when test="${lecardApply.applyType == 50}">
                        <tr>
                            <th>${internationalConfig.申请面额}:</th>
                            <td>
                                <label>
                                        ${lecardApply.amount}
                                </label>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <th>${internationalConfig.申请面额}:</th>
                            <td>
                                <label>
                                        ${lecardApply.amount}
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <th>${internationalConfig.结算金额}:</th>
                            <td>
                                <label>
                                        ${lecardApply.price}
                                </label>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                <tr>
                    <th>${internationalConfig.申请数量}:</th>
                    <td>
                        <label>
                            ${lecardApply.cardCount}
                        </label>
                    </td>
                </tr>
                <c:if test="${lecardApply.applyType == 2}">
                    <tr>
                        <th>${internationalConfig.兑换套餐}:</th>
                        <td>
                            <label>
                                    ${applyPackageList[lecardApply.applyPackage].packageNameDesc}
                            </label>
                        </td>
                    </tr>
                </c:if>
                <c:if test="${lecardApply.applyType == 2}">
                    <tr>
                        <th>${internationalConfig.首次赠送观影券张数}:</th>
                        <td>
                            <label>
                                    ${lecardApply.couponCount}
                            </label>
                        </td>
                    </tr>
                </c:if>
                <c:if test="${lecardApply.applyType == 2}">
                    <tr>
                        <th>${internationalConfig.观影券有效期}:</th>
                        <td>
                            <label>
                                    ${lecardApply.couponDays}
                            </label>
                        </td>
                    </tr>
                </c:if>
                
               
                <tr>
                    <th>${internationalConfig.失效日期}:</th>
                    <td>
                        <label>
                            <input name="expireDate"   value="${lecardApply.expireDate}" class="easyui-datebox " data-options="required:true"  >
                        </label>
                    </td>
                </tr>
                <tr>
                    <th>${internationalConfig.发行类型}:</th>
                    <td>
                        <label>
                            ${lecardApply.releaseType==1 ? "电子码":"实体码"}
                        </label>
                    </td>
                </tr>
                <tr>
                    <th>${internationalConfig.申请原因}</th>
                    <td>
                        <label>
                            ${lecardApply.applyReasonDesc}
                        </label>
                    </td>
                </tr>
                    <tr>
                    <th>${internationalConfig.用户使用次数限制}</th>
                    <td>
                        <label>
                           <input type=text  name="maxUseTime"  value=" ${lecardApply.maxUseTime}" />
                        </label>
                    </td>
                </tr>
                
                 <tr>
                    <th>${internationalConfig.已使用张数}</th>
                    <td>
                        <label>
                            ${activeCount}
                        </label>
                    </td>
                </tr>
                 <tr>
                    <th>${internationalConfig.未使用张数}</th>
                    <td>
                        <label>
                            ${lecardApply.cardCount-activeCount}
                        </label>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
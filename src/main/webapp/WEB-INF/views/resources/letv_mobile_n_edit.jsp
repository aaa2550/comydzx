<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div class="easyui-layout" data-options="fit:true,border:false">

    <div data-options="region:'center',border:false" title="" style="overflow: hidden;">
        <form id="form" method="post"  action="/letv_mobile/n_edit">
        
            <table class="table-scan" style="margin-left: 10px;margin-top: 10px">
                <tr>
                    <th>${internationalConfig.型号}:</th>
                    <td>
                        <label>
                        <input type="hidden"  name="id"  value="${id }">
                            ${letvMobileN.mode}
                        </label>
                    </td>
                </tr>
                 <tr>
                    <th>${internationalConfig.容量}:</th>
                    <td>
                        <label>
                            ${letvMobileN.flash} G
                        </label>
                    </td>
                </tr>
                <tr>
                    <th>${internationalConfig.可领取服务次数}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>N<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.值}:</th>
                    <td>
                        <label>
                       <input name="n" value="${letvMobileN.n }"  />
                        </label>
                    </td>
                </tr>
               
            </table>
        </form>
    </div>
</div>
<script>
$(function () {
    parent.$.messager.progress('close');
    $('#form').form({
        onSubmit: function () {
            url: '/letv_mobile/n_edit',
            parent.$.messager.progress({
                title: '${internationalConfig.提示}',
                text: '${internationalConfig.数据处理中}'
            });

            return true;
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
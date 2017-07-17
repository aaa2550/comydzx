<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');
        $('#form').form({
            url: '${pageContext.request.contextPath}/sportlive_dic/update.json',
            onSubmit: function () {
                parent.$.messager.progress({
                    title: '${internationalConfig.提示}',
                    text: '${internationalConfig.数据处理中}....'
                });
                var isValid = $(this).form('validate');
                if (!isValid) {
                    parent.$.messager.progress('close');
                }
                return isValid;
            },
            success: function (result) {
                parent.$.messager.progress('close');
                result = $.parseJSON(result);
                
                if (result.code == 0) {
                  parent.$.messager.alert('${internationalConfig.成功}', "${internationalConfig.编辑成功}", 'success');
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.编辑失败}', 'error');
                }
            }
        });
    });
</script>
<div class="easyui-layout" data-options="fit:true,border:false" style="width: 800px; height: 600px">
    <div data-options="region:'center',border:true" title="" style="overflow: hidden;">
        <form id="form" method="get">
            <table class="table table-form">
        <colgroup>
          <col width="80">
          <col width="100">
          <col width="80">
          <col width="*">
        </colgroup>
                <tr>
                    <th>${internationalConfig.编号}</th>
                    <td><input name="id" type="text" value="${seasonLiveDic.id}" readonly="readonly"></td>
                    <th>${internationalConfig.字典类型}</th>
                    <td><input name="type" type="hidden" value="${seasonLiveDic.type}" readonly="readonly" id="type">
                    <input name="typeDescription" type="text" value="${seasonLiveDic.typeDescription}" readonly="readonly" id="typeDescription">
                    </td>
                </tr>
                <tr>
                  <th>${internationalConfig.上级ID}</th>
                    <td><input name="pid" type="text" value="${seasonLiveDic.pid}" readonly="readonly" id="pid"></td>
                    <th>${internationalConfig.字典描述}</th>
                    <td><input name="description" type="text" value="${seasonLiveDic.description}"></td>
                </tr>
                <tr>
                  <th>${internationalConfig.图片URL}</th>
                  <td><input name="imageUrl" type="text" value="${seasonLiveDic.imageUrl}"></td>
                  <th></th><td></td>
                </tr>
            </table>
        </form>
    </div>
</div>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<style>
    select {
        width: 180px;
        font-size:12px;
    }
    input{
    	font-size:12px;
    }
</style>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title=""
         style="overflow: auto;">
        <form id="form" method="post" enctype="multipart/form-data" action="/v2/machine_card/batch_sync_vip_duration.do" onsubmit="return false;">
            <table class="table table-form">
            <tr>
                <td>${internationalConfig.上传需同步的设备}:<br/><input type="file" id="myFile" name="myFile" size="100" style="width:300px;"
                                              class="easyui-validatebox" data-options="required:true"></td>
            </tr>
            <tr>
                <td>
                    ${internationalConfig.同步设备时长}:<br>
                    <select id="productId" name="productId" class="easyui-validatebox" validType="checkRequired" data-options="required:true">
                        <option value="">${internationalConfig.请选择会员名称}</option>
                        <c:forEach items="${vipPackageTypeList}" var="vipType">
                            <option value="${vipType.id}">${vipType.name}</option>
                        </c:forEach>
                    </select>
                    <input type="text" name="duration" id="duration" class="span2 easyui-validatebox easyui-numberbox" data-options="required:true,validate:'digits',min:1,precision:0">${internationalConfig.个月}
                    <input type="hidden" name="durationUnit" value="2">
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <p>${internationalConfig.批量同步时长_说明_长文本}</p>
                </td>
            </tr>
            </table>
        </form>
    </div>
</div>

<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');
        $('#form').form({
            url: '/v2/machine_card/batch_sync_vip_duration.do',
            onSubmit: function () {
                var isValid = $(this).form('validate');
                if (!isValid) {
                    return isValid;
                }
                parent.$.messager.progress({
                    title: '${internationalConfig.提示}',
                    text: '${internationalConfig.数据处理中请稍后}....'
                });
                return isValid;
            },
            success: function (obj) {
                parent.$.messager.progress('close');
                var result = $.parseJSON(obj);
                if (result.code==0) {
                    parent.$.messager.alert('${internationalConfig.页面成功}', '${internationalConfig.文件上传中}', 'success');
                    //parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                    var batch = result.msg;
                } else {
                    parent.$.messager.alert('${internationalConfig.页面错误}', result.msg, 'error');
                }
            }
        });
    });

</script>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');
        $('#form').form({
            //url: '/device/upload.json',
            url: '/device/special_phone_upload.json',
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
                    //parent.$.messager.alert('页面成功', '成功上传'+result.data+'条专机设备记录', 'success');
                    //parent.$.messager.alert('页面成功', '成功上传专机设备记录', 'success');
                    parent.$.messager.alert('${internationalConfig.页面成功}', result.msg, 'success');
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');
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
    <div data-options="region:'center',border:false" title=""
         style="overflow: hidden;">
        <form id="form" method="post" enctype="multipart/form-data">
            <table style="margin-left: 30px; margin-top: 20px">
                <tr>
                    <td>
                        PID：<input id="pid" name="pid" type="text" style="width: 200px;"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <p>
                            <label> ${internationalConfig.请选择要上传的设备文件}:</label>
                        </p>
                        <p>
                            <input type="file" name="myfile" size="100" style="width:300px;">
                        </p>
                        <p style="margin-top:5px;padding-top:5px;border-top:1px solid #ccc">
                            <label><font style="color: red;">${internationalConfig.注}：</font>${internationalConfig.上传格式为txt格式}</label>
                        </p>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
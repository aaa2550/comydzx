<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');
        $('#form').form({
            url: '/device/check.json',
            onSubmit: function () {
                parent.$.messager.progress({
                    title: '${internationalConfig.提示}',
                    text: '${internationalConfig.数据处理中}'
                });
            },
            success: function (obj) {
                parent.$.messager.progress('close');
                var result = $.parseJSON(obj);
                if (result.code==0) {
                	 parent.$.messager.alert('${internationalConfig.校验结果}', '${internationalConfig.成功上传的设备信息均存在}', 'success');
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                    var batch = result.msg;
                } else {
                    parent.$.messager.alert('${internationalConfig.校验结果}', '${internationalConfig.校验结果已经发送到您的邮件}', 'error');
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
					<p>
					<label> ${internationalConfig.请选择要上传的文件}(<font style="color: red;">${internationalConfig.仅支持}&nbsp;xls,xlsx&nbsp;${internationalConfig.格式}</font>)
					</label>
					</p>
					<p>
					<input type="file" name="myfile" size="100" style="width:300px;">
					</p>
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>
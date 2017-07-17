<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');
        $('#form').form({
            url: '/device/upload.json',
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
                	 parent.$.messager.alert('${internationalConfig.页面成功}', '${internationalConfig.成功上传}'+result.data+'${internationalConfig.条机卡设备记录}', 'success');
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
					<p>
					<label> ${internationalConfig.请选择要上传的文件}(<font style="color: red;">${internationalConfig.仅支持}xls, xlsx${internationalConfig.格式}</font>)</label>
					</p>
					<p>
					    <input type="file" name="myfile" size="100" style="width:300px;">
					</p>
					<p style="margin-top:5px;padding-top:5px;border-top:1px solid #ccc">
					<label><font style="color: red;">${internationalConfig.注}1：</font>${internationalConfig.务必保证数据的排列顺序为}：sn, mac, key, devicetype</label>
					<label><font style="color: red;">${internationalConfig.注}2：</font>${internationalConfig.再次确认}devicetype${internationalConfig.取值}：<br><span style="display:inline-block;width:30px;"></span>（1：${internationalConfig.超级电视}； 2：${internationalConfig.超级手机}； <font style="color: red; font-weight:bold;">3：${internationalConfig.盒子}； 4：${internationalConfig.路由器}</font>）</label>
					</p>
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>
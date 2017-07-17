<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');
        $('#form').form({
            url: '/device/ex_Change.do',
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
                	 parent.$.messager.alert('${internationalConfig.换机成功}',  result.msg);
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                    var batch = result.msg;
                } else {
                	parent.$.messager.alert('${internationalConfig.换机失败}',result.msg);
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                }
            }
        });
    });

</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title=""
		style="overflow: hidden;">
		<form id="form" method="post"
			action="/device/ex_Change.do"   onsubmit="return false;">
			<table style="margin-left: 30px; margin-top: 40px">
				<tr>
					<th>${internationalConfig.请输入新的}&nbsp;MAC/IMEI：</th>
					<td><label> 
					 <input type="text" name="newmac" style="width: 120px" class="easyui-validatebox"  data-options="min:0,max:60,precision:0,required:true" />
							<input type="hidden" name="mac"  value="${mac}"/>
							<input type="hidden" name="deviceType"  value="${deviceType}"/>
					</label></td>
				</tr>
			</table>
			<p style="padding:0 15px;line-height:14px; font-size:12px;margin-top:20px;">${internationalConfig.说明}：${internationalConfig.当换机成功后}，${internationalConfig.原设备绑定赠送的所有会员剩余时长都将转移至新设备}</p>
		</form>
	</div>
</div>
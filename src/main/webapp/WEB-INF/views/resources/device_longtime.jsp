<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');
        $('#form').form({
            url: '/device/longtime.json',
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
                	 parent.$.messager.alert('${internationalConfig.同步时长结果}', '${internationalConfig.同步时长成功}', 'success');
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                    var batch = result.msg;
                } else {
                    parent.$.messager.alert('${internationalConfig.同步时长结果}', result.msg, 'error');
                }
            }
        });
    });

</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title=""
		style="overflow: hidden;">
		<form id="form" method="post"
			action="/device/synctime.json"   onsubmit="return false;">
			<table style="margin-left: 30px; margin-top: 40px">
				<tr>
					<th>${internationalConfig.乐次元影视会员}：</th>
					<td><label> <input type="text" name="resourceId"
							style="width: 120px" class="easyui-numberbox"  data-options="min:0,precision:0,required:true" />${internationalConfig.个月}
							<input type="hidden" name="mac"  value="${mac}"/>
							<input type="hidden" name="vipType"  value="1"/>
					</label></td>
					
				</tr>
				<tr>
					<th>${internationalConfig.超级影视会员}：</th>
					<td><label> <input type="text" name="resourceIdMovie"
							style="width: 120px" class="easyui-numberbox"  data-options="min:0,precision:0,required:true" />${internationalConfig.个月}
							<input type="hidden" name="vipTypeMovie"  value="2"/>
					</label></td>
					
				</tr>
				<tr>
					<th>${internationalConfig.乐视超级体育会员}：</th>
					<td><label> <input type="text" name="resourceIdSport"
							style="width: 120px" class="easyui-numberbox"  data-options="min:0,precision:0,required:true" />${internationalConfig.个月}
							<input type="hidden" name="vipTypeSport"  value="3"/>
					</label></td>
					
				</tr>
			</table>
		<p style="padding:0 15px;line-height:14px; font-size:12px;margin-top:30px;">${internationalConfig.说明}：${internationalConfig.可在此处手动增加机卡绑定的该类会员时长}</p>
		</form>
	</div>
</div>
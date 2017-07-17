<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<style>
	#choosefile{
        width:280px;
        height:26px;
        opacity: 0;
        z-index: 2;
        position: absolute;
    }
    .file_mask{
        z-index: 1;
        width: 260px;
        height:26px;
        border: 1px solid #ccc;
        border-radius:3px;
    }
    .file_mask{height:20px;padding: 3px 5px;line-height:20px;}
</style>
<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');
        $('#form').form({
            url:'/outsideCode/importCode',
            onSubmit: function () {
            	return $(this).form('validate');
                parent.$.messager.progress({
                    title: '${internationalConfig.提示}',
                    text: '${internationalConfig.数据处理中}'
                });
            },
            success: function (obj) {
                parent.$.messager.progress('close');
                var result = $.parseJSON(obj);
                if (result.code==0) {
                	var res = result.data;
                    parent.$.messager.alert('${internationalConfig.页面成功}', '${internationalConfig.总共}:'+res.total+'${internationalConfig.条}，${internationalConfig.上传成功}：'+res.dealCount+'${internationalConfig.条}', 'success');
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                    var batch = result.msg;
                } else if(result.code==5){
                    parent.$.messager.alert('${internationalConfig.页面错误}', '${internationalConfig.上传数据大于10000条}', 'error');
                }else if(result.code==4){
                	parent.$.messager.alert('${internationalConfig.页面错误}', '${internationalConfig.上传数据不能为空}', 'error');
                }else if(result.code==6){
                	parent.$.messager.alert('${internationalConfig.页面错误}', '${internationalConfig.文件格式不对}', 'error');
                }else if(result.code==7){
                	parent.$.messager.alert('${internationalConfig.页面成功}', '${internationalConfig.文件上传中}', 'success');
                }else{
                	parent.$.messager.alert('${internationalConfig.页面错误}', '${internationalConfig.上传失败}', 'error');
                }
            }
        });
    });

    $.extend($.fn.validatebox.defaults.rules, {
	    checkRequired: {
	        validator: function (value, param) {
	            if(value=="-1"){
	            	return false;
	            }else{
	            	return true;
	            }
	        },
	        message: '${internationalConfig.请选择}'
	    }
    });
    $("#choosefile").change(function(){
        if(this.value.indexOf('.xls') < 0){
        	$(".file_mask").css({"border":"1px solid #f00","color":"#f00"});
        	$(".file_mask span").html("${internationalConfig.请上传EXCEL文件}");
        	this.value="";
        }else{
        	$(".file_mask").css({"border":"1px solid #ccc","color":"#000"})
            $(".file_mask span").html(this.value);
        }
    });
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post" enctype="multipart/form-data">
			<table style="width: 100%" class="table table-form">
				<tr>
					<th>${internationalConfig.会员名称}</th>
					<td>
					       <select name="productId" class="span2 easyui-validatebox"  validType="checkRequired">
					       <option value="-1" selected>${internationalConfig.请选择}</option>
					       <c:forEach items="${vPTypeList}" var="packageType">
                                <option value="${packageType.id}">${packageType.name}</option>
                           </c:forEach>
                           </select>
                    </td>
				</tr>
				<tr>
					<th>${internationalConfig.会员时长}</th>
					<td>
						<input type="text" name="duration" class="span2 easyui-validatebox" data-options="required:true"/>
						<select name="durationUnit" class="span2 easyui-validatebox" validType="checkRequired">
							<option value="1">${internationalConfig.年}</option>
                            <option value="2">${internationalConfig.月}</option>
                            <option value="5">${internationalConfig.天}</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>${internationalConfig.使用场景}</th>
					<td>
						<select name="useType" class="span2 easyui-validatebox" validType="checkRequired">
							<option value="0">${internationalConfig.机卡绑定站外会员}</option>
							<option value="1">${internationalConfig.售卖站外会员}</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>${internationalConfig.导入文件}</th>
					<td style="position: relative">
						<input type="file" name="sourceFile" id="choosefile" size="100" style="width:300px;" class="span2 easyui-validatebox"  data-options="required:true" accept=".xls,.xlsx">
						<p class="file_mask"><span></span></p>
					</td>
				</tr>
				<tr style="border:0">
					<td style="padding:0;"></td>
					<td style="padding:0 0 0 8px; color:#f00;">${internationalConfig.文件格式为一行一个兑换码且文件格式为Excel}</td>
				</tr>
			</table>
		</form>
	</div>
</div>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.付费卡详细信息批量导出}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">

	function submit_form() {
		//判断是否上传uuid文件
		var file_name = $("input[name=myfile]").val();
	    
	    if(file_name == "") {
	    	parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.请上传乐卡文件}", 'error');
	    	return ;
	    }
		
		$("#form").submit();
		
		$("#btn1").attr("disabled", "true");
		$("#btn1").attr("value", "${internationalConfig.请求已提交}");
	}
	
	
	function setBtnStatus() {
		$("#btn1").removeAttr("disabled");
		$("#btn1").attr("value", "${internationalConfig.导出}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>CSV");
	}
</script>
</head>

<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
         style="height:1000px;overflow:auto;">
		<!-- 上传文件并导出Excel -->
		<form id="form" action="/lecard/info_batch" method="post"
			enctype="multipart/form-data"  accept-charset="UTF-8" >
			<table class="table table-hover table-condensed">
            	<tr>
            		<td>${internationalConfig.选择文件}</td>
            		<td>${internationalConfig.导出明细}</td>
            	</tr>
				<tr>
                    <td>
                    	<input style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;" onchange="setBtnStatus()" type="file" name="myfile"><br> 
                    </td>
                    <td>
                    	<input style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;" type="button" id="btn1" onclick="submit_form()" value="${internationalConfig.导出}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>CSV">
                    </td>
            	</tr>
         	</table>
		</form>
		<div id="message" style="padding-left:5px;">
			<p><span>${internationalConfig.说明}：</span></p>
			<p><span>1.${internationalConfig.乐卡卡号可批量导入}。</span></p>
			<p><span>2.${internationalConfig.导出文件包含}:${internationalConfig.序列号},${internationalConfig.卡号},${internationalConfig.卡状态},${internationalConfig.使用者}&nbsp;ID,${internationalConfig.批次号},${internationalConfig.创建日期},${internationalConfig.激活时间}。</span></p>
		

		</div>
	</div>
</div>

</body>
</html>
<%@ page contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh">
<head>
<script src="/static/lib/jquery.min.js" type="text/javascript" charset="utf-8"></script>
<script src="/static/lib/ajaxfileupload.js" type="text/javascript" charset="utf-8"></script>
<title>文件上传</title>
</head>
<body>
文件上传：
	<form id="form" method="post" enctype="multipart/form-data"  action="/upload">
			<table style="margin-left: 30px; margin-top: 20px">
				<tr>
					<td>
					<p>
					<label> 请选择要上传的文件(<font style="color: red;">仅支持xls,xlsx,txt格式</font>) 
					</label>
					</p>
					<p>
					<input type="file" name="myfile" size="100">
					<input type="hidden" name="cdn" value="${param.cdn }">
					</p>
					<hr>
					<p>
					<label> <font style="color: red;">注:务必保证数据的排列顺序为:SN码,MAC地址,暗码; txt文件以空格分隔</font>
					</label>
					</p>
					</td>
				</tr>
				<tr><td><input type="submit"></td></tr>
			</table>
		</form>
		
<hr/>
ajax 上传



	<script type="text/javascript">
	function ajaxFileUpload()
	{


		$.ajaxFileUpload
		(
			{
				url:'/upload.json',
				secureuri:false,
				fileElementId:'myfile',
				dataType: 'json',
				beforeSend:function()
				{
				//	$("#loading").show();
				alert("send");
				},
				complete:function()
				{
				//	$("#loading").hide();
				alert("complete")
				},				
				success: function (data, status)
				{
					console.log(data);
					alert(data);
				},
				error: function (data, status, e)
				{
					alert(e);
				}
			}
		)
		
		return false;

	}
	</script>
	
	<input id="myfile" type="file" size="45" name="myfile" class="input">
	<button onclick="ajaxFileUpload();" id="buttonUpload" class="button">Upload</button>
</body>


</html>
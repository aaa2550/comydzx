<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<script src="/static/lib/swfupload/swfupload.js" type="text/javascript" charset="utf-8"></script>
<%--<script type="text/javascript" src="/static/lib/uploadImg4LebiConfig.js" charset="utf-8"></script>--%>

<script type="text/javascript">
	var readFlag=true;
	$(function() {
	
		parent.$.messager.progress('close');
		$('#form').form({
			url : '${pageContext.request.contextPath}/lebi/paypackage/addPaypackage',
			success : function(result) {
				parent.$.messager.progress('close');
				result = $.parseJSON(result);
				if (result.code == 0) {
                	parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.添加成功}', 'success');
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
					parent.$.modalDialog.handler.dialog('close');
				} else {
					parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
				}
			}
		});
		$('.lebi_num').eq(0).validatebox({
			required:true,
			validType:'linkage'
		})
		$("#terminal_pack").change(function(){
			if($(this).val()==141009){
				readFlag=false;
				$('.read_inp').eq(0).validatebox({
					required:true,
					validType:'link'
				})
				$('.read_inp').prop('readonly',false);
			}else{
				readFlag=true;
				$('.read_inp').validatebox({
					required:false
				})
				for(var i=0;i<$('.lebi_num').length;i++){
					linkFn($('.lebi_num').eq(i));
				}
				$('.read_inp').prop('readonly',true);
			}
		})
		
	});
	
	
	
	var packagesize = '${fn:length(vrPackagelist)}';
	function addPackagehtml() {
		var obj = $("input[name='thumbnailsUrlArr']");
		if( packagesize==10 ) {
			alert('最大可添加10条!');
			return;
		}
		packagesize++;
		var appendhtml = '' +
		'<tr>' +
				'<td colspan="3">乐币数量<input type="text" onkeyup="linkFn(this)" name="lbPaynumArr" min="1" precision="0" class="lebi_num" />' +
				' 价格<input type="text"  name="lbPriceArr" min="0.01" precision="2" class="easyui-numberbox read_inp" /></td>' +
//				' 赠送<input type="text" name="lbGivenumArr" min="0" precision="0" class="easyui-numberbox" data-options="required:false" />' +
		 '<td colspan="3"> 赠送<input type="text" name="lbGivenumArr" min="0" precision="0" class="easyui-numberbox" data-options="required:false" /> apple-proID<input type="text" name="expandidArr" style="width: 110px" class="easyui-validatebox"/></td>'+
			'<td colspan="3"><input type="text" class="inp_w" name="thumbnailsUrlArr" value="${config.mobile.pic}" id="configMobilePic' + obj.length + '" placeholder="请选择缩略图" class="span2"/> ' +
		'<input class="props_upload_btn" type="button" value="上传" id="thumbnailsUrlArr'+ obj.length +'" onclick="uploadFile(' + obj.length + ')" /></td>' +
		'</tr>';
		
		$("#tb1").append(appendhtml);
		if(readFlag){
			$("#tb1").find('.read_inp:last').prop('readonly',true)
		};
		uploadFile(obj.length);
		return;
	}
	function linkFn(ele){
		$(ele).next('.read_inp').val($(ele).val()/10);
	}
	$.extend($.fn.validatebox.defaults.rules, {
	    linkage: {
	        validator: function(value, param){
	        	//console.log($(param[0]).next('span').find('input[type="text"]'));
	        	var reg=/^\d*[1-9]+\d*(\.\d+)?$/;
	        	if(reg.test(value)){
					//$(param[0]).next('span').find('input[type="text"]').val(value*2);    	
					/* $(".read_inp[data-id='" +param[0]+ "']").val(value/10); */
	        		return true
	        	}else{
	        		return false;
	        	}
	        },
	        message: '请输入大于0的数字'
	    }
	});
	$.extend($.fn.validatebox.defaults.rules, {
	    link: {
	        validator: function(value, param){
	        	//console.log($(param[0]).next('span').find('input[type="text"]'));
	        	var reg=/^\d+(\.\d+)?$/;
	        	if(reg.test(value)){
					//$(param[0]).next('span').find('input[type="text"]').val(value*2);    	
					/* $(".read_inp[data-id='" +param[0]+ "']").val(value/10); */
	        		return true
	        	}else{
	        		return false;
	        	}
	        },
	        message: '请输入数字'
	    }
	});

	function uploadFile(id){
		new SWFUpload({
			button_placeholder_id: 'thumbnailsUrlArr' + id,
			flash_url: "/static/lib/swfupload/swfupload.swf?rt=" + Math.random(),
			upload_url: '/upload?cdn=sync',
			button_image_url: $.cookie('boss_lang') == 'zh' ? '/static/lib/swfupload/upload_zh.png' : '/static/lib/swfupload/upload_en.png',
			button_cursor: SWFUpload.CURSOR.HAND,
			button_action: SWFUpload.BUTTON_ACTION.SELECT_FILE,
			file_size_limit: '8 MB',
			button_width: "61",
			file_post_name: "myfile",
			button_height: "24",
			file_types: "*.jpg;*.jpeg;*.png;*.bmp;*.gif",
			file_types_description: "All Image Files",
			button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
			upload_start_handler: function () {
			},
			upload_success_handler: function (file, response) {
				/*var HTML_VIEWS = '<a href=' + response + ' target="_blank">查看图片</a>&nbsp;&nbsp;&nbsp;&nbsp;';
				 $("#img-mobile").html(HTML_VIEWS);*/
				$("#configMobilePic" + id).val(response);
			},
			file_queued_handler: function () {
				this.startUpload();
			},
			upload_error_handler: function (file, code, msg) {
				var message = '上传失败，请稍后重试。错误码：' + code + ': ' + msg + ', ' + file.name;
				alert(message);
			}
		});
	}

	$(document).ready(function(){
		var obj = $("input[name='thumbnailsUrlArr']");
		for(i = 0; i < obj.length; i++){
			uploadFile(i);
		}
	});
</script>

<style>
	input, textarea, .uneditable-input {
		width: 80px;
		border:1px solid #ccc;
	}
</style>

<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post" >
			<table style="width: 100%" class="table table-form" id="tb1">
				<colgroup>
					<col width="90">
					<col width="100">
					<col width="80">
					<col width="*">
				</colgroup>
				<tr>
					<th>乐币包名称：</th>
					<td>
						<input type="text" name="packageName" class="easyui-validatebox" data-options="required:true" />
					</td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<th>业务线：</th>
					<td>
						<select name="busiId" style="width: 165px">
							<c:forEach items="${businesslist}" var="business">
	                            <option value="${business.bussid}">${business.bussname}</option>
	                        </c:forEach>
						</select>
					</td>
					<td></td>
					<td></td>
				</tr>	
				
				<tr>
					<th>终端：</th>
					<td>
	            	<select id="terminal_pack" name="packageTerminal" class="span2" required="true">
		            	<c:forEach items="${terminals }" var="terminal">
		               		<option value="${terminal.key}">${terminal.value}</option>
		                </c:forEach>
	              	</select>
					</td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<th>有效期：</th>
					<td colspan="3">
						<input type="text" name="packageStartdate" style="width: 180px" class="easyui-datetimebox" class="easyui-validatebox" data-options="required:true" />
						<input type="text" name="packageEnddate" style="width: 180px" class="easyui-datetimebox" class="easyui-validatebox" data-options="required:true" />
					</td>
				</tr>
				<tr>
					<th>活动文案：</th>
					<td colspan="3">
						<input type="text" name="hdDoc" style="width: 180px" class="easyui-validatebox" />
					</td>
				</tr>					
				<c:forEach items="${vrPackagelist }" var="vr" varStatus="status">
				<tr>
					<td colspan="3">
						乐币数量<input type="text"  name="lbPaynumArr" onkeyup="linkFn(this)" class="lebi_num" min="1"  precision="0" <c:choose ><c:when test="${status.index==0 }">data-options="required:true"</c:when><c:otherwise>data-options="required:false"</c:otherwise></c:choose>/>
						价格<input type="text" class="read_inp" readonly="true" name="lbPriceArr" min="0.01" precision="2" <c:choose ><c:when test="${status.index==0 }"> </c:when><c:otherwise></c:otherwise></c:choose> />
					</td>
					<td colspan="3">
						赠送<input type="text" name="lbGivenumArr" min="0" precision="0"/>
						apple-proID<input type="text" name="expandidArr" style="width: 110px"/>
					</td>
					<td colspan="3">
						<input type="text" class="inp_w" name="thumbnailsUrlArr" value="${config.mobile.pic}" id="configMobilePic${status.index}" placeholder="请选择缩略图" class="span2"/>
						<input class="props_upload_btn" type="button" value="上传" id="thumbnailsUrlArr${status.index}" onclick="uploadFile(${status.index})" />
					</td>
				</tr>
				</c:forEach>		
			</table>
			
			<table style="width: 100%" class="table table-form" id="tb2">
				<tr>
					<td ><a href="javascript:addPackagehtml()">增加</a></td>
				</tr>	
			</table>			
		</form>
	</div>
</div>
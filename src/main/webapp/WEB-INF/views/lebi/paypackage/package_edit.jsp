<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
	var readFlag=true;
	
	$(function() {
		parent.$.messager.progress('close');
		
		$('#form').form({
			url : '${pageContext.request.contextPath}/lebi/paypackage/editPaypackage',
			success : function(result) {
				parent.$.messager.progress('close');
				result = $.parseJSON(result);
				if (result.code == 0) {
                	parent.$.messager.alert('${internationalConfig.成功}', '保存成功！', 'success');
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
					parent.$.modalDialog.handler.dialog('close');
				} else {
					parent.$.messager.alert('${internationalConfig.错误}', "保存失败！", 'error');
				}
			}
		});

		if($("#terminal_pack option:selected").val()==141009){
			readFlag=false;
			$('.read_inp').eq(0).validatebox({
				required:true,
				validType:"link"
			})
			$('.read_inp').prop('readonly',false);
		}
		
		
	});
	$(".lebi_num").eq(0).validatebox({
		required:true,
		validType:['linkage']
		
	})
	var packagesize = '${fn:length(vrPackagelist)}';
	function addPackagehtml() {
		var obj = $("input[name='configMobilePic']");
		if( packagesize==10 ) {
			return;
		}
		packagesize++;
		var appendhtml = '' +
				'<tr>' +
				'<td>乐币数量<input type="text" onkeyup="linkFn(this)" name="lbPaynumArr" min="1" precision="0" class="lebi_num" />' +
				' 价格<input type="text"  name="lbPriceArr" min="0.01" precision="2" class="easyui-numberbox read_inp" /></td>' +
//				' 赠送<input type="text" name="lbGivenumArr" min="0" precision="0" class="easyui-numberbox" data-options="required:false" />' +
				'<td>赠送<input type="text" name="lbGivenumArr" min="0" precision="0" class="easyui-numberbox" data-options="required:false" />' +
				' apple-proID<input type="text" name="expandidArr" style="width: 100px" class="easyui-validatebox"/></td>'+
				'<td><input type="text" class="inp_w" name="thumbnailsUrlArr" value="${config.mobile.pic}" id="configMobilePic'+ obj.length + '" placeholder="请选择缩略图" class="span2"/> ' +
				'<input class="props_upload_btn" type="button" value="上传" id="thumbnailsUrlArr'+ obj.length +'" onclick="uploadFile('+ obj.length + ')" /></td>' +
				'<td>&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: graytext;"></span>&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: graytext;"></span></td>' +
				'</tr>';
		$("#tb1").append(appendhtml);
		if(readFlag){
			$("#tb1").find('.read_inp:last').prop('readonly',true)
		};
		uploadFile(obj.length)
		return;
	}
	function linkFn(ele){
		$(ele).next('.read_inp').val($(ele).val()/10);
	}
	$.extend($.fn.validatebox.defaults.rules, {
    linkage: {
        validator: function(value, param){
        	//console.log($(param[0]).next('span').find('input[type="text"]'));
        	var reg= /^\d*[1-9]+\d*(\.\d+)?$/;
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
	function editline(packagedetailId) {
		var flag = confirm("确认修改吗？");
		if (!flag) {
			return;
		}
		var lbPaynum = $("#lbPaynum"+packagedetailId).val();
		var lbPrice = $("#lbPrice"+packagedetailId).val();
		var lbGivenum = $("#lbGivenum"+packagedetailId).val();
		var expandId = $("#expandId"+packagedetailId).val();
		var configMobilePic = $("#configMobilePic"+packagedetailId).val();
		var packageId = $("#packageId").val();
		//alert(lbpaynum+","+lbPrice+","+lbGivenum+","+expandid);
		var url = "${pageContext.request.contextPath}/lebi/paypackage/editPaypackageone";
		$.post(url,{packagedetailId:packagedetailId,lbPaynum:lbPaynum,lbPrice:lbPrice,lbGivenum:lbGivenum,expandId:expandId,packageId:packageId,thumbnailsUrl:configMobilePic},function(data){
			var datajson = eval("("+data+")");
			if(datajson.code==0) {
            	parent.$.messager.alert('${internationalConfig.成功}', '修改成功！', 'success');
			} else {
				parent.$.messager.alert('${internationalConfig.错误}', '修改失败！', 'error');
			}
		});
	}
	function deleteline(packagedetailId) {
		var flag = confirm("确认删除吗？");
		if (!flag) {
			return;
		}
		var url = "${pageContext.request.contextPath}/lebi/paypackage/deleteone";
		var packageId = $("#packageId").val();
		$.post(url,{packagedetailId:packagedetailId,packageId:packageId},function(data){
			var datajson = eval("("+data+")");
			if(datajson.code==0) {
				$("#tr"+packagedetailId).remove();
            	parent.$.messager.alert('${internationalConfig.成功}', '删除成功！', 'success');
			} else {
				parent.$.messager.alert('${internationalConfig.错误}', '删除失败！', 'error');
			}
		});		
	}

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
		var obj = $("input[id^='configMobilePic']");
		obj.each(function(i){
			var str = $(this).attr("id");
			uploadFile(str.split('configMobilePic')[1]);
		});
	});
</script>
<style>
	input, textarea, .uneditable-input{
		width: 94px;
	}
	.table-form td{
		white-space: nowrap;
	}
</style>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post" >
			<table style="width: 100%" class="table table-form" id="tb1">
 
				<tr>
					<th>乐币包名称：</th>
					<td>
						<input type="text" name="packageName" class="easyui-validatebox" data-options="required:true" value="${vrPaypackage.packageName }"/>
						<input type="hidden" name="packageId" id="packageId" class="easyui-validatebox" data-options="required:true" value="${vrPaypackage.packageId }"/>
						<input type="hidden" name="packageStatus" class="easyui-validatebox" data-options="required:true" value="${vrPaypackage.packageStatus }"/>
					</td>
					<td></td>
					<td></td>
				</tr>
				<!-- 新增APP_PRODUCT_ID参数 -->
				<tr>
					<th>业务线：</th>
					<td>
						<select name="busiId" style="width: 165px" onfocus="this.defaultIndex=this.selectedIndex;" onchange="this.selectedIndex=this.defaultIndex;">
							<c:forEach items="${businesslist}" var="business">
	                            <option value="${business.bussid}" <c:if test="${vrPaypackage.busiId eq business.bussid}">selected</c:if>>${business.bussname}</option>
	                        </c:forEach>
						</select>
					</td>
					<td></td>
					<td></td>
				</tr>	
				
				<tr>
					<th>终端：</th>
					<td>
						<select id="terminal_pack" name="packageTerminal" class="span2" onfocus="this.defaultIndex=this.selectedIndex;" onchange="this.selectedIndex=this.defaultIndex;">
						<c:forEach items="${terminals }" var="terminal">
		               		<option value="${terminal.key}" <c:if test="${vrPaypackage.packageTerminal eq terminal.key}">selected</c:if>>${terminal.value}</option>
		                </c:forEach>
		              	</select>
					</td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<th>有效期：</th>
					<td colspan="3">
						<input type="text" name="packageStartdate" value="<fmt:formatDate pattern="yyyy-MM-dd hh:mm:ss" value="${vrPaypackage.packageStartdate }"/>" style="width: 180px" class="easyui-datetimebox" class="easyui-validatebox" data-options="required:true" />
						<input type="text" name="packageEnddate" value="<fmt:formatDate pattern="yyyy-MM-dd hh:mm:ss" value="${vrPaypackage.packageEnddate }"/>" style="width: 180px" class="easyui-datetimebox" class="easyui-validatebox" data-options="required:true" />
					</td>
				</tr>
				<tr>
					<th>活动文案：</th>
					<td colspan="3">
						<input type="text" name="hdDoc" value="${vrPaypackage.hdDoc }" style="width: 180px" class="easyui-validatebox" />
					</td>
				</tr>				
  				<c:forEach items="${vrPackagelist }" var="vr"  varStatus="status">
					<tr id="tr${vr.packagedetailId}">
						<td>
							乐币数量<input type="text" id="lbPaynum${vr.packagedetailId }" value="${vr.lbPaynum }" onkeyup="linkFn(this)" class="lebi_num" min="1"  precision="0"  <c:choose ><c:when test="${status.index==0 }">data-options="required:true"</c:when><c:otherwise>data-options="required:false"</c:otherwise></c:choose> />
							价格<input type="text" id="lbPrice${vr.packagedetailId }" value="${vr.lbPrice }"  min="0.01" precision="2" class="read_inp" readonly="true"  <c:choose ><c:when test="${status.index==0 }"></c:when><c:otherwise></c:otherwise></c:choose> />
						</td>
						<%--赠送<input type="text" id="lbGivenum${vr.packagedetailId }" value="${vr.lbGivenum }" min="0" precision="0" />--%>
						<td>
							赠送<input type="text" id="lbGivenum${vr.packagedetailId }" value="${vr.lbGivenum }" min="0" precision="0" />
							apple-proID<input type="text" id="expandId${vr.packagedetailId }" value="${vr.expandId }" style="width: 100px" class="easyui-validatebox"/>
						</td>
					<td>
						<input type="text" class="inp_w" value="${vr.thumbnailsUrl}" id="configMobilePic${vr.packagedetailId }" placeholder="请选择缩略图" class="span2"/>
						<input class="props_upload_btn" type="button" value="上传" id="thumbnailsUrlArr${vr.packagedetailId }" onclick="uploadFile(${vr.packagedetailId })" />
					</td>
					<td>
						&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:editline(${vr.packagedetailId })">修改</a>
						<c:choose >
							<c:when test="${status.index==0 }">&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: graytext;">删除</span></c:when>
							<c:otherwise>&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:deleteline(${vr.packagedetailId })">删除</a></c:otherwise>
						</c:choose>
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
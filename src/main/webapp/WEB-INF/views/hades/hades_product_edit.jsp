<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script src="/static/lib/swfupload/swfupload.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
    var swfupload = swfupload||null ;
	$(function() {
		parent.$.messager.progress('close');
		$('#form').form({
			url : '${pageContext.request.contextPath}/hades/product/hades_product_add.json',
			onSubmit : function() {
				//去除两个默认checkbox的disabled属性，让后台能够得到这两个值
				parent.$.messager.progress({
					title : '提示',
					text : '数据处理中，请稍后....'
				});
				var isValid = $(this).form('validate');
				if (!isValid) {
					parent.$.messager.progress('close');
				}
				return isValid;
			},
			success : function(result) {
				parent.$.messager.progress('close');
				result = $.parseJSON(result);
				if (result.code == 0) {
                	parent.$.messager.alert('成功', '编辑成功', 'success');
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');
					parent.$.modalDialog.handler.dialog('close');
				} else {
					parent.$.messager.alert('错误', result.msg, 'error');
				}
			}
		});
        swfupload = new SWFUpload({
            button_placeholder_id: "js_upload_btn",
            flash_url: "${pageContext.request.contextPath}/static/lib/swfupload/swfupload.swf?rt="+Math.random(),
            upload_url: '${pageContext.request.contextPath}/upload?cdn=sync',
            button_image_url: Boss.util.defaults.upload.button_image,
            button_cursor: SWFUpload.CURSOR.HAND,
            button_action: SWFUpload.BUTTON_ACTION.SELECT_FILE,
            file_size_limit: '8 MB',
            button_width: "61",
            file_post_name:"myfile",
            button_height: "24",
            file_types: "*.jpg;*.jpeg;*.png;*.bmp;*.gif",
            file_types_description: "All Image Files",
            button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
            upload_start_handler: function() {
            },
            upload_success_handler: function(file, response) {
                var HTML_VIEWS = '<a href='+response+' target="_blank">'+Boss.util.defaults.upload.viewText+'</a>&nbsp;&nbsp;&nbsp;&nbsp;';
                $("#img-views").html(HTML_VIEWS);
                $("#prdImg").val(response);
            },
            file_queued_handler: function() {
                this.startUpload();
            },
            upload_error_handler: function(file, code, msg) {
                var message = Boss.util.defaults.upload.err + code + ': ' + msg + ', ' + file.name;
                alert(message);
            }
        });
	});
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post"
			action="#">
			<input type="hidden" name="id" value="${p.id}" />
			<input type="hidden" name="appId" value="${appId }" />
			<input type="hidden" name="ppId" value="${p.ppId}" />
			<table class="table table-form">
				<colgroup>
					<col width="100">
					<col width="300">
					<col width="80">
					<col width="*">
				</colgroup>
				<tr>
					<td style="text-align:right;">商品名称：</td>
					<td><input type="text" name="marketName" value="${p.marketName}" class="easyui-validatebox" required="true"/></td>
					<td style="text-align:right;">商品状态：</td>
					<td>
						<select name="status">
							<option value="ONLINE" <c:if test="${p.status eq 'ONLINE' }">selected</c:if>>上线</option>
							<option value="OFFLINE" <c:if test="${p.status eq 'OFFLINE' }">selected</c:if>>下线</option>
						</select>
					</td>
				</tr>
				<tr>
					<td style="text-align:right;">商品显示价格：</td>
					<td><input type="text" name="displayPrice" value="${p.displayPrice}" class="easyui-numberbox" data-options="min:0,precision:2,required:true"/></td>
					<td style="text-align:right;">商品分类：</td>
					<td><input type="text" name="productCategory" value="${p.productCategory}"/></td>
				</tr>
				<tr>
					<td style="text-align: right;">起始时间：</td>
					
					<td>
						<input type="text" name="startActiveTime" id="startActiveTime"
									value="<fmt:formatDate pattern="yyyy-MM-dd hh:mm:ss" value="${p.startActiveTime}"/>"
									class="easyui-datetimebox" data-options="required:true" />
					</td>
					<td style="text-align:right;">截至时间：</td>
					<td>
						<input type="text" name="endActiveTime" id="endActiveTime"
								value="<fmt:formatDate pattern="yyyy-MM-dd hh:mm:ss" value="${p.endActiveTime}"/>"
								class="easyui-datetimebox" data-options="required:true" />
					</td>
				</tr>
				<tr>
					<td style="text-align:right;">商品图片：</td>
					<td ><input type="text" id="prdImg" name="prdImg" value="${p.prdImg}" style="width:300px;"/></td>
					<td>
						<input class="buttoncenter" type="button" value="上传文件" id="js_upload_btn" />
					</td>
		            <td><div id="img-views" name="img-views" /></td>
				</tr>
				<tr>
					<td style="text-align:right;width:40px">下载地址：</td>
					<td colspan="3"><input type="text" name="downloadUrl" value="${p.downloadUrl}" style="width:300px" /></td>
				</tr>
				<tr>
					<td style="text-align:right;">商品备注：</td>
					<td colspan="3">
						<textarea  name="description" class="txt-large">${p.description }</textarea>
					</td>
				</tr>
				<!-- price -->
				<tr>
					<td style="text-align:right;">默认价格：</td>
					<td><input type="text" name="ppPrice" value="${p.ppPrice}" class="easyui-numberbox" data-options="min:0,precision:2,required:true"/></td>
					<td style="text-align:right;">币种：</td>
					<td>
						<select name="ppCurrency">
							<option value="CNY" <c:if test="${p.ppCurrency eq 'CNY' }">selected</c:if> >人民币</option>
							<option value="USD" <c:if test="${p.ppCurrency eq 'USD' }">selected</c:if> >美元</option>
						</select>
					</td>
				</tr>
				<!-- price -->
				<tr>
					<td style="text-align:right;">商品处理方式：</td>
					<td>
						<select name="fulfillmentType">
							<option value="D" <c:if test="${p.fulfillmentType eq 'D' }">selected</c:if> >无需配送</option>
							<option value="E" <c:if test="${p.fulfillmentType eq 'E' }">selected</c:if> >第三方配送</option>
						</select>
					</td>
					<td style="text-align:left;">分成比例：</td>
					<td><input type="text" required="true" name="dividedProportion" class="easyui-numberbox" precision="2" value="<c:if test="${p.dividedProportion == null}">0.1</c:if><c:if test="${p.dividedProportion != null}">${p.dividedProportion}</c:if>" /></td>
				</tr>
				<tr>
					<td style="text-align:right;">默认价格备注：</td>
					<td colspan="3">
						<textarea  name="ppDescription" class="txt-large">${p.ppDescription }</textarea>
					</td>
				</tr>
				
			</table>
		</form>
	</div>
</div>
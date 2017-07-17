<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script src="/static/lib/swfupload/swfupload.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" src="/static/lib/uploadImg.js?v=20150408.01" charset="utf-8"></script>
<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form').form({
			url : '${pageContext.request.contextPath}/play_package/add.json',
			onSubmit : function() {
				//提交前,去除两个默认checkbox的disabled属性，让后台能够得到这两个值
				$("#feature30").attr("disabled", false)
				$("#feature31").attr("disabled", false)
				parent.$.messager.progress({
					title : '${internationalConfig.提示}',
					text : '${internationalConfig.数据处理中}....'
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
					parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.添加成功}', 'success');
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
					parent.$.modalDialog.handler.dialog('close');
				} else {
					var msg = result.msg ? result.msg : '';
					parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.操作失败}<br>'+msg, 'error');
				}
			}
		});
	});

	//增加自定义的表单验证规则
	$.extend($.fn.validatebox.defaults.rules, {
		number : {
			validator : function(value, param) {
				var reg = new RegExp("^[0-9]+(.[0-9]+)?$");
				return reg.test(value);
			},
			message : '${internationalConfig.请输入合法数字}'
		}
	});
	$.extend($.fn.validatebox.defaults.rules, {
		int : {
			validator : function(value, param) {
				var reg = new RegExp("^[0-9]+$");
				return reg.test(value);
			},
			message : '${internationalConfig.请输入合法整数}'
		}
	});
	
	//终端设备联动
    $(function(){
    	$("#matchid").change(function(){
    		var matchid = $("#matchid").val();
    		$
    				.ajax({
    					url : "${pageContext.request.contextPath}/play_package/get_match_info.json",
    					data : {
    						'pid' : matchid
    					},
    					success : function(result) {
    						var directIndex = null;
    						var optionsHtml = "";
    						$("#itemid").empty();
    						for (directIndex in result) {
    							var directModel = result[directIndex];
    							var optionHtml = '<option value="'+directModel.id+'">'
    									+ directModel.description + '</option>';
    							optionsHtml += optionHtml;
    						}
    						var optionhtml = '<option value="-1" selected="selected">${internationalConfig.全部}</option>';
                            optionsHtml += optionhtml;
    						$("#itemid").html(optionsHtml);
    						var optionhtml1 = '<option value="-1" selected="selected">${internationalConfig.全部}</option>';
    						$("#sessionid").html(optionhtml1);
    					},
    					dataType : "json",
    					cache : false
    				});
    			
    		});
          }
    	);
	
  //终端设备联动
    $(function(){
    	$("#itemid").change(function(){
    		var matchid = $("#itemid").val();
    		$
    				.ajax({
    					url : "${pageContext.request.contextPath}/play_package/get_match_info.json",
    					data : {
    						'pid' : matchid
    					},
    					success : function(result) {
    						var directIndex = null;
    						var optionsHtml = "";
    						$("#sessionid").empty();
    						for (directIndex in result) {
    							var directModel = result[directIndex];
    							var optionHtml = '<option value="'+directModel.id+'">'
    									+ directModel.description + '</option>';
    							optionsHtml += optionHtml;
    						}
    						var optionhtml = '<option value="-1" selected="selected">${internationalConfig.全部} </option>';
                            optionsHtml += optionhtml;
    						$("#sessionid").html(optionsHtml);
    					},
    					dataType : "json",
    					cache : false
    				});
    			
    		});
          }
    	);
  
  //套餐改变，不同套餐显示不同条目
    $(function(){
    	$("#type").change(function(){
    		var typeid = $("#type").val();
    		if(typeid == 1){//直播券
    			var optionhtml = '<option value="1">1${internationalConfig.张}</option><option value="10">10${internationalConfig.张}</option><option value="30">30${internationalConfig.张}</option>';
    			$("#counts").html(optionhtml);
    		}
    		
    		if(typeid == 2 || typeid == 3 || typeid == 4){//球队报or赛季包
    			var optionhtml = '<option value="0">0${internationalConfig.张}</option>';
    			$("#counts").html(optionhtml);
    		}
    		
    		if(typeid == 0){//球队报or赛季包
    			var optionhtml = '<option value="0">0${internationalConfig.张}</option><option value="1">1${internationalConfig.张}</option><option value="10">10${internationalConfig.张}</option><option value="30">30${internationalConfig.张}</option>';
    			$("#counts").html(optionhtml);
    		}
    			
    		});
          }
    	);
  
 // 场次轮次事件
    $(function(){
    	$("#matchid,#itemid,#type").change(function(){
    		var matchid = $("#matchid").val();
    		var itemid = $("#itemid").val();
    		var type = $("#type").val();
    		var roundNumber = $("#round_number");
    		if(matchid == '09' && itemid == '001' && type == '1'){
    			$('#rounds').attr("disabled",false);
    			$('#play_number').attr("disabled",false);
    			roundNumber.show();
    		}else{
    			$('#rounds').attr("disabled",true);
    			$('#play_number').attr("disabled",true);
    			roundNumber.hide();
    		}
    		});
          }
    	);
</script>
<style type="text/css">
#form table tr th{
	vertical-align:middle;
	width:90px;
}
#form table tr td select{
	width:180px;
}
</style>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post"
			action="${pageContext.request.contextPath}/play_package/create.json">
			<table style="width: 100%" class="table table-form">
				<!--<colgroup>
					<col width="70">
					<col width="220">
					<col width="95">
					<col width="*">
				</colgroup>-->
			    <tr>
					<th>${internationalConfig.频道}</th>
					<td><select name="matchid" id="matchid" style="margin-top: 5px">
						<option value="-1">${internationalConfig.全部}</option>
						        <c:forEach items="${directList}" var="var">
								    <option value="${var.id}">${var.description}</option>
								</c:forEach>
						</select></td>
					<th>${internationalConfig.赛事}</th>
					<td><select name="itemid" id="itemid" style="margin-top: 5px">
								<option value="-1">${internationalConfig.全部}</option>
						</select></td>
				</tr>
				<tr>
				   <th>${internationalConfig.赛季}</th>
					<td><select name="sessionid" id="sessionid" style="margin-top: 5px">
								<option value="-1"> ${internationalConfig.全部}</option>
						</select></td>
					<th>${internationalConfig.套餐名称}</th>
					<td>
					<select name="type" id="type">
					    <option value="0">${internationalConfig.全部}</option>
						<option value="1">${internationalConfig.直播券}</option>
						<option value="2">${internationalConfig.轮次包}</option>
						<option value="3">${internationalConfig.全季特惠包}</option>
						<option value="4">${internationalConfig.死忠季票包}</option>
					</select>
					</td>
				</tr>
				<tr>
					<th>${internationalConfig.套餐状态}</th>
					<td>
					  <select name="status">
								<option value="0">${internationalConfig.上线}</option>
								<option value="1">${internationalConfig.下线}</option>
					  </select>
					</td>
					<th>${internationalConfig.直播券张数}</th>

					<td>
					<select name="counts" id="counts">
					            <option value="0">0${internationalConfig.张}</option>
					</select>
					</td>
				</tr>
				<tr id="round_number" style="display: none">
				   <th>${internationalConfig.轮次}</th>
				   <td>
					 <select name="rounds" id="rounds" style="margin-top: 5px">
						<option value="001"> ${internationalConfig.第1轮}</option>
						<option value="002"> ${internationalConfig.第2轮}</option>
						<option value="003"> ${internationalConfig.第3轮}</option>
						<option value="004"> ${internationalConfig.第4轮}</option>
						<option value="005"> ${internationalConfig.第5轮}</option>
						<option value="006"> ${internationalConfig.第6轮}</option>
						<option value="007"> ${internationalConfig.第7轮}</option>
						<option value="008"> ${internationalConfig.第8轮}</option>
						<option value="009"> ${internationalConfig.第9轮}</option>
						<option value="010"> ${internationalConfig.第10轮}</option>
						<option value="011"> ${internationalConfig.第11轮}</option>
						<option value="012"> ${internationalConfig.第12轮}</option>
					 </select>
					</td>
					<th>${internationalConfig.场次}</th>
					<td>
					<select name="play_number" id="play_number">
						<option value="0001"> ${internationalConfig.第1场}</option>
						<option value="0002"> ${internationalConfig.第2场}</option>
						<option value="0003"> ${internationalConfig.第3场}</option>
						<option value="0004"> ${internationalConfig.第4场}</option>
						<option value="0005"> ${internationalConfig.第5场}</option>
						<option value="0006"> ${internationalConfig.第6场}</option>
						<option value="0007"> ${internationalConfig.第7场}</option>
						<option value="0008"> ${internationalConfig.第8场}</option>
						<option value="0009"> ${internationalConfig.第9场}</option>
						<option value="0010"> ${internationalConfig.第10场}</option>
						<option value="0011"> ${internationalConfig.第11场}</option>
						<option value="0012"> ${internationalConfig.第12场}</option>
						<option value="0013"> ${internationalConfig.第13场}</option>
						<option value="0014"> ${internationalConfig.第14场}</option>
						<option value="0015"> ${internationalConfig.第15场}</option>
						<option value="0016"> ${internationalConfig.第16场}</option>
						<option value="0017"> ${internationalConfig.第17场}</option>
						<option value="0018"> ${internationalConfig.第18场}</option>
						<option value="0019"> ${internationalConfig.第19场}</option>
						<option value="0020"> ${internationalConfig.第20场}</option>
						<option value="0021"> ${internationalConfig.第21场}</option>
						<option value="0022"> ${internationalConfig.第22场}</option>
						<option value="0023"> ${internationalConfig.第23场}</option>
						<option value="0024"> ${internationalConfig.第24场}</option>
						<option value="0025"> ${internationalConfig.第25场}</option>
						<option value="0026"> ${internationalConfig.第26场}</option>
						<option value="0027"> ${internationalConfig.第27场}</option>
						<option value="0028"> ${internationalConfig.第28场}</option>
						<option value="0029"> ${internationalConfig.第29场}</option>
						<option value="0030"> ${internationalConfig.第30场}</option>
					 </select>
					</td>
				</tr>
			
				<tr>
					<th>${internationalConfig.付费类型}</th>
					<td colspan="3">
						<%--<input name="payType" type="radio" value="1" />${internationalConfig.包年及以上免费}
                        <input name="payType" type="radio" value="2" />${internationalConfig.包年及以上免费且可单点}--%>
                        <%--<input name="payType" type="radio" value="3" />${internationalConfig.会员免费}
                        <input name="payType" type="radio" value="4" />${internationalConfig.会员免费且可单点}--%>
                        <input name="payType" type="radio" value="5" checked="checked" />${internationalConfig.单点}
                        <%--<input name="payType" type="radio" value="6" />${internationalConfig.全屏包年及以上免费且可单点}--%>
                    </td>
				</tr>
				
					<tr>
					<th>${internationalConfig.原价}：</th>
					<td colspan="3"><input type="text" name="origin_price" class="easyui-validatebox" 	data-options="required:true,validType:'number'" value="" /></td>
				</tr>
				
				<tr>
					
					<th>vip${internationalConfig.价格}</th>
					<td><input type="text" name="vip_price" class="easyui-validatebox"
						data-options="required:true,validType:'number'" /></td>
						<th>${internationalConfig.非会员价格}</th>
					<td><input type="text" name="regular_price"
						class="easyui-validatebox"
						data-options="required:true,validType:'number'" /></td>
				</tr>
				
				<tr id="app_id">
				   <th>APP_PRODUCT_ID</th>
				   <td><input type="text" name="app_product_id" class="easyui-validatebox"
						data-options="required:false" /></td>
					<th>APP_${internationalConfig.价格}</th>
					 <td><input type="text" name="app_price" class="easyui-validatebox"
						data-options="validType:'number'" />
					 </td>
				</tr>
				
				<tr id="ipad_id">
				   <th>IPAD_PRODUCT_ID</th>
				   <td><input type="text" name="ipadProductId" class="easyui-validatebox"
						data-options="required:false" /></td>
					<th>IPAD_${internationalConfig.价格}</th>
					 <td><input type="text" name="ipadPrice" class="easyui-validatebox"
						data-options="validType:'number'" />
					 </td>
				</tr>

				<tr>
					<th>${internationalConfig.直播卷有效时长}</th>
					<td><input type="text" name="validate_days" class="easyui-validatebox"
						data-options="required:true,validType:'int'" value="365" /></td>
						<th>${internationalConfig.赛季结束时间}</th>
					<td><label> <input type="text" name="session_end_time"
							id="expireDate"  class="easyui-datebox"
							class="easyui-validatebox" data-options="required:true,width:165,height:30" />
					</label></td>
				</tr>
				<tr>
					<th>${internationalConfig.分成比例}：</th>
					<td>
					<input type="text" required="true" name="dividedProportion" 
					class="easyui-numberbox" precision="2" value="0.1" />
					</td>
					<th>${internationalConfig.直播名称}：</th>
					<td><input type="text" name="playName"
						class="easyui-validatebox" data-options="required:true"/></td>
				</tr>
				<tr>
					<th>${internationalConfig.移动端图片}：</th>
					<td ><input type="text" id="mobileImg" name="mobileImg" value="${eplPackage.mobileImg}"/></td>
					<td>
						<input class="buttoncenter" type="button" value="${internationalConfig.上传文件}" id="mobile_upload_btn" />
					</td>
		            <td><div id="img-mobile" name="img-mobile" /></td>
				</tr>
				<tr>
					<th>${internationalConfig.超级移动端图片}：</th>
					<td ><input type="text" id="superMobileImg" name="superMobileImg" value="${eplPackage.superMobileImg}"/></td>
					<td>
						<input class="buttoncenter" type="button" value="${internationalConfig.上传文件}" id="super_mobile_upload_btn" />
					</td>
		            <td><div id="img-super-mobile" name="img-super-mobile" /></td>
				</tr>
				<tr>
					<th>${internationalConfig.套餐描述}：</th>
					<td colspan="3"><textarea name="playDesc" class="txt-middle"></textarea></td>
				</tr>
			</table>
		</form>
	</div>
</div>
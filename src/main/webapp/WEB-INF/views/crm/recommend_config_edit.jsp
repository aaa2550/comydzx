<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script type="text/javascript">
    $(function () {
    	var maxSmsLength = 140;
    	$("#sms_content").bind("keyup",function(){
    		var smsLength=$("#sms_content").val().length;
    		if(smsLength==undefined){
    			smsLength=0;
    		}
    		if(smsLength>maxSmsLength){
    			$(this).val($("#sms_content").val().substr(0,maxSmsLength));
	    		$("#sms_a").text("${internationalConfig.已输入}："+maxSmsLength+"/"+maxSmsLength+" ${internationalConfig.字符}");
    		}else{
    			$("#sms_a").text("${internationalConfig.已输入}："+smsLength+"/"+maxSmsLength+" ${internationalConfig.字符}");
    		}
    		
    	});
    	var maxPushLength = 35;
    	$("#push_content").bind("keyup",function(){
    		var pushLength=$(this).val().length;
    		if(pushLength==undefined){
    			pushLength=0;
    		}
    		if(pushLength>maxPushLength){
    			$(this).val($(this).val().substr(0,maxPushLength));
	    		$("#push_a").text("${internationalConfig.已输入}："+maxPushLength+"/"+maxPushLength+" ${internationalConfig.字符}");
    		}else{
    			$("#push_a").text("${internationalConfig.已输入}："+pushLength+"/"+maxPushLength+" ${internationalConfig.字符}");
    		}
    		
    	});
    	
    	
        parent.$.messager.progress('close');
        $('#form').form({
        	
        	
            url: '/recommend_config/createOrUpdate.json',
            onSubmit: function () {
                parent.$.messager.progress({
                    title: '${internationalConfig.提示}',
                    text: '${internationalConfig.数据处理中}'
                });
                var isValid = $(this).form('validate');
                if (!isValid) {
                    parent.$.messager.progress('close');
                }
                return isValid;
            },
            success: function (obj) {
                parent.$.messager.progress('close');
                var result = $.parseJSON(obj);
                if (result.code==0) {
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
                    parent.$.modalDialog.handler.dialog('close');
                    var batch = result.msg;
                } else {
                    parent.$.messager.alert('${internationalConfig.页面错误}', result.msg, 'error');
                }
            }
        });
        $("#sendSmsButton").bind("click",function(){
        	var id = $("#id").val();
        	sendSms(id);
        });
        $("#pushButton").bind("click",function(){
        	var id = $("#id").val();
        	push(id);
        });
        
        $("#pushType").bind("change",function(){
        	var pushType = $(this).val();
        	if(pushType==3){
        		$("#push_resid").html("${internationalConfig.影片}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>VID");
        		$("#resid_desc").html("");
        	}
        	if(pushType==6){
        		$("#push_resid").html("H5<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.推送}");
        		$("#resid_desc").html("&nbsp;&nbsp;*${internationalConfig.去除H5链接_长文本}");
        	}
        });
        
        $("#popType").bind("change",function(){
        	var pushType = $(this).val();
        	if(pushType==1){
        		$("#upload_file").hide();
        		$(".config").show();
        	}else{
        		$("#upload_file").show();
        		$(".config").hide();
        	}
        });
    });
    
    function sendSms(id) {
    	var smsContent = $("#sms_content").val();
		if(!smsContent){
			parent.$.messager.confirm('${internationalConfig.警告}', "${internationalConfig.短信文案不能为空}！", function (b) {
		    });
			return ;
		}
    	
    	$.get("${pageContext.request.contextPath}/recommend_config/sendSmsBefore.json",{configId:id},function(data){
    		if(data.code==0){
    		    if (id == undefined) {
    		    	return;
    		    }
    			var info=data.msg;
    		    parent.$.messager.confirm('${internationalConfig.询问}', info, function (b) {
    		        if (b) {
    		            parent.$.messager.progress({
    		                title: '${internationalConfig.提示}',
    		                text: '${internationalConfig.数据处理中}'
    		            });
    		            $.post('${pageContext.request.contextPath}/recommend_config/sendSms.json', {
    		            	configId: id,
    		            	smsContent:smsContent
    		            }, function (obj) {
    		                if (obj.code == 0) {
    		                	parent.$.messager.confirm('${internationalConfig.警告}', "${internationalConfig.正在发送}！", function (b) {
    		        		    });
    		                }else{
    		                	parent.$.messager.confirm('${internationalConfig.警告}', obj.msg, function (b) {
    		        		    });
    		                }
    		                parent.$.messager.progress('close');
    		            }, 'JSON');
    		        }
    		    });
    		}else{
    			var info=data.msg;
    			parent.$.messager.confirm('${internationalConfig.警告}', info, function (b) {
    		    });
    		}
    		
    	  },"json");
    	
    	
    }
    
	function push(id) {
		var pushContent = $("#push_content").val();
		var pushResid = $("#pushResid").val();
		var pushType = $("#pushType").val();
		var pushImg = $("#pushImg").val();
		if(!pushContent){
			parent.$.messager.confirm('${internationalConfig.警告}', "push ${internationalConfig.文案不能为空}！", function (b) {
		    });
			return ;
		}
		if(!pushResid){
			parent.$.messager.confirm('${internationalConfig.警告}', "push resid ${internationalConfig.不能为空}！", function (b) {
		    });
			return ;
		}
		if(!pushImg){
			parent.$.messager.confirm('${internationalConfig.警告}', "push img ${internationalConfig.不能为空}！", function (b) {
		    });
			return ;
		}
    	
    	$.get("${pageContext.request.contextPath}/recommend_config/pushBefore.json",{configId:id},function(data){
    		if(data.code==0){
    		    if (id == undefined) {
    		    	return;
    		    }
    			var info=data.msg;
    			if(data.code==0){
    				info = pushContent;
    			}
    			
    		    parent.$.messager.confirm('${internationalConfig.询问}', info, function (b) {
    		        if (b) {
    		            parent.$.messager.progress({
    		                title: '${internationalConfig.提示}',
    		                text: '${internationalConfig.数据处理中}'
    		            });
    		            $.post('${pageContext.request.contextPath}/recommend_config/pushMessage.json', {
    		            	configId: id,
    		            	pushContent: pushContent,
    		            	pushResid:pushResid,
    		            	pushType:pushType,
    		            	pushImg:pushImg
    		            }, function (obj) {
    		                if (obj.code == 0) {
    		                	parent.$.messager.confirm('${internationalConfig.警告}', "${internationalConfig.正在发送}，"+ "${internationalConfig.减小服务器压力_长文本}!", function (b) {
    		        		    });
    		                }else{
    		                	parent.$.messager.confirm('${internationalConfig.警告}', obj.msg, function (b) {
    		        		    });
    		                }
    		                parent.$.messager.progress('close');
    		            }, 'JSON');
    		        }
    		    });
    		}else{
    			var info=data.msg;
    			parent.$.messager.confirm('${internationalConfig.警告}', info, function (b) {
    		    });
    		}
    		
    	  },"json");
    	
    	
    }

</script>
<style>
<!--
.right_p{
	display: inline-block;
	line-height: 30px;
	vertical-align: middle;
	padding-left: 20px;
}
.right_p02{
	margin-top:20px;
}
.right_p span{display: block;height:30px;line-height: 30px;}
.right_p input{display: block;width: 80px;height: 30px;line-height: 30px;font-size: 14px;}
.push_div{
display: inline-block;
padding: 10px 0 10px;overflow: hidden;
float: left;
}
.push_div p{
margin-bottom:10px;
}
.push_div p textarea {
	width:334px;
}
-->
</style>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title=""
		style="overflow: auto;">
		<form id="form" method="post"
			action="/recommend_config/create.json" class="easyui-form" enctype="multipart/form-data">
			<table style="margin-left: 30px; margin-top: 20px" class = "recommend-dialog-add">
				<tr class="pannel-tr pannel-with-out">
					<c:if test="${not empty recommendConfig}">
					
						<td  class="pannel-td">
							<span class="content-sp" >${internationalConfig.项目名称}</span>
						 	<input type="text" title="" name="title" style="width: 150px" class="easyui-validatebox" value="${recommendConfig.title }" data-options="required:true">
						</td>
						<td  class="pannel-td">
							<span class="content-sp">${internationalConfig.项目}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID</span>
							<input type="text" name="id" id="id" style="width: 150px" value="${recommendConfig.id }" class="easyui-validatebox">
						</td>
					</c:if>
					<c:if test="${empty recommendConfig}">
					
						<td  class="pannel-td" colspan="2">
							<span class="content-sp" >${internationalConfig.项目名称}</span>
						 	<input type="text" title="" name="title" style="width: 150px" class="easyui-validatebox" value="${recommendConfig.title }" data-options="required:true">
						</td>
					</c:if>
					
				</tr>
				<tr class="pannel-tr">
					<td  class="pannel-td">
						<span class="content-sp" >${internationalConfig.频道}</span>
						<select name="channel" id="channel" style="width: 150px">
							<option value="0" <c:if test="${recommendConfig.channel eq 0 }">selected</c:if>>${internationalConfig.全部}</option>
							<c:forEach items="${channelJson.data }" var="item"  varStatus="status">
								<option value="${item.id}" <c:if test="${recommendConfig.channel eq item.id }">selected</c:if>>${item.value}</option>
					    	</c:forEach>
						</select>
<!-- 						<td  class="pannel-td"> -->
<!-- 							<span class="content-sp" >频道</span> -->
<!-- 							<select name="channel" id="channel" style="width: 150px"> -->
<%-- 								<option value="1" <c:if test="${recommendConfig.channel eq 1 }">selected</c:if>>电影</option> --%>
<%-- 								<option value="2" <c:if test="${recommendConfig.channel eq 2 }">selected</c:if>>电视剧</option> --%>
<!-- 							</select> -->
<!-- 						</td> -->
						<td  class="pannel-td">
							<span class="content-sp">${internationalConfig.类型}</span>
							<select name="popType" id="popType" style="width: 150px">
								<option value="1" <c:if test="${recommendConfig.popType eq 1 }">selected</c:if>>${internationalConfig.新片推荐}</option>
								<option value="3" <c:if test="${recommendConfig.popType eq 3 }">selected</c:if>>${internationalConfig.活动推广}</option>
							</select>
						</td>
				</tr>
				<tr class="pannel-tr pannel-with-out" id="upload_file" <c:if test="${empty recommendConfig || recommendConfig.popType eq 1 }"> style="display:none" </c:if>>
					<td class="pannel-td" colspan="2" >
						<span class="content-sp">${internationalConfig.参加活动用户}</span>
					 	<input type="file" name="uidfile" value="${internationalConfig.导入}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>UID" style="width:150px">
					</td>
				</tr>
                <tr class="pannel-tr pannel-with-out" >
			  		<td class="pannel-td">
			  		 	<span class="content-sp">${internationalConfig.失效日期}</span>
                        <input type="text" class="easyui-datebox datebox-f combo-f textbox-f" data-options="required:true" style="width: 165px; display: none;" id="expireTime" name="expireTime" textboxname="expireTime" comboname="expireTime" value="${recommendConfig.expireTime }">
                    </td>
					<td style="padding-right:20px" class="pannel-td"> 
						<span class="content-sp">${internationalConfig.权重}</span>
						<input type="text" data-options="required:true" class="easyui-validatebox"  value="${recommendConfig.weight }" style="width: 150px" name="weight">
					</td>
				</tr>
				<tr class="pannel-tr pannel-with-out config" <c:if test="${not empty recommendConfig && recommendConfig.popType != 1 }"> style="display:none" </c:if>>
					<td class="pannel-td" >
						<span class="content-sp">${internationalConfig.正片名称}</span>
	            		<input type="text" name="pname" style="width: 150px" class="easyui-validatebox" value="${recommendConfig.pname }">
					</td>
 
					<td style="padding-right:20px" class="pannel-td"> 
						<span class="content-sp">PID</span>
						<input type="text" class="easyui-validatebox"  value="${recommendConfig.pid }" style="width: 150px" name="pid">
					</td>
				</tr>
				<tr class="pannel-tr config" <c:if test="${not empty recommendConfig && recommendConfig.popType != 1 }"> style="display:none" </c:if>>
					<td class="pannel-td" >
						<span class="content-sp">${internationalConfig.相关专辑}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>2</span>
	            		<input type="text" name="pname1" style="width: 150px" class="easyui-validatebox" value="${recommendConfig.pname1 }">
					</td>
 
					<td style="padding-right:20px" class="pannel-td"> 
						<span class="content-sp">PID</span>
						<input type="text" class="easyui-validatebox"  value="${recommendConfig.pid1 }" style="width: 150px" name="pid1">
					</td>
				</tr>
				<tr class="pannel-tr config" <c:if test="${not empty recommendConfig && recommendConfig.popType != 1 }"> style="display:none" </c:if>>
					<td class="pannel-td" >
						<span class="content-sp">${internationalConfig.相关专辑}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>3</span>
	            		<input type="text" name="pname2" style="width: 150px" class="easyui-validatebox" value="${recommendConfig.pname2 }">
					</td>
 
					<td style="padding-right:20px" class="pannel-td"> 
						<span class="content-sp">PID</span>
						<input type="text" class="easyui-validatebox"  value="${recommendConfig.pid2 }" style="width: 150px" name="pid2">
					</td>
				</tr>
				<tr class="pannel-tr config" <c:if test="${not empty recommendConfig && recommendConfig.popType != 1 }"> style="display:none" </c:if>>
					<td class="pannel-td" colspan="2">
						<span class="content-sp">${internationalConfig.专题链接}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>1</span>
						<input type="text" class="easyui-validatebox" style="width: 150px" name="specialUrl" value="${recommendConfig.specialUrl }">
					</td>
				</tr>
				 <tr class="pannel-tr config" <c:if test="${not empty recommendConfig && recommendConfig.popType != 1 }"> style="display:none" </c:if>>
 					<td colspan="2" class="pannel-td">
						<span class="content-sp">${internationalConfig.专题}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>1<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.日期}</span>
					    <input type="text" class="easyui-datebox datebox-f combo-f textbox-f" style="width: 165px; display: none;" id="specialBegin" name="specialBegin" textboxname="specialBegin" comboname="specialBegin" value="${recommendConfig.specialBegin }">
                          --<input type="text" class="easyui-datebox datebox-f combo-f textbox-f" style="width: 165px; display: none;" id="specialEnd" name="specialEnd" textboxname="specialEnd" comboname="specialEnd" value="${recommendConfig.specialEnd }">
					</td>
                </tr>
   				<tr class="pannel-tr config" <c:if test="${not empty recommendConfig && recommendConfig.popType != 1 }"> style="display:none" </c:if>>
					<td class="pannel-td" colspan="2">
						<span class="content-sp">${internationalConfig.专题链接}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>2</span>
						<input type="text" class="easyui-validatebox" style="width: 150px" name="specialUrl1" value="${recommendConfig.specialUrl1 }">
					</td>
				</tr>
				 <tr class="pannel-tr config" <c:if test="${not empty recommendConfig && recommendConfig.popType != 1 }"> style="display:none" </c:if>>
 					<td colspan="2" class="pannel-td">
						<span class="content-sp">${internationalConfig.专题}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>2<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.日期}</span>
					    <input type="text" class="easyui-datebox datebox-f combo-f textbox-f" style="width: 165px; display: none;" id="specialBegin1" name="specialBegin1" textboxname="specialBegin1" comboname="specialBegin1" value="${recommendConfig.specialBegin1 }">
                          --<input type="text" class="easyui-datebox datebox-f combo-f textbox-f" style="width: 165px; display: none;" id="specialEnd1" name="specialEnd1" textboxname="specialEnd1" comboname="specialEnd1" value="${recommendConfig.specialEnd1 }">
					</td>
                </tr>
				<tr class="pannel-tr pannel-with-out" >
					<td class="pannel-td">	
						<span class="content-sp" >${internationalConfig.更多描述}</span>
						<input type="text" class="easyui-validatebox" style="width: 150px" name="popInfoObj.more.desc" value="${popInfoObj.more.desc }">
					</td>
        			<td class="pannel-td">
	        			<span class="content-sp" >${internationalConfig.更多链接}</span>
	        			<input type="text" name="popInfoObj.more.link" style="width: 150px" class="easyui-validatebox" value="${popInfoObj.more.link }">
					</td>
				</tr>
   				<tr class="pannel-tr" >
        			<td class="pannel-td">
	        			<span class="content-sp" >${internationalConfig.弹窗片名}</span>
	        			<input type="text" name="popInfoObj.showInfo.title" style="width: 150px" class="easyui-validatebox" value="${popInfoObj.showInfo.title }">
					</td>
					<td  class="pannel-td">
						<span class="content-sp">${internationalConfig.小图片链接}</span>
						<input type="text" class="easyui-validatebox" style="width: 150px" name="popInfoObj.showInfo.smallPicAddress" value="${popInfoObj.showInfo.smallPicAddress }">
					</td>
				</tr>
				<tr class="pannel-tr" >
					<td  class="pannel-td">
						<span class="content-sp">${internationalConfig.大图片链接}</span>
						<input type="text" data-options="required:true" class="easyui-validatebox" style="width: 150px" name="popInfoObj.showInfo.bigPicAddress" value="${popInfoObj.showInfo.bigPicAddress}">
					</td>
					<td  class="pannel-td">
						<span class="content-sp" >${internationalConfig.图片链接跳转到}</span>
						<input type="text" data-options="required:true" class="easyui-validatebox" style="width: 150px" name="popInfoObj.showInfo.link" value="${popInfoObj.showInfo.link}">
					</td>
				</tr>
				<tr class="pannel-tr" >
					<td  class="pannel-td" colspan="2">
						<span class="content-sp">${internationalConfig.底部标题}</span>
						<input type="text" class="easyui-validatebox" style="width: 150px" name="popInfoObj.footerInfo.title" value="${popInfoObj.footerInfo.title }">
					</td>
				</tr>
				
				<c:forEach items="${popInfoObj.footerInfo.links }" var="item"  varStatus="status">
					<tr class="pannel-tr" >
						<td  class="pannel-td">
							<span class="content-sp">${internationalConfig.底部文案}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${status.index +1}</span>
							<input type="text" class="easyui-validatebox" style="width: 150px" name="popInfoObj.footerInfo.links[${status.index}].desc" value="${item.desc }">
						</td>
						<td  class="pannel-td">
							<span class="content-sp" >${internationalConfig.跳转链接}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${status.index +1}</span>
							<input type="text" class="easyui-validatebox" style="width: 150px" name="popInfoObj.footerInfo.links[${status.index}].link" value="${item.link}">
						</td>
					</tr>
			    </c:forEach>
			    <c:forEach items="${popInfoObj.footerInfo.button }" var="item"  varStatus="status">
					<tr class="pannel-tr" >
						<td  class="pannel-td">
							<span class="content-sp">${internationalConfig.底部按钮文案}</span>
							<input type="text" class="easyui-validatebox" style="width: 150px" name="popInfoObj.footerInfo.button[${status.index }].name" value="${item.name }">
						</td>
						<td  class="pannel-td">
							<span class="content-sp" >${internationalConfig.底部按钮跳转到}</span>
							<input type="text" class="easyui-validatebox" style="width: 150px" name="popInfoObj.footerInfo.button[${status.index }].link" value="${item.link}">
						</td>
					</tr>
				</c:forEach>
				<tr class="pannel-tr pannel-with-out pannel-with-in config" <c:if test="${not empty recommendConfig && recommendConfig.popType != 1 }"> style="display:none" </c:if>>
	  				<td colspan="2" class="pannel-td">
		  				<span class="content-sp">${internationalConfig.短信文案}</span>
						<textarea id="sms_content" class="text-area" name="smsContent" >${recommendConfig.smsContent } </textarea>
						<p class="right_p">
							<span id="sms_a"></span>
							<c:if test="${not empty recommendConfig && recommendConfig.flag== 1}"> 
								<input type="button" id="sendSmsButton" value="${internationalConfig.发送}">
						   </c:if>
						</p>
	   				 </td>
	   			</tr>
				<tr class="pannel-tr pannel-with-out pannel-with-in config" <c:if test="${not empty recommendConfig && recommendConfig.popType != 1 }"> style="display:none" </c:if>>
		  				<td colspan="2" class="pannel-td">
		  					<div class="push_div">
				  				<p>
				  				<span class="content-sp">PUSH<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.文案}</span>
								<textarea name="pushContent" id="push_content" class="text-area" >${recommendConfig.pushContent }</textarea>
								</p>
								<p>
				  				<span class="content-sp">PUSH<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.类型}</span>
								<select name="pushType" id="pushType">
									<option value="3" <c:if test="${recommendConfig.pushType eq 3 }">selected</c:if>>${internationalConfig.影片推送}</option>
									<option value="6" <c:if test="${recommendConfig.pushType eq 6 }">selected</c:if>>h5<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.推送}</option>
								</select>
								</p>
								<p>
							    <c:choose>
							    	<c:when test="${empty recommendConfig || recommendConfig.pushType== 3}">
							    		<span class="content-sp" id="push_resid">${internationalConfig.影片}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>VID</span>
										<input type="text" class="easyui-validatebox" style="width: 150px" name="pushResid" id="pushResid" value="${recommendConfig.pushResid }">
							    		<span id="resid_desc" style="color:red;"></span>
							    	</c:when>
							    	<c:when test="${not empty recommendConfig && recommendConfig.pushType== 6}">
							    		<span class="content-sp" id="push_resid">H5<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.链接}</span>
										<input type="text" class="easyui-validatebox" style="width: 150px" name="pushResid" id="pushResid" value="${recommendConfig.pushResid }">
							    		<span id="resid_desc" style="color:red;">&nbsp;&nbsp;*${internationalConfig.去除H5链接_长文本}</span>
							    	</c:when>
							    </c:choose>
								</p>
								<p>
								<span class="content-sp">PUSH<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.图片}</span>
								<input type="text" class="easyui-validatebox" style="width: 150px" name="pushImg" id="pushImg" value="${recommendConfig.pushImg }">
								</p>
							</div>
							<p class="right_p right_p02">
								<span id="push_a"></span>
							   <c:if test="${not empty recommendConfig && (recommendConfig.flag== 1 || recommendConfig.flag== 2)}"> 
									<input type="button" id="pushButton" value="${internationalConfig.发送}">
							   </c:if>
							</p>
							
		   				 </td>
	   			</tr>
            </table>
        </form>
    </div>
    
</div>
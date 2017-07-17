<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/inc/jstl.inc"%>
<c:if test="${not empty param.singlePage}">
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
</c:if>
<script src="/static/lib/swfupload/swfupload.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" src="/static/lib/uploadImgCommon.js?v=20150408.01" charset="utf-8"></script>
<script type="text/javascript">
  $(function() {
    parent.$.messager.progress('close');
    (function($){
		  $.fn.serializeJson=function(){ 
	 
		      var serializeObj={};  
		      var array=this.serializeArray();  
		      // var str=this.serialize(); 
		      $(array).each(function(){ // 遍历数组的每个元素 {name : xx , value : xxx} 
		              if(serializeObj[this.name]){ // 判断对象中是否已经存在 name，如果存在name 
		                    /* if($.isArray(serializeObj[this.name])){ 
		                           serializeObj[this.name].push(this.value); // 追加一个值 hobby : ['音乐','体育'] 
		                    }else{ 
		                            // 将元素变为 数组 ，hobby : ['音乐','体育'] 
		                            serializeObj[this.name]=[serializeObj[this.name],this.value]; 
		                    }  */
		                  serializeObj[this.name]+=","+this.value;
		              }else{ 
		                      serializeObj[this.name]=this.value; // 如果元素name不存在，添加一个属性 name:value 
		              } 
		      }); 
		      return serializeObj; 
		  }
		})(jQuery)
    $('#form').form({
      url : '/v2/product/vipType/save',
      onSubmit : function() {
        //提交前,去除两个默认checkbox的disabled属性，让后台能够得到这两个值
        $("#feature30").attr("disabled", false);
        $("#feature31").attr("disabled", false);
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
                  parent.$.messager.alert('${internationalConfig.成功}', <c:choose><c:when test="${packageTypeInfo!=null}">'${internationalConfig.编辑成功}'</c:when><c:otherwise>'${internationalConfig.添加成功}'</c:otherwise></c:choose>, 'success');
          parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
          parent.$.modalDialog.handler.dialog('close');
        } else {
          parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
        }
      }
    });
    checkedOn($('input[name="webLive"]'),'${web.live}');
    checkedOn($('input[name="appLive"]'),'${app.live}');
    checkedOn($('input[name="padLive"]'),'${pad.live}');
    checkedOn($('input[name="tvLive"]'),'${tv.live}');
    function checkedOn(eles,str){
    	var arr=str.split(',');
      eles.each(function(index,value){
    	  
    		  if(str.length>0&&$.inArray($(this).val(),arr)>-1){
    	          $(this).attr('checked','checked');
    	      } 
    	
        
      })
    }
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
  
  /* //校验会员名称是否存在
  function isExist(){
		 var Vname=document.getElementById("name").value;
		//去除前后空白
		 Vname = $.trim(Vname);
		 if(Vname == "")
		 {
			 $("#message").html(" 会员名称不能为空");
		 	return;
		 }
		 $.ajax({
		 		type: "POST",    
		         url: "/v2/product/vipType/ajaxQueryName",    
		         data: "name="+Vname, 
		         success: function(data){
			    if(data=="true" || data==true){   
			    	$("#message").html("");  
			    }else{   
			    	$("#message").html(" 该名称已存在");  
		    	} 
		  		}          
		        });   
		} */
	function onCategoryChange(category){
		var tr = $('#vendorVipTr');
        var aggPackageList = $('input[name=aggPackageList]');
        var inputs = tr.find("input");
		if (category==103) {
            inputs.validatebox({
                novalidate:false
            });
            tr.show();
            aggPackageList.prop("disabled", true);
			$('#aggPackageListTr').hide();
			$('#aggPackageListDescTr').hide();
		} else {
            inputs.val('');
            inputs.validatebox({
                novalidate:true
            });
            tr.hide();
            aggPackageList.prop("disabled", false);
			$('#aggPackageListDescTr').show();
			$('#aggPackageListTr').show();
		}
	}
    <c:if test="${packageTypeInfo.category!=103}">
    $(document).ready(function(){
        $('#vendorVipTr').find("input").validatebox({
            novalidate:true
        });
    });
    </c:if>
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
  <div data-options="region:'center',border:false" title="">
    <form id="form" method="post"
      action="${pageContext.request.contextPath}/mealController/create">
      <table style="width: 100%" class="table table-form">
        <colgroup>
          <col width="70">
          <col width="140">
          <col width="70">
          <col width="*">
        </colgroup>
        <input type="hidden" name="id" value="${packageTypeInfo.id}"/>
        <tr>
          <th style="width:55px;"><b style="color: red">*</b>${internationalConfig.会员名称}</th>
          <td><input type="text" id="name" name="name" value="${packageTypeInfo.name}" class="easyui-validatebox"
            data-options="required:true,"/> <span id="message" style="color: red;font-size: 12px"></span></td>
          <th><b style="color: red">*</b>${internationalConfig.会员类别}</th>
          <td>
              <select name="category" id="category" style="width: 150px" onchange="onCategoryChange(this.value)">
                  <c:forEach var="vipCategory" items="${vipCategoryList}">
                      <option value="${vipCategory.category}" ${vipCategory.category == packageTypeInfo.category ? "selected":""}> ${internationalConfig[vipCategory.name]}</option>
                  </c:forEach>
              </select>
          </td>
        </tr>
        <c:if test="${currentCountry==86}">
		<tr id="vendorVipTr" style="<c:choose><c:when test="${packageTypeInfo.category==103}"></c:when><c:otherwise>display:none;</c:otherwise></c:choose>">
			<th><b style="color: red">*</b>${internationalConfig.商家ID}</th>
			<td><input type="text" id="vendorId" name="vendorId" value="${packageTypeInfo.vendorId}" class="easyui-validatebox" data-options="required:true"/></td>
			<th nowrap="nowrap"><b style="color: red">*</b>${internationalConfig.商家会员ID}</th>
			<td><input type="text" id="vendorVipId" name="vendorVipId" value="${packageTypeInfo.vendorVipId}" class="easyui-validatebox" data-options="required:true"/></td>
		</tr>
	    </c:if>
        <tr>
			<th>${internationalConfig.会员图片}</th>
			<td ><input type="text" id="common_pic" name="pic" value="${packageTypeInfo.pic}"/></td>
			<td>
				<input class="buttoncenter" type="button" value="${internationalConfig.上传文件}" id="common_upload_btn" />
			</td>
            <td nowrap="nowrap">
				<div id="common_preview" name="img-mobile">
					<c:if test="${not empty packageTypeInfo.pic}"><a href="${packageTypeInfo.pic}" target="_blank">${internationalConfig.查看图片}</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</c:if>
					${internationalConfig.图片尺寸限制为414_233}
				</div>
				</div>
			</td>
		</tr>
		<tr <c:if test="${country!=1}">style="display: none"</c:if> >
			<th>
				${internationalConfig.试用时长}
			</th>
			<td>
				<select id="durationId" name="durationId" style="width:155px">
					<option value="0">${internationalConfig.无}</option>
					<c:forEach items="${trialDurationList}" var="trialDuration">
						<c:choose>
							<c:when test="${packageTypeInfo.durationId == trialDuration.id}">
								<option value="${trialDuration.id}" selected="selected">${trialDuration.durationName}</option>
							</c:when>
							<c:otherwise>
								<option value="${trialDuration.id}">${trialDuration.durationName}</option>
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr>
			<th>${internationalConfig.会员描述}</th>
			<td colspan="3"><textarea name="ext" class="txt-middle">${packageTypeInfo.ext}</textarea></td>
		</tr>

        		<tr id="aggPackageListDescTr" <c:if test="${packageTypeInfo.category==103}"> style="display: none;" </c:if>>
		          <th colspan='4'>
		             ${internationalConfig.请配置该会员类型包含的权益包}
		          </th>
		        </tr>
        		<tr id="aggPackageListTr" <c:if test="${packageTypeInfo.category==103}"> style="display: none;" </c:if>>
		        <td colspan="4" style="border-top:none;">
		        <p>
        		<c:forEach items="${aggPackageList}" var="aggPackage">
        		    <span style="display:inline-block">
        		    	<c:set var="match" value="0" />
        		        <c:forEach items="${bindedAggPackageIdList}" var="bindedId">
        		        	<c:if test="${aggPackage.id==bindedId}">
        		        		<c:set var="match" value="1" />
        		        	</c:if>
        		        </c:forEach>
        		        <input id="aggPackage_${aggPackage.id}" type="checkbox" name="aggPackageList" value="${aggPackage.id}" <c:if test="${match==1}"> checked="checked" </c:if> <c:if test="${packageTypeInfo.category==103}"> disabled="disabled"</c:if> /> ${aggPackage.aggPackageName} &nbsp;&nbsp;
	                </span>
	            </c:forEach>
	            </p>
	            </td>
	            </tr>

		<%--
        <c:choose>
        	<c:when test="${fn:length(aggPackageList) > 0}">
        	    <tr>
		          <th colspan='4'>
		             请配置该会员类型包含的权益包
		          </th>
		        </tr>
        		<tr>
		        <td colspan="4" style="border-top:none;">
        		<c:forEach items="${aggPackageList}" var="aggPackage">
	                    <c:choose>
	                        <c:when test="${fn:contains(bindedAggPackageIdList, aggPackage.id)}">
	                            <input id="aggPackage_${aggPackage.id}" type="checkbox" name="aggPackageList" value="${aggPackage.id}" checked="checked" /> ${aggPackage.aggPackageName}
	                        </c:when>
	                        <c:otherwise>
	                            <input id="aggPackage_${aggPackage.id}" type="checkbox" name="aggPackageList" value="${aggPackage.id}" /> ${aggPackage.aggPackageName}
	                        </c:otherwise>
	                    </c:choose>
	            </c:forEach>
	            </td>
	            </tr>
        	</c:when>
        	<c:otherwise>
        		<tr>
		          <th colspan='4'>
		             ${internationalConfig.请配置该会员类型各终端可支持的权益信息}
		          </th>
		        </tr>
		        <tr>
		          
		          <td colspan="4" style="border-top:none;">
		            
		            <table width='80%' border="1" align="center" style="border:1px solid #ddd;text-align:center;">
		              
		              <tr>
		                <td style="text-align:center;">
		                  ${internationalConfig.支持终端}  
		                </td>
		                <td style="text-align:center;">
		                   ${internationalConfig.支持权益}  
		                </td>
		              </tr>
		         
		              <tr>
		                <td style="text-align:center;">
		                  Web 
		                </td>
		                <td style="text-align:center;">
		                <c:set var="terminal"  value="web"   />
		                  <%@ include file="/WEB-INF/views/inc/vip_benefit.inc"%>
		                  
		                </td>
		              </tr>
		              <tr>
		                <td style="text-align:center;">
		                 app
		                </td>
		                <td style="text-align:center;">
		                     <c:set var="terminal"  value="app"   />
		                  <%@ include file="/WEB-INF/views/inc/vip_benefit.inc"%>
		                  
		                </td>
		              </tr>
		              <tr>
		                <td style="text-align:center;">
		                  Pad 
		                </td>
		                <td style="text-align:center;">
		                     <c:set var="terminal"  value="pad"   />
		                  <%@ include file="/WEB-INF/views/inc/vip_benefit.inc"%>
		                  
		                </td>
		              </tr>
		              <tr>
		                <td style="text-align:center;">
		                  ${internationalConfig.TV}
		                </td>
		                <td style="text-align:center;">
		                     <c:set var="terminal"  value="tv"   />
		                  <%@ include file="/WEB-INF/views/inc/vip_benefit.inc"%>
		                  
		                </td>
		              </tr>
		            </table>
		          </td>
		          
		         </tr> 
        	</c:otherwise>
        </c:choose>
        --%>

      </table>
    </form>
  </div>
</div>
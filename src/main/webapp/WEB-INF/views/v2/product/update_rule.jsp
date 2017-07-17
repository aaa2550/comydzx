<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script type="text/javascript">
    $(function () {
      init();
        parent.$.messager.progress('close');
        $('#form').form({
            url: '/v2/product/video/letv/update_rule_save',
            onSubmit: function () {
                parent.$.messager.progress({
                    title: '${internationalConfig.提示}',
                    text: '${internationalConfig.数据处理中}....'
                });
                var isValid = $(this).form('validate');
                if (!isValid) {
                    parent.$.messager.progress('close');
                }
                
                var episodesShow = $("#episodesShow").val();
                var episodesDay = $("#episodesDay").val();
                var episodesCount = $("#episodesCount").val();
                
                if(episodesShow == 0) {
                	if(episodesDay == 0 || episodesCount == 0) {
                		parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.初始展示集数为0时}', 'error');
    					parent.$.messager.progress('close');
    					return false;
                	}
                }
                
                var ruleType = $('input:radio[name="ruleType"]:checked').val();
       			if(ruleType == 1) {
       				if($("#latestEpisodesPay").val() == 0) {
       					parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.最新几集付费不能为空0}", 'error');
    					parent.$.messager.progress('close');
    					return false;
       				}
       			} else if(ruleType == 2) {
       				var preEpisodesFree = $("#preEpisodesFree").val();
       				var dayCycle = $("#dayCycle").val();
       				var freeCount = $("#freeCount").val();
       				
       				if(preEpisodesFree == 0) {
       					if(dayCycle == 0 || freeCount == 0) {
           					parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.前几集免费为0时}", 'error');
        					parent.$.messager.progress('close');
        					return false;
       					}
       				}
       			} else if(ruleType == 3) { //按周计算
       				var isTrue = true;
                    $($("input:checkbox[name='week']")).each(function(){
                       if($(this).is(':checked')) {
                         isTrue = false;
                       }                      
                    });

                    if(isTrue) {
                    	parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.请选择周几免费}', 'error');
                    	parent.$.messager.progress('close');
                        return false;
                    }
                    
                    var freeCountWeek = $("#freeCountWeek").val();
                    if(freeCountWeek == 0) {
                    	parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.请选择周几免费Add}', 'error');
                    	parent.$.messager.progress('close');
                        return false;
                    }
       			}
                
                if($("#regularTime").val() == "") {
                	parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.定时发送时间不能为空}!", 'error');
					parent.$.messager.progress('close');
					return false;
                }
                
                return isValid;
            },
            success: function (result) {
                parent.$.messager.progress('close');
                result = $.parseJSON(result);
                if (result.code == 0) {
					parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.编辑成功}', 'success');
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
                }
            }
        });
    });
    
  	//增加自定义的表单验证规则
	$.extend($.fn.validatebox.defaults.rules, {
		number : {
			validator : function(value, param) {
				var reg = new RegExp("^[0-9]+$");
				return reg.test(value);
			},
			message : '${internationalConfig.请输入合法整数}'
		}
	});
  	
  	var weekStr = '${movieVideoRule.weeks}';
  	if(weekStr != '') {
  		var weekArry = weekStr.split(",");
  		for(var i = 0; i < weekArry.length; i ++) {
  			$("#week_" + weekArry[i]).prop('checked', true);
  		}
  	}
  	
  	function movieVideoSync(){
  	 $.get("/movie/movie_video_sync?movieId="+$("input[name=movieId]").val(),function(data){
  		parent.$.messager.alert('${internationalConfig.成功}', data.msg, 'success');
  	 },"json")	;
  	};
  	 function init() {
        $("select[name='immediatelyValidate']").find("option[value='" + ${movieVideoRule.immediatelyValidate} + "']").attr('selected',true);
    }
</script>
<div class="easyui-layout" data-options="fit:true,border:false" style="width: 800px; height: 600px">
    <div data-options="region:'center',border:true" title="">
        <form id="form" method="post">
        	<input type="hidden" name="movieId" value="${movieVideoRule.movieId}" />
            <table style="width: 100%;" class="table table-form">
				<colgroup>
					<col width="100">
					<col width="230">
					<col width="90">
					<col width="*">
				</colgroup>
				<tr>
					<th>${internationalConfig.从媒资获取视频集数}</th>
					<td><input type="text" readonly="readonly" value="${videoListCount}" /></td>
					<th>${internationalConfig.免费集数}</th>
					<td><input type="text" readonly="readonly" value="${movieVideoRule.totalFreeCount}" /></td>
				</tr>
				<tr>
                    <th>${internationalConfig.规则创建时间}</th>
                    <td colspan="3"><input type="text" readonly="readonly"
						value="<fmt:formatDate pattern="yyyy-MM-dd" value="${movieVideoRule.createTime}"/>"
						class="easyui-datebox" /></td>
                </tr>
                <tr>
                    <th>${internationalConfig.初始展示集数}</th>
                    <td><input type="text" style="width:50px;" id="episodesShow" name="episodesShow" value="${movieVideoRule.episodesShow}" class="easyui-validatebox" data-options="required:true,validType:'number'" /></td>
                    <td colspan="2">${internationalConfig.每}&nbsp;&nbsp;<input type="text" id="episodesDay" name="episodesDay" style="width:50px;" value="${movieVideoRule.episodesDay}" class="easyui-validatebox" data-options="required:true,validType:'number'" />&nbsp;&nbsp;${internationalConfig.天增加显示}&nbsp;&nbsp;<input type="text" id="episodesCount" name="episodesCount" style="width:50px;" value="${movieVideoRule.episodesCount}" class="easyui-validatebox" data-options="required:true,validType:'number'" />&nbsp;&nbsp;${internationalConfig.集数}</td>
                </tr>

                <tr>
                    <td colspan="4"><input name="ruleType" <c:if test="${movieVideoRule.ruleType == 1 || movieVideoRule.ruleType == 0}"> checked="checked" </c:if> type="radio" value="1"/>&nbsp;&nbsp;&nbsp;&nbsp;${internationalConfig.最新}&nbsp;&nbsp;<input type="text" style="width:50px;" id="latestEpisodesPay" name="latestEpisodesPay" value="${movieVideoRule.latestEpisodesPay}" class="easyui-validatebox" data-options="required:true,validType:'number'" />&nbsp;&nbsp;${internationalConfig.集付费}</td>
                </tr>
                <tr>
                    <td colspan="4"><input name="ruleType" <c:if test="${movieVideoRule.ruleType == 2}"> checked="checked" </c:if> type="radio" value="2"/>&nbsp;&nbsp;&nbsp;&nbsp;${internationalConfig.前}&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" style="width:50px;" id="preEpisodesFree" name="preEpisodesFree" value="${movieVideoRule.preEpisodesFree}" class="easyui-validatebox" data-options="required:true,validType:'number'" />&nbsp;&nbsp;${internationalConfig.集免费}，${internationalConfig.每}<input type="text" id="dayCycle" name="dayCycle" style="width:50px;" value="${movieVideoRule.dayCycle}" class="easyui-validatebox" data-options="required:true,validType:'number'" />${internationalConfig.天增加}<input type="text" id="freeCount" name="freeCount" style="width:50px;" value="${movieVideoRule.freeCount}" class="easyui-validatebox" data-options="required:true,validType:'number'" />${internationalConfig.集免费}</td>
                </tr>
                <tr>
                    <td colspan="4"><input name="ruleType" <c:if test="${movieVideoRule.ruleType == 3}"> checked="checked" </c:if> type="radio" value="3"/>&nbsp;&nbsp;&nbsp;&nbsp;${internationalConfig.前}&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" style="width:50px;" id="preEpisodesFreeWeek" name="preEpisodesFreeWeek" value="${movieVideoRule.preEpisodesFreeWeek}" class="easyui-validatebox" data-options="required:true,validType:'number'" />&nbsp;&nbsp;${internationalConfig.集免费}，${internationalConfig.周}&nbsp;&nbsp;<input id="week_2" name="week" type="checkbox" value="2" />${internationalConfig.一}&nbsp;
                    	<input id="week_3" name="week" type="checkbox" value="3" />${internationalConfig.二}&nbsp;<input id="week_4" name="week" type="checkbox" value="4" />${internationalConfig.三}&nbsp;<input id="week_5" name="week" type="checkbox" value="5" />${internationalConfig.四}&nbsp;
                    	<input id="week_6" name="week" type="checkbox" value="6" />${internationalConfig.五}&nbsp;<input id="week_7" name="week" type="checkbox" value="7" />${internationalConfig.六}&nbsp;<input id="week_1" name="week" type="checkbox" value="1" />${internationalConfig.七}
                    	${internationalConfig.增加}&nbsp;&nbsp;<input type="text" id="freeCountWeek" name="freeCountWeek" style="width:50px;" value="${movieVideoRule.freeCountWeek}" class="easyui-validatebox" data-options="required:true,validType:'number'" />&nbsp;&nbsp;${internationalConfig.集免费}</td>
                </tr>
                <tr>
                    <th>${internationalConfig.是否立即发布}</th>
                    <td>
                        <select name="immediatelyValidate" style="width:100px;">
                            <option value="0" selected>${internationalConfig.否}</option>
                            <option value="1">${internationalConfig.是}</option>
                        </select>
                    </td>
                    <th>${internationalConfig.定时发送时间}</th>
					<td>
						<input type="text" id="regularTime" name="regularTime" value="${movieVideoRule.regularTime}" style="with:100px;"/>
					</td>
                </tr>
            </table>
        </form>
    </div>
</div>
<style>
.table th{white-space: nowrap;}
</style>
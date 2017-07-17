<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${not empty param.singlePage}">
	<%@ include file="/WEB-INF/views/inc/head.inc"%>
</c:if>
<style>
.noborder{border:1px dashed #aaa;}
.noborder tr{border:0;}
textarea {height:80px;}
.bold {font-weight: bold}
.short_number{width:50px;white-space: nowrap}
td .title{vertical-align: text-top !important;}
.dash_top_border{border-top:1px dashed #aaa;}
</style>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="" style="overflow: auto;">
		<form id="form" method="post" action="/vip_prerogative/save">
			<table class="table">
				<tr>
					<th width="73"><b style="color: red">*</b>${internationalConfig.等级类型}:</th>
					<td>
						<c:choose><c:when test="${not empty vipPrerogative}">
							<input type="hidden" name="vipPrerogativeType" value="${vipPrerogative.vipPrerogativeType}">
							<input style="height: 30px;width: 180px;" value="${dict['vip_level_type'][vipPrerogative.vipPrerogativeType]}" readonly="readonly">
						</c:when><c:otherwise>
							<select name="vipPrerogativeType" id="vipPrerogativeType" style="height: 30px;width: 180px;" class="easyui-validatebox" data-options="required:true">
							<option value="">${internationalConfig.请选择等级类型}</option>
							<c:forEach var="vipType" items="${dict['vip_level_type']}">
								<option value="${vipType.key}">${vipType.value}</option>
							</c:forEach>
							</select>
						</c:otherwise></c:choose>
					</td>
					<th><b style="color: red">*</b>${internationalConfig.等级级数}:</th>
					<td>
						<c:choose>
						<c:when test="${empty vipPrerogative}">
						<select name="level" id="level" style="width: 80px" class="easyui-validatebox" data-options="required:true" onchange="setDefaultName()">
							<option value="">${internationalConfig.请选择}</option>
						</select>
						</c:when>
						<c:otherwise>
							<input name="level" class="easyui-validatebox" style="width:60px;" data-options="required:true" type="text" readonly="readonly" value="${vipPrerogative.level}">
						</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<th width="73"><b style="color: red">*</b>${internationalConfig.等级名称}:</th>
					<td colspan="3">
						<input id="name" name="name" edited="false" class="easyui-validatebox" style="width: 200px" data-options="required:true" type="text" value="${vipPrerogative.name}" onchange="nameChanged()"/>
					</td>
				</tr>
				<tr>
					<th>${internationalConfig.等级描述}:</th>
					<td colspan="3">
						<textarea name="description" class="txt-middle">${vipPrerogative.description}</textarea>
					</td>
				</tr>
				<tr>
					<th><b style="color: red">*</b>${internationalConfig.配置权益包}:</th>
					<td colspan="3">
						<c:set var="rightConf" value="${vipPrerogative.rightConfObject}"/>
						<table class="noborder" width="100%">
							<c:set var="presentUniversalMovieTickets" value="${rightConf['presentUniversalMovieTickets']}"/>
							<tr>
								<td width="10">
									<c:if test="${presentUniversalMovieTickets['enabled']==true}"><c:set var="checked1" value="checked='checked'"/></c:if>
									<input type="checkbox" id="prsentUniversalMovieTicketsCheckbox" name="presentUniversalMovieTickets" class="rightConfig" ${checked1}>
								</td><td colspan="2">
									<span class="bold">${internationalConfig.赠送通用观影券}</span>
								</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td>
									${internationalConfig.赠送数量}:
								</td>
								<td>
									${internationalConfig.升级时}
									<input type="text" name="numberWhileUpgrading" class="short_number easyui-numberbox" precision="0" min="0" value="${presentUniversalMovieTickets['numberWhileUpgrading']}">${张},&nbsp;
									${internationalConfig.每月赠送}
									<input type="text" name="numberMonthly" class="short_number easyui-numberbox" precision="0" min="0" value="${presentUniversalMovieTickets['numberMonthly']}">${张}
								</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td class="title">
									${internationalConfig.赠送描述}:
								</td>
								<td>
									<textarea name="desc"  style="width:320px;" class="coupon txt-middle" >${presentUniversalMovieTickets['desc']}</textarea>
								</td>
							</tr>
							<c:set var="shareUniversalMovieTickets" value="${rightConf['shareUniversalMovieTickets']}"/>
							<tr style="border-top:1px dashed #aaa;" class="dash_top_border">
								<td width="10">
									<c:if test="${shareUniversalMovieTickets['enabled']==true}"><c:set var="checked2" value="checked='checked'"/></c:if>
									<input type="checkbox" id="shareUniversalTicketsCheckbox" name="shareUniversalMovieTickets" class="rightConfig" ${checked2}>
								</td><td colspan="2">
									<span class="bold">${internationalConfig.允许分享通用观影券}</span>
								</td>
							</tr><tr>
								<td>&nbsp;</td>
								<td class="title">${internationalConfig.分享描述}:</td>
								<td>
									<textarea name="desc"  style="width:320px;" class="coupon txt-middle" >${shareUniversalMovieTickets['desc']}</textarea>
								</td>
							</tr>
							<c:set var="sharePayingMovies" value="${rightConf['sharePayingMovies']}"/>
							<tr style="border-top:1px dashed #aaa;" class="dash_top_border">
								<c:if test="${sharePayingMovies['enabled']==true}"><c:set var="checked3" value="checked='checked'"/></c:if>
								<td width="10">
									<input type="checkbox" id="sharePayingMoviesCheckbox" name="sharePayingMovies" class="rightConfig" ${checked3}>
								</td><td colspan="2">
								<span class="bold">${internationalConfig.分享付费影片}</span>
								</td>
							</tr><tr>
								<td>&nbsp;</td>
								<td colspan="2"><div style="width: 150px;float: left">${internationalConfig.分享次数}:</div>
									<div style="float: left"><input type="text" name="sharingTimes" class="short_number easyui-numberbox" precision="0" min="0" value="${sharePayingMovies['sharingTimes']}">&nbsp;${internationalConfig.次}</div>
								</td>
							</tr><tr>
								<td>&nbsp;</td>
								<td colspan="2"><div style="width: 150px;float: left">${internationalConfig.每次分享观影机会}:</div>
									<div style="float: left"><input type="text" name="sharingChances" class="short_number easyui-numberbox" precision="0" min="0" value="${sharePayingMovies['sharingChances']}">&nbsp;${internationalConfig.机会}/${internationalConfig.次}(${internationalConfig.同一影片})</div>
								</td>
							</tr><tr>
								<td>&nbsp;</td>
								<td colspan="2"><div style="width: 150px;float: left">${internationalConfig.每次分享人数}:</div>
									<div style="float: left"><input type="text" name="sharingPersons" class="short_number easyui-numberbox" precision="0" min="0" value="${sharePayingMovies['sharingPersons']}">&nbsp;${internationalConfig.人}/${internationalConfig.次}</div>
								</td>
							</tr><tr>
								<td>&nbsp;</td>
								<td class="title">${internationalConfig.分享描述}:</td>
								<td>
									<textarea name="desc"  style="width:320px;" class="coupon txt-middle" >${sharePayingMovies['desc']}</textarea>
								</td>
						</tr>
						</table>
					</td>
				</tr>
				<tr>
					<th>
						<b style="color: red">*</b>
						${internationalConfig.发布时间}:
					</th>
					<td colspan="3">
						<input name="forceTime" class="easyui-datetimebox easyui-validatebox" value="${vipPrerogative.forceTime}"/>
					</td>
				</tr>
            </table>
			<input type="hidden" name="rightConf" id="rightConf">
        </form>
    </div>
</div>
<script src="/static/lib/json2.min.js"></script>
 <script type="text/javascript">
$(function() {
	$('input[name="forceTime"]').datetimebox({  
	   showSeconds:false,  
	   required:true
	}); 

	$("input[type=checkbox]").click($(this), checkChange);
	$("input[type=checkbox]").each(function () {
		var _self = this;
		setTimeout(function(){checkChange(null, _self)}, 100);
	});

	parent.$.messager.progress('close');
	 $('#form').form({
		url : '/vip_prerogative/save',
		onSubmit : function() {
			if(!$(this).form('validate')){
				return false;
			}else{
				var checkboxes = $('.rightConfig');
				if(checkboxes.is(":checked")){
					var rightConf = {};
					checkboxes.each(function(){
						var _self=$(this);
						rightConf[_self.attr('name')] = {};
						var rightConfig_i=rightConf[_self.attr('name')];
						if (_self.is(":checked")) {
							rightConfig_i.enabled = true;
							_self.parent().parent().nextUntil(".dash_top_border").find("input[type=hidden],textarea").each(function(){
								var configItemInput = $(this);
								var configItemValue = $.trim(configItemInput.val());
								if (configItemValue=='')configItemValue=null;
								if ($.isNumeric(configItemValue)) {
									configItemValue = configItemValue.indexOf('.') == -1 ? parseInt(configItemValue):parseFloat(configItemValue);

								}
								rightConfig_i[configItemInput.attr('name')]=configItemValue;
							});
						} else {
							rightConfig_i.enabled = false;
						}
					});
					/*if(!window.confirm('${internationalConfig.确定要保存该会员等级配置吗}?')){
						return false;
					};*/
					$("#rightConf").val(JSON.stringify(rightConf));
					parent.$.messager.progress({
						title : '${internationalConfig.提示}',
						text : '${internationalConfig.数据处理中请稍后}....'
					});
					return true;
				}else{
					parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.请至少配置一个权益包}', 'error');
					return false;
				}
			}
			//return true;
		},
		success : function(result) {
			parent.$.messager.progress('close');
			result = $.parseJSON(result);
			if (result.code == 0) {
            	parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.编辑成功}', 'success');
				parent.$.modalDialog.openner_dataGrid.datagrid('reload');
				parent.$.modalDialog.handler.dialog('close');
			} else {
				parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
			}
		}
	});

	<c:if test="${empty vipPrerogative}">
	$("#vipPrerogativeType").change(function(){
		var value = $(this).val();
		var levelSelect = $("#level");
		levelSelect.empty();
		if (value){
			$.getJSON("/vip_prerogative/available_levels/"+value, function(result){
				if(result.code!=0){
					parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
				} else {
					if (result.data.length !=0) {
						levelSelect.append($('<option>', {value:'', text:'${internationalConfig.请选择}'}));
						$.each(result.data, function (i,item) {
							levelSelect.append($('<option>', {value:item, text:'${internationalConfig.等级}'<c:if test="${currentLanguage!='zh'&&currentLanguage!='zh_hk'}">+' '</c:if> + item}));
						});
					} else {
						levelSelect.append($('<option>', {value:'', text: '${internationalConfig.已经没有可以添加的等级}'}));
					}
				}
			});
		} else {
			levelSelect.append($('<option>', {value:'', text:'${internationalConfig.请选择}'}));
		}
	});
	</c:if>
});

function checkChange(event,obj) {
	checkbox = this == window ? $(obj) : $(this);
	var checked = $(checkbox).is(":checked");
	if (checked) {
		checkbox.parent().parent().nextUntil(".dash_top_border").each(function(){
			var _self = $(this);
			_self.find("input[type=text]").validatebox({
				required: true
			});
			_self.find("input").removeAttr("disabled");
			_self.find("textarea").removeAttr("disabled");
		});
	} else {
		checkbox.parent().parent().nextUntil(".dash_top_border").each(function(){
			var _self = $(this);
			_self.find("input[type=text]").validatebox({
				required: false
			});
			_self.find("input").attr("disabled", "disabled");
			_self.find("textarea").attr("disabled", "disabled");
		});
	}
}

function nameChanged(){
	var input = $("#name");
	input.val($.trim(input.val()));
	if (input.val()=='')
		input.attr("edited", "false");
	else
		input.attr("edited", "true");
}
function setDefaultName() {
	if ($("#name").attr("edited")=="true")
		return;
	var levelType = $("#vipPrerogativeType option:selected").text();
	var level = $("#level option:selected").text();
	if (levelType==''||level=='')
		return;
	$('#name').val(levelType<c:if test="${currentLanguage!='zh'&&currentLanguage!='zh_hk'}">+' '</c:if>+level);
}

</script>


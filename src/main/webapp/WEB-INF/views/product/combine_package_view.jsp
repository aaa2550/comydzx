<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form').form({
			url : '/combine_package/update.json',
			onSubmit : function() {
				parent.$.messager.progress({
					title : '${internationalConfig.提示}',
					text : '${internationalConfig.数据处理中}....'
				});
				
				var isflag = true;
				var selectCount = 0;
				
				$("select").each(function(){
					selectCount ++;
					if($(this).val() == -1) {
						isflag = false;
					}
				});
				
				if(! isflag) {
					alert("${internationalConfig.选择项不能为空}!");
					parent.$.messager.progress('close');
					return false;
				}
				
				if(selectCount <= 1) {
					alert("${internationalConfig.请添加子套餐}!");
					parent.$.messager.progress('close');
					return false;
				}
				
				if($("#price").val() < 0 || isNaN($("#price").val())) {
					alert("${internationalConfig.请添加子套餐}!");
					parent.$.messager.progress('close');
					return false;
				}
				
				var isNumberFlag = true;
				
				$("input[name='discountPrices']").each(function(){ 
					var price = $(this).val();
					var reg = new RegExp("^[0-9]+(.[0-9]+)?$");
					if(! reg.test(price)) {
						isNumberFlag = false;
					}
				});
				
				if(! isNumberFlag) {
					alert("${internationalConfig.请输入合法折扣价格}!");
					parent.$.messager.progress('close');
					return false;
				}
				
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
	
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post"
			action="">
			<table style="width: 100%" class="table table-form">
				<colgroup>
					<col width="90">
					<col width="265">
					<col width="140">
					<col width="*">
				</colgroup>
				<tr>
					<th>${internationalConfig.套餐名称}：</th>
					<td>${combinePackage.name}</td>
					<th>${internationalConfig.套餐状态}：</th>
					<td>
						<c:if test="${combinePackage.status == 0}">${internationalConfig.上线}</c:if>
						<c:if test="${combinePackage.status == 1}">${internationalConfig.下线}</c:if>
					</td>
				</tr>
				<tr>
					<th>${internationalConfig.套餐原价}：</th>
					<td>${combinePackage.originPrice}</td>
					<th>${internationalConfig.套餐现价}：</th>
					<td>${combinePackage.price}</td>
				</tr>
				<tr>
					<th>${internationalConfig.套餐会员价}：</th>
					<td>${combinePackage.vipPrice}</td>
					<th></th>
					<td></td>
				</tr>
				<tr>
					<th>${internationalConfig.终端}</th>
					<td>${combinePackage.terminalsName}</td>
					<th>${internationalConfig.是否支持乐点}</th>
					<td>
						<c:if test="${combinePackage.isSupportLepoint == 0}">${internationalConfig.支持}</c:if>
						<c:if test="${combinePackage.isSupportLepoint == 1}">${internationalConfig.不支持}</c:if>
					</td>
				</tr>
			</table>
			
			<table id="childPackage" style="width: 780" class="table table-form">
				<tr>
					<th>${internationalConfig.子套餐名称}</th>
					<th>${internationalConfig.套餐类型}</th>
					<th>${internationalConfig.套餐明细}</th>
					<th>${internationalConfig.死忠季票包}</th>
					<th>${internationalConfig.原价}</th>
					<th>${internationalConfig.折扣价}</th>
					<th>${internationalConfig.操作}</th>
					<th></th>
				</tr>
				<c:forEach items="${combinePackage.vipPackageList}" var="vipPackage">
					<tr>
						<td>${internationalConfig.会员套餐}</td>
						<td>
							<c:if test="${vipPackage.packageName == 1}">${internationalConfig.移动影视会员}</c:if>
							<c:if test="${vipPackage.packageName == 9}">${internationalConfig.全屏影视会员}</c:if>
						</td>
						<td>
								${vipPackage.durationDesc}-时长${vipPackage.days}
						</td>
						<td></td>
						<td>${vipPackage.combinePrice}</td>
						<td>${vipPackage.combineDiscountPrice}</td> 
					</tr>
				</c:forEach>
				<c:forEach items="${combinePackage.playPackageList}" var="playPackage">
					<tr>
						<td>${internationalConfig.直播套餐}</td>
						<td>
							<c:if test="${playPackage.matchid == '04'}">${internationalConfig.体育频道}</c:if>
							<c:if test="${playPackage.matchid == '09'}">${internationalConfig.音乐频道}</c:if>
						</td>
						<td>
							${playPackage.playName}
						</td>
						<td>
							<c:choose>
								<c:when test="${playPackage.matchid == '04' && playPackage.type == 4}">
									<select multiple="multiple" style="width: 100px" disabled="disabled">
										<c:forEach items="${eplTeams}" var="team">
											<c:choose>
												<c:when test='${fn:contains(playPackage.teams,team.id)}'>
													<option value="${team.id}" selected="selected">${team.teamName}</option>
												</c:when>
												<c:otherwise>
													<option value="${team.id}">${team.teamName}</option>
												</c:otherwise>
											</c:choose>
										</c:forEach>
									</select>
								</c:when>
								<c:otherwise>
									
								</c:otherwise>
							</c:choose>
						</td>
						<td>${playPackage.combinePrice}</td>
						<td>${playPackage.combineDiscountPrice}</td> 
					</tr>
				</c:forEach>
				<%-- 
				<c:forEach items="${combinePackage.movieList}" var="movie">
					<tr>
						<td>影视剧</td>
						<td>
							<c:if test="${movie.contentType == 1}">电影</c:if>
							<c:if test="${movie.contentType == 2}">连续剧</c:if>
						</td>
						<td>
							${movie.movieName}
						</td>
						<td></td>
						<td>${movie.combinePrice}</td>
						<td>${movie.combineDiscountPrice}</td> 
					</tr>
				</c:forEach>
				--%>
			</table>
		</form>
	</div>
</div>
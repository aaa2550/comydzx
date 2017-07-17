<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<script type="text/javascript">
	var monthTotal = parseInt('${monthTotal}') / 31;
	
	$(function() {
		parent.$.messager.progress('close');
		$('#form').form({
			url : '${pageContext.request.contextPath}/device/user_split.json',
			onSubmit : function() {
				parent.$.messager.progress({
					title : '${internationalConfig.提示}',
					text : '${internationalConfig.数据处理中}'
				});
				
				var isFlag = true;
				var index = 0;
				
				var premac = $("#premac").val();
				if(premac == "") {
					parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.配对电视}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>MAC<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.不能为空}", 'error');
					parent.$.messager.progress('close');
					return false;
				}
				
				$("input[name=mac]").each(function() {
					var val = $(this).val();
					index ++;
					if(val == "") {
						parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.设备}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>MAC<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.不能为空}", 'error');
						isFlag = false;
						return;
					}
				});
				
				if(!isFlag) {
					parent.$.messager.progress('close');
					return false;
				}
				
				if(index <= 0) {
					parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.设备组不能为空}", 'error');
					isFlag = false;
				}
				
				if(!isFlag) {
					parent.$.messager.progress('close');
					return false;
				}
				
				$("input[name=activeUserId]").each(function() {
					var val = $(this).val();
					index ++;
					if(val == "") {
						parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.绑定用户不能为空}", 'error');
						isFlag = false;
						return;
					}
				});
				
				if(!isFlag) {
					parent.$.messager.progress('close');
					return false;
				}
				
				var reg = new RegExp("^[0-9]+(.[0-9]+)?$");
				
				var timeTotal = 0;
				
				$("input[name=resourceId]").each(function() {
					var val = $(this).val();
					if(val == "") {
						parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.拆分时长不能为空}", 'error');
						isFlag = false;
						return ;
					}
					
					if(reg.test(val) == false) {
						parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.拆分时长应为正整年数}", 'error');
						isFlag = false;
						return;
					}
					
					if(val <= 0) {
						parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.拆分时长应大于}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>0", 'error');
						isFlag = false;
						return ;
					}
					
					timeTotal = timeTotal + parseInt(val);
					
				});
				
				if(!isFlag) {
					parent.$.messager.progress('close');
					return false;
				}
				
				if(monthTotal - timeTotal * 12 <= 0) {
					parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.拆分不符合规则}", 'error');
					isFlag = false;
				}
				
				if(!isFlag) {
					parent.$.messager.progress('close');
					return false;
				}
				
				return isFlag;
			},
			success : function(result) {
				parent.$.messager.progress('close');
				result = $.parseJSON(result);
				if (result.code == 0) {
                	parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.拆分会员成功}', 'success');
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
					parent.$.modalDialog.handler.dialog('close');
				} else {
					parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
				}
			}
		});
	});
	
	//添加行
	function addRow() {
	   var table = $("#childPackage");
	   var tr = '<tr>'
			+ '<td><input type="text" name="mac" /></td>' 
			+ '<td><input type="text" name="activeUserId"  /></td>' 
			+ '<td><input type="text" name="resourceId" /></td>' 
			+ '<td><img onclick="delTr(this);" src="/static/style/images/extjs_icons'
			+ '/cancel.png" title="${internationalConfig.删除}"/></td>'
			+ '</tr>';
	   table.append(tr);
	}


	//删除行
	function delTr(delbtn){
	    $(delbtn).parents("tr").remove();
	};

</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post"
			action="">
			<table style="width: 100%" class="table table-form">
				<colgroup>
					<col width="100">
					<col width="80">
					<col width="80">
					<col width="100">
					<col width="80">
					<col width="*">
				</colgroup>
				<tr>
					<th>${internationalConfig.手机IMEI}：</th>
					<td><input type="text" id="splitimei" name="splitimei" readOnly="readOnly" value="${mac}" /></td>
					<th>${internationalConfig.配对电视}&nbsp;MAC：</th>
					<td><input type="text" id="premac" name="premac" class="easyui-validatebox"/></td>
					<th>${internationalConfig.拆分时长}(${internationalConfig.月})：</th>
					<td><input type="text" readOnly="readOnly" value="${monthTotal / 31}" /></td>
				</tr>
				<tr>
					<td><img onclick="addRow();" src="${pageContext.request.contextPath}/static/style/images/extjs_icons/pencil_add.png" title="${internationalConfig.添加设备组}"/><a href="javascript:void(0)" onclick="addRow();">${internationalConfig.添加设备组}</a></td>
					<td colspan="5">
					
					</td>
				</tr>
			</table>
			<table id="childPackage" style="width: 780" class="table table-form">
				<tr>
					<th>${internationalConfig.设备}&nbsp;MAC</th>
					<th>${internationalConfig.绑定用户}</th>
					<th>${internationalConfig.拆分时长}(${internationalConfig.年})</th>
					<th>${internationalConfig.操作}</th>
				</tr>
			</table>
		</form>
	</div>
</div>
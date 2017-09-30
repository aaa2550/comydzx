<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript">

	$(function() {
		parent.$.messager.progress('close');
        $('#addform').form({
        url : '${pageContext.request.contextPath}/share_role/add_submit.json',
        onSubmit : function() {
                parent.$.messager.progress({
					title : '${internationalConfig.提示}',
					text : '${internationalConfig.数据处理中请稍后}'
				});
				var isValid = $(this).form('validate');
            	var v = validCp();
				if (!isValid || !v) {
					parent.$.messager.progress('close');
				}
				return isValid && v;

			},
			success : function(result) {
				parent.$.messager.progress('close');
				result = $.parseJSON(result);
				if (result.code == 0) {
					parent.$.messager.alert('${internationalConfig.成功}', result.msg, 'success');
				} else {
					parent.$.messager.alert('${internationalConfig.错误}', result.msg,'error');
				}
				parent.$.modalDialog.openner_dataGrid.datagrid('reload');
				parent.$.modalDialog.handler.dialog('close');
			}
		});
        var co = new Boss.util.combo({
            url:'/share_role/copyRightList.json',//请求url
            inputSelector:'#copyrightList',       //搜索框id
            sName:'cpName'			//输入的参数名字
        });
        $(co).bind('select',function(eventName,el){
            //自定义选中后的操作
            $('#cpId').val(el.attr('data-id'));
//
        })
	});
	function checkValue(obj) {
		var checked = $(obj).prop('checked');
		if (checked) {
			$('#copyrightList').prop('disabled', true).val('');
			$('#cpId').val(-1);

		} else {
            $('#copyrightList').prop('disabled', false);
            $('#cpId').val('')
		}
    }

    function validCp() {
		var cpId = $("#cpId").val();
		if (cpId == '') {
		    alert("请选择版权公司");
		    return false;
		}
		return true;
    }
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="" >
		<form id="addform" method="post">
			<table class="table table-hover table-condensed">
				<tr>
					<td><span>${internationalConfig.角色名称}</span><input name="name" type="text" placeholder="${internationalConfig.请输入角色名称}" class="easyui-validatebox span2" data-options="required:true" value=""></td>
				</tr>
				<tr>
					
					<td><span>${internationalConfig.菜单权限}</span>
						<c:forEach items="${menuList}" var="var">
        				    <input type="checkbox" name="menus" value='${var.id}'>${var.name}
                        </c:forEach>
					</td>
				</tr>
				<tr>
					<td><span>${internationalConfig.所属版权方}</span>
						<%--<select name="copyrights" style="width: 160px">
                            <option value="-1" selected>${internationalConfig.不限}</option>
                        	<c:forEach items="${copyrightList}" var="var">
        				    <option value='${var.id}' >${var.name}</option>
                        	</c:forEach>
                        </select>--%>
						<input id="copyrightList" value="" style="width: 200px"/>
						<input type="hidden" name="copyrights" id="cpId" value=""/>
						<label style="display: inline-block;"><input type="checkbox" value="-1" onclick="checkValue(this)"/>${internationalConfig.不限}</label>
					</td>
				</tr>
				<tr>
					
					<td><span>${internationalConfig.返利渠道}</span>
					<select name="rebateChannels" style="width: 160px">
                            <option value="-1" selected>${internationalConfig.不限}</option>
                        	<c:forEach items="${rebateChannels}" var="var">
        				    <option value='${var.id}' >${var.name}</option>
                        	</c:forEach>
                        </select></td>
				</tr>
				<tr>
					<td><span>${internationalConfig.所属频道}</span>
					<select name="channels" style="width: 160px">
                            <option value="-1" selected>${internationalConfig.不限}</option>
                        	<c:forEach items="${channelList}" var="var">
        				    <option value='${var.id}' >${var.name}</option>
                        	</c:forEach>
                        </select></td>
				</tr>
				<tr>
					
					<td><input type="checkbox" name="enabledNature" value="yes">${internationalConfig.是否可查看自然数据}</td>
				</tr>
				<tr>
					
					<td colspan="3"><span>${internationalConfig.备注}</span><textarea name="remark" rows="" cols="" class="span5"></textarea></td>
				</tr>
			</table>
		</form>
	</div>
</div>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript">
	$(function() {
		$('#iconCls').combobox({
			data : $.iconData,
			formatter : function(v) {
				return String.format('<span class="{0}" style="display:inline-block;vertical-align:middle;width:16px;height:16px;"></span>{1}', v.value, v.value);
			},
			value : '${resource.iconCls}'
		});

		$('#pid').combotree({
			url : '${pageContext.request.contextPath}/sys/tree',
			parentField : 'pid',
			lines : true,
			panelMaxHeight : 300, 
			value : '${resource.pid}',
			onLoadSuccess : function() {
				parent.$.messager.progress('close');
			}
		});

		$('#form').form({
			url : '${pageContext.request.contextPath}/sys/edit.json',
			onSubmit : function() {
				parent.$.messager.progress({
					title : '${internationalConfig.提示}',
					text : '${internationalConfig.数据处理中}'
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
				if (result.code==0) {
					
		           try{
		        	   parent.$.modalDialog.openner_treeGrid.treegrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_treeGrid这个对象，是因为resource.jsp页面预定义好了
		   			parent.layout_west_tree.tree('reload');
		           }catch(e){};
					parent.$.modalDialog.handler.dialog('close');
				}
			}
		});
	});
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="" style="overflow: hidden;">
		<form id="form" method="post">
			<table class="table table-hover table-condensed table-form">
				<colgroup>
					<col width="70">
					<col width="100">
					<col width="70">
					<col width="180">
				</colgroup>
				<tr>
					<th>${internationalConfig.编号}</th>
					<td><input name="id" type="text" class="span2" value="${resource.id}" readonly="readonly"  ></td>
					<th>${internationalConfig.资源路径}</th>
					<td><input name="url" type="text" placeholder="${internationalConfig.请输入资源路径}" class="easyui-validatebox span2" value="${resource.url}"></td>
					
				</tr>
				<tr>
					<th>${internationalConfig.资源名称}（${internationalConfig.中}）</th>
					<td><input name="name" type="text" placeholder="${internationalConfig.请输入中文资源名称}" class="easyui-validatebox span2" data-options="required:true" value="${resource.name}"></td>
					<th>${internationalConfig.资源名称}（${internationalConfig.英}）</th>
					<td><input name="nameEn" type="text" placeholder="${internationalConfig.请输入英文资源名称}" class="easyui-validatebox span2" data-options="required:true" value="${resource.nameEn}"></td>
				</tr>
				<tr>
					<th>${internationalConfig.排序}</th>
					<td><input name="seq" value="${resource.seq}" class="easyui-numberspinner" style="width: 140px; height: 29px;" required="required" data-options="editable:false"></td>
					<th>${internationalConfig.上级资源}</th>
					<td><select id="pid" name="pid" style="width: 140px; height: 29px;"></select><img src="/static/style/images/extjs_icons/cut_red.png"  align="middle" onclick="$('#pid').combotree('clear');"   /></td>
				</tr>
				<tr>
				<th>${internationalConfig.资源类型}</th>
					<td><select name="typeId" class="easyui-combobox" data-options="width:140,height:29,editable:false,panelHeight:'auto'">
							
								<option value="0" <c:if test="${0 == resource.typeId}">selected="selected"</c:if>>${internationalConfig.菜单}</option>
							<option value="1" <c:if test="${1 == resource.typeId}">selected="selected"</c:if>>${internationalConfig.功能}</option>
					</select></td>
				</tr>
				<tr>
					<th>${internationalConfig.菜单图标}</th>
					<td colspan="3"><input id="iconCls" name="iconCls" style="width: 375px; height: 29px;" data-options="editable:false" /></td>
				</tr>
				<tr>
					<th>${internationalConfig.备注}</th>
					<td colspan="3"><textarea name="remark" rows="" cols="" class="span5">${resource.remark}</textarea></td>
				</tr>
			</table>
		</form>
	</div>
</div>

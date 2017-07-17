<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');
        $('#form').form({
            url: '${pageContext.request.contextPath}/sportlive_dic/download_team.json',
            onSubmit: function () {
                parent.$.messager.progress({
                    title: '${internationalConfig.提示}',
                    text: '${internationalConfig.数据处理中}....'
                });
                var isValid = $(this).form('validate');
                if (!isValid) {
                    parent.$.messager.progress('close');
                }
                return isValid;
            },
            success: function (result) {
                parent.$.messager.progress('close');
                result = $.parseJSON(result);
                
                if (result.code == 0) {
                	parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.下载成功}', 'success');
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.下载失败}', 'error');
                }
            }
        });
    });
</script>
<div class="easyui-layout" data-options="fit:true,border:false" style="width: 800px; height: 600px">
    <div data-options="region:'center',border:true" title="" style="overflow: hidden;">
        <form id="form" method="post">
            <table class="table table-hover table-condensed" style="width: 100%; height: 100%">
                <tr>
                    <th>${internationalConfig.赛事ID}</th>
                    <td><input name="eventId" type="text" class="easyui-validatebox span2" data-options="required:true"></td>
                    <th>${internationalConfig.球队类型}</th>
                    <td><select name="type" style="margin-top: 5px">
								<c:forEach items="${sportTeamList}" var="sportTerm">
									<option value="${sportTerm.type}">${sportTerm.description}</option>
								</c:forEach>
						</select></td>
                </tr>
            </table>
        </form>
    </div>
</div>
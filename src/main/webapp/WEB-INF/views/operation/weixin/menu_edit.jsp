<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');
        $('#form').form({
            url: '/weixin/menu_edit.json',
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
            success: function (result) {
                parent.$.messager.progress('close');
                result = $.parseJSON(result);
                if (result.success) {
                	parent.$.messager.alert('${internationalConfig.成功}', result.msg, 'success');
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
                }
            }
        });
    });
</script>
<div class="easyui-layout" data-options="fit:true,border:false" style="width: 800px; height: 600px">
    <div data-options="region:'center',border:true" title="" style="overflow: hidden;">
        <form id="form" method="post">
        	<input name="id" type="hidden" value="${menu.id}" readonly="readonly" id="id">
            <table class="table table-hover table-condensed" style="width: 100%; height: 100%">
                <tr>
                    <th>${internationalConfig.菜单名称}</th>
                    <td><input name="name" type="text" value="${menu.name}"></td>
                    <th>${internationalConfig.菜单级别}</th>
                    <td>
                    <c:choose>
                        <c:when test="${menu.mlevel == 1}">
                            <input name="mlevel" type="radio" value="1" checked="checked"/>${internationalConfig.一级菜单}
                        </c:when>
                        <c:when test="${menu.mlevel == 2}">
                            <input name="mlevel" type="radio" value="2" checked="checked"/>${internationalConfig.二级菜单}
                        </c:when>
                   	</c:choose>
                    </td>
                </tr>
                <tr>
                	<th>${internationalConfig.菜单类型}</th>
                	<td>
		               	<c:choose>
		                       <c:when test="${menu.type == 1}">
		                           <input name="type" type="radio" value="1" checked="checked"/>click
		                           <input name="type" type="radio" value="2"/>view
		                       </c:when>
		                       <c:when test="${menu.type == 2}">
		                           <input name="type" type="radio" value="1"/>click
		                           <input name="type" type="radio" value="2" checked="checked"/>view
		                       </c:when>
		                       <c:otherwise>
		                           <input name="type" type="radio" value="1"/>click
		                           <input name="type" type="radio" value="2"/>view
		                       </c:otherwise>
		                  	</c:choose>
                   	</td>
                   	<th>${internationalConfig.菜单}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>KEY</th>
                   	<td><input name="key" type="text" value="${menu.key}"></td>
                </tr>
                <tr>
                	<th>${internationalConfig.菜单}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>URL</th>
                	<td><input name="url" type="text" value="${menu.url}"></td>
                   	<th>${internationalConfig.状态}</th>
                   	<td>
                   	<c:choose>
                        <c:when test="${menu.status == 0}">
                            <input name="status" type="radio" value="0" checked="checked"/>${internationalConfig.有效}
                            <input name="status" type="radio" value="1"/>${internationalConfig.失效}
                        </c:when>
                        <c:when test="${menu.status == 1}">
                            <input name="status" type="radio" value="0"/>${internationalConfig.有效}
                            <input name="status" type="radio" value="1" checked="checked"/>${internationalConfig.失效}
                        </c:when>
                        <c:otherwise>
                            <input name="status" type="radio" value="0"/>${internationalConfig.有效}
                            <input name="status" type="radio" value="1"/>${internationalConfig.失效}
                        </c:otherwise>
                   	</c:choose>
                   	</td>
                </tr>
                <tr>
                	<th>${internationalConfig.序列号}</th>
                	<td><input name="windex" type="text" value="${menu.windex}" class="easyui-validatebox" data-options="required:true"></td>
                   	<th></th>
                   	<td>
                   	</td>
                </tr>
                        <c:if test="${menu.mlevel == 1}">
                        	 <tr>
								<th>${internationalConfig.子菜单}</th>
								<td colspan="20">
									<table>
										<tr style="border-top:0px;">
											<c:forEach items="${childMenus}"
												var="childMenu">
												<td><c:choose>
														<c:when test="${fn:contains(selectedIds, childMenu.id)}">
															<input id="childMenu${childMenu.id}"
																type="checkbox" name="childMenus"
																checked="checked" value="${childMenu.id}" />${childMenu.name}
				                                           </c:when>
														<c:otherwise>
															<input id="childMenu${childMenu.id}"
																type="checkbox" name="childMenus"
																value="${childMenu.id}" />${childMenu.name}
				                                           </c:otherwise>
													</c:choose></td>
											</c:forEach>
										</tr>
									</table>
								</td>
							</tr>
                        </c:if>
            </table>
			
				<c:if test="${menu.mlevel == 2}">
				
					<div data-options="region:'center',border:true" title="">
						<label><b>${internationalConfig.图文资源}</b></label><c:forEach items="${resources}" var="resource">
							<td><c:choose>
									<c:when test="${fn:contains(selectedIds, resource.id)}">
										<input id="resource${resource.id}" type="checkbox"
											name="resources" checked="checked" value="${resource.id}" />${resource.title}
				                                           </c:when>
									<c:otherwise>
										<input id="childMenu${resource.id}" type="checkbox"
											name="resources" value="${resource.id}" />${resource.title}
				                                           </c:otherwise>
								</c:choose></td>
						</c:forEach>
					</div>
				</c:if>
		</form>
    </div>
</div>
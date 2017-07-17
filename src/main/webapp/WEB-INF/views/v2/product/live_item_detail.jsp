<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script src="/static/lib/swfupload/swfupload.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
    /*$(function() {
        parent.$.messager.progress('close');
        (function($){
            $.fn.serializeJson=function(){
                var serializeObj={};
                var array=this.serializeArray();
                $(array).each(function(){ // 遍历数组的每个元素 {name : xx , value : xxx}
                    if(serializeObj[this.name]){ // 判断对象中是否已经存在 name，如果存在name
                        serializeObj[this.name]+=","+this.value;
                    }else{
                        serializeObj[this.name]=this.value; // 如果元素name不存在，添加一个属性 name:value
                    }
                });
                return serializeObj;
            }
        })(jQuery)

    });*/
</script>

<style type="text/css">
    #form table tr th{
        vertical-align:middle;
        width:90px;
    }
    #form table tr td select{
        width:180px;
    }
</style>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="">
        <form id="form" method="post" name="matchForm" action="/v2/product/liveItem/save">
            <table style="width: 100%" class="table table-form">
                <tr>
                    <th>ID</th>
                    <td colspan="3"><input type="text" name="cid" readonly value="${param.cid}"/></td>
                </tr>
                <tr>
                    <th>${internationalConfig.频道名称}</th>
                    <td colspan="3"><input type="text" name="name" readonly value="${param.name}"/></td>
                </tr>
                <tr>
                    <th>${internationalConfig.内容特权}</th>
                    <td colspan="3">
                        <p>
                            <c:forEach items="${aggPackageList}" var="aggPackage">
                            <span style="display: inline-block">
                                	<c:set var="checked" value=""/>
			        		        <c:forEach items="${boundPackages}" var="boundPackage">
                                        <c:if test="${aggPackage.id==boundPackage.id}">
                                            <c:set var="checked" value='checked="checked"' />
                                        </c:if>
                                    </c:forEach>
                                    <input id="aggPackage_${aggPackage.id}" type="checkbox" name="packages" value="${aggPackage.id}" ${checked}> ${aggPackage.aggPackageName} &nbsp;&nbsp;
                                </span>
                            </c:forEach>
                        <p>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
<script>
    $(document).ready(function() {
        parent.$.messager.progress('close');

        $(function onSubmit() {
            $('#form').form({
                url : '/v2/product/liveItem/save',
                method: "POST",
                onSubmit : function() {
                    parent.$.messager.progress({
                        title : "${internationalConfig.提示}",
                        text : "${internationalConfig.数据处理中}"
                    });
                    return true;
                },
                success : function(result) {
                    parent.$.messager.progress('close');
                    result = $.parseJSON(result);
                    if (result.code == 0) {
                        parent.$.messager.alert("${internationalConfig.成功}", '${internationalConfig.编辑成功}', 'success');
                        parent.$.modalDialog.handler.dialog('close');
                        //parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                    } else {
                        parent.$.messager.alert("${internationalConfig.错误}", result.msg, 'error');
                    }
                },
                error: function(result){
                    parent.$.messager.progress('close');
                    parent.$.messager.alert("${internationalConfig.错误}", result, 'error');
                }
            });
        });
    });
</script>
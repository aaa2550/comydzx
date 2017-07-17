<%--
  Created by IntelliJ IDEA.
  User: kangxiongwei3
  Date: 2016/4/14
  Time: 15:22
  Desc: 用来将单个道具设置为免费
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/inc/jstl.inc" %>

<style type="text/css">
    .add_star {
        padding: 20px;
        width: 300px;
        overflow: hidden;
        margin: 0 auto;
        border: 1px solid #CCCCCC;
        background-color: #F2F2F2;
        color: #333333;
        padding: 20px;
    }

    .add_star table {
        width: 100%;
    }

    .add_star table tr {
        line-height: 30px;
    }

    .add_star table tr td {
        width: 30%;
    }

    .add_star table tr td.start_img img {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        vertical-align: middle;
    }
    .add_star dl dt {
        float: left;
        width: 50px;
        height: 50px;
        vertical-align: middle;
        padding: 10px;
    }

    .add_star dl dt img {
        width: 50px;
        height: 50px;
        border-radius: 50%;
    }

    .add_star dl dd {
        float: left;
        padding: 20px 0 0 10px;
    }
</style>

<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');

        $('#form').form({
            url: '${pageContext.request.contextPath}/props_live/single_update_free.do',
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
                    parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.操作成功}', 'success');
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
                }
            }
        });
    });

</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="" class="add_star">
        <form id="form" method="post" action="/props_live/single_update_free.do">
            <input type="hidden" name="liveId" value="${liveId}">
            <input type="hidden" name="type" value="${type}">
            <dl>
                <dt>
                    <img src="${config.web.pic}">
                </dt>
                <dd>
                    <input type="hidden" name="pid" value="${prop.id}"/>
                    ${prop.codeName}&nbsp;&nbsp;&nbsp;&nbsp;(${prop.id})
                </dd>
            </dl>
            <table>
                <tr>
                    <td colspan="2"><input name="freeCount" value="${propsLiveToy.freeCount}" class="easyui-numberbox" data-options="required:true"></td>
                    <td style="text-align: right">免费数量</td>
                </tr>
                <%--<tr>
                    <td><input name="startFreeTime" type="text" value="${propsLiveToy.startFreeTime}" class="easyui-datetimebox" data-options="required:true">
                    </td>
                    <td><input name="endFreeTime" type="text" value="${propsLiveToy.endFreeTime}" class="easyui-datetimebox" data-options="required:true">
                    </td>
                    <td style="text-align: right">免费时段</td>
                </tr>--%>
            </table>
        </form>
    </div>
</div>

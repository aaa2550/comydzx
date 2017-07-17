<%--
  Created by IntelliJ IDEA.
  User: kangxiongwei3
  Date: 2016/4/11
  Time: 19:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<script src="/static/lib/swfupload/swfupload.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" src="/static/lib/uploadImgCommon.js" charset="utf-8"></script>
<script type="text/javascript" src="/js/kv/propsBusiness.js" charset="utf-8"></script>
<script type="text/javascript" src="/js/kv/propsChannel.js"></script>
<%@ include file="/WEB-INF/views/inc/jstl.inc"%>

<style type="text/css">
    .table th {
        text-align: right;
    }
</style>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="">
        <form id="form" method="post" action="/props_live/props_live_add.do">
            <input type="hidden" name="refreshProp" value="${refreshProp}">
            <table style="width: 100%" class="table table-form">
                
                <tr>
                    <th><b style="color: red">*</b>直播ID：</th>
                    <td><input type="hidden" value="${propsLive.name}" name="name">
                        <input name="liveId" value="${propsLive.liveId}" class="span2, easyui-validatebox" data-options="required:true" style="width: 240px">&nbsp;&nbsp;
                        <input type="button" value="绑定" onclick="bindLive();" style="width: 80px; font-family: 'Microsoft YaHei'">&nbsp;&nbsp;
                        <b id="validateInfo" style="color: red; display: none"></b>
                    </td>
                </tr>
                <tr>
                    <th>直播时间：</th>
                    <td>
                        <input name="startTime" value="${propsLive.startTime}" class="span2" data-options="required:true" style="width: 160px" readonly>&nbsp;&nbsp;
                        <input name="endTime" value="${propsLive.endTime}" class="span2" data-options="required:true" style="width: 160px" readonly>
                    </td>
                </tr>
                <tr>
                    <th><b style="color: red">*</b>业务线：</th>
                    <td>
                      <%@ include file="/WEB-INF/views/inc/props_business.inc" %>
                        <%@ include file="/WEB-INF/views/inc/props_channel.inc" %>
                    </td>
                </tr>
                <tr>
                    <th>活动图片：</th>
                    <td>
                        <input type="text" name="pic" value="${propsLive.pic}" id="common_pic" class="span2"/>&nbsp;&nbsp;
                        <input type="button" value="上传" id="common_upload_btn"><br>
                    </td>
                </tr>
                <tr>
                    <th>描述：</th>
                    <td><textarea name="ext" placeholder="请输入0-200字符" style="width: 333px; height: 80px" onchange="this.value=this.value.substring(0, 200)"
                                  onkeydown="this.value=this.value.substring(0, 200);"
                                  onkeyup="this.value=this.value.substring(0, 200);">${propsLive.ext}</textarea></td>
                </tr>
            </table>
        </form>
    </div>
</div>
<script type="text/javascript">
$("select[name=businessId]").val('${propsLive.businessId}');
    $(function () {
        parent.$.messager.progress('close');

        init();

        disabledComponent();

        /**
         * 表单验证
         */
        $('#form').form({
            url: '${pageContext.request.contextPath}/props_live/props_live_add.do',
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

    function init() {
        //初始化业务线
        var businessId = $("select[name=businessId]");
        <c:if test="${props.businessId > 0}">
        businessId.val('${props.businessId}');
        </c:if>
        businessId.trigger("change");

        //初始化渠道
        var channelId = $("select[name=channelId]");
        <c:if test="${props.channelId > 0}">
        channelId.val('${props.channelId}');
        </c:if>
        channelId.trigger("change");
    }

    function disabledComponent() {
        if ('${propsLive.liveId}') {
            $("input[name='liveId']").attr("readonly", "readonly");
            $("#businessId").attr("readonly", "readonly");
            $("#businessId").attr("onfocus", "this.defaultIndex=this.selectedIndex");
            $("#businessId").attr("onchange", "this.selectedIndex=this.defaultIndex");
        }
    }

    /**
     * 验证道具名称是否可用
     */
    function bindLive(){
        var liveId = $("input[name='liveId']").val();
        if(liveId == "") {
            parent.$.messager.alert("提示","直播ID不能为空");
            return;
        }
        $.ajax({
            type: "POST",
            url: "/props_live/bind_live",
            data: {"liveId": liveId},
            dataType: 'json',
            success: function(json){
                //alert(JSON.stringify(json));
                if(json.code == 0){
                    var data = json.data;
                    $("input[name='startTime']").val(data.startTime);
                    $("input[name='endTime']").val(data.endTime);
                    $("input[name='name']").val(data.name);
                }
                else {
                    parent.$.messager.alert('${internationalConfig.错误}', json.data, 'error');
                }
            }
        });
    }

</script>

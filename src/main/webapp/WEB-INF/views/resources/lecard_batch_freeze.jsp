<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${internationalConfig.兑换码批量冻结服务}</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <style>
        .body_div {
            overflow: hidden;
            height: 300px;
            display:inline;
        }

        .row_desc {
            float: left;
            width: 200px;
            margin-left: 10px;
            margin-right: 10px;
            vertical-align: middle;
            display: inline-block;
            white-space: nowrap;
        }

        .row_input {
            float: left;
            margin-left: 10px;
        }

        .desc_text {
            margin: 10px;
            clear: both;
        }
        .button_out_div{
            width: 500px;
            text-align: center;
        }
        .button_inner_div {
            width: 50%;
            margin: 0 auto;
            text-align: left;
        }
        .button_span{
            margin-right: 5px;
        }

        input[type="button"]{
            width: 100px;
        }

    </style>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'${internationalConfig.兑换码批量冻结服务}',border:false"
         class="body_div">
        <form id="form" method="post" enctype="multipart/form-data">
            <div style="margin-top: 10px;">
                <div class="row_desc">${internationalConfig.批量上传兑换码}:</div>
                <div class="row_input"><input type="file" id="myFile" name="myFile" size="100" style="width:300px;"
                                              class="easyui-validatebox" data-options="required:true"></div>
            </div>
            <div class="desc_text">
                <p>${internationalConfig.说明_长文本}</p>
            </div>
            <div class="button_out_div">
                <div class="button_inner_div">
                    <span class="button_span"><input type="button" class="shortcut-item boss-btn" value="${internationalConfig.冻结}"
                                 onclick="submitForm()"></span>
                    <span class="button_span"><input type="button" class="shortcut-item boss-btn" value="${internationalConfig.取消}"
                                 onclick="resetForm()"></span>
                </div>
            </div>
        </form>
    </div>
</div>
<script>
    $('#form').submit(function (e) {
        if (!$('#form').form('validate'))
            return false;
        parent.$.messager.progress({
            title: '${internationalConfig.提示}',
            text: '${internationalConfig.数据处理中}'
        });
        $.ajax({
            url: '/lecard/lecard_batch_freeze.do',
            type: 'POST',
            data: new FormData(this),
            processData: false,
            contentType: false,
            success: function (response) {
                resetForm();
                parent.$.messager.progress('close');
                var result = $.parseJSON(response);
                var msg = result.code == 0 ? $.formatString('${internationalConfig.成功冻结兑换码条}',result.data) : result.msg;
                if (result.code == 0)
                    parent.$.messager.alert('${internationalConfig.成功}', msg, 'success');
                else
                    parent.$.messager.alert('${internationalConfig.错误}', msg, 'error');
            },
            error: function (e) {
                parent.$.messager.progress('close');
                parent.$.messager.alert('${internationalConfig.错误}', e, 'error');
            }
        });
        e.preventDefault();
    });
    function submitForm() {
        $('#form').submit();
    }
    function resetForm() {
        $("#myFile").val("");
    }
</script>
</body>
</html>
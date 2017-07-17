<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>指定用户到期</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">
        $(function () {
            parent.$.messager.progress('close');
        });

        function submit_form() {
            //判断是否上传uuid文件
            var file_name = $("input[name=file]").val();

            if (file_name == "") {
                parent.$.messager.alert('错误', "请上传UID文件", 'error');
                return;
            }

            $("#form").submit();

            $("#btn1").attr("disabled", "true");
            $("#btn1").attr("value", "请求已提交,请稍等");
        }


        function setBtnStatus() {
            $("#btn1").removeAttr("disabled");
            $("#btn1").attr("value", "导出Excel");
        }
    </script>
</head>

<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false"
         style="height:1000px;overflow:auto;">
        <!-- 上传文件并导出Excel -->
        <form id="form" action="${pageContext.request.contextPath}/vipController/exportZjVipInfoExcel" method="post" enctype="multipart/form-data">
            <table class="table table-hover table-condensed">
                <tr>
                    <td>选择UID文件</td>
                    <td>导出明细</td>
                </tr>
                <tr>
                    <td>
                        <input style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;"
                               onchange="setBtnStatus()" type="file" name="file"><br>
                    </td>
                    <td>
                        <select name="vipType" style="width: 140px" id="viptype" onchange="setBtnStatus()">
                            <option value="0">全部</option>
                            <option value="1">移动影视会员</option>
                            <option value="9">全屏影视会员</option>
                        </select>
                    </td>
                    <td>
                        <input style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;"
                               type="button" id="btn1" onclick="submit_form()" value="导出Excel">
                    </td>
                </tr>
            </table>
        </form>
        <div id="message" style="padding-left:5px;">
            <p><span>说明：</span></p>

            <p><span>1、UID可批量导入，且是txt文件，每个uid为一行，每次导入的uid个数不超过50,000个。</span></p>

            <p><span>2、服务到期时间：定向uid的最后一个有效订单的到期时间为该uid的服务到期时间。</span></p>

            <p><span>3、导出的明细是定向uid的最后一个有效订单的详细信息</span></p>

            <p><span>&nbsp;</span></p>

            <p><span>特别说明：</span></p>

            <p><span>1、明细中的订单种类包含：单点，直播单点，全屏影视会员，移动影视会员</span></p>

            <p><span>2、订单类型即ordertype：包月，包季等</span></p>

            <p><span>3、明细展示时除金额，时间外，其余展示的皆为中文，不是直接的参数</span></p>

            <p><span>4、导出的订单明细是该uid下的最后一个支付成功的订单的详细信息</span></p>

            <p><span><font color="red"><b>5、点击导出后，按钮会置为不可用状态，只有上传的UID文件名发生变化时，导出按钮才能变为可用</b></font></span></p>
        </div>
    </div>
</div>

</body>
</html>
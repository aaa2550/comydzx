<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>指定用户订单明细</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script src="${pageContext.request.contextPath}/js/highcharts/highcharts.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/highcharts/exporting.js" type="text/javascript"></script>
    <script type="text/javascript">
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }
        $(function () {
            parent.$.messager.progress('close');
        });

        $.extend($.fn.validatebox.defaults.rules, {
            TimeCheck: {
                validator: function () {
                    var s = $("input[name=beginDate]").val();
                    var s1 = $("input[name=endDate]").val();
                    return Math.abs(((new Date(Date.parse(s1)) - new Date(Date.parse(s))) / 1000 / 60 / 60 / 24)) - 15 < 0;
                },
                message: '非法数据'
            }
        });

        function submit_form() {
            //判断是否上传uuid文件
            var file_name = $("input[name=file]").val();

            if (file_name == "") {
                parent.$.messager.alert('错误', "请上传UID文件", 'error');
                return;
            }

            //判断日期时间是否正确
            var s = $("input[name=beginDate]").val();
            var s1 = $("input[name=endDate]").val();
            if (s == "") {
                parent.$.messager.alert('错误', "开始时间不能为空", 'error');
                return;
            }
            if (s1 == "") {
                parent.$.messager.alert('错误', "结束时间不能为空", 'error');
                return;
            }
            if (Math.abs(((new Date(Date.parse(s1)) - new Date(Date.parse(s))) / 1000 / 60 / 60 / 24)) - 31 > 0) {
                parent.$.messager.alert('错误', "日期时间段不能超过31天", 'error');
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
    <style>
        .span {
            padding: 10px;
        }
    </style>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false"
         style="height: 1000px; overflow: auto;">
        <form action="${pageContext.request.contextPath}/vipController/exportDxVipInfoExcel" id="form" method="post"
              enctype="multipart/form-data">
            <table class="table table-hover table-condensed">
                <tr>
                    <td>选择UID文件</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>订单状态</td>
                    <td>会员类型</td>
                    <td>支付方式</td>
                    <td>导出明细</td>
                </tr>
                <tr>
                    <td>
                        <input style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;"
                               onchange="setBtnStatus()" type="file" name="file">
                    </td>
                    <td>
                        <input name="beginDate" id="begin" validType="TimeCheck" invalidMessage="查询时间范围是15天!"
                               class="easyui-datebox" value="${start}" style="width: 140px; height: 29px"/>
                    </td>
                    <td>
                        <input name="endDate" id="end" validType="TimeCheck" invalidMessage="查询时间范围是15天!"
                               class="easyui-datebox" value="${end}" style="width: 140px; height: 29px">
                    </td>
                    <td>
                        <select name="status" style="width: 140px" id="status" onchange="setBtnStatus()">
                            <option value="1" selected="selected">已支付</option>
                            <option value="0">未支付</option>
                        </select>
                    </td>
                    <td>
                        <select name="vipType" style="width: 140px" id="viptype" onchange="setBtnStatus()">
                            <option value="">全部</option>
                            <option value="1">移动影视会员</option>
                            <option value="9">全屏影视会员</option>
                            <option value="-1">点播</option>
                        </select>
                    </td>
                    <td><select name="paytype" style="width: 140px" id="paytype" onchange="setBtnStatus()">
                        <option value="-2">全部</option>
                        <option value="2" selected>现金</option>
                        <option value="1">乐点</option>
                        <option value="0">兑换码</option>
                        <option value="-1">免费</option>
                        <option value="3">机卡绑定</option>
                    </select></td>
                    <td>
                        <input style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;" type="button"
                               id="btn1" onclick="submit_form()" value="导出Excel">
                    </td>
                </tr>
            </table>
        </form>
        <div id="message" style="padding-left:5px;">
            <p><span>说明：</span></p>

            <p><span>1、UID可批量导入，且是txt文件，每个uid为一行，每次导入的uid个数不超过50,000个。</span></p>

            <p><span>2、时间是支付时间的查询条件，每次时间范围最大为31天。</span></p>

            <p><span>3、订单状态包含：已支付，未支付</span></p>

            <p><span>&nbsp;</span></p>

            <p><span>特别说明：</span></p>

            <p><span>1、明细中的订单种类包含：单点，直播单点，全屏影视会员，移动影视会员</span></p>

            <p><span>2、订单类型即ordertype：包月，包季等</span></p>

            <p><span>3、明细展示时除金额，时间外，其余展示的皆为中文，不是直接的参数</span></p>

            <p><span><font color="red"><b>5、点击导出后，按钮会置为不可用状态，只有上传的UID文件名或订单状态发生变化时，导出按钮才能变为可用</b></font></span></p>
        </div>
    </div>
</div>
</body>
</html>
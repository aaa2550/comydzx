<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>订单明细查询</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">
        function exportExcel() {
            var begin = $('#begin').combobox('getValue');
            var end = $('#end').combobox('getValue');
            var terminal = $("#terminal").val();
            var status = $("#status").val();
            var viptype = $("#viptype").val();
            var paytype = $("#paytype").val();
            var url = '${pageContext.request.contextPath}/vipController/exportZdyComsumeExcel?createtime=' + begin
                    + '&canceltime=' + end + '&terminal=' + terminal + '&viptype=' + viptype + '&paytype=' + paytype;
            if (begin == "") {
                parent.$.messager.alert('错误', "开始时间不能为空", 'error');
                return;
            }

            if (end == "") {
                parent.$.messager.alert('错误', "结束时间不能为空", 'error');
                return;
            }

            if (Math.abs(((new Date(Date.parse(end)) - new Date(Date.parse(begin))) / 1000 / 60 / 60 / 24)) - 15 > 0) {
                parent.$.messager.alert('错误', "查询时间范围是15天!!!", 'error');
                return;
            }

            location.href = url;

            $("#btn1").attr("disabled", "true");
            $("#btn1").attr("value", "请求已提交,请稍等");

        }

        function setBtnStatus() {
            $("#btn1").removeAttr("disabled");
            $("#btn1").attr("value", "导出Excel");
        }
        $(function () {
            parent.$.messager.progress('close');
        });
    </script>
    <script>
        $.extend($.fn.validatebox.defaults.rules, {
            TimeCheck: {
                validator: function () {
                    var s = $("input[name=createtime]").val();
                    var s1 = $("input[name=canceltime]").val();
                    return Math.abs(((new Date(Date.parse(s1)) - new Date(Date.parse(s))) / 1000 / 60 / 60 / 24)) - 15 < 0;
                },
                message: '非法数据'
            }
        });
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false"
         style="height: 1000px; overflow: auto;">
        <form id="searchForm">
            <table class="table table-hover table-condensed">
                <tr>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>终端</td>
                    <td>会员类型</td>
                    <td>付费类型</td>
                    <td>导出明细</td>
                </tr>
                <tr>
                    <td><input id="begin" name="createtime" value="${startDate}" validType="TimeCheck"
                               invalidMessage="查询时间范围是15天!"
                               class="easyui-datebox" style="width: 140px; height: 29px"/></td>
                    <td><input id="end" name="canceltime" value="${endDate}" validType="TimeCheck"
                               invalidMessage="查询时间范围是15天!"
                               class="easyui-datebox" style="width: 140px; height: 29px"/></td>
                    <td><select name="terminal" style="width: 140px" id="terminal" onchange="setBtnStatus()">
                        <%--<option value="-2">全部</option>
                        <option value="112">pc</option>
                        <option value="130">mobile</option>
                        <option value="111">tv</option>
                        <option value="113">M站</option>
                        <option value="120">超级手机</option>--%>
                        <option value="-2">全部</option>
                        <c:forEach items="${terminals}" var="t">
                            <option value="${t.terminalId}">${t.terminalName}</option>
                        </c:forEach>
                    </select></td>
                    <%--<td><select name="status" style="width: 140px" id="status" onchange="setBtnStatus()">
                        <option value="1">已支付</option>
                        <option value="0">未支付</option>
                    </select></td>--%>
                    <td><select name="viptype" style="width: 140px" id="viptype" onchange="setBtnStatus()">
                        <option value="-2">全部</option>
                        <option value="1">乐次元影视会员</option>
                        <option value="9">超级影视会员</option>
                        <%--<option value="-1">点播</option>--%>
                    </select></td>
                    <td><select name="paytype" style="width: 140px" id="paytype" onchange="setBtnStatus()">
                        <option value="-2">全部</option>
                        <option value="2" selected>现金</option>
                        <option value="1">乐点</option>
                        <option value="0">兑换码</option>
                        <option value="-1">免费</option>
                        <option value="3">机卡绑定</option>
                    </select></td>
                    <td><input id="btn1" type="button" onclick="exportExcel();" value="导出excel"/></td>
                </tr>
            </table>
        </form>
        <div id="message" style="padding-left:5px;">
            <p><span>说明：</span></p>

            <p><span>1、查询时间为支付时间。</span></p>

            <p><span>2、时间是支付时间的查询条件，每次时间范围最大为15天。</span></p>

            <p><span>3、订单状态包含：已支付；未支付，默认已支付。</span></p>

            <p><span>4、支付方式选项中去除了全部的选项，因为考虑到活动时的赠送的免费订单较多，会影响数据的导出，所以支付方式不支持全部，默认现金。</span></p>

            <p><span>&nbsp;</span></p>

            <p><span>特别说明：</span></p>

            <p><span>1、明细中的订单种类包含：单点，直播单点，全屏影视会员，移动影视会员</span></p>

            <p><span>2、订单类型即ordertype：包月，包季等</span></p>

            <p><span>3、明细展示时除金额，时间外，其余展示的皆为中文，不是直接的参数</span></p>

            <p><span><font color="red"><b>4、点击导出后，按钮会置为不可用状态，只有除日期选择外的其他查询状态发生变化时，导出按钮才能变为可用</b></font></span></p>
        </div>
    </div>
</div>
</body>
</html>
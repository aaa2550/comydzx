<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>集团订单明细导出</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>

    <script type="text/javascript">
        /**
         * 待绑定行数据
         */
        var rows;
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }

        function loadCompanyName() {
            setBtnStatus();

            var systemSelect = $("#systemType");
            var systemType = systemSelect.val();
            var companySelect = $("#companyId");

            $.getJSON("${pageContext.request.contextPath}/tj/jtStatController/queryCompanyName", {systemType: systemType}, function (modules) {
                var options = "";
                modules = modules['rows'];
                var size = modules.length;
                if (size > 0) {
                    options += "<option value=-2>全部</option>";
                    for (var i = 0; i < size; i++) {
                        var module = modules[i];
                        options += "<option value=" + module['ID'] + ">" + module['NAME'] + "</option>";
                    }
                    companySelect.html(options);
                } else {
                    companySelect.html(options);

                }
            });
        }

        function exportExcel() {
            var begin = $('#begin').combobox('getValue');
            var end = $('#end').combobox('getValue');
            var companyid = $("#companyId").val();
            var systemType = $("#systemType").val();
            var url = '${pageContext.request.contextPath}/tj/jtStatController/groupPayOrderExcel?startTime='
                    + begin
                    + '&endTime='
                    + end
                    + '&companyid='
                    + companyid
                    + '&systemType='
                    + systemType;

            if (begin == "") {
                parent.$.messager.alert('错误', "开始时间不能为空", 'error');
                return;
            }

            if (end == "") {
                parent.$.messager.alert('错误', "结束时间不能为空", 'error');
                return;
            }

            if (Math.abs(((new Date(Date.parse(end)) - new Date(Date.parse(begin))) / 1000 / 60 / 60 / 24)) - 31 > 0) {
                parent.$.messager.alert('错误', "查询时间范围是31天!!!", 'error');
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
                    var s = $("input[name=startTime]").val();
                    var s1 = $("input[name=endTime]").val();
                    return Math.abs(((new Date(Date.parse(s1)) - new Date(Date.parse(s))) / 1000 / 60 / 60 / 24)) - 31 < 0;
                },
                message: '非法数据'
            }
        });

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
        <form id="searchForm">
            <table class="table table-hover table-condensed">
                <tr>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>支付系统</td>
                    <td>商户名称</td>
                    <td></td>
                </tr>
                <tr>
                    <td><input id="begin" name="startTime" value="${startTime}" validType="TimeCheck" invalidMessage="查询时间范围是15天!" class="easyui-datebox" style="width: 140px; height: 29px"></td>
                    <td><input id="end" name="endTime" value="${endTime}" validType="TimeCheck" invalidMessage="查询时间范围是15天!" class="easyui-datebox" style="width: 140px; height: 29px"></td>
                    <td>
                        <select name="systemType" id="systemType" style="width: 160px" id="one" onchange="loadCompanyName()">
                            <option value="1">旧支付系统</option>
                            <option value="2">新支付系统</option>
                            <option value="3">boss新支付系统</option>
                        </select>
                    </td>
                    <td><select name="companyId" style="width: 140px"
                                id="companyId" onchange="setBtnStatus()">
                        <option value="-2" selected>全部</option>
                        <c:forEach items="${companyNameList}" var="company">
                            <option value='${company.ID}'>${company.NAME}</option>
                        </c:forEach>
                    </select></td>
                    <td><input id="btn1" type="button" onclick="exportExcel();" value="导出excel"/></td>
                </tr>
            </table>
        </form>
        <div id="message" style="padding-left:5px;">
            <p><span>说明：</span></p>

            <p><span>1、查询时间为支付时间。</span></p>

            <p><span>2、时间是支付时间的查询条件，每次时间范围最大为31天。</span></p>

            <p><span><font color="red"><b>3、点击导出后，按钮会置为不可用状态，只有除日期外查询状态发生变化时，导出按钮才能变为可用</b></font></span></p>
        </div>
    </div>

    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>


</div>

</body>
</html>
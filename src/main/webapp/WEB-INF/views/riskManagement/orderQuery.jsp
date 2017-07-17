<%--
  Created by IntelliJ IDEA.
  User: hujunfei
  Date: 2016/6/23
  Time: 16:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>订单查询</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">
        var dataGrid;

        $(function () {

            initName();

            dataGrid = $('#dataGrid').bossDataGrid({
                url: '${pageContext.request.contextPath}/tj/riskManagement/orderQueryData',
                sortName: "paymentDate",
                queryParams: {
                    beginDate: $("#beginDate").val(),
                    endDate: $("#endDate").val()
                },
                columns: [
                    {
                        field: 'paymentDate',
                        title: '支付时间',
                        width: 70,
                        sortable: true
                    },
                    {
                        field: 'serialNumber',
                        title: '支付流水号',
                        width: 120
                    },
                    {
                        field: 'payment',
                        title: '支付金额',
                        width: 35
                    },
                    {
                        field: 'userID',
                        title: '用户ID',
                        width: 50
                    },
                    {
                        field: 'bankCardNumber',
                        title: '银行卡号',
                        width: 100
                    },
                    {
                        field: 'payIP',
                        title: '支付IP',
                        width: 55
                    },
                    {
                        field: 'phoneNumber',
                        title: '支付手机号',
                        width: 70
                    },
                    {
                        field: 'spareOrderNumber',
                        title: '备用订单号',
                        width: 90
                    },
                    {
                        field: 'terminal',
                        title: '支付终端',
                        width: 90
                    }
                ]
            });
        });

        function searchFun() {
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }

        function cleanFun() {
            $('#searchForm input').val('');
            $("#payStatus").val(0);
            $("#attributeType").val(0);
            $("#companyName").val(0);
            $("#businessName").val(0);
            $("#payChannel").val(0);
        }

        function exportExcel() {
            var beginDate = $("#beginDate").combobox("getValue");
            var endDate = $("#endDate").combobox("getValue");
            var payStatus = $("#payStatus").val();
            var attributeType = $("#attributeType").val();
            var attributeNumber = $("#attributeNumber").val();
            var url = "${pageContext.request.contextPath}/tj/riskManagement/exportOrderQueryExcel?beginDate=" + beginDate + "&endDate=" + endDate + "&payStatus=" + payStatus + "&attributeType=" + attributeType + "&attributeNumber=" + attributeNumber;
            location.href = url;
        }

        function selectBusiness(data) {
            var option2 = "<option value='0'>全部</option>";
            var selectedIndex = $("#companyName :selected").val();
            $("#businessName").empty();
            $.each(data, function (index, items) {
                if (items.companyId != selectedIndex) {
                    return;
                }
                $.each(items.businessList, function (index, items) {
                    option2 += "<option value='" + items.businessId + "'>" + items.businessName + "</option>";
                })
            });
            $("#businessName").append(option2);
        }

        function initName() {
            var option1 = '';
            $.getJSON("${pageContext.request.contextPath}/tj/riskManagement/orderCompanyName", function (jsonData) {
                $.each(jsonData.data, function (index, indexItems) {
                    option1 += "<option value='" + indexItems.companyId + "'>" + indexItems.companyName + "</option>";
                });
                $("#companyName").append(option1);
                $("#companyName").bind("change", function () {
                    selectBusiness(jsonData.data);
                })
            })
        }


    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false" style="height: 160px; overflow: hidden;">
        <form id="searchForm">
            <table class="table table-hover table-condensed">
                <tr style="border: hidden">
                    <th>开始日期:</th>
                    <th>截至日期:</th>
                    <th>公司名称:</th>
                    <th>业务线:</th>
                    <th>支付渠道:</th>
                    <th>支付状态:</th>
                </tr>
                <tr style="border: hidden">
                    <td><input id="beginDate" name="beginDate" class="easyui-datebox" value="${startDate}"></td>
                    <td><input id="endDate" name="endDate" class="easyui-datebox" value="${endDate}"></td>
                    <td>
                        <select id="companyName" name="companyName">
                            <option value="0">全部</option>
                        </select>
                    </td>
                    <td>
                        <select id="businessName" name="businessName">
                            <option value="0">全部</option>
                        </select>
                    </td>
                    <td>
                        <select id="payChannel" name="payChannel">
                            <option value="0">全部</option>
                            <c:forEach items="${payChannel}" var="channel">
                                <option value="${channel.key}">${channel.value}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <select name="payStatus" id="payStatus">
                            <option value="0">全部</option>
                            <option value="1">支付成功</option>
                            <option value="2">支付失败</option>
                        </select>
                    </td>
                </tr>
                <tr style="border: hidden">
                    <th>查询属性</th>
                    <td>
                        <select name="attributeType" id="attributeType">
                            <option value="0">全部</option>
                            <option value="1">支付流水号</option>
                            <option value="2">用户ID</option>
                            <option value="3">银行卡号</option>
                            <option value="4">支付手机号</option>
                            <option value="5">支付IP</option>
                        </select>
                    </td>
                    <td colspan="4">
                        <input name="attributeNumber" style="width: 900px" id="attributeNumber" class="easyui-validatebox" placeholder="可批量查询,逗号分隔"/>
                    </td>
                    <th>
                </tr>
            </table>
        </form>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>
<div id="toolbar" style="display: none;">
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true"
       onclick="searchFun();">查询</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true"
       onclick="cleanFun();">清空条件</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true"
       onclick="exportExcel();">导出excel</a>
</div>
</body>
</html>

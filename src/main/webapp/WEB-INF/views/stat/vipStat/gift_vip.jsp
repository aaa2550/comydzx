<%--
  Created by IntelliJ IDEA.
  User: hujunfei
  Date: 2016/8/8
  Time: 17:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>赠送会员统计</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">

        var dataGrid;

        $(function () {
                    dataGrid = $('#dataGrid').bossDataGrid({
                        url: '${pageContext.request.contextPath}/vipController/gift_data',
                        sortName: 'paymentDate',
                        sortOrder: 'desc',
                        queryParams: {
                            beginDate: $("#beginDate").val(),
                            endDate: $("#endDate").val(),
                            company: $("#companyName").val(),
                            product: $("#productName").val()
                        },
                        columns: [
                            {
                                field: 'paymentDate',
                                title: '支付时间',
                                width: 70,
                                sortable: true
                            },
                            {
                                field: 'productName',
                                title: '产品名称',
                                width: 70
                            },
                            {
                                field: 'numbers',
                                title: '数量',
                                width: 70
                            },
                            {
                                field: 'income',
                                title: '收入金额',
                                width: 70
                            }
                        ]
                    });
                }
        );

        function cleanFun() {
            $('#searchForm').find('input').val('');
            $("#searchForm").find("option:selected").removeAttr("selected");
        }

        function searchFun() {
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }

        function exportGift() {
            var params = $('#searchForm').serialize();
            var url = "${pageContext.request.contextPath}/vipController/export_gift?";
            window.location.href = url + params
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit:true, border:false">
    <div data-options="region:'north',title:'查询条件',border:false" style="height: 120px; overflow: hidden;">
        <form id="searchForm">
            <table class="table table-hover table-condensed">
                <tr>
                    <th>开始时间</th>
                    <th>结束时间</th>
                    <th>公司名称</th>
                    <th>产品名称</th>
                    <th>支付状态</th>
                </tr>
                <tr>
                    <td><input id="beginDate" name="beginDate" class="easyui-datebox" value="${startDate}"></td>
                    <td><input id="endDate" name="endDate" class="easyui-datebox" value="${endDate}"></td>
                    <td>
                        <select name="company" id="company" class="easyui-combobox" style="width: 150px">
                            <option value="0">全部</option>
                            <c:forEach items="${companyMap}" var="company">
                                <option value="${company.key}">${company.value}[${company.key}]</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <select name="product" id="product" class="easyui-combobox" style="width: 150px">
                            <option value="0">全部</option>
                            <c:forEach items="${vipType}" var="vip">
                                <option value="${vip.key}">${vip.value}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <select name="status" class="easyui-combobox" style="width: 150px">
                            <option value="-1" selected>全部</option>
                            <option value="1">支付成功</option>
                            <option value="2">通知失败</option>
                            <option value="3">退款成功</option>
                        </select>
                    </td>
                </tr>
            </table>
        </form>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>
<div id="toolbar" style="display: none;">
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_search',plain:true" onclick="searchFun();">查询</a>

    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">清空条件</a>

    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_go',plain:true" onclick="exportGift();">导出</a>
</div>
</body>
</html>

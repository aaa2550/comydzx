<%--
  Created by IntelliJ IDEA.
  User: kangxiongwei3
  Date: 2016/12/5
  Time: 13:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>会员订单查询</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            parent.$.messager.progress('close');
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/vip2/data_grid');

            //级联会员类型
            $("#productType").combobox({
                onChange: function (productType, oldProductType) {
                    if (productType != 100) {
                        $("#productSubtype").combobox("clear").combobox("loadData", {});
                    } else {
                        $('#productSubtype').combobox({
                            url: "${pageContext.request.contextPath}/tj/v2order/orderBase/productSubtype?productType=" + productType,
                            valueField: 'category',
                            textField: 'name'
                        });
                    }
                }
            });

        });

        function renderDataGrid(url) {
            return $('#dataGrid').bossDataGrid({
                url: url,
                sortName: 'orderDate',
                sortOrder: 'desc',
                queryParams: {
                    startDate: $("input[name='startDate']").val(),
                    endDate: $("input[name='endDate']").val()
                },
                columns: [
                    {
                        field: 'orderDate',
                        title: '统计日期',
                        width: 100
                    },
                    {
                        field: 'orderCount',
                        title: '支付成功订单数',
                        width: 100
                    }, {
                        field: 'payPrice',
                        title: '会员支付金额',
                        width: 100
                    },
                    {
                        field: 'price',
                        title: '现金支付金额',
                        width: 100
                    },
                    {
                        field: 'virtualPrice',
                        title: '虚拟币支付金额',
                        width: 100
                    }
                ]
            });
        }

        function searchFun() {
            var startDate = $("input[name='startDate']").val();
            var endDate = $("input[name='endDate']").val();
            if (startDate == null || startDate == '' || endDate == null || endDate == '') {
                parent.$.messager.alert("提示", "查询条件开始时间和结束时间不能为空");
            } else {
                dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
            }
        }
        function cleanFun() {
            var ele = $("#searchForm");
            ele.find("select option:selected").removeAttr("selected");
            dataGrid.datagrid('load', {});
        }
        function exportFile() {
            var params = $("#searchForm").serialize();
            var url = '${pageContext.request.contextPath}/tj/vip2/export_mix?' + params;
            location.href = url;
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false" style="height: 120px; overflow: auto;">
        <form id="searchForm" method="post">
            <table class="table table-hover table-condensed">
                <tr>
                    <th>开始时间</th>
                    <th>结束时间</th>
                    <th>产品类型</th>
                    <th>会员类型</th>
                    <th>支付方式</th>
                    <th>终端</th>
                </tr>
                <tr>
                    <td>
                        <input name="startDate" class="easyui-datebox" value="${startDate}"/>
                    </td>
                    <td>
                        <input name="endDate" class="easyui-datebox" value="${endDate}"/>
                    </td>
                    <td>
                        <select id="productType" name="productType" class="easyui-combobox" style="width: 150px">
                            <option value="">全部</option>
                            <c:forEach var="product" items="${productTypes}">
                                <option value="${product.key}">[${product.key}]${product.value}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <select id="productSubtype" name="productSubtype" class="easyui-combobox" style="width: 150px">
                            <option value="">全部</option>
                        </select>
                    </td>
                    <td>
                        <select id="payChannel" name="payChannel" class="easyui-combobox" style="width: 150px">
                            <option value="">全部</option>
                            <c:forEach items="${payChannels}" var="channel">
                                <option value="${channel.key}">${channel.value}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <select name="terminal" class="easyui-combobox" style="width: 150px">
                            <option value="">全部</option>
                            <c:forEach var="terminal" items="${terminals}">
                                <option value="${terminal.terminalId}">${terminal.terminalName}</option>
                            </c:forEach>
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
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_go',plain:true" onclick="exportFile();">导出明细</a>
</div>
</body>
</html>

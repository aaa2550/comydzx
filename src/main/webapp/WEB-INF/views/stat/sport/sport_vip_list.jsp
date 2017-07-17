<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>体育订单统计</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            parent.$.messager.progress('close');
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/sport/vip/dataGrid');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').bossDataGrid({
                url: url,
                sortName: 'dt',
                sortOrder: 'desc',
                columns: [
                    {
                        field: 'dt',
                        title: '日期',
                        width: 100
                    },
                    {
                        field: 'orderNum',
                        title: '订单',
                        width: 100
                    }, {
                        field: 'orderSuccNum',
                        title: '成功订单',
                        width: 100
                    },
                    {
                        field: 'newOrderRate',
                        title: '新增订单占比',
                        width: 100
                    },
                    {
                        field: 'income',
                        title: '收入',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'monthOrder',
                        title: '包月订单',
                        width: 100
                    },
                    {
                        field: 'quarterOrder',
                        title: '包季订单',
                        width: 100
                    },
                    {
                        field: 'yearOrder',
                        title: '包年订单',
                        width: 100
                    },
                    {
                        field: 'allUser',
                        title: '总用户数',
                        width: 100
                    },
                    {
                        field: 'newUser',
                        title: '新增用户数',
                        width: 100
                    },
                    {
                        field: 'renewUser',
                        title: '续费用户数',
                        width: 100
                    }
                ]
            });
        }

        function searchFun() {
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }
        function exportFile() {
            var startDate = $('#begin').datetimebox("getValue");
            var endDate = $('#end').datetimebox("getValue");
            var terminal = $('#terminal').val();
            var paychannel = $('#paychannel').val();
            var paytype = $('#paytype').val();
            var url = '${pageContext.request.contextPath}/tj/sport/vip/export?terminal=' + terminal + '&sdate=' + startDate + '&edate=' + endDate + '&paychannel=' + paychannel + '&paytype=' + paytype;
            location.href = url;
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false"
         style="height: 120px; overflow: auto;">
        <form id="searchForm">
            <table class="table table-hover table-condensed">
                <tr>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>支付方式</td>
                    <td>支付渠道</td>
                    <td>终端</td>
                </tr>
                <tr>
                    <td>
                        <input name="sdate" id="begin" class="easyui-datebox" validType="TimeCheck" data-options="required:true" value="${sdate}"
                               style="width: 160px; height: 29px"/>
                    </td>

                    <td>
                        <input name="edate" id="end" class="easyui-datebox" validType="TimeCheck" data-options="required:true" value="${edate}"
                               style="width: 160px; height: 29px"/>
                    </td>

                    <td>
                        <select name="paytype" id="paytype" style="width:140px">
                            <option value="-2">全部</option>
                            <option value="-1">免费</option>
                            <option value="0">兑换码</option>
                            <option value="1">乐点</option>
                            <option value="2" selected>现金</option>
                            <option value="3">机卡绑定</option>
                        </select>
                    </td>

                    <td>
                        <select name="paychannel" style="width: 160px" id="paychannel">
                            <option value="-2" selected="selected">全部</option>
                            <c:forEach var="channel" items="${paychannels}">
                                <option value="${channel.type}">${channel.description}</option>
                            </c:forEach>
                        </select>
                    </td>

                    <td>
                        <select name="terminal" style="width: 160px" id="terminal">
                            <option value="-2">全部</option>
                            <c:forEach var="terminal" items="${terminals}">
                                <option value="${terminal.key}">${terminal.value}</option>
                            </c:forEach>
                            <option value="-1">其他</option>
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
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="exportFile();">导出数据</a>
</div>
</body>
</html>
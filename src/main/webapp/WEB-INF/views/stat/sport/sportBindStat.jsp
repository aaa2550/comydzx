<%--
  Created by IntelliJ IDEA.
  User: lianghaitao
  Date: 2016/7/18
  Time: 18:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>体育会员机卡绑定统计</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <style type="text/css">
        th {
            padding-left: 40px;
        }

        td {
            padding-left: 10px;
        }

        select {
            width: 150px;
            height: 20px;
        }
    </style>
    <script type="text/javascript">
        /**
         * 待绑定行数据
         */
        var rows;

        var dataGrid;
        $(function () {
            parent.$.messager.progress('close');

            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/sport/device_bind_grid');
        });
        function renderDataGrid(url) {
            return $('#dataGrid').bossDataGrid({
                url: url,
                idField: 'date',
                sortName: 'date',
                sortOrder: 'desc',
                queryParams: {
                    sdate: $("#sdate").val(),
                    edate: $("#edate").val()
                },
                columns: [
                    {
                        field: 'date',
                        title: '日期',
                        width: 130,
                        sortable: true
                    },
                    {
                        field: 'allBound',
                        title: '总机卡绑定订单',
                        width: 130,
                        sortable: true
                    },
                    {
                        field: 'tvBound',
                        title: 'tv机卡绑定订单',
                        width: 130,
                        sortable: true
                    },
                    {
                        field: 'mBound',
                        title: '移动机卡绑定订单',
                        width: 130,
                        sortable: true
                    },
                    {
                        field: 'allUnbound',
                        title: '非机卡绑定订单',
                        width: 130,
                        sortable: true
                    },
                    {
                        field: 'lemallUnbound',
                        title: '商城非机卡绑定订单',
                        width: 130,
                        sortable: true
                    },
                    {
                        field: 'otherUnbound',
                        title: '其他非机卡绑定',
                        width: 130,
                        sortable: true
                    },
                    {
                        field: 'unBoundIncome',
                        title: '非机卡绑定收入',
                        width: 130,
                        sortable: true,
                        formatter: function (value) {
                            return value.toFixed(2);
                        }
                    },
                    {
                        field: 'lemallUnboundIncome',
                        title: '商城非机卡绑定收入',
                        width: 130,
                        sortable: true,
                        formatter: function (value) {
                            return value.toFixed(2);
                        }
                    },
                    {
                        field: 'otherUnboundIncome',
                        title: '其他非机卡绑定收入',
                        width: 130,
                        sortable: true,
                        formatter: function (value) {
                            return value.toFixed(2);
                        }
                    }
                ]
            });
        }
        function searchFun() {
            var diff = $("input[name='sdate']").dateDiff($("input[name='edate']").val());
            if (diff > 62) {
                $.messager.alert("提示", "查询日期范围不能大于62天", "关闭");
            } else {
                dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
            }
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false" style="height: 100px; overflow: auto;padding-top: 20px;padding-left: 20px">
        <form id="searchForm">
            <table>
                <tr>
                    <th style="padding-left: 5px">开始时间 </th>
                    <td>
                        <input id="sdate" name="sdate" class="easyui-datebox" value="${sdate}">&nbsp;&nbsp;
                    </td>
                    <th>截止时间 </th>
                    <td>
                        <input id="edate" name="edate" class="easyui-datebox" value="${edate}">
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
</div>
</body>
</html>

<%--
  Created by IntelliJ IDEA.
  User: kangxiongwei3
  Date: 2016/7/6
  Time: 19:15
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>国广对账</title>
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

            /**
             * 级联获取公司的商户号
             * @param flag 是否加载DataGrid
             */
            var getSignnumber = function (flag) {
                var companyId = $("#company").val();
                $.get("${pageContext.request.contextPath}/tj/cibn/get_signnumber", {companyId: companyId}, function (data) {
                    $("#signnumber option").remove();
                    var json = JSON.parse(data);
                    for (var key in json) {
                        $("#signnumber").append("<option value='" + key + "'>" + json[key] + "</option>")
                    }
                    if(flag)
                        dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/cibn/dataGrid');
                });
            };

            $("#company").change(function () {
                getSignnumber(false);
            });

            getSignnumber(true);
        });

        function renderDataGrid(url) {
            return $('#dataGrid').bossDataGrid({
                url: url,
                idField: 'date',
                sortName: 'date',
                sortOrder: 'desc',
                queryParams: {
                    startDate: $("#startDate").val(),
                    endDate: $("#endDate").val(),
                    companyId: $("#company").val(),
                    signnumber: $("#signnumber").val()
                },
                columns: [
                    {
                        field: 'date',
                        title: '日期',
                        width: 130,
                        sortable: true
                    },
                    {
                        field: 'orderIncome',
                        title: '正向总金额',
                        width: 130,
                        sortable: true
                    },
                    {
                        field: 'orderCount',
                        title: '正向总笔数',
                        width: 130,
                        sortable: true
                    },
                    {
                        field: 'refundOrderIncome',
                        title: '反向总金额',
                        width: 130,
                        sortable: true
                    },
                    {
                        field: 'refundOrderCount',
                        title: '反向总笔数',
                        width: 130,
                        sortable: true
                    },
                    {
                        field: 'serviceFee',
                        title: '总服务费',
                        width: 130,
                        sortable: true,
                        formatter: function (value) {
                            return value.toFixed(2);
                        }
                    },
                    {
                        field: 'realIncome',
                        title: '实际收入金额',
                        width: 130,
                        sortable: true
                    },
                    {
                        field: 'lePayMoney',
                        title: '乐视应结金额',
                        width: 130,
                        sortable: true,
                        formatter: function (value) {
                            return value.toFixed(2);
                        }
                    },
                    {
                        field: 'cibnPayMoney',
                        title: '国广应结金额',
                        width: 130,
                        sortable: true,
                        formatter: function (value) {
                            return value.toFixed(2);
                        }
                    },
                    {
                        field: 'diffCount',
                        title: '差异笔数',
                        width: 130
                    }
                ]
            });
        }

        function searchFun() {
            var diff = $("input[name='startDate']").dateDiff($("input[name='endDate']").val());
            if (diff > 31) {
                $.messager.alert("提示", "对账日期范围不能大于31天", "关闭");
            } else {
                dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
            }
        }

        function exportFile() {
            var startDate = $("input[name='startDate']").val();
            var endDate = $("input[name='endDate']").val();
            var companyId = $("#company option:selected").val();
            var signnumber = $("#signnumber option:selected").val();
            var url = "${pageContext.request.contextPath}/tj/cibn/export_detail?startDate=" + startDate
                    + "&endDate=" + endDate + "&companyId=" + companyId + "&signnumber=" + signnumber;
            window.location.href = url;
        }

    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false" style="height: 100px; overflow: auto;padding-top: 20px;padding-left: 20px">
        <form id="searchForm">
            <table>
                <tr>
                    <th style="padding-left: 5px">对账业务</th>
                    <td>
                        <select id="company" name="companyId">
                            <c:forEach var="company" items="${companies}">
                                <option value="${company.key}">${company.value}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <th>对账商户</th>
                    <td>
                        <select id="signnumber" name="signnumber">

                        </select>
                    </td>
                    <th>对账日期</th>
                    <td>
                        <input id="startDate" name="startDate" class="easyui-datebox" value="${startDate}" />&nbsp;&nbsp;
                        <input id="endDate" name="endDate" class="easyui-datebox" value="${endDate}" />
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
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_search',plain:true" onclick="exportFile();">导出明细</a>
</div>
</body>
</html>

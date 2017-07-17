<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>会员收入</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>
    <script type="text/javascript">

        var dataGrid;
        $(function () {
            parent.$.messager.progress('close');
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/mobileChannel/mtrend/dataGrid');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').bossDataGrid({
                url: url,
                sortName: 'allRate',
                sortOrder: 'desc',
                queryParams: {
                    statDate: $("#begin").val(),
                    device: $("#device").val(),
                    fmFlag: $("#orderone").val(),
                    actCode: $("#one").val(),
                    pffw: $("#pffw").val()
                },
                columns: [
                    {
                        field: 'statDate',
                        title: '日期',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'channelName',
                        title: '功能项',
                        width: 200,
                        sortable: true
                    },
                    {
                        field: 'actCodeName',
                        title: '动作类型',
                        width: 80,
                        sortable: true
                    },
                    {
                        field: 'pv',
                        title: '次数',
                        width: 80,
                        sortable: true
                    }, {
                        field: 'uv',
                        title: '人数',
                        width: 80,
                        sortable: true
                    },
                    {
                        field: 'newOrderCnt',
                        title: '新增订单数',
                        width: 80,
                        sortable: true
                    },
                    {
                        field: 'oldOrderCnt',
                        title: '续费订单数',
                        width: 80,
                        sortable: true
                    },
                    {
                        field: 'newMoney',
                        title: '新增收入',
                        width: 80,
                        sortable: true
                    },
                    {
                        field: 'oldMoney',
                        title: '续费金额',
                        width: 80,
                        sortable: true
                    },
                    {
                        field: 'totalIncome',
                        title: '总收入',
                        width: 80,
                        sortable: true
                    },
                    {
                        field: 'newRate',
                        title: '新增转化率',
                        width: 80,
                        formatter: function (value, row, index) {
                            return $.formatString('{0}%', row.newRate);
                        },
                        sortable: true
                    },
                    {
                        field: 'allRate',
                        title: '总转化率',
                        width: 80,
                        formatter: function (value, row, index) {
                            return $.formatString('{0}%', row.allRate);
                        },
                        sortable: true
                    },
                    {
                        field: 'cpmIncome',
                        title: '千人收入',
                        width: 80,
                        sortable: true
                    },
                    {
                        field: 'actLoc',
                        title: '渠道代号',
                        width: 300,
                        sortable: true
                    },
                    {
                        field: 'action',
                        title: '操作',
                        width: 80,
                        formatter: function (value, row, index) {
                            return "<a href='${pageContext.request.contextPath}/tj/mobileChannel/mchanneldetail?id=" + row.id + "'>趋势明细</a>";
                        }
                    }
                ]
            })
        }

        function searchFun() {
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }
    </script>

    <style type="text/css">
        th, td {
            padding-top: 5px;
            padding-left: 15px;
        }
    </style>

</head>

<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false"
         style="height: 120px; overflow: auto;">
        <form id="searchForm">
            <table>
                <tr>
                    <th>日期</th>
                    <th>设备类型</th>
                    <th>统计分类</th>
                    <th>动作类型</th>
                    <th>渠道代号</th>
                </tr>
                <tr>
                    <td>
                        <input name="statDate" id="begin" class="easyui-datebox" data-options="required:true" value="${statDate}"
                               style="width: 160px; height: 29px;"/>
                    </td>
                    <td>
                        <select name="device" style="width: 160px" id="device">
                            <option value="-1">全部</option>
                            <option value="001">安卓</option>
                            <option value="002">Iphone</option>
                            <option value="004">Ipad</option>
                        </select>
                    </td>
                    <td>
                        <select name="fmFlag" style="width: 160px" id="orderone">
                            <option value="-1">全部</option>
                            <option value="0">fragid</option>
                            <option value="1">name</option>
                        </select>
                    </td>
                    <td>
                        <select name="actCode" style="width: 160px" id="one">
                            <option value="-1">全部</option>
                            <option value="0">点击</option>
                            <option value="17">推荐点击</option>
                            <option value="19">曝光</option>
                            <option value="25">推荐曝光</option>
                        </select>
                    </td>
                    <td>
                        <input name="pffw" style="width: 300px" id="pffw" class="easyui-validatebox"/>
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
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>
</div>
</body>
</html>
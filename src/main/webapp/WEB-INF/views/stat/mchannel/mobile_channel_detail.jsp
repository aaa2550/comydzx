<%--
  Created by IntelliJ IDEA.
  User: kangxiongwei3
  Date: 2016/8/31
  Time: 9:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>移动渠道流量趋势</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js"
            type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>
    <script type="text/javascript">

        var dataGrid;

        $(function () {
            parent.$.messager.progress('close');
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/mobileChannel/mcheckDetail/list');
        });

        //每页末尾加一行统计结果
        function compute() {
            var rows = $('#dataGrid').datagrid('getRows'); //获取当前的数据行
            var totalPv = 0, totalUv = 0, totalNewOrders = 0, totalXfOrders = 0, totalNewIncome = 0, totalXfIncome = 0, totalIncome = 0, totalCpmIncome = 0;
            for (var i = 0; i < rows.length; i++) {
                totalPv += rows[i]['pv'];
                totalUv += rows[i]['uv'];
                totalNewOrders += rows[i]['newOrder'];
                totalXfOrders += rows[i]['xfOrder'];
                totalNewIncome += rows[i]['newIncome'];
                totalXfIncome += rows[i]['xfIncome'];
                totalIncome += rows[i]['totalIncome'];
            }
            var totalNewRate = 0, totalRate = 0;
            if(totalUv > 0) {
                totalNewRate = totalNewOrders * 100 / totalUv;
                totalRate  = (totalNewOrders + totalXfOrders) * 100 / totalUv;
                totalCpmIncome = totalIncome * 1000 / totalUv;
            }
            //新增一行显示统计信息
            $('#dataGrid').datagrid('appendRow', {statDate: '<b>本页统计</b>', pv: totalPv, uv: totalUv, newOrder: totalNewOrders, xfOrder: totalXfOrders,
                newIncome: totalNewIncome.toFixed(2), xfIncome: totalXfIncome.toFixed(2), totalIncome: totalIncome.toFixed(2), newRate: totalNewRate.toFixed(2),
                totalRate: totalRate.toFixed(2), cpmIncome: totalCpmIncome.toFixed(2)
            });
        }

        function renderDataGrid(url) {
            return $('#dataGrid').bossDataGrid({
                url: url,
                pageSize: 50,
                sortName: 'statDate',
                sortOrder: 'asc',
                queryParams: {
                    startDate: $("#startDate").val(),
                    endDate: $("#endDate").val(),
                    device: $("#device").val(),
                    actType: $("#actType").val(),
                    actCode: $("#actCode").val(),
                    channelUrl: $("#channelUrl").val()
                },
                columns: [
                    {
                        field: 'statDate',
                        title: '日期',
                        width: 100
                    },
                    {
                        field: 'pv',
                        title: 'PV',
                        width: 100,
                        sortable: true
                    }, {
                        field: 'uv',
                        title: 'UV',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'newOrder',
                        title: '新增订单数',
                        width: 100
                    },
                    {
                        field: 'xfOrder',
                        title: '续费订单数',
                        width: 100
                    },
                    {
                        field: 'newIncome',
                        title: '新增收入',
                        width: 100
                    },
                    {
                        field: 'xfIncome',
                        title: '续费金额',
                        width: 100
                    },
                    {
                        field: 'totalIncome',
                        title: '总收入',
                        width: 100
                    },
                    {
                        field: 'newRate',
                        title: '新增转化率',
                        width: 100,
                        formatter: function (value, row, index) {
                            return $.formatString('{0}%', row.newRate);
                        }
                    },
                    {
                        field: 'totalRate',
                        title: '总转化率',
                        width: 100,
                        formatter: function (value, row, index) {
                            return $.formatString('{0}%', row.totalRate);
                        }
                    },
                    {
                        field: 'cpmIncome',
                        title: '千人收入',
                        width: 100
                    }
                ],
                onLoadSuccess: function(data){
                	loadChart(data);
                }
            });
        }

        function searchFun() {
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }
        
        function loadChart(data) {
            var rows = data['rows'];
            $('#container').highcharts({
                chart: {
                    //type: 'column'
                },
                title: {
                    text: '移动渠道流量趋势',
                    x: -20 //center
                },
                xAxis: {
                    categories: $.map(rows, function (element) {
                        return element['statDate'];
                    })
                },
                yAxis: {
                    title: {
                        text: '数量'
                    },
                    labels: {
       	                format: '{value}'
       	            },
                    plotLines: [{
                        value: 0,
                        width: 1,
                        color: '#808080'
                    }]
                },
                credits: {
                    enabled: false
                },
                tooltip: {
                    shared: true
                },
                legend: {
                    layout: 'vertical',
                    align: 'right',
                    verticalAlign: 'middle',
                    borderWidth: 1,
                    borderRadius: 5
                },
                series: [{
                    name: 'UV',
                    color:'#51A7F9',
                    type: 'spline',
                    data: $.map(rows, function (element) {
                        return Number(element['uv']);
                    })
                },
                {
                    name: 'PV',
                    color:'#22BA66',
                    type: 'spline',
                    data: $.map(rows, function (element) {
                        return Number(element['pv']);
                    })
                }]
            });
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
    <div data-options="region:'north',title:'查询条件',border:false" style="height: 120px; overflow: auto;">
        <form id="searchForm">
            <table>
                <tr>
                    <th>开始日期</th>
                    <th>结束日期</th>
                    <th>设备类型</th>
                    <th>统计分类</th>
                    <th>动作类型</th>
                    <th>渠道代号</th>
                </tr>
                <tr>
                    <td>
                        <input name="startDate" id="startDate" class="easyui-datebox" data-options="required:true"
                               value="${startDate}"
                               style="width: 160px; height: 29px"/>
                    </td>
                    <td>
                        <input name="endDate" id="endDate" class="easyui-datebox" data-options="required:true"
                               value="${endDate}"
                               style="width: 160px; height: 29px"/>
                    </td>
                    <td>
                        <select name="device" style="width: 160px" id="device">
                            <option value="-1" <c:if test="${device == -1}">selected="selected"</c:if>>全部</option>
                            <option value="001" <c:if test="${device == '001'}">selected="selected"</c:if>>Android</option>
                            <option value="002" <c:if test="${device == '002'}">selected="selected"</c:if>>iPhone</option>
                            <option value="004" <c:if test="${device == '004'}">selected="selected"</c:if>>iPad</option>
                        </select>
                    </td>
                    <td>
                        <select name="actType" style="width: 160px" id="actType">
                            <option value="-1" <c:if test="${actType == -1}">selected="selected"</c:if>>全部</option>
                            <option value="0" <c:if test="${actType == 0}">selected="selected"</c:if>>fragid</option>
                            <option value="1" <c:if test="${actType == 1}">selected="selected"</c:if>>name</option>
                            <option value="2" <c:if test="${actType == 2}">selected="selected"</c:if>>其他</option>
                        </select>
                    </td>
                    <td>
                        <select name="actCode" style="width: 160px" id="actCode">
                            <option value="-1" <c:if test="${actCode == -1}">selected="selected"</c:if>>全部</option>
                            <option value="0" <c:if test="${actCode == 0}">selected="selected"</c:if>>点击</option>
                            <option value="17" <c:if test="${actCode == 17}">selected="selected"</c:if>>推荐点击</option>
                            <option value="19" <c:if test="${actCode == 19}">selected="selected"</c:if>>曝光</option>
                            <option value="25" <c:if test="${actCode == 25}">selected="selected"</c:if>>推荐曝光</option>
                        </select>
                    </td>
                    <td>
                        <input name="channelUrl" style="width: 500px" id="channelUrl" value="${channelUrl}" readonly=true/>
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
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_search',plain:true"
       onclick="searchFun();">查询</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true"
       onclick="cleanFun();">清空条件</a>
    <div id="container" style="min-width: 310px; height: 300px; margin: 0 auto; overflow: auto"></div>
</div>
</body>
</html>

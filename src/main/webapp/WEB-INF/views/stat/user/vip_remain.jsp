<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>会员留存趋势</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js"
            type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>
    <script type="text/javascript">
        /**
         * 待绑定行数据
         */
        var rows;

        var dataGrid;
        $(function () {
            parent.$.messager.progress('close');
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/remain/${productSubtype}/list.json');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').bossDataGrid({
                url: url,
                pagination: false,
                sortName: 'cdate',
                sortOrder: "asc",
                fit: false,
                queryParams: {
                    startDate: $("input[name='startDate']").val(),
                    endDate: $("input[name='endDate']").val(),
                    terminal: $("select[name='terminal'] option:selected").val(),
                    parentChannel: $("select[name='parentChannel'] option:selected").val(),
                    productId: $("select[name='productId'] option:selected").val()
                },
                columns: [
                    {
                        field: 'cdate',
                        title: '日期',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'remain',
                        title: '会员留存数',
                        width: 100
                    }
                ],
                onLoadSuccess: function (data) {
                    parent.$.messager.progress('close');
                    rows = data['rows'];
                    loadChart(data);
                }
            });
        }

        function searchFun() {
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }

        function loadChart(data) {
            var rows = data['rows'];
            //根据长度设置步长，防止x轴数据太多显示不全
            var step = Math.round(rows.length / 6);
            $('#container').highcharts({
                title: {
                    text: '会员留存趋势',
                    x: -20
                },
                xAxis: {
                    tickInterval: step,
                    categories: $.map(rows, function (element) {
                        return element['cdate'];
                    })
                },
                yAxis: {
                    title: {
                        text: '留存数'
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
                    valueSuffix: '人',
                    pointFormat: '{series.name}: <b>{point.y}</b><br/>',
                    shared: true
                },

                legend: {
                    layout: 'vertical',
                    align: 'right',
                    verticalAlign: 'middle',
                    borderWidth: 1,
                    borderRadius: 5
                },
                series: [
                    {
                        type: 'spline',
                        name: '留存会员数',
                        data: $.map(rows, function (element) {
                            return Number(element['remain']);
                        })
                    }
                ]
            });
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false" style="height: 120px; overflow: auto;">
        <form id="searchForm">
            <table class="table table-hover table-condensed">
                <tr>
                    <td>开始</td>
                    <td>结束</td>
                    <td>终端</td>
                    <td>会员类型</td>
                    <td>支付方式</td>
                </tr>
                <tr>
                    <td>
                        <input name="startDate" id="startDate" class="easyui-datebox" data-options="required:true"
                               value="${startDate}" style="width: 160px; height: 29px"/>
                    </td>

                    <td>
                        <input name="endDate" id="endDate" class="easyui-datebox" data-options="required:true"
                               value="${endDate}" style="width: 160px; height: 29px"/>
                    </td>
                    <td>
                        <select name="terminal" style="width: 160px">
                            <option value="-2">全部</option>
                            <c:forEach var="terminal" items="${terminal}">
                                <option value="${terminal.terminalId}">${terminal.terminalName}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <select name="productId" id="productId" style="width: 160px">
                            <option value="0">全部</option>
                            <option value="1">乐次元影视会员</option>
                            <option value="9">超级影视会员</option>
                        </select>
                    </td>
                    <td>
                        <select name="parentChannel" style="width: 160px" id="parentChannel">
                            <option value="-2">全部</option>
                            <c:forEach var="parentChannel" items="${parentChannel}">
                                <option value="${parentChannel.parentChannel}">${parentChannel.parentName}</option>
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
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_search',plain:true"
       onclick="searchFun();">查询</a>
    <div id="container" style="height: 280px;"></div>
</div>

</body>
</html>
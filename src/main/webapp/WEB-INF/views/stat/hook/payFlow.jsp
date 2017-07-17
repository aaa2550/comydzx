<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>订单转化率统计</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>
    <style>
        .progress-con {
            padding: 20px;
            overflow: hidden;
            background: #fff;
        }

        .progress-con li {
            height: 26px;
            line-height: 26px;
            margin-bottom: 10px;
        }

        .progress-con li .title-s {
            display: inline-block;
            width: 120px;
            text-align: right;
            font-size: 12px;
            color: #333;
            line-height: 26px;
            vertical-align: top
        }

        .progress-con li p {
            display: inline-block;
            width: 460px;
            overflow: hidden;
            text-align: center;
            margin-left: 20px
        }

        .progress-con li p .number-text {
            display: inline-block;
            width: 50%;
            background: #0081C2;
            color: #333;
            margin: 0 auto;
            overflow: visible;

        }

        .progress-con li p .number-text em {
            font-size: 14px;
            font-style: normal;
            font-weight: bold;
        }
    </style>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            parent.$.messager.progress('close');
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/hookstat/payFlow/dataGrid');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').datagrid({
                url: url,
                fit: false,
                fitColumns: false,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 10,
                pageList: [10, 20, 30, 40, 50],
                //sortName: 'date',
                //sortOrder: 'asc',
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                striped: true,
                rownumbers: true,
                singleSelect: true,
                remoteSort: false,
                frozenColumns: [
                    []
                ],
                queryParams: $.serializeObject($('#searchForm')),
                columns: [
                    [
                        {
                            field: 'date',
                            title: '日期',
                            width: '120',
                            sortable: true
                        },
                        {
                            field: "cashierPv",
                            title: '收银台PV',
                            width: '120',
                            sortable: true
                        },
                        {
                            field: "cashierUv",
                            title: '收银台UV',
                            width: '120',
                            sortable: true
                        },
                        {
                            field: "confirmOpenedPv",
                            title: '确认开通PV',
                            width: '120',
                            sortable: true
                        },
                        {
                            field: "confirmOpenedUv",
                            title: '确认开通UV',
                            width: '120',
                            sortable: true
                        },
                        {
                            field: "immediatelyPayPv",
                            title: '立即支付PV',
                            width: '120',
                            sortable: true
                        },
                        {
                            field: "immediatelyPayUv",
                            title: '立即支付UV',
                            width: '120',
                            sortable: true
                        },
                        {
                            field: "succOrderCount",
                            title: '成功订单数',
                            width: '120',
                            sortable: true
                        },
                        {
                            field: "succOrderCountUv",
                            title: '成功订单数Uv',
                            width: '120',
                            sortable: true
                        },
                        {
                            field: "succOrderRate",
                            title: '订单转化率',
                            width: '100',
                            sortable: true,
                            formatter: function (value, row, index) {
                                return value + "%";
                            }
                        },
                        {
                            field: "succOrderRateUv",
                            title: '订单转化率Uv',
                            width: '100',
                            sortable: true,
                            formatter: function (value, row, index) {
                                return value + "%";
                            }
                        }
                    ]
                ],
                toolbar: '#toolbar',
                onLoadSuccess: function (data) {
                    parent.$.messager.progress('close');
                    loadChart(data);
                    loadFunnelGraph(data.graphs);
                },
                onRowContextMenu: function (e, rowIndex, rowData) {
                    e.preventDefault();
                    $(this).datagrid('unselectAll');
                    $(this).datagrid('selectRow', rowIndex);
                    $('#menu').menu('show', {
                        left: e.pageX,
                        top: e.pageY
                    });
                }
            });
        }

        function exportExcel() {
            location.href = '${pageContext.request.contextPath}/tj/hookstat/payFlow/excel?' + $('#searchForm').serialize();
        }

        function searchFun() {
            var s = $("input[name=dateStart]").val();
            var s1 = $("input[name=dateEnd]").val();
            if (Math.abs(((new Date(Date.parse(s1)) - new Date(Date.parse(s))) / 1000 / 60 / 60 / 24)) - 120 < 0) {
                dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
            } else {
                alert("查询时间范围是120天!!!");
            }
        }

        function loadFunnelGraph(data) {
            var graph = "<ul>";
            $.each(data, function (i, value) {
                graph += '<li>'
                        + '<span class="title-s">' + value['name'] + '</span>'
                        + '<p><span class="number-text" style="width:' + value['rate'] + '"><em>' + value['rate'] + '</em>,<em>' + value['count'] + '</em></span></p>'
                        + '</li>';
            });
            graph += "</ul>";
            $('#graph').empty().append(graph);
        }

        function loadChart(data) {
            var rows = data['rows'];
            //根据长度设置步长，防止x轴数据太多显示不全
            var step = Math.round(rows.length / 5);
            $('#container').highcharts({
                title: {
                    text: '收银台转化率趋势',
                    x: -20
                },
                xAxis: {
                	tickInterval: step,
                    categories: $.map(rows, function (element) {
                        return element['date'];
                    })
                },
                credits: {
	   	            enabled:false
	   	        },
                yAxis: {
                    title: {
                        text: '转化率(%)'
                    },
                    plotLines: [{
                        value: 0,
                        width: 1,
                        color: '#808080'
                    }]
                },
                tooltip: {
    	            shared: true
    	        },
                legend: {
                    layout: 'vertical',
                    align: 'right',
                    verticalAlign: 'middle',
                    borderWidth: 0
                },
                series: [{
                	name: '转化率',
    	            color: '#51A7F9',
    	            data: $.map(rows, function (element) {
                        return element['succOrderRate'];
                    }),
    	            tooltip: {
    	                valueSuffix: ' %'
    	            }
                },
                {
                	name: '转化率Uv',
    	            color: '#22BA66',
    	            data: $.map(rows, function (element) {
                        return element['succOrderRateUv'];
                    }),
    	            tooltip: {
    	                valueSuffix: ' %'
    	            }
                }]
            });
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
                    <td>开始时间</td>
                    <td>结束时间</td>
                    <td>终端</td>
                </tr>
                <tr>
                    <td>
                        <input name="dateStart" class="easyui-datebox" data-options="required:true" value="${dateStart}" style="width: 160px; height: 29px"/>
                    </td>

                    <td>
                        <input name="dateEnd" class="easyui-datebox" data-options="required:true" value="${dateEnd}" style="width: 160px; height: 29px">
                    </td>
                    <td>
                        <select name="terminal" style="width: 160px">
                            <c:forEach items="${terminals}" var="terminal">
                                <option value="${terminal.key}">${terminal.value}</option>
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
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="exportExcel();">导出excel</a>

    <div class="progress-con" id="graph"></div>
    <div id="container" style="min-width: 310px; height: 300px; margin: 0 auto; overflow: auto"></div>
</div>
</body>
</html>
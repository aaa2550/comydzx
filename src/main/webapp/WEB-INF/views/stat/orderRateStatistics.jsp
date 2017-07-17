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
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            parent.$.messager.progress('close');
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/orderPaySuccController/rateQueryList');
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
                sortName: 'date',
                sortOrder: 'asc',
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
                columns: [
                    [
                        {
                            field: 'date',
                            title: '日期',
                            width: '90',
                            sortable: true
                        },
                        {
                            field: "allConRate",
                            title: '总订单转化率',
                            width: '100',
                            sortable: true,
                            formatter: function (value, row, index) {
                                return $.formatString('{0}%', row.allConRate);
                            }
                        },
                        {
                            field: "proConRate",
                            title: '全屏影视订单转化率',
                            width: '120',
                            sortable: true,
                            formatter: function (value, row, index) {
                                return $.formatString('{0}%', row.proConRate);
                            }
                        },
                        {
                            field: "regularConRate",
                            title: '移动影视订单转化率',
                            width: '120',
                            sortable: true,
                            formatter: function (value, row, index) {
                                return $.formatString('{0}%', row.regularConRate);
                            }
                        },
                        {
                            field: "singleConRate",
                            title: '单点订单转化率',
                            width: '100',
                            sortable: true,
                            formatter: function (value, row, index) {
                                return $.formatString('{0}%', row.singleConRate);
                            }
                        },
                        /* {
                         field: "otherRate",
                         title: '其他',
                         width: '50',
                         sortable: false
                         }, */
                        {
                            field: 'allUV',
                            title: '总收银台流量',
                            width: '90',
                            sortable: true
                        },
                        {
                            field: 'proUV',
                            title: '全屏影视收银台',
                            width: '100',
                            sortable: true
                        },
                        {
                            field: "regularUV",
                            title: '移动影视收银台',
                            width: '100',
                            sortable: true
                        },
                        {
                            field: "singleUV",
                            title: '单点收银台',
                            width: '90',
                            sortable: true
                        },
                        /* {
                         field: 'otherUV',
                         title: '其他',
                         width: '50',
                         sortable: true
                         }, */
                        {
                            field: 'allOrderCount',
                            title: '总订单数',
                            width: '90',
                            sortable: true
                        },
                        {
                            field: "proOrderCount",
                            title: '全屏影视订单数',
                            width: '90',
                            sortable: true
                        },
                        {
                            field: "regularOrderCount",
                            title: '移动影视订单数',
                            width: '90',
                            sortable: true
                        },
                        {
                            field: 'singleOrderCount',
                            title: '单点订单数',
                            width: '90',
                            sortable: true
                        }/* ,
                     {
                     field: 'otherCount',
                     title: '其他',
                     width: '50',
                     sortable: true
                     } */

                    ]
                ],
                toolbar: '#toolbar',
                onLoadSuccess: function (data) {
                    parent.$.messager.progress('close');
                    loadChart(data)
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

        function searchFun() {
            var s = $("input[name=beginDate]").val();
            var s1 = $("input[name=endDate]").val();
            if (Math.abs(((new Date(Date.parse(s1)) - new Date(Date.parse(s))) / 1000 / 60 / 60 / 24)) - 30 < 0) {
                dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
            } else {
                alert("查询时间范围是30天!!!");
            }
        }
        function cleanFun() {
            $('#searchForm input').val('');
            $('#two').val('');
            dataGrid.datagrid('load', {});
        }

       /* $(function () {
            parent.$.messager.progress('close');
        });*/


        function loadChart(data) {
            var rows = data['rows'];
            $('#container').highcharts({
                title: {
                    text: '订单转化率'
                },
                legend: {
                    layout: 'vertical',
                    align: 'right',
                    verticalAlign: 'middle',
                    width: 100,
                    borderWidth: 0
                },
                xAxis: {
                    categories: $.map(rows, function (element) {
                        return element['date'];
                    }),
                    title: {
                        text: '日期'
                    }
                },
                /*tooltip: {
                 pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.y:,.2f}%</b><br/>',
                 crosshairs: true,
                 shared: true
                 },*/
                yAxis: {
                    title: {
                        text: '转化率(%)'
                    },
                    labels: {
                        formatter: function () {
                            return this.value
                        }
                    },
                    plotLines: [
                        {
                            value: 0,
                            width: 1,
                            color: '#808080'
                        }
                    ],
                    min: Math.min.apply(null, $.map(rows, function (element) {
                        return element['allConRate'];
                    })),
                    max: Math.max.apply(null, $.map(rows, function (element) {
                        return element['allConRate'];
                    }))
                },
                series: [
                    {
                        type: 'line',
                        name: '订单转化率',
                        data: $.map(rows, function (element) {
                            return element['allConRate'];
                        }),
                        marker: {
                            lineWidth: 2,
                            lineColor: Highcharts.getOptions().colors[3],
                            fillColor: 'white'
                        }
                    }
                ]
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
                    <td>开始</td>
                    <td>结束</td>
                    <td>支付终端</td>
                    <td>设备</td>
                    <td>指标</td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <input name="beginDate" class="easyui-datebox" data-options="required:true" value="${start}" style="width: 160px; height: 29px"/>
                    </td>

                    <td>
                        <input name="endDate" class="easyui-datebox" data-options="required:true" value="${end}" style="width: 160px; height: 29px">
                    </td>
                    <td>
                        <select name="terminal" style="width: 160px" id="one">
                            <option value="112">PC</option>
                            <option value="111">TV</option>
                            <option value="130">Mobile</option>
                            <option value="113">M站</option>
                        </select>
                    </td>
                    <td>
                    	<select name="terminal2" style="width: 160px" id="two">
                            <option value="">全部</option>
                            <c:forEach items="${devices}" var = "device">
                            	<option value="${device.key}">${device.value}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <select name="model" style="width: 160px">
                            <option value="uv">UV</option>
                            <option value="pv">PV</option>
                        </select>
                    </td>
                    <td></td>
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
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">清空条件</a>

    <div id="container" style="min-width: 310px; height: 300px; margin: 0 auto; overflow: auto"></div>
</div>
</body>
</html>
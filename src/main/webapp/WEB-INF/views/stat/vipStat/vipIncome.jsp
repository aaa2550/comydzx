<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>会员收入</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/static/lib/select2.full.js" type="text/javascript"></script>
    <link href="${pageContext.request.contextPath}/static/style/select2.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript">
        /**
         * 待绑定行数据
         */
        var rows;

        var dataGrid;
        $(function () {
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/vipController/query/vipIncomeQueryList');
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
                sortName: 'time',
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
                            field: 'time',
                            title: '日期',
                            width: 100,
                            sortable: true
                        }, {
                        field: 'allVipIncome',
                        title: '会员总收入',
                        width: 100,
                        sortable: true
                    },
                        {
                            field: 'newVipIncome',
                            title: '新增收入',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'xfVipIncome',
                            title: '续费收入',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'monthVipIncome',
                            title: '包月收入',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'autoMonthVipIncome',
                            title: '自动包月收入',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'quaterVipIncome',
                            title: '包季收入',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'helfYearVipIncome',
                            title: '包半年收入',
                            width: 100,
                            sortable: true
                        }, {
                        field: 'oneYearVipIncome',
                        title: '包年收入',
                        width: 100,
                        sortable: true
                    }, {
                        field: 'threeYearVipIncome',
                        title: '包3年收入',
                        width: 100,
                        sortable: true
                    }
                    ]
                ],
                toolbar: '#toolbar',
                onLoadSuccess: function (data) {
                    parent.$.messager.progress('close');
                    rows = data['rows'];
                    loadChart(data);
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
            if (Math.abs(((new Date(Date.parse(s1)) - new Date(Date.parse(s))) / 1000 / 60 / 60 / 24)) - 60 < 0) {
                dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
            } else {
                alert("查询时间范围是60天!!!");
            }
        }
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }

        function exportExcel() {
            var begin = $('#begin').combobox('getValue');
            var end = $('#end').combobox('getValue');
            var terminal = $("#one").val();
            var terminal2 = $("#two").val();
            var orderpaytype = $("#orderone").val();
            var orderpaytype1 = $("#orderpaytype1").val();
            var viptype = $("#viptypeid").val();
            var url = '${pageContext.request.contextPath}/vipController/exportVipIncomeExcel?beginDate=' + begin + '&endDate=' + end + '&terminal=' + terminal + '&terminal2=' + terminal2 + '&orderpaytype=' + orderpaytype + '&orderpaytype1=' + orderpaytype1 + '&viptype=' + viptype;
            location.href = url;
        }

        function loadChart(data) {
            var rows = data['rows'].slice(0); //深度拷贝
            rows.pop(); //删除最后一个元素
            $('#container').highcharts({
                        chart: {
                            //type: 'column'
                        },
                        title: {
                            text: '会员收入趋势',
                            x: -20 //center
                        },
                        xAxis: {
                            categories: $.map(rows, function (element) {
                                return element['time'];
                            })
                        },
                        yAxis: {
                            title: {
                                text: '收入金额（元）'
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
                            valueSuffix: '元(RMB)',
                            crosshairs: true,
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
                        series: [/*

                         {
                         type: 'spline',
                         name: '续费收入',
                         data: $.map(rows, function (element) {
                         return Number(element['xfVipIncome']) ;
                         })
                         },
                         {
                         type: 'spline',
                         name: '新增收入',
                         data: $.map(rows, function (element) {
                         return Number(element['newVipIncome']) ;
                         })
                         },*/
                            {
                                type: 'spline',
                                name: '总收入',
                                data: $.map(rows, function (element) {
                                    return Number(element['allVipIncome']);
                                })
                            },
                            {
                                type: 'spline',
                                name: '包月收入',
                                data: $.map(rows, function (element) {
                                    return Number(element['monthVipIncome']);
                                })
                            },
                            {
                                type: 'spline',
                                name: '自动包月收入',
                                data: $.map(rows, function (element) {
                                    return Number(element['autoMonthVipIncome']);
                                })
                            },
                            {
                                type: 'spline',
                                name: '包季收入',
                                data: $.map(rows, function (element) {
                                    return Number(element['quaterVipIncome']);
                                })
                            },
                            {
                                type: 'spline',
                                name: '包半年收入',
                                data: $.map(rows, function (element) {
                                    return Number(element['helfYearVipIncome']);
                                })
                            },
                            {
                                type: 'spline',
                                name: '包年收入',
                                data: $.map(rows, function (element) {
                                    return Number(element['oneYearVipIncome']);
                                })
                            },
                            {
                                type: 'spline',
                                name: '包三年收入',
                                data: $.map(rows, function (element) {
                                    return Number(element['threeYearVipIncome']);
                                })
                            }
                        ]
                    }
            );
        }


        $(function () {
            parent.$.messager.progress('close');
        });

        //终端设备联动
        $(function () {
                    $("#one").change(function () {
                        var m = $(this).children('option:selected').val();
                        if (m == 130) {
                            $("#two").empty();
                            $("#two").append("<option value='-2' >全部</option>");
                            $("#two").append("<option value='41' >iPad</option>");
                            $("#two").append("<option value='42' >iPhone</option>");
                            $("#two").append("<option value='47' >android</option>");
                        } else {
                            $("#two").empty();
                            $("#two").append("<option value='-2' >全部</option>");
                        }

                    });
                }
        );

        //支付通道联动
        $(function () {
            $("#orderone").change(function () {
                var m = $(this).children('option:selected').val();
                if (m == 2) {
                    $("#orderpaytype1").empty();
                    $("#orderpaytype1").append("<option value='-2' >全部</option>");
                    <c:forEach items="${payTypeList}" var="var">
                    $("#orderpaytype1").append("<option value='${var.type}' >${var.description}</option>");
                    </c:forEach>

                } else {
                    $("#orderpaytype1").empty();
                    $("#orderpaytype1").append("<option value='-2' >全部</option>");
                }

            });
        }
        );

        $(function () {
            $('#orderpaytype1, #paytype').select2();
            $('#paytype').on('change', function () {
                $('#orderpaytype1').prop('disabled', $(this).val() != -2);
            });
        });
    </script>

    <script>
        $.extend($.fn.validatebox.defaults.rules, {
            TimeCheck: {
                validator: function () {
                    var s = $("input[name=beginDate]").val();
                    var s1 = $("input[name=endDate]").val();
                    return Math.abs(((new Date(Date.parse(s1)) - new Date(Date.parse(s))) / 1000 / 60 / 60 / 24)) - 60 < 0;
                },
                message: '非法数据'
            }
        });

    </script>
    <style>
        .span {
            padding: 10px;
        }
    </style>
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
                    <td>终端</td>
                    <td>设备</td>
                    <td>会员类型</td>
                    <td>支付方式</td>
                    <td>支付渠道</td>
                    <td>新支付渠道</td>
                </tr>
                <tr>
                    <td>
                        <input name="beginDate" id="begin" class="easyui-datebox" validType="TimeCheck" invalidMessage="查询时间范围是60天!!!" data-options="required:true" value="${start}"
                               style="width: 160px; height: 29px"/>
                    </td>

                    <td>
                        <input name="endDate" id="end" class="easyui-datebox" validType="TimeCheck" invalidMessage="查询时间范围是60天!!!" data-options="required:true" value="${end}"
                               style="width: 160px; height: 29px">
                    </td>
                    <td>
                        <select name="terminal" style="width: 160px" id="one">
                            <option value="-2">全部</option>
                            <option value="130">mobile</option>
                            <option value="112">pc</option>
                            <option value="111">tv</option>
                            <option value="113">M站</option>
                            <option value="120">超级手机</option>
                        </select>
                    </td>
                    <td>
                        <select name="terminal2" style="width: 160px" id="two">
                            <option value="-2">全部</option>
                        </select>
                    </td>
                    <td>
                        <select name="viptype" id="viptypeid" style="width: 160px">
                            <option value="-2">全部</option>
                            <option value="1">移动影视会员</option>
                            <option value="9">全屏影视会员</option>
                        </select>
                    </td>
                    <td>
                        <select name="orderpaytype" style="width: 160px" id="orderone">
                            <option value="-2">全部</option>
                            <option value="-1">免费</option>
                            <option value="0">兑换码</option>
                            <option value="1">乐点</option>
                            <option value="2" selected="selected">现金</option>
                            <option value="3">机卡绑定</option>
                        </select>
                    </td>
                    <td>
                        <select name="orderpaytype1" id="orderpaytype1" style="width: 180px">
                            <option value="-2">全部</option>
                            <c:forEach items="${payTypeList}" var="var">
                                <option value='${var.type}'>${var.type}-${var.description}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <select name="paytype" id="paytype" style="width: 180px">
                            <option value="-2">全部</option>
                            <c:forEach items="${payChannelNews}" var="var">
                                <option value='${var.key}'>${var.key}-${var.value}</option>
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

    <div id="container" style="min-width: 310px; height: 300px; margin: 0 auto; overflow: auto"></div>
</div>
</body>
</html>
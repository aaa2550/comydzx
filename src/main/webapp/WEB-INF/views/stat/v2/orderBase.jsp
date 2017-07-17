<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>${internationalConfig.基础数据汇总}</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js"
            type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/static/lib/select2.full.js" type="text/javascript"></script>
    <link href="${pageContext.request.contextPath}/static/style/select2.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="/js/kv/vipCategory.js"></script>
    <script type="text/javascript">
        /**
         * 待绑定行数据
         */
        var rows;

        var dataGrid;
        $(function () {
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/v2order/orderBase/dataGrid');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').datagrid({
                url: url,
                fit: false,
                fitColumns: false,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 15,
                pageList: [15, 30, 45],
                //sortName: 'success_time',
                //sortOrder: 'desc',
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                striped: true,
                rownumbers: true,
                singleSelect: true,
                remoteSort: false,
                queryParams: $.serializeObject($('#searchForm')),
                frozenColumns: [
                    []
                ],
                columns: [
                    [
                        {
                            field: 'successTime',
                            title: '${internationalConfig.日期}',
                            width: 100,
                            sortable: true
                        }, {
                        field: 'userCount',
                        title: '${internationalConfig.用户数}',
                        width: 100,
                        sortable: true
                    },
                        {
                            field: 'orderCount',
                            title: '${internationalConfig.订单数}',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'payPrice',
                            title: '${internationalConfig.总收入}',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'succRate',
                            title: '${internationalConfig.支付成功率}',
                            width: 100,
                            sortable: true
                        }
                    ]
                ],
                toolbar: '#toolbar',
                onLoadSuccess: function (data) {
                    parent.$.messager.progress('close');
                    loadChart(data.rows);
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
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }

        function exportExcel() {
            var fields = new Array();
            var options = $('#dataGrid').datagrid('options');
            var columns = options.columns[0];
            for (var i = 0; i < columns.length; i++) {
                if (!columns[i].hidden) {
                    var title = columns[i].title;
                    var field = columns[i].field;
                    var obj = new Object();
                    obj.title = title;
                    obj.field = field;
                    fields.push(obj);
                }
            }
            $('input[name=fields]').val(JSON.stringify(fields));
            $('input[name=title]').val($('head title').text());
            $('#searchForm').submit();
        }

        function exportExcelRecord() {
            location.href = '${pageContext.request.contextPath}/tj/v2order/orderBase/excelRecord?' + $("#searchForm").serialize();
        }

        function loadChart(rows) {
            $('#container').highcharts({
                chart: {
                    zoomType: 'xy'
                },
                title: {
                    text: '${internationalConfig.收入}-ARPU'
                },
                xAxis: {
                    categories: $.map(rows, function (element) {
                        return element['successTime'];
                    })
                },
                yAxis: [{ // Primary yAxis
                    labels: {
                        //format: '{value}',
                        style: {
                            color: Highcharts.getOptions().colors[2]
                        }
                    },
                    title: {
                        text: '${internationalConfig.收入}(${internationalConfig.元})',
                        style: {
                            color: Highcharts.getOptions().colors[2]
                        }
                    }
                }, {
                    gridLineWidth: 0,
                    title: {
                        text: 'arpu',
                        style: {
                            color: Highcharts.getOptions().colors[0]
                        }
                    },
                    labels: {
                        //format: '{value}',
                        style: {
                            color: Highcharts.getOptions().colors[0]
                        }
                    },
                    opposite: true
                }],
                credits: {
                    enabled: false
                },
                tooltip: {
                    shared: true
                },
                legend: {
                    layout: 'vertical',
                    align: 'right',
                    x: -100,
                    verticalAlign: 'top',
                    y: 25,
                    floating: true,
                    backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF',
                    borderWidth: 1,
                    borderRadius: 5,
                    shadow: false
                },
                series: [
                    {
                        type: 'spline',
                        name: '${internationalConfig.收入}',
                        data: $.map(rows, function (element) {
                            return Number(element['payPrice']);
                        }),
                        color: Highcharts.getOptions().colors[2],
                        tooltip: {
                            valueSuffix: '{value}(${internationalConfig.元})'
                        }
                    },
                    {
                        type: 'spline',
                        name: 'arpu',
                        yAxis: 1,
                        data: $.map(rows, function (element) {
                            return Number(element['arpu']);
                        }),
                        color: Highcharts.getOptions().colors[0],
                        tooltip: {
                            valueSuffix: '{value}(${internationalConfig.元})'
                        }
                    }
                ]
            });
        }


        $(function () {
            parent.$.messager.progress('close');
        });

        var cache = {};

        function renderCascade(productType, url, subId) {
            if (productType == 100) {
                var key = productType;
                if (subId)
                    key += "_" + subId;
                if (cache[key]) {
                    $('#' + subId).empty().append(cache[key]);
                    $('#' + subId + ' select').select2();
                } else {
                    $.getJSON(url, {productType: productType}, function (data) {
                        var str = '<select name="' + subId + '" style="width: 200px">';
                        str += '<option value="">${internationalConfig.全部}</option>';
                        $.each(data, function (n, value) {
                            if (subId == 'productSubtype')
                                str += "<option value='" + value.category + "'>" + value.category + "-" + Dict.vipCategory[value.category] + "</option>";
                            else
                                str += "<option value='" + value.id + "'>" + value.id + "-" + value.name + "</option>";
                        });
                        str += '</select>';
                        $('#' + subId).empty().append(str);
                        $('#' + subId + ' select').select2();
                        cache[key] = str;
                    });
                }
            } else {
                var str = '<input class="easyui-textbox" name="' + subId + '" style="width: 200px; height: 29px"/>';
                $('#' + subId).empty().append(str);
                $('#' + subId + ' input').textbox();
            }
        }

        $(function () {
            $('select').select2();
            $('#productType').on('change', function () {
                renderCascade($(this).val(), "${pageContext.request.contextPath}/tj/v2order/orderBase/productSubtype", "productSubtype");
                renderCascade($(this).val(), "${pageContext.request.contextPath}/tj/v2order/orderBase/productId", "productId");
            });
        });
        function dataExplain() {
            $("#dataExplain").dialog({
                title: '字段解释',
                width: 520,
                height: 160,
                closed: false,
                modal: true
            });
        }
    </script>

    <script>
        $.extend($.fn.validatebox.defaults.rules, {
            TimeCheck: {
                validator: function () {
                    var s = $("input[name=dateStart]").val();
                    var s1 = $("input[name=dateEnd]").val();
                    return Math.abs(((new Date(Date.parse(s1)) - new Date(Date.parse(s))) / 1000 / 60 / 60 / 24)) - 61 < 0;
                },
                message: '${internationalConfig.非法数据}'
            }
        });

    </script>
    <style>
        .span {
            padding: 10px;
        }

        .dataExplain {
            padding: 10px 10px;
            font-size: 15px;
        }
    </style>
</head>
<body>
<div id="dataExplain" closed="true" class="dataExplain easyui-dialog">
    <p>用户数:订单状态为已支付的用户去重数</p>

    <p>订单数:订单状态为已支付的订单数</p>

    <p>总收入:订单状态为已支付的订单的通道真实支付价格总和</p>

    <p>支付成功率:订单状态为已支付的数量和全部订单数量的比值</p>

    <p>arpu:一段时间内从每个用户身上得到的利润(Average Revenue Per User)</p>
</div>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
         style="height: 120px; overflow: auto;">
        <form id="searchForm" action="${pageContext.request.contextPath}/tj/v2order/orderBase/excel" method="post">
            <table class="table table-hover table-condensed">
                <tr>
                    <td>${internationalConfig.开始时间}</td>
                    <td>${internationalConfig.结束时间}</td>
                    <td>${internationalConfig.产品类型}</td>
                    <td>${internationalConfig.产品子类型}</td>
                    <td>${internationalConfig.产品ID}</td>
                    <td>${internationalConfig.支付方式}</td>
                    <td>${internationalConfig.终端}</td>
                </tr>
                <tr>
                    <input type="hidden" name="title">
                    <input type="hidden" name="fields">
                    <td>
                        <input name="dateStart" id="begin" class="easyui-datebox"  data-options="required:true"
                               value="${dateStart}" style="width: 160px; height: 29px"/>
                    </td>

                    <td>
                        <input name="dateEnd" id="end" class="easyui-datebox"  data-options="required:true"
                               value="${dateEnd}" style="width: 160px; height: 29px">
                    </td>
                    <td>
                        <select name="productType" style="width: 160px" id="productType">
                            <option value="-2">${internationalConfig.全部}</option>
                            <c:forEach items="${productTypes}" var="var">
                                <option value='${var.key}'>${var.key}-${var.value}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td id="productSubtype">
                        <input class="easyui-textbox" name="productSubtype" style="width: 200px; height: 29px"/>
                    </td>
                    <td id="productId">
                        <input class="easyui-textbox" name="productId" style="width: 200px; height: 29px"/>
                    </td>
                    <td>
                        <select name="payChannel" style="width: 220px">
                            <option value="-99">${internationalConfig.全部}</option>
                            <c:forEach items="${payChannels}" var="var">
                                <option value='${var.key}'>${var.key}-${var.value}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <select name="terminal" style="width: 190px">
                            <option value="-2">${internationalConfig.全部}</option>
                            <c:forEach items="${terminals}" var="var">
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
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true"
       onclick="searchFun();">${internationalConfig.查询}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_go',plain:true"
       onclick="exportExcel();">${internationalConfig.导出excel}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_go',plain:true"
       onclick="exportExcelRecord();">${internationalConfig.导出成功订单明细}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'help',plain:true"
       onclick="dataExplain();">${internationalConfig.字段解释}</a>

    <div id="container" style="min-width: 310px; height: 300px; margin: 0 auto; overflow: auto"></div>
</div>
</body>
</html>
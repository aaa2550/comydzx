<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>${internationalConfig.会员订单明细}</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js"
            type="text/javascript"></script>
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
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/v2order/orderDetail/dataGrid');
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
                        field: 'orderCount',
                        title: '${internationalConfig.订单数}',
                        width: 100,
                        sortable: true
                    },
                        {
                            field: 'succCount',
                            title: '${internationalConfig.成功订单数}',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'newCount',
                            title: '${internationalConfig.新增订单数}',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'xufeiCount',
                            title: '${internationalConfig.续费订单数}',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'subscribeCount',
                            title: '${internationalConfig.订阅订单数}',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'autoXufeiCount',
                            title: '${internationalConfig.自动续费订单数}',
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

        function loadChart(rows) {
            $('#container').highcharts({
                chart: {
                    zoomType: 'xy'
                },
                title: {
                    text: '${internationalConfig.订单趋势}',
                    x: -20 //center
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
                            //color: Highcharts.getOptions().colors[2]
                        }
                    },
                    title: {
                        text: '${internationalConfig.订单数}',
                        style: {
                            //color: Highcharts.getOptions().colors[2]
                        }
                    }
                }],
                credits: {
                    enabled: false
                },
                tooltip: {
                    shared: true
                },
                legend: {
                    backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || 'white',
                    layout: 'vertical',
                    align: 'right',
                    verticalAlign: 'top',
                    x: -50,
                    y: 25,
                    floating: true,
                    borderWidth: 1,
                    borderRadius: 5,
                    shadow: false
                },
                series: [
                    {
                        type: 'spline',
                        name: '${internationalConfig.成功订单数}',
                        data: $.map(rows, function (element) {
                            return Number(element['succCount']);
                        }),
                        color: '#3890CD'
                    },
                    {
                        type: 'spline',
                        name: '${internationalConfig.新增订单数}',
                        data: $.map(rows, function (element) {
                            return Number(element['newCount']);
                        }),
                        color: '#22BA66'
                    },
                    {
                        type: 'spline',
                        name: '${internationalConfig.续费订单数}',
                        data: $.map(rows, function (element) {
                            return Number(element['xufeiCount']);
                        }),
                        color: '#FFCB30'
                    }
                ]
            });
        }


        $(function () {
            parent.$.messager.progress('close');
        });

        var cache = {};

        function renderCascade(productSubtype, url, subId) {
            var key = productSubtype;
            if (subId)
                key += "_" + subId;
            if (cache[key]) {
                $('#' + subId).empty().append(cache[key]);
                if (cache[key].indexOf('select'))
                    $('#' + subId + ' select').select2();
                else
                    $('#' + subId + ' input').textbox();
            } else {
                $.getJSON(url, {productSubtype: productSubtype}, function (data) {
                    var str = '';
                    if (data.length > 0) {
                        str = '<select name="' + subId + '" style="width: 200px">';
                        str += '<option value="">${internationalConfig.全部}</option>';
                        $.each(data, function (n, value) {
                            str += "<option value='" + value.id + "'>" + value.id + "-" + value.name + "</option>";
                        });
                        str += '</select>';
                        $('#' + subId).empty().append(str);
                        $('#' + subId + ' select').select2();
                    } else {
                        str = '<input class="easyui-textbox" name="' + subId + '" style="width: 200px; height: 29px"/>';
                        $('#' + subId).empty().append(str);
                        $('#' + subId + ' input').textbox();
                    }
                    cache[key] = str;
                });
            }
        }

        $(function () {
            $('select').select2();
            $('#productSubtype').on('change', function () {
                renderCascade($(this).val(), "${pageContext.request.contextPath}/tj/v2order/orderDetail/productId", "productId");
            });
        });
        function dataExplain() {
            $("#dataExplain").dialog({
                title: '字段解释',
                width: 600,
                height: 200,
                closed: false,
                modal: true
            });
        }
    </script>
    <style>
        .span {
            padding: 10px;
        }

        .dataExplain {
            padding: 10px 10px;
            font-size: 14px;
        }
    </style>
</head>
<body>
<div id="dataExplain" closed="true" class="dataExplain easyui-dialog">
    <p>订单数:总订单数(不过滤订单状态)</p>

    <p>成功订单数 :订单状态为已支付的订单数</p>

    <p>新增订单数:订单状态为已支付的首次购买订单数(之前没购买过)</p>

    <p>续费订单数 :订单状态为已支付的非首次购买订单数(之前购买过)</p>

    <p>订阅订单数:订单状态为已支付的类似于连续包月(订阅类)订单的首次购买订单数</p>

    <p>自动续费订单数:订单状态为已支付的订阅类订单的自动续费订单数(如：连续包月第二个月自动续费)</p>
</div>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
         style="height: 120px; overflow: auto;">
        <form id="searchForm" action="${pageContext.request.contextPath}/tj/v2order/orderDetail/excel" method="post">
            <table class="table table-hover table-condensed">
                <tr>
                    <td>${internationalConfig.开始时间}</td>
                    <td>${internationalConfig.结束时间}</td>
                    <td>${internationalConfig.产品子类型}</td>
                    <td>${internationalConfig.会员类型}</td>
                    <td>${internationalConfig.支付方式}</td>
                    <td>${internationalConfig.终端}</td>
                </tr>
                <tr>
                    <input type="hidden" name="title">
                    <input type="hidden" name="fields">
                    <td>
                        <input name="dateStart" id="begin" class="easyui-datebox" data-options="required:true"
                               value="${dateStart}" style="width: 160px; height: 29px"/>
                    </td>

                    <td>
                        <input name="dateEnd" id="end" class="easyui-datebox" data-options="required:true"
                               value="${dateEnd}" style="width: 160px; height: 29px">
                    </td>
                    <td>
                        <select name="productSubtype" style="width: 160px" id="productSubtype">
                            <option value="-2">${internationalConfig.全部}</option>
                            <c:forEach items="${productTypes}" var="var">
                                <option value='${var.category}'>${var.category}-${var.name}</option>
                            </c:forEach>
                        </select>
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
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'help',plain:true"
       onclick="dataExplain();">${internationalConfig.字段解释}</a>

    <div id="container" style="min-width: 310px; height: 300px; margin: 0 auto; overflow: auto"></div>
</div>
</body>
</html>
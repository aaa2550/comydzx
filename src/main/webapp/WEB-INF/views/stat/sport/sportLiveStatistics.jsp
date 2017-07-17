<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
<title>英超直播统计</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<c:if
        test="${fn:contains(sessionInfo.resourceList, '/coupon/freeze')}">
    <script type="text/javascript">
        $.canfreeze = true;
    </script>
</c:if>
<c:if
        test="${fn:contains(sessionInfo.resourceList, '/coupon/unfreeze')}">
    <script type="text/javascript">
        $.canunfreeze = true;
    </script>
</c:if>


<script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>
<script type="text/javascript">
var dataGrid;
$(function () {
    dataGrid = renderDataGrid('${pageContext.request.contextPath}/sportsstat/query/live');
});

function renderDataGrid(url) {
    return $('#dataGrid').datagrid({
        url: url,
        fit: true,
        fitColumns: false,
        border: false,
        pagination: true,
        idField: 'id',
        pageSize: 10,
        pageList: [ 10, 20, 30, 40, 50 ],
        sortName: 'gameTime',
        sortOrder: 'desc',
        checkOnSelect: false,
        selectOnCheck: false,
        nowrap: false,
        striped: true,
        rownumbers: true,
        singleSelect: true,
        remoteSort: false,
        frozenColumns: [
            [
            ]
        ],
        columns: [
            [
				{
				    field: 'gameId',
				    title: '场次ID',
				    width: '150',
				    sortable: true
				},                
                {
                    field: 'liveId',
                    title: '直播ID',
                    width: '150',
                    sortable: true
                },
                {
                    field: 'gameName',
                    title: '直播名称',
                    width: '150',
                    sortable: true
                },
                {
                    field: 'gameTime',
                    title: '直播时间',
                    width: '150',
                    sortable: true
                }, 
                {
                    field: 'uv',
                    title: '观看人数(UV)',
                    width: '150',
                    sortable: true
                },
                {
                    field: 'vv',
                    title: '观看次数(VV)',
                    width: '150',
                    sortable: true
                },
                {
                    field: 'onlineUv',
                    title: '最高在线人数',
                    width: '150',
                    sortable: true
                }
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
    dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
}
function cleanFun() {
    $('#searchForm input').val('');
    dataGrid.datagrid('load', {});
}


$(function () {
    parent.$.messager.progress('close');
});


function loadChart(data) {
    var rows = data['rows']
    $('#container').highcharts({
        chart: {
            type: 'spline'
        },
        title: {
            text: '直播观看趋势'
        },
        subtitle: {
            text: ''
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
                return element['gameName'];
            }),
            title: {
                text: '直播名称'
            }

        },
        yAxis: {
            title: {
                text: '次数'
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
            min: 0,
            max: Math.max.apply(null, $.map(rows, function (element) {
                return element['vv']
            })) * 1.1
        },
        tooltip: {
            crosshairs: true,
            shared: true
        },
        plotOptions: {
            spline: {
                marker: {
                    radius: 4,
                    lineColor: '#666666',
                    lineWidth: 1
                }
            }
        },
        series: [
            {
                name: 'UV',
                data: $.map(rows, function (element) {
                    return element['uv'];
                })
            },
            {
                name: 'VV',
                data: $.map(rows, function (element) {
                    return element['vv'];
                })
            }
            /**,
            {
                name: '最高在线人数',
                data: $.map(rows, function (element) {
                    return element['onlineUv'];
                })
            }*/
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
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>终端</td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <input name="beginDate" class="easyui-datebox" data-options="required:true" value="${start}" style="width: 160px; height: 29px"/>
                    </td>

                    <td>
                        <input name="endDate" class="easyui-datebox" data-options="required:true" value="${end}" style="width: 160px; height: 29px">
                    </td>
                    <td><select name="terminal" style="width: 140px"
							id="terminal">
								<option value="112">PC</option>
								<option value="130">Mobile</option>
								<!-- <option value="111">tv</option>
								<option value="-3">M站</option> -->
						</select></td>
                    <td></td>
                    <td></td>
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
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a><a
        href="javascript:void(0);" class="easyui-linkbutton"
        data-options="iconCls:'brick_delete',plain:true"
        onclick="cleanFun();">清空条件</a>

    <div id="container" style="min-width: 310px; height: 220px; margin: 0 auto; overflow: auto"></div>
</div>


</body>
</html>
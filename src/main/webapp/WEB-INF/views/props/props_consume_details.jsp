<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>道具消耗明细</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script  src="/js/kv/propsBusiness.js"></script>
    <style type="text/css">
        table tr td b {
            text-align: center;
            font-size: 32px;
        }

        table tr td:first-child b {
            color: red;
        }

        div[class="easyui-panel panel-body"] {
            overflow: hidden;
        }
        .nomargin{
        	margin-left:0px;
        }
    </style>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            var params = $.serializeObject($('#searchForm'));
            loadSummaryData(params);
            dataGrid = renderDataGrid('/props_consume_details/query', params);
        });

        function renderDataGrid(url, params) {
            return $('#dataGrid').datagrid({
                url: url,
                queryParams: params,
                fit: true,
                fitColumns: false,
                border: false,
                idField: 'id',
                pagination: true,
                pageSize: 10,
                pageList: [10, 20, 30, 40, 50],
                sortName: 'createTime',
                sortOrder: 'desc',
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                striped: true,
                rownumbers: true,
                singleSelect: false,
                remoteSort: false,
                columns: [
                    [
                        {
                            field: 'pid',
                            title: '道具ID',
                            width: 100
                        },
                        {
                            field: 'name',
                            title: '道具名称',
                            width: 100
                        },
                        {
                            field: 'terminalName',
                            title: '终端',
                            width: 50
                        },
                        {
                            field: 'businessId',
                            title: '业务线',
                            width: 50,
                            formatter: function (value, row, index) {
                            	return Dict.propsBusiness[value];
                            }
                        },
                        {
                            field: 'uid',
                            title: '用户ID',
                            width: 100
                        },
                        {
                            field: 'username',
                            title: '用户名称',
                            width: 100
                        },
                        {
                            field: 'liveId',
                            title: '直播ID',
                            width: 150
                        },
                        {
                            field: 'liveName',
                            title: '直播名称',
                            width: 100
                        },
                        {
                            field: 'starId',
                            title: '明星ID',
                            width: 150,
                            formatter: function (value, row, index) {
                                return value == 0 ? '' : value;
                            }
                        },
                        {
                            field: 'starName',
                            title: '明星名称',
                            width: 100
                        },
                        {
                            field: 'price',
                            title: '乐币',
                            width: 50
                        },
                        {
                            field: 'createTime',
                            title: '消耗时间',
                            width: 150
                        }
                    ]
                ],
                toolbar: '#toolbar',
                onLoadSuccess: function () {
                    $('#searchForm table').show();
                    parent.$.messager.progress('close');
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

        function loadSummaryData(params) {
            $.get("/props_consume_details/query_props_stat", params, function (data) {
                if (data) {
                    $("#totalPrice").html(data.totalPrice ? data.totalPrice : 0);
                    $("#freeCount").html(data.freeCount);
                    $("#payCount").html(data.payCount);
                    $("#propsCount").html(data.propsCount);
                }
            }, "json");
        }

        function searchFun() {
            if (validation()) {
                var params = $.serializeObject($('#searchForm'));
                loadSummaryData(params);
                dataGrid.datagrid('load', params);
            }
        }

        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }

        function validation() {
            var startTime = $("input[name=createTime]").val();
            var endTime = $("input[name=updateTime]").val();

            if (!startTime || !endTime) {
                alert("请选择时间跨度！");
                return false;
            }
            var days=Math.abs(((new Date(Date.parse(endTime)) - new Date(Date.parse(startTime))) / 1000 / 60 / 60 / 24))
            if (days >30 ) {
                alert("只允许查询30天内数据！");
                return false;
            }

           var liveId = $("input[name=liveId]").val();
            var propsKey = $("input[name=propsKey]").val();
            var starId = $("input[name=starId]").val();
            if (!liveId && !propsKey && !starId && days>7) {
                alert("道具ID/直播ID/明星ID 都不存在的时候，只允许查询7天数据");
                return false;
            }
            return true;
        }

        function exportFile() {

            if (validation()) {
                var startTime = $("input[name='createTime']").val();
                var endTime = $("input[name='updateTime']").val();
                var propsKey = $("input[name='propsKey']").val();
                var liveId = $("input[name='liveId']").val();
                var starId = $("input[name='starId']").val();

                var url = '/props_consume_details/export?createTime=' + startTime + '&updateTime=' + endTime + '&propsKey=' + propsKey + ''
                        + '&liveId=' + liveId + '&starId' + starId;
                location.href = url;
            }
        }

    </script>
</head>
<body>
<div class="easyui-panel" title="查询条件">
    <form id="searchForm">
        <input type="hidden" name="pid" value="${pid}">
        <table class="table-more">
            <tr>
                <td width="500px">
                    时间段：
                    <input class="easyui-datetimebox" name="createTime" value="${startTime}" validType="TimeCheck"
                           data-options="required:true" style="width: 150px">&nbsp;&nbsp;
                    <input class="easyui-datetimebox" name="updateTime" value="${endTime}" validType="TimeCheck"
                           data-options="required:true" style="width: 150px">
                </td>
                <td>
                    直播ID：<input name="liveId" class="easyui-textbox" data-options="prompt:'请输入直播ID'"
                                style="width: 310px" class="span2">
                </td>
            </tr>
            <tr>
                <td>
                    道具名称：<input name="propsKey" class="easyui-textbox" data-options="prompt:'请输入道具ID\\道具名称'"
                                style="width: 310px" class="span2">
                </td>
                <td>
                    明星ID：<input name="starId" class="easyui-numberbox" data-options="prompt:'请输入明星ID'"
                                style="width: 310px" class="span2">
                </td>
            </tr>
            <tr>
                <td>业务线：<%@ include file="/WEB-INF/views/inc/props_business.inc" %></td>

            </tr>
        </table>
    </form>
</div>
<div class="easyui-panel">
    <table class="table-more nomargin">
        <tr>
            <td>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<ur>乐币总数：<b id="totalPrice"><fmt:formatNumber value='${totalPrice}' pattern='###,###,###,###'/></b></ur>
            </td>
            <td>
                免费总次数：<b id="freeCount"><fmt:formatNumber value='${freeCount}' pattern='###,###,###,###'/></b>
            </td>
            <td>
                付费总次数：<b id="payCount"><fmt:formatNumber value='${payCount}' pattern='###,###,###,###'/></b>
            </td>
            <td>
                道具总数：<b id="propsCount"><fmt:formatNumber value='${propsCount}' pattern='###,###,###,###'/></b>
            </td>
        </tr>
    </table>
</div>

<div style="height: 400px">
    <table id="dataGrid"></table>
</div>

<div id="toolbar" style="display: none;">
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_delete',plain:true"
       onclick="cleanFun();">清空条件</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="exportFile();">导出数据</a>
</div>
</body>
</html>
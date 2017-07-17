<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>TV全屏影视会员统计</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">

        var dataGrid;

        $(function () {
            parent.$.messager.progress('close');
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/activity_tv/dataGrid');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').bossDataGrid({
                url: url,
                sortName: 'dt',
                sortOrder: 'desc',
                queryParams: {
                    sdate: $("#begin").val(),
                    edate: $("#end").val(),
                    viplen: $("#viplenid").val(),
                    device: $("#deviceid").val()
                },
                columns: [
                    {
                        field: 'dt',
                        title: '日期',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'userNum',
                        title: '活跃用户数',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'unloginUserNum',
                        title: '未登录用户数',
                        width: 100
                    },
                    {
                        field: 'loginUserNum',
                        title: '登录用户数',
                        width: 100
                    },
                    {
                        field: 'vipUserNum',
                        title: '会员用户数',
                        width: 100
                    },

                    {
                        field: 'payUserNum',
                        title: '支付人数',
                        width: 100
                    },
                    {
                        field: 'orderNum',
                        title: '订单',
                        width: 100
                    },
                    {
                        field: 'payMoney',
                        title: '金额',
                        width: 100
                    },
                    {
                        field: 'paySuccRate',
                        title: '支付成功率',
                        width: 100
                    },
                    {
                        field: 'loginRate',
                        title: '登录率',
                        width: 100
                    }
                ]
            });
        }
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }
        function searchFun() {
            if ($("input[name='sdate']").dateDiff($("input[name='edate']").val()) < 61) {
                dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
            } else {
                parent.$.messager.alert("提示", "查询时间范围最多为60天!");
            }
        }

        function exportFile() {
            var startDate = $('#begin').datetimebox("getValue");
            var endDate = $('#end').datetimebox("getValue");
            var device = $('#deviceid').val();
            var viplen = $('#viplenid').val();
            var url = '${pageContext.request.contextPath}/tj/activity_tv/export?device=' + device + '&sdate=' + startDate + '&edate=' + endDate + '&viplen=' + viplen;
            location.href = url;
        }
    </script>
</head>

<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false" style="height: 120px; overflow: auto;">
        <form id="searchForm">
            <table class="table table-hover table-condensed">
                <tr>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>终端</td>
                    <td>会员期限</td>
                </tr>
                <tr>
                    <td>
                        <input name="sdate" id="begin" class="easyui-datebox" data-options="required:true" value="${sdate}"
                               style="width: 160px; height: 29px"/>
                    </td>

                    <td>
                        <input name="edate" id="end" class="easyui-datebox" data-options="required:true" value="${edate}"
                               style="width: 160px; height: 29px"/>
                    </td>
                    <td>
                        <select name="device" style="width: 160px" id="deviceid">
                            <option value="tv_all" selected="selected">TV联网</option>
                            <option value="tv_21">TV版</option>
                        </select>
                    </td>

                    <td>
                        <select name="viplen" style="width: 160px" id="viplenid">
                            <option value="-2" selected="selected">全部</option>
                            <option value="lt30">小于30天</option>
                            <option value="gt30">大于等于30天</option>
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
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="exportFile();">导出文件</a>
</div>

</body>
</html>
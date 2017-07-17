<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>自动续费统计</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            dataGrid = $('#dataGrid').datagrid({
                url: '${pageContext.request.contextPath}/vipController/autorenewConsume',
                fit: true,
                fitColumns: true,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 20,
                pageList: [10, 20, 30, 40, 50],
                sortName: 'ptime',
                sortOrder: 'desc',
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                striped: true,
                rownumbers: true,
                singleSelect: true,
                frozenColumns: [
                    [
                        {
                            field: 'id',
                            title: '编号',
                            width: 150,
                            hidden: true
                        }
                    ]
                ],
                columns: [
                    [
                        {
                            field: 'ptime',
                            title: '日期',
                            width: 70,
                            sortable: true
                        },
                        {
                            field: 'newAutorenewPerson',
                            title: '新增自动续费人数',
                            width: 70
                        },
                        {
                            field: 'autorenewOrderIncome',
                            title: '新增自动续费订单收入',
                            width: 70
                        },
                        {
                            field: 'totalAutorenewPerson',
                            title: '累计自动续费人数',
                            width: 70
                        },
                        {
                            field: 'toPayCount',
                            title: '自动续费应扣款人数',
                            width: 70
                        },
                        {
                            field: 'paySuccessCount',
                            title: '自动续费扣款成功人数',
                            width: 70
                        },
                        {
                            field: 'autorenewIncome',
                            title: '自动续费扣款收入',
                            width: 70
                        },
                        {
                            field: 'renewRate',
                            title: '自动续费成功率',
                            width: 70
                        },
                        {
                            field: 'unbindPerson',
                            title: '暂停自动续费人数',
                            width: 70
                        },
                        {
                            field: 'totalPausePerson',
                            title: '累计暂停自动续费人数',
                            width: 70
                        },
                        {
                            field: 'restorePerson',
                            title: '恢复自动续费人数',
                            width: 70
                        }
                    ]
                ],
                toolbar: '#toolbar',
                onLoadSuccess: function () {
                    $("#searchForm table").show();
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
        });

        function searchFun() {
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }
        function searchMonth() {
            var tDate = new Date();
            var tYear = tDate.getFullYear();
            var tMonth = tDate.getMonth() + 1;
            var tDay = tDate.getDate();
            if (tMonth < 10) {
                tMonth = "0" + tMonth;
            }
            if (tDay < 10) {
                tDay = "0" + tDay;
            }
            var clock = tYear + "-" + tMonth + "-" + tDay;
            var beginDate = reduceByTransDate(clock, 30);
            $("#end").datebox('setValue', clock);
            $("#begin").datebox('setValue', beginDate);
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }

        function addByTransDate(dateParameter, num) {

            var translateDate = "", dateString = "", monthString = "", dayString = "";
            translateDate = dateParameter.replace("-", "/").replace("-", "/");

            var newDate = new Date(translateDate);
            newDate = newDate.valueOf();
            newDate = newDate + num * 24 * 60 * 60 * 1000;
            newDate = new Date(newDate);

            //如果月份长度少于2，则前加 0 补位
            if ((newDate.getMonth() + 1).toString().length == 1) {
                monthString = 0 + "" + (newDate.getMonth() + 1).toString();
            } else {
                monthString = (newDate.getMonth() + 1).toString();
            }

            //如果天数长度少于2，则前加 0 补位
            if (newDate.getDate().toString().length == 1) {

                dayString = 0 + "" + newDate.getDate().toString();
            } else {

                dayString = newDate.getDate().toString();
            }

            dateString = newDate.getFullYear() + "-" + monthString + "-" + dayString;
            return dateString;
        }

        function reduceByTransDate(dateParameter, num) {

            var translateDate = "", dateString = "", monthString = "", dayString = "";
            translateDate = dateParameter.replace("-", "/").replace("-", "/");

            var newDate = new Date(translateDate);
            newDate = newDate.valueOf();
            newDate = newDate - num * 24 * 60 * 60 * 1000;
            newDate = new Date(newDate);

            //如果月份长度少于2，则前加 0 补位
            if ((newDate.getMonth() + 1).toString().length == 1) {

                monthString = 0 + "" + (newDate.getMonth() + 1).toString();
            } else {

                monthString = (newDate.getMonth() + 1).toString();
            }

            //如果天数长度少于2，则前加 0 补位
            if (newDate.getDate().toString().length == 1) {
                dayString = 0 + "" + newDate.getDate().toString();
            } else {
                dayString = newDate.getDate().toString();
            }

            dateString = newDate.getFullYear() + "-" + monthString + "-" + dayString;
            return dateString;
        }
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false" style="height: 80px; overflow: hidden;">
        <form id="searchForm">
            <table class="table table-hover table-condensed" style="display: none;">
                <tr>
                    <th></th>
                    <td>开始日期：<input id="begin" name="beginDate" value="${beginDate}" class="easyui-datebox"/></td>
                    <td>截至日期：<input id="end" name="endDate" value="${endDate}" class="easyui-datebox"/></td>
                    <td>会员类型：
                        <select name="vipType" id="vipType">
                            <option value="0">全部</option>
                            <option value="1">普通会员</option>
                            <option value="9">高级会员</option>
                        </select>
                    </td>
                    <td>支付类型：
                        <select name="payType" id="paytype">
                            <option value="0">全部</option>
                            <option value="8">支付宝</option>
                            <option value="24">微信</option>
                        </select>
                    </td>
                    <th></th>
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
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">过滤条件</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="searchMonth();">查询最近30天</a>
</div>
</body>
</html>
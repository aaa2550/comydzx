<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>综合对账</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>
    <script type="text/javascript">
        var rows;
        var dataGrid;
        $(function () {
            parent.$.messager.progress('close');

            //商户号和公司级联
            var loadCompany = function() {
                var signnumber = $("#signnumber option:selected").val();
                $.get("${pageContext.request.contextPath}/tj/jtStatController/list_company", "signnumber=" + signnumber, function (data) {
                    $("#companyid").find("option").remove();
                    var company = data.data;
                    $("#companyid").append("<option value='-2'>全部</option>");
                    for (var i = 0; i < company.length; i++) {
                        var tmp = company[i];
                        for (var key in tmp) {
                            $("#companyid").append("<option value=" + key + ">" + tmp[key] + "</option>");
                        }
                    }
                }, "json");
            };

            //商户号和公司级联
            $(document).on("change", "#signnumber", function () {
                var partner = $(this).find("option:selected");
                loadCompany();
                var content = partner.text();
                if (content.indexOf("易宝") != -1) {
                    $("#yeePayButton").show();
                }
                else {
                    $("#yeePayButton").hide();
                }
            });
            //公司和业务线级联
            $(document).on("change", "#companyid", function () {
                var companyid = $("#companyid option:selected").val();
                $.get("${pageContext.request.contextPath}/tj/jtStatController/list_business", "companyid=" + companyid, function (data) {
                    $("#businessid").find("option").remove();
                    var business = data.data;
                    $("#businessid").append("<option value='-2'>全部</option>");
                    for (var i = 0; i < business.length; i++) {
                        var tmp = business[i];
                        for (var key in tmp) {
                            $("#businessid").append("<option value=" + key + ">" + tmp[key] + "</option>");
                        }
                    }
                }, "json");
            });

            loadCompany();
            //加载表格
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/jtStatController/compare_bill_grid');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').datagrid({
                url: url,
                fit: true,
                fitColumns: false,
                border: false,
                pagination: true,
                idField: 'paydate',
                pageSize: 20,
                pageList: [10, 20, 50, 100],
                sortName: 'paydate',
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
                            field: 'paydate',
                            title: '日期',
                            width: 130
                        },
                        {
                            field: 'signnumber',
                            title: '商户号',
                            width: 130
                        },
                        {
                            field: 'channelNum',
                            title: '支付渠道订单数',
                            width: 130
                        },
                        {
                            field: 'payNum',
                            title: '支付系统订单数',
                            width: 130
                        },
                        {
                            field: 'channelMoney',
                            title: '支付渠道订单金额',
                            width: 130
                        },
                        {
                            field: 'payMoney',
                            title: '支付系统订单金额',
                            width: 130
                        },
                        {
                            field: 'channelRefundNum',
                            title: '支付渠道退款数',
                            width: 130
                        },
                        {
                            field: 'payRefundNum',
                            title: '支付系统退款数',
                            width: 130
                        },
                        {
                            field: 'channelRefundMoney',
                            title: '支付渠道退款金额',
                            width: 130
                        },
                        {
                            field: 'payRefundMoney',
                            title: '支付系统退款金额',
                            width: 130
                        }
                    ]
                ],
                toolbar: '#toolbar',
                onLoadSuccess: function (data) {
                    parent.$.messager.progress('close');
                    rows = data['rows'];
                },
                onRowContextMenu: function (e, rowIndex, rowData) {
                    e.preventDefault();
                    $(this).datagrid('unselectAll');
                    $(this).datagrid('selectRow', rowIndex);
                    $('#menu').menu('show', {
                        left: e.pageX,
                        top: e.pageY
                    });
                },
                queryParams: {
                    signnumber: $("#signnumber").val(),
                    startDate: $("#queryBegin").val(),
                    endDate: $("#queryEnd").val()
                }
            });
        }

        function searchFun() {
            var s = $("#queryBegin").val();
            var s1 = $("#queryEnd").val();
            if ((new Date(Date.parse(s1)) < new Date(Date.parse(s)))) {
                alert("对账结束日期不能小于起始日期!!!");
                return;
            }
            if (Math.abs(((new Date(Date.parse(s1)) - new Date(Date.parse(s))) / 1000 / 60 / 60 / 24)) - 32 < 0) {
                dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
            } else {
                alert("对账时间范围最多为31天!!!");
            }
        }
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }

        function importFile() {
            parent.$.modalDialog({
                title: '导入对账文件',
                width: 680,
                height: 300,
                href: '${pageContext.request.contextPath}/balanceAccount/importView',
                buttons: [
                    {
                        text: '导入文件',
                        handler: function () {
                            parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                            var f = parent.$.modalDialog.handler.find('#form');
                            f.submit();
                        }
                    },
                    {
                        text: "关闭",
                        handler: function () {
                            parent.$.modalDialog.handler.dialog('close');
                        }
                    }
                ]
            });
        }

        function exportPaymentFile() {
            var startDate = $('#queryBegin').datetimebox("getValue");
            var endDate = $('#queryEnd').datetimebox("getValue");
            var signnumber = $('#signnumber').val();
            var companyid = $("#companyid option:selected").val();
            var businessid = $("#businessid option:selected").val();
            location.href = '${pageContext.request.contextPath}/tj/jtStatController/export_compare_bill_pay?signnumber='
                    + signnumber + '&startDate=' + startDate + '&endDate=' + endDate + '&companyid=' + companyid + '&businessid=' + businessid;
        }


        function exportRefundFile() {
            var startDate = $('#queryBegin').datetimebox("getValue");
            var endDate = $('#queryEnd').datetimebox("getValue");
            var signnumber = $('#signnumber').val();
            var companyid = $("#companyid option:selected").val();
            var businessid = $("#businessid option:selected").val();
            location.href = '${pageContext.request.contextPath}/tj/jtStatController/export_compare_bill_refund?signnumber='
                    + signnumber + '&startDate=' + startDate + '&endDate=' + endDate + '&companyid=' + companyid + '&businessid=' + businessid;
        }


        /**
         * 导入易宝支付账单
         */
        function importYeePayFile() {
            var signnumber = $("#signnumber option:selected").val();
            parent.$.modalDialog({
                title: '导入对账文件',
                width: 680,
                height: 300,
                href: '${pageContext.request.contextPath}/tj/jtStatController/importYeePayFile/' + signnumber,
                buttons: [
                    {
                        text: '导入文件',
                        handler: function () {
                            parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                            var f = parent.$.modalDialog.handler.find('#form');
                            f.submit();
                        }
                    },
                    {
                        text: "关闭",
                        handler: function () {
                            parent.$.modalDialog.handler.dialog('close');
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
         style="height: 100px; overflow: auto;padding-top: 20px;padding-left: 20px">

        <form id="searchForm">
            <table style=>
                <tr>
                    <td>商户号&nbsp;
                        <select name="signnumber" id="signnumber" style="width: 250px; height: 29px;" id="two">
                            <c:forEach items="${signnumbers}" var="sign">
                                <option value='${sign.signnumber}'>[${sign.name}]${sign.signnumber}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td style="padding-left: 20px">公司&nbsp;
                        <select name="companyid" id="companyid" style="width: 250px; height: 29px">
                            <option value="-2">全部</option>
                        </select>
                    </td>
                    <td style="padding-left: 20px">业务线&nbsp;
                        <select name="businessid" id="businessid" style="width: 250px; height: 29px">
                            <option value="-2">全部</option>
                        </select>
                    </td>
                    <td style="padding-left: 50px">
                        对账时间
                        <input name="startDate" id="queryBegin" class="easyui-datebox" data-options="required:true" value="${startDate}"
                               style="width: 160px; height: 29px"/>&nbsp;&nbsp;
                        <input name="endDate" id="queryEnd" class="easyui-datebox" data-options="required:true" value="${endDate}"
                               style="width: 160px; height: 29px">
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
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="exportPaymentFile();">导出支付对账明细</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="exportRefundFile();">导出退款对账明细</a>
    <a id="yeePayButton" href="javascript:void (0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="importYeePayFile();" style="display: none">导入易宝支付对账单</a>
</div>

</body>
</html>
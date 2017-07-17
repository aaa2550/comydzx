<%--
  Created by IntelliJ IDEA.
  User: kangxiongwei3
  Date: 2016/11/15
  Time: 15:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>支付订单查询</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            parent.$.messager.progress('close');
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/payinfo/payment/list');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').bossDataGrid({
                url: url,
                sortName: 'paymentdate',
                sortOrder: 'desc',
                queryParams: {
                    startDate: $("input[name='startDate']").val(),
                    endDate: $("input[name='endDate']").val()
                },
                columns: [
                    {
                        field: 'paymentdate',
                        title: '支付时间',
                        width: 110
                    },
                    {
                        field: 'status',
                        title: '订单状态',
                        width: 50,
                        formatter: function (row) {
                            var status;
                            switch (row) {
                                case 0:
                                    status = "未支付";
                                    break;
                                case 1:
                                    status = "支付成功";
                                    break;
                                case 2:
                                    status = "部分退款";
                                    break;
                                case 3:
                                    status = "全部退款";
                                    break;
                                case 4:
                                    status = "支付失败";
                                    break;
                                default :
                                    status = row;
                                    break;
                            }
                            return status;
                        }
                    },
                    {
                        field: 'userid',
                        title: '用户ID',
                        width: 70
                    },
                    {
                        field: 'ordernumber',
                        title: '支付流水号',
                        width: 160
                    }, {
                        field: 'lepayorderno',
                        title: '支付订单号',
                        width: 160
                    },
                    {
                        field: 'companyorderno',
                        title: '商户订单号',
                        width: 90
                    },
                    {
                        field: 'companyseq',
                        title: '商户流水号',
                        width: 90
                    },
                    {
                        field: 'channelseq',
                        title: '第三方流水',
                        width: 90
                    },
                    {
                        field: 'price',
                        title: '支付金额',
                        width: 50
                    },
                    {
                        field: 'channelId',
                        title: '支付渠道',
                        width: 50
                    },
                    {
                        field: 'productname',
                        title: '产品名称',
                        width: 120
                    },
                    {
                        field: 'paymentext',
                        title: '流水扩展信息',
                        width: 90
                    },
                    {
                        field: 'orderext',
                        title: '订单扩展信息',
                        width: 90
                    },
                    {
                        field: 'errormsg',
                        title: '错误信息',
                        width: 90
                    },
                    {
                        field: 'ip',
                        title: '支付IP',
                        width: 80
                    }
                ]
            });
        }

        function searchFun() {
            var array = $.serializeObject($('#searchForm'));
            if (!array.userid && !array.ordernumber && !array.lepayorderno && !array.channelseq && !array.companyorderno) {
                parent.$.messager.alert("提示", "请至少输入用户ID，支付流水号，支付订单号，第三方流水，商户订单号其中一个");
            } else {
                dataGrid.datagrid('load', array);
            }
        }
        function cleanFun() {
            var ele = $("#searchForm");
            ele.find('input').val('');
            ele.find("select option:selected").removeAttr("selected");
            dataGrid.datagrid('load', {});
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false" style="height: 120px; overflow-y: hidden; overflow-x: auto">
        <form id="searchForm" method="post">
            <table class="table table-hover table-condensed">
                <tr>
                    <th>开始日期</th>
                    <th>结束日期</th>
                    <th>用户ID</th>
                    <th>支付流水号</th>
                    <th>支付订单号</th>
                    <th>商户流水号</th>
                    <th>第三方流水</th>
                    <th>支付状态</th>
                </tr>
                <tr>
                    <td>
                        <input name="startDate" class="easyui-datebox" value="${startDate}"/>
                    </td>
                    <td>
                        <input name="endDate" class="easyui-datebox" value="${endDate}"/>
                    </td>
                    <td>
                        <input name="userid" class="easyui-textbox"/>
                    </td>
                    <td>
                        <input name="ordernumber" class="easyui-textbox"/>
                    </td>
                    <td>
                        <input name="lepayorderno" class="easyui-textbox"/>
                    </td>
                    <td>
                        <input name="companyorderno" class="easyui-textbox"/>
                    </td>
                    <td>
                        <input name="channelseq" class="easyui-textbox"/>
                    </td>
                    <td>
                        <select name="status" class="easyui-combobox" style="width: 150px">
                            <option value="">全部</option>
                            <option value="0">未支付</option>
                            <option value="1">支付成功</option>
                            <option value="2">部分退款</option>
                            <option value="3">全部退款</option>
                        </select>
                    </td>
                </tr>
            </table>
        </form>
    </div>
    <div data-options="region:'center',border:false" style="overflow: hidden">
        <table id="dataGrid"></table>
    </div>
</div>
<div id="toolbar" style="display: none;">
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_search',plain:true" onclick="searchFun();">查询</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">清空条件</a>
</div>
</body>
</html>

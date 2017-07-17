<%--
  Created by IntelliJ IDEA.
  User: kangxiongwei3
  Date: 2016/11/15
  Time: 17:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>退款订单查询</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            parent.$.messager.progress('close');
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/payinfo/refund/list');
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
                        title: '退款时间',
                        width: 110
                    },
                    {
                        field: 'status',
                        title: '退款状态',
                        width: 50,
                        formatter: function (row) {
                            var status;
                            switch (row) {
                                case 0:
                                    status = "初始";
                                    break;
                                case 1:
                                    status = "退款成功";
                                    break;
                                case 2:
                                    status = "退款失败";
                                    break;
                                case 3:
                                    status = "提交成功";
                                    break;
                                case 4:
                                    status = "提交失败";
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
                        title: '原支付流水号',
                        width: 160
                    },
                    {
                        field: 'lepayorderno',
                        title: '原支付订单号',
                        width: 160
                    },
                    {
                        field: 'refundno',
                        title: '退款流水号',
                        width: 100
                    },
                    {
                        field: 'outrefundno',
                        title: '商户退款流水号',
                        width: 100
                    },
                    {
                        field: 'price',
                        title: '退款金额',
                        width: 50
                    },
                    {
                        field: 'companyseq',
                        title: '商户流水号',
                        width: 90
                    },
                    {
                        field: 'channelseq',
                        title: '原第三方流水',
                        width: 90
                    },
                    {
                        field: 'refundtranseq',
                        title: '第三方流水',
                        width: 90
                    },
                    {
                        field: 'errormsg',
                        title: '错误信息',
                        width: 90
                    }
                ]
            });
        }

        function searchFun() {
            var array = $.serializeObject($('#searchForm'));
            dataGrid.datagrid('load', array);
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
                    <th>退款流水号</th>
                    <th>原支付流水号</th>
                    <th>原支付订单号</th>
                    <th>商户流水号</th>
                    <th>原第三方流水</th>
                    <th>商户退款流水号</th>
                    <th>退款状态</th>
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
                        <input name="refundno" class="easyui-textbox"/>
                    </td>
                    <td>
                        <input name="ordernumber" class="easyui-textbox"/>
                    </td>
                    <td>
                        <input name="lepayorderno" class="easyui-textbox"/>
                    </td>
                    <td>
                        <input name="companyseq" class="easyui-textbox"/>
                    </td>
                    <td>
                        <input name="channelseq" class="easyui-textbox"/>
                    </td>
                    <td>
                        <input name="outrefundno" class="easyui-textbox"/>
                    </td>
                    <td>
                        <select name="status" class="easyui-combobox" style="width: 150px">
                            <option value="">全部</option>
                            <option value="0">初始</option>
                            <option value="1">退款成功</option>
                            <option value="2">退款失败</option>
                            <option value="3">提交成功</option>
                            <option value="4">提交失败</option>
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

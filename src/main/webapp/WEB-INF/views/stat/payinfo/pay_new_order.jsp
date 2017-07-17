<%--
  Created by IntelliJ IDEA.
  User: kangxiongwei3
  Date: 2016/9/27
  Time: 11:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>会员订单查询</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            parent.$.messager.progress('close');
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/payinfo/order/list');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').bossDataGrid({
                url: url,
                sortName: 'paytime',
                sortOrder: 'desc',
                queryParams: {
                    startDate: $("input[name='startDate']").val(),
                    endDate: $("input[name='endDate']").val()
                },
                columns: [
                    {
                        field: 'orderid',
                        title: '订单ID',
                        width: 90
                    },
                    {
                        field: 'ordername',
                        title: '订单名称',
                        width: 150
                    }, {
                        field: 'userid',
                        title: '用户ID',
                        width: 70
                    },
                    {
                        field: 'username',
                        title: '用户名称',
                        width: 70
                    },
                    {
                        field: 'money',
                        title: '支付金额',
                        width: 50
                    },
                    {
                        field: 'status',
                        title: '订单状态',
                        width: 50
                    },
                    {
                        field: 'paytime',
                        title: '支付时间',
                        width: 120
                    },
                    {
                        field: 'createtime',
                        title: '开始时间',
                        width: 120
                    },
                    {
                        field: 'canceltime',
                        title: '结束时间',
                        width: 120
                    },
                    {
                        field: 'ordertype',
                        title: '订单类型',
                        width: 50
                    },
                    {
                        field: 'orderfrom',
                        title: '订单来源',
                        width: 50
                    },
                    {
                        field: 'suborderfrom',
                        title: '订单子来源',
                        width: 60
                    },
                    {
                        field: 'payChannel',
                        title: '支付渠道',
                        width: 50
                    },
                    {
                        field: 'pfrom',
                        title: '支付平台',
                        width: 50
                    },
                    {
                        field: 'userip',
                        title: '用户IP',
                        width: 80
                    },
                    {
                        field: 'ext',
                        title: '扩展信息',
                        width: 230
                    }
                ]
            });
        }

        function searchFun() {
            var userid = $("input[name='userid']").val();
            if(userid == null || userid == '') {
                parent.$.messager.alert("提示", "必须输入用户ID");
            } else {
                dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
            }
        }
        function cleanFun() {
            var ele = $("#searchForm");
            ele.find('input').val('');
            ele.find("select option:selected").removeAttr("selected");
            dataGrid.datagrid('load', {});
        }
        function exportFile() {
            var params = $("#searchForm").serialize();
            var url = '${pageContext.request.contextPath}/tj/payinfo/order/export?' + params;
            location.href = url;
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false" style="height: 120px; overflow: auto;">
        <form id="searchForm" method="post">
            <table class="table table-hover table-condensed">
                <tr>
                    <th>开始日期</th>
                    <th>结束日期</th>
                    <th>用户ID</th>
                    <th>订单ID</th>
                    <th>支付渠道</th>
                    <th>订单状态</th>
                </tr>
                <tr>
                    <td>
                        <input name="startDate" class="easyui-datebox" value="${startDate}"/>
                    </td>
                    <td>
                        <input name="endDate" class="easyui-datebox" value="${endDate}"/>
                    </td>
                    <td>
                        <input name="userid" class="easyui-validatebox" data-options="required:true"/>
                    </td>
                    <td>
                        <input name="orderid" class="easyui-textbox"/>
                    </td>
                    <td>
                        <select name="payChannel" class="easyui-combobox" style="width: 150px">
                            <option value="">全部</option>
                            <c:forEach items="${payChannels}" var="payChannel">
                                <option value="${payChannel.key}">${payChannel.value}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <select name="status" class="easyui-combobox" style="width: 150px">
                            <option value="">全部</option>
                            <option value="0">服务未开通</option>
                            <option value="1">服务正常</option>
                            <option value="3">服务关闭3</option>
                            <option value="4">服务关闭4</option>
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
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_search',plain:true" onclick="searchFun();">查询</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">清空条件</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_go',plain:true" onclick="exportFile();">导出数据</a>
</div>
</body>
</html>

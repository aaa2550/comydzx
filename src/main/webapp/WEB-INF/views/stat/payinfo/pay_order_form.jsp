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
    <title>会员支付查询</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            parent.$.messager.progress('close');
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/payinfo/orderform/list');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').bossDataGrid({
                url: url,
                sortName: 'paymentDate',
                sortOrder: 'desc',
                queryParams: {
                    startDate: $("input[name='startDate']").val(),
                    endDate: $("input[name='endDate']").val(),
                    status: $("select[name='status'] option:selected").val()
                },
                columns: [
                    {
                        field: 'userId',
                        title: '用户ID',
                        width: 90
                    },
                    {
                        field: 'orderNumber',
                        title: '订单流水号',
                        width: 160
                    }, {
                        field: 'orderId',
                        title: '商户订单号',
                        width: 110
                    },
                    {
                        field: 'price',
                        title: '支付金额',
                        width: 50
                    },
                    {
                        field: 'paymentDate',
                        title: '支付时间',
                        width: 110,
                        sortable: true
                    },
                    {
                        field: 'payType',
                        title: '支付渠道',
                        width: 50
                    },
                    {
                        field: 'deptId',
                        title: '支付终端',
                        width: 50
                    },
                    {
                        field: 'svip',
                        title: '会员类型',
                        width: 50
                    },
                    {
                        field: 'productId',
                        title: '产品ID',
                        width: 50
                    },
                    {
                        field: 'productName',
                        title: '产品名称',
                        width: 140
                    },
                    {
                        field: 'companyId',
                        title: '公司ID',
                        width: 50
                    },
                    {
                        field: 'status',
                        title: '支付状态',
                        width: 50
                    },
                    {
                        field: 'ip',
                        title: '用户IP',
                        width: 80
                    },
                    {
                        field: 'ext',
                        title: '扩展信息',
                        width: 220
                    },
                    {
                        field: 'pid',
                        title: '影片ID',
                        width: 50
                    },
                    {
                        field: 'videoId',
                        title: '直播场次ID',
                        width: 60
                    },
                    {
                        field: 'memo',
                        title: '订单说明',
                        width: 60
                    }
                ]
            });
        }

        function searchFun() {
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }
        function cleanFun() {
            var ele = $("#searchForm");
            ele.find('input').val('');
            ele.find("select option:selected").removeAttr("selected");
            dataGrid.datagrid('load', {});
        }
        function exportFile() {
            var params = $("#searchForm").serialize();
            var url = '${pageContext.request.contextPath}/tj/payinfo/orderform/export?' + params;
            location.href = url;
        }
        /**
         * 批量查询功能
         */
        function batchExport() {
            var params = $("#searchForm").serialize();
            parent.$.modalDialog({
                title: '根据用户ID或订单ID批量导出会员支付信息',
                width: 600,
                height: 360,
                href: '${pageContext.request.contextPath}/tj/payinfo/orderform/batch_export?' + params,
                onClose: function () {
                    this.parentNode.removeChild(this);
                },
                buttons: [{
                    text: '导出',
                    handler: function () {
                        parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#form');
                        f.submit();
                        parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                        parent.$.modalDialog.handler.dialog('close');
                    }
                }, {
                    text: "取消",
                    handler: function () {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                }]
            });
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false" style="height: 120px; overflow: hidden;">
        <form id="searchForm" method="post">
            <table class="table table-hover table-condensed">
                <tr>
                    <th>开始日期</th>
                    <th>结束日期</th>
                    <th>支付流水</th>
                    <th>用户ID</th>
                    <th>订单ID</th>
                    <th>支付渠道</th>
                    <th>支付终端</th>
                    <th>会员类型</th>
                    <th>公司ID</th>
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
                        <input name="orderNumber" class="easyui-textbox"/>
                    </td>
                    <td>
                        <input name="userId" class="easyui-textbox"/>
                    </td>
                    <td>
                        <input name="orderId" class="easyui-textbox"/>
                    </td>
                    <td>
                        <select name="payType" class="easyui-combobox" style="width: 150px">
                            <option value="">全部</option>
                            <c:forEach items="${payChannels}" var="payChannel">
                                <option value="${payChannel.key}">${payChannel.value}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <select name="deptId" class="easyui-combobox" style="width: 150px">
                            <option value="">全部</option>
                            <c:forEach items="${terminals}" var="dept">
                                <option value="${dept.key}">${dept.value}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <select name="svip" class="easyui-combobox" style="width: 150px">
                            <option value="">全部</option>
                            <c:forEach items="${vipTypes}" var="vipType">
                                <option value="${vipType.key}">${vipType.value}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <select name="companyId" class="easyui-combobox" style="width: 150px">
                            <option value="">全部</option>
                            <c:forEach items="${companies}" var="company">
                                <option value="${company.key}">${company.value}[${company.key}]</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <select name="status" class="easyui-combobox" style="width: 150px">
                            <option value="1" selected>已支付</option>
                            <option value="0">未支付</option>
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
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_go',plain:true" onclick="exportFile();">导出数据</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_link',plain:true" onclick="batchExport();">批量查询</a>
</div>
</body>
</html>

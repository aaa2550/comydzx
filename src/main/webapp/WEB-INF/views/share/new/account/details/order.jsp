<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>${internationalConfig.结算明细}</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            getTotal();
            dataGrid = $('#dataGrid').datagrid({
                url: '/account/details/find?configType=${configType}&cid=${cid}&memberType=${memberType}&time=${time}',
                fit: true,
                fitColumns: true,
                border: false,
                idField: 'id',
                sortName: 'createTime',
                sortOrder: 'desc',
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                columns: [[{
                    field: 'time',
                    title: '${internationalConfig.结算日期}',
                    width: 100,
                    formatter: function (value, row, index) {
                        return value.substring(0,10);
                    }
                }, {
                    field: 'memberType',
                    title: '${internationalConfig.类型}',
                    width: 100
                }, {
                    field: 'memberTypeName',
                    title: '${internationalConfig.类型名称}',
                    width: 100
                }, {
                    field: 'userCount',
                    title: '${internationalConfig.有效人数}',
                    width: 100
                }, {
                    field: 'totalCount',
                    title: '${internationalConfig.有效订单数}',
                    width: 100
                }, {
                    field: 'orderMoney',
                    title: '${internationalConfig.订单总金额}',
                    width: 100
                }, {
                    field: 'tax',
                    title: '${internationalConfig.税额}',
                    width: 100
                }, {
                    field: 'outTax',
                    title: '${internationalConfig.去税总金额}',
                    width: 100,
                    formatter: function (value, row, index) {
                        return row.orderMoney - row.tax;
                    }
                }, {
                    field: 'sharingRate',
                    title: '${internationalConfig.分成比例}',
                    width: 100
                }, {
                    field: 'money',
                    title: '${internationalConfig.分成金额}',
                    width: 100
                }, {
                    field: 'updateTime',
                    title: '${internationalConfig.记录时间}',
                    width: 100
                }]]
            });
        });

        function getTotal() {
            $.get('/account/details/totalPrice?cid=${cid}&configType=${configType}&time=${time}&memberType=${memberType}', null, function(result) {
                $(".price").html(result + " ${internationalConfig.priceUnit}");
            });
        }

        function exportFile() {
            location.href = '/account/details/export?cid=${cid}&configType=${configType}&time=${time}&memberType=${memberType}';
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'${internationalConfig.结算明细}',border:false" style="height: 50px; overflow: hidden;">
        总计 : <font class="price" style="color: red;font-size: 18px">￥ 2342343</font><a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="exportFile();">${internationalConfig.导出数据}</a>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>
</body>
</html>
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
                url: '/account/details/find?configType=${configType}&cid=${cid}&albumId=${albumId}&time=${time}',
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
                    field: 'albumId',
                    title: '${internationalConfig.专辑ID}',
                    width: 100
                }, {
                    field: 'albumName',
                    title: '${internationalConfig.专辑名称}',
                    width: 100
                }, {
                    field: 'playNum',
                    title: '${internationalConfig.有效播放总数千次}',
                    width: 100
                }, {
                    field: 'money',
                    title: '${internationalConfig.可分成金额}',
                    width: 100
                }, {
                    field: 'updateTime',
                    title: '${internationalConfig.记录时间}',
                    width: 100
                }]]
            });
        });

        function getTotal() {
            $.get('/account/details/totalPrice?cid=${cid}&configType=${configType}&time=${time}&albumId=${albumId}', null, function(result) {
                $(".price").html("￥ " + result);
            });
        }

        function exportFile() {
            location.href = '/account/details/export?cid=${cid}&configType=${configType}&time=${time}&albumId=${albumId}';
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
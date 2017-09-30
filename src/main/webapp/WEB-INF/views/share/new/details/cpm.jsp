<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>CPM分成明细</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">
        var dataGrid;
        $(function () {

            dataGrid = $('#dataGrid').datagrid({
                url: '/share_details/details_data?albumId=${albumId}&configType=${configType}&month=${month}',
                fit: true,
                fitColumns: true,
                border: false,
                idField: 'id',
                sortName: 'createTime',
                sortOrder: 'desc',
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                frozenColumns: [
                    [
                        {
                            field: 'id',
                            title: '编号',
                            width: 50,
                            hidden: true
                        }
                    ]
                ],
                columns: [[{
                    field: 'time',
                    title: '日期',
                    width: 100
                }, {
                    field: 'albumId',
                    title: '专辑ID',
                    width: 100
                }, {
                    field: 'albumName',
                    title: '专辑名称',
                    width: 100
                }, {
                    field: 'pcTotal',
                    title: 'PC端分成',
                    width: 100,
                    formatter: function (value, row, index) {
                        return String.format(value+" <a href=\"javascript:void(0);\" onclick=\"model('"+row.time+"',"+row.albumId+",'PC')\">详细</a>", row.id)
                    }
                }, {
                    field: 'phoneTotal',
                    title: '移动端分成',
                    width: 100,
                    formatter: function (value, row, index) {
                        return String.format(value+" <a href=\"javascript:void(0);\" onclick=\"model('"+row.time+"',"+row.albumId+",'移动')\">详细</a>", row.id)
                    }
                }, {
                    field: 'tvTotal',
                    title: 'TV端分成',
                    width: 100,
                    formatter: function (value, row, index) {
                        return String.format(value+" <a href=\"javascript:void(0);\" onclick=\"model('"+row.time+"',"+row.albumId+",'TV')\">详细</a>", row.id)
                    }
                }, {
                    field: 'total',
                    title: '总金额',
                    width: 100
                }, {
                    field: 'updateTime',
                    title: '记录时间',
                    width: 100
                }]]
            });
        });

        function model(time, albumId, type) {
            parent.$.modalDialog({
                title: type + '端分成明细',
                width: 800,
                height: 150,
                href: '/share_details/model?albumId=' + albumId + '&time=' + time + '&type=' + type,
                buttons: [{
                    text: '返回',
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
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>
</body>
</html>
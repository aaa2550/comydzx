<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>付费分成明细</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">
        var dataGrid;
        $(function () {

            dataGrid = $('#dataGrid').datagrid({
                url: '/share_details/details_data?memberType=${albumId}&configType=${configType}&month=${month}',
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
                    field: 'payCount',
                    title: '点播总人数',
                    width: 100
                }, {
                    field: 'memberCount',
                    title: '会员总人数',
                    width: 100
                }, {
                    field: 'effectiveCount',
                    title: '有效总人数',
                    width: 100
                }, {
                    field: 'price',
                    title: '单价（元/次）',
                    width: 100
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
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

            dataGrid = $('#dataGrid').datagrid({
                url: '/account/details/find?configType=${configType}&cid=${cid}&memberType=${memberType}&configType=${configType}&time=${time}',
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
                    width: 100
                }, {
                    field: 'albumId',
                    title: '${internationalConfig.专辑ID}',
                    width: 100
                }, {
                    field: 'albumName',
                    title: '${internationalConfig.专辑名称}',
                    width: 100
                }, {
                    field: 'payCount',
                    title: '${internationalConfig.有效点播总数}',
                    width: 100
                }, {
                    field: 'memberCount',
                    title: '${internationalConfig.有效会员总数}',
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
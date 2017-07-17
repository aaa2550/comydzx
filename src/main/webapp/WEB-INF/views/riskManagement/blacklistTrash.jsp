<%--
  Created by IntelliJ IDEA.
  User: hujunfei
  Date: 2016/7/7
  Time: 15:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>黑名单回收站</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">
        var dataGrid;

        $(function () {
            dataGrid = $('#dataGrid').bossDataGrid({
                url: '${pageContext.request.contextPath}/tj/riskManagement/blacklistTrashData',
                sortName: 'createTime',
                sortOrder: 'desc',
                columns: [
                    {
                        field: 'createTime',
                        title: '加黑时间',
                        width: 70,
                        sortable: true
                    },
                    {
                        field: 'deleteTime',
                        title: '删除时间',
                        width: 70
                    },
                    {
                        field: 'blackType',
                        title: '黑名单属性',
                        width: 70
                    },
                    {
                        field: 'blackInfo',
                        title: '黑名单信息',
                        width: 70
                    },
                    {
                        field: 'remark',
                        title: '删除备注',
                        width: 70
                    },
                    {
                        field: 'username',
                        title: '操作人',
                        width: 70
                    },
                    {
                        field: 'operation',
                        title: '操作',
                        width: 70,
                        formatter: function (value, row, index) {
                            var d = '';
                            d = '<a href="#" onclick="revert(' + row.id + ',' + index + ')">还原</a>';
                            return d;
                        }
                    }
                ]
            });
        });
        function revert(id, index) {
            var row = $('#dataGrid').datagrid('getData').rows[index];
            parent.$.messager.confirm("询问", "你确认还原该记录吗?", function(flag) {
                if(flag) {
                    confirmRevert(row);//自己的方法
                } else{
                    $("#revert").dialog("close");//关闭对话框
                }
            });
        }
        function confirmRevert(row) {
            $.ajax({
                type: "POST",
                url: "${pageContext.request.contextPath}/tj/riskManagement/recycleRevert",
                data: {blackType: row.blackType, blackInfo: row.blackInfo, createTime: row.createTime},
                dataType: "json",
                success: function (data) {
                    if(data.code == 0) {
                        dataGrid.datagrid('load', {});
                    } else {
                        parent.$.messager.alert("提示", dataObj.msg);
                    }
                }
            });
        }
    </script>
</head>
<body>
<br>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>
<div id="revert">
</div>
</body>
</html>

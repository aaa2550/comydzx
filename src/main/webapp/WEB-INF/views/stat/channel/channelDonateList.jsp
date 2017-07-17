<%--
  Created by IntelliJ IDEA.
  User: kangxiongwei1
  Date: 2015/12/4
  Time: 18:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>酷派合作渠道列表</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">

        var dataGrid;

        $(function () {
            dataGrid = renderDataGrid("${pageContext.request.contextPath}/vipController/channelDonateController/query");
        });

        //请求数据
        function renderDataGrid(url) {
            return $("#dataGrid").datagrid({
                url: url,
                fit: true,
                fitColumns: true,
                border: true,
                pagination: true,
                idField: 'id',
                pageSize: 20,
                pageList: [10, 20, 30, 40, 50],
                sortName: 'id',
                sortOrder: 'asc',
                checkOnSelect: false,
                selectOnCheck: false,
                singleSelect: true,
                nowrap: false,
                striped: true,
                rownumbers: true,
                columns: [[
                    {
                        field: 'name',
                        title: '设备型号',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'id',
                        title: '渠道ID',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'donateVipNums',
                        title: '赠送会员数',
                        width: 100,
                        sortable: false
                    },
                    {
                        field: 'macAddrs',
                        title: 'mac总数',
                        width: 100,
                        sortable: false
                    },
                    {
                        field: 'regularMoney',
                        title: '赠送移动会员价值(元)',
                        width: 130,
                        sortable: false,
                        formatter: function (value, row) {
                            return value == null ? 0: value;
                        }
                    },
                    {
                        field: 'proMoney',
                        title: '赠送全屏会员价值(元)',
                        width: 130,
                        sortable: false,
                        formatter: function (value, row) {
                            return value == null ? 0: value;
                        }
                    },
                    {
                        field: 'days',
                        title: '赠送移动会员时长',
                        width: 130,
                        sortable: false
                    },
                    {
                        field: 'xuFeiCount',
                        title: '续费人数',
                        width: 130
                    },
                    {
                        field: 'xuFeiMoney',
                        title: '续费价值',
                        width: 130
                    },
                    {
                        field: 'xuFeiRate',
                        title: '续费率',
                        width: 130,
                        formatter: function(value){
                            if(value == null || value == 'NaN') value = "0.000%";
                            else value += "%";
                            return value;
                        }
                    }
                ]],
                toolbar: '#toolbar',
                onLoadSuccess: function (data) {
                    parent.$.messager.progress('close');
                    rows = data['rows'];
                },
                onRowContextMenu: function (e, rowIndex, rowData) {
                    e.preventDefault();
                    $(this).datagrid('unselectAll');
                    $(this).datagrid('selectRow', rowIndex);
                }
            });
        }

        //查询
        function searchFun() {
            if ($('#searchForm').form('validate')){
                var params = $.serializeObject($('#searchForm'));
                //alert(JSON.stringify(params));
                dataGrid.datagrid('load', params);
            }
        }
        //清空查询条件
        /*function cleanFun() {
            $('#searchForm input').val('');

            $("#searchForm select").each(function (index, element) {
                $(this).find("option:first").attr("selected", "selected");
            });

            dataGrid.datagrid('load', {});
        }*/

        //导出csv文件
        function exportChannelDonate() {
            var start = $("input[name='start']").val();
            var end = $("input[name='end']").val();
            var id = $("select[name='id'] option:selected").val();
            var name = $("select[name='name'] option:selected").val();
            var conditon = "start="+start+"&end="+end+"&id="+id+"&name="+name;
            var url = "${pageContext.request.contextPath}/vipController/channelDonateController/export?"+conditon;
            window.location.href = url;
        }

    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit:true, border:false">
    <div data-options="region:'north',title:'查询条件',border:false" style="height: 120px; overflow: auto;">
        <form id="searchForm">
            <table class="table table-hover table-condensed">
                <tr>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>渠道ID</td>
                    <td>设备型号</td>
                </tr>
                <tr>
                    <td>
                        <input name="start" class="easyui-datebox easyui-validatebox" data-options="required:true" value="${start}" style="width: 160px; height: 29px"/>
                    </td>
                    <td>
                        <input name="end" class="easyui-datebox easyui-validatebox" data-options="required:true" value="${end}" style="width: 160px; height: 29px;"/>
                    </td>
                    <td>
                        <select name="id" style="width: 140px; height: 29px;">
                            <option value="">全部</option>
                            <c:forEach var="channel" items="${list}">
                                <option value="${channel.id}">${channel.id}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <select name="name" style="height: 29px;">
                            <option value="">全部</option>
                            <c:forEach var="channel" items="${list}">
                                <option value="${channel.name}">${channel.name}</option>
                            </c:forEach>
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
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true"
       onclick="searchFun();">查询</a>
    <%--<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true"
       onclick="cleanFun();">清空条件</a>--%>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_go',plain:true"
       onclick="exportChannelDonate();">
        导出数据
    </a>
</div>

</body>
</html>

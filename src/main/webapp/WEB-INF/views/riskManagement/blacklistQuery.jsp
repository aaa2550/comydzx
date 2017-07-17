<%@ page import="java.util.Map" %>
<%--
  Created by IntelliJ IDEA.
  User: hujunfei
  Date: 2016/6/27
  Time: 15:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>黑名单查询</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">
        var dataGrid;

        $(function () {
            dataGrid = $('#dataGrid').datagrid({
                url: '${pageContext.request.contextPath}/tj/riskManagement/blacklistQueryData',
                fit: true,
                fitColumns: true,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 20,
                pageList: [10, 20, 30, 40, 50],
                sortName: 'createTime',
                sortOrder: 'desc',
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                striped: true,
                rownumbers: true,
                singleSelect: true,
                queryParams: {
                    beginDate: $("#beginDate").val(),
                    endDate: $("#endDate").val()
                },
                frozenColumns: [
                    [
                        {
                            field: 'id',
                            title: '编号',
                            width: 150,
                            hidden: true
                        }
                    ]
                ],
                columns: [
                    [
                        {
                            field: 'blackInfo',
                            title: '黑名单信息',
                            width: 70
                        },
                        {
                            field: 'blackType',
                            title: '黑名单属性',
                            width: 70
                        },
                        {
                            field: 'createTime',
                            title: '加黑时间',
                            width: 70,
                            sortable: true
                        },
                        {
                            field: 'blackReason',
                            title: '加黑原因',
                            width: 70
                        },
                        {
                            field: 'operation',
                            title: '操作',
                            width: 70,
                            formatter: function (value, row, index) {
                                var d = '';
                                d = '<a href="#" onclick="deleterow(' + row.id + ',' + index + ')">删除</a>';
                                return d;
                            }
                        },
                        {
                            field: 'username',
                            title: '操作人',
                            width: 70
                        }
                    ]
                ],
                toolbar: '#toolbar',
                onLoadSuccess: function () {
                    $('#searchForm table').show();
                    parent.$.messager.progress('close');
                },
                onRowContextMenu: function (e, rowIndex, rowData) {
                    e.preventDefault();
                    $(this).datagrid('unselectAll');
                    $(this).datagrid('selectRow', rowIndex);
                    $('#menu').menu('show', {
                        left: e.pageX,
                        top: e.pageY
                    });
                }
            });
        });

        function searchFun() {
            var tDate = new Date();
            var tYear = tDate.getFullYear();
            var tMonth = tDate.getMonth() + 1;
            var tDay = tDate.getDate();
            if (tMonth < 10) {
                tMonth = "0" + tMonth;
            }
            if (tDay < 10) {
                tDay = "0" + tDay;
            }
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }

        function cleanFun() {
            $('#searchForm input[id !=addBlack]').val('');
            $("#reason").val(0);
            $("#attributeType").val(0);
            $("#attributeNumber").val("");
        }
        function showAddFun() {
            $("#add").dialog({
                title: "添加黑名单",   //一些属性
                width: 500,
                height: 500,
                buttons: [{
                    text: "添加",
                    handler: function () {
                        saveNews();//自己的方法
                    }
                }, {
                    text: "取消",
                    handler: function () {
                        $("#blackAttr").val(1);
                        $("#blackReason").val(1);
                        $("#timeLimit").val(1);
                        $("#addNumbers").val("");
                        $("#add").dialog("close");//关闭对话框
                    }
                }]
            })
        }
        function saveNews() {
            $.ajax({
                type: "POST",
                url: "${pageContext.request.contextPath}/tj/riskManagement/addBlacklist",
                data: $("#addBlackForm").serialize(),
                //dataType: "json",
                error: function (request) {
                    alert("Connection error");
                },
                success: function (data) {
                    var dataObj = eval("(" + data + ")");
                    alert(dataObj.msg);
                    $("#blackAttr").val(1);
                    $("#blackReason").val(1);
                    $("#timeLimit").val(1);
                    $("#addNumbers").val("");
                    $("#add").dialog("close");
                    dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
                }
            });
        }
        function deleterow(id, index) {
            var row = $('#dataGrid').datagrid('getData').rows[index];
            $("#delete").dialog({
                title: "确认删除",
                width: 320,
                height: 240,
                buttons: [{
                    text: "确认",
                    handler: function () {
                        confirmDelete(row);//自己的方法
                    }
                }, {
                    text: "取消",
                    handler: function () {
                        $("#remark").val("");
                        $("#delete").dialog("close");//关闭对话框
                    }
                }]
            })
        }
        function confirmDelete(row) {
            $.ajax({
                type: "POST",
                url: "${pageContext.request.contextPath}/tj/riskManagement/deleteBlacklist",
                data: {
                    blackType: row.blackType,
                    blackInfo: row.blackInfo,
                    createTime: row.createTime,
                    remark: $("#remark").val()
                },
                error: function (request) {
                    alert("Connection error");
                },
                success: function (data) {
                    var dataObj = eval("(" + data + ")");
                    alert(dataObj.msg);
                    $("#remark").val("");
                    $("#delete").dialog("close");
                    dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
                }
            });
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false"
         style="height: 160px; overflow: hidden;">
        <form id="searchForm">
            <table class="table table-hover table-condensed" style="display: none;">
                <tr style="border: hidden">
                    <th>加黑时间</th>
                    <td><input id="beginDate" name="beginDate" class="easyui-datebox" value="${startDate}"></td>
                    <th>结束时间</th>
                    <td><input id="endDate" name="endDate" class="easyui-datebox" value="${endDate}"></td>
                    <th>加黑原因</th>
                    <td>
                        <select name="reason" id="reason">
                            <option value="0">全部</option>
                            <c:forEach items="${reasonMap}" var="reason">
                                <option value="${reason.key}">${reason.value}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr style="border: hidden">
                    <th>黑名单属性</th>
                    <td>
                        <select name="attributeType" id="attributeType">
                            <option value="0">全部</option>
                            <c:forEach items="${typeMap}" var="type">
                                <option value="${type.key}">${type.value}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <th>查询</th>
                    <td colspan="3"><input name="attributeNumber" id="attributeNumber" style="width: 400px"
                                           id="attributeNumber" class="easyui-validatebox" placeholder="可批量查询,逗号分隔"/>
                    </td>
                </tr>
                <tr style="border: hidden">
                    <td colspan="6">
                        <input id="addBlack" type="button" value="添加黑名单"
                               style="width: 100px;height: 30px;border-radius: 3px" onclick="showAddFun()"/>
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
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>

    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_delete',plain:true"
       onclick="cleanFun();">清空条件</a>

</div>
<div id="add">
    <div>
        <form name="addBlackForm" id="addBlackForm">
            <table class="table table-hover table-condensed">
                <tr style="border: hidden">
                    <td style="text-align: right">黑名单属性</td>
                    <td>
                        <select name="blackAttr" id="blackAttr">
                            <c:forEach items="${typeMap}" var="type">
                                <option value="${type.key}">${type.value}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr style="border: hidden">
                    <td style="text-align: right">加黑原因</td>
                    <td>
                        <select name="blackReason" id="blackReason">
                            <c:forEach items="${reasonMap}" var="reason">
                                <option value="${reason.key}">${reason.value}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr style="border: hidden">
                    <td style="text-align: right">加黑时限</td>
                    <td>
                        <select name="timeLimit" id="timeLimit">
                            <c:forEach items="${limitMap}" var="limit">
                                <option value="${limit.key}">${limit.value}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr style="border: hidden">
                    <td style="text-align: right">批量添加</td>
                    <td>
                        <textarea id="addNumbers" name="addNumbers" style="width:220px;height:300px;resize: none"
                                  placeholder="以换行分隔"></textarea>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
<div id="delete">
    删除备注<br><textarea id="remark" name="remark" style="width:320px;height:220px;resize: none" placeholder="50字符以内"></textarea>
</div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>自定义会员UID导出</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script src="${pageContext.request.contextPath}/js/highcharts/highcharts.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/highcharts/exporting.js" type="text/javascript"></script>
    <script type="text/javascript">
        /**
         * 待绑定行数据
         */
        var rows;

        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }

        function exportExcel() {
            var canceldate = $('#canceldate').combobox('getValue');
            var viptype = $("#viptype").val();
            var paytype = $("#paytype").val();
            var url = '${pageContext.request.contextPath}/vipController/exportZdyUidExcel?canceltime=' + canceldate + '&viptype=' + viptype + '&paytype=' + paytype;
            location.href = url;
        }

        $(function () {
            parent.$.messager.progress('close');
        });
    </script>
    <script>
        $.extend($.fn.validatebox.defaults.rules, {
            TimeCheck: {
                validator: function () {
                    var s = $("input[name=canceldate]").val();
                    return Math.abs(((new Date(Date.parse(s1)) - new Date(Date
                                    .parse(s))) / 1000 / 60 / 60 / 24)) - 60 < 0;
                },
                message: '非法数据'
            }
        });
    </script>
    <style>
        .span {
            padding: 10px;
        }
    </style>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false"
         style="height: 1200px; overflow: auto;">
        <form id="searchForm">
            <table class="table table-hover table-condensed">
                <tr>
                    <td>日期选择</td>
                    <td>会员套餐类型</td>
                    <td>支付方式</td>
                </tr>
                <tr>
                    <td><input id="canceldate" name="canceltime" value="${canceldate}" class="easyui-datebox" style="width: 160px; height: 29px"></td>
                    <td><select name="viptype" style="width: 160px" id="viptype">
                        <option value="-2" selected="selected">全部</option>
                        <option value="1">移动影视会员</option>
                        <option value="9">全屏影视会员</option>
                    </select></td>
                    <td><select name="paytype" style="width: 160px" id="paytype">
                        <option value="-1">免费</option>
                        <option value="0">兑换码</option>
                        <option value="1">乐点</option>
                        <option value="2" selected="selected">现金</option>
                    </select></td>
                </tr>
            </table>
            <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="exportExcel();">导出excel</a>
        </form>
    </div>
</div>

</body>
</html>
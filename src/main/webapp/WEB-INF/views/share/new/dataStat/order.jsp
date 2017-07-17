<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">
        var dataGrid;
        $(function () {

            dataGrid = $('#dataGrid').datagrid({
                url: '/dataStat/order/find',
                fit: true,
                fitColumns: true,
                border: false,
                idField: 'id',
                pagination: true,
                pageSize: 10,
                pageList: [10, 20, 30, 40, 50],
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                columns: [[{
                    field: 'startTime',
                    title: '${internationalConfig.规则开始时间}',
                    width: 80,
                    formatter: function (value, row, index) {
                        return value.substring(0,10);
                    }
                }, {
                    field: 'endTime',
                    title: '${internationalConfig.规则结束时间}',
                    width: 80,
                    formatter: function (value, row, index) {
                        return value.substring(0,10);
                    }
                }, {
                    field: 'cid',
                    title: 'CPID',
                    width: 40
                }, {
                    field: 'cpName',
                    title: '${internationalConfig.CP名称}',
                    width: 250
                }, {
                    field: 'cpType',
                    title: '${internationalConfig.类别}',
                    width: 40,
                    formatter: function (value, row, index) {
                        var str = '';
                        if (value == 1) {
                            str = '${internationalConfig.默认分类}';
                        } else if (value == 2) {
                            str = '${internationalConfig.影业}';
                        } else if (value == 3) {
                            str = '${internationalConfig.动漫}';
                        } else if (value == 4) {
                            str = '${internationalConfig.音乐}';
                        } else if (value == 5) {
                            str = '${internationalConfig.PGC}';
                        } else {
                            str = '${internationalConfig.其它}';
                        }
                        return str;
                    }
                }, {
                    field: 'configType',
                    title: '${internationalConfig.分成类型}',
                    width: 80,
                    formatter: function (value, row, index) {
                        var str = '';
                        if (value == 1) {
                            str = '${internationalConfig.付费分成}';
                        } else if (value == 2) {
                            str = '${internationalConfig.CPM分成}';
                        } else if (value == 3) {
                            str = '${internationalConfig.播放分成}';
                        } else if (value == 4) {
                            str = '${internationalConfig.累计时长分成}';
                        } else if (value == 5) {
                            str = '${internationalConfig.会员订单分成}';
                        } else if (value == 6) {
                            str = '${internationalConfig.业务订单分成}';
                        } else {
                            str = '${internationalConfig.其它}';
                        }
                        return str;
                    }
                }, {
                    field: 'memberType',
                    title: '${internationalConfig.类型ID}',
                    width: 90
                }, {
                    field: 'memberTypeName',
                    title: '${internationalConfig.类型名称}',
                    width: 100
                }, {
                    field: 'pcCount',
                    title: '${internationalConfig.PC端订单量}',
                    width: 100
                }, {
                    field: 'phoneCount',
                    title: '${internationalConfig.移动端订单量}',
                    width: 100
                }, {
                    field: 'tvCount',
                    title: '${internationalConfig.TV端订单量}',
                    width: 60
                }, {
                    field: 'userCount',
                    title: '${internationalConfig.有效人数}',
                    width: 40
                }, {
                    field: 'totalCount',
                    title: '${internationalConfig.总订单量}',
                    width: 40
                }, {
                    field: 'action',
                    title: '${internationalConfig.操作}',
                    width: 100,
                    formatter: function (value, row, index) {
                        return "<a target='_blank' href='/dataStat/details/order/list.do?startTime=" + row.startTime + "&endTime=" + row.endTime + "&memberType=" + row.memberType + "&cid=" + row.cid + "'>${internationalConfig.日明细}</a>";
                    }
                }]],
                toolbar: '#toolbar'
            });
        });

        function searchFun() {
            var fromData = $.serializeObject($('#searchForm'));
            dataGrid.datagrid({queryParams: fromData});
        }

        function exportFile() {
            var params = $.serializeObject($('#searchForm'));
            var url = '/dataStat/order/export?';
            for(var key in params){
                url += key + "=" + params[key] + "&";
            }
            location.href = url;
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
         style="height: 120px; overflow: hidden;">
        <form id="searchForm">
            <table class="table-more" style="width: 1200px;">
                <tr>
                    <td>${internationalConfig.时间段}：<input name="startTime" class="easyui-datebox"/>-<input name="endTime" class="easyui-datebox"/></td>
                    <td>
                        ${internationalConfig.类别}：
                        <select name="cpType">
                            <option value="">${internationalConfig.全部}</option>
                            <option value="1">${internationalConfig.默认分类}</option>
                            <option value="2">${internationalConfig.影业}</option>
                            <option value="3">${internationalConfig.动漫}</option>
                            <option value="4">${internationalConfig.音乐}</option>
                            <option value="5">${internationalConfig.PGC}</option>
                        </select>
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td>CPID：<input name="cid" placeholder="${internationalConfig.请输入CPID}" class="span2"/> ${internationalConfig.CP名称}：<input name="cpName" placeholder="${internationalConfig.请输入CP名称}" class="span2"/></td>
                    <td>${internationalConfig.类型ID}：<input name="memberType" placeholder="${internationalConfig.请输入专辑ID}" class="span2"/></td>
                    <td>${internationalConfig.类型名称}：<input name="memberName" placeholder="${internationalConfig.类型名称}" class="span2"/></td>
                </tr>
            </table>
        </form>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
    <div id="toolbar" style="display: none;">
        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true"
           onclick="searchFun();">${internationalConfig.过滤条件}</a>
        <a href="javascript:void(0);" class="easyui-linkbutton"
           data-options="iconCls:'brick_add',plain:true" onclick="exportFile();">${internationalConfig.导出数据}</a>
    </div>
</div>
</body>
</html>
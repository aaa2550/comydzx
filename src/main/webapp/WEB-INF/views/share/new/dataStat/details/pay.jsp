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
                url: '/dataStat/details/pay/find?albumId=${albumId}',
                fit: true,
                fitColumns: true,
                border: false,
                idField: 'id',
                pagination: true,
                queryParams: $.serializeObject($('#searchForm')),
                pageSize: 10,
                pageList: [10, 20, 30, 40, 50],
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                columns: [[{
                    field: 'playDate',
                    title: '${internationalConfig.日期}',
                    width: 80,
                    formatter: function (value, row, index) {
                        return value.substring(0,10);
                    }
                }, {
                    field: 'playNum',
                    title: '${internationalConfig.会员播放次数}',
                    width: 100
                }, {
                    field: 'playUsers',
                    title: '${internationalConfig.会员播放人数}',
                    width: 100
                }, {
                    field: 'playHours',
                    title: '${internationalConfig.播放时长时}',
                    width: 60
                }, {
                    field: 'avgPeopleTimes',
                    title: '${internationalConfig.人均时长分}',
                    width: 40
                }, {
                    field: 'avgPlayTimes',
                    title: '${internationalConfig.次均时长分}',
                    width: 40
                }, {
                    field: 'avgPeoplePlay',
                    title: '${internationalConfig.人均播次}',
                    width: 40
                }, {
                    field: 'playTimes',
                    title: '${internationalConfig.播完次数}',
                    width: 100
                }, {
                    field: 'playFullProportion',
                    title: '${internationalConfig.播完比例}',
                    width: 40,
                    formatter: function (value, row, index) {
                        return value + '%';
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
            var url = '/dataStat/details/pay/export?albumId=${albumId}&';
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
                    <td>${internationalConfig.时间段}：<input name="startTime" value="${startTime}" class="easyui-datebox"/>-<input name="endTime" value="${endTime}" class="easyui-datebox"/></td>
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
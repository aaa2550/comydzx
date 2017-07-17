<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>电视领取关联统计</title>
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js" type="text/javascript"></script>
	<script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>
    <script type="text/javascript">
        /**
         * 待绑定行数据
         */
        var rows;

        var dataGrid;
        $(function () {
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/letvPhoneStat/bindTV/dataGrid');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').datagrid({
                url: url,
                fit: true,
                fitColumns: false,
                border: false,
                pagination: true,
                idField: 'channelId',
                pageSize: 10,
                pageList: [ 10, 20, 30, 40, 50 ],
                sortName: 'xufeiMoney',
                sortOrder: 'desc',
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                striped: true,
                rownumbers: true,
                singleSelect: true,
                remoteSort: false,
                frozenColumns: [
                    [
                    ]
                ],
                columns: [
                    [
                        {
                            field: 'userCount',
                            title: '电视配对领取成功数',
                            width: 130,
                            sortable: true,
                            formatter: function (value, row, index) {
                                return $.formatString('{0}', row.vipBind+row.offlineBind);
                            }
                        },
                        {
                            field: 'vipBind',
                            title: '线上会员机领取数',
                            width: 130,
                            sortable: true
                        },
                        {
                            field: 'totalMoney',
                            title: '线上会员机领取率',
                            width: 130,
                            sortable: true,
                            formatter: function (value, row, index) {
                                return $.formatString('{0}%', parseInt(row.vipBind*10000/row.onlineVipCount)/100);
                            }
                        },
                        {
                            field: 'offlineBind',
                            title: '线下机器领取数',
                            width: 130,
                            sortable: true
                        },
                        {
                            field: 'xufeiMoney',
                            title: '线下机器领取率',
                            width: 130,
                            sortable: true,
                            formatter: function (value, row, index) {
                                return $.formatString('{0}%', parseInt(row.offlineBind*10000/row.offlineCount)/100);
                            }
                        }
                    ]
                ],
                toolbar: '#toolbar',
                onLoadSuccess: function (data) {
                    parent.$.messager.progress('close');
                    rows = data['rows'];
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
        }

        function searchFun() {
              dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }


        $(function () {
            parent.$.messager.progress('close');
        });
        
        $(function(){
        	$("#queryBegin").change(function(){
        		//alert($("input[name=queryBeginDate]").val());
        		//$("input[name=xufeiBeginDate]").val($("input[name=queryBeginDate]").val());
        	});
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
         style="height: 120px; overflow: auto;">
        <form id="searchForm">
            <table class="table table-hover table-condensed">
                <tr>
                    <td>开始时间</td>
                    <td></td>
                    <td>结束时间</td>
                </tr>
                <tr>
                    <td>
                        <input name="beginDate" id="queryBegin" class="easyui-datebox"   data-options="required:true" value="${start}" style="width: 160px; height: 29px"/>
                    </td>

                    <td>
                        <input name="endDate" id="queryEnd" class="easyui-datebox"   data-options="required:true" value="${end}" style="width: 160px; height: 29px">
                    </td>
                    <td>
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
</div>

</body>
</html>
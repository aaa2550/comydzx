<%--
  Created by IntelliJ IDEA.
  User: kangxiongwei3
  Date: 2016/8/31
  Time: 9:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>移动渠道流量统计</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">

        var dataGrid;

        $(function () {
            parent.$.messager.progress('close');
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/mobileChannel/mcheck/list');
        });

        //每页末尾加一行统计结果
        function compute() {
            var rows = $('#dataGrid').datagrid('getRows'); //获取当前的数据行
            var totalPv = 0, totalUv = 0, totalNewOrders = 0, totalXfOrders = 0, totalNewIncome = 0, totalXfIncome = 0, totalIncome = 0, totalCpmIncome = 0;
            for (var i = 0; i < rows.length; i++) {
                totalPv += rows[i]['pv'];
                totalUv += rows[i]['uv'];
                totalNewOrders += rows[i]['newOrder'];
                totalXfOrders += rows[i]['xfOrder'];
                totalNewIncome += rows[i]['newIncome'];
                totalXfIncome += rows[i]['xfIncome'];
                totalIncome += rows[i]['totalIncome'];
            }
            var totalNewRate = 0, totalRate = 0;
            if(totalUv > 0) {
                totalNewRate = totalNewOrders * 100 / totalUv;
                totalRate  = (totalNewOrders + totalXfOrders) * 100 / totalUv;
                totalCpmIncome = totalIncome * 1000 / totalUv;
            }
            //新增一行显示统计信息
            $('#dataGrid').datagrid('appendRow', {statDate: '<b>本页统计</b>', pv: totalPv, uv: totalUv, newOrder: totalNewOrders, xfOrder: totalXfOrders,
                newIncome: totalNewIncome.toFixed(2), xfIncome: totalXfIncome.toFixed(2), totalIncome: totalIncome.toFixed(2), newRate: totalNewRate.toFixed(2),
                totalRate: totalRate.toFixed(2), cpmIncome: totalCpmIncome.toFixed(2)
            });
        }

        function renderDataGrid(url) {
            return $('#dataGrid').bossDataGrid({
                url: url,
                pageSize: 50,
                sortName: 'pv',
                sortOrder: 'desc',
                queryParams: {
                    startDate: $("#startDate").val(),
                    device: $("#device").val(),
                    actType: $("#actType").val(),
                    actCode: $("#actCode").val(),
                    channelUrl: $("#channelUrl").val()
                },
                columns: [
                    {
                        field: 'statDate',
                        title: '日期',
                        width: 100
                    },
                    {
                        field: 'pv',
                        title: 'PV',
                        width: 100,
                        sortable: true
                    }, {
                        field: 'uv',
                        title: 'UV',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'newOrder',
                        title: '新增订单数',
                        width: 100
                    },
                    {
                        field: 'xfOrder',
                        title: '续费订单数',
                        width: 100
                    },
                    {
                        field: 'newIncome',
                        title: '新增收入',
                        width: 100
                    },
                    {
                        field: 'xfIncome',
                        title: '续费金额',
                        width: 100
                    },
                    {
                        field: 'totalIncome',
                        title: '总收入',
                        width: 100
                    },
                    {
                        field: 'newRate',
                        title: '新增转化率',
                        width: 100,
                        formatter: function (value, row, index) {
                            return $.formatString('{0}%', row.newRate);
                        }
                    },
                    {
                        field: 'totalRate',
                        title: '总转化率',
                        width: 100,
                        formatter: function (value, row, index) {
                            return $.formatString('{0}%', row.totalRate);
                        }
                    },
                    {
                        field: 'cpmIncome',
                        title: '千人收入',
                        width: 100
                    },
                    {
                        field: 'actCode',
                        title: '动作类型',
                        width: 100,
                        formatter: function(value, row, index){
                            if (value == 0) {
                                return "点击";
                            } else if (value == 17) {
                                return "推荐点击";
                            } else if (value == 19) {
                                return "曝光";
                            } else if (value == 25) {
                                return "推荐曝光";
                            }
                        }
                    },
                    {
                        field: 'channelUrl',
                        title: '渠道代号',
                        width: 350
                    },
                    {
                        field: 'operation', 
                        title: '操作',
                        noExport: true,
                        width: 	120,
                        sortable: false,
                        formatter : function(value, row, index) {
                            return '<a href="javascript:void(0)" onclick=gotoDetail("'+row.actCode+'","'+row.channelUrl+'")>查询明细</a>';
                        }
                    }
                ],
                onLoadSuccess: compute
            });
        }

        function searchFun() {
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }
        function gotoDetail(actCode, channelUrl){//详情跳转
    		parent.iframeTab.init({url:'${pageContext.request.contextPath}/tj/mobileChannel/mcheckDetail?actCode='+actCode+'&channelUrl='+encodeURIComponent(encodeURIComponent(channelUrl))
    			+'&device='+$("#device").val()
    			+'&actType='+$("#actType").val()
    			,text:'移动渠道流量明细'});
    	}
    </script>
    <style type="text/css">
        th, td {
            padding-top: 5px;
            padding-left: 15px;
        }
    </style>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false" style="height: 120px; overflow: auto;">
        <form id="searchForm">
            <table>
                <tr>
                    <th>日期</th>
                    <th>设备类型</th>
                    <th>统计分类</th>
                    <th>动作类型</th>
                    <th>渠道代号</th>
                </tr>
                <tr>
                    <td>
                        <input name="startDate" id="startDate" class="easyui-datebox" data-options="required:true"
                               value="${startDate}"
                               style="width: 160px; height: 29px"/>
                    </td>
                    <td>
                        <select name="device" style="width: 160px" id="device">
                            <option value="-1" selected="selected">全部</option>
                            <option value="001">Android</option>
                            <option value="002">iPhone</option>
                            <option value="004">iPad</option>
                        </select>
                    </td>
                    <td>
                        <select name="actType" style="width: 160px" id="actType">
                            <option value="-1" selected="selected">全部</option>
                            <option value="0">fragid</option>
                            <option value="1">name</option>
                            <option value="2">其他</option>
                        </select>
                    </td>
                    <td>
                        <select name="actCode" style="width: 160px" id="actCode">
                            <option value="-1" selected="selected">全部</option>
                            <option value="0">点击</option>
                            <option value="17">推荐点击</option>
                            <option value="19">曝光</option>
                            <option value="25">推荐曝光</option>
                        </select>
                    </td>
                    <td>
                        <input name="channelUrl" style="width: 400px" id="channelUrl"/>
                    </td>
                </tr>
                <tr>
                    <td colspan="5">
                        <p style="font-size: 14px; color: red;">
                            说明: 统计分类中fragid包含同时有fragid和name的情况，name表示有name没有fragid的情况，其他表示既不包含fragid又不包含name的情况
                        </p>
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
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_search',plain:true"
       onclick="searchFun();">查询</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true"
       onclick="cleanFun();">清空条件</a>
</div>
</body>
</html>

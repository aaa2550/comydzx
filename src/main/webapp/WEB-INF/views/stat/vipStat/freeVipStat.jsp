<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>免费赠送会员统计</title>
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js" type="text/javascript"></script>
	<script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>
	<script src="${pageContext.request.contextPath}/static/lib/select2.full.js" type="text/javascript"></script>
	<link href="${pageContext.request.contextPath}/static/style/select2.min.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript">
        /**
         * 待绑定行数据
         */
        var rows;

        var dataGrid;
        $(function () {
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/vipController/freevip/query');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').datagrid({
                url: url,
                fit: true,
                fitColumns: false,
                border: false,
                pagination: true,
                idField: 'channelId',
                pageSize: 50,
                pageList: [ 10, 20, 50 ],
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
                            field: 'channelName',
                            title: '渠道名称',
                            width: 130,
                            sortable: true
                        },{
                            field: 'userCount',
                            title: '用户数',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'regularMoney',
                            title: '移动影视会员价值(元)',
                            width: 130,
                            sortable: true
                        },
                        {
                            field: 'proMoney',
                            title: '全屏影视会员价值(元)',
                            width: 130,
                            sortable: true
                        },
                        {
                            field: 'totalMoney',
                            title: '赠送总价值(元)',
                            width: 130,
                            sortable: true
                        },{
                            field: 'xufeiCount',
                            title: '续费用户数',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'xufeiMoney',
                            title: '续费总价值(元)',
                            width: 130,
                            sortable: true
                        },
                        {
                            field: 'xufeiRate',
                            title: '续费率',
                            width: 100,
                            sortable: true,
                            formatter: function (value, row, index) {
                                return $.formatString('{0}%', row.xufeiRate);
                            }
                        },
                        {
                            field: 'todayCount',
                            title: '今天赠送的用户数',
                            width: 100,
                            sortable: true
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
        	var s = $("input[name=xufeiBeginDate]").val();
		     var s1 = $("input[name=xufeiEndDate]").val();
		     if(Math.abs(((new Date(Date.parse(s1)) - new Date(Date.parse(s)))/1000/60/60/24)) - 60 < 0){
              dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
		     }else{
		       alert("续费时间查询范围是60天!!!");
		     }
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
        
        $(function () {
        	$("#channelId").select2();
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
                    <td>渠道名称</td>
                    <td>终端</td>
                    <td>赠送时间</td>
                    <td></td>
                    <td>续费时间</td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                	<td>
                        <select name="channelId" id="channelId" style="width: 220px" id="two">
                        	<option value="-2">全部</option>
                            <c:forEach items="${freeVipChannel}" var="var">
        				    	<option value='${var.id}' >${var.id}-${var.name}</option>
                          	</c:forEach>
                        </select>
                    </td>
                    <td>
                        <select name="terminal" style="width: 160px" id="one">
                            <option value="-2">全部</option>
                            <option value="130">mobile</option>
                            <option value="112">pc</option>
                            <option value="111">tv</option>
                            <option value="113">M站</option>
                        </select>
                    </td>
                    <td>
                        <input name="queryBeginDate" id="queryBegin" class="easyui-datebox"   data-options="required:true" value="${start}" style="width: 160px; height: 29px"/>
                    </td>

                    <td>
                        <input name="queryEndDate" id="queryEnd" class="easyui-datebox"   data-options="required:true" value="${end}" style="width: 160px; height: 29px">
                    </td>
                    <td>
                        <input name="xufeiBeginDate" id="xufeiBegin" class="easyui-datebox"   data-options="required:true" value="${xufeiBegin}" style="width: 160px; height: 29px"/>
                    </td>

                    <td>
                        <input name="xufeiEndDate" id="xufeiEnd" class="easyui-datebox"   data-options="required:true" value="${xufeiEnd}" style="width: 160px; height: 29px">
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
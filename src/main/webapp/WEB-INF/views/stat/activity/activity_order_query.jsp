<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>活动数据查询</title>
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
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/activity/orderQuery/dataGrid');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').datagrid({
                url: url,
                fit: true,
                fitColumns: false,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 100,
                pageList: [ 20, 40, 60, 80, 100 ],
                //sortName: 'id',
                //sortOrder: 'desc',
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
                queryParams: $.serializeObject($('#searchForm')),
                columns: [
                    [
						{
						    field: 'activityId',
						    title: '活动Id',
						    width: 120,
						    sortable: true
						},
                        {
                            field: 'title',
                            title: '活动名称',
                            width: 200,
                            sortable: true
                        },{
                            field: 'label',
                            title: '活动标签',
                            width: 120,
                            sortable: true
                        },
                        {
                            field: 'beginDate',
                            title: '开始时间',
                            width: 120,
                            sortable: true
                        },
                        {
                            field: 'endDate', 
                            title: '结束时间',
                            width: 120,
                            sortable: true
                        },
                        {
                            field: 'comfirmOpenCount', 
                            title: '确认开通订单数',
                            width: 120,
                            sortable: true
                        },
                        {
                            field: 'succOrderCount', 
                            title: '支付成功订单数',
                            width: 120,
                            sortable: true
                        },
                        {
                            field: 'income', 
                            title: '活动收入（元）',
                            width: 120,
                            sortable: true
                        },
                        {
                            field: 'succOrderPayRate', 
                            title: '支付成功转化率',
                            width: 120,
                            sortable: true,
                            formatter : function(value, row, index){
                            	return value + "%";
                            }
                        },
                        {
                            field: 'operation', 
                            title: '操作',
                            width: 	120,
                            sortable: false,
                            formatter : function(value, row, index) {
                                return '<a href="javascript:void(0)" onclick=exportOrderDetail('+row.activityId+')>导出活动订单</a>';
                            }
                        }
                    ]
                ],
                toolbar: '#toolbar',
                onLoadSuccess: function (data) {
                    parent.$.messager.progress('close') ;
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
        
        
        function exportOrderDetail(activityId) {
        	var url = '${pageContext.request.contextPath}/tj/activity/orderQuery/exportDetail?activityId=' + activityId + "&beginDate=" + $("input[name=beginDate]").val() + "&endDate=" + $("input[name=endDate]").val();
        	location.href = url;
        }
        
        function searchFun() {
			var s = $("input[name=beginDate]").val();
		    var s1 = $("input[name=endDate]").val();
		    if(Math.abs(((new Date(Date.parse(s1)) - new Date(Date.parse(s)))/1000/60/60/24)) > 0){
            	dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
		    }else{
		    	alert("结束时间必须大于开始时间");
		    }
        }
        
        function dataExplain(){
        	$("#dataExplain").dialog({
        	    title: '字段解释',
        	    width: 520,
        	    height: 170,
        	    closed: false,
        	    modal: true
        	});
        }
        
    </script>
    
    <style>
        .span {
            padding: 10px;
        }
        .dataExplain{padding:10px 10px;font-size:15px;}
    </style>
</head>
<body>
<div id="dataExplain" closed="true" class="dataExplain easyui-dialog">
	<p>1.活动标签：活动特殊标记，比如双十一活动、919活动；</p>
	<p>2.确认开通订单：通过活动生成的会员订单（包含未支付成功）</p>
	<p>3.支付成功订单：在某一时间段内通过该活动支付成功的订单数量；</p>
	<p>4.活动收入：在某一时间段内通过该活动收入价值；</p>
	<p>5.支付成功转化率：支付成功订单除以总订单；</p>
	<p>6.导出活动订单：导出参与活动的订单详情；</p>
</div>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false"
         style="height: 120px; overflow: auto;">
        <form id="searchForm">
            <table class="table table-hover table-condensed">
                <tr>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>活动ID</td>
                    <td>活动标签</td>
                    <td>终端</td>
                    <td>活动状态</td>
                </tr>
                <tr>
                    <td>
                        <input name="beginDate" id="begin" class="easyui-datebox" validType="TimeCheck"  data-options="required:true" value="${beginDate}" style="width: 160px; height: 29px"/>
                    </td>
                    <td>
                        <input name="endDate" id="end" class="easyui-datebox" validType="TimeCheck"  data-options="required:true" value="${endDate}" style="width: 160px; height: 29px"/>
                    </td>
                    <td>    
                        <input name="activityId" class="easyui-textbox style="width: 160px; height: 29px"/>
                    </td>
                    <td>
                        <select name="label" style="width: 220px" >
                        	<option value="">全部</option>
                            <c:forEach items="${labelList}" var="var">
                                <option value='${var}'>${var}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <select name="terminal" style="width: 160px" id="terminal">
                            <option value="" selected="selected">全部</option>
                            <c:forEach items="${terminalList}" var="var">
                                <option value='${var.terminalId}'>${var.terminalName}</option>
                            </c:forEach>
                        </select>
                    </td><td>
                        <select name="status" style="width: 160px" id="status">
                            <c:forEach items="${statusList}" var="var">
                                <option value='${var.value}'>${var.description}</option>
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
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>
       <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'help',plain:true" onclick="dataExplain();">字段解释</a>
     <!-- <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="exportFile();">导出文件</a> -->
</div>


</body>
</html>
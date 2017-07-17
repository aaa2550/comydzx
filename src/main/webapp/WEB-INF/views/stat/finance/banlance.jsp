<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>对账统计</title>
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
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/balanceAccount/dataGrids');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').datagrid({
                url: url,
                fit: true,
                fitColumns: false,
                border: false,
                pagination: true,
                idField: 'paydate',
                pageSize: 50,
                pageList: [50, 100],
                sortName: 'paydate',
                sortOrder: 'asc',
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
                            field: 'paydate',
                            title: '日期',
                            width: 130,
                            sortable: true
                        },{
                            field: 'otherNum',
                            title: '渠道有boss无(订单)',
                            width: 130,
                            sortable: true
                        },
                        {
                            field: 'otherMoney',
                            title: '渠道有boss无(金额)',
                            width: 130,
                            sortable: true
                        },
                        {
                            field: 'bossNum',
                            title: '渠道无boss有(订单)',
                            width: 130,
                            sortable: true
                        },
                        {
                            field: 'bossMoney',
                            title: '渠道无boss有(金额)',
                            width: 130,
                            sortable: true
                        },{
                            field: 'allNum',
                            title: '双方均含笔数',
                            width: 130,
                            sortable: true
                        },
                        {
                            field: 'allMoney',
                            title: '双方均含金额',
                            width: 130,
                            sortable: true
                        },{
                            field: 'bossRefundMoney',
                            title: 'boss退费',
                            width: 130,
                            sortable: true
                        },
                        {
                            field: 'otherRefundMoney',
                            title: '渠道退费',
                            width: 130,
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
        	var s = $("input[name=sdate]").val();
		     var s1 = $("input[name=edate]").val();
		     if(Math.abs(((new Date(Date.parse(s1)) - new Date(Date.parse(s)))/1000/60/60/24)) - 32 < 0){
              dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
		     }else{
		       alert("对账时间范围最多为31天!!!");
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
   

        function importFile() {
            parent.$.modalDialog({
                title: '导入对账文件',
                width: 680,
                height: 300,
                href: '${pageContext.request.contextPath}/tj/balanceAccount/importView',
                buttons: [
                    {
                        text: '导入文件',
                        handler: function () {
                            parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                            var f = parent.$.modalDialog.handler.find('#form');
                            f.submit();
                        }
                    },
                    {
                        text: "关闭",
                        handler: function () {
                            parent.$.modalDialog.handler.dialog('close');
                        }
                    }
                ]
            });
        }
        
        function exportFile() {
        	var startDate = $('#queryBegin').datetimebox("getValue");
        	var endDate = $('#queryEnd').datetimebox("getValue");;
        	var paytype = $('#paytype').val();
        	var url = '${pageContext.request.contextPath}/tj/balanceAccount/exportFile?paytype='+paytype+'&sdate='
        			+ startDate + '&edate='+ endDate;
        	location.href = url;
        }
        
        function exportIncomeFile() {
        	var startDate = $('#queryBegin').datetimebox("getValue");
        	var endDate = $('#queryEnd').datetimebox("getValue");;
        	var paytype = $('#paytype').val();
        	var url = '${pageContext.request.contextPath}/tj/balanceAccount/exportIncomeFile?paytype='+paytype+'&sdate='
        			+ startDate + '&edate='+ endDate;
        	location.href = url;
        }
        
        function exportRefundFile() {
        	var startDate = $('#queryBegin').datetimebox("getValue");
        	var endDate = $('#queryEnd').datetimebox("getValue");;
        	var paytype = $('#paytype').val();
        	var url = '${pageContext.request.contextPath}/tj/balanceAccount/exportRefundFile?paytype='+paytype+'&sdate='
        			+ startDate + '&edate='+ endDate;
        	location.href = url;
        }
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
         style="height: 100px; overflow: auto;padding-top: 20px;padding-left: 20px" >
         
         <form id="searchForm">
            <table style=>
                <tr>
                	<td>商户号：
                        <select name="paytype" id="paytype" style="width: 210px" id="two">
                            <c:forEach items="${paytypes}" var="paytype">
        				    	<option value='${paytype.merchantid}'>${paytype.merchantid}[${paytype.name}]</option>
                          	</c:forEach>
                        </select>
                    </td>
                    
                    <td style="padding-left: 50px">
                        	对账时间：<input name="sdate" id="queryBegin" class="easyui-datebox"   data-options="required:true" value="${sdate}" style="width: 160px; height: 29px"/>
                        ———<input name="edate" id="queryEnd" class="easyui-datebox"   data-options="required:true" value="${edate}" style="width: 160px; height: 29px">
                    </td>
                    <td>(*说明:上传文件必须为excel,大小不能超过20M)</td>
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
       data-options="iconCls:'brick_add',plain:true" onclick="importFile();">导入对账文件</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="exportFile();">导出对账结果文件</a>
    
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="exportIncomeFile();">导出收入差异明细</a>
       
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="exportRefundFile();">导出退款差异明细</a>
       
    <a href="${pageContext.request.contextPath}/static/stat/balance_account_model.xlsx" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" >导出上传模板文件</a>
</div>

</body>
</html>
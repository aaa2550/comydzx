<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>活动页面统计</title>
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
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/activity/directorder/dataGrid');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').datagrid({
                url: url,
                fit: true,
                fitColumns: false,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 50,
                pageList: [ 10, 20, 30, 40, 50 ],
                sortName: 'dt',
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
						    field: 'dt',
						    title: '日期',
						    width: 100,
						    sortable: true
						},
                        {
                            field: 'payNum',
                            title: '付费人数',
                            width: 100,
                            sortable: true
                        },{
                            field: 'money',
                            title: '收入',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'terminal',
                            title: '终端',
                            width: 100,
                            sortable: false
                        },
                        {
                            field: 'ordertype', 
                            title: '购买套餐',
                            width: 200,
                            sortable: false
                        }
                    ]
                ],
                toolbar: '#toolbar',
                onLoadSuccess: function (data) {
                    parent.$.messager.progress('close') ;
                    rows = data['rows'];
                  //  loadChart(data) ;
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
        
        function searchFun() {
        	var s = $("input[name=sdate]").val();
		     var s1 = $("input[name=edate]").val();
		     if(Math.abs(((new Date(Date.parse(s1)) - new Date(Date.parse(s)))/1000/60/60/24)) - 32 < 0){
              dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
		     }else{
		       alert("对账时间范围最多为31天!!!");
		     }
        }
        
        function exportFile() {
        	var startDate = $('#begin').datetimebox("getValue");
        	var endDate = $('#end').datetimebox("getValue");;
        	var uurl = $('#url').val();
        	var url = '${pageContext.request.contextPath}/tj/activity/export/directOrderFile?sdate='
        			+ startDate + '&edate='+ endDate + '&url='+ uurl;
        	location.href = url;
        }
        
        function exportDetailFile() {
        	var startDate = $('#begin').datetimebox("getValue");
        	var endDate = $('#end').datetimebox("getValue");;
        	var uurl = $('#url').val();
        	var url = '${pageContext.request.contextPath}/tj/activity/export/detailOrderFile?sdate='
        			+ startDate + '&edate='+ endDate + '&url='+ uurl;
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
         style="height: 120px; overflow: auto;">
        <form id="searchForm">
            <table class="table table-hover table-condensed">
                <tr>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>url</td>
                </tr>
                <tr>
                    <td>
                        <input name="sdate" id="begin" class="easyui-datebox" validType="TimeCheck"  data-options="required:true" value="${sdate}" style="width: 160px; height: 29px"/>
                    </td>
                    
                    <td>
                        <input name="edate" id="end" class="easyui-datebox" validType="TimeCheck"  data-options="required:true" value="${edate}" style="width: 160px; height: 29px"/>
                    </td>
                  
                    <td>
                    	<input name="url" style="width: 300px" id="url" class="easyui-validatebox" />
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
       data-options="iconCls:'brick_add',plain:true" onclick="exportFile();">导出数据</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="exportDetailFile();">导出详细订单</a>
</div>

</body>
</html>
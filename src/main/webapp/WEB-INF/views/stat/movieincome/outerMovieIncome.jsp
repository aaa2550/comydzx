<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>影片站外渠道收入</title>
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
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/movieIncome/outerMovieIncome/dataGrid');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').datagrid({
                url: url,
                fit: true,
                fitColumns: false,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 20,
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
                            field: 'channelPara',
                            title: '站外渠道',
                            width: 200,
                            sortable: false
                        },
                        {
                            field: 'movieName',
                            title: '影片名称',
                            width: 200,
                            sortable: false
                        },
                        {
                            field: 'pid',
                            title: '专辑id',
                            width: 100,
                            sortable: false
                        },
                        {
                            field: 'uv', 
                            title: '流量',
                            width: 100,
                            sortable: true
                        },
                        
                        {
                            field: 'payNum',
                            title: '付费人数',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'payMoney',
                            title: '付费金额',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'rate',
                            title: '付费转化率',
                            width: 100,
                            formatter: function (value, row, index) {
                                return $.formatString('{0}%',  Math.round(row.payNum/row.uv*10000)/100);
                            },
                            sortable: true
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
        	var pid = $('#pid').val();
        	var movieName = $('#movieName').val();
        	var channelPara = $('#channelPara').val();
        	var url = '${pageContext.request.contextPath}/tj/movieIncome/outerMovieIncome/excel?pid='+pid+'&sdate='
        			+ startDate + '&edate='+ endDate + '&movieName='+ movieName + '&channelPara='+ channelPara;
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
                    <td>pid</td>
                    <td>影片名称</td>
                    <td>站外渠道</td>
                </tr>
                <tr>
                    <td>
                        <input name="sdate" id="begin" class="easyui-datebox" validType="TimeCheck"  data-options="required:true" value="${start}" style="width: 160px; height: 29px"/>
                    </td>
                    
                    <td>
                        <input name="edate" id="end" class="easyui-datebox" validType="TimeCheck"  data-options="required:true" value="${end}" style="width: 160px; height: 29px"/>
                    </td>
                    <td>
                        <input name="pid" id="pid"  style="width: 160px;" class="easyui-validatebox"/>
                    </td>
					<td>
                    	<input name="movieName" style="width: 200px" id="movieName" class="easyui-validatebox" />
                    </td>
                   
                    <td>
                    	<input name="channelPara" style="width: 200px" id="channelPara" class="easyui-validatebox" />
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
       data-options="iconCls:'brick_add',plain:true" onclick="exportFile();">导出文件</a>
</div>

</body>
</html>
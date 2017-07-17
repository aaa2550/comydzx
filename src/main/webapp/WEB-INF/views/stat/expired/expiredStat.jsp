<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>服务到期会员uid</title>
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
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/expiredStat/dataGrid');
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
                pageList: [ 10 ],
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
                            field: 'count',
                            title: '服务到期会员数',
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
        
        function exportExcel() {
        	var begin = $('#queryBegin').combobox('getValue'); 
        	var end = $('#queryEnd').combobox('getValue'); 
        	var type = $("#typeid").val() ;
        	var viptype = $("#viptypeid").val() ;
        	var url = '${pageContext.request.contextPath}/tj/expiredStat/excel?beginDate='+begin + '&endDate=' + end + '&type=' + type + '&vipType=' + viptype;
        	location.href= url ;
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
   
        $.extend($.fn.validatebox.defaults.rules,{ 
 		   TimeCheck:{ 
 		    validator:function(){     
 		     var s = $("input[name=beginDate]").val();
 		     var s1 = $("input[name=endDate]").val(); 
 		     return Math.abs(((new Date(Date.parse(s1)) - new Date(Date.parse(s)))/1000/60/60/24)) - 7 < 0; 
 		    }, 
 		    message:'非法数据' 
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
         style="height: 120px; overflow: auto;">
        <form id="searchForm">
            <table class="table table-hover table-condensed">
                <tr>
                    <td>开始时间</td>
                    <td>结束时间</td>
                    <td>会员类型</td>
                    <td>筛选条件</td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <input name="beginDate" id="queryBegin" class="easyui-datebox"   data-options="required:true" value="${start}" style="width: 160px; height: 29px"/>
                    </td>

                    <td>
                        <input name="endDate" id="queryEnd" class="easyui-datebox"   data-options="required:true" value="${end}" style="width: 160px; height: 29px">
                    </td>
                    <td>
                    	<select name="vipType" id="viptypeid" style="width: 160px">
                    		<option value="-2">全部</option>
                            <option value="1">移动影视会员</option>
                            <option value="9">全屏影视会员</option>
                        </select>
                    </td>
                    <td>
                    	<select name="type" id="typeid" style="width: 160px">
                            <option value="1" selected>剔除免费和自动续费</option>
                            <option value="2">免费赠送</option>
                            <option value="3">自动续费</option>
                        </select>
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
    <a href="javascript:void(0);" class="easyui-linkbutton"
		data-options="iconCls:'brick_delete',plain:true"
		onclick="exportExcel();">导出到期uid</a>
</div>

</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>花呗支付统计</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>

<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid').datagrid(
						{
							url : '${pageContext.request.contextPath}/tj/jtStatController/huabeiStatQuery',
							queryParams:$.serializeObject($('#searchForm')),
							fit : true,
							fitColumns : true,
							border : false,
							pagination : true,
							idField : 'id',
							pageSize : 50,
							pageList : [ 10, 20, 30, 40, 50 ],
							checkOnSelect : false,
							selectOnCheck : false,
							sortName: 'date',
			                sortOrder: 'asc',
							nowrap : false,
							striped : true,
							rownumbers : true,
							singleSelect : true,
							frozenColumns : [ [ {
								field : 'id',
								title : '编号',
								width : 150,
								hidden : true
							} ] ],
							columns : [ [
									{
										field : 'date',
										title : '日期',
										width : 150,
										sortable : true
									},
									{
										field : 'clickNum',
										title : '分期点击数',
										width : 150,
										sortable : false
									},
									{
										field : 'succNum',
										title : '成功订单数',
										width : 150,
										sortable : false
									},
									{
										field : 'succMoneyStr',
										title : '成功订单金额',
										width : 150,
										sortable : false
									},
									
									{
										field : 'stage3Rate',
										title : '3期订单占比',
										width : 150,
										formatter: function (value, row, index) {
			                                return $.formatString('{0}%', row.stage3Rate);
			                            }
									},
									{
										field : 'stage6Rate',
										title : '6期订单占比',
										width : 150,
										formatter: function (value, row, index) {
			                                return $.formatString('{0}%', row.stage6Rate);
			                            }
									},
									{
										field : 'stage9Rate',
										title : '9期订单占比',
										width : 150,
										formatter: function (value, row, index) {
			                                return $.formatString('{0}%', row.stage9Rate);
			                            }
									},
									{
										field : 'stage12Rate',
										title : '12期订单占比',
										width : 150,
										formatter: function (value, row, index) {
			                                return $.formatString('{0}%', row.stage12Rate);
			                            }
									},
									{
										field : 'succRate',
										title : '转化率',
										width : 150,
										formatter: function (value, row, index) {
			                                return $.formatString('{0}%', row.succRate);
			                            }
									}
									

							] ],
							toolbar : '#toolbar',
							onLoadSuccess : function() {
								$('#searchForm table').show();
								parent.$.messager.progress('close');
							},
							onRowContextMenu : function(e, rowIndex, rowData) {
								e.preventDefault();
								$(this).datagrid('unselectAll');
								$(this).datagrid('selectRow', rowIndex);
								$('#menu').menu('show', {
									left : e.pageX,
									top : e.pageY
								});
							}
						});
	});
	
	function searchFun() {
    	var s = $("#begin").val();
	     var s1 = $("#end").val(); 
	     if(Math.abs(((new Date(Date.parse(s1.substring(0,10))) - new Date(Date.parse(s.substring(0,10))))/1000/61/60/24)) - 31 < 0){
          dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
	     }else{
	       alert("查询时间范围是31天!!!");
	     }
    }
    
    function cleanFun() {
        $('#searchForm input').val('');
        dataGrid.datagrid('load', {});
    }
	
	
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'查询条件',border:false"
			style="height: 140px; overflow: hidden;">
			<form id="searchForm">
				<table class="table-more">
					<tr>
	                    <td>开始日期</td>
	                    <td>结束日期</td>
	                </tr>
						
						
					 <tr>
	                    <td>
	                        <input name="beginDate" id="begin" class="easyui-datebox" validType="TimeCheck" invalidMessage="查询时间范围是30天!!!" data-options="required:true" value="${sdate}" style="width: 160px; height: 29px"/>
	                    </td>
	
	                    <td>
	                        <input name="endDate" id="end" class="easyui-datebox" validType="TimeCheck" invalidMessage="查询时间范围是30天!!!" data-options="required:true" value="${edate}" style="width: 160px; height: 29px">
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
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a><a
			href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_delete',plain:true"
			onclick="cleanFun();">清空条件</a>
	</div>
</body>
</html>
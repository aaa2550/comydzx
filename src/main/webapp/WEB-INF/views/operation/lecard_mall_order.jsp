<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<title>乐卡申请</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript" src="/js/dict.js"></script>
<script type="text/javascript">

var dataGrid;
$(function () {
    dataGrid = renderDataGrid('/mall/list_order');
});

function renderDataGrid(url) {
    return $('#dataGrid').datagrid({
        url: url,
        fit: true,
        fitColumns: false,
        border: false,
        pagination: true,
        idField: 'batch',
        pageSize: 10,
        pageList: [ 10, 20, 30, 40, 50 ],     
        checkOnSelect: false,
        selectOnCheck: false,
        nowrap: false,
        striped: true,
        rownumbers: true,
        singleSelect: true,
        remoteSort: false,
        frozenColumns: [
            [
                {
                    field: 'id',
                    title: '编号',
                    width: 150,
                    hidden: true
                }
            ]
        ],
        columns: [
            [
                {
                    field: 'orderId',
                    title: '订单',
                    width: 100
                },
                {
                    field: 'channel',
                    title: '渠道',
                    width: 100,
                    formatter: function(value){
                    	return Dict.getName("operator",value);
                    }
                },
                {
                    field: 'phone',
                    title: '手机',
                    width: 100
                    
                },
                {
                    field: 'uid',
                    title: '用户ID',
                    width: 100,
                    formatter: function(value){
                        return value == 0 ? "":value;
                    }

                },
                {
                    field: 'number',
                    title: '卡号',
                    width: 200
                    
                },
                {
                    field: 'itemId',
                    title: '商品id',
                    width: 200
                   
                },
                {
                	  field: 'applyPackageDesc',
                      title: '套餐类型',
                      width: 200	 	
                },
             
                {
                    field: 'price',
                    title: '价格(元)',
                    width: 100
                },
               
                {
                    field: 'activeTime',
                    title: '激活时间',
                    width: 200
                 
                },
         
                {
                    field: 'createTime',
                    title: '申请时间',
                    width: 200,
                    sortable: true
                },
                
                {
                    field: 'expireDate',
                    title: '失效日期',
                    width: 200,
                    sortable: true
                  
                },
                {
                    field: 'flagDesc',
                    title: '状态',
                    width: 50
                 
                }
            ]
        ],
        toolbar: '#toolbar',
        onLoadSuccess: function () {
            $('#searchForm table').show();
            parent.$.messager.progress('close');
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

function exportExcel(batch) {

  var url="/mall/exportexcel?"+$('#searchForm').serialize();  
  
  window.open(url);
}  






function searchFun() {
	dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
  //  renderDataGrid('${pageContext.request.contextPath}/lecard/list.json?' + $('#searchForm').serialize());
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
			style="overflow: hidden; height: 145px">
        <form id="searchForm">
            <table class="table-more" style="display: none;">
                <tr>
                    <td>卡号：<input class="span2" name="number"></td>
<td>手机号：<input class="span2" name="phone"></td>
                    <td>渠道商: <select name="channel"
							style="width: 165px">
								<c:forEach items="${dict.operator}" var="operator">
									<option value="${operator.key}"    ${operator.key==10086 ?"selected":""}  >${operator.value}</option>
								</c:forEach>
						</select>
                    </td>
                    <td>激活状态： <select name="flag" class="span2">
                        <option value="0" selected="selected">全部</option>
                      <option value="1" >已使用</option>
                       <option value="2" >未使用</option>
                    </select>
                    </td>
                    

             
                    </tr>
                    </table>
             <table class="table-more" style="display: none;">
             	<tr>
                    <td>订单时间：<input id="begin" name="createTime"
                                    class="easyui-datebox">
                    --<input id="end" name="updateTime"
                                    class="easyui-datebox"></td>
                    <td>失效日期：<input name="expireDate"
                                    class="easyui-datebox">--<input name="expEnd"
                                    class="easyui-datebox">
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
  <a onclick="exportExcel()" href="javascript:void(0);"
       class="easyui-linkbutton" data-options="plain:true,iconCls:'bug_add'">导出</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a><a
        href="javascript:void(0);" class="easyui-linkbutton"
        data-options="iconCls:'brick_delete',plain:true"
        onclick="cleanFun();">清空条件</a>
</div>


</body>
</html>
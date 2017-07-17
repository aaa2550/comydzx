<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
	    dataGrid = $('#dataGrid')
        .datagrid(
            {
              url : '${pageContext.request.contextPath}/na/lebi/rechargedetail/rechargedetailquery?userid=${userid}',
              queryParams:$.serializeObject($('#searchForm')),
              fit : false,
              fitColumns : true,
              border : false,
              pagination : true,
              idField : 'id',
              pageSize : 50,
              pageList : [ 5, 20, 30, 40, 50 ],
              checkOnSelect : false,
              selectOnCheck : false,
              sortName: 'submitdate',
              sortOrder: 'asc',
              nowrap : false,
              striped : true,
              rownumbers : true,
              singleSelect : true,
              frozenColumns : [ [ {
                field : 'id',
                title : '${internationalConfig.流水号}',
                width : 150,
                hidden : true
              } ] ],
              columns : [ [
                  {
                    field : 'userid',
                    title : '${internationalConfig.用户} ID',
                    width : 200,
                    sortable : false
                  },
                  {
                    field : 'username',
                    title : '${internationalConfig.用户名}',
                    width : 120,
                    sortable : true
                  },
                  {
                    field : 'terminalname',
                    title : '${internationalConfig.终端}',
                    width : 120,
                    sortable : true
                  },
                  {
                    field : 'payname',
                    title : '${internationalConfig.支付方式}',
                    width : 150,
                    sortable : false
                  },
                  {
                    field : 'bizno',
                    title : '${internationalConfig.支付流水号}',
                    width : 180,
                    sortable : false
                  },
                  {
                    field : 'payamount',
                    title : '${internationalConfig.充值金额}',
                    width : 200,
                    sortable : false,
                    formatter: function (value, row, index) {
                    	var str = "";
                    	str = (row.payamount/100).toFixed(2);
						return str;
                    }  
                  },
                  
                  {
                    field : 'paytime',
                    title : '${internationalConfig.支付时间}',
                    width : 100,
                    sortable : true
                  },
                  {
                    field : 'remark',
                    title : '${internationalConfig.备注}',
                    width : 150,
                    sortable : true
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
</script>

  <div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'">
      <form id="searchForm">
      	
      </form>
    </div>
    <div data-options="region:'center',border:false" >
      <table id="dataGrid"></table>
    </div>
  </div>
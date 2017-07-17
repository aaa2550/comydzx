<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<script type="text/javascript">
  var dataGrid;
  $(function() {
	parent.$.messager.progress('close');
    dataGrid = $('#dataGrid')
        .datagrid(
            {
              url : '${pageContext.request.contextPath}/lebi/tradedetail/tradedetailquery?userid=${userid}',
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
              sortName: 'submitdate',
                      sortOrder: 'asc',
              nowrap : false,
              striped : true,
              rownumbers : true,
              singleSelect : true,
              frozenColumns : [ [ {
                field : 'id',
                title : '流水号',
                width : 150,
                hidden : true
              } ] ],
              columns : [ [
              	  {
                    field : 'id',
                    title : '流水号',
                    width : 200,
                    sortable : false
                  },                           
                  {
                    field : 'userid',
                    title : '用户id',
                    width : 200,
                    sortable : false
                  },
                  {
                    field : 'username',
                    title : '用户名称',
                    width : 120,
                    sortable : true
                  },
                  {
                    field : 'terminal',
                    title : '终端',
                    width : 120,
                    sortable : true
                  },
                  {
                      field : 'lbtype',
                      title : '类型',
                      width : 120,
                      sortable : true,
                      formatter: function (value, row, index) {
                    	  var ret = "";
                    	  if( row.lbtype=='xh' ) {
                    		  ret = "消耗";
                    	  } else {
                    		  ret = "充值";
                    	  }
                    	  return ret;
                      }
                    },         
                    {
                        field : 'currencynum',
                        title : '乐币数量',
                        width : 120,
                        sortable : true
                      },  
                      {
                          field : 'currencynumreward',
                          title : '赠送数量',
                          width : 120,
                          sortable : true
                        },                      
                  {
                    field : 'accounttime',
                    title : '交易时间',
                    width : 100,
                    sortable : true
                  },
                  {
                    field : 'remark',
                    title : '备注',
                    width : 150,
                    sortable : true
                  }
              ] ],
              toolbar : '#toolbar',
              onLoadSuccess : function() {
            	  loadsum();
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
  function loadsum() {
	  
		var userid = '${userid}';
		var url = "/lebi/tradedetail/tradedetailquerycount";
		$.post(url,{userid:userid},function(data) {
			
			var datas = data.split(",");
			var jieyu = datas[0];
			var sumcz = datas[1];
			var sumxh = datas[2];
			var sumzs = datas[3];
			var userinfo = datas[4];
			$("#jieyu").html(fnumber(jieyu));
			$("#sumcz").html(fnumber(sumcz));
			$("#sumxh").html(fnumber(sumxh));
			$("#sumzs").html(fnumber(sumzs));
			$("#userinfo").html(userinfo);
		});	  
  }
  function fnumber(num) {
	    var result = '', counter = 0;
	    num = (num || 0).toString();
	    for (var i = num.length - 1; i >= 0; i--) {
	        counter++;
	        result = num.charAt(i) + result;
	        if (!(counter % 3) && i != 0) { result = ',' + result; }
	    }
	    return result;
  }
</script>
  <div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'">
      <form id="searchForm">
            <table style="background-color: #EEEED1;width: 100%">
	            <tr>
	            	<td colspan="4"><span style="font-size: 20px" id="userinfo">--</span></td>
	            </tr>            
	            <tr style="font-size: 35px;font-weight: bold;" height="50px">
	            	<td><span style="color: red" id="jieyu">0</span></td>
	            	<td><span id="sumcz">0</span></td>
	            	<td><span id="sumzs">0</span></td>
	            	<td><span id="sumxh">0</span></td>
	            </tr>
	            <tr>
	            	<td ><span style="font-size: 15px">结余：</span></td>
	            	<td ><span style="font-size: 15px">累计充值总数</span></td>
	            	<td ><span style="font-size: 15px">累计充赠总数</span></td>
	            	<td ><span style="font-size: 15px">累计消耗总数</span></td>
	            </tr>            
            </table>
      </form>
    </div>
    <div data-options="region:'center',border:false">
      <table id="dataGrid"></table>
    </div>
  </div>
  </div>
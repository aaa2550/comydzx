<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<script type="text/javascript">
  var dataGrid;
  $(function() {
	  
    dataGrid = $('#dataGrid')
        .datagrid(
            {
              url : '${pageContext.request.contextPath}/lebi/tradedetail/incomequery?bizid=${bizid}',
              queryParams:$.serializeObject($('#searchForm')),
              fit : false,
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
                              width : 300,
                              sortable : false
                            },   
                            {
                                field : 'bizid',
                                title : '业务线id',
                                width : 50,
                                sortable : false
                              },
                            {
                                field : 'companyid',
                                title : '商户id',
                                width : 50,
                                sortable : false
                              },
                              {
                                field : 'companyname',
                                title : '商户名称',
                                width : 120,
                                sortable : true
                              },                  
                            {
                              field : 'userid',
                              title : '用户id',
                              width : 100,
                              sortable : false
                            },
                            {
                              field : 'username',
                              title : '用户名称',
                              width : 100,
                              sortable : true
                            },
                            {
                              field : 'terminalname',
                              title : '终端',
                              width : 70,
                              sortable : true
                            },
                            {
                                field : 'skuid',
                                title : '商品id',
                                width : 50,
                                sortable : true
                              },                  
                              {
                                  field : 'skuname',
                                  title : '商品名称',
                                  width : 120,
                                  sortable : true
                                },         
                              {
                                  field : 'currencynum',
                                  title : '乐币数量',
                                  width : 80,
                                  sortable : true
                                },                    
                            {
                              field : 'accounttime',
                              title : '交易时间',
                              width : 200,
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
	  
		var bizid = '${bizid}';
		var url = "/lebi/tradedetail/incomequerycount";
		$.post(url,{bizid:bizid},function(data) {
			
			var datas = data.split(",");
			var sumlb = datas[0];
			var userinfo = datas[1];
			$("#sumlb").html(fnumber(sumlb));
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
	            <tr style="font-size: 30px;font-weight: bold;" height="50">
	            	<td><span style="color: red" id="sumlb">0</span></td>
	            </tr>
	            <tr>
	            	<td ><span style="font-size: 15px" >累计乐币总数</span></td>
	            </tr>            
            </table>
      </form>
    </div>
    <div data-options="region:'center',border:false">
      <table id="dataGrid"></table>
    </div>
  </div>

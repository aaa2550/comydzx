<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.集团退款订单查询}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>

<script type="text/javascript">
  var dataGrid;
  $(function() {
    dataGrid = $('#dataGrid')
        .datagrid(
            {
              url : '${pageContext.request.contextPath}/tj/jtStatController/refund_query/data_grid.json',
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
              nowrap : false,
              striped : true,
              rownumbers : true,
              singleSelect : true,
              frozenColumns : [ [ {
                field : 'id',
                title : '${internationalConfig.编号}',
                width : 150,
                hidden : true
              } ] ],
              columns : [ [
                  {
                    field : 'refundnumber',
                    title : '${internationalConfig.退款流水号}',
                    width : 240,
                    sortable : false
                  },  
                  {
                    field : 'ordernumber',
                    title : '${internationalConfig.原支付流水号}',
                    width : 200,
                    sortable : false
                  },
                  {
                    field : 'status',
                    title : '${internationalConfig.退款状态}',
                    width : 110,
                    sortable : true,
                    formatter : function(value) {
                      var str = '';
                      if ("0" == value) {
                        str = "";
                      } else if ("1" == value) {
                        str = "${internationalConfig.退款成功}";
                      } else if ("5" == value) {
                        str = "${internationalConfig.进行中}";
                      } else if ("9" == value) {
                        str = "${internationalConfig.退款失败}";
                      } 
                      return str;
                    }
                  },
                  {
                    field : 'companyname',
                    title : '${internationalConfig.商户名称}',
                    width : 110,
                    sortable : false
                  },
                  {
                    field : 'corderid',
                    title : '${internationalConfig.商户订单号}',
                    width : 200,
                    sortable : false
                  },
                  {
                    field : 'productid',
                    title : '${internationalConfig.备用单号}',
                    width : 150,
                    sortable : true
                  },
                  {
                    field : 'totalprice',
                    title : '${internationalConfig.订单金额}',
                    width : 100,
                    sortable : true
                  },
                  {
                    field : 'refundprice',
                    title : '${internationalConfig.退款金额}',
                    width : 100,
                    sortable : true
                  },
                  {
                    field : 'userid',
                    title : '${internationalConfig.用户ID}',
                    width : 100,
                    sortable : false,
                  },
                  {
                    field : 'transeq',
                    title : '${internationalConfig.第三方流水号}',
                    width : 250,
                    sortable : false
                  },
                  {
                    field : 'paytypename',
                    title : '${internationalConfig.支付方式}',
                    width : 150,
                    sortable : false
                  },
                  {
                    field : 'refunddate',
                    title : '${internationalConfig.退款完成时间}',
                    width : 160,
                    sortable : false
                  },
                  {
                    field : 'submitdate',
                    title : '${internationalConfig.退款请求时间}',
                    width : 160,
                    sortable : false
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
  Date.prototype.format = function(format) {
    if (!format) {
      format = "yyyy-MM-dd hh:mm:ss";
    }
    var o = {
      "M+" : this.getMonth() + 1, // month
      "d+" : this.getDate(), // day
      "h+" : this.getHours(), // hour
      "m+" : this.getMinutes(), // minute
      "s+" : this.getSeconds(), // second
      "q+" : Math.floor((this.getMonth() + 3) / 3), // quarter
      "S" : this.getMilliseconds()
    // millisecond
    };
    if (/(y+)/.test(format)) {
      format = format.replace(RegExp.$1, (this.getFullYear() + "")
          .substr(4 - RegExp.$1.length));
    }
    for ( var k in o) {
      if (new RegExp("(" + k + ")").test(format)) {
        format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k]
            : ("00" + o[k]).substr(("" + o[k]).length));
      }
    }
    return format;
  };
  //$('#win').window({    
  //    collapsible:false,    
  //    minimizable:false,    
  //   maximizable:false    
  //}); 
  function formatterdate(val, row) {
    var date = new Date(val);
    if (date = "Invalid Date") {
      return "";
    }
    return date.format("yyyy-MM-dd hh:mm:ss");
  }
  function searchFun() {
    var name = $('#userId').val();
    //if (name.length <= 0) {
    //$('#win').window('open'); 
    //alert('请输入完整的用户名！') ;
    //} else {
    dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
    //}
  }
  function cleanFun() {
    $('#searchForm input').val('');
    dataGrid.datagrid('load', {});
  }
  
  function editFun(corderid, validatePrice) {
    if (corderid == undefined) {
      var rows = dataGrid.datagrid('getSelections');
      corderid = rows[0].corderid;
    }
    
    if (validatePrice == undefined) {
      var rows = dataGrid.datagrid('getSelections');
      validatePrice = rows[0].validatePrice;
    }
    
  }
  
  function changeQuery(){
    var systemtype = $("#systemtype").val();
    var html=$("#corderid").parent().html();
    if(systemtype == '3'){
      $("#corderid").parent().html(html.replace("${internationalConfig.商户}","${internationalConfig.支付}"));
    }else {
      $("#corderid").parent().html(html.replace("${internationalConfig.支付}", "${internationalConfig.商户}"));
    }
  }
  
</script>
</head>
<body>
  <div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'">
      <form id="searchForm">
        <table class="table-more">
          <tr>
            <td>${internationalConfig.支付系统}： <select name="systemtype" id="systemtype" class="span2" onchange="changeQuery()">
                  <option value="" selected>${internationalConfig.全部}</option>
                  <option value="1">${internationalConfig.旧支付系统}</option>
                  <option value="2">${internationalConfig.新支付系统}</option>
                  <option value="3">${internationalConfig.boss新支付系统}</option>
                </select>
            </td>
            <td>${internationalConfig.支付流水号}：<input id="ordernumber" name="ordernumber"
              class="span2"></input>
            </td>
            <td>${internationalConfig.商户订单号}：<input id="corderid" name="corderid"
              class="span2"></input>
            </td>
            <td>${internationalConfig.备用单号}：<input id="productid" name="productid"
              class="span2"></input>
            </td>
            </tr>
            
            <tr>
            <td>${internationalConfig.支付第三方流水号}：<input id="transeq" name="transeq"
              class="span2"></input>
            </td>
            <td>${internationalConfig.用户ID}：<input id="userid" name="userid" 
              class="span2"></input>
            </td>
            
            <td>${internationalConfig.退款流水号}：<input id="refundnumber" name="refundnumber" 
              class="span2"></input>
            </td>
            <td></td>
            <td></td>
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
      data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a><a
      href="javascript:void(0);" class="easyui-linkbutton"
      data-options="iconCls:'brick_delete',plain:true"
      onclick="cleanFun();">${internationalConfig.清空条件}</a>
  </div>
</body>
</html>
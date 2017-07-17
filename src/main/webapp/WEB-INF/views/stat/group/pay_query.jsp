<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.集团支付信息查询}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>

<script type="text/javascript">
  var dataGrid;
  $(function() {
    dataGrid = $('#dataGrid')
        .datagrid(
            {
              url : '${pageContext.request.contextPath}/tj/jtStatController/pay_query/data_grid.json',
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
                title : '${internationalConfig.编号}',
                width : 150,
                hidden : true
              } ] ],
              columns : [ [
                  {
                    field : 'ordernumber',
                    title : '${internationalConfig.支付流水号}',
                    width : 200,
                    sortable : false
                  },
                  {
                    field : 'status',
                    title : '${internationalConfig.支付状态}',
                    width : 120,
                    sortable : true,
                    formatter : function(value, row, index) {
                      var str = '';
                      var systemtype = row.systemtype;
                      if("1" == systemtype){
                        if ("-1" == value) {
                          str = "${internationalConfig.未支付}";
                        } else if ("0" == value) {
                          str = "${internationalConfig.支付失败}";
                        } else if ("1" == value || "3" == value) {
                          str = "${internationalConfig.支付成功}";
                        } else {
                          str = "${internationalConfig.未支付}";
                        }
                      } else if("2" == systemtype){
                        if ("0" == value) {
                          str = "${internationalConfig.未支付}";
                        } else if ("1" == value) {
                          str = "${internationalConfig.支付成功}";
                        } else if ("2" == value) {
                          str = "${internationalConfig.支付处理中败}";
                        } else if ("3" == value) {
                          str = "${internationalConfig.支付状态未知}";
                        } else if ("4" == value) {
                          str = "${internationalConfig.支付异常}";
                        } else if ("5" == value) {
                          str = "${internationalConfig.支付成功}";
                        } else if ("9" == value) {
                          str = "${internationalConfig.支付失败}";
                        } else {
                          str = "${internationalConfig.未支付}";
                        }
                      } else if("3" == systemtype){
                        if ("0" == value) {
                          str = "${internationalConfig.未支付}";
                        } else if ("4" == value) {
                          str = "${internationalConfig.支付失败}";
                        } else if ("1" == value || "3" == value || "2" == value) {
                          str = "${internationalConfig.支付成功}";
                        } 
                      }
                      
                      return str;
                    }
                  },
                  {
                    field : 'refundstatus',
                    title : '${internationalConfig.是否退款}',
                    width : 120,
                    sortable : true,
                    formatter : function(value) {
                      var str = '';
                      if ("1" == value) {
                        str = "${internationalConfig.已退款}";
                      } else if ("9" == value) {
                        str = "${internationalConfig.退款失败}";
                      } 
                      if("3" == $("#systemtype").val()){
                        if ("2" == value) {
                          str = "${internationalConfig.部分退款}";
                        } else if ("3" == value) {
                          str = "${internationalConfig.退款}";
                        }  
                      }
                      return str;
                    }
                  },
                  {
                    field : 'companyname',
                    title : '${internationalConfig.商户名称}',
                    width : 150,
                    sortable : false
                  },
                  {
                    field : 'corderid',
                    title : '${internationalConfig.商户订单号}',
                    width : 180,
                    sortable : false
                  },
                  {
                    field : 'productname',
                    title : '${internationalConfig.商品名称}',
                    width : 200,
                    sortable : false
                  },
                  
                  {
                    field : 'price',
                    title : '${internationalConfig.支付金额}',
                    width : 100,
                    sortable : true
                  },
                  {
                    field : 'productid',
                    title : '${internationalConfig.备用单号}',
                    width : 150,
                    sortable : true
                  },
                  {
                    field : 'userid',
                    title : '${internationalConfig.用户ID}',
                    width : 100,
                    sortable : false,
                  },
                  {
                    field : 'paytypename',
                    title : '${internationalConfig.支付方式}',
                    width : 150,
                    sortable : false
                  },
                  {
                    field : 'signnumber',
                    title : '${internationalConfig.收款账号}',
                    width : 150,
                    sortable : true
                  },
                  {
                    field : 'transeq',
                    title : '${internationalConfig.银行流水号}',
                    width : 250,
                    sortable : false
                  },
                  {
                    field : 'paymentdate',
                    title : '${internationalConfig.支付时间}',
                    width : 160,
                    sortable : false
                  },
                  {
                    field : 'submitdate',
                    title : '${internationalConfig.提交订单时间}',
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
    
    parent.$.modalDialog({
      title : '${internationalConfig.退费操作}',
      width : 600,
      height : 200,
      href : '${pageContext.request.contextPath}/tj/jtStatController/pay_query/refund_edit.json?corderid='
          + corderid + "&validatePrice=" + validatePrice,
      onClose:function(){
        this.parentNode.removeChild(this);
      },    
      buttons : [ {
        text : '${internationalConfig.退款}',
        handler : function() {
          parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
          var f = parent.$.modalDialog.handler.find('#form');
          f.submit();
        }
      }, {
        text : "${internationalConfig.关闭}",
        handler : function() {
          parent.$.modalDialog.handler.dialog('close');
        }
      } ]
    });
  }
  
  function changeQuery(){
    var systemtype = $("#systemtype").val();
    if(systemtype == '3'){
      $("#corderidname").html("${internationalConfig.支付订单号}：");
    }else {
      $("#corderidname").html("${internationalConfig.商户订单号}：");
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
                  <option value="3">${internationalConfig.新支付系统}</option>
                </select>
            </td>
            <td>${internationalConfig.支付流水号}：<input id="ordernumber" name="ordernumber"
              class="span2"></input>
            </td>
            <td><span id="corderidname" >${internationalConfig.商户订单号}：</span><input id="corderid" name="corderid"
              class="span2"></input>
            </td>
            <td>${internationalConfig.备用单号}：<input id="productid" name="productid"
              class="span2"></input>
            </td>
            </tr>
            
            
            <tr>
            <td>${internationalConfig.用户ID}：<input id="userid" name="userid" 
              class="span2"></input>
            </td>
            <td>${internationalConfig.第三方流水号}：<input id="transeq" name="transeq"
              class="span2"></input>
            </td>
            <td>${internationalConfig.支付状态}： <select name="paystaus" class="span2">
                <option value="1" selected>${internationalConfig.已支付}</option>
                <option value="2">${internationalConfig.未支付}</option>
              </select>
            </td>
            </tr>
            </table>
      </form>
      <p style="color: red;">${internationalConfig.pay_query_tip}</p>
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
  <!-- <div id="win" class="easyui-window" title="输入提示框" closed="true" 
   collapsible="false" minimizable="false" maximizable="false" style="width:300px;height:100px;padding:5px;color: red;">  
  <font size="2">请输入完整的用户名! </font>  
    </div>  -->
</body>
</html>
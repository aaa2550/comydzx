<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.用户自动续费查询}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
  var dataGrid;
  $(function() {
    dataGrid = $('#dataGrid')
        .datagrid(
            {
              url : '/auto_renewal_record/data_grid.json',
              fit : true,
              fitColumns : true,
              border : false,
              pagination : true,
              idField : 'id',
              pageSize : 10,
              pageList : [10, 20, 30, 40, 50 ],
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
                    field : 'userid',
                    title : '${internationalConfig.用户ID}',
                    width : 100,
                    sortable : true
                  },
                  {
                    field : 'username',
                    title : '${internationalConfig.用户名}',
                    width : 240,
                    sortable : true
                  },
                  {
                    field : 'ordernumber',
                    title : '${internationalConfig.支付订单号}',
                    width : 200,
                    sortable : true
                  },
                  {
                    field : 'corderid',
                    title : '${internationalConfig.商户订单号}',
                    width : 180,
                    sortable : true
                  },
                  {
                    field : 'price',
                    title : '${internationalConfig.支付金额}',
                    width : 100,
                    sortable : true
                  },
                  {
                    field : 'svip',
                    title : '${internationalConfig.VIP类型}',
                    width : 100,
                    sortable : true,
                    formatter : function(value) {
                      var str = '${internationalConfig.未知}';
                      if ("1" == value) {
                        str = "${internationalConfig.普通VIP}";
                      } else if ("9" == value) {
                        str = "${internationalConfig.高级VIP}";
                      }
                      return str;
                    }
                  },
                  {
                    field : 'productid',
                    title : '${internationalConfig.套餐类型}',
                    width : 120,
                    sortable : true,  
                    formatter : function(value) {
                      var str = '${internationalConfig.未知}';
                      if ("2" == value) {
                        str = "${internationalConfig.包月}";
                      } else if ("3" == value) {
                        str = "${internationalConfig.包季}";
                      } else if ("4" == value) {
                        str = "${internationalConfig.包半年}";
                      } else if ("5" == value) {
                        str = "${internationalConfig.包年}";
                      } else if ("6" == value) {
                        str = "${internationalConfig.包三年}";
                      }
                      return str;
                    }
                  },
                  {
                    field : 'renewtime',
                    title : '${internationalConfig.开通时间}',
                    width : 180,
                    sortable : true
                  },
                  {
                    field : 'paytype',
                    title : '${internationalConfig.支付方式}',
                    width : 100,
                    sortable : true,
                    formatter : function(value) {
                      var str = '${internationalConfig.未知}';
                      if ("6" == value) {
                        str = "${internationalConfig.支付宝}";
                      } else if ("50" == value) {
                        str = "${internationalConfig.支付宝手机}";
                      } else if ("32" == value
                          || "33" == value) {
                        str = "${internationalConfig.乐点}";
                      } else if ("8" == value) {
                        str = "${internationalConfig.一键}";
                      } else if ("9" == value) {
                        str = "${internationalConfig.快钱}";
                      } else if ("40" == value) {
                        str = "${internationalConfig.IAP}";
                      } else if ("2" == value) {
                        str = "${internationalConfig.财付通}";
                      } else if ("51" == value) {
                        str = "${internationalConfig.兑换码}";
                      }else if ("24" == value) {
                        str = "${internationalConfig.微信支付}";
                      }
                      return str;
                    }
                  },
                  {
                    field : 'status',
                    title : '${internationalConfig.服务状态}',
                    width : 120,
                    sortable : true,
                    formatter : function(value) {
                      var str = '';
                      if ("0" == value) {
                        str = "${internationalConfig.服务已取消}";
                      } else if ("1" == value) {
                        str = "${internationalConfig.服务正常}";
                      } 
                      return str;
                    }
                  },
                  {
                    field : 'action',
                    title : '${internationalConfig.操作}',
                    width : 100,
                    formatter : function(value, row, index) {
                      var str = '&nbsp;&nbsp;&nbsp;';
                      if (row.status == 1){
                        str += $
                            .formatString(
                                '<img onclick="cancel(\'{0}\',\'{1}\',\'{2}\',\'{3}\');" src="{4}" title="${internationalConfig.取消服务}"/>',
                                row.userid,row.paytype,row.svip,row.channelId,
                                '${pageContext.request.contextPath}/static/style/images/extjs_icons/bug/bug_delete.png');
                      }
                      return str;
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
    dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
  }
  function cleanFun() {
    $('#searchForm input').val('');
    dataGrid.datagrid('load', {});
  }

  //退款操作
  function cancel(userId,paytype,svip,channelId) {
    var uid = userId ;
      if (uid == undefined) {
          var rows = dataGrid.datagrid('getSelections');
          uid = rows[0].userId;
      }
      var tip = '${internationalConfig.您是否要取消用户}'+uid+'${internationalConfig.的自动续费服务}'
      parent.$.messager.confirm('${internationalConfig.确认}', tip , function (b) {
          if (b) {
              parent.$.messager.progress({
                  title: '${internationalConfig.提示}',
                  text: '${internationalConfig.数据处理中}'
              });
              $.post('${pageContext.request.contextPath}/auto_renewal_record/cancel_autorenewal_service.json', {
                userId: uid,
                paytype:paytype,
                svip:svip,
                channelId:channelId
              }, function (obj) {
                  var result = $.parseJSON(obj);
                  if (result.code == 0) {
           /*  parent.$.messager.alert('${internationalConfig.成功}', result.msg, 'success');
            parent.$.messager.progress('close'); */
                      searchFun();
                  }else{
                    parent.$.messager.progress('close');
                    alert('${internationalConfig.取消用户自动续费服务失败}') ;
                  }
              }, 'html');
          }
      });
  }
</script>
</head>
<body>
  <div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'">
      <form id="searchForm">
        <table class="table-td-two">
          <tr>
            <td>${internationalConfig.用户ID}：<input id="userId" name="userId"
              class="span2"></input>
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
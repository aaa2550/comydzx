<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.用户乐点余额查询}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
  var dataGrid;
  $(function() {
    dataGrid = $('#dataGrid').datagrid({
        url : '${pageContext.request.contextPath}/lepoint_recharge/data_grid.json',
        queryParams:$.serializeObject($('#searchForm')),
        fit : true,
        fitColumns : true,
        border : false,
        pagination : true,
        idField : 'id',
        pageSize : 20,
        pageList : [ 10, 20, 30, 40, 50 ],
        checkOnSelect : false,
        selectOnCheck : false,
        nowrap : false,
        striped : true,
        rownumbers : true,
        singleSelect : true,
        frozenColumns : [ [ {
          field : 'userid',
          title : '${internationalConfig.用户ID}',
          width : 100,
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
          width : 150,
          sortable : true
        },   
        {
          field : 'point',
          title : '${internationalConfig.充值乐点数}',
          width : 100,
          sortable : true
        },   
        {
          field : 'amount',
          title : '${internationalConfig.充值金额}',
          width : 100,
          sortable : true
        },   
        {
          field : 'cardNumber',
          title : '${internationalConfig.充值卡号}',
          width : 150,
          sortable : true
        }, {
          field : 'chargeNumber',
          title : '${internationalConfig.充值流水号}',
          width : 150,
          sortable : true
        },   
        {
          field : 'chargeTypeName',
          title : '${internationalConfig.充值途径}',
          width : 150,
          sortable : false
        }
        , {
          field : 'activeDate',
          title : '${internationalConfig.充值时间}',
          width : 150,
          sortable : true
        }] ],
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
    if(date ="Invalid Date"){
      return "";
    }
    return date.format("yyyy-MM-dd hh:mm:ss");
  }
  function searchFun() {
    var name = $('#userId').val();
    if(name == "") {
      alert("${internationalConfig.用户ID不能为空}");
      return ;
    }
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
</script>
</head>
<body>
  <div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'">
      <form id="searchForm">
        <table class="table-td-four">
          <tr>
            <td>${internationalConfig.用户ID}：<input id="userId" name="userId" value="${param.userId}"
              class="span2" ></input>
            </td>
            <td>${internationalConfig.充值开始时间}：<input id="beginDate" name="beginDate"
                                    class="easyui-datebox"></td>
                        <td>${internationalConfig.充值结束时间}：<input id="endDate" name="endDate"
                                    class="easyui-datebox"></td>
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
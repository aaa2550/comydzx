<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.用户账户汇总}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<style type="text/css">
        table tr td b {
            text-align: center;
            font-size: 32px;
          
        }
		table tr td:first-child b{
            
            color: red;
        }
        .header-userinfo{
          font-size:12px;
          color: #777;
          background-color:#FBFBFB;
          line-height:26px;
          padding-left:5px;
          height:26px;
          margin-left:-10px;
          border-bottom:1px solid #ccc;
          border-top:1px solid #ccc;
        }

        div[class="easyui-panel panel-body"] {
            overflow: hidden;
        }
    </style>
<script type="text/javascript">
  var dataGrid;
  $(function() {
    dataGrid = $('#dataGrid')
        .datagrid(
            {
              url : '${pageContext.request.contextPath}/na/lebi/rechargedetail/rechargedetailquerysum',
              queryParams:$.serializeObject($('#searchForm')),
              fit : true,
              fitColumns : true,
              border : false,
              pagination : true,
              idField : 'id',
              pageSize : 50,
              pageList : [ 1, 20, 30, 40, 50 ],
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
                    title : '${internationalConfig.用户} id',
                    width : 100,
                    sortable : false
                  },
                  {
                    field : 'username',
                    title : '${internationalConfig.用户名}',
                    width : 120,
                    sortable : true
                  },
                  {
                    field : 'accounttime',
                    title : '${internationalConfig.账户时间}',
                    width : 200,
                    sortable : true
                  },
                  {
                    field : 'pricesum',
                    title : '${internationalConfig.累计充值金额}',
                    width : 100,
                    sortable : false,
                    formatter: function (value, row, index) {
                        var str = '';
//                   		str += $.formatString('<a href="javascript:rechargefun('+row.userid+')">'+(row.pricesum/100).toFixed(2)+'</a>' );
                        str = (row.pricesum/100).toFixed(2);
                        return str;
                    }                    
                  },
                  {
                    field : 'lbsum',
                    title : '${internationalConfig.累计充值乐币}',
                    width : 100,
                    sortable : false,
                    formatter: function (value, row, index) {
                        var str = '';
                   		str += $.formatString('<a href="javascript:tradefun('+row.userid+',1)">'+row.lbsum+'</a>' );
                        return str;
                    }    
                  },
                  {
                    field : 'zssum',
                    title : '${internationalConfig.累计赠送乐币}',
                    width : 100,
                    sortable : false,
                    formatter: function (value, row, index) {
                        var str = '';
                   		str += $.formatString('<a href="javascript:tradefun('+row.userid+',1)">'+row.zssum+'</a>' );
                        return str;
                    }    
                  },
                  {
                    field : 'xhsum',
                    title : '${internationalConfig.累计消耗乐币}',
                    width : 100,
                    sortable : true,
                    formatter: function (value, row, index) {
                        var str = '';
                   		str += $.formatString('<a href="javascript:tradefun('+row.userid+',2)">'+row.xhsum+'</a>' );
                        return str;
                    }    
                  },
                  {
                    field : 'lbjy',
                    title : '${internationalConfig.乐币总余额}',
                    width : 100,
                    sortable : true,
                    formatter: function (value, row, index) {
                        var str = '';
                   		str += $.formatString('<a href="javascript:tradefun('+row.userid+',2)">'+row.lbjy+'</a>' );
                        return str;
                    }    
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
    $('#searchForm select').val('');
    dataGrid.datagrid('load', {});
  }

  
  function loadsum() {
	  	var options = $('#dataGrid').datagrid('getPager').data("pagination").options;
	  	var pageSize = options.pageSize;
	  	var pageNumber = options.pageNumber;
		var createtimestart = $("#createtimestart").datetimebox('getValue');
		var createtimeend =  $("#createtimeend").datetimebox('getValue');
		var userid = $("#userid").val();
		var url = "/na/lebi/rechargedetail/rechargedetailquerycount";
		$.post(url,{createtimestart:createtimestart,createtimeend:createtimeend,userid:userid,page:pageNumber,rows:pageSize},function(data) {
			
			var datas = data.split(",");
			var jieyu = datas[0];
			var sumprice = datas[1];
			var sumcz = datas[2];
			var sumzs = datas[3];
			var sumxh = datas[4];
			var sumyh = datas[5];
			$("#jieyu").html(fnumber(jieyu));
			$("#sumprice").html(fmoney(sumprice/100,2));
			$("#sumcz").html(fnumber(sumcz));
			$("#sumzs").html(fnumber(sumzs));
			$("#sumxh").html(fnumber(sumxh));
			$("#sumyh").html(fnumber(sumyh));
			$("#userinfo").html("${internationalConfig.全部用户}");
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
  function fmoney(s, n)   
  {   
     n = n > 0 && n <= 20 ? n : 2;   
     s = parseFloat((s + "").replace(/[^\d\.-]/g, "")).toFixed(n) + "";   
     var l = s.split(".")[0].split("").reverse(),   
     r = s.split(".")[1];   
     t = "";   
     for(i = 0; i < l.length; i ++ )   
     {   
        t += l[i] + ((i + 1) % 3 == 0 && (i + 1) != l.length ? "," : "");   
     }   
     return t.split("").reverse().join("") + "." + r;   
  } 
  function rechargefun(userid) {

      parent.iframeTab.init({url:'/na/lebi/rechargedetail/listdialog?userid=' + userid,text:'${internationalConfig.充值明细}'});
 }
	    
   function tradefun(userid,lbtype) {

     parent.iframeTab.init({url:'/na/lebi/tradedetail/listdialog?userid=' + userid+'&lbtype='+lbtype,text:'${internationalConfig.乐币明细}'});
   }  
</script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}&nbsp;&nbsp;&nbsp;${internationalConfig.时间段}、${internationalConfig.用户名}, ${internationalConfig.至少输入一项}！',border:false,height:'auto'">
      <form id="searchForm">
        <table class="table-more">
          <tr>
            <td>
              &nbsp;&nbsp;&nbsp;&nbsp;${internationalConfig.时间段}：
            	<input type="text" id="createtimestart" name="createtimestart" style="width: 180px" class="easyui-datetimebox"  />
            	<input type="text" id="createtimeend" name="createtimeend" style="width: 180px" class="easyui-datetimebox"  />
            </td>
            </tr>
            
            <tr>
            <td>
                ${internationalConfig.用户名}：
              <input style="width:360px;" id="userid" name="userid" placeholder="${internationalConfig.用户} ID\ ${internationalConfig.用户名}"
              class="span2"/>
            </td>
            </tr>
            </table>
                       
      </form>
    <div >
    	<h5 class="header-userinfo"  id="userinfo">${internationalConfig.用户信息}</h5>
	    <table class="table-more">
	        <tr>
	            <td>
                    ${internationalConfig.乐币总余额}：<b id="jieyu">0</b>
	            </td>
	            <td>
                    ${internationalConfig.充值乐币}：<b id="sumcz">0</b>
	            </td>
	            <td>
                    ${internationalConfig.赠送乐币}：<b id="sumzs">0</b>
	            </td>
	            <td>
                    ${internationalConfig.消耗乐币}：<b id="sumxh">0</b>
	            </td>
	            <td>
                    ${internationalConfig.用户数}：<b id="sumyh">0</b>
	            </td>
	        </tr>
	    </table>
	</div>
    
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
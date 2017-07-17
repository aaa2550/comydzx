<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.乐币明细}</title>
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
      
    </style>
<script type="text/javascript">
  var dataGrid;
  $(function() {
    dataGrid = $('#dataGrid')
        .datagrid(
            {
              url : '${pageContext.request.contextPath}/na/lebi/tradedetail/tradedetailquery',
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
                    field : 'id',
                    title : '${internationalConfig.流水号}',
                    width : 250,
                    align: 'center',
                    sortable : false
                  },                           
                  {
                    field : 'userid',
                    title : '${internationalConfig.用户} id',
                    width : 100,
                    align: 'center',
                    sortable : false
                  },
                  {
                    field : 'username',
                    title : '${internationalConfig.用户名}',
                    width : 100,
                    align: 'center',
                    sortable : true
                  },
                  {
                    field : 'terminalname',
                    title : '${internationalConfig.终端}',
                    width : 100,
                    align: 'center',
                    sortable : true
                  },
                  {
                      field : 'lbtype',
                      title : '${internationalConfig.类型}',
                      width : 100,
                      sortable : true,
                      align: 'center',
                      formatter: function (value, row, index) {
                    	  var ret = "";
                    	  if( row.lbtype=='xh' ) {
                    		  ret = "${internationalConfig.消耗}";
                    	  } else if(row.lbtype=='cz') {
                    		  ret = "${internationalConfig.硬件返还}";
                    	  } else if(row.lbtype=='td') {
                            ret = "${internationalConfig.退款扣减}";
                          }
                    	  return ret;
                      }
                    },         
                    {
                        field : 'currencynum',
                        title : '${internationalConfig.乐币数量}',
                        align: 'center',
                        width : 100,
                        sortable : true
                      },  
                      {
                          field : 'currencynumreward',
                          title : '${internationalConfig.赠送数量}',
                          width : 100,
                          align: 'center',
                          sortable : true
                        },
                  {
                      field : 'balance',
                      title : '${internationalConfig.账户余额}',
                      width : 100,
                      align: 'center',
                      formatter: function (value, row, index) {
                          var str = "";
//                          str = (row.balance/100).toFixed(2);
                          return row.balance;
                      }
                  },
                  {
                    field : 'createtime',
                    title : '${internationalConfig.交易时间}',
                    width : 200,
                    align: 'center',
                    sortable : true
                  },
                  {
                    field : 'remark',
                    title : '${internationalConfig.备注}',
                    align: 'center',
                    width : 150,
                    sortable : true
                  }
              ] ],
              toolbar : '#toolbar',
              onLoadSuccess : function() {
//            	  loadsum();
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

  function cleanFun() {
    $('#searchForm input').val('');
    $('#searchForm select').val('');
    dataGrid.datagrid('load', {});
  }

  function exportExcel() {
	
	  	var options = $('#dataGrid').datagrid('getPager').data("pagination").options;
	  	var pageSize = options.pageSize;
	  	var pageNumber = options.pageNumber;

		var createtimestart = $('#createtimestart').datetimebox('getValue');
		var createtimeend = $('#createtimeend').datetimebox('getValue');
		var terminal = $('#terminal').val();
		var id = $('#id').val();
		var userid = $('#userid').val();
		
		var url = '${pageContext.request.contextPath}/na/lebi/tradedetail/excel?createtimestart='
				+ createtimestart + '&createtimeend='+ createtimeend + "&terminal="+terminal + "&id="+id+"&userid="+userid+"&page="+pageNumber+"&rows="+pageSize;
		location.href = url;
	}

  function searchFun() {
		
	    dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
  }
  
  function loadsum() {

	  	var options = $('#dataGrid').datagrid('getPager').data("pagination").options;
	  	var pageSize = options.pageSize;
	  	var pageNumber = options.pageNumber;

		var createtimestart = $("#createtimestart").datetimebox('getValue');
		var createtimeend =  $("#createtimeend").datetimebox('getValue');
		var terminal = $("#terminal").val();
		var id = $("#id").val();
		var userid = $("#userid").val();
		var url = "/na/lebi/tradedetail/tradedetailquerycount";
		$.post(url,{createtimestart:createtimestart,createtimeend:createtimeend,terminal:terminal,id:id,userid:userid,page:pageNumber,rows:pageSize},function(data) {
			
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
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}&nbsp;&nbsp;&nbsp;${internationalConfig.时间段}、${internationalConfig.流水号}、${internationalConfig.用户名}, ${internationalConfig.至少输入一项}！',border:false,height:'auto'">
      <form id="searchForm">
        <table class="table-more">
          <tr>
            <td>
                ${internationalConfig.时间段}：
            	<input type="text" id="createtimestart" name="createtimestart" style="width: 180px" class="easyui-datetimebox" class="easyui-validatebox"  />
            	<input type="text" id="createtimeend" name="createtimeend" style="width: 180px" class="easyui-datetimebox" class="easyui-validatebox"  />
            </td>
            <td>	            	
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${internationalConfig.终端}：
	            	<select name="terminal" class="span2" id="terminal">
		            	<option value="" selected>${internationalConfig.全部}</option>
		            	<c:forEach items="${terminals }" var="terminal">
		               		<option value="${terminal.key}">${terminal.value}</option>
		                </c:forEach>
	              	</select>
            </td>
            <td>
                ${internationalConfig.交易类型}：
            		<select name="lbtype" class="span2" id="type">
		            	<option value="" selected>${internationalConfig.全部}</option>
	               		<option value="td" <c:if test="${3 eq param.lbtype}">selected</c:if>>${internationalConfig.退款扣减}</option>
	               		<option value="xh" <c:if test="${2 eq param.lbtype}">selected</c:if>>${internationalConfig.消耗}</option>
	               		<option value="cz" <c:if test="${1 eq param.lbtype}">selected</c:if>>${internationalConfig.硬件返还}</option>
	              	</select>
            </td>
            </tr>
            
            <tr>
            <td>
                ${internationalConfig.流水号}：
              <input style="width:360px;" id="id" name="id" 
              class="span2"></input>
            </td>
            <td>
                ${internationalConfig.用户名}：
              <input id="userid" style="width:138px;" name="userid" placeholder="${internationalConfig.用户} ID \ ${internationalConfig.用户名}" value="${param.userid }"
              class="span2"></input>
            </td>
            </tr>
            </table>
            
      </form>
    <%--<div >--%>
    	<%--<h5 class="header-userinfo"  id="userinfo">用户信息</h5>--%>
	    <%--<table class="table-more">--%>
	        <%--<tr>--%>
	            <%--<td>--%>
	               <%--结余：<b id="jieyu">0</b>--%>
	            <%--</td>--%>
	            <%--<td>--%>
	               <%--累计充值总数：<b id="sumcz">0</b>--%>
	            <%--</td>--%>
	            <%--<td>--%>
	               <%--累计充赠总数：<b id="sumzs">0</b>--%>
	            <%--</td>--%>
	            <%--<td>--%>
	               <%--累计消耗总数：<b id="sumxh">0</b>--%>
	            <%--</td>--%>
	        <%--</tr>--%>
	    <%--</table>--%>
	<%--</div>--%>
 
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
      
            <a href="javascript:void(0);" class="easyui-linkbutton"
      data-options="plain:true,iconCls:'bug_add'"
      onclick="exportExcel();">${internationalConfig.导出}</a>
  </div>
</body>
</html>
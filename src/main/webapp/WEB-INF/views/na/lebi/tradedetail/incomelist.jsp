<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.收入明细}</title>
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
        	border-bottom:1px solid #ccc;
        }

        div[class="easyui-panel panel-body"] {
            overflow: hidden;
        }
        .table-more{
        
        }
    </style>
<script type="text/javascript">
  var dataGrid;
  $(function() {
    dataGrid = $('#dataGrid')
        .datagrid(
            {
              url : '${pageContext.request.contextPath}/lebi/tradedetail/incomequery',
              queryParams:$.serializeObject($('#searchForm')),
              fit : false,
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
              columns : [ [
              	  {
                    field : 'id',
                    title : '${internationalConfig.流水号}',
                    width : 300,
                    sortable : false
                  },   
                  {
                      field : 'bizid',
                      title : '${internationalConfig.业务线} ID',
                      width : 50,
                      sortable : false
                    },
                    {
                      field : 'companyname',
                      title : '${internationalConfig.业务线名称}',
                      width : 120,
                      sortable : true
                    },                  
                  {
                    field : 'userid',
                    title : '${internationalConfig.商户} ID',
                    width : 100,
                    sortable : false
                  },
                  {
                    field : 'username',
                    title : '${internationalConfig.商户名称}',
                    width : 100,
                    sortable : true
                  },
                  {
                    field : 'terminalname',
                    title : '${internationalConfig.终端}',
                    width : 70,
                    sortable : true
                  },
                  {
                      field : 'skuid',
                      title : '${internationalConfig.商品} ID',
                      width : 50,
                      sortable : true
                    },                  
                    {
                        field : 'skuname',
                        title : '${internationalConfig.商品名称}',
                        width : 120,
                        sortable : true
                      },         
                    {
                        field : 'currencynum',
                        title : '${internationalConfig.乐币数量}',
                        width : 80,
                        sortable : true
                      },                    
                  {
                    field : 'createtime',
                    title : '${internationalConfig.交易时间}',
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
	  loadsum();  
    dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
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
		var bizid = $('#bizid').val();
		var userid = $('#userid').val();
		var url = '${pageContext.request.contextPath}/na/lebi/tradedetail/incomeexcel?userid='+userid+'&bizid='+bizid+'&createtimestart='
				+ createtimestart + '&createtimeend='+ createtimeend + "&id="+id+"&page="+pageNumber+"&rows="+pageSize;
      location.href = url;
	}

  function loadsum() {
	  	var options = $('#dataGrid').datagrid('getPager').data("pagination").options;
	  	var pageSize = options.pageSize;
	  	var pageNumber = options.pageNumber;
  
		var createtimestart = $("#createtimestart").datetimebox('getValue');
		var createtimeend =  $("#createtimeend").datetimebox('getValue');
		var id = $("#id").val();
		var userid = $("#userid").val();
		var bizid = $("#bizid").val();
		var url = "/na/lebi/tradedetail/incomequerycount";
		$.post(url,{createtimestart:createtimestart,createtimeend:createtimeend,id:id,bizid:bizid,userid:userid,page:pageNumber,rows:pageSize},function(data) {
			
			var datas = data.split(",");
			var sumlb = datas[0];
			var userinfo = datas[1];
			$("#sumlb").html(fnumber(sumlb));
//			$("#userinfo").html(userinfo);
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
  <div class="easyui-panel" title="${internationalConfig.查询条件}&nbsp;&nbsp;&nbsp;${internationalConfig.时间段}、${internationalConfig.流水号}、${internationalConfig.用户名}、${internationalConfig.业务线}, ${internationalConfig.至少输入一项}！">
   <form id="searchForm">
        <table class="table-more" style="width:90%">
          <tr>
            <td>
                ${internationalConfig.时间段}：
            	<input type="text" id="createtimestart" name="createtimestart" style="width: 180px" class="easyui-datetimebox" class="easyui-validatebox"  />
            	<input type="text" id="createtimeend" name="createtimeend" style="width: 180px" class="easyui-datetimebox" class="easyui-validatebox"  />
            </td>
             <td>
                ${internationalConfig.商户名称}：
              <input style="width:138px;" id="userid" name="userid" placeholder="${internationalConfig.商户} ID\ ${internationalConfig.商户名称}"
              class="span2"/>
            </td>
            <tr>
            <td>
                ${internationalConfig.流水号}：
              <input style="width:360px;" id="id" name="id" 
              class="span2"/>
            </td>
            <td>
              &nbsp;&nbsp;&nbsp;&nbsp;${internationalConfig.业务线}：
                <select name="bizid" class="span2" id="bizid" >
	            		<option value="" selected>${internationalConfig.全部}</option>
			            <c:forEach items="${businesslist }" var="business">
			                <%--<option value="${business.bussid}" <c:if test="${business.bussid eq param.bizid}">selected</c:if>>${business.bussname}</option>--%>
                            <c:if test="${business.bussid=='301'}">
                                <option value="${business.bussid}">${business.bussEnName}</option>
                            </c:if>
			            </c:forEach>
	              </select>
            </td>
            </tr>
            </table>
            
      </form>
    </div>
    <div >
    	<%--<h5 class="header-userinfo"  id="userinfo">${internationalConfig.用户信息}</h5>--%>
	    <table class="table-more" style="width:90%">
	        <tr>
	            <td>
                    ${internationalConfig.累计乐币总数}：<b id="sumlb">0</b>
	            </td>
	            
	        </tr>
	    </table>
	</div>
   <!--  <table style="background-color: #EEEED1;width: 100%">
	            <tr>
	            	<td ><span style="font-size: 20px" id="userinfo">--</span></td>
	            </tr>            
	            <tr style="font-size: 30px;font-weight: bold;" height="50">
	            	<td><span style="color: red" id="sumlb">0</span></td>
	            </tr>
	            <tr>
	            	<td ><span style="font-size: 15px" >累计乐币总数</span></td>
	            </tr>            
            </table> -->
    <div data-options="height:400px;">
      <table id="dataGrid"></table>
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
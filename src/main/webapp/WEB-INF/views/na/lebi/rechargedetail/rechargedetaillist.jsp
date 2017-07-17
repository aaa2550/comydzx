<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.充值明细}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>

<script type="text/javascript">
  var dataGrid;
  $(function() {
    dataGrid = $('#dataGrid')
        .datagrid(
            {
              url : '${pageContext.request.contextPath}/na/lebi/rechargedetail/rechargedetailquery',
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
              sortName: 'paytime',
              sortOrder: 'desc',
              nowrap : false,
              striped : true,
              rownumbers : true,
              singleSelect : true,
              columns : [ [
                           {
                               field : 'id',
                               title : '${internationalConfig.流水号}',
                               width : 200,
                               sortable : false,
                               align: 'center'
                             },                           
                  {
                    field : 'userid',
                    title : '${internationalConfig.用户} ID',
                    width : 100,
                    align: 'center',
                    sortable : false
                  },
                  {
                    field : 'username',
                    title : '${internationalConfig.用户名}',
                    width : 150,
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
                    field : 'payname',
                    title : '${internationalConfig.支付方式}',
                    width : 100,
                    align: 'center',
                    sortable : false
                  },
                  {
                    field : 'payseq',
                    title : '${internationalConfig.支付流水号}',
                    width : 180,
                    align: 'center',
                    sortable : false
                  },
                  {
                    field : 'payamount',
                    title : '${internationalConfig.充值金额}',
                    width : 100,
                    sortable : false,   
                    align: 'center',
                    formatter: function (value, row, index) {
                    	var str = "";
                    	str = (row.payamount/100).toFixed(2);
						return str;
                    }                    
                  },
                  
                  {
                    field : 'createtime',
                    title : '${internationalConfig.支付时间}',
                    width : 200,
                    align: 'center',
                    sortable : true
                  },
                  {
                    field : 'remark',
                    title : '${internationalConfig.备注}',
                    width : 150,
                    align: 'center',
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

  function exportExcel() {

	  	var options = $('#dataGrid').datagrid('getPager').data("pagination").options;
	  	var pageSize = options.pageSize;
	  	var pageNumber = options.pageNumber;

		var createtimestart = $('#createtimestart').datetimebox('getValue');
		var createtimeend = $('#createtimeend').datetimebox('getValue');
		var terminal = $('#terminal').val();
		var id = $('#id').val();
		var userid = $('#userid').val();
		
		var url = '${pageContext.request.contextPath}/na/lebi/rechargedetail/excel?createtimestart='
				+ createtimestart + '&createtimeend='+ createtimeend + "&terminal="+terminal + "&id="+id+"&userid="+userid+"&page="+pageNumber+"&rows="+pageSize;
		location.href = url;
	}

</script>
</head>
<body>
  <div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件} &nbsp;&nbsp;&nbsp;${internationalConfig.时间段}、${internationalConfig.流水号}、${internationalConfig.用户名}, ${internationalConfig.至少输入一项}！',border:false,height:'auto'">
      <form id="searchForm">
        <table class="table-more">
          <tr>
            <td>
                ${internationalConfig.时间段}：
            	<input type="text" id="createtimestart" name="createtimestart" style="width: 180px" class="easyui-datetimebox" class="easyui-validatebox" />
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
            	支付方式：
            		<select name="paytype" class="span2">
		            	<option value="" selected>${internationalConfig.全部}</option>
		            	<c:forEach items="${channellist }" var="channel">
		               		<option value="${channel.id}">${channel.name}</option>
		                </c:forEach>
	              	</select>
            </td>
            </tr>
            
            <tr>
            <td>
                ${internationalConfig.流水号}：
              <input id="id" name="id" style="width:360px;" class="span2"></input>
            </td>
            <td>
                ${internationalConfig.用户名}：
              <input id="userid" style="width:138px;" name="userid" placeholder="${internationalConfig.用户} ID\ ${internationalConfig.用户名}" value="${param.userid }"
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
      
            <a href="javascript:void(0);" class="easyui-linkbutton"
      data-options="plain:true,iconCls:'bug_add'"
      onclick="exportExcel();">${internationalConfig.导出}</a>
  </div>
</body>
</html>
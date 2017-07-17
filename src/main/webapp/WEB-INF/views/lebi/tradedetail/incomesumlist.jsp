<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.收入汇总}</title>
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
    loadsum();
    dataGrid = $('#dataGrid')
        .datagrid(
            {
              url : '${pageContext.request.contextPath}/lebi/tradedetail/incomesumquery',
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
                title : '${internationalConfig.流水号}',
                width : 150,
                hidden : true
              } ] ],
              columns : [ [

                    {
                      field : 'companyname',
                      title : '${internationalConfig.商户名称}',
                      width : 30,
                      align: 'center',
                      sortable : true
                    },
                  {
                    field : 'bizname',
                    title : '${internationalConfig.业务线}',
                    width : 30,
                    align: 'center',
                    sortable : false
                  },
                  {
                    field : 'accounttime',
                    title : '${internationalConfig.账户时间}',
                    width : 50,
                    align: 'center',
                    sortable : true
                  },
                  {
                      field : 'lbsum',
                      title : '${internationalConfig.乐币总余额}',
                      align: 'center',
                      width : 50,
                      sortable : true,
                      formatter: function (value, row, index) {
                          var str = '';
                        str += $.formatString("<a href='javascript:tradefun(\""+row.bizid+"\")'>"+row.lbsum+"</a>");
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
    loadsum();
    dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
  }
  function cleanFun() {
    $('#searchForm input').val('');
    $('#searchForm select').val('');
    dataGrid.datagrid('load', {});
  }

  function loadsum() {

 
    var createtimestart = $("#createtimestart").datetimebox('getValue');
    var createtimeend =  $("#createtimeend").datetimebox('getValue');
    var id = $("#id").val();
    var companyid = $("#companyid").val();
    var bizid = $("#bizid").val();
    var url = "/lebi/tradedetail/incomesumquerycount";
    $.post(url,{createtimestart:createtimestart,createtimeend:createtimeend,id:id,companyid:companyid,bizid:bizid},function(data) {
      
      var datas = data.split(",");
      var sumlb = datas[0];
      var sumcompany = datas[1];
      var userinfo = datas[2];
      $("#sumlb").html(fnumber(sumlb));
      $("#sumcompany").html(fnumber(sumcompany));
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

  function tradefun(bizid) {

      parent.iframeTab.init({url:'/lebi/tradedetail/incomedialog?bizid=' + bizid,text:'${internationalConfig.收入明细}'});
  }  
</script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'">
      <form id="searchForm">
        <table class="table-more">
          <tr>
            <td>
                ${internationalConfig.时间段}：
              <input type="text" id="createtimestart" name="createtimestart" style="width: 160px" class="easyui-datetimebox" class="easyui-validatebox"  />
              <input type="text" id="createtimeend" name="createtimeend" style="width: 160px" class="easyui-datetimebox" class="easyui-validatebox"  />
            </td>
            <td>
                ${internationalConfig.业务线}：
        				<select id="bizid" name="bizid" style="width: 165px" >
        					<option value="">${internationalConfig.全部}</option>
        					<c:forEach items="${businesslist}" var="business">
                      <option value="${business.bussid}">${business.bussname}</option>
                  </c:forEach>
        				</select>                  
            </td>
          </tr>
            
        </table> 
   
      </form>
      <div >
        <h5 class="header-userinfo"  id="userinfo">${internationalConfig.用户信息}</h5>
        <table class="table-more">
            <tr>
                <td>
                    ${internationalConfig.乐币总余额}：<b id="sumlb">0</b>
                </td>
                <td>
                    ${internationalConfig.商户数}：<b id="sumcompany">0</b>
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
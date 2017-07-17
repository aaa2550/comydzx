<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.sso用户信息}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
  var dataGrid;
  $(function() {
    dataGrid = $('#dataGrid').datagrid({
      url : '/sso_user/batch_show.json',
      queryParams:{
        'searchKey':'uid'
      },
      fit : true,
      fitColumns : true,
      border : false,
      pagination : false,
      idField : 'id',
      checkOnSelect : false,
      selectOnCheck : false,
      nowrap : false,
      striped : true,
      rownumbers : true,
      singleSelect : true,
      frozenColumns : [ [

      ] ],
      columns : [ [ {
        field : 'uid',
        title : '${internationalConfig.用户ID}',
        width : 100
      }, {
        field : 'nickname',
        title : '${internationalConfig.昵称}',
        width : 100
      }, {
        field : 'email',
        title : '${internationalConfig.邮箱}',
        width : 100
      }, {
        field : 'mobile',
        title : '${internationalConfig.电话号码}',
        width : 100
      }, {
        field : 'registTime',
        title : '${internationalConfig.注册时间}',
        width : 100
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
  function searchFun() {
    dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
  }
  function cleanFun() {
    $('#searchForm textarea').val('');
    dataGrid.datagrid('load', {});
  }

  function contains(string, substr, isIgnoreCase) {
    if (isIgnoreCase) {
      string = string.toLowerCase();
      substr = substr.toLowerCase();
    }
    var startChar = substr.substring(0, 1);
    var strLen = substr.length;
    for (var j = 0; j < string.length - strLen + 1; j++) {
      if (string.charAt(j) == startChar)//如果匹配起始字符,开始查找
      {
        if (string.substring(j, j + strLen) == substr)//如果从j开始的字符与str匹配，那ok
        {
          return true;
        }
      }
    }
    return false;
  }
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
    if (val == null) {
      return "";
    }
    var date = new Date(val);
    return date.format("yyyy-MM-dd hh:mm:ss");
  }
  function exportExcel() {
        var isValid = $("#searchForm").form('validate');
        if (!isValid) {
            return;
        }
        $("#searchForm").submit();
  }
</script>
</head>
<body>
  <div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'">
      <form id="searchForm" action="/sso_user/batch_export.do" method="post">
        <table class="table table-hover table-condensed"
          style="width: 800px">
          <tr>
            <td>
              <input name="searchKey" value="uid" type="radio" checked="checked" /> ${internationalConfig.用户ID}
              &nbsp;
              <input name="searchKey" value="nickname" type="radio"/> ${internationalConfig.昵称} 
              &nbsp;
              <input name="searchKey" value="email" type="radio"/> ${internationalConfig.邮箱}
                &nbsp;
              <input name="searchKey" value="mobile"  type="radio"/> ${internationalConfig.电话号码} 
            </td>
            <td>
              <textarea rows="" cols="" id="listValue" name="listValue"></textarea>${internationalConfig.每条信息一行}
            </td>
          </tr>
          
        </table>
      </form>
    </div>
    <div data-options="region:'center',border:false">
      <table id="dataGrid"></table>
    </div>
    <br />

  </div>
  <div id="toolbar" style="display: none;">
    <a href="javascript:void(0);" class="easyui-linkbutton"
      data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
      data-options="iconCls:'brick_delete',plain:true"
      onclick="cleanFun();">${internationalConfig.清空条件}</a>
     <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="exportExcel();">${internationalConfig.导出excel}</a>
      
  </div>
</body>
</html>
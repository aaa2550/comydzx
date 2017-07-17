<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>黑名单</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>

<script type="text/javascript">
  var dataGrid;
  $(function() {
    dataGrid = $('#dataGrid')
        .datagrid(
            {
              url : '${pageContext.request.contextPath}/lebi/blacklist/black_query',
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
                field : 'userid',
                title : '用户id',
                width : 150,
                hidden : true
              } ] ],
              columns : [ [
                 {
                     field : 'userid',
                     title : '用户',
                     width : 200,
                     sortable : false
                   },                           
                  {
                    field : 'userphone',
                    title : '用户手机号',
                    width : 200,
                    sortable : false
                  },
                  {
                    field : 'terminaladdr',
                    title : '终端地址',
                    width : 120,
                    sortable : true
                  },
                  {
                    field : 'limitterm',
                    title : '限制期限',
                    width : 120,
                    sortable : true,
                    formatter: function (value, row, index) {
                   		if( row.limitterm==7 ) {
                   			str = "7天";
                   		} else if( row.limitterm==30 ) {
                   			str = "1个月";
                   		} else if (row.limitterm==90) {
                   			str = "3个月"
                   		} else if (row.limitterm==360) {
                   			str = "12个月";
                   		} else if ( row.limitterm==3600 ) {
                   			str = "永久";
                   		}
                        return str;
                    }
                  },
                  {
                    field : 'limitenddate',
                    title : '限制到期时间',
                    width : 150,
                    sortable : false,
                    formatter: function (value, row, index) {
                        var str = row.limitenddate.replace(' 00:00:00','');
                        return str;
                    }
                  },
                  {
                    field : 'limitreason',
                    title : '限制原因',
                    width : 180,
                    sortable : false
                  },
                  {
                    field : 'status',
                    title : '状态',
                    width : 200,
                    sortable : false,
                    formatter: function (value, row, index) {
                    	
                    	if( row.status==1 ) {
                    		str = "限制中";
                    	} else if( row.status==2 ) {
                    		str = "已失效";
                    	} else {
                    		str = "未知";
                    	}
                        return str;
                    }                    
                  },
                  
                  {
                    field : 'operuser',
                    title : '添加人',
                    width : 100,
                    sortable : true
                  },
                  {
                    field : 'opertime',
                    title : '添加时间',
                    width : 150,
                    sortable : true,
                    formatter: function (value, row, index) {
                        var str = row.opertime.replace(' 00:00:00','');
                        return str;
                    }
                  },{
	                    field: 'action',
	                    title: '操作',
	                    width: 100,
	                    formatter: function (value, row, index) {
	                        var str = '&nbsp;&nbsp;';
                       		str += $.formatString('<a onclick="deleteFun('+row.userid+');" href="#">删除</a>' );
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
    $('#searchForm select').val('');
    dataGrid.datagrid('load', {});
  }

  function addFun(type) {
	    parent.$.modalDialog({
	        title: '添加黑名单',
	        width: 500,
	        height: 450,
	        href: '${pageContext.request.contextPath}/lebi/blacklist/black_addpage',
	        buttons: [
	            {
	                text: '添加',
	                handler: function () {
	                    parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
	                    var f = parent.$.modalDialog.handler.find('#form');
	                    f.submit();
	                    //dataGrid.datagrid('reload');
	                }
	            }, {
	                text : "取消",
	                handler : function() {
	                  parent.$.modalDialog.handler.dialog('close');
	                }
	              }
	        ]
	    });
	}
  
	function deleteFun(userid) {
		
		parent.$.messager.confirm('询问', '确认删除？', function(b) {
			if (b) {
				parent.$.messager.progress({
					title : '${internationalConfig.提示}',
					text : '${internationalConfig.数据处理中}....'
				});
				$.post('${pageContext.request.contextPath}/lebi/blacklist/delete', {
					id : userid
				}, function(result) {
					if (result.code == 0) {
						parent.$.messager.alert('${internationalConfig.提示}', '删除成功！', 'info');
						dataGrid.datagrid('reload');
					} else {
						parent.$.messager.alert('${internationalConfig.提示}', '删除失败！', 'info');
					}
					parent.$.messager.progress('close');
				}, 'JSON');
			}
		});
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
            	   用户名称：
            	 <input id="userid" name="userid" placeholder="用户ID\用户名称" class="span2"/>
            </td>
            <td>
         		   用户手机号：
            	<input id="userphone" name="userphone" class="span2"></input>
            </td>
            </tr>
          
            
            <tr>
	            <td>
	           		 终端地址：
	            	<input id="terminaladdr" name="terminaladdr" class="span2"></input>
	            </td>
            <td>
             	&nbsp;&nbsp;&nbsp;&nbsp;限制期限：
             	<select name="limitterm" class="span2">
	            	<option value="" selected>全部</option>
	                <option value="7">7天</option>
	                <option value="30">1个月</option>
	                <option value="90">3个月</option>
	                <option value="360">12个月</option>
	                <option value="3600">永久</option>
	            </select>
            </td>
            <td>
            	状态：
            	<select name="status" class="span2">
	            	<option value="" selected>全部</option>
	                <option value="1">限制中</option>
	                <option value="2">已失效</option>
              </select>
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
      
            <a href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'pencil_add'"
      onclick="addFun();">添加</a>
  </div>
</body>
</html>
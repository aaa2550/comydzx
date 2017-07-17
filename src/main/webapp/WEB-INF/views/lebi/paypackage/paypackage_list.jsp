<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>乐币包列表</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>

<script type="text/javascript">
  var dataGrid;
  $(function() {
    dataGrid = $('#dataGrid')
        .datagrid(
            {
              url : '${pageContext.request.contextPath}/lebi/paypackage/paypackage_query',
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
                      field : 'packageId',
                      title : '乐币包ID',
                      width : 100,
                      align: 'center',
                      sortable : false
                    },                           
                  {
                    field : 'packageName',
                    title : '乐币包名称',
                    width : 100,
                    align: 'center',
                    sortable : false
                  },
                  {
                    field : 'busiName',
                    title : '业务线',
                    align: 'center',
                    width : 100
                  },
                  {
                    field : 'packageTerminalname',
                    title : '终端',
                    width : 100,
                    align: 'center',
                    sortable : true
                  },
                  {
                    field : 'packagedate',
                    title : '有效期',
                    width : 200,
                    align: 'center',
                    sortable : false,
                    formatter: function (value, row, index) {
                        var str = row.packageStartdate.replace(' 00:00:00','')+"至"+row.packageEnddate.replace(' 00:00:00','');
                        return str;
                    }                    
                  },
                  {
                    field : 'packageStatusname',
                    title : '状态',
                    width : 100,
                    align: 'center',
                    sortable : false
                  },
                  {
                    field : 'operTime',
                    title : '添加时间',
                    width : 200,
                    sortable : false,
                    align: 'center'
                  },
                  {
                      field : 'hdDoc',
                      title : '活动文案',
                      width : 200,
                      sortable : false,
                      align: 'center'
                    },                  
                  {
	                    field: 'action',
	                    title: '操作',
	                    width: 200,
	                    align: 'center',
	                    formatter: function (value, row, index) {
	                        var str = '&nbsp;&nbsp;';
                       		str += $.formatString('<a onclick="editFun('+row.packageId+');" href="#">修改</a>&nbsp;&nbsp;|&nbsp;&nbsp;' );
                       		if( row.packageStatus=='1' ) {
                       			str += $.formatString('<a onclick="belowline('+row.packageId+');" href="#">下线</a>&nbsp;&nbsp;' );
                       		} else {
                       			str += $.formatString('<a onclick="online('+row.packageId+');" href="#">上线</a>&nbsp;&nbsp;' );
                       		}
                       		if(row.packageStatusname=='已失效') {
                       			str += $.formatString('|&nbsp;&nbsp<a onclick="deleteFun('+row.packageId+');" href="#">删除</a>' );
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
  
	  function editFun(id) {
	    parent.$.modalDialog({
	      title:'添加/修改乐币包',
	      width:900,
	      height:450,
	      href : '${pageContext.request.contextPath}/lebi/paypackage/editPaypackagepage?id='+id,
	      buttons : [ {
	        text : '保存',
	        handler : function() {
	          parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
	          var f = parent.$.modalDialog.handler.find('#form');
	          f.submit();
	          dataGrid.datagrid('reload');
	        }
	      }, {
	        text : "取消",
	        handler : function() {
	          parent.$.modalDialog.handler.dialog('close');
	        }
	      } ]
	    });
	  }
  
  function addFun(type) {
	    parent.$.modalDialog({
	        title: '添加\修改乐币包',
	        width: 900,
	        height: 450,
	        href: '${pageContext.request.contextPath}/lebi/paypackage/addPaypackagepage',
	        buttons: [
	            {
	                text: '添加',
	                handler: function () {
	                    parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
	                    var f = parent.$.modalDialog.handler.find('#form');
	                    f.submit();
	                    dataGrid.datagrid('reload');
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
 
  
	function deleteFun(packageid) {
		
		parent.$.messager.confirm('询问', '确认删除？', function(b) {
			if (b) {
				parent.$.messager.progress({
					title : '${internationalConfig.提示}',
					text : '${internationalConfig.数据处理中}....'
				});
				$.post('${pageContext.request.contextPath}/lebi/paypackage/delete', {
					packageId : packageid
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
	
  function online(packageid) {

		parent.$.messager.confirm('询问', '确认上线？', function(b) {
			if (b) {
				parent.$.messager.progress({
					title : '${internationalConfig.提示}',
					text : '${internationalConfig.数据处理中}....'
				});
				$.post('${pageContext.request.contextPath}/lebi/paypackage/line', {
					id : packageid,onOrBelow:1
				}, function(result) {
					if (result.code == 0) {
						parent.$.messager.alert('${internationalConfig.提示}', '上线成功', 'info');
						dataGrid.datagrid('reload');
					} else {
						parent.$.messager.alert('${internationalConfig.提示}', '上线失败！确保在有效期内且同一业务线同一终端下只有一条生效记录！', 'info');
					}
					parent.$.messager.progress('close');
				}, 'JSON');
			}
		});		
  }
  
  function belowline(packageid) {

		parent.$.messager.confirm('询问', '确认下线？', function(b) {
			if (b) {
				parent.$.messager.progress({
					title : '${internationalConfig.提示}',
					text : '${internationalConfig.数据处理中}....'
				});
				$.post('${pageContext.request.contextPath}/lebi/paypackage/line', {
					id : packageid,onOrBelow:2
				}, function(result) {
					if (result.code == 0) {
						parent.$.messager.alert('${internationalConfig.提示}', '下线成功！', 'info');
						dataGrid.datagrid('reload');
					} else {
						parent.$.messager.alert('${internationalConfig.提示}', '下线失败！', 'info');
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
                乐币包名称：
                <input id="packageName" name="packageName" style="text-indent:5px; width:190px;font-size:12px;height:24px;line-height:24px;" placeholder="乐币包ID\乐币包名称"
	              class="span2"/>
	            </td>
	            <td>
                业务线：
	            	<select name="busiId" class="span2">
	            			<option value="" selected>全部</option>
			            <c:forEach items="${businesslist }" var="business">
			                <option value="${business.bussid}">${business.bussname}</option>
			            </c:forEach>
	              	</select>
	            </td>
            </tr>
            
            <tr>
	            <td>
	            	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;状态：
	            	<select name="packageStatus" class="span2">
		            	<option value="" selected>全部</option>
		            	<option value="1-1">生效中</option>
		            	<option value="1-2">未生效</option>
		                <option value="2">已失效</option>
	              	</select>
	            </td>
	            <td>
	            	&nbsp;&nbsp;&nbsp;&nbsp;终端：
	            	<select name="packageTerminal" class="span2">
		            	<option value="" selected>全部</option>
		            	<c:forEach items="${terminals }" var="terminal">
		               		<option value="${terminal.key}">${terminal.value}</option>
		                </c:forEach>
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
      
      <a href="javascript:void(0);" class="easyui-linkbutton"
      data-options="plain:true,iconCls:'pencil_add'"
      onclick="addFun();">添加</a>
  </div>
</body>
</html>
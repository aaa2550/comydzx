<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.活动成功页配置管理}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>

<script type="text/javascript">
<m:auth uri="/pay_package_pre/pay_package_pre_edit.json">
  $.canEdit = true;
</m:auth>
<m:auth uri="/pay_package_pre/pay_package_pre_delete.json">
  $.canDelete = true;
</m:auth>
</script>

<script type="text/javascript">
  var dataGrid;
  $(function() {
    dataGrid = $('#dataGrid').datagrid({
      url : '${pageContext.request.contextPath}/pay_package_pre/data_grid.json',
      fit : true,
      fitColumns : true,
      border : false,
      pagination : true,
      idField : 'id',
      pageSize : 20,
      pageList : [ 10, 20, 30, 40, 50 ],
      sortName : 'id',
      sortOrder : 'desc',
      checkOnSelect : false,
      selectOnCheck : false,
      singleSelect: true,
      nowrap: false,
          striped: true,
          rownumbers: true,
          singleSelect: true,
      frozenColumns: [
            [
                {
                    field: 'id',
                    title: '${internationalConfig.编号}',
                    width: 50,
                    hidden: true
                }
            ]
        ],
      columns : [ [ 
      {
        field : 'terminalDesc',
        title : '${internationalConfig.终端描述}',
        width : 80,
      },
      {
        field : 'packageDesc',
        title : '${internationalConfig.套餐描述}',
        width : 100,
      }, {
        field : 'subscript',
        title : '${internationalConfig.是否支持}',
        width : 40,
        formatter : function(value) {
          var str = '';
          if("0" == value) {
            str = "${internationalConfig.否}";
          }else if("1" == value) {
            str = "${internationalConfig.是}";
          }
          
          return str;
        }
      },
      {
        field : 'subscriptText',
        title : '${internationalConfig.角标文案}',
        width : 100,
      },
      {
        field : 'sortValue',
        title : '${internationalConfig.排序}',
        width : 100,
      }, {
        field : 'status',
        title : '${internationalConfig.状态}',
        width : 150,
        formatter : function(value) {
          var str = '';
          if("0" == value) {
            str = "${internationalConfig.下线}";
          }else if("1" == value) {
            str = "${internationalConfig.上线}";
          }
          
          return str;
        }
      },
      {
        field : 'createTime',
        title : '${internationalConfig.创建时间}',
        width : 100,
        sortable : true
      },
      {
        field : 'updateTime',
        title : '${internationalConfig.更新时间}',
        width : 100,
        sortable : true
      },  {
        field : 'action',
        title : '${internationalConfig.操作}',
        width : 60,
        formatter : function(value, row, index) {
          var str = '';
          if ($.canEdit) {
            str += $.formatString('<img onclick="editFun(\'{0}\');" src="{1}" title="${internationalConfig.编辑}"/>', row.id, '${pageContext.request.contextPath}/static/style/images/extjs_icons/bug/bug_edit.png');
          }
          
          if($.canDelete) {
            str += '&nbsp;&nbsp;&nbsp;&nbsp;';
            str += $.formatString('<img onclick="deleteFun(\'{0}\');" src="{1}" title="${internationalConfig.删除}"/>', row.id, '${pageContext.request.contextPath}/static/style/images/extjs_icons/bug/bug_delete.png');
          }
          
          return str;
        }
      } ] ],
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

  //编辑信息
  function editFun(id) {
    if (id == undefined) {
      var rows = dataGrid.datagrid('getSelections');
      id = rows[0].id;
    }
    parent.$.modalDialog({
   	  title : '${internationalConfig.添加活动成功页配置}',
      width : 600,
      height : 300,
      resizable : true,
      href : '${pageContext.request.contextPath}/pay_package_pre/pay_package_pre_edit.json?payPackagePreId=' + id,
      buttons : [ {
        text : '${internationalConfig.保存}',
        handler : function() {
          parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
          var f = parent.$.modalDialog.handler.find('#form');
          f.submit();
        }
      } , {
			text : "${internationalConfig.取消}",
			handler : function() {
				parent.$.modalDialog.handler.dialog('close');
			}
		}]
    });
  }
  
  function addFun() {
    parent.$.modalDialog({
      title : '${internationalConfig.添加活动成功页配置}',
      width : 600,
      height : 300,
      href : '${pageContext.request.contextPath}/pay_package_pre/pay_package_pre_add.json',
      buttons : [ {
        text : '${internationalConfig.增加}',
        handler : function() {
          parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
          var f = parent.$.modalDialog.handler.find('#form');
          f.submit();
        }
      } , {
			text : "${internationalConfig.取消}",
			handler : function() {
				parent.$.modalDialog.handler.dialog('close');
			}
		}]
    });
  }

  function deleteFun(id) {
    if (id == undefined) {
      var rows = dataGrid.datagrid('getSelections');
      id = rows[0].id;
    }
    parent.$.messager.confirm('${internationalConfig.确认}', '${internationalConfig.您确定要删除当前配置吗}',
    function(b) {
      if (b) {
        parent.$.messager.progress({
          title : '${internationalConfig.提示}',
          text : '${internationalConfig.数据处理中}......'
        });
        $.post(
          '${pageContext.request.contextPath}/pay_package_pre/delete.json',
          {
            payPackagePreId : id
          },
          function(result) {
            if (result.code == 0) {
              parent.$.messager
                  .alert(
                      '${internationalConfig.提示}',
                      '${internationalConfig.删除成功}',
                      'info');
              dataGrid
                  .datagrid('reload');
            } else {
              parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.请确认该配置处于线下状态}', 'error');
            }
            parent.$.messager
                .progress('close');
          }, 'JSON');
      }
    });
  }
  
  function searchFun() {
    dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
  }
  function cleanFun() {
    $('#searchForm input').val('');
    dataGrid.datagrid('load', {});
  }
</script>
</head>
<body>
  <div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'" >
      <form id="searchForm">
        <table class="table-td-more">
          <tr>
            <td>${internationalConfig.终端}：
              <select name="terminal" class="span2">
                  <option value="-1" selected>${internationalConfig.全部}</option>
                <c:forEach items="${terminals}" var="terminal">
                  <option value="${terminal.terminalId}">${terminal.terminalName}</option>
                </c:forEach>
              </select>
            </td>
            <td>${internationalConfig.会员套餐}
              <select name="packageId" class="span2">
                  <option value="-1" selected>${internationalConfig.全部}</option>
                <c:forEach items="${vipList}" var="vip">
                  <option value="${vip.id}">${vip.packageNameDesc}_${vip.durationDesc}</option>
                </c:forEach>
              </select>
            </td>
            <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${internationalConfig.状态}：
              <select name="status" class="span2">
                  <option value="-1" selected>${internationalConfig.全部}</option>
                <option value="0">${internationalConfig.下线}</option>
                <option value="1">${internationalConfig.上线}</option>
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
    <m:auth uri="/pay_package_pre/pay_package_pre_add.json">
      <a onclick="addFun();" href="javascript:void(0);"
        class="easyui-linkbutton"
        data-options="plain:true,iconCls:'pencil_add'">${internationalConfig.增加}</a>
    </m:auth>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">${internationalConfig.清空条件}</a>
  </div>

  <div id="menu" class="easyui-menu" style="width: 120px; display: none;">
    <div onclick="editFun();" data-options="iconCls:'pencil'">${internationalConfig.编辑}</div>
  </div>
</body>
</html>
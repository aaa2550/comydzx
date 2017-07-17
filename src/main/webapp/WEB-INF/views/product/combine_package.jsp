<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.编辑}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
<m:auth uri="/combine_package/combine_package_edit.json">
  $.canEdit = true;
</m:auth>
<m:auth uri="/combine_package/combine_package_view.json">
  $.canView = true;
</m:auth>
</script>

<script type="text/javascript">
  var dataGrid;
  $(function() {
    dataGrid = renderDataGrid('${pageContext.request.contextPath}/combine_package/data_grid.json');
  });
  $.extend($.fn.validatebox.defaults.rules, {
    time : {
      validator : function(value, param) {
        var reg = new RegExp(
            '(^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$)|(^24:00$)');
        return reg.test(value);
      },
      message : '${internationalConfig.请输入合法时间}'
    }
  });

  function renderDataGrid(url) {
    return $('#dataGrid')
        .datagrid(
            {
              url : url,
              fit : true,
              fitColumns : false,
              border : false,
              pagination : true,
              idField : 'id',
              pageSize : 10,
              pageList : [ 10, 20, 30, 40, 50 ],
              sortName : 'id',
              sortOrder : 'desc',
              checkOnSelect : false,
              selectOnCheck : false,
              nowrap : false,
              striped : true,
              rownumbers : true,
              singleSelect : true,
              frozenColumns : [ [ {
                field : 'id',
                title : '${internationalConfig.编号}',
                width : 150,
                hidden : true
              } ] ],
              columns : [ [
                  {
                    field : 'id',
                    title : '${internationalConfig.序号}',
                    width : 50,
                    sortable : true
                  },
                  {
                    field : 'name',
                    title : '${internationalConfig.组合套餐名称}',
                    width : 200,
                    sortable : true
                  },
                  {
                    field : 'childName',
                    title : '${internationalConfig.所含子套餐名称}',
                    width : 200,
                    sortable : true
                  },
                  {
                    field : 'terminalsName',
                    title : '${internationalConfig.终端}',
                    width : 100,
                    sortable : false
                  },
                  {
                    field : 'isSupportLepoint',
                    title : '${internationalConfig.是否支持乐点}',
                    width : 80,
                    sortable : true,
                    formatter : function(value) {
                      if (value == 0) {
                        return "${internationalConfig.支持}";
                      }
                      if (value == 1) {
                        return "${internationalConfig.不支持}";
                      }
                    }
                  },
                  {
                    field : 'originPrice',
                    title : '${internationalConfig.套餐现价}',
                    width : 100,
                    sortable : true
                  },
                  {
                    field : 'price',
                    title : '${internationalConfig.套餐价格}',
                    width : 100,
                    sortable : true
                  },
                  {
                    field : 'vipPrice',
                    title : '${internationalConfig.套餐会员价}',
                    width : 100,
                    sortable : true
                  },
                  {
                    field : 'status',
                    title : '${internationalConfig.状态}',
                    width : 80,
                    sortable : true,
                    formatter : function(value) {
                      if (value == 0) {
                        return "${internationalConfig.上线}";
                      }
                      if (value == 1) {
                        return "${internationalConfig.下线}";
                      }
                    }
                  },
                  {
                    field : 'createTime',
                    title : '${internationalConfig.创建时间}',
                    width : 80,
                    sortable : true
                  },

                  {
                    field : 'updateTime',
                    title : '${internationalConfig.更新时间}',
                    width : 80,
                    sortable : true
                  },
                  {
                    field : 'action',
                    title : '${internationalConfig.操作}',
                    width : 60,
                    formatter : function(value, row, index) {
                      var str = '';
                      
                      if ($.canEdit) {
                        str += $
                            .formatString(
                                '<img onclick="editFun(\'{0}\');" src="{1}" title="${internationalConfig.编辑}"/>',
                                row.id,
                                '${pageContext.request.contextPath}/static/style/images/extjs_icons/bug/bug_edit.png');
                      }
                      
                      str += '&nbsp;';
                      
                      if ($.canView) {
                        str += $
                            .formatString(
                                '<img onclick="viewFun(\'{0}\');" src="{1}" title="${internationalConfig.查看}"/>',
                                row.id,
                                '${pageContext.request.contextPath}/static/style/images/extjs_icons/bug/bug_link.png');
                      }
                      return str;
                    }
                  } ] ],
              toolbar : '#toolbar',
              onLoadSuccess : function() {
                //            $('#searchForm table').show();
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
  }

  function editFun(combineId) {
    parent.$
        .modalDialog({
          title : '${internationalConfig.编辑套餐}',
          scroll : true,
          width : 850,
          height : 500,
          resizable : true,
          maximizable : true,
          href : '${pageContext.request.contextPath}/combine_package/combine_package_edit.json?combineId='
              + combineId,
          buttons : [ {
            text : '${internationalConfig.保存}',
            handler : function() {
              parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
              var f = parent.$.modalDialog.handler.find('#form');
              f.submit();
            }
          }, {
            text : "${internationalConfig.取消}",
            handler : function() {
              parent.$.modalDialog.handler.dialog('close');
            }
          }

          ]
        });
  }

  function addFun() {
    parent.$.modalDialog({
      title : '${internationalConfig.添加套餐}',
      width : 850,
      height : 500,
      scroll : true,
      resizable : true,
      maximizable : true,
      href : '${pageContext.request.contextPath}/combine_package/combine_package_add.json',
      buttons : [ {
        text : '${internationalConfig.保存}',
        handler : function() {
          parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
          var f = parent.$.modalDialog.handler.find('#form');
          f.submit();
        }
      }, {
        text : "${internationalConfig.取消}",
        handler : function() {
          parent.$.modalDialog.handler.dialog('close');
        }
      } ]
    });
  }
  
  function deleteFun(id) {
    if (id == undefined) {
      var rows = dataGrid.datagrid('getSelections');
      id = rows[0].id;
    }
    parent.$.messager.confirm('${internationalConfig.确认}', '${internationalConfig.您确定要删除当前套餐}',
    function(b) {
      if (b) {
        parent.$.messager.progress({
          title : '${internationalConfig.提示}',
          text : '${internationalConfig.数据处理中}......'
        });
        $.post(
          '${pageContext.request.contextPath}/combine_package/delete.json',
          {
            combineId : id
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
              parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.请确认该套餐处于线下状态}', 'error');
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

  function viewFun(id) {
    if (id == undefined) {
      var rows = dataGrid.datagrid('getSelections');
      id = rows[0].id;
    }
    parent.$.modalDialog({
      title : '${internationalConfig.查看套餐}',
      width : 780,
      height : 500,
      href : '${pageContext.request.contextPath}/combine_package/combine_package_view.json?combineId='
          + id,
      buttons : [ 
      {
        text : "${internationalConfig.关闭}",
        handler : function() {
          parent.$.modalDialog.handler.dialog('close');
        }
      } ]
    });
  }
</script>
</head>
<body>
  <div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'" >
      <form id="searchForm">
        <table class="table-more">
          <tr>
            <td align="left">${internationalConfig.组合套餐名称}：<input type="text" class="span2"
                name="name" value="" />
            </td>
            <td align="left">${internationalConfig.状态}：<select name="status" class="span2">
                    <option value="-1" selected>${internationalConfig.全部}</option>
                <option value="0" >${internationalConfig.上线}</option>
                <option value="1">${internationalConfig.下线}</option>
              </select>
            </td>
            <td align="left">${internationalConfig.创建时间}：<input name="createTime" class="easyui-datebox span2"
              value=""> -- <input name="updateTime"
              class="easyui-datebox span2" value=""></td>
          </tr>
        </table>
      </form>
    </div>
    <div data-options="region:'center',border:false">
      <table id="dataGrid"></table>
    </div>
  </div>
  <div id="toolbar" style="display:none;">
    <m:auth uri="/combine_package/combine_package_add.json">
      <a onclick="addFun();" href="javascript:void(0);"
        class="easyui-linkbutton" data-options="plain:true,iconCls:'pencil_add'">${internationalConfig.增加}</a>
    </m:auth>
    <a href="javascript:void(0);" class="easyui-linkbutton"
      data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a><a
      href="javascript:void(0);" class="easyui-linkbutton"
      data-options="iconCls:'brick_delete',plain:true"
      onclick="cleanFun();">${internationalConfig.清空条件}</a>
  </div>
</body>
</html>
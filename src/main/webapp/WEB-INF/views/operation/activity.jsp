<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.活动管理}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
<m:auth uri="/activity/activity_edit.json">
  $.canEdit = true;
</m:auth>
</script>

<script type="text/javascript">
  var dataGrid;
  $(function() {
    dataGrid = renderDataGrid('${pageContext.request.contextPath}/activity/data_grid.json');//全部的活动
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
                    title : '${internationalConfig.活动id}',
                    width : 150
                
                  },
                  {
                    field : 'title',
                    title : '${internationalConfig.标题}',
                    width : 150
                    
                  },
                  {
                    field : 'groupIdsDesc',
                    title : '${internationalConfig.所属分组}',
                    width : 80,
                  },
                  {
                    field : 'label',
                    title : '${internationalConfig.促销签}',
                    width : 200
                  },
                  {
                    field : 'text',
                    title : '${internationalConfig.营销文字}',
                    width : 200
                  },
                  {
                    field : 'beginDate',
                    title : '${internationalConfig.开始日期}',
                    width : 130,
                    sortable : true
                  },

                  {
                    field : 'endDate',
                    title : '${internationalConfig.结束日期}',
                    width : 130,
                    sortable : true
                  },
                  {
                    field : 'beginTime',
                    title : '${internationalConfig.每日开始时段}',
                    width : 100,
                    sortable : true
                  },
                  {
                    field : 'endTime',
                    title : '${internationalConfig.每日结束时段}',
                    width : 100,
                    sortable : true
                  },
                  {
                    field : 'priority',
                    title : '${internationalConfig.优先级}',
                    width : 80,
                    sortable : true
                  },
                  {
                    field : 'status',
                    title : '${internationalConfig.活动状态}',
                    width : 80,
                  
                    formatter : function(value) {
                      if (value == 31) {
                        return "${internationalConfig.上线}"
                      }
                      if (value == 32) {
                        return "${internationalConfig.下线}"
                      }
                    }
                  },
                  {
                    field : 'action',
                    title : '${internationalConfig.操作}',
                    width : 100,
                    formatter : function(value, row, index) {
                      var str = $.formatString(
                                '<img onclick="editFun(\'{0}\');" src="{1}" title="${internationalConfig.编辑}" />',
                                row.id,'${pageContext.request.contextPath}/static/style/images/extjs_icons/bug/bug_edit.png');
                    
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

  function editFun(activityId) {
    parent.$
        .modalDialog({
          title : '${internationalConfig.修改}',
          scroll : true,
          width : 780,
          height : 500,
          resizable : true,
          maximizable : true,
          href : '${pageContext.request.contextPath}/activity/activity_edit.json?activityId='
              + activityId,
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
      title : '${internationalConfig.添加活动}',
      width : 780,
      height : 500,
      scroll : true,
      resizable : true,
      maximizable : true,
      href : '${pageContext.request.contextPath}/activity/activity_add.json',
      buttons : [ {
        text : '${internationalConfig.增加}',
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

  function searchFun() {
    dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
  }
  function cleanFun() {
    $('#searchForm input').val('');
    dataGrid.datagrid('load', {});
  }

  //下线操作
  function offlineFun(activityId) {
    parent.$.messager.confirm('${internationalConfig.确认}', '${internationalConfig.下线当前活动}', function(isAllowed) {
      if (isAllowed) {
        parent.$.messager.progress({
          title : '${internationalConfig.提示}',
          text : '${internationalConfig.数据处理中}......'
        });
        $.post('${pageContext.request.contextPath}/activity/offline', {
          activityId : activityId
        }, function(result) {
          if (result.success) {
            searchFun();
          } else {
            parent.$.messager.alert('${internationalConfig.页面错误}', result.msg, 'error');
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
    <div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'">
      <form id="searchForm">
        <table class="table-td-four">
          <tr>
            <td>${internationalConfig.所属分组}：<select class="span2" name="groupId" style="margin-top: 5px">
                <option value="0" selected="selected">${internationalConfig.所有分组}</option>
                <c:forEach items="${activityGroups}" var="pg">
                  <c:if test="${pg == '1'}">
                    <option value="${pg}">${internationalConfig.默认}</option>
                  </c:if>
                  <c:if test="${pg != '1'}">
                  <option value="${pg}">${pg}</option>
                  </c:if>
                </c:forEach>
            </select></td>
            <td>${internationalConfig.活动状态}：<select name="status" class="span2">
                  <option value="-1">${internationalConfig.全部}</option>
                  <option value="31">${internationalConfig.上线}</option>
                  <option value="32">${internationalConfig.下线}</option>
                 <%--  <c:forEach items="${statuses}" var="status">
                    <option value="${status.value}">${status.description}</option>
                  </c:forEach> --%>
              </select>
            </td>
            <td>${internationalConfig.开始日期}：<input name="beginDate" class="easyui-datebox span2"
              value=""></td><td> ${internationalConfig.结束日期}： <input name="endDate"
              class="easyui-datebox span2" value="">
            </td>
          </tr>
          <tr>
            <td>${internationalConfig.活动标题}：<input type="text" class="span2"
                name="title" value="" />
            </td>
            <td>${internationalConfig.开始时段}：<input name="beginTime" class="easyui-validatebox span2"
              data-options="validType:'time'" value=""> </td><td>${internationalConfig.结束时段}： <input
              name="endTime" class="easyui-validatebox span2"
              data-options="validType: 'time'" value="">
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
    <m:auth uri="/activity/activity_add.json">
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
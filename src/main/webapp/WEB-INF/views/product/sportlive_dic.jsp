<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.直播内容管理}</title>

<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
<m:auth uri="/sportlive_dic/sportlive_dic_edit.json">
  $.canEdit = true;
</m:auth>
</script>
<script type="text/javascript">
  var dataGrid;
  $(function() {
    dataGrid = $('#dataGrid').datagrid({
      url : '${pageContext.request.contextPath}/sportlive_dic/data_grid.json',
      fit : true,
      fitColumns : true,
      border : false,
      pagination : true,
      idField : 'id',
      pageSize : 20,
      pageList : [ 10, 20, 30, 40, 50 ],
      sortName : 'id',
      sortOrder : 'asc',
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
        field : 'id',
        title : '${internationalConfig.编号}',
        width : 60
      },{
        field : 'typeDescription',
        title : '${internationalConfig.字典类型}',
        width : 50
      }, 
      {
        field : 'description',
        title : '${internationalConfig.字典描述}',
        width : 60
      },
      {
        field : 'pid',
        title : '${internationalConfig.上级ID}',
        width : 60
      },{
        field : 'imageUrl',
        title : '${internationalConfig.图片URL}',
        width : 80
      },{
        field : 'action',
        title : '${internationalConfig.操作}',
        width : 100,
        formatter : function(value, row, index) {
          var str = '';
          
          if ($.canEdit) {
            str += $.formatString('<img onclick="editFun(\'{0}\',\'{1}\');" src="{2}" title="${internationalConfig.编辑}"/>', row.id,row.type, '${pageContext.request.contextPath}/static/style/images/extjs_icons/bug/bug_edit.png');
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
  function editFun(id,type) {
    if (typeof id == 'undefined') {
      var rows = dataGrid.datagrid('getSelections');
      id = rows[0].id;
      type = rows[0].type;
    }
    parent.$.modalDialog({
      title : '${internationalConfig.编辑直播价格}',
      width : 680,
      height : 400,
      resizable : true,
      href : '${pageContext.request.contextPath}/sportlive_dic/sportlive_dic_edit.json?id=' + id + "&type="+type,
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
  function downloadTermInfo(){
    parent.$.modalDialog({
      title : '${internationalConfig.下载球队信息}',
      width : 600,
      height : 400,
      resizable : true,
      href : '${pageContext.request.contextPath}/sportlive_dic/download_team_add.json',
      buttons : [ {
        text : '${internationalConfig.下载}',
        handler : function() {
          parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
          var f = parent.$.modalDialog.handler.find('#form');
          f.submit();
        }
      } ]
    });
  }
</script>
</head>
<body>
  <div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'" >
      <form id="searchForm">
        <table class="table-td-two">
          <tr>
            <td>${internationalConfig.编号}：<input name="id" class="span2" /></td>
          </tr>
        </table>
      </form>
    </div>
    <div data-options="region:'center',border:false">
      <table id="dataGrid"></table>
    </div>
  </div>
  <div id="toolbar" style="display: none;">
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">${internationalConfig.清空条件}</a>
    <m:auth uri="/sportlive_dic/download_team_add.json">
      <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'bug_add',plain:true" onclick="downloadTermInfo();">${internationalConfig.下载球队信息}</a>
    </m:auth>
  </div>
  
  <m:auth uri="/sportlive_dic/sportlive_dic_edit.json">
    <div id="menu" class="easyui-menu" style="width: 120px; display: none;">
      <div onclick="editFun();" data-options="iconCls:'pencil'">${internationalConfig.编辑}</div>
    </div>
  </m:auth>
  
</body>
</html>
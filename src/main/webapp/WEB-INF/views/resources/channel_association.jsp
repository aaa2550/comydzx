<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.合作公司管理}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
$.canEdit = true;
$.canDelete = true;
  var dataGrid;
  (function($){
	  $.fn.serializeJson=function(){ 
 
	      var serializeObj={};  
	      var array=this.serializeArray();  
	      $(array).each(function(){ // 遍历数组的每个元素 {name : xx , value : xxx}
	              if(serializeObj[this.name]){ // 判断对象中是否已经存在 name，如果存在name 
	                  serializeObj[this.name]+=","+this.value;
	              }else{ 
	                      serializeObj[this.name]=this.value; // 如果元素name不存在，添加一个属性 name:value 
	              } 
	      }); 
	      return serializeObj; 
	  }
	})(jQuery)

  $(function() {
         
    dataGrid = renderDataGrid('/channelAssociation/dataGrid');
  });

  function renderDataGrid(url,data,method) {
    return $('#dataGrid')
        .datagrid(
            {
              url : url,
              fit : true,
              queryParams:data||"",
              fitColumns : true,
              border : false,
              method:method||'post',
              pagination : true,
              idField : 'id',
              pageSize : 50,
              pageList : [ 50, 100 ],
              sortOrder : 'asc',
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
              columns : [[{
                      field : 'id',
                      title : '${internationalConfig.公司ID}',
                      width : 100,
                      sortable : false,
                      hidden : false
                    },
                    {
                      field : 'channelName',
                      title : '${internationalConfig.公司名称}',
                      width : 100,
                      sortable : false
                    },
                    {
                      field : 'uid',
                      title : '${internationalConfig.操作者}',
                      width : 100,
                      sortable : false
                    },
                    {
                      field : 'updateTime',
                      title : '${internationalConfig.更新时间}',
                      width : 150
                    },
                    {
                      field : 'action',
                      title : '${internationalConfig.操作}',
                      width : 100,
                      formatter : function(value, row, index) {
                        var str = '';
                        
                        if ($.canEdit) {
                          str += $
                              .formatString(
                                  '<img onclick="editFun(\'{0}\');" src="{1}" title="${internationalConfig.编辑}"/>',
                                  row.id,
                                  '/static/style/images/extjs_icons/bug/bug_edit.png');
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
  }


  function editFun(id) {
    if (id == undefined) {
      var rows = dataGrid.datagrid('getSelections');
      id = rows[0].id;
    }

    parent.$.modalDialog({
      title : '${internationalConfig.编辑合作公司}',
      width : 650,
      height : 350,
      href : '/channelAssociation/edit?id='
          + id,
      onClose:function(){
        this.parentNode.removeChild(this);
      },
      buttons : [ {
        text : '${internationalConfig.保存}',
        handler : function() {
          parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
          var f = parent.$.modalDialog.handler.find('#form');
          //submitFun(f);
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


  function addFun(id) {
    parent.$.modalDialog({
      title : '${internationalConfig.合作公司创建}',
      width : 650,
      height : 350,
      href : '/channelAssociation/add?id=',
      onClose:function(){
        this.parentNode.removeChild(this);
      },
      buttons : [ {
        text : '${internationalConfig.增加}',
        handler : function() {
          parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
          var f = parent.$.modalDialog.handler.find('#form');
          //submitFun(f);
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
  function submitFun(f){
    if(f.form("validate")){
      if(!validateMemberPrice())return false;
      parent.$.messager.progress({
        title : '${internationalConfig.提示}',
        text : '${internationalConfig.数据处理中}....'
      });
      $.ajax({
        url:"/channelAssociation/save",
        type:"post",
        data:f.serializeJson(),
        dataType:"json",
        success:function(result){
          parent.$.messager.progress('close');
          /* result = $.parseJSON(result); */
          if (result.code == 0) {
                    parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.添加成功}', 'success');
            parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
            parent.$.modalDialog.handler.dialog('close');
          } else{
        	parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
          }
        },
        error:function(){
          
        }
        
        
      })
    } 
  }

  function searchFun() {
    parent.$.messager.progress({
      title : '${internationalConfig.提示}',
      text : '${internationalConfig.数据处理中}....'
    });

    renderDataGrid('/channelAssociation/dataGrid?',$('#searchForm').serializeJson(),"get")
    parent.$.messager.progress('close');
  }
  function cleanFun() {
    $('#searchForm input').val('');
    renderDataGrid('/channelAssociation/dataGrid');
  }
</script>
</head>
<body>
  <div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.合作公司管理}',border:false,height:'auto'">
      <form id="searchForm">
        <table  class="table-more">
          <tr>
              <td>${internationalConfig.公司ID}：<input type="text"  name="id" class="easyui-validatebox"/> <span style="color: red;font-size: 12px"></span></td>
              <td>${internationalConfig.公司名称}：<input type="text"  name="channelName" class="easyui-validatebox"/> <span style="color: red;font-size: 12px"></span></td>
          </tr>
        </table>
      </form>
    </div>
    <div data-options="region:'center',border:false">
      <table id="dataGrid"></table>
    </div>
  </div>
  <div id="toolbar" style="display: none;">
    <%-- <m:auth uri="/package/add.json"> --%>
      <a onclick="addFun();" href="javascript:void(0);"
        class="easyui-linkbutton"
        data-options="plain:true,iconCls:'pencil_add'">${internationalConfig.增加}</a>
    <%-- </m:auth> --%>
    <a href="javascript:void(0);" class="easyui-linkbutton"
      data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">${internationalConfig.清空条件}</a>
  </div>
</body>
</html>
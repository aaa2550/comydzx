<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.自动续费短信模板}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
    <script type="text/javascript" src="/js/kv/vipCategory.js"></script>
    <script type="text/javascript" src="/js/kv/vipType.js"></script>
<script type="text/javascript">
$.canEdit = true;
$.canDelete = true;
  var dataGrid;
  (function($){
	  $.fn.serializeJson=function(){ 
 
	      var serializeObj={};  
	      var array=this.serializeArray();  
	      // var str=this.serialize(); 
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
         
    dataGrid = renderDataGrid('/v2/product/template/dataGrid');
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
                      field : 'noteName',
                      title : '${internationalConfig.短信名称}',
                      width : 100,
                      sortable : false,
                      hidden : false
                    },
                    {
                      field : 'vipType',
                      title : '${internationalConfig.会员类型}',
                      width : 100,
                      sortable : false,
                        formatter : function(val) {
                            return Dict.vipCategory[val];
                        }
                    },
                    {
                      field : 'typeId',
                      title : '${internationalConfig.会员名称}',
                      width : 100,
                      sortable : false,
                        formatter : function(val) {
                            return Dict.vipType[val];
                        }
                    },
                    {
                      field : 'incidentType',
                      title : '${internationalConfig.事件类型}',
                      width : 150,
                        formatter : function(value) {
                            if(value==10001){
                              return "${internationalConfig.开通会员提醒}"
                            }
                            if(value==10002){
                                return "${internationalConfig.会员自扣费提醒}"
                            }
                            if(value==10003){
                                return "${internationalConfig.解除自扣费提醒}"
                            }
                        }
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
      title : '${internationalConfig.编辑短信模板}',
      width : 700,
      height : 600,
      href : '/v2/product/template/edit?id='
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
      title : '${internationalConfig.添加短信模板}',
      width : 700,
      height : 600,
      href : '/v2/product/template/add?id=',
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
        url:"/v2/product/vipPackage/save",
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

    renderDataGrid('/v2/product/template/dataGrid?',$('#searchForm').serializeJson(),"get")
    parent.$.messager.progress('close');
  }
  function cleanFun() {
    $('#searchForm')[0].reset();
    renderDataGrid('/v2/product/template/dataGrid');
  }
</script>
</head>
<body>
  <div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.自动续费短信模板}',border:false,height:'auto'">
      <form id="searchForm">
        <table  class="table-more">
          <tr>
            <td>${internationalConfig.短信名称}：<input type="text"  name="noteName" class="easyui-validatebox"/> <span id="message" style="color: red;font-size: 12px"></span></td>
            <td>${internationalConfig.事件类型}：
                <select name="incidentType">
                    <option value="-1">${internationalConfig.全部}</option>
                    <option value="10001">${internationalConfig.开通会员提醒}</option>
                    <option value="10002">${internationalConfig.会员自扣费提醒}</option>
                    <option value="10003">${internationalConfig.解除自扣费提醒}</option>
                </select>
            </td>
              <td>${internationalConfig.会员类型}：
                  <select name="vipType" style="width: 150px">
                      <option value="-1">${internationalConfig.全部}</option>
                      <c:forEach items="${vipCategoryList}" var="vipCategory" >
                          <option value="${vipCategory.category}"> ${internationalConfig[vipCategory.name]}</option>
                      </c:forEach>
                 </select></td>
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
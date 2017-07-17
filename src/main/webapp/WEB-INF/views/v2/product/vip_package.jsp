<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.会员套餐管理}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript" src="/js/kv/vipType.js"></script>
<script type="text/javascript" src="/js/kv/vipDuration.js"></script>
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
	                    /* if($.isArray(serializeObj[this.name])){ 
	                           serializeObj[this.name].push(this.value); // 追加一个值 hobby : ['音乐','体育'] 
	                    }else{ 
	                            // 将元素变为 数组 ，hobby : ['音乐','体育'] 
	                            serializeObj[this.name]=[serializeObj[this.name],this.value]; 
	                    }  */
	                  serializeObj[this.name]+=","+this.value;
	              }else{ 
	                      serializeObj[this.name]=this.value; // 如果元素name不存在，添加一个属性 name:value 
	              } 
	      }); 
	      return serializeObj; 
	  }
	})(jQuery)

  $(function() {
         
    dataGrid = renderDataGrid('/v2/product/vipPackage/dataGrid');
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
              sortName: "id",
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
              columns : [[{
                      field : 'id',
                      title : '${internationalConfig.套餐ID}',
                      width : 50,
                      sortable : false,
                      hidden : false
                    },
                    {
                      // field : 'typeId',
                      field : 'name',
                      title : '${internationalConfig.会员名称}',
                      width : 100,
                      sortable : false,
                      /*
                      formatter : function(value) {
                        if(Dict.vipType[value]==null){
                          return "";
                        }
                        return Dict.vipType[value];
                      }
                      */
                    },
                    /* {
                      field : 'version',
                      title : '会员版本',
                      width : 80,
                      sortable : false,
                      formatter : function(value) {
                        if (value == 1) {
                                      return "普通版本";
                                    }
                                    if (value == 2) {
                                      return "商业版本";
                                    }
                      }
                    }, */
                    {
                      field : 'durationId',
                      title : '${internationalConfig.套餐时长名称}',
                      width : 100,
                      sortable : false,
                      formatter : function(value) {
                        if(Dict.vipDuration[value]==null){
                          return "";
                        }
                        return Dict.vipDuration[value].name;
                      }
                    },
                    {
                      field : 'terminal',
                      title : '${internationalConfig.终端}',
                      width : 150,
                      formatter : function(value) {
                          var terminal={<c:forEach var="terminal" items="${terminals}">"${terminal.terminalId}":"${terminal.terminalName}",</c:forEach>};
                          if(value!=null){
                            var s=value.split(",");
                            var array=new Array();
                            for(var a in s){
                              array.push(terminal[s[a]]);
                            }
                            return array.join(", ");
                            }else{
                              return "";
                            }
                      }
  
                    },
                    {
                      field : 'packageGroups',
                      title : '${internationalConfig.套餐分组名称}',
                      width : 150,
                      sortable : false,
                      formatter: function(value,row,index){
                          if (row.packageGroups){
                              var groupNames = [];
                              $.each(row.packageGroups, function(){
                                  if(this.groupInfo)
                                    groupNames.push(this.groupInfo.groupName);
                              });
                              return groupNames.join(', ');
                          }
                          return '';
                      }

                    },<c:if test="${currentCountry==86||currentCountry==852}">
                    {
                        field : 'packageCategory',
                        title : '${internationalConfig.套餐类型}',
                        width : 60,
                        sortable : false,
                        formatter: function(value){
                            var types = {1:"${internationalConfig.常规套餐}",2:"${internationalConfig.活动套餐}"};
                            return types[value];
                        }

                    },</c:if>
                    {
                      field : 'price',
                      title : '${internationalConfig.现售价}',
                      width : 60,
                      sortable : false
  
                    },
                    {
                      field : 'status',
                      title : '${internationalConfig.套餐状态}',
                      width : 60,
                      sortable : false,
                      formatter : function(value) {
                        if (value == 1) {
                                      return "${internationalConfig.未发布}";
                                    }
                                    if (value == 3) {
                                      return "${internationalConfig.已发布}";
                                    }
                      }
  
                    },
                    {
                      field : 'updateTime',
                      title : '${internationalConfig.最后修改时间}',
                      width : 100,
                      sortable : true
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
                         str += '&nbsp;';
                         if ($.canDelete) {
                             str += $.formatString('<img onclick="deleteFun(\'{0}\');" src="{1}" title="${internationalConfig.删除}"/>', row.id, '/static/style/images/extjs_icons/bug/bug_delete.png');
                         }
                        str += '&nbsp;';
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

  function deleteFun(id) {
    if (id == undefined) {
      var rows = dataGrid.datagrid('getSelections');
      id = rows[0].id;
    }
    parent.$.messager
        .confirm(
            '${internationalConfig.询问}',
            '${internationalConfig.您是否要删除当前套餐}',
            function(b) {
              if (b) {
                parent.$.messager.progress({
                  title : '${internationalConfig.提示}',
                  text : '${internationalConfig.数据处理中}....'
                });
                $
                    .post(
                        '/v2/product/vipPackage/delete',
                        {
                          id : id
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
                          }
                          parent.$.messager
                              .progress('close');
                        }, 'JSON');
              }
            });
  }

  function editFun(id) {
    if (id == undefined) {
      var rows = dataGrid.datagrid('getSelections');
      id = rows[0].id;
    }

    parent.$.modalDialog({
      title : '${internationalConfig.编辑套餐}',
      width : 800,
      height : 500,
      href : '/v2/product/vipPackage/packageInfo?packageId='
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
      title : '${internationalConfig.添加套餐}',
      width : 780,
      height : 500,
      href : '/v2/product/vipPackage/packageInfo?packageId=',
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
          } else if(result.code == 2){
        	parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.套餐描述文字过长}', 'error'); 
          } else{
        	parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.该套餐已存在}', 'error');  
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

    renderDataGrid('/v2/product/vipPackage/dataGrid?',$('#searchForm').serializeJson(),"get")
    /* renderDataGrid('${pageContext.request.contextPath}/package/search.json?'
        + $('#searchForm').serialize()); */

    parent.$.messager.progress('close');
  }
  function cleanFun() {
      $('#searchForm input').val('');
      $("#searchForm select").each(function(){
          var _self=$(this);
          _self.val(_self.find("option:first").val());
      });
      renderDataGrid('/v2/product/vipPackage/dataGrid');
  }
</script>
</head>
<body>
  <div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.会员套餐}',border:false,height:'auto'">
      <form id="searchForm">
        <table  class="table-more">
          <tr>
            <td>${internationalConfig.会员名称}：<select class="span2" name="typeId">
                <option value="-1" selected="selected">${internationalConfig.全部}</option>
                <c:forEach items="${vipPackageType}" var="packageType">
                  <option value="${packageType.id}">${packageType.name}</option>
                 </c:forEach>
            </select></td>
            <td>${internationalConfig.状态}：<select class="span2" name="status">
                <option value="0" selected="selected">${internationalConfig.全部}</option>
                <option value="1">${internationalConfig.未发布}</option>
                <option value="3">${internationalConfig.已发布}</option>
                <%-- <c:forEach items="${statuses}" var="status">
                  <option value="${status.id}">${status.description}</option>
                </c:forEach> --%>
            </select></td>
              <c:if test="${currentCountry==86||currentCountry==852}">
              <td>
                  ${internationalConfig.套餐类型}:&nbsp;
                  <select class="span2" name="packageCategory">
                      <option value="">${internationalConfig.全部类型}</option>
                      <option value="1">${internationalConfig.常规套餐}</option>
                      <option value="2">${internationalConfig.活动套餐}</option>
                  </select>
              </td>
              </c:if>
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
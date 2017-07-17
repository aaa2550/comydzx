<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>${internationalConfig.活动管理}</title>
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
    <script src="${pageContext.request.contextPath}/js/dict.js"></script>
    <script type="text/javascript">
        /**
         * 待绑定行数据
         */
        var rows;
        var dataGrid;
        $(function () {
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/v2/activity/data_grid');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').datagrid({
                url: url,
                fit: true,
                fitColumns: true,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 20,
                pageList: [ 10, 20, 30, 40, 50 ],
                sortName: 'id',
                sortOrder: 'desc',
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                striped: true,
                rownumbers: true,
                singleSelect: true,
                remoteSort: false,
                frozenColumns: [
                    [
                    ]
                ],
                columns: [
                    [
						{
						    field: 'type',
						    title: '${internationalConfig.活动类型}',
						    width: 100,
						    sortable: true,
							formatter:function(value){return Dict.getName('v2_activity_type',value)}
						},
                        {
                            field: 'id',
                            title: '${internationalConfig.活动id}',
                            width: 100,
                            sortable: true
                        },{
                            field: 'title',
                            title: '${internationalConfig.活动标题}',
                            width: 200,
                            sortable: true
                        },{
                            field: 'vipCombindPackageName',
                            title: '${internationalConfig.活动套餐}',
                            width: 200,
                            sortable: true
                        },{
                            field: 'operator',
                            title: '${internationalConfig.创建人}',
                            width: 200,
                            sortable: true
                        },
                        {
                            field: 'beginDate',
                            title: '${internationalConfig.开始日期}',
                            width: 200,
                            sortable: true,
							formatter: function(value){return value==""?value:value.substr(0,10)}
                        },
                        {
                            field: 'endDate', 
                            title: '${internationalConfig.结束日期}',
                            width: 200,
                            sortable: true,
							formatter: function(value){return value==""?value:value.substr(0,10)}
                        },
						{
                            field: 'status', 
                            title: '${internationalConfig.状态}',
                            width: 150,
                            sortable: true,
							formatter : function(value) {
                                if(value==1)return '${internationalConfig.未发布}';
                                else if(value==3) return '${internationalConfig.已发布}';
                                else return '';
                            }
                        },
						{
                            field: 'action', 
                            title: '${internationalConfig.操作}',
							width: 100,
							formatter: function (value, row, index) {
								var str = $.formatString('<img onclick="addFun(\'{0}\');" src="{1}" title="${internationalConfig.编辑}"/>', row.id, '/static/style/images/extjs_icons/pencil.png');
								return str;
							}
                        }
                    ]
                ],
                toolbar: '#toolbar',
                onLoadSuccess: function (data) {
                    parent.$.messager.progress('close');
                    rows = data['rows'];
                  //  loadChart(data) ;
                },
                onRowContextMenu: function (e, rowIndex, rowData) {
                    e.preventDefault();
                    $(this).datagrid('unselectAll');
                    $(this).datagrid('selectRow', rowIndex);
                    $('#menu').menu('show', {
                        left: e.pageX,
                        top: e.pageY
                    });
                }
            });
        }

         function searchFun() {
             dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        } 
        function cleanFun() {
            $('#searchForm input').val('');
            $('#searchForm select').val('');
            dataGrid.datagrid('load', {});
        }

        $(function () {
            parent.$.messager.progress('close');
        });
		
	function addFun(id) {
		parent.$.modalDialog({
		  title : id?'${internationalConfig.编辑活动}':'${internationalConfig.添加活动}',
		  width : 780,
		  height : 500,
		  scroll : true,
		  resizable : true,
		  maximizable : true,
		  href : '${pageContext.request.contextPath}/v2/activity/edit'+(id==undefined?'':'?id='+id),
		  buttons : [ {
			text : id?'${internationalConfig.保存}':'${internationalConfig.增加}',
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

	function getDictNameByCode(dictList,code){
		for(var x in dictList){
			if(dictList[x].code==code)
				return dictList[x].name;
		}
	}
    </script>
    
    <style>
        .span {
            padding: 10px;
        }
		.searchtable{padding:5px;}
        .table-td-six tr td{
            line-height: 40px;
            white-space:nowrap;
            padding-left:10px;
        }
        select{
            width:126px;
        }
    </style>
    
</head>

<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false" style="height: 120px; overflow: hidden;">
      <form id="searchForm">
        <table class="table-td-six searchtable">
          <tr>
            <td width="10%">${internationalConfig.活动标题}:</td>
            <td width="20%"><input name="title" class="span2"></td>
			<td width="10%">${internationalConfig.活动id}:</td>
            <td width="20%">
				<input name="id" class="span2">
			</td>
            <td width="10%">${internationalConfig.活动状态}:</td>
            <td width="30%">
				<select name="status">
                    <option value="">${internationalConfig.全部}</option>
                    <option value="1">${internationalConfig.未发布}</option>
                    <option value="3">${internationalConfig.已发布}</option>
              </select>
            </td>
          </tr>
          <tr>
            <td>${internationalConfig.活动类型}:</td>
            <td>
			<select name="type">
                <option value="">${internationalConfig.全部}</option>
                <c:forEach items="${dict['v2_activity_type']}" var="item">
                <option value="${item.key}">${item.value}</option>
                </c:forEach>
            </select>
            </td>
			<td>${internationalConfig.开始日期}:</td>
             <td>
                 <input name="beginDate" class="easyui-datebox span2" value="">
			</td>
			<td> ${internationalConfig.结束日期}:</td>
            <td>
                <input name="endDate" class="easyui-datebox span2" value="">
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
      <a onclick="addFun();" href="javascript:void(0);"
      class="easyui-linkbutton" data-options="plain:true,iconCls:'pencil_add'">${internationalConfig.增加}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
      data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a><a
      href="javascript:void(0);" class="easyui-linkbutton"
      data-options="iconCls:'brick_delete',plain:true"
      onclick="cleanFun();">${internationalConfig.清空条件}</a>
  </div>

</body>
</html>
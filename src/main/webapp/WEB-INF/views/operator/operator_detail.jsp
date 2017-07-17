<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>运营商结算明细</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript" src="/js/kv/operator.js"></script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'查询条件',border:false"
			style="overflow: hidden; height: 95px">
        <form id="searchForm" onsubmit="return false">
            <table class="table-more" style="display: none;">
                <tr>
                    <td>运营商：
                      <input id="inputSearch" class="span2 input-box" autocomplete="off">
                     <input class="span2" type="hidden" name="oid"   value="0">
                    
                  
                    </td>
                    <td>结算类型: <select name="stype" class="span2">
                    <option selected="selected" value="0">全部</option>
                     	<option value="1">集采</option>
						<option value="2">代销</option>
                    </select>
                    </td>
                 
                    <td>对账周期：
                    <m:date name="year"  before="10"  after="10" type="year"  attr="class=yys_dz_select"></m:date>年
               <m:date name="month"  type="month"  attr="class=yys_dz_select"></m:date>月
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
       class="easyui-linkbutton" data-options="plain:true,iconCls:'bug_add'">添加</a>

  
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a><a
        href="javascript:void(0);" class="easyui-linkbutton"
        data-options="iconCls:'brick_delete',plain:true"
        onclick="cleanFun();">清空条件</a>
</div>

<script type="text/javascript">

var dataGrid;
$(function () {
    dataGrid = renderDataGrid('/operator/list_detail');
    
	var co = new Boss.util.combo({	  url:"/search_name?type=operatorName"})
	
	$(co).bind('select',function(eventName,el){
		$('input[name=oid]').val(el.attr('data-id'));
	});
    
});

function renderDataGrid(url) {
    return $('#dataGrid').datagrid({
        url: url,
        fit: true,
        fitColumns: false,
        border: false,
        pagination: true,
        idField: 'id',
        pageSize: 30,
        pageList: [ 10, 20, 30, 40, 50 ],
        sortName: 'updateTime',
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
                {
                    field: 'id',
                    title: '编号',
                    width: 150,
                    hidden: true
                }
            ]
        ],
        columns: [
            [
                {
                    field: 'oid',
                    title: '运营商',
                    width: 100,
                    formatter: function(value,row){
                    	return Dict.operator[value];
                    }
                },
                {
                    field: 'year',
                    title: '对账周期',
                    width: 200,
                    formatter: function(value,row){
                    	return value+"年"+row.month+"月";
                    }
                },
                {
                    field: 'stype',
                    title: '结算类型',
                    width: 60,
                    formatter: function(value){
                    	return value==1 ? "集采" :"代销";
                    }
                    
                },
                {
                    field: 'amount',
                    title: '结算金额（元）',
                    width: 90
                    
                },
               
               
                {
                    field: 'username',
                    title: '制表人',
                    width: 80
                },
             
                {
                    field: 'updateTime',
                    title: '更新时间',
                    width: 200,
                    sortable: true
                },           
                {
                    field: 'action',
                    title: '操作',
                    width: 100,
                    formatter: function (value, row, index) {
                        var str = '&nbsp;&nbsp;&nbsp;';
                            str += $.formatString('<img onclick="editFun(\'{0}\',0);" src="{1}" title="编辑"/>', row.id, '/static/style/images/extjs_icons/pencil.png');
                        
                      
                        return str; 
                    }
                }
            ]
        ],
        toolbar: '#toolbar',
        onLoadSuccess: function () {
            $('#searchForm table').show();
            parent.$.messager.progress('close');
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



function editFun(id,oaid) {
    parent.$.modalDialog({
        title: '编辑',
        width: 700,
        height: 600,
        href: '/operator/edit_detail?id=' + id+"&oaid="+oaid,
        buttons : [ {
			text : "保存",
			handler : function() {
				   parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                   var f = parent.$.modalDialog.handler.find('#form');
                   f.submit();
            
			}
		}

		]
    });
}

function addFun() {
	 
	    parent.$.modalDialog({
	        title: '添加',
	        width: 700,
	        height: 300,
	        href: '/operator/add_detail',
	        buttons : [ {
				text : "确定",
				handler : function() {
					   parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
	                  var f = parent.$.modalDialog.handler.find('#form');
	              
	                  parent.$.modalDialog.handler.dialog('close');
	                  editFun(0,f.find("#contract").val());
				}
			}

			]
	    });
}


function searchFun() {
	dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
}
function cleanFun() {
    $('#searchForm input').val('');
    $('#searchForm select').val('0');
    dataGrid.datagrid('load', {});
}




</script>
</body>
</html>
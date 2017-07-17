<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<title>运营商结算规则</title>
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

            	
                    <td>合同起止时间：<input id="start" name="startDate"
                                    class="easyui-datebox">
                    --<input id="end" name="endDate"
                                    class="easyui-datebox"></td>
                   
                 
                    <td>结算类型: <select name="stype" class="span2">
                    <option selected="selected" value="0">全部</option>
                     	<option value="1">集采</option>
						<option value="2">代销</option>
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
    dataGrid = renderDataGrid('/operator/list');
});

function renderDataGrid(url) {
    return $('#dataGrid').datagrid({
        url: url,
        fit: true,
        fitColumns: false,
        border: false,
        pagination: true,
        idField: 'id',
        pageSize: 10,
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
                    field: 'startDate',
                    title: '合同起止时间',
                    width: 200,
                    formatter: function(value,row){
                    	return value.replace("00:00:00","")+"—"+row.endDate.replace("00:00:00","");
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
                    field: 'hardware',
                    title: '硬件价格(元/台)',
                    width: 90
                    
                },
                {
              	  field: 'serviceLife',
                    title: '服务年限',
                    width: 80	 	
              },
                {
                    field: 'servicePrice',
                    title: '续费规则',
                    width: 80,
                    formatter: function(value,row){
                    	var s=row.serviceType==1 ? "元/月" :"元/年" ;
                    	return value+s ;
                    }
                   
                },
                {
                    field: 'renewal',
                    title: '第1年',
                    width: 60,
                    formatter: function(value,row){                
                    	var renewal=row.renewal ;
                    	if(renewal){
                    		renewal=renewal[0];
                    		return renewal.servicePrice+(renewal.serviceType==1 ? "元/月" :"元/年"  ) ;
                    	}
                    	return "";
                    }
                },
                {
                    field: 'renewal1',
                    title: '第2年',
                    width: 60,
                    formatter: function(value,row){                
                    	var renewal=row.renewal ;
                    	if(renewal && renewal[1]){
                    		renewal=renewal[1];
                    		return renewal.servicePrice+(renewal.serviceType==1 ? "元/月" :"元/年"  ) ;
                    	}
                    	return "";
                    }
                },
                {
                    field: 'renewal2',
                    title: '第2年',
                    width: 60,
                    formatter: function(value,row){                
                    	var renewal=row.renewal ;
                    	if(renewal && renewal[2]){
                    		renewal=renewal[2];
                    		return renewal.servicePrice+(renewal.serviceType==1 ? "元/月" :"元/年"  ) ;
                    	}
                    	return "";
                    }
                },
                {
                    field: 'renewal3',
                    title: '第4年',
                    width: 60,
                    formatter: function(value,row){                
                    	var renewal=row.renewal ;
                    	if(renewal && renewal[3] ){
                    		renewal=renewal[3];
                    		return renewal.servicePrice+(renewal.serviceType==1 ? "元/月" :"元/年"  ) ;
                    	}
                    	return "";
                    }
                },
                {
                    field: 'renewal4',
                    title: '第5年',
                    width: 60,
                    formatter: function(value,row){                
                    	var renewal=row.renewal ;
                    	if(renewal && renewal[4]){
                    		renewal=renewal[4];
                    		return renewal.servicePrice+(renewal.serviceType==1 ? "元/月" :"元/年"  ) ;
                    	}
                    	return "";
                    }
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
                            str += $.formatString('<img onclick="editFun(\'{0}\');" src="{1}" title="编辑"/>', row.id, '/static/style/images/extjs_icons/pencil.png');
                        
                      
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



function editFun(id) {
    if (id == undefined) {
        var rows = dataGrid.datagrid('getSelections');
        id = rows[0].id;
    }
    parent.$.modalDialog({
        title: '编辑',
        width: 700,
        height: 600,
        href: '/operator/edit?id=' + id,
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
	editFun(0);
}


function searchFun() {
	dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
}
function cleanFun() {
    $('#searchForm input').val('');
    $('#searchForm select').val('0');
    dataGrid.datagrid('load', {});
}

$(function(){
	var co = new Boss.util.combo({  url:"/search_name?type=operatorName"})
	
	$(co).bind('select',function(eventName,el){
		$('input[name=oid]').val(el.attr('data-id'));
	});
});


</script>

</body>
</html>
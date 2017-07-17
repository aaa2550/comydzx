<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>运营商对账管理</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'查询条件',border:false"
			style="overflow: hidden; height: 145px">
        <form id="searchForm" onsubmit="return false">
            <table class="table-td-four" style="display: none;">
                <tr>
                    <td>运营商：
                      <input id="inputSearch" class="span2 input-box" autocomplete="off">
                     <input class="span2" type="hidden" name="oid"  id="oid">
                    
                  
                    </td>
                 
                 
                    <td>对账周期：
                      <m:date name="year"  before="10"  after="10" type="year"  attr="class=yys_dz_select"></m:date>年
               <m:date name="month"  type="month"  attr="class=yys_dz_select"></m:date>月
                    </td>

               
                    </tr>
               
                    </table>
        
        </form>
         <div id="execel" class="yys_js_excel">对账报告导出：
    <m:date name="year2"  before="10"  after="10" type="year" attr="class=yys_dz_select"></m:date><a
        href="javascript:void(0);" class="easyui-linkbutton"
        data-options="iconCls:'brick_delete',plain:true"
        onclick="excel();">导出excel</a>
    </div>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>
<div id="toolbar" style="display: none;">
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>
</div>

<script type="text/javascript">

var dataGrid;
$(function () {
    dataGrid = renderDataGrid('/operator/list_detail_stat');
});
function excel(){
    var url= "/operator/exportexcel.do?year="+$("#execel").find("select[name=year2]").val();
    window.open(url);
}
function renderDataGrid(url) {
    return $('#dataGrid').datagrid({
        url: url,
        fit: true,
        fitColumns: false,
        border: false,
        pagination: true,
        idField: 'desc',
        pageSize: 30,
        pageList: [ 10, 20, 30, 40, 50 ],
        checkOnSelect: false,
        selectOnCheck: false,
        nowrap: false,
        striped: true,
        rownumbers: true,
        singleSelect: true,
        remoteSort: false,
        columns: [
            [
             {
                 field: 'desc',
                 title: '在网时长',
                 width: 100
             },
                {
                    field: 'theoryCentral',
                    title: '理论结算个数（集采）',
                    width: 200
                },
                {
                    field: 'theoryAgency',
                    title: '理论结算个（代销）',
                    width: 200
                },
                {
                    field: 'theorySum',
                    title: '理论结算总数',
                    width: 200
                },
                {
                    field: 'realityCentral',
                    title: '实际结算个数（集采）',
                    width: 200
                    
                },
               
               
                {
                    field: 'realityAgency',
                    title: '实际结算个数（代销）',
                    width: 200
                },
             
                {
                    field: 'realitySum',
                    title: '实际结算总数',
                    width: 200
                },           
                { 
                    field: 'cibnCount',
                    title: '国广结算个数',
                    width: 100
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





function searchFun() {
	dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
}
function cleanFun() {
    $('#searchForm input').val('');
    $('#searchForm select').val('0');
    dataGrid.datagrid('load', {});
}

$(function () {
    
    	var co = new Boss.util.combo({	  url:"/search_name?type=operatorName"})
    	
    	$(co).bind('select',function(eventName,el){
    		$('#oid').val(el.attr('data-id'));
    	});
    
});


</script>
</body>
</html>
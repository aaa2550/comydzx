<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.超级手机}-${internationalConfig.可兑换时间管理}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">

var dataGrid;
$(function () {
    dataGrid = renderDataGrid('/letv_mobile/active');
});

function renderDataGrid(url) {
    return $('#dataGrid').datagrid({
        url: url,
        fit: true,
        fitColumns: false,
        border: false,
        pagination: true,
        idField: 'mac',
        pageSize: 20,
        pageList: [ 20, 40, 50,100 ],
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
                    field: 'uid',
                    title: 'UID',
                    width: 200,
                    sortable: true
                },
                {
                    field: 'mac',
                    title: 'MAC',
                    width: 200,
                    sortable: true
                },
                {
                    field: 'activeTime',
                    title: '${internationalConfig.激活时间}',
                    width: 200
                  
                   
                },
                {
                    field: 'updateTime',
                    title: '${internationalConfig.兑换截止时间}',
                    width: 200
                    
                },
                {
                    field: 'operatorId',
                    title: '${internationalConfig.操作人}',
                    width:200
                    
                },
               
             
                {
                    field: 'action',
                    title: '${internationalConfig.操作}',
                    width: 200,
                    formatter: function (value, row, index) {
                      
                   
                       var     str = $.formatString('<img onclick="editFun(\'{0}\');" src="{1}" title="${internationalConfig.更新激活时间}"/>', row.mac, '/static/style/images/extjs_icons/pencil.png');
                      
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





function editFun(mac) {
  if(window.confirm("${internationalConfig.确定要更新此设备的激活时间吗}？")){
	  
	  $.post("/letv_mobile/update_active",{"mac":mac},function(){
		  
		  parent.$.messager.alert('success',mac+"${internationalConfig.激活时间更新成功}");
	  });
  }
}


function searchFun() {
	if($("input[name=uid]").val()==''){
		$("input[name=uid]").val(0);
	}
	dataGrid.datagrid('load', $.serializeObject($('#searchForm')));

}
function cleanFun() {
    $('#searchForm input').val('');
    dataGrid.datagrid('load', {});
}

</script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
			style="overflow: hidden; height: 145px">
        <form id="searchForm">
            <table class="table-more" style="display: none;">
                <tr>
                    <td>mac：<input class="span2" name="mac"></td>
<td>uid：<input class="span2" name="uid"></td>

                    </tr>
                 
           
             	<tr>
                    <td>${internationalConfig.激活时间}：<input id="begin" name="regTime"
                                    class="easyui-datebox">
                    --<input id="end" name="activeTime"
                                    class="easyui-datebox"></td>
                
                 </tr> 
                 </table>
        </form>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>

<div id="toolbar" style="display: none;">

    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a><a
        href="javascript:void(0);" class="easyui-linkbutton"
        data-options="iconCls:'brick_delete',plain:true"
        onclick="cleanFun();">${internationalConfig.清空条件}</a>
</div>


</body>
</html>
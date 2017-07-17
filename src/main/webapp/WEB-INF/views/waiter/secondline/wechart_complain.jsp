<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.微信投诉订单}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
var dataGrid;

$(function () {
    dataGrid = $('#dataGrid').datagrid({
        url: '${pageContext.request.contextPath}/wechart_complain/data_grid.json',
 
        fit: true,
        fitColumns: true,
        border: false,
        pagination: true,  
        idField: 'id',
        pageSize: 20,
        pageList: [ 10, 20, 30, 40, 50 , 100 ],
        sortName: 'ptime',
        sortOrder: 'desc',
        checkOnSelect: false,
        selectOnCheck: false,
        nowrap: false,
        striped: true,
        rownumbers: true,
        singleSelect: true,
        frozenColumns: [
            [
                {
                    field: 'msgType',
                    title: '${internationalConfig.状态}',
                    width: 150,
                    hidden: true
                }
            ]
        ],
        columns: [
            [
				{
   					 field: 'corderid',
 				      title: '${internationalConfig.订单号}',
  					  width: 240,
                    sortable: true
   				},{
  					 field: 'productname',
				      title: '${internationalConfig.套餐类型}',
 					  width: 240,
                   sortable: true
  				},
                {
                    field: 'reason',
                    title: '${internationalConfig.投诉理由}',
                    width: 240,
                    sortable: true
                },{
                    field: 'solution',
                    title: '${internationalConfig.用户希望解决方案}', 
                    width: 180, 
                    sortable: true
                },
                {
                    field: 'extinfo',
                    title: '${internationalConfig.备注信息}',
                    width: 180,
                    sortable: true
                },
                {
                    field: 'complaintime',
                    title: '${internationalConfig.投诉时间}',
                    width: 220,
                    sortable: true
                },{
                    field: 'feedbackid',
                    title: '${internationalConfig.微信交易号}',
                    width: 220,
                    sortable: true
                },{
                    field: 'msgtype',//request confirm reject
                    title: '${internationalConfig.处理状态}',
                    width: 220,
                    sortable: true,
                    formatter:function (value){
                    	if(value=='request'){
                    		return '${internationalConfig.新增投诉}';
                    	}else if(value=='confirm'){
                    		return '${internationalConfig.已处理}';
                    	}else if(value=='processing'){
                    		return '${internationalConfig.处理中}';
                    	}else{
                    		return '${internationalConfig.处理但未接受}';
                    	}
                    }
                },
                {
                    field: 'openid',
                    title: "${internationalConfig.用户微信}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID",
                    width: 220,
                    sortable: true
                },
                {
                    field: 'action',
                    title: '${internationalConfig.操作}',
                    width: 100,
                    formatter: function (value, row, index) {
                        var str = '&nbsp;&nbsp;&nbsp;';
                        if(row.msgType!='confirm'){
                        	if(row.msgType!='processing'){
                        		str += $.formatString('<a  href="#" onclick="editFun(\'{0}\');" src="{1}" title="${internationalConfig.修改}">${internationalConfig.申请处理完毕}</a>', row.feedbackid, '${pageContext.request.contextPath}/style/images/extjs_icons/bug/bug_edit.png');
                        	}
                    	}
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
});

function editFun(couponCode) {
    
	$.get('${pageContext.request.contextPath}/wechart_complain/updateFeedback.json?feedbackid=' + couponCode, function(result){
		var msg = result.msg;
		parent.$.messager.alert('${internationalConfig.提示}', msg, 'info');
		parent.$.messager.progress('close');
		$('#dataGrid').datagrid('load', $.serializeObject($('#searchForm')));
	  }, 'JSON');
}

function searchFun() {
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
			style="height: 80px; overflow: hidden;">
			<form id="searchForm">
				<table class="table-td-two"
					style="display: none;">
					<tr> 
						<td>${internationalConfig.投诉日期}：<input id="date" name="date"
				 			class="easyui-datebox" ></input></td> 
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
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.过滤条件}</a><a
			href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_delete',plain:true"
			onclick="cleanFun();">${internationalConfig.清空条件}</a>
	</div>    
</body> 
</html>
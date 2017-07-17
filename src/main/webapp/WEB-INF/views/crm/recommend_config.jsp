<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.推荐弹窗设置}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
var dataGrid;
$(function () {
    dataGrid = renderDataGrid('/recommend_config/list.json');
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
                {
                    field: 'id',
                    title: '${internationalConfig.项目编号}',
                    width: 150,
                    hidden: true
                }
            ]
        ],
        columns: [
            [
                {
                    field: 'title',
                    title: '${internationalConfig.项目名称}',
                    width: 200,
                    sortable: true
                },
                {
                    field: 'pname',
                    title: '${internationalConfig.预告片名}',
                    width: 200,
                    sortable: true
                },
                {
                    field: 'pid',
                    title: 'PID',
                    width: 200,
                    sortable: true
                },
                {
                    field: 'weight',
                    title: '${internationalConfig.权重}',
                    width: 50,
                    sortable: true
                },
                {
                    field: 'expireTime',
                    title: '${internationalConfig.过期时间}',
                    width: 160
                    
                },
                {
                    field: 'updateTime',
                    title: '${internationalConfig.更新时间}',
                    width: 160
                    
                },
                {
                    field: 'operater',
                    title: '${internationalConfig.操作人}',
                    width: 100
                    
                },
                {
                    field: 'flag',
                    title: '${internationalConfig.状态}',
                    width: 180,
                    formatter: function (value,row,index) {
                        if (value == 0) {
                            return "${internationalConfig.待准备数据}"
                        } else if(value == 1){
                            return "${internationalConfig.数据准备完毕}";
                        }else if(value == 2){
                        	return "${internationalConfig.已发送短信}("+row.sendSmsCount+")";
                        }
                    }
                    
                },
                {
                    field: 'action',
                    title: '${internationalConfig.操作}',
                    width: 200,
                    formatter: function (value, row, index) {
                        var str = '&nbsp;&nbsp;&nbsp;';
                        str += $.formatString('<img onclick="editFun(\'{0}\');" src="{1}" title="${internationalConfig.修改}"/>', row.id, '/static/style/images/extjs_icons/pencil.png');
                        if(row.flag>=1){
	                        str += '&nbsp;&nbsp;&nbsp;';
	                        str += $.formatString('<img onclick="exportCsv(\'{0}\');" src="{1}" title="${internationalConfig.导出}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>csv"/>', row.id, '/static/style/images/extjs_icons/bug/bug_edit.png');
                        }
                        //str += $.formatString('<a href="${pageContext.request.contextPath}/recommend_config/sendSms.json?configId={0}" title=""> 发送短信</a>', row.id);
                        //str += $.formatString('<a href="${pageContext.request.contextPath}/recommend_config/exportCsv.json?configId={0}" title=""> 导出csv</a>', row.id);
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

function exportCsv(id) {
    if (id == undefined) {
        var rows = dataGrid.datagrid('getSelections');
        id = rows[0].id;
    }
	$.get("/recommend_config/exportCsvBefore.json",{configId:id},function(data){
		if(data.code==0){
		    var url = "/recommend_config/exportCsv.json?configId="+id;
		    location.href = url;
		}else{
			var info=data.msg;
			parent.$.messager.confirm('${internationalConfig.警告}', info, function (b) {
		    });
		}
		
	},"json");
	
	
	
    //location.href = url;
}


function editFun(id) {
	var url="${pageContext.request.contextPath}/recommend_config/addOrUpdate.do";
	var title ='${internationalConfig.添加}'
	if(id){
		url += '?id='+id;
		title = '${internationalConfig.修改}';
	}
    parent.$.modalDialog({
        title: title,
        width: 680,
        height: 650,
        href: url,
        buttons : [ {
			text : title,
			handler : function() {
				parent.$.modalDialog.openner_dataGrid = dataGrid;//因为修改成功之后，需要刷新这个dataGrid，所以先预定义好
                var f = parent.$.modalDialog.handler.find('#form');
                f.submit();
			}
		}

		]
    });
}


function searchFun() {
	dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
  //  renderDataGrid('${pageContext.request.contextPath}/lecard/list.json?' + $('#searchForm').serialize());
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
			style="overflow: hidden; height: 80px">
        <form id="searchForm">
             <table class="table-more" style="display: none;">
             	<tr>
             		<td>${internationalConfig.操作人}：<input id="operater" name="operater" class="span2"></td>
                    <td>${internationalConfig.申请时间}：<input id="begin" name="createTime"
                                    class="easyui-datebox">
                    --<input id="end" name="updateTime"
                                    class="easyui-datebox"></td>
                    <td>${internationalConfig.失效日期}：<input id="end" name="expireTime"
                                    class="easyui-datebox">
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
  <a onclick="editFun();" href="javascript:void(0);"
       class="easyui-linkbutton" data-options="plain:true,iconCls:'bug_add'">${internationalConfig.新增}</a>

    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a><a
        href="javascript:void(0);" class="easyui-linkbutton"
        data-options="iconCls:'brick_delete',plain:true"
        onclick="cleanFun();">${internationalConfig.清空条件}</a>
</div>


</body>
</html>
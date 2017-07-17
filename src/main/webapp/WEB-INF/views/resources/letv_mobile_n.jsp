<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.超级手机}-N&nbsp;${internationalConfig.值管理}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">

var dataGrid;
$(function () {
    dataGrid = renderDataGrid('/letv_mobile/n');
});

function renderDataGrid(url) {
    return $('#dataGrid').datagrid({
        url: url,
        fit: true,
        fitColumns: false,
        border: false,
        pagination: true,
        idField: 'id',
        pageSize: 100,
        pageList: [ 10, 20, 40, 50,100 ],
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
                    title: '${internationalConfig.编号}',
                    width: 150,
                    hidden: true
                }
            ]
        ],
        columns: [
            [
                {
                    field: 'mode',
                    title: '${internationalConfig.型号}',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'flash',
                    title: '${internationalConfig.容量}',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'n',
                    title: 'N',
                    width: 80
                  
                   
                },
                {
                    field: 'operator_id',
                    title: '${internationalConfig.操作人}',
                    width:100
                    
                },
                {
                    field: 'updateTime',
                    title: '${internationalConfig.更新时间}',
                    width: 100
                    
                },
             
                {
                    field: 'action',
                    title: '${internationalConfig.操作}',
                    width: 100,
                    formatter: function (value, row, index) {
                      
                   
                       var     str = $.formatString('<img onclick="editFun(\'{0}\');" src="{1}" title="${internationalConfig.修改}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>N<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.值}"/>', row.id, '/static/style/images/extjs_icons/pencil.png');
                      
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
    parent.$.modalDialog({
        title: '${internationalConfig.修改}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>N<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.值}',
        width: 680,
        height: 500,
        href: '/letv_mobile/n_edit/'+id,
        buttons: [
            {
                text: '${internationalConfig.修改}',
                handler: function () {
                    parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                    var f = parent.$.modalDialog.handler.find('#form');
                    f.submit();
                }
            }
        ]
    });
}





//冻结操作


</script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'center',border:false,title:'${internationalConfig.超级手机}-N<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.值管理列表}'" >
        <table id="dataGrid"></table>
    </div>
</div>
</body>
</html>
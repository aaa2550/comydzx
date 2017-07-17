<%--
  Created by IntelliJ IDEA.
  User: jiangchao3
  Date: 2017/2/6
  Time: 14:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>商户管理</title>
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
    <script type="text/javascript">

        var dataGrid;
        (function($) {
            $.fn.serializeJson = function() {

                var serializeObj = {};
                var array = this.serializeArray();
                $(array).each(function() { // 遍历数组的每个元素 {name : xx , value : xxx}
                    if (serializeObj[this.name]) { // 判断对象中是否已经存在 name，如果存在name
                        serializeObj[this.name] += "," + this.value;
                    } else {
                        serializeObj[this.name] = this.value; // 如果元素name不存在，添加一个属性 name:value
                    }
                });
                return serializeObj;
            }
        })(jQuery)

        $(function() {
            //dataGrid = renderDataGrid('/mini/vendor/list');
            parent.refreshDataGrid = [];
            parent.refreshDataGrid.venderDataGrid = renderDataGrid('/mini/vendor/list');
        });

        function renderDataGrid(url, data, method) {
            return $('#dataGrid')
                    .datagrid(
                            {
                                url : url,
                                fit : true,
                                queryParams : data || "",
                                fitColumns : true,
                                border : false,
                                method : method || 'post',
                                pagination : true,
                                idField : 'id',
                                pageSize : 50,
                                pageList : [ 50, 100 ],
                                sortName : 'pk_agg_package',
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
                                    width : 10,
                                    hidden : true
                                } ] ],
                                columns : [ [
                                    {
                                        field : 'vendorNo',
                                        title : '商户编码',
                                        width : 50,
                                        sortable : false,
                                    },
                                    {
                                        field : 'name',
                                        title : '商户名称',
                                        width : 100,
                                        sortable : false
                                    },
                                    {
                                        field : 'createUser',
                                        title : '创建人',
                                        width : 80,
                                        sortable : false
                                    },
                                    {
                                        field : 'modifyTime',
                                        title : '最后修改时间',
                                        width : 80,
                                        sortable : false
                                    },
                                    {
                                        field : 'action',
                                        title : '${internationalConfig.操作}',
                                        width : 40,
                                        formatter : function(val, row, index) {
                                            var str = '';
                                            str += $.formatString('<a href="javascript:;" onclick="editFun(\'{0}\');">${internationalConfig.编辑}</a>',
                                                    row.id);
                                            /*str += $.formatString('<img onclick="editFun(\'{0}\');" src="{1}" title="${internationalConfig.编辑}"/>',
                                                    row.id, '/static/style/images/extjs_icons/bug/bug_edit.png');*/
                                            /*str += '&nbsp;';
                                            str += $.formatString('<img onclick="deleteFun(\'{0}\');" src="{1}" title="${internationalConfig.删除}"/>',
                                                    row.id, '/static/style/images/extjs_icons/cancel.png');*/


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
                var rows = parent.refreshDataGrid.venderDataGrid.datagrid('getSelections');
                id = rows[0].id;
            }
            parent.iframeTab.init({url:'/mini/vendor/toEdit?id='+id,text:'编辑商戶'});
        }

        function addFun(id) {
            parent.iframeTab.init({url:'/mini/vendor/toAdd',text:'新增商戶'});
        }

        function searchFun() {
            parent.$.messager.progress({
                title : '${internationalConfig.提示}',
                text : '${internationalConfig.数据处理中}....'
            });
            renderDataGrid('/mini/vendor/search?', $('#searchForm').serializeJson(), "get");
            parent.$.messager.progress('close');
        }

        function cleanFun() {
            $('#searchForm input').val('');
            renderDataGrid('/mini/vendor/search');
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit:true, border:false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'">
        <form id="searchForm">
            <table  width="500" cellspacing="5" class="table-more">
                <tr>
                    <td>商户名称：<input name="name" class="span2" /></td>
                </tr>
            </table>
        </form>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>

<div id="toolbar" style="display: none;">
    <a href="javascript:void(0);" class="easyui-linkbutton" onclick="addFun(0);"
       data-options="plain:true,iconCls:'pencil_add'">增加</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" onclick="searchFun();"
       data-options="iconCls:'brick_add',plain:true">${internationalConfig.查询}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" onclick="cleanFun();"
       data-options="iconCls:'brick_delete',plain:true">${internationalConfig.清空条件}</a>

</div>
</body>
</html>

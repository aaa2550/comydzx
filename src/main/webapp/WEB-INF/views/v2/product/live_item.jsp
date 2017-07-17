<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <title>${internationalConfig.直播频道管理}</title>
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
    <script type="text/javascript">
        var dataGrid;
        (function($){
            $.fn.serializeJson=function(){
                var serializeObj={};
                var array=this.serializeArray();
                $(array).each(function(){ // 遍历数组的每个元素 {name : xx , value : xxx}
                    if(serializeObj[this.name]){ // 判断对象中是否已经存在 name，如果存在name
                        serializeObj[this.name]+=","+this.value;
                    }else{
                        serializeObj[this.name]=this.value; // 如果元素name不存在，添加一个属性 name:value
                    }
                });
                return serializeObj;
            }
        })(jQuery)
        $(function() {
            dataGrid = renderDataGrid('/v2/product/liveItem/dataGrid');
        });

        function renderDataGrid(url) {
            return $('#dataGrid')
                    .datagrid(
                    {
                        url : url,
                        fit : true,
                        fitColumns : true,
                        border : false,
                        pagination : true,

                        idField : 'id',
                        pageSize : 30,
                        pageList : [ 10, 20, 30, 40, 50 ],
                        sortName : 'id',
                        sortOrder : 'asc',
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
                        columns : [ [
                            {
                                field : 'id',
                                title : 'ID',
                                width : 120,
                                sortable : true
                            },
                            {
                                field : 'description',
                                title : '${internationalConfig.频道名称}',
                                width : 120,
                                sortable : true
                            },
                            {
                                field : 'action',
                                title : '${internationalConfig.操作}',
                                width : 100,
                                formatter : function(value, row, index) {
                                    var str = '';

                                    str += $
                                            .formatString(
                                            '<img onclick="editFun(\'{0}\',\'{1}\',\'{2}\');" src="{3}" title="${internationalConfig.编辑}"/>',
                                            row.id,row.pid,row.description,
                                            '/static/style/images/extjs_icons/bug/bug_edit.png');
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

        function editFun(id,pid,description) {
      
            if (id == undefined) {
                var rows = dataGrid.datagrid('getSelections');
                id = rows[0].id;
            }

            parent.$.modalDialog({
                title : '${internationalConfig.编辑赛事}',
                width : 720,
                height : 300,
                href : '/v2/product/liveItem/edit?cid=' + id + "&name=" + encodeURIComponent(description),
                buttons : [ {
                    text : '${internationalConfig.保存}',
                    handler : function() {
                        parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#form');
                        f.submit();
                    }
                } , {
                    text : "${internationalConfig.取消}",
                    handler : function() {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                } ]
            });
        }

    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.直播频道管理}',border:false,height:'auto'">
        <form id="searchForm">
            <%--<table class="table-td-four">
               <tr>
                    <td>${internationalConfig.频道}：<select class="span2" name="itemId" id="itemId">
                        <option value=""> ${internationalConfig.全部}</option>
                        <c:forEach items="${directList}" var="item">
                            <option value="${item.id}">${internationalConfig[item.description]}</option>
                        </c:forEach>
                    </select></td>
                </tr>
            </table>--%>
        </form>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>
<div id="toolbar" style="display: none;">
    <%--<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">${internationalConfig.清空条件}</a>--%>
</div>

</body>
</html>
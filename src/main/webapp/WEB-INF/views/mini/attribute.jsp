<%--
  Created by IntelliJ IDEA.
  User: jiangchao3
  Date: 2017/2/6
  Time: 14:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<html>
<head>
    <title>属性管理</title>
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
            dataGrid = renderDataGrid('/mini/attribute/dataGrid');
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
                                    width : 10,
                                    hidden : true
                                } ] ],
                                columns : [ [
                                    {
                                        field : 'id',
                                        title : '属性ID',
                                        width : 30,
                                        sortable : false
                                    },
                                    {
                                        field : 'name',
                                        title : '${internationalConfig.属性名称}',
                                        width : 100,
                                        sortable : false
                                    },
                                    {
                                        field : 'showName',
                                        title : '${internationalConfig.显示名称}',
                                        width : 100,
                                        sortable : false
                                    },
                                    {
                                        field : 'items',
                                        title : '可选项',
                                        width : 180,
                                        sortable : false,
                                        formatter : function(val, row, index) {
                                            var str = "";
                                            for(var i in val){
                                                str +=$.formatString('<a style="margin-right: 5px;text-decoration:underline" href="javascript:;" onclick="editItem(\'{0}\',\'{2}\')">{1}</a>',val[i].id,val[i].attributeItem,row.id);
                                            }
                                            str +=  $.formatString('<button style="height: 14px;width:14px;line-height: 10px;border-radius: 3px;border: 1px solid #999;" onclick="addItem(\'{0}\')">+</button>',row.id);
                                            return str;
                                        }
                                    },
                                    {
                                        field : 'createUser',
                                        title : '${internationalConfig.创建人}',
                                        width : 80,
                                        sortable : false
                                    },
                                    {
                                        field : 'modifyTime',
                                        title : '${internationalConfig.最后修改时间}',
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
                                            str += '&nbsp;&nbsp;';
                                            str += $.formatString('<a href="javascript:;" onclick="deleteFun(\'{0}\');">${internationalConfig.删除}</a>',
                                                    row.id);


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
                var rows = dataGrid.datagrid('getSelections');
                id = rows[0].id;
            }

            parent.$.modalDialog({
                title : '编辑属性',
                width : 650,
                height : 190,
                href : '/mini/attribute/edit?id='+id,
                onClose : function() {
                    this.parentNode.removeChild(this);
                },
                buttons : [ {
                    text : '${internationalConfig.保存}',
                    handler : function() {
                        parent.$.modalDialog.openner_dataGrid = dataGrid; // 因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#form');
                        submitFun(f, 2,"/mini/attribute/save");
                    }
                }, {
                    text : "${internationalConfig.取消}",
                    handler : function() {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                } ]
            });
        }
        function deleteFun(id) {
            if (id == undefined) {
                var rows = dataGrid.datagrid('getSelections');
                id = rows[0].id;
            }
            parent.$.messager.confirm('${internationalConfig.询问}', '是否确认删除当前属性？',
                    function(b) {
                        if (b) {
                            parent.$.messager.progress({
                                title : '${internationalConfig.提示}',
                                text : '${internationalConfig.数据处理中}....'
                            });
                            $.post(
                                    '${pageContext.request.contextPath}/mini/attribute/delete',
                                    {
                                        id : id
                                    },
                                    function(result) {
                                        if (result.code == 0) {
                                            parent.$.messager
                                                    .alert(
                                                            '${internationalConfig.提示}',
                                                            '${internationalConfig.删除成功}',
                                                            'info');
                                            dataGrid
                                                    .datagrid('reload');
                                        } else {
                                            parent.$.messager.alert('${internationalConfig.错误}', '该属性已关联相关品类，不允许删除。', 'error');
                                        }
                                        parent.$.messager
                                                .progress('close');
                                    }, 'JSON');
                        }
                    });
        }
        function addFun(id) {
            parent.$.modalDialog({
                title : '添加属性',
                width : 650,
                height : 190,
                href : '/mini/attribute/edit',
                onClose : function() {
                    this.parentNode.removeChild(this);
                },
                buttons : [ {
                    text : '${internationalConfig.保存}',
                    handler : function() {
                        parent.$.modalDialog.openner_dataGrid = dataGrid; // 因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#form');
                        submitFun(f, 1,"/mini/attribute/save");
                    }
                }, {
                    text : "${internationalConfig.取消}",
                    handler : function() {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                } ]
            });
        }


         /*新建属性值*/
        function addItem(id) {
            parent.$.modalDialog({
                title : '添加属性值',
                width : 650,
                height : 190,
                href : '/mini/attribute/item_edit?attributeId='+id,
                onClose : function() {
                    this.parentNode.removeChild(this);
                },
                buttons : [ {
                    text : '${internationalConfig.保存}',
                    handler : function() {
                        parent.$.modalDialog.openner_dataGrid = dataGrid; // 因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#form');
                        submitFun(f, 1,"/mini/attribute/item_save");
                    }
                }, {
                    text : "${internationalConfig.取消}",
                    handler : function() {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                } ]
            });
        }
        function editItem(id,attributeId) {
            parent.$.modalDialog({
                title : '编辑属性值',
                width : 650,
                height : 190,
                href : '/mini/attribute/item_edit?id='+id+'&attributeId='+attributeId,
                onClose : function() {
                    this.parentNode.removeChild(this);
                },
                buttons : [ {
                    text : '${internationalConfig.保存}',
                    handler : function() {
                        parent.$.modalDialog.openner_dataGrid = dataGrid; // 因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#form');
                        submitFun(f, 2,"/mini/attribute/item_save");
                    }
                }, {
                    text : "${internationalConfig.取消}",
                    handler : function() {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                } , {
                    text : "${internationalConfig.删除}",
                    handler : function() {
                        parent.$.messager.confirm('${internationalConfig.询问}', '是否确认删除当前属性值？',
                                function(b) {
                                    if (b) {
                                        parent.$.messager.progress({
                                            title : '${internationalConfig.提示}',
                                            text : '${internationalConfig.数据处理中}....'
                                        });
                                        $.post(
                                                '${pageContext.request.contextPath}/mini/attribute/item_delete',
                                                {
                                                    id : id
                                                },
                                                function(result) {
                                                    if (result.code == 0) {
                                                        parent.$.modalDialog.handler.dialog('close');
                                                        parent.$.messager.alert('${internationalConfig.提示}','${internationalConfig.删除成功}','info');
                                                        dataGrid.datagrid('reload');
                                                    } else {
                                                        parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
                                                    }
                                                    parent.$.messager.progress('close');
                                                }, 'JSON');
                                    }
                                });
                    }
                } ]
            });
        }
        function submitFun(f, type,url) {
            if (f.form("validate")) {
                parent.$.messager.progress({
                    title : '${internationalConfig.提示}',
                    text : '${internationalConfig.数据处理中}....'
                });

                var successStr;
                if(type == 1){
                    successStr = "${internationalConfig.添加成功}";
                }else if(type == 2){
                    successStr = "${internationalConfig.修改成功}";
                }
                $.ajax({
                    url : url,
                    type : "post",
                    data : f.serializeJson(),
                    dataType : "json",
                    success : function(result) {
                        parent.$.messager.progress('close');
                        if (result.code == 0) {
                            parent.$.messager.alert('${internationalConfig.成功}', successStr, 'success');
                            parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                            parent.$.modalDialog.handler.dialog('close');
                        } else {
                            parent.$.messager.alert('${internationalConfig.错误}', '<div style="word-break:break-all;">'+result.msg+'</div>', 'error');
                        }
                    },

                    error : function() {}
                })
            }
        }

        function searchFun() {
            parent.$.messager.progress({
                title : '${internationalConfig.提示}',
                text : '${internationalConfig.数据处理中}....'
            });
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
            //renderDataGrid('/mini/attribute/dataGrid?', $('#searchForm').serializeJson(), "get");
            parent.$.messager.progress('close');
        }

        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
            //renderDataGrid('/mini/attribute/dataGrid');
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit:true, border:false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'">
        <form id="searchForm">
            <table  width="500" cellspacing="5" class="table-more">
                <tr>
                    <td width="100">${internationalConfig.属性名称}：<input name="name" class="span2" /></td>
                    <td width="100">${internationalConfig.显示名称}：<input name="showName" class="span2" /></td>
                    <td width="150"></td>
                    <td width="150"></td>
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
       data-options="plain:true,iconCls:'pencil_add'">${internationalConfig.增加}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" onclick="searchFun();"
       data-options="iconCls:'brick_add',plain:true">${internationalConfig.查询}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" onclick="cleanFun();"
       data-options="iconCls:'brick_delete',plain:true">${internationalConfig.清空条件}</a>

</div>
</body>
</html>

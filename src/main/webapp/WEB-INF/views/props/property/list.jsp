<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>道具属性管理</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <style type="text/css">
        a.propsOperation:link, a.propsOperation:visited {
            border-right: 1px solid grey;
            padding-right: 5px;
            padding-left: 5px;
            text-decoration: none;
            color: black;
        }
        a.propsOperation:hover{
            color: #8888FF;
            text-decoration: underline;
        }
        img.configImg {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            border: 1px solid #CCCCCC;
        }
    </style>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            dataGrid = renderDataGrid('/props/property/query');
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
                pageList: [10, 20, 30, 40, 50],
                sortName: 'no',
                sortOrder: 'asc',
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                striped: true,
                rownumbers: true,
                singleSelect: false,
                remoteSort: false,
                columns: [
                    [
                        {
                            field: 'id',
                            title: 'ID',
                            width: 60
                        },
                        {
                            field: 'name',
                            title: '属性名称',
                            width: 100
                        },
                        {
                            field: 'isDefault',
                            title: '是否默认选中',
                            width: 100,
                            formatter: function (value) {
                                var html = "";
                                if (value==1) {
                                    html += "是";
                                } else {
                                    html += "否";
                                }
                                return html;
                            }
                        },
                        {
                            field: 'no',
                            title: '排序',
                            width: 100
                        },
                        {
                            field: 'action',
                            title: '操作',
                            width: 200,
                            formatter: function (value, row, index) {
                                return $.formatString("<a href='javascript:void(0);' onclick='editProperty({0}, \"{1}\")' class='propsOperation'>修改</a>", row.id, '修改属性');
                                /*if (row.isDefault==1) {
                                    return $.formatString("<a href='javascript:void(0);' onclick='editProperty({0}, \"{1}\")' class='propsOperation'>修改</a>", row.id, '修改属性');
                                } else {
                                    var str = $.formatString("<a href='javascript:void(0);' onclick='setDefault({0})' class='propsOperation'>设为默认</a>", row.id);
                                    str += $.formatString("<a href='javascript:void(0);' onclick='editProperty({0}, \"{1}\")' class='propsOperation'>修改</a>", row.id, '修改属性');
                                    str += $.formatString("<a href='javascript:void(0);' onclick='delProperty({0})' class='propsOperation'>删除</a>", row.id);
                                    return str;

                                }*/
                            }
                        }
                    ]
                ],
                toolbar: '#toolbar',
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

        /**
         * 添加修改属性
         */
        function editProperty(id, title) {
            parent.$.modalDialog({
                title: title,
                width: 400,
                height: 300,
                href: '${pageContext.request.contextPath}/props/property/edit?id='+id,
                buttons: [
                    {
                        text: '保存',
                        handler: function () {
                            parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                            var f = parent.$.modalDialog.handler.find('#form');
                            f.submit();
                        }
                    },
                    {
                        text: '取消',
                        handler: function () {
                            parent.$.modalDialog.handler.dialog('close');
                        }
                    }
                ]
            });
        }

        /**
         * 设置默认
         */
        function setDefault(id){
            $.messager.confirm("询问", "确认设置默认吗？", function(b){
                if(!b) return;
                $.post('/props/property/setDefault', {id: id},
                        function(json){
                            if(json.code == 0){
                                $.messager.alert("设置默认", "设置默认成功！");
                                dataGrid.datagrid('load', {});
                            } else {
                                $.messager.alert("设置默认", "设置默认失败！");
                            }
                        }, "json"
                );
            });
        }

        /**
         * 删除
         */
        function delProperty(id){
            $.messager.confirm("询问", "确认删除道具属性吗？", function(b){
                if(!b) return;
                $.post('/props/property/delete', {id: id},
                        function(json){
                            if(json.code == 0){
                                $.messager.alert("删除道具属性", "删除道具属性成功！");
                                dataGrid.datagrid('load', {});
                            } else {
                                $.messager.alert("删除道具属性", json.msg);
                            }
                        }, "json"
                );
            });
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <%--<div data-options="region:'north',title:'查询条件',border:false" style="overflow: hidden; height: 145px">
        <form id="searchForm">
            <table class="table-more">
                <tr>
                    <td>
                        添加时间：
                        <input class="easyui-datebox" name="startTime" style="width: 150px">&nbsp;&nbsp;
                        <input class="easyui-datebox" name="endTime" style="width: 150px">
                    </td>

                    <td>&nbsp;&nbsp;&nbsp;&nbsp;业务线：<%@ include file="/WEB-INF/views/inc/props_business.inc" %>
                    </td>
                    <td>
                        是否推荐：
                        <select name="attributeConfig" class="span2">
                            <option value="0" selected="selected">全部</option>
                            <option value="1">推荐</option>
                            <option value="2">未推荐</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>
                        道具名称：<input name="codeName" style="width: 310px" class="span2">
                    </td>
                    <td>
                        道具状态：
                        <select name="flag" class="span2">
                            <option value="0">全部</option>
                            <option value="1">上线中</option>
                            <option value="2">已下线</option>
                        </select>
                    </td>
                </tr>
            </table>
        </form>
    </div>--%>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>
<div id="toolbar" style="display: none;">
    <a onclick="editProperty(0, '添加属性');" href="javascript:void(0);"
       class="easyui-linkbutton" data-options="plain:true,iconCls:'pencil_add'">添加属性</a>
</div>


</body>
</html>
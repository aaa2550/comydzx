<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>道具库管理</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script  src="/js/kv/propsBusiness.js"></script>
    <script  src="/js/kv/propsChannel.js"></script>
    <script  src="/js/kv/propsType.js"></script>
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
            dataGrid = renderDataGrid('/props/query');

            init();
        });

        function init() {
            $("[name='businessId']").trigger("change");
        }

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
                sortName: 'updateTime',
                sortOrder: 'desc',
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
                            title: '道具ID',
                            width: 60,
                            sortable: true
                        },
                        {
                            field: 'codeName',
                            title: '道具名称',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'name',
                            title: '显示名称',
                            width: 100
                        },
                        {
                            field: 'businessId',
                            title: '业务线',
                            width: 100,
                            formatter: function (value) {
                                return Dict.propsBusiness[value];
                            }
                        },
                        {
                            field: 'channelId',
                            title: '渠道',
                            width: 100,
                            formatter: function (value) {
                                if (Dict.propsChannel[value]) {
                                    return Dict.propsChannel[value].name;
                                }
                                return "无";
                            }
                        },
                        {
                            field: 'typeId',
                            title: '分类',
                            width: 100,
                            formatter: function (value) {
                                if (value > 0) {
                                    if (Dict.propsType[value]) {
                                        return Dict.propsType[value].name;
                                    }
                                }
                                return "无";
                            }
                        },
                        {
                            field: 'mobilePic',
                            title: '移动端',
                            width: 100,
                            formatter: function (value, row, index) {
                                var html = "";
                                if (value) {
                                    html += "<img class='configImg' src='"+value+"' >";
                                } else {
                                    html += "无";
                                }
                                return html;
                            }
                        },
                        {
                            field: 'webPic',
                            title: 'PC端',
                            width: 100,
                            formatter: function (value, row, index) {
                                var html = "";
                                if (value) {
                                    html += "<img class='configImg' src='"+value+"' >";
                                } else {
                                    html += "无";
                                }
                                return html;
                            }
                        },
                        {
                            field: 'tvPic',
                            title: 'TV端',
                            width: 100,
                            formatter: function (value, row, index) {
                                var html = "";
                                if (value) {
                                    html += "<img class='configImg' src='"+value+"' >";
                                } else {
                                    html += "无";
                                }
                                return html;
                            }
                        },
                        {
                            field: 'price',
                            title: '单价',
                            width: 80
                        },
                        /*{
                            field: 'isPublic',
                            title: '是否推荐',
                            width: 80,
                            formatter: function(value){
                                if(value){
                                    return "已推荐";
                                } else {
                                    return "未推荐"
                                }
                            }
                        },*/
                        {
                            field: 'flag',
                            title: '道具状态',
                            width: 100,
                            formatter: function (value) {
                                if(value == 1){
                                    return "上线中";
                                } else {
                                    return "已下线";
                                }
                            }
                        },
                        {
                            field: 'updateTime',
                            title: '添加时间',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'action',
                            title: '操作',
                            width: 200,
                            formatter: function (value, row, index) {
                                var str = $.formatString("<a href='javascript:void(0);' onclick='editProps({0})' class='propsOperation'>修改</a>", row.id);
                                str += $.formatString("<a href='javascript:void(0);' onclick='changeFlag({0}, {1});' class='propsOperation'>" + (row.flag==1?'下线':'上线') + "</a>", row.id, row.flag);
                                return str;
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
         * 添加道具功能
         */
        function addProps() {
            parent.$.modalDialog({
                title: '添加道具',
                width: 750,
                height: 500,
                href: '${pageContext.request.contextPath}/props/props_edit',
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
         * 修改道具功能
         */
        function editProps(id) {
            parent.$.modalDialog({
                title: '修改道具',
                width: 900,
                height: 500,
                href: '${pageContext.request.contextPath}/props/props_edit?id='+id,
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

        function searchFun() {
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
            //  renderDataGrid('${pageContext.request.contextPath}/lecard/list.json?' + $('#searchForm').serialize());
        }
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }

        //改变道具的线上线下状态
        function changeFlag(id, flag){
            //console.log("id: "+id+", flag: "+flag);
            $.messager.confirm("询问", "确认"+(flag==1?'下线':'上线')+"此道具吗？", function(b){
                if(!b) return;
                $.post('/props/props_change_flag', {id: id, flag: flag},
                    function(json){
                        if(json.code == 0){
                            dataGrid.datagrid('load', {});
                        }
                    }, "json"
                );
            });
        }

    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false" style="overflow: hidden; height: 145px">
        <form id="searchForm">
            <table class="table-more">
                <tr>
                    <td>
                        添加时间：
                        <input class="easyui-datebox" name="startTime" style="width: 150px">&nbsp;&nbsp;
                        <input class="easyui-datebox" name="endTime" style="width: 150px">
                    </td>

                    <td>
                        &nbsp;&nbsp;&nbsp;&nbsp;业务线：<%@ include file="/WEB-INF/views/inc/props_business.inc" %>
                        &nbsp;&nbsp;&nbsp;&nbsp;<%@ include file="/WEB-INF/views/inc/props_channel.inc" %>
                    </td>
                    <%--<td>
                        是否推荐：
                        <select name="attributeConfig" class="span2">
                            <option value="0" selected="selected">全部</option>
                            <option value="1">推荐</option>
                            <option value="2">未推荐</option>
                        </select>
                    </td>--%>
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
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>
<div id="toolbar" style="display: none;">
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a><a
        href="javascript:void(0);" class="easyui-linkbutton"
        data-options="iconCls:'brick_delete',plain:true"
        onclick="cleanFun();">清空条件</a>
    <a onclick="addProps();" href="javascript:void(0);"
       class="easyui-linkbutton" data-options="plain:true,iconCls:'pencil_add'">添加道具</a>
</div>


</body>
</html>
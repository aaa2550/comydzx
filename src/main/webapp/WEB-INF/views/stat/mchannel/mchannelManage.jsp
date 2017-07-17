<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>渠道管理</title>
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/mobileChannel/mchannel/dataGrid');
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
                pageList: [ 50, 100 ],
                sortName: 'createTime',
                sortOrder: 'desc',
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
                            field: 'actCodeName',
                            title: '动作码',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'actPageid',
                            title: 'pageid',
                            width: 80,
                        },
                        {
                            field: 'actFl',
                            title: 'fl',
                            width: 80,
                        },
                        {
                            field: 'fragid',
                            title: 'fragid',
                            width: 80,
                            sortable: true
                        },
                        {
                            field: 'name',
                            title: 'name',
                            width: 200,
                        },
                        {
                            field: 'actWz',
                            title: 'wz',
                            width: 80,
                            sortable: true
                        },
                        {
						    field: 'channelName',
						    title: '功能项名称',
						    width: 200,
						    sortable: true
						},
                        {
                            field: 'createTime',
                            title: '创建时间',
                            width: 150,
                            sortable: true
                        },
                        {
                            field: 'updateTime',
                            title: '更新时间',
                            width: 150,
                            sortable: true
                        },
                        
                        /* {
                            field: 'author',
                            title: '创建人',
                            width: 100,
                        }, */
                        {
                            field: 'action',
                            title: '操作',
                            width: 80,
                            formatter: function (value, row, index) {
                                var str = '&nbsp;&nbsp;&nbsp;';
                                str += $.formatString('<img onclick="editFun(\'{0}\');" src="{1}" title="编辑"/>', row.id, '/static/style/images/extjs_icons/pencil.png');
                                str += '&nbsp;&nbsp;&nbsp;';
                                 
                                str += $.formatString('<img onclick="deleteFun(\'{0}\');" src="{1}" title="删除"/>', row.id, '/static/style/images/extjs_icons/cancel.png');
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

        function addFun() {
            parent.$.modalDialog({
                title: '创建渠道',
                width: 680,
                height: 300,
                href: '${pageContext.request.contextPath}/tj/mobileChannel/mchannel/add',
                buttons: [
                    {
                        text: '添加',
                        handler: function () {
                            parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                            var f = parent.$.modalDialog.handler.find('#form');
                            f.submit();
                        }
                    },
                    {
                        text: "关闭",
                        handler: function () {
                            parent.$.modalDialog.handler.dialog('close');
                        }
                    }
                ]
            });
        }

        function editFun(channelId) {
            parent.$.modalDialog({
                title: '更新渠道',
                width: 680,
                height: 300,
                href: '${pageContext.request.contextPath}/tj/mobileChannel/mchannel/edit?id=' + channelId,
                buttons: [
                    {
                        text: '更新',
                        handler: function () {
                            parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                            var f = parent.$.modalDialog.handler.find('#form');
                            f.submit();
                        }
                    },
                    {
                        text: "关闭",
                        handler: function () {
                            parent.$.modalDialog.handler.dialog('close');
                        }
                    }
                ]
            });
        }
        function deleteFun(channelId) {
        	 parent.$.messager.confirm('询问', '您是否要删除此信息？', function(b) {
     			if (b) {
     				parent.$.messager.progress({
     						title : '提示',
     						text : '数据处理中，请稍后....'
     				});
     				$.post('${pageContext.request.contextPath}/tj/mobileChannel/mchannel/delete', {
     						id : channelId
     					}, function(result) {
     						if (result.status == 0) {
     							parent.$.messager.alert('提示', result.message, 'info');
     							dataGrid.datagrid('reload');
     						}
     						parent.$.messager.progress('close');
     				}, 'JSON');
     			}
     		});
        }

        function searchFun() {
        	renderDataGrid('${pageContext.request.contextPath}/tj/mobileChannel/mchannel/dataGrid');
        }
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }
		
        
		
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>
<div id="toolbar" style="display: none;">
    <a onclick="addFun();" href="javascript:void(0);"
       class="easyui-linkbutton" data-options="plain:true,iconCls:'pencil_add'">创建渠道</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">刷新</a>
</div>

</body>
</html>
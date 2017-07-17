<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
    <title>${internationalConfig.专机设备上传}</title>
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
    <style>
        .table-td-more tr td{
            width:20%;
        }
    </style>
    <script type="text/javascript">
        var dataGrid;
        $(function() {
            dataGrid = $('#dataGrid')
                    .datagrid(
                    {
                        url : '/device/special_phone_list.json',
                        fit : true,
                        fitColumns : true,
                        border : false,
                        pagination : true,
                        idField : 'id',
                        pageSize : 50,
                        pageList : [ 20, 50, 100, 1000 ],
                        checkOnSelect : false,
                        selectOnCheck : false,
                        nowrap : false,
                        striped : true,
                        rownumbers : true,
                        singleSelect : true,
                        frozenColumns : [ [ {
                            field : 'id',
                            title : '${internationalConfig.编号}',
                            width : 80,
                            hidden : true
                        } ] ],
                        columns : [ [ {
                            field : 'pid',
                            title : '${internationalConfig.PID码}',
                            width : 50

                        }, {
                            field : 'pName',
                            title : '${internationalConfig.影片名称}',
                            width : 50

                        }, {
                            field : 'count',
                            title : '${internationalConfig.设备数量}',
                            width : 50

                        }, {
                            field : 'status',
                            title : '${internationalConfig.状态}',
                            width : 50,
                            formatter: function (value) {
                                if(value == 0){
                                    return "${internationalConfig.下线}";
                                }else if(value == 1){
                                    return "${internationalConfig.上线}";
                                }
                            }

                        }, {
                            field: 'action',
                            title: '${internationalConfig.操作}',
                            width: 20,
                            formatter: function (value, row, index) {
                                var str = $.formatString('<img onclick="updateActive(\'{0}\',{2});" src="{1}" title="${internationalConfig.修改设备状态}"/>', row.pid, '/static/style/images/extjs_icons/pencil.png',row.status);
                                return str;
                            }
                        }

                        ] ],
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
        });

        function searchFun() {
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }
        function uploadDevice() {
            parent.$.modalDialog({
                title: '${internationalConfig.上传设备信息}',
                width: 520,
                height: 250,
                href: '/device/upload_phone_info',
                buttons: [
                    {
                        text: '${internationalConfig.确认上传}',
                        handler: function () {
                            parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                            var f = parent.$.modalDialog.handler.find('#form');
                            f.submit();
                        }
                    },{
                        text : "${internationalConfig.取消}",
                        handler : function() {
                            parent.$.modalDialog.handler.dialog('close');
                        }
                    }
                ]
            });
        }

        function updateActive(pid, status) {
            if(status == 0){
                status = 1;
            }else if(status == 1){
                status = 0;
            }
            parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.确定要更改}' + pid + '${internationalConfig.设备状态吗}？', function (b) {
                if (b) {
                    parent.$.messager.progress({
                        title: '${internationalConfig.提示}',
                        text: '${internationalConfig.数据处理中请稍后}....'
                    });
                    $.post('/device/change_status',{"pid":pid,"status":status}, function (result) {
                        result = $.parseJSON(result);
                        if(result.code == 0){
                            parent.$.messager.alert('${internationalConfig.提示信息}',pid+"${internationalConfig.设备状态更改成功}");
                            dataGrid.datagrid('reload', $.serializeObject($('#searchForm')));
                        }else{
                            parent.$.messager.alert('${internationalConfig.提示信息}',pid+"${internationalConfig.设备状态更改失败}");
                        }
                    });
                }
            });
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
         style="height: 80px; overflow: hidden;">
        <form id="searchForm">
            <table class="table-td-more table-more"  style="display: none;">
                <tr>
                    <td>
                        PID：<input id="pid" name="pid" class="span2"/>
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
    <a onclick="uploadDevice();" href="javascript:void(0);"
       class="easyui-linkbutton" data-options="plain:true,iconCls:'bug_add'">${internationalConfig.上传设备信息}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a><a
        href="javascript:void(0);" class="easyui-linkbutton"
        data-options="iconCls:'brick_delete',plain:true"
        onclick="cleanFun();">${internationalConfig.清除条件}</a>
</div>
</body>
</html>
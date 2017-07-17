<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>${internationalConfig.测试}${internationalConfig.用户管理}</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js"
            type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>
    <script type="text/javascript">
        /**
         * 待绑定行数据
         */
        var rows;

        var dataGrid;
        $(function () {
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/vipController/userTest/dataGrid');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').datagrid({
                url: url,
                fit: true,
                fitColumns: false,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 20,
                pageList: [20, 40, 60, 80, 100],
                //sortName: 'create_time',
                //sortOrder: 'desc',
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                striped: true,
                rownumbers: true,
                singleSelect: true,
                remoteSort: false,
                frozenColumns: [
                    []
                ],
                queryParams: $.serializeObject($('#searchForm')),
                columns: [
                    [
                        {
                            field: 'userId',
                            title: '${internationalConfig.用户}ID',
                            width: 80
                        },
                        {
                            field: 'userName',
                            title: '${internationalConfig.用户名}',
                            width: 120
                        },
                        {
                            field: 'phone',
                            title: '${internationalConfig.电话号码}',
                            width: 100
                        },
                        {
                            field: 'email',
                            title: '${internationalConfig.邮箱}',
                            width: 140
                        },
                        {
                            field: 'status',
                            title: '${internationalConfig.状态}',
                            width: 60,
                            sortable: true,
                            formatter: function (value, row, index) {
                                return value == 1 ? "${internationalConfig.启用}" : "${internationalConfig.停用}";
                            }
                        },
                        {
                            field: 'creatorName',
                            title: '${internationalConfig.创建人}',
                            width: 80
                        },
                        {
                            field: 'createTime',
                            title: '${internationalConfig.创建时间}',
                            width: 140
                        },
                        {
                            field: 'updaterName',
                            title: '${internationalConfig.更新}${internationalConfig.人}',
                            width: 80
                        },
                        {
                            field: 'updateTime',
                            title: '${internationalConfig.更新时间}',
                            width: 140
                        },
                        {
                            field: 'description',
                            title: '${internationalConfig.描述}',
                            width: 80
                        },
                        {
                            field: 'operation',
                            title: '${internationalConfig.操作}',
                            exportFalse: true,
                            width: 100,
                            formatter: function (value, row, index) {
                                var str = '<a href="javascript:void(0)" onclick="edit(' + row.id + ')">${internationalConfig.编辑}</a>';
                                str += '&nbsp;<a href="javascript:void(0)" onclick="updateStatus(' + row.id + ',' + (1 - row.status) + ')">' + (row.status == 1 ? "${internationalConfig.停用}" : "${internationalConfig.启用}") + '</a>';
                                return str;
                            }
                        }
                    ]
                ],
                toolbar: '#toolbar',
                onLoadSuccess: function (data) {
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

        function searchFun() {
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }

        function cleanFun() {
            $('#userId, #userName').textbox('setValue', '');
            $('select[name=status]').val('');
            dataGrid.datagrid('load', {});
        }

        $(function () {
            parent.$.messager.progress('close');
        });

        function exportExcel() {
            var fields = new Array();
            var options = $('#dataGrid').datagrid('options');
            var columns = options.columns[0];
            for (var i = 0; i < columns.length; i++) {
                if (!columns[i].hidden && !columns[i].exportFalse) {
                    var title = columns[i].title;
                    var field = columns[i].field;
                    var obj = new Object();
                    obj.title = title;
                    obj.field = field;
                    fields.push(obj);
                }
            }
            $('input[name=fields]').val(JSON.stringify(fields));
            $('input[name=title]').val($('head title').text());
            $('#searchForm').submit();
        }

        function exportTemplate() {
            var url = '${pageContext.request.contextPath}/vipController/userTest/exportTemplate';
            location.href = url;
        }

        function batchImport() {
            var jsonData = new FormData(document.forms.namedItem("searchForm"));
            $.messager.confirm('INFO', '${internationalConfig.确认添加}', function (status) {
                if (status) {
                    $.ajax({
                        type: "post",
                        url: '${pageContext.request.contextPath}/vipController/userTest/batchImport',
                        dataType: 'json',
                        data: jsonData,//$("#video-second-form").serializeArray(),                            
                        processData: false,
                        contentType: false,
                        success: function (result) {
                            if (result.code == 0) {
                                parent.$.messager.alert('SUCCESS', result.msg, 'success');
                                dataGrid.datagrid('reload');
                            } else {
                                parent.$.messager.alert('ERROR', result.msg, 'error');
                            }
                        }
                    });
                }
            })
        }

        function edit(id) {
            var url = '${pageContext.request.contextPath}/vipController/userTest/edit';
            var title = '';
            if (id) {
                url += '?id=' + id;
                title = 'Update Test User';
            } else {
                title = 'Add Test User';
            }
            parent.$.modalDialog({
                title: title,
                width: 500,
                height: 450,
                href: url,
                buttons: [{
                    text: '${internationalConfig.保存}',
                    handler: function () {
                        parent.$.modalDialog.openner_dataGrid = dataGrid;
                        var f = parent.$.modalDialog.handler.find('#form');
                        f.submit();
                    }
                }]
            });
        }
        function updateStatus(id, status) {
            $.get("${pageContext.request.contextPath}/vipController/userTest/updateStatus", {
                id: id,
                status: status
            }, function (result) {
                parent.$.messager.progress('close');
                result = $.parseJSON(result);
                if (result.code == 0) {
                    parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.状态} ${internationalConfig.更新} ${internationalConfig.成功}', 'success');
                    dataGrid.datagrid('reload');
                } else {
                    parent.$.messager.alert('${internationalConfig.失败}', result.msg, 'error');
                }
            });
        }
    </script>

    <style>
        .span {
            padding: 10px;
        }
    </style>
</head>
<body>

<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
         style="height: 120px; overflow: auto;">
        <form id="searchForm" action="${pageContext.request.contextPath}/vipController/userTest/exportExcel"
              method="post">
            <table class="table table-hover table-condensed">
                <tr>
                    <th>${internationalConfig.用户}ID</th>
                    <th>${internationalConfig.用户名}</th>
                    <th>${internationalConfig.状态}</th>
                    <th>${internationalConfig.上传文件}</th>
                </tr>
                <tr>
                    <input type="hidden" name="title">
                    <input type="hidden" name="fields">
                    <td>
                        <input name="userId" id="userId" class="easyui-textbox" style=" width: 160px; height: 29px"/>
                    </td>
                    <td>
                        <input name="userName" id="userName" class="easyui-textbox"
                               style=" width: 160px; height: 29px"/>
                    </td>
                    <td>
                        <select name="status" id="status" style="width: 160px">
                            <option value="">${internationalConfig.全部}</option>
                            <option value="1">${internationalConfig.启用}</option>
                            <option value="0">${internationalConfig.停用}</option>
                        </select>
                    </td>
                    <td><input id="fb" name="file" class="easyui-filebox"/></td>
                </tr>
            </table>
        </form>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>
<div id="toolbar" style="display: none;">
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true"
       onclick="searchFun();">${internationalConfig.查询}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'pencil_add',plain:true"
       onclick="edit();">${internationalConfig.增加}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true"
       onclick="cleanFun();">${internationalConfig.清空条件}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true"
       onclick="exportExcel();">${internationalConfig.导出excel}</a>
    <%-- <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="exportTemplate();">${internationalConfig.导出模板}</a> --%>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true"
       onclick="batchImport();">${internationalConfig.批量导入}</a>
</div>
</body>
</html>
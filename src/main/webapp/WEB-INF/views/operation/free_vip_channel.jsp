<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>免费会员-渠道管理</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            dataGrid = $('#dataGrid')
                    .datagrid(
                    {
                        url: '/free_vip/channel/list',
                        queryParams: $.serializeObject($('#searchForm')),
                        fit: true,
                        fitColumns: true,
                        border: false,
                        pagination: true,
                        idField: 'id',
                        pageSize: 20,
                        pageList: [10, 20, 30, 40, 50],
                        sortName: 'id',
                        sortOrder: 'asc',
                        checkOnSelect: false,
                        selectOnCheck: false,
                        singleSelect: true,
                        nowrap: false,
                        striped: true,
                        rownumbers: false,
                        singleSelect: true,
                        frozenColumns: [[{
                            field: 'id',
                            title: '${internationalConfig.编号}',
                            width: 50,
                            hidden: true
                        }]],
                        columns: [[
                            {
                                field: 'id',
                                title: '${internationalConfig.渠道} ID',
                                width: 60,
                                sortable: true
                            }, {
                                field: 'name',
                                title: '${internationalConfig.渠道名称}',
                                width: 60
                            }, {
                                field: 'description',
                                title: '${internationalConfig.渠道描述}',
                                width: 150
                            },
                            {
                                field: 'price',
                                title: '${internationalConfig.第三方售卖价格}',
                                width: 100
                            },
                            {
                                field: 'clearingForm',
                                title: '${internationalConfig.结算方式}',
                                width: 70,
                                formatter: function (value) {
                                    if(value==1){
                                        return '${internationalConfig.前置付费}';
                                    }else if(value==2){
                                        return '${internationalConfig.后置付费}';
                                    }
                                    return "";
                                }
                            },
                            {
                                field: 'area',
                                title: '${internationalConfig.会员生效区域}',
                                width: 80,
                                formatter: function (value) {
                                    if (value == 0) {
                                        return "${internationalConfig.通用}";
                                    } else if (value == 1) {
                                        return "${internationalConfig.移动app}";
                                    } else if (value == 2) {
                                        return "${internationalConfig.机卡绑定}";
                                    } else {
                                        return "";
                                    }
                                }
                            }, {
                                field: 'operatorId',
                                title: '${internationalConfig.操作者}',
                                width: 80
                            },
                            {
                                field: 'start',
                                title: '${internationalConfig.开始时间}',
                                width: 60,
                                sortable: true
                            },
                            {
                                field: 'end',
                                title: '${internationalConfig.结束时间}',
                                sortable: true,
                                width: 60
                            },
                            {
                                field: 'updateTime',
                                title: '${internationalConfig.更新时间}',
                                width: 60,
                                sortable: true
                            },
                            {
                                field: 'action',
                                title: '${internationalConfig.操作}',
                                width: 60,
                                formatter: function (value, row, index) {
                                    var str = '';

                                    str += $.formatString('<img onclick="addFun(\'{0}\');" src="{1}" title="${internationalConfig.编辑}"/>', row.id, '/static/style/images/extjs_icons/pencil.png');

                                    return str;
                                }
                            }]],
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
        });


        function searchFun() {
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }
        function addFun(id) {
            parent.$.modalDialog({
                title: '${internationalConfig.渠道信息}',
                scroll: true,
                width: 530,
                height: 600,
                resizable: true,
                maximizable: true,
                href: '/free_vip/channel/save?id=' + id,
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
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
         style="height: 80px; overflow: hidden;">
        <form id="searchForm">
            <table class="table-td-two" style="width:70%">
                <tr>
                    <td style="width:30%">${internationalConfig.渠道}ID：<input name="id" class="span2"/></td>
                    <td style="width:30%">${internationalConfig.渠道名称}：<input name="name" class="span2"/></td>
                    <%-- <td style="text-align:right;width:30%;">${internationalConfig.会员生效区域}：</td>
                    <td style="width:30%;" >
                     <select name="area" onchange="showTerminalPaymentConfig(this)" class="tabla_form_input" style="text-align:left;width:100px;">
                         <option value="" <c:if test="${terminal eq '0' }">selected</c:if>>${internationalConfig.全部}</option>
                         <option value="0" <c:if test="${terminal eq '0' }">selected</c:if>>${internationalConfig.通用}</option>
                         <option value="1" <c:if test="${terminal eq '1' }">selected</c:if>>${internationalConfig.移动app}</option>
                         <option value="2" <c:if test="${terminal eq '2' }">selected</c:if>>${internationalConfig.机卡绑定}</option>
                     </select>
                     </td> --%>
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
       data-options="iconCls:'pencil_add',plain:true" onclick="addFun(0);">${internationalConfig.增加渠道}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_delete',plain:true"
       onclick="cleanFun();">${internationalConfig.清空条件}</a>
</div>
</body>
</html>
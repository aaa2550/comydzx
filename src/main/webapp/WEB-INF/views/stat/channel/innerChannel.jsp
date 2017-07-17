<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>站内转化分布</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/channelStat/inner/channelQuery');
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
                pageList: [20, 30, 50, 100],
                sortName: 'payUV',
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
                            field: 'moduleId',
                            title: '渠道类别',
                            width: 100
                        },
                        {
                            field: 'channelName',
                            title: '渠道名称',
                            width: 250
                        },
                        {
                            field: 'channelParameter',
                            title: '渠道参数',
                            width: 150
                        },
                        {
                            field: 'pageUV',
                            title: '流量(UV)',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'payUV',
                            title: '付费人数',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'income',
                            title: '付费收入',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'payRate',
                            title: '付费转化率',
                            width: 100,
                            formatter: function (value, row, index) {
                                return $.formatString('{0}%', row.payRate);
                            }
                        },
                        {
                            field: 'newPayUV',
                            title: '新增人数',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'newIncome',
                            title: '新增收入',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'xufeiPayUV',
                            title: '续费人数',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'xufeiIncome',
                            title: '续费收入',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'operation', 
                            title: '操作',
                            noExport: true,
                            width: 	120,
                            sortable: false,
                            formatter : function(value, row, index) {
                                return '<a href="javascript:void(0)" onclick=gotoDetail("'+row.domainId+'","'+row.moduleId+'","'+row.channelParameter+'")>查询明细</a>';
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

        function searchFun() {
            renderDataGrid('${pageContext.request.contextPath}/tj/channelStat/inner/channelQuery?' + $("#searchForm").serialize());
        }
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }
        function gotoDetail(domainId, moduleId, channelParameter){
    		parent.iframeTab.init({url:'${pageContext.request.contextPath}/tj/channelStat/inner/trendPage.do?domainId='+domainId+'&moduleId='+moduleId+'&channelParameter='+channelParameter+"&jump=true"
    			,text:'站内转化趋势'});
    	}
        function loadModuleByDomain() {
            var domainSelect = $("#domainId");
            var domainId = domainSelect.val();
            var moduleSelect = $("#moduleId");

            $.getJSON("${pageContext.request.contextPath}/tj/channelStat/channel/module", {domainId: domainId}, function (modules) {
                var options = "";
                modules = modules['rows'];
                var size = modules.length;
                if (size > 0) {
                    options += "<option value=-2>全部</option>";
                    for (var i = 0; i < size; i++) {
                        var module = modules[i];
                        if (module['moduleId'] == '${channel.moduleId}') {
                            options += "<option value=" + module['moduleId'] + " selected>" + module['moduleName'] + "</option>";
                        } else {
                            options += "<option value=" + module['moduleId'] + ">" + module['moduleName'] + "</option>";
                        }
                    }
                    moduleSelect.html(options);
                } else {
                    moduleSelect.html(options);

                }
            });
        }


    </script>

    <script type="text/javascript">
        function exportExcel() {
            var beginDate = $('#beginDate').combobox('getValue');
            var endDate = $('#endDate').combobox('getValue');
            var domainId = $("#domainId").val();
            var moduleId = $("#moduleId").val();
            var terminal = $("#terminal").val();
            var channelParameter = $("#channelParameter").val();
            var url = '${pageContext.request.contextPath}/tj/channelStat/inner/excel?beginDate='
                    + beginDate + '&endDate=' + endDate + '&domainId=' + domainId + '&moduleId=' + moduleId + '&terminalStr=' + terminal + '&channelParameter=' + channelParameter;
            location.href = url;
        }
    </script>

</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false"
         style="height: 120px; overflow: auto;">
        <form id="searchForm">
            <table class="table table-hover table-condensed">
                <tr>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>渠道级别</td>
                    <td>渠道类别</td>
                    <td>终端</td>
                    <td>渠道参数</td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <input name="beginDate" id="beginDate" class="easyui-datebox" data-options="required:true"
                               value="${start}" style="width: 160px; height: 29px"/>
                    </td>
                    <td>
                        <input name="endDate" id="endDate" class="easyui-datebox" data-options="required:true"
                               value="${end}" style="width: 160px; height: 29px">
                    </td>
                    <td><select id="domainId" name="domainId" style="width: 160px" onchange="loadModuleByDomain()">
                        <option value="-2" selected>全部</option>
                        <option value="1">站内</option>
                        <option value="2">支付域</option>
                    </select>
                    </td>
                    <td><select id="moduleId" name="moduleId" style="width: 160px">
                        <option value="-2" selected>全部</option>
                    </select>
                    </td>
                    <td><select id="terminal" name="terminalStr" style="width: 160px">
                        <option value="-2" selected>全部</option>
                        <option value="PC">PC</option>
                        <option value="MH5">M站</option>
                    </select>
                    </td>
                    <td>
                        <input name="channelParameter" id="channelParameter" style="width: 160px; height: 24px"/>
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
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true"
       onclick="exportExcel();">导出excel</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_delete',plain:true"
       onclick="cleanFun();">清空条件</a>
</div>


</body>
</html>
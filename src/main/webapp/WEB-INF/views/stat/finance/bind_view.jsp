<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>机卡绑定数量统计</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            dataGrid = $('#dataGrid').datagrid({
                url: '${pageContext.request.contextPath}/vipController/bindView/query',
                fit: true,
                fitColumns: true,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 20,
                pageList: [10, 20, 30, 40, 50],
                //sortName: 'create_time',
                //sortOrder: 'desc',
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                striped: true,
                rownumbers: true,
                singleSelect: true,
                queryParams: {
                	beginDate: $("#beginDate").val(),
                	endDate: $("#endDate").val()
                },
                frozenColumns: [
                    [
                        {
                            field: 'id',
                            title: '编号',
                            width: 150,
                            hidden: true
                        }
                    ]
                ],
                columns: [
                    [
                        {
                            field: 'deviceType',
                            title: '设备类型',
                            width: 70,
                            formatter: function(value,row,index){
                            	if(value == 1)
                            		return "电视";
                            	if(value == 2)
                            		return "手机";
                            	if(value == 3)
                            		return "盒子";
                            	if(value == 4)
                            		return "路由器";
                            	return "";
                			}
                        },
                        {
                            field: 'vipType',
                            title: '机卡绑定的会员类型',
                            width: 70,
                            formatter: function(value,row,index){
                            	if(value == 1)
                            		return "乐次元";
                            	if(value == 2)
                            		return "全屏";
                            	if(value == 3)
                            		return "体育";
                            	return "";
                			}
                        },
                        {
                            field: 'resourceTotal',
                            title: '时长(月)',
                            width: 70
                        },
                        {
                            field: 'bindCount',
                            title: '绑定数',
                            width: 70
                        },
                        {
                            field: 'activeCount',
                            title: '激活数',
                            width: 70
                        }
                    ]
                ],
                toolbar: '#toolbar',
                onLoadSuccess: function () {
                    $("#searchForm table").show();
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
            $('#searchForm input,select').val('');
            //dataGrid.datagrid('load', {});
        }
        
        function exportFile() {
        	location.href = '${pageContext.request.contextPath}/vipController/bindView/exportExcel?' + $("#searchForm").serialize();
        }
        
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false" style="height: 80px; overflow: hidden;">
        <form id="searchForm">
            <table class="table table-hover table-condensed" style="display: none;">
                <tr>
                    <th></th>
                    <td>开始日期：<input id="beginDate" name="beginDate" value="${beginDate}" class="easyui-datebox"/></td>
                    <td>截至日期：<input id="endDate" name="endDate" value="${endDate}" class="easyui-datebox"/></td>
                    <td>设备类型：
                        <select name="deviceType" id="deviceType">
                            <option value="">全部</option>
                            <option value="1">电视</option>
                            <option value="2">手机</option>
                            <option value="3">盒子</option>
                            <option value="4">路由器</option>
                        </select>
                    </td>
                    <td>会员类型：
                        <select name="vipType" id="vipType">
                            <option value="">全部</option>
                            <option value="1">乐次元</option>
                            <option value="2">全屏</option>
                            <option value="3">体育</option>
                        </select>
                    </td>
                   	<td>时长从：<input id="resourceTotalMin" name="resourceTotalMin" value="${resourceTotalMin}" class="easyui-textbox"/></td>
                   	<td>到：<input id="resourceTotalMax" name="resourceTotalMax" value="${resourceTotalMax}" class="easyui-textbox"/></td>
                    <th></th>
                    <td></td>
                </tr>
            </table>
        </form>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>
<div id="toolbar" style="display: none;">
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">清空条件</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="exportFile();">导出文件</a>
</div>
</body>
</html>
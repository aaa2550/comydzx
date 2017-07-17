<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>TV页面流量</title>
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/channelStat/clickPv/query?terminal=111');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').datagrid({
                url: url,
                fit: true,
                fitColumns: false,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 50,
                pageList: [ 20,50,100 ],
                sortName: '',
                sortOrder: '',
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
						    field: 'channelName',
						    title: '渠道名称',
						    width: 200,
						    sortable: true
						},
                        {
                            field: 'channelParameter',
                            title: '渠道参数',
                            width: 300,
                            sortable: true
                        },
                        {
                            field: 'pv',
                            title: '流量(PV)',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'uv',
                            title: '流量(UV)',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'clickRate',
                            title: '转化率',
                            width: 100,
                            formatter: function (value, row, index) {
                                return $.formatString('{0}%', parseInt(100*row.clickRate)/100);
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
            renderDataGrid('${pageContext.request.contextPath}/tj/channelStat/clickPv/query?' + $("#searchForm").serialize());
        }
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
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
                    <td>终端</td>
                    <td>渠道参数</td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <input name="beginDate" class="easyui-datebox" data-options="required:true" value="${start}" style="width: 160px; height: 29px"/>
                    </td>
                    <td>
                        <input name="endDate" class="easyui-datebox" data-options="required:true" value="${end}" style="width: 160px; height: 29px">
                    </td>
                    <td><select id="terminal" name="terminal" style="width: 160px" >
							<option value="111" selected>TV</option>
						</select>
					</td>
                    <td>
                    	<select name="channelParameter" style="width:200px" >
                            <option value="">全部</option>
                          	<c:forEach items="${pageList}" var="var">
        				    	<option value='${var.channelParameter}' >${var.channelName}</option>
                          	</c:forEach>
                        </select>
					</td>
					<td></td>
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
     <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a><a
        href="javascript:void(0);" class="easyui-linkbutton"
        data-options="iconCls:'brick_delete',plain:true"
        onclick="cleanFun();">清空条件</a>
</div>


</body>
</html>
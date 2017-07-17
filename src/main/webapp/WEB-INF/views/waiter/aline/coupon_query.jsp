<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>${internationalConfig.代金券细节查询}</title>
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
    <script type="text/javascript">
        var dataGrid;

        $(function () {
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/coupon_query/data_grid.json');
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
                pageList: [ 10, 20, 30, 40, 50 ],
                sortName: 'createDate',
                sortOrder: 'desc',
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                striped: true,
                rownumbers: true,
                singleSelect: true,
                remoteSort: false,
                frozenColumns: [
                    [
                    ]
                ],
                columns: [
                    [
                        {
                            field: 'name',
                            title: '${internationalConfig.代金券名称}',
                            width: 80,
                            sortable: false
                        },
                        {
                            field: 'amountFmt',
                            title: '${internationalConfig.代金券面额}',
                            width: 80,
                            sortable: false,
                            formatter: function (value) {
                                return value + "${internationalConfig.元}";
                            }
                        },
                        {
                            field: 'startTime',
                            title: '${internationalConfig.有效开始时间}',
                            width: 100,
                            sortable: false,
                            formatter: function (value) {
                                return value.substr(0, 10);
                            }
                        },
                        {
                            field: 'endTime',
                            title: '${internationalConfig.有效结束时间}',
                            width: 100,
                            sortable: false,
                            formatter: function (value) {
                                return value.substr(0, 10);
                            }
                        },
                        {
                            field: 'statusDesc',
                            title: '${internationalConfig.状态}',
                            width: 80,
                            sortable: false
                        },{
                            field: 'userId',
                            title: '${internationalConfig.用户ID}',
                            width: 100,
                            sortable: false,
                            formatter: function (value) {
                                if(value==0 || value==-1 || value==1){
                                    return "";
                                }
                               return value;
                            }
                        },
                        {
                            field: 'ext',
                            title: '${internationalConfig.备注}',
                            width: 100,
                            sortable: false
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
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }
        function searchFun() {
        	if(isNaN($("#couponCode").val())) {
        		parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.优惠码必须为数字}!', 'error');
        		return ;
        	}
        	
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'">
        <form id="searchForm">
            <table class="table-td-two">
                <tr>
                    <td>${internationalConfig.优惠码}：
                        <input id="couponCode" name="couponCode" class="span2"/>
                    </td>
                    <td>
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
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a><a
        href="javascript:void(0);" class="easyui-linkbutton"
        data-options="iconCls:'brick_delete',plain:true"
        onclick="cleanFun();">${internationalConfig.清空条件}</a>
</div>


</body>
</html>
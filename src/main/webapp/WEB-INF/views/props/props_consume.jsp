<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>道具消耗汇总</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script  src="/js/kv/propsBusiness.js"></script>
    <script type="text/javascript" src="/js/dict.js"></script>
    <style type="text/css">
        table tr td b {
            text-align: center;
            font-size: 32px;
        }

        table tr td:first-child b {
            color: red;
        }

        div[class="easyui-panel panel-body"] {
            overflow: hidden;
        }
    </style>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            dataGrid = renderDataGrid('/props_consume/query');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').datagrid({
                url: url,
                fit: true,
                fitColumns: false,
                border: false,
                idField: 'pid',
                pagination: true,
                pageSize: 10,
                pageList: [10, 20, 30, 40, 50],
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
                            field: 'pid',
                            title: '道具ID',
                            width: 60,
                            formatter: function (value, row, index) {
                                var str = $.formatString("<a href='javascript:void(0)' onclick='openFn(this)' data-row='{0}' data-href='/props_consume_details/list.do?pid=" + value + "'>" + value + "</a>", row.pid);
                                return str;
                            }
                        },
                        {
                            field: 'codeName',
                            title: '道具名称',
                            width: 100
                        },
                        {
                            field: 'name',
                            title: '显示名称',
                            width: 150
                        },
                        {
                            field: 'businessId',
                            title: '业务线',
                            width: 100,
                            formatter: function (value, row, index) {
                            	return Dict.propsBusiness[value];
                            }
                        },
                        {
                            field: 'freeCount',
                            title: '免费次数',
                            width: 150
                        },
                        {
                            field: 'payCount',
                            title: '付费次数',
                            width: 150
                        },
                        {
                            field: 'totolCount',
                            title: '总次数',
                            width: 150
                        },
                        {
                            field: 'totalPrice',
                            title: '乐币总数',
                            width: 150
                        }
                    ]
                ],
                toolbar: '#toolbar',
                onLoadSuccess: function () {
                    var params = $.serializeObject($('#searchForm'));
                    loadSum(params);
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
        function openFn (ele) {
        	var tt =parent.$('#index_tabs'),title="道具消耗明细",href=$(ele).data("href");  
            if (tt.tabs('exists', title)){//如果tab已经存在,则选中并刷新该tab          
                tt.tabs('select', title);  
                refreshTab({tabTitle:title,url:href});  
            } else {  
                if (href){  
                    var content = '<iframe scrolling="no" frameborder="0"  src="'+href+'" style="width:100%;height:100%;"></iframe>';  
                } else {  
                    var content = '未实现';  
                }  
                tt.tabs('add',{  
                    title:title,  
                    closable:true,  
                    content:content,  
                   
                });  
            }  
            function refreshTab(cfg){  
                var refresh_tab = cfg.tabTitle?tt.tabs('getTab',cfg.tabTitle):tt.tabs('getSelected');  
                if(refresh_tab && refresh_tab.find('iframe').length > 0){  
                var _refresh_ifram = refresh_tab.find('iframe')[0];  
                var refresh_url = cfg.url?cfg.url:_refresh_ifram.src;  
                //_refresh_ifram.src = refresh_url;  
                _refresh_ifram.contentWindow.location.href=refresh_url;  
                }  
            } 
        			
        	
        
        	 
        	 
        }
        function searchFun() {
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }

        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }

        function exportFile() {
            var businessId = $("select[name='businessId']").val();
            var propsKey = $("input[name='propsKey']").val();
            var url = '/props_consume/export?businessId=' + businessId + '&propsKey=' + propsKey;
            location.href = url;
        }

        function loadSum(params) {
            $.get("/props_consume/query_count", params, function (data) {
                if (data) {
                    $("#totalPrice").html(data.totalPrice ? data.totalPrice : 0);
                    $("#freeCount").html(data.freeCount ? data.freeCount : 0);
                    $("#payCount").html(data.payCount ? data.payCount : 0);
                }
            }, "json");
        }
    </script>
</head>
<body>
<div class="easyui-panel" title="查询条件">
    <form id="searchForm">
        <table class="table-more">
            <tr>
                <td>业务线：<%@ include file="/WEB-INF/views/inc/props_business.inc" %>
                </td>
            </tr>
            <tr>
                <td>
                    道具名称：<input name="propsKey" class="easyui-textbox" data-options="prompt:'请输入道具ID\\道具名称'" style="width: 310px"
                                class="span2">
                </td>
            </tr>
        </table>
    </form>
</div>
<div class="easyui-panel" title="全部道具">
    <table class="table-more">
        <tr>
            <td>
                乐币总数：<b id="totalPrice"><fmt:formatNumber value='${totalPrice}' pattern='###,###,###,###'/></b>
            </td>
            <td>
                免费总次数：<b id="freeCount"><fmt:formatNumber value='${freeCount}' pattern='###,###,###,###'/></b>
            </td>
            <td>
                付费总次数：<b id="payCount"><fmt:formatNumber value='${payCount}' pattern='###,###,###,###'/></b>
            </td>
        </tr>
    </table>
</div>

<div data-options="border:false" style="height: 400px">
    <table id="dataGrid"></table>
</div>

<div id="toolbar" style="display: none;">
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_delete',plain:true"
       onclick="cleanFun();">清空条件</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="exportFile();">导出数据</a>
</div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>${internationalConfig.乐点余额转移}</title>
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            dataGrid = $('#dataGrid').datagrid({
                url: '${pageContext.request.contextPath}/lepoint_transfer/data_grid.json',
                fit: true,
                fitColumns: true,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 50,
                pageList: [ 10, 20, 30, 40, 50 ],
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                striped: true,
                rownumbers: true,
                singleSelect: true,
                frozenColumns: [
                    [

                    ]
                ],
                columns: [
                    [
                        {
                            field: 'userid',
                            title: '${internationalConfig.使用者}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID'
                        },
                        {
                            field: 'username',
                            title: '${internationalConfig.使用者}'
                        },
                        {
                            field: 'lepoint',
                            title: '${internationalConfig.乐点数}'
                        },
                        {
                            field: 'createdate',
                            title: '${internationalConfig.账户创建时间}'
                        },
                        {
                            field: 'updatedate',
                            title: '${internationalConfig.账户更新时间}'
                        },
                        {
                            field: 'source',
                            title: '${internationalConfig.数据来源}',
                            formatter: function (value) {
                                if (value == 'legacy') {
                                    return "${internationalConfig.老乐点系统}"
                                } else {
                                    return "${internationalConfig.新乐点系统}"
                                }

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
        });
        function searchFun() {
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }
        function transferFun() {
        	var srcUserId = $('#srcUserId').val();
        	var dstUserId = $('#dstUserId').val();
        	if(srcUserId == ''){
        		alert("${internationalConfig.请输入转出用户}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID");
        		return;
        	}
        	if(dstUserId == ''){
        		alert("${internationalConfig.请输入转入用户}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID");
        		return;
        	}
            parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.确认乐点转账}？', function (isAllowed) {
                if (isAllowed) {
                    parent.$.messager.progress({
                        title: '${internationalConfig.提示}',
                        text: '${internationalConfig.数据处理中}....'
                    });
                    $.post('${pageContext.request.contextPath}/lepoint_transfer/transaction.json', {
                    	srcUserId: $("#srcUserId").val(), dstUserId: $('#dstUserId').val()
                    }, function(obj) {
            			var msg = decodeURIComponent(obj.msg) ;
            			parent.$.messager.alert('${internationalConfig.提示}', msg, 'info');
            			parent.$.messager.progress('close');
            			dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
            			
            		}, 'JSON');
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
            <table class="table-td-two"
                   style="display: none;">
                <tr>
                    <td>
                        ${internationalConfig.转出用户}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID：<input id="srcUserId" name="srcUserId"
                               class="span2"/>
                    </td>
                    <td>
                        ${internationalConfig.转入用户}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID：<input id="dstUserId" name="dstUserId"
                               class="span2"/>
                    </td>
                </tr>
            </table>
        </form>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
    <br/>

</div>
<div id="toolbar" style="display: none;">
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_delete',plain:true"
       onclick="cleanFun();">${internationalConfig.清空条件}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true"
       onclick="transferFun();">${internationalConfig.乐点转账}</a>
</div>
</body>
</html>
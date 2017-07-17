<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.新乐卡查询}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>

<script type="text/javascript">
<m:auth uri="/lecard/lecard_expire_edit.json">
	$.canEdit = true;
</m:auth>
</script>

<script type="text/javascript">
var dataGrid;
$(function () {
    dataGrid = $('#dataGrid').datagrid({
        url: '/lecard/detail.json',
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
				    field: 'id',
				    title: '${internationalConfig.序列号}'
				},
                {
                    field: 'number',
                    title: '${internationalConfig.卡号}'
                },
                {
                    field: 'flagDesc',
                    title: '${internationalConfig.卡状态}'
                   
                },
                {
                    field:'uid',
                    title:'${internationalConfig.用户ID}'
                },
             
                {
                    field: 'amount',
                    title: '${internationalConfig.金额}'
                  
                },
                {
                    field: 'batch',
                    title: '${internationalConfig.批次号}'
                },
                {
                    field: 'createTime',
                    title: '${internationalConfig.创建日期}',
                    width: 100
                },
                {
                    field: 'expireDate',
                    title: '${internationalConfig.过期日期}',
                    width: 100
                },
                {
                    field: 'activeTime',
                    title: '${internationalConfig.激活日期}',
                    width: 100
                } ,
                {
                    field: 'source',
                    title: '${internationalConfig.数据来源}',
                    formatter: function(value){
                        if(value == 'legacy'){
                            return "${internationalConfig.老系统}"
                        }else{
                            return "${internationalConfig.新系统}"
                        }

                    }
                },
                {
                    field: 'applyTypeDesc',
                    title: "${internationalConfig.卡类型}"
                },{
					field : 'action',
					title : '${internationalConfig.操作}',
					width : 100,
					formatter : function(value, row, index) {
						var str = '';
						
						<%--if ($.canEdit && row.flag == 1) {--%>
							<%--str += $--%>
									<%--.formatString(--%>
											<%--'<img onclick="editFun(\'{0}\');" src="{1}" title="${internationalConfig.编辑}"/>',--%>
											<%--row.number,--%>
											<%--'${pageContext.request.contextPath}/static/style/images/extjs_icons/bug/bug_edit.png');--%>
						<%--}--%>
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
});
function searchFun() {
    dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
}
function cleanFun() {
    $('#searchForm input').val('');
    dataGrid.datagrid('load', {});
}

function editFun(number) {
	if (number == undefined) {
		var rows = dataGrid.datagrid('getSelections');
		number = rows[0].number;
	}

	parent.$.modalDialog({
		title : '${internationalConfig.修改过期时间}',
		width : 400,
		height : 300,
		href : '${pageContext.request.contextPath}/lecard/lecard_expire_edit.json?number='
				+ number,
		buttons : [ {
			text : '${internationalConfig.保存}',
			handler : function() {
				parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
				var f = parent.$.modalDialog.handler.find('#form');
				f.submit();
			}
		} , {
			text : "${internationalConfig.取消}",
			handler : function() {
				parent.$.modalDialog.handler.dialog('close');
			}
		} ]
	});
}

</script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'"
         style="overflow: hidden;">
        <form id="searchForm">
            <table class="table-td-two">
                <tr>
                    <td>${internationalConfig.卡号}：
                        <input id="cardNumberOrSerialNumber" name="number"
                               class="span2"/>
                    </td>
                    <td>${internationalConfig.序列号}：<input id="id" name="id"
                               class="span2"/></td>
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
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a><a
        href="javascript:void(0);" class="easyui-linkbutton"
        data-options="iconCls:'brick_delete',plain:true"
        onclick="cleanFun();">${internationalConfig.清空条件}</a>
</div>
</body>
</html>
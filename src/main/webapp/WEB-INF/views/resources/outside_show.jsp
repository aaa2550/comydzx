<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.站外兑换码}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript" src="/js/dict.js"></script>
<script type="text/javascript">
<m:auth uri="/outsideCode/dataGrid">  $.canView = true;</m:auth>
<m:auth uri="/outsideCode/outsideCodeInfo">  $.canImport = true;</m:auth>
var dataGrid;
$(function () {
    dataGrid = renderDataGrid('');
});

function renderDataGrid(url) {
    return $('#dataGrid').datagrid({
        url: url,
        fit: true,
        fitColumns: false,
        border: false,
        pagination: true,
        idField: 'batch',
        pageSize: 10,
        pageList: [ 10, 20, 30, 40, 50 ],
        //sortName: 'createTime',
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
                {
                    field: 'id',
                    title: '${internationalConfig.编号}',
                    width: 150,
                    hidden: true
                }
            ]
        ],
        columns: [
            [
                {
                    field: 'code',
                    title: '${internationalConfig.兑换码}',
                    width: 150,
                    sortable: true
                },
                {
                    field: 'productName',
                    title: '${internationalConfig.会员名称}',
                    width: 150
                },
                {
                    field: 'duration',
                    title: '${internationalConfig.时长数量}',
                    width: 130
                    
                },
                {
                    field: 'durationUnit',
                    title: '${internationalConfig.时长单位}',
                    width: 130,
                    formatter: function (value) {
                        if (value == 1) {
                            return "${internationalConfig.年}";
                        }else if(value == 2){
                        	return "${internationalConfig.月}";
                        }else if(value == 5){
                        	return "${internationalConfig.天}";
                        }
                    }
                },
                {
                    field: 'createTime',
                    title: '${internationalConfig.导入时间}',
                    width: 130
                },
                {
                    field: 'useType',
                    title: '${internationalConfig.使用场景}',
                    width: 130,
                    formatter: function(value){
                        if (value == 0) return "${internationalConfig.机卡绑定站外会员}";
                        else if (value == 1) return "${internationalConfig.售卖站外会员}";
                        else return "";
                    }
                },
                {
                    field: 'status',
                    title: '${internationalConfig.状态}',
                    width: 130,
                    formatter: function (value,rowData,rowIndex) {
                        if (rowData.userId == 0) {
                            return "${internationalConfig.未领取}";
                        } else {
                        	return "${internationalConfig.已领取}";
                        }
                    }
                },
                {
                	  field: 'userId',
                      title: '${internationalConfig.用户ID}',
                      width: 150
                },
                {
                    field: 'activeTime',
                    title: '${internationalConfig.领取时间}',
                    width: 150,
                    sortable: true
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
//var firstLoad = true;
function searchFun() {
    /*if (!firstLoad)
	    dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
    else {
        firstLoad = false;*/
        dataGrid = renderDataGrid('/outsideCode/dataGrid?' + $('#searchForm').serialize());
    //}
}
function cleanFun() {
    $('#searchForm input').val('');
    dataGrid.datagrid('load', {});
}
//导入操作
function operation() {
    parent.$.modalDialog({
        title: '${internationalConfig.设定兑换码的相关属性}',
        width: <c:choose><c:when test="${currentLanguage=='zh'||currentLanguage=='zh_hk'}">500</c:when><c:otherwise>600</c:otherwise></c:choose>,
        height: 350,
        resizable: true,
        href: '/outsideCode/outsideCodeInfo',
        buttons: [{
            text: '${internationalConfig.保存}',
            handler: function () {
                parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                var f = parent.$.modalDialog.handler.find('#form');
                f.submit();
            }
        }, {
            text: "${internationalConfig.关闭}",
            handler: function () {
                parent.$.modalDialog.handler.dialog('close');
            }
        }]
    });
}


</script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
			style="overflow: hidden; height: 145px">
        <form id="searchForm">
            <table class="table-more" style="display: block;">
                <tr>
                    <td>${internationalConfig.兑换码}：<input class="span2" name="code"/></td>

                    <td>${internationalConfig.会员名称}: <select name="productId" class="span2">
                                <option value="" selected>${internationalConfig.请选择}</option>
                                <c:forEach items="${vipPackageTypeList}" var="packageType">
                                <option value="${packageType.id}">${packageType.name}</option>
                                </c:forEach>
                                </select>
                    </td>
                    <td>${internationalConfig.用户ID}: <input class="span2" name="userId"/></td>
                    <td>
                       ${internationalConfig.兑换码状态}：<select name="status" class="span2">
   						       <option value="-1">${internationalConfig.全部}</option>
                               <option value="1">${internationalConfig.未领取}</option>
                               <%--<option value="2">${internationalConfig.领取中}</option>--%>
                               <option value="3">${internationalConfig.已领取}</option>
                              </select>
                    </td>
                    </tr>
                    <tr>
                    <td>${internationalConfig.使用场景}: &nbsp;<select name="useType" class="span2">
                        <option value="-1">${internationalConfig.全部}</option>
                        <option value="0">${internationalConfig.机卡绑定站外会员}</option>
                        <option value="1">${internationalConfig.售卖站外会员}</option>
                    </select></td>
                    <td>${internationalConfig.上传开始时间}: <input class="span2 easyui-datebox" name="starttime"/></td>
                    <td>${internationalConfig.上传截止时间}: <input class="span2 easyui-datebox" name="endtime"/></td>
                    </tr>
                    </table>
        </form>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>
<div id="toolbar" style="display: none;">
<m:auth uri="/outsideCode/dataGrid">
       <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
</m:auth>
<m:auth uri="/outsideCode/outsideCodeInfo">
        <a href="javascript:void(0);" class="easyui-linkbutton"
        onclick="operation();">${internationalConfig.导入}</a>
</m:auth>
</div>


</body>
</html>
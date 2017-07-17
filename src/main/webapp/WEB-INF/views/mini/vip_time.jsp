<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: jiangchao3
  Date: 2017/2/6
  Time: 14:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>三方会员时长查询</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">
        var dataGrid;
        (function ($) {
            $.fn.serializeJson = function () {

                var serializeObj = {};
                var array = this.serializeArray();
                $(array).each(function () { // 遍历数组的每个元素 {name : xx , value : xxx}
                    if (serializeObj[this.name]) { // 判断对象中是否已经存在 name，如果存在name
                        serializeObj[this.name] += "," + this.value;
                    } else {
                        serializeObj[this.name] = this.value; // 如果元素name不存在，添加一个属性 name:value
                    }
                });
                return serializeObj;
            }
        })(jQuery)

        $(function () {
            dataGrid = renderDataGrid();

        });

        function renderDataGrid(url, data, method) {
            return $('#dataGrid')
                .datagrid(
                    {
                        url: url,
                        fit: true,
                        queryParams: data || "",
                        fitColumns: true,
                        border: false,
                        method: method || 'post',
                        pagination: true,
                        idField: 'id',
                        pageSize: 50,
                        pageList: [50, 100],
                        sortName: 'pk_agg_package',
                        sortOrder: 'desc',
                        checkOnSelect: false,
                        selectOnCheck: false,
                        nowrap: false,
                        striped: true,
                        rownumbers: true,
                        singleSelect: true,
                        frozenColumns: [[{
                            field: 'id',
                            title: '${internationalConfig.编号}',
                            width: 10,
                            hidden: true
                        }]],
                        columns: [[
                            /*{
                             field : 'id',
                             title : '序号',
                             width : 100,
                             sortable : true,
                             formatter : function(val, row) {
                             return row.id;
                             }
                             },*/
                            {
                                field: 'userId',
                                title: '用户ID',
                                width: 40,
                                sortable: false
                            },
                            {
                                field: 'vendorVipName',
                                title: '商家产品名称',
                                width: 100,
                                sortable: false
                            },
                            {
                                field: 'startTime',
                                title: '会员开始时间',
                                width: 60,
                                sortable: false
                            },
                            {
                                field: 'endTime',
                                title: '会员结束时间',
                                width: 60,
                                sortable: false
                            },

                        ]],
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
            var html = $(".userInfoType").find("option:selected").text()
            parent.$.messager.progress({
                title: '${internationalConfig.提示}',
                text: '${internationalConfig.数据处理中}....'
            });
            if ($("#userId").val() == '') {
                parent.$.messager.alert('${internationalConfig.提示}', '请输入' + html, 'info');
                parent.$.messager.progress('close');
                return false;
            }
            renderDataGrid('/mini/vip/search?', $('#searchForm').serializeJson(), "get");
            parent.$.messager.progress('close');
        }

        function cleanFun() {
            $('#searchForm input').val('');
            renderDataGrid('/mini/vip/search');
        }
    </script>
</head>
<style>
    table a {
        display: inline-block
    }
</style>
<body>
<div class="easyui-layout" data-options="fit:true, border:false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'">
        <form id="searchForm">
            <table width="500" cellspacing="5" class="table-more">
                <tr>
                    <td width="100"><i style="color: red">*</i>
                        <select class="userInfoType" name="userInfoType" style="width: 70px;height:22px;">
                            <option value="id">用户ID</option>
                            <option value="email">邮箱</option>
                            <option value="mobile">手机号</option>
                        </select>
                        <input name="userId" id="userId" class="span2"/>
                    </td>
                    <td width="150"></td>
                </tr>
                <tr>
                    <td width="150"></td>
                    <td width="150"></td>
                </tr>
            </table>
        </form>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>

<div id="toolbar" style="display: none;">
    <a href="javascript:void(0);" class="easyui-linkbutton" onclick="searchFun();"
       data-options="iconCls:'brick_add',plain:true">${internationalConfig.查询}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" onclick="cleanFun();"
       data-options="iconCls:'brick_delete',plain:true">${internationalConfig.清空条件}</a>

</div>
</body>
</html>

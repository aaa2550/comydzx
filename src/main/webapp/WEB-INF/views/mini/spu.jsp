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
    <title>SPU管理</title>
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
    <script type="text/javascript">
        var dataGrid;
        (function($) {
            $.fn.serializeJson = function() {

                var serializeObj = {};
                var array = this.serializeArray();
                $(array).each(function() { // 遍历数组的每个元素 {name : xx , value : xxx}
                    if (serializeObj[this.name]) { // 判断对象中是否已经存在 name，如果存在name
                        serializeObj[this.name] += "," + this.value;
                    } else {
                        serializeObj[this.name] = this.value; // 如果元素name不存在，添加一个属性 name:value
                    }
                });
                return serializeObj;
            }
        })(jQuery)

        $(function() {
            parent.refreshDataGrid = [];
            parent.refreshDataGrid.spuDataGrid = renderDataGrid('/mini/spu/dataGrid');

            $(".category1").change(function () {
                var html = '<option value="-1">请选择</option>';
                var category1 = $(this).val();
                $(".category2").html(html);
                $(".category3").html(html);
                $.ajax({
                    url : "/mini/category/sub?id="+category1,
                    type : "get",
                    dataType : "json",
                    success : function(res) {
                        if (res.total > 0) {
                            for(var i in res.rows){
                                html += '<option value="'+res.rows[i].id+'">'+res.rows[i].name+'</option>'
                            }
                            $(".category2").html(html);
                        }
                    }
                })
            });
            $(".category2").change(function () {
                var html = '<option value="-1">请选择</option>';
                var category2 = $(this).val();
                $(".category3").html(html);
                $.ajax({
                    url : "/mini/category/sub?id="+category2,
                    type : "get",
                    dataType : "json",
                    success : function(res) {
                        if (res.total > 0) {
                            for(var i in res.rows){
                                html += '<option value="'+res.rows[i].id+'">'+res.rows[i].name+'</option>'
                            }
                            $(".category3").html(html);
                        }
                    }
                })
            });
        });

        function renderDataGrid(url, data, method) {
            return $('#dataGrid')
                    .datagrid(
                            {
                                url : url,
                                fit : true,
                                queryParams : data || "",
                                fitColumns : true,
                                border : false,
                                method : method || 'post',
                                pagination : true,
                                idField : 'id',
                                pageSize : 50,
                                pageList : [ 50, 100 ],
                                sortName : 'id',
                                sortOrder : 'asc',
                                checkOnSelect : false,
                                selectOnCheck : false,
                                nowrap : false,
                                striped : true,
                                rownumbers : true,
                                singleSelect : true,
                                frozenColumns : [ [ {
                                    field : 'id',
                                    title : '${internationalConfig.编号}',
                                    width : 10,
                                    hidden : true
                                } ] ],
                                columns : [ [
                                    {
                                        field : 'spuNo',
                                        title : 'SPU编码',
                                        width : 80,
                                        sortable : false
                                    },
                                    {
                                        field : 'name',
                                        title : 'SPU名称',
                                        width : 100,
                                        sortable : false
                                    },
                                    {
                                        field : 'pathTree',
                                        title : '品类名称',
                                        width : 120,
                                        sortable : false
                                    },
                                    {
                                        field : 'isOnline',
                                        title : '上下架状态',
                                        width : 40,
                                        sortable : false,
                                        formatter : function(val) {
                                            if(val==1) {
                                                return "已下架";
                                            }
                                            if(val==2) {
                                                return "已上架";
                                            }
                                        }
                                    },
                                    {
                                        field : 'createUser',
                                        title : '创建人',
                                        width : 50,
                                        sortable : false
                                    },
                                    {
                                        field : 'modifyTime',
                                        title : '最后修改时间',
                                        width : 80,
                                        sortable : false
                                    },
                                    {
                                        field : 'createTime',
                                        title : '首次上架时间',
                                        width : 80,
                                        sortable : false
                                    },
                                    {
                                        field : 'action',
                                        title : '${internationalConfig.操作}',
                                        width : 30,
                                        formatter : function(val, row, index) {
                                            var str = '';
                                            str += $.formatString('<a href="javascript:;" onclick="editFun(\'{0}\');">${internationalConfig.编辑}</a>',
                                                    row.id);
                                            return str;
                                        }
                                    } ] ],
                                toolbar : '#toolbar',
                                onLoadSuccess : function() {
                                    $('#searchForm table').show();
                                    parent.$.messager.progress('close');
                                },
                                onRowContextMenu : function(e, rowIndex, rowData) {
                                    e.preventDefault();
                                    $(this).datagrid('unselectAll');
                                    $(this).datagrid('selectRow', rowIndex);
                                    $('#menu').menu('show', {
                                        left : e.pageX,
                                        top : e.pageY
                                    });
                                }
                            });
        }

        function editFun(id) {
            if (id == undefined) {
                var rows = dataGrid.datagrid('getSelections');
                id = rows[0].id;
            }
            parent.iframeTab.init({url:'/mini/spu/edit?spuId='+id,text:'编辑SPU'});
        }
        function addFun(id) {
            parent.iframeTab.init({url:'/mini/spu/edit',text:'新增SPU'});
        }

        function searchFun() {
            var category1 = $(".category1").val();
            var category2 = $(".category2").val();
            var category3 = $(".category3").val();
            var attrId = category1;
            var levelId = null;
            if(category1 != ''){
                levelId = 1;
            }
            if(category3!=-1){
                attrId = category3;
                levelId = 3;
            }else if(category2!=-1){
                attrId = category2;
                levelId = 2;
            }
            var data = $('#searchForm').serializeJson();
            data.level = levelId
            data.categoryId = attrId
            parent.$.messager.progress({
                title : '${internationalConfig.提示}',
                text : '${internationalConfig.数据处理中}....'
            });
            //parent.refreshDataGrid.spuDataGrid.datagrid('load', data);
            renderDataGrid('/mini/spu/dataGrid?', data, "get");
            parent.$.messager.progress('close');
        }
        function attrSort() {
            var row = $('#dataGrid').datagrid('getSelected');
            if(row){
                parent.$.modalDialog({
                    title : '销售属性排序',
                    width :650,
                    height : 500,
                    href : '/mini/spu/spu_attribute_sort?spuId='+row.id,
                    onClose : function() {
                        this.parentNode.removeChild(this);
                    },
                    buttons : [ {
                        text : "${internationalConfig.关闭}",
                        handler : function() {
                            parent.$.modalDialog.handler.dialog('close');
                        }
                    } ]
                });
            }else{
                parent.$.messager.alert('${internationalConfig.提示}', '请选择SPU', 'info');
            }
        }
        function onOffLine() {
            var row = $('#dataGrid').datagrid('getSelected');
            if(row){
                var msg="";
                var msg2 = "";
                var status = 1;
                if (row.isOnline==1) {
                    msg='是否确认当前SPU执行上架？';
                    msg2 = "当前SPU已上架。";
                    status = 2;
                }else{
                    msg='是否确认当前SPU及其关联的所有SKU执行下架？';
                    msg2 = "当前SPU已下架，且关联的所有SKU已同时下架。";
                    status = 1;
                }
                $.messager.confirm('${internationalConfig.确认}', msg, function(r) {
                    if (r){
                        $.ajax({
                            type: 'POST',
                            cache: false,
                            url: '/mini/spu/onlineOffline',
                            data: {'spuIds': row.id,'status':status},
                            dataType: 'json',
                            success: function(data) {
                                if(data.code == 0 ){
                                    parent.$.messager.alert('${internationalConfig.成功}', msg2, 'success');
                                    //renderDataGrid('/mini/spu/dataGrid');
                                    searchFun();
                                } else {
                                    parent.$.messager.alert('${internationalConfig.错误}', data.msg, 'error');
                                }
                            }
                        });
                    }
                });
            }else{
                parent.$.messager.alert('${internationalConfig.提示}', '请选择SPU', 'info');
            }
        }
        function cleanFun() {
            $(".category1").val('');
            var html = '<option value="-1">请选择</option>';
            $(".category2").html(html);
            $(".category3").html(html);
            $('#searchForm input').val('');
            //parent.refreshDataGrid.spuDataGrid.datagrid('load', {});
            renderDataGrid('/mini/spu/dataGrid');
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit:true, border:false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'">
        <form id="searchForm">
            <table  width="800" cellspacing="5" class="table-more">
                <tr>
                    <td colspan="4">选择品类：
                        <select class="category1">
                            <option value="">${internationalConfig.全部}</option>
                            <c:forEach var="category" items="${categoryList}">
                                <option value="${category.id}"> ${category.name}</option>
                            </c:forEach>
                        </select>
                        <select class="category2">
                            <option value="-1">请选择</option>
                        </select>
                        <select class="category3">
                            <option value="-1">请选择</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td width="100">SPU编码：<input name="spuNo" class="span2" /></td>
                    <td width="100">SPU名称：<input name="spuName" class="span2" /></td>
                    <td width="150">上下架状态：
                        <select name="spuStatus" class="span2">
                            <option value="">全部</option>
                            <option value="2">已上架</option>
                            <option value="1">已下架</option>
                        </select>
                    </td>
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
    <a href="javascript:void(0);" class="easyui-linkbutton" onclick="addFun(0);"
       data-options="plain:true,iconCls:'pencil_add'">增加</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" onclick="attrSort();"
       data-options="iconCls:'brick_add',plain:true">销售属性排序</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" onclick="onOffLine(0);"
       data-options="plain:true,iconCls:'pencil_add'">上下架设置</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" onclick="searchFun();"
       data-options="iconCls:'brick_add',plain:true">${internationalConfig.查询}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" onclick="cleanFun();"
       data-options="iconCls:'brick_delete',plain:true">${internationalConfig.清空条件}</a>

</div>
</body>
</html>

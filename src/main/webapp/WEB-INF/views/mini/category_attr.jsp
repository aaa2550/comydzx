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
    <title>品类属性管理</title>
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
            dataGrid = renderDataGrid();

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
                                        field : 'id',
                                        title : '属性ID',
                                        width : 30,
                                        sortable : true,
                                        formatter : function(val, row) {
                                            return row.id;
                                        }
                                    },
                                    {
                                        field : 'name',
                                        title : '${internationalConfig.属性名称}',
                                        width : 80,
                                        sortable : false
                                    },
                                    {
                                        field : 'showName',
                                        title : '${internationalConfig.显示名称}',
                                        width : 80,
                                        sortable : false
                                    },
                                    {
                                        field : 'attributeUseScope',
                                        title : '${internationalConfig.属性类型}',
                                        width : 80,
                                        sortable : false,
                                        formatter : function(val) {
                                            var str = "";
                                            if(val==1) {
                                                str= "展示属性";
                                            }
                                            if(val==2) {
                                                str= "销售属性";
                                            }
                                            if(val==3){
                                                str= "展示且销售属性";
                                            }
                                            return str;
                                        }
                                    },
                                    {
                                        field : 'categoryAttributeItems',
                                        title : '可选项',
                                        width : 190,
                                        sortable : false,
                                        formatter : function(val, row, index) {
                                            var str = "";
                                            var length = val.length-1
                                            for(var i in val){
                                                if(i<length){
                                                    str +=$.formatString('<span>{0}</span>，',val[i].attributeItem);
                                                }else{
                                                    str +=$.formatString('<span>{0}</span>',val[i].attributeItem);
                                                }

                                            }
                                            return str;
                                        }
                                    },
                                    {
                                        field : 'createUser',
                                        title : '${internationalConfig.创建人}',
                                        width : 80,
                                        sortable : false
                                    },
                                    {
                                        field : 'modifyTime',
                                        title : '${internationalConfig.最后修改时间}',
                                        width : 80,
                                        sortable : false
                                    },
                                    {
                                        field : 'action',
                                        title : '${internationalConfig.操作}',
                                        width : 40,
                                        formatter : function(val, row, index) {
                                            var str = '';
                                            str += $.formatString('<a href="javascript:;" onclick="editFun(\'{0}\'\,\'{1}\');">${internationalConfig.编辑}</a>',
                                                    row.id, row.categoryId);
                                            str += '&nbsp;&nbsp;';
                                            str += $.formatString('<a href="javascript:;" onclick="deleteFun(\'{0}\');">${internationalConfig.删除}<a/>',
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


        function editFun(id, categoryId) {
            if (id == undefined) {
                var rows = dataGrid.datagrid('getSelections');
                id = rows[0].id;
            }

            parent.$.modalDialog({
                title : '编辑关联属性',
                width :650,
                height : 500,
                href : '/mini/category_attr/mapping_edit?id='+id+'&categoryId='+categoryId,
                onClose : function() {
                    this.parentNode.removeChild(this);
                },
                buttons : [ {
                    text : '${internationalConfig.保存}',
                    handler : function() {
                        parent.$.modalDialog.openner_dataGrid = dataGrid;
                        var f = parent.$.modalDialog.handler.find('#form');
                        submitFun(f, 2,false);
                    }
                }, {
                    text : "${internationalConfig.取消}",
                    handler : function() {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                } ]
            });
        }
        function deleteFun(id) {
            if (id == undefined) {
                var rows = dataGrid.datagrid('getSelections');
                id = rows[0].id;
            }
            parent.$.messager.confirm('${internationalConfig.询问}', '是否确认删除当前关联属性?',
                    function(b) {
                        if (b) {
                            parent.$.messager.progress({
                                title : '${internationalConfig.提示}',
                                text : '${internationalConfig.数据处理中}....'
                            });
                            $.post(
                                    '${pageContext.request.contextPath}/mini/category_attr/delete',
                                    {
                                        id : id
                                    },
                                    function(result) {
                                        if (result.code == 0) {
                                            parent.$.messager.alert('${internationalConfig.提示}','${internationalConfig.删除成功}','info');
                                            dataGrid.datagrid('reload');
                                        } else {
                                            parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
                                        }
                                        parent.$.messager.progress('close');
                                    }, 'JSON');
                        }
                    });
        }
        function mappingFun() {
            var category3 = $(".category3").val();
            var categoryId = category3;
            if(category3 ==-1) {
                parent.$.messager.alert('${internationalConfig.提示}', '属性只能与三级品类关联，请完整创建三级品类。', 'info');
                return false;
            }
            parent.$.modalDialog({
                title : '添加关联属性',
                width : 650,
                height : 500,
                href : '/mini/category_attr/mapping_edit?categoryId=' + categoryId,
                onClose : function() {
                    this.parentNode.removeChild(this);
                },
                buttons : [ {
                    text : '${internationalConfig.增加}',
                    handler : function() {
                        parent.$.modalDialog.openner_dataGrid = dataGrid; // 因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#form');
                        submitFun(f, 1,true);
                    }
                }, {
                    text : "${internationalConfig.取消}",
                    handler : function() {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                } ]
            });
        }


        function submitFun(f, type,isAdd) {
            if (f.form("validate")) {
                parent.$.messager.progress({
                    title : '${internationalConfig.提示}',
                    text : '${internationalConfig.数据处理中}....'
                });

                var successStr;
                if(type == 1){
                    successStr = "${internationalConfig.添加成功}";
                }else if(type == 2){
                    successStr = "${internationalConfig.修改成功}";
                }
                var data = f.serializeJson();
                if(data.attributeUseScope == '1,2'){
                    data.attributeUseScope = 3;
                }
                data.isAdd = isAdd;
                if(data.attributeItemIds==""){
                    parent.$.messager.progress('close');
                    parent.$.messager.alert('${internationalConfig.提示}', '请设置属性可选项', 'info');
                    return false;
                }
                $.ajax({
                    url : "/mini/category_attr/save",
                    type : "post",
                    data : data,
                    dataType : "json",
                    success : function(result) {
                        parent.$.messager.progress('close');
                        if (result.code == 0) {
                            parent.$.messager.alert('${internationalConfig.成功}', successStr, 'success');
                            searchFun();
                            //parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                            parent.$.modalDialog.handler.dialog('close');
                        } else {
                            parent.$.messager.alert('${internationalConfig.错误}', '<div style="word-break:break-all;">'+result.msg+'</div>', 'error');
                        }
                    },

                    error : function() {}
                })
            }
        }

        function searchFun() {
            var category1 = $(".category1").val();
            var category2 = $(".category2").val();
            var category3 = $(".category3").val();
            var attrId = category1;
            if(category3!=-1){
                attrId = category3;
            }else{
                if(category2!=-1){
                    attrId = category2;
                }else{
                    if(category1==0){
                        parent.$.messager.alert('${internationalConfig.提示}', '请选择三级品类。', 'info');
                        return false;
                    }
                }
            }
            parent.$.messager.progress({
                title : '${internationalConfig.提示}',
                text : '${internationalConfig.数据处理中}....'
            });
            renderDataGrid('/mini/category_attr/dataGrid?id=' + attrId, "get");
            parent.$.messager.progress('close');
        }

        function cleanFun() {
            $(".category1").val(0).trigger("change");
            renderDataGrid('/mini/category_attr/dataGrid?id=0');
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit:true, border:false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'">
        <form id="searchForm">
            <table  width="500" cellspacing="5" class="table-more">
                <tr>
                    <td>选择品类：
                        <select class="category1">
                            <option value="0">${internationalConfig.全部}</option>
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
            </table>
        </form>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>

<div id="toolbar" style="display: none;">
    <a href="javascript:void(0);" class="easyui-linkbutton" onclick="mappingFun();"
       data-options="plain:true,iconCls:'pencil_add'">关联属性</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" onclick="searchFun();"
       data-options="iconCls:'brick_add',plain:true">${internationalConfig.查询}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" onclick="cleanFun();"
       data-options="iconCls:'brick_delete',plain:true">${internationalConfig.清空条件}</a>

</div>
</body>
</html>

<%--
  Created by IntelliJ IDEA.
  User: jiangchao3
  Date: 2017/2/6
  Time: 14:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>品类管理</title>
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
</head>
<style>
    .no-result{display: none;}
</style>
<body>
    <div class="categories clearfix">
        <p class="cate_prompt">您当前选中的品类为【<span class="change_cate"></span>】，点击后面的 <a>${internationalConfig.编辑}</a> 按钮进行更改。
        <br><img style="margin-right: 5px;" src="/static/style/images/extjs_icons/information.png"/>品类需完整创建至第三级，方可生效。
        </p>
        <div class="category">
            <p class="category_title">一级品类</p>
            <div class="category_list">
                <p class="category_oper clearfix">
                    <a class="category_add" title="添加" onclick="addCate(1)"></a>
                    <a class="category_del" onclick="deleteCate(1)" title="删除"></a>
                </p>
                <div class="cateList">
                    <table id="category1"></table>
                </div>
            </div>
        </div>
        <div class="category">
            <p class="category_title">二级品类</p>
            <div class="category_list">
                <p class="category_oper clearfix">
                    <a class="category_add" title="添加" onclick="addCate(2)"></a>
                    <a class="category_del" onclick="deleteCate(2)" title="删除"></a>
                </p>
                <div class="cateList">
                    <table id="category2"></table>
                </div>
            </div>
        </div>
        <div class="category">
            <p class="category_title">三级品类</p>
            <div class="category_list">
                <p class="category_oper clearfix">
                    <a class="category_add" title="添加" onclick="addCate(3)"></a>
                    <a class="category_del" onclick="deleteCate(3)" title="删除"></a>
                </p>
                <div class="cateList">
                    <table id="category3"></table>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        var category1,category2,category3;
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
            category1 = renderDataGrid1('/mini/category/sub?id=0');
            category2 = renderDataGrid2();
            category3 = renderDataGrid3();
        });

        function renderDataGrid1(url, data, method) {
            return $('#category1')
                    .datagrid(
                            {
                                url : url,
                                fit : true,
                                queryParams : data || "",
                                fitColumns : true,
                                border : false,
                                method : method || 'post',
                                pagination : false,
                                idField : 'id',
                                sortName : 'category_name',
                                sortOrder : 'desc',
                                checkOnSelect : false,
                                selectOnCheck : false,
                                nowrap : false,
                                striped : true,
                                rownumbers : true,
                                singleSelect : true,
                                columns : [ [
                                    {
                                        field : 'category_name',
                                        title : '',
                                        width : 200,
                                        sortable : true,
                                        formatter : function(val, row) {
                                            return row.name;
                                        }
                                    },
                                    {
                                        field : 'action',
                                        title : '',
                                        width : 100,
                                        sortable : true,
                                        formatter : function(val, row) {
                                            var str = $.formatString('<a href="javascript:;" onclick="editFun(\'{0}\',1);">${internationalConfig.编辑}</a>',
                                                    row.id);
                                            return str;
                                        }
                                    }] ],
                                onLoadSuccess : function() {
                                    parent.$.messager.progress('close');
                                },
                                onClickRow:function(rowIndex,rowData){
                                    $(".change_cate").html(rowData.pathTree);
                                    category2 = renderDataGrid2('/mini/category/sub',{"id":rowData.id});
                                    if(category3) {
                                        $('#category3').datagrid('loadData', []);   //清除3级品类数据
                                        $('#category2').datagrid('clearSelections');
                                        $('#category3').datagrid('clearSelections');
                                    }
                                },
                            });
        }
        function renderDataGrid2(url, data, method) {
            return $('#category2')
                    .datagrid(
                            {
                                url : url,
                                fit : true,
                                queryParams : data || "",
                                fitColumns : true,
                                border : false,
                                method : method || 'post',
                                pagination : false,
                                idField : 'id',
                                sortName : 'category_name',
                                sortOrder : 'desc',
                                checkOnSelect : false,
                                selectOnCheck : false,
                                nowrap : false,
                                striped : true,
                                rownumbers : true,
                                singleSelect : true,
                                columns : [ [
                                    {
                                        field : 'category_name',
                                        title : '',
                                        width : 200,
                                        sortable : true,
                                        formatter : function(val, row) {
                                            return row.name;
                                        }
                                    },
                                    {
                                        field : 'action',
                                        title : '',
                                        width : 100,
                                        sortable : true,
                                        formatter : function(val, row) {
                                            var str = $.formatString('<a href="javascript:;" onclick="editFun(\'{0}\',2);">${internationalConfig.编辑}</a>',
                                                    row.id);
                                            return str;
                                        }
                                    }] ],
                                onLoadSuccess : function() {
                                    parent.$.messager.progress('close');
                                },
                                onClickRow:function(rowIndex,rowData){
                                    category3 = renderDataGrid3('/mini/category/sub',{"id":rowData.id});
                                    $(".change_cate").html(rowData.pathTree);
                                },
                            });
        }
        function renderDataGrid3(url, data, method) {
            return $('#category3')
                    .datagrid(
                            {
                                url : url,
                                fit : true,
                                queryParams : data || "",
                                fitColumns : true,
                                border : false,
                                method : method || 'post',
                                pagination : false,
                                idField : 'id',
                                sortName : 'category_name',
                                sortOrder : 'desc',
                                checkOnSelect : false,
                                selectOnCheck : false,
                                nowrap : false,
                                striped : true,
                                rownumbers : true,
                                singleSelect : true,
                                columns : [ [
                                    {
                                        field : 'category_name',
                                        title : '',
                                        width : 200,
                                        sortable : true,
                                        formatter : function(val, row) {
                                            return row.name;
                                        }
                                    },
                                    {
                                        field : 'action',
                                        title : '',
                                        width : 100,
                                        sortable : true,
                                        formatter : function(val, row) {
                                            var str = $.formatString('<a href="javascript:;" onclick="editFun(\'{0}\',3);">${internationalConfig.编辑}</a>',
                                                    row.id);
                                            return str;
                                        }
                                    }] ],
                                onLoadSuccess : function() {
                                    parent.$.messager.progress('close');
                                },
                                onClickRow:function(rowIndex,rowData){
                                    $(".change_cate").html(rowData.pathTree);
                                },
                            });
        }
function editFun(id,num) {
    if (id == undefined) {
        var rows = dataGrid.datagrid('getSelections');
        id = rows[0].id;
    }

    parent.$.modalDialog({
        title : '编辑品类',
        width :650,
        height : 340,
        href : '/mini/category/toEdit?id=' + id,
        onClose : function() {
            this.parentNode.removeChild(this);
        },
        buttons : [ {
            text : '${internationalConfig.保存}',
            handler : function() {
                if(num==1){
                    parent.$.modalDialog.openner_dataGrid = category1;
                }else if(num==2){
                    parent.$.modalDialog.openner_dataGrid = category2;
                }else if(num==3){
                    parent.$.modalDialog.openner_dataGrid = category3;
                }
                var f = parent.$.modalDialog.handler.find('#form');
                submitFun(f, 2,num);
            }
        }, {
            text : "${internationalConfig.取消}",
            handler : function() {
                parent.$.modalDialog.handler.dialog('close');
            }
        } ]
    });
}
function deleteCate(num) {
    var row = $('#category'+num).datagrid('getSelected');
    if (row){
        parent.$.messager.confirm('${internationalConfig.询问}', '是否确认删除当前品类？',
                function(b) {
                    if (b) {
                        parent.$.messager.progress({
                            title : '${internationalConfig.提示}',
                            text : '${internationalConfig.数据处理中}....'
                        });
                        $.post(
                                '${pageContext.request.contextPath}/mini/category/delete',
                                {
                                    id : row.id
                                },
                                function(result) {
                                    if (result.code == 0) {
                                        parent.$.messager.alert('${internationalConfig.提示}','${internationalConfig.删除成功}','info');
                                        if(num==1){
                                            category1.datagrid('reload');
                                        }else if(num==2){
                                            category2.datagrid('reload');
                                        }else if(num==3){
                                            category3.datagrid('reload');
                                        }
                                    } else {
                                        parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
                                    }
                                    parent.$.messager.progress('close');
                                }, 'JSON');
                    }
        });
    }else{
        parent.$.messager.alert('${internationalConfig.提示}','请选择要删除的品类','info');
        return false;
    }
}
function addCate(num){
    var parentId = 0;
    if(num!=1){
        var parentRow = $('#category'+(num-1)).datagrid('getSelected');
        if(parentRow==null){
            if(num==2){
                parent.$.messager.alert('${internationalConfig.提示}','请选择一级品类','info');
            }else{
                parent.$.messager.alert('${internationalConfig.提示}','请选择二级品类','info');
            }

            return false;
        }
        parentId = parentRow.id;
    }
    parent.$.modalDialog({
        title : '添加品类',
        width :650,
        height : 340,
        href : '/mini/category/toAdd?parentId=' + parentId,
        onClose : function() {
            this.parentNode.removeChild(this);
        },
        buttons : [ {
            text : '${internationalConfig.保存}',
            handler : function() {
                if(num==1){
                    parent.$.modalDialog.openner_dataGrid = category1;
                }else if(num==2){
                    parent.$.modalDialog.openner_dataGrid = category2;
                }else if(num==3){
                    parent.$.modalDialog.openner_dataGrid = category3;
                }
                var f = parent.$.modalDialog.handler.find('#form');
                submitFun(f, 1,num);
            }
        }, {
            text : "${internationalConfig.取消}",
            handler : function() {
                parent.$.modalDialog.handler.dialog('close');
            }
        } ]
    });
}
        function submitFun(f, submitType,num){
            if(f.form("validate")){
                parent.$.messager.progress({
                    title : '${internationalConfig.提示}',
                    text : '${internationalConfig.数据处理中}....'
                });
                var suffix=0;
                if(submitType == 1){
                    suffix = "add";
                }else if(submitType == 2){
                    suffix = "edit";
                }
                $.ajax({
                    url:"${pageContext.request.contextPath}/mini/category/"+suffix,
                    type:"post",
                    data:f.serializeJson(),
                    dataType:"json",
                    success:function(result){
                        parent.$.messager.progress('close');
                        /* result = $.parseJSON(result); */
                        if (result.code == 0) {
                            if(submitType == 1){
                                parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.添加成功}', 'success');
                            }else if(submitType == 2){
                                parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.编辑成功}', 'success');
                            }
                            //parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
                            if(num==1){
                                category1.datagrid('reload');
                            }else if(num==2){
                                category2.datagrid('reload');
                            }else if(num==3){
                                category3.datagrid('reload');
                            }
                            parent.$.modalDialog.handler.dialog('close');
                        } else {
                            parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
                        }
                    },
                    error:function(){

                    }


                })
            }
        }
    </script>
</body>
</html>

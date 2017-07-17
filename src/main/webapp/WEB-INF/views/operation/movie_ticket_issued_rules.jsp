<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
    <title>${internationalConfig.观影卷发放规则设置}</title>
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
    <script type="text/javascript" src="/js/kv/vipCategory.js"></script>
    <script type="text/javascript" src="/js/kv/vipType.js"></script>
    <script type="text/javascript">
        $.canEdit = true;
        $.canDelete = true;
        var dataGrid;
        (function($){
            $.fn.serializeJson=function(){

                var serializeObj={};
                var array=this.serializeArray();
                // var str=this.serialize();
                $(array).each(function(){ // 遍历数组的每个元素 {name : xx , value : xxx}
                    if(serializeObj[this.name]){ // 判断对象中是否已经存在 name，如果存在name
                        serializeObj[this.name]+=","+this.value;
                    }else{
                        serializeObj[this.name]=this.value; // 如果元素name不存在，添加一个属性 name:value
                    }
                });
                return serializeObj;
            }
        })(jQuery)

        $(function() {
            dataGrid = renderDataGrid('/movie_ticket_issued_rules/dataGrid');
        });

        function renderDataGrid(url,data,method) {
            return $('#dataGrid')
                    .datagrid(
                            {
                                url : url,
                                fit : true,
                                queryParams:data||"",
                                fitColumns : true,
                                border : false,
                                method:method||'post',
                                pagination : true,
                                idField : 'id',
                                pageSize : 50,
                                pageList : [ 50, 100 ],
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
                                    width : 150,
                                    hidden : true
                                } ] ],
                                    columns : [[{
                                        field : 'nonmember',
                                        title : '${internationalConfig.非会员下单发放}',
                                        width : 100,
                                        sortable : false,
                                        hidden : false,
                                        formatter : function(value) {
                                            return value+"${internationalConfig.张}";
                                        }
                                    },
                                    {
                                        field : 'vipRenewal',
                                        title : '${internationalConfig.会员续费发放}',
                                        width : 100,
                                        sortable : false,
                                        formatter : function(value) {
                                            return value+"${internationalConfig.张}";
                                        }
                                    },
                                    {
                                        field : 'vipCycle',
                                        title : '${internationalConfig.会员周期发放}',
                                        width : 100,
                                        sortable : false,
                                        formatter : function(value) {
                                            return value+"${internationalConfig.张}";
                                        }
                                    },
                                    {
                                        field : 'validPeriod',
                                        title : '${internationalConfig.有效期}',
                                        width : 100,
                                        sortable : false,
                                        formatter : function(value,row) {
                                            if(row.validPeriodUnit==1){
                                                return value+"${internationalConfig.个月}";
                                            }
                                            return value;
                                        }
                                    },
                                    {
                                        field : 'issueCycle',
                                        title : '${internationalConfig.发放周期}',
                                        width : 100,
                                        sortable : false,
                                        formatter : function(value,row) {
                                            if(row.issueCycleUnit==1){
                                                return value+"${internationalConfig.个月}";
                                            }
                                            return value;
                                        }
                                    },
                                    {
                                        field : 'operator',
                                        title : '${internationalConfig.操作人}',
                                        width : 100,
                                        sortable : false
                                    },
                                    {
                                        field : 'action',
                                        title : '${internationalConfig.操作}',
                                        width : 100,
                                        formatter : function(value, row, index) {
                                            var str = '';

                                            if ($.canEdit) {
                                                str += $
                                                        .formatString(
                                                                '<img onclick="editFun(\'{0}\');" src="{1}" title="${internationalConfig.编辑}"/>',
                                                                row.id,
                                                                '/static/style/images/extjs_icons/bug/bug_edit.png');
                                            }
                                            return str;
                                        }
                                    } ] ],
                                toolbar : '#toolbar',
                                onLoadSuccess : function(rows) {
                                    if(rows.total==1){
                                        $('.easyui-linkbutton').hide();
                                    }
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

            parent.$.modalDialog({
                title : '${internationalConfig.编辑观影卷发放规则}',
                width : 700,
                height : 400,
                href : '/movie_ticket_issued_rules/edit?id='
                + id,
                onClose:function(){
                    this.parentNode.removeChild(this);
                },
                buttons : [ {
                    text : '${internationalConfig.保存}',
                    handler : function() {
                        parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#form');
                        //submitFun(f);
                        f.submit();
                    }
                }, {
                    text : "${internationalConfig.取消}",
                    handler : function() {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                } ]
            });
        }

        function addFun(id) {
            parent.$.modalDialog({
                title : '${internationalConfig.添加观影卷发放规则}',
                width : 700,
                height : 400,
                href : '/movie_ticket_issued_rules/add?id=',
                onClose:function(){
                    this.parentNode.removeChild(this);
                },
                buttons : [ {
                    text : '${internationalConfig.增加}',
                    handler : function() {
                        parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#form');
                        //submitFun(f);
                        f.submit();
                    }
                }, {
                    text : "${internationalConfig.取消}",
                    handler : function() {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                } ]
            });
        }
        function submitFun(f){
            if(f.form("validate")){
                if(!validateMemberPrice())return false;
                parent.$.messager.progress({
                    title : '${internationalConfig.提示}',
                    text : '${internationalConfig.数据处理中}....'
                });
                $.ajax({
                    url:"/movie_ticket_issued_rules/save",
                    type:"post",
                    data:f.serializeJson(),
                    dataType:"json",
                    success:function(result){
                        parent.$.messager.progress('close');
                        /* result = $.parseJSON(result); */
                        if (result.code == 0) {
                            parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.添加成功}', 'success');
                            parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
                            parent.$.modalDialog.handler.dialog('close');
                        } else{
                            parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
                        }
                    },
                    error:function(){

                    }


                })
            }
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'',border:false,height:'auto'">
        <form id="searchForm">
            <table  class="table-more">
            </table>
        </form>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>
<div id="toolbar" style="display: none;">
    <a onclick="addFun();" href="javascript:void(0);"
       class="easyui-linkbutton"
       data-options="plain:true,iconCls:'pencil_add'">${internationalConfig.增加}</a>
</div>
</body>
</html>
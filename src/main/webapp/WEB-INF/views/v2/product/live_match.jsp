<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <title>${internationalConfig.直播赛事管理}</title>
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
    <script type="text/javascript">
        var dataGrid;
        (function($){
            $.fn.serializeJson=function(){

                var serializeObj={};
                var array=this.serializeArray();
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

            dataGrid = renderDataGrid('/v2/product/liveMatch/dataGrid');
        });

        function renderDataGrid(url) {
            return $('#dataGrid')
                    .datagrid(
                    {
                        url : url,
                        fit : true,
                        fitColumns : true,
                        border : false,
                        pagination : true,

                        idField : 'id',
                        pageSize : 20,
                        pageList : [ 10, 20, 30, 40, 50 ],
                        sortName : 'pid',
                        sortOrder : 'asc',
                        checkOnSelect : false,
                        selectOnCheck : false,
                        nowrap : false,
                        striped : true,
                        rownumbers : true,
                        singleSelect : true,
                        frozenColumns : [ [ {
                            field : 'ids',
                            title : '${internationalConfig.编号}',
                            width : 150,
                            hidden : true
                        } ] ],
                        columns : [ [
                            {
                                field : 'pid',
                                title : '${internationalConfig.频道}',
                                width : 120,
                                sortable : true,
                                formatter: function (value) {
                                    var channels={<c:forEach var="channel" items="${directList}">"${channel.id}":"${channel.description}",</c:forEach>};
                                    return channels[value];
                                }
                            },
                            {
                                field : 'description',
                                title : '${internationalConfig.赛事}',
                                width : 120,
                                sortable : true
                            },
                            {
                                field : 'action',
                                title : '${internationalConfig.操作}',
                                width : 100,
                                formatter : function(value, row, index) {
                                    var str = '';

                                    str += $
                                            .formatString(
                                            '<img onclick="editFun(\'{0}\',\'{1}\',\'{2}\');" src="{3}" title="${internationalConfig.编辑}"/>',
                                            row.id,row.pid,row.description,
                                            '/static/style/images/extjs_icons/bug/bug_edit.png');
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

        function editFun(id,pid,description) {
      
            if (id == undefined) {
                var rows = dataGrid.datagrid('getSelections');
                id = rows[0].id;
            }
            parent.$.modalDialog({
                title : '${internationalConfig.编辑赛事}',
                width : 720,
                height : 450,
                href : '/v2/product/liveMatch/liveMatchInfo?id='
                + id + "&pid=" + pid + "&description=" + encodeURIComponent(description),
                buttons : [ {
                    text : '${internationalConfig.保存}',
                    handler : function() {
                        parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#form');
                        submitFun(f, 2);
                    }
                } , {
                    text : "${internationalConfig.取消}",
                    handler : function() {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                } ]
            });
        }

        function addFun() {
            parent.$.modalDialog({
                title : '${internationalConfig.添加赛事}',
                width : 700,
                height : 450,
                <%--href : '${pageContext.request.contextPath}/v2/product/livePackage/livePackageInfo?id=',--%>
                href : '${pageContext.request.contextPath}/v2/product/liveMatch/liveMatchInfo?id=',
                buttons : [ {
                    text : '${internationalConfig.增加}',
                    handler : function() {
                        parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#form');

                        submitFun(f, 1);
                    }
                } , {
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
            parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.您是否要删除当前赛事}',
                    function(b) {
                        if (b) {
                            parent.$.messager.progress({
                                title : '${internationalConfig.提示}',
                                text : '${internationalConfig.数据处理中}....'
                            });
                            $.post(
                                    '${pageContext.request.contextPath}/v2/product/liveMatch/delete',
                                    {
                                        id : id
                                    },
                                    function(result) {
                                        if (result.code == 0) {
                                            parent.$.messager
                                                    .alert(
                                                    '${internationalConfig.提示}',
                                                    '${internationalConfig.删除成功}',
                                                    'info');
                                            dataGrid
                                                    .datagrid('reload');
                                        } else {
                                            parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.删除失败}', 'error');
                                        }
                                        parent.$.messager
                                                .progress('close');
                                    }, 'JSON');
                        }
                    });
        }
        function submitFun(f, submitType){
            if(f.form("validate")){
                parent.$.messager.progress({
                    title : '${internationalConfig.提示}',
                    text : '${internationalConfig.数据处理中}....'
                });
                $.ajax({
                    url:"/v2/product/liveMatch/save",
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
                            parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
                            parent.$.modalDialog.handler.dialog('close');
                        } else {
                            parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.编辑失败}', 'error');
                        }
                    },
                    error:function(){

                    }


                })
            }
        }
        function searchFun() {
            parent.$.messager.progress({
                title : '${internationalConfig.提示}',
                text : '${internationalConfig.数据处理中}....'
            });
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
            parent.$.messager.progress('close');
        }
        function cleanFun() {
            $('#searchForm select').val('');
            dataGrid.datagrid('load', {});
        }

        //终端设备联动
        $(function(){
            $("#matchId").change(function(){
                var matchId = $("#matchId").val();
                $.ajax({
                    url : "/v2/product/livePackage/get_match_info",
                    data : {
                        'pid' : matchId
                    },
                    success : function(result) {
                        var directIndex = null;
                        var optionsHtml = "";
                        var optionhtml = '<option value="" selected="selected">${internationalConfig.全部}</option>';
                        optionsHtml += optionhtml;
                        $("#itemId").empty();
                        for (directIndex in result) {
                            var directModel = result[directIndex];
                            var optionHtml = '<option value="'+directModel.id+'">'
                                    + directModel.description+  '</option>';
                            optionsHtml += optionHtml;
                        }
                        $("#itemId").html(optionsHtml);
                    },
                    dataType : "json",
                    cache : false
                });
            });
        });

    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.直播赛事管理}',border:false,height:'auto'">
        <form id="searchForm">
            <table class="table-td-four">
                <tr>
                    <td>${internationalConfig.频道}：<select class="span2" name="matchId" id="matchId">
                        <option value=""> ${internationalConfig.全部}</option>
                        <c:forEach items="${directList}" var="item">
                            <option value="${item.id}">${item.description}</option>
                        </c:forEach>
                        <%--<option value="04">${internationalConfig.体育频道}</option>--%>
                    </select></td>
                    <td>${internationalConfig.赛事}：<select class="span2" name="itemId" id="itemId">
                        <option value="">${internationalConfig.全部}</option>
                    </select></td>
                </tr>
            </table>
        </form>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>
<div id="toolbar" style="display: none;">
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">${internationalConfig.清空条件}</a>
</div>

</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>${internationalConfig.用户账户查询}</title>
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            dataGrid = $('#dataGrid').datagrid({
                url: '${pageContext.request.contextPath}/user_lepoint/data_grid.json',
                queryParams:$.serializeObject($('#searchForm')),
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
                        {
                            field: 'userid',
                            title: '${internationalConfig.用户ID}',
                            width: 150,
                            hidden: true
                        }
                    ]
                ],
                columns: [
                    [
                        {
                            field: 'userid',
                            title: '${internationalConfig.用户ID}',
                            width: 180,
                            sortable: false
                        },
                        {
                            field: 'username',
                            title: '${internationalConfig.用户名}',
                            width: 180,
                            sortable: false
                        },
                        {
                            field: 'lepoint',
                            title: '${internationalConfig.乐点总数}',
                            width: 180,
                            sortable: false
                        },
                        {
                            field: 'totalpoint',
                            title: '${internationalConfig.累计充值乐点数}',
                            width: 180,
                            sortable: false
                        } ,
                        {
                            field: 'couponStatus',
                            title: '${internationalConfig.代金券}',
                            width: 180
                        },
                        {
                            field: 'createdate',
                            title: '${internationalConfig.创建时间}',
                            width: 180,
                            sortable: false
                        },
                        {
                            field: 'updatedate',
                            title: '${internationalConfig.更新时间}',
                            width: 180,
                            sortable: false
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
        Date.prototype.format = function (format) {
            if (!format) {
                format = "yyyy-MM-dd hh:mm:ss";
            }
            var o = {
                "M+": this.getMonth() + 1, // month
                "d+": this.getDate(), // day
                "h+": this.getHours(), // hour
                "m+": this.getMinutes(), // minute
                "s+": this.getSeconds(), // second
                "q+": Math.floor((this.getMonth() + 3) / 3), // quarter
                "S": this.getMilliseconds()
                // millisecond
            };
            if (/(y+)/.test(format)) {
                format = format.replace(RegExp.$1, (this.getFullYear() + "")
                        .substr(4 - RegExp.$1.length));
            }
            for (var k in o) {
                if (new RegExp("(" + k + ")").test(format)) {
                    format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k]
                            : ("00" + o[k]).substr(("" + o[k]).length));
                }
            }
            return format;
        };
        //$('#win').window({
        //    collapsible:false,
        //    minimizable:false,
        //   maximizable:false
        //});
        function formatterdate(val, row) {
            var payDate = new Date(val);
            if (payDate = "Invalid Date") {
                return "";
            }
            return payDate.format("yyyy-MM-dd hh:mm:ss");
        }
        function searchFun() {
            var name = $('#userName').val();
            //if (name.length <= 0) {
            //$('#win').window('open');
            //alert('请输入完整的用户名！') ;
            //} else {
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
            //}
        }
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'">
        <form id="searchForm">
            <table class="table-td-two">
                <tr>
                    <th></th>
                    <td>${internationalConfig.用户ID}：<input id="userId" name="userId" value="${param.userId}"
                                    class="span2"></input>
                    </td>


                    <th></th>
                    <td></td>
                </tr>

            </table>
        </form>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>
<div id="toolbar" style="display: none;">
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a><a
        href="javascript:void(0);" class="easyui-linkbutton"
        data-options="iconCls:'brick_delete',plain:true"
        onclick="cleanFun();">${internationalConfig.清空条件}</a>
</div>
<!-- <div id="win" class="easyui-window" title="输入提示框" closed="true"
 collapsible="false" minimizable="false" maximizable="false" style="width:300px;height:100px;padding:5px;color: red;">
<font size="2">请输入完整的用户名! </font>
</div>  -->
</body>
</html>

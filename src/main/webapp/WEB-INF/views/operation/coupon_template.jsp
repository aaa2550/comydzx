<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh">
<head>
<title>${internationalConfig.代金券模板管理}</title>
<%@ include file="/WEB-INF/views/inc/head.inc" %>

<script type="text/javascript">
var dataGrid;
$(function () {
    dataGrid = renderDataGrid('/coupon_template/query.json');
});

function renderDataGrid(url) {
    return $('#dataGrid')
            .datagrid(
            {
                url: '/coupon_template/query.json?number='+Math.random(),
                fit: true,
                fitColumns: false,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 10,
                pageList: [ 10, 20, 30, 40, 50 ],
                sortName: 'id',
                sortOrder: 'desc',
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                striped: true,
                rownumbers: true,
                singleSelect: true,
                remoteSort: false,
                method: 'get',
                frozenColumns: [
                    []
                ],
                columns: [
                    [
                        {
                            field: 'id',
                            title: '${internationalConfig.模板}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID',
                            width: 60,
                            sortable: false
                        },
                        {
                            field: 'batchNo',
                            title: '${internationalConfig.批次号}',
                            width: 100,
                            sortable: false
                        },
                        {
                            field: 'couponCode',
                            title: '${internationalConfig.优惠码}',
                            width: 100,
                            sortable: true,
                            formatter: function (value) {
                                if (value > 0) {
                                    return value;
                                } else {
                                    return "";
                                }

                            }
                        },
                        {
                            field: 'ownerTypeName',
                            title: '${internationalConfig.代金券类型}',
                            width: 80,
                            sortable: true
                        },
                        {
                            field: 'issuerName',
                            title: '${internationalConfig.发放方}',
                            width: 80,
                            sortable: true
                        },
                        {
                            field: 'name',
                            title: '${internationalConfig.代金券名称}',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'amountFmt',
                            title: '${internationalConfig.代金券面额}',
                            width: 70,
                            sortable: true,
                            formatter: function (value) {
                                return value + "<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.元}";
                            }
                        },
                        {
                            field: 'startTime',
                            title: '${internationalConfig.有效开始时间}',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'endTime',
                            title: '${internationalConfig.有效结束时间}',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'createTime',
                            title: '${internationalConfig.创建时间}',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'statusName',
                            title: '${internationalConfig.状态}',
                            width: 60,
                            sortable: true
                        },
                        {
                            field: 'ext',
                            title: '${internationalConfig.备注}',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'issueNum',
                            title: '${internationalConfig.发放量}',
                            width: 60,
                            sortable: true
                        },
                        {
                            field: 'useNum',
                            title: '${internationalConfig.使用量}',
                            width: 60,
                            sortable: true
                        },
                        {
                            field: 'action',
                            title: '${internationalConfig.操作}',
                            width: 120,
                            formatter: function (value, row, index) {
                                var str = '&nbsp;&nbsp;';
                                if (true) {
                                    str += $
                                            .formatString(
                                                    '<a  href="#" onclick="editFun(\'{0}\');" src="{1}" title="${internationalConfig.修改}">${internationalConfig.修改}</a>',
                                                    row.id,
                                                    '${pageContext.request.contextPath}/style/images/extjs_icons/bug/bug_edit.png');
                                }
                                str += '&nbsp;&nbsp;';
                                if (true && row.status == 0) {
                                    str += $
                                            .formatString(
                                                    '<a href="#" onclick="freeze(\'{0}\');" src="{1}" title="${internationalConfig.冻结}">${internationalConfig.冻结}</a>',
                                                    row.id,
                                                    '${pageContext.request.contextPath}/style/images/extjs_icons/bug/bug_delete.png');
                                } else if (true && row.status == 1) {
                                    str += $
                                            .formatString(
                                                    '<a href="#" onclick="unfreeze(\'{0}\');" src="{1}" title="${internationalConfig.解冻}">${internationalConfig.解冻}</a>',
                                                    row.id,
                                                    '${pageContext.request.contextPath}/style/images/extjs_icons/bug/bug_delete.png');
                                }

                                str += '&nbsp;&nbsp;';
                                if (true) {
                                    str += $
                                            .formatString(
                                                    '<a href="${pageContext.request.contextPath}/coupon_template/' + row.id + '/detail.do" target="_blank" src="{1}" title="${internationalConfig.查看}">${internationalConfig.查看}</a>',
                                                    row.id,
                                                    '${pageContext.request.contextPath}/style/images/extjs_icons/bug/bug_delete.png');
                                }
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
}

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
function formatterdate(val, row) {
    if (val == null) {
        return "";
    }
    var payDate = new Date(val);
    return payDate.format("yyyy-MM-dd");
}

function exportExcel(batch) {
    if (batch == undefined) {
        var rows = dataGrid.datagrid('getSelections');
        batch = rows[0].batch;
    }
    var url = '${pageContext.request.contextPath}/lecordOperate/exportexcel?batch='
            + batch;
    //alert(url) ;
    location.href = url;
}

function editFun(id) {
    parent.$.modalDialog({
        title: '${internationalConfig.修改}',
        width: 600,
        height: 500,
        href: '${pageContext.request.contextPath}/coupon_template/' + id + '/edit.do',
        buttons: [
            {
                text: '${internationalConfig.确定}',
                handler: function () {
                    parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                    var f = parent.$.modalDialog.handler.find('#form');
                    f.submit();
                }
            }
        ]
    });
}

function addFun() {
    parent.$.modalDialog({
        title: '${internationalConfig.代金券模板生成}',
        width: 600,
        height: 500,
        href: '${pageContext.request.contextPath}/coupon_template/add.do',
        method: 'get',
        buttons: [
            {
                text: '${internationalConfig.添加}',
                handler: function () {
                    parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                    var f = parent.$.modalDialog.handler.find('#form');
                    f.submit();
                }
            }
        ]
    });
}

function searchFun() {
	renderDataGrid('/coupon_template/query.json?number'+Math.random()).datagrid('load', $.serializeObject($('#searchForm')));
}
function cleanFun() {
    $('#searchForm input').val('');
    dataGrid.datagrid('load', {});
}

//冻结操作
function freeze(couponCode) {

    parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.模板}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID:' + couponCode
            + ',${internationalConfig.确认冻结}？', function (b) {
        if (b) {
            parent.$.messager.progress({
                title: '${internationalConfig.提示}',
                text: '${internationalConfig.数据处理中}'
            });
            $.post('/coupon_template/'
                    + couponCode + '/freeze.json', function (result) {
                if (result.success) {
                    searchFun();
                } else {
                    parent.$.messager.alert('${internationalConfig.页面错误}', result.msg, 'error');
                }
                parent.$.messager.progress('close');
            }, 'JSON');
        }
    });
}

//解除冻结操作
function unfreeze(couponCode) {
    parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.模板}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID:' + couponCode
            + ',${internationalConfig.确认解冻}？', function (b) {
        if (b) {
            parent.$.messager.progress({
                title: '${internationalConfig.提示}',
                text: '${internationalConfig.数据处理中}'
            });
            $.post('${pageContext.request.contextPath}/coupon_template/'
                    + couponCode + '/unfreeze.json', function (result) {
                if (result.success) {
                    searchFun();
                } else {
                    parent.$.messager.alert('${internationalConfig.页面错误}', result.msg, 'error');
                }
                parent.$.messager.progress('close');
            }, 'JSON');
        }
    });
}
</script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false" style="height: 160px; overflow: hidden;">
        <form id="searchForm">
            <table class="table-more"
                   style="display: none;">
                <tr>
                    <td><label>${internationalConfig.模板}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>id：<input name="id"  value="">
                    </label></td>
                    <td>${internationalConfig.类型}：<select class="span2" name="ownerType">
                        <option value="0">${internationalConfig.代金券类型}</option>
                        <option value="1">${internationalConfig.公共代金券}</option>
                        <option value="2">${internationalConfig.私有代金券}</option>
                    </select>
                    </td>
                    <td>${internationalConfig.批次号}：<input class="span2" name="batchNo"/>
                    </td>

                </tr>
                <tr>
                    <td>${internationalConfig.生成日期}：<input data-options="width: 95" name="createDateBegin"
                                    class="easyui-datebox" value=""> <span
                            style="padding: 5px">-</span>
                        <input data-options="width: 95" name="createDateEnd"
                                                                 class="easyui-datebox" value="">
                    </td>
                    <td>${internationalConfig.有效日期}：<input data-options="width: 95" name="startTime" class="easyui-datebox"
                                    value=""> <span style="padding: 5px">-</span> <input
                            data-options="width: 95" name="endTime" class="easyui-datebox" value="">
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
    <a onclick="addFun();" href="javascript:void(0);"
       class="easyui-linkbutton" data-options="plain:true,iconCls:'bug_add'">${internationalConfig.代金券模板生成}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a><a
        href="javascript:void(0);" class="easyui-linkbutton"
        data-options="iconCls:'brick_delete',plain:true"
        onclick="cleanFun();">${internationalConfig.清空条件}</a>
</div>


</body>
</html>
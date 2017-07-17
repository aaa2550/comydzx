<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <title>${internationalConfig.代金券管理}</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
</head>
<body>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false" style="height: 80px; overflow: hidden;">
        <form id="searchForm">
            <table class="table-td-four" style="display: none;">
                <tr>
                    <td>${internationalConfig.批次号}:&nbsp;&nbsp;<input class="span2" name="batchId"/></td>
                    <td>${internationalConfig.代金券名称}:&nbsp;&nbsp;<input class="span2" name="name"/></td>
                    <td>${internationalConfig.代金券类型}:&nbsp;&nbsp;<select class="span2" name="type" id="type">
                            <option value="0">${internationalConfig.全部}</option>
                            <option value="1">${internationalConfig.预先生成}</option>
                            <option value="2">${internationalConfig.实时抽取}</option>
                        </select>
                    </td>
                    <td>${internationalConfig.状态}:&nbsp;&nbsp;
                        <select class="span2" name="status" id="status">
                            <option value="-1">${internationalConfig.全部}</option>
                            <option value="0">${internationalConfig.正常}</option>
                            <option value="1">${internationalConfig.已冻结}</option>
                            <option value="-2">${internationalConfig.已过期}</option>
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
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_go',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">${internationalConfig.清空条件}</a>
    <a onclick="confirmType();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'pencil_add'">${internationalConfig.创建}</a>
</div>

<div id="confirmDiv" style="display:none">
    <div>
        <div style="float: left;"><input type="radio" name="couponType" value="1"></div>
        <div style="marge-left: 5px"><h5>${internationalConfig.预先生成类}</h5></div>
        <div style="margin-left: 10px;margin-top: 5px;">${internationalConfig.适用于批量生成代金券批量导出从而执行线下渠道发放的场景}</div>
    </div>
    <div style="margin-top: 10px">
        <div style="float: left;"><input type="radio" name="couponType" value="2"></div>
        <div style="marge-left: 5px"><h5>${internationalConfig.实时抽取类}</h5></div>
        <div style="margin-left: 10px;margin-top: 5px;">${internationalConfig.适用于_实时抽取类文案}</div>
    </div>
</div>

<script src="/static/lib/date.js"></script>
<script type="text/javascript">
    var dataGrid;
    $(function () {
        dataGrid = renderDataGrid('/v2/coupon/header/datagrid?' + $('#searchForm').serialize());
    });

    function renderDataGrid(url) {
        return $('#dataGrid').datagrid({
            url: url,
            fit: true,
            fitColumns: true,
            border: false,
            pagination: true,
            idField: 'batchId',
            pageSize: 10,
            pageList: [ 10, 20, 30, 40, 50 ],
            sortName: 'batchId',
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
                        field: 'name',
                        title: '${internationalConfig.代金券名称}',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'batchId',
                        title: '${internationalConfig.批次号}',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'type',
                        title: '${internationalConfig.代金券类型}',
                        width: 80,
                        sortable: true,
                        formatter: function (value) {
                            var dict={"1":"${internationalConfig.预先生成}","2":"${internationalConfig.实时抽取}"};
                            return dict[value];
                        }
                    },
                    {
                        field: 'amount',
                        title: '${internationalConfig.面值}',
                        width: 50
                    },
                    {
                        field: 'totalQty',
                        title: '${internationalConfig.发行量}',
                        width: 50,
                        sortable: true
                    },
                    {
                        field: 'applicant',
                        title: '${internationalConfig.申请人}',
                        width: 100
                    },
                    {
                        field: 'relatedActivity',
                        title: '${internationalConfig.关联活动}',
                        width: 100
                    },
                    {
                        field: 'validDays',
                        title: '${internationalConfig.代金券有效期}',
                        width: 260,
                        sortable: true,
                        formatter: function (value,row,index) {
                            if (row.type == 1)
                                return row.validStartTime + " ${internationalConfig.至} " + row.validEndTime;
                            return row.validDays + " ${internationalConfig.天}";
                        }
                    },
                    {
                        field: 'validStartTime',
                        title: '${internationalConfig.实时抽取有效期}',
                        width: 260,
                        sortable: true,
                        formatter: function (value,row,index) {
                            return row.type==1 ? "" : value + " ${internationalConfig.至} " + row.validEndTime;
                        }
                    },
                    {
                        field: 'operator',
                        title: '${internationalConfig.操作人}',
                        width:80
                    },
                    {
                        field: 'createTime',
                        title: '${internationalConfig.创建时间}',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'status',
                        title: '${internationalConfig.状态}',
                        width: 100,
                        sortable: true,
                        formatter:function (value,row,index) {
                            if(Date.parse(row.validEndTime, 'yyyy-MM-dd HH:mm:ss')<new Date())
                                return '${internationalConfig.已过期}';
                            var statuses={0:'${internationalConfig.正常}',1:'${internationalConfig.已冻结}',5:'${internationalConfig.创建任务执行中}'};
                            return statuses[value];
                        }
                    },
                    {
                        field: 'action',
                        title: '${internationalConfig.操作}',
                        width: 120,
                        formatter: function (value, row, index) {
                            var str = '';
                            if(row.status==1&&Date.parse(row.validEndTime, 'yyyy-MM-dd HH:mm:ss')>new Date())
                                str += $.formatString('<a href="#" onclick="unfreeze({0})">${internationalConfig.解冻}<a>',row.batchId);
                            else if (row.status==0&&Date.parse(row.validEndTime, 'yyyy-MM-dd HH:mm:ss')>new Date()) {
                                str += $.formatString('<a href="#" onclick="freeze({0})">${internationalConfig.冻结}<a>',row.batchId);
                                str += $.formatString('&nbsp;&nbsp;&nbsp;<a href="#" onclick="edit({0},\'N\')">${internationalConfig.编辑}</a>',row.batchId);
                            }
                            str += $.formatString('<br><a href="#" onclick="edit({0},\'Y\')">${internationalConfig.查看}</a>',row.batchId);
                            str += $.formatString('&nbsp;&nbsp;&nbsp;<a href="#" onclick="exportExcel(this, {0})">${internationalConfig.导出}</a>',row.batchId);
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


    function exportExcel(aelemtn, batch) {
        var url = '/customTasks/addTask';
        var data = {taskType: "v2_coupon_export", taskJson: $.formatString("{\"batchId\":{0}}", batch), taskName: "${internationalConfig.导出代金券批次}"+batch};
        $.post(url, data, function (result) {
            if (result.success) {
                parent.$.messager.alert('${internationalConfig.成功}', "${internationalConfig.代金券导出任务生成成功消息}" + result.data, 'sucess');
            } else {
                parent.$.messager.alert('${internationalConfig.页面错误}', result.msg, 'error');
            }
            parent.$.messager.progress('close');
        }, 'JSON');
    }

    function edit(id,readOnly) {
        parent.$.modalDialog({
            title:  readOnly=='Y'?'${internationalConfig.查看}':'${internationalConfig.修改}',
            width: 500,
            height: 520,
            href: '${pageContext.request.contextPath}/v2/coupon/header/edit?batchId='+id+"&readOnly="+readOnly,
            buttons: readOnly=='Y'?[
                {
                    text: '${internationalConfig.确定}',
                    handler: function () {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                }
            ]:[
                {
                    text: '${internationalConfig.保存}',
                    handler: function () {
                        parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#form');
                        f.submit();
                    }
                },
                {
                    text: '${internationalConfig.取消}',
                    handler: function () {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                }
            ]
        });
    }

    function add(type) {
        var titles={1:"${internationalConfig.创建预先生成类代金券}",2:"${internationalConfig.创建实时抽取类代金券}"};
        parent.$.modalDialog({
            title: titles[type],
            width: 500,
            height: 500,
            href: '${pageContext.request.contextPath}/v2/coupon/header/create?type='+type,
            buttons: [
                {
                    text: '${internationalConfig.保存}',
                    handler: function () {
                        parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#form');
                        f.submit();
                    }
                },
                {
                    text: '${internationalConfig.取消}',
                    handler: function () {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                }
            ]
        });
    }

    function confirmType() {
        $.messager.confirm("${internationalConfig.创建代金券}", $('#confirmDiv').html(),function (r) {
            if (r) {
                var type=$('.messager-window').find("input[type=radio]:checked");
                if (type.length==0) {
                    return false;
                }
                add(type.val());
            }
        });
        var win = $('.messager-window');
        win.css('width',500);
        win.find('.window-header').css('width',500);
        win.find('.messager-body').css('width',478);
        win.find('.messager-question').hide();
        $('.window-shadow').hide();
        $(".messager-button a.l-btn:first").hide();
        $('.messager-window').find("input[type=radio]").click(function(e) {
            $(".messager-button a.l-btn:first").show();
        });
    }

    function searchFun() {
        dataGrid = renderDataGrid('/v2/coupon/header/datagrid?' + $('#searchForm').serialize());
    }
    function cleanFun() {
        $('#searchForm input').val('');
        $("#status").val('-1');
        $("#type").val('0');
        dataGrid.datagrid('load', {});
    }

    //冻结操作
    function freeze(batchId) {
        parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.你是否要冻结当前批次代金券} ' + batchId, function (b) {
            if (b) {
                parent.$.messager.progress({
                    title: '${internationalConfig.提示}',
                    text: '${internationalConfig.数据处理中}'
                });
                $.post('/v2/coupon/header/freeze?batchId='+batchId, function (result) {
                    if (result.success) {
                        parent.$.messager.alert('${internationalConfig.成功}', "${internationalConfig.冻结成功}", 'success');
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
    function unfreeze(batchId) {
        parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.你是否要解冻当前批次代金券}' + batchId, function (b) {
            if (b) {
                parent.$.messager.progress({
                    title: '${internationalConfig.提示}',
                    text: '${internationalConfig.数据处理中}'
                });
                $.post('/v2/coupon/header/unfreeze?batchId='+batchId, function (result) {
                    if (result.success) {
                        parent.$.messager.alert('${internationalConfig.成功}', "${internationalConfig.解冻成功}", 'success');
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
</body>
</html>
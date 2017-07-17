<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <title>${internationalConfig.代金券查询}</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
</head>
<body>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false" style="height: 80px; overflow: hidden;">
        <form id="searchForm">
            <table class="table-td-four" style="display: block;">
                <tr>
                    <td>${internationalConfig.批次号}:&nbsp;&nbsp;<input class="span2" name="batchId" id="batchId"/></td>
                    <td>${internationalConfig.代金券券号}:&nbsp;&nbsp;<input class="span2" name="code" id="code"/></td>
                    <td>${internationalConfig.状态}:&nbsp;&nbsp;
                        <select class="span2" name="status">
                            <option value="-1">${internationalConfig.全部}</option>
                            <option value="20">${internationalConfig.未使用}</option>
                            <option value="3">${internationalConfig.已锁定}</option>
                            <option value="4">${internationalConfig.已使用}</option>
                            <option value="1">${internationalConfig.已冻结}</option>
                            <option value="-2">${internationalConfig.已过期}</option>
                        </select>
                    </td>
                    <td>&nbsp;</td>
                </tr>
            </table>
        </form>
    </div>
    <div id="toolbar" style="display: block;">
        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_go',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">${internationalConfig.清空条件}</a>
        <%--<a onclick="confirmType();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'pencil_add'">${internationalConfig.创建}</a>--%>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>

<script src="/static/lib/date.js"></script>
<script type="text/javascript">
    var dataGrid;
    $(function () {
        dataGrid = renderDataGrid('');
    });

    function renderDataGrid(url) {
        return $('#dataGrid').datagrid({
            url: url,
            fit: true,
            fitColumns: true,
            border: false,
            pagination: true,
            idField: 'couponCode',
            pageSize: 10,
            pageList: [ 10, 20, 30, 40, 50 ],
            sortName: 'code',
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
                        width: 100
                    },
                    {
                        field: 'code',
                        title: '${internationalConfig.代金券券号}',
                        width: 100
                    },
                    {
                        field: 'batchId',
                        title: '${internationalConfig.批次号}',
                        width: 100
                    },
                    {
                        field: 'type',
                        title: '${internationalConfig.代金券类型}',
                        width: 80,
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
                        field: 'createTime',
                        title: '${internationalConfig.创建时间}',
                        width: 100
                    },
                    {
                        field: 'validStartTime',
                        title: '${internationalConfig.代金券有效期}',
                        width: 260,
                        formatter: function (value,row,index) {
                            return value + " ${internationalConfig.至} " + row.validEndTime;
                        }
                    },
                    {
                        field: 'bindTime',
                        title: '${internationalConfig.发放时间}',
                        width: 100
                    },
                    {
                        field: 'useTime',
                        title: '${internationalConfig.使用时间}',
                        width: 100
                    },
                    {
                        field: 'ownerId',
                        title: '${internationalConfig.绑定ID}',
                        width: 100,
                        formatter: function (value) {
                            return value==0?"":value;
                        }
                    },
                    {
                        field: 'userId',
                        title: '${internationalConfig.使用ID}',
                        width: 100,
                        formatter: function(value) {
                            return value==0?"":value;
                        }
                    },
                    {
                        field: 'status',
                        title: '${internationalConfig.状态}',
                        width: 100,
                        formatter:function (value,row,index) {
                            if(Date.parse(row.validEndTime, 'yyyy-MM-dd HH:mm:ss')<new Date())
                                return '${internationalConfig.已过期}';
                            var statuses={0:'${internationalConfig.未使用}',1:'${internationalConfig.已冻结}',2:'${internationalConfig.未使用}',3:'${internationalConfig.已锁定}',4:'${internationalConfig.已使用}'};
                            return statuses[value];
                        }
                    },
                    {
                        field: 'action',
                        title: '${internationalConfig.操作}',
                        width: 120,
                        formatter: function (value, row, index) {
                            var str = '';
                            if(row.status==1)
                                str += $.formatString('<a href="#" onclick="unfreeze(\'{0}\')">${internationalConfig.解冻}<a>',row.code);
                            else if (row.status!=3&&row.status!=4&&Date.parse(row.validEndTime, 'yyyy-MM-dd HH:mm:ss')>new Date())
                                str += $.formatString('<a href="#" onclick="freeze(\'{0}\')">${internationalConfig.冻结}<a>',row.code);
                            return str;
                        }
                    }
                ]
            ],
            toolbar: '#toolbar',
            onLoadSuccess: function (result) {
                $('#searchForm table').show();
                $(".pagination-last").parent().parent().hide();
                $(".pagination-num").attr('readonly','readonly');
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
        if ($.trim($("#code").val())=='' && $.trim($("#batchId").val()) == '') {
            parent.$.messager.alert('${internationalConfig.页面错误}', '${internationalConfig.请输入查询条件}', 'error');
            return;
        }
        /*$("#code").val($.trim($("#code").val()));
        $("#batchId").val($.trim($("#batchId").val()));
        if ($("#batchId").val()!=''&&isNaN(batchId)) {
            $("#batchId").val('');
            return;
        }*/
        dataGrid = renderDataGrid('/v2/coupon/item/datagrid?' + $('#searchForm').serialize());
    }
    function cleanFun() {
        $('#searchForm input').val('');
        $("#searchForm select").val('-1');
        dataGrid.datagrid('load', {});
    }

    //冻结操作
    function freeze(code) {
        parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.你是否要冻结当前代金券券号} ' + code, function (b) {
            if (b) {
                parent.$.messager.progress({
                    title: '${internationalConfig.提示}',
                    text: '${internationalConfig.数据处理中}'
                });
                $.post('/v2/coupon/item/freeze?code='+code, function (result) {
                    if (result.success) {
                        parent.$.messager.alert('${internationalConfig.成功}', "${internationalConfig.冻结成功}", 'success');
                        searchFun();
                    } else {
                        parent.$.messager.alert('${internationalConfig.成功}', result.msg, 'success');
                    }
                    parent.$.messager.progress('close');
                }, 'JSON');
            }
        });
    }

    //解除冻结操作
    function unfreeze(code) {
        parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.你是否要解冻当前代金券券号} ' + code, function (b) {
            if (b) {
                parent.$.messager.progress({
                    title: '${internationalConfig.提示}',
                    text: '${internationalConfig.数据处理中}'
                });
                $.post('/v2/coupon/item/unfreeze?code='+code, function (result) {
                    if (result.success) {
                        parent.$.messager.alert('${internationalConfig.成功}', "${internationalConfig.解冻成功}", 'success');
                        searchFun();
                    } else {
                        parent.$.messager.alert('${internationalConfig.成功}', result.msg, 'success');
                    }
                    parent.$.messager.progress('close');
                }, 'JSON');
            }
        });
    }
    $.fn.pagination.defaults.nav.next.handler=function(){
        var options=$(this).pagination("options");
        if (options.pageNumber>=10){
            parent.$.messager.alert('${internationalConfig.错误消息}', "${internationalConfig.页面上最多展示10页数据}", 'error');
            return;
        }
        var total=Math.ceil(options.total/options.pageSize);
        if(options.pageNumber<total){
            $(this).pagination("select",options.pageNumber+1);
        }
    };
    $.fn.pagination.defaults.nav.last.handler=function(){
        return;
    };
    //var defaultChangePaginationAction=$(".pagination-num").change;
</script>
</body>
</html>
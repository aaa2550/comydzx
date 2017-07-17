<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>机卡绑定信息查询</title>
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
    <script type="text/javascript">
        var dataGrid;
        $(function() {
            dataGrid = $('#dataGrid')
                    .datagrid(
                    {
                        url: '/v2/machine_card/query_list',
                        fit : true,
                        fitColumns : true,
                        border : false,
                        pagination : true,
                        idField : 'id',
                        pageSize : 50,
                        pageList : [ 20, 50, 100, 1000 ],
                        checkOnSelect : false,
                        selectOnCheck : false,
                        nowrap : false,
                        striped : true,
                        rownumbers : true,
                        singleSelect : true,
                        frozenColumns : [ [ {
                            field : 'id',
                            title : '${internationalConfig.编号}',
                            width : 80,
                            hidden : true
                        },] ],
                        columns : [[{
                            field : 'deviceTypeName',
                            title : '${internationalConfig.绑定设备类型}',
                            width : 150
                        },{
                            field : 'sn',
                            title : '${internationalConfig.SN码}',
                            width : 130
                        },{
                            field : 'mac',
                            title : '${internationalConfig.MAC地址}',
                            width : 150
                        },{
                            field : "deviceKey",
                            title : '${internationalConfig.设备暗码}',
                            width : 150
                        },{
                            field : 'productName',
                            title : '${internationalConfig.会员名称}',
                            width : 150
                        },{
                            field : 'bindDuration',
                            title : '${internationalConfig.绑定时间}',
                            width : 100,
                            formatter:function(value, row){
                                if (row.bindDurationUnit == 1){
                                    return value + "${internationalConfig.年}";
                                } else if (row.bindDurationUnit == 2){
                                    return value + "${internationalConfig.个月}";
                                } else if (row.bindDurationUnit == 5){
                                    return value + "${internationalConfig.天}";
                                }

                            }
                        }<%--, {
                            field : 'cardDuration',
                            title : '${internationalConfig.兑换卡时长}',
                            width : 130,
                            formatter:function(value){
                                if(value>0){
                                    return (value/31)+"${internationalConfig.个月}" ;
                                }else{
                                    return "0" ;
                                }
                            }
                        }--%>, {
                            field : 'activeUserId',
                            title : '${internationalConfig.绑定用户ID}',
                            width : 150,
                            formatter: function(value){
                                if(value==0){
                                    return "";
                                }
                                return value;
                            }
                        }, {
                            field : 'activeTime',
                            title : '${internationalConfig.用户激活时间}',
                            width : 150
                        },{
                            field : 'vipEndTime',
                            title : '${internationalConfig.会员有效期}',
                            width : 150
                        },{
                            field : 'type',
                            title : '${internationalConfig.机卡会员类型}',
                            width : 150,
                            formatter: function(value){
                                if(value==0){
                                    return "${internationalConfig.设备上报}";
                                }else if(value==1){
                                    return "${internationalConfig.绑定领取}";
                                }else if(value==2){
                                    return "${internationalConfig.兑换码兑换}";
                                }
                                return "";
                            }
                        }, {
                            field : 'status',
                            title : '${internationalConfig.会员状态}',
                            width : 130,
                            formatter: function(value){
                                if (value == 1){
                                    return "${internationalConfig.设备上报}";
                                }else if (value == 2){
                                    return "${internationalConfig.已同步时长}";
                                }else if (value == 4){
                                    return "${internationalConfig.领取中}";
                                }else if (value == 6){
                                    return "${internationalConfig.已领取}";
                                }else if (value == 9){
                                    return "${internationalConfig.已退货}";
                                }
                            }
                        }
                         <m:auth uri="/v2/machine_card/toSyncTime">
                            ,{
                                field: 'action',
                                title: '${internationalConfig.操作}',
                                width: 200,
                                formatter: function (value, row, index) {
                                    var str = '&nbsp;&nbsp;&nbsp;';
                                    if(row.status == 1 || row.status == 2){
                                        str += $.formatString('<a href="javascript:void(0);" onclick="longTime(\'{0}\',\'{1}\');">${internationalConfig.同步时长}</a>', row.deviceKey, row.mac);
                                    }else if(row.status == 6){
                                        str += $.formatString('<a href="javascript:void(0);" onclick="unbindFun(\'{0}\',\'{1}\',\'{2}\',\'{3}\');">${internationalConfig.解绑}</a>', row.deviceKey, row.mac, row.activeUserId, row.productId);
                                    }
                                    return str;
                                }


                            }
                          </m:auth>
                        ] ],
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
        });

        function searchFun() {
            var data=$.serializeObject($('#searchForm'));
            //console.log(data);
            if(data.sn==""&&data.mac==''){
                $('#lt').hide();
            }else{
                $('#lt').show();
            }
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }
        function longTime(deviceKey, mac) {
            if(mac!=''){
                parent.$.modalDialog({
                    title: '${internationalConfig.同步设备时长}',
                    width: 390,
                    height: 400,
                    href: '/v2/machine_card/getSyncTimePage?deviceKey=' + deviceKey + '&mac=' + mac,
                    buttons: [
                        {
                            text: '${internationalConfig.提交}',
                            handler: function () {
                                parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                                var f = parent.$.modalDialog.handler.find('#form');
                                f.submit();
                            }
                        }
                    ]
                });

            }
        }

        //同步时长
        function syscTime(mac,deviceKey) {
            parent.$.modalDialog({
                title: '${internationalConfig.同步设备时长}',
                width: 320,
                height: 200,
                //href: '/device/tosynctime?mac='+mac+'&vipType='+vipType,
                href: '/v2/machine_card/toSyncTime?mac='+mac+'&deviceKey='+deviceKey,
                buttons: [
                    {
                        text: '${internationalConfig.提交}',
                        handler: function () {
                            parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                            var f = parent.$.modalDialog.handler.find('#form');
                            f.submit();
                        }
                    }
                ]
            });
        }


        //解绑操作
        function unbindFun(deviceKey, mac, userId, productId) {
            parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.询问是否解除绑定}', function (b) {
                if (b) {
                    parent.$.messager.progress({
                        title: '${internationalConfig.提示}',
                        text: '${internationalConfig.数据处理中请稍后}....'
                    });
                    $.post('/v2/machine_card/unbind', {
                        deviceKey: deviceKey, mac: mac, userId: userId, productId: productId
                    }, function (obj) {
                        if (obj.code == 0) {
                            searchFun();
                        }else {
                            parent.$.messager
                                    .alert(
                                    '${internationalConfig.解绑失败}',
                                    obj.msg,
                                    'error');
                        }
                        parent.$.messager.progress('close');
                    }, 'JSON');
                }
            });
        };

        //上传设备信息页面
        function uploadDevice() {
            parent.$.modalDialog({
                title: '${internationalConfig.上传设备信息}',
                width: 550,
                height: 350,
                href: '/v2/machine_card/toUpload',
                buttons: [
                    {
                        text: '${internationalConfig.上传}',
                        handler: function () {
                            parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                            var f = parent.$.modalDialog.handler.find('#form');
                            f.submit();
                        }
                    }
                ]
            });
        }

        //电视、盒子退货操作
        function returnTV(mac,deviceType) {
            parent.$.messager.confirm('${internationalConfig.询问}', '您是否确认退货？', function (b) {
                if (b) {
                    parent.$.messager.progress({
                        title: '${internationalConfig.提示}',
                        text: '数据处理中，请稍后....'
                    });
                    $.post('/device/return_tv.json', {
                        mac:mac,deviceType:deviceType
                    }, function (obj) {
                        if (obj.code == 0) {
                            parent.$.messager.alert('退货成功',obj.msg,'success');
                            searchFun();
                        }else {
                            parent.$.messager.alert('退货失败',obj.msg);
                        }
                        parent.$.messager.progress('close');
                    }, 'JSON');
                }
            });
        };
        //电视、盒子B2B换货操作
        function changeB2B(mac,deviceType) {
            parent.$.modalDialog({
                title: '换货',
                width: 320,
                height: 200,
                href: '/device/tochangeb?mac='+mac+'&deviceType='+deviceType,
                buttons: [
                    {
                        text: '${internationalConfig.提交}',
                        handler: function () {
                            parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                            var f = parent.$.modalDialog.handler.find('#form');
                            f.submit();
                        }
                    }
                ]
            });
        }
        //电视、盒子B2C换货操作
        function changeB2C(mac,deviceType) {
            parent.$.modalDialog({
                title: 'B2C换货',
                width: 320,
                height: 200,
                href: '/device/tochangec?mac='+mac+'&deviceType='+deviceType,
                buttons: [
                    {
                        text: '${internationalConfig.提交}',
                        handler: function () {
                            parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                            var f = parent.$.modalDialog.handler.find('#form');
                            f.submit();
                        }
                    }
                ]
            });
        }
        //手机退货操作
        function returnM(mac,deviceType) {
            parent.$.messager.confirm('询问', '您是否确认退货？', function (b) {
                if (b) {
                    parent.$.messager.progress({
                        title: '提示',
                        text: '数据处理中，请稍后....'
                    });
                    $.post('/device/return_mobile.json', {
                        mac:mac,deviceType:deviceType
                    }, function (obj) {
                        if (obj.code == 0) {
                            parent.$.messager.alert('退货成功',obj.msg,'success');
                            searchFun();
                        }else {
                            parent.$.messager.alert('退货失败',obj.msg);
                        }
                        parent.$.messager.progress('close');
                    }, 'JSON');
                }
            });
        };
        //手机换货操作
        function changeM(mac,deviceType) {
            parent.$.modalDialog({
                title: '换货',
                width: 320,
                height: 200,
                href: '/device/tochangeMobile?mac='+mac+'&deviceType='+deviceType,
                buttons: [
                    {
                        text: '${internationalConfig.提交}',
                        handler: function () {
                            parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                            var f = parent.$.modalDialog.handler.find('#form');
                            f.submit();
                        }
                    }
                ]
            });
        }

        //手机维修操作
        function repairM(mac,deviceType) {
            parent.$.modalDialog({
                title: '维修',
                width: 320,
                height: 200,
                href: '/device/torepairMobile?mac='+mac+'&deviceType='+deviceType,
                buttons: [
                    {
                        text: '${internationalConfig.提交}',
                        handler: function () {
                            parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                            var f = parent.$.modalDialog.handler.find('#form');
                            f.submit();
                        }
                    }
                ]
            });
        }


    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
         style="height: 80px; overflow: hidden;">
        <form id="searchForm">
            <table class="table-td-three"
                   style="display: none;">
                <tr>
                    <td>
                        ${internationalConfig.设备码}：
                        <input id="deviceKey" name="deviceKey" class="easyui-validatebox"/>
                    </td>
                    <td>
                        &nbsp;&nbsp;${internationalConfig.用户ID}：
                        <input id="userId" name="userId" class="easyui-validatebox"/>
                    </td>
                    <td>
                        &nbsp;&nbsp;SN：
                        <input id="sn" name="sn" class="easyui-validatebox"/>
                    </td>
                    <td>
                        &nbsp;&nbsp;MAC / IMEI：
                        <input id="mac" name="mac" class="easyui-validatebox"/>
                    </td>
                    <th></th>
                </tr>
            </table>
        </form>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>
<div id="toolbar" style="display: none;">
    <m:auth uri="/v2/machine_card/upload">
    <a onclick="uploadDevice();" href="javascript:void(0);"
       class="easyui-linkbutton" data-options="plain:true,iconCls:'bug_add'">${internationalConfig.上传设备信息}</a>
    </m:auth>
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a><a
        href="javascript:void(0);" class="easyui-linkbutton"
        data-options="iconCls:'brick_delete',plain:true"
        onclick="cleanFun();">${internationalConfig.清除条件}</a><%--<a href="javascript:void(0);" id="lt" class="easyui-linkbutton"
                                         data-options="iconCls:'brick_add',plain:true"
                                         onclick="longTime();">${internationalConfig.同步时长}</a>--%>
    <m:auth uri="/v2/machine_card/batch_sync_vip_duration.do">
    <a onclick="batchSync();" href="javascript:void(0);"
       class="easyui-linkbutton" data-options="plain:true,iconCls:'bug_add'">${internationalConfig.批量同步会员时长}</a>
    </m:auth>
</div>
<m:auth uri="/v2/machine_card/batch_sync_vip_duration.do">
<script>
    function batchSync() {
        parent.$.modalDialog({
            title: '${internationalConfig.批量同步会员时长}',
            width: 600,
            height: 380,
            href: '/v2/machine_card/batch_sync_vip_duration.do',
            buttons: [
                {
                    text: '${internationalConfig.上传}',
                    handler: function () {
                        parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#form');
                        f.submit();
                    }
                },
                {
                    text : "${internationalConfig.取消}",
                    handler : function() {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                }
            ]
        });
    }
</script>
</m:auth>
</body>
</html>
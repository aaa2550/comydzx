<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>${internationalConfig.版权信息}</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">
        var dataGrid;
        $(function () {

            dataGrid = $('#dataGrid').datagrid({
                url: '/share_details/find',
                fit: true,
                fitColumns: true,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 10,
                pageList: [10, 20, 30, 40, 50],
                checkOnSelect: false,
                selectOnCheck: false,
                singleSelect: true,
                nowrap: false,
                rownumbers: true,
                frozenColumns: [
                    [
                        {
                            field: 'id',
                            title: '${internationalConfig.编号}',
                            width: 50,
                            hidden: true
                        }
                    ]
                ],
                columns: [[{
                    field: 'month',
                    title: '${internationalConfig.结算年月}',
                    width: 100
                }, {
                    field: 'cid',
                    title: 'CPID',
                    width: 100
                }, {
                    field: 'cpName',
                    title: '${internationalConfig.CP名称}',
                    width: 100
                }, {
                    field: 'albumId',
                    title: '${internationalConfig.专辑ID}',
                    width: 100
                }, {
                    field: 'albumName',
                    title: '${internationalConfig.专辑名称}',
                    width: 100
                }, {
                    field: 'configType',
                    title: '${internationalConfig.分成类型}',
                    width: 100,
                    formatter: function (value, row, index) {
                        var str = '';
                        switch (value) {
                            case 1:
                                str = '${internationalConfig.付费分成}';
                                break;
                            case 2:
                                str = '${internationalConfig.CPM分成}';
                                break;
                            case 3:
                                str = '${internationalConfig.播放分成}';
                                break;
                            case 4:
                                str = '${internationalConfig.累计时长分成}';
                                break;
                            case 5:
                                str = '${internationalConfig.会员订单分成}';
                                break;
                            case 6:
                                str = '${internationalConfig.业务订单分成}';
                                break;
                            default:
                                str = '${internationalConfig.未定义}';
                        }
                        return str;
                    }
                }, {
                    field: 'money',
                    title: '${internationalConfig.总金额}',
                    width: 100
                }, {
                    field: 'bossRatio',
                    title: '${internationalConfig.系数}',
                    width: 100
                }, {
                    field: 'bossMoney',
                    title: '${internationalConfig.对外金额}',
                    width: 100
                }, {
                    field: 'status',
                    title: '${internationalConfig.结算状态}',
                    width: 100,
                    formatter: function (value, row, index) {
                        var str = '';
                        switch (value) {
                            case 0:
                                str = '${internationalConfig.未结算}';
                                break;
                            case 1:
                                str = '${internationalConfig.结算中}';
                                break;
                            case 2:
                                str = '${internationalConfig.已结算}';
                                break;
                            default:
                                str = '${internationalConfig.未定义}';
                        }
                        return str;
                    }
                }, {
                    field: 'applyTime',
                    title: '${internationalConfig.申请时间}',
                    width: 100
                }, {
                    field: 'closeTime',
                    title: '${internationalConfig.结算时间}',
                    width: 100
                }, {
                    field: 'action',
                    title: '${internationalConfig.操作}',
                    width: 100,
                    formatter: function (value, row, index) {
                        var dataTime = new Date(row.month.substring(0, 4), row.month.substring(4, 6), 1).getTime();
                        var before6Months = new Date().getTime() - (1000 * 60 * 60 * 24 * 155);
                        if (!row.totalMoney && dataTime < before6Months) {
                            return '--';
                        }

                        switch (row.status) {
                            case 0:
                                return $.formatString("<a href='javascript:void(0);' onclick='changeStatus(" + row.month + "," + row.ruleId + ")'>${internationalConfig.结算}</a>", row.id);
                                break;
                            case 1:
                                return $.formatString("<a target='_blank' href='/share_details/toDetails?albumId=" + row.albumId + "&configType=" + row.configType + "&month=" + row.month + "'>${internationalConfig.查看明细}</a>", row.id);
                                break;
                            case 2:
                                return $.formatString("<a target='_blank' href='/share_details/toDetails?albumId=" + row.albumId + "&configType=" + row.configType + "&month=" + row.month + "'>${internationalConfig.查看明细}</a>", row.id);
                                break;
                            default:
                                return '${internationalConfig.未定义}';
                        }
                    }
                }]],
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
            /* $('startTime').datebox({
                onSelect: function (date) {
                    alert(date.getFullYear() + ":" + (date.getMonth() + 1) + ":" + date.getDate());
                }
            }); */
        });

        function changeStatus(month, ruleId) {
            parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.是否结算}', function (flag) {
                if (flag) {
                    var url = '/share_details/changeStatus?month=' + month + '&ruleId=' + ruleId;
                    $.get(url, function (result) {
                        var json = $.parseJSON(result);
                        if (json.code == 0) {
                            parent.$.messager.alert('${internationalConfig.Success}', '${internationalConfig.操作成功}', 'success');
                            dataGrid.datagrid('reload');
                        } else {
                            parent.$.messager.alert('${internationalConfig.Error}', json.msg, 'error');
                        }
                    });
                }
            });
        }

        function searchFun() {

            var albumId = $("input[name='albumId']").val();
            var reg = new RegExp("^[0-9]*$");
            if (!reg.test(albumId)) {
                parent.$.messager.alert('${internationalConfig.提示}', "${internationalConfig.专辑ID只能查询中文}", 'info');
                return;
            }

            if (albumId == '0') {
                parent.$.messager.alert('${internationalConfig.提示}', "${internationalConfig.专辑ID不能为0}", 'info');
                return;
            }

            dataGrid.datagrid({
                url: '/share_details/find',
                queryParams: $.serializeObject($('#searchForm'))
            });
        }

        function myformatter(date) {
            var y = date.getFullYear();
            var m = date.getMonth() + 1;
            return y + "" + (m < 10 ? ('0' + m) : m);
        }
        function myparser(s) {
            if (!s) return new Date();
            s = s + '';
            var y = s.substr(0, 4);
            var m = s.substr(4, 6);
            if (!isNaN(y) && !isNaN(m)) {
                return new Date(y, m - 1);
            } else {
                return new Date();
            }
        }

        function exportFile() {
            var startTime = $("input[name='startTime']").val();
            var endTime = $("input[name='endTime']").val();
            var configType = $("select[name='configType']").val();
            var albumId = $("input[name='albumId']").val();
            var albumName = $("input[name='albumName']").val();

            var url = '/share_details/export?startTime=' + startTime + '&endTime=' + endTime + '&configType=' + configType + ''
                    + '&albumId=' + albumId + '&albumName' + albumName;
            location.href = url;
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false" style="height: 120px; overflow: hidden;">
        <form id="searchForm">
            <table class="table-more">
                <tr>
                    <td>${internationalConfig.结算年月}：<input name="startTime" class="start-time easyui-datebox"
                                    data-options="formatter:myformatter,parser:myparser"/> - <input name="endTime"
                                                                                                    class="end-time easyui-datebox"
                                                                                                    data-options="formatter:myformatter,parser:myparser"/>
                    </td>
                    <td>${internationalConfig.分成类型}：<select name="configType">
                        <option value="">${internationalConfig.全部}</option>
                        <option value="1">${internationalConfig.付费分成}</option>
                        <option value="2">${internationalConfig.CPM分成}</option>
                        <option value="3">${internationalConfig.播放分成}</option>
                        <option value="4">${internationalConfig.累计时长分成}</option>
                        <option value="5">${internationalConfig.会员订单分成}</option>
                        <option value="5">${internationalConfig.业务订单分成}</option>
                    </select></td>
                </tr>
                <tr>
                    <td>${internationalConfig.专辑ID}：<input name="albumId" placeholder="${internationalConfig.请输入专辑ID}" class="span2"/></td>
                    <td>${internationalConfig.专辑名称}：<input name="albumName" placeholder="${internationalConfig.专辑名称}" class="span2"/></td>
                </tr>
            </table>
        </form>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>
<div id="toolbar" style="display: none;">

    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true"
       onclick="searchFun();">${internationalConfig.过滤条件}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="exportFile();">${internationalConfig.导出数据}</a>
</div>

</body>
</html>
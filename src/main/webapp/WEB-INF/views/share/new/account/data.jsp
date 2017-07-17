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
        var patamConfigType = 1;
        $(function () {
            reload_data(1);
            $('.easyui-tabs').tabs({
                border:false,
                onSelect:function(title,index){
                    switch (index) {
                        case 0:
                            reload_data(1);
                            break;
                        case 1:
                            reload_data(3);
                            break;
                        case 2:
                            reload_data(4);
                            break;
                        case 3:
                            reload_data(2);
                            break;
                        case 4:
                            reload_data(5);
                            break;
                        case 5:
                            reload_data(6);
                            break;
                    }
                }
            });
        });

        function reload_data(configType) {
            patamConfigType = configType;
            switch (configType) {
                case 1:
                    dataGrid = $('#dataGrid1').datagrid({
                        url: '/account/data/find?configType=' + configType,
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
                        columns: [[{
                            field: 'time',
                            title: '${internationalConfig.结算年月}',
                            width: 70,
                            formatter: function (value, row, index) {
                                return value.substring(0,7);
                            }
                        }, {
                            field: 'cid',
                            title: 'CPID',
                            width: 50
                        }, {
                            field: 'cpName',
                            title: '${internationalConfig.CP名称}',
                            width: 250
                        }, {
                            field: 'copyrightType',
                            title: '${internationalConfig.类别}',
                            width: 50,
                            formatter: function (value, row, index) {
                                var str = '';
                                if (value == 1) {
                                    str = '${internationalConfig.默认分类}';
                                } else if (value == 2) {
                                    str = '${internationalConfig.影业}';
                                } else if (value == 3) {
                                    str = '${internationalConfig.动漫}';
                                } else if (value == 4) {
                                    str = '${internationalConfig.音乐}';
                                } else if (value == 5) {
                                    str = '${internationalConfig.PGC}';
                                } else {
                                    str = '${internationalConfig.其它}';
                                }
                                return str;
                            }
                        }, {
                            field: 'albumId',
                            title: '${internationalConfig.专辑ID}',
                            width: 100
                        }, {
                            field: 'albumName',
                            title: '${internationalConfig.专辑名称}',
                            width: 100
                        }, {
                            field: 'playNum',
                            title: '${internationalConfig.有效点播总数}',
                            width: 100
                        }, {
                            field: 'userNum',
                            title: '${internationalConfig.有效会员总数}',
                            width: 100
                        }, {
                            field: 'money',
                            title: '${internationalConfig.可分成金额}',
                            width: 100
                        }, {
                            field: 'ratio',
                            title: '${internationalConfig.系数}',
                            width: 30
                        }, {
                            field: 'bossMoney',
                            title: '${internationalConfig.对外金额}',
                            width: 100
                        }, {
                            field: 'status',
                            title: '${internationalConfig.结算状态}',
                            width: 50,
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
                                var str = '';
                                if (row.status == 0) {
                                    str = $.formatString("<a href='javascript:void(0);' onclick='changeStatus(\"" + row.time + "\"," + row.ruleId + ")'>${internationalConfig.结算}</a>|", row.id);
                                }
                                str += $.formatString("<a target='_blank' href='/account/details/list.do?cid=" + row.cid + "&configType=" + patamConfigType + "&time=" + row.time + "&albumId="  + row.albumId + "'>${internationalConfig.查看明细}</a>", row.id);
                                return str;
                            }
                        }]],
                        toolbar: '#toolbar',
                        onLoadSuccess: onLoadSuccess
                    });
                    break;
                case 2:
                    dataGrid = $('#dataGrid2').datagrid({
                        url: '/account/data/find?configType=' + configType,
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
                        columns: [[{
                            field: 'time',
                            title: '${internationalConfig.结算年月}',
                            width: 70,
                            formatter: function (value, row, index) {
                                return value.substring(0,7);
                            }
                        }, {
                            field: 'cid',
                            title: 'CPID',
                            width: 50
                        }, {
                            field: 'cpName',
                            title: '${internationalConfig.CP名称}',
                            width: 250
                        }, {
                            field: 'copyrightType',
                            title: '${internationalConfig.类别}',
                            width: 50,
                            formatter: function (value, row, index) {
                                var str = '';
                                if (value == 1) {
                                    str = '${internationalConfig.默认分类}';
                                } else if (value == 2) {
                                    str = '${internationalConfig.影业}';
                                } else if (value == 3) {
                                    str = '${internationalConfig.动漫}';
                                } else if (value == 4) {
                                    str = '${internationalConfig.音乐}';
                                } else if (value == 5) {
                                    str = '${internationalConfig.PGC}';
                                } else {
                                    str = '${internationalConfig.其它}';
                                }
                                return str;
                            }
                        }, {
                            field: 'albumId',
                            title: '${internationalConfig.专辑ID}',
                            width: 100
                        }, {
                            field: 'albumName',
                            title: '${internationalConfig.专辑名称}',
                            width: 100
                        }, {
                            field: 'pcCount',
                            title: '${internationalConfig.PC端千次}',
                            width: 100,
                            formatter: function (value, row, index) {
                                return value / 1000;
                            }
                        }, {
                            field: 'phoneCount',
                            title: '${internationalConfig.移动端千次}',
                            width: 100,
                            formatter: function (value, row, index) {
                                return value / 1000;
                            }
                        }, {
                            field: 'tvCount',
                            title: '${internationalConfig.TV端千次}',
                            width: 100,
                            formatter: function (value, row, index) {
                                return value / 1000;
                            }
                        }, {
                            field: 'money',
                            title: '${internationalConfig.可分成金额}',
                            width: 100
                        }, {
                            field: 'ratio',
                            title: '${internationalConfig.系数}',
                            width: 30
                        }, {
                            field: 'bossMoney',
                            title: '${internationalConfig.对外金额}',
                            width: 100
                        }, {
                            field: 'status',
                            title: '${internationalConfig.结算状态}',
                            width: 80,
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
                            width: 130,
                            formatter: function (value, row, index) {
                                var str = '';
                                if (row.status == 0) {
                                    str = $.formatString("<a href='javascript:void(0);' onclick='changeStatus(\"" + row.time + "\"," + row.ruleId + ")'>${internationalConfig.结算}</a>|", row.id);
                                }
                                str += $.formatString("<a target='_blank' href='/account/details/list.do?cid=" + row.cid + "&configType=" + patamConfigType + "&time=" + row.time + "&albumId="  + row.albumId + "'>${internationalConfig.查看明细}</a>", row.id);
                                return str;
                            }
                        }]],
                        toolbar: '#toolbar',
                        onLoadSuccess: onLoadSuccess
                    });
                    break;
                case 3:
                    dataGrid = $('#dataGrid3').datagrid({
                        url: '/account/data/find?configType=' + configType,
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
                        columns: [[{
                            field: 'time',
                            title: '${internationalConfig.结算年月}',
                            width: 70,
                            formatter: function (value, row, index) {
                                return value.substring(0,7);
                            }
                        }, {
                            field: 'cid',
                            title: 'CPID',
                            width: 50
                        }, {
                            field: 'cpName',
                            title: '${internationalConfig.CP名称}',
                            width: 250
                        }, {
                            field: 'copyrightType',
                            title: '${internationalConfig.类别}',
                            width: 50,
                            formatter: function (value, row, index) {
                                var str = '';
                                if (value == 1) {
                                    str = '${internationalConfig.默认分类}';
                                } else if (value == 2) {
                                    str = '${internationalConfig.影业}';
                                } else if (value == 3) {
                                    str = '${internationalConfig.动漫}';
                                } else if (value == 4) {
                                    str = '${internationalConfig.音乐}';
                                } else if (value == 5) {
                                    str = '${internationalConfig.PGC}';
                                } else {
                                    str = '${internationalConfig.其它}';
                                }
                                return str;
                            }
                        }, {
                            field: 'albumId',
                            title: '${internationalConfig.专辑ID}',
                            width: 100
                        }, {
                            field: 'albumName',
                            title: '${internationalConfig.专辑名称}',
                            width: 100
                        }, {
                            field: 'playNum',
                            title: '${internationalConfig.有效播放总数千次}',
                            width: 100
                        }, {
                            field: 'money',
                            title: '${internationalConfig.可分成金额}',
                            width: 100
                        }, {
                            field: 'ratio',
                            title: '${internationalConfig.系数}',
                            width: 30
                        }, {
                            field: 'bossMoney',
                            title: '${internationalConfig.对外金额}',
                            width: 100
                        }, {
                            field: 'status',
                            title: '${internationalConfig.结算状态}',
                            width: 50,
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
                                var str = '';
                                if (row.status == 0) {
                                    str = $.formatString("<a href='javascript:void(0);' onclick='changeStatus(\"" + row.time + "\"," + row.ruleId + ")'>${internationalConfig.结算}</a>|", row.id);
                                }
                                str += $.formatString("<a target='_blank' href='/account/details/list.do?cid=" + row.cid + "&configType=" + patamConfigType + "&time=" + row.time + "&albumId="  + row.albumId + "'>${internationalConfig.查看明细}</a>", row.id);
                                return str;
                            }
                        }]],
                        toolbar: '#toolbar',
                        onLoadSuccess: onLoadSuccess
                    });
                    break;
                case 4:
                    dataGrid = $('#dataGrid4').datagrid({
                        url: '/account/data/find?configType=' + configType,
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
                        columns: [[{
                            field: 'time',
                            title: '${internationalConfig.结算年月}',
                            width: 70,
                            formatter: function (value, row, index) {
                                return value.substring(0,7);
                            }
                        }, {
                            field: 'cid',
                            title: 'CPID',
                            width: 50
                        }, {
                            field: 'cpName',
                            title: '${internationalConfig.CP名称}',
                            width: 250
                        }, {
                            field: 'copyrightType',
                            title: '${internationalConfig.类别}',
                            width: 50,
                            formatter: function (value, row, index) {
                                var str = '';
                                if (value == 1) {
                                    str = '${internationalConfig.默认分类}';
                                } else if (value == 2) {
                                    str = '${internationalConfig.影业}';
                                } else if (value == 3) {
                                    str = '${internationalConfig.动漫}';
                                } else if (value == 4) {
                                    str = '${internationalConfig.音乐}';
                                } else if (value == 5) {
                                    str = '${internationalConfig.PGC}';
                                } else {
                                    str = '${internationalConfig.其它}';
                                }
                                return str;
                            }
                        }, {
                            field: 'albumId',
                            title: '${internationalConfig.专辑ID}',
                            width: 100
                        }, {
                            field: 'albumName',
                            title: '${internationalConfig.专辑名称}',
                            width: 100
                        }, {
                            field: 'timeNum',
                            title: '${internationalConfig.有效累计时长时}',
                            width: 100
                        }, {
                            field: 'money',
                            title: '${internationalConfig.可分成金额}',
                            width: 100
                        }, {
                            field: 'ratio',
                            title: '${internationalConfig.系数}',
                            width: 30
                        }, {
                            field: 'bossMoney',
                            title: '${internationalConfig.对外金额}',
                            width: 100
                        }, {
                            field: 'status',
                            title: '${internationalConfig.结算状态}',
                            width: 50,
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
                                var str = '';
                                if (row.status == 0) {
                                    str = $.formatString("<a href='javascript:void(0);' onclick='changeStatus(\"" + row.time + "\"," + row.ruleId + ")'>${internationalConfig.结算}</a>|", row.id);
                                }
                                str += $.formatString("<a target='_blank' href='/account/details/list.do?cid=" + row.cid + "&configType=" + patamConfigType + "&time=" + row.time + "&albumId="  + row.albumId + "'>${internationalConfig.查看明细}</a>", row.id);
                                return str;
                            }
                        }]],
                        toolbar: '#toolbar',
                        onLoadSuccess: onLoadSuccess
                    });
                    break;
                case 5:
                    dataGrid = $('#dataGrid5').datagrid({
                        url: '/account/data/find?configType=' + 5,
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
                        columns: [[{
                            field: 'time',
                            title: '${internationalConfig.结算年月}',
                            width: 70,
                            formatter: function (value, row, index) {
                                return value.substring(0,7);
                            }
                        }, {
                            field: 'cid',
                            title: 'CPID',
                            width: 50
                        }, {
                            field: 'cpName',
                            title: '${internationalConfig.CP名称}',
                            width: 250
                        }, {
                            field: 'memberTypeName',
                            title: '${internationalConfig.类型名称}',
                            width: 100
                        }, {
                            field: 'userCount',
                            title: '${internationalConfig.有效人数}',
                            width: 100
                        }, {
                            field: 'totalCount',
                            title: '${internationalConfig.有效订单数}',
                            width: 100
                        }, {
                            field: 'orderMoney',
                            title: '${internationalConfig.订单总金额}',
                            width: 100
                        }, {
                            field: 'tax',
                            title: '${internationalConfig.税额}',
                            width: 100
                        }, {
                            field: 'outTax',
                            title: '${internationalConfig.去税总金额}',
                            width: 100,
                            formatter: function (value, row, index) {
                                var value = row.orderMoney - row.tax;
                                return value.toFixed(2);
                            }
                        }, {
                            field: 'sharingRate',
                            title: '${internationalConfig.分成比例}',
                            width: 100
                        }, {
                            field: 'money',
                            title: '${internationalConfig.分成金额}',
                            width: 100
                        }, {
                            field: 'status',
                            title: '${internationalConfig.结算状态}',
                            width: 50,
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
                                var str = '';
                                if (row.status == 0) {
                                    str = $.formatString("<a href='javascript:void(0);' onclick='changeStatus(\"" + row.time + "\"," + row.ruleId + ")'>${internationalConfig.结算}</a>|", row.id);
                                }
                                str += $.formatString("<a target='_blank' href='/account/details/list.do?cid=" + row.cid + "&configType=" + patamConfigType + "&time=" + row.time + "&memberType="  + row.memberType + "'>${internationalConfig.查看明细}</a>", row.id);
                                return str;
                            }
                        }]],
                        toolbar: '#toolbar',
                        onLoadSuccess: onLoadSuccess
                    });
                    break;
                case 6:
                    dataGrid = $('#dataGrid6').datagrid({
                        url: '/account/data/find?configType=' + configType,
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
                        columns: [[{
                            field: 'time',
                            title: '${internationalConfig.结算年月}',
                            width: 70,
                            formatter: function (value, row, index) {
                                return value.substring(0,7);
                            }
                        }, {
                            field: 'cid',
                            title: 'CPID',
                            width: 50
                        }, {
                            field: 'cpName',
                            title: '${internationalConfig.CP名称}',
                            width: 250
                        }, {
                            field: 'copyrightType',
                            title: '${internationalConfig.类别}',
                            width: 50,
                            formatter: function (value, row, index) {
                                var str = '';
                                if (value == 1) {
                                    str = '${internationalConfig.默认分类}';
                                } else if (value == 2) {
                                    str = '${internationalConfig.影业}';
                                } else if (value == 3) {
                                    str = '${internationalConfig.动漫}';
                                } else if (value == 4) {
                                    str = '${internationalConfig.音乐}';
                                } else if (value == 5) {
                                    str = '${internationalConfig.PGC}';
                                } else {
                                    str = '${internationalConfig.其它}';
                                }
                                return str;
                            }
                        }, {
                            field: 'memberTypeName',
                            title: '${internationalConfig.类型名称}',
                            width: 100
                        }, {
                            field: 'userCount',
                            title: '${internationalConfig.有效人数}',
                            width: 100
                        }, {
                            field: 'totalCount',
                            title: '${internationalConfig.有效订单量}',
                            width: 100
                        }, {
                            field: 'money',
                            title: '${internationalConfig.可分成金额}',
                            width: 100
                        }, {
                            field: 'ratio',
                            title: '${internationalConfig.系数}',
                            width: 30
                        }, {
                            field: 'bossMoney',
                            title: '${internationalConfig.对外金额}',
                            width: 100
                        }, {
                            field: 'status',
                            title: '${internationalConfig.结算状态}',
                            width: 50,
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
                                var str = '';
                                if (row.status == 0) {
                                    str = $.formatString("<a href='javascript:void(0);' onclick='changeStatus(\"" + row.time + "\"," + row.ruleId + ")'>${internationalConfig.结算}</a>|", row.id);
                                }
                                str += $.formatString("<a target='_blank' href='/account/details/list.do?cid=" + row.cid + "&configType=" + patamConfigType + "&time=" + row.time + "&memberType="  + row.memberType + "'>${internationalConfig.查看明细}</a>", row.id);
                                return str;
                            }
                        }]],
                        toolbar: '#toolbar',
                        onLoadSuccess: onLoadSuccess
                    });
                    break;
            }

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
            var fromData = $.serializeObject($('#searchForm'));
            dataGrid.datagrid({queryParams: fromData});
        }

        function changeStatus(time, ruleId) {
            parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.是否结算}', function (flag) {
                if (flag) {
                    var url = '/account/data/changeStatus?configType=' + patamConfigType + '&time=' + time + '&ruleId=' + ruleId;
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

        function exportFile() {
            var params = $.serializeObject($('#searchForm'));
            var url = '/account/data/export?';
            for(var key in params){
                url += key + "=" + params[key] + "&";
            }
            url += 'configType=' + patamConfigType;
            location.href = url;
        }

        function totalPrice() {
            var params = $.serializeObject($('#searchForm'));
            var url = '/account/data/totalPrice?';
            for(var key in params){
                url += key + "=" + params[key] + "&";
            }
            url += 'configType=' + patamConfigType;
            $("#price"+patamConfigType).html("金额计算中...");
            $.get(url, function (result) {
                $("#price"+patamConfigType).html(result + " ${internationalConfig.priceUnit}");
            });
        }

        function onLoadSuccess() {
            $('#searchForm table').show();
            totalPrice();
            parent.$.messager.progress('close');
        }
        
    </script>
<style>
.mytable
{
    padding: 0;
    border:1px solid #ddd;
    
    empty-cells: show;
}
.mytable tr:first-child{background:#eee;}
.mytable tr:first-child .tdbackground{background:#e3e3e3;}
.mytable caption
{
    font-size: 12px;
    color: #0E2D5F;
    height: 16px;
    line-height: 16px;
    border: 1px dashed red;
    empty-cells: show;
}

.mytable tr th
{
    border: 1px dashed #C1DAD7;
    letter-spacing: 2px;
    text-align: left;
    padding: 6px 6px 6px 12px;
    font-size: 13px;
    height: 16px;
    line-height: 16px;
    empty-cells: show;
}

.mytable tr td
{
    font-size: 12px;
    border: 1px dashed #C1DAD7;
    padding: 6px 6px 6px 12px;
    empty-cells: show;
    border-collapse: collapse;
}
.cursor
{
    cursor: pointer;
    background:none;
}
.tdbackground
{
    background-color: #FFE48D;
}
.datebox-calendar-inner{display:none;}
.datebox-button{display:none;}
</style>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
         style="height: 120px; overflow: hidden;">
        <form id="searchForm">
            <table class="table-more" style="width: 1200px;">
                <tr>
                    <td>${internationalConfig.结算年月}：<input name="startTime" id="startTime" class="easyui-datebox"/>-<input name="endTime" id="endTime" class="easyui-datebox"/></td>
                    <td>
                        ${internationalConfig.类别}
                        <select name="type">
                            <option value="">${internationalConfig.全部}</option>
                            <option value="1">${internationalConfig.默认分类}</option>
                            <option value="2">${internationalConfig.影业}</option>
                            <option value="3">${internationalConfig.动漫}</option>
                            <option value="4">${internationalConfig.音乐}</option>
                            <option value="5">${internationalConfig.PGC}</option>
                        </select>
                    </td>
                    <td>${internationalConfig.专辑ID}：<input name="albumId" placeholder="${internationalConfig.请输入专辑ID}" class="span2"/></td>
                    <td>${internationalConfig.专辑名称}：<input name="albumName" placeholder="${internationalConfig.专辑名称}" class="span2"/></td>
                </tr>
                <tr>
                    <td>CPID：<input name="cid" placeholder="${internationalConfig.请输入CPID}" class="span2"/> ${internationalConfig.CP名称}：<input name="cpName" placeholder="${internationalConfig.请输入CP名称}" class="span2"/></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
            </table>
        </form>
    </div>
    <div class="easyui-tabs" data-options="region:'center',border:false">
        <div title="${internationalConfig.付费分成}" style="padding:10px" data="1">
            总计 : <font id="price1" style="color: red;font-size: 18px">￥ ...</font>
            <table id="dataGrid1"></table>
        </div>
        <div title="${internationalConfig.播放分成}" style="padding:10px" data="3">
            总计 : <font id="price3" style="color: red;font-size: 18px">￥ ...</font>
            <table id="dataGrid3"></table>
        </div>
        <div title="${internationalConfig.累计时长}" style="padding:10px" data="4">
            总计 : <font id="price4" style="color: red;font-size: 18px">￥ ...</font>
            <table id="dataGrid4"></table>
        </div>
        <div title="${internationalConfig.CPM}" style="padding:10px" data="2">
            总计 : <font id="price2" style="color: red;font-size: 18px">￥ ...</font>
            <table id="dataGrid2"></table>
        </div>
        <div title="${internationalConfig.会员订单}" style="padding:10px" data="5">
            总计 : <font id="price5" style="color: red;font-size: 18px">￥ ...</font>
            <table id="dataGrid5"></table>
        </div>
        <div title="${internationalConfig.业务订单}" style="padding:10px" data="6">
            总计 : <font id="price60" style="color: red;font-size: 18px">￥ ...</font>
            <table id="dataGrid6"></table>
        </div>
    </div>
</div>
<div id="toolbar" style="display: none;">
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true"
       onclick="searchFun();">${internationalConfig.查询}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="exportFile();">${internationalConfig.导出数据}</a>
</div>
<script>
$.extend($.fn.combobox.methods, {
    yearandmonth: function (jq) {
        return jq.each(function () {
            var obj = $(this).combobox();
            var date = new Date();
            var year = date.getFullYear();
            var month = date.getMonth() + 1;
            var table = $('<table>');
            var tr1 = $('<tr>');
            var tr1td1 = $('<td>', {
                text: '<<<<',
                click: function () {
                    var y = $(this).next().html();
                    y = parseInt(y) - 1;
                    $(this).next().html(y);
                }
            });
            tr1td1.appendTo(tr1);
            var tr1td2 = $('<td>', {
                text: year
            }).appendTo(tr1);

            var tr1td3 = $('<td>', {
                text: '>>>>',
                click: function () {
                    var y = $(this).prev().html();
                    y = parseInt(y) + 1;
                    $(this).prev().html(y);
                }
            }).appendTo(tr1);
            tr1.appendTo(table);

            var n = 1;
            for (var i = 1; i <= 4; i++) {
                var tr = $('<tr>');
                for (var m = 1; m <= 3; m++) {
                    var td = $('<td>', {
                        text: n,
                        click: function () {
                            var yyyy = $(table).find("tr:first>td:eq(1)").html();
                            var cell = $(this).html();
                            var v = yyyy + '-' + (cell.length < 2 ? '0' + cell : cell);
                            obj.combobox('setValue', v).combobox('hidePanel');

                        }
                    });
                    if (n == month) {
                        td.addClass('tdbackground');
                    }
                    td.appendTo(tr);
                    n++;
                }
                tr.appendTo(table);
            }
            table.addClass('mytable cursor');
            table.find('td').hover(function () {
                $(this).addClass('tdbackground');
            }, function () {
                $(this).removeClass('tdbackground');
            });
            table.appendTo(obj.combobox("panel"));

        });
    }
});
console.log($('#startTime').length)
$('#startTime').combobox('yearandmonth');
$('#endTime').combobox('yearandmonth');
</script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>${internationalConfig.用户支付信息查询}</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">
    	<m:auth uri="/lecard/lecard_edit.do">  $.canEdit = true;</m:auth>
        <m:auth uri="/lecard/freeze.json">
        $.canfreeze = true;
        </m:auth>
        var applyType ={
            1:"${internationalConfig.充值码}",2:"${internationalConfig.兑换码}",3:"${internationalConfig.老充值码}",
            4:"${internationalConfig.超级手机兑换码}",5:"${internationalConfig.兑换码}2.0",6:"${internationalConfig.机卡兑换码}2.0",
            10:"${internationalConfig.直播赛事兑换码}",11:"${internationalConfig.直播场次兑换码}",20:"${internationalConfig.音乐兑换码}",
            30:"${internationalConfig.影视剧兑换码}",40:"${internationalConfig.组合套餐兑换码}",50:"${internationalConfig.大屏商品兑换码}"

        };
        var dataGrid;
        $(function () {
            dataGrid = $('#dataGrid')
                    .datagrid(
                    {
                        url: '/lecard/query.json',
                        fit: true,
                        fitColumns: true,
                        border: false,
                        pagination: true,
                        idField: 'id',
                        pageSize: 50,
                        pageList: [20, 50, 100, 1000],
                        checkOnSelect: false,
                        selectOnCheck: false,
                        nowrap: false,
                        striped: true,
                        rownumbers: true,
                        singleSelect: true,
                        frozenColumns: [[{
                            field: 'id',
                            title: '${internationalConfig.编号}',
                            width: 80,
                            hidden: true
                        }]],
                        columns: [[{
                            field: 'number',
                            title: '${internationalConfig.卡号}',
                            width: 120,
                            sortable: true
                        }, {
                            field: 'batch',
                            title: '${internationalConfig.申请批次}',
                            width: 150,
                            sortable: true
                        }, {
                            field: 'createTime',
                            title: '${internationalConfig.创建日期}',
                            width: 150
                        }, {
                            field: 'expireDate',
                            title: '${internationalConfig.截止日期}',
                            width: 150,
                            sortable: true
                        }, {
                            field: 'amount',
                            title: '${internationalConfig.乐卡面额}',
                            width: 100,
                            sortable: true,
                            formatter: function (value, rows) {
                                if ($.isNumeric(value) && value >= 0) {
                                    return value + " ${internationalConfig.元}";
                                }
                            }
                        }, {
                            field: 'activeTime',
                            title: '${internationalConfig.激活时间}',
                            width: 150

                        },
                            {
                                field: 'uid',
                                title: '${internationalConfig.使用者}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID',
                                width: 150

                            },
                            {
                                field: 'applyTypeDesc',
                                title: '${internationalConfig.卡类型}',
                                width: 100,
                                formatter: function (value,row) {
                                    var deviceType ={1:"${internationalConfig.电视}",2:"${internationalConfig.乐视手机}",3:"${internationalConfig.盒子}",4:"${internationalConfig.路由器}",5:"${internationalConfig.酷派手机}"};
                                    if(row.applyType==undefined || row.applyType==null){
                                        return "${internationalConfig.充值码}";
                                    }
                                    if(row.applyType ==6 && row.deviceType > 0){
                                        return applyType[row.applyType] + "【" + deviceType[row.deviceType] + "】";
                                    }
                                    return applyType[row.applyType];
                                }

                            }, {
                                field: 'flag',
                                title: '${internationalConfig.卡状态}',
                                width: 100,
                                formatter:function(value, rows){
                                    if(value==1 && rows.status!=2){
                                        return "${internationalConfig.未使用}" ;
                                    }else if(value==2){
                                        return "${internationalConfig.已使用}" ;
                                    }else if(value==3){
                                        return "${internationalConfig.已过期}";
                                    }else if(value==4 || rows.status==2){
                                        return "${internationalConfig.已冻结}"
                                    }else {
                                        return "${internationalConfig.未知}"
                                    }
                                }

                            }, {
                                field: 'action',
                                title: '${internationalConfig.操作}',
                                width: 100,
                                formatter: function (value, row, index) {
                                    var str = '&nbsp;&nbsp;';
                                    if ($.canEdit) {
                                 	   str += $.formatString('<img onclick="editLecard({0})"; src="{1}" title="${internationalConfig.编辑}"/>&nbsp;&nbsp;', row.number, '/static/style/images/extjs_icons/brick_edit.png');
                                    }

                                    if ($.canfreeze) {
                                        if (row.flag == 1) {
                                            str += $.formatString('<img onclick="freeze(\'{0}\',4);" src="{1}" title="${internationalConfig.冻结}"/>', row.number, '/static/style/images/extjs_icons/bug/bug_delete.png');
                                        } else if (row.flag == 4) {
                                            str += $.formatString('<img onclick="freeze(\'{0}\',1);" src="{1}" title="${internationalConfig.解冻}"/>', row.number, '/static/style/images/extjs_icons/bug/bug_delete.png');
                                        }

                                    }

                                    return str;
                                }
                            }


                        ]],
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

        function searchFun() {
            batch = $('#batch').val().trim();
            cardNumber = $('#cardNumber').val().trim();
            if('' == batch && '' == cardNumber){
                $.messager.alert('${internationalConfig.错误}', "${internationalConfig.请输入批次号或者卡号}", 'error');
                return;
            }
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }

        //冻结操作
        function freeze(number, status) {
            var info = "${internationalConfig.您是否要冻结当前卡号}？";
            if (status == 1) {
                info = "${internationalConfig.您是否要解冻当前批次卡号}？";
            }
            parent.$.messager.confirm('${internationalConfig.询问}', info, function (b) {
                if (b) {
                    parent.$.messager.progress({
                        title: '${internationalConfig.提示}',
                        text: '${internationalConfig.数据处理中}'
                    });
                    $.post('/lecard/freeze.json', {
                        number: number,
                        status: status
                    }, function (obj) {
                        if (obj.code == 0) {
                            //dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
                            searchFun();
                        }
                        parent.$.messager.progress('close');
                    }, 'JSON');
                }
            });
        }

        //修改乐卡的使用者和状态
        function editLecard(number) {
            parent.$.modalDialog({
                title: '${internationalConfig.编辑乐卡}',
                width: 400,
                height: 250,
                href: '${pageContext.request.contextPath}/lecard/lecard_edit.do?number=' + number,
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
                    <td>${internationalConfig.批次号}：<input class="span2" id="batch" name="batch" data-options="required:true">
                    </td>
                    <td>${internationalConfig.卡号}：<input class="span2" id="cardNumber" name="number" data-options="required:true">
                    </td>
                    <td>${internationalConfig.使用状态}：
                        <select class="span2" name="flag">
                            <option value="0" selected>${internationalConfig.全部}</option>
                            <option value="1">${internationalConfig.未使用}</option>
                            <option value="2">${internationalConfig.已使用}</option>
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
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a><a
        href="javascript:void(0);" class="easyui-linkbutton"
        data-options="iconCls:'brick_delete',plain:true"
        onclick="cleanFun();">${internationalConfig.清除条件}</a>
</div>

</body>
</html>
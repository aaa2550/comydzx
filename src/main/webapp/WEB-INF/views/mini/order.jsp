<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: jiangchao3
  Date: 2017/2/6
  Time: 14:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>商品订单查询</title>
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
    <script type="text/javascript">
        var dataGrid;
        (function($) {
            $.fn.serializeJson = function() {

                var serializeObj = {};
                var array = this.serializeArray();
                $(array).each(function() { // 遍历数组的每个元素 {name : xx , value : xxx}
                    if (serializeObj[this.name]) { // 判断对象中是否已经存在 name，如果存在name
                        serializeObj[this.name] += "," + this.value;
                    } else {
                        serializeObj[this.name] = this.value; // 如果元素name不存在，添加一个属性 name:value
                    }
                });
                return serializeObj;
            }
        })(jQuery)

        $(function() {
            dataGrid = renderDataGrid();

        });

        function renderDataGrid(url, data, method) {
            return $('#dataGrid')
                    .datagrid(
                            {
                                url : url,
                                fit : true,
                                queryParams : data || "",
                                fitColumns : true,
                                border : false,
                                method : method || 'post',
                                pagination : true,
                                idField : 'id',
                                pageSize : 50,
                                pageList : [ 50, 100 ],
                                sortName : 'pk_agg_package',
                                sortOrder : 'desc',
                                checkOnSelect : false,
                                selectOnCheck : false,
                                nowrap : false,
                                striped : true,
                                rownumbers : true,
                                singleSelect : true,
                                frozenColumns : [ [ {
                                    field : 'id',
                                    title : '${internationalConfig.编号}',
                                    width : 10,
                                    hidden : true
                                } ] ],
                                columns : [ [
                                    /*{
                                        field : 'id',
                                        title : '序号',
                                        width : 100,
                                        sortable : true,
                                        formatter : function(val, row) {
                                            return row.id;
                                        }
                                    },*/
                                    {
                                        field : 'userId',
                                        title : '用户ID',
                                        width : 40,
                                        sortable : false
                                    },
                                    {
                                        field : 'orderNo',
                                        title : '订单号',
                                        width : 100,
                                        sortable : false
                                    },
                                    {
                                        field : 'orderName',
                                        title : '订单名',
                                        width : 120,
                                        sortable : false
                                    },
                                    {
                                        field : 'skuNo',
                                        title : 'SKU编码',
                                        width : 80,
                                        sortable : false
                                    },
                                    {
                                        field : 'spuNo',
                                        title : 'SPU编码',
                                        width : 80,
                                        sortable : false
                                    },
                                    {
                                        field : 'spuName',
                                        title : 'SPU名称',
                                        width : 80,
                                        sortable : false
                                    },
                                    /*{
                                        field : 'payPrice',
                                        title : '实际支付价格（元）',
                                        width : 50,
                                        sortable : false
                                    },
                                    {
                                        field : 'exchangeCode',
                                        title : '是否兑换码',
                                        width : 30,
                                        sortable : false,
                                        formatter:function(val) {
                                            if (val!=null&&val.length>0) {
                                                return "是";
                                            }else{
                                                return "否";
                                            }
                                        }
                                    },*/
                                    {
                                        field : 'status',
                                        title : '订单状态',
                                        width : 30,
                                        sortable : false,
                                        formatter : function(val) {
                                            switch (val){
                                                case 0: return "未支付";break;
                                                case 1: return "已支付";break;
                                                case 2: return "过期关闭";break;
                                                case 3: return "退款";break;
                                            }
                                        }
                                    },
                                    {
                                        field : 'createTime',
                                        title : '订单创建时间',
                                        width : 60,
                                        sortable : false
                                    },
                                    {
                                        field : 'successTime',
                                        title : '订单支付时间',
                                        width : 60,
                                        sortable : false
                                    },
                                    {
                                        field : 'action',
                                        title : '${internationalConfig.操作}',
                                        width : 80,
                                        formatter : function(val, row, index) {
                                            var str = '';
                                            str += $.formatString('<a href="javascript:;" onclick="detail(\'{0}\',\'{1}\');">${internationalConfig.详情}</a>',
                                                    row.userId,row.orderNo);

                                            if(row.status==1){
                                                str+='&nbsp;&nbsp;'
                                                str += $.formatString('<a href="javascript:;" onclick="toRefund(\'{0}\',\'{1}\',\'{2}\',\'{3}\');">${internationalConfig.退款}</a>',
                                                    row.userId, row.orderNo, row.status, row.payPrice);
                                            }

                                            if (row.status==1||row.status==3) {
                                                str+='&nbsp;&nbsp;'
                                                str += $.formatString('<a href="javascript:;" onclick="notify(\'{0}\',\'{1}\',\'{2}\',\'{3}\',\'{4}\');">商户通知</a>',
                                                        row.userId,row.id,row.orderNo,row.status,row.orderName);
                                            }

                                            return str;
                                        }
                                    }
                                ]],
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

        //详情
        function detail(userid,orderNo) {
            parent.iframeTab.init({url:'/mini/order/detail?userId='+userid+'&orderNo='+orderNo,text:'商品订单详情'});
        }
        function notify(userId,orderId,orderNo,status,orderName) {
            parent.iframeTab.init({url:'/mini/order/notify?userId='+userId+'&orderNo='+orderNo+'&status='+status+'&orderName='+orderName,text:'商户通知记录'});
        }
        function toRefund(userid, orderNo, status, payPrice) {
            if (status!=1) {
                alert('订单状态不是已支付,所以不能发起退款操作!');
                return;
            }
            if (userid == undefined) {
                var rows = dataGrid.datagrid('getSelections');
                userid = rows[0].userid;
            }

            parent.$.modalDialog({
                title : '退款',
                width : 650,
                height : 245,
                href: '/mini/order/toRefund?userId=' + userid + '&orderNo=' + orderNo + '&payPrice=' + payPrice,
                onClose : function() {
                    this.parentNode.removeChild(this);
                },
                buttons : [ {
                    text : '${internationalConfig.保存}',
                    handler : function() {
                        parent.$.modalDialog.openner_dataGrid = dataGrid; // 因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#form');
                        submitFun(f, "/mini/order/refund");
                    }
                }, {
                    text : "${internationalConfig.取消}",
                    handler : function() {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                } ]
            });
            //parent.iframeTab.init({url:'/mini/order/toRefund?userId='+userid+'&orderNo='+orderNo,text:'商品订单详情'});
        }

        function submitFun(f, url){
            if(f.form("validate")){
                parent.$.messager.progress({
                    title : '${internationalConfig.提示}',
                    text : '${internationalConfig.数据处理中}....'
                });
                $.ajax({
                    url:url,
                    type:"post",
                    data:f.serializeJson(),
                    dataType:"json",
                    success:function(result){
                        parent.$.messager.progress('close');
                        /* result = $.parseJSON(result); */
                        if (result.code == 0) {
                            parent.$.messager.alert('${internationalConfig.成功}', '退款操作完成', 'success');
                            parent.$.modalDialog.handler.dialog('close');
                            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
                        } else {
                            parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
                        }
                    },
                    error:function(){

                    }
                })
            }
        }

        function searchFun() {
            var html = $(".userInfoType").find("option:selected").text()
            parent.$.messager.progress({
                title : '${internationalConfig.提示}',
                text : '${internationalConfig.数据处理中}....'
            });
            if($("#userId").val()==''){
                parent.$.messager.alert('${internationalConfig.提示}', '请输入'+html, 'info');
                parent.$.messager.progress('close');
                return false;
            }
            renderDataGrid('/mini/order/search?', $('#searchForm').serializeJson(), "get");
            parent.$.messager.progress('close');
        }

        function cleanFun() {
            $('#searchForm input').val('');
            renderDataGrid('/mini/order/search');
        }
    </script>
</head>
<style>
    table a{display: inline-block}
</style>
<body>
<div class="easyui-layout" data-options="fit:true, border:false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'">
        <form id="searchForm">
            <table  width="500" cellspacing="5" class="table-more">
                <tr>
                    <td width="100"><i style="color: red">*</i>
                        <select class="userInfoType" name="userInfoType" style="width: 70px;height:22px;">
                            <option value="id">用户ID</option>
                            <option value="email">邮箱</option>
                            <option value="mobile">手机号</option>
                        </select>
                        <input name="userId" id="userId" class="span2" />
                    </td>
                    <td width="100">订单号：<input name="orderNo" class="span2" /></td>

                    <td width="150">SPU编码：<input name="spuNo" class="span2" /></td>
                    <td width="150"></td>
                </tr>
                <tr>

                    <td width="100">SKU编码：<input name="skuNo" class="span2" /></td>
                    <td width="100">订单状态：
                        <select name="orderStatus" class="vendor span2">
                            <option value="-1">全部</option>
                            <option value="0">未支付</option>
                            <option value="1">已支付</option>
                            <option value="2">已过期</option>
                            <option value="3">已退款</option>
                        </select>
                    </td>
                    <td width="150"></td>
                    <td width="150"></td>
                </tr>
            </table>
        </form>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>

<div id="toolbar" style="display: none;">
    <a href="javascript:void(0);" class="easyui-linkbutton" onclick="searchFun();"
       data-options="iconCls:'brick_add',plain:true">${internationalConfig.查询}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" onclick="cleanFun();"
       data-options="iconCls:'brick_delete',plain:true">${internationalConfig.清空条件}</a>

</div>
</body>
</html>

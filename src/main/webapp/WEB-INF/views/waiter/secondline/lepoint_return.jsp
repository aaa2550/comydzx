<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>${internationalConfig.乐点退还}</title>
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
    <script type="text/javascript">
    <m:auth uri="/lepoint_return/return.json">  $.canRefund = true;</m:auth>
        var dataGrid;
        $(function () {
            dataGrid = $('#dataGrid').datagrid({
                url: '${pageContext.request.contextPath}/lepoint_return/data_grid.json',
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
                            field: 'id',
                            title: '${internationalConfig.编号}',
                            width: 150,
                            hidden: true
                        }
                    ]
                ],
                columns: [
                    [
                        {
                            field: 'ordernumber',
                            title: '${internationalConfig.支付订单号}',
                            width: 180,
                            sortable: true
                        },
                        {
                            field: 'corderid',
                            title: '${internationalConfig.消费订单号}',
                            width: 180,
                            sortable: true
                        },
                        {
                            field: 'productname',
                            title: '${internationalConfig.产品}',
                            width: 150,
                            sortable: true
                        },
                        {
                            field: 'username',
                            title: '${internationalConfig.用户名}',
                            width: 180,
                            sortable: true
                        },
                        {
                            field: 'userid',
                            title: '${internationalConfig.用户}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID',
                            width: 180,
                            sortable: true
                        },
                        {
                            field: 'price',
                            title: '${internationalConfig.价格}',
                            width: 80,
                            sortable: true
                        },
                        {
                            field: 'productid',
                            title: '${internationalConfig.订单类型}',
                            width: 180,
                            sortable: true,
                            formatter: function (value) {
                                var str = '';
                                if ("0" == value) {
                                    str = "${internationalConfig.单片}";
                                } else if ("2" == value) {
                                    str = "${internationalConfig.包月}";
                                } else if ("3" == value) {
                                    str = "${internationalConfig.包季}";
                                } else if ("4" == value) {
                                    str = "${internationalConfig.包半年}";
                                } else if ("5" == value) {
                                    str = "${internationalConfig.包年}";
                                } else if ("6" == value) {
                                    str = "${internationalConfig.包三年}";
                                }
                                return str;
                            }
                        },
                        {
                            field: 'status',
                            title: '${internationalConfig.订单状态}',
                            width: 180,
                            sortable: true,
                            formatter: function (value) {
                                var str = '';
                                if (1 == value) {
                                    str = "${internationalConfig.已支付}，${internationalConfig.开通}";
                                } else if (2 == value) {
                                    str = "${internationalConfig.已支付}，${internationalConfig.未知}";
                                } else if (3 == value) {
                                    str = "${internationalConfig.已退订}";
                                } else if (0 == value) {
                                    str = "${internationalConfig.已作废}"
                                } else {
                                    str = "${internationalConfig.未知}"
                                }
                                return str;
                            }
                        },
                        {
                            field: "submitdate",
                            title: "${internationalConfig.提交时间}",
                            width: 180,
                            sortable: true

                        },
                        {
                            field: "paymentdate",
                            title: "${internationalConfig.支付时间}",
                            width: 180,
                            sortable: true

                        },
                        {
                            field: 'action',
                            title: '${internationalConfig.操作}',
                            width: 100,
                            formatter: function (value, row, index) {
                                var str = '';
                                if ($.canRefund && ( row.status == 1 || row.status == 2)) {
                                    str += $.formatString('<a href="#" onclick="refund(\'{0}\');" title="${internationalConfig.退还乐点}">${internationalConfig.退还乐点}</a>', row.ordernumber);
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
        });

        function refund(ordernumber) {
        	parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.您是否要退订当前订单}？', function(b) {
    			if (b) {
    				parent.$.messager.progress({
    					title : '${internationalConfig.提示}',
    					text : '${internationalConfig.数据处理中}....'
    				});
    				$.post('${pageContext.request.contextPath}/lepoint_return/return.json', {
    					'ordernumber' : ordernumber
    				}, function(result) {
    					var code = result.code;
    	            	var msg = result.msg;
    	                if (code == '0') {
    	                	msg = "${internationalConfig.退还乐点成功}, ${internationalConfig.请重新查询用户乐点余额}，${internationalConfig.并及时关闭相应服务}";
    	                } 
    					parent.$.messager.alert('${internationalConfig.提示}', msg, 'info');
    					parent.$.messager.progress('close');
    					dataGrid.datagrid('reload');
    				}, 'JSON');
    			}
    		});
        }

        function searchFun() {
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
         style="height: 80px; overflow: hidden;">
        <form id="searchForm">
            <table class="table-td-two" style="display: none;">
                <tr>
                    <td>${internationalConfig.用户名}：<input id="userName" name="username" class="span2"/></td>
                    <td>${internationalConfig.用户}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID：<input id="userId" name="userid" class="span2"/></td>
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
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">${internationalConfig.清空条件}</a>
</div>

<div id="mydialog" style="display:none;padding:5px;width:400px;height:200px;" title="${internationalConfig.退款}">
    <input id="txRoleID" type="hidden" runat="server" value="0"/>
    <label class="lbInfo">${internationalConfig.退款金额}：</label>
    <input id="refund_fee_id" type="text" class="easyui-validatebox" required="true" runat="server"/><br/>
    <label class="lbInfo"> </label>
    <label id="lbmsg" runat="server"></label>
</div>
</body>
</html>
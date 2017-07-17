<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>支付订单查询(v1.0)</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script src="${pageContext.request.contextPath}/static/lib/select2.full.js" type="text/javascript"></script>
    <link href="${pageContext.request.contextPath}/static/style/select2.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript">
        var page = 1;

        $(function () {
            parent.$.messager.progress('close');
            searchFun();
            $('#fb').filebox({
                buttonText: '选择',
                buttonAlign: 'left'
            });
            $('#svips').select2({multiple: true, allowClear: true, placeholder: '全部', data: eval('${svips}')});
            $('#deptids').select2({multiple: true, allowClear: true, placeholder: '全部', data: eval('${deptids}')});
        });

        function getDataGridFields() {
            var fields = new Array();
            var options = $('#dataGrid').datagrid('options');
            var columns = options.columns[0];
            for (var i = 0; i < columns.length; i++) {
                if (!columns[i].hidden) {
                    var title = columns[i].title;
                    var field = columns[i].field;
                    var obj = new Object();
                    obj.title = title;
                    obj.field = field;
                    fields.push(obj);
                }
            }
            return fields;
        }

        function exportExcel() {
            $('input[name=fields]').val(JSON.stringify(getDataGridFields()));
            $('#searchForm').submit();
        }

        function searchFun(pageNo, pageSize) {
            var oData = new FormData(document.forms.namedItem("searchForm"));
            oData.append("page", pageNo == undefined ? 1 : pageNo);
            oData.append("rows", pageSize == undefined ? 25 : pageSize);
            if (!pageNo)
                page = 1;
            var oReq = new XMLHttpRequest();
            oReq.open("POST", "${pageContext.request.contextPath}/tj/payinfo/orderv1/dataGrid", true);
            oReq.onload = function (oEvent) {
                if (oReq.status == 200) {
                    if ($('#payStatus').val() == '1') {
                        $('#dataGrid').datagrid({
                            'data': $.parseJSON(oReq.responseText),
                            fit: true,
                            fitColumns: false,
                            border: false,
                            pagination: true,
                            idField: 'id',
                            pageSize: 25,
                            pageList: [25, 50, 75, 100],
                            //sortName: 'paymentdate',
                            //sortOrder: 'desc',
                            checkOnSelect: false,
                            selectOnCheck: false,
                            nowrap: false,
                            striped: true,
                            rownumbers: true,
                            singleSelect: true,
                            remoteSort: false,
                            frozenColumns: [[]],
                            columns: [
                                [
                                    {
                                        field: 'ordernumber',
                                        title: '订单号',
                                        width: '160',
                                        sortable: true
                                    },
                                    {
                                        field: 'price',
                                        title: '支付金额',
                                        width: '80',
                                        sortable: true
                                    },
                                    {
                                        field: 'companyid',
                                        title: '公司ID',
                                        width: '120',
                                        sortable: true
                                    },
                                    {
                                        field: 'svip',
                                        title: 'VIP类型',
                                        width: '120',
                                        sortable: true
                                    },
                                    {
                                        field: 'corderid',
                                        title: '商户订单号',
                                        width: '120',
                                        sortable: true
                                    },
                                    {
                                        field: 'deptid',
                                        title: '支付的部门编号',
                                        width: '120',
                                        sortable: true
                                    },
                                    {
                                        field: 'transeq',
                                        title: '第三方公司流水号',
                                        width: '200',
                                        sortable: true
                                    },
                                    {
                                        field: 'submitdate',
                                        title: '订单提交时间',
                                        width: '100',
                                        sortable: true
                                    },
                                    {
                                        field: 'paymentdate',
                                        title: '支付时间',
                                        width: '100',
                                        sortable: true
                                    },
                                    {
                                        field: 'paytype',
                                        title: '支付方式',
                                        width: '120',
                                        sortable: true
                                    },
                                    {
                                        field: 'status',
                                        title: '订单状态',
                                        width: '120',
                                        sortable: true
                                    },
                                    {
                                        field: 'userid',
                                        title: '用户ID',
                                        width: '120',
                                        sortable: true
                                    },
                                    {
                                        field: 'username',
                                        title: '用户名',
                                        width: '120',
                                        sortable: true
                                    },
                                    {
                                        field: 'productid',
                                        title: '产品ID',
                                        width: '120',
                                        sortable: true
                                    },
                                    {
                                        field: 'productname',
                                        title: '商品名称',
                                        width: '120',
                                        sortable: true
                                    },
                                    {
                                        field: 'productnum',
                                        title: '商品数量',
                                        width: '120',
                                        sortable: true
                                    },
                                    {
                                        field: 'deviceid',
                                        title: '设备标识',
                                        width: '120',
                                        sortable: true
                                    },
                                    {
                                        field: 'productnum',
                                        title: '商品数量',
                                        width: '120',
                                        sortable: true
                                    },
                                    {
                                        field: 'ext',
                                        title: '扩展信息',
                                        width: '400',
                                        sortable: true
                                    },
                                    {
                                        field: 'videoidTmp',
                                        title: '视频ID',
                                        width: '120',
                                        sortable: true
                                    },
                                    {
                                        field: 'pidTmp',
                                        title: '专辑ID',
                                        width: '120',
                                        sortable: true
                                    }
                                ]
                            ],
                            toolbar: '#toolbar',
                            onLoadSuccess: function (data) {
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
                    } else {
                        $('#dataGrid').datagrid({
                            'data': $.parseJSON(oReq.responseText),
                            fit: true,
                            fitColumns: false,
                            border: false,
                            pagination: true,
                            idField: 'id',
                            pageSize: 25,
                            pageList: [25, 50, 75, 100],
                            //sortName: 'submit_date',
                            //sortOrder: 'desc',
                            checkOnSelect: false,
                            selectOnCheck: false,
                            nowrap: false,
                            striped: true,
                            rownumbers: true,
                            singleSelect: true,
                            remoteSort: false,
                            frozenColumns: [[]],
                            columns: [
                                [
                                    {
                                        field: 'orderNumber',
                                        title: '订单号',
                                        width: '160',
                                        sortable: true
                                    },
                                    {
                                        field: 'companyId',
                                        title: '公司ID',
                                        width: '120',
                                        sortable: true
                                    },
                                    {
                                        field: 'svip',
                                        title: 'VIP类型',
                                        width: '120',
                                        sortable: true
                                    },
                                    {
                                        field: 'deptId',
                                        title: '支付的部门编号',
                                        width: '120',
                                        sortable: true
                                    },
                                    {
                                        field: 'price',
                                        title: '支付金额',
                                        width: '80',
                                        sortable: true
                                    },
                                    {
                                        field: 'submitDate',
                                        title: '订单提交时间',
                                        width: '100',
                                        sortable: true
                                    },
                                    {
                                        field: 'payType',
                                        title: '支付方式',
                                        width: '120',
                                        sortable: true
                                    },
                                    {
                                        field: 'status',
                                        title: '订单状态',
                                        width: '120',
                                        sortable: true
                                    },
                                    {
                                        field: 'userId',
                                        title: '用户ID',
                                        width: '120',
                                        sortable: true
                                    },
                                    {
                                        field: 'userName',
                                        title: '用户名',
                                        width: '120',
                                        sortable: true
                                    },
                                    {
                                        field: 'corderId',
                                        title: '商户订单号',
                                        width: '120',
                                        sortable: true
                                    },
                                    {
                                        field: 'productId',
                                        title: '产品ID',
                                        width: '120',
                                        sortable: true
                                    },
                                    {
                                        field: 'productName',
                                        title: '商品名称',
                                        width: '120',
                                        sortable: true
                                    },
                                    {
                                        field: 'productNum',
                                        title: '商品数量',
                                        width: '120',
                                        sortable: true
                                    },
                                    {
                                        field: 'productDesc',
                                        title: '视频描述',
                                        width: '120',
                                        sortable: true
                                    },
                                    {
                                        field: 'deviceid',
                                        title: '设备标识',
                                        width: '120',
                                        sortable: true
                                    },
                                    {
                                        field: 'ext',
                                        title: '扩展信息',
                                        width: '400',
                                        sortable: true
                                    },
                                    {
                                        field: 'pid',
                                        title: '影片ID',
                                        width: '120',
                                        sortable: true
                                    },
                                    {
                                        field: 'videoId',
                                        title: '专辑场次ID',
                                        width: '120',
                                        sortable: true
                                    }
                                ]
                            ],
                            toolbar: '#toolbar',
                            onLoadSuccess: function (data) {
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
                }
                var pg = $("#dataGrid").datagrid("getPager");
                if (pg) {
                    $(pg).pagination({
                        onSelectPage: function (pageNo, pageSize) {
                            page = pageNo;
                            searchFun(pageNo, pageSize);
                        }
                    });
                    $(pg).pagination('refresh', {
                        pageNumber: page
                    });
                }
            };
            oReq.send(oData);
        }

        function switchBatchField() {
            $('#batchField').prop('disabled', $("input[name=file]").val() == "");
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false" style="height: 125px; overflow: auto;">
        <form id="searchForm" action="${pageContext.request.contextPath}/tj/payinfo/orderv1/excel" method="post" enctype="multipart/form-data">
            <table class="table table-hover table-condensed">
                <tr>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>会员类型</td>
                    <td>终端</td>
                    <td>用户ID</td>
                    <td>商户订单号</td>
                    <td>支付状态</td>
                    <td>批量查询导入文件</td>
                    <td>批量查询字段</td>
                </tr>
                <tr>
                    <input type="hidden" name="fields">
                    <td>
                        <input id="dateStart" name="dateStart" class="easyui-datebox" data-options="required:true" value="${dateStart}"
                               style="width: 120px; height: 29px"/>
                    </td>
                    <td>
                        <input id="dateEnd" name="dateEnd" class="easyui-datebox" data-options="required:true" value="${dateEnd}"
                               style="width: 120px; height: 29px">
                    </td>
                    <td>
                        <select id="svips" name="svips" style="width: 150px; height:29px; padding:0; margin:0"></select>
                    </td>
                    <td>
                        <select id="deptids" name="deptids" style="width: 150px; height: 29px; padding: 0; margin: 0"></select>
                    </td>
                    <td>
                        <input id="userid" class="easyui-textbox" name="userid" style="width: 120px; height: 29px"/>
                    </td>
                    <td>
                        <input id="corderid" class="easyui-textbox" name="corderid" style="width: 120px; height: 29px"/>
                    </td>
                    <td>
                        <select id="payStatus" name="payStatus" style="width: 120px; height: 29px;">
                            <option value="1">已支付</option>
                            <option value="0">未支付</option>
                        </select>
                    </td>
                    <td>
                        <input id="fb" class="easyui-filebox" style="width:200px; height: 29px"
                               data-options="onChange:switchBatchField,prompt:'Choose a file...'" name="file"><br>
                    </td>
                    <td>
                        <select id="batchField" name="batchField" style="width: 120px; height: 29px" disabled>
                            <option value="Userid">用户ID</option>
                            <option value="Corderid">商户订单号</option>
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
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="exportExcel();">导出excel</a>
</div>
</body>
</html>
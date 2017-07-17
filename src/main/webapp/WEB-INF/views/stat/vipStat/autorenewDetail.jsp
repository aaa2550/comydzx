<%--
  Created by IntelliJ IDEA.
  User: lianghaitao
  Date: 2016/7/13
  Time: 16:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>自动续费查询</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <%--<script src="${pageContext.request.contextPath}/static/lib/jquery.boss.stat.js" type="text/javascript"></script>--%>
    <style type="text/css">
    th {
      padding-left: 40px;
    }

    td {
      padding-left: 10px;
    }

    select {
      width: 150px;
      height: 20px;
    }
    </style>
    <script type="text/javascript">
    /**
     * 待绑定行数据
     */
    var rows;

    var dataGrid;
    $(function () {
      parent.$.messager.progress('close');

      dataGrid = renderDataGrid('${pageContext.request.contextPath}/vipController/autorenewConsume3');
    });
      function renderDataGrid(url) {
        return $('#dataGrid').bossDataGrid({
          url: url,
          idField: 'ptime',
          sortName: 'ptime',
          sortOrder: 'desc',
          queryParams: {
            startDate: $("#beginDate").val(),
            endDate: $("#endDate").val(),
            payType: $("#payType").val(),
            vipType: $("#vipType").val(),
            terminal: $("#terminal").val()
          },
          columns: [
            {
              field: 'ptime',
              title: '日期',
              width: 130,
              sortable: true
            },
            {
              field: 'dailyRenew',
              title: '新增人数',
              width: 130,
              sortable: true
            },
            {
              field: 'dailyResume',
              title: '恢复人数',
              width: 130,
              sortable: true
            },
            {
              field: 'dailyRepay',
              title: '补扣订单',
              width: 130,
              sortable: true
            },
            {
              field: 'dailyRepaySuccess',
              title: '成功补扣订单',
              width: 130,
              sortable: true
            },
            {
              field: 'dailyRepayIncome',
              title: '补扣收入',
              width: 130,
              sortable: true,
              formatter: function (value) {
                return value.toFixed(2);
              }
            },
            {
              field: 'orderAmount',
              title: '订单数',
              width: 130,
              sortable: true,
            },
            {
              field: 'successOrder',
              title: '成功扣费订单',
              width: 130,
              sortable: true
            },
            {
              field: 'orderIncome',
              title: '订单扣费收入',
              width: 130,
              sortable: true,
              formatter: function (value) {
                return value.toFixed(2);
              }
            },
            {
              field: 'totalRemain',
              title: '总留存数',
              width: 130,
              sortable:true
            },
            {
              field: 'totalOrder',
              title: '总订单数',
              width: 130,
              sortable:true
            },
            {
              field: 'totalSuccessOrder',
              title: '总成功支付订单数',
              width: 150,
              sortable:true
            },
            {
              field: 'totalIncome',
              title: '总收入',
              width: 130,
              sortable:true,
              formatter: function (value) {
                return value.toFixed(2);
              }
            }
          ]
        });
      }

      function searchFun() {
		dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        /* var diff = $("input[name='beginDate']").dateDiff($("input[name='endDate']").val());
        if (diff > 31) {
          $.messager.alert("提示", "查询日期范围不能大于31天", "关闭");
        } else {
          dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        } */
      }

    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
  <div data-options="region:'north',title:'查询条件',border:false" style="height: 100px; overflow: auto;padding-top: 20px;padding-left: 20px">
    <form id="searchForm">
      <table>
        <tr>
          <th style="padding-left: 5px">开始时间</th>
          <td>
            <input id="beginDate" name="beginDate" class="easyui-datebox" value="${beginDate}">&nbsp;&nbsp;
          </td>
          <th>截止时间</th>
          <td>
            <input id="endDate" name="endDate" class="easyui-datebox" value="${endDate}">
          </td>
          <th>支付渠道</th>
          <td>
            <select id="payType" name="payType">
              <option value="0">全部</option>
              <option value="1">支付宝</option>
              <option value="2">微信</option>
            </select>
          </td>
          <th>会员类型</th>
          <td>
            <select id="vipType" name="vipType">
              <option value="-2">全部</option>
              <option value="1">普通会员</option>
              <option value="9">高级会员</option>
            </select>
          </td>
          <th>终端</th>
          <td>
            <select id="terminal" name="terminal">
              <option value="-2">全部</option>
              <option value="112">PC</option>
              <option value="113">M站</option>
              <option value="120">手机领先版</option>
              <option value="130">Mobile</option>
            </select>
          </td>
        </tr>
        <tr><td colspan="4" style="padding-top: 5px">
          <p style="color:red;font-size: 11px ">订单数，成功扣费订单和订单扣费收入包含了补扣部分的数据;</p>
          </td>
          <td colspan="4" style="padding-top: 5px">
            <p style="color:red;font-size: 11px ">总留存数：该查询日期前开通服务的且至今保持服务开通的用户数</p>
        </td>
        </tr>
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
</div>
</body>
</html>
<%--
  Created by IntelliJ IDEA.
  User: lianghaitao
  Date: 2016/8/1
  Time: 11:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
  <title>体育订单查询页面</title>
  <%@ include file="/WEB-INF/views/inc/head.inc"%>
  <script type="text/javascript">
    /**
     * 待绑定行数据
     */
    var rows;

    var dataGrid;
    $(function () {
      parent.$.messager.progress('close');
      dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/sport/vip/orders');
    });

    function renderDataGrid(url) {
      return $('#dataGrid').bossDataGrid({
        url: url,
        idField: 'dt',
        sortName: 'dt',
        sortOrder: 'desc',
        queryParams: {
          startDate: $("#startDate").val(),
          endDate: $("#endDate").val(),
          payType: $("#payType").val(),
          terminal: $("#terminal").val()
        },
        columns: [
            {
              field: 'dt',
              title: '日期',
              width: 100
            },
            {
              field: 'orderNum',
              title: '订单',
              width: 100
            },
            {
            field: 'orderSuccNum',
            title: '成功订单',
            width: 100
            },
            {
              field: 'newOrderRate',
              title: '新增订单占比',
              width: 100
            },
            {
              field: 'income',
              title: '收入',
              width: 100,
              sortable: true
            } ,
            {
              field: 'monthOrder',
              title: '包月订单',
              width: 100
            } ,
            {
              field: 'quarterOrder',
              title: '包季订单',
              width: 100
            } ,
            {
              field: 'yearOrder',
              title: '包年订单',
              width: 100
            },
            {
              field: 'allUser',
              title: '总用户数',
              width: 100
            },
            {
              field: 'newUser',
              title: '新增用户数',
              width: 100
            },
            {
              field: 'renewUser',
              title: '续费用户数',
              width: 100
            }
          ]
      });
    }

    function cleanFun() {
      $('#searchForm input').val('');
      dataGrid.datagrid('load', {});
    }

    $(function () {
      parent.$.messager.progress('close');
    });


      function exportFile() {
      var startDate = $('#startDate').datetimebox("getValue");
      var endDate = $('#endDate').datetimebox("getValue");;
      var terminal = $('#terminal').val();
      var payType = $('#payType').val();
      var url = '${pageContext.request.contextPath}/tj/sport/vip/export_v2?terminal='+terminal+'&sdate=' + startDate + '&edate='+ endDate +'&payType='+payType;
      location.href = url;
    }

    function searchFun() {
      var s = $("input[name=startDate]").val();
      var s1 = $("input[name=endDate]").val();
      if(Math.abs(((new Date(Date.parse(s1)) - new Date(Date.parse(s)))/1000/60/60/24)) - 32 < 0){
        dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
      }else{
        alert("对账时间范围最多为31天!!!");
      }
    }

  </script>
  <style>
    .span {
      padding: 10px;
    }
  </style>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
  <div data-options="region:'north',title:'查询条件',border:false"
       style="height: 120px; overflow: auto;">
    <form id="searchForm">
      <table class="table table-hover table-condensed">
        <tr>
          <td>开始日期</td>
          <td>结束日期</td>
          <td>支付方式</td>
          <td>终端</td>
        </tr>
        <tr>
          <td>
            <input name="startDate" id="startDate" class="easyui-datebox" validType="TimeCheck"  data-options="required:true" value="${startDate}" style="width: 160px; height: 29px"/>
          </td>

          <td>
            <input name="endDate" id="endDate" class="easyui-datebox" validType="TimeCheck"  data-options="required:true" value="${endDate}" style="width: 160px; height: 29px"/>
          </td>

          <td>
            <select name="payType" id="payType" style="width:140px">
              <option value="-2">全部</option>
              <option value="-1">免费</option>
              <option value="0">乐卡</option>
              <option value="2" selected>现金</option>
              <option value="3" >机卡绑定</option>
            </select>
          </td>

          <td>
            <select name="terminal" style="width: 160px" id="terminal">
              <option value="-2">全部</option>
              <c:forEach var="terminal" items="${terminals}">
                <option value="${terminal.key}">${terminal.value}</option>
              </c:forEach>
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
  <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="exportFile();">导出数据</a>
</div>
</body>
</html>
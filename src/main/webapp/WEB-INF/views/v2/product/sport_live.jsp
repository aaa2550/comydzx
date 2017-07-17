<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.直播内容管理}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<style>
  .width150{width: 150px}
  .title_td{
    width: 80px;
  }
</style>
</head>
<body>
  <div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'" >
      <form id="searchForm">
        <table id="searchTable" width="600">
          <tr>
            <td class="title_td">${internationalConfig.直播频道}:</td>
            <td class=""><select name="liveType" class="width150">
                <option value="">${internationalConfig.全部}</option>
                <c:forEach var="channel" items="${channels}">
                  <option value="${channel.type}">${internationalConfig[channel.name]}</option>
                </c:forEach>
              </select>
            </td>
            <td class="title_td">${internationalConfig.场次ID}:</td>
            <td class=""><input name="extendId" class="span2" /></td>
          </tr>
        </table>
      </form>
    </div>
    <div data-options="region:'center',border:false">
      <table id="dataGrid"></table>
    </div>
  </div>
  <div id="toolbar" style="display: none;">
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">${internationalConfig.清空条件}</a>
  </div>

  <div id="menu" class="easyui-menu" style="width: 120px; display: none;">
    <div onclick="editFun();" data-options="iconCls:'pencil'">${internationalConfig.编辑}</div>
  </div>
  <script type="text/javascript">
    var liveDict={<c:forEach var="dic" items="${liveDict}">"${dic.pid}-${dic.id}":"${dic.description}",</c:forEach>};
    function renderGrid(url) {
      $('#dataGrid').datagrid({
        url : url,
        fit : true,
        fitColumns : true,
        border : false,
        pagination : true,
        idField : 'id',
        pageSize : 20,
        pageList : [ 10, 20, 30, 40, 50 ],
        sortName : 'updateTime',
        sortOrder : 'desc',
        checkOnSelect : false,
        selectOnCheck : false,
        singleSelect: true,
        nowrap: false,
        striped: true,
        rownumbers: true,
        singleSelect: true,
        frozenColumns: [
          [
            {
              field: 'id',
              title: '${internationalConfig.编号}',//编号
              width: 50,
              hidden: true
            }
          ]
        ],
        columns : [ [
          {
            field : 'extendId',
            title : '${internationalConfig.场次ID}',//场次ID
            width : 60,
            sortable: true
          },{
            field : 'name',
            title : '${internationalConfig.直播名称}',
            width : 80,
            sortable: true
          },
          {
            field : 'liveType',
            title : '${internationalConfig.直播频道}',
            width : 60,
            sortable: true,
            formatter: function (value) {
              var channels = {<c:forEach var="channel" items="${channels}">${channel.type}:'${internationalConfig[channel.name]}',</c:forEach>};
              return channels[value];
            }
          },
          {
            field: 'itemId',
            title : '${internationalConfig.直播类型}',
            width: 60,
            sortable: true,
            formatter: function (value,row,index) {
              return liveDict[row.matchId+"-"+value];
            }
          },
          {
            field : 'trialTime',
            title : '${internationalConfig.直播试看时间}(${internationalConfig.分钟})',
            width : 60
          },
          {
            field : 'pushTime',
            title : '${internationalConfig.推送时间}',
            width : 60,
            sortable: true
          },{
            field : 'action',
            title : '${internationalConfig.操作}',
            width: 60,
            formatter: function (value,row,index) {
              var str = $.formatString('<a href="javascript:void(0)" onclick="manageLive(\'{0}\')">${internationalConfig.直播管理}</a>', row.extendId);
              str += '&nbsp;&nbsp;|&nbsp;&nbsp;';
              str += $.formatString('<a href="javascript:void(0)" onclick="live2vod(\'{0}\')">${internationalConfig.直转点管理}</a>', row.extendId);
              return str;
            }
          }] ],
        toolbar : '#toolbar',
        onLoadSuccess : function() {
          $('#searchForm table').show();
          parent.$.messager.progress('close');
        }
      });
    };

    var dataGrid;
    $(function () {
        renderGrid('');
        $('#dataGrid').datagrid('load', '${request.contextPath}/v2/product/sport_live/data_grid?'+$('#searchForm').serialize());
        dataGrid=$('#dataGrid');
    });
    function searchFun() {
        dataGrid.datagrid('load', '${request.contextPath}/v2/product/sport_live/data_grid?'+$('#searchForm').serialize());
    }
    function cleanFun() {
      $('#searchForm input').val('');
        dataGrid.datagrid('load', {});
    }

    //直播管理
    function manageLive(id) {
      parent.$.modalDialog({
        title : '${internationalConfig.直播管理}',
        width : 650,
        height : 450,
        resizable : true,
        href : '${request.contextPath}/v2/product/sport_live/manage_live?extendId=' + id,
        buttons : [ {
          text : '${internationalConfig.保存}',
          handler : function() {
            parent.$.modalDialog.openner_dataGrid = dataGrid;
            var f = parent.$.modalDialog.handler.find('#form');
            f.submit();
          }
        }, {
          text : "${internationalConfig.取消}",
          handler : function() {
            parent.$.modalDialog.handler.dialog('close');
          }
        } ]
      });
    }
    //直转点管理
    function live2vod(id) {
      parent.$.modalDialog({
        title : '${internationalConfig.直播转点播管理}',
        width : 700,
        height : 400,
        resizable : true,
        href : '${request.contextPath}/v2/product/sport_live/live2vod?extendId=' + id,
        buttons : [ {
          text : '${internationalConfig.保存}',
          handler : function() {
            parent.$.modalDialog.openner_dataGrid = dataGrid;
            var f = parent.$.modalDialog.handler.find('#form');
            f.submit();
          }
        }, {
          text : "${internationalConfig.取消}",
          handler : function() {
            parent.$.modalDialog.handler.dialog('close');
          }
        } ]
      });
    }
  </script>
</body>
</html>
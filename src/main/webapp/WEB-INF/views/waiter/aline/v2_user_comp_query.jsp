<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.用户综合查询}2.0</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<style>
  .table-in{
    width: 95%;
    margin: 0 auto;
    border:1px solid #ddd;
    text-align:center;


  }
  .table-in td,.table-in th{
    padding: 7px;
    border:1px solid #ddd;
  }
  .font_grey{
  	color:#A09D9D;
  }
  a.l-btn{height:26px;line-height: 26px;margin-right:10px;width:60px;text-decoration:none;}
  a.l-btn:hover,a.l-btn:focus{color:#444;text-decoration:none;}
  .table-w{border-top:1px solid #ddd}
  .table-cont{float: left;width: 100%;height:auto;min-height:300px;overflow-y: auto;overflow-x: hidden;}
</style>
  <script type="text/javascript" src="/js/kv/v2SeasonLiveDic.js"></script>
<script type="text/javascript">
  var dataGrid = [];
  $(function() {
    dataGrid[0] = $('#dataGrid0').datagrid({
      url : '/v2_user_comp_query/user_info',
      fit : true,
      fitColumns : true,
      border : false,
      checkOnSelect : false,
      selectOnCheck : false,
      nowrap : false,
      striped : true,
      rownumbers : true,
      singleSelect : true,
      frozenColumns : [ [

      ] ],
      columns : [ [ {
        field : 'uid',
        title : '${internationalConfig.用户ID}',
        width : 100
      }, {
        field : 'nickname',
        title : '${internationalConfig.昵称}',
        width : 100
      }, {
        field : 'email',
        title : '${internationalConfig.邮箱}',
        width : 100
      }, {
        field : 'mobile',
        title : '${internationalConfig.电话号码}',
        width : 100
      },{
          field : 'disableStatus',
          title : '${internationalConfig.是否禁用}',
          width : 100
      }, {
        field : 'registTime',
        title : '${internationalConfig.注册时间}',
        width : 100
      }, {
        field : 'operator',
        title : '${internationalConfig.操作}',
        width : 100,
        formatter : function(value, row, index) {
          var str = '&nbsp;';
          if(row.disableStatus=="yes"){
            str += $.formatString(
                            '<img onclick="allow(\'{0}\');" src="{1}" title="${internationalConfig.解禁}"/>', row.uid,'/static/style/images/extjs_icons/pencil_delete.png');
          }else{
            str += $.formatString(
                    '<img onclick="banned(\'{0}\');" src="{1}" title="${internationalConfig.封禁}"/>', row.uid,'/static/style/images/extjs_icons/pencil_add.png');
          }
          return str;
        }
      }

      ] ],
      toolbar : '#toolbar'
    });
    dataGrid[1] = $('#dataGrid1').datagrid({
      url : '/v2_user_comp_query/vip_info',
      fit : true,
      fitColumns : true,
      border : false,
      checkOnSelect : false,
      selectOnCheck : false,
      nowrap : false,
      striped : true,
      rownumbers : true,
      singleSelect : true,
      frozenColumns : [ [

      ] ],
      columns : [ [ {
        field : 'name',
        title : '${internationalConfig.名称}',
        width : 100
      }, {
        field : 'endTime',
        title : '${internationalConfig.到期时间}',
        width : 100
      }, {
        field : 'vipbrand',
        title : '${internationalConfig.冠名方}',
        width : 100,
        formatter : function(value) {
          if(value==0){
            return "";
          }
          return value;
        }
      }, {
        field : 'isSubscribe',
        title : '${internationalConfig.自动续费}',
        width : 100,
        formatter : function(value) {
          if(value == 2){
            return "yes";
          }
          return "no";
        }
      }, {
        field : 'subscribeMode',
        title : '${internationalConfig.自动续费模式}',
        width : 100,
        formatter : function(value,row) {
           if(row.isSubscribe==2){
             if(value==1){
               return "${internationalConfig.现金扣费}";
             }else if(value==2){
               return "${internationalConfig.话费扣费}";
             }else if(value==3){
               return "${internationalConfig.应用商店扣费}";
             }else{
               return "${internationalConfig.现金扣费}";
             }
           }
             return "";
        }
      }, {
        field : 'operator',
        title : '${internationalConfig.操作}',
        width : 100,
        formatter : function(value, row, index) {
          var str = '&nbsp;';
          if(row.isSubscribe == 2 && row.subscribeMode!=3){
            str += '<input type="image" onclick="closeFun(' + row.uid + ',' + row.productId + ')" src="/static/style/images/extjs_icons/cancel.png" title="${internationalConfig.关闭自动续费}" />';
          }
          str += '&nbsp;';
            var data = row.endTime;
            data = data.replace(/-/g,"/");
          if (new Date(data)>new Date()) {
            str += $.formatString('<img onclick="transferVip(\'{0}\',\'{1}\',\'{2}\',\'{3}\');" src="{4}" title="会员转移"/>',row.uid,row.productId,row.name,row.isSubscribe,'/static/style/images/extjs_icons/transmit_go.png');
          }
          return str;
        }
      }

      ] ],
      toolbar : '#toolbar'
    });
    dataGrid[2] = $('#dataGrid2').datagrid({
      url : '/v2_user_comp_query/machine_info',
      fit : true,
      fitColumns : true,
      border : false,
      checkOnSelect : false,
      selectOnCheck : false,
      nowrap : false,
      striped : true,
      rownumbers : true,
      singleSelect : true,
      frozenColumns : [ [

      ] ],
      columns : [ [ {
        field : 'productName',
        title : '${internationalConfig.会员名称}',
        width : 100
      }, {
        field : 'mac',
        title : 'mac',
        width : 100
      }, {
        field : 'deviceKey',
        title : 'deviceKey',
        width : 100
      }, {
        field : 'endTime',
        title : '${internationalConfig.到期时间}',
        width : 100
      }

      ] ],
      toolbar : '#toolbar'
    });
    dataGrid[3] = $('#dataGrid3').datagrid({
      url : '/v2_user_comp_query/device_info',
      fit : true,
      fitColumns : true,
      border : false,
      checkOnSelect : false,
      selectOnCheck : false,
      nowrap : false,
      striped : true,
      rownumbers : true,
      singleSelect : true,
      frozenColumns : [ [

      ] ],
      columns : [ [ {
        field : 'deviceType',
        title : '${internationalConfig.授权设备类型}',
        width : 100,
        formatter : function(value) {
          if(value==1){
            return "${internationalConfig.超级电视}";
          }else if(value==2){
            return "${internationalConfig.超级手机}";
          }else if(value==3){
            return "${internationalConfig.盒子}";
          }else if(value==4){
            return "${internationalConfig.路由器}";
          }else if(value==5){
            return "${internationalConfig.酷派手机}";
          }else{
            return value;
          }

        }
      },{
        field : 'mac',
        title : 'mac',
        width : 100
      }, {
        field : 'deviceModel',
        title : '${internationalConfig.设备型号}',
        width : 100
      }, {
        field : 'createTime',
        title : '${internationalConfig.授权时间}',
        width : 100
      }, {
        field : 'operator',
        title : '${internationalConfig.操作}',
        width : 100,
        formatter : function(value, row, index) {
            var str = '&nbsp;';
            str += '<input type="image" onclick="removeFun(' + row.userId + ',\'' + row.mac + '\',' + row.deviceType + ')" src="/static/style/images/extjs_icons/cancel.png" title="${internationalConfig.解除授权}" />';
            return str;
        }
      }

      ] ],
      toolbar : '#toolbar'
    });
    dataGrid[4] = $('#dataGrid4').datagrid({
      url : '/v2_user_comp_query/live_ticket',
      fit : true,
      fitColumns : true,
      border : false,
      checkOnSelect : false,
      selectOnCheck : false,
      nowrap : false,
      striped : true,
      rownumbers : true,
      singleSelect : true,
      frozenColumns : [ [

      ] ],
      columns : [ [ {
        field : 'channel',
        title : '${internationalConfig.频道}',
        width : 100,
        formatter : function(value) {
          if(value=="04"){
             return "${internationalConfig.体育}";
          }else if(value=="09"){
             return "${internationalConfig.音乐}";
          }
          return value;
        }
      }, {
        field : 'project',
        title : '${internationalConfig.赛事}',
        width : 100,
        formatter : function(value) {
          if(Dict.v2SeasonLiveDic[value]==null){
            return value;
          }
          return Dict.v2SeasonLiveDic[value];
        }
      }, {
        field : 'screening',
        title : '${internationalConfig.场次ID}',
        width : 100
      }, {
        field : 'amount',
        title : '${internationalConfig.票数}',
        width : 100
      }, {
        field : 'deadline',
        title : '${internationalConfig.有效期}',
        width : 100
      }
      ] ],
      toolbar : '#toolbar'
    });
    dataGrid[5] = $('#dataGrid5').datagrid({
      url : '/v2_user_comp_query/virtual_tickets',
      fit : true,
      fitColumns : true,
      border : false,
      checkOnSelect : false,
      selectOnCheck : false,
      nowrap : false,
      striped : true,
      rownumbers : true,
      singleSelect : true,
      frozenColumns : [ [

      ] ],
      columns : [ [ {
        field : 'amount',
        title : '${internationalConfig.票数}',
        width : 100
      }, {
        field : 'endtime',
        title : '${internationalConfig.失效日期}',
        width : 100
      }, {
        field : 'ticketDesc',
        title : '${internationalConfig.观影券描述}',
        width : 100
      }
      ] ],
      toolbar : '#toolbar'
    });
    dataGrid[6] = $('#dataGrid6').datagrid({
      url : '/v2_user_comp_query/movie_on_demand',
      fit : true,
      fitColumns : true,
      border : false,
      checkOnSelect : false,
      selectOnCheck : false,
      nowrap : false,
      striped : true,
      rownumbers : true,
      singleSelect : true,
      frozenColumns : [ [

      ] ],
      columns : [ [ {
        field : 'productName',
        title : '${internationalConfig.影片名称}',
        width : 100
      }, {
        field : 'createTime',
        title : '${internationalConfig.创建时间}',
        width : 100
      }, {
        field : 'endTime',
        title : '${internationalConfig.有效时间}',
        width : 100
      }
      ] ],
      toolbar : '#toolbar'
    });
    dataGrid[7] = $('#dataGrid7').datagrid({
      url : '/v2_user_comp_query/transfer_vip',
      fit : true,
      fitColumns : true,
      border : false,
      checkOnSelect : false,
      selectOnCheck : false,
      nowrap : false,
      striped : true,
      rownumbers : true,
      singleSelect : true,
      frozenColumns : [ [

      ] ],
      columns : [ [ {
        field : 'realUserId',
        title : '${internationalConfig.转入用户id}',
        width : 100
      }, {
        field : 'virtualUserId',
        title : '${internationalConfig.转出用户id}',
        width : 100
      }, {
        field : 'createTime',
        title : '${internationalConfig.转移时间}',
        width : 100
      }, {
        field : 'productName',
        title : '${internationalConfig.产品名称}',
        width : 100,
        formatter : function(value) {
          if(value==null){
            return "${internationalConfig.观影券}";
          }
          return value;
        }
      }
      ] ],
      toolbar : '#toolbar'
    });
    dataGrid[8] = $('#dataGrid8').datagrid({
      url:'/v2_user_comp_query/customer_transfer_vip',
      data : [],
      fit : true,
      fitColumns : true,
      border : false,
      checkOnSelect : false,
      selectOnCheck : false,
      nowrap : false,
      striped : true,
      rownumbers : true,
      singleSelect : true,
      frozenColumns : [ [

      ] ],
      columns : [ [  {
        field : 'productName',
        title : '${internationalConfig.会员名称}',
        width : 100
      },{
        field : 'fromUserId',
        title : '${internationalConfig.转出用户id}',
        width : 100
      },{
        field : 'toUserId',
        title : '${internationalConfig.转入用户id}',
        width : 100
      },{
        field : 'updateTime',
        title : '${internationalConfig.转移时间}',
        width : 100
      }, {
        field : 'transferDays',
        title : '${internationalConfig.转移天数}',
        width : 100
      },  {
        field : 'operator',
        title : '${internationalConfig.操作人}',
        width : 100
      }
      ] ],
      toolbar : '#toolbar'
    });
    dataGrid[9] = $('#dataGrid9').datagrid({
      url:'/v2_user_comp_query/third_duration',
      data : [],
      fit : true,
      fitColumns : true,
      border : false,
      checkOnSelect : false,
      selectOnCheck : false,
      nowrap : false,
      striped : true,
      rownumbers : true,
      singleSelect : true,
      frozenColumns : [ [

      ] ],
      columns: [[
        {
          field: 'userId',
          title: '${internationalConfig.用户ID}',
          width: 40,
          sortable: false
        },
        {
          field: 'vendorVipName',
          title: '${internationalConfig.商家产品名称}',
          width: 100,
          sortable: false
        },
        {
          field: 'startTime',
          title: '${internationalConfig.会员开始时间}',
          width: 60,
          sortable: false
        },
        {
          field: 'endTime',
          title: '${internationalConfig.会员结束时间}',
          width: 60,
          sortable: false
        }

      ]],
      toolbar : '#toolbar'
    });
  });
    function searchFun() {
      /*var url = [   //九个接口
                  "/v2_user_comp_query/user_info",
                  "/v2_user_comp_query/vip_info",
                  "/v2_user_comp_query/machine_info",
                  "/v2_user_comp_query/device_info",
                  "/v2_user_comp_query/live_ticket",
                  "/v2_user_comp_query/virtual_tickets",
                  "/v2_user_comp_query/movie_on_demand",
                  "/v2_user_comp_query/transfer_vip",
                  "/v2_user_comp_query/third_duration"
                ];*/
      var queryTerms = $.serializeObject($('#searchForm'))
      var js_key = $(".js_key").val();
      var js_value = trim($(".js_value").val());
      if(js_key=="uid"&&(!/^[0-9]+$/.test(js_value))){
        parent.$.messager.alert('${internationalConfig.提示}', '${internationalConfig.用户ID必须为数字}', 'info');
        return false;
      }
      queryTerms[js_key] = js_value;
      for(var i=0;i<dataGrid.length;i++){
        //dataGrid[i].datagrid({'url':url[i],'queryParams': queryTerms});
        dataGrid[i].datagrid('load', queryTerms);
      }
    }
  function trim(str){ //删除左右两端的空格
    return str.replace(/(^\s*)|(\s*$)/g, "");
  }
   function formatterTime(ms){
        var thisTime=new Date(ms);
        var str='',month=thisTime.getMonth()+1,date=thisTime.getDate(),hours=thisTime.getHours(),minute=thisTime.getMinutes(),seconds=thisTime.getSeconds();

        return str+=thisTime.getFullYear()+'/'+(month < 10 ? "0" + month : month)+'/'+ (date > 9 ? date : "0" + date) + " " + (hours > 9 ? hours : "0" + hours) + ":" + (minute > 9 ? minute : "0" + minute) + ":" + (seconds > 9 ? seconds : "0" + seconds);

   }

  function allow(uid){
    parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.您是否要解禁当前用户}？', function(b) {
      if (b) {
        parent.$.messager.progress({
          title : '${internationalConfig.提示}',
          text : '${internationalConfig.数据处理中}....'
        });
        $.post('/v2_user_comp_query/allow', {
          'uid' : uid
        }, function(result) {
          if (result.code == 0) {
            $("#lookup_win").window("close");
            parent.$.messager
                    .alert(
                            '${internationalConfig.成功}',
                            '${internationalConfig.解禁成功}',
                            'success');
            $(".js-search").trigger('click');
          }else {
            parent.$.messager
                    .alert(
                            '${internationalConfig.失败}',
                            '${internationalConfig.解禁失败}',
                            'error');
          }
          parent.$.messager.progress('close');
        }, 'JSON');
      }
    });
  }

  function banned(uid){
    parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.您是否要封禁当前用户}？', function(b) {
      if (b) {
        parent.$.messager.progress({
          title : '${internationalConfig.提示}',
          text : '${internationalConfig.数据处理中}....'
        });
        $.post('/v2_user_comp_query/banned', {
          'uid' : uid
        }, function(result) {
          if (result.code == 0) {
            $("#lookup_win").window("close");
            parent.$.messager
                    .alert(
                            '${internationalConfig.成功}',
                            '${internationalConfig.封禁成功}',
                            'success');
            $(".js-search").trigger('click');
          }else {
            parent.$.messager
                    .alert(
                            '${internationalConfig.失败}',
                            '${internationalConfig.封禁失败}',
                            'error');
          }
          parent.$.messager.progress('close');
        }, 'JSON');
      }
    });
  }

  function removeFun(userId, mac, deviceType){
    parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.本操作将解除本设备与UID的关系}', function (b) {
      if (b) {
        parent.$.messager.progress({
          title: '${internationalConfig.提示}',
          text: '${internationalConfig.数据处理中请稍后}....'
        });
        $.post('/v2_user_comp_query/remove_device', {
          userId: userId, mac: mac, deviceType: deviceType
        }, function (result) {
          if (result.code == 0) {
            $("#lookup_win").window("close");
            parent.$.messager
                    .alert(
                            '${internationalConfig.成功}',
                            '${internationalConfig.解除成功}',
                            'success');
            $(".js-search").trigger('click');
          }else {
            parent.$.messager
                    .alert(
                            '${internationalConfig.失败}',
                            '${internationalConfig.解除失败}',
                            'error');
          }
          parent.$.messager.progress('close');
        }, 'JSON');
      }
    });
  }

  function closeFun(uid, productId){
      parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.确认关闭自动续费}', function (b) {
        if (b) {
          parent.$.messager.progress({
            title: '${internationalConfig.提示}',
            text: '${internationalConfig.数据处理中请稍后}....'
          });
          $.post('/v2_user_comp_query/cancel_auto_renew', {
            uid: uid, productId: productId
          }, function (result) {
            if (result.code == 0) {
                $("#lookup_win").window("close");
                parent.$.messager
                      .alert(
                      '${internationalConfig.成功}',
                      '${internationalConfig.取消成功}',
                      'success');
                $(".js-search").trigger('click');
            }else {
                parent.$.messager
                    .alert(
                    '${internationalConfig.失败}',
                    '${internationalConfig.取消失败}',
                    'error');
            }
            parent.$.messager.progress('close');
          }, 'JSON');
        }
      });
  }
   
  function cleanFun() {
    $('#searchForm input').val('');
    for(var i=0;i<dataGrid.length;i++){
      dataGrid[i].datagrid('load', {});
    }

  }
  
  Date.prototype.format = function(format) {
    if (!format) {
      format = "yyyy-MM-dd hh:mm:ss";
    }
    var o = {
      "M+" : this.getMonth() + 1, // month
      "d+" : this.getDate(), // day
      "h+" : this.getHours(), // hour
      "m+" : this.getMinutes(), // minute
      "s+" : this.getSeconds(), // second
      "q+" : Math.floor((this.getMonth() + 3) / 3), // quarter
      "S" : this.getMilliseconds()
    // millisecond
    };
    if (/(y+)/.test(format)) {
      format = format.replace(RegExp.$1, (this.getFullYear() + "")
          .substr(4 - RegExp.$1.length));
    }
    for ( var k in o) {
      if (new RegExp("(" + k + ")").test(format)) {
        format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k]
            : ("00" + o[k]).substr(("" + o[k]).length));
      }
    }
    return format;
  };
  
  function formatterdate(val, row) {
    if (val == null) {
      return "";
    }
    var date = new Date(val);
    return date.format("yyyy-MM-dd hh:mm:ss");
  }

  function showOtherFunction(e) {
    var idValue = $(e).attr("id");
    var userIdValue = $(".js_value").val();
    var userInfo = $(".js_key  option:selected").val();
    if(userIdValue == undefined || userIdValue == '') {
      parent.$.messager.alert('${internationalConfig.失败}', '${internationalConfig.用户ID不能为空}', 'error');
      return ;
    }
      var userId = '';
      if(userInfo=="uid"){
          userId='?userId=' + userIdValue;
      }
    if(idValue == 'userPay') {
      parent.iframeTab.init({url:'pay_query/pay_query.do' + userId,text:'${internationalConfig.用户支付查询}'});
    } else if(idValue == 'consumeOrder') {
        parent.iframeTab.init({url:'consume/consumeOrder?userInfo='+userInfo+'&uid=' + userIdValue,text:'${internationalConfig.消费订单查询}2.0'});
    } else if(idValue == 'letpointQuery') {
      parent.iframeTab.init({url:'lepoint_recharge/lepoint_recharge.do' + userId,text:'${internationalConfig.乐点充值查询}'});
    } else if(idValue == 'freeVip') {
      parent.iframeTab.init({url:'free_vip/free_vip.do' + userId,text:'${internationalConfig.开通免费会员}'});
    } else if(idValue == 'userLetPont') {
      parent.iframeTab.init({url:'user_lepoint/user_lepoint.do' + userId,text:'${internationalConfig.用户账户查询}'});
    }
  }

  function transferVip(userid,productId,productName,isSubscribe) {
    parent.$.modalDialog({
      title : '${internationalConfig.会员转移操作}',
      width : 1000,
      height : 350,
      href : '/v2_user_comp_query/get_tv_vip?userId='+userid+'&productId='+productId+'&productName='+encodeURI(productName)+'&isSubscribe='+isSubscribe,
      onClose:function(){
        this.parentNode.removeChild(this);
      },
      buttons : [ {
        text : '${internationalConfig.确定}',
        handler : function() {
          //parent.$.modalDialog.openner_dataGrid = 111;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
          var f = parent.$.modalDialog.handler.find('#form');
          submitFun(f,"/v2_user_comp_query/transferVip");
          //f.submit();
        }
      }, {
        text : "${internationalConfig.返回}",
        handler : function() {
          parent.$.modalDialog.handler.dialog('close');
        }
      } ]
    });
  }
  function submitFun(f,url) {
    var data = f.serializeJson();
    if(data.jsOpTime==data.transferDays){
        data.transferType=1;
    }
    if (f.form("validate")) {
      parent.$.messager.progress({
        title : '${internationalConfig.提示}',
        text : '${internationalConfig.数据处理中}....'
      });
      $.ajax({
        url : url,
        type : "get",
        data : data,
        dataType : "json",
        success : function(result) {
          parent.$.messager.progress('close');
          if (result.code == 0) {
            parent.$.messager.alert('${internationalConfig.成功}', "${internationalConfig.会员转移成功}", 'success');
            searchFun();
            parent.$.modalDialog.handler.dialog('close');
          } else if (result.code == 2){
            parent.$.messager.alert('${internationalConfig.错误}', '<div style="word-break:break-all;">${internationalConfig.转入用户id不能等于转出用户id}</div>', 'error');
          } else {
            parent.$.messager.alert('${internationalConfig.错误}', '<div style="word-break:break-all;">${internationalConfig.会员转移失败}</div>', 'error');
          }
        },

        error : function() {}
      })
    }
  }
</script>
</head>
<body>
  <div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'">
      <form id="searchForm">
        <table class="table-td-four">
          <tr>
            <td>
              <select name="" class="span2 js_key">
                <option value="uid">${internationalConfig.用户ID}</option>
                <option value="email">${internationalConfig.邮箱}</option>
                <option value="mobile">${internationalConfig.电话号码}</option>
              </select>
            </td>
            <td>
              <input class="span2 js_value"/>
            </td>
            <td  nowrap="nowrap">${internationalConfig.应用终端}：
              <select name="terminal" class="span2 js_terminal">
                <option value="141002">PC(Client)</option>
                <option value="141007">SuperTV</option>
                <option value="141001">Web</option>
                <option value="141003">Mobile(Android)</option>
                <option value="141004">SuperMobile</option>
                <option value="141005">PAD(Android)</option>
                <option value="141006">MWeb</option>
                <option value="141008">IPAD</option>
                <option value="141009">IPhone</option>
                <option value="141010">TV</option>
              </select>
            </td>
            <td  nowrap="nowrap">mac： <input name="mac" class="span2"/>
            </td>
            <td>
              <a href="javascript:void(0);" class="l-btn l-btn-small js-search" onclick="searchFun();">${internationalConfig.查询} </a>
            </td>
            <td>
              <a href="javascript:void(0);" class="l-btn l-btn-small" onclick="cleanFun();">${internationalConfig.清空条件}</a>
            </td>
          </tr>
        </table>
      </form>
    </div>

    <div class="easyui-tabs" data-options="region:'center',border:false">
      <table class="table-shortcut" style="margin-bottom:5px;">
        <tr>
          <th>${internationalConfig.快捷功能}：</th>
          <td><input class="shortcut-item boss-btn" type="button" onclick="showOtherFunction(this);" id="userPay" xx="ss" value="${internationalConfig.用户支付查询}" />&nbsp;&nbsp;&nbsp;&nbsp;</td>
          <td><input class="shortcut-item boss-btn" type="button" onclick="showOtherFunction(this);" id="consumeOrder" value="${internationalConfig.消费订单查询}2.0" />&nbsp;&nbsp;&nbsp;&nbsp;</td>
          <td><input class="shortcut-item boss-btn" type="button" onclick="showOtherFunction(this);" id="letpointQuery" value="${internationalConfig.乐点充值查询} " />&nbsp;&nbsp;&nbsp;&nbsp;</td>
          <td><input class="shortcut-item boss-btn" type="button" onclick="showOtherFunction(this);" id="freeVip" value="${internationalConfig.开通免费会员}" />&nbsp;&nbsp;&nbsp;&nbsp;</td>
          <td><input class="shortcut-item boss-btn" type="button" onclick="showOtherFunction(this);" id="userLetPont" value="${internationalConfig.用户账户查询}" /></td>
        </tr>
      </table>
      <div title="${internationalConfig.基本信息}" class="clearfix table-w">
        <div class="table-cont">
          <table id="dataGrid0"></table>
        </div>
      </div>
      <div title="${internationalConfig.会员状态}" class="clearfix table-w">
        <div class="table-cont">
          <table id="dataGrid1"></table>
        </div>
      </div>
      <div title="${internationalConfig.机卡时长}" class="clearfix table-w">
        <div class="table-cont">
          <table id="dataGrid2"></table>
        </div>
      </div>
      <div title="${internationalConfig.授权设备}" class="clearfix table-w">
        <div class="table-cont">
          <table id="dataGrid3"></table>
        </div>
      </div>
      <div title="${internationalConfig.直播票}" class="clearfix table-w">
        <div class="table-cont">
          <table id="dataGrid4"></table>
        </div>
      </div>
      <div title="${internationalConfig.观影券}" class="clearfix table-w">
      <div class="table-cont">
        <table id="dataGrid5"></table>
      </div>
    </div>
    <div title="${internationalConfig.点播影片}" class="clearfix table-w">
      <div class="table-cont">
        <table id="dataGrid6"></table>
      </div>
    </div>
    <div title="${internationalConfig.IOS未登录会员转移记录}" class="clearfix table-w">
      <div class="table-cont">
        <table id="dataGrid7"></table>
      </div>
    </div>
    <div title="${internationalConfig.后台客服会员转移记录}" class="clearfix table-w">
      <div class="table-cont">
        <table id="dataGrid8"></table>
      </div>
    </div>
    <div title="${internationalConfig.第三方会员时长}" class="clearfix table-w">
      <div class="table-cont">
        <table id="dataGrid9"></table>
      </div>
    </div>

  </div>
  </div>
</body>
</html>
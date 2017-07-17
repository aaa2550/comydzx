<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.用户综合查询}</title>
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
</style>
<script type="text/javascript">
  var dataGrid;
  $(function() {
    dataGrid = $('#dataGrid').datagrid({
      url : '${pageContext.request.contextPath}/user_comp_query/data_grid.json',
      fit : true,
      fitColumns : true,
      border : false,
      pagination : true,
      idField : 'id',
      pageSize : 10,
      pageList : [ 10, 20, 30, 40, 50 ],
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
      }/* ,{
        field : 'letPointCount',
        title : '${internationalConfig.乐点账户}',
        width : 100
      } */,{
        field : 'statusDec',
        title : '${internationalConfig.是否禁用}',
        width : 100
      }, {
        field : 'registTime',
        title : '${internationalConfig.注册时间}',
        width : 100
      },{
          field : 'vipStutus',
          title : '${internationalConfig.综合查询会员状态}',
          width : 100,
          formatter : function(value, row) {
              var str = '';
                str += $
                    .formatString(
                        '<a href="javascript:;" onclick="lookup(\'{1}\',\'{2}\')" data-id="{0}"  uname="{1}" userid="{2}" >${internationalConfig.查看状态}</a>',value,row.uid,row.username);
              return str;
            }
        }

      ] ],
      toolbar : '#toolbar',
      onLoadSuccess : function() {
        $('#searchForm table').show();
        parent.$.messager.progress('close');
        $('#lookup_win').window({
          title:'${internationalConfig.当前会员信息}',
          collapsible:false,
          minimizable:false,
          maximizable:false,
          shadow:false,
          width:500,
          height:400
        });
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
  });
  function searchFun() {
    dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
  }
   function formatterTime(ms){
	    var thisTime=new Date(ms);
	    var str='',month=thisTime.getMonth()+1,date=thisTime.getDate(),hours=thisTime.getHours(),minute=thisTime.getMinutes(),seconds=thisTime.getSeconds();

	    return str+=thisTime.getFullYear()+'/'+(month < 10 ? "0" + month : month)+'/'+ (date > 9 ? date : "0" + date) + " " + (hours > 9 ? hours : "0" + hours) + ":" + (minute > 9 ? minute : "0" + minute) + ":" + (seconds > 9 ? seconds : "0" + seconds);

	  }
 
   function lookup(uid,username){
	      var  tbody = $('.table-in tbody');
	      tbody.html('');
	      if(tbody.data('isReq')==true) return ;
	      tbody.data('isReq',true);
	      $.ajax({
	        type: "get",
	        url: "/user_comp_query/vipInfo",
	        data: {username:username, uid:uid, number:Math.random()},
	        dataType: "json",
	        success: function(res){
	                $('.td_uid').html(uid);
	                $('.td_username').html(username);
	                if(res.total>0){
	                    var data=res.rows,html='';
	                    var time=new Date().getTime();
	                    $.each(data,function(index,value){
                            var isSubscribe = "no";
                            if(value.isSubscribe == 2){
                                isSubscribe = "yes";
                            }
                            var vipbrand;
                            if(value.vipbrand==0){
                              vipbrand="";
                            }else{
                              vipbrand=value.vipbrand;
                            }

	                        if(value.valid==true){
	                                  html+='<tr>'+
	                                '<td class="">'+value.name+'</td>'+
	                                '<td class="">'+value.endTime+'</td>'+
                                    '<td class="">'+vipbrand+'</td>'+
	                                '<td class="">'+isSubscribe+'</td>';
	                        }else{
	                            html+='<tr>'+
	                            '<td class="font_grey">'+value.name+'</td>'+
	                            '<td class="font_grey">'+value.endTime+'</td>'+
                                '<td class="">'+vipbrand+'</td>'+
	                            '<td class="font_grey">'+isSubscribe+'</td>';
	                        }

                            if(value.valid==true && value.isSubscribe == 2){
                                html += '<td class=""><input type="image" onclick="closeFun(' + value.uid + ',' + value.productId + ',' + value.isV2 + ')" src="/static/style/images/extjs_icons/cancel.png" title="${internationalConfig.关闭自动续费}" /></td>';
                            }
	                        html += '</tr>';
	                    })
	                    if(tbody.length>0){
	                        tbody.html(html);
	                    }else{
	                        $(html).appendTo($('.table-in'));
	                    }
	                }else{ 
	                    var html="<tr><td colspan='3'>${internationalConfig.暂无会员购买记录}</td></tr>";
	                     if(tbody.length>0){
	                        tbody.html(html);
	                    }else{
	                        $(html).appendTo($('.table-in'));
	                    }
	                    
	                }
	                $("#lookup_win").window("open");

	                 tbody.data('isReq',false);
	          
	        },
	        error:function(){
	            tbody.data('isReq',false);
	        }

	      })

	    }
  function closeFun(uid, productId, isV2){
      console.log(uid + " " + productId + " " + isV2)
      parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.确认关闭自动续费}', function (b) {
        if (b) {
          parent.$.messager.progress({
            title: '${internationalConfig.提示}',
            text: '${internationalConfig.数据处理中请稍后}....'
          });
          $.post('/user_comp_query/cancel_auto_renew', {
            uid: uid, productId: productId, isV2: isV2
          }, function (result) {
            if (result.code == 0) {
                $("#lookup_win").window("close");
                parent.$.messager
                      .alert(
                      '${internationalConfig.成功}',
                      '${internationalConfig.取消成功}',
                      'success');
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
    dataGrid.datagrid('load', {});
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
    var userIdValue = $("#userId").val();
    if(userIdValue == undefined || userIdValue == '') {
      var dataTable = dataGrid.datagrid('getData');
      var row = dataTable.rows[0];
      if(row) {
        userIdValue = dataTable.rows[0].uid;
      }
    }
    
    if(userIdValue == undefined || userIdValue == '') {
      parent.$.messager.alert('${internationalConfig.失败}', '${internationalConfig.用户ID不能为空}', 'error');
      return ;
    }
    
    if(idValue == 'userPay') {
      parent.iframeTab.init({url:'pay_query/pay_query.do?userId=' + userIdValue,text:'${internationalConfig.用户支付查询}'});
    } else if(idValue == 'consumeOrder') {
      parent.iframeTab.init({url:'consume/consume.do?userId=' + userIdValue,text:'${internationalConfig.消费查询}'});
    } else if(idValue == 'letpointQuery') {
      parent.iframeTab.init({url:'lepoint_recharge/lepoint_recharge.do?userId=' + userIdValue,text:'${internationalConfig.乐点充值查询}'});
    } else if(idValue == 'freeVip') {
      parent.iframeTab.init({url:'free_vip/free_vip.do?userId=' + userIdValue,text:'${internationalConfig.开通免费会员}'});
    } else if(idValue == 'userLetPont') {
      parent.iframeTab.init({url:'user_lepoint/user_lepoint.do?userId=' + userIdValue,text:'${internationalConfig.用户账户查询}'});
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
            <td  nowrap="nowrap">${internationalConfig.用户ID}： <input id="userId" name="uid"
              class="span2" />
            </td>
            <td  nowrap="nowrap">${internationalConfig.邮箱}： <input id="email" name="email"
              class="span2" />
            </td>
            </tr>
            <tr>
            <td  nowrap="nowrap">${internationalConfig.电话号码}： <input id="phoneNum" name="mobile"
              class="span2" />
            </td>
            <td colspan=2  nowrap="nowrap">${internationalConfig.昵称}： <input id="nickName" name="nickname"
              class="span2" />
            </td>
          </tr>
        </table>
      </form>
      
    </div>
    <div data-options="region:'center',border:false">
      <table class="table-shortcut" style="margin-bottom:5px;">
        <tr>
          <th>${internationalConfig.快捷功能}：</th>
          <td><input class="shortcut-item boss-btn" type="button" onclick="showOtherFunction(this);" id="userPay" xx="ss" value="${internationalConfig.用户支付查询}" />&nbsp;&nbsp;&nbsp;&nbsp;</td>
          <td><input class="shortcut-item boss-btn" type="button" onclick="showOtherFunction(this);" id="consumeOrder" value="${internationalConfig.消费订单查询}" />&nbsp;&nbsp;&nbsp;&nbsp;</td>
          <td><input class="shortcut-item boss-btn" type="button" onclick="showOtherFunction(this);" id="letpointQuery" value="${internationalConfig.乐点充值查询} " />&nbsp;&nbsp;&nbsp;&nbsp;</td>
          <td><input class="shortcut-item boss-btn" type="button" onclick="showOtherFunction(this);" id="freeVip" value="${internationalConfig.开通免费会员}" />&nbsp;&nbsp;&nbsp;&nbsp;</td>
          <td><input class="shortcut-item boss-btn" type="button" onclick="showOtherFunction(this);" id="userLetPont" value="${internationalConfig.用户账户查询}" /></td>
        </tr>
      </table>
      <table id="dataGrid"></table>
    </div>
    <br />

  </div>
  <div id="lookup_win" class="easyui-window" closed="true" style=" width:500px;padding:5px;">
    <table style="width: 100%" class="table table-form">
      <colgroup>
        <col width="160">
        <col width="160">
        <col width="*">
      </colgroup>
      
      <tr style="border-top:none;">

        <th style="border-top:none;">&nbsp;&nbsp;&nbsp;${internationalConfig.用户ID}：<span class="td_uid"></span></th>
    
      </tr>

      <tr>
        <table width='80%' border="1" align="center" class="table-in">
          <thead>
	          <tr >
	            <th>${internationalConfig.会员名称}</th>
	            <th>${internationalConfig.会员到期时间}</th>
                <th>${internationalConfig.冠名方}</th>
                <th>${internationalConfig.自动续费}</th>
                <%--<th>${internationalConfig.操作}</th>--%>
	          </tr>
          </thead>
          <tbody></tbody>
        </table>
      </tr> 
      
      
      
    </table>
  <div id="toolbar" style="display: none;">
    <a href="javascript:void(0);" class="easyui-linkbutton"
      data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
      data-options="iconCls:'brick_delete',plain:true"
      onclick="cleanFun();">${internationalConfig.清空条件}</a>
  </div>
</body>
</html>
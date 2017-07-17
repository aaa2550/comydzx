<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<script src="/static/lib/swfupload/swfupload.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
  $(function() {
    parent.$.messager.progress('close');
    $('#form').form({
      url : '${pageContext.request.contextPath}/activity/add.json',
      onSubmit : function() {
        parent.$.messager.progress({
          title : '${internationalConfig.提示}',
          text : '${internationalConfig.数据处理中}......'
        });

        var isValid = $(this).form('validate');
        if (!isValid) {
          parent.$.messager.progress('close');
        }
        return isValid;
      },
      success : function(obj) {
        parent.$.messager.progress('close');
        var result = $.parseJSON(obj);
        if (result.code == 0) {
                  parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.添加成功}', 'success');
          parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
          parent.$.modalDialog.handler.dialog('close');
        } else {
          parent.$.messager.alert('${internationalConfig.页面错误}', result.msg, 'error');
        }
      }
    });

  });

  function computeByDeduction(dom) {
    var deductionInput = $(dom);
    var deduction = deductionInput.val();
    if (deduction.trim != "" && !isNaN(deduction)) {
      var closestTr = deductionInput.closest("tr");
      var priceDom = closestTr.find(".price");
      var price = parseInt(priceDom.text());
      var promotion =((price*100 - deduction*100)/100).toFixed(2);
      var promotionDom = closestTr.find(".promotion");
      if (promotion >= 0) {
        promotionDom.text(promotion);
      } else {
        promotionDom.text("N/A");
      }
      
      var discount = (promotion / price * 10).toFixed(2);
      var discountDom = closestTr.find(".discount");
      if (discount >= 0) {
        discountDom.text(discount);
      } else {
        discountDom.text("N/A");
      }
    }

  }

  //增加自定义的表单验证规则
  /*    $.extend($.fn.validatebox.defaults.rules, {
   time: {
   validator: function(value, param){
   var reg = new RegExp('^([01]\d|2[0-3]):?([0-5]\d)$');
   return reg.text(value);
   },
   message : '请输入正确的时间格式'
   }
   });*/

  $.extend($.fn.validatebox.defaults.rules, {
    time : {
      validator : function(value, param) {
        var reg = new RegExp(
            '(^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$)|(^24:00$)');
        return reg.test(value);
      },
      message : '${internationalConfig.请输入合法时间}'
    }
  });

  function activityTypeChange() {
    var val = $('input:radio[name="type"]:checked').val();
    if (val == 1) {
      $('#paytypeid').hide();
    } else {
      $('#paytypeid').show();
      $("#tvOrient").val("0");
      tvOrientChange();
    }
  }

  function tvOrientChange() {
    var tvOrientValue = $("#tvOrient").val();
    if(tvOrientValue == 1) {
      $("input[name='terminals']").prop("checked", false);
      $("#terminal141007").prop("checked", true);
//      $("input[name='terminals']").attr("disabled", true);
      $("#tradeType0").prop("checked", true);
      activityTypeChange();
    } else {
//      $("input[name='terminals']").attr("disabled", false);
    }
  }

  function showCont(){
    switch($("input[name=groupId]:checked").attr("value")){
      case "1":
          $("input[name=begin1]").attr("disabled", false);
          $("input[name=begin2]").attr("disabled", false);
          $("input[name=end1]").attr("disabled", false);
          $("input[name=end2]").attr("disabled", false);
          break;
        default:
          $("input[name=begin1]").attr("disabled", true);
          $("input[name=begin2]").attr("disabled", true);
          $("input[name=end1]").attr("disabled", true);
          $("input[name=end2]").attr("disabled", true);
          break;
    }
  }
</script>
<style>
<style>
.table_border {
  border: solid 1px #B4B4B4;
  border-collapse: collapse;
  width:100%;
}

.table_border tr th {
  padding-left: 4px;
  height: 20px;
  border: solid 1px #B4B4B4;
}

.table_border tr td {
  line-height: 20px;
  padding: 4px;
  border: solid 1px #B4B4B4;
  text-align:center
}
.table-form td.join_times{
vertical-align:top;
}
.table-form .tab_name{
display: inline-block;
float: left;
line-height: 40px;
}
.table-form .fenzu_span{
display: block;
float: left;
} 
.kinds_wrap{
float: left;
width:270px;
}
.times_p{
line-height:30px;font-size:12px
}
.times_p span{
display:inline-block;
width:78px;
}
.table .no_top_border{
border-top:none;
padding-right:5px;
display: inline-block;
padding-top: 5px;
}
.packageStatus select{
width:80px;
}
.member_model{
display:inline-block;
line-height: 30px;
}
.member_model li{
line-height: 30px;}
.member_model li .member_vip_time{
display: inline-block;
float: left;
}
.member_model li .select_radio{
float:left;
margin-top:8px;
}

.member_model li .member_vip_time p{
margin-bottom: 5px;
}
select.short-select-i{
width:150px;
}
</style>
<div class="easyui-layout" data-options="fit:true,border:false">
  <div data-options="region:'center',border:false" title=""
    style="overflow: auto">
    <form id="form" method="post" action="${pageContext.request.contextPath}/mealController/create">
      <table class="table table-form" style="width: 100%">
        <tr>
          <td>
          <span class="tab_name"><b>${internationalConfig.价格标题}：</b></span>
          <input class="easyui-validatebox"
              type="text" name="title" data-options="required:true"
              title="${internationalConfig.最多5个汉字}">
          </td>
          
          <td>
          <span class="tab_name"><b>${internationalConfig.促销签文字}：</b></span>
          <input class="easyui-validatebox"
              name="label" type="text" data-options="required:true">
          </td>
        </tr>
        <tr>
          
          <td>
          <span class="tab_name"><b>${internationalConfig.营销文字}：</b></span>
          <textarea class="easyui-validatebox"
                name="text" data-options="required:true"></textarea>
          </td>
          
          <td class="join_times">
          <span class="tab_name"><b>${internationalConfig.用户参加次数}：</b></span>
            <select name="userQuota" class="easyui-validatebox" style="width:150px;">
                <option value="-1">${internationalConfig.无限次}</option>
                <option value="1">1${internationalConfig.次}</option>
                <option value="2">2${internationalConfig.次}</option>
                <option value="3">3${internationalConfig.次}</option>
                <option value="4">4${internationalConfig.次}</option>
                <option value="5">5${internationalConfig.次}</option>
                <option value="6">6${internationalConfig.次}</option>
                <option value="7">7${internationalConfig.次}</option>
                <option value="8">8${internationalConfig.次}</option>
                <option value="9">9${internationalConfig.次}</option>
                <option value="10">10${internationalConfig.次}</option>
                <option value="11">11${internationalConfig.次}</option>
                <option value="12">12${internationalConfig.次}</option>
            </select>
          </td>
        </tr>
          <tr>
          <td colspan="3" class="times_td">
          <span class="tab_name"><b>${internationalConfig.定向活动类型}：</b></span>
          <ul class="member_model"> 
            <li><span class="no_top_border">${internationalConfig.会员类型}</span>
            	<span class="no_top_border"><input type="radio" value="0" name="vip" >${internationalConfig.全部} </span>
             	<span class="no_top_border"><input type="radio" value="1" name="vip" >${internationalConfig.移动影视会员}  </span>
             	<span class="no_top_border"><input type="radio" value="9" name="vip" >${internationalConfig.全屏影视会员}</span>
             </li> 
            <li><input type="radio" value="1" name="userType" >${internationalConfig.全部用户}</li> 
            <li><input type="radio" value="2" name="userType">${internationalConfig.过期用户}</li>
            <li><input type="radio" value="3" name="userType">${internationalConfig.一直非会员用户}</li>
            <li>
              <input class="select_radio" type="radio" value="4" name="userType">
              <div class="member_vip_time">
                <p>${internationalConfig.会员有效期剩余} <input type="text" value="" name="begin1"> 一  <input type="text" value="" name="end1"> ${internationalConfig.天的用户} </p>
                <p>${internationalConfig.会员有效期过期} <input type="text" value="" name="begin2"> 一 <input type="text" value="" name="end2"> ${internationalConfig.天的用户}</p>
              </div>
            </li>
          </ul>
          </td>
        </tr>
        <tr>
          <td colspan="2">
          <span class="tab_name"><b>${internationalConfig.活动方式}：</b></span>
            <span class="no_top_border"><input type="radio" id="tradeType0" name="type" value="1" id="packageid" checked="checked" onchange="activityTypeChange()" />&nbsp;${internationalConfig.套餐优惠}</span>
            <span class="no_top_border"><input type="radio" id="tradeType1" name="type" value="2" id="payid" onchange="activityTypeChange()" />&nbsp;${internationalConfig.支付方式优惠}</span>
          </td>
        </tr>
        <tr style="display: none;" id="paytypeid">
          
          <td colspan="10">
          <span class="tab_name"><b>${internationalConfig.支付方式}：</b></span>
            <table>
              <tr>
                <td class="no_top_border"><c:forEach
                    items="${paytypes}" var="paytypes" varStatus="varStatus">
                    <input type="checkbox" name="paytypes"
                      value="${paytypes.typeid}" />&nbsp;${paytypes.name}&nbsp;&nbsp;&nbsp;&nbsp;
                                               </c:forEach>
                               </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          
          <td colspan="2">
          <span class="tab_name"><b>${internationalConfig.终端}：</b></span>
            <table>
              <tr>
                <c:forEach items="${terminals}" var="terminal"
                  varStatus="varStatus">
                  <td class="no_top_border"><input type="checkbox" id="terminal${terminal.terminalId}"
                    name="terminals" value="${terminal.terminalId}" />&nbsp;${terminal.terminalName}
                  </td>
                </c:forEach>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          
            <td>
            <span class="tab_name"><b>${internationalConfig.促销对象}：</b></span>
            <!--<c:forEach items="${target}" var="var">
                <input name="activityTarget" type="checkbox" value="${var.value}">
                      ${var.description}
                </c:forEach>-->
                <span class="no_top_border"><input name="activityTarget" type="checkbox" value="22">${internationalConfig.支持乐点支付}</span>
                <span class="no_top_border"><input name="activityTarget" type="checkbox" value="21">${internationalConfig.登录用户}</span>
                </td>
            <td>
            <span class="tab_name"><b>${internationalConfig.所属分组}：</b></span>
              <div class="kinds_wrap">
                  <c:forEach items="${activityGroups}" var="pg"
                    varStatus="varStatus">
                    <c:if test="${pg == '1'}">
                      <label class="no_top_border"><input type="radio"
                      name="groupId" value="${pg}" checked="checked" onclick="showCont()" />&nbsp;${internationalConfig.默认}
                    </label>
                    </c:if>
                    <c:if test="${pg != '1'}">
                      <label class="no_top_border"><input type="radio"
                        name="groupId" value="${pg}" onclick="showCont()" />&nbsp;${pg}
                      </label>
                    </c:if>
                  </c:forEach>
              </div>
            </td>
          </tr>
          <tr>
            <td>
            <span class="tab_name"><b>${internationalConfig.可否使用代金券}：</b></span>
            <select name="coupon" class="short-select-i" style="width:150px;">
                  <!--<c:forEach items="${coupon}" var="var">
                    <option value="${var.value}">${var.description}</option>
                  </c:forEach>-->
                  <option value="11" selected>${internationalConfig.不支持}</option>
                  <option value="12">${internationalConfig.与活动互斥使用}</option>
                  <option value="13">${internationalConfig.支持}</option>
              </select>
            </td>
            <td>
              <span class="tab_name" ><b>${internationalConfig.TV定向活动}：</b></span>
              <select id="tvOrient" name="tvOrient" onchange="tvOrientChange(this)" style="width:150px;">
                <option value="0" <c:if test="${activity.tvOrient == 0}"> selected="selected" </c:if>>${internationalConfig.否}</option>
                <option value="1" <c:if test="${activity.tvOrient == 1}"> selected="selected" </c:if>>${internationalConfig.是}</option>
              </select>
            </td>
          </tr>
        <tr>
          <td  colspan="2"><b>${internationalConfig.TV定向活动图片}：</b><input type="text" id="tvOrientImg" name="tvOrientImg" class="easyui-validatebox"/>&nbsp;&nbsp;<input class="buttoncenter" type="button" value="${internationalConfig.上传文件}" id="mobile_upload_btn" /> <span id="imgUrl-mobile" name="imgUrl-mobile" ></span></td>
          
        </tr>
        <tr>
          <td colspan="2">${internationalConfig.TV定向活动描述url}：<input type="text" id="tvOrientUrl" name="tvOrientUrl" class="easyui-validatebox" /></td>
        </tr>
        <tr>
          <td>
          <span class="tab_name"><b>${internationalConfig.开始日期}：</b></span>
          <input class="easyui-datebox" name="beginDate"data-options="required:true" /></td>
          <td><span class="tab_name"><b>${internationalConfig.结束日期}：</b></span><input class="easyui-datebox" name="endDate"
            data-options="required:true"></td>
        </tr>
        <tr>
          
          <td>
          <span class="tab_name"><b>${internationalConfig.每日开始时段}：</b></span>
          <span class="no_top_border"><input name="beginTime" value="00:00"
              class="easyui-validatebox"
              data-options="required:true,validType:'time'" />
          </span>
          </td>
          
          <td>
          <span class="tab_name"><b>${internationalConfig.每日结束时段}：</b></span>
          <span class="no_top_border"><input name="endTime" value="24:00"
              class="easyui-validatebox"
              data-options="required:true,validType:'time'" />
         </span>
          </td>
        </tr>
        <tr>
          <td colspan="10">
            <table class="table_border">
              <tr>
                <td>${internationalConfig.移动影视会员时长}</td>
                <td>${internationalConfig.原价}</td>
                <td>${internationalConfig.现价}</td>
                <td>${internationalConfig.促销价}</td>
                <td>${internationalConfig.折扣}</td>
                <td>${internationalConfig.减免金额}</td>
                <td>${internationalConfig.延长有效期}</td>
                <td>${internationalConfig.限量件数}</td>
                <td>${internationalConfig.套餐文案}</td>
                <td>${internationalConfig.是否参加活动}</td>
              </tr>
              <c:forEach items="${packageList}" var="var">
              <c:if test="${var.price>0.00 }">
                <tr>
                  <td id="package_${var.packageId}">${durationMap[var.duration]}</td>
                  <td class="original">${var.originPrice}</td>
                  <td class="price">${var.price}</td>
                  <td class="promotion">${var.price}</td>
                  <td class="discount">10</td>
                  <td class="deduction"><input type="text" value="0"
                    style="width: 25px" name="deduction_${var.packageId}"
                    class="easyui-numberbox"
                    data-options="precision:2,required:true,onChange:function() {
                      computeByDeduction(this);
                    }" /></td>
                  <td class="extension"><input type="text" value="0"
                    style="width: 25px" name="extension_${var.packageId}"
                    class="easyui-numberbox" data-options="required:true" /></td>
                  <td class="quota"><input type="text" value="${internationalConfig.不限}"
                    style="width: 34px" name="quota_${var.packageId}"
                    class="easyui-validatebox" data-options="required:true" /></td>
                  <td class="packageText"><input type="text" value=""
                    style="width: 100px" name="packagetext_${var.packageId}"
                    class="easyui-validatebox" title="${internationalConfig.最多14个汉字}" /></td>
                  <td class="packageStatus"><select
                    name="packagestatus_${var.packageId}">
                      <c:forEach items="${packagestatus}" var="var">
                        <option
                          <c:if test="${var.value == 42}"> selected="selected" </c:if>
                          value="${var.value}">${var.description}</option>
                      </c:forEach>
                  </select></td>
                </tr>
                </c:if>
              </c:forEach>
            </table>
          </td>
        <tr>
          <td colspan="10">
            <table class="table_border">
              <tr>
                <td>${internationalConfig.全屏影视会员时长}</td>
                <td>${internationalConfig.原价}</td>
                <td>${internationalConfig.现价}</td>
                <td>${internationalConfig.促销价}</td>
                <td>${internationalConfig.折扣}</td>
                <td>${internationalConfig.减免金额}</td>
                <td>${internationalConfig.延长有效期}</td>
                <td>${internationalConfig.限量件数}</td>
                <td>${internationalConfig.套餐文案}</td>
                <td>${internationalConfig.是否参加活动}</td>
              </tr>
              <c:forEach items="${seniorPackageList}" var="var">
              <c:if test="${var.price>0.00 }">
                <tr>
                  <td id="package_${var.packageId}">${durationMap[var.duration]}</td>
                  <td class="original">${var.originPrice}</td>
                  <td class="price">${var.price}</td>
                  <td class="promotion">${var.price}</td>
                  <td class="discount">10</td>
                  <td class="deduction"><input type="text" value="0"
                    style="width: 25px" name="deduction_${var.packageId}"
                     class="easyui-numberbox"
                    data-options="precision:2,required:true,onChange:function() {
                      computeByDeduction(this);
                    }" /></td>
                  <td class="extension"><input type="text" value="0"
                    style="width: 25px" name="extension_${var.packageId}"
                    class="easyui-numberbox" data-options="required:true" /></td>
                  <td class="quota"><input type="text" value="${internationalConfig.不限}"
                    style="width: 34px" name="quota_${var.packageId}"
                    class="easyui-validatebox" data-options="required:true" /></td>
                  <td class="packageText"><input type="text" value=""
                    style="width: 100px" name="packagetext_${var.packageId}"
                    class="easyui-validatebox" title="${internationalConfig.最多14个汉字}" /></td>
                  <td class="packageStatus"><select
                    name="packagestatus_${var.packageId}">
                      <c:forEach items="${packagestatus}" var="var">
                        <option
                          <c:if test="${var.value == 42}"> selected="selected" </c:if>
                          value="${var.value}">${var.description}</option>
                      </c:forEach>
                  </select></td>
                </tr>
                </c:if>
              </c:forEach>
            </table>
          </td>
        </tr>
        <tr>
          
          <td colspan="2">
          <span class="tab_name" style='width:20%;'><b>${internationalConfig.促销优先级}：</b></span>
          <input name="priority" type="text"
            class="easyui-numberbox" data-options="required:true"><font color="red">${internationalConfig.数字越小}</font></td>
        </tr>
        <tr>
          
          <td colspan="3">
          <span class="tab_name" style='width:20%;'><b>${internationalConfig.促销状态}：</b></span>
          <select name="status">
              <!--<c:forEach items="${status}" var="var">
                  <option <c:if test="${var.value == 32}"> selected="selected" </c:if> value="${var.value}">${var.description}</option>
              </c:forEach>-->
              <option value="31">${internationalConfig.上线}</option>
              <option value="32"   selected="selected">${internationalConfig.下线}</option>
          </select>
          </td>
        </tr>
      </table>
    </form>
  </div>
</div>
<script type="text/javascript">
var img_url = img_url||null ; //大推广图片
img_url = new SWFUpload({
  button_placeholder_id: "mobile_upload_btn",
  flash_url: "/static/lib/swfupload/swfupload.swf?rt="+Math.random(),
  upload_url: '/upload?cdn=sync',
  button_image_url: Boss.util.defaults.upload.button_image,
  button_cursor: SWFUpload.CURSOR.HAND,
  button_action: SWFUpload.BUTTON_ACTION.SELECT_FILE,
  file_size_limit: '8 MB',
  button_width: "61",
  file_post_name:"myfile",
  button_height: "24",
  file_types: "*.jpg;*.jpeg;*.png;*.bmp;*.gif",
  file_types_description: "All Image Files",
  button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
  upload_start_handler: function() {
  },
  upload_success_handler: function(file, response) {
    var HTML_VIEWS = '<a href='+response+' target="_blank">'+Boss.util.defaults.upload.viewText+'</a>&nbsp;&nbsp;&nbsp;&nbsp;';
    $("#imgUrl-mobile").html(HTML_VIEWS);
    $("#tvOrientImg").val(response);
  },
  file_queued_handler: function() {
    this.startUpload();
  },
  upload_error_handler: function(file, code, msg) {
    var message = Boss.util.defaults.upload.err + code + ': ' + msg + ', ' + file.name;
    alert(message);
  }
});
</script>
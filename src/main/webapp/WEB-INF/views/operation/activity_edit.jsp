<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script src="/static/lib/swfupload/swfupload.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
  $.extend($.fn.datebox.defaults.rules,
      {
        gtStartDate : {
          validator : function(value, param) {//
            if (param[0] && value) {
              if (value.length > 10) {
                value = value.substring(0, 10);
              }
              var ed_arr = value.split('-');
              var endDate = new Date(ed_arr[0], ed_arr[1] - 1,
                  ed_arr[2]);
              var sDate = $(param[0]).datebox('getValue');
              if (sDate) {
                if (sDate.length > 10) {
                  sDate = sDate.substring(0, 10);
                }
                var sd_arr = sDate.split('-');
                var startDate = new Date(sd_arr[0],
                    sd_arr[1] - 1, sd_arr[2]).getTime();
                if ((endDate.getTime() - startDate) > 0) {
                  return true;
                }
              }
            }
            return false;
          },
          message : "${internationalConfig.结束时间必须大于开始时间或者日期}"
        }
      });
  $(function() {
    parent.$.messager.progress('close');
    $('#form').form({
      url : '${pageContext.request.contextPath}/activity/update.json',
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
                  parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.编辑成功}', 'success');
          parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
          parent.$.modalDialog.handler.dialog('close');
        } else {
          parent.$.messager.alert('${internationalConfig.页面错误}', result.msg, 'error');
        }
      }
    });
  });

  checkTerminals();
  //查询活动对应的终端terminals
  function checkTerminals() {
    $
        .getJSON(
            '/activity/terminals.json?activityId=${activity.id}',
            {}, function(terminals) {
              for ( var i = 0; i < terminals.length; i++) {
                $("#terminal" + terminals[i]).prop(
                    "checked", true);
              }
            })
  }

  checkPatytypes();
  //查询活动对应的支付方式
  function checkPatytypes() {
    $
        .getJSON(
            '/activity/paytypes.json?activityId=${activity.id}',
            {}, function(paytypes) {
              if ('${activity.type}' == 1) {
                $('#paytypeid').hide();
                $("#tradeType0").prop("checked", true);
              } else {
                $("#tradeType1").prop("checked", true);
                $('#paytypeid').show();
              }
              for ( var i = 0; i < paytypes.length; i++) {
                $("#paytype" + paytypes[i]).prop(
                    "checked", true);
              }
            })
  }

  //增加自定义的表单验证规则
  $.extend($.fn.validatebox.defaults.rules, {
    number : {
      validator : function(value, param) {
        var reg = new RegExp("^[0-9]+(.[0-9]+)?$");
        return reg.test(value);
      },
      message : '${internationalConfig.请输入合法数字}'
    }
  });
  $.extend($.fn.validatebox.defaults.rules, {
    int : {
      validator : function(value, param) {
        var reg = new RegExp("^[0-9]+$");
        return reg.test(value);
      },
      message : '${internationalConfig.请输入合法整数}'
    }
  });
  $.extend($.fn.validatebox.defaults.rules, {
    amount : {
      validator : function(value, param) {
        var reg = new RegExp("^-?[0-9]+(.[0-9]+)?$");
        return reg.test(value);
      },
      message : '${internationalConfig.请输入合法金额}'
    }
  });
  $.extend($.fn.validatebox.defaults.rules, {
    discount : {
      validator : function(value, param) {
        var reg = new RegExp("^[0-1]+(.[0-9]+)?$");
        return reg.test(value);
      },
      message : '${internationalConfig.请输入合法折扣}'
    }
  });

  //注册按照卡类型进行页面控制的回调方法。
  $('input:radio[name=applyType]').click(function() {
    var value = $(this).val();
    //激活码
    var dhtc = $("#dhtc");
    var sqme = $("#sqme");
    if (value == 1) {
      dhtc.hide();
      sqme.show();
    }
    //兑换码
    if (value == 2) {
      dhtc.show();
      sqme.hide();
    }
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
</script>
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
</style>
<div class="easyui-layout" data-options="fit:true,border:false">
  <div data-options="region:'center',border:false" title=""
    style="overflow: auto;">
    <form id="form" method="post"
      action="${pageContext.request.contextPath}/mealController/create">
      <input type="hidden" value="${activity.id}" name="id" />
      <table class="table table-form" style="width:100%">
      
      <%-- 
        <th class="tab_name">促销名称:</th> 
        <td><label> <input class="easyui-validatebox">
              data-options="required:true" type="text" name="name" >
            value="${activity.name}" /> 
      </label></td> 
      --%>
       
        <tr>
          <td><span class="tab_name"><b>${internationalConfig.价格标题}：</b></span>
          <input class="easyui-validatebox"
              type="text" name="title" data-options="required:true"
              value="${activity.title}" title="${internationalConfig.最多5个汉字}">
          
          </td>
          <td><span class="tab_name"><b>${internationalConfig.促销签文字}：</b></span>
          <input class="easyui-validatebox"
              name="label" type="text" data-options="required:true"
              value="${activity.label}">
          </td>
        </tr>
        <tr>
          <td><span class="tab_name"><b>${internationalConfig.营销文字}：</b></span>
          <textarea class="easyui-validatebox"
                name="text" data-options="required:true" title="">${activity.text}</textarea>
          </td>
          <td class="join_times">
          <span class="tab_name"><b>${internationalConfig.用户参加次数}：</b></span>
          <select name="userQuota" class="easyui-validatebox">
                <option value="-1" <c:if test="${activity.userQuota==-1}">selected = "selected"</c:if>>${internationalConfig.无限次}</option>
                <option value="1" <c:if test="${activity.userQuota==1}">selected = "selected"</c:if>>1${internationalConfig.次}</option>
                <option value="2" <c:if test="${activity.userQuota==2}">selected = "selected"</c:if>>2${internationalConfig.次}</option>
                <option value="3" <c:if test="${activity.userQuota==3}">selected = "selected"</c:if>>3${internationalConfig.次}</option>
                <option value="4" <c:if test="${activity.userQuota==4}">selected = "selected"</c:if>>4${internationalConfig.次}</option>
                <option value="5" <c:if test="${activity.userQuota==5}">selected = "selected"</c:if>>5${internationalConfig.次}</option>
                <option value="6" <c:if test="${activity.userQuota==6}">selected = "selected"</c:if>>6${internationalConfig.次}</option>
                <option value="7" <c:if test="${activity.userQuota==7}">selected = "selected"</c:if>>7${internationalConfig.次}</option>
                <option value="8" <c:if test="${activity.userQuota==8}">selected = "selected"</c:if>>8${internationalConfig.次}</option>
                <option value="9" <c:if test="${activity.userQuota==9}">selected = "selected"</c:if>>9${internationalConfig.次}</option>
                <option value="10" <c:if test="${activity.userQuota==10}">selected = "selected"</c:if>>10${internationalConfig.次}</option>
                <option value="11" <c:if test="${activity.userQuota==11}">selected = "selected"</c:if>>11${internationalConfig.次}</option>
                <option value="12" <c:if test="${activity.userQuota==12}">selected = "selected"</c:if>>12${internationalConfig.次}</option>
            </select>
          </td>
        </tr>
        <tr>
          
          <td colspan="2">
          <span class="tab_name"><b>${internationalConfig.定向活动类型}：</b></span>
          
          <ul class="member_model">
            <li>
            <span class="no_top_border">${internationalConfig.会员类型}</span>
            <span class="no_top_border"> <input type="radio" value="0" name="vip"   ${orienteering.vip==0 ? "checked": "" } >${internationalConfig.全部} </span>
            <span class="no_top_border"><input type="radio" value="1" name="vip" ${orienteering.vip==1 ? "checked": "" }>${internationalConfig.移动影视会员} </span> 
            <span class="no_top_border"><input type="radio" value="9" name="vip"  ${orienteering.vip==9 ? "checked": "" } >${internationalConfig.全屏影视会员}</span></li> 
            <li><input type="radio" value="1" name="userType"  ${orienteering.userType==1 ? "checked": "" }>${internationalConfig.全部用户}</li> 
            <li><input type="radio" value="2" name="userType"   ${orienteering.userType==2 ? "checked": "" }>${internationalConfig.过期用户}</li>
            <li><input type="radio" value="3" name="userType"   ${orienteering.userType==3 ? "checked": "" }>${internationalConfig.一直非会员用户}</li>
            <li>
              <input class="select_radio" type="radio" value="4" name="userType"  ${orienteering.userType==4 ? "checked": "" }>
              <div class="member_vip_time">
              <p>${internationalConfig.会员有效期剩余} <input type="text" value="${orienteering.begin1 }" name="begin1"> 一  <input type="text" value="${orienteering.end1 }" name="end1"> ${internationalConfig.天的用户} </p>
              <p>${internationalConfig.会员有效期过期} <input type="text" value="${orienteering.begin2 }" name="begin2"> 一 <input type="text" value="${orienteering.end2 }" name="end2"> ${internationalConfig.天的用户}</p>
              </div>
            </li>
          </ul>
        </td>
        </tr>
        <tr>
          <td colspan="2">
            <span class="tab_name"><b>${internationalConfig.活动方式}</b></span>
            <span class="no_top_border"><input type="radio"
                        name="type" value="1" checked="checked"
                        id="tradeType0" onchange="activityTypeChange()" />&nbsp;${internationalConfig.套餐优惠}
            </span>
            <span class="no_top_border"><input type="radio"
                        name="type" value="2" id="tradeType1"
                        onchange="activityTypeChange()" />&nbsp;${internationalConfig.支付方式优惠}
            </span>
          </td>
        </tr>
        <tr style="display: none;" id="paytypeid">
          <td colspan="2">
          <span class="tab_name"><b>${internationalConfig.支付方式}：</b></span>
            <table>
              <tr>
                <td class="no_top_border"><c:forEach
                    items="${paytypes}" var="paytype">
                    <input id="paytype${paytype.typeid}" type="checkbox"
                      name="paytypes" value="${paytype.typeid}" />${paytype.name}&nbsp;&nbsp;&nbsp;&nbsp;
                                    </c:forEach></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td colspan="2">
          <span class="tab_name"><b>${internationalConfig.终端}：</b></span>
            <table>
              <tr>
                <c:forEach items="${terminals}" var="terminal">
                  <td class="no_top_border"><input
                    id="terminal${terminal.terminalId}" type="checkbox" name="terminals"
                    value="${terminal.terminalId}" />${terminal.terminalName}</td>
                </c:forEach>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>
          <span class="tab_name"><b>${internationalConfig.促销对象}：</b></span>
          <!--<c:forEach items="${target}"
              var="var">
              <input name="activityTarget" type="checkbox"
                <c:if test="${fn:contains(targetList, var.value)}"> checked="checked"</c:if>
                value="${var.value}">
                    ${var.description}
        </c:forEach>-->
        <span class="no_top_border"><input name="activityTarget" type="checkbox"  <c:if test="${fn:contains(targetList, 22)}"> checked="checked"</c:if> value="22">${internationalConfig.支持乐点支付}</span>
         <span class="no_top_border"><input name="activityTarget" type="checkbox" <c:if test="${fn:contains(targetList, 21)}"> checked="checked"</c:if> value="21">${internationalConfig.登录用户}</span>
        </td>
          <td>
            <span class="tab_name fenzu_span kinds_wrap"><b>${internationalConfig.所属分组}：</b></span>
            <div class="kinds_wrap">
                <c:forEach items="${activityGroups}" var="pg"
                  varStatus="varStatus">
                  <c:if test="${pg == '1'}">
                    <label class="no_top_border"><input type="radio"
                      name="groupId" value="${pg}" onclick="showCont()" />&nbsp;${internationalConfig.默认}
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
            <span class="tab_name" ><b>${internationalConfig.可否使用代金券}：</b></span>
            <select name="coupon" style="width:150px;">
                <!--<c:forEach items="${coupon}" var="var">
                  <option value="${var.value}"
                    <c:if test="${var.value == activity.coupon}"> selected="selected" </c:if>>${var.description}</option>
                </c:forEach>-->
                <option value="11" ${activity.coupon==11 ? "selected":"" }>${internationalConfig.不支持}</option>
                  <option value="12" ${activity.coupon==12 ? "selected":"" }>${internationalConfig.与活动互斥使用}</option>
                  <option value="13" ${activity.coupon==13 ? "selected":"" }>${internationalConfig.支持}</option>
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
          <td colspan="2"><b>${internationalConfig.TV定向活动图片}：</b><input type="text" id="tvOrientImg" value="${activity.tvOrientImg}" name="tvOrientImg" class="easyui-validatebox" />&nbsp;&nbsp;<input class="buttoncenter" type="button" value="上传文件" id="mobile_upload_btn" /> <span id="imgUrl-mobile" name="imgUrl-mobile" ><c:if test="${not empty activity.tvOrientImg}"><a href="${activity.tvOrientImg}" target="_blank">${internationalConfig.查看图片}</a></c:if></span></td>
        </tr>
        <tr>
          <td colspan="2"><b>${internationalConfig.TV定向活动描述url}：</b><input type="text" id="tvOrientUrl" value="${activity.tvOrientUrl}" name="tvOrientUrl" class="easyui-validatebox" /></td>
          
        </tr>
        <tr>
          
          <td>
          <span class="tab_name"><b>${internationalConfig.开始日期}：</b></span>
          <input class="easyui-datebox" name="beginDate"
            data-options="required:true"
            value='<fmt:formatDate value="${activity.beginDate}" pattern="yyyy-MM-dd"/>' />
          </td>
          
          <td>
          <span class="tab_name"><b>${internationalConfig.结束日期}：</b></span>
          <input class="easyui-datebox" name="endDate"
            data-options="required:true"
            value='<fmt:formatDate value="${activity.endDate}" pattern="yyyy-MM-dd"/>' />
          </td>
        </tr>
        <tr>
          
          <td>
          <span class="tab_name"><b>${internationalConfig.每日开始时段}：</b></span>
          <span class="no_top_border"><input name="beginTime" value="${activity.beginTime}"
            class="easyui-validatebox" data-options="required:true" /></span></td>
          
          <td>
          <span class="tab_name"><b>${internationalConfig.每日结束时段}：</b></span>
          <span class="no_top_border"><input name="endTime" value="${activity.endTime}"
            class="easyui-validatebox" data-options="required:true" /></span></td>
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
              <c:catch>
              <c:if test="${var.price>0.00 }">
                <tr>
                  <td id="package_${var.packageId}">${durationMap[var.duration]}</td>
                  <td class="original">${var.originPrice}</td>
                  <td class="price">${var.price}</td>
                  <td class="promotion">
                    <fmt:formatNumber pattern="0.00"
                      value="${(var.price - activityMealByMealId[var.packageId].deduction)}" />
                    </td>
                  <td class="discount">
                    <c:choose>
                      <c:when test="${var.price == 0.00}">
                        0.00
                      </c:when>
                      <c:otherwise>
                        <fmt:formatNumber pattern="0.00"
                      value="${(var.price - activityMealByMealId[var.packageId].deduction)/var.price * 10}" />
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td class="deduction"><c:choose>
                      <c:when test="${activityMealByMealId[var.packageId] != null}">
                        <input type="text"
                          value="${activityMealByMealId[var.packageId].deduction}"
                          style="width: 30px" name="deduction_${var.packageId}"
                           class="easyui-numberbox"
                          data-options="precision:2,required:true,onChange:function() {
                      computeByDeduction(this);
                    }" />
                      </c:when>
                      <c:otherwise>
                        <input type="text" value="0" style="width: 30px"
                          name="deduction_${var.packageId}"
                          class="easyui-numberbox"
                          data-options="precision:2,required:true,onChange:function() {
                      computeByDeduction(this);
                    }" />
                      </c:otherwise>
                    </c:choose></td>
                  <td class="extension"><c:choose>
                      <c:when test="${activityMealByMealId[var.packageId] != null}">
                        <input type="text"
                          value="${activityMealByMealId[var.packageId].extension}"
                          style="width: 30px" name="extension_${var.packageId}"
                          class="easyui-numberbox" data-options="required:true" />
                      </c:when>
                      <c:otherwise>
                        <input type="text" value="0" style="width: 30px"
                          name="extension_${var.packageId}" class="easyui-numberbox"
                          data-options="required:true" />
                      </c:otherwise>
                    </c:choose></td>
                  <td class="quota">
                        <c:choose>
                          <c:when
                            test="${activityMealByMealId[var.packageId].quota >= 0}">
                            <input type="text"
                              value="${activityMealByMealId[var.packageId].quota}"
                              style="width: 30px" name="quota_${var.packageId}"
                              class="easyui-validatebox" data-options="required:true" />
                          </c:when>
                          <c:otherwise>
                            <input type="text" value="不限" style="width: 30px"
                              name="quota_${var.packageId}" class="easyui-validatebox"
                              data-options="required:true" />
                          </c:otherwise>
                        </c:choose>
                    </td>
                  <td class="packageText"><input type="text"
                    value="${activityMealByMealId[var.packageId].packageText}"
                    style="width: 100px" name="packagetext_${var.packageId}"
                    class="easyui-validatebox" title="${internationalConfig.最多14个汉字}" /></td>
                  <td class="packageStatus"><select
                    name="packagestatus_${var.packageId}" style="width: 80px">
                      <c:forEach items="${packagestatus}" var="item">
                        <option
                          <c:if test="${ (empty activityMealByMealId[var.packageId] && item.value=='42' ) ||  item.value == activityMealByMealId[var.packageId].packageStatus}"> selected="selected" </c:if>
                          value="${item.value}">${item.description}</option>
                      </c:forEach>
                  </select></td>
                </tr>
                </c:if>
                </c:catch>
              </c:forEach>
            </table>
          </td>
        </tr>
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
              <c:forEach items="${seniorPackageList}" var="var"   >
              <c:if test="${var.price>0.00}">
                <tr>
                  <td id="package_${var.packageId}">${durationMap[var.duration]}</td>
                  <td class="original">${var.originPrice}</td>
                  <td class="price">${var.price}</td>
                  <td class="promotion">
                    <fmt:formatNumber pattern="0.00"
                      value="${(var.price - activityMealByMealId[var.packageId].deduction)}" />
                    </td>
                  <td class="discount">
                    <c:choose>
                      <c:when test="${var.price == 0.00}">
                        0.00
                      </c:when>
                      <c:otherwise>
                        <fmt:formatNumber pattern="0.00"
                      value="${(var.price - activityMealByMealId[var.packageId].deduction)/var.price * 10}" />
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td class="deduction"><c:choose>
                      <c:when test="${activityMealByMealId[var.packageId] != null}">
                        <input type="text"
                          value="${activityMealByMealId[var.packageId].deduction}"
                          style="width: 30px" name="deduction_${var.packageId}"
                          class="easyui-numberbox"
                          data-options="precision:2,required:true,onChange:function() {
                      computeByDeduction(this);
                    }"/>
                      </c:when>
                      <c:otherwise>
                        <input type="text" value="0" style="width: 30px"
                          name="deduction_${var.packageId}"
                         class="easyui-numberbox"
                          data-options="precision:2,required:true,onChange:function() {
                      computeByDeduction(this);
                    }" />
                      </c:otherwise>
                    </c:choose></td>
                  <td class="extension"><c:choose>
                      <c:when test="${activityMealByMealId[var.packageId] != null}">
                        <input type="text"
                          value="${activityMealByMealId[var.packageId].extension}"
                          style="width: 30px" name="extension_${var.packageId}"
                          class="easyui-numberbox" data-options="required:true" />
                      </c:when>
                      <c:otherwise>
                        <input type="text" value="0" style="width: 30px"
                          name="extension_${var.packageId}" class="easyui-numberbox"
                          data-options="required:true" />
                      </c:otherwise>
                    </c:choose></td>
                  <td class="quota">
                        <c:choose>
                          <c:when
                            test="${activityMealByMealId[var.packageId].quota >= 0}">
                            <input type="text"
                              value="${activityMealByMealId[var.packageId].quota}"
                              style="width: 30px" name="quota_${var.packageId}"
                              class="easyui-validatebox" data-options="required:true" />
                          </c:when>
                          <c:otherwise>
                            <input type="text" value="${internationalConfig.不限}" style="width: 30px"
                              name="quota_${var.packageId}" class="easyui-validatebox"
                              data-options="required:true" />
                          </c:otherwise>
                        </c:choose>
                      </td>
                  <td class="packageText"><input type="text"
                    value="${activityMealByMealId[var.packageId].packageText}"
                    style="width: 100px" name="packagetext_${var.packageId}"
                    class="easyui-validatebox" /></td>
                  <td class="packageStatus"><select
                    name="packagestatus_${var.packageId}" style="width: 80px">
                      <c:forEach items="${packagestatus}" var="item">
                        <option
                          <c:if test="${(empty activityMealByMealId[var.packageId] && item.value=='42' )|| item.value == activityMealByMealId[var.packageId].packageStatus}"> selected="selected" </c:if>
                          value="${item.value}">${item.description}</option>
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
          <span class="tab_name" style="width:20%;"><b>${internationalConfig.促销优先级}：</b></span>
          <input name="priority" type="text"
            value="${activity.priority}" class="easyui-numberbox"
            data-options="required:true"></td>
        </tr>
        <tr>
          <td colspan="2">
          <span class="tab_name" style="width:20%;"><b>${internationalConfig.促销状态}：</b></span>
          <select name="status">
              <!--<c:forEach items="${status}" var="var">
                <option
                  <c:if test="${var.value == activity.status}"> selected="selected" </c:if>
                  value="${var.value}">${var.description}</option>
              </c:forEach>-->
              <option value="31"   ${activity.status==31 ? "selected":"" } >${internationalConfig.上线}</option>
              <option  value="32"   ${activity.status==32 ? "selected":"" }>${internationalConfig.下线}</option>
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
  button_image_url: $.cookie('boss_lang') == 'zh'?'/static/lib/swfupload/upload_zh.png':'/static/lib/swfupload/upload_en.png',
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
    var HTML_VIEWS = '<a href='+response+' target="_blank">${internationalConfig.查看图片}</a>&nbsp;&nbsp;&nbsp;&nbsp;';
    $("#imgUrl-mobile").html(HTML_VIEWS);
    $("#tvOrientImg").val(response);
  },
  file_queued_handler: function() {
    this.startUpload();
  },
  upload_error_handler: function(file, code, msg) {
    var message = '${internationalConfig.上传失败}' + code + ': ' + msg + ', ' + file.name;
    alert(message);
  }
});
function checkActivityGroup() {
  var groupId = ${activity.groupId};
  
  $("input[name=groupId]").each(function() {
    if((groupId & $(this).val()) == $(this).val()) {
      $(this).attr("checked", true);
    }
  });
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
  
checkActivityGroup();
showCont();
tvOrientChange();
</script>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="/WEB-INF/views/inc/jstl.inc" %><script type="text/javascript" src="/js/kv/operator.js"></script>
  <style>
    	.dzd_list_table .dzd_mx_li_tw{
    	line-height:30px;
    	border-bottom:1px solid #ccc;
    	padding-left:10px;
    	}
    	.dzd_list_table .dzd_mx_li_tw_last{
    	border:none;
    	}
    	.dzd_list_table .dzd_mx_li_tw span{
    	display:inline-block;
    	padding-right:20px;
    	}
    	.dzd_list_table .dzd_mx_li_tw span .bz_text{
    	min-height:50px;
    	overflow-y:scroll;
    	}
    	.dzd_list_table .dzd_mx_li_tw span .yys_name01{
    	width:100px;
    	}
 </style>
 <form method="post"   id="form"  action="/operator/edit_detail">
 <input type="hidden"  name="id" value="${id }"/>
 <input type="hidden"  name="oaid"  value="${account.id }"/>
<div class="dzd_closing_rule">
    <div class="yys_closing_one">
        <ul class="yys_closing_list">
            <li>
                <span class="jsgz_left_span">
                    <b>运营商：</b>
                  <span  id="operator_id"></span>
                </span>
                <span class="jsgz_left_span">
                    <b>合同日期：</b>
                    <fmt:formatDate value="${account.startDate}" type="date"/>
                   至 <fmt:formatDate value="${account.endDate }" type="date"/>
                </span>
            </li>
            <li>
                <span class="jsgz_left_span">
                <b>对账周期：</b>
               <c:choose>
               <c:when test="${empty detail }">
                 <m:date name="year"  before="10"  after="10" type="year"  attr="class=yys_dz_select"></m:date>年
               <m:date name="month"  type="month"  attr="class=yys_dz_select"></m:date>月
                  
               </c:when>
               <c:otherwise>
               <input  name="year"  value="${detail.year }"  readonly="readonly">年<input  name="month"  value="${detail.month }"  readonly="readonly">月
               </c:otherwise>
               </c:choose>
           
                </span>
                <span class="jsgz_left_span"><b>结算总金额：</b><input class="yys_name easyui-numberbox"   data-options="min:0,precision:2,required:true" name="amount"  value="${detail.amount }">元</span>
            </li>
        </ul>
    </div>
    <div class="yys_closing_two">
        <div class="dzd_closing_dl">
            <h4 class="closing_title">结算明细</h4>
                <ul class="dzd_list_table">
                    <li class="li_title">
                        <span class="dzb_fbt">${account.stype ==1 ? "集采" :"代销" }</span>
                    </li>
                    <li class="dzd_mx_li">
                        <span class="dzb_zdxh">终端型号</span>
                        <span class="dzb_zddj">终端单价（元/台）</span>
                        <span class="dzb_zddj">销量（台）</span>
                        <span class="dzb_xse">销售额（元）</span>
                    </li>
                       <li class="dzd_mx_li">
                        <span class="dzb_zdxh"><input class="easyui-validatebox yys_name01"   name="model"  value="${terminal[0].model }"> </span>
                        <span class="dzb_zddj"><input disabled="disabled" class="easyui-validatebox yys_name02"  value="${account.hardware}"></span>
                        <span class="dzb_zddj"><input class="easyui-validatebox yys_name02"  name="count" value="${terminal[0].count }"></span>
                        <span class="dzb_xse"><input class="easyui-validatebox yys_name03"   name="amountSum"  value="${terminal[0].amountSum }"></span>
                    </li>
                    <li class="dzd_mx_li">
                        <span class="dzb_zdxh"><input class="easyui-validatebox yys_name01"  name="model"  value="${terminal[1].model }"></span>
                        <span class="dzb_zddj"><input disabled="disabled" class="easyui-validatebox yys_name02"  value="${account.hardware}"></span>
                        <span class="dzb_zddj"><input class="easyui-validatebox yys_name02"  name="count"  value="${terminal[1].count }"></span>
                        <span class="dzb_xse"><input class="easyui-validatebox yys_name03"  name="amountSum"  value="${terminal[1].amountSum }"></span>
                    </li>
                    <li class="dzd_mx_li">
                        <span class="dzb_zdxh"><input class="easyui-validatebox yys_name01"   name="model"  value="${terminal[2].model }"></span>
                        <span class="dzb_zddj"><input disabled="disabled" class="easyui-validatebox yys_name02"  value="${account.hardware}"></span>
                        <span class="dzb_zddj"><input class="easyui-validatebox yys_name02" name="count"  value="${terminal[2].count }"></span>
                        <span class="dzb_xse"><input class="easyui-validatebox yys_name03"  name="amountSum"  value="${terminal[2].amountSum }"></span>
                    </li>
             </ul> 
             <c:if test="${ ! empty account.renewal }">
               <br>
                <ul class="dzd_list_table">
               <li class="dzd_mx_li">
                        <span class="dzb_zdxh">在网时长</span>
                        <span class="dzb_zddj">结算规则</span>
                        <span class="dzb_zddj">在网用户数</span>
                        <span class="dzb_xse">服务费</span>
                    </li>
                    
                    <c:forEach var="item" items="${account.renewal }"  varStatus="status" >
                        <li class="dzd_mx_li">
                        <span class="dzb_zdxh">
                        <c:choose>
                        <c:when test="${item.year ==0}">当月</c:when>
                         <c:when test="${item.year ==1}">2-12</c:when>
                         <c:otherwise>${item.year} 年内</c:otherwise>
                        </c:choose>                     
                        </span>
                        <span class="dzb_zddj"><input disabled="disabled" class="easyui-validatebox yys_name02"  value="${item.servicePrice }">${item.serviceType==1 ? "元/月":"元/年" }</span>
                        <span class="dzb_zddj"><input class="easyui-validatebox yys_name02"   name="user" value="${item.user }"></span>
                        <span class="dzb_xse"><input class="easyui-validatebox yys_name03"  name="money" value="${item.money }"></span>
                    </li>
                    </c:forEach>
                </ul>
             </c:if>
           
          
                <br>
                <ul class="dzd_list_table">
              		<li class="dzd_mx_li_tw">
                        
                        <span>退网人数：<input class="easyui-validatebox yys_name01"  name="offline"  value="${detail.offline }" /></span>
                        <span>退网备注：<textarea class="bz_text"  name="offlineDesc" >${detail.offlineDesc }</textarea></span>
                    </li>
                    <li class="dzd_mx_li_tw">
                        <span >服务年限：<input disabled="disabled"  class="easyui-validatebox yys_name01"  value="${account.serviceLife }"/></span>
                    </li>
                    <li class="dzd_mx_li_tw">
                        <span >续费人数：<input class="easyui-validatebox yys_name01"  name="online"  value="${detail.online }"/></span>
                        <span>续费价格：<input class="easyui-validatebox yys_name01" disabled="disabled"  value="${account.servicePrice }" />${account.serviceType==1 ? "元/月":"元/年" }</span>
                        <span>结算净额：<input class="easyui-validatebox yys_name03  easyui-numberbox"   data-options="min:0,precision:2,required:true" name="profit"  value="${detail.profit }"/></span>
                    </li>
                    <li class="dzd_mx_li_tw">
                        <span >本次抵扣：<input class="easyui-validatebox yys_name01"    name="deduction"  value="${detail.deduction }"/></span>
                        <span>抵扣周期：<input type="text" name="deductionStart"  style="width: 165px" value="${detail.deductionStart}"
                                   class="easyui-datebox"  /> - <input type="text" name="deductionEnd"  style="width: 165px" value="${detail.deductionEnd}"
                                   class="easyui-datebox" /></span>
                    </li>
                    <li class="dzd_mx_li_tw dzd_mx_li_tw_last">
                        <span >未抵扣：<input class="easyui-validatebox yys_name "   name="noDeduction"  value="${detail.noDeduction }">元</span>
                        <span>误差：<input class="yys_name "    name="deviation"  value="${detail.deviation }">元</span>
                    </li>
                                 
                </ul>
        </div>
    </div>


    <dl class="yys_rule_detail">
        <dt>*说明</dt>
        <dd>1.该页面目的为设定每个运营商与乐视具体的结算规则，起到内部能及时透明对账的作用。</dd>
        <dd>2.鉴于每个运营商不同合作模式，设定不同结算类型和规则。</dd>
        <dd>3.结算类型包含"集采"或"代销“结算。按照不同类型在各自区域填写具体计费规则。</dd>
        <dd>4.代销结算若回款周期出现半年期，如2.5年，按月计费，仍在下方第3年填写”X元/月“的标准即可</dd>
    </dl>
</div>
</form>
<script type="text/javascript">
$(function () {
    parent.$.messager.progress('close');
    $('#form').form({
        url: '/operator/edit_detail',
        onSubmit: function () {
            parent.$.messager.progress({
                title: '提示',
                text: '数据处理中，请稍后....'
            });

            var isValid = $(this).form('validate');
            if (!isValid) {
                parent.$.messager.progress('close');
            }
            
            if($("input[name=deviation]").val()==''){
            	$("input[name=deviation]").val('0');
            }
            
            if($("input[name=noDeduction]").val()==''){
            	$("input[name=noDeduction]").val('0');
            }
            
            if($("input[name=deduction]").val()==''){
            	$("input[name=deduction]").val('0');
            }
            if($("input[name=online]").val()==''){
            	$("input[name=online]").val('0');
            }
            if($("input[name=offline]").val()==''){
            	$("input[name=offline]").val('0');
            }
    
            return isValid;
        },
        success: function (obj) {
            parent.$.messager.progress('close');
            var result = $.parseJSON(obj);
            if (result.code==0) {
               parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                parent.$.modalDialog.handler.dialog('close');
            } else {
                parent.$.messager.alert('页面错误', result.msg, 'error');
            }
        }
    });
    
    
    $("#operator_id").html(Dict.operator["${account.oid }"]);
    
}); 
    

</script>

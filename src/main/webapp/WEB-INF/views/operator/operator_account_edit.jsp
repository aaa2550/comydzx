<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script type="text/javascript" src="/js/kv/operator.js"></script>
 <form method="post"   id="form"  action="/operator/edit">
 <input type="hidden"  name="id"  value="0"  />
<div class="yys_closing_rule">
    <div class="yys_closing_one">
        <ul class="yys_closing_list">
         
            <li>
                <b>运营商：</b>
                    <input id="inputSearch2" class="span2 input-box" autocomplete="off"  >
                     <input   id="oid2"  class="span2" type="hidden" name="oid"  value="${operatorAccount.oid}">
            </li>
            <li>
                <b>合同起止时间：</b>
             <input type="text" name="startDate" id="startDate" style="width: 165px" value="${operatorAccount.startDate}"
                                   class="easyui-datebox" data-options="required:true"/>
                 - 
              <input type="text" name="endDate" id="endDate" style="width: 165px" value="${operatorAccount.endDate}"
                                   class="easyui-datebox " data-options="required:true"/>
            </li>
        </ul>
    </div>
 
    <div class="yys_closing_three">
    <div class="yys_closing_dl">
            <ul class="yys_list_table">
                <li>
                    <span class="yys_title_span"><input  id="stype1"  type="radio" name="stype"  value="1"  checked="checked">集采      <input type="radio"  id="stype2" name="stype" value="2">代销</span>
                    <span class="red_text_tips">*选择集采，无需填写服务费价格栏信息</span>
                </li>
                <li>
                        <b class="yj_price">硬件价格</b>
                        <span class="yj_monney"><input type="text"  name="hardware" class="easyui-numberbox"  value="${operatorAccount.hardware}" data-options="min:0,precision:2,width:100,height:25,required:true">元/台</span>
                        <span class="yj_fuwf">服务年限  <input  name="serviceLife" type="text" class="easyui-numberbox" value="${operatorAccount.serviceLife}"data-options="min:0,precision:1,width:100,height:25,required:true"> 年</span>
                </li>
                <li> 
                        <b class="yj_price">服务费价格</b>
                        <select class="yys_jf_select"  name="serviceType2">                    
                            <option value="1">按月计费</option>
                            <option value="2">按年计费</option>
                        </select>
                </li>
                <li>
                    <span class="yys_js_nf yys_js_color">年份</span>
                    <span class="yys_js_gz yys_js_color">结算规则</span>
                    <span class="yys_bg_bz yys_js_color">变更备注</span>
                </li>
                <li>
                    <span class="yys_js_nf">第一年</span>
                    <span class="yys_js_gz"><input type="text"   name="renewals" class="easyui-numberbox"  value="${operatorAccount.renewal[0]['servicePrice'] }" data-options="min:0,precision:2,width:60,height:25"><span class="pp_price">元/月</span></span>
                    <span class="yys_bg_bz"><input class="easyui-validatebox  yys_beizhu"   name="remarks"  data-options="width:340,height:25"   value="${operatorAccount.renewal[0]['remark'] }" ></span>
                </li>
                <li>
                    <span class="yys_js_nf">第二年</span>
                    <span class="yys_js_gz"><input type="text"   name="renewals"  class="easyui-numberbox" value="${operatorAccount.renewal[1]['servicePrice'] }" data-options="min:0,precision:2,width:60,height:25"><span class="pp_price">元/月</span></span>
                    <span class="yys_bg_bz"><input class="easyui-validatebox  yys_beizhu" name="remarks"  data-options="width:340,height:25"   value="${operatorAccount.renewal[1]['remark'] }" ></span>
                </li>
                <li>
                    <span class="yys_js_nf">第三年</span>
                    <span class="yys_js_gz"><input type="text"  name="renewals"  class="easyui-numberbox" value="${operatorAccount.renewal[2]['servicePrice'] }" data-options="min:0,precision:2,width:60,height:25"><span class="pp_price">元/月</span></span>
                    <span class="yys_bg_bz"><input class="easyui-validatebox  yys_beizhu" name="remarks"  data-options="width:340,height:25"   value="${operatorAccount.renewal[2]['remark'] }" ></span>
                </li>
                 <li>
                    <span class="yys_js_nf">第四年</span>
                    <span class="yys_js_gz"><input type="text"   name="renewals"  class="easyui-numberbox" value="${operatorAccount.renewal[3]['servicePrice'] }" data-options="min:0,precision:2,width:60,height:25"><span class="pp_price">元/月</span></span>
                    <span class="yys_bg_bz"><input class="easyui-validatebox  yys_beizhu"  name="remarks"  data-options="width:340,height:25"  value="${operatorAccount.renewal[3]['remark'] }" ></span>
                </li>
                 <li>
                    <span class="yys_js_nf">第五年</span>
                    <span class="yys_js_gz"><input type="text"  name="renewals"  class="easyui-numberbox" value="${operatorAccount.renewal[4]['servicePrice'] }" data-options="min:0,precision:2,width:60,height:25"><span class="pp_price">元/月</span></span>
                    <span class="yys_bg_bz"><input class="easyui-validatebox  yys_beizhu"  name="remarks"  data-options="width:340,height:25"   value="${operatorAccount.renewal[4]['remark'] }" ></span>
                </li>
                <li class="yys_last_li">
                        <b class="yj_price">续费规则</b>
                        <span class="yj_monney"><input type="text"  name="servicePrice" class="easyui-numberbox" value="${operatorAccount.servicePrice }" data-options="min:0,precision:2,width:100,height:25"></span>
                           
                        <span class="yj_monney">
                        <select class="yys_jf_select"  name="serviceType">
                            <option value="1">元/月</option>
                            <option value="2">元/年</option>
                        </select>
                        </span>
                        
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
        url: '/operator/edit',
        onSubmit: function () {
            parent.$.messager.progress({
                title: '提示',
                text: '数据处理中，请稍后....'
            });

            var isValid = $(this).form('validate');
            if (!isValid) {
                parent.$.messager.progress('close');
            }
            var stype=$("input[name=stype]:checked").val();
            var serviceLife=Math.ceil($("input[name=serviceLife]").val());
            if(stype==2) {
            	$("input[name=renewals]").each(function(index){
            		if(index<serviceLife){
            			if($(this).val()==""){
            				parent.$.messager.alert('错误', '服务年限不匹配', 'error');
            				parent.$.messager.progress('close');
                        	return false;
            			}
            		}
            	});
            	
            }
            
            var servicePrice=$("input[name=servicePrice]").val();
            if(servicePrice==''){
            	$("input[name=servicePrice]").val("0");
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
    
    
    
 $("select[name=serviceType2]").change(function(){
	 var a=$(this).val();
	 var h="元/月" ;
	 if(a==2){
		 h="元/年"
	 }
	 $(".pp_price").text(h);
 }); 
 
 
 
 var co = new Boss.util.combo({
	  url:"/search_name?type=operatorName",
	 inputSelector:'#inputSearch2' 
	 });
	
	$(co).bind('select',function(eventName,el){
		$('#oid2').val(el.data("id"));
	});
    
});



</script>


<c:if test="${! empty operatorAccount }"> 
<script type="text/javascript">
$("input[name=id]").val("${operatorAccount.id}");
$("select[name=serviceType]").val("${operatorAccount.serviceType}");
 $("#stype${operatorAccount.stype}").attr("checked",true);
$("select[name=serviceType2]").val("${operatorAccount.renewal[0]['serviceType']}");
$("#inputSearch2").val(Dict.operator["${operatorAccount.oid}"]);
</script>
</c:if>

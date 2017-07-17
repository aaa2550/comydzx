<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<style type="text/css">
.set_wrap,.tanc_kinds_wrap{
padding:20px;
overflow:hidden;
width:700px;
}
.tanc_kinds_wrap{
padding-top: 0;
}
.set_wrap{
width:700px;
}
.set_wrap h4{
font-size: 16px;
line-height: 26px;
}
.set_div{
line-height: 30px;
font-size: 14px;
overflow: hidden;
width:300px;
margin-bottom: 10px;
}
.set_div .set_span{
float: left;padding-right: 10px;display: inline-block;margin:0;
}
.set_div .selec_p{
float:left;
width:160px;
display: inline-block;
} 
.set_div .status{
float:left;
vertical-align:middle;
display: block;
margin-left: 10px;
margin-top: 6px;
}
.jianmian_price{
line-height: 30px;
width: 300px;
}
.jianmian_price input{
width:100px;
}
.tanc_kinds_wrap h3{
	font-size: 14px;
	font-weight: bold;
	line-height: 28px;
}
.tanc_kinds_wrap ul li{
line-height: 30px;
overflow: hidden;
}
.tanc_kinds_wrap ul li p{
padding-bottom: 10px;
}
.tanc_kinds_wrap ul li input[type="radio"]{
margin-right: 10px;
}
.tanchuang_con td{
text-align:center;
height: 30px;
}
.tanchuang_con td span{
text-align: right;
display: inline-block;
width:60px;
}
.tanchuang_con td input{
width:180px;
}
.tanchuang_con th{
text-align: center;
}
.tc_number{
line-height: 30px;
padding-top: 10px;
}
.tc_number input[type="text"]{
width:100px;margin:0 10px;
}
.table{ color:#333; font-size:12px; width:97%;border:1px #999 solid;overflow: hidden;margin:0 20px;}
 .table .th01{
width:150px;
}
/*.table .th02{
width:170px;
} */
.tab_title{ text-align:left; font-size:14px; font-weight:bold; margin:20px 0 10px;}
</style>
<form id="form"  method="post"    enctype="multipart/form-data"    accept-charset="utf-8" >
<input type="hidden"   name="id"  value="${pop.id }">
<div class="set_wrap">	
	<div class="set_div">
		<span class="set_span">终端</span>
	    <select class="s_terminal" name="terminal" >
	      <c:forEach items="${terminal }"  var="item">
	      <option value="${item.key }" >${item.value }</option>
	      </c:forEach>
	    </select>
	
	</div> 
	<p class="jianmian_price"><span>设置减免价格：</span><input id="price" name="price"  type=text  value="${pop.price }"></p>
</div>
<div class="tanc_kinds_wrap">
	<h3>定向弹窗用户类型</h3>
	<ul>
		<li><input  type="radio"  name="userType"  value="1">全部用户</li>
		<li><input  type="radio"  name="userType"  value="2">过期用户</li>
		<li><input  type="radio"  name="userType"  value="3">一直非会员用户</li>
		<li>
			<p><input  type="radio"  name="userType"  value="4">会员有效期剩余 <input type="text" name="start1"  value="${pop.start1 }"  /> 一  <input type="text" name="end1"  value="${pop.end1 }"  /> 天的用户 </p>
			<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;会员有效期过期 <input type="text" name="start2"  value="${pop.start2 }"  /> 一 <input type="text"  name="end2"  value="${pop.end2 }"  /> 天的用户</p>
		</li>
			<li><input  type="radio"  name="userType"  value="5">导入UID  <input  type="file"    name="myfile" />( <font color=red>说明：导入文件需为txt格式，每个UID一行。)</font></li>
	</ul>
	<p class="tc_number">每日弹出次数 <input type="text"  name="dailyCount" value="${pop.dailyCount }" />次</p>
	<p class="tc_number">&nbsp;&nbsp;&nbsp;&nbsp;弹出总次数 <input  type="text" name="totalCount"   value="${pop.totalCount }"/>次</p>
	<p class="tc_number">起止时间<input name="startTime"  id="start"  value="${pop.startTime }" class="easyui-datetimebox " data-options="required:true"  >--<input name="endTime"  id="start"  value="${pop.endTime }" class="easyui-datetimebox " data-options="required:true"  ></p>
	<p class="tc_number">&nbsp;&nbsp;&nbsp;&nbsp;优先级<input  type="text" name="weight"   value="${pop.weight }"/>(说明：数字从小到大优先级由高到低)</p>
</div>


<div class="tanchuang01">
<table class="table tanchuang_con">
	<caption class="tab_title">
	        弹窗内容设置：
	    </caption>
	    <tr>
	    <td>描述</td><td> <input type="text"  name="moreDesc" value="${moreDesc}" /></td>
	    <td>更多链接 </td><td><input type="text"  name="moreLink" value="${moreLink }" /></td>
	    </tr>
 	<tr>
	 	<th class="th01">推荐位置</th>
	    <th class="th02">标题</th>
	    <th class="th02">图片</th>	
	   <th class="th02">链接</th>
    </tr>

    <c:forEach items="${contents }" var="item"  varStatus="status">
    <tr>
    <td>${status.index+1 }</td>
    <td><input type="text" name="content${status.index }.title"  value="${item.title }"></td>
    <td><input type="text" name="content${status.index }.pic"  value="${item.pic }"></td>
   <td><input type="text" name="content${status.index }.link"  value="${item.link }"></td>
    </tr>
    </c:forEach>
    </table>
    
<p>
<dl>
							<dt>说明</dt>
							<dd>1、每日弹出次数，总次数 0为不限制；</dd>
							<dd>2、用户类型，全部用户，过期用户，一直非会员用户只能同时只能存在一个</dd>
							<dd>3、会员有效期剩余,填写数字的格式为从大到小；过期，填写数字的格式为从小到大。不能填写0</dd>
							<dd>4、TV跳转地址定义1、native{id=***,monthType=***,payType=***} 2、h5{h5url=http://www.letv.com?userid=123&id=XXX,id=***,monthType=***,payType=***}</dd>
							<dd>native:代表本地打开   id：本地需要打开应用 </dd>
							<dd>monthType代表套餐类型，2:包月，3：包季，5：包年 </dd>
							<dd>payType代表支付类型， 5：支付宝，24：微信，41,42：信用卡，乐点：33 </dd>
</dl>
</p>
 <script type="text/javascript">
$(function() {
	parent.$.messager.progress('close');
	 $('#form').form({
		url : '/reminder_pop/edit', 
		onSubmit : function() {
			parent.$.messager.progress({
				title : '提示',
				text : '数据处理中，请稍后....'
			});
		
			return true;
		},
		success : function(result) {
			parent.$.messager.progress('close');
			result = $.parseJSON(result);
			if (result.code == 0) {
            	parent.$.messager.alert('成功', '编辑成功', 'success');
				parent.$.modalDialog.openner_dataGrid.datagrid('reload');
				parent.$.modalDialog.handler.dialog('close');
			} else {
				parent.$.messager.alert('错误', result.msg, 'error');
			}
		}
	}); 
	 
	 
	 if('${pop.id}'!='0'){
		 $("select[name=terminal]").val('${pop.terminal}');
		$("input[name=userType][value=${pop.userType}]").attr("checked",true); 
	 }
		
	 
   
});
</script>
</div>
</form>
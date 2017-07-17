<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form').form({
			url : '${pageContext.request.contextPath}/lebi/ristcontrol/add',
			success : function(result) {
				parent.$.messager.progress('close');
				result = $.parseJSON(result);
				if (result.code == 0) {
                	parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.添加成功}', 'success');
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
					parent.$.modalDialog.handler.dialog('close');
				} else {
					parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
				}
			}
		});
	});

	
/* 	function save() {
		
		var costlargelbjson = "costlargelb:{";
		var costlebi = $("#costlebi");
		costlargelbjson = costlargelbjson+"costlebi:"+costlebi;
		costlargelbjson=costlargelbjson+"}"
		
		var daylimitjson = "daylimit:{";
		var buysx=$("#buysx");
		var costsx=$("#costsx");
		var costtimes=$("#costtimes");
		daylimitjson = daylimitjson+"buysx:"+buysx+",";
		daylimitjson = daylimitjson+"costsx:"+costsx+",";
		daylimitjson = daylimitjson+"costtimes:"+costtimes;
		daylimitjson=daylimitjson+"}";
		
		var frequencyjson = "frequency:{"
		var minute=$("#minute").val();
		frequencyjson=frequencyjson+"minute:"+minute;
		frequencyjson=frequencyjson+"costtimes:"+minute;
	} */
	
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post" id="form1">
			<table style="width: 100%" class="table table-form" id="tb1">

				<tr>
					<td colspan="4">
						消耗大额虚拟币：超过<input type="text" name="rule[0]['largerule'].costlebi" id="costlebi" class="easyui-validatebox" data-options="required:true" style="width: 100px;"/>币标记交易
					</td>
				</tr>
				<tr>
					<td colspan="4">
						每日限制：每人购买上限<input type="text" name="rule[1]['daylimit'].buysx" id="buysx" class="easyui-validatebox" data-options="required:true" style="width: 100px;"/>
							        每人消耗上限<input type="text" name="rule[1]['daylimit'].costsx" id="costsx" class="easyui-validatebox" data-options="required:true" style="width: 100px;"/>
							        每人消耗次数<input type="text" name="rule[1]['daylimit'].costtimesperson" id="costtimes" class="easyui-validatebox" data-options="required:true" style="width: 100px;"/> 
					</td>
				</tr>	
				
				<tr>
					<td colspan="4">
						消耗频次：<input type="text" name="rule[2]['costlimit'].minute" id="minute" class="easyui-validatebox" data-options="required:true" style="width: 100px;"/>
							     分钟内限制消耗<input type="text" name="rule[2]['costlimit'].costtimesminute" id="costtimes" class="easyui-validatebox" data-options="required:true" style="width: 100px;"/>
					</td>
				</tr>
				<tr>
				<td colspan="4">	
					<button value="javascript:save()">保存</button>
				</td>
				</tr>	
			</table>
		</form>
	</div>
</div>
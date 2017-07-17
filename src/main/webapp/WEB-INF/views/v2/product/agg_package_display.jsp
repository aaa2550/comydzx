<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/inc/jstl.inc"%>
<style type="text/css">
	/*body,div,ul,li{
		padding:0;
		text-align:center;
	}*/
	body{
		font:12px "宋体";
		text-align:center;
	}
	a:link{
		color:#00F;
		text-decoration:none;
	}
	a:visited {
		color: #00F;
		text-decoration:none;
	}
	a:hover {
		color: #c00;
		text-decoration:underline;
	}
	ul{ list-style:none;}
	/*选项卡1*/
	#Tab1{
		width:460px;
		margin:0px;
		padding:0px;
		margin:0 auto;}
	/*选项卡2*/
	#Tab2{
		width:576px;
		margin:0px;
		padding:0px;
		margin:0 auto;}
	/*菜单class*/
	.Menubox {
		width:670px;
		height:28px;
		line-height:28px;
	}
	.Menubox ul{
		margin:0px;
		padding:0px;
	}
	.Menubox li{
		float:left;
		display:block;
		cursor:pointer;
		width:116px;
		max-width:116px;
		height:28px;
		line-height:28px;
		text-align:center;
		color:#949694;
		font-weight:bold;
		background:url(http://www.jb51.net/upload/small/20079299441652.gif);
	}
	.Menubox .tab_choose{
		background:#666;
	}
	.Menubox li.hover{
		padding:0px;
		background:#fff;
		width:116px;
		border-left:1px solid #A8C29F;
		border-top:1px solid #A8C29F;
		border-right:1px solid #A8C29F;
		background:url(http://www.jb51.net/upload/small/200792994426548.gif);
		color:#739242;
		font-weight:bold;
		height:27px;
		line-height:27px;
	}
	.Contentbox{
		clear:both;
		margin-top:0px;
		border:1px solid #A8C29F;
		border-top:none;
		height:181px;
		text-align:center;
		padding-top:8px;
	}
	.datagrid-btable{
		width:100%;
	}
	.datagrid-body{min-height:164px;}
</style>
<script type="text/javascript">
	var fullLiveChannelList={<c:forEach var="channel" items="${liveChannelList}">"${channel.id}":"${fn:replace(channel.description, "\"", "\\\"")}",</c:forEach>};
	var dataGrid;
	$(function() {
		parent.$.messager.progress('close');
		(function($) {
			$.fn.serializeJson = function() {
				var serializeObj = {};
				var array = this.serializeArray();
				$(array).each(function() { // 遍历数组的每个元素 {name : xx , value : xxx} 
					if (serializeObj[this.name]) { // 判断对象中是否已经存在 name，如果存在name 
						serializeObj[this.name] += "," + this.value;
					} else {
						serializeObj[this.name] = this.value; // 如果元素name不存在，添加一个属性 name:value 
					}
				});
				return serializeObj;
			}
		})(jQuery)

		var id = $("#id").val();
		/*var data = {id: id, ctype: 3};
		dataGrid = renderDataGrid('/v2/product/aggPackage/subDataGrid', data);*/

		$('#form').form(
				{
					url : '/v2/product/aggPackage/save',
					onSubmit : function() {
						parent.$.messager.progress({
							title : '${internationalConfig.提示}',
							text : '${internationalConfig.数据处理中}....'
						});

						var isValid = $(this).form('validate');
						if (!isValid) {
							parent.$.messager.progress('close');
						}
						
						return isValid;
					},
					success : function(result) {
						parent.$.messager.progress('close');
						result = $.parseJSON(result);
						if (result.code == 0) {
							parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.保存成功}', 'success');
							parent.$.modalDialog.openner_dataGrid.datagrid('reload');
							parent.$.modalDialog.handler.dialog('close');
						} else {
							parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
						}
					}
				});
		var ulWidth = $("#tab_ul").width();
		var liNum = $("#tab_ul li").length;
		if(liNum!=0){
			$("#tab_ul li").css("width",Math.floor(ulWidth/liNum) );
		}
		$("#tab_ul li").click(function(){
			$("#tab_ul li").removeClass("tab_choose");
			$(this).addClass("tab_choose");
			var ctype = $(this).attr('ctype');
			var data = {id: id, ctype: ctype};
			dataGrid = renderDataGrid('/v2/product/aggPackage/subDataGrid', data);
		});
	});

	function renderDataGrid(url, data, method) {
		return $('#subDataGrid').datagrid({
					url : url,
					fit : false,
					queryParams : data || "",
					fitColumns : true,
					border : false,
					method : method || 'post',
					pagination : true,
					idField : 'cid',
					pageSize : 5,
					showPageList:false,
					pageList : [ 5 ,10,20],
					//sortName : 'cid',
					sortOrder : 'asc',
					checkOnSelect : false,
					selectOnCheck : false,
					nowrap : false,
					striped : true,
					rownumbers : true,
					singleSelect : true,
					frozenColumns : [ [ {
						field : 'id',
						title : '${internationalConfig.编号}',
						width : 150,
						hidden : true
					} ] ],
					columns : [ [
						{
							field : 'cid',
							title : '${internationalConfig.内容ID}',
							width : 100,
							sortable : false,
							hidden : false
						},
						{
							field : 'cName',
							title : '${internationalConfig.名称}',
							width : 100,
							sortable : false,
							formatter: function(value,row,index){
								if (data.ctype==4){
									return fullLiveChannelList[row.subCtype]+" - " + value;
								}
								return value;
							}
						},
						{
							field : 'action',
							title : '${internationalConfig.操作}',
							width : 50,
							formatter : function(value, row, index) {
								var str = $.formatString('<img onclick="deleteFun(\'{0}\');" src="{1}" title="${internationalConfig.删除}"/>',
										row.id, '/static/style/images/extjs_icons/cancel.png');
								return str;
							}
						}
					] ],
					onLoadSuccess : function() {
						//$(".pagination-page-list").hide();
						$('#searchForm table').show();
						parent.$.messager.progress('close');
					}
				});
	}

	function deleteFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		}
		parent.$.messager
			.confirm(
				'${internationalConfig.询问}',
				'${internationalConfig.您是否要删除此信息}',
				function(b) {
					if (b) {
						parent.$.messager.progress({
							title : '${internationalConfig.提示}',
							text : '${internationalConfig.数据处理中}....'
						});
						$
							.post(
								'/v2/product/aggPackage/deleteSubData',
								{
									id : id
								},
								function(result) {
									if (result.code == 0) {
										parent.$.messager
											.alert(
												'${internationalConfig.提示}',
												'${internationalConfig.删除成功}',
												'info');
										dataGrid
												.datagrid('reload');
									}
									parent.$.messager
											.progress('close');
								}, 'JSON');
					}
				});
	}

	// 增加自定义的表单验证规则
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
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post" action="${pageContext.request.contextPath}/mealController/create">
			<input id="id" type="hidden" name="id" value="${aggPackage.id}" />
			<table style="width: 100%" class="table table-form">
				<tr>
					<th><b style="color: red">*</b>${internationalConfig.内容包名称}</th>
					<td>
						<input type="text" id="aggPackageName" name="aggPackageName" value="${aggPackage.aggPackageName}"
							class="easyui-validatebox" data-options="required:true" disabled="disabled" style="width: 300px"/>
						<span id="message" style="color: red; font-size: 12px"></span>
					</td>
				</tr>
				<tr>
					<th>${internationalConfig.描述信息}</th>
					<td>
						<input type="text" id="desc" name="desc" value="${aggPackage.desc}" class="easyui-validatebox" disabled="disabled" style="width: 300px"/>
					</td>
				</tr>
				<tr style="display: none;">
					<th><b style="color: red">*</b>${internationalConfig.是否全片库}</th>
					<td>
					    <select name="isAllVideo" id="isAllVideo" onchange="releaseStatus()" class="easyui-validatebox" style="width: 155px" disabled="disabled">
                            <option value="">===${internationalConfig.请选择}===</option>
                            <option value="1" <c:if test="${aggPackage.isAllVideo == 1}"> selected </c:if> >${internationalConfig.是}</option>
                            <option value="2" <c:if test="${aggPackage.isAllVideo == 2}"> selected </c:if> >${internationalConfig.否}</option>
                        </select>
					</td>
				</tr>
				<tr>
					<th colspan="2" style="border-bottom: none;">${internationalConfig.请选择需要查看的内容类型}：</th>
				</tr>
				<tr id="tr_cids">
					<td colspan="2" style="border-top:none;padding:0">
						<div id="tabDiv" class="Menubox">
							<ul id="tab_ul" class="clearfix">
								<c:forEach var="contentType" items="${contentTypeList}">
									<li ctype="${contentType.type}">${internationalConfig[contentType.desc]}</li>
								</c:forEach>
							</ul>
							<div id="data_table">
								<table id="subDataGrid"></table>
							</div>
						</div>
						<div>
							<div id="con_one_2" style="display:none">${internationalConfig.直播列表}</div>
							<div id="con_one_3" style="display:none">${internationalConfig.轮播列表}</div>
						</div>
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
	<title>${internationalConfig.直播套餐管理}</title>
	<%@ include file="/WEB-INF/views/inc/head.inc"%>
	<script type="text/javascript">
		var dataGrid;
		(function($){
			$.fn.serializeJson=function(){

				var serializeObj={};
				var array=this.serializeArray();
				// var str=this.serialize();
				$(array).each(function(){ // 遍历数组的每个元素 {name : xx , value : xxx}
					if(serializeObj[this.name]){ // 判断对象中是否已经存在 name，如果存在name
						/* if($.isArray(serializeObj[this.name])){
						 serializeObj[this.name].push(this.value); // 追加一个值 hobby : ['音乐','体育']
						 }else{
						 // 将元素变为 数组 ，hobby : ['音乐','体育']
						 serializeObj[this.name]=[serializeObj[this.name],this.value];
						 }  */
						serializeObj[this.name]+=","+this.value;
					}else{
						serializeObj[this.name]=this.value; // 如果元素name不存在，添加一个属性 name:value
					}
				});
				return serializeObj;
			}
		})(jQuery)
		$(function() {

			dataGrid = renderDataGrid('/v2/product/livePackage/dataGrid');
		});
		var liveDict={<c:forEach var="dic" items="${liveDict}">"${dic.pid}-${dic.id}":"${dic.description}",</c:forEach>};
		function renderDataGrid(url) {
			return $('#dataGrid')
					.datagrid(
					{
						url : url,
						fit : true,
						fitColumns : true,
						border : false,
						pagination : true,

						idField : 'id',
						pageSize : 10,
						pageList : [ 10, 20, 30, 40, 50 ],
						sortName : 'id',
						sortOrder : 'desc',
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
								field : 'name',
								title : '${internationalConfig.直播名称}',
								width : 150,
								sortable : true
							},
							{
								field : 'matchId',
								title : '${internationalConfig.频道}',
								width : 120,
								sortable : true,
								formatter: function (value) {
									var channels={<c:forEach var="channel" items="${directList}">"${channel.id}":"${channel.description}",</c:forEach>};
									return channels[value];
								}
							},
							{
								field : 'itemId',
								title : '${internationalConfig.赛事}',
								width : 120,
								sortable : true,
								formatter: function (value,row,index) {
									return liveDict[row.matchId+"-"+value];
								}
							},
							{
								field : 'price',
								title : '${internationalConfig.现售价}',
								width : 120
							},
							{
								field : 'status',
								title : '${internationalConfig.套餐状态}',
								width : 120,
								formatter: function (value) {
									if (value == 1) {
										return "${internationalConfig.未发布}"
									} else if (value == 3){
										return "${internationalConfig.已发布}"
									}
								}
							},
							{
								field : 'action',
								title : '${internationalConfig.操作}',
								width : 100,
								formatter : function(value, row, index) {
									var str = '';

									str += $
											.formatString(
											'<img onclick="editFun(\'{0}\',\'{1}\');" src="{2}" title="${internationalConfig.编辑}"/>',
											row.id, row.matchId,
											'/static/style/images/extjs_icons/bug/bug_edit.png');

									str += '&nbsp;';

									str += $.formatString('<img onclick="deleteFun(\'{0}\');" src="{1}" title="${internationalConfig.删除}"/>', row.id, '/static/style/images/extjs_icons/bug/bug_delete.png');

									return str;
								}
							} ] ],
						toolbar : '#toolbar',
						onLoadSuccess : function() {
							$('#searchForm table').show();
							parent.$.messager.progress('close');
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
		}

		function editFun(id,pid) {
			if (id == undefined) {
				var rows = dataGrid.datagrid('getSelections');
				id = rows[0].id;
			}

			parent.$.modalDialog2({
				title : '${internationalConfig.编辑套餐}',
				width : 780,
				height : 580,
				href : $.formatString('/v2/product/livePackage/livePackageInfo?id={0}&pid={1}', id, pid),
				buttons : [ {
					text : '${internationalConfig.保存}',
					handler : function() {
						parent.$.modalDialog2.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
						var f = parent.$.modalDialog2.handler.find('#form1');
						//submitFun(f, 2);
						f.submit();
					}
				} , {
					text : "${internationalConfig.取消}",
					handler : function() {
						parent.$.modalDialog2.handler.dialog('close');
					}
				} ]
			});
		}

		function addFun() {
			parent.$.modalDialog2({
				title : '${internationalConfig.添加套餐}',
				width : 780,
				height : 580,
				href : '${pageContext.request.contextPath}/v2/product/livePackage/livePackageInfo?id=',
				buttons : [ {
					text : '${internationalConfig.增加}',
					handler : function() {
						parent.$.modalDialog2.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
						var f = parent.$.modalDialog2.handler.find('#form1');
						//submitFun(f, 1);
						f.submit();
					}
				} , {
					text : "${internationalConfig.取消}",
					handler : function() {
						parent.$.modalDialog2.handler.dialog('close');
					}
				} ]
			});
		}

		function deleteFun(id) {
			if (id == undefined) {
				var rows = dataGrid.datagrid('getSelections');
				id = rows[0].id;
			}
			parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.您是否要删除当前套餐}',
					function(b) {
						if (b) {
							parent.$.messager.progress({
								title : '${internationalConfig.提示}',
								text : '${internationalConfig.数据处理中}....'
							});
							$.post(
									'${pageContext.request.contextPath}/v2/product/livePackage/delete',
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
										} else {
											parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.删除失败}', 'error');
										}
										parent.$.messager
												.progress('close');
									}, 'JSON');
						}
					});
		}
		function submitFun(f, submitType){
			if(f.form("validate")){
				parent.$.messager.progress({
					title : '${internationalConfig.提示}',
					text : '${internationalConfig.数据处理中}....'
				});
				$.ajax({
					url:"${pageContext.request.contextPath}/v2/product/livePackage/save",
					type:"post",
					data:f.serializeJson(),
					dataType:"json",
					success:function(result){
						parent.$.messager.progress('close');
						/* result = $.parseJSON(result); */
						if (result.code == 0) {
							if(submitType == 1){
								parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.添加成功}', 'success');
							}else if (submitType == 2){
								parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.编辑成功}', 'success');
							}
							parent.$.modalDialog2.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog2.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
							parent.$.modalDialog2.handler.dialog('close');
						} else {
							parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.该套餐已存在}', 'error');
						}
					},
					error:function(){

					}


				})
			}
		}
		function searchFun() {
			parent.$.messager.progress({
				title : '${internationalConfig.提示}',
				text : '${internationalConfig.数据处理中}....'
			});
			dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
			parent.$.messager.progress('close');
		}
		function cleanFun() {
			$('#searchForm input').val('');
			$('#searchForm select').val('');
			dataGrid.datagrid('load', {});
		}

		function syncMatchsFun() {
			$.ajax({
				url:"${pageContext.request.contextPath}/v2/product/livePackage/syncMatchs",
				type:"post",
				success:function() {
					parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.同步完成}', 'success');
				}
			});
		}

		/*//终端设备联动
		 $(function(){

		 $("#matchid").change(function(){
		 var matchid = $("#matchid").val();
		 $
		 .ajax({
		 url : "${pageContext.request.contextPath}/play_package/get_match_info",
		 data : {
		 'pid' : matchid
		 },
		 success : function(result) {
		 var directIndex = null;
		 var optionsHtml = "";
		 $("#itemid").empty();
		 for (directIndex in result) {
		 var directModel = result[directIndex];
		 var optionHtml = '<option value="'+directModel.id+'">'
		 + directModel.description + '</option>';
		 optionsHtml += optionHtml;
		 }
		 var optionhtml = '<option value="-1" selected="selected">${internationalConfig.全部}</option>';
		 optionsHtml += optionhtml;
		 $("#itemid").html(optionsHtml);

		 var optionhtml1 = '<option value="-1" selected="selected">${internationalConfig.全部}</option>';
		 $("#sessionid").html(optionhtml1);

		 },
		 dataType : "json",
		 cache : false
		 });

		 });
		 }
		 );

		 //终端设备联动
		 $(function(){
		 $("#itemid").change(function(){
		 var matchid = $("#itemid").val();
		 $
		 .ajax({
		 url : "${pageContext.request.contextPath}/play_package/get_match_info.json",
		 data : {
		 'pid' : matchid
		 },
		 success : function(result) {
		 var directIndex = null;
		 var optionsHtml = "";
		 $("#seasonId").empty();
		 for (directIndex in result) {
		 var directModel = result[directIndex];
		 var optionHtml = '<option value="'+directModel.id+'">'
		 + directModel.description + '</option>';
		 optionsHtml += optionHtml;
		 }
		 var optionhtml = '<option value="-1" selected="selected">${internationalConfig.全部}</option>';
		 optionsHtml += optionhtml;
		 $("#seasonId").html(optionsHtml);
		 },
		 dataType : "json",
		 cache : false
		 });

		 });
		 }
		 ); */

		//终端设备联动
		$(function(){
			$("#matchId").change(function(){
				var matchId = $("#matchId").val();
				$.ajax({
					url : "/v2/product/livePackage/get_match_info",
					data : {
						'pid' : matchId
					},
					success : function(result) {
						var directIndex = null;
						var optionsHtml = "";
						var optionhtml = '<option value="" selected="selected">${internationalConfig.全部}</option>';
						optionsHtml += optionhtml;
						$("#itemId").empty();
						for (directIndex in result) {
							var directModel = result[directIndex];
							var optionHtml = '<option value="'+directModel.id+'">'
									+ directModel.description+  '</option>';
							optionsHtml += optionHtml;
						}
						$("#itemId").html(optionsHtml);
						//var optionhtml1 = '<option value="-1" selected="selected">${internationalConfig.All}</option>';
						//$("#sessionid").html(optionhtml1);
					},
					dataType : "json",
					cache : false
				});
			});
		});

	</script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
	<div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.直播套餐管理}',border:false,height:'auto'">
		<form id="searchForm" enctype="multipart/form-data">
			<table class="table-td-four">
				<tr>
					<td>${internationalConfig.频道}：<select class="span2" name="matchId" id="matchId">
						<option value=""> ${internationalConfig.全部}</option>
						<c:forEach items="${directList}" var="item">
							<option value="${item.id}">${item.description}</option>
						</c:forEach>
					</select></td>
					<td>${internationalConfig.赛事}：<select class="span2" name="itemId" id="itemId">
						<option value="">${internationalConfig.全部}</option>
						<%-- <option value="013">${internationalConfig.英超}</option> --%>
					</select></td>
					<td>${internationalConfig.直播名称}：<input type="text" name="name" class="span2"></td>
					<td>${internationalConfig.发布状态}：
						<select name="status" class="span2">
							<option value="0" selected>${internationalConfig.全部}</option>
							<option value="1">${internationalConfig.未发布}</option>
							<option value="3">${internationalConfig.已发布}</option>
						</select>
					</td>
				</tr>
			</table>
		</form>
	</div>
	<div data-options="region:'center',border:false">
		<table id="dataGrid"></table>
	</div>
</div>
<div id="toolbar" style="display: none;">

	<a onclick="addFun();" href="javascript:void(0);"
	   class="easyui-linkbutton"
	   data-options="plain:true,iconCls:'pencil_add'">${internationalConfig.增加}</a>
	<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
	<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">${internationalConfig.清空条件}</a>
	<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick',plain:true" onclick="syncMatchsFun();">${internationalConfig.同步直播赛事}</a>
</div>

<div id="menu" class="easyui-menu" style="width: 120px; display: none;">
	<div onclick="addFun();" data-options="iconCls:'pencil_add'">${internationalConfig.增加}</div>
	<div onclick="deleteFun();" data-options="iconCls:'pencil_delete'">${internationalConfig.删除}</div>
	<div onclick="editFun();" data-options="iconCls:'pencil'">${internationalConfig.编辑}</div>
</div>
</body>
</html>
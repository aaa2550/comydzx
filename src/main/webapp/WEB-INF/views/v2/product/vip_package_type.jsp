<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.会员类型设置}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript" src="/js/kv/vipCategory.js"></script>
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
		
		dataGrid = renderDataGrid('/v2/product/vipType/dataGrid');
	});

	function renderDataGrid(url,data,method) {
		return $('#dataGrid')
				.datagrid(
						{
							url : url,
							fit : true,
							queryParams:data||"",
							fitColumns : true,
							border : false,
							method:method||'post',
							pagination : true,
							idField : 'id',
							pageSize : 50,
							pageList : [ 50, 100 ],
							sortName : 'id',
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
							columns : [[{
											field : 'id',
											title : '${internationalConfig.会员ID}',
											width : 50,
											sortable : true,
											hidden : false
										},
							         	{
											field : 'name',
											title : '${internationalConfig.会员名称}',
											width : 100,
											sortable : false/* ,
											formatter : function(value) {
												return Dict.VipType[value];
											} */
										},
										{
											field : 'category',
											title : '${internationalConfig.会员类别}',
											width : 100,
											sortable : false,
											formatter : function(val) {
						                        return Dict.vipCategory[val];
											}
										},
										{
											field : 'ext',
											title : '${internationalConfig.会员描述}',
											width : 100,
											sortable : false
										},
										{
											field : 'action',
											title : '${internationalConfig.操作}',
											width : 140,
											formatter : function(value, row, index) {
												var str = $.formatString(
													'<img onclick="editFun(\'{0}\');" src="{1}" title="${internationalConfig.编辑}"/>',
													row.id, '/static/style/images/extjs_icons/bug/bug_edit.png');
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

	function deleteFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		}
		parent.$.messager
				.confirm(
						'${internationalConfig.询问}',
						'${internationalConfig.您是否要删除当前套餐}',
						function(b) {
							if (b) {
								parent.$.messager.progress({
									title : '${internationalConfig.提示}',
									text : '${internationalConfig.数据处理中}....'
								});
								$
										.post(
												'/v2/product/vipPackage/delete',
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

	function editFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		}

		parent.$.modalDialog({
			title : '${internationalConfig.编辑会员管理套餐}',
			width : 650,
			height : 430,
			href : '/v2/product/vipType/packageTypeInfo?id='
					+ id,
			onClose:function(){
				this.parentNode.removeChild(this);
			},		
			buttons : [ {
				text : '${internationalConfig.保存}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#form');
					submitFun(f,id);
				}
			}, {
				text : "${internationalConfig.取消}",
				handler : function() {
					parent.$.modalDialog.handler.dialog('close');
				}
			} ]
		});
	}

	
	function addFun(id) {
		parent.$.modalDialog({
			title : '${internationalConfig.添加会员管理套餐}',
			width : 650,
			height : 500,
			href : '/v2/product/vipType/packageTypeInfo?id=',
			onClose:function(){
				this.parentNode.removeChild(this);
			},	
			buttons : [ {
				text : '${internationalConfig.增加}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#form');
					submitFun(f); 
					
				}
			}, {
				text : "${internationalConfig.取消}",
				handler : function() {
					parent.$.modalDialog.handler.dialog('close');
				}
			} ]
		});
	}
	function submitFun(f, vipTypeId){
		if(f.form("validate")){
			parent.$.messager.progress({
				title : '${internationalConfig.提示}',
				text : '${internationalConfig.数据处理中}....'
			});
			$.ajax({
				url:"/v2/product/vipType/save",
				type:"post",
				data:f.serializeJson(),
				dataType:"json",
				success:function(result){
					parent.$.messager.progress('close');
					/* result = $.parseJSON(result); */
					if (result.code == 0) {
						var successMsg = vipTypeId ? '${internationalConfig.编辑成功}' : '${internationalConfig.添加成功}';
	                	parent.$.messager.alert('${internationalConfig.成功}', successMsg, 'success');
						parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
						parent.$.modalDialog.handler.dialog('close');
					} else {
						parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
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
		renderDataGrid('/v2/product/vipType/dataGrid?',$('#searchForm').serializeJson(),"get")
		parent.$.messager.progress('close');
	}
	function cleanFun() {
		$('#searchForm input').val('');
		$('select').val('');
		$(".easyui-numberbox").numberbox('setValue','');
		renderDataGrid('/v2/product/vipType/dataGrid');
	}
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.会员管理}',border:false,height:'auto'">
			<form id="searchForm">
				<table class="table-td-four">
					<tr>
						<td>${internationalConfig.会员ID}:&nbsp;&nbsp;&nbsp;&nbsp;<input name="id" class="easyui-numberbox" /></td>
						<td>${internationalConfig.会员名称}:&nbsp;&nbsp;&nbsp;&nbsp;<input name="name" class="span2" /></td>
						<td>${internationalConfig.会员类别}:&nbsp;&nbsp;&nbsp;&nbsp;
							<select name="category" id="category" style="width: 150px">
								<option value="">${internationalConfig.全部}</option>
								<c:forEach var="vipCategory" items="${vipCategoryList}">
									<option value="${vipCategory.category}"> ${internationalConfig[vipCategory.name]}</option>
								</c:forEach>
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
		
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">${internationalConfig.清空条件}</a>
			
	</div>
</body>
</html>
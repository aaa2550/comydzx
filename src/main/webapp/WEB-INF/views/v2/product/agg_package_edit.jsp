<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/inc/jstl.inc"%>
<c:if test="${not empty param.singlePage}">
	<%@ include file="/WEB-INF/views/inc/head.inc"%>
</c:if>
<script type="text/javascript">
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

		$('#add').click(function() {
			//获取选中的选项，删除并追加给对方
			add($('#select1 option:selected'));
			$('#select1 option:selected').appendTo('#select2');
		});
		//移到左边
		$('#remove').click(function() {
			remove($('#select2 option:selected'))
			$('#select2 option:selected').appendTo('#select1');
		});
		//全部移到右边
		$('#add_all').click(function() {
			//获取全部的选项,删除并追加给对方
			add($('#select1 option'))
			$('#select1 option').appendTo('#select2');
		});
		//全部移到左边
		$('#remove_all').click(function() {
			$("#boundEvents").val("[]");
			$('#select2 option').appendTo('#select1');
		});
		//双击选项
		$('#select1').dblclick(function(){ //绑定双击事件
			//获取全部的选项,删除并追加给对方
			add($("option:selected",this));
			$("option:selected",this).appendTo('#select2'); //追加给对方
		});
		//双击选项
		$('#select2').dblclick(function(){
			remove($("option:selected",this))
			$("option:selected",this).appendTo('#select1');
		});
	});

	function ctypeChange(ctypeComp) {
		if (ctypeComp.value == 4) {
			// 体育赛事
			$("#tr_cids").hide();
			$("#tr_live_channels").hide();
			$("#tr_sports").show();
			$('#channelOfMatchTH').show();
			$('#channelOfMatchTD').show();
		} else if (ctypeComp.value == 5) {
			$("#tr_sports").hide();
			$("#tr_cids").hide();
			$("#tr_live_channels").show();
			$('#channelOfMatchTH').hide();
			$('#channelOfMatchTD').hide();
		} else {
			// 其他
			$('#channelOfMatchTH').hide();
			$('#channelOfMatchTD').hide();
			$("#tr_live_channels").hide();
			$("#tr_sports").hide();
			$("#tr_cids").show();
		}
	}

	function add(select){
		var selectedEvents=$("#boundEvents").val();
		selectedEvents=selectedEvents=='' ? []:JSON.parse(selectedEvents);
		$(select).each(function(){
			selectedEvents.push(JSON.parse($(this).val()));
		});
		$("#boundEvents").val(JSON.stringify(selectedEvents));
	}
	function remove(select){
		var selectedEvents=$("#boundEvents").val();
		selectedEvents=selectedEvents==''?[] : JSON.parse(selectedEvents);
		$(select).each(function(){
			var event=JSON.parse($(this).val());
			selectedEvents=$.grep(selectedEvents,function(value){
				return value.subCtype!=event.subCtype || value.cid!=event.cid;
			});
		});
		$("#boundEvents").val(JSON.stringify(selectedEvents));
	}
	// 赛事列表{“频道Id”:{"赛事ID"：“赛事名”,...},...}
	var liveEvents={<c:forEach var="liveChannel" items="${liveChannelList}">"${liveChannel.id}":{<c:forEach var="liveEvent" items="${sportsSeasonLiveList}"><c:if test="${liveEvent.pid==liveChannel.id}">"${liveEvent.id}":"${liveEvent.typeDescription} - ${fn:replace(liveEvent.description, "\"", "\\\"")}",</c:if></c:forEach>},</c:forEach>};
	// 根据频道改变显示不同的赛事列表
	function changeChannelOfMatch(channelOfMatch){
		channelOfMatch = $(channelOfMatch).val();
		function eventSelected(value){
			var selected=$('#select2 option');
			for (var i=0;i<selected.length;i++){
				if($(selected[i]).val()==value)
					return true;
			}
			return false;
		}
		var options = [];
		var func = function(select,liveEvents) {
			select.empty();
			for (var channel in liveEvents) {
				if (channel == channelOfMatch) {
					var liveEvent = liveEvents[channel];
					for (var eventId in liveEvent) {
						var value = JSON.stringify({subCtype:channelOfMatch,cid:eventId});
						var option = $("<option>", {value: value, text: liveEvent[eventId]});
						options.push(option);
						if (!eventSelected(value))
							select.append(option);
					}
				}
			}
		};
		func($("#select1"),liveEvents);

		// 查找功能
		//var options = $('#select1 option');
		$("#search_btn").click(function(){
			var searchText = $("#search_text").val();
			var html = "";
			//设置查询正则
			var searchTerm = searchText.split("");
			searchTerm = searchTerm.join(".*");
			var regExp = new RegExp(searchTerm,'gi');
			var select1 = $("#select1");
			select1.empty();
			for(var i=0;i<options.length;i++){
				var text=options[i].text();
				var value=options[i].val();
				if(text.match(regExp)&&!eventSelected(value)){
					select1.append($("<option>", {value:value, text:text}));
				}
			}
		});
	}
	$(document).ready(function(){
		changeChannelOfMatch($('#channelOfMatch'));
	});
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post" action="">
			<input type="hidden" name="id" value="${aggPackage.id}" />
			<input type="hidden" id="boundEvents" name="boundEvents" value='[<c:forEach items="${bindedSportsSeasonList}" var="item" varStatus="cnt"><c:if test="${cnt.index!=0}">,</c:if>{"subCtype":"${item.pid}","cid":"${item.id}"}</c:forEach>]' />
			<table style="width: 100%" class="table table-form">
				<colgroup>
					<col width="100">
					<col width="150">
					<col width="*">
				</colgroup>
				<tr>
					<th><b style="color: red">*</b>${internationalConfig.内容包名称}</th>
					<td>
						<input type="text" id="aggPackageName" name="aggPackageName" value="${aggPackage.aggPackageName}"
							class="easyui-validatebox" />
					</td>
					<th>${internationalConfig.描述信息}</th>
					<td>
						<input type="text" id="desc" name="desc" value="${aggPackage.desc}" class="easyui-validatebox" />
					</td>
				</tr>
				<!-- 
				<tr>
		        	<th colspan='3' style="border-top:none;">请选择要导入的内容类型，并输入内容的ID列表（<b style="color: red">内容ID以英文逗号（,）分隔</b>）</th>
		        </tr>
		         -->
		        <tr>
		        	<th><b style="color: red">*</b>${internationalConfig.内容类型}</th>
		        	<td>
		        		<select name="ctype" id="ctype" style="width: 155px" onchange="ctypeChange(this)">
			                  <c:forEach var="contentType" items="${contentTypeList}">
			                      <option value="${contentType.type}"> ${internationalConfig[contentType.desc]}</option>
			                  </c:forEach>
			            </select>
		        	</td>
					<th><span id="channelOfMatchTH" style="display: none;"><b style="color: red">*</b>${internationalConfig.直播频道}</span></th>
					<td><span id="channelOfMatchTD" style="display: none;">
						<select id="channelOfMatch" onchange="changeChannelOfMatch(this)" class="easyui-validatebox" style="width: 155px">
							<c:forEach var="liveChannel" items="${liveChannelList}">
								<option value="${liveChannel.id}">${internationalConfig[liveChannel.description]}</option>
							</c:forEach>
						</select></span>
					</td>
		        </tr>
        		<tr id="tr_cids">
			        <td colspan="4" style="border-top:none;">
			        	${internationalConfig.请输入内容的ID列表}（<b style="color: red">${internationalConfig.内容ID以英文逗号分隔}</b>）<br>
	        			<textarea id="cids" name="cids" rows="10" style="width: 400px;"></textarea>
		            </td>
	            </tr>
	            <tr id="tr_live_channels" style="display: none">
	            	<td colspan="4" style="border-top:none;">
	            		${internationalConfig.请选择需要导入的频道}<br>
			        	<c:forEach items="${liveChannelList}" var="liveChannel">
							<c:set var="checked" value=""/>
							<c:forEach var="binded" items="${bindedLiveChannelIdList}">
								<c:if test="${binded==liveChannel.id}"><c:set var="checked" value='checked="checked"'/></c:if>
							</c:forEach>
							<input id="liveChannel_${liveChannel.id}" type="checkbox" name="liveChannelList" value="${liveChannel.id}" ${checked}> ${internationalConfig[liveChannel.description]} &nbsp;&nbsp;
			            </c:forEach>
		            </td>
	            </tr>
	            <tr id="tr_sports" style="display: none">
			        <td colspan="4" style="border-top:none;">
						<div style="padding-top: 5px;padding-bottom: 5px;">
							<input id="search_text" type="text" value=""/>&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="button" class="btn" id="search_btn" value="${internationalConfig.查找}"/>
						</div>
			        	<div>
						  <select multiple="multiple" id="select1" style="width:200px;height:200px; float:left; border:4px #A0A0A4 outset; padding:4px; ">
						  </select>
						</div>
						<div style="float:left">
							<span id="add">
								<input type="button" class="btn" value=">"/>
							</span><br />
							<span id="add_all">
								<input type="button" class="btn" value=">>"/>
							</span> <br />
							<span id="remove">
								<input type="button" class="btn" value="<"/>
							</span><br />
							<span id="remove_all">
								<input type="button" class="btn" value="<<"/>
							</span>
						</div>
						<div>
							<select multiple="multiple" id="select2" style="width: 200px;height:200px; float:left;border:4px #A0A0A4 outset; padding:4px;">
								<c:forEach items="${bindedSportsSeasonList}" var="item">
									<option value='{"subCtype":"${item.pid}","cid":"${item.id}"}'>${item.typeDescription} - ${item.description}</option>
								</c:forEach>
							</select>
						</div>
		            </td>
	            </tr>
			</table>
		</form>
	</div>
</div>

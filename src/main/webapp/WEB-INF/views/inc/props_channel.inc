<%@ page pageEncoding="UTF-8"%>
<select  name="channelId" class="span2 js_channelId"></select>

<script>

//$("[name='businessId']").trigger("change");

$("[name='channelId']").change(function(){
	//操作分类
	var typeObj = $("[name='typeId']");
	if (typeObj.length > 0) {
		typeObj.empty();
		<c:if test="${!hideTypeAllOptions}">
		var option={value:"0",text:"不限"};
		typeObj.append($("<option>", option));
		</c:if>
		var channelId = $(this).val();
		var dataMap = Dict.propsType;
		if ($.isEmptyObject(dataMap)) return;
		if (channelId > 0) {
			for(var key in dataMap){
				if (dataMap[key].channelId == channelId) {
					var option={value:key,text:dataMap[key].name};
					typeObj.append($("<option>", option));
				}
			}
		} else {
			<%--<c:if test="${!hideTypeAllOptions}">
				var option={value:"0",text:"不限"};
				typeObj.append($("<option>", option));
			</c:if>
			for(var key in dataMap){
				var option={value:key,text:dataMap[key].name};
				typeObj.append($("<option>", option));
			}--%>
		}

		typeObj.trigger("change");
	}

	//操作运营分类
	var operateTypeObj = $("[name='operateTypeId']");
	if (operateTypeObj.length > 0) {
		operateTypeObj.empty();
		<c:if test="${!hideOperateTypeObjAllOptions}">
		var option={value:"0",text:"不限"};
		operateTypeObj.append($("<option>", option));
		</c:if>
		var channelId = $(this).val();
		var dataMap = Dict.propsOperateType;
		if ($.isEmptyObject(dataMap)) return;
		if (channelId > 0) {
			for(var key in dataMap){
				if (dataMap[key].channelId == channelId) {
					var option={value:key,text:dataMap[key].name};
					operateTypeObj.append($("<option>", option));
				}
			}
		} else {
			<%--<c:if test="${!hideTypeAllOptions}">
				var option={value:"0",text:"不限"};
				typeObj.append($("<option>", option));
			</c:if>
			for(var key in dataMap){
				var option={value:key,text:dataMap[key].name};
				typeObj.append($("<option>", option));
			}--%>
		}

		operateTypeObj.trigger("change");
	}
})

/**(function(){
	var channelObj = $("[name='channelId']");
	channelObj.empty();
	<c:if test="${!hideChannelAllOptions}">
		var option={value:"0",text:"全部"};
		channelObj.append($("<option>", option));
	</c:if>
	var dataMap = Dict.propsChannel;
	for(var key in dataMap){
		var option={value:key,text:dataMap[key].name};
		channelObj.append($("<option>", option));
	}
})();**/

</script>
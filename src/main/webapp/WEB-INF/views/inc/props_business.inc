<%@ page pageEncoding="UTF-8"%>
<select  name="businessId" class="span2 js_businessId">
    <c:if test="${!hideBusinessAllOptions}">
         <option value="0">不限</option>
    </c:if>
</select>
<script>
(function(){
	var obj = Dict.propsBusiness;
	var html = "";
	for(var i in obj){
		html += '<option value="'+i+'" >'+obj[i]+'</option>'
	}
	$(".js_businessId").append(html);
})();

$("[name='businessId']").change(function(){
	var channelObj = $("[name='channelId']");
	if (channelObj.length > 0) {
		channelObj.empty();
		<c:if test="${!hideChannelAllOptions}">
		var option={value:"0",text:"不限"};
		channelObj.append($("<option>", option));
		</c:if>
		var businessId = $(this).val();
		var dataMap = Dict.propsChannel;
		if ($.isEmptyObject(dataMap)) return;
		if (businessId > 0) {
			for(var key in dataMap){
				if (dataMap[key].businessId == businessId) {
					var option={value:key,text:dataMap[key].name};
					channelObj.append($("<option>", option));
				}
			}
		} else {
			<%--<c:if test="${!hideChannelAllOptions}">
				var option={value:"0",text:"全部"};
				channelObj.append($("<option>", option));
			</c:if>--%>
			for(var key in dataMap){
				var option={value:key,text:dataMap[key].name};
				channelObj.append($("<option>", option));
			}
		}

		channelObj.trigger("change");
	}
})
</script>
<%@ page pageEncoding="UTF-8"%>
<select  name="unitId" class="span2 js_unitId"></select>

<script>

(function(){
	var unitObj = $("[name='unitId']");
	unitObj.empty();
	var useDefault = 1;
	var defaultValue = 0;
	<c:if test="${!hideUnitAllOptions}">
		var option={value:"0",text:"全部"};
		unitObj.append($("<option>", option));
		useDefault = 0;
		defaultValue = 0;
	</c:if>
	var dataMap = Dict.propsUnit;
	if ($.isEmptyObject(dataMap)) return;
	for(var key in dataMap){
		var option={value:key,text:dataMap[key].name};
		unitObj.append($("<option>", option));
		if (useDefault == 1 && dataMap[key].isDefault == 1){
			defaultValue = key;
		}
	}
	unitObj.val(defaultValue);
})();

</script>
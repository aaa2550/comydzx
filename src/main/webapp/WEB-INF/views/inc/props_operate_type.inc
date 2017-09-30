<%@ page pageEncoding="UTF-8"%>
<select  name="operateTypeId" class="span2 js_operateTypeId"></select>

<script>

/*(function(){
	var operateTypeObj = $("[name='operateTypeId']");
	operateTypeObj.empty();
	<c:if test="${!hideOperateTypeAllOptions}">
		var option={value:"0",text:"选择运营分类"};
		operateTypeObj.append($("<option>", option));
	</c:if>
	var dataMap = Dict.propsOperateType;
	if ($.isEmptyObject(dataMap)) return;
	for(var key in dataMap){
		var option={value:key,text:dataMap[key]};
		operateTypeObj.append($("<option>", option));
	}
})();*/

</script>
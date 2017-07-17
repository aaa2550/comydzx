<%@ page pageEncoding="UTF-8"%>
<div style="white-space:nowrap;width:600px" id="div_propertyId"></div>
<style>
	span{padding-right:10px;}
</style>
<script>
(function(){
	var propertyObj = $("#div_propertyId");
	propertyObj.html("");
	var dataMap = Dict.propsProperty;
	if ($.isEmptyObject(dataMap)) return;
	for(var key in dataMap){
	    var checkbox = $("<input type='checkbox' name='property_ids'>");
	    checkbox.val(key);
		propertyObj.append(checkbox);
		propertyObj.append($('<span>', {text:dataMap[key].name}));
		if (dataMap[key].isDefault == 1){
			checkbox.attr('checked','true');;
		}
	}
})();

</script>
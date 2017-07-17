<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/inc/jstl.inc"%>

<script type="text/javascript">

    (function($) {
        parent.$.messager.progress('close');
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
        var categoryId = $("#categoryId").val();
        $.ajax({
            type: 'GET',
            cache: false,
            url: '/mini/category_attr/dataGrid?id='+categoryId+'&pagesize='+100,
            dataType: 'json',
            success: function(res) {
                var html = "";
                for(var i in res.rows){
                    if("${attributeIds}".indexOf(res.rows[i].attributeId)>=0){
                        html += '<span><input type="checkbox" name="attr" value="'+res.rows[i].attributeId+'" checked readonly/>'+res.rows[i].name+'</span>';
                    }else{
                        html += '<span><input type="checkbox" name="attr" value="'+res.rows[i].attributeId+'"/>'+res.rows[i].name+'</span>';
                    }

                }
                $(html).appendTo("#form");
                $("input:checked").click(function (e) {
                    e.preventDefault();
                })
            }
        });
    })(jQuery);
</script>
<style>
    .select_form span{display: inline-block;margin: 5px;}
</style>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="">
        <input type="hidden" id="categoryIds" name="categoryId" value="${attributeIds}"/>
        <input type="hidden" id="categoryId" name="categoryId" value="${categoryId}"/>
        <form id="form" class="select_form" method="post" action="" style="padding: 20px">
            <%--<span><input type="checkbox" name="attr" value="4"/>时长单位</span>--%>
        </form>
    </div>
</div>

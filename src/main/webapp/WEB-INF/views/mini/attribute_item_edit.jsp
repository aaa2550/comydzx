<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/inc/jstl.inc"%>

<script type="text/javascript">
    $.extend($.fn.validatebox.defaults.rules, {
        maxLength: {
            validator: function(value, param){
                var length = value.replace(/[\u0391-\uFFE5]/g,"aa").length;
                return param[0] >= length;
            },
            message: '不得超过{0}个字符'
        }
    });
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
    })(jQuery)
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="">
        <form id="form" method="post" action="">
            <input type="hidden" name="id" value="${attributeItem.id}">
            <input type="hidden" name="attributeId" value="${attributeId}">
            <table style="width: 100%" class="table table-form">
                <tr>
                    <th><b style="color: red">*</b>属性值名称</th>
                    <td>
                        <input type="text" name="attributeItem" value="${attributeItem.attributeItem}"
                               class="easyui-validatebox"  data-options="required:true,validType:'maxLength[40]'"/>
                        <span style="color: gray;padding-left: 10px;">不得超过20个汉字或40个字符</span>
                    </td>
                </tr>
                <tr>
                    <th><b style="color: red">*</b>${internationalConfig.排序}</th>
                    <td colspan="3">
                        <input type="text" name="sort" value="${attributeItem.sort}" class="easyui-validatebox" onkeyup="value=value.replace(/[^\d.]/g,'')" data-options="required:true,validType:'maxLength[5]'" invalidMessage="不得超过5位数"/>
                        <span style="color: gray;padding-left: 10px;">仅限填写数字，数字越小，排序越靠前</span>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>

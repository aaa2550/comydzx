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
            <input type="hidden" name="id" value="${attribute.id}">
            <table style="width: 100%" class="table table-form">
                <tr>
                    <th><b style="color: red">*</b>${internationalConfig.属性名称}</th>
                    <td>
                        <input type="text" name="name" value="${attribute.name}"
                               class="easyui-validatebox"  data-options="required:true,validType:'maxLength[40]'"/>
                        <span style="color: gray;padding-left: 10px;">不得超过20个汉字或40个字符</span>
                    </td>
                </tr>
                <tr>
                    <th><b style="color: red">*</b>${internationalConfig.显示名称}</th>
                    <td colspan="3">
                        <input type="text" name="showName" value="${attribute.showName}"
                               class="easyui-validatebox"  data-options="required:true,validType:'maxLength[8]'"/>
                        <span style="color: gray;padding-left: 10px;">不得超过4个汉字或8个字符</span>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>

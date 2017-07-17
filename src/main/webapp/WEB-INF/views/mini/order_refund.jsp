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
    })(jQuery)
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="">
        <form id="form" method="post" action="">
            <input type="hidden" name="userId" value="${userId}">
            <table style="width: 100%" class="table table-form">
                <tr>
                    <th><b style="color: red">*</b>订单号</th>
                    <td>
                        <input type="text" name="orderNo" value="${orderNo}" maxlength="16" readonly/>
                        <span style="color: gray;padding-left: 10px;"></span>
                    </td>
                    <th><b style="color: red">*</b>退款金额</th>
                    <td>
                        <input type="text" name="refundPrice" value="${payPrice}"
                               class="easyui-validatebox" data-options="required:true"/>
                        <span style="color: gray;padding-left: 10px;"></span>
                    </td>
                </tr>
                <tr>
                    <th><b style="color: red">*</b>退款原因</th>
                    <td colspan="3">
                        <textarea type="text" name="reason" value="" style="width: 475px;height: 80px;"
                               class="easyui-validatebox"  data-options="required:true"></textarea>
                        <span style="color: gray;padding-left: 10px;"></span>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>

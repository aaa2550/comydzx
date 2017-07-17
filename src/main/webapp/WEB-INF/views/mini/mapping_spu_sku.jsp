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
        if($('#skuNo').val()){
            search();
        }
    })(jQuery)

    function search() {
        var spuId = $('#spuId').val();
        var skuNo = $('#skuNo').val();
        $.ajax({
            url : "/mini/sku/detail?skuNo="+skuNo,
            type : "post",
            dataType : "json",
            success : function(res) {
                if(res){
                    $("#sku_name").val(res.name);
                    $("#price").val(res.price);
                    $("#skuId").val(res.id);
                    //$("#marketPrice").val(res.marketPrice);
                }
            },

            error : function() {
                parent.$.messager.alert('${internationalConfig.错误}', '未检索到商品信息。', 'error');
            }
        })
    }
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="">
        <form id="form" method="post" action="">
            <input type="hidden" name="spuId" id="spuId" value="${spuId}">
            <input type="hidden" name="skuId" id="skuId" value="">
            <input type="hidden" name="mappingSkuId" id="mappingSkuId" value="${skuInfo.skuId}">
            <input type="hidden" name="attributeInfo" id="attributeInfo" value="${attributeInfo}">
            <table style="width: 100%" class="table table-form">
                <tr>
                    <th><b style="color: red">*</b>商品编码</th>
                    <td>
                        <input type="text" name="skuNo" id="skuNo" value="${skuInfo.skuNo}" style="width: 290px;"
                               class="easyui-validatebox"  data-options="required:true"/>
                        <button type="button" onclick="search()" style="padding: 1px 3px;margin-left: 5px">检索</button>
                        <span style="color: gray;padding-left: 10px;">输入商品编码，检索商品信息</span>
                    </td>
                </tr>
                <tr>
                    <th><b style="color: red">*</b>商品名称</th>
                    <td>
                        <input type="text" name="" id="sku_name" value="${skuInfo.name}" style="width: 290px;" readonly="readonly"
                               class="easyui-validatebox" data-options="required:true"/>
                        <span style="color: gray;padding-left: 10px;"></span>
                    </td>
                </tr>
                <tr>
                    <th><b style="color: red">*</b>销售属性</th>
                    <td>
                        <input type="text" name="" value="${attributeString}" style="width: 290px;" readonly="readonly"
                               class="easyui-validatebox"/>
                        <span style="color: gray;padding-left: 10px;"></span>
                    </td>
                </tr>
                <tr>
                    <th><b style="color: red">*</b>售卖价格</th>
                    <td>
                        <input type="text" name="" id="price" value="${skuInfo.price}" style="width: 290px;" readonly="readonly"
                               class="easyui-validatebox"  data-options="required:true"/>
                        <span style="color: gray;padding-left: 10px;"></span>
                    </td>
                </tr>
                <%--<tr>
                    <th><b style="color: red">*</b>经销商价格</th>
                    <td>
                        <input type="text" name="" id="marketPrice" value="${skuInfo.marketPrice}" style="width: 290px;" readonly="readonly"
                               class="easyui-validatebox"  data-options="required:true"/>
                        <span style="color: gray;padding-left: 10px;"></span>
                    </td>
                </tr>--%>
                <tr style="display: none">
                    <th><b style="color: red">*</b>是否默认</th>
                    <td>
                        <input type="radio" name="isDefault" style="margin: 0 3px 0 3px" value="2" <c:if test="${empty skuInfo.isDefault ||skuInfo.isDefault==2}">checked</c:if> />是
                        <input type="radio" name="isDefault" style="margin: 0 3px 0 10px" value="1" <c:if test="${empty skuInfo || skuInfo.isDefault==1}">checked</c:if>/>否
                        <span style="color: gray;padding-left: 10px;"></span>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>

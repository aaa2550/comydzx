<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/inc/jstl.inc"%>
<!DOCTYPE html>
<html>
<head>
    <title>编辑商品</title>
    <script src="/static/lib/swfupload/swfupload.js" type="text/javascript" charset="utf-8"></script>
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
    <style>
        .cont1{width:100%;}
        .cont2{margin:0 20px;padding:14px 20px;color:#444;position: relative;font-size: 12px;}
        .cont2:last-child{border-bottom:0px dashed #aaa;}
        .title{margin-bottom: 10px;font-weight: bold;}
        td{height: 30px;padding: 10px 0;}
        td input{width: 300px;height: 25px;padding: 1px 10px;}
        td select{width: 316px;height: 30px;padding: 1px 10px;margin-right:25px;}
        td textarea{width: 292px;height: 80px;padding: 1px 10px;margin-right:25px;}
        td .margin5{margin-right: 5px;}
        .name-span{float: none;margin-left: 10px;}
        table b{padding-left: 10px;}
        table tr td span{margin-right: 10px;display: inline-block;float: none;}
        table tr td input{margin-right: 30px;}
        .val-span{min-width:100px;color:#777;float: none;}
        .attention{color:#f00;float:left;margin-top: 54px;}
        .edit-btn{margin: 0 0 0 60px;padding: 2px 6px;cursor: pointer;}
        a.edit-btn{padding: 2px 20px;text-decoration:none;}
        .close-btn{margin: 20px 0 0 60px;padding: 2px 6px;}
        .save-btn{margin: 20px 0 0 450px;padding: 2px 6px;}
        .gray{color: gray;}
        .hide_btn{display: none;}
        .vendor_num{font-style: normal;}
        .detail{font-family: "Microsoft YaHei", arial;font-size: 14px;}
        .detail p{line-height: 25px;color: #333;}
        .detail p b{color: #333}
        .detail p span{color: #00a9d5;}
        .detail input{margin-left: 10px;border-radius: 0;width: 174px;padding: 2px 5px;}
        .detail table{border:1px solid #ddd;width: 100%;margin: 10px 0}
        .detail table td,.detail table th{text-align: center;padding: 3px 0;height: 24px;}
        .detail table th{background: #00a9d5}
        .window, .window-shadow{position: fixed;}
    </style>
</head>
<body>
<div class="cont1">
    <div class="cont2">
        <p class="title">1.商品信息 <a class="edit-btn edit_mes_btn" onclick="editSku('sku_form',event)">${internationalConfig.编辑}</a></p>
        <form id="sku_form" class="mini_form" style="border-bottom: 1px dashed #bbb;padding-bottom: 20px;">
            <input type="hidden" name="skuId" id="skuId" value="${sku.id}"/>
            <table>
                <tr>
                    <td width="120"><b style="color: red">*</b><span class="name-span">商品编码</span></td>
                    <td><input type="text" id="skuNo" name="skuNo" value="${sku.skuNo}" readonly="readonly"/></td>
                    <td><span class="gray">系统自动生成</span></td>
                </tr>
                <tr>
                    <td><b style="color: red">*</b><span class="name-span">商品名称</span></td>
                    <td><input type="text" name="name" value="${sku.name}" class="easyui-validatebox" data-options="required:true,validType:'maxLength[40]'"/></td>
                    <td><span class="gray">不得超过20个汉字或40个字符</span></td>
                </tr>
                <tr>
                    <td><b style="color: red">*</b><span class="name-span">显示名称</span></td>
                    <td><input type="text" name="showName" value="${sku.showName}" class="easyui-validatebox" data-options="required:true,validType:'maxLength[40]'"/></td>
                    <td><span class="gray">不得超过20个汉字或40个字符</span></td>
                </tr>
                <tr>
                    <td><b style="color: red">*</b><span class="name-span">售卖价格</span></td>
                    <td><input type="text" id="price" name="price" value="${sku.price}" class="easyui-validatebox margin5" data-options="required:true,validType:'length[0,9]'" onblur="returnFloat(this)" onkeyup="value=value.replace(/[^\d.]/g,'')"/> 元</td>
                    <td><span class="gray">仅限填写数字，单位为“元”</span></td>
                </tr>
                <tr>
                    <td><b style="color: red">*</b><span class="name-span">价格描述</span></td>
                    <td><input type="text" name="priceInfo" value="${sku.priceInfo}" class="easyui-validatebox" data-options="required:true"/></td>
                    <td><span class="gray">该信息显示在统一收银台“售卖价格”后面</span></td>
                </tr>
                <%--<tr>
                    <td><b style="color: red">*</b><span class="name-span">经销商价格</span></td>
                    <td><input type="text" id="marketPrice" name="marketPrice" value="${sku.marketPrice}" class="easyui-validatebox margin5" precision="2" data-options="required:true,validType:'length[0,20]'" onblur="returnFloat(this)" onkeyup="value=value.replace(/[^\d.]/g,'')"/> 元</td>
                    <td><span class="gray">商户提供的商品批发价，一般低于售卖价</span></td>
                </tr>--%>
                <tr>
                    <td><b style="color: red">*</b><span class="name-span">固定成长值</span></td>
                    <td><input type="text" name="lefanVal" value="${sku.lefanVal}" class="easyui-validatebox" data-options="required:true,validType:'maxLength[9]'"/></td>
                    <td><span class="gray">该商品价值对应的固定参考成长值</span></td>
                </tr>
                <tr>
                    <td><b style="color: red">*</b><span class="name-span">收款方</span></td>
                    <td>
                        <select name="skuPayId" class="easyui-validatebox" data-options="validType:'selectRequire'">
                            <option value="-1">请选择</option>
                            <c:forEach var="channel" items="${payChannel}">
                                <option value="${channel.key}"
                                        <c:if test="${channel.key==sku.skuPayId}">selected</c:if>>${channel.value}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td><span class="gray"></span></td>
                </tr>
                <tr>
                    <td><b style="color: red">*</b><span class="name-span">商品介绍</span></td>
                    <td><textarea type="text" name="description" class="easyui-validatebox" data-options="required:true,validType:'maxLength[200]'">${sku.description}</textarea></td>
                    <td><span class="gray">最多不超过100个汉字或200个字符</span></td>
                </tr>
                <tr>
                    <td><b></b><span class="name-span">使用规则</span></td>
                    <td><textarea type="text" name="introduction" class="easyui-validatebox" data-options="validType:'maxLength[200]'">${sku.introduction}</textarea></td>
                    <td><span class="gray">用于单片产品售卖使用，不填写则前端隐藏该区域</span></td>
                </tr>
                <tr>
                    <td><b style="color: red">*</b><span class="name-span">商品列表图</span></td>
                    <td>
                        <input type="text" id="common_pic1" name="imgUrls" value="" onkeyup="delLink(this)" style="width: 145px;vertical-align: top;margin-right:20px"/>
                        <input class="buttoncenter" type="button" value="${internationalConfig.上传文件}" id="common_upload_btn1" style="margin-top:2px;margin-right:30px;"/>
                        <span id="see_pic1" style="vertical-align: top;"><a class="link_img" style="vertical-align: top;margin-left: 20px;" href="javascript:;" target="_blank">查看图片</a></span>
                    </td>
                    <td><span class="gray">图片尺寸建议为600x800，限制大小1M</span></td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <input type="text" id="common_pic2" name="imgUrls" value="" onkeyup="delLink(this)" style="width: 145px;vertical-align: top;margin-right:20px"/>
                        <input class="buttoncenter" type="button" value="${internationalConfig.上传文件}" id="common_upload_btn2" style="margin-top:2px;margin-right:30px;"/>
                        <span id="see_pic2" style="vertical-align: top;"><a class="link_img" style="vertical-align: top;margin-left: 20px;" href="javascript:;" target="_blank">查看图片</a></span>
                    </td>
                    <td><span class="gray">图片尺寸建议为600x800，限制大小1M</span></td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <input type="text" id="common_pic3" name="imgUrls" value="" onkeyup="delLink(this)" style="width: 145px;vertical-align: top;margin-right:20px"/>
                        <input class="buttoncenter" type="button" value="${internationalConfig.上传文件}" id="common_upload_btn3" style="margin-top:2px;margin-right:30px;"/>
                        <span id="see_pic3" style="vertical-align: top;"><a class="link_img" style="vertical-align: top;margin-left: 20px;" href="javascript:;" target="_blank">查看图片</a></span>
                    </td>
                    <td><span class="gray">图片尺寸建议为600x800，限制大小1M</span></td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <input type="text" id="common_pic4" name="imgUrls" value="" onkeyup="delLink(this)" style="width: 145px;vertical-align: top;margin-right:20px"/>
                        <input class="buttoncenter" type="button" value="${internationalConfig.上传文件}" id="common_upload_btn4" style="margin-top:2px;margin-right:30px;"/>
                        <span id="see_pic4" style="vertical-align: top;"><a class="link_img" style="vertical-align: top;margin-left: 20px;" href="javascript:;" target="_blank">查看图片</a></span>
                    </td>
                    <td><span class="gray">图片尺寸建议为600x800，限制大小1M</span></td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <input type="text" id="common_pic5" name="imgUrls" value="" onkeyup="delLink(this)" style="width: 145px;vertical-align: top;margin-right:20px"/>
                        <input class="buttoncenter" type="button" value="${internationalConfig.上传文件}" id="common_upload_btn5" style="margin-top:2px;margin-right:30px;"/>
                        <span id="see_pic5" style="vertical-align: top;"><a class="link_img" style="vertical-align: top;margin-left: 20px;" href="javascript:;" target="_blank">查看图片</a></span>
                    </td>
                    <td><span class="gray">图片尺寸建议为600x800，限制大小1M</span></td>
                </tr>
            </table>
            <button class="save-btn hide_btn" onclick="saveTab(event)">${internationalConfig.保存}</button>
            <button class="close-btn hide_btn" onclick="cancelEditSj(this,event,'edit_mes_btn')">${internationalConfig.取消}</button>
        </form>

        <p class="title">2.商户信息<button class="edit-btn" onclick="newSjMes()">新增商户信息</button></p>

        <div class="sj_list">
            <c:if test="${empty skuVendors}">
                <form class="sj_form" style="padding-bottom: 20px;">
                    <input type="hidden" name="id" value=""/>
                    <table style="background: #f5f5f5;">
                        <tr style="border-bottom: 1px dashed #ddd;">
                            <td><b style="color: red">*</b><span class="name-span">商户<i class="vendor_num">1</i></span></td>
                            <td colspan="2" style="text-align: right;">
                                <a class="edit-btn show_btn" onclick="editSku(this,event)">${internationalConfig.编辑}</a>
                                <a class="edit-btn hide_btn" onclick="deleteSj(this,event)">删除</a>
                            </td>
                        </tr>
                        <tr>
                            <td><b style="color: red">*</b><span class="name-span">所属商户</span></td>
                            <td>
                                <select name="vendorId" class="vendor easyui-validatebox" data-options="validType:'selectRequire'">
                                    <option value="-1">请选择</option>
                                    <c:forEach var="vendor" items="${vendorList}">
                                        <option value="${vendor.id}">${vendor.name}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <td><span class="gray">请选择相关的商户信息，如“乐视影业”</span></td>
                        </tr>
                        <tr>
                            <td><b style="color: red">*</b><span class="name-span">商户商品类型</span></td>
                            <td>
                                <select name="productType" class="margin5">
                                    <option value="100">会员</option>
                                </select>
                            </td>
                            <td>
                                <span class="gray">请选择符合的商户商品类型，如”会员”</span>
                                    <%--<span class="gray">请填写商户符合的商品类型ID，填写规范<a href="javascript:;" onclick="detail()">详见</a></span>--%>
                            </td>
                        </tr>
                        <tr>
                            <td><b style="color: red">*</b><span class="name-span">商户商品ID</span></td>
                            <td><input type="text" name="productNo" value="" class="easyui-validatebox" data-options="required:true,validType:'maxLength[60]'"/></td>
                            <td><span class="gray">请填写在各商户BOSS系统中符合的商品ID，如“超级影视会员ID”</span></td>
                        </tr>
                        <tr>
                            <td><b style="color: red">*</b><span class="name-span">物料编码</span></td>
                            <td><input type="text" name="productItemCode" value="" class="easyui-validatebox" data-options="required:false,validType:'maxLength[60]'"/></td>
                            <td><span class="gray">从ERP系统申请,收款方为致新时不能为空</span></td>
                        </tr>
                        <tr>
                            <td><b style="color: red">*</b><span class="name-span">物料收款价格</span></td>
                            <td><input type="text" name="productItemPrice" value="" class="easyui-validatebox" data-options="required:false,validType:'length[0,9]'" onblur="returnFloatOrNull(this)" onkeyup="value=value.replace(/[^\d.]/g,'')"/></td>
                            <td><span class="gray">收款方为致新时不能为空</span></td>
                        </tr>
                        <tr>
                            <td><b style="color: red">*</b><span class="name-span">成本价格</span></td>
                            <td><input type="text" name="costPrice" value="" class="easyui-validatebox" data-options="required:false,validType:'length[0,9]'" onblur="returnFloatOrNull(this)" onkeyup="value=value.replace(/[^\d.]/g,'')"/></td>
                            <td><span class="gray">收款方为致新时不能为空</span></td>
                        </tr>
                        <tr>
                            <td><b style="color: red">*</b><span class="name-span">服务时长</span></td>
                            <td>
                                <input type="text" name="duration" value="" class="easyui-validatebox margin5" precision="0" onkeyup='this.value=this.value.replace(/\D/gi,"")' data-options="required:true,validType:'length[0,9]'"/>
                                <select name="durationType" class="margin5" style="width: 50px;padding: 0;">
                                    <option value="1">年</option>
                                    <option value="2">月</option>
                                    <option value="5">日</option>
                                </select>
                            </td>
                            <td><span class="gray">请填写商品服务期限，如会员则填写匹配的会员时长</span></td>
                        </tr>
                        <tr>
                            <td><b style="color: red">*</b><span class="name-span">价格</span></td>
                            <td><input type="text" name="productPrice" value="" class="easyui-validatebox margin5"
                                       data-options="required:true,validType:'length[0,9]'"
                                       onkeyup='this.value=this.value.replace(/[^\d.]/gi,"")'/>元
                            </td>
                            <td><span class="gray">商户服务针对该SKU实际售卖价格，不能大于sku售卖价格</span></td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <button class="save-btn hide_btn" onclick="saveSj(this,event)">${internationalConfig.保存}</button>
                                <button class="close-btn hide_btn" onclick="cancelEditSj(this,event)">${internationalConfig.取消}</button>
                            </td>
                        </tr>
                    </table>

                </form>
            </c:if>
            <c:forEach var="skuVendors" items="${skuVendors}" varStatus="loop">
                <form class="sj_form" style="padding-bottom: 20px;">
                    <input type="hidden" name="id" value="${skuVendors.id}"/>
                    <table style="background: #f5f5f5;">
                        <tr style="border-bottom: 1px dashed #ddd;">
                            <td><b style="color: red">*</b><span class="name-span">商户<i
                                    class="vendor_num">${loop.index+1}</i></span></td>
                            <td colspan="2" style="text-align: right;">
                                <a class="edit-btn show_btn" onclick="editSku(this,event)">${internationalConfig.编辑}</a>
                                <a class="edit-btn hide_btn" onclick="deleteSj(this,event)">删除</a>
                            </td>
                        </tr>
                        <tr>
                            <td><b style="color: red">*</b><span class="name-span">所属商户</span></td>
                            <td>
                                <select name="vendorId" class="vendor easyui-validatebox"
                                        data-options="validType:'selectRequire'">
                                    <option value="-1">请选择</option>
                                    <c:forEach var="vendor" items="${vendorList}">
                                        <option value="${vendor.id}"
                                                <c:if test="${vendor.id==skuVendors.vendorId}">selected</c:if>>${vendor.name}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <td><span class="gray">请选择相关的商户信息，如“乐视影业”</span></td>
                        </tr>
                        <tr>
                            <td><b style="color: red">*</b><span class="name-span">商户商品类型</span></td>
                            <td>
                                <select name="productType" class="margin5">
                                    <option value="100"
                                            <c:if test="${skuVendors.vendorProductType==100}">selected</c:if>>会员
                                    </option>
                                </select>
                            </td>
                            <td>
                                <span class="gray">请选择符合的商户商品类型，如”会员”</span>
                                    <%--<span class="gray">请填写商户符合的商品类型ID，填写规范<a href="javascript:;" onclick="detail()">详见</a></span>--%>
                            </td>
                        </tr>
                        <tr>
                            <td><b style="color: red">*</b><span class="name-span">商户商品ID</span></td>
                            <td><input type="text" name="productNo" value="${skuVendors.vendorProductNo}"
                                       class="easyui-validatebox"
                                       data-options="required:true,validType:'maxLength[60]'"/></td>
                            <td><span class="gray">请填写在各商户BOSS系统中符合的商品ID，如“超级影视会员ID”</span></td>
                        </tr>
                        <tr>
                            <td><b style="color: red">*</b><span class="name-span">物料编码</span></td>
                            <td><input type="text" name="productItemCode" value="${skuVendors.productItemCode}"
                                       class="easyui-validatebox"
                                       data-options="required:false,validType:'maxLength[60]'"/></td>
                            <td><span class="gray">从ERP系统申请,收款方为致新时不能为空</span></td>
                        </tr>
                        <tr>
                            <td><b style="color: red">*</b><span class="name-span">物料收款价格</span></td>
                            <td><input type="text" name="productItemPrice" value="${skuVendors.productItemPrice}"
                                       class="easyui-validatebox" data-options="required:false,validType:'length[0,9]'"
                                       onblur="returnFloatOrNull(this)" onkeyup="value=value.replace(/[^\d.]/g,'')"/>
                            </td>
                            <td><span class="gray">收款方为致新时不能为空</span></td>
                        </tr>
                        <tr>
                            <td><b style="color: red">*</b><span class="name-span">成本价格</span></td>
                            <td><input type="text" name="costPrice" value="${skuVendors.costPrice}"
                                       class="easyui-validatebox" data-options="required:false,validType:'length[0,9]'"
                                       onblur="returnFloatOrNull(this)" onkeyup="value=value.replace(/[^\d.]/g,'')"/>
                            </td>
                            <td><span class="gray">收款方为致新时不能为空</span></td>
                        </tr>
                        <tr>
                            <td><b style="color: red">*</b><span class="name-span">服务时长</span></td>
                            <td>
                                <input type="text" name="duration" value="${skuVendors.vendorProductDuration}"
                                       class="easyui-validatebox margin5" precision="0"
                                       onkeyup='this.value=this.value.replace(/\D/gi,"")'
                                       data-options="required:true,validType:'length[0,9]'"/>
                                <select name="durationType" class="margin5" style="width: 50px;padding: 0;">
                                    <option value="1"
                                            <c:if test="${skuVendors.vendorProductDurationType==1}">selected</c:if>>年
                                    </option>
                                    <option value="2"
                                            <c:if test="${skuVendors.vendorProductDurationType==2}">selected</c:if>>月
                                    </option>
                                    <option value="5"
                                            <c:if test="${skuVendors.vendorProductDurationType==5}">selected</c:if>>日
                                    </option>
                                </select>
                            </td>
                            <td><span class="gray">请填写商品服务期限，如会员则填写匹配的会员时长</span></td>
                        </tr>
                        <tr>
                            <td><b style="color: red">*</b><span class="name-span">价格</span></td>
                            <td><input type="text" name="productPrice" value="${skuVendors.productPrice}"
                                       class="easyui-validatebox margin5"
                                       onkeyup='this.value=this.value.replace(/[^\d.]/gi,"")'
                                       data-options="required:true,validType:'length[0,9]'"/>元
                            </td>
                            <td><span class="gray">商户服务针对该SKU实际售卖价格，不能大于sku售卖价格</span></td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <button class="save-btn hide_btn"
                                        onclick="saveSj(this,event)">${internationalConfig.保存}</button>
                                <button class="close-btn hide_btn"
                                        onclick="cancelEditSj(this,event)">${internationalConfig.取消}</button>
                            </td>
                        </tr>
                    </table>

                </form>
            </c:forEach>
        </div>

    </div>

    <div class="cont2">
        <button class="save-btn" onclick="closeTab()">${internationalConfig.关闭}</button>
    </div>
    <%--<div id="detail" class="easyui-dialog detail" title="商户商品类型说明" style="width:500px;height:510px;padding: 10px" data-options="iconCls:'icon-save',resizable:true,modal:true" closed="true" >
        <p><b>1.乐视集团内商户：</b><br>如乐视体育、乐视影视等，请按照如下说明填写商品ID</p>
        <p>例如：<span>商户商品类型</span><input type="text" value="100"/></p>
        <table border="1">
            <tr><th>商品类型</th><th>商品ID</th><th>备注</th></tr>
            <tr><td>会员</td><td>100</td><td></td></tr>
            <tr><td>直播券</td><td>200</td><td></td></tr>
            <tr><td>专辑</td><td>1</td><td>用于单片点播</td></tr>
            <tr><td>轮播台</td><td>2</td><td></td></tr>
            <tr><td>视频</td><td>3</td><td>用于单片点播</td></tr>
            <tr><td>直播场次</td><td>4</td><td>用于单场直播</td></tr>
            <tr><td>直播赛事</td><td>5</td><td>用于赛事直播</td></tr>
        </table>
        <p><b>2.乐视集团外商户：</b><br>如国广、华数等，请从各商户处获取制定商品类型ID，如实填写。</p>
        <p>备注：后期可考虑各商户提供商品类型接口，系统转译为商品类型文字，便于运营人员直接选择。</p>
    </div>--%>
</div>
<script>
    $.extend($.fn.validatebox.defaults.rules, {
        maxLength: {
            validator: function(value, param){
                var length = value.replace(/[\u0391-\uFFE5]/g,"aa").length;
                return param[0] >= length;
            },
            message: '不得超过{0}个字符'
        },
        selectRequire: {
            validator: function (value, param) {
                if(value=="-1"){
                    return false;
                }else{
                    return true;
                }
            },
            message: '${internationalConfig.请选择}'
        }
    });
    (function($) {
        if($("#skuId").val()==''){
            $(".edit_mes_btn").hide();
            $(".hide_btn").show();
            $(".link_img").hide();
            $(".show_btn").hide();
        }else{
            if('${sku.isOnline}'==2){
                $(".edit-btn").hide();
            }
            getPicList();
            $("input,select,textarea").attr("disabled",true);
        }

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

        initPosterButton();
    })(jQuery)
    function addZero(data){
        if(parseInt(data)<10){
            return "0"+data;
        }else{
            return data;
        }
    }
    //编辑时获取图片列表
    function getPicList() {
        $(".link_img").hide();
        var picList = "${sku.imgUrls}";
        var links = picList.split(",");
        for(var i=0;i<links.length;i++){
            $($("input[name=imgUrls]")[i]).val(links[i]);
            if(links[i]) {
                $($(".link_img")[i]).show().attr("href", links[i]);
            }
        }
    }
    //保存编辑页上部信息
    function saveTab(e) {
        e.preventDefault();
        if ($("#sku_form").form("validate")) {
            if ($("#sku_form").form("validate")) {
                parent.$.messager.progress({
                    title : '${internationalConfig.提示}',
                    text : '${internationalConfig.数据处理中}....'
                });
                var noPic = true;
                var imgUrls = $("input[name='imgUrls']");
                for(var i=0;i<imgUrls.length;i++){
                    if(imgUrls[i].value!=''){
                        noPic = false;
                    }
                }
                if(noPic==true){
                    parent.$.messager.progress('close');
                    parent.$.messager.alert('${internationalConfig.提示}','至少上传一张商品图片','info');
                    return false;
                }
                var url = "";
                if($("#skuId").val()==''){
                    url="/mini/sku/add";   //保存链接
                }else{
                    url="/mini/sku/editSku";   //保存链接
                }
                $.ajax({
                    url : url,   //保存链接
                    type : "post",
                    data : $("#sku_form").serializeJson(),
                    dataType : "json",
                    success : function(result) {
                        parent.$.messager.progress('close');
                        if (result.code == 0) {
                            parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.保存成功}', 'success');
                            if(result.data) {
                                var backData = JSON.parse(result.data);
                                if($("#skuId").val()=='') {
                                    $("#skuId").val(backData.id);
                                    $("#skuNo").val(backData.skuNo);
                                }
                            }
                            formDisable('sku_form',0);
                            if(parent.refreshDataGrid.skuDataGrid) {
                                parent.refreshDataGrid.skuDataGrid.datagrid('reload');
                            }
                            $("#sku_form").find(".hide_btn").show();
                            $("#sku_form").find(".show_btn").hide();
                            $("#sku_form .hide_btn").hide();
                            $(".edit-btn").show();
                        } else {
                            parent.$.messager.alert('${internationalConfig.错误}', '<div style="word-break:break-all;">'+result.msg+'</div>', 'error');
                        }
                    }
                })
            }
        }
    }

    //保存商户
    function saveSj(that,e) {
        e.preventDefault();
        var sjForm = $(that).parents("form")
        if (sjForm.form("validate")) {
            parent.$.messager.progress({
                title : '${internationalConfig.提示}',
                text : '${internationalConfig.数据处理中}....'
            });
            var sjFormData = sjForm.serializeJson();
            if($("#skuId").val()==''){
                parent.$.messager.progress('close');
                parent.$.messager.alert('${internationalConfig.提示}','请先保存商品信息','info');
                return false;
            }

            sjFormData.skuId = $("#skuId").val();
            var url = "";
            var vendorMapId = sjForm.find('input[name="id"]').val();
            if (vendorMapId=='') {
                url="/mini/sku/addVendorMap";
            }else{
                url="/mini/sku/editSkuVendorMap";
            }
            $.ajax({
                url : url,   //保存链接
                type : "post",
                data : sjFormData,
                dataType : "json",
                success : function(result) {
                    parent.$.messager.progress('close');
                    if (result.code == 0) {
                        if(result.data){
                            $(that).parents('form').find('input[name="id"]').val(result.data);
                        }
                        parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.保存成功}', 'success');
                        $(that).parents("form").find(".hide_btn").hide();
                        $(that).parents("form").find(".show_btn").show();
                        formDisable(that,0);
                    } else {
                        parent.$.messager.alert('${internationalConfig.错误}', '<div style="word-break:break-all;">'+result.msg+'</div>', 'error');
                    }
                }
            })
        }
    }
    //图片删除时，去掉后面的link
    function delLink(that){
        if(that.value==""){
            $(that).parent('td').find('.link_img').remove();
        }
    }
    function closeTab(){
        parent.$('.tabs .tabs-selected .tabs-close').trigger("click");
    }
    //编辑
    function editSku(ele,e,that) {
        formDisable(ele,1);
        if((typeof ele)=="string"){
            $("#"+ele).find(".hide_btn").show();
            $(".edit_mes_btn").hide();
        }else{
            var form = $(ele).parents("form")
            if(form.find('input[name="id"]').val()){
                form.find(".vendor").attr("disabled",true);
            }
            form.find(".hide_btn").show();
            form.find(".show_btn").hide();
            form.find('input[name="vendorId"]').validatebox({validType:'selectRequire'});
            form.find('input[name="productNo"]').validatebox({required:true,validType:'length[0,60]'});
            form.find('input[name="duration"]').validatebox({required:true,validType:'length[0,9]'});
            form.find('input[name="productPrice"]').validatebox({required: true, validType: 'length[0,9]'});
        }
        e.preventDefault();
    }
    //新增商户信息
    function newSjMes() {
        var num = $(".vendor_num:last").html();
        if($(".sj_form").length>=5){
            parent.$.messager.alert('${internationalConfig.提示}','最多添加5个商户','info');
            return false;
        }
        num = num?parseInt(num)+1:1;
        var form = '<form class="sj_form" style="padding-bottom: 20px;">'+
            '<input type="hidden" name="id" value=""/>' +
            //'<input type="hidden" name="vendorId" value=""/>'+
            '<table style="background: #f5f5f5;">' +
            '<tr style="border-bottom: 1px dashed #ddd;">' +
            '<td><b style="color: red">*</b><span class="name-span">商户<i class="vendor_num">' + num + '</i></span></td>' +
            '<td colspan="2" style="text-align: right;"><a class="edit-btn show_btn" onclick="editSku(this,event)">${internationalConfig.编辑}</a>' +
            '<a class="edit-btn hide_btn" onclick="deleteSj(this,event)">删除</a></td></tr>' +
            '<tr><td><b style="color: red">*</b><span class="name-span">所属商户</span></td>' +
            '<td><select name="vendorId" class="vendor easyui-validatebox"><option value="-1">请选择</option><c:forEach var="vendor" items="${vendorList}">' +
            '<option value="${vendor.id}">${vendor.name}</option>' +
            '</c:forEach></select></td>' +
            '<td><span class="gray">请选择相关的商户信息，如“乐视影业”</span></td></tr>' +
            '<tr><td><b style="color: red">*</b><span class="name-span">商户商品类型</span></td>' +
            '<td><select name="productType" class="margin5"> <option value="100">会员</option> </select></td>' +
            '<td><span class="gray">请选择符合的商户商品类型，如”会员”</span></td></tr>' +
            '<tr><td><b style="color: red">*</b><span class="name-span">商户商品ID</span></td>' +
            '<td><input type="text" name="productNo" value="" class="easyui-validatebox"/></td>' +
            '<td><span class="gray">请填写在各商户BOSS系统中符合的商品ID，如“超级影视会员ID”</span></td></tr>' +
            '<tr><td><b style="color: red">*</b><span class="name-span">物料编码</span></td>' +
            '<td><input type="text" name="productItemCode" value="" class="easyui-validatebox" data-options="required:false,validType:\'maxLength[60]\'"/></td>' +
            '<td><span class="gray">从ERP系统申请,收款方为致新时不能为空</span></td></tr>' +
            '<tr><td><b style="color: red">*</b><span class="name-span">物料收款价格</span></td>' +
            '<td><input type="text" name="productItemPrice" value="" class="easyui-validatebox" data-options="required:false,validType:\'length[0,9]\'" onblur="returnFloatOrNull(this)" onkeyup="value=value.replace(/[^\\d.]/g,\'\')"/></td>' +
            '<td><span class="gray">收款方为致新时不能为空</span></td></tr>' +
            '<tr><td><b style="color: red">*</b><span class="name-span">成本价格</span></td>' +
            '<td><input type="text" name="costPrice" value="" class="easyui-validatebox" data-options="required:false,validType:\'length[0,9]\'" onblur="returnFloatOrNull(this)" onkeyup="value=value.replace(/[^\\d.]/g,\'\')"/></td>' +
            '<td><span class="gray">收款方为致新时不能为空</span></td></tr>' +
            '<tr><td><b style="color: red">*</b><span class="name-span">服务时长</span></td>' +
            '<td><input type="text" name="duration" value="" class="easyui-validatebox margin5" precision="0" data-options="required:true,validType:\'length[0,9]\'"/>' +
            '<select  name="durationType" class="margin5" style="width: 50px;padding: 0;"><option value="1">年</option><option value="2">月</option><option value="5">日</option></select></td>' +
            '<td><span class="gray">请填写商品服务期限，如会员则填写匹配的会员时长</span></td></tr>' +
            '<tr><td><b style="color: red">*</b><span class="name-span">价格</span></td>' +
            '<td><input type="text" name="productPrice" value="" class="easyui-validatebox margin5" data-options="required:true,validType:\'length[0,9]\'"/>元</td>' +
            '<td><span class="gray">商户服务针对该SKU实际售卖价格，不能大于sku售卖价格</span></td></tr>' +
            '<tr><td colspan="3">' +
            '<button class="save-btn hide_btn" onclick="saveSj(this,event)">${internationalConfig.保存}</button>' +
            '<button class="close-btn hide_btn" onclick="cancelEditSj(this,event)">${internationalConfig.取消}</button></td></tr>' +
            '</table></form>';

        //var template = $(".sj_form").prop("outerHTML");
        $(".sj_list").append(form);
        $(".sj_form:last input[name='duration']").keyup(function () {
            this.value=this.value.replace(/\D/gi,"")
        });
        $(".sj_form:last input[name='productPrice']").keyup(function () {
            this.value = this.value.replace(/[^\d.]/gi, "")
        });
        $(".sj_form:last").find(".show_btn").hide();
        $(".sj_form:last").find(".hide_btn").show();
        $('.sj_form:last select[name="vendorId"]').validatebox({required:true,validType:'selectRequire'});
        $('.sj_form:last input[name="productNo"]').validatebox({required:true,validType:'length[0,60]'});
        $('.sj_form:last input[name="duration"]').validatebox({required:true,validType:'length[0,9]'});
        $('.sj_form:last input[name="productPrice"]').validatebox({required: true, validType: 'length[0,9]'});



    }
    //取消编辑商户
    function cancelEditSj(that,e,edtiMsgbtn) {
        e.preventDefault();
        if(edtiMsgbtn){
            $("."+edtiMsgbtn).show();
        }
        $(that).parents("form").find(".hide_btn").hide();
        $(that).parents("form").find(".show_btn").show();
        formDisable(that,0);
        if(parent.refreshDataGrid.skuDataGrid) {
            parent.refreshDataGrid.skuDataGrid.datagrid('reload');
        }
    }
    //删除商户
    function deleteSj(that,e) {
        e.preventDefault();
        if($(".sj_form").length>1){ //商户数量大于一个时
            var vendorMapId = $(that).parents('form').find('input[name="id"]').val();
            if (vendorMapId){
                parent.$.messager.confirm('${internationalConfig.询问}', '是否确认删除当前商户？',
                    function (b) {
                        if (b) {
                            parent.$.messager.progress({
                                title: '${internationalConfig.提示}',
                                text: '${internationalConfig.数据处理中}....'
                            });
                            $.post('/mini/sku/deleteSkuVendorMap', {id: vendorMapId},
                                function (result) {
                                    if (result.code == 0) {
                                        parent.$.messager.alert('${internationalConfig.提示}', '${internationalConfig.删除成功}', 'info');
                                        $(that).parents("form").remove();
                                        var vendorNum = $(".vendor_num");
                                        for (var i = 0; i < vendorNum.length; i++) {
                                            vendorNum[i].innerText = i + 1;
                                        }
                                    } else {
                                        parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
                                    }
                                    parent.$.messager.progress('close');
                                }, 'JSON');
                        }
                    });
            }else{
                $(that).parents("form").remove();
            }
        }else{
            parent.$.messager.alert('${internationalConfig.提示}', '至少保证关联一个商户', 'info');
        }
    }
    //设置form编辑状态
    function formDisable(that,isEdit) {
        if(isEdit){
            if((typeof that)=="string"){
                $("#"+that).find("input,select,textarea").attr("disabled",false);
            }else{
                $(that).parents("form").find("input,select,textarea").attr("disabled",false);
            }
        }else{
            if((typeof that)=="string"){
                $("#"+that).find("input,select,textarea").attr("disabled",true);
            }else{
                $(that).parents("form").find("input,select,textarea").attr("disabled",true);
            }
        }

    }
    function detail(){
        //$("#detail input").attr("disabled",false);
        $("#detail").dialog('open');
        //$('#detail').window('center');
    }
    function newCommonUploadBtn(buttonId,inputId,previewId){
        new SWFUpload({
            button_placeholder_id: buttonId,
            flash_url: "/static/lib/swfupload/swfupload.swf?rt=" + Math.random(),
            upload_url: '/upload?cdn=sync',
            button_image_url: Boss.util.defaults.upload.button_image,
            button_cursor: SWFUpload.CURSOR.HAND,
            button_action: SWFUpload.BUTTON_ACTION.SELECT_FILE,
            file_size_limit: '1 MB',
            button_width: "61",
            button_height: "24",
            file_post_name: "myfile",
            file_types: "*.jpg;*.jpeg;*.png;*.bmp;*.gif",
            file_types_description: "All Image Files",
            button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
            upload_start_handler: function () {
            },
            upload_success_handler: function (file, response) {
                if (response.indexOf("http")!=0){
                    alert("${internationalConfig.上传失败请稍后重试}");
                    return;
                }
                if (previewId) {
                    var HTML_VIEWS = '<a style="margin-left: 20px;" href="' + response + '" target="_blank">${internationalConfig.查看图片}</a>';
                    $("#" + previewId).html(HTML_VIEWS);
                }
                $("#"+inputId).val(response);
            },
            file_queued_handler: function () {
                this.startUpload();
            },
            file_queue_error_handler:function(file){
                if(file.size>=1048576){
                    parent.$.messager.alert('${internationalConfig.提示}', '文件不得大于1MB，请重新上传', 'info');
                }
            },
            upload_error_handler: function (file, code, msg) {
                var message = '${internationalConfig.UploadFailed}' + code + ': ' + msg + ', ' + file.name;
                alert(message);
            }
        });
    }
    function initPosterButton(){
        for (var i = 1;i <= 5; i++){
            newCommonUploadBtn("common_upload_btn"+i, "common_pic"+i, "see_pic"+i);
        }
    }
    function returnFloat(that){
        var value = that.value;
        if(value!=""){
            var value=Math.round(parseFloat(value)*100)/100;
            that.value = value.toFixed(2);
        }else{
            that.value = '0.00';
        }
    }
    function returnFloatOrNull(that){
        var value = that.value;
        if(value!=""){
            var value=Math.round(parseFloat(value)*100)/100;
            that.value = value.toFixed(2);
        }else{
            that.value = null;
        }
    }
</script>
</body>
</html>

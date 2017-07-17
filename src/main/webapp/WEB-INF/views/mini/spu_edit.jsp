<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/inc/jstl.inc"%>
<!DOCTYPE html>
<html>
<head>
    <title>新增spu</title>
    <script src="/static/lib/swfupload/swfupload.js" type="text/javascript" charset="utf-8"></script>
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
    <script type="text/javascript">
        /* <m:auth uri="/consume/open">
         $.canOpen = true;
        </m:auth> */
        <m:auth uri="/consume/close">
        $.canClose = true;
        </m:auth>
        <m:auth uri="/consume/refund.do">
        $.canRefund = true;
        </m:auth>
    </script>
    <style>
        .textbox-addon{margin:4px 0}
        .cont1{width:100%;}
        .cont2{margin:0 20px;padding:14px 20px;color:#444;position: relative;font-size: 12px;}
        .cont2:last-child{border-bottom:0px dashed #aaa;}
        .title{margin-bottom: 10px;font-weight: bold;text-decoration: underline;}
        form td{height: 30px;padding: 10px 0;}
        td input{width: 300px;height: 25px;padding: 1px 10px;}
        td select{width: 220px;height: 30px;padding: 1px 10px;margin-right:5px;}
        td textarea{width: 292px;height: 80px;padding: 1px 10px;margin-right:25px;}
        td .margin5{margin-right: 5px;}
        .name-span{float: none;margin-left: 10px;}
        table b{padding-left: 10px;}
        table tr td span{margin-right: 10px;display: inline-block;float: none;}
        table tr td input{margin-right: 30px;}
        .val-span{min-width:100px;color:#777;float: none;}
        .attention{color:#f00;float:left;margin-top: 54px;}
        .edit-btn{margin: 0 0 0 60px;padding: 2px 6px;}
        .close-btn{margin: 20px 0 0 60px;padding: 2px 6px;}
        .save-btn{margin: 20px 0 0 450px;padding: 2px 6px;}
        .gray{color: gray;}
        .hide_btn{display: none;}
        .attr-table{background: #f5f5f5;padding: 10px;width: 800px;}
        .attr-table th{padding: 10px;border-bottom: 1px solid #ddd;}
        .attr-table td{padding: 10px;border-bottom: 1px dashed #ddd;}
        .attr-table tr:last-child td{border-bottom: 0;}
        .chose_btn{float: right;padding: 2px 6px;}
        .selecked_list{margin-top:20px;width: 820px;}
        .select_title{background: #ddd;height: 30px;line-height: 30px;padding-left: 10px;}
        .select_title span{color: #0088CC;}
        #attr_form input[type="checkbox"]{margin-left:5px;}

    </style>
</head>
<body>
<div class="cont1 easyui-tabs" id="tabs">
    <div class="cont2" title="SPU基本信息" id="tabs-1"  data-options="selected:true">
        <form id="sku_form" class="mini_form" name="sku_form" style="padding-bottom: 20px;">
            <input type="hidden" id="spu_id" name="spuId" value="${spu.id}"/>
            <table>
                <tr>
                    <td width="120"><b style="color: red">*</b><span class="name-span">SPU品类：</span></td>
                    <td colspan="2">
                    <c:if test="${not empty spu.id}">
                        <select class="category1" disabled>
                            <option value="">${spu.category1Name}</option>
                        </select>
                        <select class="category2" disabled>
                            <option value="">${spu.category2Name}</option>
                        </select>
                        <select class="category3" disabled>
                            <option value="${spu.categoryId}">${spu.category3Name}</option>
                        </select>
                    </c:if>
                    <c:if test="${empty spu.id}">
                        <select class="category1 easyui-validatebox" data-options="validType:'selectRequire'">
                            <option value="-1">${internationalConfig.请选择}</option>
                            <c:forEach var="category" items="${categoryList}">
                                <option value="${category.id}"> ${category.name}</option>
                            </c:forEach>
                        </select>
                        <select class="category2 easyui-validatebox" data-options="validType:'selectRequire'">
                            <option value="-1">请选择</option>
                        </select>
                        <select class="category3 easyui-validatebox" data-options="validType:'selectRequire'">
                            <option value="-1">请选择</option>
                        </select>
                    </c:if>
                        <span class="gray" style="padding-left: 20px">SPU只能与三级品类关联</span>
                    </td>
                </td>
                </tr>
                <tr>
                    <td><b style="color: red">*</b><span class="name-span">SPU名称</span></td>
                    <td width="350"><input type="text" name="name" value="${spu.name}" class="easyui-validatebox" data-options="required:true,validType:'maxLength[40]'"/></td>
                    <td><span class="gray">不得超过20个汉字或40个字符</span></td>
                </tr>
                <tr>
                    <td><b style="color: red">*</b><span class="name-span">副标题</span></td>
                    <td><input type="text" name="title" value="${spu.title}" class="easyui-validatebox" data-options="required:true,validType:'maxLength[40]'"/></td>
                    <td><span class="gray">不得超过20个汉字，或40个字符</span></td>
                </tr>
                <tr>
                    <td><b style="color: red">*</b><span class="name-span">SPU价格</span></td>
                    <td><input type="text" name="price" value="${spu.price}" class="easyui-validatebox easyui-numberbox margin5"  precision="2" data-options="required:true"/> 元</td>
                    <td><span class="gray">仅限填写数字，单位为“元”</span></td>
                </tr>
                <tr>
                    <td><b style="color: red">*</b><span class="name-span">是否含实物赠品</span></td>
                    <td>
                        <input type="radio" name="isEntityBundle" style="margin: 0 3px 0 10px" value="2"<c:if test="${spu.isEntityBundle=='2'}">checked</c:if>/>是
                        <input type="radio" name="isEntityBundle" style="margin: 0 3px 0 20px" value="1"<c:if test="${spu.isEntityBundle=='1'}">checked</c:if>/>否
                    </td>
                    <td><span class="gray">如售卖商品为搭配或买赠模式，则需要标注</span></td>
                </tr>
                <tr>
                    <td><b style="color: red">*</b><span class="name-span">二维码链接</span></td>
                    <td><input type="text" name="qrcodeUrl" value="${spu.qrcodeUrl}" class="easyui-validatebox" data-options="validType:'isUrl'"/></td>
                    <td><span class="gray">在CMS系统生成</span></td>
                </tr>
                <tr style="display: none">
                    <td><b> </b><span class="name-span">最低购买数量</span></td>
                    <td><input type="text" name="minPurchaseCnt" value="${spu.minPurchaseCnt}" class="easyui-validatebox easyui-numberbox" precision="0" data-options="validType:'length[0,9]'"/></td>
                    <td><span class="gray">仅限填写数字</span></td>
                </tr>
                <tr style="display: none">
                    <td><b> </b><span class="name-span">最高购买数量</span></td>
                    <td><input type="text" name="maxPurchaseCnt" value="${spu.maxPurchaseCnt}" class="easyui-validatebox easyui-numberbox" precision="0" data-options="validType:'length[0,9]'"/></td>
                    <td><span class="gray">仅限填写数字</span></td>
                </tr>
                <tr style="display: none">
                    <td><b> </b><span class="name-span">可售时间</span></td>
                    <td>
                        <input name="saleTimeStart" class="easyui-datebox span2" value="${spu.saleTimeStartStr}">—
                        <input name="saleTimeEnd" class="easyui-datebox span2" value="${spu.saleTimeEndStr}">
                    </td>
                    <td><span class="gray">开始时间不得晚于截止时间</span></td>
                </tr>
                <tr>
                    <td><b style="color: red">*</b><span class="name-span">销售平台</span></td>
                    <td>
                        <c:if test="${spu.salePlatform=='1000000000'}">
                            <input type="checkbox" name="salePlatform" class="easyui-validatebox" validType="mastcheck['sku_form','salePlatform']" value="1000000000" checked/>乐视国广
                            <input type="checkbox" name="salePlatform" class="easyui-validatebox" validType="mastcheck['sku_form','salePlatform']" style="margin-left:5px;" value="0100000000"/>乐视华数
                        </c:if>
                        <c:if test="${spu.salePlatform=='0100000000'}">
                            <input type="checkbox" name="salePlatform" class="easyui-validatebox" validType="mastcheck['sku_form','salePlatform']" value="1000000000"/>乐视国广
                            <input type="checkbox" name="salePlatform" class="easyui-validatebox" validType="mastcheck['sku_form','salePlatform']" style="margin-left:5px;" value="0100000000" checked/>乐视华数
                        </c:if>
                        <c:if test="${spu.salePlatform=='1100000000'}">
                            <input type="checkbox" name="salePlatform" class="easyui-validatebox" validType="mastcheck['sku_form','salePlatform']" value="1000000000" checked/>乐视国广
                            <input type="checkbox" name="salePlatform" class="easyui-validatebox" validType="mastcheck['sku_form','salePlatform']" style="margin-left:5px;" value="0100000000" checked/>乐视华数
                        </c:if>

                        <c:if test="${spu.salePlatform=='0' || spu.salePlatform=='0000000000'}">
                            <input type="checkbox" name="salePlatform" class="easyui-validatebox" validType="mastcheck['sku_form','salePlatform']" value="1000000000"/>乐视国广
                            <input type="checkbox" name="salePlatform" class="easyui-validatebox" validType="mastcheck['sku_form','salePlatform']" style="margin-left:5px;" value="0100000000"/>乐视华数
                        </c:if>
                    </td>
                    <td><span class="gray"></span></td>
                </tr>
                <tr>
                    <td><b> </b><span class="name-span">SPU列表图</span></td>
                    <td>
                        <input type="text" id="common_pic1" name="imgUrls" value="" style="width: 145px;vertical-align: top;margin-right:20px"/>
                        <input class="buttoncenter" type="button" value="${internationalConfig.上传文件}" id="common_upload_btn1" style="margin-top:2px;margin-right:30px;"/>
                        <span id="see_pic1" style="vertical-align: top;"><a class="link_img" style="vertical-align: top;margin-left: 20px;" href="" target="_blank">查看图片</a></span>
                    </td>
                    <td><span class="gray">图片尺寸建议为600x800，限制大小1M</span></td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <input type="text" id="common_pic2" name="imgUrls" value="" style="width: 145px;vertical-align: top;margin-right:20px"/>
                        <input class="buttoncenter" type="button" value="${internationalConfig.上传文件}" id="common_upload_btn2" style="margin-top:2px;margin-right:30px;"/>
                        <span id="see_pic2" style="vertical-align: top;"><a class="link_img" style="vertical-align: top;margin-left: 20px;" href="" target="_blank">查看图片</a></span>
                    </td>
                    <td><span class="gray">图片尺寸建议为600x800，限制大小1M</span></td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <input type="text" id="common_pic3" name="imgUrls" value="" style="width: 145px;vertical-align: top;margin-right:20px"/>
                        <input class="buttoncenter" type="button" value="${internationalConfig.上传文件}" id="common_upload_btn3" style="margin-top:2px;margin-right:30px;"/>
                        <span id="see_pic3" style="vertical-align: top;"><a class="link_img" style="vertical-align: top;margin-left: 20px;" href="" target="_blank">查看图片</a></span>
                    </td>
                    <td><span class="gray">图片尺寸建议为600x800，限制大小1M</span></td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <input type="text" id="common_pic4" name="imgUrls" value="" style="width: 145px;vertical-align: top;margin-right:20px"/>
                        <input class="buttoncenter" type="button" value="${internationalConfig.上传文件}" id="common_upload_btn4" style="margin-top:2px;margin-right:30px;"/>
                        <span id="see_pic4" style="vertical-align: top;"><a class="link_img" style="vertical-align: top;margin-left: 20px;" href="" target="_blank">查看图片</a></span>
                    </td>
                    <td><span class="gray">图片尺寸建议为600x800，限制大小1M</span></td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <input type="text" id="common_pic5" name="imgUrls" value="" style="width: 145px;vertical-align: top;margin-right:20px"/>
                        <input class="buttoncenter" type="button" value="${internationalConfig.上传文件}" id="common_upload_btn5" style="margin-top:2px;margin-right:30px;"/>
                        <span id="see_pic5" style="vertical-align: top;"><a class="link_img" style="vertical-align: top;margin-left: 20px;" href="" target="_blank">查看图片</a></span>
                    </td>
                    <td><span class="gray">图片尺寸建议为600x800，限制大小1M</span></td>
                </tr>
                <tr>
                    <td><b> </b><span class="name-span">SPU介绍</span></td>
                    <td><textarea type="text" name="description" class="easyui-validatebox" data-options="validType:'maxLength[40]'" value="${spu.description}">${spu.description}</textarea></td>
                    <td><span class="gray">最多不超过100个汉字，或200个字符</span></td>
                </tr>
            </table>
            <button class="save-btn" onclick="saveTab1(this,event)">${internationalConfig.保存}</button>
            <button class="close-btn" onclick="closeTab(this,event)">${internationalConfig.取消}</button>
        </form>
    </div>
        <%--<div class="cont2">
            <button class="save-btn" onclick="closeTab()">${internationalConfig.保存}</button>
            <button class="close-btn" onclick="closeTab()">${internationalConfig.关闭}</button>
        </div>--%>
        <div class="cont2" title="商品信息" id="tabs-2">
            <div class="sj_list">
                    <input type="hidden" name="vendorId" value="${vendor.id}"/>
                    <table>
                        <tr>
                            <td><b style="color: red">*</b><span class="name-span">是否选择销售属性</span></td>
                            <td>
                                <input type="radio" class="selectAttr" style="margin: 0 3px 0 10px" name="selectAttr" value="1" <c:if test="${not empty attributeList}">checked="checked"</c:if>/>是
                                <input type="radio" class="selectAttr" style="margin: 0 3px 0 10px" name="selectAttr" value="0" <c:if test="${empty attributeList}">checked="checked"</c:if>/>否
                            </td>
                            <td><button class="edit-btn" onclick="newSjMes()">选择销售属性</button></td>
                        </tr>
                    </table>
                    <div class="attr_hide">
                        <table>
                            <tr>
                                <td colspan="3"><b style="color: red">*</b><span class="name-span">请选择该SPU下匹配的属性可选项</span></td>
                            </tr>
                        </table>
                        <div class="attr-table clearfix">
                            <form id="attr_form">
                                <table>
                                    <tr>
                                        <th width="120">属性名称</th>
                                        <th width="620">可选项（支持复选）</th>
                                    </tr>
                                    <c:forEach var="attribute" items="${attributeList}">
                                        <tr data-id="${attribute.attributeId}">
                                            <td>${attribute.name}</td>
                                            <td>
                                            <c:forEach var="item" items="${attribute.categoryAttributeItems}">
                                                <input type="checkbox" value="${item.attributeItemId}" data-name="${item.attributeItem}" name="data" <c:if test="${item.checked}">checked</c:if> />${item.attributeItem}
                                            </c:forEach>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </table>
                            </form>
                            <button class="chose_btn selectFinish">选择完毕</button>
                        </div>
                    </div>
            </div>
            <div class="selecked_list">
                <p class="select_title">该spu已关联<span>${fn:length(attributeList)}</span>个商品信息</p>
                <table id="dataGrid" style="min-height:400px;"></table>
            </div>
            <%--<button class="save-btn" onclick="saveTab2(this,event)">${internationalConfig.保存}</button>
            <button class="close-btn" onclick="closeTab(this,event)">${internationalConfig.取消}</button>--%>
        </div>




</div>
<script>
    var dataGrid
    $.extend($.fn.validatebox.defaults.rules, {
        maxLength: {
            validator: function(value, param){
                var length = value.replace(/[\u0391-\uFFE5]/g,"aa").length;
                return param[0] >= length;
            },
            message: '不得超过{0}个字符'
        },
        //spu品类必选
        selectRequire: {
            validator: function (value, param) {
                if(value=="-1"){
                    return false;
                }else{
                    return true;
                }
            },
            message: '${internationalConfig.请选择}'
        },
        isUrl:{ //验证链接
            validator: function(value, param){
                return /^(file|http|https|ftp|mms|telnet|news|wais|mailto):\/\/(.+)$/.test(value);
            },
            message: '请输入正确的链接。'
        },
        mastcheck:{//验证链接salePlatform
            validator: function (value, param) {
                var frm = param[0], groupname = param[1], checkNum = 0;
                $('input[name="' + groupname + '"]', document[frm]).each(function () { //查找表单中所有此名称的checkbox
                    if (this.checked) checkNum++;
                });

                return checkNum > 0;
            },
            message: '请至少选择一个销售平台'
        }
    });
    (function($) {
        if('${spu.isOnline}'==2){   //已上架后不可编辑
            $("input,textarea,select").attr("disabled",true);
            $(".selectFinish").hide();
            $(".edit-btn").remove();
            $(".save-btn").hide();
            $(".close-btn").css('margin-left','500px');
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
        //判断是否是编辑进来
        if(!$("#spu_id").val()){
            $('#tabs').tabs({
                border:false,
                onSelect:function(title,index){
                    if(index==1){
                        $("#tabs").tabs("select", 0);
                        parent.$.messager.alert('${internationalConfig.提示}', '请先保存SPU基本信息', 'info');
                    }
                }
            });
        }
        initPosterButton();
        var spuid = $("#spu_id").val();
        if($("#spu_id").val()){
            getPicList();
            $.ajax({
                url : "/mini/spu/list_spu_mapping_sku?spuId="+$("#spu_id").val(),
                type : "get",
                dataType : "json",
                success : function(res) {
                    dataGrid = renderDataGrid();
                    $(".select_title span").html(res.length);
                    if (res.length > 0) {
                        $(".selectAttr").attr("disabled",true);
                        /*$(".edit-btn").hide();*/
                        /*if('${attributeList}'==''){ //已关联商品，切无销售属性
                            $(".selectAttr").attr("disabled",true);
                        }else{
                            $(".edit-btn").hide();
                        }*/
                        $("#dataGrid").datagrid('loadData',res);
                    }else{
                        $("#dataGrid").datagrid("appendRow", []);
                    }
                }
            })
            //dataGrid = renderDataGrid("/mini/spu/list_spu_mapping_sku?spuId="+$("#spu_id").val());

        }else{
            $(".link_img").hide();
            dataGrid = renderDataGrid();
            if(spuid==''){
                $("#dataGrid").datagrid("appendRow", []);
            }

        }
        //是否选择销售属性
        if($(".selectAttr:checked").val()=="1"){
            $(".edit-btn").show();
            $(".selectFinish").show();
        }else{
            $(".selectFinish").hide();
            $(".edit-btn").hide();
        }
        $(".selectAttr").change(function(){
            if($(this).val()=="1"){
                $(".edit-btn").show();
                $(".selectFinish").show();
                var row = ($('#dataGrid').datagrid('getRows'))[0];
                if('${attributeList}'==''&&row.length==0){
                    $('#dataGrid').datagrid('deleteRow', 0);
                }
            }else{
                $(".edit-btn").hide();
                $(".selectFinish").hide();
                $("#dataGrid").datagrid("loadData", []);
                $("#dataGrid").datagrid("appendRow", []);
                /*$(".selectFinish").hide();*/
            }
        });

        $(".category1").change(function () {
            var html = '<option value="-1">请选择</option>';
            var category1 = $(this).val();
            $(".category2").html(html);
            $(".category3").html(html);
            $.ajax({
                url : "/mini/category/sub?id="+category1,
                type : "get",
                dataType : "json",
                success : function(res) {
                    if (res.total > 0) {
                        for(var i in res.rows){
                            html += '<option value="'+res.rows[i].id+'">'+res.rows[i].name+'</option>'
                        }
                        $(".category2").html(html);
                    }
                }
            })
        });
        $(".category2").change(function () {
            var html = '<option value="-1">请选择</option>';
            var category2 = $(this).val();
            $(".category3").html(html);
            $.ajax({
                url : "/mini/category/sub?id="+category2,
                type : "get",
                dataType : "json",
                success : function(res) {
                    if (res.total > 0) {
                        for(var i in res.rows){
                            html += '<option value="'+res.rows[i].id+'">'+res.rows[i].name+'</option>'
                        }
                        $(".category3").html(html);
                    }
                }
            })
        });

        $(".selectFinish").click(function (e) {
            e.preventDefault();
            /*var row = ($('#dataGrid').datagrid('getRows'))[0];
            if('${attributeList}'==''&&row.length==0){
                $('#dataGrid').datagrid('deleteRow', 0);
            }*/
            var dataArr = [];
            var rows = $("#dataGrid").datagrid("getRows");
            for(var i=0;i<rows.length;i++){
                if(rows[i].attributeIds) {
                    dataArr.push(rows[i].attributeIds)
                }
            }
            var arr = [];
            var trList = $("#attr_form table tr");
            for(var i=1;i<trList.length;i++){
                var obj = {};
                obj.attributeId =  $(trList[i]).attr("data-id");
                obj.name = $(trList[i]).find("td")[0].innerHTML;
                var tdInput = $($(trList[i]).find("td")[1]).find("input:checked");
                obj.items = [];
                for(var j=0;j<tdInput.length;j++){
                    var itemobj = {};
                    itemobj.attributeItemId = $(tdInput[j]).val();
                    itemobj.attributeItemName = $(tdInput[j]).attr("data-name");
                    obj.items.push(itemobj);
                }
                if(obj.items.length!=0){
                    arr.push(obj);
                }
            }
            if(arr.length==0){
                return false;
            }
            var showText = [];
            var interData = [];
            for(var i in arr){
                interData[i] = [];
                showText[i] = [];
                for(var j in arr[i].items){
                    var str = arr[i].attributeId+':'+arr[i].items[j].attributeItemId;
                    interData[i].push(str);
                    var strText = arr[i].name+':'+arr[i].items[j].attributeItemName;
                    showText[i].push(strText);
                }
            }
            var text = buildedata(showText);
            var data = buildedata(interData);
            /*var rows = $('#dataGrid').datagrid('getRows')//获取当前页的数据行
            console.log(rows)*/
            for(var i=0;i<text.length;i++){
                var row = {};
                row.attributeIds = data[i];
                row.attributeItems = text[i];
                var include = 0;
                for(var k=0;k<dataArr.length;k++){
                    if(row.attributeIds==dataArr[k]){
                        include=1;
                    }
                }
                if(include==0){
                    $("#dataGrid").datagrid("appendRow", row);
                }
            }
        });
    })(jQuery)
    //选择销售属性
    function newSjMes() {
        var categoryId = $(".category3").val();
        var arr = [];
        var ele = $("#attr_form table tr");
        for(var i=1;i<ele.length;i++){
            arr.push($(ele[i]).attr('data-id'));
        }
        var str = arr.join(',');
        parent.$.modalDialog({
            title : '选择销售属性',
            width :500,
            height : 300,
            href : '/mini/spu/spu_select_attribute?categoryId='+categoryId+'&attributeIds='+str,
            onClose : function() {
                this.parentNode.removeChild(this);
            },
            buttons : [ {
                text : '${internationalConfig.保存}',
                handler : function() {
                    var f = parent.$.modalDialog.handler.find('#form');
                    var checkAttr = f.serializeJson()//弹框选中的销售属性
                    var checkArr = checkAttr.attr.split(",");//弹框选中的销售属性存入数组
                    /*<tr>
                     <td>时长名称</td>
                     <td>
                     <input type="checkbox" name="data"/>包年
                     <input type="checkbox" name="data"/>包月
                     <input type="checkbox" name="data"/>包季
                     </td>
                     </tr>*/

                    var attrList = $("#attr_form table tr");//编辑时页面有的销售属性
                    var attrArr = [];
                    for(var k=1;k<attrList.length;k++){//编辑时页面有的销售属性存入数组
                        attrArr.push($(attrList[k]).attr("data-id"));
                    }
                    var checkData = [];
                    for(var l=0;l<checkArr.length;l++){//如果页面中已有，则去掉选中的值
                        if($.inArray(checkArr[l],attrArr)<0){
                            checkData.push(checkArr[l]);
                        }
                    }
                    if (f.form("validate")) {
                        $.ajax({
                            type: 'GET',
                            cache: false,
                            url: '/mini/category_attr/dataGrid?id='+categoryId+'&pagesize='+100,
                            dataType: 'json',
                            success: function(res) {
                                var html = "";
                                for(var h=0;h<checkData.length;h++){
                                    for(var i in res.rows){
                                        if(checkData[h]==res.rows[i].attributeId){
                                            html += '<tr data-id = "'+res.rows[i].attributeId+'"><td>'+res.rows[i].name+'</td><td>';
                                            for(var j in res.rows[i].categoryAttributeItems){
                                                html += '<input type="checkbox" name="time" data-name="'+res.rows[i].categoryAttributeItems[j].attributeItem+'" value="'+res.rows[i].categoryAttributeItems[j].attributeItemId+'"/>'+res.rows[i].categoryAttributeItems[j].attributeItem;
                                            }
                                            html += '</td></tr>';

                                        }
                                    }
                                }
                                $(html).appendTo("#attr_form table");
                                parent.$.modalDialog.handler.dialog('close');
                            }
                        });

                    }
                }
            }, {
                text : "${internationalConfig.取消}",
                handler : function() {
                    parent.$.modalDialog.handler.dialog('close');
                }
            } ]
        });
    }
    function addZero(data){
        if(parseInt(data)<10){
            return "0"+data;
        }else{
            return data;
        }
    }
    function renderDataGrid(url,data, method) {
        return $('#dataGrid')
                .datagrid(
                        {
                            //url : url,
                            data:data,
                            fit : true,
                            fitColumns : true,
                            border : false,
                            method : method || 'post',
                            pagination : false,
                            idField : 'id',
                            sortName : 'pk_agg_package',
                            sortOrder : 'desc',
                            checkOnSelect : false,
                            selectOnCheck : false,
                            nowrap : false,
                            striped : true,
                            rownumbers : true,
                            singleSelect : true,
                            frozenColumns : [ [ {
                                field : 'id',
                                title : '${internationalConfig.编号}',
                                width : 10,
                                hidden : true
                            } ] ],
                            columns : [ [
                                {
                                    field : 'skuNo',
                                    title : '商品编码',
                                    width : 140,
                                    sortable : true,
                                    formatter : function(val, row,index) {
                                        if(val){
                                            return '<a href="javascript:void(0)" onclick="mappingShop(\''+row.attributeIds+'\',\''+row.attributeItems+'\',\''+index+'\',\''+row.skuId+'\')">'+val+'</a>';
                                        }else{
                                            return '<a href="javascript:void(0)" onclick="mappingShop(\''+row.attributeIds+'\',\''+row.attributeItems+'\',\''+index+'\')">关联商品</a>';
                                        }


                                    }
                                },
                                {
                                    field : 'name',
                                    title : '商品名称',
                                    width : 100,
                                    sortable : false
                                },
                                {
                                    field : 'attributeItems',
                                    title : '销售属性',
                                    width : 100,
                                    sortable : false,
                                    formatter : function(val) {
                                        if(val){
                                            var arr = val.split(',');
                                            var html = "";
                                            for(var i=0;i<arr.length;i++){
                                                html += '<p>'+arr[i]+'</p>';
                                            }
                                            return html;
                                        }else{
                                            return '无';
                                        }
                                    }
                                },
                                {
                                    field : 'price',
                                    title : '价格（元）',
                                    width : 60,
                                    sortable : false
                                },
                                {
                                    field : 'status',
                                    title : '上下架状态',
                                    width : 80,
                                    sortable : false,
                                    formatter : function(val) {
                                        if(val==2){
                                            return '已上架';
                                        }else if(val==1){
                                            return '已下架';
                                        }else {
                                            return "";
                                        }
                                    }
                                }/*,
                                {
                                    field : 'isDefault',
                                    title : '是否默认',
                                    width : 80,
                                    sortable : false,
                                    formatter : function(val) {
                                        if(val==1) {
                                            return "否";
                                        }
                                        if(val==2) {
                                            return "是";
                                        }
                                    }
                                }*/ ] ],
                            toolbar : '#toolbar',
                            onLoadSuccess : function() {
                                $('#searchForm table').show();
                                parent.$.messager.progress('close');
                            },
                            onRowContextMenu : function(e, rowIndex, rowData) {
                                e.preventDefault();
                                $(this).datagrid('unselectAll');
                                $(this).datagrid('selectRow', rowIndex);
                                $('#menu').menu('show', {
                                    left : e.pageX,
                                    top : e.pageY
                                });
                            }
                        });
    }
    function saveTab1(that,e) {
        e.preventDefault();
        var form = $(that).parents("form");
        var formData = form.serializeJson();
        if(formData.salePlatform=="1000000000,0100000000"){
            formData.salePlatform="1100000000";
        }
        if(!'${spu.id}'){
            formData.categoryId = $(".category3").val();
        }
        if (form.form("validate")) {
            if($("input[name='isEntityBundle']:checked").val()==2&&$("input[name='qrcodeUrl']").val()==''){
                parent.$.messager.alert('${internationalConfig.提示}', '二维码链接不能为空', 'info',function () {
                    $("input[name='qrcodeUrl']").trigger("focus");
                });
                return false;
            }
            parent.$.messager.progress({
                title : '${internationalConfig.提示}',
                text : '${internationalConfig.数据处理中}....'
            });
            $.ajax({
                url : "/mini/spu/save",   //保存链接
                type : "post",
                data : formData,
                dataType : "json",
                success : function(result) {
                    parent.$.messager.progress('close');
                    if (result.code == 0) {
                        parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.保存成功}', 'success');
                        if(parent.refreshDataGrid.spuDataGrid) {
                            parent.refreshDataGrid.spuDataGrid.datagrid('reload');
                        }
                        if(result.data) {
                            $("#spu_id").val(result.data);
                        }
                        $(".category1,.category2,.category3").attr("disabled",true);
                        $('#tabs').tabs({
                            border:false,
                            scroll:0,
                            onSelect:function(title,index){}
                        });
                        $("#tabs").tabs("select", 1);
                        $(".selectAttr").trigger('focus');
                    } else {
                        parent.$.messager.alert('${internationalConfig.错误}', '<div style="word-break:break-all;">'+result.msg+'</div>', 'error');
                    }
                }
            })
        }
    }
    //关联商品
    function mappingShop(info,str,index,skuId) {
        var spuId = $("#spu_id").val();
        if(info=='undefined'){
            info = ""
        }
        if(str=='undefined'){
            str = ""
        }
        var skuIdStr = '';
        if(skuId!=undefined&&skuId!='undefined'){
            skuIdStr = '&skuId='+skuId;
        }
        if('${spu.isOnline}'==2){//已上架，不让保存
            parent.$.modalDialog({
                title : '关联商品',
                width : 650,
                height : 340,
                href : '/mini/spu/mapping_spu_sku?spuId='+spuId+'&attributeInfo='+info+'&attributeString='+str+skuIdStr,
                onClose : function() {
                    this.parentNode.removeChild(this);
                },
                buttons : [  {
                    text : "${internationalConfig.关闭}",
                    handler : function() {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                } ]
            });
        }else{
            parent.$.modalDialog({
                title : '关联商品',
                width : 650,
                height : 340,
                href : '/mini/spu/mapping_spu_sku?spuId='+spuId+'&attributeInfo='+info+'&attributeString='+str+skuIdStr,
                onClose : function() {
                    this.parentNode.removeChild(this);
                },
                buttons : [ {
                    text : '${internationalConfig.保存}',
                    handler : function() {
                        var f = parent.$.modalDialog.handler.find('#form');
                        submitFun(f, 2,"/mini/spu/spu_mapping",index);
                    }
                }, {
                    text : "${internationalConfig.取消}",
                    handler : function() {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                } ]
            });
        }
    }
    function saveTab2(that,e) {
        e.preventDefault();
        var form = $(that).parents("form");
        var formData = form.serializeJson();
        if (form.form("validate")) {
            parent.$.messager.progress({
                title : '${internationalConfig.提示}',
                text : '${internationalConfig.数据处理中}....'
            });
            $.ajax({
                url : "/mini/vendor/modify",   //保存链接
                type : "post",
                data : formData,
                dataType : "json",
                success : function(result) {
                    parent.$.messager.progress('close');
                    if (result.code == 0) {
                        parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.保存成功}', 'success');
                        parent.venderDataGrid.datagrid('reload');
                        parent.$('.tabs .tabs-selected .tabs-close').trigger("click");
                    } else {
                        parent.$.messager.alert('${internationalConfig.错误}', '<div style="word-break:break-all;">'+result.msg+'</div>', 'error');
                    }
                }
            })
        }
    }
    //关闭当前页
    function closeTab(){
        parent.$('.tabs .tabs-selected .tabs-close').trigger("click");
    }
    //编辑时获取图片列表
    function getPicList() {
        $(".link_img").hide();
        var picList = "${spu.imgUrls}";
        var links = picList.split(",");
        for(var i=0;i<links.length;i++){
            $($("input[name=imgUrls]")[i]).val(links[i]);
            if(links[i]) {
                $($(".link_img")[i]).show().attr("href", links[i]);
            }
        }
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
    function submitFun(f, type,url,freshRow) {
        if (f.form("validate")) {
            parent.$.messager.progress({
                title : '${internationalConfig.提示}',
                text : '${internationalConfig.数据处理中}....'
            });

            var successStr;
            if(type == 1){
                successStr = "${internationalConfig.保存成功}";
            }else if(type == 2){
                successStr = "${internationalConfig.保存成功}";
            }
            var data = f.serializeJson()

            $.ajax({
                url : url,
                type : "post",
                data : data,
                dataType : "json",
                success : function(result) {
                    parent.$.messager.progress('close');
                    if (result.code == 0) {
                        parent.$.modalDialog.handler.dialog('close');
                        if(freshRow>-1){
                            $("#dataGrid").datagrid("updateRow",{   //更新本行数据
                                index:freshRow, //行索引
                                row:{
                                    skuNo:result.data[0].skuNo, //行中的某个字段
                                    name:result.data[0].name,
                                    price:result.data[0].price,
                                    marketPrice:result.data[0].marketPrice,
                                    attributeIds:result.data[0].attributeIds,
                                    attributeItems:result.data[0].attributeItems,
                                    skuId:result.data[0].skuId
                                }
                            });
                        }
                        $(".selectAttr").attr("disabled",true);
                        parent.$.messager.alert('${internationalConfig.成功}', successStr, 'success');
                        $('.select_title span').html(parseInt($('.select_title span').html())+1);//更新已关联商品个数
                        //parent.$.modalDialog.openner_dataGrid.datagrid('reload');

                    } else {
                        parent.$.messager.alert('${internationalConfig.错误}', '<div style="word-break:break-all;">'+result.msg+'</div>', 'error');
                    }
                },

                error : function() {}
            })
        }
    }
    function buildedata(arr) {
        var oArr = ['i', 'j', 'k', 'm', 'n', 'l', 'o', 'p', 'q'];
        var funStr = ['var array=\[\];'],
                handleStr = 'array.push(\'\'', endStr = '';
        for (var i = 0, len = arr.length; i < len; i++) {
            var $len = 'len' + oArr[i], $i = oArr[i];
            funStr.push('for\(var ' + $i + '=0,' + $len + '=arr\[' + i + '\]\.length;' + oArr[i] + '<' + $len + ';' + $i + '++\)\{');
            /*if(i==0){
                handleStr += '\+ arr\[' + i + '\]\[' + $i + '\]';
            }else{*/
                handleStr += '\+ arr\[' + i + '\]\[' + $i + '\]\+\',\'';
            //}
            if (i == len - 1) handleStr += '\);';
            endStr += '\}';
        }
        funStr.push(handleStr);
        funStr.push(endStr);
        funStr.push('return array;');
        return new Function('arr', funStr.join(''))(arr);
    }
</script>
</body>
</html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/inc/jstl.inc"%>
<style>
    .serchDiv{width:313px;}
    .serchDiv ul{width:313px; top:30px;}
    .serchDiv ul li{width: 305px;}
    .serchDiv input{width: 300px;border: 0;position: relative;top:-2px;}
</style>
<script type="text/javascript">
    var changedItenArr = new Array();
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

        //筛选属性名称 查询
        $("#fuzzy_search").unbind("click").on("click",function (e) {
            e.stopPropagation();
            var html = "";
            var value = $(this).val();
            var id = $("#categoryId").val();
            if($(this).attr("readonly")=="readonly"){
                return false;
            }
            $.ajax({
                url: "/mini/attribute/tip_list?name="+value+'&id='+id,
                dataType: 'json',
                success: function (res) {
                    if(res.rows.length==0){
                        html = '<li>暂无数据！</li>';
                    }
                    for(var i in res.rows){
                        html +='<li data-id="'+res.rows[i].id+'" onclick="changeAttrName(this)">'+res.rows[i].name+'</li>';
                    }
                    $("#prop_source").html(html);
                    $(".serchDiv ul").removeClass("hideul");
                }
            });
                $(this).unbind("keyup").on('keyup',function(){
                    var html = "";
                    var value = $(this).val();
                        $.ajax({
                            url: "/mini/attribute/tip_list?name="+value+'&id='+id,
                            dataType: 'json',
                            success: function (res) {
                                if(res.rows.length==0){
                                    html = '<li>暂无数据！</li>';
                                }
                                for(var i in res.rows){
                                    /*var obj = new Object();
                                    if(res.rows[i].items){
                                        obj = {items:res.rows[i].items};
                                    }*/
                                    html +='<li data-id="'+res.rows[i].id+'" onclick="changeAttrName(this)">'+res.rows[i].name+'</li>';
                                }
                                $("#prop_source").html(html);
                                $(".serchDiv ul").removeClass("hideul");
                            }
                        });
                });
        });

        //设置可选项
        $("#wright_input").unbind("focus").focus(function (e) {
            e.preventDefault();
            if(!$("#fuzzy_search").val()){
                parent.$.messager.alert('${internationalConfig.提示}', '请先选择属性名称', 'info');
                return false;
            }
            var attributeId = $("#attrId").val();
            $(".change_div").show();
            var html = "";
            var value = $(this).val();
            $.ajax({
                url: "/mini/attribute/item_list?attributeId="+attributeId+"&attributeItem="+value,
                dataType: 'json',
                success: function (res) {
                    for(var i in res){
                        var noChanged = notChanged(res[i].id)
                        var changeClass = noChanged==true?"not_changed":"changed_icon";
                        html +='<span data-id="'+res[i].id+'" class="'+changeClass+'">'+res[i].attributeItem+'</span>';
                    }
                    $("#to_change").html(html);
                    $(".change_div .to_change").removeClass("hideul");
                    $(".not_changed").unbind("click").click(function () {
                        var attrId = $(this).attr("data-id");
                        var attrName = $(this).html();
                        $(this).removeClass("not_changed").addClass("changed_icon");
                        $(this).unbind("click");
                        changedItenArr.push(attrId);
                        arrToStr();
                        $("#wright_input").before('<span class="changed" data-id="'+attrId+'">'+attrName+'<a class="del" href="javascript:;" onclick="delChange(this)">×</a></span>');
                    });
                }
            });
                $(this).unbind("keyup").on('keyup',function(){
                    var html = "";
                    var value = $(this).val();
                        $.ajax({
                            url: "/mini/attribute/item_list?attributeId="+attributeId+"&attributeItem="+value,
                            dataType: 'json',
                            success: function (res) {
                                if(res.length==0){
                                    html = '暂无数据！';
                                }
                                for(var i in res){
                                    var noChanged = notChanged(res[i].id)
                                    var changeClass = noChanged==true?"not_changed":"changed_icon";
                                    html +='<span data-id="'+res[i].id+'" class="'+changeClass+'">'+res[i].attributeItem+'</span>';
                                }
                                $("#to_change").html(html);
                                $(".change_div .to_change").removeClass("hideul");
                                $(".not_changed").unbind("click").click(function () {
                                    var attrId = $(this).attr("data-id");
                                    var attrName = $(this).html();
                                    $(this).removeClass("not_changed").addClass("changed_icon");
                                    $(this).unbind("click");
                                    changedItenArr.push(attrId);
                                    arrToStr();
                                    $("#wright_input").before('<span class="changed" data-id="'+attrId+'">'+attrName+'<a class="del" href="javascript:;" onclick="delChange(this)">×</a></span>');
                                });
                            }
                        });

                });
        });

        $(".search_change").click(function () {
            $("#wright_input").focus();
        })
        changedItem();
        $("body").click(function(){
            $(".serchDiv ul").addClass("hideul");
        });

    })(jQuery)
    function changeAttrName(that){  //选择属性名称
        var html = "";
        changedItenArr = [];
        arrToStr();
        $(".search_change span").remove();
        $("#wright_input").before(html);
        var attrId = $(that).attr("data-id");
        var attrName = $(that).html();
        $("#fuzzy_search").val(attrName);
        $(".attr_name").html(attrName);
        $("#attrId").val(attrId);
        $(".serchDiv ul").addClass("hideul");
    }
    function delChange(that) {
        var id = $(that).closest(".changed").attr("data-id");
        for(var i=0;i<changedItenArr.length;i++){
            if(changedItenArr[i]==id){
                changedItenArr.splice(i, 1);
            }
        }
        $(that).closest(".changed").remove();
        arrToStr();
    }

    function changedItem(){     //选择属性下可选项
        changedItenArr = [];
        var changedAttr = $(".search_change .changed");
        for(var i=0;i<changedAttr.length;i++){
            var attrId = $(changedAttr[i]).attr("data-id");
            changedItenArr.push(attrId);
        }
        arrToStr();
    }
    function notChanged(id) {
        for(var i in changedItenArr){
            if(id==changedItenArr[i]){
                return false;
            }
        }
        return true;
    }
    function arrToStr() {
        var str = changedItenArr.join(",");
        $("#chooseVal").val(str);
    }
    function choseAll(that) {       //选择全部
        var chose = $(that).is(':checked');
        if(chose==true){
            $(".not_changed").trigger("click");
        }else {
            $(".search_change .changed .del").trigger("click");
        }
    }
    function closeSearch() {
        $(".change_div").hide();
    }
    $(".must_check").click(function (e) {
        e.preventDefault();
    });
</script>
<style>
    .table tr{border:0;}
    tr:nth-child(2n-1) td{padding: 0 20px;font-size: 14px}
    tr:nth-child(2n) td{padding: 8px 0 40px 40px;}

    .search_change{width: 300px;min-height: 30px;border: 1px solid #ddd;padding: 0 10px;position: relative;}
    .search_change input{border: 0;width: 50px;box-shadow:0 0 0 #fff;}
    .search_change input:focus{box-shadow:0 0 0 #fff;}
    .search_change .changed{display:block;height:18px;background: #00a9d5;border: 1px solid #0e90d2;margin: 3px;float: left;
        position: relative;line-height: 18px;border-radius: 3px;padding:0 30px 0 5px;}
    .search_change .changed .del{position: absolute;width: 10px;height: 10px;top:3px;right:3px;font-size: 16px;line-height: 13px;cursor: pointer;}
    .search_change .changed .del:hover{text-decoration: none;}
    .change_div{position: relative;display: none;}
    .change_div .to_change{position: absolute;top:0;left:0;width:320px;border: 1px solid #eee;min-height: 100px;max-height: 200px;margin-bottom: 30px;padding-bottom: 30px;}
    .change_div .to_change span{display:inline-block;height:18px;background: #ddd;border: 1px solid #999;margin-right: 5px;
        position: relative;line-height: 18px;border-radius: 3px;padding:0 20px;cursor: pointer;}
    .change_div .to_change .changed_icon{background: #aaa;}
    .change_div .to_change .list{padding: 0 10px;}
    .change_tools{position: absolute;bottom: 0;border-top:1px solid #eee;height: 30px;width: 100%}
    .change_div .change_tools .botton_tool{border:0;padding: 0 5px;background: #fff;}
    .change_div .change_tools .tool_right{padding-left: 222px;}
    .change_div .change_tools .tool_right a{padding: 0 3px;}
</style>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="">
        <div class="Breadcrumbs">
            当前品类<span>${category.pathTree}</span>
        </div>
        <form id="form" method="post" action="">
            <table style="width: 100%" class="table table-form">
                <tr><td>1. 筛选属性名称</td></tr>
                <tr>
                    <td>
                        <div class="serchDiv">
                            <input type="text" id="fuzzy_search" style="font-size: 12px" class="easyui-validatebox"  data-options="required:true" <c:if test="${not empty categoryAttr.name}">readonly</c:if> value="${categoryAttr.name}" autocomplete="off"/>
                            <input type="hidden" name="id" value="${categoryAttr.attributeId}" id="attrId"/>
                            <ul id="prop_source" class="hideul">
                                <%--<li>111</li>
                                <li>111</li>--%>
                            </ul>
                        </div>

                    </td>
                </tr>
                <tr><td>2. 设置属性类型</td></tr>
                <tr>
                    <td colspan="3">
                        <input type="checkbox" class="must_check" value="1" name="attributeUseScope" <c:if test="${categoryAttr.attributeUseScope ==1 || categoryAttr.attributeUseScope ==3 || empty categoryAttr.attributeUseScope}">checked</c:if> readonly/>销售属性
                        <input type="checkbox" value="2" name="attributeUseScope" <c:if test="${categoryAttr.attributeUseScope ==2 || categoryAttr.attributeUseScope ==3}">checked</c:if>/>展示属性
                    </td>
                </tr>
                <tr><td>3. 设置当前品类在【<span class="attr_name" style="color: #00a9d5">${categoryAttr.name}</span>】属性下的可选项</td></tr>
                <tr>
                    <td colspan="3">
                        <div class="search_change clearfix">
                            <c:forEach items="${categoryAttr.categoryAttributeItems}" var="item">
                                    <span class="changed" data-id="${item.attributeItemId}">${item.attributeItem}</span>
                            </c:forEach>
                            <input type="text" id="wright_input" value="" maxlength="16" autocomplete="off"/>

                        </div>
                        <div class="change_div">
                            <div class="to_change hideul">
                                <div id="to_change" class="list">

                                </div>
                                <div class="change_tools">
                                    <span class="botton_tool"><input type="checkbox" onchange="choseAll(this)" />全选</span>
                                    <span class="botton_tool tool_right">
                                        <a href="javascript:;" onclick="closeSearch()">关闭</a>
                                    </span>
                                </div>
                            </div>

                        </div>
                        <input type="hidden" id="categoryId" name="categoryId" value="${category.id}"/>
                        <%--<input type="hidden" id="attributeId" name="" value=""/>--%>
                        <input type="hidden" id="chooseVal" name="attributeItemIds" value=""/>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>

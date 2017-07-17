<%--
  Created by IntelliJ IDEA.
  User: kangxiongwei3
  Date: 2016/4/13
  Time: 18:16
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/inc/jstl.inc" %>

<style type="text/css">
    .add_star {
        background-color: #F2F2F2;
    }

    .free_prop_box {
        padding: 20px 0 20px 40px;
        width: 680px;
        overflow: hidden;
        margin: 0 auto;
    }

    .free_prop_box .prop_wrap {
        width: 100%;
    }

    .free_prop_box .prop_wrap .float_prop_wrap {
        float: left;
        width: 240px;
        margin: 0 10px;
    }

    .free_prop_box .prop_wrap .float_prop_wrap .pro_title {
        line-height: 30px;
    }

    .free_prop_box .prop_wrap .float_prop_wrap .prop_list {
        width: 240px;
        height: 300px;
        overflow-y: scroll;
        border: 1px solid #CCCCCC;
    }

    .free_prop_box .prop_wrap .float_prop_wrap .prop_list table tr {
        height: 25px;
    }

    .free_prop_box .prop_wrap .float_prop_wrap .prop_list table tr td {
        height: 20px;
        width: 50px;
        position: relative;
        padding: 3px 0 0 10px;
    }

    .free_prop_box .prop_wrap .float_prop_wrap .prop_list table tr td input[type="checkbox"] {
        position: absolute;
        right: 10px;
        bottom: 10px;
    }

    /**/
    .free_prop_box .prop_wrap .float_prop_wrap .prop_list2 {
        width: 240px;
        height: 300px;
        overflow-y: scroll;
        border: 1px solid #CCCCCC;
    }

    .free_prop_box .prop_wrap .float_prop_wrap .prop_list2 table tr {
        height: 25px;
    }

    .free_prop_box .prop_wrap .float_prop_wrap .prop_list2 table tr td {
        height: 20px;
        width: 50px;
        position: relative;
        padding: 3px 0 0 10px;
    }

    .free_prop_box .prop_wrap .float_prop_wrap .prop_list2 table tr td input[type="checkbox"] {
        position: absolute;
        right: 10px;
        bottom: 10px;
    }

    .free_prop_box .prop_wrap .prop_list_wrap {
        width: 300px;
    }

    .free_prop_box .prop_wrap .prop_list_wrap .prop_list {
        width: 300px;
    }
    .free_prop_box .prop_wrap .prop_list_wrap .prop_list2 {
        width: 300px;
    }

    .free_prop_box .prop_wrap .prop_list_wrap2 {
        position: relative;
        width: 200px;
    }

    .free_prop_box .prop_wrap .prop_list_wrap2 table tr th,.free_prop_box .prop_wrap .prop_list_wrap table tr th{
        background: #999;
        text-align: center;
        padding: 3px;
    }

    .free_prop_box .prop_wrap .prop_list_wrap2 .table2 tr th,.free_prop_box .prop_wrap .prop_list_wrap .table2 tr th{
        margin-top: 5px;
    }

    .free_prop_box .prop_wrap .prop_list_wrap2 .table1{
        width: 202px;
    }

    .free_prop_box .prop_wrap .prop_list_wrap2 .table2{
        width: 180px;
        user-select: none;
        -webkit-user-select: none;
        -moz-user-select: none;
        -ms-user-select: none;
    }

    .free_prop_box .prop_wrap .prop_list_wrap table{
        width: 302px;
    }

    .free_prop_box .prop_wrap .prop_list_wrap .table2{
        width: 282px;
    }

    .free_prop_box .prop_wrap .prop_list_wrap2 .prop_list {
        width: 300px;
    }
    .free_prop_box .prop_wrap .prop_list_wrap2 .prop_list2 {
        width: 200px;
    }

    .free_prop_box .prop_wrap .add_del_c {
        width: 120px;
        float: left;
        padding-top: 150px;
        text-align: center;
    }

    .free_prop_box .prop_wrap .add_del_c a {
        display: inline-block;
        width: 83%;
        line-height: 20px;
        text-align: center;


        margin: 0 auto 10px;
        color: #0000ff;
    }
    .free_prop_box .prop_wrap .add_del_c .add_a{
        background:url(http://i2.letvimg.com/lc02_pay/201605/06/11/17/a_btn.png) -4px -37px no-repeat;

        font-family: "Microsoft YaHei", arial;
    }
    .free_prop_box .prop_wrap .add_del_c .dele_a{
        background:url(http://i2.letvimg.com/lc02_pay/201605/06/11/17/a_btn.png) -4px -8px no-repeat;
        font-family: "Microsoft YaHei", arial;
    }

    .free_prop_box .select_table {
        margin: 10px 0 0 20px;
        width: 50%;
    }

    .free_prop_box .oprate_div {
        padding-left: 20px;
    }

    tr.checkedBox {
        background: darkgray;
    }
    .fuzzy_search{width:180px;padding:3px 10px;margin-bottom: 5px;height: 24px;}
    .head-img{width:45px;height:45px;border-radius: 100%;padding: 3px 0 ;}
    .popular{width:50px;height:20px;}
    .delete-changed{display: inline-block;width: 16px;height: 16px;background: #d81e06;color: #FFF;cursor: pointer;
        border-radius:16px;font-size: 16px;text-align: center;font-weight: bold;line-height: 17px;}
    .delete-changed:hover{background: #d81a00;}
    .serch-icon{display: block;position: absolute;width: 30px;height: 30px;left:-35px;top:1px;
    background: url("/static/style/images/search.png") center no-repeat;background-size: contain;}
</style>

<script type="text/javascript">
    $(function () {
        var liveId = $("#liveId").val();
        parent.$.messager.progress('close');
        var clickTimeout = {
            _timeout: null,
            set: function (fn) {
                var that = this;
                that.clear();
                that._timeout = window.setTimeout(fn, 200);
            },
            clear: function () {
                var that = this;
                if (that._timeout) {
                    window.clearTimeout(that._timeout);
                }
            }
        };
        //效果处理
        $('#batch_props_handle').on("click", "#prop_source tr", function () {
            var that = this;
            clickTimeout.set(function () {
                $(that).toggleClass("checkedBox");
            });

        });
        $('#batch_props_handle').on("dblclick", "#prop_source tr", function () {
            clickTimeout.clear();
            $(this).addClass("checkedBox");
            addPropsToys();
            $(this).removeClass("checkedBox");
        });

        $(".popular").click(function (event) {
            event.stopPropagation();
        });
        getStars(liveId);


        $("#fuzzy_search").focus(function () {
            if ((navigator.userAgent.indexOf('MSIE') >= 0)&& (navigator.userAgent.indexOf('Opera') < 0)){
                $(this).on('propertychange',function(){
                    var html = "";
                    var value = $(this).val();
                    if(value!=""){
                        $.ajax({
                            url: "/props/starConfig/searchStar?name="+value,
                            dataType: 'json',
                            success: function (res) {
                                if(res.data.length==0){
                                    html = '<tr style="color: #666;text-align: center;height: 100px;"><td>暂无数据！</td></tr>';
                                }
                                for(var i in res.data){
                                    html +='<tr data-id = "'+res.data[i].id+'" data-weight = "'+res.data[i].weight+'">'+
                                            '<td style="width: 60px"><img class="head-img" src="'+res.data[i].pic+'"/></td>'+
                                            '<td style="width: 70px;text-align: center">'+res.data[i].name+'</td>'+
                                            '<td style="width: 40px;text-align: right;padding-right: 5px;padding-left: 0;">'+res.data[i].id+'</td>'+
                                            '</tr>';
                                }
                                $("#prop_source").html(html);
                            }
                        });
                    }

                    /*$(".serchDiv ul li").unbind("click").click(function(event){
                        selName = $(this).html();
                        $(".serchSelect").val($(this).html());
                        $(".serchDiv ul").addClass("hideul");
                        changeCP($(this).val());
                        event.stopPropagation();
                    });*/
                });
            }else{
                $(this).on('input',function(){
                    var html = "";
                    var value = $(this).val();
                    if(value!=""){
                        $.ajax({
                            url: "/props/starConfig/searchStar?name="+value,
                            dataType: 'json',
                            success: function (res) {
                                if(res.data.length==0){
                                    html = '<tr style="color: #666;text-align: center;height: 100px;"><td>暂无数据！</td></tr>';
                                }
                                for(var i in res.data){
                                    html +='<tr data-id = "'+res.data[i].id+'" data-weight = "'+res.data[i].weight+'" data-pic="'+res.data[i].pic+'" data-name="'+res.data[i].name+'">'+
                                            '<td style="width: 50px"><img class="head-img" src="'+res.data[i].pic+'"/></td>'+
                                            '<td style="width: 60px;text-align: center">'+res.data[i].name+'</td>'+
                                            '<td style="width: 40px;text-align: center;padding-left: 0;">'+res.data[i].id+'</td>'+
                                            '</tr>';
                                }
                                $("#prop_source").html(html);
                            }
                        });
                    }

                    /*$(".serchDiv ul li").unbind("click").click(function(event){
                        selName = $(this).html();
                        $(".serchSelect").val($(this).html());
                        $(".serchDiv ul").addClass("hideul");
                        changeCP($(this).val());
                        event.stopPropagation();
                    });*/
                });
            }
        });

        /*$(".delete-changed").unbind("click").click(function(event){
            event.stopPropagation();
            $(this).closest('tr').remove();
        });*/
    });
    /**
     * 验证道具名称是否可用
     */
    function validateStar() {
        var starId = $("input[name='starId']").val();
        $.ajax({
            type: "POST",
            url: "/props_live/validate_star",
            data: {"starId": starId},
            dataType: 'json',
            success: function (json) {
                //alert(JSON.stringify(json));
                if (json.code == 0) {
                    var data = $.parseJSON(json.data);
                    $("input[name='name']").val(data.name);
                    $("input[name='totalPrice']").val(data.totalPrice);
                    $("input[name='pic']").val(data.pic);
                    $("#starImg").attr("src", data.pic);
                }
            }
        });
    }

    //同步道具
    function syncToys(businessId) {
        $.post("/props_live/sync_props.do", {businessId:businessId}, function (json) {
            var data = json['data'];
            var content = "";
            for (var i = 0; i < data.length; i++) {
                var obj = data[i];
                content += "<tr><td style='width: 30px'>" + obj.id + "</td><td style='width: 80px'>" + obj.codeName + "</td> <td style='width: 40px'>" + obj.price + "</td></tr>"
            }
            $("#prop_source tr").remove();
            $("#prop_source").append(content);
        }, "json");
    }

    /**
     * 用于批量添加或删除直播的道具后，刷新界面
     * @param data
     */
    var refreshPropsForLive = function (data) {
        var content = "";
        for (var i = 0; i < data.length; i++) {
            var obj = data[i];
            content += "<tr><td style='width: 30px'>" + obj.id + "</td><td style='width: 80px'>" + obj.codeName + "</td> <td style='width: 40px'>" + obj.price + "</td></tr>"
        }
        $("#prop_target tr").remove();
        $("#prop_target").append(content);
    };

    //实现通过对话框添加道具
    function addPropsToys() {
        var trs = $("#prop_source").find(".checkedBox");
        var trsChoose = $("#prop_target").find("tr");
        if (trs.length==0) {
            parent.$.messager.alert("提示", "请选择需要添加的道具");
            return false;
        }
        var liveId = $("input[name='liveId']").val();
        var type = $("input[name='type']").val();
        //var pids = "";
        trs.each(function () {
            var dataId = $(this).attr("data-id");
            var dataWeight = $(this).attr("data-weight");
            var pid = $(this).clone().removeClass("checkedBox");
            pid.append('<td style="width: 70px;text-align: center"><input class="popular" value="'+dataWeight+'"/></td><td style="width: 50px;text-align: right;padding-right: 5px;padding-left: 0;"><span class="delete-changed" onclick="deleteStar('+liveId+','+dataId+',this)">×</span></td>');
            trsChoose.each(function(){
                var dataIdChoose = $(this).attr("data-id");
                if(dataIdChoose==dataId){
                    pid = "";
                }
            })
            $("#prop_target").append(pid);
        });

        /*$(".delete-changed").unbind("click").click(function(event){
            event.stopPropagation();
            $(this).closest('tr').remove();
        });*/


        /*$.post("/props_live/add_toys.do", {liveId: liveId, type: type, pids: pids}, function (json) {
            if (json.code == 0) {
                refreshPropsForLive(json['data']);
                parent.$.messager.alert("提示", "添加成功！");
            }
            else {
                parent.$.messager.alert("提示", "添加失败！" + json.data);
            }
        }, "json");*/
    }
    function getStars(liveId) {
        $.ajax({
            url: "/props_live/list_star?liveId="+liveId,
            dataType: 'json',
            success: function (res) {
                var html = "";
                for(var i in res.data){
                    html +='<tr data-id="'+res.data[i].starId+'" data-weight="'+res.data[i].weight+'" data-old="true" data-pic="'+res.data[i].pic+'" data-name="'+res.data[i].name+'">'+
                            '<td style="width: 60px"><img class="head-img" src="'+res.data[i].pic+'"/></td>'+
                            '<td style="width: 70px;text-align: center">'+res.data[i].name+'</td>'+
                            '<td style="width: 40px;text-align: center;padding-right: 5px;padding-left: 0;">'+res.data[i].starId+'</td>'+
                            '<td style="width: 70px;text-align: center"><input class="popular" value="'+res.data[i].weight+'"/></td>' +
                            '<td style="width: 50px;text-align: right;padding-right: 5px;padding-left: 0;"><span class="delete-changed" onclick="deleteStar('+liveId+','+res.data[i].starId+',this)">×</span></td>'
                    '</tr>';
                }
                $("#prop_target").html(html);
                /*$(".delete-changed").unbind("click").click(function(event){
                 event.stopPropagation();
                 $(this).closest('tr').remove();
                 });*/
            }
        });
    }
    function deleteStar(liveId, starId,that) {
        //console.log("直播ID为：" + liveId + " , 明星ID为：" + starId);
        parent.$.messager.confirm("提示", "确认移除此明星吗？", function (flag) {
            if (!flag) return;
            $.post('/props_live/delete_star.do', {liveId: liveId, starId: starId},
                    function (json) {
                        if (json.code == 0) {
                            //dataGrid.datagrid('load', {businessId:1});
                            //getStars(liveId);
                            $(that).closest('tr').remove();
                        }else{
                            parent.$.messager.alert("提示", "操作失败！");
                        }
                    }, "json");
        })
    }
    //实现通过对话框删除已经选择的道具
   /* function deletePropsToys() {
        var trs = $("#prop_target").find(".checkedBox");
        var liveId = $("input[name='liveId']").val();
        var type = $("input[name='type']").val();
        var pids = "";
        trs.each(function () {
            //console.log($(this).html());
            pids += $(this).find("td:first").text() + ",";
        });

        if (!pids) {
            parent.$.messager.alert("提示", "请选择需要添加或者删除的道具");
            return false;
        }

        $.post("/props_live/delete_toys", {liveId: liveId, type: type, pids: pids}, function (json) {
            if (json.code == 0) {
                refreshPropsForLive(json['data']);
                parent.$.messager.alert("提示", "删除成功！");
            }
            else {
                parent.$.messager.alert("提示", "删除失败！" + json.data);
            }
        }, "json");
    }*/

</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="" class="add_star">
        <input type="hidden" id="liveId" name="liveId" value="${liveId}">
        <input type="hidden" name="type" value="${type}">

        <div class="free_prop_box" id="batch_props_handle">
            <div class="prop_wrap">
                <div class="float_prop_wrap prop_list_wrap2">
                    <span class="serch-icon"></span>
                    <input value="" id="fuzzy_search" placeholder="请输入明星姓名" class="fuzzy_search"/>
                    <table class="table1">
                        <tr>
                            <th style="width: 80px">头像</th>
                            <th style="width: 50px">姓名</th>
                            <th style="width: 45px;padding-left: 25px;text-align: left">ID</th>
                        </tr>
                    </table>
                    <div class="prop_list2">
                        <table id="prop_source" class="table2">
                            <%--
                            <tr>
                                <td style="width: 60px"><img class="head-img" src="http://i2.letvimg.com/lc05_pay/201611/03/16/02/1478160118425.jpg"/></td>
                                <td style="width: 70px;text-align: center">刘德华</td>
                                <td style="width: 40px;text-align: right;padding-right: 5px;padding-left: 0;">11</td>
                            </tr>
                            <tr>
                                <td style="width: 60px"><img class="head-img" src="http://i2.letvimg.com/lc05_pay/201611/03/16/02/1478160118425.jpg"/></td>
                                <td style="width: 70px;text-align: center">刘德华</td>
                                <td style="width: 40px;text-align: right;padding-right: 5px;padding-left: 0;">11</td>
                            </tr>
                            <tr>
                                <td style="width: 60px"><img class="head-img" src="http://i2.letvimg.com/lc05_pay/201611/03/16/02/1478160118425.jpg"/></td>
                                <td style="width: 70px;text-align: center">刘德华</td>
                                <td style="width: 40px;text-align: right;padding-right: 5px;padding-left: 0;">11</td>
                            </tr>
                            <c:forEach var="prop" items="${library}">
                                <tr>
                                    <td style="width: 30px">${prop.id}</td>
                                    <td style="width: 80px">${prop.codeName}</td>
                                    <td style="width: 40px">${prop.price}</td>
                                </tr>
                            </c:forEach>
                            --%>
                        </table>
                    </div>
                </div>
                <div class="add_del_c">
                    <%--<a class="dele_a" href="javascript:void (0);" onclick="deletePropsToys();">删除</a>--%>
                    <a class="add_a" href="javascript:void (0);" onclick="addPropsToys();">添加</a>
                    <p style="color: #666;text-align: left">提示：双击或选中后点击按钮添加</p>
                </div>
                <div class="float_prop_wrap prop_list_wrap">

                    <h4 class="pro_title">添入明星
                        <%--<a href="#" onclick="syncToys(${businessId});" style="font-size: 12px">同步</a>--%>
                    </h4>
                    <table>
                        <tr>
                            <th>头像</th>
                            <th>姓名</th>
                            <th>ID</th>
                            <th>人气值</th>
                            <th>操作</th>
                        </tr>
                    </table>
                    <div class="prop_list">
                        <table id="prop_target" class="table2">
                            <%--<tr data-id = "2" data-weight = "123" data-old="true" data-pic="http://i2.letvimg.com/lc05_pay/201611/03/16/02/1478160118425.jpg" data-name="刘德华">
                                <td style="width: 50px"><img class="head-img" src="http://i2.letvimg.com/lc05_pay/201611/03/16/02/1478160118425.jpg"/></td>
                                <td style="width: 60px;text-align: center">刘德华</td>
                                <td style="width: 40px;text-align: center;padding-left: 0;">11</td>
                                <td style="width: 70px;text-align: center"><input class="popular" value="123"/></td>
                                <td style="width: 50px;text-align: right;padding-right: 5px;padding-left: 0;"><span class="delete-changed">×</span></td>
                            </tr>--%>
                            <c:forEach var="prop" items="${existToys}">
                                <tr>
                                    <td style="width: 30px">${prop.id}</td>
                                    <td style="width: 80px">${prop.codeName}</td>
                                    <td style="width: 40px">${prop.price}</td>
                                </tr>
                            </c:forEach>
                        </table>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

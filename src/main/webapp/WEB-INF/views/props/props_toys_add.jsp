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
        padding: 20px;
        width: 560px;
        overflow: hidden;
        margin: 0 auto;
        border: 1px solid #CCCCCC;
    }

    .free_prop_box .prop_wrap {
        width: 100%;
    }

    .free_prop_box .prop_wrap .float_prop_wrap {
        float: left;
        width: 240px;
        margin: 0 20px;
    }

    .free_prop_box .prop_wrap .float_prop_wrap .pro_title {
        line-height: 30px;
    }

    .free_prop_box .prop_wrap .float_prop_wrap .prop_list {
        width: 240px;
        height: 220px;
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

    .free_prop_box .prop_wrap .prop_list_wrap {
        width: 160px;
    }

    .free_prop_box .prop_wrap .prop_list_wrap .prop_list {
        width: 180px;
    }

    .free_prop_box .prop_wrap .add_del_c {
        width: 140px;
        float: left;
        padding-top: 50px;
        text-align: center;
    }

    .free_prop_box .prop_wrap .add_del_c a {
        display: inline-block;
        width: 72%;
        line-height: 20px;
        text-align: center;
        
        
        margin: 0 auto 10px;
        color: #0000ff;
    }
    .free_prop_box .prop_wrap .add_del_c .add_a{
    	background:url(http://i2.letvimg.com/lc02_pay/201605/06/11/17/a_btn.png) -4px -8px no-repeat;
    }
    .free_prop_box .prop_wrap .add_del_c .dele_a{
    	background:url(http://i2.letvimg.com/lc02_pay/201605/06/11/17/a_btn.png) -4px -37px no-repeat;
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
</style>

<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');

        //效果处理
        $('#batch_props_handle').on("click", "#prop_source tr, #prop_target tr", function () {
            $(this).toggleClass("checkedBox");
        });

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

        $.post("/props_live/add_toys.do", {liveId: liveId, type: type, pids: pids}, function (json) {
            if (json.code == 0) {
                refreshPropsForLive(json['data']);
                parent.$.messager.alert("提示", "添加成功！");
            }
            else {
                parent.$.messager.alert("提示", "添加失败！" + json.data);
            }
        }, "json");
    }
    //实现通过对话框删除已经选择的道具
    function deletePropsToys() {
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
    }

</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="" class="add_star">
        <input type="hidden" name="liveId" value="${liveId}">
        <input type="hidden" name="type" value="${type}">

        <div class="free_prop_box" id="batch_props_handle">
            <div class="prop_wrap">
                <div class="float_prop_wrap prop_list_wrap">
                    <h4 class="pro_title">已有道具</h4>

                    <div class="prop_list">
                        <table id="prop_target">
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
                <div class="add_del_c">
                    <a class="add_a" href="javascript:void (0);" onclick="addPropsToys();">添加</a>
                    <a class="dele_a" href="javascript:void (0);" onclick="deletePropsToys();">删除</a>
                </div>
                <div class="float_prop_wrap prop_list_wrap">
                    <h4 class="pro_title">所有道具&nbsp;&nbsp;&nbsp;&nbsp;
                        <a href="#" onclick="syncToys(${businessId});" style="font-size: 12px">同步</a>
                    </h4>

                    <div class="prop_list">
                        <table id="prop_source">
                            <c:forEach var="prop" items="${library}">
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

<%--
  Created by IntelliJ IDEA.
  User: kangxiongwei3
  Date: 2016/4/11
  Time: 16:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<script  src="/js/kv/propsBusiness.js"></script>
<script  src="/js/kv/propsChannel.js"></script>
<script  src="/js/kv/propsType.js"></script>
<script  src="/js/kv/propsOperateType.js"></script>
<%@ include file="/WEB-INF/views/inc/jstl.inc"%>

<style type="text/css">
    .table th {
        text-align: right;
    }
    .inp_w{
        width: 110px;
    }
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

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="" class="add_star">
        <form id="form" method="post" action="/props/operate/save">
            <input type="hidden" name="id" value="${propsOperate.id}">
            <table style="width: 100%" class="table table-form">
                <tr>
                    <th><b style="color: red">*</b>道具配置名称：</th>
                    <td>
                        <input name="name" value="${propsOperate.name}" class="span2, easyui-validatebox" data-options="required:true">&nbsp;&nbsp;
                    </td>
                </tr>
                <tr>
                    <th><b style="color: red">*</b>业务线：</th>
                    <td>
                        <%@ include file="/WEB-INF/views/inc/props_business.inc" %>
                        <%@ include file="/WEB-INF/views/inc/props_channel.inc" %>
                    </td>
                </tr>
                <tr>
                    <th><b style="color: red">*</b>方式：</th>
                    <td>
                        <input type="hidden" name="way" value="">
                        <input type="hidden" name="wayValue" value="">
                        <input type="radio" name="radio_way" value="1" checked />按渠道
                        <input type="radio" name="radio_way" value="2" <c:if test="${2 eq propsOperate.way}">checked</c:if>/>按运营分类
                        <input type="radio" name="radio_way" value="3" <c:if test="${3 eq propsOperate.way}">checked</c:if>/>按直播ID
                        <br>
                        <%@ include file="/WEB-INF/views/inc/props_operate_type.inc" %>
                        <input name="live_id" value="" class="span2, easyui-validatebox">&nbsp;&nbsp;
                    </td>
                </tr>
            </table>
            <div class="free_prop_box" id="batch_props_handle">
                <div class="prop_wrap">
                    <div class="float_prop_wrap prop_list_wrap">
                        <h4 class="pro_title">已有道具</h4>

                        <div class="prop_list">
                            <table id="prop_target">
                                <input type="hidden" name="toyIds" value="">
                                <c:forEach var="prop" items="${existToyList}">
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
                    道具分类： <%@ include file="/WEB-INF/views/inc/props_type.inc" %>
                    <div class="float_prop_wrap prop_list_wrap">

                        <div class="prop_list">
                            <table id="prop_source">
                                <%--<c:forEach var="prop" items="${library}">
                                    <tr>
                                        <td style="width: 30px">${prop.id}</td>
                                        <td style="width: 80px">${prop.codeName}</td>
                                        <td style="width: 40px">${prop.price}</td>
                                    </tr>
                                </c:forEach>--%>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>
<script type="text/javascript">

    //存储已经选择的道具id
    var addToyMap = {};

    $(function () {
        parent.$.messager.progress('close');

        init();

        //效果处理
        $('#batch_props_handle').on("click", "#prop_source tr, #prop_target tr", function () {
            $(this).toggleClass("checkedBox");
        });

        //initConfig();
        //disabledComponent();

        /**
         * 表单验证
         */
        $('#form').form({
            url: $('#form').attr("action"),
            onSubmit: function () {
                parent.$.messager.progress({
                    title: '${internationalConfig.提示}',
                    text: '${internationalConfig.数据处理中}....'
                });
                var isValid = $(this).form('validate');

                var errorMsg = validateConfig();
                if(errorMsg) {
                    parent.$.messager.alert('${internationalConfig.错误}', errorMsg, 'error');
                    parent.$.messager.progress('close');
                    return false;
                }

                if (!isValid) {
                    parent.$.messager.progress('close');
                }

                prepareData();

                return isValid;
            },
            success: function (result) {
                parent.$.messager.progress('close');
                result = $.parseJSON(result);
                if (result.code == 0) {
                    parent.$.messager.alert('${internationalConfig.成功}', '保存成功', 'success');
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
                }
            }
        });
    });

    /*function disabledComponent() {
        if ('${props.id}' && ${props.id} > 0) {
            $("#businessId").attr("readonly", "readonly");
            $("#businessId").attr("onfocus", "this.defaultIndex=this.selectedIndex");
            $("#businessId").attr("onchange", "this.selectedIndex=this.defaultIndex");
        }
    }
*/
    //初始化数据
    function init() {
        //初始化业务线
        var businessId = $("select[name=businessId]");
        <c:if test="${propsOperate.businessId > 0}">
        businessId.val('${propsOperate.businessId}');
        </c:if>
        businessId.trigger("change");

        //初始化渠道
        var channelId = $("select[name=channelId]");
        <c:if test="${propsOperate.channelId > 0}">
        channelId.val('${propsOperate.channelId}');
        </c:if>
        channelId.trigger("change");

        //初始化分类
        var typeId = $("select[name=typeId]");
        typeId.change(changeTypeEvent);
        typeId.trigger("change");

        //初始化方式的单选操作事件触发
        var radioWay = $("input[name=radio_way]");
        radioWay.click(changeWayEvent);
        radioWay.each(function(){
            if ($(this).attr("checked")) {
                $(this).trigger("click");
                var v = $(this).val();
                if (v == 2) {
                    //初始化运营类型
                    $("select[name=operateTypeId]").val('${propsOperate.wayValue}');
                } else if (v == 3) {
                    $("input[name=live_id]").val('${propsOperate.wayValue}');
                }
            }
        });



        //初始化已经选择的道具id
        <c:forEach var="prop" items="${existToyList}">
            var pid = ${prop.id};
            addToyMap[pid] = pid;
        </c:forEach>
    }

    //数据提交校验
    function validateConfig() {
        var msg = '';
        var name = $("input[name='name']").val();
        if (name != $.trim(name)) {
            return "道具配置名称不能为空或包含前后空格";
        }


        var v = $("input[name=radio_way]:checked").val();
        if (v==1) {
            var channelId = $("[name='channelId']").val();
            if (channelId == 0) {
                return "必须选择一个渠道";
            }
        }
        if (v==2) {
            var operateTypeId = $("[name='operateTypeId']").val();
            if (operateTypeId == 0) {
                return "必须选择一个运营分类";
            }
        }
        if (v==3) {
            var liveId = $("input[name=live_id]").val();
            if (liveId.length == 0) {
                return "直播ID必须输入";
            }
        }

        if (msg) {
            return msg;
        }
    }

    //分类绑定事件
    function changeTypeEvent() {
        var businessId = $("[name='businessId']").val();
        var channelId = $("[name='channelId']").val();
        var typeId = $("[name='typeId']").val();
        $.ajax({
            type: "GET",
            url: "/props/online_props",
            data: {"businessId":businessId, "channelId":channelId, "typeId":typeId},
            dataType: 'json',
            success: function(json){
                if(json.code == 0){
                    var table = $("#prop_source");
                    table.html("");
                    if ($.isEmptyObject(json.data)) return;
                    for(var row in json.data){
                        var trHtml = '<tr><td style="width: 30px">'+json.data[row].id+"</td>";
                        trHtml += '<td style="width: 80px">'+json.data[row].codeName+"</td>";
                        trHtml += '<td style="width: 40px">'+json.data[row].price+"</td></tr>";
                        table.append(trHtml);
                    }
                }else {
                    alert("获取道具列表失败");
                }
            }
        });
    }

    //方式绑定事件
    function changeWayEvent() {
        var operateTypeObj = $("[name='operateTypeId']");
        var liveIdObj = $("[name='live_id']");
        var v = $(this).val();
        if (v==1) {
            operateTypeObj.hide();
            liveIdObj.hide();
        } else if (v==2) {
            operateTypeObj.show();
            liveIdObj.hide();
        } else {
            operateTypeObj.hide();
            liveIdObj.show();
        }
    }


    //实现通过对话框添加道具
    function addPropsToys() {
        var trs = $("#prop_source").find(".checkedBox");
        if (trs.length == 0) {
            parent.$.messager.alert("提示", "请选择需要添加或者删除的道具");
            return false;
        }
        trs.each(function () {
            //console.log($(this).html());
            var pid = $(this).find("td:first").text();
            if (addToyMap[pid]) {
                //parent.$.messager.alert("提示", "已经添加该道具");
                return false;
            } else {
                $("#prop_target").append($(this).clone());
                addToyMap[pid] = pid;
            }
        });
    }
    //实现通过对话框删除已经选择的道具
    function deletePropsToys() {
        var trs = $("#prop_target").find(".checkedBox");
        if (trs.length == 0) {
            parent.$.messager.alert("提示", "请选择需要添加或者删除的道具");
            return false;
        }
        trs.each(function () {
            //console.log($(this).html());
            var pid = $(this).find("td:first").text();
            $(this).remove();
            delete addToyMap[pid]
        });
    }

    //提交保存前准备数据
    function prepareData() {
        var wayValue = $("input[name=wayValue]");
        var operateType = $("[name='operateTypeId']");
        var liveId = $("input[name=live_id]");

        //准备way值和wayValue值
        var v = $("input[name=radio_way]:checked").val();
        $("input[name=way]").val(v);
        if (v==1) {
            wayValue.val("");
        } else if (v==2) {
            wayValue.val(operateType.val());
        } else {
            wayValue.val(liveId.val());
        }
        //准备已选择道具id值
        var toyIds = "";
        for(var key in addToyMap) {
            if (toyIds != "") {
                toyIds += ",";
            }
            toyIds += key;
        }
        $("input[name=toyIds]").val(toyIds);
    }

</script>

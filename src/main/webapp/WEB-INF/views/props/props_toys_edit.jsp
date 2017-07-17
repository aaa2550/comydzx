<%--
  Created by IntelliJ IDEA.
  User: kangxiongwei3
  Date: 2016/4/14
  Time: 15:24
  Desc： 用来将直播对应的多个场景道具，明星道具设置为免费
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/inc/jstl.inc" %>

<style type="text/css">
    .add_star {
        padding: 20px;
        width: 300px;
        overflow: hidden;
        margin: 0 auto;
        border: 1px solid #CCCCCC;
        background-color: #F2F2F2;
        color: #333333;
    }

    .add_star table {
        width: 100%;
    }

    .add_star table tr {
        line-height: 30px;
    }

    .add_star table tr td {
        width: 25%;
    }

    .add_star table tr td .star_id {
        width: 150px;
        display: inline-block;
        border: 1px solid #ccc;
        color: #333;
        font-weight: bold;
        display: inline-block;
        line-height: 24px;
        background-color: #ffffff;
        padding: 0 10px;
        margin-right: 10px;
    }
    .add_star table tr td.start_img img {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        vertical-align: middle;
    }

    .add_star table a {
        display: inline-block;
        border: 1px solid #ccc;
        color: #333;
        font-weight: bold;
        display: inline-block;
        background-color: #f3f3f3;
        line-height: 24px;
        padding: 0 10px;
        width: 30px;
        text-align: center;
        margin-right: 10px;
    }

    .add_star .prop_intro textarea {
        width: 100%;
        display: inline-block;
        border: 1px solid #ccc;
        color: #333;
        font-weight: bold;
        display: inline-block;
        background-color: #f3f3f3;
        line-height: 24px;
        padding: 0;
    }

    .add_star dl dt {
        float: left;
        width: 50px;
        height: 50px;
        vertical-align: middle;
        padding: 10px;
    }

    .add_star dl dt img {
        width: 50px;
        height: 50px;
        border-radius: 50%;
    }

    .add_star dl dd {
        float: left;
        color: #ddd;
        padding: 20px 0 0 10px;
    }

    .free_prop_box {
        padding: 20px;
        width: 560px;
        overflow: hidden;
        margin: 0 auto;
        border: 1px solid #CCCCCC;
        background-color: #F2F2F2;
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

    .free_prop_box .prop_wrap .float_prop_wrap .pro_title i {
        color: #999999;
    }

    .free_prop_box .prop_wrap .float_prop_wrap .prop_list {
        width: 240px;
        height: 220px;
        overflow-y: scroll;
        border: 1px solid #CCCCCC;
    }

    .free_prop_box .prop_wrap .float_prop_wrap .prop_list table tr {
        height: 70px;
    }

    .free_prop_box .prop_wrap .float_prop_wrap .prop_list table tr td {
        height: 50px;
        width: 50px;
        position: relative;
        padding: 10px 0 0 10px;
    }

    .free_prop_box .prop_wrap .float_prop_wrap .prop_list table tr td img {
        width: 50px;
        height: 50px;
        border-radius: 50%;
    }

    .free_prop_box .prop_wrap .float_prop_wrap .prop_list table tr td input[type="checkbox"] {
        position: absolute;
        left: 50px;
        bottom: 10px;
    }

    .free_prop_box .prop_wrap .prop_list_wrap {
        width: 160px;
    }

    .free_prop_box .prop_wrap .prop_list_wrap .prop_list {
        width: 160px;
    }

    .free_prop_box .prop_wrap .add_del_c {
        width: 140px;
        float: left;
        padding-top: 50px;
        text-align: center;
    }

    .free_prop_box .prop_wrap .add_del_c a {
        display: inline-block;
        width: 70%;
        line-height: 18px;
        text-align: center;
        margin: 0 auto 10px;
        background-color: #F2F2F2;
        border: 1px solid #CCCCCC;
        color: #0000ff;
    }

    .free_prop_box .select_table {
        margin: 10px 0 0 20px;
        width: 100%;
    }
    .free_prop_box .select_table td a{
        margin: 0;
        padding: 0;
    }

</style>

<script type="text/javascript">

    Date.prototype.Format = function(fmt)
    { //author: meizz
        var o = {
            "M+" : this.getMonth()+1,                 //月份
            "d+" : this.getDate(),                    //日
            "h+" : this.getHours(),                   //小时
            "m+" : this.getMinutes(),                 //分
            "s+" : this.getSeconds(),                 //秒
            "q+" : Math.floor((this.getMonth()+3)/3), //季度
            "S"  : this.getMilliseconds()             //毫秒
        };
        if(/(y+)/.test(fmt))
            fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
        for(var k in o)
            if(new RegExp("("+ k +")").test(fmt))
                fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));
        return fmt;
    }

    $(function () {
        parent.$.messager.progress('close');

        /**
         * 表单验证
         */
        $('#form').form({
            url: '${pageContext.request.contextPath}/props_live/batch_update_free.do',
            onSubmit: function () {
                parent.$.messager.progress({
                    title: '${internationalConfig.提示}',
                    text: '${internationalConfig.数据处理中}....'
                });
                var isValid = $(this).form('validate');
                if (!isValid) {
                    parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.错误}", 'error');
                    parent.$.messager.progress('close');
                }
                return isValid;
            },
            success: function (result) {
                parent.$.messager.progress('close');
                result = $.parseJSON(result);
                if (result.code == 0) {
                    parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.操作成功}', 'success');
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
                }
            }
        });

        /**
         * 将已经选择的道具按照一行3个添加到对应表格中
         * @param target 目标节点
         * @param toys 所有道具数据
         * @param type 道具类型 scenePid表示场景道具， starPid表示明星道具
         */
        var toysHandler = function (target, toys, type) {
            var unify;
            //一共需要添加多少行
            for (var i = 0; i < Math.floor(toys.length / 3) + 1; i++) {
                var temp = $("<tr></tr>");
                var content = "";
                //每一行添加的列
                for (var j = 0; j < 3 && i * 3 + j < toys.length; j++) {
                    var index = i * 3 + j;
                    var element = toys[index];
                    if (element['freeCount']>0 && !unify) {
                        unify = element;
                    }
                    var pic = "";
                    if ($.parseJSON(element['config'])['web'].pic) {
                        pic = $.parseJSON(element['config'])['web'].pic;
                    } else if ($.parseJSON(element['config'])['mobile'].pic) {
                        pic = $.parseJSON(element['config'])['mobile'].pic;
                    } else {
                        $.parseJSON(element['config'])['tv'].pic
                    }
                    content += $.formatString("<td><img src='{0}' onclick='chooseProp(this);'><input onclick='chooseCheck(this)' type='checkbox' name='{1}' value='{2}' "+(element['freeCount']>0?"checked='true'":"")+"></td>", pic, type, element['id']);
                }
                target.append(temp.html(content));
            }
            if (unify) {
                if (unify.startFreeTime && unify.endFreeTime) {
                    var startFreeTime = new Date(unify.startFreeTime).format("yyyy-MM-dd hh:mm:ss");
                    var endFreeTime = new Date(unify.endFreeTime).format("yyyy-MM-dd hh:mm:ss");
                    $("#startFreeTime").datetimebox('setValue', startFreeTime);
                    $("#endFreeTime").datetimebox('setValue', endFreeTime);
                }
                $("#freeCount").numberbox('setValue', unify.freeCount);
            }
        };

        /**
         * 从后台获取场景道具和明星道具信息
         */
        var initToys = function (liveId) {
            $.post("/props_live/get_toys_info.do", {liveId: liveId}, function (json) {
                var data = $.parseJSON(json.data);
                //场景道具部分
                toysHandler($("#sceneToys"), data['sceneToys'], "scenePid");
                toysHandler($("#starToys"), data['starToys'], "starPid");
            }, "json");
        };

        initToys($("input[name='liveId']").val());

    });

    /**
     * 点击图片时，多选框对应状态切换
     * 并验证已经选中的元素数量是否<=3个
     */
    function chooseProp(ele){
        var box = $(ele).next("input[type=checkbox]");
        if($(ele).parents('table').find(':checked').length>2){
        	box.prop("checked",false)
        	return
        }
       
        //如果被选中，移除checked属性，否则增加该属性
        box.prop("checked")?box.prop("checked", false):box.prop("checked", true);
        return;
    }
    function chooseCheck(ele){
    	//alert(ele);
    	//alert($(ele).parents('table').find(":checked").length);
    	if($(ele).parents('table').find(":checked").length>3){
    		$(ele).prop('checked',false);
    	
    	}
    }

</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="" class="add_star free_prop_box">
        <form id="form" method="post" action="/props_live/batch_update_free.do">
            <input type="hidden" name="liveId" value="${liveId}">
            <div class="prop_wrap">
                <div class="float_prop_wrap">
                    <h4 class="pro_title">场景道具 <i>（最多三个）</i></h4>
                    <div class="prop_list">
                        <table id="sceneToys">
                        </table>
                    </div>
                </div>
                <div class="float_prop_wrap">
                    <h4 class="pro_title">明星道具 <i>（最多三个）</i></h4>
                    <div class="prop_list">
                        <table id="starToys">
                        </table>
                    </div>
                </div>
            </div>
            <table class="select_table">
                <tr>
                    <td><input id="freeCount" name="freeCount" type="text" class="easyui-numberbox star_id" data-options="precision:0"></td>
                    <td colspan="2">免费数量</td>
                </tr>
            </table>
        </form>
    </div>
</div>

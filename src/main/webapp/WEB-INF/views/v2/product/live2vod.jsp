<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:if test="${not empty param.singlePage}">
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
</c:if>

<style>
    .stbl{
        width: 100%;
    }
    td {
        padding: 5px;
    }
    .lable{
        margin-right: 10px;
    }
    .button1{
        width: 120px !important;
    }
    .long_input{
        width: 180px;
        padding-top: 0px !important;
        padding-bottom: 0px !important;
    }
    .mid_input{
        width: 130px;
        padding-top: 0px !important;
        padding-bottom: 0px !important;
    }
    .short_input{
        width: 100px;
        padding-top: 0px !important;
        padding-bottom: 0px !important;
    }
</style>
<c:if test="${not empty activity && not empty activity.copywritings}">
    <c:set var="copywritings" value="${activity.parsedCopywritings}"/>
</c:if>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="">
        <form id="form" method="post" name = "liveVideoForm"
              action="/v2/product/sport_live/live2vod?extendId=${live.extendId}">
            <div style="margin: 5px;">
                <h5>${internationalConfig.直播后台透传信息}</h5>
            </div>
            <div style="margin: 5px;">
                <table class="stbl">
                    <tr>
                        <td>${internationalConfig.场次ID}:</td>
                        <td><input type="text" value="${live.extendId}" readonly="readonly" class="long_input"></td>
                        <td>${internationalConfig.直播名称}:</td>
                        <td><input type="text" value="${fn:replace(live.name, '\"', '&quot;')}" readonly="readonly" class="long_input"></td>
                    </tr>
                    <tr>
                        <td>${internationalConfig.直播频道}:</td>
                        <c:forEach var="channel" items="${channels}">
                            <c:if test="${channel.type==live.liveType}"><c:set var="channelName" value="${internationalConfig[channel.name]}"/></c:if>
                        </c:forEach>
                        <td><input type="text" value="${channelName}" readonly="readonly" class="long_input"></td>
                        <td>${internationalConfig.直播类型}:</td>
                        <td><input type="text" id="liveClass" value="${liveClass}" readonly="readonly" class="long_input"></td>
                    </tr>
                </table>
            </div>
            <hr style="border-top: dotted 1px;" />
            <div style="margin: 5px;">
                <table id="configTable" width="100%">
                    <tr>
                        <td colspan="2"><h5>${internationalConfig.配置直转点信息}</h5></td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td colspan="2" align="right"><input type="button" value="${internationalConfig.添加}" class="button1 shortcut-item boss-btn" onclick="addNewConfigLine()"></td>
                    </tr>
                    <tr>
                        <td>${internationalConfig.序号}</td>
                        <%--<td><b style="color: red">*</b>${internationalConfig.关联点播类型}</td>--%>
                        <td><b style="color: red">*</b>${internationalConfig.专辑ID}</td>
                        <td><b style="color: red">*</b>${internationalConfig.直转点开始时间}</td>
                        <td><b style="color: red">*</b>${internationalConfig.直转点有效期}(${internationalConfig.天})</td>
                        <td>${internationalConfig.创建时间}</td>
                        <td>&nbsp;</td>
                    </tr>
                    <c:set var="configCount" value="${0}"/>
                    <c:forEach var="i" items="${live2vodConfigs}" varStatus="varStatus">
                        <tr>
                            <td>${varStatus.count}</td>
                            <%--<td><select disabled="disabled" class="mid_input">
                                    <option value="">${internationalConfig.关联点播类型}</option>
                                    <option value="1" <c:if test="${i.relatedVodType==1}">selected</c:if>>${internationalConfig.关联VID}</option>
                                    <option value="2" <c:if test="${i.relatedVodType==2}">selected</c:if>>${internationalConfig.关联PID}</option>
                                </select>
                            </td>--%>
                            <td><input type="text" value="${i.relatedVodId}" class="mid_input" disabled> </td>
                            <td><input type="text" value="<fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${i.startTime}"/>" class="mid_input" disabled></td>
                            <td><input type="text" value="${i.validDays}" class="short_input" disabled></td>
                            <td><input type="text" value="<fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${i.createdTime}"/>" class="mid_input" disabled></td>
                            <td>&nbsp;</td>
                        </tr>
                        <c:set var="configCount" value="${varStatus.count}"/>
                    </c:forEach>
                </table>
            </div>
            <div style="margin: 5px;">
                ${internationalConfig.直转点管理_说明}
            </div>
        </form>
    </div>
</div>
<script type="text/javascript">
    var configLineIndex = 0;
    $(document).ready(function () {
        parent.$.messager.progress('close');

        if($("#configTable tr").length==2) {
            addNewConfigLine();
        }

        $('#form').form({
            url : '/v2/product/sport_live/live2vod?extendId=${live.extendId}',
            onSubmit : function() {
                parent.$.messager.progress({
                    title : '${internationalConfig.提示}',
                    text : '${internationalConfig.数据处理中}....'
                });
                var isValid = $(this).form('validate');
                if (!isValid) {
                    parent.$.messager.progress('close');
                }

                return isValid;
            },
            success : function(result) {
                parent.$.messager.progress('close');
                result = $.parseJSON(result);
                if (result.code == 0) {
                    parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.编辑成功}', 'success');
                    parent.$.modalDialog.handler.dialog('close');
                    //parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                } else {
                    parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
                }
            },
            error: function(result){
                parent.$.messager.progress('close');
                parent.$.messager.alert('${internationalConfig.错误}', result, 'error');
            }
        });
    });

    function addNewConfigLine() {
        var table = $("#configTable");
        var index = table.find("tr").length - 2;
        var row = $("<tr>");
        table.append(row);

        var td0 = $("<td>");
        row.append(td0);
        var indexSpan=$('<span>');
        indexSpan.text(index+1);
        td0.append(indexSpan);
        td0.append($('<input type="hidden" name="configs['+configLineIndex+'].extendId" value="${live.extendId}">'));

        /*var td1 = $("<td>");
        row.append(td1);
        var select = $('<select name="configs['+configLineIndex+'].relatedVodType" class="mid_input easyui-validatebox" data-options="required:true">');
        select.append($("<option>", {value:'',text:'${internationalConfig.关联点播类型}'}));
        select.append($("<option>", {value:'1',text:'${internationalConfig.关联VID}'}));
        select.append($("<option>", {value:'2',text:'${internationalConfig.关联PID}'}));
        $.parser.parse(td1.append(select));*/

        var td1 = $("<td>");
        row.append(td1);
        var input = $('<input type="text" name="configs['+configLineIndex+'].relatedVodId" class="mid_input easyui-validatebox" data-options="required:true" onchange="doTrimInput(this)">')
        $.parser.parse(td1.append(input));

        var td2 = $("<td>");
        row.append(td2);
        var input2 = '<input name="configs['+configLineIndex+'].startTime" class="mid_input easyui-datetimebox" data-options="required:true">';
        $.parser.parse(td2.append(input2));

        var td3 = $("<td>");
        row.append(td3);
        var input3 = $('<input type="text" name="configs['+configLineIndex+'].validDays" class="easyui-validatebox easyui-numberbox short_input" precision="0" data-options="required:true,min:1">');
        $.parser.parse(td3.append(input3));

        var td3 = $("<td>");
        row.append(td3);
        var input4 = $('<input type="text" class="mid_input easyui-validatebox" disabled="disabled">');
        $.parser.parse(td3.append(input4));

        var td4 = $("<td>");
        row.append(td4);
        td4.append($($.formatString('<img onclick="removeRow(this);" src="/static/style/images/extjs_icons/cancel.png" title="${internationalConfig.删除}"/>')));

        configLineIndex++;
    }
    function removeRow(img) {
        var row = $(img).parent().parent();
        var table = row.parent();
        var nextRow = row.next();
        row.remove();
        while (!$.isEmptyObject(nextRow)&&nextRow.length!=0) {
            var rowIndexSpan = nextRow.find('td:first').find("span");
            var newRowIndex = parseInt(rowIndexSpan.text()) - 2;
            rowIndexSpan.text(newRowIndex+1);
            /*var inputs = nextRow.find('input,select');
            inputs.each(function () {
                var _self = $(this);
                if (_self.attr('name'))
                    _self.attr('name', _self.attr('name').replace(/\d+/,newRowIndex));
            });*/
            nextRow = nextRow.next();
        }
        //configLineIndex--;
    }
    function doTrimInput(input){
        input.value=$.trim(input.value);
    }
</script>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/inc/head.inc" %>
<style>
    .bg{
        background-color: #F0F0F0;
        overflow-scrolling: auto;
    }
    .content-block {
        /*width: 100%;*/
        margin: 5px;
        background-color: white;
    }
    .header-table th, .header-table td{
        border: 0;
        vertical-align: middle;
        padding: 5px;
        font-size:12px;
    }
    .header-table td object{
        vertical-align: middle;
    }
    .footerissticky{
        background-color: #F0F0F0;
        position: fixed;
        bottom: 0px;
        width: 100%;
    }
</style>
<script src="/static/lib/swfupload/swfupload.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
    var vipTypes={<c:forEach items="${vipTypes}" var="type">"${type.id}":"${type.name}",</c:forEach>};
    var vipDurations={<c:forEach items="${vipDurations}" var="duration">"${duration.id}":"${duration.durationName}",</c:forEach>};
    $(function() {
        parent.$.messager.progress('close');
        function renderDatagrid1(url) {
            $('#dataGrid1').datagrid({
                url : url,
                fit : true,
                queryParams:"",
                fitColumns : true,
                border : false,
                method:"GET",
                pagination : false,
                idField : 'id',
                checkOnSelect : false,
                selectOnCheck : false,
                nowrap : false,
                striped : true,
                rownumbers : true,
                singleSelect : true,
                sortName: 'weight',
                sortOrder: 'desc',
                columns : [[
                    {
                        field : 'id',
                        title : '${internationalConfig.套餐ID}',
                        width : 50,
                        align: 'right',
                        sortable : false
                    },{
                        field : 'packageName',
                        title : '${internationalConfig.套餐名称}',
                        width : 100,
                        sortable : false
                    },{
                        field : 'name',
                        title : '${internationalConfig.会员名称}',
                        width : 100,
                        sortable : false
                    },{
                        field : 'durationId',
                        title : '${internationalConfig.会员时长}',
                        width : 50,
                        sortable : false,
                        formatter : function(value) {
                            return vipDurations[value];
                        }
                    },{
                        field : 'status',
                        title : '${internationalConfig.套餐状态}',
                        width : 50,
                        sortable : false,
                        formatter : function(value) {
                            return value == 1 ? "${internationalConfig.未发布}" : "${internationalConfig.已发布}";
                        }
                    },{
                        field : 'terminal',
                        title : '${internationalConfig.终端}',
                        width : 100,
                        formatter : function(value) {
                            var terminal={<c:forEach var="terminal" items="${terminals}">"${terminal.terminalId}":"${terminal.terminalName}",</c:forEach>};
                            if(value!=null){
                                var s=value.split(",");
                                var array=new Array();
                                for(var a in s){
                                    array.push(terminal[s[a]]);
                                }
                                return array.join(",");
                            }else{
                                return "";
                            }
                        }

                    },{
                        field : 'price',
                        title : '${internationalConfig.价格}',
                        align: "right",
                        width : 50,
                        sortable : false

                    },{
                        field : 'weight',
                        title : '${internationalConfig.操作}',
                        width : 100,
                        formatter : function(value, row, index) {
                            var str = $.formatString('<a href="javascript:void(0)" onclick="removePackage({0},{1})">移除</a>',row.id,index);
                            str += $.formatString('&nbsp;&nbsp;&nbsp;&nbsp;<img src="/static/style/images/extjs_icons/arrow/arrow_up.png" onclick="incrPriority({0},{1})">',row.id,index);
                            return str;
                        }
                    } ] ],
                onLoadSuccess : function() {
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
        };
        renderDatagrid1("/v2/product/packageGroup/${packageGroup==null?0:packageGroup.id}/packages?_t="+ (new Date()).getTime());
    });
    function newCommonUploadBtn(buttonId,inputId,previewId){
        new SWFUpload({
            button_placeholder_id: buttonId,
            flash_url: "/static/lib/swfupload/swfupload.swf?rt=" + Math.random(),
            upload_url: '/upload?cdn=sync',
            button_image_url: Boss.util.defaults.upload.button_image,
            button_cursor: SWFUpload.CURSOR.HAND,
            button_action: SWFUpload.BUTTON_ACTION.SELECT_FILE,
            file_size_limit: '8 MB',
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
                response=response.replace("http://","https://");
                if (previewId) {
                    var HTML_VIEWS = '<a href=' + response + ' target="_blank">${internationalConfig.查看图片}</a>&nbsp;&nbsp;&nbsp;&nbsp;';
                    $("#" + previewId).html(HTML_VIEWS);
                }
                $("#"+inputId).val(response);
            },
            file_queued_handler: function () {
                this.startUpload();
            },
            upload_error_handler: function (file, code, msg) {
                var message = '${internationalConfig.UploadFailed}' + code + ': ' + msg + ', ' + file.name;
                alert(message);
            }
        });
    }
    $(document).ready(function(){
        newCommonUploadBtn('imageUrlUploadBtn','imageUrl', 'imagePreviewSpan');
    });
    $.extend($.fn.validatebox.defaults.rules, {
        onlyHttpsUrl : {
            validator : function(value, param) {
                return value.substring(0,8).toLowerCase() == 'https://';
            },
            message : '${internationalConfig.图片URL必须是HTTPS开头}'
        }
    });
    function removePackage(packageId,index){
        $.messager.confirm("${internationalConfig.警告}", "${internationalConfig.是否移除该套餐}",function(r) {
            if (r) {
                var dg = $('#dataGrid1');
                dg.datagrid('deleteRow',index);
                var rows = dg.datagrid("getRows");
                for (var i = 0; i < rows.length; i++){
                    rows[i].weight = rows.length - i;
                }
                dg.datagrid("sort", {sortName:'weight',sortOrder:'desc',remoteSort:false});
            }
        });
    }
    function incrPriority(packageId,index){
        if (index>0){
            var dg = $('#dataGrid1');
            var rows = dg.datagrid("getRows");
            if (rows[index].weight >= rows[index-1].weight) {
                for (var i = 0; i < rows.length; i++){
                    rows[i].weight = rows.length - i;
                }
            }
            var tmp = rows[index].weight;
            rows[index].weight = rows[index - 1].weight;
            rows[index - 1].weight = tmp;
            dg.datagrid("sort", {sortName:'weight',sortOrder:'desc',remoteSort:false});
        }
    }
    $(function(){
        $('#form').form({
            url : '/v2/product/packageGroup/save',
            method: 'POST',
            onSubmit : function() {
                var isValid = $(this).form('validate');
                if (!isValid) {
                    return isValid;
                }
                var hiddenDiv = $('#hiddens');
                hiddenDiv.empty();
                $.each($('#dataGrid1').datagrid("getRows"), function(i) {
                    var packageHtml = $.formatString('<input type="hidden" name="packages[{0}].packageId" value="{1}">', i, this.id);
                    packageHtml += $.formatString('<input type="hidden" name="packages[{0}].weight" value="{1}">', i, this.weight);
                    hiddenDiv.append($(packageHtml));
                })
                parent.$.messager.progress({
                    title : '${internationalConfig.提示}',
                    text : '${internationalConfig.数据处理中}....'
                });
                return true;
            },
            success : function(result) {
                parent.$.messager.progress('close');
                result = $.parseJSON(result);
                if (result.code == 0) {
                    var groupId = $("#form input[name=id]");
                    var msg = groupId.val()==''?'${internationalConfig.添加成功}':'${internationalConfig.编辑成功}';
                    parent.$.messager.alert('${internationalConfig.成功}', msg, 'success');
                    groupId.val(result.data);
                    parent.$('.tabs .tabs-selected .tabs-close').trigger("click");
                    parent.$.modalDialog.handler.dialog('close');
                } else{
                    parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
                }
            }
        });
    });
    function save(){
        $('#form').submit();
    }
    function closeTab(){
        parent.$('.tabs .tabs-selected .tabs-close').trigger("click");
    }
</script>
</head>
<body>
    <div class="bg" style="margin-bottom: 30px;">
        <form id="form" method="post" action="/v2/product/packageGroup/save">
            <div id="hiddens"></div>
            <input type="hidden" name="id" value="${packageGroup.id}" />
            <div class="content-block">
                <table class="header-table">
                    <tr>
                        <td width="100px"><b style="color: red">*</b>${internationalConfig.套餐分组名称}</td>
                        <td width="240px"><input type="text" id= "groupName"  name="groupName" value="${fn:replace(packageGroup.groupName, '\"', '&quot;')}" class="easyui-validatebox"
                                   maxlength="50" data-options="required:true,"/> <span id="message" style="color: red;font-size: 12px"></span></td>
                        <td width="100px">${internationalConfig.分组头图}</td>
                        <td>
                            <input type="text" name="imageUrl" id="imageUrl" value="${packageGroup.imageUrl}" class="easyui-validatebox" validType="onlyHttpsUrl">&nbsp;&nbsp;
                            <input class="buttoncenter" type="button" value="${internationalConfig.上传文件}" id="imageUrlUploadBtn">&nbsp;&nbsp;
                            <span id="imagePreviewSpan" name="img-mobile" ><c:if test="${not empty packageGroup.imageUrl}">
                                <a href="${packageGroup.imageUrl}" target="_blank">${internationalConfig.查看图片}</a>
                            </c:if>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td><b style="color: red">*</b>${internationalConfig.分组状态}</td>
                        <td><select name="status" style="width:155px">
                            <c:choose>
                                <c:when test="${packageGroup.status == 1}">
                                    <option value="1" selected="selected">${internationalConfig.未发布}</option>
                                    <option value="3">${internationalConfig.已发布}</option>
                                </c:when>
                                <c:when test="${packageGroup.status == 3}">
                                    <option value="1">${internationalConfig.未发布}</option>
                                    <option value="3" selected="selected">${internationalConfig.已发布}</option>
                                </c:when>
                                <c:otherwise>
                                    <option value="3" selected="selected">${internationalConfig.已发布}</option>
                                    <option value="1">${internationalConfig.未发布}</option>
                                </c:otherwise>
                            </c:choose>
                        </select></td>
                        <td>${internationalConfig.套餐分组描述}</td>
                        <td><input type="text" id="groupDesc" name="groupDesc" style="width: 260px;" value="${fn:replace(packageGroup.groupDesc, '\"', '&quot;')}"></td>
                    </tr>
                </table>
            </div>
            <div style="margin-top: 15px; margin-bottom:5px;"><h5 style="margin-left: 10px">${internationalConfig.编辑分组内套餐}</h5></div>

            <div class="easyui-layout" data-options="fit : true,border : false" style="height: 50px">
                <div data-options="region:'center',border:false">
                    <table id="dataGrid1"></table>
                </div>
            </div>
        </form>

        <div style="margin:5px">
            <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'pencil_add',plain:true" onclick="displaySearchingDiv();">${internationalConfig.新增组内套餐}</a>
        </div>

        <%@include file="vip_package_for_select.inc"%>
    </div>
    <div class="footerissticky">
        <div style="float:right;margin-right:20px;">
            <input type="button" value="${internationalConfig.保存}" class="shortcut-item boss-btn" onclick="save()">
            &nbsp;
            <input type="button" value="${internationalConfig.取消}" class="shortcut-item boss-btn" onclick="closeTab()">
        </div>
    </div>
</body>
</html>

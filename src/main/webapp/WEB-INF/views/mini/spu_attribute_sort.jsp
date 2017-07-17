<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/inc/jstl.inc"%>

<script type="text/javascript">
    var dataGrid;
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
        getDate();
        $(".refresh").click(function () {
            getDate();
        });
        //dataGrid = renderDataGrid('/mini/spu/list_spu_attr?spuId=${spuId}');
    })(jQuery)
    function getDate() {
        var data = new Array();
        $.ajax({
            url : '/mini/spu/list_spu_attr?spuId=${spuId}',
            type : "get",
            dataType : "json",
            success : function(res) {
                for(var i=0;i<res.length;i++){
                    var list = {};
                        list.attributeItemId = res[i].attributeId;
                        list.attributeItemName = res[i].attributeName;
                        list.attributeItemSort = res[i].attributeSort;
                        list.parent = 1;
                        data.push(list);
                    for(var j in res[i].spuAttributeItemList) {
                        list = {};
                        list.attributeItemId = res[i].spuAttributeItemList[j].attributeItemId;
                        list.attributeItemName = res[i].spuAttributeItemList[j].attributeItemName;
                        list.attributeItemSort = res[i].spuAttributeItemList[j].attributeItemSort;
                        list.parent = 0;
                        data.push(list);
                    }
                }
                dataGrid = renderDataGrid(data);
            }
        })
    }
    function sortAttr(index) {
        $('#dataGrid').datagrid('beginEdit', index);
        $(".textbox-text").keyup(function () {
            this.value=this.value.replace(/[^\d]/g,'')
        })
    }
    function saveSort(index) {
        $('#dataGrid').datagrid('endEdit', index);
    }
    function cancelSort(index) {

        $('#dataGrid').datagrid('cancelEdit', index);
    }
    function renderDataGrid(data, method) {
        return $('#dataGrid')
                .datagrid(
                        {
                            fit : true,
                            data : data,
                            fitColumns : true,
                            border : false,
                            method : method || 'post',
                            pagination : false,
                            idField : 'id',
                            sortName : 'pk_agg_package',
                            sortOrder : 'desc',
                            nowrap : false,
                            striped : true,
                            rownumbers : true,
                            singleSelect : true,
                            columns : [ [
                                {
                                    field : 'attributeItemName',
                                    title : '销售属性名称',
                                    width : 100,
                                    sortable : false,
                                    formatter : function(val, row, index) {
                                        if (row.parent){
                                            var s = '<img src="/static/style/images/extjs_icons/folder/folder.png"/> ';
                                            var c = '<span>'+val+'</span>';
                                            return s+c;
                                        } else {
                                            var e = '<span style="padding-left: 30px">'+val+'</span>';
                                            return e;
                                        }
                                    }

                                },
                                {
                                    field : 'attributeItemSort',
                                    title : '排序值',
                                    width : 100,
                                    sortable : false,
                                    editor:{
                                        type:"numberbox",
                                        options:{
                                            min :0,
                                            max:99999,
                                            precision:0,
                                            required: true
                                        }
                                    }
                                },
                                {
                                    field : 'action',
                                    title : '${internationalConfig.操作}',
                                    width : 80,
                                    formatter : function(val, row, index) {
                                        if (row.editing){
                                            var s = '<a href="javascript:void(0)" onclick="saveSort('+index+')">保存</a> ';
                                            var c = '<a href="javascript:void(0)" onclick="cancelSort('+index+')">取消</a>';
                                            return s+c;
                                        } else {
                                            var e = '<a href="javascript:void(0)" onclick="sortAttr('+index+')">排序</a> ';
                                            return e;
                                        }
                                    }
                                } ] ],
                            toolbar : '#toolbar',
                            onBeforeEdit:function(index,row){
                                row.editing = true;
                                $('#dataGrid').datagrid('refreshRow', index);
                            },
                            onAfterEdit:function(index,row,changes){
                                if(changes.attributeItemSort!=undefined&&changes.attributeItemSort!=""){
                                    row.editing = false;
                                    if(row.parent==1){
                                        $.ajax({
                                            url : '/mini/spu/save_spu_attr_sort?spuId=${spuId}&attributeId='+row.attributeItemId+'&sortValue='+changes.attributeItemSort,
                                            type : "get",
                                            dataType : "json",
                                            success : function(res) {
                                                if(res.code==0){
                                                    $('#dataGrid').datagrid('refreshRow', index);
                                                }else{
                                                    parent.$.messager.alert('${internationalConfig.错误}', res.msg, 'error');
                                                }
                                            }
                                        });
                                    }else{
                                        $.ajax({
                                            url : '/mini/spu/save_spu_attr_sort?spuId=${spuId}&attributeItemId='+row.attributeItemId+'&sortValue='+changes.attributeItemSort,
                                            type : "get",
                                            dataType : "json",
                                            success : function(res) {
                                                if(res.code==0){
                                                    $('#dataGrid').datagrid('refreshRow', index);
                                                }else{
                                                    parent.$.messager.alert('${internationalConfig.错误}', res.msg, 'error');
                                                }
                                            }
                                        });
                                    }
                                }else{
                                    row.editing = false;
                                    $('#dataGrid').datagrid('refreshRow', index);
                                }

                            },
                            onCancelEdit:function(index,row){
                                row.editing = false;
                                $('#dataGrid').datagrid('refreshRow', index);
                            }
                        });
    }
</script>
<style>
    .info{height: 30px;line-height: 30px;padding: 0 10px;background: #ffffcc;font-family: "Microsoft YaHei", arial;font-size: 14px;}
    .refresh{float: right;}
</style>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false">
        <p class="info">排序值越小，排序越靠前，排在第一位的为主销售属性<a href="javascript:;" class="refresh">刷新</a></p>
            <input type="hidden" name="id" value="${attribute.id}">
            <table id="dataGrid" style="width: 100%"></table>
    </div>
</div>

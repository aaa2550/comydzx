<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<div id="searchingDiv" class="easyui-layout" data-options="fit : true,border : false" style="height:65px">
    <div data-options="bodyCls:'boss_common_scroll',region:'north',border:false,height:'80px'">
      <form id="searchForm">
        <table class="table-more">
          <tr>
              <td colspan="4"><h5>${internationalConfig.筛选会员套餐}</h5></td>
          </tr>
          <tr>
            <td>${internationalConfig.套餐ID}:&nbsp;
                <input type="text" name="id" class="easyui-numberbox">
            </td>
            <td>${internationalConfig.会员名称}:&nbsp;<select class="span2" name="typeId">
                <option value="-1" selected="selected">${internationalConfig.全部}</option>
                <c:forEach items="${vipTypes}" var="packageType">
                  <option value="${packageType.id}">${packageType.name}</option>
                 </c:forEach>
            </select></td>
              <td>${internationalConfig.会员时长}:&nbsp;
                  <select name="durationId">
                      <option value="0">${internationalConfig.全部}</option>
                      <c:forEach var="duration" items="${vipDurations}">
                          <option value="${duration.id}">${duration.durationName}</option>
                      </c:forEach>
                  </select>
              </td>
            <td>${internationalConfig.状态}:&nbsp;<select class="span2" name="status">
                <option value="0" selected="selected">${internationalConfig.全部}</option>
                <option value="1">${internationalConfig.未发布}</option>
                <option value="3">${internationalConfig.已发布}</option>
                <%-- <c:forEach items="${statuses}" var="status">
                  <option value="${status.id}">${status.description}</option>
                </c:forEach> --%>
            </select></td>
          </tr>
        </table>
      </form>
    </div>
    <div data-options="region:'center',border:false">
      <table id="dataGrid2"></table>
    </div>
  </div>
  <div id="toolbar" style="display: none;">
    <a href="javascript:void(0);" class="easyui-linkbutton"
      data-options="iconCls:'brick_go',plain:true" onclick="searchFun();">${internationalConfig.筛选}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">${internationalConfig.清空条件}</a>
  </div>

<script type="text/javascript">
    $(function() {
        $.fn.serializeJson=function(){

            var serializeObj={};
            var array=this.serializeArray();
            // var str=this.serialize();
            $(array).each(function(){ // 遍历数组的每个元素 {name : xx , value : xxx}
                if(serializeObj[this.name]){ // 判断对象中是否已经存在 name，如果存在name
                    /* if($.isArray(serializeObj[this.name])){
                     serializeObj[this.name].push(this.value); // 追加一个值 hobby : ['音乐','体育']
                     }else{
                     // 将元素变为 数组 ，hobby : ['音乐','体育']
                     serializeObj[this.name]=[serializeObj[this.name],this.value];
                     }  */
                    serializeObj[this.name]+=","+this.value;
                }else{
                    serializeObj[this.name]=this.value; // 如果元素name不存在，添加一个属性 name:value
                }
            });
            return serializeObj;
        };
        $('#searchingDiv').hide();
    });
    function displaySearchingDiv(){
        $('#searchingDiv').show();
        renderDataGrid2('/v2/product/vipPackage/dataGrid');
    }

    function renderDataGrid2(url,data,method) {
        return $('#dataGrid2').datagrid({
                            url : url,
                            fit : true,
                            queryParams:data||"",
                            fitColumns : true,
                            border : false,
                            method:method||'post',
                            pagination : true,
                            idField : 'id',
                            pageSize : 10,
                            pageList : [ 10,20,50,100 ],
                            sortName: "id",
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
                                width : 150,
                                hidden : true
                            } ] ],
                            columns : [[{
                                field : 'id',
                                title : '${internationalConfig.套餐ID}',
                                width : 50,
                                align : 'right',
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
                                width : 100,
                                sortable : false,
                                formatter : function(value) {
                                    return vipDurations[value];
                                }
                            },{
                                field : 'status',
                                title : '${internationalConfig.套餐状态}',
                                width : 100,
                                sortable : false,
                                formatter : function(value) {
                                    return value == 1 ? "${internationalConfig.未发布}" : "${internationalConfig.已发布}";
                                }
                            },{
                                field : 'terminal',
                                title : '${internationalConfig.终端}',
                                width : 150,
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
                                field : 'action',
                                title : '${internationalConfig.操作}',
                                width : 100,
                                formatter : function(value, row, index) {
                                    var html=$.formatString('<a href="javascript:void(0)" onclick="addToGroup({0})">${internationalConfig.添加}</a>',index);
                                    return html;
                                }
                            } ] ],
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

    function searchFun() {
        parent.$.messager.progress({
            title : '${internationalConfig.提示}',
            text : '${internationalConfig.数据处理中}....'
        });
        renderDataGrid2('/v2/product/vipPackage/dataGrid?loadGroupInfo=false',$('#searchForm').serializeJson(),"get");
        parent.$.messager.progress('close');
    }
    function cleanFun() {
        $('#searchForm input').val('');
        $("#searchForm select").each(function(){
            var _self=$(this);
            _self.val(_self.find("option:first").val());
        });
        renderDataGrid('/v2/product/vipPackage/dataGrid?loadGroupInfo=false');
    }
    function addToGroup(index){
        var newRow=$('#dataGrid2').datagrid('getRows')[index];
        var dg1=$('#dataGrid1');
        var dg1Rows=dg1.datagrid('getRows');
        for (var i in dg1Rows){
            if (dg1Rows[i].id==newRow.id){
                parent.$.messager.alert("${internationalConfig.错误}","${internationalConfig.同一套餐不能重复添加}", 'error');
                return;
            }
        }
        $.messager.confirm("${internationalConfig.警告}", "${internationalConfig.是否添加该套餐}",function(r) {
            if (r) {
                var dg1 = $('#dataGrid1');
                newRow.weight = 1;
                dg1.datagrid('appendRow',newRow);
                for(var i in dg1Rows){
                    dg1Rows[i].weight=dg1Rows.length-i;
                }
            }
        });

    }
</script>
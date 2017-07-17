<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.乐卡申请}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript" src="/js/dict.js"></script>
<script type="text/javascript" src="/js/kv/channelAssociation.js"></script>
<script type="text/javascript">
<m:auth uri="/lecard/freeze.json">  $.canfreeze = true;</m:auth>
<m:auth uri="/lecard/view.do">  $.canView = true;</m:auth>
<m:auth uri="/lecard/exportexcel.do">  $.canExport = true;</m:auth>

var applyType ={
    1:"${internationalConfig.充值码}",2:"${internationalConfig.兑换码}",3:"${internationalConfig.老充值码}",
    4:"${internationalConfig.超级手机兑换码}",5:"${internationalConfig.兑换码}2.0",6:"${internationalConfig.机卡兑换码}2.0",
    10:"${internationalConfig.直播赛事兑换码}",11:"${internationalConfig.直播场次兑换码}",20:"${internationalConfig.音乐兑换码}",
    30:"${internationalConfig.影视剧兑换码}",40:"${internationalConfig.组合套餐兑换码}",50:"${internationalConfig.大屏商品兑换码}"

};

var dataGrid;
$(function () {
    dataGrid = renderDataGrid('/lecard/list.json');
});

function renderDataGrid(url) {
    return $('#dataGrid').datagrid({
        url: url,
        fit: true,
        fitColumns: false,
        border: false,
        pagination: true,
        idField: 'batch',
        pageSize: 10,
        pageList: [ 10, 20, 30, 40, 50 ],
        sortName: 'createTime',
        sortOrder: 'desc',
        checkOnSelect: false,
        selectOnCheck: false,
        nowrap: false,
        striped: true,
        rownumbers: true,
        singleSelect: true,
        remoteSort: false,
        frozenColumns: [
            [
                {
                    field: 'batch',
                    title: '${internationalConfig.编号}',
                    width: 150,
                    hidden: true
                }
            ]
        ],
        columns: [
            [
                {
                    field: 'batch',
                    title: '${internationalConfig.批次号}',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'department',
                    title: '${internationalConfig.申请部门}',
                    width: 100,
                    formatter: function(value){
                    	return Dict.getName("department",value);
                    }
                },
                {
                    field: 'uname',
                    title: '${internationalConfig.制卡人}',
                    width: 80
                    
                },
                {
                    field: 'applicant',
                    title: '${internationalConfig.申请人}',
                    width: 80
                    
                },
                {
                    field: 'applyReason',
                    title: '${internationalConfig.申请用途}',
                    width: 80,
                    formatter: function(value){
                    	//  申请用途 1 赠送 2 测试 3 销售 4生产
                    	if(value==1){
                    		return "${internationalConfig.赠送}";
                    	}else if(value==3){
                    		return "${internationalConfig.销售}";
                    	}else if(value==4){
                    		return "${internationalConfig.生产}";
                    	}
                    	return "${internationalConfig.测试}"
                    }
                   
                },
                {
                    field: 'channelAssociationId',
                    title: '${internationalConfig.合作公司}',
                    width: 80,
                    formatter: function(value){
                           if(value==0){
                               return "${internationalConfig.未知}";
                           }
                           return Dict.channelAssociation[value].name;
                    }

                },
                {
                    field: 'applyTypeDesc',
                    title: '${internationalConfig.乐卡类型}',
                    width: 80,
                    formatter: function (value,row) {
                        var deviceType ={1:"${internationalConfig.电视}",2:"${internationalConfig.乐视手机}",3:"${internationalConfig.盒子}",4:"${internationalConfig.路由器}",5:"${internationalConfig.酷派手机}"};
                        if(row.applyType==undefined || row.applyType==null){
                            return "${internationalConfig.充值码}";
                        }
                        if(row.applyType ==6 && row.deviceType > 0){
                            return applyType[row.applyType] + "【" + deviceType[row.deviceType] + "】";
                        }
                        return applyType[row.applyType];
                    }
                },
                {
                	  field: 'applyPackageDesc',
                      title: '${internationalConfig.套餐类型}',
                      width: 100
                },
                {
                    field: 'price',
                    title: '${internationalConfig.结算金额}',
                    width: 100,
                    sortable: true,
                    formatter: function (value) {
                        if (value < 0) {
                            return "N/A"
                        } else {
                            return value;
                        }
                    }
                },
                {
                    field: 'amount',
                    title: '${internationalConfig.申请面额}',
                    width: 100,
                    sortable: true,
                    formatter: function (value) {
                        if (value < 0) {
                            return "N/A"
                        } else {
                            return value;
                        }
                    }
                },
                {
                    field: 'cardCount',
                    title: '${internationalConfig.申请数量}',
                    width: 80,
                    sortable: true
                },
                {
                    field: 'total',
                    title: '${internationalConfig.申请总额}',
                    width: 100,
                    sortable: true,
                    formatter: function (value,row,index) {
                            return (row.cardCount * row.amount).toFixed(2);
                    }
                },
         
                {
                    field: 'createTime',
                    title: '${internationalConfig.申请时间}',
                    width: 100,
                    sortable: true
                },
                
                {
                    field: 'expireDate',
                    title: '${internationalConfig.失效日期}',
                    width: 80,
                    sortable: true
                  
                },
                {
                    field: 'status',
                    title: '${internationalConfig.状态}',
                    width: 50,
                    formatter: function(value,row){
                    	if(value==0){
                    		return "${internationalConfig.制卡中}" ;
                    	}else if(value==2){
                    		return "${internationalConfig.冻结}" ;
                    	}
                    	var d=row.expireDate.replace(/-/g,"/");
                    	if(Date.parse(d)<new Date()){
                    		return "${internationalConfig.已过期}" ;
                    	}
                    	return "${internationalConfig.正常}" ;
                    }
                },
                {
                    field: 'action',
                    title: '${internationalConfig.操作}',
                    width: 200,
                    formatter: function (value, row, index) {
                        var str = '&nbsp;&nbsp;&nbsp;';
                        if(row.status==0)
                        	return str;
                        if ($.canView) {
                            str += $.formatString('<img onclick="viewFun(\'{0}\');" src="{1}" title="${internationalConfig.查看}"/>', row.batch, '/static/style/images/extjs_icons/bug/bug_link.png');
                        }
                     
                        str += '&nbsp;&nbsp;&nbsp;';
                        if ($.canfreeze && row.status == 1) {
                            str += $.formatString('<img onclick="freeze(\'{0}\',2);" src="{1}" title="${internationalConfig.冻结}"/>', row.batch, '/static/style/images/extjs_icons/bug/bug_delete.png');
                        }
                        else if ($.canfreeze && row.status == 2) {
                            str += $.formatString('<img onclick="freeze(\'{0}\',1);" src="{1}" title="${internationalConfig.解冻}"/>', row.batch, '/static/style/images/extjs_icons/bug/bug_delete.png');
                        }
                        
                        str += '&nbsp;&nbsp;&nbsp;';
                        if ($.canExport ) {
                          //  str += $.formatString('<img onclick="exportExcel(\'{0}\');" src="{1}" title="导出excel"/>', row.batch, '/static/style/images/extjs_icons/bug/bug_edit.png');
                          str+='<a href=javascript:exportExcel("'+row.batch+'");>${internationalConfig.导出卡号}</a>';
                          str+=' &nbsp;&nbsp;&nbsp;<a href=javascript:exportExcel('+row.batch+',"all");>${internationalConfig.导出全部信息}</a>';

                        }
                        return str;
                    }
                }
            ]
        ],
        toolbar: '#toolbar',
        onLoadSuccess: function () {
            $('#searchForm table').show();
            parent.$.messager.progress('close');
        },
        onRowContextMenu: function (e, rowIndex, rowData) {
            e.preventDefault();
            $(this).datagrid('unselectAll');
            $(this).datagrid('selectRow', rowIndex);
            $('#menu').menu('show', {
                left: e.pageX,
                top: e.pageY
            });
        }
    });
}

function exportExcel(batch,info) {
   if (info=='all') {
       var url = '/customTasks/addTask';
       var data = {taskType: "lecard_export", taskJson: $.formatString("{\"batchId\":\"{0}\"}", batch), taskName: "${internationalConfig.导出兑换码批次}"+batch};
       $.post(url, data, function (result) {
           if (result.success) {
               parent.$.messager.alert('${internationalConfig.成功}', "${internationalConfig.导出兑换码批次成功消息}" + result.data, 'sucess');
           } else {
               parent.$.messager.alert('${internationalConfig.页面错误}', result.msg, 'error');
           }
           parent.$.messager.progress('close');
       }, 'JSON');
   } else {
        var url = '${pageContext.request.contextPath}/lecard/exportexcel.do?batch=' + batch+"&info="+info;
        //alert(url) ;
        //location.href = url;
        window.open(url);
   }
}


function viewFun(id) {
    if (id == undefined) {
        var rows = dataGrid.datagrid('getSelections');
        id = rows[0].batch;
    }
    parent.$.modalDialog({
        title: '${internationalConfig.查看}',
        width: 680,
        height: 450,
        href: '/lecard/view.do?batch=' + id,
    	buttons : [ {
			text : '${internationalConfig.保存}',
			handler : function() {
				parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
				var f = parent.$.modalDialog.handler.find('#form');
				f.submit();
			}
		}, {
			text : "${internationalConfig.关闭}",
			handler : function() {
				parent.$.modalDialog.handler.dialog('close');
			}
		} ]
    });
}

function addFun(type,title) {
    parent.$.modalDialog({
        title: title,
        width: 680,
        height: 520,
        href: '${pageContext.request.contextPath}/lecard/add_'+type+".do",
        buttons: [
            {
                text: '${internationalConfig.添加}',
                handler: function () {
                    parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                    var f = parent.$.modalDialog.handler.find('#form');
                    f.submit();
                }
            }, {
                text : "${internationalConfig.取消}",
                handler : function() {
                    parent.$.modalDialog.handler.dialog('close');
                }
            }
        ]
    });
}


function searchFun() {
	dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
  //  renderDataGrid('${pageContext.request.contextPath}/lecard/list.json?' + $('#searchForm').serialize());
}
function cleanFun() {
    $('#searchForm input').val('');
    dataGrid.datagrid('load', {});
}


//冻结操作
function freeze(batch,status) {
	var info="${internationalConfig.您是否要冻结当前批次卡号}" ;
	if(status==1){
		info="${internationalConfig.您是否要解冻当前批次卡号}" ;
	}
    parent.$.messager.confirm('${internationalConfig.询问}', info, function (b) {
        if (b) {
            parent.$.messager.progress({
                title: '${internationalConfig.提示}',
                text: '${internationalConfig.数据处理中请稍后}....'
            });
            $.post('${pageContext.request.contextPath}/lecard/freeze.json', {
                batch: batch,
                status:status
            }, function (obj) {
                if (obj.code == 0) {
                    //dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
                    searchFun();
                }
                parent.$.messager.progress('close');
            }, 'JSON');
        }
    });
}

</script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
			style="overflow: hidden; height: 145px">
        <form id="searchForm">
            <table class="table-more" style="display: none;">
                <tr>
                    <td>${internationalConfig.批次号}：<input id="batch" class="span2" name="batch" style="width:80px;"></td>

                    <td>${internationalConfig.状态}: <select name="status" class="span2" style="width:60px;">
                            <option value="0">${internationalConfig.全部}</option>
                                <option value="1">${internationalConfig.正常}</option>
                           <option value="2">${internationalConfig.冻结}</option>
                        </select>
                    </td>
                    <td>${internationalConfig.申请部门}： <select name="department" class="span2" style="width:110px;">
                        <option value="0" selected="selected">${internationalConfig.全部}</option>
                        <c:forEach items="${dict.department}" var="department">
                            <option value="${department.key}">${department.value}</option>
                        </c:forEach>
                    </select>
                    </td>
                    <td>${internationalConfig.申请用途}: <select name="applyReason" class="span2" style="width:60px;">
                    <option selected="selected" value="0">${internationalConfig.全部}</option>
                     	<option value="1">${internationalConfig.赠送}</option>
						<option value="3">${internationalConfig.销售}</option>
						<option value="4">${internationalConfig.生产}</option>
                    </select>
                    </td>

                    <%--<td>${internationalConfig.所属渠道组别}: <select name="channelAssociationId" class="span2" style="width:60px;">
                        <option selected="selected" value="-1">${internationalConfig.全部}</option>
                        <option value="0">${internationalConfig.未知}</option>
                        <c:forEach items="${channelAssociationList}" var="channelAssociation">
                            <option value="${channelAssociation.id}">${channelAssociation.channelName}</option>
                        </c:forEach>
                    </select>
                    </td>--%>

                    <td>
                        ${internationalConfig.乐卡类型}：<select name="applyType" class="span2" style="width:125px;">
                        <m:auth uri="/lecard/add_common.do">
   								<option value="0">${internationalConfig.全部}</option>
                                <option value="1">${internationalConfig.充值码}</option>
                                <option value="2">${internationalConfig.兑换码}</option>
                                <option value="4">${internationalConfig.超级手机兑换码}</option>
					    </m:auth>
                        <m:auth uri="/lecard/add_sport.do">
                            <option value="10">${internationalConfig.直播赛事兑换码}</option>
                            <option value="11">${internationalConfig.直播场次兑换码}</option>
                        </m:auth>
                        <m:auth uri="/lecard/add_exchange2.do">
                            <option value="5">${internationalConfig.会员兑换码}2.0</option>
                            <option value="6">${internationalConfig.机卡兑换码}2.0</option>
                        </m:auth>
                        <m:auth uri="/lecard/add_ecommerce.do">
                            <option value="50">${internationalConfig.大屏商品兑换码}</option>
                        </m:auth>
					<%--<m:auth uri="/lecard/add_music.do">
                             <option value="20">${internationalConfig.音乐兑换码}</option>
					</m:auth>					
					<m:auth uri="/lecard/add_movie.do">
                               <option value="30">${internationalConfig.影视剧兑换码}</option>
                             <option value="40">${internationalConfig.组合套餐兑换码}</option>
					</m:auth>--%>
                        </select>
                    </td>
                    </tr>
                    </table>
             <table class="table-more" style="display: none;">
             	<tr>
             		<td>${internationalConfig.申请人员}：<input id="applicant" name="applicant" class="span2"></td>
                    <td>${internationalConfig.申请时间}：<input id="begin" name="createTime"
                                    class="easyui-datebox">
                    --<input id="end" name="updateTime"
                                    class="easyui-datebox"></td>
                    <td>${internationalConfig.失效日期}：<input id="end" name="expireDate"
                                    class="easyui-datebox">
                    </td>
                 </tr>
                 </table>
        </form>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>
<div id="toolbar" style="display: none;">
<c:if test="${currentCountry==852}">
<m:auth uri="/lecard/add_common.do">
  <a onclick="addFun('common','${internationalConfig.制卡}');" href="javascript:void(0);"
       class="easyui-linkbutton" data-options="plain:true,iconCls:'bug_add'">${internationalConfig.制卡}</a>
</m:auth>
</c:if>
<m:auth uri="/lecard/add_exchange2.do">
     <a onclick="addFun('exchange2','${internationalConfig.兑换码}2.0');" href="javascript:void(0);"
       class="easyui-linkbutton" data-options="plain:true,iconCls:'bug_add'">${internationalConfig.兑换码}2.0</a>
</m:auth>
<m:auth uri="/lecard/add_sport.do">
  <a onclick="addFun('sport','${internationalConfig.直播兑换码}');" href="javascript:void(0);"
       class="easyui-linkbutton" data-options="plain:true,iconCls:'bug_add'">${internationalConfig.直播兑换码}</a>
</m:auth>

    <m:auth uri="/lecard/add_ecommerce.do">
        <a onclick="addFun('ecommerce','${internationalConfig.大屏商品兑换码}');" href="javascript:void(0);"
           class="easyui-linkbutton" data-options="plain:true,iconCls:'bug_add'">${internationalConfig.大屏商品兑换码}</a>
    </m:auth>
<%--   

<m:auth uri="/lecard/add_music.do">
  <a onclick="addFun('music');" href="javascript:void(0);"
       class="easyui-linkbutton" data-options="plain:true,iconCls:'bug_add'">制作音乐兑换码</a>
</m:auth>

<m:auth uri="/lecard/add_movie.do">
  <a onclick="addFun('movie');" href="javascript:void(0);"
       class="easyui-linkbutton" data-options="plain:true,iconCls:'bug_add'">制作影视剧兑换码</a>
</m:auth>



 --%>



    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a><a
        href="javascript:void(0);" class="easyui-linkbutton"
        data-options="iconCls:'brick_delete',plain:true"
        onclick="cleanFun();">${internationalConfig.清空条件}</a>
</div>


</body>
</html>
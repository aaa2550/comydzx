<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">
        var dataGrid;
        $(function () {

            dataGrid = $('#dataGrid').datagrid({
                url: '/dataStat/cpm/find',
                fit: true,
                fitColumns: true,
                border: false,
                idField: 'id',
                pagination: true,
                pageSize: 10,
                pageList: [10, 20, 30, 40, 50],
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                columns: [[{
                    field: 'startTime',
                    title: '${internationalConfig.规则开始时间}',
                    width: 80,
                    formatter: function (value, row, index) {
                        return value.substring(0,10);
                    }
                }, {
                    field: 'endTime',
                    title: '${internationalConfig.规则结束时间}',
                    width: 80,
                    formatter: function (value, row, index) {
                        return value.substring(0,10);
                    }
                }, {
                    field: 'cid',
                    title: 'CPID',
                    width: 40
                }, {
                    field: 'cpName',
                    title: '${internationalConfig.CP名称}',
                    width: 250
                }, {
                    field: 'cpType',
                    title: '${internationalConfig.类别}',
                    width: 40,
                    formatter: function (value, row, index) {
                        var str = '';
                        if (value == 1) {
                            str = '${internationalConfig.默认分类}';
                        } else if (value == 2) {
                            str = '${internationalConfig.影业}';
                        } else if (value == 3) {
                            str = '${internationalConfig.动漫}';
                        } else if (value == 4) {
                            str = '${internationalConfig.音乐}';
                        } else if (value == 5) {
                            str = '${internationalConfig.PGC}';
                        } else {
                            str = '${internationalConfig.其它}';
                        }
                        return str;
                    }
                }, {
                    field: 'configType',
                    title: '${internationalConfig.分成类型}',
                    width: 80,
                    formatter: function (value, row, index) {
                        var str = '';
                        if (value == 1) {
                            str = '${internationalConfig.付费分成}';
                        } else if (value == 2) {
                            str = '${internationalConfig.CPM分成}';
                        } else if (value == 3) {
                            str = '${internationalConfig.播放分成}';
                        } else if (value == 4) {
                            str = '${internationalConfig.累计时长分成}';
                        } else if (value == 5) {
                            str = '${internationalConfig.会员订单分成}';
                        } else if (value == 6) {
                            str = '${internationalConfig.业务订单分成}';
                        } else {
                            str = '${internationalConfig.其它}';
                        }
                        return str;
                    }
                }, {
                    field: 'albumId',
                    title: '${internationalConfig.专辑ID}',
                    width: 90
                }, {
                    field: 'albumName',
                    title: '${internationalConfig.专辑名称}',
                    width: 100
                }, {
                    field: 'pc',
                    title: '${internationalConfig.PC端暂停千次}',
                    width: 100,
                    formatter: function (value, row, index) {
                        return value / 1000;
                    }
                }, {
                    field: 'pcNum',
                    title: '${internationalConfig.PC端贴片千次}',
                    width: 100,
                    formatter: function (value, row, index) {
                    	var str = row.pc5+","+row.pc10+","+row.pc15+","+row.pc30+","+row.pc60+","+row.pc75+",1"
                        return (value / 1000) + " | <a href='javascript:;' onclick='showDetails("+str+")' class='propsOperation'>${internationalConfig.详细}</a>";
                    }
                }, {
                    field: 'phone',
                    title: '${internationalConfig.移动端暂停千次}',
                    width: 60,
                    formatter: function (value, row, index) {
                        return value / 1000;
                    }
                }, {
                    field: 'phoneNum',
                    title: '${internationalConfig.移动端贴片千次}',
                    width: 100,
                    formatter: function (value, row, index) {
                    	var str = row.phone5+","+row.phone10+","+row.phone15+","+row.phone30+","+row.phone60+","+row.phone75+",2"
                        return value / 1000+ " | <a href='javascript:;' onclick='showDetails("+str+")' class='propsOperation'>${internationalConfig.详细}</a>";
                    }
                }, {
                    field: 'tv',
                    title: '${internationalConfig.TV端暂停千次}',
                    width: 60,
                    formatter: function (value, row, index) {
                        return value / 1000;
                    }
                }, {
                    field: 'tvNum',
                    title: '${internationalConfig.TV端贴片千次}',
                    width: 100,
                    formatter: function (value, row, index) {
                    	var str = row.tv5+","+row.tv10+","+row.tv15+","+row.tv30+","+row.tv60+","+row.tv75+",3"
                        return value / 1000+ " | <a href='javascript:;' onclick='showDetails("+str+")' class='propsOperation'>${internationalConfig.详细}</a>";;
                    }
                }, {
                    field: 'action',
                    title: '${internationalConfig.操作}',
                    width: 50,
                    formatter: function (value, row, index) {
                        return "<a target='_blank' href='/dataStat/details/cpm/list.do?startTime=" + row.startTime + "&endTime=" + row.endTime + "&albumId=" + row.albumId + "'>${internationalConfig.日明细}</a>";
                    }
                }]],
                toolbar: '#toolbar'
            });
        });

        function showDetails(str) {
        	/* var numargs = arguments.length
        	console.log(arguments) */
        	var title=""
        	if(arguments[6]==1){
        		title="${internationalConfig.PC端贴片详细}"
        	}else if(arguments[6]==2){
        		title="${internationalConfig.移动端贴片详细}"
        	}else{
        		title="${internationalConfig.TV端贴片详细}"
        	}
        	$(".d5").html(arguments[0]);
        	$(".d10").html(arguments[1]);
        	$(".d15").html(arguments[2]);
        	$(".d30").html(arguments[3]);
        	$(".d60").html(arguments[4]);
        	$(".d75").html(arguments[5]);
        	$("#detailDialog").dialog({
        	    title: title,
        	    width: 600,
        	    height: 150,
        	    closed: false,
        	    cache: false,
        	    modal: true
        	});
            /* parent.$.modalDialog({
                title: '${internationalConfig.添加版权方}',
                width: 600,
                height: 600
                //href: '/new/share_copyright_config/update_copyright?copyrightId=' + updateId
            }); */
        }

        function searchFun() {
            var fromData = $.serializeObject($('#searchForm'));
            dataGrid.datagrid({queryParams: fromData});
        }

        function exportFile() {
            var params = $.serializeObject($('#searchForm'));
            var url = '/dataStat/cpm/export?';
            for(var key in params){
                url += key + "=" + params[key] + "&";
            }
            location.href = url;
        }
    </script>
</head>
<body>
<style>
.detailDialog tr th{background:#eee}
.detailDialog tr td,.detailDialog tr th{width:80px;padding:10px;border:1px solid #ddd;text-align:center;}
</style>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
         style="height: 120px; overflow: hidden;">
        <form id="searchForm">
            <table class="table-more" style="width: 1200px;">
                <tr>
                    <td>${internationalConfig.时间段}：<input name="startTime" class="easyui-datebox"/>-<input name="endTime" class="easyui-datebox"/></td>
                    <td>
                        ${internationalConfig.类别}：
                        <select name="cpType">
                            <option value="">${internationalConfig.全部}</option>
                            <option value="1">${internationalConfig.默认分类}</option>
                            <option value="2">${internationalConfig.影业}</option>
                            <option value="3">${internationalConfig.动漫}</option>
                            <option value="4">${internationalConfig.音乐}</option>
                            <option value="5">${internationalConfig.PGC}</option>
                        </select>
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td>CPID：<input name="cid" placeholder="${internationalConfig.请输入CPID}" class="span2"/> ${internationalConfig.CP名称}：<input name="cpName" placeholder="${internationalConfig.请输入CP名称}" class="span2"/></td>
                    <td>${internationalConfig.专辑ID}：<input name="albumId" placeholder="${internationalConfig.请输入专辑ID}" class="span2"/></td>
                    <td>${internationalConfig.专辑名称}：<input name="albumName" placeholder="${internationalConfig.专辑名称}" class="span2"/></td>
                </tr>
            </table>
        </form>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
    <div id="toolbar" style="display: none;">
        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true"
           onclick="searchFun();">${internationalConfig.过滤条件}</a>
        <a href="javascript:void(0);" class="easyui-linkbutton"
           data-options="iconCls:'brick_add',plain:true" onclick="exportFile();">${internationalConfig.导出数据}</a>
    </div>
    <div id="detailDialog" class="detailDialog">
        <table>
        	<tr>
        		<th>5秒</th>
        		<th>10秒</th>
        		<th>15秒</th>
        		<th>30秒</th>
        		<th>60秒</th>
        		<th>75秒</th>
        	</tr>
        	<tr>
        		<td class="d5"></td>
        		<td class="d10"></td>
        		<td class="d15"></td>
        		<td class="d30"></td>
        		<td class="d60"></td>
        		<td class="d75"></td>
        	</tr>
        </table>
    </div>
</div>
</body>
</html>
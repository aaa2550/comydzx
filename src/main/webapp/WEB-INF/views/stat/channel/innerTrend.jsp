<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>站内转化趋势</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js"
            type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>
    <script type="text/javascript">
        var dataGrid;
        var jump = '${jump}';
        $(function () {
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/channelStat/inner/trendQuery');
            if('${domainId}'){
        		$('#domainId').val('${domainId}')
        		loadModuleByDomain('${moduleId}', '${channelParameter}');
        	}
        });
        
        function renderDataGrid(url) {
        	var params = $.serializeObject($('#searchForm'));
        	if(jump){
        		jump = false;
	        	if('${domainId}')
	        		$.extend(params, {'domainId': '${domainId}'});
	        	if('${moduleId}')
	        		$.extend(params, {'moduleId': '${moduleId}'});
	        	if('${channelParameter}')
	        		$.extend(params, {'channelParameter': '${channelParameter}'});
        	}
            return $('#dataGrid').datagrid({
                url: url,
                fit: false,
                fitColumns: false,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 20,
                pageList: [20, 30, 50, 100],
                sortName: 'date',
                sortOrder: 'asc',
                queryParams: params,
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                striped: true,
                rownumbers: true,
                singleSelect: true,
                remoteSort: false,
                columns: [
                    [
                        {
                            field: 'date',
                            title: '日期',
                            width: 100,
                        },
                        {
                            field: 'pageUV',
                            title: '流量(UV)',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'payUV',
                            title: '付费人数',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'income',
                            title: '付费收入',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'payRate',
                            title: '付费转化率',
                            width: 100,
                            formatter: function (value, row, index) {
                                return $.formatString('{0}%', row.payRate);
                            }
                        },
                        {
                            field: 'newPayUV',
                            title: '新增人数',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'newIncome',
                            title: '新增收入',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'xufeiPayUV',
                            title: '续费人数',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'xufeiIncome',
                            title: '续费收入',
                            width: 100,
                            sortable: true
                        }

                    ]
                ],
                toolbar: '#toolbar',
                onLoadSuccess: function (data) {
                    $('#searchForm table').show();
                    parent.$.messager.progress('close');
                    loadChart(data);
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
        
        function searchFun() {
            renderDataGrid('${pageContext.request.contextPath}/tj/channelStat/inner/trendQuery');
        }
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }
        function loadModuleByDomain(moduleId, channelParameter) {
            $.getJSON("${pageContext.request.contextPath}/tj/channelStat/channel/module", {domainId: $("#domainId").val()}, function (modules) {
	            var options = "";
	            modules = modules['rows'];
	            options += "<option value=-2 selected>全部</option>";
	            for (var i = 0; i < modules.length; i++) {
	                options += "<option value=" + modules[i]['moduleId'] + "" + ((modules[i]['moduleId'] == moduleId)? " selected=selected>": ">") + modules[i]['moduleName'] + "</option>";
	            }
	            $("#moduleId").html(options);
	            loadChannelByModule(channelParameter);
            });
        }

        function loadChannelByModule(channelParameter) {
            $.getJSON("${pageContext.request.contextPath}/tj/channelStat/channel/query", {moduleId: $("#moduleId").val()}, function (channels) {
                var options = "";
                channels = channels['rows'];
                options += "<option value=-2 selected>全部</option>";
                for (var i = 0; i < channels.length; i++) {
                	options += "<option value=" + channels[i]['channelParameter'] + "" + ((channels[i]['channelParameter'] == channelParameter)? " selected=selected>": ">") + channels[i]['channelName'] + "</option>";
                }
                $("#channelParameter").html(options);
            });
        }

        function loadChart(data) {
            var rows = data['rows'];
            $('#container').highcharts({
                chart: {
                    //type: 'column'
                },
                title: {
                    text: '站内转化流量分布',
                    x: -20 //center
                },
                xAxis: {
                    categories: $.map(rows, function (element) {
                        return element['date'];
                    })
                },
                yAxis: {
                    title: {
                        text: ''
                    },
                    plotLines: [{
                        value: 0,
                        width: 1,
                        color: '#808080'
                    }]
                },
                credits: {
                    enabled: false
                },
                tooltip: {
                    shared: true
                },

                legend: {
                    layout: 'vertical',
                    align: 'right',
                    verticalAlign: 'middle',
                    borderWidth: 1,
                    borderRadius: 5
                },
                series: [{
                    //color:'#00EEEE',
                    //type: 'column',
                    name: '流量(uv)',
                    data: $.map(rows, function (element) {
                        //console.info(element) ;
                        return Number(element['pageUV']);
                    })
                }

                ]
            });
        }

    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false"
         style="height: 120px; overflow: auto;">
        <form id="searchForm">
            <table class="table table-hover table-condensed">
                <tr>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>渠道级别</td>
                    <td>渠道类别</td>
                    <td>渠道</td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <input name="beginDate" class="easyui-datebox" data-options="required:true" value="${start}"
                               style="width: 160px; height: 29px"/>
                    </td>

                    <td>
                        <input name="endDate" class="easyui-datebox" data-options="required:true" value="${end}"
                               style="width: 160px; height: 29px"/>
                    </td>
                    <td><select id="domainId" name="domainId" title="ex:360,baidu为站外"
                                style="width: 160px" onchange="loadModuleByDomain()">
                        <option value="-2" selected>全部</option>
                        <option value="1">站内</option>
                        <option value="2">支付域</option>
                    </select>
                    </td>
                    <td><select id="moduleId" name="moduleId" style="width: 160px" onchange="loadChannelByModule()">
                        <option value="-2" selected>全部</option>
                    </select>
                    </td>
                    <td><select id="channelParameter" name="channelParameter" style="width: 160px">
                        <option value="-2" selected>全部</option>
                    </select></td>
                    <td></td>
                </tr>
            </table>
        </form>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>
<div id="toolbar" style="display: none;">
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a><a
        href="javascript:void(0);" class="easyui-linkbutton"
        data-options="iconCls:'brick_delete',plain:true"
        onclick="cleanFun();">清空条件</a>

    <div id="container" style="min-width: 310px; height: 300px; margin: 0 auto; overflow: auto"></div>

</div>


</body>
</html>
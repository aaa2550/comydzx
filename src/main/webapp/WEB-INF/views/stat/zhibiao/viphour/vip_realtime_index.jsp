<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>boss会员指标首页</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <link href="${pageContext.request.contextPath}/static/style/js/stat/style.css" rel="stylesheet" type="text/css"/>
    <script src="${pageContext.request.contextPath}/static/lib/jquery-1.11.1.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#thisDiv").click(function () {
                $("#anotherDiv").toggle();
            });
        });
        $(document).ready(function () {
       		$('.f_help').click(function(){
       			$(this).next(".ks").toggle();
       		});
        });
    </script>
    <script type="text/javascript">
        /*返回数据*/
        function getSerialData(option) {
            $.getJSON('${pageContext.request.contextPath}/tj/statzb/vip_index/querySerialIncome', option, function (result) {

                Highcharts.setOptions({
                    colors: ['#5CACEE', '#FC6558', '#DDDF00', '#3626FD', '#6AF9C4', '#24CBE5',
                        '#64E572', '#FF9655', '#8C1E89', '#9D9D9D', '#555500']
                });
                new Highcharts.Chart({
                    chart: {
                        renderTo: 'linecontainerprice',
                        type: 'spline',
                        marginRight: 130,
                        marginBottom: 60
                    },

                    title: {
                        text: '会员实时收入'
                    },

                    xAxis: {
                        lineColor: '#104E8B', //x轴颜色
                        lineWidth: 2, //轴宽度
                        gridLineColor: '#E8E8E8', //网格线
                        gridLineWidth: 1,
                        categories: result['categories'],
                        title: {
                            text: ''
                        },
                        labels: {},
                        tickInterval: 1
                    },

                    yAxis: {
                        lineColor: '#104E8B', //y轴颜色
                        lineWidth: 2, //轴宽度
                        gridLineColor: '#E8E8E8',
                        gridLineWidth: 1,
                        min: 0,
                        title: {
                            text: '收入金额'
                        }
                    },

                    credits: {
                        enabled: false // 禁用版权信息
                    },
                    exporting: {
                        enabled: false //隐藏打印图列
                    },
                    tooltip: {
                        crosshairs: { //十字准线
                            width: 0.5,
                            color: '#104E8B',
                            dashStyle: 'solid'
                        },
                        formatter: function () {
                            return '<b>' + this.x + ":00" + " - " + this.x + ":59" + '</b><br/><br/>' +
                                    '<b>' + this.series.name + '</b>' + '： ' + this.y + "(元)";
                        }
                    },
                    legend: {
                        y: 10,
                        borderWidth: 0,
                    },
                    series: [
                        {
                            name: '收入金额',
                            marker: {
                                lineWidth: 2,
                                lineColor: Highcharts.getOptions().colors[0],
                                fillColor: 'white'
                            },
                            data: result['data']['0']['999']
                        },
                        {
                            type: 'spline',
                            name: '昨日收入',
                            visible: false,
                            marker: {
                                lineWidth: 2,
                                lineColor: Highcharts.getOptions().colors[1],
                                fillColor: 'white'
                            },
                            data: result['data']['-1']['999']
                        },
                        {
                            type: 'spline',
                            name: '上周同期',
                            visible: false,
                            marker: {
                                lineWidth: 2,
                                lineColor: Highcharts.getOptions().colors[2],
                                fillColor: 'white'
                            },
                            data: result['data']['-7']['999']
                        },
                        {
                            name: '收入金额(乐次元)',
                            marker: {
                                lineWidth: 2,
                                lineColor: Highcharts.getOptions().colors[3],
                                fillColor: 'white'
                            },
                            data: result['data']['0']['1']
                        },
                        {
                            type: 'spline',
                            name: '昨日收入(乐次元)',
                            visible: false,
                            marker: {
                                lineWidth: 2,
                                lineColor: Highcharts.getOptions().colors[4],
                                fillColor: 'white'
                            },
                            data: result['data']['-1']['1']
                        },
                        {
                            type: 'spline',
                            name: '上周同期(乐次元)',
                            visible: false,
                            marker: {
                                lineWidth: 2,
                                lineColor: Highcharts.getOptions().colors[5],
                                fillColor: 'white'
                            },
                            data: result['data']['-7']['1']
                        },
                        {
                            name: '收入金额(超级影视会员)',
                            marker: {
                                lineWidth: 2,
                                lineColor: Highcharts.getOptions().colors[6],
                                fillColor: 'white'
                            },
                            data: result['data']['0']['9']
                        },
                        {
                            type: 'spline',
                            name: '昨日收入(超级影视会员)',
                            visible: false,
                            marker: {
                                lineWidth: 2,
                                lineColor: Highcharts.getOptions().colors[7],
                                fillColor: 'white'
                            },
                            data: result['data']['-1']['9']
                        },
                        {
                            type: 'spline',
                            name: '上周同期(超级影视会员)',
                            visible: false,
                            marker: {
                                lineWidth: 2,
                                lineColor: Highcharts.getOptions().colors[8],
                                fillColor: 'white'
                            },
                            data: result['data']['-7']['9']
                        },
                    ]

                });
            });


            $.getJSON('${pageContext.request.contextPath}/tj/statzb/vip_index/querySerialOrder', option, function (result) {

                Highcharts.setOptions({
                    colors: ['#5CACEE', '#FC6558', '#DDDF00', '#3626FD', '#6AF9C4', '#24CBE5',
                        '#64E572', '#FF9655', '#8C1E89', '#9D9D9D', '#555500']
                });
                new Highcharts.Chart({
                    chart: {
                        renderTo: 'linecontainerorder',
                        type: 'spline',
                        marginRight: 130,
                        marginBottom: 60
                    },

                    title: {
                        text: '订单实时统计'
                    },

                    xAxis: {
                        lineColor: '#104E8B', //x轴颜色
                        lineWidth: 2, //轴宽度
                        gridLineColor: '#E8E8E8', //网格线
                        gridLineWidth: 1,
                        categories: result['categories'],
                        title: {
                            text: ''
                        },
                        labels: {},
                        tickInterval: 1
                    },

                    yAxis: {
                        lineColor: '#104E8B', //y轴颜色
                        lineWidth: 2, //轴宽度
                        gridLineColor: '#E8E8E8',
                        gridLineWidth: 1,
                        min: 0,
                        title: {
                            text: '订单数量'
                        }
                    },

                    credits: {
                        enabled: false // 禁用版权信息
                    },
                    exporting: {
                        enabled: false //隐藏打印图列
                    },
                    tooltip: {
                        crosshairs: { //十字准线
                            width: 0.5,
                            color: '#104E8B',
                            dashStyle: 'solid'
                        },
                        formatter: function () {
                            return '<b>' + this.x + ":00" + " - " + this.x + ":59" + '</b><br/><br/>' +
                                    '<b>' + this.series.name + '</b>' + '： ' + this.y;
                        }
                    },
                    legend: {
                        y: 10,
                        borderWidth: 0,
                    },
                    series: [
                        {
                            name: '当日订单数',
                            marker: {
                                lineWidth: 2,
                                lineColor: Highcharts.getOptions().colors[0],
                                fillColor: 'white'
                            },
                            data: result['data']['0']['999']
                        },
                        {
                            type: 'spline',
                            name: '昨日订单数',
                            visible: false,
                            marker: {
                                lineWidth: 2,
                                lineColor: Highcharts.getOptions().colors[1],
                                fillColor: 'white'
                            },
                            data: result['data']['-1']['999']
                        },
                        {
                            type: 'spline',
                            name: '上周同期数',
                            visible: false,
                            marker: {
                                lineWidth: 2,
                                lineColor: Highcharts.getOptions().colors[2],
                                fillColor: 'white'
                            },
                            data: result['data']['-7']['999']
                        },
                        {
                            name: '当日订单数(乐次元)',
                            marker: {
                                lineWidth: 2,
                                lineColor: Highcharts.getOptions().colors[3],
                                fillColor: 'white'
                            },
                            data: result['data']['0']['1']
                        },
                        {
                            type: 'spline',
                            name: '昨日订单数(乐次元)',
                            visible: false,
                            marker: {
                                lineWidth: 2,
                                lineColor: Highcharts.getOptions().colors[4],
                                fillColor: 'white'
                            },
                            data: result['data']['-1']['1']
                        },
                        {
                            type: 'spline',
                            name: '上周同期数(乐次元)',
                            visible: false,
                            marker: {
                                lineWidth: 2,
                                lineColor: Highcharts.getOptions().colors[5],
                                fillColor: 'white'
                            },
                            data: result['data']['-7']['1']
                        },
                        {
                            name: '当日订单数(超级影视会员)',
                            marker: {
                                lineWidth: 2,
                                lineColor: Highcharts.getOptions().colors[6],
                                fillColor: 'white'
                            },
                            data: result['data']['0']['9']
                        },
                        {
                            type: 'spline',
                            name: '昨日订单数(超级影视会员)',
                            visible: false,
                            marker: {
                                lineWidth: 2,
                                lineColor: Highcharts.getOptions().colors[7],
                                fillColor: 'white'
                            },
                            data: result['data']['-1']['9']
                        },
                        {
                            type: 'spline',
                            name: '上周同期数(超级影视会员)',
                            visible: false,
                            marker: {
                                lineWidth: 2,
                                lineColor: Highcharts.getOptions().colors[8],
                                fillColor: 'white'
                            },
                            data: result['data']['-7']['9']
                        },
                    ]

                });
            });

        }
        
        function queryTitle(option){
        	$.getJSON('${pageContext.request.contextPath}/tj/statzb/vip_index/queryTodayIncome', option, function (result) {
				$('#sds1_value').replaceWith('<i id="sds1_value">'+result.viptypenull.pricenull+'</i>');
				$('#sds6_value').replaceWith('<i id="sds6_value">'+result.viptype1.price1+'</i>');
				$('#sds7_value').replaceWith('<i id="sds7_value">'+result.viptype9.price9+'</i>');
				$('#sds8_value').replaceWith('<i id="sds8_value">'+result.viptypenull.ordernull+'</i>');
				$('#sds9_value').replaceWith('<i id="sds9_value">'+result.viptype1.order1+'</i>');
				$('#sds10_value').replaceWith('<i id="sds10_value">'+result.viptype9.order9+'</i>');
            });
        }


        function query(option){
        	queryTitle(option);
        	getSerialData(option);        	
        }
        //执行  
        query();


    </script>

    <script type="text/javascript">
        var pie_xset = [];//X轴数据集
        var pie_yset = [];//Y轴数据集
        function getPieData() {
            $.getJSON('${pageContext.request.contextPath}/tj/statzb/vip_index/vip_province/dataGrid', function (data) {
                $.each(data, function (i, item) {
                    $.each(item, function (k, v) {
                        //console.log(item) ;
                        pie_xset.push(k);
                        pie_yset.push(v);
                    });
                })
                //根据时间序列生成折线图
                showCharts(pie_xset, pie_yset);
            });
        }


        function showCharts(pie_xset, pie_yset) {
            var pies = $.map(pie_yset, function (element) {
                //console.log(element) ;
                return {name: element['province'], y: element['zhibiaoValue']}
            });
            //console.log(pies+"---") ;
            // Build the chart
            $('#piecontainer').highcharts({
                chart: {
                    plotBackgroundColor: null,
                    plotBorderWidth: null,
                    plotShadow: false,
                    height: 300,
                    width: 250,
                },
                legend: {
                    enabled: false
                },
                credits: {
                    enabled: false // 禁用版权信息
                },
                exporting: {
                    enabled: false //隐藏打印图列
                },
                title: {
                    // enabled:false
                    text: ''
                },
                tooltip: {
                    pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
                },
                plotOptions: {
                    pie: {
                        allowPointSelect: true,
                        cursor: 'pointer',
                        dataLabels: {
                            enabled: false
                        },
                        showInLegend: true
                    }
                },
                series: [{
                    type: 'pie',
                    name: '付费占比',
                    data: pies
                }]
            });
        }

        getPieData();
    </script>
</head>

<body>
<!--标题-->
<!-- <div class="w_title"><h3>实时数据统计</h3></div>   -->
<div data-options="region:'north',title:'查询条件',border:false"
     style="height: 42px; overflow: hidden;">
    <form id="searchForm">
        <table class="table table-hover table-condensed">
            <tr>
                <td>设备类型： <select name="deviceType" id="deviceType" onchange="query({terminal: this.options[this.options.selectedIndex].value})">
                    <option value="">全部</option>
                    <c:forEach items="${terminals}" var="terminal">
                        <option value="${terminal.key}">${terminal.value}</option>
                    </c:forEach>
                </select>
                </td>
            </tr>
        </table>
    </form>
</div>
<!--数据分析列表-->
<div class="f_shuju">
    <table cellpadding="0" cellspacing="1" border="0">
        <tr>
            <td>
                <dl>
                    <dt>
                        <span>今日累计收入</span>
                        <a class="f_help" id="sds1" href="javascript:;"></a>
                    <div class="ks" id="fd1" style="display: none;">
                        <span>今日截止目前,所有现金收入，包括点播，开通会员，续费等带来收入。</span>
                    </div>
                    </dt>
                    <dd>
                        <i id="sds1_value"></i>
                    </dd>
                </dl>
            </td>
            <td>
                <dl>
                    <dt>
                        <span>今日累计收入（乐次元）</span><a class="f_help" id="sds6" href="javascript:;"></a>
                    <div class="ks" id="fd6" style="display: none;">
                        <span>今日截止目前,所有现金收入,仅包含乐次元收入。</span>
                    </div>
                    </dt>
                    <dd>
                        <i id="sds6_value"></i>
                    </dd>
                </dl>
            </td>
            <td>
                <dl>
                    <dt>
                        <span>今日累计收入（超级影视）</span><a class="f_help" id="sds7" href="javascript:;"></a>
                    <div class="ks" id="fd7" style="display: none;">
                        <span>今日截止目前,所有现金收入,仅包含超级影视收入。</span>
                    </div>
                    </dt>
                    <dd>
                        <i id="sds7_value"></i>
                    </dd>
                </dl>
            </td>
            <td>
                <dl>
                    <dt>
                        <span>今日累计订单数</span><a class="f_help" id="sds8" href="javascript:;"></a>
                    <div class="ks" id="fd8" style="display: none;">
                        <span>今日截止目前,所有现金订单，包括点播，开通会员，续费等订单。</span>
                    </div>
                    </dt>
                    <dd>
                        <i id="sds8_value"></i>
                    </dd>
                </dl>
            </td>
            <td>
                <dl>
                    <dt>
                        <span>今日累计订单（乐次元）</span><a class="f_help" id="sds9" href="javascript:;"></a>
                    <div class="ks" id="fd9" style="display: none;">
                        <span>今日截止目前,所有现金订单,仅包含乐次元订单。</span>
                    </div>
                    </dt>
                    <dd>
                        <i id="sds9_value"></i>
                    </dd>
                </dl>
            </td>
            <td>
                <dl>
                    <dt>
                        <span>今日累计订单（超级影视）</span><a class="f_help" id="sds10" href="javascript:;"></a>
                    <div class="ks" id="fd10" style="display: none;">
                        <span>今日截止目前,所有现金订单,仅包含超级影视订单。</span>
                    </div>
                    </dt>
                    <dd>
                        <i id="sds10_value"></i>
                    </dd>
                </dl>
            </td>
            </tr>
            <tr>
             
            <td>
                <dl>
                    <dt>
                        <span>昨日收入金额 </span><a class="f_help" id="sds2" href="javascript:;"></a>
                    <div class="ks" id="fd2" style="display: none;">
                        <span>昨日一天现金收入</span>
                    </div>
                    </dt>
                    <dd>
                        <i id="sds2_value">${allIncome}</i>
                    </dd>
                </dl>
            </td>
            <td>
                <dl>
                    <dt>
                        <span>昨日新增收入</span><a class="f_help" id="sds3" href="javascript:;"></a>
                    <div class="ks" id="fd3" style="display: none;">
                        <span>昨日新增收入</span>
                    </div>
                    </dt>
                    <dd>
                        <i id="sds3_value">${newIncome}</i>
                    </dd>
                </dl>
            </td>
            <td>
                <dl>
                    <dt>
                        <span>昨日付费用户数</span><a class="f_help" id="sds4" href="javascript:;"></a>
                    <div class="ks" id="fd4" style="display: none;">
                        <span>昨日付费用户数</span>
                    </div>
                    </dt>
                    <dd>
                        <i id="sds4_value">${payNum }</i>
                    </dd>
                </dl>
            </td>
            <td>
                <dl>
                    <dt>
                        <span>昨日人均付费</span><a class="f_help" id="sds5" href="javascript:;"></a>
                    <div class="ks" id="fd5" style="display: none;">
                        <span>昨日人均付费=昨日现金收入/昨日付费用户数</span>
                    </div>
                    </dt>
                    <dd>
                        <i id="sds5_value">${perMoney }</i>
                    </dd>
                </dl>
            </td>
            <td></td>
            <td></td>
        </tr>
    </table>
</div>
<!--线图位置-->
<div class="p_img">
    <!--
<div class="p_des">
     <a href="javascript:void(0)" id="thisDiv" class="combobox trackable"><span class="text">指标：</span><span class="flash-indicator-text text">收入金额</span><em class="arrow"></em></a>
    <div class="flash-indicator-container layer" id="anotherDiv" style="display:none;">
        <div class="flash-indicator-groups">
            <div class="group clearfix">
                <label title="收入金额"><input name="tangram-flash-indicator--TANGRAM__e-FlashIndicator" id="tangram-flash-indicator--TANGRAM__e-pv_count" value="pv_count" text="访问次数" checked="checked" type="radio">收入金额</label>
                <label title="付费人数"><input name="tangram-flash-indicator--TANGRAM__e-FlashIndicator" id="tangram-flash-indicator--TANGRAM__e-pv_count" value="pv_count" text="访问次数" checked="checked" type="radio">付费人数</label>
                <label title="xxxx"><input name="tangram-flash-indicator--TANGRAM__e-FlashIndicator" id="tangram-flash-indicator--TANGRAM__e-pv_count" value="pv_count" text="访问次数" checked="checked" type="radio">会员人数</label>
            </div>
        </div>
        <div id="FlashTip" class="text">(可同时选择<span class="max-flash-indicator-num">1</span>项)</div>
    </div>
</div>
-->
    <div class="p_shua">
        <div id="linecontainerprice"
             style="width: auto; height: 330px; padding-bottom: 40px"></div>
    </div>
    <div class="p_shua">
        <div id="linecontainerorder"
             style="width: auto; height: 330px; padding-bottom: 40px"></div>
    </div>
    <!--  <div class="p_hang" style="padding-top: 40px">
    <p>
    <label>对比：</label>
    <label for="LastDay"><input id="LastDay" type="checkbox">前一日</label>
    <label for="LastWeek"><input id="LastWeek" type="checkbox">上周同期</label>
    <label for="LastMonth"><input id="LastMonth" type="checkbox">上月同期</label>
    </p>
</div> -->
</div>
<!--模块分布数据-->
<div class="d_cid">
    <div class="d_left">
        <div class="zi">
            <span>地域分布：</span><a href="javascript:;">查看全部</a>
        </div>
        <div class="tu">
            <table class="area-list" cellpadding="0" cellspacing="0" border="0">
                <tbody>
                <tr>
                    <th style="width: 40%;">&nbsp;</th>
                    <th style="width: 20%; padding-left: 30px">地域</th>
                    <th style="width: 20%;">会员数</th>
                    <th style="width: 20%;">占比</th>
                </tr>
                </tbody>
            </table>
        </div>
        <div class="tu">
            <div style="float: left; width: 40%">
                <table style="width: 30%">
                    <tr>
                        <td>
                            <div id="piecontainer"
                                 style="float: left; margin-left: 20px; height: 300px; width: auto;"/>
                            <!-- <img src="${pageContext.request.contextPath}/static/style/images/stat/ds2.jpg" /> -->
                        </td>
                    </tr>
                </table>
            </div>
            <c:set var="sumVip" value="0"></c:set>
            <%-- <c:forEach var="province" items="${provinceList}">
            <c:set var="sumVip" value="${sumVip+province.zhibiaoValue}"></c:set>
        </c:forEach> --%>
            <c:set var="sumVip" value=" ${payNum}"></c:set>

            <div style="float: left; width: 60%">
                <table
                        style="float: left; width: 100%; margin-top: 10px; line-height: 25px; margin-left: 30px; font-weight: bold;">
                    <c:forEach var="province" items="${provinceList}">
                        <tr>
                            <td style="width: 28%;">${province.province}</td>
                            <td style="width: 28%;">${province.zhibiaoValue}</td>
                            <td style="width: 5%"></td>
                            <td style="width: 32%;"><fmt:formatNumber
                                    value="${province.zhibiaoValue/sumVip*100}"
                                    pattern="#,###,###,###.#"/>%
                            </td>
                            <td style="width: 15%"></td>
                        </tr>
                    </c:forEach>
                </table>
            </div>
        </div>
    </div>
    <div class="d_right">
        <div class="zi">
            <span>影片收入</span><a
                href="${pageContext.request.contextPath}/tj/movieIncome/incomeDetail">查看全部</a>
        </div>
        <div class="tu">
            <table class="page-list" cellpadding="0" cellspacing="0" border="0">
                <tbody>
                <tr>
                    <th>&nbsp;&nbsp;&nbsp;影片PID</th>
                    <th>专辑ID</th>
                    <th>影片收入</th>
                    <th>收入占比</th>
                </tr>
                <c:set var="index" value="0"></c:set>
                <c:forEach var="m" items="${movieList}">
                    <c:set var="count" value="${count+1}"/>
                    <tr>
                        <td title="searchindex" class="page-title"><span
                                class="page-order">${count }</span>${m.pid }</td>
                        <td title="xxx" class="page-title">${m.name }</td>
                        <td class="ar">${m.income}</td>
                        <td class="ratio">
                            <div title="${m.percent}"
                                 style="height: 16px; line-height: 16px;background-color:#DCEBFE; width:${m.percent};">${m.percent}</div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

        </div>
    </div>
</div>
</body>
</html>



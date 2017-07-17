<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>订单转化率统计</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            parent.$.messager.progress('close');
            searchFun();
        });

        function renderDataGrid(url) {
            return $('#dataGrid').datagrid({
                url: url,
                fit: false,
                fitColumns: true,
                border: false,
                pagination: true,
                idField: 'id',
                setTitle: '数据详情',
                pageSize: 10,
                pageList: [10, 20, 30, 40, 50],
                //sortName: 'date',
                //sortOrder: 'asc',
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                striped: true,
                rownumbers: true,
                singleSelect: true,
                remoteSort: false,
                frozenColumns: [
                    []
                ],
                queryParams: $.serializeObject($('#searchForm')),
                columns: [
                    [
                        {
                            field: 'date',
                            title: '日期',
                            width: '120'
                        },
                        {
                            field: "cashierUv",
                            title: '收银台流量',
                            width: '120'
                        },
                        {
                            field: "confirmOpenedUv",
                            title: '确认开通流量',
                            width: '120'
                        },
                        {
                            field: "immediatelyPayUv",
                            title: '立即支付流量',
                            width: '120'
                        },
                        {
                            field: "succOrderCountUv",
                            title: '成功订单数',
                            width: '120'
                        },
                        {
                            field: "confirmOpenedRate",
                            title: '订单转化率',
                            width: '120',
                            formatter: function (value, row, index) {
                                return value + "%";
                            }
                        },
                        {
                            field: "succOrderRate",
                            title: '支付成功率',
                            width: '120',
                            formatter: function (value, row, index) {
                                return value + "%";
                            }
                        },
                        {
                            field: "succOrderCashierRate",
                            title: '收银台转化率',
                            width: '120',
                            formatter: function (value, row, index) {
                                return value + "%";
                            }
                        }
                    ]
                ],
                toolbar: '#toolbar',
                onLoadSuccess: function (data) {
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

        //渲染总结数据
        function renderSummary(data) {
            var summ = '<tr>';
            $.each(data, function (index, value) {
                summ += '<td><dl><span>' + value.name + '</span></dl><dd><i><b>' + value.data + '</b>' + '<span class=' + value.icon + '></span><span>' + value.rate + '</span></i></dd>';
            })
            summ += '</tr>';
            $('#summary').empty().append(summ);
            $('#cashierUv').empty().append(data.cashierUv);
        }
        //渲染漏斗图形
        function renderFunnelGraph(table, data) {
            var trs = '';
            $.each(data, function (i, obj) {
                trs += '<tr><td>' + obj.name + '</td><td>' + obj.count + '</td><td>' + obj.rate + '</td></tr>';
            });
            $('#' + table).empty().append(trs);
        }
        function exportExcel() {
            var s = $("input[name=dateStart]").val();
            var s1 = $("input[name=dateEnd]").val();
            if (Math.abs(((new Date(Date.parse(s1)) - new Date(Date.parse(s))) / 1000 / 60 / 60 / 24)) - 120 < 0) {
                dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
            } else {
                alert("查询时间范围是120天!!!");
            }
            location.href = '${pageContext.request.contextPath}/tj/hookstat/payFlowNew/excel?' + $('#searchForm').serialize();
        }

        function searchFun() {
            detailDateArr = [];
            dateArr = [];
            var s = $("input[name=dateStart]");
            var s1 = $("input[name=dateEnd]").val();
            if (s.dateDiff(s1) > 120) {
                alert("查询时间范围是120天!!!");
                return;
            }
            var terminal = $("select[name=terminal]").val();
            if(terminal==1||terminal==2||terminal==111){
                detailDateArr = [];
                $(".date_btn").remove();
            }
            $(".date_btn").removeClass("hover_date");
            $("#serial").show();
            $("#serial2").hide();
            //加载当日总结数据
            loadCurrSummary(1);
            //加载转化率曲线图
            loadCashierChart();
            //加载套餐柱状图
            loadSuitColumn();
            //加载套餐折线图
            loadSuitSerial();
            //加载漏斗图分析数据
            loadFunnelGraph();
            //加载表格
            loadDataGrid();
        }

        function loadDataGrid() {
            if (!dataGrid) {
                dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/hookstat/payFlowNew/dataGrid');
            } else {
                dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
            }
        }

        function loadCashierChart() {
            var url = '${pageContext.request.contextPath}/tj/hookstat/payFlowNew/serial';
            var params = $.serializeObject($('#searchForm'));
            $.post(url, params, function (rows) {
                for(var i in rows){
                    dateArr.push(rows[i].date);
                }
                //根据长度设置步长，防止x轴数据太多显示不全
                var step = Math.round(rows.length / 6);
                $('#serial').highcharts({
                    title: {
                        text: '收银台转化率趋势',
                        x: -20
                    },
                    xAxis: {
                        gridLineColor: '#f1f1f1',
                        tickInterval: step,
                        categories: $.map(rows, function (element) {
                            return element['date'];
                        })
                    },
                    credits: {
                        enabled: false
                    },
                    yAxis: {
                        gridLineColor: '#f1f1f1',
                        title: {
                            text: '转化率'
                        },
                        plotLines: [{
                            value: 0,
                            width: 1,
                            color: '#808080'
                        }],
                        labels: {
                            formatter: function () {
                                return this.value + '%';
                            }
                        },
                        //tickInterval: 4,
                        max: 20,
                        min: 0
                    },
                    tooltip: {
                        shared: true,
                        headerFormat: '<span style="font-size:10px">{point.key}</span>',
                        pointFormat:"<p><span>{series.name}&nbsp;:&nbsp;</span><span>{point.y:.1f}</span></p><p>"+((params.terminal==112||params.terminal==113)?"<a href='javascript:;' onclick='viewDetails(\"{point.x}\",1)'>查看详情</a>":"")+"</p>",
                        useHTML: true,
                        valueSuffix: '%'

                    },
                    legend: {
                        layout: 'vertical',
                        align: 'right',
                        verticalAlign: 'middle',
                        borderWidth: 0
                    },
                    series: [
                        {
                            name: '转化率',
                            color: '#51A7F9',
                            text:"占比",
                            data: $.map(rows, function (element) {
                                var rate = element['succOrderRateUv'];
                                return parseFloat(rate.toFixed(2));
                            })
                        }]
                });
            },
            'json'
        )
        }
        //查看详情
        var detailDateArr = [];
        var dateArr = [];
        function viewDetails(num,add) {
            var colors = ['#5D9CEC','#DA4453','#FFCE54','#EC87C0','#AC92EC','#48CFAD','#A0D468','#4FC1E9','#FC6E51'];
            if(add){
                detailDate.dateStart = dateArr[num];
                detailDate.dateEnd = dateAdd(dateArr[num]);
                loadSuitColumn(dateArr[num]);
                loadSuitSerial(dateArr[num]);
                loadFunnelGraph(dateArr[num]);
                $(".button-bag button").attr('createdate',dateArr[num]);
                if($(".d"+dateArr[num]).length>0){
                    $(".d"+dateArr[num]).trigger('click');
                }else{
                    if(detailDateArr.length==0){
                        detailDateArr.push(dateArr[num]);
                        $('<span class="date_btn hover_date d'+dateArr[num]+'" date-num = "'+num+'">'+dateArr[num]+'<a class="">×</a></span>').appendTo('.detail_title');
                    }else{
                        var notMast = false;
                        for(var i=0;i<detailDateArr.length;i++){
                            if(dateArr[num]<detailDateArr[i]){
                                notMast = true;
                                $('.d'+detailDateArr[i]).before('<span class="date_btn hover_date d'+dateArr[num]+'" date-num = "'+num+'">'+dateArr[num]+'<a class="">×</a></span>');
                                detailDateArr.splice(i,0,dateArr[num]);
                                break;
                            }
                        }
                        if(!notMast){
                            detailDateArr.push(dateArr[num]);
                            $('<span class="date_btn hover_date d'+dateArr[num]+'" date-num = "'+num+'">'+dateArr[num]+'<a class="">×</a></span>').appendTo('.detail_title');
                        }
                    }

                }

            }
            $(".date_btn").unbind("click").click(function () {
                var thisNum = $(this).attr('date-num')
                $(".date_btn").removeClass("hover_date");
                $(".d"+dateArr[thisNum]).addClass("hover_date");
                var str = $(this).text();
                var createDate = str.substr(0,str.length-1);
                detailDate.dateStart = createDate;
                detailDate.dateEnd = dateAdd(createDate);
                viewDetails(thisNum);
                loadSuitColumn(createDate);
                loadSuitSerial(createDate);
                loadFunnelGraph(createDate);
                $(".button-bag button").attr('createdate',createDate);
            });
            $(".title_text").unbind('click').click(function () {
                $(".date_btn").removeClass("hover_date");
                $("#serial").show();
                $("#serial2").hide();
                searchFun();
                $(".button-bag button").attr('createdate','');
            });
            $(".date_btn a").unbind('click').click(function (e) {
                e.stopPropagation();
                var str = $(this).parent('span').text()
                var text = str.substr(0,str.length-1);
                for(var i=0;i<detailDateArr.length;i++){
                    if(text==detailDateArr[i]){
                        detailDateArr.splice(i,1);
                    }
                }
                $(".d"+text).remove();
                $(".detail_title span:last").trigger('click');
            })
            var param = $.serializeObject($('#searchForm'));
            param.createdate = dateArr[num];
            $.ajax({
                type: 'POST',
                cache: false,
                url: '${pageContext.request.contextPath}/tj/hookstat/payFlowNew/serial',
                data: param,
                dataType: 'json',
                success: function(data) {
                    if(data){
                        load_pie(data,colors);
                    }
                    $("#serial").hide();
                    $("#serial2").show();
                    var html = '<tr><th></th><th>UV来源</th><th>UV数量</th><th width="100"></th><th>转化率</th><th width="100"></th></tr>';
                    for(var i in data){
                        html += '<tr><td><span class="color_box" style="background: '+colors[i]+'"></span></td><td>'+data[i].name+'</td>'+
                                '<td>'+data[i].data+'</td><td><img src="/static/style/images/stat/'+data[i].icon+'.jpg"/>'+data[i].rate+'</td>'+
                                '<td>'+data[i].data1+'</td><td><img src="/static/style/images/stat/'+data[i].icon1+'.jpg"/>'+data[i].rate1+'</td></tr>'
                    }
                    $(".detail_table").html(html);
                }
            });
        }
        function load_pie(data,colors) {

            var arr = [];
            for(var i in data){
                arr.push({name:data[i].name,y:parseFloat(data[i].data1),color:colors[i]});
            }
            $('#detail_pie').highcharts({
                chart: {
                    plotBackgroundColor: null,
                    plotBorderWidth: null,
                    plotShadow: false
                },
                title: {
                    text: 'PC收银台UV来源及转化率',
                    align:'center',
                    y:240
                },
                credits: {
                    enabled: false
                },
                tooltip: {
                    pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
                },
                plotOptions: {
                    pie: {
                        size:160,
                        innerSize:80,
                        center:['50%','30%'],
                        allowPointSelect: true,
                        cursor: 'pointer',
                        dataLabels: {
                            enabled: false
                        },
                        showInLegend: false
                    }
                },
                series: [{
                    type: 'pie',
                    name: '占比',
                    data: arr
                }]
            });
        }
        function loadSuitColumn(createDate) {
            var params = $.serializeObject($('#searchForm'))
            if(createDate){
                params.dateStart = createDate;
                params.dateEnd = dateAdd(createDate);
            }
            $.getJSON('${pageContext.request.contextPath}/tj/hookstat/payFlowNew/suitColumn', params, function (result) {
                $('#suitColumn').highcharts({
                    chart: {
                        type: 'column'
                    },
                    title: {
                        text: '套餐订单数'
                    },
                    xAxis: {
                        gridLineColor: '#f1f1f1',
                        categories: result.categories
                        /* [
                            '连续包月',
                            '包年',
                            '包季',
                            '包月'
                        ] */,
                        crosshair: true
                    },
                    yAxis: {
                        gridLineColor: '#f1f1f1',
                        min: 0,
                        title: {
                            text: '订单数'
                        }
                    },
                    credits: {
                        enabled: false
                    },
                    tooltip: {
                        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                        '<td style="padding:0"><b>{point.y}</b></td></tr>',
                        footerFormat: '</table>',
                        shared: true,
                        useHTML: true
                    },
                    plotOptions: {
                        column: {
                            pointPadding: 0.2,
                            borderWidth: 0
                        }
                    },
                    series:result.series
                    /*[{
                        name: '乐次元',
                        data: result.commonVipList,
                        color: '#51A7F9'
                    }, {
                        name: '超级影视',
                        data: result.supperVipList,
                        color: '#FFCB30'
                    }] */
                });
            });
        }

        function loadSuitSerial(createDate,$this) {
            var params = $.serializeObject($('#searchForm'))
            if(createDate){
                params.dateStart = createDate;
                params.dateEnd = dateAdd(createDate);
            }else{
                if ($this){
                    var date = $this.attr('createdate');
                    if(date){
                        params.dateStart = date;
                        params.dateEnd = dateAdd(date);
                    }
                }
            }
            var vipType = "";
            if ($this) {
                vipType = $($this).html();
                $(".button-bag button").addClass("no-hover");
                $($this).removeClass("no-hover");
                params = $.extend(params, {viptype: $this.val()});
                $this.addClass("selected").siblings().removeClass("selected");
            } else {
                vipType = "乐次元"
                $(".button-bag button").addClass("no-hover");
                $($(".button-bag button")[0]).removeClass("no-hover");
            }
            $.getJSON('${pageContext.request.contextPath}/tj/hookstat/payFlowNew/suitSerial', params, function (result) {
            	if(params.terminal == 111){
            		$('div.button-bag').hide();
            	}else{
            		$('div.button-bag').show();
            	}
                //根据长度设置步长，防止x轴数据太多显示不全
                var rows = result.pkgList;
                var step = Math.round(rows.length / 6);
                $('#suitSerial').highcharts({
                    title: {
                        text: vipType + '套餐转化趋势',
                        x: -20
                    },
                    xAxis: {
                        gridLineColor: '#f1f1f1',
                        tickInterval: step,
                        categories: $.map(rows, function (element) {
                            return element['date'];
                        })
                    },
                    credits: {
                        enabled: false
                    },
                    yAxis: {
                        gridLineColor: '#f1f1f1',
                        title: {
                            text: '转化率(%)'
                        },
                        plotLines: [{
                            value: 0,
                            width: 1,
                            color: '#808080'
                        }]
                    },
                    tooltip: {
                        shared: true
                    },
                    series: [
                        {
                            name: result.serialNames[0],
                            color: '#51A7F9',
                            data: $.map(rows, function (element) {
                                return element['continueRate'];
                            }),
                            tooltip: {
                                valueSuffix: ' %'
                            }
                        },
                        {
                            name: result.serialNames[1],
                            color: '#22BA66',
                            data: $.map(rows, function (element) {
                                return element['yearRate'];
                            }),
                            tooltip: {
                                valueSuffix: ' %'
                            }
                        },
                        {
                            name: result.serialNames[2],
                            color: '#FFCB30',
                            data: $.map(rows, function (element) {
                                return element['quarterRate'];
                            }),
                            tooltip: {
                                valueSuffix: ' %'
                            }
                        },
                        {
                            name: result.serialNames[3],
                            color: '#E741C6',
                            data: $.map(rows, function (element) {
                                return element['monthRate'];
                            }),
                            tooltip: {
                                valueSuffix: ' %'
                            }
                        }]
                });
            });
        }

        function loadCurrSummary(type,that) {
            $(".date_tab").addClass("no-hover");
            if(that){
                $(that).removeClass("no-hover");
            }else{
                $($('.date_tab')[0]).removeClass("no-hover");
            }
            $.getJSON('${pageContext.request.contextPath}/tj/hookstat/payFlowNew/currInfo', $.extend($.serializeObject($('#searchForm')), {type: type}), function (result) {
                //总支付数据
                renderSummary(result.summary);
            });
        }

        function loadFunnelGraph(createDate) {
            var params = $.serializeObject($('#searchForm'))
            if(createDate){
                params.dateStart = createDate;
                params.dateEnd = dateAdd(createDate);
                params.createdate = createDate;
            }
            $.getJSON('${pageContext.request.contextPath}/tj/hookstat/payFlowNew/funnelAnalyze', params, function (result) {
                var graphTitle = '';
                var graph = '';
                var rowNum = 2;
                $.each(result, function (index, list) {
                    if (index % rowNum == 0)
                        graph += '<div>';
                    $.each(list, function (i, value) {
                        if (i == 0) {
                            graph += '<div style="width:48%;height:200px;margin-left:14px;float:left;position:relative;">' + value.name + (value.comment ? '<span class="hover-ask"></span><span class="hover-help hide">' + value.comment + '</span>' : '') + '<table>';
                        } else {
                            if(createDate){
                                graph += '<tr><td>' + value.name + '</td><td style="padding-left:15px;"><b>' + value.count + '</b></td><td><span class="bar"><i style="width:' + value.rate + '"></i></span></td><td>' + value.rate + '</td><td>' + (value.icon ? '<img style="margin-left: 10px" src="/static/style/images/stat/'+value.icon+'.jpg"/>' : '') + '</td><td>' + (value.data ? '<span>' + value.data + '</span>' : '') + '</td></tr>';
                            }else{
                                graph += '<tr><td>' + value.name + '</td><td style="padding-left:15px;"><b>' + value.count + '</b></td><td><span class="bar"><i style="width:' + value.rate + '"></i></span></td><td>' + value.rate + '</td><td style="position:relative;">' + (value.comment ? '<span class="hover-ask"></span><span class="hover-help hide">' + value.comment + '</span>' : '') + '</td></tr>';
                            }
                            if (i == list.length - 1)
                                graph += '</table></div>';
                        }
                    });
                    if (index % rowNum == 1 || index == result.length - 1)
                        graph += '</div>';
                });
                graph = graphTitle + graph;
                $('#funnel').html(graph);
                $(".hover-ask").hover(function () {
                    $(this).next("span").toggleClass("hide");
                })
            });
        }
        function dateAdd(str) {
            str = str.replace(/-/g,"/");
            var date = new Date(str );
            date = date.valueOf()
            date = date + 24 * 60 * 60 * 1000
            date = new Date(date)
            var year = date.getFullYear();
            var month = date.getMonth()+1;
            month = month<10?'0'+month:month;
            var day = date.getDate();
            return year+'-'+month+'-'+day;
        }
        var detailDate = [];
        function seeMoreDetail() {
            detailDate.terminal = $("select[name=\'terminal\']").val();
            if(detailDate.dateStart){
                parent.iframeTab.init({url:'/tj/cashier/refFlow/index?dateStart='+detailDate.dateStart+'&dateEnd='+detailDate.dateEnd+'&terminal='+detailDate.terminal+'',text:'收银台渠道流量'});
            }
        }
    </script>
    <style type="text/css">
        .title2 {
            font-size: 16px;
            font-weight: bold;
            padding: 10px;
            font-family: '微软雅黑';
            width: 80%;
            padding-top: 20px;
            margin-bottom:10px;
        }
        .title2 .date_btn{display:inline-block;position:relative;font-weight: normal;border:1px solid #ddd;border-radius: 3px;font-size: 12px;padding: 1px 5px;
            margin-right:8px;cursor: pointer;}
        .title2 .title_text{cursor: pointer;}
        .title2 .date_btn:hover{box-shadow: 0 3px 3px #ccc;}
        .title2 .hover_date{box-shadow: 0 3px 3px #ccc;}
        .title2 .date_btn a{position: absolute;top:-4px;right:-4px;width: 11px;height: 10px;border-radius: 10px;background: #eee;font-size: 14px;line-height: 10px;color: #0081c2;
            border:1px solid #00a9d5;cursor: pointer;}
        .title2 .date_btn a:hover{text-decoration: none}
        .color_box{display: inline-block;width: 10px;height:10px;}
        .detail_table{margin-top: 10px;margin-left: 20px}
        .detail_table td,.detail_table th{padding: 3px 10px;}
        .detail_table td:nth-child(2n),.detail_table th:nth-child(2n){padding-right: 20px;}
        .detail_table img,#funnel img{width: 10px;height: 10px;margin-right: 5px;}
        .bb {
            border-bottom: 1px solid #ddd;
        }

        .tb {
            width: 100%;
            background: #fff;
        }

        .summary {
            border-left: 0;
            border-right: 0;
            border-top: 1px solid #ddd;
            border-bottom: 1px solid #ddd;
            font-family: '微软雅黑';
            width: 100%;
        }

        .summary td {
            border-right: 1px solid #ddd;
            border-left: 0;
            margin: 20px 0;
            padding: 20px;
            width: 19%;
        }

        .summary td:nth-child(5) {
            border-right: 0;
        }

        .summary td dl {
            font-size: 16px;
            padding-bottom: 10px;
        }

        .summary td dd i b {
            font-size: 24px;
            font-weight: normal;
            font-style: normal;
        }

        .summary td dd i span.up {
            display: inline-block;
            margin: 0 2px;
            width: 10px;
            height: 10px;
            background: url("/static/style/images/stat/up.jpg") no-repeat center;
            background-size: contain;
        }

        .summary td dd i span.down {
            display: inline-block;
            margin: 0 2px;
            width: 10px;
            height: 10px;
            background: url("/static/style/images/stat/down.jpg") no-repeat center;
            background-size: cover;
        }

        .hover-ask {
            width: 16px;
            height: 16px;
            display: inline-block;
            background: url("/static/style/images/stat/grayi.jpg") no-repeat center;
            background-size: contain;
            border-radius: 15px;
            margin-left: 10px;
        }

        .hover-help {
            position: absolute;
            left: 30px;
            top: 30px;
            width: 240px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-shadow: 0px 0px 5px #ccc;
            background: #fff;
            z-index: 2000;
            font-family: '微软雅黑';
        }

        table .hover-help {
            left: -140px;
        }

        .hide {
            display: none;
        }

        .bar {
            width: 180px;
            height: 16px;
            background: #eee;
            display: block;
            position: relative;
            margin: 0 15px;
        }

        .bar i {
            display: block;
            background: #51A7F9;
            height: 16px;
            poaition: absolute;
            left: 0;
            top: 0;
        }

        .funnel table {
            margin-left: 20px;
            font-family: '微软雅黑';
        }

        .funnel table tr {
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }

        .funnel table tr td {
            padding: 10px 0;
        }

        .datagrid-mask-msg {
            position: absolute;
            top: 300px;
        }

        .button-bag {
            position: absolute;
            bottom: 37px;
            right: 20px;
        }

        .button-bag button:nth-child(1) {
            background: #51A7F9;
        }

        .button-bag button:nth-child(2) {
            background: #FFCB30;
        }

        button {
            display: block;
            float: left;
            background: #00a1e9;
            width: 80px;
            text-align: center;
            border: 0;
            padding: 3px 4px;
            font-size: 12px;
            color: #274b6d;
            font-family: '微软雅黑';
        }
        .date_tab{width: 50px;}
        button.no-hover {
            background: #eee !important;
        }

        button:focus {
            border: 0;
            outline: -webkit-focus-ring-color auto 0px;
        }
    </style>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false" style="height: 120px; overflow: auto;">
        <form id="searchForm">
            <table class="table table-hover table-condensed">
                <tr>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>终端</td>
                    <td>查询类别</td>
                </tr>
                <tr>
                    <td>
                        <input name="dateStart" class="easyui-datebox" data-options="required:true"
                               value="${dateStart}" style="width: 160px; height: 29px"/>
                    </td>
                    <td>
                        <input name="dateEnd" class="easyui-datebox" data-options="required:true"
                               value="${dateEnd}" style="width: 160px; height: 29px">
                    </td>
                    <td>
                    	<select name="terminal" style="width:160px;height:29px">
                            <option value="112">PC</option>
                            <option value="113">M站</option>
                            <option value="1">Android</option>
                            <option value="2">iPhone</option>
                            <!-- <option value="5">iPad</option> -->
                            <option value="111">TV</option>
                        </select>
                    </td>
                    <td>
                        <select name="PVorUV" style="width:160px;height:29px">
                            <option value="2">UV</option>
                            <option value="1">PV</option>
                        </select>
                    </td>
                </tr>
            </table>
        </form>
    </div>

    <div class="aaa" data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>

</div>
<div id="toolbar" style="display: none;">
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true"
       onclick="searchFun();">查询</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true"
       onclick="exportExcel();">导出excel</a>

    <div class="tb">
        <div class="title2 clearfix">
            <span class="title_text" style="float: left;line-height: 30px;">昨日转化关键数据：</span>
            <span class="clearfix" style="margin-left:20px;float: left;border:1px solid #ddd;">
                <button class="date_tab" onclick="loadCurrSummary(1,this)" style="border-right: 1px solid #fff;">昨日</button>
                <button class="date_tab" onclick="loadCurrSummary(2,this)" style="border-right: 1px solid #fff;">周</button>
                <button class="date_tab" onclick="loadCurrSummary(3,this)">月</button>
            </span>
        </div>

        <div>
            <table id="summary" class="summary" cellpadding="0" cellspacing="1" border="1"></table>
        </div>
        <div class="title2 bb detail_title"> <span class="title_text">收银台转化率:</span>
            <%--<span class="hover_date date_btn">2017-02-22<a class="">×</a></span>
            <span>2017-02-22<a class="">×</a></span>
            <span>2017-02-22<a class="">×</a></span>
            <span>2017-02-22<a class="">×</a></span>--%>
        </div>
        <div id="serial" style="min-width: 310px; height: 300px; margin: 0 auto; overflow: auto;"></div>
        <div id="serial2" style="min-width: 310px; height: 300px; margin: 0 auto; overflow: auto;display: none">
            <div id="detail_pie" style="float: left;height: 300px;min-width: 300px;width: 30%;"></div>
            <div style="width: 60%;float: left;">
                <table class="detail_table"></table>
                <p style="margin-top: 10px;"><a href="javascript:;" onclick="seeMoreDetail()" style="margin-left: 450px;">查看更多详情</a></p>
            </div>

        </div>
        <div class="title2 bb detail_title"><span class="title_text">套餐订单与转化率：</span></div>
        <div class="clearfix">
            <div id="suitColumn" style="width:30%;height:300px;float:left;"></div>
            <div style="width:5%;height:320px;float:left;"></div>
            <div style="width:62%;height:320px;float:left;position: relative;">
                <div id="suitSerial" style="width:100%;height:300px;"></div>
                <div class="button-bag">
                    <button type="button" value="1" createdate="" onclick="loadSuitSerial('',$(this))">乐次元</button>
                    <button class="no-hover" type="button" createdate="" value="9" onclick="loadSuitSerial('',$(this))">超级影视</button>
                </div>
            </div>
        </div>
        <div class="funnel clearfix">
            <div class="title2 bb detail_title"><span class="title_text">转化漏斗分析：</span></div>
            <div id="funnel"></div>
        </div>
        <div class="title2" style="margin-bottom: 0">数据详情：</div>
    </div>
</div>
</body>
</html>
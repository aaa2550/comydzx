<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>道具配置</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script  src="/js/kv/propsBusiness.js"></script>
    <script  src="/js/kv/propsChannel.js"></script>
    <script  src="/js/kv/propsOperateType.js"></script>
    <style type="text/css">
        a.propsOperation:link, a.propsOperation:visited {
            border-right: 1px solid grey;
            padding-right: 5px;
            padding-left: 5px;
            text-decoration: none;
            color: black;
        }

        a.propsOperation:hover {
            color: #8888FF;
            text-decoration: underline;
        }

        /*道具图片部分样式*/
        table tr td {
            padding: 0;
            position: relative;
        }
        .prop_lists{
            margin-bottom:14px;
        }
        .prop_wrap {
            position: relative;

        }
        .prop_detail_1{
            position: absolute;
            width: 100%;
            left: 0;
            padding: 5px 0 5px 0px;
            height: 50px;
        }

        .prop_detail {
            position: absolute;
            width: 50px;
            left: 0;
            padding: 5px;
            height: 50px;
        }

        .prop_detail_1 dt {
            padding-left: 10px;
            width: 45px;
            height: 45px;
            float: left;
            text-align: center;
        }

        .prop_detail dt img,.prop_detail_1 dt img {
            display: block;
            margin: 0 auto;
            border-radius: 50%;
            width: 45px;
            height: 45px;
        }

        .prop_detail_1 dd {
            text-align: left;
            padding:4px 0px 0 5px;
            float: right;

            width:64%;
        }
        .prop_detail_1 dd h4{
            font-size: 12px;
            font-weight:normal;
            line-height: 16px;
        }
        .prop_detail_1 .a_link_color{
            color:#08c;
        }


        .prop_detail span{
            position:relative;
            right:-33px;
            top:-48px;
            font-size:14px;
            display:inline-block;
            text-align:center;
            width:16px;
            line-height:16px;
            background-color:gray;
            border-radius:50%;
            color: #0000ff;
        }

        .add_brn {
            background-color: #cccccc;
            height: 14px;
            line-height: 14px;
            text-align: center;
            display: inline-block;
            width: 100%;
            position: absolute;
            bottom: 0;
            left: 0;
            color:#08c;

        }
        .add_brn:hover,.prop_detail_1 .a_link_color:hover{
            color: blue;
            text-decoration: underline;
        }
    </style>
    <script>
        (function ($) {

            $.fn.extend({
                changePlace: function (op) {
                    var changeFn = {
                        elx: 0,
                        ely: 0,
                        x: 0,
                        y: 0,
                        siblings: [],
                        index: undefined,
                        sib: null,
                        parentx: 0,
                        parenty: 0,
                        done: true,
                        limit: null,
                        changeTypeFlag: undefined,
                        changeType: "replace",
                        zindex: 1,
                        hoverColor: "red",
                        curColor: "blue",
                        siblingsLen: 0,
                        numPerLine:1,
                        onChangedFn: function () {

                        }

                    };

                    $.extend(changeFn, op);
                    changeFn.init = function (el) {

                        this.bindEvent(el);

                    };
                    changeFn.recordXY = function (el, e) {
                        this.elx = el.offset().left;
                        this.ely = el.offset().top;
                        this.x = e.pageX - this.elx;
                        this.y = e.pageY - this.ely;
                        this.parentx = el.parent().offset().left;
                        this.parenty = el.parent().offset().top;
                        //console.log(this.elx, this.parentx)
                        this.x = this.x + this.parentx;
                        this.y = this.y + this.parenty;
                    };
                    changeFn.sortSiblings = function (sib) {

                        var rowsObj=[],endArr=[];
                        var listSib = [];
                        if(sib.length<=0){
                            return;
                        }

                        var rowHeight=sib.eq(0).outerHeight();
                        //console.log(sib);
                        var firstOffsetTop=sib.parent().offset().top;
                        this.siblingsLen = sib.length;

                        rows=Math.ceil(sib.length/this.numPerLine);
                        for (var i = 0; i < this.siblingsLen; i++) {

                            for(var j=0;j<=rows;j++){
                                if(sib.eq(i).offset().top == j*rowHeight+firstOffsetTop){
                                    if(typeof rowsObj[j] == "undefined" ){
                                        rowsObj[j]=[];
                                    }
                                    var cc={};
                                    cc.top=sib.eq(i).offset().top;
                                    cc.left=sib.eq(i).offset().left;
                                    cc.ele=sib.eq(i).get(0);
                                    rowsObj[j].push(cc);
                                    break
                                }
                            }
                        }
                        for(var n=0;n<rowsObj.length;n++){
                            rowsObj[n].sort(function(a,b){
                                return a.left - b.left||rowsObj[n].indexOf(a) - rowsObj[n].indexOf(b);
                            })
                        }
                        for(var m=0;m<rowsObj.length;m++){
                            endArr=endArr.concat(rowsObj[m]);
                        }


                        for (var l = 0; l < endArr.length; l++) {
                            endArr[l].ele.index=l;
                            //console.log( endArr[l].ele.index);
                            listSib.push(endArr[l].ele);
                        }
                        //console.log(listSib);
                        return listSib;
                    };
                    changeFn.recordSiblingsXY = function (el, e) {
                        var _this = this;
                        _this.siblings = [];
                        _this.sib = el.siblings(_this.curClass || $(this).get(0).nodeName.toLowerCase());
                        if(_this.sib.length<=0){
                            return;
                        }
                        _this.sib = _this.sortSiblings(_this.sib)
                        $.each(_this.sib, function (index, value) {
                            var obj = {}, offset = $(value).offset();
                            obj.x = offset.left;
                            obj.y = offset.top;
                            _this.siblings[index] = obj;
                        })
                    };
                    changeFn.bindEvent = function (el) {

                        el.parent().each(function(index,value){
                            var ela=$(value).children()
                            for(var g=0;g<ela.length;g++){
                                ela.get(g).index=g

                            }

                        })
                        var _this = this;
                        el.on("mousedown", function (e) {
                            _this.els=$(this).parent().children();
                            //_this.done避免重复拖拽
                            if (!_this.done) return;
                            _this.done = false;

                            var ele = this;
                            _this.zindex++;

                            // 保存初始颜色
                            _this.originColor = $(this).css('background-color');

                            // 当前拖拽对象更改颜色
                            $(this).css({
                                'z-index': _this.zindex,
                                'cursor':"move",
                                'background-color': _this.curColor
                            })

                            // 记录当前对象位置
                            _this.recordXY($(this), e);

                            // 以top值序列化兄弟节点
                            _this.recordSiblingsXY($(this), e);

                            // 当前拖拽对象的index


                            _this.curIndex =this.index-0.5;
                            //console.log(_this.curIndex);


                            // 区分ie和其他浏览器的分别绑定事件
                            if (ele.setCapture) {
                                ele.setCapture();
                                _this.mousemove(ele, ele)
                                _this.mouseup(ele, ele)
                            } else {
                                _this.mousemove(document, ele)
                                _this.mouseup(document, ele)
                            }
                        })
                    };
                    changeFn.mousemove = function (doc, ele) {

                        var _this = this;
                        $(doc).on("mousemove", function (e) {
                            e.preventDefault();
                            var el_x = _this.limit === true || _this.limit == "width" ? "initial" : (e.pageX - _this.x), el_y = _this.limit === true || _this.limit == "height" ? _this.limitHeight(e, ele) : e.pageY - _this.y;
                            $(ele).css({
                                "left": el_x,
                                "top": el_y
                            })
                            //碰撞检测；
                            _this.collisionsCheck($(ele), e);
                        });
                    }
                    changeFn.insertFn = function (ele, e) {
                        var _this=this
                        if (this.index > this.curIndex) {
                            // 下移
                            var cur = this.curIndex + .5;
                            //console.log("下移："+this.index,cur);
                            for (var i = cur; i <= this.index; i++) {
                                this.choseAnimate($(ele), e, i)
                                //this.curIndex++;

                            }
                            //this.lastCurIndex = this.curIndex;
                        } else {
                            // 上移


                            var cur = this.curIndex - .5;
                            //console.log("上移："+this.index,cur);

                            for (var i = cur; i >= this.index; i--) {
                                this.choseAnimate($(ele), e, i);
                                //this.curIndex--
                            }
                            //this.lastCurIndex = this.curIndex;


                        }

                    }
                    changeFn.choseAnimate = function (el, e, i) {
                        var _this = this;
                        var theEl = $(this.sib[i]);
                        var x = this.siblings[i].x;
                        var y = this.siblings[i].y;
                        var a = this.siblings[i].x = this.elx;
                        var b = this.siblings[i].y = this.ely;
                        this.elx = x;
                        this.ely = y;

                        theEl.css({
                            "background-color": _this.hoverColor
                        }).stop().animate({
                            "left": a - this.parentx + "px",
                            "top": b - this.parenty + "px"
                        }, 200, function () {

                            $(this).css({
                                "background-color": _this.originColor
                            })
                        })
                    }
                    changeFn.limitHeight = function (e, ele) {
                        var el_y, parentHei = $(ele).outerHeight() * (this.siblingsLen + 1)
                        if ($(ele).offset().top > (this.parenty + parentHei)) {
                            el_y = parentHei - $(ele).outerHeight();
                        } else if ($(ele).offset().top < this.parenty) {
                            el_y = 0
                        } else {
                            if (e.pageY - this.y < 0) {
                                el_y = 0
                            } else if (e.pageY - this.y > (parentHei - $(ele).outerHeight())) {
                                el_y = parentHei - $(ele).outerHeight()
                            } else {
                                el_y = e.pageY - this.y
                            }
                        }
                        return el_y;
                    }
                    changeFn.mouseup = function (doc, ele) {
                        var _this = this;
                        $(doc).on("mouseup", function (e) {
                            e.preventDefault();
                            if (typeof _this.index !== "undefined" && _this.changeType != "insert") {
                                // 碰撞发生

                                $(_this.sib[_this.index]).stop().animate({
                                    "left": _this.elx - _this.parentx + "px",
                                    "top": _this.ely - _this.parenty + "px"
                                }, 200)
                                $(ele).css('background-color', _this.originColor).stop().animate({
                                    "left": _this.siblings[_this.index].x - _this.parentx + "px",
                                    "top": _this.siblings[_this.index].y - _this.parenty + "px"
                                }, 200, function () {
                                    _this.cbfn()

                                });
                                _this.offBind(ele)
                            } else {
                                //碰撞未发生

                                if(_this.index>-1){
                                    _this.insertFn(ele, e);

                                }
                                //$(ele).css('background-color', _this.originColor);






                                $(ele).css('background-color', _this.originColor).stop().animate({
                                    "left": _this.elx - _this.parentx + "px",
                                    "top": _this.ely - _this.parenty + "px"
                                }, 200, function () {
                                    _this.cbfn()
                                })


                                _this.offBind(ele)
                            }
                            _this.sib = null;
                            _this.index=-1;

                        })
                    }
                    changeFn.offBind = function (ele) {
                        if (ele.releaseCapture) {
                            ele.releaseCapture();
                            $(ele).unbind("mousemove");
                        } else {
                            $(document).off();
                        }
                        ;
                    }
                    changeFn.cbfn = function () {
                        this.done = true;
                        this.onChangedFn(this.sortSiblings(this.els));
                    }
                    changeFn.collisionsCheck = function (el, e) {
                        var elx = el.offset().left, ely = el.offset().top, elw = el.outerWidth(), elh = el.outerHeight(), _this = this;
                        var s = [], indexSi = {}, changeValue = null;
                        //if(!_this.changeTypeFlag) return;
                        // 循环遍历每个兄弟节点，判断重合面积
                        $.each(this.siblings, function (index, value) {
                            if (elx < (value.x + elw) && elx > (value.x - elw) && ely < (value.y + elh) && ely > (value.y - elh)) {
                                //判断被移动块与检测块有交集
                                var w, h, wh;
                                if (elx < value.x) {
                                    w = elx + elw - value.x;
                                } else {
                                    w = value.x + elw - elx;
                                }
                                if (ely < value.y) {
                                    h = ely + elh - value.y
                                } else {
                                    h = value.y + elh - ely;
                                }
                                wh = w * h
                                indexSi[wh] = index;
                                s.push(wh);


                                // 重合面积超过53%人为这个兄弟节点重合面积最大 为交换位置对象
                                // if (_this.changeType == "insert" && wh / elw / elh > 0.833) {
                                //     return changeValue = true;
                                // }
                            }
                        })
                        //change
                        // if (_this.changeType == "insert") {
                        //     if (changeValue == true) {

                        //         // 当拖拽时 面积超过53%即不再重复检测（浪费性能，被交换位置对象抖动），移动
                        //         _this.index = _this.index == indexSi[s[0]] && _this.lastCurIndex == _this.curIndex ? undefined : indexSi[s[0]];

                        //         console.log( _this.index);
                        //         // return a;

                        //         //_this.insertFn(el, e)
                        //     }
                        // } else {
                        _this.index = indexSi[Math.max.apply(null, s)]
                        //console.log("_this.index"+_this.index)
                        //}
                    };
                    changeFn.init($(this));
                }
            })
        })(jQuery)
    </script>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            dataGrid = renderDataGrid('/props/operate/query');

            init();
        });

        function init() {
            $("[name='businessId']").trigger("change");
        }

        function renderDataGrid(url) {
            return $('#dataGrid').datagrid({
                url: url,
                fit: true,
                fitColumns: false,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 10,
                pageList: [10, 20, 30, 40, 50],
                sortName: 'id',
                sortOrder: 'asc',
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                striped: true,
                rownumbers: true,
                singleSelect: false,
                remoteSort: false,
                columns: [
                    [
                        {
                            field: 'id',
                            title: 'ID',
                            width: 60,
                            sortable: true
                        },
                        {
                            field: 'name',
                            title: '道具配置名称',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'businessId',
                            title: '业务线',
                            width: 100,
                            formatter: function (value) {
                                return Dict.propsBusiness[value];
                            }
                        },
                        {
                            field: 'channelId',
                            title: '渠道',
                            width: 100,
                            formatter: function (value) {
                                if (Dict.propsChannel[value]) {
                                    return Dict.propsChannel[value].name;
                                }
                                return "";
                            }
                        },
                        {
                            field: 'operateType',
                            title: '运营分类',
                            width: 100,
                            formatter: function (value, row) {
                                if (row.way == 2) {
                                    return Dict.propsOperateType[row.wayValue].name;
                                }
                            }
                        },
                        {
                            field: 'wayValue',
                            title: '直播ID',
                            width: 100,
                            formatter: function (value, row) {
                                if (row.way == 3) {
                                    return value;
                                }
                            }
                        },
                        {
                            field: 'toyList',
                            title: '道具列表',
                            width: 210,
                            formatter: function (value, row, index) {
                                var hei=60;
                                var rows= Math.ceil(value.length/3);
                                var rowHeight = rows * hei+10 + "px";
                                var parentHeight=rows<3?rowHeight : hei*3+10+"px";
                                var str = $.formatString("<div class='prop_lists' style='height:{1}; overflow-y:auto;overflow-x:hidden;'><div class='prop_wrap prop_wrap_scene' style='height:{0}'>", rowHeight,parentHeight);
                                for (var i = 0; i < value.length; i++) {
                                    var config = $.parseJSON(value[i].config);
                                    var pic = "";
                                    if (config['web'].pic) {
                                        pic = config['web'].pic;
                                    } else if (config['mobile'].pic) {
                                        pic = config['mobile'].pic;
                                    } else {
                                        pic = config['tv'].pic;
                                    }
                                    str += $.formatString('<dl class="prop_detail" style="top:{6};left:{3}"><dt><img src="{0}"></dt>' +
                                            '<span onclick="deleteToy({4}, {5});">X</span></p>' +
                                            '<input type="hidden" name="pid" value="{7}"/>' +
                                            '<input type="hidden" name="operateId" value="{8}">' +
                                            '</dd></dl>', pic, value[i].codeName, row.id, i%3*60+"px", row.id, value[i].id, Math.ceil((i+1)/3-1) * 60 + "px", value[i].id, row.id);
                                }
                                str += "</div></div>";
                                //str += $.formatString('<span class="add_brn" onclick="addToys({0}, {1}, 1);">添加</span>', row.liveId, row.businessId);

                                return str;
                            }
                        },
                        {
                            field: 'updateTime',
                            title: '操作时间',
                            width: 150,
                            sortable: true
                        },
                        {
                            field: 'action',
                            title: '操作',
                            width: 200,
                            formatter: function (value, row, index) {
                                var str = $.formatString("<a href='javascript:void(0);' onclick='editOperate({0}, \"{1}\")' class='propsOperation'>修改</a>", row.id, '修改道具配置');
                                str += $.formatString("<a href='javascript:void(0);' onclick='delOperate({0})' class='propsOperation'>删除</a>", row.id);
                                return str;
                            }
                        }
                    ]
                ],
                toolbar: '#toolbar',
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

        /**
         * 查询
         */
        function searchFun() {
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }

        /**
         * 清空
         */
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }

        /**
         * 添加修改
         */
        function editOperate(id, title) {
            parent.$.modalDialog({
                title: title,
                width: 750,
                height: 500,
                href: '${pageContext.request.contextPath}/props/operate/edit?id='+id,
                buttons: [
                    {
                        text: '保存',
                        handler: function () {
                            parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                            var f = parent.$.modalDialog.handler.find('#form');
                            f.submit();
                        }
                    },
                    {
                        text: '取消',
                        handler: function () {
                            parent.$.modalDialog.handler.dialog('close');
                        }
                    }
                ]
            });
        }

        /**
         * 删除
         */
        function delOperate(id){
            $.messager.confirm("询问", "确认删除道具配置吗？", function(b){
                if(!b) return;
                $.post('/props/operate/delete', {id: id},
                        function(json){
                            if(json.code == 0){
                                $.messager.alert("删除道具配置", "删除道具配置成功！");
                                dataGrid.datagrid('load', {});
                            } else {
                                $.messager.alert("删除道具配置", "删除道具配置失败！");
                            }
                        }, "json"
                );
            });
        }

        function deleteToy(operateId, pid) {
            //console.log("直播ID为：" + liveId + " , 道具ID为：" + pid);
            parent.$.messager.confirm("提示", "确认移除此道具吗？", function (flag) {
                if (!flag) return;
                $.post('/props/operate/deleteToy', {operateId: operateId, pid: pid},
                        function (json) {
                            if (json.code == 0) {
                                dataGrid.datagrid('load', {});
                            }
                        }, "json");
            })
        }

    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false" style="overflow: hidden; height: 145px">
        <form id="searchForm">
            <table class="table-more">
                <tr>
                    <td>
                        道具配置名称：<input name="name" style="width: 310px" class="span2">
                    </td>

                    <td>
                        &nbsp;&nbsp;&nbsp;&nbsp;业务线：<%@ include file="/WEB-INF/views/inc/props_business.inc" %>
                        &nbsp;&nbsp;&nbsp;&nbsp;<%@ include file="/WEB-INF/views/inc/props_channel.inc" %>
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
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a><a
        href="javascript:void(0);" class="easyui-linkbutton"
        data-options="iconCls:'brick_delete',plain:true"
        onclick="cleanFun();">清空条件</a>
    <a onclick="editOperate(0, '添加道具配置');" href="javascript:void(0);"
       class="easyui-linkbutton" data-options="plain:true,iconCls:'pencil_add'">添加道具配置</a>
</div>


</body>
</html>
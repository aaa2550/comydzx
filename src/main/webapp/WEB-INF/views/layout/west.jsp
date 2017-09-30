<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript">
var layout_west_tree;
	$(function() {
		  layout_west_tree = $('#layout_west_tree').tree({
			url : '${pageContext.request.contextPath}/sys/tree',
			parentField : 'pid',
			lines : true,
			onLoadSuccess:function(){
			//  数据加载成功， 关闭有子菜单的菜单按钮
				$(".resultset_previous").click();
			},
			onClick : function(node) {
				if (node.attributes &&node.attributes.url ) {
					//iframe = '<iframe src="' + url + '" frameborder="0" style="border:0;width:100%;height:98%;" sandbox></iframe>';
					var iframe = '<iframe src="' + node.attributes.url + '" frameborder="0" style="border:0;width:100%;height:98%;"></iframe>';
					var t = $('#index_tabs');
					var opts = {
						title : node.text,
						closable : true,
						iconCls : node.iconCls,
						content : iframe,
						border : false,
						fit : true,
						url:node.attributes.url,
						cache:false
					};
					if (t.tabs('exists', opts.title)) {
						t.tabs('select', opts.title);
					} else {
						t.tabs('add', opts);
					}
				}
			},
			onSelect:function(node){//选中的时候toggle 展开和收起
				var isLeaf = layout_west_tree.tree('isLeaf', node.target);	
				if(!isLeaf){
					layout_west_tree.tree('toggle', node.target);	
				}
			}
		});
	});
	
	var iframeTab = {
        init:function(params){
        	if(!Boss.util.login()) {
				return ;
			}
            $.messager.progress({
                title : '${internationalConfig.提示}',
                text : '${internationalConfig.数据处理中}....'
            });
            this.loadResult(params);
        },
        loadResult:function(params){
            var node =params;
            var t = $('#index_tabs');
            var opts = {
                title : params.text,
                closable : true,
                border : false,
                fit : true,
                cache:false,
                url:params.url
            };
            if (t.tabs('exists', opts.title)) {
                var tab = t.tabs('getTab', opts.title);
                t.tabs('select', opts.title);
                var panel = tab.panel('panel');
				var frame = panel.find('iframe');
				try {
					if (frame.length > 0) {
						for ( var i = 0; i < frame.length; i++) {
							frame[i].src = params.url;
						}
						if (navigator.userAgent.indexOf("MSIE") > 0) {// IE特有回收内存方法
							try {
								CollectGarbage();
							} catch (e) {
							}
						}
					}
				} catch (e) {
				}
            } else {
                var iframe = '<iframe src="' + params.url + '" frameborder="0" style="border:0;width:100%;height:98%;"></iframe>';
                t.tabs('add', $.extend(opts,{content :iframe}));
            }
        }
    }
</script>
<div class="easyui-accordion" data-options="fit:true,border:false">
	<div title="${internationalConfig.BossManage}" style="padding: 5px;" data-options="border:false,isonCls:'cog',tools : [ {
				iconCls : 'database_refresh',
				handler : function() {
					$('#layout_west_tree').tree('reload');
				}
			}, {
				iconCls : 'resultset_next',
				handler : function() {
					var node = $('#layout_west_tree').tree('getSelected');
					if (node) {
						$('#layout_west_tree').tree('expandAll', node.target);
					} else {
						$('#layout_west_tree').tree('expandAll');
					}
				}
			}, {
				iconCls : 'resultset_previous',
				handler : function() {
					var node = $('#layout_west_tree').tree('getSelected');
					if (node) {
						$('#layout_west_tree').tree('collapseAll', node.target);
					} else {
						$('#layout_west_tree').tree('collapseAll');
					}
				}
			} ]">
		<div class="well well-small">
			<ul id="layout_west_tree"></ul>
		</div>
	</div>
<%--	<div title="普通系统菜单" data-options="border:false,iconCls:'icon-reload'">
		<ul>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
		</ul>
	</div>--%>
</div>
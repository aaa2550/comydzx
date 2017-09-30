<%@ page contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh">
<head>
	<title>${internationalConfig.Boss后台系统}</title>
	<%@ include file="/WEB-INF/views/inc/head.inc"%>
</head>
<body>

<c:if test="${ empty sessionInfo }">
<%@ include file="/WEB-INF/views/inc/login.inc"%>
</c:if>
	
<div id="index_layout">
		<div data-options="region:'north',href:'${pageContext.request.contextPath}/layout/north'" style="height: 70px; overflow: hidden; background:url('${internationalConfig.ImagePath}');" class="logo"  alt="${env }  ${hostName}"  ></div>
		<c:if test="${! empty sessionInfo }">
			<div data-options="region:'west',href:'${pageContext.request.contextPath}/layout/west',split:true" title="${internationalConfig.boss后台管理系统}" style="width: 200px; overflow: hidden;"></div>
		</c:if>
		<div data-options="region:'center'" title="${internationalConfig.欢迎使用boss后台管理系统}" style="overflow: hidden;">
			<div id="index_tabs" style="overflow: hidden;">
				<div title="${internationalConfig.首页}" data-options="border:false" style="overflow: hidden;">
					<iframe src=""   frameborder="0" style="border: 0; width: 100%; height: 98%;"></iframe>
				</div>
			</div>
		</div>
	
	</div>

	<div id="index_tabsMenu" style="width: 120px; display: none;">
		<div title="refresh" data-options="iconCls:'transmit'">${internationalConfig.刷新}</div>
		<div class="menu-sep"></div>
		<div title="close" data-options="iconCls:'delete'">${internationalConfig.关闭}</div>
		<div title="closeOther" data-options="iconCls:'delete'">${internationalConfig.关闭其他}</div>
		<div title="closeAll" data-options="iconCls:'delete'">${internationalConfig.关闭所有}</div>
	</div>
<%@ include file="/WEB-INF/views/inc/footer.inc"%>
<script type="text/javascript">
	var index_tabs;
	var index_tabsMenu;
	var index_layout;
	$(function() {
		index_layout = $('#index_layout').layout({
			fit : true
		});
		/*index_layout.layout('collapse', 'east');*/

		index_tabs = $('#index_tabs').tabs({
			fit : true,
			border : false,
			onContextMenu : function(e, title) {
				e.preventDefault();
				index_tabsMenu.menu('show', {
					left : e.pageX,
					top : e.pageY
				}).data('tabTitle', title);
			},
			onUpdate:function(){
            	$.messager.progress('close');
            }, 
			tools : [ {
				iconCls : 'database_refresh',
				handler : function() {
					if(!Boss.util.login()) {
						return ;
					}
					var href = index_tabs.tabs('getSelected').panel('options').href;
					if (href) {/*说明tab是以href方式引入的目标页面*/
						var index = index_tabs.tabs('getTabIndex', index_tabs.tabs('getSelected'));
						index_tabs.tabs('getTab', index).panel('refresh');
					} else {/*说明tab是以content方式引入的目标页面*/
						var panel = index_tabs.tabs('getSelected').panel('panel');
						var frame = panel.find('iframe');
						try {
							if (frame.length > 0) {
								for ( var i = 0; i < frame.length; i++) {
									frame[i].contentWindow.location.reload();
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
					}
				}
			}, {
				iconCls : 'delete',
				handler : function() {
					var index = index_tabs.tabs('getTabIndex', index_tabs.tabs('getSelected'));
					var tab = index_tabs.tabs('getTab', index);
					if (tab.panel('options').closable) {
						index_tabs.tabs('close', index);
					} else {
						$.messager.alert('${internationalConfig.提示}', '[' + tab.panel('options').title + ']${internationalConfig.不可以被关闭}', 'error');
					}
				}
			} ]
		});

		index_tabsMenu = $('#index_tabsMenu').menu({
			onClick : function(item) {
				var curTabTitle = $(this).data('tabTitle');
				var type = $(item.target).attr('title');

				if (type === 'refresh') {
					var href = index_tabs.tabs('getTab', curTabTitle).panel('options').href;
					if (href) {/*说明tab是以href方式引入的目标页面*/
						var index = index_tabs.tabs('getTabIndex', index_tabs.tabs('getSelected'));
						index_tabs.tabs('getTab', index).panel('refresh');
					} else {/*说明tab是以content方式引入的目标页面*/
						var panel = index_tabs.tabs('getTab', curTabTitle).panel('panel');
						var frame = panel.find('iframe');
						try {
							if (frame.length > 0) {
								for ( var i = 0; i < frame.length; i++) {
									frame[i].contentWindow.location.reload();
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
					}
					return;
				}

				if (type === 'close') {
					var t = index_tabs.tabs('getTab', curTabTitle);
					if (t.panel('options').closable) {
						index_tabs.tabs('close', curTabTitle);
					}
					return;
				}

				var allTabs = index_tabs.tabs('tabs');
				var closeTabsTitle = [];

				$.each(allTabs, function() {
					var opt = $(this).panel('options');
					if (opt.closable && opt.title != curTabTitle && type === 'closeOther') {
						closeTabsTitle.push(opt.title);
					} else if (opt.closable && type === 'closeAll') {
						closeTabsTitle.push(opt.title);
					}
				});

				for ( var i = 0; i < closeTabsTitle.length; i++) {
					index_tabs.tabs('close', closeTabsTitle[i]);
				}
			}
		});
	});


</script>
</body>
</html>

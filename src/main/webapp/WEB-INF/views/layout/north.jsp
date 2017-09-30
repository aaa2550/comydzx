<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript" charset="utf-8">
	/**
	 * 
	 * @requires jQuery,EasyUI,jQuery cookie plugin
	 * 
	 * 更换EasyUI主题的方法
	 * 
	 * @param themeName
	 *            主题名称
	 */
	function changeThemeFun(themeName) {
		if ($.cookie('easyuiThemeName')) {
			$('#layout_north_pfMenu').menu('setIcon', {
				target : $('#layout_north_pfMenu div[title=' + $.cookie('easyuiThemeName') + ']')[0],
				iconCls : 'emptyIcon'
			});
		}
		$('#layout_north_pfMenu').menu('setIcon', {
			target : $('#layout_north_pfMenu div[title=' + themeName + ']')[0],
			iconCls : 'tick'
		});

		var $easyuiTheme = $('#easyuiTheme');
		var url = $easyuiTheme.attr('href');
		var href = url.substring(0, url.indexOf('themes')) + 'themes/' + themeName + '/easyui.css';
		$easyuiTheme.attr('href', href);

		var $iframe = $('iframe');
		if ($iframe.length > 0) {
			for ( var i = 0; i < $iframe.length; i++) {
				var ifr = $iframe[i];
				try {
					$(ifr).contents().find('#easyuiTheme').attr('href', href);
				} catch (e) {
					try {
						ifr.contentWindow.document.getElementById('easyuiTheme').href = href;
					} catch (e) {
					}
				}
			}
		}

		$.cookie('easyuiThemeName', themeName, {
			expires : 7
		});

	};

	function logoutFun(b) {
		$.getJSON('${pageContext.request.contextPath}/logout', {
			t : new Date()
		}, function(result) {
			if (b) {
				location.replace('${pageContext.request.contextPath}/');
			} else {
				$('#sessionInfoDiv').html('');
				$('#loginDialog').dialog('open');
			}
		});
	}
	function changeLocation(name,val){	
            $.cookie(name,val);
            document.location.reload();
	}
	var lanVal = $.cookie('boss_lang')==null ?"${appMap['boss_lang']}":$.cookie('boss_lang')
	var areaVal = $.cookie('boss_country')==null ?"${appMap['boss_country']}":$.cookie('boss_country')
    $("#lanSel option[value="+lanVal+"]").attr("selected", "selected");
    $("#area option[value="+areaVal+"]").attr("selected", "selected");
</script>
<div id="sessionInfoDiv" style="position: absolute; right: 0px; top: 0px;" class="alert alert-info">
	<c:if test="${! empty sessionInfo}">[<strong>${sessionInfo.name}</strong>]，[${env }-${hostIp}], ${internationalConfig.欢迎使用boss后台管理系统}</c:if>
</div>

<div style="position: absolute; right: 0px; bottom: 0px;">
<c:if test="${env =='test' }">
	<span style="color:#f5f5f5;font-size:14px;">${internationalConfig.区域}：</span>&nbsp;
	<select id='area' onchange="changeLocation('boss_country',this.value)" style="width:100px;"> 
	   <c:forEach items="${dict.country}" var="item">
			<option value='${item.key}'>${item.value}</option>
		</c:forEach>
	</select> &nbsp; 
	</c:if>
	<span style="color:#f5f5f5;font-size:14px;">Language:&nbsp;</span>&nbsp;
	<select id='lanSel'  onchange="changeLocation('boss_lang',this.value)" style="width:100px;">
	    <option value='zh'>中文简体</option>
	     <option value='zh_hk'>中文繁体</option>
	    <option value='en'>English</option>
	</select>
	
	<a style="margin:0 5px;" href="javascript:void(0);" onclick='logoutFun(true);' class="easyui-linkbutton">${internationalConfig.注销}</a>
</div>
<!--<div id="layout_north_zxMenu" style="width: 100px; display: none;">
	<div onclick="logoutFun();">${internationalConfig.锁定窗口}</div>
	<div class="menu-sep"></div>
	<div onclick="logoutFun();">${internationalConfig.重新登录}</div>
	<div onclick="logoutFun(true);">${internationalConfig.退出系统}</div>
</div> -->
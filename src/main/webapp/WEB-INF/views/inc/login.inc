<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript" charset="utf-8">
	var loginDialog;
	var defaultUserInfoDialog;
	$(function() {
		$('#loginForm input').keyup(function(event) {
			if (event.keyCode == '13') {
				loginFun();
			}
		});

		loginDialog = $('#loginDialog').show().dialog({
			modal : true,
			closable : false,
			buttons : [ {
				text : '${internationalConfig.登录}',
				handler : function() {
					loginFun();
				}
			} ]
		});
		$('.window-mask').hide();

		defaultUserInfoDialog = $('#defaultUserInfoDialog').show().dialog({
			top : 0,
			left : 200
		});

		var sessionInfo_userId = '${sessionInfo.uid}';
		if (sessionInfo_userId) {/*目的是，如果已经登陆过了，那么刷新页面后也不需要弹出登录窗体*/
			loginDialog.dialog('close');
			defaultUserInfoDialog.dialog('close');
		}
	});
	function loginFun() {

			if ($('#loginForm').form('validate')) {
				parent.$.messager.progress({
					title : '${internationalConfig.提示}',
					text : '${internationalConfig.数据处理中}....'
				});
				$.post('${pageContext.request.contextPath}/login', $('#loginForm').serialize(), function(result) {
					console.log(result.code);
					if (result.code==0) {
						document.location.reload();
						/******
						if (!layout_west_tree_url) {
							layout_west_tree.tree({
								url : '${pageContext.request.contextPath}/resource/tree'
							});
						}
						layout_west_tree.tree('reload');//刷新系统菜单，这个菜单会根据用户ID，查找出他应该看到的菜单，没有权限就不会显示
						$('#loginDialog').dialog('close');
						$('#sessionInfoDiv').html($.formatString('[<strong>{0}</strong>]，欢迎你！您使用[<strong>{1}</strong>]IP登录！', result.obj.name, result.obj.ip));
						*****************/
					} else {
						changeImg();
						$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
						
					}
					parent.$.messager.progress('close');
				}, "json");
			}
		
	}
</script>
<script type="text/javascript"> 
    function changeImg() { 
        var imgSrc = $("#imgObj"); 
        var src = imgSrc.attr("src"); 
        imgSrc.attr("src", chgUrl(src)); 
    } 
    //时间戳     
    //为了使每次生成图片不一致，即不让浏览器读缓存，所以需要加上时间戳     
    function chgUrl(url) { 
        var timestamp = (new Date()).valueOf(); 
        if ((url.indexOf("?") >= 0)) { 
            url = url.substring(0, url.indexOf("?")); 
            url = url + "?timestamp=" + timestamp; 
        } else { 
            url = url + "?timestamp=" + timestamp; 
        } 
        return url; 
    } 
</script>
<div id="loginDialog" title="${internationalConfig.用户登录}" style="width: 450px; height: 260px; overflow: hidden; display: none;">
	<form id="loginForm" method="post">
		<table class="table table-hover table-condensed">
			<tr>
				<th>${internationalConfig.登录名}</th>
				<td><input name="name" type="text" placeholder="${internationalConfig.请输入登录名}" class="easyui-validatebox" data-options="required:true" value="" style="width:204px;"></td>
			</tr>
			<tr>
				<th>${internationalConfig.密码}</th>
				<td><input name="pwd" type="password" placeholder="${internationalConfig.请输入密码}" class="easyui-validatebox" data-options="required:true" value="" style="width:204px;"></td>
			</tr>
			<c:if test="${env=='cibn' }">
		  <input  type="hidden"    name="company"   value="lsw" />
			</c:if>
				<c:if test="${env!='cibn' }">
			<tr>
			<th>${internationalConfig.公司}</th>
			<td><select name="company">
<option value="">${internationalConfig.请选择}</option><option selected="selected" value="lsw">${internationalConfig.乐视网}</option><option value="lskg">${internationalConfig.乐视控股}</option><option value="lszx">${internationalConfig.乐视致新}</option><option value="lsyjs">${internationalConfig.乐视云计算}</option><option value="lstz">${internationalConfig.乐视投资}</option><option value="lsty">${internationalConfig.乐视体育}</option><option value="lsyy">${internationalConfig.乐视影业}</option><option value="wjw">${internationalConfig.网酒网}</option><option value="lsyd">${internationalConfig.乐视移动}</option><option value="ff">${internationalConfig.汽车}</option><option value="leplay">${internationalConfig.乐视游戏}</option><option value="letech">Le Technology Inc.</option><option value="other">${internationalConfig.其他公司}</option>                                            </select></td>
             
            </tr>
			</c:if>
			<tr>
			<td>${internationalConfig.验证码}</td>
			<td>
				<input id="index_code" name="code" type="text" style="margin-right:15px;"/>
				<img id="imgObj" alt="${internationalConfig.验证码}" src="${pageContext.request.contextPath}/code" /> 
                <a href="#" onclick="changeImg()">${internationalConfig.换一张}</a>
			</td> 
            </tr>
			
		</table>
	</form>
</div>
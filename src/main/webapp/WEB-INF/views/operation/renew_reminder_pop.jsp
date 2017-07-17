<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<title>XML<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.数据查找工具}</title>
<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
	});
	$(function() {
		getDataAndShow();
	});
	$(function() {
		$("#config").click(function() {
			config();
		});
	});
	
	
	
	function config() {
		if (check() == false) {
			return;
		}
		var status = null;
		if ($("#status").is(':checked')) {
			status = 1;
		} else {
			status = 0;
		}
			
		try {
			$.ajax({
						type : "POST",
						url : "${pageContext.request.contextPath}/renew_reminder_pop/add.json",
						cache : false,
						data : {
							"priceInfo.terminal" : $("#selectTerminal").val(),
							"priceInfo.status" : status,
							"priceInfo.price" : $("#price").val(),
							"position1.description" : $(
									"#position1\\.description").val(),
							"position1.url" : $("#position1\\.url").val(),
							"position1.picUrl" : $("#position1\\.picUrl").val(),
							"position1.name" : $("#position1\\.name").val(),
							"position1.position" : "POSITION_1",
							"position2.description" : $(
									"#position2\\.description").val(),
							"position2.url" : $("#position2\\.url").val(),
							"position2.picUrl" : $("#position2\\.picUrl").val(),
							"position2.name" : $("#position2\\.name").val(),
							"position2.position" : "POSITION_2"
						},
						dataType : "json",
						success : function(slj) {
							if (slj.code == 1) {
								alert("${internationalConfig.异常请重试}");
							} else {
							   alert("${internationalConfig.保存成功}");
							}
							 getDataAndShow();
						}
					});
			
		} catch (e) {
			getDataAndShow();
		}

	}

	function check() {
		return checkPrice() && checkPosition("position1")
				&& checkPosition("position2");
	}
	function checkPrice() {
		if ($("#status").is(':checked')) {
			var price = $("#price").val();
			if (isNullOrEmpty(price)) {
				alert("${internationalConfig.价格不能为空}");
				return false;
			} else if (!isNumeric(price)) {
				alert("${internationalConfig.价格必须为数字}");
				return false;
			}
		} else {
			var price = $("#price").val();
			if (!isNullOrEmpty(price) && !isNumeric(price)) {
				alert("${internationalConfig.价格必须为数字}");
				return false;
			}
		}
		return true;
	}

	function checkPosition(position) {
		if ("position1" == position) {
			var description = $("#" + position + "\\.description").val();
			if (isNullOrEmpty(description)) {
				alert("${internationalConfig.第一个位置的描述不能为空}");
				return false;
			}
		}
		var url = $("#" + position + "\\.url").val();
		if (isNullOrEmpty(url)) {
			alert("${internationalConfig.链接地址不能为空}");
			return false;
		}
		var picUrl = $("#" + position + "\\.picUrl").val();
		if (isNullOrEmpty(picUrl)) {
			alert("${internationalConfig.图片地址不能为空}");
			return false;
		}
		var name = $("#" + position + "\\.name").val();
		if (isNullOrEmpty(name)) {
			alert("${internationalConfig.片名不能为空}");
			return false;
		}
		return true;

	}
	function getDataAndShow() {
		try {
			var terminal =$("#selectTerminal").val();
			
			$.ajax({
						type : "get",
						url : "${pageContext.request.contextPath}/renew_reminder_pop/data_grid.json?terminal="+terminal,
						cache : false,
						dataType : "json",
						success : function(slj) {
							if (slj.code == 1) {
								alert("${internationalConfig.异常请重试}");
							} else {
								showAll(slj.data);
							}
						}
					});
		} catch (e) {
			alert(e);
		}

	}

	function showAll(obj) {
		if (obj == null) {
			return;
		}
		
		var price = obj.priceInfo;
		showPrice(price);
		var showInfo = obj.showInfo;
		if (showInfo == null) {
			return;
		}
		var x = null;
		for (x in showInfo) {
			showPosition(showInfo[x]);
		}
	}

	function showPrice(priceObj) {
		if (priceObj == null) {
			$("#status").prop('checked', false);
		} else if (priceObj.status == 1) {
			$("#status").prop('checked', true);
			$("#price").val(priceObj.price);
		} else {
			$("#status").prop('checked', false);
			$("#price").val(priceObj.price);
		}
	}

	function showPosition(position) {
		if (position == null) {
			return;
		}
		var prefix = "";
		if (position.position == "POSITION_1") {
			prefix = "position1";
		} else {
			prefix = "position2";
		}
		$("#" + prefix + "\\." + "description").val(position.description);
		$("#" + prefix + "\\." + "picUrl").val(position.picUrl);
		$("#" + prefix + "\\." + "url").val(position.url);
		$("#" + prefix + "\\." + "name").val(position.name);
	}
	function isNullOrEmpty(strVal) {

		if (strVal == '' || strVal == null || strVal == undefined) {

			return true;

		} else {

			return false;

		}

	}
	function isNumeric(a) {
		var reg = /^(\d)+(.(\d)+)?$/
		return (reg.test(a));
	}
</script>
<style type="text/css">
.set_wrap,.tanchuang01,.tanchuang02{
padding:20px;
overflow:hidden;
width:700px;
}
.set_wrap{
width:700px;
}
.set_wrap h4{
font-size: 16px;
line-height: 26px;
}
.set_div{
line-height: 30px;
font-size: 14px;
overflow: hidden;
}
.set_div .set_span{
float: left;padding-right: 10px;display: inline-block;margin:0;
}
.set_div .selec_p{
float:left;
width:160px;
display: inline-block;
} 
.set_div .status{
float:left;
vertical-align:middle;
display: block;
margin-left: 10px;
margin-top: 6px;
}
.jianmian_price{
line-height: 30px;
}
.jianmian_price input{
width:100px;
}
.change{ width:200px; height:21px; border:1px #999 solid; font-family:"Microsoft YaHei";}
.text_index{ text-indent:2em;}
.tab_title{ text-align:left; font-size:14px; font-weight:bold; margin:20px 0 10px;}
table{ color:#333; font-size:12px; width:695px;border:1px #999 solid;overflow: auto;}
tr th,tr td{ border-bottom:1px #999 solid; border-right:1px #999 solid;}
.tanchuang_con td{
padding-left: 20px;
height: 40px;
}
.tanchuang_con td span{
text-align: right;
display: inline-block;
width:60px;
}
.tanchuang_con td input{
width:225px;
}
.no_right{ border-right:none;}
.no_botm{ border-bottom:none;}
th,td{ height:40px;}
th{ text-align:center; background:#f3f3f3; color:#333; font-family:none; font-weight:normal;}
.zhuangtai{ width:63px; height:21px; border:1px #999 solid; font-family:"Microsoft YaHei";}
.texts{ font-family:"Microsoft YaHei"; color:#333; width:80px; height:20px; line-height:20px; list-style:none; margin:0; padding:0; border:none;}
.tanchu{ width:108px; height:21px; border:1px #999 solid; font-family:"Microsoft YaHei";}
.set_bc_btn{
height:30px;
text-align: center;
margin-top: 20px;
}
.set_bc_btn input{
width:80px;
height:30px;
}
</style>

</head>
<body>
<div class="set_wrap">
	<h4>${internationalConfig.价格减免设置}</h4>
	<div class="set_div">
		<span class="set_span">${internationalConfig.端启用价格减免设置}</span>
	    <select class="selec_p" name="selectTerminal" id="selectTerminal" onchange="getDataAndShow();">
	        <option value="141001">pc</option>
	        <option value="141003">${internationalConfig.移动}</option>
	    </select>
	    <input class="status" id="status" name="status" type="checkbox" value="1">
	</div> 
	<p class="jianmian_price"><span>${internationalConfig.设置减免价格}：</span><INPUT id="price" name="price" type=text value=""></p>
</div>
<div class="tanchuang01">
<table class="tanchuang_con">
	<caption class="tab_title">
	        ${internationalConfig.弹窗内容设置}：
	    </caption>
 	<tr>
	 	<th>
	    	<span>${internationalConfig.推荐位置}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>1</span>
	    </th>
	    <th>
	    	<span>${internationalConfig.推荐位置}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>2</span>
	    </th>
    </tr>
    <tr>
	 	<td>
			<span>${internationalConfig.分类描述}:</span>
		    <input id="position1.description" name="position1.description" type="text" value="">
    	</td>
	 	<td>
		 	<span>${internationalConfig.分类描述}:</span>
	    	<input id="position2.description" name="position2.description" value="" type="text">
    	</td>
    </tr>
    

    <tr>
	 	<td>
		    <span>${internationalConfig.片名}:</span>
		    <input id="position1.name" name="position1.name" value="" type="text">
		</td>
	 	<td>
		   <span>${internationalConfig.片名}:</span>
		   <input id="position2.name" name="position2.name" value="" type="text">
		</td>
    </tr>
	<tr>
	 	<td>
		    <span>${internationalConfig.图片地址}:</span>
		    <input id="position1.picUrl" name="position1.picUrl" value="" type="text">
		</td>
	 	<td>
		    <span>${internationalConfig.图片地址}:</span>
		    <input id="position2.picUrl" name="position2.picUrl" value="" type="text">
		 </td>
    </tr>
	 <tr>
	 	<td>
			<span>${internationalConfig.链接}:</span>
		    <input id="position1.url" name="position1.url" value="" type="text">
		</td>
	 	<td>
		    <span>${internationalConfig.链接}:</span>
		    <input id="position2.url" name="position2.url" value="" type="text">
		 </td>
    </tr> 
    
    </table>
    <p class="set_bc_btn"><input id="config" type="button" value="${internationalConfig.保存}"></p>
</div>

<div class="tanchuang02">
	<table>
	    <caption class="tab_title">
	        ${internationalConfig.定向弹窗用户类型}：
	    </caption>
	    <tr>
	        <th scope="col" width="183">${internationalConfig.类型}</th>
	        <th scope="col" width="100">${internationalConfig.状态}</th>
	        <th scope="col" width="100">${internationalConfig.分类描述}</th>
	        <th scope="col" width="100">${internationalConfig.图片地址}</th>
	        <th scope="col" width="100">${internationalConfig.链接}</th>
	        <th scope="col" width="112" class="no_right">${internationalConfig.弹出频次}</th>
	    </tr>
	    <tr>
	        <td align="left" width="183" class="text_index">${internationalConfig.全部用户}</td>
	        <td align="center" width="100"><select class="zhuangtai"><option>${internationalConfig.上线}</option><option>${internationalConfig.下线}</option></select></td>
	        <td align="center" width="100"><input class="texts" type="text" /></td>
	        <td align="center" width="100"><input class="texts" type="text" /></td>
	        <td align="center" width="100"><input class="texts" type="text" /></td>
	        <td align="center" width="112" class="no_right"><select class="tanchu"><option>${internationalConfig.每天弹一次}</option><option>${internationalConfig.每周弹三次}</option><option>${internationalConfig.每次登陆弹出}</option></select></td>
	    </tr>
	    <tr>
	        <td align="left" width="183" class="text_index">10<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.天}&gt;=${internationalConfig.到期时间}&gt;0<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.天}</td>
	        <td align="center" width="100"><select class="zhuangtai"><option>${internationalConfig.上线}</option><option>${internationalConfig.下线}</option></select></td>
	        <td align="center" width="100"><input class="texts" type="text" /></td>
	        <td align="center" width="100"><input class="texts" type="text" /></td>
	        <td align="center" width="100"><input class="texts" type="text" /></td>
	        <td align="center" width="112" class="no_right"><select class="tanchu"><option>${internationalConfig.每天弹一次}</option><option>${internationalConfig.每周弹三次}</option><option>${internationalConfig.每次登陆弹出}</option></select></td>
	    </tr>
	    <tr>
	        <td align="left" width="183" class="text_index">1<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.月}&gt;=${internationalConfig.到期时间}&gt;10<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.天}</td>
	        <td align="center" width="100"><select class="zhuangtai"><option>${internationalConfig.上线}</option><option>${internationalConfig.下线}</option></select></td>
	        <td align="center" width="100"><input class="texts" type="text" /></td>
	        <td align="center" width="100"><input class="texts" type="text" /></td>
	        <td align="center" width="100"><input class="texts" type="text" /></td>
	        <td align="center" width="112" class="no_right"><select class="tanchu"><option>${internationalConfig.每天弹一次}</option><option>${internationalConfig.每周弹三次}</option><option>${internationalConfig.每次登陆弹出}</option></select></td>
	    </tr>
	    <tr>
	        <td align="left" width="183" class="text_index">2<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.月}&gt;=${internationalConfig.到期时间}&gt;1<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.月}</td>
	        <td align="center" width="100"><select class="zhuangtai"><option>${internationalConfig.上线}</option><option>${internationalConfig.下线}</option></select></td>
	        <td align="center" width="100"><input class="texts" type="text" /></td>
	        <td align="center" width="100"><input class="texts" type="text" /></td>
	        <td align="center" width="100"><input class="texts" type="text" /></td>
	        <td align="center" width="112" class="no_right"><select class="tanchu"><option>${internationalConfig.每天弹一次}</option><option>${internationalConfig.每周弹三次}</option><option>${internationalConfig.每次登陆弹出}</option></select></td>
	    </tr>
	    <tr>
	        <td align="left" width="183" class="text_index">2<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.月}&gt;=${internationalConfig.到期时间}&gt;2<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.月}</td>
	        <td align="center" width="100"><select class="zhuangtai"><option>${internationalConfig.上线}</option><option>${internationalConfig.下线}</option></select></td>
	        <td align="center" width="100"><input class="texts" type="text" /></td>
	        <td align="center" width="100"><input class="texts" type="text" /></td>
	        <td align="center" width="100"><input class="texts" type="text" /></td>
	        <td align="center" width="112" class="no_right"><select class="tanchu"><option>${internationalConfig.每天弹一次}</option><option>${internationalConfig.每周弹三次}</option><option>${internationalConfig.每次登陆弹出}</option></select></td>
	    </tr>
	    <tr>
	        <td align="left" width="183" class="text_index">${internationalConfig.过期会员用户}</td>
	        <td align="center" width="100"><select class="zhuangtai"><option>${internationalConfig.上线}</option><option>${internationalConfig.下线}</option></select></td>
	        <td align="center" width="100"><input class="texts" type="text" /></td>
	        <td align="center" width="100"><input class="texts" type="text" /></td>
	        <td align="center" width="100"><input class="texts" type="text" /></td>
	        <td align="center" width="112" class="no_right"><select class="tanchu"><option>${internationalConfig.每天弹一次}</option><option>${internationalConfig.每周弹三次}</option><option>${internationalConfig.每次登陆弹出}</option></select></td>
	    </tr>
	    <tr>
	        <td align="left" width="183"class="text_index">${internationalConfig.过期}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>1<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.个月的用户}</td>
	        <td align="center" width="100"><select class="zhuangtai"><option>${internationalConfig.上线}</option><option>${internationalConfig.下线}</option></select></td>
	        <td align="center" width="100"><input class="texts" type="text" /></td>
	        <td align="center" width="100"><input class="texts" type="text" /></td>
	        <td align="center" width="100"><input class="texts" type="text" /></td>
	        <td align="center" width="112" class="no_right"><select class="tanchu"><option>${internationalConfig.每天弹一次}</option><option>${internationalConfig.每周弹三次}</option><option>${internationalConfig.每次登陆弹出}</option></select></td>
	    </tr>
	    <tr>
	        <td align="left" width="183"class="text_index">${internationalConfig.过期}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>3<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.个月的用户}</td>
	        <td align="center" width="100"><select class="zhuangtai"><option>${internationalConfig.上线}</option><option>${internationalConfig.下线}</option></select></td>
	        <td align="center" width="100"><input class="texts" type="text" /></td>
	        <td align="center" width="100"><input class="texts" type="text" /></td>
	        <td align="center" width="100"><input class="texts" type="text" /></td>
	        <td align="center" width="112" class="no_right"><select class="tanchu"><option>${internationalConfig.每天弹一次}</option><option>${internationalConfig.每周弹三次}</option><option>${internationalConfig.每次登陆弹出}</option></select></td>
	    </tr>
	    <tr>
	        <td align="left" class="no_botm text_index" width="183">${internationalConfig.一直非会员用户}</td>
	        <td align="center" width="100" class="no_botm"><select class="zhuangtai"><option>${internationalConfig.上线}</option><option>${internationalConfig.下线}</option></select></td>
	        <td align="center" width="100" class="no_botm"><input class="texts" type="text" /></td>
	        <td align="center" width="100" class="no_botm"><input class="texts" type="text" /></td>
	        <td align="center" width="100" class="no_botm"><input class="texts" type="text" /></td>
	        <td align="center" width="112" class="no_right no_botm"><select class="tanchu"><option>${internationalConfig.每天弹一次}</option><option>${internationalConfig.每周弹三次}</option><option>${internationalConfig.每次登陆弹出}</option></select></td>
	    </tr>
	</table>
	<p class="set_bc_btn"><input id="config" type="button" value="${internationalConfig.保存}"></p>
</div>

</body>
</html>
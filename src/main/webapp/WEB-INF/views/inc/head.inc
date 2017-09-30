<%@ page  pageEncoding="UTF-8"%>
<%@include file="jstl.inc" %>
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<c:if test="$fn:containsIgnoreCase(env, 'cibn') ">
<link rel="Shortcut Icon" href=" http://www.letv.com/favicon.ico"/>
</c:if>



<!-- 引入kindEditor插件 -->
<link rel="stylesheet" href="/static/lib/kindeditor-4.1.7/themes/default/default.css">
<!-- 引入bootstrap样式 -->
<link href="/static/lib/bootstrap-2.3.1/css/bootstrap.min.css" rel="stylesheet" media="screen">
<link id="easyuiTheme" rel="stylesheet" href="/static/lib/jquery-easyui-1.4.1/themes/bootstrap/easyui.css" type="text/css">
<!-- <link rel="stylesheet" href="/static/lib/jquery-easyui-1.4.1/themes/icon.css" type="text/css"> -->

<!-- 引入my97日期时间控件 -->
<script type="text/javascript" src="/static/lib/My97DatePicker4.8b3/My97DatePicker/WdatePicker.js?v=${ver}" charset="utf-8"></script>
<script type="text/javascript" src="/static/lib/kindeditor-4.1.7/kindeditor-all-min.js" charset="utf-8"></script>
<!-- 引入jQuery -->
<script src="/static/lib/jquery.min.js" type="text/javascript" charset="utf-8"></script>
<script src="/static/lib/jquery.cookie.js" type="text/javascript" charset="utf-8"></script>
<script src="/static/lib/keepme.js" type="text/javascript" charset="utf-8"></script>

<!-- <script charset="utf-8" src="/static/lib/bootstrap-2.3.1/js/bootstrap.min.js" charset="utf-8"></script> -->

<!-- 引入EasyUI -->
<script type="text/javascript" src="/static/lib/jquery-easyui-1.4.1/jquery.easyui.min.js?v=${ver}" charset="utf-8"></script>

<script type="text/javascript" src="/static/lib/jquery-easyui-1.4.1/locale/easyui-lang-zh_CN.js?v=${ver}" charset="utf-8"></script>
<!-- 修复EasyUI1.3.3中layout组件的BUG 
<script type="text/javascript" src="/static/lib/jquery-easyui-1.4.1/plugins/jquery.layout.js" charset="utf-8"></script>-->
<script>
Date.prototype.format = function(format) {
	if (!format) {
		format = "yyyy-MM-dd hh:mm:ss";
	}
	var o = {
		"M+" : this.getMonth() + 1, // month
		"d+" : this.getDate(), // day
		"h+" : this.getHours(), // hour
		"m+" : this.getMinutes(), // minute
		"s+" : this.getSeconds(), // second
		"q+" : Math.floor((this.getMonth() + 3) / 3), // quarter
		"S" : this.getMilliseconds()
	// millisecond
	};
	if (/(y+)/.test(format)) {
		format = format.replace(RegExp.$1, (this.getFullYear() + "")
				.substr(4 - RegExp.$1.length));
	}
	for ( var k in o) {
		if (new RegExp("(" + k + ")").test(format)) {
			format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k]
					: ("00" + o[k]).substr(("" + o[k]).length));
		}
	}
	return format;
};
</script>
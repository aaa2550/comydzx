<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>${internationalConfig.取消一键支付}</title>
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
    <script type="text/javascript">
    
        $(function (){
        	parent.$.messager.progress('close');
        });
        
        function unBindFun(){
        	var userId = $("#userId").val();
        	if(userId == ''){
        		alert("${internationalConfig.请输入用户}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID");
        		return;
        	}
        	parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.您是否要为该用户取消一键支付}?', function (b) {
    	        if (b) {
    	            parent.$.messager.progress({
    	                title: '${internationalConfig.提示}',
    	                text: '${internationalConfig.数据处理中}....'
    	            });
    	            
    		$.post('/onekeypay_unbind/unbind.json', {
    			userId : userId
    		}, function(obj) {
    			var msg = decodeURIComponent(obj.msg) ;
    			parent.$.messager.progress('close');
    			parent.$.messager.alert('${internationalConfig.提示}','<div class="dialog-tip">' + msg + '</div>','info');
    		}, 'JSON');
    	        }
    	    });
        	
        }

    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'${internationalConfig.解除条件}',border:false"
         style="height: 80px; overflow: auto;">
        <form id="searchForm">
            <table class="table-td-two"
                   style="display: block;">
                <tr>
                    <th></th>
                    <td>${internationalConfig.用户}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID：<input id="userId" name="userId" class="span2" style="height:24px">&nbsp;&nbsp;
                    </td>
                    <td> <input type="button" id="userId" class="boss-btn" name="userId" onclick="unBindFun();" value="${internationalConfig.取消一键支付}"></td>
                </tr>
            </table>
        </form>
    </div>
</div>


</body>
</html>
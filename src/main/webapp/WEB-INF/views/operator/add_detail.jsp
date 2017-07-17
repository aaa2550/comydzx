<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
 <form method="post"   id="form"  action="/operator/add_detail"  onsubmit="return false">
 <div class="dzd_closing_rule">
    <div class="yys_closing_one">
        <ul class="yys_closing_list">
            <li>
                <span class="jsgz_left_span">
                    <b>运营商：</b>
                                  <input id="inputSearch2" class="span2 input-box" autocomplete="off"  >
                     <input   id="oid2"  class="span2" type="hidden" name="oid"  value="${operatorAccount.oid}">
                </span>
                <span class="jsgz_left_span">
                    <b>合同日期：</b>
                    <select  id="contract">
                        <option>请选择</option> 
                    </select>
                </span>
            </li>
        
        </ul>
    </div>
</div>
</form>
<script type="text/javascript">

$(function () {
    parent.$.messager.progress('close');
    
    
	var co2 = new Boss.util.combo({
		  url:"/search_name?type=operatorName",
		  inputSelector:'#inputSearch2'  
		});
	
	$(co2).bind('select',function(eventName,el){
		var oid=el.attr('data-id');
          $('#oid2').val(oid);
          console.log(oid);

          $.get("/operator/contract",{oid:oid},function(data){
        		 var h=new Array();
        		 for(var i=0;i<data.length;i++){
        			 h.push("<option value="+data[i].id+">"+data[i].range+"</option>");
        		 }
        		 $("#contract").html(h.join(""));
        	  },"json");
          
	});

 $(".ssj-select").change(function(){
	 var operator =$("#add_operator").val();
	 var province= $("#add_province").val();
	 if(operator=='0' || province=='0' ){
		 return ;
	 }
  $.get("/operator/contract",{province:province,operator:operator},function(data){
	 var h=new Array();
	 for(var i=0;i<data.length;i++){
		 h.push("<option value="+data[i].id+">"+data[i].range+"</option>");
	 }
	 $("#contract").html(h.join(""));
  },"json");
 }); 
    
});



</script>

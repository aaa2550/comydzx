<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title=""
		style="overflow: hidden;">
		<form id="form" method="post"
			action="/lecard/create.json"   onsubmit="return false;">
			<table style="margin-left: 30px; margin-top: 20px">
				<tr>
					<th>${internationalConfig.申请人姓名}</th>
					<td><label> <input type="text" name="applicant"
							style="width: 150px" class="easyui-validatebox"
							data-options="required:true" />
					</label></td>
				</tr>
				<tr>
					<th>${internationalConfig.申请部门}</th>
					<td><label> <select name="department"
							style="width: 165px">
							  <c:forEach items="${dict.department}" var="department">
                            <option value="${department.key}">${department.value}</option>
                        </c:forEach>
						</select>
					</label></td>
				</tr>
				<tr>
					<th>${internationalConfig.合作公司}</th>
					<td><label> <select name="channelAssociationId" style="width: 165px">
						<option value="0">${internationalConfig.未知}</option>
						<c:forEach items="${channelAssociations}" var="channelAssociation">
							<option value="${channelAssociation.id}">${channelAssociation.channelName}</option>
						</c:forEach>
					</select>
					</label></td>
				</tr>
				<tr>
					<th>${internationalConfig.申请用途}</th>
					<td><label>
					<select style="width: 165px" name="applyReason">
                                        <option value="1">${internationalConfig.赠送}</option>
                                        <option value="3">${internationalConfig.销售}</option>
                                        <option value="4">${internationalConfig.生产}</option>
						</select>
					</label></td>

				</tr>
				<tr>
					<th>${internationalConfig.用途描述}</th>
					<td><label> <input type="text" name="applyReasonDesc"
							style="width: 180px" class="easyui-validatebox"
							data-options="required:true" />
					</label></td>
				</tr>
				<tr>
					<th>${internationalConfig.乐卡类型}</th>
                            <td >
                                <label>
                                     <input type="radio" value="30" name="applyType"  checked="checked">${internationalConfig.影视剧兑换码}
                                </label>
                            </td>
                            <td >
                                <label>
                                     <input type="radio" value="40" name="applyType">${internationalConfig.组合套餐兑换码}
                                </label>
                            </td>
				</tr>
		
				<tr >
					<th>${internationalConfig.套餐名称}</th>
					<td>
					<input type="hidden"  name="applyPackage">
					<label id="inputSpan"><input id="inputSearch"   type="text" >（${internationalConfig.通用兑换码此栏不填}）</label>
					<label id="inputSpan2"  style="display:none"><input id="inputSearch2"   type="text" ></label>
					</td>
				</tr>
						<tr class="sqme"  style="display:none">
					<th>${internationalConfig.申请面额}</th>
					<td><label> <input type="text" name="amount" value="0"/>
					</label></td>
				</tr>
					<tr class="sqme"  style="display:none">
					<th>${internationalConfig.实际价格}</th>
					<td><label> <input type="text" name="price" value="0" />
					</label></td>
				</tr>
				<tr>
					<th>${internationalConfig.申请数量}</th>
					<td><label> <input type="text" name="cardCount"
							style="width: 150px" class="easyui-numberbox"
							data-options="min:1,max:100000,precision:0,required:true">
					</label></td>
				</tr>
			
                <tr>
                    <th>${internationalConfig.失效日期}</th>
                    <td>
                        <label>
                            <input type="text" name="expireDate" id="expireDate" style="width: 165px"
                                   class="easyui-datebox" class="easyui-validatebox" data-options="required:true,editable:false"/>
                            <!-- validType="gtStartDate['#expireDate']" invalidMessage="结束时间必须大于开始时间或者日期不是yyyy-MM-dd格式" -->
                        </label>
                    </td>
                </tr>
                <tr>
                    <th>${internationalConfig.发行类型}</th>
                    <td>
                        <label>
                            <select name="releaseType" style="width: 165px">
                                <option value="1">${internationalConfig.电子码}</option>
								<option value="2">${internationalConfig.实体卡}</option>
                            </select>
                        </label>
                    </td>
                </tr>
                <tr>
					<th>${internationalConfig.用户使用次数}</th>
						<td><label> <input type="text" name="maxUseTime"
							style="width: 150px" class="easyui-numberbox"
							data-options="min:0,max:100000,precision:0,required:true"   value="0">
					</label> </td>
					<td>0&nbsp;${internationalConfig.为不限制}</td>
				</tr>
			
            </table>
        </form>
    </div>
</div>
<script type="text/javascript">
    $.extend($.fn.datebox.defaults.rules, {
        gtStartDate: {
            validator: function (value, param) {//
                if (param[0] && value) {
                    if (value.length > 10) {
                        value = value.substring(0, 10);
                    }
                    var ed_arr = value.split('-');
                    var endDate = new Date(ed_arr[0], ed_arr[1] - 1, ed_arr[2]);
                    var sDate = $(param[0]).datebox('getValue');
                    if (sDate) {
                        if (sDate.length > 10) {
                            sDate = sDate.substring(0, 10);
                        }
                        var sd_arr = sDate.split('-');
                        var startDate = new Date(sd_arr[0], sd_arr[1] - 1, sd_arr[2]).getTime();
                        if ((endDate.getTime() - startDate) > 0) {
                            return true;
                        }
                    }
                }
                return false;
            },
            message: "${internationalConfig.结束时间必须大于开始时间或者日期}"
        }
    });


    //增加自定义的表单验证规则
    $.extend($.fn.validatebox.defaults.rules, {
        number: {
            validator: function (value, param) {
                var reg = new RegExp("^[0-9]+(.[0-9]+)?$");
                return reg.test(value);
            },
            message: '${internationalConfig.请输入合法数字}'
        }
    });
    $.extend($.fn.validatebox.defaults.rules, {
        int: {
            validator: function (value, param) {
                var reg = new RegExp("^[0-9]+$");
                return reg.test(value);
            },
            message: '${internationalConfig.请输入合法整数}'
        }
    });
    $.extend($.fn.validatebox.defaults.rules, {
        amount: {
            validator: function (value, param) {
                var reg = new RegExp("^-?[0-9]+(.[0-9]+)?$");
                return reg.test(value);
            },
            message: '${internationalConfig.请输入合法金额}'
        }
    });

    
    $(function () {
        parent.$.messager.progress('close');
        $('#form').form({
            url: '/lecard/create.json',
            onSubmit: function () {
                parent.$.messager.progress({
                    title: '${internationalConfig.提示}',
                    text: '${internationalConfig.数据处理中}'
                });



                var isValid = $(this).form('validate');
                if (!isValid) {
                    parent.$.messager.progress('close');
                }
                //  影视剧兑换码，当没有填的时候，为通用兑换，设置 applyPackage 为0
              var s=  $("input[name=applyType]:checked").val();
              if(s==30){        
            	  if($("#inputSearch").val()==''){
            		  $("input[name=applyPackage]").val('0');
            	  }
              }
                return isValid;
            },
            success: function (obj) {
                parent.$.messager.progress('close');
                var result = $.parseJSON(obj);
                if (result.code==0) {
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
                    parent.$.modalDialog.handler.dialog('close');
                    var batch = result.msg;
                } else {
                    parent.$.messager.alert('${internationalConfig.页面错误}', result.msg, 'error');
                }
            }
        });
        
        //注册按照卡类型进行页面控制的回调方法。
        $('input:radio[name=applyType]').click(function () {
            var value = $(this).val();
            //激活码
            var dhtc = $("#inputSpan2");
            var sqme = $("#inputSpan");
            if (value == 30) {
            	dhtc.hide();
            	sqme.show() ;
           }
           //兑换码
           if (value == 40) {
        	dhtc.show();
           	sqme.hide();
           }
       });
        
        var co = new Boss.util.combo({
    	    url:'/search_name',//请求url
    	    inputSelector:'#inputSearch' ,     //搜索框id
    
    	    cbParams:{  //用于自定义一些后台返回的值  每一个键值对中的值和后台的返回字段相同 ,键的命名开发者可以自定义（有意义最好）
    	        id:'movieId',//id默认名字  required
    	        text:'movieName' //文本默认名字 required
    	      },
    	      sName:'appName',//输入的参数名字
    	      otherReqParams: {//请求的其他参数，默认只有count  可以增加其他参数
    	       type:"movie",
    	       count:100
    	      }
    	});
    	
    	$(co).bind('select',function(eventName,el){
    		var movieIdValue = el.attr('data-movieId');
    		$("input[name=applyPackage]").val(movieIdValue);
    	});
        
    	
        var co2 = new Boss.util.combo({
    	    url:'/search_name',//请求url
    	    inputSelector:'#inputSearch2' ,     //搜索框id
    	    cbParams:{  //用于自定义一些后台返回的值  每一个键值对中的值和后台的返回字段相同 ,键的命名开发者可以自定义（有意义最好）
    	    	price:"price"
    	      },
    	      otherReqParams: {//请求的其他参数，默认只有count  可以增加其他参数
    	       type:"combine",
    	       count:100
    	      }
    	});
    	
    	$(co2).bind('select',function(eventName,el){
    		var movieIdValue = el.attr('data-id');
    		$("input[name=applyPackage]").val(movieIdValue);
    		$("input[name=amount]").val(el.attr("data-price"));
    	});
        
    });





</script>
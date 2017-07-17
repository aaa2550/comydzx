<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:if test="${not empty param.singlePage}">
	<%@ include file="/WEB-INF/views/inc/head.inc"%>
</c:if>
<style type="text/css">
#form table tr td{
	padding:2px 0;
}

</style>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post"
			action="/lecard/create.json">
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
					<td>
						<%--<label>
							<select name="channelAssociationId" style="width: 165px">
							<option value="0">${internationalConfig.未知}</option>
							<c:forEach items="${channelAssociations}" var="channelAssociation">
								<option value="${channelAssociation.id}">${channelAssociation.channelName}</option>
							</c:forEach>
							</select>
						</label>--%>
							<span class="serchDiv">
								<input class="serchSelect easyui-validatebox" data-options="required:true" placeholder="${internationalConfig.请选择公司}" value=""/>
								<input class="serchSelectId" name="channelAssociationId" type="hidden"/>
								<ul class="hideul"></ul>
							</span>
					</td>
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
                    <td>
                        <%--<label style="display:inline-block;margin-right:10px;">--%>
                             <%--<input type="radio" checked="checked" value="1" name="applyType">${internationalConfig.充值码}--%>
                        <%--</label>--%>
                        <label style="display:inline-block;margin-right:10px;">
                             <input type="radio" checked="checked" value="5" name="applyType">${internationalConfig.会员兑换码}&nbsp;2.0
                        </label>
                        <label style="display:inline-block;margin-right:10px;">
                            <input type="radio" value="6" name="applyType">${internationalConfig.机卡兑换码}&nbsp;2.0
                        </label>
                    </td>
                            
				</tr>
				<tr class="jkdh" style="display: none;">
					<th>${internationalConfig.设备类型}</th>
					<td>
						<select name="deviceType" class="easyui-validatebox" data-options="validType:'deviceType'">
							<option value="0">${internationalConfig.请选择}</option>
							<option value="1">${internationalConfig.电视}</option>
							<option value="2">${internationalConfig.乐视手机}</option>
							<option value="3">${internationalConfig.盒子}</option>
							<option value="4">${internationalConfig.路由器}</option>
							<option value="5">${internationalConfig.酷派手机}</option>
						</select>
					</td>
				</tr>
				<tr class="dhtc" >
					<th>${internationalConfig.兑换套餐}</th>
					<td><label> <select name="applyPackage"
							style="width: 165px;" id="applyPackage">
								<c:forEach items="${applyPackageList}" var="applyPackage">
			<option	 value="${applyPackage.key}">${applyPackage.value}</option>
								</c:forEach>
						</select>
					</label></td>
				</tr>
				<tr class="dhtc" >
					<th>${internationalConfig.状态}</th>
					<td>
					<select name="flag"  >
					<option value="1">${internationalConfig.正常}</option>
					<option value="4">${internationalConfig.冻结}</option>
					</select>
					</td>
				</tr>
				<tr style="display: none;">
					<th>${internationalConfig.首次赠送观影券张数}</th>
					<td><input type="text" name="couponCount"
						class="easyui-validatebox"
						data-options="required:true,validType:'int'" value="0" /></td>
				</tr>
				<tr style="display: none;">
					<th>${internationalConfig.观影券有效期}</th>
					<td><input type="text" name="couponDays" class="easyui-validatebox"
						data-options="required:true,validType:'int'" value="0" /></td>
				</tr>
                <tr>
                    <th>${internationalConfig.申请面额}</th>
                    <td><label> <input type="text" name="amount" value="0"
                                       id="amount" style="width: 150px" class="easyui-numberbox"
                                       data-options="min:0,max:10000,precision:2,required:true" />(${internationalConfig.可根据实际情况自行调整})
                    </label></td>
                </tr>
                <tr>
                    <th>${internationalConfig.结算金额}</th>
                    <td><label> <input type="text" name="price" value="0"
                                       id="price" style="width: 150px" class="easyui-numberbox"
                                       data-options="min:0,max:10000,precision:2,required:true" />
                    </label></td>
                </tr>
				<tr>
					<th>${internationalConfig.申请数量}</th>
					<td><label> <input type="text" name="cardCount"
							style="width: 150px" class="easyui-numberbox"
							data-options="min:1,max:1000000,precision:0,required:true">
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
							data-options="min:0,max:100000,precision:0,required:true"   value="0">&nbsp;0${internationalConfig.为不限制}
					</label> </td>
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
	$(function () {
		parent.$.messager.progress('close');
		//合作公司模糊搜索
		$("body").click(function(){
			$(".serchDiv ul").addClass("hideul");
		});
		$(".serchSelect").click(function(event){
			event.stopPropagation();
		})
		$.ajax({
			url : "/channelAssociation/dataGrid",
			dataType:'json',
			success : function(res){
				res = res.rows;
				var html = '<li value="0">${internationalConfig.未知}</li>';
				for(var i in res){
					html+='<li value="'+res[i].id+'">'+res[i].channelName+'</li>';
				}
				$(".serchDiv ul").html(html);
				$(".serchDiv ul li").unbind("click").click(function(event){
					event.stopPropagation();
					$(".serchSelect").val($(this).html());
					$(".serchDiv ul").addClass("hideul");
					$(".serchSelectId").val($(this).val());
				});

				$(".serchSelect").focus(function(){
					$(".serchDiv ul").removeClass("hideul");
					var shtml = '<li value="0">${internationalConfig.未知}</li>';
					for(var i in res){
						shtml+='<li value="'+res[i].id+'">'+res[i].channelName+'</li>';
					}
					$(".serchDiv ul").html(shtml);
					$(".serchDiv ul li").unbind("click").click(function(event){
						event.stopPropagation();
						$(".serchSelect").val($(this).html());
						$(".serchDiv ul").addClass("hideul");
						$(".serchSelectId").val($(this).val());
					});
					if ((navigator.userAgent.indexOf('MSIE') >= 0)&& (navigator.userAgent.indexOf('Opera') < 0)){	//兼容
						$(this).on('propertychange',function(){
							var value = $(this).val();
							shtml = '';
							for(var i in res){
								if(res[i].channelName.indexOf(value)>=0){
									shtml+='<li value="'+res[i].id+'">'+res[i].channelName+'</li>';
								}
							}
							$(".serchDiv ul").html(shtml);
							$(".serchDiv ul li").unbind("click").click(function(event){
								event.stopPropagation();
								$(".serchSelect").val($(this).html());
								$(".serchDiv ul").addClass("hideul");
								$(".serchSelectId").val($(this).val());
							});
						});
					}else{
						$(this).on('input',function(){
							var value = $(this).val();
							shtml = '';
							for(var i in res){
								if(res[i].channelName.indexOf(value)>=0){
									shtml+='<li value="'+res[i].id+'">'+res[i].channelName+'</li>';
								}
							}
							$(".serchDiv ul").html(shtml);
							$(".serchDiv ul li").unbind("click").click(function(event){
								event.stopPropagation();
								$(".serchSelect").val($(this).html());
								$(".serchDiv ul").addClass("hideul");
								$(".serchSelectId").val($(this).val());
							});
						});
					}

				});
			},
			error:function(){
			}
		});


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
	$.extend($.fn.validatebox.defaults.rules, {
		discount: {
			validator: function (value, param) {
				var reg = new RegExp("^[0-1]+(.[0-9]+)?$");
				return reg.test(value);
			},
			message: '${internationalConfig.请输入合法折扣}'
		}
	});
	$.extend($.fn.validatebox.defaults.rules, {
		deviceType: {
			validator: function (value) {
				var jkdh = $(".jkdh");
				if(jkdh.css("display")==='none'){
					return true;
				}
				return value != '0';
			},
			message: '${internationalConfig.请选择}'
		}
	});


	//注册按照卡类型进行页面控制的回调方法。
	$('input:radio[name=applyType]').click(function () {
		var value = $(this).val();
		//激活码
		var dhtc = $(".dhtc");
		var sqme = $(".sqme");
		var jkdh = $(".jkdh");
		if (value == 1) {
			dhtc.hide();
			sqme.show();
		}else{ // 兑换码
			dhtc.show();
			sqme.hide();
		}

		if(value == 6){
			sqme.show();
			jkdh.show();
		}else {
			sqme.show();
			jkdh.hide();
		}
	});

    //套餐联动
    $(function(){
        $("#applyPackage").change(function(){
            var applyPackageIds = $("#applyPackage").val();
            $.ajax({
                url : "/v2/product/vipPackage/get_vip_package_info",
                data : {
                    'applyPackageIds' : applyPackageIds
                },
                success : function(result) {
                    $("#amount").numberbox('setValue',parseFloat(result.price));
                },
                error : function(){
                    $("#amount").numberbox('setValue',0);
                    return false;
                },
                dataType : "json",
                cache : false
            });
        });

		var applyPackageIds = $("#applyPackage").val();
		$.ajax({
			url : "/v2/product/vipPackage/get_vip_package_info",
			data : {
				'applyPackageIds' : applyPackageIds
			},
			success : function(result) {
				$("#amount").numberbox('setValue',parseFloat(result.price));
			},
			error : function(){
				$("#amount").numberbox('setValue',0);
				return false;
			},
			dataType : "json",
			cache : false
		});
    });

</script>
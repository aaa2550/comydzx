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
					<th><b style="color: red">*</b>${internationalConfig.申请人姓名}</th>
					<td><label> <input type="text" name="applicant"
							style="width: 150px" class="easyui-validatebox"
							data-options="required:true" />
					</label></td>
				</tr>
				<tr>
					<th><b style="color: red">*</b>${internationalConfig.申请部门}</th>
					<td><label> <select name="department"
							style="width: 165px">
							  <c:forEach items="${dict.department}" var="department">
                            <option value="${department.key}">${department.value}</option>
                        </c:forEach>
						</select>
					</label></td>
				</tr>

				<tr>
					<th><b style="color: red">*</b>${internationalConfig.申请用途}</th>
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
							style="width: 180px" class="easyui-validatebox"/>
					</label></td>
				</tr>
				<tr  style="display: none">
					<th><b style="color: red">*</b>${internationalConfig.乐卡类型}</th>
                    <td>
                        <label style="display:inline-block;margin-right:10px;">
                            <input type="radio" value="50" name="applyType"  checked="checked" >${internationalConfig.大屏商品兑换码}&nbsp;
                        </label>
                    </td>
                            
				</tr>
				<tr class="dhtc" >
					<th><b style="color: red">*</b>${internationalConfig.商品编码}</th>
					<td><label> <input name="applyPackage"
										style="width: 165px;" id="applyPackage"  />
					<a id="applyPackage-code"  href="javascript:;">检索</a></label>

					<font id="applyPackage-msg"  style="display: none" color="red">商品编码查询不存在</font>
					</td>
				</tr>
				<tr class="sqme" >
					<th><b style="color: red">*</b>${internationalConfig.申请面额}</th>
					<td><label> <input type="text" name="amount" value="0" readonly/>
					</label></td>

				<tr class="jkdh" >
					<th><b style="color: red">*</b>${internationalConfig.商品名称}</th>
					<td><input name="applyPackageDesc" value=""  readonly/>

					</td>
				</tr>

				<tr class="dhtc" >
					<th><b style="color: red">*</b>${internationalConfig.状态}</th>
					<td>
					<select name="flag"  >
					<option value="1">${internationalConfig.正常}</option>
					<option value="4">${internationalConfig.冻结}</option>
					</select>
					</td>
				</tr>

				<tr>
					<th><b style="color: red">*</b>${internationalConfig.申请数量}</th>
					<td><label> <input type="text" name="cardCount"
							style="width: 150px" class="easyui-numberbox"
							data-options="min:1,max:1000000,precision:0,required:true">
					</label></td>
				</tr>
			
                <tr>
                    <th><b style="color: red">*</b>${internationalConfig.失效日期}</th>
                    <td>
                        <label>
                            <input type="text" name="expireDate" id="expireDate" style="width: 165px"
                                   class="easyui-datebox" class="easyui-validatebox" data-options="required:true,editable:false"/>
                            <!-- validType="gtStartDate['#expireDate']" invalidMessage="结束时间必须大于开始时间或者日期不是yyyy-MM-dd格式" -->
                        </label>
                    </td>
                </tr>
                <tr>
                    <th><b style="color: red">*</b>${internationalConfig.发行类型}</th>
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
					<th><b style="color: red">*</b>${internationalConfig.用户使用次数}</th>
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
	$("#applyPackage-code").click(function () {
		var code=$("#applyPackage").val();
		$.get("/mini/sku/getByCode?code="+code,function (codeMsg) {
			if(codeMsg.data){
			    var data=codeMsg.data;
                $("#applyPackage-msg").hide();
				$("input[name=applyPackageDesc]").val(data.name);
				$("input[name=amount]").val(data.price);

			}else{
			    $("#applyPackage-msg").show();
			}
        },"json");
    });


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





</script>
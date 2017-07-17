<%--
  Created by IntelliJ IDEA.
  User: kangxiongwei3
  Date: 2016/9/27
  Time: 16:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');
        $('#fb').filebox({
            buttonText: '请选择',
            buttonAlign: 'left'
        });
        $('#form').form({
            url: '${pageContext.request.contextPath}/tj/payinfo/orderform/batch_export',
            onSubmit: function () {
                var isValid = $(this).form('validate');
                if (!isValid) {
                    parent.$.messager.progress('close');
                }
                return isValid;
            }
        });
    });

</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:true" title="" style="overflow: hidden;">
        <form id="form" method="post" enctype="multipart/form-data" action="/tj/payinfo/orderform/batch_export">
            <table class="table table-hover table-condensed" style="width: 100%; height: 100%">
                <tr>
                    <th>开始时间</th>
                    <td><input name="startDate" class="easyui-textbox" value="${startDate}" readonly/></td>
                    <th>结束时间</th>
                    <td><input name="endDate" class="easyui-textbox" value="${endDate}" readonly/></td>
                </tr>
                <tr>
                    <th>用户ID</th>
                    <td><input name="userId" class="easyui-textbox" value="${userId}" readonly/></td>
                    <th>订单ID</th>
                    <td><input name="orderId" class="easyui-textbox" value="${orderId}" readonly/></td>
                </tr>
                <tr>
                    <th>支付渠道</th>
                    <td><input name="payType" class="easyui-textbox" value="${payType}" readonly/></td>
                    <th>终端</th>
                    <td><input name="deptId" class="easyui-textbox" value="${deptId}" readonly/></td>
                </tr>
                <tr>
                    <th>会员类型</th>
                    <td><input name="svip" class="easyui-textbox" value="${svip}" readonly/></td>
                    <th>支付状态</th>
                    <td><input name="status" class="easyui-textbox" value="${status}" readonly/></td>
                </tr>
                <tr>
                    <th>公司ID</th>
                    <td><input name="companyId" class="easyui-textbox" value="${companyId}" readonly/></td>
                    <th>支付流水</th>
                    <td><input name="orderNumber" class="easyui-textbox" value="${orderNumber}" readonly/></td>
                </tr>
                <tr>
                    <th>文件类型</th>
                    <td>
                        <select name="type" class="easyui-combobox" style="width: 140px;">
                            <option value="0">用户ID</option>
                            <option value="1">订单ID</option>
                        </select>
                    </td>
                    <th>上传文件</th>
                    <td><input id="fb" name="file" class="easyui-filebox"/></td>
                </tr>
                <tr>
                    <td colspan="4">
                        <b>说明：</b>上传文件格式必须为文本文件，如.txt或者.csv格式，不支持excel
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
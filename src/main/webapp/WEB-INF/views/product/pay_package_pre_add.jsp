<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<%@ include file="/WEB-INF/views/inc/jstl.inc"%>

<script type="text/javascript">
  $(function() {
    parent.$.messager.progress('close');
    $('#form').form({
      url : '${pageContext.request.contextPath}/pay_package_pre/add.json',
      onSubmit : function() {
        parent.$.messager.progress({
          title : '${internationalConfig.提示}',
          text : '${internationalConfig.数据处理中}'
        });
        
        var subscriptValue = $("input[name='subscript']:checked").val();
        if(subscriptValue == 1) {
          var subscriptTextValue = $("#subscriptText").val();
          if(subscriptTextValue == "") {
            parent.$.messager.alert('${internationalConfig.警告}', '${internationalConfig.则角标文案为必填项}', 'warn');
            parent.$.messager.progress('close');
            return false;
          }
        }
        
        var isValid = $(this).form('validate');
        if (!isValid) {
          parent.$.messager.progress('close');
        }
        return isValid;
      },
      success : function(result) {
        parent.$.messager.progress('close');
        result = $.parseJSON(result);
        if (result.code == 0) {
                  parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.添加成功}', 'success');
          parent.$.modalDialog.openner_dataGrid.datagrid('reload');
          parent.$.modalDialog.handler.dialog('close');
        } else {
          parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
        }
      }
    });
  });

  //增加自定义的表单验证规则
  $.extend($.fn.validatebox.defaults.rules, {
    number : {
      validator : function(value, param) {
        var reg = new RegExp("^[0-9]+(.[0-9]+)?$");
        return reg.test(value);
      },
      message : '${internationalConfig.请输入合法数字}'
    }
  });
  $.extend($.fn.validatebox.defaults.rules, {
    int : {
      validator : function(value, param) {
        var reg = new RegExp("^[0-9]+$");
        return reg.test(value);
      },
      message : '${internationalConfig.请输入合法整数}'
    }
  });
</script>

<div class="easyui-layout" data-options="fit:true,border:false" style="width:600px;">
  <div data-options="region:'center',border:false" title="" style="width:600px;">
    <form id="form" method="post"
      action="${pageContext.request.contextPath}/mealController/create">
      <table style="width: 100%" class="table table-form">
        <colgroup>
          <col width="100">
          <col width="100">
          <col width="121">
          <col width="*">
        </colgroup>
        <tr>
          <th>${internationalConfig.终端}</th>
          <td>
            <select name="terminal" class="span2">
              <c:forEach items="${terminals}" var="terminal">
                <option value="${terminal.terminalId}">${terminal.terminalName}</option>
              </c:forEach>
            </select>
          </td>
          <th>${internationalConfig.套餐状态}</th>
          <td>
            <select name="packageId" class="span2">
              <c:forEach items="${vipList}" var="vip">
                <option value="${vip.id}">${vip.packageNameDesc}_${vip.durationDesc}</option>
              </c:forEach>
            </select>
          </td>
        </tr>
        <tr>
          <th>${internationalConfig.角标}</th>
          <td><input type="radio" name="subscript" class="easyui-validatebox" checked
            value="1" />${internationalConfig.支持}&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="subscript"
            value="0" />${internationalConfig.不支持}</td>
          <th>${internationalConfig.角标文案}</th>
          <td><input type="text" name="subscriptText" id="subscriptText" class="easyui-validatebox"/></td>
        </tr>
        <tr>
          <th>${internationalConfig.排序}</th>
          <td><input type="text" name="sortValue" class="easyui-validatebox"
            data-options="required:true,validType:'int'" /></td>
          <th>${internationalConfig.状态}</th>
          <td><select name="status" id="status" class="span2">
                            <option value="0">${internationalConfig.下线}</option>
                            <option value="1">${internationalConfig.上线}</option>
                        </select>
          </td>
        </tr>
      </table>
    </form>
  </div>
</div>
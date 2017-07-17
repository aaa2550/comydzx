<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<script type="text/javascript" src="/static/lib/combinePackage.js?v=20150317.02" charset="utf-8"></script>
<script type="text/javascript">
  $(function() {
    parent.$.messager.progress('close');
    $('#form').form({
      url : '/combine_package/add.json',
      onSubmit : function() {
        parent.$.messager.progress({
          title : '${internationalConfig.提示}',
          text : '${internationalConfig.数据处理中}......'
        });
        
        var isflag = true;
        var selectCount = 0;
        
        $("select").each(function(){
          selectCount ++;
          if($(this).val() == -1) {
            isflag = false;
          }
        });
        
        if(! isflag) {
          parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.选择项不能为空}', 'error');
          parent.$.messager.progress('close');
          return false;
        }
        
        if(selectCount <= 1) {
          parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.请添加子套餐}', 'error');
          parent.$.messager.progress('close');
          return false;
        }
        
        if($("#price").val() < 0 || isNaN($("#price").val())) {
          parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.请添加子套餐}', 'error');
          parent.$.messager.progress('close');
          return false;
        }
        
        var isNumberFlag = true;
        
        $("input[name='discountPrices']").each(function(){ 
          var price = $(this).val();
          var reg = new RegExp("^[0-9]+(.[0-9]+)?$");
          if(! reg.test(price)) {
            isNumberFlag = false;
          }
        });
        
        if(! isNumberFlag) {
          parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.请输入合法折扣价格}', 'error');
          parent.$.messager.progress('close');
          return false;
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
          parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
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
  var Page ={
	'SelectPackage':'${internationalConfig.选择套餐类型}',
	'VipPackage':'${internationalConfig.会员套餐}',
	'LivePackage':'${internationalConfig.直播套餐}',
	'Video':'${internationalConfig.影视剧}',
	'Delete':'${internationalConfig.删除}',
	'Select':'${internationalConfig.选择}',
	'MobileVip':'${internationalConfig.移动影视会员}',
	'AllVip':'${internationalConfig.全屏影视会员}',
	'SportChannel':'${internationalConfig.体育频道}',
	'MusicChannel':'${internationalConfig.音乐频道}',
	'Movie':'${internationalConfig.电影}',
	'TvPlay':'${internationalConfig.电视剧}',
	'Time':'${internationalConfig.时长}',
	'Error':'${internationalConfig.错误}',
	'EnterRightDiscountPrice':'${internationalConfig.请输入合法折扣价格}'
	
  }
  
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
  <div data-options="region:'center',border:false" title="">
    <form id="form" method="post"
      action="">
      <table style="width: 100%" class="table table-form">

        <tr>
          <th style="width:16%;">${internationalConfig.套餐名称}：</th>
          <td><input type="text" name="name"  
            class="easyui-validatebox"
            data-options="required:true" /></td>
          <th style="vertical-align: middle;">${internationalConfig.套餐状态}：</th>
          <td><select name="status">
                <option value="0" selected>${internationalConfig.上线}</option>
                <option value="1">${internationalConfig.下线}</option>
              </select></td>
        </tr>
        <tr>
          <th>${internationalConfig.套餐名称}：</th>
          <td><input type="text" id="originPrice" name="originPrice" readOnly="readOnly"
            class="easyui-validatebox" /></td>
          <th style="vertical-align: middle;">${internationalConfig.套餐现价}：</th>
          <td><input type="text" id="price" name="price" readOnly="readOnly"
            class="easyui-validatebox" /></td>
        </tr>
        <tr>
          <th>${internationalConfig.套餐会员价}：</th>
          <td><input type="text" id="vipPrice" name="vipPrice"
            class="easyui-validatebox"
            data-options="required:true" /></td>
          <th></th>
          <td></td>
        </tr>
        <tr>
          <th>${internationalConfig.终端}</th>
          <td>
            <table class="no-border-table">
              <tr>
                
                  <td style="padding-right: 5px">
                  <c:forEach items="${terminals}" var="terminal"
                  varStatus="varStatus">
                  <input type="checkbox"
                    name="terminalsArray" value="${terminal.terminalId}" />&nbsp;${terminal.terminalName}
                </c:forEach>
                  </td>
              </tr>
            </table>
          </td>
          <th>${internationalConfig.是否支持乐点}：</th>
          <td>
            <input type="radio" name="isSupportLepoint" value="0" checked />${internationalConfig.支持}
            <input type="radio" name="isSupportLepoint" value="1"/>${internationalConfig.不支持}
          </td>
        </tr>
        <tr>
          <td colspan="2"><img onclick="addRow();" src="${pageContext.request.contextPath}/static/style/images/extjs_icons/pencil_add.png" title="${internationalConfig.新增套餐}"/> <a href="javascript:void(0)" onclick="addRow();">${internationalConfig.新增套餐}</a></td>
          
          <td colspan="2">
          
          </td>
        </tr>
      </table>
      
      <table id="childPackage" style="width: 780" class="table table-form">
        <tr>
          <th>${internationalConfig.子套餐名称}</th>
          <th>${internationalConfig.套餐类型}</th>
          <th>${internationalConfig.套餐明细}</th>
          <th>${internationalConfig.死忠季票包}</th>
          <th>${internationalConfig.现价}</th>
          <th>${internationalConfig.新增套餐}</th>
          <th>${internationalConfig.操作}</th>
          <th></th>
        </tr>
      </table>
    </form>
  </div>
</div>
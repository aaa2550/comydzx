<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    table{
        font-size:18px;
    }
</style>

<script type="text/javascript">
    $(function(){
        parent.$.messager.progress('close');
    });
</script>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'center'">
        <table border="1">
            <tr>
                <td>暂停/单价</td><td>5秒贴片/单价</td><td>10秒贴片/单价</td><td>15秒贴片/单价</td><td>30秒贴片/单价</td><td>60秒贴片/单价</td><td>75秒贴片/单价</td>
            </tr>
            <tr>
                <c:choose>
                    <c:when test="${type == 'PC'}">
                        <td>${shareCpmShow.pc}/${shareCpmShow.cpmConfig.pc}</td><td>${shareCpmShow.pc5}/${shareCpmShow.cpmConfig.pc5}</td><td>${shareCpmShow.pc10}/${shareCpmShow.cpmConfig.pc10}</td><td>${shareCpmShow.pc15}/${shareCpmShow.cpmConfig.pc15}</td><td>${shareCpmShow.pc30}/${shareCpmShow.cpmConfig.pc30}</td><td>${shareCpmShow.pc60}/${shareCpmShow.cpmConfig.pc60}</td><td>${shareCpmShow.pc75}/${shareCpmShow.cpmConfig.pc75}</td>
                    </c:when>
                    <c:when test="${type == 'PHONE'}">
                        <td>${shareCpmShow.phone}/${shareCpmShow.cpmConfig.phone}</td><td>${shareCpmShow.phone5}/${shareCpmShow.cpmConfig.phone5}</td><td>${shareCpmShow.phone10}/${shareCpmShow.cpmConfig.phone10}</td><td>${shareCpmShow.phone15}/${shareCpmShow.cpmConfig.phone15}</td><td>${shareCpmShow.phone30}/${shareCpmShow.cpmConfig.phone30}</td><td>${shareCpmShow.phone60}/${shareCpmShow.cpmConfig.phone60}</td><td>${shareCpmShow.phone75}/${shareCpmShow.cpmConfig.phone75}</td>
                    </c:when>
                    <c:otherwise>
                        <td>${shareCpmShow.tv}/${shareCpmShow.cpmConfig.tv}</td><td>${shareCpmShow.tv5}/${shareCpmShow.cpmConfig.tv5}</td><td>${shareCpmShow.tv10}/${shareCpmShow.cpmConfig.tv10}</td><td>${shareCpmShow.tv15}/${shareCpmShow.cpmConfig.tv15}</td><td>${shareCpmShow.tv30}/${shareCpmShow.cpmConfig.tv30}</td><td>${shareCpmShow.tv60}/${shareCpmShow.cpmConfig.tv60}</td><td>${shareCpmShow.tv75}/${shareCpmShow.cpmConfig.tv75}</td>
                    </c:otherwise>
                </c:choose>
            </tr>
        </table>
    </div>
</div>

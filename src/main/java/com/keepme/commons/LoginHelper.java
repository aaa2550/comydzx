package com.keepme.commons;

import com.keepme.pojo.User;
import com.keepme.service.BossUserService;
import com.keepme.util.CookieUtil;
import com.keepme.util.DataUtil;
import com.keepme.util.IPUtil;
import com.keepme.util.MD5Util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class LoginHelper {

    public static String getLoginName(HttpServletRequest request) {
        String cookie = CookieUtil.getCookie(request, Consts.LOGIN);
        if (!DataUtil.isEmpty(cookie)) {
            cookie = DataUtil.decode(cookie);
            String[] code = cookie.split(Consts.DELIM);
            if (code.length == 3) {
                String time = code[0];
                String name = code[1];
                String md5 = MD5Util.getMD5(name + Consts.KEY + time).substring(4, 20);
                long loginTime = DataUtil.toLong(time);
                // 判断时间,超过3天过期
                if (System.currentTimeMillis() - loginTime < 1000 * 60 * 60 * 24 * 3 && md5.equals(code[2])) {
                    return name;
                }
            }
        }
        return null;

    }

    public static User getLoginUser(HttpServletRequest request) {
        User user = (User) request.getAttribute("sessionInfo");
        if (user != null)
            return user;
        String name = getLoginName(request);
        if (DataUtil.isEmpty(name))
            return null;
        user = SpringBean.getBean(BossUserService.class).getUserByName(name);
        if (user != null) {
            user.setLoginIp(IPUtil.getRequestIP(request));
            request.setAttribute("sessionInfo", user);
        }
        return user;
    }

    public static void login(User user, HttpServletRequest request, HttpServletResponse response) {
        long time = System.currentTimeMillis();
        String value = DataUtil.join(Consts.DELIM, time + "", user.getName(),
                MD5Util.getMD5(user.getName() + Consts.KEY + time).substring(4, 20));
        value = DataUtil.encode(value);
        if (Environment.isTest())
            CookieUtil.setCookie(response, Consts.LOGIN, value, request.getServerName());
        else
            CookieUtil.setCookie(response, Consts.LOGIN, value, request.getServerName(), 1 * 60 * 2);
    }

    public static void logout(HttpServletRequest request, HttpServletResponse response) {
        CookieUtil.removeCookie(response, Consts.LOGIN, request.getServerName());
    }

}

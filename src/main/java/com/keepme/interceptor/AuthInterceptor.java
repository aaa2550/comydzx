package com.keepme.interceptor;

import com.keepme.commons.Consts;
import com.keepme.commons.LoginHelper;
import com.keepme.pojo.CodeMsg;
import com.keepme.pojo.User;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.HandlerMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 权限拦截器
 *
 * @author xieweibo
 */
public class AuthInterceptor implements HandlerInterceptor {

    /**
     * 完成页面的render后调用
     */
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object object,
                                Exception exception) throws Exception {

    }

    /**
     * 在调用controller具体方法前拦截
     */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object object) throws Exception {
        String url = String.valueOf(request.getAttribute(HandlerMapping.BEST_MATCHING_PATTERN_ATTRIBUTE));
        User user = LoginHelper.getLoginUser(request);
        if (user == null) {// 如果没有登录或登录超时
            return this.errorCode(response, new CodeMsg(1, request.getMethod() + "您还没有登录或登录已超时，请重新登录，然后再刷新本功能！" + url));
        }
        // 超管拥有所有权限
        if (user.isSuperMan()) {
            return true;
        }

        if (user.getResources().contains(url) || user.getResources().contains(request.getRequestURI())) {
            return true;
        }

        return this.errorCode(response, new CodeMsg(1, "您没有访问此资源的权限！请联系超管赋予您[" + request.getRequestURI() + "]的资源访问权限！"));

    }

    private boolean errorCode(final HttpServletResponse response, CodeMsg msg) {
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding(Consts.ENCODE);
        try {
            response.getWriter().write(msg.toString());
        } catch (IOException e1) {
            e1.printStackTrace();
        }
        return false;
    }

    /**
     * 在调用controller具体方法后拦截
     */

    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
                           ModelAndView modelAndView) throws Exception {

    }
}
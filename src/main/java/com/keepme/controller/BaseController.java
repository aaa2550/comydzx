package com.keepme.controller;

import com.keepme.commons.Consts;
import com.keepme.commons.LoginHelper;
import com.keepme.pojo.CodeMsg;
import com.keepme.pojo.User;
import com.keepme.pojo.UserOperateLog;
import com.keepme.service.UserOperateLogService;
import com.keepme.util.RequestUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.ExceptionHandler;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class BaseController {

    @Resource
    private UserOperateLogService userOperateLogService;

    final Logger logger = LoggerFactory.getLogger(getClass());

    /**
     * @deprecated
     * 推荐使用注入方式.
     * <pre> {@code
     *     public <T> method(@RequestAttribute("sessionInfo") User user){...}
     *}</pre>
     *
     */
    protected User getLoginUser(HttpServletRequest request) {
        return LoginHelper.getLoginUser(request);
    }

    /**
     * @deprecated
     * 推荐使用注入方式.
     * <pre> {@code
     *     public <T> method(@RequestAttribute("sessionInfo") User user){
     *         String name = user.getName();
     *         ...
     *     }
     *}</pre>
     *
     */
    protected String getLoginName(final HttpServletRequest request) {
        return LoginHelper.getLoginUser(request).getName();
    }

    protected void userLog(final HttpServletRequest request, String operation, String ext) {
        try {
            User user = this.getLoginUser(request);
            UserOperateLog uol = new UserOperateLog();
            uol.setOperateUid(user.getUid());
            uol.setOperater(user.getName());
            uol.setOperateIp(user.getLoginIp());
            uol.setOperation(operation);
            uol.setExt(ext);
            this.userOperateLogService.addUserOperateLog(uol);

        } catch (Exception e) {
            logger.error("userLog error !", e);
        }
    }

    protected void userLog(User user, String operation, String ext) {
        try {
            UserOperateLog uol = new UserOperateLog();
            uol.setOperateUid(user.getUid());
            uol.setOperater(user.getName());
            uol.setOperateIp(user.getLoginIp());
            uol.setOperation(operation);
            uol.setExt(ext);
            this.userOperateLogService.addUserOperateLog(uol);

        } catch (Exception e) {
            logger.error("userLog error !", e);
        }
    }

    @ExceptionHandler(Throwable.class)
    public void handleException(Throwable e, final HttpServletRequest request, final HttpServletResponse response) {
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding(Consts.ENCODE);
        logger.error("Global-error url=" + RequestUtil.getURL(request), e);
        String msg = e.getMessage();
        String s;
        if ("Request attribute sessionInfo should not be null".equals(msg)) {
            // 如果是session过期，提示重新登录。（方式比较丑陋，但是不用改太多已有代码）
            s = new CodeMsg(1, "您还没有登录或登录已超时，请重新登录，然后再刷新本功能！").toString();
        } else {
            s = new CodeMsg(9999, e.getMessage()).toString();
        }
        try {
            request.setCharacterEncoding(Consts.ENCODE);
            response.getWriter().write(s);
        } catch (IOException e1) {
            e1.printStackTrace();

        }
        e.printStackTrace();
    }

    protected CodeMsg errorCodeMsg() {
        return new CodeMsg();
    }

}

package com.ydzx.manager.controller;

import com.letv.boss.pojo.CodeMsg;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * 对请求参数进行过滤，防止sql注入
 * Created by kangxiongwei3 on 2016/6/27 13:31.
 */
public class RequestParamFilter implements Filter {

    private static final Logger log = LoggerFactory.getLogger(RequestParamFilter.class);

    /**
     * 返回信息码
     *
     * @param response
     * @param result
     */
    public void outPrint(HttpServletResponse response, Object result) {
        try {
            response.setCharacterEncoding("utf-8");
            PrintWriter out = response.getWriter();
            out.print(result.toString());
        } catch (IOException e) {
            log.error("e", e);
        }
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        log.info("=== RequestParamFilter init");
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;
        try {
            // 对Request里的传值参数进行安全过滤
            HttpServletRequest xssRequest = new SqlHttpServletRequestWrapper(request);
            chain.doFilter(xssRequest, response);
        } catch (RuntimeException e) {
            log.error("== ", e);
            CodeMsg msg = CodeMsg.ERROR;
            msg.setMsg(e.getMessage());
            msg.setData(e);
            outPrint(response, msg);
        }
    }

    @Override
    public void destroy() {
        log.info("=== RequestParamFilter destroy");
    }

}

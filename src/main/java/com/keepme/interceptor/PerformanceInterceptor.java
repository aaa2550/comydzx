package com.keepme.interceptor;

import com.keepme.util.IPUtil;
import org.perf4j.StopWatch;
import org.perf4j.slf4j.Slf4JStopWatch;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.web.servlet.HandlerMapping;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 性能拦截器，查询接口响应时间，调用次数
 *   默认 按 org.perf4j.TimingLogger 名字记录日志
 * @author xieweibo
 *
 */
public class PerformanceInterceptor extends HandlerInterceptorAdapter {

    private final static String SESSION_KEY = "sessionId";

    private static ThreadLocal<StopWatch> local = new ThreadLocal<StopWatch>();

    private final Logger switchLogger = LoggerFactory.getLogger("org.perf4j.TimingLogger");

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 放SessionId
        String token =  java.util.UUID.randomUUID().toString().replace("-","");
        MDC.put(SESSION_KEY, token);
        StopWatch stopWatch = new Slf4JStopWatch("shell");
        local.set(stopWatch);
        return true;
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
            throws Exception {
        // 删除
        MDC.remove(SESSION_KEY);
        StopWatch watch = local.get();
        if (watch != null) {
            watch.stop(generateOperatonIdendifier(request, watch.getElapsedTime()));
            local.remove();
        }
    }

    private String generateOperatonIdendifier(HttpServletRequest request, long exeTime) {
        StringBuilder sb = new StringBuilder(64);

        // 方法
        String method = request.getMethod();
        sb.append(method);

        sb.append('|');

        // URI
        if (switchLogger.isTraceEnabled()) { // 如果是trace级别，统计到具体的URI
            sb.append(request.getRequestURL());
            sb.append('|');
            String clientIp = IPUtil.getRequestIP(request);
            sb.append(clientIp);
            sb.append('|');
            sb.append(request.getHeader("User-Agent"));

        } else { // 按URI pattern匹配，方便汇总
            sb.append(request.getAttribute(HandlerMapping.BEST_MATCHING_PATTERN_ATTRIBUTE));
        }

        // 记录慢得url,
        if (exeTime > 400) {
            sb.append("|SLOW");
        }

        return sb.toString();
    }

}

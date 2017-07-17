package com.ydzx.manager;

import java.util.Date;
import java.util.concurrent.TimeUnit;

import javax.annotation.PostConstruct;
import javax.servlet.ServletContext;

import com.letv.boss.stat.pay.unionpay.LogUtil;
import jmind.core.util.DateUtil;
import jmind.core.util.DelayTaskExecutor;
import jmind.core.util.IpUtil;

import org.springframework.stereotype.Component;
import org.springframework.web.context.ServletContextAware;

import com.letv.boss.LetvEnv;
import com.letv.commons.util.Consts;

@Component
public class InitContext implements ServletContextAware {

    private ServletContext context;

    @PostConstruct
    public void init() {


        //     BeanFactoryLocator sysCtxLocator = SingletonBeanFactoryLocator.getInstance("push-context.xml");
        //        XmlWebApplicationContext context2 = (XmlWebApplicationContext) WebApplicationContextUtils
        //                .getWebApplicationContext(this.context);
        //        context2.setConfigLocation("classpath*:root-context.xml,classpath*:push-context.xml");
        //        context2.refresh();

        //初始化logback
        //     LogbackHelper.getInstance().initLog();
        //        LoggerContext lc = (LoggerContext) LoggerFactory.getILoggerFactory();
        //        StatusPrinter.print(lc);

        //        if (Consts.HAS_PUSH) {
        //            String[] scanPackages = { "com.letv.boss.push" };
        //            // 这个必须push-context 加载完成，执行才有效
        //            new PushServer2("bossapi-cluster", Consts.APP.getProperty("push.url"), 9997, scanPackages).start();
        //
        //        }

        // 页脚服务器名 applicationScope.uriPrefix
        context.setAttribute("ver", DateUtil.format(new Date(), "MMddHHmmss"));
        context.setAttribute("env", LetvEnv.getEnvironment());
        context.setAttribute("hostIp", IpUtil.getLocalAddress());
        context.setAttribute("appMap", Consts.APP);

    }

    @Override
    public void setServletContext(ServletContext servletContext) {
        this.context = servletContext;
    }

}

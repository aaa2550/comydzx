package com.ydzx.manager;

import java.util.List;

import javax.annotation.Resource;

import jmind.core.cache.MemCache.Type;
import jmind.core.cache.support.StatsCounterCache;
import jmind.core.spring.SpringBeanLocator;
import jmind.core.util.DataUtil;

import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import ch.qos.logback.classic.Level;

import com.alibaba.fastjson.JSONObject;
import com.letv.boss.LetvEnv;
import com.letv.boss.core.pay.dao.LeRechargeRecordDao;
import com.letv.boss.core.sys.dao.UserDao;
import com.letv.boss.core.yuanxian.dao.AwardDao;
import com.letv.boss.pojo.CodeMsg;
import com.letv.boss.pojo.User;
import com.letv.boss.pojo.pager.PageUnder;
import com.letv.boss.stat.channel.dao.ChannelStatDao;
import com.letv.boss.stat.channel.model.ChannelModuleModel;
import com.letv.commons.cache.CacheManager;
import com.letv.commons.util.Reload;
import com.letv.commons.util.ReloadManager;
import com.letv.share.dao.UserBasicDAO;

@RestController
@RequestMapping("/dev")
public class DEVController extends BaseController {

    final StatsCounterCache<String> statsCounter = new StatsCounterCache<String>();

    // 这里测试数据库权限，直接写dao 了
    @Resource
    UserDao userDao;

    @Resource
    LeRechargeRecordDao leRechargeRecordDao;

    @Resource
    AwardDao awardDao;

    @Resource
    ChannelStatDao channelStatDao;
    @Resource
    UserBasicDAO userBasicDao;

    //  测试每一个db的链接权限
    @RequestMapping("/test-db")
    public String testdb() {
        PageUnder pageUnder = new PageUnder();
        pageUnder.setRows(1);
        JSONObject jo = new JSONObject();
        User user = userDao.getUser(1);
        jo.put("user", user);

        jo.put("record", leRechargeRecordDao.getRechargeRecordList("68671314", null, null, pageUnder));

        jo.put("yuanxian ", awardDao.getAwardByPage(0, 0, pageUnder));
        List<ChannelModuleModel> list = channelStatDao.selectModule(new ChannelModuleModel());
        if (!DataUtil.isEmpty(list)) {
            jo.put("bosstdy", list.get(0));
        } else {
            jo.put("bossdty", "");
        }
        jo.put("share_c", userBasicDao.getCount());

        return jo.toJSONString();
    }

    @RequestMapping("/cache")
    public String cache() {
        return CacheManager.getManager().isXmem + ",Record=" + CacheManager.getManager().getRecord();
    }

    @RequestMapping("/cache/{type}/set")
    public String set(@PathVariable String type, String key, String val, int expire) {
        CacheManager.getManager().getCache(Type.valueOf(type.toUpperCase())).set(key, expire, val);
        Object s = CacheManager.getManager().getCache(Type.valueOf(type.toUpperCase())).get(key);

        return s.toString();
    }

    @RequestMapping("/cache/{type}/get")
    public String get(@PathVariable String type, String key) {
        return key + "=" + CacheManager.getManager().getCache(Type.valueOf(type.toUpperCase())).get(key);
    }

    @RequestMapping("/cache/{type}/del")
    public String del(@PathVariable String type, String key) {
        return key + ":" + CacheManager.getManager().getCache(Type.valueOf(type.toUpperCase())).delete(key);
    }

    @RequestMapping("/reload/{name}")
    public CodeMsg reload(@PathVariable String name) {
        if (DataUtil.isEmpty(name) || !SpringBeanLocator.getInstance().containsBean(name)) {
            return CodeMsg.ERROR;
        }
        Reload reload = SpringBeanLocator.getInstance().getBean(name, Reload.class);
        reload.reload();
        return CodeMsg.SUCCESS;

    }

    @RequestMapping("/push/{name}")
    public CodeMsg push(@PathVariable String name, String key) {
        if (DataUtil.isEmpty(key)) {
            ReloadManager.reload(name);
        } else {
            ReloadManager.reload(name, key);
        }
        return CodeMsg.SUCCESS;

    }

    @RequestMapping("/log_{level}")
    public String setLogLevel(String name, @PathVariable String level) {

        ch.qos.logback.classic.Logger logger = (ch.qos.logback.classic.Logger) LoggerFactory.getLogger(name);
        Level level1 = logger.getLevel();
        logger.setLevel(Level.toLevel(level));
        return name + "=before:" + level1 + ",after:" + logger.getLevel().toString();
    }

    @RequestMapping("/log")
    public String log(String name) {
        ch.qos.logback.classic.Logger logger = (ch.qos.logback.classic.Logger) LoggerFactory.getLogger(name);
        String s = LetvEnv.getEnvironment() + "--" + logger.getName() + "---" + logger.getLevel();
        logger.info("logs={}", s);
        return s;
    }

    //    @RequestMapping("/ftp")
    //    public void ftp(final HttpServletRequest request, final HttpServletResponse response) throws SocketException,
    //            IOException {
    //        RequestUtil.setTextHead("xiazai", request, response, GlobalConstants.ENCODE);
    //        FTP ftp = new FTP();
    //        ftp.connectServer("10.127.220.164", 6021, "boss", "SmWa5boh3zQqKA6JevL6", null);
    //        ftp.download("eee.txt", response.getOutputStream());
    //        ftp.closeServer();
    //    }

}

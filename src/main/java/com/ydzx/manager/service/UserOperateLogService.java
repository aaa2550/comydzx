package com.ydzx.manager.service;

import com.letv.boss.core.log.dao.UserOperateLogDao;
import com.letv.boss.pojo.UserOperateLog;
import jmind.core.lang.Pager;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * 用户操作日志记录服务实现类
 * @author shaoxiangfei
 *
 */
@Service
public class UserOperateLogService {

    @Resource
    private UserOperateLogDao userOperateDao;

    /**
     * 记录用户操作日志
     * @param userOperateLog
     */
    public void addUserOperateLog(UserOperateLog userOperateLog) {
        userOperateDao.addUserOperateLog(userOperateLog);
    }

    public List<UserOperateLog> userLogList(UserOperateLog userOperateLog, Pager pager) {
        return userOperateDao.userLogList(userOperateLog, pager);
    }

    public int userLogCount(UserOperateLog userOperateLog) {
        return userOperateDao.userLogCount(userOperateLog);
    }

}

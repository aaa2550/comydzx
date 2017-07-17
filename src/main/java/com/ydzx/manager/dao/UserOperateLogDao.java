package com.ydzx.manager.dao;

import com.letv.boss.pojo.UserOperateLog;
import com.letv.commons.util.Consts;
import jmind.core.lang.Pager;
import org.jfaster.mango.annotation.DB;
import org.jfaster.mango.annotation.SQL;

import java.util.List;

/**
 * 用户操作日志信息dao
 * @author shaoxiangfei
 *
 */
@DB(dataSource = Consts.DB_LETV_BOSS, table = "user_operate_log")
public interface UserOperateLogDao {

    static final String COLUMNS = "operate_uid, operater, operate_ip, operate_time, " + "operation, ext";

    static final String SEARCH = " from #table where 1=1  "
            + " #if(:operater!=null ) and operater =:operater #end #if(:operateIp!=null ) and operate_ip=:operateIp #end"
            + " #if(:operateTime!=null ) and operate_time >=:operateTime  #end   #if(:endTime!=null ) and operate_time <=:endTime  #end"
            + "#if(:operation!=null) and operation like :operation #end #if(:ext!=null) and ext like :ext #end";

    @SQL("insert into #table(" + COLUMNS + ") " + "values(:1.operateUid, :1.operater, :1.operateIp, now(), "
            + ":1.operation, :1.ext)")
    public int addUserOperateLog(UserOperateLog userOperateLog);

    @SQL("SELECT *" + SEARCH)
    public List<UserOperateLog> userLogList(UserOperateLog userOperateLog, Pager pager);

    @SQL("SELECT COUNT(*) " + SEARCH)
    public int userLogCount(UserOperateLog userOperateLog);
}

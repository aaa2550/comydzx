package com.ydzx.dao;

import com.ydzx.commons.Consts;
import com.ydzx.pojo.PageUnder;
import com.ydzx.pojo.User;
import org.jfaster.mango.annotation.DB;
import org.jfaster.mango.annotation.ReturnGeneratedId;
import org.jfaster.mango.annotation.SQL;

import java.util.List;

/**
 * @author ash
 */
@DB(dataSource = Consts.DB_LETV_BOSS, table = "user")
public interface UserDao {

    static final String SEARCH = " from #table where 1=1  " + " #if(:1!=null ) and name like :1 #end"
            + " #if(:2!=null ) and create_time > :2 #end" + " #if(:3!=null ) and create_time <=:3 #end"
            + " #if(:4!=null) and (rids=:4 or rids like concat('%,', :4,',%') or rids like concat('%,', :4) or rids like concat(:4, '%,')) #end";

    @ReturnGeneratedId
    @SQL("insert into #table(name,nickname,pwd,company,create_time,modify_time) values(:name,:nickname,:pwd,:company,now(),now())")
    public int add(User user);

    @SQL("SELECT *" + SEARCH)
    public List<User> search(String name, String start, String end, String rids, PageUnder pager);

    @SQL("SELECT COUNT(*) " + SEARCH)
    public int countSearch(String name, String start, String end, String rids);

    // 1,2,3
    @SQL("select * from #table where uid=:1")
    public User getUser(int uid);

    @SQL("select *  from #table where name=:1")
    public User getUserByName(String name);

    @SQL(Consts.SQL_DELETE)
    public int delete(int id);

    @SQL("delete from #table where uid in(:1)")
    public int delete(List<Integer> uids);

    @SQL("update #table set rids=:1.rids where uid=:1.uid")
    public int grant(User user);

    /**
     * 根据rid匹配用户，由于需要精确匹配用concat连接,rid前后都加上逗号
     * @param rid  %,132,%
     * @return
     */
    @SQL("select name from user where  concat(',',rids,',') like :1 ")
    public List<String> getNamesByRid(String rid);

    @SQL("select name from #table")
    public List<String> getNames();

    @SQL("select * from #table where pwd is not null")
    public List<User> getUsers();

    @SQL("update #table set pwd=:pwd where name=:name")
    public int updatePwd(User user);
}

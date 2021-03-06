package com.keepme.dao;

import com.keepme.commons.Consts;
import com.keepme.pojo.PageUnder;
import com.keepme.pojo.User;
import org.jfaster.mango.annotation.DB;
import org.jfaster.mango.annotation.ReturnGeneratedId;
import org.jfaster.mango.annotation.SQL;

import java.util.List;

/**
 * @author ash
 */
@DB(table = "user")
public interface UserDao {

    String SEARCH = " from #table where 1=1  " + " #if(:1!=null ) and name like :1 #end"
            + " #if(:2!=null ) and create_time > :2 #end" + " #if(:3!=null ) and create_time <=:3 #end"
            + " #if(:4!=null) and (rids=:4 or rids like concat('%,', :4,',%') or rids like concat('%,', :4) or rids like concat(:4, '%,')) #end";

    @ReturnGeneratedId
    @SQL("insert into #table(name,nickname,pwd,company,create_time,modify_time) values(:name,:nickname,:pwd,:company,now(),now())")
    int add(User user);

    @SQL("SELECT *" + SEARCH)
    List<User> search(String name, String start, String end, String rids, PageUnder pager);

    @SQL("SELECT COUNT(*) " + SEARCH)
    int countSearch(String name, String start, String end, String rids);

    // 1,2,3
    @SQL("select * from #table where uid=:1")
    User getUser(int uid);

    @SQL("select *  from #table where name=:1")
    User getUserByName(String name);

    @SQL(Consts.SQL_DELETE)
    int delete(int id);

    @SQL("delete from #table where uid in(:1)")
    int delete(List<Integer> uids);

    @SQL("update #table set rids=:1.rids where uid=:1.uid")
    int grant(User user);

    /**
     * 根据rid匹配用户，由于需要精确匹配用concat连接,rid前后都加上逗号
     * @param rid  %,132,%
     * @return
     */
    @SQL("select name from user where  concat(',',rids,',') like :1 ")
    List<String> getNamesByRid(String rid);

    @SQL("select name from #table")
    List<String> getNames();

    @SQL("select * from #table where pwd is not null")
    List<User> getUsers();

    @SQL("update #table set pwd=:pwd where name=:name")
    int updatePwd(User user);
}

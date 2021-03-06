package com.keepme.dao;

import com.keepme.commons.Consts;
import com.keepme.pojo.Role;
import org.jfaster.mango.annotation.DB;
import org.jfaster.mango.annotation.ReturnGeneratedId;
import org.jfaster.mango.annotation.SQL;

import java.util.List;

@DB(table = "role")
public interface RoleDao {

    @SQL("select rids from #table where id in (#{:1})")
    List<String> getResources(String ids);

    @SQL("select rids from #table where id in (:1)")
    List<String> getResources(List<Integer> ids);

    @SQL("select * from #table order by seq")
    List<Role> list();

    @SQL("insert into #table(id,name,remark,seq,pid) values(:1.id,:1.name,:1.remark,:1.seq,:1.pid)")
    @ReturnGeneratedId
    int save(Role role);

    @SQL("update #table set name=:1.name,remark=:1.remark,seq=:1.seq,pid=:1.pid where id=:1.id")
    int update(Role role);

    @SQL("update #table set rids=:1.rids where id=:1.id")
    int grant(Role role);

    @SQL(Consts.SQL_DELETE)
    int delete(int id);

    @SQL(Consts.SQL_GET)
    Role get(int id);
}

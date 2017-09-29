package com.keepme.dao;

import com.keepme.commons.Consts;
import com.keepme.pojo.Resources;
import org.jfaster.mango.annotation.DB;
import org.jfaster.mango.annotation.SQL;

import java.util.List;
import java.util.Set;

@DB(table = "resources")
public interface ResourceDao {

    @SQL("select * from #table order by seq")
    List<Resources> list();

    @SQL("select * from #table where id in(:1)")
    List<Resources> geResources(Set<Integer> ids);

    @SQL("insert into #table(name,name_en,remark,seq,pid,iconCls,url,typeId) values(:1.name,:1.nameEn,:1.remark,:1.seq,:1.pid,:1.iconCls,:1.url,:1.typeId)")
    int add(Resources resources);

    @SQL("select url from #table where id in(:1)")
    Set<String> getUrlByIds(Set<Integer> ids);

    @SQL("select * from #table where typeId=0 order by seq")
    List<Resources> listMenu();

    @SQL("select * from #table where id in(:1) and typeId=0 order by seq")
    List<Resources> listMenu(Set<Integer> ids);

    @SQL("select * from #table where id =:1")
    Resources get(int id);

    @SQL("update #table set name=:1.name,name_en=:1.nameEn,remark=:1.remark,seq=:1.seq,pid=:1.pid,iconCls=:1.iconCls,url=:1.url,typeId=:1.typeId where id=:1.id")
    int edit(Resources resource);

    @SQL(Consts.SQL_DELETE)
    public int delete(int id);

}

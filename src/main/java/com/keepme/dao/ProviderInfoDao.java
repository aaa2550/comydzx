package com.keepme.dao;

import com.keepme.pojo.CustomerInfo;
import com.keepme.pojo.PageUnder;
import com.keepme.pojo.ProviderInfo;
import org.jfaster.mango.annotation.DB;
import org.jfaster.mango.annotation.ReturnGeneratedId;
import org.jfaster.mango.annotation.SQL;

import java.util.List;

/**
 * Created by yanghailong on 2017/9/29.
 */
@DB(table = "provider_info")
public interface ProviderInfoDao {

    @ReturnGeneratedId
    @SQL("insert into #table (create_time,update_time,company_name,name,province,city,address,linkman_name,linkman_tel,email,remark) " +
            "values(now(),now(),:companyName,:name,:province,:city,:address,:linkmanName,:linkmanTel,:email,:remark)")
    int add(ProviderInfo providerInfo);

    @SQL("select * from #table")
    List<ProviderInfo> list(PageUnder pager);

}

package com.keepme.dao;

import com.keepme.commons.Consts;
import com.keepme.pojo.CustomerInfo;
import com.keepme.pojo.PageUnder;
import com.keepme.pojo.Resources;
import com.keepme.pojo.User;
import org.jfaster.mango.annotation.DB;
import org.jfaster.mango.annotation.ReturnGeneratedId;
import org.jfaster.mango.annotation.SQL;

import java.util.Date;
import java.util.List;
import java.util.Set;

/**
 * Created by yanghailong on 2017/9/29.
 */
@DB(table = "customer_info")
public interface CustomerInfoDao {

    @ReturnGeneratedId
    @SQL("insert into #table (create_time,update_time,company_name,type,name,province,city,address,linkman_name,linkman_tel,email,remark) " +
            "values(now(),now(),:companyName,:type,:name,:province,:city,:address,:linkmanName,:linkmanTel,:email,:remark)")
    int add(CustomerInfo customerInfo);

    @SQL("select * from #table")
    List<CustomerInfo> list(PageUnder pager);

}

package com.keepme.dao;

import com.keepme.pojo.BankAccountInfo;
import com.keepme.pojo.InvoiceInfo;
import com.keepme.pojo.PageUnder;
import org.jfaster.mango.annotation.DB;
import org.jfaster.mango.annotation.ReturnGeneratedId;
import org.jfaster.mango.annotation.SQL;

import java.util.List;

/**
 * Created by yanghailong on 2017/9/29.
 */
@DB(table = "bank_account_info")
public interface BankAccountInfoDao {

    @ReturnGeneratedId
    @SQL("insert into #table (create_time,update_time,company_id,type,account_name,bank_name,account_code) " +
            "values(now(),now(),:companyId,:type,:accountName,:bankName,:accountCode)")
    int add(BankAccountInfo bankAccountInfo);

    @SQL("select * from #table")
    List<BankAccountInfo> list(PageUnder pager);

}

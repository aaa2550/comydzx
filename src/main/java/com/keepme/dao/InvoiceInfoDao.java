package com.keepme.dao;

import com.keepme.pojo.InvoiceInfo;
import com.keepme.pojo.PageUnder;
import com.keepme.pojo.ProviderInfo;
import org.jfaster.mango.annotation.DB;
import org.jfaster.mango.annotation.ReturnGeneratedId;
import org.jfaster.mango.annotation.SQL;

import java.util.List;

/**
 * Created by yanghailong on 2017/9/29.
 */
@DB(table = "invoice_info")
public interface InvoiceInfoDao {

    @ReturnGeneratedId
    @SQL("insert into #table (create_time,update_time,company_id,type,taxpayer_code,title,address,tel,open_account_bank,account_code) " +
            "values(now(),now(),:companyId,:type,:taxpayerCode,:title,:address,:tel,:openAccountBank,:accountCode)")
    int add(InvoiceInfo invoiceInfo);

    @SQL("select * from #table")
    List<InvoiceInfo> list(PageUnder pager);

}

package com.keepme.dao;

import com.keepme.pojo.InvoiceRecord;
import com.keepme.pojo.KeepmeAccountInfo;
import com.keepme.pojo.PageUnder;
import org.jfaster.mango.annotation.DB;
import org.jfaster.mango.annotation.ReturnGeneratedId;
import org.jfaster.mango.annotation.SQL;

import java.util.Date;
import java.util.List;

/**
 * Created by yanghailong on 2017/9/29.
 */
@DB(table = "invoice_record")
public interface InvoiceRecordDao {

    @ReturnGeneratedId
    @SQL("insert into #table (createTime,updateTime,invoiceInfoId,type,applyName,customerId,customerName,money,platform,payTime,invoiceCode,openTime) " +
            "values(now(),now(),:invoiceInfoId,:type,:applyName,:customerId,:customerName,:money,:platform,:payTime,:invoiceCode,:openTime)")
    int add(InvoiceRecord invoiceRecord);

    @SQL("select * from #table")
    List<InvoiceRecord> list(PageUnder pager);


}

package com.keepme.dao;

import com.keepme.pojo.PageUnder;
import com.keepme.pojo.ProviderContractInfo;
import com.keepme.pojo.ReturnPayInfo;
import org.jfaster.mango.annotation.DB;
import org.jfaster.mango.annotation.ReturnGeneratedId;
import org.jfaster.mango.annotation.SQL;

import java.util.Date;
import java.util.List;

/**
 * Created by yanghailong on 2017/9/29.
 */
@DB(table = "return_pay_info")
public interface ReturnPayInfoDao {

    @ReturnGeneratedId
    @SQL("insert into #table (create_time,update_time,customer_id,customer_name,transact_time,pay_money,return_money,surplus_money,currency,account_name,account,open_account_institutions,bank_record_time,abstracts,remark,serial_number,voucher_species,voucher_code) " +
            "values(now(),now(),:customerId,:customerName,:transactTime,:payMoney,:returnMoney,:surplusMoney,:currency,:accountName,:account,:openAccountInstitutions,:bankRecordTime,:abstracts,:remark,:serialNumber,:voucherSpecies,:voucherCode)")
    int add(ReturnPayInfo returnPayInfo);

    @SQL("select * from #table")
    List<ReturnPayInfo> list(PageUnder pager);

}

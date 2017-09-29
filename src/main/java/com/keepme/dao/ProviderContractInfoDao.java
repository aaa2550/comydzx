package com.keepme.dao;

import com.keepme.pojo.CustomerContractInfo;
import com.keepme.pojo.PageUnder;
import com.keepme.pojo.ProviderContractInfo;
import org.jfaster.mango.annotation.DB;
import org.jfaster.mango.annotation.ReturnGeneratedId;
import org.jfaster.mango.annotation.SQL;

import java.util.List;

/**
 * Created by yanghailong on 2017/9/29.
 */
@DB(table = "provider_contract_info")
public interface ProviderContractInfoDao {

    @ReturnGeneratedId
    @SQL("insert into #table (create_time,update_time,customer_type,business_type,contract_code,statistics_short_name,our_company_name,contract_start_time,contract_end_time,rebates,orderfrom) " +
            "values(now(),now(),:customerType,:businessType,:contractCode,:statisticsShortName,:ourCompanyName,:contractStartTime,:contractEndTime,:rebates,:orderfrom)")
    int add(ProviderContractInfo providerContractInfo);

    @SQL("select * from #table")
    List<ProviderContractInfo> list(PageUnder pager);

}

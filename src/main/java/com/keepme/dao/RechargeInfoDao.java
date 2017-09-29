package com.keepme.dao;

import com.keepme.pojo.PageUnder;
import com.keepme.pojo.ProviderContractInfo;
import com.keepme.pojo.RechargeInfo;
import org.jfaster.mango.annotation.DB;
import org.jfaster.mango.annotation.ReturnGeneratedId;
import org.jfaster.mango.annotation.SQL;

import java.util.Date;
import java.util.List;

/**
 * Created by yanghailong on 2017/9/29.
 */
@DB(table = "recharge_info")
public interface RechargeInfoDao {

    @ReturnGeneratedId
    @SQL("insert into #table (create_time,update_time,generalize_id,app_id,customer_id,customer_name,provider_id,provider_name,our_rebates,customer_rebates,account_recharge,rebates_recharge,recharge_cost) " +
            "values(now(),now(),:generalizeId,:appId,:customerId,:customerName,:providerId,:providerName,:ourRebates,:customerRebates,:accountRecharge,:rebatesRecharge,:rechargeCost)")
    int add(RechargeInfo rechargeInfo);

    @SQL("select * from #table")
    List<RechargeInfo> list(PageUnder pager);

}

package com.keepme.dao;

import com.keepme.pojo.KeepmeAccountInfo;
import com.keepme.pojo.PageUnder;
import com.keepme.pojo.ProviderContractInfo;
import org.jfaster.mango.annotation.DB;
import org.jfaster.mango.annotation.ReturnGeneratedId;
import org.jfaster.mango.annotation.SQL;

import java.util.Date;
import java.util.List;

/**
 * Created by yanghailong on 2017/9/29.
 */
@DB(table = "keepme_account_info")
public interface KeepmeAccountInfoDao {

    @ReturnGeneratedId
    @SQL("insert into #table (create_time,update_time,app_id,platform,keepme_account_name,keepme_account_id,provider_id,provider_name,qq,industry,generalize_link,services,subpackage,ocpa,pass_status,pass_time) " +
            "values(now(),now(),:appId,:platform,:keepmeAccountName,:keepmeAccountId,:providerId,:providerName,:qq,:industry,:generalizeLink,:services,:subpackage,:ocpa,:passStatus,:passTime)")
    int add(KeepmeAccountInfo keepmeAccountInfo);

    @SQL("select * from #table")
    List<KeepmeAccountInfo> list(PageUnder pager);

}

package com.keepme.dao;

import com.keepme.pojo.KeepmeAccountInfo;
import com.keepme.pojo.PageUnder;
import com.keepme.pojo.RebatesInfo;
import org.jfaster.mango.annotation.DB;
import org.jfaster.mango.annotation.ReturnGeneratedId;
import org.jfaster.mango.annotation.SQL;

import java.util.List;

/**
 * Created by yanghailong on 2017/9/29.
 */
@DB(table = "rebates_info")
public interface RebatesInfoDao {

    @ReturnGeneratedId
    @SQL("insert into #table (create_time,update_time,type,start_time,end_time,rebates,contract_id,user_id,user_name) " +
            "values(now(),now(),:type,:startTime,:endTime,:rebates,:contractId,:userId,:userName)")
    int add(RebatesInfo rebatesInfo);

    @SQL("select * from #table")
    List<RebatesInfo> list(PageUnder pager);

}

package com.keepme.service;

import com.keepme.dao.RechargeInfoDao;
import com.keepme.pojo.PageUnder;
import com.keepme.pojo.RechargeInfo;
import org.jfaster.mango.annotation.SQL;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by yanghailong on 2017/9/29.
 */
@Service
public class RechargeInfoService {

    @Resource
    private RechargeInfoDao rechargeInfoDao;

    int add(RechargeInfo rechargeInfo) {
        return rechargeInfoDao.add(rechargeInfo);
    }

    List<RechargeInfo> list(PageUnder pager) {
        return rechargeInfoDao.list(pager);
    }

}

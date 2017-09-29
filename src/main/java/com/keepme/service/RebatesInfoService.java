package com.keepme.service;

import com.keepme.dao.RebatesInfoDao;
import com.keepme.pojo.PageUnder;
import com.keepme.pojo.RebatesInfo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by yanghailong on 2017/9/29.
 */
@Service
public class RebatesInfoService {

    @Resource
    private RebatesInfoDao rebatesInfoDao;

    int add(RebatesInfo rebatesInfo) {
        return rebatesInfoDao.add(rebatesInfo);
    }

    List<RebatesInfo> list(PageUnder pager) {
        return rebatesInfoDao.list(pager);
    }
}

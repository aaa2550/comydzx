package com.keepme.service;

import com.keepme.dao.KeepmeAccountInfoDao;
import com.keepme.pojo.KeepmeAccountInfo;
import com.keepme.pojo.PageUnder;
import org.jfaster.mango.annotation.SQL;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by yanghailong on 2017/9/29.
 */
@Service
public class KeepmeAccountInfoService {

    @Resource
    private KeepmeAccountInfoDao keepmeAccountInfoDao;

    int add(KeepmeAccountInfo keepmeAccountInfo) {
        return keepmeAccountInfoDao.add(keepmeAccountInfo);
    }

    List<KeepmeAccountInfo> list(PageUnder pager) {
        return keepmeAccountInfoDao.list(pager);
    }

}

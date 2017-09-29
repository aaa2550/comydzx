package com.keepme.service;

import com.keepme.dao.ReturnPayInfoDao;
import com.keepme.pojo.PageUnder;
import com.keepme.pojo.ReturnPayInfo;
import org.jfaster.mango.annotation.SQL;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by yanghailong on 2017/9/29.
 */
@Service
public class ReturnPayInfoService {

    @Resource
    private ReturnPayInfoDao returnPayInfoDao;

    int add(ReturnPayInfo returnPayInfo) {
        return returnPayInfoDao.add(returnPayInfo);
    }

    List<ReturnPayInfo> list(PageUnder pager) {
        return returnPayInfoDao.list(pager);
    }

}

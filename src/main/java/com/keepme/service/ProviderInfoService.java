package com.keepme.service;

import com.keepme.dao.CustomerInfoDao;
import com.keepme.dao.ProviderInfoDao;
import com.keepme.pojo.CustomerInfo;
import com.keepme.pojo.PageUnder;
import com.keepme.pojo.ProviderInfo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by yanghailong on 2017/9/29.
 */
@Service
public class ProviderInfoService {

    @Resource
    private ProviderInfoDao providerInfoDao;

    int add(ProviderInfo providerInfo) {
        return providerInfoDao.add(providerInfo);
    }

    List<ProviderInfo> list(PageUnder pager) {
        return providerInfoDao.list(pager);
    }

}

package com.keepme.service;

import com.keepme.dao.CustomerContractInfoDao;
import com.keepme.dao.ProviderContractInfoDao;
import com.keepme.pojo.CustomerContractInfo;
import com.keepme.pojo.PageUnder;
import com.keepme.pojo.ProviderContractInfo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by yanghailong on 2017/9/29.
 */
@Service
public class ProviderContractInfoService {

    @Resource
    private ProviderContractInfoDao providerContractInfoDao;

    int add(ProviderContractInfo providerContractInfo) {
        return providerContractInfoDao.add(providerContractInfo);
    }

    List<ProviderContractInfo> list(PageUnder pager) {
        return providerContractInfoDao.list(pager);
    }

}

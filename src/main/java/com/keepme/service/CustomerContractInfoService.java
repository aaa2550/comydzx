package com.keepme.service;

import com.keepme.dao.CustomerContractInfoDao;
import com.keepme.pojo.CustomerContractInfo;
import com.keepme.pojo.PageUnder;
import org.jfaster.mango.annotation.DB;
import org.jfaster.mango.annotation.ReturnGeneratedId;
import org.jfaster.mango.annotation.SQL;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by yanghailong on 2017/9/29.
 */
@Service
public class CustomerContractInfoService {

    @Resource
    private CustomerContractInfoDao customerContractInfoDao;

    int add(CustomerContractInfo customerContractInfo) {
        return customerContractInfoDao.add(customerContractInfo);
    }

    List<CustomerContractInfo> list(PageUnder pager) {
        return customerContractInfoDao.list(pager);
    }

}

package com.keepme.service;

import com.keepme.dao.CustomerInfoDao;
import com.keepme.pojo.CustomerInfo;
import com.keepme.pojo.PageUnder;
import org.jfaster.mango.annotation.ReturnGeneratedId;
import org.jfaster.mango.annotation.SQL;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by yanghailong on 2017/9/29.
 */
@Service
public class CustomerInfoService {

    @Resource
    private CustomerInfoDao customerInfoDao;

    int add(CustomerInfo customerInfo) {
        return customerInfoDao.add(customerInfo);
    }

    List<CustomerInfo> list(PageUnder pager) {
        return customerInfoDao.list(pager);
    }

}

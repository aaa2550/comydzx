package com.keepme.service;

import com.keepme.dao.BankAccountInfoDao;
import com.keepme.pojo.BankAccountInfo;
import com.keepme.pojo.PageUnder;
import org.jfaster.mango.annotation.SQL;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by yanghailong on 2017/9/29.
 */
@Service
public class BankAccountInfoService {

    @Resource
    private BankAccountInfoDao bankAccountInfoDao;

    int add(BankAccountInfo bankAccountInfo) {
        return bankAccountInfoDao.add(bankAccountInfo);
    }

    List<BankAccountInfo> list(PageUnder pager) {
        return bankAccountInfoDao.list(pager);
    }

}

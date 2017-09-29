package com.keepme.service;

import com.keepme.dao.InvoiceInfoDao;
import com.keepme.pojo.InvoiceInfo;
import com.keepme.pojo.PageUnder;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by yanghailong on 2017/9/29.
 */
@Service
public class InvoiceInfoService {

    @Resource
    private InvoiceInfoDao invoiceInfoDao;

    int add(InvoiceInfo invoiceInfo) {
        return invoiceInfoDao.add(invoiceInfo);
    }

    List<InvoiceInfo> list(PageUnder pager) {
        return invoiceInfoDao.list(pager);
    }

}

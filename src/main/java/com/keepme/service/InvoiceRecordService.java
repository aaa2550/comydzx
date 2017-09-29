package com.keepme.service;

import com.keepme.dao.InvoiceRecordDao;
import com.keepme.pojo.InvoiceRecord;
import com.keepme.pojo.PageUnder;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by yanghailong on 2017/9/29.
 */
@Service
public class InvoiceRecordService {

    @Resource
    private InvoiceRecordDao invoiceRecordDao;

    int add(InvoiceRecord invoiceRecord) {
        return invoiceRecordDao.add(invoiceRecord);
    }

    List<InvoiceRecord> list(PageUnder pager) {
        return invoiceRecordDao.list(pager);
    }

}

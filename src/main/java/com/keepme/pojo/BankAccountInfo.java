package com.keepme.pojo;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * Created by yanghailong on 2017/9/29.
 */
@Data
@NoArgsConstructor
public class BankAccountInfo extends Pojo {

    private Integer id;  //
    private Date createTime;  //创建时间
    private Date updateTime;  //修改时间
    private String companyId;  //所属公司
    private Integer type;  //我司/客户/供应商InvoiceInfoEnum
    private String accountName;  //账户名称
    private String bankName;  //银行名称
    private String accountCode;  //账户号
    
}

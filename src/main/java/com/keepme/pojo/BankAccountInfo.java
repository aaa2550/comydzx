package com.keepme.pojo;

import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Created by yanghailong on 2017/9/29.
 */
@Data
@NoArgsConstructor
public class BankAccountInfo extends Pojo {
    
    private String id;  //
    private String createTime;  //创建时间
    private String updateTime;  //修改时间
    private String companyId;  //所属公司
    private String type;  //我司/客户/供应商
    private String accountName;  //账户名称
    private String bankName;  //银行名称
    private String accountCode;  //账户号
    
}

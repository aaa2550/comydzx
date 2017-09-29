package com.keepme.pojo;

import com.keepme.enums.InvoiceInfoEnum;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * Created by yanghailong on 2017/9/29.
 */
@Data
@NoArgsConstructor
public class InvoiceInfo extends Pojo {

    private Integer id;  //
    private Integer companyId;  //所属公司
    private Integer type;  //我司/客户/供应商InvoiceInfoEnum
    private String taxpayerCode;  //纳税人识别号
    private String title;  //收票公司
    private String address;  //地址
    private String tel;  //电话
    private String openAccountBank;  //开户银行
    private String accountCode;  //银行账户号
    private Date createTime;
    private Date updateTime;

}

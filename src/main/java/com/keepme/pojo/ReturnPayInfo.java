package com.keepme.pojo;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * Created by yanghailong on 2017/9/29.
 */
@Data
@NoArgsConstructor
public class ReturnPayInfo extends Pojo {

    private Integer id;  //
    private Date createTime;  //创建时间
    private Date updateTime;  //修改时间
    private Integer customerId;  //统计单位ID
    private String customerName;  //统计单位名称
    private Date transactTime;  //交易时间
    private Double payMoney;  //支出
    private Double returnMoney;  //收入
    private Double surplusMoney;  //余额
    private String currency;  //币种
    private String accountName;  //对方户名
    private String account;  //对方账号
    private String openAccountInstitutions;  //对方开户机构
    private Date bankRecordTime;  //记账日期
    private String abstracts;  //摘要
    private String remark;  //备注
    private String serialNumber;  //账户明细编号-交易流水号
    private String voucherSpecies;  //凭证种类
    private String voucherCode;  //凭证号'
    
}

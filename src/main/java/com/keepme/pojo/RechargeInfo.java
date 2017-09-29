package com.keepme.pojo;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * Created by yanghailong on 2017/9/29.
 */
@Data
@NoArgsConstructor
public class RechargeInfo extends Pojo {

    private Integer id;  //
    private Date createTime;  //创建时间
    private Date updateTime;  //修改时间
    private Integer generalizeId;  //推广账户ID
    private String appId;  //APPID
    private Integer customerId;  //客户ID
    private String customerName;  //客户名称
    private Integer providerId;  //供应商ID
    private String providerName;  //供应商名称
    private Double ourRebates;  //我方返点
    private Double customerRebates;  //客户返点
    private Double accountRecharge;  //我方返点
    private Double rebatesRecharge;  //返点充值
    private Double rechargeCost;  //充值成本'
    
}

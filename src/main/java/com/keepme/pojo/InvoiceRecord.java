package com.keepme.pojo;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * Created by yanghailong on 2017/9/29.
 */
@Data
@NoArgsConstructor
public class InvoiceRecord extends Pojo {

    private Integer id;  //
    private Date createTime;  //创建时间
    private Date updateTime;  //修改时间
    private Integer invoiceInfoId;  //发票信息表ID
    private String type;  //销售发票|媒介发票
    private String applyName;  //申请人姓名
    private Integer customerId;  //'客户ID
    private String customerName;  //客户名称
    private Double money;  //金额
    private String platform;  //投放平台
    private Date payTime;  //费用发生日期
    private String invoiceCode;  //发票号
    private Date openTime;  //开票日期'


}

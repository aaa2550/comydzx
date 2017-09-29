package com.keepme.pojo;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * Created by yanghailong on 2017/9/29.
 */
@Data
@NoArgsConstructor
public class ProviderContractInfo extends Pojo {

    private Integer id;  //
    private Date createTime;  //创建时间
    private Date updateTime;  //修改时间
    private String customerType;  //直客/子客
    private String businessType;  //业务类型
    private String contractCode;  //合同编号
    private String statisticsShortName;  //统计简称
    private String ourCompanyName;  //我方主体名称
    private Date contractStartTime;  //合同开始时间
    private Date contractEndTime;  //合同结束时间
    private Double rebates;  //返点
    private Integer orderfrom;  //账期（天）
    
}

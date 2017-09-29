package com.keepme.pojo;

import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Created by yanghailong on 2017/9/29.
 */
@Data
@NoArgsConstructor
public class RebatesInfo extends Pojo {
    
    private String id;  //
    private String createTime;  //创建时间
    private String updateTime;  //修改时间
    private String type;  //客户|供应商
    private String startTime;  //返点开始日期
    private String endTime;  //返点结束日期
    private String rebates;  //返点
    private String contractId;  //合同编号
    private String userId;  //操作人ID
    private String userName;  //操作人名称'
    
}

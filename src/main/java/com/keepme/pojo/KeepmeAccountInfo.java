package com.keepme.pojo;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * Created by yanghailong on 2017/9/29.
 */
@Data
@NoArgsConstructor
public class KeepmeAccountInfo extends Pojo {

    private Integer id;  //
    private Date createTime;  //创建时间
    private Date updateTime;  //修改时间
    private String appId;  //APPID
    private String platform;  //投放平台
    private String keepmeAccountName;  //账户名称
    private String keepmeAccountId;  //'账户ID
    private Integer providerId;  //供应商ID
    private String providerName;  //供应商名称
    private String qq;  //绑定QQ
    private String industry;  //行业
    private String generalizeLink;  //推广链接
    private String services;  //feed/分包/oCPA/DMP/联盟屏蔽/oCP留存/oCP订单
    private String subpackage;  //分包
    private String ocpa;  //ocpa
    private String passStatus;  //通过状态 未审核 已通过 未通过
    private Date passTime;  //通过时间'
    
}

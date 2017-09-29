package com.keepme.pojo;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * Created by yanghailong on 2017/9/29.
 */
@Data
@NoArgsConstructor
public class CustomerInfo extends Pojo {
    
    private Integer id;
    private Date createTime;   //创建时间
    private Date updateTime;   //修改时间
    private String companyName;    //公司全称
    private String type;    //类型
    private String name;    //公司简称
    private String province;    //省份
    private String city;    //城市
    private String address; //地址
    private String linkmanName;    //联系人姓名
    private String linkmanTel; //联系人电话
    private String email;   //邮箱
    private String remark;  //备注

}

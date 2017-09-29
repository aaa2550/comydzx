package com.keepme.pojo;

import java.util.Date;

/**
 * 用户操作日志信息
 * @author shaoxiangfei
 *
 */
public class UserOperateLog extends Pojo {

    //操作用戶id
    private Integer operateUid;

    //用戶名
    private String operater;

    //用戶ip
    private String operateIp;

    //操作时间
    private Date operateTime;
    // 结束时间
    private Date endTime;

    //操作
    private String operation;

    //操作详情
    private String ext;

    public Integer getOperateUid() {
        return operateUid;
    }

    public void setOperateUid(Integer operateUid) {
        this.operateUid = operateUid;
    }

    public String getOperater() {
        return operater;
    }

    public void setOperater(String operater) {
        this.operater = operater;
    }

    public String getOperateIp() {
        return operateIp;
    }

    public void setOperateIp(String operateIp) {
        this.operateIp = operateIp;
    }

    public Date getOperateTime() {
        return operateTime;
    }

    public void setOperateTime(Date operateTime) {
        this.operateTime = operateTime;
    }

    public String getOperation() {
        return operation;
    }

    public void setOperation(String operation) {
        this.operation = operation;
    }

    public String getExt() {
        return ext;
    }

    public void setExt(String ext) {
        this.ext = ext;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

}

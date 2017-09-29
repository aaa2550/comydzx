package com.keepme.pojo;

/**
 * 角色
 * @author xieweibo
 *
 */
public class Role extends Pojo {

    private int id;
    private int pid;
    private String name;
    private String remark;
    private int seq = 100;
    private String rids;

    private String ridNames;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getPid() {
        return pid;
    }

    public void setPid(int pid) {
        this.pid = pid;
    }

    public String getRids() {
        return rids;
    }

    public void setRids(String rids) {
        this.rids = rids;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public int getSeq() {
        return seq;
    }

    public void setSeq(int seq) {
        this.seq = seq;
    }

    public String getRidNames() {
        return ridNames;
    }

    public void setRidNames(String ridNames) {
        this.ridNames = ridNames;
    }

}

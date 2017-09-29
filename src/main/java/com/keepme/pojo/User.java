package com.keepme.pojo;

import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.Set;

/**
 * 用户表
 * @author xieweibo
 *
 */
public class User extends Pojo {

    private int uid;
    private String name;
    private String pwd;
    private String loginIp;
    private Date createTime;
    private Date modifyTime;
    // 角色ids，逗号隔开
    private String rids;
    // 公司
    private String company;

    private String code;

    private String nickname;

    private String roleNames;

    private Set<String> resources = Collections.emptySet();// 用户可以访问的资源地址列表

    private String language;
    private String area;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLoginIp() {
        return loginIp;
    }

    public void setLoginIp(String loginIp) {
        this.loginIp = loginIp;
    }

    public String getPwd() {
        return pwd;
    }

    public void setPwd(String pwd) {
        this.pwd = pwd;
    }

    public int getUid() {
        return uid;
    }

    public void setUid(int uid) {
        this.uid = uid;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getModifyTime() {
        return modifyTime;
    }

    public void setModifyTime(Date modifyTime) {
        this.modifyTime = modifyTime;
    }

    public String getRids() {
        return rids;
    }

    public void setRids(String rids) {
        this.rids = rids;
    }

    public Set<String> getResources() {
        return resources;
    }

    public void setResources(Set<String> resources) {
        this.resources = resources;
    }

    public String getNickname() {
        return nickname;
    }

    public String getCompany() {
        return company;
    }

    public void setCompany(String company) {
        this.company = company;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getRoleNames() {
        return roleNames;
    }

    public void setRoleNames(String roleNames) {
        this.roleNames = roleNames;
    }

    public boolean isSuperMan() {
        if (rids == null || rids.isEmpty())
            return false;
        return Arrays.asList(rids.split(",")).contains("1");
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

}

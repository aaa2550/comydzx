package com.keepme.service;

import com.google.common.collect.Maps;
import com.keepme.dao.RoleDao;
import com.keepme.pojo.Role;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class RoleService {

    @Resource
    private RoleDao roleDao;

    /**
     * 列出所有权限
     * @return
     */
    public List<Role> list() {
        return roleDao.list();
    }

    public void save(Role role) {
        if (role.getId() > 0)
            roleDao.update(role);
        else {
            int id = roleDao.save(role);
            role.setId(id);
        }
    }

    public void grant(Role role) {
        roleDao.grant(role);
    }

    public void delete(int id) {
        roleDao.delete(id);

    }

    public Role get(int id) {
        return roleDao.get(id);
    }

    public Map<Integer, String> getRoles() {
        List<Role> list = roleDao.list();
        Map<Integer, String> map = Maps.newHashMap();
        for (Role role : list) {
            map.put(role.getId(), role.getName());
        }
        return map;
    }
}

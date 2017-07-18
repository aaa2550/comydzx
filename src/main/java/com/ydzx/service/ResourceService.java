package com.ydzx.service;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import com.ydzx.dao.RoleDao;
import com.ydzx.dao.ResourceDao;
import com.ydzx.pojo.Resources;
import com.ydzx.pojo.User;
import com.ydzx.util.DataUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Service
public class ResourceService {

    @Resource
    private ResourceDao resourceDao;

    @Resource
    private RoleDao roleDao;

    public void addResource(Resources resources) {
        resourceDao.add(resources);
    }

    public Set<String> getUrlByIds(Set<Integer> ids) {
        if (DataUtil.isEmpty(ids))
            return Collections.emptySet();
        return resourceDao.getUrlByIds(ids);
    }

    // 获取资源id
    public Set<Integer> getResourceIds(String roleIds) {
        Set<Integer> set = Sets.newHashSet();
        List<String> list = roleDao.getResources(roleIds);
        for (String str : list) {
            if (DataUtil.isEmpty(str))
                continue;
            for (String id : str.split(",")) {
                set.add(DataUtil.toInt(id));
            }
        }
        return set;
    }

    public List<Resources> list() {
        return resourceDao.list();
    }

    public Map<Integer, String> getResources() {
        List<Resources> list = resourceDao.list();
        Map<Integer, String> map = Maps.newHashMap();
        for (Resources r : list) {
            map.put(r.getId(), r.getName());
        }
        return map;
    }

    public List<Resources> listByUser(User user) {
        if (user == null)
            return Collections.emptyList();
        if (DataUtil.isEmpty(user.getRids()))
            return Collections.emptyList();
        if (user.isSuperMan()) {
            return resourceDao.listMenu();
        } else {
            Set<Integer> ids = getResourceIds(user.getRids());
            if (ids == null || ids.isEmpty()) {
                return Lists.newArrayList();
            }
            return resourceDao.listMenu(ids);
        }
    }

    public Resources get(int id) {
        return resourceDao.get(id);
    }

    public int edit(Resources resource) {
        return resourceDao.edit(resource);
    }

    public int delete(int id) {
        return resourceDao.delete(id);
    }

    public int add(Resources resources) {
        return resourceDao.add(resources);
    }

}

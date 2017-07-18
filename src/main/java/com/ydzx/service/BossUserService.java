package com.ydzx.service;

import com.ydzx.cache.CacheManager;
import com.ydzx.commons.Consts;
import com.ydzx.dao.UserDao;
import com.ydzx.pojo.DataGrid;
import com.ydzx.pojo.PageUnder;
import com.ydzx.pojo.User;
import com.ydzx.util.DataUtil;
import com.ydzx.util.MD5Util;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Set;

@Service
public class BossUserService {

    @Resource
    private UserDao userDao;

    @Resource
    private ResourceService resourceService;

    /**
     * 添加用户
     * 
     * @param user
     */
    public void add(User user) {
        if (DataUtil.isEmpty(user.getPwd()))
            user.setPwd(null);
        else
            user.setPwd(generatePwd(user));
        int uid = userDao.add(user);
        user.setUid(uid);
    }

    public String generatePwd(User user) {
        return MD5Util.getMD5(user.getName() + Consts.API_SECRET + user.getPwd());
    }

    public int delete(int id) {
        return userDao.delete(id);
    }

    public int delete(List<Integer> uids) {
        return userDao.delete(uids);
    }

    public DataGrid<User> search(String name, String start, String end, String rids, PageUnder pager) {
        int count = userDao.countSearch(name, start, end, rids);
        DataGrid<User> data = new DataGrid<User>();
        data.setTotal(count);
        data.setRows(userDao.search(name, start, end, rids, pager));
        return data;
    }

    public List<User> search(String name, String start, String end, String rids) {
        PageUnder pager = new PageUnder();
        pager.setOrder("name");
        pager.setRows(Integer.MAX_VALUE);
        return userDao.search(name, start, end, rids, pager);
    }

    /**
     * 获得用户对象
     * 
     * @param uid
     * @return
     */
    public User get(int uid) {
        return userDao.getUser(uid);
    }

    /**
     * 根据用户名字，和邮箱系统对接,name 即为email
     * @param name
     * @return
     */
    public User getUserByName(String name) {
        String key = Consts.LOGIN + name;
        User u = (User)CacheManager.get(key);
        if (u == null) {
            u = userDao.getUserByName(name);
            if (u != null) {
                if (!DataUtil.isEmpty(u.getRids())) { // 非超管
                    Set<Integer> resourceIds = resourceService.getResourceIds(u.getRids());
                    Set<String> resources = resourceService.getUrlByIds(resourceIds);
                    u.setResources(resources);
                }
                CacheManager.set(key, u);
            }
        }
        return u;

    }

    public int grant(User user) {
        int i = userDao.grant(user);
        CacheManager.delete(Consts.LOGIN + get(user.getUid()).getName());
        return i;
    }

    /**
     * 给角色授权时，清空用户缓存cache
     * @param rid
     */
    public void clearCacheByRid(int rid) {
        String r = "%," + rid + ",%";
        List<String> names = userDao.getNamesByRid(r);
        for (String name : names) {
            CacheManager.delete(Consts.LOGIN + name);
        }
    }

}

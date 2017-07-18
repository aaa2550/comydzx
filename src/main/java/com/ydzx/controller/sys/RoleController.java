package com.ydzx.controller.sys;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import com.ydzx.controller.BaseController;
import com.ydzx.pojo.CodeMsg;
import com.ydzx.pojo.Role;
import com.ydzx.pojo.Tree;
import com.ydzx.pojo.User;
import com.ydzx.service.BossUserService;
import com.ydzx.service.ResourceService;
import com.ydzx.service.RoleService;
import com.ydzx.util.DataUtil;
import jdk.nashorn.internal.runtime.GlobalConstants;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.google.common.collect.Lists;
import sun.security.util.KeyUtil;

@RequestMapping("/role")
@Controller
public class RoleController extends BaseController {

    @Resource
    private ResourceService resourceService;
    @Resource
    private RoleService roleService;
    @Resource
    private BossUserService userService;

    @RequestMapping("")
    public String role(final HttpServletRequest request) {
        this.getLoginUser(request);
        return "sys/role";
    }

    @RequestMapping("/list.json")
    @ResponseBody
    public List<Role> list() {
        List<Role> list = roleService.list();
        Map<Integer, String> resources = resourceService.getResources();
        for (Role r : list) {
            List<Integer> rids = DataUtil.asIntListGtZero(r.getRids());
            r.setRidNames((DataUtil.getValues(rids, resources)));
        }
        return list;
    }

    @RequestMapping("/tree")
    @ResponseBody
    public List<Tree> tree() {
        List<Role> roles = roleService.list();
        List<Tree> lt = Lists.newArrayList();
        for (Role role : roles) {
            Tree tree = new Tree();
            tree.setId(role.getId());
            tree.setPid(role.getPid());
            tree.setText(role.getName());
            tree.setIconCls("status_online");
            lt.add(tree);
        }
        return lt;
    }

    @RequestMapping("/{op}_page")
    public String editPage(final HttpServletRequest request, @RequestParam(defaultValue = "0") int id,
            @PathVariable String op) {
        Role r = id > 0 ? roleService.get(id) : new Role();
        request.setAttribute("role", r);

        return "sys/role_" + op;
    }

    @RequestMapping("/edit.json")
    @ResponseBody
    public CodeMsg edit(Role role, @RequestAttribute(value = "sessionInfo") User user) {
        roleService.save(role);
        userLog(user, "更改权限", role.toString());
        return CodeMsg.SUCCESS;
    }

    @RequestMapping("/grant.json")
    @ResponseBody
    public CodeMsg grant(Role role, @RequestAttribute(value = "sessionInfo") User user) {
        roleService.grant(role);
        // 清空用户缓存，角色授权及时生效
        userService.clearCacheByRid(role.getId());
        userLog(user, "更改菜单授权", role.toString());
        return CodeMsg.SUCCESS;
    }

    @RequestMapping("/delete.json")
    @ResponseBody
    public CodeMsg delete(final HttpServletRequest request, int id) {
        roleService.delete(id);
        this.userLog(request, request.getRequestURI(), "delete role id=" + id);
        return CodeMsg.SUCCESS;
    }
}

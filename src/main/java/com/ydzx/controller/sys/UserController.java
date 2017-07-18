package com.ydzx.controller.sys;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ydzx.controller.BaseController;
import com.ydzx.pojo.CodeMsg;
import com.ydzx.pojo.DataGrid;
import com.ydzx.pojo.PageUnder;
import com.ydzx.pojo.User;
import com.ydzx.service.BossUserService;
import com.ydzx.service.ResourceService;
import com.ydzx.service.RoleService;
import com.ydzx.util.DataUtil;
import jdk.nashorn.internal.runtime.GlobalConstants;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import sun.security.util.KeyUtil;

@Controller
@RequestMapping("/user")
public class UserController extends BaseController {
    @Resource
    private BossUserService userService;
    @Resource
    private RoleService roleService;

    @RequestMapping("")
    public String user(final HttpServletRequest request) {
        this.getLoginUser(request);
        request.setAttribute("roles", roleService.getRoles());
        return "sys/user";
    }

    @RequestMapping("/list.json")
    @ResponseBody
    public DataGrid<User> list(String name, String start, String end, String rid, @ModelAttribute PageUnder pager) {
        if (DataUtil.isEmpty(name)) {
            name = null;
        } else {
            name = "%" + name + "%";
        }
        DataGrid<User> grid = userService.search(name, DataUtil.emptyToNull(start), DataUtil.emptyToNull(end), DataUtil.emptyToNull(rid), pager);
        List<User> users = grid.getRows();
        Map<Integer, String> roles = roleService.getRoles();
        for (User u : users) {
            List<Integer> rids = DataUtil.asIntListGtZero(u.getRids());
            u.setRoleNames(DataUtil.getValues(rids, roles));
        }
        return grid;
    }

    @RequestMapping("add")
    public String add() {
        return "sys/user_add";
    }

    @RequestMapping("add.json")
    @ResponseBody
    public CodeMsg addJ(User user) {

        userService.add(user);
        return CodeMsg.SUCCESS;
    }

    @RequestMapping("/delete.json")
    @ResponseBody
    public CodeMsg delete(@RequestParam List<Integer> ids) {
        userService.delete(ids);
        return CodeMsg.SUCCESS;
    }

    @RequestMapping("/grant_page")
    public String grantPage(int id, HttpServletRequest request) {
        User u = userService.get(id);
        request.setAttribute("user", u);
        return "/sys/user_grant";
    }

    @RequestMapping("/grant.json")
    @ResponseBody
    public CodeMsg grant(@ModelAttribute User user, final HttpServletRequest request) {
        if (user.isSuperMan()) {
            if (!getLoginUser(request).isSuperMan()) {
                return new CodeMsg(1, "您不是超管，不能赋予超管的权限！");
            }
        }
        userService.grant(user);
        this.userLog(request, "用户授权", "UID " + user.getUid() + " --> " + user.getRids());
        return CodeMsg.SUCCESS;
    }

    @RequestMapping("/exportexcel.do")
    @ResponseBody
    public void exportexcel(String name, String start, String end, String rid,
                            final HttpServletRequest request, final HttpServletResponse response) {
        if (DataUtil.isEmpty(name)) {
            name = null;
        } else {
            name = "%" + name + "%";
        }
        List<User> list = userService.search(name, DataUtil.emptyToNull(start), DataUtil.emptyToNull(end), DataUtil.emptyToNull(rid));
        Map<Integer, String> roles = roleService.getRoles();
        for (User u : list) {
            List<Integer> rids = DataUtil.asIntListGtZero(u.getRids());
            u.setRoleNames(DataUtil.getValues(rids, roles));
        }
        this.userLog(request, request.getRequestURI(), request.getParameter("info"));
    }

}

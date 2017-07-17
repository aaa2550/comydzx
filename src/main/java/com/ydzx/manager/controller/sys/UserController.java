package com.ydzx.manager.controller.sys;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jmind.core.poi.Excel;
import jmind.core.poi.PoiExportUtil;
import jmind.core.util.CollectionsUtil;
import jmind.core.util.DataUtil;
import jmind.core.util.GlobalConstants;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.letv.boss.controller.BaseController;
import com.letv.boss.core.sys.service.BossUserService;
import com.letv.boss.core.sys.service.ResourceService;
import com.letv.boss.core.sys.service.RoleService;
import com.letv.boss.pojo.CodeMsg;
import com.letv.boss.pojo.User;
import com.letv.boss.pojo.pager.DataGrid;
import com.letv.boss.pojo.pager.PageUnder;
import com.letv.commons.util.KeyUtil;
import com.letv.commons.util.Objects;

@Controller
@RequestMapping("/user")
public class UserController extends BaseController {
    @Resource
    private BossUserService userService;
    @Resource
    private RoleService roleService;
    @Resource
    private ResourceService resourceService;

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
        DataGrid<User> grid = userService.search(name, Objects.emptyToNull(start), Objects.emptyToNull(end), Objects.emptyToNull(rid), pager);
        List<User> users = grid.getRows();
        Map<Integer, String> roles = roleService.getRoles();
        for (User u : users) {
            List<Integer> rids = CollectionsUtil.asIntListGtZero(u.getRids(), GlobalConstants.COMMA);
            u.setRoleNames(KeyUtil.getValues(rids, roles));
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
        List<User> list = userService.search(name, Objects.emptyToNull(start), Objects.emptyToNull(end), Objects.emptyToNull(rid));
        Map<Integer, String> roles = roleService.getRoles();
        for (User u : list) {
            List<Integer> rids = CollectionsUtil.asIntListGtZero(u.getRids(), GlobalConstants.COMMA);
            u.setRoleNames(KeyUtil.getValues(rids, roles));
        }

        String[] headers = { "登录名", "姓名", "创建时间", "最后修改时间", "角色"};
        String[] methods = { "getName", "getNickname", "getCreateTime", "getModifyTime", "getRoleNames"};
        String fileName = "users";
        PoiExportUtil.export(request, response, fileName, Excel.Version.xlsx, fileName, list, headers, methods);
        this.userLog(request, request.getRequestURI(), request.getParameter("info"));
    }

}

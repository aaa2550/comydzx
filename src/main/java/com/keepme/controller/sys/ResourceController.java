package com.keepme.controller.sys;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import com.keepme.pojo.Tree;
import com.keepme.service.ResourceService;
import com.keepme.util.RequestUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.collect.Lists;
import com.keepme.controller.BaseController;
import com.keepme.pojo.CodeMsg;
import com.keepme.pojo.Resources;
import com.keepme.pojo.User;

@Controller
@RequestMapping("/sys")
public class ResourceController extends BaseController {

    @Resource
    private ResourceService resourceService;

    @RequestMapping("")
    public String resource(final HttpServletRequest request) {
        getLoginUser(request);
        return "sys/resource";
    }

    @RequestMapping("/tree")
    @ResponseBody
    public List<Tree> tree(final HttpServletRequest request) {
        List<Resources> list;
        if ("all".equals(request.getParameter("t"))) {
            list = resourceService.list();
        } else {
            User user = getLoginUser(request);
            list = resourceService.listByUser(user);
        }
        List<Tree> trees = Lists.newArrayListWithExpectedSize(list.size());
        for (Resources r : list) {
            Tree tree = new Tree();
            tree.setId(r.getId());
            tree.setPid(r.getPid());
            tree.setText(r.getName());
            tree.setIconCls(r.getIconCls());
            Map<String, Object> attr = new HashMap<>();
            attr.put("url", r.getUrl());
            tree.setAttributes(attr);
            trees.add(tree);
        }
        return trees;
    }

    @RequestMapping("/list.json")
    @ResponseBody
    public List<Resources> list(final HttpServletRequest request) {
        this.getLoginUser(request);
        return resourceService.list();
    }

    @RequestMapping("edit_page")
    public String editPage(HttpServletRequest request, @RequestParam(defaultValue = "0") int id) {
        Resources r;
        if (id > 0) {
            r = resourceService.get(id);
        } else {
            r = new Resources();
        }
        request.setAttribute("resource", r);
        return "/sys/resource_edit";
    }

    @RequestMapping("edit.json")
    @ResponseBody
    public CodeMsg edit(HttpServletRequest request, Resources resources) {
        if (resources.getId() > 0)
            resourceService.edit(resources);
        else
            resourceService.add(resources);
        this.userLog(request, "修改菜单", RequestUtil.getParameterMap(request).toString());
        return CodeMsg.SUCCESS;
    }

    @RequestMapping("delete.json")
    @ResponseBody
    public CodeMsg delete(int id, @RequestAttribute(value = "sessionInfo") User user) {
        Resources resources = resourceService.get(id);
        resourceService.delete(id);
        this.userLog(user, "删除菜单", resources.toString());
        return CodeMsg.SUCCESS;
    }
}

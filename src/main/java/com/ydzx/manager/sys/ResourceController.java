package com.ydzx.manager.sys;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import com.letv.commons.annotation.RequestAttribute;
import jmind.core.util.DataUtil;
import jmind.core.util.RequestUtil;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.collect.Lists;
import com.letv.boss.controller.BaseController;
import com.letv.boss.core.sys.service.ResourceService;
import com.letv.boss.enums.Language;
import com.letv.boss.helper.LoginHelper;
import com.letv.boss.pojo.CodeMsg;
import com.letv.boss.pojo.Resources;
import com.letv.boss.pojo.Tree;
import com.letv.boss.pojo.User;
import com.letv.commons.util.InternationalUtil;

@Controller
@RequestMapping("/sys")
public class ResourceController extends BaseController {

    @Resource
    private ResourceService resourceService;

    @RequestMapping("")
    public String resource(final HttpServletRequest request) {
        this.getLoginUser(request);
        return "sys/resource";
    }

    @RequestMapping("/tree")
    @ResponseBody
    public List<Tree> tree(final HttpServletRequest request) {
        List<Resources> list;
        if ("all".equals(request.getParameter("t"))) {
            list = resourceService.list();
        } else {
            User user = this.getLoginUser(request);
            list = resourceService.listByUser(user);
        }
        Language language = LoginHelper.getLanguage(request);
        List<Tree> trees = Lists.newArrayListWithExpectedSize(list.size());
        for (Resources r : list) {
            Tree tree = new Tree();
            tree.setId(r.getId());
            tree.setPid(r.getPid());
            if (language == Language.en) {
                tree.setText(DataUtil.isEmpty(r.getNameEn()) ? r.getName() : r.getNameEn());
            } else if (language == Language.zh_hk) {
                tree.setText(InternationalUtil.INSTANCE.getZhHK(r.getName()));
            } else {
                tree.setText(r.getName());
            }

            tree.setIconCls(r.getIconCls());
            Map<String, Object> attr = new HashMap<String, Object>();
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
        List<Resources> list = resourceService.list();
        Language language = LoginHelper.getLanguage(request);
        if (language == Language.en) {
            for (Resources r : list) {
                if (!DataUtil.isEmpty(r.getNameEn()))
                    r.setName(r.getNameEn());
            }
        } else if (language == Language.zh_hk) {
            for (Resources r : list) {
                r.setName(InternationalUtil.INSTANCE.getZhHK(r.getName()));
            }
        }
        return list;
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
    public CodeMsg delete(int id, @RequestAttribute(value = "sessionInfo", notNull = true) User user) {
        Resources resources = resourceService.get(id);
        resourceService.delete(id);
        this.userLog(user, "删除菜单", resources.toString());
        return CodeMsg.SUCCESS;
    }
}

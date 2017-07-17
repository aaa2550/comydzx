package com.ydzx.manager.controller;

import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jmind.core.util.DataUtil;
import jmind.core.util.IpUtil;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.letv.boss.LetvEnv;
import com.letv.boss.core.sys.service.BossUserService;
import com.letv.boss.core.sys.service.ResourceService;
import com.letv.boss.core.v2.product.service.VipPackageForThirdService;
import com.letv.boss.enums.CodeType;
import com.letv.boss.helper.LoginHelper;
import com.letv.boss.pojo.CodeMsg;
import com.letv.boss.pojo.User;
import com.letv.commons.cache.XMemcached;
import com.letv.commons.util.LDAPUtil;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController extends BaseController {

    @Resource
    private BossUserService userService;
    @Resource
    private ResourceService resourceService;

    @Resource
    private VipPackageForThirdService vipPackageForThirdService;

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String home(Locale locale, Model model, final HttpServletRequest request) {
        this.getLoginUser(request);

        return "home";
    }

    @RequestMapping("/login")
    @ResponseBody
    public CodeMsg login(User user, final HttpServletRequest request, final HttpServletResponse response) {
        if (DataUtil.isEmpty(user.getName(), user.getPwd())) {
            return CodeMsg.ERROR;
        }
        int a = user.getName().indexOf("@");
        if (a > 0) {
            user.setName(user.getName().substring(0, a));
        }

        if (!LetvEnv.isTest()) { // 生产环境需要验证码
            String code = XMemcached.getKaptcha(request);
            if (!isValidKapcha(code, user.getCode())) {
                CodeMsg msg = new CodeMsg(CodeType.CODE_INVALID);
                return msg;
            }
        }
        User u = userService.getUserByName(user.getName());

        if (u != null && !DataUtil.isEmpty(u.getPwd())) { // 为了兼容自创用户，比如国广用户
            if (userService.generatePwd(user).equals(u.getPwd())) {
                LoginHelper.login(user, request, response);
                this.userLog(user, "用户登录", user.getNickname());
                return CodeMsg.SUCCESS;
            }
        }

        CodeMsg verify = LDAPUtil.verify(user);
        if (verify.isSuccess()) {
            if (u == null) {
                u = new User();
                u.setName(user.getName());
                u.setNickname(user.getNickname());
                u.setCompany(user.getCompany());
                userService.add(u);
            }
            LoginHelper.login(user, request, response);
            user.setLoginIp(IpUtil.getIp(request));
            this.userLog(user, "用户登录", user.getNickname());
        }
        return verify;

    }

    private boolean isValidKapcha(String src, String input) {
        if (DataUtil.isEmpty(src) || DataUtil.isEmpty(input) || src.length() != input.length())
            return false;
        char[] srcChars = src.toCharArray();
        char[] inputChars = input.toCharArray();
        for (int i = 0; i < srcChars.length; i++) {
            char srcChar = srcChars[i];
            char inputChar = inputChars[i];
            if (srcChar == inputChar || Character.toUpperCase(srcChar) == Character.toUpperCase(inputChar))
                continue;
            switch (srcChar) {
                case '1':
                case 'I':
                case 'l': {
                    // 验证码是1, I, l的情况下容易混淆，i和L则不会有此情况
                    if (inputChar != '1' && inputChar != 'I' && inputChar != 'i' && inputChar != 'L' && inputChar != 'l')
                        return false;
                    break;
                }
                case '0':
                case 'o':
                case 'O': {
                    if (inputChar != '0' && inputChar != 'o' && inputChar != 'O')
                        return false;
                    break;
                }
                default:
                    return false;
            }
        }
        return true;
    }

    @RequestMapping("/logout")
    @ResponseBody
    public CodeMsg logout(final HttpServletRequest request, final HttpServletResponse response) {
        LoginHelper.logout(request, response);
        return CodeMsg.SUCCESS;
    }

    @RequestMapping("/page/{path}")
    public String page(@PathVariable String path) {
        return "page/" + path;
    }

    @RequestMapping("/layout/{path}")
    public String layout(@PathVariable String path, final HttpServletRequest request) {
        this.getLoginUser(request);

        return "layout/" + path;
    }

    @RequestMapping("/ok")
    @ResponseBody
    public String ok(final HttpServletRequest request) {
        String s = "r=" + request.getHeader("Referer") + "ua=" + request.getHeader("User-Agent") + "ip="
                + IpUtil.getIp(request);
        return "ok" + LetvEnv.getEnvironment() + "------" + IpUtil.getLocalIP() + "---------"
                + IpUtil.getLocalAddress() + "," + s;

    }

    @RequestMapping("/vipPackageForThird")
    @ResponseBody
    public CodeMsg vipPackageForThird() {
        long time = vipPackageForThirdService.spreadContent2vip();
        CodeMsg code = new CodeMsg();
        code.setData(time);
        return code;
    }

}

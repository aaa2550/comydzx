package com.keepme.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.keepme.commons.Environment;
import com.keepme.commons.LoginHelper;
import com.keepme.pojo.CodeMsg;
import com.keepme.pojo.User;
import com.keepme.service.BossUserService;
import com.keepme.util.DataUtil;
import com.keepme.util.IPUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController extends BaseController {

    @Resource
    private BossUserService userService;

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String home(HttpServletRequest request) {
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

        User u = userService.getUserByName(user.getName());

        if (u != null && !DataUtil.isEmpty(u.getPwd())) { // 为了兼容自创用户，比如国广用户
            if (userService.generatePwd(user).equals(u.getPwd())) {
                LoginHelper.login(user, request, response);
                this.userLog(user, "用户登录", user.getNickname());
                return CodeMsg.SUCCESS;
            } else {

            }
        }
        return CodeMsg.ERROR;

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
                + IPUtil.getRequestIP(request);
        return "ok" + Environment.getEnvironment() + "------" + IPUtil.getLocalIP() + "---------"
                + IPUtil.getRequestIP(request) + "," + s;

    }

}

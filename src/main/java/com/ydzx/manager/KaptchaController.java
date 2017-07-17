package com.ydzx.manager;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jmind.core.lang.Pair;
import jmind.core.util.CookieUtil;
import jmind.core.util.DataUtil;
import jmind.core.util.GlobalConstants;
import jmind.core.util.RandUtil;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.code.kaptcha.Producer;
import com.letv.commons.cache.XMemcached;

/**
 * 验证码控制器
 * @author wbxie
 * 2013-7-23
 */
@Controller
public class KaptchaController extends BaseController {

    private Producer captchaProducer = null;

    @Autowired
    public void setCaptchaProducer(final Producer captchaProducer) {
        this.captchaProducer = captchaProducer;
    }

    @RequestMapping(value = "/kaptcha", method = RequestMethod.GET)
    public ModelAndView handleRequest(final HttpServletRequest request, final HttpServletResponse response)
            throws Exception {
        // Set to expire far in the past.
        response.setDateHeader("Expires", 0);
        // Set standard HTTP/1.1 no-cache headers.
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        // Set IE extended HTTP/1.1 no-cache headers (use addHeader).
        response.addHeader("Cache-Control", "post-check=0, pre-check=0");
        // Set standard HTTP/1.0 no-cache header.
        response.setHeader("Pragma", "no-cache");

        // return a jpeg
        response.setContentType("image/jpeg");

        // create the text for the image
        final String capText = captchaProducer.createText();

        // store the text in the session
        //request.getSession().setAttribute(Constants.KAPTCHA_SESSION_KEY, capText);
        //modify by yake, set in memcached
        //   final CookieUtil cookieUtil = new CookieUtil(request, response);
        String uuid = CookieUtil.getUUIDCookie(request, response);
        XMemcached.set(XMemcached.KAPTCHA + uuid, GlobalConstants.MINUTE * 3, capText);
        // create the image with the text
        final BufferedImage bi = captchaProducer.createImage(capText);

        final ServletOutputStream out = response.getOutputStream();

        // write the data out
        ImageIO.write(bi, "jpg", out);
        try {
            out.flush();
        } finally {
            out.close();
        }
        return null;
    }

    @RequestMapping("getcode")
    @ResponseBody
    public String getCode(@RequestParam(defaultValue = "") String uuid) {
        if (uuid.isEmpty())
            return DataUtil.EMPTY;
        return XMemcached.get(XMemcached.KAPTCHA + uuid);
    }

    @RequestMapping(value = "/mcode", method = RequestMethod.GET)
    public void mathCode(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
        response.setContentType("image/jpeg");
        response.addHeader("pragma", "NO-cache");
        response.addHeader("Cache-Control", "no-cache");
        response.addDateHeader("Expries", 0);
        int width = 110, height = 30;
        BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        Graphics g = image.getGraphics();
        //以下填充背景颜色
        // g.setColor(getRandColor(240,242));
        g.fillRect(0, 0, width, height);
        //设置字体颜色
        //g.setColor(getRandColor(220,250));
        g.setColor(Color.black);
        g.setFont(new Font("Roman", Font.ROMAN_BASELINE, 22));

        g.setColor(RandUtil.getRandColor(100, 160));

        // 随机产生10条干扰线，使图象中的认证码不易被其它程序探测到
        for (int i = 0; i < 50; i++) {
            int x = RandUtil.nextInt(width);
            int y = RandUtil.nextInt(height);
            int xl = RandUtil.nextInt(12);
            int yl = RandUtil.nextInt(12);
            g.drawLine(x, y, x + xl, y + yl);
        }
        Pair<String, Integer> p = RandUtil.mathVCode();
        String uuid = CookieUtil.getUUIDCookie(request, response);

        XMemcached.set(XMemcached.KAPTCHA + uuid, GlobalConstants.MINUTE * 3, p.getSecond().toString());
        g.drawString(p.getFirst(), 4, 25);
        g.dispose();
        final ServletOutputStream out = response.getOutputStream();

        // write the data out
        ImageIO.write(image, "jpeg", out);
        try {
            out.flush();
        } finally {
            out.close();
        }

    }

    private int width = 90;// 定义图片的width
    private int height = 20;// 定义图片的height

    private int xx = 15;
    private int fontHeight = 18;
    private int codeY = 16;

    @RequestMapping("/code")
    public void code(HttpServletRequest request, HttpServletResponse response, @RequestParam(defaultValue = "4") int len)
            throws IOException {

        // 定义图像buffer
        BufferedImage buffImg = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        // Graphics2D gd = buffImg.createGraphics();
        // Graphics2D gd = (Graphics2D) buffImg.getGraphics();
        Graphics gd = buffImg.getGraphics();
        // 创建一个随机数生成器类

        // 将图像填充为白色
        gd.setColor(Color.WHITE);
        gd.fillRect(0, 0, width, height);

        // 创建字体，字体的大小应该根据图片的高度来定。
        Font font = new Font("Fixedsys", Font.BOLD, fontHeight);
        // 设置字体。
        gd.setFont(font);

        // 画边框。
        gd.setColor(Color.BLACK);
        gd.drawRect(0, 0, width - 1, height - 1);

        // 随机产生40条干扰线，使图象中的认证码不易被其它程序探测到。
        gd.setColor(Color.BLACK);
        for (int i = 0; i < 20; i++) {
            int x = RandUtil.nextInt(width);
            int y = RandUtil.nextInt(height);
            int xl = RandUtil.nextInt(12);
            int yl = RandUtil.nextInt(12);
            gd.drawLine(x, y, x + xl, y + yl);
        }

        // randomCode用于保存随机产生的验证码，以便用户登录后进行验证。
        String randomCode = RandUtil.randomCode(len, true);
        int red = 0, green = 0, blue = 0;

        // 随机产生codeCount数字的验证码。
        for (int i = 0; i < len; i++) {
            // 产生随机的颜色分量来构造颜色值，这样输出的每位数字的颜色值都将不同。
            red = RandUtil.nextInt(255);
            green = RandUtil.nextInt(255);
            blue = RandUtil.nextInt(255);

            // 用随机产生的颜色将验证码绘制到图像中。
            gd.setColor(new Color(red, green, blue));
            gd.drawString(randomCode.charAt(i) + "", (i + 1) * xx, codeY);

        }

        String uuid = CookieUtil.getUUIDCookie(request, response);

        XMemcached.set(XMemcached.KAPTCHA + uuid, GlobalConstants.MINUTE * 3, randomCode);

        // 禁止图像缓存。
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Cache-Control", "no-cache");
        response.setDateHeader("Expires", 0);

        response.setContentType("image/jpeg");

        // 将图像输出到Servlet输出流中。
        ServletOutputStream sos = response.getOutputStream();
        ImageIO.write(buffImg, "jpeg", sos);
        sos.close();
    }

}
package com.ydzx.manager;

import com.letv.boss.core.log.service.UserOperateLogService;
import com.letv.boss.enums.Language;
import com.letv.boss.helper.LoginHelper;
import com.letv.boss.pojo.CodeMsg;
import com.letv.boss.pojo.User;
import com.letv.boss.pojo.UserOperateLog;
import com.letv.commons.util.InternationalUtil;
import com.letv.share.common.util.ObjectColumnsParser;
import com.letv.share.common.util.StrategyXlsxExcel;
import jmind.core.poi.Excel;
import jmind.core.util.FileUtil;
import jmind.core.util.GlobalConstants;
import jmind.core.util.RequestUtil;
import org.apache.poi.ss.usermodel.Workbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.List;

public class BaseController {

    @Resource
    private UserOperateLogService userOperateLogService;

    protected final Logger logger = LoggerFactory.getLogger(getClass());

    /**
     * 文件保存
     * @param myfile
     * @param file
     * @return
     */
    public File transferFile(MultipartFile myfile, String file) {
        File dest = new File(file);
        FileUtil.makeDir(dest.getParentFile());
        try {
            myfile.transferTo(dest);
        } catch (IllegalStateException e) {
            logger.error("transferFile error !", e);
        } catch (IOException e) {
            logger.error("transferFile error !", e);
        }
        // dest.getAbsolutePath()
        return dest;
    }

    /**
     * @deprecated
     * 推荐使用注入方式.
     * <pre> {@code
     *     public <T> method(@RequestAttribute("sessionInfo") User user){...}
     *}</pre>
     *
     */
    @Deprecated
    protected User getLoginUser(final HttpServletRequest request) {
        return LoginHelper.getLoginUser(request);
    }

    /**
     * @deprecated
     * 推荐使用注入方式.
     * <pre> {@code
     *     public <T> method(@RequestAttribute("sessionInfo") User user){
     *         String name = user.getName();
     *         ...
     *     }
     *}</pre>
     *
     */
    @Deprecated
    protected String getLoginName(final HttpServletRequest request) {
        return LoginHelper.getLoginUser(request).getName();
    }

    protected void userLog(final HttpServletRequest request, String operation, String ext) {
        try {
            User user = this.getLoginUser(request);
            UserOperateLog uol = new UserOperateLog();
            uol.setOperateUid(user.getUid());
            uol.setOperater(user.getName());
            uol.setOperateIp(user.getLoginIp());
            uol.setOperation(operation);
            uol.setExt(ext);
            this.userOperateLogService.addUserOperateLog(uol);

        } catch (Exception e) {
            logger.error("userLog error !", e);
        }
    }

    protected void userLog(User user, String operation, String ext) {
        try {
            UserOperateLog uol = new UserOperateLog();
            uol.setOperateUid(user.getUid());
            uol.setOperater(user.getName());
            uol.setOperateIp(user.getLoginIp());
            uol.setOperation(operation);
            uol.setExt(ext);
            this.userOperateLogService.addUserOperateLog(uol);

        } catch (Exception e) {
            logger.error("userLog error !", e);
        }
    }

    protected String language(String key, HttpServletRequest request) {
        Language language = LoginHelper.getLanguage(request);
        return InternationalUtil.INSTANCE.getInternationalConfig(language).get(key);
    }

    @ExceptionHandler(Throwable.class)
    public void handleException(Throwable e, final HttpServletRequest request, final HttpServletResponse response) {
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding(GlobalConstants.ENCODE);
        logger.error("Global-error url=" + RequestUtil.getURL(request), e);
        String msg = e.getMessage();
        String s;
        if ("Request attribute sessionInfo should not be null".equals(msg)) {
            // 如果是session过期，提示重新登录。（方式比较丑陋，但是不用改太多已有代码）
            s = new CodeMsg(1, "您还没有登录或登录已超时，请重新登录，然后再刷新本功能！").toString();
        } else {
            s = new CodeMsg(9999, e.getMessage()).toString();
        }
        try {
            request.setCharacterEncoding(GlobalConstants.ENCODE);
            response.getWriter().write(s);
        } catch (IOException e1) {
            e1.printStackTrace();

        }
        e.printStackTrace();
    }

    protected <T> void export(String title, List<T> list, HttpServletRequest request, HttpServletResponse response, ObjectColumnsParser<T> objectColumnsParser) {
		/*if (CollectionUtils.isEmpty(list)) {
			return;
		}*/
        export(request, response, title, Excel.Version.xlsx, title, list, objectColumnsParser);
    }

    public <T> void export(HttpServletRequest request, HttpServletResponse response, String fileName, Excel.Version version, String sheetName, List<T> list, ObjectColumnsParser<T> objectColumnsParser) {
        RequestUtil.setExcelHeader(fileName.replaceAll(" ", "_") + "." + version.name(), request, response);
        ServletOutputStream out = null;
        try {
            out = response.getOutputStream();
            Workbook e = new StrategyXlsxExcel().exportExcel(sheetName, list, objectColumnsParser);
            if(e != null) {
                e.write(out);
            }
        } catch (UnsupportedEncodingException var18) {
            throw new RuntimeException(var18);
        } catch (Exception var19) {
            throw new RuntimeException(var19);
        } finally {
            try {
                out.flush();
                out.close();
            } catch (Exception var17) {
                throw new RuntimeException(var17);
            }
        }

    }

}

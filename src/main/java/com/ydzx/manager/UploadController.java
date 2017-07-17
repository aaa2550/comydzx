package com.ydzx.manager;

import java.io.File;
import java.io.IOException;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jmind.core.util.DataUtil;
import jmind.core.util.DateUtil;
import jmind.core.util.FileUtil;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.alibaba.fastjson.JSONObject;
import com.letv.boss.Cibn;
import com.letv.boss.core.resource.service.FileStorageService;
import com.letv.boss.pojo.FileStorage;
import com.letv.commons.util.Consts;
import com.letv.commons.util.http.UploadLetvCdn;

/**
 * 
 * @author xieweibo
 *
 */
@Controller
public class UploadController extends BaseController {
    @Resource
    private FileStorageService fileStorageService;

    @RequestMapping(value = "/upload.do", method = RequestMethod.GET)
    public String fileSub(HttpServletRequest request, HttpServletResponse response) {
        return "/upload/file_submit";
    }

    /**
     *  <form id="form" action="/lecard/info_batch" method="post"
                enctype="multipart/form-data"  accept-charset="UTF-8" >
                accept-charset 可以保证接收的文件名含有中文，不出现乱码
     * @param myfile
     * @param path
     * @param cdn
     * @return
     */
    @RequestMapping(value = "/upload", method = RequestMethod.POST)
    @ResponseBody
    public String upload(MultipartFile myfile, String path, String cdn) {
        boolean isImage = isImage(myfile.getOriginalFilename());
        if (DataUtil.isEmpty(path)) {
            path = isImage ? Consts.UPLOAD_IMG : Consts.UPLOAD_FILE;
            path += DateUtil.getMonthDir();
        }
        String fileName = path + System.currentTimeMillis() + FileUtil.getFileType(myfile.getOriginalFilename());
        File file = super.transferFile(myfile, fileName);
        if ("sync".equals(cdn)) { // 同步到cdn
            String s = isImage ? Cibn.convertImg(UploadLetvCdn.uploadImage(file)) : UploadLetvCdn.uploadFile(file);
            return s;
        }
        return fileName;
    }

    @RequestMapping(value = "/upload.json", method = RequestMethod.POST)
    @ResponseBody
    public JSONObject uploadJSON(MultipartFile myfile, final MultipartHttpServletRequest request, String path,
            String cdn) {
        long size = myfile.getSize();
        int length = 0;
        try {
            length = myfile.getBytes().length;
        } catch (IOException e) {
            e.printStackTrace();
        }
        boolean isImage = myfile.getContentType().contains("image");
        if (DataUtil.isEmpty(path)) {
            path = isImage ? Consts.UPLOAD_IMG : Consts.UPLOAD_FILE;
            path += DateUtil.getMonthDir();
        }

        String fileName = path + System.currentTimeMillis() + FileUtil.getFileType(myfile.getOriginalFilename());
        String url = fileName;
        File file = super.transferFile(myfile, fileName);
        if ("sync".equals(cdn)) { // 同步到cdn
            url = isImage ?Cibn.convertImg(UploadLetvCdn.uploadImage(file)): UploadLetvCdn.uploadFile(file);

        }
        JSONObject jo = new JSONObject();
        jo.put("fileName", fileName);
        jo.put("url", url);
        jo.put("size", size);
        jo.put("length", length);
        return jo;
    }

    @RequestMapping("/get_storage")
    @ResponseBody
    public String getStorage(int storeId) {
        FileStorage store = fileStorageService.getStore(storeId);
        return new String(store.getStore());
    }

    private boolean isImage(String fileName) {
        fileName = fileName.toLowerCase();
        return fileName.endsWith("jpg") || fileName.endsWith("jpeg") || fileName.endsWith("png")
                || fileName.endsWith("bmp") || fileName.endsWith("gif");
    }
}

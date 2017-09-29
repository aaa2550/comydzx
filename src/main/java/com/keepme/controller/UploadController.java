package com.keepme.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.alibaba.fastjson.JSONObject;

/**
 * 
 * @author xieweibo
 *
 */
@Controller
public class UploadController extends BaseController {

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
        //return filename
        return null;
    }

    @RequestMapping(value = "/upload.json", method = RequestMethod.POST)
    @ResponseBody
    public JSONObject uploadJSON(MultipartFile myfile, final MultipartHttpServletRequest request, String path,
            String cdn) {

        return null;
    }

}

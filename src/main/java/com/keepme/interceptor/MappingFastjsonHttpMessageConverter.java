package com.keepme.interceptor;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.nio.charset.Charset;

import com.keepme.commons.Consts;

import org.springframework.http.HttpInputMessage;
import org.springframework.http.HttpOutputMessage;
import org.springframework.http.MediaType;
import org.springframework.http.converter.AbstractHttpMessageConverter;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.http.converter.HttpMessageNotWritableException;
import org.springframework.util.FileCopyUtils;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.serializer.SerializerFeature;

public class MappingFastjsonHttpMessageConverter extends AbstractHttpMessageConverter<Object> {

    public static final MediaType DEFAULT_TYPE = new MediaType("text", "plain", Charset.forName(Consts.ENCODE));

    public MappingFastjsonHttpMessageConverter() {
        super(DEFAULT_TYPE, MediaType.ALL);
    }

    @Override
    protected boolean supports(Class<?> clazz) {
        return true;
    }

    @Override
    public boolean canRead(Class<?> clazz, MediaType mediaType) {
        return true;
    }

    @Override
    public boolean canWrite(Class<?> clazz, MediaType mediaType) {
        return true;
    }

    /**
     * 只支持post的 对象传输， 当时get是，流里面读出的数据为空
     *
     * @RequestBody 走这里 ,
     * 参数用@ModelAttribute  既支持post  也支持get
     * 参数直接是pojo的属性
     */
    @Override
    protected Object readInternal(Class<? extends Object> clazz, HttpInputMessage inputMessage) throws IOException,
            HttpMessageNotReadableException {
        InputStream in = inputMessage.getBody();
        return JSON.parseObject(in, clazz);
    }

    /**
     * 这里最后执行，在拦截器之后执行
     */
    @Override
    protected void writeInternal(Object t, HttpOutputMessage outputMessage) throws IOException,
            HttpMessageNotWritableException {

        // 非常重要，设置页面展示编码
        outputMessage.getHeaders().setContentType(DEFAULT_TYPE);
        String s = JSON.toJSONString(t, SerializerFeature.DisableCircularReferenceDetect,
                SerializerFeature.WriteDateUseDateFormat);
        FileCopyUtils.copy(s, new OutputStreamWriter(outputMessage.getBody(), Consts.ENCODE));

    }
}

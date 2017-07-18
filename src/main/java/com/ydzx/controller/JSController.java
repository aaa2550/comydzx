package com.ydzx.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import com.letv.boss.core.props.service.*;
import com.letv.boss.core.resource.service.ChannelAssociationService;
import com.letv.boss.pojo.ChannelAssociation;
import com.letv.boss.pojo.props.*;
import jmind.core.lang.SourceProperties;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.google.common.base.Function;
import com.google.common.collect.Maps;
import com.letv.boss.core.operator.service.OperatorAccountService;
import com.letv.boss.core.product.service.IPackageService;
import com.letv.boss.core.resource.service.DictService;
import com.letv.boss.core.v2.product.service.VideoLiveService;
import com.letv.boss.core.v2.product.service.VipPackageService;
import com.letv.boss.enums.PackageConfigType;
import com.letv.boss.enums.Region;
import com.letv.boss.enums.VipCategory;
import com.letv.boss.helper.LoginHelper;
import com.letv.boss.pojo.SeasonLiveDic;
import com.letv.boss.pojo.rebate.RebateChannel;
import com.letv.boss.v2.product.VipPackageDuration;
import com.letv.boss.v2.product.VipPackageType;
import com.letv.share.rebate.service.RebateChannelService;

@Controller
@RequestMapping("/js")
public class JSController {
    @Resource
    private DictService dictService;
    @Resource
    private OperatorAccountService operatorAccountService;
    @Resource
    private IPackageService packageService;
    @Resource
    private RebateChannelService rebateChannelService;
    @Resource
    private VipPackageService vipPackageService;
    @Resource
    private VideoLiveService videoLiveService;
    @Resource
    private PropsService propsService;
    @Resource
    private PropsChannelService propsChannelService;
    @Resource
    private PropsTypeService propsTypeService;
    @Resource
    private PropsUnitService propsUnitService;
    @Resource
    private PropsPropertyService propsPropertyService;
    @Resource
    private PropsOperateTypeService propsOperateTypeService;
    @Resource
    private ChannelAssociationService channelAssociationService;

    @RequestMapping("/dict.js")
    @ResponseBody
    public String dict(final HttpServletRequest request) {
        StringBuilder sb = new StringBuilder();
        sb.append("var Dict=Dict ||{}; Dict.data=");
        sb.append(JSON.toJSONString(dictService.getDict(LoginHelper.getLanguage(request))));
        sb.append(";Dict.getName=function(category,code){ return Dict.data[category][code]};");
        return sb.toString();
    }

    @RequestMapping("/kv/{name}.js")
    @ResponseBody
    public String dictName(@PathVariable String name, final HttpServletRequest request) {
        int country = LoginHelper.getCountry(request);
        String r = null;
        String e = null;
        if ("operator".equals(name)) { // 所有运营商名字
            Map<Integer, String> map = operatorAccountService.getAllOperatorNames();
            r = JSON.toJSONString(map);
        } else if ("packages".equals(name)) { // 在线套餐类型
            Map<String, com.letv.boss.pojo.Package> pkMap = packageService.getLecardPackage();
            Map<String, String> map = Maps.transformValues(pkMap, new Function<com.letv.boss.pojo.Package, String>() {
                public String apply(com.letv.boss.pojo.Package input) {
                    return input.getPackageNameDesc();
                }
            });
            r = JSON.toJSONString(map);
        } else if ("vip".equals(name)) { // vip 类型
            Map<Integer, String> map = packageService.getPackageConfigDescByType(PackageConfigType.PACKAGE_NAME);
            r = JSON.toJSONString(map);
        } else if ("rebateChannel".equals(name)) {
            List<RebateChannel> list = rebateChannelService.getChannels();
            JSONObject jo = new JSONObject(true);
            for (RebateChannel channel : list) {
                jo.put(channel.getId() + "", channel.getName());
            }
            r = jo.toJSONString();
        } else if ("vipType".equals(name)) {
            List<VipPackageType> list = vipPackageService.getVipPackageType(country);
            JSONObject types = new JSONObject();
            for (VipPackageType t : list) {
                types.put(t.getId() + "", t.getName());
            }
            r = types.toJSONString();
        } else if ("vipCategory".equals(name)) {
            List<VipCategory> vipCategorys = VipCategory.getVipCategory(Region.findByCountry(country));
            SourceProperties internationalConfig = (SourceProperties) request.getAttribute("internationalConfig");
            JSONObject vc = new JSONObject();
            for (VipCategory vipCategory : vipCategorys) {
                vc.put(String.valueOf(vipCategory.getCategory()),internationalConfig.getProperty(vipCategory.getName(), vipCategory.getName()) );
            }
            r = vc.toJSONString();
        } else if ("vipDuration".equals(name)) {
            List<VipPackageDuration> list2 = vipPackageService.getVipPackageDuration(country);
            JSONObject jo = new JSONObject();
            for (VipPackageDuration type : list2) {
                HashMap<Object, Object> map = Maps.newHashMap();
                map.put("name", type.getDurationName());
                map.put("duration", type.getDuration());
                jo.put(type.getId() + "", map);
            }
            r = jo.toJSONString();
        } else if ("v2SeasonLiveDic".equals(name)) {
            List<SeasonLiveDic> list = videoLiveService.getSeasonDicAllList(country);
            JSONObject types = new JSONObject();
            for (SeasonLiveDic t : list) {
                types.put(t.getId() + "", t.getDescription());
            }
            r = types.toJSONString();
        }else if("propsBusiness".equals(name)){
            List<PropsBusiness> list = propsService.listBusiness();
            JSONObject types = new JSONObject();
            for (PropsBusiness t : list) {
                types.put(t.getId() + "", t.getName());
            }
            r = types.toJSONString();
        }else if("propsChannel".equals(name)){
            List<PropsChannel> list = propsChannelService.getList();
            JSONObject jo = new JSONObject();
            for (PropsChannel t : list) {
                HashMap<Object, Object> map = Maps.newHashMap();
                map.put("name", t.getName());
                map.put("businessId", t.getBusinessId());
                jo.put(t.getId() + "", map);
            }
            r = jo.toJSONString();
        }else if("propsType".equals(name)){
            List<PropsType> list = propsTypeService.getList();
            JSONObject jo = new JSONObject();
            for (PropsType t : list) {
                HashMap<Object, Object> map = Maps.newHashMap();
                map.put("name", t.getName());
                map.put("channelId", t.getChannelId());
                jo.put(t.getId() + "", map);
            }
            r = jo.toJSONString();
        }else if("propsUnit".equals(name)){
            List<PropsUnit> list = propsUnitService.getList();
            JSONObject jo = new JSONObject();
            for (PropsUnit t : list) {
                HashMap<Object, Object> map = Maps.newHashMap();
                map.put("name", t.getName());
                map.put("isDefault", t.getIsDefault());
                jo.put(t.getId() + "", map);
            }
            r = jo.toJSONString();
        }else if("propsProperty".equals(name)){
            List<PropsProperty> list = propsPropertyService.getList();
            JSONObject jo = new JSONObject();
            for (PropsProperty t : list) {
                HashMap<Object, Object> map = Maps.newHashMap();
                map.put("name", t.getName());
                map.put("isDefault", t.getIsDefault());
                jo.put(t.getId() + "", map);
            }
            r = jo.toJSONString();
        }else if("propsOperateType".equals(name)){
            List<PropsOperateType> list = propsOperateTypeService.getList();
            JSONObject jo = new JSONObject();
            for (PropsOperateType t : list) {
                HashMap<Object, Object> map = Maps.newHashMap();
                map.put("name", t.getName());
                map.put("channelId", t.getChannelId());
                jo.put(t.getId() + "", map);
            }
            r = jo.toJSONString();
        }else if("channelAssociation".equals(name)){
            List<ChannelAssociation> channelAssociations = channelAssociationService.channelAssociationList(country);
            JSONObject jo = new JSONObject();
            for (ChannelAssociation t : channelAssociations) {
                HashMap<Object, Object> map = Maps.newHashMap();
                map.put("id", t.getId());
                map.put("name",t.getChannelName());
                jo.put(t.getId() + "", map);
            }
            r = jo.toJSONString();
        }

        StringBuilder sb = new StringBuilder();
        sb.append("var Dict=Dict || {} ;  Dict." + name + "=");
        sb.append(r);
        sb.append(";");

        return sb.toString();
    }
}

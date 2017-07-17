package com.ydzx.manager;

import java.util.Collections;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.letv.boss.core.operator.service.OperatorAccountService;
import com.letv.boss.core.product.service.ICombinePackageService;
import com.letv.boss.core.product.service.IMovieLiveService;
import com.letv.boss.pojo.CodeMsg;
import com.letv.boss.pojo.CombinePackage;
import com.letv.boss.pojo.Movie;
import com.letv.boss.pojo.pager.PageUnder;
import com.letv.commons.util.Objects;

@Controller
public class SearchController {
    @Resource
    private OperatorAccountService operatorAccountService;

    @Resource
    private IMovieLiveService movieLiveService;
    @Resource
    ICombinePackageService combinePackageService;

    @RequestMapping(value = "/search_name")
    @ResponseBody
    public CodeMsg searchName(String appName, @RequestParam(defaultValue = "operatorName") String type, PageUnder pager) {
        appName = Objects.likeParam(appName);
        List<?> list = Collections.emptyList();
        if (appName != null) {
            if ("operatorName".equalsIgnoreCase(type)) {
                list = operatorAccountService.searchOperatorName(appName);
            } else if ("movie".equalsIgnoreCase(type)) {
                Movie movie = new Movie();
                movie.setIsCharge(1); //付费           
                movie.setStatus(1); //发布状态
                movie.setMovieName(appName);
                movie.setSpell(appName);
                list = this.movieLiveService.getMovieList(movie, pager);
            } else if ("combine".equalsIgnoreCase(type)) {
                CombinePackage combinePackage = new CombinePackage();
                combinePackage.setName(appName);
                combinePackage.setSpell(appName);
                list = combinePackageService.getCombinePackageList(combinePackage, pager);

            }
        }

        CodeMsg msg = new CodeMsg();
        msg.setData(list);
        return msg;
    }

}

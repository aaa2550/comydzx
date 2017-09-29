package com.keepme.controller.sys;

import javax.annotation.Resource;

import com.keepme.controller.BaseController;
import com.keepme.pojo.DataGrid;
import com.keepme.pojo.PageUnder;
import com.keepme.pojo.UserOperateLog;
import com.keepme.service.UserOperateLogService;
import com.keepme.util.DataUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("/user_log")
public class UserOperateLogController extends BaseController {

    @Resource
    private UserOperateLogService userOperateLogService;

    @RequestMapping("/list.do")
    public String list() {
        return "sys/user_log_list";
    }

    @ResponseBody
    @RequestMapping("/list.json")
    public DataGrid<UserOperateLog> listJ(UserOperateLog userOperateLog, PageUnder pager) {
        userOperateLog = DataUtil.transEmptyPropertyToNull(userOperateLog);
        userOperateLog.setOperation(DataUtil.likeParam(userOperateLog.getOperation()));
        userOperateLog.setExt(DataUtil.likeParam(userOperateLog.getExt()));
        DataGrid<UserOperateLog> grid = new DataGrid<UserOperateLog>();

        List<UserOperateLog> rows = userOperateLogService.userLogList(userOperateLog, pager);
        grid.setRows(rows);
        grid.setTotal(userOperateLogService.userLogCount(userOperateLog));
        return grid;
    }

}

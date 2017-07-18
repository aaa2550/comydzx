package com.ydzx.controller.sys;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.letv.boss.controller.BaseController;
import com.letv.boss.core.log.service.IUserOperateLogService;
import com.letv.boss.pojo.UserOperateLog;
import com.letv.boss.pojo.pager.DataGrid;
import com.letv.boss.pojo.pager.PageUnder;
import com.letv.commons.util.Objects;

@Controller
@RequestMapping("/user_log")
public class UserOperateLogController extends BaseController {

    @Resource
    private IUserOperateLogService userOperateLogService;

    @RequestMapping("/list.do")
    public String list() {
        return "sys/user_log_list";
    }

    @ResponseBody
    @RequestMapping("/list.json")
    public DataGrid<UserOperateLog> listJ(UserOperateLog userOperateLog, PageUnder pager) {
        userOperateLog = Objects.transEmptyPropertyToNull(userOperateLog);
        userOperateLog.setOperation(Objects.likeParam(userOperateLog.getOperation()));
        userOperateLog.setExt(Objects.likeParam(userOperateLog.getExt()));
        DataGrid<UserOperateLog> grid = new DataGrid<UserOperateLog>();

        List<UserOperateLog> rows = userOperateLogService.userLogList(userOperateLog, pager);
        grid.setRows(rows);
        grid.setTotal(userOperateLogService.userLogCount(userOperateLog));
        return grid;
    }

}

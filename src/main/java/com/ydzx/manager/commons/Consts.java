package com.ydzx.manager.commons;

import com.letv.boss.LetvEnv;
import jmind.core.lang.SourceProperties;
import jmind.core.log.LogbackConfigure;
import jmind.core.util.DataUtil;
import jmind.core.util.DateUtil;
import jmind.core.util.IpUtil;

import java.util.HashMap;
import java.util.Map;

public class Consts {

    public static final SourceProperties APP = new SourceProperties(LetvEnv.getEnvironment() + "/boss-app.properties");
    // 是否推送，本机不推送，文件地址不好配置
    public static final boolean HAS_PUSH = !IpUtil.getLocalAddress().startsWith("10.58") && APP.hasProperty("push.url");
    // 默认地区
    public static final int BOSS_COUNTRY = DataUtil.toInt(APP.get("boss_country"));
    // 默认语言
    public static final String BOSS_LANG = APP.get("boss_lang");
    // 登陆cookie
    public static final String LOGIN = "bs_login_";
    //接口验证 secret
    public static final String API_SECRET = "549bd215a1a8b632f9cc293d";
    //  新boss mysql 数据库
    public static final String DB_LETV_BOSS = "letv_boss";
    // 老boss Oracle 数据库
    public static final String DB_BOSS = "boss";

    // 道具
    public static final String DB_PROPS = "props";
    public static final String DB_PROPS_SHARD = "props_shard";
    // 院线mysql 数据库
    public static final String DB_VIP_LETV = "vip_letv";

    // 院线mysql 数据库 slave
    public static final String DB_YUANXIAN_STAT = "yuanxian_stat";

    // 院线mysql 会员库
    public static final String DB_YUANXIAN_ORDER1 = "yx_pay_order1";
    public static final String DB_YUANXIAN_ORDER2 = "yx_pay_order2";
    public static final String DB_YUANXIAN_ORDER3 = "yx_pay_order3";
    public static final String DB_YUANXIAN_ORDER4 = "yx_pay_order4";

    // 集团Oracle 支付库
    public static final String DB_GROUP_PAY = "group_pay";

    // 集团对账数据库
    public static final String DB_BALANCE_ACCOUT = "balance_accout";

    // 集团新支付
    public static final String DB_GROUP_NEW_PAY = "group_new_pay";

    // Boss新支付
    public static final String DB_BOSS_NEW_PAY0 = "boss_new_pay0";
    public static final String DB_BOSS_NEW_PAY1 = "boss_new_pay1";
    public static final String DB_BOSS_NEW_PAY2 = "boss_new_pay2";
    public static final String DB_BOSS_NEW_PAY3 = "boss_new_pay3";
    public static final String DB_BOSS_NEW_PAY4 = "boss_new_pay4";

    // 美国支付库，用于对账(如果不能直接访问美国库,对账功能转移到支付系统)
    public static final String DB_LETV_US_PAY = "letv_us_pay";

    public static final String DB_BOSS_NEW_PAY5 = "boss_new_pay5";
    public static final String DB_BOSS_NEW_PAY6 = "boss_new_pay6";
    public static final String DB_BOSS_NEW_PAY7 = "boss_new_pay7";
    public static final String DB_BOSS_NEW_PAY8 = "boss_new_pay8";

    public static final String DB_BIGDATA = "bigdata";

    //风控黑名单
    public static final String RISK_BLACK = "risk_black";

    //  统计库
    public static final String DB_BOSSTDY = "bosstdy";
    // boss 统计 infobright 
    public static final String DB_BOSS_STAT = "boss_stat";
    // boss 统计Toku
    public static final String DB_BOSSTDY_TOKU = "bosstdy_toku";
    //乐购
    public static final String DB_MMALL_GOODS = "mmall_goods";
    // hades
    public static final String DB_HADES = "hades";
    //版权分成数据库
    public static final String DB_BOSS_SHARE = "boss_share";

    //用户中心，评分数据库
    public static final String DB_VPLAY = "vplay";

    public static final String UPLOAD_FILE = "/letv/data/f/";

    public static final String UPLOAD_IMG = "/letv/data/img/";

    public static final String SQL_DELETE = "DELETE FROM #table where id=:1";

    public static final String SQL_ALL = "SELECT * FROM #table";

    public static final String SQL_GET = SQL_ALL + "  where id=:1";

    public static final String WAITER_ALINE_PATH = "waiter/aline/";



    //批量查询个数
    public static final int MAX_BATCH_COUNT = 5000;

    // 赛季类型
    public static final int SEASON_TYPE = 1;
    // 轮次类型
    public static final int ROUND_TYPE = 2;
    // 缺省轮次信息
    public static final String DEFAULT_ROUND = "0";

    //权限验证后缀
    public static final String PERMISSION_SUFFIX = ".do";

    //json权限验证后缀
    public static final String PERMISSION_JSON_SUFFIX = ".json";



    //无套餐
    public static final String DEFAULT_NO_PACKAGE = "无套餐";

    //合作方
    public static final String COOPERATION_ID = "baidu";

    public static final String ADD = "add";

    public static final String UPDATE = "update";

    public static final String DELETE = "delete";

    public static final String DATA_GRID = "data_grid";

    //支付密钥
    public static final String PAY_SECKEY_SUFFIX = "@pay2013!#![]";
    // 乐卡正在生产中
    public static boolean LECARD_CREATING = false;
    // 乐卡状态 。正常
    public static final int LECARD_STATUS_NORMAL = 1;
    // 乐卡状态 。冻结
    // public static final int LECARD_STATUS_FREEZE = 2;
    // 积分商城 兑换码长度
    public static final int LECARD_OPERATOR_EXCHANGE_LENGTH = 20;

    // 会员套餐兑换码
    public static final int LECARD_TYPE_EXCHANGE = 2;
    // 超级手机兑换码
    public static final int LECARD_TYPE_SUPER_LEPHONE = 4;
    // 兑换码2.0版
    public static final int LECARD_TYPE_EXCHANGE_2 = 5;
    // 机卡兑换码
    public static final int LECARD_TYPE_MACHINE_CARD = 6;
    // 体育兑换码
    public static final int LECARD_TYPE_SPORT = 10;
    // 体育场次兑换码
    public static final int LECARD_TYPE_SPORT_EXTENDS = 11;
    // 音乐兑换码
    public static final int LECARD_TYPE_MUSIC = 20;
    // 影视剧兑换码
    public static final int LECARD_TYPE_MOVIE = 30;
    // 组合套餐兑换码
    public static final int LECARD_TYPE_COMBINE = 40;
    // 大屏商品兑换码
    public static final int LECARD_TYPE_ECOMMERCE = 50;
    // 运营商 管理 代销类型
    public static final int OPERATOR_STYPE_COMMISSION = 2;
    //一键支付绑定生效标志
    public static final int ONO_KEY_PAY_FLAG_SUCESS = 1;

    //一键支付绑定生效标志
 //   public static final int ONO_KEY_PAY_FLAG_UNBIND = 0;

    //院线封禁会员时的key
    public static final String YUANXIAN_FORBIDDEN_KEY = "D4$^&Fkw,.2isk!@#,)kdpowzcsedkwi#S*@";

    //院线转移会员服务时的key
    public static final String YUANXIAN_VIP_TRANSFER_KEY = "20#@aqk,.AsdlyqzknCBVcb,siew,gc,.sdijei284ij4$$67";

    /**
     * 院线订单支付成功的订单标志状态
     */
    public static final int PAY_SUCESS_STATUS = 1;

    //付费类型
    public static final int CHARGE_TYPE_DIANBO = 0; //点播
    public static final int CHARGE_TYPE_DIANBO_AND_BAOYUE = 1; //点播且包月
    public static final int CHARGE_TYPE_BAOYUE = 2; //包月
    public static final int CHARGE_TYPE_FREE_TV_BAOYUE = 3; //免费但TV包月收费

    public static final int RULE_USE_CURRENT_PRICE = 61;

    //影视直播errorCode
    // 系统异常
    public static final String SYSTEM_ERROR = "01000000";
    public static final String SIGN_ERROR = "01000001";
    // 影片id为空
    public static final String MOVIEID_EMPTY = "01001000";
    public static final String MOVIENAME_EMPTY = "01001001";
    public static final String LIVETYPE_EMPTY = "01001003";
    public static final String LIVETIME_EMPTY = "01001004";
    public static final String PAYBEGINTIME_EMPTY = "01001007";
    public static final String LIVETIME_ERROR = "01001005";
    public static final String PAYBEGINTIME_ERROR = "01001006";

    //院线抽奖常量
    public static final String LOTTERYKEY = "sometimes naive"; // 密钥

    public static final Map<String, String> LIVE_STATUS = new HashMap<String, String>() {
        {
            put("未开始", "1");
            put("1", "未开始");
            put("进行中", "2");
            put("2", "进行中");
            put("已结束", "3");
            put("3", "已结束");
            put("延期", "4");
            put("4", "延期");
            put("取消", "5");
            put("5", "取消");
        }

    };

    public static final String ADDLIVE_MOVIE_MD5 = "902ddc5998aadfe579ee";

    //统计查询用户数据的最大峰值
    public static final int EXPORT_EXCEL_MAX_RECORD = 10000;
    // 移动积分商城渠道号
    public static final int MALL_CHANNEL_10086 = 10086;

    // 体育频道-频道ID
    public static final String SPORTS_CHANNEL_ID = "04";

    /**
     * 打印默认最大数量
     */
    public static final int EXPORT_MAX_NUMBER = 50000;

    public static final String EMAIL_LE_SUFFIX = "@le.com";
    public static final String EMAIL_LETV_SUFFIX = "@letv.com";
}

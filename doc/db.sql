-- 客户公司信息表
CREATE TABLE `customer_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  `company_name` varchar(100) NOT NULL COMMENT '公司全称',
  `type` varchar(10) NOT NULL COMMENT '类型',
  `name` varchar(100) NOT NULL COMMENT '公司简称',
  `province` varchar(20) NOT NULL COMMENT '省份',
  `city` varchar(20) NOT NULL COMMENT '城市',
  `address` varchar(100) NOT NULL COMMENT '地址',
  `linkman_name` varchar(50) NOT NULL COMMENT '联系人姓名',
  `linkman_tel` varchar(50) NOT NULL COMMENT '联系人电话',
  `email` varchar(100) NOT NULL COMMENT '邮箱',
  `remark` varchar(500) NOT NULL COMMENT '备注'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='客户公司信息表';

-- 供应商公司信息表
CREATE TABLE `provider_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  `company_name` varchar(100) NOT NULL COMMENT '公司全称',
  `name` varchar(100) NOT NULL COMMENT '公司简称',
  `province` varchar(20) NOT NULL COMMENT '省份',
  `city` varchar(20) NOT NULL COMMENT '城市',
  `address` varchar(100) NOT NULL COMMENT '地址',
  `linkman_name` varchar(50) NOT NULL COMMENT '联系人姓名',
  `linkman_tel` varchar(50) NOT NULL COMMENT '联系人电话',
  `email` varchar(100) NOT NULL COMMENT '邮箱',
  `remark` varchar(500) NOT NULL COMMENT '备注'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='供应商公司信息表';

-- 发票表
CREATE TABLE `invoice_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL COMMENT '所属公司',
  `type` varchar(20) NOT NULL COMMENT '我司/客户/供应商',
  `taxpayer_code` varchar(100) NOT NULL COMMENT '纳税人识别号',
  `title` varchar(20) NOT NULL COMMENT '收票公司',
  `address` varchar(200) NOT NULL COMMENT '地址',
  `tel` varchar(100) NOT NULL COMMENT '电话',
  `open_account_bank` varchar(100) NOT NULL COMMENT '开户银行',
  `account_code` varchar(100) NOT NULL COMMENT '银行账户号'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='发票表';

-- 银行账户信息
CREATE TABLE `bank_account_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  `company_id` int(11) NOT NULL COMMENT '所属公司',
  `type` varchar(20) NOT NULL COMMENT '我司/客户/供应商',
  `account_name` varchar(100) NOT NULL COMMENT '账户名称',
  `bank_name` varchar(100) NOT NULL COMMENT '银行名称',
  `account_code` varchar(100) NOT NULL COMMENT '账户号'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='银行账户信息';

-- 客户合同信息表
CREATE TABLE `customer_contract_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  `customer_type` varchar(50) NOT NULL COMMENT '直客/子客',
  `business_type` varchar(50) NOT NULL COMMENT '业务类型',
  `contract_code` varchar(100) NOT NULL COMMENT '合同编号',
  `statistics_short_name` varchar(10) NOT NULL COMMENT '统计简称',
  `our_company_name` varchar(50) NOT NULL COMMENT '我方主体名称',
  `contract_start_time` datetime NOT NULL COMMENT '合同开始时间',
  `contract_end_time` datetime NOT NULL COMMENT '合同结束时间',
  `rebates` decimal(10,2) DEFAULT NULL COMMENT '返点',
  `orderfrom` int(11) DEFAULT NULL COMMENT '账期（天）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='客户合同信息表';

-- 供应商合同信息表
CREATE TABLE `provider_contract_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  `customer_type` varchar(50) NOT NULL COMMENT '直客/子客',
  `business_type` varchar(50) NOT NULL COMMENT '业务类型',
  `contract_code` varchar(100) NOT NULL COMMENT '合同编号',
  `statistics_short_name` varchar(10) NOT NULL COMMENT '统计简称',
  `our_company_name` varchar(50) NOT NULL COMMENT '我方主体名称',
  `contract_start_time` datetime NOT NULL COMMENT '合同开始时间',
  `contract_end_time` datetime NOT NULL COMMENT '合同结束时间',
  `rebates` decimal(10,2) DEFAULT NULL COMMENT '返点',
  `orderfrom` int(11) DEFAULT NULL COMMENT '账期（天）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='供应商合同信息表';

-- 点我账户表
CREATE TABLE `keepme_account_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  `app_id` varchar(50) NOT NULL COMMENT 'APPID',
  `platform` varchar(50) NOT NULL COMMENT '投放平台',
  `keepme_account_name` varchar(50) NOT NULL COMMENT '账户名称',
  `keepme_account_id` varchar(100) NOT NULL COMMENT '账户ID',
  `provider_id` int(11) NOT NULL COMMENT '供应商ID',
  `provider_name` int(11) NOT NULL COMMENT '供应商名称',
  `bank_account_id` int(11) NOT NULL COMMENT '银行账户主键',
  `qq` varchar(20) NOT NULL COMMENT '绑定QQ',
  `industry` varchar(20) NOT NULL COMMENT '行业',
  `app_id` varchar(20) NOT NULL COMMENT 'APPID',
  `generalize_link` varchar(200) NOT NULL COMMENT '推广链接',
  `services` varchar(50) NOT NULL COMMENT 'feed/分包/oCPA/DMP/联盟屏蔽/oCP留存/oCP订单',
  `subpackage` varchar(50) NOT NULL COMMENT '分包',
  `ocpa` varchar(50) NOT NULL COMMENT 'ocpa',
  `pass_status` varchar(50) NOT NULL COMMENT '通过状态',
  `pass_time` datetime DEFAULT NULL COMMENT '通过时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='推广账户表';

-- 充值信息表
CREATE TABLE `recharge_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  `generalize_id` int(11) NOT NULL COMMENT '推广账户ID',
  `app_id` varchar(50) NOT NULL COMMENT 'APPID',
  `customer_id` int(11) NOT NULL COMMENT '客户ID',
  `customer_name` int(11) NOT NULL COMMENT '客户名称',
  `provider_id` int(11) NOT NULL COMMENT '供应商ID',
  `provider_name` int(11) NOT NULL COMMENT '供应商名称',
  `our_rebates` decimal(10,2) NOT NULL COMMENT '我方返点',
  `customer_rebates` decimal(10,2) NOT NULL COMMENT '客户返点',
  `account_recharge` decimal(10,2) NOT NULL COMMENT '我方返点',
  `rebates_recharge` decimal(10,2) NOT NULL COMMENT '返点充值',
  `recharge_cost` decimal(10,2) NOT NULL COMMENT '充值成本'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='充值信息表';

-- 发票表
CREATE TABLE `invoice_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  `invoice_info_id` datetime NOT NULL COMMENT '发票信息表ID',
  `type` varchar(50) NOT NULL COMMENT '销售发票|媒介发票',
  `apply_name` varchar(50) NOT NULL COMMENT '申请人姓名',
  `customer_id` int(11) NOT NULL COMMENT '客户ID',
  `customer_name` int(11) NOT NULL COMMENT '客户名称',
  `invoice_id` int(11) NOT NULL COMMENT '发票ID',
  `money` decimal(10,2) NOT NULL COMMENT '金额',
  `platform` varchar(50) NOT NULL COMMENT '投放平台',
  `pay_time` datetime NOT NULL COMMENT '费用发生日期',
  `invoice_code` varchar(50) NOT NULL COMMENT '发票号',
  `open_time` datetime NOT NULL COMMENT '开票日期'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='供应商支付发票表';

-- 收付款信息导入表
CREATE TABLE `return_pay_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  `customer_id` int(11) NOT NULL COMMENT '统计单位ID',
  `customer_name` varchar(200) NOT NULL COMMENT '统计单位名称',
  `transact_time` datetime NOT NULL COMMENT '交易时间',
  `pay_money` decimal(10,2) DEFAULT 0 COMMENT '支出',
  `return_money` decimal(10,2) DEFAULT 0 COMMENT '收入',
  `surplus_money` decimal(10,2) NOT NULL COMMENT '余额',
  `currency` varchar(50) NOT NULL COMMENT '币种',
  `account_name` varchar(100)NOT NULL COMMENT '对方户名',
  `account` varchar(100) NOT NULL COMMENT '对方账号',
  `open_account_institutions` varchar(50) NOT NULL COMMENT '对方开户机构',
  `bank_record_time` datetime NOT NULL COMMENT '记账日期',
  `abstracts` varchar(200) NOT NULL COMMENT '摘要',
  `remark` varchar(200) NOT NULL COMMENT '备注',
  `serial_number` varchar(100) NOT NULL COMMENT '账户明细编号-交易流水号',
  `voucher_species` varchar(50) NOT NULL COMMENT '凭证种类',
  `voucher_code` varchar(100) NOT NULL COMMENT '凭证号'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='收付款信息导入表';
###移动渠道流量
CREATE TABLE `t_mobile_order_result` (
  `stat_date` date DEFAULT NULL,
  `pay_cnt` int(11) DEFAULT NULL,
  `pv` int(11) DEFAULT NULL,
  `uv` int(11) DEFAULT NULL,
  `money` double DEFAULT NULL,
  `act_code` varchar(10) DEFAULT NULL,
  `act_pageid` varchar(20) DEFAULT NULL,
  `act_fl` varchar(100) DEFAULT NULL,
  `act_fragid_name` varchar(20) DEFAULT NULL,
  `act_wz` varchar(20) DEFAULT NULL,
  `neworxufei` int(11) DEFAULT NULL,
  `fm_flag` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `t_mobile_order` (
  `stat_date` date DEFAULT NULL,
  `pay_cnt` int(11) DEFAULT NULL,
  `act_code` varchar(10) DEFAULT NULL,
  `act_pageid` varchar(20) DEFAULT NULL,
  `act_fl` varchar(20) DEFAULT NULL,
  `act_fragid_name` varchar(20) DEFAULT NULL,
  `act_wz` varchar(20) DEFAULT NULL,
  `neworxufei` int(11) DEFAULT NULL,
  `fm_flag` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

#会员渠道
CREATE TABLE `t_mobile_channel` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `act_code` varchar(10) DEFAULT NULL,
  `act_pageid` varchar(20) DEFAULT NULL,
  `act_fl` varchar(20) DEFAULT NULL,
  `act_fragid_name` varchar(20) DEFAULT NULL,
  `act_wz` varchar(20) DEFAULT NULL,
  `channel_name` varchar(100) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `author` varchar(50) DEFAULT NULL,
  `fm_flag` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `t_activity_uv` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pv` bigint(20) DEFAULT NULL,
  `uv` bigint(20) DEFAULT NULL,
  `terminal` int(11) DEFAULT NULL,
  `url` varchar(200) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `dt` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
#活动订单查询
CREATE TABLE `x_event_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_name` varchar(200) NOT NULL,
  `begin_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `activity_desc` varchar(1000) DEFAULT NULL,
  `user_type` varchar(20) DEFAULT NULL,
  `activity_type` int(11) DEFAULT NULL,
  `send_note` int(11) DEFAULT '1',
  `movie` varchar(45) DEFAULT NULL,
  `productnum` int(11) DEFAULT NULL,
  `result` varchar(45) DEFAULT NULL,
  `paychannel` varchar(45) DEFAULT NULL,
  `memberfrom` varchar(45) DEFAULT NULL,
  `membertype` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `x_event` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '用户id',
  `event_type` smallint(6) DEFAULT '0' COMMENT '专题活动类型',
  `meta` varchar(1024) DEFAULT NULL COMMENT '个性化数据,json格式,可能比较大',
  `add_time` datetime NOT NULL COMMENT '创建时间',
  `orderid` varchar(255) DEFAULT NULL,
  `note_status` varchar(45) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `x_event_orderid_index` (`orderid`),
  KEY `x_event_add_time_index` (`add_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `orderform` (
  `ORDERNUMBER` varchar(32) DEFAULT NULL COMMENT '订单号',
  `USERNAME` varchar(64) DEFAULT NULL COMMENT '用户名(真正支付的用户)',
  `PRICE` varchar(16) DEFAULT NULL COMMENT '支付金额',
  `SUBMITDATE` datetime DEFAULT NULL COMMENT '订单提交时间',
  `PAYMENTDATE` datetime DEFAULT NULL COMMENT '支付时间',
  `STATUS` int(11) DEFAULT NULL COMMENT '状态(0为失败 1为成功 2 为未知)',
  `PAYTYPE` int(11) DEFAULT NULL COMMENT '支付方式',
  `USERID` varchar(20) DEFAULT NULL COMMENT '用户id',
  `IP` varchar(200) DEFAULT NULL COMMENT 'ip',
  `country` varchar(100) DEFAULT NULL COMMENT '国家',
  `province` varchar(50) DEFAULT NULL COMMENT '省份',
  `city` varchar(50) DEFAULT NULL COMMENT '城市',
  `network` varchar(50) DEFAULT NULL COMMENT '网络类型',
  `MEMO` varchar(64) DEFAULT NULL COMMENT '描述 说明',
  `CORDERID` varchar(32) DEFAULT NULL COMMENT '商户订单号',
  `DEPTID` varchar(5) DEFAULT NULL COMMENT '支付的部门编号(mobel:130 pc:112 tv:111)',
  `PRODUCTID` int(11) DEFAULT NULL COMMENT '产品id(vrs系统读取，以后会走定价系统)',
  `CHARGETYPE` varchar(2) DEFAULT NULL COMMENT '0表示直接购买，1表示充值乐点，默认0',
  `PRODUCTNAME` varchar(100) DEFAULT NULL COMMENT '商品名称',
  `COMPANYID` varchar(2) DEFAULT NULL COMMENT '公司id （乐视网、乐视志新、网酒网 ...  乐视网1，志新2，网酒3....)',
  `FRONTURL` varchar(500) DEFAULT NULL COMMENT '页面通知url',
  `BACKURL` varchar(500) DEFAULT NULL COMMENT '服务器notifyurl',
  `SVIP` varchar(10) DEFAULT NULL COMMENT 'vip类型',
  `EXT` varchar(255) DEFAULT NULL COMMENT '扩展字段',
  `PRODUCTNUM` int(11) DEFAULT NULL COMMENT '商品数量',
  KEY `orderform_paymentdate_index` (`PAYMENTDATE`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

#影片站外渠道收入
CREATE TABLE `t_movie_outside_channel` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` varchar(20) DEFAULT NULL,
  `movie_name` varchar(256) DEFAULT NULL,
  `pv` int(11) DEFAULT NULL,
  `uv` int(11) DEFAULT NULL,
  `channel` varchar(100) DEFAULT NULL,
  `payNum` int(11) DEFAULT NULL,
  `payMoney` double DEFAULT NULL,
  `terminal` int(11) DEFAULT NULL,
  `dt` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

package com.keepme.commons;

public class Consts {

    public static final SourceProperties APP = new SourceProperties(Environment.getEnvironment() + "/common.properties");
    // 登陆cookie
    public static final String LOGIN = "bs_login_";
    //接口验证 secret
    public static final String API_SECRET = "549bd215a1a8b632f9cc293d";

    public static final String DELIM = "&";

    public static final String KEY = "17D7B842E1437BBEA81D13D94FF23F14";

    public static final String SQL_DELETE = "DELETE FROM #table where id=:1";

    public static final String SQL_ALL = "SELECT * FROM #table";

    public static final String SQL_GET = SQL_ALL + "  where id=:1";

    public static final String ENCODE = "UTF-8";
}

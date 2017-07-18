package com.ydzx.util;

import javax.servlet.http.HttpServletRequest;
import java.net.Inet4Address;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.util.Enumeration;

/**
 * Created by yanghailong on 2017/7/18.
 */
public class IPUtil {

    public static String getRequestIP(HttpServletRequest httpServletRequest) {
        String remoteAddr = httpServletRequest.getRemoteAddr();
        String forwarded = httpServletRequest.getHeader("X-Forwarded-For");
        String realIp = httpServletRequest.getHeader("X-Real-IP");

        String ip;
        if (realIp == null) {
            if (forwarded == null) {
                ip = remoteAddr;
            } else {
                ip = remoteAddr + "/" + forwarded.split(",")[0];
            }
        } else {
            if (realIp.equals(forwarded)) {
                ip = realIp;
            } else {
                if(forwarded != null){
                    forwarded = forwarded.split(",")[0];
                }
                ip = realIp + "/" + forwarded;
            }
        }
        return ip;
    }

    public static String getLocalIP() {
        Enumeration allNetInterfaces = null;
        try {
            allNetInterfaces = NetworkInterface.getNetworkInterfaces();
        } catch (SocketException e) {
            e.printStackTrace();
        }
        InetAddress inetAddress = null;
        while (allNetInterfaces.hasMoreElements())
        {
            NetworkInterface netInterface = (NetworkInterface) allNetInterfaces.nextElement();
            System.out.println(netInterface.getName());
            Enumeration enumeration = netInterface.getInetAddresses();
            while (enumeration.hasMoreElements())
            {
                inetAddress = (InetAddress) enumeration.nextElement();
                if (inetAddress != null && inetAddress instanceof Inet4Address)
                {
                    return inetAddress.getHostAddress();
                }
            }
        }
        return null;
    }
}

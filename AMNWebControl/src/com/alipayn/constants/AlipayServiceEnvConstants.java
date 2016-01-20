

/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2014 All Rights Reserved.
 */
package com.alipayn.constants;

/**
 * 支付宝服务窗环境常量（demo中常量只是参考，需要修改成自己的常量值）
 * 
 * @author taixu.zqq
 * @version $Id: AlipayServiceConstants.java, v 0.1 2014年7月24日 下午4:33:49 taixu.zqq Exp $
 */
public class AlipayServiceEnvConstants {

    /**支付宝公钥-从支付宝服务窗获取*/
    public static final String ALIPAY_PUBLIC_KEY = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDI6d306Q8fIfCOaTXyiUeJHkrIvYISRcc73s3vF1ZT7XN8RNPwJxo8pWaJMmvyTn9N4HQ632qJBVHf8sxHi/fEsraprwCtzvzQETrNRwVxLO5jVmRGi60j8Ue1efIlzPXV9je9mkjzOmdssymZkh2QhUrCmZYI/FCEa3/cNMW0QIDAQAB";

    /**签名编码-视支付宝服务窗要求*/
    public static final String SIGN_CHARSET      = "GBK";

    /**字符编码-传递给支付宝的数据编码*/
    public static final String CHARSET           = "GBK";

    /**签名类型-视支付宝服务窗要求*/
    public static final String SIGN_TYPE         = "RSA";
    
    
    public static final String PARTNER           = "2088911227080000";

    /** 服务窗appId  */
    //TODO !!!! 注：该appId必须设为开发者自己的服务窗id  这里只是个测试id
    public static final String APP_ID            = "2015110300677235";

    //开发者请使用openssl生成的密钥替换此处  请看文档：https://fuwu.alipay.com/platform/doc.htm#2-1接入指南
    //TODO !!!! 注：该私钥为测试账号私钥  开发者必须设置自己的私钥 , 否则会存在安全隐患 
    public static final String PRIVATE_KEY       = "MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMIME+8lqfggZbQW3h1PTa3NP+WgLzEnjHxfSqRp5c7lFZNUYVmOVXlPQfdc7VnkEs72CERqadp7XFL0IjTq0Q/sJUXn7rTbbXhHaFMbquR4IDHFVhYRQpC1aWrvR4/H2brjNqXyDX3Jy4wudwRmPAuQRCH5EpdAtQuuOwMJ+2sRAgMBAAECgYAGn5zqk9GKa6itDf7E51kSbqgYsXAK8HumHyaQGCFE/6LN5ZpxER+vxVnOFLjxUYymzdUYaL12PLG5DyY/wigioLNqpca8nwJ61JiPUkF1rv+Pkep4xlQN1JF2VCNaBxzVk3XnHYBWZFysGnoeGTf7KzboGJZi0H5h3g59XHmyAQJBAPdrBZTy31h8rv3XTyxfKyq7fDlT8mJ6k4oAxQefaqaK07NQa2oT1r2n1avQhpmALFdW4881cVlazfFZbABNRTECQQDIxySbm8Y0pxsaQi0nZV14R7DqL9YAZVMKwpvhSOmu4pCjMvOIYZNIq5z5LxDQuul/3sm4+MvaoJRurbOJgIvhAkEA1GziofvUntiONgtCQsqC+XF3OpFEriCnw/jdMapBmzPehzoovy7BVJxg699hcTGG4IYNmb48z4cTAoDQJYIyQQJAPtyS6qF4Ci4zvyHvD0GeZTVU/82gXBldSaYqtftlJttK273tH8slGQCaMi55PlD3IJD5aY+EC9xw/MInzypPIQJAWp1bCCeHsTfI688PUIfR23MfqLR20z7Kd6wQvJ+jDboNPVD69VO8iV01CMJHNonQJLle2havHQp08NaSGau7dQ==";

    //TODO !!!! 注：该公钥为测试账号公钥  开发者必须设置自己的公钥 ,否则会存在安全隐患
    public static final String PUBLIC_KEY        = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDCDBPvJan4IGW0Ft4dT02tzT/loC8xJ4x8X0qkaeXO5RWTVGFZjlV5T0H3XO1Z5BLO9ghEamnae1xS9CI06tEP7CVF5+602214R2hTG6rkeCAxxVYWEUKQtWlq70ePx9m64zal8g19ycuMLncEZjwLkEQh+RKXQLULrjsDCftrEQIDAQAB";

    /**支付宝网关*/
    public static final String ALIPAY_GATEWAY    = "https://openapi.alipay.com/gateway.do";

    /**授权访问令牌的授权类型*/
    public static final String GRANT_TYPE        = "authorization_code";
}
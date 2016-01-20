package com.amani.service;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.alipay.api.response.AlipayTradeCancelResponse;
import com.alipay.api.response.AlipayTradePayResponse;
import com.alipay.api.response.AlipayTradeQueryResponse;
import com.alipay.api.response.AlipayTradeRefundResponse;
import com.alipay.util.UtilDate;
import com.alipayn.f2fpay.ToAlipayBarTradePay;
import com.amani.model.Consumepayment;
import com.amani.tools.CommonTool;

/**
 * 支付宝服务
 */
@Service
public class AliPayService extends AMN_ModuleService{
	public static final String ALI_TITLE="支付宝订单号  ";
	private Logger logger = Logger.getLogger(this.getClass().getName());
	/***提交订单信息
	 * @throws Exception **/
	public Map<String,String> requestPaypal(String csbillid, String auth_code, BigDecimal totalAmt, String compid, String compname) throws Exception {
		Map<String,String> returnValue = new HashMap<String, String>();
		if(auth_code.equalsIgnoreCase("")==true){
			returnValue.put("state", "获取条形码扫描为空，不可以操作!");
			return returnValue;
		}
		
		/**业务系统中商户订单号**/
		String outTradeNo =UtilDate.getOrderNum()+getRandomLenght(10);
		returnValue.put("outTradeNo", outTradeNo);
		
		AlipayTradePayResponse res = ToAlipayBarTradePay.barPay(outTradeNo, auth_code, totalAmt.toString(), "阿玛尼 "+ compname +" 消费", compname, compid);
		if("10000".equals(res.getCode())){
			returnValue.put("state", "OK");
		}else{
			returnValue.put("state", "WAITING");
		}
		returnValue.put("tradeNo", res.getTradeNo());
		savePayment(compid, csbillid, outTradeNo, totalAmt, 1);
		return returnValue;
	}
	
	/**收银主动的取消订单**/
	public String canclePaypalBillStatus(String compid, String csbillid, String outTradeNo, BigDecimal totalAmt){
		savePayment(compid, csbillid, outTradeNo, totalAmt, 2);
		AlipayTradeCancelResponse res = ToAlipayBarTradePay.cancelOrder(outTradeNo);
		if ("N".equals(res.getRetryFlag())) {
			return "OK";
		}else{
			return "撤销失败请重试！";
		}
	}
	
	
	/**查询单据状态**/
	public String queryPaypalBillStatusReturnString(String outTradeNo){
		AlipayTradeQueryResponse res = ToAlipayBarTradePay.query(outTradeNo);
		if("TRADE_SUCCESS".equals(res.getTradeStatus())){
			return "OK";
		}else{
			logger.info(res.getTradeStatus() + " " + outTradeNo);
			return res.getTradeStatus();
		}
	}
	
	/**支付宝退款
	 * @throws Exception **/
	public String refundPaypalBillStatus(String compid, String csbillid, String tradeNo, BigDecimal totalAmt){
		AlipayTradeRefundResponse res = ToAlipayBarTradePay.refundOrder(tradeNo, totalAmt.toString());
		if("10000".equals(res.getCode())){
			return "OK";
		}else{
			logger.info(res.getSubMsg() + " " + tradeNo);
			return res.getSubMsg();
		}
	}
	
	public static String getRandomLenght(Integer len){
		 java.util.Random r=new java.util.Random(); 
		 String value = new Integer(Math.abs(r.nextInt())).toString();
		 if(len<value.length()){
			 return value.substring(0, len);
		 }else{
			 return value;
		 }
	}
	/**
	 * 保存交易记录
	 * @param compid
	 * @param csbillid
	 * @param outTradeNo
	 * @param totalAmt
	 * @param paytype
	 */
	public void savePayment(String compid, String csbillid, String outTradeNo, BigDecimal totalAmt, Integer paytype){
		try{
			Consumepayment payment = new Consumepayment();
			payment.setCscompid(compid);
			payment.setCsbillid(csbillid);
			payment.setScantradeno(outTradeNo);
			payment.setPaydate(CommonTool.getCurrDate());
			payment.setPaytime(CommonTool.getCurrTime());
			payment.setScanpaytype(1);
			payment.setPayamt(totalAmt);
			payment.setPaytype(paytype);
			this.amn_Dao.save(payment);
		}catch(RuntimeException e){
			e.printStackTrace();
		}
	}
	
	@Override
	protected boolean deleteDetail(Object curMaster) {
		return false;
	}

	@Override
	protected boolean deleteMaster(Object curMaster) {
		return false;
	}

	@Override
	protected boolean postMaster(Object curMaster) {
		return false;
	}

	@Override
	protected boolean postDetail(Object details) {
		return false;
	}

	@Override
	public List loadMasterDataSet(int pageSize, int startRow) {
		return null;
	}
}

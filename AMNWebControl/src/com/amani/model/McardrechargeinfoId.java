package com.amani.model;

import java.math.BigDecimal;



/**
 * PapercardId generated by MyEclipse - Hibernate Tools
 */

public class McardrechargeinfoId  implements java.io.Serializable {


    // Fields    

     private String rechargecompid;
     private String rechargebillid;
   
     
     public McardrechargeinfoId(String rechargecompid, String rechargebillid ) {
         this.rechargecompid = rechargecompid;
         this.rechargebillid = rechargebillid;
     }
     public McardrechargeinfoId() {
     }
	public String getRechargecompid() {
		return rechargecompid;
	}
	public void setRechargecompid(String rechargecompid) {
		this.rechargecompid = rechargecompid;
	}
	public String getRechargebillid() {
		return rechargebillid;
	}
	public void setRechargebillid(String rechargebillid) {
		this.rechargebillid = rechargebillid;
	}
	

}
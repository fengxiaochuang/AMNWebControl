package com.amani.model;

import java.math.BigDecimal;



/**
 * PapercardId generated by MyEclipse - Hibernate Tools
 */

public class DgoodsinventoryId  implements java.io.Serializable {


    // Fields    

     private String inventcompid;
     private String inventbillid;
     private Double inventseqno;
     
     public DgoodsinventoryId(String inventcompid, String inventbillid,double inventseqno ) {
         this.inventcompid = inventcompid;
         this.inventbillid = inventbillid;
         this.inventseqno=inventseqno;
     }
     public DgoodsinventoryId() {
     }
	public String getInventcompid() {
		return inventcompid;
	}
	public void setInventcompid(String inventcompid) {
		this.inventcompid = inventcompid;
	}
	public String getInventbillid() {
		return inventbillid;
	}
	public void setInventbillid(String inventbillid) {
		this.inventbillid = inventbillid;
	}
	public Double getInventseqno() {
		return inventseqno;
	}
	public void setInventseqno(Double inventseqno) {
		this.inventseqno = inventseqno;
	}
	
	
}
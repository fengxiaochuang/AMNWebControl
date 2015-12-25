package com.amani.old.model;



/**
 * Gcm20Id generated by MyEclipse - Hibernate Tools
 */

public class Gcm20Id  implements java.io.Serializable {


    // Fields    

     private String gct00c;
     private Integer gct01i;


    // Constructors

    /** default constructor */
    public Gcm20Id() {
    }

    
    /** full constructor */
    public Gcm20Id(String gct00c, Integer gct01i) {
        this.gct00c = gct00c;
        this.gct01i = gct01i;
    }

   
    // Property accessors

    public String getGct00c() {
        return this.gct00c;
    }
    
    public void setGct00c(String gct00c) {
        this.gct00c = gct00c;
    }

    public Integer getGct01i() {
        return this.gct01i;
    }
    
    public void setGct01i(Integer gct01i) {
        this.gct01i = gct01i;
    }
   



   public boolean equals(Object other) {
         if ( (this == other ) ) return true;
		 if ( (other == null ) ) return false;
		 if ( !(other instanceof Gcm20Id) ) return false;
		 Gcm20Id castOther = ( Gcm20Id ) other; 
         
		 return ( (this.getGct00c()==castOther.getGct00c()) || ( this.getGct00c()!=null && castOther.getGct00c()!=null && this.getGct00c().equals(castOther.getGct00c()) ) )
 && ( (this.getGct01i()==castOther.getGct01i()) || ( this.getGct01i()!=null && castOther.getGct01i()!=null && this.getGct01i().equals(castOther.getGct01i()) ) );
   }
   
   public int hashCode() {
         int result = 17;
         
         result = 37 * result + ( getGct00c() == null ? 0 : this.getGct00c().hashCode() );
         result = 37 * result + ( getGct01i() == null ? 0 : this.getGct01i().hashCode() );
         return result;
   }   





}
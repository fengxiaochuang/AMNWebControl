package com.amani.old.model;


/**
 * Gbm01Id generated by MyEclipse - Hibernate Tools
 */

public class Gbm01Id  implements java.io.Serializable {


    // Fields    

     private String gba00c;
     private String gba01c;


    // Constructors

    /** default constructor */
    public Gbm01Id() {
    }

    
    /** full constructor */
    public Gbm01Id(String gba00c, String gba01c) {
        this.gba00c = gba00c;
        this.gba01c = gba01c;
    }

   
    // Property accessors

    public String getGba00c() {
        return this.gba00c;
    }
    
    public void setGba00c(String gba00c) {
        this.gba00c = gba00c;
    }

    public String getGba01c() {
        return this.gba01c;
    }
    
    public void setGba01c(String gba01c) {
        this.gba01c = gba01c;
    }
   



   public boolean equals(Object other) {
         if ( (this == other ) ) return true;
		 if ( (other == null ) ) return false;
		 if ( !(other instanceof Gbm01Id) ) return false;
		 Gbm01Id castOther = ( Gbm01Id ) other; 
         
		 return ( (this.getGba00c()==castOther.getGba00c()) || ( this.getGba00c()!=null && castOther.getGba00c()!=null && this.getGba00c().equals(castOther.getGba00c()) ) )
 && ( (this.getGba01c()==castOther.getGba01c()) || ( this.getGba01c()!=null && castOther.getGba01c()!=null && this.getGba01c().equals(castOther.getGba01c()) ) );
   }
   
   public int hashCode() {
         int result = 17;
         
         result = 37 * result + ( getGba00c() == null ? 0 : this.getGba00c().hashCode() );
         result = 37 * result + ( getGba01c() == null ? 0 : this.getGba01c().hashCode() );
         return result;
   }   





}
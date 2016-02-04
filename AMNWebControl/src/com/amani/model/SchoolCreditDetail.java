package com.amani.model;

public class SchoolCreditDetail {

	private String no;  //学校编号
	private String subjectName;//课程名称;
	private Integer trainingNumber;//培训人数
	private Integer qualifiedNumber;//合格人数
    private double rate; //合格率
    
    
	public String getNo() {
		return no;
	}
	public void setNo(String no) {
		this.no = no;
	}
	public String getSubjectName() {
		return subjectName;
	}
	public void setSubjectName(String subjectName) {
		this.subjectName = subjectName;
	}
	public Integer getTrainingNumber() {
		return trainingNumber;
	}
	public void setTrainingNumber(Integer trainingNumber) {
		this.trainingNumber = trainingNumber;
	}
	public Integer getQualifiedNumber() {
		return qualifiedNumber;
	}
	public void setQualifiedNumber(Integer qualifiedNumber) {
		this.qualifiedNumber = qualifiedNumber;
	}
	public double getRate() {
		return rate;
	}
	public void setRate(double rate) {
		this.rate = rate;
	}
    
    
    

	
}

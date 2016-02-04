package com.amani.model;

import java.sql.Timestamp;

/**
 * Studentinfo entity. @author MyEclipse Persistence Tools
 */

public class Studentinfo implements java.io.Serializable {

	// Fields

	private Integer id;
	private String name;
	private Integer age;
	private String nation;
	private String nativeplace;
	private Integer educationlevels;
	private Integer sex;
	private String idcardnumber;
	private String idcardaddress;
	private String phone;
	private String homephone;
	private String studysubject;
	private Timestamp admissiontime;
	private String comeschoolway;
	private String expectcompany;
	private String graduationtype;
	private String remark;

	private String admissiontimeString;
	
	// Constructors

	/** default constructor */
	public Studentinfo() {
	}

	/** minimal constructor */
	public Studentinfo(Integer id) {
		this.id = id;
	}

	/** full constructor */
	public Studentinfo(Integer id, String name, Integer age, String nation,
			String nativeplace, Integer educationlevels, Integer sex,
			String idcardnumber, String idcardaddress, String phone,
			String homephone, String studysubject, Timestamp admissiontime,
			String comeschoolway, String expectcompany, String graduationtype,
			String remark) {
		this.id = id;
		this.name = name;
		this.age = age;
		this.nation = nation;
		this.nativeplace = nativeplace;
		this.educationlevels = educationlevels;
		this.sex = sex;
		this.idcardnumber = idcardnumber;
		this.idcardaddress = idcardaddress;
		this.phone = phone;
		this.homephone = homephone;
		this.studysubject = studysubject;
		this.admissiontime = admissiontime;
		this.comeschoolway = comeschoolway;
		this.expectcompany = expectcompany;
		this.graduationtype = graduationtype;
		this.remark = remark;
	}

	// Property accessors

	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Integer getAge() {
		return this.age;
	}

	public void setAge(Integer age) {
		this.age = age;
	}

	public String getNation() {
		return this.nation;
	}

	public void setNation(String nation) {
		this.nation = nation;
	}

	public String getNativeplace() {
		return this.nativeplace;
	}

	public void setNativeplace(String nativeplace) {
		this.nativeplace = nativeplace;
	}

	public Integer getEducationlevels() {
		return this.educationlevels;
	}

	public void setEducationlevels(Integer educationlevels) {
		this.educationlevels = educationlevels;
	}

	public Integer getSex() {
		return this.sex;
	}

	public void setSex(Integer sex) {
		this.sex = sex;
	}

	public String getIdcardnumber() {
		return this.idcardnumber;
	}

	public void setIdcardnumber(String idcardnumber) {
		this.idcardnumber = idcardnumber;
	}

	public String getIdcardaddress() {
		return this.idcardaddress;
	}

	public void setIdcardaddress(String idcardaddress) {
		this.idcardaddress = idcardaddress;
	}

	public String getPhone() {
		return this.phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getHomephone() {
		return this.homephone;
	}

	public void setHomephone(String homephone) {
		this.homephone = homephone;
	}

	public String getStudysubject() {
		return this.studysubject;
	}

	public void setStudysubject(String studysubject) {
		this.studysubject = studysubject;
	}

	

	public String getComeschoolway() {
		return this.comeschoolway;
	}

	public void setComeschoolway(String comeschoolway) {
		this.comeschoolway = comeschoolway;
	}

	public String getExpectcompany() {
		return this.expectcompany;
	}

	public void setExpectcompany(String expectcompany) {
		this.expectcompany = expectcompany;
	}

	public String getGraduationtype() {
		return this.graduationtype;
	}

	public void setGraduationtype(String graduationtype) {
		this.graduationtype = graduationtype;
	}

	public String getRemark() {
		return this.remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public Timestamp getAdmissiontime() {
		return admissiontime;
	}

	public void setAdmissiontime(Timestamp admissiontime) {
		this.admissiontime = admissiontime;
	}

	public String getAdmissiontimeString() {
		return admissiontimeString;
	}

	public void setAdmissiontimeString(String admissiontimeString) {
		this.admissiontimeString = admissiontimeString;
	}
	
    
}
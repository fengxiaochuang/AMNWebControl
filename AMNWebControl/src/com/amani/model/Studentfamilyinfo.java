package com.amani.model;

/**
 * Studentfamilyinfo entity. @author MyEclipse Persistence Tools
 */

public class Studentfamilyinfo implements java.io.Serializable {

	// Fields

	/**
	 * 
	 */
	private static final long serialVersionUID = -8974237555470423037L;
	private Integer id;
	private String name;
	private String relationship;
	private String workproperty;
	private String address;
	private String contactphone;
	private Integer stuid;

	// Constructors

	/** default constructor */
	public Studentfamilyinfo() {
	}

	/** minimal constructor */
	public Studentfamilyinfo(Integer id) {
		this.id = id;
	}

	/** full constructor */
	public Studentfamilyinfo(Integer id, String name, String relationship,
			String workproperty, String address, String contactphone,
			Integer stuid) {
		this.id = id;
		this.name = name;
		this.relationship = relationship;
		this.workproperty = workproperty;
		this.address = address;
		this.contactphone = contactphone;
		this.stuid = stuid;
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

	public String getRelationship() {
		return this.relationship;
	}

	public void setRelationship(String relationship) {
		this.relationship = relationship;
	}

	public String getWorkproperty() {
		return this.workproperty;
	}

	public void setWorkproperty(String workproperty) {
		this.workproperty = workproperty;
	}

	public String getAddress() {
		return this.address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getContactphone() {
		return this.contactphone;
	}

	public void setContactphone(String contactphone) {
		this.contactphone = contactphone;
	}

	public Integer getStuid() {
		return this.stuid;
	}

	public void setStuid(Integer stuid) {
		this.stuid = stuid;
	}

}
package com.amani.action.SchoolControl;

import java.util.List;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;

import com.amani.action.AMN_ReportAction;
import com.amani.model.Studentfamilyinfo;
import com.amani.model.Studentinfo;
import com.amani.service.SchoolControl.SCC008Service;
import com.amani.tools.SystemFinal;


@Scope("prototype")
@ParentPackage("json-default")
@Namespace("/scc008")
public class SCC008Action extends AMN_ReportAction{

	private static final long serialVersionUID = 1L;
	private List<Studentinfo> studentinfoList;   
	private Studentinfo studentinfo;
	private List<Studentfamilyinfo> studentfamilyinfo;   
	private String strMessage;
	private int sysStatus;
	private Studentfamilyinfo studentfamily;
	
	private String flag;
	
	
	@Autowired
	private SCC008Service scc008Service;
	
	//默认查询
	@Action( value="load", results={ @Result(type="json", name="load_success")})
	public String loadDataSet() {
		this.studentinfoList=scc008Service.loadDataSet();
		return SystemFinal.LOAD_SUCCESS;
	}
	
	//查询
	@Action( value="seach", results={ @Result(type="json", name="load_success")})
	public String seach() {
		this.studentinfoList=scc008Service.search(studentinfo);
		return SystemFinal.LOAD_SUCCESS;
	}
	
	

	/**
	 * 添加
	 * @return
	 */
	@Action( value="addStudent",results={ @Result(type="json", name="post_success")})
	public String addStudent() {
	     sysStatus=1;
		try{
			sysStatus = scc008Service.saveStudentinfo(studentinfo);
		}catch(Exception ex){
			ex.printStackTrace();
			sysStatus = 0;
		}
		strMessage = sysStatus==0 ? SystemFinal.POST_FAILURE_MSG : SystemFinal.POST_SUCCESS_MSG;
		return SystemFinal.POST_SUCCESS;
	}
	
	
	/**
	 * 根据学生id，获取家庭成员的信息
	 * @return
	 */
	@Action( value="loadFamilInfo",results={ @Result(type="json", name="load_success")})
	public String findFamilyInfo() {
		studentfamilyinfo=scc008Service.findFamilyInfo(studentinfo.getId());
		return SystemFinal.LOAD_SUCCESS;
	}
	
	/**
	 * 添加
	 * @return
	 */
	@Action( value="addStudentFamily",results={ @Result(type="json", name="post_success")})
	public String addStudentFamily() {
	     sysStatus=1;
		try{
			sysStatus = scc008Service.saveStudentinfoFamily(studentfamily);
		}catch(Exception ex){
			ex.printStackTrace();
			sysStatus = 0;
		}
		strMessage = sysStatus==0 ? SystemFinal.POST_FAILURE_MSG : SystemFinal.POST_SUCCESS_MSG;
		return SystemFinal.POST_SUCCESS;
	}
	
	
	
	public List<Studentinfo> getStudentinfoList() {
		return studentinfoList;
	}

	public void setStudentinfoList(List<Studentinfo> studentinfoList) {
		this.studentinfoList = studentinfoList;
	}

	public Studentinfo getStudentinfo() {
		return studentinfo;
	}

	public void setStudentinfo(Studentinfo studentinfo) {
		this.studentinfo = studentinfo;
	}

	public String getFlag() {
		return flag;
	}

	public void setFlag(String flag) {
		this.flag = flag;
	}

	public List<Studentfamilyinfo> getStudentfamilyinfo() {
		return studentfamilyinfo;
	}

	public void setStudentfamilyinfo(List<Studentfamilyinfo> studentfamilyinfo) {
		this.studentfamilyinfo = studentfamilyinfo;
	}

	public String getStrMessage() {
		return strMessage;
	}

	public void setStrMessage(String strMessage) {
		this.strMessage = strMessage;
	}

	public Studentfamilyinfo getStudentfamily() {
		return studentfamily;
	}

	public void setStudentfamily(Studentfamilyinfo studentfamily) {
		this.studentfamily = studentfamily;
	}

	public int getSysStatus() {
		return sysStatus;
	}

	public void setSysStatus(int sysStatus) {
		this.sysStatus = sysStatus;
	}

	
	
    
	

	//明细默认查询
//	@Action( value="loadDetailData", results={ @Result(type="json", name="load_success")})
//	public String loadDetailData() {
//		this.dataSet=this.scc007Service.loadDetailData(dateFrom, dateTo, staffNo, strMessage);
//		return SystemFinal.LOAD_SUCCESS;
//	}
	
	//导出Excel查询


	
	
	
}

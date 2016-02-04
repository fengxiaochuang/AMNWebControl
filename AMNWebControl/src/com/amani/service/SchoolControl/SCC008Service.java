package com.amani.service.SchoolControl;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.springframework.stereotype.Service;

import com.amani.model.Studentfamilyinfo;
import com.amani.model.Studentinfo;
import com.amani.service.AMN_ReportService;
import com.amani.tools.SystemFinal;

@Service
public class SCC008Service extends AMN_ReportService{
	
	//默认查询
	public  List<Studentinfo>  loadDataSet() {
		 List<Studentinfo> studentinfoList=this. amn_Dao.findByHql(" from Studentinfo");
		return studentinfoList;
	}

	
	//添加
	public  int  saveStudentinfo(Studentinfo studentinfo) {
		if(studentinfo != null){
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
			try {
				Date date=sdf.parse(studentinfo.getAdmissiontimeString());
				studentinfo.setAdmissiontime(getTimestamp(date));
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		//	studentinfo.setAdmissiontime();
			this.amn_Dao.saveOrUpdate(studentinfo);
			return 1;
		}
		return 0;
	}
	
	
	//添加
	public  int  saveStudentinfoFamily(Studentfamilyinfo studentfamily) {
		if(studentfamily != null){
			this.amn_Dao.saveOrUpdate( studentfamily);
			return 1;
		}
		return 0;
	}
	
	//按条件查询
	public  List<Studentinfo>  search(Studentinfo studentinfo) {
		StringBuffer hql=new StringBuffer("from Studentinfo t where 1=1");
		if(studentinfo.getName()!=null && !"".equals(studentinfo.getName())){
			hql.append(" and t.name like '%"+studentinfo.getName()+"%'");
		}
		
//		if(studentinfo.getAdmissiontime()!=null && !"".equals(studentinfo.getAdmissiontime())){
//			hql.append(" and t.name like '%"+studentinfo.getAdmissiontime()+"%'");
//		}
//		
		if(studentinfo.getAdmissiontimeString() !=null && !"".equals(studentinfo.getAdmissiontimeString())){
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
			try {
				Date date=sdf.parse(studentinfo.getAdmissiontimeString());
				hql.append(" and t.admissiontime >= '"+getStartTimestampByDate(date)+"'");
				hql.append(" and t.admissiontime < '"+getEndTimestampByDate(date)+"'");
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		if(studentinfo.getGraduationtype()!=null && !"".equals(studentinfo.getGraduationtype())){
			hql.append(" and t.graduationtype like "+studentinfo.getGraduationtype()+"");
		}
		
		 List<Studentinfo> studentinfoList=this. amn_Dao.findByHql(hql.toString());
		return studentinfoList;
	}
	
	
    public List<Studentfamilyinfo> findFamilyInfo(int id) {
	 List<Studentfamilyinfo> studentfamilyinfooList=this. amn_Dao.findByHql(" from Studentfamilyinfo where stuid="+id);	
		return studentfamilyinfooList;
	}
    
    
    /**
	 * 返回Date日期类型的结束时间，返回类型是Timestamp并包含秒表 2014-01-21 23:59:59.999
	 * 
	 * @param date
	 * @return
	 */
	public static Timestamp getEndTimestampByDate(Date date) {
		if (date == null)
			return null;
		Calendar c1 = Calendar.getInstance();
		c1.setTime(date);
		c1.set(Calendar.HOUR_OF_DAY, 23);
		c1.set(Calendar.MINUTE, 59);
		c1.set(Calendar.SECOND, 59);
		c1.set(Calendar.MILLISECOND, 999);
		return new Timestamp(c1.getTimeInMillis());
	}
	
	/**
	 * 返回Date日期类型的起始时间，返回类型是Timestamp并包含秒表 2014-01-21 00:00:00.0
	 * 
	 * @param date
	 * @return
	 */
	public static Timestamp getStartTimestampByDate(Date date) {
		if (date == null)
			return null;
		Calendar c1 = Calendar.getInstance();
		c1.setTime(date);
		c1.set(Calendar.HOUR_OF_DAY, 0);
		c1.set(Calendar.MINUTE, 0);
		c1.set(Calendar.SECOND, 0);
		c1.set(Calendar.MILLISECOND, 0);
		return new Timestamp(c1.getTimeInMillis());

	}
	
	
	/**
	 * Date日期类型转化为Timestamp类型 如果参数为空返回null
	 * 
	 * @param date
	 * @return
	 */
	public static Timestamp getTimestamp(Date date) {
		if (date == null)
			return null;
		else {
			return new Timestamp(date.getTime());
		}
	}
	
	public static String getTimestampStr(Timestamp ts) {
		if (ts == null)
			return null;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String tsStr = sdf.format(ts);
		return tsStr;
	}
}

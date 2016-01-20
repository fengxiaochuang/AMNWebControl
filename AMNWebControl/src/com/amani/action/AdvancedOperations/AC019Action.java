package com.amani.action.AdvancedOperations;

import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;

import jxl.Workbook;
import jxl.format.UnderlineStyle;
import jxl.write.Label;
import jxl.write.WritableCellFeatures;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;

import org.apache.struts2.json.annotations.JSON;
import org.codehaus.xfire.XFireFactory;
import org.codehaus.xfire.client.XFireProxyFactory;
import org.codehaus.xfire.service.Service;
import org.codehaus.xfire.service.binding.ObjectServiceFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;

import com.amani.bean.FaceId_EmployeeBean;
import com.amani.bean.FaceId_RecordBean;
import com.amani.model.AmnfaceMachineinfo;
import com.amani.model.Compscheduling;
import com.amani.model.StaffMachineinfo;
import com.amani.model.Staffinfo;
import com.amani.service.ICommonService;
import com.amani.service.AdvancedOperations.AC019Service;
import com.amani.tools.CommonTool;
import com.amani.tools.SystemFinal;
@Scope("prototype")
@ParentPackage("json-default")
@Namespace("/ac019")
public class AC019Action {
	@Autowired
	private AC019Service ac019Service;
	private String strJsonParam;
	private String strCurCompId;
	private String strCurCompName;
	private String strSearchType;
	private String strFromDate;
	private String strToDate;
	private String strMessage;
	private String leavestaffno;
	private String leavedate;
	private int	leavetype;
	private String leavemark;
	private String strFromTime;
	private String strToTime;
	private int fingerid;
	private List<AmnfaceMachineinfo> lsMachineDataSet;
	private List<Compscheduling>	lsCompscheduling=new ArrayList();
	private List<StaffMachineinfo> lsDateSet;
	private String mangerCardNo;
	private OutputStream os;
	private List<FaceId_EmployeeBean> lsFacesInfo;
	private String strOldFaceNo;
	private String strNewFaceNo;
	
	private String 	strEntryCompId;
	private int 	strEntrySeqno;
	private String 	strEntryMachineId;
	private int 	strMachineVersion;
	private String 	strEntryMachineIP;
	private String 	strStartDate;
	private String 	strEndDate;
	

    
	public String getStrEntryCompId() {
		return strEntryCompId;
	}
	public void setStrEntryCompId(String strEntryCompId) {
		this.strEntryCompId = strEntryCompId;
	}
	public String getStrEntryMachineId() {
		return strEntryMachineId;
	}
	public void setStrEntryMachineId(String strEntryMachineId) {
		this.strEntryMachineId = strEntryMachineId;
	}
	public int getStrMachineVersion() {
		return strMachineVersion;
	}
	public void setStrMachineVersion(int strMachineVersion) {
		this.strMachineVersion = strMachineVersion;
	}
	public String getStrEntryMachineIP() {
		return strEntryMachineIP;
	}
	public void setStrEntryMachineIP(String strEntryMachineIP) {
		this.strEntryMachineIP = strEntryMachineIP;
	}
	public String getStrStartDate() {
		return strStartDate;
	}
	public void setStrStartDate(String strStartDate) {
		this.strStartDate = strStartDate;
	}
	public String getStrEndDate() {
		return strEndDate;
	}
	public void setStrEndDate(String strEndDate) {
		this.strEndDate = strEndDate;
	}
	public String getStrOldFaceNo() {
		return strOldFaceNo;
	}
	public void setStrOldFaceNo(String strOldFaceNo) {
		this.strOldFaceNo = strOldFaceNo;
	}
	public String getStrNewFaceNo() {
		return strNewFaceNo;
	}
	public void setStrNewFaceNo(String strNewFaceNo) {
		this.strNewFaceNo = strNewFaceNo;
	}
	public List<FaceId_EmployeeBean> getLsFacesInfo() {
		return lsFacesInfo;
	}
	public void setLsFacesInfo(List<FaceId_EmployeeBean> lsFacesInfo) {
		this.lsFacesInfo = lsFacesInfo;
	}
	public OutputStream getOs() {
		return os;
	}
	public void setOs(OutputStream os) {
		this.os = os;
	}
	
	
	
	
	@Action( value="modifyFaceInfo", results={ @Result( type="json", name="load_success"),
			 @Result( type="json", name="load_failure")})
	public String modifyFaceInfo() {
		this.strMessage="";
		if(this.ac019Service.getDataTool().hasFunctionRights(CommonTool.getLoginInfo("USERID"), "AC019", SystemFinal.UR_SPECIAL_CHECK)==false)
		{
			this.strMessage=SystemFinal.NO_OPERATE_RIGHT;
			return SystemFinal.POST_FAILURE;
		}
		String strFingerMacineId=this.ac019Service.getDataTool().loadSysParam(strCurCompId,"SP072");
		boolean flag=this.ac019Service.handUpdateFaceInfo(strFingerMacineId,this.strCurCompId, this.strOldFaceNo, this.strNewFaceNo);
		if(flag==false)
		{
			this.strMessage="操作失败,请确认!";
		}
		else
		{
			try
			{
				FaceId_EmployeeBean record=this.ac019Service.loadBackFaceInfo(strFingerMacineId,strNewFaceNo);
				if(record!=null)
				{
					String strFingerMacineIp=this.ac019Service.getDataTool().loadSysParam(strCurCompId,"SP073");
					Service service = new ObjectServiceFactory().create(ICommonService.class);  
					XFireProxyFactory factory = new XFireProxyFactory(XFireFactory.newInstance().getXFire());  
					String url = "http://10.0.0.243:7003/AMNFaceWebService/services/CommonService";
					ICommonService commonService = (ICommonService) factory.create(service,url);
					flag=commonService.uploadEmpFaceInfoAllInfo(strFingerMacineIp, strNewFaceNo,record.getName(),record.getCard_num(),record.getCalid(),record.getFace_data());
					//flag=commonService.uploadEmpFaceInfo(strFingerMacineIp, strOldFaceNo,strFingerMacineIp, strNewFaceNo,record.getName());
					if(flag==true)
					{
						flag=commonService.deleteEmpFaceInfo(strFingerMacineIp, strOldFaceNo);
					}
					else
					{
						this.strMessage="操作失败,请确认!";
					}
				}
			}
			catch(Exception ex)
			{
				ex.printStackTrace();
			}
		
		}
		return SystemFinal.LOAD_SUCCESS;
	}
	
	
	public void createExcel() throws WriteException, IOException
	{
		try
		{
			//创建excel工作簿
			WritableWorkbook workbook= Workbook.createWorkbook(os);
			
			//创建新的一页
			WritableSheet sheet =workbook.createSheet("First Sheet", 0);
			//构造表头
			
			WritableFont bold=new WritableFont(WritableFont.ARIAL,10,WritableFont.BOLD);//设置字体种类和黑体显示
			
			WritableCellFormat titleFormate =new WritableCellFormat(bold);
			titleFormate.setAlignment(jxl.format.Alignment.CENTRE);//单元格的内容水平居中
			titleFormate.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);//单元格的内容垂直居中
			
			WritableCellFormat numberFormate =new WritableCellFormat();
			numberFormate.setAlignment(jxl.format.Alignment.RIGHT);//单元格的内容水平右对齐
			numberFormate.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);//单元格的内容垂直居中
			
			jxl.write.WritableFont wfc = new jxl.write.WritableFont(WritableFont.ARIAL, 10, 
					WritableFont.NO_BOLD, false, 
					UnderlineStyle.NO_UNDERLINE, jxl.format.Colour.RED); 
			WritableCellFormat totalNumberFormate =new WritableCellFormat(wfc);
			totalNumberFormate.setAlignment(jxl.format.Alignment.RIGHT);//单元格的内容水平右对齐
			totalNumberFormate.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);//单元格的内容垂直居中


			/****创建要显示的内容***/
			//标题
			Label head=new Label(0,0,strCurCompId+"["+strCurCompName+"]"+"门店考勤统计",titleFormate);
			sheet.setRowView(0, 500,false);
			sheet.addCell(head);
			
			//制表日期：
			Label makeDate=new Label(0,1,"制表日期：",titleFormate);
			sheet.addCell(makeDate);
			
			
			//制表日期值
			Label makeDateData=new Label(1,1,""+CommonTool.getDateMask(CommonTool.getCurrDate()));
			sheet.addCell(makeDateData);
			
			Label str0=new Label(0,2,"部门编号",titleFormate);
			sheet.addCell(str0);
			
			Label str1=new Label(1,2,"考勤日期",titleFormate);
			sheet.addCell(str1);
			
			Label str2=new Label(2,2,"星期",titleFormate);
			     
			sheet.addCell(str2);
			
			Label str3=new Label(3,2,"门店编号",titleFormate);
			sheet.addCell(str3);
			
			Label str4=new Label(4,2,"门店名称",titleFormate);
			sheet.addCell(str4);
			
			Label stra=new Label(5,2,"员工工号",titleFormate);
			sheet.addCell(stra);
		
			Label str6=new Label(6,2,"员工名称",titleFormate);
			sheet.addCell(str6);
			
			Label str7=new Label(7,2,"上班时间",titleFormate);
			sheet.addCell(str7);
			
			Label str8=new Label(8,2,"下班时间",titleFormate);
			sheet.addCell(str8);
			if(this.lsDateSet!=null&&this.lsDateSet.size()>0)
			{
				for(int i=0;i<this.lsDateSet.size();i++)
				{
					sheet.addCell(new Label(0,i+3,""+this.lsDateSet.get(i).getDepartment()));
					sheet.addCell(new Label(1,i+3,""+CommonTool.getDateMask(this.lsDateSet.get(i).getWorkdate())));
					sheet.addCell(new Label(2,i+3,""+this.lsDateSet.get(i).getWeekdate()));
					sheet.addCell(new Label(3,i+3,""+CommonTool.FormatString(this.lsDateSet.get(i).getCompno())));
					sheet.addCell(new Label(4,i+3,""+CommonTool.FormatString(this.lsDateSet.get(i).getCompname())));
					sheet.addCell(new Label(5,i+3,""+CommonTool.FormatString(this.lsDateSet.get(i).getStaffno())));
					sheet.addCell(new Label(6,i+3,""+CommonTool.FormatString(this.lsDateSet.get(i).getStaffname())));
					sheet.addCell(new Label(7,i+3,""+CommonTool.getTimeMask(this.lsDateSet.get(i).getAttime(),1)));
					sheet.addCell(new Label(8,i+3,""+CommonTool.getTimeMask(this.lsDateSet.get(i).getPttime(),1)));
				}
			}
			lsDateSet=null;
			workbook.write();
			workbook.close();
			os.close();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
	}
	@Action( value="loadFaceDataSet", results={ @Result( type="json", name="load_success"),
			 @Result( type="json", name="load_failure")})
	public String loadFaceDataSet()
	{
		try
		{
			Service service = new ObjectServiceFactory().create(ICommonService.class);  
			XFireProxyFactory factory = new XFireProxyFactory(XFireFactory.newInstance().getXFire());  
			String url = "http://10.0.0.243:7003/AMNFaceWebService/services/CommonService";
			ICommonService commonService = (ICommonService) factory.create(service,url);
			String strFingerMacineIp=this.ac019Service.getDataTool().loadSysParam(strCurCompId,"SP073");
//			if(strCurCompId.equals("001"))
//			{
//				strFingerMacineIp="10.0.1.44";
//			}
			this.lsFacesInfo=commonService.loadAllEmpFaceInfo(strFingerMacineIp);
			return SystemFinal.LOAD_SUCCESS;
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
			return SystemFinal.LOAD_SUCCESS;
		}
	}
	
	@Action( value="loadMachineinfo", results={ @Result( type="json", name="load_success"),
			 @Result( type="json", name="load_failure")})
	public String loadMachineinfo()
	{
		try
		{
			this.lsMachineDataSet=this.ac019Service.loadMachineInfo(strCurCompId);
			return SystemFinal.LOAD_SUCCESS;
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
			return SystemFinal.LOAD_SUCCESS;
		}
	}
	
	@Action( value="deleteMachineInfo", results={ @Result( type="json", name="delete_success"),
			 @Result( type="json", name="delete_failure")})
	public String deleteMachineInfo()
	{
		try
		{
			this.strMessage="";
			boolean flag=this.ac019Service.deleteMachine(strEntryCompId, strEntryMachineId, this.strEntrySeqno);
			if(flag==false)
			{
				this.strMessage="删除失败,请确认!";
			}
			return SystemFinal.DELETE_SUCCESS;
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
			return SystemFinal.DELETE_SUCCESS;
		}
	}
	
	
	@Action( value="handBandCompMachine", results={ @Result( type="json", name="load_success"),
			 @Result( type="json", name="load_failure")})
	public String handBandCompMachine()
	{
		try
		{
			this.strMessage="";
			boolean flag=this.ac019Service.insMachineInfo(strEntryCompId, strEntryMachineId, strMachineVersion, strEntryMachineIP, strStartDate, strEndDate);
			if(flag==false)
			{
				this.strMessage="新增失败!";
			}
			return SystemFinal.LOAD_SUCCESS;
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
			return SystemFinal.LOAD_SUCCESS;
		}
	}
	
	
	@Action(value = "loadFingerDataSet",  results = { 
			 @Result(name = "load_success", type = "json"),
			 @Result(name = "load_failure", type = "json")	
	}) 
	public String loadFingerDataSet()  //下载考勤
	{
		try
		{
			int kaoqingtype=Integer.parseInt(CommonTool.FormatString(this.ac019Service.getDataTool().loadSysParam(strCurCompId,"SP096")));
			if(strCurCompId.equals("001"))
			{
				kaoqingtype=2;
			}
			if(kaoqingtype==0)
			{
				strMessage="该门店使用的是打卡考勤机!";
				return SystemFinal.LOAD_SUCCESS;
			}
			else if(kaoqingtype==1) //指纹考勤
			{
				Service service = new ObjectServiceFactory().create(ICommonService.class);  
				XFireProxyFactory factory = new XFireProxyFactory(XFireFactory.newInstance().getXFire());  
				String url = "http://10.0.0.243:7001/AMNCommonService/services/CommonService";
				ICommonService commonService = (ICommonService) factory.create(service,url);
				strMessage="";
				int strFingerMacineId=Integer.parseInt(CommonTool.FormatString(this.ac019Service.getDataTool().loadSysParam(strCurCompId,"SP072")));
				String strFingerMacineIp=this.ac019Service.getDataTool().loadSysParam(this.strCurCompId,"SP073");
				if(CommonTool.FormatString(strFingerMacineIp).equals("") || CommonTool.FormatInteger(strFingerMacineId)==0)
				{
					strMessage="该门店未设置指纹信息设置";
					return SystemFinal.LOAD_SUCCESS;
				}
				int result=commonService.CKT_RegisterNet_local(strFingerMacineId,strFingerMacineIp);
				if(result==0)
				{
					strMessage="连接门店考勤机失败,请核实系统指纹信息设置";
					return SystemFinal.LOAD_SUCCESS;
				}
				result=commonService.CKT_NetDaemon_local();
				if(CommonTool.setDateMask(strFromDate).equals("") || CommonTool.setDateMask(strToDate).equals("") )
				{
					strMessage="请填写下载的起始日期";
					return SystemFinal.LOAD_SUCCESS;
				}
				if(Integer.parseInt(CommonTool.setDateMask(strFromDate))>Integer.parseInt(CommonTool.setDateMask(strToDate)))
				{
					strMessage="下载日期设置不正确";
					return SystemFinal.LOAD_SUCCESS;
				}
				int subDate=CommonTool.dateSubDate(CommonTool.setDateMask(strFromDate),CommonTool.setDateMask(strToDate));
				if(subDate>31)
				{
					strMessage="下载日期不能超过一个月";
					return SystemFinal.LOAD_SUCCESS;
				}
				if(strFromDate.equals(""))
					strFromDate=CommonTool.getCurrDate();
				else
					strFromDate=CommonTool.setDateMask(strFromDate);
				String strTargetDate=strFromDate;
				String strRecord="";
				int i=1;
				while( i<=subDate+1)
				{
					strRecord="";
					System.out.println(strTargetDate);
					
					 strRecord=commonService.GetClockingRecordProgress_localbyDate(strFingerMacineId,CommonTool.getDateMask(strTargetDate));
						if(strRecord.equals("null") || CommonTool.FormatString(strRecord).indexOf("{")==-1)
						{
							strMessage="当天没有考勤信息,请确认";
							i++;
							strTargetDate=CommonTool.datePlusDay(strTargetDate,1);
							continue;
						}
						if(!CommonTool.FormatString(strRecord).equals(""))
						{
							this.ac019Service.handStaffRecord(strFingerMacineId+"",strRecord,strTargetDate);
						}
						i++;
						strTargetDate=CommonTool.datePlusDay(strTargetDate,1);
				}
				return SystemFinal.LOAD_SUCCESS;
			}
			else
			{
				Service service = new ObjectServiceFactory().create(ICommonService.class);  
				XFireProxyFactory factory = new XFireProxyFactory(XFireFactory.newInstance().getXFire());  
				String url = "http://10.0.0.243:7003/AMNFaceWebService/services/CommonService";
				ICommonService commonService = (ICommonService) factory.create(service,url);
				String strFingerMacineId=CommonTool.FormatString(this.ac019Service.getDataTool().loadSysParam(strCurCompId,"SP072"));
				String strFingerMacineIp=this.ac019Service.getDataTool().loadSysParam(this.strCurCompId,"SP073");
//				if(strCurCompId.equals("001"))
//				{
//					//strFingerMacineIp="10.1.2.200";
//					strFingerMacineIp="10.0.1.44";
//				}
				if(CommonTool.FormatString(strFingerMacineIp).equals(""))
				{
					strMessage="该门店未设置指纹IP信息";
					return SystemFinal.LOAD_SUCCESS;
				}
				if(CommonTool.setDateMask(strFromDate).equals("") || CommonTool.setDateMask(strToDate).equals("") )
				{
					strMessage="请填写下载的起始日期";
					return SystemFinal.LOAD_SUCCESS;
				}
				if(Integer.parseInt(CommonTool.setDateMask(strFromDate))>Integer.parseInt(CommonTool.setDateMask(strToDate)))
				{
					strMessage="下载日期设置不正确";
					return SystemFinal.LOAD_SUCCESS;
				}
				int subDate=CommonTool.dateSubDate(CommonTool.setDateMask(strFromDate),CommonTool.setDateMask(strToDate));
				if(subDate>31)
				{
					strMessage="下载日期不能超过一个月";
					return SystemFinal.LOAD_SUCCESS;
				}
				if(strFromDate.equals(""))
					strFromDate=CommonTool.getCurrDate();
				else
					strFromDate=CommonTool.setDateMask(strFromDate);
				List<FaceId_RecordBean> lsRecord=commonService.loadEmpKqInfo(strFingerMacineIp, CommonTool.setDateMask(strFromDate), CommonTool.setDateMask(strToDate));
				if(lsRecord!=null && lsRecord.size()>0)
				{
						boolean flag=this.ac019Service.postStaffRecord(strFingerMacineId,strFromDate,strToDate,lsRecord);
						if(flag==false)
						{
							strMessage="下载失败,请刷新重试";
							return SystemFinal.LOAD_SUCCESS;
						}
				}
				lsRecord=null;
				return SystemFinal.LOAD_SUCCESS;
			}
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
			return SystemFinal.LOAD_FAILURE;
		}
	}
	
	@Action(value = "backupFingerDataSet",  results = { 
			 @Result(name = "load_success", type = "json"),
			 @Result(name = "load_failure", type = "json")	
	}) 
	public String backupFingerDataSet()  //下载考勤
	{
		try
		{
			this.strMessage="";
			int kaoqingtype=Integer.parseInt(CommonTool.FormatString(this.ac019Service.getDataTool().loadSysParam(strCurCompId,"SP096")));
			int strFingerMacineId=Integer.parseInt(CommonTool.FormatString(this.ac019Service.getDataTool().loadSysParam(strCurCompId,"SP072")));
			String strFingerMacineIp=this.ac019Service.getDataTool().loadSysParam(this.strCurCompId,"SP073");
			String strMachineId=this.ac019Service.getDataTool().loadSysParam(this.strCurCompId,"SP072");
			if(strCurCompId.equals("001"))
			{
				kaoqingtype=2;
				//strFingerMacineIp="10.1.2.200";
				//strFingerMacineIp="10.0.1.44";
			}
			if(kaoqingtype!=2)
			{
				strMessage="该门店没有使用人脸考勤机!";
				return SystemFinal.LOAD_SUCCESS;
			}
			Service service = new ObjectServiceFactory().create(ICommonService.class);  
			XFireProxyFactory factory = new XFireProxyFactory(XFireFactory.newInstance().getXFire());  
			String url = "http://10.0.0.243:7003/AMNFaceWebService/services/CommonService";
			ICommonService commonService = (ICommonService) factory.create(service,url);
			List<FaceId_EmployeeBean> lsRecord=commonService.loadAllEmpFaceInfo(strFingerMacineIp);
			if(lsRecord!=null && lsRecord.size()>0)
			{
				for(int i=0;i<lsRecord.size();i++)
				{
					commonService.postEmpFaceInfo(strMachineId,lsRecord.get(i).getId());
				}
			}
			return SystemFinal.LOAD_SUCCESS;
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
			return SystemFinal.LOAD_SUCCESS; 
		}
	}
	
	@Action(value = "postCompSchedulInfo",  results = { 
			 @Result(name = "post_success", type = "json"),
			 @Result(name = "post_failure", type = "json")	
       }) 
	public String postCompSchedulInfo()
	{
		this.strMessage="";
		if(!CommonTool.FormatString(strJsonParam).equals("") && strJsonParam.indexOf("[")>-1)
		{
			this.lsCompscheduling=this.ac019Service.getDataTool().loadDTOList(strJsonParam,Compscheduling.class);
			if(lsCompscheduling!=null && lsCompscheduling.size()>0)
			{
				for(int i=0;i<lsCompscheduling.size();i++)
				{
					if(!CommonTool.FormatString(lsCompscheduling.get(i).getSchedulno()).equals(""))
					{
						lsCompscheduling.get(i).setCompno(strCurCompId);
					}
				}
			}
		}
		boolean flag=this.ac019Service.postCompSchedulinfo(strCurCompId, lsCompscheduling);
		if(flag==false)
		{
			this.strMessage="保存失败!";
		}
		return SystemFinal.POST_SUCCESS;
	}
	@Action(value = "handStaffLeave",  results = { 
			 @Result(name = "post_success", type = "json"),
			 @Result(name = "post_failure", type = "json")	
      }) 
	public String handStaffLeave()
	{
		this.strMessage="";
		boolean flag=this.ac019Service.getDataTool().validateMangerPass(CommonTool.getLoginInfo("COMPID"), this.mangerCardNo);
		if(flag==false)
		{
			this.strMessage="该经理密码不对,请核实";
			return SystemFinal.POST_SUCCESS;
		}
		flag=this.ac019Service.postLeaveInfo(leavestaffno, leavedate, strFromTime, strToTime, leavetype, leavemark);
		if(flag==false)
		{
			this.strMessage="操作失败";
		}
		return SystemFinal.POST_SUCCESS;
	}
	
	public String getStrCurCompId() {
		return strCurCompId;
	}
	public void setStrCurCompId(String strCurCompId) {
		this.strCurCompId = strCurCompId;
	}
	public String getStrMessage() {
		return strMessage;
	}
	public void setStrMessage(String strMessage) {
		this.strMessage = strMessage;
	}
	
	public String getStrFromDate() {
		return strFromDate;
	}
	public void setStrFromDate(String strFromDate) {
		this.strFromDate = strFromDate;
	}
	public String getStrToDate() {
		return strToDate;
	}
	public void setStrToDate(String strToDate) {
		this.strToDate = strToDate;
	}

	public String getStrSearchType() {
		return strSearchType;
	}
	public void setStrSearchType(String strSearchType) {
		this.strSearchType = strSearchType;
	}
	

	public List<AmnfaceMachineinfo> getLsMachineDataSet() {
		return lsMachineDataSet;
	}
	public void setLsMachineDataSet(List<AmnfaceMachineinfo> lsMachineDataSet) {
		this.lsMachineDataSet = lsMachineDataSet;
	}
	public int getFingerid() {
		return fingerid;
	}

	public void setFingerid(int fingerid) {
		this.fingerid = fingerid;
	}

	public List<StaffMachineinfo> getLsDateSet() {
		return lsDateSet;
	}

	public void setLsDateSet(List<StaffMachineinfo> lsDateSet) {
		this.lsDateSet = lsDateSet;
	}
	@JSON(serialize=false)
	public AC019Service getAc019Service() {
		return ac019Service;
	}
	@JSON(serialize=false)
	public void setAc019Service(AC019Service ac019Service) {
		this.ac019Service = ac019Service;
	}

	public List<Compscheduling> getLsCompscheduling() {
		return lsCompscheduling;
	}

	public void setLsCompscheduling(List<Compscheduling> lsCompscheduling) {
		this.lsCompscheduling = lsCompscheduling;
	}

	public String getStrJsonParam() {
		return strJsonParam;
	}

	public void setStrJsonParam(String strJsonParam) {
		this.strJsonParam = strJsonParam;
	}

	public String getLeavestaffno() {
		return leavestaffno;
	}

	public void setLeavestaffno(String leavestaffno) {
		this.leavestaffno = leavestaffno;
	}

	public String getLeavedate() {
		return leavedate;
	}

	public void setLeavedate(String leavedate) {
		this.leavedate = leavedate;
	}

	public int getLeavetype() {
		return leavetype;
	}

	public void setLeavetype(int leavetype) {
		this.leavetype = leavetype;
	}

	public String getLeavemark() {
		return leavemark;
	}

	public void setLeavemark(String leavemark) {
		this.leavemark = leavemark;
	}

	public String getStrFromTime() {
		return strFromTime;
	}

	public void setStrFromTime(String strFromTime) {
		this.strFromTime = strFromTime;
	}

	public String getStrToTime() {
		return strToTime;
	}

	public void setStrToTime(String strToTime) {
		this.strToTime = strToTime;
	}

	public String getStrCurCompName() {
		return strCurCompName;
	}

	public void setStrCurCompName(String strCurCompName) {
		this.strCurCompName = strCurCompName;
	}
	public String getMangerCardNo() {
		return mangerCardNo;
	}
	public void setMangerCardNo(String mangerCardNo) {
		this.mangerCardNo = mangerCardNo;
	}
	public int getStrEntrySeqno() {
		return strEntrySeqno;
	}
	public void setStrEntrySeqno(int strEntrySeqno) {
		this.strEntrySeqno = strEntrySeqno;
	}

	
	
}

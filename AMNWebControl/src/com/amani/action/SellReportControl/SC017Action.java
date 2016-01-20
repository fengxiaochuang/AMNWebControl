package com.amani.action.SellReportControl;

import java.io.IOException;
import java.io.OutputStream;
import java.util.List;

import jxl.Workbook;
import jxl.format.UnderlineStyle;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;

import com.amani.action.AMN_ReportAction;
import com.amani.bean.SC015Bean;
import com.amani.bean.SC017Bean;
import com.amani.service.SellReportControl.SC017Service;
import com.amani.tools.CommonTool;
import com.amani.tools.SystemFinal;

@Scope("prototype")
@ParentPackage("json-default")
@Namespace("/sc017")
public class SC017Action extends AMN_ReportAction{
	private String strCompId;
	private String strDate;
	public OutputStream getOs() {
		return os;
	}

	public void setOs(OutputStream os) {
		this.os = os;
	}

	private String strToDate;
	private OutputStream os;
	public String getStrToDate() {
		return strToDate;
	}

	public void setStrToDate(String strToDate) {
		this.strToDate = strToDate;
	}

	private List<SC017Bean> lsBeans;
	private String strMessage;
	@Autowired
	private SC017Service sc017Service;
	
	@Action( value="query", results={ @Result( type="json", name="load_success"),
			 @Result( type="json", name="load_failure")})
	public String query()
	{
		strMessage="";
		lsBeans=sc017Service.loadSC017Data(strCompId, CommonTool.setDateMask(strDate),CommonTool.setDateMask(strToDate));
		if(lsBeans==null || lsBeans.size()<1)
		{
			strMessage="没有查询到数据";
		}
		return SystemFinal.LOAD_SUCCESS;
	}
	
	
	@Action(value = "loadExcel",  results = { 
			 @Result(name = "load_success", location = "/SellReportControl/SC017/sc017Excel.jsp"),
			 @Result(name = "load_failure",  location = "/SellReportControl/SC017/sc017Excel.jsp")	
	}) 
	public String loadExcel() {  //查询工资
		this.strMessage="";
		lsBeans=sc017Service.loadSC017Data(strCompId, CommonTool.setDateMask(strDate),CommonTool.setDateMask(strToDate));
		if(lsBeans==null || lsBeans.size()<1)
		{
			this.strMessage="没有查询到数据";
		}
		return SystemFinal.LOAD_SUCCESS;
	}
	
	
	public void createExcel() throws WriteException, IOException
	{
		try
		{
			int excelLength0=6;
			//创建excel工作簿
			WritableWorkbook workbook= Workbook.createWorkbook(os);
			WritableSheet sheet =workbook.createSheet("项目消费业绩统计", 0);
			sheet.mergeCells(0, 0, excelLength0-1, 0); //合并第一行，1到倒数第一行列
		
		
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
			Label head=new Label(0,0,"美容客户管理",titleFormate);
			sheet.setRowView(0, 500,false);
			sheet.addCell(head);
			
			//制表日期：
			Label makeDate=new Label(0,1,"制表日期：",titleFormate);
			sheet.addCell(makeDate);
			
			//制表日期值
			Label makeDateData=new Label(1,1,""+CommonTool.getDateMask(CommonTool.getCurrDate()));
			sheet.addCell(makeDateData);
			
			Label str0=new Label(0,2,"会员层次",titleFormate);
			sheet.addCell(str0);
			
			Label str1=new Label(1,2,"目标",titleFormate);
			sheet.addCell(str1);
			
			Label str2=new Label(2,2,"完成数量",titleFormate);
			sheet.addCell(str2);
			
			Label str3=new Label(3,2,"未完成数量",titleFormate);
			sheet.addCell(str3);
			
			/*Label str4=new Label(4,2,"季卡套数(美发)",titleFormate);
			sheet.addCell(str4);
			
			Label str5=new Label(5,2,"月卡套数(美发)",titleFormate);
			sheet.addCell(str5);
			
			Label str21=new Label(6,2,"年卡套数(美容)",titleFormate);
			sheet.addCell(str21);
			
			Label str32=new Label(7,2,"半年卡套数(美容)",titleFormate);
			sheet.addCell(str32);
			
			Label str43=new Label(8,2,"季卡套数(美容)",titleFormate);
			sheet.addCell(str43);
			
			Label str54=new Label(9,2,"月卡套数(美容)",titleFormate);
			sheet.addCell(str54);*/
			
			int index=3;
			
			if(lsBeans!=null && lsBeans.size()>0)
			{
				for(SC017Bean bean:lsBeans)
				{
					Label str6=new Label(0,index,bean.getStrType(),titleFormate);
					sheet.addCell(str6);
					
					Label str7=new Label(1,index,bean.getStrTarget(),titleFormate);
					sheet.addCell(str7);
					
					Label str8=new Label(2,index,bean.getJan()+"",titleFormate);
					sheet.addCell(str8);
					
					Label str9=new Label(3,index,bean.getFeb()+"",titleFormate);
					sheet.addCell(str9);
					
					/*Label str10=new Label(4,index,bean.getJkcount_mf()+"",titleFormate);
					sheet.addCell(str10);
					
					Label str11=new Label(5,index,bean.getMonthcount_mf()+"",titleFormate);
					sheet.addCell(str11);
					
					
					Label str14=new Label(6,index,bean.getYearcount_mr()+"",titleFormate);
					sheet.addCell(str14);
					
					Label str15=new Label(7,index,bean.getBncount_mr()+"",titleFormate);
					sheet.addCell(str15);
					
					Label str16=new Label(8,index,bean.getJkcount_mr()+"",titleFormate);
					sheet.addCell(str16);
					
					Label str17=new Label(9,index,bean.getMonthcount_mr()+"",titleFormate);
					sheet.addCell(str17);*/
					index++;
				}
			}
			workbook.write();
			workbook.close();
			os.close();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
	}

	public String getStrCompId() {
		return strCompId;
	}

	public void setStrCompId(String strCompId) {
		this.strCompId = strCompId;
	}

	public String getStrDate() {
		return strDate;
	}

	public void setStrDate(String strDate) {
		this.strDate = strDate;
	}

	public List<SC017Bean> getLsBeans() {
		return lsBeans;
	}

	public void setLsBeans(List<SC017Bean> lsBeans) {
		this.lsBeans = lsBeans;
	}

	public String getStrMessage() {
		return strMessage;
	}

	public void setStrMessage(String strMessage) {
		this.strMessage = strMessage;
	}

	public void setSc017Service(SC017Service sc017Service) {
		this.sc017Service = sc017Service;
	}
}

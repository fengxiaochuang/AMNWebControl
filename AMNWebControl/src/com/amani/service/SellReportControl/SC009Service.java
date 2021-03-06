package com.amani.service.SellReportControl;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import com.amani.action.AnlyResultSet;
import com.amani.bean.Compclasstraderesult;
import com.amani.bean.ProjectTypeAnalysis;


import com.amani.service.AMN_ReportService;
import com.amani.tools.CommonTool;
@Service
public class SC009Service extends AMN_ReportService{
	
	


	public List<ProjectTypeAnalysis> loadDateSetByCompId(String strCompId,String strDateFrom,String strDateTo)
	{
			ResultSet rs=null;
			String querySql="exec upg_compute_comp_prjchange_yeji '"+strCompId+"','"+strDateFrom+"','"+strDateTo+"' ";
			List<ProjectTypeAnalysis> dataSet=new ArrayList<ProjectTypeAnalysis>(); 
			try
			{
				rs=this.amn_Dao.executeQuery(querySql);
				List lsType=this.getPrjType();
				while(rs!=null && rs.next())
				{
					ProjectTypeAnalysis record=new ProjectTypeAnalysis();
					record.setStrCompId(rs.getString("compid"));
					record.setStrCompName(rs.getString("compname"));
					if(lsType != null && lsType.size()>0)
					{
						double prjtypes[][]=new double[lsType.size()][1];
						String strFile="";
						for(int i=0;i<lsType.size();i++)
						{
							strFile=lsType.get(i)+"Amt";
							prjtypes[i][0]=(CommonTool.FormatDouble(rs.getDouble(strFile)));
						}
						record.setPrjTypesAmt(prjtypes);
					}
					dataSet.add(record);
				}
				if(dataSet==null || dataSet.size()<1)
				{
					return null;
				}
				
				return dataSet;
			}
			catch (Exception e) {
				e.printStackTrace();
				return null;
			}
			finally
			{
				try
				{
					rs.close();
				}
				catch (Exception e) {
					e.printStackTrace();
				}
			}
		
	}
	public List  getPrjType()
	{
		String strSql="select parentcodekey from commoninfo with(NOLOCK) where  infotype='XMTJ' order by parentcodekey ";
		AnlyResultSet<List> analysis = new AnlyResultSet<List>() {
			public List anlyResultSet(ResultSet rs) {
				List returnValue=new ArrayList();
				try {
					while (rs != null && rs.next() == true) {
						
						returnValue.add(rs.getString("parentcodekey"));
					}
				} catch (Exception e) {
					e.printStackTrace();
					returnValue =null;
				}
				return returnValue;
			}
		};
		List ls= (List) this.amn_Dao.executeQuery_ex(strSql, analysis);
		analysis=null;
		return ls;		
	}
	
	
	
}

package com.amani.service.SchoolControl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import com.amani.model.SchoolCreditDetail;
import com.amani.model.SchoolInfo;
import com.amani.service.AMN_ModuleService;

/**
 * 合作学校设定
 */
@Service
public class SCC001Service extends AMN_ModuleService{
	
	public List<SchoolCreditDetail> getCreditDetail(String no){
		String sql="select sct.no no,sct.name name ,(select count(*) from schoolemployee se where se.credit=sct.no) trainingNumber,(select count(*) from schoolemployee se where se.credit=sct.no and se.ispass=1) qualifiedNumber from schoolcredit sct where sct.school_no='"+no+"'";
		List<Object[]> list=this.amn_Dao.findBySql2(sql);
		List<SchoolCreditDetail>  listDetail=new ArrayList<SchoolCreditDetail>();
		for(int i=0;i<list.size();i++){
			SchoolCreditDetail obj=new SchoolCreditDetail();
			Object[] objs=list.get(i);
			
			obj.setNo(objs[0]+"");
			obj.setSubjectName(objs[1]+"");
			obj.setTrainingNumber(Integer.parseInt(objs[2]+""));
			obj.setQualifiedNumber(Integer.parseInt(objs[3]+""));
			if(Integer.parseInt(objs[2]+"")==0){
				obj.setRate(0);
			}else{
				double b1=Double.parseDouble(objs[3].toString());
				double b2=Double.parseDouble(objs[2].toString());
				
				double  b  =  (double)(Math.round(b1/b2*100))/100;
				
				obj.setRate(b);
			}
			listDetail.add(obj);
		}
		return listDetail;
	}
	
	
	@SuppressWarnings("unchecked")
	public List<SchoolInfo> loadDataSet() throws Exception {
		return this.amn_Dao.findByHql("from SchoolInfo where state=1");
	}
	
	@SuppressWarnings("unchecked")
	public List<SchoolInfo> queryDataSet(String name) throws Exception {
		this.amn_Dao.setModel(SchoolInfo.class);
		String queryStr = "from SchoolInfo where state=1 and name like :nameVal";
		String[] params = new String[]{"nameVal"};
		Object[] values = new Object[]{"%"+name+"%"};
		return this.amn_Dao.findByParams(queryStr, params, values);
	}
	
	public int save(SchoolInfo schoolInfo){
		if(schoolInfo != null){
			this.amn_Dao.saveOrUpdate(schoolInfo);
			return 1;
		}
		return 0;
	}

	@Override
	protected boolean deleteDetail(Object curMaster) {
		return false;
	}

	@Override
	protected boolean deleteMaster(Object curMaster) {
		return false;
	}

	@Override
	protected boolean postMaster(Object curMaster) {
		return false;
	}

	@Override
	protected boolean postDetail(Object details) {
		return false;
	}

	@Override
	public List<?> loadMasterDataSet(int pageSize, int startRow) {
		return null;
	}
}
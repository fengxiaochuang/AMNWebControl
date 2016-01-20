	
	--declare @tocompid varchar(10)  
	--declare cur_each_comp cursor for  
	--select curcompno from compchainstruct where complevel=4 
	--and curcompno  in ('035','036','038','043','045','301','302','303') order by  curcompno
	--open cur_each_comp  
	--fetch cur_each_comp into @tocompid  
	--while @@fetch_status = 0  
	--begin  
	--	exec upg_prepare_ticheng_analysis_after_Sum @tocompid,'20140201','20140228' 
	--	fetch cur_each_comp into @tocompid  
	--end  
	--close cur_each_comp  
	--deallocate cur_each_comp 
	
	select strCompId,strCompName,
		 SUM(convert(numeric(20,0),case  when  ISNULL(staffcurstate,0)=2 then ISNULL(factpaysalary,0) else 0 end) ),
		 SUM(convert(numeric(20,0),case  when  ISNULL(staffcurstate,0)=4  then ISNULL(factpaysalary,0) else 0 end )),
		 SUM(convert(numeric(20,0),case  when  ISNULL(staffcurstate,0)=3  then ISNULL(factpaysalary,0) else 0 end ))
	 from compute_staff_work_salary_byday 
	 where  computeday='20140301'
	 group by  strCompId,strCompName
	 order by strCompId
	
	--�ŵ��ܶ�
	select strCompId,strCompName,
		SUM(convert(numeric(20,0),case  when  ISNULL(staffcurstate,2)=2 and ISNULL(staffsocials,0)>0  and ISNULL(staffsocialsource,'')<>'�ϲ��ֹ�˾' then ISNULL(factpaysalary,0) else 0 end )),
		SUM(convert(numeric(20,0),case  when  ISNULL(staffcurstate,2)=2 and ISNULL(staffsocials,0)=0 and strCompId not in   ('035','036','038','043','045','301','302','303') then ISNULL(factpaysalary,0) else 0 end )),
		SUM(convert(numeric(20,0),case  when  ISNULL(staffcurstate,2)=4  and ISNULL(staffsocialsource,'')<>'�ϲ��ֹ�˾' and strCompId not in   ('035','036','038','043','045','301','302','303') then ISNULL(factpaysalary,0) else 0 end )),
		SUM(convert(numeric(20,0),case  when  ISNULL(staffcurstate,2)=3  and ISNULL(staffsocialsource,'')<>'�ϲ��ֹ�˾' and strCompId not in   ('035','036','038','043','045','301','302','303') then ISNULL(factpaysalary,0) else 0 end ))
	 from compute_staff_work_salary_byday 
	 where  computeday='20140301' 
	 group by  strCompId,strCompName
	 order by strCompId
	


	 
	 --���籣,�����п�,��ְ(8000��)
	 select strCompId,strCompName,staffno,staffname,staffpositionname,staffsocialsource,staffpcid,staffbankaccountno
	 ,factpaysalary= convert(numeric(20,0),case when isnull(needpaysalary,0)>8000 then   convert(numeric(20,0),isnull(factpaysalary,0))-convert(numeric(20,0),(isnull(needpaysalary,0)-8000)) else isnull(factpaysalary,0) end) 
	 from compute_staff_work_salary_byday 
	 where  computeday='20140301' and ISNULL(staffsocials,0)>0 and len(ISNULL(staffbankaccountno,''))>10 and ISNULL(staffcurstate,2)=2   and isnull(factpaysalary,0)>0 and ISNULL(staffsocialsource,'')<>'�ϲ��ֹ�˾'
 	  --and strCompId not in   ('035','036','038','043','045','301','302','303')
 	 order by staffsocialsource,strCompId,strCompName 
 	 
 	 
 	  --���籣,�����п�,��ְ(8000�ⲹ��)
	 select strCompId,strCompName,staffno,staffname,staffpositionname,staffsocialsource,staffpcid,staffbankaccountno
	 ,factpaysalary=convert(numeric(20,0),(isnull(needpaysalary,0)-8000))
	 from compute_staff_work_salary_byday 
	 where computeday='20140301' and ISNULL(staffsocials,0)>0 and len(ISNULL(staffbankaccountno,''))>10 and ISNULL(staffcurstate,2)=2 and  isnull(needpaysalary,0)>8000  and ISNULL(staffsocialsource,'')<>'�ϲ��ֹ�˾'
 	  -- and strCompId not in   ('035','036','038','043','045','301','302','303')
 	 order by staffsocialsource,strCompId,strCompName 
 	 
 	 --���籣,�����п�,��ְ
 	  select strCompId,strCompName,staffno,staffname,staffpositionname,staffsocialsource,staffpcid,staffbankaccountno,convert(numeric(20,0),isnull(factpaysalary,0))
		 from compute_staff_work_salary_byday 
	 where computeday='20140301' and  ISNULL(staffsocials,0)=0 and len(ISNULL(staffbankaccountno,''))>10 and ISNULL(staffcurstate,2)=2  and isnull(factpaysalary,0)>0
 	   and strCompId not in   ('035','036','038','043','045','301','302','303')
 	 order by strCompId,strCompName 
 	 

 	 

 	 --��ְ �����п� ���籣(8000��)
	 select strCompId,strCompName,staffno,staffname,staffpositionname,staffsocialsource,staffpcid,staffbankaccountno
	 ,factpaysalary= convert(numeric(20,0),case when isnull(needpaysalary,0)>8000 then   convert(numeric(20,0),isnull(factpaysalary,0))-convert(numeric(20,0),(isnull(needpaysalary,0)-8000)) else isnull(factpaysalary,0) end) 
	 from compute_staff_work_salary_byday 
	 where computeday='20140301' and ISNULL(staffsocials,0)>0 and len(ISNULL(staffbankaccountno,''))>10 and ISNULL(staffcurstate,0)=3   and isnull(factpaysalary,0)>0
 	  and ISNULL(staffsocialsource,'')<>'�ϲ��ֹ�˾'
 	 order by staffsocialsource,strCompId,strCompName 
 	 
 	 
 	  --��ְ ���籣,�����п�(8000�ⲹ��)
	 select strCompId,strCompName,staffno,staffname,staffpositionname,staffsocialsource,staffpcid,staffbankaccountno
	 ,factpaysalary=convert(numeric(20,0),(isnull(needpaysalary,0)-8000))
	 from compute_staff_work_salary_byday 
	 where computeday='20140301' and ISNULL(staffsocials,0)>0 and len(ISNULL(staffbankaccountno,''))>10 and ISNULL(staffcurstate,0)=3 and  isnull(needpaysalary,0)>8000 
 	 and ISNULL(staffsocialsource,'')<>'�ϲ��ֹ�˾'
 	 order by staffsocialsource,strCompId,strCompName 
 	 
 	  --���籣,�����п�,��ְ
 	  select strCompId,strCompName,staffno,staffname,staffpositionname,staffsocialsource,staffpcid,staffbankaccountno,convert(numeric(20,0),isnull(factpaysalary,0))
	 from compute_staff_work_salary_byday 
	 where computeday='20140301' and ISNULL(staffsocials,0)=0 and len(ISNULL(staffbankaccountno,''))>10 and ISNULL(staffcurstate,0)=3  and isnull(factpaysalary,0)>0
 	 and strCompId not in   ('035','036','038','043','045','301','302','303')
 	 order by strCompId,strCompName 
 	 
 	 --��ְ �����п� 
 	  select strCompId,strCompName,staffno,staffname,staffpositionname,staffsocialsource,staffpcid,staffbankaccountno,convert(numeric(20,0),isnull(factpaysalary,0))
	 from compute_staff_work_salary_byday 
	 where computeday='20140301'  and len(ISNULL(staffbankaccountno,''))<10 and ISNULL(staffcurstate,2)=2   and isnull(factpaysalary,0)>0
 	 	 and strCompId not in   ('035','036','038','043','045','301','302','303')
 	 order by strCompId,strCompName 
 	 

 	 
 	 
 	  --��ְ �����п�
 	  select strCompId,strCompName,staffno,staffname,staffpositionname,staffsocialsource,staffpcid,staffbankaccountno,convert(numeric(20,0),isnull(factpaysalary,0))
	 from compute_staff_work_salary_byday 
	 where computeday='20140301' and  len(ISNULL(staffbankaccountno,''))<10 and ISNULL(staffcurstate,0)=3  and isnull(factpaysalary,0)>0
 	and strCompId not in   ('035','036','038','043','045','301','302','303')
 	 order by strCompId,strCompName 
 	 
 	 --����
 	 select strCompId,strCompName,staffno,staffname,staffpositionname,staffsocialsource,staffpcid,staffbankaccountno,convert(numeric(20,0),isnull(factpaysalary,0))
	 from compute_staff_work_salary_byday 
	 where computeday='20140301' and  ISNULL(staffcurstate,0)=4  and isnull(factpaysalary,0)>0
 	and strCompId not in   ('035','036','038','043','045','301','302','303')
 	 order by strCompId,strCompName 
 	 
 	 
		
		
		 --���籣
	 select �ŵ���=strCompId,�ŵ�����=strCompName,�ܸ���ҵ��=convert(numeric(20,2),sum(isnull(stafftotalyeji,0))),
								  ���ŵ�ҵ��=convert(numeric(20,2),sum(isnull(staffshopyeji,0))),
								  �ܵ�н=convert(numeric(20,2),sum(isnull(staffbasesalary,0))),
								  ������ʦ����=convert(numeric(20,2),sum(isnull(beatysubsidy,0))),
								  �ܱ��ײ���=convert(numeric(20,2),sum(isnull(staffsubsidy,0))),
								  ���ŵ겹��=convert(numeric(20,2),sum(isnull(storesubsidy,0))),
								  �ܽ���=convert(numeric(20,2),sum(isnull(staffreward,0))),
								  �ܲ������=convert(numeric(20,2),sum(isnull(staffamtchange,0))),
								  ����ְ�ۿ�=convert(numeric(20,2),sum(isnull(leaveldebit,0))),
								  �ܳٵ��ۿ�=convert(numeric(20,2),sum(isnull(latdebit,0))),
								  ��Ա������=convert(numeric(20,2),sum(isnull(staffdaikou,0))),
								  �ܷ���=convert(numeric(20,2),sum(isnull(staffdebit,0))),
								  ���籣=convert(numeric(20,2),sum(isnull(staffsocials,0))),
								  ��ס�޷�=convert(numeric(20,2),sum(isnull(staydebit,0))),
								  ��ѧϰ��=convert(numeric(20,2),sum(isnull(studydebit,0))),
								  �ܳɱ�=convert(numeric(20,2),sum(isnull(staffcost,0))),
								  �ܿ�˰=convert(numeric(20,2),sum(isnull(salarydebit,0))),
								  �����ν𷵻�=convert(numeric(20,2),sum(isnull(zerenjinback,0))),
								  �����ν�ۿ�=convert(numeric(20,2),sum(isnull(zerenjincost,0))),
								  �ܹ���=convert(numeric(20,2),sum(isnull(factpaysalary,0)))
	 from compute_staff_work_salary_byday 
	 where computeday='20140301'  and ISNULL(factpaysalary,0)>0
	 group by strCompId,strCompName
 	 order by strCompId
 	 
 	 select �ŵ���=strCompId,�ŵ�����=strCompName,b.staffno,b.staffname,b.pccid,
 								  �ܸ���ҵ��=convert(numeric(20,2),(isnull(stafftotalyeji,0))),
								  ���ŵ�ҵ��=convert(numeric(20,2),(isnull(staffshopyeji,0))),
								  �ܵ�н=convert(numeric(20,2),(isnull(staffbasesalary,0))),
								  ������ʦ����=convert(numeric(20,2),(isnull(beatysubsidy,0))),
								  �ܱ��ײ���=convert(numeric(20,2),(isnull(staffsubsidy,0))),
								  ���ŵ겹��=convert(numeric(20,2),(isnull(storesubsidy,0))),
								  �ܽ���=convert(numeric(20,2),(isnull(staffreward,0))),
								  �Ͽ����=convert(numeric(20,2),(isnull(oldcustomerreward,0))),
								  �ܲ������=convert(numeric(20,2),(isnull(staffamtchange,0))),
								  ����ְ�ۿ�=convert(numeric(20,2),(isnull(leaveldebit,0))),
								  �ܳٵ��ۿ�=convert(numeric(20,2),(isnull(latdebit,0))),
								  ��Ա������=convert(numeric(20,2),(isnull(staffdaikou,0))),
								  �ܷ���=convert(numeric(20,2),(isnull(staffdebit,0))),
								  �籣����=isnull(staffsocialsource,0),
								  ���籣=convert(numeric(20,2),(isnull(staffsocials,0))),
								  ��ס�޷�=convert(numeric(20,2),(isnull(staydebit,0))),
								  ��ѧϰ��=convert(numeric(20,2),(isnull(studydebit,0))),
								  �ܳɱ�=convert(numeric(20,2),(isnull(staffcost,0))),
								  �ܿ�˰=convert(numeric(20,2),(isnull(salarydebit,0))),
								  �����ν𷵻�=convert(numeric(20,2),(isnull(zerenjinback,0))),
								  �����ν�ۿ�=convert(numeric(20,2),(isnull(zerenjincost,0))),
								  �ܹ���=convert(numeric(20,2),(isnull(factpaysalary,0)))
	 from compute_staff_work_salary_byday a,staffinfo b
	 where computeday='20140601'  and a.staffinid=b.manageno and ISNULL(b.stafftype,0)=0
 	 order by strCompId
 	 
 	 
 	  --���籣,�����п�,��ְ(8000�ⲹ��)
	 select  strCompId,strCompName,staffno,staffname,staffpositionname,staffsocialsource,staffpcid,staffbankaccountno,
		workdays,stafftotalyeji,staffshopyeji,staffbasesalary,beatysubsidy,staffsubsidy,storesubsidy,staffreward,
		staffamtchange,basestaffpayamt,leaveldebit,latdebit,staffdaikou,staffdebit,needpaysalary=convert(numeric(20,0),isnull(needpaysalary,0)),staffsocials,
		staydebit,studydebit,staffcost,salarydebit,zerenjinback,zerenjincost,factpaysalary=convert(numeric(20,0),isnull(factpaysalary,0))
	 from compute_staff_work_salary_byday 
	 where computeday='20140301'  ISNULL(staffsocials,0)=0
 	 order by staffsocialsource,strCompId,strCompName
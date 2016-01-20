
    delete staff_work_salary_jiesuan
	declare @tocompid varchar(10)  
	declare cur_each_comp cursor for  
	select curcompno from compchainstruct where complevel=4 and curcompno in ('035','036','038','043','045') order by  curcompno
	open cur_each_comp  
	fetch cur_each_comp into @tocompid  
	while @@fetch_status = 0  
	begin  
		exec upg_prepare_ticheng_analysis_after_jiesuan @tocompid,'20140201','20140228' 
		fetch cur_each_comp into @tocompid  
	end  
	close cur_each_comp  
	deallocate cur_each_comp 
	select 	strCompId,strCompName	,staffno,	staffinid,	staffname,	staffpositionname,	staffsocialsource,	staffpcid,	staffbankaccountno,
		workdays,	stafftotalyeji,	staffshopyeji,	staffbasesalary,	beatysubsidy,	staffsubsidy,	storesubsidy,	staffreward,
		staffamtchange,	basestaffpayamt,	leaveldebit,	latdebit,	staffdaikou,	staffdebit,	needpaysalary,	staffsocials,
			staydebit,	studydebit,	staffcost,	salarydebit,	factpaysalary
	 from staff_work_salary_jiesuan order by strCompId,strCompName
	 
	 
	 	select 		convert(numeric(20,1),sum(isnull(needpaysalary,0)))	,	convert(numeric(20,5),sum(isnull(factpaysalary,0)))
	 from staff_work_salary_jiesuan

	 
	
																									
  --insert staff_work_salary_sebao(strCompId,strCompName,staffno,staffinid,staffname,staffposition,staffpositionname,staffpcid,staffbankaccountno,workdays,computedays,          
  --       stafftotalyeji,staffshopyeji,staffbasesalary,beatysubsidy,leaveldebit,staffsubsidy,staffdebit,staffdaikou,latdebit,staffcost,          
  --       staffreward,otherdebit,staffsocials,needpaysalary,staydebit,studydebit,salarydebit,factpaysalary,staffmark ,      
  --       basestaffamt,staffsocialsource,staffamtchange,stafftargetreward,basestaffpayamt,storesubsidy ,markflag )    
  
  
  
 -- create table staff_work_salary_jiesuan     
 -- (      
	--strCompId				varchar(10)		null,   --�ŵ���      
	--strCompName				varchar(10)		null,   --�ŵ�����  
	--staffno					varchar(20)		null,   --Ա�����      
	--staffinid				varchar(20)		null,   --Ա���ڲ���� 
	--arrivaldate				varchar(8 )		NULL    ,--��ְ����     
	--staffname				varchar(30)		null,   --Ա������      
	--staffposition			varchar(10)		null,   --Ա��ְλ    
	--staffsocialsource		varchar(20)		null,	--�籣����  
	--staffpcid				varchar(20)		null,   --Ա�����֤      
	--staffmark				varchar(300)	null,   --Ա����ע      
	--staffbankaccountno		varchar(30)		null,   --Ա�������˺�      
	--resulttye				varchar(5)		NULL,	--ҵ����ʽ 0--��ȷ�ʽ -������ҵ��  2 ����ʵҵ��      
	--resultrate				float			NULL,	--ҵ��ϵ��      
	--baseresult				float			NULL,   --ҵ������      
	--computedays				int				NULL,   --��������      
	--workdays				int				NULL,   --ȱ������    
	--inserworkdays			int				NULL,   --ҵ������    
	--stafftotalyeji			float			null,   --Ա����ҵ��      
	--staffshopyeji			float			null,   --Ա���ŵ�ҵ��      
	--salaryflag				int				null,   --˰ǰ ,˰��       
	--staffbasesalary			float			null,   --Ա����������      
	--beatysubsidy			float			null,   --���ݲ���      
	--leaveldebit				float			null,   --��ְ�ۿ�   
	--basestaffamt			float			null,   --�ذ�����   
	--basestaffpayamt			float			null,   --�ذ�����֧��  
	--staffsubsidy			float			null,   --Ա������  
	--storesubsidy			float			null,   --�ŵ겹��(����+�ŵ겹��)      
	--staffdebit				float			null,   --����
	--staffdaikou				float			null,   --����
	--latdebit				float			null,   --�ٵ�      
	--staffreward				float			null,   --���� 
	--yearreward				float			null,	--���ս�
	--staffamtchange			float			null,   --�������   
	--stafftargetreward		float			null,   --ָ�꽱��     
	--otherdebit				float			null,   --�����ۿ�      
	--staffsocials			float			null,   --�籣      
	--needpaysalary			float			null,   --Ӧ������      
	--staydebit				float			null,   --ס��      
	--studydebit				float			null,   --ѧϰ����      
	--staffcost				float			null,   --�ɱ�      
	--salarydebit				float			null,   --��˰      
	--factpaysalary			float			null,   --Ӧ������      
	--staffpositionname		varchar(30)		null,   --Ա��ְλ  
	--absencesalary			int				NULL,	--ȱ�ڵ�н�㷨    
	--markflag				int				NULL,	--���
 -- )       
       
 
 
 create table staff_work_salary_sum     
  (      
	strCompId				varchar(10)		null,   --�ŵ���      
	strCompName				varchar(10)		null,   --�ŵ�����  
	staffno					varchar(20)		null,   --Ա�����      
	staffinid				varchar(20)		null,   --Ա���ڲ���� 
	arrivaldate				varchar(8 )		NULL    ,--��ְ����     
	staffname				varchar(30)		null,   --Ա������      
	staffposition			varchar(10)		null,   --Ա��ְλ    
	staffsocialsource		varchar(20)		null,	--�籣����  
	staffpcid				varchar(20)		null,   --Ա�����֤      
	staffmark				varchar(300)	null,   --Ա����ע      
	staffbankaccountno		varchar(30)		null,   --Ա�������˺�      
	resulttye				varchar(5)		NULL,	--ҵ����ʽ 0--��ȷ�ʽ -������ҵ��  2 ����ʵҵ��      
	resultrate				float			NULL,	--ҵ��ϵ��      
	baseresult				float			NULL,   --ҵ������      
	computedays				int				NULL,   --��������      
	workdays				int				NULL,   --ȱ������    
	inserworkdays			int				NULL,   --ҵ������    
	stafftotalyeji			float			null,   --Ա����ҵ��      
	staffshopyeji			float			null,   --Ա���ŵ�ҵ��      
	salaryflag				int				null,   --˰ǰ ,˰��       
	staffbasesalary			float			null,   --Ա����������      
	beatysubsidy			float			null,   --���ݲ���      
	leaveldebit				float			null,   --��ְ�ۿ�   
	basestaffamt			float			null,   --�ذ�����   
	basestaffpayamt			float			null,   --�ذ�����֧��  
	staffsubsidy			float			null,   --Ա������  
	storesubsidy			float			null,   --�ŵ겹��(����+�ŵ겹��)      
	staffdebit				float			null,   --����
	staffdaikou				float			null,   --����
	latdebit				float			null,   --�ٵ�      
	staffreward				float			null,   --���� 
	yearreward				float			null,	--���ս�
	staffamtchange			float			null,   --�������   
	zerenjinback			float			null,   --���ν𷵻�
	zerenjincost			float			null,   --���ν�ۿ�
	stafftargetreward		float			null,   --ָ�꽱��     
	otherdebit				float			null,   --�����ۿ�      
	staffsocials			float			null,   --�籣      
	needpaysalary			float			null,   --Ӧ������      
	staydebit				float			null,   --ס��      
	studydebit				float			null,   --ѧϰ����      
	staffcost				float			null,   --�ɱ�      
	salarydebit				float			null,   --��˰      
	factpaysalary			float			null,   --Ӧ������      
	staffpositionname		varchar(30)		null,   --Ա��ְλ  
	absencesalary			int				NULL,	--ȱ�ڵ�н�㷨  
	staffcurstate			int				null,	--Ա����ְ״̬  
	markflag				int				NULL,	--���
  )       
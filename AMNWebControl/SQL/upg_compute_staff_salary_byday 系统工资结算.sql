
  --create table compute_staff_work_salary_byday     
  --(  
		--computeday				varchar(10)		null,	--��������
		--strCompId				varchar(10)		null,   --�ŵ���      
		--strCompName				varchar(10)		null,   --�ŵ�����  
		--staffno					varchar(20)		null,   --Ա�����      
		--staffinid				varchar(20)		null,   --Ա���ڲ���� 
		--arrivaldate				varchar(8 )		NULL,	--��ְ����     
		--staffname				varchar(30)		null,   --Ա������      
		--staffposition			varchar(10)		null,   --Ա��ְλ    
		--staffsocialsource		varchar(20)		null,	--�籣����  
		--staffpcid				varchar(20)		null,   --Ա�����֤      
		--staffmark				varchar(300)	null,   --Ա����ע      
		--staffbankaccountno		varchar(30)		null,   --Ա�������˺�   
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
		--afterstaffreward		float			null,   --���� 
		--yearreward				float			null,	--���ս�
		--staffamtchange			float			null,   --�������   
		--zerenjinback			float			null,   --���ν𷵻�
		--zerenjincost			float			null,   --���ν�ۿ�
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
		--staffcurstate			int				null,	--Ա����ְ״̬  
		--businessflag			int				NULL    ,--�Ƿ�Ϊҵ����Ա 0--���� 1--��
		--markflag				int				NULL,	--���
		--stafftype				int				NULL	,-- 0 ���� 1 ��ǲ
  --) 
  
alter procedure upg_compute_staff_salary_byday 
(  
 @compid   varchar(10),  --�ŵ��   
 @datefrom   varchar(10), --��ʼ����  
 @dateto   varchar(10)   --��������  
)    
as  
begin  
	declare @tocompid varchar(10)  
	declare cur_each_comp cursor for  
	select relationcomp from compchaininfo where curcomp=@compid   
	open cur_each_comp  
	fetch cur_each_comp into @tocompid  
	while @@fetch_status = 0  
	begin
	
	    exec upg_prepare_ticheng_analysis_after_byday @tocompid,@datefrom,@dateto
		fetch cur_each_comp into @tocompid  
	end  
	close cur_each_comp  
	deallocate cur_each_comp  
end  
go

--exec upg_compute_staff_salary_byday '001','20140301','20140331'
select * from compute_staff_work_salary_byday,commoninfo 
where staffsocials>0 and infotype='SBGS' and staffsocialsource=parentcodekey

 exec upg_compute_staff_salary_byday '00101','20140301','20140331' 
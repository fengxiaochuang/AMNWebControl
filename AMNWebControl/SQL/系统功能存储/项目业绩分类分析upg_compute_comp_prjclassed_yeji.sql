if exists(select 1 from sysobjects where type='P' and name='upg_compute_comp_prjclassed_yeji')
	drop procedure upg_compute_comp_prjclassed_yeji
go
CREATE procedure upg_compute_comp_prjclassed_yeji                        
(                                  
 @compid varchar(10) ,                                  
 @datefrom varchar(8),                                  
 @dateto varchar(8)                                
)                                  
as                                  
begin                                  
--����ҵ����س���                                      
 declare @PRJ_BEAUT_CLASS_CODE varchar(10) --��Ŀ���֮���������                                      
 declare @PRJ_HAIR_CLASS_CODE varchar(10)  --��Ŀ���֮���������                                      
 declare @PRJ_FOOT_CLASS_CODE varchar(10)  --��Ŀ���֮���������                                      
 declare @PRJ_FINGER_CLASS_CODE varchar(10) --��Ŀ���֮���������                                      
 declare @GOODS_BEAUT_CLASS_CODE varchar(10) --��Ʒ���֮���������                                      
 declare @GOODS_HAIR_CLASS_CODE varchar(10)  --��Ʒ���֮���������                                      
 declare @DEP_BEAUT_CODE varchar(10)  --���ݲ��Ŵ���                                      
 declare @DEP_HAIR_CODE varchar(10)   --�������Ŵ���                                      
 declare @DEP_FOOT_CODE varchar(10)   --�������Ŵ���                                      
 declare @DEP_FINGER_CODE varchar(10)   --�������Ŵ���                                      
                                       
 set @PRJ_BEAUT_CLASS_CODE = '4'                                      
 set @PRJ_HAIR_CLASS_CODE = '3'                                      
 set @PRJ_FOOT_CLASS_CODE = '6'                                      
 set @PRJ_FINGER_CLASS_CODE = '5'                         
                                      
 set @GOODS_BEAUT_CLASS_CODE = '400'                                      
 set @GOODS_HAIR_CLASS_CODE = '300'                          
                                     
 set @DEP_BEAUT_CODE = '003'  --���ݲ�                                     
 set @DEP_HAIR_CODE = '004'   --������                                  
 set @DEP_FINGER_CODE = '005' --���ײ�                         
 set @DEP_FOOT_CODE = '006'  --��Ⱦ��                                  
                                      
 --11.��Ŀ����������ҵ��; 12.��Ŀ����������ҵ����13.��Ŀ������ҵ��;14.��Ŀ����������ҵ����15.��Ŀ����������ҵ��                                      
 --21.���������Ʒҵ��;   22.���������Ʒҵ����  23.�۲�Ʒ��ҵ����                                      
 --31.����������ҵ����  32.����������ҵ���� 33.������ҵ��;    34.����������ҵ����    35.����������ҵ��                                      
 --41.�ʻ��춯������ҵ����42.�ʻ��춯������ҵ����43.�ʻ��춯��ҵ�� 44.�ʻ��춯������ҵ����45.�ʻ��춯������ҵ��                                      
 --51.���춯������ҵ����  52.���춯������ҵ����  53.���춯��ҵ��   54.���춯������ҵ����  55.���춯������ҵ��                                      
                                      
 --81.��Ŀ����������ʵҵ����82.��Ŀ����������ʵҵ����83.��Ŀ������ʵҵ����84.��Ŀ����������ʵҵ����85.��Ŀ����������ʵҵ��                                      
 --91.���������Ʒʵҵ����  92.���������Ʒʵҵ����  93.�۲�Ʒ��ʵҵ����                                      
 create table #yeji_result(                                      
  compid  varchar(10) not null,                                      
  id         int  identity       , -- ��ˮ��                                      
  item  varchar(5)  null, -- ҵ����Ŀ���                                      
  yeji  float  null, -- ҵ��                                      
  datefrom varchar(8) null, -- ��ʼ����                                      
  dateto  varchar(8)  null, -- ��ֹ����                                      
 )                                      
 create table #prj_cls(                                      
                                    
  prjid varchar(20) null,--��Ŀ���                                      
  prjcls varchar(10) null--��Ŀ���                                      
 )                                      
 create clustered index idx_clust_prj_cls on #prj_cls(prjcls,prjid)                                      
 insert into #prj_cls(prjid,prjcls)                                      
 select prjno,prjtype from projectnameinfo                               
                                      
              
 create table #emp_dep(                                    
  compid varchar(10) null,                                    
  inid varchar(20) null,--�ڲ����                                   
  empid varchar(20) null,--Ա�����                                    
  empdep varchar(10) null,--Ա������                                    
  datefrom varchar(8) null,                                    
  dateto varchar(8) null,                                    
 )                                    
 create clustered index idx_tmp_emp_dep on #emp_dep(compid,empid,datefrom,dateto)                                    
 create table #empinfobydate(                                    
  seqno int identity not null,                        
  compid varchar(10) null,                            
  inid varchar(20) null,                                    
  empid varchar(20) null,                                    
  datefrom varchar(8) null,                                    
  dateto  varchar(8) null,                                    
  position varchar(10) null,                                    
  salary  float null,                                    
  sharetype varchar(5) null,                                    
  sharerate float null,                                    
  deducttax int null,                                     
 )                           
                       
    declare @compidid varchar(10)                      
    declare cur_each_comp cursor for                      
	 select relationcomp from compchaininfo  where curcomp=@compid                      
	 open cur_each_comp                      
	 fetch cur_each_comp into @compidid                      
	 while @@fetch_status=0                      
	 begin                      
	   insert into #empinfobydate(compid,inid,empid,datefrom,dateto,position,salary,sharetype,sharerate,deducttax)                                    
	   exec upg_get_empinfo_by_date_comps @compidid,@datefrom,@dateto                        
	                      
	   fetch cur_each_comp into @compidid                      
	 end                      
	 close cur_each_comp                      
	 deallocate cur_each_comp                      
                      
                                             
	insert into #emp_dep(compid,inid,empid,empdep,datefrom,dateto)                                
	select distinct compid,inid,empid,department,datefrom,dateto                                
	from #empinfobydate,staffinfo with (nolock)                                
	where inid=manageno and isnull(inid,'')<>''           
                                   
                       
                                       
	--������Ŀ������ҵ��                                  
	create table #m_d_consumeinfo(                                  
	  cscompid			varchar(10)     NULL,   --��˾���                                  
	  csbillid			varchar(20)		NULL,   --���ѵ���                               
	  financedate		varchar(8)		NULL,   --�������� 
	  csinfotype		int             NULL,	--��������  1 ��Ŀ  2 ��Ʒ 
	  csitemno			varchar(20)     NULL,   --��Ŀ����                                  
	  csitemamt			float           NULL,   --���                                  
	  csfirstsaler		varchar(20)     NULL,   --�󹤴���                                  
	  csfirstinid		varchar(20)		NULL,   --���ڲ����  
	  csfirstshare		float           NULL,	--�󹤷���                              
	  cssecondsaler		varchar(20)     NULL,   --�й�����                                  
	  cssecondinid		varchar(20)		NULL,   --�й��ڲ���� 
	  cssecondshare		float           NULL,	--�й�����                               
	  csthirdsaler		varchar(20)     NULL,   --С������        
	  csthirdinid		varchar(20)		NULL,   --С���ڲ���� 
	  csthirdshare		float           NULL,	--С������                      
	  cspaymode			varchar(5)      NULL   --��Ŀ֧����ʽ                                     
	)  
	create nonclustered index index_m_d_consumeinfo_csitemno  on #m_d_consumeinfo(cscompid,csinfotype,csitemno)  
	create nonclustered index index_m_d_consumeinfo_financedate  on #m_d_consumeinfo(cscompid,csinfotype,financedate)  
	                                  
	insert into #m_d_consumeinfo(cscompid,csbillid,csinfotype,financedate,csitemno,csitemamt,csfirstsaler,csfirstinid,cssecondsaler,cssecondinid,csthirdsaler,csthirdinid,cspaymode,csfirstshare,cssecondshare,csthirdshare)                                  
	select a.cscompid,a.csbillid,csinfotype,a.financedate,csitemno,csitemamt,csfirstsaler,csfirstinid,cssecondsaler,cssecondinid,csthirdsaler,csthirdinid,cspaymode,csfirstshare,cssecondshare,csthirdshare                                  
	   from mconsumeinfo a WITH (NOLOCK),dconsumeinfo b with (nolock),compchaininfo                                   
	  where a.cscompid=b.cscompid                                  
		and a.csbillid=b.csbillid                                  
		and a.cscompid =relationcomp 
		and curcomp= @compid                                  
		and financedate>=@datefrom                                   
		and financedate<=@dateto                
                              
		insert into #yeji_result(compid,item,yeji)                                  
		 select cscompid,'11',isnull(sum(csitemamt),0)                                  
		 from #m_d_consumeinfo,#prj_cls                                  
		 where csitemno=prjid                                   
		   and prjcls=@PRJ_BEAUT_CLASS_CODE                                  
		   --and isnull(cspaymode,'') in ('1','2','6','14','15','16') 
		   and isnull(csinfotype,1)=1                                  
		 group by cscompid                                
		                                 
		 insert into #yeji_result(compid,item,yeji)                                  
		 select cscompid,'12',isnull(sum(csitemamt),0)                                  
		 from #m_d_consumeinfo,#prj_cls                                  
		 where csitemno=prjid                                   
		   and (prjcls=@PRJ_HAIR_CLASS_CODE   or    prjcls= @PRJ_FOOT_CLASS_CODE)                            
		   --and isnull(cspaymode,'') in ('1','2','6','14','15','16')
		   and isnull(csinfotype,1)=1                                        
		 group by cscompid                       
		                     
		                             
		 
		 insert into #yeji_result(compid,item,yeji)                                  
		 select cscompid,'15',isnull(sum(csitemamt),0)                                  
		 from #m_d_consumeinfo,#prj_cls                                  
		 where csitemno=prjid                                   
		   and prjcls=@PRJ_FINGER_CLASS_CODE                                  
		   --and isnull(cspaymode,'') in ('1','2','6','16')  
		   and isnull(csinfotype,1)=1                                
		 group by cscompid       
		                      
		  
    --------------------------------------------������Ŀ��ʵҵ��-------END--------------------------------------------------
    
    --21.���������Ʒҵ��;   22.���������Ʒҵ����  23.�۲�Ʒ��ҵ��                                  
	--91.���������Ʒʵҵ����  92.���������Ʒʵҵ����  93.�۲�Ʒ��ʵҵ����                                  
	                      
	--------------------------------------------�����Ʒ��ʵҵ��-------Start------------------------------------------------
		  insert into #yeji_result(compid,item,yeji)                                
		  select cscompid,case when empdep=@DEP_BEAUT_CODE		then '21'
								when empdep=@DEP_HAIR_CODE		then '22'
								when empdep=@DEP_FOOT_CODE		then '24x'
								when empdep=@DEP_FINGER_CODE    then '25' end ,isnull(sum(csfirstshare),0)                                  
		  from #m_d_consumeinfo,#emp_dep                                  
		  where inid=csfirstinid                                  
			--and isnull(cspaymode,'') in ('1','2','6','14','15','16')                                
			and financedate>=datefrom and financedate<dateto    and cscompid=compid  
			and isnull(csinfotype,1)=2                          
		  group by cscompid,empdep                                  
		                                  
		   insert into #yeji_result(compid,item,yeji)                                
		  select cscompid,case when empdep=@DEP_BEAUT_CODE		then '21'
								when empdep=@DEP_HAIR_CODE		then '22'
								when empdep=@DEP_FOOT_CODE	then '24x'
								when empdep=@DEP_FINGER_CODE    then '25' end,isnull(sum(cssecondshare),0)                                  
		  from #m_d_consumeinfo,#emp_dep                                  
		  where inid=cssecondinid                                   
			--and isnull(cspaymode,'') in ('1','2','6','14','15','16')                              
			and financedate>=datefrom and financedate<dateto   and cscompid=compid 
			and isnull(csinfotype,1)=2                                
		  group by cscompid,empdep                                 
		                                  
		   insert into #yeji_result(compid,item,yeji)                                
		  select cscompid,case when empdep=@DEP_BEAUT_CODE		then '21'
								when empdep=@DEP_HAIR_CODE		then '22'
								when empdep=@DEP_FOOT_CODE		then '24x'
								when empdep=@DEP_FINGER_CODE    then '25' end,isnull(sum(csthirdshare),0)                                  
		  from #m_d_consumeinfo,#emp_dep                                  
		  where inid=csthirdinid                                  
		   --and isnull(cspaymode,'') in ('1','2','6','14','15','16')                                
		   and financedate>=datefrom and financedate<dateto  and cscompid=compid 
		   and isnull(csinfotype,1)=2                               
		  group by cscompid,empdep                                 
		                                  
		
		                  
	
		        
	--------------------------------------------�����Ʒ��ʵҵ��-------END--------------------------------------------------
	
                           
         
	create table #prjchange_yeji_resultx(                                
		compid					varchar(10)		null,	--�ŵ���         
		compname				varchar(50)		null,	--�ŵ����� 
        beaut_prj_yeji			float			null,  --������Ŀ                          
		hair_prj_yeji			float			null,  --������Ŀ                           
		finger_prj_yeji			float			null,  --������Ŀ                             
		beaut_goods_yeji		float			null,  --���ݲ�Ʒ                              
		hair_goods_yeji			float			null,  --������Ʒ                             
		finger_goods_yeji		float			null,  --���ײ�Ʒ 
		projecttype				varchar(10)		null,	--���ͱ��    
		projectamt				float			null,	--���ͽ��              
	 )     
     
    insert #prjchange_yeji_resultx(compid,projecttype,projectamt )      
	select a.cscompid,prjreporttype+'Amt',sum(isnull(csitemamt,0))
	from #m_d_consumeinfo a ,commoninfo,compchaininfo,projectnameinfo
	where infotype='XMTJ' and a.csinfotype='1' and prjno=a.csitemno and prjreporttype=parentcodekey
	and a.cscompid =relationcomp and curcomp=@compid and financedate between @datefrom and @dateto    
	group by a.cscompid,prjreporttype  order by cscompid,prjreporttype                                
	
	update a set compname= b.compname  from  #prjchange_yeji_resultx a,companyinfo b  where a.compid=b.compno
	
    update a set beaut_prj_yeji=b.beaut_prj_yeji,hair_prj_yeji=b.hair_prj_yeji,finger_prj_yeji=b.finger_prj_yeji,
				 beaut_goods_yeji=b.beaut_goods_yeji,hair_goods_yeji=b.hair_goods_yeji,finger_goods_yeji=b.finger_goods_yeji
      from  #prjchange_yeji_resultx a,(
				select compid,beaut_prj_yeji=isnull(sum( case when item in ('11','61') then yeji else 0 end ),0),              
					hair_prj_yeji=isnull(sum( case when item in ('12','62') then yeji else 0 end ),0),        
					finger_prj_yeji=isnull(sum( case when item='15' then yeji else 0 end ),0),                
					beaut_goods_yeji=isnull(sum( case when item='21' then yeji else 0 end ),0),              
					hair_goods_yeji=isnull(sum( case when item='22' then yeji else 0 end ),0),        
					finger_goods_yeji=isnull(sum( case when item='25' then yeji else 0 end ),0)              
			   from #yeji_result     group by compid ) as b
	where a.compid=b.compid
	  
	
	
	declare @sqltitle varchar(600)
	select @sqltitle = isnull(@sqltitle + '],[' , '') + parentcodekey+'Amt' from commoninfo where infotype='XMTJ' 
	set @sqltitle = '[' + @sqltitle + ']'
	
	exec ('select * from (select * from #prjchange_yeji_resultx ) a pivot (max(projectamt) for projecttype in (' + @sqltitle + ')) b order by compid')
	    

	drop table #m_d_consumeinfo                                      
	drop table #prj_cls                                                                 
	drop table #emp_dep                                  
	drop table #yeji_result                                  
	drop table #prjchange_yeji_resultx                             
end 

go

exec upg_compute_comp_prjclassed_yeji '0010101','20130801','20130831'
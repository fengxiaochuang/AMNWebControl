if exists(select 1 from sysobjects where type='P' and name='upg_analysis_system_shop_rijie')
	drop procedure upg_analysis_system_shop_rijie
go
CREATE procedure upg_analysis_system_shop_rijie                        
(                        
 @compid	varchar(10),                        
 @mmonth	varchar(6)                      
)  
as  
begin  

     delete jsanalysisresult where compno=@compid and mmonth=@mmonth
     declare @fromdate varchar(10)
     declare @todate varchar(10)
     
     declare @tmpdate datetime
	 declare @year varchar(4) --���
	 declare @month varchar(2)--�·�
	 declare @day varchar(2) --�շ� 
	 
     set @fromdate=@mmonth+'01'
     set @tmpdate = dateadd(MONTH,1,convert(datetime,@fromdate))
     set @tmpdate = dateadd(day,-1,@tmpdate)
	 set @year = year(@tmpdate)
	 set @month = month(@tmpdate)
	 set @day = day(@tmpdate)
	 if(len(@month)=1)
		set @month = '0'+@month
	 if(len(@day)=1)
		set @day = '0'+@day
	 set @todate=@year+@month+@day
	
	insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
	select @compid,@mmonth,1,'��ҵ��',convert(numeric(20,1),SUM(ISNULL(totalyeji,0)))  
    from compclasstraderesult where compid=@compid and  ddate between @fromdate and @todate 
    group by SUBSTRING(ddate,1,6)
  
	insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
	select @compid,@mmonth,2,'������ҵ��',convert(numeric(20,1),SUM(ISNULL(hairyeji,0)))  
    from compclasstraderesult where compid=@compid and  ddate between @fromdate and @todate 
    group by SUBSTRING(ddate,1,6)
    
    insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
	select @compid,@mmonth,3,'������ҵ��',convert(numeric(20,1),SUM(ISNULL(beautyeji,0)))  
    from compclasstraderesult where compid=@compid and  ddate between @fromdate and @todate 
    group by SUBSTRING(ddate,1,6)
    
    insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
	select @compid,@mmonth,4,'����Ӫҵ��ռ��',convert(numeric(20,4),SUM(ISNULL(beautyeji,4))/SUM(ISNULL(totalyeji,0)))
    from compclasstraderesult where compid=@compid and  ddate between @fromdate and @todate   and isnull(realtotalyeji,0)>0 
    group by SUBSTRING(ddate,1,6)
    
    insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
	select @compid,@mmonth,5,'��ʵҵ��',convert(numeric(20,4),SUM(ISNULL(realtotalyeji,4)))
    from compclasstraderesult where compid=@compid and  ddate between @fromdate and @todate   
    group by SUBSTRING(ddate,1,6)
    
    insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
	select @compid,@mmonth,6,'�Ŀ���(��ֵ����/���춯)',convert(numeric(20,4),SUM(ISNULL(cardsalesservices,1))/ISNULL(sum(ISNULL(totalcardtrans,0)),0))  
    from detial_trade_byday_fromshops where shopId=@compid and  dateReport between @fromdate and @todate and  ISNULL(totalcardtrans,0)>0 
    group by SUBSTRING(dateReport,1,6)
    
     insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
	select @compid,@mmonth,7,'���ݲ�����ռ�� ',convert(numeric(20,4),SUM(ISNULL(realbeautyeji,4))/SUM(ISNULL(realtotalyeji,0)))  
    from compclasstraderesult where compid=@compid and  ddate between @fromdate and @todate    and isnull(realtotalyeji,0)>0 
    group by SUBSTRING(ddate,1,6)
    
    insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
	select @compid,@mmonth,9,'����ʵҵ��[����������Ʒ]',convert(numeric(20,4),SUM(ISNULL(realhairyeji,4)))
    from compclasstraderesult where compid=@compid and  ddate between @fromdate and @todate   
    group by SUBSTRING(ddate,1,6)
    
      create table  #m_dconsumeinfo
   (
		cscompid		varchar(10)     NULL,   --��˾���
		csbillid		varchar(20)	    NULL,   --���ѵ���
		financedate		varchar(8)		NULL    ,   --��������
		backcsflag		int				NULL    ,   --�Ƿ��Ѿ�����: 0-û�з��� 1--�Ѿ�����
		backcsbillid	varchar(20)		NULL    ,   --��������
		csitemno		varchar(20)     NULL,		--��Ŀ/��Ʒ����
		csitemunit		varchar(5)      NULL,		--��λ
		csitemcount		float           NULL,		--����
		csitemamt		float           NULL,		--���
		cspaymode		varchar(5)		NULL,		--֧����ʽ
   )
   
   insert #m_dconsumeinfo(cscompid,csbillid,financedate,backcsflag,backcsbillid,csitemno,csitemunit,csitemcount,csitemamt,cspaymode)
   select a.cscompid,a.csbillid,financedate,backcsflag,backcsbillid,csitemno,csitemunit,csitemcount,csitemamt,cspaymode
   from mconsumeinfo a,dconsumeinfo b
   where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between @fromdate and @todate and a.cscompid=@compid
   
    insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
	select @compid,@mmonth,8,'�ܿ͵���',count(distinct csbillid)
    from #m_dconsumeinfo where cscompid=@compid and  financedate between @fromdate and @todate   
    group by SUBSTRING(financedate,1,6)
    
    
      insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
	  select @compid,@mmonth,10,'ϴ��������',convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
		from #m_dconsumeinfo b,projectnameinfo c  
		where b.csitemno=c.prjno and isnull(c.prjreporttype,'') in ('01')  
		and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
		group by  SUBSTRING(b.financedate,1,6)  
    
    
      insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
	  select @compid,@mmonth,11,'�̷�����',convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
		from #m_dconsumeinfo b,projectnameinfo c  
		where b.csitemno=c.prjno and isnull(c.prjreporttype,'') in ('03')  
		and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
		group by  SUBSTRING(b.financedate,1,6)  
		
      insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
	  select @compid,@mmonth,12,'Ⱦ������',convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
		from #m_dconsumeinfo b,projectnameinfo c  
		where b.csitemno=c.prjno and isnull(c.prjreporttype,'') in ('02')  
		and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
		group by  SUBSTRING(b.financedate,1,6) 
		
		insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
	  select @compid,@mmonth,13,'��������',convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
		from #m_dconsumeinfo b,projectnameinfo c  
		where b.csitemno=c.prjno and isnull(c.prjreporttype,'') in ('04','05','07','14')  
		and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
		group by  SUBSTRING(b.financedate,1,6)   
		
		
		insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
	    select @compid,@mmonth,14,'ͷƤ����',convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
		from #m_dconsumeinfo b,projectnameinfo c  
		where b.csitemno=c.prjno and isnull(c.prjreporttype,'') in ('06')  
		and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
		group by  SUBSTRING(b.financedate,1,6) 
		
		
		insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
	    select @compid,@mmonth,15,'ϴ������Ŀ��ռ��',convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'') in ('01') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
	    from #m_dconsumeinfo b,projectnameinfo c  
	    where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('3','6')  
	     and isnull(c.prjreporttype,'') in ('01','03','02','04','05','07','14','06')  
	     and b.cscompid=@compid and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0   
	     group by  SUBSTRING(b.financedate,1,6)
	     
	     insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
	     select @compid,@mmonth,16,'�̷�����ռ��',convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'') in ('03') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
		  from #m_dconsumeinfo b,projectnameinfo c  
		  where  b.csitemno=c.prjno and isnull(c.prjtype,'') in ('3','6')  
		   and isnull(c.prjreporttype,'') in ('01','03','02','04','05','07','14','06')  
		  and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0   
		  group by  SUBSTRING(b.financedate,1,6)
		
			insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
	      select @compid,@mmonth,17,'Ⱦ������ռ��',convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'') in ('02') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
		  from #m_dconsumeinfo b,projectnameinfo c  
		  where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('3','6')  
		   and isnull(c.prjreporttype,'') in ('01','03','02','04','05','07','14','06')  
		  and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0   
		  group by  SUBSTRING(b.financedate,1,6)
		  
		  
		  insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
	      select @compid,@mmonth,18,'��������ռ��',convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'') in ('04','05','07','14') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
		  from #m_dconsumeinfo b,projectnameinfo c  
		  where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('3','6')  
		   and isnull(c.prjreporttype,'') in ('01','03','02','04','05','07','14','06')  
		  and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0   
		  group by  SUBSTRING(b.financedate,1,6)
		
		   
		   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
	      select @compid,@mmonth,19,'ͷƤ����ռ��',convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'') in ('06') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
		   from #m_dconsumeinfo b,projectnameinfo c  
		  where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('3','6')  
		   and isnull(c.prjreporttype,'') in ('01','03','02','04','05','07','14','06')  
		  and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0   
		  group by  SUBSTRING(b.financedate,1,6)
		   
		   
		  insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
	      select @compid,@mmonth,20,'��������Ŀ��[����ϴ����]',convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
		  from #m_dconsumeinfo b,projectnameinfo c  
		  where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('3','6')  
		  and isnull(c.prjreporttype,'') in ('01','03','02','04','05','07','14','06')  
		  and b.cscompid=@compid   and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
		  group by  SUBSTRING(b.financedate,1,6)
		  
		  
		   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
		    select @compid,@mmonth,21,'ϴ������Ŀ��',convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
		  from #m_dconsumeinfo b,projectnameinfo c  
		  where b.csitemno=c.prjno and isnull(c.prjreporttype,'') in ('01')  
		  and b.cscompid=@compid   and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
		  group by  SUBSTRING(b.financedate,1,6)
		  
		  
		   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
		     select @compid,@mmonth,22,'�̷���Ŀ��',convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
		  from #m_dconsumeinfo b,projectnameinfo c  
		  where b.csitemno=c.prjno and isnull(c.prjreporttype,'') in ('03')  
		  and b.cscompid=@compid   and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0 
		  group by  SUBSTRING(b.financedate,1,6)
		  
		   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
		    select @compid,@mmonth,23,'Ⱦ����Ŀ��',convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
		  from #m_dconsumeinfo b,projectnameinfo c  
		  where b.csitemno=c.prjno and isnull(c.prjreporttype,'') in ('02')  
		  and b.cscompid=@compid   and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
		  group by  SUBSTRING(b.financedate,1,6)
		  
		   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
		    select @compid,@mmonth,24,'������Ŀ��',convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
		  from #m_dconsumeinfo b,projectnameinfo c  
		  where b.csitemno=c.prjno and isnull(c.prjreporttype,'') in ('04','05','07','14')  
		  and b.cscompid=@compid   and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
		  group by  SUBSTRING(b.financedate,1,6)
		   
		   
		   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
		    select @compid,@mmonth,25,'ͷƤ��Ŀ��',convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
		  from #m_dconsumeinfo b,projectnameinfo c  
		  where b.csitemno=c.prjno and isnull(c.prjreporttype,'') in ('06')  
		  and b.cscompid=@compid   and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
		  group by  SUBSTRING(b.financedate,1,6)
		  
		    insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
		    select @compid,@mmonth,26,'ϴ������Ŀ��ռ��',convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'') in ('01') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0)))  
			  from #m_dconsumeinfo b,projectnameinfo c  
			  where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('3','6')  
			   and isnull(c.prjreporttype,'') in ('01','03','02','04','05','07','14','06')  
			  and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0   
			  group by  SUBSTRING(b.financedate,1,6)
		  
		  
		    insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
		       select @compid,@mmonth,27,'�̷���Ŀ��ռ��',convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'') in ('03') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0)))  
			  from #m_dconsumeinfo b,projectnameinfo c  
			  where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('3','6')  
			   and isnull(c.prjreporttype,'') in ('01','03','02','04','05','07','14','06')  
			  and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0   
			  group by  SUBSTRING(b.financedate,1,6)
			  
			     insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
			      select @compid,@mmonth,28,'Ⱦ����Ŀ��ռ��',convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'') in ('02') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0)))  
				  from #m_dconsumeinfo b,projectnameinfo c  
				  where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('3','6')  
				   and isnull(c.prjreporttype,'') in ('01','03','02','04','05','07','14','06')  
				  and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0   
				   group by  SUBSTRING(b.financedate,1,6)
			   
			        insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
			         select @compid,@mmonth,29,'������Ŀ��ռ��',convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'') in ('04','05','07','14') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0)))  
				     from #m_dconsumeinfo b,projectnameinfo c  
				     where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('3','6')  
				     and isnull(c.prjreporttype,'') in ('01','03','02','04','05','07','14','06')  
				     and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0   
				     group by  SUBSTRING(b.financedate,1,6)
				  
				      insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				      select @compid,@mmonth,30,'ͷƤ��Ŀ��ռ��',convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'') in ('06') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0)))  
					  from #m_dconsumeinfo b,projectnameinfo c  
					  where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('3','6')  
					   and isnull(c.prjreporttype,'') in ('01','03','02','04','05','07','14','06')  
					  and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0   
					  group by  SUBSTRING(b.financedate,1,6)
				   
				   
				      insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				      select @compid,@mmonth,31,'�����ܾ���',convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
					  from #m_dconsumeinfo b,projectnameinfo c  
					  where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('3','6')  
					   and isnull(c.prjreporttype,'') in ('01','03','02','04','05','07','14','06')  
					  and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
					  group by  SUBSTRING(b.financedate,1,6)
				   
				   
				      insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				      select @compid,@mmonth,32,'ϴ��������',convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
					  from #m_dconsumeinfo b,projectnameinfo c  
					  where b.csitemno=c.prjno  and isnull(c.prjreporttype,'') in ('01')  
					  and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
					  group by  SUBSTRING(b.financedate,1,6)
					  
					    insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				        select @compid,@mmonth,33,'�̷�����',convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
					    from #m_dconsumeinfo b,projectnameinfo c  
					    where b.csitemno=c.prjno  and isnull(c.prjreporttype,'') in ('03')  
					    and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
					    group by  SUBSTRING(b.financedate,1,6)
				  
				  
				  
				        insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				        select @compid,@mmonth,34,'Ⱦ������',convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
					    from #m_dconsumeinfo b,projectnameinfo c  
					    where b.csitemno=c.prjno and isnull(c.prjreporttype,'') in ('02')  
					    and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
					    group by  SUBSTRING(b.financedate,1,6)
					  
					    insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				        select @compid,@mmonth,35,'�������',convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
					    from #m_dconsumeinfo b,projectnameinfo c  
					    where b.csitemno=c.prjno and isnull(c.prjreporttype,'') in ('04','05','07','14')  
					    and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
					    group by  SUBSTRING(b.financedate,1,6)
					  
					  
					    insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				        select @compid,@mmonth,36,'ͷƤ����',convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
					    from #m_dconsumeinfo b,projectnameinfo c  
					    where b.csitemno=c.prjno and isnull(c.prjreporttype,'') in ('06')  
					    and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
					    group by  SUBSTRING(b.financedate,1,6)
					  
					  
					    insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				        select @compid,@mmonth,37,'�����ܿ͵���[����ϴ����]',count(distinct b.csbillid)   
					    from #m_dconsumeinfo b,projectnameinfo c  
					    where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('3','6')  
					    and isnull(c.prjreporttype,'') in ('01','03','02','04','05','07','14','06')  
					    and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
					    group by  SUBSTRING(b.financedate,1,6)
					  
					    insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				        select @compid,@mmonth,38,'�����ܿ͵���',convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/count(distinct b.csbillid))   
					    from #m_dconsumeinfo b,projectnameinfo c  
					    where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('3','6')  
					    and isnull(c.prjreporttype,'') in ('01','03','02','04','05','07','14','06')  
					    and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
					    group by  SUBSTRING(b.financedate,1,6)
					  
					  
					    insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				        select @compid,@mmonth,39,'�����Ƴ̿͵���',count(distinct b.csbillid)   
					    from #m_dconsumeinfo b,projectnameinfo c  
					    where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('3','6')  
					    and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0 and isnull(cspaymode,'')='9'  
					    group by  SUBSTRING(b.financedate,1,6)
					  
					  
					    insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				        select @compid,@mmonth,40,'�����Ƴ̿͵���',convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/count(distinct b.csbillid))   
					    from #m_dconsumeinfo b,projectnameinfo c  
					    where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('3','6')  
					    and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0 and isnull(cspaymode,'')='9'  
					    group by  SUBSTRING(b.financedate,1,6)
					    
					    insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				        select @compid,@mmonth,41,'�����Ƴ̿͵���ռ��',convert(numeric(20,4),(count(distinct case when  isnull(cspaymode,'')='9' then b.csbillid else '' end )-1)*1.0/count(distinct b.csbillid))  
					    from #m_dconsumeinfo b,projectnameinfo c  
					    where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('3','6')  
					    and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0   
					    group by  SUBSTRING(b.financedate,1,6)
					  
					  
					    insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				        select @compid,@mmonth,42,'����ʵҵ��[�������ݲ�Ʒ.��ϴˮϴ]',convert(numeric(20,1),SUM(ISNULL(realbeautyeji,0)))  
					    from compclasstraderesult where compid=@compid and  ddate between @fromdate and @todate
					    group by SUBSTRING(ddate,1,6)
					  
					  
					    insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				        select @compid,@mmonth,43,'������SPA������',convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
					    from #m_dconsumeinfo b,projectnameinfo c  
					    where b.csitemno=c.prjno and isnull(c.prjreporttype,'') in ('08','12','19','20','21')  
					    and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0 
					    group by  SUBSTRING(b.financedate,1,6)
					  
					    insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				        select @compid,@mmonth,44,'�沿������',convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
					    from #m_dconsumeinfo b,projectnameinfo c  
					    where b.csitemno=c.prjno and isnull(c.prjreporttype,'') in ('10','17')  
					    and b.cscompid=@compid and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0 
					    group by  SUBSTRING(b.financedate,1,6)
					  
					  
					    insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				        select @compid,@mmonth,45,'�ز�������',convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
					    from #m_dconsumeinfo b,projectnameinfo c  
					    where b.csitemno=c.prjno and isnull(c.prjreporttype,'') in ('18')  
					    and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0 
					    group by  SUBSTRING(b.financedate,1,6)
					  
					    insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				        select @compid,@mmonth,46,'����������',convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
					    from #m_dconsumeinfo b,projectnameinfo c  
					    where b.csitemno=c.prjno and isnull(c.prjreporttype,'') in ('09','11','13','22','23')  
					    and b.cscompid=@compid and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0 
					    group by  SUBSTRING(b.financedate,1,6)
					  
					  
					    insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				        select @compid,@mmonth,47,'���Ƴ�����',convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
					    from #m_dconsumeinfo b,projectnameinfo c  
					    where b.csitemno=c.prjno and isnull(c.prjreporttype,'') in ('15')  
					    and b.cscompid=@compid and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0 
					    group by  SUBSTRING(b.financedate,1,6)
					  
					    insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				        select @compid,@mmonth,48,'������SPA������ռ��',convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'') in ('08','12','19','20','21') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
					    from #m_dconsumeinfo b,projectnameinfo c  
					    where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('4')  
					    and isnull(c.prjreporttype,'') in ('08','12','19','20','21','10','17','18','09','11','13','22','23','15')  
					    and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0   
					    group by  SUBSTRING(b.financedate,1,6)
					  
					  
					    insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				        select @compid,@mmonth,49,'�沿������ռ��',convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'') in ('10','17') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
					    from #m_dconsumeinfo b,projectnameinfo c  
					    where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('4')  
					    and isnull(c.prjreporttype,'') in ('08','12','19','20','21','10','17','18','09','11','13','22','23','15')  
					    and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0   
					    group by  SUBSTRING(b.financedate,1,6)
					  
					    insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				        select @compid,@mmonth,50,'�ز�������ռ��',convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'') in ('18') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
						from #m_dconsumeinfo b,projectnameinfo c  
						where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('4')  
						and isnull(c.prjreporttype,'') in ('08','12','19','20','21','10','17','18','09','11','13','22','23','15')  
						and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0   
						group by  SUBSTRING(b.financedate,1,6)
						  
						  
					   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				       select @compid,@mmonth,51,'����������ռ��',convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'') in ('09','11','13','22','23') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
					   from #m_dconsumeinfo b,projectnameinfo c  
					   where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('4')  
					   and isnull(c.prjreporttype,'') in ('08','12','19','20','21','10','17','18','09','11','13','22','23','15')  
					   and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0   
					   group by  SUBSTRING(b.financedate,1,6)
						  
					   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				       select @compid,@mmonth,52,'���Ƴ�����ռ��',convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'') in ('15') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
					   from #m_dconsumeinfo b,projectnameinfo c  
					   where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('4')  
					   and isnull(c.prjreporttype,'') in ('08','12','19','20','21','10','17','18','09','11','13','22','23','15')  
					   and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0   
					   group by  SUBSTRING(b.financedate,1,6)
					  
					  
					   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				       select @compid,@mmonth,53,'��������Ŀ��[��������ϴˮϴ]',convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
					   from #m_dconsumeinfo b,projectnameinfo c  
					   where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('4')   
					   and isnull(c.prjreporttype,'') in ('08','12','19','20','21','10','17','18','09','11','13','22','23','15')  
					   and b.cscompid=@compid   and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
					   group by  SUBSTRING(b.financedate,1,6)
										  
					   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				       select @compid,@mmonth,54,'������Ŀ��',convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
					   from #m_dconsumeinfo b,projectnameinfo c  
					   where b.csitemno=c.prjno and isnull(c.prjreporttype,'') in ('08','12','19','20','21')  
					   and b.cscompid=@compid   and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
					   group by  SUBSTRING(b.financedate,1,6)
					  
					   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				       select @compid,@mmonth,55,'�沿��Ŀ��',convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
					   from #m_dconsumeinfo b,projectnameinfo c  
					   where b.csitemno=c.prjno and isnull(c.prjreporttype,'') in  ('10','17')  
					   and b.cscompid=@compid   and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
					   group by  SUBSTRING(b.financedate,1,6)
					  
					   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				       select @compid,@mmonth,56,'�ز���Ŀ��',convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
					   from #m_dconsumeinfo b,projectnameinfo c  
					   where b.csitemno=c.prjno and isnull(c.prjreporttype,'') in ('18')  
					   and b.cscompid=@compid   and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
					   group by  SUBSTRING(b.financedate,1,6)
					  
					   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				       select @compid,@mmonth,57,'��������Ŀ��',convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
					   from #m_dconsumeinfo b,projectnameinfo c  
					   where b.csitemno=c.prjno and isnull(c.prjreporttype,'') in ('09','11','13','22','23')  
					   and b.cscompid=@compid   and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
					   group by  SUBSTRING(b.financedate,1,6)
					  
					   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				       select @compid,@mmonth,58,'����Ŀ��Ŀ��',convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
					   from #m_dconsumeinfo b,projectnameinfo c  
					   where b.csitemno=c.prjno and isnull(c.prjreporttype,'')  in ('15')  
					   and b.cscompid=@compid   and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
					   group by  SUBSTRING(b.financedate,1,6)
					  
					   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				       select @compid,@mmonth,59,'������Ŀ��ռ��',convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'') in ('08','12','19','20','21') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0)))  
					   from #m_dconsumeinfo b,projectnameinfo c  
					   where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('4')  
					   and isnull(c.prjreporttype,'') in ('08','12','19','20','21','10','17','18','09','11','13','22','23','15')  
					   and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0   
					   group by  SUBSTRING(b.financedate,1,6)
					  
					   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				       select @compid,@mmonth,60,'�沿��Ŀ��ռ��',convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'') in ('10','17') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0)))  
					   from #m_dconsumeinfo b,projectnameinfo c  
					   where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('4')  
					   and isnull(c.prjreporttype,'') in ('08','12','19','20','21','10','17','18','09','11','13','22','23','15')  
					   and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0   
					   group by  SUBSTRING(b.financedate,1,6)
					   
					   
					   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				       select @compid,@mmonth,61,'�ز���Ŀ��ռ��',convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'') in ('18') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0)))  
					   from #m_dconsumeinfo b,projectnameinfo c  
					   where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('4')  
					   and isnull(c.prjreporttype,'') in ('08','12','19','20','21','10','17','18','09','11','13','22','23','15')  
					   and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0   
					   group by  SUBSTRING(b.financedate,1,6)
										   
					   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				       select @compid,@mmonth,62,'��������Ŀ��ռ��',convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'') in ('09','11','13','22','23') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0))) 
					   from #m_dconsumeinfo b,projectnameinfo c  
					   where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('4')  
					   and isnull(c.prjreporttype,'') in ('08','12','19','20','21','10','17','18','09','11','13','22','23','15')  
					   and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0   
					   group by  SUBSTRING(b.financedate,1,6)
					   
					   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				       select @compid,@mmonth,63,'����Ŀ��Ŀ��ռ��',convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'') in ('15') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0)))  
					   from #m_dconsumeinfo b,projectnameinfo c  
					   where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('4')  
					   and isnull(c.prjreporttype,'') in ('08','12','19','20','21','10','17','18','09','11','13','22','23','15')  
					   and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0   
					   group by  SUBSTRING(b.financedate,1,6)
					   
					   
					   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				       select @compid,@mmonth,64,'���ݾ���',convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
					   from #m_dconsumeinfo b,projectnameinfo c  
					   where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('4')  
					   and isnull(c.prjreporttype,'') in ('08','12','19','20','21','10','17','18','09','11','13','22','23','15')  
					   and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
					   group by  SUBSTRING(b.financedate,1,6)
					   
					   
					   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				       select @compid,@mmonth,65,'���������',convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
					   from #m_dconsumeinfo b,projectnameinfo c  
					   where b.csitemno=c.prjno  and isnull(c.prjreporttype,'') in ('08','12','19','20','21')  
					   and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
					   group by  SUBSTRING(b.financedate,1,6)
					   
					   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				       select @compid,@mmonth,66,'�沿�����',convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
					   from #m_dconsumeinfo b,projectnameinfo c  
					   where b.csitemno=c.prjno  and isnull(c.prjreporttype,'') in ('10','17')  
					   and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
					   group by  SUBSTRING(b.financedate,1,6)
					   
					   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				       select @compid,@mmonth,67,'�ز������',convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
					   from #m_dconsumeinfo b,projectnameinfo c  
					   where b.csitemno=c.prjno  and isnull(c.prjreporttype,'') in ('18')  
					   and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
					   group by  SUBSTRING(b.financedate,1,6)
					   
					   
					   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				       select @compid,@mmonth,68,'���������',convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
					   from #m_dconsumeinfo b,projectnameinfo c  
					   where b.csitemno=c.prjno  and isnull(c.prjreporttype,'') in ('09','11','13','22','23')  
					   and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
					   group by  SUBSTRING(b.financedate,1,6)
					   
					   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				       select @compid,@mmonth,69,'����Ŀ����',convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
					   from #m_dconsumeinfo b,projectnameinfo c  
					   where b.csitemno=c.prjno  and isnull(c.prjreporttype,'') in ('15')  
					   and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
					   group by  SUBSTRING(b.financedate,1,6)
					   
					   
					   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				       select @compid,@mmonth,70,'���ݲ��͵���[��������ϴˮϴ]',count(distinct b.csbillid)   
					   from #m_dconsumeinfo b,projectnameinfo c  
					   where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('4')  
					   and isnull(c.prjreporttype,'') in ('08','12','19','20','21','10','17','18','09','11','13','22','23','15')  
					   and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
					   group by  SUBSTRING(b.financedate,1,6)
					   
					   
					   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				       select @compid,@mmonth,71,'���ݲ��͵���',convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/count(distinct b.csbillid))   
					   from #m_dconsumeinfo b,projectnameinfo c  
					   where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('4')  
					   and isnull(c.prjreporttype,'') in ('08','12','19','20','21','10','17','18','09','11','13','22','23','15')  
					   and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0  
					   group by  SUBSTRING(b.financedate,1,6)
					   
					   
					   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				       select @compid,@mmonth,72,'�����Ƴ̿͵���',count(distinct b.csbillid)   
					   from #m_dconsumeinfo b,projectnameinfo c  
					   where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('4')  
					   and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0 and isnull(cspaymode,'')='9'  
					   group by  SUBSTRING(b.financedate,1,6)
					   
					   
					   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				       select @compid,@mmonth,73,'�����Ƴ̿͵���',convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/count(distinct b.csbillid))   
					   from #m_dconsumeinfo b,projectnameinfo c  
					   where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('4')  
					   and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0 and isnull(cspaymode,'')='9'  
					   group by  SUBSTRING(b.financedate,1,6)
					   
					   insert jsanalysisresult(compno,mmonth,resusttyep,resusttyeptext,resultamt)
				       select @compid,@mmonth,74,'�����Ƴ̿͵�ռ��',convert(numeric(20,4),(count(distinct case when  isnull(cspaymode,'')='9' then b.csbillid else '' end )-1)*1.0/count(distinct b.csbillid))  
					   from #m_dconsumeinfo b,projectnameinfo c  
					   where b.csitemno=c.prjno and isnull(c.prjtype,'') in ('4')  
					   and b.cscompid=@compid  and  isnull(backcsbillid,'')='' and ISNULL(backcsflag,0)=0   
					   group by  SUBSTRING(b.financedate,1,6)
					   
					   
		   drop table #m_dconsumeinfo
end  
go









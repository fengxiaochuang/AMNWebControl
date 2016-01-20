if exists(select 1 from sysobjects where type='P' and name='upg_analysis_system_error')
	drop procedure upg_analysis_system_error
go
CREATE procedure upg_analysis_system_error                      
(                      
	@compid varchar(10),                      
	@fromdate varchar(8),                      
	@todate varchar(8)                      
)                      
as                      
begin                      
 declare @TIME_VALVE int                      
 set @TIME_VALVE = 5--��λ����                      
 create table #error                      
 (                      
  errid  varchar(5)  not null,                      
  description varchar(500) null                      
 )                      
 insert into #error(errid,description) values('E0001','�����ظ�')                                        
 insert into #error(errid,description) values('E0003','ҵ��δ�����δ��ȫ����')                      
 --1-������ 2-��ֵ�� 3-��� 4-�ۿ�ת���� 5-�չ�ת���� 6-����ת���� 7-��Ա������ 8-�˿���                      
 --9-������                       
               
  create table #result                      
 (                      
  compid  varchar(10)  not null,                      
  billtype varchar(5)  null,                      
  errid  varchar(5)  null,                      
  errdescript varchar(500) null,                      
  remark  varchar(2048) null,                      
 )                   
  create table #emp_deperror(                        
  compid varchar(10) null,                        
  inid varchar(20) null,--�ڲ����                        
  empid varchar(20) null,--Ա�����       
  emppos varchar(10) null,                     
  empdep varchar(10) null,--Ա������             
  datefrom varchar(8) null,                        
  dateto varchar(8) null,                        
 )        
 insert into #emp_deperror(compid,empid,emppos)                                
 select distinct compno,staffno,position                        
 from staffinfo with (nolock)                                
 where @compid=compno                   
                
 --�жϵ����ظ��Ĺ���                      
 --1����ʱ�䷧ֵ�����ڣ��������Լ��������ϵĵ���������ͬ��                      
                       
 CREATE tAbLE	#msalecardinfo               -- ��Ա�����۵�
	(
		salecompid			varchar(10)			Not NULL,   --��˾���
		salebillid			varchar(20)			Not NULL,   --���۵���
		saledate			varchar(8)				NULL,   --��������
		salecardno			varchar(20)				NULL,   --���ۿ���
		salecardtype		varchar(20)				NULL,   --���ۿ�����
		firstsalerid		varchar(20)				NULL,   --��һ���۹���
		firstsalerinid		varchar(20)				NULL,   --��һ�����ڲ����
		firstsaleamt		float					NULL,   --��һ���۷�����
		secondsalerid		varchar(20)				NULL,   --�ڶ����۹���
		secondsalerinid		varchar(20)				NULL,   --�ڶ������ڲ����
		secondsaleamt		float					NULL,   --�ڶ����۷�����
		thirdsalerid		varchar(20)				NULL,   --�������۹���
		thirdsalerinid		varchar(20)				NULL,   --���������ڲ����
		thirdsaleamt		float					NULL,   --�������۷�����
		fourthsalerid		varchar(20)				NULL,   --�������۹���
		fourthsalerinid		varchar(20)				NULL,   --���������ڲ����
		fourthsaleamt		float					NULL,   --�������۷�����
		fifthsalerid		varchar(20)				NULL,   --�������۹��� -----��Ⱦʦ
		fifthsalerinid		varchar(20)				NULL,   --���������ڲ����
		fifthsaleamt		float					NULL,   --�������۷�����
		sixthsalerid		varchar(20)				NULL,   --�������۹���----- ��Ⱦʦ
		sixthsalerinid		varchar(20)				NULL,   --���������ڲ����
		sixthsaleamt		float					NULL,   --�������۷�����
		seventhsalerid		varchar(20)				NULL,   --�������۹��� -----��Ⱦʦ
		seventhsalerinid	varchar(20)				NULL,   --���������ڲ����
		seventhsaleamt		float					NULL,   --�������۷�����
		eighthsalerid		varchar(20)				NULL,   --�ڰ����۹���----- ��Ⱦʦ
		eighthsalerinid		varchar(20)				NULL,   --�ڰ������ڲ����
		eighthsaleamt		float					NULL,   --�ڰ����۷�����
		ninthsalerid		varchar(20)				NULL,   --�ھ����۹���-----
		ninthsalerinid		varchar(20)				NULL,   --�ھ������ڲ����
		ninthsaleamt		float					NULL,   --�ھ����۷�����
		tenthsalerid		varchar(20)				NULL,   --��ʮ���۹���----- ��Ⱦʦ
		tenthsalerinid		varchar(20)				NULL,   --��ʮ�����ڲ����
		tenthsaleamt		float					NULL,   --��ʮ���۷�����
		financedate			varchar(8)				NULL,   --�������� 
		salekeepamt			float					NULL,	--��ֵ���
		paymode				varchar(10)				NULL,	--֧����ʽ
		payamt				float					NULL,	--֧�����
	)     
    insert #msalecardinfo(salecompid,salebillid,saledate,salecardno,salecardtype,firstsalerid,firstsalerinid,firstsaleamt,secondsalerid,secondsalerinid,secondsaleamt,
                     thirdsalerid,thirdsalerinid,thirdsaleamt,fourthsalerid,fourthsalerinid,fourthsaleamt,fifthsalerid,fifthsalerinid,fifthsaleamt,
                     sixthsalerid,sixthsalerinid,sixthsaleamt,seventhsalerid,seventhsalerinid,seventhsaleamt,eighthsalerid,eighthsalerinid,eighthsaleamt,
                     ninthsalerid,ninthsalerinid,ninthsaleamt,tenthsalerid,tenthsalerinid,tenthsaleamt,financedate,salekeepamt,paymode,payamt)
	select salecompid,salebillid,saledate,salecardno,salecardtype,firstsalerid,firstsalerinid,firstsaleamt,secondsalerid,secondsalerinid,secondsaleamt,
                     thirdsalerid,thirdsalerinid,thirdsaleamt,fourthsalerid,fourthsalerinid,fourthsaleamt,fifthsalerid,fifthsalerinid,fifthsaleamt,
                     sixthsalerid,sixthsalerinid,sixthsaleamt,seventhsalerid,seventhsalerinid,seventhsaleamt,eighthsalerid,eighthsalerinid,eighthsaleamt,
                     ninthsalerid,ninthsalerinid,ninthsaleamt,tenthsalerid,tenthsalerinid,tenthsaleamt,financedate,salekeepamt,paymode,payamt
    from msalecardinfo, dpayinfo
    where salebillid=paybillid and salecompid=paycompid and paybilltype='SK'
      and salecompid=@compid and financedate between @fromdate and @todate and ISNULL(salekeepamt,0)<>0
                              
         
        
                   
              
   if exists(select 1 from #msalecardinfo)                        
   begin              
		declare @e0003_salebillid varchar(20) 
		declare @e0003_salecardno varchar(20)           
		declare @e0003_bill_msalecardinfo varchar(1024)                        
		set @e0003_bill_msalecardinfo = ''                        
                
		declare @e0003_firstsalerid varchar(20), @e0003_secondsalerid varchar(20), @e0003_thirdsalerid varchar(20), @e0003_eighthsalerid varchar(20) , @e0003_ninthsalerid varchar(20) , @e0003_tenthsalerid varchar(20)     
		declare @e0003_firstsaleamt float, @e0003_secondsaleamt float, @e0003_thirdsaleamt float, @e0003_eighthsaleamt float, @e0003_ninthsaleamt float, @e0003_tenthsaleamt float              
                
		declare cur_#msalecardinfo03err3 cursor for                        
		select salebillid,salecardno,firstsalerid,secondsalerid,thirdsalerid,eighthsalerid,ninthsalerid,tenthsalerid,firstsaleamt,secondsaleamt,thirdsaleamt,eighthsaleamt,ninthsaleamt,tenthsaleamt from #msalecardinfo                         
		open cur_#msalecardinfo03err3                        
		fetch cur_#msalecardinfo03err3 into  @e0003_salebillid,@e0003_salecardno,@e0003_firstsalerid,@e0003_secondsalerid,@e0003_thirdsalerid,@e0003_eighthsalerid,@e0003_ninthsalerid,@e0003_tenthsalerid,              
        @e0003_firstsaleamt,@e0003_secondsaleamt,@e0003_thirdsaleamt,@e0003_eighthsaleamt,@e0003_ninthsaleamt,@e0003_tenthsaleamt              
                                    
		while(@@fetch_status=0)                        
		begin  
		
			set @e0003_bill_msalecardinfo=''
			if(isnull(@e0003_eighthsalerid,'')<>'' and ISNULL(@e0003_eighthsaleamt,0)>0)              
			begin              
				if not exists( select 1 from #emp_deperror where @e0003_firstsalerid=empid and emppos  in ('00102','003','006','007') )              
					set @e0003_bill_msalecardinfo=isnull(@e0003_bill_msalecardinfo,'')+'��һ����'+isnull(@e0003_firstsalerid,'')+'����������ʦ���Ƕ�Ӧ���̷�ʦ��������Ӧ��ҵ��'               
				else if( ( convert(numeric(20,1),ISNULL(@e0003_firstsaleamt,0))<10000  and convert(numeric(20,1),ISNULL(@e0003_firstsaleamt,0))<>convert(numeric(20,1),ISNULL(@e0003_eighthsaleamt,0)))             
				or ( convert(numeric(20,1),ISNULL(@e0003_firstsaleamt,0))>=10000 and convert(numeric(20,1),ISNULL(@e0003_eighthsaleamt,0))<>10000))              
						set @e0003_bill_msalecardinfo=isnull(@e0003_bill_msalecardinfo,'')+'��һ����'+isnull(@e0003_firstsalerid,'')+'���Ӧ���̷�ʦ����ҵ����ƥ��'               
                  
			end   
			if(isnull(@e0003_ninthsalerid,'')<>'' and ISNULL(@e0003_ninthsaleamt,0)>0)              
			begin              
				if not exists( select 1 from #emp_deperror where @e0003_secondsalerid=empid and emppos  in ('00102','003','006','007') )              
					set @e0003_bill_msalecardinfo=isnull(@e0003_bill_msalecardinfo,'')+'�ڶ�����'+isnull(@e0003_secondsalerid,'')+'����������ʦ���Ƕ�Ӧ���̷�ʦ��������Ӧ��ҵ��'               
				else if(  ( convert(numeric(20,1),ISNULL(@e0003_secondsaleamt,0))<10000   and convert(numeric(20,1),ISNULL(@e0003_secondsaleamt,0))<>convert(numeric(20,1),ISNULL(@e0003_ninthsaleamt,0)))            
					or ( convert(numeric(20,1),ISNULL(@e0003_secondsaleamt,0))>=10000  and convert(numeric(20,1),ISNULL(@e0003_ninthsaleamt,0))<>10000))              
					set @e0003_bill_msalecardinfo=isnull(@e0003_bill_msalecardinfo,'')+'�ڶ�����'+isnull(@e0003_secondsalerid,'')+'���Ӧ���̷�ʦ����ҵ����ƥ��'               
			end              
         
			if(isnull(@e0003_tenthsalerid,'')<>'' and ISNULL(@e0003_tenthsaleamt,0)>0)              
			begin              
				if not exists( select 1 from #emp_deperror where @e0003_thirdsalerid=empid and emppos  in ('00102','003','006','007') )              
					set @e0003_bill_msalecardinfo=isnull(@e0003_bill_msalecardinfo,'')+'��������'+isnull(@e0003_thirdsalerid,'')+'����������ʦ���Ƕ�Ӧ���̷�ʦ��������Ӧ��ҵ��'               
				else if( (convert(numeric(20,1),ISNULL(@e0003_thirdsaleamt,0))<10000  and convert(numeric(20,1),ISNULL(@e0003_thirdsaleamt,0))<>convert(numeric(20,1),ISNULL(@e0003_tenthsaleamt,0)))            
					or  (convert(numeric(20,1),ISNULL(@e0003_thirdsaleamt,0))>=10000 and convert(numeric(20,1),ISNULL(@e0003_tenthsaleamt,0))<>10000 ))              
					set @e0003_bill_msalecardinfo=isnull(@e0003_bill_msalecardinfo,'')+'��������'+isnull(@e0003_thirdsalerid,'')+'���Ӧ���̷�ʦ����ҵ����ƥ��'               
			end              
                 
               
			if(@e0003_bill_msalecardinfo<>'')              
			begin                
				insert into #result(compid,billtype,errid,remark)                        
				values(@compid,'1','E0003',@e0003_bill_msalecardinfo+'����'+@e0003_salebillid)                
			end                
                      
			fetch cur_#msalecardinfo03err3 into  @e0003_salebillid,@e0003_salecardno,@e0003_firstsalerid,@e0003_secondsalerid,@e0003_thirdsalerid,@e0003_tenthsalerid,@e0003_ninthsalerid,@e0003_tenthsalerid,              
               @e0003_firstsaleamt,@e0003_secondsaleamt,@e0003_thirdsaleamt,@e0003_eighthsaleamt,@e0003_ninthsaleamt,@e0003_tenthsaleamt              
		end                        
		close cur_#msalecardinfo03err3                        
		deallocate cur_#msalecardinfo03err3                        
                        
	end                        
                                       
	drop table #msalecardinfo                      
                    
    CREATE tAbLE	#mcardrechargeinfo              -- ��Ա����ֵ��
	(
		rechargecompid			varchar(10)			Not NULL,   --��ֵ�ŵ�
		rechargebillid			varchar(20)			Not NULL,   --��ֵ���� 
		rechargedate			varchar(8)				NULL,   --��ֵ���� 
		rechargetime			varchar(6)				NULL,   --��ֵʱ�� 
		rechargecardno			varchar(20)				NULL,   --��Ա����
		rechargecardtype		varchar(10)				NULL,   --������
		rechargetype			int						NULL,   --���ѷ�ʽ( 0��ֵ ,6���� ,)
		firstsalerid		varchar(20)				NULL,   --��һ���۹���
		firstsalerinid		varchar(20)				NULL,   --��һ�����ڲ����
		firstsaleamt		float					NULL,   --��һ���۷�����
		secondsalerid		varchar(20)				NULL,   --�ڶ����۹���
		secondsalerinid		varchar(20)				NULL,   --�ڶ������ڲ����
		secondsaleamt		float					NULL,   --�ڶ����۷�����
		thirdsalerid		varchar(20)				NULL,   --�������۹���
		thirdsalerinid		varchar(20)				NULL,   --���������ڲ����
		thirdsaleamt		float					NULL,   --�������۷�����
		fourthsalerid		varchar(20)				NULL,   --�������۹���
		fourthsalerinid		varchar(20)				NULL,   --���������ڲ����
		fourthsaleamt		float					NULL,   --�������۷�����
		fifthsalerid		varchar(20)				NULL,   --�������۹��� -----��Ⱦʦ
		fifthsalerinid		varchar(20)				NULL,   --���������ڲ����
		fifthsaleamt		float					NULL,   --�������۷�����
		sixthsalerid		varchar(20)				NULL,   --�������۹���----- ��Ⱦʦ
		sixthsalerinid		varchar(20)				NULL,   --���������ڲ����
		sixthsaleamt		float					NULL,   --�������۷�����
		seventhsalerid		varchar(20)				NULL,   --�������۹��� -----��Ⱦʦ
		seventhsalerinid	varchar(20)				NULL,   --���������ڲ����
		seventhsaleamt		float					NULL,   --�������۷�����
		eighthsalerid		varchar(20)				NULL,   --�ڰ����۹���----- ��Ⱦʦ
		eighthsalerinid		varchar(20)				NULL,   --�ڰ������ڲ����
		eighthsaleamt		float					NULL,   --�ڰ����۷�����
		ninthsalerid		varchar(20)				NULL,   --�ھ����۹���-----
		ninthsalerinid		varchar(20)				NULL,   --�ھ������ڲ����
		ninthsaleamt		float					NULL,   --�ھ����۷�����
		tenthsalerid		varchar(20)				NULL,   --��ʮ���۹���----- ��Ⱦʦ
		tenthsalerinid		varchar(20)				NULL,   --��ʮ�����ڲ����
		tenthsaleamt		float					NULL,   --��ʮ���۷�����
		financedate			varchar(8)				NULL,   --�������� 
		rechargekeepamt		float					NULL,   --��ֵ���
		paymode				varchar(10)				NULL,	--֧����ʽ
		payamt				float					NULL,	--֧�����
	)     
	
	insert #mcardrechargeinfo(rechargecompid,rechargebillid,rechargedate,rechargetype,rechargecardno,rechargecardtype,firstsalerid,firstsalerinid,firstsaleamt,secondsalerid,secondsalerinid,secondsaleamt,
                     thirdsalerid,thirdsalerinid,thirdsaleamt,fourthsalerid,fourthsalerinid,fourthsaleamt,fifthsalerid,fifthsalerinid,fifthsaleamt,
                     sixthsalerid,sixthsalerinid,sixthsaleamt,seventhsalerid,seventhsalerinid,seventhsaleamt,eighthsalerid,eighthsalerinid,eighthsaleamt,
                     ninthsalerid,ninthsalerinid,ninthsaleamt,tenthsalerid,tenthsalerinid,tenthsaleamt,financedate,rechargekeepamt,paymode,payamt)
	select rechargecompid,rechargebillid,rechargedate,rechargetype,rechargecardno,rechargecardtype,firstsalerid,firstsalerinid,firstsaleamt,secondsalerid,secondsalerinid,secondsaleamt,
                     thirdsalerid,thirdsalerinid,thirdsaleamt,fourthsalerid,fourthsalerinid,fourthsaleamt,fifthsalerid,fifthsalerinid,fifthsaleamt,
                     sixthsalerid,sixthsalerinid,sixthsaleamt,seventhsalerid,seventhsalerinid,seventhsaleamt,eighthsalerid,eighthsalerinid,eighthsaleamt,
                     ninthsalerid,ninthsalerinid,ninthsaleamt,tenthsalerid,tenthsalerinid,tenthsaleamt,financedate,rechargekeepamt,paymode,payamt
    from mcardrechargeinfo, dpayinfo
    where rechargebillid=paybillid and rechargecompid=paycompid and paybilltype='CZ'
      and rechargecompid=@compid and financedate between @fromdate and @todate and ISNULL(rechargekeepamt,0)<>0
      
      
   if exists(select 1 from #mcardrechargeinfo)                        
   begin                        
		declare @e0003_bill_mcardrechargeinfo varchar(1024)                        
		set @e0003_bill_mcardrechargeinfo = ''                        
        declare @e0003_rechargebillid varchar(20)         
		declare @e0003_rechargecardno varchar(20)                
		declare @e0003_firstsalerid_cz varchar(20), @e0003_secondsalerid_cz varchar(20), @e0003_thirdsalerid_cz varchar(20), @e0003_eighthsalerid_cz varchar(20) , @e0003_ninthsalerid_cz varchar(20) , @e0003_tenthsalerid_cz varchar(20)                  
		declare @e0003_firstsaleamt_cz float, @e0003_secondsaleamt_cz float, @e0003_thirdsaleamt_cz float, @e0003_eighthsaleamt_cz float, @e0003_ninthsaleamt_cz float, @e0003_tenthsaleamt_cz float              
	                
		declare cur_#mcardrechargeinfo03err3 cursor for                        
		select rechargebillid,rechargecardno, firstsalerid,secondsalerid,thirdsalerid,eighthsalerid,ninthsalerid,tenthsalerid,firstsaleamt,secondsaleamt,thirdsaleamt,eighthsaleamt,ninthsaleamt,tenthsaleamt from #mcardrechargeinfo              
		open cur_#mcardrechargeinfo03err3                        
		fetch cur_#mcardrechargeinfo03err3 into  @e0003_rechargebillid,@e0003_rechargecardno,@e0003_firstsalerid_cz,@e0003_secondsalerid_cz,@e0003_thirdsalerid_cz,@e0003_eighthsalerid_cz,@e0003_ninthsalerid_cz,@e0003_tenthsalerid_cz,              
				   @e0003_firstsaleamt_cz,@e0003_secondsaleamt_cz,@e0003_thirdsaleamt_cz,@e0003_eighthsaleamt_cz,@e0003_ninthsaleamt_cz,@e0003_tenthsaleamt_cz              
	                                    
		while(@@fetch_status=0)                        
		begin         
	                
			set @e0003_bill_mcardrechargeinfo=''
			if(isnull(@e0003_eighthsalerid_cz,'')<>'' and ISNULL(@e0003_eighthsaleamt_cz,0)>0)              
			begin              
				if not exists( select 1 from #emp_deperror where @e0003_firstsalerid_cz=empid and emppos  in ('00102','003','006','007') )              
					set @e0003_bill_mcardrechargeinfo=isnull(@e0003_bill_mcardrechargeinfo,'')+'��һ����'+isnull(@e0003_firstsalerid_cz,'')+'����������ʦ���Ƕ�Ӧ���̷�ʦ��������Ӧ��ҵ��'               
				else if( (convert(numeric(20,1),ISNULL(@e0003_firstsaleamt_cz,0))<10000  and convert(numeric(20,1),ISNULL(@e0003_firstsaleamt_cz,0))<>convert(numeric(20,1),ISNULL(@e0003_eighthsaleamt_cz,0)))            
				or   (convert(numeric(20,1),ISNULL(@e0003_firstsaleamt_cz,0))>=10000 and convert(numeric(20,1),ISNULL(@e0003_eighthsaleamt_cz,0))<>10000 ))              
					set @e0003_bill_mcardrechargeinfo=isnull(@e0003_bill_mcardrechargeinfo,'')+'��һ����'+isnull(@e0003_firstsalerid_cz,'')+'���Ӧ���̷�ʦ����ҵ����ƥ��'               
	                  
			end              
	                 
			if(isnull(@e0003_ninthsalerid_cz,'')<>'' and ISNULL(@e0003_ninthsaleamt_cz,0)>0)              
			begin              
				if not exists( select 1 from #emp_deperror where @e0003_secondsalerid_cz=empid and emppos  in ('00102','003','006','007') )              
					set @e0003_bill_mcardrechargeinfo=isnull(@e0003_bill_mcardrechargeinfo,'')+'�ڶ�����'+isnull(@e0003_secondsalerid_cz,'')+'����������ʦ���Ƕ�Ӧ���̷�ʦ��������Ӧ��ҵ��'               
				else if( (convert(numeric(20,1),ISNULL(@e0003_secondsaleamt_cz,0))<10000  and convert(numeric(20,1),ISNULL(@e0003_secondsaleamt_cz,0))<>convert(numeric(20,1),ISNULL(@e0003_ninthsaleamt_cz,0)))            
				or   (convert(numeric(20,1),ISNULL(@e0003_secondsaleamt_cz,0))>=10000 and convert(numeric(20,1),ISNULL(@e0003_ninthsaleamt_cz,0))<>10000 ))              
					set @e0003_bill_mcardrechargeinfo=isnull(@e0003_bill_mcardrechargeinfo,'')+'�ڶ�����'+isnull(@e0003_secondsalerid_cz,'')+'���Ӧ���̷�ʦ����ҵ����ƥ��'               
			end              
	                 
			if(isnull(@e0003_tenthsalerid_cz,'')<>'' and ISNULL(@e0003_tenthsaleamt_cz,0)>0)              
			begin              
				if not exists( select 1 from #emp_deperror where @e0003_thirdsalerid_cz=empid and emppos  in ('00102','003','006','007') )              
					set @e0003_bill_mcardrechargeinfo=isnull(@e0003_bill_mcardrechargeinfo,'')+'��������'+isnull(@e0003_thirdsalerid_cz,'')+'����������ʦ���Ƕ�Ӧ���̷�ʦ��������Ӧ��ҵ��'               
				else if( (convert(numeric(20,1),ISNULL(@e0003_thirdsaleamt_cz,0))<10000  and convert(numeric(20,1),ISNULL(@e0003_thirdsaleamt_cz,0))<>convert(numeric(20,1),ISNULL(@e0003_tenthsaleamt_cz,0)))            
				or   (convert(numeric(20,1),ISNULL(@e0003_thirdsaleamt_cz,0))>=10000 and convert(numeric(20,1),ISNULL(@e0003_tenthsaleamt_cz,0))<>10000 ))              
					set @e0003_bill_mcardrechargeinfo=isnull(@e0003_bill_mcardrechargeinfo,'')+'��������'+isnull(@e0003_thirdsalerid_cz,'')+'���Ӧ���̷�ʦ����ҵ����ƥ��'               
			end  
			   
			if(@e0003_bill_mcardrechargeinfo<>'')              
			begin                
				insert into #result(compid,billtype,errid,remark)                        
				values(@compid,'2','E0003',@e0003_bill_mcardrechargeinfo+'����'+@e0003_rechargebillid)                
			end                
	                      
			fetch cur_#mcardrechargeinfo03err3 into  @e0003_rechargebillid,@e0003_rechargecardno,@e0003_firstsalerid_cz,@e0003_secondsalerid_cz,@e0003_thirdsalerid_cz,@e0003_eighthsalerid_cz,@e0003_ninthsalerid_cz,@e0003_tenthsalerid_cz,              
				   @e0003_firstsaleamt_cz,@e0003_secondsaleamt_cz,@e0003_thirdsaleamt_cz,@e0003_eighthsaleamt_cz,@e0003_ninthsaleamt_cz,@e0003_tenthsaleamt_cz              
	   end                        
	  close cur_#mcardrechargeinfo03err3                        
	  deallocate cur_#mcardrechargeinfo03err3                      
	  end
      
     drop table #mcardrechargeinfo    
     
     
        CREATE tAbLE	#mcardchangeinfo             -- ��Ա���춯
	(
		changecompid		varchar(10)			Not NULL,   --��ֵ�ŵ�
		changebillid		varchar(20)			Not NULL,   --��ֵ���� 
		changetype			int					Not NULL,
		changedate			varchar(8)				NULL,   --��ֵ���� 
		changetime			varchar(6)				NULL,   --��ֵʱ�� 
		changeaftercardno	varchar(20)				NULL,   --��Ա����
		changeaftercardtype	varchar(10)				NULL,   --������
		firstsalerid		varchar(20)				NULL,   --��һ���۹���
		firstsalerinid		varchar(20)				NULL,   --��һ�����ڲ����
		firstsaleamt		float					NULL,   --��һ���۷�����
		secondsalerid		varchar(20)				NULL,   --�ڶ����۹���
		secondsalerinid		varchar(20)				NULL,   --�ڶ������ڲ����
		secondsaleamt		float					NULL,   --�ڶ����۷�����
		thirdsalerid		varchar(20)				NULL,   --�������۹���
		thirdsalerinid		varchar(20)				NULL,   --���������ڲ����
		thirdsaleamt		float					NULL,   --�������۷�����
		fourthsalerid		varchar(20)				NULL,   --�������۹���
		fourthsalerinid		varchar(20)				NULL,   --���������ڲ����
		fourthsaleamt		float					NULL,   --�������۷�����
		fifthsalerid		varchar(20)				NULL,   --�������۹��� -----��Ⱦʦ
		fifthsalerinid		varchar(20)				NULL,   --���������ڲ����
		fifthsaleamt		float					NULL,   --�������۷�����
		sixthsalerid		varchar(20)				NULL,   --�������۹���----- ��Ⱦʦ
		sixthsalerinid		varchar(20)				NULL,   --���������ڲ����
		sixthsaleamt		float					NULL,   --�������۷�����
		seventhsalerid		varchar(20)				NULL,   --�������۹��� -----��Ⱦʦ
		seventhsalerinid	varchar(20)				NULL,   --���������ڲ����
		seventhsaleamt		float					NULL,   --�������۷�����
		eighthsalerid		varchar(20)				NULL,   --�ڰ����۹���----- ��Ⱦʦ
		eighthsalerinid		varchar(20)				NULL,   --�ڰ������ڲ����
		eighthsaleamt		float					NULL,   --�ڰ����۷�����
		ninthsalerid		varchar(20)				NULL,   --�ھ����۹���-----
		ninthsalerinid		varchar(20)				NULL,   --�ھ������ڲ����
		ninthsaleamt		float					NULL,   --�ھ����۷�����
		tenthsalerid		varchar(20)				NULL,   --��ʮ���۹���----- ��Ⱦʦ
		tenthsalerinid		varchar(20)				NULL,   --��ʮ�����ڲ����
		tenthsaleamt		float					NULL,   --��ʮ���۷�����
		financedate			varchar(8)				NULL,   --�������� 
		changefillamt		float					NULL,   --��ֵ���
		paymode				varchar(10)				NULL,	--֧����ʽ
		payamt				float					NULL,	--֧�����
	)   
	
	insert #mcardchangeinfo(changecompid,changebillid,changetype,changedate,changeaftercardno,changeaftercardtype,firstsalerid,firstsalerinid,firstsaleamt,secondsalerid,secondsalerinid,secondsaleamt,
                     thirdsalerid,thirdsalerinid,thirdsaleamt,fourthsalerid,fourthsalerinid,fourthsaleamt,fifthsalerid,fifthsalerinid,fifthsaleamt,
                     sixthsalerid,sixthsalerinid,sixthsaleamt,seventhsalerid,seventhsalerinid,seventhsaleamt,eighthsalerid,eighthsalerinid,eighthsaleamt,
                     ninthsalerid,ninthsalerinid,ninthsaleamt,tenthsalerid,tenthsalerinid,tenthsaleamt,financedate,changefillamt,paymode,payamt)
	select changecompid,changebillid,changetype,changedate,changeaftercardno,changeaftercardtype,firstsalerid,firstsalerinid,firstsaleamt,secondsalerid,secondsalerinid,secondsaleamt,
                     thirdsalerid,thirdsalerinid,thirdsaleamt,fourthsalerid,fourthsalerinid,fourthsaleamt,fifthsalerid,fifthsalerinid,fifthsaleamt,
                     sixthsalerid,sixthsalerinid,sixthsaleamt,seventhsalerid,seventhsalerinid,seventhsaleamt,eighthsalerid,eighthsalerinid,eighthsaleamt,
                     ninthsalerid,ninthsalerinid,ninthsaleamt,tenthsalerid,tenthsalerinid,tenthsaleamt,financedate,changefillamt,paymode,payamt
    from mcardchangeinfo, dpayinfo
    where changebillid=paybillid and changecompid=paycompid and paybilltype in ('ZK','TK')
      and changecompid=@compid and financedate between @fromdate and @todate and ISNULL(changefillamt,0)<>0
      
      
    if exists(select 1 from #mcardchangeinfo)                        
	begin                        
		declare @e0003_changebillid varchar(20)	
		declare @e0003_bill_mcardchangeinfo varchar(1024)                        
		set @e0003_bill_mcardchangeinfo = ''                        
		declare @e0003_firstsalerid_zk varchar(20), @e0003_secondsalerid_zk varchar(20), @e0003_thirdsalerid_zk varchar(20), @e0003_eighthsalerid_zk varchar(20) , @e0003_ninthsalerid_zk varchar(20) , @e0003_tenthsalerid_zk varchar(20)                  
		declare @e0003_firstsaleamt_zk float, @e0003_secondsaleamt_zk float, @e0003_thirdsaleamt_zk float, @e0003_eighthsaleamt_zk float, @e0003_ninthsaleamt_zk float, @e0003_tenthsaleamt_zk float      
                
		declare cur_#mcardchangeinfoerr3 cursor for                        
		select changebillid, firstsalerid_zk,secondsalerid_zk,thirdsalerid_zk,eighthsalerid_zk,ninthsalerid_zk,tenthsalerid_zk, firstsaleamt_zk,secondsaleamt_zk,thirdsaleamt_zk,eighthsaleamt_zk,ninthsaleamt_zk,tenthsaleamt_zk from #mcardchangeinfo              
		open cur_#mcardchangeinfoerr3                        
		fetch cur_#mcardchangeinfoerr3 into  @e0003_changebillid,@e0003_firstsalerid_zk,@e0003_secondsalerid_zk,@e0003_thirdsalerid_zk,@e0003_eighthsalerid_zk,@e0003_ninthsalerid_zk,@e0003_tenthsalerid_zk,              
            @e0003_firstsaleamt_zk,@e0003_secondsaleamt_zk,@e0003_thirdsaleamt_zk,@e0003_eighthsaleamt_zk,@e0003_ninthsaleamt_zk,@e0003_tenthsaleamt_zk              
                              
		while(@@fetch_status=0)                        
		begin  
			set @e0003_bill_mcardchangeinfo=''
			if(isnull(@e0003_eighthsalerid_zk,'')<>'' and ISNULL(@e0003_eighthsaleamt_zk,0)>0)              
			begin              
				if not exists( select 1 from #emp_deperror,#mcardchangeinfo where @e0003_firstsalerid_zk=empid and emppos  in ('00102','003','006','007') )              
					set @e0003_bill_mcardchangeinfo=isnull(@e0003_bill_mcardchangeinfo,'')+'��һ����'+isnull(@e0003_firstsalerid_zk,'')+'����������ʦ���Ƕ�Ӧ���̷�ʦ��������Ӧ��ҵ��'               
				else if( (convert(numeric(20,1),ISNULL(@e0003_firstsaleamt_zk,0))<10000  and convert(numeric(20,1),ISNULL(@e0003_firstsaleamt_zk,0))<>convert(numeric(20,1),ISNULL(@e0003_eighthsaleamt_zk,0)))            
				or  (convert(numeric(20,1),ISNULL(@e0003_firstsaleamt_zk,0))>=10000 and convert(numeric(20,1),ISNULL(@e0003_eighthsaleamt_zk,0))<>10000) )              
					set @e0003_bill_mcardchangeinfo=isnull(@e0003_bill_mcardchangeinfo,'')+'��һ����'+isnull(@e0003_firstsalerid_zk,'')+'���Ӧ���̷�ʦ����ҵ����ƥ��'               
                  
			end              
                 
			if(isnull(@e0003_ninthsalerid_zk,'')<>'' and ISNULL(@e0003_ninthsaleamt_zk,0)>0)              
			begin              
				if not exists( select 1 from #emp_deperror,#mcardchangeinfo where @e0003_secondsalerid_zk=empid and emppos  in ('00102','003','006','007') )              
					set @e0003_bill_mcardchangeinfo=isnull(@e0003_bill_mcardchangeinfo,'')+'�ڶ�����'+isnull(@e0003_secondsalerid_zk,'')+'����������ʦ���Ƕ�Ӧ���̷�ʦ��������Ӧ��ҵ��'               
				else if( (convert(numeric(20,1),ISNULL(@e0003_secondsaleamt_zk,0))<10000  and convert(numeric(20,1),ISNULL(@e0003_secondsaleamt_zk,0))<>convert(numeric(20,1),ISNULL(@e0003_ninthsaleamt_zk,0)))            
					or  (convert(numeric(20,1),ISNULL(@e0003_secondsaleamt_zk,0))>=10000 and convert(numeric(20,1),ISNULL(@e0003_ninthsaleamt_zk,0))<>10000) )              
					set @e0003_bill_mcardchangeinfo=isnull(@e0003_bill_mcardchangeinfo,'')+'�ڶ�����'+isnull(@e0003_secondsalerid_zk,'')+'���Ӧ���̷�ʦ����ҵ����ƥ��'               
			end              
                 
			if(isnull(@e0003_tenthsalerid_zk,'')<>'' and ISNULL(@e0003_tenthsaleamt_zk,0)>0)              
			begin              
				if not exists( select 1 from #emp_deperror,#mcardchangeinfo where @e0003_thirdsalerid_zk=empid and emppos  in ('00102','003','006','007') )              
					set @e0003_bill_mcardchangeinfo=isnull(@e0003_bill_mcardchangeinfo,'')+'��������'+isnull(@e0003_thirdsalerid_zk,'')+'����������ʦ���Ƕ�Ӧ���̷�ʦ��������Ӧ��ҵ��'               
				else if( (convert(numeric(20,1),ISNULL(@e0003_thirdsaleamt_zk,0))<10000  and convert(numeric(20,1),ISNULL(@e0003_thirdsaleamt_zk,0))<>convert(numeric(20,1),ISNULL(@e0003_tenthsaleamt_zk,0)))            
				or  (convert(numeric(20,1),ISNULL(@e0003_thirdsaleamt_zk,0))>=10000 and convert(numeric(20,1),ISNULL(@e0003_tenthsaleamt_zk,0))<>10000) )              
				set @e0003_bill_mcardchangeinfo=isnull(@e0003_bill_mcardchangeinfo,'')+'��������'+isnull(@e0003_thirdsalerid_zk,'')+'���Ӧ���̷�ʦ����ҵ����ƥ��'               
			end       
                
			if(@e0003_bill_mcardchangeinfo<>'')              
			begin                
				insert into #result(compid,billtype,errid,remark)                        
				values(@compid,'4','E0003',@e0003_bill_mcardchangeinfo+'����'+@e0003_changebillid)                
			end                
                      
			fetch cur_#mcardchangeinfoerr3 into  @e0003_changebillid,@e0003_firstsalerid_zk,@e0003_secondsalerid_zk,@e0003_thirdsalerid_zk,@e0003_eighthsalerid_zk,@e0003_ninthsalerid_zk,@e0003_tenthsalerid_zk,              
				@e0003_firstsaleamt_zk,@e0003_secondsaleamt_zk,@e0003_thirdsaleamt_zk,@e0003_eighthsaleamt_zk,@e0003_ninthsaleamt_zk,@e0003_tenthsaleamt_zk              
		end                        
		close cur_#mcardchangeinfoerr3                        
		deallocate cur_#mcardchangeinfoerr3  
	end              
 
	drop table #mcardchangeinfo            
               
     CREATE tAbLE	#mproexchangeinfo               -- ��Ա���Ƴ̶һ�
	(
		changecompid			varchar(10)			Not NULL,   --��˾���
		changebillid			varchar(20)			Not NULL,   --���۵���
		changedate				varchar(8)				NULL,   --��������
		changecardno			varchar(20)				NULL,   --���ۿ���
		changecardtype			varchar(20)				NULL,   --���ۿ�����
		firstsalerid			varchar(20)				NULL,			--��һ���۹���
		firstsalerinid			varchar(20)				NULL,			--��һ�����ڲ����
		firstsaleamt			float					NULL,			--��һ���۷�����
		secondsalerid			varchar(20)				NULL,			--�ڶ����۹���
		secondsalerinid			varchar(20)				NULL,			--�ڶ������ڲ����
		secondsaleamt			float					NULL,			--�ڶ����۷�����
		thirdsalerid			varchar(20)				NULL,			--�������۹���----- ��Ⱦʦ
		thirdsalerinid			varchar(20)				NULL,			--���������ڲ����
		thirdsaleamt			float					NULL,			--�������۷�����
		fourthsalerid			varchar(20)				NULL,			--�������۹���----- ��Ⱦʦ
		fourthsalerinid			varchar(20)				NULL,			--���������ڲ����
		fourthsaleamt			float					NULL,			--�������۷�����
		financedate				varchar(8)				NULL,   --�������� 
		changeproamt			float					NULL,	--��ֵ���
		paymode					varchar(10)				NULL,	--֧����ʽ
		payamt					float					NULL,	--֧�����
	)  
	insert #mproexchangeinfo(changecompid,changebillid,changedate,changecardno,changecardtype,firstsalerid,firstsalerinid,firstsaleamt,secondsalerid,secondsalerinid,secondsaleamt,
                     thirdsalerid,thirdsalerinid,thirdsaleamt,fourthsalerid,fourthsalerinid,fourthsaleamt,financedate,changeproamt,paymode,payamt)   
    select a.changecompid,a.changebillid,changedate,changecardno,changecardtype,firstsalerid,firstsalerinid,firstsaleamt,secondsalerid,secondsalerinid,secondsaleamt,
                     thirdsalerid,thirdsalerinid,thirdsaleamt,fourthsalerid,fourthsalerinid,fourthsaleamt,financedate,changebyaccountamt,changepaymode,changebycashamt 
        from mproexchangeinfo a,dproexchangeinfo b
    where a.changecompid=b.changecompid and a.changebillid=b.changebillid
    and  financedate between @fromdate and @todate and ISNULL(changeproamt,0)<>0 and a.changecompid=@compid
    
    if exists(select 1 from #mproexchangeinfo)                        
	begin                        
		declare @e0010_bill_mproexchangeinfo varchar(1024)                        
		set @e0010_bill_mproexchangeinfo = ''           
		declare @e0010_changecompid varchar(10),  @e0010_changecardno varchar(20) ,  @e0010_changebillid varchar(20)          
		declare @e0010_changeproamt float,   @e0010_payamt float                     
		declare @e0010_firstsalerid varchar(20), @e0010_secondsalerid varchar(20), @e0010_gcq14c varchar(20), @e0010_gcq15c varchar(20)                  
		declare @e0010_firstsaleamt float, @e0010_secondsaleamt float, @e0010_gcq16f float, @e0010_gcq17f float          
                
		declare cur_#mproexchangeinfo1err10 cursor for                        
		select changecompid,changecardno,changebillid,changeproamt,payamt,firstsalerid,firstsaleamt,secondsalerid,secondsaleamt from #mproexchangeinfo           
		open cur_#mproexchangeinfo1err10                        
		fetch cur_#mproexchangeinfo1err10 into  @e0010_changecompid,@e0010_changecardno,@e0010_changebillid,@e0010_changeproamt,@e0010_payamt,          
		@e0010_firstsalerid,@e0010_firstsaleamt,@e0010_secondsalerid,@e0010_secondsaleamt        
                              
		while(@@fetch_status=0)                        
		begin   
			set @e0010_bill_mproexchangeinfo='' 
			if(ISNULL(@e0010_changeproamt,0)+ISNULL(@e0010_payamt,0)>0 and ISNULL(@e0010_firstsaleamt,0)+ISNULL(@e0010_secondsaleamt,0)=0)          
			begin          
				insert into #result(compid,billtype,errid,remark)                        
				values(@compid,'10','E0010','�����Ƴ̶һ�δ������'+'����'+@e0010_changecardno+'����'+@e0010_changebillid)             
			end           
                      
			fetch cur_#mproexchangeinfo1err10 into  @e0010_changecompid,@e0010_changecardno,@e0010_changebillid,@e0010_changeproamt,@e0010_payamt,          
			@e0010_firstsalerid,@e0010_firstsaleamt,@e0010_secondsalerid,@e0010_secondsaleamt           
		end                        
		close cur_#mproexchangeinfo1err10                        
		deallocate cur_#mproexchangeinfo1err10                        
                        
	end 
 
    drop table #mproexchangeinfo   
                         
                                              
 -------------------------------------------------------------------------------------                      
 update a set errdescript = description                       
 from #result a,#error b                      
 where a.errid = b.errid                      
                      
 select compid,billtype,errid,errdescript,remark                       
 from #result                    
                      
                      
 drop table #result               
                   
 drop table #emp_deperror                 
 drop table #error                      
end 
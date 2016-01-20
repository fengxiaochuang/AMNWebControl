alter procedure upg_prepare_compute_staff_subsidy(                
 @compid    varchar(10), -- ��˾��                
 @fromdate   varchar(10), -- ��ʼ����                
 @todate    varchar(10)  -- ��������      
)       
as      
begin   
	create table #mstaffsubsidyinfo
	(
		entrycompid 				varchar(10) 	        not null,		--	�Ǽǹ�˾
		entrybillid 				varchar(20)				not null,		--	�Ǽǵ���
		handcompid					varchar(10)					null,		--	�ŵ�
		handstaffid 				varchar(20)					null,		--	Ա��
		handstaffinid 				varchar(20)					null,		--	Ա��
		subsidyamt					float						null,		--  ���׶��
		subsidyflag					int							null,		--  ���׷�ʽ ȫ������ ��������
		conditionnum				int							null,		--  ����������
	) 

	insert #mstaffsubsidyinfo(entrycompid,entrybillid,handcompid,handstaffid,handstaffinid,subsidyamt,subsidyflag,conditionnum)
	select entrycompid,entrybillid,handcompid,handstaffid,handstaffinid,subsidyamt,subsidyflag,conditionnum 
	from mstaffsubsidyinfo where startdate<=SUBSTRING(@fromdate,1,6) and enddate>=SUBSTRING(@fromdate,1,6) 
	 and handcompid=@compid and ISNULL(billflag,0)=1
 
	
    declare @entrycompid varchar(10) 
	declare @entrybillid varchar(20)  
    declare @handstaffinid varchar(20)
    declare @subsidyamt		float
    declare @subsidyflag	int
    declare @conditionnum	int 
    
    declare @stafftotalyeji		float	--������ҵ��
	declare	@staffrealtotalyeji	float	--����ʵҵ��
	declare	@oldcustomercount	float	--�����Ͽ���
	declare	@beatyprjcount		float	--���ݴ�����
	declare	@tangrancount		float	--��Ⱦ�Ƴ���
	
	declare @condtion1 int set @condtion1=0
	declare @condtion2 int set @condtion2=0
	declare @condtion3 int set @condtion3=0
	declare @condtion4 int set @condtion4=0
	declare @condtion5 int set @condtion5=0
	
	declare @condtionamt1 float set @condtionamt1=0
	declare @condtionamt2 float set @condtionamt2=0
	declare @condtionamt3 float set @condtionamt3=0
	declare @condtionamt4 float set @condtionamt4=0
	declare @condtionamt5 float set @condtionamt5=0
	
	declare @totalcontioncount	int	 set @totalcontioncount=0	--������
	declare @sufficecount		int  set @sufficecount=0		--������
	declare cur_each_subsidy cursor for  
	select entrycompid,entrybillid,handstaffinid,subsidyamt,subsidyflag,conditionnum
	from #mstaffsubsidyinfo  order by entrybillid
	open cur_each_subsidy
	fetch cur_each_subsidy into @entrycompid,@entrybillid,@handstaffinid,@subsidyamt,@subsidyflag,@conditionnum  
	while @@fetch_status = 0  
	begin  

		if(@conditionnum=0)
		begin
			insert #staffsubsidy(staffinid,staffsubsidy)
			values( @handstaffinid,@subsidyamt)
		end
		else
		begin
			select @stafftotalyeji=sum(isnull(stafftotalyeji,0)),@staffrealtotalyeji=sum(isnull(staffrealtotalyeji,0)),
			       @oldcustomercount=sum(isnull(oldcustomercount,0)),@beatyprjcount=sum(isnull(beatyprjcount,0)),
			       @tangrancount=sum(isnull(tangrancount,0)) from staffresultset
			where compid= @compid and ddate between @fromdate and @todate and staffinid=@handstaffinid
			
			select @condtion1=1,@condtionamt1=subsidyamt from dstaffsubsidyinfo where entrycompid=@entrycompid and entrybillid=@entrybillid and subsidytype=1
			select @condtion2=1,@condtionamt2=subsidyamt from dstaffsubsidyinfo where entrycompid=@entrycompid and entrybillid=@entrybillid and subsidytype=2
			select @condtion3=1,@condtionamt3=subsidyamt from dstaffsubsidyinfo where entrycompid=@entrycompid and entrybillid=@entrybillid and subsidytype=3
			select @condtion4=1,@condtionamt4=subsidyamt from dstaffsubsidyinfo where entrycompid=@entrycompid and entrybillid=@entrybillid and subsidytype=4
			select @condtion5=1,@condtionamt5=subsidyamt from dstaffsubsidyinfo where entrycompid=@entrycompid and entrybillid=@entrybillid and subsidytype=5
			
			--������ҵ��
			if(ISNULL(@condtion1,0)=1)
			begin
				set @totalcontioncount=@totalcontioncount+1
				if(ISNULL(@stafftotalyeji,0)>=ISNULL(@condtionamt1,0))
					set @sufficecount=@sufficecount+1
			end
			--����ʵҵ��
			if(ISNULL(@condtion2,0)=1)
			begin
				set @totalcontioncount=@totalcontioncount+1
				if(ISNULL(@staffrealtotalyeji,0)>=ISNULL(@condtionamt2,0))
					set @sufficecount=@sufficecount+1
			end
			--�����Ͽ���
			if(ISNULL(@condtion3,0)=1)
			begin
				set @totalcontioncount=@totalcontioncount+1
				if(ISNULL(@oldcustomercount,0)>=ISNULL(@condtionamt3,0))
					set @sufficecount=@sufficecount+1
			end
			--������Ŀ��
			if(ISNULL(@condtion4,0)=1)
			begin
				set @totalcontioncount=@totalcontioncount+1
				if(ISNULL(@beatyprjcount,0)>=ISNULL(@condtionamt4,0))
					set @sufficecount=@sufficecount+1
			end
			--��Ⱦ��Ŀ��
			if(ISNULL(@condtion5,0)=1)
			begin
				set @totalcontioncount=@totalcontioncount+1
				if(ISNULL(@tangrancount,0)>=ISNULL(@condtionamt5,0))
					set @sufficecount=@sufficecount+1
			end
			if(isnull(@subsidyflag,1)=1 and ISNULL(@totalcontioncount,0)=ISNULL(@sufficecount,0)) --ȫ������
			begin
					insert #staffsubsidy(staffinid,staffsubsidy)
					values( @handstaffinid,@subsidyamt)
			end
			else if(isnull(@subsidyflag,1)=2 and  ISNULL(@sufficecount,0)>=ISNULL(@conditionnum,0))
			begin
					insert #staffsubsidy(staffinid,staffsubsidy)
					values( @handstaffinid,@subsidyamt)
			end
		end
		fetch cur_each_subsidy into @entrycompid,@entrybillid,@handstaffinid,@subsidyamt,@subsidyflag,@conditionnum  
	end  
	close cur_each_subsidy  
	deallocate cur_each_subsidy 
	
	drop table #mstaffsubsidyinfo
end
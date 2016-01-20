
if exists(select 1 from sysobjects where type='P' and name='upg_position_analisisbycomp')
	drop procedure upg_position_analisisbycomp
go
CREATE procedure upg_position_analisisbycomp      
(        
  @compid        varchar(10),       --��˾���    
  @type          int,               --��ѯ���� 1,��ְ 2����ְ 3 �������  ��4,������    
  @fromdate      varchar(18),       --��ʼ����       
  @todate        varchar(18)        --��������        
)        
as -- ÿ�������춯���ݷ�������    
begin     
 create table #temp (          
     
      compid        varchar(10)     null,       -- �ŵ���    
      compname      varchar(40)     null,       -- �ŵ�����        
      oldposid      varchar(16)     null,       -- ԭְλ��� 
      oldposcount   int				null,       -- ְλ����
      totalcount	int				null,       -- ������
  )    

 if @type=1 or @type=2    
 begin    
  -- û��ͳ�ƴ���������ػع�˾����    
  insert into #temp(compid,oldposid)    
  select appchangecompid,beforepostation    
  from staffchangeinfo,staffinfo,compchaininfo     
  where changetype=@type     
   and staffmangerno=manageno 
   and appchangecompid=relationcomp
   and curcomp=@compid    
   and validatestartdate between @fromdate and @todate  
   and billflag=8  
 end    
 if @type=3 or @type=4    
 begin    
      
    if @type=3     
    begin     
    
		  insert into #temp(compid,oldposid)    
		  select appchangecompid,beforepostation    
		  from staffchangeinfo,staffinfo,compchaininfo     
		  where changetype=5     
		   and staffmangerno=manageno 
		   and appchangecompid=relationcomp
		   and curcomp=@compid    
		   and validatestartdate between @fromdate and @todate  
		   and billflag=8  
    end    
	if @type=4     
	begin     
	      insert into #temp(compid,oldposid)    
		  select appchangecompid,beforepostation    
		  from staffchangeinfo,staffinfo,compchaininfo     
		  where changetype=6     
		   and staffmangerno=manageno 
		   and appchangecompid=relationcomp
		   and curcomp=@compid    
		   and validatestartdate between @fromdate and @todate  
		   and billflag=8  
	end 
 end    
 
 update #temp set compname=b.compname
 from #temp a,companyinfo b
 where compid=compno
 
 update a set oldposcount=cnt
 from #temp a,(
 select compid,oldposid,cnt=count(1) from #temp    
 group by compid,oldposid ) b
 where a.compid=b.compid and a.oldposid=b.oldposid   
 
  update a set totalcount=b.oldposcount
 from #temp a,(
 select compid,oldposcount=sum(isnull(oldposcount,0)) from #temp    
 group by compid ) b
 where a.compid=b.compid   
 

	declare @sqltitle varchar(1000)  
	select @sqltitle = isnull(@sqltitle + '],[' , '') + parentcodekey+'Count' from commoninfo where infotype='GZGW'   
	set @sqltitle = '[' + @sqltitle + ']'  
 
    
  update #temp set oldposid=oldposid+'Count'
  exec ('select * from (select * from #temp ) a pivot (max(oldposcount) for oldposid in (' + @sqltitle + ')) b order by compid')  

 drop table #temp
end
go

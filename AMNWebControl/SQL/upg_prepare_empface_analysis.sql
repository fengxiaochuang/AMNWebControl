alter procedure upg_prepare_empface_analysis(                                
 @compid  varchar(10), -- ��˾��                                
 @fromdate  varchar(10), -- ��ʼ����                                
 @todate  varchar(10), -- ��������                 
 @faceid  int ,   -- ���ں�  
 @searcjflag  int    -- 1 Ա����ѯ 2 �ŵ��ѯ                     
)                   
as                      
begin                 
 CREATE table #staffkqrecordinfo                 
 (                
  compid    varchar(10)    NULL, --�����ŵ�                
  machineid   varchar(20)    NULL,   --���ڻ���                
  personid   varchar(10)    NULL, --������ָ��                
  ddate    varchar(10)    NULL, --��������                
  ttime    varchar(10)    NULL, --����ʱ��                
 )                
 insert #staffkqrecordinfo(machineid,personid,ddate,ttime)                
 select machineid,personid,ddate,ttime from  staffkqrecordinfo where ddate between @fromdate and @todate                
 update a set compid=b.compid                
 from #staffkqrecordinfo a,sysparaminfo b                
 where paramid='SP072' and paramvalue=machineid                
  --26808  26818              
                
 update #staffkqrecordinfo set personid=22091 where machineid='99001' and personid='26808'             
 update #staffkqrecordinfo set personid=25976 where machineid='99001' and personid='26806'             
 update #staffkqrecordinfo set personid=22093 where machineid='99001' and personid='26818'              
 update #staffkqrecordinfo set personid=137328 where machineid='99001' and personid='10905'              
 update #staffkqrecordinfo set personid=137230 where machineid='99001' and personid='103016'             
 update #staffkqrecordinfo set personid=26475 where machineid='99001' and personid='10515'            
 update #staffkqrecordinfo set personid=21031 where machineid='99001' and personid='10302'            
 update #staffkqrecordinfo set personid=137202 where machineid='99001' and personid='10613'    
 update #staffkqrecordinfo set personid=21146 where machineid='99001' and personid='10904'    
 update #staffkqrecordinfo set personid=21005 where machineid='99001' and personid='10106'     
                 
 if(@compid='001') --ָ�ƺ�Ϊ����                
 begin                
  select @faceid=fingerno from staffinfo where compno=@compid and CAST(staffno as int)=@faceid                 
  update a set personid=fingerno from #staffkqrecordinfo a,staffinfo b                
  where a.compid='001' and personid=CAST(staffno as int) and compno='001'                
 end                
                 
 delete #staffkqrecordinfo where personid<>@faceid                
                 
            
 create table #faceresult                
 (                
 workdate   varchar(10)  null,                
 weekdays   varchar(10)  null,                
 compid   varchar(10)  null,                
 compname   varchar(30)  null,                
 staffno   varchar(20)  null,                
 staffname   varchar(20)  null,                
 ontime   varchar(20)  null,                
 downtime   varchar(20)  null,        
 leavemark   varchar(400) null,   
 checkdate   varchar(10)    null ,  
 checkuseid   varchar(20)    null ,               
 )                
                 
 declare @tmpenddate varchar(8)                  
 set @tmpenddate = @fromdate                
 while (@tmpenddate <= @todate)                                                          
    begin                  
  insert #faceresult(workdate,weekdays)                
  values(@tmpenddate,case (datepart(dw,cast(@tmpenddate as datetime)))                 
  when 1  then '������'                
  when 2 then '����һ'                
  when 3  then '���ڶ�'                
  when 4  then '������'                
  when 5  then '������'                
  when 6  then '������'                
  when 7  then '������'                
  end)                
  execute upg_date_plus @tmpenddate,1,@tmpenddate output                         
 end                
                 
 update a set staffno=b.staffno,staffname=b.staffname                
 from #faceresult a,staffinfo b                
 where b.fingerno=@faceid                
             
                
 update a set ontime=ttime,compid=d.compno,compname=d.compname                
 from #faceresult a,(                
  select  row_number() over( PARTITION BY ddate order by min(ISNULL(ttime,0)) asc)  fid,compno,compname,ddate,ttime                
  from  companyinfo b,#staffkqrecordinfo c where b.compno=c.compid and ttime<'140000' group by compno,compname,ddate,ttime) d                
  where a.workdate=d.ddate and d.fid=1                
                 
 update a set downtime=ttime,compid=d.compno,compname=d.compname                
 from #faceresult a,(                
 select  row_number() over( PARTITION BY ddate order by max(ISNULL(ttime,0)) desc)  fid,compno,compname,ddate,ttime                
 from  companyinfo b,#staffkqrecordinfo c where b.compno=c.compid and ttime>'140000'  group by compno,compname,ddate,ttime) d                
 where a.workdate=d.ddate and d.fid=1              
     
 if(ISNULL(@searcjflag,0)=1)  
 begin              
  update a set leavemark=d.parentcodevalue+'['+b.schedulmark+']'+','+b.fromtime+'-'+b.totime ,checkdate=b.checkdate,checkuseid=b.checkuseid      
  from #faceresult a,staffleaveinfo b,staffinfo c,commoninfo d        
  where c.fingerno=@faceid and isnull(c.stafftype,0)=0        
  and c.manageno=b.staffinid and b.leavedate=a.workdate        
  and d.infotype='QJLX' and d.parentcodekey=b.leavetype     
 end  
 else  
 begin  
 update a set leavemark=d.parentcodevalue+'['+b.schedulmark+']'+','+b.fromtime+'-'+b.totime        
  from #faceresult a,staffleaveinfo b,staffinfo c,commoninfo d        
  where c.fingerno=@faceid and isnull(c.stafftype,0)=0        
  and c.manageno=b.staffinid and b.leavedate=a.workdate        
  and d.infotype='QJLX' and d.parentcodekey=b.leavetype   and ISNULL(b.checkflag,0)=1   
 end  
                  
 select workdate,weekdays,compid,compname,staffno,staffname,ontime,downtime,leavemark,checkdate,checkuseid from #faceresult                
 drop table #staffkqrecordinfo                
 drop table #faceresult                
end 
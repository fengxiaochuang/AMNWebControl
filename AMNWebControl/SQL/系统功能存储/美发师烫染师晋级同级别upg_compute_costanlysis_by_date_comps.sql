
if exists(select 1 from sysobjects where type='P' and name='upg_compute_costanlysis_by_date_comps')
	drop procedure upg_compute_costanlysis_by_date_comps
go
CREATE procedure upg_compute_costanlysis_by_date_comps                 
(          
 @compid varchar(10),  ---��˾���        
 @fromdate varchar(10),--��ʼ����        
 @todate varchar(10),  --��������     
 @viewtype int         --�鿴����       
)          
as          
begin          
	create table #empinfobydatez_js          
	(                                    
		seqno int identity not null,                                                            
		inid varchar(20) null,                                                            
		empid varchar(20) null,                                                            
		datefrom varchar(8) null,                                                            
		dateto  varchar(8) null,                                                            
		position varchar(10) null,                                                            
		salary  float null,                                                            
		sharetype varchar(5) null,                                                            
		sharerate float null,                                                            
		deducttax int null                                                            
	)          
	create clustered index idx_empinfobydatez_js on #empinfobydatez_js(empid,datefrom,dateto)                
           
	create table #resulet          
	(          
		empno varchar(20) not null,          
		empname varchar(30) null,          
		inid varchar(20) null,          
		oldxf float   null, --�Ͽ�ϴͷ        
		xfcount float  null,--ϴͷ����        
		mrcount float  null,--������Ŀ����          
		olditem float   null,--�Ͽ���Ŀ          
		itemcount float null,--��Ŀ��          
		oldcount float  null,--�Ͽ�����          
		hlcount float  null,--�������        
		rfcount float   null,--Ⱦ������        
		recount float   null,--����        
		tfcount float   null,--�̷�����        
		gmitem   float  null,--�����Ƴ���        
	)                                
           
	 create table #tbl_temp          
	 (          
	  billno varchar(20) not null,          
	  inid varchar(20) null,          
	  seq float null,          
	  empno varchar(20) not null,          
	  itemid varchar(20) not null,          
	  clenttype float  null,          
	  ccount float  null,          
	 )          
           
	 create table #tbl_dis          
	 (          
	  billno varchar(20) not null,          
	  empno varchar(20) not null,          
	  inid varchar(20) not null,          
	  itemid varchar(20) not null,          
	  clenttype float null,          
	  ccount float null          
	 )          
	           
           
	    
		 if(@viewtype=1)        
		 begin          
		 insert into #resulet(empno,inid)        
		 select staffno,manageno    
		 from staffinfo        
		 where compno=@compid         
		   and position in('004','00401','00402','008','00901','00902','00903','00904')        
		 end          
		 else if(@viewtype=2)        
		 begin        
		 insert into #resulet(empno,inid)        
		 select staffno,manageno        
		 from staffinfo        
		 where compno=@compid         
		   and position in('004','00401','00402')    
		 end        
		 else if(@viewtype=3)        
		 begin        
		 insert into #resulet(empno,inid)        
		 select staffno,manageno  
		 from staffinfo        
		 where compno=@compid    
		   and position in('008','00901','00902','00903','00904')    
		 end        
         
		 insert into #tbl_temp(billno,inid,empno,itemid,clenttype,ccount,seq)          
		 select b.csbillid,csfirstinid,csfirstsaler,csitemno,csfirsttype,csitemcount,csitemamt          
		 from mconsumeinfo a with(nolock),dconsumeinfo b  with(nolock),#resulet          
		 where a.cscompid=b.cscompid          
		   and a.csbillid=b.csbillid          
		   and financedate between @fromdate and @todate          
		   and csfirstinid=inid    
		   and ISNULL(csfirstinid,'')<>''    
		   and ISNULL(a.backcsbillid,'')=''    
		   and ISNULL(a.backcsflag,0)=0    
           
	   insert into #tbl_temp(billno,inid,empno,itemid,clenttype,ccount,seq)          
		 select b.csbillid,cssecondinid,cssecondsaler,csitemno,cssecondtype,csitemcount,csitemamt          
		 from mconsumeinfo a with(nolock),dconsumeinfo b  with(nolock),#resulet          
		 where a.cscompid=b.cscompid          
		   and a.csbillid=b.csbillid          
		   and financedate between @fromdate and @todate          
		   and cssecondinid=inid    
		   and ISNULL(cssecondinid,'')<>''    
		   and ISNULL(a.backcsbillid,'')=''    
		   and ISNULL(a.backcsflag,0)=0         
             
		   insert into #tbl_temp(billno,inid,empno,itemid,clenttype,ccount,seq)          
		 select b.csbillid,csthirdinid,csthirdsaler,csitemno,csthirdtype,csitemcount,csitemamt          
		 from mconsumeinfo a with(nolock),dconsumeinfo b  with(nolock),#resulet          
		 where a.cscompid=b.cscompid          
		   and a.csbillid=b.csbillid          
		   and financedate between @fromdate and @todate          
		   and csthirdinid=inid    
		   and ISNULL(csthirdinid,'')<>''    
		   and ISNULL(a.backcsbillid,'')=''    
		   and ISNULL(a.backcsflag,0)=0           
           
		 create table #table_temp          
		 (          
		 empno varchar(20) not null,          
		 itemid varchar(20) null,    
		 ccount float  null,          
		 )          
		           
		           
		 insert into #tbl_dis(billno,empno,inid,itemid,clenttype,ccount)          
		 select billno,empno,inid,itemid,clenttype,ccount          
		 from #tbl_temp          
		 group by billno,empno,inid,itemid,clenttype,ccount,seq          
           
		 --����ϴ�����ĸ���        
		 insert #table_temp(empno,ccount)        
		 select inid,SUM(ccount)        
		 from #tbl_dis,projectnameinfo        
		 where itemid=prjno    
		   and prjreporttype in('00','01')    
		 group by inid        
           
		 update a set xfcount=ccount        
		 from #resulet a,#table_temp b        
		 where a.inid=b.empno        
		           
		 delete #table_temp          
           
		--�Ͽ�ϴ��        
		insert #table_temp(empno,ccount)        
		 select inid,SUM(ccount)        
		 from #tbl_dis,projectnameinfo        
		 where itemid=prjno         
		   and prjreporttype in('00','01')    
		   and clenttype=1    
		 group by inid    
           
            
		 update a set oldxf=ccount          
		 from #resulet a,#table_temp b          
		 where a.inid=b.empno          
		           
		 delete #table_temp          
           
		 --������Ŀ        
		 insert #table_temp(empno,ccount)          
		 select inid,SUM(ccount)          
		 from #tbl_dis,projectnameinfo          
		 where itemid=prjno            
		   and prjreporttype='4'          
		   and prjpricetype=1  
		 group by inid          
           
           
		 update a set mrcount=ccount          
		 from #resulet a,#table_temp b          
		 where a.inid=b.empno          
		          
		 delete #table_temp          
		           
		 --�Ͽ���Ŀ        
		 insert #table_temp(empno,ccount)          
		 select inid,SUM(ccount)          
		 from #tbl_dis,projectnameinfo          
		 where itemid=prjno    
		   and prjpricetype=1          
		   and clenttype=1          
		 group by inid          
           
           
		 update a set olditem=ccount          
		 from #resulet a,#table_temp b          
		 where a.inid=b.empno          
		          
		 delete #table_temp          
           
		 --�Ͽ�        
		 insert #table_temp(empno,ccount)          
		 select inid,1          
		 from #tbl_dis  
		 where clenttype=1          
		 group by billno,inid          
		           
		 update a set oldcount=ccount        
		 from #resulet a,(select empno,SUM(ccount) ccount from #table_temp group by empno) b        
		 where a.inid=b.empno        
		           
		 delete #table_temp        
           
		 --��Ŀ����        
		 insert #table_temp(empno,ccount)        
		 select inid,SUM(ccount)  
		 from #tbl_dis,projectnameinfo  
		 where itemid=prjno         
		   and prjpricetype=1  
		 group by inid        
		           
           
		 update a set itemcount=ccount          
		 from #resulet a,#table_temp b          
		 where a.inid=b.empno        
		          
		 delete #table_temp        
		         
         
         
		 if(@viewtype=1 or @viewtype=3)        
		 begin        
		 --���㻤��ĸ���        
		  insert #table_temp(empno,ccount)        
		  select inid,SUM(ccount)        
		  from #tbl_dis,projectnameinfo        
		  where itemid=prjno      
			and prjreporttype in('04','05','06','07')         
		  group by inid        
		        
		  update a set hlcount=ccount  
		  from #resulet a,#table_temp b        
		  where a.inid=b.empno  
		          
		  delete #table_temp        
		          
		  --������Ⱦ�ĸ���        
		  insert #table_temp(empno,ccount)  
		  select inid,SUM(ccount)  
		  from #tbl_dis,projectnameinfo  
		  where itemid=prjno  
			and prjreporttype='03'  
		  group by inid  
          
          
		  update a set tfcount=ccount        
		  from #resulet a,#table_temp b        
		  where a.inid=b.empno        
		        
		  delete #table_temp        
          
		  --����Ⱦ���ĸ���        
		  insert #table_temp(empno,ccount)        
		  select inid,SUM(ccount)        
		  from #tbl_dis,projectnameinfo        
		  where itemid=prjno         
			and prjreporttype='02'        
		  group by inid        
          
		  update a set rfcount=ccount        
		  from #resulet a,#table_temp b        
		  where a.inid=b.empno        
		        
		  delete #table_temp        
          
		  --�������̵ĸ���        
		  insert #table_temp(empno,ccount)        
		  select inid,SUM(ccount)        
		  from #tbl_dis,projectnameinfo        
		  where itemid=prjno          
			and prjreporttype='03'    
			and prjname like '%(����)%'        
		  group by inid        
          
		  update a set recount=ccount        
		  from #resulet a,#table_temp b        
		  where a.inid=b.empno        
		        
		  delete #table_temp        
		         
		  delete #tbl_temp        
		  --�����Ƴ�        
		  insert into #tbl_temp(billno,empno,inid,ccount,itemid)        
		  select b.changebillid,b.firstsalerid,b.firstsalerinid,procount,changeproid    
		  from mproexchangeinfo a with(nolock),dproexchangeinfo b with(nolock)   
		  where a.changecompid=@compid     and a.changecompid=b.changecompid and a.changebillid=b.changebillid
			and changedate between @fromdate and @todate    
			and ISNULL(firstsalerinid,'')<>'' 
        
 	     insert into #tbl_temp(billno,empno,inid,ccount,itemid)        
		  select b.changebillid,b.secondsalerid,b.secondsalerinid,procount,changeproid    
		  from mproexchangeinfo a with(nolock),dproexchangeinfo b with(nolock)   
		  where a.changecompid=@compid     and a.changecompid=b.changecompid and a.changebillid=b.changebillid
			and changedate between @fromdate and @todate    
			and ISNULL(secondsalerinid,'')<>''    
			
			insert into #tbl_temp(billno,empno,inid,ccount,itemid)        
		  select b.changebillid,b.thirdsalerid,b.thirdsalerinid,procount,changeproid    
		  from mproexchangeinfo a with(nolock),dproexchangeinfo b with(nolock)   
		  where a.changecompid=@compid     and a.changecompid=b.changecompid and a.changebillid=b.changebillid
			and changedate between @fromdate and @todate
			 and ISNULL(thirdsalerinid,'')<>''    
			 
			 
			insert into #tbl_temp(billno,empno,inid,ccount,itemid)        
		  select b.changebillid,b.fourthsalerid,b.fourthsalerinid,procount,changeproid    
		  from mproexchangeinfo a with(nolock),dproexchangeinfo b with(nolock)   
		  where a.changecompid=@compid     and a.changecompid=b.changecompid and a.changebillid=b.changebillid
			and changedate between @fromdate and @todate
			 and ISNULL(fourthsalerinid,'')<>''    
        
		  insert into #table_temp(empno,itemid,ccount)    
		  select inid,itemid,SUM(ccount)    
		  from #tbl_temp    
		  group by inid,itemid    
      
		 
     
     
		  update a set gmitem=b.ccount    
		  from #resulet a,(select empno,SUM(ccount) ccount from #table_temp group by empno) b    
		  where a.inid=b.empno    
		 end        
           
		 update #resulet set empname=staffname          
		 from #resulet,staffinfo        
		 where inid=manageno        
              
           
		 select * from #resulet         
		 where ISNULL(xfcount,0)+ISNULL(oldxf,0)+ISNULL(mrcount,0)+        
			   ISNULL(olditem,0)+ISNULL(itemcount,0)+ISNULL(oldcount,0)+        
			   ISNULL(hlcount,0)+ISNULL(rfcount,0)+ISNULL(tfcount,0)+        
			   isnull(recount,0)+ISNULL(gmitem,0)>0          
           
		 drop table #empinfobydatez_js          
		 drop table #resulet          
		 drop table #table_temp          
		 drop table #tbl_temp          
		 drop table #tbl_dis          
end 
if exists(select 1 from sysobjects where type='P' and name='upg_prj_goods_consume_analysize')
	drop procedure upg_prj_goods_consume_analysize
go
create procedure upg_prj_goods_consume_analysize              
(              
  @compid			varchar(10),			--��˾���          
  @topnum			int,					--ǰ������      
  @fromdate			varchar(18),			--��ʼ����             
  @todate			varchar(18),			--��������      
  @prjsmallamt      float,					--��Ŀ��ʼ���      
  @prjbigamt        float,					--��Ŀ�������  
  @goodssmallamt    float,					--��Ʒ��ʼ���      
  @goodsbigamt      float					--��Ʒ�������           
                
)              
as -- ��Ŀ����ͳ�Ʒ���          
begin                 
     create table #prj_info (                
        compid			varchar(150)     null,       -- ��˾���
        compname		varchar(150)     null,       -- ��˾���             
        iseqno			int			     null,       -- ��Ŀ��� 
        prjno			varchar(20)      null,       -- ��Ŀ���         
        prjname			varchar(40)      null,       -- ��Ŀ����                  
        prjtype			varchar(30)      null,       -- ���        
        prjcnt          float            null,       -- ����      
        prjamt          float            null,       -- ���            
        goodsno			varchar(20)      null,       -- ��Ŀ���      
        goodsname		varchar(40)      null,       -- ��Ŀ����                  
        goodstype		varchar(30)      null,       -- ���        
        goodscnt        float            null,       -- ����      
        goodsamt        float            null       -- ���
     )      
     
 
     declare @strSql varchar(2000)   
     set @strSql='insert #prj_info(compid,iseqno,prjno,prjcnt,prjamt)   select  top '+str(@topnum)+' curcomp ,row_number() over(order by  SUM(ISNULL(csitemamt,0)) desc), csitemno,SUM(ISNULL(csitemcount,0)),csitemamt=SUM(ISNULL(csitemamt,0)) 
     from mconsumeinfo a with(nolock), dconsumeinfo b with(nolock), compchaininfo
     where curcomp= '+ str(@compid) +' and a.cscompid=relationcomp
       and financedate between '+str(@fromdate)+'  and '+str(@todate)+' 
       and a.cscompid=b.cscompid and a.csbillid=b.csbillid and csinfotype=1
     group by curcomp,csitemno
     having SUM(ISNULL(csitemamt,0))  between '+str(@prjsmallamt)+'  and '+str(@prjbigamt)+' 
     order by  SUM(ISNULL(csitemamt,0)) desc'
     execute(@strSql)   
     set @strSql='update c set goodsno=goodsno_s,goodscnt=goodscnt_s,goodsamt=goodsamt_s
     from  #prj_info c,(  select  top '+str(@topnum)+' compid=curcomp ,iseqno=row_number() over(order by  SUM(ISNULL(csitemamt,0)) desc), goodsno_s=csitemno,goodscnt_s=SUM(ISNULL(csitemcount,0)),goodsamt_s=SUM(ISNULL(csitemamt,0)) 
     from mconsumeinfo a with(nolock), dconsumeinfo b with(nolock), compchaininfo
     where curcomp= '+ str(@compid) +' and a.cscompid=relationcomp
       and financedate between '+str(@fromdate)+'  and '+str(@todate)+' 
       and a.cscompid=b.cscompid and a.csbillid=b.csbillid and csinfotype=2
     group by curcomp,csitemno
     having SUM(ISNULL(csitemamt,0))  between '+str(@goodssmallamt)+'  and '+str(@goodsbigamt)+' 
     ) as d where c.compid=d.compid and c.iseqno=d.iseqno '
 
	 execute(@strSql)   
       
        
     update a set prjname=b.prjname,prjtype=prjreporttype
     from #prj_info a,projectnameinfo b where a.prjno=b.prjno
     
     update a set goodsname=b.goodsname,goodstype=goodspricetype
     from #prj_info a,goodsnameinfo b where a.goodsno=b.goodsno
    
	 update a set compname=b.compname
	 from #prj_info a,companyinfo b where b.compno=a.compid 
	 
	 select compid,iseqno,compname,prjno,prjname,prjtype,prjcnt,prjamt,goodsno,goodsname,goodstype,goodscnt,goodsamt 
	 from #prj_info order by iseqno asc
     drop table #prj_info      
       
end  
go
--exec upg_prj_goods_consume_analysize '001',10,'20130801','20130831',0,100000,0,10000
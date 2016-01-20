if exists(select 1 from sysobjects where type='P' and name='upg_analysis_system_shop')
	drop procedure upg_analysis_system_shop
go
CREATE procedure upg_analysis_system_shop                        
(                        
 @compid varchar(10),                        
 @fromdate varchar(8),                        
 @todate varchar(8)                        
)  
as  
begin  
 create table #analysisresult  
 (  
  
  compno			varchar(10) null, --�ŵ��
  resusttyep		int   null,
  showtype			int   null,		--1 �ŵ����  2 �������� 3 ���ݷ���
  resusttyeptext  varchar(60) null, 
  month1r		float  null, --1��  
  month2r		float  null, --2��  
  month3r		float  null, --3��  
  month4r		float  null, --4��  
  month5r		float  null, --5��  
  month6r		float  null, --6��  
  month7r		float  null, --7��  
  month8r		float  null, --8��  
  month9r		float  null, --9��  
  month10r		float  null, --10��  
  month11r		float  null, --11��  
  month12r		float  null, --12��  
  months_12r    float  null, --�ܺϼ�  
  monthf_5r		float  null, --ǰ5��ƽ��  
  montha_12r    float  null, --��ƽ��  
  montha_5r		float  null, --��5��ƽ��  
 )  
 declare @searyear varchar(4)
 set @searyear=SUBSTRING(@fromdate,1,4)
 declare @sqltitle varchar(600)  
 set @sqltitle = '['+@searyear+''+'01],['+@searyear+''+'02],['+@searyear+''+'03],['+@searyear+''+'04],['+@searyear+''+'05],['+@searyear+''+'06],['+@searyear+''+'07],['+@searyear+''+'08],['+@searyear+''+'09],['+@searyear+''+'10],['+@searyear+''+'11],['+@searyear+''+'12]'  

 declare @targetsql varchar(800)  
 --1��ҵ��       
  set @targetsql='select ddate=SUBSTRING(ddate,1,6),totalyeji=convert(numeric(20,1),SUM(ISNULL(totalyeji,0)))  
  from compclasstraderesult where compid='+@compid+' and  ddate between '+@fromdate+' and '+@todate+'  
  group by SUBSTRING(ddate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select 1,''��ҵ��'',1,* from ('+@targetsql+') a pivot (max(totalyeji) for ddate in (' + @sqltitle + ')) b  ')  


  --2 ������ҵ��  
  set @targetsql='select ddate=SUBSTRING(ddate,1,6),hairyeji=convert(numeric(20,1),SUM(ISNULL(hairyeji,0)))  
  from compclasstraderesult where compid='+@compid+' and  ddate between '+@fromdate+' and '+@todate+'     
  group by SUBSTRING(ddate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  2,''������ҵ��'',1,* from ('+@targetsql+') a pivot (max(hairyeji) for ddate in (' + @sqltitle + ')) b  ')  
  
  --3 ������ҵ��  
  set @targetsql='select ddate=SUBSTRING(ddate,1,6),beautyeji=convert(numeric(20,1),SUM(ISNULL(beautyeji,0)))  
  from compclasstraderesult where compid='+@compid+' and  ddate between '+@fromdate+' and '+@todate+'        
  group by SUBSTRING(ddate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  3,''������ҵ��'',1,* from ('+@targetsql+') a pivot (max(beautyeji) for ddate in (' + @sqltitle + ')) b  ')  
   
   
     -- 4 ����Ӫҵ��ռ��  
   set @targetsql='select ddate=SUBSTRING(ddate,1,6),realbeautyeji=convert(numeric(20,4),SUM(ISNULL(beautyeji,4))/SUM(ISNULL(totalyeji,0)))  
  from compclasstraderesult where compid='+@compid+'  and isnull(realtotalyeji,0)>0   and  ddate between '+@fromdate+' and '+@todate+'    
  group by SUBSTRING(ddate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  4,''����Ӫҵ��ռ��'',1,* from ('+@targetsql+') a pivot (max(realbeautyeji) for ddate in (' + @sqltitle + ')) b  ')  
    

      --5 ��ʵҵ��  
  set @targetsql='select ddate=SUBSTRING(ddate,1,6),realtotalyeji=convert(numeric(20,1),SUM(ISNULL(realtotalyeji,0)))  
  from compclasstraderesult where compid='+@compid+'  and  ddate between '+@fromdate+' and '+@todate+'       
  group by SUBSTRING(ddate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  5,''��ʵҵ��'',1,* from ('+@targetsql+') a pivot (max(realtotalyeji) for ddate in (' + @sqltitle + ')) b  ')  
   
    --6 �Ŀ���(��ֵ����/���춯)  
  set @targetsql='select ddate=SUBSTRING(dateReport,1,6),realrate=convert(numeric(20,4),SUM(ISNULL(cardsalesservices,1))/ISNULL(sum(ISNULL(totalcardtrans,0)),0))  
  from detial_trade_byday_fromshops where shopId='+@compid+' and ISNULL(totalcardtrans,0)>0   and  dateReport between '+@fromdate+' and '+@todate+'
  group by SUBSTRING(dateReport,1,6)'  
   insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  6,''�Ŀ���(��ֵ����/���춯)'',1,* from ('+@targetsql+') a pivot (max(realrate) for ddate in (' + @sqltitle + ')) b  ')  
   
   
   
   
     --7 ���ݲ�����ռ��  
  set @targetsql='select ddate=SUBSTRING(ddate,1,6),realbeautyeji=convert(numeric(20,4),SUM(ISNULL(realbeautyeji,4))/SUM(ISNULL(realtotalyeji,0)))  
  from compclasstraderesult where compid='+@compid+'  and isnull(realtotalyeji,0)>0   and  ddate between '+@fromdate+' and '+@todate+'    
  group by SUBSTRING(ddate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  7,''���ݲ�����ռ��'',1,* from ('+@targetsql+') a pivot (max(realbeautyeji) for ddate in (' + @sqltitle + ')) b  ')  
    


   
   
  --9����ʵҵ��  
   set @targetsql='select ddate=SUBSTRING(ddate,1,6),realhairyeji=convert(numeric(20,1),SUM(ISNULL(realhairyeji,0)))  
  from compclasstraderesult where compid='+@compid+'  and  ddate between '+@fromdate+' and '+@todate+'      
  group by SUBSTRING(ddate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  9,''����ʵҵ��[����������Ʒ]'',2,* from ('+@targetsql+') a pivot (max(realhairyeji) for ddate in (' + @sqltitle + ')) b  ')  
   
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
   
        -- 8 �ܿ͵���  
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billcount=count(distinct b.csbillid)   
   from #m_dconsumeinfo b where b.cscompid='+@compid+'  
   group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  8,''�ܿ͵���'',1,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
   
   
     --10 ϴ��������   
  set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemamt=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''01'')  
  and b.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  10,''ϴ��������'',2,* from ('+@targetsql+') a pivot (max(csitemamt) for ddate in (' + @sqltitle + ')) b  ')  
   
   
  --11 �̷�����   
  set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemamt=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''03'')  
  and b.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  11,''�̷�����'',2,* from ('+@targetsql+') a pivot (max(csitemamt) for ddate in (' + @sqltitle + ')) b  ')  
   
     --12 Ⱦ������   
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemamt=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''02'')  
  and b.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  12,''Ⱦ������'',2,* from ('+@targetsql+') a pivot (max(csitemamt) for ddate in (' + @sqltitle + ')) b  ')  
   
  --13 ��������   
  set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemamt=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''04'',''05'',''07'',''14'')  
  and b.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  13,''��������'',2,* from ('+@targetsql+') a pivot (max(csitemamt) for ddate in (' + @sqltitle + ')) b  ')  
   
  --14 ͷƤ����  
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemamt=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where  b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''06'')  
  and b.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  14,''ͷƤ����'',2,* from ('+@targetsql+') a pivot (max(csitemamt) for ddate in (' + @sqltitle + ')) b  ')  
    
   --15 ϴ������Ŀ��ռ��
     set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''01'') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
   and isnull(c.prjreporttype,'''') in (''01'',''03'',''02'',''04'',''05'',''07'',''14'',''06'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(b.financedate,1,6)' 
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  15,''ϴ������Ŀ��ռ��'',2,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
   --16 �̷�����ռ��
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''03'') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where  b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
   and isnull(c.prjreporttype,'''') in (''01'',''03'',''02'',''04'',''05'',''07'',''14'',''06'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  16,''�̷�����ռ��'',2,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
  
    --17 Ⱦ������ռ��
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''02'') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
   and isnull(c.prjreporttype,'''') in (''01'',''03'',''02'',''04'',''05'',''07'',''14'',''06'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  17,''Ⱦ������ռ��'',2,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
    --18 ��������ռ��
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''04'',''05'',''07'',''14'') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
   and isnull(c.prjreporttype,'''') in (''01'',''03'',''02'',''04'',''05'',''07'',''14'',''06'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  18,''��������ռ��'',2,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
    --19ͷƤ����ռ��
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''06'') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
   from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
   and isnull(c.prjreporttype,'''') in (''01'',''03'',''02'',''04'',''05'',''07'',''14'',''06'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  19,''ͷƤ����ռ��'',2,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
  
  
    -- 20��������Ŀ��  
  set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemcount=convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
  and isnull(c.prjreporttype,'''') in (''01'',''03'',''02'',''04'',''05'',''07'',''14'',''06'')  
  and b.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  20,''��������Ŀ��[����ϴ����]'',2,* from ('+@targetsql+') a pivot (max(csitemcount) for ddate in (' + @sqltitle + ')) b  ')  
   
  -- 21 ϴ������Ŀ��   
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemcount=convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''01'')  
  and b.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  21,''ϴ������Ŀ��'',2,* from ('+@targetsql+') a pivot (max(csitemcount) for ddate in (' + @sqltitle + ')) b  ')  
   
  --22 �̷���Ŀ��   
  set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemcount=convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''03'')  
  and b.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  22,''�̷���Ŀ��'',2,* from ('+@targetsql+') a pivot (max(csitemcount) for ddate in (' + @sqltitle + ')) b  ')  
   
   
  --23 Ⱦ����Ŀ��   
    set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemcount=convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''02'')  
  and b.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  23,''Ⱦ����Ŀ��'',2,* from ('+@targetsql+') a pivot (max(csitemcount) for ddate in (' + @sqltitle + ')) b  ')  
   
  --24 ������Ŀ��   
  set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemcount=convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''04'',''05'',''07'',''14'')  
  and b.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  24,''������Ŀ��'',2,* from ('+@targetsql+') a pivot (max(csitemcount) for ddate in (' + @sqltitle + ')) b  ')  
   
  --25 ͷƤ��Ŀ��  
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemcount=convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''06'')  
  and b.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  25,''ͷƤ��Ŀ��'',2,* from ('+@targetsql+') a pivot (max(csitemcount) for ddate in (' + @sqltitle + ')) b  ')  
         
  
     
  -- 26 ϴ������Ŀ��ռ��
      set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''01'') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
   and isnull(c.prjreporttype,'''') in (''01'',''03'',''02'',''04'',''05'',''07'',''14'',''06'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  26,''ϴ������Ŀ��ռ��'',2,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
    -- 27 �̷���Ŀ��ռ�� 
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''03'') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
   and isnull(c.prjreporttype,'''') in (''01'',''03'',''02'',''04'',''05'',''07'',''14'',''06'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  27,''�̷���Ŀ��ռ��'',2,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
    --28 Ⱦ����Ŀ��ռ�� 
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''02'') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
   and isnull(c.prjreporttype,'''') in (''01'',''03'',''02'',''04'',''05'',''07'',''14'',''06'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  28,''Ⱦ����Ŀ��ռ��'',2,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
    --29 ������Ŀ��ռ�� 
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''04'',''05'',''07'',''14'') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
   and isnull(c.prjreporttype,'''') in (''01'',''03'',''02'',''04'',''05'',''07'',''14'',''06'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  29,''������Ŀ��ռ��'',2,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
    --30 ͷƤ��Ŀ��ռ��  
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''06'') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
   and isnull(c.prjreporttype,'''') in (''01'',''03'',''02'',''04'',''05'',''07'',''14'',''06'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  30,''ͷƤ��Ŀ��ռ��'',2,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
       
  -- 31�����ܾ���   
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemaprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
   and isnull(c.prjreporttype,'''') in (''01'',''03'',''02'',''04'',''05'',''07'',''14'',''06'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  31,''�����ܾ���'',2,* from ('+@targetsql+') a pivot (max(csitemaprice) for ddate in (' + @sqltitle + ')) b  ')  
   
  --32 ϴ��������   
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemaprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno  and isnull(c.prjreporttype,'''') in (''01'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  32,''ϴ��������'',2,* from ('+@targetsql+') a pivot (max(csitemaprice) for ddate in (' + @sqltitle + ')) b  ')  
   
    
  --33 �̷�����   
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemaprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno  and isnull(c.prjreporttype,'''') in (''03'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  33,''�̷�����'',2,* from ('+@targetsql+') a pivot (max(csitemaprice) for ddate in (' + @sqltitle + ')) b  ')  
   
  --34Ⱦ������   
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemaprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''02'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  34,''Ⱦ������'',2,* from ('+@targetsql+') a pivot (max(csitemaprice) for ddate in (' + @sqltitle + ')) b  ')  
   
  --35�������   
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemaprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''04'',''05'',''07'',''14'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  35,''�������'',2,* from ('+@targetsql+') a pivot (max(csitemaprice) for ddate in (' + @sqltitle + ')) b  ')  
   
  --36ͷƤ����  
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemaprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''06'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  36,''ͷƤ����'',2,* from ('+@targetsql+') a pivot (max(csitemaprice) for ddate in (' + @sqltitle + ')) b  ')  
   
   
   
 -- 37�����ܿ͵���[����ϴ����]   
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billcount=count(distinct b.csbillid)   
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
   and isnull(c.prjreporttype,'''') in (''01'',''03'',''02'',''04'',''05'',''07'',''14'',''06'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  37,''�����ܿ͵���[����ϴ����]'',2,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
   
   
 --38�����ܿ͵���   
  set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/count(distinct b.csbillid))   
   from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
   and isnull(c.prjreporttype,'''') in (''01'',''03'',''02'',''04'',''05'',''07'',''14'',''06'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  38,''�����ܿ͵���'',2,* from ('+@targetsql+') a pivot (max(billprice) for ddate in (' + @sqltitle + ')) b  ')  
   
   
 --39 �����Ƴ̿͵���  
  set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billcount=count(distinct b.csbillid)   
   from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0 and isnull(cspaymode,'''')=''9''  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  39,''�����Ƴ̿͵���'',2,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
 --40 �����Ƴ̿͵���   
  set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/count(distinct b.csbillid))   
   from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0 and isnull(cspaymode,'''')=''9''  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  40,''�����Ƴ̿͵���'',2,* from ('+@targetsql+') a pivot (max(billprice) for ddate in (' + @sqltitle + ')) b  ') 
          
   --41�����Ƴ̿͵���ռ��   
  set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billcount=convert(numeric(20,4),(count(distinct case when  isnull(cspaymode,'''')=''9'' then b.csbillid else '''' end )-1)*1.0/count(distinct b.csbillid))  
   from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  41,''�����Ƴ̿͵���ռ��'',2,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
  
  
    --42����ʵҵ��[�������ݲ�Ʒ.��ϴˮϴ]  
    set @targetsql='select ddate=SUBSTRING(ddate,1,6),realbeautyeji=convert(numeric(20,1),SUM(ISNULL(realbeautyeji,0)))  
  from compclasstraderesult where compid='+@compid+' and  ddate between '+@fromdate+' and '+@todate+'       
  group by SUBSTRING(ddate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  42,''����ʵҵ��[�������ݲ�Ʒ.��ϴˮϴ]'',3,* from ('+@targetsql+') a pivot (max(realbeautyeji) for ddate in (' + @sqltitle + ')) b  ')  
   
  -- 43������SPA������   
  set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemamt=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0 
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  43,''������SPA������'',3,* from ('+@targetsql+') a pivot (max(csitemamt) for ddate in (' + @sqltitle + ')) b  ')  
   
  -- 44�沿������   
  set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemamt=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''10'',''17'')  
  and b.cscompid='+@compid+' and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0 
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  44,''�沿������'',3,* from ('+@targetsql+') a pivot (max(csitemamt) for ddate in (' + @sqltitle + ')) b  ')  
   
  --45�ز�������   
  set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemamt=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''18'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0 
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  45,''�ز�������'',3,* from ('+@targetsql+') a pivot (max(csitemamt) for ddate in (' + @sqltitle + ')) b  ')  
   
  --46 ����������   
  set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemamt=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''09'',''11'',''13'',''22'',''23'')  
  and b.cscompid='+@compid+' and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0 
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  46,''����������'',3,* from ('+@targetsql+') a pivot (max(csitemamt) for ddate in (' + @sqltitle + ')) b  ')  
   
  --47 ���Ƴ�����  
 set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemamt=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
 from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''15'')  
  and b.cscompid='+@compid+' and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0 
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  47,''���Ƴ�����'',3,* from ('+@targetsql+') a pivot (max(csitemamt) for ddate in (' + @sqltitle + ')) b  ')  
   
    
    
  -- 48������SPA������ռ�� 
    set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
   and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'',''10'',''17'',''18'',''09'',''11'',''13'',''22'',''23'',''15'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  48,''������SPA������ռ��'',3,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
    --49�沿������ռ�� 
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''10'',''17'') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
   and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'',''10'',''17'',''18'',''09'',''11'',''13'',''22'',''23'',''15'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  49,''�沿������ռ��'',3,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
    --50�ز�������ռ�� 
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''18'') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
 from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
  and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'',''10'',''17'',''18'',''09'',''11'',''13'',''22'',''23'',''15'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  50,''�ز�������ռ��'',3,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
    --51����������ռ��
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''09'',''11'',''13'',''22'',''23'') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
  and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'',''10'',''17'',''18'',''09'',''11'',''13'',''22'',''23'',''15'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  51,''����������ռ��'',3,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
    -- 52 ���Ƴ�����ռ��  
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''15'') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
   and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'',''10'',''17'',''18'',''09'',''11'',''13'',''22'',''23'',''15'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  52,''���Ƴ�����ռ��'',3,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
   
     -- 53��������Ŀ��[��������ϴˮϴ]   
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemcount=convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
   from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')   
  and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'',''10'',''17'',''18'',''09'',''11'',''13'',''22'',''23'',''15'')  
  and b.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  53,''��������Ŀ��[��������ϴˮϴ]'',3,* from ('+@targetsql+') a pivot (max(csitemcount) for ddate in (' + @sqltitle + ')) b  ')  
   
   
  --54������Ŀ��   
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemcount=convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
   from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'')  
  and b.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  54,''������Ŀ��'',3,* from ('+@targetsql+') a pivot (max(csitemcount) for ddate in (' + @sqltitle + ')) b  ')  
   
  --55�沿��Ŀ��   
    set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemcount=convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in  (''10'',''17'')  
  and b.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  55,''�沿��Ŀ��'',3,* from ('+@targetsql+') a pivot (max(csitemcount) for ddate in (' + @sqltitle + ')) b  ')  
   
  --56�ز���Ŀ��   
    set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemcount=convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
   from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''18'')  
  and b.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  56,''�ز���Ŀ��'',3,* from ('+@targetsql+') a pivot (max(csitemcount) for ddate in (' + @sqltitle + ')) b  ')  
   
  --57��������Ŀ��   
    set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemcount=convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
   from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''09'',''11'',''13'',''22'',''23'')  
  and b.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  57,''��������Ŀ��'',3,* from ('+@targetsql+') a pivot (max(csitemcount) for ddate in (' + @sqltitle + ')) b  ')  
   
  --58 ����Ŀ��Ŀ��  
  set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemcount=convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
   from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjreporttype,'''')  in (''15'')  
  and b.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  58,''����Ŀ��Ŀ��'',3,* from ('+@targetsql+') a pivot (max(csitemcount) for ddate in (' + @sqltitle + ')) b  ')  
        
   
       
  -- 59������Ŀ��ռ�� 
  set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0)))  
   from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
   and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'',''10'',''17'',''18'',''09'',''11'',''13'',''22'',''23'',''15'')  
 and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  59,''������Ŀ��ռ��'',3,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
   
   --60�沿��Ŀ��ռ��
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''10'',''17'') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0)))  
   from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
   and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'',''10'',''17'',''18'',''09'',''11'',''13'',''22'',''23'',''15'')  
 and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  60,''�沿��Ŀ��ռ��'',3,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
    -- 61�ز���Ŀ��ռ��
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''18'') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0)))  
   from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
   and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'',''10'',''17'',''18'',''09'',''11'',''13'',''22'',''23'',''15'')  
 and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  61,''�ز���Ŀ��ռ��'',3,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
    -- 62��������Ŀ��ռ�� 
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''09'',''11'',''13'',''22'',''23'') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0))) 
	from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
  and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'',''10'',''17'',''18'',''09'',''11'',''13'',''22'',''23'',''15'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  62,''��������Ŀ��ռ��'',3,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
    --63 ����Ŀ��Ŀ��ռ��   
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''15'') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0)))  
   from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
   and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'',''10'',''17'',''18'',''09'',''11'',''13'',''22'',''23'',''15'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  63,''����Ŀ��Ŀ��ռ��'',3,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
          
        
 -- 64���ݾ���   
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemaprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
  and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'',''10'',''17'',''18'',''09'',''11'',''13'',''22'',''23'',''15'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  64,''���ݾ���'',3,* from ('+@targetsql+') a pivot (max(csitemaprice) for ddate in (' + @sqltitle + ')) b  ')  
   
 --65���������   
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemaprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno  and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  65,''���������'',3,* from ('+@targetsql+') a pivot (max(csitemaprice) for ddate in (' + @sqltitle + ')) b  ')  
   
 --66�沿�����   
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemaprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno  and isnull(c.prjreporttype,'''') in (''10'',''17'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  66,''�沿�����'',3,* from ('+@targetsql+') a pivot (max(csitemaprice) for ddate in (' + @sqltitle + ')) b  ')  
   
 --67�ز������   
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemaprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno  and isnull(c.prjreporttype,'''') in (''18'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  67,''�ز������'',3,* from ('+@targetsql+') a pivot (max(csitemaprice) for ddate in (' + @sqltitle + ')) b  ')  
   
 --68���������   
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemaprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno  and isnull(c.prjreporttype,'''') in (''09'',''11'',''13'',''22'',''23'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  68,''���������'',3,* from ('+@targetsql+') a pivot (max(csitemaprice) for ddate in (' + @sqltitle + ')) b  ')  
   
 --69����Ŀ����  
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),csitemaprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno  and isnull(c.prjreporttype,'''') in (''15'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  69,''����Ŀ����'',3,* from ('+@targetsql+') a pivot (max(csitemaprice) for ddate in (' + @sqltitle + ')) b  ')  
                
 -- 70���ݲ��͵���[��������ϴˮϴ]   
   set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billcount=count(distinct b.csbillid)   
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
  and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'',''10'',''17'',''18'',''09'',''11'',''13'',''22'',''23'',''15'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  70,''���ݲ��͵���[��������ϴˮϴ]'',3,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
   
 -- 71���ݲ��͵���   
 set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/count(distinct b.csbillid))   
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
  and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'',''10'',''17'',''18'',''09'',''11'',''13'',''22'',''23'',''15'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  71,''���ݲ��͵���'',3,* from ('+@targetsql+') a pivot (max(billprice) for ddate in (' + @sqltitle + ')) b  ')  
   
 -- 72 �����Ƴ̿͵���   
  set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billcount=count(distinct b.csbillid)   
 from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0 and isnull(cspaymode,'''')=''9''  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  72,''�����Ƴ̿͵���'',3,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
 -- 73 �����Ƴ̿͵���   
  set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/count(distinct b.csbillid))   
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0 and isnull(cspaymode,'''')=''9''  
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  73,''�����Ƴ̿͵���'',3,* from ('+@targetsql+') a pivot (max(billprice) for ddate in (' + @sqltitle + ')) b  ')  
       
 
 -- 74 �����Ƴ̿͵�ռ��   
 set @targetsql='select ddate=SUBSTRING(b.financedate,1,6),billcount=convert(numeric(20,4),(count(distinct case when  isnull(cspaymode,'''')=''9'' then b.csbillid else '''' end )-1)*1.0/count(distinct b.csbillid))  
  from #m_dconsumeinfo b,projectnameinfo c  
  where b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
  and b.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(b.financedate,1,6)'  
  insert #analysisresult(resusttyep,resusttyeptext,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  74,''�����Ƴ̿͵�ռ��'',3,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
        
	update #analysisresult set compno=@compid,months_12r=convert(numeric(20,4),ISNULL(month1r,0)+ISNULL(month2r,0)+ISNULL(month3r,0)+ISNULL(month4r,0)+ISNULL(month5r,0)+ISNULL(month6r,0)  
           +ISNULL(month7r,0)+ISNULL(month8r,0)+ISNULL(month9r,0)+ISNULL(month10r,0)+ISNULL(month11r,0)+ISNULL(month12r,0))  
             
 
	 --1��ҵ�� 2 ������ҵ�� 3 ������ҵ�� 4 ������ҵ�� 5 ��ʵҵ�� 8����ʵҵ��  32����ʵҵ��  
	 update #analysisresult set montha_12r=convert(numeric(20,1),ISNULL(months_12r,0)/(  
	  (case when ISNULL(month1r,0)>0 then 1 else 0 end )  
	 +(case when ISNULL(month2r,0)>0 then 1 else 0 end )  
	 +(case when ISNULL(month3r,0)>0 then 1 else 0 end )  
	 +(case when ISNULL(month4r,0)>0 then 1 else 0 end )  
	 +(case when ISNULL(month5r,0)>0 then 1 else 0 end )  
	 +(case when ISNULL(month6r,0)>0 then 1 else 0 end )  
	 +(case when ISNULL(month7r,0)>0 then 1 else 0 end )  
	 +(case when ISNULL(month8r,0)>0 then 1 else 0 end )  
	 +(case when ISNULL(month9r,0)>0 then 1 else 0 end )  
	 +(case when ISNULL(month10r,0)>0 then 1 else 0 end )  
	 +(case when ISNULL(month11r,0)>0 then 1 else 0 end )  
	 +(case when ISNULL(month12r,0)>0 then 1 else 0 end )))  
	 where ISNULL(months_12r,0)>0  
 

    
  --monthf_5r    float  null, --ǰ5��ƽ��  
    update A set A.monthf_5r=convert(numeric(20,4),D.montha_5r)
	from #analysisresult A ,(select resusttyep,montha_5r=sum(isnull(resultamt,0))/5  from 
	   (select resusttyep,compno,resultamt ,row_number() over( PARTITION BY resusttyep order by SUM(ISNULL(resultamt,0)) desc) fid
	      from   ( select resusttyep,compno,resultamt=convert(numeric(20,1),sum(ISNULL(resultamt,0))/sum((case when ISNULL(resultamt,0)>0 then 1 else 0 end ))) 
				from jsanalysisresult  where compno not in ('040','037','004','010') and ISNULL(resultamt,0)<>0 and mmonth between substring(@fromdate,1,6) and substring(@todate,1,6)
				group by resusttyep,compno) B  where ISNULL(resultamt,0)<>0
	    group by resusttyep,compno,resultamt) C
	     where fid<=5  group by resusttyep ) D
	where A.resusttyep=D.resusttyep
  
	--montha_5r    float  null, --��5��ƽ��  
    update A set A.montha_5r=convert(numeric(20,4),D.montha_5r)
	from #analysisresult A ,(select resusttyep,montha_5r=sum(isnull(resultamt,0))/5  from 
	   (select resusttyep,compno,resultamt ,row_number() over( PARTITION BY resusttyep order by SUM(ISNULL(resultamt,0)) asc) fid
	      from   ( select resusttyep,compno,resultamt=convert(numeric(20,1),sum(ISNULL(resultamt,0))/sum((case when ISNULL(resultamt,0)>0 then 1 else 0 end ))) 
				from jsanalysisresult  where compno not in ('040','037','004','010') and ISNULL(resultamt,0)<>0 and mmonth between substring(@fromdate,1,6) and substring(@todate,1,6)
				group by resusttyep,compno) B  where ISNULL(resultamt,0)<>0
	    group by resusttyep,compno,resultamt) C
	     where fid<=5  group by resusttyep ) D
	where A.resusttyep=D.resusttyep
    
	select a.compno,compname,resusttyeptext,resusttyep,showtype,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r,months_12r,monthf_5r,montha_12r,montha_5r  
	  from #analysisresult a,companyinfo b  where a.compno=b.compno order by resusttyep 
  
	drop table #m_dconsumeinfo
	drop table #analysisresult  
end  
go









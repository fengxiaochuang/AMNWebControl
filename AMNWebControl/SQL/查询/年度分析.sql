if exists(select 1 from sysobjects where type='P' and name='upg_analysis_system_2013')
	drop procedure upg_analysis_system_2013
go
CREATE procedure upg_analysis_system_2013                        
(                        
 @compid varchar(10),                        
 @fromdate varchar(8),                        
 @todate varchar(8)                        
)  
as  
begin  
 create table #analysisresult  
 (  
  
  compno     varchar(10) null, --�ŵ��  
  resusttyep    int   null, --ҵ������ 1��ҵ�� 2 ������ҵ�� 3 ������ҵ�� 4 ������ҵ�� 5 ��ʵҵ�� 6 �Ŀ��� 7 ���ݲ�����ռ��  
               -- 8����ʵҵ��  10 ϴ�������� 11 �̷����� 12 Ⱦ������ 13 �������� 14 ͷƤ����  
               -- 15��������Ŀ�� 16ϴ������Ŀ�� 17 �̷���Ŀ�� 18Ⱦ����Ŀ�� 19 ������Ŀ�� 20 ͷƤ��Ŀ��  
               -- 21�����ܾ��� 22 ϴ�������� 23 �̷����� 24Ⱦ������ 25������� 26ͷƤ����  
               -- 27�����ܿ͵��� 28�����ܿ͵��� 29 �����Ƴ̿͵��� 30 �����Ƴ̿͵��� 31�����Ƴ̿͵���ռ��  
               -- 32����ʵҵ��  33������SPA������ 34�沿������ 35�ز������� 36 ���������� 37 ���Ƴ�����  
               -- 38��������Ŀ�� 39������Ŀ�� 40�沿��Ŀ�� 41�ز���Ŀ�� 42��������Ŀ�� 43 ����Ŀ��Ŀ��  
               -- 44���ݾ��� 45��������� 46�沿����� 47�ز������ 48��������� 49����Ŀ����  
               -- 50���ݲ��͵��� 51���ݲ��͵��� 52 �����Ƴ̿͵��� 53 �����Ƴ̿͵��� 54 �����Ƴ̿͵�ռ��  
               -- 55 ����ʧ���� 56������������ 57��Ⱦ����ʧ���� 58 ���ݲ���ʧ���� 59 ���ýӴ�������ʧ���� 60 ������ʧ����  
               -- 61 3����������ʧ���� 62 3������������������ 63 3��������Ⱦ����ʧ���� 64 3���������ݲ���ʧ���� 65 3�����ڴ��ýӴ�������ʧ���� 66 3�����ں�����ʧ����  
               -- 67 6����������ʧ���� 68 6������������������ 69 6��������Ⱦ����ʧ���� 70 6���������ݲ���ʧ���� 71 6�����ڴ��ýӴ�������ʧ���� 62 6�����ں�����ʧ����  
               -- 73 12����������ʧ���� 74 12������������������ 75 12��������Ⱦ����ʧ���� 76 12���������ݲ���ʧ���� 77 12�����ڴ��ýӴ�������ʧ���� 78 12�����ں�����ʧ����  
               -- 79 3-6���µ���3000 ��Ա�� 80 ������3-6���µ���3000 ��Ա�� 81 ��Ⱦ��3-6���µ���3000 ��Ա�� 82 ���ݲ�3-6���µ���3000 ��Ա��  
               -- 83 6-12���µ���5000 ��Ա�� 84 ������6-12���µ���5000 ��Ա�� 85 ��Ⱦ��6-12���µ���5000 ��Ա�� 86 ���ݲ�6-12���µ���5000 ��Ա��  
               -- 87 12�����ϵ���7000 ��Ա�� 88 ������12�����ϵ���7000 ��Ա�� 89 ��Ⱦ��12�����ϵ���7000 ��Ա�� 89 ���ݲ�12�����ϵ���7000 ��Ա��  
               -- 90 ϴ��������ռ�� 91 �̷�����ռ�� 92 Ⱦ������ռ�� 93 ��������ռ�� 94 ͷƤ����ռ��  
               -- 95ϴ������Ŀ��ռ�� 96 �̷���Ŀ��ռ�� 97Ⱦ����Ŀ��ռ�� 98 ������Ŀ��ռ�� 99 ͷƤ��Ŀ��ռ��  
               -- 100������SPA������ 101�沿������ 102�ز������� 103���������� 104 ���Ƴ�����  
               -- 105������Ŀ�� 106�沿��Ŀ�� 107�ز���Ŀ�� 108��������Ŀ�� 109 ����Ŀ��Ŀ��  
               -- 110 ����Ӫҵ��ռ��    -- 112 �ŵ��ܿ͵�  
  month1r     float  null, --1��  
  month2r     float  null, --2��  
  month3r     float  null, --3��  
  month4r     float  null, --4��  
  month5r     float  null, --5��  
  month6r     float  null, --6��  
  month7r     float  null, --7��  
  month8r     float  null, --8��  
  month9r     float  null, --9��  
  month10r    float  null, --10��  
  month11r    float  null, --11��  
  month12r    float  null, --12��  
  months_12r    float  null, --�ܺϼ�  
  monthf_5r    float  null, --ǰ5��ƽ��  
  montha_12r    float  null, --��ƽ��  
  montha_5r    float  null, --��5��ƽ��  
 )  
 declare @sqltitle varchar(600)  
 set @sqltitle = '[201301],[201302],[201303],[201304],[201305],[201306],[201307],[201308],[201309],[201310],[201311],[201312]'  
   
 declare @targetsql varchar(800)  
 --1��ҵ��       
  set @targetsql='select ddate=SUBSTRING(ddate,1,6),totalyeji=convert(numeric(20,1),SUM(ISNULL(totalyeji,0)))  
  from compclasstraderesult where compid='+@compid+'   
  group by SUBSTRING(ddate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  1,* from ('+@targetsql+') a pivot (max(totalyeji) for ddate in (' + @sqltitle + ')) b  ')  
      
  --2 ������ҵ��  
  set @targetsql='select ddate=SUBSTRING(ddate,1,6),hairyeji=convert(numeric(20,1),SUM(ISNULL(hairyeji,0)))  
  from compclasstraderesult where compid='+@compid+'   
  group by SUBSTRING(ddate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  2,* from ('+@targetsql+') a pivot (max(hairyeji) for ddate in (' + @sqltitle + ')) b  ')  
   
  --3 ������ҵ��  
  set @targetsql='select ddate=SUBSTRING(ddate,1,6),beautyeji=convert(numeric(20,1),SUM(ISNULL(beautyeji,0)))  
  from compclasstraderesult where compid='+@compid+'   
  group by SUBSTRING(ddate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  3,* from ('+@targetsql+') a pivot (max(beautyeji) for ddate in (' + @sqltitle + ')) b  ')  
   
  --4 ������ҵ��  
  set @targetsql='select ddate=SUBSTRING(ddate,1,6),fingeryeji=convert(numeric(20,1),SUM(ISNULL(fingeryeji,0)))  
  from compclasstraderesult where compid='+@compid+'   
  group by SUBSTRING(ddate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  4,* from ('+@targetsql+') a pivot (max(fingeryeji) for ddate in (' + @sqltitle + ')) b  ')  
   
   --5 ��ʵҵ��  
  set @targetsql='select ddate=SUBSTRING(ddate,1,6),realtotalyeji=convert(numeric(20,1),SUM(ISNULL(realtotalyeji,0)))  
  from compclasstraderesult where compid='+@compid+'   
  group by SUBSTRING(ddate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  5,* from ('+@targetsql+') a pivot (max(realtotalyeji) for ddate in (' + @sqltitle + ')) b  ')  
   
    
   
  --6 �Ŀ���(��ֵ����/���춯)  
  set @targetsql='select ddate=SUBSTRING(dateReport,1,6),realrate=convert(numeric(20,4),SUM(ISNULL(cardsalesservices,1))/ISNULL(sum(ISNULL(totalcardtrans,0)),0))  
  from detial_trade_byday_fromshops where shopId='+@compid+' and ISNULL(totalcardtrans,0)>0  
  group by SUBSTRING(dateReport,1,6)'  
   insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  6,* from ('+@targetsql+') a pivot (max(realrate) for ddate in (' + @sqltitle + ')) b  ')  
   
  --7 ���ݲ�����ռ��  
  set @targetsql='select ddate=SUBSTRING(ddate,1,6),realbeautyeji=convert(numeric(20,4),SUM(ISNULL(realbeautyeji,4))/SUM(ISNULL(realtotalyeji,0)))  
  from compclasstraderesult where compid='+@compid+'  and isnull(realtotalyeji,0)>0  
  group by SUBSTRING(ddate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  7,* from ('+@targetsql+') a pivot (max(realbeautyeji) for ddate in (' + @sqltitle + ')) b  ')  
    
  -- 110 ����Ӫҵ��ռ��  
   set @targetsql='select ddate=SUBSTRING(ddate,1,6),realbeautyeji=convert(numeric(20,4),SUM(ISNULL(beautyeji,4))/SUM(ISNULL(totalyeji,0)))  
  from compclasstraderesult where compid='+@compid+'  and isnull(realtotalyeji,0)>0  
  group by SUBSTRING(ddate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  110,* from ('+@targetsql+') a pivot (max(realbeautyeji) for ddate in (' + @sqltitle + ')) b  ')  
    
  --8����ʵҵ��  
   set @targetsql='select ddate=SUBSTRING(ddate,1,6),realhairyeji=convert(numeric(20,1),SUM(ISNULL(realhairyeji,0)))  
  from compclasstraderesult where compid='+@compid+'   
  group by SUBSTRING(ddate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  8,* from ('+@targetsql+') a pivot (max(realhairyeji) for ddate in (' + @sqltitle + ')) b  ')  
   
  --10 ϴ��������   
  set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemamt=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''01'')  
  and a.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  10,* from ('+@targetsql+') a pivot (max(csitemamt) for ddate in (' + @sqltitle + ')) b  ')  
   
  --11 �̷�����   
  set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemamt=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''03'')  
  and a.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  11,* from ('+@targetsql+') a pivot (max(csitemamt) for ddate in (' + @sqltitle + ')) b  ')  
   
  --12 Ⱦ������   
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemamt=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''02'')  
  and a.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  12,* from ('+@targetsql+') a pivot (max(csitemamt) for ddate in (' + @sqltitle + ')) b  ')  
   
  --13 ��������   
  set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemamt=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''04'',''05'',''07'',''14'')  
  and a.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  13,* from ('+@targetsql+') a pivot (max(csitemamt) for ddate in (' + @sqltitle + ')) b  ')  
   
  --14 ͷƤ����  
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemamt=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''06'')  
  and a.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  14,* from ('+@targetsql+') a pivot (max(csitemamt) for ddate in (' + @sqltitle + ')) b  ')  
    
  -- 90 ϴ������Ŀ��ռ�� 91 �̷���Ŀ��ռ�� 92 Ⱦ������ռ�� 93 ��������ռ�� 94 ͷƤ����ռ��  
    set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''01'') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
   and isnull(c.prjreporttype,'''') in (''01'',''03'',''02'',''04'',''05'',''07'',''14'',''06'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(a.financedate,1,6)'  
   
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  90,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
   
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''03'') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
   and isnull(c.prjreporttype,'''') in (''01'',''03'',''02'',''04'',''05'',''07'',''14'',''06'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  91,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
  
     
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''02'') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
   and isnull(c.prjreporttype,'''') in (''01'',''03'',''02'',''04'',''05'',''07'',''14'',''06'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  92,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''04'',''05'',''07'',''14'') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
   and isnull(c.prjreporttype,'''') in (''01'',''03'',''02'',''04'',''05'',''07'',''14'',''06'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  93,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''06'') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
   and isnull(c.prjreporttype,'''') in (''01'',''03'',''02'',''04'',''05'',''07'',''14'',''06'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  94,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
  -- 95ϴ������Ŀ��ռ�� 96 �̷���Ŀ��ռ�� 97Ⱦ����Ŀ��ռ�� 98 ������Ŀ��ռ�� 99 ͷƤ��Ŀ��ռ��  
      set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''01'') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
   and isnull(c.prjreporttype,'''') in (''01'',''03'',''02'',''04'',''05'',''07'',''14'',''06'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  95,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''03'') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
   and isnull(c.prjreporttype,'''') in (''01'',''03'',''02'',''04'',''05'',''07'',''14'',''06'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  96,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''02'') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
   and isnull(c.prjreporttype,'''') in (''01'',''03'',''02'',''04'',''05'',''07'',''14'',''06'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  97,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''04'',''05'',''07'',''14'') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
   and isnull(c.prjreporttype,'''') in (''01'',''03'',''02'',''04'',''05'',''07'',''14'',''06'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  98,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''06'') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
   and isnull(c.prjreporttype,'''') in (''01'',''03'',''02'',''04'',''05'',''07'',''14'',''06'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  99,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
     
  -- 15��������Ŀ��  
  set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemcount=convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
  and isnull(c.prjreporttype,'''') in (''01'',''03'',''02'',''04'',''05'',''07'',''14'',''06'')  
  and a.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  15,* from ('+@targetsql+') a pivot (max(csitemcount) for ddate in (' + @sqltitle + ')) b  ')  
   
  -- 16ϴ������Ŀ��   
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemcount=convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''01'')  
  and a.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  16,* from ('+@targetsql+') a pivot (max(csitemcount) for ddate in (' + @sqltitle + ')) b  ')  
   
  --17 �̷���Ŀ��   
  set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemcount=convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''03'')  
  and a.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  17,* from ('+@targetsql+') a pivot (max(csitemcount) for ddate in (' + @sqltitle + ')) b  ')  
   
   
  --18Ⱦ����Ŀ��   
    set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemcount=convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''02'')  
  and a.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  18,* from ('+@targetsql+') a pivot (max(csitemcount) for ddate in (' + @sqltitle + ')) b  ')  
   
  --19 ������Ŀ��   
  set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemcount=convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''04'',''05'',''07'',''14'')  
  and a.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  19,* from ('+@targetsql+') a pivot (max(csitemcount) for ddate in (' + @sqltitle + ')) b  ')  
   
  --20 ͷƤ��Ŀ��  
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemcount=convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''06'')  
  and a.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  20,* from ('+@targetsql+') a pivot (max(csitemcount) for ddate in (' + @sqltitle + ')) b  ')  
                  
  -- 21�����ܾ���   
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemaprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
   and isnull(c.prjreporttype,'''') in (''01'',''03'',''02'',''04'',''05'',''07'',''14'',''06'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  21,* from ('+@targetsql+') a pivot (max(csitemaprice) for ddate in (' + @sqltitle + ')) b  ')  
   
  --22 ϴ��������   
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemaprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno  and isnull(c.prjreporttype,'''') in (''01'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  22,* from ('+@targetsql+') a pivot (max(csitemaprice) for ddate in (' + @sqltitle + ')) b  ')  
   
    
  --23 �̷�����   
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemaprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno  and isnull(c.prjreporttype,'''') in (''03'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  23,* from ('+@targetsql+') a pivot (max(csitemaprice) for ddate in (' + @sqltitle + ')) b  ')  
   
  --24Ⱦ������   
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemaprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''02'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  24,* from ('+@targetsql+') a pivot (max(csitemaprice) for ddate in (' + @sqltitle + ')) b  ')  
   
  --25�������   
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemaprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''04'',''05'',''07'',''14'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  25,* from ('+@targetsql+') a pivot (max(csitemaprice) for ddate in (' + @sqltitle + ')) b  ')  
   
  --26ͷƤ����  
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemaprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''06'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  26,* from ('+@targetsql+') a pivot (max(csitemaprice) for ddate in (' + @sqltitle + ')) b  ')  
   
 -- 27�����ܿ͵���   
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billcount=count(distinct b.csbillid)   
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
   and isnull(c.prjreporttype,'''') in (''01'',''03'',''02'',''04'',''05'',''07'',''14'',''06'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  27,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
   
   
 --28�����ܿ͵���   
  set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/count(distinct b.csbillid))   
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
   and isnull(c.prjreporttype,'''') in (''01'',''03'',''02'',''04'',''05'',''07'',''14'',''06'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  28,* from ('+@targetsql+') a pivot (max(billprice) for ddate in (' + @sqltitle + ')) b  ')  
   
   
 --29 �����Ƴ̿͵���  
  set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billcount=count(distinct b.csbillid)   
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0 and isnull(cspaymode,'''')=''9''  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  29,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
 --30 �����Ƴ̿͵���   
  set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/count(distinct b.csbillid))   
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0 and isnull(cspaymode,'''')=''9''  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  30,* from ('+@targetsql+') a pivot (max(billprice) for ddate in (' + @sqltitle + ')) b  ')  
                
  --32����ʵҵ��  
    set @targetsql='select ddate=SUBSTRING(ddate,1,6),realbeautyeji=convert(numeric(20,1),SUM(ISNULL(realbeautyeji,0)))  
  from compclasstraderesult where compid='+@compid+'   
  group by SUBSTRING(ddate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  32,* from ('+@targetsql+') a pivot (max(realbeautyeji) for ddate in (' + @sqltitle + ')) b  ')  
   
  -- 33������SPA������   
  set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemamt=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0 
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  33,* from ('+@targetsql+') a pivot (max(csitemamt) for ddate in (' + @sqltitle + ')) b  ')  
   
  -- 34�沿������   
  set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemamt=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''10'',''17'')  
  and a.cscompid='+@compid+' and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0 
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  34,* from ('+@targetsql+') a pivot (max(csitemamt) for ddate in (' + @sqltitle + ')) b  ')  
   
  --35�ز�������   
  set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemamt=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''18'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0 
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  35,* from ('+@targetsql+') a pivot (max(csitemamt) for ddate in (' + @sqltitle + ')) b  ')  
   
  --36 ����������   
  set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemamt=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''09'',''11'',''13'',''22'',''23'')  
  and a.cscompid='+@compid+' and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0 
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  36,* from ('+@targetsql+') a pivot (max(csitemamt) for ddate in (' + @sqltitle + ')) b  ')  
   
  --37 ���Ƴ�����  
 set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemamt=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''15'')  
  and a.cscompid='+@compid+' and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0 
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  37,* from ('+@targetsql+') a pivot (max(csitemamt) for ddate in (' + @sqltitle + ')) b  ')  
   
   
  -- 100������SPA������ 101�沿������ 102�ز������� 103���������� 104 ���Ƴ�����  
    set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
   and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'',''10'',''17'',''18'',''09'',''11'',''13'',''22'',''23'',''15'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  100,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''10'',''17'') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
   and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'',''10'',''17'',''18'',''09'',''11'',''13'',''22'',''23'',''15'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  101,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''18'') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
  and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'',''10'',''17'',''18'',''09'',''11'',''13'',''22'',''23'',''15'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  102,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''09'',''11'',''13'',''22'',''23'') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
  and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'',''10'',''17'',''18'',''09'',''11'',''13'',''22'',''23'',''15'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  103,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''15'') then ISNULL(b.csitemamt,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemamt,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
   and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'',''10'',''17'',''18'',''09'',''11'',''13'',''22'',''23'',''15'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  104,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
    
  -- 105������Ŀ�� 106�沿��Ŀ�� 107�ز���Ŀ�� 108��������Ŀ�� 109 ����Ŀ��Ŀ��  
  set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
   and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'',''10'',''17'',''18'',''09'',''11'',''13'',''22'',''23'',''15'')  
 and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  105,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''10'',''17'') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
   and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'',''10'',''17'',''18'',''09'',''11'',''13'',''22'',''23'',''15'')  
 and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  106,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''18'') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
   and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'',''10'',''17'',''18'',''09'',''11'',''13'',''22'',''23'',''15'')  
 and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  107,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''09'',''11'',''13'',''22'',''23'') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0))) 
 
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
  and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'',''10'',''17'',''18'',''09'',''11'',''13'',''22'',''23'',''15'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  108,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billcount=convert(numeric(20,4),(sum(case when isnull(c.prjreporttype,'''') in (''15'') then ISNULL(b.csitemcount,0) else 0 end ))*1.0/SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
   and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'',''10'',''17'',''18'',''09'',''11'',''13'',''22'',''23'',''15'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  109,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
    
    
                 
  -- 38��������Ŀ��   
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemcount=convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')   
  and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'',''10'',''17'',''18'',''09'',''11'',''13'',''22'',''23'',''15'')  
  and a.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  38,* from ('+@targetsql+') a pivot (max(csitemcount) for ddate in (' + @sqltitle + ')) b  ')  
   
   
  --39������Ŀ��   
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemcount=convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'')  
  and a.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  39,* from ('+@targetsql+') a pivot (max(csitemcount) for ddate in (' + @sqltitle + ')) b  ')  
   
  --40�沿��Ŀ��   
    set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemcount=convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in  (''10'',''17'')  
  and a.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  40,* from ('+@targetsql+') a pivot (max(csitemcount) for ddate in (' + @sqltitle + ')) b  ')  
   
  --41�ز���Ŀ��   
    set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemcount=convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''18'')  
  and a.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  41,* from ('+@targetsql+') a pivot (max(csitemcount) for ddate in (' + @sqltitle + ')) b  ')  
   
  --42��������Ŀ��   
    set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemcount=convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjreporttype,'''') in (''09'',''11'',''13'',''22'',''23'')  
  and a.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  42,* from ('+@targetsql+') a pivot (max(csitemcount) for ddate in (' + @sqltitle + ')) b  ')  
   
  --43 ����Ŀ��Ŀ��  
  set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemcount=convert(numeric(20,0),SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjreporttype,'''')  in (''15'')  
  and a.cscompid='+@compid+'   and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  43,* from ('+@targetsql+') a pivot (max(csitemcount) for ddate in (' + @sqltitle + ')) b  ')  
                
 -- 44���ݾ���   
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemaprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
  and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'',''10'',''17'',''18'',''09'',''11'',''13'',''22'',''23'',''15'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  44,* from ('+@targetsql+') a pivot (max(csitemaprice) for ddate in (' + @sqltitle + ')) b  ')  
   
 --45���������   
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemaprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno  and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  45,* from ('+@targetsql+') a pivot (max(csitemaprice) for ddate in (' + @sqltitle + ')) b  ')  
   
 --46�沿�����   
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemaprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno  and isnull(c.prjreporttype,'''') in (''10'',''17'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  46,* from ('+@targetsql+') a pivot (max(csitemaprice) for ddate in (' + @sqltitle + ')) b  ')  
   
 --47�ز������   
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemaprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno  and isnull(c.prjreporttype,'''') in (''18'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  47,* from ('+@targetsql+') a pivot (max(csitemaprice) for ddate in (' + @sqltitle + ')) b  ')  
   
 --48���������   
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemaprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno  and isnull(c.prjreporttype,'''') in (''09'',''11'',''13'',''22'',''23'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  48,* from ('+@targetsql+') a pivot (max(csitemaprice) for ddate in (' + @sqltitle + ')) b  ')  
   
 --49����Ŀ����  
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),csitemaprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/SUM(ISNULL(b.csitemcount,0)))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno  and isnull(c.prjreporttype,'''') in (''15'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  49,* from ('+@targetsql+') a pivot (max(csitemaprice) for ddate in (' + @sqltitle + ')) b  ')  
                
 -- 50���ݲ��͵���   
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billcount=count(distinct b.csbillid)   
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
  and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'',''10'',''17'',''18'',''09'',''11'',''13'',''22'',''23'',''15'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  50,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
   
 -- 51���ݲ��͵���   
 set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/count(distinct b.csbillid))   
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
  and isnull(c.prjreporttype,'''') in (''08'',''12'',''19'',''20'',''21'',''10'',''17'',''18'',''09'',''11'',''13'',''22'',''23'',''15'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  51,* from ('+@targetsql+') a pivot (max(billprice) for ddate in (' + @sqltitle + ')) b  ')  
   
 -- 52 �����Ƴ̿͵���   
  set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billcount=count(distinct b.csbillid)   
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0 and isnull(cspaymode,'''')=''9''  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  52,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
 -- 53 �����Ƴ̿͵���   
  set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billprice=convert(numeric(20,1),SUM(ISNULL(b.csitemamt,0))/count(distinct b.csbillid))   
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0 and isnull(cspaymode,'''')=''9''  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  53,* from ('+@targetsql+') a pivot (max(billprice) for ddate in (' + @sqltitle + ')) b  ')  
       
  --31�����Ƴ̿͵���ռ��   
  set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billcount=convert(numeric(20,4),(count(distinct case when  isnull(cspaymode,'''')=''9'' then b.csbillid else '''' end )-1)*1.0/count(distinct b.csbillid))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''3'',''6'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  31,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
 -- 54 �����Ƴ̿͵�ռ��   
 set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billcount=convert(numeric(20,4),(count(distinct case when  isnull(cspaymode,'''')=''9'' then b.csbillid else '''' end )-1)*1.0/count(distinct b.csbillid))  
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and b.csitemno=c.prjno and isnull(c.prjtype,'''') in (''4'')  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0   
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  54,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
    
    
   -- 112 �ܿ͵���  
   set @targetsql='select ddate=SUBSTRING(a.financedate,1,6),billcount=count(distinct b.csbillid)   
  from mconsumeinfo a,dconsumeinfo b,projectnameinfo c  
  where a.csbillid=b.csbillid and a.cscompid=b.cscompid and a.financedate between ''20130101'' and ''20131231''  
  and a.cscompid='+@compid+'  and  isnull(backcsbillid,'''')='''' and ISNULL(backcsflag,0)=0  
  group by  SUBSTRING(a.financedate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  112,* from ('+@targetsql+') a pivot (max(billcount) for ddate in (' + @sqltitle + ')) b  ')  
   
   
 -- 55 ����ʧ���� 56������������ 57��Ⱦ����ʧ���� 58 ���ݲ���ʧ���� 59 ���ýӴ�������ʧ���� 60 ������ʧ����  
 --������ְָ��  
  create table #leavelstaff      
  (      
   compid  varchar(10) null,      
   inid  varchar(20) null,      
   inserdate varchar(10) null,      
   leveldate varchar(10) null,      
   department  varchar(10) null,      
  )    
    
  insert #leavelstaff(compid,inid,leveldate,department)      
  select oldcompid,a.manageno,max(effectivedate),department     
    from staffhistory a,compchaininfo ,staffinfo b with(nolock)                    
    where changetype='3' and oldcompid=relationcomp and curcomp=@compid      
   and a.manageno=b.Manageno and ISNULL(curstate,'1')='3'        
   and effectivedate>='20130101'                                             
   and effectivedate<='20131231'                          
    group by oldcompid,a.manageno,department      
      
   update #leavelstaff set inserdate=isnull((select MIN(effectivedate) from staffhistory where manageno=inid and changetype='4' ),'')   
      update #leavelstaff set inserdate='20120101' where ISNULL(inserdate,'')=''     
      
   
       
     set @targetsql=' select ddate=substring(leveldate,1,6), leavelcorecount=count(distinct inid) from #leavelstaff group by substring(leveldate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  55,* from ('+@targetsql+') a pivot (max(leavelcorecount) for ddate in (' + @sqltitle + ')) b  ')  
    
  set @targetsql=' select ddate=substring(leveldate,1,6), leavelcorecount=count(distinct inid) from #leavelstaff  where   department=''004'' group by substring(leveldate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  56,* from ('+@targetsql+') a pivot (max(leavelcorecount) for ddate in (' + @sqltitle + ')) b  ')  
    
  set @targetsql=' select ddate=substring(leveldate,1,6), leavelcorecount=count(distinct inid) from #leavelstaff where   department=''006''  group by substring(leveldate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  57,* from ('+@targetsql+') a pivot (max(leavelcorecount) for ddate in (' + @sqltitle + ')) b  ')  
    
  set @targetsql=' select ddate=substring(leveldate,1,6), leavelcorecount=count(distinct inid) from #leavelstaff where   department=''003'' group by substring(leveldate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  58,* from ('+@targetsql+') a pivot (max(leavelcorecount) for ddate in (' + @sqltitle + ')) b  ')  
    
  set @targetsql=' select ddate=substring(leveldate,1,6), leavelcorecount=count(distinct inid) from #leavelstaff where   department=''007'' group by substring(leveldate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  59,* from ('+@targetsql+') a pivot (max(leavelcorecount) for ddate in (' + @sqltitle + ')) b  ')  
    
  set @targetsql=' select ddate=substring(leveldate,1,6), leavelcorecount=count(distinct inid) from #leavelstaff where   department=''008'' group by substring(leveldate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  60,* from ('+@targetsql+') a pivot (max(leavelcorecount) for ddate in (' + @sqltitle + ')) b  ')  
    
    
    
 -- 61 3����������ʧ���� 62 3������������������ 63 3��������Ⱦ����ʧ���� 64 3���������ݲ���ʧ���� 65 3�����ڴ��ýӴ�������ʧ���� 66 3�����ں�����ʧ����  
   
  set @targetsql=' select ddate=substring(leveldate,1,6), leavelcorecount=count(distinct inid) from #leavelstaff  where DATEDIFF ( MONTH ,inserdate ,leveldate )<=3   group by substring(leveldate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  61,* from ('+@targetsql+') a pivot (max(leavelcorecount) for ddate in (' + @sqltitle + ')) b  ')  
    
  set @targetsql=' select ddate=substring(leveldate,1,6), leavelcorecount=count(distinct inid) from #leavelstaff  where DATEDIFF ( MONTH ,inserdate ,leveldate )<=3   and    department=''004'' group by substring(leveldate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  62,* from ('+@targetsql+') a pivot (max(leavelcorecount) for ddate in (' + @sqltitle + ')) b  ')  
    
  set @targetsql=' select ddate=substring(leveldate,1,6), leavelcorecount=count(distinct inid) from #leavelstaff where DATEDIFF ( MONTH ,inserdate ,leveldate )<=3  and  department=''006''  group by substring(leveldate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  63,* from ('+@targetsql+') a pivot (max(leavelcorecount) for ddate in (' + @sqltitle + ')) b  ')  
    
  set @targetsql=' select ddate=substring(leveldate,1,6), leavelcorecount=count(distinct inid) from #leavelstaff where DATEDIFF ( MONTH ,inserdate ,leveldate )<=3  and  department=''003'' group by substring(leveldate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  64,* from ('+@targetsql+') a pivot (max(leavelcorecount) for ddate in (' + @sqltitle + ')) b  ')  
    
  set @targetsql=' select ddate=substring(leveldate,1,6), leavelcorecount=count(distinct inid) from #leavelstaff where DATEDIFF ( MONTH ,inserdate ,leveldate )<=3  and  department=''007'' group by substring(leveldate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  65,* from ('+@targetsql+') a pivot (max(leavelcorecount) for ddate in (' + @sqltitle + ')) b  ')  
    
  set @targetsql=' select ddate=substring(leveldate,1,6), leavelcorecount=count(distinct inid) from #leavelstaff where DATEDIFF ( MONTH ,inserdate ,leveldate )<=3  and  department=''008'' group by substring(leveldate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  66,* from ('+@targetsql+') a pivot (max(leavelcorecount) for ddate in (' + @sqltitle + ')) b  ')  
    
    
    
 -- 67 6����������ʧ���� 68 6������������������ 69 6��������Ⱦ����ʧ���� 70 6���������ݲ���ʧ���� 71 6�����ڴ��ýӴ�������ʧ���� 62 6�����ں�����ʧ����  
  set @targetsql=' select ddate=substring(leveldate,1,6), leavelcorecount=count(distinct inid) from #leavelstaff  where DATEDIFF ( MONTH ,inserdate ,leveldate )<=6   group by substring(leveldate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  67,* from ('+@targetsql+') a pivot (max(leavelcorecount) for ddate in (' + @sqltitle + ')) b  ')  
    
  set @targetsql=' select ddate=substring(leveldate,1,6), leavelcorecount=count(distinct inid) from #leavelstaff  where DATEDIFF ( MONTH ,inserdate ,leveldate )<=6  and    department=''004'' group by substring(leveldate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  68,* from ('+@targetsql+') a pivot (max(leavelcorecount) for ddate in (' + @sqltitle + ')) b  ')  
    
  set @targetsql=' select ddate=substring(leveldate,1,6), leavelcorecount=count(distinct inid) from #leavelstaff where DATEDIFF ( MONTH ,inserdate ,leveldate )<=6  and department=''006''  group by substring(leveldate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  69,* from ('+@targetsql+') a pivot (max(leavelcorecount) for ddate in (' + @sqltitle + ')) b  ')  
    
  set @targetsql=' select ddate=substring(leveldate,1,6), leavelcorecount=count(distinct inid) from #leavelstaff where DATEDIFF ( MONTH ,inserdate ,leveldate )<=6  and department=''003'' group by substring(leveldate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  70,* from ('+@targetsql+') a pivot (max(leavelcorecount) for ddate in (' + @sqltitle + ')) b  ')  
    
  set @targetsql=' select ddate=substring(leveldate,1,6), leavelcorecount=count(distinct inid) from #leavelstaff where DATEDIFF ( MONTH ,inserdate ,leveldate )<=6  and department=''007'' group by substring(leveldate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  71,* from ('+@targetsql+') a pivot (max(leavelcorecount) for ddate in (' + @sqltitle + ')) b  ')  
    
  set @targetsql=' select ddate=substring(leveldate,1,6), leavelcorecount=count(distinct inid) from #leavelstaff where DATEDIFF ( MONTH ,inserdate ,leveldate )<=6  and department=''008'' group by substring(leveldate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  72,* from ('+@targetsql+') a pivot (max(leavelcorecount) for ddate in (' + @sqltitle + ')) b  ')  
    
 -- 73 12����������ʧ���� 74 12������������������ 75 12��������Ⱦ����ʧ���� 76 12���������ݲ���ʧ���� 77 12�����ڴ��ýӴ�������ʧ���� 78 12�����ں�����ʧ����                 
  set @targetsql=' select ddate=substring(leveldate,1,6), leavelcorecount=count(distinct inid) from #leavelstaff  where DATEDIFF ( MONTH ,inserdate ,leveldate )>12   group by substring(leveldate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  73,* from ('+@targetsql+') a pivot (max(leavelcorecount) for ddate in (' + @sqltitle + ')) b  ')  
    
  set @targetsql=' select ddate=substring(leveldate,1,6), leavelcorecount=count(distinct inid) from #leavelstaff  where DATEDIFF ( MONTH ,inserdate ,leveldate )>12  and    department=''004'' group by substring(leveldate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  74,* from ('+@targetsql+') a pivot (max(leavelcorecount) for ddate in (' + @sqltitle + ')) b  ')  
    
  set @targetsql=' select ddate=substring(leveldate,1,6), leavelcorecount=count(distinct inid) from #leavelstaff where DATEDIFF ( MONTH ,inserdate ,leveldate )>12 and  department=''006''  group by substring(leveldate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  75,* from ('+@targetsql+') a pivot (max(leavelcorecount) for ddate in (' + @sqltitle + ')) b  ')  
    
  set @targetsql=' select ddate=substring(leveldate,1,6), leavelcorecount=count(distinct inid) from #leavelstaff where DATEDIFF ( MONTH ,inserdate ,leveldate )>12 and  department=''003'' group by substring(leveldate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  76,* from ('+@targetsql+') a pivot (max(leavelcorecount) for ddate in (' + @sqltitle + ')) b  ')  
    
  set @targetsql=' select ddate=substring(leveldate,1,6), leavelcorecount=count(distinct inid) from #leavelstaff where DATEDIFF ( MONTH ,inserdate ,leveldate )>12 and department=''007'' group by substring(leveldate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  77,* from ('+@targetsql+') a pivot (max(leavelcorecount) for ddate in (' + @sqltitle + ')) b  ')  
    
  set @targetsql=' select ddate=substring(leveldate,1,6), leavelcorecount=count(distinct inid) from #leavelstaff where DATEDIFF ( MONTH ,inserdate ,leveldate )>12  and department=''008'' group by substring(leveldate,1,6)'  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  78,* from ('+@targetsql+') a pivot (max(leavelcorecount) for ddate in (' + @sqltitle + ')) b  ')  
        
    drop table #leavelstaff    
      
    create table #salarystaff      
 (      
     
   inid   varchar(20) null,      
   inserdate  varchar(10) null,    
   salary_date  varchar(10) null,   
   difdate   int   null,    
   department  varchar(10) null,   
   staffyeji  float  null,    
     
 )    
 insert  #salarystaff(inid,staffyeji,salary_date,department)  
    select person_inid,staffyeji=SUM(staffyeji),salary_date=SUBSTRING(salary_date,1,6),department     
    from staff_work_salary,staffinfo b with(nolock)     
    where compid=@compid and salary_date between '20130101' and '20131231'  
    and person_inid=manageno  
    group by person_inid,SUBSTRING(salary_date,1,6),department  
    update #salarystaff set inserdate=isnull((select MIN(effectivedate) from staffhistory where manageno=inid and changetype='4' ),'')   
    update #salarystaff set inserdate='20120101' where ISNULL(inserdate,'')=''  
      
    update #salarystaff set difdate=DATEDIFF (MONTH ,inserdate ,salary_date+'28')  
       
      -- 79 3-6���µ���3000 ��Ա�� 80 ������3-6���µ���3000 ��Ա�� 81 ��Ⱦ��3-6���µ���3000 ��Ա�� 82 ���ݲ�3-6���µ���3000 ��Ա��  
     
     set @targetsql=' select ddate=salary_date,salarycount=COUNT(inid) from #salarystaff where staffyeji<3000 and ISNULL(staffyeji,0)>0 and difdate>=3 and difdate<=6 group by  salary_date '  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  79,* from ('+@targetsql+') a pivot (max(salarycount) for ddate in (' + @sqltitle + ')) b  ')  
    
  set @targetsql=' select ddate=salary_date,salarycount=COUNT(inid) from #salarystaff where staffyeji<3000 and ISNULL(staffyeji,0)>0 and department=''004'' and difdate>=3 and difdate<=6 group by  salary_date '  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  80,* from ('+@targetsql+') a pivot (max(salarycount) for ddate in (' + @sqltitle + ')) b  ')  
    
     set @targetsql=' select ddate=salary_date,salarycount=COUNT(inid) from #salarystaff where staffyeji<3000 and ISNULL(staffyeji,0)>0 and department=''006'' and difdate>=3 and difdate<=6 group by  salary_date '  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  81,* from ('+@targetsql+') a pivot (max(salarycount) for ddate in (' + @sqltitle + ')) b  ')  
    
      set @targetsql=' select ddate=salary_date,salarycount=COUNT(inid) from #salarystaff where staffyeji<3000 and ISNULL(staffyeji,0)>0 and department=''003'' and difdate>=3 and difdate<=6 group by  salary_date '  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  82,* from ('+@targetsql+') a pivot (max(salarycount) for ddate in (' + @sqltitle + ')) b  ')  
    
  -- 83 6-12���µ���5000 ��Ա�� 84 ������6-12���µ���5000 ��Ա�� 85 ��Ⱦ��6-12���µ���5000 ��Ա�� 86 ���ݲ�6-12���µ���5000 ��Ա��  
    
    set @targetsql=' select ddate=salary_date,salarycount=COUNT(inid) from #salarystaff where staffyeji<5000 and ISNULL(staffyeji,0)>0 and difdate>6 and difdate<=12 group by  salary_date '  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  83,* from ('+@targetsql+') a pivot (max(salarycount) for ddate in (' + @sqltitle + ')) b  ')  
    
  set @targetsql=' select ddate=salary_date,salarycount=COUNT(inid) from #salarystaff where staffyeji<5000 and ISNULL(staffyeji,0)>0 and department=''004'' and difdate>6 and difdate<=12 group by  salary_date '  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  84,* from ('+@targetsql+') a pivot (max(salarycount) for ddate in (' + @sqltitle + ')) b  ')  
    
     set @targetsql=' select ddate=salary_date,salarycount=COUNT(inid) from #salarystaff where staffyeji<5000 and ISNULL(staffyeji,0)>0 and department=''006'' and difdate>6 and difdate<=12 group by  salary_date '  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  85,* from ('+@targetsql+') a pivot (max(salarycount) for ddate in (' + @sqltitle + ')) b  ')  
    
      set @targetsql=' select ddate=salary_date,salarycount=COUNT(inid) from #salarystaff where staffyeji<5000 and ISNULL(staffyeji,0)>0 and department=''003'' and difdate>6 and difdate<=12 group by  salary_date '  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  86,* from ('+@targetsql+') a pivot (max(salarycount) for ddate in (' + @sqltitle + ')) b  ')  
  -- 87 12�����ϵ���7000 ��Ա�� 88 ������12�����ϵ���7000 ��Ա�� 89 ��Ⱦ��12�����ϵ���7000 ��Ա�� 89 ���ݲ�12�����ϵ���7000 ��Ա��  
    set @targetsql=' select ddate=salary_date,salarycount=COUNT(inid) from #salarystaff where staffyeji<7000 and ISNULL(staffyeji,0)>0 and difdate>12 group by  salary_date '  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  87,* from ('+@targetsql+') a pivot (max(salarycount) for ddate in (' + @sqltitle + ')) b  ')  
    
  set @targetsql=' select ddate=salary_date,salarycount=COUNT(inid) from #salarystaff where staffyeji<7000 and ISNULL(staffyeji,0)>0 and department=''004'' and difdate>12  group by  salary_date '  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  88,* from ('+@targetsql+') a pivot (max(salarycount) for ddate in (' + @sqltitle + ')) b  ')  
    
     set @targetsql=' select ddate=salary_date,salarycount=COUNT(inid) from #salarystaff where staffyeji<7000 and ISNULL(staffyeji,0)>0 and department=''006'' and difdate>12 group by  salary_date '  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  89,* from ('+@targetsql+') a pivot (max(salarycount) for ddate in (' + @sqltitle + ')) b  ')  
    
      set @targetsql=' select ddate=salary_date,salarycount=COUNT(inid) from #salarystaff where staffyeji<7000 and ISNULL(staffyeji,0)>0 and department=''003'' and difdate>12 group by  salary_date '  
  insert #analysisresult(resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r)  
  exec (' select  111,* from ('+@targetsql+') a pivot (max(salarycount) for ddate in (' + @sqltitle + ')) b  ')  
   
    drop table #salarystaff  
      
      
                 
 update #analysisresult set months_12r=convert(numeric(20,4),ISNULL(month1r,0)+ISNULL(month2r,0)+ISNULL(month3r,0)+ISNULL(month4r,0)+ISNULL(month5r,0)+ISNULL(month6r,0)  
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
  
  --montha_5r    float  null, --��5��ƽ��  
    delete analysisresult where compno= @compid  
    insert analysisresult(compno,resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r,months_12r,monthf_5r,montha_12r,montha_5r)  
    select @compid,resusttyep,month1r,month2r,month3r,month4r,month5r,month6r,month7r,month8r,month9r,month10r,month11r,month12r,months_12r,monthf_5r,montha_12r,montha_5r  
  from #analysisresult order by resusttyep  
   
 drop table #analysisresult  
end  
go










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
   
   
      
      
                 
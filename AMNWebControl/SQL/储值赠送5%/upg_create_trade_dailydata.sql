alter procedure upg_create_trade_dailydata    
(    
 @compid   varchar(10),  --�ŵ��     
 @datefrom  varchar(10),  --��ʼ����    
 @dateto   varchar(10),  --��������    
 @showtype  int     --��ʾ����(1 �ռ��� 2 ���˱�)    
)      
as     
begin    
     
 CREATE TABLE    #dpayinfo_billcount               --  ����--֧����ϸ    
 (    
  paycompid  varchar(10)      NULL,   --��˾���    
  paydate   varchar(10)      NULL,   --֧������    
  paybilltype  varchar(5)   NULL,   --�������  SY ����  SK  �ۿ�  CZ ��ֵ ZK  ת�� HZ ������Ŀ TK �˿�    
  paymode   varchar(5)   NULL,   --֧����ʽ    
  payamt   float    NULL,   --֧�����    
 )    
    
 exec upg_compute_comp_trade_payinfo @compid,@datefrom,@dateto    
     
 if(@showtype=1)    
 begin    
  create table #tradedailydata   --�ŵ�Ӫҵ��ʱ��    
  (    
   seqno   int identity(1,1) NOT NULL, --Ĭ�ϱ��    
   tradeTitle  varchar(50)    NULL, --Ӫҵ����    
   tradeAmt  varchar(30)    NULL, --Ӫҵ���    
   valueflag  int      NULL --��ʾ��ʾ    
  )    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '�ŵ�����',compname,1 from companyinfo where compno=@compid    
    
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '��Ӫҵ��',    
  convert(numeric(20,1),SUM(case when  paymode in ('1','6','14','15','16','2') and  isnull(paybilltype,'')='TK' then isnull(payamt,0)*(-1)    
     when  paymode in ('1','6','14','15','16','2') and  isnull(paybilltype,'')<>'TK' then isnull(payamt,0) else 0 end )) ,2    
  from #dpayinfo_billcount where paycompid=@compid     
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select 'Ա�������Ʒ',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)) ,3    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode in ('1','6','14','15','16','2') and  isnull(paybilltype,'')='SY_G2'    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '�ֽ����',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)),4     
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='1' and  isnull(paybilltype,'')='SY_P'    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '�ֽ��Ʒ',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)),5     
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='1' and  isnull(paybilltype,'') in  ('SY_G1','SY_G2')    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '�ֽ��˿�',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0))*(-1),6     
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='1' and  isnull(paybilltype,'')='TK'    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '�ֽ��춯',convert(numeric(20,1),isnull(  sum(case when  isnull(paybilltype,'')='TK' then 0   
             when  isnull(paybilltype,'') in ('SK','CZ','ZK') then isnull(payamt,0) else 0 end),0)),7     
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='1' and  isnull(paybilltype,'') in ('TK','SK','CZ','ZK')    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '�ֽ����뿨',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)),8    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='1' and  isnull(paybilltype,'')='TMK'    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '�ֽ��Ƴ̶һ�',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)),9     
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='1' and  isnull(paybilltype,'')='LXDH'    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '�ֽ������Ŀ',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)) ,10    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='1' and  isnull(paybilltype,'')='HZ'    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '�ֽ�ϼ�',convert(numeric(20,1),isnull(sum(case when  isnull(paybilltype,'')='TK' then 0 else isnull(payamt,0) end),0)),11     
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='1'    
      
  -------------------------���п�-----------------------------------    
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '���п�����',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)),12     
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='6' and  isnull(paybilltype,'')='SY_P'    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '���п���Ʒ',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)),13     
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='6' and  isnull(paybilltype,'') in  ('SY_G1','SY_G2')    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '���п��˿�',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0))*(-1),14     
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='6' and  isnull(paybilltype,'')='TK'    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '���п����춯',convert(numeric(20,1),isnull(  sum(case when  isnull(paybilltype,'')='TK' then 0  
             when  isnull(paybilltype,'') in ('SK','CZ','ZK') then isnull(payamt,0) else 0 end),0)) ,15    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='6' and  isnull(paybilltype,'') in ('TK','SK','CZ','ZK')    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '���п����뿨',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)),16    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='6' and  isnull(paybilltype,'')='TMK'    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '���п��Ƴ̶һ�',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)) ,17    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='6' and  isnull(paybilltype,'')='LXDH'    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '���п�������Ŀ',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)),18    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='6' and  isnull(paybilltype,'')='HZ'    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '���п��ϼ�',convert(numeric(20,1),isnull(sum(case when  isnull(paybilltype,'')='TK' then isnull(payamt,0)*(-1) else isnull(payamt,0) end),0)),19     
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='6'    
      
   -------------------------֧Ʊ-----------------------------------    
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '֧Ʊ����',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)),20     
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='2' and  isnull(paybilltype,'')='SY_P'    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '֧Ʊ��Ʒ',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)) ,21    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='2' and  isnull(paybilltype,'') in  ('SY_G1','SY_G2')    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '֧Ʊ�˿�',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0))*(-1) ,22    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='2' and  isnull(paybilltype,'')='TK'    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '֧Ʊ���춯',convert(numeric(20,1),isnull(  sum(case when  isnull(paybilltype,'')='TK' then 0  
             when  isnull(paybilltype,'') in ('SK','CZ','ZK') then isnull(payamt,0) else 0 end),0)) ,23    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='2' and  isnull(paybilltype,'') in ('TK','SK','CZ','ZK')    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '֧Ʊ���뿨',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)),24     
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='2' and  isnull(paybilltype,'')='TMK'    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '֧Ʊ�Ƴ̶һ�',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)),25     
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='2' and  isnull(paybilltype,'')='LXDH'    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '֧Ʊ������Ŀ',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)),26    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='2' and  isnull(paybilltype,'')='HZ'    
      
       
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '֧Ʊ�ϼ�',convert(numeric(20,1),isnull(sum(case when  isnull(paybilltype,'')='TK' then isnull(payamt,0)*(-1) else isnull(payamt,0) end),0)),27     
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='2'    
      
  -------------------------ָ��ͨ-----------------------------------    
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select 'ָ��ͨ����',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)) ,28    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='14' and  isnull(paybilltype,'')='SY_P'    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select 'ָ��ͨ��Ʒ',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)) ,29    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='14' and  isnull(paybilltype,'') in  ('SY_G1','SY_G2')    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select 'ָ��ͨ�˿�',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0))*(-1) ,30    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='14' and  isnull(paybilltype,'')='TK'    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select 'ָ��ͨ���춯',convert(numeric(20,1),isnull(  sum(case when  isnull(paybilltype,'')='TK' then 0  
             when  isnull(paybilltype,'') in ('SK','CZ','ZK') then isnull(payamt,0) else 0 end),0)) ,31    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='14' and  isnull(paybilltype,'') in ('TK','SK','CZ','ZK')    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select 'ָ��ͨ���뿨',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)) ,32    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='14' and  isnull(paybilltype,'')='TMK'    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select 'ָ��ͨ�Ƴ̶һ�',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)) ,33    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='14' and  isnull(paybilltype,'')='LXDH'    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select 'ָ��ͨ������Ŀ',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)) ,34    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='14' and  isnull(paybilltype,'')='HZ'    
      
       
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select 'ָ��ͨ�ϼ�',convert(numeric(20,1),isnull(sum(case when  isnull(paybilltype,'')='TK' then isnull(payamt,0)*(-1) else isnull(payamt,0) end),0)) ,35    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='14'    
      
  -------------------------OK��-----------------------------------    
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select 'OK������',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)) ,36    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='15' and  isnull(paybilltype,'')='SY_P'    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select 'OK����Ʒ',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)) ,37    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='15' and  isnull(paybilltype,'') in  ('SY_G1','SY_G2')    
      
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select 'OK���춯',convert(numeric(20,1),isnull(  sum(case when  isnull(paybilltype,'')='TK' then 0  
             when  isnull(paybilltype,'') in ('SK','CZ','ZK') then isnull(payamt,0) else 0 end),0)) ,38    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='15' and  isnull(paybilltype,'') in ('TK','SK','CZ','ZK')    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select 'OK�����뿨',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)),39     
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='15' and  isnull(paybilltype,'')='TMK'    
      
    
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select 'OK���ϼ�',convert(numeric(20,1),isnull(sum(case when  isnull(paybilltype,'')='TK' then isnull(payamt,0)*(-1) else isnull(payamt,0) end),0)) ,40    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='15'    
      
  -------------------------�Ź���-----------------------------------    
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '�Ź�������',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)),41    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='16' and  isnull(paybilltype,'')='SY_P'    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '�Ź�����Ʒ',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)) ,42    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='16' and  isnull(paybilltype,'') in  ('SY_G1','SY_G2')    
      
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '�Ź����춯',convert(numeric(20,1),isnull(  sum(case when  isnull(paybilltype,'')='TK' then 0  
             when  isnull(paybilltype,'') in ('SK','CZ','ZK') then isnull(payamt,0) else 0 end),0)),43     
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='16' and  isnull(paybilltype,'') in ('TK','SK','CZ','ZK')    
      
    
    
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '�Ź����ϼ�',convert(numeric(20,1),isnull(sum(case when  isnull(paybilltype,'')='TK' then isnull(payamt,0)*(-1) else isnull(payamt,0) end),0)) ,44    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='16'    
      
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '���춯�ϼ�',convert(numeric(20,1),isnull(  sum(case when  isnull(paybilltype,'')='TK' then isnull(payamt,0)*(-1)    
             when  isnull(paybilltype,'') in ('SK','CZ','ZK') then isnull(payamt,0) else 0 end),0)),45    
  from #dpayinfo_billcount    
  where paycompid=@compid and  isnull(paybilltype,'') in ('TK','SK','CZ','ZK')    
      
  ------------------------------------����---------------------------------------    
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '��������',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)) ,46    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode in ('4','17') and  isnull(paybilltype,'')='SY_P'    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '�Ƴ̷���',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)) ,47    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='9' and  isnull(paybilltype,'')='SY_P'    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '�չ�������',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)) ,48    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='A' and  isnull(paybilltype,'')='SY_P'    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '������Ʒ',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)) ,49    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode in ('4','17') and  isnull(paybilltype,'') in  ('SY_G1','SY_G2')    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '�����˻�����',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)) ,50    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='7' and  isnull(paybilltype,'')='SY_P'    
      
      
      
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '�ֽ����ȯ����',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)) ,51    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='12' and  isnull(paybilltype,'')='SY_P'    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '��Ŀ����ȯ����',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)) ,52    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='11' and  isnull(paybilltype,'')='SY_P'    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '���뿨����',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0) ),53    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='13' and  isnull(paybilltype,'')='SY_P'    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '֧���Ǽ�',0,54    
      
  insert #tradedailydata(tradeTitle,tradeAmt,valueflag)    
  select '����ǩ��',convert(numeric(20,1),isnull(sum(isnull(payamt,0)),0)) ,55    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='8'     
     
  select tradeTitle,tradeAmt,valueflag from #tradedailydata    
  drop table #tradedailydata    
 end    
 else    
 begin    
  create table #tradedatedata   --�ŵ��½�����    
  (    
   tradedate   varchar(50)     NULL, --Ӫҵ����    
   totalcashamt  float     NULL, --�ֽ�ϼ�    
   staffcashamt  float     NULL, --Ա���ֽ��Ʒ    
   hezuocashamt  float     NULL --Ա���ֽ��Ʒ    
  )    
  insert #tradedatedata(tradedate,totalcashamt,staffcashamt,hezuocashamt)    
   select paydate,isnull(sum(case when  isnull(paybilltype,'')='TK' then isnull(payamt,0)*(-1) else isnull(payamt,0) end),0) ,    
         isnull(sum(case when  isnull(paybilltype,'')='SP_G2' then isnull(payamt,0) else 0 end),0),    
         isnull(sum(case when  isnull(paybilltype,'')='HZ' then isnull(payamt,0) else 0 end),0)    
  from #dpayinfo_billcount    
  where paycompid=@compid and paymode ='1'     
  group by paydate    
      
  insert #tradedatedata(tradedate,totalcashamt,staffcashamt,hezuocashamt)    
  select '',sum(isnull(totalcashamt,0)),sum(isnull(staffcashamt,0)),sum(isnull(hezuocashamt,0))    
  from #tradedatedata    
      
  select tradedate,totalcashamt,staffcashamt,hezuocashamt from #tradedatedata    
  drop table #tradedatedata    
 end    
 drop table #dpayinfo_billcount    
end 
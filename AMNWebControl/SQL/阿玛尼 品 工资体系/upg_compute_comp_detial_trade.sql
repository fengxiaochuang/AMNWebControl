alter procedure upg_compute_comp_detial_trade     
(    
 @compid   varchar(10),  --�ŵ��     
 @datefrom   varchar(10), --��ʼ����    
 @dateto   varchar(10)   --��������    
)      
as    
begin    
 --��ȡ�ŵ�֧����Ϣ    
 CREATE TABLE    #dpayinfo               --  ����--֧����ϸ    
 (    
  paycompid  varchar(10)      NULL,   --��˾���    
  paydate   varchar(10)      NOT NULL,   --��������    
  paybilltype  varchar(5)   NULL,   --�������  SY ����  SK  �ۿ�  CZ ��ֵ ZK  ת�� HZ ������Ŀ TK �˿�    
  paymode   varchar(5)   NULL,   --֧����ʽ    
  payamt   float    NULL,   --֧�����    
 )    
 create nonclustered index idx_dpayinfoday_paydate on #dpayinfo(paycompid,paydate)     
 ----------------------------��Ҫ���ݿ��ս�-------------upg_compute_comp_trade_payinfo_daybyday------------    
 insert #dpayinfo(paycompid,paydate,paybilltype,paymode,payamt)    
 select paycompid,paydate,paybilltype,paymode,payamt from payinfodaybyday,compchaininfo where  curcomp=@compid and paycompid=relationcomp     
 --�����ŵ�Ӫҵ���    
 delete detial_trade_byday_fromshops from payinfodaybyday,compchaininfo where curcomp=@compid and shopId=relationcomp and  dateReport between @datefrom and @dateto    
 create table #detial_trade_byday_fromShops      --���ڽ����ѯ�ŵ���ս���Ϣ                                              
 (                                                                                  
   shopId      varchar(10)   NULL, --�ŵ���                                               
   shopName     varchar(20)   NULL, --�ŵ�����                                               
   dateReport     varchar(8)   NULL, --��������                                               
   total      float    NULL, --������     
                                                                        
   cashService    float    NULL, --�ֽ����                                                     
   cashProd     float    NULL, --�ֽ��Ʒ                                                     
   cashCardTrans    float    NULL, --�ֽ�(���춯)                                        
   cashBackCard    float    NULL, --�ֽ�(�˿�)                                                  
   cashTotal     float    NULL, --�ֽ�ϼ�(�۳��ֽ��˿�)                                                    
                                                                                                       
   creditService    float    NULL, --���п�����                                                    
   creditProd     float    NULL, --���п���Ʒ                                                    
   creditTrans    float    NULL, --���п�(���춯)                                          
   creditBackCard    float    NULL, ---���п�(�˿�)                                               
   creditTotal    float    NULL, --���п��ϼ�(�۳����п��˿�)                                                    
                                                                                                        
   checkService    float    NULL, --֧Ʊ����                                                     
   checkProd     float    NULL, --֧Ʊ��Ʒ                                                     
   checkTrans     float    NULL, --֧Ʊ(���춯)                                           
   checkBackCard    float    NULL, --֧Ʊ(�˿�)                                               
   checkTotal     float    NULL, --֧Ʊ�ϼ�(�۳�֧Ʊ�˿�)                                       
                                     
   zftService     float    NULL, --ָ��ͨ����                                                     
   zftProd     float    NULL, --ָ��ͨ��Ʒ                                                     
   zftTrans     float    NULL, --ָ��ͨ(���춯)                                           
   zftBackCard    float    NULL, --ָ��ͨ(�˿�)                                               
   zftTotal     float    NULL, --ָ��ͨ�ϼ�(�۳�֧��ͨ�˿�)                                     
                                     
   ockService     float    NULL, --OK������                                                     
   ockkProd     float    NULL, --OK����Ʒ                                                     
   ockTrans     float    NULL, --OK��(���춯)                                             
   ockTotal     float    NULL, --OK���ϼ�    
       
   tgkService     float    NULL, --�Ź�������                                                     
   tgkkProd     float    NULL, --�Ź�����Ʒ                                       
   tgkTrans     float    NULL, --�Ź���(���춯)                                                      
   tgkTotal     float    NULL, --�Ź����ϼ�             
       
   totalCardTrans    float    NULL, --���춯(������,����ֵ,������)     
                                 
   cashchangeSale    float    NULL, --�ֽ�һ�����                              
   bankchangeSale    float    NULL, --���п��һ�����     
        
   cashbytmkSale    float    NULL, --�ֽ����뿨����                                  
   bankbytmkSale    float    NULL, --���п����뿨����                                  
   checkbytmkSale    float    NULL , --֧Ʊ���뿨����                                  
   fingerbytmkSale   float    NULL, --ָ��ͨ���뿨����                                  
   okpqypwybytmkSale   float    NULL, --OK�����뿨����    
        
   cashhezprj     float    NULL, --�ֽ������Ŀ                               
   bankhezprj     float    NULL, --���п�������Ŀ                      
   sumcashhezprj    float    NULL, --�ֽ������Ŀ(����֧�����ֽ�)                                        
                                                                                                        
                                                        
                                                                                                                   
   cardSalesServices          float    NULL, --��������                                                     
   cardSalesprod    float    NULL, --������Ʒ       
    staffsallprod    float    NULL, --Ա����Ʒ                  
   acquisitionCardServices float    NULL, --�չ�ת������     
   costpointTotal    float    NULL, --���ַ���       
   cashdyService    float    NULL,   --�ֽ����ȯ����                                  
   prjdyService    float    NULL,   --��Ŀ����ȯ����    
   tmkService     float    NULL,   --���뿨 ���� 
   tmksendService   float    NULL,   --�������뿨 ����   
   manageSigning    float    NULL, --����ǩ��                                             
   payOutRegister    float    NULL, --֧���Ǽ�     
 )      
     
 ---------------------------��ʼ����Ӫҵ����-------------------START-------------------------------        
 declare @tmpdate varchar(8)                                        
 declare @tmpenddate varchar(8)                                        
 set @tmpenddate = @datefrom                                        
 set @tmpdate = @datefrom                                        
    while (@tmpenddate <= @dateto)                                        
    begin                                        
   --����ѡ����ŵ��ŵ�#diarialBill_byday_fromShops��                                            
  insert #detial_trade_byday_fromShops(shopId,shopName,dateReport)                                            
  select compno,compname,@tmpenddate                                            
  from companyinfo,compchaininfo    
  where curcomp= @compid and  relationcomp=compno       
                                         
  execute upg_date_plus @tmpdate,1,@tmpenddate output                                        
  set @tmpdate = @tmpenddate                                        
    end     
    
 --������    
    update #detial_trade_byday_fromShops            
   set total=ISNULL((select sum(case when  paymode in ('1','6','14','15','16','2') and  isnull(paybilltype,'')='TK' then isnull(payamt,0)*(-1)    
          when  paymode in ('1','6','14','15','16','2') and  isnull(paybilltype,'')<>'TK' then isnull(payamt,0) else 0 end )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid ),0)    
      
        
        
      --���춯    
    update #detial_trade_byday_fromShops            
 set totalCardTrans=ISNULL((select  sum(case when  isnull(paybilltype,'')='TK' then isnull(payamt,0)*(-1)    
             when  isnull(paybilltype,'') in ('SK','CZ','ZK') then isnull(payamt,0) else 0 end )   
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  ),0)    
     
       
    --�ֽ����    
    update #detial_trade_byday_fromShops            
   set cashService=ISNULL((select sum( isnull(payamt,0) )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='1' and isnull(paybilltype,'')='SY_P' ),0)    
  --�ֽ��Ʒ    
    update #detial_trade_byday_fromShops            
   set cashProd=ISNULL((select sum( isnull(payamt,0) )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='1' and isnull(paybilltype,'') in ('SY_G1','SY_G2')),0)    
  --�ֽ��춯    
    update #detial_trade_byday_fromShops            
   set cashCardTrans=ISNULL((select  sum(case when  isnull(paybilltype,'')='TK' then isnull(payamt,0)*(-1)    
             when  isnull(paybilltype,'') in ('SK','CZ','ZK') then isnull(payamt,0) else 0 end )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='1'),0)    
 --�ֽ��˿�    
    update #detial_trade_byday_fromShops            
   set cashBackCard=ISNULL((select  sum(isnull(payamt,0)*(-1))    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='1' and isnull(paybilltype,'')='TK'),0)    
    
 --�ֽ�������    
  update #detial_trade_byday_fromShops            
   set cashTotal=ISNULL((select sum(case when  isnull(paybilltype,'')='TK' then isnull(payamt,0)*(-1)    
          when    isnull(paybilltype,'')<>'TK' then isnull(payamt,0) else 0 end )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='1'),0)    
       
 --���п�����    
    update #detial_trade_byday_fromShops            
   set creditService=ISNULL((select sum( isnull(payamt,0) )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='6' and isnull(paybilltype,'')='SY_P' ),0)    
  --���п���Ʒ    
    update #detial_trade_byday_fromShops            
   set creditProd=ISNULL((select sum( isnull(payamt,0) )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='6' and isnull(paybilltype,'') in ('SY_G1','SY_G2') ),0)    
  --���п����춯    
    update #detial_trade_byday_fromShops            
   set creditTrans=ISNULL((select  sum(case when  isnull(paybilltype,'')='TK' then isnull(payamt,0)*(-1)    
             when  isnull(paybilltype,'') in ('SK','CZ','ZK') then isnull(payamt,0) else 0 end )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='6'),0)    
 --���п��˿�    
    update #detial_trade_byday_fromShops            
   set creditBackCard=ISNULL((select  sum(isnull(payamt,0)*(-1))    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='6' and isnull(paybilltype,'')='TK'),0)    
    
 --���п�������    
  update #detial_trade_byday_fromShops            
   set creditTotal=ISNULL((select sum(case when  isnull(paybilltype,'')='TK' then isnull(payamt,0)*(-1)    
          when    isnull(paybilltype,'')<>'TK' then isnull(payamt,0) else 0 end )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='6'),0)    
     
 --֧Ʊ����    
    update #detial_trade_byday_fromShops            
   set checkService=ISNULL((select sum( isnull(payamt,0) )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='2' and isnull(paybilltype,'')='SY_P' ),0)    
  --֧Ʊ��Ʒ    
    update #detial_trade_byday_fromShops            
   set checkProd=ISNULL((select sum( isnull(payamt,0) )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='2' and isnull(paybilltype,'') in ('SY_G1','SY_G2')),0)    
  --֧Ʊ���춯    
    update #detial_trade_byday_fromShops            
   set checkTrans=ISNULL((select  sum(case when  isnull(paybilltype,'')='TK' then isnull(payamt,0)*(-1)    
             when  isnull(paybilltype,'') in ('SK','CZ','ZK') then isnull(payamt,0) else 0 end )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='2'),0)    
 --֧Ʊ�˿�    
    update #detial_trade_byday_fromShops            
   set checkBackCard=ISNULL((select  sum(isnull(payamt,0)*(-1))    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='2' and isnull(paybilltype,'')='TK'),0)    
    
 --֧Ʊ������    
  update #detial_trade_byday_fromShops            
   set checkTotal=ISNULL((select sum(case when  isnull(paybilltype,'')='TK' then isnull(payamt,0)*(-1)    
          when    isnull(paybilltype,'')<>'TK' then isnull(payamt,0) else 0 end )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='2'),0)    
      
 --ָ��ͨ����    
    update #detial_trade_byday_fromShops            
   set zftService=ISNULL((select sum( isnull(payamt,0) )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='14' and isnull(paybilltype,'')='SY_P' ),0)    
  --ָ��ͨ��Ʒ    
    update #detial_trade_byday_fromShops            
   set zftProd=ISNULL((select sum( isnull(payamt,0) )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='14' and isnull(paybilltype,'') in ('SY_G1','SY_G2') ),0)    
  --ָ��ͨ���춯    
    update #detial_trade_byday_fromShops            
   set zftTrans=ISNULL((select  sum(case when  isnull(paybilltype,'')='TK' then isnull(payamt,0)*(-1)    
             when  isnull(paybilltype,'') in ('SK','CZ','ZK') then isnull(payamt,0) else 0 end )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='14'),0)    
 --ָ��ͨ�˿�    
    update #detial_trade_byday_fromShops            
   set zftBackCard=ISNULL((select  sum(isnull(payamt,0)*(-1))    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='14' and isnull(paybilltype,'')='TK'),0)    
    
 --ָ��ͨ������    
  update #detial_trade_byday_fromShops            
   set zftTotal=ISNULL((select sum(case when  isnull(paybilltype,'')='TK' then isnull(payamt,0)*(-1)    
          when    isnull(paybilltype,'')<>'TK' then isnull(payamt,0) else 0 end )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='14'),0)    
 --OK������    
    update #detial_trade_byday_fromShops            
   set ockService=ISNULL((select sum( isnull(payamt,0) )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='15' and isnull(paybilltype,'')='SY_P' ),0)    
  --OK����Ʒ    
    update #detial_trade_byday_fromShops            
   set ockkProd=ISNULL((select sum( isnull(payamt,0) )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='15' and isnull(paybilltype,'') in ('SY_G1','SY_G2') ),0)    
  --OK�����춯    
    update #detial_trade_byday_fromShops            
   set ockTrans=ISNULL((select  sum(case when  isnull(paybilltype,'')='TK' then isnull(payamt,0)*(-1)    
             when  isnull(paybilltype,'') in ('SK','CZ','ZK') then isnull(payamt,0) else 0 end )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='15'),0)    
 --OK��������    
  update #detial_trade_byday_fromShops            
   set ockTotal=ISNULL((select sum(case when  isnull(paybilltype,'')='TK' then isnull(payamt,0)*(-1)    
          when    isnull(paybilltype,'')<>'TK' then isnull(payamt,0) else 0 end )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='15'),0)    
      
  --�Ź�������    
    update #detial_trade_byday_fromShops            
   set tgkService=ISNULL((select sum( isnull(payamt,0) ) from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='16' and isnull(paybilltype,'')='SY_P' ),0)    
  --�Ź�����Ʒ    
    update #detial_trade_byday_fromShops            
     set tgkkProd=ISNULL((select sum( isnull(payamt,0) ) from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='16' and isnull(paybilltype,'') in ('SY_G1','SY_G2') ),0)    
  --�Ź������춯    
    update #detial_trade_byday_fromShops            
   set tgkTrans=ISNULL((select  sum(case when  isnull(paybilltype,'')='TK' then isnull(payamt,0)*(-1)    
           when  isnull(paybilltype,'') in ('SK','CZ','ZK') then isnull(payamt,0) else 0 end )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='16'),0)    
 --�Ź���������    
  update #detial_trade_byday_fromShops            
   set tgkTotal=ISNULL((select sum(case when  isnull(paybilltype,'')='TK' then isnull(payamt,0)*(-1)    
          when    isnull(paybilltype,'')<>'TK' then isnull(payamt,0) else 0 end )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='16'),0)    
             
 --�ֽ�һ�����    
  update #detial_trade_byday_fromShops            
   set cashchangeSale=ISNULL((select sum( isnull(payamt,0) )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='1' and isnull(paybilltype,'')='LXDH' ),0)    
 --���п��һ�����     
 update #detial_trade_byday_fromShops            
   set bankchangeSale=ISNULL((select sum( isnull(payamt,0) )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='6' and isnull(paybilltype,'')='LXDH' ),0)    
     
 --�ֽ����뿨����        
 update #detial_trade_byday_fromShops            
   set cashbytmkSale=ISNULL((select sum( isnull(payamt,0) )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='1' and isnull(paybilltype,'')='TMK' ),0)    
 --���п����뿨����       
 update #detial_trade_byday_fromShops            
   set bankbytmkSale=ISNULL((select sum( isnull(payamt,0) )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='6' and isnull(paybilltype,'')='TMK' ),0)    
 --֧Ʊ���뿨����      
 update #detial_trade_byday_fromShops            
   set checkbytmkSale=ISNULL((select sum( isnull(payamt,0) )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='2' and isnull(paybilltype,'')='TMK' ),0)    
 --ָ��ͨ���뿨����        
 update #detial_trade_byday_fromShops            
   set fingerbytmkSale=ISNULL((select sum( isnull(payamt,0) )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='14' and isnull(paybilltype,'')='TMK' ),0)    
 --OK�����뿨����    
 update #detial_trade_byday_fromShops            
   set okpqypwybytmkSale=ISNULL((select sum( isnull(payamt,0) )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='15' and isnull(paybilltype,'')='TMK' ),0)    
         
 --�ֽ������Ŀ     
 update #detial_trade_byday_fromShops            
   set cashhezprj=ISNULL((select sum( isnull(payamt,0) )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='1' and isnull(paybilltype,'') in ('HZ_I') ),0)    
 --���п�������Ŀ      
 update #detial_trade_byday_fromShops            
   set bankhezprj=ISNULL((select sum( isnull(payamt,0) )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode ='6' and isnull(paybilltype,'')  in ('HZ_I') ),0)    
 --�ֽ������Ŀ(����֧�����ֽ�)     
 update #detial_trade_byday_fromShops            
   set sumcashhezprj=ISNULL((select sum( isnull(payamt,0) )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid   and isnull(paybilltype,'')='HZ_I' ),0)    
 --������ԭ�ۿ�
 ----��������          
 --update #detial_trade_byday_fromShops            
 --  set cardSalesServices=ISNULL((select sum( isnull(payamt,0) )    
 --       from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode  in ('4','9','17') and isnull(paybilltype,'')='SY_P' ),0)    
 ----������Ʒ          
 --update #detial_trade_byday_fromShops            
 --  set cardSalesprod=ISNULL((select sum( isnull(payamt,0) )    
 --       from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode in ('4','17') and isnull(paybilltype,'') in ('SY_G1','SY_G2') ),0)    
     
   --��������(������ԭ�ۿ�)
   update #detial_trade_byday_fromShops            
   set cardSalesServices=ISNULL((select sum( isnull(b.csitemamt,0) )    
        from mconsumeinfo a,dconsumeinfo b,compchaininfo c
        where a.cscompid=b.cscompid and a.csbillid=b.csbillid 
        and a.financedate=dateReport and curcomp= shopId and  relationcomp=a.cscompid  and b.cspaymode in ('4','9','17')  
        and isnull(b.csinfotype,1)=1 and isnull(a.cscardtype,'')<>'ZK'  ),0)   
           
   --������Ʒ(������ԭ�ۿ�)     
   update #detial_trade_byday_fromShops            
   set cardSalesprod=ISNULL((select sum( isnull(b.csitemamt,0) )    
        from mconsumeinfo a,dconsumeinfo b,compchaininfo c
        where a.cscompid=b.cscompid and a.csbillid=b.csbillid 
        and a.financedate=dateReport and curcomp= shopId and  relationcomp=a.cscompid  and b.cspaymode in ('4','9','17') 
        and isnull(b.csinfotype,1)=2 and isnull(a.cscardtype,'')<>'ZK' ),0)  
        
           
 update #detial_trade_byday_fromShops            
   set staffsallprod=ISNULL((select sum( isnull(payamt,0) )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid   and isnull(paybilltype,'') ='SY_G2' ),0)    
     
     
 --�չ�ת������     
 update #detial_trade_byday_fromShops            
   set acquisitionCardServices=ISNULL((select sum( isnull(payamt,0) )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode='A' and isnull(paybilltype,'')='SY_P' ),0)    
 --���ַ���     
 update #detial_trade_byday_fromShops            
   set costpointTotal=ISNULL((select sum( isnull(payamt,0) )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode='7' and isnull(paybilltype,'')='SY_P' ),0)    
                 
 --�ֽ����ȯ����     
 update #detial_trade_byday_fromShops            
   set cashdyService=ISNULL((select sum( isnull(payamt,0) )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode='12' and isnull(paybilltype,'')='SY_P' ),0)    
                 
 --��Ŀ����ȯ����     
 update #detial_trade_byday_fromShops            
   set prjdyService=ISNULL((select sum( isnull(payamt,0) )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode='11' and isnull(paybilltype,'')='SY_P' ),0)    
                 
 --���뿨����     
 --update #detial_trade_byday_fromShops            
 --  set tmkService=ISNULL((select sum( isnull(payamt,0) )    
 --       from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode='13' and isnull(paybilltype,'')='SY_P' ),0)    
  
  --�������뿨����
  update #detial_trade_byday_fromShops            
   set tmkService=ISNULL((select sum( isnull(b.csitemamt,0) )    
        from mconsumeinfo a,dconsumeinfo b,compchaininfo c,nointernalcardinfo d
        where a.cscompid=b.cscompid and a.csbillid=b.csbillid 
        and a.financedate=dateReport and curcomp= shopId and  relationcomp=a.cscompid  and b.cspaymode='13'  
        and isnull(a.tiaomacardno,'')=cardno and ISNULL(cardtype,0)=2 and ISNULL(entrytype,0)=0 ),0)    
     
     update #detial_trade_byday_fromShops            
   set tmksendService=ISNULL((select sum( isnull(b.csitemamt,0) )    
        from mconsumeinfo a,dconsumeinfo b,compchaininfo c,nointernalcardinfo d
        where a.cscompid=b.cscompid and a.csbillid=b.csbillid 
        and a.financedate=dateReport and curcomp= shopId and  relationcomp=a.cscompid  and b.cspaymode='13'  
        and isnull(a.tiaomacardno,'')=cardno and ISNULL(cardtype,0)=2 and ISNULL(entrytype,0)=1 ),0)   
           
  --����ǩ������     
 update #detial_trade_byday_fromShops            
   set manageSigning=ISNULL((select sum( isnull(payamt,0) )    
        from payinfodaybyday,compchaininfo where paydate=dateReport and curcomp= shopId and  relationcomp=paycompid  and paymode='8'  ),0)    
     
 --֧���Ǽ�    
 update #detial_trade_byday_fromShops            
   set payOutRegister=ISNULL((select sum( isnull(payoutitemamt,0) )    
        from mpayoutinfo a,dpayoutinfo b,compchaininfo where a.payoutcompid=b.payoutcompid and a.payoutbillid=b.payoutbillid and a.payoutdate=dateReport and curcomp= shopId and  relationcomp=a.payoutcompid  and b.payoutbillstate='3'  ),0)    
     
 ---------------------------��ʼ����Ӫҵ����-------------------END---------------------------------        
 insert detial_trade_byday_fromshops(shopId,shopName,dateReport,total, cashService,cashProd,cashCardTrans,cashTotal,cashBackCard,    
   creditService,creditProd,creditTrans,creditTotal,creditBackCard,checkService,checkProd,checkTrans,checkTotal,checkBackCard,    
   zftService,zftProd,zftTrans, zftTotal,zftBackCard,ockService,ockkProd,ockTrans, ockTotal,tgkService, tgkkProd,tgkTrans,tgkTotal,     
   totalCardTrans, cashchangesale,bankchangesale,cashbytmkSale,bankbytmkSale,checkbytmkSale,fingerbytmkSale,okpqypwybytmkSale,    
   cashhezprj,bankhezprj,sumcashhezprj,cardsalesservices, cardsalesprod,staffsallprod,acquisitionCardServices,costpointTotal,cashdyService,prjdyService,tmkService,tmksendservice,    
   manageSigning, payOutRegister )                                        
 select  shopId,shopName,dateReport,total,    
         cashService,cashProd,cashCardTrans,cashTotal,cashBackCard,    
   creditService,creditProd,creditTrans,creditTotal,creditBackCard,    
   checkService,checkProd,checkTrans,checkTotal,checkBackCard,    
   zftService,zftProd,zftTrans, zftTotal,zftBackCard,    
   ockService,ockkProd,ockTrans, ockTotal,    
   tgkService, tgkkProd,tgkTrans,tgkTotal,     
   totalCardTrans, cashchangesale,bankchangesale,cashbytmkSale,bankbytmkSale,checkbytmkSale,fingerbytmkSale,okpqypwybytmkSale,    
   cashhezprj,bankhezprj,sumcashhezprj,    
   cardSalesServices, cardSalesprod,staffsallprod,acquisitionCardServices,costpointTotal,cashdyService,prjdyService,tmkService,tmksendService,    
   manageSigning, payOutRegister                          
         from #detial_trade_byday_fromShops     
     
 drop table #dpayinfo    
 drop table #detial_trade_byday_fromShops    
end 
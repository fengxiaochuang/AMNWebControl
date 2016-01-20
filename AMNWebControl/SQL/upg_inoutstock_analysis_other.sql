alter procedure upg_inoutstock_analysis_other(                      
 @compid   varchar(10),   --�ŵ���                      
 @datefrom   varchar(10),   --����                     
 @dateto   varchar(10),   --����                    
 @goodsfrom   varchar(20),   --��Ʒ���                     
 @goodsto   varchar(20),   --��Ʒ���                     
 @goodstype   varchar(20)   --�ֿ���                  
)                      
as                  
begin                      
                  
 create table #begstockquan    --����ڳ���                      
 (                      
  id    int identity  not null,                        
  goodsno   varchar(20)   null,--��Ʒ���                        
  goodsname  varchar(80)   null,--��Ʒ����                        
  garageno  varchar(20)   null,--�ֿ���                        
  garagename  varchar(20)   null,--�ֿ�����                        
  goodstype  varchar(20)   null,--��Ʒ����                      
  goodstypename varchar(20)   null,--��Ʒ��������                   
  unit   varchar(10)   null,--��λ                      
  price   float    null,--����                    
  quantity  float    null,--����                            
  amt    float    null,--���                     
  primary key (id),                      
 )                      
 create table #endstockquan    -- �����ĩ��                      
 (                      
  id    int identity  not null,                        
  goodsno   varchar(20)   null,--��Ʒ���                        
  goodsname  varchar(80)   null,--��Ʒ����                        
  garageno  varchar(20)   null,--�ֿ���                        
  garagename  varchar(20)   null,--�ֿ�����                        
  goodstype  varchar(20)   null,--��Ʒ����                      
  goodstypename varchar(20)   null,--��Ʒ��������                   
  unit   varchar(10)   null,--��λ                      
  price   float    null,--����                    
  quantity  float    null,--����                            
  amt    float    null,--���                       
  primary key (id),                      
 )                      
 create table #instock      --��������                      
 (                      
  id   int identity   not null,                      
  goodsno  varchar(20)    null,--��Ʒ���                      
  garageno varchar(20)    null,--�ֿ���                      
  quantity float     null,--����                      
  amt   float     null,--�����                   
  primary key (id),                      
 )     
   
   
 create table #handselinstock      --���������                      
 (                      
 id    int identity   not null,                      
 goodsno   varchar(20)   null,--��Ʒ���                      
 quantity  float     null,--����                      
 amt    float      null,--�����                   
 primary key (id),                      
 )           
         
 create table #quitstock      --�˻���                      
 (                      
  id   int identity   not null,                      
  goodsno  varchar(20)    null,--��Ʒ���                     
  quantity float     null,--����                      
  amt   float     null,--�˽��                   
  primary key (id),                      
 )          
                   
 create table #outstock      --��ų�����                      
 (                      
  id   int identity   not null,                      
  goodsno  varchar(20)    null,--��Ʒ���                      
  garageno varchar(20)    null,--�ֿ���                   
  quantity float     null,--����                      
  amt   float     null,--������                   
  primary key (id),                      
 )                       
 create table #sendstock      -- ����;��                   
 (                      
  id    int identity   not null,                      
  goodsno   varchar(20)     null,--��Ʒ���                      
  garageno  varchar(20)     null,--�ֿ���                   
  quantity  float      null,--����                      
  amt    float      null,--�������                   
  primary key (id),                      
 )            
                    
                        
  --�����ڴ���,��1������ݽ��в�ѯ                      
  declare @start_date   varchar(8)                 
  declare @end_date   varchar(8)                    
  declare @strtmp     varchar(10)                      
                          
  set @strtmp = convert(varchar(10),dateadd(day,-1,@datefrom),120)                      
  set @start_date = substring(@strtmp,1,4)+substring(@strtmp,6,2)+substring(@strtmp,9,2)             
               
  set @strtmp = convert(varchar(10),dateadd(day,1,@dateto),120)                      
  set @end_date = substring(@strtmp,1,4)+substring(@strtmp,6,2)+substring(@strtmp,9,2)                        
                        
         
  insert #instock(goodsno,garageno,quantity,amt)                      
  select changegoodsno,changewareid,isnull(sum(changecount),0),isnull(sum(changeamt),0)                       
  from mgoodsstockinfo a,dgoodsstockinfo b ,goodsnameinfo c                   
  where a.changecompid= b.changecompid                         
       and a.changetype= b.changetype                         
       and a.changebillno= b.changebillno                        
       and a.changetype='1'  and a.changebillno not like '%e%'  and ISNULL(changeoption,0)<>6             
       and a.changedate  between @datefrom and @dateto                    
       and a.changecompid= @compid                    
       and (changegoodsno between @goodsfrom and @goodsto or ISNULL(@goodsfrom,'')='')                    
       and (c.goodspricetype = @goodstype or ISNULL(@goodstype,'')='')  and b.changegoodsno=c.goodsno                   
       and b.changebillno not in ('00120131231001x','00120131231002x')                  
       group by changegoodsno,changewareid              
               
       
       
       insert #handselinstock(goodsno,quantity,amt)                      
   select changegoodsno,isnull(sum(changecount),0),isnull(sum(changeamt),0)                       
   from mgoodsstockinfo a,dgoodsstockinfo b ,goodsnameinfo c                   
   where a.changecompid= b.changecompid                         
     and a.changetype= b.changetype                         
     and a.changebillno= b.changebillno                        
     and a.changetype='1'  and a.changebillno not like '%e%'  and ISNULL(changeoption,0)=6             
     and a.changedate  between @datefrom and @dateto                    
     and a.changecompid= @compid                    
     and (changegoodsno between @goodsfrom and @goodsto or ISNULL(@goodsfrom,'')='')                    
     and (c.goodspricetype = @goodstype or ISNULL(@goodstype,'')='')  and b.changegoodsno=c.goodsno                   
     and b.changebillno not in ('00120131231001x','00120131231002x')                  
     group by changegoodsno              
         
                 
        insert #quitstock(goodsno,quantity,amt)                      
  select changegoodsno,isnull(sum(changecount),0),isnull(sum(changeamt),0)                       
  from mgoodsstockinfo a,dgoodsstockinfo b ,goodsnameinfo c                   
  where a.changecompid= b.changecompid                         
       and a.changetype= b.changetype                         
       and a.changebillno= b.changebillno                        
       and a.changetype='1'  and a.changebillno  like '%e%'                  
       and a.changedate  between @datefrom and @dateto                    
       and a.changecompid= @compid                    
       and (changegoodsno between @goodsfrom and @goodsto or ISNULL(@goodsfrom,'')='')                    
       and (c.goodspricetype = @goodstype or ISNULL(@goodstype,'')='')  and b.changegoodsno=c.goodsno                   
       and b.changebillno not in ('00120131231001x','00120131231002x')                  
       group by changegoodsno,changewareid                 
                        
                           
       insert #outstock(goodsno,garageno,quantity,amt)                      
      select  changegoodsno,changewareid,isnull(sum(changecount),0),isnull(sum(changeamt),0)                       
                from  mgoodsstockinfo a,dgoodsstockinfo b ,goodsnameinfo c                        
            where a.changecompid= b.changecompid                         
                  and a.changetype= b.changetype                         
                  and a.changebillno= b.changebillno                        
        and a.changetype<>'1'                        
        and a.changedate  between @datefrom and @dateto                    
        and a.changecompid= @compid                    
        and (changegoodsno between @goodsfrom and @goodsto or ISNULL(@goodsfrom,'')='')                    
        and (c.goodspricetype = @goodstype or ISNULL(@goodstype,'')='')  and b.changegoodsno=c.goodsno                            
        and b.changebillno not in ('00120131231001x','00120131231002x')                  
       group by changegoodsno,changewareid                        
                     
                    
                    
     insert #sendstock(goodsno,garageno,quantity,amt)                      
     select ordergoodsno,headwareno,isnull(sum(downordercount),0),isnull(sum(downorderamt),0)                       
       from mgoodsorderinfo a,dgoodsorderinfo b ,goodsnameinfo c                   
      where a.ordercompid=b.ordercompid and a.orderbillid=b.orderbillid                        
        and ISNULL(a.invalid,0)<>'1'                        
        and a.downorderdate  between @datefrom and @dateto                    
        and a.downordercompid= @compid and isnull(b.ordergoodstype,0)=2                  
        and (ordergoodsno between @goodsfrom and @goodsto or ISNULL(@goodsfrom,'')='')                    
        and (c.goodspricetype = @goodstype or ISNULL(@goodstype,'')='')  and b.ordergoodsno=c.goodsno                   
       group by ordergoodsno,headwareno                       
                       
  --�ڳ������                 
  if(@compid<>'001' and @datefrom<'20140101')            
  begin                 
   insert #begstockquan(goodsno,goodsname,garageno,garagename,unit,goodstype,goodstypename,quantity,price,amt)                      
   exec upg_compute_goods_stock @compid,@start_date,@goodsfrom,@goodsto,''              
  end            
  else            
  begin                
   insert #begstockquan(goodsno,quantity,amt)             
   select changegoodsno,begincount,beginamt from dgoodssetlebegin ,goodsnameinfo c        
    where changecompid=@compid and ( changegoodsno between @goodsfrom and @goodsto  or ISNULL(@goodsfrom,'')='')         
      and begindate=@datefrom         
      and (c.goodspricetype = @goodstype or ISNULL(@goodstype,'')='')  and changegoodsno=c.goodsno              
  end            
             
  --��ĩ�����                      
  if(@compid<>'001' and @datefrom<'20140101')            
  begin                 
   insert #endstockquan(goodsno,goodsname,garageno,garagename,unit,goodstype,goodstypename,quantity,price,amt)                      
   exec upg_compute_goods_stock @compid,@dateto,@goodsfrom,@goodsto,''            
  end            
  else            
  begin               
           
   if exists(select 1 from dgoodssetlebegin where begindate=@end_date)            
   begin           
    insert #endstockquan(goodsno,quantity,amt)             
    select changegoodsno,begincount,beginamt from dgoodssetlebegin ,goodsnameinfo c        
    where changecompid=@compid and ( changegoodsno between @goodsfrom and @goodsto  or ISNULL(@goodsfrom,'')='')         
    and begindate=@end_date  and (c.goodspricetype = @goodstype or ISNULL(@goodstype,'')='')  and changegoodsno=c.goodsno            
   end            
   else            
   begin            
    insert #endstockquan(goodsno,goodsname,garageno,garagename,unit,goodstype,goodstypename,quantity,price,amt)                      
    exec upg_compute_goods_stock @compid,@dateto,@goodsfrom,@goodsto,''            
   end            
  end            
        
             
           
           
                         
     
  select goodsno=x.goodsno,goodsname=x.goodsname,garageno=x.goodswarehouse,garagename=z.warehousename, goodsclassname=y.parentcodevalue,                     
  pquan=sum(isnull(b.quantity,0)),unit=x.saleunit,                      
  pamt=sum(isnull(b.amt,0)),                      
  inquan=sum(isnull(c.quantity,0)),                        
  inamt =sum(isnull(c.amt,0)) ,   
  hinquan=sum(isnull(g.quantity,0)),                        
  hinamt =sum(isnull(g.amt,0)) ,                   
  outquan=sum(isnull(d.quantity,0)),                      
  outamt=sum(isnull(d.amt,0)),                  
  equan=sum(isnull(a.quantity,0)),                      
  eamt=sum(isnull(a.amt,0))  ,          
  squan=sum(isnull(e.quantity,0)),                      
  samt=sum(isnull(e.amt,0)) ,                   
  qquan=sum(isnull(f.quantity,0)),                      
  qamt=sum(isnull(f.amt,0))                     
  from goodsinfo x,  compwarehouse z,commoninfo y, #endstockquan a                    
  left outer join #begstockquan b on a.goodsno = b.goodsno                  
  left outer join #instock c on a.goodsno = c.goodsno                      
  left outer join #outstock d on a.goodsno = d.goodsno                   
  left outer join #sendstock e on a.goodsno = e.goodsno          
  left outer join #quitstock f on a.goodsno = f.goodsno     
  left outer join #handselinstock g on a.goodsno=g.goodsno                 
  where x.goodsno=a.goodsno and x.goodsmodeid='SGM'  and isnull(x.useflag,0)=0           
  and z.compno=@compid and warehouseno=x.goodswarehouse                
  and (x.goodspricetype = @goodstype or ISNULL(@goodstype,'')='')   
  and y.infotype='WPTJ' and y.parentcodekey=x.goodspricetype        
  group by x.goodsno,x.goodsname,x.goodswarehouse,z.warehousename,x.saleunit,parentcodevalue                    
  order by x.goodsno                    
                         
  drop table #begstockquan                      
  drop table #endstockquan                      
  drop table #instock                      
  drop table #outstock                      
                       
end 
--exec upg_inoutstock_analysis '001','20131101','20131117','','',''

if exists(select 1 from sysobjects where type='P' and name='upg_inoutstock_analysis')
	drop procedure upg_inoutstock_analysis
go
create procedure upg_inoutstock_analysis(    
	@compid			varchar(10),			--�ŵ���    
	@datefrom		varchar(10),			--����   
	@dateto			varchar(10),			--����  
	@goodsfrom		varchar(20),			--��Ʒ���   
	@goodsto		varchar(20),			--��Ʒ���   
	@wareid			varchar(20)			--�ֿ���
)    
as
begin    

  create table #begstockquan    --����ڳ���    
  (    
		id				int identity	not null,      
		goodsno			varchar(20)		null,--��Ʒ���      
		goodsname		varchar(80)		null,--��Ʒ����      
		garageno		varchar(20)		null,--�ֿ���      
		garagename		varchar(20)		null,--�ֿ�����      
		goodstype		varchar(20)		null,--��Ʒ����    
		goodstypename	varchar(20)		null,--��Ʒ�������� 
		unit			varchar(10)		null,--��λ    
		price			float			null,--����  
		quantity		float			null,--����          
		amt				float			null,--���   
		primary key (id),    
  )    
  create table #endstockquan    -- �����ĩ��    
  (    
		id				int identity	not null,      
		goodsno			varchar(20)		null,--��Ʒ���      
		goodsname		varchar(80)		null,--��Ʒ����      
		garageno		varchar(20)		null,--�ֿ���      
		garagename		varchar(20)		null,--�ֿ�����      
		goodstype		varchar(20)		null,--��Ʒ����    
		goodstypename	varchar(20)		null,--��Ʒ�������� 
		unit			varchar(10)		null,--��λ    
		price			float			null,--����  
		quantity		float			null,--����          
		amt				float			null,--���     
   primary key (id),    
  )    
  create table #instock      --��������    
  (    
		id				int identity			not null,    
		goodsno			varchar(20)					null,--��Ʒ���    
		garageno		varchar(20)					null,--�ֿ���    
		quantity		float						null,--����    
		amt				float						null,--����� 
   primary key (id),    
  )    
  create table #outstock      --��ų�����    
  (    
		id				int identity			not null,    
		goodsno			varchar(20)					null,--��Ʒ���    
		garageno		varchar(20)					null,--�ֿ��� 
		quantity		float						null,--����    
		amt				float						null,--������ 
   primary key (id),    
  )     
   create table #sendstock      -- ����;�� 
  (    
		id				int identity			not null,    
		goodsno			varchar(20)					null,--��Ʒ���    
		garageno		varchar(20)					null,--�ֿ��� 
		quantity		float						null,--����    
		amt				float						null,--������� 
   primary key (id),    
  )     
  
      
	  --�����ڴ���,��1������ݽ��в�ѯ    
	  declare @start_date   varchar(8)    
	  declare @strtmp     varchar(10)    
	       
	  set @strtmp = convert(varchar(10),dateadd(day,-1,@datefrom),120)    
	  set @start_date = substring(@strtmp,1,4)+substring(@strtmp,6,2)+substring(@strtmp,9,2)    
      
   
		insert #instock(goodsno,garageno,quantity,amt)    
		select  changegoodsno,changewareid,isnull(sum(changecount),0),isnull(sum(changeamt),0)     
                from  mgoodsstockinfo a,dgoodsstockinfo b  
                where a.changecompid= b.changecompid       
                  and a.changetype= b.changetype       
                  and a.changebillno= b.changebillno      
                  and a.changetype='1'       
                  and a.changedate  between @datefrom and @dateto  
                  and a.changecompid= @compid  
                  and (changegoodsno between @goodsfrom and @goodsto or ISNULL(@goodsfrom,'')='')  
                  and (changewareid = @wareid or ISNULL(@wareid,'')='')  
                  and b.changebillno not in ('00120131231001x','00120131231002x')
       group by changegoodsno,changewareid     
         
       insert #outstock(goodsno,garageno,quantity,amt)    
      select  changegoodsno,changewareid,isnull(sum(changecount),0),isnull(sum(changeamt),0)     
                from  mgoodsstockinfo a,dgoodsstockinfo b  
                where a.changecompid= b.changecompid       
                  and a.changetype= b.changetype       
                  and a.changebillno= b.changebillno      
                  and a.changetype<>'1'      
                  and a.changedate  between @datefrom and @dateto  
                  and a.changecompid= @compid  
                  and (changegoodsno between @goodsfrom and @goodsto or ISNULL(@goodsfrom,'')='')  
                  and (changewareid = @wareid or ISNULL(@wareid,'')='')  
                   and b.changebillno not in ('00120131231001x','00120131231002x')
       group by changegoodsno,changewareid      
   
  
		
     insert #sendstock(goodsno,garageno,quantity,amt)    
      select  ordergoodsno,headwareno,isnull(sum(downordercount),0),isnull(sum(downorderamt),0)     
               from mgoodsorderinfo a,dgoodsorderinfo b
               where a.ordercompid=b.ordercompid and a.orderbillid=b.orderbillid      
                  and ISNULL(a.invalid,0)<>'1'      
                  and a.downorderdate  between @datefrom and @dateto  
                  and a.downordercompid= @compid and isnull(orderstate,0)=2
                  and (ordergoodsno between @goodsfrom and @goodsto or ISNULL(@goodsfrom,'')='')  
                  and (headwareno = @wareid or ISNULL(@wareid,'')='')  
       group by ordergoodsno,headwareno     
     
     --�ڳ������    
     insert #begstockquan(goodsno,goodsname,garageno,garagename,unit,goodstype,goodstypename,quantity,price,amt)    
     exec upg_compute_goods_stock @compid,@start_date,@goodsfrom,@goodsto,@wareid
	 --��ĩ�����    
     insert #endstockquan(goodsno,goodsname,garageno,garagename,unit,goodstype,goodstypename,quantity,price,amt)    
     exec upg_compute_goods_stock @compid,@dateto,@goodsfrom,@goodsto,@wareid
	
  --select goodsno=a.goodsno,goodsname=a.goodsname,garageno=a.garageno,garagename=a.garagename,    
  -- pquan=sum(isnull(b.quantity,0)),unit=a.unit,    
  -- pamt=sum(isnull(b.quantity,0)*ISNULL(purchaseprice,0)),    
  -- inquan=sum(isnull(c.quantity,0)),   
  -- inamt =sum(isnull(c.quantity,0)*ISNULL(purchaseprice,0)) ,
  -- outquan=sum(isnull(d.quantity,0)),    
  -- outamt=sum(isnull(d.quantity,0)*ISNULL(purchaseprice,0)),
  -- equan=sum(isnull(a.quantity,0)),    
  -- eamt=sum(isnull(a.quantity,0)*ISNULL(purchaseprice,0))  ,
  -- squan=sum(isnull(e.quantity,0)),    
  -- samt=sum(isnull(e.quantity,0)*ISNULL(purchaseprice,0))   
  --from goodsinfo x,   #endstockquan a  
  --left outer join #begstockquan b on a.goodsno = b.goodsno and a.garageno = b.garageno    
  --left outer join #instock c on a.goodsno = c.goodsno and a.garageno = c.garageno    
  --left outer join #outstock d on a.goodsno = d.goodsno and a.garageno = d.garageno   
  --left outer join #sendstock e on a.goodsno = e.goodsno and a.garageno = e.garageno 
  --where x.goodsno=a.goodsno and x.goodsmodeid='SGM'
  --group by a.goodsno,a.goodsname,a.garageno,a.garagename,a.unit    
      select goodsno=a.goodsno,goodsname=a.goodsname,garageno=a.garageno,garagename=a.garagename,    
   pquan=sum(isnull(b.quantity,0)),unit=a.unit,    
   pamt=sum(isnull(b.amt,0)),    
   inquan=sum(isnull(c.quantity,0)),   
   inamt =sum(isnull(c.amt,0)) ,
   outquan=sum(isnull(d.quantity,0)),    
   outamt=sum(isnull(d.amt,0)),
   equan=sum(isnull(a.quantity,0)),    
   eamt=sum(isnull(a.quantity,0)*isnull(x.purchaseprice,0))  ,
   squan=sum(isnull(e.quantity,0)),    
   samt=sum(isnull(e.amt,0))   
  from goodsinfo x,   #endstockquan a  
  left outer join #begstockquan b on a.goodsno = b.goodsno and a.garageno = b.garageno    
  left outer join #instock c on a.goodsno = c.goodsno and a.garageno = c.garageno    
  left outer join #outstock d on a.goodsno = d.goodsno and a.garageno = d.garageno   
  left outer join #sendstock e on a.goodsno = e.goodsno and a.garageno = e.garageno 
  where x.goodsno=a.goodsno and x.goodsmodeid='SGM'
  group by a.goodsno,a.goodsname,a.garageno,a.garagename,a.unit  
    
       
  drop table #begstockquan    
  drop table #endstockquan    
  drop table #instock    
  drop table #outstock    
     
end  
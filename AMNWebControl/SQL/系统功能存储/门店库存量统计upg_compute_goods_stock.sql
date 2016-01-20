--exec upg_compute_goods_stock '001','20131114','30101101','30101101',''
----------------�����ŵ���-----------------
if exists(select 1 from sysobjects where type='P' and name='upg_compute_goods_stock')
	drop procedure upg_compute_goods_stock
go
create procedure upg_compute_goods_stock   
(      
 @compid   varchar(10),   --��ݱ��      
 @date   varchar(10),   --����       
 @goodsfrom  varchar(20),  --��Ʒ���from       
 @goodsto  varchar(20),   --��Ʒ���to       
 @garagefrom  varchar(20)        --�ֿ���from   
  
)      
as  
begin      
   
    --�����������(������λ���׼��λת��)         
   create table #inser_stock     
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
   -- ��ų��⡢���������õ��������ĵ�λ���׼��λת����   
   create table #outser_stock       
   (      
	   id				int identity        not null,      
	   goodsno			varchar(20)				null,--��Ʒ���      
	   goodsname		varchar(80)				null,--��Ʒ����      
	   garageno			varchar(20)				null,--�ֿ���      
	   garagename		varchar(20)				null,--�ֿ�����      
	   unit				varchar(10)				null,--��λ      
	   quantity			float					null,--����      
	   primary key (id),      
   )      
   insert #inser_stock(goodsno,goodsname,garageno,garagename,unit,quantity)      
   select  changegoodsno,'',changewareid,'','',isnull(sum(changecount),0)     
                from  mgoodsstockinfo a,dgoodsstockinfo b  
                where a.changecompid= b.changecompid       
                  and a.changetype= b.changetype       
                  and a.changebillno= b.changebillno      
                  and a.changetype='1'       
                  and a.changedate<=@date   
                  and a.changecompid= @compid  
                  and (changegoodsno between @goodsfrom and @goodsto or ISNULL(@goodsfrom,'')='')  
                  and (changewareid = @garagefrom or ISNULL(@garagefrom,'')='')  
       group by changegoodsno,changewareid      
         
             
      insert #outser_stock(goodsno,goodsname,garageno,garagename,unit,quantity)      
      select  changegoodsno,'',changewareid,'','',isnull(sum(changecount),0)     
                from  mgoodsstockinfo a,dgoodsstockinfo b  
                where a.changecompid= b.changecompid       
                  and a.changetype= b.changetype       
                  and a.changebillno= b.changebillno      
                  and a.changetype<>'1'       
                  and a.changedate<=@date  
                  and a.changecompid= @compid      
                  and (changegoodsno between @goodsfrom and @goodsto or ISNULL(@goodsfrom,'')='')  
                  and (changewareid = @garagefrom or ISNULL(@garagefrom,'')='')   
      group by changegoodsno,changewareid    
	  --���²ֿ�����      
	  update a      
	  set a.garagename =b.warehousename      
	  from #inser_stock a,compwarehouse b      
	  where a.garageno = b.warehouseno      
		and b.compno = @compid      
          
     
      
   --ͳ�Ƴ���(��������)���������¿����      
      
  update t      
  set t.quantity = isnull(t.quantity,0)- isnull(a.quantity,0)       
  from #outser_stock a, #inser_stock t      
  where  a.goodsno=t.goodsno       
   and a.garageno=t.garageno           
        
  --���²�Ʒ��      
  update a set  a.goodsname=b.goodsname,a.unit=b.saleunit ,
				a.goodstype=b.goodspricetype ,
				a.goodstypename=c.parentcodevalue,
				a.price=b.storesalseprice,
				a.amt=isnull(a.quantity,0)*isnull(b.storesalseprice,0)
  from #inser_stock a, goodsinfo b ,commoninfo  c ,compchaininfo 
  where curcomp=goodssource and relationcomp=@compid and a.goodsno = b.goodsno   
  and  b.goodspricetype=c.parentcodekey and c.infotype='WPTJ'
          
        
   
    select goodsno,goodsname,garageno,garagename,unit,goodstype,goodstypename,quantity,price,amt      
    from #inser_stock  
    order by goodsno     
      
  drop table #inser_stock      
  drop table #outser_stock      
       
end 
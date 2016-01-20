if exists(select 1 from sysobjects where type='P' and name='upg_changestock_analysis')
	drop procedure upg_changestock_analysis
go
create procedure upg_changestock_analysis(    
	@compid			varchar(10),			--�ŵ���    
	@datefrom		varchar(10),			--����   
	@dateto			varchar(10),			--����  
	@goodsfrom		varchar(20),			--��Ʒ���   
	@goodsto		varchar(20),			--��Ʒ���   
	@wareid			varchar(20)			--�ֿ���
)    
as
begin    

 create table #changedetail      
 (      
		id					int identity		not null,      
		itemno				varchar(30)				null, -- item no      
		itemname			varchar(50)				null, -- item no 
		storage				varchar(20)				null, -- �ֿ�      
		storagename			varchar(60)				null, -- �ֿ�      
		ddate				varchar(8)				null , -- �춯����     
		ttime				varchar(8)				null , --  �춯ʱ�� 
		insercount			float					null , -- �������      
		outrecount			float					null , -- ��������      
		changetype			varchar(20)				null , -- �춯���      
		billno				varchar(30)				null , -- �춯����      
		stock				float					null , -- �������  
		primary key (id),      
 )  
 
	insert #changedetail( itemno, storage, ddate, ttime,insercount, outrecount ,changetype, billno )
	select  changegoodsno,changewareid,changedate,changetime,
  	case a.changetype when 1 then changecount else 0 end,
  	case a.changetype when 1 then 0 else changecount end,      
	case a.changetype when '1' then case changeoption when 1 then '�������' when 2 then '��ӯ���' when 3 then '�ͻ��˻�' when 4 then '�������' end     
                        when '2' then case changeoption when 1 then '��������' when 2 then '�̿�����' when 3 then '��Ӧ���˻�' when 4 then '��������' when 5 then '��' when 6 then '����' else '����' end    
                        when '3' then '����'     
                        when '5' then '�ײ�'     
                        when '6' then '�ײ�'     
                        else '����' end,a.changebillno
                from  mgoodsstockinfo a,dgoodsstockinfo b  
                where a.changecompid= b.changecompid       
                  and a.changetype= b.changetype       
                  and a.changebillno= b.changebillno 
                  and a.changedate  between @datefrom and @dateto  
                  and a.changecompid= @compid  
                  and (changegoodsno between @goodsfrom and @goodsto or ISNULL(@goodsfrom,'')='')  
                  and (changewareid = @wareid or ISNULL(@wareid,'')='')  
       order by a.changecompid,changegoodsno,changedate,changetime     
       
        update #changedetail set stock =       
  isnull((select sum(insercount) from #changedetail A       
  where A.id <= #changedetail.id and A.itemno = #changedetail.itemno and A.storage = #changedetail.storage ), 0)    
      
 update #changedetail set stock = stock -       
  isnull((select sum(outrecount) from #changedetail A       
  where A.id <= #changedetail.id and A.itemno = #changedetail.itemno and A.storage = #changedetail.storage ), 0)      
      
      
 delete #changedetail where ddate < @datefrom or ddate > @dateto     
   --���²ֿ�����      
 update a      
	  set a.storagename =b.warehousename      
	  from #changedetail a,compwarehouse b      
	  where a.storage = b.warehouseno      
		and b.compno = @compid      
  --���²�Ʒ��      
  update a set  a.itemname=b.goodsname
  from #changedetail a, goodsnameinfo b 
  where a.itemno = b.goodsno  
       

  select itemno,itemname,storage,storagename,ddate,insercount,outrecount,changetype,billno,stock from #changedetail order by ddate,ttime
  drop table #changedetail
     
end  
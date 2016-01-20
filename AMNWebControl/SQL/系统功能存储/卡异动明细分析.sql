if exists(select 1 from sysobjects where type='P' and name='upg_analysis_comp_changebill')
	drop procedure upg_analysis_comp_changebill
go
CREATE procedure upg_analysis_comp_changebill                        
(                                  
 @compid		varchar(10) ,                                  
 @fromdate		varchar(8),                                  
 @todate		varchar(8),
 @search		int			--1����	 ,2��ֵ 3�ۿ�ת�� 4 �չ�ת�� 5����ת�� 6 �Ͽ����Ͽ� 7 �Ͽ����¿� 8 �˿� 9�Ƴ̶һ�                               
)                                  
as                                  
begin                                  
    create table #changeinfo
    (
		compno				varchar(10)		null,
		compname			varchar(50)		null,
		changetype			int				null,
		changetypename		varchar(30)		null,
		changedate			varchar(10)		null,
		changebillno		varchar(20)		null,
		membername			varchar(30)		null,
		oldcardno			varchar(20)		null,
		oldcardtype			varchar(10)		null,
		oldcardtypename		varchar(30)		null,
		newcardno			varchar(20)		null,
		newcardtype			varchar(10)		null,
		newcardtypename		varchar(30)		null,
		changeamt			float			null,
    )    
    
    if(@search=1)
    begin
			insert #changeinfo(compno,changetype,changetypename,changedate,changebillno,oldcardno,oldcardtype,changeamt,membername)
			select salecompid,1,'��Ա������',saledate,salebillid,salecardno,salecardtype,sum(isnull(payamt,0)),membername 
				from msalecardinfo with(nolock), dpayinfo with(nolock),compchaininfo
				where salebillid=paybillid and salecompid=paycompid and paybilltype='SK'  
				and salecompid=relationcomp and curcomp=@compid and financedate between @fromdate and @todate and ISNULL(salebakflag,0)=0  
			group by  salecompid,saledate,salebillid,salecardno,salecardtype,membername
    end    
    else if(@search=2) 
    begin
			insert #changeinfo(compno,changetype,changetypename,changedate,changebillno,oldcardno,oldcardtype,changeamt,membername)
			select rechargecompid,2,'��Ա����ֵ',rechargedate,rechargebillid,rechargecardno,rechargecardtype,sum(isnull(payamt,0)),membername 
			from mcardrechargeinfo with(nolock), dpayinfo with(nolock),compchaininfo
			where rechargebillid=paybillid and rechargecompid=paycompid and paybilltype='CZ'  
			  and rechargecompid=relationcomp and curcomp=@compid and financedate between @fromdate and @todate and ISNULL(salebakflag,0)=0  
			 group by  rechargecompid,rechargedate,rechargebillid,rechargecardno,rechargecardtype,membername
     end  
     else if(@search=3) 
     begin
			  --0 �ۿ�ת�� 1 �չ�ת�� 2����ת�� 3���� 4��ʧ�� 5���� 6�Ͽ����Ͽ� 7�Ͽ����¿� 8�˿�
			  insert #changeinfo(compno,changetype,changetypename,changedate,changebillno,oldcardno,oldcardtype,newcardno,newcardtype,changeamt,membername)
			select changecompid,3,'�ۿ�ת��',changedate,changebillid,changebeforcardno,changebeforcardtype,changeaftercardno,changeaftercardtype,sum(isnull(payamt,0)),membername 
			from mcardchangeinfo with(nolock), dpayinfo with(nolock),compchaininfo
			where changebillid=paybillid and changecompid=paycompid and paybilltype='ZK'  
			  and changecompid=relationcomp and curcomp=@compid and financedate between @fromdate and @todate and ISNULL(salebakflag,0)=0  
			  and changetype=0
			 group by  changecompid,changedate,changebillid,changebeforcardno,changebeforcardtype,changeaftercardno,changeaftercardtype,membername
     end   
     else if(@search=4)   
     begin  
			   insert #changeinfo(compno,changetype,changetypename,changedate,changebillno,oldcardno,oldcardtype,newcardno,newcardtype,changeamt,membername)
			select changecompid,4,'�չ�ת��',changedate,changebillid,changebeforcardno,changebeforcardtype,changeaftercardno,changeaftercardtype,sum(isnull(payamt,0)),membername
			from mcardchangeinfo with(nolock), dpayinfo with(nolock),compchaininfo
			where changebillid=paybillid and changecompid=paycompid and paybilltype='ZK'  
			  and changecompid=relationcomp and curcomp=@compid and financedate between @fromdate and @todate and ISNULL(salebakflag,0)=0  
			  and changetype=1
			 group by  changecompid,changedate,changebillid,changebeforcardno,changebeforcardtype,changeaftercardno,changeaftercardtype,membername
     end      
     else if(@search=5)   
     begin 
			   insert #changeinfo(compno,changetype,changetypename,changedate,changebillno,oldcardno,oldcardtype,newcardno,newcardtype,changeamt,membername)
			select changecompid,5,'����ת��',changedate,changebillid,changebeforcardno,changebeforcardtype,changeaftercardno,changeaftercardtype,sum(isnull(payamt,0)),membername 
			from mcardchangeinfo with(nolock), dpayinfo with(nolock),compchaininfo
			where changebillid=paybillid and changecompid=paycompid and paybilltype='ZK'  
			  and changecompid=relationcomp and curcomp=@compid and financedate between @fromdate and @todate and ISNULL(salebakflag,0)=0  
			  and changetype=2
			 group by  changecompid,changedate,changebillid,changebeforcardno,changebeforcardtype,changeaftercardno,changeaftercardtype,membername
    end     
    else if(@search=6)   
    begin 
			   insert #changeinfo(compno,changetype,changetypename,changedate,changebillno,oldcardno,oldcardtype,newcardno,newcardtype,changeamt,membername)
			select changecompid,6,'�Ͽ����Ͽ�',changedate,changebillid,changebeforcardno,changebeforcardtype,changeaftercardno,changeaftercardtype,sum(isnull(payamt,0)),membername
			from mcardchangeinfo with(nolock), dpayinfo with(nolock),compchaininfo
			where changebillid=paybillid and changecompid=paycompid and paybilltype='ZK'  
			  and changecompid=relationcomp and curcomp=@compid and financedate between @fromdate and @todate and ISNULL(salebakflag,0)=0  
			  and changetype=6
			 group by  changecompid,changedate,changebillid,changebeforcardno,changebeforcardtype,changeaftercardno,changeaftercardtype,membername
    end
    else if(@search=7)   
    begin       
			   insert #changeinfo(compno,changetype,changetypename,changedate,changebillno,oldcardno,oldcardtype,newcardno,newcardtype,changeamt,membername)
			select changecompid,7,'�Ͽ����¿�',changedate,changebillid,changebeforcardno,changebeforcardtype,changeaftercardno,changeaftercardtype,sum(isnull(payamt,0)),membername 
			from mcardchangeinfo with(nolock), dpayinfo with(nolock),compchaininfo
			where changebillid=paybillid and changecompid=paycompid and paybilltype='ZK'  
			  and changecompid=relationcomp and curcomp=@compid and financedate between @fromdate and @todate and ISNULL(salebakflag,0)=0  
			  and changetype=7
			 group by  changecompid,changedate,changebillid,changebeforcardno,changebeforcardtype,changeaftercardno,changeaftercardtype,membername
    end  
    else if(@search=8)   
	begin 
			insert #changeinfo(compno,changetype,changetypename,changedate,changebillno,oldcardno,oldcardtype,newcardno,newcardtype,changeamt,membername)
			select changecompid,8,'�˿�',changedate,changebillid,changebeforcardno,changebeforcardtype,changeaftercardno,changeaftercardtype,sum(isnull(payamt,0))*(-1) ,membername
			from mcardchangeinfo with(nolock), dpayinfo with(nolock),compchaininfo
			where changebillid=paybillid and changecompid=paycompid and paybilltype='TK'  
			  and changecompid=relationcomp and curcomp=@compid and financedate between @fromdate and @todate and ISNULL(salebakflag,0)=0  
			  and changetype=8
			 group by  changecompid,changedate,changebillid,changebeforcardno,changebeforcardtype,changeaftercardno,changeaftercardtype,membername
     end
     else if(@search=9)   
     begin 
			insert #changeinfo(compno,changetype,changetypename,changedate,changebillno,oldcardno,oldcardtype,changeamt,membername)
			select a.changecompid,9,'�Ƴ̶һ�',changedate,a.changebillid,changecardno,changecardtype,sum(isnull(changeproamt,0)),membername
			from mproexchangeinfo a with(nolock) , dproexchangeinfo b with(nolock),compchaininfo
			where a.changecompid=relationcomp and curcomp=@compid and financedate between @fromdate and @todate and ISNULL(backcsflag,0)=0  
			and a.changecompid=b.changecompid and a.changebillid=b.changebillid
			 group by  a.changecompid,changedate,a.changebillid,changecardno,changecardtype,membername
     end     
             
    --�����ŵ�����
    update a
    set a.compname=b.compname
    from  #changeinfo a,companyinfo b
    where a.compno=b.compno
    
    --���¿���������
    update a
    set a.oldcardtypename=b.cardtypename
    from  #changeinfo a,cardtypenameinfo b
    where a.oldcardtype=b.cardtypeno
     and ISNULL(oldcardno,'')<>''
    --���¿���������
    update a
    set a.newcardtypename=b.cardtypename
    from  #changeinfo a,cardtypenameinfo b
    where a.newcardtype=b.cardtypeno
    and ISNULL(newcardno,'')<>''
    
    select compno,compname,changetype,changetypename,changedate,changebillno,membername,oldcardno,oldcardtype,oldcardtypename,newcardno,newcardtype,newcardtypename,changeamt
     from #changeinfo order by compno,changetype,changedate
     drop table #changeinfo
end 
go



-------��Ա���Ƴ̶һ�----
if exists(select 1 from sysobjects where type='P' and name='upg_handaccountChangebill_card')
	drop procedure upg_handaccountChangebill_card
go
create procedure upg_handaccountChangebill_card
@compid			varchar(10),	--�һ���˾      
@billid			varchar(20)		--�һ����� 
as      
begin 
	--�����ڲ�����
	update dproexchangeinfo set firstsalerinid=manageno		from dproexchangeinfo,staffinfo	where changecompid=@compid and changebillid=@billid and firstsalerid=staffno and compno=@compid
	update dproexchangeinfo set secondsalerinid=manageno	from dproexchangeinfo,staffinfo	where changecompid=@compid and changebillid=@billid and secondsalerid=staffno and compno=@compid
	update dproexchangeinfo set thirdsalerinid=manageno		from dproexchangeinfo,staffinfo	where changecompid=@compid and changebillid=@billid and thirdsalerid=staffno and compno=@compid
	update dproexchangeinfo set fourthsalerinid=manageno	from dproexchangeinfo,staffinfo	where changecompid=@compid and changebillid=@billid and fourthsalerid=staffno and compno=@compid
	
	declare @changecardno				varchar(20)		--�һ�����
	declare @changedate					varchar(8)		--�һ�����
	declare @changetime					varchar(9)		--�һ�ʱ��
	
	declare @changeaccount				varchar(5)		--�����˻�
	declare @changeaccountamt			float			--�����˻����
	declare @changeaccount4amt			float			--�����Ƴ��˻����
	declare @inseraccount4amt			float			--�һ��Ƴ��˻����
	
	select @changecardno=changecardno,@changedate=changedate,@changetime=changetime,@changeaccount=ISNULL(changeaccounttype,0)
	from mproexchangeinfo with(nolock) where changecompid=@compid and changebillid=@billid
	
	select @changeaccountamt=SUM(ISNULL(changebyaccountamt,0)),@changeaccount4amt=SUM(ISNULL(changebyproaccountamt,0)),@inseraccount4amt=SUM(isnull(changeproamt,0))
	from  dproexchangeinfo with(nolock) where changecompid=@compid and changebillid=@billid
	
	--�����˻����
		if(ISNULL(@changeaccountamt,0)>0)--�����˻�
		begin
			update cardaccount set accountbalance=ISNULL(accountbalance,0)-@changeaccountamt where accounttype=@changeaccount and cardno=@changecardno
		end
		if(ISNULL(@changeaccount4amt,0)>0)--�����Ƴ��˻�
		begin
			update cardaccount set accountbalance=ISNULL(accountbalance,0)-@changeaccount4amt where accounttype='4' and cardno=@changecardno
		end
		if(ISNULL(@inseraccount4amt,0)>0)--�һ��Ƴ��˻�
		begin
			update cardaccount set accountbalance=ISNULL(accountbalance,0)+@inseraccount4amt where accounttype='4' and cardno=@changecardno
		end
	--�����˻���ʷ
		declare @costaccountseqno		float
		declare @curcardamt				float
		select @costaccountseqno=MAX(changeseqno)+1 from cardaccountchangehistory where changecardno=@changecardno 
		if(ISNULL(@changeaccountamt,0)>0)--�����˻�
		begin
			select top 1 @curcardamt=(case when changetype in (0,6,7,8,9,10,11) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@changecardno  and changeaccounttype=CAST(@changeaccount as int) order by changeseqno desc 
			insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)
			values(@compid,@changecardno,CAST(@changeaccount as int),isnull(@costaccountseqno,0),12,@changeaccountamt,'DH',@billid,@changedate,@curcardamt)
			set @costaccountseqno=@costaccountseqno+1
		end
		if(ISNULL(@changeaccount4amt,0)>0)--�����Ƴ��˻�
		begin
			select top 1 @curcardamt=(case when changetype in (0,6,7,8,9,10,11) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@changecardno  and changeaccounttype=4 order by changeseqno desc 
			insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)
			values(@compid,@changecardno,4,isnull(@costaccountseqno,0),13,@changeaccount4amt,'DH',@billid,@changedate,@curcardamt)
			set @costaccountseqno=@costaccountseqno+1
		end
		if(ISNULL(@inseraccount4amt,0)>0)--�����Ƴ��˻�
		begin
			select top 1 @curcardamt=(case when changetype in (0,6,7,8,9,10,11) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@changecardno  and changeaccounttype=4 order by changeseqno desc 
			insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)
			values(@compid,@changecardno,4,isnull(@costaccountseqno,0),11,@inseraccount4amt,'DH',@billid,@changedate,@curcardamt)
			set @costaccountseqno=@costaccountseqno+1
		end
	--�����Ƴ���Ϣ
		declare @proseqno float
		select @proseqno=MAX(proseqno)+1 from cardproaccount with(nolock) where cardno=@changecardno 
		insert cardproaccount(cardvesting,cardno,projectno,proseqno,propricetype,salecount,costcount,lastcount,saleamt,costamt,lastamt,saledate,cutoffdate,proremark)
		select changecompid,@changecardno,changeproid,ISNULL(@proseqno,0)+ISNULL(changeseqno,0),4,ISNULL(changeprocount,0),0,ISNULL(changeprocount,0),
		ISNULL(changeproamt,0),0,ISNULL(changeproamt,0),@changedate,'','' 
		from dproexchangeinfo where changecompid=@compid and changebillid=@billid 
	--���ɵֿ���Ϣ	
		if(ISNULL(@changeaccount4amt,0)>0)--�����Ƴ��˻�
		begin
			update a set costcount=ISNULL(a.costcount,0)+ISNULL(b.changeprocount,0),
									  lastcount=ISNULL(a.lastcount,0)-ISNULL(b.changeprocount,0),
									  costamt=ISNULL(a.costamt,0)-ISNULL(b.changeproamt,0),
									  lastamt=ISNULL(a.lastamt,0)-ISNULL(b.changeproamt,0),
									  exchangeseqno=ISNULL(b.changeseqno,0),
									  changecompid=ISNULL(b.changecompid,''),
									  changebillid=ISNULL(b.changebillid,'')
			from cardproaccount a,dproexchangeinfobypro b
			where b.changecompid=@compid and b.changebillid=@billid and a.cardno=@changecardno and a.projectno=b.changeproid and a.proseqno=b.bproseqno
		end
	--�������ȯ״̬
	 update nointernalcardinfo set cardstate=2,usedate=@changedate
	 from nointernalcardinfo a,dproexchangeinfo b
	 where b.changecompid=@compid and b.changebillid=@billid and b.nointernalcardno=a.cardno
end 
go  


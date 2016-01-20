alter procedure upg_Confirm_CardChangeCard            
(            
	@compid   varchar(10),  --�ŵ��         
	@billid   varchar(20),  --����        
	@changedate  varchar(8),   --����        
	@oldcardno   varchar(20),  --�Ͽ���        
	@newcardno   varchar(20),  --�¿���          
	@changetype  varchar(20)   --��������� 0 �ۿ�ת�� 1 �չ�ת�� 2����ת�� 3���� 4��ʧ�� 5���� 6�Ͽ����Ͽ� 7�Ͽ����¿�        
)            
as           
begin        
	declare @saleaccountseqno  float        
	declare @curfillamt    float  --��ֵ���        
	declare @curdebtamt    float  --Ƿ����        
	declare @membername    varchar(20) --��Ա����          
	declare @membertphone   varchar(20) --��Ա�ֻ�          
	declare @oldaccfillamt   float  --ԭ���˻����        
	declare @oldaccdebtamt   float  --ԭ���˻�Ƿ����        
	declare @oldprofillamt   float  --ԭ���Ƴ��˻����        
	declare @oldprodebtamt   float  --ԭ���Ƴ��˻�Ƿ����        
	declare @prodetialseqno   float  --�Ƴ���ϸ���        
	declare @costaccountseqno   float  --�˻���ʷ���        
	declare @costaccount2lastamt float  --�˻���ʷ������        
	declare @costaccount4lastamt float  --�˻���ʷ������    
	declare @oldcardpointamt float        
	declare @SP042     varchar(2) --�Ƿ����ÿ����Ƿ���ۼ� 0:���� 1:����        
	select @SP042=paramvalue from sysparaminfo where compid=@compid and paramid='SP042'        
	select	@curfillamt=ISNULL(changefillamt,0),@curdebtamt=ISNULL(changdebtamt,0),        
			@oldaccfillamt=isnull(curaccountkeepamt,0),@oldaccdebtamt=isnull(curaccountdebtamt,0),        
			@membername=ISNULL(membername,''),@membertphone=ISNULL(memberphone,'') from  mcardchangeinfo where changecompid=@compid and changebillid=@billid        
         
	if(@changetype=5)        
	begin        
		update  cardinfo set cardstate=11 where cardno=@oldcardno  --�Ѳ���״̬        
		--�����춯��ʷ        
        
		select @saleaccountseqno=MAX(changeseqno)+1 from cardchangehistory where changecardno=@newcardno         
		insert cardchangehistory(changecompid,changecardno,changeseqno,changetype,changebillid,beforestate,afterstate,chagedate,targetcardno)        
		values(@compid,@newcardno,isnull(@saleaccountseqno,0),7,@billid,3,4,@changedate,@oldcardno)        
		select @saleaccountseqno=MAX(changeseqno)+1 from cardchangehistory where changecardno=@oldcardno         
		insert cardchangehistory(changecompid,changecardno,changeseqno,changetype,changebillid,beforestate,afterstate,chagedate,targetcardno)        
		values(@compid,@oldcardno,isnull(@saleaccountseqno,0),7,@billid,9,11,@changedate,@newcardno)        
	end        
	else if(@changetype=3)        
	begin        
		update  cardinfo set cardstate=13 where cardno=@oldcardno  --�ѻ���״̬        
		--�����춯��ʷ        
		select @saleaccountseqno=MAX(changeseqno)+1 from cardchangehistory where changecardno=@newcardno         
		insert cardchangehistory(changecompid,changecardno,changeseqno,changetype,changebillid,beforestate,afterstate,chagedate,targetcardno)        
		values(@compid,@newcardno,isnull(@saleaccountseqno,0),13,@billid,3,4,@changedate,@oldcardno)        
		select @saleaccountseqno=MAX(changeseqno)+1 from cardchangehistory where changecardno=@oldcardno         
		insert cardchangehistory(changecompid,changecardno,changeseqno,changetype,changebillid,beforestate,afterstate,chagedate,targetcardno)        
		values(@compid,@oldcardno,isnull(@saleaccountseqno,0),13,@billid,9,13,@changedate,@newcardno)        
	end        
	else if(@changetype in (0,1))        
	begin        
		update  cardinfo set cardstate=6 where cardno=@oldcardno   --��ת��״̬        
		--�����춯��ʷ        
		select @saleaccountseqno=MAX(changeseqno)+1 from cardchangehistory where changecardno=@newcardno         
		insert cardchangehistory(changecompid,changecardno,changeseqno,changetype,changebillid,beforestate,afterstate,chagedate,targetcardno)        
		values(@compid,@newcardno,isnull(@saleaccountseqno,0),11,@billid,1,4,@changedate,@oldcardno)        
		select @saleaccountseqno=MAX(changeseqno)+1 from cardchangehistory where changecardno=@oldcardno         
		insert cardchangehistory(changecompid,changecardno,changeseqno,changetype,changebillid,beforestate,afterstate,chagedate,targetcardno)        
		values(@compid,@oldcardno,isnull(@saleaccountseqno,0),11,@billid,4,6,@changedate,@newcardno)        
	end      
	else if(@changetype=8)        
	begin        
		update mcardchangeinfo set firstsalerinid=manageno from mcardchangeinfo,staffinfo where changecompid=@compid and changebillid=@billid and firstsalerid=staffno and compno=@compid        
		update mcardchangeinfo set secondsalerinid=manageno from mcardchangeinfo,staffinfo where changecompid=@compid and changebillid=@billid and secondsalerid=staffno and compno=@compid        
		update mcardchangeinfo set thirdsalerinid=manageno from mcardchangeinfo,staffinfo where changecompid=@compid and changebillid=@billid and thirdsalerid=staffno and compno=@compid        
		update mcardchangeinfo set fourthsalerinid=manageno from mcardchangeinfo,staffinfo where changecompid=@compid and changebillid=@billid and fourthsalerid=staffno and compno=@compid        
		update mcardchangeinfo set fifthsalerinid=manageno from mcardchangeinfo,staffinfo where changecompid=@compid and changebillid=@billid and fifthsalerid=staffno and compno=@compid        
		update mcardchangeinfo set sixthsalerinid=manageno from mcardchangeinfo,staffinfo where changecompid=@compid and changebillid=@billid and sixthsalerid=staffno and compno=@compid        
		update mcardchangeinfo set seventhsalerinid=manageno from mcardchangeinfo,staffinfo where changecompid=@compid and changebillid=@billid and seventhsalerid=staffno and compno=@compid        
		update mcardchangeinfo set eighthsalerinid=manageno from mcardchangeinfo,staffinfo where changecompid=@compid and changebillid=@billid and eighthsalerid=staffno and compno=@compid        
         
         
		update  cardinfo set cardstate=7 where cardno=@oldcardno   --���˿�״̬        
		--�����춯��ʷ        
		select @saleaccountseqno=MAX(changeseqno)+1 from cardchangehistory where changecardno=@oldcardno         
		insert cardchangehistory(changecompid,changecardno,changeseqno,changetype,changebillid,beforestate,afterstate,chagedate,targetcardno)        
		values(@compid,@oldcardno,isnull(@saleaccountseqno,0),8,@billid,4,7,@changedate,'')        
          
		--����˻�        
		update   cardaccount set accountbalance=0,accountdebts=0 where cardno=@oldcardno         
		--�����˻���ʷ        
		select @costaccountseqno=MAX(changeseqno)+1 from cardaccountchangehistory where changecardno=@oldcardno         
		select top 1 @costaccount2lastamt=(case when changetype in (0,6,7,8,9,10) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@oldcardno  and changeaccounttype=2 order by chagedate desc,changeseqno desc         
		select top 1 @costaccount4lastamt=(case when changetype in (0,6,7,8,9,10,11) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@oldcardno  and changeaccounttype=4 order by chagedate desc,changeseqno desc         
          
		insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)        
		values(@compid,@oldcardno,2,isnull(@costaccountseqno,0),1,@oldaccfillamt,'TK',@billid,@changedate,@costaccount2lastamt)        
		set @costaccountseqno=isnull(@costaccountseqno,0)+1        
		insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)        
		values(@compid,@oldcardno,4,isnull(@costaccountseqno,0),1,@oldprofillamt,'TK',@billid,@changedate,@costaccount4lastamt)        
		--����Ƴ���ϸ        
		update  cardproaccount set lastcount=0,lastamt=0 where cardno=@oldcardno        
           
	end        
	if(@changetype in (0,1,2,3,5,6,7))        
	begin         
		update mcardchangeinfo set firstsalerinid=manageno from mcardchangeinfo,staffinfo where changecompid=@compid and changebillid=@billid and firstsalerid=staffno and compno=@compid        
		update mcardchangeinfo set secondsalerinid=manageno from mcardchangeinfo,staffinfo where changecompid=@compid and changebillid=@billid and secondsalerid=staffno and compno=@compid        
		update mcardchangeinfo set thirdsalerinid=manageno from mcardchangeinfo,staffinfo where changecompid=@compid and changebillid=@billid and thirdsalerid=staffno and compno=@compid        
		update mcardchangeinfo set fourthsalerinid=manageno from mcardchangeinfo,staffinfo where changecompid=@compid and changebillid=@billid and fourthsalerid=staffno and compno=@compid        
		update mcardchangeinfo set fifthsalerinid=manageno from mcardchangeinfo,staffinfo where changecompid=@compid and changebillid=@billid and fifthsalerid=staffno and compno=@compid        
		update mcardchangeinfo set sixthsalerinid=manageno from mcardchangeinfo,staffinfo where changecompid=@compid and changebillid=@billid and sixthsalerid=staffno and compno=@compid        
		update mcardchangeinfo set seventhsalerinid=manageno from mcardchangeinfo,staffinfo where changecompid=@compid and changebillid=@billid and seventhsalerid=staffno and compno=@compid        
		update mcardchangeinfo set eighthsalerinid=manageno from mcardchangeinfo,staffinfo where changecompid=@compid and changebillid=@billid and eighthsalerid=staffno and compno=@compid        
         
		if(@changetype in (0,1,2,3,5))  --ת���������� �������Ϣ        
		begin        
			update  cardinfo set cardstate=4 where cardno=@newcardno  --��������״̬        
			update cardsoninfo set parentcardno=@newcardno where parentcardno=@oldcardno        
			if(@changetype=2) --����ת��        
			begin        
				--�����¿���ֵ�˻�        
				if not exists(select 1 from cardaccount where   cardno = @newcardno and accounttype=2)              
				begin              
					insert into cardaccount(cardvesting,cardno,accounttype,accountbalance,accountdebts)               
					values(@compid,@newcardno,2,ISNULL(@oldaccfillamt,0)+ISNULL(@curfillamt,0),ISNULL(@oldaccdebtamt,0))              
				end            
				else        
				begin        
					update cardaccount set accountbalance=ISNULL(accountbalance,0)+ISNULL(@oldaccfillamt,0)+ISNULL(@curfillamt,0),accountdebts=ISNULL(accountdebts,0)+ISNULL(@oldaccdebtamt,0) where cardno=@newcardno and accounttype=2        
				end        
           
				insert memberinfo(membervesting,memberno,membername,membertphone,cardnotomemberno)        
				values( @compid,@newcardno,@membername,@membertphone,@newcardno)        
				if(ISNULL(@oldaccfillamt,0)>0) --��ֵ�˻�        
				begin        
					--�����˻���ʷ        
					select @costaccountseqno=MAX(changeseqno)+1 from cardaccountchangehistory where changecardno=@newcardno         
					select top 1 @costaccount2lastamt=(case when changetype in (0,6,7,8,9,10) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@newcardno  and changeaccounttype=2 order by chagedate desc,changeseqno desc         
					insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)        
					values(@compid,@newcardno,2,isnull(@costaccountseqno,0),ISNULL(@changetype,0)+7,ISNULL(@oldaccfillamt,0)+ISNULL(@curfillamt,0),'ZK',@billid,@changedate,@costaccount2lastamt)        
					set @costaccountseqno=@costaccountseqno+1        
				end        
			end        
			else        
			begin        
				if(@changetype=1) --�չ�ת��        
				begin        
					delete cardaccount where  cardno=@oldcardno and accounttype=2        
					update cardaccount set accounttype=2 where cardno=@oldcardno and accounttype=5   
				end        
				delete memberinfo where memberno=@newcardno        
				update memberinfo set memberno=@newcardno,cardnotomemberno=@newcardno where memberno=@oldcardno        
				delete cardaccount where cardno=@newcardno        
				update cardaccount set cardno=@newcardno where cardno=@oldcardno        
				update cardaccount set accountbalance=ISNULL(accountbalance,0)+ISNULL(@curfillamt,0),accountdebts=ISNULL(accountdebts,0)+ISNULL(@curdebtamt,0) where cardno=@newcardno and accounttype=2        
				update cardproaccount set cardno=@newcardno where cardno=@oldcardno        
				update cardaccountchangehistory set changecardno=@newcardno where changecardno=@oldcardno        
				update cardtransactionhistory set transactioncardno=@newcardno where transactioncardno=@oldcardno        
           
				if(ISNULL(@curfillamt,0)>0) --��ֵ�˻�        
				begin    
					    
					--�����˻���ʷ        
					select @costaccountseqno=MAX(changeseqno)+1 from cardaccountchangehistory where changecardno=@newcardno         
					select top 1 @costaccount2lastamt=(case when changetype in (0,6,7,8,9,10) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@newcardno  and changeaccounttype=2 order by chagedate desc,changeseqno desc         
					if(@changetype=1)        
						set @costaccount2lastamt=ISNULL(@oldaccfillamt,0)        
					insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)        
					values(@compid,@newcardno,2,isnull(@costaccountseqno,0),ISNULL(@changetype,0)+7,@curfillamt,'ZK',@billid,@changedate,@costaccount2lastamt)        
					set @costaccountseqno=isnull(@costaccountseqno,0)+1        
				end  
				if(@changetype=5) --��ʧ���� ��ȡ10��������
				begin
					if(ISNULL(@oldaccfillamt,0)>10)
					begin
					    update cardaccount set accountbalance=ISNULL(accountbalance,0)-10 where cardno=@newcardno and accounttype=2        
						select @costaccountseqno=MAX(changeseqno)+1 from cardaccountchangehistory where changecardno=@newcardno  
						set @costaccountseqno=isnull(@costaccountseqno,0)+1  
						insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)        
						values(@compid,@newcardno,2,isnull(@costaccountseqno,0),1,10,'ZK',@billid,@changedate,ISNULL(@oldaccfillamt,0))        
					
					end
				end 
				select @oldcardpointamt =SUM(isnull(accountbalance,0)) from cardaccount,mcardchangeinfo where changecompid=@compid and changebillid=@billid  and cardno=changebeforcardno  and accounttype=3      
				if(ISNULL(@oldcardpointamt,0)<>0 )        
				begin        
					--�����¿������˻�        
					if not exists(select 1 from cardaccount where   cardno = @newcardno and accounttype=3)              
					begin              
						insert into cardaccount(cardvesting,cardno,accounttype,accountbalance,accountdebts)               
						values(@compid,@newcardno,3,ISNULL(@oldcardpointamt,0),0)              
					end            
					else        
					begin        
						update cardaccount set accountbalance=ISNULL(accountbalance,0)+ISNULL(@oldcardpointamt,0) where cardno=@newcardno and accounttype=3        
					end        
				end       
			end        
		end        
		else if(@changetype in (6,7))          
		begin        
			if(@changetype =6)--�Ͽ����Ͽ� @oldcardno ΪĿ�꿨        
			begin        
				update  cardinfo set cardstate=12 from dcardchangeinfo,cardinfo where cardno=oldcardno and changecompid=@compid and changebillid=@billid  --�Ѳ���״̬        
				--�����춯��ʷ        
				select @saleaccountseqno=MAX(changeseqno)+1 from cardchangehistory where changecardno=@oldcardno        
				insert cardchangehistory(changecompid,changecardno,changeseqno,changetype,changebillid,beforestate,afterstate,chagedate,targetcardno)        
				select @compid,oldcardno,99,12,@billid,4,12,@changedate,@oldcardno from dcardchangeinfo where changecompid=@compid and changebillid=@billid  --�Ѳ���״̬        
				insert cardchangehistory(changecompid,changecardno,changeseqno,changetype,changebillid,beforestate,afterstate,chagedate,targetcardno)        
				select @compid,@oldcardno ,isnull(@saleaccountseqno,0)+(row_number() over(order by oldcardno desc)),12,@billid,4,12,@changedate,oldcardno from dcardchangeinfo where changecompid=@compid and changebillid=@billid  --�Ѳ���״̬        
        
			end        
			else if(@changetype =7)--�Ͽ����¿� @oldcardno ΪĿ�꿨        
			begin        
				update  cardinfo set cardstate=12 from dcardchangeinfo,cardinfo where cardno=oldcardno and changecompid=@compid and changebillid=@billid  --�Ѳ���״̬        
				update  cardinfo set cardstate=4 where cardno=@oldcardno  --��������״̬        
				--�����춯��ʷ        
				select @saleaccountseqno=MAX(changeseqno)+1 from cardchangehistory where changecardno=@oldcardno         
				insert cardchangehistory(changecompid,changecardno,changeseqno,changetype,changebillid,beforestate,afterstate,chagedate,targetcardno)        
				values(@compid,@oldcardno,isnull(@saleaccountseqno,0),12,@billid,1,4,@changedate,'')        
				insert cardchangehistory(changecompid,changecardno,changeseqno,changetype,changebillid,beforestate,afterstate,chagedate,targetcardno)        
				select @compid,oldcardno,99,12,@billid,4,12,@changedate,@oldcardno from dcardchangeinfo where changecompid=@compid and changebillid=@billid  --�Ѳ���״̬        
				--�����¿���������
				insert memberinfo(membervesting,memberno,membercreatedate,membername,membermphone,membersex,memberpaperworkno,memberbirthday,cardnotomemberno)
				select @compid,@oldcardno,@changedate,membername,membermphone,membersex,memberpaperworkno,memberbirthday,@oldcardno
				from memberinfo where memberno in ( select top 1 oldcardno from dcardchangeinfo where  changecompid=@compid and changebillid=@billid )
				
			end        
			--��ֵ���+�Ͽ��б�ԭ�ж��        
			select @curfillamt=ISNULL(@curfillamt,0)+SUM(ISNULL(curaccountkeepamt,0)) from  dcardchangeinfo where changecompid=@compid and changebillid=@billid         
			--��ֵǷ��  / �Ͽ��б�ԭ��Ƿ�� @SP042        
			if(ISNULL(@SP042,'0')='0') --���ۼ�Ƿ��        
			begin        
				select @curdebtamt=ISNULL(@curdebtamt,0)+SUM(ISNULL(curaccountdebtamt,0)) from  dcardchangeinfo where changecompid=@compid and changebillid=@billid         
			end        
			--�Ͽ��б��Ƴ��˻�Ƿ��        
			select @oldprofillamt=SUM(ISNULL(proaccountkeepamt,0)) from  dcardchangeinfo where changecompid=@compid and changebillid=@billid         
			select @oldprodebtamt=SUM(ISNULL(proaccountdebtamt,0)) from  dcardchangeinfo where changecompid=@compid and changebillid=@billid         
      
         
			select @oldcardpointamt =SUM(isnull(accountbalance,0)) from cardaccount,dcardchangeinfo where changecompid=@compid and changebillid=@billid  and cardno=oldcardno  and accounttype=3      
			----------------------------------------�����˻� Start-----------------------------------------------        
			--����Ͽ��˻�        
			update cardaccount set accountbalance=0,accountdebts=0 from cardaccount,dcardchangeinfo where changecompid=@compid and changebillid=@billid  and cardno=oldcardno        
			--�����¿���ֵ�˻�        
			if not exists(select 1 from cardaccount where   cardno = @oldcardno and accounttype=2)              
			begin              
					insert into cardaccount(cardvesting,cardno,accounttype,accountbalance,accountdebts)               
					values(@compid,@oldcardno,2,ISNULL(@curfillamt,0),ISNULL(@curdebtamt,0))              
			end            
			else        
			begin        
				update cardaccount set accountbalance=ISNULL(accountbalance,0)+ISNULL(@curfillamt,0),accountdebts=ISNULL(accountdebts,0)+ISNULL(@curdebtamt,0) where cardno=@oldcardno and accounttype=2        
			end        
			if(ISNULL(@oldprofillamt,0)<>0 or ISNULL(@oldprodebtamt,0)<>0)        
			begin        
				--�����¿��Ƴ��˻�        
				if not exists(select 1 from cardaccount where   cardno = @oldcardno and accounttype=4)              
				begin              
					insert into cardaccount(cardvesting,cardno,accounttype,accountbalance,accountdebts)               
					values(@compid,@oldcardno,4,ISNULL(@oldprofillamt,0),ISNULL(@oldprodebtamt,0))              
				end            
				else        
				begin        
					update cardaccount set accountbalance=ISNULL(accountbalance,0)+ISNULL(@oldprofillamt,0),accountdebts=ISNULL(accountdebts,0)+ISNULL(@oldprodebtamt,0) where cardno=@oldcardno and accounttype=4        
				end        
			end        
         
			if(ISNULL(@oldcardpointamt,0)<>0 )        
			begin        
				--�����¿������˻�        
				if not exists(select 1 from cardaccount where   cardno = @oldcardno and accounttype=3)              
				begin              
					insert into cardaccount(cardvesting,cardno,accounttype,accountbalance,accountdebts)               
					values(@compid,@oldcardno,3,ISNULL(@oldcardpointamt,0),0)              
				end            
				else        
				begin        
					update cardaccount set accountbalance=ISNULL(accountbalance,0)+ISNULL(@oldcardpointamt,0) where cardno=@oldcardno and accounttype=3        
				end        
			end       
			----------------------------------------�����˻� end-----------------------------------------------        
			select @costaccountseqno=MAX(changeseqno)+1 from cardaccountchangehistory where changecardno=@oldcardno         
			----------------------------------------�����˻���ʷ Start-----------------------------------------------   
			if(ISNULL(@curfillamt,0)>0) --��ֵ�˻�        
			begin        
				--�����˻���ʷ        
				select top 1 @costaccount2lastamt=(case when changetype in (0,6,7,8,9,10) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@oldcardno  and changeaccounttype=2 order by chagedate desc,changeseqno desc         
				insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)        
				values(@compid,@oldcardno,2,isnull(@costaccountseqno,0),10,@curfillamt,'ZK',@billid,@changedate,@costaccount2lastamt)        
				set @costaccountseqno=isnull(@costaccountseqno,0)+1        
			end        
			if(ISNULL(@oldprofillamt,0)>0) --�Ƴ��˻�        
			begin        
				 select top 1 @costaccount2lastamt=(case when changetype in (0,6,7,8,9,10,11) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@oldcardno  and changeaccounttype=4 order by chagedate desc,changeseqno desc         
				insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)        
				values(@compid,@oldcardno,4,isnull(@costaccountseqno,0),10,@oldprofillamt,'ZK',@billid,@changedate,@costaccount2lastamt)        
				set @costaccountseqno=isnull(@costaccountseqno,0)+1        
			end        
			----------------------------------------�����˻���ʷ end-----------------------------------------------        
			----------------------------------------�ϲ��Ƴ���ϸ Start---------------------------------------------        
			select @prodetialseqno=MAX(proseqno) from cardproaccount where cardno=@oldcardno        
			insert cardproaccount(cardvesting,cardno,projectno,proseqno,propricetype,salecount,costcount,lastcount,saleamt,costamt,lastamt,saledate,cutoffdate,proremark,prostopeflag,exchangeseqno)        
			select cardvesting,@oldcardno,projectno,isnull(@prodetialseqno,0)+1+row_number() over(order by proseqno desc),propricetype,salecount,costcount,lastcount,saleamt,costamt,lastamt,saledate,cutoffdate,proremark,prostopeflag,exchangeseqno       
			from cardproaccount a,dcardchangeinfo b where b.changecompid=@compid and b.changebillid=@billid  and cardno=oldcardno        
			delete a from cardproaccount a,dcardchangeinfo b where b.changecompid=@compid and b.changebillid=@billid  and cardno=oldcardno        
			----------------------------------------�ϲ��Ƴ���ϸ end-----------------------------------------------        
			----------------------------------------�ϲ�������ϸ Start---------------------------------------------        
			update cardtransactionhistory set transactioncardno=@oldcardno        
			from cardtransactionhistory a,dcardchangeinfo b where b.changecompid=@compid and b.changebillid=@billid  and transactioncardno=oldcardno        
           
			----------------------------------------�ϲ�������ϸ end---------------------------------------------        
		end   
	 end        
end 
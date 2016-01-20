-------��Ա���䷢
if exists(select 1 from sysobjects where type='P' and name='upg_handle_card_allot')
	drop procedure upg_handle_card_allot
go
create procedure upg_handle_card_allot    
(    
 @compid varchar(10), --���ݹ�˾    
 @billid varchar(20) --���õ��ݱ��    
)    
as    
begin    
    
	create table #dcardallotment   
	(    
		cardclass varchar(10) null, --������    
		cardfrom  varchar(20) null, --����ʼ���    
		cardto   varchar(20)   null, --���������    
		storage   varchar(10) null, --�ֿ���    
		compid   varchar(10) null, --��˾���    
	)    
     
	insert into #dcardallotment(cardclass,cardfrom,cardto,storage,compid)    
	select cardtypeid,cardnofrom,cardnoto,callotwareid,a.callotcompid    
	  from mcardallotment a,dcardallotment b   
	 where a.callotcompid=@compid and a.callotbillid=@billid    
	   and a.callotcompid = b.callotcompid and a.callotbillid = b.callotbillid  and isnull(cardtypeid,'')<>'' and isnull(cardnofrom,'')<>''    
     
  declare @varCardClass varchar(10)     
  declare @varCardFrom varchar(20)     
  declare @varCardTo varchar(20)     
  declare @varStorage varchar(10)    
  declare @varCompid varchar(10)    
  declare @cardlength int     
  declare @filterNum varchar(10)    
     
  select @cardlength = cast(paramvalue as int) from sysparaminfo where compid=@compid and paramid='SP019'    
  select @filterNum = isnull(paramvalue,'')  from sysparaminfo where compid=@compid and paramid='SP020'    
     
  declare cur_dcardallotment cursor for    
  select cardclass,cardfrom,cardto,storage,compid  from #dcardallotment   
  open cur_dcardallotment     
  fetch cur_dcardallotment into @varCardClass,@varCardFrom,@varCardTo,@varStorage,@varCompid    
  while @@fetch_status=0    
  begin    
		declare @rangeStart varchar(20)    
		declare @rangeEnd varchar(20)    
		declare @leftRangeCount int    
		declare @rightRangeCount int    
      
		set @leftRangeCount=0    
		set @rightRangeCount=0    
		--��������£�������ֿ��ŷ�Χ���ֽ�������;Ԥ����һ��ȡtop 1    
		select top 1 @rangeStart=cardfrom,@rangeEnd=cardto    
		from cardstock    
		where cardclass = @varCardClass and storage = @varStorage and compid = @varCompid    
			and substring(cardfrom,1,len(cardfrom)-@cardlength) = substring(@varCardFrom,1,len(@varCardFrom)-@cardlength)    
			and substring(@varCardFrom,len(@varCardFrom)-@cardlength+1,@cardlength)>=substring(cardfrom,len(cardfrom)-@cardlength+1,@cardlength)    
			and substring(@varCardTo,len(@varCardTo)-@cardlength+1,@cardlength)<=substring(cardto,len(cardto)-@cardlength+1,@cardlength)    
        
		if(@rangeStart <> @varCardFrom)    
		begin    
			declare @leftStartNum int    
			declare @leftEndNum int    
			select @leftEndNum = cast(substring(@varCardFrom,len(@varCardFrom)-@cardlength+1,@cardlength) as int)    
			select @leftStartNum = cast(substring(@rangeStart,len(@rangeStart)-@cardlength+1,@cardlength) as int)    
			if(isnull(@filterNum,'')='')    
			begin    
				set @leftRangeCount = @leftEndNum-@leftStartNum    
			end    
			else    
			begin    
				declare @leftTempNum  int     
				select @leftTempNum = @leftStartNum    
				while(@leftTempNum<@leftEndNum)    
				begin    
					if(substring(cast(@leftTempNum as varchar),len(cast(@leftTempNum as varchar)),1)!=@filterNum)    
						set @leftRangeCount = @leftRangeCount + 1    
					set @leftTempNum = @leftTempNum + 1    
				end    
			end    
		end    
		if(@rangeEnd <> @varCardTo)    
		begin    
			declare @rightStartNum int    
			declare @rightEndNum int    
			select @rightEndNum = cast(substring(@rangeEnd,len(@rangeEnd)-@cardlength+1,@cardlength) as int)    
			select @rightStartNum = cast(substring(@varCardTo,len(@varCardTo)-@cardlength+1,@cardlength) as int)    
			if(isnull(@filterNum,'')='')    
			begin    
				set @rightRangeCount = @rightEndNum-@rightStartNum    
			end    
			else    
			begin    
				declare @rightTempNum  int     
				select @rightTempNum = @rightStartNum    
				while(@rightTempNum<@rightEndNum)    
				begin    
					if(substring(cast(@rightTempNum as varchar),len(cast(@rightTempNum as varchar)),1)!=@filterNum)    
						set @rightRangeCount = @rightRangeCount + 1    
					set @rightTempNum = @rightTempNum + 1    
				end    
			end    
		end    
       
		declare @cardPrefix varchar(20)    
		set @cardPrefix = substring(@varCardFrom,1,len(@varCardFrom)-@cardlength)    
     
  
  
		if(@leftRangeCount != 0)    
		begin    
			declare @cardSuffix varchar(20)    
			set @cardSuffix = cast(cast(substring(@varCardFrom,len(@cardPrefix)+1,@cardlength) as int)-1 as varchar)    
        
			if(substring(@cardSuffix,len(@cardSuffix),1)=@filterNum )    
			set @cardSuffix = cast(substring(@varCardFrom,len(@cardPrefix)+1,@cardlength) as int)-2    
  
  
			--  ��0------------------  
			declare @cardSuffixLen int   
			set @cardSuffixLen=len(@cardSuffix)   
			if(@cardSuffixLen<@cardlength)  
			begin  
				while(@cardlength-@cardSuffixLen>0)  
				begin  
					set @cardSuffix='0'+@cardSuffix  
					set @cardSuffixLen=@cardSuffixLen+1  
				end  
			end  
			-----------------------------------      
			declare @leftRangeEndX varchar(20)    
			set @leftRangeEndX = @cardPrefix+@cardSuffix    
     
			insert into cardstock(cardclass,cardfrom,cardto,ccount,storage,compid)    
			values(@varCardClass,@rangeStart,@leftRangeEndX,@leftRangeCount,@varStorage,@varCompid)    
		end    
         
		if(@rightRangeCount !=0)    
		begin    
			declare @cardSuffix2 varchar(20)    
			set @cardSuffix2 = cast(cast(substring(@varCardTo,len(@cardPrefix)+1,@cardlength) as int)+1 as varchar)    
        
			if(substring(@cardSuffix2,len(@cardSuffix2),1)=@filterNum )    
			set @cardSuffix2 = cast(substring(@varCardTo,len(@cardPrefix)+1,@cardlength) as int)+2    
        
  
			-- ��0------------------  
			declare @cardSuffix2Len int   
			set @cardSuffix2Len=len(@cardSuffix2)   
			if(@cardSuffix2Len<@cardlength)  
			begin  
				 while(@cardlength-@cardSuffix2Len>0)  
				 begin  
					set @cardSuffix2='0'+@cardSuffix2  
					set @cardSuffix2Len=@cardSuffix2Len+1  
			end  
		end  
		-----------------------------------  
  
		declare @rightRangeStartX varchar(20)    
		set @rightRangeStartX = @cardPrefix+@cardSuffix2    
		insert into cardstock(cardclass,cardfrom,cardto,ccount,storage,compid)    
		values(@varCardClass,@rightRangeStartX,@rangeEnd,@rightRangeCount,@varStorage,@varCompid)    
	end    
       
	delete cardstock 	where cardclass=@varCardClass and cardfrom=@rangeStart and cardto=@rangeEnd    
     
  fetch cur_dcardallotment into @varCardClass,@varCardFrom,@varCardTo,@varStorage,@varCompid    
  end    
  close cur_dcardallotment    
  deallocate cur_dcardallotment    
      
  drop table #dcardallotment     
end  

go

-------��Ա���䷢������ʼ��
if exists(select 1 from sysobjects where type='P' and name='upg_allotcard_createcardno')
	drop procedure upg_allotcard_createcardno
go
create procedure upg_allotcard_createcardno    
@compid  varchar(10), ---��¼��˾      
@sendid  varchar(10), --���빫˾       
@billno  varchar(20)      
as      
begin      
 declare @cardclass  varchar(10)---�����      
 declare @cardfromno varchar(20) --�����뿪ʼ����      
 declare @cardtono varchar(20) --�������������      
 declare @cardcount float     --������      
 declare @cardno     varchar(20) --insert ��gcm01�еĿ���          
 
 declare @cardlength  int      
 declare @filterNum varchar(10)   
 
 select @cardlength = cast(paramvalue as int) from sysparaminfo where compid=@compid and paramid='SP019'    
 select @filterNum = isnull(paramvalue,'')  from sysparaminfo where compid=@compid and paramid='SP020'   
       
   
 declare cursor_allot cursor for      
 select cardtypeid,cardnofrom,cardnoto,ccount from dcardallotment  where callotcompid=@compid and callotbillid=@billno      
 open cursor_allot      
 fetch cursor_allot into @cardclass,@cardfromno,@cardtono,@cardcount      
 while @@fetch_status=0      
 begin      
		set @cardno = @cardfromno      
		declare @cardseq int      
		declare @cardbefore varchar(20)--����ǰ����      
		declare @cardafter varchar(20) --���ĺ󲿷�      
		while(@cardno <= @cardtono)      
		begin      
		if((substring(@cardno,len(@cardno),1))=isnull(@filterNum,''))      
		begin      
			set @cardseq = substring(@cardno,(len(@cardno)-@cardlength+1),@cardlength)      
			set @cardbefore = substring(@cardno,1,len(@cardno)-@cardlength)      
			set @cardseq = @cardseq+1      
			set @cardafter = cast(@cardseq as varchar(20))      
			while(len( cast(@cardafter as varchar(20)))<@cardlength)      
			begin      
				set @cardafter = '0'+@cardafter      
			end      
			set @cardno = @cardbefore+@cardafter      
			continue;      
		end      
		else      
		begin      
			if not exists(select 1 from cardinfo where cardno = @cardno)      
			begin      
				insert into cardinfo (cardvesting,cardno,cardtype,cardstate,cardsource)      
				values(@sendid,@cardno,@cardclass,1,0)      
				declare @operationdate varchar(8)  
				declare @operationtime varchar(6)  
				select @operationdate = substring(convert(varchar(20),getdate(),102),1,4) + substring(convert(varchar(20),getdate(),102),6,2)+  
						substring(convert(varchar(20),getdate(),102),9,2)  
				set @operationtime = substring(convert(varchar(40),getdate(),120),12,2)+ substring(convert(varchar(40),getdate(),120),15,2)  
				insert into sysoperationlog(userid,program,operation,operationdate,operationtime,origatedate,compid,keyvalue1,keyvalue2, keyvalue3,keyvalue4)      
				values('','CC003','A',@operationdate,@operationtime,@operationdate,@sendid,@cardno,@cardclass,@billno,'��Ա���䷢' )     
			end      
			if not exists(select 1 from cardaccount where   cardno = @cardno)      
			begin      
				insert into cardaccount(cardvesting,cardno,accounttype,accountbalance)       
				values(@sendid,@cardno,2,0)      
			end      
			set @cardseq = substring(@cardno,(len(@cardno)-@cardlength+1),@cardlength)      
			set @cardbefore = substring(@cardno,1,len(@cardno)-@cardlength)      
			set @cardseq = @cardseq+1      
			set @cardafter = cast(@cardseq as varchar(20))      
			while(len( cast(@cardafter as varchar(20)))<@cardlength)      
			begin      
				set @cardafter = '0'+@cardafter      
			end      
			set @cardno = @cardbefore+@cardafter      
		end      
  end      
  fetch cursor_allot into  @cardclass,@cardfromno,@cardtono,@cardcount      
  end      
 close cursor_allot      
 deallocate cursor_allot      
end  

go

-------��Ա��δ���ۿ��Ǽ�
if exists(select 1 from sysobjects where type='P' and name='upg_amn_createcardno')
	drop procedure upg_amn_createcardno
go
CREATE procedure upg_amn_createcardno 
(       
	@compid  varchar(10), ---��¼��˾        
	@cardfromno varchar(20), --��ʼ����        
	@cardtono  varchar(20) ,--��������      
	@cardclass varchar(10)  ---�����       
)  
as        
begin        
	declare @cardcount float     --������        
	declare @cardno     varchar(20) --insert ��gcm01�еĿ���        
 
	declare @cardlength	int        
	declare @filterNum		varchar(10)     
	declare @temp varchar(20)      
      
	if(@cardfromno>@cardtono or len(isnull(@cardfromno,''))<>len(isnull(@cardtono,'')))      
	begin    
		return    
	end     
	declare @count int    
	set @count = 0;   
  
	select @cardlength = cast(paramvalue as int) from sysparaminfo where compid=@compid and paramid='SP019'    
	select @filterNum = isnull(paramvalue,'')  from sysparaminfo where compid=@compid and paramid='SP020'    
       
	set @cardno = @cardfromno        
	declare @cardseq int        
    
	declare @cardbefore varchar(20)--����ǰ����        
	declare @cardafter varchar(20) --���ĺ󲿷�        
	while((@cardno <= @cardtono) and len(@cardno)=len(@cardtono) and @count<200)        
	begin        
		set @count  = @count+1    
      
		if((substring(@cardno,len(@cardno),1))=isnull(@filterNum,''))        
		begin        
			set @cardseq = cast(substring(@cardno,(len(@cardno)-@cardlength+1),@cardlength) as int)        
			set @cardbefore = substring(@cardno,1,len(@cardno)-@cardlength)        
			set @cardseq = @cardseq+1        
			set @cardafter = cast(@cardseq as varchar(20))        
			while(len(@cardafter)<@cardlength)        
			begin        
				set @cardafter = '0'+@cardafter        
			end        
			set @cardno = @cardbefore+@cardafter        
			continue;        
		end        
		else        
		begin    
			if not exists(select 1 from cardinfo where cardno = @cardno )        
			begin        
				insert into cardinfo (cardvesting,cardno,cardtype,cardstate,cardsource)      
				values(@compid,@cardno,@cardclass,1,0)         
				declare @operationdate varchar(8)  
				declare @operationtime varchar(6)  
				select @operationdate = substring(convert(varchar(20),getdate(),102),1,4) + substring(convert(varchar(20),getdate(),102),6,2)+substring(convert(varchar(20),getdate(),102),9,2)  
				set @operationtime = substring(convert(varchar(40),getdate(),120),12,2)+ substring(convert(varchar(40),getdate(),120),15,2)  
				insert into sysoperationlog(userid,program,operation,operationdate,operationtime,origatedate,compid,keyvalue1,keyvalue2, keyvalue3,keyvalue4)      
				values('','AC006','A',@operationdate,@operationtime,@operationdate,@compid,@cardno,@cardclass,'','δ���ۿ��Ǽ�' )   
			end        
			if not exists(select 1 from cardaccount where   cardno = @cardno)      
			begin      
				insert into cardaccount(cardvesting,cardno,accounttype,accountbalance)       
				values(@compid,@cardno,2,0)      
			end         
			set @cardseq = cast(substring(@cardno,(len(@cardno)-@cardlength+1),@cardlength) as int)        
			set @cardbefore = substring(@cardno,1,len(@cardno)-@cardlength)        
			set @cardseq = @cardseq+1        
			set @cardafter = cast(@cardseq as varchar(20))        
			while(len(@cardafter)<@cardlength)        
			begin        
					set @cardafter = '0'+@cardafter        
			end      
			if(len(@cardafter)=@cardlength)  
			begin    
				set @cardno = @cardbefore+@cardafter  
			end        
		end        
	end        
end  

go
-------���ڲ����Ǽ�
if exists(select 1 from sysobjects where type='P' and name='upg_amn_createcardno_quan')
	drop procedure upg_amn_createcardno_quan
go
create procedure upg_amn_createcardno_quan           
(               
	@compid  varchar(10), ---��¼��˾                
	@cardfromno varchar(20), --��ʼ����                
	@cardtono  varchar(20) ,--��������              
	@cardclass  int , ---�����               
	@carduseclass int  ,---�����          
	@facePrice  float, --��ֵ        
	@cardBef  varchar(10),--��ǰ׺        
	@contion  varchar(600),    
	@sendate varchar(10), --��Ч�� 
	@enabledate varchar(10), --��������
	@outercardtype	int	   --1 ���뿨 2 ����ȯ    

)          
as                
begin                
	declare @cardcount float     --������                
	declare @cardno     varchar(20) --insert ��gcm01�еĿ���          
	set     @cardno=@cardfromno   
            
	if(@cardfromno>@cardtono or len(isnull(@cardfromno,''))<>len(isnull(@cardtono,'')))              
	begin            
		return            
	end          
    declare @sql nvarchar(600)  
	declare @count int            
	set @count = 0; 
	declare @targcardno varchar(20)        
    
    if(@outercardtype=2)  
    begin     
		while((@cardno <= @cardtono) and len(@cardno)=len(@cardtono) and @count<6000)                
		begin               
			
			set @targcardno=@cardBef+@cardno        
			insert nointernalcardinfo(cardvesting,cardno,cardtype,cardstate,carduseflag,cardfaceamt,entrytype,oldvalidate,lastvalidate,enabledate)        
			values( @compid,@targcardno,@cardclass,1,@carduseclass,@facePrice,0,@sendate,@sendate,@enabledate)       
			if(@carduseclass=1 and ISNULL(@contion,'')<>'')
			begin 
				--������Ŀ��ϸ
				set @sql=' insert dnointernalcardinfo(cardvesting,cardno,seqno,ineritemno,entrycount,lastcount,entryamt,lastamt) select '''+@compid+''' ,'''+@targcardno+''',s,p,c,c,a,a from ('+@contion+')  as tb '         
				exec sp_executesql @sql        
			end
			set @count  = @count+1            
			set @cardno=cast((cast(@cardno as int )+1) as varchar(20))        
			while(len(@cardno)<len(@cardtono))                
			begin                
				set @cardno = '0'+@cardno                
			end          
		end   	
	end 
	else
	begin
		while((@cardno <= @cardtono) and len(@cardno)=len(@cardtono) and @count<6000)            
		begin           
			set @targcardno=@cardBef+@cardno    
			insert nointernalcardinfo(cardvesting,cardno,cardtype,cardstate,carduseflag)    
			values( @compid,@targcardno,@cardclass,0,@carduseclass)    
			set @count  = @count+1        
			set @cardno=cast((cast(@cardno as int )+1) as varchar(20))    
			while(len(@cardno)<len(@cardtono))            
			begin            
				set @cardno = '0'+@cardno            
			end      
		end          
	end            
end 
go

-------��Ա������----- 1�۳��˻�(�����Ƴ����ѿ۳���Ӧ�Ƴ���ϸ) 2 �����˻���ʷ 3���ɽ�����ʷ
if exists(select 1 from sysobjects where type='P' and name='upg_handconsumbill_card')
	drop procedure upg_handconsumbill_card
go
create procedure upg_handconsumbill_card
@compid			varchar(10),	--���ѹ�˾      
@sendid			varchar(20),	--���ѵ��� 
@costdate		varchar(8),		--��������
@costtype		int				-- 1 ɢ������ 2 ��Ա����
as      
begin 
	--�����ڲ�����
	update dconsumeinfo set csfirstinid=manageno from dconsumeinfo,staffinfo where cscompid=@compid and csbillid=@sendid and csfirstsaler=staffno and compno=@compid
	update dconsumeinfo set cssecondinid=manageno from dconsumeinfo,staffinfo where cscompid=@compid and csbillid=@sendid and cssecondsaler=staffno and compno=@compid
	update dconsumeinfo set csthirdinid=manageno from dconsumeinfo,staffinfo where cscompid=@compid and csbillid=@sendid and csthirdsaler=staffno and compno=@compid
	
	declare @cardno varchar(20)			--���ѿ���
	declare @costaccount2	float		--��ֵ�˻�
	declare @costaccount3	float		--�����˻�
	declare @costaccount4	float		--�Ƴ��˻�
	declare @costaccount5	float		--�չ����˻�
	declare @tuangoucardno	varchar(20)	--�Ź�����


	
	select @cardno=cscardno,@tuangoucardno=tuangoucardno,
	@costaccount2=SUM(case when paymode='4' then isnull(payamt,0) else 0 end ),
	@costaccount3=SUM(case when paymode='7' then isnull(payamt,0) else 0 end ),
	@costaccount4=SUM(case when paymode='9' then isnull(payamt,0) else 0 end ),
	@costaccount5=SUM(case when paymode='A' then isnull(payamt,0) else 0 end )
	from mconsumeinfo with(nolock),dpayinfo with(nolock)
	where cscompid=paycompid and csbillid=paybillid and paybilltype='SY'
	and cscompid=@compid and  csbillid=@sendid
	group by cscardno,tuangoucardno

	if(isnull(@tuangoucardno,'')<>'')
	begin
		update corpsbuyinfo set corpssate=2,useincompid=@compid, useinbillno=@sendid,useindate=@costdate where corpscardno=@tuangoucardno
	end
	
	
	if(@costtype=1)
		return 

	
	
	
	declare @costaccountseqno	float		--�����˻����
	declare @costaccount2lastamt	float		--��ֵ�˻�ǰ�����
	declare @costaccount3lastamt	float		--�����˻�ǰ�����
	declare @costaccount4lastamt	float		--�Ƴ��˻�ǰ�����
	declare @costaccount5lastamt	float		--�չ����˻�ǰ�����
	
	select @costaccountseqno=MAX(changeseqno)+1 from cardaccountchangehistory where changecardno=@cardno 
	--���»�Ա���˻�+�˻���ʷ (�����Ƴ��˻�����0,����۳���Ӧ���Ƴ���ϸ)
	if(ISNULL(@costaccount2,0)<>0) --��ֵ�˻�
	begin
				--�����˻���ʷ
			select top 1 @costaccount2lastamt=(case when changetype in (0,6,7,8,9,10) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@cardno  and changeaccounttype=2 order by changeseqno desc 
			if(ISNULL(@costaccount2lastamt,0)=0)
				select @costaccount2lastamt=ISNULL(accountbalance,0) from cardaccount where cardno=@cardno and accounttype=2
			insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)
			values(@compid,@cardno,2,ISNULL(@costaccountseqno,0),2,@costaccount2,'SY',@sendid,@costdate,@costaccount2lastamt)
			set @costaccountseqno=ISNULL(@costaccountseqno,0)+1
			--�����˻�
			update cardaccount set accountbalance=ISNULL(accountbalance,0)-ISNULL(@costaccount2,0) where cardno=@cardno and accounttype='2'
		
	end
	if(ISNULL(@costaccount3,0)<>0) --�����˻�
	begin
			--�����˻���ʷ
			select top 1 @costaccount3lastamt=(case when changetype in (0,6,7,8,9,10) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@cardno  and changeaccounttype=3 order by changeseqno desc 
			if(ISNULL(@costaccount3lastamt,0)=0)
				select @costaccount3lastamt=ISNULL(accountbalance,0) from cardaccount where cardno=@cardno and accounttype=3
			insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)
			values(@compid,@cardno,3,ISNULL(@costaccountseqno,0),2,@costaccount3,'SY',@sendid,@costdate,@costaccount3lastamt)
			set @costaccountseqno=ISNULL(@costaccountseqno,0)+1
			--�����˻�
			update cardaccount set accountbalance=ISNULL(accountbalance,0)-ISNULL(@costaccount3,0) where cardno=@cardno and accounttype='3'
			
	end
	if(ISNULL(@costaccount4,0)<>0) --�Ƴ��˻�
	begin	
			--�����˻���ʷ
			select top 1 @costaccount4lastamt=(case when changetype in (0,6,7,8,9,10,11) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@cardno  and changeaccounttype=4 order by changeseqno desc 
			if(ISNULL(@costaccount4lastamt,0)=0)
				select @costaccount4lastamt=ISNULL(accountbalance,0) from cardaccount where cardno=@cardno and accounttype=4
			insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)
			values(@compid,@cardno,4,ISNULL(@costaccountseqno,0),2,@costaccount4,'SY',@sendid,@costdate,@costaccount4lastamt)
			set @costaccountseqno=ISNULL(@costaccountseqno,0)+1
			--�����˻�
			update cardaccount set accountbalance=ISNULL(accountbalance,0)-ISNULL(@costaccount4,0) where cardno=@cardno and accounttype='4'
			
			--�����Ƴ���ϸ
			update cardproaccount set costcount=isnull(costcount,0)+isnull(csitemcount,0),
									  lastcount=isnull(lastcount,0)-isnull(csitemcount,0),
									  costamt=isnull(costamt,0)+isnull(csitemamt,0),
									  lastamt=isnull(lastamt,0)-isnull(csitemamt,0)
			from cardproaccount,
			(select csitemno,csproseqno,csitemcount=sum(ISNULL(csitemcount,0)),csitemamt=SUM(isnull(csitemamt,0)) from dconsumeinfo where cspaymode='9' and cscompid=@compid and  csbillid=@sendid group by csitemno,csproseqno) as costdetial
			 where cardno=@cardno and projectno=csitemno and proseqno=csproseqno
	end
	if(ISNULL(@costaccount5,0)<>0) --�չ��˻�
	begin
				--�����˻���ʷ
			select top 1 @costaccount5lastamt=(case when changetype in (0,6,7,8,9,10) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@cardno  and changeaccounttype=5 order by changeseqno desc 
			if(ISNULL(@costaccount5lastamt,0)=0)
			select @costaccount5lastamt=ISNULL(accountbalance,0) from cardaccount where cardno=@cardno and accounttype=5
			insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)
			values(@compid,@cardno,5,ISNULL(@costaccountseqno,0),2,@costaccount5,'SY',@sendid,@costdate,@costaccount5lastamt)
			--�����˻�
			update cardaccount set accountbalance=ISNULL(accountbalance,0)-ISNULL(@costaccount5,0) where cardno=@cardno and accounttype='5'
		
	end
	
	--������Ŀ������ϸ
	insert cardtransactionhistory(transactioncompid,transactioncardno,transactiondate,transactiontype,codeno,codename,ccount,price,billtype,billno,firstempid,secondempid,thirthempid,paymode)
	select cscompid,@cardno,@costdate,3,csitemno,prjname,csitemcount,csitemamt,'SY',csbillid,csfirstsaler,cssecondsaler,csthirdsaler,cspaymode
	 from dconsumeinfo a,compchaininfo b,projectinfo c
	  where  csinfotype=1  and cscompid=@compid and  csbillid=@sendid
	  and  c.prjno = a.csitemno and  b.curcomp=c.prisource and b.relationcomp=@compid


	--���ɲ�Ʒ������ϸ
	insert cardtransactionhistory(transactioncompid,transactioncardno,transactiondate,transactiontype,codeno,codename,ccount,price,billtype,billno,firstempid,secondempid,thirthempid,paymode)
	select cscompid,@cardno,@costdate,4,csitemno,goodsname,csitemcount,csitemamt,'SY',csbillid,csfirstsaler,cssecondsaler,csthirdsaler,cspaymode
	 from dconsumeinfo a,compchaininfo b,goodsinfo c
	  where  csinfotype=2  and cscompid=@compid and  csbillid=@sendid
	  and  c.goodsno = a.csitemno and  b.curcomp=c.goodssource and b.relationcomp=@compid



end 
go  


if exists(select 1 from sysobjects where type='P' and name='upg_handconsumbill_card_back')
	drop procedure upg_handconsumbill_card_back
go
create procedure upg_handconsumbill_card_back  
@compid   varchar(10), --���ѹ�˾        
@sendid   varchar(20), --���ѵ���   
@costdate  varchar(8),  --��������  
@costtype  int ,   -- 1 ɢ������ 2 ��Ա����  
@oldsendid  varchar(20)  --ԭʼ���ѵ���   
as        
begin   
 --�����ڲ�����  
 update dconsumeinfo set csfirstinid=manageno from dconsumeinfo,staffinfo where cscompid=@compid and csbillid=@sendid and csfirstsaler=staffno and compno=@compid  
 update dconsumeinfo set cssecondinid=manageno from dconsumeinfo,staffinfo where cscompid=@compid and csbillid=@sendid and cssecondsaler=staffno and compno=@compid  
 update dconsumeinfo set csthirdinid=manageno from dconsumeinfo,staffinfo where cscompid=@compid and csbillid=@sendid and csthirdsaler=staffno and compno=@compid  
   
 declare @cardno varchar(20)   --���ѿ���  
 declare @costaccount2 float  --��ֵ�˻�  
 declare @costaccount3 float  --�����˻�  
 declare @costaccount4 float  --�Ƴ��˻�  
 declare @costaccount5 float  --�չ����˻�  
 declare @tuangoucardno varchar(20) --�Ź�����  
 declare @tiaomacardno varchar(20) --���뿨��  
 declare @diyongcardno varchar(20) --����ȯ��  
   
 select @cardno=cscardno,@tuangoucardno=isnull(tuangoucardno,''),@tiaomacardno=isnull(tiaomacardno,''),@diyongcardno=isnull(diyongcardno,''),  
 @costaccount2=SUM(case when paymode='4' then isnull(payamt,0) else 0 end ),  
 @costaccount3=SUM(case when paymode='7' then isnull(payamt,0) else 0 end ),  
 @costaccount4=SUM(case when paymode='9' then isnull(payamt,0) else 0 end ),  
 @costaccount5=SUM(case when paymode='A' then isnull(payamt,0) else 0 end )  
 from mconsumeinfo with(nolock),dpayinfo with(nolock)  
 where cscompid=paycompid and csbillid=paybillid and paybilltype='SY'  
 and cscompid=@compid and  csbillid=@sendid  
 group by cscardno,isnull(tuangoucardno,''),isnull(tiaomacardno,''),isnull(diyongcardno,'')  
  
 --�Ź���  
 if(isnull(@tuangoucardno,'')<>'')  
 begin  
  update corpsbuyinfo set corpssate=1,useincompid='', useinbillno='',useindate='' where corpscardno=@tuangoucardno  
 end  
   
 --����ȯ  
 if(isnull(@diyongcardno,'')<>'')  
 begin  
  update nointernalcardinfo set cardstate=1,usedate='', useinproject='' where cardno=@diyongcardno and cardtype=1  
  --update a set a.usecount=ISNULL(a.usecount,0)-ISNULL(b.csitemcount,0),a.lastcount=ISNULL(a.lastcount,0)+ISNULL(b.csitemcount,0),  
               --a.useamt=ISNULL(a.useamt,0)-ISNULL(b.csitemamt,0),a.lastamt=ISNULL(a.lastamt,0)+ISNULL(b.csitemamt,0)   
   --from dnointernalcardinfo a,dconsumeinfo b  
  --where cscompid=@compid and csbillid=@oldsendid and cspaymode='11' and a.ineritemno=b.csitemno and a.cardno=@diyongcardno  
    
 end  
   
 --���뿨  
 if(isnull(@tiaomacardno,'')<>'')  
 begin  
  update a set a.usecount=ISNULL(a.usecount,0)-ISNULL(b.csitemcount,0),a.lastcount=ISNULL(a.lastcount,0)+ISNULL(b.csitemcount,0),  
               a.useamt=ISNULL(a.useamt,0)-ISNULL(b.csitemamt,0),a.lastamt=ISNULL(a.lastamt,0)+ISNULL(b.csitemamt,0)   
   from dnointernalcardinfo a,dconsumeinfo b  
  where cscompid=@compid and csbillid=@oldsendid and cspaymode='13' and a.ineritemno=b.csitemno and a.cardno=@tiaomacardno  
    
 end  
   
 --Ψһ��Ʒ����  
 update dgoodsbarinfo set barnostate=2,costbillo='',coststore='' where costbillo=@oldsendid   and coststore=@compid  
 if(@costtype=1)  
  return   
 declare @costaccountseqno float  --�����˻����  
 declare @costaccount2lastamt float  --��ֵ�˻�ǰ�����  
 declare @costaccount3lastamt float  --�����˻�ǰ�����  
 declare @costaccount4lastamt float  --�Ƴ��˻�ǰ�����  
 declare @costaccount5lastamt float  --�չ����˻�ǰ�����  
   
 select @costaccountseqno=MAX(changeseqno)+1 from cardaccountchangehistory where changecardno=@cardno   
 --���»�Ա���˻�+�˻���ʷ (�����Ƴ��˻�����0,����۳���Ӧ���Ƴ���ϸ)  
 if(ISNULL(@costaccount2,0)<>0) --��ֵ�˻�  
 begin  
    --�����˻���ʷ  
   select top 1 @costaccount2lastamt=(case when changetype in (0,6) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@cardno  and changeaccounttype=2 order by chagedate desc,changeseqno desc   
   if(ISNULL(@costaccount2lastamt,0)=0)  
    select @costaccount2lastamt=ISNULL(accountbalance,0) from cardaccount where cardno=@cardno and accounttype=2  
   insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)  
   values(@compid,@cardno,2,ISNULL(@costaccountseqno,0),2,@costaccount2,'SY',@sendid,@costdate,@costaccount2lastamt)  
   set @costaccountseqno=ISNULL(@costaccountseqno,0)+1  
   --�����˻�  
   update cardaccount set accountbalance=ISNULL(accountbalance,0)-ISNULL(@costaccount2,0) where cardno=@cardno and accounttype='2'  
    
 end  
 if(ISNULL(@costaccount3,0)<>0) --�����˻�  
 begin  
   --�����˻���ʷ  
   select top 1 @costaccount3lastamt=(case when changetype in (0,6) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@cardno  and changeaccounttype=3 order by chagedate desc,changeseqno desc   
   if(ISNULL(@costaccount3lastamt,0)=0)  
    select @costaccount3lastamt=ISNULL(accountbalance,0) from cardaccount where cardno=@cardno and accounttype=3  
   insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)  
   values(@compid,@cardno,3,ISNULL(@costaccountseqno,0),2,@costaccount3,'SY',@sendid,@costdate,@costaccount3lastamt)  
   set @costaccountseqno=ISNULL(@costaccountseqno,0)+1  
   --�����˻�  
   update cardaccount set accountbalance=ISNULL(accountbalance,0)-ISNULL(@costaccount3,0) where cardno=@cardno and accounttype='3'  
     
 end  
 if(ISNULL(@costaccount4,0)<>0) --�Ƴ��˻�  
 begin   
   --�����˻���ʷ  
   select top 1 @costaccount4lastamt=(case when changetype in (0,6,7,8,9,10,11) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@cardno  and changeaccounttype=4 order by chagedate desc,changeseqno desc   
   if(ISNULL(@costaccount4lastamt,0)=0)  
    select @costaccount4lastamt=ISNULL(accountbalance,0) from cardaccount where cardno=@cardno and accounttype=4  
   insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)  
   values(@compid,@cardno,4,ISNULL(@costaccountseqno,0),2,@costaccount4,'SY',@sendid,@costdate,@costaccount4lastamt)  
   set @costaccountseqno=ISNULL(@costaccountseqno,0)+1  
   --�����˻�  
   update cardaccount set accountbalance=ISNULL(accountbalance,0)-ISNULL(@costaccount4,0) where cardno=@cardno and accounttype='4'  
     
   --�����Ƴ���ϸ  
   update cardproaccount set costcount=isnull(costcount,0)+isnull(csitemcount,0),  
           lastcount=isnull(lastcount,0)-isnull(csitemcount,0),  
           costamt=isnull(costamt,0)+isnull(csitemamt,0),  
           lastamt=isnull(lastamt,0)-isnull(csitemamt,0)  
   from cardproaccount,  
   (select csitemno,csproseqno,csitemcount=sum(ISNULL(csitemcount,0)),csitemamt=SUM(isnull(csitemamt,0)) from dconsumeinfo where cspaymode='9' and cscompid=@compid and  csbillid=@sendid group by csitemno,csproseqno) as costdetial  
    where cardno=@cardno and projectno=csitemno and proseqno=csproseqno  
 end  
 if(ISNULL(@costaccount5,0)<>0) --�չ��˻�  
 begin  
    --�����˻���ʷ  
   select top 1 @costaccount5lastamt=(case when changetype in (0,6,7,8,9,10,11) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@cardno  and changeaccounttype=5 order by chagedate desc,changeseqno desc   
   if(ISNULL(@costaccount5lastamt,0)=0)  
   select @costaccount5lastamt=ISNULL(accountbalance,0) from cardaccount where cardno=@cardno and accounttype=5  
   insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)  
   values(@compid,@cardno,5,ISNULL(@costaccountseqno,0),2,@costaccount5,'SY',@sendid,@costdate,@costaccount5lastamt)  
   --�����˻�  
   update cardaccount set accountbalance=ISNULL(accountbalance,0)-ISNULL(@costaccount5,0) where cardno=@cardno and accounttype='5'  
    
 end  
   
 --������Ŀ������ϸ  
 insert cardtransactionhistory(transactioncompid,transactioncardno,transactiondate,transactiontype,codeno,codename,ccount,price,billtype,billno,firstempid,secondempid,thirthempid,paymode)  
 select cscompid,@cardno,@costdate,3,csitemno,prjname,csitemcount,csitemamt,'SY',csbillid,csfirstsaler,cssecondsaler,csthirdsaler,cspaymode  
  from dconsumeinfo a,compchaininfo b,projectinfo c  
   where  csinfotype=1  and cscompid=@compid and  csbillid=@sendid  
   and  c.prjno = a.csitemno and  b.curcomp=c.prisource and b.relationcomp=@compid  
  
  
 --���ɲ�Ʒ������ϸ  
 insert cardtransactionhistory(transactioncompid,transactioncardno,transactiondate,transactiontype,codeno,codename,ccount,price,billtype,billno,firstempid,secondempid,thirthempid,paymode)  
 select cscompid,@cardno,@costdate,4,csitemno,goodsname,csitemcount,csitemamt,'SY',csbillid,csfirstsaler,cssecondsaler,csthirdsaler,cspaymode  
  from dconsumeinfo a,compchaininfo b,goodsinfo c  
   where  csinfotype=2  and cscompid=@compid and  csbillid=@sendid  
   and  c.goodsno = a.csitemno and  b.curcomp=c.goodssource and b.relationcomp=@compid  
  
  --ɾ�����
   delete mgoodsstockinfo where changecompid=@compid and changebillno=@oldsendid and changetype=3
    delete dgoodsstockinfo where changecompid=@compid and changebillno=@oldsendid and changetype=3 
end   

-------��Ա������----- 1�۳��˻�(�����Ƴ����ѿ۳���Ӧ�Ƴ���ϸ) 2 �����˻���ʷ 3���ɽ�����ʷ
if exists(select 1 from sysobjects where type='P' and name='upg_handsalecardbill_card')
	drop procedure upg_handsalecardbill_card
go
create procedure upg_handsalecardbill_card
@compid			varchar(10),	--���۹�˾      
@billid			varchar(20),	--���۵��� 
@cardtype		varchar(20)	--����
as      
begin 
	--�����ڲ�����
	update msalecardinfo set firstsalerinid=manageno from msalecardinfo,staffinfo	where salecompid=@compid and salebillid=@billid and firstsalerid=staffno and compno=@compid
	update msalecardinfo set secondsalerinid=manageno from msalecardinfo,staffinfo	where salecompid=@compid and salebillid=@billid and secondsalerid=staffno and compno=@compid
	update msalecardinfo set thirdsalerinid=manageno from msalecardinfo,staffinfo	where salecompid=@compid and salebillid=@billid and thirdsalerid=staffno and compno=@compid
	update msalecardinfo set fourthsalerinid=manageno from msalecardinfo,staffinfo	where salecompid=@compid and salebillid=@billid and fourthsalerid=staffno and compno=@compid
	update msalecardinfo set fifthsalerinid=manageno from msalecardinfo,staffinfo	where salecompid=@compid and salebillid=@billid and fifthsalerid=staffno and compno=@compid
	update msalecardinfo set sixthsalerinid=manageno from msalecardinfo,staffinfo	where salecompid=@compid and salebillid=@billid and sixthsalerid=staffno and compno=@compid
	update msalecardinfo set seventhsalerinid=manageno from msalecardinfo,staffinfo where salecompid=@compid and salebillid=@billid and seventhsalerid=staffno and compno=@compid
	update msalecardinfo set eighthsalerinid=manageno from msalecardinfo,staffinfo	where salecompid=@compid and salebillid=@billid and eighthsalerid=staffno and compno=@compid
	declare @salecardno			varchar(20)		--���ۿ���
	declare @saledate			varchar(8)		--��������
	declare @saletime			varchar(9)		--����ʱ��
	declare @membername			varchar(30)		--��Ա����
	declare @memberphone		varchar(20)		--��Ա�ֻ�
	declare @membersex			int				--��Ա�Ա�
	declare @memberpcid			varchar(30)		--��Ա����֤��
	declare @memberbirthday		varchar(8)		--��Ա����
	declare @acc2keepamt		float			--��ֵ���
	declare @debtamt			float			--��ֵǷ��(AMN������Ƿ��)
	declare @acc2totalamt		float			--��ֵ�ܶ�
	declare @acc4totalamt		float			--�Ƴ��ܶ�
	declare @paykeeptotalamt	float			--֧���ܶ�
	declare @paydebttotalamt	float			--֧����Ƿ��
	declare @corpscardno		varchar(10)		--�Ź���

	select @salecardno=salecardno,@saledate=saledate,@saletime=saletime,@membername=membername,@memberphone=memberphone,
	@membersex=membersex,@memberpcid=memberpcid,@memberbirthday=memberbirthday,@corpscardno=corpscardno 
	from msalecardinfo with(nolock) where salecompid=@compid and salebillid=@billid
	

	select @paykeeptotalamt=SUM(ISNULL(payamt,0)) from dpayinfo with(nolock)  where paycompid=@compid and paybillid=@billid and paybilltype='SK' and ISNULL(paymode,'')<>'5'
	select @paydebttotalamt=SUM(ISNULL(payamt,0)) from dpayinfo with(nolock)  where paycompid=@compid and paybillid=@billid and paybilltype='SK' and ISNULL(paymode,'')='5'
	select @acc4totalamt=sum(ISNULL(saleproamt,0)) from dsalecardproinfo with(nolock) where salecompid=@compid and salebillid=@billid and salebilltype=1
	set @acc2totalamt=ISNULL(@paykeeptotalamt,0)-ISNULL(@acc4totalamt,0)
	
	--���»�Ա����
		--��øÿ��ֵ���Ч����
		declare @carduselife float
		select @carduselife=carduselife from cardtypeinfo where cardtypeno=@cardtype and cardtypemodeid='SCM'
		declare @cutoffdate varchar(10)
		select @cutoffdate=convert(varchar(10),dateadd(day,@carduselife,cast(@saledate as datetime)),120)
		select @cutoffdate=substring(@cutoffdate,1,4)+substring(@cutoffdate,6,2)+substring(@cutoffdate,9,2)
		update cardinfo set salecarddate=@saledate,cutoffdate=@cutoffdate,cardstate=4,salebillno=@billid,cardsource=0 where cardno=@salecardno
	--�����˻����
		if exists(select 1 from cardaccount where cardno=@salecardno and accounttype=2)
			update cardaccount set accountbalance=@acc2totalamt,accountdatefrom=@saledate,accountdateend=@cutoffdate where cardno=@salecardno and accounttype=2
		else
		begin
			insert cardaccount(cardvesting,cardno,accounttype,accountbalance,accountdebts,accountdatefrom,accountdateend,accountremark)
			values(@compid,@salecardno,2,@acc2totalamt,0,@saledate,@cutoffdate,'')
		end
		if exists(select 1 from cardaccount where cardno=@salecardno and accounttype=4)
			update cardaccount set accountbalance=@acc4totalamt,accountdatefrom=@saledate,accountdateend=@cutoffdate where cardno=@salecardno and accounttype=4
		else
		begin
			insert cardaccount(cardvesting,cardno,accounttype,accountbalance,accountdebts,accountdatefrom,accountdateend,accountremark)
			values(@compid,@salecardno,4,@acc4totalamt,0,@saledate,@cutoffdate,'')
		end
	--������Ա��������
		if exists(select 1 from memberinfo where cardnotomemberno=@salecardno )
			update memberinfo set membervesting=@compid,memberno=@salecardno,membercreatedate=@saledate,
			 membername=@membername,membertphone=@memberphone,membersex=@membersex,memberpaperworkno=@memberpcid,
			 memberbirthday=@memberbirthday where cardnotomemberno=@salecardno
		else
		begin
			insert memberinfo(membervesting,memberno,membercreatedate,membername,membermphone,membersex,memberpaperworkno,memberbirthday,cardnotomemberno)
			values(@compid,@salecardno,@saledate,@membername,@memberphone,@membersex,@memberpcid,@memberbirthday,@salecardno)
		end
	--�����˻���ʷ
		declare @costaccountseqno		float
		declare @costaccount2lastamt	float		--��ֵ�˻�ǰ�����
		declare @costaccount4lastamt	float		--�Ƴ��˻�ǰ�����

		select @costaccountseqno=MAX(changeseqno)+1 from cardaccountchangehistory where changecardno=@salecardno 
		if(ISNULL(@acc2totalamt,0)>0) --��ֵ�˻�
		begin
				--�����˻���ʷ
				select top 1 @costaccount2lastamt=(case when changetype in (0,6,7,8,9,10,11) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@salecardno  and changeaccounttype=2 order by changeseqno desc 
				insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)
				values(@compid,@salecardno,2,isnull(@costaccountseqno,0),0,@acc2totalamt,'SK',@billid,@saledate,@costaccount2lastamt)
				set @costaccountseqno=@costaccountseqno+1
		end
	
		if(ISNULL(@acc4totalamt,0)>0) --�Ƴ��˻�
		begin	
				--�����˻���ʷ
				select top 1 @costaccount4lastamt=(case when changetype in (0,6,7,8,9,10,11) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@salecardno  and changeaccounttype=4 order by changeseqno desc 
				insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)
				values(@compid,@salecardno,4,isnull(@costaccountseqno,0),0,@acc4totalamt,'SK',@billid,@saledate,@costaccount4lastamt)
				set @costaccountseqno=@costaccountseqno+1
				
		end
	--�����춯��ʷ
		declare @saleaccountseqno		float
		select @saleaccountseqno=MAX(changeseqno)+1 from cardchangehistory where changecardno=@salecardno 
		insert cardchangehistory(changecompid,changecardno,changeseqno,changetype,changebillid,beforestate,afterstate,chagedate,targetcardno)
		values(@compid,@salecardno,isnull(@saleaccountseqno,0),2,@billid,0,4,@saledate,'')
	
	--�����Ƴ���Ϣ
		declare @proseqno float
		select @proseqno=MAX(proseqno)+1 from cardproaccount with(nolock) where cardno=@salecardno 
		insert cardproaccount(cardvesting,cardno,projectno,proseqno,propricetype,salecount,costcount,lastcount,saleamt,costamt,lastamt,saledate,cutoffdate,proremark,createbilltype,createbillno)
		select @compid,@salecardno,saleproid,ISNULL(@proseqno,0)+ISNULL(seleproseqno,0),saleprotype,ISNULL(saleprocount,0)+ISNULL(sendprocount,0),0,ISNULL(saleprocount,0)+ISNULL(sendprocount,0),
		ISNULL(saleproamt,0),0,ISNULL(saleproamt,0),@saledate,procutoffdate,saleproremark,'SK', @billid
		from dsalecardproinfo where salecompid=@compid and salebillid=@billid and salebilltype=1
		
	--�����Ź���Ϣ
	if(ISNULL(@corpscardno,'')<>'')
	begin
		update corpsbuyinfo set corpssate=2,useincompid=@compid,useinbillno=@billid,useindate =@saledate where corpscardno=@corpscardno
	end		
end 
go  


-------��Ա���Ƴ̶һ�----
if exists(select 1 from sysobjects where type='P' and name='upg_handaccountChangebill_card')
	drop procedure upg_handaccountChangebill_card
go
create procedure upg_handaccountChangebill_card  
@compid   varchar(10), --�һ���˾        
@billid   varchar(20)  --�һ�����   
as        
begin   
 --�����ڲ�����  
 update dproexchangeinfo set firstsalerinid=manageno  from dproexchangeinfo,staffinfo where changecompid=@compid and changebillid=@billid and firstsalerid=staffno and compno=@compid  
 update dproexchangeinfo set secondsalerinid=manageno from dproexchangeinfo,staffinfo where changecompid=@compid and changebillid=@billid and secondsalerid=staffno and compno=@compid  
 update dproexchangeinfo set thirdsalerinid=manageno  from dproexchangeinfo,staffinfo where changecompid=@compid and changebillid=@billid and thirdsalerid=staffno and compno=@compid  
 update dproexchangeinfo set fourthsalerinid=manageno from dproexchangeinfo,staffinfo where changecompid=@compid and changebillid=@billid and fourthsalerid=staffno and compno=@compid  
   
 declare @changecardno    varchar(20)  --�һ�����  
 declare @changedate     varchar(8)  --�һ�����  
 declare @changetime     varchar(9)  --�һ�ʱ��  
   
 declare @changeaccount    varchar(5)  --�����˻�  
 declare @changeaccountamt   float   --�����˻����  
 declare @changeaccount4amt   float   --�����Ƴ��˻����  
 declare @inseraccount4amt   float   --�һ��Ƴ��˻����  
   
 select @changecardno=changecardno,@changedate=changedate,@changetime=changetime,@changeaccount=ISNULL(changeaccounttype,0)  
 from mproexchangeinfo with(nolock) where changecompid=@compid and changebillid=@billid  
   
 select @changeaccountamt=SUM(ISNULL(changebyaccountamt,0)),@changeaccount4amt=SUM(ISNULL(changebyproaccountamt,0)),@inseraccount4amt=SUM(isnull(changebyaccountamt,0)+ISNULL(changebyproaccountamt,0)+ISNULL(changebycashamt,0))  
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
   if not exists(select 1 from cardaccount where   cardno = @changecardno and accounttype=4)        
   begin        
     insert into cardaccount(cardvesting,cardno,accounttype,accountbalance,accountdebts)         
     values(@compid,@changecardno,4,ISNULL(@inseraccount4amt,0),0)        
   end    
   else  
   begin  
    update cardaccount set accountbalance=ISNULL(accountbalance,0)+@inseraccount4amt where accounttype='4' and cardno=@changecardno  
   end  
  end  
 --�����˻���ʷ  
  declare @costaccountseqno  float  
  declare @curcardamt    float  
  select @costaccountseqno=MAX(changeseqno)+1 from cardaccountchangehistory where changecardno=@changecardno   
  if(ISNULL(@changeaccountamt,0)>0)--�����˻�  
  begin  
   set @curcardamt=0  
   select top 1 @curcardamt=(case when changetype in (0,6,7,8,9,10,11) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@changecardno  and changeaccounttype=CAST(@changeaccount as int) order by chagedate desc,changeseqno desc   
    
   --�����˻���ʷ   
   insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)  
   values(@compid,@changecardno,CAST(@changeaccount as int),isnull(@costaccountseqno,0),12,@changeaccountamt,'DH',@billid,@changedate,@curcardamt)  
   set @costaccountseqno=@costaccountseqno+1  
  end  
  if(ISNULL(@changeaccount4amt,0)>0)--�����Ƴ��˻�  
  begin  
   set @curcardamt=0  
   select top 1 @curcardamt=(case when changetype in (0,6,7,8,9,10,11) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@changecardno  and changeaccounttype=4 order by chagedate desc,changeseqno desc   
    
   insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)  
   values(@compid,@changecardno,4,isnull(@costaccountseqno,0),13,@changeaccount4amt,'DH',@billid,@changedate,@curcardamt)  
   set @costaccountseqno=@costaccountseqno+1  
  end  
  if(ISNULL(@inseraccount4amt,0)>0)--�����Ƴ��˻�  
  begin  
   set @curcardamt=0  
   select top 1 @curcardamt=(case when changetype in (0,6,7,8,9,10,11) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@changecardno  and changeaccounttype=4 order by chagedate desc,changeseqno desc   
    
   insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)  
   values(@compid,@changecardno,4,isnull(@costaccountseqno,0),11,@inseraccount4amt,'DH',@billid,@changedate,@curcardamt)  
   set @costaccountseqno=@costaccountseqno+1  
  end  
 --�����Ƴ���Ϣ  
  declare @proseqno float  
  select @proseqno=MAX(proseqno)+1 from cardproaccount with(nolock) where cardno=@changecardno   
  insert cardproaccount(cardvesting,cardno,projectno,proseqno,propricetype,salecount,costcount,lastcount,saleamt,costamt,lastamt,saledate,cutoffdate,proremark,createbilltype,createbillno,createseqno)  
  select changecompid,@changecardno,changeproid,ISNULL(@proseqno,0)+ISNULL(changeseqno,0),4,ISNULL(changeprocount,0),0,ISNULL(changeprocount,0),  
  isnull(changebyaccountamt,0)+ISNULL(changebyproaccountamt,0)+ISNULL(changebycashamt,0),0,isnull(changebyaccountamt,0)+ISNULL(changebyproaccountamt,0)+ISNULL(changebycashamt,0),@changedate,'',changemark,'LCDH',@billid ,changeseqno  
  from dproexchangeinfo where changecompid=@compid and changebillid=@billid   
 --���ɵֿ���Ϣ   
  if(ISNULL(@changeaccount4amt,0)>0)--�����Ƴ��˻�  
  begin  
   update a set costcount=ISNULL(a.costcount,0)+ISNULL(b.changeprocount,0),  
           lastcount=ISNULL(a.lastcount,0)-ISNULL(b.changeprocount,0),  
           costamt=ISNULL(a.costamt,0)+ISNULL(b.changeproamt,0),  
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



if exists(select 1 from sysobjects where type='P' and name='upg_Confirm_CardChangeCard')
	drop procedure upg_Confirm_CardChangeCard
go
create procedure upg_Confirm_CardChangeCard      
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
 declare @SP042     varchar(2) --�Ƿ����ÿ����Ƿ���ۼ� 0:���� 1:����  
 select @SP042=paramvalue from sysparaminfo where compid=@compid and paramid='SP042'  
 select @curfillamt=ISNULL(changefillamt,0),@curdebtamt=ISNULL(changdebtamt,0),  
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
 else if(@changetype in (0,1,2))  
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
  select top 1 @costaccount2lastamt=(case when changetype in (0,6,7,8,9,10,11) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@oldcardno  and changeaccounttype=2 order by chagedate desc,changeseqno desc   
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
     select top 1 @costaccount2lastamt=(case when changetype in (0,6,7,8,9,10,11) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@newcardno  and changeaccounttype=2 order by chagedate desc,changeseqno desc   
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
     select top 1 @costaccount2lastamt=(case when changetype in (0,6,7,8,9,10,11) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@newcardno  and changeaccounttype=2 order by chagedate desc,changeseqno desc   
     if(@changetype=1)  
      set @costaccount2lastamt=ISNULL(@oldaccfillamt,0)  
     insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)  
     values(@compid,@newcardno,2,isnull(@costaccountseqno,0),ISNULL(@changetype,0)+7,@curfillamt,'ZK',@billid,@changedate,@costaccount2lastamt)  
     set @costaccountseqno=@costaccountseqno+1  
    end  
   end  
  end  
  else if(@changetype in (6,7))    
  begin  
   if(@changetype =6)--�Ͽ����Ͽ� @oldcardno ΪĿ�꿨  
   begin  
        update  cardinfo set cardstate=12 from dcardchangeinfo,cardinfo where cardno=oldcardno and changecompid=@compid and changebillid=@billid  --�Ѳ���״̬  
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
   declare @oldcardpointamt float
   
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
    select top 1 @costaccount2lastamt=(case when changetype in (0,6,7,8,9,10,11) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@oldcardno  and changeaccounttype=2 order by chagedate desc,changeseqno desc   
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
  
  
go

--���ڼ��㺯��
if exists(select 1 from sysobjects where name = 'upg_date_plus' and type='P')
drop procedure upg_date_plus
go
create procedure upg_date_plus
	@fromdate varchar(8),
	@addday float,
	@result varchar(8) output
as
begin
	declare @tmpdate datetime
	declare @year varchar(4) --���
	declare @month varchar(2)--�·�
	declare @day varchar(2) --�շ�
	set @tmpdate = dateadd(day,@addday,convert(datetime,@fromdate))
	set @year = year(@tmpdate)
	set @month = month(@tmpdate)
	set @day = day(@tmpdate)
	if(len(@month)=1)
		set @month = '0'+@month
	if(len(@day)=1)
		set @day = '0'+@day
	set @result=@year+@month+@day
end
go

if exists(select 1 from sysobjects where type='P' and name='get_month_days')
	drop procedure get_month_days
go
create procedure get_month_days 
@year   int,  
@month  int,  
@day    int output  
as  
begin  
  
declare @leap int --1 is leap 0 is not leap  
begin  
 if( (@year%4=0 and @year%100<>0) or @year%400=0)  
  set @leap =1  
 else   
  set @leap = 0  
  
 if(@month=1)  
  set @day=31  
 if(@month=2)  
 begin  
  if(@leap=1)  
   set @day=29  
  else  
   set @day=28  
 end  
 if(@month=3)  
  set @day=31  
 if(@month=4)  
  set @day=30  
 if(@month=5)  
  set @day=31  
 if(@month=6)  
  set @day=30  
 if(@month=7)  
  set @day=31  
 if(@month=8)  
  set @day=31  
 if(@month=9)  
  set @day=30  
 if(@month=10)  
  set @day=31  
 if(@month=11)  
  set @day=30  
 if(@month=12)  
  set @day=31  
end  
end  
go
if exists(select 1 from sysobjects where type='P' and name='upg_handrechargecardbill_card')
	drop procedure upg_handrechargecardbill_card
go
create procedure upg_handrechargecardbill_card    
@compid   varchar(10), --������˾          
@billid   varchar(20), --��������     
@cardtype  varchar(20) --����    
as          
begin     
 --�����ڲ�����    
 update mcardrechargeinfo set firstsalerinid=manageno from mcardrechargeinfo,staffinfo where rechargecompid=@compid and rechargebillid=@billid and firstsalerid=staffno and compno=@compid    
 update mcardrechargeinfo set secondsalerinid=manageno from mcardrechargeinfo,staffinfo where rechargecompid=@compid and rechargebillid=@billid and secondsalerid=staffno and compno=@compid    
 update mcardrechargeinfo set thirdsalerinid=manageno from mcardrechargeinfo,staffinfo where rechargecompid=@compid and rechargebillid=@billid and thirdsalerid=staffno and compno=@compid    
 update mcardrechargeinfo set fourthsalerinid=manageno from mcardrechargeinfo,staffinfo where rechargecompid=@compid and rechargebillid=@billid and fourthsalerid=staffno and compno=@compid    
 update mcardrechargeinfo set fifthsalerinid=manageno from mcardrechargeinfo,staffinfo where rechargecompid=@compid and rechargebillid=@billid and fifthsalerid=staffno and compno=@compid    
 update mcardrechargeinfo set sixthsalerinid=manageno from mcardrechargeinfo,staffinfo where rechargecompid=@compid and rechargebillid=@billid and sixthsalerid=staffno and compno=@compid    
 update mcardrechargeinfo set seventhsalerinid=manageno from mcardrechargeinfo,staffinfo where rechargecompid=@compid and rechargebillid=@billid and seventhsalerid=staffno and compno=@compid    
 update mcardrechargeinfo set eighthsalerinid=manageno from mcardrechargeinfo,staffinfo where rechargecompid=@compid and rechargebillid=@billid and eighthsalerid=staffno and compno=@compid    
 declare @salecardno    varchar(20)  --��������    
 declare @saledate    varchar(8)  --��������    
 declare @saletime    varchar(9)  --����ʱ��    
     
 declare @rechargetype   int    --���ѷ�ʽ( 0��ֵ ,6����)      
 declare @rechargekeepamt  float   --��ֵ���    
 declare @rechargedebtamt  float   --Ƿ����    
 declare @curcardamt    float   --�춯ǰ���    
 declare @curcarddebtamt   float   --�춯ǰǷ��    
 declare @rechargeaccounttype varchar(10)  --��ֵ�˻�    
 declare @acc4totalamt  float   --�Ƴ��ܶ�    
 declare @carduselife float    
 select @carduselife=carduselife from cardtypeinfo where cardtypeno=@cardtype and cardtypemodeid='SCM'    
 declare @cutoffdate varchar(10)    
 select @cutoffdate=convert(varchar(10),dateadd(day,@carduselife,cast(@saledate as datetime)),120)    
     
 select @salecardno=rechargecardno,@saledate=rechargedate,@saletime=rechargetime,@rechargetype=rechargetype,    
        @rechargekeepamt=rechargekeepamt,@rechargedebtamt=rechargedebtamt,@curcardamt=curcardamt,@curcarddebtamt=curcarddebtamt,@rechargeaccounttype=rechargeaccounttype    
 from mcardrechargeinfo with(nolock) where rechargecompid=@compid and rechargebillid=@billid    
     
 select @cutoffdate=substring(@cutoffdate,1,4)+substring(@cutoffdate,6,2)+substring(@cutoffdate,9,2)    
 select @acc4totalamt=sum(ISNULL(saleproamt,0)) from dsalecardproinfo with(nolock) where salecompid=@compid and salebillid=@billid and salebilltype=2    
     
 --�����˻����    
 if(@rechargetype=0)--��ֵ    
 begin    
  if exists(select 1 from cardaccount where cardno=@salecardno and accounttype=CAST(@rechargeaccounttype as int))    
  begin    
    update cardaccount set accountbalance=isnull(accountbalance,0)+ISNULL(@rechargekeepamt,0),accountdebts=isnull(accountdebts,0)+ISNULL(@rechargedebtamt,0) where cardno=@salecardno and accounttype=CAST(@rechargeaccounttype as int)    
  end    
  else    
  begin    
   insert cardaccount(cardvesting,cardno,accounttype,accountbalance,accountdebts,accountdatefrom,accountdateend,accountremark)    
   values(@compid,@salecardno,CAST(@rechargeaccounttype as int),ISNULL(@rechargekeepamt,0),ISNULL(@rechargedebtamt,0),@saledate,@cutoffdate,'')    
  end    
 end    
 else --����    
 begin    
   update cardaccount set accountbalance=isnull(accountbalance,0)+ISNULL(@rechargekeepamt,0),accountdebts=isnull(accountdebts,0)-ISNULL(@rechargekeepamt,0) where cardno=@salecardno and accounttype=CAST(@rechargeaccounttype as int)    
 end    
 --�����˻���ʷ    
  declare @costaccountseqno  float    
  select @costaccountseqno=MAX(changeseqno)+1 from cardaccountchangehistory where changecardno=@salecardno     
  insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)    
  values(@compid,@salecardno,CAST(@rechargeaccounttype as int),isnull(@costaccountseqno,0),0,@rechargekeepamt,'CZ',@billid,@saledate,@curcardamt)    
  set @costaccountseqno=@costaccountseqno+1    
      
     
 --�����Ƴ���Ϣ    
  declare @proseqno float    
  select @proseqno=MAX(proseqno)+1 from cardproaccount with(nolock) where cardno=@salecardno     
  insert cardproaccount(cardvesting,cardno,projectno,proseqno,propricetype,salecount,costcount,lastcount,saleamt,costamt,lastamt,saledate,cutoffdate,proremark,createbilltype,createbillno)    
  select @compid,@salecardno,saleproid,ISNULL(@proseqno,0)+ISNULL(seleproseqno,0),saleprotype,ISNULL(saleprocount,0)+ISNULL(sendprocount,0),0,ISNULL(saleprocount,0)+ISNULL(sendprocount,0),    
  ISNULL(saleproamt,0),0,ISNULL(saleproamt,0),@saledate,procutoffdate,saleproremark,'CZ',@billid     
  from dsalecardproinfo where salecompid=@compid and salebillid=@billid and salebilltype=2    
      
  if(ISNULL(@acc4totalamt,0)>0)    
  begin    
   if exists(select 1 from cardaccount where cardno=@salecardno and accounttype=4)    
    update cardaccount set accountbalance=isnull(accountbalance,0)+@acc4totalamt where cardno=@salecardno and accounttype=4    
   else    
   begin    
    insert cardaccount(cardvesting,cardno,accounttype,accountbalance,accountdebts,accountdatefrom,accountdateend,accountremark)    
    values(@compid,@salecardno,4,@acc4totalamt,0,@saledate,@cutoffdate,'')    
   end    
   declare @costaccount4lastamt float     
   select top 1 @costaccount4lastamt=(case when changetype in (0,6) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@salecardno  and changeaccounttype=4 order by chagedate desc,changeseqno desc     
   insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)    
   values(@compid,@salecardno,4,isnull(@costaccountseqno,0),0,@acc4totalamt,'CZ',@billid,@saledate,isnull(@costaccount4lastamt,0))    
  end    
end     
go

if exists(select 1 from sysobjects where type='P' and name='upg_handrechargecardbill_card_back')
	drop procedure upg_handrechargecardbill_card_back
go
create procedure upg_handrechargecardbill_card_back    
@compid   varchar(10), --������˾          
@billid   varchar(20) --��������    
as          
begin     
 declare @salecardno    varchar(20)  --��������    
 declare @saledate    varchar(8)  --��������    
 declare @saletime    varchar(9)  --����ʱ��    
     
 declare @rechargetype   int    --���ѷ�ʽ( 0��ֵ ,6����)      
 declare @rechargekeepamt  float   --��ֵ���    
 declare @rechargedebtamt  float   --Ƿ����    
 declare @curcardamt    float   --�춯ǰ���    
 declare @curcarddebtamt   float   --�춯ǰǷ��    
 declare @rechargeaccounttype varchar(10)  --��ֵ�˻�    
 declare @acc4totalamt  float   --�Ƴ��ܶ�    
 declare @carduselife float    
    
     
 select @salecardno=rechargecardno,@saledate=rechargedate,@saletime=rechargetime,@rechargetype=rechargetype,    
   @rechargekeepamt=rechargekeepamt,@rechargedebtamt=rechargedebtamt,@curcardamt=curcardamt,@curcarddebtamt=curcarddebtamt,@rechargeaccounttype=rechargeaccounttype    
 from mcardrechargeinfo with(nolock) where rechargecompid=@compid and rechargebillid=@billid    
     
 select @acc4totalamt=sum(ISNULL(saleproamt,0)) from dsalecardproinfo with(nolock) where salecompid=@compid and salebillid=@billid and salebilltype=2    
     
 --�����˻����    
 if(@rechargetype=0)--��ֵ    
 begin    
   update cardaccount set accountbalance=isnull(accountbalance,0)+ISNULL(@rechargekeepamt,0)*(-1),accountdebts=isnull(accountdebts,0)+ISNULL(@rechargedebtamt,0)*(-1) where cardno=@salecardno and accounttype=CAST(@rechargeaccounttype as int)    
 end    
 else --����    
 begin    
   update cardaccount set accountbalance=isnull(accountbalance,0)+ISNULL(@rechargekeepamt,0)*(-1),accountdebts=isnull(accountdebts,0)-ISNULL(@rechargekeepamt,0)*(-1) where cardno=@salecardno and accounttype=CAST(@rechargeaccounttype as int)    
 end    
 --�����˻���ʷ    
  declare @costaccountseqno  float    
  select @costaccountseqno=MAX(changeseqno)+1 from cardaccountchangehistory where changecardno=@salecardno     
  insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)    
  values(@compid,@salecardno,CAST(@rechargeaccounttype as int),isnull(@costaccountseqno,0),0,isnull(@rechargekeepamt,0)*(-1),'CZ',@billid,@saledate,ISNULL(@curcardamt,0)+ISNULL(@rechargekeepamt,0))    
  set @costaccountseqno=@costaccountseqno+1    
      
     
 --�����Ƴ���Ϣ    
  delete cardproaccount where cardno=@salecardno and createbilltype='CZ' and createbillno=@billid  
    
  if(ISNULL(@acc4totalamt,0)>0)    
  begin    
    update cardaccount set accountbalance=isnull(accountbalance,0)+isnull(@acc4totalamt,0)*(-1) where cardno=@salecardno and accounttype=4      
 declare @costaccount4lastamt float     
 select top 1 @costaccount4lastamt=(case when changetype in (0,6) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@salecardno  and changeaccounttype=4 order by chagedate desc,changeseqno desc     
 insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)    
 values(@compid,@salecardno,4,isnull(@costaccountseqno,0),0,isnull(@acc4totalamt,0)*(-1),'CZ',@billid,@saledate,isnull(@costaccount4lastamt,0))    
  end    
  update mcardrechargeinfo set salebakflag=1 where rechargecompid=@compid and rechargebillid=@billid    
end     
go




-------��Ա���Ƴ̶һ�����----
if exists(select 1 from sysobjects where type='P' and name='upg_handaccountChangebill_card_back')
	drop procedure upg_handaccountChangebill_card_back
go
create procedure upg_handaccountChangebill_card_back  
@compid   varchar(10), --�һ���˾        
@billid   varchar(20), --�һ�����   
@proseqno  float   --�����Ƴ����     
as        
begin   
  
 declare @changecardno    varchar(20)  --�һ�����  
 declare @changedate     varchar(8)  --�һ�����  
 declare @changetime     varchar(9)  --�һ�ʱ��  
 declare @changeaccount    varchar(5)  --�����˻�  
 declare @changeaccountamt   float   --�����˻����  
 declare @inseraccount4amt   float   --�һ��Ƴ��˻����  
   
 select @changecardno=changecardno,@changedate=changedate,@changetime=changetime,@changeaccount=ISNULL(changeaccounttype,0)  
 from mproexchangeinfo with(nolock) where changecompid=@compid and changebillid=@billid  
   
 select @changeaccountamt=SUM(ISNULL(changebyaccountamt,0)),@inseraccount4amt=SUM(isnull(changebyaccountamt,0)+ISNULL(changebyproaccountamt,0)+ISNULL(changebycashamt,0))  
 from  dproexchangeinfo with(nolock) where changecompid=@compid and changebillid=@billid and changeseqno=@proseqno  
   
 --�����˻����  
  if(ISNULL(@changeaccountamt,0)>0)--�����˻�  
  begin  
   update cardaccount set accountbalance=ISNULL(accountbalance,0)-isnull(@changeaccountamt,0)*(-1) where accounttype=@changeaccount and cardno=@changecardno  
  end  
   
  if(ISNULL(@inseraccount4amt,0)>0)--�һ��Ƴ��˻�  
  begin  
   update cardaccount set accountbalance=ISNULL(accountbalance,0)+isnull(@inseraccount4amt,0)*(-1) where accounttype='4' and cardno=@changecardno  
  end  
 --�����˻���ʷ  
  declare @costaccountseqno  float  
  declare @curcardamt    float  
  select @costaccountseqno=MAX(changeseqno)+1 from cardaccountchangehistory where changecardno=@changecardno   
  if(ISNULL(@changeaccountamt,0)>0)--�����˻�  
  begin  
   set @curcardamt=0  
   select top 1 @curcardamt=(case when changetype in (0,6,7,8,9,10,11) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@changecardno  and changeaccounttype=CAST(@changeaccount as int) order by chagedate desc,changeseqno desc   
   --�����˻���ʷ   
   insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)  
   values(@compid,@changecardno,CAST(@changeaccount as int),isnull(@costaccountseqno,0),12,isnull(@changeaccountamt,0)*(-1),'DH',@billid,@changedate,@curcardamt)  
   set @costaccountseqno=@costaccountseqno+1  
  end  
   
  if(ISNULL(@inseraccount4amt,0)>0)--�����Ƴ��˻�  
  begin  
   set @curcardamt=0  
   select top 1 @curcardamt=(case when changetype in (0,6,7,8,9,10,11) then ISNULL(changebeforeamt,0)+isnull(changeamt,0) else ISNULL(changebeforeamt,0)-isnull(changeamt,0) end ) from cardaccountchangehistory where changecardno=@changecardno  and changeaccounttype=4 order by chagedate desc,changeseqno desc   
   insert cardaccountchangehistory(changecompid,changecardno,changeaccounttype,changeseqno,changetype,changeamt,changebilltype,changebillno,chagedate,changebeforeamt)  
   values(@compid,@changecardno,4,isnull(@costaccountseqno,0),11,isnull(@inseraccount4amt,0)*(-1),'DH',@billid,@changedate,@curcardamt)  
   set @costaccountseqno=@costaccountseqno+1  
  end  
  --�����Ƴ���Ϣ  
      
  delete c from mproexchangeinfo a,dproexchangeinfo b,cardproaccount c   
    where a.changecompid=b.changecompid and a.changebillid=b.changebillid  
     and b.changecompid=@compid and b.changebillid=@billid and b.changeseqno=@proseqno  
    and a.changecardno=c.cardno and b.changeproid=c.projectno and a.changebillid=c.createbillno   
    and c.createbilltype='LCDH' and c.lastcount=b.changeprocount and ( c.createseqno=@proseqno  or ISNULL(c.createseqno,0)=0)   
    
 --�������ȯ״̬  
  update nointernalcardinfo set cardstate=1,usedate=''  
  from nointernalcardinfo a,dproexchangeinfo b  
  where b.changecompid=@compid and b.changebillid=@billid and b.nointernalcardno=a.cardno  
  --���÷����׼λ  
 -- update mproexchangeinfo  set backcsflag=1 where  changecompid=@compid and changebillid=@billid  
  update dproexchangeinfo  set salebakflag=1 where  changecompid=@compid and changebillid=@billid and changeseqno=@proseqno  
   
end   
go  


-------��Ա��ת������----
if exists(select 1 from sysobjects where type='P' and name='upg_handcardchangebill_back')
	drop procedure upg_handcardchangebill_back
go
create procedure upg_handcardchangebill_back  
@compid   varchar(10), --�һ���˾        
@billid   varchar(20)  --�һ�����     
as        
begin   
 declare @changetype  int    --ת������  
 declare @oldcardno  varchar(20)  --ת���Ͽ���  
 declare @newcardno  varchar(20)  --ת���¿���  
 declare @rechargeamt float   --��ֵ���  
 declare @detamt   float   --Ƿ����  
 declare @oldkeepamt  float   --ԭ���  
 declare @olddetamt  float   --ԭǷ����  
  --��ȡ������Ϣ  
  select @changetype=changetype,@oldcardno=changebeforcardno,  
         @oldkeepamt=curaccountkeepamt,@olddetamt=curaccountdebtamt,  
         @rechargeamt=changefillamt,@detamt=changdebtamt,@newcardno=changeaftercardno  
  from mcardchangeinfo where changecompid=@compid and changebillid=@billid  
    
  if(isnull(@changetype,0)=0)  --�ۿ�ת��  
  begin  
    --����Ա��Ϣ��ԭ���Ͽ�  
    delete memberinfo where memberno=@oldcardno  
    update memberinfo set memberno=@oldcardno where memberno=@newcardno  
    --��ԭ�ȵ��˻���ʷ���  
    delete cardaccountchangehistory where changecardno=@newcardno and changebilltype='ZK' and changecompid=@compid and changebillno=@billid   
    --�ٽ�ԭ�еĿ���ʷת�ƹ�ȥ  
    update cardaccountchangehistory set changecardno=@oldcardno where changecardno=@newcardno  
    --��������ʷת�ƹ�ȥ  
    update cardtransactionhistory set transactioncardno=@oldcardno where transactioncardno=@newcardno  
    --���춯��ʷת�ƹ�ȥ  
    delete cardchangehistory where changecardno=@oldcardno  
    delete cardchangehistory where changecardno=@newcardno  
  
    --���Ͽ���״̬��Ϊ����״̬  
    update cardinfo set cardstate=4 where cardno=@oldcardno  
     --���¿���״̬��Ϊδ����  
    update cardinfo set cardstate=1 where cardno=@newcardno  
     delete cardsoninfo where parentcardno=@newcardno  
    --���Ͽ��˻���ԭ  
    if not exists(select 1 from cardaccount where   cardno = @oldcardno and accounttype=2)        
    begin        
    insert into cardaccount(cardvesting,cardno,accounttype,accountbalance,accountdebts)         
    values(@compid,@oldcardno,2,ISNULL(@oldkeepamt,0),ISNULL(@olddetamt,0))        
    end      
    else  
    begin  
    update cardaccount set accountbalance=ISNULL(@oldkeepamt,0),accountdebts=ISNULL(@olddetamt,0) where cardno=@oldcardno and accounttype=2  
    end  
      
    update cardaccount set cardno= @oldcardno where  cardno=@newcardno  and ISNULL(accounttype,0)<>2  
    --���Ƴ��˻����µ��Ͽ�  
    delete cardproaccount where cardno=@oldcardno  
    update cardproaccount set cardno=@oldcardno where cardno=@newcardno  
    --���¿��˻���0  
    update cardaccount set accountbalance=0 where cardno=@newcardno   
  end  
  else if(isnull(@changetype,0)=1)  --�չ�ת��  
  begin  
    --����Ա��Ϣ��ԭ���Ͽ�  
    delete memberinfo where memberno=@oldcardno  
    update memberinfo set memberno=@oldcardno where memberno=@newcardno  
    --��ԭ�ȵ��˻���ʷ���  
    delete cardaccountchangehistory where changecardno=@newcardno and changebilltype='ZK' and changecompid=@compid and changebillno=@billid   
    --�ٽ�ԭ�еĿ���ʷת�ƹ�ȥ  
    update cardaccountchangehistory set changecardno=@oldcardno where changecardno=@newcardno  
    --��������ʷת�ƹ�ȥ  
    update cardtransactionhistory set transactioncardno=@oldcardno where transactioncardno=@newcardno  
     delete cardchangehistory where changecardno=@oldcardno  
     delete cardchangehistory where changecardno=@newcardno  
    --���Ͽ���״̬��Ϊ����״̬  
    update cardinfo set cardstate=4 where cardno=@oldcardno  
     --���¿���״̬��Ϊδ����  
    update cardinfo set cardstate=1 where cardno=@newcardno  
    delete cardsoninfo where parentcardno=@newcardno  
    --���Ͽ��˻���ԭ  
    if not exists(select 1 from cardaccount where   cardno = @oldcardno and accounttype=5)        
    begin        
    insert into cardaccount(cardvesting,cardno,accounttype,accountbalance,accountdebts)         
    values(@compid,@oldcardno,5,ISNULL(@oldkeepamt,0),ISNULL(@olddetamt,0))        
    end      
    else  
    begin  
    update cardaccount set accountbalance=ISNULL(@oldkeepamt,0),accountdebts=ISNULL(@olddetamt,0) where cardno=@oldcardno and accounttype=5  
    end  
    --���¿��˻���0  
    update cardaccount set accountbalance=0 where cardno=@newcardno   
  end  
  else if(isnull(@changetype,0)=2)  --����ת��  
  begin  
    --��ԭ�ȵ��˻���ʷ���  
    delete cardaccountchangehistory where changecardno=@newcardno and changebilltype='ZK' and changecompid=@compid and changebillno=@billid   
    --���¿���״̬��Ϊδ����  
    update cardinfo set cardstate=1 where cardno=@newcardno  
    delete cardsoninfo where parentcardno=@newcardno  
    delete cardchangehistory where changecardno=@newcardno  
    delete cardtransactionhistory where transactioncardno=@newcardno  
    delete memberinfo where memberno=@newcardno  
    --���¿��˻���0  
    update cardaccount set accountbalance=0 where cardno=@newcardno   
  end  
  update mcardchangeinfo set salebakflag=1 where changecompid=@compid and changebillid=@billid  
       
end  
go
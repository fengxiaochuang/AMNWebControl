alter procedure upg_hand_personManger_anon          
(        
 @compid  varchar(10),                         
 @billNo  varchar(20)           
)        
as        
begin        
	--��ǰ����        
	declare @curdate varchar(10)            
	select @curdate=substring(convert(varchar(20),getdate(),102),1,4) + substring(convert(varchar(20),getdate(),102),6,2)+ substring(convert(varchar(20),getdate(),102),9,2)                    
         
	declare @oldcompid   varchar(10)   --ԭ�ŵ���                        
	declare @oldstaffno   varchar(20)         --ԭ����             
	declare @olddepartment  varchar(10)   --ԭ����           
	declare @oldposition  varchar(10)   --ԭְλ             
	declare @oldsalary   float    --ԭ����          
	declare @oldyejitype  varchar(5)   --�춯ǰҵ����ʽ 1-����ҵ��  2-����ҵ��  3-��ҵ��        
    declare @oldyejirate  float    --�춯ǰҵ��ϵ��        
    declare @oldyejiamt   float    --�춯ǰҵ������            
            
    declare @newcompid   varchar(10)   --���ŵ���             
	declare @newstaffno   varchar(20)   --�¹���         
	declare @newdepartment  varchar(10)   --�²��ű��            
	declare @newposition  varchar(10)   --��ְλ           
	declare @newsalary   float    --ԭ����          
	declare @newyejitype  varchar(5)   --�춯ǰҵ����ʽ 1-����ҵ��  2-����ҵ��  3-��ҵ��        
    declare @newyejirate  float    --�춯ǰҵ��ϵ��        
    declare @newyejiamt   float    --�춯ǰҵ������            
    declare @leaveltype   int     --��ְ����  1 ������ְ 2 �Զ���ְ        
	declare @note			varchar(80)   --��ע               
	declare @billtype		int     --��������  0-н�ʵ��� 1--��ְ���� 2--��ְ���� 3--�ػع�˾���� 4--�������,5--�������,6--������        
	declare @validDate		varchar(8)          --��Ч����        
	declare @inlineno		varchar(20)   --Ա���ڲ����            
	declare @changemark		varchar(200)   --Ա���ڲ����            
    declare @roleid			varchar(10)		--��ɫ���      
         
	select @oldcompid=appchangecompid, @oldstaffno=changestaffno,@olddepartment=beforedepartment,@oldposition=beforepostation,@oldsalary=beforesalary,        
        @oldyejitype=beforeyejitype,@oldyejirate=beforeyejirate,@oldyejiamt=beforeyejiamt,@newstaffno=afterstaffno,@newcompid=aftercompid,        
        @newdepartment=afterdepartment,@newposition=afterpostation,@newsalary=aftersalary,@newyejitype=afteryejitype,@newyejirate=afteryejirate,        
        @newyejiamt=afteryejiamt,@leaveltype=leaveltype,@note=remark,@validDate=validatestartdate,@inlineno=staffmangerno,@billtype=changetype,@changemark=remark        
	from staffchangeinfo where changecompid=@compid and changebillid=@billNo and billflag=3        
         
	--������ʷ�㷨 0�������  1��������  2��н�ʵ���  3:Ա����ְ 4����ְ����  5���ػع�˾        
	if(@billtype = 2)--��ְ����                       
	begin              
		insert staffhistory(manageno,changetype,oldcompid,oldempid,olddepid,oldpostion,oldsalary,oldyjtype, oldyjrate,oldyjamt,newcompid,newempid,newdepid,newpostion,newsalary,newyjtype,newyjrate,newyjramt,effectivedate,optionbill,changemark)                
		values(@inlineno,4,@oldcompid,@oldstaffno,@olddepartment,@oldposition,@oldsalary,@oldyejitype,@oldyejirate,@oldyejiamt,@newcompid,@newstaffno,        
		@newdepartment,@newposition,@newsalary,@newyejitype,@newyejirate,@newyejiamt,@curdate,@billNo,@changemark)        
          
		update staffinfo set curstate='2',arrivaldate=@curdate where manageno=@inlineno        
		update staffchangeinfo set billflag=8  where changecompid=@compid and changebillid=@billNo
		
		--����ְλ������ɫ�˻�
		select @roleid=roleno from sysroletoposition where position=@newposition  
		if(ISNULL(@roleid,'')<>'')
		begin
			delete sysuserinfo where userno=@newstaffno
			insert sysuserinfo(userno,userpwd,enableflag,userrole,frominnerno,fromcompno)
			values(@newstaffno,'42a12b9150770ead',1,@roleid,@inlineno,@newcompid) 
			delete usereditright where userno=@newstaffno
			delete useroverall where userno=@newstaffno 
			insert useroverall(userno,modetype,modevalue) values(@newstaffno,'1',@newcompid) 
		end 
		      
    end            
    else if(@billtype = 1) --��ְ����                       
    begin                  
		insert staffhistory(manageno,changetype,oldcompid,oldempid,olddepid,oldpostion,oldsalary,oldyjtype, oldyjrate,oldyjamt,newcompid,newempid,newdepid,newpostion,newsalary,newyjtype,newyjrate,newyjramt,effectivedate,optionbill,changemark)                
		values(@inlineno,3,@oldcompid,@oldstaffno,@olddepartment,@oldposition,@oldsalary,@oldyejitype,@oldyejirate,@oldyejiamt,'99999',@inlineno+'LZ',        
				@olddepartment,@oldposition,@oldsalary,@oldyejitype,@oldyejirate,@oldyejiamt,@curdate,@billNo,@changemark)        
        update staffinfo set curstate='3',compno='99999',staffno=@inlineno+'LZ',leavedate=@curdate,leveltype=@leaveltype,fillno=REPLACE(fillno,'FN','LZ')    
			where manageno=@inlineno  and  compno= @oldcompid  
		update staffinfo set curstate='3',compno='99999',staffno=@inlineno+'LZ',leavedate=@curdate,leveltype=@leaveltype ,fillno=REPLACE(fillno,'FN','LZ')   
			where manageno=@inlineno and  ISNULL(stafftype,0)=1  
		---------------------------------------------------------------              
		delete sysuserinfo where   frominnerno=@inlineno         
		delete useroverall where userno=@oldstaffno    
        update staffchangeinfo set billflag=8  where changecompid=@compid and changebillid=@billNo                  
	end           
	else if(@billtype = 3) --�ػع�˾        
	begin        
		insert staffhistory(manageno,changetype,oldcompid,oldempid,olddepid,oldpostion,oldsalary,oldyjtype, oldyjrate,oldyjamt,newcompid,newempid,newdepid,newpostion,newsalary,newyjtype,newyjrate,newyjramt,effectivedate,optionbill,changemark)                
		values(@inlineno,5,@oldcompid,@oldstaffno,@olddepartment,@oldposition,@oldsalary,@oldyejitype,@oldyejirate,@oldyejiamt,@newcompid,@newstaffno,        
        @newdepartment,@newposition,@newsalary,@newyejitype,@newyejirate,@newyejiamt,@curdate,@billNo,@changemark)        
        
        declare @fillno varchar(20)
		declare @needfid int	
		select @needfid=MIN(needfid) from (select cast(SUBSTRING(fillno,4,6) as int ) as curfid, row_number() over (order by fillno) as needfid
		from staffinfo where ISNULL(fillno,'') like 'FN%' ) as curresult where curfid<>needfid
		if(ISNULL(@needfid,0)=0)
			select @needfid=max(cast(SUBSTRING(fillno,4,6) as int))+1 from staffinfo where ISNULL(fillno,'') like 'FN%' 
		if(ISNULL(@needfid,0)<10)
			set @fillno='FN10000'+cast(@needfid as varchar(1))
		else if(ISNULL(@needfid,0)<100 and ISNULL(@needfid,0)>=10 )
			set @fillno='FN1000'+cast(@needfid as varchar(2))
		else if(ISNULL(@needfid,0)<1000 and ISNULL(@needfid,0)>=100 )
			set @fillno='FN100'+cast(@needfid as varchar(3))
		else if(ISNULL(@needfid,0)<10000 and ISNULL(@needfid,0)>=1000 )
			set @fillno='FN10'+cast(@needfid as varchar(4))
				
		update staffinfo set curstate='2',compno=@newcompid,staffno=@newstaffno,department=@newdepartment,position=@newposition,basesalary=@newsalary,        
                       resulttye=@newyejitype,resultrate=@newyejirate,baseresult=@newyejiamt,arrivaldate=@curdate,fillno=@fillno        
		where manageno=@inlineno and  isnull(stafftype,0)=0          
		---------------------------------------------------------------              
          
        update staffchangeinfo set billflag=8  where changecompid=@compid and changebillid=@billNo              
	end        
	else if(@billtype = 5) --�������        
	begin        
		insert staffhistory(manageno,changetype,oldcompid,oldempid,olddepid,oldpostion,oldsalary,oldyjtype, oldyjrate,oldyjamt,newcompid,newempid,newdepid,newpostion,newsalary,newyjtype,newyjrate,newyjramt,effectivedate,optionbill,changemark)                
		values(@inlineno,0,@oldcompid,@oldstaffno,@olddepartment,@oldposition,@oldsalary,@oldyejitype,@oldyejirate,@oldyejiamt,@newcompid,@newstaffno,        
        @newdepartment,@newposition,@newsalary,@newyejitype,@newyejirate,@newyejiamt,@curdate,@billNo,@changemark)        
        
		update staffinfo set staffno=@newstaffno,department=@newdepartment,position=@newposition,basesalary=@newsalary,        
                       resulttye=@newyejitype,resultrate=@newyejirate,baseresult=@newyejiamt        
		where manageno=@inlineno and  isnull(stafftype,0)=0       
		---------------------------------------------------------------       
        update staffchangeinfo set billflag=8  where changecompid=@compid and changebillid=@billNo            
	end        
	else if(@billtype = 6) --�������        
	begin        
		insert staffhistory(manageno,changetype,oldcompid,oldempid,olddepid,oldpostion,oldsalary,oldyjtype, oldyjrate,oldyjamt,newcompid,newempid,newdepid,newpostion,newsalary,newyjtype,newyjrate,newyjramt,effectivedate,optionbill,changemark)                
		values(@inlineno,1,@oldcompid,@oldstaffno,@olddepartment,@oldposition,@oldsalary,@oldyejitype,@oldyejirate,@oldyejiamt,@newcompid,@newstaffno,        
        @newdepartment,@newposition,@newsalary,@newyejitype,@newyejirate,@newyejiamt,@curdate,@billNo,@changemark)        
        
		update staffinfo set compno=@newcompid,staffno=@newstaffno,department=@newdepartment,position=@newposition,basesalary=@newsalary,        
                       resulttye=@newyejitype,resultrate=@newyejirate,baseresult=@newyejiamt        
		where manageno=@inlineno  and  isnull(stafftype,0)=0         
		---------------------------------------------------------------              
		delete sysuserinfo where   frominnerno=@inlineno         
		delete useroverall where userno=@oldstaffno    
        update staffchangeinfo set billflag=8  where changecompid=@compid and changebillid=@billNo            
	end              
                      
end 
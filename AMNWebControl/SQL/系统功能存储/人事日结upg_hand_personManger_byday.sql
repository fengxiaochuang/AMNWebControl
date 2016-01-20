alter procedure upg_hand_personManger_byday          
(        
 @fromdate varchar(8),                        
 @todate  varchar(8)        
)        
as        
begin        
 CREATE tAbLE    #staffchangeinfo             
 (        
  changecompid   varchar(10)     not null, --��˾��        
  changebillid   varchar(20)  not null, --���뵥��        
  changetype    int    not null, --��������  0-н�ʵ��� 1--��ְ���� 2--��ְ���� 3--�ػع�˾���� 4--�������,5--�������,6--������        
  changestaffno   varchar(20)   null, --�춯ǰԱ�����        
  appchangecompid   varchar(10)   null, --�춯ǰ���빫˾        
  staffpcid    varchar(20)   null, --Ա�����֤        
  staffphone    varchar(20)   null,   --�ֻ�����        
  staffmangerno   varchar(20)   null,   --Ա���ڲ����        
  changedate    varchar(8)   null, --��������        
  validatestartdate  varchar(8)   null, --��changetype=0 ��ʱ���ֵ�ǿ������õ�����         
               --��changetype=1 ��ʱ���ֵ��ʵ����ְ����         
               --��changetype=2 ��ʱ���ֵ��ʵ����ְ����         
               --��changetype=3 ��ʱ���ֵ��ʵ���ػع�˾����         
               --��changetype=4 ��ʱ���ֵ�� ��ٿ�ʼ����         
               --��changetype=5 ��ʱ���ֵ�Ǳ��������ʼ����         
               --��changetype=6 ��ʱ���ֵ�ǿ�������ʼ����         
  validateenddate   varchar(8)   null, --��changetype=4 ��ʱ���ֵ�� ��ٽ������� --��fhb02i=3��ʱ���ֵ�ؼ�ʱ��        
  beforedepartment  varchar(20)   null, --�춯ǰ����        
  beforepostation   varchar(10)   null, --�춯ǰְλ        
  beforesalary   float    null, --�춯ǰн��        
  beforesalarytype  int     null, --�춯ǰ 0��˰ǰ 1 ˰��          
  beforeyejitype   varchar(5)   null,   --�춯ǰҵ����ʽ 1-����ҵ��  2-����ҵ��  3-��ҵ��        
  beforeyejirate   float    null,   --�춯ǰҵ��ϵ��        
  beforeyejiamt   float    null,   --�춯ǰҵ������        
  aftercompid    varchar(20)   null, --�춯���ŵ�        
  afterstaffno   varchar(20)   null, --�춯�󹤺�        
  afterdepartment   varchar(20)   null, --�춯����        
  afterpostation   varchar(10)   null, --�춯��ְλ        
  aftersalary    float    null, --�춯��н��        
  aftersalarytype   int     null, --�춯�� 0��˰ǰ 1 ˰��          
  afteryejitype   varchar(5)   null,   --�춯��ҵ����ʽ 1-����ҵ��  2-����ҵ��  3-��ҵ��        
  afteryejirate   float    null,   --�춯��ҵ��ϵ��        
  afteryejiamt   float    null,   --�춯��ҵ������        
  leaveltype    int     null, --ְ����  1 ������ְ 2 �Զ���ְ        
  remark     varchar(200)  null, --��ע        
          
 )        
 insert #staffchangeinfo(changecompid,changebillid,changetype,changestaffno,appchangecompid,staffpcid,staffphone,staffmangerno,        
 changedate,validatestartdate,validateenddate,beforedepartment,beforepostation,beforesalary,beforeyejiamt,beforeyejitype,beforeyejirate,        
 aftercompid,afterstaffno,afterdepartment,afterpostation,aftersalary,afteryejiamt,afteryejitype,afteryejirate,remark,leaveltype)        
 select changecompid,changebillid,changetype,changestaffno,appchangecompid,staffpcid,staffphone,staffmangerno,        
 changedate,validatestartdate,validateenddate,beforedepartment,beforepostation,beforesalary,beforeyejiamt,beforeyejitype,beforeyejirate,        
 aftercompid,afterstaffno,afterdepartment,afterpostation,aftersalary,afteryejiamt,afteryejitype,afteryejirate,remark,leaveltype        
 from staffchangeinfo where validatestartdate between @fromdate and @todate and billflag=3        
         
 declare @changecompid  varchar(10)   --�춯�ŵ�        
 declare @changebillid  varchar(20)   --�춯����        
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
 declare @note    varchar(80)   --��ע               
 declare @billtype   int     --��������  0-н�ʵ��� 1--��ְ���� 2--��ְ���� 3--�ػع�˾���� 4--�������,5--�������,6--������        
 declare @validDate   varchar(8)          --��Ч����        
 declare @inlineno   varchar(20)   --Ա���ڲ����        
        
         
 declare cursor_staffchange cursor                  
 for            
  select changecompid,changebillid,changetype,changestaffno,appchangecompid,staffmangerno,validatestartdate,beforedepartment,beforepostation,beforesalary,beforeyejitype,beforeyejirate,beforeyejiamt,        
    aftercompid,afterstaffno,afterdepartment,afterpostation,aftersalary,afteryejitype,afteryejirate,afteryejiamt,remark,leaveltype        
  from #staffchangeinfo        
 open cursor_staffchange        
 fetch cursor_staffchange into @changecompid,@changebillid,@billtype, @oldstaffno,@oldcompid,@inlineno,@validDate,@olddepartment,@oldposition,@oldsalary,@oldyejitype,@oldyejirate,@oldyejiamt,        
    @newcompid,@newstaffno ,@newdepartment,@newposition,@newsalary,@newyejitype,@newyejirate,@newyejiamt,@note,@leaveltype        
 while @@fetch_status=0                        
 begin          
   --������ʷ�㷨 0�������  1��������  2��н�ʵ���  3:Ա����ְ 4����ְ����  5���ػع�˾        
   if(@billtype = 2)--��ְ����                       
   begin              
    insert staffhistory(manageno,changetype,oldcompid,oldempid,olddepid,oldpostion,oldsalary,oldyjtype, oldyjrate,oldyjamt,newcompid,newempid,newdepid,newpostion,newsalary,newyjtype,newyjrate,newyjramt,effectivedate,optionbill,changemark)                
    values(@inlineno,4,@oldcompid,@oldstaffno,@olddepartment,@oldposition,@oldsalary,@oldyejitype,@oldyejirate,@oldyejiamt,@newcompid,@newstaffno,        
    @newdepartment,@newposition,@newsalary,@newyejitype,@newyejirate,@newyejiamt,@validDate,@changebillid,@note)        
            
    update staffinfo set curstate='2',arrivaldate=@validDate where manageno=@inlineno   
    update staffchangeinfo set billflag=8  where changecompid=@changecompid and changebillid=@changebillid         
            
                           
   end            
   else if(@billtype = 1) --��ְ����                       
   begin                  
  insert staffhistory(manageno,changetype,oldcompid,oldempid,olddepid,oldpostion,oldsalary,oldyjtype, oldyjrate,oldyjamt,newcompid,newempid,newdepid,newpostion,newsalary,newyjtype,newyjrate,newyjramt,effectivedate,optionbill,changemark)                
  values(@inlineno,3,@oldcompid,@oldstaffno,@olddepartment,@oldposition,@oldsalary,@oldyejitype,@oldyejirate,@oldyejiamt,'99999',@inlineno+'LZ',        
     @olddepartment,@oldposition,@oldsalary,@oldyejitype,@oldyejirate,@oldyejiamt,@validDate,@changebillid,@note)        
         
  update staffinfo set curstate='3',compno='99999',staffno=@inlineno+'LZ',leavedate=@validDate,leveltype=@leaveltype 
  where manageno=@inlineno and  compno= @oldcompid
   update staffinfo set curstate='3',compno='99999',staffno=@inlineno+'LZ',leavedate=@validDate,leveltype=@leaveltype 
  where manageno=@inlineno and  ISNULL(stafftype,0)=1       
  ---------------------------------------------------------------              
  delete sysuserinfo where   frominnerno=@inlineno       
  delete useroverall where userno=@oldstaffno    
  update staffchangeinfo set billflag=8  where changecompid=@changecompid and changebillid=@changebillid                  
   end           
   else if(@billtype = 3) --�ػع�˾        
   begin        
    insert staffhistory(manageno,changetype,oldcompid,oldempid,olddepid,oldpostion,oldsalary,oldyjtype, oldyjrate,oldyjamt,newcompid,newempid,newdepid,newpostion,newsalary,newyjtype,newyjrate,newyjramt,effectivedate,optionbill,changemark)                
    values(@inlineno,5,@oldcompid,@oldstaffno,@olddepartment,@oldposition,@oldsalary,@oldyejitype,@oldyejirate,@oldyejiamt,@newcompid,@newstaffno,        
          @newdepartment,@newposition,@newsalary,@newyejitype,@newyejirate,@newyejiamt,@validDate,@changebillid,@note)        
        
    update staffinfo set curstate='2',compno=@newcompid,staffno=@newstaffno,department=@newdepartment,position=@newposition,basesalary=@newsalary,        
          resulttye=@newyejitype,resultrate=@newyejirate,baseresult=@newyejiamt ,arrivaldate=@validDate       
     where manageno=@inlineno   and  isnull(stafftype,0)=0          
    ---------------------------------------------------------------              
            
    update staffchangeinfo set billflag=8  where changecompid=@changecompid and changebillid=@changebillid              
   end        
   else if(@billtype = 5) --�������        
   begin        
    insert staffhistory(manageno,changetype,oldcompid,oldempid,olddepid,oldpostion,oldsalary,oldyjtype, oldyjrate,oldyjamt,newcompid,newempid,newdepid,newpostion,newsalary,newyjtype,newyjrate,newyjramt,effectivedate,optionbill,changemark)                
    values(@inlineno,0,@oldcompid,@oldstaffno,@olddepartment,@oldposition,@oldsalary,@oldyejitype,@oldyejirate,@oldyejiamt,@newcompid,@newstaffno,        
          @newdepartment,@newposition,@newsalary,@newyejitype,@newyejirate,@newyejiamt,@validDate,@changebillid,@note)        
        
    update staffinfo set staffno=@newstaffno,department=@newdepartment,position=@newposition,basesalary=@newsalary,        
          resulttye=@newyejitype,resultrate=@newyejirate,baseresult=@newyejiamt        
     where manageno=@inlineno    and  isnull(stafftype,0)=0         
    ---------------------------------------------------------------              
            
    update staffchangeinfo set billflag=8  where changecompid=@changecompid and changebillid=@changebillid            
   end        
   else if(@billtype = 6) --�������        
   begin        
  insert staffhistory(manageno,changetype,oldcompid,oldempid,olddepid,oldpostion,oldsalary,oldyjtype, oldyjrate,oldyjamt,newcompid,newempid,newdepid,newpostion,newsalary,newyjtype,newyjrate,newyjramt,effectivedate,optionbill,changemark)                
  values(@inlineno,1,@oldcompid,@oldstaffno,@olddepartment,@oldposition,@oldsalary,@oldyejitype,@oldyejirate,@oldyejiamt,@newcompid,@newstaffno,        
          @newdepartment,@newposition,@newsalary,@newyejitype,@newyejirate,@newyejiamt,@validDate,@changebillid,@note)        
        
  update staffinfo set compno=@newcompid,staffno=@newstaffno,department=@newdepartment,position=@newposition,basesalary=@newsalary,        
          resulttye=@newyejitype,resultrate=@newyejirate,baseresult=@newyejiamt        
  where manageno=@inlineno   and  isnull(stafftype,0)=0         
  ---------------------------------------------------------------              
  delete sysuserinfo where   frominnerno=@inlineno       
  delete useroverall where userno=@oldstaffno       
  update staffchangeinfo set billflag=8  where changecompid=@changecompid and changebillid=@changebillid            
   end              
          
  fetch cursor_staffchange into @changecompid,@changebillid,@billtype, @oldstaffno,@oldcompid,@inlineno,@validDate,@olddepartment,@oldposition,@oldsalary,@oldyejitype,@oldyejirate,@oldyejiamt,        
    @newcompid,@newstaffno ,@newdepartment,@newposition,@newsalary,@newyejitype,@newyejirate,@newyejiamt,@note,@leaveltype        
 end                        
 close cursor_staffchange                        
 deallocate cursor_staffchange               
 drop table #staffchangeinfo        
end 
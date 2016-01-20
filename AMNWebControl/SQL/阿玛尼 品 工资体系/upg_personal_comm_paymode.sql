alter procedure upg_personal_comm_paymode(                                      
 @compid    varchar(10), -- ��˾��                                      
 @fromdate   varchar(10), -- ��ʼ����                                      
 @todate    varchar(10), -- ��������      
 @fromempinno  varchar(20), -- ��ѯ��ʼ��Ա�ڲ����               
 @toempinno   varchar(20)  -- ��ѯ������Ա�ڲ����       
)                                                                         
as                                      
begin                                    
	create table #work_detail      
	(      
		  seqno					int identity		NOT NULL,             
		  person_inid			varchar(20)			NULL, --Ա���ڲ����      
		  action_id				int					NULL, --��������      
		  srvdate				varchar(10)			NULL, --����      
		  code					varchar(20)			NULL, --��Ŀ����,���ǿ���,��Ʒ��      
		  name					varchar(40)			NULL, --����      
		  payway				varchar(20)			NULL, --֧����ʽ      
		  billamt				float				NULL, --Ӫҵ���      
		  ccount				float				NULL, --����      
		  cost					float				NULL, --�ɱ�      
		  staffticheng			float				NULL, --���      
		  staffyeji				float				NULL, --��ҵ��     
		  staffshareyeji		float				NULL, --������
		  prj_type				varchar(20)			NULL, --��Ŀ���      
		  cls_flag				int					NULL, --1:��Ŀ 2:��Ʒ 3:��      
		  billid				varchar(20)			NULL, --����      
		  paycode				varchar(20)			NULL, --֧������      
		  compid				varchar(10)			NULL, --��˾��      
		  cardid				varchar(20)			NULL, --��Ա����      
		  cardtype				varchar(20)			NULL, --��Ա������      
		  postation				varchar(10)			NULL, --ְλ 
		  arrivaldmonth			int					NULL, --��ְ�·�
		  csitemstate			int					NULL,		--�Ƿ���	0 �� 1 ��� 2 δ��� 
		  billinsertype			int					NULL,	--��ֵ���췽 1 ���� 2 ���� 3���� 
		  costpricetype			int					NULL,		--�Ƿ�Ϊ���������	0 ���� 1 �� 
	)           
	exec upg_prepare_yeji_detail @compid,@fromdate, @todate,@fromempinno, @toempinno        


    declare @isNewComdMode	int	--�Ƿ�����ģʽ
    set @isNewComdMode=0
    if exists(select 1 from compchaininfo where curcomp in ('0010104','0010102') and relationcomp=@compid and @compid not in ('028','035') )
	begin
		set @isNewComdMode=1
    end
    else
    begin
		if(@todate>'20140531')
		begin
			set @isNewComdMode=1
		end
		else
		begin
			update #work_detail set staffyeji=ISNULL(staffshareyeji,0) where action_id  in ('1','2','3')
		end
    end
    
    declare @SP105 varchar(2)
    select @SP105=paramvalue from sysparaminfo where compid=@compid and paramid='SP105'

	--Ĭ����ְ����
    update   #work_detail set arrivaldmonth=datediff(month,arrivaldate,@todate)
    from  #work_detail,staffinfo 
    where person_inid=manageno
    
   --�������� 
   
   UPDATE #work_detail set arrivaldmonth=(select MAX(isnull(effectivedate,'')) from staffhistory c where person_inid=c.manageno and c.changetype in (0,1) and c.oldpostion not in  ('003','006','007','00701','00702')  and isnull(newpostion,'')='003')
   from #work_detail a,staffhistory b
   where a.person_inid=b.manageno and  b.changetype in (0,1) and b.oldpostion not in  ('003','006','007','00701','00702')  and isnull(newpostion,'')='003'
   
   --�ػع�˾�Ĳ�����ְ����
   UPDATE a 
   set arrivaldmonth='20130101'
   from #work_detail a,staffhistory b 
   where person_inid=manageno and changetype =5 and isnull(newpostion,'') in ('003','006','007','00701','00702')  and b.oldpostion  in  ('003','006','007','00701','00702') 

    
	update #work_detail set payway=parentcodevalue       
	from #work_detail,commoninfo      
	where infotype='ZFFS' and parentcodekey=paycode      
       
       
	update #work_detail set cardtype='' where cardtype='ZK' and paycode not in ('4','17')      
       
	create table #empinfobydate(                                      
		seqno  int identity  not null,                          
		compid  varchar(10)   null,                              
		inid  varchar(20)   null,                                      
		empid  varchar(20)   null,                                      
		datefrom varchar(8)   null,                                      
		dateto  varchar(8)   null,                                      
		position varchar(10)   null,                                      
		salary  float    null,                                      
		sharetype varchar(5)   null,                                      
		sharerate float    null,                                      
		deducttax int     null,                                       
	  )                             
                         
    insert into #empinfobydate(compid,inid,empid,datefrom,dateto,position,salary,sharetype,sharerate,deducttax)                                 
	exec upg_get_empinfo_by_date_comps @compid,@fromdate,@todate     
    --�ŵ�ģʽ      
	declare @comptypebyfinger varchar(5)                        
	select  @comptypebyfinger=ISNULL(compmode,'1') from companyinfo where compno=@compid         
                                         
	declare @empPostion varchar(10)                                                    
	declare @tmpSeqId int                                                              
	declare @tmpEmpId varchar(20)                                                              
	declare @tmpItem varchar(10)                                                              
	declare @tmpYeji float                                                              
	declare @tmpPrjId varchar(20)                                                              
	declare @tmpDate varchar(8)                                                              
	declare @paycode varchar(10)                            
	declare @emp_total_yeji float                                             
                                              
	declare @GOODS_TYPE varchar(5)                                            
	declare @PROJECT_COST float                                          
	declare @Performance_Ratio float                                          
	declare @Wage_Rates float                                          
	declare @CARD_SALE_RATE float                                       
	set @CARD_SALE_RATE=0.04                                          
	declare @PROJECT_TYPE varchar(5)                         
	declare @GOODS_SALE_RATE_buty float                                          
	declare @GOODS_SALE_RATE_hair float                                        
	declare @GOODS_SALE_RATE_finger float --�����۲�Ʒ��ɱ���                                             
                                            
	set  @GOODS_SALE_RATE_buty=0.1                                                 
	set  @GOODS_SALE_RATE_hair=0.05                                
	set  @GOODS_SALE_RATE_finger=0.6                                        
	declare @cardtype  varchar(20)  --��Ա�����      
	declare @dycardnocreatetype  int  -- ����ȯ����                                    
	declare @quan float                                      
	declare @fuflag float --��������                                      
	declare @businessflag int --�Ƿ�Ϊҵ����Ա 0--���� 1--��                                       
	declare @empinid varchar(20)                                  
	declare @proflag int --��Ŀ���     
	declare @arrivaldmonth	int  --��ְ�·�
	declare @newcosttc  float	--�¿������
	declare @oldcosttc  float	--�Ͽ������ 
	declare @saleprice  float	--��Ŀ��׼��
	declare @csitemstate int	--�Ƿ���	0 �� 1 ��� 2 δ��� 
	declare @billinsertype int		--��ֵ���췽 1 ���� 2 ����    0 ������ 
	declare @costpricetype  int   --�Ƿ�Ϊ���������	0 ���� 1 ��
	declare @prjsaletype   int		--�Ƿ����Ƴ�		 1��  2��                                     
	declare cur_yeji_ticheng cursor for                                                               
	select seqno,person_inid,action_id,case when isnull(action_id,'') in ('1','2','3') then staffshareyeji else staffyeji end,code,srvdate ,paycode,isnull(cardtype,''),isnull(ccount,0),isnull(arrivaldmonth,0),ISNULL(csitemstate,0),ISNULL(billinsertype,0) ,isnull(costpricetype,0)                                            
	from #work_detail                                                              
	declare @empTicheng float           
                                                               
	open cur_yeji_ticheng                                                              
	fetch cur_yeji_ticheng into @tmpSeqId,@tmpEmpId,@tmpItem,@tmpYeji,@tmpPrjId,@tmpDate,@paycode ,@cardtype,@quan,@arrivaldmonth,@csitemstate,@billinsertype ,@costpricetype                                                              
	while(@@fetch_status=0)                          
	begin                                           
		set @empTicheng = 0       
		set @empPostion=''      
		--����Ա��������ְλ            
		select @empPostion=position ,@empinid=inid from #empinfobydate where inid=@tmpEmpId and @tmpDate>=datefrom and @tmpDate<dateto       
           
		-- �鿴Ա���Ƿ���ҵ����Ա         
		select @businessflag=ISNULL(businessflag,0)  from staffinfo with(nolock)  where manageno=@tmpEmpId                                   
		-- ����Ƿ�ҵ����Ա���Ϊ0      
		if(@businessflag=0 or isnull(@empPostion,'') not in ('003','004','00103','00401','00402','005','006','007','00701','00702','008','00901','00902','00903','00904'))  
		begin                                      
			update #work_detail set staffticheng=0 where seqno=@tmpSeqId                                         
			fetch cur_yeji_ticheng into @tmpSeqId,@tmpEmpId,@tmpItem,@tmpYeji,@tmpPrjId,@tmpDate ,@paycode ,@cardtype,@quan ,@arrivaldmonth,@csitemstate,@billinsertype,@costpricetype                                     
			continue                                         
		end      
		-- 16��17��18��19��20��21��22��23��24-�۲�Ʒ        
		if(isnull(@tmpItem,'') in ('16','17','18','19','20','21','22','23','24'))                                                      
		begin            
			select   @GOODS_TYPE=isnull(goodstype,1)  from  goodsnameinfo with(nolock) where goodsno=@tmpPrjId                                            
			if(isnull(@GOODS_TYPE,'300'))='400'----���ݲ�Ʒ(�۳��ɱ�20%���10%)                                            
			begin                                            
				update #work_detail set staffyeji=isnull(staffyeji,0) where seqno=@tmpSeqId                                             
				set @empTicheng = isnull(@tmpYeji,0)*0.06                                       
			end                                            
			else if(isnull(@GOODS_TYPE,'300'))='300'----������Ʒ�����5%��                                             
			begin                                            
				update #work_detail set staffyeji=isnull(staffyeji,0) where seqno=@tmpSeqId                                             
				set @empTicheng = isnull(@tmpYeji,0)*@GOODS_SALE_RATE_hair                                               
			end                    
			else if(isnull(@GOODS_TYPE,'300'))='500'----���ײ�Ʒ����Ʒ���۳ɱ� 4��6�֣�                                           
			begin                                               
				set @empTicheng = isnull(@tmpYeji,0)*@GOODS_SALE_RATE_finger--0.4                 
			end                                        
			else if(isnull(@GOODS_TYPE,'300'))='700'----��ʫ��Ʒ����ҵ������ɣ�                                                 
			begin                                               
				update #work_detail set staffyeji=0 where seqno=@tmpSeqId                                             
				set @empTicheng = 0                                      
			end                                                  
		end        
		-- ����+��ֵ+ת��+���뿨���� 1��2��3��5      
		else if(isnull(@tmpItem,'')='1' or isnull(@tmpItem,'')='2'  or isnull(@tmpItem,'')='3' or isnull(@tmpItem,'')='5')                                           
		begin                                             
			if(isnull(@empPostion,'')='00901' or isnull(@empPostion,'')='00902' or isnull(@empPostion,'')='00903'  )  --һ���Ͷ�����Ⱦʦ1.5%                                         
				set @empTicheng = @tmpYeji*0.015                                           
			else if (isnull(@empPostion,'')='00904' or isnull(@empPostion,'')='008' )  --�������ļ���Ⱦʦ 2%                                         
				set @empTicheng = @tmpYeji*0.02
			else    -- ����ְλ����6%                     
				set @empTicheng = @tmpYeji*0.06 
			--if(@compid in ('006','047','033','014','041','046'))
			if(ISNULL(@isNewComdMode,0)=1)
			begin
				if (isnull(@empPostion,'')='00402') -- C������ʦ�������
					set @empTicheng = 0      
				else if (isnull(@empPostion,'') in ('004' ,'00401','00103') ) -- ����������ʦ��1%�����
					set @empTicheng = @tmpYeji*0.01 
				else if (isnull(@empPostion,'') in ('003','006','007','00701','00702') and ISNULL(@tmpDate,'')>='20140517') -- ��������4%
					set @empTicheng = @tmpYeji*0.04   
			
				if(ISNULL(@billinsertype,0)=0)
				begin
					update #work_detail set staffyeji=@tmpYeji where seqno=@tmpSeqId 
				end
				if(ISNULL(@billinsertype,0)=1 and isnull(@empPostion,'') in ('003','006','007','00701','00702')) --���ݿ���
				begin
					update #work_detail set staffyeji=0 where seqno=@tmpSeqId                
				end 
				if(ISNULL(@billinsertype,0)=2 and isnull(@empPostion,'') in ('003','006','007','00701','00702')) --��������
				begin
					update #work_detail set staffyeji=@tmpYeji where seqno=@tmpSeqId                
				end 
				if(ISNULL(@billinsertype,0)=2 and isnull(@empPostion,'') in ('004','00401','00402','00103')) --��������
				begin
					update #work_detail set staffyeji=0 where seqno=@tmpSeqId                
				end 
				if(ISNULL(@billinsertype,0)=1 and isnull(@empPostion,'') in ('004','00401','00402','00103')) --���ݿ���
				begin
					update #work_detail set staffyeji=@tmpYeji where seqno=@tmpSeqId                
				end 
			end                                                   
		end         
		-- ������Ŀ����  26��27��28��29��30��31                                           
		else if(isnull(@tmpItem,'')='26' or isnull(@tmpItem,'')='27'                              
			or  isnull(@tmpItem,'')='28' or isnull(@tmpItem,'')='29'                              
			or  isnull(@tmpItem,'')='30' or isnull(@tmpItem,'')='31' )                                         
		begin                                             
			if(isnull(@tmpItem,'')='26' or isnull(@tmpItem,'')='27' or isnull(@tmpItem,'')='30' )                              
				set @empTicheng = @tmpYeji*0.06                                 
			else if (isnull(@tmpItem,'')='28')                              
				set @empTicheng = @tmpYeji*0.22                             
		end        
		--�Ƴ̶һ�  4      
		else if(isnull(@tmpItem,'')='4')                                     
		begin                                      
			if(isnull(@empPostion,'')='00901' or isnull(@empPostion,'')='00902' or isnull(@empPostion,'')='00903'  )  --һ���Ͷ�����Ⱦʦ2%                                         
				set @empTicheng = @tmpYeji*0.02                                           
			else if ( isnull(@empPostion,'')='00904' or isnull(@empPostion,'')='008' )  --�������ļ���Ⱦʦ 2.5%                                         
				set @empTicheng = @tmpYeji*0.025                                          
			--��ϯ���ܼ࣬���ʦ��ҵ��20%,���20%                                       
			else if ( isnull(@empPostion,'')='003' or isnull(@empPostion,'')='006'  
				or isnull(@empPostion,'')='007' or isnull(@empPostion,'')='00701' or isnull(@empPostion,'')='00702'  
				or isnull(@empPostion,'')='00102')                                        
			begin                                      
				update #work_detail set staffyeji=isnull(@tmpYeji,0)*0.2 where seqno=@tmpSeqId                                        
				set @empTicheng = isnull(@tmpYeji,0)*0.2*0.2                      
			end                                      
		end     
		--�Ƴ̶һ� (��������)   
		else if(isnull(@tmpItem,'')='25')                                     
		begin      
			                                
			if(isnull(@empPostion,'') in ('00901','00902','00903','00904','008') )  --һ���Ͷ�����Ⱦʦ2%                                         
			begin
				update #work_detail set staffyeji=0 where seqno=@tmpSeqId 
				set @empTicheng = @tmpYeji*15  
			end  
			else if(isnull(@empPostion,'') in ('003','006','007','00701','00702') )  --����ʦ                                         
			begin
				update #work_detail set staffyeji=0 where seqno=@tmpSeqId 
				set @empTicheng = @tmpYeji*15  
			end                                           
			else   
			begin
				set @empTicheng =0    
				update #work_detail set staffyeji=0 where seqno=@tmpSeqId 
			end        
		end
		--�Ƴ̶һ� (�羱����)   
		else if(isnull(@tmpItem,'')='35')                                     
		begin                               
			if(isnull(@empPostion,'') in ('00103','004','00401') )  --����ʦ                                         
			begin
				update #work_detail set staffyeji=0 where seqno=@tmpSeqId 
				set @empTicheng = @tmpYeji*50  
			end                                           
			else   
			begin
				set @empTicheng =0    
				update #work_detail set staffyeji=0 where seqno=@tmpSeqId 
			end        
		end       
		--32 ��Ŀ������
		else if(isnull(@tmpItem,'')='32')                                     
		begin      
			update #work_detail set staffyeji=0 where seqno=@tmpSeqId 
			if(ISNULL(@SP105,'0')='1')
				set @empTicheng = 10      
			else 
				set @empTicheng = 0         
		end  
		--36 ��Ŀ������
		else if(isnull(@tmpItem,'')='36')                                     
		begin      
			update #work_detail set paycode='1',staffyeji=1000 where seqno=@tmpSeqId 
			set @empTicheng = 0    
		end 
		--��Ŀ���� 7,8,9,10,11,12,13,14,15      
		else      
		begin      
			set @fuflag=@quan         
			if(isnull(@paycode,'')='9') --�Ƴ�                                                        
			begin             
				--�Ƴ���������ʦ������ʦ�����趨�ɱ���ҵ��������                                    
				select @proflag=isnull(prjpricetype,2),@PROJECT_COST=isnull(costprice,0),@Performance_Ratio=isnull(lyjrate,1),
					@Wage_Rates=isnull(ltcrate,1),@PROJECT_TYPE=prjtype,@newcosttc=newcosttc,@oldcosttc=oldcosttc,@prjsaletype=isnull(prjsaletype,0)     
					from  projectinfo a,sysparaminfo b     
					where b.paramid='SP059' and b.compid=@compid and b.paramvalue=a.prjmodeId and prjno=@tmpPrjId                                     
				
				--����ʦC���������
				if(isnull(@empPostion,'') ='00402'  and ISNULL(@proflag,2)=1)                                      
				begin                                      
					update #work_detail set staffyeji=0 where seqno=@tmpSeqId                                        
					set @empTicheng = 0     
					fetch cur_yeji_ticheng into @tmpSeqId,@tmpEmpId,@tmpItem,@tmpYeji,@tmpPrjId,@tmpDate ,@paycode ,@cardtype,@quan ,@arrivaldmonth,@csitemstate,@billinsertype,@costpricetype                                     
					continue                                    
				end   
				if(ISNULL(@newcosttc,0)>0 or ISNULL(@oldcosttc,0)>0)
				begin
						if(  isnull(@tmpItem,'')='7')
							update #work_detail set staffticheng=@oldcosttc*@fuflag  where seqno=@tmpSeqId 
						else   if(  isnull(@tmpItem,'')='8')
							update #work_detail set staffticheng=@newcosttc*@fuflag  where seqno=@tmpSeqId 
						else
							update #work_detail set staffticheng=0 where seqno=@tmpSeqId 
						--���Ƴ̵��Ƴ���Ŀ 
						if(ISNULL(@prjsaletype,0)<>1)
							 update #work_detail set staffticheng=60*@fuflag  where seqno=@tmpSeqId                                    
						fetch cur_yeji_ticheng into @tmpSeqId,@tmpEmpId,@tmpItem,@tmpYeji,@tmpPrjId,@tmpDate ,@paycode ,@cardtype,@quan ,@arrivaldmonth,@csitemstate,@billinsertype,@costpricetype                                     
						continue  
				end
				update #work_detail set staffyeji=(isnull(@tmpYeji,0)*isnull(@PROJECT_COST,0))*isnull(@Performance_Ratio,0) where seqno=@tmpSeqId                                             
				set @empTicheng = (isnull(@tmpYeji,0)*isnull(@PROJECT_COST,0))*@Performance_Ratio*@Wage_Rates                                            
                                              
				--��Ⱦʦ ���Ƴ̿� ��80%ҵ�� ��5%��� ���Ƴ̿���120���ҵ����6��Ǯ�����                                      
				if(isnull(@empPostion,'')='00901' or isnull(@empPostion,'')='00902'  or isnull(@empPostion,'')='00903'  or isnull(@empPostion,'')='00904' or isnull(@empPostion,'')='008' )                                          
				begin            
					if( isnull(@cardtype,'') ='MR' or isnull(@cardtype,'')='MF')                                          
					begin                                      
						update #work_detail set staffyeji=120*@fuflag where seqno=@tmpSeqId                                             
						set @empTicheng=6*@fuflag                                      
					end                                       
					else                                      
					begin                                           
						update #work_detail set staffyeji=isnull(@tmpYeji,0)*0.8 where seqno=@tmpSeqId                               
						set @empTicheng = isnull(@tmpYeji,0)*0.8*0.05                                      
						if(isnull(@empPostion,'')='00904' or isnull(@empPostion,'')='008')--�ļ���Ⱦʦ                                      
							set @empTicheng = isnull(@tmpYeji,0)*0.8*0.06                                      
					end                                         
				end    
				                                                        
				if(isnull(@empPostion,'')in('004','00401','00402','00103') and ISNULL(@PROJECT_TYPE,'') in ('3','6') and ISNULL(@proflag,2)=1)                                      
				begin                                      
					update #work_detail set staffyeji=0 where seqno=@tmpSeqId                                        
					set @empTicheng = 0                                       
				end                                      
				if(isnull(@empPostion,'') in ('003','006','007','00701','00702','00901','00902','00903','00904','008')  and ISNULL(@PROJECT_TYPE,'') ='4' and ISNULL(@proflag,2)=1)                                      
				begin                                      
					update #work_detail set staffyeji=0 where seqno=@tmpSeqId                                        
					set @empTicheng = 0                                       
				end                                       
				--�������������й���С��λ�õ�(����ʦ,��ϯ,�ܼ�)�����                                      
				if((@PROJECT_TYPE='3' or @PROJECT_TYPE='6') and isnull(@empPostion,'') in ('003','006','007','00701','00702') and isnull(@tmpItem,'') not in ('7','8','9'))                                      
				begin                                      
					set @empTicheng = 0                                       
				end                                      
				if(@cardtype ='MFOLD' )                                       
				begin                                      
					update #work_detail set staffyeji=0 where seqno=@tmpSeqId                                        
					set @empTicheng =0                                      
				end                                                         
			end       
			else if( (@cardtype ='ZK' and isnull(@paycode,'') in ('4','17')) or isnull(@paycode,'')='$'  or isnull(@paycode,'')='A' or isnull(@paycode,'')='7' or isnull(@paycode,'')='11'  or isnull(@paycode,'')='12'  )                     
			begin                                   
				select  @proflag=isnull(prjpricetype,2),@newcosttc=newcosttc,@oldcosttc=oldcosttc      
				from  projectinfo a,sysparaminfo b     
				where b.paramid='SP059' and b.compid=@compid and b.paramvalue=a.prjmodeId and prjno=@tmpPrjId                             
				
				--����ʦC���������
				if(isnull(@empPostion,'') ='00402'  and ISNULL(@proflag,2)=1)                                      
				begin                                      
					update #work_detail set staffyeji=0 where seqno=@tmpSeqId                                        
					set @empTicheng = 0     
					fetch cur_yeji_ticheng into @tmpSeqId,@tmpEmpId,@tmpItem,@tmpYeji,@tmpPrjId,@tmpDate ,@paycode ,@cardtype,@quan ,@arrivaldmonth,@csitemstate,@billinsertype,@costpricetype                                     
					continue                                    
				end  
				
				--if(isnull(@tmpYeji,0)>0)                                    
				--	set @fuflag=1                                    
				--else                                    
				--	set @fuflag=-1 
				if((ISNULL(@newcosttc,0)>0 or ISNULL(@oldcosttc,0)>0) and isnull(@paycode,'')<>'11')
				begin
					if(  isnull(@tmpItem,'')='7' and ISNULL(@costpricetype,0)=0 )  --ָ���ͷ�������Ŀ
							update #work_detail set staffticheng=@oldcosttc*@fuflag  where seqno=@tmpSeqId 
					else   if(  isnull(@tmpItem,'')='7' and ISNULL(@costpricetype,0)=1  ) --ָ����������Ŀ
							update #work_detail set staffticheng=60*@fuflag  where seqno=@tmpSeqId 
					else   if(  isnull(@tmpItem,'')='8' and ISNULL(@costpricetype,0)=0) --�¿ͷ�������Ŀ
							update #work_detail set staffticheng=@newcosttc*@fuflag  where seqno=@tmpSeqId 
					else   if(  isnull(@tmpItem,'')='8' and ISNULL(@costpricetype,0)=1) --�¿�������Ŀ
							update #work_detail set staffticheng=60*@fuflag  where seqno=@tmpSeqId 
					else   if(  isnull(@tmpItem,'')='9') --�¿��Ƽ�
							update #work_detail set staffticheng=(@newcosttc-10)*@fuflag  where seqno=@tmpSeqId 
					else
							update #work_detail set staffticheng=0 where seqno=@tmpSeqId 
							                                     
					fetch cur_yeji_ticheng into @tmpSeqId,@tmpEmpId,@tmpItem,@tmpYeji,@tmpPrjId,@tmpDate ,@paycode ,@cardtype,@quan,@arrivaldmonth ,@csitemstate,@billinsertype,@costpricetype                                     
					continue  
				end
				if(@tmpPrjId in ('321','322','323','324','325','326','327','328','329','330','331','332') and isnull(@tmpItem,'')  in ('10','11','12') and  isnull(@empPostion,'') not in ('003','006','007','00701','00702')  )
				begin
						if(  ISNULL(@csitemstate,1)=1)
							update #work_detail set staffticheng=10*@fuflag  where seqno=@tmpSeqId 
						else   if( ISNULL(@csitemstate,1)=2)
							update #work_detail set staffticheng=5*@fuflag  where seqno=@tmpSeqId 
						else   if( ISNULL(@csitemstate,1)=3)
							update #work_detail set staffticheng=3*@fuflag  where seqno=@tmpSeqId 
						else
							update #work_detail set staffticheng=0 where seqno=@tmpSeqId                                      
						fetch cur_yeji_ticheng into @tmpSeqId,@tmpEmpId,@tmpItem,@tmpYeji,@tmpPrjId,@tmpDate ,@paycode ,@cardtype,@quan,@arrivaldmonth ,@csitemstate,@billinsertype,@costpricetype                                     
						continue 
				end  
				if(@tmpPrjId in ('321','322','323','324','325','326','327','328','329','330','331','332') and isnull(@tmpItem,'')  in ('13','14','15') )
				begin
						update #work_detail set staffticheng=0 where seqno=@tmpSeqId                                      
						fetch cur_yeji_ticheng into @tmpSeqId,@tmpEmpId,@tmpItem,@tmpYeji,@tmpPrjId,@tmpDate ,@paycode ,@cardtype,@quan,@arrivaldmonth ,@csitemstate,@billinsertype,@costpricetype                                     
						continue 
				end                                     
				--��Ŀ����ȯʹ����ֵ��ҵ��                                      
				if(isnull(@paycode,'')='11' )                                      
				begin            
					select @tmpYeji=ISNULL(cardfaceamt,0),@dycardnocreatetype=createtype from nointernalcardinfo where cardno=@cardtype
					--�ȯ
					if(ISNULL(@dycardnocreatetype,0)=20140811)
					begin
						update #work_detail set staffticheng=25*@fuflag where seqno=@tmpSeqId                                      
						fetch cur_yeji_ticheng into @tmpSeqId,@tmpEmpId,@tmpItem,@tmpYeji,@tmpPrjId,@tmpDate ,@paycode ,@cardtype,@quan,@arrivaldmonth ,@csitemstate,@billinsertype,@costpricetype                                     
						continue
					end  
					--�µǼǵ���ȯ
					if(ISNULL(@dycardnocreatetype,0)<>0)
					begin
						update #work_detail set staffticheng=60*@fuflag where seqno=@tmpSeqId                                      
						fetch cur_yeji_ticheng into @tmpSeqId,@tmpEmpId,@tmpItem,@tmpYeji,@tmpPrjId,@tmpDate ,@paycode ,@cardtype,@quan,@arrivaldmonth ,@csitemstate,@billinsertype,@costpricetype                                     
						continue
					end                              
					if(ISNULL(@fuflag,0)<0)                            
						set  @tmpYeji=ISNULL(@tmpYeji,0)*(-1)                                   
					update #work_detail set staffyeji=@tmpYeji,billamt=@tmpYeji where seqno=@tmpSeqId                                        
				end                                       
				--��Ⱦʦ ��ҵ��24% ���5%                                      
				if(isnull(@empPostion,'')='00901' or isnull(@empPostion,'')='00902'  or isnull(@empPostion,'')='00903' or isnull(@empPostion,'')='00904' or isnull(@empPostion,'')='008')                                          
				begin                                      
					update #work_detail set staffyeji=isnull(@tmpYeji,0)*0.24 where seqno=@tmpSeqId                                        
					set @empTicheng = isnull(@tmpYeji,0)*0.24*0.05                                        
					if( isnull(@empPostion,'')='00904' or isnull(@empPostion,'')='008')                
						set @empTicheng = isnull(@tmpYeji,0)*0.24*0.06                                        
				end                                        
				--��ϯ���ܼ࣬���ʦ��ҵ��24%,���22% ����ʦ��ҵ��24%,���22%                                       
				else                                       
				begin                                      
					update #work_detail set staffyeji=isnull(@tmpYeji,0)*0.24 where seqno=@tmpSeqId                                        
					set @empTicheng = isnull(@tmpYeji,0)*0.24*0.22    
					if(  isnull(@tmpItem,'')='9' and ISNULL(@empTicheng,0)>10) --�¿��Ƽ� 
						set @empTicheng =ISNULL(@empTicheng,0) -10                                     
				end                                        
				---ϴ������Ŀ ����ʦ�۳�0.25�ĳɱ� �ܼ�۳�0.11�ĳɱ� ��ϯ�۳�0.15�ĳɱ�                                      
				---������Ŀ����ʦ����ĸ�ϴ20��ҵ����ˮϵ5 ���ϵ��0.3         
                             
				if(@tmpPrjId in ('300','3002','301','302','303','305','306','309','311','321','322','323','324','325','326','327','328','329','330','331','332'))                                    
				begin                                      
					if(isnull(@empPostion,'')in('004','00401','00402','00103') or isnull(@empPostion,'')='00901' or isnull(@empPostion,'')='00902'  or isnull(@empPostion,'')='00903' or isnull(@empPostion,'')='00904' or isnull(@empPostion,'')='008')                            
					begin                                      
						if(@tmpPrjId='300' or @tmpPrjId='302' or @tmpPrjId='303'  or @tmpPrjId='309' )                                      
						begin                                      
							update #work_detail set staffyeji=20*@fuflag where seqno=@tmpSeqId                                        
							set @empTicheng =6*@fuflag                                      
						end                                       
						else                                      
						begin                                      
							update #work_detail set staffyeji=5*@fuflag where seqno=@tmpSeqId                                        
							 set @empTicheng =1.5*@fuflag                                      
						end                                      
					end                                             
					if((@tmpPrjId='300' or @tmpPrjId='3002') and isnull(@tmpItem,'') not in ('7','8','9'))                                      
					begin                                      
						if(isnull(@empPostion,'')='006' or isnull(@empPostion,'') ='007' or isnull(@empPostion,'') ='00701' or isnull(@empPostion,'') ='00702')--��ϯ�ܼ�      
						begin                                      
							update #work_detail set staffyeji=10*@fuflag where seqno=@tmpSeqId                                      
							set @empTicheng =3*@fuflag                                      
						end                                             
						else if(isnull(@empPostion,'')='003')                                      
						begin                                      
							update #work_detail set staffyeji=10*@fuflag where seqno=@tmpSeqId                                      
							set @empTicheng =2.8*@fuflag                                      
						end                                             
						else                                       
						begin             
							update #work_detail set staffyeji=0 where seqno=@tmpSeqId                                        
							set @empTicheng =0                                      
						end                                      
					end                                      
				end                               
			end       
			else      
			begin      
				select @proflag=isnull(prjpricetype,2),@PROJECT_COST=isnull(costprice,0),@Performance_Ratio=isnull(kyjrate,1),
				@Wage_Rates=isnull(ktcrate,1),@PROJECT_TYPE=prjtype,@newcosttc=newcosttc,@oldcosttc=oldcosttc ,@saleprice=saleprice      
				from  projectinfo a,sysparaminfo b     
				where b.paramid='SP059' and b.compid=@compid and b.paramvalue=a.prjmodeId and prjno=@tmpPrjId  
				
				--����ʦC���������
				if(isnull(@empPostion,'') ='00402'  and ISNULL(@proflag,2)=1)                                      
				begin                                      
					update #work_detail set staffyeji=0 where seqno=@tmpSeqId                                        
					set @empTicheng = 0     
					fetch cur_yeji_ticheng into @tmpSeqId,@tmpEmpId,@tmpItem,@tmpYeji,@tmpPrjId,@tmpDate ,@paycode ,@cardtype,@quan ,@arrivaldmonth,@csitemstate,@billinsertype,@costpricetype                                     
					continue                                    
				end  
				
				if((ISNULL(@newcosttc,0)>0 or ISNULL(@oldcosttc,0)>0) )
				begin
					if(  isnull(@tmpItem,'')='7' and ISNULL(@costpricetype,0)=0 )  --ָ���ͷ�������Ŀ
					begin
							update #work_detail set staffticheng=@oldcosttc*@fuflag  where seqno=@tmpSeqId 
							set @empTicheng=@oldcosttc*@fuflag
					end
					else   if(  isnull(@tmpItem,'')='7' and ISNULL(@costpricetype,0)=1  ) --ָ����������Ŀ
					begin
							update #work_detail set staffticheng=60*@fuflag  where seqno=@tmpSeqId 
							set @empTicheng=60*@fuflag
					end
					else   if(  isnull(@tmpItem,'')='8' and ISNULL(@costpricetype,0)=0) --�¿ͷ�������Ŀ
					begin
							update #work_detail set staffticheng=@newcosttc*@fuflag  where seqno=@tmpSeqId
							set @empTicheng=@newcosttc*@fuflag 
					end
					else   if(  isnull(@tmpItem,'')='8' and ISNULL(@costpricetype,0)=1) --�¿�������Ŀ
					begin
							update #work_detail set staffticheng=60*@fuflag  where seqno=@tmpSeqId 
							set @empTicheng=60*@fuflag 
					end
					else   if(  isnull(@tmpItem,'')='9') --�¿��Ƽ�
					begin
							update #work_detail set staffticheng=(@newcosttc-10)*@fuflag  where seqno=@tmpSeqId 
							set @empTicheng=(@newcosttc-10)*@fuflag
					end
					else
					begin
							update #work_detail set staffticheng=0 where seqno=@tmpSeqId
							set @empTicheng=0
					end 
					                               
					if( isnull(@paycode,'')='13')
					begin
							update #work_detail set staffticheng=60*@fuflag  where seqno=@tmpSeqId 
							set @empTicheng=60*@fuflag 
					end	
					fetch cur_yeji_ticheng into @tmpSeqId,@tmpEmpId,@tmpItem,@tmpYeji,@tmpPrjId,@tmpDate ,@paycode ,@cardtype,@quan,@arrivaldmonth ,@csitemstate,@billinsertype,@costpricetype                                     
					continue
				end
				
				if(@tmpPrjId in ('321','322','323','324','325','326','327','328','329','330','331','332') and isnull(@tmpItem,'')  in ('10','11','12') and  isnull(@empPostion,'') not in ('003','006','007','00701','00702')   )
				begin
						if(  ISNULL(@csitemstate,1)=1)
							update #work_detail set staffticheng=10*@fuflag  where seqno=@tmpSeqId 
						else   if( ISNULL(@csitemstate,1)=2)
							update #work_detail set staffticheng=5*@fuflag  where seqno=@tmpSeqId
						else   if( ISNULL(@csitemstate,1)=3)
							update #work_detail set staffticheng=3*@fuflag  where seqno=@tmpSeqId 
						else
							update #work_detail set staffticheng=0 where seqno=@tmpSeqId                                      
						fetch cur_yeji_ticheng into @tmpSeqId,@tmpEmpId,@tmpItem,@tmpYeji,@tmpPrjId,@tmpDate ,@paycode ,@cardtype,@quan,@arrivaldmonth ,@csitemstate ,@billinsertype,@costpricetype                                    
						continue 
				end  
				if(@tmpPrjId in ('321','322','323','324','325','326','327','328','329','330','331','332') and isnull(@tmpItem,'')  in ('13','14','15') )
				begin
						update #work_detail set staffticheng=0 where seqno=@tmpSeqId                                      
						fetch cur_yeji_ticheng into @tmpSeqId,@tmpEmpId,@tmpItem,@tmpYeji,@tmpPrjId,@tmpDate ,@paycode ,@cardtype,@quan,@arrivaldmonth ,@csitemstate,@billinsertype,@costpricetype                                     
						continue 
				end     
				--if(@compid in ('006','047','033','014','041','046') and isnull(@empPostion,'')  in ('003','006','007','00701','00702')   )
				if(isnull(@isNewComdMode,0)=1 and isnull(@empPostion,'')  in ('003','006','007','00701','00702')  and ISNULL(@PROJECT_TYPE,'')<>'6' )
				begin
					if(ISNULL(@arrivaldmonth,0)<=5)
					begin
						set @Wage_Rates=0.3  --********��6�ҵ�����ʦ5���ڵ����ϵ��Ϊ0.3
					end
					else
					begin
						set @Wage_Rates=0.25  --********��6�ҵ�����ϵ��Ϊ0.25
					end
				end      
				if(@PROJECT_TYPE<>'5')--���׳ɱ�������                        
				begin                        
					update #work_detail set staffyeji=(isnull(@tmpYeji,0)*isnull(@PROJECT_COST,0))*isnull(@Performance_Ratio,0) where seqno=@tmpSeqId                                             
				end                        
				set @empTicheng = (isnull(@tmpYeji,0)*isnull(@PROJECT_COST,0))*@Performance_Ratio*@Wage_Rates 
				if(  isnull(@tmpItem,'')='9' and ISNULL(@empTicheng,0)>10) --�¿��Ƽ� 
						set @empTicheng =ISNULL(@empTicheng,0) -10                                              
				--��ϯ�ܼ� �۳��ɱ����ҵ�����ʣ���� 30%  
				--if(@compid not in ('006','047','033','014','041','046') )  --��6�ҵ��Ϊ��׼��ϵ��
				if(isnull(@isNewComdMode,0)=0)
				begin                                    
					if((isnull(@empPostion,'')='006' or isnull(@empPostion,'') ='007' or isnull(@empPostion,'') ='00701' or isnull(@empPostion,'') ='00702') and ISNULL(@PROJECT_TYPE,'0')<>'6' )                                          
						set @empTicheng = (isnull(@tmpYeji,0)*isnull(@PROJECT_COST,0))*@Performance_Ratio*0.3                                           
				end
				--��Ⱦʦ �۳��ɱ����ҵ��5%                                      
				if(isnull(@empPostion,'')='00901' or isnull(@empPostion,'')='00902'  or isnull(@empPostion,'')='00903'  )                                          
					set @empTicheng = (isnull(@tmpYeji,0)*isnull(@PROJECT_COST,0))*isnull(@Performance_Ratio,0)*0.05                                           
				if( isnull(@empPostion,'')='00904' or isnull(@empPostion,'')='008')                                      
					set @empTicheng = (isnull(@tmpYeji,0)*isnull(@PROJECT_COST,0))*isnull(@Performance_Ratio,0)*0.06   
				---ϴ������Ŀ ����ʦ�۳�0.25�ĳɱ� �ܼ�۳�0.11�ĳɱ� ��ϯ�۳�0.15�ĳɱ�                                      
				---������Ŀ����ʦ����ĸ�ϴ20��ҵ����ˮϵ5 ���ϵ��0.3                                          
				if(@tmpPrjId in ('300','3002','301','302','303','305','306','309','311','321','322','323','324','325','326','327','328','329','330','331','332'))                                    
				begin                                      
					if(isnull(@empPostion,'')='003') --����ʦ                                      
					begin 
					    --if(@compid in ('006','047','033','014','041','046')  )
					    if(isnull(@isNewComdMode,0)=1)
						begin
							update #work_detail set staffyeji=isnull(@tmpYeji,0)*0.75 where seqno=@tmpSeqId                                        
							set @empTicheng = isnull(@tmpYeji,0)*0.75*@Wage_Rates        
						end 
						else
						begin                                     
							update #work_detail set staffyeji=isnull(@tmpYeji,0)*0.75 where seqno=@tmpSeqId                                        
							set @empTicheng = isnull(@tmpYeji,0)*0.75*0.28 
						end                                        
					end                                       
					else if(isnull(@empPostion,'')='006') --��ϯ                                      
					begin  
						--if(@compid in ('006','047','033','014','041','046')   )
						if(isnull(@isNewComdMode,0)=1)
						begin
							update #work_detail set staffyeji=isnull(@tmpYeji,0)*0.85 where seqno=@tmpSeqId                                        
							set @empTicheng = isnull(@tmpYeji,0)*0.85*@Wage_Rates        
						end 
						else
						begin                                      
							update #work_detail set staffyeji=isnull(@tmpYeji,0)*0.85 where seqno=@tmpSeqId                                        
							set @empTicheng = isnull(@tmpYeji,0)*0.85*0.3   
						end                      
					end                                   
					else if(isnull(@empPostion,'')='007' or isnull(@empPostion,'')='00701' or isnull(@empPostion,'')='00702') --�ܼ�                                     
					begin                                      
						--if(@compid in ('006','047','033','014','041','046')   )
						if(isnull(@isNewComdMode,0)=1)
						begin
							update #work_detail set staffyeji=isnull(@tmpYeji,0)*0.89 where seqno=@tmpSeqId                                        
							set @empTicheng = isnull(@tmpYeji,0)*0.89*@Wage_Rates        
						end 
						else
						begin   
							update #work_detail set staffyeji=isnull(@tmpYeji,0)*0.89 where seqno=@tmpSeqId                                        
							set @empTicheng = isnull(@tmpYeji,0)*0.89*0.3 
						end                                       
					end                                       
					else if(isnull(@empPostion,'')in('004','00401','00402','00103') or isnull(@empPostion,'')='00901' or isnull(@empPostion,'')='00902'  or isnull(@empPostion,'')='00903' or isnull(@empPostion,'')='00904' or isnull(@empPostion,'')='008')                      
					begin                                      
						if(@tmpPrjId='300' or @tmpPrjId='302' or @tmpPrjId='303'  or @tmpPrjId='309' )                                
						begin                                      
							update #work_detail set staffyeji=20*@fuflag where seqno=@tmpSeqId                                        
							set @empTicheng =6*@fuflag                                      
						end                                       
						else                                      
						begin                                      
							update #work_detail set staffyeji=5*@fuflag where seqno=@tmpSeqId                                        
							set @empTicheng =1.5*@fuflag                                      
						end                                      
					end  
					--��6�����ɱ���
					   
					if((@tmpPrjId='300' or @tmpPrjId='3002') and isnull(@tmpItem,'') not in ('7','8','9'))                       
					begin                                            
						if(isnull(@empPostion,'')='006' or isnull(@empPostion,'') ='007' or isnull(@empPostion,'') ='00701' or isnull(@empPostion,'') ='00702')--��ϯ�ܼ�              
						begin                                      
							update #work_detail set staffyeji=10*@fuflag where seqno=@tmpSeqId                                      
							set @empTicheng =3*@fuflag                                      
						end                                             
						else if(isnull(@empPostion,'')='003')                                      
						begin                                      
							update #work_detail set staffyeji=10*@fuflag where seqno=@tmpSeqId                                      
							set @empTicheng =2.8*@fuflag                                      
						end                                             
						else                                       
						begin                                      
							update #work_detail set staffyeji=0 where seqno=@tmpSeqId                                        
							set @empTicheng =0                                      
						end                
					end                                      
				end                                      
				if(isnull(@paycode,'')='13' )                                      
				begin                  
					declare @tmcardfrom int --0 ��������,1 ���Ϳ���
					declare @createcardtype int --0 ��������,1 ���Ϳ���                                         
					select @tmcardfrom=ISNULL(entrytype,0),@createcardtype=createcardtype from nointernalcardinfo where cardno=@cardtype                                      
					if(ISNULL(@createcardtype ,0)=8009)
					begin
						set @empTicheng =60
					end
					else if(ISNULL(@tmcardfrom,0)=1)                                      
					begin                                      
						--��Ⱦʦ ��ҵ��24% ���5%                                      
						if(isnull(@empPostion,'')='00901' or isnull(@empPostion,'')='00902'  or isnull(@empPostion,'')='00903' or isnull(@empPostion,'')='00904' or isnull(@empPostion,'')='008')                                          
						begin                                      
							update #work_detail set staffyeji=isnull(@tmpYeji,0)*0.24 where seqno=@tmpSeqId                                        
							set @empTicheng = isnull(@tmpYeji,0)*0.24*0.05                   
							if( isnull(@empPostion,'')='00904' or isnull(@empPostion,'')='008')                                      
								set @empTicheng = isnull(@tmpYeji,0)*0.24*0.06                                        
						end                                        
						--��ϯ���ܼ࣬���ʦ��ҵ��24%,���22% ����ʦ��ҵ��24%,���22%                                       
						else                                       
						begin                                      
							update #work_detail set staffyeji=isnull(@tmpYeji,0)*0.24 where seqno=@tmpSeqId                                        
							set @empTicheng = isnull(@tmpYeji,0)*0.24*0.22                                      
						end                                       
					end                                       
				end              
				--�������������й���С��λ�õ�(����ʦ,��ϯ,�ܼ�)�����                                      
				if((@PROJECT_TYPE='3' or @PROJECT_TYPE='6') and isnull(@empPostion,'') in ('003','006','007','00701','00702') and isnull(@tmpItem,'') not in ('7','8','9'))                                      
				begin                                      
					set @empTicheng = 0                                       
				end                                      
				else if(@PROJECT_TYPE='5')-- ����ҵ����10%�ĳɱ������4��6��                                      
				begin                                      
					if(isnull(@empPostion,'')='005' )                                      
					begin                          
						if( ISNULL(@comptypebyfinger,'1')='1')                          
						begin                             
							update #work_detail set staffyeji=isnull(@tmpYeji,0)*0.9 where seqno=@tmpSeqId                                        
							set @empTicheng = isnull(@tmpYeji,0)*0.9*0.6                            
						end                                    
					end                                      
					else                                      
					begin                             
						update #work_detail set staffyeji=0 where seqno=@tmpSeqId                                        
						set @empTicheng =0                                      
					end                                      
				end        
                   
				if(isnull(@empPostion,'') in('004','00401','00402','00103')  and @tmpPrjId in ('48811') and isnull(@paycode,'')<>'13')                                      
				begin                                      
					if(isnull(@tmpItem,'') in ('7','8','9'))                      
					begin             
						if(isnull(@tmpYeji,0)<100)           
							set @tmpYeji=100                            
						update #work_detail set staffyeji= isnull(@tmpYeji,0)*0.8 where seqno=@tmpSeqId                 
						set @empTicheng = isnull(@tmpYeji,0)*0.8*0.3*@fuflag                      
					end                                 
					else                                      
					begin                                      
						update #work_detail set staffyeji=0 where seqno=@tmpSeqId                                        
						set @empTicheng = 0                     
					end                                      
				end 
				                                           
				if(isnull(@empPostion,'')in('004','00401','00402','00103') and ISNULL(@PROJECT_TYPE,'') in ('3','6') and ISNULL(@proflag,2)=1)                                      
				begin                             
					update #work_detail set staffyeji=0 where seqno=@tmpSeqId                                        
					set @empTicheng = 0                                       
				end  
				
			 
				if(isnull(@empPostion,'') in ('003','006','007','00701','00702','00901','00902','00903','00904','008')  and ISNULL(@PROJECT_TYPE,'') ='4' and ISNULL(@proflag,2)=1)                                      
				begin                                      
					update #work_detail set staffyeji=0 where seqno=@tmpSeqId                                        
					set @empTicheng = 0                                       
				end  
	                                     
			end       
		end   
            
		---�������                                   
		update #work_detail set staffticheng=@empTicheng,person_inid=@empinid,postation=@empPostion where seqno=@tmpSeqId                                                                        
		fetch cur_yeji_ticheng into @tmpSeqId,@tmpEmpId,@tmpItem,@tmpYeji,@tmpPrjId,@tmpDate ,@paycode ,@cardtype,@quan ,@arrivaldmonth ,@csitemstate,@billinsertype,@costpricetype                               
	end                                                              
	close cur_yeji_ticheng                                                              
	deallocate cur_yeji_ticheng                             
       
	--����ʦ��������Ŀ ����ָ��ҵ��������ͨ����ɱ���                                      
	--����ʦҵ����2.5W,��ϯ��5W,�ܼ� 7W ������Ŀ��ɱ���0.35                                      
	create  table #emp_yeji_total_resultx                                       
	(                                      
		inid  varchar(20) null,  --Ա���ڲ����                                         
		yeji  float  null, -- ҵ��                       
		lv   float  null, --��ɱ���                                           
	)                                         
                                      
	insert #emp_yeji_total_resultx(inid,yeji)                                             
	select  person_inid,sum(isnull(staffyeji,0)) from #work_detail 
	where ISNULL(action_id,-1)<>4 and paycode in ('1','2','6','0','14','15') group by person_inid                                    
   
    --if(@compid in ('006','047','033','014','041','046'))
    if(isnull(@isNewComdMode,0)=1)
    begin

        update a set staffticheng=isnull(staffyeji,0)*0.30                                      
		from #work_detail a ,projectnameinfo with(nolock)                                      
		where isnull(a.postation,'') in ('003','006','007','00701','00702')                                    
		and action_id in (7,10,13)  and ISNULL(paycode,'') not in ('9','11','12')                                 
		and  prjno=code and prjtype='3'                                      
		and isnull(cardtype,'')   not in ('MFOLD','ZK') 
		
		
		        --��6�� 5�������� ����ʦ 1W-2W(������2W) �Ͽ���ɱ���Ϊ30%
		update a set staffticheng=isnull(staffyeji,0)*0.30                                      
		from #work_detail a ,#emp_yeji_total_resultx b,projectnameinfo with(nolock)                                      
		where a.person_inid=b.inid and isnull(a.postation,'')='003'                                       
		and action_id in (7,10,13)  and ISNULL(paycode,'') not in ('9','11','12')                                       
		and b.yeji>=10000 and b.yeji<20000 and  prjno=code and prjtype='3'                                      
		and isnull(cardtype,'')   not in ('MFOLD','ZK') 
		and ISNULL(arrivaldmonth,0)>5  
		
		
		--��6�� 5�������� ����ʦ 2W���� �Ͽ���ɱ���Ϊ35%
		update a set staffticheng=isnull(staffyeji,0)*0.35                                     
		from #work_detail a ,#emp_yeji_total_resultx b,projectnameinfo with(nolock)                                      
		where a.person_inid=b.inid and isnull(a.postation,'')='003'                                       
		and action_id in (7,10,13)  and ISNULL(paycode,'') not in ('9','11','12')                                       
		and b.yeji>=20000 and  prjno=code and prjtype='3'                                      
		and isnull(cardtype,'')   not in ('MFOLD','ZK') 
		and ISNULL(arrivaldmonth,0)>5                                    
         
        ----��6�� 5�������� ��ϯ 2W-3W(������3W) �Ͽ���ɱ���Ϊ30%    
		update a set staffticheng=isnull(staffyeji,0)*0.30                                      
		from #work_detail a ,#emp_yeji_total_resultx b,projectnameinfo with(nolock)                                      
		where a.person_inid=b.inid and isnull(a.postation,'')='006'                                       
		and action_id in (7,10,13) and ISNULL(paycode,'') not in ('9','11','12')                                       
		and b.yeji>=20000 and b.yeji<30000 and  prjno=code and prjtype='3'                                      
		and isnull(cardtype,'')   not in ('MFOLD','ZK')    
		and ISNULL(arrivaldmonth,0)>5    
		
		----��6�� 5�������� ��ϯ 3W-5W(������5W) �Ͽ���ɱ���Ϊ35%    
		update a set staffticheng=isnull(staffyeji,0)*0.35                                     
		from #work_detail a ,#emp_yeji_total_resultx b,projectnameinfo with(nolock)                                      
		where a.person_inid=b.inid and isnull(a.postation,'')='006'                                       
		and action_id in (7,10,13) and ISNULL(paycode,'') not in ('9','11','12')                                      
		and b.yeji>=30000 and b.yeji<50000 and  prjno=code and prjtype='3'                                      
		and isnull(cardtype,'')   not in ('MFOLD','ZK')    
		and ISNULL(arrivaldmonth,0)>5    
		
		----��6�� 5�������� ��ϯ 5W���� �Ͽ���ɱ���Ϊ40%    
		update a set staffticheng=isnull(staffyeji,0)*0.40                                     
		from #work_detail a ,#emp_yeji_total_resultx b,projectnameinfo with(nolock)                                      
		where a.person_inid=b.inid and isnull(a.postation,'')='006'                                       
		and action_id in (7,10,13) and ISNULL(paycode,'') not in ('9','11','12')                                     
		and b.yeji>=50000 and  prjno=code and prjtype='3'                                      
		and isnull(cardtype,'')   not in ('MFOLD','ZK')    
		and ISNULL(arrivaldmonth,0)>5 
		
		                              
        ----��6�� 5�������� �ܼ�,�����ܼ�,����ܼ� 3W-5W(������5W) �Ͽ���ɱ���Ϊ30%                              
		update a set staffticheng=isnull(staffyeji,0)*0.30                                      
		from #work_detail a ,#emp_yeji_total_resultx b,projectnameinfo with(nolock)                                      
		where a.person_inid=b.inid and isnull(a.postation,'') in ('007' ,'00701','00702')                                     
		and action_id in (7,10,13) and ISNULL(paycode,'') not in ('9','11','12')                                     
		and b.yeji>=30000 and b.yeji<50000   and prjno=code and prjtype='3'                                      
		and isnull(cardtype,'')   not in ('MFOLD','ZK')                                      
		and ISNULL(arrivaldmonth,0)>5 
		
		----��6�� 5�������� �ܼ�,�����ܼ�,����ܼ� 5W-8W(������5W) �Ͽ���ɱ���Ϊ35%                              
		update a set staffticheng=isnull(staffyeji,0)*0.35                                      
		from #work_detail a ,#emp_yeji_total_resultx b,projectnameinfo with(nolock)                                      
		where a.person_inid=b.inid and isnull(a.postation,'') in ('007' ,'00701','00702')                                     
		and action_id in (7,10,13) and ISNULL(paycode,'') not in ('9','11','12')                                    
		and b.yeji>=50000 and b.yeji<70000   and prjno=code and prjtype='3'                                      
		and isnull(cardtype,'')   not in ('MFOLD','ZK')                                      
		and ISNULL(arrivaldmonth,0)>5 
		
		----��6�� 5�������� �ܼ�,�����ܼ�,����ܼ� 8W���� �Ͽ���ɱ���Ϊ40%                              
		update a set staffticheng=isnull(staffyeji,0)*0.40                                      
		from #work_detail a ,#emp_yeji_total_resultx b,projectnameinfo with(nolock)                                      
		where a.person_inid=b.inid and isnull(a.postation,'') in ('007' ,'00701','00702')                                     
		and action_id in (7,10,13) and ISNULL(paycode,'') not in ('9','11','12')                                     
		and b.yeji>=70000   and prjno=code and prjtype='3'                                      
		and isnull(cardtype,'')   not in ('MFOLD','ZK')                                      
		and ISNULL(arrivaldmonth,0)>5 
    end  
    else                                   
	begin
		update a set staffticheng=isnull(staffyeji,0)*0.35                                      
		from #work_detail a ,#emp_yeji_total_resultx b,projectnameinfo with(nolock)                                      
		where a.person_inid=b.inid and isnull(a.postation,'')='003'                                       
		and (action_id>=7 and action_id<=15) and ISNULL(paycode,'')<>'9'                                      
		and b.yeji>=30000 and  prjno=code and prjtype='3'                                      
		and isnull(cardtype,'')   not in ('MFOLD','ZK')                                      
             
		update a set staffticheng=isnull(staffyeji,0)*0.35                                      
		from #work_detail a ,#emp_yeji_total_resultx b,projectnameinfo with(nolock)                                      
		where a.person_inid=b.inid and isnull(a.postation,'')='006'                                       
		and (action_id>=7 and action_id<=15) and ISNULL(paycode,'')<>'9'                                      
		and b.yeji>=50000 and  prjno=code and prjtype='3'                                      
		and isnull(cardtype,'')   not in ('MFOLD','ZK')                                      
                                       
		update a set staffticheng=isnull(staffyeji,0)*0.35                                      
		from #work_detail a ,#emp_yeji_total_resultx b,projectnameinfo with(nolock)                                      
		where a.person_inid=b.inid and isnull(a.postation,'')='007'                                       
		and (action_id>=7 and action_id<=15) and ISNULL(paycode,'')<>'9'                                      
		and b.yeji>=70000  and prjno=code and prjtype='3'                                      
		and isnull(cardtype,'')   not in ('MFOLD','ZK')                                      
      
		update a set staffticheng=isnull(staffyeji,0)*0.35                                      
		from #work_detail a ,#emp_yeji_total_resultx b,projectnameinfo with(nolock)                                      
		where a.person_inid=b.inid and isnull(a.postation,'') in ('00701','00702')                                    
		and (action_id>=7 and action_id<=15) and ISNULL(paycode,'')<>'9'                                      
		and b.yeji>=90000  and prjno=code and prjtype='3'                                      
		and isnull(cardtype,'')   not in ('MFOLD','ZK')   
	end                          
                       
                     
	---����ʦA��                    
	/*if(@compid in ('008','017','019','026','032'))                    
	begin                    
                     
		update a set staffticheng=ISNULL(staffticheng,0)+ISNULL(staffyeji,0)*0.05        
		from #work_detail a,#emp_yeji_total_resultx b                    
		where a.person_inid=b.inid                    
			and ISNULL(a.postation,'')='004'                    
			and (action_id>=7 and action_id<=15)                    
			and paycode not in('11','12','7','8','A','13')        
			and cardtype not in('ZK')        
			and yeji>=70000        
			and code not in('300','3002','301','302','303','305','306','309','311')                    
			and action_id not in (26,27,28,29,30,31)        
        
		--���뿨֧����ʱ����Ҫ�ж��Ƿ�Ϊ����        
		update a set staffticheng=ISNULL(staffticheng,0)+ISNULL(staffyeji,0)*0.05        
		from #work_detail a,nointernalcardinfo,#emp_yeji_total_resultx b        
		where a.person_inid=b.inid                     
			and a.cardtype=cardno                    
			and ISNULL(a.postation,'')='004'                    
			and (action_id>=7 and action_id<=15)                   
			and paycode='13'                    
			and yeji>=70000                       
			and isnull(entrytype,0)=0                    
			and code not in('300','3002','301','302','303','305','306','309','311')                    
			and action_id not in (26,27,28,29,30,31)                    
                          
                       
		update a set staffticheng=ISNULL(staffticheng,0)+ISNULL(staffyeji,0)*0.02                    
		from #work_detail a,#emp_yeji_total_resultx b                    
		where a.person_inid=b.inid and ISNULL(a.postation,'')='004'                    
			and paycode not in('11','12','7','8','A','13')                    
			and cardtype not in('ZK')                    
			and (action_id>=7 and action_id<=15)                  
			and yeji<70000                     
			and yeji>=50000                   
			and code not in('300','3002','301','302','303','305','306','309','311')                    
			and action_id not in (26,27,28,29,30,31)                    
                       
		--���뿨֧����ʱ����Ҫ�ж��Ƿ�Ϊ����                    
		update a set staffticheng=ISNULL(staffticheng,0)+ISNULL(staffyeji,0)*0.02                    
		from #work_detail a,nointernalcardinfo,#emp_yeji_total_resultx b                    
		where a.person_inid=b.inid                     
		and a.cardtype=cardno                    
		and ISNULL(a.postation,'')='004'                    
		and (action_id>=7 and action_id<=15)                   
		and paycode='13'                    
		and yeji<70000                     
		and yeji>=50000                    
		and isnull(entrytype,0)=0                    
		and action_id not in (26,27,28,29,30,31)                    
	end   */                 
	drop table #emp_yeji_total_resultx  
                          
		--������ɷ�ʽ                        
		--�а���ʽ:����ֳ�,��5%�ɱ�                        
		--��˾ֱӪ:����ҵ��1-5000 50% ��10%�ɱ�,5000����35%��10%�ɱ�                                     
                          
		if(ISNULL(@comptypebyfinger,'1')='3') --�а���ʽ                        
		begin                        
			update #work_detail set staffyeji=ISNULL(staffyeji,0)*0.95,staffticheng=isnull(staffticheng,0)*0.95*0.5                        
			from #work_detail,staffinfo where Manageno=person_inid and position = '005'                        
		end                   
		else  if(ISNULL(@comptypebyfinger,'1')='2') --��˾ֱӪ                         
		begin                        
		    update #work_detail set staffyeji=ISNULL(staffyeji,0)*0.9,staffticheng=isnull(staffticheng,0)*0.5*0.9                        
			where  person_inid in (select person_inid from #work_detail ,staffinfo where Manageno=person_inid and position = '005'                        
			group by person_inid having SUM(ISNULL(staffyeji,0))<=5000 )                         
                          
		    update #work_detail set staffyeji=ISNULL(staffyeji,0)*0.9,staffticheng=isnull(staffticheng,0)*0.35*0.9                        
			where  person_inid in (select person_inid from #work_detail ,staffinfo where Manageno=person_inid and position = '005'                        
			group by person_inid having SUM(ISNULL(staffyeji,0))>5000 )                         
		end          
          
	select seqno,person_inid,action_id,srvdate,code,name,payway,billamt,ccount,cost,staffticheng,staffyeji,staffshareyeji,prj_type,cls_flag,billid,paycode,compid,cardid,cardtype       
	from #work_detail order by action_id,srvdate      
       
      
	drop table #empinfobydate      
    drop table #work_detail       
         
end 
alter procedure upg_all_personal_comm_paymode(                                      
	@compid    varchar(10), -- ��˾��                                      
	@fromdate   varchar(10), -- ��ʼ����                                      
	@todate    varchar(10), -- ��������      
    @handtype   int    --1 ��ѯ 2 �ս� 3 Ա��ҵ��ͳ��      
   )                                                          
as                                      
begin                                    
	create table #allstaff_work_detail      
	(      
	   seqno   int identity  not null,             
	   person_inid  varchar(20)   NULL, --Ա���ڲ����      
	   action_id  int    NULL, --��������      
	   srvdate   varchar(10)   NULL, --����      
	   code   varchar(20)   NULL, --��Ŀ����,���ǿ���,��Ʒ��      
	   name   varchar(40)   NULL, --����      
	   payway   varchar(20)   NULL, --֧����ʽ      
	   billamt   float    NULL, --Ӫҵ���      
	   ccount   float    NULL, --����      
	   cost   float    NULL, --�ɱ�      
	   staffticheng float    NULL, --���      
	   staffyeji  float    NULL, --��ҵ��    
	   staffshareyeji		float				NULL, --������  
	   prj_type  varchar(20)   NULL, --��Ŀ���      
	   cls_flag        int     NULL, -- 1:��Ŀ 2:��Ʒ 3:��      
	   billid   varchar(20)   NULL, --����      
	   paycode   varchar(20)   NULL, --֧������      
	   compid   varchar(10)   NULL, --��˾��      
	   cardid   varchar(20)   NULL, --��Ա����      
	   cardtype  varchar(20)   NULL, --��Ա������      
	   postation  varchar(10)   NULL, --Ա������ 
	   arrivaldmonth			int					NULL, --��ְ�·�  
	   csitemstate			int					NULL,		--�Ƿ���	0 �� 1 ��� 2 δ��� 
	   billinsertype			int						NULL,	--��ֵ���췽 1 ���� 2 ���� 
	   costpricetype			int					NULL,		--�Ƿ�Ϊ���������	0 ���� 1 ��     
	)           
	create clustered index idx_work_detail_action_id on #allstaff_work_detail(action_id,code)        
       
     exec upg_prepare_yeji_analysis @compid,@fromdate, @todate 
          
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
			update #allstaff_work_detail set staffyeji=ISNULL(staffshareyeji,0) where action_id  in ('1','2','3')
		end
    end
    
    declare @SP105 varchar(2)
    select @SP105=paramvalue from sysparaminfo where compid=@compid and paramid='SP105'
       
	  
 
    update   #allstaff_work_detail set arrivaldmonth=datediff(month,arrivaldate,@todate)
    from  #allstaff_work_detail,staffinfo 
    where person_inid=manageno
    
    --��������
    UPDATE #allstaff_work_detail set arrivaldmonth=(select MAX(isnull(effectivedate,'')) from staffhistory c where person_inid=c.manageno and c.changetype in (0,1) and c.oldpostion not in  ('003','006','007','00701','00702')  and isnull(newpostion,'')='003')
   from #allstaff_work_detail a,staffhistory b
   where a.person_inid=b.manageno and  b.changetype in (0,1) and b.oldpostion not in  ('003','006','007','00701','00702') and isnull(newpostion,'')='003' 
   
   
   --�ػع�˾�Ĳ�����ְ����
   UPDATE a 
   set arrivaldmonth='20130101'
   from #allstaff_work_detail a,staffhistory b 
   where person_inid=manageno and changetype =5 and isnull(newpostion,'') in ('003','006','007','00701','00702')  and b.oldpostion  in  ('003','006','007','00701','00702') 
        
	update #allstaff_work_detail set payway=parentcodevalue       
	from #allstaff_work_detail,commoninfo      
	where infotype='ZFFS' and parentcodekey=paycode      
       
	update #allstaff_work_detail set cardtype='' where cardtype='ZK' and paycode not in ('4','17')     
      
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
	declare @prjsaletype   int		--�Ƿ����Ƴ�		 1��  2��  
	declare @csitemstate int	--�Ƿ���	0 �� 1 ��� 2 δ��� 
	declare @billinsertype int		--��ֵ���췽 1 ���� 2 ����    0 ������
	declare @costpricetype  int   --�Ƿ�Ϊ���������	0 ���� 1 �� 
	
	-----------------------------��ɻ�����------------------------------------------------
	--��Ʒ���
	declare @cp_costrate_mr				float				   -- ���ݲ�Ʒ�ɱ�ϵ��
	declare @cp_salaryrate_mr			float				   -- ���ݲ�Ʒ���ϵ��
	declare @cp_costrate_mf				float				   -- ������Ʒ�ɱ�ϵ��
	declare @cp_salaryrate_mf			float				   -- ������Ʒ���ϵ��
	declare @cp_costrate_mj				float				   -- ���ײ�Ʒ�ɱ�ϵ��
	declare @cp_salaryrate_mj			float				   -- ���ײ�Ʒ���ϵ��
	declare @cp_costrate_ks				float				   -- ��ʫ��Ʒ�ɱ�ϵ��
	declare @cp_salaryrate_ks			float				   -- ��ʫ��Ʒ���ϵ��
	
	--�������
	declare @kj_salaryrate_trsa			float					--һ,��,������Ⱦʦ�������ϵ��
	declare @kj_salaryrate_trsb			float					--�ļ���Ⱦʦ,��Ⱦ�����������ϵ��
	declare @kj_salaryrate_mrc			float					--����ʦC�������ϵ��
	declare @kj_salaryrate_mr			float					--��������ʦ���ϵ��
	declare @kj_salaryrate_mf			float					--������Ա���ϵ��
	
	--�Ƴ̶һ����
	declare @dh_costrate_trsa			float					--һ,��,������Ⱦʦ�Ƴ̶һ��ɱ�ϵ��
	declare @dh_costrate_trsb			float					--�ļ���Ⱦʦ,��Ⱦ�����Ƴ̶һ��ɱ�ϵ��
	declare @dh_costrate_mf				float					--������Ա�Ƴ̶һ��ɱ�ϵ��
	declare @dh_salaryrate_trsa			float					--һ,��,������Ⱦʦ�Ƴ̶һ����ϵ��
	declare @dh_salaryrate_trsb			float					--�ļ���Ⱦʦ,��Ⱦ�����Ƴ̶һ����ϵ��
	declare @dh_salaryrate_mf			float					--������Ա�Ƴ̶һ����ϵ��
	
	--������Ŀ���
	declare @hz_salaryrate_qh			float					--ȫ��˽�ܺ�����ɱ���
	declare @hz_salaryrate_jd			float					--�ߴ������ɱ���
	
	declare @jfdh_salary_reward			float					--�����Ƴ̶һ���ɽ���
	declare @jjdh_yeji_reward			float					--�羱�Ƴ̶һ�������
	declare @jjfw_salary_reward			float					--�羱������ɽ���
	declare @jsr_salary_reward			float					--��������ɽ���
	declare @tjsr_salary_cost			float					--�������˿۳����
	
	--��Ŀ����������ɷ�ʽ
	declare @mf_salaryrate_fiveup		float					--������Ա5�����ϵ���ɱ���(����������Ŀ)
	declare @mf_salaryrate_fivedown		float					--������Ա5�����µ���ɱ���(����������Ŀ)
	
	declare @olc_cost_yeji_fixed		float					--���Ƴ̿��̶�ҵ��
	declare @olc_cost_salary_fixed		float					--���Ƴ̿��̶����
	declare @nlc_costrate_tr			float					--��Ⱦʦ�Ƴ̳ɱ�
	
	declare @yjk_costrate_mrmf			float					--ԭ�ۿ����������ɱ�
	declare @yjk_salaryrate_mrmf		float					--ԭ�ۿ�����������ɱ���
	declare @yjk_costrate_tr			float					--ԭ�ۿ���Ⱦʦ�ɱ�
	
	declare @salaryrate_tra				float					--һ,��,������Ⱦʦ��ɱ���
	declare @salaryrate_trb				float					--�ļ���Ⱦʦ,��Ⱦ������ɱ���
	
	declare @xjc_costrate_sjs			float					--���ʦϴ�����ɱ�
	declare @xjc_costrate_sx			float					--��ϯϴ�����ɱ�
	declare @xjc_costrate_zj			float					--�ܼ�ϴ�����ɱ�
	
	declare @xjc_salary_fixed_db		float					--ϴ�����й���� 10
	declare @xjc_salary_fixed_ndb		float					--ϴ�����й������ 5
	declare @xjc_salary_fixed_nhg		float					--ϴ�����й����ϸ� 3
	
	declare @mr_salary_fixed_tmk		float					--��������Ŀ���뿨�̶����
	declare @mr_salary_fixed_ty			float					--��������Ŀ����̶����
	
	select  @cp_costrate_mr=cp_costrate_mr,@cp_salaryrate_mr=cp_salaryrate_mr,@cp_costrate_mf=cp_costrate_mf,@cp_salaryrate_mf=cp_salaryrate_mf,
			@cp_costrate_mj=cp_costrate_mj,@cp_salaryrate_mj=cp_salaryrate_mj,@cp_costrate_ks=cp_costrate_ks,@cp_salaryrate_ks=cp_salaryrate_ks, 
			@kj_salaryrate_trsa=kj_salaryrate_trsa,@kj_salaryrate_trsb=kj_salaryrate_trsb,@kj_salaryrate_mrc=kj_salaryrate_mrc,@kj_salaryrate_mr=kj_salaryrate_mr,@kj_salaryrate_mf=kj_salaryrate_mf,
			@dh_costrate_trsa=dh_costrate_trsa,@dh_costrate_trsb=dh_costrate_trsb,@dh_costrate_mf=dh_costrate_mf,@dh_salaryrate_trsa=dh_salaryrate_trsa,@dh_salaryrate_trsb=dh_salaryrate_trsb,@dh_salaryrate_mf=dh_salaryrate_mf, 
			@hz_salaryrate_qh=hz_salaryrate_qh,@hz_salaryrate_jd=hz_salaryrate_jd,@jfdh_salary_reward=jfdh_salary_reward,@jjdh_yeji_reward=jjdh_yeji_reward,@jjfw_salary_reward=jjfw_salary_reward,@jsr_salary_reward=jsr_salary_reward,@tjsr_salary_cost=tjsr_salary_cost, 
			@mf_salaryrate_fiveup=mf_salaryrate_fiveup,@mf_salaryrate_fivedown=mf_salaryrate_fivedown,@olc_cost_yeji_fixed=olc_cost_yeji_fixed,@olc_cost_salary_fixed=olc_cost_salary_fixed,@nlc_costrate_tr=nlc_costrate_tr,
			@yjk_costrate_mrmf=yjk_costrate_mrmf,@yjk_salaryrate_mrmf=yjk_salaryrate_mrmf,@yjk_costrate_tr=yjk_costrate_tr, 
			@salaryrate_tra=salaryrate_tra,@salaryrate_trb=salaryrate_trb,@xjc_costrate_sjs=xjc_costrate_sjs,@xjc_costrate_sx=xjc_costrate_sx,@xjc_costrate_zj=xjc_costrate_zj,@xjc_salary_fixed_db=xjc_salary_fixed_db,@xjc_salary_fixed_ndb=xjc_salary_fixed_ndb,@xjc_salary_fixed_nhg=xjc_salary_fixed_nhg,
			@mr_salary_fixed_tmk=mr_salary_fixed_tmk,@mr_salary_fixed_ty=mr_salary_fixed_ty 
			from salaryrateinfo where compno=@compid
	                                                   
	declare cur_yeji_ticheng cursor for                                                               
	select seqno,person_inid,action_id,case when isnull(action_id,'') in ('1','2','3') then staffshareyeji else staffyeji end,code,srvdate ,paycode,isnull(cardtype,''),isnull(ccount,0),isnull(arrivaldmonth,0),ISNULL(csitemstate,0),ISNULL(billinsertype,0),isnull(costpricetype,0)                                                 
	from #allstaff_work_detail                                                              
	declare @empTicheng float           
    declare @trkcqualified int --��Ⱦ�γ��Ƿ�ϸ�                                                            
	open cur_yeji_ticheng                                                              
	fetch cur_yeji_ticheng into @tmpSeqId,@tmpEmpId,@tmpItem,@tmpYeji,@tmpPrjId,@tmpDate,@paycode ,@cardtype,@quan,@arrivaldmonth,@csitemstate,@billinsertype,@costpricetype                                                                 
	while(@@fetch_status=0)                          
	begin                                           
		set @empTicheng = 0         
		set @empPostion=''    
		--����Ա��������ְλ            
		select @empPostion=position ,@empinid=inid from #empinfobydate where inid=@tmpEmpId and @tmpDate>=datefrom and @tmpDate<dateto                           
		 -- �鿴Ա���Ƿ���ҵ����Ա         
		select @businessflag=ISNULL(businessflag,0),@trkcqualified=ISNULL(trkcqualified,0)  from staffinfo with(nolock)  where manageno=@tmpEmpId and ISNULL(stafftype,0)=0                                   
		-- ����Ƿ�ҵ����Ա���Ϊ0      
		if(@businessflag=0 or isnull(@empPostion,'') not in ('003','004','00103','00401','00402','005','006','007','00701','00702','008','00901','00902','00903','00904'))                                            
		begin                                      
			update #allstaff_work_detail set staffticheng=0 where seqno=@tmpSeqId                                         
			fetch cur_yeji_ticheng into @tmpSeqId,@tmpEmpId,@tmpItem,@tmpYeji,@tmpPrjId,@tmpDate ,@paycode ,@cardtype,@quan ,@arrivaldmonth,@csitemstate,@billinsertype,@costpricetype                                      
			continue                                         
		end      
		-- 16��17��18��19��20��21��22��23��24-�۲�Ʒ        
		if(isnull(@tmpItem,'') in ('16','17','18','19','20','21','22','23','24'))                                                      
		begin            
			select   @GOODS_TYPE=isnull(goodstype,1)  from  goodsnameinfo with(nolock) where goodsno=@tmpPrjId                                            
			if(isnull(@GOODS_TYPE,'300'))='400'----���ݲ�Ʒ(�۳��ɱ�20%���10%)                                            
			begin                                            
				update #allstaff_work_detail set staffyeji=isnull(staffyeji,0)*isnull(@cp_costrate_mr,0) where seqno=@tmpSeqId                                             
				set @empTicheng = isnull(@tmpYeji,0)*isnull(@cp_costrate_mr,0)*ISNULL(@cp_salaryrate_mr,0)                                            
			end                                            
			else if(isnull(@GOODS_TYPE,'300'))='300'----������Ʒ�����5%��                                       
			begin                                            
				update #allstaff_work_detail set staffyeji=isnull(staffyeji,0)*isnull(@cp_costrate_mf,0) where seqno=@tmpSeqId                                             
				set @empTicheng = isnull(@tmpYeji,0)*isnull(@cp_costrate_mf,0)*ISNULL(@cp_salaryrate_mf,0)                                                
			end                                           
			else if(isnull(@GOODS_TYPE,'300'))='500'----���ײ�Ʒ����Ʒ���۳ɱ� 4��6�֣�                                           
			begin                                               
				update #allstaff_work_detail set staffyeji=isnull(staffyeji,0)*isnull(@cp_costrate_mj,0) where seqno=@tmpSeqId 
				set @empTicheng = isnull(@tmpYeji,0)*isnull(@cp_costrate_mj,0)*ISNULL(@cp_salaryrate_mj,0)                                       
			end                                        
			else if(isnull(@GOODS_TYPE,'300'))='700'----��ʫ��Ʒ����ҵ������ɣ�                                                 
			begin                                               
				update #allstaff_work_detail set staffyeji=isnull(staffyeji,0)*isnull(@cp_costrate_ks,0) where seqno=@tmpSeqId                                             
				set @empTicheng = isnull(@tmpYeji,0)*isnull(@cp_costrate_ks,0)*ISNULL(@cp_salaryrate_ks,0)                                          
			end                                                      
		end        
		-- ����+��ֵ+ת��+���뿨���� 1��2��3��5      
		else if(isnull(@tmpItem,'')='1' or isnull(@tmpItem,'')='2'  or isnull(@tmpItem,'')='3' or isnull(@tmpItem,'')='5')                                           
		begin                                             
			if(isnull(@empPostion,'')='00901' or isnull(@empPostion,'')='00902' or isnull(@empPostion,'')='00903'  )  --һ���Ͷ�����Ⱦʦ1.5%                                         
				set @empTicheng = @tmpYeji*ISNULL(@kj_salaryrate_trsa,0)                                          
			else if (isnull(@empPostion,'')='00904' or isnull(@empPostion,'')='008' )  --�������ļ���Ⱦʦ 2%                                         
				set @empTicheng = @tmpYeji*ISNULL(@kj_salaryrate_trsb,0) 
			else    -- ����ְλ����6%                     
				set @empTicheng = @tmpYeji*0.06  
			--if(@compid in ('006','047','033','014','041','046'))
			if(ISNULL(@isNewComdMode,0)=1)
			begin
				if (isnull(@empPostion,'')='00402') -- C������ʦ�������
					set @empTicheng = @tmpYeji*ISNULL(@kj_salaryrate_mrc,0)      
				else if (isnull(@empPostion,'')='004' or isnull(@empPostion,'')='00401'  or isnull(@empPostion,'')='00103') -- ����������ʦ��1%�����
					set @empTicheng = @tmpYeji*ISNULL(@kj_salaryrate_mr,0) 
				else if (isnull(@empPostion,'') in ('003','006','007','00701','00702') and ISNULL(@tmpDate,'')>='20140517' ) -- ��������4%
					set @empTicheng = @tmpYeji*ISNULL(@kj_salaryrate_mf,0)
			
				if(ISNULL(@billinsertype,0)=0)
				begin
					update #allstaff_work_detail set staffyeji=@tmpYeji where seqno=@tmpSeqId 
				end
				if(ISNULL(@billinsertype,0)=1 and isnull(@empPostion,'') in ('003','006','007','00701','00702')) --��������
				begin
					update #allstaff_work_detail set staffyeji=0 where seqno=@tmpSeqId                
				end 
				if(ISNULL(@billinsertype,0)=2 and isnull(@empPostion,'') in ('003','006','007','00701','00702')) --��������
				begin
					update #allstaff_work_detail set staffyeji=@tmpYeji where seqno=@tmpSeqId                
				end 
				if(ISNULL(@billinsertype,0)=2 and isnull(@empPostion,'') in ('004','00401','00402','00103')) --���ݿ���
				begin
					update #allstaff_work_detail set staffyeji=0 where seqno=@tmpSeqId                
				end 
				if(ISNULL(@billinsertype,0)=1 and isnull(@empPostion,'') in ('004','00401','00402','00103')) --���ݿ���
				begin
					update #allstaff_work_detail set staffyeji=@tmpYeji where seqno=@tmpSeqId                
				end 
			end                                                     
		end         
		-- ������Ŀ����  26��27��28��29��30��31                                           
		else if(isnull(@tmpItem,'')='26' or isnull(@tmpItem,'')='27'                              
			or  isnull(@tmpItem,'')='28' or isnull(@tmpItem,'')='29'                              
			or  isnull(@tmpItem,'')='30' or isnull(@tmpItem,'')='31' )                                         
		begin                                             
			if(isnull(@tmpItem,'')='26' or isnull(@tmpItem,'')='27' or isnull(@tmpItem,'')='30' )                              
				set @empTicheng = @tmpYeji*ISNULL(@hz_salaryrate_qh,0)                                 
			else if (isnull(@tmpItem,'')='28')                              
				set @empTicheng = @tmpYeji*ISNULL(@hz_salaryrate_jd,0)                              
		end        
		--�Ƴ̶һ�  4      
		else if(isnull(@tmpItem,'')='4')                                     
		begin                                      
			if(isnull(@empPostion,'')='00901' or isnull(@empPostion,'')='00902' or isnull(@empPostion,'')='00903'  )  --һ���Ͷ�����Ⱦʦ2% 
			begin                                        
				update #allstaff_work_detail set staffyeji=isnull(@tmpYeji,0)*ISNULL(@dh_costrate_trsa,0) where seqno=@tmpSeqId                                      
				set @empTicheng = @tmpYeji*ISNULL(@dh_costrate_trsa,0)*ISNULL(@dh_salaryrate_trsa,0)        
			end                                    
			else if ( isnull(@empPostion,'')='00904' or isnull(@empPostion,'')='008' )  --�������ļ���Ⱦʦ 2.5%  
			begin                                       
				update #allstaff_work_detail set staffyeji=isnull(@tmpYeji,0)*ISNULL(@dh_costrate_trsb,0) where seqno=@tmpSeqId                                    
				set @empTicheng = @tmpYeji*ISNULL(@dh_costrate_trsb,0)*ISNULL(@dh_salaryrate_trsb,0) 
			end                                         
			--��ϯ���ܼ࣬���ʦ��ҵ��20%,���20%                                       
			else if ( isnull(@empPostion,'')='003' or isnull(@empPostion,'')='006' or isnull(@empPostion,'')='007' or isnull(@empPostion,'')='00701' or isnull(@empPostion,'')='00702'  or isnull(@empPostion,'')='00102')                                        
			begin                                      
				update #allstaff_work_detail set staffyeji=isnull(@tmpYeji,0)*ISNULL(@dh_costrate_mf,0) where seqno=@tmpSeqId                                        
				set @empTicheng = isnull(@tmpYeji,0)*ISNULL(@dh_costrate_mf,0)*ISNULL(@dh_salaryrate_mf,0)                      
			end                                      
		end  
		--�Ƴ̶һ� (��������)   
		else if(isnull(@tmpItem,'')='25')                                     
		begin      
			                                
			if(isnull(@empPostion,'') in ('00901','00902','00903','00904','008') )  --һ���Ͷ�����Ⱦʦ2%                                         
			begin
				update #allstaff_work_detail set staffyeji=0 where seqno=@tmpSeqId 
				set @empTicheng = @tmpYeji*ISNULL(@jfdh_salary_reward,0)  
			end 
			else  if(isnull(@empPostion,'') in ('003','006','007','00701','00702') )  --һ���Ͷ�����Ⱦʦ2%                                         
			begin
				update #allstaff_work_detail set staffyeji=0 where seqno=@tmpSeqId 
				set @empTicheng = @tmpYeji*ISNULL(@jfdh_salary_reward,0)  
			end                                        
			else   
			begin
				set @empTicheng =0    
				update #allstaff_work_detail set staffyeji=0 where seqno=@tmpSeqId 
			end        
		end
		--�Ƴ̶һ� (�羱����)   
		else if(isnull(@tmpItem,'')='35')                                     
		begin                               
			if(isnull(@empPostion,'') in ('00103','004','00401') )  --����ʦ                                         
			begin
				update #allstaff_work_detail set staffyeji=0 where seqno=@tmpSeqId 
				set @empTicheng = @tmpYeji*ISNULL(@jjfw_salary_reward,0)   
			end                                           
			else   
			begin
				set @empTicheng =0    
				update #allstaff_work_detail set staffyeji=0 where seqno=@tmpSeqId 
			end        
		end     
		--32 ��Ŀ������
		else if(isnull(@tmpItem,'')='32')                                     
		begin      
			update #allstaff_work_detail set staffyeji=0 where seqno=@tmpSeqId 
			if(ISNULL(@SP105,'0')='1')
				set @empTicheng =  ISNULL(@jsr_salary_reward,0)      
			else 
				set @empTicheng = 0     
		end 
		--36 ��Ŀ������
		else if(isnull(@tmpItem,'')='36')                                     
		begin      
			update #allstaff_work_detail set paycode='1',staffyeji=ISNULL(@jjdh_yeji_reward,0) where seqno=@tmpSeqId 
			set @empTicheng = 0    
		end  
		--37����ʦ�ֹ���
		else if(isnull(@tmpItem,'')='37')                                     
		begin      
			update #allstaff_work_detail set staffyeji=25*ISNULL(@quan,1)   where seqno=@tmpSeqId 
			set @empTicheng =  25*ISNULL(@quan,1)
		end    
		--��Ŀ���� 7,8,9,10,11,12,13,14,15      
		else      
		begin      
			--��������ʦ����Ⱦ��Ŀ��Ŀ
			if(isnull(@empPostion,'') in ('003','006','007','00701','00702') and ISNULL(@trkcqualified,0)=1)
			begin
				if exists(select 1 from projectnameinfo where prjno=@tmpPrjId and ISNULL(prjreporttype,'') in ('02','03'))
				begin
					update #allstaff_work_detail set staffyeji=0,staffticheng=0 where seqno=@tmpSeqId                                        
					set @empTicheng = 0     
					fetch cur_yeji_ticheng into @tmpSeqId,@tmpEmpId,@tmpItem,@tmpYeji,@tmpPrjId,@tmpDate ,@paycode ,@cardtype,@quan ,@arrivaldmonth,@csitemstate,@billinsertype,@costpricetype                                     
					continue 
				end
			end  
			set @fuflag=@quan         
			if(isnull(@paycode,'')='9') --�Ƴ�                                                        
			begin                                                          
				--�Ƴ���������ʦ������ʦ�����趨�ɱ���ҵ��������                                    
				select @proflag=isnull(prjpricetype,2),@PROJECT_COST=isnull(costprice,0),@Performance_Ratio=isnull(lyjrate,1),
					@Wage_Rates=isnull(ltcrate,1),@PROJECT_TYPE=prjtype,@newcosttc=newcosttc,@oldcosttc=oldcosttc ,@prjsaletype=isnull(prjsaletype,0)      
					from  projectinfo a,sysparaminfo b     
					where b.paramid='SP059' and b.compid=@compid and b.paramvalue=a.prjmodeId and prjno=@tmpPrjId                                     
				
				 --����ʦC���������
				if(isnull(@empPostion,'') ='00402'  and ISNULL(@proflag,2)=1)                                      
				begin                                      
					update #allstaff_work_detail set staffyeji=0 where seqno=@tmpSeqId                                        
					set @empTicheng = 0     
					fetch cur_yeji_ticheng into @tmpSeqId,@tmpEmpId,@tmpItem,@tmpYeji,@tmpPrjId,@tmpDate ,@paycode ,@cardtype,@quan ,@arrivaldmonth,@csitemstate,@billinsertype,@costpricetype                                     
					continue                                    
				end  
				 
				if(ISNULL(@newcosttc,0)>0 or ISNULL(@oldcosttc,0)>0)
				begin
						if(  isnull(@tmpItem,'')='7')
							update #allstaff_work_detail set staffticheng=@oldcosttc*@fuflag  where seqno=@tmpSeqId 
						else   if(  isnull(@tmpItem,'')='8')
							update #allstaff_work_detail set staffticheng=@newcosttc*@fuflag  where seqno=@tmpSeqId 
						else
							update #allstaff_work_detail set staffticheng=0 where seqno=@tmpSeqId 
						--���Ƴ̵��Ƴ���Ŀ 
						if(ISNULL(@prjsaletype,0)<>1)
							 update #allstaff_work_detail set staffticheng=60*@fuflag  where seqno=@tmpSeqId                                     
						fetch cur_yeji_ticheng into @tmpSeqId,@tmpEmpId,@tmpItem,@tmpYeji,@tmpPrjId,@tmpDate ,@paycode ,@cardtype,@quan ,@arrivaldmonth,@csitemstate,@billinsertype,@costpricetype                                     
						continue  
				end
				update #allstaff_work_detail set staffyeji=(isnull(@tmpYeji,0)*isnull(@PROJECT_COST,0))*isnull(@Performance_Ratio,0) where seqno=@tmpSeqId                                             
				set @empTicheng = (isnull(@tmpYeji,0)*isnull(@PROJECT_COST,0))*@Performance_Ratio*@Wage_Rates                                            
                                              
				--��Ⱦʦ ���Ƴ̿� ��80%ҵ�� ��5%��� ���Ƴ̿���120���ҵ����6��Ǯ�����                                      
				if(isnull(@empPostion,'')='00901' or isnull(@empPostion,'')='00902'  or isnull(@empPostion,'')='00903'  or isnull(@empPostion,'')='00904' or isnull(@empPostion,'')='008' )                                          
				begin            
					if( isnull(@cardtype,'') ='MR' or isnull(@cardtype,'')='MF')                                          
					begin                                      
						update #allstaff_work_detail set staffyeji=ISNULL(@olc_cost_yeji_fixed,0)*@fuflag where seqno=@tmpSeqId                                             
						set @empTicheng=ISNULL(@olc_cost_salary_fixed,0)*@fuflag                                      
					end                                       
					else                                      
					begin                                           
						update #allstaff_work_detail set staffyeji=isnull(@tmpYeji,0)*ISNULL(@nlc_costrate_tr,0) where seqno=@tmpSeqId                               
						set @empTicheng = isnull(@tmpYeji,0)*ISNULL(@nlc_costrate_tr,0)*ISNULL(@salaryrate_tra,0)                                      
						if(isnull(@empPostion,'')='00904' or isnull(@empPostion,'')='008')--�ļ���Ⱦʦ                                      
							set @empTicheng = isnull(@tmpYeji,0)*ISNULL(@nlc_costrate_tr,0)*ISNULL(@salaryrate_trb,0)                                      
					end                                         
				end                                                            
				if(isnull(@empPostion,'')in('004','00103','00401','00402') and ISNULL(@PROJECT_TYPE,'') in ('3','6') and ISNULL(@proflag,2)=1)                                      
				begin                                      
					update #allstaff_work_detail set staffyeji=0 where seqno=@tmpSeqId                                        
					set @empTicheng = 0                                       
				end                                      
				if(isnull(@empPostion,'') in ('003','006','007','00701','00702','00901','00902','00903','00904','008')  and ISNULL(@PROJECT_TYPE,'') ='4' and ISNULL(@proflag,2)=1)                                      
				begin                                      
					update #allstaff_work_detail set staffyeji=0 where seqno=@tmpSeqId                                        
					set @empTicheng = 0                                       
				end                                       
				--�������������й���С��λ�õ�(����ʦ,��ϯ,�ܼ�)�����                                      
				if((@PROJECT_TYPE='3' or @PROJECT_TYPE='6') and isnull(@empPostion,'') in ('003','006','007','00701','00702') and isnull(@tmpItem,'') not in ('7','8','9'))                                      
				begin                                      
					set @empTicheng = 0                                       
				end                                      
				if(@cardtype ='MFOLD' )                                       
				begin                                      
					update #allstaff_work_detail set staffyeji=0 where seqno=@tmpSeqId                                        
					set @empTicheng =0                                      
				end                                                         
			end   
			else if( (@cardtype ='ZK' and isnull(@paycode,'')='4') or (@cardtype ='ZK' and isnull(@paycode,'')='17')  or isnull(@paycode,'')='$'  or isnull(@paycode,'')='A' or isnull(@paycode,'')='7' or isnull(@paycode,'')='11'  or isnull(@paycode,'')='12'  )                     
			begin                                   
				select @proflag=isnull(prjpricetype,2),@newcosttc=newcosttc,@oldcosttc=oldcosttc      
				from  projectinfo a,sysparaminfo b     
				where b.paramid='SP059' and b.compid=@compid and b.paramvalue=a.prjmodeId and prjno=@tmpPrjId  
				
				--����ʦC���������
				if(isnull(@empPostion,'') ='00402'  and ISNULL(@proflag,2)=1)                                      
				begin                                      
					update #allstaff_work_detail set staffyeji=0 where seqno=@tmpSeqId                                        
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
							update #allstaff_work_detail set staffticheng=@oldcosttc*@fuflag  where seqno=@tmpSeqId 
					else   if(  isnull(@tmpItem,'')='7' and ISNULL(@costpricetype,0)=1  ) --ָ����������Ŀ
					begin
							if(ISNULL(@oldcosttc,0)>ISNULL(@mr_salary_fixed_ty,0))
							begin
								update #allstaff_work_detail set staffticheng=ISNULL(@mr_salary_fixed_ty,0)*@fuflag  where seqno=@tmpSeqId 
								set @empTicheng=ISNULL(@mr_salary_fixed_ty,0)*@fuflag
							end
							else
							begin
								update #allstaff_work_detail set staffticheng=@oldcosttc*@fuflag  where seqno=@tmpSeqId 
								set @empTicheng=@oldcosttc*@fuflag
							end
					end
					else   if(  isnull(@tmpItem,'')='8'  and ISNULL(@costpricetype,0)=0) --�¿ͷ�������Ŀ
							update #allstaff_work_detail set staffticheng=@newcosttc*@fuflag  where seqno=@tmpSeqId 
					else   if(  isnull(@tmpItem,'')='8'  and ISNULL(@costpricetype,0)=1) --�¿�������Ŀ
					begin
							if(ISNULL(@newcosttc,0)>ISNULL(@mr_salary_fixed_ty,0))
							begin
								update #allstaff_work_detail set staffticheng=ISNULL(@mr_salary_fixed_ty,0)*@fuflag  where seqno=@tmpSeqId 
								set @empTicheng=ISNULL(@mr_salary_fixed_ty,0)*@fuflag 
							end
							else
							begin
								update #allstaff_work_detail set staffticheng=@newcosttc*@fuflag  where seqno=@tmpSeqId
								set @empTicheng=@newcosttc*@fuflag 
							end
					end
					else   if(  isnull(@tmpItem,'')='9' and ISNULL(@costpricetype,0)=1) --�¿��Ƽ�����
					begin
							if(ISNULL(@newcosttc,0)>ISNULL(@mr_salary_fixed_ty,0))
							begin
								update #allstaff_work_detail set staffticheng=ISNULL(@mr_salary_fixed_ty,0)*@fuflag  where seqno=@tmpSeqId 
								set @empTicheng=ISNULL(@mr_salary_fixed_ty,0)*@fuflag 
							end
							else
							begin
								update #allstaff_work_detail set staffticheng=@newcosttc*@fuflag  where seqno=@tmpSeqId
								set @empTicheng=@newcosttc*@fuflag 
							end
							--set @empTicheng=(@mr_salary_fixed_ty-ISNULL(@tjsr_salary_cost,0))*@fuflag
					end
					else   if(  isnull(@tmpItem,'')='9' and ISNULL(@costpricetype,0)=0) --�¿��Ƽ�������
					begin
							update #allstaff_work_detail set staffticheng=(@newcosttc-ISNULL(@tjsr_salary_cost,0))*@fuflag  where seqno=@tmpSeqId 
							--set @empTicheng=(@newcosttc-ISNULL(@tjsr_salary_cost,0))*@fuflag
					end
					else
							update #allstaff_work_detail set staffticheng=0 where seqno=@tmpSeqId                                       
					fetch cur_yeji_ticheng into @tmpSeqId,@tmpEmpId,@tmpItem,@tmpYeji,@tmpPrjId,@tmpDate ,@paycode ,@cardtype,@quan,@arrivaldmonth ,@csitemstate,@billinsertype,@costpricetype                                     
					continue  
				end
				if(@tmpPrjId in ('321','322','323','324','325','326','327','328','329','330','331','332') and isnull(@tmpItem,'')  in ('10','11','12') and  isnull(@empPostion,'') not in ('003','006','007','00701','00702') )
				begin
						if(  ISNULL(@csitemstate,1)=1)
							update #allstaff_work_detail set staffticheng=ISNULL(@xjc_salary_fixed_db,0)*@fuflag  where seqno=@tmpSeqId 
						else   if( ISNULL(@csitemstate,1)=2)
							update #allstaff_work_detail set staffticheng=ISNULL(@xjc_salary_fixed_ndb,0)*@fuflag  where seqno=@tmpSeqId 
						else   if( ISNULL(@csitemstate,1)=3)
							update #allstaff_work_detail set staffticheng=ISNULL(@xjc_salary_fixed_nhg,0)*@fuflag  where seqno=@tmpSeqId 
						else
							update #allstaff_work_detail set staffticheng=0 where seqno=@tmpSeqId                                      
						fetch cur_yeji_ticheng into @tmpSeqId,@tmpEmpId,@tmpItem,@tmpYeji,@tmpPrjId,@tmpDate ,@paycode ,@cardtype,@quan,@arrivaldmonth ,@csitemstate,@billinsertype,@costpricetype                                     
						continue 
				end  
				if(@tmpPrjId in ('321','322','323','324','325','326','327','328','329','330','331','332') and isnull(@tmpItem,'')  in ('13','14','15') )
				begin
						update #allstaff_work_detail set staffticheng=0 where seqno=@tmpSeqId                                      
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
						update #allstaff_work_detail set staffticheng=25*@fuflag where seqno=@tmpSeqId                                      
						fetch cur_yeji_ticheng into @tmpSeqId,@tmpEmpId,@tmpItem,@tmpYeji,@tmpPrjId,@tmpDate ,@paycode ,@cardtype,@quan,@arrivaldmonth ,@csitemstate,@billinsertype,@costpricetype                                     
						continue
					end   
					--�µǼǵ���ȯ
					if(ISNULL(@dycardnocreatetype,0)<>0)
					begin
						update #allstaff_work_detail set staffticheng=ISNULL(@mr_salary_fixed_ty,0)*@fuflag where seqno=@tmpSeqId                                      
						fetch cur_yeji_ticheng into @tmpSeqId,@tmpEmpId,@tmpItem,@tmpYeji,@tmpPrjId,@tmpDate ,@paycode ,@cardtype,@quan,@arrivaldmonth ,@csitemstate,@billinsertype,@costpricetype                                     
						continue
					end   
					if(ISNULL(@fuflag,0)<0)                            
						set  @tmpYeji=ISNULL(@tmpYeji,0)*(-1)                                   
					update #allstaff_work_detail set staffyeji=@tmpYeji,billamt=@tmpYeji where seqno=@tmpSeqId                                        
				end                                       
				--��Ⱦʦ ��ҵ��24% ���5%                                      
				if(isnull(@empPostion,'')='00901' or isnull(@empPostion,'')='00902'  or isnull(@empPostion,'')='00903' or isnull(@empPostion,'')='00904' or isnull(@empPostion,'')='008')                                          
				begin                                      
					update #allstaff_work_detail set staffyeji=isnull(@tmpYeji,0)*ISNULL(@yjk_costrate_tr,0) where seqno=@tmpSeqId                                        
					set @empTicheng = isnull(@tmpYeji,0)*ISNULL(@yjk_costrate_tr,0)*ISNULL(@salaryrate_tra,0)                                       
					if( isnull(@empPostion,'')='00904' or isnull(@empPostion,'')='008')                
						set @empTicheng = isnull(@tmpYeji,0)*ISNULL(@yjk_costrate_tr,0)*ISNULL(@salaryrate_trb,0)                                        
				end                                        
				--��ϯ���ܼ࣬���ʦ��ҵ��24%,���22% ����ʦ��ҵ��24%,���22%                                       
				else                                       
				begin                                      
					update #allstaff_work_detail set staffyeji=isnull(@tmpYeji,0)*ISNULL(@yjk_costrate_mrmf,0) where seqno=@tmpSeqId                                        
					set @empTicheng = isnull(@tmpYeji,0)*ISNULL(@yjk_costrate_mrmf,0)*ISNULL(@yjk_salaryrate_mrmf,0)  
					if(  isnull(@tmpItem,'')='9' and ISNULL(@empTicheng,0)>ISNULL(@tjsr_salary_cost,0)) --�¿��Ƽ�     
						set  @empTicheng=ISNULL(@empTicheng,0)-ISNULL(@tjsr_salary_cost,0)                                  
				end                                        
				---ϴ������Ŀ ����ʦ�۳�0.25�ĳɱ� �ܼ�۳�0.11�ĳɱ� ��ϯ�۳�0.15�ĳɱ�                                      
				---������Ŀ����ʦ����ĸ�ϴ20��ҵ����ˮϵ5 ���ϵ��0.3         
                             
				if(@tmpPrjId in ('300','3002','301','302','303','305','306','309','311','321','322','323','324','325','326','327','328','329','330','331','332'))                                    
				begin                                      
					if(isnull(@empPostion,'')in('004','00103','00401','00402') or isnull(@empPostion,'')='00901' or isnull(@empPostion,'')='00902'  or isnull(@empPostion,'')='00903' or isnull(@empPostion,'')='00904' or isnull(@empPostion,'')='008')                            
					begin                                      
						if(@tmpPrjId='300' or @tmpPrjId='302' or @tmpPrjId='303'  or @tmpPrjId='309' )                                      
						begin                                      
							update #allstaff_work_detail set staffyeji=20*@fuflag where seqno=@tmpSeqId                                        
							set @empTicheng =6*@fuflag                                      
						end                                       
						else                                      
						begin                                      
							update #allstaff_work_detail set staffyeji=5*@fuflag where seqno=@tmpSeqId                                        
							set @empTicheng =1.5*@fuflag                                      
						end                                      
					end                                             
					if((@tmpPrjId='300' or @tmpPrjId='3002') and isnull(@tmpItem,'') not in ('7','8','9'))         
					begin                                      
						if(isnull(@empPostion,'')='006' or isnull(@empPostion,'') ='007' or isnull(@empPostion,'') ='00701' or isnull(@empPostion,'') ='00702')--��ϯ�ܼ�                                      
						begin                                      
							update #allstaff_work_detail set staffyeji=10*@fuflag where seqno=@tmpSeqId                                      
							set @empTicheng =3*@fuflag                                      
						end                                             
						else if(isnull(@empPostion,'')='003')                                      
						begin                                      
							update #allstaff_work_detail set staffyeji=10*@fuflag where seqno=@tmpSeqId                                      
							set @empTicheng =2.8*@fuflag                                      
						end                                             
						else                                       
						begin                                      
							update #allstaff_work_detail set staffyeji=0 where seqno=@tmpSeqId                                        
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
					update #allstaff_work_detail set staffyeji=0 where seqno=@tmpSeqId                                        
					set @empTicheng = 0     
					fetch cur_yeji_ticheng into @tmpSeqId,@tmpEmpId,@tmpItem,@tmpYeji,@tmpPrjId,@tmpDate ,@paycode ,@cardtype,@quan ,@arrivaldmonth,@csitemstate,@billinsertype,@costpricetype                                     
					continue                                    
				end 
				
				if(ISNULL(@newcosttc,0)>0 or ISNULL(@oldcosttc,0)>0)
				begin
					if(  isnull(@tmpItem,'')='7' and ISNULL(@costpricetype,0)=0 )  --ָ���ͷ�������Ŀ
					begin
							update #allstaff_work_detail set staffticheng=@oldcosttc*@fuflag  where seqno=@tmpSeqId 
							set @empTicheng=@oldcosttc*@fuflag
					end
					else   if(  isnull(@tmpItem,'')='7' and ISNULL(@costpricetype,0)=1  ) --ָ����������Ŀ
					begin
							if(ISNULL(@oldcosttc,0)>ISNULL(@mr_salary_fixed_ty,0))
							begin
								update #allstaff_work_detail set staffticheng=ISNULL(@mr_salary_fixed_ty,0)*@fuflag  where seqno=@tmpSeqId 
								set @empTicheng=ISNULL(@mr_salary_fixed_ty,0)*@fuflag
							end
							else
							begin
								update #allstaff_work_detail set staffticheng=@oldcosttc*@fuflag  where seqno=@tmpSeqId 
								set @empTicheng=@oldcosttc*@fuflag
							end
					end
					else   if(  isnull(@tmpItem,'')='8' and ISNULL(@costpricetype,0)=0) --�¿ͷ�������Ŀ
					begin
							update #allstaff_work_detail set staffticheng=@newcosttc*@fuflag  where seqno=@tmpSeqId
							set @empTicheng=@newcosttc*@fuflag 
					end
					else   if(  isnull(@tmpItem,'')='8' and ISNULL(@costpricetype,0)=1) --�¿�������Ŀ
					begin
							if(ISNULL(@newcosttc,0)>ISNULL(@mr_salary_fixed_ty,0))
							begin
								update #allstaff_work_detail set staffticheng=ISNULL(@mr_salary_fixed_ty,0)*@fuflag  where seqno=@tmpSeqId 
								set @empTicheng=ISNULL(@mr_salary_fixed_ty,0)*@fuflag 
							end
							else
							begin
								update #allstaff_work_detail set staffticheng=@newcosttc*@fuflag  where seqno=@tmpSeqId
								set @empTicheng=@newcosttc*@fuflag 
							end
					end
					else   if(  isnull(@tmpItem,'')='9' and ISNULL(@costpricetype,0)=1) --�¿��Ƽ�����
					begin
							if(ISNULL(@newcosttc,0)>ISNULL(@mr_salary_fixed_ty,0))
							begin
								update #allstaff_work_detail set staffticheng=(@mr_salary_fixed_ty-ISNULL(@tjsr_salary_cost,0))*@fuflag  where seqno=@tmpSeqId 
								set @empTicheng=(@mr_salary_fixed_ty-ISNULL(@tjsr_salary_cost,0))*@fuflag
							end
							else
							begin
								update #allstaff_work_detail set staffticheng=(@newcosttc-ISNULL(@tjsr_salary_cost,0))*@fuflag  where seqno=@tmpSeqId 
								set @empTicheng=(@newcosttc-ISNULL(@tjsr_salary_cost,0))*@fuflag
							end
					end
					else   if(  isnull(@tmpItem,'')='9' and ISNULL(@costpricetype,0)=0) --�¿��Ƽ�������
					begin
							update #allstaff_work_detail set staffticheng=(@newcosttc-ISNULL(@tjsr_salary_cost,0))*@fuflag  where seqno=@tmpSeqId 
							set @empTicheng=(@newcosttc-ISNULL(@tjsr_salary_cost,0))*@fuflag
					end
					else
					begin
							update #allstaff_work_detail set staffticheng=0 where seqno=@tmpSeqId
							set @empTicheng=0
					end  
					if( isnull(@paycode,'')='13')
					begin
							update #allstaff_work_detail set staffticheng=ISNULL(@mr_salary_fixed_tmk,0)*@fuflag  where seqno=@tmpSeqId 
							set @empTicheng=ISNULL(@mr_salary_fixed_tmk,0)*@fuflag 
					end	                                   
					fetch cur_yeji_ticheng into @tmpSeqId,@tmpEmpId,@tmpItem,@tmpYeji,@tmpPrjId,@tmpDate ,@paycode ,@cardtype,@quan,@arrivaldmonth ,@csitemstate,@billinsertype,@costpricetype                                     
					continue  
				end
				
				if(@tmpPrjId in ('321','322','323','324','325','326','327','328','329','330','331','332') and isnull(@tmpItem,'')  in ('10','11','12') and  isnull(@empPostion,'') not in ('003','006','007','00701','00702') )
				begin
						if(  ISNULL(@csitemstate,1)=1)
							update #allstaff_work_detail set staffticheng=ISNULL(@xjc_salary_fixed_db,0)*@fuflag  where seqno=@tmpSeqId 
						else   if( ISNULL(@csitemstate,1)=2)
							update #allstaff_work_detail set staffticheng=ISNULL(@xjc_salary_fixed_ndb,0)*@fuflag  where seqno=@tmpSeqId 
						else   if( ISNULL(@csitemstate,1)=3)
							update #allstaff_work_detail set staffticheng=ISNULL(@xjc_salary_fixed_nhg,0)*@fuflag  where seqno=@tmpSeqId 
						else
							update #allstaff_work_detail set staffticheng=0 where seqno=@tmpSeqId                                      
						fetch cur_yeji_ticheng into @tmpSeqId,@tmpEmpId,@tmpItem,@tmpYeji,@tmpPrjId,@tmpDate ,@paycode ,@cardtype,@quan,@arrivaldmonth ,@csitemstate,@billinsertype,@costpricetype                                     
						continue 
				end  
				if(@tmpPrjId in ('321','322','323','324','325','326','327','328','329','330','331','332') and isnull(@tmpItem,'')  in ('13','14','15') )
				begin
						update #allstaff_work_detail set staffticheng=0 where seqno=@tmpSeqId                                      
						fetch cur_yeji_ticheng into @tmpSeqId,@tmpEmpId,@tmpItem,@tmpYeji,@tmpPrjId,@tmpDate ,@paycode ,@cardtype,@quan,@arrivaldmonth ,@csitemstate,@billinsertype,@costpricetype                                     
						continue 
				end     
				--if(@compid in ('006','047','033','014','041','046') and isnull(@empPostion,'')  in ('003','006','007','00701','00702')   )
				if(isnull(@isNewComdMode,0)=1 and isnull(@empPostion,'')  in ('003','006','007','00701','00702') and ISNULL(@PROJECT_TYPE,'')<>'6'  )
				begin
					if(ISNULL(@arrivaldmonth,0)<=5)
					begin
						set @Wage_Rates=ISNULL(@mf_salaryrate_fivedown,0)  --********��6�ҵ�����ʦ5���ڵ����ϵ��Ϊ0.3
					end
					else
					begin
						set @Wage_Rates=ISNULL(@mf_salaryrate_fiveup,0)  --********��6�ҵ�����ϵ��Ϊ0.25
					end
				end          
				if(@PROJECT_TYPE<>'5')--���׳ɱ�������                        
				begin                        
					update #allstaff_work_detail set staffyeji=(isnull(@tmpYeji,0)*isnull(@PROJECT_COST,0))*isnull(@Performance_Ratio,0) where seqno=@tmpSeqId                                             
				end 
				
				    
				set @empTicheng = (isnull(@tmpYeji,0)*isnull(@PROJECT_COST,0))*@Performance_Ratio*@Wage_Rates
				if(  isnull(@tmpItem,'')='9' and ISNULL(@empTicheng,0)>ISNULL(@tjsr_salary_cost,0)) --�¿��Ƽ� 
					set @empTicheng =ISNULL(@empTicheng,0) -ISNULL(@tjsr_salary_cost,0)  
					                                         
				--��ϯ�ܼ� �۳��ɱ����ҵ�����ʣ���� 30%                                      
				--if(@compid not in ('006','047','033','014','041','046') )  --��6�ҵ��Ϊ��׼��ϵ��
				if(isnull(@isNewComdMode,0)=0)
				begin 
					if((isnull(@empPostion,'')='006' or isnull(@empPostion,'') ='007' or isnull(@empPostion,'') ='00701' or isnull(@empPostion,'') ='00702') and ISNULL(@PROJECT_TYPE,'0')<>'6' )                                          
						set @empTicheng = (isnull(@tmpYeji,0)*isnull(@PROJECT_COST,0))*@Performance_Ratio*0.3                                           
				end
				--��Ⱦʦ �۳��ɱ����ҵ��5%                                      
				if(isnull(@empPostion,'')='00901' or isnull(@empPostion,'')='00902'  or isnull(@empPostion,'')='00903'  )                                          
					set @empTicheng = (isnull(@tmpYeji,0)*isnull(@PROJECT_COST,0))*isnull(@Performance_Ratio,0)*ISNULL(@salaryrate_tra,0)                                           
				if( isnull(@empPostion,'')='00904' or isnull(@empPostion,'')='008')                                      
					set @empTicheng = (isnull(@tmpYeji,0)*isnull(@PROJECT_COST,0))*isnull(@Performance_Ratio,0)*ISNULL(@salaryrate_trb,0)                                           
                         
				---ϴ������Ŀ ����ʦ�۳�0.25�ĳɱ� �ܼ�۳�0.11�ĳɱ� ��ϯ�۳�0.15�ĳɱ�                                      
				---������Ŀ����ʦ����ĸ�ϴ20��ҵ����ˮϵ5 ���ϵ��0.3                                          
				if(@tmpPrjId in ('300','3002','301','302','303','305','306','309','311','321','322','323','324','325','326','327','328','329','330','331','332'))                                    
				begin                                      
					if(isnull(@empPostion,'')='003') --����ʦ                                      
					begin 
					    --if(@compid in ('006','047','033','014','041','046')  )
					    if(isnull(@isNewComdMode,0)=1)
						begin
							update #allstaff_work_detail set staffyeji=isnull(@tmpYeji,0)*ISNULL(@xjc_costrate_sjs,0) where seqno=@tmpSeqId                                        
							set @empTicheng = isnull(@tmpYeji,0)*ISNULL(@xjc_costrate_sjs,0)*@Wage_Rates        
						end 
						else
						begin                                     
							update #allstaff_work_detail set staffyeji=isnull(@tmpYeji,0)*ISNULL(@xjc_costrate_sjs,0) where seqno=@tmpSeqId                                        
							set @empTicheng = isnull(@tmpYeji,0)*ISNULL(@xjc_costrate_sjs,0)*0.28 
						end                                        
					end                                       
					else if(isnull(@empPostion,'')='006') --��ϯ                                      
					begin  
						--if(@compid in ('006','047','033','014','041','046')   )
						if(isnull(@isNewComdMode,0)=1)
						begin
							update #allstaff_work_detail set staffyeji=isnull(@tmpYeji,0)*ISNULL(@xjc_costrate_sx,0) where seqno=@tmpSeqId                                        
							set @empTicheng = isnull(@tmpYeji,0)*ISNULL(@xjc_costrate_sx,0)*@Wage_Rates        
						end 
						else
						begin                                      
							update #allstaff_work_detail set staffyeji=isnull(@tmpYeji,0)*ISNULL(@xjc_costrate_sx,0) where seqno=@tmpSeqId                                        
							set @empTicheng = isnull(@tmpYeji,0)*ISNULL(@xjc_costrate_sx,0)*0.3   
						end                      
					end                                   
					else if(isnull(@empPostion,'')='007' or isnull(@empPostion,'')='00701' or isnull(@empPostion,'')='00702') --�ܼ�                                     
					begin                                      
						--if(@compid in ('006','047','033','014','041','046')   )
						if(isnull(@isNewComdMode,0)=1)
						begin
							update #allstaff_work_detail set staffyeji=isnull(@tmpYeji,0)*ISNULL(@xjc_costrate_zj,0) where seqno=@tmpSeqId                                        
							set @empTicheng = isnull(@tmpYeji,0)*ISNULL(@xjc_costrate_zj,0)*@Wage_Rates        
						end 
						else
						begin   
							update #allstaff_work_detail set staffyeji=isnull(@tmpYeji,0)*ISNULL(@xjc_costrate_zj,0) where seqno=@tmpSeqId                                        
							set @empTicheng = isnull(@tmpYeji,0)*ISNULL(@xjc_costrate_zj,0)*0.3 
						end                                       
					end                                                      
					else if(isnull(@empPostion,'')in('004','00103','00401','00402') or isnull(@empPostion,'')='00901' or isnull(@empPostion,'')='00902'  or isnull(@empPostion,'')='00903' or isnull(@empPostion,'')='00904' or isnull(@empPostion,'')='008')                       
					begin                                      
						if(@tmpPrjId='300' or @tmpPrjId='302' or @tmpPrjId='303'  or @tmpPrjId='309' ) 
						begin                                      
							update #allstaff_work_detail set staffyeji=20*@fuflag where seqno=@tmpSeqId                                        
							set @empTicheng =6*@fuflag                                      
						end                                       
						else                                      
						begin                                     
							update #allstaff_work_detail set staffyeji=5*@fuflag where seqno=@tmpSeqId                                        
							set @empTicheng =1.5*@fuflag                                      
						end                                      
					end     
					   
					if((@tmpPrjId='300' or @tmpPrjId='3002') and isnull(@tmpItem,'') not in ('7','8','9'))                       
					begin                                            
						if(isnull(@empPostion,'')='006' or isnull(@empPostion,'') ='007' or isnull(@empPostion,'') ='00701' or isnull(@empPostion,'') ='00702')--��ϯ�ܼ�              
						begin                                      
							update #allstaff_work_detail set staffyeji=10*@fuflag where seqno=@tmpSeqId                                      
							set @empTicheng =3*@fuflag                                      
						end                                             
						else if(isnull(@empPostion,'')='003')                                      
						begin                                      
							update #allstaff_work_detail set staffyeji=10*@fuflag where seqno=@tmpSeqId                                      
							set @empTicheng =2.8*@fuflag                                      
						end                                             
						else                                       
						begin                                      
							update #allstaff_work_detail set staffyeji=0 where seqno=@tmpSeqId                                        
							set @empTicheng =0                                      
						end                    
					end                                      
				end                                      
				if(isnull(@paycode,'')='13' )                                      
				begin                                      
					declare @tmcardfrom int --0 ��������,1 ���Ϳ���                                      
					select @tmcardfrom=ISNULL(entrytype,0) from nointernalcardinfo where cardno=@cardtype                                      
					if(ISNULL(@tmcardfrom,0)=1)                                      
					begin                                      
						--��Ⱦʦ ��ҵ��24% ���5%                                      
						if(isnull(@empPostion,'')='00901' or isnull(@empPostion,'')='00902'  or isnull(@empPostion,'')='00903' or isnull(@empPostion,'')='00904' or isnull(@empPostion,'')='008')                                          
						begin                                      
							update #allstaff_work_detail set staffyeji=isnull(@tmpYeji,0)*0.24 where seqno=@tmpSeqId                                        
							set @empTicheng = isnull(@tmpYeji,0)*0.24*0.05                                        
							if( isnull(@empPostion,'')='00904' or isnull(@empPostion,'')='008' )                                      
								set @empTicheng = isnull(@tmpYeji,0)*0.24*0.06                                        
						end                                        
						--��ϯ���ܼ࣬���ʦ��ҵ��24%,���22% ����ʦ��ҵ��24%,���22%                                       
						else                                       
						begin                                      
							update #allstaff_work_detail set staffyeji=isnull(@tmpYeji,0)*0.24 where seqno=@tmpSeqId                                        
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
								update #allstaff_work_detail set staffyeji=isnull(@tmpYeji,0)*0.9 where seqno=@tmpSeqId                                        
								set @empTicheng = isnull(@tmpYeji,0)*0.9*0.6                            
							end                                    
					end                                      
					else                                      
					begin                                      
							update #allstaff_work_detail set staffyeji=0 where seqno=@tmpSeqId                                        
							set @empTicheng =0                                      
					end                                      
				end           
				--һ��һ����һ(�)              
				if(isnull(@empPostion,'') in('004','00103','00401','00402')  and @tmpPrjId in ('48811') and isnull(@paycode,'')<>'13')                                      
				begin                                      
					if(isnull(@tmpItem,'') in ('7','8','9'))                      
					begin             
						if(isnull(@tmpYeji,0)<100)           
							set @tmpYeji=100                            
						update #allstaff_work_detail set staffyeji= isnull(@tmpYeji,0)*0.8 where seqno=@tmpSeqId                 
						set @empTicheng = isnull(@tmpYeji,0)*0.8*0.3*@fuflag                      
					end                                 
					else                                      
					begin                                      
						update #allstaff_work_detail set staffyeji=0 where seqno=@tmpSeqId                                        
						set @empTicheng = 0                     
					end                                      
				end                                     
				if(isnull(@empPostion,'')in('004','00103','00401','00402') and ISNULL(@PROJECT_TYPE,'') in ('3','6') and ISNULL(@proflag,2)=1)                                      
				begin                             
					update #allstaff_work_detail set staffyeji=0 where seqno=@tmpSeqId                                        
					set @empTicheng = 0                                       
				end                    
				if(isnull(@empPostion,'') in ('003','006','007','00701','00702','00901','00902','00903','00904','008')  and ISNULL(@PROJECT_TYPE,'') ='4' and ISNULL(@proflag,2)=1)                                      
				begin                                      
					update #allstaff_work_detail set staffyeji=0 where seqno=@tmpSeqId                                        
					set @empTicheng = 0                                       
				end                                       
			end       
		end                    
		---�������                                   
		update #allstaff_work_detail set staffticheng=@empTicheng,person_inid=@empinid,postation=@empPostion where seqno=@tmpSeqId                                                                        
		fetch cur_yeji_ticheng into @tmpSeqId,@tmpEmpId,@tmpItem,@tmpYeji,@tmpPrjId,@tmpDate ,@paycode ,@cardtype,@quan,@arrivaldmonth,@csitemstate,@billinsertype,@costpricetype                                 
	end                                                              
	close cur_yeji_ticheng                                                              
	deallocate cur_yeji_ticheng                  
         
      
  if(@handtype=2)      
  begin      
		delete allstaff_work_detail_daybyday where compid=@compid and srvdate=@fromdate      
		insert allstaff_work_detail_daybyday(compid,person_inid,action_id,srvdate,code,name,payway,billamt,ccount,cost,staffticheng,staffyeji,prj_type,cls_flag,billid,paycode,cardid,cardtype,postation)      
		select compid,person_inid,action_id,srvdate,code,name,payway,billamt,ccount,cost,staffticheng,staffyeji,prj_type,cls_flag,billid,paycode,cardid,cardtype,postation      
		from #allstaff_work_detail      
	end      
	--����ʦ��������Ŀ ����ָ��ҵ��������ͨ����ɱ���                                      
	--����ʦҵ����2.5W,��ϯ��5W,�ܼ� 7W ������Ŀ��ɱ���0.35                                      
	create  table #emp_yeji_total_resultx                                       
	(                                      
		inid  varchar(20) null,  --Ա���ڲ����                                         
		yeji  float  null, -- ҵ��                       
		lv   float  null, --��ɱ���                                           
	)                                         
                  
    insert #emp_yeji_total_resultx(inid,yeji)                                             
	select  person_inid,sum(isnull(staffyeji,0)) from #allstaff_work_detail where ISNULL(action_id,-1)<>4 and paycode in ('1','2','6','0','14','15') group by person_inid                                    
    
    --if(@compid in ('006','047','033','014','041','046'))
    if(isnull(@isNewComdMode,0)=1)
    begin
		if exists (select 1 from compchaininfo where curcomp='00105' and relationcomp=@compid )
		begin
			--��6�� 5�������� ����ʦ  5W�� 0.35 5W ��0.40
			update a set staffticheng=isnull(staffyeji,0)*0.35                                      
			from #allstaff_work_detail a ,#emp_yeji_total_resultx b,projectnameinfo with(nolock)                                      
			where a.person_inid=b.inid and isnull(a.postation,'') in ('003','006','007','00701','00702')                                        
			and action_id in (7,10,13)  and ISNULL(paycode,'') not in ('9','11','12')                                       
			and b.yeji<50000 and  prjno=code and prjtype='3'                                      
			and isnull(cardtype,'')   not in ('MFOLD','ZK') 
			--and ISNULL(arrivaldmonth,0)>5  
			
			update a set staffticheng=isnull(staffyeji,0)*0.4                                      
			from #allstaff_work_detail a ,#emp_yeji_total_resultx b,projectnameinfo with(nolock)                                      
			where a.person_inid=b.inid and isnull(a.postation,'') in ('003','006','007','00701','00702')                                       
			and action_id in (7,10,13)  and ISNULL(paycode,'') not in ('9','11','12')                                       
			and b.yeji>=50000 and  prjno=code and prjtype='3'                                      
			and isnull(cardtype,'')   not in ('MFOLD','ZK') 
			--and ISNULL(arrivaldmonth,0)>5  
		end
		else
		begin		
			update a set staffticheng=isnull(staffyeji,0)*0.30                                      
			from #allstaff_work_detail a ,projectnameinfo with(nolock)                                      
			where isnull(a.postation,'')  in ('003','006','007','00701','00702')                                           
			and action_id in (7,10,13)  and ISNULL(paycode,'') not in ('9','11','12')                                      
			and  prjno=code and prjtype='3'                                      
			and isnull(cardtype,'')   not in ('MFOLD','ZK') 
			and ISNULL(srvdate,'')<='20140831'
			
			--��6�� 5�������� ����ʦ 1W-2W(������2W) �Ͽ���ɱ���Ϊ30%
			update a set staffticheng=isnull(staffyeji,0)*0.30                                      
			from #allstaff_work_detail a ,#emp_yeji_total_resultx b,projectnameinfo with(nolock)                                      
			where a.person_inid=b.inid and isnull(a.postation,'')='003'                                       
			and action_id in (7,10,13)  and ISNULL(paycode,'') not in ('9','11','12')                                      
			and b.yeji>=10000 and b.yeji<20000 and  prjno=code and prjtype='3'                                      
			and isnull(cardtype,'')   not in ('MFOLD','ZK') 
			--and ISNULL(arrivaldmonth,0)>5  
			
			
			--��6�� 5�������� ����ʦ 2W���� �Ͽ���ɱ���Ϊ35%
			update a set staffticheng=isnull(staffyeji,0)*0.35                                     
			from #allstaff_work_detail a ,#emp_yeji_total_resultx b,projectnameinfo with(nolock)                                      
			where a.person_inid=b.inid and isnull(a.postation,'')='003'                                       
			and action_id in (7,10,13)  and ISNULL(paycode,'') not in ('9','11','12')                                      
			and b.yeji>=20000 and  prjno=code and prjtype='3'                                      
			and isnull(cardtype,'')   not in ('MFOLD','ZK') 
			--and ISNULL(arrivaldmonth,0)>5                                    
	         
			----��6�� 5�������� ��ϯ 2W-3W(������3W) �Ͽ���ɱ���Ϊ30%    
			update a set staffticheng=isnull(staffyeji,0)*0.30                                      
			from #allstaff_work_detail a ,#emp_yeji_total_resultx b,projectnameinfo with(nolock)                                      
			where a.person_inid=b.inid and isnull(a.postation,'')='006'                                       
			and action_id in (7,10,13) and ISNULL(paycode,'') not in ('9','11','12')                                      
			and b.yeji>=20000 and b.yeji<30000 and  prjno=code and prjtype='3'                                      
			and isnull(cardtype,'')   not in ('MFOLD','ZK')    
			--and ISNULL(arrivaldmonth,0)>5    
			
			----��6�� 5�������� ��ϯ 3W-5W(������5W) �Ͽ���ɱ���Ϊ35%    
			update a set staffticheng=isnull(staffyeji,0)*0.35                                     
			from #allstaff_work_detail a ,#emp_yeji_total_resultx b,projectnameinfo with(nolock)                                      
			where a.person_inid=b.inid and isnull(a.postation,'')='006'                                       
			and action_id in (7,10,13) and ISNULL(paycode,'') not in ('9','11','12')                                      
			and b.yeji>=30000 and b.yeji<50000 and  prjno=code and prjtype='3'                                      
			and isnull(cardtype,'')   not in ('MFOLD','ZK')    
			--and ISNULL(arrivaldmonth,0)>5    
			
			----��6�� 5�������� ��ϯ 5W���� �Ͽ���ɱ���Ϊ40%    
			update a set staffticheng=isnull(staffyeji,0)*0.40                                     
			from #allstaff_work_detail a ,#emp_yeji_total_resultx b,projectnameinfo with(nolock)                                      
			where a.person_inid=b.inid and isnull(a.postation,'')='006'                                       
			and action_id in (7,10,13) and ISNULL(paycode,'') not in ('9','11','12')                                      
			and b.yeji>=50000 and  prjno=code and prjtype='3'                                      
			and isnull(cardtype,'')   not in ('MFOLD','ZK')    
			--and ISNULL(arrivaldmonth,0)>5 
			
			                              
			----��6�� 5�������� �ܼ�,�����ܼ�,����ܼ� 3W-5W(������5W) �Ͽ���ɱ���Ϊ30%                              
			update a set staffticheng=isnull(staffyeji,0)*0.30                                      
			from #allstaff_work_detail a ,#emp_yeji_total_resultx b,projectnameinfo with(nolock)                                      
			where a.person_inid=b.inid and isnull(a.postation,'') in ('007' ,'00701','00702')                                     
			and action_id in (7,10,13) and ISNULL(paycode,'') not in ('9','11','12')                                      
			and b.yeji>=30000 and b.yeji<50000   and prjno=code and prjtype='3'                                      
			and isnull(cardtype,'')   not in ('MFOLD','ZK')                                      
			--and ISNULL(arrivaldmonth,0)>5 
			
			----��6�� 5�������� �ܼ�,�����ܼ�,����ܼ� 5W-8W(������5W) �Ͽ���ɱ���Ϊ35%                              
			update a set staffticheng=isnull(staffyeji,0)*0.35                                      
			from #allstaff_work_detail a ,#emp_yeji_total_resultx b,projectnameinfo with(nolock)                                      
			where a.person_inid=b.inid and isnull(a.postation,'') in ('007' ,'00701','00702')                                     
			and action_id in (7,10,13) and ISNULL(paycode,'') not in ('9','11','12')                                      
			and b.yeji>=50000 and b.yeji<70000   and prjno=code and prjtype='3'                                      
			and isnull(cardtype,'')   not in ('MFOLD','ZK')                                      
			--and ISNULL(arrivaldmonth,0)>5 
			
			----��6�� 5�������� �ܼ�,�����ܼ�,����ܼ� 8W���� �Ͽ���ɱ���Ϊ40%                              
			update a set staffticheng=isnull(staffyeji,0)*0.40                                      
			from #allstaff_work_detail a ,#emp_yeji_total_resultx b,projectnameinfo with(nolock)                                      
			where a.person_inid=b.inid and isnull(a.postation,'') in ('007' ,'00701','00702')                                     
			and action_id in (7,10,13) and ISNULL(paycode,'') not in ('9','11','12')                                      
			and b.yeji>=70000   and prjno=code and prjtype='3'                                      
			and isnull(cardtype,'')   not in ('MFOLD','ZK')                                      
			--and ISNULL(arrivaldmonth,0)>5 
		end 
    end   
    else                                  
	begin
	                  
		update a set staffticheng=isnull(staffyeji,0)*0.35                                      
		from #allstaff_work_detail a ,#emp_yeji_total_resultx b,projectnameinfo with(nolock)                                      
		where a.person_inid=b.inid and isnull(a.postation,'')='003'                                       
		and (action_id>=7 and action_id<=15) and ISNULL(paycode,'')<>'9'                                      
		and b.yeji>=30000 and  prjno=code and prjtype='3'                                      
		and isnull(cardtype,'')   not in ('MFOLD','ZK')                                      
	                                       
		update a set staffticheng=isnull(staffyeji,0)*0.35                                      
		from #allstaff_work_detail a ,#emp_yeji_total_resultx b,projectnameinfo with(nolock)                                      
		 where a.person_inid=b.inid and isnull(a.postation,'')='006'                                       
		and (action_id>=7 and action_id<=15) and ISNULL(paycode,'')<>'9'                                      
		and b.yeji>=50000 and  prjno=code and prjtype='3'                                      
		and isnull(cardtype,'')   not in ('MFOLD','ZK')                                      
	                                       
		update a set staffticheng=isnull(staffyeji,0)*0.35                                      
		from #allstaff_work_detail a ,#emp_yeji_total_resultx b,projectnameinfo with(nolock)             
		where a.person_inid=b.inid and isnull(a.postation,'')='007'                                       
		and (action_id>=7 and action_id<=15) and ISNULL(paycode,'')<>'9'                                      
		and b.yeji>=70000  and prjno=code and prjtype='3'                                      
		and isnull(cardtype,'')   not in ('MFOLD','ZK')                                      
	                     
		update a set staffticheng=isnull(staffyeji,0)*0.35                                      
		from #allstaff_work_detail a ,#emp_yeji_total_resultx b,projectnameinfo with(nolock)                                      
		where a.person_inid=b.inid and isnull(a.postation,'') in ('00701' ,'00702' )                                     
		and (action_id>=7 and action_id<=15) and ISNULL(paycode,'')<>'9'                                      
		and b.yeji>=90000  and prjno=code and prjtype='3'                                      
		and isnull(cardtype,'')   not in ('MFOLD','ZK')    
    end            
	---����ʦA��                    
	/*if(@compid in ('008','017','019','026','032'))                    
	begin                    
                     
	update a set staffticheng=ISNULL(staffticheng,0)+ISNULL(staffyeji,0)*0.05        
	 from #allstaff_work_detail a,#emp_yeji_total_resultx b                    
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
    from #allstaff_work_detail a,nointernalcardinfo,#emp_yeji_total_resultx b        
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
   from #allstaff_work_detail a,#emp_yeji_total_resultx b                    
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
    from #allstaff_work_detail a,nointernalcardinfo,#emp_yeji_total_resultx b                    
    where a.person_inid=b.inid                     
   and a.cardtype=cardno                    
   and ISNULL(a.postation,'')='004'                    
   and (action_id>=7 and action_id<=15)             
   and paycode='13'                    
   and yeji<70000                     
   and yeji>=50000                    
   and isnull(entrytype,0)=0                    
   and action_id not in (26,27,28,29,30,31)                    
 end  */                  
 drop table #emp_yeji_total_resultx                                      
                                       
  
                                                  
                          
 --������ɷ�ʽ                        
 --�а���ʽ:����ֳ�,��5%�ɱ�                        
 --��˾ֱӪ:����ҵ��1-5000 50% ��10%�ɱ�,5000����35%��10%�ɱ�                                     
                          
    if(ISNULL(@comptypebyfinger,'1')='3') --�а���ʽ                        
    begin                        
  update #allstaff_work_detail set staffyeji=ISNULL(staffyeji,0)*0.95,staffticheng=isnull(staffticheng,0)*0.95*0.5                        
  from #allstaff_work_detail,staffinfo where Manageno=person_inid and position = '005'                        
    end                   
    else  if(ISNULL(@comptypebyfinger,'1')='2') --��˾ֱӪ                         
    begin                        
                        
   update #allstaff_work_detail set staffyeji=ISNULL(staffyeji,0)*0.9,staffticheng=isnull(staffticheng,0)*0.5*0.9                        
   where  person_inid in (select person_inid from #allstaff_work_detail ,staffinfo where Manageno=person_inid and position = '005'                        
   group by person_inid having SUM(ISNULL(staffyeji,0))<=5000 )                         
                          
                              
   update #allstaff_work_detail set staffyeji=ISNULL(staffyeji,0)*0.9,staffticheng=isnull(staffticheng,0)*0.35*0.9                        
   where  person_inid in (select person_inid from #allstaff_work_detail ,staffinfo where Manageno=person_inid and position = '005'                        
   group by person_inid having SUM(ISNULL(staffyeji,0))>5000 )                         
    end         
                     
      
   --88 ֻҪ��88�Ķ�����ҵ��*0.02
   update #allstaff_work_detail set staffticheng=staffyeji*0.02 where action_id=88

        
 create table #allstaff_work_analysis      
 (      
  person_inid   varchar(20)   NULL, --Ա���ڲ����      
  staffno    varchar(30)   NULL, --Ա������      
  staffname   varchar(30)   NULL, --Ա������      
  staffposition  varchar(30)   NULL, --Ա��ְλ      
  oldcostcount  float    NULL, --�Ͽ���Ŀ��      
  newcostcount  float    NULL, --�¿���Ŀ��      
  trcostcount   float    NULL, --��Ⱦ��Ŀ��      
  cashbigcost   float    NULL, --�ֽ����      
  cashsmallcost  float    NULL, --�ֽ�С��      
  cashhulicost  float    NULL, --�ֽ���      
  cardbigcost   float    NULL, --��������      
  cardsmallcost  float    NULL, --����С��      
  cardhulicost  float    NULL, --��������      
  cardprocost   float    NULL, --�Ƴ�����      
  cardsgcost   float    NULL, --�չ�������      
  cardpointcost  float    NULL, --��������      
  projectdycost  float    NULL, --��Ŀ����ȯ      
  cashdycost   float    NULL, --�ֽ����ȯ      
  tmcardcost   float    NULL, --����������      
  salegoodsamt  float    NULL, --��Ʒ����      
  salecardsamt  float    NULL, --������      
  prochangeamt  float    NULL, --�Ƴ̶һ�      
  saletmkamt   float    NULL, --���뿨����      
  qhpayinner   float    NULL, --ȫ������֧��      
  qhpayouter   float    NULL, --ȫ���Է�֧��      
  jdpayinner   float    NULL, --�ߴ����֧��      
  smpayinner   float    NULL, --˽�ܵ���֧��      
  staffyeji   float    NULL, --Ա����ɺϼ�      
  staffcashyeji  float    NULL, --Ա���ֽ�ҵ���ϼ�      
 )       
 create clustered index idx_work_analysis_person_inid on #allstaff_work_analysis(person_inid)        
       
 if(@handtype=3)--Ա��ҵ��ͳ�Ʊ�      
 begin      

  insert #allstaff_work_analysis(person_inid,staffyeji)      
  select person_inid,SUM(isnull(staffyeji,0)) from #allstaff_work_detail where isnull(person_inid,'')<>'' and action_id<>'36' group by person_inid       
        
  update a set a.staffno=b.staffno,a.staffname=b.staffname,a.staffposition=b.position      
  from #allstaff_work_analysis a,staffinfo b      
  where a.person_inid=b.Manageno      
        
  --�ֽ����      
  update a set cashbigcost=ISNULL((      
   select sum(ISNULL(staffyeji,0)) from #allstaff_work_detail b,projectnameinfo c      
    where a.person_inid=b.person_inid and b.action_id >=7 and b.action_id<=15 and b.code=c.prjno and  c.prjtype<>6 and c.prjpricetype=1 and b.paycode in ('1','2','6','0','14','15') ),0)      
  from #allstaff_work_analysis a      
        
  --�ֽ�С��      
  update a set cashsmallcost=ISNULL((      
   select sum(ISNULL(staffyeji,0)) from #allstaff_work_detail b,projectnameinfo c      
    where a.person_inid=b.person_inid and b.action_id >=7 and b.action_id<=15 and b.code=c.prjno and  c.prjtype<>6 and c.prjpricetype=2 and b.paycode in ('1','2','6','0','14','15') ),0)      
  from #allstaff_work_analysis a      
        
  --�ֽ���      
  update a set cashhulicost=ISNULL((      
   select sum(ISNULL(staffyeji,0)) from #allstaff_work_detail b,projectnameinfo c      
    where a.person_inid=b.person_inid and b.action_id >=7 and b.action_id<=15 and b.code=c.prjno and  c.prjtype=6  and b.paycode in ('1','2','6','0','14','15') ),0)      
  from #allstaff_work_analysis a      
        
  --��������      
  update a set cardbigcost=ISNULL((      
   select sum(ISNULL(staffyeji,0)) from #allstaff_work_detail b,projectnameinfo c      
    where a.person_inid=b.person_inid and b.action_id >=7 and b.action_id<=15 and b.code=c.prjno and  c.prjtype<>6 and c.prjpricetype=1 and b.paycode in ('4','17') ),0)      
  from #allstaff_work_analysis a      
        
  --����С��      
  update a set cardsmallcost=ISNULL((      
   select sum(ISNULL(staffyeji,0)) from #allstaff_work_detail b,projectnameinfo c      
    where a.person_inid=b.person_inid and b.action_id >=7 and b.action_id<=15 and b.code=c.prjno and  c.prjtype<>6 and c.prjpricetype=2 and b.paycode  in ('4','17')  ),0)      
  from #allstaff_work_analysis a      
        
  --��������      
  update a set cardhulicost=ISNULL((      
   select sum(ISNULL(staffyeji,0)) from #allstaff_work_detail b,projectnameinfo c      
    where a.person_inid=b.person_inid and b.action_id >=7 and b.action_id<=15 and b.code=c.prjno and  c.prjtype=6  and b.paycode in ('4','17')  ),0)      
  from #allstaff_work_analysis a      
        
  --�Ƴ�����      
  update a set cardprocost=ISNULL((      
   select sum(ISNULL(staffyeji,0)) from #allstaff_work_detail b      
    where a.person_inid=b.person_inid and b.action_id >=7 and b.action_id<=15 and b.paycode  ='9' ),0)      
  from #allstaff_work_analysis a      
        
  --�չ�������      
  update a set cardsgcost=ISNULL((      
   select sum(ISNULL(staffyeji,0)) from #allstaff_work_detail b      
    where a.person_inid=b.person_inid and b.action_id >=7 and b.action_id<=15 and b.paycode  ='A' ),0)      
  from #allstaff_work_analysis a      
        
  --��������      
  update a set cardpointcost=ISNULL((      
   select sum(ISNULL(staffyeji,0)) from #allstaff_work_detail b      
    where a.person_inid=b.person_inid and b.action_id >=7 and b.action_id<=15 and b.paycode  ='7' ),0)      
  from #allstaff_work_analysis a      
        
  --��Ŀ����ȯ����      
  update a set projectdycost=ISNULL((      
   select sum(ISNULL(staffyeji,0)) from #allstaff_work_detail b      
    where a.person_inid=b.person_inid and b.action_id >=7 and b.action_id<=15 and b.paycode  ='11' ),0)      
  from #allstaff_work_analysis a      
        
  --�ֽ����ȯ����      
  update a set cashdycost=ISNULL((      
   select sum(ISNULL(staffyeji,0)) from #allstaff_work_detail b      
    where a.person_inid=b.person_inid and b.action_id >=7 and b.action_id<=15 and b.paycode  ='12' ),0)      
  from #allstaff_work_analysis a      
        
  --���뿨����      
  update a set tmcardcost=ISNULL((      
   select sum(ISNULL(staffyeji,0)) from #allstaff_work_detail b      
    where a.person_inid=b.person_inid and b.action_id >=7 and b.action_id<=15 and b.paycode  ='13' ),0)      
  from #allstaff_work_analysis a      
        
  --��Ʒ����      
  update a set salegoodsamt=ISNULL((      
   select sum(ISNULL(staffyeji,0)) from #allstaff_work_detail b      
    where a.person_inid=b.person_inid and b.action_id >=16 and b.action_id<=24  ),0)      
  from #allstaff_work_analysis a      
        
  --��Ա������      
  update a set salecardsamt=ISNULL((      
   select sum(ISNULL(staffyeji,0)) from #allstaff_work_detail b      
    where a.person_inid=b.person_inid and b.action_id >=1 and b.action_id<=3  ),0)      
  from #allstaff_work_analysis a      
        
  --�Ƴ̶һ�      
  update a set prochangeamt=ISNULL((      
   select sum(ISNULL(staffyeji,0)) from #allstaff_work_detail b      
    where a.person_inid=b.person_inid and b.action_id =4  ),0)      
  from #allstaff_work_analysis a      
        
  --���뿨����      
  update a set saletmkamt=ISNULL((      
   select sum(ISNULL(staffyeji,0)) from #allstaff_work_detail b      
    where a.person_inid=b.person_inid and b.action_id =5  ),0)      
  from #allstaff_work_analysis a      
        
      
  --ȫ������֧��      
  update a set qhpayinner=ISNULL((      
   select sum(ISNULL(staffyeji,0)) from #allstaff_work_detail b      
    where a.person_inid=b.person_inid and b.action_id =28  ),0)      
  from #allstaff_work_analysis a      
        
  --ȫ���Է�֧��      
  update a set qhpayouter=ISNULL((      
   select sum(ISNULL(staffyeji,0)) from #allstaff_work_detail b      
    where a.person_inid=b.person_inid and b.action_id =27 ),0)      
  from #allstaff_work_analysis a      
        
  --�ߴ����֧��      
  update a set jdpayinner=ISNULL((      
   select sum(ISNULL(staffyeji,0)) from #allstaff_work_detail b      
    where a.person_inid=b.person_inid and b.action_id =28  ),0)      
  from #allstaff_work_analysis a      
        
  --˽�ܵ���֧��      
  update a set smpayinner=ISNULL((      
   select sum(ISNULL(staffyeji,0)) from #allstaff_work_detail b      
    where a.person_inid=b.person_inid and b.action_id =29  ),0)      
  from #allstaff_work_analysis a      
        
  --�ֽ�ҵ��    

  update a set staffcashyeji=ISNULL((      
   select sum(ISNULL(staffyeji,0)) from #allstaff_work_detail b      
    where a.person_inid=b.person_inid  and b.paycode in ('1','2','6','0','14','15') and ISNULL(b.action_id,-1)<>4 ),0)      
  from #allstaff_work_analysis a      
        
  --�¿���Ŀ��      
  update a set  newcostcount=ISNULL((      
   select count(distinct billid) from #allstaff_work_detail b      
    where a.person_inid=b.person_inid and b.action_id in (8,11,14) and isnull(ccount,0)>0  ),0)      
  from #allstaff_work_analysis a      
        
  --�Ͽ���Ŀ��      
  update a set oldcostcount=ISNULL((      
   select count(distinct billid) from #allstaff_work_detail b      
    where a.person_inid=b.person_inid and b.action_id in (7,10,13) and isnull(ccount,0)>0  ),0)      
  from #allstaff_work_analysis a      
        
  --��Ⱦ��Ŀ��      
  update a set trcostcount=ISNULL((      
   select count(distinct billid) from #allstaff_work_detail b,projectnameinfo c      
    where a.person_inid=b.person_inid  and isnull(ccount,0)>0 and b.code=c.prjno and c.prjreporttype in ('02','03') ),0)      
  from #allstaff_work_analysis a      
       
        
        
       
        
  select  person_inid,staffno,staffname,staffposition,oldcostcount,newcostcount,trcostcount,cashbigcost,cashsmallcost,cashhulicost,      
    cardbigcost,cardsmallcost,cardhulicost,cardprocost,cardsgcost,cardpointcost,projectdycost,cashdycost,tmcardcost,      
    salegoodsamt,salecardsamt,prochangeamt,saletmkamt,qhpayinner,qhpayouter,jdpayinner,smpayinner,staffyeji,staffcashyeji      
  from #allstaff_work_analysis order by staffno      
        
  drop table #empinfobydate      
  drop table #allstaff_work_detail       
  drop table #allstaff_work_analysis       
        
  return       
 end      
       
 insert #allstaff_work_analysis(person_inid,staffyeji)      
 select person_inid,SUM(isnull(staffticheng,0)) from #allstaff_work_detail where isnull(person_inid,'')<>'' group by person_inid       
       
 update a set a.staffno=b.staffno,a.staffname=b.staffname,a.staffposition=b.position      
 from #allstaff_work_analysis a,staffinfo b      
 where a.person_inid=b.Manageno      
       
 --�ֽ����      
 update a set cashbigcost=ISNULL((      
  select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail b,projectnameinfo c      
   where a.person_inid=b.person_inid and b.action_id >=7 and b.action_id<=15 and b.code=c.prjno and  c.prjtype<>6 and c.prjpricetype=1 and b.paycode in ('1','2','6','0','14','15') ),0)      
 from #allstaff_work_analysis a      
       
 --�ֽ�С��      
 update a set cashsmallcost=ISNULL((      
  select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail b,projectnameinfo c      
   where a.person_inid=b.person_inid and b.action_id >=7 and b.action_id<=15 and b.code=c.prjno and  c.prjtype<>6 and c.prjpricetype=2 and b.paycode in ('1','2','6','0','14','15') ),0)      
 from #allstaff_work_analysis a      
       
 --�ֽ���      
 update a set cashhulicost=ISNULL((      
  select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail b,projectnameinfo c      
   where a.person_inid=b.person_inid and b.action_id >=7 and b.action_id<=15 and b.code=c.prjno and  c.prjtype=6  and b.paycode in ('1','2','6','0','14','15') ),0)      
 from #allstaff_work_analysis a      
       
 --��������      
 update a set cardbigcost=ISNULL((      
  select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail b,projectnameinfo c      
   where a.person_inid=b.person_inid and b.action_id >=7 and b.action_id<=15 and b.code=c.prjno and  c.prjtype<>6 and c.prjpricetype=1 and b.paycode in ('4','17')  ),0)      
 from #allstaff_work_analysis a      
       
 --����С��      
 update a set cardsmallcost=ISNULL((      
  select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail b,projectnameinfo c      
   where a.person_inid=b.person_inid and b.action_id >=7 and b.action_id<=15 and b.code=c.prjno and  c.prjtype<>6 and c.prjpricetype=2 and b.paycode  in ('4','17') ),0)      
 from #allstaff_work_analysis a      
       
 --��������      
 update a set cardhulicost=ISNULL((      
  select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail b,projectnameinfo c      
   where a.person_inid=b.person_inid and b.action_id >=7 and b.action_id<=15 and b.code=c.prjno and  c.prjtype=6  and b.paycode  in ('4','17')  ),0)      
 from #allstaff_work_analysis a      
       
 --�Ƴ�����      
 update a set cardprocost=ISNULL((      
  select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail b      
   where a.person_inid=b.person_inid and b.action_id >=7 and b.action_id<=15 and b.paycode  ='9' ),0)      
 from #allstaff_work_analysis a      
       
 --�չ�������      
 update a set cardsgcost=ISNULL((      
  select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail b      
   where a.person_inid=b.person_inid and b.action_id >=7 and b.action_id<=15 and b.paycode  ='A' ),0)      
 from #allstaff_work_analysis a      
       
 --��������      
 update a set cardpointcost=ISNULL((      
  select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail b      
   where a.person_inid=b.person_inid and b.action_id >=7 and b.action_id<=15 and b.paycode  ='7' ),0)      
 from #allstaff_work_analysis a      
       
 --��Ŀ����ȯ����      
 update a set projectdycost=ISNULL((      
  select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail b      
   where a.person_inid=b.person_inid and b.action_id >=7 and b.action_id<=15 and b.paycode  ='11' ),0)      
 from #allstaff_work_analysis a      
       
 --�ֽ����ȯ����      
 update a set cashdycost=ISNULL((      
  select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail b      
   where a.person_inid=b.person_inid and b.action_id >=7 and b.action_id<=15 and b.paycode  ='12' ),0)      
 from #allstaff_work_analysis a      
       
 --���뿨����      
 update a set tmcardcost=ISNULL((      
  select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail b      
   where a.person_inid=b.person_inid and b.action_id >=7 and b.action_id<=15 and b.paycode  ='13' ),0)      
 from #allstaff_work_analysis a      
       
 --��Ʒ����      
 update a set salegoodsamt=ISNULL((      
  select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail b      
   where a.person_inid=b.person_inid and b.action_id >=16 and b.action_id<=24  ),0)      
 from #allstaff_work_analysis a      
       
 --��Ա������      
 update a set salecardsamt=ISNULL((      
  select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail b      
   where a.person_inid=b.person_inid and b.action_id >=1 and b.action_id<=3  ),0)      
 from #allstaff_work_analysis a      
       
 --�Ƴ̶һ�      
 update a set prochangeamt=ISNULL((      
  select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail b      
   where a.person_inid=b.person_inid and b.action_id =4  ),0)      
 from #allstaff_work_analysis a      
       
 --���뿨����      
 update a set saletmkamt=ISNULL((      
  select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail b      
   where a.person_inid=b.person_inid and b.action_id =5  ),0)      
 from #allstaff_work_analysis a      
       
      
 --ȫ������֧��      
 update a set qhpayinner=ISNULL((      
  select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail b      
   where a.person_inid=b.person_inid and b.action_id =28  ),0)      
 from #allstaff_work_analysis a      
       
 --ȫ���Է�֧��      
 update a set qhpayouter=ISNULL((      
  select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail b      
   where a.person_inid=b.person_inid and b.action_id =27 ),0)      
 from #allstaff_work_analysis a      
       
 --�ߴ����֧��      
 update a set jdpayinner=ISNULL((      
  select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail b      
   where a.person_inid=b.person_inid and b.action_id =28  ),0)      
 from #allstaff_work_analysis a      
       
 --˽�ܵ���֧��      
 update a set smpayinner=ISNULL((      
  select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail b      
   where a.person_inid=b.person_inid and b.action_id =29  ),0)      
 from #allstaff_work_analysis a      
       
 --�¿���Ŀ��      
 update a set newcostcount =ISNULL((      
  select count(distinct billid) from #allstaff_work_detail b      
   where a.person_inid=b.person_inid and b.action_id in (8,11,14) and isnull(ccount,0)>0  ),0)      
 from #allstaff_work_analysis a      
       
 --�Ͽ���Ŀ��      
 update a set oldcostcount=ISNULL((      
  select count(distinct billid) from #allstaff_work_detail b      
   where a.person_inid=b.person_inid and b.action_id in (7,10,13) and isnull(ccount,0)>0  ),0)      
 from #allstaff_work_analysis a      
       
 --��Ⱦ��Ŀ��      
 update a set trcostcount=ISNULL((      
  select count(distinct billid) from #allstaff_work_detail b,projectnameinfo c      
   where a.person_inid=b.person_inid  and isnull(ccount,0)>0 and b.code=c.prjno and c.prjreporttype in ('02','03') ),0)      
 from #allstaff_work_analysis a      
       
 --select seqno,person_inid,action_id,srvdate,code,name,payway,billamt,ccount,cost,staffticheng,staffyeji,prj_type,cls_flag,billid,paycode,compid,cardid,cardtype       
 --from #allstaff_work_detail order by action_id,srvdate      
 if(@handtype=1)      
 begin      
  select  person_inid,staffno,staffname,staffposition,oldcostcount,newcostcount,trcostcount,cashbigcost,cashsmallcost,cashhulicost,      
    cardbigcost,cardsmallcost,cardhulicost,cardprocost,cardsgcost,cardpointcost,projectdycost,cashdycost,tmcardcost,      
    salegoodsamt,salecardsamt,prochangeamt,saletmkamt,qhpayinner,qhpayouter,jdpayinner,smpayinner,staffyeji       
  from #allstaff_work_analysis order by staffno      
 end      
 else      
 begin      
  --   delete allstaff_work_yeji_daybyday  where compid=@compid and yeji_date =@fromdate      
  --insert allstaff_work_yeji_daybyday(yeji_date,compid,person_inid,staffno,staffname,staffposition,      
  --oldcostcount,newcostcount,trcostcount,cashbigcost,cashsmallcost,cashhulicost,cardbigcost,cardsmallcost,cardhulicost,cardprocost,      
  --cardsgcost,cardpointcost,projectdycost,cashdycost,tmcardcost,salegoodsamt,salecardsamt,prochangeamt,saletmkamt,      
  --qhpayinner,qhpayouter,jdpayinner,smpayinner,staffyeji)      
  --select @fromdate,@compid,person_inid,staffno,staffname,staffposition,      
  --oldcostcount,newcostcount,trcostcount,cashbigcost,cashsmallcost,cashhulicost,cardbigcost,cardsmallcost,cardhulicost,cardprocost,      
  --cardsgcost,cardpointcost,projectdycost,cashdycost,tmcardcost,salegoodsamt,salecardsamt,prochangeamt,saletmkamt,      
  --qhpayinner,qhpayouter,jdpayinner,smpayinner,staffyeji from #allstaff_work_analysis      
        
      
  delete staff_work_salary where compid=@compid and salary_date =@fromdate      
  insert staff_work_salary(compid,person_inid,salary_date,oldcostcount,newcostcount,trcostcount,cashbigcost,cashsmallcost,cashhulicost,      
    cardbigcost,cardsmallcost,cardhulicost,cardprocost,cardsgcost,cardpointcost,projectdycost,cashdycost,tmcardcost,      
    salegoodsamt,salecardsamt,prochangeamt,saletmkamt,qhpayinner,qhpayouter,jdpayinner,smpayinner,staffyeji)      
  select @compid,person_inid,@fromdate,sum(isnull(oldcostcount,0)),sum(isnull(newcostcount,0)),sum(isnull(trcostcount,0)),      
    sum(isnull(cashbigcost,0)),sum(isnull(cashsmallcost,0)),sum(isnull(cashhulicost,0)),      
    sum(isnull(cardbigcost,0)),sum(isnull(cardsmallcost,0)),sum(isnull(cardhulicost,0)),      
    sum(isnull(cardprocost,0)),sum(isnull(cardsgcost,0)),sum(isnull(cardpointcost,0)),      
    sum(isnull(projectdycost,0)),sum(isnull(cashdycost,0)),sum(isnull(tmcardcost,0)),      
    sum(isnull(salegoodsamt,0)),sum(isnull(salecardsamt,0)),sum(isnull(prochangeamt,0)),      
    sum(isnull(saletmkamt,0)),sum(isnull(qhpayinner,0)),sum(isnull(qhpayouter,0)),      
    sum(isnull(jdpayinner,0)),sum(isnull(smpayinner,0)),sum(isnull(staffyeji,0))      
  from #allstaff_work_analysis      
  group by person_inid      
        
  update a      
  set staffcashyeji=isnull((select  sum(isnull(staffyeji,0)) from #allstaff_work_detail b where ISNULL(action_id,-1)<>4 and paycode in ('1','2','6','0','14','15') and a.person_inid=b.person_inid  ),0)                                  
  from staff_work_salary a where salary_date=@fromdate      
        
 end      
       
    drop table #empinfobydate      
    drop table #allstaff_work_detail       
    drop table #allstaff_work_analysis       
end       
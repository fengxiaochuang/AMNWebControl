if exists(select 1 from sysobjects where type='P' and name='upg_compute_comp_other_satff_salary_daybyday')
	drop procedure upg_compute_comp_other_satff_salary_daybyday
go
create procedure upg_compute_comp_other_satff_salary_daybyday
(
	@compid			varchar(10)	,
	@staffinid		varchar(20)	,
	@datefrom		varchar(8)	,
	@dateto			varchar(8)
)
as
begin
		create table #allstaff_work_detail_daybyday
		(
			seqno			int	identity		not null,       
			person_inid		varchar(20)			NULL, --Ա���ڲ����
			action_id		int				NULL, --��������
			srvdate			varchar(10)			NULL, --����
			code			varchar(20)			NULL, --��Ŀ����,���ǿ���,��Ʒ��
			name			varchar(40)			NULL, --����
			payway			varchar(20)			NULL, --֧����ʽ
			billamt			float				NULL, --Ӫҵ���
			ccount			float				NULL, --����
			cost			float				NULL, --�ɱ�
			staffticheng	float				NULL, --���
			staffyeji		float				NULL, --��ҵ��
			prj_type		varchar(20)			NULL, --��Ŀ���
			cls_flag        int					NULL, -- 1:��Ŀ 2:��Ʒ 3:��
			billid			varchar(20)			NULL, --����
			paycode			varchar(20)			NULL, --֧������
			compid			varchar(10)			NULL, --��˾��
			cardid			varchar(20)			NULL, --��Ա����
			cardtype		varchar(20)			NULL, --��Ա������
			postation		varchar(10)			NULL, --Ա������
		)     
		
		insert #allstaff_work_detail_daybyday (compid,person_inid,action_id,srvdate,code,name,payway,billamt,ccount,cost,staffticheng,staffyeji,prj_type,cls_flag,billid,paycode,cardid,cardtype,postation)
		select compid,person_inid,action_id,srvdate,code,name,payway,billamt,ccount,cost,staffticheng,staffyeji,prj_type,cls_flag,billid,paycode,cardid,cardtype,postation
		from allstaff_work_detail_daybyday where compid=@compid and person_inid=@staffinid
		--����ʦ��������Ŀ ����ָ��ҵ��������ͨ����ɱ���                                
		--����ʦҵ����2.5W,��ϯ��5W,�ܼ� 7W ������Ŀ��ɱ���0.35                                
		create  table #emp_yeji_total_resultx                                 
		(                                
			inid		varchar(20) null,  --Ա���ڲ����                                   
			yeji		float  null, -- ҵ��                 
			lv			float  null, --��ɱ���                                     
		)                                   
            
       	insert #emp_yeji_total_resultx(inid,yeji)                                       
		select  person_inid,sum(isnull(staffyeji,0)) from #allstaff_work_detail_daybyday where ISNULL(action_id,-1)<>4 and paycode in ('1','2','6','0','14','15') group by person_inid                              
                
		update a set staffticheng=isnull(staffyeji,0)*0.35                                
		from #allstaff_work_detail_daybyday a ,#emp_yeji_total_resultx b,projectnameinfo with(nolock)                                
		where a.person_inid=b.inid and isnull(a.postation,'')='003'                                 
		and (action_id>=7 and action_id<=15) and ISNULL(paycode,'')<>'9'                                
		and b.yeji>=25000 and  prjno=code and prjtype='3'                                
		and isnull(cardtype,'')   not in ('MFOLD','ZK')                                
                                 
		update a set staffticheng=isnull(staffyeji,0)*0.35                                
		from #allstaff_work_detail_daybyday a ,#emp_yeji_total_resultx b,projectnameinfo with(nolock)                                
		where a.person_inid=b.inid and isnull(a.postation,'')='006'                                 
		and (action_id>=7 and action_id<=15) and ISNULL(paycode,'')<>'9'                                
		and b.yeji>=50000 and  prjno=code and prjtype='3'                                
		and isnull(cardtype,'')   not in ('MFOLD','ZK')                                
                                 
		update a set staffticheng=isnull(staffyeji,0)*0.35                                
		from #allstaff_work_detail_daybyday a ,#emp_yeji_total_resultx b,projectnameinfo with(nolock)                                
		where a.person_inid=b.inid and isnull(a.postation,'')='007'                                 
		and (action_id>=7 and action_id<=15) and ISNULL(paycode,'')<>'9'                                
		 and b.yeji>=70000  and prjno=code and prjtype='3'                                
		and isnull(cardtype,'')   not in ('MFOLD','ZK')                                
               
               
		---����ʦA��              
		if(@compid in ('008','017','019','026','032'))              
		begin              
               
		 update a set staffticheng=ISNULL(staffticheng,0)+ISNULL(staffyeji,0)*0.05  
		 from #allstaff_work_detail_daybyday a,#emp_yeji_total_resultx b              
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
		  from #allstaff_work_detail_daybyday a,nointernalcardinfo,#emp_yeji_total_resultx b  
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
		 from #allstaff_work_detail_daybyday a,#emp_yeji_total_resultx b              
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
		  from #allstaff_work_detail_daybyday a,nointernalcardinfo,#emp_yeji_total_resultx b              
		  where a.person_inid=b.inid               
			and a.cardtype=cardno              
			and ISNULL(a.postation,'')='004'              
			and (action_id>=7 and action_id<=15)       
			and paycode='13'              
			and yeji<70000               
			and yeji>=50000              
			and isnull(entrytype,0)=0              
			and action_id not in (26,27,28,29,30,31)              
	end              
	drop table #emp_yeji_total_resultx                                
                                 
                                
                                            

               
	
  
	create table #allstaff_work_analysis_daybyday
	(
		ddate				varchar(10)			NULL,	--����
		person_inid			varchar(20)			NULL,	--Ա���ڲ����
		staffno				varchar(30)			NULL,	--Ա������
		staffname			varchar(30)			NULL,	--Ա������
		staffposition		varchar(30)			NULL,	--Ա��ְλ
		oldcostcount		float				NULL,	--�Ͽ���Ŀ��
		newcostcount		float				NULL,	--�¿���Ŀ��
		trcostcount			float				NULL,	--��Ⱦ��Ŀ��
		cashbigcost			float				NULL,	--�ֽ����
		cashsmallcost		float				NULL,	--�ֽ�С��
		cashhulicost		float				NULL,	--�ֽ���
		cardbigcost			float				NULL,	--��������
		cardsmallcost		float				NULL,	--����С��
		cardhulicost		float				NULL,	--��������
		cardprocost			float				NULL,	--�Ƴ�����
		cardsgcost			float				NULL,	--�չ�������
		cardpointcost		float				NULL,	--��������
		projectdycost		float				NULL,	--��Ŀ����ȯ
		cashdycost			float				NULL,	--�ֽ����ȯ
		tmcardcost			float				NULL,	--����������
		salegoodsamt		float				NULL,	--��Ʒ����
		salecardsamt		float				NULL,	--������
		prochangeamt		float				NULL,	--�Ƴ̶һ�
		saletmkamt			float				NULL,	--���뿨����
		qhpayinner			float				NULL,	--ȫ������֧��
		qhpayouter			float				NULL,	--ȫ���Է�֧��
		jdpayinner			float				NULL,	--�ߴ����֧��
		smpayinner			float				NULL,	--˽�ܵ���֧��
		staffyeji			float				NULL,	--Ա����ɺϼ�
	) 
	create clustered index idx_work_analysis_person_inid on #allstaff_work_analysis_daybyday(person_inid)  
	insert #allstaff_work_analysis_daybyday(person_inid,ddate,staffyeji)
	select person_inid,srvdate,SUM(isnull(staffticheng,0)) from #allstaff_work_detail_daybyday where isnull(person_inid,'')<>'' group by person_inid,srvdate
	
	update a set a.staffno=b.staffno,a.staffname=b.staffname,a.staffposition=b.position
	from #allstaff_work_analysis_daybyday a,staffinfo b
	where a.person_inid=b.Manageno
	
	--�ֽ����
	update a set cashbigcost=ISNULL((
		select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail_daybyday b,projectnameinfo c
		 where a.person_inid=b.person_inid and a.ddate=b.srvdate and b.action_id >=7 and b.action_id<=15 and b.code=c.prjno and  c.prjtype<>6 and c.prjpricetype=1 and b.paycode in ('1','2','6','0','14','15') ),0)
	from #allstaff_work_analysis_daybyday a
	
	--�ֽ�С��
	update a set cashsmallcost=ISNULL((
		select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail_daybyday b,projectnameinfo c
		 where a.person_inid=b.person_inid and a.ddate=b.srvdate and b.action_id >=7 and b.action_id<=15 and b.code=c.prjno and  c.prjtype<>6 and c.prjpricetype=2 and b.paycode in ('1','2','6','0','14','15') ),0)
	from #allstaff_work_analysis_daybyday a
	
	--�ֽ���
	update a set cashhulicost=ISNULL((
		select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail_daybyday b,projectnameinfo c
		 where a.person_inid=b.person_inid and a.ddate=b.srvdate and b.action_id >=7 and b.action_id<=15 and b.code=c.prjno and  c.prjtype=6  and b.paycode in ('1','2','6','0','14','15') ),0)
	from #allstaff_work_analysis_daybyday a
	
	--��������
	update a set cardbigcost=ISNULL((
		select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail_daybyday b,projectnameinfo c
		 where a.person_inid=b.person_inid and a.ddate=b.srvdate and b.action_id >=7 and b.action_id<=15 and b.code=c.prjno and  c.prjtype<>6 and c.prjpricetype=1 and b.paycode ='4' ),0)
	from #allstaff_work_analysis_daybyday a
	
	--����С��
	update a set cardsmallcost=ISNULL((
		select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail_daybyday b,projectnameinfo c
		 where a.person_inid=b.person_inid and a.ddate=b.srvdate and b.action_id >=7 and b.action_id<=15 and b.code=c.prjno and  c.prjtype<>6 and c.prjpricetype=2 and b.paycode  ='4' ),0)
	from #allstaff_work_analysis_daybyday a
	
	--��������
	update a set cardhulicost=ISNULL((
		select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail_daybyday b,projectnameinfo c
		 where a.person_inid=b.person_inid and a.ddate=b.srvdate and b.action_id >=7 and b.action_id<=15 and b.code=c.prjno and  c.prjtype=6  and b.paycode  ='4' ),0)
	from #allstaff_work_analysis_daybyday a
	
	--�Ƴ�����
	update a set cardprocost=ISNULL((
		select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail_daybyday b
		 where a.person_inid=b.person_inid and a.ddate=b.srvdate and b.action_id >=7 and b.action_id<=15 and b.paycode  ='9' ),0)
	from #allstaff_work_analysis_daybyday a
	
	--�չ�������
	update a set cardsgcost=ISNULL((
		select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail_daybyday b
		 where a.person_inid=b.person_inid and a.ddate=b.srvdate and b.action_id >=7 and b.action_id<=15 and b.paycode  ='A' ),0)
	from #allstaff_work_analysis_daybyday a
	
	--��������
	update a set cardpointcost=ISNULL((
		select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail_daybyday b
		 where a.person_inid=b.person_inid and a.ddate=b.srvdate and b.action_id >=7 and b.action_id<=15 and b.paycode  ='7' ),0)
	from #allstaff_work_analysis_daybyday a
	
	--��Ŀ����ȯ����
	update a set projectdycost=ISNULL((
		select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail_daybyday b
		 where a.person_inid=b.person_inid and a.ddate=b.srvdate and b.action_id >=7 and b.action_id<=15 and b.paycode  ='11' ),0)
	from #allstaff_work_analysis_daybyday a
	
	--�ֽ����ȯ����
	update a set cashdycost=ISNULL((
		select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail_daybyday b
		 where a.person_inid=b.person_inid and a.ddate=b.srvdate and b.action_id >=7 and b.action_id<=15 and b.paycode  ='12' ),0)
	from #allstaff_work_analysis_daybyday a
	
	--���뿨����
	update a set tmcardcost=ISNULL((
		select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail_daybyday b
		 where a.person_inid=b.person_inid and a.ddate=b.srvdate and b.action_id >=7 and b.action_id<=15 and b.paycode  ='13' ),0)
	from #allstaff_work_analysis_daybyday a
	
	--��Ʒ����
	update a set salegoodsamt=ISNULL((
		select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail_daybyday b
		 where a.person_inid=b.person_inid and a.ddate=b.srvdate and b.action_id >=16 and b.action_id<=24  ),0)
	from #allstaff_work_analysis_daybyday a
	
	--��Ա������
	update a set salecardsamt=ISNULL((
		select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail_daybyday b
		 where a.person_inid=b.person_inid and a.ddate=b.srvdate and b.action_id >=1 and b.action_id<=3  ),0)
	from #allstaff_work_analysis_daybyday a
	
	--�Ƴ̶һ�
	update a set prochangeamt=ISNULL((
		select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail_daybyday b
		 where a.person_inid=b.person_inid and a.ddate=b.srvdate and b.action_id =4  ),0)
	from #allstaff_work_analysis_daybyday a
	
	--���뿨����
	update a set saletmkamt=ISNULL((
		select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail_daybyday b
		 where a.person_inid=b.person_inid and a.ddate=b.srvdate and b.action_id =5  ),0)
	from #allstaff_work_analysis_daybyday a
	

	--ȫ������֧��
	update a set qhpayinner=ISNULL((
		select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail_daybyday b
		 where a.person_inid=b.person_inid and a.ddate=b.srvdate and b.action_id =28  ),0)
	from #allstaff_work_analysis_daybyday a
	
	--ȫ���Է�֧��
	update a set qhpayouter=ISNULL((
		select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail_daybyday b
		 where a.person_inid=b.person_inid and a.ddate=b.srvdate and b.action_id =27 ),0)
	from #allstaff_work_analysis_daybyday a
	
	--�ߴ����֧��
	update a set jdpayinner=ISNULL((
		select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail_daybyday b
		 where a.person_inid=b.person_inid and a.ddate=b.srvdate and b.action_id =28  ),0)
	from #allstaff_work_analysis_daybyday a
	
	--˽�ܵ���֧��
	update a set smpayinner=ISNULL((
		select sum(ISNULL(staffticheng,0)) from #allstaff_work_detail_daybyday b
		 where a.person_inid=b.person_inid and a.ddate=b.srvdate and b.action_id =29  ),0)
	from #allstaff_work_analysis_daybyday a
	
	--�¿���Ŀ��
	update a set oldcostcount=ISNULL((
		select count(distinct billid) from #allstaff_work_detail_daybyday b
		 where a.person_inid=b.person_inid and a.ddate=b.srvdate and b.action_id in (8,11,14) and isnull(ccount,0)>0  ),0)
	from #allstaff_work_analysis_daybyday a
	
	--�Ͽ���Ŀ��
	update a set newcostcount=ISNULL((
		select count(distinct billid) from #allstaff_work_detail_daybyday b
		 where a.person_inid=b.person_inid and a.ddate=b.srvdate and b.action_id in (7,10,13) and isnull(ccount,0)>0  ),0)
	from #allstaff_work_analysis_daybyday a
	
	--��Ⱦ��Ŀ��
	update a set trcostcount=ISNULL((
		select count(distinct billid) from #allstaff_work_detail_daybyday b,projectnameinfo c
		 where a.person_inid=b.person_inid and a.ddate=b.srvdate and isnull(ccount,0)>0 and b.code=c.prjno and c.prjreporttype in ('02','03') ),0)
	from #allstaff_work_analysis_daybyday a
	

	 

		delete staff_work_salary where compid=@compid and salary_date between @datefrom and @dateto and person_inid=@staffinid
		insert staff_work_salary(compid,person_inid,salary_date,oldcostcount,newcostcount,trcostcount,cashbigcost,cashsmallcost,cashhulicost,
				cardbigcost,cardsmallcost,cardhulicost,cardprocost,cardsgcost,cardpointcost,projectdycost,cashdycost,tmcardcost,
				salegoodsamt,salecardsamt,prochangeamt,saletmkamt,qhpayinner,qhpayouter,jdpayinner,smpayinner,staffyeji)
		select @compid,person_inid,ddate,sum(isnull(oldcostcount,0)),sum(isnull(newcostcount,0)),sum(isnull(trcostcount,0)),
				sum(isnull(cashbigcost,0)),sum(isnull(cashsmallcost,0)),sum(isnull(cashhulicost,0)),
				sum(isnull(cardbigcost,0)),sum(isnull(cardsmallcost,0)),sum(isnull(cardhulicost,0)),
				sum(isnull(cardprocost,0)),sum(isnull(cardsgcost,0)),sum(isnull(cardpointcost,0)),
				sum(isnull(projectdycost,0)),sum(isnull(cashdycost,0)),sum(isnull(tmcardcost,0)),
				sum(isnull(salegoodsamt,0)),sum(isnull(salecardsamt,0)),sum(isnull(prochangeamt,0)),
				sum(isnull(saletmkamt,0)),sum(isnull(qhpayinner,0)),sum(isnull(qhpayouter,0)),
				sum(isnull(jdpayinner,0)),sum(isnull(smpayinner,0)),sum(isnull(staffyeji,0))
		from #allstaff_work_analysis_daybyday
		group by person_inid,ddate
		drop table #allstaff_work_detail_daybyday
		drop table #allstaff_work_analysis_daybyday
	end
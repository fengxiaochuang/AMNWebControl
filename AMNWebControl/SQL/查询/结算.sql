 --exec upg_compute_comp_classed_trade_daybyday '001','20130101', '20130131'  --�����ռ����ս�
 --go
 --exec upg_compute_comp_classed_trade_daybyday '001','20130201', '20130228'  --�����ռ����ս�
 -- go
 --exec upg_compute_comp_classed_trade_daybyday '001','20130301', '20130331'  --�����ռ����ս�
 -- go
 --exec upg_compute_comp_classed_trade_daybyday '001','20130401', '20130430'  --�����ռ����ս�
 -- go
 --exec upg_compute_comp_classed_trade_daybyday '001','20130501', '20130531'  --�����ռ����ս�
 -- go
 --exec upg_compute_comp_classed_trade_daybyday '001','20130601', '20130630'  --�����ռ����ս�
 -- go
 --exec upg_compute_comp_classed_trade_daybyday '001','20130701', '20130731'  --�����ռ����ս�
 -- go
 --exec upg_compute_comp_classed_trade_daybyday '001','20130801', '20130831'  --�����ռ����ս�
 -- go
 --exec upg_compute_comp_classed_trade_daybyday '001','20130901', '20130930'  --�����ռ����ս�
 -- go
 --exec upg_compute_comp_classed_trade_daybyday '001','20131001', '20131031'  --�����ռ����ս�
 -- go
 --exec upg_compute_comp_classed_trade_daybyday '001','20131101', '20131131'  --�����ռ����ս�
 -- go
 --exec upg_compute_comp_classed_trade_daybyday '001','20131201', '20131231'  --�����ռ����ս�
 
 --select * into compclasstraderesultbak20140116 from compclasstraderesult
 
 --select * into detial_trade_byday_fromshops20140116 from detial_trade_byday_fromshops
 
 --exec upg_compute_comp_trade_payinfo_daybyday '001','20130101', '20130131' --֧����ʽ�ս�
 --exec upg_compute_comp_detial_trade '001','20130101', '20130131'	--�ռ����ս�
 --go
 -- exec upg_compute_comp_trade_payinfo_daybyday '001','20130201', '20130228' --֧����ʽ�ս�
 --exec upg_compute_comp_detial_trade '001','20130201', '20130228'	--�ռ����ս�
 --go
 -- exec upg_compute_comp_trade_payinfo_daybyday '001','20130301', '20130331' --֧����ʽ�ս�
 --exec upg_compute_comp_detial_trade '001','20130301', '20130331'	--�ռ����ս�
 --go
 -- exec upg_compute_comp_trade_payinfo_daybyday '001','20130401', '20130430' --֧����ʽ�ս�
 --exec upg_compute_comp_detial_trade '001','20130401', '20130430'	--�ռ����ս�
 --go
 -- exec upg_compute_comp_trade_payinfo_daybyday '001','20130501', '20130531' --֧����ʽ�ս�
 --exec upg_compute_comp_detial_trade '001','20130501', '20130531'	--�ռ����ս�
 --go
 -- exec upg_compute_comp_trade_payinfo_daybyday '001','20130601', '20130630' --֧����ʽ�ս�
 --exec upg_compute_comp_detial_trade '001','20130601', '20130630'	--�ռ����ս�
 --go
 -- exec upg_compute_comp_trade_payinfo_daybyday '001','20130701', '20130731' --֧����ʽ�ս�
 --exec upg_compute_comp_detial_trade '001','20130701', '20130731'	--�ռ����ս�
 --go
 -- exec upg_compute_comp_trade_payinfo_daybyday '001','20130801', '20130831' --֧����ʽ�ս�
 --exec upg_compute_comp_detial_trade '001','20130801', '20130831'	--�ռ����ս�
 --go
 -- exec upg_compute_comp_trade_payinfo_daybyday '001','20130901', '20130930' --֧����ʽ�ս�
 --exec upg_compute_comp_detial_trade '001','20130901', '20130930'	--�ռ����ս�
 --go
 -- exec upg_compute_comp_trade_payinfo_daybyday '001','20131001', '20131031' --֧����ʽ�ս�
 --exec upg_compute_comp_detial_trade '001','20131001', '20131031'	--�ռ����ս�
 --go
 -- exec upg_compute_comp_trade_payinfo_daybyday '001','20131101', '20131130' --֧����ʽ�ս�
 --exec upg_compute_comp_detial_trade '001','20131101', '20131130'	--�ռ����ս�
 --go
 -- exec upg_compute_comp_trade_payinfo_daybyday '001','20131201', '20131231' --֧����ʽ�ս�
 --exec upg_compute_comp_detial_trade '001','20131201', '20131231'	--�ռ����ս�
 --go
 
 select * into staff_work_salarybak20140116bak from staff_work_salary
 exec upg_compute_comp_satff_salary_daybyday '001','20130101', '20130131'  --�����ս�
 go
 exec upg_compute_comp_satff_salary_daybyday '001','20130201', '20130228'  --�����ս�
  go
 exec upg_compute_comp_satff_salary_daybyday '001','20130301', '20130331'  --�����ս�
  go
 exec upg_compute_comp_satff_salary_daybyday '001','20130401', '20130430'  --�����ս�
  go
 exec upg_compute_comp_satff_salary_daybyday '001','20130501', '20130531'  --�����ս�
  go
 exec upg_compute_comp_satff_salary_daybyday '001','20130601', '20130630'  --�����ս�
  go
 exec upg_compute_comp_satff_salary_daybyday '001','20130701', '20130731'  --�����ս�
  go
 exec upg_compute_comp_satff_salary_daybyday '001','20130801', '20130831'  --�����ս�
  go
 exec upg_compute_comp_satff_salary_daybyday '001','20130901', '20130930'  --�����ս�
  go
 exec upg_compute_comp_satff_salary_daybyday '001','20131001', '20131031'  --�����ս�
  go
 exec upg_compute_comp_satff_salary_daybyday '001','20131101', '20131131'  --�����ս�
  go
 exec upg_compute_comp_satff_salary_daybyday '001','20131201', '20131231'  --�����ս�
 


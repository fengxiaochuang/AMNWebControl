if exists(select 1 from sysobjects where type='P' and name='upg_diarialBill_byday_analysis')
	drop procedure upg_diarialBill_byday_analysis
go
create procedure upg_diarialBill_byday_analysis 
(             
  @compid  varchar(10),   -- �Ѿ���֧�ָ�����Ĺ�˾              
  @fromdate varchar(10),  --��ʼ����              
  @todate   varchar(10)  --��������      
)            
as              
begin                      
	CREATE TABLE    #dpayinfo_billcount             --  ����--֧����ϸ
	(
		paycompid		varchar(10)      NULL,   --��˾���
		paydate			varchar(10)      NULL,   --֧������
		paybilltype		varchar(5)		 NULL,   --�������  SY ����  SK  �ۿ�  CZ ��ֵ ZK  ת�� HZ ������Ŀ TK �˿�
		paymode			varchar(5)		 NULL,   --֧����ʽ
		payamt			float			 NULL,   --֧�����
	)

	exec upg_compute_comp_trade_payinfo @compid,@fromdate,@todate
    
    
    select  paycompid,paydate,paybilltype,paymode,payamt=sum(isnull(payamt,0)) 
    from #dpayinfo_billcount group by paycompid,paydate,paybilltype,paymode
    drop table #dpayinfo_billcount
end 
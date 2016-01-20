if exists(select 1 from sysobjects where type='P' and name='upg_yejiAnalysis_byMonth_HT')
	drop procedure upg_yejiAnalysis_byMonth_HT
go
create procedure upg_yejiAnalysis_byMonth_HT    
(    
	@compid  varchar(10),    
	@month   varchar(10)   
)    
as    
begin   
 
	                                  
	

  
    create table #shopyejianalysis  
	(    
		compid				varchar(10) not null,    
		compname			varchar(40) null,    
		mmonth				varchar(10)	null,
		totalAmt			float  null, -- //������Ӫҵ��    
		totalAmtA			float  null, -- ȥ��ͬ����Ӫҵ��    
		totalAmtB			float  null, -- ������Ӫҵ��    
		totalAmtRateA		float  null,--  Ӫҵ��ͬ��    
		totalAmtRateB		float  null,--  Ӫҵ���    
	     
		totalFactAmt		float  null,--  ������ʵҵ��    
		totalFactAmtA		float  null,--  ȥ��ͬ����ʵҵ��    
		totalFactAmtB		float  null,--  ������ʵҵ��    
		totalFactAmtRateA	float  null,--  ʵҵ��ͬ��    
		totalFactAmtRateB	float  null,--  ʵҵ������    
	     
		saleCardAmt			float  null,--  �������ۿ�    
		saleCardAmtA		float  null,--  ȥ��ͬ�����ۿ�    
		saleCardAmtB		float  null,--  �������ۿ�    
		saleCardAmtRateA	float  null,--  �ۿ�ͬ��    
		saleCardAmtRateB	float  null,--  �ۿ�����    
	     
		pinCardAmt			float  null,--  ����������    
		pinCardAmtA			float  null,--  ȥ��ͬ��������    
		pinCardAmtB			float  null,--  ����������    
		pinCardAmtRateA		float  null,--  ����ͬ��    
		pinCardAmtRateB		float  null,--  ��������    
	     
		buyGoodsAmt			float  null,--  ���������Ʒ    
		buyGoodsAmtA		float  null,--  ȥ��ͬ�������Ʒ    
		buyGoodsAmtB		float  null,--  �������Ʒҵ��    
		buyGoodsAmtRateA	float  null,--  ���Ʒͬ��    
		buyGoodsAmtRateB	float  null,--  ���Ʒ����    
	)   
	create nonclustered index idx_shopyejianalysis_mmonth on #shopyejianalysis(compid,mmonth)	
	--����ѡ����ŵ��ŵ�#diarialBill_byday_fromShops��                                        
	insert #shopyejianalysis(compid,compname,mmonth)                                        
	 select compno,compname,@month                                        
	 from companyinfo,compchaininfo,compchainstruct
	 where curcomp= @compid and  relationcomp=compno and curcompno=compno and complevel=4
	
	if len(@month)=6    
		set @month=@month+'01' 
		
	----�������ͬ�� 
	declare @tyear varchar(10)    
	declare @tmonth varchar(10)    
	declare @beforeyearMonth varchar(20)  
	set @beforeyearMonth=DATEADD(year, -1, @month)    
	set @tyear = year(@beforeyearMonth)    
	set @tmonth = month(@beforeyearMonth)    
	if(cast(@tmonth as int)<10)    
		set @tmonth='0'+@tmonth    
	set @beforeyearMonth=@tyear+@tmonth  
     
    ----��ñ���ͬ�� 
    declare @beforeMonth varchar(20)    
	set @beforeMonth=DATEADD(month, -1, @month)    
	set @tyear = year(@beforeMonth)    
	set @tmonth = month(@beforeMonth)    
	if(cast(@tmonth as int)<10)    
		set @tmonth='0'+@tmonth    
	set @beforeMonth=@tyear+@tmonth 
	
	
	--��Ӫҵ��totalAmt
	update #shopyejianalysis set totalAmt=ISNULL((select SUM(isnull(total,0)) from detial_trade_byday_fromshops 
	 where compid=shopId and dateReport like '%'+SUBSTRING(@month,1,6)+'%'),0)
	update #shopyejianalysis set totalAmtA=ISNULL((select SUM(isnull(total,0)) from detial_trade_byday_fromshops 
	 where compid=shopId and dateReport like '%'+SUBSTRING(@beforeyearMonth,1,6)+'%'),0)
	update #shopyejianalysis set totalAmtB=ISNULL((select SUM(isnull(total,0)) from detial_trade_byday_fromshops 
	 where compid=shopId and dateReport like '%'+SUBSTRING(@beforeMonth,1,6)+'%'),0)
	 
	 --��ʵҵ��totalFactAmt
	update a set totalFactAmt=ISNULL((select SUM(isnull(realtotalyeji,0)) from compclasstraderesult b
	 where a.compid=b.compid and ddate like '%'+SUBSTRING(@month,1,6)+'%'),0) from #shopyejianalysis a
	update a set totalFactAmtA=ISNULL((select SUM(isnull(realtotalyeji,0)) from compclasstraderesult b 
	 where a.compid=b.compid and ddate like '%'+SUBSTRING(@beforeyearMonth,1,6)+'%'),0) from #shopyejianalysis a
	update a set totalFactAmtB=ISNULL((select SUM(isnull(realtotalyeji,0)) from compclasstraderesult b
	 where a.compid=b.compid and ddate like '%'+SUBSTRING(@beforeMonth,1,6)+'%'),0) from #shopyejianalysis a
	 
	 --�ܿ��춯ҵ��saleCardAmt
	update #shopyejianalysis set saleCardAmt=ISNULL((select SUM(isnull(totalCardTrans,0)) from detial_trade_byday_fromshops 
	 where compid=shopId and dateReport like '%'+SUBSTRING(@month,1,6)+'%'),0)
	update #shopyejianalysis set saleCardAmtA=ISNULL((select SUM(isnull(totalCardTrans,0)) from detial_trade_byday_fromshops 
	 where compid=shopId and dateReport like '%'+SUBSTRING(@beforeyearMonth,1,6)+'%'),0)
	update #shopyejianalysis set saleCardAmtB=ISNULL((select SUM(isnull(totalCardTrans,0)) from detial_trade_byday_fromshops 
	 where compid=shopId and dateReport like '%'+SUBSTRING(@beforeMonth,1,6)+'%'),0)
	 
	 	 --������ҵ��pinCardAmt
	update #shopyejianalysis set pinCardAmt=ISNULL((select SUM(isnull(cardsalesservices,0)+isnull(cardsalesprod,0)+isnull(acquisitionCardServices,0)) from detial_trade_byday_fromshops 
	 where compid=shopId and dateReport like '%'+SUBSTRING(@month,1,6)+'%'),0)
	update #shopyejianalysis set pinCardAmtA =ISNULL((select SUM(isnull(cardsalesservices,0)+isnull(cardsalesprod,0)+isnull(acquisitionCardServices,0)) from detial_trade_byday_fromshops 
	 where compid=shopId and dateReport like '%'+SUBSTRING(@beforeyearMonth,1,6)+'%'),0)
	update #shopyejianalysis set pinCardAmtB =ISNULL((select SUM(isnull(cardsalesservices,0)+isnull(cardsalesprod,0)+isnull(acquisitionCardServices,0)) from detial_trade_byday_fromshops 
	 where compid=shopId and dateReport like '%'+SUBSTRING(@beforeMonth,1,6)+'%'),0)
    
    
    --�ܲ�Ʒ����ҵ��buyGoodsAmt
	update #shopyejianalysis set buyGoodsAmt=ISNULL((select SUM(isnull(cashProd,0)+isnull(creditProd,0)+isnull(checkProd,0)+isnull(zftProd,0)+isnull(ockkProd,0)+isnull(tgkkProd,0)+isnull(cardSalesprod,0)) from detial_trade_byday_fromshops 
	 where compid=shopId and dateReport like '%'+SUBSTRING(@month,1,6)+'%'),0)
	update #shopyejianalysis set buyGoodsAmtA =ISNULL((select SUM(isnull(cashProd,0)+isnull(creditProd,0)+isnull(checkProd,0)+isnull(zftProd,0)+isnull(ockkProd,0)+isnull(tgkkProd,0)+isnull(cardSalesprod,0)) from detial_trade_byday_fromshops 
	 where compid=shopId and dateReport like '%'+SUBSTRING(@beforeyearMonth,1,6)+'%'),0)
	update #shopyejianalysis set buyGoodsAmtB =ISNULL((select SUM(isnull(cashProd,0)+isnull(creditProd,0)+isnull(checkProd,0)+isnull(zftProd,0)+isnull(ockkProd,0)+isnull(tgkkProd,0)+isnull(cardSalesprod,0)) from detial_trade_byday_fromshops 
	 where compid=shopId and dateReport like '%'+SUBSTRING(@beforeMonth,1,6)+'%'),0)
    
    
	update #shopyejianalysis set totalAmtA=1 where totalAmtA=0    
	update #shopyejianalysis set totalFactAmtA=1 where totalFactAmtA=0    
	update #shopyejianalysis set saleCardAmtA=1 where saleCardAmtA=0    
	update #shopyejianalysis set pinCardAmtA=1 where pinCardAmtA=0    
	update #shopyejianalysis set buyGoodsAmtA=1 where buyGoodsAmtA=0    
	update #shopyejianalysis set totalAmtB=1 where totalAmtB=0    
	update #shopyejianalysis set totalFactAmtB=1 where totalFactAmtB=0    
	update #shopyejianalysis set saleCardAmtB=1 where saleCardAmtB=0    
	update #shopyejianalysis set pinCardAmtB=1 where pinCardAmtB=0    
	update #shopyejianalysis set buyGoodsAmtB=1 where buyGoodsAmtB=0    
    
    
	update #shopyejianalysis set totalAmtRateA=isnull(totalAmt,0)/isnull(totalAmtA,1),totalAmtRateB=isnull(totalAmt,0)/isnull(totalAmtB,1),    
     
        totalFactAmtRateA=isnull(totalFactAmt,0)/isnull(totalFactAmtA,1),totalFactAmtRateB=isnull(totalFactAmt,0)/isnull(totalFactAmtB,1),    
     
        saleCardAmtRateA=isnull(saleCardAmt,0)/isnull(saleCardAmtA,1),saleCardAmtRateB=isnull(saleCardAmt,0)/isnull(saleCardAmtB,1),    
     
        pinCardAmtRateA=isnull(pinCardAmt,0)/isnull(pinCardAmtA,1),pinCardAmtRateB=isnull(pinCardAmt,0)/isnull(pinCardAmtB,1),    
    
        buyGoodsAmtRateA=isnull(buyGoodsAmt,0)/isnull(buyGoodsAmtA,1),buyGoodsAmtRateB=isnull(buyGoodsAmt,0)/isnull(buyGoodsAmtB,1)    
    
	update #shopyejianalysis set totalAmtA=0,totalAmtRateA=0 where totalAmtA=1    
	update #shopyejianalysis set totalFactAmtA=0,totalFactAmtRateA=0 where totalFactAmtA=1    
	update #shopyejianalysis set saleCardAmtA=0,saleCardAmtRateA=0 where saleCardAmtA=1    
	update #shopyejianalysis set pinCardAmtA=0,pinCardAmtRateA=0 where pinCardAmtA=1    
	update #shopyejianalysis set buyGoodsAmtA=0,buyGoodsAmtRateA=0 where buyGoodsAmtA=1    
	update #shopyejianalysis set totalAmtB=0,totalAmtRateB=0 where totalAmtB=1    
	update #shopyejianalysis set totalFactAmtB=0,totalFactAmtRateB=0 where totalFactAmtB=1    
	update #shopyejianalysis set saleCardAmtB=0,saleCardAmtRateB=0 where saleCardAmtB=1    
	update #shopyejianalysis set pinCardAmtB=0,pinCardAmtRateB=0 where pinCardAmtB=1    
	update #shopyejianalysis set buyGoodsAmtB=0,buyGoodsAmtRateB=0 where buyGoodsAmtB=1    
    
	select compid,compname,mmonth,totalAmt,totalAmtA,totalAmtB,totalAmtRateA=convert(numeric(20,2),totalAmtRateA),totalAmtRateB=convert(numeric(20,2),totalAmtRateB),    
		totalFactAmt,totalFactAmtA,totalFactAmtB,totalFactAmtRateA=convert(numeric(20,2),totalFactAmtRateA),totalFactAmtRateB=convert(numeric(20,2),totalFactAmtRateB),    
		saleCardAmt,saleCardAmtA,saleCardAmtB,saleCardAmtRateA=convert(numeric(20,2),saleCardAmtRateA),saleCardAmtRateB=convert(numeric(20,2),saleCardAmtRateB),    
		pinCardAmt,pinCardAmtA,pinCardAmtB,pinCardAmtRateA=convert(numeric(20,2),pinCardAmtRateA),pinCardAmtRateB=convert(numeric(20,2),pinCardAmtRateB),    
		buyGoodsAmt,buyGoodsAmtA,buyGoodsAmtB,buyGoodsAmtRateA=convert(numeric(20,2),buyGoodsAmtRateA),buyGoodsAmtRateB=convert(numeric(20,2),buyGoodsAmtRateB)     
	from #shopyejianalysis    
	order by  compid asc
   
    drop table #shopyejianalysis    
end  
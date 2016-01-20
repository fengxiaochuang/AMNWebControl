select * from MFQC
select * from MRQC


insert mgoodsouter(outercompid,outerbillid,outerdate,outertime,outerwareid,outertype,revicetype,outerstaffid,sendbillid,billflag,outeropationerid,outeropationdate)
select '001','00120131231001x','20131231','202020','01',1,1,'amani','',2,'amani','20131231'


insert mgoodsouter(outercompid,outerbillid,outerdate,outertime,outerwareid,outertype,revicetype,outerstaffid,sendbillid,billflag,outeropationerid,outeropationdate)
select '001','00120131231002x','20131231','202020','02',1,1,'amani','',2,'amani','20131231'

insert dgoodsouter(outercompid,outerbillid,outerseqno,outergoodsno,standunit,standprice,curgoodsstock,outerunit,outercount,outerprice,outeramt,outerrate)
select '001','00120131231001x',row_number() over(order by goodsno desc),goodsno,'ƿ',goodsprice,goodscount,'ƿ',goodscount,goodsprice,goodsamt,1
from MFQC

insert dgoodsouter(outercompid,outerbillid,outerseqno,outergoodsno,standunit,standprice,curgoodsstock,outerunit,outercount,outerprice,outeramt,outerrate)
select '001','00120131231002x',row_number() over(order by goodsno desc),goodsno,'ƿ',goodsprice,goodscount,'ƿ',goodscount,goodsprice,goodsamt,1
from MRQC


insert mgoodsinsert(insercompid,inserbillid,inserdate,insertime,inserwareid,inserstaffid,insertype,checkbillflag,checkbillno,storesendbill,exitstoreno,exidbillno,billflag)
select '001','00120131231001x','20131231','202020','01','amani',1,0,'','','','',0
insert mgoodsinsert(insercompid,inserbillid,inserdate,insertime,inserwareid,inserstaffid,insertype,checkbillflag,checkbillno,storesendbill,exitstoreno,exidbillno,billflag)
select '001','00120131231002x','20131231','202020','02','amani',1,0,'','','','',0

insert dgoodsinsert(insercompid,inserbillid,inserseqno,insergoodsno,inserunit,insercount,goodsprice,goodsamt,standunit,standcount,standprice)
select '001','00120131231001x',row_number() over(order by goodsno desc),goodsno,'ƿ',goodscount,goodsprice,goodsamt,'ƿ',goodscount,goodsprice
from MFQC

insert dgoodsinsert(insercompid,inserbillid,inserseqno,insergoodsno,inserunit,insercount,goodsprice,goodsamt,standunit,standcount,standprice)
select '001','00120131231002x',row_number() over(order by goodsno desc),goodsno,'ƿ',goodscount,goodsprice,goodsamt,'ƿ',goodscount,goodsprice
from MRQC



if not exists(select 1 from sysobjects where type='U' and name='dgoodsinsert')
CREATE TABLE    dgoodsinsert             
(
	insercompid			varchar(10)				NOT NULL,   --��˾���
	inserbillid			varchar(30)				NOT NULL,   --��ⵥ��
	inserseqno			float					NOT NULL,   --���
	insergoodsno		varchar(20)					NULL,   --��Ʒ����
	inserunit			varchar(5)					NULL,   --������λ
	insercount			float						NULL,   --(������λ)����
	goodsprice			float						NULL,   --����
	goodsamt			float						NULL,   --���
	standunit			varchar(5)					NULL,   --��׼��λ
	standcount			float   					NULL,	--��׼��λ����
	standprice			float	  					NULL,	--��׼��λ�۸�
	producedate			varchar(8)					NULL,   --��������
	producenorm			varchar(20)					NULL,   --��Ʒ���
	frombarcode			varchar(20)					NULL,   --��ʼ����
	tobarcode			varchar(20)					NULL,   --��������
	CONSTRAINT PK_dgoodsinsert PRIMARY KEY CLUSTERED(insercompid,inserbillid,inserseqno)
)
go 


update mgoodsouter set billflag=0 ,outeropationerid='',outeropationdate='' where outerbillid='00120131231001x'
update mgoodsouter set billflag=0 ,outeropationerid='',outeropationdate='' where outerbillid='00120131231002x'


select * from  mgoodsstockinfo where changebillno='00120131231002x' and changetype='1'
select * from dgoodsstockinfo where changebillno='00120131231002x' and changetype='1'

insert mgoodsouter(outercompid,outerbillid,outerdate,outertime,outerwareid,outertype,revicetype,outerstaffid,sendbillid,billflag,outeropationerid,outeropationdate)

insert dgoodsouter(outercompid,outerbillid,outerseqno,outergoodsno,standunit,standprice,curgoodsstock,outerunit,outercount,outerprice,outeramt,outerrate)

insert mgoodsstockinfo(changecompid,changetype,changebillno,changedate,changetime,changewareid,changeoption,changestaffid,changeflag)
select changecompid,changetype,'20130513001_02',changedate,changetime,'02',changeoption,changestaffid,changeflag
 from mgoodsstockinfo where changebillno='20130513001_01'
 
 insert dgoodsstockinfo( changecompid,changetype,changebillno,changeseqno,changegoodsno,standunit,standcount,standprice,producedate,changeunit,changeprice,changecount,changeamt)
select changecompid,changetype,'20130513001_02',changeseqno,changegoodsno,standunit,standcount,standprice,producedate,changeunit,changeprice,changecount,changeamt
 from dgoodsstockinfo where changebillno='20130513001_01' and changegoodsno='41209103'
delete dgoodsstockinfo where changebillno='20130513001_01' and changegoodsno='41209103'


select * from MRQC where goodsno='50209'

select * from MfQC where goodsno='50209'



update dgoodsstockinfo set changecompid=changecompid+'X' where changegoodsno in (
select goodsno from goodsinfo where goodsno ='50211'  )


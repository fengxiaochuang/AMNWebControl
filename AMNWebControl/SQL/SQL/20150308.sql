create table vouchers
(
	compid varchar(20) not null,--��˾���
	vchno varchar(50) not null,--�����
	vchname varchar(50) null,--����
	vchtype int  null,--����
	amt  float null,--���
	PRIMARY KEY(compid,vchno)
)

create table vouchersdetal
(
	compid varchar(20) not null,--��˾���
	vchno varchar(50) not null,--����ȯ���
	itemno varchar(20) not null,--������Ŀ
	vchtype int null,--����
	amt float null,--���
	PRIMARY KEY(compid,vchno,itemno)
)

create table weixinclent
(
	operid varchar(100) null,--openid
	clientname varchar(50) null,--�ͻ�����
	mobile varchar(20) null,--�ֻ�����
	qdyno varchar(20)  not null primary key,--
	vchno varchar(20) null,--���ô���
	billid varchar(50) null,--����
	createdate varchar(20) null
)

create table wxbandcard
(
	uuid varchar(50) not null primary key,--Ψһ���
	cardno varchar(50) not null,--��Ա����
	randomno varchar(50) not null,--18λ�����
	createdate varchar(20) null,--����ʱ��yyyyMMddhhmmss
	validate varchar(20) null,--������Ч����yyyyMMddhhmmss
)

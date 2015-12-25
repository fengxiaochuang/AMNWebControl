---------------------------------------
-----sysuserinfo ϵͳģ����Ϣ CREATE by liujie 20130628
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='sysmodeinfo')

CREATE table sysmodeinfo
(
	sysversion			varchar(10)			Not NULL	,-- �汾��
	upmoduleno			varchar(20)			Not NULL	,-- �ϼ�ģ��Ŀ¼
	curmoduleno			varchar(20)			Not NULL	,-- ģ��ID
	modulename	        varchar(40)			NULL		,-- ģ������
	modulevel           int					NULL		,-- Ŀ¼����  0��ģ�� 1 ģ�� 2 ģ��
	moduletype			varchar(5)			NULL		,--	ģ������ F���� R ����
	remark				varchar(100)		NULL		,--	��ע˵��
	moduletitle			varchar(20)			NULL		,-- ģ����ʾ����
	moduleurl			varchar(50)			NULL		,-- ģ��·��
	modulewidth			int					NULL		,--	ģ�����
	moduleheight		int					NULL		,--	ģ��߶�
	showtype			int					null		,-- ��ʾ˳��
	CONSTRAINT PK_sysmodeinfo PRIMARY KEY NONCLUSTERED(sysversion,upmoduleno,curmoduleno)
)
go


---------------------------------------
-----sysmodepurview ϵͳģ��Ȩ����Ϣ CREATE by liujie 20130628
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='sysmodepurview')

CREATE table sysmodepurview
(
	curRoleno			varchar(10)			Not NULL	,-- ģ��ID
	curpurviewno		varchar(10)			Not NULL	,-- Ȩ��ID
	purviewname	        varchar(40)			NULL		,-- Ȩ������
	remark				varchar(50)			NULL		,--	��ע˵��
	CONSTRAINT PK_sysmodepurview PRIMARY KEY NONCLUSTERED(curpurviewno,curRoleno)
)
go


---------------------------------------
-----sysuserinfo ϵͳʹ������Ϣ CREATE by liujie 20130628(sysuserlogininfo) 
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='sysuserinfo')

CREATE table sysuserinfo 
(
	userno				varchar(20)		Not NULL,   --�û���
	userpwd				varchar(100)	NULL,		--����
	enableflag			int				NULL,		--�Ƿ����� 1 ���� 0 ������
	userrole			varchar(5)		NULL,		--�û���ɫ 1 ϵͳ������ 2 �ŵ������ 3����רԱ 4����רԱ 5 ��ϢרԱ 6����Ա			
	frominnerno			varchar(20)		NULL,		--�ڲ����
	fromcompno			varchar(10)		NULL,		--�ŵ���
	datefrom			varchar(10)		NULL,		--��ʼ����
	dateto				varchar(10)		NULL,		--��������
	callcenterqueue		varchar(30)		NULL,		--����ϵͳ������
	callcenterinterface	varchar(40)		NULL,		--�������ڻ���ϯ����
	CONSTRAINT PK_sysuserinfo PRIMARY KEY NONCLUSTERED(userno)
)
go




if not  exists(select 1 from sysobjects where type='U' and name='sysuserinfobak')

CREATE table sysuserinfobak 
(
	seqno			int identity(1,1)	Not NULL,
	userno			varchar(20)		Not NULL,   --�û���
	userpwd			varchar(100)	NULL,		--����
	enableflag		int				NULL,		--�Ƿ����� 1 ���� 0 ������
	userrole		varchar(5)		NULL,		--�û���ɫ 1 ϵͳ������ 2 �ŵ������ 3����רԱ 4����רԱ 5 ��ϢרԱ 6����Ա			
	frominnerno		varchar(20)		NULL,		--�ڲ����
	fromcompno		varchar(10)		NULL,		--�ŵ���
	datefrom		varchar(10)		NULL,		--��ʼ����
	dateto			varchar(10)		NULL,		--��������
	operationerno	varchar(20)		NULL,		--������Ա
	operationdate	varchar(10)		NULL,		--��������
	operationtime	varchar(10)		NULL,		--��������
	CONSTRAINT PK_sysuserinfobak PRIMARY KEY NONCLUSTERED(seqno)
)
go

-----user �û�������Ϣ CREATE by liujie 20130628(sysuserlogininfo) 
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='useroverall')

CREATE table useroverall 
(
	userno			varchar(20)	Not NULL,   --�û���
	modetype		varchar(5)	Not NULL,	--1 ��¼�ŵ� 2 ����ģ�� 3�����ŵ� 4 ���ù���  5��������Ȩ��
	modevalue		varchar(20)	Not NULL,	--����ֵ
	descriptions	varchar(100)	NULL,		--����
	CONSTRAINT PK_useroverall PRIMARY KEY NONCLUSTERED(userno,modetype,modevalue)
)
go


-----user �û�������Ϣ�༭ CREATE by liujie 20130628(usereditright) 
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='usereditright')

CREATE table usereditright
(
	userno			varchar(10)	Not NULL,   --�û����
	sysmodeno		varchar(20)	Not NULL,	--ģ����
	functionno		varchar(20)	Not NULL,	--���ܱ��
	browsepurview	varchar(5)	NULL,		--�鿴Ȩ��Y �� N��
	editpurview		varchar(5)	NULL,		--�༭Ȩ��Y �� N��
	exportpurview	varchar(5)	NULL,		--����Ȩ��Y �� N��
	postpurview		varchar(5)	NULL,		--����Ȩ��Y �� N��
	confirmpurview	varchar(5)	NULL,		--���Ȩ��Y �� N��
	invalidpurview	varchar(5)	NULL,		--����Ȩ��Y �� N��
	disabledflag	int			NULL,		--�Ƿ�����  0 ���� 1 ����
	CONSTRAINT PK_usereditright PRIMARY KEY NONCLUSTERED(userno,sysmodeno,functionno)
)
go

-----sysrolemode ��ɫģ�� CREATE by liujie 20130628(sysuserlogininfo) 
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='sysrolemode')

CREATE table sysrolemode 
(
	roleno			varchar(5)	Not NULL,   --��ɫ���
	sysmodeno		varchar(20)	Not NULL,		--ģ����
	functionno		varchar(20)	Not NULL,		--���ܱ��
	browsepurview	varchar(5)	NULL,		--�鿴Ȩ��Y �� N��
	editpurview		varchar(5)	NULL,		--�༭Ȩ��Y �� N��
	exportpurview	varchar(5)	NULL,		--����Ȩ��Y �� N��
	postpurview		varchar(5)	NULL,		--����Ȩ��Y �� N��
	confirmpurview	varchar(5)	NULL,		--���Ȩ��Y �� N��
	invalidpurview	varchar(5)	NULL,		--����Ȩ��Y �� N��
	disabledflag	int			NULL,		--�Ƿ�����  0 ���� 1 ����
	CONSTRAINT PK_sysrolemode PRIMARY KEY NONCLUSTERED(roleno,sysmodeno,functionno)
)
go


if not exists(select 1 from sysobjects where type='U' and name='sysroletoposation')
CREATE table sysroletoposition
(
	roleno			varchar(5)	Not NULL,   --��ɫ���
	position		varchar(10)	Not	NULL,	--��λ���
	CONSTRAINT PK_sysroletoposition PRIMARY KEY NONCLUSTERED(roleno,position)
)
go


---------------------------------------
-----sysuserlogininfo -�û���¼��־ CREATE by liujie 20130628
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='sysuserlogininfo')
CREATE table sysuserlogininfo 
(
	seqno				int identity(1,1)	Not NULL,
	logindate			varchar(8)			NULL, -- login date
	logintime			varchar(6)			NULL, -- login time
	loginipno			varchar(50)			NULL, -- login machine's ip
	loginmacno			varchar(50)			NULL, -- login machine's mac address
	loginuserid			varchar(30)			NULL, -- user id
	loginusername		varchar(40)			NULL, -- user name
	logincompid			varchar(10)			NULL, -- login company id 
	logincompname		varchar(50)			NULL, -- login company name
	CONSTRAINT PK_sysuserlogininfo PRIMARY KEY NONCLUSTERED(seqno)
)
go


---------------------------------------
-----company �ŵ���Ϣ CREATE by liujie 20130628
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='companyinfo')
CREATE table companyinfo
(
	compno				varchar(10)		Not NULL,	-- �ŵ���
	compname			varchar(60)     NULL,		-- �ŵ����� 
	compstate			varchar(2)      NULL,		-- �ŵ�״̬
	compphone			varchar(15)     NULL,		-- �ŵ�绰  
	compaddress			varchar(60)     NULL,		-- �ŵ��ַ
	comptradelicense	varchar(40)     NULL,		-- �ŵ�Ӫҵִ��
	compfex				varchar(15)     NULL,		-- �ŵ괫�� 
	compzipcode			varchar(6)      NULL,		-- �ŵ���������
	compadslno			varchar(20)     NULL,		-- �ŵ�ADsL�˺�
	compadslpassword	varchar(20)		NULL,		-- �ŵ�ADsL����
	compipaddress		varchar(15)		NULL,		-- �ŵ�IP��ַ
	compipaddressex		varchar(15)		NULL,		-- �ŵ�IP��ַ��չ
	comparea			float		    NULL,		-- �ŵ����  
	comprent			float		    NULL,		-- �ŵ����  
	compresponsible		varchar(20)		NULL,		-- �ŵ�������
	compmode			varchar(5)		NULL,		-- �ŵ�ģʽ
	CREATEdate			varchar(10)		NULL,		-- ��������
	region				varchar(100)	NULL,       -- ������
	xcoordinate			varchar(20)		NULL,		-- X����
	ycoordinate			varchar(20)		NULL,		-- Y����
	mangerPassword		varchar(20)		NULL,		-- ��������
	roomnumber int					null, --��������
	mirrornumber int				null, --��̨����
	shopwf1  varchar(100)				null,--��������1
	shopwf2  varchar(100)				null,--��������2
	shopwf3  varchar(100)				null,--��������3
	shopwf4  varchar(100)				null,--��������4
	shopwf5  varchar(100)				null,--��������5
	shopwf6  varchar(100)				null,--��������6
	shopwf7  varchar(100)				null,--��������7
	shopwf8  varchar(100)				null,--��������8
	shopwf9  varchar(100)				null,--��������9
	shopwf10  varchar(100)				null,--��������10
	bilinginfo varchar(50) 				NULL --��Ʊ��Ϣ�ֶ�
	CONSTRAINT PK_companyinfo PRIMARY KEY NONCLUSTERED(compno)
)
go





---------------------------------------
-----compchainstruct �ŵ������ṹ CREATE by liujie 20130628
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='compchainstruct')
CREATE table compchainstruct
(
	curcompno				varchar(10)		Not NULL,	-- ��ǰ�ŵ�
	parentcompno			varchar(10)		NULL,		-- ��һ���ŵ�
	complevel				int				NULl,		-- �ŵ꼶��    1 �ܲ� 2 ��ҵ�� 3 ���� 4 �ŵ�
	CREATEdate				varchar(10)		NULL,		-- ��������	
	CONSTRAINT PK_compchainstruct PRIMARY KEY NONCLUSTERED(curcompno)	
)
go
---------------------------------------
-----compchaininfo �ŵ�������ϸ CREATE by liujie 20130628
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='compchaininfo')
CREATE table compchaininfo
(
	curcomp				varchar(10)  Not  NULL,-- ��ǰ�ŵ�
	relationcomp		varchar(10)  Not  NULL,-- ��ǰ���ŵ�
	CONSTRAINT PK_compchaininfo PRIMARY KEY NONCLUSTERED(curcomp,relationcomp)	
)
go

---------------------------------------
-----a3area �����
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='a3area')
CREATE table a3area
(
	id		int			not null,
	code	varchar(10)	not null,
	name	varchar(50)	not null,
	cityId	int			not null,
	CONSTRAINT PK_a3area PRIMARY KEY NONCLUSTERED(id,code,name,cityId)	
)
CREATE NONCLUSTERED index idx_a3area_code on a3area(code)


---------------------------------------
-----a3city ���б�
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='a3city')
CREATE table a3city
(
	id			int			not null,
	code		varchar(10)	not null,
	name		varchar(50)	not null,
	provinceId	int			not null,
	CONSTRAINT PK_a3city PRIMARY KEY NONCLUSTERED(id,code,name,provinceId)
)
CREATE NONCLUSTERED index idx_a3city_code on a3city(code)


---------------------------------------
-----a3province ʡ�ݱ�
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='a3province')
CREATE table a3province
(
	id			int			 not null,
	code		varchar(10)	 not null,
	name		varchar(50)	 not null,
	CONSTRAINT PK_a3province PRIMARY KEY NONCLUSTERED(id,code,name)
)
CREATE NONCLUSTERED index idx_a3province_code on a3province(code)

---------------------------------------
-----compwarehouse �ŵ�ֿ� CREATE by liujie 20130628
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='compwarehouse')
CREATE table compwarehouse
(
	compno				varchar(10)		Not  NULL,-- ��ǰ�ŵ�
	warehouseno			varchar(10)		Not  NULL,-- �ֿ���
	warehousename		varchar(30)		NULL	  ,-- �ֿ�����
	warehousecontact	varchar(10)		NULL,       -- �ֹ������� 
	warehousephone		varchar(20)		NULL,       -- ����绰
	warehousefax		varchar(20)		NULL,       -- �ֿ⴫��
	warehouseaddress	varchar(40)		NULL,       -- �ֿ��ַ
	CONSTRAINT PK_compwarehouse PRIMARY KEY NONCLUSTERED(compno,warehouseno)	
)
go


---------------------------------------
-----compscheduling �ŵ�����Ϣ CREATE by liujie 20130628
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='compscheduling')
CREATE table compscheduling
(
	compno				varchar(10)		Not  NULL,	-- ��ǰ�ŵ�
	schedulno			varchar(10)		Not  NULL,	-- ��α��
	schedulname		varchar(30)			 NULL,	-- �������
	fromtime			varchar(10)			NULL,	-- ��ʼʱ��
	totime				varchar(10)			NULL,	-- ����ʱ��
	CONSTRAINT PK_compscheduling PRIMARY KEY NONCLUSTERED(compno,schedulno)	
)
go

---------------------------------------
-----warehousepurview   �ֿ⸺�����趨 CREATE by liujie 20130628
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='warehousepurview')
CREATE tAbLE    warehousepurview              
(
	compno			varchar(10) Not NULL,   -- ��˾��
	warehouseno		varchar(10) Not NULL,   -- �ֿ���
	staffno			varchar(20) Not NULL,   -- �ֿ⸺����Ա������
	staffname		varchar(30) NULL    , 	-- �ֿ⸺��������	
	CONSTRAINT PK_warehousepurview PRIMARY KEY CLUSTERED(compno,warehouseno,staffno)
)
go


---------------------------------------
-----staffinfo   �ŵ�Ա������ CREATE by liujie 20130628
---------------------------------------

if not exists(select 1 from sysobjects where type='U' and name='staffinfo')
CREATE tAbLE    staffinfo              
(
	compno			varchar(10)		Not NULL,   -- ��˾��
	staffno			varchar(20)		Not NULL,   -- Ա�����
	staffname		varchar(20)		NULL    , 	-- Ա������
	staffename		varchar(20)		NULL    , 	-- Ӣ����
	staffsex		int				NULL    ,--�Ա�(1,��;0Ů)        
	department		varchar(10)		NULL    ,--���ű��
	position		varchar(20 )	NULL    ,--ְλ
	arrivaldate		varchar(8 )		NULL    ,--��ְ����
	leavedate		varchar(8 )		NULL    ,--��ְ����
	contractdate	varchar(8 )		NULL    ,--��Լ������
	fillno			varchar(20)		NULL	,--������
	pccid			varchar(20)		NULL    ,--����֤��
	educational		varchar(5 )		NULL    ,--���ѧ��(���)��������
	birthdate		varchar(8  )	NULL    ,--��������
	height			float			NULL    ,--����(����)
	bodyweight		float			NULL   ,--����(����)
	aaddress		varchar(160)	NULL    ,--�����ַ
	qqno			varchar(20 )	NULL    ,--QQ����
	mobilephone		varchar(20 )	NULL    ,--�ж��绰
	email			varchar(20 )	NULL    ,--Email
	healthno		varchar(20 )	NULL    ,--����֤����
	healthdate		varchar(20 )	NULL    ,--����֤��Ч��
	curstate		varchar(1)		NULL    ,--Ŀǰ״��(1-δ��ְ ,2-��ְ ,3 -��ְ )
	socialsecurity  float			NULL    ,-- �籣
	socialsource    varchar(10)		NULL    ,-- �籣������˾
	remark			varchar(200)	NULL    ,--������ע
	staffmark		varchar(200)	null	,--Ա����ע
	searchpassword	varchar(10)		NULL    ,--��ѯ����
	staffpassword	varchar(30)		NULL    ,--Ա�������� ,Added by MZH, 2005/08/02	 ---����ǩ��������							
	manageno		varchar(20)		NULL    ,--�ڲ�������
	reservecontect	varchar(30)		NULL    ,--������ϵ��     
	reservephone	varchar(30)		NULL    ,--������ϵ�˵绰 
	reserveaddress  varchar(160)	NULL    ,--������ϵ�˵�ַ     
	introductioner  varchar(20)		NULL    ,--������
	leveltype		int				NULL    ,--��ְ���� 1 ������ְ 2 �Զ���ְ
	basesalary		float			NULL    ,--��������
	businessflag	int				NULL    ,--�Ƿ�Ϊҵ����Ա 0--���� 1--��
	banktype		varchar(5)		NULL    ,--���п�����
	bankno			varchar(30)		NULL    ,--���п���
    resulttye		varchar(5)		NULL    ,--ҵ����ʽ 0--��ȷ�ʽ -������ҵ��  2 ����ʵҵ��
	resultrate		float			NULL    ,--ҵ��ϵ��
    baseresult		float			NULL    ,--ҵ������
    salaryflag      int				NULL    ,--(����)˰ǰ˰��0˰ǰ  1˰��
    fingerno		int				NULL	,--ָ�Ʊ��
    fingernotext	varchar(500)	NULL	,--ָ���ļ�
    positiontitle   varchar(20)		NULL	,
    absencesalary   int				NULL    ,--ȱ�ڵ�н�㷨
    tichengmode		int				NULL    ,--���ģʽ 1 ����+����+��н 2 ֻ���ܵ�н
    stafftype		int				NULL	,-- 0 ���� 1 ��ǲ
    hairqualified	int				NULL	,-- 0 �ϸ� 1 ���ϸ�
    trkcqualified	int				NULL	,-- 0 �ϸ� 1 ���ϸ�
    mangerflag		int				NULL	,-- �Ƿ�Ϊ���ž���
    displayname		varchar(200)	NULL,--չʾ����
    staffintroduction	varchar(500)	null,	--Ա������
	CONSTRAINT PK_staffinfo PRIMARY KEY CLUSTERED(compno,staffno)
)
go
CREATE NONCLUSTERED index idx_staffinfo_comp on staffinfo(compno,staffno)
go
CREATE NONCLUSTERED index idx_staffinfo_manager on staffinfo(manageno)
go


if not exists(select 1 from sysobjects where type='U' and name='staffinfomanger')
CREATE tAbLE    staffinfomanger  
(
	compno			varchar(10)		Not NULL,   -- ��˾��
	curstaffno		varchar(20)		Not NULl,	-- ��ǰԱ��
	cstaffno		varchar(20)		Not NULL,   -- Ա�����
	staffname		varchar(20)		NULL    , 	-- Ա������
	department		varchar(10)		NULL    ,	-- ���ű��
	manageno		varchar(20)		NULL    ,	-- �ڲ�������
	CONSTRAINT PK_staffinfomanger PRIMARY KEY CLUSTERED(compno,curstaffno,cstaffno)
)
---------------------------------------
-----staffinfodispatch   �ŵ�Ա����ǲ�� CREATE by liujie 20130628
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='staffinfodispatch')
CREATE tAbLE    staffinfodispatch              
(
	seqno			int identity		Not NULL,   --���
	manageno		varchar(20)			NULL,		--�ڲ�������� 
	oldcompid		varchar(10)         NULL,		--���ŵ��� 
	newcompid		varchar(10)         NULL,		--���ŵ��� 
	oldempid		varchar(20)         NULL,		--��Ա�����
	olddepid		varchar(10)			NULL,		--�ϲ���
	oldpostion		varchar(10)         NULL,		--���ŵ�ְλ
    oldyjtype		varchar(5)          NULL,		--ԭҵ����ʽ
    oldyjrate		float               NULL,		--ԭҵ��ϵ��
    oldyjamt		float               NULL,		--ԭҵ������
    effectivedate	varchar(8)          NULL,		--ʵ����ǲ����
    teffectivedate	varchar(8)          NULL,		--ʵ����ǲ����
    dispatchstate	int					NULL,		--��ǲ״̬     0 �Ǽ�  1 רԱ��� 2 ���¾������ 3���¾�������
    checkinheadcompid		varchar(10)			null,	--�ܲ���˹�˾
	checkinheadstaffid		varchar(20)			null,	--�ܲ������
	checkinheaddate			varchar(8)			null,	--�ܲ��������
	comfirmcompid			varchar(10)			null,	--������˹�˾
	comfirmstaffid			varchar(20)			null,	--���������
	comfirmdate				varchar(8)			null,	--�����������
	CONSTRAINT PK_staffinfodispatch PRIMARY KEY NONCLUSTERED(seqno)
)

-----staffabsenceinfo   �ŵ�Ա��ȱ�ڱ� CREATE by liujie 20130628
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='staffasarymark')
CREATE tAbLE    staffasarymark              
(
	seqno			int identity		Not NULL,		--���
	compid			varchar(10)				NULL,		--�ŵ��� 
	manageno		varchar(20)				NULL,		--�ڲ�������� 
    absencedate		varchar(6)				NULL,		--����·�
	CONSTRAINT PK_staffasarymark PRIMARY KEY NONCLUSTERED(seqno)
)
-----staffabsenceinfo   �ŵ�Ա��ȱ�ڱ� CREATE by liujie 20130628
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='staffabsenceinfo')
CREATE tAbLE    staffabsenceinfo              
(
	seqno			int identity		Not NULL,		--���
	manageno		varchar(20)				NULL,		--�ڲ�������� 
	compid			varchar(10)				NULL,		--�ŵ��� 
	empid			varchar(20)				NULL,		--Ա�����
    absencedate		varchar(8)				NULL,		--ȱ������
	CONSTRAINT PK_staffabsenceinfo PRIMARY KEY NONCLUSTERED(seqno)
)

-----managershareinfo   �������������ʷ��� CREATE by liujie 20130628
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='managershareinfo')
CREATE tAbLE    managershareinfo              
(
	seqno			int identity		Not NULL,		--���
	manageno		varchar(20)				NULL,		--�ڲ�������� 
	empid			varchar(20)				NULL,		--Ա�����
	compid			varchar(10)				NULL,		--�ŵ��� 
    sharesalary		float					NULL,		--������������
	CONSTRAINT PK_managershareinfo PRIMARY KEY NONCLUSTERED(seqno)
)


---------------------------------------
-----staffinfo   �ŵ�Ա���춯��ʷ CREATE by liujie 20130628
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='staffhistory')
CREATE tAbLE    staffhistory              
(
	seqno			int identity    Not NULL,   --���
	manageno		varchar(20)      NULL,   --�ڲ�������� 
    changetype		varchar(20)         NULL,   --�춯���� 0�������  1��������  2��н�ʵ���  3:Ա����ְ 4����ְ����  5���ػع�˾
	oldcompid		varchar(10)         NULL,   --���ŵ��� 
	oldempid		varchar(20)         NULL,   --��Ա�����
	olddepid		varchar(10)			null,	--�ϲ���
	oldpostion		varchar(10)          NULL,   --���ŵ�ְλ
    oldsalary		float               NULL,   --ԭ����
    oldyjtype		varchar(5)          NULL,   --ԭҵ����ʽ
    oldyjrate		float               NULL,   --ԭҵ��ϵ��
    oldyjamt		float               NULL,   --ԭҵ��ϵ��
	newcompid		varchar(10)         NULL,   --���ŵ��� 
	newempid		varchar(20)         NULL,   --��Ա�����
	newdepid		varchar(10)			null,	--�²���
	newpostion		varchar(5)          NULL,   --���ŵ�ְλ
    newsalary		float               NULL,   --�¹���
    newyjtype		varchar(5)          NULL,   --��ҵ����ʽ
    newyjrate		float               NULL,   --��ҵ��ϵ��
    newyjramt		float               NULL,   --��ҵ��ϵ��
    effectivedate	varchar(8)          NULL,   --ʵ����Ч����
	optionbill		varchar(20)			null,	--���ݱ��
	changemark      varchar(300)			NULL,
	CONSTRAINT PK_staffhistory PRIMARY KEY NONCLUSTERED(seqno)
)


---------------------------------------
-----commoninfo   �������� CREATE by liujie 20130708
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='commoninfo')
CREATE tAbLE    commoninfo
(
	infotype		varchar(5)		Not NULL,		--������������
	infoname		varchar(40)		NULL,			--������������
	parentcodekey	varchar(10)		Not NULL,
	parentcodevalue	varchar(40)		NULL,
	codekey			varchar(10)		Not NULL,		--�������ϼ�	
	codevalue		varchar(40)		NULL,			--��������ֵ
	codesource		varchar(10)		NULL,			--Ĭ����Դ D (default) ��������Ϊ�ŵ�
	useflag			int				null,			--ʹ�÷�Χ 0 ���� 1 �ŵ� 2 �ܲ� 
	CONSTRAINT PK_commoninfo PRIMARY KEY CLUSTERED(infotype,parentcodekey,codekey)
)		


---------------------------------------
-----projectinfo   ��Ŀ���� CREATE by liujie 20130708
---------------------------------------

if not exists(select 1 from sysobjects where type='U' and name='projectinfo')
CREATE tAbLE    projectinfo
(
	prjmodeId			varchar(10)     Not NULL,   --��Ŀģ����
	prjno				varchar(20)		Not NULL,   --��Ŀ��� 
	prjname				varchar(50)		NULL    ,   --��Ŀ���
	prjtype				varchar(5)		NULL    ,   --��Ŀ���
	prjpricetype		int 			NULL	,   ---��Ŀ���--�����������  1���� 2С��
	prjreporttype		varchar(10)		NULL    ,   --ͳ�Ʒ��� 
	saleunit			varchar(5)		NULL    ,   --�Ƽ۵�λ
	saleprice			float			NULL    ,   --��׼�۸�
	msalecount			float			NULL,       -- �۸�1����,��
	msaleprice			float			NULL,       -- �۸�1���,��
	rsalecount			float			NULL,       -- �۸�2����,����
	rsaleprice			float			NULL,       -- �۸�2���,����
	hsalecount			float			NULL,       -- �۸�3����,����
	hsaleprice			float			NULL,       -- �۸�3���,����
	ysalecount			float			NULL,       -- �۸�4����,��
	ysaleprice			float			NULL,       -- �۸�4���,��
	onecountprice		float			NULL,		--���μ�
	onepageprice		float			NULL,		--����۸�(ɢ�ͼ�)
	memberprice		    float			NULL,		--����۸�(��Ա��)
	salelowprice		float			NULL,		--��ͼ�
	needhairflag		int				NULL,		--�Ƿ���Ҫϴͷ��	 1��  2��
	useflag				int				NULL,		--���ñ�־			 1���� 2ͣ��
	saleflag			int				NULL,		--�����Ƿ�����   1��  2��
	rateflag			int				NULL,		--�����Ƿ����		 1��  2��
	prjsaletype			int				NULL,		--�Ƿ����Ƴ�		 1��  2��
	editflag			int				NULL,		-- �ɷ�༭�۸�		 1��  2��
	pointtype			int				NULL,		-- ���ַ�ʽ
	pointvalue			float			NULL,       -- ���ֻ����
	costtype			int				NULL,		-- ��Ŀ�Ƿ�����ֽ�֧����1Ϊ�����ֽ�֧����0Ϊδ��
	costprice			float			NULL,       -- �ɱ�
	kyjrate				float			NULL,       -- ҵ������
	ktcrate				float			NULL,       -- ���ʱ���
	lyjrate				float			NULL,       -- �Ƴ�ҵ������
	ltcrate				float			NULL,       -- �Ƴ̹��ʱ���
	finaltype			int				NULL,       -- ��������  0 ���� 1����
	prisource			varchar(10)		Not  NULL,	--��Ŀ��Դ
	prjabridge			varchar(10)		NULL,		--��Ŀ��д
	newcosttc			float			NULL,		--�¿������
	oldcosttc			float			NULL,		--�Ͽ������
	markflag			int				NULL,		--�Ƴ̶һ��Ƿ���Ҫ��ע
	morelongflag			int				NULL,       --  �Ƿ��г�����
	ipadname varchar(50)		null,				--ipad��ʾ����
	CONSTRAINT PK_projectinfo PRIMARY KEY CLUSTERED(prjmodeId,prjno,prisource)
)
go
CREATE NONCLUSTERED index idx_projectinfo_prjno on projectinfo(prjno)



---------------------------------------
-----goodsinfo   ��Ʒ���� CREATE by liujie 20130708
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='goodsinfo')
CREATE tAbLE    goodsinfo               -- ��Ʒ���ϵ�
(
	goodsmodeid			varchar(10)     Not NULL,   -- ��Ʒģ����
	goodsno				varchar(20)		Not NULL,   -- ��Ʒ���
	goodsuniquebar		varchar(10)		NULL,       --Ψһ��ǰ׺
	goodsbarno			varchar(100)		NULL,       -- ������
	goodsname			varchar(80)		NULL,       -- ��Ʒ����
	CREATEdate			varchar(8)		NULL,       -- ��������
	goodstype			varchar(5)		NULL,       -- ��Ʒ����
	goodspricetype		varchar(10)		NULL,		-- ͳ�Ʒ��� 
	goodsappsource		int				NULL,		-- 0��ʱ���ǲֿ� 1--�ǹ�Ӧ��
	goodswarehouse		varchar(10)		NULL,		-- ֱ�����Ĳֿ���
	goodssupplier		varchar(5)		NULL,       -- ��Ʒ��Ӧ��
	costunit			varchar(5)		NULL,       -- ���ĵ�λ
	saleunit			varchar(5)		NULL,       -- ���۵�λ(��׼��λ)	
	purchaseunit		varchar(5)		NULL,		-- ������λ
	goodsformat			varchar(20)		NULL,       -- ��Ʒ���
	saletocostcount		float			NULL,       -- ���۵�λ��Ӧ���ĵ�λ����
	purtocostcount		float			NULL,       -- ������λ��Ӧ���۵�λ����
	purchaseprice		float			NULL,       -- ��Ʒ����(��׼��λ)	--�ܲ�������(���)
	costamtbysale		float			NULL,       -- ���۳ɱ�(��׼��λ)   --�ŵ������(�ܲ�����/����)
	standprice			float			NULL,       -- ��׼�۸�(���۵�λ)
	storesalseprice		float			NULL,       -- �ܲ������ŵ�۸�		--�ŵ����۹˿ͼ�
	shelflife			int				NULL,       -- ������
	lowstock			float			NULL,       -- ��ȫ����(��׼��λ)
	heightstock			float			NULL,       -- ��ߴ���		
	appflag				int				NULL,       -- �Ƿ������ɹ�
	useflag				int				NULL,       -- �Ƿ�ͣ��
	goodsusetype		int				NULL,       -- ��Ʒʹ������ 1��Ʒ  2����Ʒ
    stopdate			varchar(8)		NULL,       -- ֹͣ�ɹ�����
	stopmark			varchar(100)	NULL,		-- ֹͣ�ɹ�ԭ��	 
	pointtype			int				NULL,       -- ���ַ�ʽ
	pointvalue			float			NULL,       -- ���ֻ����
	yetype				int				NULL,       -- ҵ����ʽ
	yevalue				float			NULL,       -- �������
	tctype				int				NULL,       -- ��ɷ�ʽ
	tcvalue				float			NULL,       -- �������
	finaltype			int				NULL,       -- ��������  0 ���� 1����
	goodssource			varchar(10)		Not NULL,		-- ��Ʒ��Դ
	goodsabridge		varchar(10)		NULL,		--��Ʒ��д
	minordercount		float NULL					--��С������
	bindgoodsno			varchar(50)		NULL,		--��Ӧ�̰󶨲�Ʒ���
	enablecompany 		varchar(1) 		NULL		--�Ƿ����òɹ��ŵ�����
    goodscompany 		varchar(200) 	NULL		--�����ɹ��ŵ�
    enablebarcode 		varchar(1) 		NULL		--�Ƿ���������У��
	CONSTRAINT PK_goodsinfo PRIMARY KEY CLUSTERED(goodsmodeid,goodsno,goodssource)
)



go
if not exists(select 1 from sysobjects where type='U' and name='goodsnameinfo')
CREATE tAbLE    goodsnameinfo
(
	goodsno					varchar(20)		Not NULL,		--��Ʒ��� 
	goodsbarno				varchar(40)			NULL    ,   --������
	goodsname				varchar(80)			NULL    ,   --��Ʒ����
	goodstype				varchar(5) 			NULL	,   --��Ʒ����
	goodspricetype			varchar(5)			NULL    ,   --ͳ�Ʒ���
	maxbarcode				varchar(20)			NULL,		--��Ʒ������� 
	CONSTRAINT PK_goodsnameinfo PRIMARY KEY CLUSTERED(goodsno)
)



if not exists(select 1 from sysobjects where type='U' and name='projectnameinfo')
CREATE tAbLE    projectnameinfo
(
	prjno				varchar(20)		Not NULL,   --��Ŀ��� 
	prjname				varchar(50)		NULL    ,   --��Ŀ���
	prjtype				varchar(5)		NULL    ,   --��Ŀ���
	prjpricetype		int 			NULL	,   ---��Ŀ���--�����������  1���� 2С��
	prjreporttype		varchar(10)		NULL    ,   --ͳ�Ʒ��� 
	CONSTRAINT PK_projectnameinfo PRIMARY KEY CLUSTERED(prjno)
)


if not exists(select 1 from sysobjects where type='U' and name='cardtypenameinfo')
CREATE tAbLE    cardtypenameinfo
(
	cardtypeno			varchar(10)		Not NULL,   --������
	cardtypename		varchar(30)		NULL       --������� 
)

---------------------------------------
-----cardtypeinfo   ��Ա������趨 CREATE by liujie 20130708
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='cardtypeinfo')
CREATE tAbLE    cardtypeinfo               -- 
(
	cardtypemodeid		varchar(10)     Not NULL,   -- ���ģ����
	cardtypeno			varchar(10)		Not NULL,   --������
	cardtypename		varchar(30)		NULL    ,   --������� 
	cardusetype			int				NULL    ,   --����(1-��ֵ��, 2- �ʸ�,3-�ƴο�,4-���ο�)
	cardchiptype		int				NULL    ,   --���������� 0�ſ� 1Ic����
	carduselife			float			NULL    ,   --��Ч����
	cardsaleprice		float			NULL    ,   --��׼�ۼ�
	cardcost			float			NULL    ,   --�ɱ�
	saletctype			int				NULL    ,   --��������ɷ�ʽ
	saletcvalue			float			NULL    ,   --�����۽������	
	saleyjtype			int				NULL    ,   --������ҵ����ʽ
	saleyjvalue			float			NULL    ,   --�����۽������
	fillyjtype			int				NULL    ,   --����ֵҵ����ʽ
	fillyjvalue			float			NULL    ,   --����ֵ�������
	filltctype			int				NULL    ,   --����ֵ��ɷ�ʽ
	filltcvalue			float			NULL    ,   --����ֵ�������
	pointtype			int				NULL    ,   --���ͻ��ֵķ�ʽ
	prjpointvalue		float			NULL    ,   --��Ŀ���ѻ����������
	goodspointvalue		float			NULL    ,   --��Ʒ���ѻ����������
	lowfillamt			float			NULL    ,   --��ͳ�ֵ���
	lowopenamt			float			NULL    ,   --�򿨵�ʱ����ͳ�ֵ���
	salegoodsflag		int  			NULL    ,   --�Ƿ���Թ�����Ʒ1:'��',0:'��'
	slaeproerate		float  			NULL    ,   --�����Ƴ��ۿ�
	slaegoodsrate		float  			NULL    ,   --�����Ʒ�ۿ�
	changerule			int	  			NULL    ,   --ת������ 1:'��׼ת��',0:'���ת��' 
	openflag			int				NULL default(1), --�������� 1:'��',0:'��'
    fillflag			int				NULL default(1),  -- ������ֵ 1:'��',0:'��'
    changeflag			int				NULL default(1), --����ת�� 1:'��',0:'��'
    finaltype			int				NULL,       -- ��������  0 ���� 1����
    cardtypesource		varchar(10)		Not NULL,		--��������Դ
    sendamtflag			int				NULL default(0), --�Ƿ����Ϳ��� 1:'��',0:'��'
	CONSTRAINT PK_cardtypeinfo PRIMARY KEY CLUSTERED(cardtypemodeid,cardtypeno,cardtypesource)
)
go 


---------------------------------------
-----cardchangerule   ת������ CREATE by liujie 20130708
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='cardchangerule')
CREATE table cardchangerule
(
	rulemodeid		varchar(10)         not null, --���ģ����
	cardtypeno		varchar(20)			not null, --��Ա�����
	seqno			float				not null, --���
	tocardtypeno	varchar(20)			null,     --ת�����
	changeamt		float				null,     --ת����ͽ��
	cardtypesource	varchar(10)		NULL,		--��������Դ
	CONSTRAINT	PK_cardchangerule PRIMARY key CLUSTERED(rulemodeid,cardtypeno,seqno)
)
go

---------------------------------------
-----cardchangecostrate   ��Ա�������ۿ� CREATE by liujie 20130708
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='cardchangecostrate')
CREATE table cardchangecostrate
(
	compid				varchar(10)					not null,		--�ŵ���
	projecttypeid		varchar(10)					not null,		--��Ŀ����
	cardtypeno			varchar(10)					not null,		--�����ͱ��
	acounttypeno		varchar(10)					not null,		--�˻����ͱ��
	startdate			varchar(8)						null,		--��ʼ����
	enddate				varchar(8)						null,		--��������
	costrate			float(10)						null,		--��Ŀ�ۿ�
	CONSTRAINT	PK_cardchangecostrate PRIMARY key CLUSTERED(compid,projecttypeid,cardtypeno,acounttypeno)
)
go


if not exists(select 1 from sysobjects where type='U' and name='cardratetocostrate')
CREATE table cardratetocostrate
(
	compid				varchar(10)					not null,		--�ŵ���
	projecttypeid		varchar(10)					not null,		--��Ŀ����
	startdate			varchar(8)						null,		--��ʼ����
	enddate				varchar(8)						null,		--��������
	costrate			float(10)						null,		--��Ŀ�����ۿ�
	changerate			float(10)						null,		--��Ŀ�����ۿ�
	CONSTRAINT	PK_cardratetocostrate PRIMARY key CLUSTERED(compid,projecttypeid)
)
go

---------------------------------------
-----cardcostgoodsrate   ��Ա�������ۿ� CREATE by liujie 20130708
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='cardcostgoodsrate')
CREATE table cardcostgoodsrate
(
	compid				varchar(10)					not null,		--�ŵ���
	goodstypeid		varchar(10)					not null,		--��Ŀ����
	cardtypeno			varchar(10)					not null,		--�����ͱ��
	acounttypeno		varchar(10)					not null,		--�˻����ͱ��
	startdate			varchar(8)						null,		--��ʼ����
	enddate				varchar(8)						null,		--��������
	costrate			float(10)						null,		--��Ŀ�ۿ�
	CONSTRAINT	PK_cardcostgoodsrate PRIMARY key CLUSTERED(compid,goodstypeid,cardtypeno,acounttypeno)
)
go



---------------------------------------
-----sysparaminfo   ϵͳ���� CREATE by liujie 20130708
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='sysparaminfo')
CREATE table sysparaminfo
(
	compid			varchar(10)			not null, --�ŵ��
	paramid			varchar(10)			not null, --�������
	paramname		varchar(100)		null,	  --����ֵ
	paramvalue		varchar(100)		null,	  --����ֵ
	parammark		varchar(50)			null,	  --����ֵ��ע
	CONSTRAINT	PK_sysparaminfo PRIMARY key CLUSTERED(compid,paramid)
)
go

---------------------------------------
-----supplierinfo   ��Ӧ�̻������� CREATE by liujie 20130708
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='supplierinfo')
CREATE tAbLE supplierinfo   --��Ӧ�̻�������
(
   supplierid			varchar(20)			Not NULL,--��Ӧ��ID
   suppliername			varchar(40)			NULL,--��Ӧ������
   suppliersname		varchar(30)			NULL,--��Ӧ�̼��
   supplierphone		varchar(20)			NULL,--�绰
   supplierfex			varchar(20)			NULL,--����
   supplieremail		varchar(20)			NULL,--�����ʼ�
   supplierurl			varchar(20)			NULL,--��ҳ
   supplieraddress      varchar(80)			NULL,--��Ӧ�̷�Ʊ��ַ
   supplierpos			varchar(20)			NULL,--��������
   supplierremark		varchar(40)			NULL,--��Ӧ�̱�ע 
   miantoucher			varchar(40)			NULL,--��Ҫ��ϵ������
   supplierpassword     varchar(40)			NULL,--��Ӧ������
   suppliermobilephone 	varchar(20)  		NULL,--�ֻ�����
   supplierstate   		int  				NULL,--0.û�к�����1���ں���
   CONSTRAINT PK_supplierinfo PRIMARY KEY CLUSTERED(supplierid)
)
go

---------------------------------------
-----promotionsinfo   �ŵ�����趨 CREATE by liujie 20130708
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='promotionsinfo')
CREATE tAbLE    promotionsinfo             -- 
(
	compid				varchar(10)   Not NULL,			--��˾���
    billid				varchar(20)   Not NULL,			--����
	promotionstype		int			  NULL,				--��Ŀ������Ŀ��ʶ��1-��Ŀ���ۣ�2-������� 3��ֵ��� ,4-����������� 5������ֵ��� 
														--6 �����ۿ�ϵ��		7 �һ��ۿ�ϵ��	
	promotionscode		varchar(20)   NULL,				--��Ŀ��Ż����ͻ򿨺�
    promotionsstore		varchar(10)   NULL,				--�����ŵ�
    promotionsvalue		float		  NULL,				--�����۸�
	startdate			varchar(10)   NULL,				--�ۿۿ�ʼ����
	enddate				varchar(10)   NULL,				--�ۿ۽�ֹ����
    promotionsreason	varchar(200)  NULL,				--����ԭ��
	promotionsstate		int			  NULL,				--�Ƿ���ˣ�0-û��ˣ�1-�����    
	promotionsempid		varchar(10)	  NULL,				--����˱���
	promotionsdate		varchar(10)   NULL,				--�������
	invalid				int			  NULl,				--�Ƿ����� 0 δ����  1 ������
	CONSTRAINT PK_promotionsinfo PRIMARY KEY CLUSTERED(compid,billid)
)	
go
CREATE NONCLUSTERED index idx_promotionsinfo_promotionstype on promotionsinfo(promotionstype,promotionscode)



---------------------------------------
-----syscommoninfomode ������Ϣģ��    CREATE by liujie 20130708
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='syscommoninfomode')
CREATE tAbLE    syscommoninfomode             -- 
(
	modeid				varchar(10)   Not NULL,			--ģ����
    modetype			int			  Not NULL,			--ģ������   1 ��Ŀģ��  2��Ʒģ��  3��Ա������ģ�� 4н��ģ��
	modename 			varchar(40)	  NULL,				--ģ������
	modesource			varchar(20)   NULL,				--ģ�����
    parentmodeid		varchar(10)	  NULL,				--�̳�ģ����
    CREATEdate			varchar(10)	  NULL,				--��ģ����
    CREATEemp			varchar(20)	  NULL,				--��ģԱ��
    invalid				int			  NULl,				--�Ƿ����� 0 δ����  1 ������
	CONSTRAINT PK_syscommoninfomode PRIMARY KEY CLUSTERED(modeid,modetype)
)	
go

---------------------------------------
-----mcardnoinsert ��Ա����ⵥ����
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='mcardnoinsert')
CREATE table mcardnoinsert
(
	cinsertcompid			varchar(10)		not null,	--��⹫˾
	cinsertbillid			varchar(20)		not null,	--��ⵥ��
	cinsertdate				varchar(8)      null,		--�������
	cinserttime				varchar(8)      null,		--�������
	cinsertware				varchar(10)     null,		--���ֿ�
	CREATEcompname			varchar(60)     null,		--��������˾
	checkoutflag			int				null, --�Ƿ���� 0--û�н��� 1--����
	billflag				int				null, --�Ƿ�Ʊ 0--����Ҫ��Ʊ 1--��Ҫ��Ʊ
	billno					varchar(50)     null, --��Ʊ���
	checkoutmark			varchar(120)    null, --���ʱ�ע
	checkoutimgurl			varchar(120)    null, --����ͼƬ��ַ
	reportimage				image           NULL,   --������Ƭ
	cinsertper				varchar(20)     null,		--�����
	optionconfrimdate		varchar(10)     null, --��������
	optionconfrimper		varchar(20)     null, --������
	optioncanceldate		varchar(10)     null, --ȡ����������
	optioncancelper			varchar(20)     null, --ȡ��������
	invalid					int				null, --�Ƿ����� 0 ���� 1 ����
	CONSTRAINT	PK_mcardnoinsert PRIMARY key CLUSTERED(cinsertcompid,cinsertbillid)
)
go


---------------------------------------
-----mcardnoinsert ��Ա����ⵥ��ϸ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dcardnoinsert')
CREATE table dcardnoinsert
(
	cinsertcompid   varchar(10)		not null, --��⹫˾
	cinsertbillid	varchar(20)		not null, --��ⵥ��
	seqno			float			not null, --��ˮ��
	cardtypeid		varchar(10)     null, --�����
	cardnofrom		varchar(20)     null, --�����뿪ʼ����
	cardnoto		varchar(20)     null, --�������������
	cardnum			float			null, --������
	cardprice		float			null, --������
	cardamt			float			null, --�����
	CONSTRAINT	PK_dcardnoinsert PRIMARY key CLUSTERED(cinsertcompid,cinsertbillid,seqno)	
)
go



---------------------------------------
-----cardstock ��Ա���Ŷο��
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='cardstock')
CREATE table cardstock
(
	rid				int identity(1,1)		not null,
	cardclass		varchar(10)				null,	-- �����
	cardfrom		varchar(20)				null,	-- ��ʼ����
	cardto			varchar(20)				null,	-- ��ֹ����
	ccount			float					null,	-- �÷�Χ�ڿ�����
	storage			varchar(10)				null,	-- �ֿ���
	compid			varchar(10)				null,   -- ��˾���
	CONSTRAINT PK_cardstock PRIMARY key CLUSTERED(rid)
)
go


---------------------------------------
-----cardstockchange ��Ա����������ʷ 
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='cardstockchange')
CREATE table cardstockchange          --��Ա��������춯ͳ����ϸ��(�����춯������ϸ update) 
(
	changecompid		varchar(10)			Not NULL,		-- ��ݱ�       
	changetype			varchar(2)			Not NULL,		-- �춯�� (1-���,2-����)                     
	changebill			varchar(20)			Not NULL,		-- �춯����     
	changeseqno			float				Not NULL,		-- ������ˮ��       
	cardtype			varchar(30)				NULL,   	-- ��Ա�����     
	changecardfromno	varchar(20)				NULL,       -- ��Ա����ʼ����     
	changecardtono		varchar(20)				NULL,       -- ��Ա����������              
	changecount			float			  		NULL,       -- ��Ա����        
	changeprice			float			  		NULL,       -- ��Ա����    
	changeamt			float			  		NULL,       -- ��Ա���       
	changedate			varchar(8)				NULL,		-- ����
	changeware			varchar(10)				NULL,      	--�ֿ���
	CONSTRAINT PK_cardstockchange PRIMARY KEY CLUSTERED (changecompid, changetype, changebill, changeseqno)
)
go

---------------------------------------
-----mcardapponline ���߿���������
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='mcardapponline')
CREATE table mcardapponline
(
	cappcompid				varchar(10)		not null ,--���빫˾
	cappcompbillid			varchar(20)		not null, --���뵥��
	cappdate				varchar(8)		null,     --��������
	capptime				varchar(6)		null,     --����ʱ��
	cappempid				varchar(20)		null,     --������
	cappbillflag			int				null,     --���̱�־  0--������ 1--�ܲ�ͬ�� 2--�Ѿ�����
	cappopationper			varchar(20)		null,     --������
	cappopationdate			varchar(8)		null,	  --��������
	cappconfirmper			varchar(20)		null,     --�ܲ�������
	cappconfirmdate			varchar(8)		null,     --�ܲ���������
	cappconfirmcompid		varchar(10)		null,     --��˹�˾
	invalid					int				null,	  --�Ƿ����� 0 ���� 1 ����
	CONSTRAINT	PK_mcardapponline PRIMARY key CLUSTERED(cappcompid,cappcompbillid)
)
go

---------------------------------------
-----dcardapponline ���߿�������ϸ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dcardapponline')
CREATE table dcardapponline
(
	cappcompid			varchar(10)  not null ,--���빫˾
	cappcompbillid		varchar(20)  not null, --���뵥��
	cappseqno			float	     not null, --��ˮ��
	cappcardtypeid		varchar(10)  null,     --������
	cappcount			float		 null,     --����
	CONSTRAINT	PK_dcardapponline PRIMARY key CLUSTERED(cappcompid,cappcompbillid,cappseqno)
)
go

---------------------------------------
-----mcardallotment ���߿��䷢����
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='mcardallotment')
CREATE table mcardallotment
(
	callotcompid			varchar(10)		not null ,--��˾���
	callotbillid			varchar(20)		not null, --����
	callotdate				varchar(8)		null,     --�䷢����
	callottime				varchar(6)		null,     --�䷢ʱ��
	callotempid				varchar(20)		null,     --�䷢��
	recevieempid			varchar(20)		null,     --������
	callotopationempid		varchar(20)		null,     --������
	callotopationdate		varchar(8)		null,	  --��������
	checkoutflag			int 			null,     --�Ƿ����
	checkoutdate			varchar(8)		null,     --��������
	checkoutemp				varchar(20)		null,     --������Ա
	cappbillid				varchar(20)		null,     --���뵥��
	cappcompid				varchar(10)		null,     --���뵥��˾
	callotwareid			varchar(10)		null,     --����ֿ���
	invalid					int				null,		--�Ƿ����� 0 ���� 1 ����
	CONSTRAINT	PK_mcardallotment PRIMARY key CLUSTERED(callotcompid,callotbillid)
)
go


---------------------------------------
-----dcardallotment ���߿��䷢��ϸ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dcardallotment')
CREATE table dcardallotment
(
	callotcompid	varchar(10)		not null ,	--���ù�˾
	callotbillid	varchar(20)		not null,	--���õ���
	callotseqno		float			not null,	--��ˮ��
	cardtypeid		varchar(10)			null,	--�����
	cardnofrom		varchar(20)			null,	--�����뿪ʼ����
	cardnoto		varchar(20)			null,	--�������������
	ccount			float				null,	-- �÷�Χ�ڿ���������
	allotcount		float				null,	-- �䷢����
	CONSTRAINT	PK_dcardallotment PRIMARY key CLUSTERED(callotcompid,callotbillid,callotseqno)
)

go


---------------------------------------
-----sysoperationlog ϵͳ������־
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='sysoperationlog')
CREATE table    sysoperationlog        
(
		log_id      int IDENtItY(1,1),
		
		userid          varchar(10)     Not NULL,			--User ID    
		program         varchar(10)     Not NULL ,			--��ʽ����
		operation       varchar(1)      Not NULL,			--���� 
		operationdate   varchar(8)      Not NULL,           --�춯����
		operationtime   varchar(8)      Not NULL,           --�춯ʱ��
		origatedate     varchar(8)			NULL,           --������ҵʱ��.
		compid          varchar(10)			 NULL,			--company ID  
		keyvalue1       varchar(20)         NULL,
		keyvalue2       varchar(20)         NULL,
		keyvalue3       varchar(20)         NULL,
		keyvalue4       varchar(20)         NULL,
		CONSTRAINT PK_sysoperationlog_id PRIMARY KEY (log_id)
)

---------------------------------------
-----sysaccountforpaymode ϵͳ�˻���֧��
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='sysaccountforpaymode')
CREATE table sysaccountforpaymode(
	paymode			varchar(5)  Not NULL, -- ֧����ʽ
	accounttype		varchar(5)      NULL, -- �˻�
	CONSTRAINT PK_sysaccountforpaymode PRIMARY KEY CLUSTERED(paymode)
)
go



---------------------------------------
----cardinfo----- ��Ա����������
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='cardinfo')
CREATE tAbLE    cardinfo              
(
	cardvesting			varchar(10)     Not NULL,   --�������ŵ� 
	cardno				varchar(20)		Not NULL,	--���� 
	cardtype			varchar(10)		NULL,		--����(��Ա������趨) 
	membernotocard		varchar(20)		NULL    ,   --��Ա���
	salecarddate		varchar(8)		NULL    ,   --�ۿ�����
	cutoffdate			varchar(8)		NULL    ,   --��ֹ��Ч����
	cardstate			int				NULL    ,   --״̬(δ����, ����δ����, ����ʹ����, ��ʧת��,Խ�ڿ����� , Խ�����Ͽ�)
	salebillno			varchar(20)		NULL    ,   --���۵���
	costpassword		varchar(10)		NULL    ,   --��������
	searchpassword		varchar(10)		NULL    ,   --��ѯ����
	cardremark			varchar(180)	NULL    ,   --��ע
	cardsource			int				NULL    ,   --������Դ 0--����˾�Ŀ� 1--�չ���
	costcountbydebts	int				NULL    ,   --�����Ƿ���ʱ�� ����λ��ʾ�����������Ѽ���
	costamtbydebts		float			NULL    ,   --�����Ƿ���ʱ�� ����λ��ʾ���������ѵĽ��
	costamt				float			NUll	,	--Ƿ��ʣ�����Ѷ��
	CONSTRAINT PK_cardinfo PRIMARY KEY CLUSTERED(cardvesting,cardno)
)
go
CREATE NONCLUSTERED index idx_cardinfo_cardno on cardinfo(cardno)
go


CREATE table cardsoninfo
(
	cardvesting			varchar(10)			Not NULL,   --�������ŵ� 
	cardno				varchar(20)			Not NULL,	--���� 
	cardtype			varchar(10)			NULL,		--����(��Ա������趨) 
	salecarddate		varchar(8)			NULL    ,   --�ۿ�����
	parentcardno		varchar(20)			NULL,		--������ 
	membername			varchar(20)			NULL,		--�ӿ�����
	memberphone			varchar(20)			NULL,		--�ӿ��ֻ�����
	salebillno			varchar(20)			NULL,		--���۵���
	saleamt				float				NULL,		--���۽��
	songfalg			varchar(10)			NULL,		--�ӿ���ʾ
	CONSTRAINT PK_cardsoninfo PRIMARY KEY CLUSTERED(cardvesting,cardno)
)
go
CREATE NONCLUSTERED index idx_cardsoninfo_cardno on cardsoninfo(cardno)
go
CREATE NONCLUSTERED index idx_cardsoninfo_parentcardno on cardsoninfo(parentcardno)
go



CREATE table cardspecialcost
(
	cardno				varchar(20)			Not NULL,	--���� 
	costxc1				float				NULL	,	--���ʦϴ��
	costxc2				float				NULL    ,   --��ϯϴ��
	costxc3				float				NULL,		--�ܼ�ϴ�� 
	costxc4				float				NULL,		--�����ܼ�ϴ��
	costxc5				float				NULL,		--���ʦϴ��
	costxc6				float				NULL,		--��ϯϴ����
	costxc7				float				NULL,		--�ܼ�ϴ����
	costxc8				float				NULL,		--�����ܼ�ϴ����
	costxc9				float				NULL,		--�곤ϴ����
	CONSTRAINT PK_cardspecialcost PRIMARY KEY CLUSTERED(cardno)
)
go
CREATE NONCLUSTERED index idx_cardsoninfo_cardno on cardsoninfo(cardno)
go
CREATE NONCLUSTERED index idx_cardsoninfo_parentcardno on cardsoninfo(parentcardno)
go
---------------------------------------
----memberinfo----- ��Ա������������
---------------------------------------


if not exists(select 1 from sysobjects where type='U' and name='memberinfo')
CREATE tAbLE    memberinfo              
(
	membervesting			varchar(10)     Not NULL,		-- ��˾���
	memberno				varchar(20)		Not NULL,		-- ��Ա���
	membercreatedate		varchar(8)			NULL,		-- ������������
	membername				varchar(40)			NULL,		-- ��Ա����
	memberaddress			varchar(160)		NULL,		-- address
	membertphone			varchar(20)			NULL,		-- ��ͥtele No.
	membermphone			varchar(20)			NULL,		-- Mobile No.
	memberFax				varchar(20)			NULL,		-- Fax No.-1
	memberemail				varchar(40)			NULL,       -- E-Mail��ַ
	memberzip				varchar(6)			NULL,       -- �ʱ�
	membersex				int					NULL,       -- �Ա�(0- female, 1- male )
	memberpaperworkno		varchar(20)			NULL    ,   -- ֤����� 
	memberbirthday			varchar(8)			NULL    ,   -- ��������
	memberjob				varchar(30)			NULL    ,   -- ְҵ
	cardnotomemberno		varchar(20)			NULL    ,   -- ��Ա����
	memberqqno				varchar(20)			NULL	,   -- QQ����
	membermsnno				varchar(60)			NULL	,   -- MsN����
	membertype				varchar(2)			NULL	,   --��Ա���
	weixinno				varchar(20) NULL,
	autopassword			varchar(20) NULL,
	issendmsg			int	    null,				   --�Ƿ��Ͷ�Ϣ		
	CONSTRAINT PK_memberinfo PRIMARY KEY CLUSTERED(membervesting,memberno)
)
go
CREATE NONCLUSTERED index idx_memberinfo_memberno on memberinfo(memberno)
CREATE NONCLUSTERED index idx_memberinfo_cardnotomemberno on memberinfo(cardnotomemberno)
go
--��Ա�����޸ı�
if not exists(select 1 from sysobjects where type='U' and name='memberinfoedit')
CREATE tAbLE    memberinfoedit              
(
	seqno			int identity(1,1)	Not NULL,
	memberno				varchar(20)		Not NULL,		-- ��Ա���
	membername				varchar(40)			NULL,		-- ��Ա����
	membermphone			varchar(20)			NULL,		-- Mobile No.
	memberpaperworkno		varchar(20)			NULL    ,   -- ֤����� 
	memberbirthday			varchar(8)			NULL    ,   -- ��������
	edituserno				varchar(20)			NULL	,	-- �޸���
	editusername			varchar(30)			NULL	,	-- �޸���
	editdate				varchar(10)			NULL	,	-- �޸�����
	edittime				varchar(10)			NULL	,	-- �޸�ʱ��
)
go


---------------------------------------
----cardaccount--- ��Ա��--�ʻ�
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='cardaccount')
CREATE tAbLE    cardaccount               
(
	cardvesting			varchar(10)     Not NULL,   --�������ŵ�
	cardno				varchar(20)		Not NULL,	--���� 
	accounttype			int				Not NULL,   --�ʺ����(��������)
	accountbalance		float			NULL	,	--�˻����
	accountdebts		float           NULL,		--�ʻ�Ƿ��
	accountdatefrom		varchar(20)     NULL,		--�˺ſ�������
	accountdateend		varchar(20)     NULL,		--�˺Ž�������
	accountremark		varchar(60)     NULL,		--�˺ű�ע
	CONSTRAINT PK_cardaccount PRIMARY KEY CLUSTERED(cardvesting,cardno,accounttype)
)
go
CREATE NONCLUSTERED index idx_cardaccount_cardno on cardaccount(cardno)
go


---------------------------------------
----cardproaccount--- ��Ա���Ƴ��ʻ�
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='cardproaccount')
CREATE tAbLE    cardproaccount               -- ��Ա��--�Ƴ�
(
	cardvesting			varchar(10)     Not NULL,   --�������ŵ� 
	cardno				varchar(20)		Not NULL,   --���� 
	projectno			varchar(20)		Not NULL,   --�Ƴ̱��
	proseqno			float			Not NULL,   --�Ƴ����
	propricetype		int					NULL,   --�Ƴ�����
	salecount			float				NULl,	--�����ܴ���
	costcount			float				NULL,   --�Ѿ�ʹ�ô���
	lastcount			float				NULL,   --ʣ�����
	saleamt				float				NULL,   --�Ƴ̽��
	costamt				float				NULL,   --�Ѿ�ʹ�ý��
	lastamt				float				NULL,   --ʣ����
	saledate			varchar(8)			NULL,   --�˻�������
	cutoffdate			varchar(8)			NULL,   --�˻�������
	proremark			varchar(60)			NULL,   --�Ƴ̱�ע
	prostopeflag		int					NULL,   --�Ƿ�ͣ��
	exchangeseqno		float				null,	--�Ƴ̶һ����
	changecompid		varchar(10)			NULL,   --�һ��ŵ� 
	changebillid		varchar(20)			NULL,   --�һ�����
	createbilltype		varchar(10)			NULL,   --�����ŵ�
	createbillno		varchar(20)			NULL,   --���ɵ���
	createseqno			float				NULL,
	yearsz				int 				NULL,	--��Դ���� 1�����ͣ�0������
	activinid			varchar(50)			NULL	--�����Ƴ̻Ψһ���
	CONSTRAINT PK_cardproaccount PRIMARY KEY CLUSTERED(cardvesting,cardno,projectno,proseqno)
)
go
CREATE NONCLUSTERED index idx_cardproaccount_cardno on cardproaccount(cardno)
go
CREATE NONCLUSTERED index idx_cardproaccount_createbill on cardproaccount(cardno,createbillno,createbilltype)
go


---------------------------------------
----cardchangehistory--- ��Ա���춯��ʷ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='cardchangehistory')
CREATE tAbLE    cardchangehistory             
(
	changecompid		varchar(10)     Not NULL,   --�춯 �ŵ�
	changecardno		varchar(20)		Not NULL,   --�춯���� 
	changeseqno			float			Not NULL,   --�춯���
	changetype			int					NULL    ,   --�춯����(2- ����, 3-ת��, 4- ���� ,5-�˿�) 
	changebillid		varchar(20)			NULL    ,   --�춯���� 
	beforestate			int					NULL    ,   --�춯ǰ״̬  
	afterstate			int					NULL    ,   --�춯��״̬
	chagedate			varchar(8)			NULL    ,   --�춯����
	targetcardno		varchar(20)			NULL    ,   --��Ӧ����
	CONSTRAINT PK_cardchangehistory PRIMARY KEY CLUSTERED(changecompid,changecardno,changeseqno)
)
go 
CREATE NONCLUSTERED index idx_cardchangehistory_changecardno on cardchangehistory(changecardno)
go




---------------------------------------
----cardaccountchangehistory--- ��Ա���˻���ʷ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='cardaccountchangehistory')
CREATE tAbLE    cardaccountchangehistory     
(
	changecompid		varchar(10)     Not NULL,   --��˾��� 
	changecardno		varchar(20)		Not NULL,   --���� 
	changeaccounttype	int				Not NULL,   --�ʺ����(1-����Ǯ�� , 2-��ֵ�ʺ�)
	changeseqno			int				Not NULL,   --�ʺ����
	changetype			int             NULL,   --�춯���(0- ��ֵ ,1-ȡ�� 2-���� ,3-ת��, 4-ת��)
	changeamt			float           NULL,   --�춯���
	changebilltype		varchar(5)      NULL,   --�춯�������
	changebillno		varchar(20)     NULL,   --�춯����
	chagedate			varchar(8)      NULL,   --�춯����
	changebeforeamt		float			NULL,   --ǰ�����
	changemark			varchar(200)	NULL,	--�޸ı�ע
	CONSTRAINT PK_cardaccountchangehistory PRIMARY KEY CLUSTERED(changecompid,changecardno,changeaccounttype,changeseqno)
)
go
CREATE NONCLUSTERED index idx_cardaccountchangehistory_changecardno on cardaccountchangehistory(changecardno)
go

---------------------------------------
----cardtransactionhistory--- ��Ա��������ʷ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='cardtransactionhistory')
CREATE tAbLE    cardtransactionhistory             
(
	transactioncompid		varchar(10)			Not NULL,   --���ױ�� 
	transactionseqno		int identity		Not NULL,   --������� 
	transactioncardno		varchar(20)				NULL,   --���� 
	transactiondate			varchar(8 )				NULL,   --����
	transactiontype			varchar(10)				NULL,   --��������--1-������ 2-�Ƴ����� 3-��Ŀ 4-��Ʒ���� - 5����ֵ - 6�Ƴ̳�ֵ
	codeno					varchar(20)				NULL,   --����
	codename				varchar(50)				NULL,   --����
	ccount					float					NULL,   --����
	price					float					NULL,   --�۸�
	billtype				varchar(10)				NULL,   --�������
	billno					varchar(20)				NULL,   --���ݵ���
	firstempid				varchar(20)				NULL,   --Ա��1
	secondempid				varchar(20)				NULL,   --Ա��2
	thirthempid				varchar(20)				NULL,   --Ա��3
	paymode					varchar(10)				NULL,   --֧����ʽ
	CONSTRAINT PK_cardtransactionhistory PRIMARY KEY NONCLUSTERED(transactioncompid,transactionseqno)
)
go
CREATE NONCLUSTERED index idx_cardtransactionhistory_transactioncardno on cardtransactionhistory(transactioncardno)
go

---------------------------------------
----mconsumeinfo--- ��������
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='mconsumeinfo')
CREATE tAbLE    mconsumeinfo  
(
	cscompid			varchar(10)     Not NULL,   --��˾���
	csbillid			varchar(20)		Not NULL,   --���ѵ���
	cskeyno				varchar(20)		NULL    ,   --���ƺ�
	csmanualno			varchar(20)		NULL    ,   --�ֹ�С��
	csdate				varchar(8)		NULL    ,   --��������
	csstarttime			varchar(6)		NULL    ,   --���ѿ�ʼʱ��
	csendtime			varchar(6)		NULL    ,   --���ѽ���ʱ��
	cscardno			varchar(20)		NULL    ,   --��Ա����
	csname				varchar(20)		NULL    ,   --�ͻ�����������ǻ�Ա���ǻ�Ա����
	cscardtype			varchar(10)		NULL    ,   --������
	csersex				int				NULL    ,  	--�˿��Ա�
	csertype			int				NULL    ,   --�Ƿ�Ϊ�Ͽ�
	csercount			int				NULL    ,   --��������
	csopationerid		varchar(20)		NULL    ,   --��������Ա
	csopationdate		varchar(10)		NULL    ,   --��������
	financedate			varchar(8)		NULL    ,   --�������� ,
	backcsflag			int				NULL    ,   --�Ƿ��Ѿ�����: 0-û�з��� 1--�Ѿ�����
	backcsbillid		varchar(20)		NULL    ,   --��������
	cscurkeepamt		float			NULL	,	--���ѵ�ǰ���(��ֵ���չ��˻�)
	cscurdepamt			float			NULL	,	--���ѵ�ǰǷ��
	tuangoucardno		varchar(20)		NUlL	,	--�Ź�����
	tiaomacardno		varchar(20)		NUlL	,	--���뿨��
	diyongcardno		varchar(20)		NUlL	,	--����ȯ��
	reservationflag		int				NULL    ,   --�Ƿ�ԤԼ: 0-û��ԤԼ 1--�Ѿ�ԤԼ
	sendpointflag		int						NULL,   --�Ƿ����ͻ���: 0--������ 1--����
	reserveStaffinfo	varchar(100)	NUlL	,	--ԤԼԱ��
	recommendempid		varchar(20)		NULL	,	--�Ƽ�Ա��
	recommendempinid	varchar(20)		NULL	,	--�Ƽ�Ա��
	sendpointflag		varchar(20)		null,
	cardphone			varchar(20)		null,
	randomno			varchar(50)		null,	--΢����
	ctypestate 			int 				null,--C������ʦ������ʶ1.��ʹ�� NULL.δʹ��
 	scanpaytype 		int 				null,--ɨ��֧������1.֧���� 2.΢��
	scanbarcode 		nvarchar(20) 		null,--ɨ��֧������
	scantradeno 		nvarchar(30) 		null,--ɨ�붩����
	ticketcode 			varchar(20) 		NULL--��ʫ��è�ȯ��
	CONSTRAINT PK_mconsumeinfo PRIMARY KEY NONCLUSTERED(cscompid,csbillid)
)
go 		 
CREATE NONCLUSTERED index idx_mconsumeinfo_cardno on mconsumeinfo(cscardno)
go
CREATE NONCLUSTERED index idx_mconsumeinfo_financedate on mconsumeinfo(financedate)
go
CREATE NONCLUSTERED index idx_mconsumeinfo_saledate on mconsumeinfo(cscompid,financedate)
INCLUDE ([csbillid],[cscardno],[cscardtype],[diyongcardno])
go



	
---------------------------------------
----dconsumeinfo--- ������ϸ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dconsumeinfo')
CREATE tAbLE    dconsumeinfo  
(
	cscompid		varchar(10)     Not NULL,   --��˾���
	csbillid		varchar(20)		Not NULL,   --���ѵ���
	csinfotype		int				Not	NULL,	--��������  1 ��Ŀ  2 ��Ʒ
	csseqno			float			Not NULL,   --���к�
	csitemno		varchar(20)     NULL,		--��Ŀ/��Ʒ����
	csitemunit		varchar(5)      NULL,		--��λ
	csitemcount		float           NULL,		--����
	csunitprice		float           NULL,		--���۵���
	csdiscount		float           NULL,		--����
	csdisprice		float           NULL,		--���õ���
	csitemamt		float           NULL,		--���
	cspaymode		varchar(5)		NULL,		--֧����ʽ
	csfirstsaler	varchar(20)     NULL,		--�󹤹���
	csfirsttype		varchar(5)     NULL,		--������
    csfirstinid		varchar(20)		NULL,		--���ڲ����
	csfirstshare	float           NULL,		--�󹤷���
	csfirstreserve	int				NULL,
	cssecondsaler	varchar(20)     NULL,		--�й�����
	cssecondtype	varchar(5)     NULL,		--�й�����
    cssecondinid	varchar(20)		NULL,		--�й��ڲ����
	cssecondshare	float           NULL,		--�й�����
	cssecondreserve	int				NULL,		
	csthirdsaler	varchar(20)     NULL,		--С������
	csthirdtype		varchar(5)		NULL,		--С������
    csthirdinid		varchar(20)		NULL,		--С���ڲ����
	csthirdshare	float           NULL,		--С������
	csthirdreserve	int				NULL,		
	csortherpayid	varchar(30)		NULL,		--����֧��(�ֽ����ȯ,��Ŀ����ȯ,���뿨,�Ź���)
	csproseqno		float			NULL,		--�Ƴ��������
	saletype		int             NULL,		-- �����ʶ 1 �˿ͣ�2 �ŵ�	
	goodsbarno		varchar(20)     NULL,		--��Ʒ����
	csitemstate		int				NULL,		--�Ƿ���	0 �� 1 ��� 2 δ���
	costpricetype	int				NULL,		--�Ƿ�Ϊ���������	0 ���� 1 �� �����ʶ��
	hairRecommendEmpId varchar(50)			null,   --�ܼ���ϯ������
	hairRecommendEmpInid varchar(50)		null,   --�ܼ���ϯ�ڲ�����
	yearinid		varchar(50)		null,--Ψһ���
 	scanpaytype 	int 			null,			--ɨ��֧������1.֧���� 2.΢��
 	scanpayamt 		float 			null,			--ɨ��֧�����
    haircompamt		float 			null, 			--�ӷ�-��˾ҵ�����
	hairstaff		varchar(20)		null,			--�ӷ�-���������-�Ƽ��ˣ���ĳɱ�ʶλ 0�Ǳ��� 1���Ƽ��꣩
	integralcode	int				null			--���ӻ���֧�������ݻ��֣��ı�ʶ�ֶ�
	saledate		varchar(8)		NULL,   		--�Ƴ��˻�������
	activinid		varchar(50)		NULL,			--�Ψһ���
	CONSTRAINT PK_dconsumeinfo PRIMARY KEY NONCLUSTERED(cscompid,csbillid,csinfotype,csseqno)
)
go 	
CREATE NONCLUSTERED index idx_dconsumeinfo_csitemno on dconsumeinfo(cscompid,csitemno)
go




---------------------------------------
----dpayinfo--- ֧����ϸ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dpayinfo')
CREATE tAbLE    dpayinfo               --  ����--֧����ϸ
(
	paycompid		varchar(10)     Not NULL,   --��˾���
	paybillid		varchar(20)		Not NULL,   --���ݱ��
	paybilltype		varchar(5)		Not NULL,   --�������  sY ����  sK  �ۿ�  cZ ��ֵ ZK  ת�� HZ ������Ŀ tK �˿�
	payseqno		float			Not NULL,   --���
	paymode			varchar(5)      NULL,   --֧����ʽ
	payamt			float           NULL,   --֧�����
	payremark		varchar(30)     NULL,   --��ע˵��
	CONSTRAINT PK_dpayinfo PRIMARY KEY NONCLUSTERED(paycompid,paybillid,paybilltype,payseqno)
)
Go



---------------------------------------
----sendpointcard -- ���ͻ��ֿ�
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='sendpointcard')
CREATE tAbLE sendpointcard                  
(
	sendcompid			varchar(10)		Not NULL,		--���ͱ�� 
	sendbillid			varchar(20)		Not NULL,		--���͵���
	sendtype			int				Not NULL,       --��������(0- ���� ,1-��ֵ  ,2-�ۿ�ת��, 3-�չ�ת����5-���� )
	senddate			varchar(10)		NULL,			--��������
	sendempid			varchar(20)		NULL,			--����Ա��
	sourcebillid		varchar(20)     NULL,			--ԭʼ����
	sourcecardno		varchar(20)     NULL,			--ԭ������
	sourcedate			varchar(10)     NULL,			--ԭ������
	sourceamt			float		    NULL,			--ԭ�����
	sendcardno			varchar(20)     NULL,			--���Ϳ���
	sendamt				float		    NULL,			--���ͽ��
	sendmark			varchar(100)    NULL,			--��ע
	operation			varchar(20)     NULL,			--������
	membername			varchar(20)     NULL,			--��Ա����
	memberphone			varchar(20)     NULL,			--��Ա�ֻ�����
	sendrateflag		int				NULL,			--1,10%�ϣ�2 ���¿� 15%��
	sendpicflag 		int				NULL,			--1 ���� , 2 ���뿨 3 ��ֵ���
	picno				varchar(20)		NULL,			--��Ŀ����ȯ����
	firstdateno			varchar(20)		NULL,			--��������ȯ��
	CONSTRAINT PK_sendpointcard PRIMARY KEY CLUSTERED(sendcompid,sendbillid,sendtype)
)
Go



---------------------------------------
----corpsbuyinfo -- �Ź�������
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='corpsbuyinfo')
CREATE table corpsbuyinfo
(
	corpscardno		varchar(20)		not null,--�Ź�����
	corpstype		int				not	null,--��Ŀ/������ 1 �Ź���Ŀ 2 �Ź�����
	corpssource		varchar(10)		not	null,--�Ź����� ��������
	corpspicno		varchar(20)		not null,--��Ŀ/�����ͱ��
	corpsamt		float			null	,--�Ź����
	operationer		varchar(20)		null	,--�Ǽ���
	operationdate	varchar(10)		null	,--�Ǽ�����
	corpssate		int				null	,--�Ź���״̬ 1:δ���� 2��ʹ��
	useincompid		varchar(10)		null	,--ʹ���ŵ�
	useinbillno		varchar(20)		null	,--ʹ�õ���
	useindate		varchar(10)		null	,--ʹ������
	CONSTRAINT PK_corpsbuyinfo PRIMARY KEY CLUSTERED(corpscardno)
)
go



---------------------------------------
----nointernalcardinfo -- ��ϵͳ�ڲ�����Ϣ ���뿨/��Ŀ����ȯ/�ֽ����ȯ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='nointernalcardinfo')
CREATE table nointernalcardinfo
(
	cardvesting		varchar(10)		not null,	--��˾���
	cardno			varchar(20)		not null,	--���ڲ�����
	cardtype 		int 				null	,--������ -- 1 ����ȯ��2���뿨 3�ȯ(��Ŀ+��Ʒ)
	cardfaceamt		float				null	,--��ֵ(����ȯ��Ч)
	carduseflag		int 				null	,--ʹ������ 1 ��Ŀ  2 �ֽ� (����ȯ��Ч,���뿨Ĭ����Ŀ)
	entrytype		int 				null	,--�Ǽ�����  // 0  �����Ǽ�,1 ����
	cardstate		int 				null	,--��״̬  //0 �Ǽ�     1������ʹ��  2 ����
	usedate			varchar(10) 		null	,--ʹ������  
	useinproject	varchar(80) 		null	,--������Ŀ(�ֽ�ȯ��Ч)  
	oldvalidate		varchar(10) 		null	,--ԭʼ��Ч����  
	lastvalidate	varchar(10) 		null	,--������Ч����  
	enabledate		varchar(10)			null	,--��������
	uespassward		int					null	,--�Ƿ���Ҫ����  -- 0 ����Ҫ 1 ��Ҫ
	cardpassward	varchar(20)			null	,--��������
	createtype		int					null	,-- 0��ͨȯ 1 ��һ�ȯ
	createcardtype	int					null	,-- ȯ1 ȯ2 ȯ3
	CONSTRAINT PK_nointernalcardinfo PRIMARY KEY CLUSTERED(cardvesting,cardno)
)
go
CREATE NONCLUSTERED index idx_nointernalcardinfo_cardno on nointernalcardinfo(cardno)
go

insert nointernalcardinfo(cardvesting,cardno,cardtype,cardfaceamt,carduseflag,entrytype,cardstate,oldvalidate,lastvalidate,enabledate,uespassward,createtype)


---------------------------------------
----dnointernalcardinfo -- ��ϵͳ�ڲ�����Ŀ��Ϣ ���뿨/��Ŀ����ȯ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dnointernalcardinfo')
CREATE table dnointernalcardinfo
(
	cardvesting		varchar(10)		not null,--��˾���
	cardno			varchar(20)		not null,--���ڲ�����
	seqno			float			not null,--���
	ineritemno		varchar(20)		null	,--��Ŀ
	entrycount		float			null	,--�ǼǴ���
	usecount		float			null	,--ʹ�ô���
	lastcount		float			null	,--ʣ�����
	entryamt		float			null	,--�Ǽ����
	useamt			float			null	,--ʹ�����
	lastamt			float			null	,--ʣ�����
	costbillno		varchar(20)		null	,--���ѵ���
	entryremark	varchar(200)		null	,--��ע
	packageNo	varchar(50)		null,	 --�ײͱ��
	CONSTRAINT PK_dnointernalcardinfo PRIMARY KEY CLUSTERED(cardvesting,cardno,seqno)
)
go
CREATE NONCLUSTERED index idx_dnointernalcardinfo_cardno on dnointernalcardinfo(cardno)
go

---------------------------------------
----msalebarcodecardinfo -- ϵͳ���뿨��������
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='msalebarcodecardinfo')
CREATE table msalebarcodecardinfo
(
	salecompid			varchar(10)		not null	,--�����ŵ�
	salebillid			varchar(20)		not null	,--���۵���
	saledate			varchar(8)			null	,--��������
	saletime			varchar(8)			null	,--����ʱ��
	operationer			varchar(20)			null	,--���ݲ�����
	barcodecardno		varchar(20)			null	,--�������뿨����
	firstpaymode		varchar(20)			null	,--��һ֧����ʽ
	firstpayamt			float				null	,--��һ֧�����
	secondpaymode		varchar(20)			null	,--�ڶ�֧����ʽ
	secondpayamt		float				null	,--�ڶ�֧�����
	saleamt				float				null	,--�����ܶ�
	firstsaleempid		varchar(20)			null	,--��һ���۹���
	firstsaleempinid	varchar(20)			null	,--��һ�����ڲ�����
	firstsaleamt		float				null	,--��һ���۷������
	secondsaleempid		varchar(20)			null	,--�ڶ����۹���
	secondsaleempinid	varchar(20)			null	,--�ڶ������ڲ�����
	secondsaleamt		float				null	,--�ڶ����۷������
	thirdsaleempid		varchar(20)			null	,--�������۹���
	thirdsaleempinid	varchar(20)			null	,--���������ڲ�����
	thirdsaleamt		float				null	,--�������۷������
	salebakflag			int NULL,
	usecardno			varchar(20)			null	,--��Ա����
	usecardtype			varchar(10)			null    ,--��Ա������
	usecardpayamt		float				null	,--��ֵ֧��
	CONSTRAINT PK_msalebarcodecardinfo PRIMARY KEY CLUSTERED(salecompid,salebillid)
)
go



---------------------------------------                                                                                           
----dsalebarcodecardinfo -- ϵͳ���뿨������ϸ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dsalebarcodecardinfo')
CREATE table dsalebarcodecardinfo
(
	salecompid		varchar(10)		not null	,--�����ŵ�
	salebillid		varchar(20)		not null	,--���۵���
	saleseqno		float			not null	,--�������
	saleproid		varchar(20)			null	,--���뿨��Ŀ���
	saleprocount	float				null	,--���뿨��Ŀ����
	saleproamt		float				null	,--���뿨��Ŀ���
	saleremark		varchar(200)		null	,--��ע
	packageNo		varchar(50)		null,	 --�ײͱ��
	CONSTRAINT PK_dsalebarcodecardinfo PRIMARY KEY CLUSTERED(salecompid,salebillid,saleseqno)
)
go



---------------------------------------
----mpackageinfo  -- �ײ���������
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='mpackageinfo')
CREATE tAbLE    mpackageinfo             
(
	compid			varchar(10)     	Not NULL,   	--��˾���
	packageno		varchar(20) 	Not NULL,	--�ײͱ��
	packagename 	varchar(30) 	NULL,		--�ײ�����
	packageprice	float         	NULL,		--��׼�۸�
	paceageremark	varchar(100)	NULL,		--�ײͼ��
	usedate			varchar(10)		NULL,		--�ײͽ�ֹʹ������		
	usetype			int				NULL,		--�ײ�ʹ�÷�Χ  1 ���뿨  2 �Ƴ̶һ�
	ratetype		int				NULL,		--���۱�ʾ 0 ����  1 ������
	usemonths		int				NULL,		--��Ч�� ��λ ��
	CONSTRAINT PK_mpackageinfo PRIMARY KEY CLUSTERED(compid,packageno)
)
go



---------------------------------------
----dmpackageinfo  -- �ײ�������ϸ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dmpackageinfo')
CREATE tAbLE    dmpackageinfo               
(
	compid			varchar(10)     	Not NULL,   	--��˾���
	packageno		varchar(20) 		Not NULL,	--�ײͱ��
	packageprono 	varchar(20) 		Not NULL,	--��Ŀ���
	packageprocount	float				NULL,			--��Ŀ����
	packageproamt	float				NULL,			--������
	CONSTRAINT PK_dmpackageinfo PRIMARY KEY CLUSTERED(compid,packageno,packageprono)
)
go



---------------------------------------
----msalecardinfo  -- ��Ա�����۵�����
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='msalecardinfo')
CREATE tAbLE	msalecardinfo               -- ��Ա�����۵�
(
	salecompid			varchar(10)			Not NULL,   --��˾���
	salebillid			varchar(20)			Not NULL,   --���۵���
	saledate			varchar(8)				NULL,   --��������
	saletime			varchar(8)				NULL,   --����ʱ��
	salecardno			varchar(20)				NULL,   --���ۿ���
	salecardtype		varchar(20)				NULL,   --���ۿ�����
	membername			varchar(30)				NULL,   --�ͻ�����
	memberphone			varchar(20)				NULL,   --��Ա�ֻ���,
	membersex			int						NULL,	--�ͻ��Ա�1--�� 0--Ů
	memberpcid			varchar(30)				NULL,   --�ͻ�����֤��
	memberbirthday		varchar(8)				NULL,   --�ͻ�����
	salekeepamt			float					NULL,   --��ֵ���
	saledebtamt			float					NULL,   --Ƿ����
	saletotalamt		float					NULL,   --ʵ���ܶ�
	firstsalerid		varchar(20)				NULL,   --��һ���۹���
    firstsalerinid		varchar(20)				NULL,   --��һ�����ڲ����
    firstsaleamt		float					NULL,   --��һ���۷������
	secondsalerid		varchar(20)				NULL,   --�ڶ����۹���
    secondsalerinid		varchar(20)				NULL,   --�ڶ������ڲ����
    secondsaleamt		float					NULL,   --�ڶ����۷������
	thirdsalerid		varchar(20)				NULL,   --�������۹���
    thirdsalerinid		varchar(20)				NULL,   --���������ڲ����
    thirdsaleamt		float					NULL,   --�������۷������
	fourthsalerid		varchar(20)				NULL,   --�������۹���
    fourthsalerinid		varchar(20)				NULL,   --���������ڲ����
    fourthsaleamt		float					NULL,   --�������۷������
	fifthsalerid		varchar(20)				NULL,   --�������۹��� -----��Ⱦʦ
    fifthsalerinid		varchar(20)				NULL,   --���������ڲ����
    fifthsaleamt		float					NULL,   --�������۷������
	sixthsalerid		varchar(20)				NULL,   --�������۹���----- ��Ⱦʦ
    sixthsalerinid		varchar(20)				NULL,   --���������ڲ����
    sixthsaleamt		float					NULL,   --�������۷������
	seventhsalerid		varchar(20)				NULL,   --�������۹��� -----��Ⱦʦ
    seventhsalerinid	varchar(20)				NULL,   --���������ڲ����
    seventhsaleamt		float					NULL,   --�������۷������
	eighthsalerid		varchar(20)				NULL,   --�ڰ����۹���----- ��Ⱦʦ
    eighthsalerinid		varchar(20)				NULL,   --�ڰ������ڲ����
    eighthsaleamt		float					NULL,   --�ڰ����۷������
    
    ninthsalerid		varchar(20)				NULL,   --�ھ����۹���-----
    ninthsalerinid		varchar(20)				NULL,   --�ھ������ڲ����
    ninthsaleamt		float					NULL,   --�ھ����۷������
    tenthsalerid		varchar(20)				NULL,   --��ʮ���۹���----- ��Ⱦʦ
    tenthsalerinid		varchar(20)				NULL,   --��ʮ�����ڲ����
    tenthsaleamt		float					NULL,   --��ʮ���۷������
    
    firstsalecashamt		float					NULL,   --��һ���۷������(ʵ���ֽ�ҵ��)
    secondsalecashamt		float					NULL,   --�ڶ����۷������(ʵ���ֽ�ҵ��)
    thirdsalecashamt		float					NULL,   --�������۷������(ʵ���ֽ�ҵ��)
    fourthsalecashamt		float					NULL,   --�������۷������(ʵ���ֽ�ҵ��)
    fifthsalecashamt		float					NULL,   --�������۷������(ʵ���ֽ�ҵ��)
    sixthsalecashamt		float					NULL,   --�������۷������(ʵ���ֽ�ҵ��)
    seventhsalecashamt		float					NULL,   --�������۷������(ʵ���ֽ�ҵ��)
    eighthsalecashamt		float					NULL,   --�ڰ����۷������(ʵ���ֽ�ҵ��)
    ninthsalecashamt		float					NULL,   --�ھ����۷������(ʵ���ֽ�ҵ��)
    tenthsalecashamt		float					NULL,   --��ʮ���۷������(ʵ���ֽ�ҵ��)
    
	financedate			varchar(8)				NULL,   --�������� 
	saleroperator		varchar(20)				NULL,   --��½��Ա����
	saleroperdate		varchar(8)				NULL,   --��½����
	cardappbillid		varchar(20)				NULL,   --��Ա�����뵥��
	corpscardno			varchar(20)				NULL,	--�Ź���
	activtycardno		varchar(20)				NULL,	--�ȯ��
	saleremark			varchar(160)			NULL,   --��ע
	bankcostno			varchar(10)				NULL,	--���п�ƾ֤��
	backconfirmflag		varchar(5) 				null,   --�ڷ���ʱ�����Ƿ��ܲ�����  Y ����  N δ����
	salebakflag			int						null,	--��������: 0--������ 1--������
	firstpaymode		varchar(5)				NULL,   --֧����ʽ1
	firstpayamt			float      				NULL,   --֧����ʽ1���
	secondpaymode		varchar(5)				NULL,   --֧����ʽ2
	secondpayamt		float      				NULL,   --֧����ʽ2���
	thirdpaymode		varchar(5)				NULL,   --֧����ʽ3
	thirdpayamt			float      				NULL,   --֧����ʽ3���
	fourthpaymode		varchar(5)				NULL,   --֧����ʽ4
	fourthpayamt		float      				NULL,   --֧����ʽ4���
	sendpointflag		int						NULL,   --�Ƿ����ͻ���: 0--������ 1--����
	backflag			int						NULL,	--�Ƿ񷴳� 0 δ���� 1 ����
	billinsertype		int						NULL,	--��ֵ���췽 1 ���� 2 ����
	sendamtflag		int							NULL,   --�Ƿ����Ϳ���: 0--������ 1--����
	CONSTRAINT PK_INDEX_msalecardinfo PRIMARY KEY CLUSTERED(salecompid,salebillid)
)
         
   
go 
CREATE NONCLUSTERED index idx_msalecardinfo_cardno on msalecardinfo(salecardno)
go
CREATE NONCLUSTERED index idx_msalecardinfo_financedate on msalecardinfo(financedate)
go
CREATE NONCLUSTERED index idx_msalecardinfo_saledate on msalecardinfo(salecompid,saledate)
go



---------------------------------------
----dsalecardproinfo -- ��Ա������--�Ƴ���ϸ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dsalecardproinfo')
CREATE tAbLE    dsalecardproinfo               
(
	salecompid			varchar(10)     Not NULL,   --��˾���
	salebillid			varchar(20)		Not NULL,   --���۵���
	salebilltype		int				Not NULL,   --��������   1 ����  2 ��ֵ
	seleproseqno		float			Not	NULL,   --�Ƴ����
	saleproid			varchar(20)			NULL,   --��Ŀ���
	saleprocardcount	float				NULL,	--�����Ƴ���
	saleprotype			int					NULL,   --�۸����
	saleprocount		float				NULL,   --����
	sendprocount		float				NULL,   --���ʹ���
	saleproamt			float				NULL,   --�Ƴ̽��
	saleprodebtamt		float				NULL,   --�Ƴ�Ƿ��
	procutoffdate		varchar(8)			NULL,   --��������
	saleproremark		varchar(200)		NULL,   --��ע
	firthpaymode		varchar(5)			NULL,   --֧����ʽ1
	firthpayamt			float      			NULL,   --֧����ʽ1���
	secondpaymode		varchar(5)			NULL,   --֧����ʽ2
	secondpayamt		float      			NULL,   --֧����ʽ2���
	thirdpaymode		varchar(5)			NULL,   --֧����ʽ3
	thirdpayamt			float      			NULL,   --֧����ʽ3���
	fourthpaymode		varchar(5)			NULL,   --֧����ʽ4
	fourthpayamt		float      			NULL,   --֧����ʽ4���
	CONSTRAINT PK_dsalecardproinfo PRIMARY KEY CLUSTERED(salecompid,salebillid,seleproseqno,salebilltype)
)
go


---------------------------------------
----mcardrechargeinfo  -- ��Ա�����ѵ�����
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='mcardrechargeinfo')
CREATE tAbLE    mcardrechargeinfo               -- �ʻ��춯��
(
	rechargecompid			varchar(10)			Not NULL,   --��ֵ�ŵ�
	rechargebillid			varchar(20)			Not NULL,   --��ֵ���� 
	rechargedate			varchar(8)				NULL,   --��ֵ���� 
	rechargetime			varchar(6)				NULL,   --��ֵʱ�� 
	rechargecardno			varchar(20)				NULL,   --��Ա����
	rechargecardtype		varchar(10)				NULL,   --������
	rechargeaccounttype		varchar(10)				NULL,   --��ֵ�˻�
	rechargetype			int						NULL,   --���ѷ�ʽ( 0��ֵ ,6���� ,)
	membername				varchar(20)				NULL,   --��Ա����
	rechargekeepamt			float					NULL,   --��ֵ���
	rechargedebtamt			float					NULL,   --Ƿ����
	curcardamt				float					NULL,   --�춯ǰ���
	curcarddebtamt			float					NULL,   --�춯ǰǷ��
	firstsalerid			varchar(20)				NULL,   --��һ���۹���
    firstsalerinid			varchar(20)				NULL,   --��һ�����ڲ����
    firstsaleamt			float					NULL,   --��һ���۷������
	secondsalerid			varchar(20)				NULL,   --�ڶ����۹���
    secondsalerinid			varchar(20)				NULL,   --�ڶ������ڲ����
    secondsaleamt			float					NULL,   --�ڶ����۷������
	thirdsalerid			varchar(20)				NULL,   --�������۹���
    thirdsalerinid			varchar(20)				NULL,   --���������ڲ����
    thirdsaleamt			float					NULL,   --�������۷������
	fourthsalerid			varchar(20)				NULL,   --�������۹���
    fourthsalerinid			varchar(20)				NULL,   --���������ڲ����
    fourthsaleamt			float					NULL,   --�������۷������
	fifthsalerid			varchar(20)				NULL,   --�������۹��� -----��Ⱦʦ
    fifthsalerinid			varchar(20)				NULL,   --���������ڲ����
    fifthsaleamt			float					NULL,   --�������۷������
	sixthsalerid			varchar(20)				NULL,   --�������۹���----- ��Ⱦʦ
    sixthsalerinid			varchar(20)				NULL,   --���������ڲ����
    sixthsaleamt			float					NULL,   --�������۷������
	seventhsalerid			varchar(20)				NULL,   --�������۹��� -----��Ⱦʦ
    seventhsalerinid		varchar(20)				NULL,   --���������ڲ����
    seventhsaleamt			float					NULL,   --�������۷������
	eighthsalerid			varchar(20)				NULL,   --�ڰ����۹���----- ��Ⱦʦ
    eighthsalerinid			varchar(20)				NULL,   --�ڰ������ڲ����
    eighthsaleamt			float					NULL,   --�ڰ����۷������
    ninthsalerid		varchar(20)				NULL,   --�ھ����۹���-----
    ninthsalerinid		varchar(20)				NULL,   --�ھ������ڲ����
    ninthsaleamt		float					NULL,   --�ھ����۷������
    tenthsalerid		varchar(20)				NULL,   --��ʮ���۹���----- ��Ⱦʦ
    tenthsalerinid		varchar(20)				NULL,   --��ʮ�����ڲ����
    tenthsaleamt		float					NULL ,  --��ʮ���۷������
	financedate				varchar(8)				NULL,   --�������� 
	operationer				varchar(20)				NULL,   --������Ա
	operationdate			varchar(8)				NULL,   --��������
	firstpaymode			varchar(5)				NULL,   --֧����ʽ1
	firstpayamt				float      				NULL,   --֧����ʽ1���
	secondpaymode			varchar(5)				NULL,   --֧����ʽ2
	secondpayamt			float      				NULL,   --֧����ʽ2���
	thirdpaymode			varchar(5)				NULL,   --֧����ʽ3
	thirdpayamt				float      				NULL,   --֧����ʽ3���
	fourthpaymode			varchar(5)				NULL,   --֧����ʽ4
	fourthpayamt			float      				NULL,   --֧����ʽ4���
	rechargeremark			varchar(160)			NULL,   --��ע
	
	firstsalecashamt		float					NULL,   --��һ���۷������(ʵ���ֽ�ҵ��)
    secondsalecashamt		float					NULL,   --�ڶ����۷������(ʵ���ֽ�ҵ��)
    thirdsalecashamt		float					NULL,   --�������۷������(ʵ���ֽ�ҵ��)
    fourthsalecashamt		float					NULL,   --�������۷������(ʵ���ֽ�ҵ��)
    fifthsalecashamt		float					NULL,   --�������۷������(ʵ���ֽ�ҵ��)
    sixthsalecashamt		float					NULL,   --�������۷������(ʵ���ֽ�ҵ��)
    seventhsalecashamt		float					NULL,   --�������۷������(ʵ���ֽ�ҵ��)
    eighthsalecashamt		float					NULL,   --�ڰ����۷������(ʵ���ֽ�ҵ��)
    ninthsalecashamt		float					NULL,   --�ھ����۷������(ʵ���ֽ�ҵ��)
    tenthsalecashamt		float					NULL,   --��ʮ���۷������(ʵ���ֽ�ҵ��)
    
	backbillid				varchar(160)			NULL,   --����ԭʼ��
	bankcostno				varchar(10)				NULL,	--���п�ƾ֤��
	backconfirmflag			varchar(5) 				NULL,  --�ڷ���ʱ�����Ƿ��ܲ�����  Y ����  N δ����
	salebakflag				int						NULL,  --��������: 0--������ 1--������
	sendpointflag			int						NULL    ,  --�Ƿ����ͻ���: 0--������ 1--����
	backflag				int						NULL,	--�Ƿ񷴳� 0 δ���� 1 ����
	billinsertype			int						NULL,	--��ֵ���췽 1 ���� 2 ����
	sendamtflag				int							NULL,   --�Ƿ����Ϳ���: 0--������ 1--����
	CONSTRAINT PK_mcardrechargeinfo PRIMARY KEY NONCLUSTERED(rechargecompid,rechargebillid)
)
Go

CREATE NONCLUSTERED index idx_mcardrechargeinfo_rechargecardno on mcardrechargeinfo(rechargecardno)
go
CREATE NONCLUSTERED index idx_mcardrechargeinfo_financedate on mcardrechargeinfo(financedate)
go
CREATE NONCLUSTERED index idx_mcardrechargeinfo_rechargedate on mcardrechargeinfo(rechargecompid,rechargedate)
go


---------------------------------------
----mproexchangeinfo--- ��ֵ�չ��˻��һ��Ƴ�����
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='mproexchangeinfo')
CREATE tAbLE    mproexchangeinfo  
(
	changecompid			varchar(10)			Not NULL,   --�һ��ŵ�
	changebillid			varchar(20)			Not NULL,   --�һ�����
	changedate				varchar(8)			NULL    ,   --�һ�����
	changetime				varchar(6)			NULL    ,   --�һ���ʼʱ��
	changecardno			varchar(20)			NULL    ,   --��Ա����
	changeaccounttype		varchar(10)			NULL    ,   --���˻�����
	curaccountkeepamt		float				NULL    ,   --��ֵ�˻����
	curaccountdebtamt		float				NULL    ,   --��ֵ�˻�Ƿ��
	cursendaccountkeepamt	float				NULL    ,   --�����˻����
	curproaccountamt		float				NULL    ,   --�Ƴ��˻����
	changecardtype			varchar(10)			NULL    ,   --������
	membername				varchar(20)			NULL    ,   --�ͻ�����������ǻ�Ա���ǻ�Ա����
	memberphone				varchar(20)			NULL    ,  	--�˿��Ա�
	changeopationerid		varchar(20)			NULL    ,   --��������Ա
	changeopationdate		varchar(10)			NULL    ,   --��������
	financedate				varchar(8)			NULL    ,   --�������� ,
	backcsflag				int					NULL    ,   --�Ƿ��Ѿ�����: 0--������ 1--������
	backcsbillid			varchar(20)			NULL    ,   --���ص���
	curfaceaccountamt		float				NULL       	--���ݻ����˻����
	CONSTRAINT PK_mproexchangeinfo PRIMARY KEY NONCLUSTERED(changecompid,changebillid)
)
go 	
CREATE NONCLUSTERED index idx_mproexchangeinfo_changecardno on mproexchangeinfo(changecardno)
go
CREATE NONCLUSTERED index idx_mproexchangeinfo_financedate on mproexchangeinfo(financedate)
go
CREATE NONCLUSTERED index idx_mproexchangeinfo_compid_financedate on mproexchangeinfo(changecompid,financedate)
INCLUDE (changebillid,changedate,changecardno,changecardtype)
go


---------------------------------------
----dproexchangeinfo--- ��ֵ�չ��˻��һ��Ƴ���ϸ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dproexchangeinfo')
CREATE table dproexchangeinfo( 
	changecompid			varchar(10)				Not NULL, 		--�һ��ŵ�
	changebillid			varchar(20)				Not NULL, 		--�һ�����
	changeseqno				float					Not NULL, 		--��ˮ�� 
	changeproid				varchar(20) 			NULL,			--��Ŀ���
	procount				float					NULL,			--�Ƴ���
	changeprocount			float					NULL,			--����
	changeprorate			float					NULL,			--�ۿ�
	changeproamt			float					NULL,			--���
	changebyproaccountamt	float					NULL,			--���(�Ƴ��˻�)
	changebyaccountamt		float					NULL,			--���(��ֵ�˻����)
	changebysendaccountamt	float					NULL,			--���(�����˻����)
	changepaymode			varchar(5)				NULL,			--֧����ʽ
	changebycashamt			float					NULL,			--��ֵ���ֽ��
	nointernalcardno		varchar(20)				NULL,			--����ȯ��ľ
    changebydyqamt			float					NULL,			--���(����ȯ��)
	firstsalerid			varchar(20)				NULL,			--��һ���۹���
    firstsalerinid			varchar(20)				NULL,			--��һ�����ڲ����
    firstsaleamt			float					NULL,			--��һ���۷������
	secondsalerid			varchar(20)				NULL,			--�ڶ����۹���
    secondsalerinid			varchar(20)				NULL,			--�ڶ������ڲ����
    secondsaleamt			float					NULL,			--�ڶ����۷������
	thirdsalerid			varchar(20)				NULL,			--�������۹���----- ��Ⱦʦ
    thirdsalerinid			varchar(20)				NULL,			--���������ڲ����
    thirdsaleamt			float					NULL,			--�������۷������
	fourthsalerid			varchar(20)				NULL,			--�������۹���----- ��Ⱦʦ
    fourthsalerinid			varchar(20)				NULL,			--���������ڲ����
    fourthsaleamt			float					NULL,			--�������۷������
    changemark				varchar(200)			NULL,			--�ۿ�
    salebakflag				int						NULL,  --��������: 0--������ 1--������
    sendpointflag			int					NULL    ,  --�Ƿ����ͻ���: 0--������ 1--����
	changebyfaceamt			float					NULL			--���ݻ��ֵֿ�(���ݻ��ֵֿ�)
    CONSTRAINT PK_dproexchangeinfo PRIMARY KEY NONCLUSTERED(changecompid,changebillid,changeseqno)
)
go







---------------------------------------
----dproexchangeinfo--- ��ֵ�չ��˻��һ��Ƴ���ϸ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dproexchangeinfobypro')
CREATE table dproexchangeinfobypro
(
	changecompid			varchar(10)				Not NULL, 		--��˾��
	changebillid			varchar(20)				Not NULL, 		--��Ա����
	changeseqno				float					Not NULL, 		--��ˮ�� 
	changeproid				varchar(20) 			NULL,			--��Ŀ���
	bproseqno				float					NULL,			--��Ŀ���
	lastcount				float					NULL,			--ʣ�����
	lastamt					float					NULL,			--ʣ����
	changeprocount			float					NULL,			--����
	changeproamt			float					NULL,			--���
	CONSTRAINT PK_dproexchangeinfobypro PRIMARY KEY NONCLUSTERED(changecompid,changebillid,changeseqno)
)
go


---------------------------------------
----mcardchangeinfo--- ��Ա���춯
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='mcardchangeinfo')
CREATE table mcardchangeinfo
(
	changecompid				varchar(10)     Not NULL,   --�춯�ŵ�
	changebillid				varchar(20)		Not NULL,   --�춯����
	changetype					int				Not NULL,   --�춯���  0 �ۿ�ת�� 1 �չ�ת�� 2����ת�� 3���� 4��ʧ�� 5���� 6�Ͽ����Ͽ� 7�Ͽ����¿� 8�˿�
	changedate					varchar(8)			NULL,   --�춯����
	changetime					varchar(8)			NULL,   --�춯ʱ��
	changebeforcardno			varchar(20)			NULL,   --�춯ǰ��Ա����
	changecardfrom				varchar(20)			NULL,   --�춯ǰ��Ա������
	changebeforcardstate		int					NULL,   --�춯ǰ״̬  
	changebeforcardtype			varchar(10)			NULL,	--�춯ǰ������
	membername					varchar(20)			NULL,   --����
	memberphone					varchar(20)			NULL,   --�ֻ�����
	curaccountkeepamt			float				NULL,   --��ֵ�˻����
	curaccountdebtamt			float				NULL,   --��ֵ�˻�Ƿ��
	curproaccountkeepamt		float				NULL,   --�Ƴ��˻����
	curproaccountdebtamt		float				NULL,   --�Ƴ��˻�Ƿ��
	curpointaccountkeepamt			float				NULL,   --�����˻����
	cursendaccountkeepamt			float				NULL,   --�����˻����
	changelowamt				float				NULL,   --ת��������
	changefillamt				float				NULL,   --ת����ֵ
	changdebtamt				float				NULL,   --ת��Ƿ��
	cashfillamt					float				NULL,   --�ֽ�ֿ�
	bankfillamt					float				NULL,   --���п��ֿ�
	keepamtfillamt				float				NULL,   --��ֵ�ֿ�
	deductamt					float				NULL,   --�ɱ�
	changeaftercardno			varchar(20)			NULL,   --�춯ǰ��Ա����
	changeaftercardstate		int					NULL,   --�춯ǰ״̬  
	changeaftercardtype			varchar(10)			NULL,	--�춯ǰ������
	firstsalerid			varchar(20)				NULL,   --��һ���۹���
    firstsalerinid			varchar(20)				NULL,   --��һ�����ڲ����
    firstsaleamt			float					NULL,   --��һ���۷������
	secondsalerid			varchar(20)				NULL,   --�ڶ����۹���
    secondsalerinid			varchar(20)				NULL,   --�ڶ������ڲ����
    secondsaleamt			float					NULL,   --�ڶ����۷������
	thirdsalerid			varchar(20)				NULL,   --�������۹���
    thirdsalerinid			varchar(20)				NULL,   --���������ڲ����
    thirdsaleamt			float					NULL,   --�������۷������
	fourthsalerid			varchar(20)				NULL,   --�������۹���
    fourthsalerinid			varchar(20)				NULL,   --���������ڲ����
    fourthsaleamt			float					NULL,   --�������۷������
	fifthsalerid			varchar(20)				NULL,   --�������۹��� -----��Ⱦʦ
    fifthsalerinid			varchar(20)				NULL,   --���������ڲ����
    fifthsaleamt			float					NULL,   --�������۷������
	sixthsalerid			varchar(20)				NULL,   --�������۹���----- ��Ⱦʦ
    sixthsalerinid			varchar(20)				NULL,   --���������ڲ����
    sixthsaleamt			float					NULL,   --�������۷������
	seventhsalerid			varchar(20)				NULL,   --�������۹��� -----��Ⱦʦ
    seventhsalerinid		varchar(20)				NULL,   --���������ڲ����
    seventhsaleamt			float					NULL,   --�������۷������
	eighthsalerid			varchar(20)				NULL,   --�ڰ����۹���----- ��Ⱦʦ
    eighthsalerinid			varchar(20)				NULL,   --�ڰ������ڲ����
    eighthsaleamt			float					NULL,   --�ڰ����۷������
    ninthsalerid		varchar(20)				NULL,   --�ھ����۹���-----
    ninthsalerinid		varchar(20)				NULL,   --�ھ������ڲ����
    ninthsaleamt		float					NULL,   --�ھ����۷������
    tenthsalerid		varchar(20)				NULL,   --��ʮ���۹���----- ��Ⱦʦ
    tenthsalerinid		varchar(20)				NULL,   --��ʮ�����ڲ����
    tenthsaleamt		float					NULL,   --��ʮ���۷������
    rechargeremark			varchar(160)			NULL,   --��ע
    bankcostno				varchar(10)				NULL,	--���п�ƾ֤��
	financedate				varchar(8)				NULL,   --�������� 
	operationer				varchar(20)				NULL,   --������Ա
	operationdate			varchar(8)				NULL,   --��������
	confirmer				varchar(20)				NULL,   --�����Ա
	confirmdate				varchar(8)				NULL,   --�������
	backconfirmflag			varchar(5) 				NULL,   --�ڷ���ʱ�����Ƿ��ܲ�����  Y ����  N δ����
	salebakflag				int						NULL,  --��������:0--������ 1--������
	billflag				int						NULL,  --��������: ת���Ǽǵ� 0�ѵǼ� 1�ѹ�ʧ/�ѱ��� 2 �ѽ�� 3�Ѳ��� 4�Ѳ���
																--	   �˿��Ǽǵ� 0����¼�� 1�ѵǼ� 2 ����� 3�Ѳ��� 4���˿���Ч
	sendpointflag			int						NULL    ,  --�Ƿ����ͻ���: 0--������ 1--����
	backflag				int						NULL,	--�Ƿ񷴳� 0 δ���� 1 ����
	billinsertype			int						NULL,	--��ֵ���췽 1 ���� 2 ����
	salarytype				int						NULL,	--н��ģʽ 0 ��ģʽ 1 ��ģʽ
	sendamtflag				int						NULL,   --�Ƿ����Ϳ���: 0--������ 1--����
	CONSTRAINT PK_mcardchangeinfo PRIMARY KEY CLUSTERED(changecompid,changebillid,changetype)
)
go
CREATE NONCLUSTERED index idx_mcardchangeinfo_changebeforcardno on mcardchangeinfo(changebeforcardno)
go
CREATE NONCLUSTERED index idx_mcardchangeinfo_changeaftercardno on mcardchangeinfo(changeaftercardno)
go
CREATE NONCLUSTERED index idx_mcardchangeinfo_financedate on mcardchangeinfo(financedate)
go
CREATE NONCLUSTERED index idx_mcardchangeinfo_rechargedate on mcardchangeinfo(changecompid,changedate)
go


---------------------------------------
----dcardchangeinfo--- ��Ա���춯(������ϸ)
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dcardchangeinfo')
CREATE tAbLE  dcardchangeinfo              
(
	changecompid		varchar(10)     Not NULL,   --�춯�ŵ�
	changebillid		varchar(20)		Not NULL,   --�춯����
	oldcardno			varchar(20)		Not NULL,   --�ϻ�Ա����
	oldcardtype			varchar(10)     null,   --��Ա�����
	oldcardname			varchar(20)		Not NULL,   --�ϻ�Ա����
    curaccountkeepamt	float           null,   --�˻����
    curaccountdebtamt	float           null,   --�˻�Ƿ��
    proaccountkeepamt	float           null,   --�Ƴ����
    proaccountdebtamt	float           null,   --�Ƴ�Ƿ��
	CONSTRAINT PK_dcardchangeinfo PRIMARY KEY CLUSTERED(changecompid,changebillid,oldcardno)
)
go
if not exists(select 1 from sysobjects where type='U' and name='dcardchangetocardinfo')
CREATE tAbLE  dcardchangetocardinfo              
(
	changecompid		varchar(10)     Not NULL,   --�춯�ŵ�
	changebillid		varchar(20)		Not NULL,   --�춯����
	cardno				varchar(20)		Not	NULL,	--��ֿ���
	cardvesting			varchar(10)			NUll,	--������
	cardtype			varchar(20)			NULL,	--������
	membername			varchar(20)			NULL,	--��Ա����
	memberphone			varchar(20)			NULL,	--�ֻ�����
	cardamt				float				NUll,	--��ֵ���
	CONSTRAINT PK_dcardchangetocardinfo PRIMARY KEY CLUSTERED(changecompid,changebillid,cardno)
)




---------------------------------------
----mcooperatesaleinfo--- ������Ŀ¼������
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='mcooperatesaleinfo')
CREATE tAbLE    mcooperatesaleinfo             
(
	salecompid				char(10)				Not NULL,   --��˾���
	salebillid				varchar(20)				Not NULL,   --�춯����
	saledate				varchar(8)				NULL    ,   --�춯����
	saletime				varchar(8)				NULL    ,   --�춯����
	salecooperid			varchar(30)				NULL    ,   --������λ
	slaepaymode				varchar(5)				NULL    ,   --֧������ 1 ����֧����2 ������λ֧��
	salecostproamt			float					NULL    ,   --��Ŀ���
	salecostcardno			varchar(20)				NULL    ,   --��Ա����
	salecostcardtype		varchar(20)				NULL    ,   --��Ա������
	membername				varchar(20)				NULL    ,   --����
	memberphone				varchar(20)				NULL    ,	--�ֻ�
	salemark				varchar(80)				NULL    ,   --��ע
	salefactpaycode			varchar(20)				NULL    ,   --ʵ��֧����ʽ ��ϸ��
	slaefactpayamt			float					NULL    ,   --ʵ��֧����� ��ϸ��
	salebillflag			int						NULL    ,   --����״̬ 0 ����¼��1 �ѵǼ� 2 �ܲ����
	firstsalerid			varchar(20)				NULL,   --��һ���۹���
    firstsalerinid			varchar(20)				NULL,   --��һ�����ڲ����
    firstsaleamt			float					NULL,   --��һ���۷������
	secondsalerid			varchar(20)				NULL,   --�ڶ����۹���
    secondsalerinid			varchar(20)				NULL,   --�ڶ������ڲ����
    secondsaleamt			float					NULL,   --�ڶ����۷������
	thirdsalerid			varchar(20)				NULL,   --�������۹���
    thirdsalerinid			varchar(20)				NULL,   --���������ڲ����
    thirdsaleamt			float					NULL,   --�������۷������
	fourthsalerid			varchar(20)				NULL,   --�������۹���
    fourthsalerinid			varchar(20)				NULL,   --���������ڲ����
    fourthsaleamt			float					NULL,   --�������۷������
	fifthsalerid			varchar(20)				NULL,   --�������۹��� -----��Ⱦʦ
    fifthsalerinid			varchar(20)				NULL,   --���������ڲ����
    fifthsaleamt			float					NULL,   --�������۷������
	sixthsalerid			varchar(20)				NULL,   --�������۹���----- ��Ⱦʦ
    sixthsalerinid			varchar(20)				NULL,   --���������ڲ����
    sixthsaleamt			float					NULL,   --�������۷������
	seventhsalerid			varchar(20)				NULL,   --�������۹��� -----��Ⱦʦ
    seventhsalerinid		varchar(20)				NULL,   --���������ڲ����
    seventhsaleamt			float					NULL,   --�������۷������
	eighthsalerid			varchar(20)				NULL,   --�ڰ����۹���----- ��Ⱦʦ
    eighthsalerinid			varchar(20)				NULL,   --�ڰ������ڲ����
    eighthsaleamt			float					NULL,   --�ڰ����۷������
	ninthsalerid		varchar(20)				NULL,   --�ھ����۹���-----
    ninthsalerinid		varchar(20)				NULL,   --�ھ������ڲ����
    ninthsaleamt		float					NULL,   --�ھ����۷������
    tenthsalerid		varchar(20)				NULL,   --��ʮ���۹���----- ��Ⱦʦ
    tenthsalerinid		varchar(20)				NULL,   --��ʮ�����ڲ����
    tenthsaleamt		float					NULL,   --��ʮ���۷������
    financedate				varchar(8)				NULL,   --�������� 
	operationer				varchar(20)				NULL,   --������Ա
	operationdate			varchar(8)				NULL,   --��������
	salebakflag				int						NULL,  --��������:0--������ 1--������
	accounttype 			int						NULL,	--����
	salescardpayment 		float					NULL,	--��ֵ֧��
	paymentmethod 			varchar(20)				NULL,	--֧����ʽ
	paymentamount 			float					NULL,	--֧�����
	CONSTRAINT PK_mcooperatesaleinfo PRIMARY KEY CLUSTERED(salecompid,salebillid)
)
go 
CREATE NONCLUSTERED index idx_mcooperatesaleinfo_salecostcardno on mcooperatesaleinfo(salecostcardno)
go


CREATE NONCLUSTERED index idx_mcooperatesaleinfo_financedate on mcooperatesaleinfo(financedate)
go
CREATE NONCLUSTERED index idx_mcooperatesaleinfo_rechargedate on mcooperatesaleinfo(salecompid,saledate)
go

---------------------------------------
----payinfodaybyday-- --  ����--֧����ϸ�ս�
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='payinfodaybyday')
CREATE tAbLE    payinfodaybyday              
(
	paycompid		varchar(10)      Not NULL,   --��˾���
	paydate			varchar(10)      Not NULL,   --��������
	paybilltype		varchar(5)		 Not NULL,   --�������  sY ����  sK  �ۿ�  cZ ��ֵ ZK  ת�� HZ ������Ŀ tK �˿�
	paymode			varchar(5)		 Not NULL,   --֧����ʽ
	payamt			float				 NULL,   --֧�����
	CONSTRAINT PK_payinfodaybyday PRIMARY KEY CLUSTERED(paycompid,paydate,paybilltype,paymode)
)
CREATE NONCLUSTERED index idx_payinfodaybyday_paydate on payinfodaybyday(paycompid,paydate)	
CREATE NONCLUSTERED index idx_payinfodaybyday_paymode on payinfodaybyday(paycompid,paydate,paymode)	

---------------------------------------
----detial_trade_byday_fromshops-- --  ����--Ӫҵ���ݽ���
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='detial_trade_byday_fromshops')
CREATE table detial_trade_byday_fromshops                                 
(                                                                              
		 shopId					varchar(10)			Not NULL,	--�ŵ���                                           
		 shopName				varchar(20)			NULL,	--�ŵ�����                                           
		 dateReport					varchar(8)			Not NULL,	--��������                                           
		 total						float				NULL,	--������                                                                  
		 cashservice				float				NULL,	--�ֽ����                                                 
		 cashprod					float				NULL,	--�ֽ��Ʒ                                                 
		 cashcardtrans				float				NULL,	--�ֽ�(���춯)                                    
		 cashbackcard				float				NULL,	--�ֽ�(�˿�)                                              
		 cashtotal					float				NULL,	--�ֽ�ϼ�(�۳��ֽ��˿�)                                                
		                                                                                                 
		 creditservice				float				NULL,	--���п�����                                                
		 creditprod					float				NULL,	--���п���Ʒ                                                
		 credittrans				float				NULL,	--���п�(���춯)                                      
		 creditbackcard				float				NULL,	---���п�(�˿�)                                           
		 credittotal				float				NULL,	--���п��ϼ�(�۳����п��˿�)                                                
		                                                                                                  
		 checkservice				float				NULL,	--֧Ʊ����                                                 
		 checkprod					float				NULL,	--֧Ʊ��Ʒ                                                 
		 checktrans					float				NULL,	--֧Ʊ(���춯)                                       
		 checkbackcard				float				NULL,	--֧Ʊ(�˿�)                                           
		 checktotal					float				NULL,	--֧Ʊ�ϼ�(�۳�֧Ʊ�˿�)                                   
		                               
		 zftservice					float				NULL,	--ָ��ͨ����                                                 
		 zftprod					float				NULL,	--ָ��ͨ��Ʒ                                                 
		 zfttrans					float				NULL,	--ָ��ͨ(���춯)                                       
		 zftbackcard				float				NULL,	--ָ��ͨ(�˿�)                                           
		 zfttotal					float				NULL,	--ָ��ͨ�ϼ�(�۳�֧��ͨ�˿�)                                 
		                               
		 ockservice					float				NULL,	--oK������                                                 
		 ockkprod					float				NULL,	--oK����Ʒ                                                 
		 ocktrans					float				NULL,	--oK��(���춯)                                       
		 ockbackcard				float				NULL,	--oK��(�˿�)                                           
		 ocktotal					float				NULL,	--oK���ϼ�(�۳�oK���˿�) 
		 
		 tgkservice					float				NULL,	--�Ź�������                                                 
		 tgkkprod					float				NULL,	--�Ź�����Ʒ                                   
		 tgktrans					float				NULL,	--�Ź���(���춯)                                                  
		 tgktotal					float				NULL,	--�Ź����ϼ�                                
	
		 
		 totalcardtrans				float				NULL,	--���춯(������,����ֵ,������)	
		                           
		 cashchangesale				float				NULL,	--�ֽ�һ�����                          
		 bankchangesale				float				NULL,	--���п��һ����� 
		  
		 cashbytmksale				float				NULL,	--�ֽ����뿨����                              
		 bankbytmksale				float				NULL,	--���п����뿨����                              
		 checkbytmksale				float				NULL ,	--֧Ʊ���뿨����                              
		 fingerbytmksale			float				NULL,	--ָ��ͨ���뿨����                              
		 okpqypwybytmksale			float				NULL,	--oK�����뿨����
		  
		 cashhezprj					float				NULL,	--�ֽ������Ŀ                           
		 bankhezprj					float				NULL,	--���п�������Ŀ                  
		 sumcashhezprj				float				NULL,	--�ֽ������Ŀ(����֧�����ֽ�)                                    
		                                                                                                  
		                                                  
		                                                                                                             
		 cardsalesservices          float				NULL,	--��������                                                 
		 cardsalesprod				float				NULL,	--������Ʒ 
		 staffsallprod				float				NULL,	--Ա����Ʒ             
		 acquisitioncardservices	float				NULL,	--�չ�ת������ 
		 costpointtotal				float				NULL,	--���ַ���   
		 cashdyservice				float				NULL,   --�ֽ����ȯ����                              
		 prjdyservice				float				NULL,   --��Ŀ����ȯ����
		 tmkservice					float				NULL,   --�������뿨����  
		 tmksendservice				float				NULL,   --�������뿨����  
		 managesigning				float				NULL,	--����ǩ��                                         
		 payoutRegister				float				NULL,	--֧���Ǽ�  
		CONSTRAINT PK_detial_trade_byday_fromshops PRIMARY KEY CLUSTERED(shopId,dateReport)                                    
)         

---------------------------------------
----compclasstraderesult-- --  ����ҵ��--���ݽ���
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='compclasstraderesult')
CREATE table compclasstraderesult(                              
		  compid			varchar(10) not null,   
		  ddate				varchar(10) not null,                             
		  beautyeji			float			null,                              
		  hairyeji			float			null,                              
		  footyeji			float			null,                              
		  fingeryeji		float			null,                              
		  totalyeji			float			null,                              
		  realbeautyeji		float			null,                              
		  realhairyeji		float			null,                              
		  realfootyeji		float			null,                              
		  realfingeryeji	float			null,                              
		  realtotalyeji		float			null,
		  CONSTRAINT PK_compclasstraderesult PRIMARY KEY CLUSTERED(compid,ddate)                              
)  
go






---------------------------------------
-----staffchangeinfo   �ŵ�Ա���춯��Ϣ CREATE by liujie 20130628
---------------------------------------

if not exists(select 1 from sysobjects where type='U' and name='staffchangeinfo')
CREATE tAbLE    staffchangeinfo     
(
	changecompid			varchar(10)     not null,	--��˾��
	changebillid			varchar(20) 	not null,	--���뵥��
	changetype				int				not	null,	--��������  0-н�ʵ��� 1--��ְ���� 2--��ְ���� 3--�ػع�˾���� 4--�������,5--�������,6--������
	changestaffno			varchar(20)			null,	--�춯ǰԱ�����
	appchangecompid			varchar(10)			null,	--�춯ǰ���빫˾
	staffpcid				varchar(20)			null,	--Ա������֤
	staffphone				varchar(20)			null,   --�ֻ�����
    staffmangerno			varchar(20)			null,   --Ա���ڲ����
	changedate				varchar(8)			null,	--��������
	validatestartdate		varchar(8)			null,	--��changetype=0 ��ʱ���ֵ�ǿ������õ����� 
														--��changetype=1 ��ʱ���ֵ��ʵ����ְ���� 
														--��changetype=2 ��ʱ���ֵ��ʵ����ְ���� 
														--��changetype=3 ��ʱ���ֵ��ʵ���ػع�˾���� 
														--��changetype=4 ��ʱ���ֵ�� ��ٿ�ʼ���� 
														--��changetype=5 ��ʱ���ֵ�Ǳ��������ʼ���� 
														--��changetype=6 ��ʱ���ֵ�ǿ�������ʼ���� 
	validateenddate			varchar(8)			null,	--��changetype=4 ��ʱ���ֵ�� ��ٽ������� --��fhb02i=3��ʱ���ֵ�ؼ�ʱ��
	beforedepartment		varchar(20)			null,	--�춯ǰ����
	beforepostation			varchar(10)			null,	--�춯ǰְλ
	beforesalary			float				null,	--�춯ǰн��
    beforesalarytype		int					null,	--�춯ǰ 0��˰ǰ 1 ˰��  
    beforeyejitype			varchar(5)			null,   --�춯ǰҵ����ʽ 1-����ҵ��  2-����ҵ��  3-��ҵ��
    beforeyejirate			float				null,   --�춯ǰҵ��ϵ��
    beforeyejiamt			float				null,   --�춯ǰҵ������
    aftercompid				varchar(20)			null,	--�춯���ŵ�
    afterstaffno			varchar(20)			null,	--�춯�󹤺�
    afterdepartment			varchar(20)			null,	--�춯����
	afterpostation			varchar(10)			null,	--�춯��ְλ
	aftersalary				float				null,	--�춯��н��
    aftersalarytype			int					null,	--�춯�� 0��˰ǰ 1 ˰��  
    afteryejitype			varchar(5)			null,   --�춯��ҵ����ʽ 1-����ҵ��  2-����ҵ��  3-��ҵ��
    afteryejirate			float				null,   --�춯��ҵ��ϵ��
    afteryejiamt			float				null,   --�춯��ҵ������
    leaveltype				int					null,	--ְ����  1 ������ְ 2 �Զ���ְ
	checkcompid				varchar(10)			null,	--��˹�˾
	checkstaffid			varchar(20)			null,	--�ŵ������
	checkdate				varchar(8)			null,	--�ŵ��������
	checkflag				int					null,	--�ŵ��Ƿ��Ѿ���� 0--û����� 1--�Ѿ����
	
	checkinheadcompid		varchar(10)			null,	--�ܲ���˹�˾
	checkinheadstaffid		varchar(20)			null,	--�ܲ������
	checkinheaddate			varchar(8)			null,	--�ܲ��������
	checkinheadflag			int					null,	--�ܲ��Ƿ��Ѿ���� 0--û����� 1--�Ѿ����
	
	comfirmcompid			varchar(10)			null,	--������˹�˾
	comfirmstaffid			varchar(20)			null,	--���������
	comfirmdate				varchar(8)			null,	--�����������
	comfirmflag				int					null,	--�����Ƿ��Ѿ���� 0--û����� 1--�Ѿ���� 2 �Ѿ�����
	billflag				int					null,	--�������״̬  0 �Ǽ� 1--�ŵ����״̬ 2--�ܲ����״̬ 3--�������״̬ 8 ����Ч 5 �Ѳ���
	remark					varchar(200)		null,	--��ע
	CONSTRAINT PK_staffchangeinfo PRIMARY KEY CLUSTERED(changecompid, changebillid,changetype)
)
go

---------------------------------------
-----staffrewardinfo   �ŵ�Ա��������Ϣ CREATE by liujie 20130628
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='staffrewardinfo')
create table staffrewardinfo
(
	entrycompid 				varchar(10) 	        not null,		--	�Ǽǹ�˾
	entrybillid 				varchar(20)				not null,		--	�Ǽǵ���
	entryflag 					int							null,		--	������־   0--��   2--��
	handcompid					varchar(10)					null,		--	����Ա�������ŵ�
	handstaffid 				varchar(20)					null,		--	����Ա��
	handstaffinid 				varchar(20)					null,		--	����Ա��
	entryreason					varchar(200)				null,		--����ԭ��
	entrydate 					varchar(8)					null,		--�Ǽ�����
	entrytype 					varchar(8)					null,		--��������
	billflag					int							null,		--�������� ��־ 0-�Ǽǣ�1-�ŵ���� 2�ܲ���� 
	checkrewardstaff 			varchar(20)					null,		--�ŵ꽱��Ա���� 
	checkrewardstaffname 		varchar(40)					null,		--�ŵ꽱��Ա������ 
	checkrewardremark			varchar(800)				null,		--�ŵ꽱����ע
	checkrewardamt				float						null,		--�ŵ꽱�����
	checkpersonid				varchar(20)					null,		--�ŵ�������
	checkdate					varchar(8)					null,		--�ŵ���������
	checkflag					int							 null,		--�ŵ��ʵ����������־ 0-δ��ʵ��1-�Ѻ�ʵ
	checkinheadrewardstaff 		varchar(20)					null,		--�ܲ�����Ա���� 
	checkinheadrewardstaffname 	varchar(40)					null,		--�ܲ�����Ա������ 
	checkinheadrewardremark		varchar(800)				null,		--�ܲ�������ע
	checkinheadrewardamt		float						null,		--�ܲ��������
	checkinheadpersonid			varchar(20)					null,		--�ܲ�������
	checkinheaddate				varchar(8)					null,		--�ܲ���������
	checkinheadflag				int							 null,		--�ܲ���ʵ����������־ 0-δ��ʵ��1-�Ѻ�ʵ
	invalid						int							null,		--�Ƿ�����
	constraint PK_staffrewardinfo	primary key clustered(entrycompid,entrybillid)
) 
go

--��������
if not exists(select 1 from sysobjects where type='U' and name='mstaffrewardinfo')
create table mstaffrewardinfo
(
	entrycompid 				varchar(10) 	        not null,		--	�Ǽǹ�˾
	entrybillid 				varchar(20)				not null,		--	�Ǽǵ���
	entryflag 					int							null,		--	������־   0--��   1--��
	handcompid					varchar(10)					null,		--	����Ա�������ŵ�
	billflag					int							null,		--	�������� ��־ 0-�Ǽǣ�1-�ŵ���� 2 �ŵ겵��
	invalid						int							null,		--	�Ƿ�����
	operationer					varchar(20)					null,		--	������
	operationdate				varchar(10)					null,		--	����ʱ��
	constraint PK_mstaffrewardinfo	primary key clustered(entrycompid,entrybillid)
) 
go





--������ϸ
if not exists(select 1 from sysobjects where type='U' and name='dstaffrewardinfo')
create table dstaffrewardinfo
(
	entrycompid 				varchar(10) 	        not null,		--	�Ǽǹ�˾
	entrybillid 				varchar(20)				not null,		--	�Ǽǵ���
	entryseqno					float					not null, 		--  ��ˮ�� 
	handstaffid 				varchar(20)					null,		--	����Ա��
	handstaffinid 				varchar(20)					null,		--	����Ա��
	entryreason					varchar(200)				null,		--  ����ԭ��
	entrydate 					varchar(8)					null,		--  ��������
	entrytype 					varchar(8)					null,		--  ��������
	rewardamt					float						null,		--�ܲ��������
	billflag					int							null,		--	�������� ��־ 0-�Ǽǣ�1-�ŵ���� 2 �ŵ겵��
	constraint PK_dstaffrewardinfo	primary key clustered(entrycompid,entrybillid,entryseqno)
) 
go




--�ŵ�Ա����������
if not exists(select 1 from sysobjects where type='U' and name='mstaffsubsidyinfo')
create table mstaffsubsidyinfo
(
	entrycompid 				varchar(10) 	        not null,		--	�Ǽǹ�˾
	entrybillid 				varchar(20)				not null,		--	�Ǽǵ���
	handcompid					varchar(10)					null,		--	�ŵ�
	handstaffid 				varchar(20)					null,		--	Ա��
	handstaffinid 				varchar(20)					null,		--	Ա��
	subsidyamt					float						null,		--  ���׶��
	subsidyflag					int							null,		--  ���׷�ʽ ȫ������ ��������
	conditionnum				int							null,		--  ����������
	billflag					int							null,		--	�������� ��־ 0-�Ǽǣ�1-���  2 ���� 3 ����
	invalid						int							null,		--	�Ƿ�����
	operationer					varchar(20)					null,		--	������
	operationdate				varchar(10)					null,		--	����ʱ��
	startdate					varchar(10) 				null,		--	��ʼ����
	enddate						varchar(10) 				null,		--	��������
	subsidycondition			varchar(100) 				null,		--	����������ע
	subsidyconditiontext		varchar(200) 				null,		--	����������ע
	appstaffname				varchar(20)					null,		--	����������
	checkstaffname				varchar(20)					null,		--	���������	
	constraint PK_mstaffsubsidyinfo	primary key clustered(entrycompid,entrybillid)
) 
go




--������ϸ
if not exists(select 1 from sysobjects where type='U' and name='dstaffsubsidyinfo')
create table dstaffsubsidyinfo
(
	entrycompid 				varchar(10) 	        not null,		--	�Ǽǹ�˾
	entrybillid 				varchar(20)				not null,		--	�Ǽǵ���
	entryseqno					float					not null, 		--  ��ˮ�� 
	handstaffinid 				varchar(20)					null,		--	Ա��
	subsidytype					int							null,		--	���׷�ʽ
	subsidyamt					float						null,		--	���׶��
	
	constraint PK_dstaffsubsidyinfo	primary key clustered(entrycompid,entrybillid,entryseqno)
) 
go


--�ŵ�Ա��ָ������
if not exists(select 1 from sysobjects where type='U' and name='mstafftargetinfo')
create table mstafftargetinfo
(
	entrycompid 				varchar(10) 	        not null,		--	�Ǽǹ�˾
	entrybillid 				varchar(20)				not null,		--	�Ǽǵ���
	handcompid					varchar(10)					null,		--	�ŵ�
	handstaffid 				varchar(20)					null,		--	Ա��
	handstaffinid 				varchar(20)					null,		--	Ա��
	targemode					int							null,		--  ���׷�ʽ 1 ��� 2 ����
	targeyejitype				int							null,		--  ��ȡҵ����ʽ 1 ������ҵ�� 2 ����ʵҵ�� 3������ҵ��
	targeamt					float						null,		--  ���׶��
	targeflag					int							null,		--  ���׷�ʽ ȫ������ ��������
	conditionnum				int							null,		--  ����������
	billflag					int							null,		--	�������� ��־ 0-�Ǽǣ�1-���  2 ����
	invalid						int							null,		--	�Ƿ�����
	operationer					varchar(20)					null,		--	������
	operationdate				varchar(10)					null,		--	����ʱ��
	startdate					varchar(10) 				null,		--	��ʼ����
	enddate						varchar(10) 				null,		--	��������
	subsidycondition			varchar(100) 				null,		--	����������ע
	subsidyconditiontext		varchar(200) 				null,		--	����������ע
	constraint PK_mstafftargetinfo	primary key clustered(entrycompid,entrybillid)
) 
go




--ָ����ϸ
if not exists(select 1 from sysobjects where type='U' and name='dstafftargetinfo')
create table dstafftargetinfo
(
	entrycompid 				varchar(10) 	        not null,		--	�Ǽǹ�˾
	entrybillid 				varchar(20)				not null,		--	�Ǽǵ���
	entryseqno					float					not null, 		--  ��ˮ�� 
	handstaffinid 				varchar(20)					null,		--	Ա��
	targettype					int							null,		--	ָ�귽ʽ
	targetamt					float						null,		--	ָ����
	startdate					varchar(10) 				null,		--	��ʼ����
	enddate						varchar(10) 				null,		--	��������
	constraint PK_dstafftargetinfo	primary key clustered(entrycompid,entrybillid,entryseqno)
) 
go


---------------------------------------
-----noperformanceemp   �ŵ���ҵ����Ա CREATE by liujie 20130628
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='noperformanceemp')
create table noperformanceemp
(
		compid			varchar(10)		null,
		empid			varchar(20)		null,
		empinnerno		varchar(20)		null,
		ddate			varchar(10)		null,
)
---------------------------------------
-----staff_work_salary   �ŵ�Ա����ɱ�
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='staff_work_salary')
create table staff_work_salary
(
		compid				varchar(10)			NOT NULL,	--�ŵ���
		person_inid			varchar(20)			NOT NULL,	--Ա���ڲ����
		salary_date			varchar(10)			NOT NULL,	--��������
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
		staffcashyeji		float				 NULL,
		stafftotalyeji		float				 NULL,
		constraint PK_staff_work_salary	primary key clustered(compid,person_inid,salary_date)
) 

---------------------------------------
-----mgoodsinsert    -- ��Ʒ��ⵥ����
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='mgoodsinsert')
CREATE TABLE    mgoodsinsert              
(
	insercompid			varchar(10)				NOT NULL	,   --��˾���
	inserbillid			varchar(30)				NOT NULL	,   --��ⵥ��
	inserdate			varchar(8)					NULL    ,   --�������
	insertime			varchar(8)					NULL    ,   --���ʱ��
	inserwareid			varchar(10)					NULL    ,   --�ֿ����
	inserstaffid		varchar(10)					NULL    ,   --�ɹ���Ա
	insertype			int							NULL    ,   --�������(1- ������� 2- �̵���,3-�˻�)
	checkbillflag		int							NULL    ,	--�Ƿ�Ʊ 0-û�� 1--��Ҫ
	checkbillno			varchar(50)					NULL    ,	--��Ʊ���
	storesendbill		varchar(30)					NULL	,	--�ջ�����
    exitstoreno			varchar(20)					NULL	,	--�˻��ŵ�
    exidbillno			varchar(10)					NULL	,	--�ŵ�ֿ�
    billflag			int							NULL	,	--����״̬ 0--�������  1--����  2--����
    inseropationerid	varchar(20)					NULL    ,   --��������Ա
	inseropationdate	varchar(10)					NULL    ,   --��������
	invalid				int							NULL	,	--�Ƿ����� 0--����  1--����
	CONSTRAINT PK_mgoodsinsert PRIMARY KEY CLUSTERED(insercompid,inserbillid)
)
go 
---------------------------------------
-----dgoodsinsert    -- ��Ʒ��ⵥ��ϸ
---------------------------------------
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

---------------------------------------
  -- dgoodsinsertpc    --��Ʒ������ι���      
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dgoodsinsertpc')
create table dgoodsinsertpc
(
	insercompid			varchar(10)				NOT NULL,		--��˾���
	insergoodsno		varchar(20)				NOT NULL,		--��Ʒ���
	inserbillid 		varchar(20)				NOT NULL,		--��������
	inserseqno			float					NOT NULL,		--���
	producedate			varchar(8)					NULL,		--��������
	expireddate			varchar(8)					NULL,		--�����ڵ�������
	curlavecount		float						NULL,		--������ǰʣ������
	inserwareid			varchar(10)					NULL    ,   --�ֿ����
	inserdate			varchar(8)					NULL    ,   --�������
	CONSTRAINT PK_dgoodsinsertpc PRIMARY KEY CLUSTERED(insercompid,insergoodsno,inserbillid,inserseqno)
)
go

-----mgoodsouter    -- ��Ʒ���ⵥ����
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='mgoodsouter')
CREATE TABLE    mgoodsouter   
(
	outercompid			varchar(10)     NOT NULL	,   --��˾���
	outerbillid			varchar(30)		NOT NULL	,   --���ⵥ��
	outerdate			varchar(8)			NULL	,   --��������
	outertime			varchar(8)			NULL	,   --��������
	outerwareid			varchar(10)			NULL	,   --�ֿ����
	outertype			int					NULL	,	--��������(1- �������� 2- �̵��� 3-��Ӧ���˻�)
	revicetype			int					NULL    ,   --��ȡ��� 1:Ա�� 2�ŵ�
	orderbilltype   	int  				NULL,		--�ɹ������� Ա��/�ŵ� 
	outerstaffid		varchar(10)			NULL	,   --�ɹ���Ա
	sendbillid			varchar(40)			NULL    ,   --��������
	billflag			int					NULL	,	--����״̬ 0--�������  1--����  2--����
    outeropationerid	varchar(20)			NULL    ,   --��������Ա
	outeropationdate	varchar(10)			NULL    ,   --��������
	invalid				int					NULL	,	--�Ƿ����� 0--����  1--����
	CONSTRAINT PK_mgoodsouter PRIMARY KEY CLUSTERED(outercompid,outerbillid)
)
go 
---------------------------------------
-----dgoodsouter    -- ��Ʒ���ⵥ��ϸ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dgoodsouter')
CREATE TABLE    dgoodsouter              
(
	outercompid			varchar(10)			NOT NULL,   --��˾���
	outerbillid			varchar(30)			NOT NULL,   --���ⵥ��
	outerseqno			float				NOT NULL,   --���
	outergoodsno		varchar(20)				NULL,   --��Ʒ����
	standunit			varchar(5)				NULL,   --��׼��λ
	standprice			float					NULL,   --����(��׼��λ)
	curgoodsstock		float					NULL,   --�ֿ������(���ⵥλ)
	outerunit			varchar(5)				NULL,   --���ⵥλ
	outercount			float					NULL,   --(���ⵥλ)����
	outerprice			float					NULL,   --����(���ⵥλ)
	outeramt			float					NULL,   --���
    outerrate			float					NULL,   --�ۿ�  Ĭ��1
   	frombarcode			varchar(20)				NULL,   --��ʼ����
	tobarcode			varchar(20)				NULL,   --��������
	CONSTRAINT PK_dgoodsouter PRIMARY KEY CLUSTERED(outercompid,outerbillid,outerseqno)
)
go 

---------------------------------------
  -- dgoodsouterpc    --��Ʒ�������ι���      
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dgoodsouterpc')
create table dgoodsouterpc
(
	outercompid			varchar(10)			NOT NULL,	--��˾���
	outerbillid			varchar(30)			NOT NULL,	--���ⵥ��
	outergoodsno 		varchar(20)			NOT NULL,	--��Ʒ���
	outerseqno			float				NOT NULL,   --���
	inserbillid 		varchar(20)				NULL,	--��������
	outercount			float					NULL,	--������������
	outerprice			float					NULL,	--�������ⵥ��	
	CONSTRAINT PK_dgoodsouterpc PRIMARY KEY CLUSTERED(outercompid,outerbillid,outergoodsno,outerseqno)
)
go


---------------------------------------
-----mgoodsstockinfo    -- ��Ʒ����ⵥ����
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='mgoodsstockinfo')
CREATE TABLE mgoodsstockinfo     
(
	changecompid		varchar(10)				NOT NULL,   -- ��˾���             
	changetype			varchar(2)				NOT NULL,   -- �춯�� (1-���,2-����,3-����,4-����)                
	changebillno		varchar(30)				NOT NULL,   -- �춯����             
	changedate			varchar(8)					NULL,   -- �춯����                
	changetime			varchar(8)					NULL,   -- �춯ʱ��
	changewareid		varchar(10)					NULL,   -- �ֿ����(�����Դ�Ϊ׼,����λ����)             
	changeoption		int							NULL,   --������ⷽʽ
	changestaffid		varchar(20)					NULL,   --��������˻�������Ա
	changeflag			int							NULL,   --��ϸ���(Ĭ��Ϊ1,Ա����ȡ)

	CONSTRAINT PK_mgoodsstockinfo PRIMARY KEY CLUSTERED (changecompid, changetype, changebillno)
)
go
---------------------------------------
-----dgoodsstockinfo    -- ��Ʒ����ⵥ��ϸ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dgoodsstockinfo')
CREATE TABLE dgoodsstockinfo          -- ������춯ͳ����ϸ��(�����춯������ϸ update) 
(
	changecompid		varchar(10)				NOT NULL,   -- ��˾���             
	changetype			varchar(2)				NOT NULL,   -- �춯�� (1-���,2-����,3-����,4-����)                
	changebillno		varchar(30)				NOT NULL,   -- �춯����      
	changeseqno			float					NOT NULL,   -- ������ˮ��       
	changegoodsno		varchar(30)					NULL,   -- ��Ʒ����     
	standunit			varchar(8)					NULL,   -- ������ⵥλ
	standcount			float						NULL,   -- ��׼��λ����     
	standprice			float						NULL,   -- ��׼��λ����     
	producedate			varchar(8)					NULL,   -- ��������
	changeunit			varchar(8)					NULL,   -- ������ⵥλ
	changeprice			float						NULL,   -- ������ⵥλ
	changecount			float						NULL,   -- ��ⵥλ����ⵥλ����
	changeamt			float						NULL,   -- ���
	CONSTRAINT PK_dgoodsstockinfo PRIMARY KEY CLUSTERED (changecompid, changetype, changebillno, changeseqno)
)
go

---------------------------------------
-----dgoodssetlebegin  --��Ʒ�ڳ������
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dgoodssetlebegin')
CREATE TABLE dgoodssetlebegin          -- ������춯ͳ����ϸ��(�����춯������ϸ update) 
(
	changecompid		varchar(10)				NOT NULL,   -- �����ŵ�          
	changegoodsno		varchar(30)				NOT	NULL,   -- ��Ʒ����   
	begindate			varchar(10)				NOT	null,	-- ��������  
	begincount			float						NULL,   -- ��������
	beginamt			float						NULL,   -- ���
	CONSTRAINT PK_dgoodssetlebegin PRIMARY KEY CLUSTERED (changecompid, changegoodsno,begindate)
)
go

---------------------------------------
-----dgoodsbatchbegin  --��Ʒ�ڳ����ν����
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dgoodsbatchbegin')
CREATE TABLE dgoodsbatchbegin          -- ������춯ͳ����ϸ��(�����춯������ϸ update) 
(
	changecompid		varchar(10)				NOT NULL,   -- �����ŵ�          
	changegoodsno		varchar(30)				NOT	NULL,   -- ��Ʒ����   
	begindate			varchar(10)				NOT	null,	-- �������� 
	beginbillno			varchar(30)				NOT	NULL,   -- ���㵥��
	beginprice			float					NOT	NULL,   -- ����
	begincount			float						NULL,   -- ����

	CONSTRAINT PK_dgoodsbatchbegin PRIMARY KEY CLUSTERED (changecompid, changegoodsno,begindate,beginbillno,beginprice)
)
go


---------------------------------------
-----dgoodsbarinfo    --��ƷΨһ�����
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dgoodsbarinfo')
CREATE TABLE dgoodsbarinfo         						
(     
	goodsno				varchar(20)			NOT NULL,				-- ��Ʒ��� 
	goodsbarno			varchar(20)			NOT NULL,				-- Ψһ����
	barnostate			int						NULL,				-- ����״̬ 0:���� 1:��� 2:����/���� 3:���� 4:���� 5:�� 6:�˻���
	createdate			varchar(10)				NULL,				-- ��������
	createstaffno		varchar(20)				NULL,				-- ���ɲ�����
	inserdate			varchar(10)				NULL,				-- �������
	inserbillno			varchar(20)				NULL,				-- ��ⵥ��
	outerdate			varchar(10)				NULL,				-- ����/��������
	outerbill			varchar(20)				NULL,				-- ����/���ⵥ��
	receivestore		varchar(10)				NULL,				-- �ջ��ŵ�
	costdate			varchar(10)				NULL,				-- ��������/��������
	costbillo			varchar(20)				NULL,				-- ���ѵ���/���ĵ���
	coststore			varchar(10)				NULL				-- �����ŵ�
	CONSTRAINT PK_dgoodsbarinfo PRIMARY KEY CLUSTERED (goodsno,goodsbarno)
)
go  

---------------------------------------
-----staffkqrecordinfo    --Ա�������
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='staffkqrecordinfo')
CREATE table staffkqrecordinfo 
(
	seqno				int identity(1,1)	Not NULL,
	machineid			varchar(20)				NULL,   --���ڻ���
	personid			varchar(10)				NULL,	--������ָ��
	stat				int						NULL,	--����״̬	
	ddate				varchar(10)				NULL,	--��������
	ttime				varchar(10)				NULL,	--����ʱ��
	worktype			int						NULL,	--		
	operationer			varchar(20)				NULL,	--��ȡ������Ա
	operationdate		varchar(10)				NULL,	--��ȡ��������
	invalid				int						NULL	,	--�Ƿ����� 0--����  1--����
	checkdate			varchar(10)				null	,
	checkuseid			varchar(20)				null	,
	checkflag			int						null	,   -- 0δ����  1 �Ѹ���
	downloaddate		varchar(10)				null	,
	CONSTRAINT PK_staffkqrecordinfo PRIMARY KEY NONCLUSTERED(seqno)
)
go


if not exists(select 1 from sysobjects where type='U' and name='staffkqrecordinfobak')
CREATE table staffkqrecordinfobak
(
	seqno				int identity(1,1)	Not NULL,
	machineid			varchar(20)				NULL,   --���ڻ���
	personid			varchar(10)				NULL,	--������ָ��
	stat				int						NULL,	--����״̬	
	ddate				varchar(10)				NULL,	--��������
	ttime				varchar(10)				NULL,	--����ʱ��
	worktype			int						NULL,	--		
	operationer			varchar(20)				NULL,	--��ȡ������Ա
	operationdate		varchar(10)				NULL,	--��ȡ��������
	invalid				int						NULL	,	--�Ƿ����� 0--����  1--����
	checkdate			varchar(10)				null	,
	checkuseid			varchar(20)				null	,
	checkflag			int						null	,   -- 0δ����  1 �Ѹ���
	CONSTRAINT PK_staffkqrecordinfobak PRIMARY KEY NONCLUSTERED(seqno)
)
go

---------------------------------------
-----mgoodsinventory     -- ��Ʒ�̵㵥����
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='mgoodsinventory')
CREATE TABLE    mgoodsinventory              
(
	inventcompid			varchar(10)			NOT NULL,			--��˾���
	inventbillid			varchar(30)			NOT NULL,			--�̵㵥��
	inventdate				varchar(8)				NULL    ,		--�̵�����
	inventtime				varchar(8)				NULL    ,		--�̵�����
	inventwareid			varchar(10)				NULL    ,		--�ֿ����
	inventstaffid			varchar(10)				NULL    ,		--�̵���Ա����
	inventopationerid		varchar(20)				NULL    ,		--��������Ա
	inventopationdate		varchar(10)				NULL    ,		--��������
	inventinserbillid		varchar(20)				NULL    ,		--��ⵥ��
	inventouterbillid		varchar(20)				NULL    ,		--���ⵥ��
	invalid					int						NULL	,		--�Ƿ�����
	inventflag				int						NUll	,		--�Ƿ��̵�� 0δ���� 1 �ѱ��� 2���̵�
	CONSTRAINT PK_mgoodsinventory PRIMARY KEY CLUSTERED(inventcompid,inventbillid)
)
go 


---------------------------------------
-----dgoodsinventory     -- ��Ʒ�̵㵥��ϸ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dgoodsinventory')
CREATE TABLE    dgoodsinventory             
(
	inventcompid			varchar(10)			NOT NULL,   --��˾���
	inventbillid			varchar(30)			NOT NULL,   --�̵㵥��
	inventseqno				float				NOT NULL,   --���
	inventgoodsno			varchar(20)				NULL,   --��Ʒ����
	inventunit				varchar(5)				NULL,   --������λ
	inventcount				float					NULL,   --�̵�����
	curstockcount			float					NULL,   --�ֿ����
	discount				float					NULL,   --��������
	inventfrombarno			varchar(20)				NULL    ,--��ʼ�����
	inventtobarno			varchar(20)				NULL    ,--���������
	inventcreateflag		int						NULL	,--�Ƿ����ɻ�����
	inserunit				varchar(10)				NULL	,--������λ
	inserprice				float					NUll	,--��������
	outerunit				varchar(10)				NULL	,--���ⵥλ
	outerprice				float					NUll	,--���ⵥ��
	CONSTRAINT PK_dgoodsinventory PRIMARY KEY CLUSTERED(inventcompid,inventbillid,inventseqno)
)
go

---------------------------------------
-----mgoodsorderinfo     --������������
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='mgoodsorderinfo')
create table mgoodsorderinfo	
(
	ordercompid 			varchar(10)			NOT NULL,		--��˾���
	orderbillid				varchar(30)			NOT NULL,		--������
	orderdate				varchar(8)				NULL,		--��������
	ordertime				varchar(8)				NULL,		--�ɹ�ʱ��
	orderstaffid			varchar(20)				NULL,		--�ɹ���
	orderstate				int						NULL,		--����״̬  0δ���� 1�Ѿ�ȷ��(����) 2�����µ� 3ȫ������ 4���ջ� 5 ����
	downordercompid			varchar(20)				NULL,		--�µ��ֹ�˾
	downorderstaffid		varchar(20)				NULL,		--�µ���
	downorderdate			varchar(8)				NULL,		--�µ�����
	downordertime			varchar(8)				NULL,		--�µ�ʱ��
	sendbillno				varchar(80)				NULL,		--������
	revicebillno			varchar(80)				NULL,		--�ջ���
	ordersource   			int  					NULL,		--��Ʒ��Դ0�ϼ��ֿ�,1��Ӧ��
	storewareid				varchar(20)				NULL,		--�ŵ�Ĳֿ���
	headwareid   			varchar(100)			NULL,		--�ܲ��Ĳֿ���
	headwarename   			varchar(100)			NULL,		--�ܲ��Ĳֿ���
	orderbilltype   		int  					NULL,		--�ɹ������� Ա��/�ŵ� 
	orderopationerid		varchar(20)				NULL,		--��������Ա
	orderopationdate		varchar(10)				NULL,		--��������	
	invalid   				int  					NULL,		--�Ƿ�����
	arrivaldate 			varchar(10) 			NULL		--��������
	constraint PK_mgoodsorderinfo  primary key clustered(ordercompid,orderbillid)
)
go
create nonclustered index idx_mgoodsorderinfo_date on mgoodsorderinfo(ordercompid,orderdate)
go


---------------------------------------
-----dgoodsorderinfo     --����������ϸ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dgoodsorderinfo')
create table dgoodsorderinfo
(
	ordercompid				varchar(10)			NOT NULL,		--��˾���
	orderbillid				varchar(30)			NOT NULL,		--������
	orderseqno				float				NOT NULL,		--��Ʒ���
	ordergoodsno			varchar(20)				NULL,		--��Ʒ���
	ordergoodscount			float					NULL,		--����
	ordergoodsunit			varchar(5)				NULL,		--��λ
	ordergoodsprice			float					NULL,		--��������
	ordergoodsamt			float					NULL,		--���
	headstockcount			float					NULL,		--�ܲ����
	downordercount			float					NULL,		--���µ���
	downorderamt			float					NULL,		--���µ����
	nodowncount				float					NULL,		--δ�µ���
	norevicecount			float					NULL,		--δ�ջ���
	supplierno				varchar(20)				NULL,		--��Ӧ�̱��
	headwareno				varchar(20)				NULL,		--�ϼ��ֿ���
	goodssource				int  default(0)			NULL,		--��Ʒ��Դ0�ϼ��ֿ�,1��Ӧ��
	ordergoodstype			int						NULL,		-- 0δ���� 1�Ѿ�ȷ��(����) 2�����µ� 3ȫ������ 4���ջ� 
	ordermark				varchar(200)			NULL,		-- �µ�Ƿ����ע
	constraint pk_dgoodsorderinfo primary key clustered(ordercompid,orderbillid,orderseqno)		
)
go




---------------------------------------
-----mgoodsallotmentinfo     --�䷢��������
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='mgoodsallotmentinfo')
create table mgoodsallotmentinfo	
(
	entrycompid 			varchar(10)			NOT NULL,		--��˾���
	entrybillid				varchar(30)			NOT NULL,		--�䷢��
	allotmentdate			varchar(8)				NULL,		--�䷢����
	allotmenttime			varchar(8)				NULL,		--�䷢ʱ��
	allotmenttaffid			varchar(20)				NULL,		--�䷢��
	allotmenttype			int						NULL,		--�䷢����
	allotmentcompid			varchar(10)				NULL,		--�䷢�ŵ�
	recevicestaffid			varchar(20)				NULL,		--�ŵ������
	apporderbillno			varchar(20)				NULL,		--�䷢���ɵĲɹ���
	orderopationerid		varchar(20)				NULL,		--��������Ա
	orderopationdate		varchar(10)				NULL,		--��������	
	invalid   				int  					NULL,		--�Ƿ�����
	constraint PK_mgoodsallotmentinfo  primary key clustered(entrycompid,entrybillid)
)
go
create nonclustered index idx_mgoodsallotmentinfo_date on mgoodsallotmentinfo(entrycompid,allotmentdate)
go


---------------------------------------
-----dgoodsallotmentinfo     --�䷢����ϸ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dgoodsallotmentinfo')
create table dgoodsallotmentinfo
(
	entrycompid				varchar(10)			NOT NULL,		--��˾���
	entrybillid				varchar(30)			NOT NULL,		--�䷢����
	allotmentseqno				float				NOT NULL,		--��Ʒ���
	allotmentgoodsno			varchar(20)				NULL,		--��Ʒ���
	allotmentgoodscount			float					NULL,		--����
	allotmentgoodsunit			varchar(5)				NULL,		--��λ
	allotmentgoodsprice			float					NULL,		--�䷢����
	allotmentgoodsamt			float					NULL,		--���
	headstockcount				float					NULL,		--�ܲ����
	supplierno					varchar(20)				NULL,		--��Ӧ�̱��
	headwareno					varchar(20)				NULL,		--�ϼ��ֿ���
	goodssource					int  default(0)			NULL,		--��Ʒ��Դ0�ϼ��ֿ�,1��Ӧ��
	constraint pk_dgoodsallotmentinfo primary key clustered(entrycompid,entrybillid,allotmentseqno)		
)
go

if not exists(select 1 from sysobjects where type='U' and name='dcompallotmentinfo')
create table dcompallotmentinfo
(
	entrycompid				varchar(10)			NOT NULL,			--��˾���
	entrybillid				varchar(30)			NOT NULL,			--�䷢����
	allotmentseqno			float				NOT NULL,			--�䷢���
	allotmentcompno		varchar(20)				NULL,			--�ŵ���
	apporderbillno			varchar(20)				NULL,			--�䷢���ɵĲɹ���
	constraint pk_dcompallotmentinfo primary key clustered(entrycompid,entrybillid,allotmentseqno)		
)
go




---------------------------------------
-----mgoodssendinfo     --�ܲ���������������
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='mgoodssendinfo')
create table mgoodssendinfo	
(
	sendcompid 				varchar(10)				NOT NULL,		--��˾���
	sendbillid				varchar(30)				NOT NULL,		--������
	senddate				varchar(8)				NULL,			--��������
	sendtime				varchar(8)				NULL,			--����ʱ��
	sendstaffid				varchar(20)				NULL,			--������
	sendstate				int						NULL,			--������״̬  0δ���� 1�Ѿ�ȷ��(����) 2������
	storewareid				varchar(20)				NULL,			--�ŵ�Ĳֿ���
	headwareid   			varchar(20)				NULL,			--�ܲ��Ĳֿ���
	orderdate				varchar(8)				NULL,			--��������
	ordertime				varchar(8)				NULL,			--�ɹ�ʱ��
	ordercompid   			varchar(10)	  			NULL,			--�ŵ�ɹ���
	orderbill   			varchar(20)	  			NULL,			--�ŵ�ɹ���
	orderbilltype   		int  					NULL,			--�ɹ������� Ա��/�ŵ� 
	storestaffid			varchar(20)				NULL,			--�ŵ���ϵ��
	storeaddress			varchar(80)				NULL,			--�ŵ��ַ
	sendopationerid			varchar(20)				NULL,			--��������Ա
	sendopationdate			varchar(10)				NULL,			--��������	
	invalid   				int  					NULL,			--�Ƿ�����
	constraint PK_mgoodssendinfo  primary key clustered(sendcompid,sendbillid)
)
go

---------------------------------------
-----dgoodssendinfo     --�ܲ�������������ϸ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dgoodssendinfo')
create table dgoodssendinfo
(
	sendcompid				varchar(10)			NOT NULL,		--��˾���
	sendbillid				varchar(30)			NOT NULL,		--������
	sendseqno				float				NOT NULL,		--��Ʒ���
	sendgoodsno				varchar(20)				NULL,		--��Ʒ���
	sendgoodsunit			varchar(5)				NULL,		--��λ
	ordergoodscount			float					NULL,		--��������
	ordergoodsamt			float					NULL,		--������	
	downordercount			float					NULL,		--���µ���
	nodowncount				float					NULL,		--δ�µ���
	sendgoodprice			float					NULL,		--��������
	sendgoodrate			float					NULL,		--�����ۿ� 
	sendgoodscount			float					NULL,		--������ 
	sendgoodsamt			float					NULL,		--������� 
	frombarcode				varchar(20)				NULL,		--��ʼ����
	tobarcode				varchar(20)				NULL,		--��������
	constraint pk_dgoodssendinfo primary key clustered(sendcompid,sendbillid,sendseqno)		
)
go

---------------------------------------
-----dgoodssendbarinfo     --�ܲ��������������ϸ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dgoodssendbarinfo')
create table dgoodssendbarinfo
(
	sendcompid				varchar(10)			NOT NULL,		--��˾���
	sendbillid				varchar(30)			NOT NULL,		--������
	sendseqno				float				NOT NULL,		--��Ʒ���
	sendgoodsno				varchar(20)				NULL,		--��Ʒ���
	frombarcode				varchar(20)				NULL,		--��ʼ����
	tobarcode				varchar(20)				NULL,		--��������
	sendbarcount			float					NULL,		--��������
	constraint pk_dgoodssendbarinfo primary key clustered(sendcompid,sendbillid,sendseqno)		
)
go


---------------------------------------
-----mgoodsreceipt     --�ŵ��ջ�������
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='mgoodsreceipt')
create table mgoodsreceipt
(
	receiptcompid					varchar(10)			NOT NULL,		--��˾���
	receiptbillid					varchar(30)			NOT NULL,		--�ջ�����
	receiptdate						varchar(8)				NULL,		--�ջ�����
	receipttime						varchar(8)				NULL,		--�ջ�����
	receiptwareid					varchar(10)				NULL,		--�ֿ����
	receiptstaffid					varchar(10)				NULL,		--�ջ���
	receiptsendbillid				varchar(30)				NULL,		--��������
	receiptorderbillid				varchar(30)				NULL,		--������
	orderbilltype   				int  					NULL,			--�ɹ������� Ա��/�ŵ� 
	receiptstate					int						NULL,       --�ջ���״̬��0��δ������1�����ջ�
	receiptopationerid				varchar(20)				NULL,		--��������Ա
	receiptopationdate				varchar(10)				NULL,		--��������
	receiptsenddate					varchar(8)				NULL		--��Ӧ�̷�������
	receiptsupplier 				varchar(20) 			NULL		--��Ӧ�̱���
	constraint pk_mgoodsreceipt primary key clustered(receiptcompid,receiptbillid)
)
go	

---------------------------------------
-----dgoodsreceipt     --�ŵ��ջ���ϸ��
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dgoodsreceipt')
create table dgoodsreceipt	--�ջ�����ϸ��
(
	receiptcompid  			varchar(10)				NOT NULL,		--��˾���
	receiptbillid  			varchar(30)				NOT NULL,		--�ջ�����
	receiptseqno			float					NOT NULL,		--���
	receiptgoodsno			varchar(20)					NULL,		--��Ʒ���
	receiptgoodsunit		varchar(10)					NULL,		--��λ
	receiptprice			float						NULL,		--��׼����(Ϊ����춯)
	receiptgoodscount		float						NULL,		--�ջ�����
	receiptgoodsamt			float						NULL,		--�ջ�����
	sendgoodscount			float						NULL,		--��������
	damagegoodscount		float						NULL,		--������
	debegiidscount			float						NULL,		--Ƿ������
	ordergoodscount			float						NULL		--��������
	constraint pk_dgoodsreceipt primary key clustered(receiptcompid,receiptbillid,receiptseqno)
)			
go



---------------------------------------
-----mreturngoodsinfo     --�ŵ��˻�����
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='mreturngoodsinfo')
create table mreturngoodsinfo
(
	returncompid				varchar(10)			NOT NULL,		--��˾���
	returnbillid				varchar(20)			NOT NULL,		--�˻�����
	returndate					varchar(8)			NULL    ,		--�˻�����
    returntime					varchar(6)			NULL    ,		--�˻�ʱ��  
	returnwareid				varchar(10)			NULL    ,		--�ŵ�ֿ�
	returnstaffid				varchar(10)			NULL    ,		--�˻���Ա
    returnstate					int     			NULL    ,		--����״̬ 0 ���� 1--������� 2--�ܲ����  3--����
    returnopationerid			varchar(20)			NULL,			--��������Ա
	returnopationdate			varchar(10)			NULL,			--��������	
	confirmopationerid			varchar(20)			NULL,			--��˻򲵻���Ա
	confirmopationdate			varchar(10)			NULL,			--��˻򲵻�����	
	confirmcompid				varchar(10)			NULL,			--����ŵ�			
    CONSTRAINT PK_mreturngoodsinfo PRIMARY KEY CLUSTERED(returncompid,returnbillid)
)

---------------------------------------
-----mreturngoodsinfo     --�ŵ��˻���ϸ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dreturngoodsinfo')
create table dreturngoodsinfo
(
	returncompid				varchar(10)			NOT NULL,		--��˾���
	returnbillid				varchar(20)			NOT NULL,		--�˻�����
	returnseqno					float				NOT NULL,		--���
	returngoodsno				varchar(20)				NULL	,	--��Ʒ����
	returngoodsunit				varchar(5)				NULL	,	--�˻���λ
	returncount					float					NULL	,	--�˻�����
    returntype					int						NULL	,	--�˻�����(0-���� 1- �˻����ܲ� 2- �˻�����Ӧ��)
   	revicestoreno				varchar(20)				NULL	,	--�˻���Ӧ�̱��/�ܲ��ֿ����
   	factreturncount				float					NULL	,	--ʵ���˻�����
    factreturnprice				float					NULL	,	--ʵ���˻�����
    factreturnamt				float					NULL	,	--ʵ���˻����
	CONSTRAINT PK_dreturngoodsinfo PRIMARY KEY CLUSTERED(returncompid,returnbillid,returnseqno)
)
GO

---------------------------------------
-----dgoodsreturnbarinfo     --�ܲ��˻����������ϸ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dgoodsreturnbarinfo')
create table dgoodsreturnbarinfo
(
	returncompid				varchar(10)			NOT NULL,		--��˾���
	returnbillid				varchar(30)			NOT NULL,		--������
	returnseqno					float				NOT NULL,		--��Ʒ���
	returngoodsno				varchar(20)				NULL,		--��Ʒ���
	frombarcode					varchar(20)				NULL,		--��ʼ����
	tobarcode					varchar(20)				NULL,		--��������
	returncount					float					NULL,		--��������
	constraint pk_dgoodsreturnbarinfo primary key clustered(returncompid,returnbillid,returnseqno)		
)
go



---------------------------------------
-----mpayoutinfo     --�ŵ�֧���Ǽ�
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='mpayoutinfo')
create table mpayoutinfo
(
	payoutcompid				varchar(10)			NOT NULL,		--��˾���
	payoutbillid				varchar(20)			NOT NULL,		--֧������
	payoutdate					varchar(8)			NULL    ,		--֧������
    payouttime					varchar(6)			NULL    ,		--֧��ʱ��  
	payoutopationerid			varchar(20)			NULL	,		--��������Ա
	payoutopationdate			varchar(10)			NULL	,		--��������
	billstate					int					NULL	,		--����״̬  0 �Ǽ�  1 �ѱ��� 2 ������
    CONSTRAINT PK_mpayoutinfo	PRIMARY KEY CLUSTERED(payoutcompid,payoutbillid)
)
go
create nonclustered index idx_mgoodsorderinfo_date on mpayoutinfo(payoutcompid,payoutdate)
go


---------------------------------------
-----dpayoutinfo     --�ŵ�֧���Ǽ�
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dpayoutinfo')
create table dpayoutinfo
(
	payoutcompid				varchar(10)			NOT NULL,		--��˾���
	payoutbillid				varchar(20)			NOT NULL,		--֧������
	payoutseqno					float				NOT	NULL,		--���
	payoutitemid				varchar(20)			NULL    ,		--֧����Ŀ
	payoutitemamt				float				NULL    ,		--֧�����
	checkbookflag				int 				NULL	,		--���޷�Ʊ   0-�޷�Ʊ,1-�з�Ʊ 2 ����
	checkbookno					varchar(200)		NULL	,		--��Ʊ���
	payoutmark					varchar(400)		NULL	,		--֧����ע
	payoutbillstate				int     			NULL    ,		--����״̬ 0 ���� 1--�ŵ���� 2--����רԱ���  3--�������� 11 �ŵ겵��  22 ����רԱ����  33 ����������
	checkedopationerid			varchar(20)			NULL	,		--�ܲ������Ա
	checkedopationdate			varchar(10)			NULL	,		--�ܲ���˻�����	
	confirmopationerid			varchar(20)			NULL	,		--������˻򲵻���Ա
	confirmopationdate			varchar(10)			NULL	,		--������˻򲵻�����	
    CONSTRAINT PK_dpayoutinfo	PRIMARY KEY CLUSTERED(payoutcompid,payoutbillid,payoutseqno)
)
---------------------------------------
-----accountclosureinfo     --�ŵ���ʱ�
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='accountclosureinfo')
create table accountclosureinfo  
(
	closecompid			varchar(10)	NOT NULL,   --��˾��
	closedate			varchar(8)	NOT NULL,   --��������	
	closeoptioner		varchar(20)	NULL,	    --������
	closeoptiondate		varchar(8)	NULL,	    --��������	
	closeoptiontime		varchar(6)	NULL,		--����ʱ��
	constraint PK_accountclosureinfo primary key(closecompid,closedate)
)
go

---------------------------------------
-----purchaseregister     --�չ����Ǽ�
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='purchaseregister')
CREATE TABLE    purchaseregister               -- �չ����Ǽ�
(
	registercompid 		varchar(10) 		NOT NULL, 		--�Ǽǹ�˾
	registercardno  	varchar(20)			NOT NULL,  	 	--����
	registercardtype   	varchar(10)  		NULL,			--�����
	membername  		varchar(20) 		NULL,    		--����
	memberphone     	varchar(20) 		NULL,    		--�ֻ�����
	memberbrithday     	varchar(10) 		NULL,    		--����
	membersex     		int     			NULL,			--�Ա�
	cardbalance     	float				NULL,			--���
	registerperson		varchar(20)  		NULL,			--�Ǽ���
	registerdate		varchar(8)  		NULL,			--�Ǽ�����
	registertime		varchar(8)  		NULL,			--�Ǽ�ʱ��
	cardvesting			varchar(10)  		NULL,			--��������˾
	registerpcid		varchar(30) 		NULL,   		--����֤����
	CONSTRAINT PK_purchaseregister PRIMARY KEY CLUSTERED(registercompid,registercardno)
)
go



---------------------------------------
----defaultlist--- Ĭ�Ϸ����б�
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='defaultlist')
CREATE table defaultlist
(
  defaultid int identity(1,1) Not NULL,--Ĭ�ϱ��
  defaultname varchar(20),--Ĭ������
  defaultphone varchar(20),--Ĭ�ϵ绰����
  CONSTRAINT PK_defaultlist PRIMARY KEY NONCLUSTERED(defaultid)
)


--������Ϣ����ϸ
if not exists(select 1 from sysobjects where type='U' and name='smgInfo')
CREATE table smgInfo
(
	sendcompid				varchar(10)		Not NULL,	--�ŵ���
	sendbillid              varchar(30)		Not NULL,   --���ݱ��
	senddate				varchar(20)		NUll,		--��������
	sendtime				varchar(20)     NULL,		--����ʱ��
	sendstate				int             NULL,		--����״̬
	userid					varchar(20)		NULL,		--��¼��
	sendcontent				varchar(500)	NULL,		--��������
	CONSTRAINT PK_smgInfo PRIMARY KEY NONCLUSTERED(sendcompid,sendbillid)
)
go

--������ϸ
if not exists(select 1 from sysobjects where type='U' and name='smgdetails')
CREATE table smgdetails
(
	sendcompid  		varchar(30)		Not NULL,   --�ŵ���
	sendbillid  		varchar(30)		Not NULL,   --���ݱ��
	smgbernme		varchar(20)		NULL,		--����
	smgphone		varchar(15)		NULL,		--����
	cardno			varchar(50)		NULL,		--����
	cardtype		varchar(20)		NULL		--������
	CONSTRAINT PK_smgdetails PRIMARY KEY NONCLUSTERED(sendcompid,sendbillid)
)
go

--��������ϸ
if not exists(select 1 from sysobjects where type='U' and name='missioninfo')
CREATE table missioninfo
(
	missionbillid       varchar(30)		Not NULL,   --���ݱ��
	missionname			varchar(20)		NULL,		--��������
	missiontype			varchar(10)		NULL,		--��������
	missionkey			varchar(30)		NULL,		--����ֵ
	missiondetails		varchar(1000)   NULL,		--��������
	templatestate		int				NULL,		--����״̬
	CONSTRAINT PK_missioninfo PRIMARY KEY NONCLUSTERED(missionbillid)
)
go

--������ϸ
if not exists(select 1 from sysobjects where type='U' and name='missiontails')
CREATE table missiontails(
	missionbillid		varchar(30)		Not NULL,	--���ݱ�ţ��������ϵmissioninfo��
	missionnames		varchar(20)		NULL,		--�����͵�����
	missionphone		varchar(20)		NULL		--�����͵��ֻ���
	CONSTRAINT PK_missiontails PRIMARY KEY NONCLUSTERED(missionbillid)
)
go
--���еȴ�
if not exists(select 1 from sysobjects where type='U' and name='callwaiting')
create table callwaiting(
			callid			INT  IDENTITY(1, 1)		PRIMARY KEY,  --�ȴ����
			callbillid		varchar(30)				NOT NULL, --���ݱ��
			calluserid		varchar(50)					NULL,  --��½����+��ϯ
			callon			varchar(20)					NULL,   --����绰����
			calledon		varchar(20)					NULL, --������ĺ���
			agentnum		varchar(20)					NULL, --������ϯ
			offertime		varchar(50)					NULL, --ժ��ʱ��
			calledtime		varchar(50)					NULL, --�һ�ʱ��
			calltime		varchar(50)					NULL, --��½ʱ��
			calltype		int							NULL,           --���ͣ�0��ʾԤԼ��1��ʾ��ѯ��2��ʾ��ʧ��3��ʾͶ�ߣ�4��ʾ�˿���
			callstate		int							NULL,          --״̬��0��ʾδ������1��ʾ������
			callmark		varchar(600)				NULL,
)

--¼��
if not exists(select 1 from sysobjects where type='U' and name='recordinfos')
create table recordinfos(
			callid			INT  IDENTITY(1, 1)		PRIMARY KEY,  --�ȴ����
			callbillids		varchar(30)					NULL, --���ݱ��
			callons			varchar(20)					NULL,  
			calledons		varchar(20)					NULL, 
			starttime		varchar(10)					NULL, 
			endtime			varchar(10)					NULL, 
			agentnums		varchar(50)					NULL, 
			recordname		varchar(50)					NULL,        
			recordstate		varchar(50)				    NULL,   
			
)

--ԤԼ
if not exists(select 1 from sysobjects where type='U' and name='orders')
  create table orders(
        ordersid			INT  IDENTITY(1, 1)  PRIMARY KEY,	--ԤԼ���
		calluserid			varchar(50)		null,
		callbillid			varchar(30)		null,				--ԤԼ���ݱ�� 
		orderphone			varchar(20)		null,				--ԤԼ����	
		orderconply			varchar(100)	null,				--	ԤԼ�ŵ�
		orderusermf			varchar(80)		null,
		orderusertrh		varchar(80)		null,
		orderusermr			varchar(80)		null,
		orderproject		varchar(1000)	null,			--	ԤԼ��Ŀ
		ordertime			varchar(100)	null,			--	ԤԼʱ��
		ordertimes			varchar(100)	NULL,			--	ȷ��ʱ��
		orderdetail			varchar(2000)	NULL,			--	ԤԼ��ע
		complydetail		varchar(2000)	NULL,			--	�ŵ걸ע
		orderstate			int				NULL,			--	״̬(0��ʾȷ�ϵ��ݣ�1��ʾ����δ������ 2 �ѷ��Ͷ���ȷ��)
		orderfactdate		varchar(10)		NULL,			--	ʵ��ԤԼ����
		orderfacttime		varchar(10)		NULL,			--	ʵ��ԤԼʱ��
		orderfactproject	varchar(100)		NULL,			--	ʵ��ԤԼ��Ŀ
		orderfactempid		varchar(20)		NULL,			--	ʵ��ԤԼ��Ա
		orderconfirmmsg		varchar(200)	NULL,			--	ԤԼȷ�϶���
		confirmdate			varchar(10)		NULL,			--	ȷ��ԤԼ����
		confirmemp			varchar(20)		NULL,			--	ȷ��ԤԼԱ��
  )



--��ѯ
if not exists(select 1 from sysobjects where type='U' and name='refer')
create table refer(
		 referid			INT  IDENTITY(1, 1)  PRIMARY KEY,  --��ѯ���
		 callbillid			varchar(30)				NOT NULL, --��ѯ���ݱ��
	     calluserid			varchar(50)					NULL,    -- ��½����+��ϯ
	     refertime			varchar(100)				NULL,	 --	��ѯʱ��
         refercomply		varchar(1000)				NULL,     --��ѯ�ŵ���Ϣ
		 refercards			varchar(1000)				NULL,			--��ѯ��Ա����Ϣ
		 referproject		varchar(1000)				NULL,	--��Ŀ��Ϣ
	     referelse			varchar(100)				NULL, --����
	     referdetails		varchar(2000)				NULL,	 --	��ע
		 feferstate			int							NULL		--״̬	
)


--Ͷ��
if not exists(select 1 from sysobjects where type='U' and name='peiier')
create table peiier(
		 peiierid			INT  IDENTITY(1, 1)  PRIMARY KEY,			--Ͷ�߱��
		 callbillid			varchar(30)					NOT NULL,		--Ͷ�ߵ��ݱ��
	     calluserid			varchar(50)						NULL,		-- ��½����+��ϯ
	     peiiertime			varchar(100)					NULL,		--	Ͷ��ʱ��
		 peiiercontent		varchar(1000)					NULL,		--Ͷ������
	     peiierelse			varchar(100)					NULL,		--����
	     peiierdetails		varchar(2000)					NULL,		--	��ע	

		 peiierstate     int   NULL		--״̬	
)
--�˿�
if not exists(select 1 from sysobjects where type='U' and name='cardreturning')
create table cardreturning(
		 cardreturningid			INT  IDENTITY(1, 1)  PRIMARY KEY,  --�˿����
		 callbillid					varchar(30)				NOT NULL, --�˿����ݱ��
	     calluserid					varchar(50)				NULL,    -- ��½����+��ϯ
	     cardreturningtime			varchar(100)			NULL,	 --	�˿�ʱ��
		 cardreturningcontent		varchar(1000)			NULL,     --�˿�����
	     cardelse					varchar(100)			NULL, --����
	     cardreturningdetails		varchar(2000)			NULL,	 --	��ע	
		 cardreturningstate			int						NULL		--״̬
)
go

if not exists(select 1 from sysobjects where type='U' and name='intention')
CREATE TABLE    intention     --��ѵ��������
		(
				intid			INT  IDENTITY(1, 1)  PRIMARY KEY,--��ѵ���	
				intcomplyno		varchar(10)		Not NULL,--��˾���
				intbillid		varchar(30)		Not NULL,--����
				intdproject		varchar(10)		NULL    ,--��λ�γ̣�0��������ʦ��1���߼���ʦ��2��Ԥ������ʦ��3������ʦ��4����ϯ��5���ܼ࣬6������������7��ѡ�޿Σ�
				intdstage		int				NULL    ,--�׶Σ�0���ޣ�1����һ�׶�,2:�ڶ��׶Σ�3�������׶Σ�4�����Ľ׶Σ����������
				intdstarttime	varchar(20 )		NULL    ,--��ѵ��ʼʱ��
				intdendtime		varchar(20 )		NULL    ,--��ѵ����ʱ��
				intuser			varchar(20)		NULL    ,--�Ǽ���
				intdata			varchar(30)		NULL    ,--�Ǽ�����
				intetionstate	int				NULL     --�Ǽ�״̬
		)
if not exists(select 1 from sysobjects where type='U' and name='intentiondetail')
CREATE TABLE    intentiondetail   --��ѵ������ϸ
		(
				intdid			INT		IDENTITY(1, 1)  PRIMARY KEY, --��ˮ��	
				intdcomplyno	varchar(10)		Not NULL,--��˾���
				intdbillid		varchar(30)		Not NULL,--��Ӧ����
				intdwaite		varchar(16)		NULL    ,--Ԥ��
				intstuno		varchar(18)		NULL    ,--ѧ���ֲ����
				incardno		varchar(18)		NULL    ,--����֤����
				instaffno		varchar(20)		NULL    ,--Ա�����
				instaffname		varchar(20)		NULL    ,--Ա������
				intposition		varchar(20)		NULL    ,--ְλ
				intbirthday		varchar(20)		NULL    ,--��������			
				intdscore		int				NULL    ,--�ɼ���0�����ϸ�1���ϸ�
				intpositions	int				NULL	,--����ɵ�����λ��0��������ʦ��1���߼���ʦ��2��Ԥ������ʦ��3������ʦ��4����ϯ��5���ܼ࣬6������������
				intdproname		varchar(20)		NULL    ,--ѡ�޿�����
				intdpunish		varchar(255)	NULL    ,--�������
				intdremark		varchar(255)	NULL     --��ע
		)

		
--¼�����ڱ�
if not exists(select 1 from sysobjects where type='U' and name='calldata')
create table calldata
(
	id   INT  IDENTITY(1, 1)  PRIMARY KEY,
	callbillid 	varchar(40)	NULL,  --���	
	calltime varchar(30)	NULL,  --¼������
	callstate int			NULL   --¼��״̬��0��δ�ϴ���1�����ϴ���
)

--¼����
if not exists(select 1 from sysobjects where type='U' and name='callditails')
create table callditails
(
	id   INT  IDENTITY(1, 1)  PRIMARY KEY,
  callbillid 	varchar(40)	NULL,  --���	
	calltime varchar(30)	NULL,  --¼������	
	calltimes varchar(30)	NULL,  --¼������
	callon varchar(30)	NULL,   --����
	calledon varchar(30)	NULL,   --����
 calledons varchar(50)	NULL,   --����
	callhoues time(7)	NULL,   --ͨ��ʱ��
  callall varchar(300)	NULL
)


	--�ŵ�����ܷ���
	create table jsanalysisresult  
	(  
		compno				varchar(10) null,	--�ŵ��
		mmonth				varchar(6)	null,	--�·�
		resusttyep			int			null,	--����
		resusttyeptext		varchar(60) null,	--��������
		resultamt			float		null	--���
	)
	
	go
	--�ŵ������
	create table storeconfirmflow
	(
		appitemno				varchar(5)		null,--������ 1���� 2���� 3�˿� 4�������  5��ֵ��� 
													 --       6�޸Ļ�Ա���� 7���Ƴ� 8��Ŀ��� 9 ��Ʒ���
		checkcommissioner		varchar(200)	null,--���רԱ
		checkcommissionertext	varchar(300)	null,--���רԱ
		checkmanager			varchar(200)	null,--��˾���
		checkmanagertext		varchar(300)	null,--��˾���
	)
	go
	--�ŵ�������Ϣ
	CREATE tAbLE    storeflowinfo             -- 
	(
		compid						varchar(10)   Not NULL,			--��˾���
		billid						varchar(20)   Not NULL,			--����
		appflowtype					int			  NULL,				----������ 1���� 2���� 3�˿� 4�������  5��ֵ��� 
																	--       6�޸Ļ�Ա���� 7���Ƴ� 8��Ŀ��� 9 ��Ʒ���
		appflowcode					varchar(20)   NULL,				--��Ŀ��Ż����ͻ򿨺�
		appflowstore				varchar(10)   NULL,				--�����ŵ�
		appflowvalue				varchar(30)	  NULL,				--���뿨��/�۸�
		startdate					varchar(10)   NULL,				--��Ч��ʼ����
		enddate						varchar(10)   NULL,				--��Ч��ֹ����
		appflowreason				varchar(200)  NULL,				--����ԭ��
		appflowstate				int			  NULL,				--�Ƿ���ˣ�0-�Ǽǣ�1-רԱ��ˣ�2�������    
		appflowconfirmempid			varchar(10)	  NULL,				--רԱ����˱���
		appflowconfirmdate			varchar(10)   NULL,				--רԱ�������
		appflowcheckempid			varchar(10)	  NULL,				--��������˱���
		appflowcheckdate			varchar(10)   NULL,				--�����������
		invalid						int			  NULl,				--�Ƿ����� 0 δ����  1 ������
		CONSTRAINT PK_storeflowinfo PRIMARY KEY CLUSTERED(compid,billid)
	)	
	go
	CREATE NONCLUSTERED index idx_storeflowinfo_promotionstype on storeflowinfo(appflowtype,appflowcode)

   --Ա��ָ���½��
   create table staffresultset
   (
		compid				varchar(10)		null,	--�ŵ���
		staffinid			varchar(20)		null,	--Ա���ڲ�����
		ddate				varchar(10)		null,	--��������
		stafftotalyeji		float			null,	--������ҵ��
		stafftotalxuyeji		float			null,	--������ҵ��
		staffrealtotalyeji	float			null,	--����ʵҵ��
		oldcustomercount	float			null,	--�����Ͽ���
		beatyprjcount		float			null,	--���ݴ�����
		tangrancount		float			null,	--��Ⱦ�Ƴ���
		
   )
--insert spadMconsumeInfo(brachcode,SMALL_NO,EMPLOYEE_NO,CUSTOM,STATUS,CDATE,SUMMARY,PSMALL_NO,SMERGE)
--select brachcode,SMALL_NO,EMPLOYEE_NO,CUSTOM,STATUS,CDATE,SUMMARY,PSMALL_NO,SMERGE
-- from [MasterDatabase2014].dbo.spadMconsumeInfo


--insert spadDconsumeInfo( brachcode,SMALL_NO,SORTID,CODE,PRODUCT,AMOUNT,PRICE,COST,CDATE,ISDELETED,ISFORTREATMENT,EMPLOYEE_NO,EMPLOYEE_NO2,EMPLOYEE_NO3,ISNEW,ISNEW2,ISNEW3)
--select brachcode,SMALL_NO,SORTID,CODE,PRODUCT,AMOUNT,PRICE,COST,CDATE,ISDELETED,ISFORTREATMENT,EMPLOYEE_NO,EMPLOYEE_NO2,EMPLOYEE_NO3,ISNEW,ISNEW2,ISNEW3
-- from [MasterDatabase2014].dbo.spadDconsumeInfo


 create table spadMconsumeInfo
 (
	ID				int identity(1,1) 					NOT NULL,
	brachcode		 VARCHAR(10)		NULL,		--�ŵ��
    SMALL_NO		VARCHAR(50)			NULL,--С����
    EMPLOYEE_NO		VARCHAR(255)		NULL,--Ա���� 
    CUSTOM			VARCHAR(50)			NULL,--���ƺ�	
    STATUS			int DEFAULT 0		NULL,--С��״̬					-δ��  3 �ѽᵥ
    CDATE			VARCHAR(30)			NULL,--����ʱ��
    SUMMARY			VARCHAR(2000)		NULL,--��ע
    PSMALL_NO		VARCHAR(50)			NULL,--�ϲ��� ����С����
    SMERGE			int DEFAULT 0		NULL,-- 1 �ϲ�������С			-δ��
 )



 create table spadDconsumeInfo
 (
	ID              int identity(1,1) 					NOT NULL,
	brachcode		 VARCHAR(10)		NULL,		--�ŵ��
    SMALL_NO        VARCHAR(50)			NULL,		--С����
    SORTID          int					NULL,--����id 0��Ʒ 1���� 2 ��Ա��
    CODE            VARCHAR(50)			NULL,--��Ŀ����
    PRODUCT         VARCHAR(50)			NULL,--��Ŀ����
    AMOUNT          float				NULL,--����				-δ��
    PRICE           float				NULL,--����
	COST            NUMERIC(8,2) DEFAULT 1	NULL,--�ۿ���
    CDATE           varchar(30)			NULL,--¼��ʱ��
    ISDELETED       int DEFAULT 0		NULL,-- 0���� 1ɾ��
    ISFORTREATMENT  int					NULL,-- 1�Ƴ̿�
	EMPLOYEE_NO     VARCHAR(50)			NULL,--Ա���� 1
    EMPLOYEE_NO2    VARCHAR(50)			NULL,--Ա���� 2
    EMPLOYEE_NO3    VARCHAR(50)			NULL,--Ա���� 3
    ISNEW           int DEFAULT 0		NULL,-- 0��ָ�� 1 ָ��
    ISNEW2          int DEFAULT 0		NULL,-- 0��ָ�� 1 ָ��
    ISNEW3          int DEFAULT 0		NULL,-- 0��ָ�� 1 ָ��
    CSPROSEQNO 		float			NULL,		--�Ƴ��������
	SCORE           NUMERIC(8,2)		NULL,--ҵ��1
    SCORE2          NUMERIC(8,2)		NULL,--ҵ��2
    SCORE3          NUMERIC(8,2)		NULL,--ҵ��3
    REWARD          NUMERIC(8,2) DEFAULT 0	NULL,--���1
    REWARD2         NUMERIC(8,2) DEFAULT 0	NULL,--���2
    REWARD3         NUMERIC(8,2) DEFAULT 0--���3

 )

--�ŵ��������ڻ��汾����
  create table amnfaceMachineinfo
  (
		compno				varchar(10)			not null,		--�ŵ���
		machineno			varchar(20)			not	null,		--���ڻ����
		createseqno			int					not	null,		--�������
		machineversion		varchar(5)				null,		--���ڻ��汾
		createfromdate		varchar(10)				null,		--��ʼʹ������
		createtodate		varchar(10)				null,		--����ʹ������
		CONSTRAINT PK_amnfaceMachineinfo PRIMARY KEY CLUSTERED(compno,machineno,createseqno)
  )			
	
 --��������ϵͳ
  create table amnfaceinfo
  (
		faceip			varchar(20)			not null,		--��������IP
		emplooyid		varchar(10)			not	null,		--Ա��ID
		emplooyname		varchar(20)				null,		--Ա������
		emplooycalid	varchar(20)				null,		--������ʾ��
		emplooycardnum	varchar(20)				null,		--ˢ������
		faceimageA		varchar(2500)			null,		--����ͼƬ�ַ�1
		faceimageB		varchar(2500)			null,		--����ͼƬ�ַ�2
		faceimageC		varchar(2500)			null,		--����ͼƬ�ַ�3
		faceimageD		varchar(2500)			null,		--����ͼƬ�ַ�4
		faceimageE		varchar(2500)			null,		--����ͼƬ�ַ�5
		faceimageF		varchar(2500)			null,		--����ͼƬ�ַ�6
		faceimageG		varchar(2500)			null,		--����ͼƬ�ַ�7
		faceimageH		varchar(2500)			null,		--����ͼƬ�ַ�8
		faceimageI		varchar(2500)			null,		--����ͼƬ�ַ�9
		faceimageJ		varchar(2500)			null,		--����ͼƬ�ַ�10
		faceimageK		varchar(2500)			null,		--����ͼƬ�ַ�11
		faceimageL		varchar(2500)			null,		--����ͼƬ�ַ�12
		faceimageM		varchar(2500)			null,		--����ͼƬ�ַ�13
		faceimageN		varchar(2500)			null,		--����ͼƬ�ַ�14
		faceimageO		varchar(2500)			null,		--����ͼƬ�ַ�15
		faceimageP		varchar(2500)			null,		--����ͼƬ�ַ�16
		faceimageQ		varchar(2500)			null,		--����ͼƬ�ַ�17
		faceimageR		varchar(2500)			null,		--����ͼƬ�ַ�18
  )		
  
  
  
  --�ŵ�ָ������
  create table storetargetinfo
  (
		entrycompid 				varchar(10) 	        not null,		--	�Ǽǹ�˾
		entrybillid 				varchar(20)				not null,		--	�Ǽǵ���
		compid					varchar(10)					null,			--	�ŵ���
		targetmonth				varchar(10)					null,			--	ָ�������·�
		ttotalyeji				float						null,			--	����ҵ��ָ��
		trealtotalyeji			float						null,			--	��ʵҵ��ָ��
		tbeatyyeji				float						null,			--	������ҵ��ָ��
		ttrhyeji				float						null,			--	��Ⱦָ��
		tcostcount				float						null,			--	�ܿ͵�ָ��
		tstaffleavelcount		float						null,			--	�ŵ���ʧ��
		targetflag				int							null,			--	�Ƿ����� 0 �Ǽ���   1�����  2 �Ѳ��� 3 ������
		operationer				varchar(20)					null,			--	������
		operationdate			varchar(10)					null,			--	����ʱ��
		checkempid				varchar(20)					null,			--	�����
		checkdate				varchar(10)					null,			--	���ʱ��
  )

  
  
   --�ŵ�곤����
  create table shopownerinfo
  (
		compid				varchar(10)			null,		--Ա�����	
		staffid				varchar(20)			null,		--Ա�����	
		staffname			varchar(20)			null,		--Ա������
		staffinid			varchar(20)			null,		--Ա���ڲ����
		mmonth				varchar(10)			null,		--�趨�·�
		stafftype			int					null,		--Ա������	--1��ҵ�� 2����ҵ��
  )
  



	if not exists(select 1 from sysobjects where type='U' and name='staff_work_yeji')
	create table staff_work_yeji
	(
		seqno				int identity			NOT NULL,  
		compid				varchar(10)					NULL, --��˾��   
		person_inid			varchar(20)					NULL, --Ա���ڲ����      
		action_id			int							NULL, --��������      
		srvdate				varchar(10)					NULL, --����      
		code				varchar(20)					NULL, --��Ŀ����,���ǿ���,��Ʒ��      
		name				varchar(40)					NULL, --����      
		payway				varchar(20)					NULL, --֧����ʽ      
		billamt				float						NULL, --Ӫҵ���      
		ccount				float						NULL, --����      
		cost				float						NULL, --�ɱ�      
		staffticheng		float						NULL, --���      
		staffyeji			float						NULL, --��ҵ��      
		prj_type			varchar(20)					NULL, --��Ŀ���      
		cls_flag			int							NULL, -- 1:��Ŀ 2:��Ʒ 3:��      
		billid				varchar(20)					NULL, --����      
		paycode				varchar(20)					NULL, --֧������      
		   
		cardid				varchar(20)					NULL, --��Ա����      
		cardtype			varchar(20)					NULL, --��Ա������      
		postation			varchar(10)					NULL, --Ա������   
	) 
	go
	
---------------------------------------
-----compscheduling �ŵ��Ű���Ϣ CREATE by liujie 20130628
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='compschedulinfo')
CREATE table compschedulinfo
(
	compno				varchar(10)		Not  NULL,	-- ��ǰ�ŵ�
	schedulno			varchar(10)		Not  NULL,	-- ��α��
	scheduldate			varchar(10)		Not  NULL,	-- �Ű�����
	schedulemp			varchar(20)		Not	 NULL,	-- �Ű���Ա
	schedulempname		varchar(30)			 NULL,	-- �Ű���Ա
	schedulempmanger	varchar(30)			 NULL,	-- �Ű���Ա
	fromtime			varchar(10)			 NULL,	-- ��ʼʱ��
	totime				varchar(10)			 NULL,	-- ����ʱ��
	schedulmark			varchar(100)		 NULL,	-- �Ű౸ע
	CONSTRAINT PK_compschedulinfo PRIMARY KEY NONCLUSTERED(compno,schedulno,scheduldate,schedulemp)	
)
go

if not exists(select 1 from sysobjects where type='U' and name='staffleaveinfo')
CREATE table staffleaveinfo
(
	staffinid			varchar(20)			Not NULL,	-- Ա���ڲ����
	leavedate			varchar(10)			Not NULL,	-- �������
	leavetype			int						NULL,	-- �������
	fromtime			varchar(10)				NULL,	-- ��ʼʱ��
	totime				varchar(10)				NULL,	-- ����ʱ��
	schedulmark			varchar(100)			NULL,	-- ��ٱ�ע
	checkdate			varchar(10)				null	,
	checkuseid			varchar(20)				null	,
	checkflag			int						null	   -- 0δ����  1 �Ѹ���
	CONSTRAINT PK_staffleaveinfo PRIMARY KEY NONCLUSTERED(staffinid,leavedate)	
)
go

if not exists(select 1 from sysobjects where type='U' and name='projectcostinfo')
CREATE TABLE projectcostinfo          -- ��Ŀ�����趨      
(
	prjno				varchar(20) NOT NULL,   -- ��Ŀ��� 
	goodsno				varchar(30) NOT NULL,   -- ��Ʒ���         
	costunitcount		float       NULL,       -- ��׼��������       
	CONSTRAINT PK_projectcostinfo PRIMARY KEY CLUSTERED (prjno, goodsno)
)
go 


if not exists(select 1 from sysobjects where type='U' and name='compute_staff_work_salary_byday')
CREATE table compute_staff_work_salary_byday
(
	computeday				varchar(10)		null,	--��������
	strCompId				varchar(10)		null,   --�ŵ���      
	strCompName				varchar(10)		null,   --�ŵ�����  
	staffno					varchar(20)		null,   --Ա�����      
	staffinid				varchar(20)		null,   --Ա���ڲ���� 
	arrivaldate				varchar(8 )		NULL    ,--��ְ����     
	staffname				varchar(30)		null,   --Ա������      
	staffposition			varchar(10)		null,   --Ա��ְλ    
	staffsocialsource		varchar(20)		null,	--�籣����  
	staffpcid				varchar(20)		null,   --Ա������֤      
	staffmark				varchar(300)	null,   --Ա����ע      
	staffbankaccountno		varchar(30)		null,   --Ա�������˺�      
	resulttye				varchar(5)		NULL,	--ҵ����ʽ 0--��ȷ�ʽ -������ҵ��  2 ����ʵҵ��      
	resultrate				float			NULL,	--ҵ��ϵ��      
	baseresult				float			NULL,   --ҵ������      
	computedays				int				NULL,   --��������      
	workdays				int				NULL,   --ȱ������    
	inserworkdays			int				NULL,   --ҵ������    
	stafftotalyeji			float			null,   --Ա����ҵ��      
	staffshopyeji			float			null,   --Ա���ŵ�ҵ��      
	salaryflag				int				null,   --˰ǰ ,˰��       
	staffbasesalary			float			null,   --Ա����������      
	beatysubsidy			float			null,   --���ݲ��� 
	oldcustomerreward		float			null,   --�ϿͲ���
	leaveldebit				float			null,   --��ְ�ۿ�   
	basestaffamt			float			null,   --�ذ�����   
	basestaffpayamt			float			null,   --�ذ�����֧��  
	staffsubsidy			float			null,   --Ա������  
	storesubsidy			float			null,   --�ŵ겹��(����+�ŵ겹��)      
	staffdebit				float			null,   --����
	staffdaikou				float			null,   --����
	latdebit				float			null,   --�ٵ�      
	staffreward				float			null,   --���� 
	afterstaffreward		float			null,   --���� 
	yearreward				float			null,	--���ս�
	staffamtchange			float			null,   --�������   
	zerenjinback			float			null,   --���ν𷵻�
	zerenjincost			float			null,   --���ν�ۿ�
	stafftargetreward		float			null,   --ָ�꽱��     
	otherdebit				float			null,   --�����ۿ�      
	staffsocials			float			null,   --�籣      
	needpaysalary			float			null,   --Ӧ������      
	staydebit				float			null,   --ס��      
	studydebit				float			null,   --ѧϰ����      
	staffcost				float			null,   --�ɱ�      
	salarydebit				float			null,   --��˰      
	factpaysalary			float			null,   --Ӧ������      
	staffpositionname		varchar(30)		null,   --Ա��ְλ  
	absencesalary			int				NULL,	--ȱ�ڵ�н�㷨  
	staffcurstate			int				null,	--Ա����ְ״̬  
	businessflag			int				NULL    ,--�Ƿ�Ϊҵ����Ա 0--���� 1--��
	markflag				int				NULL,	--���
	stafftype				int				NULL	,-- 0 ���� 1 ��ǲ
	)
	go
	
	
	
---------------------------------------
----msalecardinfolog  -- ��Ա�����۵��޸���־
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='msalecardinfolog')
CREATE tAbLE	msalecardinfolog               -- ��Ա�����۵�
(
	seqno				int identity			NOT NULL,  
	salecompid			varchar(10)				NULL,   --��˾���
	salebillid			varchar(20)				NULL,   --���۵���
	saledate			varchar(8)				NULL,   --��������
	saletime			varchar(8)				NULL,   --����ʱ��
	salecardno			varchar(20)				NULL,   --���ۿ���
	saletotalamt		float					NULL,   --ʵ���ܶ�
	firstsalerid		varchar(20)				NULL,   --��һ���۹���
    firstsalerinid		varchar(20)				NULL,   --��һ�����ڲ����
    firstsaleamt		float					NULL,   --��һ���۷������
	secondsalerid		varchar(20)				NULL,   --�ڶ����۹���
    secondsalerinid		varchar(20)				NULL,   --�ڶ������ڲ����
    secondsaleamt		float					NULL,   --�ڶ����۷������
	thirdsalerid		varchar(20)				NULL,   --�������۹���
    thirdsalerinid		varchar(20)				NULL,   --���������ڲ����
    thirdsaleamt		float					NULL,   --�������۷������
	fourthsalerid		varchar(20)				NULL,   --�������۹���
    fourthsalerinid		varchar(20)				NULL,   --���������ڲ����
    fourthsaleamt		float					NULL,   --�������۷������
	fifthsalerid		varchar(20)				NULL,   --�������۹��� -----��Ⱦʦ
    fifthsalerinid		varchar(20)				NULL,   --���������ڲ����
    fifthsaleamt		float					NULL,   --�������۷������
	sixthsalerid		varchar(20)				NULL,   --�������۹���----- ��Ⱦʦ
    sixthsalerinid		varchar(20)				NULL,   --���������ڲ����
    sixthsaleamt		float					NULL,   --�������۷������
	seventhsalerid		varchar(20)				NULL,   --�������۹��� -----��Ⱦʦ
    seventhsalerinid	varchar(20)				NULL,   --���������ڲ����
    seventhsaleamt		float					NULL,   --�������۷������
	eighthsalerid		varchar(20)				NULL,   --�ڰ����۹���----- ��Ⱦʦ
    eighthsalerinid		varchar(20)				NULL,   --�ڰ������ڲ����
    eighthsaleamt		float					NULL,   --�ڰ����۷������    
    ninthsalerid		varchar(20)				NULL,   --�ھ����۹���-----
    ninthsalerinid		varchar(20)				NULL,   --�ھ������ڲ����
    ninthsaleamt		float					NULL,   --�ھ����۷������
    tenthsalerid		varchar(20)				NULL,   --��ʮ���۹���----- ��Ⱦʦ
    tenthsalerinid		varchar(20)				NULL,   --��ʮ�����ڲ����
    tenthsaleamt		float					NULL,   --��ʮ���۷������    
    firstsalecashamt	float					NULL,   --��һ���۷������(ʵ���ֽ�ҵ��)
    secondsalecashamt	float					NULL,   --�ڶ����۷������(ʵ���ֽ�ҵ��)
    thirdsalecashamt	float					NULL,   --�������۷������(ʵ���ֽ�ҵ��)
    fourthsalecashamt	float					NULL,   --�������۷������(ʵ���ֽ�ҵ��)
    fifthsalecashamt	float					NULL,   --�������۷������(ʵ���ֽ�ҵ��)
    sixthsalecashamt	float					NULL,   --�������۷������(ʵ���ֽ�ҵ��)
    seventhsalecashamt	float					NULL,   --�������۷������(ʵ���ֽ�ҵ��)
    eighthsalecashamt	float					NULL,   --�ڰ����۷������(ʵ���ֽ�ҵ��)
    ninthsalecashamt	float					NULL,   --�ھ����۷������(ʵ���ֽ�ҵ��)
    tenthsalecashamt	float					NULL,   --��ʮ���۷������(ʵ���ֽ�ҵ��)    
	billinsertype		int						NULL,	--��ֵ���췽 1 ���� 2 ���� 3����
	optionuserno		varchar(20)				NULL,	--�޸���
	optiondate			varchar(10)				NULL,	--�޸�����
	optiontime			varchar(10)				NULL,	--�޸�ʱ��
) 
go
CREATE NONCLUSTERED index idx_msalecardinfolog_billno on msalecardinfolog(salecompid,salebillid)
go
     
if not exists(select 1 from sysobjects where type='U' and name='dproexchangeinfolog')
CREATE table dproexchangeinfolog( 
	seqno					int identity			NOT NULL,		
	changecompid			varchar(10)				NULL, 			--�һ��ŵ�
	changebillid			varchar(20)				NULL, 			--�һ�����
	changeseqno				float					NULL, 		--��ˮ�� 
	changeproid				varchar(20) 			NULL,			--��Ŀ���
	changeprocount			float					NULL,			--����
	changeprorate			float					NULL,			--�ۿ�
	changeproamt			float					NULL,			--���
	firstsalerid			varchar(20)				NULL,			--��һ���۹���
    firstsalerinid			varchar(20)				NULL,			--��һ�����ڲ����
    firstsaleamt			float					NULL,			--��һ���۷������
	secondsalerid			varchar(20)				NULL,			--�ڶ����۹���
    secondsalerinid			varchar(20)				NULL,			--�ڶ������ڲ����
    secondsaleamt			float					NULL,			--�ڶ����۷������
	thirdsalerid			varchar(20)				NULL,			--�������۹���----- ��Ⱦʦ
    thirdsalerinid			varchar(20)				NULL,			--���������ڲ����
    thirdsaleamt			float					NULL,			--�������۷������
	fourthsalerid			varchar(20)				NULL,			--�������۹���----- ��Ⱦʦ
    fourthsalerinid			varchar(20)				NULL,			--���������ڲ����
    fourthsaleamt			float					NULL,			--�������۷������
    optionuserno			varchar(20)				NULL,			--�޸���
	optiondate				varchar(10)				NULL,			--�޸�����
	optiontime				varchar(10)				NULL,			--�޸�ʱ��
)
go 	
CREATE NONCLUSTERED index idx_dproexchangeinfolog_billno on dproexchangeinfolog(changecompid,changebillid)
go

if not exists(select 1 from sysobjects where type='U' and name='dconsumeinfolog')
CREATE tAbLE    dconsumeinfolog  
(
	seqno				int identity			NOT NULL,
	cscompid			varchar(10)					NULL,		--��˾���
	csbillid			varchar(20)					NULL,		--���ѵ���
	csinfotype			int							NULL,		--��������  1 ��Ŀ  2 ��Ʒ
	csitemno			varchar(20)					NULL,		--��Ŀ/��Ʒ����
	csitemcount			float						NULL,		--����
	csdisprice			float						NULL,		--���õ���
	csitemamt			float						NULL,		--���
	cspaymode			varchar(5)					NULL,		--֧����ʽ
	csfirstsaler		varchar(20)					NULL,		--�󹤹���
	csfirsttype			varchar(5)					NULL,		--������
    csfirstinid			varchar(20)					NULL,		--���ڲ����
	csfirstshare		float						NULL,		--�󹤷���
	cssecondsaler		varchar(20)					NULL,		--�й�����
	cssecondtype		varchar(5)					NULL,		--�й�����
    cssecondinid		varchar(20)					NULL,		--�й��ڲ����
	cssecondshare		float						NULL,		--�й�����
	csthirdsaler		varchar(20)					NULL,		--С������
	csthirdtype			varchar(5)					NULL,		--С������
    csthirdinid			varchar(20)					NULL,		--С���ڲ����
	csthirdshare		float						NULL,		--С������
	optionuserno		varchar(20)					NULL,		--�޸���
	optiondate			varchar(10)					NULL,		--�޸�����
	optiontime			varchar(10)					NULL,		--�޸�ʱ��
)
go 	
CREATE NONCLUSTERED index idx_dconsumeinfolog_billno on dconsumeinfolog(cscompid,csbillid)
go

if not exists(select 1 from sysobjects where type='U' and name='mcardchangeinfolog')
CREATE table mcardchangeinfolog
(
	seqno					int identity			NOT NULL, 
	changecompid			varchar(10)				NULL,   --�춯�ŵ�
	changebillid			varchar(20)				NULL,   --�춯����
	changetype				int						NULL,   --�춯���  0 �ۿ�ת�� 1 �չ�ת�� 2����ת�� 3���� 4��ʧ�� 5���� 6�Ͽ����Ͽ� 7�Ͽ����¿� 8�˿�
	changedate				varchar(8)				NULL,   --�춯����
	changebeforcardno		varchar(20)				NULL,   --�춯ǰ��Ա����
	firstsalerid			varchar(20)				NULL,   --��һ���۹���
    firstsalerinid			varchar(20)				NULL,   --��һ�����ڲ����
    firstsaleamt			float					NULL,   --��һ���۷������
	secondsalerid			varchar(20)				NULL,   --�ڶ����۹���
    secondsalerinid			varchar(20)				NULL,   --�ڶ������ڲ����
    secondsaleamt			float					NULL,   --�ڶ����۷������
	thirdsalerid			varchar(20)				NULL,   --�������۹���
    thirdsalerinid			varchar(20)				NULL,   --���������ڲ����
    thirdsaleamt			float					NULL,   --�������۷������
	fourthsalerid			varchar(20)				NULL,   --�������۹���
    fourthsalerinid			varchar(20)				NULL,   --���������ڲ����
    fourthsaleamt			float					NULL,   --�������۷������
	fifthsalerid			varchar(20)				NULL,   --�������۹��� -----��Ⱦʦ
    fifthsalerinid			varchar(20)				NULL,   --���������ڲ����
    fifthsaleamt			float					NULL,   --�������۷������
	sixthsalerid			varchar(20)				NULL,   --�������۹���----- ��Ⱦʦ
    sixthsalerinid			varchar(20)				NULL,   --���������ڲ����
    sixthsaleamt			float					NULL,   --�������۷������
	seventhsalerid			varchar(20)				NULL,   --�������۹��� -----��Ⱦʦ
    seventhsalerinid		varchar(20)				NULL,   --���������ڲ����
    seventhsaleamt			float					NULL,   --�������۷������
	eighthsalerid			varchar(20)				NULL,   --�ڰ����۹���----- ��Ⱦʦ
    eighthsalerinid			varchar(20)				NULL,   --�ڰ������ڲ����
    eighthsaleamt			float					NULL,   --�ڰ����۷������
    ninthsalerid			varchar(20)				NULL,   --�ھ����۹���-----
    ninthsalerinid			varchar(20)				NULL,   --�ھ������ڲ����
    ninthsaleamt			float					NULL,   --�ھ����۷������
    tenthsalerid			varchar(20)				NULL,   --��ʮ���۹���----- ��Ⱦʦ
    tenthsalerinid			varchar(20)				NULL,   --��ʮ�����ڲ����
    tenthsaleamt			float					NULL,   --��ʮ���۷������
    
    firstsalecashamt		float					NULL,   --��һ���۷������(ʵ���ֽ�ҵ��)
    secondsalecashamt		float					NULL,   --�ڶ����۷������(ʵ���ֽ�ҵ��)
    thirdsalecashamt		float					NULL,   --�������۷������(ʵ���ֽ�ҵ��)
    fourthsalecashamt		float					NULL,   --�������۷������(ʵ���ֽ�ҵ��)
    fifthsalecashamt		float					NULL,   --�������۷������(ʵ���ֽ�ҵ��)
    sixthsalecashamt		float					NULL,   --�������۷������(ʵ���ֽ�ҵ��)
    seventhsalecashamt		float					NULL,   --�������۷������(ʵ���ֽ�ҵ��)
    eighthsalecashamt		float					NULL,   --�ڰ����۷������(ʵ���ֽ�ҵ��)
    ninthsalecashamt		float					NULL,   --�ھ����۷������(ʵ���ֽ�ҵ��)
    tenthsalecashamt		float					NULL,   --��ʮ���۷������(ʵ���ֽ�ҵ��)
	
	billinsertype			int						NULL,	--��ֵ���췽 1 ���� 2 ����
	optionuserno			varchar(20)				NULL,	--�޸���
	optiondate				varchar(10)				NULL,	--�޸�����
	optiontime				varchar(10)				NULL,	--�޸�ʱ��
)
CREATE NONCLUSTERED index idx_mcardchangeinfolog_billno on mcardchangeinfolog(changecompid,changebillid)
go

if not exists(select 1 from sysobjects where type='U' and name='mcardrechargeinfolog')
CREATE tAbLE    mcardrechargeinfolog              -- �ʻ��춯��
(
	seqno					int identity			NOT NULL,  
	rechargecompid			varchar(10)				NULL,   --��ֵ�ŵ�
	rechargebillid			varchar(20)				NULL,   --��ֵ���� 
	rechargedate			varchar(8)				NULL,   --��ֵ���� 
	rechargecardno			varchar(20)				NULL,   --��Ա����
	firstsalerid			varchar(20)				NULL,   --��һ���۹���
    firstsalerinid			varchar(20)				NULL,   --��һ�����ڲ����
    firstsaleamt			float					NULL,   --��һ���۷������
	secondsalerid			varchar(20)				NULL,   --�ڶ����۹���
    secondsalerinid			varchar(20)				NULL,   --�ڶ������ڲ����
    secondsaleamt			float					NULL,   --�ڶ����۷������
	thirdsalerid			varchar(20)				NULL,   --�������۹���
    thirdsalerinid			varchar(20)				NULL,   --���������ڲ����
    thirdsaleamt			float					NULL,   --�������۷������
	fourthsalerid			varchar(20)				NULL,   --�������۹���
    fourthsalerinid			varchar(20)				NULL,   --���������ڲ����
    fourthsaleamt			float					NULL,   --�������۷������
	fifthsalerid			varchar(20)				NULL,   --�������۹��� -----��Ⱦʦ
    fifthsalerinid			varchar(20)				NULL,   --���������ڲ����
    fifthsaleamt			float					NULL,   --�������۷������
	sixthsalerid			varchar(20)				NULL,   --�������۹���----- ��Ⱦʦ
    sixthsalerinid			varchar(20)				NULL,   --���������ڲ����
    sixthsaleamt			float					NULL,   --�������۷������
	seventhsalerid			varchar(20)				NULL,   --�������۹��� -----��Ⱦʦ
    seventhsalerinid		varchar(20)				NULL,   --���������ڲ����
    seventhsaleamt			float					NULL,   --�������۷������
	eighthsalerid			varchar(20)				NULL,   --�ڰ����۹���----- ��Ⱦʦ
    eighthsalerinid			varchar(20)				NULL,   --�ڰ������ڲ����
    eighthsaleamt			float					NULL,   --�ڰ����۷������
    ninthsalerid			varchar(20)				NULL,   --�ھ����۹���-----
    ninthsalerinid			varchar(20)				NULL,   --�ھ������ڲ����
    ninthsaleamt			float					NULL,   --�ھ����۷������
    tenthsalerid			varchar(20)				NULL,   --��ʮ���۹���----- ��Ⱦʦ
    tenthsalerinid			varchar(20)				NULL,   --��ʮ�����ڲ����
    tenthsaleamt			float					NULL ,  --��ʮ���۷������
	
	firstsalecashamt		float					NULL,   --��һ���۷������(ʵ���ֽ�ҵ��)
    secondsalecashamt		float					NULL,   --�ڶ����۷������(ʵ���ֽ�ҵ��)
    thirdsalecashamt		float					NULL,   --�������۷������(ʵ���ֽ�ҵ��)
    fourthsalecashamt		float					NULL,   --�������۷������(ʵ���ֽ�ҵ��)
    fifthsalecashamt		float					NULL,   --�������۷������(ʵ���ֽ�ҵ��)
    sixthsalecashamt		float					NULL,   --�������۷������(ʵ���ֽ�ҵ��)
    seventhsalecashamt		float					NULL,   --�������۷������(ʵ���ֽ�ҵ��)
    eighthsalecashamt		float					NULL,   --�ڰ����۷������(ʵ���ֽ�ҵ��)
    ninthsalecashamt		float					NULL,   --�ھ����۷������(ʵ���ֽ�ҵ��)
    tenthsalecashamt		float					NULL,   --��ʮ���۷������(ʵ���ֽ�ҵ��)
	billinsertype			int						NULL,	--��ֵ���췽 1 ���� 2 ����
	optionuserno		varchar(20)				NULL,	--�޸���
	optiondate			varchar(10)				NULL,	--�޸�����
	optiontime			varchar(10)				NULL,	--�޸�ʱ��
)
go
CREATE NONCLUSTERED index idx_mcardrechargeinfolog_billno on mcardrechargeinfolog(rechargecompid,rechargebillid)
go

if not exists(select 1 from sysobjects where type='U' and name='mreturnproinfo')
create table mreturnproinfo
(
	returncompid				varchar(10)			NOT NULL,		--��˾���
	returnbillid				varchar(20)			NOT NULL,		--���Ƴ̵���
	returndate					varchar(10)			NULL    ,		--���Ƴ�����
    returntime					varchar(10)			NULL    ,		--���Ƴ�ʱ��  
	returncardno				varchar(20)			NULL	,		--�˿�����
	cardvesting					varchar(10)			NULL	,		--������
	cardtype					varchar(10)			NULL	,		--������
	membername					varchar(20)			NULL	,		--��Ա����
	memberphone					varchar(20)			NULL	,		--��Ա�ֻ�
	curkeepamt					float				NULL	,		--��ֵ���
	curkeepproamt				float				NULL	,		--�Ƴ����
	cursendamt					float				NULl	,		--�������
	curpointamt					float				NULL	,		--���ֽ��
	changecardno				varchar(20)			NULL	,		--�¿���
	opencardtype				varchar(10)			NULL	,		--�¿�������
	opentotalamt				float				NULL	,		--�¿����Ƴ��ܶ�
	returnkeeptotalamt			float				NULL	,		--�˻���ֵ�ܶ�
	changetotalamt				float				NULL	,		--ת���Ƴ��ܶ�	
	costproamt					float				NULL	,		--�۳����							
    CONSTRAINT PK_mreturnproinfo PRIMARY KEY CLUSTERED(returncompid,returnbillid)
)
go
if not exists(select 1 from sysobjects where type='U' and name='dreturnproinfo')
create table dreturnproinfo
(
	returncompid				varchar(10)			NOT NULL,			--��˾���
	returnbillid				varchar(20)			NOT NULL,			--���Ƴ̵���
	returnprotype				int					NOT NULL,			--���Ƴ�����  1 ���Ƴ�  2���Ƴ�
	returnseqno					float				NOT NULL,			--���
    changeproid					varchar(20) 			NULL,			--��Ŀ���
    lastcount					float					NULL,			--ʣ�����
	lastamt						float					NULL,			--ʣ����
	changeprocount				float					NULL,			--����
	changeproamt				float					NULL,			--���
	changebyaccountamt			float					NULL,			--���(��ֵ�˻����)
	firstsalerid				varchar(20)				NULL,			--��һ���۹���
    firstsalerinid				varchar(20)				NULL,			--��һ�����ڲ����
    firstsaleamt				float					NULL,			--��һ���۷������
	secondsalerid				varchar(20)				NULL,			--�ڶ����۹���
    secondsalerinid				varchar(20)				NULL,			--�ڶ������ڲ����
    secondsaleamt				float					NULL,			--�ڶ����۷������	
    changemark					varchar(200)			NULL,			--��ע
    changeflag					int						 NULL,			--0 ���Ƴ�  1���Ƴ�
    CONSTRAINT PK_dreturnproinfo PRIMARY KEY CLUSTERED(returncompid,returnbillid,returnprotype,returnseqno)
)
go

--��Ϣ����
create table blacklist
(
	id varchar(50) not null primary key,   --��ʶ��
	mobilephone varchar(30) null,---�ֻ�����
	acceptdate varchar(30) null,--�ظ����ڣ�ʱ��
	content varchar(1000)  null,--����
	operdate varchar(20)  null,--ϵͳ���ڽ�������
)
go

--��Ʒ�Ƿ���Կ���
create table gooddiscount
(
	compid varchar(20) not null,--��˾���
	bprojecttypeid varchar(20) not null,--��Ʒ���
	iscard   int   null,--�Ƿ���Կ���
	CONSTRAINT PK_gooddiscount PRIMARY KEY NONCLUSTERED(compid,bprojecttypeid)
)
go


-----categoryinfo �Ű�����趨 
---------------------------------------
CREATE table categoryinfo
(
	compno				varchar(10)		Not  NULL,	-- ��ǰ�ŵ�
	categoryno			varchar(20)		Not  NULL,	-- �����
	categoryname		varchar(50)		Not  NULL,	-- �������
	categorymark			varchar(200)		 NULL,	-- ���ע
)
go

-----categoryinfoid �Ű������ְλ�� 
---------------------------------------
CREATE table categoryinfoid
(
	compno				varchar(10)		Not  NULL,	-- ��ǰ�ŵ�
	categoryno			varchar(20)		Not  NULL,	-- �����
	postationid		varchar(20)		Not  NULL,	-- ְλ���
	postationname			varchar(20)		 NULL,	-- ְλ����
)
go

--�����趨
CREATE table roominfo
(
	compno				varchar(10)		Not  NULL,	-- ��˾���
	roomno			varchar(10)		Not  NULL,	-- ������
	roomname		varchar(100)		  NULL,	-- ��������

)

---------------------------------------
-----schoolinfo ����ѧУ��Ϣ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='schoolinfo')
CREATE table schoolinfo(
	id 				int IDENTITY(1,1) 	NOT NULL,	--��ˮ���
	no  			AS (right(CONVERT(varchar,(1000)+id,(0)),(3))),	--ѧУ���
	name 			varchar(50) 	NOT NULL,		--ѧУ����
	website 		varchar(20) 	NULL,			--��ַ
	address 		varchar(100) 	NULL,			--��ַ
	telephone 		varchar(20) 	NULL,			--�绰
	contacts 		varchar(20) 	NULL,			--��ϵ��
	mobile 			varchar(20) 	NULL,			--��ϵ�˵绰
	describe 		varchar(1000) 	NULL,			--ѧУ���
	remark 			varchar(255) 	NULL,			--��ע
	state 			int 			NULL,			--״̬ 1:���� 0:δ����
	CONSTRAINT PK_schoolinfo PRIMARY KEY NONCLUSTERED(id)
)
go

---------------------------------------
-----schoolcredit �γ�ѧ���趨
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='schoolcredit')
CREATE table schoolcredit(
	id 				bigint 			IDENTITY(1,1) NOT NULL,	--��ˮ���
	no  			AS (right(CONVERT(varchar,(1000)+id,(0)),(3))),	--�γ̱��
	name 			varchar(50) 	NOT NULL,				--�γ�����
	type 			int 			NOT NULL,				--�γ���� 0:���� 1:����
	school_no 		varchar(10) 	NOT NULL,				--ѧУ���
	state 			int 			NULL,					--״̬ 1:���� 0:δ����
	CONSTRAINT PK_schoolcredit PRIMARY KEY NONCLUSTERED(id)
)
go

---------------------------------------
-----schoolscore �γ�ѧ��-ְλѧ�ֹ���
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='schoolscore')
CREATE table schoolscore(
	credit_no 		varchar(10) 	NOT NULL,	--�γ̱��
	postion 		varchar(10) 	NOT NULL,	--ְλ���
	score 			int 			NOT NULL,	--ѧ��
	CONSTRAINT PK_schoolscore PRIMARY KEY NONCLUSTERED(credit_no, postion)
)
go

---------------------------------------
----- Schoolcreditpostionְλѡ�޿α��޿�
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='Schoolcreditpostion')
CREATE table Schoolcreditpostion(
	id bigint IDENTITY(1,1) NOT NULL ,--�߼�����
	postion varchar(20) NULL,--ְλ����
	schoolcreditno varchar(20) NULL,--�γ̱���
	type int NULL,--�γ����ͣ�1�����ޡ�2��ѡ��
	CONSTRAINT PK_Schoolcreditpostion PRIMARY KEY NONCLUSTERED(id)
)
go

---------------------------------------
-----schoolemployee �γ�ѧ��¼��
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='schoolemployee')
CREATE table schoolemployee
(
	salecompid  	nchar(10)		Not NULL,	--¼�벿��
	salebillid		varchar(20)		Not NULL,	--¼�뵥��
	staffno			varchar(20)		Not NULL,	--Ա�����
	credit			varchar(20)		Not NULL,	--�γ�
	ispass			int				Not NULL,	--�Ƿ�ͨ�� 1:ͨ�� 0:��ͨ��
	remark			nvarchar(100)	NULL,		--��ע
	operationer		varchar(20)		NULL,		--������
	operationdate	smalldatetime	NULL,		--��������
	state			int				NULL,		--״̬ 1:���� 0:δ����
	CONSTRAINT PK_schoolemployee PRIMARY KEY NONCLUSTERED(salecompid,salebillid,staffno,credit)
)
go

---------------------------------------
-----schoolactinfo ��ػ��Ϣ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='schoolactinfo')
CREATE table schoolactinfo 
(
	id  			int	IDENTITY(1,1)	Not NULL,	--��ˮ���
	no				AS (right(CONVERT(varchar,(1000)+id,(0)),(3))),	--����
	name			varchar(20)		Not NULL,	--�����
	remark			nvarchar(100)	NULL,		--��ע
	state			int				default(1) NULL,	--״̬ 1:���� 0:δ����
	CONSTRAINT PK_schoolactinfo PRIMARY KEY NONCLUSTERED(id)
)
go

---------------------------------------
-----schoolactivity ����ѧ��¼��
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='schoolactivity')
CREATE table schoolactivity 
(
	salecompid  	nchar(10)		Not NULL,	--¼�벿��
	salebillid		varchar(20)		Not NULL,	--¼�뵥��
	staffno			varchar(20)		Not NULL,	--Ա�����
	remark			nvarchar(100)	NULL,		--��ע
	actno			varchar(10)		Not NULL,	--����
	acttype			int				Not NULL,	--�����
	score 			int 			NOT NULL,	--����	
	operationer		varchar(20)		NULL,		--������
	operationdate	smalldatetime	NULL,		--��������
	state			int				NULL,		--״̬ 1:���� 0:δ����
	CONSTRAINT PK_schoolactivity PRIMARY KEY NONCLUSTERED(salecompid,salebillid,staffno,actno)
)
go

---------------------------------------
----- ѧ��ָ���趨
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='schoolindex')
CREATE table schoolindex(
	postion_no varchar(20) NOT NULL,--ְλ���
	time varchar(20) NOT NULL,--�·� yyyyMM
	type nvarchar(20) NOT NULL,--���ͣ���Ŀ��ָ�꣬�Ƴ�ҵ��ָ�꣩
	num float NULL,--���/����
	CONSTRAINT PK_schoolindex PRIMARY KEY NONCLUSTERED(postion_no,time,type)
)
go

---------------------------------------
----- ������ѧ���趨
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='Schoollowestscore')
CREATE table Schoollowestscore(
	syear int NOT NULL,--���
	score float NULL,--���ѧ��
	state int NULL,--״̬1Ϊ����
	CONSTRAINT PK_Schoollowestscore PRIMARY KEY NONCLUSTERED(syear)
)
go

---------------------------------------
-----credit Ա������
---------------------------------------
CREATE TABLE credit(
	compno varchar(10) NOT NULL,	--�ŵ���
	staffno varchar(20) NOT NULL,	--Ա�����
	staffname varchar(20) NOT NULL, --����
	positionname varchar(40) NOT NULL,--ְλ
	credit int NOT NULL--����
);

---------------------------------------
-----creditdetail Ա��������ϸ
---------------------------------------
create table creditdetail(
	staffno varchar(20) NOT NULL,--Ա�����
	classify varchar(100) NOT NULL,--����
	number int NOT NULL,--����
	unit varchar(40) NOT NULL,--��λ
	credit int NOT NULL--����
);

---------------------------------------
-----suppliermode ��Ӧ����Ϣ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='suppliermode')
CREATE table suppliermode(
	id 				int IDENTITY(1,1) 	NOT NULL,	--��ˮ���
	no  			AS (right(CONVERT(varchar,(1000)+id,(0)),(3))),	--��Ӧ�̱��
	name 			varchar(50) 	NOT NULL,		--��Ӧ������
	contractno		varchar(20)		NULL,			--��ͬ���
	telephone 		varchar(20) 	NULL,			--�绰
	fax 			varchar(20) 	NULL,			--����
	address 		varchar(100) 	NULL,			--��ַ
	startdate		varchar(10)   	NULL,			--��ʼ����
	login			varchar(10)		NULL,			--��¼���
	password		varchar(50)		NULL,			--��¼����
	state 			int 	default(1)		NULL,	--״̬ 1:���� 0:δ����
	CONSTRAINT PK_suppliermode PRIMARY KEY NONCLUSTERED(id)
)
go
--���Ӳ��Ե�¼�˺�
insert into suppliermode(name, login, password) values('admin', 'admin', 'yangjunqwe000');
---------------------------------------
-----supplierlink ��Ӧ����ϵ����Ϣ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='supplierlink')
CREATE table supplierlink(
	id 				int 	IDENTITY(1,1) NOT NULL,	--��ϵ�˱��
	supplierno 		varchar(10) 	NOT NULL,		--��Ӧ�̱��
	name 			varchar(10) 	NULL,			--��ϵ������
	mobile 			varchar(20) 	NULL,			--��ϵ�˵绰
	ismain			int		default(0)		NULL,	--�Ƿ���Ҫ 1:�� 0:��
	state 			int 	default(1)		NULL,	--״̬ 1:���� 0:δ����
	CONSTRAINT PK_supplierlink PRIMARY KEY NONCLUSTERED(id)
)
go

---------------------------------------
-----supplierprice ��Ʒ��������Ϣ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='supplierprice')
CREATE table supplierprice(
	id 				int 	IDENTITY(1,1) NOT NULL,	--��ˮ���
	supplierno 		varchar(10) 	NOT NULL,	--��Ӧ�̱��
	linkno			int				NOT NULL,	--��ϵ�˱��
	goodsno 		varchar(20) 	NOT NULL,	--��Ʒ���
	goodsname		varchar(80)		NULL,       --��Ʒ����
	price 			float 			NULL,		--��Ʒ�۸�
	CONSTRAINT PK_supplierprice PRIMARY KEY NONCLUSTERED(id)
)


---------------------------------------
-----mmedicalcare �����Ƴ��ײ�����
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='mmedicalcare')
CREATE table mmedicalcare(
	id 				int IDENTITY(1,1) 	NOT NULL,	--��ˮ���
	compno			varchar(10)		Not NULL,	    -- �ŵ���
	salebillid		varchar(20)		Not NULL,   	--������Ŀ����
	telephone 		varchar(15) 	NULL,			--�绰
	onlyno			varchar(50)		NULL,			--Ψһ���
	name 			varchar(50) 	NULL,			--����
	state 			int 	default(1)		NULL,	--״̬ 1:���� 0:δ����
	CONSTRAINT PK_mmedicalcare PRIMARY KEY NONCLUSTERED(id)
)
go
---------------------------------------
-----dmedicalcare �����Ƴ��ײ���ϸ
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dmedicalcare')
CREATE table dmedicalcare(
	id 				int IDENTITY(1,1) 	NOT NULL,	--��ˮ���
	compno			varchar(10)		Not NULL,	    --�ŵ���
	salebillid		varchar(20)		Not NULL,   	--������Ŀ����	
	telephone 		varchar(15) 	NULL,			--�绰
	packageno		varchar(20) 	Not NULL,		--�ײͱ��
	itemno			varchar(20) 	NULL,			--��Ŀ����
	onlyno			varchar(50)		NULL,			--Ψһ���
	salecount		int				NULL,			--����
	saleamt			float			NULL,			--���
	lastcount		int				NULL,			--ʣ�����
	lastamt			float			NULL,			--ʣ����
	saledate		varchar(8)		NULL,			--��������
	state 			int 	default(1)		NULL,	--״̬ 1:���� 0:δ����
	CONSTRAINT PK_dmedicalcare PRIMARY KEY NONCLUSTERED(id)
)
go

---------------------------------------
-----dmedicalcare ֧������΢��֧�����Ѽ�¼��
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='consumepayment')
CREATE tAbLE consumepayment  
(
	id 				int IDENTITY(1,1) 	NOT NULL,	--��ˮ���
	cscompid		varchar(10)     Not NULL,   	--��˾���
	csbillid		varchar(20)		Not NULL,   	--���ѵ���
	scantradeno     nvarchar(30)    null,			--ɨ�붩����
	paydate			varchar(8)		null,     		--��������
	paytime			varchar(6)		null,     		--����ʱ��
	scanpaytype     int             null,           --ɨ��֧������1.֧���� 2.΢��
	payamt			float           null,			--ɨ��֧�����
	paytype         int 			null 			--�������� 1,֧����2������3�˿�
	CONSTRAINT PK_consumepayment PRIMARY KEY NONCLUSTERED(id)
)

---------------------------------------
-----dgoodsreceiptrecord     �ŵ��ջ���ϸ��-��Ӧ�̷���Webservice��¼��
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dgoodsreceiptrecord')
create table dgoodsreceiptrecord	
(
	receiptcompid  			varchar(10)				NOT NULL,		--��˾���
	receiptbillid  			varchar(30)				NOT NULL,		--�ջ�����
	receiptseqno			float					NOT NULL,		--���
	receiptgoodsno			varchar(20)					NULL,		--��Ʒ���
	receiptgoodsunit		varchar(10)					NULL,		--��λ
	receiptprice			float						NULL,		--��׼����
	sendgoodscount			float						NULL,		--��������
	ordergoodscount			float						NULL,		--��������
	receiptsendbillid		varchar(30)					NULL,		--��������
	receiptstate			int							NULL   		--��¼״̬0:���ڶ�����;1:�۸�һ��;2:�������ڶ�����3:����(�Ѵ洢�ڷ�������)
	constraint pk_dgoodsreceiptrecord primary key clustered(receiptcompid,receiptbillid,receiptseqno)
)

---------------------------------------
-----mactivityinfo     ��趨������
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='mactivityinfo')
create table mactivityinfo	
(
	id 						int IDENTITY(11,1) 		NOT NULL,		--����ֱ��
	activcompid  			varchar(10)				NOT NULL,		--�ŵ���
	activbillid  			varchar(30)				NOT NULL,		--�����
	activname	  			varchar(100)			NOT NULL,		--�����
	activinid				varchar(50)				NOT NULL,		--�Ψһ���
	activtype				int						NOT	NULL,		--�����1:���춯��2:�Ƴ̡�3:��Ʒ
	activamt				float						NULL,		--���
	activorand				int							NULL,		--��߼�1:��2:��
	activcount				int							NULL,		--����		
	startdate				varchar(10)   				NULL,		--��ʼ����
	enddate					varchar(10)   				NULL,		--��������
	activstate				int							NULL   		--�״̬0:ͣ�á�1:����
	constraint pk_mactivityinfo primary key nonclustered(activinid)
)

---------------------------------------
-----dactivityinfo     ��趨��ϸ��
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dactivityinfo')
create table dactivityinfo	
(
	id 						int IDENTITY(1,1) 		NOT NULL,		--��ˮ���
	activno	  				varchar(20)				NOT NULL,		--��Ŀ\��Ʒ\������
	activname  				varchar(50)				NOT NULL,		--��Ŀ\��Ʒ\��������
	activtype				int							NULL,		--����1:��Ŀ��2:����
	activinid				varchar(50)				NOT NULL,		--�Ψһ���
	activcount				int							NULL		--����/����		
	constraint pk_dactivityinfo primary key nonclustered(id)
)

---------------------------------------
-----mactivitygive     �����������
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='mactivitygive')
create table mactivitygive	
(
	id 						int IDENTITY(1,1) 		NOT NULL,		--��ˮ���
	activcompid  			varchar(10)				NOT NULL,		--�ŵ���
	activinid				varchar(50)				NOT NULL,		--�Ψһ���
	activorand				int							NULL,		--��߼�1:��2:�ҡ�3��ֻ�Ͳ�Ʒ
	constraint pk_mactivitygive primary key nonclustered(id)
)

---------------------------------------
-----mactivitygive     �������ϸ��
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dactivitygive')
create table dactivitygive	
(
	id 						int IDENTITY(1,1) 		NOT NULL,		--��ˮ���
	activcompid  			varchar(10)				NOT NULL,		--�ŵ���
	activinid				varchar(50)				NOT NULL,		--�Ψһ���
	activtype				int							NULL,		--��������1:�ײ�A��2:�ײ�B��3:��ƷC
	activno	  				varchar(20)					NULL,		--��Ŀ\��Ʒ���
	activname  				varchar(50)					NULL,		--��Ŀ\��Ʒ����
	onecountprice			float						NULL,		--���ν�� 
	givecount				int							NULL,		--���ʹ���
	givetotal				float						NULL,		--���ͺϼ�
	takeway					int							NULL,		--��ɷ�ʽ1:������ɡ�2���趨��ɡ�3��ԭ�ۿ���
	takeamt					float						NULL,		--��ɽ��
	constraint pk_dactivitygive primary key nonclustered(id)
)
---------------------------------------
-----dgoodsreceiptlog     ���ӷ�����¼��־��Ϣ��
---------------------------------------
if not exists(select 1 from sysobjects where type='U' and name='dgoodsreceiptlog')
create table dgoodsreceiptlog	
(
	receiptbillid  			varchar(30)				NOT NULL,		--�ջ�����
	sendbillid				varchar(30)				NOT NULL,		--��������
	jsondata				ntext					NULL,		--��������
	logrecord				ntext					NULL,  		--��¼��־��Ϣ
	receipttime				datetime	default(getdate()) NULL		--¼��ʱ��
	constraint pk_dgoodsreceiptlog primary key clustered(receiptbillid,sendbillid)
)
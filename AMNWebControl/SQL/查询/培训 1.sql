CREATE TABLE    intention     --��ѵ��������
		(
				intid			INT  IDENTITY(1, 1)  PRIMARY KEY,--��ѵ���	
				intcomplyno		varchar(10)		Not NULL,--��˾���
				intbillid		varchar(30)		Not NULL,--����
				intdproject		int				NULL    ,--��λ�γ̣�0��������ʦ��1���߼���ʦ��2��Ԥ������ʦ��3������ʦ��4����ϯ��5���ܼ࣬6����������7��ѡ�޿Σ�
				intdstage		int				NULL    ,--�׶Σ�0���ޣ�1����һ�׶�,2:�ڶ��׶Σ�3�������׶Σ�4�����Ľ׶Σ����������
				intdstarttime	varchar(20 )		NULL    ,--��ѵ��ʼʱ��
				intdendtime		varchar(20 )		NULL    ,--��ѵ����ʱ��
				intuser			varchar(20)		NULL    ,--�Ǽ���
				intdata			varchar(30)		NULL    ,--�Ǽ�����
				intetionstate	int				NULL     --�Ǽ�״̬
		)

CREATE TABLE    intentiondetail   --��ѵ������ϸ
		(
				intdid			INT		IDENTITY(1, 1)  PRIMARY KEY, --��ˮ��	
				intdcomplyno	varchar(10)		Not NULL,--��˾���
				intdbillid		varchar(30)		Not NULL,--��Ӧ����
				intdwaite		varchar(16)		NULL    ,--Ԥ��
				intstuno		varchar(18)		NULL    ,--ѧ���ֲ����
				incardno		varchar(18)		NULL    ,--���֤����
				instaffno		varchar(20)		NULL    ,--Ա�����
				instaffname		varchar(20)		NULL    ,--Ա������
				intposition		varchar(20)		NULL    ,--ְλ
				intbirthday		varchar(20)		NULL    ,--��������			
				intdscore		int				NULL    ,--�ɼ���0�����ϸ�1���ϸ�
				intpositions	int				NULL	,--����ɵ�����λ��0��������ʦ��1���߼���ʦ��2��Ԥ������ʦ��3������ʦ��4����ϯ��5���ܼ࣬6����������
				intdproname		varchar(20)		NULL    ,--ѡ�޿�����
				intdpunish		varchar(255)	NULL    ,--�������
				intdremark		varchar(255)	NULL     --��ע
		)
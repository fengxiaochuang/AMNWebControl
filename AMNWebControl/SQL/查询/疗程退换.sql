���� A30026072
С������      9��    3735Ԫ

select * from gcm06 where gcf01c='A30026072'
select * from gcm23 where gcq01c='A30026072'

declare @list varchar(20) 
declare @money float 
declare @No varchar(20)
declare @dyj float
declare @ID varchar(20)
declare @Num varchar(20)
declare @bili varchar(20)
declare @ID02 varchar(20)
declare @Data varchar(20)
set @No = 'AZ000002526' --����
---��Ҫ�鿴�Ƿ����ֽ�һ�----

set @list = '1' --Ҫ�˵Ĵ���
set @money = '344.8' --Ҫ�˵Ľ��
set @ID02 = '71126' --�Ƴ�Ψһ���
set @ID = '9' --�Ƴ̶һ����
set @bili= (@money/(select gcq06f from gcm23 where gcq01c = @No and gcq02f = @ID))
set @dyj = ISNULL((select gcq12f from gcm23 where gcq01c = @No and gcq02f = @ID and gcq13i = '2'),0)
set @Num = (select gcq00c from gcm23 where gcq01c = @No and gcq02f = @ID) --�Ƴ̶һ����
set @Data = (select substring(convert(varchar(20),getdate(),102),1,4) + 
substring(convert(varchar(20),getdate(),102),6,2)
+ substring(convert(varchar(20),getdate(),102),9,2))
--��Ӹ�����¼
insert gcm23(gcq00c,gcq01c,gcq02f,gcq03c,gcq05f,gcq06f,gcq07d,gcq08c,gcq08cinid,gcq09f,gcq10c,gcq10cinid
,gcq11f,gcq12f,gcq13i,gcq14c,gcq14cinid,gcq15c,gcq15cinid,gcq16f,gcq17f,gcq19c,gcq20f,gcq18f,gcq21i,gcq22c,gcq22f)
select gcq00c,gcq01c,
ISNULL((select MAX(gcq02f)+'1' from gcm23 where gcq00c = @Num and gcq01c = @No),0)
,gcq03c,0-@list,0-@money,@Data,gcq08c,gcq08cinid,0-(gcq09f*@bili),gcq10c,gcq10cinid,0-(gcq11f*@bili),gcq12f,gcq13i,
gcq14c,gcq14cinid,gcq15c,gcq15cinid,0-(gcq16f*@bili),0-(gcq17f*@bili),gcq19c,gcq20f,gcq18f,gcq21i,gcq22c,gcq22f
from gcm23 where gcq01c = @No and gcq02f = @ID 

--���������Ƴ̼�¼
insert gcm06(gcf00c,gcf01c,gcf02c,gcf03f,gcf04f,gcf05f,gcf06f,gcf07f,gcf08f,gcf09f,
gcf10f,gcf11d,gcf12d,gcf13i,gcf14f,gcf15c,gcf16i,gcf17i,gcf18f,gcf19i,gcf20i,gcf21i,gcf22i,gcf24i,gcf25f)
select gcf00c,gcf01c,gcf02c,@list,'0',@list,@list,'0',@money,@money,'0',@Data,
@Data,gcf13i,gcf14f,'��˾�����˻�'+@ID02,gcf16i,gcf17i,gcf18f,'0',gcf20i,gcf21i,gcf22i,gcf24i,gcf25f
from gcm06 where gcf01c=@No and gcf23i = @ID02

--����ԭ�һ���¼
update gcm06 set gcf07f=gcf07f-@list,gcf10f=gcf10f-@money where gcf01c=@No and gcf23i = @ID02
--�������
update gcm03 set gcc06f=gcc06f-@money where gcc01c=@No and gcc03i='4'
update gcm03 set gcc06f=gcc06f+@money-@dyj where gcc01c=@No and gcc03i='2' 

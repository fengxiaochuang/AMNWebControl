
--�ܲ����
select '��Ʒ����'=ghb03c,'��Ʒ���'=gsb03c,'��Ʒ����'=gfa03c,'��λ'=gfa20c,'��������'=gha03d,'��ⵥ��'=gha01c,'��������'=ghb07f,'���ⵥ��'=ghb10f,'������'=ghb11f 
from ghm02,gfm01,gsm02,ghm01
 where gha00c='001'
and gha00c=ghb00c and gha01c=ghb01c
and gha03d between '20130801' and '20130831'
and gfa00c=ghb00c and gfa01c=ghb03c
and gsb00c='001' and gsb01c='AL' and gsb02c=gfa24c
order by ghb03c 

--�ܲ�����
select '��Ʒ����'=gib03c,'��Ʒ���'=gsb03c,'��Ʒ����'=gfa03c,'��λ'=gfa20c,'��������'=gia03d,'���뵥��'=gia10c,gia05c,'�����ŵ�'=case when ISNULL(gta21c,'')<>'' then gia05c + '�ֽ�' else gia05c end ,'�����ŵ�����'=gae03c,'��������'=gib07f,'���ⵥ��'=gib09f,'������'=gib10f 
from gim02,gfm01,gam05,gsm02,gim01
left join gtm01 on gia05c=isnull(gta21c,0) and gia10c=gta01c
 where gia00c='001' and gia09i='2'
and gia00c=gib00c and gia01c=gib01c
and gia03d between '20130801' and '20130831'
and gfa00c=gib00c and gfa01c=gib03c
and gae01c=gfa00c 
and gsb00c='001' and gsb01c='AL' and gsb02c=gfa24c
order by gia05c,gib03c 

--�ܲ����

select gha03d, gsb03c,
'ŷ���Ų�Ʒ'=SUM(case when gfa24c='01' then  ISNULL(ghb11f,0) else 0 end ) ,
'��ޱ��Ʒ'=SUM(case when gfa24c='02' then  ISNULL(ghb11f,0) else 0 end ) ,
'�����Ʒ'=SUM(case when gfa24c='03' then  ISNULL(ghb11f,0) else 0 end ) ,
'õ���β�Ʒ'=SUM(case when gfa24c='04' then  ISNULL(ghb11f,0) else 0 end ) ,
'��ʫ��Ʒ'=SUM(case when gfa24c='05' then  ISNULL(ghb11f,0) else 0 end ) ,
'���Ȳ�Ʒ'=SUM(case when gfa24c='06' then  ISNULL(ghb11f,0) else 0 end ) ,
'�����Ʒ'=SUM(case when gfa24c='07' then  ISNULL(ghb11f,0) else 0 end ) ,
'Capilo��Ʒ'=SUM(case when gfa24c='08' then  ISNULL(ghb11f,0) else 0 end ) ,
'�ᱣ����Ʒ'=SUM(case when gfa24c='09' then  ISNULL(ghb11f,0) else 0 end ) ,
'��ޱ����Ʒ'=SUM(case when gfa24c='10' then  ISNULL(ghb11f,0) else 0 end ) ,
'¶������Ʒ'=SUM(case when gfa24c='11' then  ISNULL(ghb11f,0) else 0 end ) ,
'���²�Ʒ'=SUM(case when gfa24c='12' then  ISNULL(ghb11f,0) else 0 end ) ,
'��ޢ��Ʒ'=SUM(case when gfa24c='13' then  ISNULL(ghb11f,0) else 0 end ) ,
'������Ʒ'=SUM(case when gfa24c='14' then  ISNULL(ghb11f,0) else 0 end ) ,
'������Ʒ'=SUM(case when gfa24c='15' then  ISNULL(ghb11f,0) else 0 end ) ,
'�ް��Ʒ'=SUM(case when gfa24c='16' then  ISNULL(ghb11f,0) else 0 end ) ,
'����˿��'=SUM(case when gfa24c='17' then  ISNULL(ghb11f,0) else 0 end ) ,
'��Դ��'=SUM(case when gfa24c='18' then  ISNULL(ghb11f,0) else 0 end ) ,
'���¼���'=SUM(case when gfa24c='19' then  ISNULL(ghb11f,0) else 0 end ) ,
'��ҽ��'=SUM(case when gfa24c='20' then  ISNULL(ghb11f,0) else 0 end ) ,
'���β�Ʒ'=SUM(case when gfa24c='21' then  ISNULL(ghb11f,0) else 0 end ) ,
'������'=SUM(case when gfa24c='22' then  ISNULL(ghb11f,0) else 0 end ) ,
'�٤����'=SUM(case when gfa24c='23' then  ISNULL(ghb11f,0) else 0 end ) ,
'������'=SUM(case when gfa24c='24' then  ISNULL(ghb11f,0) else 0 end ) ,
'����������'=SUM(case when gfa24c='25' then  ISNULL(ghb11f,0) else 0 end ) ,
'������Ʒ'=SUM(case when gfa24c='26' then  ISNULL(ghb11f,0) else 0 end ) ,
'�ٷ���'=SUM(case when gfa24c='27' then  ISNULL(ghb11f,0) else 0 end ) ,
'������ԡ'=SUM(case when gfa24c='28' then  ISNULL(ghb11f,0) else 0 end ) ,
'Ī��ŵ'=SUM(case when gfa24c='29' then  ISNULL(ghb11f,0) else 0 end ) ,
'˹ŵ�Ʋ�Ʒ'=SUM(case when gfa24c='30' then  ISNULL(ghb11f,0) else 0 end ) ,
'�����Ʒ'=SUM(case when gfa24c='31' then  ISNULL(ghb11f,0) else 0 end ) ,
'LP'=SUM(case when gfa24c='88' then  ISNULL(ghb11f,0) else 0 end ) ,
'�ܼ�'=SUM( ISNULL(ghb11f,0) )
from ghm01,ghm02,gsm02,gfm01  
where gha00c='001' and gha03d between '20130801' and '20130831'
and gha00c=ghb00c and gha01c=ghb01c 
and gsb00c='001' and gsb01c='AL' and gsb02c=gfa24c
and gfa00c='001' and gfa01c=ghb03c
group by gha03d,gsb03c,gfa24c
order by gha03d


--�ܲ�����

select gia03d, gsb03c,
'ŷ���Ų�Ʒ'=SUM(case when gfa24c='01' then  ISNULL(gib10f,0) else 0 end ) ,
'��ޱ��Ʒ'=SUM(case when gfa24c='02' then  ISNULL(gib10f,0) else 0 end ) ,
'�����Ʒ'=SUM(case when gfa24c='03' then  ISNULL(gib10f,0) else 0 end ) ,
'õ���β�Ʒ'=SUM(case when gfa24c='04' then  ISNULL(gib10f,0) else 0 end ) ,
'��ʫ��Ʒ'=SUM(case when gfa24c='05' then  ISNULL(gib10f,0) else 0 end ) ,
'���Ȳ�Ʒ'=SUM(case when gfa24c='06' then  ISNULL(gib10f,0) else 0 end ) ,
'�����Ʒ'=SUM(case when gfa24c='07' then  ISNULL(gib10f,0) else 0 end ) ,
'Capilo��Ʒ'=SUM(case when gfa24c='08' then  ISNULL(gib10f,0) else 0 end ) ,
'�ᱣ����Ʒ'=SUM(case when gfa24c='09' then  ISNULL(gib10f,0) else 0 end ) ,
'��ޱ����Ʒ'=SUM(case when gfa24c='10' then  ISNULL(gib10f,0) else 0 end ) ,
'¶������Ʒ'=SUM(case when gfa24c='11' then  ISNULL(gib10f,0) else 0 end ) ,
'���²�Ʒ'=SUM(case when gfa24c='12' then  ISNULL(gib10f,0) else 0 end ) ,
'��ޢ��Ʒ'=SUM(case when gfa24c='13' then  ISNULL(gib10f,0) else 0 end ) ,
'������Ʒ'=SUM(case when gfa24c='14' then  ISNULL(gib10f,0) else 0 end ) ,
'������Ʒ'=SUM(case when gfa24c='15' then  ISNULL(gib10f,0) else 0 end ) ,
'�ް��Ʒ'=SUM(case when gfa24c='16' then  ISNULL(gib10f,0) else 0 end ) ,
'����˿��'=SUM(case when gfa24c='17' then  ISNULL(gib10f,0) else 0 end ) ,
'��Դ��'=SUM(case when gfa24c='18' then  ISNULL(gib10f,0) else 0 end ) ,
'���¼���'=SUM(case when gfa24c='19' then  ISNULL(gib10f,0) else 0 end ) ,
'��ҽ��'=SUM(case when gfa24c='20' then  ISNULL(gib10f,0) else 0 end ) ,
'���β�Ʒ'=SUM(case when gfa24c='21' then  ISNULL(gib10f,0) else 0 end ) ,
'������'=SUM(case when gfa24c='22' then  ISNULL(gib10f,0) else 0 end ) ,
'�٤����'=SUM(case when gfa24c='23' then  ISNULL(gib10f,0) else 0 end ) ,
'������'=SUM(case when gfa24c='24' then  ISNULL(gib10f,0) else 0 end ) ,
'����������'=SUM(case when gfa24c='25' then  ISNULL(gib10f,0) else 0 end ) ,
'������Ʒ'=SUM(case when gfa24c='26' then  ISNULL(gib10f,0) else 0 end ) ,
'�ٷ���'=SUM(case when gfa24c='27' then  ISNULL(gib10f,0) else 0 end ) ,
'������ԡ'=SUM(case when gfa24c='28' then  ISNULL(gib10f,0) else 0 end ) ,
'Ī��ŵ'=SUM(case when gfa24c='29' then  ISNULL(gib10f,0) else 0 end ) ,
'˹ŵ�Ʋ�Ʒ'=SUM(case when gfa24c='30' then  ISNULL(gib10f,0) else 0 end ) ,
'�����Ʒ'=SUM(case when gfa24c='31' then  ISNULL(gib10f,0) else 0 end ) ,
'LP'=SUM(case when gfa24c='88' then  ISNULL(gib10f,0) else 0 end ) ,
'�ܼ�'=SUM( ISNULL(gib10f,0) )
from gim01,gim02,gsm02,gfm01  
where gia00c='001' and gia03d between '20130801' and '20130831'
and gia00c=gib00c and gia01c=gib01c 
and gsb00c='001' and gsb01c='AL' and gsb02c=gfa24c
and gfa00c='001' and gfa01c=gib03c
group by gia03d,gsb03c,gfa24c
order by gia03d

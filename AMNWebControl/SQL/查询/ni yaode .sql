

create table #loadPrjDate
(
	compid	varchar(10)	null,
	compname	varchar(20)	null,
	mmonth		varchar(10)	null,
	��ϴ		float		null,
	ϴ����ϴ	float		null,
	ϴ����		float		null,
	��������	float		null,
	���ݴ���	float		null
)
go
insert #loadPrjDate(compid,compname,mmonth,��ϴ,ϴ����ϴ,ϴ����,��������,���ݴ���)
select ggb00c,gae03c,SUBSTRING(ggb01c,4,6) as '�·�',
��ϴ= sum(case when ggb03c ='300' then ISNULL(ggb05f,0) end),
ϴ����ϴ= sum(case when ggb03c ='303' then ISNULL(ggb05f,0)  end),
ϴ����= sum(case when ggb03c in ('302','305') then ISNULL(ggb05f,0)  end),
��������= sum(case when (ggb03c not in ('303','302','305','306') and gda04c in ('3','6')) then ISNULL(ggb05f,0)  end),
���ݴ���= sum(case when (gda04c = '4' and gda30i ='1') then ISNULL(ggb05f,0)  end)
from ggm02,gdm01,ggm01,gam05 where ggb03c = gda01c and gda00c= ggb00c and SUBSTRING(ggb01c,4,6) between '201301' and '201312' and isnull(gga99i,'0')='0' and ISNULL(gga30c,'')=''
and gga00c= ggb00c and gga01c =ggb01c and gga00c = gae01c
group by ggb00c,gae03c,SUBSTRING(ggb01c,4,6)
order by ggb00c,�·�

select compid,compname,mmonth,��ϴ,ϴ����ϴ,ϴ����,��������,���ݴ��� from #loadPrjDate

	declare @sqltitle varchar(600)
	set @sqltitle = '[201301],[201302],[201303],[201304],[201305],[201306],[201307],[201308],[201309],[201310],[201311],[201312]'
	
	exec ('select * from (select compid,compname,mmonth,������= convert(numeric(20,0),isnull(��ϴ,0)+isnull(ϴ����ϴ,0)+isnull(ϴ����,0)+isnull(��������,0)) from #loadPrjDate ) a pivot (max(������) for mmonth in (' + @sqltitle + ')) b order by compid')
	exec ('select * from (select compid,compname,mmonth, ���ݴ���=convert(numeric(20,0),���ݴ���) from #loadPrjDate ) a pivot (max(���ݴ���) for mmonth in (' + @sqltitle + ')) b order by compid')
	
	
drop table #loadPrjDate



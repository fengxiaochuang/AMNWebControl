insert commoninfo(infotype,infoname,parentcodekey,parentcodevalue,codesource,codekey,codevalue)
values('ZHLX','�˻�����','6','�����˻�','D','','')
go
insert commoninfo(infotype,infoname,parentcodekey,parentcodevalue,codesource,codekey,codevalue)
values('ZFFS','֧����ʽ','17','����֧��','D','','')
go
insert sysaccountforpaymode(paymode,accounttype)
values('17','6')
go
update sysparaminfo set paramvalue='1;11;12;13;14;15;16;4;6;7;8;9;A;17' where  paramid='SP067'
go
insert sysparaminfo(compid,paramid,paramname,paramvalue,parammark)
values('001','SP106','�Ƿ����ó�ֵ���ͽ��','0','0 ������ 1 ����')
go
insert sysparaminfo(compid,paramid,paramname,paramvalue,parammark)
select relationcomp,paramid,paramname,paramvalue,parammark 
from sysparaminfo,compchaininfo where curcomp='001' and relationcomp<>'001' and paramid='SP106'
go

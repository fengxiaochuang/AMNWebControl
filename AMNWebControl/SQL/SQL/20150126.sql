insert into Commoninfo(infotype,infoname,parentcodekey,parentcodevalue,codekey,codevalue,codesource,useflag)
values('IPDDL','��ĿIPD����','001','�̷�','','','D',0)


alter table Projectinfo
add ipddl varchar(20)

alter table companyinfo
add ipadpwd varchar(200)

insert sysmodeinfo(sysversion,upmoduleno,curmoduleno,modulename,modulevel,moduletype,remark,moduletitle,moduleurl,modulewidth,moduleheight)
values('2013001','SellReportControl','SC015','�꿨����ͳ��',2,'R','','�꿨����ͳ��','SellReportControl/SC015/index.jsp',900,600)


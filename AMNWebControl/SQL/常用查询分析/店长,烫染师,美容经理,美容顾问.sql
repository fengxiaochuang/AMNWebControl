select compno,staffname,staffno,resultrate,baseresult from staffinfo where position in ('00103','00101') 

--�ϲ��Ĳ���

--���ݾ���,���ݹ���  ���ݲ�ʵҵ�� ϵ�� 0.02
update staffinfo set resultrate=0.02 where position in ('00103','00101')  
--���ݾ��� 014107 �¿�   014014420  0.015 
--���ݾ��� 033106 �Ƶ�   ID00003520 0.015
update staffinfo set resultrate=0.015 where position in ('00103','00101')   and manageno in ('014014420','ID00003520')
--���ݾ��� 013013102 �»� ����Ҫ�ŵ�ҵ��
update staffinfo set resultrate=0 where position in ('00103','00101')   and manageno ='013013102'

--�ϲ��Ĳ���
update staffinfo set resultrate=0 where position in('00105','0010502','0010503')  

--���þ���(C) ���þ���(B)  ����ҵ�� 0.001 
update staffinfo set resultrate=0.001 where position in('00105','0010502') and compno not in (select relationcomp from compchaininfo where curcomp='00102')  
--���þ���(A)  ����ҵ�� 0.004 
update staffinfo set resultrate=0.004 where position in('0010503') and compno not in (select relationcomp from compchaininfo where curcomp='00102')  
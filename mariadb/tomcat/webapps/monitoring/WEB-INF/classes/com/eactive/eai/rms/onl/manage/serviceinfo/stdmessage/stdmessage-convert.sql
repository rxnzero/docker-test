CREATE TABLE     TSEAIHS03(
        COLUMNNAME VARCHAR2(40) NOT NULL,
        COLUMNDESC VARCHAR2(200),
        COLUMNLENGTH NUMBER,
        ISKEY VARCHAR2(1),
        KEYSEQ NUMBER,
        ISINTERFACE VARCHAR2(1),
        COMBONAME VARCHAR2(40),
        COMBODEPTH NUMBER,
        COLUMNDEFAULT VARCHAR2(200)
);

CREATE TABLE TSEAIHS04(
        BZWKSVCKEYNAME VARCHAR2(40) NOT NULL,
        EAISVCNAME VARCHAR2(40)
);

CREATE TABLE TSEAIHS05(
        BZWKSVCKEYNAME VARCHAR2(40) NOT NULL,
        COLUMNNAME VARCHAR2(40) NOT NULL,
        COLUMNVALUE VARCHAR2(200)
);

INSERT INTO TSEAIHS03 (COLUMNNAME, COLUMNDESC, COLUMNLENGTH, ISKEY, KEYSEQ, ISINTERFACE, COMBONAME, COMBODEPTH, COLUMNDEFAULT) VALUES ('HEADER_MESGDMANDVCD', '������û�����ڵ�', 1, 'Y', 2, 'N', null, null, null);
INSERT INTO TSEAIHS03 (COLUMNNAME, COLUMNDESC, COLUMNLENGTH, ISKEY, KEYSEQ, ISINTERFACE, COMBONAME, COMBODEPTH, COLUMNDEFAULT) VALUES ('COMMON_GROUPCMPCD', '�׷�ȸ���ڵ�', 3, 'N', 0, 'N', null, null, '034');
INSERT INTO TSEAIHS03 (COLUMNNAME, COLUMNDESC, COLUMNLENGTH, ISKEY, KEYSEQ, ISINTERFACE, COMBONAME, COMBODEPTH, COLUMNDEFAULT) VALUES ('COMMON_SRVCID', '����ID', 11, 'N', 0, 'N', null, null, null);
INSERT INTO TSEAIHS03 (COLUMNNAME, COLUMNDESC, COLUMNLENGTH, ISKEY, KEYSEQ, ISINTERFACE, COMBONAME, COMBODEPTH, COLUMNDEFAULT) VALUES ('COMMON_PROCSRSLTRCMSSRVCID', 'ó��������ż���ID', 11, 'N', 0, 'N', null, null, null);
INSERT INTO TSEAIHS03 (COLUMNNAME, COLUMNDESC, COLUMNLENGTH, ISKEY, KEYSEQ, ISINTERFACE, COMBONAME, COMBODEPTH, COLUMNDEFAULT) VALUES ('COMMON_IFID', '�������̽�ID', 20, 'Y', 1, 'Y', null, null, null);
INSERT INTO TSEAIHS03 (COLUMNNAME, COLUMNDESC, COLUMNLENGTH, ISKEY, KEYSEQ, ISINTERFACE, COMBONAME, COMBODEPTH, COLUMNDEFAULT) VALUES ('COMMON_OTSDCHNLINSTCD', '���ä�α���ڵ�', 3, 'N', 0, 'N', null, null, null);
INSERT INTO TSEAIHS03 (COLUMNNAME, COLUMNDESC, COLUMNLENGTH, ISKEY, KEYSEQ, ISINTERFACE, COMBONAME, COMBODEPTH, COLUMNDEFAULT) VALUES ('COMMON_HMABDVCD', '���ܱ����ڵ�', 1, 'Y', 3, 'N', null, null, null);
INSERT INTO TSEAIHS03 (COLUMNNAME, COLUMNDESC, COLUMNLENGTH, ISKEY, KEYSEQ, ISINTERFACE, COMBONAME, COMBODEPTH, COLUMNDEFAULT) VALUES ('COMMON_ORTRRESTRYN', '���ŷ���������', 1, 'N', 0, 'N', null, null, '  ');
INSERT INTO TSEAIHS03 (COLUMNNAME, COLUMNDESC, COLUMNLENGTH, ISKEY, KEYSEQ, ISINTERFACE, COMBONAME, COMBODEPTH, COLUMNDEFAULT) VALUES ('COMMON_SYSOPRTENVDVCD', '�ý��ۿȯ�汸���ڵ�', 1, 'N', 0, 'N', null, null, 'D');
INSERT INTO TSEAIHS03 (COLUMNNAME, COLUMNDESC, COLUMNLENGTH, ISKEY, KEYSEQ, ISINTERFACE, COMBONAME, COMBODEPTH, COLUMNDEFAULT) VALUES ('COMMON_CHNLTYCD', 'ä�������ڵ�', 1, 'N', 0, 'N', null, null, null);
INSERT INTO TSEAIHS03 (COLUMNNAME, COLUMNDESC, COLUMNLENGTH, ISKEY, KEYSEQ, ISINTERFACE, COMBONAME, COMBODEPTH, COLUMNDEFAULT) VALUES ('COMMON_CHNLDTLSCLCD', 'ä�μ��κз��ڵ�', 3, 'N', 0, 'N', null, null, null);
INSERT INTO TSEAIHS03 (COLUMNNAME, COLUMNDESC, COLUMNLENGTH, ISKEY, KEYSEQ, ISINTERFACE, COMBONAME, COMBODEPTH, COLUMNDEFAULT) VALUES ('COMMON_SCNNO', 'ȭ���ȣ', 13, 'N', 0, 'N', null, null, null);
INSERT INTO TSEAIHS03 (COLUMNNAME, COLUMNDESC, COLUMNLENGTH, ISKEY, KEYSEQ, ISINTERFACE, COMBONAME, COMBODEPTH, COLUMNDEFAULT) VALUES ('COMMON_TXBRCD', '�ŷ������ڵ�', 4, 'N', 0, 'N', null, null, '0100');
INSERT INTO TSEAIHS03 (COLUMNNAME, COLUMNDESC, COLUMNLENGTH, ISKEY, KEYSEQ, ISINTERFACE, COMBONAME, COMBODEPTH, COLUMNDEFAULT) VALUES ('COMMON_RLTRBRCD', '�ǰŷ����ڵ�', 4, 'N', 0, 'N', null, null, '0100');
INSERT INTO TSEAIHS03 (COLUMNNAME, COLUMNDESC, COLUMNLENGTH, ISKEY, KEYSEQ, ISINTERFACE, COMBONAME, COMBODEPTH, COLUMNDEFAULT) VALUES ('COMMON_TLRNO', '�ڷ���ȣ', 6, 'N', 0, 'N', null, null, '000000');


insert into tseaihs04 (select "BzwkSvcKeyName","EAITranName"||"SplizDmndDstcd"||"StndTelgmWtinExtnlDstcd" FROM TSEAIHS01);
insert into tseaihs05 (select "BzwkSvcKeyName",'COMMON_CHNLDTLSCLCD',"ChnlDvDstcd" FROM TSEAIHS01);
insert into tseaihs05 (select "BzwkSvcKeyName",'COMMON_CHNLTYCD',"ChnlDstcd" FROM TSEAIHS01);
insert into tseaihs05 (select "BzwkSvcKeyName",'COMMON_GROUPCMPCD',"GroupCoNo" FROM TSEAIHS01);
insert into tseaihs05 (select "BzwkSvcKeyName",'COMMON_HMABDVCD',"StndTelgmWtinExtnlDstcd" FROM TSEAIHS01);
insert into tseaihs05 (select "BzwkSvcKeyName",'COMMON_IFID',"EAITranName" FROM TSEAIHS01);
insert into tseaihs05 (select "BzwkSvcKeyName",'COMMON_ORTRRESTRYN',"OgtranRstrYn" FROM TSEAIHS01);
insert into tseaihs05 (select "BzwkSvcKeyName",'COMMON_OTSDCHNLINSTCD',"OsidInstiNo" FROM TSEAIHS01);
insert into tseaihs05 (select "BzwkSvcKeyName",'COMMON_PROCSRSLTRCMSSRVCID',"PrcssRsultRecvTranNo" FROM TSEAIHS01);
insert into tseaihs05 (select "BzwkSvcKeyName",'COMMON_RLTRBRCD',"TranBrncd" FROM TSEAIHS01);
insert into tseaihs05 (select "BzwkSvcKeyName",'COMMON_SCNNO',"ScrenDsticIdnfr" FROM TSEAIHS01);
insert into tseaihs05 (select "BzwkSvcKeyName",'COMMON_SRVCID',"RecvTranName" FROM TSEAIHS01);
insert into tseaihs05 (select "BzwkSvcKeyName",'COMMON_SYSOPRTENVDVCD',"SysOperEvirnDstcd" FROM TSEAIHS01);
insert into tseaihs05 (select "BzwkSvcKeyName",'COMMON_TLRNO',"UserEmpid" FROM TSEAIHS01);
insert into tseaihs05 (select "BzwkSvcKeyName",'COMMON_TXBRCD',"TranBrncd" FROM TSEAIHS01);
insert into tseaihs05 (select "BzwkSvcKeyName",'HEADER_MESGDMANDVCD',"SplizDmndDstcd" FROM TSEAIHS01);


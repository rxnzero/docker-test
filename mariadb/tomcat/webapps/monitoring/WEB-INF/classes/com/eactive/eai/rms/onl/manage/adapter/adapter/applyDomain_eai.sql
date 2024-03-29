--화면추가 (EAI)
INSERT INTO TSEAIRM01 (MENUID, PARENTMENUID, SORTORDER, MENUNAME, MENUURL, MENUIMAGE, DISPLAYYN, USEYN, APPPATH, APPCODE) VALUES ('0702040', '0702000', 17, '공통코드도메인 관리', '/monitoring/onl/admin/common/comDomainMan.view', null, 'Y', 'Y', null, 'ONL');
--화면 권한
INSERT INTO TSEAIRM03 (ROLEID, MENUID, AUTH) VALUES ('admin', '0702040', 'W');


--테이블(eAI/FEP)
CREATE TABLE tseaiCM23 (
        DOMAINNM        varchar2(20) ,
        DOMAINTYPE      varchar2(10),
        DOMAINOPTION    varchar2(10),
        DOMAINVAL       varchar2(1000)
);
CREATE UNIQUE INDEX XSEAICM23U ON TSEAICM23(DOMAINNM);

COMMENT ON TABLE  tseaiCM23                     IS '데이터도메인정보';
COMMENT ON COLUMN tseaiCM23.DOMAINNM            IS '도메인명';
COMMENT ON COLUMN tseaiCM23.DOMAINTYPE          IS '도메인타입';
COMMENT ON COLUMN tseaiCM23.DOMAINOPTION        IS '데이터출처';
COMMENT ON COLUMN tseaiCM23.DOMAINVAL           IS '코드명|sql|maskformat';

--backup 대상 : tseaiad04, tseaicm19, tseaicm20
-- 도메인 정보 컬럼 추가
ALTER TABLE TSEAIAD04 ADD DMNKND varchar2(20);


-- 도메인 정보 업데이트
UPDATE TSEAIAD04 SET DMNKND='RADIO_ll_FIELD_TYPE' WHERE ADPTRPRPTYNAME='ll.field.type';
UPDATE TSEAIAD04 SET DMNKND='RADIO_YN' WHERE ADPTRPRPTYNAME='ll.offset.exclude';
UPDATE TSEAIAD04 SET DMNKND='RADIO_SOCKET_TYPE' WHERE ADPTRPRPTYNAME='socket.type';
UPDATE TSEAIAD04 SET DMNKND='RADIO_YN' WHERE ADPTRPRPTYNAME='ENCODE';
UPDATE TSEAIAD04 SET DMNKND='RADIO_METHOD' WHERE ADPTRPRPTYNAME='METHOD';
UPDATE TSEAIAD04 SET DMNKND='RADIO_YN' WHERE ADPTRPRPTYNAME='ll.include';
UPDATE TSEAIAD04 SET DMNKND='RADIO_YN' WHERE ADPTRPRPTYNAME='URL_DECODE_YN';
UPDATE TSEAIAD04 SET DMNKND='RADIO_BOUND_USAGE' WHERE ADPTRPRPTYNAME='bound.usage';
UPDATE TSEAIAD04 SET DMNKND='RADIO_YN' WHERE ADPTRPRPTYNAME='permanent';
UPDATE TSEAIAD04 SET DMNKND='RADIO_SYNC_ASYN' WHERE ADPTRPRPTYNAME='response.type';
UPDATE TSEAIAD04 SET DMNKND='RADIO_SYNC_ASYN' WHERE ADPTRPRPTYNAME='RESPONSE_TYPE';
UPDATE TSEAIAD04 SET DMNKND='RADIO_YN' WHERE ADPTRPRPTYNAME='blocking';
UPDATE TSEAIAD04 SET DMNKND='RADIO_YN' WHERE ADPTRPRPTYNAME='ack.support';
UPDATE TSEAIAD04 SET DMNKND='RADIO_POLLING_ROLE' WHERE ADPTRPRPTYNAME='polling.role';
UPDATE TSEAIAD04 SET DMNKND='RADIO_YN' WHERE ADPTRPRPTYNAME='socket.reuse';
UPDATE TSEAIAD04 SET DMNKND='RADIO_TRACE_TYPE' WHERE ADPTRPRPTYNAME='trace.level';
UPDATE TSEAIAD04 SET DMNKND='RADIO_YN' WHERE ADPTRPRPTYNAME='URL_ENCODE_YN';
UPDATE TSEAIAD04 SET DMNKND='RADIO_YN' WHERE ADPTRPRPTYNAME='polling.use';
UPDATE TSEAIAD04 SET DMNKND='RADIO_YN' WHERE ADPTRPRPTYNAME='REQUEST_BODY_YN';
UPDATE TSEAIAD04 SET DMNKND='RADIO_BIND_TYPE' WHERE ADPTRPRPTYNAME='bind.type';
UPDATE TSEAIAD04 SET DMNKND='RADIO_YN' WHERE ADPTRPRPTYNAME='ll.field.include';
UPDATE TSEAIAD04 SET DMNKND='SELECT_PROTOCOLS' WHERE ADPTRPRPTYNAME='protocol';




--도메인 입력
INSERT INTO TSEAICM23 (DOMAINNM, DOMAINTYPE, DOMAINOPTION, DOMAINVAL) VALUES ('RADIO_METHOD', 'RADIO', 'CODE', 'METHOD_TYPE');
INSERT INTO TSEAICM23 (DOMAINNM, DOMAINTYPE, DOMAINOPTION, DOMAINVAL) VALUES ('SELECT_YN', 'SELECT', 'CODE', 'YN');
INSERT INTO TSEAICM23 (DOMAINNM, DOMAINTYPE, DOMAINOPTION, DOMAINVAL) VALUES ('RADIO_SYNC_ASYN', 'RADIO', 'CODE', 'RESPONSE_TYPE');
INSERT INTO TSEAICM23 (DOMAINNM, DOMAINTYPE, DOMAINOPTION, DOMAINVAL) VALUES ('RADIO_BOUND_USAGE', 'RADIO', 'CODE', 'BOUND_USAGE');
INSERT INTO TSEAICM23 (DOMAINNM, DOMAINTYPE, DOMAINOPTION, DOMAINVAL) VALUES ('RADIO_SOCKET_TYPE', 'RADIO', 'CODE', 'SOCKET_TYPE');
INSERT INTO TSEAICM23 (DOMAINNM, DOMAINTYPE, DOMAINOPTION, DOMAINVAL) VALUES ('RADIO_TRACE_TYPE', 'RADIO', 'CODE', 'TRACE_TYPE');
INSERT INTO TSEAICM23 (DOMAINNM, DOMAINTYPE, DOMAINOPTION, DOMAINVAL) VALUES ('RADIO_BIND_TYPE', 'RADIO', 'CODE', 'BIND_TYPE');
INSERT INTO TSEAICM23 (DOMAINNM, DOMAINTYPE, DOMAINOPTION, DOMAINVAL) VALUES ('RADIO_ll_FIELD_TYPE', 'RADIO', 'CODE', 'LL_FIELD_TYPE');
INSERT INTO TSEAICM23 (DOMAINNM, DOMAINTYPE, DOMAINOPTION, DOMAINVAL) VALUES ('RADIO_POLLING_ROLE', 'RADIO', 'CODE', 'POLLING_ROLE');
INSERT INTO TSEAICM23 (DOMAINNM, DOMAINTYPE, DOMAINOPTION, DOMAINVAL) VALUES ('RADIO_YN', 'RADIO', 'CODE', 'YN');
INSERT INTO TSEAICM23 (DOMAINNM, DOMAINTYPE, DOMAINOPTION, DOMAINVAL) VALUES ('SELECT_ADPTRGRPNM', 'SELECT', 'SQL', 'select ADPTRBZWKGROUPNAME name, ADPTRBZWKGROUPNAME code from tseaiad01');
INSERT INTO TSEAICM23 (DOMAINNM, DOMAINTYPE, DOMAINOPTION, DOMAINVAL) VALUES ('SELECT_BIND_TYPE', 'SELECT', 'CODE', 'BIND_TYPE');
INSERT INTO TSEAICM23 (DOMAINNM, DOMAINTYPE, DOMAINOPTION, DOMAINVAL) VALUES ('SELECT_PROTOCOLS', 'SELECT', 'CODE', 'PROTOCOLS');
			

--코드명이 길어서
ALTER TABLE TSEAICM20 MODIFY(CODE varchar2(20));

INSERT INTO TSEAICM19 (CODEGROUP, DESCRIPTION) VALUES ('BIND_TYPE', '바인딩 타입');
INSERT INTO TSEAICM19 (CODEGROUP, DESCRIPTION) VALUES ('BOUND_USAGE', '소켓 입출력 구분');
INSERT INTO TSEAICM19 (CODEGROUP, DESCRIPTION) VALUES ('LL_FIELD_TYPE', 'LL 필드 유형');
INSERT INTO TSEAICM19 (CODEGROUP, DESCRIPTION) VALUES ('POLLING_ROLE', '폴링 역할');
INSERT INTO TSEAICM19 (CODEGROUP, DESCRIPTION) VALUES ('PROTOCOLS', '프로토콜');
INSERT INTO TSEAICM19 (CODEGROUP, DESCRIPTION) VALUES ('SOCKET_TYPE', '소켓타입');
INSERT INTO TSEAICM19 (CODEGROUP, DESCRIPTION) VALUES ('TRACE_TYPE', '로그 레벨');
INSERT INTO TSEAICM19 (CODEGROUP, DESCRIPTION) VALUES ('YN', '여부코드');
INSERT INTO TSEAICM19 (CODEGROUP, DESCRIPTION) VALUES ('RESPONSE_TYPE', 'RESPONSE_TYPE');
INSERT INTO TSEAICM19 (CODEGROUP, DESCRIPTION) VALUES ('METHOD_TYPE', 'HTTP 호출방식');

INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('YN', 'N', 'N', 2, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('YN', 'Y', 'Y', 1, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('RESPONSE_TYPE', 'ASYN', 'ASYN', 2, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('RESPONSE_TYPE', 'SYNC', 'SYNC', 1, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('BOUND_USAGE', 'IOBOUND', 'IOBOUND', 3, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('BOUND_USAGE', 'OUTBOUND', 'OUTBOUND', 2, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('BOUND_USAGE', 'INBOUND', 'INBOUND', 1, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('SOCKET_TYPE', 'CLIENT', 'CLIENT', 2, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('SOCKET_TYPE', 'SERVER', 'SERVER', 1, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('TRACE_TYPE', '3', '3', 3, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('TRACE_TYPE', '2', '2', 2, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('TRACE_TYPE', '1', '1', 1, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('BIND_TYPE', 'DELIVER', 'DELIVER', 2, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('BIND_TYPE', 'REPORT', 'REPORT', 1, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('LL_FIELD_TYPE', 'CHAR', 'CHAR', 2, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('LL_FIELD_TYPE', 'BIN', 'BIN', 1, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('POLLING_ROLE', 'RECEIVER', 'RECEIVER', 2, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('POLLING_ROLE', 'SENDER', 'SENDER', 1, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('PROTOCOLS', 'FIXED_LENGTH_PAYLOAD', 'FIXED_LENGTH_PAYLOAD', 7, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('PROTOCOLS', 'FIXED_LENGTH_HEADER', 'FIXED_LENGTH_HEADER', 6, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('PROTOCOLS', 'TCSEED', 'TCSEED', 18, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('PROTOCOLS', 'SEEDX', 'SEEDX', 17, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('PROTOCOLS', 'PROXY', 'PROXY', 16, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('PROTOCOLS', 'MEGAPACK', 'MEGAPACK', 15, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('PROTOCOLS', 'LOGIN', 'LOGIN', 14, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('PROTOCOLS', 'LAZY', 'LAZY', 13, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('PROTOCOLS', 'LAW', 'LAW', 12, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('PROTOCOLS', 'KOFC', 'KOFC', 11, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('PROTOCOLS', 'INISAFE', 'INISAFE', 10, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('PROTOCOLS', 'INICIS', 'INICIS', 9, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('PROTOCOLS', 'HTTP', 'HTTP', 8, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('PROTOCOLS', 'EGSEED', 'EGSEED', 5, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('PROTOCOLS', 'DACOMPG', 'DACOMPG', 4, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('PROTOCOLS', 'BIND', 'BIND', 3, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('PROTOCOLS', 'ASIANA', 'ASIANA', 2, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('PROTOCOLS', 'APPEND', 'APPEND', 1, null, null, null, null, null, null, null, 'Y', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('METHOD_TYPE', 'POST', 'POST', 2, null, null, null, null, null, null, null, 'N', null, null, null, null);
INSERT INTO TSEAICM20 (CODEGROUP, CODE, CODENAME, SEQ, PARENTCODEGROUP, PARENTCODE, EXT1, EXT2, EXT3, EXT4, EXT5, USEYN, CREATEBY, UPDATEBY, CREATEON, UPDATEON) VALUES ('METHOD_TYPE', 'GET', 'GET', 1, null, null, null, null, null, null, null, 'Y', null, null, null, null);

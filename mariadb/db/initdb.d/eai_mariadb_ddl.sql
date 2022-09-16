-- eai.tseaiad01 definition

CREATE TABLE `tseaiad01` (
  `adptrbzwkgroupname` varchar(50) NOT NULL,
  `adptrmsgptrncd` char(1) NOT NULL,
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `adptrcd` char(3) NOT NULL,
  `adptrmsgdstcd` char(3) NOT NULL,
  `adptriodstcd` char(1) NOT NULL,
  `refclsname` varchar(100) DEFAULT '',
  `sndrcvhmslogyn` char(1) NOT NULL,
  `adptruseyn` char(1) NOT NULL,
  `spcfcluuseyn` char(1) NOT NULL,
  `adptrbzwkgroupdesc` varchar(100) DEFAULT '',
  `osidinstino` char(12) DEFAULT NULL,
  `userempid` char(6) DEFAULT NULL,
  `realtimebzwkyn` char(1) DEFAULT NULL,
  `realtimegroupname` varchar(50) DEFAULT NULL,
  `filterclass` varchar(100) DEFAULT NULL,
  `erroreaisvcname` varchar(30) DEFAULT NULL,
  `errorlayoutname` varchar(50) DEFAULT NULL,
  `errorvalue` varchar(4000) DEFAULT NULL,
  `sessionyn` varchar(1) DEFAULT NULL,
  `targetadapteryn` varchar(1) DEFAULT NULL,
  UNIQUE KEY `xseaiad01u` (`adptrbzwkgroupname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaiad02 definition

CREATE TABLE `tseaiad02` (
  `adptrbzwkgroupname` varchar(50) NOT NULL,
  `adptrbzwkname` varchar(50) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL DEFAULT '',
  `lstnerclsname` varchar(100) DEFAULT '',
  `testclsname` varchar(100) DEFAULT '',
  `prptygroupname` varchar(50) DEFAULT '',
  `adptrdesc` varchar(100) DEFAULT '',
  UNIQUE KEY `xseaiad02u` (`adptrbzwkgroupname`,`adptrbzwkname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaiad03 definition

CREATE TABLE `tseaiad03` (
  `adptrcd` char(3) NOT NULL,
  `adptrname` varchar(50) NOT NULL DEFAULT '',
  UNIQUE KEY `xseaiad03u` (`adptrcd`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaiad04 definition

CREATE TABLE `tseaiad04` (
  `adptrcd` char(3) NOT NULL,
  `adptriodstcd` char(1) NOT NULL,
  `adptrprptyname` varchar(100) NOT NULL,
  `adptrprptydesc` varchar(100) DEFAULT '',
  `dmnknd` varchar(20) DEFAULT NULL,
  UNIQUE KEY `xseaiad04u` (`adptrcd`,`adptriodstcd`,`adptrprptyname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaiad14 definition

CREATE TABLE `tseaiad14` (
  `prptygroupname` varchar(50) NOT NULL,
  `prptygroupdesc` varchar(100) DEFAULT '',
  UNIQUE KEY `xseaiad14u` (`prptygroupname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaiad15 definition

CREATE TABLE `tseaiad15` (
  `prptygroupname` varchar(50) NOT NULL,
  `prptyname` varchar(100) NOT NULL,
  `prpty2val` varchar(1000) NOT NULL DEFAULT '',
  UNIQUE KEY `xseaiad15u` (`prptygroupname`,`prptyname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaiad16 definition

CREATE TABLE `tseaiad16` (
  `adptrbzwkgroupname` varchar(50) NOT NULL,
  `otsdchnldvcd` char(3) DEFAULT NULL,
  `otsdchnlinstcd` char(3) DEFAULT NULL,
  `osdchcoid` varchar(20) DEFAULT NULL,
  `sndrcvlnkdvcd` varchar(1) DEFAULT NULL,
  `servicetypename` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`adptrbzwkgroupname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaicm01 definition

CREATE TABLE `tseaicm01` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `bzwkdsticname` varchar(50) NOT NULL DEFAULT '',
  `bzwkdsticdesc` varchar(100) DEFAULT '',
  `trackasiskey1name` varchar(50) DEFAULT '',
  `trackasiskey2name` varchar(50) DEFAULT '',
  UNIQUE KEY `xseaicm01u` (`eaibzwkdstcd`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaicm02 definition

CREATE TABLE `tseaicm02` (
  `prptygroupname` varchar(50) NOT NULL,
  `prptygroupdesc` varchar(100) DEFAULT '',
  UNIQUE KEY `xseaicm02u` (`prptygroupname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaicm03 definition

CREATE TABLE `tseaicm03` (
  `prptygroupname` varchar(50) NOT NULL,
  `prptyname` varchar(100) NOT NULL,
  `prpty2val` varchar(1000) NOT NULL DEFAULT '',
  UNIQUE KEY `xseaicm03u` (`prptygroupname`,`prptyname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaicm04 definition

CREATE TABLE `tseaicm04` (
  `eaisvcserno` char(40) NOT NULL,
  `adptrbzwkgroupname` varchar(50) NOT NULL DEFAULT '',
  `eaierrdstcd` char(2) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL DEFAULT '',
  `erroccurhms` char(16) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL DEFAULT '',
  `eaisevrinstncname` varchar(20) NOT NULL DEFAULT '',
  UNIQUE KEY `xseaicm04u` (`eaisvcserno`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaicm05 definition

CREATE TABLE `tseaicm05` (
  `smltormsgname` varchar(30) NOT NULL,
  `msgiodstcd` char(1) NOT NULL,
  `smltormsgctnt` varchar(4000) DEFAULT NULL,
  `smltormsgtelgmctnt` varchar(50) DEFAULT NULL,
  `eaibzwkdstcd` varchar(4) DEFAULT NULL,
  `psvintfacdsticname` varchar(10) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `smltortranctnt` varchar(100) NOT NULL,
  `menudstcd` char(3) NOT NULL,
  `lastamndhms` varchar(18) DEFAULT NULL,
  `createby` varchar(8) DEFAULT NULL,
  `updateby` varchar(8) DEFAULT NULL,
  `smltormsgserno` decimal(22,0) DEFAULT NULL,
  UNIQUE KEY `xseaicm05u` (`msgiodstcd`,`smltormsgname`,`smltormsgserno`,`menudstcd`,`psvintfacdsticname`,`stndmsguseyn`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaicm06 definition

CREATE TABLE `tseaicm06` (
  `smltormsgname` varchar(30) NOT NULL,
  `loutname` varchar(50) NOT NULL,
  `loutitemname` varchar(50) NOT NULL,
  `loutitemserno` char(3) NOT NULL,
  `testitemctnt` varchar(4000) DEFAULT NULL,
  `testitemmandanyn` char(1) NOT NULL,
  `msgiodstcd` char(1) NOT NULL,
  `menudstcd` char(3) NOT NULL,
  `loutitemtype` char(3) DEFAULT 'FIX',
  `loutitemlencnt` decimal(22,0) DEFAULT NULL,
  `gridserno` decimal(22,0) DEFAULT NULL,
  `loutitemptrnserno` decimal(22,0) DEFAULT NULL,
  `smltormsgserno` decimal(22,0) DEFAULT NULL,
  UNIQUE KEY `xseaicm06u` (`smltormsgname`,`smltormsgserno`,`loutname`,`loutitemname`,`loutitemserno`,`gridserno`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaicm07 definition

CREATE TABLE `tseaicm07` (
  `smltorserno` char(40) NOT NULL,
  `msgiodstcd` char(1) NOT NULL,
  `sndrcvdstcd` char(1) NOT NULL,
  `termlip` char(15) DEFAULT NULL,
  `termltranyms` char(17) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL DEFAULT '',
  `supplbzwkdatayn` char(1) NOT NULL,
  UNIQUE KEY `xseaicm07u` (`smltorserno`,`msgiodstcd`,`sndrcvdstcd`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaicm08 definition

CREATE TABLE `tseaicm08` (
  `smltorserno` char(40) NOT NULL,
  `msgiodstcd` char(1) NOT NULL,
  `sndrcvdstcd` char(1) NOT NULL,
  `smlindex` decimal(22,0) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  UNIQUE KEY `xseaicm08u` (`smltorserno`,`msgiodstcd`,`sndrcvdstcd`,`smlindex`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaicm09 definition

CREATE TABLE `tseaicm09` (
  `srcsmltormsgname` varchar(30) NOT NULL,
  `trgsmltormsgname` varchar(30) NOT NULL,
  `errsmltormsgname` varchar(30) DEFAULT NULL,
  `responsetype` char(1) NOT NULL,
  `msgfldstartsituval1` decimal(22,0) DEFAULT NULL,
  `msgfldlen1` decimal(22,0) DEFAULT NULL,
  `msgfldstartsituval2` decimal(22,0) DEFAULT NULL,
  `msgfldlen2` decimal(22,0) DEFAULT NULL,
  `sleeptime` decimal(22,0) DEFAULT NULL,
  UNIQUE KEY `xseaicm09u` (`srcsmltormsgname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaicm10 definition

CREATE TABLE `tseaicm10` (
  `smltormsgname` varchar(30) NOT NULL,
  `loutname` varchar(50) NOT NULL,
  `loutitemname` varchar(50) NOT NULL,
  `msgiodstcd` char(1) NOT NULL,
  `menudstcd` char(3) NOT NULL,
  `loutitemtype` char(3) NOT NULL,
  `typeserno` char(3) NOT NULL,
  `typevalue` varchar(4000) DEFAULT NULL,
  `loutitemserno` decimal(22,0) DEFAULT NULL,
  `gridserno` decimal(22,0) DEFAULT NULL,
  `loutitemptrnserno` decimal(22,0) DEFAULT NULL,
  `smltormsgserno` decimal(22,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaicm11 definition

CREATE TABLE `tseaicm11` (
  `chnlcode` char(4) NOT NULL,
  `seq` decimal(22,0) NOT NULL,
  `lastupdate` char(8) NOT NULL,
  UNIQUE KEY `xseaicm11u` (`chnlcode`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaicm12 definition

CREATE TABLE `tseaicm12` (
  `smltormsgname` varchar(30) NOT NULL,
  `loutname` varchar(50) NOT NULL,
  `loutitemname` varchar(50) NOT NULL,
  `loutitemserno` char(3) NOT NULL,
  `msgiodstcd` char(1) NOT NULL,
  `menudstcd` char(3) NOT NULL,
  `testitemmandanyn` char(1) NOT NULL,
  `testitemserno` decimal(22,0) NOT NULL,
  `testitemctnt` varchar(4000) DEFAULT NULL,
  `smltormsgserno` decimal(22,0) DEFAULT NULL,
  UNIQUE KEY `xseaicm12u` (`smltormsgname`,`smltormsgserno`,`loutname`,`loutitemname`,`loutitemserno`,`testitemserno`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaicm13 definition

CREATE TABLE `tseaicm13` (
  `otsdchnlinstcd` varchar(3) NOT NULL,
  `msgfldserno` decimal(22,0) NOT NULL,
  `msgfldoffset` decimal(22,0) NOT NULL,
  `msgfldlen` decimal(22,0) NOT NULL,
  `msgfldvalue` varchar(200) NOT NULL,
  `msgfldtype` char(3) NOT NULL,
  `msgfldrnk` decimal(22,0) DEFAULT NULL,
  UNIQUE KEY `xseaicm13u` (`otsdchnlinstcd`,`msgfldserno`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaicm15 definition

CREATE TABLE `tseaicm15` (
  `otsdchnlinstcd` varchar(3) NOT NULL,
  `adptrbzwkgroupname` varchar(50) NOT NULL,
  `bulkfilepath` varchar(2000) DEFAULT NULL,
  `maxlength` decimal(22,0) DEFAULT NULL,
  UNIQUE KEY `xseaicm15u` (`otsdchnlinstcd`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaicm16 definition

CREATE TABLE `tseaicm16` (
  `eaisvcname` varchar(40) NOT NULL,
  `columnname` varchar(40) NOT NULL,
  `columnvalue` varchar(200) DEFAULT NULL,
  UNIQUE KEY `xseaicm16u` (`eaisvcname`,`columnname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaicm19 definition

CREATE TABLE `tseaicm19` (
  `codegroup` varchar(50) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  UNIQUE KEY `xseaicm19u` (`codegroup`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaicm20 definition

CREATE TABLE `tseaicm20` (
  `codegroup` varchar(50) NOT NULL,
  `code` varchar(20) NOT NULL,
  `codename` varchar(50) DEFAULT NULL,
  `seq` decimal(22,0) DEFAULT NULL,
  `parentcodegroup` varchar(5) DEFAULT NULL,
  `parentcode` varchar(10) DEFAULT NULL,
  `ext1` varchar(50) DEFAULT NULL,
  `ext2` varchar(50) DEFAULT NULL,
  `ext3` varchar(50) DEFAULT NULL,
  `ext4` varchar(50) DEFAULT NULL,
  `ext5` varchar(50) DEFAULT NULL,
  `useyn` varchar(1) DEFAULT NULL,
  `createby` varchar(8) DEFAULT NULL,
  `updateby` varchar(8) DEFAULT NULL,
  `createon` varchar(14) DEFAULT NULL,
  `updateon` varchar(14) DEFAULT NULL,
  UNIQUE KEY `xseaicm20u` (`codegroup`,`code`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaicm23 definition

CREATE TABLE `tseaicm23` (
  `domainnm` varchar(20) DEFAULT NULL,
  `domaintype` varchar(10) DEFAULT NULL,
  `domainoption` varchar(10) DEFAULT NULL,
  `domainval` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseaicm23u` (`domainnm`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaiea02 definition

CREATE TABLE `tseaiea02` (
  `adptrcd` char(9) NOT NULL,
  `workgrpcd` char(3) DEFAULT NULL,
  `adptrbzwkname` varchar(100) DEFAULT NULL,
  `adptrdesc` varchar(100) DEFAULT NULL,
  `sndrcvkind` char(1) DEFAULT NULL,
  `adptrkind` char(1) DEFAULT NULL,
  `jndidatasource` varchar(50) DEFAULT NULL,
  `lstnerclsname` varchar(100) DEFAULT NULL,
  `prptygroupid` varchar(40) DEFAULT NULL,
  `delyn` char(1) DEFAULT NULL,
  `enc1` varchar(20) DEFAULT NULL,
  UNIQUE KEY `sys_c0011950` (`adptrcd`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaiea03 definition

CREATE TABLE `tseaiea03` (
  `adptrcd` char(9) NOT NULL,
  `adptrcdseq` decimal(22,0) NOT NULL,
  `sqlname` varchar(200) DEFAULT NULL,
  `intfid` varchar(20) DEFAULT NULL,
  `sqlnamedesc` varchar(600) DEFAULT NULL,
  `dbsql` longtext,
  `dbeventwhere` varchar(100) DEFAULT NULL,
  `txcommitunitcnt` decimal(22,0) DEFAULT NULL,
  `selectunitcnt` decimal(22,0) DEFAULT NULL,
  `delyn` char(1) DEFAULT NULL,
  `layoutkey` varchar(40) DEFAULT NULL,
  `divfieldorder` decimal(22,0) DEFAULT NULL,
  `codeckey` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`adptrcdseq`,`adptrcd`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaiea04 definition

CREATE TABLE `tseaiea04` (
  `intfid` varchar(20) NOT NULL,
  `intfname` varchar(200) DEFAULT NULL,
  `intfdesc` varchar(600) DEFAULT NULL,
  `workgrpcd` char(3) DEFAULT NULL,
  `sndadptrcd` char(9) DEFAULT NULL,
  `sndadptrcdseq` decimal(22,0) DEFAULT NULL,
  `batchtype` char(2) DEFAULT NULL,
  `regdate` varchar(17) DEFAULT NULL,
  `reguserid` varchar(20) DEFAULT NULL,
  `moddate` varchar(17) DEFAULT NULL,
  `moduserid` varchar(20) DEFAULT NULL,
  `intfstartdate` varchar(17) DEFAULT NULL,
  `intfenddate` varchar(17) DEFAULT NULL,
  `delyn` char(1) DEFAULT NULL,
  `eventcallval` varchar(2) DEFAULT NULL,
  `restartyn` char(1) DEFAULT NULL,
  `level4` varchar(10) DEFAULT NULL,
  `postjobhostname` varchar(50) DEFAULT NULL,
  `postjobportnoname` varchar(10) DEFAULT NULL,
  `postjobuid` varchar(40) DEFAULT NULL,
  `postjobuserpwdname` varchar(40) DEFAULT NULL,
  `postjobcmd` varchar(300) DEFAULT NULL,
  `sizeonce` varchar(40) DEFAULT NULL,
  `procterm` varchar(40) DEFAULT NULL,
  `reschgr` varchar(40) DEFAULT NULL,
  `reschgrtlno` varchar(40) DEFAULT NULL,
  `reqchgr` varchar(40) DEFAULT NULL,
  `reqchgrtlno` varchar(40) DEFAULT NULL,
  UNIQUE KEY `sys_c0050708` (`intfid`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaiea05 definition

CREATE TABLE `tseaiea05` (
  `adptrcd` char(9) NOT NULL,
  `adptrcdseq` decimal(22,0) NOT NULL,
  `intfid` varchar(20) DEFAULT NULL,
  `ftpname` varchar(200) DEFAULT NULL,
  `ftpnamedesc` varchar(600) DEFAULT NULL,
  `ftphostname` varchar(50) NOT NULL,
  `rmtsevrftpportnoname` varchar(10) NOT NULL,
  `rmtsevrftpuid` varchar(40) NOT NULL,
  `rmtsevrftpuserpwdname` varchar(40) DEFAULT NULL,
  `ftparchivedir` varchar(300) DEFAULT NULL,
  `ftpstorefilepattern` varchar(300) DEFAULT NULL,
  `nextoption` char(1) DEFAULT NULL,
  `checkname` varchar(40) DEFAULT NULL,
  `ftpcheckdir` varchar(300) DEFAULT NULL,
  `systemname` varchar(200) DEFAULT NULL,
  `systemowner` varchar(200) DEFAULT NULL,
  `systemownertelephone` varchar(100) DEFAULT NULL,
  `systemothertxt` varchar(200) DEFAULT NULL,
  `sectionval` varchar(10) DEFAULT NULL,
  `ftpbackupdir` varchar(300) DEFAULT NULL,
  `sftpyn` char(1) DEFAULT NULL,
  `layoutkey` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`adptrcdseq`,`adptrcd`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaiea06 definition

CREATE TABLE `tseaiea06` (
  `intfid` varchar(20) NOT NULL,
  `filenameptrn` varchar(200) NOT NULL,
  `transfreq` char(1) DEFAULT NULL,
  `sizeonce` varchar(40) DEFAULT NULL,
  `procterm` varchar(40) DEFAULT NULL,
  `reqchgr` varchar(40) DEFAULT NULL,
  `reqchgrtlno` varchar(40) DEFAULT NULL,
  `reschgr` varchar(40) DEFAULT NULL,
  `reschgrtlno` varchar(40) DEFAULT NULL,
  `regdate` varchar(17) DEFAULT NULL,
  `reguserid` varchar(20) DEFAULT NULL,
  `moddate` varchar(17) DEFAULT NULL,
  `moduserid` varchar(20) DEFAULT NULL,
  `delyn` char(1) DEFAULT NULL,
  PRIMARY KEY (`filenameptrn`,`intfid`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaiea09 definition

CREATE TABLE `tseaiea09` (
  `prptygroupid` varchar(40) NOT NULL,
  `prptygroupname` varchar(100) DEFAULT NULL,
  UNIQUE KEY `sys_c0011960` (`prptygroupid`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaiea10 definition

CREATE TABLE `tseaiea10` (
  `prptygroupid` varchar(40) NOT NULL,
  `prptyid` varchar(100) NOT NULL,
  `prptydetail` varchar(500) DEFAULT NULL,
  UNIQUE KEY `sys_c0011964` (`prptygroupid`,`prptyid`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaiea11 definition

CREATE TABLE `tseaiea11` (
  `msgid` varchar(12) NOT NULL,
  `msgctnt` varchar(200) DEFAULT NULL,
  UNIQUE KEY `sys_c0011967` (`msgid`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaiej01 definition

CREATE TABLE `tseaiej01` (
  `workgrpcd` varchar(20) NOT NULL,
  `workgrpname` varchar(200) DEFAULT NULL,
  `scheduldelyn` char(1) DEFAULT NULL,
  UNIQUE KEY `sys_c0011970` (`workgrpcd`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaiep03 definition

CREATE TABLE `tseaiep03` (
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisevrip` varchar(50) NOT NULL,
  `sevrlsnportname` varchar(10) NOT NULL,
  `flovrsevrname` varchar(20) NOT NULL,
  `hostname` varchar(50) NOT NULL,
  UNIQUE KEY `xseaiep03u` (`eaisevrinstncname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaiep04 definition

CREATE TABLE `tseaiep04` (
  `lifecyclclsname` varchar(100) NOT NULL,
  `lodinseq` decimal(22,0) DEFAULT NULL,
  `lifecyclusedstcd` char(1) DEFAULT NULL,
  UNIQUE KEY `sys_c0011973` (`lifecyclclsname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaies01 definition

CREATE TABLE `tseaies01` (
  `bjobdmndmsgid` varchar(40) NOT NULL,
  `msgregdate` varchar(17) NOT NULL,
  `intfid` varchar(20) NOT NULL,
  `workgrpcd` char(3) DEFAULT NULL,
  `sndadptrcd` char(9) DEFAULT NULL,
  `sndadptrcdseq` decimal(22,0) DEFAULT NULL,
  `sndsqltext` varchar(1000) DEFAULT NULL,
  `batchtype` char(2) NOT NULL,
  `dbeventwhere` varchar(100) DEFAULT NULL,
  `txcommitunitcnt` decimal(22,0) DEFAULT NULL,
  `selectunitcnt` decimal(22,0) DEFAULT NULL,
  `sndstartdate` varchar(17) DEFAULT NULL,
  `sndenddate` varchar(17) DEFAULT NULL,
  `rcvstartdate` varchar(17) DEFAULT NULL,
  `rcvenddate` varchar(17) DEFAULT NULL,
  `intfidenddate` varchar(17) DEFAULT NULL,
  `erryn` char(1) DEFAULT NULL,
  `sndlinecnt` decimal(22,0) DEFAULT NULL,
  `rcvlinecnt` decimal(22,0) DEFAULT NULL,
  `eaiobstdoccurcausctnt` varchar(1000) DEFAULT NULL,
  `eaiobstdprcssctnt` varchar(1000) DEFAULT NULL,
  `obstdprcsrid` varchar(40) DEFAULT NULL,
  `obstdprcsshms` varchar(17) DEFAULT NULL,
  `checkbasedate` varchar(8) DEFAULT NULL,
  `checkrowcnt` decimal(22,0) DEFAULT NULL,
  `checkparam` varchar(300) DEFAULT NULL,
  `eaisndtablename` varchar(30) DEFAULT NULL,
  `filenamedupway` char(1) DEFAULT NULL,
  `schekind` char(1) DEFAULT NULL,
  `bjobmsgscheid` varchar(20) DEFAULT NULL,
  UNIQUE KEY `sys_c0011979` (`bjobdmndmsgid`),
  KEY `ix_tseaies01_01` (`intfid`,`schekind`),
  KEY `ix_tseaies01_02` (`msgregdate`,`intfid`),
  KEY `ix_tseaies01_03` (`bjobdmndmsgid`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaies03 definition

CREATE TABLE `tseaies03` (
  `bjobdmndmsgid` varchar(40) NOT NULL,
  `sndrcvkind` char(1) NOT NULL,
  `filelogseq` decimal(22,0) NOT NULL,
  `intfid` varchar(20) DEFAULT NULL,
  `adptrcd` char(9) DEFAULT NULL,
  `adptrcdseq` decimal(22,0) DEFAULT NULL,
  `filetrsmtstarthms` varchar(17) DEFAULT NULL,
  `filetrsmtendhms` varchar(17) DEFAULT NULL,
  `rmttrsmtfullname` varchar(400) DEFAULT NULL,
  `eaitrsmtfullname` varchar(400) DEFAULT NULL,
  `eaifiletrsmtpathname` varchar(300) DEFAULT NULL,
  `eaitrsmtfilename` varchar(100) DEFAULT NULL,
  `rmtfiletrsmtpathname` varchar(300) DEFAULT NULL,
  `rmttrsmtfilename` varchar(100) DEFAULT NULL,
  `filetrsmtamndhms` varchar(17) DEFAULT NULL,
  `filetrsmtsizectnt` varchar(20) DEFAULT NULL,
  `transstatuscd` char(1) DEFAULT NULL,
  `errmsgcd` varchar(4000) DEFAULT NULL,
  PRIMARY KEY (`filelogseq`,`bjobdmndmsgid`,`sndrcvkind`),
  KEY `tseaies03_ix01` (`bjobdmndmsgid`,`sndrcvkind`,`transstatuscd`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaies04 definition

CREATE TABLE `tseaies04` (
  `bjobdmndmsgid` varchar(40) NOT NULL,
  `sndrcvkind` char(1) NOT NULL,
  `dblogseq` decimal(22,0) NOT NULL,
  `intfid` varchar(20) DEFAULT NULL,
  `adptrcd` char(9) DEFAULT NULL,
  `adptrcdseq` decimal(22,0) DEFAULT NULL,
  `orgcnt` decimal(22,0) DEFAULT NULL,
  `insertcnt` decimal(22,0) DEFAULT NULL,
  `dbtrsmtstarthms` varchar(17) DEFAULT NULL,
  `dbtrsmtendhms` varchar(17) DEFAULT NULL,
  `transstatuscd` char(1) DEFAULT NULL,
  `errmsgcd` varchar(4000) DEFAULT NULL,
  UNIQUE KEY `sys_c0012007` (`bjobdmndmsgid`,`sndrcvkind`,`dblogseq`),
  KEY `tseaies04_ix01` (`bjobdmndmsgid`,`sndrcvkind`,`transstatuscd`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaies05 definition

CREATE TABLE `tseaies05` (
  `bjobdmndmsgid` varchar(40) NOT NULL,
  `adptrcd` char(9) NOT NULL,
  `adptrcdseq` decimal(22,0) NOT NULL,
  `sndrcvkind` char(1) NOT NULL,
  `errlogseq` decimal(22,0) NOT NULL,
  `intfid` varchar(20) DEFAULT NULL,
  `systemkind` char(1) DEFAULT NULL,
  `targetdata` varchar(4000) DEFAULT NULL,
  `errmsg` varchar(4000) DEFAULT NULL,
  `errregdate` varchar(17) DEFAULT NULL,
  UNIQUE KEY `sys_c0012014` (`bjobdmndmsgid`,`adptrcd`,`adptrcdseq`,`sndrcvkind`,`errlogseq`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaies06 definition

CREATE TABLE `tseaies06` (
  `adptrcd` char(9) NOT NULL,
  `adptrcdseq` decimal(22,0) NOT NULL,
  `layoutseq` decimal(22,0) NOT NULL,
  `intfid` varchar(20) DEFAULT NULL,
  `orderseq` decimal(22,0) DEFAULT NULL,
  `colsize` varchar(10) DEFAULT NULL,
  `coldepth` decimal(22,0) DEFAULT NULL,
  `coldesc` varchar(200) DEFAULT NULL,
  `coltype` char(1) DEFAULT NULL,
  `coldesceng` varchar(50) DEFAULT NULL,
  `colkind` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`adptrcdseq`,`adptrcd`,`layoutseq`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaies07 definition

CREATE TABLE `tseaies07` (
  `bjobmsgscheid` varchar(20) NOT NULL,
  `intfid` varchar(20) DEFAULT NULL,
  `batchtype` char(2) DEFAULT NULL,
  `schekind` char(1) DEFAULT NULL,
  `sndrcvstarthms` varchar(4) DEFAULT NULL,
  `sndrcvendhms` varchar(4) DEFAULT NULL,
  `msgsndrid` varchar(40) DEFAULT NULL,
  `schefrstregihms` varchar(17) DEFAULT NULL,
  `rqstrecvfilestorgdirname` varchar(100) DEFAULT NULL,
  `thismsguseyn` char(1) DEFAULT NULL,
  `thismsgschedesc` varchar(200) DEFAULT NULL,
  `thismsgregsntid` varchar(40) DEFAULT NULL,
  `thismsgregihms` varchar(17) DEFAULT NULL,
  `thismsgamndrid` varchar(40) DEFAULT NULL,
  `thismsgamndhms` varchar(17) DEFAULT NULL,
  `cyclekind` varchar(5) DEFAULT NULL,
  `cyclecode` varchar(5) DEFAULT NULL,
  `monweekcode1` varchar(5) DEFAULT NULL,
  `monweekcode2` varchar(5) DEFAULT NULL,
  `daycycletime` varchar(4) DEFAULT NULL,
  `acttime1` varchar(4) DEFAULT NULL,
  `acttime2` varchar(4) DEFAULT NULL,
  `acttime3` varchar(4) DEFAULT NULL,
  `acttime4` varchar(4) DEFAULT NULL,
  `acttime5` varchar(4) DEFAULT NULL,
  `acttime6` varchar(4) DEFAULT NULL,
  `actday` varchar(8) DEFAULT NULL,
  `actday2` varchar(8) DEFAULT NULL,
  `actday3` varchar(8) DEFAULT NULL,
  `actday4` varchar(8) DEFAULT NULL,
  UNIQUE KEY `sys_c0012022` (`bjobmsgscheid`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaies08 definition

CREATE TABLE `tseaies08` (
  `logprcssseqno` char(40) DEFAULT NULL,
  `seqno` decimal(22,0) DEFAULT NULL,
  `servicename` varchar(50) DEFAULT NULL,
  `command` varchar(25) DEFAULT NULL,
  `loutname` varchar(50) DEFAULT NULL,
  `recvdata` varchar(4000) DEFAULT NULL,
  `recvamndhms` char(16) DEFAULT NULL,
  `prcssrslt` char(1) DEFAULT NULL,
  `prcssrsltcmnt` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaies09 definition

CREATE TABLE `tseaies09` (
  `bjobmsgscheid` varchar(20) NOT NULL,
  `intfid` varchar(20) NOT NULL,
  `regid` varchar(20) DEFAULT NULL,
  `regdate` varchar(17) DEFAULT NULL,
  `modid` varchar(20) DEFAULT NULL,
  `moddate` varchar(17) DEFAULT NULL,
  `delyn` char(1) DEFAULT NULL,
  UNIQUE KEY `sys_c0012025` (`bjobmsgscheid`,`intfid`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaies10 definition

CREATE TABLE `tseaies10` (
  `schedid` varchar(40) NOT NULL,
  `cronexp` varchar(50) DEFAULT NULL,
  `jobclassname` varchar(50) DEFAULT NULL,
  `scheddstcd` char(1) DEFAULT NULL,
  `scandirname` varchar(100) DEFAULT NULL,
  `timermsg` varchar(100) DEFAULT NULL,
  UNIQUE KEY `sys_c0012028` (`schedid`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaies20 definition

CREATE TABLE `tseaies20` (
  `transkind` varchar(2) NOT NULL,
  `translogseq` decimal(22,0) NOT NULL,
  `menuid` varchar(20) DEFAULT NULL,
  `loginid` varchar(20) DEFAULT NULL,
  `modifydatetime` varchar(16) DEFAULT NULL,
  `connectip` varchar(30) DEFAULT NULL,
  `actmode` varchar(2) DEFAULT NULL,
  `transkey1` varchar(40) DEFAULT NULL,
  `transkey2` varchar(40) DEFAULT NULL,
  `transkey3` varchar(40) DEFAULT NULL,
  `transkey4` varchar(40) DEFAULT NULL,
  `transdesc` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`translogseq`,`transkind`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaies22 definition

CREATE TABLE `tseaies22` (
  `translogseq` decimal(22,0) NOT NULL,
  `targethost` varchar(20) DEFAULT NULL,
  `targetid` varchar(20) DEFAULT NULL,
  `loginid` varchar(20) DEFAULT NULL,
  `transdate` varchar(16) DEFAULT NULL,
  `connectip` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`translogseq`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaies24 definition

CREATE TABLE `tseaies24` (
  `intfid` varchar(20) NOT NULL,
  `loginid` varchar(8) DEFAULT NULL,
  `workgrpcd` char(3) DEFAULT NULL,
  `userkind` varchar(16) DEFAULT NULL,
  `smsyn` char(1) DEFAULT NULL,
  `msgyn` char(1) DEFAULT NULL,
  `sndlevel` varchar(2) DEFAULT NULL,
  `erragreecnt` varchar(2) DEFAULT NULL,
  `addinfo1` varchar(20) DEFAULT NULL,
  `addinfo2` varchar(20) DEFAULT NULL,
  `addinfo3` varchar(20) DEFAULT NULL,
  `addinfo4` varchar(20) DEFAULT NULL,
  `addinfo5` varchar(20) DEFAULT NULL,
  `addinfo6` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`intfid`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaifr01 definition

CREATE TABLE `tseaifr01` (
  `eaisvcname` varchar(30) NOT NULL,
  `svcprcssno` decimal(22,0) NOT NULL,
  `ruleserno` decimal(22,0) NOT NULL,
  `rsultprcssno` decimal(22,0) NOT NULL,
  `rulefldgroupname` varchar(50) DEFAULT NULL,
  `rulefldname` varchar(50) NOT NULL,
  `cmprctnt` varchar(20) NOT NULL,
  UNIQUE KEY `xseaifr01u` (`eaisvcname`,`rsultprcssno`,`ruleserno`,`svcprcssno`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaifr02 definition

CREATE TABLE `tseaifr02` (
  `routname` varchar(50) NOT NULL,
  `motivrouturiname` varchar(200) NOT NULL DEFAULT '',
  `nonmotivrouturiname` varchar(200) DEFAULT '',
  `layerdstcd` char(1) NOT NULL,
  UNIQUE KEY `xseaifr02u` (`routname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaifr03 definition

CREATE TABLE `tseaifr03` (
  `eaisvcname` varchar(30) NOT NULL,
  `etractdstcd` char(2) NOT NULL,
  `fldprcssno` decimal(22,0) NOT NULL,
  `msgdstcd` char(3) NOT NULL,
  `bzwkfldname` varchar(200) NOT NULL,
  `msgfldstartsituval` decimal(22,0) DEFAULT NULL,
  `msgfldlen` decimal(22,0) DEFAULT NULL,
  UNIQUE KEY `xseaifr03u` (`eaisvcname`,`etractdstcd`,`fldprcssno`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaifr04 definition

CREATE TABLE `tseaifr04` (
  `adptrbzwkgroupname` varchar(50) NOT NULL,
  `msgdstcd` char(3) NOT NULL,
  `iodstcd` char(1) NOT NULL,
  `fldprcssno` decimal(22,0) NOT NULL,
  `bzwkfldname` varchar(200) DEFAULT NULL,
  `clsname` varchar(100) DEFAULT NULL,
  `msgfldstartsituval` decimal(22,0) NOT NULL DEFAULT '0',
  `msgfldlen` decimal(22,0) NOT NULL DEFAULT '0',
  `nomalprcssctnt` varchar(50) DEFAULT NULL,
  `groupinorno` decimal(22,0) NOT NULL,
  UNIQUE KEY `xseaifr04u` (`adptrbzwkgroupname`,`msgdstcd`,`iodstcd`,`fldprcssno`,`groupinorno`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaifr05 definition

CREATE TABLE `tseaifr05` (
  `lifecyclclsname` varchar(200) NOT NULL,
  `lodinseq` decimal(22,0) NOT NULL,
  `lifecyclusedstcd` char(1) NOT NULL,
  UNIQUE KEY `xseaifr05u` (`lifecyclclsname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaifr06 definition

CREATE TABLE `tseaifr06` (
  `eaisvcname` varchar(30) NOT NULL,
  `svcprcssno` decimal(22,0) NOT NULL,
  `svcroutclsname` varchar(100) NOT NULL,
  `adptrroutclsname` varchar(100) NOT NULL,
  UNIQUE KEY `xseaifr06u` (`eaisvcname`,`svcprcssno`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaifr07 definition

CREATE TABLE `tseaifr07` (
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `extnlinstiidnfiname` varchar(8) NOT NULL,
  `dmnddtalsbzwkdsticname` varchar(30) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `adptrbzwkname` varchar(50) NOT NULL,
  UNIQUE KEY `xseaifr07u` (`eaisevrinstncname`,`eaisvcname`,`extnlinstiidnfiname`,`dmnddtalsbzwkdsticname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaihe01 definition

CREATE TABLE `tseaihe01` (
  `eaisvcname` varchar(30) NOT NULL,
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcesdsticname` varchar(10) NOT NULL DEFAULT '',
  `flowctrlroutname` varchar(50) NOT NULL DEFAULT '',
  `intgradsticname` varchar(6) NOT NULL DEFAULT '',
  `svcbfclmnlogyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL DEFAULT '',
  `sevrloglvelno` decimal(22,0) NOT NULL,
  `svcloglvelno` decimal(22,0) NOT NULL,
  `erreaisvcname` varchar(30) DEFAULT NULL,
  `dmnderrchngidname` varchar(50) DEFAULT NULL,
  `dmnderrfldname` varchar(50) DEFAULT NULL,
  `rspnserrchngidname` varchar(50) DEFAULT NULL,
  `rspnserrfldname` varchar(50) DEFAULT NULL,
  `eaisvcdesc` varchar(200) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `createby` varchar(8) DEFAULT NULL,
  `updateby` varchar(8) DEFAULT NULL,
  `devuserid` varchar(8) DEFAULT NULL,
  `bankuserid` varchar(8) DEFAULT NULL,
  `createon` varchar(14) DEFAULT NULL,
  `updateon` varchar(14) DEFAULT NULL,
  `reqchgr` varchar(40) DEFAULT NULL,
  `reqchgrtlno` varchar(40) DEFAULT NULL,
  `reschgr` varchar(40) DEFAULT NULL,
  `reschgrtlno` varchar(40) DEFAULT NULL,
  UNIQUE KEY `xseaihe01u` (`eaisvcname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaihe02 definition

CREATE TABLE `tseaihe02` (
  `eaisvcname` varchar(30) NOT NULL,
  `svcprcssno` decimal(22,0) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvsysbzwkdstcd` varchar(4) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) DEFAULT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngeonot` char(1) NOT NULL,
  `chngmsgidname` varchar(50) DEFAULT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) DEFAULT NULL,
  `bascrspnschngeonot` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) DEFAULT NULL,
  `errrspnsmsgcmprctnt` varchar(20) DEFAULT NULL,
  `errrspnschngeonot` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) DEFAULT NULL,
  `nextsvcprcssno` decimal(22,0) DEFAULT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssdsticname` varchar(20) DEFAULT NULL,
  `suppldelyn` char(1) NOT NULL,
  `hdrctrldstcd` char(2) NOT NULL,
  `hdrrefclsname` varchar(100) DEFAULT NULL,
  `RESTOPTION` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseaihe02u` (`eaisvcname`,`svcprcssno`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaihe03 definition

CREATE TABLE `tseaihe03` (
  `extnlinstiidnfiname` varchar(8) NOT NULL,
  `svcprcssno` decimal(22,0) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvsysbzwkdstcd` varchar(4) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) DEFAULT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngeonot` char(1) NOT NULL,
  `chngmsgidname` varchar(50) DEFAULT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) DEFAULT NULL,
  `bascrspnschngeonot` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) DEFAULT NULL,
  `errrspnsmsgcmprctnt` varchar(20) DEFAULT NULL,
  `errrspnschngeonot` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) DEFAULT NULL,
  `nextsvcprcssno` decimal(22,0) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssdsticname` varchar(20) DEFAULT NULL,
  `suppldelyn` char(1) NOT NULL DEFAULT '0',
  `hdrctrldstcd` char(2) DEFAULT NULL,
  `hdrrefclsname` varchar(100) DEFAULT NULL,
  UNIQUE KEY `xseaihe03u` (`extnlinstiidnfiname`,`svcprcssno`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaihe04 definition

CREATE TABLE `tseaihe04` (
  `extnlinstiidnfiname` varchar(8) NOT NULL,
  `svcprcssno` decimal(22,0) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvsysbzwkdstcd` varchar(4) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) DEFAULT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngeonot` char(1) NOT NULL,
  `chngmsgidname` varchar(50) DEFAULT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) DEFAULT NULL,
  `bascrspnschngeonot` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) DEFAULT NULL,
  `errrspnsmsgcmprctnt` varchar(20) DEFAULT NULL,
  `errrspnschngeonot` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) DEFAULT NULL,
  `nextsvcprcssno` decimal(22,0) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssdsticname` varchar(20) DEFAULT NULL,
  `suppldelyn` char(1) NOT NULL,
  `hdrctrldstcd` char(2) DEFAULT NULL,
  `hdrrefclsname` varchar(100) DEFAULT NULL,
  UNIQUE KEY `xseaihe04u` (`extnlinstiidnfiname`,`svcprcssno`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaihe10 definition

CREATE TABLE `tseaihe10` (
  `eaisvcname` varchar(30) NOT NULL,
  `occurdstcd` varchar(40) DEFAULT NULL,
  `transkind` varchar(40) DEFAULT NULL,
  `transfreq` varchar(40) DEFAULT NULL,
  `sizeonce` varchar(40) DEFAULT NULL,
  `procterm` varchar(40) DEFAULT NULL,
  `reqchgr` varchar(40) DEFAULT NULL,
  `reqchgrtlno` varchar(40) DEFAULT NULL,
  `reschgr` varchar(40) DEFAULT NULL,
  `reschgrtlno` varchar(40) DEFAULT NULL,
  `rmk` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseaihe10u` (`eaisvcname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaihs01 definition

CREATE TABLE `tseaihs01` (
  `bzwksvckeyname` varchar(40) NOT NULL,
  `splizdmnddstcd` char(1) NOT NULL,
  `groupcono` char(3) NOT NULL,
  `recvtranname` varchar(11) NOT NULL DEFAULT '',
  `prcssrsultrecvtranno` char(11) NOT NULL,
  `screndsticidnfr` char(13) NOT NULL,
  `osidinstino` char(4) NOT NULL,
  `ogtranrstryn` char(1) NOT NULL,
  `sysoperevirndstcd` char(1) NOT NULL,
  `eaitranname` varchar(20) NOT NULL DEFAULT '',
  `stndtelgmwtinextnldstcd` char(1) NOT NULL,
  `tranbrncd` char(4) NOT NULL,
  `userempid` char(6) NOT NULL,
  `chnldvdstcd` char(3) DEFAULT NULL,
  `chnldstcd` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaihs02 definition

CREATE TABLE `tseaihs02` (
  `nwuapplcd` char(3) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `kbmsghdrctnt` varchar(1600) NOT NULL,
  `eaimsgstorgymd` char(8) NOT NULL,
  UNIQUE KEY `xseaihs02u` (`nwuapplcd`,`keymgtmsgctnt`,`eaimsgstorgymd`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaihs03 definition

CREATE TABLE `tseaihs03` (
  `columnname` varchar(40) NOT NULL,
  `columndesc` varchar(200) DEFAULT NULL,
  `columnlength` decimal(22,0) DEFAULT NULL,
  `iskey` varchar(1) DEFAULT NULL,
  `keyseq` decimal(22,0) DEFAULT NULL,
  `isinterface` varchar(1) DEFAULT NULL,
  `comboname` varchar(40) DEFAULT NULL,
  `combodepth` decimal(22,0) DEFAULT NULL,
  `columndefault` varchar(200) DEFAULT NULL,
  UNIQUE KEY `xseaihs03u` (`columnname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaihs04 definition

CREATE TABLE `tseaihs04` (
  `bzwksvckeyname` varchar(40) NOT NULL,
  `eaisvcname` varchar(40) DEFAULT NULL,
  UNIQUE KEY `xseaihs04u` (`bzwksvckeyname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaihs05 definition

CREATE TABLE `tseaihs05` (
  `bzwksvckeyname` varchar(40) NOT NULL,
  `columnname` varchar(40) NOT NULL,
  `columnvalue` varchar(200) DEFAULT NULL,
  UNIQUE KEY `xseaihs05u` (`bzwksvckeyname`,`columnname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaiif06 definition

CREATE TABLE `tseaiif06` (
  `eaibzwkdstcd` varchar(4) DEFAULT NULL,
  `instancecode` char(3) DEFAULT NULL,
  UNIQUE KEY `xseaiif06u` (`eaibzwkdstcd`,`instancecode`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaiim01 definition

CREATE TABLE `tseaiim01` (
  `eaisvcname` varchar(30) NOT NULL,
  `itsmtagetyn` char(1) NOT NULL,
  `crtcval` decimal(22,0) NOT NULL,
  `lastmodfiyms` char(14) NOT NULL,
  `trancdname` varchar(100) NOT NULL,
  UNIQUE KEY `xseaiim01u` (`eaisvcname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild01 definition

CREATE TABLE `tseaild01` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild02 definition

CREATE TABLE `tseaild02` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild03 definition

CREATE TABLE `tseaild03` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild04 definition

CREATE TABLE `tseaild04` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild05 definition

CREATE TABLE `tseaild05` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild06 definition

CREATE TABLE `tseaild06` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild07 definition

CREATE TABLE `tseaild07` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild08 definition

CREATE TABLE `tseaild08` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild09 definition

CREATE TABLE `tseaild09` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild10 definition

CREATE TABLE `tseaild10` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild11 definition

CREATE TABLE `tseaild11` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild12 definition

CREATE TABLE `tseaild12` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild13 definition

CREATE TABLE `tseaild13` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild14 definition

CREATE TABLE `tseaild14` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild15 definition

CREATE TABLE `tseaild15` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild16 definition

CREATE TABLE `tseaild16` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild17 definition

CREATE TABLE `tseaild17` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild18 definition

CREATE TABLE `tseaild18` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild19 definition

CREATE TABLE `tseaild19` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild20 definition

CREATE TABLE `tseaild20` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild21 definition

CREATE TABLE `tseaild21` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild22 definition

CREATE TABLE `tseaild22` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild23 definition

CREATE TABLE `tseaild23` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild24 definition

CREATE TABLE `tseaild24` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild25 definition

CREATE TABLE `tseaild25` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild26 definition

CREATE TABLE `tseaild26` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild27 definition

CREATE TABLE `tseaild27` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild28 definition

CREATE TABLE `tseaild28` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild29 definition

CREATE TABLE `tseaild29` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild30 definition

CREATE TABLE `tseaild30` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaild31 definition

CREATE TABLE `tseaild31` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `bzwkdataserno` decimal(22,0) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile01 definition

CREATE TABLE `tseaile01` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile02 definition

CREATE TABLE `tseaile02` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile03 definition

CREATE TABLE `tseaile03` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile04 definition

CREATE TABLE `tseaile04` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile05 definition

CREATE TABLE `tseaile05` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile06 definition

CREATE TABLE `tseaile06` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile07 definition

CREATE TABLE `tseaile07` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile08 definition

CREATE TABLE `tseaile08` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile09 definition

CREATE TABLE `tseaile09` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile10 definition

CREATE TABLE `tseaile10` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile11 definition

CREATE TABLE `tseaile11` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile12 definition

CREATE TABLE `tseaile12` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile13 definition

CREATE TABLE `tseaile13` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile14 definition

CREATE TABLE `tseaile14` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile15 definition

CREATE TABLE `tseaile15` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile16 definition

CREATE TABLE `tseaile16` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile17 definition

CREATE TABLE `tseaile17` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile18 definition

CREATE TABLE `tseaile18` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile19 definition

CREATE TABLE `tseaile19` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile20 definition

CREATE TABLE `tseaile20` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile21 definition

CREATE TABLE `tseaile21` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile22 definition

CREATE TABLE `tseaile22` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile23 definition

CREATE TABLE `tseaile23` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile24 definition

CREATE TABLE `tseaile24` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  UNIQUE KEY `xseaile24u` (`eaibzwkdstcd`,`msgdpstyms`,`eaisvcserno`,`logprcssserno`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile25 definition

CREATE TABLE `tseaile25` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile26 definition

CREATE TABLE `tseaile26` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile27 definition

CREATE TABLE `tseaile27` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile28 definition

CREATE TABLE `tseaile28` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile29 definition

CREATE TABLE `tseaile29` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile30 definition

CREATE TABLE `tseaile30` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaile31 definition

CREATE TABLE `tseaile31` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(4000) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `lgingsysid` varchar(20) NOT NULL,
  `msgprcssyms` char(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm01 definition

CREATE TABLE `tseailm01` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm01u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm01n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm01n2` (`guid`),
  KEY `tseailm01_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm01_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm02 definition

CREATE TABLE `tseailm02` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm02u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm02n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm02n2` (`guid`),
  KEY `tseailm02_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm02_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm03 definition

CREATE TABLE `tseailm03` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm03u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm03n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm03n2` (`guid`),
  KEY `tseailm03_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm03_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm04 definition

CREATE TABLE `tseailm04` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm04u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm04n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm04n2` (`guid`),
  KEY `tseailm04_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm04_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm05 definition

CREATE TABLE `tseailm05` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm05u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm05n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm05n2` (`guid`),
  KEY `tseailm05_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm05_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm06 definition

CREATE TABLE `tseailm06` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm06u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm06n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm06n2` (`guid`),
  KEY `tseailm06_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm06_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm07 definition

CREATE TABLE `tseailm07` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm07u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm07n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm07n2` (`guid`),
  KEY `tseailm07_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm07_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm08 definition

CREATE TABLE `tseailm08` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm08u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm08n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm08n2` (`guid`),
  KEY `tseailm08_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm08_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm09 definition

CREATE TABLE `tseailm09` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm09u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm09n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm09n2` (`guid`),
  KEY `tseailm09_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm09_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm10 definition

CREATE TABLE `tseailm10` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm10u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm10n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm10n2` (`guid`),
  KEY `tseailm10_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm10_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm11 definition

CREATE TABLE `tseailm11` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm11u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm11n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm11n2` (`guid`),
  KEY `tseailm11_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm11_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm12 definition

CREATE TABLE `tseailm12` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm12u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm12n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm12n2` (`guid`),
  KEY `tseailm12_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm12_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm13 definition

CREATE TABLE `tseailm13` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm13u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm13n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm13n2` (`guid`),
  KEY `tseailm13_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm13_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm14 definition

CREATE TABLE `tseailm14` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm14u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm14n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm14n2` (`guid`),
  KEY `tseailm14_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm14_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm15 definition

CREATE TABLE `tseailm15` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm15u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm15n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm15n2` (`guid`),
  KEY `tseailm15_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm15_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm16 definition

CREATE TABLE `tseailm16` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm16u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm16n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm16n2` (`guid`),
  KEY `tseailm16_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm16_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm17 definition

CREATE TABLE `tseailm17` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm17u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm17n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm17n2` (`guid`),
  KEY `tseailm17_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm17_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm18 definition

CREATE TABLE `tseailm18` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm18u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm18n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm18n2` (`guid`),
  KEY `tseailm18_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm18_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm19 definition

CREATE TABLE `tseailm19` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm19u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm19n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm19n2` (`guid`),
  KEY `tseailm19_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm19_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm20 definition

CREATE TABLE `tseailm20` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm20u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm20n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm20n2` (`guid`),
  KEY `tseailm20_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm20_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm21 definition

CREATE TABLE `tseailm21` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm21u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm21n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm21n2` (`guid`),
  KEY `tseailm21_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm21_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm22 definition

CREATE TABLE `tseailm22` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm22u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm22n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm22n2` (`guid`),
  KEY `tseailm22_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm22_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm23 definition

CREATE TABLE `tseailm23` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm23u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm23n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm23n2` (`guid`),
  KEY `tseailm23_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm23_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm24 definition

CREATE TABLE `tseailm24` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm24u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm24n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm24n2` (`guid`),
  KEY `tseailm24_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm24_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm25 definition

CREATE TABLE `tseailm25` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm25u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm25n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm25n2` (`guid`),
  KEY `tseailm25_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm25_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm26 definition

CREATE TABLE `tseailm26` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm26u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm26n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm26n2` (`guid`),
  KEY `tseailm26_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm26_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm27 definition

CREATE TABLE `tseailm27` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm27u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm27n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm27n2` (`guid`),
  KEY `tseailm27_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm27_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm28 definition

CREATE TABLE `tseailm28` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm28u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm28n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm28n2` (`guid`),
  KEY `tseailm28_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm28_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm29 definition

CREATE TABLE `tseailm29` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm29u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm29n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm29n2` (`guid`),
  KEY `tseailm29_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm29_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm30 definition

CREATE TABLE `tseailm30` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm30u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm30n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm30n2` (`guid`),
  KEY `tseailm30_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm30_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseailm31 definition

CREATE TABLE `tseailm31` (
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `msgdpstyms` char(17) NOT NULL,
  `eaisvcserno` char(40) NOT NULL,
  `logprcssserno` char(3) NOT NULL,
  `eaisevrinstncname` varchar(20) NOT NULL,
  `eaisvcname` varchar(30) NOT NULL,
  `svchmseonot` char(1) NOT NULL,
  `svcmotivusedstcd` char(4) NOT NULL,
  `svcprcssdsticname` varchar(10) NOT NULL,
  `flowctrlroutname` varchar(50) NOT NULL,
  `intgradsticname` varchar(6) NOT NULL,
  `gstatsvcdsticname` varchar(15) NOT NULL,
  `svcprcssno` char(2) NOT NULL,
  `svcbfclmnlogyn` char(1) NOT NULL,
  `stndmsguseyn` char(1) NOT NULL,
  `gstatsysadptrbzwkgroupname` varchar(50) NOT NULL,
  `prsntmsgidname` varchar(60) NOT NULL,
  `rspnserrcdname` char(12) NOT NULL,
  `msgprcssyms` char(17) NOT NULL,
  `sevrloglvelno` char(1) NOT NULL,
  `svcloglvelno` char(1) NOT NULL,
  `erreaisvcname` varchar(30) NOT NULL,
  `dmnderrchngidname` varchar(50) NOT NULL,
  `dmnderrfldname` varchar(50) NOT NULL,
  `rspnserrchngidname` varchar(50) NOT NULL,
  `rspnserrfldname` varchar(50) NOT NULL,
  `psvintfacdsticname` varchar(4) NOT NULL,
  `psvbzwksysname` varchar(5) NOT NULL,
  `psvsysidname` varchar(12) NOT NULL,
  `psvsyssvcdsticname` varchar(20) NOT NULL,
  `psvsysadptrbzwkgroupname` varchar(100) NOT NULL,
  `flovryn` char(1) NOT NULL,
  `chngyn` char(1) NOT NULL,
  `chngmsgidname` varchar(50) NOT NULL,
  `inptmsgidname` varchar(200) NOT NULL,
  `bascrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `bascrspnschngyn` char(1) NOT NULL,
  `bascrspnschngmsgidname` varchar(50) NOT NULL,
  `errrspnsmsgcmprctnt` varchar(20) NOT NULL,
  `errrspnschngyn` char(1) NOT NULL,
  `errrspnschngmsgidname` varchar(50) NOT NULL,
  `nextsvcprcssno` char(2) NOT NULL,
  `outbndroutname` varchar(50) NOT NULL,
  `toutval` decimal(22,0) NOT NULL,
  `cmpensvcprcssname` varchar(20) NOT NULL,
  `supplbzwkdatayn` char(1) NOT NULL,
  `keymgtmsgctnt` varchar(105) NOT NULL,
  `trackasiskey1ctnt` varchar(50) NOT NULL,
  `trackasiskey2ctnt` varchar(50) NOT NULL,
  `eaierrcd` char(12) NOT NULL,
  `eaierrctnt` varchar(500) NOT NULL,
  `sevrgroupname` varchar(20) NOT NULL,
  `bzwkdatactnt` varchar(4000) NOT NULL,
  `guid` char(36) NOT NULL,
  `header` varchar(1000) NOT NULL,
  `common` varchar(850) NOT NULL,
  `dataheader` char(10) DEFAULT NULL,
  `simyn` char(1) DEFAULT NULL,
  `correcttransformyn` char(1) DEFAULT NULL,
  `msg` varchar(4000) DEFAULT NULL,
  `ETIHEADER` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `xseailm31u` (`eaisvcserno`,`logprcssserno`),
  KEY `xseailm31n1` (`msgdpstyms`,`eaisvcserno`),
  KEY `xseailm31n2` (`guid`),
  KEY `tseailm31_trackasiskey1ctnt_IDX` (`trackasiskey1ctnt`) USING BTREE,
  KEY `tseailm31_trackasiskey2ctnt_IDX` (`trackasiskey2ctnt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaimn04 definition

CREATE TABLE `tseaimn04` (
  `userid` varchar(20) NOT NULL,
  `eaibzwkdstcd` varchar(4) NOT NULL,
  UNIQUE KEY `xseaimn04u` (`userid`,`eaibzwkdstcd`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaims01 definition

CREATE TABLE `tseaims01` (
  `msg` char(12) NOT NULL,
  `msgctnt` varchar(200) NOT NULL DEFAULT '',
  `treatmatrctnt` varchar(200) DEFAULT '',
  UNIQUE KEY `xseaims01u` (`msg`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaims02 definition

CREATE TABLE `tseaims02` (
  `eaisvcname` varchar(30) NOT NULL,
  `svcprcssno` decimal(22,0) NOT NULL,
  `refmsgidno` decimal(22,0) NOT NULL,
  `refmsgidname` varchar(50) NOT NULL,
  UNIQUE KEY `xseaims02u` (`eaisvcname`,`svcprcssno`,`refmsgidno`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaimx01 definition

CREATE TABLE `tseaimx01` (
  `item_id` varchar(36) NOT NULL,
  `item_knm` varchar(200) NOT NULL,
  `item_enm` varchar(200) NOT NULL,
  `data_type` varchar(20) DEFAULT NULL,
  `data_length` varchar(10) DEFAULT NULL,
  `data_scale` varchar(10) DEFAULT NULL,
  `description` varchar(4000) DEFAULT NULL,
  `chng_dttm` datetime DEFAULT NULL,
  `del_yn` char(1) DEFAULT NULL,
  UNIQUE KEY `xseaimx01u` (`item_id`),
  KEY `xseaimx01n1` (`chng_dttm`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaimx02 definition

CREATE TABLE `tseaimx02` (
  `telegram_id` varchar(36) NOT NULL,
  `telegram_knm` varchar(200) NOT NULL,
  `telegram_enm` varchar(200) NOT NULL,
  `data_type` varchar(200) DEFAULT NULL,
  `data_length` varchar(10) DEFAULT NULL,
  `data_scale` varchar(10) DEFAULT NULL,
  `description` varchar(4000) DEFAULT NULL,
  `chng_dttm` datetime DEFAULT NULL,
  `del_yn` varchar(1) DEFAULT NULL,
  UNIQUE KEY `xseaimx02u` (`telegram_id`),
  KEY `xseaimx02n1` (`chng_dttm`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaimx03 definition

CREATE TABLE `tseaimx03` (
  `obj_id` varchar(36) NOT NULL,
  `std_err_cd_yn` varchar(1) DEFAULT NULL,
  `err_cd` varchar(10) DEFAULT NULL,
  `stsy_err_cd` varchar(10) DEFAULT NULL,
  `err_tlg_lan_dscd` varchar(3) DEFAULT NULL,
  `msg_dit` varchar(1) DEFAULT NULL,
  `err_tp_cd` varchar(1) DEFAULT NULL,
  `err_cd_us_yn` varchar(1) DEFAULT NULL,
  `ipt_msg_cd_yn` varchar(1) DEFAULT NULL,
  `isd_err_cas_cts` varchar(200) DEFAULT NULL,
  `osd_err_cas_cts` varchar(200) DEFAULT NULL,
  `err_cd_apl_dt` varchar(10) DEFAULT NULL,
  `actn_cd` varchar(10) DEFAULT NULL,
  `of_actn_cd` varchar(36) DEFAULT NULL,
  `chng_dttm` datetime DEFAULT NULL,
  `del_yn` varchar(1) DEFAULT NULL,
  UNIQUE KEY `xseaimx03u` (`obj_id`),
  KEY `xseaimx03n1` (`chng_dttm`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaimx04 definition

CREATE TABLE `tseaimx04` (
  `code_id` varchar(36) NOT NULL,
  `cd_knm` varchar(100) DEFAULT NULL,
  `vld_val` varchar(100) DEFAULT NULL,
  `cd_idtf_id` varchar(36) DEFAULT NULL,
  `clsf_type_id` varchar(36) DEFAULT NULL,
  `cd_enm` varchar(100) DEFAULT NULL,
  `cd_clsf_type_nm` varchar(100) DEFAULT NULL,
  `vld_val_sno` varchar(10) DEFAULT NULL,
  `vld_val_nm` varchar(1000) DEFAULT NULL,
  `vld_val_frmal_nm` varchar(200) DEFAULT NULL,
  `upper_vld_val` varchar(100) DEFAULT NULL,
  `uppser_vld_val_nm` varchar(200) DEFAULT NULL,
  `domn_knm` varchar(100) DEFAULT NULL,
  `domn_enm` varchar(100) DEFAULT NULL,
  `vld_sdt` datetime DEFAULT NULL,
  `vld_edt` datetime DEFAULT NULL,
  `crt_dtti` datetime DEFAULT NULL,
  `chng_dttm` datetime DEFAULT NULL,
  `std_cod_id` varchar(36) DEFAULT NULL,
  `data_type` varchar(4000) DEFAULT NULL,
  `data_length` varchar(10) DEFAULT NULL,
  `del_yn` char(1) DEFAULT NULL,
  UNIQUE KEY `xseaimx04u` (`code_id`),
  KEY `xseaimx04n1` (`chng_dttm`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaimx05 definition

CREATE TABLE `tseaimx05` (
  `obj_id` varchar(36) NOT NULL,
  `err_act_cd` varchar(10) DEFAULT NULL,
  `err_tlg_lan_dscd` varchar(3) DEFAULT NULL,
  `chnl_msg_cd` varchar(10) DEFAULT NULL,
  `chnl_typ_cd` varchar(2) DEFAULT NULL,
  `actn_msg_ctnt` varchar(200) DEFAULT NULL,
  `use_yn` varchar(1) DEFAULT NULL,
  `actn_cd_apcl_dt` varchar(10) DEFAULT NULL,
  `mci_lnk_yn` varchar(1) DEFAULT NULL,
  `mci_lnk_dt` datetime DEFAULT NULL,
  `actn_del_yn` varchar(1) DEFAULT NULL,
  `chng_dttm` datetime DEFAULT NULL,
  `del_yn` varchar(1) DEFAULT NULL,
  UNIQUE KEY `xseaimx05u` (`obj_id`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaiqm01 definition

CREATE TABLE `tseaiqm01` (
  `nonsyncztranquename` varchar(100) NOT NULL,
  `eaiquebzwkctnt` varchar(100) NOT NULL DEFAULT '',
  `queuseyn` char(1) NOT NULL,
  `queusagdstcd` char(1) NOT NULL,
  `eaibzwkdstcd` varchar(4) NOT NULL,
  `eaiquebzwkdtalsctnt` varchar(200) NOT NULL DEFAULT '',
  `eaisevrinstncname` varchar(20) NOT NULL DEFAULT '',
  UNIQUE KEY `xseaiqm01u` (`nonsyncztranquename`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaiqm02 definition

CREATE TABLE `tseaiqm02` (
  `quercvername` varchar(100) NOT NULL,
  `nonsyncztranquename` varchar(100) NOT NULL DEFAULT '',
  `nonsyncztranobstclquename` varchar(100) NOT NULL DEFAULT '',
  `quemsgselctctnt` varchar(1000) DEFAULT '',
  `senddlayttmval` decimal(22,0) NOT NULL,
  `sendretralnotms` decimal(22,0) NOT NULL,
  `quercvercnt` decimal(22,0) NOT NULL,
  `quercverdtalsctnt` varchar(200) DEFAULT NULL,
  `bascquercveryn` char(1) NOT NULL DEFAULT '0',
  `eaisevrinstncname` varchar(20) NOT NULL,
  UNIQUE KEY `xseaiqm02u` (`quercvername`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseairm01 definition

CREATE TABLE `tseairm01` (
  `menuid` varchar(40) NOT NULL,
  `parentmenuid` varchar(40) NOT NULL DEFAULT '',
  `sortorder` decimal(22,0) NOT NULL,
  `menuname` varchar(100) NOT NULL,
  `menuurl` varchar(200) NOT NULL,
  `menuimage` varchar(50) DEFAULT NULL,
  `displayyn` char(1) NOT NULL,
  `useyn` char(1) NOT NULL,
  `apppath` varchar(100) DEFAULT NULL,
  `appcode` varchar(3) DEFAULT NULL,
  UNIQUE KEY `xseairm01u` (`menuid`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseairm02 definition

CREATE TABLE `tseairm02` (
  `userid` varchar(8) NOT NULL,
  `username` varchar(40) NOT NULL,
  `password` varchar(40) NOT NULL,
  `branchcode` varchar(6) DEFAULT NULL,
  `mobile` varchar(40) DEFAULT NULL,
  `phone` varchar(40) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `positionname` varchar(100) DEFAULT NULL,
  `deptname` varchar(40) DEFAULT NULL,
  `createby` varchar(8) DEFAULT NULL,
  `updateby` varchar(8) DEFAULT NULL,
  `createon` varchar(14) DEFAULT NULL,
  `updateon` varchar(14) DEFAULT NULL,
  `useyn` varchar(1) DEFAULT NULL,
  `loginfailcount` decimal(22,0) DEFAULT '0',
  UNIQUE KEY `xseairm02u` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseairm03 definition

CREATE TABLE `tseairm03` (
  `roleid` varchar(40) NOT NULL,
  `menuid` varchar(40) NOT NULL,
  `auth` char(1) NOT NULL,
  UNIQUE KEY `xseairm03u` (`roleid`,`menuid`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseairm04 definition

CREATE TABLE `tseairm04` (
  `userid` varchar(40) NOT NULL,
  `roleid` varchar(40) NOT NULL,
  UNIQUE KEY `xseairm04u` (`userid`,`roleid`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseairm05 definition

CREATE TABLE `tseairm05` (
  `roleid` varchar(40) NOT NULL,
  `rolename` varchar(50) NOT NULL,
  `useyn` char(1) NOT NULL,
  `roledesc` varchar(200) NOT NULL DEFAULT '',
  `menuid` varchar(40) NOT NULL DEFAULT '',
  UNIQUE KEY `xseairm05u` (`roleid`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseairm06 definition

CREATE TABLE `tseairm06` (
  `userid` varchar(8) NOT NULL,
  `eaibzwkdstcd` varchar(4) NOT NULL,
  UNIQUE KEY `xseairm06u` (`userid`,`eaibzwkdstcd`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseairm07 definition

CREATE TABLE `tseairm07` (
  `prptygroupname` varchar(50) NOT NULL,
  `prptygroupdesc` varchar(100) DEFAULT NULL,
  UNIQUE KEY `xseairm07u` (`prptygroupname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseairm08 definition

CREATE TABLE `tseairm08` (
  `prptygroupname` varchar(50) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `prptyname` varchar(100) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `prpty2val` varchar(1000) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  UNIQUE KEY `xseairm08u` (`prptygroupname`,`prptyname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseairm12 definition

CREATE TABLE `tseairm12` (
  `eaimonisvcdstcd` char(1) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `eaibzwkdstcd` varchar(4) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `eaisvcname` varchar(30) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `uapplcd` char(3) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `eaibzwkdomndstcd` char(1) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `eairlgoalnoitm` decimal(22,0) NOT NULL,
  `eairlreginoitm` decimal(22,0) NOT NULL,
  `eairlfnshyn` char(1) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  UNIQUE KEY `xseairm12u` (`eaimonisvcdstcd`,`eaibzwkdstcd`,`eaisvcname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseairm15 definition

CREATE TABLE `tseairm15` (
  `logseqno` decimal(22,0) DEFAULT NULL,
  `userid` varchar(8) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `remoteaddress` varchar(15) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `logtypeclass` varchar(500) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `logsubmsg` varchar(500) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `logmsg` varchar(500) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `parameters` varchar(4000) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `logamndhms` char(16) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  UNIQUE KEY `xseairm15u` (`logseqno`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseairm20 definition

CREATE TABLE `tseairm20` (
  `uuid` varchar(40) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `jobname` varchar(40) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `startdate` varchar(17) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `enddate` varchar(17) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `status` varchar(20) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `instancename` varchar(20) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  UNIQUE KEY `xseairm20u` (`uuid`),
  KEY `ix_tseairm20_01` (`jobname`,`instancename`,`enddate`),
  KEY `ix_tseairm20_02` (`enddate`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseairm21 definition

CREATE TABLE `tseairm21` (
  `jobname` varchar(40) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `cronexp` varchar(50) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `jobclassname` varchar(200) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `useyn` char(1) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `instancename` varchar(20) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `jobdesc` varchar(2000) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `chkstatus` char(1) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  UNIQUE KEY `xseairm21u` (`jobname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseairm22 definition

CREATE TABLE `tseairm22` (
  `jobname` varchar(40) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `datakey` varchar(100) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `datavalue` varchar(100) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  UNIQUE KEY `xseairm22u` (`jobname`,`datakey`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseairm31 definition

CREATE TABLE `tseairm31` (
  `menuidnfiname` varchar(40) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `hirkmenuname` varchar(40) CHARACTER SET euckr COLLATE euckr_bin NOT NULL DEFAULT '',
  `menulnpserno` decimal(22,0) NOT NULL,
  `menuname` varchar(100) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `menuurlname` varchar(200) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `menuimgname` varchar(50) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `outptyn` char(1) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `useyn` char(1) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `datauapplpathname` varchar(100) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseairm32 definition

CREATE TABLE `tseairm32` (
  `roleidnfiname` varchar(40) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `menuidnfiname` varchar(40) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `eaimodfimgtathdstcd` char(1) CHARACTER SET euckr COLLATE euckr_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseairm33 definition

CREATE TABLE `tseairm33` (
  `roleidnfiname` varchar(40) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `roledtailname` varchar(50) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `useyn` char(1) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `roledtailctnt` varchar(200) CHARACTER SET euckr COLLATE euckr_bin NOT NULL DEFAULT '',
  `menuidnfiname` varchar(40) CHARACTER SET euckr COLLATE euckr_bin NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseairm34 definition

CREATE TABLE `tseairm34` (
  `pafiarinfoempid` varchar(8) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `eaibzwkdstcd` varchar(4) CHARACTER SET euckr COLLATE euckr_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaist01 definition

CREATE TABLE `tseaist01` (
  `statcjobymd` char(8) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `statcjobstarthms` char(16) CHARACTER SET euckr COLLATE euckr_bin NOT NULL DEFAULT '0',
  `statcjobendhms` char(16) CHARACTER SET euckr COLLATE euckr_bin NOT NULL DEFAULT '0',
  `sucssyn` char(1) CHARACTER SET euckr COLLATE euckr_bin NOT NULL DEFAULT '0',
  `errmsg` varchar(2000) CHARACTER SET euckr COLLATE euckr_bin NOT NULL DEFAULT '0',
  `statcjobcycldstcd` char(1) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  UNIQUE KEY `xseaist01u` (`statcjobymd`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaist02 definition

CREATE TABLE `tseaist02` (
  `statcymd` char(8) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `eaibzwkdstcd` char(4) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `eaisvcname` varchar(30) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `intfacptrncd` char(2) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `chnlmdiadstcd` char(4) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `logprcssserno` char(3) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `stndmsguseyn` char(1) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `s0hhtrsmtnoitm` decimal(22,0) NOT NULL,
  `s0hherrnoitm` decimal(22,0) NOT NULL,
  `s0hhrspnsavgval` decimal(22,3) NOT NULL,
  `s0hhrspnsmaxval` decimal(22,3) NOT NULL,
  `s1hhtrsmtnoitm` decimal(22,0) NOT NULL,
  `s1hherrnoitm` decimal(22,0) NOT NULL,
  `s1hhrspnsavgval` decimal(22,3) NOT NULL,
  `s1hhrspnsmaxval` decimal(22,3) NOT NULL,
  `s2hhtrsmtnoitm` decimal(22,0) NOT NULL,
  `s2hherrnoitm` decimal(22,0) NOT NULL,
  `s2hhrspnsavgval` decimal(22,3) NOT NULL,
  `s2hhrspnsmaxval` decimal(22,3) NOT NULL,
  `s3hhtrsmtnoitm` decimal(22,0) NOT NULL,
  `s3hherrnoitm` decimal(22,0) NOT NULL,
  `s3hhrspnsavgval` decimal(22,3) NOT NULL,
  `s3hhrspnsmaxval` decimal(22,3) NOT NULL,
  `s4hhtrsmtnoitm` decimal(22,0) NOT NULL,
  `s4hherrnoitm` decimal(22,0) NOT NULL,
  `s4hhrspnsavgval` decimal(22,3) NOT NULL,
  `s4hhrspnsmaxval` decimal(22,3) NOT NULL,
  `s5hhtrsmtnoitm` decimal(22,0) NOT NULL,
  `s5hherrnoitm` decimal(22,0) NOT NULL,
  `s5hhrspnsavgval` decimal(22,3) NOT NULL,
  `s5hhrspnsmaxval` decimal(22,3) NOT NULL,
  `s6hhtrsmtnoitm` decimal(22,0) NOT NULL,
  `s6hherrnoitm` decimal(22,0) NOT NULL,
  `s6hhrspnsavgval` decimal(22,3) NOT NULL,
  `s6hhrspnsmaxval` decimal(22,3) NOT NULL,
  `s7hhtrsmtnoitm` decimal(22,0) NOT NULL,
  `s7hherrnoitm` decimal(22,0) NOT NULL,
  `s7hhrspnsavgval` decimal(22,3) NOT NULL,
  `s7hhrspnsmaxval` decimal(22,3) NOT NULL,
  `s8hhtrsmtnoitm` decimal(22,0) NOT NULL,
  `s8hherrnoitm` decimal(22,0) NOT NULL,
  `s8hhrspnsavgval` decimal(22,3) NOT NULL,
  `s8hhrspnsmaxval` decimal(22,3) NOT NULL,
  `s9hhtrsmtnoitm` decimal(22,0) NOT NULL,
  `s9hherrnoitm` decimal(22,0) NOT NULL,
  `s9hhrspnsavgval` decimal(22,3) NOT NULL,
  `s9hhrspnsmaxval` decimal(22,3) NOT NULL,
  `s10hhtrsmtnoitm` decimal(22,0) NOT NULL,
  `s10hherrnoitm` decimal(22,0) NOT NULL,
  `s10hhrspnsavgval` decimal(22,3) NOT NULL,
  `s10hhrspnsmaxval` decimal(22,3) NOT NULL,
  `s11hhtrsmtnoitm` decimal(22,0) NOT NULL,
  `s11hherrnoitm` decimal(22,0) NOT NULL,
  `s11hhrspnsavgval` decimal(22,3) NOT NULL,
  `s11hhrspnsmaxval` decimal(22,3) NOT NULL,
  `s12hhtrsmtnoitm` decimal(22,0) NOT NULL,
  `s12hherrnoitm` decimal(22,0) NOT NULL,
  `s12hhrspnsavgval` decimal(22,3) NOT NULL,
  `s12hhrspnsmaxval` decimal(22,3) NOT NULL,
  `s13hhtrsmtnoitm` decimal(22,0) NOT NULL,
  `s13hherrnoitm` decimal(22,0) NOT NULL,
  `s13hhrspnsavgval` decimal(22,3) NOT NULL,
  `s13hhrspnsmaxval` decimal(22,3) NOT NULL,
  `s14hhtrsmtnoitm` decimal(22,0) NOT NULL,
  `s14hherrnoitm` decimal(22,0) NOT NULL,
  `s14hhrspnsavgval` decimal(22,3) NOT NULL,
  `s14hhrspnsmaxval` decimal(22,3) NOT NULL,
  `s15hhtrsmtnoitm` decimal(22,0) NOT NULL,
  `s15hherrnoitm` decimal(22,0) NOT NULL,
  `s15hhrspnsavgval` decimal(22,3) NOT NULL,
  `s15hhrspnsmaxval` decimal(22,3) NOT NULL,
  `s16hhtrsmtnoitm` decimal(22,0) NOT NULL,
  `s16hherrnoitm` decimal(22,0) NOT NULL,
  `s16hhrspnsavgval` decimal(22,3) NOT NULL,
  `s16hhrspnsmaxval` decimal(22,3) NOT NULL,
  `s17hhtrsmtnoitm` decimal(22,0) NOT NULL,
  `s17hherrnoitm` decimal(22,0) NOT NULL,
  `s17hhrspnsavgval` decimal(22,3) NOT NULL,
  `s17hhrspnsmaxval` decimal(22,3) NOT NULL,
  `s18hhtrsmtnoitm` decimal(22,0) NOT NULL,
  `s18hherrnoitm` decimal(22,0) NOT NULL,
  `s18hhrspnsavgval` decimal(22,3) NOT NULL,
  `s18hhrspnsmaxval` decimal(22,3) NOT NULL,
  `s19hhtrsmtnoitm` decimal(22,0) NOT NULL,
  `s19hherrnoitm` decimal(22,0) NOT NULL,
  `s19hhrspnsavgval` decimal(22,3) NOT NULL,
  `s19hhrspnsmaxval` decimal(22,3) NOT NULL,
  `s20hhtrsmtnoitm` decimal(22,0) NOT NULL,
  `s20hherrnoitm` decimal(22,0) NOT NULL,
  `s20hhrspnsavgval` decimal(22,3) NOT NULL,
  `s20hhrspnsmaxval` decimal(22,3) NOT NULL,
  `s21hhtrsmtnoitm` decimal(22,0) NOT NULL,
  `s21hherrnoitm` decimal(22,0) NOT NULL,
  `s21hhrspnsavgval` decimal(22,3) NOT NULL,
  `s21hhrspnsmaxval` decimal(22,3) NOT NULL,
  `s22hhtrsmtnoitm` decimal(22,0) NOT NULL,
  `s22hherrnoitm` decimal(22,0) NOT NULL,
  `s22hhrspnsavgval` decimal(22,3) NOT NULL,
  `s22hhrspnsmaxval` decimal(22,3) NOT NULL,
  `s23hhtrsmtnoitm` decimal(22,0) NOT NULL,
  `s23hherrnoitm` decimal(22,0) NOT NULL,
  `s23hhrspnsavgval` decimal(22,3) NOT NULL,
  `s23hhrspnsmaxval` decimal(22,3) NOT NULL,
  UNIQUE KEY `xseaist02u` (`statcymd`,`eaibzwkdstcd`,`eaisvcname`,`chnlmdiadstcd`,`intfacptrncd`,`logprcssserno`,`stndmsguseyn`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaist03 definition

CREATE TABLE `tseaist03` (
  `statcym` char(6) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `eaibzwkdstcd` char(4) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `eaisvcname` varchar(30) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `intfacptrncd` char(2) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `chnlmdiadstcd` char(4) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `logprcssserno` char(3) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `stndmsguseyn` char(1) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `s1ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s1dderrnoitm` decimal(22,0) NOT NULL,
  `s1ddrspnsavgval` decimal(22,3) NOT NULL,
  `s2ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s2dderrnoitm` decimal(22,0) NOT NULL,
  `s2ddrspnsavgval` decimal(22,3) NOT NULL,
  `s3ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s3dderrnoitm` decimal(22,0) NOT NULL,
  `s3ddrspnsavgval` decimal(22,3) NOT NULL,
  `s4ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s4dderrnoitm` decimal(22,0) NOT NULL,
  `s4ddrspnsavgval` decimal(22,3) NOT NULL,
  `s5ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s5dderrnoitm` decimal(22,0) NOT NULL,
  `s5ddrspnsavgval` decimal(22,3) NOT NULL,
  `s6ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s6dderrnoitm` decimal(22,0) NOT NULL,
  `s6ddrspnsavgval` decimal(22,3) NOT NULL,
  `s7ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s7dderrnoitm` decimal(22,0) NOT NULL,
  `s7ddrspnsavgval` decimal(22,3) NOT NULL,
  `s8ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s8dderrnoitm` decimal(22,0) NOT NULL,
  `s8ddrspnsavgval` decimal(22,3) NOT NULL,
  `s9ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s9dderrnoitm` decimal(22,0) NOT NULL,
  `s9ddrspnsavgval` decimal(22,3) NOT NULL,
  `s10ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s10dderrnoitm` decimal(22,0) NOT NULL,
  `s10ddrspnsavgval` decimal(22,3) NOT NULL,
  `s11ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s11dderrnoitm` decimal(22,0) NOT NULL,
  `s11ddrspnsavgval` decimal(22,3) NOT NULL,
  `s12ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s12dderrnoitm` decimal(22,0) NOT NULL,
  `s12ddrspnsavgval` decimal(22,3) NOT NULL,
  `s13ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s13dderrnoitm` decimal(22,0) NOT NULL,
  `s13ddrspnsavgval` decimal(22,3) NOT NULL,
  `s14ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s14dderrnoitm` decimal(22,0) NOT NULL,
  `s14ddrspnsavgval` decimal(22,3) NOT NULL,
  `s15ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s15dderrnoitm` decimal(22,0) NOT NULL,
  `s15ddrspnsavgval` decimal(22,3) NOT NULL,
  `s16ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s16dderrnoitm` decimal(22,0) NOT NULL,
  `s16ddrspnsavgval` decimal(22,3) NOT NULL,
  `s17ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s17dderrnoitm` decimal(22,0) NOT NULL,
  `s17ddrspnsavgval` decimal(22,3) NOT NULL,
  `s18ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s18dderrnoitm` decimal(22,0) NOT NULL,
  `s18ddrspnsavgval` decimal(22,3) NOT NULL,
  `s19ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s19dderrnoitm` decimal(22,0) NOT NULL,
  `s19ddrspnsavgval` decimal(22,3) NOT NULL,
  `s20ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s20dderrnoitm` decimal(22,0) NOT NULL,
  `s20ddrspnsavgval` decimal(22,3) NOT NULL,
  `s21ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s21dderrnoitm` decimal(22,0) NOT NULL,
  `s21ddrspnsavgval` decimal(22,3) NOT NULL,
  `s22ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s22dderrnoitm` decimal(22,0) NOT NULL,
  `s22ddrspnsavgval` decimal(22,3) NOT NULL,
  `s23ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s23dderrnoitm` decimal(22,0) NOT NULL,
  `s23ddrspnsavgval` decimal(22,3) NOT NULL,
  `s24ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s24dderrnoitm` decimal(22,0) NOT NULL,
  `s24ddrspnsavgval` decimal(22,3) NOT NULL,
  `s25ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s25dderrnoitm` decimal(22,0) NOT NULL,
  `s25ddrspnsavgval` decimal(22,3) NOT NULL,
  `s26ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s26dderrnoitm` decimal(22,0) NOT NULL,
  `s26ddrspnsavgval` decimal(22,3) NOT NULL,
  `s27ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s27dderrnoitm` decimal(22,0) NOT NULL,
  `s27ddrspnsavgval` decimal(22,3) NOT NULL,
  `s28ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s28dderrnoitm` decimal(22,0) NOT NULL,
  `s28ddrspnsavgval` decimal(22,3) NOT NULL,
  `s29ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s29dderrnoitm` decimal(22,0) NOT NULL,
  `s29ddrspnsavgval` decimal(22,3) NOT NULL,
  `s30ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s30dderrnoitm` decimal(22,0) NOT NULL,
  `s30ddrspnsavgval` decimal(22,3) NOT NULL,
  `s31ddtrsmtnoitm` decimal(22,0) NOT NULL,
  `s31dderrnoitm` decimal(22,0) NOT NULL,
  `s31ddrspnsavgval` decimal(22,3) NOT NULL,
  UNIQUE KEY `xseaist03u` (`statcym`,`eaibzwkdstcd`,`eaisvcname`,`chnlmdiadstcd`,`intfacptrncd`,`logprcssserno`,`stndmsguseyn`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaist04 definition

CREATE TABLE `tseaist04` (
  `statcym` char(6) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `eaibzwkdstcd` char(4) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `eaisvcname` varchar(30) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `intfacptrncd` char(2) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `chnlmdiadstcd` char(4) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `logprcssserno` char(3) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `stndmsguseyn` char(1) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `s1mntrsmtnoitm` decimal(22,0) NOT NULL,
  `s1mnerrnoitm` decimal(22,0) NOT NULL,
  `s1mnrspnsavgval` decimal(22,3) NOT NULL,
  `s2mntrsmtnoitm` decimal(22,0) NOT NULL,
  `s2mnerrnoitm` decimal(22,0) NOT NULL,
  `s2mnrspnsavgval` decimal(22,3) NOT NULL,
  `s3mntrsmtnoitm` decimal(22,0) NOT NULL,
  `s3mnerrnoitm` decimal(22,0) NOT NULL,
  `s3mnrspnsavgval` decimal(22,3) NOT NULL,
  `s4mntrsmtnoitm` decimal(22,0) NOT NULL,
  `s4mnerrnoitm` decimal(22,0) NOT NULL,
  `s4mnrspnsavgval` decimal(22,3) NOT NULL,
  `s5mntrsmtnoitm` decimal(22,0) NOT NULL,
  `s5mnerrnoitm` decimal(22,0) NOT NULL,
  `s5mnrspnsavgval` decimal(22,3) NOT NULL,
  `s6mntrsmtnoitm` decimal(22,0) NOT NULL,
  `s6mnerrnoitm` decimal(22,0) NOT NULL,
  `s6mnrspnsavgval` decimal(22,3) NOT NULL,
  `s7mntrsmtnoitm` decimal(22,0) NOT NULL,
  `s7mnerrnoitm` decimal(22,0) NOT NULL,
  `s7mnrspnsavgval` decimal(22,3) NOT NULL,
  `s8mntrsmtnoitm` decimal(22,0) NOT NULL,
  `s8mnerrnoitm` decimal(22,0) NOT NULL,
  `s8mnrspnsavgval` decimal(22,3) NOT NULL,
  `s9mntrsmtnoitm` decimal(22,0) NOT NULL,
  `s9mnerrnoitm` decimal(22,0) NOT NULL,
  `s9mnrspnsavgval` decimal(22,3) NOT NULL,
  `s10mntrsmtnoitm` decimal(22,0) NOT NULL,
  `s10mnerrnoitm` decimal(22,0) NOT NULL,
  `s10mnrspnsavgval` decimal(22,3) NOT NULL,
  `s11mntrsmtnoitm` decimal(22,0) NOT NULL,
  `s11mnerrnoitm` decimal(22,0) NOT NULL,
  `s11mnrspnsavgval` decimal(22,3) NOT NULL,
  `s12mntrsmtnoitm` decimal(22,0) NOT NULL,
  `s12mnerrnoitm` decimal(22,0) NOT NULL,
  `s12mnrspnsavgval` decimal(22,3) NOT NULL,
  UNIQUE KEY `xseaist04u` (`statcym`,`eaibzwkdstcd`,`eaisvcname`,`chnlmdiadstcd`,`intfacptrncd`,`logprcssserno`,`stndmsguseyn`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaisy01 definition

CREATE TABLE `tseaisy01` (
  `sysdomnname` varchar(12) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `sysdomndesc` varchar(200) CHARACTER SET euckr COLLATE euckr_bin DEFAULT '',
  UNIQUE KEY `xseaisy01u` (`sysdomnname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaisy02 definition

CREATE TABLE `tseaisy02` (
  `eaisevrinstncname` varchar(20) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `eaisevrip` varchar(50) CHARACTER SET euckr COLLATE euckr_bin DEFAULT '',
  `sevrlsnportname` varchar(5) CHARACTER SET euckr COLLATE euckr_bin DEFAULT '',
  `flovrsevrname` varchar(20) CHARACTER SET euckr COLLATE euckr_bin DEFAULT '',
  `hostname` varchar(20) CHARACTER SET euckr COLLATE euckr_bin DEFAULT '',
  UNIQUE KEY `xseaisy02u` (`eaisevrinstncname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaiti01 definition

CREATE TABLE `tseaiti01` (
  `eaictrlname` varchar(30) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `eaictrlnamedstcd` char(1) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `eaictrldsticctnt` varchar(50) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `ctrlprcssyms` char(17) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `tranctrlprcssname` varchar(8) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  UNIQUE KEY `xseaiti01u` (`eaictrlname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaitl01 definition

CREATE TABLE `tseaitl01` (
  `eaictrlname` varchar(30) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `ctrlprcssyms` char(17) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `ctrlrevocyms` char(17) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `eaictrlnamedstcd` char(1) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `eaictrldsticctnt` varchar(50) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `ctrlprcssname` varchar(8) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `revocprcssname` varchar(8) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  UNIQUE KEY `xseaitl01u` (`eaictrlname`,`ctrlprcssyms`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaitl02 definition

CREATE TABLE `tseaitl02` (
  `eaibzwkdstcd` varchar(4) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `msgdpstyms` char(17) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `eaisvcserno` char(40) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `eaisevrinstncname` varchar(20) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `eaisvcname` varchar(30) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `eaiosidinsticd` char(3) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `eaictrlnamedstcd` char(1) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  UNIQUE KEY `xseaitl02u` (`eaibzwkdstcd`,`msgdpstyms`,`eaisvcserno`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaitr01 definition

CREATE TABLE `tseaitr01` (
  `cnvsnname` varchar(50) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `cnvsndesc` varchar(2000) CHARACTER SET euckr COLLATE euckr_bin DEFAULT '',
  `lastamndhms` char(16) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `createby` varchar(8) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `updateby` varchar(8) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  UNIQUE KEY `xseaitr01u` (`cnvsnname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaitr02 definition

CREATE TABLE `tseaitr02` (
  `cnvsnname` varchar(50) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `loutname` varchar(50) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `sourcrsultdstcd` char(10) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  UNIQUE KEY `xseaitr02u` (`cnvsnname`,`loutname`,`sourcrsultdstcd`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaitr03 definition

CREATE TABLE `tseaitr03` (
  `cnvsnname` varchar(50) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `cnvsnrsultitempathname` varchar(2000) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `cnvsncmdname` varchar(2000) CHARACTER SET euckr COLLATE euckr_bin NOT NULL DEFAULT '',
  `cnvsnitembascval` varchar(200) CHARACTER SET euckr COLLATE euckr_bin DEFAULT '',
  `cnvsnitemserno` decimal(22,0) NOT NULL,
  UNIQUE KEY `xseaitr03u` (`cnvsnname`,`cnvsnrsultitempathname`(300))
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaitr04 definition

CREATE TABLE `tseaitr04` (
  `cnvsnfuntnname` varchar(50) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `cnvsnfuntndesc` varchar(2000) CHARACTER SET euckr COLLATE euckr_bin DEFAULT '',
  `cnvsnfuntnretunptrnidname` decimal(22,0) NOT NULL,
  `cnvsnfuntnclsname` varchar(200) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `cnvsnfuntnptrnidname` decimal(22,0) NOT NULL,
  UNIQUE KEY `xseaitr04u` (`cnvsnfuntnname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaitr05 definition

CREATE TABLE `tseaitr05` (
  `cnvsnfuntnname` varchar(50) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `cnvsnfuntnparmname` varchar(50) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `cnvsnfuntnparmdesc` varchar(2000) CHARACTER SET euckr COLLATE euckr_bin DEFAULT '',
  `cnvsnfuntnparmptrnidname` decimal(22,0) NOT NULL,
  `cnvsnfuntnparmserno` decimal(22,0) NOT NULL,
  UNIQUE KEY `xseaitr05u` (`cnvsnfuntnname`,`cnvsnfuntnparmname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaitr06 definition

CREATE TABLE `tseaitr06` (
  `loutptrnname` varchar(20) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `loutptrndesc` varchar(2000) CHARACTER SET euckr COLLATE euckr_bin DEFAULT '',
  `msgloutcretnclsname` varchar(200) CHARACTER SET euckr COLLATE euckr_bin NOT NULL DEFAULT '',
  UNIQUE KEY `xseaitr06u` (`loutptrnname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaitr07 definition

CREATE TABLE `tseaitr07` (
  `loutname` varchar(50) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `loutptrnname` varchar(20) CHARACTER SET euckr COLLATE euckr_bin NOT NULL DEFAULT '',
  `loutdesc` varchar(2000) CHARACTER SET euckr COLLATE euckr_bin DEFAULT '',
  `lastamndhms` char(16) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `eaibzwkdstcd` varchar(4) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `uapplname` varchar(50) CHARACTER SET euckr COLLATE euckr_bin DEFAULT '',
  `sysintfacname` varchar(50) CHARACTER SET euckr COLLATE euckr_bin DEFAULT '',
  `createby` varchar(8) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `updateby` varchar(8) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  UNIQUE KEY `xseaitr07u` (`loutname`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaitr08 definition

CREATE TABLE `tseaitr08` (
  `loutname` varchar(50) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `loutitemname` varchar(50) CHARACTER SET euckr COLLATE euckr_bin NOT NULL,
  `loutitemserno` decimal(22,0) NOT NULL,
  `loutitemidname` decimal(22,0) NOT NULL,
  `parntloutitemidname` decimal(22,0) NOT NULL,
  `loutitemdesc` varchar(200) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `loutitemnodeptrnidname` decimal(22,0) NOT NULL,
  `loutitemptrnidname` decimal(22,0) NOT NULL,
  `loutitempathname` varchar(200) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `loutitemlencnt` decimal(22,0) NOT NULL,
  `loutitemrefinfo` varchar(200) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `loutitemrefinfo2` varchar(200) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `loutitemoccurptrndstcd` varchar(5) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `loutitemmaxoccurnoitm` decimal(22,0) NOT NULL,
  `loutitemminoccurnoitm` decimal(22,0) NOT NULL,
  `loutitembascval` varchar(200) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `loutitemmskyn` char(1) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `lyoutdptcnt` decimal(22,0) NOT NULL,
  `decptlencnt` decimal(22,0) NOT NULL,
  `lyoutitemrefptrnidname` varchar(20) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `loutitemmasklength` decimal(22,0) DEFAULT NULL,
  UNIQUE KEY `xseaitr08u` (`loutname`,`loutitemname`,`loutitemserno`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaitr09 definition

CREATE TABLE `tseaitr09` (
  `logprcssserno` char(40) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `executedate` char(8) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `executeclass` varchar(500) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `executemethod` varchar(500) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `executeuser` varchar(8) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `sendxmlcmnt` varchar(4000) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `sendamndhms` char(16) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `recvamndhms` char(16) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `recvrslt` char(1) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `recvfailcmnt` varchar(4000) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  UNIQUE KEY `xseaitr09u` (`logprcssserno`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;


-- eai.tseaitr10 definition

CREATE TABLE `tseaitr10` (
  `logprcssseqno` char(40) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `seqno` decimal(22,0) DEFAULT NULL,
  `servicename` varchar(50) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `command` varchar(25) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `loutname` varchar(50) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `recvdata` varchar(4000) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `recvamndhms` char(16) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `prcssrslt` char(1) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  `prcssrsltcmnt` varchar(4000) CHARACTER SET euckr COLLATE euckr_bin DEFAULT NULL,
  UNIQUE KEY `xseaitr10u` (`logprcssseqno`,`seqno`)
) ENGINE=InnoDB DEFAULT CHARSET=euckr;
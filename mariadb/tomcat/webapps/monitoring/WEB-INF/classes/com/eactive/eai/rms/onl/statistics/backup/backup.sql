/* 전체 건수 쿼리 */ 
SELECT
     MAX('20081114') AS yyyymm,
     SUBSTR(MsgDpstHMS, 9, 2) AS hh,      
     sevrGroupName,                                                                                  
     eaiBzwkDstcd,                                                                                                         
     eaiSvcName,                                                                                                           
     chnlMdiaDstcd,                                                                                                        
     SUBSTR(SvcMotivUseDstcd, 1, 1) || SUBSTR(PsvIntfacDsticName, 1, 1) AS intfacPtrnCd ,                              
     stndMsgUseCd,                                                                                                         
     logPrcssSerno,      
     COUNT(*) AS trstmNoitm,
     MAX(     ( INT(SUBSTR(MsgPrcssHMS,11,2)) * 60000 + INT(SUBSTR(MsgPrcssHMS,13,2)) * 1000 + INT(SUBSTR(MsgPrcssHMS,15,3)) ) 
            - ( INT(SUBSTR(MsgDpstHMS, 11,2)) * 60000 + INT(SUBSTR(MsgDpstHMS ,13,2)) * 1000 + INT(SUBSTR(MsgDpstHMS ,15,3)) ) 
     ) AS rspnsMaxVal,                                                                                                         
     AVG(     ( INT(SUBSTR(MsgPrcssHMS,11,2)) * 60000 + INT(SUBSTR(MsgPrcssHMS,13,2)) * 1000 + INT(SUBSTR(MsgPrcssHMS,15,3)) ) 
            - ( INT(SUBSTR(MsgDpstHMS, 11,2)) * 60000 + INT(SUBSTR(MsgDpstHMS ,13,2)) * 1000 + INT(SUBSTR(MsgDpstHMS ,15,3)) ) 
     ) AS rspnsAvgVal                                                                                                          
 FROM eai.eailog                                                                                                               
 WHERE                                                                                                                         
         MsgDpstHMS >= '20081114'||'000000000'                                                                              
     AND MsgDpstHMS <= '20081114'||'239999999'
     AND (LogPrcssSerno = 100 OR (LogPrcssSerno = 300 AND SVCMOTIVUSEDSTCD = 'ASYN' AND PSVINTFACDSTICNAME = 'ASYN'))
 GROUP BY                                                                                   
         SUBSTR(MsgDpstHMS, 9, 2),            
         SEVRGROUPNAME,                                                                              
         EAIBzwkDstcd,                                                                                                     
         EAISvcName,                                                                                                       
         ChnlMdiaDstcd,                                                                                                    
         SUBSTR(SvcMotivUseDstcd, 1, 1) || SUBSTR(PsvIntfacDsticName, 1, 1),                                           
         StndMsgUseCd,                                                                                                     
         LogPrcssSerno



/* 에러 건수 쿼리 */         
SELECT                                                                                                                                                                                                      
     SUBSTR(MsgDpstHMS, 9, 2) AS hh,      
     sevrGroupName,                                                                                  
     eaiBzwkDstcd,                                                                                                         
     eaiSvcName,                                                                                                           
     chnlMdiaDstcd,                                                                                                        
     SUBSTR(SvcMotivUseDstcd, 1, 1) || SUBSTR(PsvIntfacDsticName, 1, 1) AS intfacPtrnCd ,                              
     stndMsgUseCd,                                                                                                         
     logPrcssSerno,                                                                                                  
     COUNT(*) AS errNoitm,                                                                                                       
     MAX(     ( INT(SUBSTR(MsgPrcssHMS,11,2)) * 60000 + INT(SUBSTR(MsgPrcssHMS,13,2)) * 1000 + INT(SUBSTR(MsgPrcssHMS,15,3)) ) 
            - ( INT(SUBSTR(MsgDpstHMS, 11,2)) * 60000 + INT(SUBSTR(MsgDpstHMS ,13,2)) * 1000 + INT(SUBSTR(MsgDpstHMS ,15,3)) ) 
     ) AS rspnsMaxVal,                                                                                                         
     AVG(     ( INT(SUBSTR(MsgPrcssHMS,11,2)) * 60000 + INT(SUBSTR(MsgPrcssHMS,13,2)) * 1000 + INT(SUBSTR(MsgPrcssHMS,15,3)) ) 
            - ( INT(SUBSTR(MsgDpstHMS, 11,2)) * 60000 + INT(SUBSTR(MsgDpstHMS ,13,2)) * 1000 + INT(SUBSTR(MsgDpstHMS ,15,3)) ) 
     ) AS rspnsAvgVal
 FROM eai.eailog                                                                                                               
 WHERE                                                                                                                         
         MsgDpstHMS >= '20081114'||'000000000'                                                                              
     AND MsgDpstHMS <= '20081114'||'239999999'
     AND (RspnsErrCdName like 'RE%' OR  RspnsErrCdName like 'RF%')
     AND ( 
        (SVCMOTIVUSEDSTCD != 'ASYN' OR PSVINTFACDSTICNAME != 'ASYN' AND LogPrcssSerno = 400) 
        OR
        (SVCMOTIVUSEDSTCD = 'ASYN' AND PSVINTFACDSTICNAME = 'ASYN' 
            AND (LogPrcssSerno = 200 OR LogPrcssSerno = 300 OR LogPrcssSerno = 400 OR LogPrcssSerno = 900))
     )
 GROUP BY                                                                                         
         SUBSTR(MsgDpstHMS, 9, 2), 
         SEVRGROUPNAME,                                                                                         
         EAIBzwkDstcd,                                                                                                     
         EAISvcName,                                                                                                       
         ChnlMdiaDstcd,                                                                                                    
         SUBSTR(SvcMotivUseDstcd, 1, 1) || SUBSTR(PsvIntfacDsticName, 1, 1),                                           
         StndMsgUseCd,                                                                                                     
         LogPrcssSerno
         
         
         

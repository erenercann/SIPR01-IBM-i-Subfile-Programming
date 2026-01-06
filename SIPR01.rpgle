     FSIPHDR    UF A E           K DISK                              
     FSIPDET    IF   E           K DISK                              
     FSIPDSPF   CF   E             WORKSTN                           
     F                                     SFILE(SIP01S:SFLRRN)      
     *                                                              
     D SFLRRN          S              4  0                           
     *                                                              
     C     *ENTRY        PLIST                                 
     C                   PARM                    pCOCONO           6
     *                                                            
     * --- ANA PROGRAM BASLANGICI ---                               
     C                   EXSR      LDSFL                             
     *                                                              
     C                   DOU       *IN03 = *ON                       
     C                   WRITE     FOOTER                            
     C                   EXFMT     SIP01C                            
     *                                                              
     C                   SELECT                                      
     C                   WHEN      *IN03 = *ON                       
     C                   LEAVE                                            
     *                                                                   
     C                   WHEN      *IN06 = *ON                            
     C                   EXSR      YENIKAYIT                              
     *                                                                   
     C                   WHEN      *IN05 = *ON OR S01POS <> *BLANKS       
     C                   EXSR      LDSFL                                  
     *                                                                   
     C                   OTHER                                            
     C                   EXSR      PRCSFL                                 
     C                   ENDSL                                            
     *                                                                   
     C                   ENDDO                                            
     *                                                                   
     C                   SETON                                        LR  
     * --- ANA PROGRAMIN SONU (LR SET EDILDI) ---                        
     *                                                                   
     * ----------------------------------------------------------------  
     C     LDSFL         BEGSR                                            
     C                   SETON                                        32  
     C                   WRITE     SIP01C                                   
     C                   SETOFF                                       32    
     C                   EVAL      SFLRRN = 0                               
     *                                                                     
     C     S01POS        SETLL     SIPHDRR                                  
     C                   READ      SIPHDRR                                99
     *                                                                     
     C                   DOW       *IN99 = *OFF AND SFLRRN < 15             
     C                   EVAL      SFLRRN = SFLRRN + 1                      
     C                   EVAL      S01SEL = *BLANKS                         
     C                   EVAL      S01SIP = SHSIPNO                         
     C                   EVAL      S01MUS = SHMUSTERI                       
     C                   EVAL      S01TAR = SHTARIH                         
     C                   EVAL      S01TUT = SHTUTAR                         
     C                   WRITE     SIP01S                                   
     C                   READ      SIPHDRR                                99
     C                   ENDDO                                              
     *                                                                     
     C                   IF        SFLRRN > 0                               
     C                   SETON                                        31    
     C                   ELSE                                               
     C                   SETOFF                                       31    
     C                   ENDIF                                              
     *                                                                     
     C                   EVAL      S01POS = *BLANKS                         
     C                   ENDSR                                              
     * ----------------------------------------------------------------    
     C     PRCSFL        BEGSR                                              
     C                   READC     SIP01S                                 95
     C                   DOW       *IN95 = *OFF                             
     *                                                                     
     C                   SELECT                                             
     C                   WHEN      S01SEL = '5'                             
     C                   EXSR      DETGOS                                   
     C                   WHEN      S01SEL = '2'                             
     C                   EXSR      KAYITGUNCELLE                            
     C                   WHEN      S01SEL = '4'                             
     C                   EXSR      KAYITSIL                                 
     C                   ENDSL                                              
     *                                                                     
     C                   EVAL      S01SEL = *BLANKS                         
     C                   UPDATE    SIP01S                                   
     C                   READC     SIP01S                                 95
     C                   ENDDO                                              
     *                                                                     
     C                   EXSR      LDSFL                                    
     C                   ENDSR                                              
     * ----------------------------------------------------------------    
     C     KAYITSIL      BEGSR                                              
     C     S01SIP        CHAIN     SIPHDRR                            90    
     C  N90              DELETE    SIPHDRR                                  
     C                   ENDSR                                              
     * ----------------------------------------------------------------    
     C     YENIKAYIT     BEGSR                                              
     C                   EVAL      E01SIP = *BLANKS                         
     C                   EVAL      E01MUS = *BLANKS                         
     C                   EVAL      E01TAR = 0                               
     C                   EVAL      E01TUT = 0                               
     C                   EXFMT     ENTREC                                   
     C                   IF        *IN03 = *OFF                             
     C                   EVAL      SHSIPNO = E01SIP                      
     C                   EVAL      SHMUSTERI = E01MUS                    
     C                   EVAL      SHTARIH = E01TAR                      
     C                   EVAL      SHTUTAR = E01TUT                      
     C                   WRITE     SIPHDRR                               
     C                   EXSR      LDSFL                                 
     C                   ENDIF                                           
     C                   ENDSR                                           
     * ---------------------------------------------------------------- 
     C     KAYITGUNCELLE BEGSR                                           
     C     S01SIP        CHAIN     SIPHDRR                            90 
     C  N90              DO                                              
     C                   EVAL      E01SIP = SHSIPNO                      
     C                   EVAL      E01MUS = SHMUSTERI                    
     C                   EVAL      E01TAR = SHTARIH                      
     C                   EVAL      E01TUT = SHTUTAR                      
     C                   EXFMT     ENTREC                                
     C                   IF        *IN03 = *OFF                          
     C                   EVAL      SHMUSTERI = E01MUS                    
     C                   EVAL      SHTARIH = E01TAR                      
     C                   EVAL      SHTUTAR = E01TUT                         
     C                   UPDATE    SIPHDRR                                  
     C                   ENDIF                                              
     C                   ENDDO                                              
     C                   ENDSR                                              
     * ----------------------------------------------------------------    
     C     DETGOS        BEGSR                                              
     C                   EVAL      W01SIP = S01SIP                          
     C     S01SIP        SETLL     SIPDETR                                  
     C     S01SIP        READE     SIPDETR                                98
     C  N98              EVAL      W01UR1 = SDURUN                          
     C  N98              EVAL      W01MK1 = SDMIKTAR                        
     C  N98              EVAL      W01FY1 = SDFIYAT                         
     C                   EXFMT     DETREC                                   
     C                   ENDSR                                               




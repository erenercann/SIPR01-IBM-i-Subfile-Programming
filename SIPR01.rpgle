       FSIPHDR    IF   E           K DISK                                   
       FSIPDET    IF   E           K DISK                                   
       FSIPDSPF   CF   E             WORKSTN                                
       F                                     SFILE(SIP01S:SFLRRN)           
        *                                                                   
       D SFLRRN          S              4  0                                
        *                                                                   
       C     *ENTRY        PLIST                                            
       C                   PARM                    pCOCONO           6      
        *                                                                   
        * --- ANA DÖNGÜ ---                                                 
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
        * F5 = Yenile veya Arama Alani Degistiyse                               
       C                   WHEN      *IN05 = *ON OR S01POS <> *BLANKS           
       C                   EXSR      LDSFL                                      
        *                                                                       
        * Satir Seçimi Yapildi mi? (5=Detay)                                    
       C                   OTHER                                                
       C                   EXSR      PRCSFL                                     
       C                   ENDSL                                                
        *                                                                       
       C                   ENDDO                                                
        *                                                                       
       C                   SETON                                        LR      
        *                                                                       
        * ----------------------------------------------------------------      
        * SUBFILE DOLDURMA (LOAD SFL)                                           
        * ----------------------------------------------------------------      
       C     LDSFL         BEGSR                                                
        * 1. Subfile'i Temizle                                                  
        C                   SETON                                        32       
       C                   WRITE     SIP01C                                      
       C                   SETOFF                                       32       
       C                   EVAL      SFLRRN = 0                                  
        *                                                                        
        * 2. Arama kriterine göre dosyayi konumlandir                            
       C     S01POS        SETLL     SIPHDRR                                     
       C                   READ      SIPHDRR                                99   
        *                                                                        
        * 3. Kayitlari oku ve SFL'e yaz (Max 15 kayit örnegi)                    
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
        * 4. SFL bos degilse göstergeyi yak                                      
       C                   IF        SFLRRN > 0                                  
       C                   SETON                                        31       
       C                   ELSE                                                  
       C                   SETOFF                                       31       
       C                   ENDIF                                                 
        *                                                                        
       C                   EVAL      S01POS = *BLANKS                            
       C                   ENDSR                                                 
        *                                                                        
        * ----------------------------------------------------------------       
        * SEÇILEN SATIRLARI ISLE (PROCESS SFL)                                   
        * ----------------------------------------------------------------       
       C     PRCSFL        BEGSR                                                 
       C                   READC     SIP01S                                 95   
       C                   DOW       *IN95 = *OFF                                
        *                                                                        
       C                   IF        S01SEL = '5'                                
       C                   EXSR      DETGOS                                      
       C                   ENDIF                                              
        *                                                                     
       C                   EVAL      S01SEL = *BLANKS                         
       C                   UPDATE    SIP01S                                   
       C                   READC     SIP01S                                 95
       C                   ENDDO                                              
       C                   ENDSR                                              
        *                                                                     
        * ----------------------------------------------------------------    
        * DETAY PENCERESINI GÖSTER                                            
        * ----------------------------------------------------------------    
       C     DETGOS        BEGSR                                              
       C                   EVAL      W01SIP = S01SIP                          
       C                   EVAL      W01UR1 = *BLANKS                         
       C                   EVAL      W01MK1 = 0                               
       C                   EVAL      W01FY1 = 0                               
       C                   EVAL      W01UR2 = *BLANKS                         
       C                   EVAL      W01MK2 = 0                               
       C                   EVAL      W01FY2 = 0                               
        *                                                                     
         * Siparis Detaylarini Oku (Ilk 2 satiri gösterelim)                    
       C     S01SIP        SETLL     SIPDETR                                   
       C     S01SIP        READE     SIPDETR                                98 
       C  N98              EVAL      W01UR1 = SDURUN                           
       C  N98              EVAL      W01MK1 = SDMIKTAR                         
       C  N98              EVAL      W01FY1 = SDFIYAT                          
        *                                                                      
       C     S01SIP        READE     SIPDETR                                98 
       C  N98              EVAL      W01UR2 = SDURUN                           
       C  N98              EVAL      W01MK2 = SDMIKTAR                         
       C  N98              EVAL      W01FY2 = SDFIYAT                          
        *                                                                      
       C                   EXFMT     DETREC                                    
       C                   ENDSR                                               
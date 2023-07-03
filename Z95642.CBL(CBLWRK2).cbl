       IDENTIFICATION DIVISION.
      *-----------------------
       PROGRAM-ID.    CBLWRK2
       AUTHOR.        Burak Kozluca
      *--------------------
       ENVIRONMENT DIVISION.
      *--------------------
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PRINT-LINE ASSIGN TO PRTLINE
                             STATUS    PRT-ST.
           SELECT ACCT-REC   ASSIGN TO ACCTREC
                             STATUS    ACCT-ST.
      *-------------
       DATA DIVISION.
      *-------------
       FILE SECTION.

      *Yazdiracagimiz dosyaya verileri aktarmak icin degiskenleri tanimladik
       FD  PRINT-LINE RECORDING MODE F.
       01  PRINT-REC.
           05 PRT-NO         PIC 9(04).
           05 FILLER         PIC X(02) VALUE SPACES.
           05 PRT-NAME       PIC X(15).
           05 PRT-SURNAME    PIC X(15).
           05 PRT-BDATE      PIC 9(08).
           05 PRT-TODAY      PIC 9(08).
           05 PRT-DIFF       PIC 9(04).

      *Okuyacagimiz dosyadaki verileri almak icin degiskenleri tanimladik
       FD  ACCT-REC RECORDING MODE F.
       01  ACCT-FIELDS.
           05 ACCT-NO        PIC 9(04).
           05 ACCT-NAME      PIC X(15).
           05 ACCT-SURNAME   PIC X(15).
           05 ACCT-BDATE     PIC 9(08).
           05 ACCT-TODAY     PIC 9(08).

      *Okumanin ve yazdirmanin basarili olup olmadigini kontrol etmek icin statu
       WORKING-STORAGE SECTION.
       01  WS-WORK-AREA.
           05 PRT-ST   PIC 9(02).
              88 PRT-SUCCESS VALUE 00 97.
           05 ACCT-ST   PIC 9(02).
              88 ACCT-EOF     VALUE 10.
              88 ACCT-SUCCESS VALUE 00 97.
           05 WS-INT-D PIC 9(07).
           05 WS-INT-T PIC 9(07).

      *------------------
       PROCEDURE DIVISION.
      *------------------

      *Mainde isletilecek alt programlar(paragraflar) tanimlandi.
       0000-MAIN.
           PERFORM H100-OPEN-FILES.
           PERFORM H200-PROCESS UNTIL ACCT-EOF.
           PERFORM H999-PROGRAM-EXIT.
      *Dosyalarin acilamama ve okunamama durumunu kontrol ettik.
       H100-OPEN-FILES.
           OPEN INPUT  ACCT-REC.
           IF (ACCT-ST NOT = 0) AND (ACCT-ST NOT = 97)
              DISPLAY 'UNABLE TO OPEN FILE: ' ACCT-ST
              MOVE ACCT-ST TO RETURN-CODE
              PERFORM H999-PROGRAM-EXIT
           END-IF.
           OPEN OUTPUT PRINT-LINE.
           IF (PRT-ST NOT = 0) AND (ACCT-ST NOT = 97)
              DISPLAY 'UNABLE TO OPEN FILE: ' PRT-ST
              MOVE PRT-ST TO RETURN-CODE
              PERFORM H999-PROGRAM-EXIT
           END-IF.
           READ ACCT-REC.
           IF (ACCT-ST NOT = 0) AND (ACCT-ST NOT = 97)
              DISPLAY 'UNABLE TO READ FILE: ' ACCT-ST
              MOVE ACCT-ST TO RETURN-CODE
              PERFORM H999-PROGRAM-EXIT
           END-IF.
       H100-END.EXIT.
      *
       H200-PROCESS.
      *ACCT-BDATE tarihini tam sayiya donusturur.
           COMPUTE WS-INT-D = FUNCTION INTEGER-OF-DATE(ACCT-BDATE).
      *ACCT-TODAY tarihini tam sayiya donusturur.
           COMPUTE WS-INT-T = FUNCTION INTEGER-OF-DATE(ACCT-TODAY).
           DISPLAY PRT-NAME.
           DISPLAY PRT-BDATE.
           INITIALIZE PRINT-REC.
           MOVE ACCT-NO TO PRT-NO.
           MOVE ACCT-NAME TO PRT-NAME.
           MOVE ACCT-SURNAME TO PRT-SURNAME.
           MOVE ACCT-BDATE TO PRT-BDATE.
           MOVE ACCT-TODAY TO PRT-TODAY.
      *Today ile dogum tarihi arasindaki fark bulunur.
           COMPUTE PRT-DIFF = WS-INT-T - WS-INT-D.
      *Id ile PRT-NAME arasina bosluk atmak icin kullandik.
           MOVE SPACES TO PRINT-REC(5:2).
           WRITE PRINT-REC.
           READ ACCT-REC.
       H200-END.EXIT.
      *Dosya kapama islemi
       H300-CLOSE-FILES.
           CLOSE ACCT-REC
                 PRINT-LINE.
       H300-END.EXIT.
      *Program bitis islemi
       H999-PROGRAM-EXIT.
           PERFORM H300-CLOSE-FILES.
           STOP RUN.
       H999-END.EXIT.

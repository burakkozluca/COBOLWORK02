//CBLWRK2 JOB 1,NOTIFY=&SYSUID
//***************************************************/
//* Copyright Contributors to the COBOL Programming Course
//* SPDX-License-Identifier: CC-BY-4.0
//***************************************************/
//CBLWRK2 EXEC IGYWCL
//COBOL.SYSIN  DD DSN=&SYSUID..CBL(CBLWRK2),DISP=SHR
//LKED.SYSLMOD DD DSN=&SYSUID..LOAD(CBLWRK2),DISP=SHR
//***************************************************/
// IF RC < 5 THEN
//***************************************************/
//RUN     EXEC PGM=CBLWRK2
//STEPLIB   DD DSN=&SYSUID..LOAD,DISP=SHR
//ACCTREC   DD DSN=&SYSUID..QSAM.BB,DISP=SHR
//PRTLINE   DD DSN=&SYSUID..QSAM.CC,DISP=(MOD,CATLG,DELETE),
//             SPACE=(CYL,(10,5))
//SYSOUT    DD SYSOUT=*,OUTLIM=15000
//CEEDUMP   DD DUMMY
//SYSUDUMP  DD DUMMY
//***************************************************/
// ELSE
// ENDIF

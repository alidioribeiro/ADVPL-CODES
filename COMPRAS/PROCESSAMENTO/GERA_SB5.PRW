#include "Rwmake.ch"
#include "Topconn.ch"     
#include "Colors.ch"      

//Programa para Incluir os Itens do SB1 que não estão no SB5.
//

User Function GERA_SB5()
Local oFont31 := TFont():New("Arial",,-20,.T.,.T.)
Local oFont32 := TFont():New("Arial",,-50,.T.,.T.)
//cPerg :="ACTSB7"
//aRegs := {}        
//ValidPerg(aRegs,cPerg)
//Pergunte(cPerg,.F.)
  @ 96,042 TO 290,505 DIALOG oDlg5 TITLE "Inclui Produtos em Dados Complementares." 
  @ 08,010 TO 84,222 
  @ 08,099 TO 84,222 
  @ 60,101 TO 82,220
  //@ 65,108 BMPBUTTON TYPE 5 ACTION Pergunte(cPerg)
  @ 65,148 BMPBUTTON TYPE 1 ACTION   Processa({||fRun()}, " Inclui Produtos Dados Complem.",".....")  
  @ 65,188 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
  @ 13,100 SAY "NIPPON"  OBJECT oItem1 SIZE 150,40  
  oItem1:oFont    := oFont32                        
  oItem1:nClrText := CLR_BLUE
  @ 43,102 SAY "SEIKI DO BRASIL LTDA."  OBJECT oItem2 SIZE 150,40  
  oItem2:oFont    := oFont31                        
  oItem2:nClrText := CLR_BLUE

  @ 13,014 SAY "Rotina que inclui os Produtos    " 
  @ 23,014 SAY "na Tabela de Dados Complementares"
  @ 33,014 SAY "                                 "
  @ 43,014 SAY "                                 "
  @ 53,014 SAY "                          "
  ACTIVATE DIALOG oDlg5 CENTERED

Return 
//
//
************************************************************************************************************************************
Static Function fRun() 
************************************************************************************************************************************
Private nSaldo,nMedio,aSaldo    

cQuery := " "
cQuery += " SELECT B1_FILIAL,B1_COD,B1_DESC  "
cQuery += " FROM "+RetSqlName("SB1")+" "
cQuery += " WHERE D_E_L_E_T_ <> '*' "
cQuery += " AND NOT EXISTS( SELECT * FROM "+RetSqlName("SB5") +" WHERE D_E_L_E_T_ <> '*' "
cQuery += " AND B1_FILIAL+B1_COD = B5_FILIAL+B5_COD "

cQuery := ChangeQuery(cQuery)
TCQUERY cQuery Alias SB5TMP New 

dbSelectArea("SB5TMP")
dbGoTop()      
nRegs := 0
Do While !Eof()
  
   nRegs++
   dbSkip()
Enddo
//
dbgotop()
ProcRegua(nRegs) 
//

SB5TMP->(Dbgotop())
Do While !SB5TMP->(Eof())
   //
   IncProc("Incluindo Produtos Em Dados Complementares item: "+ SB5TMP->B1_COD)                             
   //
   dbSelectArea("SB5")	
   dbsetorder(1)
   If !dbSeek(xFilial("SB5")+ SB5TMP->B1_COD)
      RecLock("SB5", .T.)		    
   	  SB5->B5_FILIAL := SB5TMP->B1_FILIAL
  	  SB5->B5_COD    := SB5TMP->B1_COD
   	  SB5->B5_CEME   := SB5TMP->B1_DESC
      MsUnlock()
   Endif
   //
   SB5TMP->(dbSkip())
Enddo
//
SB5TMP->(dbClosearea())

MSGINFO(OemToAnsi("Total de registros Incluidos: "+strzero(nRegs,9)))
//
Return NIl

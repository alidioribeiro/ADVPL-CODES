#include "rwmake.ch" 
#Include "TOPCONN.CH"
#Include "TBICONN.CH" 


User Function RatOff()                          
Private DataRef:="      " // Incluida pela Aglair

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RatOff   ³ Autor ³ JORGE SILVEIRA        ³ Data ³ 02.06.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Acerta quantidade final nos SB2, conforme quantidade e     ³±±
±±³          ³ valores informados nos saldos iniciais, SB9.               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
@ 96,42 TO 323,505 DIALOG oDlg5 TITLE "Rateio Off-Line"
@ 8,10 TO 84,222
@ 91,168 BMPBUTTON TYPE 1 ACTION OkProc()
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
@ 23,14 SAY "Esta rotina tem como objetivo, transferir os percentuais de rateio"
@ 33,14 SAY "informados para Cod. de Rateio ALIMEN, para os demais Códigos de"
@ 43,14 SAY "rateio off-line."
@ 53,14 SAY "Data de Referência(mmaaaa)" 
@ 53,90 Get DataRef  //  PICTURE "@999999" 
@ 63,14 SAY ""
ACTIVATE DIALOG oDlg5

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³OkProc    ³ Autor ³ JORGE SILVEIRA        ³ Data ³ 27.10.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Confirma o Processamento                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

Static Function OkProc()
Close(oDlg5)

Processa( {|| RunProc() } )

  dbSelectArea("CTQ")
  RetIndex("CTQ")

  If !(Type('ArqNtx') == 'U')
     fErase(cArqNtx)
  Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RunProc   ³ Autor ³ JORGE SILVEIRA        ³ Data ³ 27.10.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Executa o Processamento                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

Static Function RunProc()

dbSelectArea("CTQ")
cArqNtx  := CriaTrab(NIL,.f.)
cIndCond := 'CTQ_CCCPAR + CTQ_RATEIO'
IndRegua('CTQ',cArqNtx,cIndCond,,,'Selecionando Registros...')
           
ProcRegua(RecCount())
dbGotop()

While !Eof()

      IncProc()
      
      If ( AllTrim(CTQ_Rateio) =="MOTEMP" .or.  AllTrim(CTQ_Rateio)=="OGLUZF") .Or. CTQ_MSBLQL == "2" 
         dbSkip()
         Loop
      End   

      xCCusto := CTQ_CCCPAR
      xPercen := CTQ_Percen
      
      While !Eof() .And. xCCusto == CTQ_CCCPAR
            
  		   If AllTrim(CTQ_Rateio) == "MOTEMP"  .or. AllTrim(CTQ_Rateio)=="OGLUZF" .Or. CTQ_MSBLQL == "2" 
        	 dbSkip()
	         Loop
     	   End     

            RecLock("CTQ",.F.)
            CTQ->CTQ_Percen := xPercen
	        CTQ->(MsUnlock())
            dbSkip()
            
      EndDo      
                           
EndDo                 
 DataRef:=Substr(DataRef,3,4)+Substr(DataRef,1,2)
 QtdR:=U_AtuCCMovCT2(DataRef)
 Alert("Foram atualizados "+Alltrim(Str(QtdR))+" registros de movimentação Contabil")
Return
//************************************************************************************************/
User Function AtuCCMovCT2(DataRef)
Local Qtd:=0   
cQuery:=" SELECT * FROM CT2010 "
cQuery+=" WHERE ((SUBSTRING(CT2_DEBITO,1,2)='39' AND CT2_CCD<>'121') OR "	
cQuery+="       (SUBSTRING(CT2_CREDIT,1,2)='39'AND CT2_CCC<>'121')  ) AND "
cQuery+="  SUBSTRING(CT2_DATA,1,6)  ='"+DataRef+"' AND "
cQuery+="  D_E_L_E_T_=''  "
TcQuery cQuery New Alias TRB
DbSelectArea("TRB")
DbGotop()
While !Eof()
    DbSelectArea("CT2")
    Dbgoto(TRB->R_E_C_N_O_)
    RecLock("CT2",.F.)
    If Substr(CT2_DEBITO,1,2)='39'
      CT2->CT2_CCD := '121' //C.Custo 121 - Administração Geral
    EndIf  
    if Substr(CT2_CREDITO,1,2)='39'  
      CT2->CT2_CCC := '121'
	EndIf
    CT2->(MsUnlock())
	qtd++
	DbSelectArea("TRB")
	DbSkip()
End
DbSelectArea("TRB")
DbCloseArea()
REturn Qtd
//************************************************************************************************/

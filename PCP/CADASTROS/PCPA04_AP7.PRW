#include "rwmake.ch"  

User Function PCPA04()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CSTRING,_CPERG,CARQTXT,NHDLARQ")
SetPrvt("_CGRAVA,XMODELO,XLINHA,XI,XQTD")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01  C  9   // Da OP                                   ³
//³ mv_par02  C  9   // Até a OP                                ³
//³ mv_par03  N  8   // Da Data                                 ³
//³ mv_par04  N  8   // Até a Data                              ³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cString := "SC2"
_cPerg  := "PCPA04"
Pergunte(_cPerg,.T.)

@ 96,42 TO 323,505 DIALOG oDlg5 TITLE "Encerra Ordens de Produção"
@ 08,10 TO 84,222
@ 91,139 BMPBUTTON TYPE 5 ACTION Pergunte(_cPerg)
@ 91,168 BMPBUTTON TYPE 1 ACTION OkProc()
@ 91,196 BMPBUTTON TYPE 2 ACTION oDlg5:End()
@ 23,14 SAY "Este programa tem como objetivo zerar os empenhos e encerrar"
@ 33,14 SAY "as Ordens de Produção Abertas em um período determinado nos"
@ 43,14 SAY "Parâmetros."
@ 53,14 SAY ""
ACTIVATE DIALOG oDlg5

Return nil

Static Function OkProc()
   Processa( { || RunProc() }, "Cancelando Empenhos...")
   oDlg5:End()
Return


Static Function RunProc()
   dMes := GetMV("MV_ULMES") 
   DbSelectArea("SC2")
   DbSetOrder(1)
   DbSeek(xFilial("SC2")+MV_PAR01,.T.) 
   ProcRegua(RecCount())
   While !SC2->(Eof()) .And. SC2->(C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN)<=xFilial("SC2")+MV_PAR02
         IncProc("OP: "+C2_NUM+"-"+C2_ITEM+"-"+C2_SEQUEN)
         If dtos(C2_DATPRF)<dtos(MV_PAR03) .or. dtos(C2_DATPRF)>dtos(MV_PAR04) .or. !Empty(C2_DATRF)
            DbSkip()
            Loop
         EndIf
         RecLock("SC2",.F.)
         SC2->C2_DATRF := dDataBase
         msUnlock()
 /*      nQtd := c2_quant-c2_quje
         If c2_sequen=="001"
            GravaSB2(SC2->C2_PRODUTO,"01",SC2->C2_SEQUEN,nQtd)
         endif          */
         GravaSD4(SC2->C2_NUM  ,SC2->C2_ITEM  ,SC2->C2_SEQUEN)   
         DbSelectArea("SC2")
         DbSkip()
   EndDo
Return

Static Function GravaSD4(xNum,xItem,xSeq)
   DBSelectArea("SD4")
   DbSetOrder(2) 
   DbSeek(xFilial("SD4")+xNum+xItem+xSeq)
   cOP := xFilial("SD4")+xNum+xItem+xSeq
   While !SD4->(Eof()) .And. Alltrim(SD4->(D4_FILIAL+D4_OP))==cOP
         nQuant := SD4->D4_QUANT
         nRecno:= Recno()
         RecLock("SD4",.F.)
         SD4->D4_QUANT   := 0
         msUnlock()
         GravaSB2(SD4->D4_COD,"10",xSeq,nQuant) 
         dbSelectArea("SD4")
         DbGoto(nRecno)
         dbskip()
         
   EndDo	   
Return

Static Function GravaSB2(cProd,cLoc,cTipo,nQuant)
   DbSelectArea("SB2")
   DbSetorder(1)
   if !DbSeek(xFilial("SB2")+cProd+cLoc)
      CriaSB2(cProd,cLoc)               
   Endif  	
   RecLock("SB2",.F.)
   SB2->B2_SALPEDI := IIF(SB2->B2_SALPEDI - nQuant > 0 , SB2->B2_SALPEDI - nQuant , SB2->B2_SALPEDI )
   SB2->B2_QEMP    := IIF(SB2->B2_QEMP    - nQuant > 0 , SB2->B2_QEMP    - nQuant , SB2->B2_QEMP    )
   MsUnlock()
Return

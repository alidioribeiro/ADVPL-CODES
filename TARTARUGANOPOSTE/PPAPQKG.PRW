#include "rwmake.ch"        
#INCLUDE "Protheus.ch"
#include "ap5mail.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

//**** Inclui Atividades no Cadastro de Cronograma ***/

User Function PPAPQKG()    

cCod    := M->QKG_PECA
cRev    := M->QKG_REV
cResp   := M->QKG_RESP
cData   := M->QKG_DATA 
cCodLig := M->QKG_CHAVE
//
//msginfo(dtos(cData))
//
cAlias := Select()
nOrder := IndexOrd(cAlias)
lRet    := .T.
aAtiv   := {}
i       := 0                                 
// Seleciona as atividades
cQuery:=" SELECT * FROM QKZ010 "
cQuery+=" WHERE LEN(QKZ_COD)=6 AND D_E_L_E_T_<>'*' "
cQuery+=" ORDER BY QKZ_COD "

TCQUERY cQuery NEW ALIAS "TRB"
ListQtdDoc:={}

DbSelectArea("TRB")                                                        
DbGotop()
While !Eof()
	AAdd(aAtiv,{TRB->QKZ_COD, TRB->QKZ_DESC})
    DbSkip()	
EndDo 

DbSelectArea("TRB")
TRB->(DbCloseArea())
DbSelectArea(cAlias)

If  len(aAtiv) = 0
	MsgStop("Nao Ha atividades cadastrada !")
	lRet := .F.
Endif 
//                
If lRet   
   For i:=1 to Len(aAtiv)         
       aCols[Len(aCols),1] := "ENABLE" // Legenda
       aCols[Len(aCols),02] := Strzero(i,3) // Sequencia
       aCols[Len(aCols),03] := aAtiv[i,1] // Codigo da Atividade
       aCols[Len(aCols),04] := aAtiv[i,2] // Desc Atividade
       aCols[Len(aCols),05] := Space(06)
       aCols[Len(aCols),06] := ""
       aCols[Len(aCols),07] := CTOD("//") 
       aCols[Len(aCols),08] := CTOD("//")       
       aCols[Len(aCols),09] := CTOD("//")
       aCols[Len(aCols),10] := CTOD("//")       
       aCols[Len(aCols),11] := "0"
       aCols[Len(aCols),12] := "obs        " //Space(11)
       aCols[Len(aCols),13] := cCodLig
       aCols[Len(aCols),14] := "N"
       aCols[Len(aCols),15] := "VM"
       aCols[Len(aCols),16] := "VM"              
       aCols[Len(aCols),17] := .F.                                                     
       if i<len(aAtiv)
          aadd(aCols, ARRAY(17)) 
       endif
   Next
   oGet:refresh()
Endif        
//         
DbselectArea(cAlias)                                      
DbSetOrder(nOrder)
Return(cData)
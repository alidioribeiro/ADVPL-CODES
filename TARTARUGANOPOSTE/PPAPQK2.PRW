#include "rwmake.ch"        
#INCLUDE "Protheus.ch"
#include "ap5mail.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

//**** Inclui Itens da Estrutura na Tabela de Pecas (QK2) ***/
	User Function PPAPQK2()    

cCod := M->QK1_PECA
cRev := M->QK1_REV     
cPCCLI := M->QK1_PCCLI
cAlias := Select()
nOrder := IndexOrd(cAlias)
lRet    := .T.
aStru   := {}
nEstru  := 0
i       := 0                                 

aStru := Estrut(aLLTRIM(cCod))  // Obtem a estrutura

//aSort( asTRU ,,, {|x,y| x[1] < y[1]})

If  len(aStru) = 0
	MsgStop("Este Código não possui Estrutura!")
	lRet := .F.
Endif 

If lRet  
 
   For i:=1 to Len(aStru)         
       cNivel := If(Val(aStru[i,5])>1,Replicate(".",Val(aStru[i,5])),"")+Alltrim(aStru[i,5])
       aCols[Len(aCols),1] := strzero(i,4) // Item
       aCols[Len(aCols),2] := Alltrim(str(i,4))+"("+cNivel+")"
       aCols[Len(aCols),3] := aStru[i,3] // Codigo Produto
       aCols[Len(aCols),4] := Posicione("SB1",1,xFilial("SB1")+aStru[i,3],"B1_DESC") // Descricao
	   aCols[Len(aCols),5] := Space(50)
       aCols[Len(aCols),6] := " " // Tipo de Caracter - 1>Dimensional,2>Material,3>Desempenho,
	   aCols[Len(aCols),7] := space(13) // Tolerancia
	   aCols[Len(aCols),8] := Space(13) // LIE
	   aCols[Len(aCols),9] := Space(13) // LSE
	   aCols[Len(aCols),10] := Space(02) // Simbolo
       aCols[Len(aCols),11] := " " // 1>Produto,2>Processo
       aCols[Len(aCols),12] := " " // P.Controle 1>Sim/2>Nao
       aCols[Len(aCols),13] := "1" // Especial 1>Sim  /2>Nao
       aCols[Len(aCols),14] := Posicione("SB1",1,xFilial("SB1")+aStru[i,3],"B1_UM") // UM         
   	   aCols[Len(aCols),15] := Left(aStru[i,3],8) // Cod. Ligacao
       aCols[Len(aCols),16] := .F.                                                     
       if i<len(aStru)
          aadd(aCols, ARRAY(16)) 
       endif
   Next
   oGet:refresh()
Endif
DbselectArea(cAlias)
DbSetOrder(nOrder)
Return(cPCCLI)
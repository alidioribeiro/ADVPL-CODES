#include "rwmake.ch"        
#INCLUDE "Protheus.ch"
#include "ap5mail.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

//**** Inclui Itens da Estrutura na Tabela de Pecas (QK2) ***/
User Function PegaDepMat()    

Local _cChave := ""
Local _aUser := {}

PswSeek(__cUserId)
_aUser := PswRet()
//_cChave := xFilial("SRA") + SubStr(_aUser[1][22],5,6)) // Aqui sem Aspas
Return(_cChave) 
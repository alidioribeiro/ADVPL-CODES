#INCLUDE "URZUM.CH"

//+-----------------------------------------------------------------------------------//
//|Empresa...: aFill Tecnologia
//|Funcao....: U_A140EXC()
//|Autor.....: aFill Tecnologia - suporte@afill.com.br
//|Data......: 20 de Fevereiro de 2008, 08:00
//|Uso.......: SIGACOM
//|Versao....: Protheus - 10
//|Descricao.: PE para valida��o da exclus�o da Nota
//|Observa��o:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function A140EXC()
*-----------------------------------------*

Local lRet := .T.

If !Empty(SF1->F1_HAWB) .AND. Alltrim(FunName()) <> "DSBBROW"
	MsgStop("NF n�o pode ser excluida pois foi gerada pelo Controle Geral (Importa��o). Exclua a NF pela Op��o de Importa��o \ Controle Geral...","Sem acesso")
	lRet := .F.
EndIf

Return(lRet)

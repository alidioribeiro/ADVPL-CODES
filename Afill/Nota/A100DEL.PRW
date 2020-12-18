#INCLUDE "URZUM.CH"

//+-----------------------------------------------------------------------------------//
//|Empresa...: aFill Tecnologia
//|Funcao....: U_A100DEL()
//|Autor.....: aFill Tecnologia - suporte@afill.com.br
//|Data......: 20 de Fevereiro de 2008, 08:00
//|Uso.......: SIGACOM
//|Versao....: Protheus - 10
//|Descricao.: PE para validação da exclusão da Pré-Nota
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function A100DEL()
*-----------------------------------------*

Local lRet := .T.

If !Empty(SF1->F1_HAWB) .AND. Alltrim(FunName()) <> "DSBBROW"
	MsgStop("NF não pode ser excluida pois foi gerada pelo Controle Geral (Importação). Exclua a NF pela Opção de Importação \ Controle Geral...","Sem acesso")
	lRet := .F.
EndIf

Return(lRet)

#INCLUDE "URZUM.CH"
//+-----------------------------------------------------------------------------------//
//|Empresa...: aFill Tecnologia
//|Funcao....: U_MT120LEG
//|Autor.....: aFill Tecnologia - suporte@afill.com.br
//|Data......: 06 de janeiro de 2014, 11:00
//|Uso.......: SIGACOM
//|Versao....: Protheus
//|Descricao.: PE para inclus�o de legenda a descri��o da Legenda
//|Observa��o:4
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function MT120LEG()
*-----------------------------------------*

Local aRet := U_UzxPCBrow("MT120LEG",PARAMIXB[1])

Return(aRet)
#INCLUDE "Protheus.ch"   
#INCLUDE "rwmake.ch"  

//
// Autor: Wagner da Gama Corrêa
// Descrição: Na tela de firmar ordens de produção, filtra quais usuários podem firmar ops por centro  de custo
//
User Function MA651FIL

Local _cFiltro := PARAMIXB[01]
_cCusto := ""

_cUsuario  := __cUserID

_cCusto += IIF( _cUsuario $ GetMv("MV_XOP211"), "211", "")
_cCusto += IIF( _cUsuario $ GetMv("MV_XOP221"), "221", "")
_cCusto += IIF( _cUsuario $ GetMv("MV_XOP231"), "231", "")
_cCusto += IIF( _cUsuario $ GetMv("MV_XOP241"), "241", "")
_cCusto += IIF( _cUsuario $ GetMv("MV_XOP251"), "251", "")

If !(_cUsuario $ "000000")
	_cFiltro += " .AND. AllTrim(C2_CC) $ '" + _cCusto + "' "
EndIf

Return _cFiltro
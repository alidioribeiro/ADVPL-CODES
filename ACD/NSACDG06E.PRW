#include "protheus.ch"
#include "apvt100.ch"

//
//
User Function ACDG06E()
Local cEtiqueta
Local aTela := Vtsave()
Private cCodOpe :=CBRetOpe()

If Empty(cCodOpe)
	VTAlert("Operador nao cadastrado" + cCodOpe,"Aviso",.T.,3000) //"Operador nao cadastrado"###"Aviso"
	Return .F.
EndIf

//VTAlert("Operador " + cCodOpe ,"Aviso",.T.,3000) //"Operador nao cadastrado"###"Aviso"

While .t.
	cEtiqueta := Space(20)
	VtClear
	@ 0,0 VTSay 'Quebra  de '
	@ 1,0 VTSay 'Etiquetas  '
	@ 3,0 VTSay 'Leitura da Etiqueta'
	@ 4,0 VTGet cEtiqueta Pict "@!" Valid ValidEtq(cEtiqueta)
	VTRead
	If VtLastKey() == 27
		Exit
	Endif
Enddo
VTRestore(,,,,aTela)
Return .t.
//
//
Static Function ValidEtq(cEtiqueta)
Local aTela
Local nQuant
Local aEtiqueta

If Empty(cEtiqueta)
	Return .f.
EndIf

aEtiqueta := CBRetEti(cEtiqueta,"01")

If Empty(aEtiqueta)
	VTALERT("Etiqueta invalida.","Aviso",.T.,3000,2) //"Etiqueta invalida."###"Aviso"
	VTKeyBoard(chr(20))
	Return .f.
EndIf

If aEtiqueta[2] == 1
	VTALERT("Etiqueta com quantidade == 1","Aviso",.T.,3000,2) //"Etiqueta com quantidade == 1"###"Aviso"
	VTKeyBoard(chr(20))
	Return .f.
EndIf

If ! Empty(CB0->CB0_PEDCOM)
	SC7->(DbSetOrder(1))
	If ! SC7->(DbSeek(xFilial()+CB0->CB0_PEDCOM))
		VTALERT("Pedido nao encontrado","Aviso",.T.,4000,2) //"Pedido nao encontrado"###"Aviso"
		VTKeyBoard(chr(20))
		Return .f.
	EndIf
EndIf

aTela := VtSave()
nQuant := 0
@ 3,0 VTSay 'Digite a Quantidade'
@ 4,0 VTGet nQuant    Pict CBPictQtde() Valid ValidQuant(nQuant,aEtiqueta[2])
VTRead
VtRestore(,,,,aTela)
If VtLastKey() == 27
	VTKeyBoard(chr(20))
	Return .F.
Endif
If VTYesNo('Confirma a Geracao da Nova Etiqueta','Atencao',.t.) //'Confirma a Geracao da Nova Etiqueta'###'Atencao'
	ImpEti(nQuant, cEtiqueta)
EndIf
Return .T.

Static Function ValidQuant(nQuant,nQuantOri)
If nQuant == 0 .OR. nQuant >= nQuantOri
	VTALERT("Quantidade invalida","Aviso",.T.,3000,2) //"Quantidade invalida"###"Aviso"
	VTKeyBoard(chr(20))
	Return .f.
Endif
Return
//
//
Static Function ImpEti(nQuant, _cEtiqueta)
Local cCodEtiOri := 0 //Space(Len(CB0->CB0_CODETI))
Local nRecnoOri  := 0
Local nRecnoNew  := 0 //CB0->(Recno())


dbSelectArea("CB0")
CB0->(dbSetorder(1))
CB0->(dbSeek(xFilial("CB0")+ _cEtiqueta ))
cCodEtiOri := _cEtiqueta
nRecnoOri  := RECNO()
//
//VTAlert('id:'+_cEtiqueta,'Aviso',.t.,3000,3)
//
If UPPER(Left(cCodOpe,3)) $ "SEP/CQR"
	IF UPPER(cCodOpe) $ "SEP010#SEP011#" //'ia
		IF !CB5SetImp(CBRLocImp("MV_IACD05"),IsTelNet())
			VTAlert('Local de impressao nao configurado, MV_IACD05','Aviso',.t.,3000,3) //'Local de impressao nao configurado, MV_IACD02'###'Aviso'
			Return
		EndIf 
	ELSEIF UPPER(cCodOpe) $ "SEP006" 
		//VTAlert(cCodOpe)
		IF !CB5SetImp(CBRLocImp("MV_IACD06"),IsTelNet())
			VTAlert('Local de impressao nao configurado, MV_IACD06','Aviso',.t.,3000,3) //'Local de impressao nao configurado, MV_IACD02'###'Aviso'
			Return
		EndIf	
	ELSE
		IF !CB5SetImp(CBRLocImp("MV_IACD05"),IsTelNet())
			VTAlert('Local de impressao nao configurado, MV_IACD05','Aviso',.t.,3000,3) //'Local de impressao nao configurado, MV_IACD02'###'Aviso'
			Return
		EndIf
	ENDIF
Else
	IF !CB5SetImp(CBRLocImp("MV_IACD02"),IsTelNet())
		VTAlert('Local de impressao nao configurado, MV_IACD02','Aviso',.t.,3000,3) //'Local de impressao nao configurado, MV_IACD02'###'Aviso'
		Return
	EndIf
Endif

VTMsg("Imprimindo...")

//CB0->(DbGoto(nRecnoCB0))
//cCodEtiOri  := CB0->CB0_CODETI

cCodEtiProx := CBProxCod("MV_CODCB0")

/*****
Alterado EM: 21/02/2013 por Alex Almeida
Copia registro para gerar nova etiqueta,
modificado devido ao erro gerado pela função
CBCopyRec() na versão Proteus 11
INICIO
*****/

aCampos := {}
dbSelectArea("CB0")
For nCampo:=1 to FCount()
	If FieldName(nCampo) == "CB0_CODETI"
		aadd(aCampos, cCodEtiProx)
	ElseIf FieldName(nCampo) == "CB0_QTDE"
		aadd(aCampos, nQuant)
	Else
		aadd( aCampos, FieldGet(nCampo))
	Endif
Next
//
//
RecLock("CB0",.T.)
For nX := 1 to Len(aCampos)
	FieldPut(nX, aCampos[nX])
Next
MsUnlock()
//
/*****
Alterado EM: 21/02/2013 por Alex Almeida
Copia registro para gerar nova etiqueta,
modificado devido ao erro gerado pela função
CBCopyRec() na versão Proteus 11
FIM
*****/
//
//
nRecnoNew := CB0->(Recno())
//
//nRecno      := CB0->(CBCopyRec())	 // erro na versao 11
//CB0->(DbGoto(nRecno))
//CB0->CB0_CODETI := _cCodEti  //CBProxCod("MV_CODCB0")
//
SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial("SB1")+CB0->CB0_CODPRO))
If ExistBlock('IMG01')
	//VTAlert("img01","debug",.T.,3000)   //"Operador nao cadastrado"###"Aviso"
	ExecBlock("IMG01",,,{,,CB0->CB0_CODETI})
EndIf
//If ExistBlock('IMG00')
//	ExecBlock("IMG00",,,{"U_ACDG06E"})
//EndIf
//
//Gravacao do log da nova etiqueta gerada:
//
CbLog("07",{CB0->CB0_CODPRO,CB0->CB0_QTDE,CB0->CB0_LOTE,CB0->CB0_SLOTE,CB0->CB0_LOCAL,CB0->CB0_LOCALI,CB0->CB0_OP,CB0->CB0_CODETI,cCodEtiOri,NIL})
//
//
dbSelectArea("CB0")
CB0->(dbSetorder(1))
CB0->(dbSeek(xFilial("CB0")+ cCodEtiOri ))
//
Reclock("CB0",.F.)
CB0->CB0_QTDE := CB0->CB0_QTDE - nQuant
CB0->(MSUnlock())
//
/* ALTERADO PARA REIMPRIMIR ETIQ. ORIGINAL COM QTD. ATUALIZADA
SOMENTE PARA EXPEDICAO CONFORME REUNIAO EM: 07/08/13 COM
WALDIR, SR. FRANCISCO, RAINEY, SOUZA E ALEX.
*/
//If Left(Upper(Alltrim(cUserName)),3) == "EXP"


// Alidio - bruno    19/08/2020   antes  era EXP e SEP 

//If Left(Upper(Alltrim(cUserName)),3) == "EXP" .OR. Left(Upper(Alltrim(cUserName)),3) == "XXX" 
	
If VTYesNo('ETIQ. ORIGINAL COM QTD. ATUALIZADA?','Atencao',.t.) 	
	//ALTERADO POR ALEX EM: 24/07/2013 PARA GERAR A ETIQUETA MODIFICADA
	If ExistBlock('IMG01')
		ExecBlock("IMG01",,,{,,CB0->CB0_CODETI})
	EndIf
Endif


//
//If ExistBlock('IMG00')
//	ExecBlock("IMG00",,,{"U_ACDG06E"})
//EndIf
//VTAlert("img01","SEGUNDA",.T.,3000)   //"Operador nao cadastrado"###"Aviso"
//ALTERADO POR ALEX EM: 24/07/2013 PARA GERAR A ETIQUETA MODIFICADA
//
MSCBCLOSEPRINTER()
Return

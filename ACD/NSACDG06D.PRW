#include "protheus.ch"
#include "apvt100.ch"

//
//
User Function ACDG06D()
	Local cEtiqueta
	Local aTela := Vtsave()
	//
	// Alterado para suprir a necessidade de injecao plastica em função da
	// imprevisibilidade da quantidade a ser produzida.
	// BY ALEX
	If !Posicione('CB1', 2, xfilial('CB1') + __cuserid, 'CB1_CODOPE') $ "SEP001/SEP002/SEP003/SEP007/SEP006/SEP010/SEP011/SEP012"
		vtalert("Rotina desabilitada!")		
		Return(.F.)
	Endif
	// Alterado para suprir a necessidade de injecao plastica em função da
	// imprevisibilidade da quantidade a ser produzida.
	// BY ALEX
	//
	//
	While .t.	
		cEtiqueta := Space(20)
		VtClear
		@ 0,0 VTSay "    Alteração   "
		@ 1,0 VTSay "  de Etiquetas  "
		@ 3,0 VTSay "Leia a etiqueta:"
		@ 4,0 VTGet cEtiqueta Pict "@!" Valid ValidEtiq(cEtiqueta)	
		VTRead		
		If VtLastKey() == 27
			Exit
		Endif
	Enddo                   
	VTRestore(,,,,aTela)
Return(.t.)
//
//
Static Function ValidEtiq(cEtiqueta)
	Local aTela       
	Local nQuant
	Local aEtiqueta

	If Empty(cEtiqueta)
		Return .f.
	EndIf

	cLocal := Posicione('CB0', 1, xfilial('CB0') + cEtiqueta , 'CB0_LOCAL')
	If Alltrim(cLocal) == "20"
		VTALERT("Nao e permitido alterar Qtd. no armazem: "+cLocal,"Aviso",.T.,3000,2)
		Return(.f.)
	Endif 

	aEtiqueta := CBRetEti(cEtiqueta,"01")

	If Empty(aEtiqueta)
		VTALERT("Etiqueta invalida.","Aviso",.T.,3000,2) //###
		VTKeyBoard(chr(20))
		Return .f.
	EndIf
	//
	aTela := VtSave()
	nQuant := 0
	@ 1,0 VTSay "Qtd. Atual da Etiq." 
	@ 2,0 VTSay Transform(aEtiqueta[2], CBPictQtde())
	@ 3,0 VTSay "Qtd. Desejada     ?" 
	@ 4,0 VTGet nQuant    Pict CBPictQtde() Valid ValidQuant(nQuant)	
	VTRead  	 
	VtRestore(,,,,aTela)
	If VtLastKey() == 27
		VTKeyBoard(chr(20))
		Return .F.
	Endif
	//
	If VTYesNo("Confirma alteração ?","Atenção",.t.) //'Confirma a Geracao da Nova Etiqueta'###'Atencao'
		Imprime(cEtiqueta, nQuant) 	   	
	EndIf
Return .T.
//
//
Static Function ValidQuant(nQuant)
	If nQuant == 0
		VTALERT("Quantidade inválida","Aviso",.T.,3000,2) //"Quantidade invalida"###"Aviso"
		VTKeyBoard(chr(20))
		Return .f.
	Endif	
Return
//
//
Static Function Imprime(cEtiqueta, nQuant)
	Private cCodOpe :=CBRetOpe()
	//

	IF UPPER(cCodOpe) $ "SEP006" 
		//VTAlert(cCodOpe)
		IF !CB5SetImp(CBRLocImp("MV_IACD06"),IsTelNet())
			VTAlert('Local de impressao nao configurado, MV_IACD06','Aviso',.t.,3000,3) //'Local de impressao nao configurado, MV_IACD02'###'Aviso'
			Return
		EndIf
	Else
		IF ! CB5SetImp(CBRLocImp("MV_IACD04"),IsTelNet())
			VTAlert('Local de impressao nao configurado, MV_IACD04','Aviso',.t.,3000,3)
			Return
		EndIf     
	EndIf
	//
	VTMsg("Imprimindo ...")
	//        
	CB0->(dbsetorder(1))
	CB0->(dbSeek(xFilial("CB0")+ cEtiqueta))
	RecLock("CB0",.F.)
	CB0->CB0_QTDE := nQuant
	CB0->(MsUnlock())
	//
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial()+CB0->CB0_CODPRO))
	ExecBlock("IMG01",,,{,,CB0->CB0_CODETI})
	ExecBlock("IMG00",,,{"U_ACDG06D"})
	MSCBCLOSEPRINTER()
	//
	//Gravacao do log da nova etiqueta gerada:
	CbLog("07",{CB0->CB0_CODPRO,CB0->CB0_QTDE,CB0->CB0_LOTE,CB0->CB0_SLOTE,CB0->CB0_LOCAL,CB0->CB0_LOCALI,CB0->CB0_OP,CB0->CB0_CODETI,CB0->CB0_CODETI,NIL})
	//
Return
#include "protheus.ch"
#include "apvt100.ch"

//
//
User Function ACDG06F()
Local cEtiqueta
Local aTela := Vtsave()

If Posicione('CB1', 2, xfilial('CB1') + __cuserid, 'CB1_CODOPE') <> "SEP008"
	vtalert("Rotina desabilitada!")		
	Return(.F.)
Endif

While .t.	
	cEtiqueta := Space(20)
	VtClear
	@ 0,0 VTSay "Transferir Etiq."
	@ 1,0 VTSay "p/ outro codigo."
	@ 3,0 VTSay "Leia a etiqueta:"
	@ 4,0 VTGet cEtiqueta Pict "@!" Valid ValidEtiq(cEtiqueta)	
	VTRead		
	If VtLastKey() == 27
	   Exit
	Endif
Enddo                   
VTRestore(,,,,aTela)
Return .t.
//
//
Static Function ValidEtiq(cEtiqueta)
Local aTela       
Local nQuant
Local aEtiqueta
Local cCodigo := Space(tamsx3('B1_COD')[1])

If Empty(cEtiqueta)
	Return .f.
EndIf
//           
cLocal := Posicione('CB0', 1, xfilial('CB0') + cEtiqueta , 'CB0_LOCAL')
If Alltrim(cLocal) == "20"
   VTALERT("Nao e permitido alterar codigo no armazem: "+cLocal,"Aviso",.T.,3000,2)
   Return(.f.)
Endif 
//
aEtiqueta := CBRetEti(cEtiqueta,"01")
If Empty(aEtiqueta)
	VTALERT("Etiqueta invalida.","Aviso",.T.,3000,2) //###
	VTKeyBoard(chr(20))
	Return .f.
EndIf
//
CB0->(dbsetorder(1))
CB0->(dbSeek(xFilial("CB0")+ cEtiqueta))
//
aTela := VtSave()
@ 1,0 VTSay "Cod. Atual da Etiq." 
@ 2,0 VTSay CB0->CB0_CODPRO
@ 3,0 VTSay "Codigo Desejado   ?" 
@ 4,0 VTGet cCodigo Pict "@!" Valid ValidCod(cCodigo)
VTRead  	 
VtRestore(,,,,aTela)
If VtLastKey() == 27
	VTKeyBoard(chr(20))
	Return .F.
Endif
//
If VTYesNo("Confirma alteração ?","Atenção",.t.) //'Confirma a Geracao da Nova Etiqueta'###'Atencao'
  	Imprime(cEtiqueta, cCodigo) 	   	
EndIf
Return .T.
//
//
Static Function ValidCod(_cCodigo)

SB1->(dbsetorder(1))
SB1->(dbSeek(xFilial('SB1')+ _cCodigo))

If !SB1->(Found())
	VTALERT("Codigo nao encontrado!","Aviso",.T.,3000,2)
	VTKeyBoard(chr(20))
	Return .f.

ElseIf SB1->B1_LOCPAD <> CB0->CB0_LOCAL
	VTALERT("Alteração permitida somente para itens do mesmo armazem!","Aviso",.T.,3000,2)
	VTKeyBoard(chr(20))
	Return .f.

ElseIf SB1->B1_MSBLQL == "1"
	VTALERT("Alteração permitida somente para itens desbloqueados!","Aviso",.T.,3000,2)
	VTKeyBoard(chr(20))
	Return .f.
Endif	
Return
//
//
Static Function Imprime(cEtiqueta, _cCodigo)
//
IF ! CB5SetImp(CBRLocImp("MV_IACD04"),IsTelNet())
	VTAlert('Local de impressao nao configurado, MV_IACD04','Aviso',.t.,3000,3)
	Return
EndIf     
//
VTMsg("Imprimindo ...")
//        
CB0->(dbsetorder(1))
CB0->(dbSeek(xFilial("CB0")+ cEtiqueta))
//
CbLog("07",{CB0->CB0_CODPRO,CB0->CB0_QTDE,CB0->CB0_LOTE,CB0->CB0_SLOTE,CB0->CB0_LOCAL,CB0->CB0_LOCALI,CB0->CB0_OP,CB0->CB0_CODETI,CB0->CB0_CODETI,NIL})
//
RecLock("CB0",.F.)
CB0->CB0_CODPRO := _cCodigo
CB0->(MsUnlock())
//
SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial()+CB0->CB0_CODPRO))
ExecBlock("IMG01",,,{,,CB0->CB0_CODETI})
ExecBlock("IMG00",,,{"U_ACDG06F"})
MSCBCLOSEPRINTER()
//
//Gravacao do log da nova etiqueta gerada:
CbLog("07",{_cCodigo,CB0->CB0_QTDE,CB0->CB0_LOTE,CB0->CB0_SLOTE,CB0->CB0_LOCAL,CB0->CB0_LOCALI,CB0->CB0_OP,CB0->CB0_CODETI,CB0->CB0_CODETI,NIL})
//
Return
#INCLUDE "acdv010.ch"
#include "protheus.ch"
#include "apvt100.ch"

User Function NSACDGCQ()
Local nOpc

If UsaCB0("01")
	ACDV0101()   // produto com cb0
EndIf
Return
//
//
Static Function ACDV0101(nTipo)
Local bkey09
Local bkey24
Local nL := 0
Private lBranco := .t.
Private cNota     := space(6)
Private cSerie    := space(3)
Private cFornec   := space(6)
Private cLoja     := space(2)
Private cDoc      := space(6)
Private cProd     := Space(20)
Private cMotivo  := Space(06)
Private cDescMot  := Replicate("-",15) //Space(20)
Private nQtdePro  := 1
Private cArmazem  := Space(2)
Private cEndereco := Space(15)
Private aDist     := {}
Private aRecSD1   := {}
Private aRecSD3   := {}
Private aHisEti   := {}
Private cCondSF1  := "1 "   // variavel utilizada na consulta Sxb 'CBW'
Private lTTS       := iif(getmv('MV_TTS') == 'S', .T., .F.)
Private	cCont := Space(01)
Private	cCont2 := Space(01)

CBChkTemplate()

OpenFile("CQCAB"+cEmpAnt,"CABTMP")
OpenFile("CQIT"+cEmpAnt,"ITETMP")
RegistraCab()

bkey09 := VTSetKey(09,{|| Informa()},STR0050) //"Informacao"
bKey24 := VTSetKey(24,{|| Estorna()},STR0051)   // CTRL+X //"Estorno"

If ExistBlock("ACDV10INI")
	ExecBlock("ACDV10INI",.F.,.F.,)
EndIf
//
If nTipo == 1
	cProd     := Space(20)
Else
	cProd     := Space(48)
EndIf
While .t.
	VTClear
	@ 0,0 VTSAY STR0004  //"Liberacao/Rejeicao"
	nL := 0
	nQtdePro := 1
	@ ++nL,0 VTSAY "Produto:"
	@ ++nL,0 VTGET cProd PICTURE "@!" VALID VTLastkey() == 05 .or. Empty(cProd) .or. VldProd()
	//@ ++nL,0 VTSAY ""  // // //'Endereco'
	//@ ++nL,0 VTGet cArmazem PICTURE "!!" Valid VTLastkey() == 05 .or. ! Empty(cArmazem)
	//@   nL,3 VTSAY "-" VTGET cEndereco PICTURE "@!" VALID VtLastKey()==5 .or. VldEndereco()
	VTREAD
	If VTLASTKEY()==27
		If Empty(aDist) .or. VTYesNo(STR0012,STR0026,.T.)		  //### //### //"Saindo perdera o que foi lido, confirma saida?" //"ATENCAO"
			Exit
		EndIf
	Else
		If Empty(aDist)
			VTALERT("Nenhuma etiqueta foi lida!","Aviso",.T.,4000)   //"Etiqueta invalida."###"AVISO"			
		Else
			While .T. && Confirmacao de gravacao da Producao
				cCont := Space(01)
				@ 05,00 vtsay '  Quanto ao produto    '
				@ 06,00 vtsay '1=Libera / 2=Rejeita ? '
				@ 07,10 vtget cCont	Picture '!' valid fConfirma(cCont)
				vtread
				vtclear()
				If cCont ==  '2' 
					While .t.
						nL := 0
						@ ++nL,0 VTSAY "Motivo da Rejeição:"
						@ ++nL,0 VTGET cMotivo PICTURE "@!" F3 "43" VALID !Empty(cMotivo) .and. VldMotivo()
						@ ++nL,0 VTGET cDescMot  When .f. 
						vtread
						aTela2 := Vtsave()						   
						cCont2 := Space(01)
						@ 05,00 vtsay '  Confirma motivo ?    '
						@ 06,00 vtsay '   (1=Sim / 0=Nao)     '
						@ 07,10 vtget cCont2	 Picture '!' valid fConfirma2(cCont2)						
						vtread
						If cCont2 == "1"
							Exit	
						Endif
						VtRestore(,,,,aTela2)
						cCont2 := Space(01)						
					Enddo
				Endif
				If Lastkey() <> 27 .and. cCont $ '12'
				   	vtbeep(2)
				 	if lTTS
						begin transaction
						VldEndereco()
						dbcommitall()
						end transaction
					else
						VldEndereco()
						dbcommitall()
					endif
					vtkeyboard(chr(0))
					vtclearbuffer()
					Exit
				Else
				   Exit
				Endif
			Enddo
		Endif
	EndIf
	If nTipo == 1
		cProd := Space(20)
	Else
		cProd := Space(48)
	EndIf
End
vtsetkey(09,bkey09)
vtsetkey(24,bkey24)
//
RegistraCab(.F.)
CabTMP->(dbCloseArea())
IteTMP->(dbCloseArea())
CloseFile("CQCAB"+cEmpAnt,"CABTMP")
CloseFile("CQIT"+cEmpAnt,"ITETMP")
If ExistBlock("ACDV10FIM")
	ExecBlock("ACDV10FIM",.F.,.F.,)
EndIf
Return
//
//
Static function VldProd()
Local nPos     := 0
Local nX       := 0
Local nP       := 0
Local aEtiqueta:= {}
Local cChavPesq:= ""
Local aChavPesq:= ""
Local cChave   := ""
Local cTipDis  := ""
Local cLote    := Space(10)
Local cSLote   := Space(6)
Local aDistBKP  := aClone(aDist)
Local aHisEtiBKP:= aClone(aHisEti)
Local aGrava    :={}
Local aItensPallet := CBItPallet(cProd)
Local lIsPallet := .t.

If len(aItensPallet) == 0
	aItensPallet:={cProd}
	lIsPallet := .f.
EndIf
//
Begin Sequence
For nP:= 1 to len(aItensPallet)
	cProd :=  padr(aItensPallet[nP],20)
	If UsaCB0("01")
		aEtiqueta := CBRetEti(cProd,"01")
		If Empty(aEtiqueta)
			VTBEEP(2)
			VTALERT(STR0016,STR0014,.T.,4000)   //"Etiqueta invalida."###"AVISO"
			break
		EndIf
		If ! lIsPallet .and. ! Empty(CB0->CB0_PALLET)
			VTBeep(2)
			VTALERT(STR0052,STR0014,.T.,4000) //"Etiqueta invalida, Produto pertence a um Pallet"###"AVISO"
			break
		EndIf
		If ascan(aHisEti,{|x|x[1] == cProd}) > 0
			VTBEEP(2)
			VTALERT(STR0017,STR0014,.T.,4000)   //"Produto ja foi lido."###"AVISO"
			break
		EndIf

		If Empty(aEtiqueta[9])  //Empty(aEtiqueta[4]) .OR. Empty(aEtiqueta[5]) .or. Empty(aEtiqueta[6]) .or. Empty(aEtiqueta[7]) .or. Empty(aEtiqueta[11]) .or. Empty(aEtiqueta[12])
			VTBEEP(2)
			VTALERT(STR0019,STR0014,.T.,4000)   //"Produto nao conferido"###"AVISO"
			break
		EndIf

		If aEtiqueta[10] # AlmoxCQ() .and. aEtiqueta[10] # Substr(GetMV("MV_CBENDRE"),1,2)  .and. aEtiqueta[10] # Substr(GetMV("MV_CBENDSC"),1,2)
			VTBEEP(2)
			VTALERT(STR0047,STR0014,.T.,4000)   //"AVISO" //"Produto ja liberado"
			break
		EndIf
		
		If Alltrim(aEtiqueta[10]+aEtiqueta[09]) == GetMV("MV_CBENDRE") .and. Alltrim(aEtiqueta[10]+aEtiqueta[09]) # GetMV("MV_CBENDSC")  
			VTBEEP(2)
			VTALERT("Produto já rejeitado (Refugo /Scrap)","AVISO",.T.,4000)   //"AVISO" //"Produto ja rejeitado"
			break
		EndIf                                                  
		
		cNota  := aEtiqueta[4]
		cSerie := aEtiqueta[5]
		cFornec:= aEtiqueta[6]
		cLoja  := aEtiqueta[7]
		cLote  := aEtiqueta[16]
		cSLote := aEtiqueta[17]
	EndIf
	// quandos os elementos abaixo estiverem em branco e' porque nao foi conferido
	If ! CBProdLib(AlmoxCQ(),aEtiqueta[1])
		break
	EndIF        

	If !Empty(cNota+cSerie+cFornec+cLoja) .AND. IIf(UsaCB0("01"),aEtiqueta[24]<>"SD3",.T.)
		cTipDis   := "SD1"
		cChave    :=cNota+cSerie+cFornec+cLoja
		aChavPesq :=RetNumCQ(cChave+aEtiqueta[1],aEtiqueta[2]*nQtdePro,cTipDis,cLote,cSLote)
		IF Empty(aChavPesq)
			VTBEEP(2)
			VTALERT(STR0020,STR0014+'-1',.T.,4000)   //"Nao tem saldo a analisar"###"AVISO"
			break
		EndIf
	Else
		cTipDis   := "SD3"
		If UsaCB0("01")
			SD7->(DbSetOrder(3))
			If !SD7->(DbSeek(xFilial("SD7")+CB0->(CB0_CODPRO+CB0_NUMSEQ)))
				VTBEEP(2)
				VTALERT(STR0053,STR0014+'-2',.T.,4000)   //###"AVISO" //"Nao tem saldo a analisar no SD7"
				break
			EndIf
		Else
			SD3->(DbSetOrder(2))
			If ! SD3->(DbSeek(xFilial("SD3")+cDoc+aEtiqueta[1]))
				VTBEEP(2)
				VTALERT(STR0054,STR0014+'-3',.T.,4000)   //###"AVISO" //"Nao tem saldo a analisar no SD3"
				break
			Endif
			SD7->(DbSetOrder(3))
			If !SD7->(DbSeek(xFilial("SD7")+SD3->(D3_COD+D3_NUMSEQ)))
				VTBEEP(2)
				VTALERT(STR0053,STR0014+'-4',.T.,4000)   //###"AVISO" //"Nao tem saldo a analisar no SD7"
				break
			EndIf
		EndIf
		cChave := SD7->(D7_NUMERO+D7_PRODUTO+D7_LOCAL)
		aChavPesq:= RetNumCQ(cChave,aEtiqueta[2]*nQtdePro,cTipDis,cLote,cSLote)
		IF Empty(aChavPesq)
			VTBEEP(2)
			VTALERT(STR0020,STR0014+'-5',.T.,4000)   //"Nao tem saldo a analisar"###"AVISO"
			break
		EndIf
	EndIf
	For nX := 1 to len(aChavPesq)
		cChavPesq := aChavPesq[nX,1]
		aadd(aHisEti,{cProd,aEtiqueta[1],cChavPesq})
		nPos:= aScan(aDist,{|x| x[1] == cChavPesq .and. x[2] == aEtiqueta[1]})
		If nPos > 0
			aDist[nPos,3] += aChavPesq[nX,2]
			aadd(aDist[nPos,5],{cProd,aEtiqueta[2]})
		Else
			aadd(aDist,{cChavPesq,aEtiqueta[1],aChavPesq[nX,2],cTipDis,{{cProd,aEtiqueta[2]}},cLote,cSLote})
		EndIf
		aadd(aGrava,{xFilial(cTipDis),cChavPesq,aChavPesq[nX,2]})
		//			GravaQtd(xFilial(cTipDis),cChavPesq,aChavPesq[nX,2])
		VTKeyBoard(chr(20))
	Next
Next
For nX:= 1 to len(aGrava)
	GravaQtd(aGrava[nX,1],aGrava[nX,2],aGrava[nX,3])
Next
nQtdePro := 1
VTGetRefresh("nQtdePro")
VTKeyBoard(chr(20))
Return .f.
End sequence
aDist  := aClone(aDistBKP)
aHisEti:= aClone(aHisEtiBKP)
nQtdePro := 1
VTGetRefresh("nQtdePro")
VTKeyBoard(chr(20))
Return .f.


Static Function RetNumCQ(cChave,nQtde,cTipDis,cLote,cSLote)
Local aNumCQ  :={}
Local nSaldo  :=nQtde
Local nQtdBx  := 0

If cTipDis == "SD1"
	SD1->(DbSetOrder(1))
	SD1->(DbSeek(xFilial('SD1')+cChave))
	While SD1->(!Eof() .and. xFilial('SD1')+cChave == ;
		D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD)
		
		If ! ( SD1->D1_LOTECTL==cLote .and. SD1->D1_NUMLOTE ==cSLote )
			SD1->(DbSkip())
			Loop
		EndIf
		If Empty(SD1->D1_NUMCQ)
			SD1->(DbSkip())
			Loop
		EndIf
		SD7->(DBSetOrder(1))
		If ! SD7->(DbSeek(xFilial("SD7")+SD1->(D1_NUMCQ+D1_COD+D1_LOCAL)))
			SD1->(DbSkip())
			loop
		EndIf
		While SD7->(! Eof() .and. D7_FILIAL+D7_NUMERO+D7_PRODUTO+D7_LOCAL == xFilial("SD7")+SD1->(D1_NUMCQ+D1_COD+D1_LOCAL))
			SD7->(DbSkip())
		EndDo
		SD7->(DbSkip(-1))
		nQtdBx := RetSaldo(SD1->(D1_FILIAL+D1_NUMCQ))
		IF Empty(nQtdBx)
			SD1->(DbSkip())
			loop
		EndIf
		If nQtdBx > nSaldo
			nQtdBx :=nSaldo
		EndIf
		aadd(aNumCQ,{SD1->D1_NUMCQ,nQtdBx})
		nSaldo -=nQtdBx
		If Empty(nSaldo)
			Exit
		EndIf
		SD1->(DbSkip())
	End
ElseIf cTipDis == "SD3"
	SD7->(DBSetOrder(1))
	While SD7->(! Eof() .and. D7_FILIAL+D7_NUMERO+D7_PRODUTO+D7_LOCAL == xFilial("SD7")+cChave)
		SD7->(DbSkip())
	EndDo
	SD7->(DbSkip(-1))
	
	nQtdBx := RetSaldo(xFilial(cTipDis)+SD7->D7_NUMERO)
	
	If nQtdBx > nSaldo
		nQtdBx :=nSaldo
	EndIf
	
	aadd(aNumCQ,{SD7->D7_NUMERO,nQtdBx})
	nSaldo -=nQtdBx
EndIf
If nSaldo > 0
	aNumCQ :={}
EndIf
Return aNumCQ
//
//
Static Function RetSaldo(cChave)
Local nSaldo := SD7->D7_SALDO
ITETMP->(DBSetOrder(2))
ITETMP->(DbSeek(cChave))
While  ITETMP->( !Eof() .and. ITE_FILIAL+ITE_NUMCQ == cChave )
	nSaldo -= ITETMP->ITE_QTD
	ITETMP->(DbSkip())
End
ITETMP->(DBSetOrder(1))
Return nSaldo
//
//     
sTATIC Function VldMotivo()
If !SX5->(DbSeek(xFilial("SX5")+"43"+cMotivo))
	VTBEEP(2)
	VTALERT("Motivo nao cadastrado!","AVISO",.T.,4000)    
	VTClearGet()
	VTClearGet("cMotivo")
	VTGetSetFocus("cMotivo")
	Return .f.
Else
   cDescMot := ALLTRIM(SX5->X5_DESCRI)
   VTGetRefresh("cDescMot")   
EndIf
Return .t.

Static Function VldEndereco()
Local cTitulo
Local nX

If cCont == "1"
  cTitulo := STR0025 //" Confirma a liberacao dos itens? "
Else
   cTitulo := STR0024  //" Confirma a rejeicao dos itens? "
EndIf
//
//
VTBEEP(2)
If VTYesNo(cTitulo,STR0026,.T.)    //"ATENCAO"
	Analisa(cEndereco,cArmazem)
	Distribui(cEndereco,cArmazem)
	VTKeyBoard(chr(20))
	cArmazem  := Space(2)
	cEndereco := Space(15)
	cNota     := space(6)
	cSerie    := space(3)
	cFornec   := space(6)
	cLoja     := space(2)
	cDoc      := space(6)
	cLote     := Space(10)
	cSLote    := Space(6)
	lBranco   := .t.
	Return .t.
EndIf
Return .f.

Static Function Analisa(cEndereco,cArmazem)
Local nI
Local aMov:={}
Local nTipo
For nI := 1 to len(aDist)
	aMov:={}
	SD7->(DBSetOrder(1))
	SD7->(DbSeek(xFilial("SD7")+aDist[nI,1]+aDist[nI,2])) // Seek com NUMCQ+PRODUTO
	//
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+aDist[nI,2]))
	//
	If cCont == "1" // LIBERAÇÃO
	   	cArmazem := Substr(GetMV("MV_CBENDLI"),1,2)
	  	cEndereco := Substr(GetMV("MV_CBENDLI"),3,10) 
		nTipo:= 1
	Else      //REJEICAO
		If Alltrim(SB1->B1_GRUPO) == "MPI"
			cArmazem := Substr(GetMV("MV_CBENDSC"),1,2)
			cEndereco := Alltrim(Substr(GetMV("MV_CBENDSC"),3,10))
		Else 
			cArmazem := Substr(GetMV("MV_CBENDRE"),1,2)
			cEndereco := Alltrim(Substr(GetMV("MV_CBENDRE"),3,10))			
		Endif	
		nTipo:= 2
	EndIf 
	//
	aadd(aMov,{nTipo,aDist[nI,3],cArmazem,dDataBase," ",cMotivo,"",ConvUm(aDist[nI,2],aDist[nI,3],,1)})
	fGravaCQ(aDist[nI,2],aDist[nI,1],.f.,aMov,If(SD7->D7_ORIGLAN=='CP',PegaCMD1(),PegaCMD3()),NIL)
Next
Return
//
//
Static Function VldEtiq(cTipoObr) //funcao utilizado quando usacb0 no produto e endereco
Local cTipId   := ""
Local aItensPallet
Local lIsPallet := .t.
DEFAULT cTipoObr := "01/02"
If Empty(cProd)
	Return .f.
EndIf

aItensPallet := CBItPallet(cProd)
If len(aItensPallet) == 0
	lIsPallet := .f.
EndIf

cTipId:=CBRetTipo(cProd)
If lIsPallet .or. (cTipId =="01"  .and. cTipId $ cTipoObr )
	VldProd()
ElseIf cTipId =="02" .and. cTipId $ cTipoObr
	aEtiqueta := CBRetEti(cProd,"02")
	If Empty(aEtiqueta)
		VTBEEP(2)
		VTALERT(STR0016,STR0014,.T.,4000)   //"Etiqueta invalida."###"AVISO"
		VTKeyBoard(chr(20))
		Return .f.
	EndIf
	cEndereco:=aEtiqueta[1]
	cArmazem :=aEtiqueta[2]
	Return VLDEndereco()
Else
	VTBEEP(2)
	VTALERT(STR0016,STR0014,.T.,4000)   //"Etiqueta invalida."###"AVISO"
EndIf
VTKeyBoard(chr(20))
Return .f.
//
//
Static Function Distribui(cLocaliz,cLocal)
Local cEtiq    := space(10)
Local cItem    := ""
Local cDoc     := ""
Local cNumSeq  := ""
Local cSeek    := ""
Local cLote    := ""
Local cSLote   := ""
Local nI       := 0
Local nX       := 0
Local nIndex   := 0
Local aCab     := {}
Local aItens   := {}
Local aSave := VTSAVE()
Private lMSErroAuto := .F.

VTMSG(STR0027,1)  // // //"Aguarde..."
Begin Transaction
For nI := 1 to Len(aDist)
	
	SD7->(DBSetOrder(1))
	If !SD7->(DbSeek(xFilial("SD7")+aDist[nI,1]+aDist[nI,2]))
		loop
	EndIf
	While SD7->(! Eof() .and. D7_FILIAL+D7_NUMERO+D7_PRODUTO == xFilial("SD7")+aDist[nI,1]+aDist[nI,2])
		SD7->(DbSkip())
	EndDo
	SD7->(DbSkip(-1))    
	//
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+aDist[nI,2]))
	//
	If cCont == "1" // LIBERAÇÃO
		//cLocaliz,cLocal
   		cLocal := Substr(GetMV("MV_CBENDLI"),1,2)
   		cLocaliz := Substr(GetMV("MV_CBENDLI"),3,10) 
	Else      //REJEICAO
		If Alltrim(SB1->B1_GRUPO) == "MPI"
			cLocal := Substr(GetMV("MV_CBENDSC"),1,2)
			cLocaliz := Alltrim(Substr(GetMV("MV_CBENDSC"),3,10))
		Else 
			cLocal := Substr(GetMV("MV_CBENDRE"),1,2)
			cLocaliz := Alltrim(Substr(GetMV("MV_CBENDRE"),3,10))			
		Endif	
	EndIf 
	//
	cDoc    := SD7->D7_NUMERO
	cNumSeq := SD7->D7_NUMSEQ
	cLote   := SD7->D7_LOTECTL
	cSLote  := SD7->D7_NUMLOTE
	cItem := Item(nI,cLocal,cLocaliz,cNumSeq)
	aCAB  :={{"DA_PRODUTO",aDist[nI,2]   , nil},;
	{"DA_LOCAL"  ,cLocal         , nil},;
	{"DA_NUMSEQ" ,cNumSeq        , nil},; //relacionado ao campo D1_NUMSEQ
	{"DA_DOC"    ,cDoc           , nil}} //Relacionado ao campo F1_DOC ou D1_DOC
	
	aITENS:={{{"DB_ITEM"   ,cItem         , nil},;
	{"DB_LOCALIZ",cLocaliz      , nil},;
	{"DB_QUANT"  ,aDist[nI,3]   , nil},;
	{"DB_DATA"   ,dDATABASE     , nil},;
	{"DB_LOTECTL",cLote 			,nil},;
	{"DB_NUMLOTE",cSLote		   ,nil}}}
	//esta variavel deverah ser retirada mais tarde
	nModuloOld  := nModulo
	nModulo     := 4
	lMSHelpAuto := .T.
	lMSErroAuto := .F.
	msExecAuto({|x,y|mata265(x,y)},aCab,aItens)
	nModulo := nModuloOld
	lMSHelpAuto := .F.
	If lMSErroAuto
		DisarmTransaction()
		VTBEEP(2)
		VTALERT(STR0028,STR0029,.T.,4000)   //"Falha no processo de distribuicao."###"ERRO"
		Break
	Else
		If UsaCB0("01")
			For nX := 1 to len(aDist[nI,5])
				CBGrvEti("01",{NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,cLocaliz,cLocaL,,cNumSeq},aDist[nI,5,nX,1])
				CBLog("03",{aDist[nI,2],CB0->CB0_QTDE,cLote,cSLote,cLocal,cLocaliz,cNumSeq,cDoc,aDist[nI,5,nX,1]})
			Next
		Else
			CBLog("03",{aDist[nI,2],aDist[nI,3],cLote,cSLote,cLocal,cLocaliz,cNumSeq,cDoc,""})
		EndIf
		RegistraCab(.t.)
	EndIf
Next
End Transaction
If lMsErroAuto
	VTDispFile(NomeAutoLog(),.t.)
Else
	aDist  := {}
	aHisEti:= {}
Endif
VTCLEAR
VtRestore(,,,,aSave)
Return
//
//
Static Function Item(nPos,cLocal,Localiz,cNumSeq)
Local cItem     := ""
SDB->(dbSetOrder(1))
If SDB->(dbSeek(xFilial("SDB")+aDist[nPos,2]+cLocal+aDist[nPos,1]))
	While SDB->(!EOF() .and. xFilial("SDB")+aDist[nPos,2]+cLocal+aDist[nPos,1] ==;
		DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ)
		cItem := SDB->DB_ITEM
		SDB->(dbSkip())
	end
	cItem := strzero(val(cItem)+1,3)
Else
	cItem := "001"
EndIf
Return cItem
//
//
Static Function Informa()
Local aCab,aSize,aSave := VTSAVE()
Local nX,nPos
Local aTemp:={}
VTClear()
If  UsaCB0("01")
	aCab  := {STR0030,STR0031}   //"Etiqueta"###"Produto"
	aSize := {10,16}
	aTemp := aClone(aHisEti)
Else
	aCab  := {STR0031,STR0032,STR0033,STR0034}   //"Produto"###"Quantidade"###"Lote"###"SubLote"
	aSize := {15,12,10,7}
	aHisEti:= {}
	For nx:= 1 to len(aDist)
		nPos := Ascan(aTemp,{|x| x[1] == aDist[nx,2] .and. x[3] == aDist[nx,6] .and. x[4] == aDist[nx,7] })
		IF nPos == 0
			aadd(aTemp,{aDist[nx,2],aDist[nX,3],aDist[nX,6],aDist[nX,7]})
		Else
			aTemp[nPos,2] += aDist[nX,3]
		endIf
	Next
EndIf
VTaBrowse(0,0,7,19,aCab,aTemp,aSize)
VtRestore(,,,,aSave)
Return

Static Function Estorna()
Local aTela
Local cEtiqueta
aTela := VTSave()
VTClear()
cEtiqueta := Space(20)
nQtdePro  := 1
@ 00,00 VtSay Padc(STR0037,VTMaxCol())  // // //"Estorno da Leitura"
If ! UsaCB0('01')
	@ 1,00 VTSAY  STR0038 // //'Qtde. '
	@ 1,05 VTGet nQtdePro   pict CBPictQtde() when VTLastkey() == 5 //
EndIf
@ 02,00 VtSay STR0039  // // //"Etiqueta:"
@ 03,00 VtGet cEtiqueta pict "@!" Valid VldEstorno(cEtiqueta,nQtdePro)
VtRead
vtRestore(,,,,aTela)
Return

Static Function VldEstorno(cEtiqueta,nQtdePro)
Local nPos,cKey,nQtd,cProd,nPosID
Local nX,nP
Local aEtiqueta,nSaldo,nQtdeBx,cLote:=Space(10),cSLote:=Space(6)
Local aDistBKP  := aClone(aDist)
Local aHisEtiBKP:= aClone(aHisEti)
Local aGrava    :={}
Local aItensPallet := CBItPallet(cEtiqueta)
Local lIsPallet:= .t.

If Empty(cEtiqueta)
	Return .f.
EndIF

If len(aItensPallet) == 0
	aItensPallet:={cEtiqueta}
	lIsPallet := .f.
EndIf
Begin Sequence
For nP:= 1 to len(aItensPallet)
	cEtiqueta :=  padr(aItensPallet[nP],20)
	If UsaCB0("01")
		nPos := Ascan(aHisEti, {|x| AllTrim(x[1]) == AllTrim(cEtiqueta)})
		If nPos == 0
			VTBeep(2)
			VTALERT(STR0040,STR0014,.T.,4000)    //"Etiqueta nao encontrada"###"AVISO"
			Break
		EndIf
		If ! lIsPallet .and. ! Empty(CB0->CB0_PALLET)
			VTBeep(2)
			VTALERT(STR0052,STR0014,.T.,4000) //"Etiqueta invalida, Produto pertence a um Pallet"###"AVISO"
			break
		EndIf
	Else
		If ! CBLoad128(@cEtiqueta)
			Break
		EndIf
		aEtiqueta := CBRetEtiEAN(cEtiqueta)
		IF Len(aEtiqueta) == 0
			VTBeep(2)
			VTALERT(STR0041,STR0014,.T.,4000)    //"Etiqueta invalida"###"AVISO"
			Break
		EndIf
		cLote := aEtiqueta[3]
		If ! CBRastro(aEtiqueta[1],@cLote,@cSLote)
			VTBeep(2)
			VTALERT(STR0042,STR0014,.T.,4000)    //"Lote invalido"###"AVISO"
			Break
		EndIf
	EndIf
	If UsaCB0("01")
		//Estorno do aHisEti
		cKey := aHisEti[nPos,3]
		cProd:= aHisEti[nPos,2]
		nQtd := CBRetEti(cEtiqueta,'01')[2]
		aDel(aHisEti,nPos)
		aSize(aHisEti,Len(aHisEti)-1)
		//Estorno do aDist
		nPos := aScan(aDist,{|x| AllTrim(x[1]) == Alltrim(cKey) .and. x[2] == cProd})
		//GravaQtd(xFilial(aDist[nPos,4]),aDist[nPos,1],nQtd*-1)
		aadd(aGrava,{xFilial(aDist[nPos,4]),aDist[nPos,1],nQtd*-1})
		aDist[nPos,3] := aDist[nPos,3] - nQtd
		If Empty(aDist[nPos,3])
			aDel(aDist,nPos)
			aSize(aDist,Len(aDist)-1)
		Else
			nPosID := Ascan(aDist[nPos,5],{|x| Alltrim(x[1]) == Alltrim(cEtiqueta)})
			aDel(aDist[nPos,5],nPosID)
			aSize(aDist[nPos,5],Len(aDist[nPos,5])-1)
		EndIf
	Else
		cProd  := aEtiqueta[1]
		nQtde  := aEtiqueta[2]
		nSaldo := 0
		For nx:= 1 to len(aDist)
			If ! (aDist[nX,2] == cProd .and. aDist[nX,6] == cLote .and. aDist[nX,7] == cSLote)
				Loop
			EndIf
			nSaldo += aDist[nX,3]
			If nSaldo >= (nQtde*nQtdePro)
				Exit
			EndIf
		Next
		If  nSaldo < (nQtde*nQtdePro)
			VTBeep(2)
			VTALERT(STR0044,STR0014,.T.,4000)    // // //"Saldo insuficiente"###"AVISO"
			Break
		EndIf
		nSaldo := (nQtde*nQtdePro)
		nQtdeBx:= 0
		For nx:= 1 to len(aDist)
			If nX > Len(aDist)
				Exit
			EndIF
			If ! (aDist[nX,2] == cProd .and. aDist[nX,6] == cLote .and. aDist[nX,7] == cSLote)
				Loop
			EndIf
			If nSaldo ==0
				Exit
			EndIf
			If aDist[nx,3] <= nSaldo
				nQtdeBx := aDist[nx,3]
			Else
				nQtdeBx := nSaldo
			EndIf
			//GravaQtd(xFilial(aDist[nx,4]),aDist[nx,1],nQtdeBx*-1)
			aadd(aGrava,{xFilial(aDist[nPos,4]),aDist[nPos,1],nQtdeBx*-1})
			aDist[nx,3] := aDist[nx,3] - nQtdeBx
			nSaldo -= nQtdeBx
			If Empty(aDist[nx,3])
				aDel(aDist,nx)
				aSize(aDist,Len(aDist)-1)
				nX--
				Loop
			EndIf
		Next
	EndIf
Next

If ! VTYesNo(STR0037,STR0013,.t.)  //### //"Confirma o estorno desta Etiqueta?"###"ATENCAO"
	Break
EndIf
For nX:= 1 to len(aGrava)
	GravaQtd(aGrava[nX,1],aGrava[nX,2],aGrava[nX,3])
Next
nQtdePro := 1
VTGetRefresh("nQtdePro")
VTKeyBoard(chr(20))
Return .f.
End Sequence
aDist  := aClone(aDistBKP)
aHisEti:= aClone(aHisEtiBKP)
nQtdePro := 1
VTGetRefresh("nQtdePro")
VTKeyBoard(chr(20))
Return .f.

/*
Funcoes para tratamento de arquivos TMP
*/

Static Function OpenFile(cArq,cAlias)
Local cDrive   := "DBFCDXADS"
Local cArquivo := RetArq(cDrive,cArq,.T.)
Local cIndice  := RetArq(cDrive,cArq,.F.)
If ! file(cArquivo)  .or. ! file(cIndice)
	CriaFile(cArq,cAlias)
Else
	if !CloseFile(cArq,cAlias)
		CriaFile(cArq,cAlias)
	endif
EndIf
dbUseArea(.T.,cDrive,cArquivo,cAlias,.T.,.F.)
dbSetIndex(FileNoExt(cIndice))
Return

Static Function CriaFile(cArq,cAlias)
Local aStru
Local cDrive   := "DBFCDXADS"
Local cArquivo := RetArq(cDrive,cArq,.T.)
Local cIndice  := RetArq(cDrive,cArq,.F.)
If cAlias =="CABTMP"
	aStru :={{"CAB_NUMRF"	,"C",3,00}}
Else
	aStru :={	{"ITE_RECNO","C",6,00},;
	{"ITE_FILIAL","C",2,00},;
	{"ITE_NUMCQ","C",6,00},;
	{"ITE_QTD"   ,"N",12,4}}
EndIf
dbCreate(cArquivo,aStru,cDrive)
dbUseArea(.T.,cDrive,cArquivo,cAlias,.F.,.F.) // Exclusivo
If cAlias =="CABTMP"
	INDEX ON CAB_NUMRF TAG &(RetFileName(cIndice)) TO &(FileNoExt(cArquivo))
Else
	INDEX ON ITE_RECNO+ITE_FILIAL+ITE_NUMCQ TAG &(cArq+"1") TO &(FileNoExt(cArquivo))
	INDEX ON ITE_FILIAL+ITE_NUMCQ TAG &(cArq+"2") TO &(FileNoExt(cArquivo))
EndIf
dbCloseArea()
Return

Static Function CloseFile(cArq,cAlias)
Local cDrive   := "DBFCDXADS"
Local cArquivo := RetArq(cDrive,cArq,.T.)
Local cIndice  := RetArq(cDrive,cArq,.F.)
dbUseArea(.T.,cDrive,cArquivo,cAlias,.F.,.F.)
If ! neterr()
	dbCloseArea()
	FErase(cArquivo)
	FErase(cIndice)
	Return .f.
EndIf
Return .t.

Static Function RegistraCab(lRegistra)
DEFAULT lRegistra:= .T.
CABTMP->(DbGotop())
ITETMP->(DbSetOrder(1))
While !  CABTMP->(eof())
	If ! CABTMP->(Rlock())
		CABTMP->(DbSkip())
		Loop
	EndIf
	While ITETMP->(DBSEEK(Str(CABTMP->(Recno()),6)))
		RecLock("ITETMP",.f.)
		ITETMP->(DBDelete())
		ITETMP->(MsUnLock())
	End
	CABTMP->(DBDelete())
	CABTMP->(MsUnLock())
	CABTMP->(DbSkip())
End
//- Elimina os itens que estão sobrando sem cabecalho
ITETMP->(DbGotop())
While ITETMP->(!Eof())
	CABTMP->(dbGoto(Val(ITETMP->(ITE_RECNO))))
	If CABTMP->(DELETED())
		RecLock("ITETMP",.f.)
		ITETMP->(DBDelete())
		ITETMP->(MsUnLock())
	EndIf
	ITETMP->(dbSkip())
EndDo
If lRegistra
	RecLock("CABTMP",.t.)
	CABTMP->CAB_NUMRF := VTNUMRF()
	CABTMP->(MsUnlock())
	RecLock("CABTMP",.f.)
EndIf
Return .t.

Static function GravaQtd(cFilTmp,cNumCQ,qtde)
ITETMP->(DbSetOrder(1))
If ! ITETMP->(DBSeek(Str(CABTMP->(Recno()),6)+cFilTmp+cNumCQ))
	RecLock("ITETMP",.t.)
	ITETMP->ITE_RECNO:= Str(CABTMP->(Recno()),6)
	ITETMP->ITE_FILIAL := cFilTmp
	ITETMP->ITE_NUMCQ:=cNumCQ
Else
	RecLock("ITETMP",.f.)
EndIf
ITETMP->ITE_QTD   += Qtde
ITETMP->(MsUnLock())
Return

Static Function fConfirma(cCont)
Local lRet	:= .t.
If Upper(cCont) != '1' .AND. Upper(cCont) != '2' 
	lRet := .F.
Endif
Return(lRet)

Static Function fConfirma2(cCont2)
Local lRet	:= .t.
If Upper(cCont2) != '1' .AND. Upper(cCont2) != '0'
	lRet := .F.
Endif
Return(lRet)

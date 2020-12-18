# include "RWMAKE.CH"
//# include " TOPCONN.CH"

/******************************************************************************************************/
/*Ponto de entrada executado na linha do grid dos itens da nota                                ***/
/*Desenvolvedora: Aglair Brito Ishii																			***/
/*Data:17/09/09								                                                                       ***/
/******************************************************************************************************/
/******************************************************************************************************/
User Function  MT100LOK()

Local lRet,NFunc
//Local xAdi  := Type(SD1->D1_XADI)
//Local lEntra:= .F.

nFunc :=funname()
lRet    := .T.

/*If xAdi<>'Nil'
	If Empty(AllTrim(SD1->D1_XADI))
		lEntra:= .T.
	Endif
Endif*/

/************************************************************************************************************************/
/************************************************************************************************************************/
//** As notas de complemento de frete e preco não atualizam estoque qdo as TES 300,301,313,398  * **/
/**  A regra é utilizado porque a nota de despesa já atualiza estoque                                              *****/
If Alltrim(nFunc)=="FMATA103"  .and. ( CTIPO=="C" .and. !acols[n][6]$('300,301,302,313,398')  ) .and. !(acols[n][len(aheader)+1])
	// Nota inclusa pelo Estoque/Custo
	PosTes   :=aScan(aHeader,{|x| AllTrim(x[2])=="D1_TES"})
	PosNfOr   :=aScan(aHeader,{|x| AllTrim(x[2])=="D1_NFORI"})
	PosSrOr  :=aScan(aHeader,{|x| AllTrim(x[2])=="D1_SERIORI"})
	PosFabric  :=aScan(aHeader,{|x| AllTrim(x[2])=="D1_FABRIC"})
	
	TesA:= acols[n][PosTes]
	NfOri :=acols[n][PosNfOr]
	SrOri :=acols[n][PosSeOR]
	Fornecedor:=ca100for+cloja
	lRet:=.T.
	/*Se devolução consulta o cliente*/
	If CTIPO=="D"
		TesO:=Posicione('SD2',3,Xfilial('SD2')+NfOri+SrOri+Fornecedor,"D2_TES")
	Elseif CTIPO=="C"
		TesO:=Posicione('SD1',1,Xfilial('SD1')+NfOri+SrOri+Fornecedor,"D1_TES")
	Endif
	
	StatusO:=Posicione('SF4',1,Xfilial('SF4')+TesO,"F4_ESTOQUE")
	StatusA:=Posicione('SF4',1,Xfilial('SF4')+TesA,"F4_ESTOQUE")
	If StatusO<>StatusA
		Msgbox("Divergência na TES no campo Atualiza Estoque","ATENCAO","ALERT")
		lRet:=.F.
	EndIf
Endif
If nFunc="FMATA103" .and. !(acols[n][len(aheader)+1])
	PosTes:=aScan(aHeader,{|x| AllTrim(x[2])=="D1_TES"})
	PosLoc:=aScan(aHeader,{|x| AllTrim(x[2])=="D1_LOCAL"})
	TesA :=acols[n][PosTes]
	acols[n][PosLoc]:= IIf(TesA="110" .OR. TesA="141","15",acols[n][PosLoc])
EndIf

//Validação inclusa para atender a nota fiscal de importação 2.0.1
/*If nFunc#"MATA116" .AND. CTIPO=="N" .and. cFormul='S' .and. CESPECIE="SPED" .and. !(acols[n][len(aheader)+1]) .and. lEntra == .T.
	
	EstFor:=Posicione("SA2",1,xFilial("SA2")+cA100For+CLOJA,"A2_EST")
	If AllTrim(EstFor)="EX"
		PosCod:=aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})
		PosFab:=aScan(aHeader,{|x| AllTrim(x[2])=="D1_FABRIC"})
		PosLojaF:=aScan(aHeader,{|x| AllTrim(x[2])=="D1_LOJAFAB"})
		PosPedido:=aScan(aHeader,{|x| AllTrim(x[2])=="D1_PEDIDO"})
		PosAdic  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_ADICAO"})
		PosSeqAd := aScan(aHeader,{|x| AllTrim(x[2])=="D1_SEQADIC"})
		PosLI := aScan(aHeader,{|x| AllTrim(x[2])=="D1_LI"})
		If Empty (aCols[n][PosPedido])
			Msgbox("Informe o purchase Order !!! ","ATENCAO","ALERT")
			lRet:=.F.
		EndIf
		If Empty (aCols[n][PosLi])
			Msgbox("Informe o N. da Li !!! ","ATENCAO","ALERT")
			lRet:=.F.
		EndIf
		
		If Empty (aCols[n][PosAdic]) .or. Empty (aCols[n][PosSeqAd])
			Msgbox("Adição ou Sequência da Adição não informado. Campos obrigatório na Importação!","ATENCAO","ALERT")
			lRet:=.F.
		EndIf
		//Verifica se o padrão de fabricante cadastrado
		DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xFilial("SB1")+aCols[n][PosCod])
		If Empty(SB1->B1_CODFAB) .or. Empty(SB1->B1_LOJAFAB)
			If Empty(aCols[n][PosFab]) .or. Empty(aCols[n][PosLojaF])
				Msgbox("É necessário informar o fabricante/loja do produto","ATENCAO","ALERT")
				lRet:=.F.
			Else
				Fab:=Posicione("SA2",1,xFilial("SA2")+aCols[n][PosFab]+aCols[n][PosLojaF],"A2_EST")
				If Empty(Fab)
					Msgbox("Código do Fabricante Invalido!! ","ATENCAO","ALERT")
					lRet:=.F.
				Else
					RecLock("SB1",.F.)
					SB1->B1_CODFAB:=aCols[n][PosFab]
					SB1->B1_LOJAFAB:=aCols[n][PosLojaF]
					SB1->(MsUnLock())
				Endif
			EndIf
		Else
			If Empty(aCols[n][PosFab])
				aCols[n][PosFab]:=    SB1->B1_CODFAB
				aCols[n][PosLojaF]:=  SB1->B1_LOJAFAB
			ElseIf aCols[n][PosFab]+aCols[n][PosLojaF] # SB1->B1_CODFAB+SB1->B1_LOJAFAB
				RecLock("SB1",.F.)
				SB1->B1_CODFAB:=aCols[n][PosFab]
				SB1->B1_LOJAFAB:=aCols[n][PosLojaF]
				SB1->(MsUnLock())
			EndIf
		EndIf
		
		//    	PosCod   :=aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})
		
		//Verifica se já existe o fornecedor padrão do produto.
		
	Endif
EndIf*/

/** Validação do conhecimento de Frete **********/
If nFunc=="MATA116"
	If ! StatusCT // Variavel pública do ponto de entrada MT116SD1
		Msgbox("Divergência na TES, campo Atualiza Estoque. Cancele a inclusão  e informe a TES correta no conhecimento","ATENCAO","ALERT")
		lRet:=.F.
	endif
Endif

/*******************************************************/
/** Validação do conhecimento de Frete **********/
/*
If nFunc=="MATA116"

DConhec:=aParametros
If DConhec[1]==2  //Se for incluir valida dados
DbselectArea ("a116inclui")
If  !Eof()
Chave:=a116inclui->f1_filial+a116inclui->f1_doc+a116inclui->f1_serie+a116inclui->f1_fornece+a116inclui->f1_loja
TesO:=Posicione('SD1',1,Chave,"D1_TES")
StatusO:=Posicione('SF4',1,Xfilial('SF4')+TesO,"F4_ESTOQUE")
StatusA:=Posicione('SF4',1,Xfilial('SF4')+DConhec[12],"F4_ESTOQUE")
If StatusO<>StatusA
Msgbox("Divergência na TES no campo Atualiza Estoque. Cancele a Tela e entre com a TES correta no conhecimento","ATENCAO","ALERT")
Return .F.
Endif
EndIf
EndiF
Endif

*/
Return(lRet)
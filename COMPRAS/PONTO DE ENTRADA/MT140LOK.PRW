# include "RWMAKE.CH"
//# include " TOPCONN.CH"

User Function  MT140LOK()
Local lRet,NFunc
//Local xAdi:= Type(D1_XADI)
//Local lEntra:= .F.
nFunc :=funname()
lRet    := .T.

/*If xAdi<>'Nil'
	If Empty(D1_XADI)
		lEntra:= .T.
	Endif
Endif */

/*If nFunc#"MATA116" .AND. CTIPO=="N" .and. cFormul='S' .and. CESPECIE="SPED" .and. !(acols[n][len(aheader)+1]) .and. lEntra == .T.
	EstFor:=Posicione("SA2",1,xFilial("SA2")+cA100For+CLOJA,"A2_EST")
	
	If AllTrim(EstFor)="EX"
		PosCod:=aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})
		PosFab:=aScan(aHeader,{|x| AllTrim(x[2])=="D1_FABRIC"})
		PosLojaF:=aScan(aHeader,{|x| AllTrim(x[2])=="D1_LOJAFAB"})
		PosPedido:=aScan(aHeader,{|x| AllTrim(x[2])=="D1_PEDIDO"})
		PosAdic  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_ADICAO"})
		PosSeqAd := aScan(aHeader,{|x| AllTrim(x[2])=="D1_SEQADIC"})
		If Empty (aCols[n][PosPedido])
			Msgbox("Informe o purchase Order !!! ","ATENCAO","ALERT")
			lRet:=.F.
		EndIf
		
		If Empty (aCols[n][PosAdic]) .or. Empty (aCols[n][PosSeqAd])
			Msgbox("Adi��o ou Sequ�ncia da Adi��o n�o informado. Campos obrigat�rio na Importa��o!","ATENCAO","ALERT")
			lRet:=.F.
		EndIf
		//Verifica se o padr�o de fabricante cadastrado
		DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xFilial("SB1")+aCols[n][PosCod])
		If Empty(SB1->B1_CODFAB) .or. Empty(SB1->B1_LOJAFAB)
			If Empty(aCols[n][PosFab]) .or. Empty(aCols[n][PosLojaF])
				Msgbox("� necess�rio informar o fabricante/loja do produto","ATENCAO","ALERT")
				lRet:=.F.
			Else
				Fab:=Posicione("SA2",1,xFilial("SA2")+aCols[n][PosFab]+aCols[n][PosLojaF],"A2_EST")
				If Empty(Fab)
					Msgbox("C�digo do Fabricante Invalido!! ","ATENCAO","ALERT")
					lRet:=.F.
				Else
					RecLock("SB1",.F.)
					SB1->B1_CODFAB:=aCols[n][PosFab]
					SB1->B1_LOJAFAB:=aCols[n][PosLojaF]
					MsUnLock()
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
				MsUnLock()
			EndIf
		EndIf
		
		//    	PosCod   :=aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})
		
		//Verifica se j� existe o fornecedor padr�o do produto.
		
	Endif
EndIf*/

Return lRet

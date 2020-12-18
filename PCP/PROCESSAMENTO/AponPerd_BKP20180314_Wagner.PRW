#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TOPCONN.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"

User Function AponPerd()
	Local lParam:= GetMv("MV_APCUSTO")
	Local aArea := GetArea()
	If lParam .and. n == 1
		If MsgYesNo(AllTrim(cUserName)+", Deseja utilizar apontamento de perdas customizado?") 
			TelaPerda()
		Endif
	Endif
	RestArea(aArea)
Return M->BC_PRODUTO

Static Function TelaPerda()

	Private oDlgAut
	Private nQuant  := 0
	Private cTipo2  := ' '
	Private cAlmox  := Space(TamSX3('NNR_CODIGO')[1])
	Private cEndOri := Space(TamSX3('BC_LOCALIZ')[1])
	Private cCodMot := Space(TamSX3('BC_MOTIVO')[1])
	Private cDescri := Space(TamSX3('BC_DESCRI')[1])
	Private cObs    := Space(TamSX3('BC_OBS')[1])
	Private cSolic  := Space(TamSX3('BC_GERAREQ')[1])
	Private COP  	:= Space(TamSX3('BC_OP')[1])
	//
	DEFINE FONT oArial12 NAME 'Arial' SIZE 06,12 BOLD
	DEFINE FONT oArial14 NAME 'Arial' SIZE 06,14 BOLD
	//
	DEFINE MSDIALOG oDlgAut FROM 38,16 TO 450,600 TITLE Alltrim("Apontamento de Perdas Customizado") Pixel //430,531
	//                                                    
	//@ 005,005 TO 065,300 LABEL cTitLabel  PIXEL OF oDlgAut
	@ 015,015 say   'Ordem de produção:'        SIZE 080,10 PIXEL OF oDlgAut //COLOR CLR_BLUE
	@ 015,090 say   COP  		                SIZE 080,10 PIXEL oF oDlgAut FONT oArial14 COLOR CLR_RED
	@ 030,015 say   'Produto acabado:'       	SIZE 080,10 PIXEL OF oDlgAut //COLOR CLR_BLUE
	@ 030,090 say   CPRODUTO  		            SIZE 080,10 PIXEL oF oDlgAut FONT oArial14 COLOR CLR_RED
	@ 045,015 say   'Quantidade :'              SIZE 080,10 PIXEL OF oDlgAut //COLOR CLR_BLUE
	@ 045,090 MSGet nQuant   Picture '@E 99999999.99'   Valid  !Empty(nQuant) SIZE 080,10  PIXEL of oDlgAut COLOR CLR_BLUE
	@ 060,015 say   'Tipo (S-scrap, R-Refugo):' SIZE 080,10 PIXEL OF oDlgAut //COLOR CLR_BLUE
	@ 060,090 MSGet cTipo2   Picture '@E' valid Pertence("SR") SIZE 080,10  PIXEL of oDlgAut COLOR CLR_BLUE
	@ 075,015 Say   'Almoxarifado'              SIZE 080,10 PIXEL OF oDlgAut //COLOR CLR_BLUE
	@ 075,090 MsGet cAlmox   Picture '@E' Valid ExistCpo('NNR',cAlmox) F3 'NNR' SIZE 080,10  PIXEL of oDlgAut COLOR CLR_BLUE
	@ 090,015 Say   'Endereco    '              SIZE 080,10 PIXEL OF oDlgAut //COLOR CLR_BLUE
	@ 090,090 MsGet cEndOri  Picture '@!' Valid ExistCpo('SBE',cAlmox+cEndOri) F3 'SBE' SIZE 080,10  PIXEL of oDlgAut COLOR CLR_BLUE
	@ 105,015 Say   'Tem Solic.? '              SIZE 080,10 PIXEL OF oDlgAut //COLOR CLR_BLUE
	@ 105,090 MsGet cSolic   Picture '@!' Valid Pertence('SN') SIZE 080,10  PIXEL of oDlgAut COLOR CLR_BLUE
	@ 120,015 Say   'Motivo      '              SIZE 080,10 PIXEL OF oDlgAut //COLOR CLR_BLUE
	@ 120,090 MsGet cCodMot  Picture '@!' Valid ExistCpo('SZC',cCodMot) F3 'SZC' SIZE 080,10  PIXEL of oDlgAut COLOR CLR_BLUE    
	@ 135,015 Say   'Observacao  '              								 SIZE 080,10 PIXEL OF oDlgAut //COLOR CLR_BLUE
	@ 135,090 MsGet cObs     Picture '@!'                                        SIZE 080,10  PIXEL of oDlgAut COLOR CLR_BLUE
	//
	@ 150,070 BUTTON "OK"                       SIZE 40,15 ACTION MsAguarde({|| Perda(nQuant,COP,cTipo2,cAlmox,cEndOri,cSolic,cCodMot,cObs), Close(oDlgAut)},'Processando...') PIXEL OF oDlgAut
	@ 150,120 BUTTON "Sair"                     SIZE 40,15 ACTION MsAguarde({|| Close(oDlgAut)},'Processando...') PIXEL OF oDlgAut
	ACTIVATE MSDIALOG oDlgAut CENTERED
	Return

Return Nil

Static Function Perda(nQuant,COP,cTipo2,cAlmox,cEndOri,cSolic,cCodMot,cObs)
	//Local aArea := GetArea()
	Local nCol_cpo1 := U_Posicao2("BC_PRODUTO")
	Local nCol_cpo2 := U_Posicao2("BC_LOCORIG")
	Local nCol_cpo3 := U_Posicao2("BC_QUANT")
	Local nCol_cpo4 := U_Posicao2("BC_CODDEST")
	Local nCol_cpo5 := U_Posicao2("BC_QTDDEST")
	Local nCol_cpo6 := U_Posicao2("BC_DATA")
	Local nCol_cpo7 := U_Posicao2("BC_DESC")
	Local nCol_cpo8 := U_Posicao2("BC_TIPO")
	Local nCol_cpo9 := U_Posicao2("BC_LOCAL")
	Local nCol_cpo10:= U_Posicao2("BC_LOCDEST")
	Local nCol_cpo11:= U_Posicao2("BC_APLIC")
	Local nCol_cpo12:= U_Posicao2("BC_LOCALIZ")
	Local nCol_cpo13:= U_Posicao2("BC_MOTIVO")
	Local nCol_cpo14:= U_Posicao2("BC_DESCRI")
	Local nCol_cpo15:= U_Posicao2("BC_OBS")
	Local nCol_cpo16:= U_Posicao2("BC_GERAREQ")
	//
	If select("TM1")>0
		TM1->(dbCloseArea())
	Endif

	cQuery:= " SELECT ((SD4.D4_QTDEORI / SC2.C2_QUANT)* "+Alltrim(Str(nQuant))+") AS QTDORI, SD4.D4_COD, SC2.C2_CC "
	cQuery+= " FROM "+RetSqlName('SC2')+" SC2 "
	cQuery+= "     INNER JOIN "+RetSqlName('SD4')+" SD4 "
	cQuery+= "     ON (SD4.D_E_L_E_T_<>'*' "
	cQuery+= "         AND SD4.D4_FILIAL = SC2.C2_FILIAL "
	cQuery+= "         AND SD4.D4_OP = '"+COP+"' )"
	cQuery+= " WHERE SC2.D_E_L_E_T_<>'*' "
	cQuery+= "      AND SC2.C2_FILIAL = '"+xFilial('SC2')+"' "
	cQuery+= "      AND SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN  = '"+COP+"'
	DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TM1",.F.,.T.)

	DbSelectArea("TM1")
	TM1->(DbGotop())
	lFlag:=iif( LEN(aCols)<=1,.t.,.f.)
	lFlag2:=iif( LEN(aCols)<=1,.t.,.f.)
	While TM1->(!Eof()) .and. lFlag2
		If lFlag
			lFlag:= .f.   
		Else     
			aadd(aCols, Array(len(aHeader)+1))  
			For nCntFor := 1 To Len(aHeader)
				If	aHeader[nCntFor,8] == "C"
					aCols[Len(aCols),nCntFor]:= Space(aHeader[nCntFor,4])
				ElseIf	aHeader[nCntFor,8] == "D"	
					aCols[Len(aCols),nCntFor]:= ctod(" / / ")
				Else
					aCols[Len(aCols),nCntFor]:= 0
				EndIf
			Next
			aCols[Len(aCols),Len(aHeader)+1]:=.F.
			n:=n+1
		Endif

		aCols[len(aCols)][nCol_cpo1] := TM1->D4_COD
		aCols[len(aCols)][nCol_cpo2] := cAlmox
		aCols[len(aCols)][nCol_cpo3] := TM1->QTDORI
		aCols[len(aCols)][nCol_cpo4] := TM1->D4_COD  
		aCols[len(aCols)][nCol_cpo5] := TM1->QTDORI
		aCols[len(aCols)][nCol_cpo6] := dDatabase
		aCols[len(aCols)][nCol_cpo7] := Posicione("SB1",1,xFilial("SB1")+TM1->D4_COD,"B1_DESC")
		aCols[len(aCols)][nCol_cpo8] := cTipo2
		aCols[len(aCols)][nCol_cpo9] := IIf(cTipo2 = 'S','50','40')
		aCols[len(aCols)][nCol_cpo10]:= IIf(cTipo2 = 'S','SCRAP','REFUGO')
		aCols[len(aCols)][nCol_cpo11]:= IIf(cTipo2 = 'S',TM1->C2_CC,Space(9))
		//
		aCols[len(aCols)][nCol_cpo12]:= cEndOri
		aCols[len(aCols)][nCol_cpo13]:= cCodMot
		aCols[len(aCols)][nCol_cpo14]:= Posicione("SZC",1,xFilial("SZC")+cCodMot,"ZC_DESC")
		aCols[len(aCols)][nCol_cpo15]:= cObs
		aCols[len(aCols)][nCol_cpo16]:= cSolic
		//  
		TM1->(DbSkip())
	End             

	n:= Len(aCols)

	If select("TM1")>0
		TM1->(DbCloseArea())
	Endif

	//RestArea(aArea)

Return Nil  

User Function Posicao2(pCampo)
	cCampo := pCampo+Space(10-Len(pCampo))
	nPos := AScan(aHeader,{|x| AllTrim(x[2]) == AllTrim(cCampo) })
Return(nPos)
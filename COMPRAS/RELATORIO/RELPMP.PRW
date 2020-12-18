#INCLUDE "rwmake.ch"
//#INCLUDE "Protheus.ch"   // Problema com a janela inicial
#include "ap5mail.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

USER FUNCTION RELPMP()

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё DECLARACAO DE VARIAVEIS UTILIZADAS NO PROGRAMA ATRAVES DA FUNCAO    Ё
	//Ё SETPRVT, QUE CRIARA SOMENTE AS VARIAVEIS DEFINIDAS PELO USUARIO,    Ё
	//Ё IDENTIFICANDO AS VARIAVEIS PUBLICAS DO SISTEMA UTILIZADAS NO CODIGO Ё
	//Ё INCLUIDO PELO ASSISTENTE DE CONVERSAO DO AP5 IDE                    Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

	SETPRVT("CBTXT,CBCONT,CABEC1,CABEC2,WNREL,TITULO")
	SETPRVT("CDESC1,CDESC2,CDESC3,TAMANHO,LIMITE,XSAIDA")
	SETPRVT("AORD,LCONTINUA,CUM,LEND,ARETURN,NOMEPROG")
	SETPRVT("NLASTKEY,CPERG,XCPI,GQUANT,GF_MPN,GF_MPI")
	SETPRVT("XCOMP,XDATA,XDATFCH,XMES,XCOMPRA,XDATFIN")
	SETPRVT("CDATINI,CDATFIN,XDATINI,XSALPED,CSTRING")
	SETPRVT("XMRP,XCOMPRA,APDTS,XGERMES,dValIni,dValFin,xEmpresa") 


	/*
	эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
	╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
	╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
	╠╠ЁFun┤┘o    Ё RELPMP   Ё Autor Ё Jefferson Moreira     Ё Data Ё 27/02/08 Ё╠╠
	╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
	╠╠ЁDescri┘o  Ё                                                            Ё╠╠
	╠╠Ё          Ё                                                            Ё╠╠
	╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
	╠╠ЁSintaxe e Ё RELPMP                                                     Ё╠╠
	╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
	╠╠ЁParametrosЁ                                                            Ё╠╠
	╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
	╠╠Ё Uso      Ё Generico                                                   Ё╠╠
	╠╠цддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
	╠╠Ё         ATUALIZACOES SOFRIDAS DESDE A CONSTRU─AO INICIAL.             Ё╠╠
	╠╠цддддддддддддбддддддддбддддддбдддддддддддддддддддддддддддддддддддддддддд╢╠╠
	╠╠ЁProgramador Ё Data   Ё BOPS Ё  Motivo da Alteracao                     Ё╠╠
	╠╠цддддддддддддеддддддддеддддддедддддддддддддддддддддддддддддддддддддддддд╢╠╠
	╠╠Ё            Ё        Ё      Ё                                          Ё╠╠ 
	╠╠юддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддддды╠╠
	╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
	*/

	/*/
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё DEFINE VARIAVEIS                                             Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	*/

	titulo    := PADC("Relatorio de PMP MЙs a MЙs",30)
	cDesc1    := PADC("Este Programa tem como objetivo, emitir a relacao de PMPs    ",64)
	cDesc2    := PADC("Conforme especificacoes em Parametros."    ,58)
	cDesc3    := ""
	TAMANHO   := "G"
	LIMITE    := 220
	CSTRING   := "SHC"
	AORD      := {"Produto","Data"} //-- ORDEM
	LCONTINUA := .T.
	CUM       := ""
	LEND      := .F.
	ARETURN   := { "ZEBRADO", 1,"ADMINISTRACAO", 2, 2, 1, "",1 }
	NOMEPROG  := "RELPMP"
	NLASTKEY  := 0
	CPERG     := "RELPMP"
	CMES      := {}
	aCod      := {}
	PMP       := {}
	xTotTota  := 0   


	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё VERIFICA AS PERGUNTAS SELECIONADAS                          Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

	Pergunte( cPerg,.F.)

	aAdd( cMES, {"JAN", "31", "08"})
	aAdd( cMES, {"FEV", "28", "09"})
	aAdd( cMES, {"MAR", "31", "10"})
	aAdd( cMES, {"ABR", "30", "11"})
	aAdd( cMES, {"MAI", "31", "12"})
	aAdd( cMES, {"JUN", "30", "01"})
	aAdd( cMES, {"JUL", "31", "02"})
	aAdd( cMES, {"AGO", "31", "03"})
	aAdd( cMES, {"SET", "30", "04"})
	aAdd( cMES, {"OUT", "31", "05"})
	aAdd( cMES, {"NOV", "30", "06"})
	aAdd( cMES, {"DEZ", "31", "07"})  


	*/
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Variaveis utilizadas para parametros                        Ё
	//Ё mv_par01             // Periodo Incial (mmaaaa)             Ё
	//Ё mv_par02             // Periodo Final  (mmaaaa)             Ё
	//Ё mv_par03             // Do Produto                          Ё
	//Ё mv_par04             // Ate o Produto                       Ё 
	//Ё mv_par05             // Nr. do Plano                        Ё
	//Ё mv_par06             // Revisao                             Ё 
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

	WNREL := "RELPMP"
	WNREL := SetPrint( CSTRING, WNREL, CPERG, @TITULO, CDESC1, CDESC2,CDESC3,.F.,aOrd,)

	IF NLASTKEY==27
		RETURN
	ENDIF

	SetDefault(aReturn,cString)

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Variaveis utilizadas para Impressao do Cabecalho e Rodape  Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cbtxt   := Space(10)
	cbcont  := 00
	li      := 80
	m_pag   := 01
	nOrdem  := aReturn[8]
	cCabec  := ""

	xQuant  := 0
	cDiaIni := "01"
	cMesIni := Val(subs(mv_par01,1,2))
	cMesFin := Val(subs(mv_par02,1,2))

	cAnoIni := Val(subs(mv_par01,3,4))
	cDiaFin := cMes[cMesFin][02]
	cAnoFin := Val(subs(mv_par02,3,4))

	cDatIni := Ctod( cDiaIni+"/"+StrZero(cMesIni,2)+"/"+StrZero(cAnoIni,4) )
	cDatFin := Ctod( cDiaFin+"/"+StrZero(cMesFin,2)+"/"+StrZero(cAnoFin,4) )
	/*
	If cMesIni <= cMesFin .And. cAnoIni < cAnoFin
	MsgStop("Periodo Estipulado, Ultrapasa 12 meses...")
	Return
	ElseIf cMesIni > cMesFin .And. cAnoIni >= cAnoFin
	MsgStop("Periodo Inicial maior que Periodo Final...")
	Return
	ElseIf cMesIni > 12 .or. cMesFin > 12
	MsgStop("Mes Invalido...")
	Return
	ElseIf cMesIni == cMesFin .And. cAnoIni == cAnoFin
	xQuant := 1
	ElseIf cMesIni < cMesFin .And. cAnoIni <= cAnoFin
	xQuant := DateDiffMonth( cDatIni , cDatFin ) +1 //Apura Diferenca em Meses entre duas Datas
	ElseIf cMesIni > cMesFin .And. cAnoIni < cAnoFin
	xQuant := DateDiffMonth( cDatIni , cDatFin ) +1 //Apura Diferenca em Meses entre duas Datas
	End
	*/

	// --------------------------------------------
	// Monta cabecalho para impressao de relatorio.
	// --------------------------------------------
	xCOL   := 040
	xPOS   := {}
	xMESES := {}

	xIni := cDatIni
	
	While xIni <= cDatFin
		If aScan( xMeses ,{|x| x[1] == Year(xIni) .and. x[2] == Month(xIni) } ) == 0

			aAdd( xMESES, { YEAR(xIni), MONTH(xIni)} )
			aAdd( xPOS, xCOL )

			cCabec  := cCabec + Padr(cMes[MONTH(xIni)][1]+"/"+Subs(StrZero(year(xIni),4),3,2), 9)+" "

			//xCol := xCol + 9
			xQuant++
		Endif
		xIni := xIni + 1
	EndDo

	If MsgYesNo(" Informar ObservaГЦo no RelatСrio ? ")
		xDesc := Space(80)

		@ 96,42  TO 323,505 DIALOG oDlg5 TITLE "ObservaГЦo"
		@ 08,10  TO 84,222
		@ 45,20  SAY "ObservaГЦo: " 
		@ 45,50  Get xDesc  PICTURE "@!   "             
		@ 91,168 BMPBUTTON TYPE 1 ACTION Close(oDlg5)
		ACTIVATE DIALOG oDlg5
	else 
		xDesc := ""
	endif


	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Definicao dos cabecalhos                                     Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

	titulo := "PMP - Plano Mestre de Producao"
	cabec1 := "Entre: "+dtoc(cDatIni)+" a "+dtoc(cDatFin) + Space(20) + cCabec 
	cabec2 := "Codigo           Descricao"+ Space(187) + "Total"
	//         xxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  9,999,999  9.999.999  9.999.999 99.999.999
	//         Ativo,Dispos.,Tela,Equip...          JAN/2006        JAN/2006
	//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	//                   111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999
	//         Codigo          Descricao                 JAN/18    FEV/18    MAR/18    ABR/18    MAI/18    JUN/18    JUL/18    AGO/18    SET/18    OUT/18    NOV/18    DEZ/18    JAN/19    FEV/19    MAR/19    ABR/19              Total                   
	//         123456789012345 1234567890123456789012345 9,999,999 9,999,999 9,999,999 9,999,999 9,999,999 9,999,999 9,999,999 9,999,999 9,999,999 9,999,999 9,999,999 9,999,999 9,999,999 9,999,999 9,999,999 9,999,999     999,999,999
	//         0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111222222222222222222222
	//         0000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999000000000011111111112
	//         1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	If nLastKey == 27
		Return
	Endif

	nTipo  := IIF(aReturn[4]==1,15,18)

	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)

	RptStatus({|| DetRelPMP()})
Return
//
//
//
Static Function DetRelPMP()

	PMP  := GetPMP()    // Retorna aProd

	If nOrdem == 1                      
		aSort( PMP ,,,{ |x,y| x[1] + StrZero(x[2],2) < y[1] + StrZero(y[2],2)} ) 
	Else
		aSort( PMP ,,,{ |x,y| StrZero(x[2],2) + x[1]  < StrZero(y[2],2)+y[1] } )
	EndIf

	For n:=1 to len(PMP)    
		
		nPos := aScan( aCod ,{|x| x[1] == PMP[ n, 1] }) 
		
		If nPos == 0
			aAdd(aCod, {PMP[ n, 1] } )  	
		EndIf

	Next

	aImp     := Array( xQuant, 1 )
	xTotal   := Array( xQuant, 1 )
	xTotal2  := Array( xQuant, 1 )

	//Zerar vetores
	For n := 1 to xQuant

		aImp[ n, 1]     := 0
		xTotal[ n, 1]   := 0
		xTotal2[ n, 1 ] := 0
	Next
	
	if !empty(xDesc)
		@ li,000 PSay "Nr. do Plano: "+mv_par05+" Revisao Nr.: "+mv_par06+" Obs.: " + xDesc
		li += 2
	endif

	SetRegua( Len(aCod) ) 
	
	For i:=1 to Len( aCod )
		xProd := aCod[i][1]
		IncRegua("Produto: " + xProd )

		For m:=1 to xQuant

			nMes  := xMeses[ m, 2]
			nAno  := xMeses[ m, 1]
			nPos1 := aScan(PMP ,{|X| X[1] == xProd .and. X[2]== nMes .and. x[4] = nAno}) 

			aIMP[m, 1] := IIF(nPos1<>0, PMP[nPos1,3], 0)   // Plano

		Next

		xProdDes := Posicione("SB1",1,xFilial("SB1")+xProd,"B1_DESC")

		@ LI,000 PSAY xProd //+"  "+ xProdDes
		@ LI,017 PSAY SubString(xProdDes, 1, 25) 

		xTot := 0
		xCol := 44

		For m := 1 to xQuant
                         
			@ Li, xCol PSAY Transform(aImp[ m, 1 ], "@E 9,999,999")
				
			xTot += aImp[ m, 1]
			xTotal[ m, 1] += aImp[ m, 1]

			xCol += 10
		Next

		@ LI,207 PSAY Transform (xTot,"@E 999,999,999")  // Total por Produto
		xTotTota += xTot
        
		If Li > 64
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)	
		End
		Li += 1
		//Next

	Next  
	Li += 1
	@ LI,000 PSAY "Total Geral                                                        "
	xCol := 43
	For J:=1 to xQuant                                            
		@ LI, xCol PSAY Transform(xTotal[j][1],"@E 9,999,999")
		xCol += 10
	next

	@ LI,207 PSAY Transform (xTotTota, "@E 999,999,999")  // Total por Produto
	IF li != 85
		roda(cbcont,cbtxt,tamanho)
	EndIF

	Set Device To Screen

	dbSelectArea('SHC')
	RetIndex('SHC')

	If aReturn[5] == 1
		Set Printer to
		dbCommitAll()
		ourspool(wnrel)
	Endif
	MS_FLUSH()      
Return


//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Retorna os valores gastos com materiais mes a mes            Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

Static Function GetPMP()
	aPMP  :={}

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Variaveis utilizadas para parametros                        Ё
	//Ё mv_par01             // Periodo Incial (mmaaaa)             Ё
	//Ё mv_par02             // Periodo Final  (mmaaaa)             Ё
	//Ё mv_par03             // Do Tipo                             Ё
	//Ё mv_par04             // Ate o Tipo                          Ё
	//Ё mv_par05             // CCusto                              Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

	cQuery := " SELECT HC_PRODUTO, YEAR(HC_DATA) AS ANO, MONTH(HC_DATA) AS MES, SUM(HC_QUANT)AS PLANO "
	cQuery += " FROM " + RetSqlName("SHC") + " "
	cQuery += " WHERE HC_DATA >= '"+ DTOS(cDatIni)+"'"
	cQuery += "   AND HC_DATA <= '"+ DTOS(cDatFin)+"'" 
	cQuery += "   AND HC_DTVIGEN >= '"+ DTOS(cDatIni)+"'"
	cQuery += "   AND HC_DTVIGEN <= '"+ DTOS(cDatFin)+"'" 
	cQuery += "   AND HC_PRODUTO >= '"+ MV_PAR03 +"'"
	cQuery += "   AND HC_PRODUTO <= '"+ MV_PAR04 +"'"
	cQuery += "   AND HC_NUMPLAN = '"+ MV_PAR05 +"'"
	cQuery += "   AND HC_REVISAO = '"+ MV_PAR06 +"'"
	cQuery += "   AND D_E_L_E_T_ = ''"
	cQuery += " GROUP BY HC_PRODUTO, MONTH(HC_DATA),YEAR(HC_DATA)"
	cQuery += " ORDER BY HC_PRODUTO, YEAR(HC_DATA), MONTH(HC_DATA)"

	cQuery := ChangeQuery(cQuery)
	TCQUERY cQuery Alias THC New 


	DbSElectArea("THC")       // Plano de Producao
	DbGotop() 
	While !THC->(Eof())

		AAdd(aPMP,{HC_PRODUTO,; // [1] Cod Produto
		MES,;   // [2] Mes 
		PLANO,; // [3] Plano de Producao
		ANO})   // [4] Ano

		THC->(DBSKIP())

	ENDDO 

	dbClearFil(NIL)
	dbCloseArea("THC")
	dbCloseArea()
Return aPMP 


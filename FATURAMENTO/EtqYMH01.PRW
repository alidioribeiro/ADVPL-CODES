#Include "rwmake.ch"

/*_______________________________________________________________________________
¦ Função    ¦ EtqYMH01   ¦ Autor ¦ Adson Carlos             ¦ Data ¦ 26/04/2010 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Impressão da Etiqueta da YAMAHA.                                  ¦	
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function NSESTY01()
	Private oDlg1 
	private cPerg := "NSESTY01"

	ValidPerg(cPerg)
	Pergunte(cPerg,.f.)

	@ 96,042 TO 323,505 DIALOG oDlg1 TITLE "Geração de Etiquetas YAMAHA"
	@ 08,010 TO 84,222
	@ 23,014 SAY "Esta rotina irá importar as informações de Vendas para imprimir as "
	@ 33,014 SAY "etiquetas enviadas à YAMAHA."
	@ 91,139 BMPBUTTON TYPE 5 ACTION Pergunte(cPerg)
	@ 91,168 BMPBUTTON TYPE 1 ACTION EtqYMH01a()
	@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
	ACTIVATE DIALOG oDlg1

Return Nil

//********************************************************************

Static Function EtqYMH01a()
	Local nCntEtq := 0
	Local nQtdEtq := 0
	Local nTotEtq := 0
	Local nSalEtq := 0
	Local nNumEtq := 0
	Private cLotes := ""

	/*
	If mv_par03 == 0 
	MsgStop("A quantidade nas caixas deve ser maior que 0 (zero)!")
	Return Nil
	EndIf
	*/
	Close(oDlg1)

	MsgRun("Preparando Ambiente...","Aguarde...",{|| EtqHda01b() })

	nEtiq := 0
	ETQ->( dbGoTop() )              
	Begin Transaction
		While !ETQ->(Eof())
			nQuant := ETQ->D2_QUANT
			nCont  := 0

			If ETQ->B1_QE <> 0
				_nEtiquetas := ETQ->D2_QUANT / ETQ->B1_QE
				_nQtdEtiq   := ETQ->B1_QE
			Else
				MsgInfo("O Item " + ETQ->D2_ITEM + " ( Cód: "+ ETQ->D2_COD + " ) não possui quantidade por embalagem cadastrado. Não serão impressas as etiquetas")
				ETQ->(dbSkip())
				Loop
			EndIf
       
			While nQuant > 0
				nCont++ 
				nEtiq++ 

				If (nQuant < _nQtdEtiq) 
					EtqHda01u(nQuant,    StrZero(nCont,5), StrZero(nEtiq,3))
				Else 
					EtqHda01u(_nQtdEtiq, StrZero(nCont,5), StrZero(nEtiq,3))		      
				EndIf                 

				nQuant -= _nQtdEtiq
			End

			ETQ->(dbSkip())	 
		End
	End Transaction
	Etq->(dbCloseArea())
Return Nil

//**********************************************************************************

Static Function EtqHda01b()
	Local cQuery := ""

	cQuery := "SELECT D2_DOC, D2_ITEM, C6_PEDCLI, A7_CODCLI, D2_COD, D2_LOTECTL, B1_DESC, SUM(D2_QUANT) AS D2_QUANT, MAX(B1_QE) AS B1_QE"
	cQuery += "	FROM " + RetSQLName("SD2") + " SD2"
	cQuery += " INNER JOIN " + RetSqlName("SC6") + " SC6 ON SC6.D_E_L_E_T_='' AND D2_PEDIDO=C6_NUM AND D2_ITEMPV=C6_ITEM AND D2_COD=C6_PRODUTO "
	cQuery += "	INNER JOIN " + RetSQLName("SB1") + " SB1 ON SB1.D_E_L_E_T_='' AND B1_COD=D2_COD AND B1_FILIAL=D2_FILIAL "
	cQuery += " INNER JOIN " + RetSQLName("SA7") + " SA7 ON SA7.D_E_L_E_T_='' AND A7_CLIENTE=D2_CLIENTE AND A7_LOJA=D2_LOJA AND A7_PRODUTO=D2_COD " 
	cQuery += "WHERE SD2.D_E_L_E_T_ = '' "
	cQuery += "	 AND D2_FILIAL = '" + SD2->(xFilial()) + "'"
	cQuery += "	 AND D2_DOC    = '" + Mv_Par01 + "'"
	cQuery += "	 AND D2_SERIE  = '" + Mv_Par02 + "'"
	If !Empty(mv_par03)
		cQuery += "  AND D2_ITEM = '" + StrZero( Val(mv_par03),2)+ "' "
	EndIf
	cQuery += "	 AND D2_COD = B1_COD"                                                      
	cQuery += " GROUP By D2_DOC, D2_ITEM, C6_PEDCLI, A7_CODCLI, D2_COD, D2_LOTECTL, B1_DESC "
	cQuery += " ORDER BY D2_DOC, D2_ITEM, D2_COD"

	Memowrit("ETQYAMA.SQL",cQuery)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "ETQ", .T., .T.)
Return Nil

//**************************************************************************************************

Static Function EtqHda01u(nwQtde, cwItem, cwEtiq)
	Local cPorta := "LPT1" 

	MsCbPrinter("Z4M","LPT1",17,,.F.,,,,)
	MsCbChkStatus(.F.)

	MsCbBegin( 1, 2)  

	MSCBWRITE("^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ^XA^MMT^PW1228^LL0874^LS0")

	MSCBWRITE("^FO29,30^GB1183,835,6^FS^FO32,741^GB1177,0,5^FS^FO34,619^GB1177,0,5^FS^FO30,501^GB1178,0,6^FS^FO34,383^GB1177,0,5^FS")
	MSCBWRITE("^FO32,264^GB1177,0,5^FS^FO33,149^GB1178,0,5^FS^FO228,625^GB0,121,5^FS^FO660,621^GB0,121,5^FS^FO660,503^GB0,121,5^FS")
	MSCBWRITE("^FO821,265^GB0,121,5^FS^FO466,267^GB0,121,5^FS^FO1004,29^GB0,121,5^FS^FO849,32^GB0,121,6^FS")

	cCodBar := '5249' + SubStr(DTOS(dDatabase),7,2)+SubStr(DTOS(dDatabase),5,2)+SubStr(DTOS(dDatabase),3,2) + cwItem 

	// 1o. Quadro - 1a. Parte

	nwColAux := 070
	MSCBWRITE("^FT47,76^A0N,33,33^FH\^FDLPN:^FS")
	MSCBWRITE("^FT47,127^A0N,42,40^FH\^FD" + cCodBar + "^FS")     

	MSCBWRITE("^FT881,110^A0N,58,60^FH\^FD" + AllTrim(Posicione("SB5",1,xFilial("SB5")+ETQ->D2_COD,"B5_QUAL")) + "^FS")

	// 2o. Quadro - 1a. Parte 

	MSCBWRITE("^BY3,3,69^FT311,232^BCN,,N,N^FD>:" + cCodBar + "^FS")  
	MSCBWRITE("^FT522,261^A0N,21,21^FH\^FD" + cCodBar + "^FS")

	// 3o. Quadro - 1a. Parte     

	MSCBWRITE("^FT47,314^A0N,33,33^FH\^FD"  + "CODIGO:"   + "^FS")
	MSCBWRITE("^FT482,314^A0N,33,33^FH\^FD" + "SUPPLIER:" + "^FS")
	MSCBWRITE("^FT844,314^A0N,33,33^FH\^FD" + "USER:"     + "^FS")
	MSCBWRITE("^FT47,362^A0N,42,40^FH\^FD" + StrTran(SubStr(Etq->A7_CODCLI, 1, 18), "-", "") + "^FS")
	MSCBWRITE("^FT482,362^A0N,42,40^FH\^FD" + "5249" + "^FS")
	MSCBWRITE("^FT844,362^A0N,42,40^FH\^FD" + "9219" + "^FS")

	// 4o. Quadro - 1a. Parte 

	cCodBar  := AllTrim( StrTran(SubStr(Etq->A7_CODCLI, 1, 18), "-", "") ) + "-" + "5249" + "-" + "9219"
	MSCBWRITE("^BY3,3,69^FT156,471^BCN,,N,N^FD>:" + cCodBar + "^FS")  
	MSCBWRITE("^FT453,496^A0N,21,21^FH\^FD" + cCodBar + "^FS")  

	// 5o. Quadro - 1a. Parte                          

	MSCBWRITE("^FT47,550^A0N,33,33^FH\^FDNOME:^FS")
	MSCBWRITE("^FT675,550^A0N,33,33^FH\^FDFORNECEDOR:^FS")
	MSCBWRITE("^FT47,596^A0N,40,40^FH\^FD" + SubStr(Etq->B1_DESC,1,25) + "^FS")
	MSCBWRITE("^FT705,596^A0N,42,40^FH\^FD" + "NIPPON SEIKI" + "^FS")

	// 6o. Quadro - 1a. Parte

	cTxt003  := Alltrim(Transform(nwQtde, "9999999999"))  

	MSCBWRITE("^FT47 ,672^A0N,33,33^FH\^FDQTDE:^FS")
	MSCBWRITE("^FT249,672^A0N,33,33^FH\^FDNF/INVOICE:^FS")
	MSCBWRITE("^FT674,672^A0N,33,33^FH\^FDUSO EXCLUSIVO DO FORNECEDOR:^FS") 
	MSCBWRITE("^FT47 ,722^A0N,42,40^FH\^FD" + cTxt003 + "^FS")
	MSCBWRITE("^FT249,722^A0N,42,40^FH\^FD" + Etq->D2_DOC	 + "^FS")
	MSCBWRITE("^FT996,701^A0N,25,24^FH\^FDDATA: "   + DtoC(dDataBase) + "^FS")
	MSCBWRITE("^FT688,701^A0N,25,24^FH\^FDPEDIDO: " + ETQ->C6_PEDCLI  + "^FS")
	MSCBWRITE("^FT996,725^A0N,25,24^FH\^FDLOTE: "   + ETQ->D2_LOTECTL + "^FS")
	MSCBWRITE("^FT688,725^A0N,25,24^FH\^FDCODIGO:"   + ETQ->D2_COD     + "^FS")

	// 7o. Quadro - 2a. Parte

	cCodBar := cTxt003
	MSCBWRITE("^BY3,3,59^FT70,825^BCN,,N,N^FD>:" + cCodBar + "^FS")   
	MSCBWRITE("^FT171,853^A0N,21,21^FH\^FD" + cCodBar + "^FS")
	MSCBWRITE("^PQ1,0,1,Y^XZ")  

	MsCbEnd()

	MsCbClosePrinter()

Return .T.

//**********************************************************************************************

Static Function ValidPerg(cPerg)

	PutSX1(cPerg,"01","Nota Fiscal", "", "", "mv_ch1", "C", 09, 0, 0,"G","","","","","mv_par01")
	PutSX1(cPerg,"02","Série",		 "", "", "mv_ch2", "C", 03, 0, 0,"G","","","","","mv_par02")  
	PutSX1(cPerg,"03","Item",        "", "", "mv_ch3", "C", 03, 0, 0,"G","","","","","mv_par03")

Return Nil
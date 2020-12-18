#include 'protheus.ch'
#include 'parmtype.ch'
#include 'tbiconn.ch'
#include 'fvexcel.ch'

#define _Enter Chr(13) + Chr(10)

User FUnction PCPLISCRI()
	Local oExcel    := FvExcel():New()
	Local oTimes08  := FvFont():New("Times New Roman","",08)
	Local oTimes08N := FvFont():New("Times New Roman","",08,,.T.)
	Local aCodPais  := {}
	Local adEstrut  := {}
	Local aColunas  := {}
	Local aField    := {}
	Local aMeses    := {}
	Local aTransito := {}
	Local nPosSaldo := 0

	aAdd(aCodPais,{"A01004",00})
	aAdd(aCodPais,{"C01002",00})
	aAdd(aCodPais,{"C01004",00})
	aAdd(aCodPais,{"C01007",00})
	aAdd(aCodPais,{"C01008",00})
	aAdd(aCodPais,{"C01009",00})
	aAdd(aCodPais,{"U01003",00})

	//aAdd(aCodPais,{"INVENTARIO",00})

	//aAdd(aMeses,{"INVENT",00})
	/*
	aAdd(aMeses,{"SETEMBRO",00})
	aAdd(aMeses,{"OUTUBRO" ,00})
	aAdd(aMeses,{"NOVEMBRO",00})
	aAdd(aMeses,{"DEZEMBRO",00})
	*/
	If Type("cAcesso") == "U"
		RpcSetType(3)
		RpcSetEnv("01","01")
	EndIf

	xQry := " Select C7_PRODUTO,LEFT(C7_DATPRF,6) ENTREGA,SUM(C7_QUANT - C7_QUJE) TRANSITO From " + RetSqlName("SC7") + " C7 With(Nolock) "
	xQry += " Where C7.D_E_L_E_T_ = '' "
	xQry += "   And C7_CONAPRO = 'L' " 
	xQry += "   And C7_QUJE < C7_QUANT  "
	xQry += "   And C7_PRODUTO BETWEEN '               ' AND 'ZZZZZZZZZZZZZZZ'  "     
	xQry += "   And C7_NUM     BETWEEN '      ' AND 'ZZZZZZ'  "
	xQry += "   And C7_FORNECE BETWEEN '     ' AND 'zzzzz'  "	
	xQry += "   And C7_RESIDUO = '' "
	xQry += " GROUP BY C7_PRODUTO,LEFT(C7_DATPRF,6) "
	xQry += " ORDER BY 1,2 "
	ConOUt('[Recuperando Transito]')
	xTbl := MpSysOpenQuery(xQry)

	While !(xTbl)->(Eof())

		aAdd(aTransito, { (xTbl)->C7_PRODUTO, (xTbl)->ENTREGA , (xTbl)->TRANSITO } )

		(xTbl)->(dbSkip())
	EndDo
	ConOut('[Transito Recuperado!]')
	ConOut('[Recuperado Estrutura!]')
	xQry := " Select PAI,COMPONENTE,Sum(QUANT)QUANT From FVGETESTRUTURA('') A"
	xQry += " Group by PAI,COMPONENTE"
	xQry += " Order by COMPONENTE,PAI"

	xTbl := MpSysOpenQuery(xQry)

	While !(xTbl)->(Eof())	   
		aAdd(adEstrut, { (xTbl)->PAI,(xTbl)->COMPONENTE,(xTbl)->QUANT, 00} )

		(xTbl)->(dbSkip())
	EndDo
	ConOut('[Estrutura Recuperada!]')
	//aSort(adEstrut, {| x,y | x[02] > y[02] } )

	oExcel:AddSheet("Dados Gerais")
	oExcel:AddSheet("Teste")
	oExcel:SetSheet(01)
	oExcel:Cell(01,01):SetBorder(,Border)
	oExcel:Cell(01,01):SetBackColor("#00B0F0")
	oExcel:Cell(01,02):SetValue("Desvio Positivo")
	oExcel:Cell(01,02):SetFont(oTimes08)

	oExcel:Cell(01,04):SetValue(,Border)
	oExcel:Cell(01,04):SetBackColor("#FFC000")
	oExcel:Cell(01,05):SetValue("Usar Alternativo")
	oExcel:Cell(01,05):SetFont(oTimes08)

	oExcel:Cell(02,01):SetBorder(,Border)
	oExcel:Cell(02,01):SetBackColor("#FF99CC")
	oExcel:Cell(02,02):SetValue("Desvio Negativo")
	oExcel:Cell(02,02):SetFont(oTimes08)

	oExcel:Cell(02,04):SetBorder(,Border)
	oExcel:Cell(02,04):SetBackColor("#FFFF00")
	oExcel:Cell(02,05):SetValue("Emitir PO")
	oExcel:Cell(02,05):SetFont(oTimes08)

	oExcel:Cell(03,01):SetBorder(,Border)
	oExcel:Cell(03,01):SetBackColor("#FF0000")
	oExcel:Cell(03,02):SetValue("Risco")
	oExcel:Cell(03,02):SetFont(oTimes08)

	oExcel:Cell(03,04):SetBorder(,Border)
	oExcel:Cell(03,04):SetBackColor("#00B050")
	oExcel:Cell(03,05):SetValue("Usar em mod Espec")
	oExcel:Cell(03,05):SetFont(oTimes08)

	nLine := 04
	oExcel:Cell(nLine,01):SetBorder(,Border)
	oExcel:Cell(nLine,01):SetFont(oTimes08n)
	oExcel:Cell(nLine,01):SetValue("P.NUMBER")
	oExcel:Cell(nLine,01):SetBackColor("#66FF66")

	oExcel:Cell(nLine,02):SetBorder(,Border)
	oExcel:Cell(nLine,02):SetFont(oTimes08n)
	oExcel:Cell(nLine,02):SetValue("DESCRICAO")
	oExcel:Cell(nLine,02):SetBackColor("#66FF66")

	oExcel:Cell(nLine,03):SetBorder(,Border)
	oExcel:Cell(nLine,03):SetFont(oTimes08n)
	oExcel:Cell(nLine,03):SetValue("UM")
	oExcel:Cell(nLine,03):SetBackColor("#66FF66")

	oExcel:Cell(nLine,04):SetBorder(,Border)
	oExcel:Cell(nLine,04):SetFont(oTimes08n)
	oExcel:Cell(nLine,04):SetValue("GRP. OPC.")
	oExcel:Cell(nLine,04):SetBackColor("#66FF66")

	oExcel:Cell(nLine,05):SetBorder(,Border)
	oExcel:Cell(nLine,05):SetFont(oTimes08n)
	oExcel:Cell(nLine,05):SetValue("LCE CODE")
	oExcel:Cell(nLine,05):SetBackColor("#66FF66")
    
    oExcel:Cell(nLine,06):SetBorder(,Border)
	oExcel:Cell(nLine,06):SetFont(oTimes08n)
	oExcel:Cell(nLine,06):SetValue("TIPO")
	oExcel:Cell(nLine,06):SetBackColor("#66FF66")
    
	nLCabec := nLine
	nColPA  := 07

	For _xdS := 01 To Len(aCodPais)
		oExcel:Cell(nLCabec,nColPA):SetFont(oTimes08n)
		oExcel:Cell(nLCabec,nColPA):SetValue( aCodPais[_xdS][01] )
		oExcel:Cell(nLCabec,nColPA):SetBackColor("")
		aCodPais[_xdS][02] := nColPA
		nColPA++
	Next
	nPosSaldo := nColPA
    //nColPA++
	ConOUt('Recuperando Data MRP')
	xSH5 := MpSysOpenQuery(" Select * From SH5010 H5 With(Nolock) WHERE H5_PER = '001' AND H5_NIVEL = '01' AND H5_ALIAS = 'PAR'")

	xData := STOD( (xSH5)->H5_DATAORI)
	ConOUt('Data MRP Recuperada')

	oExcel:Cell(nLCabec-01,nPosSaldo):SetFont(oTimes08n)
	oExcel:Cell(nLCabec-01,nPosSaldo):SetValue( DTOC(xData) )
	oExcel:Cell(nLCabec-01,nPosSaldo):SetBackColor("#66FF66")
	oExcel:Cell(nLCabec-01,nPosSaldo):SetBorder(,Dense)

	oExcel:Cell(nLCabec,nPosSaldo):SetFont(oTimes08n)
	oExcel:Cell(nLCabec,nPosSaldo):SetValue( "INVENTARIO" )
	oExcel:Cell(nLCabec,nPosSaldo):SetBackColor("#66FF66")
	oExcel:Cell(nLCabec,nPosSaldo):SetBorder(,Dense)
	oExcel:Cell(nLCabec-01,nPosSaldo):SetBorder(_Bottom, Single)

	nColPA++
	
	ConOut('[Recuperando MRP!]')
	_xQry := " Select * From SHA010 HA With(Nolock)"
	_xQry += "     Inner Join ( SELECT B1_COD,B1_DESC,B1_TIPO,B1_UM,B1_GRUPO FROM SB1010 B1 WITH(NOLOCK) WHERE B1.D_E_L_E_T_ = ' ' AND B1_TIPO not IN('PA') )B1 ON B1_COD = HA_PRODUTO 
	_xQry += "  Where D_E_L_E_T_E_D = ' '" 
	_xQry += "   And HA_TIPO In('1','3','4') "
	//_xQry += "   And HA_PER001  > 0 "
	_xQry += "   Order By HA_PRODUTO,HA_TIPO"
	//_xQry += "   And HA_PRODUTO = '1-1910164-0'"    

	xTbl := MpSysOpenQuery(_xQry)
	ConOut('[MRP Recuperado!]')
	nLine++
	SB1->(dbSetOrder(1))	
	aStruct := (xTbl)->(dbStruct())

	ConOUt('Montando Estrutura Excel')
	For _xdJ := 01 To Len(aStruct)
		If "HA_PER"$aStruct[_xdJ][01]
			nInt := Val(Right(aStruct[_xdJ][01],3))

			nDia := Dow(xData)
			If nDia == 07
				xData += 02
			ElseIf nDia == 01
				xData += 01
			EndIf

			nMonth := Month(xData)
			xMes := aScan(aMeses,{|x| x[01] == nMonth })
			If xMes == 0

				oExcel:Cell(nLCabec-01,nColPA):SetFont(oTimes08n)
				oExcel:Cell(nLCabec-01,nColPA):SetValue( cMonth(xData) )
				oExcel:Cell(nLCabec-01,nColPA):SetColSpan(02)
				oExcel:Cell(nLCabec-01,nColPA):SetAlignment(Horizontal,_Center)
				oExcel:Cell(nLCabec-01,nColPA):SetBackColor(If(Len(aMeses) % 2 == 0,"#A6A6A6","#FFD966"))	          
				oExcel:Cell(nLCabec-01,nColPA):SetBorder(,Dense)
				oExcel:Cell(nLCabec-01,nColPA):SetBorder(_Bottom,Single)

				oExcel:Cell(nLCabec,nColPA):SetFont(oTimes08n)
				oExcel:Cell(nLCabec,nColPA):SetValue("Demanda")
				oExcel:Cell(nLCabec,nColPA):SetBackColor(If(Len(aMeses) % 2 == 0, "#A6A6A6","#FFD966"))
				oExcel:Cell(nLCabec,nColPA):SetBorder(_Left,Dense)
				oExcel:Cell(nLCabec,nColPA):SetBorder(_Bottom,Dense)
				nColPA++
				oExcel:Cell(nLCabec,nColPA):SetFont(oTimes08n)
				oExcel:Cell(nLCabec,nColPA):SetValue("Transito")
				oExcel:Cell(nLCabec,nColPA):SetBackColor(If(Len(aMeses) % 2 == 0, "#A6A6A6","#FFD966"))
				oExcel:Cell(nLCabec,nColPA):SetBorder(_Bottom,Dense)
				nColPA++
				oExcel:Cell(nLCabec,nColPA):SetFont(oTimes08n)
				oExcel:Cell(nLCabec,nColPA):SetValue("Balance")
				oExcel:Cell(nLCabec,nColPA):SetBackColor(If(Len(aMeses) % 2 == 0, "#A6A6A6","#FFD966"))
				oExcel:Cell(nLCabec,nColPA):SetBorder(_Bottom,Dense)
				oExcel:Cell(nLCabec,nColPA):SetBorder(_Right,Dense)
				//nColPa
				nColPA++

				aAdd(aMeses,{nMonth ,Left(DTOS(xData),6),nColPA - 03 })
				aAdd(aField,{aStruct[_xdJ][01] , nColPA - 03} )
			Else
				aAdd(aField,{aStruct[_xdJ][01] , aMeses[xMes][03]} )

			EndIf

			xData := xData + 01
			//nColPA++
		EndIf
	Next

	While !(xTbl)->(Eof())
		xdProduto := (xTbl)->HA_PRODUTO 

		SB1->(dbGoTop())
		SB1->(dbSeek(xFilial('SHA') + (xTbl)->HA_PRODUTO ) )
		if nLine == 3292
			cstop := '[stop]'
		EndIf
		oExcel:Cell(nLine,01):SetFont(FvFont():New("Times New Roman","",08))
		oExcel:Cell(nLine,01):SetValue( (xTbl)->HA_PRODUTO )

		oExcel:Cell(nLine,02):SetFont(FvFont():New("Times New Roman","",08))
		oExcel:Cell(nLine,02):SetValue( EncodeUtf8(SB1->B1_DESC) )

		oExcel:Cell(nLine,03):SetFont(FvFont():New("Times New Roman","",08))
		oExcel:Cell(nLine,03):SetValue( SB1->B1_UM )
		
		oExcel:Cell(nLine,06):SetFont(FvFont():New("Times New Roman","",08))
		oExcel:Cell(nLine,06):SetValue( SB1->B1_TIPO )

		For _xdS := 01 To Len(aCodPais)         	
			oExcel:Cell(nLine,aCodPais[_xdS][02]):SetValue( 0 )
			oExcel:Cell(nLine,aCodPais[_xdS][02]):SetFont(FvFont():New("Times New Roman","",08))         	
		Next

		// Adiciona o Transito
		For _xdS := 01 To Len(aMeses)
			xPos := aScan(aTransito, {|x| x[01] == (xTbl)->HA_PRODUTO .And. aMeses[_xdS][02] == x[02] })
								
			oExcel:Cell(nLine,aMeses[_xdS][03]):SetValue( 0 )
			oExcel:Cell(nLine,aMeses[_xdS][03]):SetFont( FvFont():New("Calibri","",09) )
			oExcel:Cell(nLine,aMeses[_xdS][03]+01):SetValue( 0 )			
			oExcel:Cell(nLine,aMeses[_xdS][03]+01):SetFont( FvFont():New("Calibri","",09) )	
			oExcel:Cell(nLine,aMeses[_xdS][03]+02):SetValue( 0 )
			oExcel:Cell(nLine,aMeses[_xdS][03]+02):SetFont( FvFont():New("Calibri","",09) )
			
			If xPos > 0
				nOld := oExcel:Cell(nLine,aMeses[_xdS][03]+01):GetValue()
				If Empty(nOld)
					oExcel:Cell(nLine,aMeses[_xdS][03]+01):SetValue( aTransito[xPOs][03] )
				Else
					oExcel:Cell(nLine,aMeses[_xdS][03]+01):SetValue( aTransito[xPOs][03] + nOld  )
				EndIf
			Else
				oExcel:Cell(nLine,aMeses[_xdS][03]+01):SetValue( 0 )				  
			EndIf
		Next
		// Adiciona o Consumo
		xdComp := aScan(adEstrut, {|x| x[02] == SB1->B1_COD})
		If xdComp > 0
			While adEstrut[xdComp][02] == SB1->B1_COD
				xdPosPA := aScan(aCodPais,{|x| x[01] == ALLTRIM(adEstrut[xdComp][01]) })
				If xdPosPA > 0	              
					oExcel:Cell(nLine,aCodPais[xdPosPA][02]):SetValue(adEstrut[xdComp][03] )
					oExcel:Cell(nLine,aCodPais[xdPosPA][02]):SetFont(oTimes08n)
				EndIf	           
				xdComp++
			EndDo
		EndIf
        
        
        For _xdS := 01 To Len(aField)
           //oExcel:Cell(nLine,aField[_xdS][02]):SetFont( FvFont():New("Calibri","",09) )
           If Empty(oExcel:Cell(nLine,aField[_xdS][02]+2):GetFormula())
              oExcel:Cell(nLine,aField[_xdS][02]+2):SetFormula("RC[-" + Alltrim(Str(aField[_xdS][02]+2 - nPosSaldo)) + "]+RC[-1]-RC[-2]")
           EndIf
        Next
        
		While !(xTbl)->(Eof()) .And.  (xTbl)->HA_PRODUTO  == xdProduto
			If (xTbl)->HA_TIPO == '1'
				oExcel:Cell(nLine,nPosSaldo):SetValue( (xTbl)->HA_PER001 )
				oExcel:Cell(nLine,nPosSaldo):SetFont( FvFont():New("Calibri","",09) )
			Else
				For _xdS := 01 To Len(aField)
					nOld := oExcel:Cell(nLine,aField[_xdS][02]):GetValue()									
					If Empty(nOld)
						oExcel:Cell(nLine,aField[_xdS][02]):SetValue( (xTbl)->&(aField[_xdS][01]) )
					Else
						oExcel:Cell(nLine,aField[_xdS][02]):SetValue( (xTbl)->&(aField[_xdS][01]) + nOld )
					EndIf
				Next
			EndIf

			(xTbl)->(dbSkip())
		EndDo
		//_xdCodPA := U_PLGETPA(SB1->B1_COD)

		nLine++

		ConOut('nLine == ' + StrZero(nLine,10)) 
	EndDo 

	xFileName := GetTempPath()+'\teste.xls'
	ConOUt('Salvando Dados no ')
	oExcel:Save(xFileName)
	//MemoWrite(xFileName,oExcel:GetXml())	

	RpcClearEnv()
	/*
	If ! ApOleClient( 'MsExcel' )        //Verifica se o Excel esta instalado
	MsgStop( 'MsExcel nao instalado' ) 
	Return
	EndIf  */
	oExcelApp := MsExcel():New()                    	  // Cria um objeto para o uso do Excel
	oExcelApp:WorkBooks:Open(xFileName) 
	oExcelApp:SetVisible(.T.)   // Abre o Excel com o arquivo criado exibido na Primeira planilha.  

	oExcelApp:Destroy()

	alert('donne')
Return 

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ NSESTR08   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 19/09/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Relatório de obsolescência  1                                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
//  .--------------------------------------.
// |  Inclusao de Bibliotecas e Constantes  |
//  '--------------------------------------'
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"

//  .--------------------------------------.
// |  Inicio da Rotina Principal            |
//  '--------------------------------------'
User Function NSGPER01()

	//  .--------------------------------------.
	// |  Declaracao de variaveis Locais        |
	//  '--------------------------------------'
	Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2        := "de acordo com os parametros informados pelo usuario."
	Local cDesc3        := "Relacao de dependentes"
	Local cPict         := ""
	Local titulo        := "Relacao de dependentes"
	Local nLin          := 180
	Local Cabec1        := ""
	Local Cabec2        := ""
	Local imprime       := .T.
	Local aOrd 		 := {}
	Local cPerg         := PADR("NSGPER01", Len(SX1->X1_GRUPO))

	//  .----------------------------------.
	// |  Declaracao de variaveis Privadas  |
	//  '----------------------------------'
	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private CbTxt       := ""
	Private limite      := 132
	Private tamanho     := "M"
	Private nomeprog    := "NSGPER01"
	Private nTipo       := 10
	Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey    := 0
	Private cbtxt       := Space(10)
	Private cbcont      := 00
	Private CONTFL      := 01
	Private m_pag       := 01
	Private wnrel       := "NSGPER01"
	Private cString     := "SRA"

	_setPergunte(cPerg)
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	Pergunte(cPerg,.F.)

	//  .-------------------------------------.
	// |  Montagem do Cabecalho de Impressao   |
	//  '-------------------------------------'

	//         123456 123456789012345678901234567890 12345678 123456789012345678901234 1234567890123456789012345 1234567890 12 1234 12345678901    9,999,999,999    9,999,999,999.99
	//         000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111                                                                    200
	//         000000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233        4         5         6         7         8         9         0         1         2
	//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	Cabec1 := " MAT   NOME                           ADMISSAO SETOR                    DEPENDENTES               NASC       SX GRAU CPF
	Cabec2 := " "


	_cdFile := AllTrim(GetTempPath())
	_cdFile += If( Right(_cdFile,1) $ "\/" ,"","\") + Alltrim(mv_par05) + ".xls"

	_cdTbl := _getTable()
	//If mv_par06 == 01 .OR. mv_par06 == 03      
	Processa( {|| _Excel( _cdTbl , _cdFile , {} ) } ," Gerando Dados no Excel, Aguarde...")
	//EndIf

Return Nil

Static Function RunReport(Cabcec1,Cabec2,Titulo,nLin)

	_cdTbl := _getTable()

	Cabec1 := " Codigo     Descricao                                 Quantidade      "
	Cabec2 := "                                                         Inicial      " 

	If Li > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		Li := 8
	Endif

	SetRegua(nCont)

	While !(_cdTbl)->(EOf())



		(_cdTbl)->(dbSkip())
	EndDo

	SET DEVICE TO SCREEN

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return


Static Function _setPergunte(cPerg)                   
	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j

	dbSelectArea("SX1")
	dbSetOrder(1)

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs,{cPerg, "01", "Admissao           :", "", "", "mv_ch1", "D", 08, 0, 0, "G", "", "   ", "", "", "mv_par01"})
	aAdd(aRegs,{cPerg, "02", "Tipo Impressao ?", "", "", "mv_ch2", "N", 01, 0, 0, "C", "", "   ", "", "", "mv_par02", "Protheus"   , "", "", "", "Excel"    , "", "", "Ambos"    , "", ""})
	aAdd(aRegs,{cPerg, "03", "Matricula       :", "", "", "mv_ch3", "C", 06, 0, 0, "G", "", "AL ", "", "", "mv_par03"})
	aAdd(aRegs,{cPerg, "04", "Setor      :", "", "", "mv_ch4", "C", 30, 0, 0, "G", "", "AL ", "", "", "mv_par04"})



	For i:=1 to Len(aRegs)
		If !dbSeek(PadR(cPerg,10)+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next j 
			MsUnlock()
		Endif
	Next i

	dbSelectArea(_sAlias)

Return Nil

Static Function _Excel(_cTbl,_cFile,_aCab)

	Local _aStru  :=  (_cTbl)->(dbStruct())
	Local oExcel  := FWMSEXCEL():New()
	Local _cWork  := "Relação de Dependentes"
	Local _aCol   := {}
	Local _cdTbl  := _cWork

	Default _aCab := {{"",""}}

	oExcel:AddworkSheet( _cWork )
	oExcel:AddTable( _cWork, _cdTbl)

	For _ndI := 1 To Len(_aStru)

		_cdCp := _aStru[_ndI][01]
		_nPos := aScan(_aCab,{|y| y[01] == _cdCp })

		If _nPos > 0
			_cAdd :=  _aCab[_nPos,02]
		Elseif _ChkCpo(_aStru[_ndI][01])
			_cAdd := SX3->X3_TITULO
		Else
			_cAdd := StrTran(_aStru[_ndI][01],"_"," ")
		EndIf

		_ndAlign  := iIf(_aStru[_ndI][02] $ 'N',3, iIf(_aStru[_ndI][02] $ 'D' ,2, 1) )
		_ndFormat := iIf(_aStru[_ndI][02] $ 'N',2, iIf(_aStru[_ndI][02] $ 'D' ,4, 1) )
		_ldTotal  := iIf(_aStru[_ndI][02] $ 'N',.T.,.F. )
		oExcel:AddColumn(_cWork, _cdTbl, _cAdd , _ndAlign, _ndFormat, _ldTotal )
		aAdd(_aCol,_cAdd)
	Next

	ProcRegua(0)

	While !(_cTbl)->(Eof())

		IncProc()
		_adLinha := {}
		For _ndI := 1 To Len(_aStru)
			If _aStru[_ndI][02] == "D"
				aAdd(_adLinha, DTOC( (_cTbl)->&(_aStru[_ndI][01]) ) )
			Else
				aAdd(_adLinha, (_cTbl)->&(_aStru[_ndI][01])  )
			EndIf
		Next

		oExcel:AddRow(_cWork, _cdTbl, _adLinha )

		(_cTbl)->(dbSkip())
	EndDo

	oExcel:Activate()
	oExcel:GetXmlFile(_cFile)
	oExcel:DeActivate()
	RunExcel(_cFile)
Return Nil

Static Function _ChkCpo(_cCpo)
	Local _lRet := .F.

	SX3->(dbgoTop())
	SX3->(dbSetOrder(2))
	_lRet := SX3->(dbSeek(Alltrim(_cCpo)))

Return _lRet


/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ MontaQry   ¦ Autor ¦ Anderson Gadelha     ¦ Data ¦ 01/12/2016 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Atraves de umaIsntrucao em Sql monta uma Tabela Temporaria c/ ¦¦¦
¦¦¦  (Cont)   ¦ as informcacoes da tabela SRA e SRB                           ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function _getTable()

	Local cQry    := ""
	Local _cTab   := getNextAlias()          
	Local cwEnter := CHR(13)


	cQry := "SELECT RA_MAT, RA_NOME  , RA_ADMISSA , SRJ.RJ_DESC   , CTT.CTT_DESC01 , "
	cQry +=        "ISNULL(RB_COD,'') RB_COD, ISNULL(RB_NOME,'SEM DEPENDENDES') RB_NOME, "
	cQry +=        "ISNULL(SUBSTRING(RB_DTNASC,7,2)+'/'+SUBSTRING(RB_DTNASC,5,2)+'/'+SUBSTRING(RB_DTNASC,1,4) ,'') AS RB_DTNASC , "
	cQry +=        "ISNULL(RB_SEXO,'') RB_SEXO,"
	cQry +=        "(CASE RB_TIPIR               "
	cQry +=	     "WHEN '1' THEN 'S/Lim.Idade'  "
	cQry +=	     "WHEN '2' THEN 'Ate 21 Anos'  "
	cQry +=	     "WHEN '3' THEN 'Ate 24 Anos'  "
	cQry +=	     "WHEN '4' THEN 'Nao é dep.'END)RB_TIPIR, "
	cQry +=	     "(CASE RB_TIPSF  "
	cQry +=	     "WHEN '0' THEN 'S/Lim.Idade'"
	cQry +=	     "WHEN '1' THEN 'Ate 14 Anos'"
	cQry +=	     "WHEN '2' THEN 'Nao é dep.'END)RB_TIPSF, RB_REGNAS, RB_GRAUPAR, RB_DTENTRA, RB_DTBAIXA, RB_CIC, "
	cQry +=        "RB_VBDESAM, RB_NOMEMAE, RB_CNS, RB_XCNVMED, RB_XCNVODO  "
	cQry +=    "FROM " + RetSqlName("SRA") + " SRA (NOLOCK) "
	cQry += "LEFT OUTER JOIN " + RetSqlName("SRB") + " SRB ON SRB.D_E_L_E_T_='' AND RA_MAT = RB_MAT "
	cQry += "LEFT OUTER JOIN " + RetSqlName("SRJ") + " SRJ ON SRJ.D_E_L_E_T_='' AND RA_CODFUNC = RJ_FUNCAO "
	cQry += "LEFT OUTER JOIN " + RetSqlName("CTT") + " CTT ON CTT.D_E_L_E_T_='' AND RA_CC = CTT_CUSTO "
	cQry += "WHERE SRA. D_E_L_E_T_='' "
	cQry +=        "AND RA_DEMISSA='' "
	cQry += "ORDER BY RA_NOME, RB_COD "

	MemoWrit("NSGPER01.sql",cQry)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,, cQry ),_cTab,.F.,.F.)


Return _cTab

//
//
//
Static Function RunExcel(cwArq)
	Local oExcelApp
	Local aNome := {}

	oExcelApp := MsExcel():New()                    	  // Cria um objeto para o uso do Excel
	oExcelApp:WorkBooks:Open(cwArq)
	oExcelApp:SetVisible(.T.)   // Abre o Excel com o arquivo criado exibido na Primeira planilha.

Return
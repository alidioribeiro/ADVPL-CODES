#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"
#Include "protheus.CH"

#Define NTAMTIT  74
#Define NTAMMENS 20
#Define NTAMCOL  14
#Define NCABEC   03

/*/{Protheus.doc} MRPNSB
//TODO MRP desenvolvido baseado no PCPR20_AP6, conforme novas regras informadas pela Sra Priscila
//     CALCULO DA NECESSIDA DE MATERIAIS, CONFORME PLANO MESTRE DE PRODUCAO.
@author Rogerio Cavalcante / Alidio Ribeiro
@since 06/02/2020
@version v1.0

@type function
/*/
USER FUNCTION MRPNSB()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ DEFINE VARIAVEIS                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local nLeadAir    := 10
	Local nLeadSea    := 60
	Local cCabec      := Space(NCABEC)
	Local cDiaIni     := "01"
	Local nMesIni     := 1
	Local nMesFin     := 12
	Local nAnoIni     := YEAR(dDataBase)
	Local nAnoFin     := nAnoIni
	Local cDiaFin     := "30"
	Private cTitulo   := PADC("MRP - NECESSIDADES DA ESTRUTURA.",NTAMTIT)
	Private cCabec1    := ""
	Private cCabec2    := ""
	Private cDesc1    := PADC("ESTE PROGRAMA TEM COM OBJETIVO, GERAR AS NECESSIDADES DE MATERIAS",NTAMTIT)
	Private cDesc2    := PADC("PRIMAS, BASEADO NO PLANO MESTRE DE PRODUCAO, CONFORME A ESTRUTURA",NTAMTIT)
	Private cDesc3    := PADC("DE PRODUTOS DENTRO DO PERIODO ESPECIFICADO NOS PARAMETROS.",NTAMTIT)
	Private cTamanho   := "G"
	Private nLimite    := 220
	Private cString   := "SHC"
	//Private aOrd      := {} //-- ORDEM
	Private lContinua := .T.
	//Private CUM       := ""
	Private lEnd      := .F.
	Private aReturn   := { "ZEBRADO", 1,"ADMINISTRACAO", 2, 2, 1, "",1 }
	Private cNomeProg := "PCPR20"
	Private nLastKey  := 0
	Private cPerg     := "PCPR02"
	Private aMES      := {}
	Private aMSG      := {}
	Private aMSG1     := {"COMPRAS          US$",  "SAIDAS ESTRUTURA US$", "SALDO            US$"}
	Private ANUM      := {}
	Private xItem     := 0
	Private WNREL     := "MRPNSB"//"PCPR20"
	Private aMesAno   := {}
	Private nQtdMes   := 0
	Private dDatIni   := dDataBase
	Private dDatFin   := dDataBase
	Private LI        := 80
	Private nCol      := 026 // Coluna início de impressão do cabeçalho dos meses
	Private aMRP      := {}
	Private aGRP      := {}
	Private aCompra   := {}
	Private APDTS     := {}
	Private aSaldAnt  := {}
	Private aAcrPer   := {}
	Private aTmNeces  := {}
	Private AIMP      := {}
	Private M_PAG     := 01
	Private aPedidos  := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ VERIFICA AS PERGUNTAS SELECIONADAS                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	PERGUNTE(cPerg,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ VARIAVEIS UTILIZADAS PARA PARAMETROS                        ³
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ MV_PAR01  C  6   // Periodo Inicial (MMAAAA)                ³
	//³ MV_PAR02  C  6   // Periodo Final (MMAAAA)                  ³
	//³ MV_PAR03  N 15   // Do Produto                              ³
	//³ MV_PAR04  N 15   // Ate o Produto                           ³
	//³ MV_PAR05  N  1   // Origem (Manaus/Fora do Estado/Importacao³
	//³ MV_PAR06  N  1   // Do Grupo                                ³
	//³ MV_PAR07  N  1   // Ate o Grupo                             ³
	//³ MV_PAR08  N  1   // Considerar Saldo: (Atual/Fechamento)    ³
	//³ MV_PAR09  N  1   // Do Tipo                                 ³
	//³ MV_PAR10  N  1   // Ate o Tipo                              ³
	//³ MV_PAR11  N  1   // Considera Estoque de Segurança    (S/N) ³
	//³ MV_PAR12  N  1   // Considera Material em Transito    (S/N) ³
	//³ MV_PAR13  N  1   // Considera Apenas Necessidade      (S/N) ³
	//³ MV_PAR14  N  1   // Quanto ao Idioma (Portugues/Inglês)     ³
	//³ MV_PAR15  N  1   // Gera Planilha com as Necessidades (S/N) ³
	//³ MV_PAR16  N  1   // Gera Solicitacao de Compras       (S/N) ³
	//³ MV_PAR17  N  1   // Considera Pedidos em Atraso       (S/N) ³
	//³ MV_PAR18  D  8   // Inicio Pesquisa Pedidos atrasados       ³
	//³ MV_PAR19  N  1   // Considera Saldos Em Prosseso      (S/N) ³
	//³ MV_PAR20  N  1   // Grava Est.Seg. no SB1 (Cad.Prod.) (S/N) ³
	//³ MV_PAR21  N  1   // Considera Saldos Bloqueados?      (S/N) ³
	//³ MV_PAR22  C  2   // Nr. do Plano?                           ³
	//³ MV_PAR23  C  3   // Revisao?                                ³
	//³ MV_PAR24  N  3   // Lead Time Aereo?                        ³
	//³ MV_PAR25  N  3   // Lead Time Maritimo?                     ³
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ ENVIA CONTROLE PARA A FUNCAO SETPRINT                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	WNREL := SETPRINT(cString,WNREL,cPerg,@cTitulo,cDesc1,cDesc2,cDesc3,.F.,,)

	IF nLastKey==27
		RETURN
	ENDIF

	SETDEFAULT(aReturn,cString)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ CRIA OS ARRAYS AMES E AMESANO PARA PROCESSAMENTO DO RELATORIO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//2020-02-06 Rogerio Cavalcante - Refactoring criarAMes - Agora o bloco esta concentrado na funcão criarAMes
	aMes := criarAMes(mv_par02)

	//2020-02-06 Rogerio Cavalcante - Refactoring Inicializa variaveis conforme parametros
	cDiaIni := strzero(day(dDataBase),2)
	nMesIni := VAL(SubStr(MV_PAR01,1,2))
	nMesFin := VAL(SubStr(MV_PAR02,1,2))
	nAnoIni := VAL(SubStr(MV_PAR01,3,4))
	nAnoFin := VAL(SubStr(MV_PAR02,3,4))
	cDiaFin := aMES[nMesFin][02]
	dDatIni := CTOD( cDiaIni+"/"+STRZERO(nMesIni,2)+"/"+STRZERO(nAnoIni,4) )
	dDatFin := CTOD( cDiaFin+"/"+STRZERO(nMesFin,2)+"/"+STRZERO(nAnoFin,4) )

	//2020-02-06 Rogerio Cavalcante - Refactoring criarAMesAno - Agora o bloco esta concentrado na funcão criarAMesAno
	aMesAno := criarAMesAno(mv_par01, mv_par02,@nQtdMes)

	//2020-02-06 Rogerio Cavalcante - Refactoring Cria a mensagem de cabecalho
	aMSG:= { PADR("=SALDO EM ESTOQUE",NTAMMENS),;
	PADR(iif(mv_par12==1,"+ENTRADAS","+ENTRADAS (N.C.)"),NTAMMENS),;
	PADR("-SAIDAS ESTRUTURA",NTAMMENS),;
	PADR(iif(mv_par17==2,"=SALDO","=SALDO+PED. ATRASO"),NTAMMENS),;
	PADR(" NECESSIDADE",NTAMMENS),;
	PADR(" MÊS",NTAMMENS),;
	PADR(" FALTAS",NTAMMENS)}

	//2020-02-06 Rogerio Cavalcante - Refactoring atribuido o valor default na declaração da variavel nLeadAir e
	// substitui-se pelo parametro mv_par24 quando for diferente de 0
	If MV_PAR24 <> 0
		//MSGINFO("Lead time aereo nao informado! Será utilizado Lead Time padrao de 10 Dias.")
		nLeadAir := MV_PAR24
	Endif

	//2020-02-06 Rogerio Cavalcante - Refactoring atribuido o valor default na declaração da variavel nLeadAir e
	// substitui-se pelo parametro mv_par24 quando for diferente de 0
	If MV_PAR25 <> 0
		//MSGINFO("Lead time maritimo nao informado! Será utilizado Lead Time padrao de 60 Dias.")
		nLeadSea := MV_PAR25
	Endif

	// --------------------------------------------
	// MONTA CABECALHO PARA IMPRESSAO DE RELATORIO.
	// --------------------------------------------
	// PERIODO
	// PRODUTO: 123456789012345   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234
	//                          99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999
	// 0000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000011111111112
	// 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

	// PERIODO
	// 123456789012345 1234567890123456789012345   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234
	//                                           999,999.999 999,999.999 999,999.999 999,999.999 999,999.999 999,999.999 999,999.999 999,999.999 999,999.999 999,999.999 999,999.999 999,999.999
	// 0000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000011111111112
	// 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

	//DbSelectArea("SHC")
	//DbSetOrder(1)
	//DbSeek(XFILIAL("SHC") + DTOS(dDatIni), .T.)

	//2020-02-06 Rogerio Cavalcante - Refactoring criarAMesAno - Agora o bloco esta concentrado na funcão criarAMesAno
	cCabec := criarCabec(cCabec)

	//2020-02-06 Rogerio Cavalcante - Refactoring criarAimp - cria aImp, aAcrPer, aTmNeces
	criarAimp()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ DEFINICAO DOS CABECALHOS                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If Mv_Par15 == 1
		cTitulo := "MRP - NEED OF MATERIALS"
		//cCabec1 := "PRODUCT          DESCRIPTION                     "+CCABEC+   "       Total"
		cCabec1 := "PRODUCT          DESCRIPTION              "+CCABEC//+"       Total"
		cCabec2 := ""
		//         999999999999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999.999,99  999.999.999,99
		//         12345678901234567890123456789012345678
		//                 10        20        30

		// 123456789012345 1234567890123456789012345    123/1234    123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234
		//                                           999,999.999 999,999.999 999,999.999 999,999.999 999,999.999 999,999.999 999,999.999 999,999.999 999,999.999 999,999.999 999,999.999 999,999.999 999,999.999
		//                                           99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999
		// 0000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000011111111112
		// 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

	Else
		cTitulo := "MRP - NECESSIDADE DE MATERIAIS"
		cCabec1 := "PERIODO                  "+CCABEC
		cCabec2 := ""
		//         XXXXXXXXXXXXXXXXXXXX  999,999,999
		//         12345678901234567890123456789012345678
		//                 10        20        30
	Endif

	If nLastKey == 27
		Return
	EndIf

	//#IFDEF WINDOWS

	Processa({|| RptDetail()})
	RptStatus({|| pImprime()})

	//#ENDIF

Return

/*/{Protheus.doc} criarAMes
//TODO Descrição Funcao responsavel por criar o array de Meses
@author Rogerio Cavalcante / Alidio Ribeiro
@since 06/02/2020
@version v1.0
@param cMesAno, , descricao recebe o mv_par02 que contem uma string de Mes e Ano
@type function
/*/
Static Function criarAMes(cMesAnoFim)
	Local nAno  := Val(subs(cMesAnoFim,3,4))
	Local aFev  := {{"FEV","29","09"},{"FEV","28","09"}}
	Local aMes  := {}

	AADD(aMES,{"JAN","31","08"})
	AADD(aMES,aFev[Mod(nAno,4) + 1])
	AADD(aMES,{"MAR","31","10"})
	AADD(aMES,{"ABR","30","11"})
	AADD(aMES,{"MAI","31","12"})
	AADD(aMES,{"JUN","30","01"})
	AADD(aMES,{"JUL","31","02"})
	AADD(aMES,{"AGO","31","03"})
	AADD(aMES,{"SET","30","04"})
	AADD(aMES,{"OUT","31","05"})
	AADD(aMES,{"NOV","30","06"})
	AADD(aMES,{"DEZ","31","07"})
Return aMES

/*/{Protheus.doc} criarAMesAno
//TODO Descrição Funcao Responsavel pela criacao do array aMesAno que identifica o Mes e o Ano
@author Rogerio Cavalcante / Alidio Ribeiro
@since 06/02/2020
@version undefined
@param cMesAnoIni, characters, descricao - Mes e Ano do mv_par01
@param cMesAnoFim, characters, descricao - Mes e Ano do mv_par02
@param nQtdMes, numeric, descricao - quantidade de Meses gerados
@type function
/*/
Static Function criarAMesAno(cMesAnoIni, cMesAnoFim, nQtdMes)
	Local nCont := 1
	Local _nMes := Val(SubStr(cMesAnoIni,1,2))
	Local _nAno := Val(SubStr(cMesAnoIni,3,4))
	Local aMesAno := {}

	// Wagner 18 01 18
	nQtdMes := 0

	While .T.
		aadd( aMesAno, aMES[_nMes][2]+"/"+StrZero(_nMes,2)+"/"+StrZero(_nAno,4) )

		If _nMes == 12
			_nMes := 0
			_nAno ++
		Endif
		_nMes ++
		nCont ++

		nQtdMes++
		If StrZero(_nAno,4)+StrZero(_nMes,2) > Right(cMesAnoFim,4)+Left(cMesAnoFim,2)
			exit
		Endif
	End

Return aMesAno

/*/{Protheus.doc} criarCabec
//TODO Descrição auto-gerada.
@author Rogerio Cavalcante / Alidio Ribeiro
@since 06/02/2020
@version undefined

@type function
/*/
Static function criarCabec(cCabec)
	Local aPos        := {}
	Local aMeses      := {}
	Local cNewCabec   := cCabec
	Local dIni        := dDatIni

	While dIni <= dDatFin

		If aScan( aMeses, { |x| x[1] = Year(dIni) .and. x[2] = Month( dIni) } ) == 0

			aAdd( aMeses, { Year(dIni), Month( dIni) } ) // Adiciona Ano e Mês no vetor de impressão
			aAdd( aPos, nCol ) // Adiciona posição do mês no vetor

			cNewCabec += PadL( aMES[ Month( dIni)][1] + "/" + StrZero( Year(dIni), 4), NTAMCOL) + " "
			nCol += (NTAMCOL + 1)
		Endif
		dIni ++
	End

Return cNewCabec

/*/{Protheus.doc} criarAimp
//TODO Descrição auto-gerada.
@author Rogerio Cavalcante / Alidio Ribeiro
@since 06/02/2020
@version undefined

@type function
/*/
Static Function criarAimp()
	Local GQMES   := 0
	Local nI := 0
	Local nC := 0
	Local nTamImp := Len(aMSG)
	Local nQuant  := 0
	Local nMes    := 0

	aAcrPer  := ARRAY(nQtdMes) // Jorge: 20/09/06
	aTmNeces := ARRAY(nQtdMes) // Jorge: 20/09/06
	aIMP     := ARRAY(nQtdMes,nTamImp)

	For nI := 1 to nQtdMes // --> Nr. de Meses
		XM      := StrZero(nI,2)
		nQuant  := "GQMES" + XM
		//nMes    := "VMES" + STRZERO(IIF( nMesIni+nI-1 > 12, nMesIni+nI-13, nMesIni+nI-1 ),2)
		nMes    := "VMES" + XM // Wagner 18 01 18
		&nQuant := 0
		&nMes   := nI

		For nC:= 1 to nTamImp
			aIMP[nI][nC] := 0
		Next

		aAcrPer[nI]  := 0  // Jorge: 20/09/06
		aTmNeces[nI] := 0  // Jorge: 20/09/06

	Next

Return

/*/{Protheus.doc} RptDetail
//TODO Descrição Refactoring o processamento do calculo de estoque, necessidade, saldo de pedidos
@author Rogerio Cavalcante / Alidio Ribeiro
@since 06/02/2020
@version v1.0

@type function
/*/
/*/{Protheus.doc} RptDetail
//TODO Descrição auto-gerada.
@author Administrador
@since 07/02/2020
@version undefined

@type function
/*/
Static Function RptDetail()
	Local cProduto := ""
	Local aStru    := {}
	Local nI       := 0
	Local cOpc     := ""
	Local cComp    := ""
	Local lPassa   := .T.
	Local cPrd     := ""
	Local nTamStru := 0
	Local nQNec    := 0
	Local nPos     := 0
	Local nPos1    := 0
	Local aModal   := {}
	Local cForn    := ""
	Local cLojFor  := ""
	//**Marcio Macedo colocar query**/

	dbSelectArea("SHC")
	dbSetOrder(4)
	//dbSeek(xFilial("SHC") + MV_PAR03 + dtos(dDatIni),.T.)
	dbSeek(xFilial("SHC") + MV_PAR03,.T.)
	ProcRegua(RecCount())

	While !SHC->(Eof()) .And. SHC->HC_Produto <= MV_Par04 .And. lContinua

		#IFNDEF WINDOWS
		IF LASTKEY() == 286
			lEnd := .T.
		ENDIF
		#ENDIF

		If lEnd
			@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
			lContinua := .F.
			exit
		EndIf

		If ( SHC->HC_Data < dDatIni .Or. SHC->HC_Data > dDatFin) .or. ( SHC->HC_DTVIGEN < dDatIni .Or. SHC->HC_DTVIGEN > dDatFin)
			SHC->(dbSkip())
			Loop
		Endif

		cProduto := SHC->HC_PRODUTO
		lPassa   := .T.

		/*dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+cProduto)
		cOpc := AllTrim(B1_Opc)
		*/

		cOpc := AllTrim(Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_OPC"))

		//dbSelectArea("SHC")
		While !SHC->(Eof()) .And. cProduto == SHC->HC_Produto .And. SHC->HC_Data <= dDatFin

			INCPROC("Processando: "+SHC->HC_PRODUTO+" Data: "+dtoc(SHC->hc_data))

			IF AllTrim(SHC->HC_NUMPLAN) <> Alltrim(Mv_par22) .Or. AllTrim(SHC->HC_Revisao) <> Alltrim(Mv_par23) // Jorge: 20/03/2012
				SHC->(DBSKIP())
				LOOP
			ENDIF

			If ( SHC->HC_Data < dDatIni .Or. SHC->HC_Data > dDatFin) .or. ( SHC->HC_DTVIGEN < dDatIni .Or. SHC->HC_DTVIGEN > dDatFin)
				SHC->(dbSkip())
				Loop
			Endif

			cPrd    := SHC->HC_PRODUTO
			//aStru   := {}
			//aStru1   := {}

			//NESTRU  := 0
			//I       := 0
			//dValIni := ctod("01/"+SubStr(dtos(SHC->HC_DATA),5,2)+"/"+SubStr(dtos(SHC->HC_DATA),1,4))
			//dValIni := SHC->HC_DATA // ddatabase   // Jorge Em: 25/08/2009
			//dValFin := ctod(aMES[month(SHC->HC_DATA)][2]+"/"+SubStr(dtos(SHC->HC_DATA),5,2)+"/"+SubStr(dtos(SHC->HC_DATA),1,4))

			aStru   := GetStru(cPrd)  // Utilizado até 23/09/2010 teste aglair
			//	aStru   := Estrut(cPrd)   // Passou a ser utilizado em 23/09/2010
			aGRP    := {}

			nTamStru := Len(aStru)
			For nI:=1 To nTamStru // MONTA ESTRUTURA DE PRODUTO.

				cComp  := aStru[nI,3]
				nQNec  := 0

				dbSelectArea("SG1")  // ESTRUTURA DE PRODUTO
				dbSetOrder(1)
				dbSeek(XFILIAL("SG1")+aStru[nI,2]+aStru[nI,3]+aStru[nI,5])

				dbSelectArea("SB1")  // CADASTRO DE PRODUTO
				dbSetOrder(1)
				dbSeek(XFILIAL("SB1")+cComp)

				If SB1->B1_GRUPO < MV_PAR06 .OR. SB1->B1_GRUPO > MV_PAR07 .OR.;
				SB1->B1_MRP # "S" .OR. SB1->B1_TIPO < MV_PAR09 .OR. SB1->B1_TIPO > MV_PAR10 .OR.;
				SG1->G1_FIXVAR<>"V" .OR. SB1->B1_ATIVO # "S"
					lPassa := .F.
				Endif

				// Jorge: 28/09/07 (Opcionais Padrao: Verifica Saldo dos Opcionais)
				If !Empty(SG1->G1_GroPc) .And. !(Alltrim(SG1->G1_GroPc)+Alltrim(SG1->G1_Opc) $ cOpc);
				.And. Right(Alltrim(SG1->G1_GrOpc),1) == "0"  // Jorge Em: 05/01/2007
					lPassa := .F.
				Endif

				//			IF (dValIni < SG1->G1_INI .Or. dValFin > SG1->G1_FIM)                                                         // Opcao original
				IF (SHC->HC_DATA < SG1->G1_INI .OR. SHC->HC_DATA > SG1->G1_FIM)                                               // JORGE EM: 01/08/2008
					lPassa := .F.
				ENDIF

				If lPassa // Jorge Em: 09/11/2009
					nQNec := aStru[nI,4] * SHC->HC_Quant
				Endif

				If nQNec > 0 .and. lPassa // Aglair Em: 12/11/09 - Filtra por Grupo de Opcionais -> Solicitacao do PCP
					nPos := ASCAN(aMRP,{|X| X[1] == cComp .AND. MONTH(SHC->HC_DATA) == X[4] .and. YEAR(SHC->HC_DATA) == X[6]})
					yPos := ASCAN(aGRP,{|X| X[1] == cComp .AND. MONTH(SHC->HC_DATA) == X[3] .and. YEAR(SHC->HC_DATA) == X[4] .AND. SG1->G1_GrOpc == X[2] .AND. ALLTRIM(SG1->G1_GrOpc)<>"" })

					If nPos # 0 .And. yPos = 0
						aadd(aGRP,{cComp,;
						SG1->G1_GrOpc,;
						Month(SHC->HC_DATA), Year(SHC->HC_DATA) })
						aMRP[nPos][02] += nQNec
					Elseif nPos == 0
						aadd(aGRP,{cComp, SG1->G1_GrOpc, Month(SHC->HC_DATA),Year(SHC->HC_DATA)})
						aadd(aMRP, {cComp,;			            // 01 COMPONENTE
						nQNec,;						// 02 QUANTIDADE
						SHC->HC_DATA,;				// 03 DATA
						Month(SHC->HC_DATA),;       // 04 MES
						SG1->G1_GrOpc,;             // 05 Grupo de Opcionais
						Year(SHC->HC_DATA) })       // 06 ANO
					Endif
					cForn := Posicione("SB1",1,xFilial("SB1")+cComp,"B1_PROC")
					cLojFor := SB1->B1_LOJPROC

					aModal := {}
					aModal := aClone(u_FModal(cComp))

					nPos  := aScan(APDTS,{ |X| X[1] == cComp })
					nPos1 := aScan(aPedidos,{ |X| X[1]+X[2]+X[3]== cForn+clojFor+aModal[2] })
					If nPos1==0
						aAdd(aPedidos,{cForn,cLojFor,aModal[2],aModal[3],{}})
						nPos1 := Len(aPedidos)
					EndIf
					//AAdd( aPedidos, { SB1->B1_COD, nC7_QUANT, nC7_PRECO, cC7_OBS, CTT->CTT_CUSTO, CT1->CT1_CONTA} )

					If nPos==0

						aadd(APDTS,{cComp,;                    // Cod. do Componente
						SG1->G1_GrOpc,;            // Grupo de Opcionais
						SG1->G1_Opc,;              // Item Opcional
						SG1->G1_Cod,;              // Item Opcional
						cOpc,Alltrim(aModal[1]),Alltrim(cForn),Alltrim(aModal[2]) })                    // Opcional Default (SB1)
						//aModal := {}
						If mv_par12==1
							SALPED(cComp)
						Endif
					Endif
				Endif
				lPassa := .T.
			Next

			dbSelectArea("SHC")
			SHC->(dbSkip())

		EndDo
	EndDo

Return

/*/{Protheus.doc} pImprime
//TODO Descrição auto-gerada.
@author Administrador
@since 07/02/2020
@version undefined

@type function
/*/
Static Function pImprime()
	Local nTamImp := Len(aMSG)
	Local nTamApdts := Len(aPdts)
	Local nApdts := 0
	Local nItem   := 0
	Local aVetEstSeg := {}
	Local aTotUs     := {}

	nTipo := Iif(aReturn[4]==1,15,18)
	Cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho,nTipo)

	aSort(aPdts,,,{|x,y| x[1] < y[1]})

	SetRegua(nTamApdts)
	//i := 1

	///Limpa os produtos com estoque de segurança para geração do MRP
	If mv_Par20=1
		DbSelectArea("SB1")
		DbGotop()
		While !Eof() //**Marcio Macedo colocar query**/
			RecLock("SB1",.F.)
			SB1->B1_ESTSEG := 0
			SB1->(MsUnlock())
			DbSkip()
		EndDo
	EndIf
	For nApdts:=1 to nTamApdts

		IncRegua()

		dbSelectArea("SB1")  // CADASTRO DE PRODUTO
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+aPdts[nApdts][1])
		xIndPer := 1 + SB1->B1_INDPER /(100 - SB1->B1_INDPER)  // Jorge: 19/09/06 (Formula fornecida pelo Edy-PCP)
		If MV_PAR11==1
			nInex := SB1->B1_PERSEG
		Else
			nInex := 0
		EndIf

		xGrOpc  := {}
		xTotOpc := 0

		_nPedAtras := 0

		If mv_par08 == 1   // SALDO ATUAL
			// Jorge: 28/09/07 (Opcionais Padrao: Verifica Saldo dos Opcionais)
			If Len(AllTrim(aPdts[nApdts][2]))#0 .And. Alltrim(aPdts[nApdts][2])+Alltrim(aPdts[nApdts][3]) $ aPdts[nApdts][5] //cOpc
				dbSelectArea("SGA")
				dbSetOrder(1)
				dbSeek(xFilial("SGA")+AllTrim(aPdts[nApdts][2]))
				While !Eof() .And. AllTrim(aPdts[nApdts][2]) == GA_GrOpc

					dbSelectArea("SB2")
					dbSetOrder(1)
					dbSeek(xFilial("SB2")+AllTrim(SGA->GA_DescOpc))

					dbSelectArea("SGA")
					If aPdts[nApdts][3] # GA_Opc
						aadd(xGrOpc,{aPdts[nApdts][2],;              // Grupo de Opcionais
						GA_Opc,;                   // Item do grupo de Opcionais
						AllTrim(GA_DescOpc),;      // Codigo do Produto
						GA_DescGrp,;               // Descricao do Grupo de Opcionais
						Iif(mv_par21==1,SB2->B2_qAtu, SB2->B2_qAtu-SB2->B2_qEmp)})            // Jorge Em: 25/10/11 - Saldos bloqueados
						xTotOpc := xTotOpc + Iif(mv_par21==1,SB2->B2_qAtu,SB2->B2_qAtu-SB2->B2_qEmp)    // SB2->B2_qAtu
					Endif
					dbSkip()
				EndDo
			End
			dbSelectArea("SB2")
			dbSetOrder(1)
			If dbSeek(xFilial("SB2")+SB1->B1_COD) //+"01")
				nPos := ASCAN(aSaldAnt,B2_COD)
				aImp[1][1] := iif(nPos<>0,aSaldAnt[ASCAN(aSaldAnt,B2_COD)][2],0)+Iif(SubStr(aPdts[nApdts][2],3,1)=="0",xTotOpc,0)  // Jorge Em: 06.02.2007
				If nPos <> 0
					While !Eof() .And. SB1->B1_COD==B2_COD
						If B2_Local $ If(Mv_Par19==1,"01-10-70-98-A1","01-70-98-02") // Jorge Em: 20/03/2008        //incluso armazém A1 03/05/2016 Nilton
							aImp[1][1] := aImp[1][1] + Iif(mv_par21==1,B2_qAtu,B2_qAtu-B2_qEmp) // B2_QATU
						Endif
						dbSkip()
					EndDo
				Else
					While !Eof() .And. SB1->B1_COD==B2_COD
						If B2_Local $ If(Mv_Par19==1,"01-10-70-98-A1","01-70-98-02") // Jorge Em: 20/03/2008       //incluso armazém A1 03/05/2016 Nilton
							aImp[1][1] := aImp[1][1] + Iif(mv_par21==1,B2_qAtu,B2_qAtu-B2_qEmp)
						Endif
						dbSkip()
					EndDo
				Endif
			Else
				aImp[1][1] := Iif(SubStr(aPdts[nApdts][2],3,1)=="0",xTotOpc,0)
			Endif
		Else  // SALDO MOVIMENTO.
			If Len(AllTrim(aPdts[nApdts][2]))#0 .And. Alltrim(aPdts[nApdts][2])+Alltrim(aPdts[nApdts][3]) $ aPdts[nApdts][5] // cOpc
				dbSelectArea("SGA")
				dbSetOrder(1)
				dbSeek(xFilial("SGA")+AllTrim(aPdts[nApdts][2]))
				While !Eof() .And. AllTrim(aPdts[nApdts][2]) == GA_GrOpc
					dbSelectArea("SB2")
					dbSetOrder(1)
					xEst01  := CalcEst(AllTrim(SGA->GA_DescOpc),"01",dDataBase)[1] // Jorge Em: 01.02.2007
					If Mv_Par19 == 1
						xEst10  := CalcEst(AllTrim(SGA->GA_DescOpc),"10",dDataBase)[1] // Jorge Em: 20.03.2008
					Else
						xEst10  := 0
					Endif
					If SB1->B1_Tipo # "MP"
						xEst70  := CalcEst(AllTrim(SGA->GA_DescOpc),"70",dDataBase)[1] // Jorge Em: 20.03.2008
					Else
						xEst70  := 0
					Endif
					xEst98  := CalcEst(AllTrim(SGA->GA_DescOpc),"98",dDataBase)[1] // Jorge Em: 01.02.2007
					xEstA1  := CalcEst(AllTrim(SGA->GA_DescOpc),"02",dDataBase)[1] //incluso armazém A1 03/05/2016 Nilton
					dbSelectArea("SGA")
					If aPdts[nApdts][3] # GA_Opc
						aadd(xGrOpc,{aPdts[nApdts][2],;              // Grupo de Opcionais
						GA_Opc,;                   // Item do grupo de Opcionais
						AllTrim(GA_DescOpc),;      // Codigo do Produto
						GA_DescGrp,;               // Descricao do Grupo de Opcionais
						xEst01+xEst98+xEstA1 })           // Saldo em Estoque          //incluso armazém A1 03/05/2016 Nilton
						xTotOpc := xTotOpc + (xEst01+xEst10+xEst70+xEst98+xEstA1) //incluso armazém A1 03/05/2016 Nilton
					Endif
					dbSkip()
				EndDo
			End

			dbSelectArea("SB2")
			dbSetOrder(1)
			xEst01  := CalcEst(SB1->B1_COD,"01",dDataBase)[1] // Jorge Em: 01.02.2007
			If Mv_Par19 == 1
				xEst10  := CalcEst(SB1->B1_COD,"10",dDataBase)[1] // Jorge Em: 20.03.2008
			Else
				xEst10  := 0
			End
			If SB1->B1_Tipo # "MP"
				xEst70  := CalcEst(SB1->B1_COD,"70",dDataBase)[1] // Jorge Em: 20.03.2008
			Else
				xEst70  := 0
			End
			xEst98  := CalcEst(SB1->B1_COD, "98", dDataBase)[1] // Jorge Em: 01.02.2007
			xEstA1  := CalcEst(SB1->B1_COD, "02", dDataBase)[1] // Jorge Em: 01.02.2007
			aImp[1][1] := xEst01 + xEst10 + xEst70 + xEst98 + xEstA1 + Iif(SubStr(aPdts[nApdts][2],3,1)=="0",xTotOpc,0) // Jorge Em: 01.02.2007
			//EndIf
		EndIf

		c_Comp := aPdts[nApdts][1]

		For N := 1 TO nQtdMes // (Total de meses a serem impressos)
			aAcrPer[N] := 0
			nPos := aScan(aCompra ,{|X| X[1] == c_Comp .and. X[4] == Month(CtoD(aMesAno[n])) .and. X[5] == Year(CtoD(aMesAno[n]))})
			aImp[N][2] := IIF(nPos<>0, aCompra[nPos][2], 0)
			nPos := aScan(aMRP    ,{|X| X[1] == c_comp .and. X[4] == Month(CTod(aMesAno[n])) .and. x[6] == Year(CToD(aMesAno[n]))})
			aImp[N][3] := IIF(nPos<>0, aMRP[nPos][2]   , 0)
			If aImp[N][3] > 0 // Jorge: 20/09/06
				aAcrPer[N] := (aImp[N][3] * xIndPer - aImp[N][3])
			End
		Next

		_nNecAnt := 0

		nTNec := 0
		_GrvEstSeg := .T.

		// 1a. Passagem
		For N := 1 to nQtdMes   // Nr. de meses a serem impressos
			nPrev := 0
			For y:=1 to Int(nInex) // Est.Seg. por periodo
				If N+y <= Len(aImp)
					nPrev += aImp[N+y][3]
				Else
					nPrev += aImp[Len(aImp)][3] // Jorge Em: 11.11.08
				EndIf
			Next
			y := Int(nInex)+1
			If N+y <= Len(aImp)
				nPrev += aImp[N+y][3]*Mod(nInex,1)
			EndIf

			If mv_Par20==1 .And. nPrev>0 .And. _GrvEstSeg == .T. // Atualiza campo Est.Seg, no Cad. de Produto
				aadd(aVetEstSeg,{sb1->b1_cod,sb1->b1_estseg,nPrev,ddatabase})
				RecLock("SB1",.F.)
				SB1->B1_ESTSEG := nPrev
				SB1->(MsUnlock())
				_GrvEstSeg := .F.
			End

			aImp[N][4] := aImp[N][1] + aImp[N][2] - aImp[N][3] - aAcrPer[N] //remerson 04/01/07

			/*Compras em atraso 07/01/07*/
			If mv_par17==1
				If N==1
					cPos := aScan(aSaldAnt,{|X| X[1] == c_Comp})
					aImp[N][4] += aSaldAnt[cPos][2]
				End
			End
			/*Compras em atraso 07/01/07*/
			nImp3 := nPrev  // Iif(nPrev<>0,nPrev,Iif(N<nQtdMes,AIMP[N+1][3],0))
			aImp[N][5] := Iif(nImp3-aImp[N][4]<=0,0,(nImp3-aImp[N][4]) + aAcrPer[N] ) // * xIndPer )  // Jorge: 19/09/06
			If SB1->B1_LE > 0
				aImp[N][5] := Iif(Mod(aImp[N][5],SB1->B1_LE)==0,aImp[N][5],INT((aImp[N][5]/SB1->B1_LE)+1)*SB1->B1_LE)   // Jorge: 19/09/06
			End

			If N < nQtdMes  // NR. de meses a serem impressos
				aImp[N+1][1]  := aImp[N][4] //+ aImp[N][5]
			EndIf

			aImp[N,6] := Round( (aImp[n,1] - (_nNecAnt + _nPedAtras ))/ aImp[n,3], 1)
			aImp[N,7] := -1 * Iif(nImp3-aImp[N][4]<=0,0,(nImp3-aImp[N][4]) + aAcrPer[N] )

			_nNecAnt := aImp[n, 5]

		Next

		// 2a. Passagem Cálculo Meses
		/*
		_nNecAnt := 0
		For N := 1 to nQtdMes   // Nr. de meses a serem impressos

		_nConsumo

		aImp[n,6] := Round( (aImp[n,1] - (_nNecAnt + _nPedAtras ))/ aImp[n,3], 1)

		_nNecAnt   := aImp[n, 5]
		_nPedAtras := 0
		Next
		*/
		If nTNec==0 .and. mv_par13==1
			Loop
		EndIf

		If MV_Par15==1 // Gera Planinha somente com as necessidades.

			@ LI,000      PSAY aPdts[nApdts][1]        			 			     	// COMPONENTE
			if mv_par14==1
				@ LI,PCOL()+1 PSAY SubStr(SB1->B1_DESC,1,25)			     	// DESCRICAO PORTUGUES
			Else
				@ LI,PCOL()+1 PSAY SubStr(SB1->B1_DESC_EN,1,25)			   	// DESCRICAO INGLES
			End
			xTotNec := 0
			_undMed:= subs(Posicione("SB1",1,xFilial("SB1")+aPdts[nApdts][1],"B1_UM"),1,2)

			nCol := 43

			For M:=1 to nQtdMes
				@ LI, nCol PSAY Transform(aImp[M][5],"@E 999,999.999")
				aTmNeces[M] := aTmNeces[M] + aImp[M][5]
				xTotNec := xTotNec + aImp[M][5]
				nCol += 12
			Next

			//@ LI,PCOL()+2 PSAY Transform(xTotNec,"@E 99,999,999")
			li++

			If Li > 60
				Cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho,nTipo)
			EndIf
		Else
			@ LI,000      PSAY "PRODUTO: " + aPdts[nApdts][1]        			 				// COMPONENTE
			@ LI,PCOL()+3 PSAY SubStr(SB1->B1_DESC,1,40)				    				// DESCRICAO PORTUGUES
			if mv_par14==2
				@ LI,PCOL()+3 PSAY SubStr(SB1->B1_DESC_EN,1,30)			           		// DESCRICAO INGLES
			end

			cPos:=ascan(aSaldAnt,{|X| X[1] == aPdts[nApdts][1]})

			@ LI,PCOL()+1 PSAY "UM: "         + SB1->B1_UM 								// UM
			@ LI,PCOL()+1 PSAY "TIPO: "       + SB1->B1_TIPO 		    					// TIPO
			@ LI,PCOL()+1 PSAY "GRUPO: "      + SubStr(SB1->B1_GRUPO,1,3)					// GRUPO
			@ LI,PCOL()+1 PSAY "SEGURANÇA:"   + Transform(nInex         , "@e 99.99")	 	// ESTOQUE SEGURANÇA
			@ LI,PCOL()+1 PSAY "IND.PERDA:"   + Transform(SB1->B1_INDPER, "@e 99.99%")	 	// INDICE DE PERDA
			@ LI,PCOL()+1 PSAY "LOTE ECONOM:" + Transform(SB1->B1_LE,"@e 999,999")	    // LOTE ECONOMICO
			IF aSaldAnt[cPos][2] > 0
				@ LI,PCOL()+3 PSAY "PED. ATRASO:" + Transform(aSaldAnt[cPos][2],"@e 999,999")// Saldos de Compras
			End
			Li+=1
			@ LI,000 PSAY "MODAL:"+aPdts[nApdts][6]                              //  Alidio Ribeiro 30/04/2019
			@ LI,PCOL()+1 PSAY "FORN.:" + SB1->B1_PROC + " - " + SB1->B1_LOJPROC + " " + Left( Posicione("SA2",1,xFilial("SA2")+SB1->B1_PROC+SB1->B1_LOJPROC,"A2_NOME" ),30)+"TAB.:"+Alltrim(aPdts[nApdts][8])  + "  " + "Saldos A1 e 10.:"+STR(CalcEst(aPdts[nApdts][1], "A1", dDataBase)[1])+ " -- " + STR(CalcEst(aPdts[nApdts][1], "10", dDataBase)[1]) + "    Bloq Empenho.:" + STR(RetBlok(aPdts[nApdts][1]))
			Li+=2
			_undMed:= subs(Posicione("SB1",1,xFilial("SB1")+aPdts[nApdts][1],"B1_UM"),1,2)

			IF Mv_Par15 == 3 // Resumo das necessidades na Moeda Estrangeira.
				A :=0
				xPrPro := U_QuanProd(aPdts[nApdts][1]) /*captura o preco do produto de acordo com a tabela 001*/
				For N:=5 to 1 step -1
					For M:=1 to nQtdMes
						If M==1  .And. (N==5 .or. N==3  .or. N==1)
							Do case
								case N == 5
								A:=1
								case N == 3
								A:=2
								case N == 1
								A:=3
							End case
							@ LI,000  PSAY aMSG1[A]
						End
						/*TESTE PARA O PLANEJAMENTO DE DO MPI*/
						If N==5 .Or. N==3  .Or. N==1
							If N==1
								xSaldo := (aImp[M][1]+aImp[M][5]+aImp[M][2])-aImp[M][3]
								xSaldo *= xPrPro
								@ LI,PCOL()+2 PSAY Transform(xSaldo,"@E 999999.999")
							ElseIf N==5
								xPreco:=(aImp[M][5]+aImp[M][2])*xPrPro
								@ LI,PCOL()+2 PSAY Transform(xPreco,"@E 999999.999")
							Else
								xPreco:=aImp[M][N]*xPrPro
								@ LI,PCOL()+2 PSAY Transform(xPreco,"@E 999999.999")
								aTmNeces[M] := aTmNeces[M] + aImp[M][5]
								//xTotNec := xTotNec + aImp[M][5]
							End

							nPos := aScan(aTotUS,{|X| M == X[4] })
							If nPos == 0
								aAdd(aTotUS,{  xPreco,;						// 01 QTD COMPRA
								0.0,;						// 02 QTD SAIDA
								0.0,;						// 03 QTD SALDO
								M})						// 04 MES
							Else
								Do Case
									Case N==5
									aTotUS[nPos][1]+=xPreco   			     	// 01 QTD COMPRA
									Case N==3
									aTotUS[nPos][2]+=xPreco   		        	// 02 QTD SAIDA
									Case N==1
									aTotUS[nPos][3]+=xSaldo	   			    	// 03 QTD SALDO
								EndCase
							EndIf
						Else
							Exit
						End
						xPreco := 0.0
						xSaldo := 0.0
						//TESTE PARA O PLANEJAMENTO DE DO MPI
					Next
					If N==5 .or. N==3 .or. N==1
						li++
						//@ LI,nCol PSAY ""
					End
				Next
				@ LI,000 PSAY Replicate("-",nLimite)
				Li += 1
				If Li > 65
					Cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho,nTipo)
				EndIf
			Else // Mv_Par15 == 2
				For N:=1 to nTamImp  // Nr. de Linhas
					nCol := 29
					For M:=1 to nQtdMes // Nr. de Colunas
						If M==1
							@ LI,000  PSAY aMSG[N]
						End
						@ LI, nCol PSAY IIF(AllTrim(_undMed)$"KG/L/", Transform(aImp[M][N],"@E 9,999,999.999"), Transform(aImp[M][N],"@E 9,999,999.999"))
						IF N==5 .And. M == 5 .And. mv_par16 == 1 .And. aImp[M][N] > 0 // Jorge Em: 05/09/07
							xItem += 1
							geraSolCompra(M,aImp[M][N],aPdts[nApdts][1],xItem) // Jorge Em: 05/09/07
						EndIf
						nCol += 15
					Next
					li++
				Next
			EndIf
			//------------------------------------------//
			// Demonstrativo do Grupo de Opcionais.     //
			//------------------------------------------//
			If Len(xGrOpc) > 0
				@ li, 000 PSAY ">>> LISTA DOS ITENS OPCIONAIS: "
				Li += 1
				@ li, 000 PSAY "Gru  Item  Produto          UM Descrição                       Sld.Estoque            Total"
				Li += 1
				@ LI,000 PSAY Replicate("-",92)
				Li += 1
				For xI:=1 to Len(xGrOpc)
					@ li, 000      PSAY xGrOpc[xI][1]             // Grupo de Opcionais
					@ li, PCol()+2 PSAY xGrOpc[xI][2]             // Item do grupo de Opcionais
					@ li, PCol()+2 PSAY xGrOpc[xI][3]             // Codigo do Produto
					@ li, PCol()+2 PSAY xGrOpc[xI][4]             // Descricao do Grupo de Opcionais
					@ li, PCol()+2 PSAY IIF(AllTrim(_undMed)$"KG/L/",Transform(xGrOpc[xI][5],"@E 99,999,999.999"),Transform(xGrOpc[xI][5],"@E 99,999,999,999")) // Saldo em Estoque
					If xI == Len(xGrOpc)
						@ li, PCol()+2 PSAY  IIF(AllTrim(_undMed)$"KG/L/",Transform(xTotOpc,"@E 999,999,999.999"),Transform(xTotOpc,"@E 999,999,999,999"))
					EndIf
					Li += 1
				Next
			EndIf

			@ LI,000 PSAY Replicate("-",nLimite)
			Li += 1

			If Li > 58
				Cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho,nTipo)
			EndIf
		End
	Next

	If MV_Par15==1 // Gera Planinha somente com as necessidades.
		li++
		@ LI,000      PSAY "Total Geral    "//+space(42)
		xGerNec := 0
		nCol := 42
		For M:=1 to nQtdMes
			@ LI,nCol PSAY Transform(aTmNeces[M],"@E 999999.999")
			xGerNec := xGerNec + aTmNeces[M]
			nCol += 11
		Next
		//@ LI,PCOL()+2 PSAY Transform(xGerNec,"@E 99,999,999")
		li++
	Elseif MV_Par15==3   //aTotUS:={}
		If len(aTotUS)<>0
			Li++
			@ LI,000      PSAY "Total Geral    "+space(42)
			Li+=2
			For N:=1 to 3
				For M:=1 to nQtdMes
					If M==1
						@ LI,000  PSAY aMSG1[N]
					End
					@ LI,PCOL()+2 PSAY Transform(aTotUS[M][N],"@E 999,999,999.99")
				Next
				li++
			Next
		Else
			msgstop("Produto não gerou necessidade")
		End
	End
	If Len(aVetEstSeg)>0
	//	GRelEstSeg(aVetEstSeg)  Retirado  Alidio  testes 26/03/2020.
	EndIf

	Set Device To Screen

	If aReturn[5] == 1
		Set Printer To
		DBCOMMITALL()
		OurSpool(WNREL)
	EndIf
	MS_FLUSH()
Return

/*/{Protheus.doc} GRelEstSeg
//TODO Descrição Refactoring da rotina com declaração de variaveis locais
@author Rogerio Cavalcante
@since 07/02/2020
@version undefined
@param aVetEstSeg, , descricao
@type function
/*/
Static Function GRelEstSeg(aVetEstSeg)
	Local aCampos    :={}
	Local cDirDocs   := "\RELATO\"
	Local cArq       := Criatrab( ,.F.)
	Local cNameTmp   := STRTRAN(Dtoc(Date()),"/","")+STRTRAN(TIME(),":","")
	Local cPath      := "C:\RELATORIO_SIGA"
	Local cNome      := "AtuEstSeg-" + cNameTmp + ".XLS"
	Local nVetEst    := 0
	Local nTamVetEst := Len(aVetEstSeg)

	AADD(aCampos, {"COD"       , "C" , 15 ,0 })
	AADD(aCampos, {"DESC"      , "C" , 50 ,0 })
	AADD(aCampos, {"ESEGANT"   , "N" , 14 ,2 })
	AADD(aCampos, {"ESEGATU"   , "N" , 14 ,2 })
	AADD(aCampos, {"DATAATU"   , "D" , 09 ,0 })

	dbCreate(cDirDocs+"\"+cArq,aCampos,"DBFCDXADS")             //Cria o arquivo no caminho especificado
	dbUseArea(.T.,"DBFCDXADS",cDirDocs+"\"+cArq,"TRX",.F.,.F.) //Seleciona o arquivo para uso.

	For nVetEst := 1 to nTamVetEst
		DbSelectArea("TRX")
		RecLock("TRX",.T.)  //	{sb1->b1_cod,sb1->b1_estseg,nPrev,ddatabase}
		TRX->COD     := aVetEstSeg[nVetEst][1]
		TRX->DESC    := Posicione("SB1",1,xFilial("SB1")+aVetEstSeg[nVetEst][1],"B1_DESC")
		TRX->ESEGANT := aVetEstSeg[nVetEst][2]
		TRX->ESEGATU := aVetEstSeg[nVetEst][3]
		TRX->DATAATU := aVetEstSeg[nVetEst][4]
		MsUnlock()
	Next

	dbSelectArea("TRX")
	COPY TO &(cDirDocs+cNome) VIA "DBFCDXADS"
	CpyS2T( cDirDocs+cNome , cPath , .T. ) //cDirDocs+"\"+cArq+".DBF"
	fErase(cDirDocs+cNome)
	If ! ApOleClient( 'MsExcel' )        //Verifica se o Excel esta instalado
		MsgStop( 'MsExcel nao instalado' )
		//           DbSelectArea("TSD3")
		//	  	   DbcloseArea("TSD3")
		DbSelectArea("TRX")
		DbcloseArea("TRX")
		Return
	EndIf

	oExcelApp := MsExcel():New()     // Cria um objeto para o uso do Excel
	oExcelApp:WorkBooks:Open(cPath+"\"+cNome) // Atribui à propriedade WorkBooks do Excel
	// o Arquivo criado com as informacoes acumuladas do SRC
	oExcelApp:SetVisible(.T.)   // Abre o Excel com o arquivo criado exibido na Primeira planilha.

	MSGBOX("Foi gerado o Arquivo AtuEstSeg "+Dtoc(DdataBase),"Informacao","INFO")

	DbcloseArea("TRX") // Incluido por Rodovaldo

	//Rotina que envia os dados para o Excel.
Return

/*/{Protheus.doc} SalPed
//TODO Descrição Refactoring para declarar variaveis locais de acordo com o escopo 
@author Rogerio Cavalcante / Alidio Ribeiro
@since 07/02/2020
@version undefined
@param cComp, characters, descricao
@type function
/*/
Static Function SalPed(cComp)
	Local _cQry := ""
	//Local nSaldAnt := 0
	Local nMesComp := Month(dDataBase)
	Local nAnoComp := Year(dDataBase)
	Local nCompMes := 0
	Local nPos     := 0 

	_cQry := "SELECT SUM(SC7.C7_QUANT - SC7.C7_QUJE) AS COMPRA_ANT "
	_cQry += "FROM " + RetSqlName("SC7") + " (NOLOCK) SC7 "
	_cQry += "WHERE SC7.D_E_L_E_T_='' AND C7_PRODUTO='" + cComp + "' "
	_cQry += "AND SC7.C7_DATPRF>='" + DtoS(mv_par18)+ "' "
	_cQry += "AND SC7.C7_DATPRF< '" + Dtos(dDatIni)+ "' "
	_cQry += "AND SC7.C7_RESIDUO<>'S' "

	_cQry := ChangeQuery(_cQry)
	TCQUERY _cQry Alias TMRP New

	dbSelectArea("TMRP")
	dbGoTop()

	//nSaldAnt := COMPRA_ANT
	aadd(aSaldAnt,{cComp,TMRP->COMPRA_ANT}) //aadd(aSaldAnt,{cComp,nSaldAnt})

	dbCloseArea("TMRP")
	
	//
	//xSalped := 0
	//xSaida  := 0

	SC7->(DbSetOrder(7))
	SC7->(DbSeek(xFilial("SC7")+cComp+DtoS(dDatIni),.T.))

	While !SC7->(Eof()) .And. cComp == SC7->C7_PRODUTO .and. SC7->C7_DATPRF <= dDatFin

		nMesComp := MONTH(SC7->C7_DATPRF)
		nAnoComp := YEAR(SC7->C7_DATPRF)
		nCompMes := 0
		While !SC7->(Eof()) .and. cComp == SC7->C7_PRODUTO .and. SC7->C7_DATPRF <= dDatFin .and. nMesComp == Month(SC7->C7_DATPRF)

			If SC7->C7_RESIDUO # "S"
				nCompMes += (SC7->C7_QUANT - SC7->C7_QUJE)
			End

			SC7->(dbSkip())
		EndDo

		nPos := aScan(aCompra,{|X| X[1] == cComp .And. nMesComp == X[4] .and. x[5] = nAnoComp } )

		If nPos == 0
			aAdd(aCompra, {cComp,;	   // 01 COMPONENTE
			nCompMes,;  // 02 QUANTIDADE
			SC7->C7_DATPRF,; // 03 DATA
			nMesComp,;  // 04 MES
			nAnoComp})  // 05 ANO
		EndIf

	EndDo

Return

/*/{Protheus.doc} GetStru
//TODO Descrição auto-gerada.
@author Administrador
@since 07/02/2020
@version undefined
@param cProd, characters, descricao
@type function
/*/
Static Function GetStru(cProd)

	dbSelectArea("SG1")
	dbSetOrder(1)
	dbSeek(xfilial()+cProd)
	aStr  := {}
	aPai  := {}
	aTmp  := {}
	cPai  := SG1->G1_COD
	nPos  := Recno()
	nPos2 := 0
	Z     := 0

	While !Eof() .And. cPai == SG1->G1_COD
		nPos   := Recno()
		cFilho := SG1->G1_COMP
		If SG1->G1_FIXVAR == "F"
			dbSkip()
			//Marcio Macedo para verificar se é uma sub-Strutura
			While cPai<>SG1->G1_COD .and. z>0
				Go aPai[Z][1]
				cPai   := aPai[Z][2]
				dbSkip()
				aTmp   := {}
				For w:=1 to (z-1)
					aadd(atmp,aPai[w])
				Next
				aPai   := {}
				For w:=1 to (z-1)
					aadd(aPai,aTmp[w])
				Next
				Z      := Len(aPai)
			EndDo
			//-----------------------------------------------------
			Loop
		End
		//	If dValIni >= SG1->G1_INI .and. dValFin <= SG1->G1_FIM
		If (SHC->HC_DATA >= SG1->G1_INI .AND. SHC->HC_DATA <= SG1->G1_FIM) // Jorge Em: 22/09/2010
			If dbSeek(xfilial()+cFilho)
				nPos2  := Recno()
				Go nPos
				aAdd(aStr,{StrZero((z+1),2,0),cPai,SG1->G1_COMP,SG1->G1_QUANT*Iif(z>0,aPai[z][3],1),SG1->G1_TRT})
				nQuant := SG1->G1_QUANT
				Go nPos2
				aAdd(aPai,{nPos,cPai,nQuant*Iif(Z>0,aPai[z][3],1)})
				Z      := Len(aPai)
				cPai   := SG1->G1_COD
			Else
				Go nPos
				aAdd(aStr,{StrZero((z+1),2,0),SG1->G1_COD,SG1->G1_COMP,SG1->G1_QUANT*Iif(z>0,aPai[z][3],1),SG1->G1_TRT})
				dbSkip()
			EndIf
		Else
			go nPos
			dbSkip()
		EndIf
		While cPai<>SG1->G1_COD .and. z>0
			Go aPai[Z][1]
			cPai   := aPai[Z][2]
			dbSkip()
			aTmp   := {}
			For w:=1 to (z-1)
				aadd(atmp,aPai[w])
			Next
			aPai   := {}
			For w:=1 to (z-1)
				aadd(aPai,aTmp[w])
			Next
			Z      := Len(aPai)
		EndDo
	EndDo
Return(aStr)

static FUNCTION GeraSolCompra(mesRef,xNecess,Prod,cItem)

	_grupo:= subs(Posicione("SB1",1,xFilial("SB1")+Prod,"B1_GRUPO"),1,3)

	IF _grupo == "MPI"
		nPos := aScan(ANUM ,{|X| X[2] == mesRef})
		IF nPos == 0
			_nextNum:=GetSX8Num("SC1") //Indice do ultimo registro
			ConfirmSX8()

			AADD(ANUM,{aMES[mesRef][1],mesRef,_nextNum,1})
			item:=1
		ELSE
			_nextNum := ANUM[nPos][3]
			item:=ANUM[nPos][4]
		END

		dDatPrf    := "01"+"/"+ALLTRIM(STRZERO(mesRef+3,2))+"/"+ALLTRIM(STR(YEAR(DDATABASE),4))
		dDatPrf    := CTOD(dDatPrf)
		dDatEms    := "01"+"/"+ALLTRIM(STRZERO(mesRef,2))+"/"+ALLTRIM(STR(YEAR(DDATABASE),4))
		dDatEms := Ctod(dDatEms)
		//dDatPrf    := CTOD("01/01/08")

		RecLock("SC1",.T.)
			SC1->C1_Filial  := xFilial("SC1")
			SC1->C1_NUM     := _nextNum
			SC1->C1_ITEM    := strzero(cItem,4)
			SC1->C1_PRODUTO := Prod
			SC1->C1_UM      := SUBS(AllTrim(Posicione("SB1",1,xFilial("SB1")+Prod,"B1_UM")),1,2)
			SC1->C1_QUANT   := xNecess // aImp[mesRef+4][5¤]
			SC1->C1_DATPRF  := dDatPrf
			SC1->C1_LOCAL   := SUBS(AllTrim(Posicione("SB1",1,xFilial("SB1")+Prod,"B1_LOCPAD")),1,2)
			SC1->C1_CONTA   := SUBS(AllTrim(Posicione("SB1",1,xFilial("SB1")+Prod,"B1_CONTA")),1,8)
			//SC1->C1_OBS     := "GERACAO AUTO. SOL. COMPRAS"
			SC1->C1_CC      := SUBS(AllTrim(Posicione("SB1",1,xFilial("SB1")+Prod,"B1_CC")),1,3)
			SC1->C1_EMISSAO := dDatEms
			SC1->C1_DESCRI  := SUBS(AllTrim(Posicione("SB1",1,xFilial("SB1")+Prod,"B1_DESC_EN")),1,30)
			SC1->C1_SOLICIT := SUBSTR(CUSUARIO,7,15)
			SC1->C1_ORIGEM  := "MRP" + STRZERO(month(dDataBase),2)
		SC1->(MsUnlock())
		//   IIF(nPos==0,ANUM[mesRef][4]+=1,ANUM[nPos][4]+=1)
	ENDIF
Return
/*
User Function FModal(cProduto)
Local cQry	 := ""
Local cModal := ""
Local cTabela := ""
Local cCondicao := ""

cForn := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_PROC")
cLojFor := SB1->B1_LOJPROC
If Select("MODAL")>0
MODAL->(DbCloseArea("MODAL"))
EndIf
cQry+=" SELECT AIA_XMODAL AS MODAL,AIA_DESCRI AS TABELA,AIA_CONDPG AS CONDICAO FROM "+ RetSQLName("AIB")+" AIB "
cQry+=" INNER JOIN "+RetSQLName("AIA")+" AIA ON "
cQry+=" AIA.D_E_L_E_T_='' "
cQry+=" AND AIA.AIA_FILIAL=AIB.AIB_FILIAL "
cQry+=" AND AIA_CODTAB=AIB.AIB_CODTAB "
cQry+=" AND AIA.AIA_CODFOR=AIB.AIB_CODFOR "
cQry+=" AND AIA.AIA_LOJFOR=AIB.AIB_LOJFOR "
cQry+=" AND AIA_DATATE='' "
cQry+=" WHERE AIB.D_E_L_E_T_='' "
cQry+=" AND AIB_CODFOR='"+cForn+"' "
cQry+=" AND AIB_LOJFOR='"+cLojFor+"' "
cQry+=" AND AIB_CODPRO='"+cProduto+"' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"MODAL",.T.,.T.)

cModal := Alltrim(MODAL->MODAL)
cTabela := Alltrim(MODAL->TABELA)
cCondicao := MODAL->CONDICAO

If !Empty(cModal)
if mv_par14==1
cModal := Upper(Alltrim(RetCombo("AIA_XMODAL",cModal)))
Else
If cModal=="M"
cModal := "SEA"
ElseIf cModal=="A"
cModal := "AIR"
ElseIf cModal=="R"
cModal := "ROAD"
EndIf
End
Else
if mv_par14==1
cModal := "NÃO PREENCHIDO"
Else
cModal := "EMPTY FIELD"
End
EndIf

MODAL->(DbCloseArea("MODAL"))
Return {cModal,cTabela,cCondicao}
*/
Static Function RetCombo(cCampo, cChave)
	Local aSx3Box := RetSx3Box( Posicione("SX3", 2, cCampo, "X3CBox()" ),,, 1 )
Return AllTrim( aSx3Box[aScan( aSx3Box, { |aBox| aBox[2] = cChave } )][3])

Static Function IncluiPedido(aPedido)
	Local nX, aLinha
	Local nSaveSX8 := GetSx8Len()   // Variavel que controla numeracao
	Local cNumPed  := GetSXENum("SC7","C7_NUM")   // Pega o próximo pedido de compra
	Local cItem    := StrZero(0,TamSX3("C7_ITEM")[1])
	Local aCabec   := {}
	Local aItens   := {}
	Local cError   := ""

	//RollBAckSx8()
	conout("Número do pedido: " + cNumPed)
	// Posiciona no fornecedor
	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial("SA2")+aPedido[2]+aPedido[3]))

	aCabec := {		{ "C7_NUM"    , cNumPed         },;
	{ "C7_EMISSAO", dDataBase       },;
	{ "C7_FORNECE", aPedido[2]      },;
	{ "C7_LOJA"   , aPedido[3]      },;
	{ "C7_COND"   , aPedido[4]      },;
	{ "C7_CONTATO", SA2->A2_CONTATO },;
	{ "C7_FILENT" , cFilAnt         } }
	//{ "C7_MOEDA"  , 1               },;
	//{ "C7_TXMOEDA", 0               }}

	For nX:=1 To Len(aPedido[5])
		// Posiciona no produto
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(XFILIAL("SB1")+aPedido[5][nX,1]))

		aLinha := {}

		AAdd( aLinha , { "C7_ITEM"   , cItem:=Soma1(cItem), Nil} )
		AAdd( aLinha , { "C7_PRODUTO", SB1->B1_COD        , Nil} )
		AAdd( aLinha , { "C7_UM"     , SB1->B1_UM         , Nil} )
		If !Empty(SB1->B1_SEGUM)
			AAdd( aLinha , { "C7_SEGUM"  , SB1->B1_SEGUM   , Nil} )
			AAdd( aLinha , { "C7_QTSEGUM", ConvUM(SB1->B1_COD,aPedido[5][nX,2],0,2), Nil} )
		EndIf
		AAdd( aLinha , { "C7_QUANT"  , aPedido[5][nX,2], Nil} )
		AAdd( aLinha , { "C7_PRECO"  , aPedido[5][nX,3], Nil} )
		AAdd( aLinha , { "C7_TOTAL"  , aPedido[5][nX,2] * aPedido[5][nX,3], Nil} )
		AAdd( aLinha , { "C7_OBS"    , aPedido[5][nX,4], Nil} )
		AAdd( aLinha , { "C7_DATPRF" , dDataBase       , Nil} )
		AAdd( aLinha , { "C7_LOCAL"  , SB1->B1_LOCPAD  , Nil} )
		AAdd( aLinha , { "C7_XCC"    , aPedido[5][nX,5], Nil} )
		//AAdd( aLinha , { "C7_CONTA"  , aPedido[5][nX,6], Nil} )
		AAdd( aLinha , { "C7_XCONTRA", aPedido[1]      , Nil} )
		//AAdd( aLinha , { "C7_DESCRI" , SB1->B1_DESC    , Nil} )

		AAdd( aItens , aClone(aLinha) )
	Next

	lMsErroAuto := .F.
	MSExecAuto({|x,y,Z| Mata120(1,x,y,Z)}, aCabec, aItens, 3)   // Inclui o pedido de compra

	If lMsErroAuto
		cError := u_MDResumeErro(MostraErro("\","Error.log"))
		While ( GetSx8Len() > nSaveSX8 )
			RollBackSx8()
		Enddo
		DisarmTransaction()
	Else
		While ( GetSx8Len() > nSaveSX8 )
			ConfirmSX8()
		Enddo
	Endif

Return cError

/*
Alidio/Bruno 01/09/2020.
Rotina para retornar quantidade empenhada / bloqueada
*/

Static Function RetBlok(cComp)

	Local _cQry := ""

	Local nRet := 0 
	
	_cQry := "SELECT SUM(B2_QEMP) AS BLOQ  "
	_cQry += "FROM " + RetSqlName("SB2") + " (NOLOCK) SB2 "
	_cQry += "WHERE SB2.D_E_L_E_T_='' AND B2_COD='" + cComp + "' "
	_cQry += "AND B2_LOCAL IN ('01','70','98','02')  "
	

	_cQry := ChangeQuery(_cQry)
	TCQUERY _cQry Alias TBLK New

	dbSelectArea("TBLK")
	dbGoTop()

	nRet := TBLK->BLOQ
	
    dbCloseArea("TBLK")
	
Return  nRet


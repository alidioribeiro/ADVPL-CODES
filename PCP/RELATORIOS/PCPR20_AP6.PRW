#INCLUDE "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"
#Include "protheus.CH"

USER FUNCTION PCPR20()    


// Alteração Alidio 30/04/2019.


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ DECLARACAO DE VARIAVEIS UTILIZADAS NO PROGRAMA ATRAVES DA FUNCAO    ³
	//³ SETPRVT, QUE CRIARA SOMENTE AS VARIAVEIS DEFINIDAS PELO USUARIO,    ³
	//³ IDENTIFICANDO AS VARIAVEIS PUBLICAS DO SISTEMA UTILIZADAS NO CODIGO ³
	//³ INCLUIDO PELO ASSISTENTE DE CONVERSAO DO AP5 IDE                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SETPRVT("CBTXT,CBCONT,CABEC1,CABEC2,WNREL,TITULO")
	SETPRVT("CDESC1,CDESC2,CDESC3,TAMANHO,LIMITE,XSAIDA")
	SETPRVT("AORD,LCONTINUA,CUM,LEND,ARETURN,NOMEPROG,AMODAL,aPedidos")
	SETPRVT("NLASTKEY,CPERG,XCPI,GQUANT,GF_MPN,GF_MPI")
	SETPRVT("XCOMP,XDATA,XDATFCH,XMES,XDATFIN")
	SETPRVT("CDATINI,CDATFIN,XDATINI,XSALPED,CSTRING")
	SETPRVT("XMRP,XCOMPRA,APDTS,XGERMES,dValIni,dValFin") 
	SETPRVT("xSaldAnt,cSaldAnt,xItem,xGrOpc,xOpc")


	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³FUNCAO    ³ PCPR20   ³ AUTOR ³ JORGE SILVEIRA        ³ DATA ³ 15.07.99 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³DESCRI‡…O ³ CALCULO DA NECESSIDA DE MATERIAIS, CONFORME PLANO MESTRE DE³±±
	±±³          ³ PRODUCAO.                                                  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³SINTAXE   ³ RDMAKE PCPR20 -X                                           ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³PARAMETROS³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ USO      ³                                                            ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ DEFINE VARIAVEIS                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	TITULO    := PADC("MRP - NECESSIDADES DA ESTRUTURA.",74)
	CDESC1    := PADC("ESTE PROGRAMA TEM COM OBJETIVO, GERAR AS NECESSIDADES DE MATERIAS",74)
	CDESC2    := PADC("PRIMAS, BASEADO NO PLANO MESTRE DE PRODUCAO, CONFORME A ESTRUTURA",74)
	CDESC3    := PADC("DE PRODUTOS DENTRO DO PERIODO ESPECIFICADO NOS PARAMETROS.",74)
	TAMANHO   := "G"
	LIMITE    := 220
	CSTRING   := "SHC"
	AORD      := {} //-- ORDEM
	LCONTINUA := .T.
	CUM       := ""
	LEND      := .F.
	ARETURN   := { "ZEBRADO", 1,"ADMINISTRACAO", 2, 2, 1, "",1 }
	NOMEPROG  := "PCPR20"
	NLASTKEY  := 0
	CPERG     := "PCPR02"
	CMES      := {}
	AMSG      := {} 
	ANUM      := {}
	xItem     := 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ VERIFICA AS PERGUNTAS SELECIONADAS                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	PERGUNTE(CPERG,.F.)

	nAno  := Val(subs(mv_par02,3,4))
	AADD(CMES,{"JAN","31","08"})
	AADD(CMES,iif(Mod(nAno,4)==0,{"FEV","29","09"},{"FEV","28","09"}))
	AADD(CMES,{"MAR","31","10"})
	AADD(CMES,{"ABR","30","11"})
	AADD(CMES,{"MAI","31","12"})
	AADD(CMES,{"JUN","30","01"})
	AADD(CMES,{"JUL","31","02"})
	AADD(CMES,{"AGO","31","03"})
	AADD(CMES,{"SET","30","04"})
	AADD(CMES,{"OUT","31","05"})
	AADD(CMES,{"NOV","30","06"})
	AADD(CMES,{"DEZ","31","07"})

	aPedidos := {}
	//
	//
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

	WNREL := "PCPR20"
	WNREL := SETPRINT(CSTRING,WNREL,CPERG,@TITULO,CDESC1,CDESC2,CDESC3,.F.,,)

	IF NLASTKEY==27
		RETURN
	ENDIF

	SETDEFAULT(ARETURN,CSTRING)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ VARIAVEIS UTILIZADAS PARA IMPRESSAO DO CABECALHO E RODAPE  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//
	//
	// Variaveis ALEX

	nCont := 1
	_nMes := Val(substr(mv_par01,1,2))
	_nAno := Val(substr(mv_par01,3,4))
	xMesAno := {}

	// Wagner 18 01 18

	xQuant := 0
	While .T. 
		aadd( xMesAno, CMES[_nMes][2]+"/"+STRZERO(_nMes,2)+"/"+STRZERO(_nAno,4) )
		If _nMes == 12
			_nMes := 0
			_nAno ++
		Endif  
		_nMes ++
		nCont ++

		xQuant++
		If strzero(_nAno,4)+strzero(_nMes,2) > Right(mv_par02,4)+Left(mv_par02,2)
			exit
		Endif
	End 
	//
	nLeadAir := MV_PAR24
	nLeadSea := MV_PAR25
	//
	If nLeadAir == 0
		//MSGINFO("Lead time aereo nao informado! Será utilizado Lead Time padrao de 10 Dias.")
		nLeadAir := 10
	Endif
	//     
	If nLeadSea == 0
		//MSGINFO("Lead time maritimo nao informado! Será utilizado Lead Time padrao de 60 Dias.")
		nLeadSea := 60
	Endif
	//
	CBTXT   := SPACE(10)
	CBCONT  := 00
	LI      := 80
	M_PAG   := 01
	CCABEC  := "   "

	AMSG:= {"SALDO EM ESTOQUE    ",;
	iif(mv_par12==1,"ENTRADAS            ","ENTRADAS (N.C.)     "),;
	"SAIDAS ESTRUTURA    ",;
	iif(mv_par17==2,"SALDO               ","SALDO\PED. ATRASO   "),;
	"NECESSIDADE         ",;
	"MÊS"}

	xCompra := {}
	/*Rmogi 10/02/2007 */
	AMSG1:= {"COMPRAS          US$",;
	"SAIDAS ESTRUTURA US$",;
	"SALDO            US$"}
	aTotUS:={}

	CDIAINI := strzero(day(ddatabase),2)
	CMESINI := VAL(SUBSTR(MV_PAR01,1,2))
	CMESFIN := VAL(SUBSTR(MV_PAR02,1,2))
	CANOINI := VAL(SUBSTR(MV_PAR01,3,4))
	CANOFIN := VAL(SUBSTR(MV_PAR02,3,4))
	CDIAFIN := CMES[CMESFIN][02]
	CDATINI := CTOD( CDIAINI+"/"+STRZERO(CMESINI,2)+"/"+STRZERO(CANOINI,4) )
	CDATFIN := CTOD( CDIAFIN+"/"+STRZERO(CMESFIN,2)+"/"+STRZERO(CANOFIN,4) ) 

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


	DBSELECTAREA("SHC")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SHC") + DTOS(CDATINI), .T.)
	
	xCol    := 026 // Coluna início de impressão do cabeçalho dos meses
	xTamCol := 014 // Espaçamento da coluna de cada mês
	xPos    := {}
	xMeses  := {}
	xIni    := cDatIni

	While xIni <= cDatFin

		If aScan( xMeses, { |x| x[1] = Year(xIni) .and. x[2] = Month( xIni) } ) == 0

			aAdd( xMeses, { Year(xIni), Month( xIni) } ) // Adiciona Ano e Mês no vetor de impressão
			aAdd( xPos, xCol ) // Adiciona posição do mês no vetor

			cCabec += PadL( cMes[ Month( xIni)][1] + "/" + StrZero( Year(xIni), 4), xTamCol) + " "
			xCol += (xTamCol + 1)
		Endif
		xIni ++
	End


	XMRP    := {}
	XGRP    := {}
	XCOMPRA := {}
	APDTS   := {}
	cSaldAnt:= {}
	AcrPer  := ARRAY(XQUANT) // Jorge: 20/09/06
	tmNeces := ARRAY(XQUANT) // Jorge: 20/09/06
	XGERMES := {}
	GQMES   := 0
	GVMES   := 0
	GFMES   := 0
	AIMP    := ARRAY(XQUANT,6)

	FOR XI := 1 TO XQUANT // --> Nr. de Meses
		XM      := STRZERO(XI,2)
		CQUANT  := "GQMES" + XM
		//NMES    := "VMES" + STRZERO(IIF( CMESINI+XI-1 > 12, CMESINI+XI-13, CMESINI+XI-1 ),2)
		NMES    := "VMES" + XM // Wagner 18 01 18
		&CQUANT := 0
		&NMES   := XI
		FOR N:=1 TO 6
			AIMP[XI][N] := 0
		NEXT
		AcrPer[XI]  := 0  // Jorge: 20/09/06
		tmNeces[XI] := 0  // Jorge: 20/09/06
	NEXT
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ DEFINICAO DOS CABECALHOS                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If Mv_Par15 == 1
		TITULO := "MRP - NEED OF MATERIALS"
		//CABEC1 := "PRODUCT          DESCRIPTION                     "+CCABEC+   "       Total"
		CABEC1 := "PRODUCT          DESCRIPTION              "+CCABEC//+"       Total"
		CABEC2 := ""
		//         999999999999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999.999,99  999.999.999,99
		//         12345678901234567890123456789012345678
		//                 10        20        30

		// 123456789012345 1234567890123456789012345    123/1234    123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234   123/1234
		//                                           999,999.999 999,999.999 999,999.999 999,999.999 999,999.999 999,999.999 999,999.999 999,999.999 999,999.999 999,999.999 999,999.999 999,999.999 999,999.999    
		//                                           99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999   
		// 0000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000011111111112
		// 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

	Else
		TITULO := "MRP - NECESSIDADE DE MATERIAIS"
		CABEC1 := "PERIODO                  "+CCABEC
		CABEC2 := ""
		//         XXXXXXXXXXXXXXXXXXXX  999,999,999
		//         12345678901234567890123456789012345678
		//                 10        20        30
	Endif

	IF NLASTKEY == 27
		RETURN
	ENDIF

	//#IFDEF WINDOWS
	
   
	Processa({|| RptDetail()})
	RptStatus({|| pImprime()})
	
	//#ENDIF
	
Return 

Static Function RptDetail()
	//**Marcio Macedo colocar query**/
	dbSelectArea("SHC")
	dbSetOrder(4)
	//dbSeek(xFilial("SHC") + MV_PAR03 + dtos(cDatIni),.T.) 
	dbSeek(xFilial("SHC") + MV_PAR03,.T.)
	ProcRegua(RecCount())

	While !Eof() .And. HC_Produto <= MV_Par04 .And. lContinua

		#IFNDEF WINDOWS
		IF LASTKEY() == 286
			LEND := .T.
		ENDIF
		#ENDIF

		IF LEND
			@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
			LCONTINUA := .F.
			EXIT
		ENDIF

		If ( HC_Data < cDatIni .Or. HC_Data > cDatFin) .or. ( HC_DTVIGEN < cDatIni .Or. HC_DTVIGEN > cDatFin) 
			dbSkip()
			Loop
		Endif 

		XPRODUTO := HC_PRODUTO
		xPASSA   := .T.

		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+xPRODUTO)
		xOpc := AllTrim(B1_Opc)

		dbSelectArea("SHC")  
		While !Eof() .And. xProduto == HC_Produto .And. HC_Data <= cDatFin 

			INCPROC("Processando: "+HC_PRODUTO+" Data: "+dtoc(hc_data)) 

			IF AllTrim(HC_NUMPLAN) <> Alltrim(Mv_par22) .Or. AllTrim(HC_Revisao) <> Alltrim(Mv_par23) // Jorge: 20/03/2012
				DBSKIP()
				LOOP
			ENDIF

			If ( HC_Data < cDatIni .Or. HC_Data > cDatFin) .or. ( HC_DTVIGEN < cDatIni .Or. HC_DTVIGEN > cDatFin) 
				dbSkip()
				Loop
			Endif 

			CPRD    := HC_PRODUTO
			ASTRU   := {}
			ASTRU1   := {}

			NESTRU  := 0
			I       := 0
			dValIni := ctod("01/"+SubStr(dtos(SHC->HC_DATA),5,2)+"/"+SubStr(dtos(SHC->HC_DATA),1,4))
			dValIni := SHC->HC_DATA // ddatabase   // Jorge Em: 25/08/2009
			dValFin := ctod(cMes[month(SHC->HC_DATA)][2]+"/"+SubStr(dtos(SHC->HC_DATA),5,2)+"/"+SubStr(dtos(SHC->HC_DATA),1,4))
			
			ASTRU   := GetStru(CPRD)  // Utilizado até 23/09/2010 teste aglair
			//	ASTRU   := Estrut(CPRD)   // Passou a ser utilizado em 23/09/2010
			XGRP    := {}		
			
			For I:=1 To Len(ASTRU)    // MONTA ESTRUTURA DE PRODUTO.

				CCOMP  := ASTRU[I,3]
				CQNEC  := 0

				dbSelectArea("SG1")  // ESTRUTURA DE PRODUTO
				dbSetOrder(1)
				dbSeek(XFILIAL("SG1")+ASTRU[I,2]+ASTRU[I,3]+ASTRU[I,5]) 

				dbSelectArea("SB1")  // CADASTRO DE PRODUTO
				dbSetOrder(1)
				dbSeek(XFILIAL("SB1")+CCOMP)

				If B1_GRUPO < MV_PAR06 .OR. B1_GRUPO > MV_PAR07 .OR.;
				B1_MRP # "S" .OR. B1_TIPO < MV_PAR09 .OR. B1_TIPO > MV_PAR10 .OR.;
				SG1->G1_FIXVAR<>"V" .OR. B1_ATIVO # "S"
					xPassa := .F.
				Endif

				// Jorge: 28/09/07 (Opcionais Padrao: Verifica Saldo dos Opcionais)
				If !Empty(SG1->G1_GroPc) .And. !(Alltrim(SG1->G1_GroPc)+Alltrim(SG1->G1_Opc) $ xOpc);
				.And. Right(Alltrim(SG1->G1_GrOpc),1) == "0"  // Jorge Em: 05/01/2007
					xPassa := .F.
				Endif

				//			IF (dValIni < SG1->G1_INI .Or. dValFin > SG1->G1_FIM)                                                         // Opcao original
				IF (SHC->HC_DATA < SG1->G1_INI .OR. SHC->HC_DATA > SG1->G1_FIM)                                               // JORGE EM: 01/08/2008			   
					xPassa := .F.
				ENDIF

				If xPassa // Jorge Em: 09/11/2009
					cQNec := ASTRU[I,4] * SHC->HC_Quant
				Endif   

				If cQnec > 0 .and. xPassa // Aglair Em: 12/11/09 - Filtra por Grupo de Opcionais -> Solicitacao do PCP
					nPos := ASCAN(XMRP,{|X| X[1] == CCOMP .AND. MONTH(SHC->HC_DATA) == X[4] .and. YEAR(SHC->HC_DATA) == X[6]})
					yPos := ASCAN(xGRP,{|X| X[1] == CCOMP .AND. MONTH(SHC->HC_DATA) == X[3] .and. YEAR(SHC->HC_DATA) == X[4] .AND. SG1->G1_GrOpc == X[2] .AND. ALLTRIM(SG1->G1_GrOpc)<>"" }) 

					If nPos # 0 .And. yPos = 0                          
						aadd(xGRP,{cComp,;
						SG1->G1_GrOpc,;
						Month(SHC->HC_DATA), Year(SHC->HC_DATA) })
						XMRP[NPOS][02] += CQNEC
					Elseif nPos == 0 
						aadd(XGRP,{cComp, SG1->G1_GrOpc, Month(SHC->HC_DATA),Year(SHC->HC_DATA)})
						aadd(XMRP, {cComp,;			            // 01 COMPONENTE
						cQNec,;						// 02 QUANTIDADE
						SHC->HC_DATA,;				// 03 DATA
						Month(SHC->HC_DATA),;       // 04 MES
						SG1->G1_GrOpc,;             // 05 Grupo de Opcionais
						Year(SHC->HC_DATA) })       // 06 ANO
					Endif  
					cForn := Posicione("SB1",1,xFilial("SB1")+CCOMP,"B1_PROC")
					cLojFor := SB1->B1_LOJPROC

					aModal := {}
					aModal := aClone(u_FModal(CCOMP))

					nPos  := aScan(APDTS,{ |X| X[1] == CCOMP })
					nPos1 := aScan(aPedidos,{ |X| X[1]+X[2]+X[3]== cForn+clojFor+aModal[2] })
					If nPos1==0
						aAdd(aPedidos,{cForn,cLojFor,aModal[2],aModal[3],{}})
						nPos1 := Len(aPedidos)
					EndIf		
					//AAdd( aPedidos, { SB1->B1_COD, nC7_QUANT, nC7_PRECO, cC7_OBS, CTT->CTT_CUSTO, CT1->CT1_CONTA} )		

					If nPos==0

						aadd(APDTS,{CCOMP,;                    // Cod. do Componente
						SG1->G1_GrOpc,;            // Grupo de Opcionais
						SG1->G1_Opc,;              // Item Opcional
						SG1->G1_Cod,;              // Item Opcional
						xOpc,Alltrim(aModal[1]),Alltrim(cForn),Alltrim(aModal[2]) })                    // Opcional Default (SB1)
						aModal := {}
						If mv_par12==1
							SALPED()
						Endif
					Endif                                           
				Endif
				xPassa := .T.
			Next 

			dbSelectArea("SHC")
			dbSkip()

		EndDo
	EndDo

Return

	***********************************
Static Function pImprime()         
	***********************************

	nTipo := Iif(aReturn[4]==1,15,18)
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	
	aSort(aPdts,,,{|x,y| x[1] < y[1]})
	
	SetRegua(Len(aPdts))
	i := 1
	
	_VetEstSeg := {}

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
	For I:=1 to Len(aPdts)

		IncRegua()

		dbSelectArea("SB1")  // CADASTRO DE PRODUTO
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+aPdts[I][1])
		xIndPer := 1 + SB1->B1_INDPER /(100 - SB1->B1_INDPER)  // Jorge: 19/09/06 (Formula fornecida pelo Edy-PCP)
		If MV_PAR11==1
			nInex := B1_PERSEG
		Else
			nInex := 0
		EndIf

		xGrOpc  := {}
		xTotOpc := 0
		
		_nPedAtras := 0
		
		If mv_par08 == 1   // SALDO ATUAL
			// Jorge: 28/09/07 (Opcionais Padrao: Verifica Saldo dos Opcionais)
			If Len(AllTrim(aPdts[I][2]))#0 .And. Alltrim(aPdts[I][2])+Alltrim(aPdts[I][3]) $ aPdts[I][5] //xOpc
				dbSelectArea("SGA")
				dbSetOrder(1)
				dbSeek(xFilial("SGA")+AllTrim(aPdts[I][2]))
				While !Eof() .And. AllTrim(aPdts[I][2]) == GA_GrOpc

					dbSelectArea("SB2")
					dbSetOrder(1)
					dbSeek(xFilial("SB2")+AllTrim(SGA->GA_DescOpc))

					dbSelectArea("SGA")
					If aPdts[I][3] # GA_Opc
						aadd(xGrOpc,{aPdts[I][2],;              // Grupo de Opcionais
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
				nPos := ASCAN(cSaldAnt,B2_COD)
				aImp[1][1] := iif(nPos<>0,cSaldAnt[ASCAN(cSaldAnt,B2_COD)][2],0)+Iif(SubStr(aPdts[I][2],3,1)=="0",xTotOpc,0)  // Jorge Em: 06.02.2007
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
				aImp[1][1] := Iif(SubStr(aPdts[I][2],3,1)=="0",xTotOpc,0)
			Endif
		Else  // SALDO MOVIMENTO. 
			If Len(AllTrim(aPdts[I][2]))#0 .And. Alltrim(aPdts[I][2])+Alltrim(aPdts[I][3]) $ aPdts[I][5] // xOpc
				dbSelectArea("SGA")
				dbSetOrder(1)
				dbSeek(xFilial("SGA")+AllTrim(aPdts[I][2]))
				While !Eof() .And. AllTrim(aPdts[I][2]) == GA_GrOpc
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
					If aPdts[I][3] # GA_Opc
						aadd(xGrOpc,{aPdts[I][2],;              // Grupo de Opcionais
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
			aImp[1][1] := xEst01 + xEst10 + xEst70 + xEst98 + xEstA1 + Iif(SubStr(aPdts[I][2],3,1)=="0",xTotOpc,0) // Jorge Em: 01.02.2007
			//EndIf
		EndIf

		c_Comp := aPdts[I][1]

		For N := 1 TO xQuant // (Total de meses a serem impressos)
			AcrPer[N] := 0
			nPos := aScan(xCompra ,{|X| X[1] == c_Comp .and. X[4] == Month(CtoD(xMesAno[n])) .and. X[5] == Year(CtoD(xMesAno[n]))})
			aImp[N][2] := IIF(nPos<>0, xCompra[nPos][2], 0) 
			nPos := aScan(xMRP    ,{|X| X[1] == c_comp .and. X[4] == Month(CTod(xMesAno[n])) .and. x[6] == Year(CToD(xMesAno[n]))})
			aImp[N][3] := IIF(nPos<>0, xMRP[nPos][2]   , 0)
			If aImp[N][3] > 0 // Jorge: 20/09/06
				AcrPer[N] := (aImp[N][3] * xIndPer - aImp[N][3]) 
			End   
		Next

		_nNecAnt := 0

		nTNec := 0
		_GrvEstSeg := .T.
		
		// 1a. Passagem
		For N := 1 to xQuant   // Nr. de meses a serem impressos
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
				aadd(_VetEstSeg,{sb1->b1_cod,sb1->b1_estseg,nPrev,ddatabase})
				RecLock("SB1",.F.)                
				SB1->B1_ESTSEG := nPrev  
				SB1->(MsUnlock())
				_GrvEstSeg := .F.
			End

			aImp[N][4] := aImp[N][1] + aImp[N][2] - aImp[N][3] - AcrPer[N] //remerson 04/01/07

			/*Compras em atraso 07/01/07*/
			If mv_par17==1 
				If N==1
					cPos := aScan(cSaldAnt,{|X| X[1] == c_Comp})
					aImp[N][4] += cSaldAnt[cPos][2]
				End
			End
			/*Compras em atraso 07/01/07*/		
			nImp3 := nPrev  // Iif(nPrev<>0,nPrev,Iif(N<xQuant,AIMP[N+1][3],0))
			aImp[N][5] := Iif(nImp3-aImp[N][4]<=0,0,(nImp3-aImp[N][4]) + AcrPer[N] ) // * xIndPer )  // Jorge: 19/09/06
			If SB1->B1_LE > 0
				aImp[N][5] := Iif(Mod(aImp[N][5],SB1->B1_LE)==0,aImp[N][5],INT((aImp[N][5]/SB1->B1_LE)+1)*SB1->B1_LE)   // Jorge: 19/09/06
			End


			If N < xQuant  // NR. de meses a serem impressos
				aImp[N+1][1]  := aImp[N][4] + aImp[N][5]
			EndIf

			aImp[n,6] := Round( (aImp[n,1] - (_nNecAnt + _nPedAtras ))/ aImp[n,3], 1)

			_nNecAnt := aImp[n, 5]

		Next
		
		// 2a. Passagem Cálculo Meses
		/*
		_nNecAnt := 0
		For N := 1 to xQuant   // Nr. de meses a serem impressos

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

			@ LI,000      PSAY aPdts[I][1]        			 			     	// COMPONENTE
			if mv_par14==1
				@ LI,PCOL()+1 PSAY SubStr(SB1->B1_DESC,1,25)			     	// DESCRICAO PORTUGUES
			Else
				@ LI,PCOL()+1 PSAY SubStr(SB1->B1_DESC_EN,1,25)			   	// DESCRICAO INGLES
			End
			xTotNec := 0
			_undMed:= subs(Posicione("SB1",1,xFilial("SB1")+aPdts[I][1],"B1_UM"),1,2)  

			xCol := 43

			For M:=1 to xQuant
				@ LI, xCol PSAY Transform(aImp[M][5],"@E 999,999.999")
				tmNeces[M] := tmNeces[M] + aImp[M][5]   
				xTotNec := xTotNec + aImp[M][5]
				xCol += 12 
			Next

			//@ LI,PCOL()+2 PSAY Transform(xTotNec,"@E 99,999,999")
			li++                                     

			If Li > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			EndIf
		Else
			@ LI,000      PSAY "PRODUTO: " + aPdts[I][1]        			 				// COMPONENTE
			@ LI,PCOL()+3 PSAY SubStr(SB1->B1_DESC,1,40)				    				// DESCRICAO PORTUGUES
			if mv_par14==2
				@ LI,PCOL()+3 PSAY SubStr(SB1->B1_DESC_EN,1,30)			           		// DESCRICAO INGLES
			end

			cPos:=ascan(cSaldAnt,{|X| X[1] == aPdts[I][1]})

			@ LI,PCOL()+1 PSAY "UM: "         + SB1->B1_UM 								// UM
			@ LI,PCOL()+1 PSAY "TIPO: "       + SB1->B1_TIPO 		    					// TIPO
			@ LI,PCOL()+1 PSAY "GRUPO: "      + SubStr(SB1->B1_GRUPO,1,3)					// GRUPO
			@ LI,PCOL()+1 PSAY "SEGURANÇA:"   + Transform(nInex         , "@e 99.99")	 	// ESTOQUE SEGURANÇA
			@ LI,PCOL()+1 PSAY "IND.PERDA:"   + Transform(SB1->B1_INDPER, "@e 99.99%")	 	// INDICE DE PERDA
			@ LI,PCOL()+1 PSAY "LOTE ECONOM:" + Transform(SB1->B1_LE,"@e 999,999")	    // LOTE ECONOMICO
			IF cSaldAnt[cPos][2] > 0  
				@ LI,PCOL()+3 PSAY "PED. ATRASO:" + Transform(cSaldAnt[cPos][2],"@e 999,999")// Saldos de Compras
			End
			Li+=1
			@ LI,000 PSAY "MODAL:"+aPdts[I][6]                              //  Alidio Ribeiro 30/04/2019
			@ LI,PCOL()+1 PSAY "FORN.:" + SB1->B1_PROC + " - " + SB1->B1_LOJPROC + " " + Left( Posicione("SA2",1,xFilial("SA2")+SB1->B1_PROC+SB1->B1_LOJPROC,"A2_NOME" ),30)+"TAB.:"+Alltrim(aPdts[I][8])  + "  " + "Saldos A1 e 10.:"+STR(CalcEst(aPdts[I][1], "A1", dDataBase)[1])+ " -- " + STR(CalcEst(aPdts[I][1], "10", dDataBase)[1]) //
			Li+=2
			_undMed:= subs(Posicione("SB1",1,xFilial("SB1")+aPdts[I][1],"B1_UM"),1,2)  	   	                 	                 

			IF Mv_Par15 == 3 // Resumo das necessidades na Moeda Estrangeira.
				A :=0                                                                    
				xPrPro := U_QuanProd(aPdts[I][1]) /*captura o preco do produto de acordo com a tabela 001*/       
				For N:=5 to 1 step -1 
					For M:=1 to xQuant
						If M==1  .And. (N==5 .or. N==3  .or. N==1) 
							Do case 
								case N == 5
								A:=1
								case N == 3
								A:=2
								case N == 1  
								A:=3
							End case
							@ LI,000  PSAY aMsg1[A]
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
								tmNeces[M] := tmNeces[M] + aImp[M][5]
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
						//@ LI,xCol PSAY ""
					End
				Next       	   
				@ LI,000 PSAY Replicate("-",Limite)
				Li += 1
				If Li > 65
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				EndIf
			Else // Mv_Par15 == 2
				For N:=1 to 6  // Nr. de Linhas
					xCol := 29
					For M:=1 to xQuant // Nr. de Colunas
						If M==1
							@ LI,000  PSAY aMsg[N]
						End
						@ LI, xCol PSAY IIF(AllTrim(_undMed)$"KG/L/", Transform(aImp[M][N],"@E 9,999,999.999"), Transform(aImp[M][N],"@E 9,999,999.999"))
						IF N==5 .And. M == 5 .And. mv_par16 == 1 .And. aImp[M][N] > 0 // Jorge Em: 05/09/07
							xItem += 1
							geraSolCompra(M,aImp[M][N],aPdts[I][1],xItem) // Jorge Em: 05/09/07
						EndIf
						xCol += 15
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

			@ LI,000 PSAY Replicate("-",Limite)
			Li += 1

			If Li > 58
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			EndIf
		End
	Next   

	If MV_Par15==1 // Gera Planinha somente com as necessidades.
		li++
		@ LI,000      PSAY "Total Geral    "//+space(42)
		xGerNec := 0   
		xCol := 42
		For M:=1 to xQuant
			@ LI,xCol PSAY Transform(tmNeces[M],"@E 999999.999")
			xGerNec := xGerNec + tmNeces[M]
			xCol += 11
		Next
		//@ LI,PCOL()+2 PSAY Transform(xGerNec,"@E 99,999,999")
		li++
	Elseif MV_Par15==3   //aTotUS:={}
		If len(aTotUS)<>0
			Li++
			@ LI,000      PSAY "Total Geral    "+space(42)
			Li+=2
			For N:=1 to 3
				For M:=1 to xQuant
					If M==1
						@ LI,000  PSAY aMsg1[N]
					End 
					@ LI,PCOL()+2 PSAY Transform(aTotUS[M][N],"@E 999,999,999.99")
				Next
				li++
			Next
		Else
			msgstop("Produto não gerou necessidade")
		End
	End     
	If Len(_VetEstSeg)>0
		//GRelEstSeg()  Retirado Alidio testes 
	EndIf

	Set Device To Screen

	If ARETURN[5] == 1
		Set Printer To
		DBCOMMITALL()
		OurSpool(WNREL)
	EndIf
	MS_FLUSH()
	Return
	**********************************************
Static Function GRelEstSeg

	aCampos:={} 
	cDirDocs  :="\RELATO\"                                                                                                                                  
	AADD(aCampos, {"COD  "     ,"C",15,0})
	AADD(aCampos, {"DESC  "    ,"C",50,0})
	AADD(aCampos, {"ESEGANT    "    ,"N",14,2})
	AADD(aCampos, {"ESEGATU    "    ,"N",14,2})
	AADD(aCampos, {"DATAATU    "    ,"D",9,0})

	cArq := Criatrab( ,.F.)
	dbCreate(cDirDocs+"\"+cArq,aCampos,"DBFCDXADS")             //Cria o arquivo no caminho especificado
	dbUseArea(.T.,"DBFCDXADS",cDirDocs+"\"+cArq,"TRX",.F.,.F.) //Seleciona o arquivo para uso.

	For i:=1 to Len(_VetEstSeg)
		DbSelectArea("TRX")
		RecLock("TRX",.T.)  //	{sb1->b1_cod,sb1->b1_estseg,nPrev,ddatabase}
		TRX->COD:=_VetEstSeg[i][1]
		TRX->DESC:=Posicione("SB1",1,xFilial("SB1")+_VetEstSeg[i][1],"B1_DESC")   
		TRX->ESEGANT:=_VetEstSeg[i][2]
		TRX->ESEGATU:=_VetEstSeg[i][3]
		TRX->DATAATU:=_VetEstSeg[i][4]	
		MsUnlock()
	Next
	cNameTmp := STRTRAN(Dtoc(Date()),"/","")+STRTRAN(TIME(),":","")
	cDirDocs  :="\RELATO\"
	cPath="C:\RELATORIO_SIGA"
	cNome := "AtuEstSeg-"+cNameTmp+".XLS"

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


	************************************
Static Function SalPed()
	************************************

	_cQry := "SELECT SUM(SC7.C7_QUANT - SC7.C7_QUJE) AS COMPRA_ANT " 
	_cQry += "FROM " + RetSqlName("SC7") + " (NOLOCK) SC7 "
	_cQry += "WHERE SC7.D_E_L_E_T_='' AND C7_PRODUTO='" + cComp + "' "
	_cQry += "AND SC7.C7_DATPRF>='" + DtoS(mv_par18)+ "' "
	_cQry += "AND SC7.C7_DATPRF< '" + Dtos(cDatIni)+ "' "
	_cQry += "AND SC7.C7_RESIDUO<>'S' "

	_cQry := ChangeQuery(_cQry)
	TCQUERY _cQry Alias TMRP New 

	dbSelectArea("TMRP")
	dbGoTop()

	xSaldAnt := COMPRA_ANT

	dbCloseArea("TMRP") 

	aadd(cSaldAnt,{cComp,xSaldAnt})
	//
	xSalped := 0
	xSaida  := 0

	SC7->(DbSetOrder(7))
	SC7->(DbSeek(xFilial("SC7")+cComp+DtoS(cDatIni),.T.))

 	While !SC7->(Eof()) .And. cComp == SC7->C7_PRODUTO .and. SC7->C7_DATPRF <= cDatFin

		xMesComp := MONTH(SC7->C7_DATPRF)
		xaNOComp := YEAR(SC7->C7_DATPRF)
		xCompMes := 0
		While !SC7->(Eof()) .and. cComp == SC7->C7_PRODUTO .and. SC7->C7_DATPRF <= cDatFin .and. xMesComp == Month(SC7->C7_DATPRF)

			If SC7->C7_RESIDUO # "S"
				xCompMes += (SC7->C7_QUANT - SC7->C7_QUJE)
			End

			SC7->(dbSkip())
		EndDo     

		nPos := aScan(xCompra,{|X| X[1] == cComp .And. xMescomp == X[4] .and. x[5] = xAnoComp } )

		If nPos == 0
			aAdd(xCompra, {cComp,;	   // 01 COMPONENTE
			xCompMes,;  // 02 QUANTIDADE
			SC7->C7_DATPRF,; // 03 DATA
			xMescomp,;  // 04 MES
			xAnoComp})  // 05 ANO
		EndIf

	EndDo

	Return()

	******************************
Static Function GetStru(cProd)
	******************************

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

			AADD(ANUM,{CMES[mesRef][1],mesRef,_nextNum,1})
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


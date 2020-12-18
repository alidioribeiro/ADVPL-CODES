#INCLUDE "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"
//
//
//
USER FUNCTION PCPR20()

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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
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

Pergunte( cPerg, .F.)

nAno  := Val(subs(mv_par02,3,4))
aAdd( cMes, {"JAN", "31", "08"})
aAdd( cMes, IIF(Mod(nAno,4)==0,{"FEV","29","09"},{"FEV","28","09"}))
aAdd( cMes, {"MAR", "31", "10"})
aAdd( cMes, {"ABR", "30", "11"})
aAdd( cMes, {"MAI", "31", "12"})
aAdd( cMes, {"JUN", "30", "01"})
aAdd( cMes, {"JUL", "31", "02"})
aAdd( cMes, {"AGO", "31", "03"})
aAdd( cMes, {"SET", "30", "04"})
aAdd( cMes, {"OUT", "31", "05"})
aAdd( cMes, {"NOV", "30", "06"})
aAdd( cMes, {"DEZ", "31", "07"})

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
WNREL := SETPRINT( CSTRING, WNREL, CPERG, @TITULO, CDESC1, CDESC2, CDESC3,.F.,,)

IF nLastKey == 27
	Return
EndIf

SetDefault( aReturn, cString)

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

nLeadAir := mv_par24
nLeadSea := mv_par25

If nLeadAir == 0
	nLeadAir := 10
Endif

If nLeadSea == 0
	nLeadSea := 60
Endif

cbTXT  := Space(10)
cbCONT := 00
li     := 80
m_Pag  := 01
cCabec := ""

aMsg := {"SALDO EM ESTOQUE    ",;
          IIF(mv_par12==1, "ENTRADAS            ", "ENTRADAS (N.C.)     "),;
         "SAIDAS ESTRUTURA    ",;
          IIF(mv_par17==2,"SALDO                ","SALDO\PED. ATRASO   "),;
         "NECESSIDADE         ",;
         "MÊS"}

xCompra := {}

aMsg1:= {"COMPRAS          US$",;
         "SAIDAS ESTRUTURA US$",;
         "SALDO            US$"}

aTotUS:={}

cDiaIni := StrZero( Day(dDatabase), 2)

cMesIni := Val( SubStr( mv_par01, 1, 2) )
cMesFin := Val( SubStr( mv_par02, 1, 2) )
cAnoIni := Val( SubStr( mv_par01, 3, 4) )
cAnoFin := Val( SubStr( mv_par02, 3, 4) )

CDIAFIN := CMES[ CMESFIN][02]
CDATINI := CTOD( CDIAINI+"/"+STRZERO(CMESINI,2)+"/"+STRZERO(CANOINI,4) )
CDATFIN := CTOD( CDIAFIN+"/"+STRZERO(CMESFIN,2)+"/"+STRZERO(CANOFIN,4) )

dbSelectArea("SHC")
dbSetOrder(1)
dbSeek( xFilial("SHC") + DtoS(cDatIni), .T.)

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

For XI := 1 TO XQUANT // --> Nr. de Meses
	XM      := STRZERO(XI,2)
	CQUANT  := "GQMES" + XM
	NMES    := "VMES" + XM // Wagner 18 01 18
	&CQUANT := 0
	&NMES   := XI
	FOR N:=1 TO 6
		AIMP[XI][N] := 0
	NEXT
	AcrPer[XI]  := 0  // Jorge: 20/09/06
	tmNeces[XI] := 0  // Jorge: 20/09/06
Next
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ DEFINICAO DOS CABECALHOS                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// --------------------------------------------
// MONTA CABECALHO PARA IMPRESSAO DE RELATORIO.
// --------------------------------------------

// PERIODO                      jan/2018        fev/2018        mar/2018        abr/2018         mai/2018         jun/2018         jul/2018         jul/2018         ago/2018         set/2018         out/2018         nov/2018        dez/2018
// PRODUTO: 123456789012345     123/1234        123/1234        123/1234        123/1234         123/1234         123/1234         123/1234         123/1234         123/1234         123/1234         123/1234         123/1234        123/1234
//                           999,999,999 1,1 999,999,999 1,1 999,999,999 1,1 999,999,999 1,1 999,999,999 12,1 999,999,999 12,1 999,999,999 12,1 999,999,999 12,1 999,999,999 12,1 999,999,999 12,1 999,999,999 12,1 999,999,999 12,1 999,999,999
// 0000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000011111111112
// 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

// PERIODO
// 123456789012345 1234567890123456789012345    123/1234        123/1234      123/1234      123/1234      123/1234      123/1234      123/1234      123/1234      123/1234      123/1234      123/1234    123/1234
//                                           9,999,999.999 9,999,999.999 9,999,999.999 9,999,999.999 9,999,999.999 9,999,999.999 9,999,999.999 9,999,999.999 9,999,999.999 9,999,999.999 9,999,999.999 9,999,999.999
// 0000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000011111111112
// 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890


If Mv_Par15 == 1 // Gera somente necessidade
	TITULO := "MRP - NEED OF MATERIALS"
	CABEC1 := "PRODUCT         DESCRIPTION              " + CCABEC
	CABEC2 := ""
Else
	TITULO := "MRP - NECESSIDADE DE MATERIAIS"
	CABEC1 := "PERIODO                  " + CCABEC
	CABEC2 := ""
Endif

If nLastKey == 27
	Return
EndIf

Processa({|| RptDetail()})
RptStatus({|| pImprime()})
Return
//
//
//
Static Function RptDetail()
                           
_cQry := "SELECT * "
_cQry +=    "FROM " + RetSqlName("SHC") + " SHC "
_cQry += "WHERE SHC.D_E_L_E_T_='' "
_cQry +=    "AND HC_DATA BETWEEN '" + DtoS(cDatIni) + "' AND '" + DtoS(cDatFin) + "' "
_cQry +=    "AND HC_DTVIGEN BETWEEN '" + DtoS(cDatIni) + "' AND '" + DtoS(cDatFin)+ "' "
_cQry +=    "AND HC_PRODUTO BETWEEN '" + mv_par03 + "' AND '" + mv_par04+ "' "
_cQry +=    "AND HC_NUMPLAN='" + mv_par22 + "' AND HC_REVISAO='" + mv_par23 + "' "
_cQry += "ORDER BY HC_PRODUTO, HC_DATA "

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQry), "THC",.T.,.T.)

dbSelectArea("THC")
dbGoTop()
ProcRegua(RecCount())

While !Eof()
	
	xProduto := HC_PRODUTO
	xPassa   := .T.
	
	xOpc := AllTrim(Posicione("SB1", 1, xFilial("SB1")+xProduto, "B1_OPC"))
	
	While !Eof() .and. xProduto == HC_PRODUTO
		
		INCPROC("Processando: " + HC_PRODUTO + " Data: " + DtoC(StoD(HC_DATA)) )
		
		cPrd   := HC_PRODUTO
		aStru  := {}
		aStru1 := {}
		
		nEstru  := 0
		i       := 0
		dValIni := HC_DATA
		dValFin := CtoD( cMes[ Val(SubStr(HC_DATA,5,2)), 2] + "/" + SubStr(HC_DATA, 5, 2) + "/" + SubStr( HC_DATA, 1, 4) )
		aStru   := GetStru(cPrd)
		
		xGrp    := {}
		
		For i:=1 To Len(aStru) // MONTA ESTRUTURA DE PRODUTO.
			
			cComp := aStru[ i, 3]
			cQNec := 0
			
			dbSelectArea("SG1") // ESTRUTURA DE PRODUTO
			dbSetOrder(1)
			dbSeek( xFilial("SG1") + aStru[i,2] + aStru[i,3] + aStru[i,5])
			
			dbSelectArea("SB1") // CADASTRO DE PRODUTO
			dbSetOrder(1)
			dbSeek( xFilial("SB1") + cComp)
			
			If (B1_MRP <> 'S' .or. B1_ATIVO <> "S") .or. ;
			   (B1_GRUPO < mv_par06 .or. B1_GRUPO > mv_par07) .or. ;
			   (B1_TIPO  < mv_par09 .or. B1_TIPO  > mv_par10) .or. ;
				SG1->G1_FIXVAR <> "V"
				
				dbSelectArea("THC")
				dbSkip()
				Loop
			Endif
			
			If !Empty(SG1->G1_GROPC) .and. !(Alltrim(SG1->G1_GROPC) + Alltrim(SG1->G1_OPC) $ xOpc) .and.;
				Right(Alltrim(SG1->G1_GROPC), 1) == "0"
				dbSelectArea("THC")
				dbSkip()
				Loop
			Endif

			If ( StoD(THC->HC_DATA) < SG1->G1_INI .OR. Stod(THC->HC_DATA) > SG1->G1_FIM)
				dbSelectArea("THC")
				dbSkip()
				Loop
			ENDIF
			
			cQNec := aStru[I,4] * THC->HC_QUANT
			
			If cQnec > 0
			
				nPos := aScan( xMRP,{|x| x[1] == cComp .and. SubStr(THC->HC_DATA,5,2) == x[4] .and. SubStr(THC->HC_DATA,1,4) == x[6]})
				yPos := aScan( xGRP,{|x| x[1] == cComp .and. SubStr(THC->HC_DATA,5,2) == x[3] .and. SubStr(THC->HC_DATA,1,4) == x[4] .and. SG1->G1_GROPC == x[2] .and. AllTrim(SG1->G1_GROPC) <> "" })
				
				If nPos <> 0 .And. yPos = 0
					
					aAdd(xGRP, { cComp, SG1->G1_GROPC, SubStr(THC->HC_DATA,5,2), SubStr(THC->HC_DATA,1,4) } )
					xMRP[nPos , 2] += cQNec
				
				Elseif nPos == 0

					aAdd( xGRP, { cComp, SG1->G1_GROPC, SubStr(THC->HC_DATA,5,2), SubStr(THC->HC_DATA,1,4) } )
					aAdd( xMRP, { cComp,;                      // 01 COMPONENTE
					              cQNec,;                      // 02 QUANTIDADE
					              StoD(THC->HC_DATA),;         // 03 DATA
					              SubStr(THC->HC_DATA,5,2),;   // 04 MES
					              SG1->G1_GROPC,;              // 05 GRUPO DE OPCIONAIS
					              SubStr(THC->HC_DATA,1,4) } ) // 06 ANO

				Endif
				
				cForn   := SB1->B1_PROC
				cLojFor := SB1->B1_LOJPROC
				
				aModal := {}
				aModal := aClone( u_FModal(cComp) )
				
				If aScan( aPdts, { |x| x[1] == cComp }) = 0
					If aScan( aPedidos, { |x| x[1] + x[2] + x[3] == cForn+clojFor+aModal[2] } ) = 0
						aAdd(aPedidos,{cForn,cLojFor,aModal[2],aModal[3],{}})
						nPos1 := Len(aPedidos)
					EndIf
					aAdd( aPDTS, { cComp,; // Cod. do Componente
					               SG1->G1_GROPC,;     // Grupo de Opcionais
					               SG1->G1_OPC,;       // Item Opcional
					               SG1->G1_COD,;       // Item Opcional
				                   xOpc,Alltrim( aModal[1]), AllTrim(cForn), Alltrim(aModal[2]) }) // Opcional Default (SB1)
					aModal := {}
					
					If mv_par12==1
						SALPED()
					Endif
				EndIf

			Endif
			xPassa := .T.
		Next
		
		dbSelectArea("THC")
		dbSkip()
		
	EndDo
EndDo

dbSelectArea("THC")
dbCloseArea()

Return
//
//
//
Static Function pImprime()
//
//
//
nTipo := Iif(aReturn[4]==1,15,18)
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
aSort(aPdts,,,{|x,y| x[1] < y[1]})

SetRegua(Len(aPdts))
I := 1
_VetEstSeg := {}

// Limpa os produtos com estoque de segurança para geração do MRP
If mv_par20=1 // Considera Estoque de Segurança
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial()+mv_par03,.T.)
	While !Eof() .and. SB1->B1_COD <= mv_par04
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
	dbSeek(xFilial("SB1") + aPdts[I][1])

	xIndPer := 1 + SB1->B1_INDPER / (100 - SB1->B1_INDPER)  // Jorge: 19/09/06 (Formula fornecida pelo Edy-PCP)
	If mv_par11 == 1
		nInex := B1_PERSEG
	Else
		nInex := 0
	EndIf
	
	xGrOpc  := {}
	xTotOpc := 0
	
	_nPedAtras := 0

	If mv_par08 == 1 // SALDO ATUAL
		If Len( AllTrim( aPdts[i][2])) <> 0 .and. AllTrim( aPdts[i,2]) + AllTrim( aPdts[i][3]) $ aPdts[i][5]
			
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
					Iif(mv_par21==1,SB2->B2_qAtu,SB2->B2_qAtu-SB2->B2_qEmp)})            // Jorge Em: 25/10/11 - Saldos bloqueados
					xTotOpc := xTotOpc + Iif(mv_par21==1,SB2->B2_qAtu,SB2->B2_qAtu-SB2->B2_qEmp)    // SB2->B2_qAtu
				Endif
				dbSkip()
			EndDo
		EndIf 
		
		dbSelectArea("SB2")
		dbSetOrder(1)
		If dbSeek(xFilial("SB2") + SB1->B1_COD)
			nPos := aScan( cSaldAnt, B2_COD)
			aImp[ 1, 1] := IIF( nPos<>0, cSaldAnt[ aScan( cSaldAnt, B2_COD)][2],0) + IIF( SubStr( aPdts[i, 2], 3, 1)=="0", xTotOpc, 0)
			If nPos <> 0
				While !Eof() .And. SB1->B1_COD==B2_COD
					If B2_Local $ If(Mv_Par19==1, "01-10-70-98-A1", "01-70-98-A1")
						aImp[1][1] := aImp[1][1] + IIF( mv_par21==1, B2_QATU, B2_QATU - B2_QEMP) // B2_QATU
					Endif
					dbSkip()
				EndDo
			Else
				While !Eof() .And. SB1->B1_COD==B2_COD
					If B2_Local $ If(Mv_Par19==1,"01-10-70-98-A1","01-70-98-A1") // Jorge Em: 20/03/2008       //incluso armazém A1 03/05/2016 Nilton
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
				xEstA1  := CalcEst(AllTrim(SGA->GA_DescOpc),"A1",dDataBase)[1] //incluso armazém A1 03/05/2016 Nilton
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
		xEst01  := CalcEst(SB1->B1_COD,"01",dDataBase)[1]
		If Mv_Par19 == 1
			xEst10  := CalcEst(SB1->B1_COD,"10",dDataBase)[1]
		Else
			xEst10  := 0
		End
		If SB1->B1_Tipo # "MP"
			xEst70  := CalcEst(SB1->B1_COD,"70",dDataBase)[1]
		Else
			xEst70  := 0
		End
		xEst98  := CalcEst(SB1->B1_COD, "98", dDataBase)[1]
		xEstA1  := CalcEst(SB1->B1_COD, "A1", dDataBase)[1]
		aImp[1][1] := xEst01 + xEst10 + xEst70 + xEst98 + xEstA1 + Iif(SubStr(aPdts[I][2],3,1)=="0",xTotOpc,0) // Jorge Em: 01.02.2007
		//EndIf
	EndIf
	
	c_Comp := aPdts[I][1]
	
	For N := 1 TO xQuant // (Total de meses a serem impressos)
		AcrPer[N] := 0
		nPos := aScan( xCompra ,{ |x| x[1] == c_Comp .and. x[4] == Month( CtoD( xMesAno[n])) .and. x[5] == Year( CtoD(xMesAno[n]))})
		aImp[N][2] := IIF(nPos<>0, xCompra[nPos][2], 0)
		nPos := aScan(xMRP    ,{|x| x[1] == c_comp .and. x[4] == SubStr(xMesAno[n],4,2) .and. x[6] == SubStr(xMesAno[n],7,4)})
		aImp[N][3] := IIF(nPos<>0, xMRP[nPos][2]   , 0)
		If aImp[N][3] > 0 // Jorge: 20/09/06
			AcrPer[N] := (aImp[N][3] * xIndPer - aImp[N][3])
		End
	Next
	
	_nNecAnt := 0
	
	nTNec := 0
	_GrvEstSeg := .T.
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
		
		aImp[N][4] := aImp[N][1] + aImp[N][2] - aImp[N][3] - AcrPer[N]
		
		If mv_par17==1
			If N==1
				cPos := aScan(cSaldAnt,{|X| X[1] == c_Comp})
				aImp[N][4] += cSaldAnt[cPos][2]
				_nPedAtras := cSaldAnt[cPos][2]
			End
		End

		nImp3 := nPrev
		aImp[N][5] := IIF( nImp3 - aImp[N][4] <= 0 , 0, (nImp3-aImp[N][4]) + AcrPer[N] )
		
		If SB1->B1_LE > 0
			aImp[N][5] := IIF( Mod(aImp[N][5], SB1->B1_LE)==0, aImp[N][5], INT((aImp[N][5]/SB1->B1_LE) + 1) * SB1->B1_LE)
		EndiF
		nTNec += aImp[N][5]
		
		If N < xQuant  // NR. de meses a serem impressos
			aImp[N+1][1]  := aImp[N][4] + aImp[N][5]
		EndIf
		
		aImp[n,6] := Round( (aImp[n,1] - (_nNecAnt + _nPedAtras ))/ aImp[n,3], 1)

		_nNecAnt := aImp[n, 5]
		_nPedAtras := 0
	Next	

	If nTNec==0 .and. mv_par13==1
		Loop
	EndIf
	

	
	If mv_par15 == 1 // Gera Planinha somente com as necessidades.
		
		@ li, 000      PSAY aPdts[I][1] // COMPONENTE
		@ li, PCol()+1 PSAY SubStr( IIF(mv_par14==1, SB1->B1_DESC, SB1->B1_DESC_EN), 1, 25) // DESCRICAO PORTUGUES/INGLES

		xTotNec := 0
		_undMed:= subs(Posicione("SB1",1,xFilial("SB1")+aPdts[I][1],"B1_UM"),1,2)
		
		xCol := 43
		
		For M:=1 to xQuant
			@ LI, xCol PSAY Transform(aImp[M][5],"@E 9,999,999.999")
			tmNeces[M] := tmNeces[M] + aImp[M][5]
			xTotNec := xTotNec + aImp[M][5]
			xCol += 15
		Next
		
		li++
		
		If li > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		EndIf
	Else
		@ li, 000      PSAY "PRODUTO: " + aPdts[I][1] // COMPONENTE
		@ li, PCol()+3 PSAY SubStr(SB1->B1_DESC,1,40) // DESCRICAO PORTUGUES
		If mv_par14=2
			@ LI,PCol()+3 PSAY SubStr(SB1->B1_DESC_EN,1,30) // DESCRICAO INGLES
		EndIf

		cPos := aScan(cSaldAnt,{|X| X[1] == aPdts[I][1]})

		@ li, PCol() + 1 PSAY "UM: "         + SB1->B1_UM                             // UM
		@ li, PCol() + 1 PSAY "TIPO: "       + SB1->B1_TIPO                           // TIPO
		@ li, PCol() + 1 PSAY "GRUPO: "      + SubStr(SB1->B1_GRUPO,1,3)              // GRUPO
		@ li, PCol() + 1 PSAY "SEGURANÇA:"   + Transform(nInex         , "@e 99.99")  // ESTOQUE SEGURANÇA
		@ li, PCol() + 1 PSAY "IND.PERDA:"   + Transform(SB1->B1_INDPER, "@e 99.99%") // INDICE DE PERDA
		@ li, PCol() + 1 PSAY "LOTE ECONOM:" + Transform(SB1->B1_LE,"@e 999,999")     // LOTE ECONOMICO

		If cSaldAnt[cPos][2] > 0
			@ li, PCol() + 3 PSAY "PED. ATRASO:" + Transform(cSaldAnt[cPos][2],"@e 999,999")// Saldos de Compras
		End
		
		li += 1
		
		@ LI,000 PSAY "MODAL:"+aPdts[I][6]
		@ LI,PCOL()+1 PSAY "FORN.:" + SB1->B1_PROC + " - " + SB1->B1_LOJPROC + " " + Left( Posicione("SA2",1,xFilial("SA2")+SB1->B1_PROC+SB1->B1_LOJPROC,"A2_NOME" ), 30)+" TAB.: " + AllTrim(aPdts[i,8])
		Li+=2
		_undMed:= subs(Posicione("SB1",1,xFilial("SB1")+aPdts[I][1],"B1_UM"),1,2)
		
		If mv_Par15 == 3 // Resumo das necessidades na Moeda Estrangeira.
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
						EndCase
						@ LI,000  PSAY aMsg1[A]
					EndIf
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

						EndIf
						
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
					EndIf
					xPreco := 0.0
					xSaldo := 0.0
					//TESTE PARA O PLANEJAMENTO DE DO MPI
				Next
				If N==5 .or. N==3 .or. N==1
					li++
				EndIf
			Next
			
			@ li,000 PSAY Replicate("-", Limite)
			li++
			If li > 65
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			EndIf
		Else // Mv_Par15 == 2 - Resumo das necessidades NÂO
			For N:=1 to 6  // Nr. de Linhas
				xCol := 26
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
			//AQUI
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
					End
					Li += 1
				Next
			End
			
			@ LI,000 PSAY Replicate("-",Limite)
			Li += 1
			
			If Li > 58
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			EndIf
		End
	EndIf
	
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
	GRelEstSeg()
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

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cPath+"\"+cNome)
oExcelApp:SetVisible(.T.)

MsgBox("Foi gerado o Arquivo AtuEstSeg " + Dtoc(dDataBase), "Informacao", "INFO")
dbcloseArea("TRX")

Return
//
//
//
Static Function SalPed()

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
//
//
//
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
	If (StoD(THC->HC_DATA) >= SG1->G1_INI .and. StoD(THC->HC_DATA) <= SG1->G1_FIM)
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
//
//
//
Static Function GeraSolCompra(mesRef,xNecess,Prod,cItem)

_grupo:= subs(Posicione("SB1",1,xFilial("SB1")+Prod,"B1_GRUPO"),1,3)

IF _grupo == "MPI"
	nPos := aScan(ANUM ,{|X| X[2] == mesRef})
	IF nPos == 0
		_nextNum:=GetSX8Num("SC1") //Indice do ultimo registro
		ConfirmSX8()
		
		AADD(ANUM,{CMES[mesRef][1],mesRef,_nextNum,1})
		item:=1
	Else
		_nextNum := ANUM[nPos][3]
		item:=ANUM[nPos][4]
	END
	
	dDatPrf    := "01"+"/"+ALLTRIM(STRZERO(mesRef+3,2))+"/"+ALLTRIM(STR(YEAR(DDATABASE),4))
	dDatPrf    := CTOD(dDatPrf)
	dDatEms    := "01"+"/"+ALLTRIM(STRZERO(mesRef,2))+"/"+ALLTRIM(STR(YEAR(DDATABASE),4))
	dDatEms := Ctod(dDatEms)
	
	RecLock("SC1",.T.)
	SC1->C1_Filial  := xFilial("SC1")
	SC1->C1_NUM     := _nextNum
	SC1->C1_ITEM    := strzero(cItem,4)
	SC1->C1_PRODUTO := Prod
	SC1->C1_UM      := SUBS(AllTrim(Posicione("SB1",1,xFilial("SB1")+Prod,"B1_UM")),1,2)
	SC1->C1_QUANT   := xNecess
	SC1->C1_DATPRF  := dDatPrf
	SC1->C1_LOCAL   := SUBS(AllTrim(Posicione("SB1",1,xFilial("SB1")+Prod,"B1_LOCPAD")),1,2)
	SC1->C1_CONTA   := SUBS(AllTrim(Posicione("SB1",1,xFilial("SB1")+Prod,"B1_CONTA")),1,8)
	SC1->C1_CC      := SUBS(AllTrim(Posicione("SB1",1,xFilial("SB1")+Prod,"B1_CC")),1,3)
	SC1->C1_EMISSAO := dDatEms
	SC1->C1_DESCRI  := SUBS(AllTrim(Posicione("SB1",1,xFilial("SB1")+Prod,"B1_DESC_EN")),1,30)
	SC1->C1_SOLICIT := SUBSTR(CUSUARIO,7,15)
	SC1->C1_ORIGEM  := "MRP" + STRZERO(month(dDataBase),2)
	SC1->(MsUnlock())
ENDIF
Return
//
//
//
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
cQry += "SELECT AIA_XMODAL AS MODAL,AIA_DESCRI AS TABELA,AIA_CONDPG AS CONDICAO "
cQry +=    "FROM " + RetSQLName("AIB")+" AIB "
cQry += "INNER JOIN " + RetSQLName("AIA")+" AIA ON "
cQry += "AIA.D_E_L_E_T_='' "
cQry += "AND AIA.AIA_FILIAL=AIB.AIB_FILIAL "
cQry += "AND AIA_CODTAB=AIB.AIB_CODTAB "
cQry += "AND AIA.AIA_CODFOR=AIB.AIB_CODFOR "
cQry += "AND AIA.AIA_LOJFOR=AIB.AIB_LOJFOR "
cQry += "AND AIA_DATATE='' "
cQry += "WHERE AIB.D_E_L_E_T_='' "
cQry +=       "AND AIB_CODFOR='" + cForn +    "' "
cQry +=       "AND AIB_LOJFOR='" + cLojFor +  "' "
cQry +=       "AND AIB_CODPRO='" + cProduto + "' "

dbUseArea(.T., "TOPCONN", TcGenQry(,,cQry),"MODAL",.T.,.T.)

cModal    := Alltrim(MODAL->MODAL)
cTabela   := Alltrim(MODAL->TABELA)
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
//
//
//
Static Function RetCombo(cCampo, cChave)
Local aSx3Box := RetSx3Box( Posicione("SX3", 2, cCampo, "X3CBox()" ),,, 1 )
Return AllTrim( aSx3Box[aScan( aSx3Box, { |aBox| aBox[2] = cChave } )][3])
//
//
//
Static Function IncluiPedido(aPedido)

Local nX, aLinha
Local nSaveSX8 := GetSx8Len()
Local cNumPed  := GetSXENum("SC7", "C7_NUM")
Local cItem    := StrZero(0,TamSX3("C7_ITEM")[1])
Local aCabec   := {}
Local aItens   := {}
Local cError   := ""

ConOut("Número do pedido: " + cNumPed)

SA2->(dbSetOrder(1))
SA2->(dbSeek(xFilial("SA2") + aPedido[2] + aPedido[3]) )

aCabec := { { "C7_NUM",     cNumPed         },;
            { "C7_EMISSAO", dDataBase       },;
            { "C7_FORNECE", aPedido[2]      },;
            { "C7_LOJA",    aPedido[3]      },;
            { "C7_COND",    aPedido[4]      },;
            { "C7_CONTATO", SA2->A2_CONTATO },;
            { "C7_FILENT",  cFilAnt         } }

For nX:=1 To Len(aPedido[5])
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(XFILIAL("SB1")+aPedido[5][nX,1]))
	
	aLinha := {}
	
	cItem := Soma1(cItem)
	
	aAdd( aLinha, { "C7_ITEM",    cItem,       NIL} )
	aAdd( aLinha, { "C7_PRODUTO", SB1->B1_COD, NIL} )
	aAdd( aLinha, { "C7_UM",      SB1->B1_UM,  NIL} )
	
	If !Empty(SB1->B1_SEGUM)
		aAdd( aLinha, { "C7_SEGUM"  , SB1->B1_SEGUM, NIL} )
		aAdd( aLinha, { "C7_QTSEGUM", ConvUM(SB1->B1_COD,aPedido[5][nX,2],0,2), NIL} )
	EndIf
	
	aAdd( aLinha, { "C7_QUANT",   aPedido[5][nX,2], NIL} )
	aAdd( aLinha, { "C7_PRECO",   aPedido[5][nX,3], NIL} )
	aAdd( aLinha, { "C7_TOTAL",   aPedido[5][nX,2] * aPedido[5][nX,3], NIL} )
	aAdd( aLinha, { "C7_OBS",     aPedido[5][nX,4], NIL} )
	aAdd( aLinha, { "C7_DATPRF",  dDataBase,        NIL} )
	aAdd( aLinha, { "C7_LOCAL",   SB1->B1_LOCPAD,   NIL} )
	aAdd( aLinha, { "C7_XCC",     aPedido[5][nX,5], NIL} )
	aAdd( aLinha, { "C7_XCONTRA", aPedido[1],       NIL} )
	aAdd( aItens, aClone(aLinha) )
Next

lMsErroAuto := .F.
MSExecAuto({|x,y,Z| MATA120(1,x,y,Z)}, aCabec, aItens, 3) // Inclui o pedido de compra

If lMsErroAuto
	cError := u_MDResumeErro(MostraErro("\","Error.log"))
	While ( GetSx8Len() > nSaveSX8 )
		RollBackSx8()
	Enddo
	DisarmTransaction()
Else
	While ( GetSx8Len() > nSaveSX8 )
		ConfirmSX8()
	End
Endif

Return cError
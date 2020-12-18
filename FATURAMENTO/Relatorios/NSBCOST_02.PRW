#include "rwmake.ch"

User Function COST_02()
Local _cArea:=GetArea()

Private oDlg5 := Nil

Pergunte("GGF003",.F.)

@ 96,42 TO 323,505 DIALOG oDlg5 TITLE "Rateio GGF Por Produto"
@ 8,10 TO 84,222
@ 91,139 BMPBUTTON TYPE 5 ACTION Pergunte("GGF003")
@ 91,168 BMPBUTTON TYPE 1 ACTION Exec_Rat()
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
@ 23,14 SAY "Este programa tem como objetivo, Fazer o rateio dos custos de fabricaçao"
@ 33,14 SAY "Por produto, dentro do periodo especificado em Paramentro."
@ 43,14 SAY ""
@ 53,14 SAY ""
ACTIVATE DIALOG oDlg5
RestArea(_cArea)
Return nil

Static Function Exec_Rat()

Processa({|| RptDetail()})
Close(oDlg5)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funçao    ³ RptDetail ³ Autor ³ Marcelo Iannuzzi     ³Inicio ³ 04.03.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Custo dos produtos industrializados...   ³Termino³ 24.03.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ rdmake GGF000 -X                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ mv_par01 e 02 Produto                                       ³±±
±±³Parametros³ mv_par03 e 04 Data                                          ³±±
±±³Parametros³ mv_par06 Grava a movimentaçao do custo no SD3               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ALTERAD0 ³ 29/04/2006 - POR: JORGE SILVEIRA                            ³±±
±±³          ³ ALTERACAO NA FORMA DE CALCULO DO RATEIO DAS DESPESAS DE GGF ³±±
±±³          ³ MOD, MOI E MAT. IMPRODUTIVOS, P/ QUE O RATEIO SEJA REALIZA- ³±±
±±³          ³ DO POR DOCUMENTO (APONTAMENTO DE PRODUCAO), E NAO MAIS PELA ³±±
±±³          ³ ORDEM DE PRODUCAO.                                          ³±±
±±³          ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ 01/09/2007 - POR: JORGE SILVEIRA                            ³±±
±±³          ³ INCLUSAO DO SETOR DE INSERCAO AUTOMATICA.                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RptDetail()

SetPrvt("nSns_MPN,nSns_MPI,nSns_TMP,nSns_PER,nSns_MIN,nSns_MII")
SetPrvt("nSns_Sal,nSns_Enc,nSns_Ben,nSns_GGF,nSns_MIS,nSns_MIE")
SetPrvt("nSns_MIO,nSns_GGi,nSns_TOT,a_gSns")
SetPrvt("nInj_MPN,nInj_MPI,nInj_TMP,nInj_PER,nInj_MIN,nInj_MII")
SetPrvt("nInj_Sal,nInj_Enc,nInj_Ben,nInj_GGF,nInj_MIS,nInj_MIE")
SetPrvt("nInj_MIO,nInj_GGi,nInj_TOT,nMon_MPN,nMon_MPI,nMon_TMP")
SetPrvt("nIns_MPN,nIns_MPI,nIns_TMP,nIns_PER,nIns_MIN,nIns_MII")
SetPrvt("nIns_Sal,nIns_Enc,nIns_Ben,nIns_GGF,nIns_MIS,nIns_MIE")
SetPrvt("nIns_MIO,nIns_GGi,nIns_TOT,a_gIns")
SetPrvt("nMon_PER,nMon_MIN,nMon_MII,nMon_Sal,nMon_Enc,nMon_GGF")
SetPrvt("nMon_Ben,nMon_MIS,nMon_MIE,nMon_MIO,nMon_GGi,nMon_TOT")
SetPrvt("nImp_MPN,nImp_MPI,nImp_TMP,nImp_PER,nImp_MIN,nImp_MII")
SetPrvt("nImp_Sal,nImp_Enc,nImp_Ben,nImp_GGF,nImp_MIS,nImp_MIE")
SetPrvt("nImp_MIO,nImp_GGi,nImp_TOT,XQUANT,XOP,a_gImp,c_CC,cMsg")
SetPrvt("a_Grv08,a_Grv09,a_Grv10,a_Grv11,a_Grv12,a_Grv21,a_Grv01")
SetPrvt("a_Grv13,a_Grv14,a_Grv15,a_Grv16,a_Grv17,a_Grv18,a_Grv19,a_Grv20")
SetPrvt("a_Grv02,a_Grv03,a_Grv04,a_Grv05,a_Grv06,a_Grv18,a_Grv07")
SetPrvt("a_gSns,a_gInj,a_gInc,NIMP_PI,NINJ_PI,NMON_PI,NSNS_PI,aTotal,mSequencia")
//      01          02	        03          04          05          06          07          08          09          10          11          12
aTotal := {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}}
aQtdTt := {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}}

dbSelectArea("SZ3")
dbSetOrder(1)
dbSeek(xFilial("SZ3")+dtos(mv_par04))

If Eof()
	MsgStop("Valores de RATEIO inexistentes para periodo informado."+;
	"É necessario executar a rotina de rateio dos Gastos de Fabricação, ou verifique os parâmetros.")
	Return
EndIF

// MONTAGEM FINAL
a_gMon  := {{"NMON_MPI","MPI211"},; // 01 MPI
{"NMON_MPN","MPN211"},; // 02 MPN
{"NMON_PI" ,"_PI211"},; // 03 PI
{"NMON_MII","MII211"},; // 04 MAT.IMPR.IMP.
{"NMON_MIN","MIN211"},; // 05 MAT.IMPR.NAC.
{"NMON_SAL","SAL211"},; // 06 MOD REMUNERACAO
{"NMON_ENC","ENC211"},; // 07 MOD ENC.SOCIAL
{"NMON_BEN","BEN211"},; // 08 MOD BEN.SOCIAL
{"NMON_GGF","GGF211"},; // 09 MOD GGF
{"NMON_MIS","MIS211"},; // 10 MOI REMUNERACAO
{"NMON_MIE","MIE211"},; // 11 MOI ENC.SOCIAL
{"NMON_MIO","MIO211"},; // 12 MOI BEN.SOCIAL
{"NMON_GGI","GGI211"},; // 13 MOI GGF
"Z3_MPMON" ,;          // 14 TOTAL DE INSUMOS
"Z3_MSIMON",;          // 15 MAT.Impr.Imp
"Z3_MSNMON",;          // 16 MAT.Impr.Nac
"Z3_MONSal",;          // 17 MOD REMUNERACAO
"Z3_MONEnc",;          // 18 MOD ENC.SOCIAL
"Z3_MONBen",;          // 19 MOD BEN.SOCIAL
"Z3_MONGGF"}           // 20 MOD GGF
//             "Z3_PIMON" }           // 21 PI

// IMPRESSAO
a_gImp  := {{"NIMP_MPI","MPI221"},;  // 01 MPI
{"NIMP_MPN","MPN221"},;  // 02 MPN
{"NIMP_PI" ,"_PI221"},;  // 03 PI
{"NIMP_MII","MII221"},;  // 04 M.IMPR. IMP.
{"NIMP_MIN","MIN221"},;  // 05 M.IMPR. NAC.
{"NIMP_SAL","SAL221"},;  // 06 MOD REMUNERACAO
{"NIMP_ENC","ENC221"},;  // 07 MOD ENC. SOCIAL
{"NIMP_BEN","BEN221"},;  // 08 MOD BEN. SOCIAL
{"NIMP_GGF","GGF221"},;  // 09 MOD GGF
{"NIMP_MIS","MIS221"},;  // 10 MOI REMUNERACAO
{"NIMP_MIE","MIE221"},;  // 11 MOI ENC. SOCIAL
{"NIMP_MIO","MIO221"},;  // 12 MOI BEN. SOCIAL
{"NIMP_GGI","GGI221"},;  // 13 MOI GGF
"Z3_MPImp" ,;
"Z3_MSIImp",;           // 15 MAT. Improdutivo
"Z3_MSNImp",;
"Z3_ImpSal",;           // 17 Mão-De-Obra Direta
"Z3_ImpEnc",;
"Z3_ImpBen",;
"Z3_ImpGGF"}
//  "Z3_PIIMP" }

// INJ. PLASTICA
a_gInj  := {{"NINJ_MPI","MPI231"},;
{"NINJ_MPN","MPN231"},;
{"NINJ_PI" ,"_PI231"},; // 03 PI
{"NINJ_MII","MII231"},;
{"NINJ_MIN","MIN231"},;
{"NINJ_SAL","SAL231"},;
{"NINJ_ENC","ENC231"},;
{"NINJ_BEN","BEN231"},;
{"NINJ_GGF","GGF231"},;
{"NINJ_MIS","MIS231"},;
{"NINJ_MIE","MIE231"},;
{"NINJ_MIO","MIO231"},;
{"NINJ_GGI","GGI231"},;
"Z3_MPINJ" ,;
"Z3_MSIINJ",; // MAT. Improdutivo
"Z3_MSNINJ",;
"Z3_INJSal",; // Mão-De-Obra Direta
"Z3_INJEnc",;
"Z3_INJBen",;
"Z3_INJGGF"}

//  "Z3_PIINJ" }

// INS. AUTOMATICA
a_gIns  := {{"NINS_MPI","MPI241"},;   // 01
{"NINS_MPN","MPN241"},;   // 02
{"NINS_PI" ,"_PI241"},;   // 03 PI
{"NINS_MII","MII241"},;   // 04
{"NINS_MIN","MIN241"},;   // 05
{"NINS_SAL","SAL241"},;   // 06
{"NINS_ENC","ENC241"},;   // 07
{"NINS_BEN","BEN241"},;   // 08
{"NINS_GGF","GGF241"},;   // 09
{"NINS_MIS","MIS241"},;   // 10
{"NINS_MIE","MIE241"},;   // 11
{"NINS_MIO","MIO241"},;   // 12
{"NINS_GGI","GGI241"},;   // 13
"Z3_MPINS" ,;            // 14
"Z3_MSIINS",;            // 15 MAT. Improdutivo
"Z3_MSNINS",;            // 16
"Z3_INSSAL",;            // 17 Mão-De-Obra Direta
"Z3_INSENC",;            // 18
"Z3_INSBEN",;            // 19
"Z3_INSGGF"}             // 20
//  "Z3_PIINS"  }            // 21

// SENSOR DO COMBUSTIVEL
a_gSns  := {{"NSNS_MPI","MPI251"},;   // 01
{"NSNS_MPN","MPN251"},;   // 02
{"NSNS_PI" ,"_PI251"},;   // 03 PI
{"NSNS_MII","MII251"},;   // 04
{"NSNS_MIN","MIN251"},;   // 05
{"NSNS_SAL","SAL251"},;   // 06
{"NSNS_ENC","ENC251"},;   // 07
{"NSNS_BEN","BEN251"},;   // 08
{"NSNS_GGF","GGF251"},;   // 09
{"NSNS_MIS","MIS251"},;   // 10
{"NSNS_MIE","MIE251"},;   // 11
{"NSNS_MIO","MIO251"},;   // 12
{"NSNS_GGI","GGI251"},;   // 13
"Z3_MPSNS" ,;            // 14
"Z3_MSISNS",;            // 15 MAT. Improdutivo
"Z3_MSNSNS",;            // 16
"Z3_SNSSAL",;            // 17 Mão-De-Obra Direta
"Z3_SNSENC",;            // 18
"Z3_SNSBEN",;            // 19
"Z3_SNSGGF"}             // 20
//  "Z3_PIINS"  }            // 21

dbSelectArea("SD3")  // Jorge Em: 08/06/2006
cArqSD3 := CriaTrab(NIL,.F. )
cKeySD3 := "D3_FILIAL + D3_OP + D3_DOC"
cFiltro := "D3_FILIAL=='"+xFilial("SD3")+"' .And. DTOS(D3_EMISSAO) >= '"+DTOS(mv_par03)
cFiltro += "' .And. DTOS(D3_EMISSAO) <= '"+DTOS(mv_par04)+"' .and. D3_ESTORNO <>'S'"
IndRegua("SD3",cArqSD3,cKeySD3,,cFiltro,"Selecionando Registros...")
dbGotop()

dbSelectArea("SC2")
dbSetOrder(2)

ProcRegua(RecCount())

dbSeek(xFilial("SC2")+MV_PAR01,.T.)
While !Eof() .And. C2_PRODUTO <= MV_PAR02
	
	If DTOS(C2_DATPRI) < DTOS(MV_PAR03) .Or. DTOS(C2_DATPRI) > DTOS(MV_PAR04)
		dbSkip()
		Loop
	EndIF
	
	nIns_MPN := nInj_MPN := nMon_MPN := nImp_MPN := nSns_MPN := 0  // Mat. Prima Nac.
	nIns_MPI := nInj_MPI := nMon_MPI := nImp_MPI := nSns_MPI := 0  // Mat. Prima Imp.
	nIns_PI  := nInj_PI  := nMon_PI  := nImp_PI  := nSns_PI  := 0  // Produto Intermediario
	nIns_TMP := nInj_TMP := nMon_TMP := nImp_TMP := nSns_TMP := 0  // Total de Mat.Prima
	nIns_MIN := nInj_MIN := nMon_MIN := nImp_MIN := nSns_MIN := 0  // Mat.Improd.Nac.
	nIns_MII := nInj_MII := nMon_MII := nImp_MII := nSns_MII := 0  // Mat.Improd.Imp.
	nIns_Sal := nInj_Sal := nMon_Sal := nImp_Sal := nSns_Sal := 0  // MOD Salario
	nIns_Enc := nInj_Enc := nMon_Enc := nImp_Enc := nSns_Enc := 0  // MOD Enc.Sociais
	nIns_Ben := nInj_Ben := nMon_Ben := nImp_Ben := nSns_Ben := 0  // MOD Outros
	nIns_GGF := nInj_GGF := nMon_GGF := nImp_GGF := nSns_GGF := 0  // GGF
	nIns_MIS := nInj_MIS := nMon_MIS := nImp_MIS := nSns_MIS := 0  // MOI Salario
	nIns_MIE := nInj_MIE := nMon_MIE := nImp_MIE := nSns_MIE := 0  // MOI Enc.Sociais
	nIns_MIO := nInj_MIO := nMon_MIO := nImp_MIO := nSns_MIO := 0  // MOI Outros
	nIns_GGi := nInj_GGi := nMon_GGi := nImp_GGi := nSns_GGi := 0  // GGF Indireto
	
	xProduto := C2_PRODUTO
	xQuant   := 0
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+xProduto)
	xTipo    := B1_Tipo
	//
	dbSelectArea("SC2")
	While !Eof() .And. C2_PRODUTO == xProduto
		
		IncProc("Ordem de Produção: "+C2_NUM+"  De: "+DTOC(C2_Emissao) )
		
		If DTOS(C2_DATPRI) < DTOS(MV_PAR03) .or. DTOS(C2_DATPRI) > DTOS(MV_PAR04)
			dbSkip()
			Loop
		EndIF
		
		If SC2->C2_QUJE == 0
			dbSkip()
			Loop
		EndIF
		
		xOP    := AllTrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
		c_CC   := SC2->C2_CC
		xQuant += SC2->C2_Quje
		
		ImpEstr()
		
		dbSelectArea("SC2")
		dbSkip()
	EndDo
	
	GravaZ4("251")
	GravaZ4("241")
	GravaZ4("231")
	GravaZ4("221")
	GravaZ4("211")
	
	dbSelectArea("SC2")
	
Enddo

If mv_par06 == 1
	GrvTot()
EndIf

dbSelectArea("SD3")
RetIndex("SD3")
Set Filter To
dbSelectArea("SC2")
dbSetOrder(1)

Return

/*
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funçao    ³ ImpEstr  ³ Autor ³ Marcelo Iannuzzi      ³Inicio³ 24.03.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±*/

Static Function ImpEstr()

dbSelectArea("SD3")
dbSeek(xFilial("SD3")+Alltrim(xOP))

xEmissao := D3_EMISSAO
While !Eof() .and. xOP == AllTrim(D3_OP)
	
	n_xMPI := 0  // 01 MPI
	n_xMPN := 0  // 02 MPN
	n_xPI  := 0  // 03 PI
	n_TMP  := 0  //  TOTAL DE INSUMOS
	n_MII  := 0  // 04 MAT.IMPR.IMP.
	n_MIN  := 0  // 05 MAT.IMPR.NAC
	n_Sal  := 0  // 06 MOD REMUNERACAO
	n_Enc  := 0  // 07 MOD ENC.SOCIAL
	n_Ben  := 0  // 08 MOD BEN.SOCIAL
	n_GGF  := 0  // 09 MOD GGF
	n_MIS  := 0  // 10 MOI REMUNERACAO
	n_MIE  := 0  // 11 MOI ENC.SOCIAL
	n_MIO  := 0  // 12 MOI BEN.SOCIAL
	n_GGi  := 0  // 13 MOI GGF
	n_Tot  := 0  //    TOTAL GERAL
	mDoc   := D3_Doc   // Jorge Em: 08/06/2006
	
	While !Eof() .And. xOP == AllTrim(D3_OP) .And. mDoc == D3_Doc   // Jorge Em: 08/06/2006
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SD3->D3_COD)
		
		dbSelectArea("SD3")
		
		/*
		If D3_TM == "400"
		mqProd := D3_Quant
		ElseIf Alltrim(D3_GRUPO) == "MPN"
		n_xMPN += D3_CUSTO1
		ElseIf Alltrim(D3_GRUPO) == "MPI"
		n_xMPI += D3_CUSTO1
		ElseIf D3_Tipo == "PI"
		n_xPI += D3_CUSTO1
		End
		*/
		
		If D3_TM == "400"
			mqProd := D3_Quant
			dbSkip()
			Loop
		EndIf
		
		If     Alltrim(D3_GRUPO) == "MPN"
			n_xMPN += D3_CUSTO1
		ElseIf Alltrim(D3_GRUPO) == "MPI"
			n_xMPI += D3_CUSTO1
		ElseIf D3_Tipo == "PI"
			n_xPI += D3_CUSTO1
		EndIF
		
		mSequencia := D3_NUMSEQ
		
		dbSkip()
	EndDo
	
	GetVar(c_CC) // alimenta as variaveis a_Grv00 com os nomes das variaveis de custo de acordo com o centro de custo em parametro
	
	n_TMP := (n_xMPN + n_xMPI + n_xPI)
	n_MII := ((n_TMP /  SZ3->&a_Grv14) * SZ3->&a_Grv15) // Z3_MSIInj) // MAT. IMPRODUTIVO IMPORTADO
	n_MIN := ((n_TMP /  SZ3->&a_Grv14) * SZ3->&a_Grv16) // Z3_MSNInj) // MAT. IMPRODUTIVO NACIONAL
	n_Sal := ((n_TMP /  SZ3->&a_Grv14) * SZ3->&a_Grv17) // Z3_InjSal) // Mão-De-Obra Direta SALARIO
	n_Enc := ((n_TMP /  SZ3->&a_Grv14) * SZ3->&a_Grv18) // Z3_InjEnc) // Mão-De-Obra Direta BENEFICIO
	n_Ben := ((n_TMP /  SZ3->&a_Grv14) * SZ3->&a_Grv19) // Z3_InjBen) // Mão-De-Obra Direta ENCARGOS
	n_GGF := ((n_TMP /  SZ3->&a_Grv14) * SZ3->&a_Grv20) // Z3_InjGGF) // Mão-De-Obra Direta GGF
	
	n_MIS := ((n_TMP / (SZ3->Z3_MPSns + SZ3->Z3_MPIns + SZ3->Z3_MPInj + SZ3->Z3_MPImp + SZ3->Z3_MPMon)) * SZ3->Z3_MOISal) // Mão-De-Obra Indireta
	n_MIE := ((n_TMP / (SZ3->Z3_MPSns + SZ3->Z3_MPIns + SZ3->Z3_MPInj + SZ3->Z3_MPImp + SZ3->Z3_MPMon)) * SZ3->Z3_MOIEnc)
	n_MIO := ((n_TMP / (SZ3->Z3_MPSns + SZ3->Z3_MPIns + SZ3->Z3_MPInj + SZ3->Z3_MPImp + SZ3->Z3_MPMon)) * SZ3->Z3_MOIBen)
	n_GGi := ((n_TMP / (SZ3->Z3_MPSns + SZ3->Z3_MPIns + SZ3->Z3_MPInj + SZ3->Z3_MPImp + SZ3->Z3_MPMon)) * SZ3->Z3_MOIGGF)
	
	&a_Grv01 +=  n_xMPI
	&a_Grv02 +=  n_xMPN
	&a_Grv03 +=  n_xPI
	&a_Grv04 +=  n_MII
	&a_Grv05 +=  n_MIN
	&a_Grv06 +=  n_Sal
	&a_Grv07 +=  n_Enc
	&a_Grv08 +=  n_Ben
	&a_Grv09 +=  n_GGF
	&a_Grv10 +=  n_MIS
	&a_Grv11 +=  n_MIE
	&a_Grv12 +=  n_MIO
	&a_Grv13 +=  n_GGi
	
	n_Tot := (n_TMP + n_MII + n_MIN + n_Sal + n_Enc + n_Ben + n_GGF + n_MIS + n_MIE + n_MIO + n_GGi )
	
	a_Tot := {0     , 0     , 0     , n_MII , n_MIN , n_Sal , n_Enc , n_Ben , n_GGF , n_MIS , n_MIE , n_MIO , n_GGi} //NÃO ALTERAR ORDEM
	//     0       1       2       3       4       5       6       7       8       9       10      11      12
	
	aCmTot(c_CC,a_Tot,xQuant)
	
	If mv_par06 == 1
		GrvSD3(c_CC,a_Tot)
	EndIf
	
EndDo	  // Jorge Em: 08/06/2006

Return

/*
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funçao    ³  GrvSD3  ³ Autor ³ Marcelo Iannuzzi      ³Inicio³ 24.03.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±*/

Static Function GrvSD3(_cCusto,a_nVal)

Local mOp        := xOP
Local mEmissao   := xEmissao
Local mCC        := _cCusto
//Local mSequencia := ""
Local mCustog    := 0
Local mProduto   := ""
Local aGrvSD3    := GetArray(_cCusto)

For i:=4 to 13
	
	mProduto   := aGrvSD3[i][2]
	mCustog    := a_nVal[i]
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+mProduto)
	
	If mCustog = 0.00000000
		Loop
	EndIf
	
	RecLock("SD3",.T.)
	SD3->D3_FILIAL  := xFilial("SD3")
	SD3->D3_ORIGEM  := "GGF003"
	SD3->D3_TM      := "999"
	SD3->D3_CF      := "RE5"
	SD3->D3_COD     := SB1->B1_COD
	SD3->D3_UM      := SB1->B1_UM
	SD3->D3_QUANT   := SC2->C2_QUJE // mqProd // SC2->C2_QUJE      // Jorge Em: 13/02/2008
	SD3->D3_OP      := mOp
	SD3->D3_DOC     := mDoc   // SubStr(mOp,1,6)   // Jorge Em: 08/06/2006
	SD3->D3_LOCAL   := SB1->B1_LOCPAD
	SD3->D3_EMISSAO := mEmissao
	SD3->D3_GRUPO   := SB1->B1_GRUPO
	SD3->D3_TIPO    := SB1->B1_TIPO
	SD3->D3_CUSTO1  := mCustog
	SD3->D3_CC      := SB1->B1_CC
	//	D3->D3_LOCALIZ := "GGF000"
	//	mSequencia := ProxNum()
	SD3->D3_NUMSEQ  := mSequencia
	SD3->D3_IDENT   := StrZero(Val(mSequencia)+1,6)
	SD3->D3_CHAVE   := 'E0'
	MsUnlock()
Next

Return
/*
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funçao    ³ GravaZ4  ³ Autor ³ Marcelo Iannuzzi      ³Inicio³ 24.03.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±*/
Static Function GravaZ4(c_Cust)

Local a_GrvVal := {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
Local n_GrvVal := 0
Local c_GrvVal := ""
Local a_Grv    := GetArray(c_Cust)

dbSelectArea("SZ4")
dbSetOrder(1)

For _i:=1 to 13
	c_GrvVal     := a_Grv[_i][1]
	a_GrvVal[_i] := &c_GrvVal
	n_GrvVal     += a_GrvVal[_i]
Next
//c_GrvVal     := a_Grv[21]
a_GrvVal[14] := &c_GrvVal
//n_GrvVal     += a_`GrvVal[13]

If n_GrvVal == 0
	Return
EndIf

If dbSeek(xFilial("SZ4")+dtos(mv_par04)+xProduto+c_Cust)
	RecLock("SZ4",.F.)
Else
	RecLock("SZ4",.T.)
EndIf

SZ4->Z4_FILIAL  := xFilial("SZ4")
SZ4->Z4_CC      := c_Cust
SZ4->Z4_PRODUTO := xProduto
SZ4->Z4_DATA    := mv_par04
SZ4->Z4_QUANT   := xQuant
SZ4->Z4_MPI     := Round(a_grvVal[01],2)    //{{"NINJ_MPI","MPN231"},;
SZ4->Z4_MPN     := Round(a_grvVal[02],2)    // {"NINJ_MPN","MPI231"},;
SZ4->Z4_PI      := Round(a_grvVal[03],2)    // {"NINJ_PI" ,"_PI231"},; // 03 PI
SZ4->Z4_MSI     := Round(a_grvVal[04],2)    // {"NINJ_MII","MII231"},;
SZ4->Z4_MSN     := Round(a_grvVal[05],2)    // {"NINJ_MIN","MIN231"},;
SZ4->Z4_MODSAL  := Round(a_grvVal[06],2)    // {"NINJ_SAL","SAL231"},;
SZ4->Z4_MODENC  := Round(a_grvVal[07],2)    // {"NINJ_ENC","ENC231"},;
SZ4->Z4_MODBEN  := Round(a_grvVal[08],2)    // {"NINJ_BEN","BEN231"},;
SZ4->Z4_MODGGF  := Round(a_grvVal[09],2)    // {"NINJ_GGF","GGF231"},;
SZ4->Z4_MOISAL  := Round(a_grvVal[10],2)    // {"NINJ_MIS","MIS231"},;
SZ4->Z4_MOIENC  := Round(a_grvVal[11],2)    // {"NINJ_MIE","MIE231"},;
SZ4->Z4_MOIBEN  := Round(a_grvVal[12],2)    // {"NINJ_MIO","MIO231"},;
SZ4->Z4_MOIGGF  := Round(a_grvVal[13],2)    // {"NINJ_GGI","GGI231"},;
MsUnLock()

Return

/*
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funçao    ³ GetArray ³ Autor ³ Marcelo Iannuzzi      ³Inicio³ 24.03.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±*/

Static Function GetArray(c_CC)

Local a_Var:={}


If     Alltrim(c_CC)=="251"     // SENSOR COMBUSTIVEL
	a_Var := a_gSns
ElseIf Alltrim(c_CC)=="241"     // INSERCAO AUTOMATICA
	a_Var := a_gIns
ElseIf Alltrim(c_CC)=="231"     // INJECAO PLASTICA
	a_Var := a_gInj
ElseIf Alltrim(c_CC)=="221"     // IMPRESSAO
	a_Var := a_gImp
Else                            // MONTAGEM
	a_Var := a_gMon
EndIf

Return(a_Var)

/*
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funçao    ³  GetVar  ³ Autor ³ Marcelo Iannuzzi      ³Inicio³ 24.03.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±*/

Static Function GetVar(_CCusto)

Local c_GrvVal := ""
Local a_GrvVal := GetArray(_CCusto)

For _i := 1 to 20
	c_GrvVal  := "a_Grv" + StrZero(_i,2)
	If _i >= 14
		&c_GrvVal := a_GrvVal[_i]
	Else
		&c_GrvVal := a_GrvVal[_i][1]
	Endif
Next

//a_Grv21 := a_GrvVal[21]

Return

/*
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funçao    ³  aCmTot  ³ Autor ³ Marcelo Iannuzzi      ³Inicio³ 24.03.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±*/

Static Function aCmTot(c_CC,a_Tot,nQtd)

If  Alltrim(c_CC)=="251"     // SENSOR COMBUSTIVEL
	n_Var := 5
ElseIf Alltrim(c_CC)=="241"     // INSERCAO AUTOMATICA
	n_Var := 1
ElseIf Alltrim(c_CC)=="231"     // INJECAO PLASTICA
	n_Var := 2
ElseIf Alltrim(c_CC)=="221"     // IMPRESSAO
	n_Var := 3
Else                            // MONTAGEM
	n_Var := 4
EndIf

For i:=4 to 13 // ? a verificar
	aTotal[i-3][n_Var] += Round(a_Tot[i],2)
	If a_Tot[i] <> 0.00000000
		aQtdTt[i-3][n_Var] += SC2->C2_QUJE
	EndIf
Next

Return

******************************************************************
Static Function GrvTot()
******************************************************************

Local mEmissao   := mv_par04
Local mCC        := ""
Local mSequencia := ""
Local mCustog    := 0
Local mProduto   := ""
Local aGrvSD3    := Nil

For j:=1 to 5
	
	If j==1
		aGrvSD3 := a_gIns
		mCC     := "241"
	ElseIf j==2
		aGrvSD3 := a_gInj
		mCC     := "231"
	ElseIf j==3
		aGrvSD3 := a_gImp
		mCC     := "221"
	ElseIf j==4
		aGrvSD3 := a_gMon
		mCC     := "211"
	ElseIf j== 5
		aGrvSD3 := a_gSns
		mCC     := "251"
		
	EndIf
	
	For i := 4 to 13 // ? a verificar
		mProduto   := aGrvSD3[i][2]     // MII
		mCustog    := aTotal[i-3][j]    // MPI
		mQuant     := aQtdTt[i-3][j]    // MPI
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+mProduto)
		If NoRound(mCustog) == 0
			Loop
		EndIf
		RecLock("SD3",.T.)
		SD3->D3_FILIAL  := xFilial("SD3")
		SD3->D3_ORIGEM  := "COST02"
		SD3->D3_TM      := "499"
		SD3->D3_CF      := "DE5"
		SD3->D3_COD     := SB1->B1_COD
		SD3->D3_UM      := SB1->B1_UM
		SD3->D3_QUANT   := mQuant
		SD3->D3_DOC     := "GG"+SubStr(dtos(mv_par04),3,6)
		SD3->D3_LOCAL   := SB1->B1_LOCPAD
		SD3->D3_EMISSAO := mEmissao
		SD3->D3_GRUPO   := SB1->B1_GRUPO
		SD3->D3_TIPO    := SB1->B1_TIPO
		SD3->D3_CUSTO1  := mCustog
		SD3->D3_CC      := SB1->B1_CC
		//	D3->D3_LOCALIZ := "GGF000"
		mSequencia := ProxNum()
		SD3->D3_NUMSEQ  := mSequencia
		SD3->D3_CHAVE   := 'E0'
		MsUnlock()
	Next

Next

Return

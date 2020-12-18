#include "rwmake.ch"

User Function COST_03()

Private oDlg5 := Nil

Pergunte("GGF003",.F.)

@ 96,42 TO 323,505 DIALOG oDlg5 TITLE "Rateio GGF Por Produto - SD3"
@ 8,10 TO 84,222
@ 91,139 BMPBUTTON TYPE 5 ACTION Pergunte("GGF003")
@ 91,168 BMPBUTTON TYPE 1 ACTION Exec_Rat()
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
@ 23,14 SAY "Este programa tem como objetivo, Gravar os custos de fabricaçao"
@ 33,14 SAY "Por produto, dentro do periodo especificado em Paramentro, pela"
@ 43,14 SAY "Movimentacao."
@ 53,14 SAY ""
ACTIVATE DIALOG oDlg5

Return nil

Static Function Exec_Rat()

Processa({|| RptDetail()})
Close(oDlg5)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funçao    ³ RptDetail³ Autor ³ Marcelo Iannuzzi      ³Inicio³ 04.03.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Custo dos produtos industrializados...   ³Termino³24.03.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ rdmake GGF000 -X                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function RptDetail()

SetPrvt("nSns_MPN,nSns_MPI,nSns_TMP,nSns_PER,nSns_MIN,nSns_MII")
SetPrvt("nSns_Sal,nSns_Enc,nSns_Ben,nSns_GGF,nSns_MIS,nSns_MIE")
SetPrvt("nSns_MIO,nSns_GGi,nSns_TOT")
SetPrvt("nInj_MPN,nInj_MPI,nInj_TMP,nInj_PER,nInj_MIN,nInj_MII")
SetPrvt("nInj_Sal,nInj_Enc,nInj_Ben,nInj_GGF,nInj_MIS,nInj_MIE")
SetPrvt("nInj_MIO,nInj_GGi,nInj_TOT,nMon_MPN,nMon_MPI,nMon_TMP")
SetPrvt("nMon_PER,nMon_MIN,nMon_MII,nMon_Sal,nMon_Enc,nMon_GGF")
SetPrvt("nMon_Ben,nMon_MIS,nMon_MIE,nMon_MIO,nMon_GGi,nMon_TOT")
SetPrvt("nImp_MPN,nImp_MPI,nImp_TMP,nImp_PER,nImp_MIN,nImp_MII")
SetPrvt("nImp_Sal,nImp_Enc,nImp_Ben,nImp_GGF,nImp_MIS,nImp_MIE")
SetPrvt("nImp_MIO,nImp_GGi,nImp_TOT,XQUANT,XOP,a_gImp,c_CC,cMsg")  
SetPrvt("a_Grv08,a_Grv09,a_Grv10,a_Grv11,a_Grv12,a_Grv20,a_Grv01") 
SetPrvt("a_Grv13,a_Grv14,a_Grv15,a_Grv16,a_Grv17,a_Grv18,a_Grv19")
SetPrvt("a_Grv02,a_Grv03,a_Grv04,a_Grv05,a_Grv06,a_Grv18,a_Grv07")
SetPrvt("a_gInj,NIMP_PI,NINJ_PI,NMON_PI,NINS_PI,NSNS_PI") 
SetPrvt("a_gSns")

Private n_xMPN := 0
Private n_xMPI := 0
Private n_xPI  := 0
Private n_TMP  := 0
Private n_MII  := 0
Private n_MIN  := 0
Private n_SAL  := 0
Private n_ENC  := 0
Private n_BEN  := 0
Private n_GGF  := 0
Private n_MIS  := 0
Private n_MIE  := 0
Private n_MIO  := 0
Private n_GGI  := 0
Private n_TOT  := 0

a_gImp  := {{"NIMP_MPI","MPN221"},; // 01
            {"NIMP_MPN","MPI221"},; // 02
            {"NIMP_PI" ,"_PI221"},; // 03 PI
            {"NIMP_MII","MII221"},; // 04
            {"NIMP_MIN","MIN221"},; // 05
            {"NIMP_SAL","SAL221"},; // 06
            {"NIMP_ENC","ENC221"},; // 07
            {"NIMP_BEN","BEN221"},; // 08
            {"NIMP_GGF","GGF221"},; // 09
            {"NIMP_MIS","MIS221"},; // 10
            {"NIMP_MIE","MIE221"},; // 11
            {"NIMP_MIO","MIO221"},; // 12
            {"NIMP_GGI","GGI221"},; // 13
             "Z3_MPImp",;           // 14
             "Z3_MSIImp",;          // 15 MAT. Improdutivo
             "Z3_MSNImp",;          // 16
             "Z3_ImpSal",;          // 17 Mão-De-Obra Direta
             "Z3_ImpEnc",;          // 18
             "Z3_ImpBen",;          // 19
             "Z3_ImpGGF"}           // 20
           //  "NIMP_PI"   }

a_gMon  := {{"NMON_MPI","MPN211"},;
            {"NMON_MPN","MPI211"},;
            {"NMON_PI" ,"_PI211"},; // 03 PI
            {"NMON_MII","MII211"},;
            {"NMON_MIN","MIN211"},;
            {"NMON_SAL","SAL211"},;
            {"NMON_ENC","ENC211"},;
            {"NMON_BEN","BEN211"},;
            {"NMON_GGF","GGF211"},;
            {"NMON_MIS","MIS211"},;
            {"NMON_MIE","MIE211"},;
            {"NMON_MIO","MIO211"},;
            {"NMON_GGI","GGI211"},;
             "Z3_MPMON" ,;
             "Z3_MSIMON",; // MAT. Improdutivo
             "Z3_MSNMON",;
             "Z3_MONSal",; // Mão-De-Obra Direta
             "Z3_MONEnc",;
             "Z3_MONBen",;
             "Z3_MONGGF"}
           //  "NMON_PI"   }

a_gInj  :=  {{"NINJ_MPI","MPN231"},;
             {"NINJ_MPN","MPI231"},;
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
           //   "NINJ_PI"   }

a_gIns  := {{"NINS_MPI","MPN241"},;
            {"NINS_MPN","MPI241"},;
            {"NINS_PI" ,"_PI241"},; // 03 PI
            {"NINS_MII","MII241"},;
            {"NINS_MIN","MIN241"},;
            {"NINS_SAL","SAL241"},;
            {"NINS_ENC","ENC241"},;
            {"NINS_BEN","BEN241"},;
            {"NINS_GGF","GGF241"},;
            {"NINS_MIS","MIS241"},;
            {"NINS_MIE","MIE241"},;
            {"NINS_MIO","MIO241"},;
            {"NINS_GGI","GGI241"},;
             "Z3_MPINS" ,;
             "Z3_MSIINS",; // MAT. Improdutivo
             "Z3_MSNINS",;
             "Z3_INSSal",; // Mão-De-Obra Direta
             "Z3_INSEnc",;
             "Z3_INSBen",;
             "Z3_INSGGF"}
          //   "NINS_PI"   }

a_gSns  := {{"NSNS_MPI","MPN251"},;
            {"NSNS_MPN","MPI251"},;
            {"NSNS_PI" ,"_PI251"},; // 03 PI
            {"NSNS_MII","MII251"},;
            {"NSNS_MIN","MIN251"},;
            {"NSNS_SAL","SAL251"},;
            {"NSNS_ENC","ENC251"},;
            {"NSNS_BEN","BEN251"},;
            {"NSNS_GGF","GGF251"},;
            {"NSNS_MIS","MIS251"},;
            {"NSNS_MIE","MIE251"},;
            {"NSNS_MIO","MIO251"},;
            {"NSNS_GGI","GGI251"},;
             "Z3_MPSNS" ,;
             "Z3_MSISNS",; // MAT. Improdutivo
             "Z3_MSNSNS",;
             "Z3_SNSSal",; // Mão-De-Obra Direta
             "Z3_SNSEnc",;
             "Z3_SNSBen",;
             "Z3_SNSGGF"}
          //   "NINS_PI"   }


dbSelectArea("SD3")
SET FILTER TO dtos(D3_EMISSAO) >= dtos(mv_par03) .and. dtos(D3_EMISSAO) <= dtos(mv_par04) .AND.D3_ESTORNO <> "S"// .AND. D3_CF $ "RE2/RE5/RE1"

dbSelectArea("SC2")
dbSetOrder(2)

ProcRegua(RecCount())

dbSeek(xFilial("SC2")+MV_PAR01,.T.)

While !Eof() .And. C2_PRODUTO <= MV_PAR02
		
	If (DTOS(C2_DATPRI) < DTOS(MV_PAR03) .or. DTOS(C2_DATPRI) > DTOS(MV_PAR04)) .Or.;
		C2_QUJE == 0
		dbSkip()
		Loop                                                        	
	End
	
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
	
	xTipo := B1_Tipo
	
	dbSelectArea("SC2")
	
	While !Eof() .And. C2_PRODUTO == xProduto
		
		   IncProc("Ordem de Produção: "+C2_NUM+"  De: "+DTOC(C2_Emissao) )
		
		   If (DTOS(C2_DATPRI) < DTOS(MV_PAR03) .or. DTOS(C2_DATPRI) > DTOS(MV_PAR04)) .Or.;
			  C2_QUJE == 0
			  dbSkip()
			  Loop                                                        	
		   End
		
		   xOP    := AllTrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
		   xQuant += C2_Quje
		
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

dbSelectArea("SD3")
SET FILTER TO

Return

/*
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funçao    ³ ImpEstr  ³ Autor ³ Marcelo Iannuzzi      ³Inicio³ 24.03.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±*/

Static Function ImpEstr()
Local cVar   := ""

n_xMPN := 0
n_xMPI := 0
n_xPI  := 0
n_TMP  := 0
n_MII  := 0
n_MIN  := 0
n_SAL  := 0
n_ENC  := 0
n_BEN  := 0
n_GGF  := 0
n_MIS  := 0
n_MIE  := 0
n_MIO  := 0
n_GGI  := 0
n_TOT  := 0

dbSelectArea("SD3")
dbSetOrder(1)
dbSeek(xFilial("SD3")+Alltrim(xOP))

xEmissao := D3_EMISSAO
c_CC     := D3_CC

While !Eof() .and. xOP == AllTrim(D3_OP)

	  dbSelectArea("SB1") 
	  dbSetOrder(1)
	  dbSeek(xFilial("SB1")+SD3->D3_COD)

	  dbSelectArea("SD3")  
 	
	  /*If !(D3_TIPO $ "MP/GG/BN") 
		 If D3_TIPO $ "PI/RT" .And. D3_CF <> "PR0"
			n_xPI += D3_CUSTO1
		 EndIf
		 dbSkip()
		 Loop
	  EndIf*/
	
	  If D3_CF == "PR0"
		 dbSkip()
		 Loop
	  End
	  If     ALLTRIM(D3_GRUPO) == "MPN" .Or. D3_TIPO = "BN"
		n_xMPN += D3_CUSTO1
	  ElseIf ALLTRIM(D3_GRUPO) == "MPI"
		n_xMPI += D3_CUSTO1
	  ElseIf ALLTRIM(D3_TIPO) == "PI"
		n_xPI  += D3_CUSTO1
	  ElseIf ALLTRIM(D3_GRUPO) == "GGF"
        cVar   := "n_"+SubStr(D3_COD,1,3)
        &cVar  += (D3_CUSTO1)
	  EndIf
		
	dbSkip()
EndDo

GetVar(c_CC)

&a_Grv01 := (&a_Grv01 + n_xMPI)
&a_Grv02 := (&a_Grv02 + n_xMPN)
&a_Grv03 := (&a_Grv03 + n_xPI)

&a_Grv04 := (&a_Grv04 +  n_MII)
&a_Grv05 := (&a_Grv05 +  n_MIN)

&a_Grv06 += (n_SAL)
&a_Grv07 += (n_ENC)
&a_Grv08 += (n_BEN)
&a_Grv09 += (n_GGF)

&a_Grv10 += (n_MIS)
&a_Grv11 += (n_MIE)
&a_Grv12 += (n_MIO)
&a_Grv13 += (n_GGI)

//&a_Grv20 := (&a_Grv20 +  n_xPI)

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
//c_GrvVal     := a_Grv[20]
a_GrvVal[14] := &c_GrvVal
//n_GrvVal     += a_GrvVal[13]
	
If NoRound(n_GrvVal) <= 0.00000000
	Return
EndIf

If dbSeek(xFilial("SZ4")+dtos(mv_par04)+xProduto+c_Cust)
	RecLock("SZ4",.F.)
Else
	RecLock("SZ4",.T.)
EndIf

SZ4->Z4_FILIAL  := xFilial()
SZ4->Z4_CC      := c_Cust
SZ4->Z4_PRODUTO := xProduto
SZ4->Z4_DATA    := mv_par04
SZ4->Z4_QUANT   := xQuant
//SZ4->Z4_PI      := a_grvVal[13]
SZ4->Z4_MPI     := (a_grvVal[01])    //{{"NINJ_MPI","MPN231"},;
SZ4->Z4_MPN     := (a_grvVal[02])    // {"NINJ_MPN","MPI231"},;
SZ4->Z4_PI      := (a_grvVal[03])    // {"NINJ_PI" ,"_PI231"},; // 03 PI
SZ4->Z4_MSI     := (a_grvVal[04])    // {"NINJ_MII","MII231"},;
SZ4->Z4_MSN     := (a_grvVal[05])    // {"NINJ_MIN","MIN231"},;
SZ4->Z4_MODSAL  := (a_grvVal[06])    // {"NINJ_SAL","SAL231"},;
SZ4->Z4_MODENC  := (a_grvVal[07])    // {"NINJ_ENC","ENC231"},;
SZ4->Z4_MODBEN  := (a_grvVal[08])    // {"NINJ_BEN","BEN231"},;
SZ4->Z4_MODGGF  := (a_grvVal[09])    // {"NINJ_GGF","GGF231"},;
SZ4->Z4_MOISAL  := (a_grvVal[10])    // {"NINJ_MIS","MIS231"},;
SZ4->Z4_MOIENC  := (a_grvVal[11])    // {"NINJ_MIE","MIE231"},;
SZ4->Z4_MOIBEN  := (a_grvVal[12])    // {"NINJ_MIO","MIO231"},;
SZ4->Z4_MOIGGF  := (a_grvVal[13])    // {"NINJ_GGI","GGI231"},;
MsUnLock()

Return
/*
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funçao    ³ GetArray ³ Autor ³ Marcelo Iannuzzi      ³Inicio³ 24.03.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±*/
Static Function GetArray(c_CC)
Local a_Var:={}

If     Alltrim(c_CC) == "251" 	// Sensor do Combustivel
	a_Var := a_gSns
ElseIf Alltrim(c_CC) == "241" 	// Insercao Automatica
	a_Var := a_gIns
ElseIf Alltrim(c_CC) == "231"  	// Injecao Plastica
	a_Var := a_gInj
ElseIf Alltrim(c_CC) == "221"  	// Impressao
	a_Var := a_gImp
Else	                        // Montagem
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

For _i:=1 to 20
	c_GrvVal  := "a_Grv" + StrZero(_i,2)
	If Len(a_GrvVal[_i])<>2
		&c_GrvVal := a_GrvVal[_i]
	Else
		&c_GrvVal := a_GrvVal[_i][1]
	Endif
Next

///a_Grv20 := a_GrvVal[20]

Return

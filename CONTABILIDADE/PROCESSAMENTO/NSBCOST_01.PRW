#include "rwmake.ch"

User Function COST_01()

Private oGeraRat := Nil
Private cMesRef  := Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³NSBCOST_01³ Autor ³ Jorge S.da Silva      ³ Data ³ 12.04.12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³Importacao das Despesas contabeis para Custo de Fabricacao   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

cPerg := "GGF001"

Pergunte(cPerg,.F.)

@ 200,1 TO 380,380 DIALOG oGeraRat TITLE OemToAnsi("Importacao dos Custos Contabeis.")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira gerar o Rateio ref. aos Custos mensais com"
@ 18,018 Say " Mao-de-obra Direta, Mao-de-obra Indireta e Gastos Gerais de"
@ 26,018 Say " Fabricacao."

@ 70,098 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg)
@ 70,128 BMPBUTTON TYPE 01 ACTION cGrvDados()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oGeraRat)

Activate Dialog oGeraRat Centered

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³cGrvDados ³ Autor ³ Jorge S.da Silva      ³ Data ³ 11.02.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Grava dados do Rateio.                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function cGrvDados()

If MsgYEsNo ("Confirma Valores para Rateio?","Escolha")
	Processa( {|| RunProc(),"Rateio Mat. Improdutivo." } )
	Close(oGeraRat)
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RunProc   ³ Autor ³ Jorge S.da Silva      ³ Data ³ 11.02.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Executa o Processamento                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RunProc()

SetPrvt("CMESREF,CMODFUN,CMODUSI,CMODPIN,CMODMON,CCTMOI")
SetPrvt("CGGFFUN,CGGFUSI,CGGFPIN,CGGFMON,XULMES,XDATINI")
SetPrvt("GFUN,CARQSD3")
SetPrvt("gMP_Inj,gMP_Ins,gMP_Imp,gMP_Mon,gMP_Sns")
//SetPrvt("gPI_Inj,gPI_Ins,gPI_Imp,gPI_Mon")
//SetPrvt("nPI_Inj,nPI_Ins,nPI_Imp,nPI_Mon")
SetPrvt("nMP_Inj,nMP_Ins,nMP_Imp,nMP_Mon,nMP_Sns")
SetPrvt("CKEYSD3,CFILSD3,NINDEX1,NF_MPN,NF_MPI")
SetPrvt("NU_MPN,NU_MPI,NI_MPN,NI_MPI,NM_MPN,NM_MPI")
SetPrvt("XDESC,XTIPO,XUM,XPRODUTO,CPRD,ASTRU")
SetPrvt("NESTRU,I,CCOMP,CCUSTO,CMEDIO,XPODE")
SetPrvt("ACM,GMSNIMP,GMSIIMP,GMSNINJ,GMSIINJ,GMSNPIN,GMSNSNS,GMSISNS")
SetPrvt("gMSNIns,gMSIIns,nMP_Ins,nIns_MSI,nIns_MSN,nSns_MSN")
SetPrvt("GMSIPIN,GMSNMON,GMSIMON,NQUANT,NF_MSN,NF_MSI")
SetPrvt("nMPMon610,nMPImp610,nMPInj610,nMPIns610,nMPSns610")
SetPrvt("NU_MSN,NU_MSI,NP_MSN,NP_MSI,NM_MSN,NM_MSI")
SetPrvt("GTOTGER,mSaldatu,cMsg")
SetPrvt("gMon610,gImp610,gInj610,gIns610,gSns610")

cMesRef := mv_par01  // Data Referencia
xUlMes  := GetMv("MV_ULMES")

If cMesRef <= xUlMes
	If MsgYesNo("Data de referencia inferior ao Ultimo Fechamento. Deseja refazer Rateio?","Escolha")
		MsgStop("Por segurança sera gerado registro com log desta ocorrência para futuras auditorias.")
	Else
		Return
	EndIf
End

dbSelectArea("CT7") 
cArqCT7 := CriaTrab(NIL,.F. )
cKeyCT7 := "CT7_FILIAL+CT7_CONTA+DTOS(CT7_DATA)"
cFiltro := "CT7_FILIAL=='"+xFilial()+"' .and. DTOS(CT7_DATA) >= '"+SubStr(DTOS(mv_par01),1,6)
cFiltro += "01' .and. DTOS(CT7_DATA) <= '"+DTOS(mv_par01)+"'  .and. CT7_MOEDA == '01' .and. CT7_TPSALD == '1'"
//cFiltro += "' .and. BC_PRODUTO <= '"+mv_par04+"' .and. BC_OP>= '"+mv_par01+"' .and. BC_OP <= '"+mv_par02+"'"
IndRegua("CT7",cArqCT7,cKeyCT7,,cFiltro,"Selecionando Registros...")
//ProcRegua(RecCount())
dbGotop()

cMonSal := cMonEnc := cMonBen := cMonGGF := 0
cImpSal := cImpEnc := cImpBen := cImpGGF := 0
cInjSal := cInjEnc := cInjBen := cInjGGF := 0
cInsSal := cInsEnc := cInsBen := cInsGGF := 0
cSnsSal := cSnsEnc := cSnsBen := cSnsGGF := 0


IF SM0->M0_CODIGO == "01" // NSB

   //---------------------------------------
   // M O N T A G E M
   //---------------------------------------
   xSaldo("31111")
   cMonSal := mSaldatu
   xSaldo("31112")
   cMonEnc := mSaldatu
   xSaldo("31113")
   cMonBen := mSaldatu
   xSaldo("31121")
   cMonGGF := mSaldatu

   //---------------------------------------
   // I M P R E S S A O
   //---------------------------------------

   xSaldo("31211")
   cImpSal := mSaldatu
   xSaldo("31212")
   cImpEnc := mSaldatu
   xSaldo("31213")
   cImpBen := mSaldatu
   xSaldo("31221")
   cImpGGF := mSaldatu

   //---------------------------------------
   // I N S E R C A O  A U T O M A T I C A
   //---------------------------------------
   xSaldo("31311")
   cInsSal := mSaldatu
   xSaldo("31312")
   cInsEnc := mSaldatu
   xSaldo("31313")
   cInsBen := mSaldatu
   xSaldo("31321")
   cInsGGF := mSaldatu

   //---------------------------------------
   // I N J E C A O  P L A S T I C A
   //---------------------------------------
   xSaldo("31411")
   cInjSal := mSaldatu
   xSaldo("31412")
   cInjEnc := mSaldatu
   xSaldo("31413")
   cInjBen := mSaldatu
   xSaldo("31421")
   cInjGGF := mSaldatu
   
   //----------------------------------------
   // S E N S O R  D O  C O M B U S T I V E L // INCLUIDO EM: 10/02/2014  
   //----------------------------------------
   xSaldo("31611")
   cSnsSal := mSaldatu
   xSaldo("31612")
   cSnsEnc := mSaldatu
   xSaldo("31613")
   cSnsBen := mSaldatu
   xSaldo("31621")
   cSnsGGF := mSaldatu
 

ELSEIF SM0->M0_CODIGO == "04" // NSSP

   //---------------------------------------
   // M O N T A G E M
   //---------------------------------------
   xSaldo("31111")
   cMonSal := mSaldatu
   xSaldo("31112")
   cMonEnc := mSaldatu
   xSaldo("31113")
   cMonBen := mSaldatu
   xSaldo("31121")
   cMonGGF := mSaldatu

   //---------------------------------------
   // I N J E C A O  P L A S T I C A
   //---------------------------------------
   xSaldo("31211")
   cInjSal := mSaldatu
   xSaldo("31212")
   cInjEnc := mSaldatu
   xSaldo("31213")
   cInjBen := mSaldatu
   xSaldo("31221")
   cInjGGF := mSaldatu
     
End

//---------------------------------------
// MAO-DE-OBRA-INDIRETA
//---------------------------------------
xSaldo("31511")
cMOISal := mSaldatu
xSaldo("31512")
cMOIEnc := mSaldatu
xSaldo("31513")
cMOIBen := mSaldatu
xSaldo("31521")
cMOIGGF := mSaldatu

dbSelectArea("SZ3")
If !dbSeek(xFilial("SZ3")+dtos(cMesRef))
	RecLock("SZ3",.T.)
	SZ3->Z3_Filial := xFilial("SZ3")
	SZ3->Z3_Data   := cMesRef
	SZ3->Z3_MonSal := cMonSal // Montagem
	SZ3->Z3_MonEnc := cMonEnc
	SZ3->Z3_MonBen := cMonBen
	SZ3->Z3_MonGGF := cMonGGF
	SZ3->Z3_ImpSal := cImpSal // Impressão
	SZ3->Z3_ImpEnc := cImpEnc
	SZ3->Z3_ImpBen := cImpBen
	SZ3->Z3_ImpGGF := cImpGGF
	SZ3->Z3_InjSal := cInjSal // Inj. Plastica
	SZ3->Z3_InjEnc := cInjEnc
	SZ3->Z3_InjBen := cInjBen
	SZ3->Z3_InjGGF := cInjGGF
	SZ3->Z3_InsSal := cInsSal // Ins. Automatica
	SZ3->Z3_InsEnc := cInsEnc
	SZ3->Z3_InsBen := cInsBen
	SZ3->Z3_InsGGF := cInsGGF
    //--------- Sensor // INCLUIDO EM 10/02/2014
	SZ3->Z3_SnsSal := cSnsSal // Sensor do Combustivel
	SZ3->Z3_SnsEnc := cSnsEnc
	SZ3->Z3_SnsBen := cSnsBen
	SZ3->Z3_SnsGGF := cSnsGGF
	//----------------------------------------
	SZ3->Z3_MOISal := cMOISal // Mao-de-Obra Indireta
	SZ3->Z3_MOIEnc := cMOIEnc
	SZ3->Z3_MOIBen := cMOIBen
	SZ3->Z3_MOIGGF := cMOIGGF
	SZ3->(msUnlock())
Else
	If MsgYesNo ("Data de ref. ja Cadastrada. Deseja refazer Rateio?","Escolha")
		RecLock("SZ3",.F.)
		SZ3->Z3_Data   := cMesRef
		SZ3->Z3_MonSal := cMonSal // Montagem
		SZ3->Z3_MonEnc := cMonEnc
		SZ3->Z3_MonBen := cMonBen
		SZ3->Z3_MonGGF := cMonGGF
		SZ3->Z3_ImpSal := cImpSal // Impressão
		SZ3->Z3_ImpEnc := cImpEnc
		SZ3->Z3_ImpBen := cImpBen
		SZ3->Z3_ImpGGF := cImpGGF
		SZ3->Z3_InjSal := cInjSal // Inj. Plastica
		SZ3->Z3_InjEnc := cInjEnc
		SZ3->Z3_InjBen := cInjBen
		SZ3->Z3_InjGGF := cInjGGF
		SZ3->Z3_InsSal := cInsSal // Ins. Automatica
		SZ3->Z3_InsEnc := cInsEnc
		SZ3->Z3_InsBen := cInsBen
		SZ3->Z3_InsGGF := cInsGGF
		//---------------Sensor do Combustivel
		SZ3->Z3_SnsSal := cSnsSal // Sensor do Combustivel // INCLUIDO EM 10/02/2014
		SZ3->Z3_SnsEnc := cSnsEnc
		SZ3->Z3_SnsBen := cSnsBen
		SZ3->Z3_SnsGGF := cSnsGGF
		//-----------------------
		SZ3->Z3_MOISal := cMOISal // Mao-de-Obra Indireta
		SZ3->Z3_MOIEnc := cMOIEnc
		SZ3->Z3_MOIBen := cMOIBen
		SZ3->Z3_MOIGGF := cMOIGGF
		SZ3->(msUnlock())
	Else
		Return
	EndIf
End

Processa( {|| xCustoMp() } )

 RecLock("SZ3",.F.)
 SZ3->Z3_MPMon  := gMP_Mon  // Consumo de MP Montagem
 SZ3->Z3_MPImp  := gMP_Imp  // Consumo de MP Impressao
 SZ3->Z3_MPInj  := gMP_Inj  // Consumo de MP Injcao Plastica
 SZ3->Z3_MPIns  := gMP_Ins  // Consumo de MP Insercao Automatica
 SZ3->Z3_MPSns  := gMP_Sns  // Consumo de MP Sensor Combustivel
 //
 //SZ3->Z3_PIMon  := gPI_Mon  // Consumo de PI Montagem
 //SZ3->Z3_PIImp  := gPI_Imp  // Consumo de PI Impressao
 //SZ3->Z3_PIInj  := gPI_Inj  // Consumo de PI Injcao Plastica
 //SZ3->Z3_PIIns  := gPI_Ins  // Consumo de PI Insercao Automatica 
 //
 SZ3->(msUnlock())

dbSelectArea('SD3')
Set Filter To
RetIndex('SD3')

Processa( {|| xCustoMs() } )

 RecLock("SZ3",.F.)
 SZ3->Z3_MSNMon := gMSNMon
 SZ3->Z3_MSIMon := gMSIMon
 SZ3->Z3_MSNImp := gMSNImp
 SZ3->Z3_MSIImp := gMSIImp
 SZ3->Z3_MSNInj := gMSNInj
 SZ3->Z3_MSIInj := gMSIInj
 SZ3->Z3_MSNIns := gMSNIns
 SZ3->Z3_MSIIns := gMSIIns 
 SZ3->Z3_MSISns := gMSISns // INCLUIDO EM 10/02/2014
 SZ3->Z3_MSNSns := gMSNSns // INCLUIDO EM 10/02/2014
 //
 //SZ3->Z3_Mon610 := gMon610 // Mat.Prima c/ Mov. 610 p/ Mon
 //SZ3->Z3_Imp610 := gImp610 // Mat.Prima c/ Mov. 610 p/ Imp
 //SZ3->Z3_Inj610 := gInj610 // Mat.Prima c/ Mov. 610 p/ Inj
 //SZ3->Z3_Ins610 := gIns610 // Mat.Prima c/ Mov. 610 p/ Ins
 //
 SZ3->Z3_MPMon  := gMP_Mon  // Consumo de MP Montagem
 SZ3->Z3_MPImp  := gMP_Imp  // Consumo de MP Impressao
 SZ3->Z3_MPInj  := gMP_Inj  // Consumo de MP Injcao Plastica
 SZ3->Z3_MPIns  := gMP_Ins  // Consumo de MP Insercao Automatica
 SZ3->Z3_MPSns  := gMP_Sns  // Consumo de MP Sensor do Combustivel // INCLUIDO EM 10/02/2014
 //
 SZ3->(msUnlock())

dbSelectArea('SD3')
Set Filter To
RetIndex('SD3')
dbSelectArea("CT7") 
Set Filter To
Retindex("CT7") 

MsgBox ("Processo concluido com SUCESSO!!!","Informação","INFO")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³xCustoMp  ³ Autor ³ Jorge S.da Silva      ³ Data ³ 11.02.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado  ³xCustoMp  ³ Autor ³ Marcelo I. Silveira   ³ Data ³ 01.04.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Processamento dos Custos das Materias Primas, utiliazadas no³±±
±±³          ³Processo de Producao.                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xCustoMp()
//
xDatIni := ctod("01/"+SubStr(dtoc(cMesRef),4,7))
//
gMP_Ins  := 0
gMP_Inj  := 0
gMP_Imp  := 0
gMP_Mon  := 0
gMP_Sns  := 0
//gPI_Ins  := 0
//gPI_Inj  := 0
//gPI_Imp  := 0
//gPI_Mon  := 0
nMP_Ins := 0   // Insercao Automatica
nMP_Inj := 0   // Injecao Plastica
nMP_Imp := 0   // Impressao
nMP_Mon := 0   // Montagem
nMP_Sns := 0   // Sensor
//nPI_Ins := 0   // Insercao Automatica
//nPI_Inj := 0   // Injecao Plastica
//nPI_Imp := 0   // Impressao
//nPI_Mon := 0   // Montagem
//
dbSelectArea("SD3")
dbSetOrder(1)
cArqSD3 := CriaTrab(NIL,.F. )
cKeySD3 := "D3_Filial + D3_Cod + dtos(D3_Emissao)" // IndexKey()
cFilSD3 := "D3_FILIAL='"+xFilial("SD3")+"'.And.D3_CF$'"+"RE1/RE2"+"'.And.D3_ESTORNO<>'"+"S"+"'.And.D3_TIPO$'MP/PI'"
cFilSD3 += " .And. DTOS(D3_EMISSAO)>='"+DTOS(xDatIni)+"' .And. DTOS(D3_EMISSAO)<='"+DTOS(cMesRef)+"'.AND. !Empty(D3_OP)"
IndRegua("SD3",cArqSD3,cKeySD3,,cFilSD3,"Selecionando Registros...")

ProcRegua(RecCount())
dbGoTop()
While !Eof()
	//
	IncProc("Consumo das OP's. CC: "+D3_CC+" OP: "+D3_OP)
	//
	If D3_Tipo $ "MP/PI"
	   If Alltrim(D3_CC)     == "241" // Insercao Automatica
	      nMP_Ins += D3_Custo1	                    
	   ElseIf Alltrim(D3_CC) == "231" // Injecao Plastica
		  nMP_Inj += D3_Custo1
	   ElseIf Alltrim(D3_CC) == "221" // Impressao
		  nMP_Imp += D3_Custo1 
	   ElseIf Alltrim(D3_CC) == "251" // Sensor Combustivel
		  nMP_Sns += D3_Custo1 		  
	   Else   ///If Alltrim(D3_CC) $ "211" //  Montagem
		  nMP_MON += D3_Custo1
	   End
	EndIf   
	//   
/*	ElseIf D3_Tipo == "PI"
	  If Alltrim(D3_CC)     == "241" // Insercao Automatica
	      nPI_Ins += D3_Custo1	
	   ElseIf Alltrim(D3_CC) == "231" // Injecao Plastica
		  nPI_Inj += D3_Custo1
	   ElseIf Alltrim(D3_CC) == "221" // Impressao
		  nPI_Imp += D3_Custo1 
	   Else   ///If Alltrim(D3_CC) $ "211" //  Montagem
		  nPI_MON += D3_Custo1
	   End
	End */  
	
	dbSkip()
	
Enddo
//
gMP_Ins  := nMP_Ins
gMP_Inj  := nMP_Inj
gMP_Imp  := nMP_Imp
gMP_Mon  := nMP_Mon
gMP_Sns  := nMP_Sns  // INCLUIDO EM 10/02/2014
//
//gPI_Ins  := nPI_Ins
//gPI_Inj  := nPI_Inj
//gPI_Imp  := nPI_Imp
//gPI_Mon  := nPI_Mon
//
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³xCustoMs  ³ Autor ³ Jorge S.da Silva      ³ Data ³ 11.02.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Processamento das Req. de Materias de Consumo, acumulando   ³±±
±±³          ³Por Centro de Custo.                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xCustoMs()

xDatIni  := ctod("01/"+SubStr(dtoc(cMesRef),4,7))
gMSNMon  := 0
gMSIMon  := 0
gMSNImp  := 0
gMSIImp  := 0
gMSNInj  := 0
gMSIInj  := 0
gMSNIns  := 0
gMSIIns  := 0
gMSNSns  := 0
gMSISns  := 0
gMon610  := 0
gImp610  := 0
gInj610  := 0
gIns610  := 0
gSns610  := 0

nMon_MSN := 0
nMon_MSI := 0
nImp_MSN := 0
nImp_MSI := 0
nInj_MSN := 0
nInj_MSI := 0
nIns_MSN := 0
nIns_MSI := 0 
nSns_MSN := 0
nSns_MSI := 0 

nMon610  := 0
nImp610  := 0
nInj610  := 0
nIns610  := 0
nSns610  := 0

dbSelectArea("SD3")
cArqSD3 := CriaTrab(NIL,.F. )
cKeySD3 := "D3_Filial+D3_Cod+dtos(D3_Emissao)" // IndexKey()
cFilSD3 := "D3_FILIAL='"+xFilial("SD3")+"'.And.D3_TM$'"+"610"+"'.And.D3_ESTORNO#'"+"S"+"'"
cFilSD3 := cFilSD3 + ".And.DTOS(D3_EMISSAO)>='"+DTOS(xDatIni)+"'.And.DTOS(D3_EMISSAO)<='"+DTOS(cMesRef)+"'"
IndRegua("SD3",cArqSD3,cKeySD3,,cFilSD3,"Selecionando Registros...")

ProcRegua(RecCount())
dbGoTop()

While !Eof()
	
	IncProc("Materiais Improdutivos. OP: "+D3_DOC)
	
	Do Case
	   Case SubStr(SD3->D3_CC,1,3)=="211"    //  MONTAGEM
				If AllTrim(SD3->D3_Grupo) $ "MSN/MCN/MNN"
					nMon_MSN += D3_Custo1
				ElseIf AllTrim(SD3->D3_Grupo) $ "MSI/MCI/MNI"
					nMon_MSI += D3_Custo1
				ElseIf D3_Tipo == "MP"
					nMon610 += D3_Custo1
				End
				
	   Case SubStr(SD3->D3_CC,1,3)=="221"    //  IMPRESSAO
				If AllTrim(SD3->D3_Grupo) $ "MSN/MCN/MNN"
					nImp_MSN += D3_Custo1
				ElseIf AllTrim(SD3->D3_Grupo) $ "MSI/MCI/MNI"
					nImp_MSI += D3_Custo1
				ElseIf D3_Tipo == "MP"
					nImp610 += D3_Custo1	
				End
				
	    Case SubStr(SD3->D3_CC,1,3)=="231"    //  Injecao Plastica
				If AllTrim(SD3->D3_Grupo) $ "MSN/MCN/MNN"
					nInj_MSN += D3_Custo1
				ElseIf AllTrim(SD3->D3_Grupo) $ "MSI/MCI/MNI"
					nInj_MSI += D3_Custo1
				ElseIf D3_Tipo == "MP"
					nInj610 += D3_Custo1	
				End
		
		Case SubStr(SD3->D3_CC,1,3)=="241"    //  Insercao Automatica
				If AllTrim(SD3->D3_Grupo) $ "MSN/MCN/MNN/   "
					nIns_MSN += D3_Custo1
				ElseIf AllTrim(SD3->D3_Grupo) $ "MSI/MCI/MNI"
					nIns_MSI += D3_Custo1
				ElseIf D3_Tipo == "MP"
					nIns610 += D3_Custo1	
				End

		Case SubStr(SD3->D3_CC,1,3)=="251"    //  Sensor Combustivel
				If AllTrim(SD3->D3_Grupo) $ "MSN/MCN/MNN/   "
					nSns_MSN += D3_Custo1
				ElseIf AllTrim(SD3->D3_Grupo) $ "MSI/MCI/MNI"
					nSns_MSI += D3_Custo1
				ElseIf D3_Tipo == "MP"
					nSns610 += D3_Custo1	
				End
				
						
	EndCase
		
	dbSkip()
		
EndDo
	
gMSNMon  += nMon_MSN
gMSIMon  += nMon_MSI
gMSNImp  += nImp_MSN
gMSIImp  += nImp_MSI
gMSNInj  += nInj_MSN
gMSIInj  += nInj_MSI
gMSNIns  += nIns_MSN
gMSIIns  += nIns_MSI
gMSNSns  += nSns_MSN
gMSISns  += nSns_MSI

gMon610  += gMon610
gImp610  += gImp610
gInj610  += gInj610
gIns610  += gIns610
gSns610  += gSns610
	
gTotMon := (gMSNMon+gMSIMon+gMon610)
gTotImp := (gMSNImp+gMSIImp+gImp610)
gTotInj := (gMSNInj+gMSIInj+gInj610)
gTotIns := (gMSNIns+gMSIIns+gIns610)
gTotSns := (gMSNSns+gMSISns+gSns610)

gTotGer := (gTotMon+gTotImp+gTotInj+gTotIns+gTotSns)

// Processo         Mat.Impr.Nac   Mat.Impr.Imp   MP-Mov.610
// MONTAGEM FINAL     999.999,99     999.999,99   999.999,99
// IMPRESSAO          999.999,99     999.999,99   999.999,99
// INJ. PLASTICA      999.999,99     999.999,99   999.999,99
// INS. AUTOMÁTICA    999.999,99     999.999,99   999.999,99
// TOTAL GERAL        999.999,99     999.999,99   999.999,99

@ 0,0 TO 250,450 DIALOG oDlg2 TITLE "Custo Total da Movimentacao 610"
@ 005,010 Say "PROCESSO   "
@ 005,050 Say "M.IMPR.NAC "
@ 005,100 Say "M.IMPR.IMP "
@ 005,150 Say "MOV. MP.610"
@ 005,200 Say "TOTAL      "

@ 015,010 Say "MONTAGEM FINAL"
@ 015,050 Say Transform(gMSNMon,"@E 99,999,999.99")
@ 015,100 Say Transform(gMSIMon,"@E 99,999,999.99")
@ 015,150 Say Transform(gMon610,"@E 99,999,999.99")
@ 015,200 Say Transform(gTotMon,"@E 999,999,999.99")

@ 025,010 Say "IMPRESSAO     "
@ 025,050 Say Transform(gMSNImp,"@E 99,999,999.99")
@ 025,100 Say Transform(gMSIImp,"@E 99,999,999.99")
@ 025,150 Say Transform(gImp610,"@E 99,999,999.99")
@ 025,200 Say Transform(gTotImp,"@E 999,999,999.99")

@ 035,010 Say "INJ.PLASTICA  "
@ 035,050 Say Transform(gMSNInj,"@E 99,999,999.99")
@ 035,100 Say Transform(gMSIInj,"@E 99,999,999.99")
@ 035,150 Say Transform(gInj610,"@E 99,999,999.99")
@ 035,200 Say Transform(gTotInj,"@E 999,999,999.99")

@ 045,010 Say "INS.AUTOMATICA"
@ 045,050 Say Transform(gMSNIns,"@E 99,999,999.99")
@ 045,100 Say Transform(gMSIIns,"@E 99,999,999.99")
@ 045,150 Say Transform(gIns610,"@E 99,999,999.99")
@ 045,200 Say Transform(gTotIns,"@E 999,999,999.99")

@ 055,010 Say "SENSOR COMBUS."
@ 055,050 Say Transform(gMSNSns,"@E 99,999,999.99")
@ 055,100 Say Transform(gMSISns,"@E 99,999,999.99")
@ 055,150 Say Transform(gSns610,"@E 99,999,999.99")
@ 055,200 Say Transform(gTotSns,"@E 999,999,999.99")

@ 065,010 Say "TOTAL GERAL   "
@ 065,050 Say Transform((gMSNMon+gMSNImp+gMSNInj+gMSNIns+gMSNSns),"@E 99,999,999.99")
@ 065,100 Say Transform((gMSIMon+gMSIImp+gMSIInj+gMSIIns+gMSISns),"@E 99,999,999.99")
@ 065,150 Say Transform((gMon610+gImp610+gInj610+gIns610+gSns610),"@E 99,999,999.99")
@ 065,200 Say Transform((gTotMon+gTotImp+gTotInj+gTotIns+gTotSns),"@E 999,999,999.99")

@ 085,200 BMPBUTTON TYPE 02 ACTION Close(oDlg2)

ACTIVATE DIALOG oDlg2 CENTER

Return

*******************************
Static Function xSaldo(cConta)
*******************************
mSaldatu := 0
mSaldMes := 0
nDebito  := 0
nCredit  := 0
dbSelectArea("CT7")
dbSeek(xFilial("CT7")+cConta)

While !Eof() .and. cConta==SubStr(CT7_Conta,1,5)
	If Right(alltrim(CT7_Conta),3)<>"999"
		nDebito  += CT7_Debito
		nCredit  += CT7_Credit
	EndIf	
	dbSkip()
	
EndDo
	
	mSaldMes := nDebito - nCredit
    mSaldatu := mSaldMes

Return

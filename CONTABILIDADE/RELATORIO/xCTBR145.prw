#Include "Ctbr145.Ch"
#Include "PROTHEUS.Ch"

#DEFINE TAM_VALOR	18


// 17/08/2009 -- Filial com mais de 2 caracteres

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ CTBR145  ³ Autor ³ Cicero J. Silva   	³ Data ³ 04.08.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balancete Conta/C.Custo                 			 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Ctbr145      											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso 		 ³ SIGACTB      											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xCTBR145()

Local aArea := GetArea()
Local oReport          

Local lOk := .T.
Local aCtbMoeda		:= {}
Local nDivide		:= 1

PRIVATE cTipoAnt	:= ""
PRIVATE cPerg	 	:= "CTR145"
PRIVATE nomeProg  	:= "CTBR145"  
PRIVATE oTRF1
PRIVATE oTRF2
PRIVATE oTRF3
PRIVATE oTRF4
PRIVATE nTotMov	:= 0
PRIVATE nTotdbt		:= 0
PRIVATE nTotcrt		:= 0
PRIVATE titulo
PRIVATE aSelFil		:= {}
PRIVATE lTodasFil		:= .F.

CtAjustSx1(cPerg)         


If FindFunction("TRepInUse") .And. TRepInUse()
	
  	Pergunte(cPerg,.T.) // Precisa ativar as perguntas antes das definicoes.

	If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
		lOk := .F.
	EndIf
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
	//³ Gerencial -> montagem especifica para impressao)			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !ct040Valid(mv_par08) // Set Of Books
		lOk := .F.
	EndIf 

  	If mv_par24 == 2			// Divide por cem
		nDivide := 100
	ElseIf mv_par24 == 3		// Divide por mil
		nDivide := 1000
	ElseIf mv_par24 == 4		// Divide por milhao
		nDivide := 1000000
	EndIf

	If lOk
		aCtbMoeda  	:= CtbMoeda(mv_par10) // Moeda?
	   If Empty(aCtbMoeda[1])
	      Help(" ",1,"NOMOEDA")
	      lOk := .F.
	   Endif
	Endif

	If lOk .And. mv_par29 == 1 .And. Len( aSelFil ) <= 0
		aSelFil := AdmGetFil(@lTodasFil)
		If Len( aSelFil ) <= 0
			lOk := .F.
		EndIf
	EndIf  

	If lOk
		oReport := ReportDef(aCtbMoeda,nDivide)
		oReport:PrintDialog()
	EndIf
Else
	CTBR145R3() // Executa versão anterior do fonte
Endif
	
RestArea(aArea)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ReportDef º Autor ³ Cicero J. Silva    º Data ³  01/08/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Definicao do objeto do relatorio personalizavel e das      º±±
±±º          ³ secoes que serao utilizadas                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ aCtbMoeda  - Matriz ref. a moeda                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ReportDef(aCtbMoeda,nDivide)

Local oReport
Local oSection1
Local oSection2 
Local oBreak

Local cSayCusto		:= CtbSayApro("CTT")

LOCAL cDesc1 		:= STR0001+ Upper(cSayCusto)	//"Este programa ira imprimir o Balancete de Conta / "
LOCAL cDesc2 		:= STR0002				  //"de acordo com os parametros solicitados pelo Usuario"

Local aTamCC    	:= TAMSX3("CTT_CUSTO")
Local aTamCCRes 	:= TAMSX3("CTT_RES")
Local aTamConta		:= TAMSX3("CT1_CONTA")
Local aTamCtaRes	:= TAMSX3("CT1_RES")
                                            
Local nTamCC  		:= Len(CriaVar("CTT->CTT_DESC"+mv_par10))
Local nTamCta 		:= Len(CriaVar("CT1->CT1_DESC"+mv_par10))

Local lPulaPag		:= Iif(mv_par20==1,.T.,.F.)
Local lPula			:= Iif(mv_par21==1,.T.,.F.)
Local lCCNormal		:= Iif(mv_par23==1,.T.,.F.)
Local lPrintZero	:= Iif(mv_par24==1,.T.,.F.)
Local lCNormal		:= Iif(mv_par25==1,.T.,.F.)

Local cSegAte 	   	:= mv_par13 // Imprimir ate o Segmento?
Local cSegmento		:= mv_par14
Local cSegIni		:= mv_par15
Local cSegFim		:= mv_par16
Local cFiltSegm		:= mv_par17
Local nDigitAte		:= 0
Local nPos			:= 0
Local nDigitos		:= 0
Local lMov		:= IIF(mv_par18 == 1,.T.,.F.) // Imprime movimento ?

Local cSepara1		:= ""
Local cSepara2		:= ""
Local aSetOfBook := CTBSetOf(mv_par08)	
	
Local cMascara1		:= IIF (Empty(aSetOfBook[6]),GetMv("MV_MASCCUS"),RetMasCtb(aSetOfBook[6],@cSepara1))//Mascara do Centro de Custo
Local cMascara2		:= IIF (Empty(aSetOfBook[2]),GetMv("MV_MASCARA"),RetMasCtb(aSetOfBook[2],@cSepara2))//Mascara da Conta

Local cPicture 		:= aSetOfBook[4]
Local nDecimais 	:= DecimalCTB(aSetOfBook,mv_par10)
Local cDescMoeda 	:= aCtbMoeda[2]

Local bCdCUSTO	:= {|| EntidadeCTB(cArqTmp->CUSTO,0,0,20,.F.,cMascara1,cSepara1,,,,,.F.) }
Local bCdCCRES	:= {|| EntidadeCTB(cArqTmp->CCRES,0,0,20,.F.,cMascara1,cSepara1,,,,,.F.) }

Local bCdCONTA	:= {|| EntidadeCTB(cArqTmp->CONTA,0,0,25 ,.F.,cMascara2,cSepara2,,,,,.F.)}
Local bCdCTRES	:= {|| EntidadeCTB(cArqTmp->CTARES,0,0,20,.F.,cMascara2,cSepara2,,,,,.F.)}

	  titulo	:= STR0003+ Upper(cSayCusto) 	//"Balancete de Verificacao Conta / "

//Soma a mascara do custo ao tamanho do campo
If Len( cMascara1 ) > 0 .And. Len( aTamCC ) > 0
	aTamCC[1] += Len( cMascara1 ) - 1
EndIf
//Soma a mascara da conta ao tamanho do campo
If Len( cMascara2 ) > 0 .And. Len( aTamConta ) > 0
	aTamConta[1] += Len( cMascara2 ) - 1
EndIf

oReport := TReport():New(nomeProg,titulo,,{|oReport| ReportPrint(oReport,aSetOfBook,cDescMoeda,cSayCusto,nDivide)},cDesc1+cDesc2)
oReport:SetLandScape(.T.)

// Sessao 1
oSection1 := TRSection():New(oReport,STR0025+" x "+cSayCusto ,{"cArqTmp",'CT1'},/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/) //"Conta "
oReport:SetTotalInLine(.F.)
oReport:EndPage(.T.)          


//Somente sera impresso centro de custo analitico	
TRCell():New(oSection1,"CONTA"	,"cArqTmp",STR0026	,/*Picture*/,aTamConta[1]	,/*lPixel*/, bCdCONTA )// Codigo da Conta
TRCell():New(oSection1,"CTARES"	,"cArqTmp",STR0027	,/*Picture*/,aTamCtaRes[1]	,/*lPixel*/, bCdCTRES )// Codigo Reduzido da Conta
TRCell():New(oSection1,"DESCCTA"	,"cArqTmp",STR0028	,/*Picture*/,nTamCta		,/*lPixel*/,/*{|| }*/ )// Descricao da Conta

TRPosition():New( oSection1, "CT1", 1, {|| xFilial("CT1") + cArqTMP->CONTA })

If lCNormal
	oSection1:Cell("CTARES"):Disable()
Else
	oSection1:Cell("CONTA"	):Disable() 
EndIf

If lPulaPag
	oSection1:SetPageBreak(.T.)
EndIf

oSection1:SetLineCondition({|| IIF(cArqTmp->TIPOCONTA == "1",.F.,.T.) })

// Sessao 2
oSection2 := TRSection():New(oSection1,cSayCusto,{"cArqTmp","CTT"},/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/)
oSection2:SetTotalInLine(.F.)
oSection2:SetColSpace(5)
oSection2:SetHeaderPage()

	TRCell():New(oSection2,"CUSTO"	,"cArqTmp",cSayCusto,/*Picture*/,aTamCC[1]+LEN(cMascara1)		,/*lPixel*/,bCdCUSTO)
	TRCell():New(oSection2,"CONTA"	,"cArqTmp",STR0026	,/*Picture*/,aTamConta[1]	,/*lPixel*/, bCdCONTA )// Codigo da Conta
	TRCell():New(oSection2,"CCRES"	,"cArqTmp",STR0027	,/*Picture*/,aTamCCRes[1]+LEN(cMascara1)	,/*lPixel*/,bCdCCRES)
	TRCell():New(oSection2,"DESCCC"	,"cArqTmp",STR0028	,/*Picture*/,nTamCC			,/*lPixel*/,/*{|| }*/)
	TRCell():New(oSection2,"SALDOANT","cArqTmp",STR0029 	,/*Picture*/,TAM_VALOR	,/*lPixel*/,{|| ValorCTB(cArqTmp->SALDOANT ,,,TAM_VALOR-2,nDecimais,.T.,cPicture,CTT->CTT_NORMAL,,,,,,lPrintZero,.F.)},"RIGHT",,"RIGHT")// Saldo Anterior
	TRCell():New(oSection2,"SALDODEB","cArqTmp",STR0030 	,/*Picture*/,TAM_VALOR	,/*lPixel*/,{|| ValorCTB(cArqTmp->SALDODEB ,,,TAM_VALOR,nDecimais,.F.,cPicture,CTT->CTT_NORMAL,,,,,,lPrintZero,.F.)},"RIGHT",,"RIGHT")// Debito
	TRCell():New(oSection2,"DEBS","cArqTmp","Tipo Deb "     	,/*Picture*/,TAM_VALOR	,/*lPixel*/,{|| RIGHT(ValorCTB(cArqTmp->SALDODEB ,,,TAM_VALOR,nDecimais,.T.,cPicture,If(CTT->CTT_NORMAL = "0",CT1->CT1_NORMAL,CTT->CTT_NORMAL),,,,,,lPrintZero,.F.),1)},"RIGHT",,"RIGHT")// Debito
	TRCell():New(oSection2,"SALDOCRD","cArqTmp",STR0031 	,/*Picture*/,TAM_VALOR	,/*lPixel*/,{|| ValorCTB(cArqTmp->SALDOCRD ,,,TAM_VALOR,nDecimais,.F.,cPicture,If(CTT->CTT_NORMAL = "0",CT1->CT1_NORMAL,CTT->CTT_NORMAL),,,,,,lPrintZero,.F.)},"RIGHT",,"RIGHT")// Credito
	TRCell():New(oSection2,"CRDS","cArqTmp","Tipo Cred"     	,/*Picture*/,TAM_VALOR	,/*lPixel*/,{|| RIGHT(ValorCTB(cArqTmp->SALDOCRD ,,,TAM_VALOR,nDecimais,.T.,cPicture,If(CTT->CTT_NORMAL = "0",CT1->CT1_NORMAL,CTT->CTT_NORMAL),,,,,,lPrintZero,.F.),1)},"RIGHT",,"RIGHT")// Credito    

	If lMov //Imprime Coluna Movimento!!
		TRCell():New(oSection2,"MOVIMENTO","cArqTmp",STR0032 ,/*Picture*/,TAM_VALOR	,/*lPixel*/,{|| ValorCTB(cArqTmp->MOVIMENTO,,,TAM_VALOR-2,nDecimais,.F.,cPicture,If(CTT->CTT_NORMAL = "0",CT1->CT1_NORMAL,CTT->CTT_NORMAL),,,,,,lPrintZero,.F.)},"RIGHT",,"RIGHT")// Movimento do Periodo
   		TRCell():New(oSection2,"MOVS","cArqTmp","Tipo Mov" ,/*Picture*/,TAM_VALOR	,/*lPixel*/,{|| RIGHT(ValorCTB(cArqTmp->MOVIMENTO,,,TAM_VALOR-2,nDecimais,.T.,cPicture,If(CTT->CTT_NORMAL = "0",CT1->CT1_NORMAL,CTT->CTT_NORMAL),,,,,,lPrintZero,.F.),1)},"RIGHT",,"RIGHT")// Movimento do Periodo

	EndIf

	TRCell():New(oSection2,"SALDOATU"	,"cArqTmp",STR0033 			,/*Picture*/,TAM_VALOR	,/*lPixel*/,{|| ValorCTB(cArqTmp->SALDOATU ,,,TAM_VALOR-2,nDecimais,.F.,cPicture,If(CTT->CTT_NORMAL = "0",CT1->CT1_NORMAL,CTT->CTT_NORMAL),,,,,,lPrintZero,.F.)},"RIGHT",,"RIGHT")// Saldo Atual
 	TRCell():New(oSection2,"TIPOCC"		,"cArqTmp",STR0034 	+" "+cSayCusto	,/*Picture*/,01			,/*lPixel*/,/*{|| }*/)// Centro Custo / Sintetica           
 	TRCell():New(oSection2,"TIPOCONTA"	,"cArqTmp",STR0034	+" "+STR0025	,/*Picture*/,01			,/*lPixel*/,/*{|| }*/)// Conta Analitica / Sintetica           
 	TRCell():New(oSection2,"NIVEL1"		,"cArqTmp",STR0035 					,/*Picture*/,01			,/*lPixel*/,/*{|| }*/)// Logico para identificar se 

// oSection2:SetNoFilter({'CTT'})

	TRPosition():New( oSection2, "CTT", 1, {|| xFilial("CTT") + cArqTMP->CUSTO })
	
	oSection2:Cell("TIPOCC" 	):Disable()
	oSection2:Cell("TIPOCONTA"	):Disable()
	oSection2:Cell("NIVEL1"  	):Disable()
	
	If lCCNormal                                                                          
		oSection2:Cell("CCRES"	):Disable()
	Else
		oSection2:Cell("CUSTO"	):Disable() 
	EndIf
	
	oSection2:OnPrintLine( {|| ( IIf( lPula .And. (cTipoAnt == "1" .Or. (cArqTmp->TIPOCC == "1" .And. cTipoAnt == "2")), oReport:SkipLine(),NIL),;
									 cTipoAnt := cArqTmp->TIPOCC;
								)  })
	
	oSection2:SetLineCondition({|| f145Fil(cSegAte,cSegmento,nDigitAte,cSegIni,cSegFim,cFiltSegm,nPos,nDigitos,cMascara1) })

// Totais das sessoes	
	oBreak:= TRBreak():New(oSection2,{ || cArqTmp->CONTA },STR0020,.F.)
	
 	oBreak:OnBreak({ || nTotdbt := oTRF1:GetValue(),nTotcrt := oTRF2:GetValue() })   

 	oTRF1 := TRFunction():New(oSection2:Cell("SALDODEB"),nil,"SUM",oBreak,/*Titulo*/,/*cPicture*/,{ || f145Soma("D",cSegAte) },.F.,.F.,.F.,oSection2)
 	oTRF1:disable()
 	 		 TRFunction():New(oSection2:Cell("SALDODEB"),nil,"ONPRINT",oBreak,/*Titulo*/,/*cPicture*/,{ || ValorCTB(nTotdbt,,,TAM_VALOR,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection2)
	
	oTRF2 := TRFunction():New(oSection2:Cell("SALDOCRD"),nil,"SUM",oBreak,/*Titulo*/,/*cPicture*/,{ || f145Soma("C",cSegAte) },.F.,.F.,.F.,oSection2)
	oTRF2:disable()
		 	 TRFunction():New(oSection2:Cell("SALDOCRD"),nil,"ONPRINT",oBreak,/*Titulo*/,/*cPicture*/,{ || ValorCTB(nTotcrt,,,TAM_VALOR,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection2)

  	If lMov
 	    TRFunction():New(oSection2:Cell("MOVIMENTO"),nil,"ONPRINT",oBreak,/*Titulo*/,/*cPicture*/,{ || ( (nTotMov := nTotCrt-nTotDbt),;
 		ValorCTB(nTotMov,,,TAM_VALOR-2,nDecimais,.T.,cPicture,CT1->CT1_NORMAL,,,,,,lPrintZero,.F.)  )},.F.,.F.,.F.,oSection2)
	EndIf


// Total geral

	oTRF3 := TRFunction():New(oSection2:Cell("SALDODEB"),nil,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,{ || f145Soma("D",cSegAte) },.F.,.F.,.F.,oSection2)
	oTRF3:disable()
			 TRFunction():New(oSection2:Cell("SALDODEB"),nil,"ONPRINT",/*oBreak*/,/*Titulo*/,/*cPicture*/,{ || ValorCTB(oTRF3:GetValue(),,,TAM_VALOR,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) },.F.,.T.,.F.,oSection2)

	oTRF4 := TRFunction():New(oSection2:Cell("SALDOCRD"),nil,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,{ || f145Soma("C",cSegAte) },.F.,.F.,.F.,oSection2)
	oTRF4:disable()
			 TRFunction():New(oSection2:Cell("SALDOCRD"),nil,"ONPRINT",/*oBreak*/,/*Titulo*/,/*cPicture*/,{ || ValorCTB(oTRF4:GetValue(),,,TAM_VALOR,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) },.F.,.T.,.F.,oSection2)

	
Return oReport

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportPrintº Autor ³ Cicero J. Silva    º Data ³  14/07/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Definicao do objeto do relatorio personalizavel e das      º±±
±±º          ³ secoes que serao utilizadas                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ReportPrint(oReport,aSetOfBook,cDescMoeda,cSayCusto,nDivide)

Local oSection1 	:= oReport:Section(1)
Local oSection2		:= oReport:Section(1):Section(1)

Local cArqTmp		:= ""
Local cFiltro	:= oSection1:GetAdvplExp('CT1')

Local dDataLP		:= mv_par27
Local dDataFim		:= mv_par02
Local cMascCC		:= IIF (Empty(aSetOfBook[6]),"",aSetOfBook[6])//Mascara do Centro de Custo
Local cMascCta		:= IIF (Empty(aSetOfBook[2]),GetMv("MV_MASCARA"),aSetOfBook[2])//Mascara da Conta
Local lImpSint		:= Iif(mv_par07==1 .Or. mv_par07 ==3,.T.,.F.)
Local lVlrZerado	:= Iif(mv_par09==1,.T.,.F.)
Local lImpMov		:= Iif(mv_par18==1,.T.,.F.)
Local lPrintZero	:= Iif(mv_par22==1,.T.,.F.)
Local lImpAntLP		:= Iif(mv_par26==1,.T.,.F.)
Local lCompEnt		:= Iif(mv_par28==1,.T.,.F.)
Local cSegmento		:= mv_par14
Local nDigitAte		:= 0
Local nPos			:= 0
Local nDigitos		:= 0
                        



	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega titulo do relatorio: Analitico / Sintetico			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF mv_par07 == 1
		Titulo:=	STR0007 + Upper(cSayCusto)	//"BALANCETE ANALITICO DE CONTA / "
	ElseIf mv_par07 == 2
		Titulo:=	STR0006 + Upper(cSayCusto)	//"BALANCETE SINTETICO DE CONTA / "
	ElseIf mv_par07 == 3
		Titulo:=	STR0008 + Upper(cSayCusto)	//"BALANCETE DE CONTA / "
	EndIf

	Titulo += 	STR0009 + DTOC(mv_par01) + STR0010 + Dtoc(mv_par02) + STR0011 + cDescMoeda
	
	If mv_par12 > "1"
		Titulo += " (" + Tabela("SL", mv_par12, .F.) + ")"
	EndIf
	
	If nDivide > 1			
		Titulo += " (" + STR0022 + Alltrim(Str(nDivide)) + ")"
	EndIf	
	
	oReport:SetPageNumber(mv_par11) //mv_par14	-	Pagina Inicial
	oReport:SetCustomText( {|| CtCGCCabTR(,,,,,dDataFim,titulo,,,,,oReport) } )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta Arquivo Temporario para Impressao						 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	 MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
			 CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
			  mv_par01,mv_par02,"CT3","",mv_par03,mv_par04,mv_par05,mv_par06,,,,,mv_par10,;
			   mv_par12,aSetOfBook,mv_par14,mv_par15,mv_par16,mv_par17, !lImpMov,.T.,,"CT1",;
				lImpAntLP,dDataLP, nDivide,lVlrZerado,,,,,,,,,,,,,lImpMov,lImpSint,cFiltro,,,,,,,,,,,,aSelFil,,,,lCompEnt,,,,,lTodasFil)},;
				 (STR0014),;  //"Criando Arquivo Tempor rio..."
				   STR0003+cSayCusto)    //"Balancete Verificacao Conta /"

	If !Empty(cSegmento)
		dbSelectArea("CTM")
		dbSetOrder(1)
		If MsSeek(xFilial()+cMascCC)  
			While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == cMascCC
				nPos += Val(CTM->CTM_DIGITO)
				If CTM->CTM_SEGMEN == cSegmento
					nPos -= Val(CTM->CTM_DIGITO)
					nPos ++
					nDigitos := Val(CTM->CTM_DIGITO)      
					Exit
				EndIf	
				dbSkip()
			EndDo	
		EndIf	
	EndIf	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicia a impressao do relatorio                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("cArqTmp")
	dbGotop()
	//Se tiver parametrizado com Plano Gerencial, exibe a mensagem que o Plano Gerencial 
	//nao esta disponivel e sai da rotina.
	If !( RecCount() == 0 .And. !Empty(aSetOfBook[5]) )
		
		oSection2:SetParentFilter( { |cParam| cArqTmp->CONTA == cParam },{ || cArqTmp->CONTA })// SERVE PARA IMPRIMIR O TITULO DA SECAO PAI

		oSection1:Print()
		
	EndIf
	
dbSelectArea("cArqTmp")
Set Filter To
dbCloseArea()
If Select("cArqTmp") == 0
//	Ferase(cArqTmp+GetDBExtension())
//	FErase("cArqInd"+OrdBagExt())
EndIf	
dbselectArea("CT2")


Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³f145Soma  ºAutor  ³Cicero J. Silva     º Data ³  24/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBR145                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function f145Soma(cTipo,cSegAte)
Local nRetValor		:= 0
Local tpCCusto       := "" 
                 
If Empty(cArqTmp->TIPOCC)
	tpCCusto := cArqTmp->TIPOCONTA
Else
	tpCCusto := cArqTmp->TIPOCC
Endif

	If mv_par07 != 1					// Imprime Analiticas ou Ambas
	 	If tpCCusto == "2"		
			If cArqTmp->TIPOCONTA== "2" 
				If cTipo == "D"
					nRetValor := cArqTmp->SALDODEB
				ElseIf cTipo == "C"
					nRetValor := cArqTmp->SALDOCRD
				EndIf
			EndIf	
			If cTipo == "D"
				nRetValor := cArqTmp->SALDODEB
			ElseIf cTipo == "C"
				nRetValor := cArqTmp->SALDOCRD
			EndIf
		Endif
	Else
		If tpCCusto == "1" .And. cArqTmp->NIVEL1    		
			If cTipo == "D"
				nRetValor := cArqTmp->SALDODEB
			ElseIf cTipo == "C"
				nRetValor := cArqTmp->SALDOCRD
			EndIf
		Endif
		If tpCCusto == "1" .And. Empty(cArqTmp->CCSUP)
			If cTipo == "D"
				nRetValor := cArqTmp->SALDODEB
			ElseIf cTipo == "C"
				nRetValor := cArqTmp->SALDOCRD
			EndIf
		Endif
	Endif	
	
Return nRetValor                                                                         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³f145Fil   ºAutor  ³Cicero J. Silva     º Data ³  24/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBR145                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function f145Fil(cSegAte,cSegmento,nDigitAte,cSegIni,cSegFim,cFiltSegm,nPos,nDigitos,cMascara1)

Local lDeixa	:= .T.
Local nCont    := 0

Default cMascara1 := ""

	If mv_par07 == 1					// So imprime Sinteticas
		If cArqTmp->TIPOCC == "2"
			lDeixa := .F.
		EndIf
	ElseIf mv_par07 == 2				// So imprime Analiticas
		If cArqTmp->TIPOCC == "1"
			lDeixa := .F.
		EndIf
	EndIf

	// Verifica Se existe filtragem Ate o Segmento
	If !Empty(cSegAte)
		For nCont := 1 to Val(cSegAte)
			nDigitAte += Val(Subs(cMascara1,nCont,1))	
		Next
	EndIf		

	If !Empty(cSegmento)
		If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
			If  !(Substr(cArqTmp->CUSTO,nPos,nDigitos) $ (Alltrim(cFiltSegm)) ) 
				lDeixa := .F.
			EndIf	
		Else
			If Substr(cArqTmp->CUSTO,nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
				Substr(cArqTmp->CUSTO,nPos,nDigitos) > Alltrim(cSegFim)
				lDeixa := .F.
			EndIf	
		Endif
	EndIf	
	
	//Filtragem ate o Segmento do centro de custo(antigo nivel do SIGACON)		
	If !Empty(cSegAte)
		If Len(Alltrim(CUSTO)) > nDigitAte
			lDeixa := .F.
		Endif
	EndIf

dbSelectArea("cArqTmp")

Return (lDeixa)

/*

------------------------------------------------------- RELESE 4 ---------------------------------------------------------------

*/

#DEFINE 	COL_SEPARA1			1
#DEFINE 	COL_CUSTO  			2
#DEFINE 	COL_SEPARA2			3
#DEFINE 	COL_DESCRICAO		4
#DEFINE 	COL_SEPARA3			5
#DEFINE 	COL_SALDO_ANT     	6
#DEFINE 	COL_SEPARA4			7
#DEFINE 	COL_VLR_DEBITO    	8
#DEFINE 	COL_SEPARA5			9 
#DEFINE 	COL_VLR_CREDITO   	10
#DEFINE 	COL_SEPARA6			11
#DEFINE 	COL_MOVIMENTO 		12
#DEFINE 	COL_SEPARA7			13                                                                                       
#DEFINE 	COL_SALDO_ATU 		14
#DEFINE 	COL_SEPARA8			15

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ Ctbr145R3³ Autor ³ Simone Mie Sato   	³ Data ³ 16.08.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balancete Conta/C.Custo                 			 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Ctbr145      											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso    	 ³ SIGACTB      											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
static Function Ctbr145R3()

Local aSetOfBook
Local aCtbMoeda		:= {}
Local cSayCusto		:= CtbSayApro("CTT")
LOCAL cDesc1 		:= STR0001+ Upper(cSayCusto)	//"Este programa ira imprimir o Balancete de Conta / "
LOCAL cDesc2 		:= STR0002				  //"de acordo com os parametros solicitados pelo Usuario"
Local cNomeArq
LOCAL wnrel
LOCAL cString		:= "CT1"
Local titulo 		:= STR0003+ Upper(cSayCusto) 	//"Balancete de Verificacao Conta / "
Local lRet			:= .T.
Local nDivide		:= 1
Local aPergs 		:= {}

PRIVATE nLastKey 	:= 0
PRIVATE cPerg	 	:= "CTR145"
PRIVATE aReturn 	:= { STR0015, 1,STR0016, 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE aLinha		:= {}
PRIVATE nomeProg  	:= "CTBR145"
PRIVATE Tamanho		:="M"

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

li 		:= 80
m_pag	:= 1

Pergunte("CTR145",.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros					  	   	³
//³ mv_par01				// Data Inicial              	       	³
//³ mv_par02				// Data Final                          	³
//³ mv_par03				// Conta Inicial                       	³
//³ mv_par04				// Conta Final  					   	³
//³ mv_par05				// C.Custo Inicial                     	³
//³ mv_par06				// C.Custo Final					   	³
//³ mv_par07				// Imprime C.Custo:  Sintet/Analit/Ambas³
//³ mv_par08				// Set Of Books				    	   	³
//³ mv_par09				// Saldos Zerados?			     	   	³
//³ mv_par10				// Moeda?          			     	   	³
//³ mv_par11				// Pagina Inicial  		     		   	³
//³ mv_par12				// Saldos? Reais / Orcados	/Gerenciais	³
//³ mv_par13				// Imprimir ate o Segmento?			  	³
//³ mv_par14				// Filtra Segmento?					   	³
//³ mv_par15				// Conteudo Inicial Segmento?		   	³
//³ mv_par16				// Conteudo Final Segmento?		       	³
//³ mv_par17				// Conteudo Contido em?				   	³
//³ mv_par18				// Imprime Movimento do Mes            	³
//³ mv_par19				// Imprime Totalizacao de Contas Sontet.³
//³ mv_par20				// Pula Pagina                         	³

//³ mv_par21				// Salta linha sintetica ?			    ³
//³ mv_par22				// Imprime valor 0.00    ?			    ³
//³ mv_par23				// Imprimir Codigo? Normal / Reduzido  	³
//³ mv_par24				// Divide por ?                   		³
                                                                     
//³ mv_par25				// Imprime Cod. Conta ? Normal/Reduzido ³
//³ mv_par26				// Posicao Ant. L/P? Sim / Nao         	³
//³ mv_par27 				// Data Lucros/Perdas?                	³
//³ mv_par28 				// Imp. Conta S/ Custo?                	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lRet .And. mv_par29 == 1 .And. Len( aSelFil ) <= 0
	aSelFil := AdmGetFil(@lTodasFil)
	If Len( aSelFil ) <= 0
		Return
	EndIf
EndIf  

wnrel	:= "CTBR145"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,,@titulo,cDesc1,cDesc2,,.F.,"",,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !ct040Valid(mv_par08)
	lRet := .F.
Else
   aSetOfBook := CTBSetOf(mv_par08)
Endif

If mv_par24 == 2			// Divide por cem
	nDivide := 100
ElseIf mv_par24 == 3		// Divide por mil
	nDivide := 1000
ElseIf mv_par24 == 4		// Divide por milhao
	nDivide := 1000000
EndIf	

If lRet
	aCtbMoeda  	:= CtbMoeda(mv_par10)
	If Empty(aCtbMoeda[1])                       
      Help(" ",1,"NOMOEDA")
      lRet := .F.
   Endif
Endif


If !lRet
	Set Filter To
	Return
EndIf

If mv_par19 == 1			// Se imprime coluna movimento -> relatorio 220 colunas
	tamanho := "G"
EndIf

SetDefault(aReturn,cString,,,Tamanho,If(Tamanho="G",2,1))	

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| CTR145Imp(@lEnd,wnRel,cString,aSetOfBook,aCtbMoeda,cSayCusto,nDivide)})

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CTR145IMP ³ Autor ³ Simone Mie Sato       ³ Data ³ 16.08.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime relatorio -> Balancete Conta/C.Custo               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctr145Imp(lEnd,Wnrel,cString,aSetOfBook,aCtbMoeda,cSayCusto ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Sigactb                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd       - A‡ao do Codeblock                             ³±±
±±³          ³ wnRel      - Nome do Relatorio                             ³±±
±±³          ³ cString    - Mensagem                                      ³±±
±±³          ³ aSetOfBook - Array de configuracao set of book             ³±±
±±³          ³ aCtbMoeda  - Moeda                                         ³±±
±±³          ³ cSayCusto  - Descricao do c.c. utilizado pelo usuario.     ³±±
±±³          ³ nDivide    - Fator de divisao de valores                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CTR145Imp(lEnd,WnRel,cString,aSetOfBook,aCtbMoeda,cSayCusto,nDivide)

LOCAL CbTxt			:= Space(10)
Local CbCont		:= 0
LOCAL tamanho		:= "M"
LOCAL limite		:= 132
Local cabec1  		:= ""
Local cabec2		:= ""

Local aColunas

Local cSepara1		:= ""
Local cSepara2		:= ""
Local cPicture
Local cDescMoeda
Local cMascara1
Local cMascara2
Local cContaAnt 	:= ""
Local cCtaAntRes	:= ""
Local cSegAte   	:= mv_par13
Local cArqTmp		:= ""
Local cSegmento		:= mv_par14
Local cSegIni		:= mv_par15
Local cSegFim		:= mv_par16
Local cFiltSegm		:= mv_par17
Local cMascCta		:= ""
Local cMascCC  		:= ""

Local dDataLP		:= mv_par27
Local dDataFim		:= mv_par02

Local lFirstPage	:= .T.
Local lPula			:= Iif(mv_par21==1,.T.,.F.)
Local lJaPulou		:= .F.
Local l132			:= .T.
Local lImpAntLP		:= Iif(mv_par26==1,.T.,.F.)
Local lCompEnt		:= Iif(mv_par28==1,.T.,.F.)
Local lVlrZerado	:= Iif(mv_par09==1,.T.,.F.)
Local lPrintZero	:= Iif(mv_par22==1,.T.,.F.)
Local lCCNormal	:= Iif(mv_par23==1,.T.,.F.)
Local lContaNormal	:= Iif(mv_par25==1,.T.,.F.)
Local lSaltaPag		:= Iif(mv_par20==1,.T.,.F.)
Local lImpMov		:= Iif(mv_par18==1,.T.,.F.)
Local lImpSint		:= Iif(mv_par07=1 .Or. mv_par07 ==3,.T.,.F.)

Local nDecimais
Local nTotDeb		:= 0
Local nTotCrd		:= 0
Local nTotMov		:= 0
Local nTamCusto		:= Len(CriaVar("CTT_CUSTO"))
Local nTamCta		:= Len(CriaVar("CT1_CONTA"))
Local nTotCtDeb		:= 0
Local nTotCtCrd		:= 0
Local nPosAte		:= 0
Local nDigitAte		:= 0
Local nDigGrAte		:= 0
Local nPos			:= 0
Local nDigitos		:= 0
Local nCont			:= 0
Local nCNormal 		
Local tpCCusto 		:= ""

cDescMoeda 	:= aCtbMoeda[2]
nDecimais 	:= DecimalCTB(aSetOfBook,mv_par10)


// Mascara do Centro de custo
If Empty(aSetOfBook[6])
	cMascara1 := GetMv("MV_MASCCUS")
Else                                                
	cMascCC   := aSetOfBook[6]
	cMascara1 := RetMasCtb(aSetOfBook[6],@cSepara1)
EndIf

//Mascara da Conta
If Empty(aSetOfBook[2])
	cMascara2 := GetMv("MV_MASCARA")
Else
	cMascCta	:= aSetOfBook[2]
	cMascara2 	:= RetMasCtb(aSetOfBook[2],@cSepara2)
EndIf

//Soma a mascara do custo ao tamanho do campo
If Len( cMascara1 ) > 0
	nTamCusto += Len( cMascara1 ) - 1
EndIf
//Soma a mascara da conta ao tamanho do campo
If Len( cMascara2 ) > 0
	nTamCta += Len( cMascara1 ) - 1
EndIf

cPicture 		:= aSetOfBook[4]

If mv_par18 == 1 // Se imprime saldo movimento do periodo
	cabec1 := Iif(cPaisLoc<>"MEX",STR0004,STR0023)  //"|  CODIGO              |   D  E  S  C  R  I  C  A  O    |   SALDO ANTERIOR  |    DEBITO     |    CREDITO   | MOVIMENTO DO PERIODO |   SALDO ATUAL    |"
	tamanho := "G"
	limite	:= 220        
	l132	:= .F.
Else	
	cabec1 := Iif(cPaisLoc<>"MEX",STR0005,STR0024)  //"|  CODIGO               |   D  E  S  C  R  I  C  A  O    |   SALDO ANTERIOR  |      DEBITO    |      CREDITO   |   SALDO ATUAL     |"
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega titulo do relatorio: Analitico / Sintetico			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF mv_par07 == 1
	Titulo:=	STR0007 + Upper(cSayCusto)	//"BALANCETE ANALITICO DE CONTA / "
ElseIf mv_par07 == 2
	Titulo:=	STR0006 + Upper(cSayCusto)	//"BALANCETE SINTETICO DE CONTA / "
ElseIf mv_par07 == 3
	Titulo:=	STR0008 + Upper(cSayCusto)	//"BALANCETE DE CONTA / "
EndIf

Titulo += 	STR0009 + DTOC(mv_par01) + STR0010 + Dtoc(mv_par02) + STR0011 + cDescMoeda

If mv_par12 > "1"
	Titulo += " (" + Tabela("SL", mv_par12, .F.) + ")"
EndIf

If nDivide > 1			
	Titulo += " (" + STR0022 + Alltrim(Str(nDivide)) + ")"
EndIf	

If l132
	aColunas := { 000,001, 024, 025, 057,058, 077, 078, 094, 095, 111, , , 112, 131 }
Else
	aColunas := { 000,001, 030, 032, 080,082, 112, 114, 131, 133, 151, 153, 183,185,219}
Endif

m_pag := mv_par11
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Arquivo Temporario para Impressao							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
				CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
				mv_par01,mv_par02,"CT3","",mv_par03,mv_par04,mv_par05,mv_par06,,,,,mv_par10,;
				mv_par12,aSetOfBook,mv_par14,mv_par15,mv_par16,mv_par17, l132,.T.,,"CT1",;
				lImpAntLP,dDataLP, nDivide,lVlrZerado,,,,,,,,,,,,,lImpMov,lImpSint,aReturn[7],,,,,,,,,,,,aSelFil,,,,lCompEnt,,,,,lTodasFil)},;
				(STR0014),;  //"Criando Arquivo Tempor rio..."
				STR0003+cSayCusto)    //"Balancete Verificacao Conta /"

// Verifica Se existe filtragem Ate o Segmento
If !Empty(cSegAte)
	For nCont := 1 to Val(cSegAte)
		nDigitAte += Val(Subs(cMascara1,nCont,1))	
	Next
EndIf		

dbSelectArea("cArqTmp")
dbSetOrder(1)
dbGoTop()        

//Se tiver parametrizado com Plano Gerencial, exibe a mensagem que o Plano Gerencial 
//nao esta disponivel e sai da rotina.
If RecCount() == 0 .And. !Empty(aSetOfBook[5])                                       
	dbCloseArea()
	Ferase(cArqTmp+GetDBExtension())
	Ferase("cArqInd"+OrdBagExt())
	Return
Endif

SetRegua(RecCount())

If !Empty(cSegmento)
	dbSelectArea("CTM")
	dbSetOrder(1)
	If MsSeek(xFilial()+cMascCC)  
		While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == cMascCC
			nPos += Val(CTM->CTM_DIGITO)
			If CTM->CTM_SEGMEN == cSegmento
				nPos -= Val(CTM->CTM_DIGITO)
				nPos ++
				nDigitos := Val(CTM->CTM_DIGITO)      
				Exit
			EndIf	
			dbSkip()
		EndDo	
	EndIf	
EndIf	

dbSelectArea("cArqTmp")

While !Eof()

	If lEnd
		@Prow()+1,0 PSAY STR0017   //"***** CANCELADO PELO OPERADOR *****"
		Exit
	EndIF

	IncRegua()

	******************** "FILTRAGEM" PARA IMPRESSAO *************************

	If mv_par07 == 1					// So imprime Itens Sinteticos
		If TIPOCC == "2"
			dbSkip()
			Loop
		EndIf
	ElseIf mv_par07 == 2				// So imprime Itens Analiticos
		If TIPOCC == "1"
			dbSkip()
			Loop
		EndIf
	EndIf
	
	If !Empty(cSegmento)
		If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
			If  !(Substr(cArqTmp->CUSTO,nPos,nDigitos) $ (Alltrim(cFiltSegm)) ) 
				dbSkip()
				Loop
			EndIf	
		Else
			If Substr(cArqTmp->CUSTO,nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
				Substr(cArqTmp->CUSTO,nPos,nDigitos) > Alltrim(cSegFim)
				dbSkip()
				Loop
			EndIf	
		Endif
	EndIf	
	
	//Filtragem ate o Segmento do centro de custo(antigo nivel do SIGACON)		
	If !Empty(cSegAte)
		If Len(Alltrim(CUSTO)) > nDigitAte
			dbSkip()
			Loop
		Endif
	EndIf

	************************* ROTINA DE IMPRESSAO *************************
		
	cContaAnt	:= cArqTmp->CONTA
	cCtaAntRes 	:= cArqTmp->CTARES

	If li > 58 .Or. lFirstPage .Or. lSaltaPag
		If !lFirstPage
			@Prow()+1,00 PSAY	Replicate("-",limite)
		EndIf
		CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
		lFirstPage := .F.
	EndIf	
	
	@ li,000 PSAY REPLICATE("-",limite)
	li++
	@ li,000 PSAY "|"                                
	@ li,001 PSAY Upper(STR0021) + " : "
	If lContaNormal .or. TIPOCONTA == "1"
		EntidadeCTB(CONTA,li,12,nTamCta+Len(cSepara2),.F.,cMascara2,cSepara2)					
	Else
		EntidadeCTB(CTARES,li,12,nTamCta+Len(cSepara2),.F.,cMascara2,cSepara2)		
	Endif			
//	@ li,aColunas[COL_CUSTO]+ Len(CriaVar("CT1_DESC01")) PSAY " - " +cArqTMP->DESCCTA
	@ li,55 PSAY " - " +cArqTMP->DESCCTA
	@ li,131 PSAY "|"		                                        
	li++
	@ li,000 PSAY REPLICATE("-",limite)		
	li+=1		                                                    			
   
	While !Eof() .And. cContaAnt == cArqTmp->CONTA
	
		If mv_par07 == 1					// So imprime Itens Sinteticos
			If TIPOCC == "2"
				dbSkip()
				Loop
			EndIf
		ElseIf mv_par07 == 2				// So imprime Itens Analiticos
			If TIPOCC == "1"
				dbSkip()
				Loop
			EndIf
		EndIf	
		
		//Filtragem ate o Segmento do Centro de Custo( antigo nivel do SIGACON)		
		If !Empty(cSegAte)
			If Len(Alltrim(CUSTO)) > nDigitAte
				dbSkip()
				Loop
			Endif
		EndIf		
		
		If !Empty(cSegmento)
			If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
				If  !(Substr(cArqTmp->CUSTO,nPos,nDigitos) $ (Alltrim(cFiltSegm)) ) 
					dbSkip()
					Loop
				EndIf	
			Else
				If Substr(cArqTmp->CUSTO,nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
					Substr(cArqTmp->CUSTO,nPos,nDigitos) > Alltrim(cSegFim)
					dbSkip()
					Loop
				EndIf	
			Endif
		EndIf			

		@ li,aColunas[COL_SEPARA1] PSAY "|"
		If lCCNormal .or. TIPOCC == "1"
			EntidadeCTB(CUSTO,li,aColunas[COL_CUSTO],20,.F.,cMascara1,cSepara1)
		Else	
			EntidadeCTB(CCRES,li,aColunas[COL_CUSTO],20,.F.,cMascara1,cSepara1)
		EndIf	       
		
		dbSelectArea("CTT")
		dbSetOrder(1) 
		MsSeek(xFilial("CTT")+cArqTmp->CUSTO)  //Busca a situacao do Centro de Custo			

		If CTT->CTT_NORMAL = "0"   
			nCNormal = CT1->CT1_NORMAL			
		Else
			nCNormal = CTT->CTT_NORMAL			
		Endif			
			
		dbSelectArea("cArqTmp")    
		
		@ li,aColunas[COL_SEPARA2] PSAY "|"
		@ li,aColunas[COL_DESCRICAO] PSAY Substr(DESCCC,1,31)
		@ li,aColunas[COL_SEPARA3] PSAY "|"
		ValorCTB(SALDOANT,li,aColunas[COL_SALDO_ANT],17,nDecimais,.T.,cPicture,nCNormal, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA4] PSAY "|"
		ValorCTB(SALDODEB,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,NORMAL, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA5] PSAY "|"
		ValorCTB(SALDOCRD,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,NORMAL, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA6] PSAY "|"
		If !l132        
			ValorCTB(MOVIMENTO,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,nCNormal, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA7] PSAY "|"	   
		Endif
		ValorCTB(SALDOATU,li,aColunas[COL_SALDO_ATU],17,nDecimais,.T.,cPicture,nCNormal, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA8] PSAY "|"
		
		lJaPulou := .F.
		If lPula .And. TIPOCC == "1"				// Pula linha entre sinteticas
			li++
			@ li,aColunas[COL_SEPARA1] PSAY "|"
			@ li,aColunas[COL_SEPARA2] PSAY "|"
			@ li,aColunas[COL_SEPARA3] PSAY "|"	
			@ li,aColunas[COL_SEPARA4] PSAY "|"
			@ li,aColunas[COL_SEPARA5] PSAY "|"
			@ li,aColunas[COL_SEPARA6] PSAY "|"
			If !l132  
				@ li,aColunas[COL_SEPARA7] PSAY "|"
				@ li,aColunas[COL_SEPARA8] PSAY "|"
			Else
				@ li,aColunas[COL_SEPARA8] PSAY "|"
			EndIf	
			li++
			lJaPulou := .T.
		Else
			li++
		EndIf		
		
		If Empty(TIPOCC)
			tpCCusto := TIPOCONTA
		Else
			tpCCusto := TIPOCC
		Endif		

		// Soma dos totalizadores
		If mv_par07 != 1					// Imprime Analiticas ou Ambas
			If tpCCusto == "2"
				If TIPOCONTA== "2"
					nTotDeb 		+= SALDODEB 
					nTotCrd    		+= SALDOCRD
				EndIf	
				nTotCtDeb 		+= SALDODEB
				nTotCtCrd 		+= SALDOCRD				
			Endif
		Else
			If tpCCusto == "1" .And. NIVEL1
				nTotDeb += SALDODEB
				nTotCrd += SALDOCRD
			Endif
			If tpCCusto == "1" .And. Empty(CCSUP)
				nTotCtDeb += SALDODEB
				nTotCtCrd += SALDOCRD				
			Endif
		Endif	
	
		dbSkip()  
		
		If lPula .And. TIPOCC == "1" 			// Pula linha entre sinteticas
			If !lJaPulou
				@ li,aColunas[COL_SEPARA1] PSAY "|"
				@ li,aColunas[COL_SEPARA2] PSAY "|"
				@ li,aColunas[COL_SEPARA3] PSAY "|"	
				@ li,aColunas[COL_SEPARA4] PSAY "|"
				@ li,aColunas[COL_SEPARA5] PSAY "|"
				@ li,aColunas[COL_SEPARA6] PSAY "|"
				If !l132  
					@ li,aColunas[COL_SEPARA7] PSAY "|"
					@ li,aColunas[COL_SEPARA8] PSAY "|"
				Else
					@ li,aColunas[COL_SEPARA8] PSAY "|"
				EndIf	
				li++
			EndIf	
		EndIf
		
		If li > 58 
			If !lFirstPage
				@Prow()+1,00 PSAY	Replicate("-",limite)
			EndIf		
			CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
			lFirstPage := .F.
		EndIf	
		
    EndDo
    
	// Impressao do Totalizador da Conta
	@li,00 PSAY	Replicate("-",limite)
	li++
	@li,0 PSAY "|"          			
	@li,01 PSAY STR0020//"T O T A I S  D A  C O N T A:  "
	If lContaNormal	.or.TIPOCONTA == "1"   // Codigo Normal da Conta ou sintetica
		EntidadeCTB(cContaAnt,li,40,nTamCta+Len(cSepara2),.F.,cMascara2,cSepara2)		
	Else
		EntidadeCTB(cCtaAntRes,li,40,nTamCta+Len(cSepara2),.F.,cMascara2,cSepara2)
	EndIf
	@ li,aColunas[COL_SEPARA4] PSAY "|"
	ValorCTB(nTotCtDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA5] PSAY "|"
	ValorCTB(nTotCtCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)			
	@ li,aColunas[COL_SEPARA6] PSAY "|"

	dbSelectArea("CT1")
	dbSetOrder(1) 
	MsSeek(xFilial("CT1")+cContaAnt)  //Busca a situacao da Conta Contabil			
	dbSelectArea("cArqTmp")    

	If !l132
		nTotMov := (nTotCtCrd - nTotCtDeb)
		ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,CT1->CT1_NORMAL, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA7] PSAY "|"	
	Endif

	@ li,aColunas[COL_SEPARA8] PSAY "|"
	nTotCtDeb := 0
	nTotCtCrd := 0                     
	li++
	
	If li > 58  	
		If !lFirstPage
			@Prow()+1,00 PSAY	Replicate("-",limite)
		EndIf
		CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
		lFirstPage := .F.
	EndIf	
	
EndDO

IF li != 80 .And. !lEnd
	li++
	@li,00 PSAY REPLICATE("-",limite)
	li++
	@li,0 PSAY "|"          			
	@li, 10 PSAY STR0018  		//"T O T A I S  D O  P E R I O D O : "
	@ li,aColunas[COL_SEPARA4] PSAY "|"	
	ValorCTB(nTotDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA5] PSAY "|"
	ValorCTB(nTotCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA6] PSAY "|"
	@ li,aColunas[COL_SEPARA8] PSAY "|"
	li++
	@li,00 PSAY REPLICATE("-",limite)
	li++
	@li,0 PSAY " "
	If !lExterno
		roda(cbcont,cbtxt,"M")
		Set Filter To
	EndIf		
EndIF

If aReturn[5] = 1
	Set Printer To
	Commit
	Ourspool(wnrel)
EndIf

dbSelectArea("cArqTmp")
Set Filter To
dbCloseArea()
Ferase(cArqTmp+GetDBExtension())
FErase("cArqInd"+OrdBagExt())

dbselectArea("CT2")

MS_FLUSH()

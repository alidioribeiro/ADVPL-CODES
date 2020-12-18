#INCLUDE "SPEDPISCOF.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
// *************** V11  ***************
STATIC nTamTRBIt	:=	50	//Tamanho do campo relac no TRB
STATIC cCSTCRED		:=  "50/51/52/53/54/55/56/60/61/62/63/64/65/66" //CSTs de PIS e Cofins que do direito a cr©dito na apurao do bloco M
STATIC aIndics		// ARRAY COM ALIAS INDIC
STATIC aFieldPos
STATIC aParSX6
STATIC aExstBlck	// ARRAY COM EXISTBLOCK


User Function xSPEDPISCOF( cEmp, cFil , aWizJob , aFilJob)
Local	lEnd		:=	.F.
Local	aWizard		:=	{}
Local	cFileDest	:=	"SPEDPISCOF.TXT" 
Local	cNomWiz		:=	""
Local	cNomeAnt	:=	""
Local   lGerou		:= .F.
Local	lJob		:= .F.
local 	nyy 		:=	1
Local nRemType := GetRemoteType() 
Local cFunction := "CpyS2TW"

Private cVersao     :=	""
Private lCancel		:=	.F.

DEFAULT cEmp		:=	Nil
DEFAULT cFil		:=	Nil
DEFAULT aWizJob		:= {}
DEFAULT aFilJob		:= {}

//Quando for chamado via JOB, as informacoes do WIZARD serao passadas como parametro na funcao
If (lJob := Len(aWizJob) > 0)
	//Caso nao seja passado a empresa/filial, assumo que o SetEnv jah foi dado antes da chamada da funcao
	If cEmp<>Nil .And. cFil<>Nil
		RpcSetType( 3 )
		RpcSetEnv( cEmp , cFil )
	EndIf
	PtInternal(1,"SPED PIS/Cofins (Execucao Autom¡tica) - Emp: "+cEmpAnt+" - Filial: "+cFilAnt)
	aWizard	:=	aWizJob
	MsgJobSPC( "INICIO: Inicio do processamento!" )
EndIf

SpdCLCache() // CARREGA CACHE DE INFORMACOES
cNomWiz :=	"SPEDPISCOF" + FWGrpCompany() + FWGETCODFILIAL
cNomeAnt :=	Iif(File(cNomWiz+".cfp"),"","SPEDPISCOF" + FWGETCODFILIAL)

If !lJob .And. !( SpedMntWiz( cNomWiz , ,cNomeAnt , "PISCOF" ) )
	MsgJobSPC( "WIZARD: Problema ao abrir o Wizard!" )
	Return .F.
EndIf

// Se for execucao via SMARTCLIENT HTML.
If !lJob .And. nRemType == 5
	MsgAlert(STR0108 +Chr(13)+Chr(10)+ STR0109,"")
EndIf

Processa({|lEnd| PrSpedPC(@lEnd, aWizard, @cFileDest,@lGerou,lJob,aFilJob)},,,.T.)

If !lJob
	If lGerou == .F.
		If lCancel
			ApMsgStop(OemToAnsi(STR0073)) // "Cancelado pelo usu¡rio!"
		Else
			MsgAlert(OemToAnsi(STR0003),"") //"No foi poss­vel gerar o arquivo!"
		EndIf
	ElseIf File(cFileDest)
		MsgInfo(OemToAnsi(STR0001 + cFileDest + STR0002),"") //"Arquivo "###" gerado com sucesso!"

		// SmartClient HTML - Copiar o arquivo do servidor p/ a pasta de downloads do navegador.
		If nRemType == 5 .And. FindFunction(cFunction)
			&(cFunction+'("'+cFileDest+'")')
		EndIf

	Else
		MsgAlert(OemToAnsi(STR0003),"") //"No foi poss­vel gerar o arquivo!"
	EndIf
Else
	If !lGerou
		If lCancel
			MsgJobSPC( "FINAL: " + OemToAnsi( STR0073 ) )  // "Cancelado pelo usu¡rio!"
		Else
			MsgJobSPC( "FINAL: " + OemToAnsi( STR0003 ) ) //"No foi poss­vel gerar o arquivo!"
		EndIf
	ElseIf File(cFileDest)
		MsgJobSPC( "FINAL: " + OemToAnsi( STR0001 + cFileDest + STR0002 ) ) //"Arquivo "###" gerado com sucesso!"
	Else
		MsgJobSPC( "FINAL: " + OemToAnsi( STR0003 ) ) //"No foi poss­vel gerar o arquivo!"
	EndIf
EndIf
Return .T.

/*
±±Programa   PrSpedPC  Autor  Erick G. Dias          Data 06/01/2011±±
*/
Static Function PrSpedPC(lEnd,aWizard,cFileDest,lGerou,lJob,aFilJob)


Local	aReg0111		:=  {}
Local	aReg0140		:=	{}
Local	aReg0145		:=	{}
Local	aReg0150		:=	{}
Local	aReg0190		:=	{}
Local	aReg0197		:=	{}
Local	aReg0200		:=	{}
Local	aReg0205		:=	{}
Local	aReg0206		:=	{}
Local	aReg0220		:=	{}
Local	aReg0400		:=	{}
Local	aReg0450		:=	{}
Local	aReg0500		:=	{}
Local	aReg0600		:=	{}
Local	aRegA010		:=	{}
Local	aRegA100		:=	{}
Local	aRegA110		:=	{}
Local	aRegA111		:=	{}
Local	aRegA120		:=	{}
Local	aRegA170		:=	{}
Local	aRegC010		:=	{}
Local	aRegC100		:=	{}
Local	aRegC110		:=	{}
Local	aRegC111		:=	{}
Local	aRegC170		:=	{}
Local	aRegC175		:=	{}
Local	aRegC180		:=	{}
Local	aRegC181		:=	{}
Local	aRegC185		:=	{}
Local	aRegC188		:=	{}
Local	aRegC190		:=	{}
Local	aRegC191		:=	{}
Local	aRegC195		:=	{}
Local	aRegC198		:=	{}
Local	aRegC199		:=	{}
Local   aRegC380		:=  {}
Local   aRegC381		:=  {}
Local   aRegC385		:=  {}
Local   aRegC395		:=  {}
Local   aRegC396		:=  {}
Local   aRegC500		:=  {}
Local   aRegC501		:=  {}
Local   aRegC505		:=  {}
Local   aRegC509		:=  {}
Local   aRegC600		:=  {}
Local   aRegC601		:=  {}
Local   aRegC605		:=  {}
Local   aRegC609		:=  {}
Local   aRegC400		:=  {}
Local   aRegC405		:=  {}
Local   aRegC481		:=  {}
Local   aRegC485		:=  {}
Local   aRegC489        :=  {}
Local   aRegC490		:=  {}
Local   aRegC491		:=  {}
Local   aRegC495		:=  {}
Local   aRegC499        :=  {}
Local	aRegD010		:=	{}
Local	aRegD100		:=	{}
Local	aRegD101		:=	{}
Local	aRegD105		:=	{}
Local	aRegD111		:=	{}
Local	aRegD200		:=	{}
Local	aRegD201		:=	{}
Local	aRegD205		:=	{}
Local	aRegD209		:=	{}
Local	aRegD300		:=	{}
Local 	aRegD350 		:= 	{}
Local 	aRegD359 		:= 	{}
Local 	aAuxD350		:= 	{}
Local	aRegD309		:=	{}
Local	aRegD500		:=	{}
Local	aRegD501		:=	{}
Local	aRegD505		:=	{}
Local	aRegD509		:=	{}
Local	aRegD600		:=	{}
Local	aRegD601		:=	{}
Local	aRegD605		:=	{}
Local	aRegD609		:=	{}
Local	aRegF010		:=	{}
Local	aRegI010		:=	{}
Local	aRegF100		:=	{}
Local	aRegF111		:=	{}
Local	aRegF120		:=	{}
Local	aRegF129		:=	{}
Local	aRegF130		:=	{}
Local	aRegF139		:=	{}
Local	aRegF150		:=	{}
Local   aRegF200        :=  {}
Local   aRegF205        :=  {}
Local   aRegF210        :=  {}
Local	aRegF600		:=	{}
Local	aRegF700		:=	{}
Local   aRegFAux		:=  {}
Local   aF600Aux		:=  {}
Local   aF120Aux		:=  {}
Local	aRegF500		:=  {}
Local	aRegF510		:=  {}
Local	aRegF509		:=  {}
Local   aRegF519		:=  {}
Local   aRegF525		:=  {}
Local 	aTotF525		:=  {0,0,0,0,0,0,0}
Local	aRegF550		:=  {}
Local	aRegF560		:=  {}
Local	aRegF559		:=  {}
Local   aRegF569		:=  {}
Local 	aParF550 		:=	{}
Local aRegI100		:=  {}
Local aRegI199		:=  {}
Local aRegI200		:=  {}
Local aRegI299		:=  {}
Local aRegI300		:=  {}
Local aRegI399		:=  {}
Local 	aParCDG 		:=	{}
Local   aRegM350		:=  {}
Local   aM350Aux		:=  {}
Local   aRegM100		:=  {}
Local   aRegM105		:=  {}
Local   aRegM110		:=  {}
Local   aRegM115		:=  {}
Local   aRegM500		:=  {}
Local   aRegM505		:=  {}
Local   aRegM510		:=  {}
Local   aRegM515		:=  {}
Local   aRegM200		:=  {}
Local   aRegM205		:=  {}
Local   aRegM210		:=  {}
Local   aRegM211		:=  {}
Local   aRegM220		:=  {}
Local   aRegM225		:=  {}
Local   aRegM230		:=  {}
Local   aRegM300		:=	{}
Local   aRegM400		:=  {}
Local   aRegM410		:=  {}
Local   aRegM800		:=  {}
Local   aRegM810		:=  {}
Local   aRegM605		:=  {}
Local   aRegM610		:=  {}
Local   aRegM611		:=  {}
Local   aRegM600		:=  {}
Local   aRegM620		:=  {}
Local   aRegM625		:=  {}
Local	aRegM630		:=	{}
Local   aRegM700		:=	{}
Local   aRegAuxM105		:=  {}
Local   aRegAuxM505		:=  {}
Local	aSPDPCAnt		:=	{}
Local	aSPDDif			:=	{}
Local   aRegP010		:= {}
Local   aRegP100		:= {}
Local   aRegP200		:= {}
Local   aRegP210		:= {}
Local 	aRegPE210		:= {}
Local   aReg1010		:= {}
Local   aReg1020		:= {}
Local   aReg1100		:= {}
Local   aReg1101		:= {}
Local   aReg1102		:= {}
Local   aReg1500		:= {}
Local   aReg1501		:= {}
Local   aReg1502		:= {}
Local   aReg1300		:= {}
Local   aReg1700		:= {}
Local   aReg1800        := {}
Local   aReg1900        := {}
//Lgicos
Local 	cPer			:= ""
Local	lHistTab		:=	aParSX6[1] .And. aIndics[01]
Local   lGeraNota		:= .T.
Local	lMVCF3ENTR		:=	aParSX6[2]
Local	lMVESTTELE		:=  aParSX6[3]
Local 	lResF3FT		:=	aParSX6[4]
Local	lMVSpedAz  		:=	aParSX6[5]
Local   lGrava0150      :=	.F.
Local   lGrava0200      :=	.F.
Local	lGrava0190		:=	.F.
Local	lGerouC170		:=	.F.
Local	lAchouSE4		:=	.F.
Local	lIss			:=	.F.
Local	lAchouSF4		:=	.F.
Local	lAchouCD3		:=	.F.
Local	lAchouCD4		:=	.F.
Local	lAchouCD6		:=	.F.
Local	lAchouSC6		:=	.F.
Local   lCampo3         :=  .F.
Local   lAchouCDG		:=  .F.
Local	lAchouCD5		:= 	.F.
Local	lAchouCDT		:=	.F.
Local	lAchouCD1		:=	.F.
Local   lNfe			:=  .F.
Local	lAchouSFU		:=	.F.
Local	lAchouDev		:=	.F.
Local   lConsolid		:=  .F.
Local   lRegC010		:=  .F.
Local   lGeraECF		:=  .F.
Local   lCumulativ 	    :=  .F.
Local 	lGravaA010		:=  .F.
Local 	lGravaC010		:=  .F.
Local 	lGravaD010		:=  .F.
Local 	lGravaF010		:=  .F.
Local 	lGravaI010		:=  .F.
Local 	lGrava0140		:=  .F.
Local 	lPisZero		:=  .F.
Local 	lCofZero		:=  .F.
Local 	lAlqZero		:=  .F.
Local   lAchouSF1		:=  .F.
Local   lAchouSF2		:=  .F.
Local 	lTop			:=  .F.
Local 	lAchSFSD		:=  .F.
Local	lLogCfop		:= 	.F.
Local	lGravaC100		:= 	.F.
Local 	lTabCDT			:= 	aIndics[12]
Local 	lTabCDC			:= 	aIndics[33]
Local	lF2NFCUPOM 		:= 	aFieldPos[1]
Local	lF1TPCTE 		:= 	aFieldPos[2]
Local	lTabCF2			:=	aIndics[14]
Local 	lNatOper 		:=  aFieldPos[3]
Local	lTabComp		:=	aIndics[25] .And. aIndics[28] .And. aIndics[06] .And. aIndics[07] .And. ;
aIndics[08] .And. aIndics[09] .And. aIndics[10]
Local	lTabCD1			:=	aIndics[31]
Local	lGravaNFE		:=	.T.
Local	lSkpENC			:=	aParSX6[6]
Local	lSPEDCSC		:=	aParSX6[7]
Local	lCmpVertPC		:=  aFieldPos[4] .AND. aFieldPos[5]
local	lCmpD2VlPC		:= 	aFieldPos[6] .AND. aFieldPos[7]
Local	lCmpDescIC		:=	aFieldPos[8]
Local	lCmpDescZF		:=	aFieldPos[9]
Local   lCredPAgro		:= 	aParSX6[8]
Local   lRecIndi		:= aIndics[19]
Local	lBlocoPRH		:=	aParSX6[9]
Local	cSPCBPSE		:=	aParSX6[10]
Local	lGravaP010		:= .F.
Local	lEnerEle		:=  .F.
Local   lSpedNat		:=	aParSX6[11]
Local	lCmpDscComp		:=	CDT->(FieldPos("CDT_DCCOMP")) > 0
Local   lSitDocCDT		:=	.F.

Local   cJoinD1D2		:= ""
Local	cJoinF1F2		:= ""
Local   cSlctF1F2		:= ""
Local   cSlctD1D2		:= ""
Local	cAliasF130 		:= ""
Local	cAliasF500 		:= "F500"
Local   cAliasCDG		:= "CDG"
Local	cArqDestino 	:= ""
Local	aResult 		:= {}
Local 	nItemC170		:=0
Local   nCountTot		:= 0
Local   nPosF559		:= 0

Local	AF600Tmp		:=	{}
Local	aPartDoc		:=	{}
Local	aAreaSM0		:=	SM0->(GetArea ())
Local	aAreaQSFT		:=	{}
Local	aAreaQSD1		:=	{}
Local	aArq			:=	{}
Local   aLisFil         :=  {}
Local   aProd197		:=  {}
Local	aAverage		:=  {}
Local	aTotaliza		:=	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
Local	aClasFis		:=	{"","","",""}
Local	aCmpAntSFT		:=	{}
Local   aProd			:=  {"","","","","","","","","","",""}
Local   aValor0111		:= {}
Local   aRecAgro		:= {}
Local   aCompAgro		:= {}
Local	aCredPresu		:= {}
Local   aDevolucao		:= {}
Local   aDevCpMsmP		:= {}
Local   aAjuCred		:= {}
Local	aFieldDt		:=	{}
Local	aPEC110			:=	{}
Local   aDiferAnt		:=  {}
Local   aDifer			:=  {}
Local   aAjusteA		:=  {}
Local   aAjusteR		:=  {}
Local	aReg0140Ex		:=	{}
Local   aVlCrdImob      := {0,0}
Local 	aDevMsmPer		:=	{}
Local 	aDevAntPer		:=	{}
Local 	aAjustMX10		:=	{}

Local   cChvSeek		:= ""
Local	cChaveCCZ		:=	""
Local	cAliasSFT		:=	"SFT"
Local	cAliasSC6		:=	"SC6"
Local	cSlctSFT		:=	""
Local	cSlctComp		:= ""
Local	cJoinCompl		:= ""
Local	cSlctSB1		:=	""
Local	cSlctF4			:=	""
Local	cSlctALL		:=	""

Local	cCfop	 		:=  ""
Local	cConta	 		:=  ""
Local	cOrderBy 		:=  ""
Local	cTpMov 			:=  ""
Local	cAliasSB1 		:=  "SB1"
Local	cJoinSF4 		:=  ""
Local	cAliasSF4 		:=  "SF4"
Local	cAliasSF1 		:=  "SF1"
Local	cAliasSF2 		:=  "SF2"
Local	cAliasSD1 		:=  "SD1"
Local	cAliasSD2 		:=  "SD2"
Local 	cNomeCfp		:=	"SPEDPISCOF" + FWGRPCOMPANY() + FWGETCODFILIAL
Local	cCampos			:=	""
Local	cAlias			:=	""
local 	cAlsCFA			:= "CFA"
Local	cFilAte			:=	""
Local   cFiltro   		:=  ""
Local	cAlsSF			:=	""
Local	cAlsSD			:=	""
Local	cAlsSA			:=	""
Local	cEntSai			:=	""
Local	cEspecie		:=	""
Local	cSituaDoc		:=	""
Local	cCmpUm			:=	""
Local	cCmpCondP		:=	""
Local	cLancam			:=	""
Local	cChaveF3		:=	""
Local	cChaveCDT		:=	""
Local	cIndEmit		:=	""
Local	cChvNfe			:=	""
Local	cUnid			:=	""
Local	cProd			:=	""
Local 	cOpSemF			:=	""
Local	cIndex			:=	""
Local 	cMVEstado		:= 	""
Local 	cChvCte			:=  ""
Local	cFilDe			:=	""
Local   cIndCont 		:=  ""
Local   cDescProd		:=  ""
Local 	cCodInfCom		:=  ""
Local 	cIndApro		:=  ""
Local 	cStatus			:=  ""
Local	cTipoNf			:=  ""
Local  cIndNatJur		:= ""
Local  cIndTipCoo		:= ""
Local	cAliasCD5		:=	"CD5"
Local 	cAlias199		:= "CD5"
Local	cCmpTPCTE		:=	""
Local	cAliasP			:= "REGP"
Local	cPCodServ		:= ""
Local	cPCodDem		:= ""
Local	cCmpValPis		:=	""
Local	cCmpValCof		:=	""
Local	cCodTes			:=	""
Local	cCodNat			:=	""
Local	cDescNat		:=	""
Local	cCmpMenNota		:=	""
Local 	cSitExt			:=	""

Local   lPauta			:= .F.
Local   aBaseAlqUn		:= {}
Local	nAlqPis			:= 0
Local	nBasePis		:= 0
Local	nValPis			:= 0
Local	nAlqCof			:= 0
Local	nBaseCof		:= 0
Local	nValCof			:= 0
Local 	nTotF			:= 0
Local  	nTotPrev        := 0
Local	lValExclu		:= aParSX6[13]	//Par¢metro que indica se deve ser levado o Valor da excluso de Pis e Cofins
Local	nValExcluP		:= 0	//Valor da excluso de Pis, Que deve ser levado para registro F550, campo 4.
Local	nValExcluC		:= 0	//Valor da excluso de Cofins, Que deve ser levado para registro F550, campo 9.
Local nCrPrAlPIS		:=0
Local nCrPrAlCOF 		:= 0
Local	nMVM996TPR		:=	aParSX6[12]
Local	cCmpFrete		:=	0
Local	nZ				:=	0
Local	nX				:=	0
Local	nI				:=	0
Local   nItem           :=  0
Local   nCont			:=  0
Local 	n2Cont 			:= 	0
Local   dUltDia	   		:=	CToD ("//")
Local	nRelacDoc		:=	0
Local	nValST 			:= 	0
Local	nIndex			:=	0
Local	nApurIpi		:=	0
Local 	nExpIndS		:= 	0
Local   nQtde           :=  0
Local   nRelacFil		:=  0
Local   nCPisRet 		:=  0
Local   nCCOfRet 		:=  0
Local   nNCPisRet 		:=  0
Local   nNCCOfRet		:=  0
Local   nPosC110        :=  0
Local   nPosC600 		:=  0
Local   nPosC180        :=  0
Local   nPosC190        :=  0
Local   nPosD300        :=  0
Local   nPosD200        :=  0
Local   nPosD600        :=  0
Local 	nPaiA			:=  0
Local 	nPaiC			:=  0
Local 	nPaiD			:=  0
Local 	nPaiF			:=  0
Local 	nPaiI			:=  0
Local	nPaiP			:=  0
Local	nMTP			:=  0
Local lMtBlcP			:= aParSX6[46]
Local   nPos0200		:=  0
Local	nRecnoSFU		:=	Nil
Local	nRecnoSFX		:=	Nil
Local	nRecnoCD1		:=	Nil
Local	nPosDevCmp		:= 0
Local	nPosDev			:= 0
Local	nPosM350		:= 0
Local   nPosCFA        	:=  0
Local	nMVSPDIFC		:=	GetNewPar("MV_SPDIFC",0)

Local 	aCFOPs			:= XFUNCFRec() // Funcao que retorna array com CFOPS / [1]-Considera Receita / [2]-NAO considera como Receita
Local 	cCFOPEElet 		:= "125/225/325/525/625"
Local   lReceita		:= .F.
Local	nTotContrb		:= 0
//RATEIO PROPORCIONAL
Local aProcItem			:= {}
Local cArqTmp 			:= "TMPPISCOF"
Local lApropDir			:= aParSX6[14]
//DIFERIMENTO ORGAO PUBLICO
Local aRegM3e7			:= {}
Local nDiferAnt			:= 0
Local nDifAPis			:= 0
Local nDifACof			:= 0
Local cChaveSE1			:= ""
Local lDif				:= .F.
Local lReproc			:= .F.
Local dDtApur 			:=	CToD ("//")
Local lItemNCumu		:= .F.
//Tratamento para consolidar Filiais com mesmo CNPJ
Local aSM0		   		:= {}
Local lFilGra			:= .F.
Local cCGCAnt			:= ""
Local n0				:= 0
Local cPrefixo			:= ""
// Variaveis para Tratamento de ICMS-ST
Local 	cMV_StUf		:=	aParSX6[15]
Local 	cMV_StUfS		:=	aParSX6[16]
Local 	cMVCFE210		:=	LeParSeq("MV_CFE210","1410,1411,1414,1415,1660,1661,1662,2410,2411,2414,2415,2660,2661,2662")
Local 	cMVSUBTRIB		:=	LeParSeq("MV_SUBTRIB")
Local	cAlertCfop		:=	STR0093
Local 	lGravaM220		:= .F.
Local	nFil			:= 0
Local 	aParFil			:= {}
Local	aPEImport    	:=	{}
Local 	lFirst 			:= .T.
Local 	aTpMov          :=  {}
Local   aRetImob        :=  {}
Local   aCFA			:= {}
Local   nContMov		:=  0
Local	lIntTMS			:=	.F.
Local	lIntEasy		:=	.F.
Local	lTabCD0			:=	.F.
Local   lCmpCHVNFE		:= aFieldPos[10]
Local   cMVEASY			:= aParSX6[17]
Local   lSPDFIS02		:= aExstBlck[02]
Local   lSPEDPROD		:= aExstBlck[03]
Local	lSpdP09			:= aExstBlck[04]
Local   lSpdPisTr		:= aExstBlck[05]
Local	lSpdP06			:= aExstBlck[06]
Local	lSpdP61			:= aExstBlck[21]
Local	lSpdP65			:= aExstBlck[22]
Local 	aSPDPisTR		:= {}
Local 	lAchou199		:= .F.
Local   lDevComp		:= .F.
Local 	lNewCFrt		:= .F.
Local   lBlocACDF		:= .T.
Local   lRgCmpCons		:= .F.
Local   lRgCmpDet		:= .F.
Local   lRgCaxCons		:= .F.
Local	lMVGERNF		:= aParSX6[18]
Local 	nCt400    		:=0
Local	lOrgPub			:=	.F.
Local	lTabCFA			:= aIndics[29] .AND. aIndics[30]
Local   lSitDocExt     	:= aFieldPos[86] .AND. aFieldPos[87]

Local	c1Dupref		:= aParSX6[19]
Local 	c2Dupref		:= aParSX6[20]
Local 	lCDT_INDFRT		:= aFieldPos[11]
Local 	lA1_TPREG 		:= aFieldPos[12]
Local 	lFT_CODNFE 		:= aFieldPos[13]
Local 	cChvCD5			:= ""
Local 	cChv199			:= ""
Local 	cHAWB     		:= ""
Local 	alCopied		:= {}
Local 	clFSerie		:= ""
Local	lF1TpFrete 		:= aFieldPos[14]
Local	lNCodPart		:= .F.
Local	aAjCredSCP		:=	{}
Local	lFilSCP			:=	.F.
Local   nTotal			:= 0
Local 	nTotAt			:= 0

Local 	lCpoMajAli 		:= aFieldPos[15] .And. aFieldPos[16]
Local 	lCmpsSB5		:= SB5->(LastRec())>0 .AND. aFieldPos[17] .AND. aFieldPos[18] .AND. aFieldPos[19]
Local 	lCpoPtPis		:= aFieldPos[20]
Local	lCpoPtCof		:= aFieldPos[21]
LOcal 	lB1Tpreg		:= aFieldPos[22]
Local   cRelacMax       := Replicate("0",50)
Local	aJobAux			:= {}
Local 	nContJob		:= 0
Local	cJobFile		:= ""
Local 	nHandleTRB		:= 0
Local 	cSemaphore		:= ""
Local 	cFunction		:= ""
Local 	lZerVar			:= .F.
Local 	lImport			:= .F.
Local   cCodIncT        := "1"
Local	lMvPartRgA		:=	aParSX6[21]
Local   aRecBrtFil		:= {}
Local 	lGeraCrdExt   	:= .T.
Local 	lBlocoI		   	:= .F.
Local 	cNomeTRBP		:= ""
Local 	lProcAntP       := .F.
Local 	lProcAntC       := .F.
Local 	aRegNf 			:= {}
Local	lF1Mennota 		:= aFieldPos[83]
Local	lF2Mennota 		:= aFieldPos[84]
Local 	nRecAuf      	:= 0
Local 	nRemType 		:= GetRemoteType()
Local 	nC175			:= 0
Local 	cMVDTINCB1		:= 	IIF(AllTrim(GetNewPar("MV_DTINCB1","B1_DATREF")) != "", AllTrim(GetNewPar("MV_DTINCB1","B1_DATREF")),"B1_DATREF")
Local  cTitOld := ''

//Data
Private	dDataDe			:=	CToD ("//")
Private	dDataAte		:=	CToD ("//")
Private	lGrBlocoM		:=	aParSX6[22]
Private	lUsaCF7			:=	aParSX6[23]
Private	lTemProjet		:=	.F.
Private cRegime 		:= ""
//Tratamento para consolidar Filiais com mesmo CNPJ
Private lRepCGC 		:= ""
Private lCmpNRecFT		:=	.F.
Private lCmpNRecB1		:=	.F.
Private lCmpNRecF4 		:=	.F.

Private nDedPISNC		:= 0
Private nDedCOFNC		:= 0
Private nDedPISC		:= 0
Private nDedCOFC		:= 0
Private lDevolucao		:= .F.
Private nDedAPisNC		:=0
Private nDedACofNC		:=0
Private nDedAPisC		:=0
Private nDedACofC		:=0
Private aDedAPisNC		:={}
Private aDedACofNC		:={}
Private aDedAPisC		:={}
Private aDedACofC		:={}
Private	cBlocoP			:= ""
Private lProcBlcP		:= .F.

Private cNomeTRB 		:= StrTran(( "SPDC"+CriaTrab(,.F.)+FWGrpCompany()+FWCodFil() ) , " " , "" )
Private n_SPCRecno		:= 1
Private n_COMMIT		:= 0
Private cJobAux			:= ""
Private cJobPAux			:= ""
Private cMvSegment		:= aParSX6[24]
Private nMvQtdThr		:= aParSX6[25]
Private lMvGerPrdC		:= aParSX6[26]
Private lProcMThr		:= .F.
Private lConcFil			:= .T.
Private cAliasPE			:= "E"
Private lGeraReg		:= .F. //Flag para no gerar os registros M115, M515, M225 e M625 pois o validador 2.07 ainda no tem validao para estes registros

Default	lJob		:=	.F.
Default	aFilJob		:=	{}

SX2->( dbSetOrder( 1 ) )
SX2->( dbGoTop() )
If SX2->(dbSeek("SFV"))
	lProcAntP := (Alltrim(SX2->X2_UNICO) == "" .And. SFV->(FieldPos("FV_APURPER"))>0 .AND. SFV->(FieldPos("FV_MESANO"))>0)
Endif

SX2->( dbSetOrder( 1 ) )
SX2->( dbGoTop() )
If SX2->(dbSeek("SFW"))
	lProcAntC := (Alltrim(SX2->X2_UNICO) == "" .And. SFW->(FieldPos("FW_APURPER"))>0 .AND. SFW->(FieldPos("FW_MESANO"))>0)
Endif
nMvQtdThr := Iif((nMvQtdThr>0),Iif((nMvQtdThr>5),5,nMvQtdThr),0)// Limita a quantidade de Threads para 5 (no maximo)
// Se gerar bloco M e opcao de MultiThread estiver ligada, desabilita a geracao do bloco M
If lGrBlocoM .AND. nMvQtdThr>0
	lGrBlocoM := .F. 	// Apresentar mensagem.
EndIf

If !lJob .And. !xMagLeWiz (cNomeCfp, @aWizard, .T.)
	MsgJobSPC( "WIZARD: Problema ao Ler o Wizard!" )
	Return .f.
EndIf

//Preenche as vari¡veis com informaµes da Wizard.
lOrgPub		:= Iif(SubStr(aWizard[4][3],1,1)=="1",.T.,.F.)
lRepCGC		:= Iif(SubStr(aWizard[4][4],1,1)=="1",.T.,.F.)
cIndNatJur	:= SubStr(aWizard[2][3],1,2)
cIndTipCoo	:= SubStr(aWizard[2][6],1,2)
dDataDe		:= SToD (aWizard[1][1])        // Data inicio do per­odo
dDataAte	:= SToD (aWizard[1][2])        // Data final do per­odo
cDir		:= IIf(nRemType <> 5, AllTrim(aWizard[1][4]), "") // Diretrio - Se for SMARTCLIENT HTML, manter vazio.
cPer 		:= SubStr(aWizard[1][2],5,2) + SubStr(aWizard[1][2],1,4)
cFileDest	:= AllTrim(cDir+aWizard[1][5])
cNrLivro	:= Iif(!LETTERORNUM(aWizard[1][3]), '*', aWizard[1][3])
cRegime 	:= Substr(aWizard[4][1],1,1)    //Tipo de regime
//lGrBlocoM	:= Iif(SubStr(aWizard[4][7],1,1)=="1",.T.,.F.)
cBlocoP		:= SubStr(aWizard[1][9],1,1)    //1-No; 2-Sim; 3-Exclusivamente
cPCodServ	:= aWizard[1][10]   		    // Cdigo da receita vinculada   prestao de servios P200
cPCodDem	:= aWizard[1][11]   			// Cdigo da receita vinculada  s demais operaµes P200
cIndLucPre 	:= Substr(aWizard[4][5],1,1) 	// Indicador exclusivo para lucro presumido, se © regime de caixa, competencia consolidado ou competencia detalhado
cIndCompRe 	:= Substr(aWizard[4][6],1,2) 	// Indicador da composio da receita para gerao do registro F525 regime de caixa
cCodIncT    := Substr(aWizard[1][12],1,1)   // Cdigo indicador da incidªncia tribut¡ria no per­odo:
lBlocoI		:= SubStr(aWizard[2][4],1,1) == "3" .AND. !Empty(Alltrim( aWizard[4][7])) .AND.  dDataDe >= cToD("01/07/2013")

lGeraCrdExt := dDataAte <= cToD("31/07/2013") // Flag para gerar registros de cr©dito extemporaneo.

If !LETTERORNUM(aWizard[1][3])
	aWizard[1][3] := '*'
EndIf

If dDataDe >= CTOD("01/07/2012") .AND. cRegime == "2"

	lBlocACDF	:= .F.
	lRgCmpCons	:= .F.
	lRgCaxCons	:= .F.
	lRgCmpDet	:= .F.

	If  cIndLucPre == "1" // Regime de Caixa Consolidado
		lRgCaxCons	:= .T.
	ElseIf cIndLucPre == "2" // regime de Competencia consolidado
		lRgCmpCons	:= .T.
	ElseIf cIndLucPre == "9" // regime de Competencia detalhado
		lBlocACDF	:= .T.
		lRgCmpDet	:= .T.
	EndIF

Else
	lBlocACDF	:= .T.
	lRgCmpDet	:= .T.
EndIF

If cBlocoP == "3" // Gerar exclusivamente informaµes do blocoP
	lGrBlocoM := .F.
EndIf

//Verifica se faz tratamento para modelo 55 consolidado ou individualizado.
If  "1" $ aWizard[1][7]
	lConsolid := .T.
EndIf

If "1" $ aWizard[1][8] .AND. lRgCmpDet
	lGeraECF := .T.
EndIF

If !lBlocACDF
	lGeraECF := .F.
EndIF

If lBlocoI
	lBlocACDF	:= .F.
	lRgCmpCons	:= .F.
	lRgCaxCons	:= .F.
	lRgCmpDet	:= .F.
	lGeraECF := .F.
EndIF
//Verifica reprocessamento CCX.
If lReproc .And. !Empty(dDtApur)
	PCClearA(dDtApur)

	If !lJob
		MsgAlert(STR0080,"") //"Reprocessamento realizado, reinicie a rotina."
		Return
	EndIf
EndIf

// Se for SMARTCLIENT HTML no fazer as validacoes abaixo.
If nRemType <> 5
	//Verifica se o Diretorio Existe.
	alCopied := Directory(cDir+"*.*","D")

	If len(cDir) ==0 .Or. Len(alCopied) == 0
		If lJob
			MsgJobSPC( "FINAL: " + OemToAnsi( STR0067 ) ) //"Para gerao deste arquivo © necess¡rio informar o diretrio de gravao v¡lido"
		Else
			MsgAlert(STR0067) //"Para gerao deste arquivo © necess¡rio informar o diretrio de gravao v¡lido"
		EndIf
		Return .F.
	EndIF

	If len(AllTrim (aWizard[1][5])) ==0
		If lJob
			MsgJobSPC( "FINAL: " + OemToAnsi( STR0068 ) )//"Para gerao deste arquivo © necess¡rio informar o nome do arquivo."
		Else
			MsgAlert(STR0068)//"Para gerao deste arquivo © necess¡rio informar o nome do arquivo."
		EndIf
		Return .F.
	EndIF
EndIf

//Verifica se a data inicial est¡ vazia
If len(alltrim(dtos(dDataDe))) == 0
	If lJob
		MsgJobSPC( "FINAL: " + OemToAnsi( STR0069 ) )
	Else
		MsgAlert(STR0069)
	EndIf
	Return .F.
EndIF
//Verifica se a data final est¡ vazia
If len(alltrim(dtos(dDataAte))) == 0
	If lJob
		MsgJobSPC( "FINAL: " + OemToAnsi( STR0070 ) )
	Else
		MsgAlert(STR0070)
	EndIf
	Return .F.
EndIF

If lGeraECF
	dbSelectArea("SLG")
	If !aFieldPos[23]
		If lJob
			MsgJobSPC( "FINAL: " + OemToAnsi( STR0099 ) )
		Else
			MsgAlert(STR0099)
		EndIf
		Return .F.
	EndIf
	DbSelectArea("SIX")
	DbSetOrder(1)
	If !MsSeek("SFI" + "3")
		If lJob
			MsgJobSPC( "FINAL: " + OemToAnsi( STR0100 ) )
		Else
			MsgAlert(STR0100)
		EndIf
		Return .F.
	EndIf
EndIF

#IFDEF TOP
	If TcSrvType() <> "AS/400"
		lTop 	:= .T.
	Endif
#ENDIF

// Verifica se o processamento sera em multithread
If (lProcMThr := (nMvQtdThr>0 .AND. lTop .AND. cMvSegment=="2" .And. !substr(aWizard[4][5],1,1)$"1/2") )

	// Define semaforo
	cSemaphore  := "SPDC_"+Alltrim(Str(ThreadID()))
	// Fucao que sera chamada na thread para descarga de array na tabela temporaria
	cFunction 	:= "MThdGrvTRB"

	GeraTrb(1, @aArq, @cAlias, .T. , @nHandleTRB)
Else
	// Processo normal - padrao
	GeraTrb(1, @aArq, @cAlias)
EndIf

IF !lBlocoI
	//Adiciona os movimentos de entrada e sa­da.
	If lBlocACDF
		aAdd(aTpMov,"S") //Sa­das
		aAdd(aTpMov,"E") //Entradas
	ElseIF lRgCmpCons
		aAdd(aTpMov,"S") //Sa­das
	EndIF
EndIF

cIndApro := "2"

//Tratamento para Linux onde a barra e invertida
If nRemType == 2 // REMOTE_LINUX
	If (SubStr (cDir, Len (cDir), 1)<>"/")
		cDir	+=	"/"
	EndIf
Else
	If (SubStr (cDir, Len (cDir), 1)<>"\")
		cDir	+=	"\"
	EndIf
EndIf

//Verifico se devo abrir a tela para fazer o processamento de multifiliais
If "1"$aWizard[1][6]
	aLisFil  :=	Iif( lJob , aFilJob, MatFilCalc( .T. ) )
	If !Empty(aLisFil)
		cFilDe	:=	PadR("",FWGETTAMFILIAL)
		cFilAte	:=	Repl("Z",FWGETTAMFILIAL)
	Else
		If lJob
			MsgJobSPC( "MSG: " + OemToAnsi( STR0071 ) )
		Else
			MsgAlert(OemToAnsi(STR0071))
		EndIf
		//   opcao 2 neste array que eh o resultado do wizard                                     
		aWizard[1][6]	:=	"2 - No"
		cFilDe			:=	cFilAnt
		cFilAte			:=	cFilAnt
	EndIf
Else
	AADD(aLisFil,{.T.,SM0->M0_CODFIL,SM0->M0_FILIAL,SM0->M0_CGC})
EndIf

If (Empty (cFilDe) .And. Empty (cFilAte))
	cFilDe	:=	cFilAnt
	cFilAte	:=	cFilAnt
EndIf

If lGrBlocoM
	IniCF4(SubStr(DTos(dDataDe),5,2)+SubStr(Dtos(dDataDe),1,4))
EndIf

If lBlocACDF
	IncProc("Processando valores de receita Bruta")
	If !cRegime == "2" // exclusivamente cumulativo
		// Se for funcionamento em MultiThread utiliza a nova funcao NwRecBrut
		If lProcMThr
			aValor0111 := NwRecBrut(dDataDe,dDataAte,cEmpAnt,cFilAte,aWizard,aLisFil,cFilDe,aCFOPs,nMVM996TPR,cRegime, @nTotF, lTop)
		Else
			aValor0111 :=   RecBrut(dDataDe,dDataAte,cEmpAnt,cFilAte,aWizard,aLisFil,cFilDe,aCFOPs,nMVM996TPR,cRegime, @nTotF, ,@aRecBrtFil,lApropDir )
		EndIf
		If !lApropDir
			Reg0111(@aReg0111,aValor0111,cRegime)
		EndIf
	EndIf

	IF lCredPAgro .AND. !cRegime == "2" .AND. lGrBlocoM
		aRecAgro 	:=	TotReceita(dDataDe,dDataAte,cEmpAnt,cFilAte,aWizard,aLisFil,cFilDe,aCFOPs,lTop)
		aCompAgro	:=	TotEntGado(dDataDe,dDataAte,cEmpAnt,cFilAte,aWizard,aLisFil,cFilDe,aCFOPs,lTop)
		aCredPresu	:=	CredPreGad(aRecAgro,aCompAgro,dDataAte)
	EndIF
EndIF

IncProc("Processando deduo de per­odo anterior")
//Verifica se existe valor credor de PIS e Cofins que esto gravados na tabela CF3.
DeDAnt(aWizard[1][2],@aDevAntPer,@aAjustMX10)

RestArea (aAreaSM0)
cFilAnt := FWGETCODFILIAL
DbSelectArea ("SX5")
SX5->(DbSetOrder (1))
DbSelectArea ("SA1")
SA1->(DbSetOrder (1))
DbSelectArea ("SA2")
SA2->(DbSetOrder (1))
DbSelectArea ("SF1")
SF1->(DbSetOrder (1))
DbSelectArea ("SF2")
SF2->(DbSetOrder (1))
DbSelectArea ("SE4")
SE4->(DbSetOrder (1))
DbSelectArea ("SF3")
SF3->(DbSetOrder (1))
DbSelectArea ("SF4")
SF4->(DbSetOrder (1))
DbSelectArea ("SD1")
SD1->(DbSetOrder (1))
DbSelectArea ("SD2")
SD2->(DbSetOrder (3))
DbSelectArea ("SB5")
SB5->(DbSetOrder (1))
DbSelectArea ("SB1")
SB1->(DbSetOrder (1))
DbSelectArea ("SC6")
SC6->(DbSetOrder (1))

lCmpNRecB1 := .T.

lCmpNRecF4 := .T.

DbSelectArea ("SAH")
SAH->(DbSetOrder (1))
DbSelectArea ("SX6")
SX6->(DbSetOrder (1))

If lTabComp
	DbSelectArea ("CCE")
	CCE->(DbSetOrder (1))
	DbSelectArea ("CDG")
	CDG->(DbSetOrder (1))
	DbSelectArea ("CD5")
	CD5->(DbSetOrder (1))
	DbSelectArea ("CCF")
	CCF->(DbSetOrder (1))
	DbSelectArea ("SFU")
	SFU->(DbSetOrder (1))
	DbSelectArea ("SFX")
	SFX->(DbSetOrder (1))
EndIF

If lTabCD1
	DbSelectArea("CD1")
	CD1->(DbSetOrder(1))
Endif

If aIndics[05]
	DbSelectArea ("CCZ")
	CCZ->(DbSetOrder (1))
EndIF

If lTabCFA
	DbSelectArea("CFA")
	CFA->(DbSetOrder(1))
	DbSelectArea("CFB")
	CFB->(DbSetOrder(1))
Endif

If cIndNatJur == "01" // Se foi selecionado sociedade cooperativa na Wizard
	If aIndics[13]
		DbSelectArea ("CE9")  //Valores de excluso de PIS e Cofins para sociedade cooperativa.
		CE9->(DbSetOrder (1))
	Else
		If lJob
			MsgJobSPC( "MSG: " + OemToAnsi( STR0092 ) )
		Else
			MsgAlert(STR0092)
		EndIf
	EndIF
EndIf

If aIndics[01]
	DbSelectArea ("AIF")	//Historico de ALteracoes SA1/SA2/SB1
	AIF->(DbSetOrder (1))
EndIf

If IntTms ()
	DbSelectArea ("DT6")	//Documentos de Transporte
	DT6->(DbSetOrder (1))
	lIntTMS	:=.T.
EndIf

DbSelectArea ("DB3")	//Itens do documento de recebimento
DB3->(DbSetOrder (1))

If aIndics[26] //Controle de retano de PIS
	DbSelectArea ("SFV")	//Itens do documento de recebimento
	SFV->(DbSetOrder (1))
Else
	If lJob
		MsgJobSPC( "MSG: " + OemToAnsi( STR0101 ) )
	Else
		MsgAlert(STR0101)
	EndIf
	Return .F.
EndIf
If cBlocoP $ "1/3"
	If aIndics[22]
		DbSelectArea("CG1")
		CG1->( DbSetOrder(1))
	Else
		If lJob
			MsgJobSPC( "MSG: " + OemToAnsi( "Para gerao correta do Bloco P, a tabela CG1  deve constar na base. Favor Verificar os procedimentos para execuo do compatibilizador UPDFIS, conforme o Boletim Tecnico do SPED PIS COFINS" ) )
		Else
			MsgAlert("Para gerao correta do Bloco P, a tabela CG1  deve constar na base. Favor Verificar os procedimentos para execuo do compatibilizador UPDFIS, conforme o Boletim Tecnico do SPED PIS COFINS")
		EndIf
		Return .F.
	EndIf
EndIf

DbSelectArea ("SFW")
SFW->(DbSetOrder (1))
DbSelectArea ("SFT")
SFT->(DbSetOrder (1))

lCmpNRecFT := .T.

DbSelectArea ("CVD")
CVD->(DbSetOrder (1))


IF !aFieldPos[77]
	If lJob
		MsgJobSPC( "MSG: " + OemToAnsi( STR0072 ) )
	Else
		MsgAlert(STR0072)
	EndIf
	Return .F.
EndIF


IF !aFieldPos[72]
	If lJob
		MsgJobSPC( "MSG: " + OemToAnsi( STR0076 ) )
	Else
		MsgAlert(STR0076)
	EndIf
	Return .F.
EndIF

If !aIndics[04] //Controle de Cr©dito de PIs
	If lJob
		MsgJobSPC( "MSG: " + OemToAnsi( STR0074 ) )
	Else
		MsgAlert(STR0074)
	EndIf
	Return .F.
EndIf

If !aIndics[02]
	If lJob
		MsgJobSPC( "MSG: " + OemToAnsi( STR0075 ) )
	Else
		MsgAlert(STR0075)
	EndIf
	Return .F.
EndIf

If !aIndics[16] .OR. !aIndics[15]
	If lJob
		MsgJobSPC( "MSG: " + OemToAnsi( STR0095 ) ) //"Para gerao deste arquivo as tabelas CF3 e CF4  devem constar na base. Favor Verificar os procedimentos para execuo do compatibilizador UPDFIS, conforme o Boletim Tecnico do SPED PIS COFINS"
	Else
		MsgAlert(STR0095) //"Para gerao deste arquivo as tabelas CF3 e CF4  devem constar na base. Favor Verificar os procedimentos para execuo do compatibilizador UPDFIS, conforme o Boletim Tecnico do SPED PIS COFINS"
	EndIf
	Return .F.
EndIf

If !aFieldPos[73]
	If lJob
		MsgJobSPC( "MSG: " + OemToAnsi( STR0102 ) )//"Para gerao deste arquivo a tabela SFV deve estar com os campos cadastrados corretamente. Favor Verificar os procedimentos para execuo do compatibilizador UPDFIS, conforme o Boletim Tecnico do SPED PIS COFINS"
	Else
		MsgAlert(STR0102)//"Para gerao deste arquivo a tabela SFV deve estar com os campos cadastrados corretamente. Favor Verificar os procedimentos para execuo do compatibilizador UPDFIS, conforme o Boletim Tecnico do SPED PIS COFINS"
	EndIf

	// Verifica se o processamento sera em multithread
	If lProcMThr
		GeraTrb(2, @aArq, @cAlias,.T.,nHandleTRB,nMvQtdThr,cSemaphore )
	Else
		GeraTrb(2, @aArq, @cAlias)
	EndIf

	Return .F.
EndIF

If !aIndics[27] //Controle de retano de PIS
	If lJob
		MsgJobSPC( "MSG: " + OemToAnsi( STR0103 ) )//"Para gerao deste arquivo a tabela SFW  deve constar na base. Favor Verificar os procedimentos para execuo do compatibilizador UPDFIS, conforme o Boletim Tecnico do SPED PIS COFINS"
	Else
		MsgAlert(STR0103)//"Para gerao deste arquivo a tabela SFW  deve constar na base. Favor Verificar os procedimentos para execuo do compatibilizador UPDFIS, conforme o Boletim Tecnico do SPED PIS COFINS"
	EndIf
	Return .F.
EndIf

If !aFieldPos[76]
	If lJob
		MsgJobSPC( "MSG: " + OemToAnsi( STR0104 ) )//"Para gerao deste arquivo a tabela SFW deve estar com os campos cadastrados corretamente. Favor Verificar os procedimentos para execuo do compatibilizador UPDFIS, conforme o Boletim Tecnico do SPED PIS COFINS"
	Else
		MsgAlert(STR0104)//"Para gerao deste arquivo a tabela SFW deve estar com os campos cadastrados corretamente. Favor Verificar os procedimentos para execuo do compatibilizador UPDFIS, conforme o Boletim Tecnico do SPED PIS COFINS"
	EndIf

	// Verifica se o processamento sera em multithread
	If lProcMThr
		GeraTrb(2, @aArq, @cAlias,.T.,nHandleTRB,nMvQtdThr,cSemaphore )
	Else
		GeraTrb(2, @aArq, @cAlias)
	EndIf

	Return .F.
EndIF

If aIndics[23]
	DbSelectArea ("CG4")
	CG4->(DbSetOrder (1))
EndIF

Reg0000 (aWizard, cAlias, dDataDe, dDataAte)
Reg0100 (aWizard, cAlias)
Reg0110 (aWizard, cAlias)
Reg0120 (aWizard, cAlias)
IniM200600(@aRegM200,@aRegM600)

IncProc("Iniciando seleo das filiais")

aAreaSM0 := SM0->(GetArea())
DbSelectArea("SM0")

SM0->(DbGoTop())
If SM0->(MsSeek(cEmpAnt))
	Do While !SM0->(Eof()) .And. ((!"1"$aWizard[1][6] .And. cEmpAnt==SM0->M0_CODIGO .And. FWGETCODFILIAL<=cFilAte) .Or. ("1"$aWizard[1][6] .And. Len(aLisFil)>0 .And. cEmpAnt==SM0->M0_CODIGO  ))
		nFil := Ascan(aLisFil,{|x|AllTrim(x[2])==Alltrim(SM0->M0_CODFIL) .And. x[4] == SM0->M0_CGC})
		If nFil > 0 .And. aLisFil[nFil][1]
			Aadd(aSM0,{SM0->M0_CODIGO,SM0->M0_CODFIL,SM0->M0_FILIAL,SM0->M0_NOME,SM0->M0_CGC})
		EndIf
		SM0->(dbSkip())
	Enddo
EndIf
SM0->(RestArea(aAreaSM0))

If lRepCGC
	aSM0 := ASort(aSM0,,,{|x,y| x[5] < y[5] })
EndIf

// Sobe as Threads pela funcao "SPDBarkThr" (SPEDXFUN)
If lProcMThr
	For nI:=1 To nMvQtdThr
		StartJob( "SPDBarkThr", GetEnvServer(), .F., cSemaphore, cFunction, cEmpAnt, cFilAnt, cNomeTRB, cAlias, StrZero(nI,2) )
	Next nI
EndIf

//Loop das empresas e filiais.
For n0 := 1 to Len(aSM0)
	SM0->(DbGoTop ())
	SM0->(MsSeek (aSM0[n0][1]+aSM0[n0][2], .T.))	//Pego a filial mais proxima
	IncProc(STR0004+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL))
	cStatus := STR0004+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL) + " - " + StrZero(n0,3) + " de " + StrZero(Len(aSM0),3)
	cFilAnt := FWGETCODFILIAL
	If Len(aLisFil)>0
       nFilial := Ascan(aLisFil,{|x|AllTRim(x[2])==AllTrim(cFilAnt)})
	   If nFilial > 0
		   If !(aLisFil[  nFilial, 1 ])  //Filial no marcada, vai para proxima
				SM0->( dbSkip() )
				Loop
			Else
				lFilSCP	:=	GetNewPar("MV_FILSCP",.F.)
				//Tratamento para atender atualizao 1.14 Guia EFD-Contribuiµes - Registro 0035 - SCP
				If cIndNatJur$"03#04"
				    If lFilSCP				    	
				    	Reg0035(cAlias)
				    	SM0->( dbSkip() )
				    	Loop
				    EndIf
				ElseIf cIndNatJur$"05"
				    If lFilSCP
						Reg0035(cAlias)
					End If
				EndIf
			EndIf
	   Else
			SM0->( dbSkip() )
			Loop
	   EndIf
	Else
		If "1"  $ aWizard[1][6] //Somente faz skip se a opo de selecionar filiais estiver como Sim.
			 SM0->( dbSkip() )
			 Loop
		EndIf
	EndIf

	If lJob
		PtInternal(1,"SPED PIS/Cofins (Execucao Autom¡tica) - Emp: "+cEmpAnt+" - Filial: "+cFilAnt)
	EndIf

	lConcFil	:=  aParSX6[27]
	If lMtBlcP
		cNomeTRBP 		:= StrTran(( "SPDC"+CriaTrab(,.F.)+FWGrpCompany()+FWCodFil() ) , " " , "" )
	EndIF
	If cBlocoP <> "3" // Gerar exclusivamente informaµes do blocoP
		If lBlocACDF .OR. lRgCmpCons
			IncProc("Processando valores de Devoluµes")

			//Processa Devolucoes atraves da funcao SPEDDevol() - Devolucao de Venda	
			//If !cRegime == "1"
				SPEDDevol(dDataDe,dDataAte,cNrLivro,nMVM996TPR,lTop,"S",@aDevMsmPer,@aDevAntPer,cRegime)
			//Endif
			//Processa Devolucoes atraves da funcao SPEDDevol() - Devolucao de Compra	
			If !cRegime == "2"
		   		SPEDDevol(dDataDe,dDataAte,cNrLivro,nMVM996TPR,lTop,"E",@aDevCpMsmP,@aAjuCred,cRegime)
			Endif
		    IF lGrBlocoM
				IncProc("Processando cancelamento de per­odo anterior")
				//Ir¡ buscar valores de notas que foram canceladas em per­odo anterior, para fazer ajustes no bloco M.
				lGravaM220 := GrvNFCan(dDataDe,dDataAte,lCumulativ,cRegime,cNrLivro,nMVM996TPR,lTop)
			EndIF
		EndIF
	EndIf

	If Interrupcao(lEnd)

		// Verifica se o processamento sera em multithread
		If lProcMThr
			GeraTrb(2, @aArq, @cAlias,.T.,nHandleTRB,nMvQtdThr,cSemaphore )
		Else
			GeraTrb(2, @aArq, @cAlias)
		EndIf

	 	lCancel := lEnd
	    Return
	EndIf
	//Limpo as vari¡veis antes de comear o processamento da filial.
	//If cCGCAnt <> SM0->M0_CGC .Or. !lRepCGC //Tratamento para consolidar Filiais com mesmo CNPJ.
	If ( lZerVar := ( cCGCAnt <> SM0->M0_CGC .Or. !lRepCGC ) )
		nRelacFil		+= 1
		nPaiC			+= 1 // --
		lFilGra			:= .F.
		lGravaA010		:= .F.
		lGravaC010		:= .F.
		lGravaD010		:= .F.
		lGravaF010		:= .F.
		lGravaI010		:= .F.
		lGravaP010		:= .F.
		aReg0150 		:= {}
		aReg0190 		:= {}
		aReg0200 		:= {}
	 	aReg0205 		:= {}
	 	aReg0206 		:= {}
		aReg0400 		:= {}
		aReg0450 		:= {}
		aRegA010		:= {}
		aRegC010		:= {}
		aRegD010		:= {}
		aRegD200		:= {}
		aRegD201		:= {}
		aRegD205		:= {}
		aRegD209		:= {}
		aRegD300		:= {}
		aRegD350		:= {}
		aRegD359		:= {}
		aRegD309		:= {}
		aRegD600		:= {}
		aRegD601		:= {}
		aRegD605		:= {}
		aRegD609		:= {}
		aRegC180		:= {}
		aRegC181		:= {}
		aRegC185		:= {}
		aRegC188		:= {}
		aRegC190		:= {}
		aRegC191		:= {}
		aRegC195		:= {}
		aRegC198		:= {}
		aRegC199		:= {}
		aRegC380		:= {}
		aRegC381		:= {}
		aRegC385		:= {}
		aRegC395		:= {}
		aRegC396		:= {}
		aRegC600		:= {}
		aRegC601		:= {}
		aRegC605		:= {}
		aRegC609		:= {}
		aRegC400		:= {}
		aRegC405		:= {}
		aRegC481		:= {}
		aRegC485		:= {}
		aRegC489		:= {}
		aRegC490		:= {}
		aRegC491		:= {}
		aRegC495		:= {}
		aRegC499		:= {}
		aRegF010		:= {}
		aRegF100		:= {}
		aRegF111		:= {}
		aRegF120		:= {}
		aRegF129		:= {}
		aRegF130		:= {}
		aRegF139		:= {}
		aRegF150		:= {}
		aRegF200        := {}
		aRegF205        := {}
		aRegF210        := {}
		aRegF600		:= {}
		aRegF700		:= {}
		aRegP010		:= {}
		aRegP100		:= {}
		aRegF500		:= {}
		aRegF510		:= {}
		aRegF509		:= {}
		aRegF519		:= {}
		aTotF525		:= {0,0,0,0,0,0,0}
		aRegF525		:=  {}
		aRegF550		:=  {}
		aRegF560		:=  {}
		aRegF559		:=  {}
		aRegF569		:=  {}
		lGrava0140 		:= .F.
		nPos0200		:= 0
		nMTP			:= 0

	If cBlocoP <>"3"
		aReg0140 		:= {}
	Endif

	EndIf

	If cBlocoP <> "3" // Gerar exclusivamente informaµes do blocoP
	    IF lMVESTTELE .AND. lBlocACDF
	        If cCGCAnt <> SM0->M0_CGC .Or. !lRepCGC .Or. (lRepCGC .And. (aScan(aRegD010, {|aX| aX[2] == SM0->M0_CGC}) == 0)) //Tratamento para consolidar Filiais com mesmo CNPJ.
				lFirst := .F.
				RegD010(cAlias,@aRegD010, @nPaiD, @lGravaD010)
			EndIf

		    TeleComFut(dDataDe,dDataAte,@aRegD600,@aRegD601,@aRegD605,@aReg0500,@aRegM210,@aRegM610,aWizard,@aRegM400,@aRegM410,;
						@aRegM800,@aRegM810,.T.,cRegime)

			If lGravaD010
				PCGrvReg (cAlias, Iif(lProcMThr, nRelacFil , NIL ) , aRegD010,,,nPaiD,,,nTamTRBIt)
				lGravaD010 = .F.
			EndIf
		EndIF

		If !lProcMThr .AND. lMVGERNF .AND. lBlocACDF .And. FindFunction("SPDGERNF")
			If lZerVar .Or. (lRepCGC .And. (aScan(aRegC010, {|aX| aX[2] == SM0->M0_CGC}) == 0)) //Tratamento para consolidar Filiais com mesmo CNPJ.
			//If cCGCAnt <> SM0->M0_CGC .Or. !lRepCGC .Or. (lRepCGC .And. (aScan(aRegC010, {|aX| aX[2] == SM0->M0_CGC}) == 0)) //Tratamento para consolidar Filiais com mesmo CNPJ.
				lFirst := .F.
				RegC010(cAlias,@aRegC010, @nPaiC, @lGravaC010,aWizard[1][7] , lZerVar)
			EndIf

	        SPDGERNF(lEnerEle,lGravaC100,@nRelacDoc,cEntSai,nApurIpi,cSituaDoc,dDataDe,dDataAte,lConsolid,cAlias,lcumulativ,nRelacFil,aProd,cRegime,;
					@aReg0150,@aReg0200,@aReg0205,@aReg0190,@aReg0500,@aReg0600,@nPaiC,@nItemC170,@nPosC180,@aRegC170,@aRegC180,@aRegC181,;
					@aRegC185,@aRegM210,@aRegM610,@aRegM400,@aRegM410,@aRegM800,@aRegM810,@aRegC100,@aReg0400,@aReg0111,aRegC175)

			If lGravaC010
				PCGrvReg (cAlias, Iif(lProcMThr,nRelacFil,NIL)  ,aRegC010,,,nPaiC,,Iif(lProcMThr,.T.,NIL),nTamTRBIt)
				lGravaC010 := .F.
			EndIf
		EndIF
    EndIf

	If cBlocoP $ "1/3" .And. FindFunction("fS033Sped") .And. FindFunction("RhInssPat")

		IF lMtBlcP
			cJobPAux	:=	StrTran( "cPROCP" + FWGrpCompany() + FWCodFil() , ' ' , '_' ) + StrZero( 1 , 2 )
			PutGlbValue( cJobPAux , "0" )
			GlbUnLock()

			StartJob( "ThreadP" , GetEnvServer() , .F. ,lBlocoPRH,dDataDe, cEmpAnt, cFilAnt,@cAliasP,cJobPAux,cAliasPE,cNomeTRBP)
		Else
			If lBlocoPRH // Indica se buco as informaµes diretamente do RH
			   	IncProc("Buscando Informaµes bloco P Filial "+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL))
				conout("Inicio do P100: "+time())
				cAliasP:= fS033Sped(Alltrim(StrZero(Month(dDataDe),2))+Alltrim(Str(Year(dDataDe))) )
				conout("Fim do P100: "+time())
			Else		//Caso contr¡rio devo buscar as informaµes do Faturamento e aplicar a al­quota da tabela CG1 (5.1.1)
				IncProc("Buscando Informaµes bloco P Filial "+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL))
				conout("Inicio do P100: "+time())
				cAliasP:= RhInssPat(Alltrim(StrZero(Month(dDataDe),2))+Alltrim(Str(Year(dDataDe))))   
				conout("Fim do P100: "+time())
			EndIf

		EndIF

	EndIf

	cMvEstado	:=	SuperGetMv("MV_ESTADO",,"")
	lIntEasy	:= .F.
	lIntTMS :=	IntTms()
	If	aParSX6[17]=="S"
		lIntEasy	:= .T.
	EndIF

	//Processamento para apurao de PIS e COFINS para o Regime de Caixa.
	IF cIndLucPre == "1" .AND. !lBlocACDF .AND. !lBlocoI .AND. FindFunction("FinSpdF500")

		IncProc("Processando Valores do Regime de Caixa: Filial -  "+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL))
		//Chamada da funo do Financeiro para retornar os valores de baixas
		//no per­odo, para poder gerar os valores de PIS e COFINS para      
		//o Regime de Caixa.                                                
		FinSpdF500(Month(dDataDe),Year(dDataDe),cAliasF500)
		(cAliasF500)->( DBGOTOP())
		Do While !(cAliasF500)->( EOF())
			IncProc("Documento/S©rie : " + (cAliasF500)->NUMERO +  (cAliasF500)->SERIE +  " da Filial "+AllTrim(SM0->M0_FILIAL))
			//Chamada da funo para gerao dos registros referente a apurao de Regime de Caixa
			IF !(cTitOld == (cAliasF500)->FILIAL+(cAliasF500)->NUMERO+(cAliasF500)->TIPO+(cAliasF500)->CLIENTE+(cAliasF500)->LOJA+(cAliasF500)->DTMOV+(cAliasF500)->PARCELA + ALLTRIM(STR((cAliasF500)->NROREG))) 
			
				cTitOld := (cAliasF500)->FILIAL+(cAliasF500)->NUMERO+(cAliasF500)->TIPO+(cAliasF500)->CLIENTE+(cAliasF500)->LOJA+(cAliasF500)->DTMOV+(cAliasF500)->PARCELA+ ALLTRIM(STR((cAliasF500)->NROREG))
			
				RegimeCaix(cAliasF500,@aRegF500,@aRegF510,@aRegF525,@aReg0500,@aTotF525,;
							@aRegM400,@aRegM410,@aRegM800,@aRegM810,cIndCompRe,lTop,cAlias,;
							@aReg0200,@aReg0190,dDataDe,dDataAte,nRelacFil,@aReg0205,@aRegF509,;
							@aRegF519,@aReg1010,@aReg1020)
			EndIf				

			(cAliasF500)->( DBSKIP())
		EndDo

		//Atualizao dos valores do registro F525, com as receitas totalizados conforme 
		//Indicador da Composio da receita-campo 03 do registro F525                   
		AtuF525(@aRegF525, @aTotF525)

		//Chama funo para incluir os valores dos registros F500 e F510 para a apurao no bloco M
		CalcCaixa(@aRegM210,@aRegM610,aRegF500,aRegF510,@aAjusteR,@aAjusteA,lFilSCP,cIndNatJur)

		DbSelectArea(cAliasF500)
		(cAliasF500)->(dbCloseArea())
		FERASE(cAliasF500)

		Reg1900(@aReg1900,SM0->M0_CGC,dDataDe,dDataAte,cNrLivro,@aReg0500,aWizard,aCFOPs)

	EndIF

	
	For nContMov := 1 to Len(aTpMov)
		cTpMov:=aTpMov[nContMov]
		DbSelectArea (cAliasSFT)
		(cAliasSFT)->(DbSetOrder(2))
		IncProc("Buscando " + Iif(cTpMov=="E","Entradas","Sa­das") +" Notas da Filial "+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL))
		#IFDEF TOP
		    If (TcSrvType ()<>"AS/400")

				cFiltro 	:= "%"

				If cNrLivro <> "*"
					cFiltro += " SFT.FT_NRLIVRO = '" +%Exp:(cNrLivro)% +"' AND "
				EndIf

				IF cTpMov=="E"
					cFiltro		+= "(((SFT.FT_BASEPIS > 0  OR  SFT.FT_BASEPS3 > 0 ) OR SFT.FT_CSTPIS IN ('70','71','72','74','98','99'))  OR"
					cFiltro		+= " ( (SFT.FT_BASECOF > 0  OR  SFT.FT_BASECF3 > 0) OR SFT.FT_CSTCOF IN ('70','71','72','74','98','99')))  AND "
					IF (cRegime == "2") // Se for exclusivamente Cumulativo, ir¡ trazer somente notas de entradas que sejam devoluµes de vendas.
						cFiltro		+= " SFT.FT_TIPO = 'D' AND "
					EndIF
				Else
					cFiltro		+= "(( (SFT.FT_BASEPIS > 0  OR  SFT.FT_BASEPS3 > 0 ) OR SFT.FT_CSTPIS IN ('01','07','08','09','49'))  OR "
					cFiltro		+= " ( (SFT.FT_BASECOF > 0  OR  SFT.FT_BASECF3 > 0) OR SFT.FT_CSTCOF IN ('01','07','08','09','49')))  AND "

					//Somente ir¡ trazer movimentaµes de cupom para regime consolidado consolidado.
					IF !lRgCmpCons
						cFiltro		+= "SFT.FT_ESPECIE <> 'CF' AND "
					EndIF
				EndIF

				cFiltro += "%"

				cSlctSFT := "SFT.FT_FILIAL,  SFT.FT_TIPOMOV,	SFT.FT_ENTRADA, SFT.FT_SERIE,   SFT.FT_NFISCAL, SFT.FT_CLIEFOR,"
				cSlctSFT += "SFT.FT_LOJA,    SFT.FT_ITEM,   	SFT.FT_PRODUTO, SFT.FT_NRLIVRO, SFT.FT_CFOP,    SFT.FT_ESPECIE, "
				cSlctSFT += "SFT.FT_TIPO,    SFT.FT_EMISSAO,	SFT.FT_DTCANC,  SFT.FT_FORMUL,  SFT.FT_ALIQPIS, SFT.FT_VALPIS, "
				cSlctSFT += "SFT.FT_ALIQCOF, SFT.FT_VALCOF, 	SFT.FT_VALCONT, SFT.FT_BASEICM, SFT.FT_VALICM,  SFT.FT_ISSST, "
				cSlctSFT += "SFT.FT_BASERET, SFT.FT_ICMSRET,	SFT.FT_VALIPI,  SFT.FT_ISENICM, SFT.FT_QUANT,   SFT.FT_DESCONT, "
				cSlctSFT += "SFT.FT_TOTAL,   SFT.FT_FRETE,  	SFT.FT_SEGURO,  SFT.FT_DESPESA, SFT.FT_OUTRICM, SFT.FT_BASEIPI, "
				cSlctSFT += "SFT.FT_ISENIPI, SFT.FT_OUTRIPI,	SFT.FT_ICMSCOM, SFT.FT_RECISS,  SFT.FT_BASEIRR, SFT.FT_ALIQICM, "
				cSlctSFT += "SFT.FT_ALIQIPI, SFT.FT_CTIPI,  	SFT.FT_POSIPI,  SFT.FT_CLASFIS, SFT.FT_PRCUNIT, SFT.FT_CFPS, "
				cSlctSFT += "SFT.FT_OBSERV,  SFT.FT_ESTADO, 	SFT.FT_CODISS,  SFT.FT_ALIQIRR, SFT.FT_VALIRR,  SFT.FT_BASEINS, "
				cSlctSFT += "SFT.FT_VALINS,  SFT.FT_PDV,    	SFT.FT_ISSSUB,  SFT.FT_CREDST,  SFT.FT_ISENRET, SFT.FT_OUTRRET, "
				cSlctSFT += "SFT.FT_CONTA,   SFT.FT_BASEPIS,	SFT.FT_BASECOF, SFT.FT_PESO,    SFT.FT_SOLTRIB, SFT.FT_NFORI, "
				cSlctSFT += "SFT.FT_SERORI,  SFT.FT_ITEMORI,	SFT.FT_IDENTF3, SFT.FT_OBSSOL, 	SFT.FT_FORMULA, SFT.FT_BASECF3,"
				cSlctSFT += "SFT.FT_ALIQCF3,  SFT.FT_VALCF3,	SFT.FT_BASEPS3, SFT.FT_ALIQPS3, FT_VALPS3,FT_ALIQSOL"

				If aFieldPos[10]
					cSlctSFT += ", SFT.FT_CHVNFE"
				Endif
				cSlctSFT += ", SFT.FT_CSTPIS"
				cSlctSFT += ", SFT.FT_CSTCOF"
				cSlctSFT += ", SFT.FT_PAUTPIS"
				cSlctSFT += ", SFT.FT_PAUTCOF"
				cSlctSFT += ", SFT.FT_VALPS3"
				cSlctSFT += ", SFT.FT_VALCF3"

				If aFieldPos[24]
					cSlctSFT += ", SFT.FT_RGESPST"
				EndIf
				If aFieldPos[25]
					cSlctSFT += ", SFT.FT_PAUTIPI"
				EndIF
				If lCmpDescZF
					cSlctSFT += ", SFT.FT_DESCZFR"
				Endif
				If aFieldPos[26]
					cSlctSFT += ", SFT.FT_AGREG"
				Endif
				If lCmpDescIC
					cSlctSFT += ", SFT.FT_DESCICM"
				Endif

				cSlctSFT += ", SFT.FT_INDNTFR "
				cSlctSFT += ", SFT.FT_CODBCC "
				cSlctSFT += ", SFT.FT_TNATREC "
				cSlctSFT += ", SFT.FT_CNATREC "
				cSlctSFT += ", SFT.FT_GRUPONC "
				cSlctSFT += ", SFT.FT_DTFIMNT "
				cSlctSFT += ", SF4.F4_RGESPCI "
				cSlctSFT += ", SFT.FT_NORESP "

				If aFieldPos[4]
					cSlctSFT += ", SFT.FT_VRETPIS "
				EndIf

				If aFieldPos[5]
					cSlctSFT += ", SFT.FT_VRETCOF "
				EndIf

				If aFieldPos[13]
					cSlctSFT += ", SFT.FT_CODNFE "
				EndIf

				If aFieldPos[27]
					cSlctSFT += ", SFT.FT_NFELETR "
				EndIf

				If lCpoMajAli //SFT->(FieldPos("FT_MALQCOF")) > 0 .And. SFT->(FieldPos("FT_MVALCOF")) > 0
					cSlctSFT += ", SFT.FT_MVALCOF , SFT.FT_MALQCOF "
				EndIf

				If aFieldPos[28] .And. aFieldPos[29]
					cSlctSFT += ", SFT.FT_MVALPIS , SFT.FT_MALQPIS "
				EndIf

				If aFieldPos[3]
					cSlctSFT += ", SFT.FT_NATOPER"
				Endif

				cSlctSB1	:=	",SB1.B1_UM,    SB1.B1_SELO,	SB1.B1_TAB_IPI, SB1.B1_VLR_IPI, SB1.B1_TIPO,    SB1.B1_DESC, "
				cSlctSB1	+=	"SB1.B1_CODBAR, SB1.B1_CODANT,  SB1.B1_POSIPI,  SB1.B1_EX_NCM,  SB1.B1_CODISS,  SB1.B1_PICM, "
				cSlctSB1	+=	"SB1.B1_FECP,   SB1.B1_CC,		SB1.B1_SEGUM,   SB1.B1_TIPCONV, SB1.B1_CONV,    SB1.B1_VLR_PIS, "
				cSlctSB1	+=	"SB1.B1_VLR_COF,SB1.B1_CLASSE,  SB1.B1_CONTA,   SB1.B1_ORIGEM, 	SB1.B1_IMPORT,	SB1.B1_DTFIMNT, "
				cSlctSB1	+=	"SB1.B1_COD, 	SB1.B1_DATREF, 	SB1.B1_TNATREC, SB1.B1_CNATREC, SB1.B1_GRPNATR, "

				If aFieldPos[22]
					cSlctSB1 += "SB1.B1_TPREG,"
				Endif
				
				If "B1_"$cMVDTINCB1
					If SB1->(FieldPos(cMVDTINCB1))>0
						cSlctSB1	+=	cMVDTINCB1+","
					EndIf
				EndIf

				//Campos para o SELECT da tabela SD2 ou SD1
				If cTpMov=="E"
					cSlctD1D2	:=	"SD1.D1_CONTA,SD1.D1_CC,SD1.D1_UM,SD1.D1_PEDIDO,SD1.D1_ITEM "
				Else
					cSlctD1D2	:=	"SD2.D2_TES,SD2.D2_CCUSTO,SD2.D2_CONTA,SD2.D2_UM,SD2.D2_PEDIDO "

					IF lCmpD2VlPC
						cSlctD1D2	+=	",SD2.D2_VALCOF,SD2.D2_VALPIS"
					EndIF

				EndIf

				//Campos para o SELECT da tabela SF2 ou SF1
				If cTpMov=="E"
					cSlctF1F2	:=	",SF1.F1_TIPO,SF1.F1_HAWB,SF1.F1_SERIE,SF1.F1_PREFIXO "
					If lF1TPCTE
						cSlctF1F2 += ", SF1.F1_TPCTE "
					EndIF
					If lF1TPFrete
						cSlctF1F2 += ", SF1.F1_TPFRETE "
					EndIF
					If lF1Mennota
						cSlctF1F2 += ", SF1.F1_MENNOTA "
					EndIf
				Else
					cSlctF1F2	:=	",SF2.F2_TIPO,SF2.F2_SERIE,SF2.F2_PREFIXO "
					If lF2NFCUPOM
						cSlctF1F2 += ", SF2.F2_NFCUPOM "
					EndIF
					If lF2Mennota
						cSlctF1F2 += ", SF2.F2_MENNOTA "
					EndIf
				EndIf

				If lTabComp
					cSlctComp	:=	",SFU.R_E_C_N_O_ SFURECNO"
					cSlctComp	+=	",SFX.R_E_C_N_O_ SFXRECNO"
					cSlctComp	+=	",CD3.R_E_C_N_O_ CD3RECNO"

					cJoinCompl	:=	"LEFT JOIN "+RetSqlName("SFU")+" SFU ON(SFU.FU_FILIAL='"+xFilial("SFU")+"' AND SFU.FU_TIPOMOV=SFT.FT_TIPOMOV AND SFU.FU_SERIE=SFT.FT_SERIE AND SFU.FU_DOC=SFT.FT_NFISCAL AND SFU.FU_CLIFOR=SFT.FT_CLIEFOR AND SFU.FU_LOJA=SFT.FT_LOJA AND SFU.FU_ITEM=SFT.FT_ITEM AND SFU.FU_COD=SFT.FT_PRODUTO AND SFU.D_E_L_E_T_='')"
					cJoinCompl	+=	"LEFT JOIN "+RetSqlName("SFX")+" SFX ON(SFX.FX_FILIAL='"+xFilial("SFX")+"'  AND SFX.FX_TIPOMOV=SFT.FT_TIPOMOV AND SFX.FX_SERIE=SFT.FT_SERIE AND SFX.FX_DOC=SFT.FT_NFISCAL AND SFX.FX_CLIFOR=SFT.FT_CLIEFOR AND SFX.FX_LOJA=SFT.FT_LOJA AND SFX.FX_ITEM=SFT.FT_ITEM AND SFX.FX_COD=SFT.FT_PRODUTO AND SFX.D_E_L_E_T_='') "
					cJoinCompl	+=	"LEFT JOIN "+RetSqlName("CD3")+" CD3 ON(CD3.CD3_FILIAL='"+xFilial("CD3")+"' AND CD3.CD3_TPMOV=SFT.FT_TIPOMOV AND CD3.CD3_SERIE=SFT.FT_SERIE AND CD3.CD3_DOC=SFT.FT_NFISCAL AND CD3.CD3_CLIFOR=SFT.FT_CLIEFOR AND CD3.CD3_LOJA=SFT.FT_LOJA AND CD3.CD3_ITEM=SFT.FT_ITEM AND CD3.CD3_COD=SFT.FT_PRODUTO AND CD3.D_E_L_E_T_='') "
				EndIf

				If lTabCD1
					If aFieldPos[3]
						cSlctComp	+=	",CD1.R_E_C_N_O_ CD1RECNO"
						cJoinCompl	+=	"LEFT JOIN "+RetSqlName("CD1")+" CD1 ON(CD1.CD1_FILIAL='"+xFilial("CD1")+"' AND CD1.CD1_CODNAT=SFT.FT_NATOPER AND CD1.D_E_L_E_T_='') "
					Endif
				Endif

				cSlctALL := cSlctSFT+cSlctSB1+cSlctD1D2+cSlctF1F2+cSlctComp

				cOrderBy	:=	"%ORDER BY 1,2,3,4,5,6,7,8,9%"
				cSlctALL := "%" + cSlctALL + "%"
				//JOIN SF1 e SF2
				If cTpMov=="E"
					cJoinF1F2	:=	"LEFT JOIN "+RetSqlName("SF1")+" SF1 ON(SF1.F1_FILIAL='"+xFilial("SF1")+"'  AND SF1.F1_DOC=SFT.FT_NFISCAL AND SF1.F1_SERIE=SFT.FT_SERIE AND SF1.F1_FORNECE=SFT.FT_CLIEFOR AND SF1.F1_LOJA=SFT.FT_LOJA AND SF1.D_E_L_E_T_=' ') "
					cJoinF1F2	+=	"LEFT JOIN "+RetSqlName("SD1")+" SD1 ON(SD1.D1_FILIAL='"+xFilial("SD1")+"'  AND SD1.D1_DOC=SFT.FT_NFISCAL AND SD1.D1_SERIE=SFT.FT_SERIE AND SD1.D1_FORNECE=SFT.FT_CLIEFOR AND SD1.D1_LOJA=SFT.FT_LOJA AND SD1.D1_COD=SFT.FT_PRODUTO AND SD1.D1_ITEM=SFT.FT_ITEM AND SD1.D_E_L_E_T_=' ') "
					cJoinF1F2	+=	"LEFT JOIN "+RetSqlName("SF4")+" SF4 ON(SF4.F4_FILIAL='"+xFilial("SF4")+"'  AND SD1.D1_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_=' ') "
				Else
					cJoinF1F2	:=	"LEFT JOIN "+RetSqlName("SF2")+" SF2 ON(SF2.F2_FILIAL='"+xFilial("SF2")+"'  AND SF2.F2_DOC=SFT.FT_NFISCAL AND SF2.F2_SERIE=SFT.FT_SERIE AND SF2.F2_CLIENTE=SFT.FT_CLIEFOR AND SF2.F2_LOJA=SFT.FT_LOJA AND SF2.D_E_L_E_T_=' ') "
					cJoinF1F2	+=	"LEFT JOIN "+RetSqlName("SD2")+" SD2 ON(SD2.D2_FILIAL='"+xFilial("SD2")+"'  AND SD2.D2_DOC=SFT.FT_NFISCAL AND SD2.D2_SERIE=SFT.FT_SERIE AND SD2.D2_CLIENTE=SFT.FT_CLIEFOR AND SD2.D2_LOJA=SFT.FT_LOJA AND SD2.D2_COD=SFT.FT_PRODUTO AND SD2.D2_ITEM=SFT.FT_ITEM AND SD2.D_E_L_E_T_=' ') "
					cJoinF1F2	+=	"LEFT JOIN "+RetSqlName("SF4")+" SF4 ON(SF4.F4_FILIAL='"+xFilial("SF4")+"'  AND SD2.D2_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_=' ') "
				EndIf
				
				cJoinF1F2 := "%" + cJoinF1F2
				//cJoinD1D2	:=	""

				//Faz com JOIN SD1 e SD2
				/*
				If cTpMov=="E"
					cJoinD1D2	:=	"LEFT JOIN "+RetSqlName("SD1")+" SD1 ON(SD1.D1_FILIAL='"+xFilial("SD1")+"'  AND SD1.D1_DOC=SFT.FT_NFISCAL AND SD1.D1_SERIE=SFT.FT_SERIE AND SD1.D1_FORNECE=SFT.FT_CLIEFOR AND SD1.D1_LOJA=SFT.FT_LOJA AND SD1.D1_COD=SFT.FT_PRODUTO AND SD1.D1_ITEM=SFT.FT_ITEM AND SD1.D_E_L_E_T_=' ') "
					cJoinD1D2	:=	"LEFT JOIN "+RetSqlName("SF4")+" SF4 ON(SF4.F4_FILIAL='"+xFilial("SF4")+"'  AND SD1.D1_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_=' ') "
				Else
					cJoinD1D2	:=	"LEFT JOIN "+RetSqlName("SD2")+" SD2 ON(SD2.D2_FILIAL='"+xFilial("SD2")+"'  AND SD2.D2_DOC=SFT.FT_NFISCAL AND SD2.D2_SERIE=SFT.FT_SERIE AND SD2.D2_CLIENTE=SFT.FT_CLIEFOR AND SD2.D2_LOJA=SFT.FT_LOJA AND SD2.D2_COD=SFT.FT_PRODUTO AND SD2.D2_ITEM=SFT.FT_ITEM AND SD2.D_E_L_E_T_=' ') "
					cJoinD1D2	:=	"LEFT JOIN "+RetSqlName("SF4")+" SF4 ON(SF4.F4_FILIAL='"+xFilial("SF4")+"'  AND SD2.D2_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_=' ') "
				EndIf
				*/
				//cJoinD1D2 := "%" + cJoinD1D2
				cJoinCompl := " " + cJoinCompl + "%"

				cAliasSFT		:=	GetNextAlias()

		    	BeginSql Alias cAliasSFT

		    		COLUMN FT_EMISSAO AS DATE
			    	COLUMN FT_ENTRADA AS DATE
			    	COLUMN FT_DTCANC AS DATE

			    	SELECT
						%Exp:cSlctALL%

					FROM.
						%Table:SFT% SFT
						LEFT JOIN %Table:SB1% SB1 ON(SB1.B1_FILIAL=%xFilial:SB1%  AND SB1.B1_COD=SFT.FT_PRODUTO AND SB1.%NotDel%)
						%Exp:cJoinF1F2+cJoinCompl%
					WHERE
						SFT.FT_FILIAL=%xFilial:SFT% AND
						SFT.FT_TIPOMOV = %Exp:cTpMov% AND
						SFT.FT_ENTRADA>=%Exp:DToS (dDataDe)% AND
						SFT.FT_ENTRADA<=%Exp:DToS (dDataAte)% AND
						SFT.FT_NFISCAL <> ' ' AND
						((SFT.FT_CFOP NOT LIKE '000%' AND SFT.FT_CFOP NOT LIKE '999%') OR SFT.FT_TIPO='S') AND
						%Exp:cFiltro%
						SFT.%NotDel%

					%Exp:cOrderBy%
				EndSql

			Else
		#ENDIF

		    cIndex	:= CriaTrab(NIL,.F.)
		    cFiltro	:= 'FT_FILIAL=="'+xFilial ("SFT")+'".And.'
		    cFiltro += 'FT_TIPOMOV=="'+cTpMov+'" .And. '
		    cFiltro += 'DToS (FT_ENTRADA)>="'+DToS (dDataDe)+'".And.DToS (FT_ENTRADA)<="'+DToS (dDataAte)+'" '
			cFiltro += '.And. (!SubStr (FT_CFOP,1,3)$"999/000" .Or. FT_TIPO=="S")'
			//Somente ir¡ trazer operaµes de cupom fiscal para regime de competencia consolidado.
			IF !lRgCmpCons
				cFiltro		+= ' .AND. FT_ESPECIE <> "CF" '
			EndIF

	   		IF cTpMov=="E"
				cFiltro += '.And.((FT_BASEPIS>0.OR.FT_CSTPIS$"70#71#72#74#98#99").OR.(FT_BASECOF>0 .OR.FT_CSTCOF$"70#71#72#74#98#99"))'
				IF (cRegime == "2") // Se for exclusivamente Cumulativo, ir¡ trazer somente notas de entradas que sejam devoluµes de vendas.
					cFiltro	+= ".AND.FT_TIPO=='D'"
				EndIF
			Else
				cFiltro += '.And. (((FT_BASEPIS > 0  .OR.  FT_BASEPS3 > 0) .OR. FT_CSTPIS $"07#08#09#49") .OR. ((FT_BASECOF > 0  .OR.  FT_BASECF3 > 0)  .OR. FT_CSTCOF $"07#08#09#49") )  '

			EndIF

		    If (cNrLivro<>"*")
			    cFiltro	+=	'.And.FT_NRLIVRO=="'+cNrLivro+'" '
		   	EndIf

		    IndRegua (cAliasSFT, cIndex, SFT->(IndexKey ()),, cFiltro)
		    nIndex := RetIndex(cAliasSFT)

			#IFNDEF TOP
				DbSetIndex(cIndex+OrdBagExt ())
			#ENDIF

			DbSelectArea(cAliasSFT)
		    DbSetOrder(nIndex+1)

			DbSelectArea (cAliasSFT)
			(cAliasSFT)->(DbGoTop ())
	#IFDEF TOP
		Endif
	#ENDIF
		IncProc("Finalizando pesquisa das notas de " + Iif(cTpMov=="E","Entradas","Sa­das") )
		If lTop
			cAliasSB1		:=	cAliasSFT
			cAliasSF4		:=	cAliasSFT
			cAliasSD1		:=	cAliasSFT
			cAliasSD2		:=	cAliasSFT
			cAliasSF1		:=	cAliasSFT
			cAliasSF2		:=	cAliasSFT
		EndIf

		If aExstBlck[07] // ExistBlock("SPDPCANT")
			aSPDPCAnt := ExecBlock("SPDPCANT", .F., .F., { aRegM300,aRegM700,dDataDe,dDataAte } )
			aRegM300	:= aSPDPCAnt[1]
			aRegM700	:= aSPDPCAnt[2]
		EndIf

		DbSelectArea (cAliasSFT)
		(cAliasSFT)->(DbGoTop ())
		ProcRegua ((cAliasSFT)->(RecCount ()))
		IncProc("Preparando para iniciar blocos A\C\D Filial "+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL))
		Do While !(cAliasSFT)->(Eof ())
	        //Verifica se o processamento foi cancelado
			If Interrupcao(lEnd)
				// Verifica se o processamento sera em multithread
				If lProcMThr
					GeraTrb(2, @aArq, @cAlias,.T.,nHandleTRB,nMvQtdThr,cSemaphore )
				Else
					GeraTrb(2, @aArq, @cAlias)
				EndIf

			 	lCancel := lEnd
			    Return
			EndIf
			cLancam			:=	""
			cEspecie		:=	AModNot ((cAliasSFT)->FT_ESPECIE)		//Modelo NF
		    lGrava0140 		:= Iif(lRepCGC,Iif(cCGCAnt <> SM0->M0_CGC .Or. (aScan(aReg0140, {|aX| aX[4] == SM0->M0_CGC}) == 0),.T.,.F.),.T.) //Tratamento para consolidar Filiais com mesmo CNPJ.

			//FT_PDV somente estara  alimentado quando se referir a nota fiscais de saida 
			//geradas pelo SIGALOJA.                                                      
			If !Empty((cAliasSFT)->FT_PDV) .AND. AllTrim((cAliasSFT)->FT_ESPECIE)$"CF/ECF"
				cEspecie	:=	"2D"
			EndIF

			IncProc("Nota : " + (cAliasSFT)->FT_NFISCAL + " da Filial " +AllTrim(SM0->M0_FILIAL))
			If lRgCmpCons // Regime de competencia consolidado
				//Tratamento para regime de competencia consolidado

				cCfop	:= AllTrim((cAliasSFT)->FT_CFOP)

				//Se a esp©cie for diferente de "01/04/1B/55" ir¡ verificar os CFOPs de receita para pode gerar os registros.
				If !cEspecie $ "01/04/1B/55" .OR. (cCfop$aCFOPs[01] .Or. cCfop$aCFOPs[03]) .AND. !(cCfop$aCFOPs[02])

					lDevolucao	:= .F.
					nPosDev := aScan (aDevMsmPer, {|aX| aX[1]==(cAliasSFT)->FT_NFISCAL .AND. aX[2]==(cAliasSFT)->FT_EMISSAO .AND. aX[3]==(cAliasSFT)->FT_SERIE .AND. aX[4]==(cAliasSFT)->FT_ITEM  .AND. aX[5]==(cAliasSFT)->FT_CLIEFOR  .AND. aX[6]==(cAliasSFT)->FT_LOJA })
					IF nPosDev > 0
						lDevolucao	:= .T.
					EndIF

					aParF550 		:=	{}
					lPauta			:= .F.
					If (cAliasSFT)->FT_PAUTPIS > 0 .OR. (cAliasSFT)->FT_PAUTCOF > 0
						lPauta	:= .T.
						aBaseAlqUn	:=	VlrPauta(lCmpNRecFT, lCmpNRecB1, "PIS",		cAliasSFT,cAliasSB1,lCmpNRecF4,.T.)
						nAlqPis 	:= 	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][1] , (cAliasSFT)->FT_PAUTPIS)
						nBasePis  	:= 	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][2] , (cAliasSFT)->FT_QUANT)
						nValPis		:=	(cAliasSFT)->FT_VALPIS

						aBaseAlqUn	:=	VlrPauta(lCmpNRecFT, lCmpNRecB1, "COF",cAliasSFT,cAliasSB1,lCmpNRecF4,.T.)
						nAlqCof 	:= 	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][1] , (cAliasSFT)->FT_PAUTCOF)
						nBaseCof  	:= 	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][2] , (cAliasSFT)->FT_QUANT)
						nValCof		:=	(cAliasSFT)->FT_VALCOF

						If lDevolucao
							nValExcluP:= aDevMsmPer[nPosDev][7]
							nValExcluC:= aDevMsmPer[nPosDev][9]
						EndIf
					Else
						nAlqPis		:= (cAliasSFT)->FT_ALIQPIS
						nBasePis	:= IIF(!lDevolucao,(cAliasSFT)->FT_BASEPIS,(cAliasSFT)->FT_BASEPIS - aDevMsmPer[nPosDev][7])
						nValPis		:= IIF(!lDevolucao,(cAliasSFT)->FT_VALPIS,(cAliasSFT)->FT_VALPIS - aDevMsmPer[nPosDev][8])
						nAlqCof		:= (cAliasSFT)->FT_ALIQCOF
						nBaseCof	:= IIF(!lDevolucao,(cAliasSFT)->FT_BASECOF,(cAliasSFT)->FT_BASECOF - aDevMsmPer[nPosDev][9])
						nValCof		:= IIF(!lDevolucao,(cAliasSFT)->FT_VALCOF,(cAliasSFT)->FT_VALCOF - aDevMsmPer[nPosDev][10])

						nValExcluP	:= nValExcluC	:= Iif(lValExclu,(cAliasSFT)->FT_ICMSRET+(cAliasSFT)->FT_VALIPI+(cAliasSFT)->FT_DESCONT,0)

						If lDevolucao
							nValExcluP+= aDevMsmPer[nPosDev][7]
							nValExcluC+= aDevMsmPer[nPosDev][9]
						EndIf

       				EndIF

					// Receita Auferida:
					// Segundo a Consultoria Tributaria, o valor para o Registro F550, M400 e M800 deve ser o valor total sem desconto.
					// Por©m, devem ser considerados os valores dos tributos calculados "por dentro". Por isso, utilizar o FT_VALCONT e acrescentar o desconto.
					// Links: http://tdn.totvs.com/pages/viewpage.action?pageId=105316901 (desconto) e http://tdn.totvs.com/pages/releaseview.action?pageId=152801774 (ICMS)
					nRecAuf := (cAliasSFT)->FT_VALCONT + (cAliasSFT)->FT_DESCONT

					//Preenche array para gerao dos registros F550/F560
					aAdd(aParF550,Iif (lPauta,"F560","F550"))
					aAdd(aParF550,nRecAuf)
					aAdd(aParF550,(cAliasSFT)->FT_CSTPIS)
					aAdd(aParF550,nValExcluP)
					aAdd(aParF550,nBasePis)
					aAdd(aParF550,nAlqPis)
					aAdd(aParF550,nValPis)
					aAdd(aParF550,(cAliasSFT)->FT_CSTCOF)
					aAdd(aParF550,nValExcluC)
					aAdd(aParF550,nBaseCof)
					aAdd(aParF550,nAlqCof)
					aAdd(aParF550,nValCof)
					aAdd(aParF550,cEspecie)
					aAdd(aParF550,(cAliasSFT)->FT_CFOP )
					cConta	:= Reg0500(@aReg0500,(cAliasSFT)->FT_CONTA)
					aAdd(aParF550,cConta)
					aAdd(aParF550,"")
					aAdd(aParF550,(cAliasSFT)->FT_TNATREC)
					aAdd(aParF550,(cAliasSFT)->FT_CNATREC)
					aAdd(aParF550,(cAliasSFT)->FT_GRUPONC)
					aAdd(aParF550,(cAliasSFT)->FT_DTFIMNT)

					cSituaDoc		:=	SPEDSitDoc (, cAliasSFT,,,dDataDe,dDataAte)

 					IF !(cSituaDoc$"02#04#05")
						//Preenche array para pesquisar os processos referenciados vinculados a nota fiscal
						aParCDG	:= {}
						aAdd(aParCDG,(cAliasSFT)->FT_TIPOMOV)
						aAdd(aParCDG,(cAliasSFT)->FT_NFISCAL)
						aAdd(aParCDG,(cAliasSFT)->FT_SERIE)
						aAdd(aParCDG,(cAliasSFT)->FT_CLIEFOR)
						aAdd(aParCDG,(cAliasSFT)->FT_LOJA)

						lAchouCDG:= SPEDFFiltro(1,"CDG2",@cAliasCDG,aParCDG)

						//Funo para gerar registros F550/F560 e filhos
						RegimeComp(@aRegF550,@aRegF560,@aRegM210,@aRegM610,aParF550,lPauta,@aRegM400,@aRegM410,@aRegM800,;
									@aRegM810,lAchouCDG,cAliasCDG,lTop,@aRegF559,@aRegF569,@aReg1010,@aReg1020,@aReg0500,;
									.F.,cAliasSFT,@aRegM230,@aRegM630,@aRegM220,@aRegM620,aDevolucao,aDevMsmPer,,,nRecAuf)

						IF lFilSCP .And. !(cIndNatJur$"03#04#05")
							SpedXAjSCP(1,cAliasSFT,@aAjusteR,@aAjusteA,.T.,cRegime,dDataAte)
						EndIf
					EndIF

					//Funo para detalhar o documento no registro 1900
					Reg1900Com (@aReg1900,Iif(Empty(cEspecie),"98",cEspecie), cConta, cSituaDoc,SM0->M0_CGC,(cAliasSFT)->FT_SERIE,;
							   (cAliasSFT)->FT_VALCONT,(cAliasSFT)->FT_CSTPIS, (cAliasSFT)->FT_CSTCOF, (cAliasSFT)->FT_CFOP,"",aRegNf,cAliasSFT)

					SPEDFFiltro(2,,cAliasCDG)
				EndIF

                //No ir¡ processar regime de competencia detalhado nos blocos A, C, D e F.
				(cAliasSFT)->(DbSkip ())
				Loop
			EndIF
            //   Os 2 espacos refere-se a NFS pois a especie vem em branco nao pode ser removido.
			If !(cEspecie$"01#02#04#06#07#08#09#10#11#13#18#21#26#28#29#22#2D#55#57#1B#  #65#")
				(cAliasSFT)->(DbSkip ())
				Loop
			EndIf

			//„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„ Inicializacao de variaveis utilizadas no processamento „„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„
			cEntSai			:=	Iif ("E"$(cAliasSFT)->FT_TIPOMOV, "1", "2")
			cAlsSF			:=	"SF"+cEntSai	//Determina o Alias para as Tabelas SF1/SF2
			cAlsSD			:=	"SD"+cEntSai	//Determina o Alias para as Tabelas SD1/SD2
			lAchSFSD  		:= .F.
			lAchouSF1 		:= .F.
			lAchouSF2 		:= .F.
			cTipoNf         := (cAliasSFT)->FT_TIPO
			cCmpMenNota	:=	SubStr(cAlsSF,2,2)+"_MENNOTA"
			cCmpMenNota	:=	Iif((cAlsSF)->(FieldPos(cCmpMenNota))>0, cCmpMenNota, "")

			(cAlsSF)->(MsSeek (xFilial (cAlsSF)+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA))
			If cEntSai == "1"
				IF lTop
   	 		 	    cCmpTPCTE	:=	Iif(lF1TPCTE,(cAliasSF1)->F1_TPCTE,"")
					lAchSFSD 	:=	.T.
					clFSerie	:= 	(cAliasSF1)->F1_SERIE

				Else
					If(cAliasSF1)->(MsSeek (xFilial ("SF1")+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA))
	   	 		 	    cCmpTPCTE	:=	Iif(lF1TPCTE,(cAliasSF1)->F1_TPCTE,"")
						lAchSFSD 	:=	.T.
						clFSerie	:= 	(cAliasSF1)->F1_SERIE
					EndiF
				EndIF
			Else
				IF lTop
					If lF2NFCUPOM .And. !Empty((cAliasSF2)->F2_NFCUPOM)
						(cAliasSFT)->(DbSkip ())
						Loop
					EndIf
					lAchSFSD 	:=	.T.
					clFSerie	:= 	(cAliasSF2)->F2_SERIE

				Else
					(cAliasSF2)->(DbSetOrder(1))
					If	(cAliasSF2)->(MsSeek (xFilial ("SF2")+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA))
						If lF2NFCUPOM .And. !Empty((cAliasSF2)->F2_NFCUPOM)
							(cAliasSFT)->(DbSkip ())
							Loop
						EndIf
						lAchSFSD 	:=	.T.
						clFSerie	:= 	(cAliasSF2)->F2_SERIE
					EndIF
				EndIF
			EndIF

			cAlsSA			:=	"SA"+Iif ((cEntSai=="1" .And. !cTipoNf$"BD") .or.;
										  (cEntSai=="2" .And. cTipoNf$"BD"), "2", "1")	//Determina o Alias para as Tabelas SA1/SA2

							//   1  2  3   4  5  6  7  8  9  10 11 12 13 14  15 16 17 18 19 20 21 22  23 24 25 26 27 28 29  30 31 32 33 34
			aTotaliza		:=	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
			nRelacDoc++		//Utilizado para relacionar os documentos fiscais aos seus elementos inferiores/dependentes
			//Limpo as vari¡veis aintes de comear o processamento das notas. 
			nItem			:=	1
			aAverage		:=  {}
			aRegC100		:=	{}
			aRegC175		:=	{}
			aRegC110		:=	{}
			aRegC111		:=	{}
			aRegA100        :=  {}
			aRegA110		:=  {}
			aRegA111		:=	{}
			aRegA120        :=  {}
			aRegA170        :=  {}
			aRegC120		:=	{}
			aRegC395		:=  {}
			aRegC396		:=  {}
			aRegC500		:=  {}
			aRegC501		:=  {}
			aRegC505		:=  {}
			aRegC509		:=  {}
			aRegD100		:=  {}
			aRegD101		:=  {}
			aRegD105		:=  {}
			aRegD111		:=  {}
			aRegD500		:=  {}
			aRegD501		:=  {}
			aRegD505		:=  {}
			aRegD509		:=  {}
			lAchouSFU		:=	.F.
			lAchouSFX		:=	.F.
			lAchouSE4		:=	.F.
			lAchouCDG		:=	.F.
			lAchouCD5		:=	.F.
			lAchouCDT		:=	.F.
			lAchouCDC		:=	.F.
			lAchouSF4		:=	.F.
			lAchouCD3		:=	.F.
			lAchouCD4		:=	.F.
			lAchouCD6		:=	.F.
			lAchouSC6		:=	.F.
			lGrava0150      :=	.F.
			lPisZero		:=  .F.
			lCofZero		:=  .F.
			lNCodPart		:=	.F.
			lImport := Iif(Substr((cAliasSFT)->FT_CFOP,1,1) == "3",.T.,.F.)

			lEnerEle		:=  (cEspecie=="55") .AND. (SubStr((cAliasSFT)->FT_CFOP,1,3)$cCFOPEElet)
			
			If lTabCDT
				cCDTChv := xFilial("CDT")+(cAliasSFT)->FT_TIPOMOV+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA 
				lAchouCDT := SPEDSeek("CDT",1,cCDTChv)
		  
			   	lSitDocCDT	:= lSitDocExt .AND. lAchouCDT
				
				If lAchouCDT
					If lSitDocExt
						cSitExt := CDT->CDT_SITEXT
					EndIf
				EndIf
			EndIf
			
			cSituaDoc		:=	SPEDSitDoc (, cAliasSFT,,,dDataDe,dDataAte,,lSitDocCDT,cSitExt)

			cOpSemF			:=	LeParSeq("MV_OPSEMF")

			cFrete := ""
			If lTabCDT
				If CDT->(MsSeek (xFilial ("CDT")+(cAliasSFT)->FT_TIPOMOV+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA))
					If lCDT_INDFRT
						If !Empty(CDT->CDT_INDFRT)
							cFrete := CDT->CDT_INDFRT
						EndIf
					EndIf
				EndIf
			EndIf
			cCmpCondP		:=	cAlsSF+"->"+SubStr (cAlsSF, 2, 2)+"_COND"
			cCmpFrete		:=	cAlsSF+"->"+SubStr (cAlsSF, 2, 2)+"_FRETE"
			cCmpTes			:=	cAlsSD+"->"+SubStr (cAlsSD, 2, 2)+"_TES"
			cCmpUm			:=	cAlsSD+"->"+SubStr (cAlsSD, 2, 2)+"_UM"
			cCmpValPis		:=	cAlsSD+"->"+Substr (cAlsSD, 2, 2)+"_VALPIS"
			cCmpValCof		:=	cAlsSD+"->"+Substr (cAlsSD, 2, 2)+"_VALCOF"
			cIndEmit		:=	""
			cChvNfe			:=	""
			cChvCte			:=  ""
			cPrefixo		:=	&(cAlsSF+"->"+SubStr (cAlsSF, 2, 2)+"_PREFIXO")

			//lNewCFrt - Verifica se deve adotar a nova regra do codigo Indicador tipo frete
			//Conforme publicado no guia pratico Verso 2.0.7                               
			lNewCFrt := ((cAliasSFT)->FT_EMISSAO >= CtoD("01/01/2012"))


			If lIntTMS .AND. cEspecie$"#07#08#09#10#11#26#27#57" .And. "S"$(cAliasSFT)->FT_TIPOMOV
				If (DT6->DT6_TIPFRE$"1")		//1=CIF, 2=FOB
					cFrete	:=	Iif(lNewCFrt,"0","1") 										//Por conta do emitente = CIF = 1														//Por conta do emitente = CIF
				ElseIf (DT6->DT6_TIPFRE$"2")	//1=CIF, 2=FOB
					cFrete	:=	Iif(lNewCFrt,"1","2") 		   								//Por conta do destinatario = FOB = 2
				Else
					cFrete	:=	Iif(lNewCFrt,"2","0") 										//Apesar do sistema gravar 2=FOB, o devedor do frete pode ser o consignatario, espachante ou outros.
				EndIf
			Else
				If cFrete == ""
					If !Empty(cOpSemF) .And. AllTrim((cAliasSFT)->FT_CFOP)$cOpSemF
						cFrete	:= "9"
					Else
						cFrete	:=  SPEDSitFrt(cAliasSFT,cAlsSD,lTop,cAlsSF,cCmpFrete,lAchSFSD,lTop,lF1TpFrete)

			   		EndIf
				EndIf
			EndIf


			aCmpAntSFT		:={	(cAliasSFT)->FT_NFISCAL,;															//01
								(cAliasSFT)->FT_SERIE,;																//02
								(cAliasSFT)->FT_CLIEFOR,;															//03
								(cAliasSFT)->FT_LOJA,;																//04
								Iif((cEntSai=="2" .And. lMVCF3ENTR) .Or.cEntSai=="1",(cAliasSFT)->FT_ENTRADA,CToD("  /  /  ")),;		//05
								(cAliasSFT)->FT_EMISSAO,;	 														//06
								(cAliasSFT)->FT_DTCANC,;	   														//07
								(cAliasSFT)->FT_FORMUL,;															//08
								(cAliasSFT)->FT_CFOP,;		  														//09
								cLancam,;																			//10	//(cAliasSFT)->FT_LANCAM
								(cAliasSFT)->FT_ALIQICM,;															//11
								(cAliasSFT)->FT_PDV,;																//12
								(cAliasSFT)->FT_BASEICM,;															//13
								(cAliasSFT)->FT_ALIQICM,;	 														//14
								(cAliasSFT)->FT_VALICM,;	 														//15
								(cAliasSFT)->FT_ISENICM,;			 												//16
								(cAliasSFT)->FT_OUTRICM,;	  														//17
								(cAliasSFT)->FT_ICMSRET,;	   														//18
								(cAliasSFT)->FT_CONTA,;																//19
								(cAliasSFT)->FT_TIPO,;         														//20
								cFrete,;					  														//21
								(cAliasSFT)->FT_FILIAL,;								  							//22
								(cAliasSFT)->FT_ENTRADA,;								  							//23
								cPrefixo				,;															//24 - Prefixo do titulo
								(cAliasSFT)->FT_OBSERV,;                                                           //25 - Observacao
								cCmpTPCTE,;                                                                         //26 - Flag de tipo de CTE na entrada
								(cAliasSFT)->FT_NFELETR,;															//27 - Numero da RPS - Utilizado no registro A100
							   	clFSerie,;																			//28 - Serie da nota fiscal
							   	Iif(lAchSFSD,(Iif(lTop,cAliasSFT,cAlsSF))->(&(cCmpMenNota)),"")}					//29 - Mensagem da Nota Fiscal 				}															//29 - Serie da nota fiscal


			//Verifica se e NF de emissao propria
			If (Empty ((cAliasSFT)->FT_FORMUL)) .And. cEntSai=="1"
				cIndEmit := "1"			//Emissao de Terceiros
			ElseIf (Empty ((cAliasSFT)->FT_FORMUL)) .And. cEntSai=="2"
				cIndEmit := "0"			//Emissao Propria
			Else
				If ("S"$(cAliasSFT)->FT_FORMUL)
					cIndEmit := "0"		//Emissao Propria
				Else
					cIndEmit := "1"		//Emissao de Terceiros
				EndIf
			EndIf

			If lCmpCHVNFE
				cChvNfe := (cAliasSFT)->FT_CHVNFE
				If cEspecie=="57"
				    cChvCte := (cAliasSFT)->FT_CHVNFE
			    EndIf
			EndIf

			(cAlsSA)->(MsSeek (xFilial (cAlsSA)+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA))


			//lAchouSE4	:=	SE4->(MsSeek (xFilial ("SE4")+&(cCmpCondP)))  *** Comentado pois no fonte inteiro essa variavel nao e' utilizada

			cChvSeek	:=	(cAliasSFT)->(FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_ITEM+FT_PRODUTO)
			If lTabComp

				lAchouCDG	:=	CDG->(MsSeek (xFilial ("CDG")+(cAliasSFT)->FT_TIPOMOV+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA))

				cChvCD5 := ""
				If cEntSai == "1" // So se for entrada
					cChvCD5 := xFilial(cAliasCD5)+(cAliasSFT)->(FT_NFISCAL+FT_SERIE+FT_CLIEFOR+FT_LOJA)
					lAchouCD5	:= SPEDSeek(cAliasCD5,4,cChvCD5)
				EndIF

				IF lIntEasy
					aAverage := AvGetImpSped(xFilial ("SFT"), (cAliasSFT)->FT_NFISCAL, (cAliasSFT)->FT_SERIE, (cAliasSFT)->FT_CLIEFOR, (cAliasSFT)->FT_LOJA)
				Endif

				If lTabCDT
					lAchouCDT	:=	CDT->(MsSeek (xFilial ("CDT")+(cAliasSFT)->FT_TIPOMOV+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA))
					If lAchouCDT
						//Armazena a chave pois podem haver varias informacoes complementares (CDT) para uma msma NF
						cChaveCDT 	:=	CDT->CDT_FILIAL+CDT->CDT_TPMOV+CDT->CDT_DOC+CDT->CDT_SERIE+CDT->CDT_CLIFOR+CDT->CDT_LOJA
					EndIf
				EndIf
				If lTabCDC
					lAchouCDC := CDC->(MsSeek (xFilial ("CDC")+(cAliasSFT)->FT_TIPOMOV+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA))
					If lAchouCDC
						//Armazena a chave pois podem haver varias informacoes complementares (CDC) para uma msma NF
						cChaveCDC 	:=	CDC->CDC_FILIAL+CDC->CDC_TPMOV+CDC->CDC_DOC+CDC->CDC_SERIE+CDC->CDC_CLIFOR+CDC->CDC_LOJA+CDC->CDC_GUIA
					EndIf
				EndIf

			EndIf

			aPartDoc	:=	InfPartDoc (cAlsSA, Iif(cSituaDoc$"02#04#05#",.F.,@aReg0150),.F.,dDataDe, dDataAte,nRelacFil)
			//Processando os itens do documento fiscal.
			lItemNCumu	:= .F. //Inicia com False no primeiro item
			lReceita    := .F. //
			If Interrupcao(lEnd)
				// Verifica se o processamento sera em multithread
				If lProcMThr
					GeraTrb(2, @aArq, @cAlias,.T.,nHandleTRB,nMvQtdThr,cSemaphore )
				Else
					GeraTrb(2, @aArq, @cAlias)
				EndIf

			 	lCancel := lEnd
			    Return
			EndIf
			cChave	:=	(cAliasSFT)->FT_FILIAL+(cAliasSFT)->FT_TIPOMOV+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA
			lGravaC100	:= .T.
			lGravaNFE	:= .T.

			//A funcao GravaC100 verifica se o documento fiscal possui pelo menos um item que gera contribuicao ou credito 
			//e desta forma, se possuir, devera escriturar a nota fiscal em sua integralidade. Ou seja, o registro C100 com
			//valores totais, e um C170 para cada item da nota.															
			If cEspecie $ "01/04/1B/55/65" .OR. (cEntSai == "1" .AND. cEspecie $ "07/08/09/10/11/26/27/57")
				//Se o par¢metro MV_SPEDCSC estiver .T. no ir¡ fazer verificao para operaµes sem direito ao cr©dit								/IF !lSPEDCSC
				//IF !lSPEDCSC				
					aAreaQSFT	:=	SFT->(GetArea())
					lGravaC100	:=	GravaC100(cChave,cEntSai,aCFOPs)
					RestArea(aAreaQSFT)
				//Else
				//	lGravaC100:= .T.
				//EndIF
			ElseIf cEntSai == "1" .And. !((cAliasSFT)->FT_CSTPIS$("50#51#52#53#54#55#56#60#61#62#63#64#65#66")) .And. lSkpENC
				//Se o par¢metro MV_SPEDCSC estiver .T. no ir¡ fazer verificao para operaµes sem direito ao cr©dito
				IF !lSPEDCSC
					aAreaQSFT:=  SFT->(GetArea())
					aAreaQSD1:=  SD1->(GetArea())
					lGravaNFE := GravaNFEnt(cAliasSFT,lTop)
					RestArea (aAreaQSD1)
					RestArea (aAreaQSFT)
				Else
					lGravaNFE	:= .T.
				EndIF
			EndIF

			nItemC170 := 0
			Do While !(cAliasSFT)->(Eof ()) .And.;
				cChave==(cAliasSFT)->FT_FILIAL+(cAliasSFT)->FT_TIPOMOV+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA

                nRecnoSFU	:=	Iif(lTop .And. lTabComp,(cAliasSFT)->SFURECNO,Nil)
                nRecnoSFX	:=	Iif(lTop .And. lTabComp,(cAliasSFT)->SFXRECNO,Nil)
                nRecnoCD3	:=	Iif(lTop .And. lTabComp,(cAliasSFT)->CD3RECNO,Nil)
                If lNatOper
                	nRecnoCD1	:=	Iif(lTop .And. lTabCD1 ,(cAliasSFT)->CD1RECNO,Nil)
                Endif
				IF lTabComp
					cChvSeek	:=	(cAliasSFT)->(FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_ITEM+FT_PRODUTO)
	    			IF cEntSai =="2" .AND.  cEspecie $"06/28/29/"
	    				lAchouSFU	:=	SPEDSeek("SFU",,xFilial("SFU")+cChvSeek,nRecnoSFU)
	    				lAchouCD3	:=	SPEDSeek("CD3",,xFilial("CD3")+cChvSeek,nRecnoCD3)
	    			EndIF
	    			IF cEspecie $"21/22"
	    				lAchouSFX	:=	SPEDSeek("SFX",,xFilial("SFX")+cChvSeek,nRecnoSFX)
	    				aTotaliza[34] += SFX->FX_VALTERC
	    			EndIF
	    		EndIF

	    		//Natureza da Operacao/Prestacao
	    		If lTabCD1 .And. lNatOper
	    			lAchouCD1	:=	SPEDSeek("CD1",,xFilial("CD1")+(cAliasSFT)->FT_NATOPER,nRecnoCD1)
	    		Endif

				//Verifica se o item de sa­da foi devolvido.
				lDevolucao	:= .F.
				lDevComp	:= .F.
				nPosDevCmp	:= 0
				If cEntSai == "2" .AND. cEspecie $ "01/04/55/1B"
					nPosDev := aScan (aDevMsmPer, {|aX| aX[1]==(cAliasSFT)->FT_NFISCAL .AND. aX[2]==(cAliasSFT)->FT_EMISSAO .AND. aX[3]==(cAliasSFT)->FT_SERIE .AND. aX[4]==(cAliasSFT)->FT_ITEM  .AND. aX[5]==(cAliasSFT)->FT_CLIEFOR  .AND. aX[6]==(cAliasSFT)->FT_LOJA })
					IF nPosDev > 0
						lDevolucao	:= .T.
					EndIF
				ElseIf cEntSai == "1" .AND. cEspecie $ "01/04/55/1B"
					nPosDevCmp := aScan (aDevCpMsmP, {|aX| aX[1]==(cAliasSFT)->FT_NFISCAL .AND. aX[2]==(cAliasSFT)->FT_EMISSAO .AND. aX[3]==(cAliasSFT)->FT_SERIE .AND. aX[4]==(cAliasSFT)->FT_ITEM  .AND. aX[5]==(cAliasSFT)->FT_CLIEFOR  .AND. aX[6]==(cAliasSFT)->FT_LOJA })
				    If nPosDevCmp > 0
						lDevComp	:= .T.
					EndIF
				EndIF

				//Inicializacao de variaveis utilizadas no processamento do item
				aRegC170	:=	{}
				lGrava0200	:=	.F.
				nValST		:= 0

				//Posicionando tabelas de acordo com os itens dos documentos fiscais.
			    nQtde := (cAliasSFT)->FT_QUANT

				If !lTop
					SPEDSeek("SB1",,xFilial("SB1")+(cAliasSFT)->FT_PRODUTO)
				EndIF
                cUnid := (cAliasSB1)->B1_UM

				If (cAlsSD)->(MsSeek (xFilial (cAlsSD)+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA+(cAliasSFT)->FT_PRODUTO+(cAliasSFT)->FT_ITEM))
					If (lAchouSF4	:=	SF4->(MsSeek (xFilial ("SF4")+&(cCmpTes))))
						cCodTes	:=	SF4->(&(cCmpTes))
					Endif
					IF cEspecie $"06/28/29" .AND. cEntSai =="2"
						lAchouCD4	:=	CD4->(MsSeek (xFilial ("CD4")+(cAliasSFT)->FT_TIPOMOV+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA))
					EndIF
					lAchouCD6	:=	CD6->(MsSeek (xFilial ("CD6")+(cAliasSFT)->FT_TIPOMOV+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA +(cAliasSFT)->FT_ITEM +(cAliasSFT)->FT_PRODUTO))
					cUnid 		:=	&(cCmpUm)
					IF lSPDFIS02
						if valtype(ExecBlock("SPDFIS02", .F., .F., {Iif(!lTop,cAlsSD,cAliasSFT),(cAliasSFT)->FT_TIPOMOV})) == "A"
		  					aSpdFis02 := ExecBlock("SPDFIS02", .F., .F., {Iif(!lTop,cAlsSD,cAliasSFT),(cAliasSFT)->FT_TIPOMOV})
					      	cUnid     := aSpdFis02[1]
					      	nQtde     := aSpdFis02[2]
					   Else
							cUnid     := ExecBlock("SPDFIS02", .F., .F., {Iif(!lTop,cAlsSD,cAliasSFT)})
					   EndIf
					EndIF
                EndIf

				lTemProjet	:= .F.
				IF lUsaCF7
					SD2->(dbSetOrder(3))
					If SD2->(MsSeek(xFilial("SD2")+  (cAliasSFT)->FT_NFISCAL +  (cAliasSFT)->FT_SERIE+  (cAliasSFT)->FT_CLIEFOR +  (cAliasSFT)->FT_LOJA +  (cAliasSFT)->FT_PRODUTO + (cAliasSFT)->FT_ITEM))
						SC6->(MsSeek (xFilial ("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEM+(cAliasSFT)->FT_PRODUTO))
						If !Empty(SC6->C6_PROJPMS)
							lTemProjet	:= .T.
						EndIF
					EndIF
				EndIF

				lGeraNota := .T.

				// Atualiza ativo, esta nota no ser¡ gerada nos blocos A, C e D, ser¡ gerada no bloco F, nos registros que tratam cr©ditos do Ativo.
				If SF4->F4_ATUATF == "S" .And. ((cAliasSFT)->FT_CSTPIS$CCSTCRED .Or. (cAliasSFT)->FT_CSTCOF$CCSTCRED)
					lGeraNota := .F.
					lGravaC100  := .F.
					(cAliasSFT)->(DbSkip ())
					Loop
			    Else
			       lGravaC100	:=	GravaC100(cChave,cEntSai,aCFOPs)
			    EndIf

				IF cEspecie == "55" .AND. lConsolid .AND. cEntsai == "1" .AND. !((cAliasSFT)->FT_CSTPIS $ CCSTCRED .OR.  (cAliasSFT)->FT_CSTCOF $ CCSTCRED) .AND. !(cAliasSFT)->FT_TIPO$"D"
					IF !lSPEDCSC
						lGeraNota := .F.
						(cAliasSFT)->(DbSkip ())
						Loop
					EndIF
				EndIF

				If (cEspecie $ "01/04/1B" .OR. 	(cEspecie == "55" .AND. !lConsolid)) .And. !(cMvEstado == "DF" .And. (cAliasSFT)->FT_TIPO == "S" .And. cEspecie = "55");
				.OR. (cEntSai == "1" .AND. cEspecie $ "07/08/09/10/11/26/27/57")//Condio para o bloco D100 chamado TTLEOZ
					lGeraNota := lGravaC100
				Else
					lGeraNota := lGravaNFE
				EndIf

				If lMVSpedAz //MV_SPEDAZ
					lPisZero := .F.
					If (cAliasSFT)->FT_CSTPIS$"#04#05#06#07#08#09#"
						If SF4->F4_PISDSZF <> "1"   //No tem desconto para ZFM de PIS
							lPisZero := .T.
						EndIf
					EndIF

					lCofZero := .F.
					If (cAliasSFT)->FT_CSTCOF$"#04#05#06#07#08#09#"
						If SF4->F4_COFDSZF <> "1"//No tem desconto para ZFM de COFINS
							lCofZero := .T.
						EndIf
					EndIF
				EndIF


				lCumulativ :=.F.
				If cRegime == "1" //Nao cumulativo
					lCumulativ := .F.
				ElseIf cRegime == "2"  //Cumulativo
					lCumulativ := .T.
				ElseIf cRegime == "3" //Cumulativo e no cumulativo
					IF nMVM996TPR = 1 //TES
						If SF4->F4_TPREG == "2"	//Cumulativo
							lCumulativ := .T.
						ElseIF SF4->F4_TPREG == "3"	//Ambos, neste caso irei no produto para definir qual o regime
							IF lB1Tpreg .And. (caliasSB1)->B1_TPREG == "2" //Cumulativo
								lCumulativ := .T.
							EndIF
						EndIF
					Elseif nMVM996TPR == 2 //PRODUTO
						IF lB1Tpreg .And. (cAliasSB1)->B1_TPREG == "2" //Cumulativo
							lCumulativ := .T.
						EndIF
					Elseif nMVM996TPR == 3 .And. lA1_TPREG //CLIENTE
						IF SA1->A1_TPREG == "2" //Cumulativo
							lCumulativ := .T.
						EndIF
					EndIF
				EndIF

				//Se utiliza Cadastro de Natureza da Operacao (tabela CD1)
				If lAchouCD1
					cCodNat	:=	(cAliasSFT)->FT_NATOPER
					cDescNat:=	AllTrim(CD1->CD1_DESCR)

				//Se encontrar TES e MV_SPEDNAT = F
				Elseif !lSpedNat .And. lAchouSF4
					cCodNat	:=	cCodTes
					cDescNat:=	AllTrim(SF4->F4_TEXTO)

				//MV_SPEDNAT = T
				ElseIf (SX5->(MsSeek (xFilial ("SX5")+"13"+(cAliasSFT)->FT_CFOP)))
					cCodNat	:=	(cAliasSFT)->FT_CFOP
					cDescNat:=	AllTrim(SX5->X5_DESCRI)
				Endif

				//Ponto de entrada para taratmento da informao de produtos quando o mesmo © fora do padrao do sistema
				cProd 		:= (cAliasSB1)->B1_COD+Iif(lConcFil,xFilial("SB1"),"")
				cDescProd   := (cAliasSB1)->B1_DESC

				If lSPEDPROD
					aProd := Execblock("SPEDPROD", .F., .F., {cAliasSFT})
					If Len(aProd)==11
						cProd 		:= Iif(!Empty(aProd[1]),aProd[1],"")
						cDescProd   := Iif(!Empty(aProd[2]),aProd[2],"")
					Else
						aProd := {"","","","","","","","","","",""}
					EndIf
				EndIf

				//verifica se este item da nota eh um servico 
				lIss 		:= ((cAliasSFT)->FT_TIPO == "S")
				If !lIss .And. (cAliasSFT)->FT_CREDST <> "4"

					If 	(cEntSai=="2" .And. (Empty(cMv_StUfS) .Or. (cAliasSFT)->FT_ESTADO$cMv_StUfS) ;
						.And. (Empty(cMv_StUf) .Or. (cAliasSFT)->FT_ESTADO$cMv_StUf));						//Debito por saida
						.OR. ;
						(cEntSai=="1" .And. (Empty(cMv_StUf) .Or. (cAliasSFT)->FT_ESTADO$cMv_StUf) ;		//Credito por entrada (devolucoes)
						.And. (cAliasSFT)->FT_TIPO=="D")

						If lResF3FT
							//Na tabela SFT o valor de ICMS Retido pode alternar nas colunas dependendo da escrituracao
							nValST 	:= 	(cAliasSFT)->(FT_ICMSRET+FT_OUTRRET+FT_ISENRET)
							nValST	:=	(cAliasSFT)->(Iif(nValST>0,nValST,FT_OBSSOL))
						Else
							//Na tabela SF3 o valor do ICMS Retido sempre eh gravado em ICMSRET, independente da escrituracao
							nValST 	:= 	(cAliasSFT)->FT_ICMSRET
							nValST	:=	(cAliasSFT)->(Iif(nValST>0,nValST,FT_OBSSOL))
						EndIf

					ElseIf  (cEntSai=="1") .And. (cAliasSFT)->FT_ESTADO == cMVEstado .And. (cAliasSFT)->FT_CREDST <> "3"

						If (cAliasSFT)->FT_SOLTRIB > 0  //.AND. lImpCrdST
							nValST := (cAliasSFT)->FT_SOLTRIB

						Else

							If lResF3FT
								//Na tabela SFT o valor de ICMS Retido pode alternar nas colunas dependendo da escrituracao
								nValST 	:= 	(cAliasSFT)->(FT_ICMSRET+FT_OUTRRET+FT_ISENRET)
								nValST	:=	(cAliasSFT)->(Iif(nValST>0,nValST,FT_OBSSOL))
							Else
								//Na tabela SF3 o valor do ICMS Retido sempre eh gravado em ICMSRET, independente da escrituracao
								nValST 	:= 	(cAliasSFT)->FT_ICMSRET
								nValST	:=	(cAliasSFT)->(Iif(nValST>0,nValST,FT_OBSSOL))
							EndIf
						EndIf
			   		EndIf

					If (cAliasSFT)->FT_TIPO=="D" .And. !(cAliasSFT)->FT_ESTADO==cMVEstado .And. !(cAliasSFT)->FT_ESTADO$cMVSUBTRIB
						If (cEntSai=="1" .And. AllTrim((cAliasSFT)->FT_CFOP)$cMVCFE210) .AND. !((cMVEstado+(cAliasSFT)->FT_ESTADO)$AllTrim(aParSX6[30])) .Or. cEntSai=="2"
							nValST		:=	0
						EndIf
					EndIf

				EndIf

				If lAchouSF4 .And. !Empty(SF4->F4_VLAGREG) .And.;
				   !Empty(aPartDoc[7]) .And. aPartDoc[7]!= "9999999"
				   lGrava0200 := .T.
				Endif

				aClasFis 	:= RetCodCst(cAliasSFT, cAlsSA, lAchouSF4, cEntSai, .T., .T., cEspecie,cAliasSB1,cAliasSF4)
				//verifica se este item da nota eh um servico 
				lIss 		:= ((cAliasSFT)->FT_TIPO == "S")
				If !(cSituaDoc$"02#04#05") .And. lGeraNota .And. ( cEspecie$"  " .Or. lGravaC100 )
					Reg0400(cCodNat,@aReg0400,cDescNat)
				EndIf

				nValCof	:=	(cAliasSFT)->FT_VALCOF
				nValPis	:=	(cAliasSFT)->FT_VALPIS
				IF lImport
					MajAliqVal(,@nValCof,cAliasSFT,lCpoMajAli)
					MajAliqPis(,@nValPis,cAliasSFT)
				EndIF

				aTotaliza[1]	+=	(cAliasSFT)->FT_VALCONT
				aTotaliza[8]	+=	nQtde
				aTotaliza[9]	+=	Iif(SF4->F4_PISCRED == "5",(cAliasSFT)->FT_VALCONT,(cAliasSFT)->FT_DESCONT)
				aTotaliza[10]	+=	(cAliasSFT)->FT_TOTAL + Iif(lCmpDescZF .And. (cAliasSFT)->FT_TIPO <> "D",(cAliasSFT)->FT_DESCZFR ,0)
				aTotaliza[11]	+=	(cAliasSFT)->FT_FRETE
				aTotaliza[12]	+=	(cAliasSFT)->FT_SEGURO
				If (cAliasSFT)->FT_DESPESA -((cAliasSFT)->FT_SEGURO + (cAliasSFT)->FT_FRETE) > 0
					aTotaliza[13]	+=	(cAliasSFT)->FT_DESPESA -((cAliasSFT)->FT_SEGURO + (cAliasSFT)->FT_FRETE)
				EndIf
				If lMVSpedAz
					IF cEntSai == "2"
						If !lPisZero
							aTotaliza[19]	+= IIF(!lDevolucao,nValPis,nValPis - aDevMsmPer[nPosDev][8])
						EndIF

						If !lCofZero
							aTotaliza[20]	+= IIF(!lDevolucao,nValCof,nValCof - aDevMsmPer[nPosDev][10])
						EndIF
					ElseIF cEntSai == "1"
						If !lDevComp
							aTotaliza[19]	+=	nValPis
							aTotaliza[20]	+=	nValCof
						Elseif nPosDevCmp > 0
							//Se for entrada ir¡ verificar se houve devoluo desta compra, se houve ir¡ reduzir a base de c¡lculo conforme percentual devolvido.
							aTotaliza[19]	+=	nValPis - aDevCpMsmP[nPosDevCmp][8]
							aTotaliza[20]	+=	nValCof - aDevCpMsmP[nPosDevCmp][10]
						Else
							aTotaliza[19]	+=	0
							aTotaliza[20]	+=	0
						Endif
					EndIF
				ElseIF cEntSai == "2"
					If !lDevolucao
						aTotaliza[19]	+=	nValPis
						aTotaliza[20]	+=	nValCof
					Elseif nPosDev > 0
						aTotaliza[19]	+=	nValPis - aDevMsmPer[nPosDev][8]
						aTotaliza[20]	+=	nValCof - aDevMsmPer[nPosDev][10]
					Else
						aTotaliza[19]	+=	0
						aTotaliza[20]	+=	0
					Endif
				ElseIF cEntSai == "1"
					If !lDevComp .And. !((cAliasSFT)->FT_TIPO=="D" .And. (cAliasSFT)->FT_CSTPIS$"98/99")
						aTotaliza[19]	+=	nValPis
					Elseif nPosDevCmp > 0 .And. !((cAliasSFT)->FT_TIPO=="D" .And. (cAliasSFT)->FT_CSTPIS$"98/99" )
						//Se for entrada ir¡ verificar se houve devoluo desta compra, se houve ir¡ reduzir a base de c¡lculo conforme percentual devolvido.
						aTotaliza[19]	+=	nValPis - aDevCpMsmP[nPosDevCmp][8]
					Else
						aTotaliza[19]	+=	0
					Endif

					If !lDevComp .And. !((cAliasSFT)->FT_TIPO=="D" .And. (cAliasSFT)->FT_CSTCOF$"98/99" )
						aTotaliza[20]	+=	nValCof
					Elseif nPosDevCmp > 0 .And. !((cAliasSFT)->FT_TIPO=="D" .And. (cAliasSFT)->FT_CSTCOF$"98/99" )
						//Se for entrada ir¡ verificar se houve devoluo desta compra, se houve ir¡ reduzir a base de c¡lculo conforme percentual devolvido.
						aTotaliza[20]	+=	nValCof - aDevCpMsmP[nPosDevCmp][10]
					Else
						aTotaliza[20]	+=	0
					Endif

				Endif

				// Verifica campos de Retencao
				If  lCmpVertPC // Se os campos "FT_VRETPIS" e "FT_VRETCOF" existirem
					aTotaliza[21]	+=	(cAliasSFT)->FT_VRETPIS
			   		aTotaliza[22]	+=	(cAliasSFT)->FT_VRETCOF
	            ElseIf lCmpD2VlPC .AND. cEntSai =="2" // Se os campos D2_VALPIS e D2_VALCOF existirem
	            	aTotaliza[21]	+=	&(cCmpValPis)
			   		aTotaliza[22]	+=	&(cCmpValCof)
			  	Else
					aTotaliza[21]	+= 0
					aTotaliza[22]   += 0
	            EndIf
				//Se for nota de entrada, e houver identificado devoluo desta compra, ir¡ utilizar valor da base de c¡lculo reduzida conforme devoluo.
				If cEntSai == "1" .AND. nPosDevCmp > 0
					aTotaliza[23]	+= (cAliasSFT)->FT_BASEPIS -  aDevCpMsmP[nPosDevCmp][7]
					aTotaliza[24]	+= (cAliasSFT)->FT_BASECOF - aDevCpMsmP[nPosDevCmp][9]
				Else
					aTotaliza[23]	+= (cAliasSFT)->FT_BASEPIS
					aTotaliza[24]	+= (cAliasSFT)->FT_BASECOF
				EndIF

				aTotaliza[28]	+= (cAliasSFT)->FT_VALPS3
				aTotaliza[29]	+= (cAliasSFT)->FT_VALCF3
				aTotaliza[30]	+= (cAliasSFT)->FT_BASEPS3
				aTotaliza[31]	+= (cAliasSFT)->FT_BASECF3
				aTotaliza[32]	+= Iif(lCmpDescIC,(cAliasSFT)->FT_DESCICM,0)
				aTotaliza[33]	+= Iif(lCmpDescZF,(cAliasSFT)->FT_DESCZFR,0)
				//Valores que devem ser acumulados somente se nao for item de servico |
				aTotaliza[2]	+=	(cAliasSFT)->FT_BASEICM
				aTotaliza[3]	+=	(cAliasSFT)->FT_VALICM
				If nValST > 0
					aTotaliza[4]	+=	(cAliasSFT)->FT_BASERET
					aTotaliza[5]	+=	nValST
				EndIf
				aTotaliza[6]	+=	(cAliasSFT)->FT_VALIPI
				//Quando configuro a TES para escriturar o Livro de ICMS/ST como OUTROS, na tabela SF3 o valor do campo
				//  F3_ICMSRET eh transportado para o campo F3_OUTRICM, ficando com os mesmos valores. Na tabela SFT, que
				//  possui o campo proprio FT_OUTRRET, recebe este valor deixando o campo FT_OUTRICM e FT_ICMSRET zerado.
 		    	aTotaliza[7]	+=	(cAliasSFT)->FT_VALCONT-(cAliasSFT)->FT_BASEICM
				aTotaliza[14]	+=	(cAliasSFT)->FT_OUTRICM+(cAliasSFT)->FT_OUTRRET+(cAliasSFT)->FT_ISENICM+(cAliasSFT)->FT_ISENRET
				aTotaliza[15]	+=	(cAliasSFT)->FT_BASEIPI
				aTotaliza[16]	+=	(cAliasSFT)->FT_ISENIPI
				aTotaliza[17]	+=	(cAliasSFT)->FT_OUTRIPI
				aTotaliza[18]	+=	(cAliasSFT)->FT_ICMSCOM
				//Processamento dos itens do bloco A (Especie NFPS, NFS e RPS)
				If (cEspecie$"  ") .Or. (cMvEstado == "DF" .And. lIss .And. cEspecie = "55")  // "NFPS" "NFS" "RPS"
					//Codigo RPS                
					If lFT_CODNFE .AND. cEspecie != "55
						cChvNfe := AllTrim((cAliasSFT)->FT_CODNFE)
					EndIf

					//Processamento do registro A010 .

					If cCGCAnt <> SM0->M0_CGC .Or. !lRepCGC .Or. (lRepCGC .And. (aScan(aRegA010, {|aX| aX[2] == SM0->M0_CGC}) == 0)) //Tratamento para consolidar Filiais com mesmo CNPJ.
						RegA010(cAlias,@aRegA010, @nPaiA, @lGravaA010)
					EndIf
					
					If !(cMvEstado == "DF" .And. cSituaDoc == "05")
						//Se no for cancelamento
						If !cSituaDoc == "02" .And. (cEntSai=="2" .Or. lGravaNFE)
	
							RegA170(calias,@aRegA170,cAliasSFT, cProd, cDescProd, nRelacDoc,cEntSai,@aReg0500,@aReg0600,@aRegM210,@aRegM610,;
									aWizard,@aRegAuxM105,@aRegAuxM505,cRegime,@aRegM400,@aRegM410,@aRegM800,@aRegM810,lCumulativ,cIndApro, ;
									aReg0111,nItem, lPisZero, lCofZero,aDevolucao,@aRegM220,@aRegM620,@aRegM230,@aRegM630,cAliasSB1,lTop,cAliasSD1,cAliasSD2)
	
	
							If lAchouCD5
	
								RegA120(@aRegA120,cAliasSFT,cAliasCD5,cChvCD5)
	
							EndIF
						EndIF
					EndIf
				//Esp©cie NF, NFP, NFCEE, SPED, NFCF, NFFA, NFCFG, Cupom Fiscal emitido pelo SIGALOJA(2D).
				ElseIF  cEspecie $"01/04/06/55/02/29/28/2D/1B/65"

					If lZerVar .Or. (lRepCGC .And. (aScan(aRegC010, {|aX| aX[2] == SM0->M0_CGC}) == 0)) //Tratamento para consolidar Filiais com mesmo CNPJ.
					//If cCGCAnt <> SM0->M0_CGC .Or. !lRepCGC .Or. (lRepCGC .And. (aScan(aRegC010, {|aX| aX[2] == SM0->M0_CGC}) == 0)) //Tratamento para consolidar Filiais com mesmo CNPJ.
						RegC010(cAlias,@aRegC010, @nPaiC, @lGravaC010,aWizard[1][7] , lZerVar )
					EndIf

					lRegC010 :=.T.
					If cEspecie $ "01/04/55/1B/65"	.AND. !lEnerEle

						If cEspecie $ "01/04/1B" .OR. (cEspecie == "55" .AND. !lConsolid)

							If lGravaC100
								lGerouC170 := RegC170(cAlias, nRelacDoc, nItem, @aRegC170, cEspecie, cAliasSFT, cAlsSD, cEntSai,;
														 lIss, aClasFis, lAchouSF4, nApurIpi, cSituaDoc, cChvNfe, cUnid, cProd, ;
														 cIndEmit, nValST, dDataDe, dDataAte,@aRegM210,@aRegM610,aWizard,lConsolid,;
														 @aReg0500,@aRegAuxM105,@aRegAuxM505,cRegime,@aRegM400,@aRegM410, @aRegM800,;
														 @aRegM810,lCumulativ,cIndApro,aReg0111,lPisZero, lCofZero,aDevolucao,@aRegM220,@aRegM620,;
														 @aRegM230,@aRegM630,nQtde,@nItemC170,cAliasSB1,cAliasSF4,lDevComp,nPosDevCmp,aDevCpMsmP,aDevMsmPer,nPosDev,lCmpDescZF,cCodNat,lCpoMajAli,lCpoPtPis,lCpoPtCof,nPaiC)

								lReceita := .T.
							EndIf

						EndIf
						
						If cEspecie =="65" .And. dDataDe >= cToD("01/09/2014") .And. cEntSai=="2" .And. !cSituaDoc$"02#04#05"
						
							RegC175(cAlias,nRelacDoc, @aRegC175,aRegC100, cAliasSFT, aClasFis, @aRegM210,@aRegM610,@aReg0500,lPisZero,lCofZero,cAliasSB1,cAliasSF4,aDevMsmPer,nPosDev,lCpoPtPis,lCpoPtCof,;
										aWizard,lCumulativ,aDevolucao,@aRegM220,@aRegM230,lCmpDescZF,@aRegM620,@aRegM630,@aRegM400,@aRegM410,@aRegM800,@aRegM810)
										
							//Consolidacao para modelo 55 
						ElseIf lConsolid
							IF cEspecie $"55/65" 
								If cEntSai=="2" .AND. !((cAliasSFT)->FT_TIPO$"D") //Saidas e nao for devolucao
									IF !(cSituaDoc$"02#04#05")  .AND. lGravaC100

										RegC180(@aRegC180,@aRegC181,@aRegC185,@aReg0500,cAliasSFT,dDataDe,dDataAte,cProd,@nPosC180, ;
												aWizard,lConsolid,@aRegM210,@aRegM610,@aRegM400,@aRegM410,@aRegM800,@aRegM810,;
												lCumulativ,lPisZero, lCofZero,aDevolucao,@aRegM220,@aRegM620,@aRegM230,@aRegM630,cAliasSB1,aDevMsmPer,nPosDev,lCpoMajAli)

										ProceRefer(@aRegC188, nPosC180,@aReg1010,@aReg1020,"C188")
									EndIF
								//Entradas e Devolucoes utilizando CST 49
								ElseIf cEntSai=="1" .OR. ( cEntSai=="2" .AND. ((cAliasSFT)->FT_TIPO$"D") .AND. ((cAliasSFT)->FT_CSTPIS$"49") .AND. ((cAliasSFT)->FT_CSTCOF$"49") )
		                    	 	IF !(cSituaDoc$"02#04#05") .And. lGravaC100
			                    	 	//REGISTRO C190 - CONSOLIDACAO NOTAS FISCAIS ELETRONICAS
										RegC190(@aRegC190,@aRegC191,@aRegC195,@aReg0500,cAliasSFT,dDataDe,dDataAte,cProd,@nPosC190,aPartDoc,lCumulativ,lConsolid,@aRegAuxM105,@aRegAuxM505,cRegime,cIndApro,@aReg0111,cAliasSB1,lDevComp,nPosDevCmp,aDevCpMsmP)

										//REGISTRO C198 - PROCESSO REFERENCIADO
										ProceRefer(@aRegC198, nPosC190,@aReg1010,@aReg1020,"C198")

										cChv199 := xFilial(cAliasCD5)+(cAliasSFT)->(FT_NFISCAL+FT_SERIE+FT_CLIEFOR+FT_LOJA+FT_ITEM)
										lAchou199 := SPEDSeek(cAliasCD5,4,cChv199)

										If  ( lAchou199 .OR. ( Len(aAverage)>0 ) )
											RegC199(@aRegC199,nPosC190,aAverage,cAlsSF,cAlias199,cMVEASY,lTop,cAliasSF1,cChv199)
										EndIf

									EndIF
								EndIF
							EndIF
						EndIf
					//Notas Fiscais de venda a consumidor que no seja emitido por ECF.
					ElseIf cEspecie =="02"
						If cEntSai =="2" //Saidas
							If !cSituaDoc == "02" .AND. !Alltrim((cAliasSFT)->FT_ESPECIE) $ "CF/ECF"

								RegC381(@aRegC381,cAliasSFT,cProd,@aReg0500,@aRegM210,aWizard,@aRegM400,@aRegM410,lCumulativ,lPisZero,;
								aDevolucao,@aRegM220,@aRegM230,cAliasSB1)

								RegC385(@aRegC385,cAliasSFT,cProd,@aReg0500,@aRegM610,aWizard,@aRegM800,@aRegM810,lCumulativ,lCofZero,;
								aDevolucao,@aRegM620,@aRegM630,cAliasSB1,lCpoMajAli)

								RegC380(@aRegC380,cAliasSFT,dDataDe,dDataAte,cSituaDoc)
							EndIF

						ELSEIf lGravaNFE //Entradas

							RegC396(cAlias,@aRegC396,cAliasSFT,cProd,nRelacDoc,nItem,@aReg0500,@aRegAuxM105,;
									@aRegAuxM505,cRegime,lCumulativ,cIndApro,aReg0111,cAliasSB1)
						EndIF
					//Modelos NFCEE, NFCFG e  NFFA.
					Elseif cEspecie $"06/28/29/55"
						If cEntSai =="1" //ENTRADAS
							If lGravaNFE
                                If !cSituaDoc =="02" //CAncelada
									RegC501(@aRegC501,cAliasSFT,@aReg0500,@aTotaliza,@aRegAuxM105,cRegime,lCumulativ,cIndApro,aReg0111,cAliasSB1)

									RegC505(@aRegC505,cAliasSFT,@aReg0500,@aTotaliza,@aRegAuxM505,cRegime,lCumulativ,cIndApro,aReg0111,cAliasSB1)
								EndIf
							EndIF
						Elseif cEntSai =="2" //SAIDAS

							RegC600(@aRegC600,@aRegC601,@aRegC605,aTotaliza,cAliasSFT,aCmpAntSFT,cEspecie,aPartDoc, ;
							         lAchouSFU,lAchouCD3,lAchouCD4,@aReg0500,@nPosC600,@aRegM210,@aRegM610,aWizard,@aRegM400,;
							         @aRegM410,@aRegM800,@aRegM810,lCumulativ,cSituaDoc,lPisZero, lCofZero,aDevolucao,@aRegM220,@aRegM620,;
							         @aRegM230,@aRegM630,cAliasSB1,lSpdP06,lSpdP61,lSpdP65,lCpoMajAli,lCmpDescZF)

  							ProceRefer(@aRegC609,nPosC600,@aReg1010,@aReg1020,"C609")

						EndIf
					EndIF
				//Processamento dos itens do bloco D.                        
				//Modelos NFST, CTR, CTA, CA, RMD, CTF, NTST, NFSC, CTM, CTE.
				ElseIF cEspecie $"07/08/09/10/13/18/11/22/21/26/57"

					//Processamento do registro D010.
					If cCGCAnt <> SM0->M0_CGC .Or. !lRepCGC .Or. (lRepCGC .And. (aScan(aRegD010, {|aX| aX[2] == SM0->M0_CGC}) == 0)) //Tratamento para consolidar Filiais com mesmo CNPJ.
						lFirst := .F.
						RegD010(cAlias,@aRegD010, @nPaiD, @lGravaD010)
					EndIf
					//Modelos NFST, CTR, CTA, CA, RMD, CTM, CTE.
					IF cEspecie $"07/08/09/10/11/26/27/57"
						If cEntSai == "1" //Entradas
							If lGravaC100

								RegD101(@aRegD101,cAliasSFT,@aReg0500,@aRegAuxM105,cRegime,lCumulativ,cIndApro,aReg0111,cAliasSB1)

								RegD105(@aRegD105,cAliasSFT,@aReg0500,@aRegAuxM505,cRegime,lCumulativ,cIndApro,aReg0111,cAliasSB1)
							EndIF
						Else

							If !cSituaDoc$"02#03#04#05"
								RegD200(@aRegD200,@aRegD201,@aRegD205,@aReg0500,cAliasSFT,dDataDe,dDataAte,cEspecie,cSituaDoc, ;
										@nPosD200,@aRegM210,@aRegM610,aWizard,@aRegM400,@aRegM410,@aRegM800,@aRegM810,lCumulativ,;
										lPisZero, lCofZero,aDevolucao,@aRegM220,@aRegM620,@aRegM230,@aRegM630,cAliasSB1,lCpoMajAli)

								ProceRefer(@aRegD209,nPosD200,@aReg1010,@aReg1020,"D209")
							EndIF
						EndIf
					//RMD.
					ElseIf cEspecie $"13/18"
						If !cSituaDoc$"02#03"
							If cEntSai == "2" // SAŒDAS

								RegD300(@aRegD300,cEspecie,cAliasSFT,dDataAte,@aReg0500,@nPosD300,@aRegM210,@aRegM610,;
										aWizard,lCumulativ,lPisZero, lCofZero,aDevolucao,@aRegM220,@aRegM620,@aRegM230,@aRegM630,cAliasSB1,lCpoMajAli,@aRegM400,@aRegM410,@aRegM800,@aRegM810,lCmpDescZF)

								If lAchouCDG
									ProceRefer(@aRegD309,nPosD300,@aReg1010,@aReg1020,"D309")
								EndIf
							EndIF
						EndIF
					//Modelos NFSC, NTST.
					ElseIf cEspecie $"21/22"
						If cEntSai == "1" //Entradas
							If lGravaNFE
								If (cAliasSFT)->FT_CSTPIS $ "50/51/52/53/54/55/56" //Gerar somente para operaµes com Direito a Credito.
									RegD501(@aRegD501,cAliasSFT,@aReg0500,@aTotaliza,@aRegAuxM105,cRegime,lCumulativ,cIndApro,aReg0111,cAliasSB1)

									RegD505(@aRegD505,cAliasSFT,@aReg0500,@aTotaliza,@aRegAuxM505,cRegime,lCumulativ,cIndApro,aReg0111,cAliasSB1)
								EndIf	
							EndIF
						ElseIf !cSituaDoc$"02#03"

								RegD600(@aRegD600,@aRegD601,@aRegD605,@aReg0500,cAliasSFT,dDataDe,dDataAte,cEspecie,cSituaDoc, ;
										aPartdoc,@nPosD600,@aRegM210,@aRegM610,aWizard,@aRegM400,@aRegM410,@aRegM800,@aRegM810,;
										lAchouSFX,aTotaliza,lCumulativ,lPisZero, lCofZero,aDevolucao,@aRegM220,@aRegM620,@aRegM230,@aRegM630,cAliasSB1)

								ProceRefer(@aRegD609,nPosD600,@aReg1010,@aReg1020,"D609")
						EndIF
					EndIF
				EndIf
				// Para NF do bloco A no verifiquei o CFOP, portanto na gerao do 0200 deve seguir a mesma id©ia, por isso verifico se cEspecie$"  "
				If !cSituaDoc =="02" .And. lGeraNota .And. (cEspecie$"  " .or. lGravaC100 .Or. !(AllTrim((cAliasSFT)->FT_CFOP)$aCFOPs[02]))

				    If (n02000206:=aScan (aReg0200, {|aX| aX[3]==cProd}))==0
						nPos0200++
						Reg0200(cAlias,@aReg0200,@aReg0190,dDataDe,dDataAte,aProd,cProd,nRelacFil,@aReg0205,lIss,cAliasSB1,cMvEstado,lCmpsSB5,nPos0200,cMVDTINCB1)

					If lAchouCD6
						Reg0206(@aReg0206,cAliasSFT,nRelacFil,"0200"+ cvaltochar(nPos0200),cAlias)
					EndIF
				EndIf

					If (aScan (aReg0190, {|aX| aX[3]==cUnid}) == 0)
						aAdd(aReg0190, {})
						nPos	:=	Len (aReg0190)
						aAdd (aReg0190[nPos], 1)														//relacao pai 0140
						aAdd (aReg0190[nPos], "0190")													//01 - REG
						aAdd (aReg0190[nPos], cUnid)													//02 - UNI
						aAdd (aReg0190[nPos], Posicione("SAH",1,(xFilial("SAH")+cUnid),"AH_DESCPO") )	//03 - DESCR
					EndIf
				EndIF

				If !(cSituaDoc$"02#04#05") .And. lGeraNota .And. ( cEspecie$"  " .Or. lGravaC100 )
					Reg0400(cCodNat,@aReg0400,cDescNat)
				EndIf

				nItem++
				If cEntSai == "1"
					cHAWB := (cAliasSF1)->F1_HAWB
				EndIf

				// --- Ajustes para Sociedade em Conta de Participacao ---
				If lFilSCP .AND. !(cSituaDoc$"02#04#05") .And. !(cIndNatJur$"03#04#05")

					//Processamento dos documentos de entrada - Se Regime diferente de Cumulativo
					If cTpMov == "E" .And. cRegime <> "2" .AND. !lOrgPub

						SpedXAjSCP(2,cAliasSFT,@aAjCredSCP,,lCumulativ,cRegime,dDataAte)
						SpedXAjSCP(3,cAliasSFT,@aAjusteR,,lCumulativ,cRegime,dDataAte)
					Endif

					//Processamento dos documentos de saida que tenham valor de b©bito de PIS e COFINS
					If cTpMov == "S" .AND. (cAliasSFT)->FT_VALPIS > 0 .AND. (cAliasSFT)->FT_VALCOF > 0

						//Chamado com opcao 1 -> Gera os ajustes de contribuicao, registro M210 e M610
						SpedXAjSCP(1,cAliasSFT,@aAjusteR,@aAjusteA,lCumulativ,cRegime,dDataAte)
					Endif
				Endif
				(cAliasSFT)->(DbSkip ())
			EndDo	//ENDDO do item
			
			
			If Interrupcao(lEnd)
				// Verifica se o processamento sera em multithread
				If lProcMThr
					GeraTrb(2, @aArq, @cAlias,.T.,nHandleTRB,nMvQtdThr,cSemaphore )
				Else
					GeraTrb(2, @aArq, @cAlias)
				EndIf

			    lCancel := lEnd
			    Return
			EndIf
			
			If !lSPEDCSC
					//A funcao GravaC100 verifica se o documento fiscal possui pelo menos um item que gera contribuicao ou credito 
			       //e desta forma, se possuir, devera escriturar a nota fiscal em sua integralidade. Ou seja, o registro C100 com
			       //valores totais, e um C170 para cada item da nota.	
					lGravaC100	:=	GravaC100(cChave,cEntSai,aCFOPs)
			EndIF
			
			IF cEntSai == "1" .AND. lSPEDCSC
				lGeraNota	:= .T.
			ElseIf cEspecie $ "01/04/1B" .OR. (cEspecie == "55" .AND. !lConsolid .And. !lEnerEle) .And. !(cMvEstado == "DF" .And. lIss .And. cEspecie = "55")
				lGeraNota := Iif(lGravaC100,lReceita,lGeraNota)
			EndIf

			IF lGeraNota
				If (cEspecie$"01#02#2D#04#06#28#29#55#1B#65") .And. !(cMvEstado == "DF" .And. lIss .And. cEspecie = "55")
					If lGravaC010
						PCGrvReg (cAlias,,aRegC010,,,nPaiC,,,nTamTRBIt)
						lGravaC010 = .F.
					EndIf

					If (cEspecie$"01#04#55#1B#65") .AND. !lEnerEle
						If lGravaC100 .Or. lGerouC170 //Credita

							If cEspecie $ "01/04/1B" .OR. (cEspecie == "55" .AND. !lConsolid) .Or. (cEspecie =="65" .And. dDataDe >= cToD("01/09/2014"))

								RegC100 (cEntSai, aPartDoc, cEspecie, cAlias, nRelacDoc, aCmpAntSFT, aTotaliza, @aRegC100, cChave, cSituaDoc, lAchouSE4, cOpSemF, lAchouSF4, @lGrava0150, cChvNfe, cIndEmit,nPaiC,lPisZero, lCofZero,c1Dupref,c2Dupref, aRegC175)
					
								If !(cSituaDoc$"02#04#05")
									If aExstBlck[08]
										aPEC110	:=	ExecBlock("SPDPISIC",.F.,.F.,{	aCmpAntSFT[1],; 	//FT_NFISCAL
																					aCmpAntSFT[2],; 	//FT_SERIE
																					aCmpAntSFT[3],; 	//FT_CLIEFOR
																					aCmpAntSFT[4],; 	//FT_LOJA
																					aCmpAntSFT[23],;	//FT_ENTRADA
																					cEntSai})			//Entrada/Saida

										For nI := 1 To Len(aPEC110)
											If (nPos := aScan (aRegC110, {|aX| aX[2] == aPEC110[nI][1]})==0)
												RegC110 (cAlias,nRelacDoc,,@aRegC110, @nPosC110, aPEC110[nI]) // Verifica se o codigo da info ja esta lancada no C110

												If (nPos := aScan (aReg0450, {|aX| aX[3]==aPEC110[nI][1]})==0) // Verifica se o codigo da info ja esta lancada no 0450
													Reg0450(,@aReg0450,nRelacFil,aPEC110[nI])
												EndIf
											Endif
										Next nI
										PCGrvReg (cAlias, nRelacdoc, aRegC110,,,IIf(lProcMThr,nPaiC,NIL),,,nTamTRBIt)

									ElseIf lAchouCDT .And. !Empty(CDT->CDT_IFCOMP)
										While !CDT->(Eof()) .And. cChaveCDT == CDT->CDT_FILIAL + CDT->CDT_TPMOV + CDT->CDT_DOC + CDT->CDT_SERIE + CDT->CDT_CLIFOR+ CDT->CDT_LOJA

											If (nPos := aScan (aRegC110, {|aX| aX[2]==CDT->CDT_IFCOMP})==0) // Verifica se o codigo da info ja esta lancada no C110
												RegC110 (cAlias,nRelacDoc,CDT->CDT_IFCOMP,@aRegC110, @nPosC110,,aCmpAntSFT,nMVSPDIFC,lCmpDscComp,CDT->CDT_DCCOMP)

												If (nPos := aScan (aReg0450, {|aX| aX[3]==CDT->CDT_IFCOMP})==0) // Verifica se o codigo da info ja esta lancada no 0450
													Reg0450(CDT->CDT_IFCOMP,@aReg0450,nRelacFil)
												EndIf
											EndIf
											CDT->(DbSkip())
										Enddo
										PCGrvReg (cAlias, nRelacdoc, aRegC110,,,Iif(lProcMThr,nPaiC,NIL),,,nTamTRBIt)
										aRegC110 := {}
										nPosC110 := 0
									EndIf

									If lAchouCDC .And. !Empty(CDC->CDC_IFCOMP)
										While !CDC->(Eof()) .And. cChaveCDC == CDC->CDC_FILIAL + CDC->CDC_TPMOV + CDC->CDC_DOC + CDC->CDC_SERIE + CDC->CDC_CLIFOR+ CDC->CDC_LOJA+ CDC->CDC_GUIA

											If (nPos := aScan (aRegC110, {|aX| aX[2]==CDC->CDC_IFCOMP})==0) // Verifica se o codigo da info ja esta lancada no C110
												RegC110 (cAlias,nRelacDoc,CDC->CDC_IFCOMP,@aRegC110, @nPosC110,,aCmpAntSFT,nMVSPDIFC,,CDC->CDC_DCCOMP)

												If (nPos := aScan (aReg0450, {|aX| aX[3]==CDC->CDC_IFCOMP})==0) // Verifica se o codigo da info ja esta lancada no 0450
													Reg0450(CDC->CDC_IFCOMP,@aReg0450,nRelacFil)
												EndIf
											EndIf
											CDC->(DbSkip())
										Enddo
										PCGrvReg (cAlias, nRelacdoc, aRegC110,,,IIf(lProcMThr,nPaiC,NIL),,,nTamTRBIt)
									Endif

									If lAchouCDG
				  							RegC111 (@aRegC111, nPosC110,@aReg1010,@aReg1020)
				  							PCGrvReg (cAlias, nRelacdoc, aRegC111,,,IIf(lProcMThr,nPaiC,NIL),,,nTamTRBIt)
									EndIf

									//Ponto de Entrada SPDIMP: Para processar o registro C120 caso nao utilize integracao com Average e tabela CD5    
									If aExstBlck[09]
										aPEImport	:=	Execblock("SPDIMP",.F.,.F.,{ aCmpAntSFT[1],; //FT_NFISCAL
																					  aCmpAntSFT[2],; //FT_SERIE
																					  aCmpAntSFT[3],; //FT_CLIEFOR
																					  aCmpAntSFT[4],; //FT_LOJA
																					  aCmpAntSFT[23]})//FT_ENTRADA
									Endif

									If (cEspecie$"01|55") // NF e SPED
										If cEntSai == "1" .And. ( lAchouCD5 .OR. ( Len(aAverage)>0 ) .Or. (Len(aPEImport) >0) )
	
											RegC120(cAlias, nRelacDoc, aAverage, cAlsSF,cAliasCD5, aPEImport,lTop,cAliasSF1,cChvCD5,lAchouCD5,cHAWB,nPaiC)
										EndIf
									EndIf

								EndIf
				        	EndIF
				        EndIf
					ElseIf cEspecie =="02" .AND. cEntSai =="1"
						lGrava0150 := !(cSituaDoc$"02#04#05")

						RegC395 (cAlias,@aRegC395,aTotaliza,aCmpAntSFT,cEspecie,aPartDoc,nRelacDoc, nPaiC,aRegC396)
						PCGrvReg (cAlias, nRelacDoc, aRegC396,,,IIf(lProcMThr,nPaiC,NIL),,,nTamTRBIt)

					Elseif cEspecie $"06/28/29/55" .AND. cEntSai =="1"
						lGrava0150 := !(cSituaDoc$"02#04#05")

						//Gravao do registro C501 - Complemento de operao - PIS.
						PCGrvReg (cAlias, nRelacDoc, aRegC501,,,,,,nTamTRBIt)

						//Gravao do registro C505 - Complemento de operao - COFINS.
						PCGrvReg (cAlias, nRelacDoc, aRegC505,,,,,,nTamTRBIt)
						cCodInfCom := ""
						IF lAchouCDT .And. !Empty(CDT->CDT_IFCOMP)
							cCodInfCom := CDT->CDT_IFCOMP
						EndIF

						RegC500(cAlias,@aRegC500,aTotaliza,aCmpAntSFT,aPartdoc,cEspecie,cSituaDoc,nRelacDoc,cCodInfCom, nPaiC)


						If lAchouCDG
			  				RegC509(@aRegC509,@aReg1010,@aReg1020)
						EndIf

						// Verifica se o codigo da info ja esta lancada no 0450
					  	If (nPos := aScan (aReg0450, {|aX| aX[3]==CDT->CDT_IFCOMP})==0)
							Reg0450(CDT->CDT_IFCOMP,@aReg0450,nRelacFil)
						EndIf

						PCGrvReg (cAlias, nRelacDoc, aRegC509,,,,,,nTamTRBIt)

					EndIf

				//Processamento da nota do bloco D.
				ElseIF cEspecie $"07/08/09/10/18/11/13/22/21/26/57" //Processamento da nota bloco D
					If lGravaD010
						//Gravao do registro D010.
						//€„„„„„„„„„„„„„„„„„„„„„„„„„„™
						PCGrvReg (cAlias,, aRegD010,,,nPaiD,,,nTamTRBIt)
						lGravaD010 = .F.
					EndIf
					lGrava0150 := !(cSituaDoc$"02#04#05") .And. lGravaC100 
					IF cEspecie $"07/08/09/10/11/26/27/57"
						If cEntSai == "1" //Entradas
						   IF lGravaC100
								//Gravao do registro D101.
								PCGrvReg (cAlias, nRelacDoc, aRegD101,,,nPaiD,,,nTamTRBIt)

								//Gravao do registro D105.
								PCGrvReg (cAlias, nRelacDoc, aRegD105,,,nPaiD,,,nTamTRBIt)
								cCodInfCom := ""
								IF lAchouCDT .And. !Empty(CDT->CDT_IFCOMP)
									cCodInfCom := CDT->CDT_IFCOMP
								EndIF

								RegD100(cAlias,@aRegD100,aTotaliza,aCmpAntSFT,aPartdoc,cEspecie,cSituaDoc,cEntSai,cIndEmit,nRelacDoc,cOpSemF,cCmpFrete,cChvCte,cCodInfCom, @aReg0500)
								If lAchouCDG
					  				RegD111(@aRegD111,@aReg1010,@aReg1020)
								EndIf

								PCGrvReg(cAlias, nRelacDoc, aRegD100,,,nPaiD,,,nTamTRBIt)

								PCGrvReg (cAlias, nRelacDoc, aRegD111,,,nPaiD,,,nTamTRBIt)

								// Verifica se o codigo da info ja esta lancada no 0450
							  	If (nPos := aScan (aReg0450, {|aX| aX[3]==CDT->CDT_IFCOMP})==0)
									Reg0450(CDT->CDT_IFCOMP,@aReg0450,nRelacFil)
								EndIf
							EndIF
						EndIf
					ElseIf cEspecie $ "21/22"
						If cEntSai == "1"   //Entradas .
							PCGrvReg (cAlias, nRelacDoc, aRegD501,,,nPaiD,,,nTamTRBIt)

					   		PCGrvReg (cAlias, nRelacDoc, aRegD505,,,nPaiD,,,nTamTRBIt)
					   		cCodInfCom := ""
					   		IF lAchouCDT .And. !Empty(CDT->CDT_IFCOMP)
								cCodInfCom := CDT->CDT_IFCOMP
							EndIF

					   		RegD500(cAlias,nRelacDoc,@aRegD500,aCmpAntSFT,cIndEmit,aPartDoc,cEspecie,cSituaDoc,cEntSai,aTotaliza,cCodInfCom,lAchouSFX, nPaiD)

					   		If lAchouCDG
				  				RegD509(@aRegD509,aReg1010,@aReg1020)
							EndIf

							// Verifica se o codigo da info ja esta lancada no 0450
						  	If (nPos := aScan (aReg0450, {|aX| aX[3]==CDT->CDT_IFCOMP})==0)
								Reg0450(CDT->CDT_IFCOMP,@aReg0450,nRelacFil)
							EndIf

							PCGrvReg (cAlias, nRelacDoc, aRegD509,,,nPaiD,,,nTamTRBIt)
						EndIf
					EndIF
				Else // Notas Bloco A

					lGrava0150 := !(cSituaDoc$"02#04#05") .And. !(cEntSai=="2" .And. IIf(cTipoNf$"BD",(cAlsSA)->A2_TIPO=="F",(cAlsSA)->A1_TIPO=="F") .And. !lMvPartRgA .And. (Empty(aPartDoc[4]) .And. Empty(aPartDoc[5])))
					//Gravao do registro A120.
					If Len(aRegA120) > 0
						PCGrvReg (cAlias, nRelacDoc, aRegA120,,,Iif(lProcMThr,nPaiA,NIL),,,nTamTRBIt)
					EndIF
					PCGrvReg (cAlias, nRelacDoc, aRegA170,,,IIf( lProcMThr,nPaiA, ),,,nTamTRBIt)
					If lGravaA010
						PCGrvReg (cAlias,,aRegA010,,,nPaiA,,,nTamTRBIt)
						lGravaA010 = .F.
					EndIf
					//Processamento do registro A100.
					RegA100(@aRegA100,nRelacDoc,cAlias,cEntSai,cIndEmit,aPartDoc,aCmpAntSFT,cSituaDoc,aTotaliza,cChvNfe,nPaiA,dDataAte,lGrava0150,c1Dupref,c2Dupref,cMvEstado)
					nPosA110 :=0
					//Gravao do registro A100.
					PCGrvReg (cAlias, nRelacDoc, aRegA100,,,nPaiA,,,nTamTRBIt)

			   		If lAchouCDT .And. !Empty(CDT->CDT_IFCOMP)
						While !CDT->(Eof()) .And. cChaveCDT == CDT->CDT_FILIAL + CDT->CDT_TPMOV + CDT->CDT_DOC + CDT->CDT_SERIE + CDT->CDT_CLIFOR+ CDT->CDT_LOJA
							// Verifica se o codigo da info ja esta lancada no A110
							If (nPos := aScan (aRegA110, {|aX| aX[2]==CDT->CDT_IFCOMP})==0)
								//Processamento do registro A110.
								RegA110(@aRegA110,CDT->CDT_IFCOMP,@nPosA110)

								// Verifica se o codigo da info ja esta lancada no 0450
							  	If (nPos := aScan (aReg0450, {|aX| aX[3]==CDT->CDT_IFCOMP})==0)
									Reg0450(CDT->CDT_IFCOMP,@aReg0450,nRelacFil)
								EndIf

							EndIf
							CDT->(DbSkip())
						Enddo
						PCGrvReg (cAlias, nRelacDoc, aRegA110,,,Iif(lProcMThr,nPaiA,NIL),,,nTamTRBIt)
					EndIf
					If lAchouCDG
		  				RegA111 (@aRegA111,nPosA110,@aReg1010,@aReg1020)
		  				PCGrvReg (cAlias, nRelacDoc, aRegA111,,,Iif(lProcMThr,nPaiA,NIL),,,nTamTRBIt)
					EndIf
				EndIf
			EndIF
			//
			If len(aPartDoc) > 0
				If (nPos := aScan (aReg0150, {|aX| aX[3]==aPartDoc[1]})==0)
					If lGrava0150
				   		Reg0150 (@aReg0150, aPartDoc,nRelacFil)
					EndIf
				EndIf
			EndIf
			//Verifica se o processamento foi cancelado
			If Interrupcao(lEnd)
				// ------------------------------------------------------
				// Verifica se o processamento sera em multithread
				If lProcMThr
					GeraTrb(2, @aArq, @cAlias,.T.,nHandleTRB,nMvQtdThr,cSemaphore )
				Else
					GeraTrb(2, @aArq, @cAlias)
				EndIf

			 	lCancel := lEnd
			    Return
			EndIf
			
		EndDo	//ENDDO da NF
		
		
				
		
		#IFDEF TOP
			If (TcSrvType ()<>"AS/400")
				DbSelectArea (cAliasSFT)
				(cAliasSFT)->(DbCloseArea())
			Else
		#ENDIF
				RetIndex("SFT")
				FErase(cIndex+OrdBagExt())
		#IFDEF TOP
			EndIf
		#ENDIF

		cAliasSFT	:=	"SFT"

	Next nContMov

	cAliasSFT	:=	"SFT"

	//Processamento dos registros referentes a Cupom emitidos por ECF
	If lGeraECF
		IncProc("Proc. registros de ECF - Filial: "+AllTrim(SM0->M0_FILIAL) + " - " +  StrZero(n0,3) + " de " + StrZero(Len(aSM0),3) )
		lRegC010 := .F.

		If lProcMThr .AND. cMvSegment=="2"

			//Chama funo dos registros referentes a Cupom emitidos por ECF.
			NwPCProcECF(@aRegC400,@aRegC405,dDataDe,dDataAte,@aRegC481,@aRegC485,@aReg0200,@aReg0205,@aReg0190,cAlias,@lRegC010,;
						cRegime,@aRegM400,@aRegM410,@aRegM800,@aRegM810,@aRegM210,@aRegM610,@aRegC491,@aRegC495,@aRegC490,lCumulativ,nRelacFil,;
						@aRegM230,@aRegM630,@aReg0500,cCGCAnt,lRepCGC,lConsolid, nPaiC, lTop, @aRegC489, @aRegC499,@aReg1010,@aReg1020,;
						@nRelacDoc,@lAchouCDG,aRegC010,@nCt400,nMVM996TPR,lA1_TPREG,cMvEstado,lCmpsSB5,lCpoPtPis,lCpoPtCof,@nPos0200,cSemaphore)

		Else

			//Chama funo dos registros referentes a Cupom emitidos por ECF.
			ProcECF(@aRegC400,@aRegC405,dDataDe,dDataAte,@aRegC481,@aRegC485,@aReg0200,@aReg0205,@aReg0190,cAlias,@lRegC010,;
					cRegime,@aRegM400,@aRegM410,@aRegM800,@aRegM810,@aRegM210,@aRegM610,@aRegC491,@aRegC495,@aRegC490,lCumulativ,nRelacFil,;
					@aRegM230,@aRegM630,@aReg0500,cCGCAnt,lRepCGC,lConsolid, nPaiC, lTop, @aRegC489, @aRegC499,@aReg1010,@aReg1020,;
					@nRelacDoc,@lAchouCDG,aRegC010,@nCt400,nMVM996TPR,lA1_TPREG,cMvEstado,aDevMsmPer)
		EndIf

		IncProc(cStatus )
		//Verifica se grava C010 tamb©m para movimentao de ECF.
		If lRegC010
			If lZerVar .Or. (lRepCGC .And. (aScan(aRegC010, {|aX| aX[2] == SM0->M0_CGC}) == 0)) //Tratamento para consolidar Filiais com mesmo CNPJ.
			//If cCGCAnt <> SM0->M0_CGC .Or. !lRepCGC .Or. (lRepCGC .And. (aScan(aRegC010, {|aX| aX[2] == SM0->M0_CGC}) == 0)) //Tratamento para consolidar Filiais com mesmo CNPJ.
				lGrava0140 := .T.
				RegC010(cAlias,@aRegC010, @nPaiC, @lGravaC010,aWizard[1][7], lZerVar )
				If lGravaC010
					PCGrvReg (cAlias,,aRegC010,,,nPaiC,,,nTamTRBIt)
					lGravaC010 = .F.
				EndIf
			EndIf
		EndIF

	EndIF
	//Chamada para o PE SPDPISTR, que pode ser utilizado para gerar os registros                           
	//*** D350, D359 com eles 1010 e 1020 - Gera automaticamente o bloco M (M210/M610/M400/M410/M800/M810) 
	If lSPDPisTr .AND. !lRgCaxCons

	 	IF lRgCmpDet
			//Gravao do registro D010.
			RegD010(cAlias,@aRegD010, @nPaiD, @lGravaD010)
			If lGravaD010
				PCGrvReg (cAlias,, aRegD010,,,nPaiD,,,nTamTRBIt)
				lGravaD010 = .F.
			EndIf
		EndIF

		// Retorno do ponto de entrada
		aSPDPisTR := ExecBlock("SPDPISTR",.F.,.F.,{nRelacFil,dDataDe,dDataAte})
		// Alimenta array de D350   
	   	If Len(aSPDPisTR)>0 .AND. !Empty(aSPDPisTR[1])
			For nCont:=1 to Len(aSPDPisTR[01])
				aAdd(aRegD350,{})
				nPos := Len(aRegD350)
				For n2Cont:=1 to Len(aSPDPisTR[1,nCont])
					If n2Cont>23
						If lRgCmpDet
							Exit // Carrega apenas as informacoes do D350
						Else
							aAdd(aRegD350[nPos],aSPDPisTR[1,nCont,n2Cont])
						EndIF
					ElseIf n2Cont==23 // Posicao da Conta Contabil.
						If ValType(aSPDPisTR[1,nCont,n2Cont])=="A" // Podendo ser array com as informacoes do 0500
							aAdd(aRegD350[nPos], Reg0500(@aReg0500,aSPDPisTR[1,nCont,n2Cont,6],aSPDPisTR[1,nCont,n2Cont]) )
						Else // Podendo ser apenas o cod. da conta - buscara na CT1
							aAdd(aRegD350[nPos], Reg0500(@aReg0500,aSPDPisTR[1,nCont,n2Cont]) )
						EndIf
					Else
						aAdd(aRegD350[nPos],aSPDPisTR[1,nCont,n2Cont])
					EndIf
				Next n2Cont

				If lRgCmpDet //Ir¡ gerar bloco M se for regime de competencia detalhado
					// Bloco M     
					RegM210(aRegM210,,cRegime,lCumulativ,{},{},.T.,,,,,,,aRegD350[nCont])
					RegM610(aRegM610,,cRegime,lCumulativ,{},{},.T.,,,,,,,aRegD350[nCont])
					//Se possuir retorno nas posicoes 24 a 27, utiliza os codigos para gerar os registros M400, M410, M800 e M810.							
					//O array aAuxD350 eh montado na mesma estrutura do aF100Aux, para que utilize as mesma posicoes ao gerar os registro M400 e M800.	    
					If Len(aSPDPisTR[1,nCont])>23
						// *** PIS
						If (aRegD350[nCont,11] $ "04|06|07|08|09") .OR. ( aRegD350[nCont,11] $ "05" .And. aRegD350[nCont,13] == 0)
							aAuxD350	:=	{"",aRegD350[nCont,09],aRegD350[nCont,11],"","","","","","","","","","","","","","",;
											aSPDPisTR[1,nCont,24],aSPDPisTR[1,nCont,25],aSPDPisTR[1,nCont,26],aSPDPisTR[1,nCont,27]}
							RegM400(@aRegM400,@aRegM410,,,aAuxD350)
						EndIf
						// *** COFINS
						If (aRegD350[nCont,17] $ "04|06|07|08|09") .OR. ( aRegD350[nCont,17] $ "05" .And. aRegD350[nCont,19] == 0)
							aAuxD350	:=	{"",aRegD350[nCont,09],"","","","",aRegD350[nCont,17],"","","","","","","","","","",;
											aSPDPisTR[1,nCont,24],aSPDPisTR[1,nCont,25],aSPDPisTR[1,nCont,26],aSPDPisTR[1,nCont,27]}
							RegM800(@aRegM800,@aRegM810,,,aAuxD350)
						EndIf
					EndIf

				EndIF
			Next nCont
		EndIf
		// Alimenta array de D359   
		If Len(aSPDPisTR)>1 .AND. !Empty(aSPDPisTR[2])
			For nCont:=1 to Len(aSPDPisTR[2])
		   		aAdd(aRegD359,{})
				nPos := Len(aRegD359)
				For n2Cont:=1 To Len(aSPDPisTR[2,nCont])
			   		aAdd(aRegD359[nPos],aSPDPisTR[2,nCont,n2Cont])
				Next n2Cont
			Next nlCont
		EndIf
		// Alimenta array de 1010   
		If Len(aSPDPisTR)>2 .AND. !Empty(aSPDPisTR[3])
			For nCont:=1 to Len(aSPDPisTR[3])
				Reg1010(@aReg1010,aSPDPisTR[3,nCont])
			Next nCont
		EndIf
		// Alimenta array de 1020   
		If Len(aSPDPisTR)>3 .AND. !Empty(aSPDPisTR[4])
			For nCont:=1 to Len(aSPDPisTR[4])
				Reg1020(@aReg1020,aSPDPisTR[4,nCont])
			Next nCont
		EndIf

		If lRgCmpCons
			//Regime de competencia consolidado
			For nCont := 1 to Len(aRegD350)
				aParF550 		:=	{}
				lPauta			:= .F.

				//Se tem valor de pauta de PIS e COFINS
				If aRegD350[nCont][15] > 0 .OR. aRegD350[nCont][20] > 0
					lPauta	:= .T.
					nAlqPis		:= aRegD350[nCont][15]
					nBasePis	:= aRegD350[nCont][14]
					nAlqCof		:= aRegD350[nCont][21]
					nBaseCof	:= aRegD350[nCont][20]

				Else
					nAlqPis		:= aRegD350[nCont][13]
					nBasePis	:= aRegD350[nCont][12]
					nAlqCof		:= aRegD350[nCont][19]
					nBaseCof	:= aRegD350[nCont][18]
				EndIF
				nValPis		:= aRegD350[nCont][16]
				nValCof		:= aRegD350[nCont][22]

				aAdd(aParF550,Iif (lPauta,"F560","F550"))
				aAdd(aParF550,aRegD350[nCont][10])
				aAdd(aParF550,aRegD350[nCont][11])
				aAdd(aParF550,0)
				aAdd(aParF550,nBasePis)
				aAdd(aParF550,nAlqPis)
				aAdd(aParF550,nValPis)
				aAdd(aParF550,aRegD350[nCont][17])
				aAdd(aParF550,0)
				aAdd(aParF550,nBaseCof)
				aAdd(aParF550,nAlqCof)
				aAdd(aParF550,nValCof)
				aAdd(aParF550,aRegD350[nCont][2])
				aAdd(aParF550,"" )
				aAdd(aParF550,aRegD350[nCont][23])
				aAdd(aParF550,"")

				If Len(aRegD350[nCont])>23
					aAdd(aParF550,aRegD350[nCont][24])
					aAdd(aParF550,aRegD350[nCont][25])
					aAdd(aParF550,aRegD350[nCont][26])
					aAdd(aParF550,aRegD350[nCont][27])
				Else
					aAdd(aParF550,"")
					aAdd(aParF550,"")
					aAdd(aParF550,"")
					aAdd(aParF550,"")
				EndIF

				//Gera registros F550/F560 e feilhos
				RegimeComp(@aRegF550,@aRegF560,@aRegM210,@aRegM610,aParF550,lPauta,@aRegM400,@aRegM410,@aRegM800,;
							@aRegM810,lAchouCDG,cAliasCDG,lTop,@aRegF559,@aRegF569,@aReg1010,@aReg1020,@aReg0500,;
							.T.,cAliasSFT,@aRegM230,@aRegM630,@aRegM220,@aRegM620,aDevolucao,aDevMsmPer,,@nPosF500)


				//Acumula valores no registro 1900
				Reg1900Com (@aReg1900,aRegD350[nCont][2], aRegD350[nCont][23], "00",SM0->M0_CGC,"", aRegD350[nCont][10],aRegD350[nCont][11],aRegD350[nCont][17], ,"")


				For n2Cont:= 1 to len(aRegD359)

					//processo referenciado vinculado aos dos valores do D350 processados no F550
					If aRegD359[n2Cont][1] == nCont
						//Ento ir¡ gravar F559 ou F569
						IF lPauta
					   		aAdd(aRegF569,{})
							nPosF559 := Len(aRegF569)

							aAdd (aRegF569[nPosF559], nPosF500 )
							aAdd (aRegF569[nPosF559], aRegD359[n2Cont][1] )
							aAdd (aRegF569[nPosF559], aRegD359[n2Cont][1] )
							aAdd (aRegF569[nPosF559], aRegD359[n2Cont][1] )
						Else
					   		aAdd(aRegF559,{})
							nPosF559 := Len(aRegF559)

							aAdd (aRegF559[nPosF559], nPosF500 )
							aAdd (aRegF559[nPosF559], aRegD359[n2Cont][1] )
							aAdd (aRegF559[nPosF559], aRegD359[n2Cont][1] )
							aAdd (aRegF559[nPosF559], aRegD359[n2Cont][1] )

						EndIF

					EndIF

				next n2Cont

			Next nCont
			aRegD359	:= {}
			aRegD350	:= {}
		EndIF

	EndIf

	If Interrupcao(lEnd)
		// ------------------------------------------------------
		// Verifica se o processamento sera em multithread
		If lProcMThr
			GeraTrb(2, @aArq, @cAlias,.T.,nHandleTRB,nMvQtdThr,cSemaphore )
		Else
			GeraTrb(2, @aArq, @cAlias)
		EndIf

	 	lCancel := lEnd
	    Return
	EndIf
	//Chamada da funo para gerao do registro M350, PIS sobre folha de sal¡rios
	//Ser¡ gerado quando for Sociedade Cooperativa ou InS sobre folha de sal¡rios
    IF !lRgCaxCons
	    If FindFunction("fM350VlPis") .AND. (cIndNatJur == "01" .OR. cIndNatJur == "02")
			IncProc("Processando registro M350. Filial "+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL))
			aM350Aux:=fM350VlPis( SM0->M0_CODFIL, SM0->M0_CODFIL, ddatade, ddataAte)
			If Len(aM350Aux ) > 0
				If len(aRegM350) > 0
					aRegM350[1][2] += aM350Aux[1][2]
					aRegM350[1][3] += aM350Aux[1][3]
					aRegM350[1][4] += aM350Aux[1][4]
					aRegM350[1][5] := aM350Aux[1][5]
					aRegM350[1][6] += aM350Aux[1][6]

				Else
					aAdd(aRegM350, {})
					nPosM350 := Len(aRegM350)
					aAdd (aRegM350[nPosM350], "M350")
					aAdd (aRegM350[nPosM350], aM350Aux[1][2])
					aAdd (aRegM350[nPosM350], aM350Aux[1][3])
					aAdd (aRegM350[nPosM350], aM350Aux[1][4])
					aAdd (aRegM350[nPosM350], aM350Aux[1][5])
					aAdd (aRegM350[nPosM350], aM350Aux[1][6])
				EndIF
			EndIF
		EndIF
	EndIF
	

		

	IncProc("Buscando Informaµes bloco F600 Filial "+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL))
	aF600Aux:= FinSpdF600(Month(dDataDe),Year(dDataDe))  //Retornar retenµes

	IF !lRgCaxCons
	    //Processamento dos registros do bloco F                     
		//Utiliza funcoes disponibilizadas pelo modulo do Financeiro.
		If lRgCmpCons
			IncProc("Buscando Outros Documentos "+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL))
		Else
			IncProc("Buscando Informaµes bloco F100 Filial "+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL))
		EndIF
		aRegFAux := FinSpdF100(Month(dDataDe),Year(dDataDe),,,,Iif(lRgCmpDet,"F100","F550")) //Retornar t­tulos sem notas do financeiro
	EndIF

	If lBlocACDF

		//Parametros que serao enviados para a DeprecAtivo()	
		aAdd(aProcItem,"") 			//Ativo Inicial
		aAdd(aProcItem,"zz") 		//Ativo Final
		aAdd(aProcItem,CToD("")) 	//Data Inicial da aquisio
		aAdd(aProcItem,dDataAte) 	//Data Final da aquisio
		aAdd(aProcItem,"ATI")      	//Tabela Temporaria

		//Se for exclusivamente Cumulativo, no ir¡ Processar F120 e F130.
		IF !cRegime == "2"

			If FindFunction("_DeprecAtivo") .AND. FindFunction("_AtfRegF130")
				//Processamento do Registro F120 - BENS INCORPORADOS AO ATIVO IMOBILIZADO 
				IncProc("Buscando Informaµes bloco F120 Filial "+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL))
				aF120Aux := _DeprecAtivo(dDatade,dDataAte,.T.,.F.,aProcItem,,.F.,"09/11",SM0->M0_CODFIL,.F.)

				DbSelectArea("ATI")
				ATI->(DbSetOrder(1))
				ATI->(dbGoTop())

				IncProc("Processando Informaµes bloco F120 Filial "+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL))
			   	IF !ATI->(EOF()) .and. ATI->(FieldPos("NATBCCRED"))>0
					RegF120(@aRegF120,aF120Aux[1,2],@aReg0500,@aReg0600,@aRegAuxM105,@aRegAuxM505,cRegime,cIndApro,aReg0111,@aRegF129,@aReg1010,@aReg1020)
				EndIF

				DbSelectArea(aF120Aux[1,2])
				dbCloseArea()
				Ferase(aF120Aux[1,1]+GetDBExtension())
				Ferase(aF120Aux[1,1]+OrdBagExt())

				//Processamento do Registro F130 - BENS INCORPORADOS AO ATIVO IMOBILIZADO 
				IncProc("Buscando Informaµes bloco F130 Filial "+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL))
				cAliasF130 	:= GetNextAlias()
				cArqDestino := "SPEDPIS"+GetDbExtension()
				aResult 	:= _AtfRegF130(cFilAnt,dDataDe,dDataAte,"0000000","ZZZZZZZZZ",cAliasF130,.T.,"10")

				IncProc("Processando Informaµes bloco F130 Filial "+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL))
			 	If Len(aResult) > 0
					RegF130(@aRegF130,aResult[1,2],@aReg0500,@aReg0600,@aRegAuxM105,@aRegAuxM505,cRegime,cIndApro,aReg0111,@aRegF139,@aReg1010,@aReg1020)
					lGrava0140 := .T.
				EndIf
			EndIf

		EndIF
	EndIF

	//Processamento do registro F700 - DEDUCOES DE PIS E COFINS 
	IncProc("Processando Informaµes bloco F700 Filial "+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL))
	RegF700(cPer, @aRegF700,lTabCF2,@nCrPrAlPIS,@nCrPrAlCOF)

	If Len(aRegFAux) > 0 .OR. Len(aF600Aux) > 0 .OR. Len(aRegF130) > 0 .OR. Len(aRegF120) > 0  .OR. Len(aRegF700) > 0 .Or. aExstBlck[04] .OR. aIndics[20]

		lGrava0140 := .T.


		//Processa registro F010	
		If cCGCAnt <> SM0->M0_CGC .Or. !lRepCGC .Or. (lRepCGC .And. (aScan(aRegF010, {|aX| aX[2] == SM0->M0_CGC}) == 0)) //Tratamento para consolidar Filiais com mesmo CNPJ.
			lGrava0140 := .T.
			RegF010(cAlias, @aRegF010, @nPaiF, @lGravaF010)
		EndIf

		//Processa registro F600 - RETENCOES DE PIS e COFINS		
		IncProc("Processando Informaµes bloco F600 Filial "+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL))
		RegF600(@aRegF600,aF600Aux,@aReg1300,@aReg1700,@aF600Tmp)

		IF !lRgCaxCons .AND. !lBlocoI

			//Processa registro F100 - DEMAIS DOCUMENTOS E OPERACOES GERADORAS DE CONTRIBUICAO E CREDITOS
			IncProc("Processando Informaµes bloco F100 Filial "+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL))

			RegF100(@aRegF100,		aRegFAux,	@aRegM210,	@aRegM610,		@aRegAuxM105,;
					@aRegAuxM505,	cRegime,	cIndApro,	aReg0111,		@aReg0150,;
					dDataDe,		dDataAte,	nRelacFil,	SM0->M0_CODFIL,	@aRegM400,;
					@aRegM410,		@aRegM800,	@aRegM810,	lSpdP09,		@aReg0500,;
					@aRegM230,		@aRegM630,	@aReg0600,	@aReg0200,		@aReg0190,;
					@aReg0205,		lRgCmpCons,	@aRegF550,	@aRegF560,		@aReg1900,;
					@aRegF111,		@aReg1010,	@aReg1020,	@aRegF559,		@aRegF569,;
					lFilSCP,		@aAjCredSCP,@aAjusteR,	@aAjusteA,		cRegime,;
					cIndNatJur)
		EndIF

		IF lBlocACDF

			//Processamento do regiustro F150, que trata de valores de cr©dito de PIS e COFINS sobre abertura de estoque.
			IF !cRegime == "2"
				IncProc("Processando Informaµes bloco F150 Filial "+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL))
		        IF aIndics[21]
			        RegF150(dDataDe,@aRegF150,@aReg0500,@aRegAuxM105,@aRegAuxM505,cRegime,cIndApro,aReg0111)
			 	EndIF
			 EndIF
		EndIF

		//PE para geracao dos registros F200/F205/F210 - ATIVIDADE IMOBILIARIA 
    	If aExstBlck[10]

			//Retorno esperado do PE  
			//                        
			//aRetImob[1] = F200      
			//aRetImob[2] = F205      
			//aRetImob[3] = F210      
		    aRetImob := ExecBlock("SPDPCIMOB",.F.,.F.,{aWizard})

		    If Len(aRetImob)>0 .And. ValType(aRetImob[1]) == "A"

				//Baseando-se no registro F200 (Pai) processo os filhos F205 e F210
				For nX:=1 To Len(aRetImob[1])

					RegF200(aRetImob[1][nX],@aRegF200,@aRegM210,@aRegM610)

					If cRegime <> "2"  //Se for diferente de Exclusivamente Cumulativo ir¡ processar os registros de cr©ditos, caso contr¡rio no processa.
						If Len(aRetImob)>1 .And. ValType(aRetImob[2]) == "A" .And. Len(aRetImob[2])>=nX .And. ValType(aRetImob[2][nX])=="A" .And. Len(aRetImob[2][nX])>18 .And. aRetImob[2][nX][2]=="F205"
					 		RegF205(aRetImob[2][nX],@aRegF205,@aRegAuxM105,@aRegAuxM505,@aVlCrdImob,aReg0111)
					 	EndIf

						If Len(aRetImob)>2 .And. ValType(aRetImob[3]) == "A"
							RegF210(aRetImob[3],@aRegF210,nX,@aRegAuxM105,@aRegAuxM505,@aVlCrdImob,aReg0111)
						EndIf
					EndIF

					IF lRgCmpCons
						aParF550	:= {}

						aAdd(aParF550,"F550")
						aAdd(aParF550,aRetImob[1][nX][11])
						aAdd(aParF550,aRetImob[1][nX][12])
						aAdd(aParF550, 0)
						aAdd(aParF550,aRetImob[1][nX][13])
						aAdd(aParF550,aRetImob[1][nX][14])
						aAdd(aParF550,aRetImob[1][nX][15])
						aAdd(aParF550,aRetImob[1][nX][16])
						aAdd(aParF550, 0)
						aAdd(aParF550,aRetImob[1][nX][17])
						aAdd(aParF550,aRetImob[1][nX][18])
						aAdd(aParF550,aRetImob[1][nX][19])
						aAdd(aParF550, "")
						aAdd(aParF550, "")
						aAdd(aParF550, "")
						aAdd(aParF550, "")
						aAdd(aParF550,"")
						aAdd(aParF550,"")
						aAdd(aParF550,"")
						aAdd(aParF550,"")

						//Acumula valores no registro 1900
						Reg1900Com (@aReg1900,"99", "", "00",SM0->M0_CGC,"", aRetImob[1][nX][11],aRetImob[1][nX][12],aRetImob[1][nX][16], ,aRetImob[1][nX][22])

					EndIF

				Next nX
	    	EndIf

    	EndIf

	EndIF
	//Processa registro I010	
	If cCGCAnt <> SM0->M0_CGC .Or. !lRepCGC .Or. (lRepCGC .And. (aScan(aRegI010, {|aX| aX[2] == SM0->M0_CGC}) == 0)) //Tratamento para consolidar Filiais com mesmo CNPJ.
		lGrava0140 := .T.
		RegI010(cAlias, @aRegI010, @nPaiI, @lGravaI010,SubStr(aWizard[4][7],1,2))
		/*If lGravaI010
			PCGrvReg (cAlias,,aRegI010,,,nPaiI,,,nTamTRBIt)
			lGravaI010 := .F.
		EndIf*/
	EndIf

	// ------------------------------------------------------------------
	// Processa valores do bloco I com integrao do Financeiro e Saºde
	// ------------------------------------------------------------------
	If lBlocoI
		IncProc("Processando Informaµes do bloco I Filial "+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL))
		SPDCBlocoI(@aRegI100,@aRegI200,@aRegI299,@aRegI300,@aRegI399,@aReg0500,@aReg1010,@aReg1020,nPaiI,dDataDe,dDataAte,;
			SubStr(aWizard[4][7],1,2),@aRegM400,@aRegM410,@aRegM800,@aRegM810,@aRegI199)

		ApurBlocI(@aRegI100,@aRegM210,@aRegM610)
	EndIF
    //Nao verifico o tipo do regime pois nos casos de Vendas Canceladas, o Regime Nao-Cumulativo	
	//tambem esta sujeito a reducao da base de calculo, assim como no Regime Cumulativo.			
	//Se o Cancelamento ocorreu no mesmo periodo, faco a reducao da base de calculo nos registros	
	//C100/C170(individ.) ou C180(consolid.). Se o Cancelamento ocorreu em outros periodos, faco	
	//os Ajustes atraves dos registro M220 e M620.													
	IF lGrBlocoM .AND. !lRgCaxCons
		AbateDev( @aRegM210, @aRegM220, @aRegM610, @aRegM620,,aDevAntPer)

		//Diferimento de Orgao Publico				
		If lOrgPub .And. lTabCFA
			ProcDifer(dDataDe,@aDifer,@aDiferAnt)
		Endif

		//Chama CFA2 para guardar em array o retorno da query CFA considerando xfilial corrente.
		IF lTabCFA .And. SPEDFFiltro(1,"CFA2",@cAlsCFA,{cPer,"",""}) //colocar no filtro al­quota do cr©dito
			Do While !(cAlsCFA)->(EOF())
			  	nPosCFA := aScan (aCFA, {|aX| aX[1]==(cAlsCFA)->CFA_TPCON  .AND. aX[2] == (cAlsCFA)->CFA_CODCRE  .AND. aX[3] == (cAlsCFA)->CFA_PERAPU })

				If nPosCFA ==0
					aAdd(aCFA, {})
					nPos := Len(aCFA)
					aAdd (aCFA[nPos], (cAlsCFA)->CFA_TPCON)
					aAdd (aCFA[nPos], (cAlsCFA)->CFA_CODCRE)
					aAdd (aCFA[nPos], (cAlsCFA)->CFA_PERAPU)
					aAdd (aCFA[nPos], (cAlsCFA)->CFA_CREDIF)
				Else
					aCFA[nPosCFA][4]+=(cAlsCFA)->CFA_CREDIF
				EndIF

				(cAlsCFA)->(DBSKIP())
			EndDo
		EndIF

	Endif

	IncProc("Finalizando processamento da Filial "+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL))
	If Len(aResult) > 0
		//Fechar os arquivos do ativo
		(aResult[1,2])->(DbCloseArea ())
		FERASE(ARESULT[1,1]+GetDbExtension())
		fErase(ARESULT[1,1]+OrdBagExt())
	EndIf

	IF nRelacFil == 1
		lGrava0140 := .T.
	EndIF
	If lGrava0140
		Reg0140(@aReg0140)
	EndIF

	If n0+1 <= Len(aSM0) //Tratamento para consolidar Filiais com mesmo CNPJ.
		If aSM0[n0][5] == aSM0[n0+1][5]
			lFilGra := .F.
		Else
			lFilGra := .T.
		EndIF
		cCGCAnt := aSM0[n0][5]
	Else
		lFilGra := .T.
	EndIF
	IncProc("Finalizando processamento da Filial "+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL))

	If cBlocoP $ "1/3" .And. FindFunction("fS033Sped") .And. FindFunction("RhInssPat")
		IF lMtBlcP // se for processamento multithread do bloco P
			While .T.
				nMTP++
				//Verifica se j¡ finalizou o processamento
				IF GetGlbValue( cJobPAux ) == '1'
					dbUseArea( .T. ,__cRdd , cNomeTRBP , cAliasP , .T. , .F. )
					(cAliasP)->( dbClearIndex() , dbSetIndex(cNomeTRBP + '_01' ) )
					lProcBlcP	:= .T. //Thread finalizou processamento
					Exit
				ElseIF GetGlbValue( cJobPAux ) == '2'
					lProcBlcP	:= .F. //Thread no finalizou processamento por algum motivo
					Exit

				/*ElseIF nMTP >=5
					lProcBlcP	:= .F. //Thread no finalizou processamento por algum motivo
					Exit*/
				EndIF
				Sleep(2500)
			End
		Else
			lProcBlcP	:= .T.
		EndIF

		IF lProcBlcP
			//Verifica se gera bloco P
			DbSelectArea(cAliasP)
			(cAliasP)->(DbSetOrder(1))
			(cAliasP)->(dbGoTop())

			IncProc("Processando Informaµes bloco P Filial "+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL))
			If (cAliasP)->(!EOF())

				If RegP100(@aRegP100,@aRegP200, @aReg0145,lBlocoPRH, cAliasP , nRelacFil,nPaiP,cSPCBPSE,cPCodServ,cPCodDem, nTotF,@nTotPrev,@nTotAt,,,,,aRecBrtFil)

					If cCGCAnt <> SM0->M0_CGC .Or. !lRepCGC .Or. (lRepCGC .And. (aScan(aRegP010, {|aX| aX[2] == SM0->M0_CGC}) == 0)) //Tratamento para consolidar Filiais com mesmo CNPJ.
						lGrava0140	:= Iif(lRepCGC,Iif(cCGCAnt <> SM0->M0_CGC .Or. (aScan(aReg0140, {|aX| aX[4] == SM0->M0_CGC}) == 0),.T.,.F.),.T.) //Tratamento para consolidar Filiais com mesmo CNPJ.
						If lGrava0140
							Reg0140(@aReg0140)
						EndIf
						RegP010(@aRegP010, @nPaiP)
						PCGrvReg (cAlias,Iif(lProcMThr , nRelacFil, NIL ),aRegP010,,,nPaiP,,,nTamTRBIt)
					EndIf

					Reg0145(@aReg0145, nTotal, nTotAt, nTotPrev, cCodIncT)
				EndIf
		    EndIf

			DbSelectArea(cAliasP)
			(cAliasP)->( DbCloseArea() )
			IF lMtBlcP
				PCDelTmpDB(cNomeTRBP,.F.)
			EndIF
		EndIF

		If cBlocoP == "3"
			If n0+1 <= Len(aSM0) //Tratamento para consolidar Filiais com mesmo CNPJ.
				If aSM0[n0][5] == aSM0[n0+1][5]
					lFilGra := .F.
				Else
					lFilGra := .T.
				EndIF
				cCGCAnt := aSM0[n0][5]
			Else
				lFilGra := .T.
			EndIF

		   	If lFilGra .Or. !lRepCGC
				PCGrvReg (cAlias, Iif(lProcMThr,nRelacFil,NIL) , aRegP100,,,nPaiP,,,nTamTRBIt)
			EndIf
			SM0->( dbSkip() )
			Loop

		EndIf

	EndIF
	
	
					

	If lFilGra .Or. !lRepCGC //Tratamento para consolidar Filiais com mesmo CNPJ.
		If lBlocACDF
			//GERACAO DOS REGISTROS 0150, 0200, 0500 E 0600 DE CREDITO EXTEMPORANEO PARA PIS.
			If aIndics[18]
				RegExtR(@aReg0150,@aReg0200,@aReg0500,@aReg0600,@aReg0190,@aReg0205,@aReg0140)
			EndIf
	
			
			//GRAVACAO - REGISTRO C180, C185 e C188.
			GrRegDep (cAlias, aRegC180, aRegC181,   ,,,,nPaiC)
			GrRegDep (cAlias, aRegC180, aRegC185,.T.,,,,nPaiC)
			GrRegDep (cAlias, aRegC180, aRegC188,.T.,,,,nPaiC)

			//GRAVACAO - REGISTRO C190, C191, C195, C198, C199. 
			GrRegDep (cAlias, aRegC190, aRegC191,   ,,,,nPaiC)
			GrRegDep (cAlias, aRegC190, aRegC195,.T.,,,,nPaiC)
			GrRegDep (cAlias, aRegC190, aRegC198,.T.,,,,nPaiC)
			GrRegDep (cAlias, aRegC190, aRegC199,.T.,,,,nPaiC)
			
			//GRAVACAO - REGISTRO C380.
			PCGrvReg (cAlias,nPaiC, aRegC380,,,nPaiC,,,nTamTRBIt)

			//GRAVACAO - REGISTRO C381  
			PCGrvReg (cAlias,nPaiC, aRegC381,,,nPaiC,,,nTamTRBIt)

			//GRAVACAO - REGISTRO C385.
			PCGrvReg (cAlias,nPaiC, aRegC385,,,nPaiC,,,nTamTRBIt)

			If lConsolid //Se no for consolidado
				//GRAVACAO - REGISTRO C490, C491, C495. 
				If !lProcMThr
					GrRegDep (cAlias, aRegC490, aRegC491,   , , , ,nPaiC)
					GrRegDep (cAlias, aRegC490, aRegC495,.T., , , ,nPaiC)
				Else
					GrRegDep (cAlias, aRegC490, aRegC491,   , , , ,nPaiC,,.T.,@aJobAux,cSemaphore)
					GrRegDep (cAlias, aRegC490, aRegC495,.T., , , ,nPaiC,,.T.,@aJobAux,cSemaphore)
				EndIf
				GrRegDep (cAlias, aRegC490, aRegC499,.T., , , ,nPaiC)
			EndiF

			//GRAVACAO - REGISTRO C600, C601, C605, C609 
 			GrRegDep (cAlias, aRegC600, aRegC601,   ,,,,nPaiC)
			GrRegDep (cAlias, aRegC600, aRegC605,.T.,,,,nPaiC)
			GrRegDep (cAlias, aRegC600, aRegC609,.T.,,,,nPaiC)

			//GRAVACAO - REGISTRO D200, D201, D205, D509.
			GrRegDep (cAlias, aRegD200, aRegD201,   ,,,,nPaiD)
			GrRegDep (cAlias, aRegD200, aRegD205,.T.,,,,nPaiD)
			GrRegDep (cAlias, aRegD200, aRegD209,.T.,,,,nPaiD)

			//GRAVACAO - REGISTRO D300, D309.
			GrRegDep (cAlias, aRegD300, aRegD309,,,,,nPaiD)
			GrRegDep (cAlias, aRegD350,aRegD359,   , , , ,nPaiD)

			//GRAVACAO - REGISTRO D600, D601, D605, D609.
			GrRegDep (cAlias, aRegD600, aRegD601,   ,,,,nPaiD)
			GrRegDep (cAlias, aRegD600, aRegD605,.T.,,,,nPaiD)
			GrRegDep (cAlias, aRegD600, aRegD609,.T.,,,,nPaiD)

			//GRAVACAO - REGISTRO F100, F130,F200, F600 e F700.            
			GrRegDep (cAlias, aRegF100, aRegF111,,,,,nPaiF)
			GrRegDep (cAlias, aRegF120, aRegF129,,,,,nPaiF)
			GrRegDep (cAlias, aRegF130, aRegF139,,,,,nPaiF)
			PCGrvReg (cAlias, Iif(lProcMThr,nRelacFil,NIL) , aRegF150,,,nPaiF,,,nTamTRBIt)

		EndIF

		GrRegDep  (cAlias, aRegF200,aRegF205,,,,,nPaiF)
		GrRegDep  (cAlias, aRegF200,aRegF210,.T.,,,,nPaiF)

		//GRAVACAO - REGISTRO 0140, 0150, 0190, 0200, 0205, 0400, 0450.
	 	//GrRegDep (cAlias, aReg0140, aReg0145,   ,,,,nRelacFil)

	 	If !lProcMThr
			GrRegDep (cAlias, aReg0140, aReg0150,.F.,,,,nRelacFil)
		Else
			GrRegDep (cAlias, aReg0140, aReg0150,.F.,,,,nRelacFil,,.T.,@aJobAux,cSemaphore)
		EndIf

		GrRegDep (cAlias, aReg0140, aReg0190,.T.,,,,nRelacFil)

		If !lProcMThr
			GrRegDep (cAlias, aReg0140, aReg0200,.T.,460,,,nRelacFil)
		Else
			GrRegDep (cAlias, aReg0140, aReg0200,.T.,460,,,nRelacFil,,.T.,@aJobAux,cSemaphore)
		EndIf

		GrRegDep (cAlias, aReg0200, aReg0205,.T.,,.F.,,nRelacFil)
		GrRegDep (cAlias, aReg0140, aReg0400,.T.,,,,nRelacFil)
		GrRegDep (cAlias, aReg0140, aReg0450,.T.,,,,nRelacFil)

		PCGrvReg (cAlias, Iif(lProcMThr,nRelacFil,NIL) , aRegF600,,,nPaiF,,,nTamTRBIt)
		PCGrvReg (cAlias, Iif(lProcMThr,nRelacFil,NIL) , aRegF700,,,nPaiF,,,nTamTRBIt)
		GrRegDep  (cAlias, aRegF500, aRegF509,,,,,nPaiF)
		GrRegDep  (cAlias, aRegF510, aRegF519,,,,,nPaiF)
		PCGrvReg (cAlias, Iif(lProcMThr,nRelacFil,NIL) , aRegF525,,,nPaiF,,,nTamTRBIt)
		GrRegDep  (cAlias, aRegF550, aRegF559,,,,,nPaiF)
		GrRegDep  (cAlias, aRegF560, aRegF569,,,,,nPaiF)
		
		If lGravaF010 .and. (len(aRegf100)>0 .or. len(aRegf111)>0 .or. len(aRegF120)>0 ;
			.or. len(aRegF129)>0 .or. len(aRegF130)>0 .or. len(aRegF139)>0 .or. len(aRegF200)>0 ;
			.or. len(aRegF210)>0 .or. len(aRegF500)>0 .or. len(aRegF509)>0 .or. len(aRegF519)>0 ;
			.or. len(aRegF550)>0 .or. len(aRegF559)>0 .or. len(aRegF560)>0 .or. len(aRegF569)>0 ;
			.or. len(aRegF600)>0 .or. len(aRegF700)>0)
			PCGrvReg (cAlias,,aRegF010,,,nPaiF,,,nTamTRBIt)
			lGravaF010 := .F.
		EndIf

		If cBlocop == "1"
			//GRAVACAO - REGISTRO P100                                     
			PCGrvReg (cAlias,Iif(lProcMThr,nRelacFil,NIL) , aRegP100,,,nPaiP,,,nTamTRBIt)
		EndIf

		aAdd(aReg0140Ex, {AllTrim(cFilAnt), xFilial("SB1"), NIL, aReg0140[1][4]})

	EndIf

Next(n0) //Next da SM0 para a mesma EMPRESA

//Controle de Seguranca para MULTI-THREAD
If lProcMThr

	For nContJob := 1 To Len( aJobAux )
		// Informacoes do semaforo
		cJobFile	:=	aJobAux[ nContJob ]
		While .T.
			If Val( GetGlbValue( cJobFile ) ) < 5
				Conout( Replicate( '-' , 65 ) )
				Conout( 'GrRegDep: ' + 'StartJob em processamento ( ' + GetGlbValue( cJobFile ) + ' ) : ' + cJobFile + ' -> Thread: ' + StrZero(nContJob,6) )
				Conout( Replicate( '-' , 65 ) )

			Else
				If !File( cJobFile )
				  		Conout( Replicate( '-' , 65 ) )
				 		Conout( 'GrRegDep: ' + 'Termino do processamento MThread : ' + cJobFile + ' -> Thread: ' + StrZero(nContJob,6))
						Conout( Replicate( '-' , 65 ) )

				ElseIf GetGlbValue( cJobFile ) == '6'
						Conout( Replicate( '-' , 65 ) )
				  		Conout( 'GrRegDep: ' + 'StartJob com problemas de semaforo ( ' + GetGlbValue( cJobFile ) + ' ) : ' + cJobFile + ' -> Thread: ' + StrZero(nContJob,6) + '( IGNORANDO SEMAFORO)')
						Conout( Replicate( '-' , 65 ) )
				EndIf

				ClearGlbValue( cJobFile )
			    Exit
			EndIf
			Sleep(2500)
		End
	Next nContJob
	// Baixa as Threads do Ar
	For nCont:=1 To nMvQtdThr
		IPCGo( cSemaphore, "_E_X_I_T_")
		Sleep(1000)
	Next nCont
EndIf


If cBlocoP == "3"
	GrRegDep (cAlias, aReg0140, aReg0145,.F.,,,,nRelacFil)
ElseIf cBlocoP == "1"
	GrRegDep (cAlias, aReg0140, aReg0145,.T.,,,,1)
Endif

RestArea (aAreaSM0)
cFilAnt := FWGETCODFILIAL

//PE para geracao do registro 1800 do Sped Pis Cofins
If aExstBlck[11]
	aReg1800 := ExecBlock("SPDPC1800",.F.,.F.,{aWizard})
	If ValType(aReg1800) <> "A" .Or. Len(aReg1800) <= 0
		aReg1800 := {}
	EndIf
EndIf

//GRAVACAO - REGISTRO 0111 
IF cIndApro == "2"  .AND. cRegime <> "2"
	PCGrvReg (cAlias,Iif(lProcMThr,cRelacMax,NIL), aReg0111,,,,,,nTamTRBIt)
EndIF

//Gravao do BLOCO na tabela tempor¡ria I
IF Len(aRegI100) > 0
	SPEDRegs(cAlias,{aRegI010,aRegI100,aRegI199,{aREgI200,2},aRegI299,{aRegI300,4},aRegI399})
EndIF

If Interrupcao(lEnd)
	// Verifica se o processamento sera em multithread
	If lProcMThr
		GeraTrb(2, @aArq, @cAlias,.T.,nHandleTRB,nMvQtdThr,cSemaphore )
	Else
		GeraTrb(2, @aArq, @cAlias)
	EndIf

 	lCancel := lEnd
    Return
EndIf

//Tratamento para atender atualizao do EFD-Contribuiµes verso 1.13 onde informa que caso no haja informaµes para a gerao deste registro o mesmo deve ser gerado vazio.
If Len(aReg1900) == 0 .And. cRegime == '2' .AND. cIndLucPre <> "9"
	aAdd(aReg1900, {})
		nPos := Len(aReg1900)
		aAdd (aReg1900[nPos], "1900")						//01-Registro
		aAdd (aReg1900[nPos], SM0->M0_CGC)	 	  			//02-CNPJ
		aAdd (aReg1900[nPos], "99")   						//03-COD_MOD
		aAdd (aReg1900[nPos], "")							//04-SER
		aAdd (aReg1900[nPos], 0)  	 						//05-SUB_SER
		aAdd (aReg1900[nPos], "99")		   					//06-COD_SIT
		aAdd (aReg1900[nPos], "0,00") 				    	//07-VL_TOT_REC
		aAdd (aReg1900[nPos], 0)   							//08-QUANT_DOC
		aAdd (aReg1900[nPos], "")    						//09-CST_PIS
		aAdd (aReg1900[nPos], "")	   						//10-CST_COFINS
		aAdd (aReg1900[nPos], "")  	   						//11-CFOP
		aAdd (aReg1900[nPos], "")	 						//12-INF_COMPL
		aAdd (aReg1900[nPos], "")  							//13-COD_CTA
EndIf

//Tratamento para gravao do bloco M.
If lGrBlocoM //MV_GRBLOCM        Quando gerar exclusivamente o bloco P, lGrBlocoM vai ser .F.
	IncProc("Processando Bloco M ")

	cPer := SubStr(aWizard[1][2],5,2) + SubStr(aWizard[1][2],1,4)
	IniRetAnt(aWizard[1][2]) //Zera os valores de creditos do per­odo para fazer a correta gracao
	IniDeddAnt(aWizard[1][2])
	IniCredAnt(aWizard[1][2]) //Zera os valores de creditos do per­odo para fazer a correta gracao

	//Ajusta a contribuio acrescentando os valores de ajustes com origem de Receita Indicada.
	AjustAcres(aAjusteA,@aRegM210,@aRegM220,@aRegM610,@aRegM620,dDataAte)

	//Ajusta a contribuio reduzindo os valores de ajustes com origem de Receita Indicada.
	AjustReduc(aAjusteR,@aRegM210,@aRegM220,@aRegM610,@aRegM620,dDataAte)

	IF !lRgCaxCons
		//Notas Canceladas de Per­odos anteriores. 

		If Len(aRegM210) > 0 .Or. Len(aRegM610) > 0
			GX20Canc(@aRegM210,@aRegM220,@aRegM610,@aRegM620,cRegime,dDataDe)
		EndIf

		//Ajustes retornados pelo Financeiro dos registros F100 de periodos anteriores
		If FindFunction("FinSpdM220")
			RedFinMX20(@aRegM210,@aRegM220,@aRegM610,@aRegM620,dDataDe,dDataAte,lCumulativ)
		EndIF

		//indica se ir¡ processar valores de ajustes sobre receita indicada.
	    If lRecIndi
			//Ir¡ buscar valores de ajustes, diferimento e diferimento de per­odos anteriores que tem origem de Receita Indicada, tabela CF7.
			AjusConDif(cPer,aAjusteA,aAjusteR,aDifer,aDiferAnt,dDataAte,cFilDe,cFilAte,cEmpAnt,aWizard,aLisFil)
		Endif

	    //Receita Indicada ou Diferimento Orgao Publico
		//If lRecIndi .Or. lOrgPub

			//Processa valores de diferimento de per­odos anteriores, com origem de receita indicada.
			AjDiferAnt(aDiferAnt,@aRegM210,@aRegM300,@aRegM610,@aRegM700,dDataAte,@aAjusteR)

			//Processa valores de diferimento do per­odo atual, com origem de receita indicada.
			 AjustDifer(aDifer,@aRegM210,@aRegM230,@aRegM610,@aRegM630,dDataAte)


		//EndIf

		If aExstBlck[12]
			aSPDDif := ExecBlock("SPDPCD", .F., .F., { dDataDe, dDataAte } )

			If Len(aSPDDif) > 0 .And. Len(aSPDDif[1])>0

				For nX:=1 to Len(aSPDDif[1])

					//Pesquisa no registro M210
					If aSPDDif[1][nX][2]// Se PIS por Pauta
						nPosM210 := aScan (aRegM210, {|aX| aX[2]==aSPDDif[1][nX][1] .AND.  cvaltochar(aX[7])==cvaltochar(aSPDDif[1][nX][3]) })
					Else
						nPosM210 := aScan (aRegM210, {|aX| aX[2]==aSPDDif[1][nX][1] .AND.  cvaltochar(aX[5])==cvaltochar(aSPDDif[1][nX][3]) })
					EndIF

					If nPosM210>0
						//Alterar o M210 informando o diferimento
						aRegM210[nPosM210][11] += aSPDDif[1][nX][7]
						aRegM210[nPosM210][13] -= aSPDDif[1][nX][7]


						nPosM230 :=  aScan (aRegM230, {|aX| aX[1]== nPosM210 .AND. aX[3]== aSPDDif[1][nX][4] })
						If nPosM230 == 0
							aAdd(aRegM230, {})
							nPos := Len(aRegM230)
							aAdd (aRegM230[nPos], nPosM210)
							aAdd (aRegM230[nPos], "M230")			   	   	 			//01 - REG
							aAdd (aRegM230[nPos],aSPDDif[1][nX][4])						//02 - CNPJ
							aAdd (aRegM230[nPos],aSPDDif[1][nX][5])						//03 - VL_VENDA
							aAdd (aRegM230[nPos],aSPDDif[1][nX][6])				    	//04 - VL_NAO_RECEB
							aAdd (aRegM230[nPos],aSPDDif[1][nX][7])				    	//05 - VL_CONT_DIF
							aAdd (aRegM230[nPos], "")				           	   		//06 - VL_CRED_DIF
							aAdd (aRegM230[nPos], "")				    	   	  		//07 - COD_CRED
						Else
							aRegM230[nPosM230][4] += aSPDDif[1][nX][5]					//03 - VL_VENDA
							aRegM230[nPosM230][5] += aSPDDif[1][nX][6]				    //04 - VL_NAO_RECEB
							aRegM230[nPosM230][6] += aSPDDif[1][nX][7]				    //05 - VL_CONT_DIF
						EndIf
					EndIf

				Next nX

			EndIf

			If Len(aSPDDif) > 1 .And. Len(aSPDDif[2])>0

				For nX:=1 to Len(aSPDDif[2])

					//Pesquisa no registro M210
					If aSPDDif[2][nX][2]// Se PIS por Pauta
						nPosM610 := aScan (aRegM610, {|aX| aX[2]==aSPDDif[2][nX][1] .AND.  cvaltochar(aX[7])==cvaltochar(aSPDDif[2][nX][3]) })
					Else
						nPosM610 := aScan (aRegM610, {|aX| aX[2]==aSPDDif[2][nX][1] .AND.  cvaltochar(aX[5])==cvaltochar(aSPDDif[2][nX][3]) })
					EndIF

					If nPosM610>0
						//Alterar o M210 informando o diferimento
						aRegM610[nPosM610][11] += aSPDDif[2][nX][7]
						aRegM610[nPosM610][13] -= aSPDDif[2][nX][7]


						nPosM630 :=  aScan (aRegM630, {|aX| aX[1]== nPosM610 .AND. aX[3]== aSPDDif[2][nX][4] })
						If nPosM630 == 0
							aAdd(aRegM630, {})
							nPos := Len(aRegM630)
							aAdd (aRegM630[nPos], nPosM610)
							aAdd (aRegM630[nPos], "M630")			   	   	 			//01 - REG
							aAdd (aRegM630[nPos],aSPDDif[2][nX][4])						//02 - CNPJ
							aAdd (aRegM630[nPos],aSPDDif[2][nX][5])						//03 - VL_VENDA
							aAdd (aRegM630[nPos],aSPDDif[2][nX][6])				    	//04 - VL_NAO_RECEB
							aAdd (aRegM630[nPos],aSPDDif[2][nX][7])				    	//05 - VL_CONT_DIF
							aAdd (aRegM630[nPos], "")				           	   		//06 - VL_CRED_DIF
							aAdd (aRegM630[nPos], "")				    	   	  		//07 - COD_CRED
						Else
							aRegM630[nPosM630][4] += aSPDDif[2][nX][5]					//03 - VL_VENDA
							aRegM630[nPosM630][5] += aSPDDif[2][nX][6]				    //04 - VL_NAO_RECEB
							aRegM630[nPosM630][6] += aSPDDif[2][nX][7]				    //05 - VL_CONT_DIF
						EndIf
					EndIf

				Next nX
	        EndIf
		EndIf
	EndIF

	//Total da contriulai de PIS no cumulativo
	nTotContrb := TotContrib(aRegM210, cIndNatJur,@aRegM211,cIndTipCoo,cPer)
	IncProc("Bloco M: Cr©dito PIS ")
	If cRegime <> "2" // Se for diferente de exclusivamente cumulativo
		//Busca os valores de cr©ditos anteriores de PIS
		PCCredAnt(aWizard[1][2],@aReg1100,@aReg1500,@nTotContrb,"PIS")
		//GERACAO DE CREDITO EXTEMPORANEO PARA PIS.
		If aIndics[18] .And. lGeraCrdExt
			Reg1101(@aReg1100,@aReg1101,@aReg1102,@nTotContrb,aWizard[1][2],.F.,cAlias,aReg0140Ex)
		EndIf
		DescPisAnt(aReg1100,@aRegM200)
		//Processa registro M105, M110 e M115
		RegM105(cAlias,		@aRegM100,	@aRegM105,	@aRegAuxM105,	@aRegM200,;
				aReg0111,	cIndApro,	@aReg1100,	SubStr(aWizard[1][2],5,2)+SubStr(aWizard[1][2],1,4),	nTotContrb,;
				@aRegM110,	@aCredPresu,@aAjuCred,	aVlCrdImob,		aAjCredSCP, {}, aCFA, @aRegM115)

		//GRAVACAO - REGISTRO M100 e M105.
		GrRegDep(cAlias, aRegM100, aRegM105)

		//GRAVACAO - REGISTRO M110 e M115
		GrRegDep(cAlias, aRegM100, aRegM110,.T.,,,,)
		GrRegDep(cAlias, aRegM110, aRegM115,.T.,,,,)
	EndIF


	//GRAVACAO - REGISTRO M400 E M410.

	GrRegDep (cAlias, aRegM400, aRegM410)

	//Total da CONTRIBUI‡ƒO de cofins no cumulativo
	nTotContrb := TotCntCOF(aRegM610, cIndNatJur,@aRegM611,cIndTipCoo,cPer)
	IncProc("Bloco M: Cr©dito COFINS ")
	If cRegime <> "2" // Se for diferente de exclusivamente cumulativo
		//Busca valores de cr©dito de COFINS do per­odo anterior.
//		CredAntCof(aWizard[1][2],@aReg1500,@nTotContrb, .F.)
		PCCredAnt(aWizard[1][2],@aReg1100,@aReg1500,@nTotContrb,"COF")
		//GERACAO DE CREDITO EXTEMPORANEO PARA COFINS.
		If aIndics[18] .And. lGeraCrdExt
			Reg1501(@aReg1500,@aReg1501,@aReg1502,@nTotContrb,aWizard[1][2],.F.,cAlias,aReg0140Ex)
		EndIf
		DescCofAnt(aReg1500,@aRegM600)
		//Processa registro M505, M510 e M515
		RegM505(cAlias,		@aRegM500,	@aRegM505,	@aRegAuxM505,	@aRegM600,;
				aReg0111,	cIndApro,	@aReg1500,	SubStr(aWizard[1][2],5,2)+SubStr(aWizard[1][2],1,4),	nTotContrb,;
				@aRegM510,	@aCredPresu,@aAjuCred,	aVlCrdImob,		aAjCredSCP, {}, aCFA, @aRegM515)


		//GRAVACAO - REGISTRO M500 e M505.
		GrRegDep (cAlias, aRegM500,aRegM505)

		//GRAVACAO - REGISTRO M510 e M515.
		GrRegDep (cAlias, aRegM500,aRegM510,.T.,,,,)
		GrRegDep (cAlias, aRegM510,aRegM515,.T.,,,,)

	EndIF


	//GRAVACAO - REGISTRO M800 E M810.

	GrRegDep (cAlias, aRegM800, aRegM810)
	IncProc("Bloco M: Contribuio PIS")

	//GRAVACAO - REGISTRO M200.
	RegM200(cAlias,aRegM200,aRegM210,aReg1300,aRegM220,cRegime,aRegM230,AF600Tmp,aReg1300, cPer,aWizard[1][2], @aRegM211, cIndNatJur,cIndTipCoo,nCrPrAlPIS,lProcAntP,aRegM205)
	IncProc("Bloco M: Contribuio COFINS")

	//GRAVACAO - REGISTRO M600.
	RegM600(cAlias,aRegM600,aRegM610,aReg1700,aRegM620,cRegime,aRegM630,AF600Tmp,aReg1700, cPer, aWizard[1][2],@aRegM611, cIndNatJur,cIndTipCoo,nCrPrAlCOF,lProcAntC,aRegM605)

	If lBlocACDF
		CredAntPis(aWizard[1][2],@aReg1100,nTotContrb, .T.)

		CredAntCof(aWizard[1][2],@aReg1500,nTotContrb, .T.)
	EndIF

	dUltDia := LastDay (DDATAATE) + 1

	For nCont	:= 1 to Len(aDedAPisNC)
		If aDedAPisNC[nCont][2] > 0
			SaldoDed(SToD(aDedAPisNC[nCont][1]), cvaltochar(strzero(month(dUltDia ),2)) + cvaltochar(year(dUltDia )), "0", aDedAPisNC[nCont][2], 0,"D") // Guarda o saldo de deduµes para prximos per­odos.
		EndIF
	Next nCont


	For nCont	:= 1 to Len(aDedAPisC)
		If aDedAPisC[nCont][2] > 0
			SaldoDed(SToD(aDedAPisC[nCont][1]), cvaltochar(strzero(month(dUltDia ) ,2)) + cvaltochar(year(dUltDia )), "1", aDedAPisC[nCont][2], 0,"D") // Guarda o saldo de deduµes para prximos per­odos.
		EndIF
	Next nCont

	For nCont	:= 1 to Len(aDedACofNC)
		If aDedACofNC[nCont][2] > 0
			SaldoDed(SToD(aDedACofNC[nCont][1]), cvaltochar(strzero(month(dUltDia ) ,2)) + cvaltochar(year(dUltDia )), "0",0 , aDedACofNC[nCont][2],"D") // Guarda o saldo de deduµes para prximos per­odos.
		EndIF
	Next nCont


	For nCont	:= 1 to Len(aDedACofC)
		If aDedACofC[nCont][2] > 0
			SaldoDed(SToD(aDedACofC[nCont][1]), cvaltochar(strzero(month(dUltDia ),2)) + cvaltochar(year(dUltDia )), "1",0 , aDedACofC[nCont][2],"D") // Guarda o saldo de deduµes para prximos per­odos.
		EndIF
	Next nCont

	For nCont	:= 1 to Len(aAjustMX10)
		If aAjustMX10[nCont][2] > 0
			SaldoDed(aAjustMX10[nCont][1], cvaltochar(strzero(month(dUltDia ),2)) + cvaltochar(year(dUltDia )), "0",aAjustMX10[nCont][2] , aAjustMX10[nCont][3],aAjustMX10[nCont][6],aAjustMX10[nCont][5],aAjustMX10[nCont][4]) // Guarda valores de reduo de cr©dito de PIS e COFINS para prximos per­odos
		EndIF
	Next nCont

	//Guarda valores de devoluµes caso ficar valor credor
	If aIndics[15]
		If aFieldPos[32]  .AND. aFieldPos[33] .AND. cRegime <> "1"
			For nCont	:= 1 to Len(aDevAntPer)
				If aDevAntPer[nCont][3] > 0 .OR. aDevAntPer[nCont][4] > 0
					SaldoDed(aDevAntPer[nCont][2], cvaltochar(strzero(month(dUltDia ),2)) + cvaltochar(year(dUltDia )) ,"1",aDevAntPer[nCont][3],aDevAntPer[nCont][4],"E",aDevAntPer[nCont][5],aDevAntPer[nCont][1]  ) // Guarda o saldo de devoluµes para prximos per­odos.
				EndIF
			Next nCont
		EndIF
	EndIf

EndIF
If Interrupcao(lEnd)
	// Verifica se o processamento sera em multithread
	If lProcMThr
		GeraTrb(2, @aArq, @cAlias,.T.,nHandleTRB,nMvQtdThr,cSemaphore )
	Else
		GeraTrb(2, @aArq, @cAlias)
	EndIf

 	lCancel := lEnd
    Return
EndIf
IncProc("Finalizando Processamento do Bloco M")

If cBlocoP $ "1/3"

	aAreaSM0 := SM0->(GetArea())
	//Chama ponto de entrada para gerar registro P210
	If aExstBlck[23]
		aRegPE210 := ExecBlock("SPEDCP210", .F., .F.,{ dDataDe, dDataAte, aSm0 , cPCodServ, cPCodDem }  )
	EndIF
	RestArea (aAreaSM0)
	RegP210 (@aRegP210,@aRegP200, aRegPE210)

	//GRAVACAO - REGISTRO P200.
	//	PCGrvReg (cAlias,, aRegP200,,,,,,nTamTRBIt)
	GrRegDep (cAlias, aRegP200,aRegP210,.F.,,,,nPaiP)	

EndIf
If cBlocoP <> "3" // se cBlocop for 3, deve gerar exclusivamente informaµes do blocoP
	//GRAVACAO - REGISTRO 0500.
   	PCGrvReg (cAlias,nPaiF, aReg0500,,,nPaiF,,,nTamTRBIt)
 	//GRAVACAO - REGISTRO 0600.
	PCGrvReg (cAlias,nPaiF, aReg0600,,,nPaiF,,,nTamTRBIt)
	//GRAVACAO - REGISTRO M300.
	PCGrvReg (cAlias,Iif(lProcMThr,cRelacMax,NIL), aRegM300,,,,,,nTamTRBIt)
	//GRAVACAO - REGISTRO M700.
	PCGrvReg (cAlias,Iif(lProcMThr,cRelacMax,NIL), aRegM700,,,,,,nTamTRBIt)
	//GRAVACAO - REGISTRO 1100.
	SPEDRegs(cAlias,{aReg1100,aReg1101,aReg1102},,.T.)
	//GRAVACAO - REGISTRO 1500.
	SPEDRegs(cAlias,{aReg1500,aReg1501,aReg1502},,.T.)
	//GRAVACAO - REGISTRO 1300.
	PCGrvReg (cAlias,Iif(lProcMThr,cRelacMax,NIL), aReg1300,,,,,,nTamTRBIt)
	//GRAVACAO - REGISTRO 1700.
	PCGrvReg (cAlias,Iif(lProcMThr,cRelacMax,NIL), aReg1700,,,,,,nTamTRBIt)
	//GRAVACAO - REGISTRO 1800.
	PCGrvReg (cAlias,Iif(lProcMThr,cRelacMax,NIL), aReg1800,,,,,,nTamTRBIt)
	//GRAVACAO - REGISTRO 1010.
	PCGrvReg (cAlias,Iif(lProcMThr,cRelacMax,NIL), aReg1010,,,,,,nTamTRBIt)
	//GRAVACAO - REGISTRO 1020.
	PCGrvReg (cAlias,Iif(lProcMThr,cRelacMax,NIL), aReg1020,,,,,,nTamTRBIt)
	//GRAVACAO - REGISTRO 1900.
	PCGrvReg (cAlias,Iif(lProcMThr,cRelacMax,NIL), aReg1900,,,,,,nTamTRBIt)
	//GRAVACAO - REGISTRO M350.
	PCGrvReg (cAlias,Iif(lProcMThr,cRelacMax,NIL), aRegM350,,,,,,nTamTRBIt)

EndIf

If cBlocop == "3"
	aRegM200[1][2]	:= 0
	aRegM600[1][2]	:= 0
	PCGrvReg (cAlias,Iif(lProcMThr,cRelacMax,NIL) , aRegM200,,,,,,nTamTRBIt)
	PCGrvReg (cAlias,Iif(lProcMThr,cRelacMax,NIL) , aRegM600,,,,,,nTamTRBIt)
EndIf

//Gravacao dos indicadores de movimento dos registros 
GrvIndMov (cAlias,lBlocACDF,lProcMThr)
If lProcMThr // MT
	n_SPCRecno := NIL
	TcSQLExec( 'COMMIT' ) // Garanto ultimo COMMIT
	n_COMMIT := 0
EndIf

If Interrupcao(lEnd)
	// Verifica se o processamento sera em multithread
	If lProcMThr
		GeraTrb(2, @aArq, @cAlias,.T.,nHandleTRB,nMvQtdThr,cSemaphore )
	Else
		GeraTrb(2, @aArq, @cAlias)
	EndIf

 	lCancel := lEnd
    Return
EndIf

//Gero meio-magnetico
OrgTxt (cAlias, cFileDest)

//Fecho TRB criado
// Verifica se o processamento sera em multithread
If lProcMThr
	GeraTrb(2, @aArq, @cAlias,.T.,nHandleTRB,nMvQtdThr,cSemaphore )
Else
	GeraTrb(2, @aArq, @cAlias)
EndIf

lGerou := .T.
Return

/*±±ºPrograma  Reg0000   ºAutor  Erick G. Dias       º Data   06/01/11 º±±
±±ºDesc.      Abertura do arquivo/Identificacao da pessoa juridica        º±±
±±ºParametros: aWizard: Array com infrmacoes digitadas pelo usuario       º±±
±±º          : cAlias: Alias para gravacao do arquivo temporario          º±±
±±º          : dDatade: Data inicial do periodo                           º±±
±±º          : cdDataAte: Data final do periodo                           º±±*/
Static Function Reg0000 (aWizard, cAlias, dDataDe, dDataAte)
Local	aReg	:= {}
Local	nPos	:=	0

If dDataDe >= CTOD("01/07/2012")
	cVersao:= "003"
Else
	cVersao:= "002"
Endif
aAdd(aReg, {})
nPos	:=	Len (aReg)
aAdd (aReg[nPos], "0000")													//01 - REG
aAdd (aReg[nPos], cVersao)													//02 - COD_VER
aAdd (aReg[nPos], SubStr (aWizard[2][1], 1, 1))				    		//03 - TIPO_ESCRIT
aAdd (aReg[nPos], SubStr (aWizard[2][2], 1, 1))							//04 - IND_SIT_ESP
aAdd (aReg[nPos], aWizard[2][5])										   	//05 - NUM_REC_ANTERIOR
aAdd (aReg[nPos], dDataDe)										 			//06 - DT_INI
aAdd (aReg[nPos], dDataAte)													//07 - DT_FIM
aAdd (aReg[nPos], SM0->M0_NOMECOM)	                                        //08 - NOME
aAdd (aReg[nPos], SPEDConvType(VldIE(Iif (RetPessoa(SM0->M0_CGC) == "J", SM0->M0_CGC, ""))))	//09 - CNPJ
aAdd (aReg[nPos], SM0->M0_ESTENT)						   					//10 - UF
aAdd (aReg[nPos], Iif (Upper(SM0->M0_ESTENT) == "EX","",Iif(Len(Alltrim(SM0->M0_CODMUN))<=5,UfCodIBGE(SM0->M0_ESTENT),"")+SM0->M0_CODMUN))	//10 - COD_MUN
aAdd (aReg[nPos], SPEDConvType(SM0->M0_INS_SUF))								//12 - SUFRAMA
aAdd (aReg[nPos],  SubStr (aWizard[2][3], 1, 2))							//13 - IND_NAT_PJ
aAdd (aReg[nPos],  SubStr (aWizard[2][4], 1, 1))							//14 - IND_ATIV
PCGrvReg (cAlias,, aReg,,,,,,nTamTRBIt)
Return

/*ºPrograma  Reg0035   ºAutor  Simone Oliveira     º Data   12/03/14   º±±
±±ºDesc.      Identificao de Sociedade em Conta de Participao - SCP  º±±
±±ºParametros: cAlias: Alias para gravacao do arquivo temporario          º*/
Static Function Reg0035 (cAlias)
Local	aReg		:=	{}
Local	nPos		:=	0

aAdd (aReg, {})
nPos	:=	Len (aReg)
aAdd (aReg[nPos], "0035")							//01 - REG
aAdd (aReg[nPos], SM0->M0_CGC)		   				//02 - COD_SCP
aAdd (aReg[nPos], SM0->M0_NOME) 					//03 - DESC_SCP
aAdd (aReg[nPos], "")	   							//04 - INF_COMP

PCGrvReg (cAlias,, aReg,,,,,,nTamTRBIt)

Return

/*±±ºPrograma  Reg0100   ºAutor  Erick G. Dias       º Data   06/01/11   º±±
±±ºDesc.      Dados do Contabilista                                      º±±
±±ºParametros: aWizard - Array com infrmacoes digitadas pelo usuario      º±±
±±º          : cAlias - alias para gracavao do arquivo temporario         º±±*/
Static Function Reg0100 (aWizard, cAlias)
Local	aReg		:=	{}
Local	lRet		:=	.T.
Local	nPos		:=	0
Local 	cCNPJ		:= ""
Local 	lInclui		:= .F.

If (!Empty(aWizard[3][1]) .And. !Empty(aWizard[3][7])) .Or. !(aIndics[24])
	aAdd (aReg, {})
	nPos	:=	Len (aReg)
	aAdd (aReg[nPos], "0100")					//01 - REG
	aAdd (aReg[nPos], aWizard[3][1])			//02 - NOME
	aAdd (aReg[nPos], aWizard[3][3])			//03 - CPF
	aAdd (aReg[nPos], aWizard[3][4])			//04 - CRC
	aAdd (aReg[nPos], aWizard[3][2])			//05 - CNPJ
	aAdd (aReg[nPos], aWizard[3][5])			//06 - CEP
	aAdd (aReg[nPos], aWizard[3][7])			//07 - END
	aAdd (aReg[nPos], aWizard[3][8])			//08 - NUM
	aAdd (aReg[nPos], aWizard[3][9])			//09 - COMPL
	aAdd (aReg[nPos], aWizard[3][10])			//10 - BAIRRO
	aAdd (aReg[nPos], aWizard[3][11])			//11 - FONE
	aAdd (aReg[nPos], aWizard[3][12])			//12 - FAX
	aAdd (aReg[nPos], aWizard[3][13])			//13 - EMAIL
	aAdd (aReg[nPos], aWizard[3][6])			//14 - COD_MUN
Else
	lInclui := .F.
	If !Empty(aWizard[3][3]) .And. aFieldPos[34]
		// se o CPF estiver informado, mas sem o nome e endereco, pesquiso na tabela CVB - contabilista pelo num. documento.
		DbSelectArea ("CVB") //Tabela Contabilista
		CVB->(DbSetOrder(3)) //Indice por CPF
		If CVB->(MsSeek(xFilial("CVB")+aWizard[3][3]))
			lInclui := .T.
		Endif
	ElseIf !Empty(aWizard[3][2]) .Or. (!Empty(aWizard[3][3]) .And. !aFieldPos[34])
		// se o CNPJ estiver informado, mas sem o nome e endereco, pesquiso na tabela CVB - contabilista pelo num. documento.
		DbSelectArea ("CVB") //Tabela Contabilista
		CVB->(DbSetOrder(2)) //Indice por CGC
		cCNPJ := Iif(!Empty(aWizard[3][2]), aWizard[3][2], aWizard[3][3])
		cCNPJ := Padr(SubStr(cCNPJ,1,TamSx3("A2_CGC")[1]),TamSx3("A2_CGC")[1])
		If CVB->(MsSeek(xFilial("CVB")+cCNPJ))
			lInclui := .T.
		Endif
	Else
		// senao pego o primeiro contabilista informado para a filial corrente.
		DbSelectArea ("CVB") //Tabela Contabilista
		CVB->(DbSetOrder(1)) //Indice por Codigo
		If CVB->(MsSeek(xFilial("CVB")))
			lInclui := .T.
		Endif
	Endif

	If lInclui
		aAdd (aReg, {})
		nPos	:=	Len (aReg)
		aAdd (aReg[nPos], "0100")				   																				//01 - REG
		aAdd (aReg[nPos], CVB->CVB_NOME )																						//02 - NOME
		aAdd (aReg[nPos], Iif(aFieldPos[34],Alltrim(CVB->CVB_CPF),Iif(Len(Alltrim(CVB->CVB_CGC))<14,Alltrim(CVB->CVB_CGC),"")))	//03 - CPF
		aAdd (aReg[nPos], SPEDConvType(CVB->CVB_CRC))																				//04 - CRC
		aAdd (aReg[nPos], SPEDConvType(Iif(Len(Alltrim(CVB->CVB_CGC))>11,Alltrim(CVB->CVB_CGC),"")))								//05 - CNPJ
		aAdd (aReg[nPos], SPEDConvType(CVB->CVB_CEP)) 											   									//06 - CEP
		aAdd (aReg[nPos], SPEDConvType(FisGetEnd(CVB->CVB_END,CVB->CVB_UF)[1]))						 							//07 - END
		aAdd (aReg[nPos], Iif(!Empty(FisGetEnd(CVB->CVB_END,CVB->CVB_UF)[2]),FisGetEnd(CVB->CVB_END,CVB->CVB_UF)[3],"SN"))	//08 - NUM
		aAdd (aReg[nPos], SPEDConvType(CVB->CVB_COMPL))											   								//09 - COMPL
		aAdd (aReg[nPos], SPEDConvType(CVB->CVB_BAIRRO))																			//10 - BAIRRO
		aAdd (aReg[nPos], SPEDConvType(CVB->CVB_TEL))																				//11 - FONE
		aAdd (aReg[nPos], SPEDConvType(CVB->CVB_FAX))																				//12 - FAX
		aAdd (aReg[nPos], CVB->CVB_EMAIL)																						//13 - EMAIL
		aAdd (aReg[nPos], "")																					   				//14 - COD_MUN
		If aFieldPos[35]
			aReg[nPos][14] := IIF( Len(Alltrim(CVB->CVB_CODMUN)) <= 5 , UfCodIBGE(CVB->CVB_UF) + Alltrim(CVB->CVB_CODMUN) , Alltrim(CVB->CVB_CODMUN) )
		EndIf

	Endif

Endif
PCGrvReg (cAlias,, aReg,,,,,,nTamTRBIt)
Return (lRet)

/*Programa  Reg0110   ºAutor  Erick G. Dias       º Data   06/01/11   º±±
±±ºDesc.      Regimes de apurao                                        º±±
±±ºParametros: aWizard - Array com infrmacoes digitadas pelo usuario      º±±
±±º          : cAlias - alias para gracavao do arquivo temporario         º±±*/
Static Function Reg0110 (aWizard, cAlias)
Local	aReg		:=	{}
Local	nPos		:=	0
Local   lApropDir	:= aParSX6[14]
Local   cIndAprop	:= ""

If (!Empty(aWizard[4][1]) .And. !Empty(aWizard[4][2]))

	IF SubStr(aWizard[4][1],1,1) <> "2"
		cIndAprop	:=Iif(lApropDir,"1", "2")
	EndIF
	aAdd (aReg, {})
	nPos	:=	Len (aReg)
	aAdd (aReg[nPos], "0110")								//01 - REG
	aAdd (aReg[nPos], SubStr(aWizard[4][1],1,1))			//02 - COD_INC_TRIB
	aAdd (aReg[nPos], cIndAprop)							//03 - IND_APRO_CRED
	aAdd (aReg[nPos], SubStr(aWizard[4][2],1,1))			//04 - COD_TIPO_CONT

	If !Empty(Alltrim( SubStr(aWizard[4][7],1,2))) // Bloco I
		aAdd (aReg[nPos], "")			//05 - IND_REG_CUM
	ElseIf dDataDe >= CTOD("01/07/2012")
		If SubStr(aWizard[4][1],1,1) == "2"
			//PRORROGADO PARA JANEIRO/2013 - REGIME DE CAIXA/COMPETENCIA
			aAdd (aReg[nPos], SubStr(aWizard[4][5],1,1))			//05 - IND_REG_CUM
		Else
			aAdd (aReg[nPos], "")			//05 - IND_REG_CUM
		EndIF
	EndIF
	PCGrvReg (cAlias,, aReg,,,,,,nTamTRBIt)
EndIF
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} Reg0120
Identificao de Periodos dispensados da EFD- Contribuiµes

@param cAlias - Alias para gravacao do arquivo temporario
		aWizard - Array com infrmacoes digitadas pelo usuario

@author  Simone dos Santos de Oliveira
@since   05.05.2014
@version 11.80
/*/
//-------------------------------------------------------------------
Static Function Reg0120 (aWizard,cAlias)
Local	aReg0120	:=	{}
Local	nPos		:=	0
Local 	cMesEFD	:= SubStr(aWizard[1][1],5,2)
Local  cAnoEFD		:= SubStr(aWizard[1][1],1,4)
Local 	cPerDisp	:= ""

If aIndics[32] .And. CKN->(DbSeek(xFilial('CKN')+cMesEFD+cAnoEFD))
	Do While (!CKN->(Eof ()) .And. (CKN->CKN_MESEFD == cMesEFD .And. CKN->CKN_ANOEFD == cAnoEFD))

		cPerDisp:= CKN->CKN_MESDIS+CKN->CKN_ANODIS

		aAdd (aReg0120, {})
		nPos	:=	Len (aReg0120)
		aAdd (aReg0120[nPos], "0120")					//01 - REG
		aAdd (aReg0120[nPos], cPerDisp)		   			//02 - MES_DISPENSA
		aAdd (aReg0120[nPos], CKN->CKN_INFCOM)	   		//03 - INF_COMP

		CKN->(dbSkip())
	EndDo
	PCGrvReg (cAlias,, aReg0120,,,,,,nTamTRBIt)
EndIf
Return

/* Programa  Reg0140   ºAutor  Erick G. Dias       º Data   07/01/11   º±±
±±ºDesc.      Cadastro de estabelecimento                                º±±
±±ºParametros: aReg0140 - Array com infrmacoes do cadastro do estabelecim.º*/
Static Function Reg0140 (aReg0140)
Local  nPos := 0
local  cPto  := "."
Local  cTco  := "-"
Local  cINSC := SM0->M0_INSC
Local  nPos1 := AT(cPto,cINSC)
Local  nPos2 := AT(cTco,cINSC)
If aScan (aReg0140, {|aX| AllTrim(aX[4])==AllTrim(SM0->M0_CGC)}) == 0
	aAdd(aReg0140, {})
	nPos	:=	Len (aReg0140)
	aAdd (aReg0140[nPos], "0140") 				    										//01-REG
	aAdd (aReg0140[nPos], Alltrim(SM0->M0_CODFIL))    										//02-COD_EST
	If aExstBlck[20] //SPDPC0140 - Ponto de entrada refernete a razao social da filial
		aAdd (aReg0140[nPos], ExecBlock("SPDPC0140", .F., .F., {"SM0"}))			//03-NOME
   Else
		aAdd (aReg0140[nPos], SM0->M0_NOMECOM)  		   								//03-NOME
	Endif
	aAdd (aReg0140[nPos], SM0->M0_CGC)  													//04-CNPJ
	aAdd (aReg0140[nPos], SM0->M0_ESTENT)  													//05-UF
	While (nPos1 >0 .Or. nPos2 >0)
		nPos1 := AT(cPto,cINSC)
		Iif(!(nPos1 := AT(cPto,cINSC))>0,cINSC,cINSC := Stuff(cINSC,nPos1,1,""))
		nPos2 := AT(cTco,cINSC)
		Iif(!(nPos2 := AT(cTco,cINSC))>0,cINSC,cINSC := Stuff(cINSC,nPos2,1,""))
	Enddo
	aAdd (aReg0140[nPos], IIF (Substr(SM0->M0_INSC,1,5) == "ISENT","",cINSC)) 			 	//06-IE
	aAdd (aReg0140[nPos], SM0->M0_CODMUN)  													//07-COD_MUN
	aAdd (aReg0140[nPos], SM0->M0_INSCM)  													//08-IM
	aAdd (aReg0140[nPos], SM0->M0_INS_SUF)  												//09-SUFRAMA
EndIf
Return

/*ºPrograma  Reg0150   ºAutor  Erick G. Dias       º Data   07/01/11   º±±
±±ºDesc.      Cadastro de participante                                   º±±
±±ºParametros aReg0150->array para gravacao do participante              º±±
±±º           aPAr->array com informacaos do cadastro SA1/SA2            º±±
±±º           nRelacFil->Numero de relacao com a filial                  */
Static Function Reg0150 (aReg0150,aPar,nRelacFil)
Local	lRet	:=	.T.
Local	nPos	:=	0
Local	aRegAux	:=	{}

aAdd (aReg0150, {})
nPos	:=	Len (aReg0150)
aAdd (aReg0150[nPos], 1) 			//relao com o pai 0140
aAdd (aReg0150[nPos], "0150") 		//01-REG
aAdd (aReg0150[nPos], aPar[1]) 		//02-COD_PART
aAdd (aReg0150[nPos], aPar[2]) 		//03-NOME
aAdd (aReg0150[nPos], aPar[3]) 		//04-COD_PAIS
aAdd (aReg0150[nPos], aPar[4]) 		//05-CNPJ
aAdd (aReg0150[nPos], aPar[5]) 		//06-CPF
aAdd (aReg0150[nPos], aPar[6]) 		//07-IE
aAdd (aReg0150[nPos], aPar[7]) 		//08-COD_MUN
aAdd (aReg0150[nPos], aPar[8]) 		//09-SUFRAMA
aAdd (aReg0150[nPos], aPar[9]) 		//10-END
aAdd (aReg0150[nPos], aPar[10]) 	//11-NUM
aAdd (aReg0150[nPos], aPar[11]) 	//12-COMPL
aAdd (aReg0150[nPos], aPar[12]) 	//13-BAIRRO

If aExstBlck[ 24 ]
	aRegAux := ExecBlock( "SPED0150" , .F. , .F. , { aReg0150[nPos] } )
	If Len( aRegAux ) == 14
		aReg0150[nPos] := aRegAux
	Endif
Endif

Return (lRet)

/*ºPrograma  Reg0200   ºAutor  Erick G. Dias       º Data   07/01/11   º±±
±±ºDesc.      Identificao do Item(produtos e servios)                 º±±
±±PAr¢metroscAlias	-> Alias da tabela tempor¡ria                     ±±
±±          aReg0200	-> Array com informaµes do registro 0200         ±±
±±          aReg0190	-> Array com informaµes do registro 0200         ±±
±±          dDataDe	-> Data inicial do ´per­odo                       ±±
±±          dDataAte	-> Data final do per­odo                          ±±
±±          aProd	    -> Array com informaµes do produro               ±±
±±          cProd     -> Cdigo do produto                              ±±
±±          nRelacFil	-> Relao com filial processada                  ±±
±±          aReg0205	-> Array com informaµes do registro 0205         ±±
±±          lIss	    -> indica se © servio                            ±±
±±          cAliasSB1	-> Alias do cadastro de produto SB1               ±±
±±          cMvEstado	-> MV_ESTADO                                      ±±
±±          |lCmpsSB5	-> FieldPos SB5               					  ±±
±±          |nPos0200	-> Posicao do array do produto                    */
Static Function Reg0200(cAlias,aReg0200,aReg0190,dDataDe,dDataAte,aProd,cProd, nRelacFil,aReg0205,lIss,cAliasSB1,cMvEstado,lCmpsSB5,nPos0200,cMVDTINCB1)
Local	lRet   		:=	.T.
Local	lHistTab	:=	aParSX6[1] .And. aIndics[01]
Local	nICMPAD 	:= 	GetNewPar("MV_ICMPAD",18)
Local	nTIpo		:=	0
Local	nX			:=	0
Local	nY			:=	0
Local	nAlqProd	:=	0
Local   nPos        :=  0
Local	cTipo		:=	"99"
Local	cCodIss 	:= 	""
Local	aHist		:=	{}
Local	aReg200		:= 	{}
Local	aDesc		:=	{}
Local 	aTipo		:=	{ {"ME","00"},;
						  {"MP","01"},;
						  {"EM","02"},;
						  {"PP","03"},;
						  {"SP","05"},;
						  {"PI","06"},;
						  {"PA","04"},;
						  {"MC","07"},;
						  {"AI","08"},;
						  {"MO","09"},;
						  {"OI","10"} }
Local 	aAuxDesc	:= 	{}
Local 	dDataFinal	:= 	cTOd("  /  /  ")
Local 	dDataInici	:= 	cTOd("  /  /  ")
Local 	cDescProd	:= 	""
Local 	cNcm		:= 	""
Local  	cProdCDN 	:=  ""
Local 	cCmpDTINCB1 :=  ""

DEFAULT cProd 		:= (cAliasSB1)->B1_COD+Iif(lConcFil,xFilial("SB1"),"")
DEFAULT aProd 		:= {"","","","","","","","","","",""}
DEFAULT lIss  		:= .F.
DEFAULT cMvEstado 	:= aParSX6[28]
DEFAULT lCmpsSB5	:= aFieldPos[17] .AND. aFieldPos[18] .AND. aFieldPos[19]
DEFAULT	cMVDTINCB1	:= 	IIF(AllTrim(GetNewPar("MV_DTINCB1","B1_DATREF")) != "", AllTrim(GetNewPar("MV_DTINCB1","B1_DATREF")),"B1_DATREF")

//Ponto de entrada para o usuario relacionar tipos de produto criados com o codigo da tabela de tipos do ATO COTEPE 09/2008 (layout SPED Fiscal)
If aExstBlck[13]
	aTipo := ExecBlock("SPDFIS001", .F., .F., {aTipo})
EndIf

//Obtendo o tipo de item para montar o campo do registro
nTipo := ASCAN(aTipo,{|x| x[1]==(cAliasSB1)->B1_TIPO})
If nTipo > 0
	cTipo := aTipo[nTipo][2]
EndIf

//Obtendo a NCM do produto, verificando se trata-se de um servico atraves codigo de ISS
If !Empty(aProd[7])
	cNcm	:=	aProd[7]
Elseif Empty((cAliasSB1)->B1_CODISS)
	cNcm	:=	(cAliasSB1)->B1_POSIPI
Endif

//REGISTRO 0200 - TABELA DE IDENTIFICACAO DO ITEM 
aAdd(aReg0200, {})
nPos	:=	Len (aReg0200)
aAdd (aReg0200[nPos], 1)													    //Relao com o reg pai 0140.
aAdd (aReg0200[nPos], "0200")													//01 - REG
aAdd (aReg0200[nPos], cProd)     												//02 - COD_ITEM
aAdd (aReg0200[nPos], Iif(!Empty(aProd[2]),aProd[2],(cAliasSB1)->B1_DESC)) 	//03 - DESCR_ITEM
aAdd (aReg0200[nPos], Iif(!Empty(aProd[3]),aProd[3], IIf(type((cAliasSB1)->B1_CODBAR)== "N",(cAliasSB1)->B1_CODBAR,""))) 			//04 - COD_BARRA
aAdd (aReg0200[nPos], Iif(!Empty(aProd[4]),aProd[4]+xFilial("SB1"),(cAliasSB1)->B1_CODANT+Iif(!Empty((cAliasSB1)->B1_CODANT),xFilial("SB1"),"")))			//05 - COD_ANT_IETM
aAdd (aReg0200[nPos], Iif(!Empty(aProd[5]),aProd[5],(cAliasSB1)->B1_UM))		 //06 - UNI_INV
aAdd (aReg0200[nPos], Iif(!Empty(aProd[6]),aProd[6],cTipo))					 //07 - TIPO_ITEM
aAdd (aReg0200[nPos], Iif(Len(AllTrim(cNcm))<8,"",cNcm))						 //08 - COD_NCM
aAdd (aReg0200[nPos], Iif(!Empty(aProd[8]),aProd[8],(cAliasSB1)->B1_EX_NCM))	 //09 - EX_IPI
aAdd (aReg0200[nPos], Iif(!Empty(aProd[9]),aProd[9],Iif(Empty((cAliasSB1)->B1_CODISS),Left((cAliasSB1)->B1_POSIPI,2),"00" )))//10 - COD_GEN

//Obtendo o codigo do ISS atraves do cadastro da tabela CDN. Este codigo deverah estar conforme LC 116/03|
If !Empty(aProd[10])
	cCodIss	:=	aProd[10]
Else
	cCodIss	:=	StrTran(AllTrim((cAliasSB1)->B1_CODISS),".","")
Endif

//Tratamento para considerar tamb©m mais de um Cod LST por Cod ISS, conforme a legislao   
//existe a possibilidade de ser n / n										                       
cProdCDN := Alltrim((cAliasSB1)->B1_COD)
If !Empty(cCodIss) .And. aIndics[11]
	If CDN->(MsSeek(xFilial("CDN")+PadR(cCodIss,8)+cProdCDN))
		cCodIss := StrTran(AllTrim(CDN->CDN_CODLST),".","")
	Elseif CDN->(MsSeek(xFilial("CDN")+PadR(cCodIss,8)))
		cCodIss := StrTran(AllTrim(CDN->CDN_CODLST),".","")
	EndIf
EndIf

If DTOS(dDataDe) >= "20150501"
	//Tiro todos os pontos que estiverem no cadastro.
	cCodIss	:= StrTran(cCodIss,".","")	
	
	IF(LEN(ALLTRIM(cCodIss))<4 .AND. !EMPTY (ALLTRIM(cCodIss)) )
		cCodIss := "0" + cCodIss
	ENDIF
		
	If !Empty(cCodIss)		
		IF ddatade >= ctod('01/01/2015') //a partir de 2015 o formato do cdigo lst dever¡ ser NN.NN
			//Coloco ponto na terceita posio do cdigo de servio
			cCodIss	:= SubStr(cCodIss,1,2) + '.' + SubStr(cCodIss,3,2)
		EndIF
	EndIF
	
	aAdd (aReg0200[nPos], cCodIss)			//11 - COD_LST
Else
	aAdd (aReg0200[nPos], Substr(cCodIss,1,4))			//11 - COD_LST
EndIf	

//Tratamento para obter a aliquota interna do produto
If !Empty(aProd[11])
	nAlqProd	:= aProd[11]
Elseif (cAliasSB1)->B1_PICM > 0
	nAlqProd	:=	(cAliasSB1)->B1_PICM
Elseif !(cTipo$"09")
	If cMvEstado=="RJ" //GetMv("MV_ESTADO")=="RJ"
		nAlqProd:=	nICMPAD+(cAliasSB1)->B1_FECP
	Else
	   	nAlqProd:=	nICMPAD
	EndIf
Endif

aAdd (aReg0200[nPos],  nAlqProd)  		//12 - ALIQ_ICM

//REGISTRO 0190 - UNIDADES DE MEDIDA
If !Empty((cAliasSB1)->B1_UM) .And. SAH->(MsSeek (xFilial ("SAH")+(cAliasSB1)->B1_UM))
	If (aScan (aReg0190, {|aX| aX[3]==(cAliasSB1)->B1_UM}) == 0)
		aAdd(aReg0190, {})
		nPos	:=	Len (aReg0190)
		aAdd (aReg0190[nPos], 1)											    //Relacao com pai 0140
		aAdd (aReg0190[nPos], "0190")											//01 - REG
		aAdd (aReg0190[nPos], (cAliasSB1)->B1_UM)								//02 - UNI
		aAdd (aReg0190[nPos], SAH->AH_DESCPO)									//03 - DESCR
	EndIf
EndIf

//REGISTRO 0208 - CODIGO DE GRUPOS POR MARCA COMERCIAL	
Reg0208((cAliasSB1)->B1_COD,"0200"+ Iif(lProcMThr,cvaltochar(nPos0200),cvaltochar(len(aReg0200))),cAlias,nRelacFil,aReg0200,lCmpsSB5)

If lHistTab .And. dDataDe <> NIL
	aHist := MsConHist("SB1","","",dDataDe,dDataAte,Substr(cProd,1,TamSx3("B1_COD")[1]))

	//Verificando se a funo MsConHist retornou pelo menos um array
	If Len(aHist) > 0
		cCmpDTINCB1 := cAliasSB1 + "->" +cMVDTINCB1 //Campo configurado no parametro MV_DTINCB1
		//Passando para um array auxiliar os arrays que so do campo B1_DESC, para ordenar corretamente por DATA e HORA de alterao
		For nX := 1 To Len(aHist)
			If Alltrim(aHist[nX][1]) $ "B1_DESC"
				aAdd(aAuxDesc,aHist[nX])
			EndIf
		Next nX
		If len(aAuxDesc) >0
			//Ordenando descrescentemente o array aAuxDesc de acordo com DATA e HORA de alterao
			//Foi necess¡rio colocar a condio da hora ser maior ou igual a dez, pois quando concatena os valor maiores que 10 eram ordenados de forma
			//incorreta caso houvesse outra hora com data prxima ou na mesma data.
			aAuxDesc := aSort(aAuxDesc,,,{|x,y| AllTrim(dTOs(x[3]))+IIf(HoraToInt(x[4])>=10,AllTrim(Str(HoraToInt(x[4]))),"0"+AllTrim(Str(HoraToInt(x[4])))) > AllTrim(dTOs(y[3]))+IIf(HoraToInt(y[4])>=10,AllTrim(Str(HoraToInt(y[4]))),"0"+AllTrim(Str(HoraToInt(y[4]))) ) })

			//Atribuindo a variavel cDescProd o valor da 'DESCRIO ANTERIOR DO PRODUTO' da ultima alterao
			cDescProd := aAuxDesc[1][2]

			//Atribuindo a ultima data de alterao a variavel dDataFinal
			dDataFinal := IIf(Day(UltimoDia(aAuxDesc[1][3]))==Day(aAuxDesc[1][3]),aAuxDesc[1][3]-1,aAuxDesc[1][3])
			If Len(aAuxDesc)==1
				//Atribuindo a data da criao do produto a variavel dDataInici por ter efetuado uma alterao do produto
				dbSelectArea("SB1")
				dbSetOrder(1)
				If MsSeek(xFilial("SB1")+Substr(cProd,1,TamSx3("B1_COD")[1]))
					TcSetField(cAliasSB1,cMVDTINCB1,"D",8,0)
					dDataInici := &(cCmpDTINCB1)
					If Empty(dDataInici)
						TcSetField(cAliasSB1,"B1_DATREF","D",8,0)
						dDataInici := (cAliasSB1)->B1_DATREF
					Endif
				EndIf
				If Empty(dDataInici)
					dDataInici := aAuxDesc[1][3]
				Endif
			Else
				dbSelectArea("SB1")
				dbSetOrder(1)
				If MsSeek(xFilial("SB1")+Substr(cProd,1,TamSx3("B1_COD")[1]))
					TcSetField(cAliasSB1,cMVDTINCB1,"D",8,0)
					dDataInici := &(cCmpDTINCB1)
					If Empty(dDataInici)
						TcSetField(cAliasSB1,"B1_DATREF","D",8,0)
						dDataInici := (cAliasSB1)->B1_DATREF
					Endif
				EndIf
				If Empty(dDataInici)
					//Atribuindo a penultima data de alterao a variavel dDataInici independente se houve alteracao ou no no mesmo dia
					dDataInici := aAuxDesc[2][3]
				Endif
			Endif
			
			If Valtype(dDataInici) != Valtype(dDataFinal) .And. !Empty(dDataInici)
				dDataInici := IIF(Valtype(dDataInici) == "C" .And. Valtype(dDataFinal) == "D", cTod(dDataInici)  ,dDataInici )
			EndIf

			//tratamento na geracao do registro 0205 - Alteracao do Item quando um item for alterado na data final do arquivo do Sped Fiscal
	   		If dDataFinal <= dDataAte
				// Nao pode fazer aReg0205 := {} pois o array sempre ficara com apenas   1 elemento (o ultimo adicionado),
				// gerando so uma linha 0205. Neste caso, deve-se adicionar mais um elemento ao array, e as informacoes deste novo registro
				// deverao ser adicionadas neste elemento indexado por "aReg0205[Len(aReg0205)]".
				aAdd(aReg0205, {})
				aAdd(aReg0205[Len(aReg0205)], Iif(lProcMThr,nPos0200,Len(aReg0200)) )	//01 - relacao com registro pai 0200
				aAdd(aReg0205[Len(aReg0205)], "0205")									//01 - REG
				aAdd(aReg0205[Len(aReg0205)], cDescProd)								//02 - DESCR_ANT_ITEM
				aAdd(aReg0205[Len(aReg0205)], dDataInici)								//03 - DT_INI
				aAdd(aReg0205[Len(aReg0205)], dDataFinal)								//04 - DT_FIM
				aAdd(aReg0205[Len(aReg0205)], (cAliasSB1)->B1_CODANT)					//05 - COD_ANT_ITEM - LAYOUT 2010
			EndIf
		EndIf
	EndIf
EndIf
Return (lRet)

/*ºPrograma  Reg0400   ºAutor  Erick G. Dias       º Data   06/01/11   º±±
±±ºDesc.      Natureza da operao                                       º±±
±±ParametroscCodNat -> Codigo da Natureza da Operacao/Prestacao         ±±
±±          aReg0400 -> Array com o conteudo do registro para posteior  ±±
±±           gravacao.                                                  ±±
±±          cDescNat -> Descriacao da Natureza da Operacao/Prestacao    */
Static Function Reg0400(cCodNat,aReg0400,cDescNat)
Local	lRet	:=	.T.
Local	nPos	:=	aScan (aReg0400, {|aX| aX[3]==cCodNat})

If (nPos==0)
	aAdd (aReg0400, {})
	nPos	:=	Len (aReg0400)
	aAdd (aReg0400[nPos], 1)				//Relacao registro pai 0140
	aAdd (aReg0400[nPos], "0400")			//REG
	aAdd (aReg0400[nPos], cCodNat)			//COD_NAT
	aAdd (aReg0400[nPos], cDescNat)			//DESCR_NAT
EndIf

Return

/*ºPrograma  Reg0450   ºAutor  Erick G. Dias       º Data   06/01/11   º±±
±±ºDesc.      Informaµes complementares do documento fiscal             º*/
Static Function Reg0450 (cCodInf,aReg0450,nRelacFil,aPar)
	Local	nPos		:=	0
	Local	aInfCompl	:=	{"",""}

	Default	aPar		:=	{}
	Default	cCodInf		:=	""

	If Len(aPar) > 0
		aInfCompl[1]	:=	aPar[1]
		aInfCompl[2]	:=	aPar[2]
	Elseif CCE->(MsSeek (xFilial("CCE")+cCodInf))
		aInfCompl[1]	:=	CCE->CCE_COD
		aInfCompl[2]	:=	CCE->CCE_DESCR
	Endif

	If !Empty(aInfCompl[1])
		aAdd(aReg0450, {})
		nPos	:=	Len (aReg0450)
		aAdd (aReg0450[nPos], 1)						//Relacao com registro pai 0140, no areg0140 sempre haver¡ somente um registro, porq e zerado quando troco de filial, por isso esta fixo com 1.
		aAdd (aReg0450[nPos], "0450")					//REG
		aAdd (aReg0450[nPos], aInfCompl[1])            //COD_INF
		aAdd (aReg0450[nPos], aInfCompl[2])          	//TXT
	Endif
Return

/*±±ºPrograma  Reg0500   ºAutor  Erick G. Dias       º Data   06/01/11   º±±
±±ºDesc.      Plano de contas                                            º±±*/
Static Function Reg0500(aReg0500,cConta,aPar,cAliasSFT,lSPDPIS07)
Local	nPos 		:=	0
Local	cRetorno 	:=	""
Local	nPos0500	:=	0
Local	cCtaRef		:=	""

// Para evitar error Log caso a funo seja invocada pelo Extrator Fiscal TAF
If FunName() == 'EXTFISXTAF'
   Default lConcFil := aParSX6[27]  
EndIf


Default aPar		:= 	{}
Default cAliasSFT	:=	"SFT"
Default lSPDPIS07   :=  .T.  // Para o Registro  F100 nao usar o ponto de entrada.


If aExstBlck[14] .And. lSPDPIS07
	cConta	:=	ExecBlock("SPDPIS07", .F., .F., {	(cAliasSFT)->FT_FILIAL,;
													(cAliasSFT)->FT_TIPOMOV,;
													(cAliasSFT)->FT_SERIE,;
													(cAliasSFT)->FT_NFISCAL,;
													(cAliasSFT)->FT_CLIEFOR,;
													(cAliasSFT)->FT_LOJA,;
													(cAliasSFT)->FT_ITEM,;
													(cAliasSFT)->FT_PRODUTO})
Endif

If Len(aPar) > 0 .And. !Empty(cConta)
	aAdd(aReg0500, {})
	nPos	:=	Len (aReg0500)
	aAdd (aReg0500[nPos], "0500")		//01-REG
	aAdd (aReg0500[nPos], aPar[1])		//02-DT_ALT
	aAdd (aReg0500[nPos], aPar[2])		//03-COD_NAT_CC
	aAdd (aReg0500[nPos], aPar[3])		//04-IND_CTA
	aAdd (aReg0500[nPos], aPar[4])		//05-NIVEL
	aAdd (aReg0500[nPos], aPar[5])		//06-COD_CTA
	aAdd (aReg0500[nPos], aPar[6])		//07-NOME_CTA
	aAdd (aReg0500[nPos], aPar[7])		//08-COD_CTA_REF
	aAdd (aReg0500[nPos], aPar[8])		//09-CNPJ_EST

	cRetorno := aPar[5] // COD_CTA

Elseif !Empty(cConta)

	DbSelectArea("CT1")			                                               '
	CT1->(DbSetOrder(1))
	
	cConta := PadR(cConta, TamSX3("CT1_CONTA")[1])

	nPos0500:= aScan (aReg0500, {|aX| AllTrim(aX[6]) == AllTrim(cConta + Iif(lConcFil, xFilial("CT1"), ""))})

	If nPos0500 == 0
		If CT1->(MsSeek(xFilial("CT1")+ cConta))
			If CVD->(MsSeek(xFilial("CVD") + CT1->CT1_CONTA))
				cCtaRef := CVD->CVD_CTAREF
			Endif

			aAdd(aReg0500, {})
			nPos	:=	Len (aReg0500)
			aAdd (aReg0500[nPos], "0500") 										//01-REG
			aAdd (aReg0500[nPos], CT1->CT1_DTEXIS)  							//02-DT_ALT
			aAdd (aReg0500[nPos], CT1->CT1_NTSPED)  							//03-COD_NAT_CC
			aAdd (aReg0500[nPos], IIF(CT1->CT1_CLASSE=="1","S","A")) 			//04-IND_CTA
			aAdd (aReg0500[nPos], Str(CtbNivCta(cConta))) 						//05-NIVEL
			aAdd (aReg0500[nPos], AllTrim(CT1->CT1_CONTA + Iif(lConcFil, xFilial("CT1"), ""))) 	//06-COD_CTA
			aAdd (aReg0500[nPos], CT1->CT1_DESC01) 							//07-NOME_CTA
			aAdd (aReg0500[nPos], cCtaRef) 										//08-COD_CTA_REF
			aAdd (aReg0500[nPos], "") 											//09-CNPJ_EST

			cRetorno := AllTrim(CT1->CT1_CONTA + Iif(lConcFil, xFilial("CT1"), ""))
		Endif
	Else
		cRetorno := aReg0500[nPos0500][6]
	EndIF


Endif
Return(cRetorno)

/*±±ºPrograma  Reg0600   ºAutor  Erick G. Dias       º Data   07/01/11   º±±
±±ºDesc.      Centro de custos                                           º±±*/
Static Function Reg0600(aReg0600,cCusto,aPar)
Local nPos 		:=	0
Local cRetorno 	:=	""
Default	aPar	:=	{}

If Len(aPar) > 0 .And. !Empty(cCusto)

	aAdd(aReg0600, {})
	nPos	:=	Len (aReg0600)
	aAdd (aReg0600[nPos], "0600") 	//01-REG
	aAdd (aReg0600[nPos], aPar[1]) 	//02-DT_ALT
	aAdd (aReg0600[nPos], aPar[2])	//03-COD_CCUSC
	aAdd (aReg0600[nPos], aPar[3]) 	//04-CCUS
	cRetorno := aPar[2]
Elseif !Empty(cCusto)
	DbSelectArea("CTT")
	CTT->(dbSetOrder(1))
	If CTT->(MsSeek(xFilial("CTT")+ cCusto))
		If aScan (aReg0600, {|aX| AllTrim(aX[3])==AllTrim(CTT->CTT_CUSTO +Iif(lConcFil,xFilial("CTT"),""))}) == 0
	 		aAdd(aReg0600, {})
			nPos	:=	Len (aReg0600)
			aAdd (aReg0600[nPos], "0600")										//01-REG
			aAdd (aReg0600[nPos], CTT->CTT_DTEXIS)								//02-DT_ALT
			aAdd (aReg0600[nPos], AllTrim(CTT->CTT_CUSTO +Iif(lConcFil,xFilial("CTT"),"")))		//03-COD_CCUSC
			aAdd (aReg0600[nPos], left(CTT->CTT_DESC01,60))					//04-CCUS
		Endif
		cRetorno := AllTrim(CTT->CTT_CUSTO +Iif(lConcFil,xFilial("CTT"),""))
	Endif
Endif
Return (cRetorno)

/*±±ºPrograma  RegA010   ºAutor  Erick G. Dias       º Data   07/01/11   º±±
±±ºDesc.      Identificao do Estabelecimento                           º±±
±±º           Ser¡ gerado um A010 para cada filial                       º±±*/
Static Function RegA010(cAlias,aRegA010,nPaiA, lGravaA010)
Local nPos := 0

If aScan (aRegA010, {|aX| AllTrim(aX[2])==AllTrim(SM0->M0_CGC)}) == 0
	aAdd(aRegA010, {})
	nPos	:=	Len (aRegA010)
	aAdd (aRegA010[nPos], "A010") 				 //01-REG
	aAdd (aRegA010[nPos], AllTrim(SM0->M0_CGC)) //02-CNPJ
	nPaiA += 1
	lGravaA010:=.T.
EndIf
Return

/*
±±ºPrograma  RegA100 | Autor  Erick G. Dias             |Data 07/01/11 º±±
±±ºDesc.      Registro de nota fiscal de servico                         º±±
*/
Static Function RegA100(aRegA100,nRelacao,cAlias,cEntSai,cIndEmit,aPartDoc,aCmpAntSFT,cSituaDoc,aTotaliza,cChvNfe,nRelacaoA,dDataAte,lGrava0150,c1Dupref,c2Dupref,cMvEstado)
Local nPos 		:= 0
Local cIndPag   := "1"
Local aParc1	:= {}
Local nY		:= 0
Local cTipoTit	:= ""
Local clPrefix	:= "" //Iif(cEntSai=="1", Iif() &(c2Dupref) , &(c1Dupref) )

Local aSpeda100	:= {}
Local cDESBASC  :=aParSX6[32]
Local dDtExec	:=	CToD ("//")

Default	dDataAte	:=	CToD ("//")
Default lGrava0150	:= .T.
Default cMvEstado  := SuperGetMv("MV_ESTADO",,"")

dDtExec	:= dDataAte
IF cDESBASC == "2"
	dDtExec	:= aCmpAntSFT[6]
EndIF

//Para nota fiscal de entrada 
If cEntSai=="1"
	clPrefix := PadR(Iif( Right(AllTrim(c2Dupref),8)$"F1_SERIE" , aCmpAntSFT[28] , aCmpAntSFT[24] ),TamSx3("E2_PREFIXO")[1])
	SE2->(DbSetOrder (6))
	SE2->(MsSeek (xFilial("SE2")+aCmpAntSFT[3]+aCmpAntSFT[4]+clPrefix+aCmpAntSFT[1]))
	cTipoMov :=	"E"
	Do While (!SE2->(Eof ()) .And.;
		xFilial("SE2")==SE2->E2_FILIAL .And.;
		aCmpAntSFT[3]==SE2->E2_FORNECE .And.;
		aCmpAntSFT[4]==SE2->E2_LOJA .And.;
		clPrefix==SE2->E2_PREFIXO .And.;
		aCmpAntSFT[1]==SE2->E2_NUM )

   		If !(AllTrim (SE2->E2_TIPO)$MVTAXA+"|"+MVTXA+"|"+MVABATIM+"|"+cTipoTit) .And. (Substr(SE2->E2_TIPO,1,2) <> "NC")
		   nY += 1
		   aAdd (aParc1, {SE2->E2_TIPO, SE2->E2_HIST, SE2->E2_NUM, SE2->E2_PARCELA, SE2->E2_VENCREA, SE2->E2_VLCRUZ, SE2->E2_VENCTO})
		EndIf

		SE2->(DbSkip())
	EndDo
//Para nota fiscal de saida 
Else
	clPrefix := PadR(Iif( Right(AllTrim(c1Dupref),8)$"F2_SERIE" , aCmpAntSFT[28] , aCmpAntSFT[24] ),TamSx3("E1_PREFIXO")[1])
	SE1->(DbSetOrder (2))
	SE1->(MsSeek (xFilial("SE1")+aCmpAntSFT[3]+aCmpAntSFT[4]+clPrefix+aCmpAntSFT[1]))
	cTipoMov :=	"S"
	Do While (!SE1->(Eof ()) .And.;
		xFilial("SE1")==SE1->E1_FILIAL .And.;
		aCmpAntSFT[3]==SE1->E1_CLIENTE .And.;
		aCmpAntSFT[4]==SE1->E1_LOJA .And.;
		clPrefix==SE1->E1_PREFIXO .And.;
		aCmpAntSFT[1]==SE1->E1_NUM )

		If !(AllTrim (SE1->E1_TIPO)$MVTAXA+"|"+MVTXA+"|"+MVABATIM+"|"+cTipoTit) .And. (Substr(SE1->E1_TIPO,1,2) <> "NC")
		   nY += 1
		   aAdd (aParc1, {SE1->E1_TIPO, SE1->E1_HIST, SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_VENCREA, SE1->E1_VLCRUZ, SE1->E1_VENCTO})
		EndIf

		SE1->(DbSkip ())
	EndDo
EndIf


If nY==0
	cIndPag:= "9" ////13 - IND_PAGTO - SEM PAGAMENTO
Elseif Len(aParc1)  > 1
	cIndPag:= "1"	  			  	//13 - IND_PAGTO - A VISTA
Elseif Len(aParc1)  == 1 .And. cEntSai=="2" .And. aCmpAntSFT[6] == aParc1[1,7]
	cIndPag:= "0"	  			  	//13 - IND_PAGTO - A VISTA
Elseif Len(aParc1)  == 1 .And. cEntSai=="1" .And. aCmpAntSFT[6] == aParc1[1,7]
	cIndPag:= "0"
Endif

If !(cMvEstado == "DF" .And. cSituaDoc == "05")
	If !cSituaDoc == "02"  //Cancelada
	
		aAdd(aRegA100, {})
		nPos	:=	Len (aRegA100)
	
		aAdd (aRegA100[nPos], "A100") 	  						//01-REG
		aAdd (aRegA100[nPos], STR(Val (cEntSai)-1,1))  			//02-IND_OPER
		aAdd (aRegA100[nPos], cIndEmit) 						//03-IND_EMIT
		aAdd (aRegA100[nPos], Iif(lGrava0150,aPartDoc[1],"")) 	//04-COD_PART
		aAdd (aRegA100[nPos], cSituaDoc) 						//05-COD_SIT
		aAdd (aRegA100[nPos], aCmpAntSFT[2]) 	     			//06-SER
		aAdd (aRegA100[nPos], "") 								//07-SUB
		aAdd (aRegA100[nPos], Iif(!Empty(aCmpAntSFT[27]),aCmpAntSFT[27],aCmpAntSFT[01]) )		//08-NUM_DOC
		aAdd (aRegA100[nPos], cChvNfe) 							//09-CHV_NFSE
		aAdd (aRegA100[nPos], aCmpAntSFT[6]) 					//10-DT_DOC
	 
	//Devido a possibilidade de a Nota Fiscal ser escriturada no mes subsequente,
	// adotou-se a seguinte regra do guia pratico no (Campo 11-DT_EXE_SERV),     
	// no qual diz que deve ser levado o "ultimo dia da escrituracao".           
		aAdd (aRegA100[nPos], dDtExec)	   					//11-DT_EXE_SERV
		aAdd (aRegA100[nPos], aTotaliza[1]) 				//12-VL_DOC
		aAdd (aRegA100[nPos], cIndPag)						//13-IND_PAGTO
		aAdd (aRegA100[nPos], aTotaliza[9]) 				//14-VL_DESC
		aAdd (aRegA100[nPos], aTotaliza[23]+aTotaliza[30])	//15-VL_BC_PIS
		aAdd (aRegA100[nPos], aTotaliza[19]+aTotaliza[28])	//16-VL_PIS
		aAdd (aRegA100[nPos], aTotaliza[24]+aTotaliza[31])	//17-VL_BC_COFINS
		aAdd (aRegA100[nPos], aTotaliza[20]+aTotaliza[29])	//18-VL_COFINS
		aAdd (aRegA100[nPos], aTotaliza[21]) 				//19-VL_PIS_RET
		aAdd (aRegA100[nPos], aTotaliza[22]) 				//20-VL_COFINS_RET
		aAdd (aRegA100[nPos], aTotaliza[3]) 				//21-VL_ISS
		//Ponto de entrada para o campo 13(IND_PAGTO)        
	   	If aExstBlck[15]
		   	aSpeda100 := ExecBlock("SPDPIS05", .F., .F., {"SFT",aCmpAntSFT,0})
			aRegA100[nPos][13] := aSpeda100[01]
		Endif
	
	Else
		//Se for cancelada preenche com vazio os valores.
		aAdd(aRegA100, {})
		nPos	:=	Len (aRegA100)
		aAdd (aRegA100[nPos], "A100") 	  				//01-REG
		aAdd (aRegA100[nPos], STR(Val (cEntSai)-1,1))  //02-IND_OPER
		aAdd (aRegA100[nPos], cIndEmit) 				//03-IND_EMIT
		aAdd (aRegA100[nPos], "") 						//04-COD_PART
		aAdd (aRegA100[nPos], cSituaDoc) 				//05-COD_SIT
		aAdd (aRegA100[nPos], aCmpAntSFT[2])			//06-SER
		aAdd (aRegA100[nPos], "") 						//07-SUB
		aAdd (aRegA100[nPos], Iif(!Empty(aCmpAntSFT[27]),aCmpAntSFT[27],aCmpAntSFT[01])) 			//08-NUM_DOC
		aAdd (aRegA100[nPos], "") 						//09-CHV_NFSE
		aAdd (aRegA100[nPos], "") 						//10-DT_DOC
		aAdd (aRegA100[nPos], "")						//11-DT_EXE_SERV
		aAdd (aRegA100[nPos], "") 						//12-VL_DOC
		aAdd (aRegA100[nPos], "") 						//13-IND_PAGTO
		aAdd (aRegA100[nPos], "") 						//14-VL_DESC
		aAdd (aRegA100[nPos], "") 						//15-VL_BC_PIS
		aAdd (aRegA100[nPos], "") 						//16-VL_PIS
		aAdd (aRegA100[nPos], "") 						//17-VL_BC_COFINS
		aAdd (aRegA100[nPos], "") 						//18-VL_COFINS
		aAdd (aRegA100[nPos], "") 						//19-VL_PIS_RET
		aAdd (aRegA100[nPos], "") 						//20-VL_COFINS_RET
		aAdd (aRegA100[nPos], "") 						//21-VL_ISS
	EndIf
EndIf	
Return

/*±±ºPrograma  RegA110   ºAutor  Erick G. Dias       º Data   07/01/11 º±±
±±ºDesc.     Complemento do documento - Informacoes complementares da NF º±±*/
Static Function RegA110(aRegA110,cCodInf,nPosA110)
Local	nPos	:=	0

If CCE->(MsSeek(xFilial("CCE")+cCodInf))
	aAdd(aRegA110, {})
	nPos :=	Len (aRegA110)
	aAdd (aRegA110[nPos], "A110")					//REG
	aAdd (aRegA110[nPos], cCodInf) 					//COD_INF
	aAdd (aRegA110[nPos], CCE->CCE_DESCR )         //TXT_COMPL
	nPosA110 :=	nPos
EndIf
Return

/*±±ºPrograma  RegA111   ºAutor  Erick G. Dias       º Data   07/01/11   º±±
±±ºDesc.     Processo referenciado                                       º±±
±±ParametrosaRegA111   -> Array com informaµes do registro A111        ±±
±±          nPosA110   -> Relacionamento com registro A110              ±±
±±          aReg1010   -> Array com Informaµes do registro 1010.       ±±
±±          aReg1020   -> Array com Informaµes do registro 1020.       ±±*/
Static Function RegA111 (aRegA111, nPosA110,aReg1010,aReg1020)
Local	lRet		:=	.T.
Local	nPos111		:=	1
Local   nPos        := 0
Local   cChave      := ""
Local 	lAchouCCF	:= .F.

cChave := CDG->CDG_FILIAL+CDG->CDG_TPMOV+CDG->CDG_DOC+CDG->CDG_SERIE+CDG->CDG_CLIFOR+CDG->CDG_LOJA

Do while !CDG->(Eof()) .And. CDG->CDG_FILIAL+CDG->CDG_TPMOV+CDG->CDG_DOC+CDG->CDG_SERIE+CDG->CDG_CLIFOR+CDG->CDG_LOJA==cChave
	// Verifica se o codigo da info ja esta lancada no A111
	If (nPos := aScan (aRegA111, {|aX| aX[2]==CDG->CDG_PROCES})==0)
		aAdd(aRegA111, {})
		nPos111 := Len(aRegA111)
		aAdd (aRegA111[nPos111], "A111")				//01 - REG
		aAdd (aRegA111[nPos111], CDG->CDG_PROCES)		//02 - NUM_PROC
		aAdd (aRegA111[nPos111], CDG->CDG_TPPROC)		//03 - IND_PROC

		lAchouCCF	:=	CCF->(MsSeek (xFilial ("CCF")+ CDG->CDG_PROCES +CDG->CDG_TPPROC))
		If	lAchouCCF
			If CCF->CCF_TPCOMP == "1" //Complemento do processo referenciado - Judicial
				Reg1010(aReg1010)
			ElseIf CCF->CCF_TPCOMP == "2" //Complemento do processo referenciado - Administrativo
				Reg1020(aReg1020)
			EndIF
		EndIf
	Endif
	CDG->(DbSkip())
EndDo
Return

/*
±±ºPrograma  RegA170   ºAutor  Erick G. Dias       º Data   07/01/11   º±±
±±ºDescrio Gerao dos itens do documento da nota de servio.          º±±
*/
Static Function RegA170(cAlias,aRegA170,cAliasSFT,cProd,cDescProd,nRelacao,cEntSai,aReg0500,aReg0600,aRegM210,aRegM610,aWizard,;
						aRegAuxM105,aRegAuxM505,cRegime,aRegM400,aRegM410,aRegM800,aRegM810,lCumulativ,cIndApro,aReg0111,nItem,;
						lPisZero,lCofZero, aDevolucao,aRegM220,aRegM620,aRegM230,aRegM630,cAliasSB1,lTop,cAliasSD1,cAliasSD2)

Local nPos 			:=0
Local cOrigCred 	:= ""
Local nAlqPis		:= 0
Local nAlqCof		:= 0
Local nBasePis		:= 0
Local nBaseCof		:= 0
Local nValPis		:= 0
Local nValCof		:= 0
Local cConta		:= ""
Local cCCusto		:= ""



nAlqPis		:= (cAliasSFT)->FT_ALIQPIS
nBasePis	:= (cAliasSFT)->FT_BASEPIS
nValPis		:= (cAliasSFT)->FT_VALPIS

nAlqCof		:= (cAliasSFT)->FT_ALIQCOF
nBaseCof  	:= (cAliasSFT)->FT_BASECOF
nValCof		:= (cAliasSFT)->FT_VALCOF

If	cEntSai=="1" .And. SubStr((cAliasSFT)->FT_CFOP,1,1) <= "3"
	If SubStr((cAliasSFT)->FT_CFOP,1,1) == "3"
		cOrigCred:="1"
	Else
		cOrigCred:="0"
	EndIf
EndIf

aAdd(aRegA170, {})
nPos := Len(aRegA170)
aAdd (aRegA170[nPos], "A170")						   					//01 - REG
aAdd (aRegA170[nPos], AllTrim (STR(nItem)))							//02 - NUM_ITEM
aAdd (aRegA170[nPos], cProd)			   	  							//03 - COD_ITEM
aAdd (aRegA170[nPos], cDescProd)										//04 - DESCR_COMPL
aAdd (aRegA170[nPos], (cAliasSFT)->FT_TOTAL)							//05 - VL_ITEM
aAdd (aRegA170[nPos], Iif(SF4->F4_PISCRED == "5",(cAliasSFT)->FT_TOTAL, (cAliasSFT)->FT_DESCONT))	//06 - VL_DESC
aAdd (aRegA170[nPos], (cAliasSFT)->FT_CODBCC)							//07 - NAT_BC_CRED
aAdd (aRegA170[nPos], cOrigCred)			   							//08 - IND_ORIG_CRED
aAdd (aRegA170[nPos], (cAliasSFT)->FT_CSTPIS)							//09 - CST_PIS
aAdd (aRegA170[nPos], nBasePis)											//10 - VL_BC_PIS
aAdd (aRegA170[nPos], nAlqPis)											//11 - ALIQ_PIS
aAdd (aRegA170[nPos], nValPis)											//12 - VL_PIS
aAdd (aRegA170[nPos], (cAliasSFT)->FT_CSTCOF)							//13 - CST_COFINS
aAdd (aRegA170[nPos], nBaseCof)											//14 - VL_BC_COFINS
aAdd (aRegA170[nPos], nAlqCof)											//15 - ALIQ_COFINS
aAdd (aRegA170[nPos], nValCof)											//16 - VL_COFINS


cConta		:= ""
cCCusto		:= ""
If cEntSai =="1"
	IF lTop
		cConta	:=	Reg0500(aReg0500,(cAliasSD1)->D1_CONTA,,cAliasSFT)
		cCCusto	:= 	Reg0600(aReg0600,(cAliasSD1)->D1_CC)
	Else
		dbSelectArea("SD1")
		SD1->(dbSetOrder(1))
		If SD1->(MsSeek(xFilial("SD1")+  (cAliasSFT)->FT_NFISCAL +  (cAliasSFT)->FT_SERIE+  (cAliasSFT)->FT_CLIEFOR +  (cAliasSFT)->FT_LOJA +  (cAliasSFT)->FT_PRODUTO + (cAliasSFT)->FT_ITEM))
			cConta:= Reg0500(aReg0500,SD1->D1_CONTA,,cAliasSFT)
			cCCusto:= Reg0600(aReg0600,SD1->D1_CC)
		EndIf
	EndIF

Else
	IF lTop
		cConta:=  Reg0500(aReg0500,(cAliasSD2)->D2_CONTA,,cAliasSFT)
		cCCusto:= Reg0600(aReg0600,(cAliasSD2)->D2_CCUSTO)
	Else
		dbSelectArea("SD2")
		SD2->(dbSetOrder(3))
		If SD2->(MsSeek(xFilial("SD2")+  (cAliasSFT)->FT_NFISCAL +  (cAliasSFT)->FT_SERIE+  (cAliasSFT)->FT_CLIEFOR +  (cAliasSFT)->FT_LOJA +  (cAliasSFT)->FT_PRODUTO + (cAliasSFT)->FT_ITEM))
			cConta:= Reg0500(aReg0500,SD2->D2_CONTA,,cAliasSFT)
			cCCusto:= Reg0600(aReg0600,SD2->D2_CCUSTO)
		EndIf
	EndIF

EndIF

aAdd (aRegA170[nPos], cConta)									//17 - COD_CTA
aAdd (aRegA170[nPos], cCCusto)									//18 - COD_CCUS	l


//Se for operao de sa­da, ir¡ tratar registros de apurao no bloco M
If cEntSai == "2"
	RegM210(aRegM210,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM220,,,@aRegM230,,cAliasSB1)

	If (cAliasSFT)->FT_CSTPIS $ "04/06/07/08/09"
		RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1)
	ElseIF (cAliasSFT)->FT_CSTPIS == "05" .AND. (cAliasSFT)->FT_ALIQPIS == 0
		RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1)
	EndIF

	RegM610(aRegM610,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM620,,,@aRegM630,,cAliasSB1)
	If (cAliasSFT)->FT_CSTCOF $ "04/06/07/08/09"
		RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1)
	ElseIf (cAliasSFT)->FT_CSTCOF == "05" .AND. (cAliasSFT)->FT_ALIQCOF == 0 //se for CST 04, 06, 07, 08, 09 grava M400 direto
		RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1)
	EndIF

Else
	//Se CST de entrada d¡ direito a cr©dito de PIS, ir¡ acumular valor para gerao do registro M100 e filhos.
	If (cAliasSFT)->FT_CSTPIS $ CCSTCRED	//Se CST pertence a um dos CSTs de cr©ditos
		AcumM105(aRegAuxM105,cAliasSFT,cRegime,lCumulativ,cIndApro,aReg0111,,,,,cAliasSB1)
	EndIF
	//Se CST de entrada d¡ direito a cr©dito de COFINS, ir¡ acumular valor para gerao do registro M100 e filhos.
	If (cAliasSFT)->FT_CSTCOF $ CCSTCRED //Se CST pertence a um dos CSTs de cr©ditos
		AcumM505(aRegAuxM505,cAliasSFT,cRegime,lCumulativ,cIndApro,aReg0111,,,,,cAliasSB1)
	EndIF
EndIF
Return

/*±±ºPrograma   Reg9900   ºAutor  Erick G. Dias       º Data   06/01/11   º±±
±±ºDesc.      Encerramento do arquivo                                    º±±*/
Static Function Reg9900 (cAlias, aReg9900)
	Local	lRet	:=	.T.
	PCGrvReg (cAlias,,aReg9900,,,,,,nTamTRBIt)
Return (lRet)
/*±±ºPrograma  Reg9999   ºAutor  Erick G. Dias       º Data   06/01/11   º±±
±±ºDesc.      Encerramento do arquivo                                    º±±*/
Static Function Reg9999 (cAlias,lProcMThr)
Local	lRet	:=	.T.
Local	nPos	:=	0
Local	aReg	:= {}

Default lProcMThr	:= .F.

aAdd(aReg, {})
nPos	:=	Len (aReg)
nTotLin := Iif( lProcMThr ,  n_SPCRecno  ,  (cAlias)->(RecCount()) + 1 )
aAdd (aReg[nPos], "9999")					//01 - REG
aAdd (aReg[nPos], Alltrim(STR(nTotLin)))	//02 - QTD_LIN
PCGrvReg (cAlias,,aReg,,,,,,nTamTRBIt)
Return (lRet)

/*±±ºPrograma  GrvIndMov   ºAutor  Erick G. Dias     º Data   06/01/11 º±±
±±ºDesc.      Gravao dos indicadores do movimentos                     º±±*/
Static Function GrvIndMov (cAlias,lBlocACDF)
Local	nQtd0990	:=	0
Local   nQtdA990    :=  0
Local   nQtdC990    :=  0
Local   nQtdD990    :=  0
Local   nQtdF990    :=  0
Local   nQtdI990	:=0
Local   nQtdM990    :=  0
Local   nQtdP990    :=  0
Local   nQtd1990    :=  0
Local 	nQtd9990	:=	0
Local	nPos		:=	0
Local	aReg9900	:=	{}
Local 	cQrySQL		:= ""
Local 	cAliasSQL	:= GetNextAlias()
Local 	nTotLines	:= 0
Local	cTRB_TPREG	:= Iif(TcGetDb()="INFORMIX", "1", "SUBSTRING(TRB.TRB_TPREG,1,1)")     

If !lProcMThr
	DbSelectArea (cAlias)
	(cAlias)->(DbSetOrder (1))
	(cAlias)->(DbGoTop ())
	//
	Do While !(cAlias)->(Eof ())

		If (nPos := aScan (aReg9900, {|aX| aX[2]==(cAlias)->TRB_TPREG}))==0
			aAdd (aReg9900, {"9900",(cAlias)->TRB_TPREG,"1"})
		Else
			aReg9900[nPos][3] := Alltrim(STR( Val( aReg9900[nPos][3] )+1))
		EndIf

		//REGISTROS - 0
		If (Left ((cAlias)->TRB_TPREG, 1)$"0")
			nQtd0990++
		elseIf (Left ((cAlias)->TRB_TPREG, 1)$"A")
			nQtdA990++
		elseIf (Left ((cAlias)->TRB_TPREG, 1)$"C")
			nQtdC990++
		elseIf (Left ((cAlias)->TRB_TPREG, 1)$"D")
			nQtdD990++
		elseIf (Left ((cAlias)->TRB_TPREG, 1)$"F")
			nQtdF990++
		elseIf (Left ((cAlias)->TRB_TPREG, 1)$"I")
			nQtdI990++
		elseIf (Left ((cAlias)->TRB_TPREG, 1)$"M")
			nQtdM990++
		elseIf (Left ((cAlias)->TRB_TPREG, 1)$"1")
			nQtd1990++
		elseIf (Left ((cAlias)->TRB_TPREG, 1)$"P")
			nQtdP990++
		EndIf

		(cAlias)->(DbSkip ())
	EndDo
Else
	// PRIMEIRA CONTAGEM POR TIPO DE REGISTRO
	cQrySQL := " SELECT TRB.TRB_TPREG,  COUNT(*) PCCOUNT FROM " + cNomeTRB + " TRB "
	cQrySQL += " GROUP BY TRB.TRB_TPREG  "
	cQrySQL := ChangeQuery(cQrySQL)
	TcQuery cQrySql New ALias &cAliasSQL
	While (cAliasSQL)->(!EOF())
		//REGISTROS - aReg9900 
		aAdd (aReg9900, {"9900",(cAliasSQL)->TRB_TPREG,AllTrim(cValToChar((cAliasSQL)->PCCOUNT))})
		nTotLines+= (cAliasSQL)->PCCOUNT
		(cAliasSQL)->(dbSkip())
	EndDo
	(cAliasSQL)->(dbCloseArea())

	// SEGUNDA CONTAGEM POR BLOCO
	cQrySQL := " SELECT SUBSTRING(TRB.TRB_TPREG,1,1) TRB_TPREG, COUNT(*) PCCOUNT FROM " + cNomeTRB + " TRB "
	cQrySQL += " GROUP BY " + cTRB_TPREG
	cQrySQL := ChangeQuery(cQrySQL)
	TcQuery cQrySql New ALias &cAliasSQL
	While (cAliasSQL)->(!EOF())
		//REGISTROS - 0     
		If (Left ((cAliasSQL)->TRB_TPREG, 1)$"0")
			nQtd0990 := (cAliasSQL)->PCCOUNT
		elseIf (Left ((cAliasSQL)->TRB_TPREG, 1)$"A")
			nQtdA990 := (cAliasSQL)->PCCOUNT
		elseIf (Left ((cAliasSQL)->TRB_TPREG, 1)$"C")
			nQtdC990 := (cAliasSQL)->PCCOUNT
		elseIf (Left ((cAliasSQL)->TRB_TPREG, 1)$"D")
			nQtdD990 := (cAliasSQL)->PCCOUNT
		elseIf (Left ((cAliasSQL)->TRB_TPREG, 1)$"F")
			nQtdF990 := (cAliasSQL)->PCCOUNT
		elseIf (Left ((cAliasSQL)->TRB_TPREG, 1)$"I")
			nQtdI990 := (cAliasSQL)->PCCOUNT
		elseIf (Left ((cAliasSQL)->TRB_TPREG, 1)$"M")
			nQtdM990 := (cAliasSQL)->PCCOUNT
		elseIf (Left ((cAliasSQL)->TRB_TPREG, 1)$"1")
			nQtd1990 := (cAliasSQL)->PCCOUNT
		elseIf (Left ((cAliasSQL)->TRB_TPREG, 1)$"P")
			nQtdP990 := (cAliasSQL)->PCCOUNT
		EndIf
		(cAliasSQL)->(dbSkip())
	EndDo
	(cAliasSQL)->(dbCloseArea())

EndIf

//Gravacao do indicador de movimento do bloco 0.   
BlAbEnc ("A", cAlias, "0001", Iif (nQtd0990>0, "0", "1"),)
BlAbEnc ("E", cAlias, "0990",, nQtd0990)
aAdd (aReg9900, {"9900","0001","1"})
aAdd (aReg9900, {"9900","0990","1"})
If lBlocACDF
	//Gravacao do indicador de movimento do bloco A.   
	BlAbEnc ("A", cAlias, "A001", Iif (nQtdA990>0, "0", "1"),)
	BlAbEnc ("E", cAlias, "A990",, nQtdA990)
	aAdd (aReg9900, {"9900","A001","1"})
	aAdd (aReg9900, {"9900","A990","1"})

	//Gravacao do indicador de movimento do bloco C
	BlAbEnc ("A", cAlias, "C001", Iif (nQtdC990>0, "0", "1"),)
	BlAbEnc ("E", cAlias, "C990",, nQtdC990)
	aAdd (aReg9900, {"9900","C001","1"})
	aAdd (aReg9900, {"9900","C990","1"})

	//Gravacao do indicador de movimento do bloco D
	BlAbEnc ("A", cAlias, "D001", Iif (nQtdD990>0, "0", "1"),)
	BlAbEnc ("E", cAlias, "D990",, nQtdD990)
	aAdd (aReg9900, {"9900","D001","1"})
	aAdd (aReg9900, {"9900","D990","1"})
EndIf

//Gravacao do indicador de movimento do bloco F
BlAbEnc ("A", cAlias, "F001", Iif (nQtdF990>0, "0", "1"),)
BlAbEnc ("E", cAlias, "F990",, nQtdF990)
aAdd (aReg9900, {"9900","F001","1"})
aAdd (aReg9900, {"9900","F990","1"})

If dDataDe > cToD("31/12/2013")
	BlAbEnc ("A", cAlias, "I001", Iif (nQtdI990>0, "0", "1"),)
	BlAbEnc ("E", cAlias, "I990",, nQtdI990)
	aAdd (aReg9900, {"9900","I001","1"})
	aAdd (aReg9900, {"9900","I990","1"})
End if

//Gravacao do indicador de movimento do bloco F
BlAbEnc ("A", cAlias, "M001", Iif (nQtdM990>0, "0", "1"),)
BlAbEnc ("E", cAlias, "M990",, nQtdM990)
aAdd (aReg9900, {"9900","M001","1"})
aAdd (aReg9900, {"9900","M990","1"})

If cBlocoP $ "1/3"
	//Gravacao do indicador de movimento do bloco P
	BlAbEnc ("A", cAlias, "P001", Iif (nQtdP990>0, "0", "1"),)
	BlAbEnc ("E", cAlias, "P990",, nQtdP990)
	aAdd (aReg9900, {"9900","P001","1"})
	aAdd (aReg9900, {"9900","P990","1"})
EndIf
//Gravacao do indicador de movimento do bloco 1
BlAbEnc ("A", cAlias, "1001", Iif (nQtd1990>0, "0", "1"),)
BlAbEnc ("E", cAlias, "1990",, nQtd1990)
aAdd (aReg9900, {"9900","1001","1"})
aAdd (aReg9900, {"9900","1990","1"})

//Outros registros que devem ser totalizados       
aAdd (aReg9900, {"9900","9001","1"})
aAdd (aReg9900, {"9900","9990","1"})
aAdd (aReg9900, {"9900","9999","1"})
aAdd (aReg9900, {"9900","9900",STR(len(aReg9900)+1)})

//Gravacao do bloco 9 (Totalizacao dos registros)  
Reg9900 (cAlias, aReg9900 )
nQtd9990 := len(aReg9900) + 1
BlAbEnc ("A", cAlias, "9001", Iif (nQtd9990>0, "0", "1"),)
BlAbEnc ("E", cAlias, "9990",, nQtd9990)
Reg9999 (cAlias,lProcMThr)
Return

/*±±Programa  |GeraTrb    Autor Liber De Esteban        Data 26.05.2008±±
±±Descri€¡€¦o                                                             ±±
±±                        GERACAO DA ESTRUTURA DO TRB                   ±±
±±                                                                      ±±
±±ObservacaoGeracao da estrutura do TRB utilizado em todo o processamento±±
±±Retorno   lRet -> .T.                                                 ±±
±±Parametros|nTipo -> 1=Gerar o TRB, 2=Fechar o TRB                      ±±
±±          cArq -> Nome fisico do TRB criado                           ±±
±±          cAlias -> Alias do TRB criado                               ±±
±±           --- Novos parametros para atender funcionalidade MT ---    ±±
±±          lTabDB -> Define se trabalhara com tabela no banco          ±±
±±          nHandleTRB -> nHandle do arquvo de controle                 ±±
±±          nThreads -> Quantidade de Threads                           ±±
±±          cSemaphore -> Identificacao / Semaforo                      ±±*/
Static Function GeraTrb (nTipo, aArq, cAlias , lTabDB, nHandleTRB, nThreads , cSemaphore )

Local	lRet	:=	.T.
Local	aCmp	:=	{}
Local	cArq	:=	""
Local	nI		:=	0
Local 	nCont	:=  0
Local   cNameArq := cNomeTRB  + ".TOTVSSPDC"

Default lTabDB		:= .F.
Default nHandleTRB	:= -1
Default nThreads	:= 0
Default cSemaphore	:= ""
//
If (nTipo==1)

	//TRB Geral
	cAlias	:=	"TRB"
	aAdd (aCmp, {"TRB_TPREG",	"C",   					004,	   			0})
	aAdd (aCmp, {"TRB_RELAC",	"C",   					nTamTRBIt*2,		0})
	aAdd (aCmp, {"TRB_FLAG",	"C",   					001,				0})
 	aAdd (aCmp, {"TRB_CONT", 	"C", iif(TcGetDb()="INFORMIX",255,999),    0})
	aAdd (aCmp, {"TRB_ITEM",	Iif(lTabDB,"C","N") , 	007,				0})
	aAdd (aCmp, {"TRB_PAI", 	"N",  					007,				0})
	aAdd (aCmp, {"TRB_CHVPAI", 	"C",  					010,				0})

	// Cria tabela local - DBF/DTC
	If !lTabDB

		cArq	:=	CriaTrab (aCmp)
		DbUseArea (.T., __LocalDriver, cArq, cAlias)
		IndRegua (cAlias, cArq, "TRB_TPREG+TRB_RELAC+StrZero (TRB_ITEM, 7, 0)")
    	aAdd (aArq, {cAlias, cArq})
	// Cria tabela no banco
  	Else
		If (lRet := PCDelTmpDB(cNomeTRB))
			PCCriaTab( cNomeTRB , cAlias, aCmp, "TRB_TPREG+TRB_RELAC+TRB_ITEM" /*"TRB_TPREG+TRB_RELAC+StrZero(TRB_ITEM,7,0)" */ )
		Else
	   		PCCriaTab( cNomeTRB , cAlias, aCmp, "TRB_TPREG+TRB_RELAC+TRB_ITEM" /*"TRB_TPREG+TRB_RELAC+StrZero(TRB_ITEM,7,0)" */ , .T. )
		EndIf
		// Cria arquivo no System com nome da tabela temporaria
		nHandleTRB := MSFCreate( cNameArq )

	EndIf
Else
	// Exclui tabela - padrao
	If !lTabDB
		For nI := 1 To Len (aArq)
			DbSelectArea (aArq[nI][1])
			(aArq[nI][1])->(DbCloseArea ())
			Ferase (aArq[nI][2]+GetDBExtension ())
			Ferase (aArq[nI][2]+OrdBagExt ())
		Next nI
	Else
		// Mata as Threads
		If nThreads>0
			For nCont:=1 To nThreads
				IPCGo( cSemaphore, "_E_X_I_T_")
			Next nCont
		EndIF
		// Fecha / Deleta tabela do banco
		(cAlias)->(dbCloseArea())
		PCDelTmpDB(cNomeTRB,.F.)
		// Fecha / Deleta arquivo de inform.
		FClose( nHandleTRB )
		FErase( cNameArq )
	EndIf


EndIf

cAlias	:=	"TRB"	//Devo sempre retornar para os casos que nao tiverem TRB proprio.
Return (lRet)

Static Function VldIE(cInsc,lContr,lIsent)

Local 		cRet	:=	""
Local 		nI		:=	1
Default 	lContr  :=	.T.
Default		lIsent	:=	.T.

For nI:=1 To Len(cInsc)
	If Isdigit(Subs(cInsc,nI,1)) .Or. IsAlpha(Subs(cInsc,nI,1))
		cRet+=Subs(cInsc,nI,1)
	Endif
Next
cRet := AllTrim(cRet)

If lIsent
	If "ISENT"$Upper(cRet)
		cRet := ""
	EndIf
	If !(lContr) .And. !Empty(cRet)
		cRet := "ISENTA"
	EndIf
EndIf
Return(cRet)


Static function BlAbEnc (cAbEnc, cAlias, cReg, cIndMov, nQtdLin)
	Local	lRet		:=	.T.
	Local	aBlAbEnc	:=	{}
	//
	aAdd(aBlAbEnc, {})
	nPos	:=	Len (aBlAbEnc)
	//
	If ("A"$cAbEnc)
		aAdd (aBlAbEnc[nPos], cReg)
		aAdd (aBlAbEnc[nPos], cIndMov)
	Else
		aAdd (aBlAbEnc[nPos], cReg)
		aAdd (aBlAbEnc[nPos], Alltrim(STR(nQtdLin+2)))	// O +2 eh para somar o registro de abertura mais o registro de encerramento
	EndIf
	//
	PCGrvReg (cAlias,,aBlAbEnc,,,,,,nTamTRBIt)
Return (lRet)


Static Function OrgTxt (cAlias, cFile)

Local	lRet		:=	.T.
Local	lGravaReg1	:=	.F.
Local	lGravaReg8	:=	.F.
Local	lGravaReg9	:=	.F.
Local	nHandle		:=	-1
Local	cRelac		:=	""
Local	cChave		:=	""
Local   nPai		:= 0
Local   cTrab	    := CriaTrab(,.F.)+".TXT"
Local	cDrive		:=	""
Local	cPath		:=	""
Local	cNewFile	:=	""
Local	cExt		:=	""
Local 	cStartPath 	:= 	GetSrvProfString("StartPath","")
Local 	cItem		:= ""
Local   aAreaAux	:= {}
Local	aArea3		:= {}
Local cTipoDB	:= AllTrim(Upper(TcGetDb())) // Tipo do banco de dados

Local 	cQuery		:= ""
Local 	cSqlAlias	:= GetNextAlias()
Local 	cAliasBP	:= GetNextAlias()                
Local 	nCont 		:= 0
Local 	cOrderBy	:= " ORDER BY TRB.TRB_PAI, SUBSTRING(TRB_RELAC,1,50), SUBSTRING(TRB_RELAC,51,50), TRB.TRB_TPREG" + IIf(cTipoDB $ "ORACLE", " ,CAST(TRB.TRB_ITEM as NUMERIC) ", " ")
Local 	cRegs0		:= "0000|0001|0100|0110|0110|0111|0140|0145|0150|0190|0200|0205|0206|0208|0400|0450|0500|0600"
Local 	cRegsA		:= "A100|A110|A111|A120|A170"
Local 	cRegsC1		:= "C100|C110|C111|C120|C170|C175"
Local 	cRegsC2		:= "C180|C181|C185|C188"
Local 	cRegsC3		:= "C190|C191|C195|C198|C199"
Local 	cRegsC4		:= "C380|C381|C385|C395|C396"
Local 	cRegsLj		:= "C400|C405|C481|C485|C489|C490|C491|C495|C499"
Local 	cRegsC500	:= "C500"
Local 	cRegsC600	:= "C600|C601|C605"
Local 	cRegsD		:= "D100|D101|D105|D111"
Local	cRegsD2		:= "D200|D201|D205|D209"
Local	cRegsD3		:= "D300|D309|D350|D359"
Local	cRegsD5		:= "D500|D501|D505|D509"
Local	cRegsD6		:= "D600|D601|D605|D609"
//Bloco F	---------------------------------------------------------------------------
Local 	cRegsF		:= "F100|F111"
Local 	cRegsF1		:= "F120|F129"
Local 	cRegsF2		:= "F130|F139"
Local 	cRegsF3		:= "F150"
Local 	cRegsF4		:= "F200|F205|F210"
Local 	cRegsF5		:= "F500|F509"
Local 	cRegsF6		:= "F510|F519"
Local 	cRegsF7		:= "F525"
Local 	cRegsF8		:= "F550|F559"
Local 	cRegsF9		:= "F560|F569"
Local 	cRegsFa		:= "F600"
Local 	cRegsFb		:= "F700"

Local 	cRegsPa		:= "P010"           
Local 	cRegsPb		:= "P100|P200" 
Local 	nContP		:= 0          

Local 	cRegsM		:= Iif(!lGrBlocoM," ","M100|M105|M110|M400|M410|M500|M505|M510|M200|M210|M211|M220|M230|M300|M350|M600|M610|M611|M620|M630|M700|M800")
Local 	aStruBlA	:= {"4","0",cRegsA}
Local 	aStruBlC	:= {{"4","0",cRegsC1},{"4","0",cRegsC2},{"4","0",cRegsC3},{"4","0",cRegsC4},{"4","0",cRegsLj},{"4","0",cRegsC500},{"4","0",cRegsC600}}
Local 	aStruBlD	:= {{"4","0",cRegsD},{"4","0",cRegsD2},{"4","0",cRegsD3},{"4","0",cRegsD5},{"4","0",cRegsD6}}
Local 	aStruBlF	:= {{"4","0",cRegsF},{"4","0",cRegsF1},{"4","0",cRegsF2},{"4","0",cRegsF3},{"4","0",cRegsF4},{"4","0",cRegsF5},{"4","0",cRegsF6},{"4","0",cRegsF7},{"4","0",cRegsF8},{"4","0",cRegsF9},{"4","0",cRegsFa},{"4","0",cRegsFb}}
Local 	aStruBlP	:= {{"4","0",cRegsPa},{"4","0",cRegsPb}}
Local 	aStruBlM	:= {"4","0",cRegsM}
Local 	aStruQry	:= {"4","0",cRegs0}

nHandle	:=	MsFCreate (cTrab)

// OrgTxt - MT
If lProcMThr

	IncProc(STR0065)	//"Gerando arquivo texto"
	// QUERY PARA BLOCO 0
	cQuery := " "
	cQuery += " SELECT "
	cQuery += " TRB.TRB_PAI, SUBSTRING(TRB_RELAC,1,50) RELAC_PAI, SUBSTRING(TRB_RELAC,51,50) RELAC_FILHO, TRB.TRB_TPREG, TRB.R_E_C_N_O_ AS REC ,TRB.* "
	cQuery += " FROM " + cNomeTRB + " TRB " //+ "  (NOLOCK) "
	cQuery += " WHERE SUBSTRING(TRB.TRB_TPREG,1,"+ aStruQry[1] + ") IN " + FormatIn(aStruQry[3],"|") + " "
	cQuery := cQuery + cOrderBy
	cQuery := ChangeQuery(cQuery)
	TcQuery cQuery New Alias &cSQLAlias
	While (cSQLAlias)->(!EOF())
		GravaLinha (nHandle, cAlias, cSQLAlias  )
		(cSQLAlias)->(!dbSkip())
	EndDo
	(cSQLAlias)->(dbCloseArea())
	// FECHO O BLOCO 0
	If (cAlias)->(MsSeek("0990"))
		GravaLinha (nHandle, cAlias  )
	EndIf
	//  -> ABRO O PROXIMO BLOCO A
	If (cAlias)->(MsSeek("A001"))
		GravaLinha (nHandle, cAlias)
			// GERA REGISTROS BLOCO A
	EndIf

		// A010 por empresas
		If (cAlias)->(MsSeek("A010"))

	  		While (cAlias)->(!Eof()) .AND. ((cAlias)->TRB_TPREG=="A010")
				GravaLinha (nHandle, cAlias)
				// - > Query's dos registros do bloco C para o pai posicionado//For nCont:=1 To Len(aStruBlA) // C100/C170 ... C400/C405...
	  				cQuery := " "
					cQuery += " SELECT "
					cQuery += " TRB.TRB_PAI, SUBSTRING(TRB_RELAC,1,50) RELAC_PAI, SUBSTRING(TRB_RELAC,51,50) RELAC_FILHO, TRB.TRB_TPREG, TRB.R_E_C_N_O_ AS REC ,TRB.* "
					cQuery += " FROM " + cNomeTRB + " TRB " //+ "  (NOLOCK) "
					cQuery += " WHERE SUBSTRING(TRB.TRB_TPREG,1,"+ aStruBlA[1] + ") IN " + FormatIn(aStruBlA[3],"|") + " "
					cQuery += " AND TRB.TRB_PAI = " + AllTrim(cValToChar((cAlias)->TRB_PAI)) + " "
					cQuery := cQuery + cOrderBy
					cQuery := ChangeQuery(cQuery)
					TcQuery cQuery New Alias &cSQLAlias
					// Grava Registros
					While (cSQLAlias)->(!EOF())
						GravaLinha (nHandle, cAlias,cSQLAlias  )
						(cSQLAlias)->(!dbSkip())
					EndDo
					(cSQLAlias)->(dbCloseArea())
	  			//Next nCont
	 			(cAlias)->(dbSkip())
	  		EndDo
	  	EndIf
	// < - FECHO O BLOCO A
	If (cAlias)->(MsSeek("A990"))
		GravaLinha (nHandle, cAlias  )
	EndIf
	// - > ABRO O PROXIMO BLOCO C
	If (cAlias)->(MsSeek("C001"))
		GravaLinha (nHandle, cAlias)

		// C010 por empresas
		If (cAlias)->(MsSeek("C010"))

	  		While (cAlias)->(!Eof()) .AND. ((cAlias)->TRB_TPREG=="C010")
	  			GravaLinha (nHandle, cAlias)
				// - > Query's dos registros do bloco C para o pai posicionado
	  			For nCont:=1 To Len(aStruBlC) // C100/C170 ... C400/C405...

	  			    // Monta query
	  				cQuery := " "
					cQuery += " SELECT "
					cQuery += " TRB.TRB_PAI, SUBSTRING(TRB_RELAC,1,50) RELAC_PAI, SUBSTRING(TRB_RELAC,51,50) RELAC_FILHO, TRB.TRB_TPREG, TRB.R_E_C_N_O_ AS REC ,TRB.* "
					cQuery += " FROM " + cNomeTRB + " TRB " //+ "  (NOLOCK) "
					cQuery += " WHERE SUBSTRING(TRB.TRB_TPREG,1,"+ aStruBlC[nCont,1] + ") IN " + FormatIn(aStruBlC[nCont,3],"|") + " "
					cQuery += " AND TRB.TRB_PAI = " + AllTrim(cValToChar((cAlias)->TRB_PAI)) + " "
					cQuery := cQuery + cOrderBy
					cQuery := ChangeQuery(cQuery)
					TcQuery cQuery New Alias &cSQLAlias
					// Grava Registros  ---- descomentar
					While (cSQLAlias)->(!EOF())

						GravaLinha (nHandle, cAlias, cSQLAlias  )

						// Tratamentos especiais pros registros C500 / C600  e seus filhos
						If (cSQLAlias)->TRB_TPREG == "C500"
							RegPorNf (nHandle, cAlias, "C501", (cSQLAlias)->TRB_RELAC)
							RegPorNf (nHandle, cAlias, "C505", (cSQLAlias)->TRB_RELAC)
							RegPorNf (nHandle, cAlias, "C509", (cSQLAlias)->TRB_RELAC)
						ElseIf (cSQLAlias)->TRB_TPREG == "C600"
							RegPorNf (nHandle, cAlias, "C601", (cSQLAlias)->TRB_RELAC, (cSQLAlias)->TRB_ITEM,(cSQLAlias)->TRB_PAI)
							RegPorNf (nHandle, cAlias, "C605", (cSQLAlias)->TRB_RELAC, (cSQLAlias)->TRB_ITEM,(cSQLAlias)->TRB_PAI)
							RegPorNf (nHandle, cAlias, "C609", (cSQLAlias)->TRB_RELAC, (cSQLAlias)->TRB_ITEM,(cSQLAlias)->TRB_PAI)
						EndIf

						(cSQLAlias)->(dbSkip())
					EndDo
					(cSQLAlias)->(dbCloseArea())
	  			Next nCont
	 			(cAlias)->(dbSkip())
	  		EndDo
	  	EndIf
	EndIf
	// < - FECHO O BLOCO C
	If (cAlias)->(MsSeek("C990"))
		GravaLinha (nHandle, cAlias  )
	EndIf
	// - > ABRO O PROXIMO BLOCO D
	If (cAlias)->(MsSeek("D001"))
		GravaLinha (nHandle, cAlias)
	EndIf

		// D010 por empresas
		If (cAlias)->(MsSeek("D010"))

	  		While (cAlias)->(!Eof()) .AND. ((cAlias)->TRB_TPREG=="D010")
	  			GravaLinha (nHandle, cAlias)
				// - > Query's dos registros do bloco C para o pai posicionado
	  			For nCont:=1 To Len(aStruBlD) // C100/C170 ... C400/C405...
	  			    // Monta query
	  				cQuery := " "
					cQuery += " SELECT "
					cQuery += " TRB.TRB_PAI, SUBSTRING(TRB_RELAC,1,50) RELAC_PAI, SUBSTRING(TRB_RELAC,51,50) RELAC_FILHO, TRB.TRB_TPREG, TRB.R_E_C_N_O_ AS REC ,TRB.* "
					cQuery += " FROM " + cNomeTRB + " TRB " //+ "  (NOLOCK) "
					cQuery += " WHERE SUBSTRING(TRB.TRB_TPREG,1,"+ aStruBlD[nCont,1] + ") IN " + FormatIn(aStruBlD[nCont,3],"|") + " "
					cQuery += " AND TRB.TRB_PAI = " + AllTrim(cValToChar((cAlias)->TRB_PAI)) + " "
					cQuery := cQuery + cOrderBy
					cQuery := ChangeQuery(cQuery)
					TcQuery cQuery New Alias &cSQLAlias
					// Grava Registros
					While (cSQLAlias)->(!EOF())
						GravaLinha (nHandle, cAlias, cSQLAlias  )
						(cSQLAlias)->(!dbSkip())
					EndDo
					(cSQLAlias)->(dbCloseArea())
	  			Next nCont
	 			(cAlias)->(dbSkip())
	  		EndDo
	  	EndIf
	// < - FECHO O BLOCO D
	If (cAlias)->(MsSeek("D990"))
		GravaLinha (nHandle, cAlias  )
	EndIf
	// - > ABRO O PROXIMO BLOCO F
	If (cAlias)->(MsSeek("F001"))
		GravaLinha (nHandle, cAlias)
	EndIf

		// F010 por empresas
		If (cAlias)->(MsSeek("F010"))
	  	//GravaLinha (nHandle, cAlias)

	  		While (cAlias)->(!Eof()) .AND. ((cAlias)->TRB_TPREG=="F010")
	  			GravaLinha (nHandle, cAlias)
				// - > Query's dos registros do bloco F para o pai posicionado
				For nCont:=1 To Len(aStruBlF)
	  				cQuery := " "
					cQuery += " SELECT "
					cQuery += " TRB.TRB_PAI, SUBSTRING(TRB_RELAC,1,50) RELAC_PAI, SUBSTRING(TRB_RELAC,51,50) RELAC_FILHO, TRB.TRB_TPREG, TRB.R_E_C_N_O_ AS REC ,TRB.* "
					cQuery += " FROM " + cNomeTRB + " TRB " //+ "  (NOLOCK) "
					cQuery += " WHERE SUBSTRING(TRB.TRB_TPREG,1,"+ aStruBlF[nCont,1] + ") IN " + FormatIn(aStruBlF[nCont,3],"|") + " "
					cQuery += " AND TRB.TRB_PAI = " + AllTrim(cValToChar((cAlias)->TRB_PAI)) + " "
					cQuery := cQuery + cOrderBy
					cQuery := ChangeQuery(cQuery)
					TcQuery cQuery New Alias &cSQLAlias
					// Grava Registros
					While (cSQLAlias)->(!EOF())
						GravaLinha (nHandle, cAlias, cSQLAlias  )

						// Tratamentos especiais para os registros do bloco F
						If (cSQLAlias)->TRB_TPREG == "F100"
							RegPorNf (nHandle, cAlias, "F111", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI)

						ElseIf (cSQLAlias)->TRB_TPREG == "F120"
							RegPorNf (nHandle, cAlias, "F129", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI)

						ElseIf (cSQLAlias)->TRB_TPREG == "F130"
							RegPorNf (nHandle, cAlias, "F139", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI)

						ElseIf (cSQLAlias)->TRB_TPREG == "F200"
							RegPorNf (nHandle, cAlias, "F205", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI)
							RegPorNf (nHandle, cAlias, "F210", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI)

						ElseIf (cSQLAlias)->TRB_TPREG == "F500"
							RegPorNf (nHandle, cAlias, "F509", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI)

						ElseIf (cSQLAlias)->TRB_TPREG == "F510"
							RegPorNf (nHandle, cAlias, "F519", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI)

						ElseIf (cSQLAlias)->TRB_TPREG == "F550"
							RegPorNf (nHandle, cAlias, "F559", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI)

						ElseIf (cSQLAlias)->TRB_TPREG == "F560"
							RegPorNf (nHandle, cAlias, "F569", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI)
						EndIf

							(cSQLAlias)->(dbSkip())
						EndDo
						(cSQLAlias)->(dbCloseArea())
		  		Next nCont
		 		(cAlias)->(dbSkip())
		  	EndDo
		EndIf

	// < - FECHO O BLOCO F
	If (cAlias)->(MsSeek("F990"))
		GravaLinha (nHandle, cAlias  )
	EndIf

	// - > ABRO O PROXIMO BLOCO I
	If (cAlias)->(MsSeek("I001"))
		GravaLinha (nHandle, cAlias)
	EndIf

	// < - FECHO O BLOCO I
	If (cAlias)->(MsSeek("I990"))
		GravaLinha (nHandle, cAlias  )
	EndIf

	// - > ABRO O PROXIMO BLOCO M
	If (cAlias)->(MsSeek("M001"))
		GravaLinha (nHandle, cAlias)
	EndIf

		// So' faz se gerar Bloco M
		If lGrBlocoM

			//For nCont:=1 To Len(aStruBlM) // C100/C170 ... C400/C405...
	  			cQuery := " "
				cQuery += " SELECT "
				cQuery += " TRB.TRB_PAI, SUBSTRING(TRB_RELAC,1,50) RELAC_PAI, SUBSTRING(TRB_RELAC,51,50) RELAC_FILHO, TRB.TRB_TPREG, TRB.R_E_C_N_O_ AS REC ,TRB.* "
				cQuery += " FROM " + cNomeTRB + " TRB " //+ "  (NOLOCK) "
				cQuery += " WHERE SUBSTRING(TRB.TRB_TPREG,1,"+ aStruBlM[1] + ") IN " + FormatIn(aStruBlM[3],"|") + " "
				//cQuery += " AND TRB.TRB_PAI = " + AllTrim(cValToChar((cAlias)->TRB_PAI)) + " "
				cQuery := cQuery + cOrderBy
				cQuery := ChangeQuery(cQuery)
				TcQuery cQuery New Alias &cSQLAlias
				// Grava Registros
				While (cSQLAlias)->(!EOF())
					GravaLinha (nHandle, cAlias, cSQLAlias  )
					(cSQLAlias)->(!dbSkip())
				EndDo

				(cSQLAlias)->(dbCloseArea())
	  		//Next nCont

		Endif
	// < - FECHO O BLOCO M
	If (cAlias)->(MsSeek("M990"))
		GravaLinha (nHandle, cAlias  )
	EndIf

		// - > ABRO O PROXIMO BLOCO P
	If (cAlias)->(MsSeek("P001"))
		GravaLinha (nHandle, cAlias)
	EndIf	

	// So' faz se gerar Bloco P
	If lProcBlcP 
	    	// F010 por empresas
	If (cAlias)->(MsSeek("P010"))
	  	//GravaLinha (nHandle, cAlias) 
  		While (cAlias)->(!Eof()) .AND. ((cAlias)->TRB_TPREG=="P010")
  			GravaLinha (nHandle, cAlias)
	     
   		For nContP:=1 To Len(aStruBlP)
	 		cQuery := " "
			cQuery += " SELECT "          
			cQuery += " TRB.TRB_PAI, SUBSTRING(TRB_RELAC,1,50) RELAC_PAI, SUBSTRING(TRB_RELAC,51,50) RELAC_FILHO, TRB.TRB_TPREG, TRB.R_E_C_N_O_ AS REC ,TRB.* "
			cQuery += " FROM " + cNomeTRB + " TRB " //+ "  (NOLOCK) " 
			cQuery += " WHERE SUBSTRING(TRB.TRB_TPREG,1,"+ aStruBlP[nContP,1] + ") IN " + FormatIn(aStruBlP[nContP,3],"|") + " "
			cQuery += " AND TRB.TRB_PAI = " + AllTrim(cValToChar((cAlias)->TRB_PAI)) + " "
			cQuery := cQuery + cOrderBy         
			cQuery := ChangeQuery(cQuery)                              
			TcQuery cQuery New Alias &cAliasBP            
			// Grava Registros 
			While (cAliasBP)->(!EOF())
				If (cAliasBP)->TRB_TPREG $ "P100" .And. (cAlias)->TRB_RELAC == (cAliasBP)->TRB_RELAC  
					GravaLinha (nHandle, cAlias, cAliasBP)					 
				EndIf
			(cAliasBP)->(!dbSkip())
			EndDo 
			(cAliasBP)->(dbCloseArea()) 
		 Next nContP 
 		(cAlias)->(dbSkip())
	  	EndDo		   		                       
	EndIf
	EndIf                     
	cChave	:=	"P200"+(cAlias)->TRB_RELAC
	If ((cAlias)->(MsSeek (cChave)))
		Do While !(cAlias)->(Eof ()) .And. cChave==(cAlias)->TRB_TPREG+(cAlias)->TRB_RELAC
			GravaLinha (nHandle, cAlias)
			RegPorNf (nHandle, cAlias, "P210", cRelac, (cAlias)->TRB_ITEM)
			(cAlias)->(DbSkip ())
		EndDo
	EndIf                   

	// < - FECHO O BLOCO P
	If (cAlias)->(MsSeek("P990"))
		GravaLinha (nHandle, cAlias)
	EndIf


	// BLOCO 1 / 8 / 9
	cQuery := " "
	cQuery += " SELECT "
	cQuery += " TRB.TRB_PAI, SUBSTRING(TRB_RELAC,1,50) RELAC_PAI, SUBSTRING(TRB_RELAC,51,50) RELAC_FILHO, TRB.TRB_TPREG, TRB.R_E_C_N_O_ AS REC ,TRB.* "
	cQuery += " FROM " + cNomeTRB + " TRB " //+ "  (NOLOCK) "
	cQuery += " WHERE SUBSTRING(TRB.TRB_TPREG,1,4) LIKE('1%') OR SUBSTRING(TRB.TRB_TPREG,1,4) LIKE('8%') OR SUBSTRING(TRB.TRB_TPREG,1,4) LIKE('9%') "
	cQuery := cQuery + cOrderBy
	cQuery := ChangeQuery(cQuery)
	TcQuery cQuery New Alias &cSQLAlias
	// Grava no TXT
	While (cSQLAlias)->(!EOF())
		GravaLinha (nHandle, cAlias, cSQLAlias  )
		(cSQLAlias)->(!dbSkip())
	EndDo
	(cSQLAlias)->(dbCloseArea())


Else // Normal - Processo sem MT

	DbSelectArea (cAlias)
	(cAlias)->(DbSetOrder (1))
	ProcRegua ((cAlias)->(RecCount ()))
	(cAlias)->(DbGoTop ())
	//
	IncProc(STR0065)	//"Gerando arquivo texto"

	Do While !(cAlias)->(Eof ())



		If (Empty ((cAlias)->TRB_FLAG))
				//
			cRelac	:=	(cAlias)->TRB_RELAC
			aArea	:=	(cAlias)->(GetArea ())
			//

			If ("0140"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias) //Grava A010
				nPai := (cAlias)->TRB_PAI

				If ((cAlias)->(MsSeek ("0145")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "0145"
						If nPai==(cAlias)->TRB_PAI .And. Empty((cAlias)->TRB_FLAG)
							GravaLinha (nHandle, cAlias) //grava 0145
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIf

			 	If ((cAlias)->(MsSeek ("0150")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "0150"
						If nPai==(cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias) //grava 0150
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF

				If ((cAlias)->(MsSeek ("0190")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "0190"
						If nPai==(cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias) //grava 0190
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF

				If ((cAlias)->(MsSeek ("0200")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "0200"
						If nPai==(cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias) //grava 0200
							cItem := cvaltochar((cAlias)->TRB_ITEM)

							RegPorNf (nHandle, cAlias, "0205", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI)
							aAreaAux:=	(cAlias)->(GetArea ())
							If ((cAlias)->(MsSeek ("0206")))
								Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "0206"
							   	     IF Alltrim((cAlias)->TRB_CHVPAI) == "0200"+cItem .AND. nPai==(cAlias)->TRB_PAI
							   	     	GravaLinha (nHandle, cAlias) //grava 0206
							   	     EndIF
							   		(cAlias)->(DbSkip ())
								EndDo
							EndIF
							RestArea (aAreaAux)

							aAreaAux:=	(cAlias)->(GetArea ())
							If ((cAlias)->(MsSeek ("0208")))
								Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "0208"
							   	     IF Alltrim((cAlias)->TRB_CHVPAI) == "0200"+cItem .AND. nPai==(cAlias)->TRB_PAI
							   	     	GravaLinha (nHandle, cAlias) //grava 0208
							   	     EndIF
							   		(cAlias)->(DbSkip ())
								EndDo
							EndIF
							RestArea (aAreaAux)

						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF

				If ((cAlias)->(MsSeek ("0400")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "0400"
						If nPai==(cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias) //grava 0400
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF

				If ((cAlias)->(MsSeek ("0450")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "0450"
						If nPai==(cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias) //grava 0450
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF

			ElseIf ("A010"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias) //Grava A010
				nPai := (cAlias)->TRB_PAI

			 	If ((cAlias)->(MsSeek ("A100")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "A100"
						If nPai==(cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias) //grava A100
							RegPorNf (nHandle, cAlias, "A110", (cAlias)->TRB_RELAC)
							RegPorNf (nHandle, cAlias, "A111", (cAlias)->TRB_RELAC)
							RegPorNf (nHandle, cAlias, "A120", (cAlias)->TRB_RELAC)
							RegPorNf (nHandle, cAlias, "A170", (cAlias)->TRB_RELAC)
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF



			ElseIf ("C010"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias) //Grava C010
				nPai := (cAlias)->TRB_PAI

				If ((cAlias)->(MsSeek ("C100")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "C100"
						If nPai==(cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias) //grava c100
							RegPorNf (nHandle, cAlias, "C110", (cAlias)->TRB_RELAC)
							RegPorNf (nHandle, cAlias, "C111", (cAlias)->TRB_RELAC)
							RegPorNf (nHandle, cAlias, "C120", (cAlias)->TRB_RELAC)
							RegPorNf (nHandle, cAlias, "C170", (cAlias)->TRB_RELAC)
							RegPorNf (nHandle, cAlias, "C175", (cAlias)->TRB_RELAC,,(cAlias)->TRB_PAI)
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF


				If ((cAlias)->(MsSeek ("C180")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "C180"
						If nPai == (cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias)
							RegPorNf (nHandle, cAlias, "C181", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI)
							RegPorNf (nHandle, cAlias, "C185", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI )
							RegPorNf (nHandle, cAlias, "C188", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI )
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF

				If ((cAlias)->(MsSeek ("C190")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "C190"
						If nPai == (cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias)
							RegPorNf (nHandle, cAlias, "C191", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI)
							RegPorNf (nHandle, cAlias, "C195", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI )
							RegPorNf (nHandle, cAlias, "C198", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI )
							RegPorNf (nHandle, cAlias, "C199", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI )
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF


				If ((cAlias)->(MsSeek ("C380")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "C380"
						If nPai==(cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias) //grava c380
							RegPorNf (nHandle, cAlias, "C381", (cAlias)->TRB_RELAC,,(cAlias)->TRB_PAI)
							RegPorNf (nHandle, cAlias, "C385", (cAlias)->TRB_RELAC,,(cAlias)->TRB_PAI)
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF

				If ((cAlias)->(MsSeek ("C395")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "C395"
						If nPai==(cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias)
							RegPorNf (nHandle, cAlias, "C396", (cAlias)->TRB_RELAC)
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF

				cChaveC400	:=	""
				If ((cAlias)->(MsSeek ("C400")))

					Do While !(cAlias)->(Eof ())  //.And. cChaveC400 <> TRB_CONT

						If (cAlias)->TRB_TPREG == "C400"  .AND. (Empty((cAlias)->TRB_FLAG))

						    aAreaAux := TRB->(GetArea())

							cChaveC400	:=	TRB_CONT
							If nPai == (cAlias)->TRB_PAI
 								GravaLinha (nHandle, cAlias)

								cChave	:=	"C405"+SubSTR(AllTrim((cAlias)->TRB_RELAC),1,nTamTRBIt)

								If ((cAlias)->(MsSeek (cChave)))
									Do While !(cAlias)->(Eof ()) .And. cChave==(cAlias)->TRB_TPREG+SubSTR(AllTrim((cAlias)->TRB_RELAC),1,nTamTRBIt)
										If nPai == (cAlias)->TRB_PAI
											GravaLinha (nHandle, cAlias)

									 		RegPorNf (nHandle, cAlias, "C481", (cAlias)->TRB_RELAC, ,(cAlias)->TRB_PAI)
											RegPorNf (nHandle, cAlias, "C485", (cAlias)->TRB_RELAC, ,(cAlias)->TRB_PAI )
											RegPorNf (nHandle, cAlias, "C489", (cAlias)->TRB_RELAC, ,(cAlias)->TRB_PAI )

									 	EndIf
									 	(cAlias)->(DbSkip())
									EndDo
								EndIf

							EndIf

							TRB->(RestArea(aAreaAux))
						EndIf
						(cAlias)->(DbSkip())
					EndDo
				EndIf

				If ((cAlias)->(MsSeek ("C490")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "C490"
						If nPai == (cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias)
							RegPorNf (nHandle, cAlias, "C491", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI)
							RegPorNf (nHandle, cAlias, "C495", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI )
							RegPorNf (nHandle, cAlias, "C499", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI )
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF

				If ((cAlias)->(MsSeek ("C500")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "C500"
						If nPai==(cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias)
							RegPorNf (nHandle, cAlias, "C501", (cAlias)->TRB_RELAC)
							RegPorNf (nHandle, cAlias, "C505", (cAlias)->TRB_RELAC)
							RegPorNf (nHandle, cAlias, "C509", (cAlias)->TRB_RELAC)
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF

				If ((cAlias)->(MsSeek ("C600")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "C600"
						If nPai == (cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias)
							RegPorNf (nHandle, cAlias, "C601", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI)
							RegPorNf (nHandle, cAlias, "C605", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI )
							RegPorNf (nHandle, cAlias, "C609", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI )
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF

			ElseIf ("D010"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias) //Grava D010
				nPai := (cAlias)->TRB_PAI

			 	If ((cAlias)->(MsSeek ("D100")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "D100"
						If nPai==(cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias) //grava D100
							RegPorNf (nHandle, cAlias, "D101", (cAlias)->TRB_RELAC,,(cAlias)->TRB_PAI)
							RegPorNf (nHandle, cAlias, "D105", (cAlias)->TRB_RELAC,,(cAlias)->TRB_PAI)
							RegPorNf (nHandle, cAlias, "D111", (cAlias)->TRB_RELAC,,(cAlias)->TRB_PAI)
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF

				If ((cAlias)->(MsSeek ("D200")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "D200"
						If nPai == (cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias)
							RegPorNf (nHandle, cAlias, "D201", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI)
							RegPorNf (nHandle, cAlias, "D205", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI )
							RegPorNf (nHandle, cAlias, "D209", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI )
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF

				If ((cAlias)->(MsSeek ("D300")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "D300"
						If nPai==(cAlias)->TRB_PAI
					    	GravaLinha (nHandle, cAlias)
							RegPorNf (nHandle, cAlias, "D309", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI)
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF

				If ((cAlias)->(MsSeek ("D350")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "D350"
						If nPai==(cAlias)->TRB_PAI
					    	GravaLinha (nHandle, cAlias)
							RegPorNf (nHandle, cAlias, "D359", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI)
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF

				If ((cAlias)->(MsSeek ("D500")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "D500"
						If nPai==(cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias) //grava D100
							RegPorNf (nHandle, cAlias, "D501", (cAlias)->TRB_RELAC,,(cAlias)->TRB_PAI)
							RegPorNf (nHandle, cAlias, "D505", (cAlias)->TRB_RELAC,,(cAlias)->TRB_PAI)
							RegPorNf (nHandle, cAlias, "D509", (cAlias)->TRB_RELAC,,(cAlias)->TRB_PAI)
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF

				If ((cAlias)->(MsSeek ("D600")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "D600"
						If nPai==(cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias)
							RegPorNf (nHandle, cAlias, "D601", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI)
							RegPorNf (nHandle, cAlias, "D605", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI )
							RegPorNf (nHandle, cAlias, "D609", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI )
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF


			ElseIf ("F010"$(cAlias)->TRB_TPREG)
				
				
				
				GravaLinha (nHandle, cAlias) //Grava F010
				nPai := (cAlias)->TRB_PAI

			 	If ((cAlias)->(MsSeek ("F100")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "F100"
						If nPai==(cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias) //grava F100
							RegPorNf (nHandle, cAlias, "F111", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI)
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF

				If ((cAlias)->(MsSeek ("F120")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "F120"
						If nPai==(cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias) //grava F120
							RegPorNf (nHandle, cAlias, "F129", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI)
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF
				If ((cAlias)->(MsSeek ("F130")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "F130"
						If nPai==(cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias) //grava F130
							RegPorNf (nHandle, cAlias, "F139", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI)
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF

				If ((cAlias)->(MsSeek ("F150")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "F150"
						If nPai==(cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias) //grava F150
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF

				If ((cAlias)->(MsSeek ("F200")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "F200"
						If nPai==(cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias) //grava F130
							RegPorNf (nHandle, cAlias, "F205", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI)
							RegPorNf (nHandle, cAlias, "F210", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI)
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF


				If ((cAlias)->(MsSeek ("F500")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "F500"
						If nPai==(cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias) //grava F500
							RegPorNf (nHandle, cAlias, "F509", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI)
						EndIF

						(cAlias)->(DbSkip ())
					EndDo
				EndIF


				If ((cAlias)->(MsSeek ("F510")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "F510"
						If nPai==(cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias) //grava F510
							RegPorNf (nHandle, cAlias, "F519", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI)
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF

				If ((cAlias)->(MsSeek ("F525")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "F525"
						If nPai==(cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias) //grava F525
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF

				If ((cAlias)->(MsSeek ("F550")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "F550"
						If nPai==(cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias) //grava F550
							RegPorNf (nHandle, cAlias, "F559", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI)
						EndIF

						(cAlias)->(DbSkip ())
					EndDo
				EndIF


				If ((cAlias)->(MsSeek ("F560")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "F560"
						If nPai==(cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias) //grava F510
							RegPorNf (nHandle, cAlias, "F569", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI)
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF

				If ((cAlias)->(MsSeek ("F600")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "F600"
						If nPai==(cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias) //grava F600
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF

				If ((cAlias)->(MsSeek ("F700")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "F700"
						If nPai==(cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias) //grava F700
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF

			ElseIf ("I010"$(cAlias)->TRB_TPREG)
				aArea3	:=	(cAlias)->(GetArea())
				SPEDGrvLin(nHandle,cAlias)

				SPEDLeRegs(nHandle,cAlias,{"I100","I199",{"I200",1},"I299",{"I300",3},"I399"},(cAlias)->TRB_RELAC)

				RestArea(aArea3)
				If ((cAlias)->(MsSeek ("I100")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "I100"
						If nPai==(cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias) //grava I100
							RegPorNf (nHandle, cAlias, "I200", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI)
							RegPorNf (nHandle, cAlias, "I300", (cAlias)->TRB_RELAC, (cAlias)->TRB_ITEM,(cAlias)->TRB_PAI)
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF
			ElseIf ("M100"$(cAlias)->TRB_TPREG)
				cChave	:=	"M100"+cRelac
				If ((cAlias)->(MsSeek (cChave)))
					Do While !(cAlias)->(Eof ()) .And. cChave==(cAlias)->TRB_TPREG+(cAlias)->TRB_RELAC
						GravaLinha (nHandle, cAlias)
						RegPorNf (nHandle, cAlias, "M105", cRelac, (cAlias)->TRB_ITEM)
						RegPorNf (nHandle, cAlias, "M110", cRelac, (cAlias)->TRB_ITEM)
						(cAlias)->(DbSkip ())
					EndDo
				EndIf

			ElseIf ("M400"$(cAlias)->TRB_TPREG)
				cChave	:=	"M400"+cRelac
				If ((cAlias)->(MsSeek (cChave)))
					Do While !(cAlias)->(Eof ()) .And. cChave==(cAlias)->TRB_TPREG+(cAlias)->TRB_RELAC
						GravaLinha (nHandle, cAlias)
						RegPorNf (nHandle, cAlias, "M410", cRelac, (cAlias)->TRB_ITEM)
						//
						(cAlias)->(DbSkip ())
					EndDo
				EndIf

			ElseIf ("M500"$(cAlias)->TRB_TPREG)
				cChave	:=	"M500"+cRelac
				If ((cAlias)->(MsSeek (cChave)))
					Do While !(cAlias)->(Eof ()) .And. cChave==(cAlias)->TRB_TPREG+(cAlias)->TRB_RELAC
						GravaLinha (nHandle, cAlias)
						RegPorNf (nHandle, cAlias, "M505", cRelac, (cAlias)->TRB_ITEM)
						RegPorNf (nHandle, cAlias, "M510", cRelac, (cAlias)->TRB_ITEM)
						(cAlias)->(DbSkip ())
					EndDo
				EndIf

			ElseIf ("M200"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias)

			ElseIf ("M210"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias)
				RegPorNf (nHandle, cAlias, "M211", cRelac)
				RegPorNf (nHandle, cAlias, "M220", cRelac)
				RegPorNf (nHandle, cAlias, "M230", cRelac)

			ElseIf ("M300"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias)

			ElseIf ("M350"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias)

			ElseIf ("M600"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias)

			ElseIf ("M610"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias)
				RegPorNf (nHandle, cAlias, "M611", cRelac)
				RegPorNf (nHandle, cAlias, "M620", cRelac)
				RegPorNf (nHandle, cAlias, "M630", cRelac)

			ElseIf ("M700"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias)

			ElseIf ("M800"$(cAlias)->TRB_TPREG)
				cChave	:=	"M800"+cRelac
				If ((cAlias)->(MsSeek (cChave)))
					Do While !(cAlias)->(Eof ()) .And. cChave==(cAlias)->TRB_TPREG+(cAlias)->TRB_RELAC
						GravaLinha (nHandle, cAlias)
						RegPorNf (nHandle, cAlias, "M810", cRelac, (cAlias)->TRB_ITEM)
						//
						(cAlias)->(DbSkip ())
					EndDo
				EndIf

			ElseIf ("P010"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias) //Grava P010
				nPai := (cAlias)->TRB_PAI

			 	If ((cAlias)->(MsSeek ("P100")))
					Do While !(cAlias)->(Eof ()) .AND. (cAlias)->TRB_TPREG == "P100"
						If nPai==(cAlias)->TRB_PAI
							GravaLinha (nHandle, cAlias) //grava P100
						EndIF
						(cAlias)->(DbSkip ())
					EndDo
				EndIF
//			ElseIf ("P200"$(cAlias)->TRB_TPREG)
//				GravaLinha (nHandle, cAlias)
			ElseIf ("P200"$(cAlias)->TRB_TPREG)
				cChave	:=	"P200"+cRelac
				If ((cAlias)->(MsSeek (cChave)))
					Do While !(cAlias)->(Eof ()) .And. cChave==(cAlias)->TRB_TPREG+(cAlias)->TRB_RELAC
						GravaLinha (nHandle, cAlias)
						RegPorNf (nHandle, cAlias, "P210", cRelac, (cAlias)->TRB_ITEM)
						(cAlias)->(DbSkip ())
					EndDo
				EndIf
			ElseIf ( "1" $ Substr((cAlias)->TRB_TPREG,1,1))
				lGravaReg1 := .T.

			ElseIf ( "9" $ Substr((cAlias)->TRB_TPREG,1,1))
				lGravaReg9 := .T.
			Else
				GravaLinha (nHandle, cAlias)

			EndIf
			RestArea (aArea)
		EndIf
		//
		(cAlias)->(DbSkip ())
	EndDo

	If lGravaReg1
		If (Empty ((cAlias)->TRB_FLAG))
			(cAlias)->(MsSeek("1"))
			Do While !(cAlias)->(Eof ()) .And. Substr((cAlias)->TRB_TPREG,1,1) == "1"
	        	If (Empty ((cAlias)->TRB_FLAG))
		        	If ("1100"$(cAlias)->TRB_TPREG)
						aArea3 := (cAlias)->(GetArea())
						SPEDGrvLin(nHandle,cAlias)
						SPEDLeRegs(nHandle,cAlias,{"1101","1102"},(cAlias)->TRB_RELAC)
						RestArea(aArea3)
			       	ElseIf ("1500"$(cAlias)->TRB_TPREG)
						aArea3 := (cAlias)->(GetArea())
						SPEDGrvLin(nHandle,cAlias)
						SPEDLeRegs(nHandle,cAlias,{"1501","1502"},(cAlias)->TRB_RELAC)
						RestArea(aArea3)
					Else
						GravaLinha (nHandle, cAlias)
		            EndIf
		    	EndIf
			(cAlias)->(DbSkip ())
			EndDo
		EndIf
	EndIf

	If lGravaReg8
		(cAlias)->(MsSeek("8"))
		Do While !(cAlias)->(Eof ()) .And. Substr((cAlias)->TRB_TPREG,1,1) == "8"
			GravaLinha (nHandle, cAlias)
			(cAlias)->(DbSkip ())
		EndDo
	EndIf
	If lGravaReg9
		(cAlias)->(MsSeek("9"))
		Do While !(cAlias)->(Eof ()) .And. Substr((cAlias)->TRB_TPREG,1,1) == "9"
			GravaLinha (nHandle, cAlias)
			(cAlias)->(DbSkip ())
		EndDo
	EndIf

EndIf

If (nHandle>=0)
	FClose (nHandle)
Endif
If (File(cFile))
	FErase (cFile)
Endif

SplitPath(cFile,@cDrive,@cPath, @cNewFile,@cExt)
cNewFile	:=	cNewFile+cExt

If Empty(cDrive)
	lCopied := __CopyFile(cTrab,cDrive+cPath+cNewFile)
Else
	If Substr(cStartPath,Len(AllTrim(cStartPath)),1) <> "\"
		cStartPath := cStartPath + "\"
	EndIf
	lCopied := CpyS2T(cStartPath+cTrab,cDrive+cPath, .F. )
EndIf

If lCopied
	FErase (cTrab)
	If File(cDrive+cPath+cTrab)
		FRename(cDrive+cPath+cTrab,cFile)
	EndIf
EndIf
Return (lRet)

Static Function GravaLinha (nHandle, cAlias,cQryAlias)

	Local	cConteudo := ""
	Default cQryAlias := cAlias

	cConteudo := AllTrim ((cQryAlias)->TRB_CONT)+Chr (13)+Chr (10)	//+"**"+(cAlias)->TRB_RELAC+"**"

	//
	FWrite (nHandle, cConteudo, Len (cConteudo))
	//
	If !lProcMThr
		RecLock (cQryAlias, .F.)
			(cAlias)->TRB_FLAG	:=	"*"
		MsUnLock ()
	EndIf

Return

Static Function RegPorNf (nHandle, cAlias, cTpReg, cRelac, xItem, nPai)
	Local	lRet		:=	.T.
	Local	cChave		:=	cTpReg+cRelac
	Local	aAreaLoc	:=	(cAlias)->(GetArea ())
	Local 	lcItem		:= .F.
	DEFAULT nPai 		:= 0

	//
	If lProcMThr
		If xItem==NIL
			xItem:=""
		Endif
		If Len(xItem)>0
			lcItem	:= .T.
			cChave	+=	xItem //StrZero (nItem, 7, 0)
		EndIf
	Else
		If (xItem<>Nil .And. xItem>0)
			cChave	+=	StrZero (xItem, 7, 0)
		EndIf
	EndIf

	//
	If ((cAlias)->(MsSeek (cChave)))
		Do While !(cAlias)->(Eof ()) .And. cChave==(cAlias)->TRB_TPREG+(cAlias)->TRB_RELAC+Iif ( (xItem<>Nil .AND. Valtype(xItem)=="N" .AND. xItem>0 ), StrZero ((cAlias)->TRB_ITEM, 7, 0),"")
			If nPai == (cAlias)->TRB_PAI
				GravaLinha (nHandle, cAlias)
			EndIF
			//
			(cAlias)->(DbSkip ())
		EndDo
	EndIf
	//
	RestArea (aAreaLoc)
Return (lRet)

/*±±ºPrograma  RegC010   ºAutor  Erick G. Dias        º Data   18/01/11 º±±*/
Static Function RegC010(cAlias,aRegC010,nPaiC, lGravaC010,IndAprop,lZerVar)

Local nPos := 0

Default	lZerVar	:=	.F.

If aScan (aRegC010, {|aX| AllTrim(aX[2])==AllTrim(SM0->M0_CGC)}) == 0
	aAdd(aRegC010, {})
	nPos	:=	Len (aRegC010)
	aAdd (aRegC010[nPos],"C010") //01-REG
	aAdd (aRegC010[nPos], AllTrim(SM0->M0_CGC)) //02-CNPJ
	//Tratamento de registro consolidado ou individualizado
	If "1" $ IndAprop
		aAdd (aRegC010[nPos], "1") 	      //03-IND_ESCRI
	ElseIf "2" $ IndAprop
		aAdd (aRegC010[nPos], "2") 	      //03-IND_ESCRI
	Else
		aAdd (aRegC010[nPos], "") 	      //03-IND_ESCRI
	EndIf
	If !lZerVar
		nPaiC += 1
	EndIf
	lGravaC010:=.T.
EndIf

Return


Static Function RegC100 (cEntSai, aPartDoc, cEspecie, cAlias, nRelac, aCmpAntSFT, aTotaliza, aRegC100, cChave, cSituaDoc, lAchouSE4, cOpSemF, lAchouSF4, lGrava0150, cChvNfe, cIndEmit, nPaiC, lPisZero, lCofZero,c1Dupref,c2Dupref,aRegc175)

Local	nPos		:=	0
Local	lRet		:=	.T.
Local	nx			:=	0
Local 	cTipoTit	:=	aParSX6[33]
Local	aParc1		:=	{}
Local	ny			:=	0
Local 	clPrefix	:= ""
Local nTamSE1 := 0
Local nTamSE2 := 0
Local lNFCE		:= IIf(cEspecie=="65",.T.,.F.)

If cEntSai=="1"

	nTamSE2 := TamSx3("E2_PREFIXO")[1]

	If !Empty(Alltrim(c2Dupref))
		clPrefix := PadR(aCmpAntSFT[24], nTamSE2)
	Else
		clPrefix := PadR(aCmpAntSFT[28], nTamSE2)
	Endif

	SE2->(DbSetOrder (6))
	SE2->(MsSeek (xFilial("SE2")+aCmpAntSFT[3]+aCmpAntSFT[4]+clPrefix+aCmpAntSFT[1]))
	Do While (!SE2->(Eof ()) .And.;
		xFilial("SE2")==SE2->E2_FILIAL .And.;
		aCmpAntSFT[3]==SE2->E2_FORNECE .And.;
		aCmpAntSFT[4]==SE2->E2_LOJA .And.;
		clPrefix==SE2->E2_PREFIXO .And.;
		aCmpAntSFT[1]==SE2->E2_NUM )

   		If !(AllTrim (SE2->E2_TIPO)$MVTAXA+"|"+MVTXA+"|"+MVABATIM+"|"+cTipoTit) .And. (Substr(SE2->E2_TIPO,1,2) <> "NC")
		   nY += 1
		   aAdd (aParc1, {SE2->E2_TIPO, SE2->E2_HIST, SE2->E2_NUM, SE2->E2_PARCELA, SE2->E2_VENCREA, SE2->E2_VLCRUZ})
		EndIf

		SE2->(DbSkip())
	EndDo

ElseIf cEntSai=="2"

	nTamSE1 := TamSx3("E1_PREFIXO")[1]

	If !Empty(Alltrim(c1Dupref))
		clPrefix := PadR(aCmpAntSFT[24], nTamSE1)
	Else
		clPrefix := PadR(aCmpAntSFT[28], nTamSE1)
	Endif

	SE1->(DbSetOrder (2))
	SE1->(MsSeek (xFilial("SE1")+aCmpAntSFT[3]+aCmpAntSFT[4]+clPrefix+aCmpAntSFT[1]))
	Do While (!SE1->(Eof ()) .And.;
		xFilial("SE1")==SE1->E1_FILIAL .And.;
		aCmpAntSFT[3]==SE1->E1_CLIENTE .And.;
		aCmpAntSFT[4]==SE1->E1_LOJA .And.;
		clPrefix==SE1->E1_PREFIXO .And.;
		aCmpAntSFT[1]==SE1->E1_NUM )

		If !(AllTrim (SE1->E1_TIPO)$MVTAXA+"|"+MVTXA+"|"+MVABATIM+"|"+cTipoTit) .And. (Substr(SE1->E1_TIPO,1,2) <> "NC")
			nY += 1
			aAdd (aParc1, {SE1->E1_TIPO, SE1->E1_HIST, SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_VENCREA, SE1->E1_VLCRUZ})
		EndIf

		SE1->(DbSkip ())
	EndDo

EndIf

aAdd(aRegC100, {})
nPos	:=	Len (aRegC100)
aAdd (aRegC100[nPos], "C100")					   		//01 - REG
aAdd (aRegC100[nPos], STR(Val (cEntSai)-1,1)) 			//02 - IND_OPER
aAdd (aRegC100[nPos], cIndEmit)							//03 - IND_EMIT
aAdd (aRegC100[nPos], IIf(cSituaDoc$"02#04#05","", aPartDoc[1]))	//04 - COD_PART
aAdd (aRegC100[nPos], cEspecie)  				 		//05 - COD_MOD
aAdd (aRegC100[nPos], cSituaDoc)				  		//06 - COD_SIT
aAdd (aRegC100[nPos], aCmpAntSFT[2])  			  	 	//07 - SER
aAdd (aRegC100[nPos], aCmpAntSFT[1])  			   		//08 - NUM_DOC

If !cSituaDoc$"05"
	aAdd (aRegC100[nPos], cChvNfe) 		//09 - CHV_NFE
Else
	aAdd (aRegC100[nPos], "")	 		//09 - CHV_NFE
EndIf

If cSituaDoc$"02#04#05"
	For nx := 10 to 29
		aAdd (aRegC100[nPos], "") 						//10 - N INFORMAR PARA DOC CANCELADO
	Next
Else
	aAdd (aRegC100[nPos], aCmpAntSFT[6])		   		//10 - DT_DOC
	//Ponto de entrada para os campo DT_E_S
	If aExstBlck[16]
	  	cSpdpis08 := ExecBlock("SPDPIS08", .F., .F., {"SFT", cChave})
	  	aAdd (aRegC100[nPos],cSpdpis08)
	Else
		aAdd (aRegC100[nPos], aCmpAntSFT[5])		   		//11 - DT_E_S
	Endif
	aAdd (aRegC100[nPos], aTotaliza[1])					//12 - VL_DOC
	//
	//Verifica a condicao de pagamento da NF

	SE1->(DbSetOrder (2))
	SE1->(MsSeek (xFilial("SE1")+aCmpAntSFT[3]+aCmpAntSFT[4]+clPrefix+aCmpAntSFT[1]))
	SE2->(DbSetOrder (6))
	SE2->(MsSeek (xFilial("SE2")+aCmpAntSFT[3]+aCmpAntSFT[4]+clPrefix+aCmpAntSFT[1]))

	If nY==0
		aAdd (aRegC100[nPos], Iif(dDataDe >= CTOD("01/07/2012"),"2","9")) ////13 - IND_PAGTO - SEM PAGAMENTO
	Elseif Len(aParc1)  > 1
		aAdd (aRegC100[nPos], "1")	  			  	//13 - IND_PAGTO - A VISTA
	Elseif Len(aParc1)  == 1 .And. aCmpAntSFT[06] == SE1->E1_VENCTO
		aAdd (aRegC100[nPos], "0")	  			  	//13 - IND_PAGTO - A VISTA
	Elseif Len(aParc1)  == 1 .And. aCmpAntSFT[06] == SE2->E2_VENCTO
		aAdd (aRegC100[nPos], "0")
	Else
		aAdd (aRegC100[nPos], "1")	  			  	//13 - IND_PAGTO - A PRAZO - campo © obrigatorio e nao pode ser levado em branco
	Endif

	aAdd (aRegC100[nPos], aTotaliza[9])					//14 - VL_DESC
	aAdd (aRegC100[nPos], aTotaliza[32]+aTotaliza[33])	//15 - VL_ABAT_NT
	aAdd (aRegC100[nPos], aTotaliza[10])				//16 - VL_MERC
 	aAdd (aRegC100[nPos], aCmpAntSFT[21])				//17 - IND_FRT
	aAdd (aRegC100[nPos], aTotaliza[11])				//18 - VL_FRT		-	FT_FRETE
	aAdd (aRegC100[nPos], aTotaliza[12])				//19 - VL_SEG		-	FT_SEGURO
	aAdd (aRegC100[nPos], aTotaliza[13])				//20 - VL_OUT_DA	-	FT_DESPESA
	aAdd (aRegC100[nPos], aTotaliza[2])					//21 - VL_BC_ICMS	-	FT_BASEICM
	aAdd (aRegC100[nPos], aTotaliza[3])					//22 - VL_ICMS		-	FT_VALICM
	aAdd (aRegC100[nPos], aTotaliza[4])					//23 - VL_BC_ICMS_ST-	FT_BASERET
	aAdd (aRegC100[nPos], aTotaliza[5])					//24 - VL_ICMS_ST	-	FT_ICMSRET
	aAdd (aRegC100[nPos], aTotaliza[6]) 				//25 - VL_IPI		-	FT_VALIPI
	aAdd (aRegC100[nPos], aTotaliza[19])				//26 - VL_PIS		-	FT_VALPIS
	aAdd (aRegC100[nPos], aTotaliza[20])				//27 - VL_COFINS	-	FT_VALCOF
	aAdd (aRegC100[nPos], aTotaliza[28]) 				//28 - VL_PIS_ST	-	FT_VALPS3
	aAdd (aRegC100[nPos], aTotaliza[29]) 				//29 - VL_COF_ST	-	FT_VALCF3
EndIf

If aExstBlck[15]
   	aSpedc100 := ExecBlock("SPDPIS05", .F., .F., {"SFT",aCmpAntSFT,aRegC100})
	aRegC100[nPos][13] := aSpedc100[01]
	aRegC100[nPos][17] := aSpedc100[02]
Endif
//
If (cEspecie$"01#04#55#1B#65")
	PCGrvReg (cAlias, nRelac, aRegC100,,,nPaiC,,,nTamTRBIt)
	PCGrvReg (cAlias, nRelac, aRegC175,,,nPaiC,,,nTamTRBIt)
	lGrava0150 := !(cSituaDoc$"02#04#05")
EndIf

Return (lRet)


Static Function RegC110 (cAlias,nRelac,cCodInf,aRegC110, nPosC110, aPEC110,aCmpAntSFT,nMVSPDIFC,lCmpDscComp,cInfCDTDC)
	Local	lRet		:=	.T.
	Local	cDesc		:=	""
	Local	lSeekCCE	:= .F.

	Default	cCodInf		:=	""
	Default	cInfCDTDC	:= ""
	Default	aPEC110		:=	{}
	Default	aCmpAntSFT 	:= {}
	Default	nMVSPDIFC  	:= 0
	Default	lCmpDscComp	:= .F.

	//

	//----------------------------------
	//Composicao do Campo 03 - TXT_COMPL
	//----------------------------------
	lSeekCCE	:=	CCE->(MsSeek(xFilial("CCE")+cCodInf))

	Do Case
		//Ponto de entrada
		Case Len(aPEC110) > 0
			cDesc	 :=	aPEC110[2]
			cCodInf :=	aPEC110[1]
		//Descricao similar a do registro 0450
		Case nMVSPDIFC == 0 .And. lSeekCCE
			cDesc   :=	CCE->CCE_DESCR
		//Verifica Descricao Complementar a partir da tabela CDT (CDT_DCCOMP)
		Case nMVSPDIFC == 1 .And. lCmpDscComp .And. !Empty(cInfCDTDC)
			cDesc	:=	cInfCDTDC

		//Verifica Descricao Complementar a partir da tabela CDC (CDC_DCCOMP)
		Case nMVSPDIFC == 1 .And. !Empty(cInfCDTDC)
			cDesc	:= cInfCDTDC

		//a posicao 44 do array aCmpAntSFT possui conte	udo do campo _MENNOTA (cabecalho da NF - F1 ou F2)
		Case nMVSPDIFC == 2 .And. aCmpAntSFT <> Nil .And. aCmpAntSFT[29] <> Nil .And. !Empty(aCmpAntSFT[29])
			cDesc	:=	aCmpAntSFT[29]
	EndCase


	aAdd(aRegC110, {})
	nPosC110 :=	Len (aRegC110)
	aAdd (aRegC110[nPosC110], "C110")					//REG
	aAdd (aRegC110[nPosC110], cCodInf)                 //COD_INF
	aAdd (aRegC110[nPosC110], cDesc)                   //TXT_COMPL

Return (lRet)


Static Function RegC170 (cAlias, nRelac, nItem, aRegC170, cEspecie, cAliasSFT, cAlsSD, cEntSai, lIss,;
						 aClasFis, lAchouSF4, nApuracao, cSituaDoc, cChvNfe, cUnid, cProd, cIndEmit, ;
						 nValST, dDataDe, dDataAte,aRegM210,aRegM610,aWizard,lConsolid,aReg0500,aRegAuxM105,;
						 aRegAuxM505,cRegime, aRegM400,aRegM410, aRegM800,aRegM810,lCumulativ,cIndApro,aReg0111,;
						 lPisZero,lCofZero,aDevolucao,aRegM220,aRegM620,aRegM230,aRegM630,nQtde,nItemC170,cAliasSB1,cAliasSF4,lDevComp,nPosDevCmp,aDevCpMsmP,aDevMsmPer,nPosDev,lCmpDescZF,cCodNat,lCpoMajAli,lPautaPIS,lPautaCOF,nPaiC)

Local	lRet		:=	.F.
Local	nPos		:=	0
Local  lSt2030		:= .F.
Local	nPisPauta 	:= 	0
Local	nQtdBPis  	:= 	0
Local	nBasePis 	:= 	0
Local	nAliqPis  	:= 	0
Local	nValPis	:=	0
Local	nCofPauta 	:= 	0
Local	nQtdBCof  	:= 	0
Local	nBaseCof  	:= 	0
Local	nAliqCof  	:= 	0
Local	nValCof	:=	0
Local   nValItem	:=  0
Local	lHistTab	:=	aParSX6[1] .And. aIndics[01]
Local	lMVcontZF  :=	aParSX6[34]
Local	aDesc		:= {}
Local   aCopyC170	:= {}
Local   cConta		:= ""
Local   aBaseAlqUn	:= {}
Local   aPar		:= {}
Local	lNFDev		:= Alltrim((cAliasSFT)->FT_TIPO)$"D"

Default	dDataDe		:=	CToD ("//")
Default	dDataAte	:=	CToD ("//")
Default	lPautaPIS	:=	aFieldPos[20]
Default	lPautaCOF	:=	aFieldPos[21]

IF  cEntSai == "2" .AND. lCumulativ .AND. (cAliasSFT)->FT_TNATREC == "4312" .AND. SubStr((cAliasSFT)->FT_CNATREC,1,2) $ "20/30"
	lSt2030 	:= .T.
EndIF

aAdd(aRegC170, Array(37))
nPos := 	Len (aRegC170)
nItemC170++
aRegC170[nPos][1] := "C170"		   					  			  			//01 - REG
aRegC170[nPos][2] := AllTrim (STR (nItemC170))			  			  		//02 - NUM_ITEM
aRegC170[nPos][3] := cProd								  					//03 - COD_ITEM
aRegC170[nPos][5] := Iif(nQtde==0,"",{nQtde, 5}) 							//05 - QTD
aRegC170[nPos][6] := cUnid						 							//06 - UNID

If !lSt2030
	nValItem	:= (cAliasSFT)->FT_TOTAL	+ Iif(lCmpDescZF .And. (cAliasSFT)->FT_TIPO <> "D",(cAliasSFT)->FT_DESCZFR,0)
EndIF
aRegC170[nPos][7] := nValItem //07 - VL_ITEM

If ((cAliasSFT)->FT_TIPO$"IPC")
	aRegC170[nPos][9] := "1"
Else
	//Tratamento movimentacao fisica sem movimentacao de estoque
	If aFieldPos[36]
		aRegC170[nPos][9] := Iif(lAchouSF4 .AND. (SF4->F4_ESTOQUE=="N" .and. (SF4->F4_MOVFIS=="N" .or. Empty(SF4->F4_MOVFIS))),"1","0")//09 - IND_MOV
	Else
		aRegC170[nPos][9] := Iif(lAchouSF4 .AND. SF4->F4_ESTOQUE=="N","1","0")//09 - IND_MOV
	EndIf
EndIf

aRegC170[nPos][10] := aClasFis[1]							   				//10 - CST
aRegC170[nPos][11] := (cAliasSFT)->FT_CFOP  			   					//11 - CFOP

If !(cSituaDoc$"02#04#05")

	If lHistTab
		aMod 	:= MsConHist("SB1","","",dDataDe,,Substr(cProd,1,TamSx3("B1_COD")[1]))
		nP	 	:= ASCAN(aMod,{|x|alltrim(x[1])=="B1_DESC" })
		If len(aMod) >0 .And. nP > 0
			If !(Alltrim((cAliasSB1)->B1_DESC) == AllTrim(aMod[nP][2])) .And. (aMod[nP][3] > dDataAte)
				aAdd(aDesc,aMod[nP][2])
			EndIF
		EndIF
		If len(aDesc) > 0 .And. lHistTab
 			aRegC170[nPos][4]	:= aDesc[1]    								//03 - DESCR_ITEM
		Else
   			aRegC170[nPos][4] 	:= (cAliasSB1)->B1_DESC					  	//04 - DESCR_COMPL
		EndIf
	Else
		aRegC170[nPos][4] 	:= (cAliasSB1)->B1_DESC					  	//04 - DESCR_COMPL	
	EndIf

	If aExstBlck[17]
		aRegC170[nPos][4] := ExecBlock("SPDFIS04", .F., .F., {(cAliasSFT)->FT_FILIAL,;
							(cAliasSFT)->FT_TIPOMOV,;
							(cAliasSFT)->FT_SERIE,;
							(cAliasSFT)->FT_NFISCAL,;
							(cAliasSFT)->FT_CLIEFOR,;
							(cAliasSFT)->FT_LOJA,;
							(cAliasSFT)->FT_ITEM,;
							(cAliasSFT)->FT_PRODUTO})
	EndIf

	aRegC170[nPos][8] := (cAliasSFT)->FT_DESCONT		 					//08 - VL_DESC_I
	aRegC170[nPos][12] := cCodNat											//12 - COD_NAT
	aRegC170[nPos][13] := IIf(lIss,0,(cAliasSFT)->FT_BASEICM)				//13 - VL_BC_ICMS_I
	If ((cAliasSFT)->FT_TIPO == "I") .And. Substr((cAliasSFT)->FT_CLASFIS,2,2) $"00#10#20#70"
		DbselectArea("SD2")
		SD2->(DbSetOrder(3)) //--D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
		If SD2->(MsSeek(xFilial("SD2") + (cAliasSFT)->FT_NFISCAL + (cAliasSFT)->FT_SERIE + (cAliasSFT)->FT_CLIEFOR + (cAliasSFT)->FT_LOJA))
	       DbselectArea("SF3")
	       SF3->(DbSetOrder(6))
		   If SF3->(MsSeek(xFilial("SF3") + SD2->D2_NFORI + SD2->D2_SERIORI))
		       aRegC170[nPos][14] := IIf(lIss,0,SF3->F3_ALIQICM)
	       EndIF

	       SF3->(DbSetOrder(1))// Retornando SF3 p/ a ordenacao inicial
	    EndIf
	Else
		aRegC170[nPos][14] := IIf(lIss,0,(cAliasSFT)->FT_ALIQICM)			//14 - ALIQ_ICMS
	EndIf
	aRegC170[nPos][15] := IIf(lIss,0,(cAliasSFT)->FT_VALICM)				//15 - VL_ICMS_I
	aRegC170[nPos][16] := IIf(nValST==0,0,(cAliasSFT)->FT_BASERET)		//16 - VL_BC_ST_I
	aRegC170[nPos][17] := IIf(nValST==0,0,(cAliasSFT)->FT_ALIQSOL)		//17 - ALIQ_ST
	aRegC170[nPos][18] := nValST											//18 - VL_ST_I
	aRegC170[nPos][19] := STR(nApuracao,1)							 		//19 - IND_APUR
	aRegC170[nPos][20] := aClasFis[2]	 					  		   		//20 - CST_IPI
	aRegC170[nPos][21] := "" 												//21 - COD_ENQ
	aRegC170[nPos][22] := (cAliasSFT)->FT_BASEIPI	 						//22 - VL_BC_IPI
	aRegC170[nPos][23] := (cAliasSFT)->FT_ALIQIPI							//23 - ALIQ_IPI
	aRegC170[nPos][24] := (cAliasSFT)->FT_VALIPI							//24 - VL_IPI
	aRegC170[nPos][25] := aClasFis[3]			 					  		//25 - CST_PIS

	//Ir¡ preencher valores de pauta se PIS for tributado a al­quota por unidade de medida de produto
	//Caso no for por pauta, ir¡ gerar C170 com valores de percentual
	If (((cAliasSFT)->FT_VALPIS > 0 .Or. (cAliasSFT)->FT_BASEPIS > 0 .OR. (cAliasSFT)->FT_ALIQPIS >0) .OR. ;
	     ((cAliasSFT)->FT_VALPS3 > 0 .Or. (cAliasSFT)->FT_BASEPS3 > 0 .OR. (cAliasSFT)->FT_ALIQPS3 >0))
		If (lPautaPIS .And. (cAliasSFT)->FT_PAUTPIS > 0) //.OR. (cAliasSB1)->B1_VLR_PIS > 0
			aBaseAlqUn	:=	VlrPauta(lCmpNRecFT, lCmpNRecB1, "PIS",cAliasSFT,cAliasSB1,lCmpNRecF4,lPautaPIS)
			nPisPauta 	:= 	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][1] , (cAliasSFT)->FT_PAUTPIS)
			nQtdBPis  	:= 	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][2] , (cAliasSFT)->FT_QUANT)

			IF cEntSai == "2" .AND. nPosDev >0
				nValPis		:=	(cAliasSFT)->FT_VALPIS - aDevMsmPer[nPosDev][8]
			ElseIf cEntSai == "1"
				IF nPosDevCmp >0
					nValPis		:=	(cAliasSFT)->FT_VALPIS - aDevCpMsmP[nPosDevCmp][8]
				ElseIF !((cAliasSFT)->FT_TIPO=="D" .And. (cAliasSFT)->FT_CSTPIS$"98/99" )
					nValPis		:=	(cAliasSFT)->FT_VALPIS
				EndIF
			Else
				nValPis		:=	(cAliasSFT)->FT_VALPIS
			EndIF
		ElseIf cEntSai == "2"
			If !lDevolucao
				IF (cAliasSFT)->FT_CSTPIS == "05"
					nBasePis  	:= 	(cAliasSFT)->FT_BASEPS3
					nAliqPis  	:= 	Iif(lPisZero,0,(cAliasSFT)->FT_ALIQPS3)
					nValPis		:=	Iif(lPisZero,0,(cAliasSFT)->FT_VALPS3)
				Else
					nBasePis  	:= 	(cAliasSFT)->FT_BASEPIS
					nAliqPis  	:= 	Iif(lPisZero,0,(cAliasSFT)->FT_ALIQPIS)
					nValPis		:=	Iif(lPisZero,0,(cAliasSFT)->FT_VALPIS)
				EndIF
			Elseif nPosDev > 0
				nBasePis  	:= 	(cAliasSFT)->FT_BASEPIS - aDevMsmPer[nPosDev][7]
				nAliqPis  	:= 	Iif(lPisZero,0,(cAliasSFT)->FT_ALIQPIS)
				nValPis		:=	Iif(lPisZero,0,(cAliasSFT)->FT_VALPIS - aDevMsmPer[nPosDev][8])
			Else
				nBasePis  	:=	0
				nAliqPis  	:=	Iif(lPisZero,0,(cAliasSFT)->FT_ALIQPIS)
				nValPis		:=	0
			EndIF
		ElseIf cEntSai == "1"
			If !lDevComp .And. !(lNFDev .And. (cAliasSFT)->FT_CSTPIS$"98/99" )
				nBasePis  	:= 	(cAliasSFT)->FT_BASEPIS
				nAliqPis  	:= 	Iif(lPisZero,0,(cAliasSFT)->FT_ALIQPIS)
				nValPis		:=	Iif(lPisZero,0,(cAliasSFT)->FT_VALPIS)
				MajAliqPis(@nAliqPis,@nValPis,cAliasSFT)
			Elseif Len(aDevCpMsmP) > 0 .And. !(lNFDev .And. (cAliasSFT)->FT_CSTPIS$"98/99" )
				nBasePis  	:= 	(cAliasSFT)->FT_BASEPIS - aDevCpMsmP[nPosDevCmp][7]
				nAliqPis  	:= 	Iif(lPisZero,0,(cAliasSFT)->FT_ALIQPIS)
				nValPis		:=	Iif(lPisZero,0,(cAliasSFT)->FT_VALPIS - aDevCpMsmP[nPosDevCmp][8])
				MajAliqPis(@nAliqPis,@nValPis,cAliasSFT)
			Else
				nBasePis  	:=	0
				nAliqPis  	:=	Iif(lPisZero,0,(cAliasSFT)->FT_ALIQPIS)
				nValPis		:=	0
			EndIF
		EndIF
	Endif
	aRegC170[nPos][27] := Iif(nAliqPis>0 .Or. lPisZero,nAliqPis,"")		//27 - ALIQ_PIS

	If nQtdBPis > 0
		IF !lDevolucao
			aRegC170[nPos][28] := nQtdBPis					 				//28 - QUANT_BC_PIS
			aRegC170[nPos][26]	:= "" 										//26 - VL_BC_PIS
		Else
			aRegC170[nPos][28] := 0					 						//28 - QUANT_BC_PIS
			aRegC170[nPos][26]	:= "" 										//26 - VL_BC_PIS
		EndIF
	Else
	    IF lMVcontZF .And. (cAliasSFT)->FT_DESCZFR > 0 .And. (cAliasSFT)->FT_ALIQCOF == 0 .And. (cAliasSFT)->FT_ALIQPIS == 0 .And. (cAliasSFT)->FT_TIPOMOV == "S"
			nBasePis:= (cAliasSFT)->FT_VALCONT
		EndIf
		aRegC170[nPos][28] := ""					 						//28 - QUANT_BC_PIS
		aRegC170[nPos][26]	:= nBasePis										//26 - VL_BC_PIS
	EndIF

	If nPisPauta > 0
		aRegC170[nPos][29] := Iif(lPisZero,0,nPisPauta) 					//29 - ALIQ_PIS - Reais
	Else
		aRegC170[nPos][29] := "" 											//29 - ALIQ_PIS - Reais
	EndIf

	aRegC170[nPos][30] := nValPis											//30 - VL_PIS
	aRegC170[nPos][31] := aClasFis[4]			 					  		//31 - CST_COFINS

//Ir¡ preencher valores de pauta se COFINS for tributado a al­quota por unidade de medida de produto Caso no for por pauta, ir¡ gerar C170 com valores de percentual
	If (((cAliasSFT)->FT_VALCOF > 0 .Or. (cAliasSFT)->FT_BASECOF > 0 .OR. (cAliasSFT)->FT_ALIQCOF >0) .OR. ;
	     ((cAliasSFT)->FT_VALCF3 > 0 .Or. (cAliasSFT)->FT_BASECF3 > 0 .OR. (cAliasSFT)->FT_ALIQCF3 >0))

		If (lPautaCOF .And. (cAliasSFT)->FT_PAUTCOF > 0) //.OR. (cAliasSB1)->B1_VLR_COF > 0
			aBaseAlqUn	:=	VlrPauta(lCmpNRecFT, lCmpNRecB1, "COF",cAliasSFT,cAliasSB1,lCmpNRecF4,lPautaCOF)
			nCofPauta 	:= 	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][1] , (cAliasSFT)->FT_PAUTCOF)
			nQtdBCof  	:= 	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][2] , (cAliasSFT)->FT_QUANT)

			IF cEntSai == "2" .AND. nPosDev >0
				nValCof		:=	(cAliasSFT)->FT_VALCOF - aDevMsmPer[nPosDev][10]
			ElseIf cEntSai == "1"
				IF nPosDevCmp >0
					nValCof		:=	(cAliasSFT)->FT_VALCOF - aDevCpMsmP[nPosDevCmp][10]
				ElseIF !((cAliasSFT)->FT_TIPO=="D" .And. (cAliasSFT)->FT_CSTPIS$"98/99" )
					nValCof		:=	(cAliasSFT)->FT_VALCOF
				EndIF
			Else
				nValCof		:=	(cAliasSFT)->FT_VALCOF
			EndIF

		ElseIF cEntSai == "2"
			If !lDevolucao
				IF (cAliasSFT)->FT_CSTCOF == "05"
					nBaseCof  	:= 	(cAliasSFT)->FT_BASECF3
					nAliqCof  	:= 	Iif(lCofZero,0,(cAliasSFT)->FT_ALIQCF3)
					nValCof		:=	Iif(lCofZero,0,(cAliasSFT)->FT_VALCF3)
				Else
					nBaseCof  	:= 	(cAliasSFT)->FT_BASECOF
					nAliqCof  	:= 	Iif(lCofZero,0,(cAliasSFT)->FT_ALIQCOF)
					nValCof		:=	Iif(lCofZero,0,(cAliasSFT)->FT_VALCOF)
				EndIF
			Elseif nPosDev > 0
				nBaseCof  	:= 	(cAliasSFT)->FT_BASECOF - aDevMsmPer[nPosDev][9]
				nAliqCof  	:= 	Iif(lCofZero,0,(cAliasSFT)->FT_ALIQCOF)
				nValCof		:=	Iif(lCofZero,0,(cAliasSFT)->FT_VALCOF - aDevMsmPer[nPosDev][10])
			Else
				nBaseCof  	:=	0
				nAliqCof  	:=	Iif(lCofZero,0,(cAliasSFT)->FT_ALIQCOF)
				nValCof		:=	0
			EndIF
		ElseIF cEntSai == "1"
			If !lDevComp .And. !(lNFDev .And. (cAliasSFT)->FT_CSTCOF$"98/99" )
				nBaseCof  	:= 	(cAliasSFT)->FT_BASECOF
				nAliqCof  	:= 	Iif(lCofZero,0,(cAliasSFT)->FT_ALIQCOF)
				nValCof		:=	Iif(lCofZero,0,(cAliasSFT)->FT_VALCOF)
				MajAliqVal(@nAliqCof,@nValCof,cAliasSFT,lCpoMajAli)
			Elseif Len(aDevCpMsmP) > 0 .And. !(lNFDev .And. (cAliasSFT)->FT_CSTCOF$"98/99" )
				nBaseCof  	:= 	(cAliasSFT)->FT_BASECOF - aDevCpMsmP[nPosDevCmp][9]
				nAliqCof  	:= 	Iif(lCofZero,0,(cAliasSFT)->FT_ALIQCOF)
				nValCof		:=	Iif(lCofZero,0,(cAliasSFT)->FT_VALCOF - aDevCpMsmP[nPosDevCmp][10])
				MajAliqVal(@nAliqCof,@nValCof,cAliasSFT,lCpoMajAli)
			Else
				nBaseCof  	:=	0
				nAliqCof  	:=	Iif(lCofZero,0,(cAliasSFT)->FT_ALIQCOF)
				nValCof		:=	0
			EndIF
		EndIF
	EndIF

	aRegC170[nPos][33] := IIf(nAliqCof	>0 .Or. lCofZero,nAliqCof,"")	//33 - ALIQ_COFIN

	If nQtdBCof > 0
		IF !lDevolucao
			aRegC170[nPos][34] := nQtdBCof 					 				//34 - QUANT_BC_COFINS
			aRegC170[nPos][32]	:= "" 										//32 - VL_BC_COFINS
		Else
			aRegC170[nPos][34] := 0 					 					//34 - QUANT_BC_COFINS
			aRegC170[nPos][32]	:= "" 										//32 - VL_BC_COFINS
		EndIF
	Else
		IF lMVcontZF .And. (cAliasSFT)->FT_DESCZFR > 0 .And. (cAliasSFT)->FT_ALIQCOF == 0 .And. (cAliasSFT)->FT_ALIQPIS == 0 .And. (cAliasSFT)->FT_TIPOMOV == "S"
			nBaseCof:= (cAliasSFT)->FT_VALCONT
		EndIf
		aRegC170[nPos][34] := ""					 						//34 - QUANT_BC_COFINS
		aRegC170[nPos][32]	:= nBaseCof 									//32 - VL_BC_COFINS
	EndIF

	If nCofPauta > 0
    	aRegC170[nPos][35] := Iif(lCofZero,0,nCofPauta) 					//35 - ALIQ_COFINS - Reais
  	Else
    	aRegC170[nPos][35] := "" 											//35 - ALIQ_COFINS - Reais
  	EndIf


	aRegC170[nPos][36] := Iif(lCofZero,0,nValCof)							//36 - VL_COFINS

	cConta := Reg0500(@aReg0500,(cAliasSFT)->FT_CONTA,,cAliasSFT)
	aRegC170[nPos][37] := cConta											//37 - COD_CTA
EndIf


If !(cSituaDoc$"02#04#05") .And. ( cEspecie$"01#04#55#1B")
	PCGrvReg (cAlias, nRelac, aRegC170, nItemC170,, Iif(lProcMThr,nPaiC,NIL) ,,,nTamTRBIt)

	//Processamento para sa­das Contribuiµes.
	IF cEntSai == "2"
		If (cEspecie <> "55" .OR. (cEspecie == "55" .AND. !lConsolid))
			If lSt2030
				aAdd(aPar,(cAliasSFT)->FT_CSTPIS)
				aAdd(aPar,(cAliasSFT)->FT_CSTCOF)
				aAdd(aPar,0)
			EndIF
			IF (cAliasSFT)->FT_CSTPIS $ "01/02/03/05"
				RegM210(aRegM210,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM220,,,@aRegM230,(cAliasSFT)->FT_TOTAL +  IIF(Iif(lCmpDescZF,(cAliasSFT)->FT_DESCZFR,0) > 0 ,(cAliasSFT)->FT_DESCZFR ,0),cAliasSB1,,,,,aPar,,aDevMsmPer,,lSt2030,.T.,nPisPauta,Iif(!lDevolucao,nQtdBPis,0))
			EndIF
			IF (cAliasSFT)->FT_CSTCOF $ "01/02/03/05"
				RegM610(aRegM610,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM620,,,@aRegM630,(cAliasSFT)->FT_TOTAL +  IIF(Iif(lCmpDescZF,(cAliasSFT)->FT_DESCZFR,0) > 0 ,(cAliasSFT)->FT_DESCZFR ,0),cAliasSB1,,,,,aPar,,aDevMsmPer,,lSt2030,.T.,nCofPauta,Iif(!lDevolucao,nQtdBCof,0))
			EndIF

			//PIS
			If (cAliasSFT)->FT_CSTPIS $ "04/05/06/07/08/09"
				If !(cAliasSFT)->FT_CSTPIS $ "05" //se for CST 04, 06, 07, 08, 09 grava M400 direto
					RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1,,,,IIF(Iif(lCmpDescZF,(cAliasSFT)->FT_DESCZFR,0) > 0 ,(cAliasSFT)->FT_TOTAL	+ (cAliasSFT)->FT_DESCZFR,0))
				ElseIF (cAliasSFT)->FT_ALIQPS3 == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
					RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1,,,,IIF(Iif(lCmpDescZF,(cAliasSFT)->FT_DESCZFR,0) > 0 ,(cAliasSFT)->FT_TOTAL	+ (cAliasSFT)->FT_DESCZFR,0))
				EndIF
			EndIF
			//COFINS
			If (cAliasSFT)->FT_CSTCOF $ "04/05/06/07/08/09"
				If !(cAliasSFT)->FT_CSTCOF $ "05" //se for CST 04, 06, 07, 08, 09 grava M400 direto
					RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1,,,,IIF(Iif(lCmpDescZF,(cAliasSFT)->FT_DESCZFR,0) > 0 ,(cAliasSFT)->FT_TOTAL	+ (cAliasSFT)->FT_DESCZFR,0))
				ElseIF (cAliasSFT)->FT_ALIQCF3 == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
					RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1,,,,IIF(Iif(lCmpDescZF,(cAliasSFT)->FT_DESCZFR,0) > 0 ,(cAliasSFT)->FT_TOTAL	+ (cAliasSFT)->FT_DESCZFR,0))
				EndIF
			EndIF
		EndIF

	ElseIF cEntSai == "1"

		If (cAliasSFT)->FT_CSTPIS $ CCSTCRED
			AcumM105(aRegAuxM105,cAliasSFT,cRegime,lCumulativ,cIndApro,aReg0111,,,,,cAliasSB1,,aDevCpMsmP,nPosDevCmp)
		EndIF

		If (cAliasSFT)->FT_CSTCOF $ CCSTCRED
			AcumM505(aRegAuxM505,cAliasSFT,cRegime,lCumulativ,cIndApro,aReg0111,,,,,cAliasSB1,,aDevCpMsmP,nPosDevCmp)
		EndIF
	EndIF

	lRet := .T.

EndIf

IF lSt2030 .AND. lRet

	aPar:= {}
	aAdd(aPar,"01")
	aAdd(aPar,"01")
	aAdd(aPar,(cAliasSFT)->FT_TOTAL +  IIF(Iif(lCmpDescZF,(cAliasSFT)->FT_DESCZFR,0) > 0 ,(cAliasSFT)->FT_DESCZFR ,0))
	nItemC170++
	aCopyC170 := aRegC170
	aCopyC170[nPos][2]:=AllTrim (STR (nItemC170))
	aCopyC170[nPos][7] := (cAliasSFT)->FT_TOTAL
	aCopyC170[nPos][25] := "01"
	aCopyC170[nPos][31] := "01"
	aCopyC170[nPos][26] := (cAliasSFT)->FT_BASEPIS
	aCopyC170[nPos][30] := (cAliasSFT)->FT_VALPIS
	aCopyC170[nPos][32] := (cAliasSFT)->FT_BASECOF
	aCopyC170[nPos][36] := (cAliasSFT)->FT_VALCOF

	PCGrvReg (cAlias, nRelac, aCopyC170, nItemC170,, Iif(lProcMThr,nPaiC,NIL) ,,,nTamTRBIt)
	RegM210(aRegM210,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM220,,,@aRegM230,(cAliasSFT)->FT_TOTAL +  IIF(Iif(lCmpDescZF,(cAliasSFT)->FT_DESCZFR,0) > 0 ,(cAliasSFT)->FT_DESCZFR ,0),cAliasSB1,,,,,aPar,,aDevMsmPer,,lSt2030)
	RegM610(aRegM610,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM620,,,@aRegM630,(cAliasSFT)->FT_TOTAL +  IIF(Iif(lCmpDescZF,(cAliasSFT)->FT_DESCZFR,0) > 0 ,(cAliasSFT)->FT_DESCZFR ,0),cAliasSB1,,,,,apar,,aDevMsmPer,,lSt2030)
EndIF

Return (lRet)



Static Function RetCodCst (cAliasSFT,cAlsSA,lAchouSF4,cEntSai,lCstPis,lCstCof,cEspecie,cAliasSB1,cAliasSF4)
	Local	cA1A2		:=	SubStr (cAlsSA, 3, 1)
	Local	cCmpEst		:=	cAlsSA+"->A"+cA1A2+"_EST"
	//						Icm Ipi Pis	Cof
	Local	aRet		:= {"" ,"", "", ""}
	Local   lStfrete    := aParSX6[35] //Cod.Situao Tributaria para notas de conhecimento de frete
	DEFAULT cEspecie 	:=	"01"

	//Situacao Tributaria ICMS
	If Empty((cAliasSFT)->FT_CLASFIS) .Or. Len(Alltrim((cAliasSFT)->FT_CLASFIS))<>3

		If Empty((cAliasSB1)->B1_ORIGEM)

			If Empty((cAliasSB1)->B1_IMPORT) .Or. (cAliasSB1)->B1_IMPORT=="N"
				aRet[1] := "0"
			Else
				If &(cCmpEst)=="EX"
					aRet[1] := "1"
				Else
					aRet[1] := "2"
				EndIf
			EndIf
		Else
			aRet[1] := (cAliasSB1)->B1_ORIGEM
		EndIf

		If lAchouSF4
			aRet[1]	+=	SF4->F4_SITTRIB
		EndIf
	Else
		aRet[1] :=(cAliasSFT)->FT_CLASFIS
	EndIf

	//Tratamento para notas de conhecimento de frete.
	//Em consulta junto nossa consultoria Tribut¡ria, foi necessario a criao do parametro MV_STFRETE para definir se o campo (CST)Cod.Situao Tributaria
	//das notas de conhecimento de frete ser¡ considerado do B1_ORIGEM ou se iniciar¡ em "0" mesmo sendo uma importao.
	//Solicitao feita na FNC 00000019516/2010-01

	If lStfrete
		If (cEspecie$"07#08#09#10#11#26#27#57") .Or. ((cAliasSFT)->FT_TIPO$"C")
	    	aRet[1] := "0"+ SubStr((cAliasSFT)->FT_CLASFIS,2,3)
	  	EndIf
	EndIf

	//Situacao Tributaria IPI
	aRet[2] := (cAliasSFT)->FT_CTIPI

	//Situacao Tributaria PIS
	aRet[3] := (cAliasSFT)->FT_CSTPIS

	//Situacao Tributaria COFINS
	aRet[4] := (cAliasSFT)->FT_CSTCOF

	//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„L¿
	//Ponto de Entrada para alterar a classificao fiscal do produto.
	//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„L™
	If aExstBlck[18]
		aRet :=  ExecBlock("SPDFIS03", .F., .F., {(cAliasSFT)->FT_FILIAL,;
							(cAliasSFT)->FT_TIPOMOV,;
							(cAliasSFT)->FT_SERIE,;
							(cAliasSFT)->FT_NFISCAL,;
							(cAliasSFT)->FT_CLIEFOR,;
							(cAliasSFT)->FT_LOJA,;
							(cAliasSFT)->FT_ITEM,;
							(cAliasSFT)->FT_PRODUTO})
	EndIf
Return(aRet)


Static Function RegC120 (cAlias, nRelac, aAverage,cAlsSF,cAliasCD5,aPEImport,lTop,cAliasSF1,cChvCD5,lAchouCD5,cHAWB,nPaiC)
	Local	aRegC120	:=	{}
	Local	nPos		:=	0
	Local	lAcDraw		:=	aFieldPos[37]
	Local	cAcDraw		:=	""
	Local	cDocImp		:=	""
	Local	nX			:=	0
	Local 	cFilCD5		:= xFilial(cAliasCD5)
	Local 	cChvWhl		:= ""

	Default lAchouCD5	:= .F.
	Default cHAWB		:= ""
	Default cChvCD5		:= ""
	Default nPaiC      := 0

	If !lTop
		cHAWB	:= (cAlsSF)->F1_HAWB
	EndIF

	//Utiliza Ponto de Entrada SPDIMP 

	If Len(aPEImport) > 0
		For nX := 1 To Len(aPEImport)

			If (nPos := aScan(aRegC120, {|aZ| aZ[6] == aPEImport[nX][5] .And. aZ[3] == aPEImport[nX][2]})) == 0
				aAdd(aRegC120, {})
				nPos	:=	Len (aRegC120)
				aAdd (aRegC120[nPos], "C120")	 						  		//01 - REG
				aAdd (aRegC120[nPos], aPEImport[nX][1])					//02 - COD_DOC_IMP
				aAdd (aRegC120[nPos], aPEImport[nX][2])					//03 - NUM_DOC_IMP
				aAdd (aRegC120[nPos], aPEImport[nX][3])					//04 - PIS_IMP
				aAdd (aRegC120[nPos], aPEImport[nX][4])					//05 - COF_IMP
				aAdd (aRegC120[nPos], aPEImport[nX][5])					//06 - NUM_ACDRAW
			Else
				aRegC120[nPos][4]	+=	aPEImport[nX][3]						//04 - PIS_IMP
				aRegC120[nPos][5]	+=	aPEImport[nX][4]						//05 - COF_IMP
			Endif

		Next nX

	//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
	Elseif aParSX6[17]=="S" .And. Len(aAverage)>0 .And. !Empty(cHAWB)
		aAdd(aRegC120, {})
		nPos	:=	Len (aRegC120)
		aAdd (aRegC120[nPos], "C120")			             	//01 - REG
		aAdd (aRegC120[nPos], aAverage[1][2][1][2][1])		//02 - TP_DOC_IMP
		aAdd (aRegC120[nPos], aAverage[1][2][2][2][1])		//03 - COD_DOC_IMP
		aAdd (aRegC120[nPos], aAverage[1][2][3][2][1])		//04 - PIS_IMP
		aAdd (aRegC120[nPos], aAverage[1][2][4][2][1])		//05 - COF_IMP
		aAdd (aRegC120[nPos], "")					            //06 - NUM_ACDRAW

	ElseIf lAchouCD5
		cChvWhl := cFilCD5+(cAliasCD5)->(CD5_DOC+CD5_SERIE+CD5_FORNEC+CD5_LOJA)

		While !(cAliasCD5)->(Eof()) .AND. (cChvWhl==cChvCD5)

			cAcDraw	:=	Iif(lAcDraw,(cAliasCD5)->CD5_ACDRAW	,"")
			cDocImp	:=	(cAliasCD5)->CD5_DOCIMP

			If (nPos := aScan(aRegC120, {|aZ| aZ[6] == cAcDraw .And. aZ[3] == cDocImp})) == 0
				aAdd(aRegC120, {})
				nPos	:=	Len (aRegC120)
				aAdd (aRegC120[nPos], "C120")	 						//01 - REG
				aAdd (aRegC120[nPos], (cAliasCD5)->CD5_TPIMP)			//02 - COD_DOC_IMP
				aAdd (aRegC120[nPos], (cAliasCD5)->CD5_DOCIMP)			//03 - NUM_DOC_IMP
				aAdd (aRegC120[nPos], (cAliasCD5)->CD5_VLPIS)			//04 - PIS_IMP
				aAdd (aRegC120[nPos], (cAliasCD5)->CD5_VLCOF)			//05 - COF_IMP

				If lAcDraw
					aAdd (aRegC120[nPos], (cAliasCD5)->CD5_ACDRAW)	//06 - NUM_ACDRAW - LAYOUT 2010
				Else
					aAdd (aRegC120[nPos], "")						//06 - NUM_ACDRAW - LAYOUT 2010
				EndIf
			Else
				aRegC120[nPos][4]	+=	(cAliasCD5)->CD5_VLPIS			//04 - PIS_IMP
				aRegC120[nPos][5]	+=	(cAliasCD5)->CD5_VLCOF			//05 - COF_IMP
			Endif

			(cAliasCD5)->(DbSkip())
			cChvWhl := cFilCD5+(cAliasCD5)->(CD5_DOC+CD5_SERIE+CD5_FORNEC+CD5_LOJA)
		End
	EndIf

	PCGrvReg (cAlias, nRelac, aRegC120,,,IIf(lProcMThr,nPaiC,NIL),,,nTamTRBIt)

Return


Static Function RegC111 (aRegC111, nPosC110,aReg1010,aReg1020)

Local	aAreaCDG	:=	CDG->(GetArea())
Local	lRet		:=	.T.
Local	nPos111		:=	1
Local   cChave      := ''
Local   nPos        := 0
Local 	lAchouCCF	:= .F.

cChave := CDG->CDG_FILIAL+CDG->CDG_TPMOV+CDG->CDG_DOC+CDG->CDG_SERIE+CDG->CDG_CLIFOR+CDG->CDG_LOJA

Do while !CDG->(Eof()) .And. CDG->CDG_FILIAL+CDG->CDG_TPMOV+CDG->CDG_DOC+CDG->CDG_SERIE+CDG->CDG_CLIFOR+CDG->CDG_LOJA==cChave

	If !(AllTrim(CDG->CDG_TPPROC)$"0|2")   // Verifica o tipo do registro, so' grava se for: 1 - Justica Federal / 2 - Secretaria Federal ou 9 - Outros
		If (nPos := aScan (aRegC111, {|aX| aX[2]==CDG->CDG_PROCES})==0)// Verifica se o codigo da info ja esta lancada no C111

			aAdd(aRegC111, {})
			nPos111 := Len(aRegC111)
			aAdd (aRegC111[nPos111], "C111")				//01 - REG
			aAdd (aRegC111[nPos111], CDG->CDG_PROCES)		//02 - NUM_PROC
			aAdd (aRegC111[nPos111], CDG->CDG_TPPROC)		//03 - IND_PROC
			lAchouCCF	:=	CCF->(MsSeek (xFilial ("CCF")+ CDG->CDG_PROCES +CDG->CDG_TPPROC))
			If	lAchouCCF
				If CCF->CCF_TPCOMP == "1" //Complemento do processo referenciado - Judicial
					Reg1010(aReg1010)
				ElseIf CCF->CCF_TPCOMP == "2" //Complemento do processo referenciado - Administrativo
					Reg1020(aReg1020)
				EndIF
			EndIf
		Endif
	 EndIF
	CDG->(DbSkip())

Enddo

RestArea(aAreaCDG)

Return (lRet)


Static Function RegC180(aRegC180,aRegC181,aRegC185,aReg0500,cAliasSFT,dDataDe, dDataAte,cProd,nPosRetur,aWizard,lConsolid, ;
						aRegM210,aRegM610,aRegM400,aRegM410,aRegM800,aRegM810,lCumulativ,lPisZero, lCofZero,aDevolucao,;
						aRegM220,aRegM620,aRegM230,aRegM630,cAliasSB1,aDevMsmPer,nPosDev,lCpoMajAli,lRecursivo,cCstRecur)

Local 	nPos		:=	0
Local 	nPosC180	:=	0
Local 	nPosC181	:=	0
Local 	nPosC185	:=	0
Local 	lPauta 		:=	.F.
Local   lSt2030		:= .F.
Local	lPautaPIS	:=	aFieldPos[20]
Local	lPautaCOF	:=	aFieldPos[21]
Local 	nPisPauta	:=	0
Local 	nCofPauta 	:=	0
Local 	cConta 		:=	Reg0500(@aReg0500,(cAliasSFT)->FT_CONTA,,cAliasSFT)
Local 	nQtdBPis	:= 	0
Local 	nQtdBCof	:= 	0
Local 	aBaseAlqUn 	:= 	{}
Local   aPar		:= {}
Local 	cChaveCCZ	:= 	""
Local 	cCstPis		:= 	""
Local 	cCstCof		:= 	""
Local 	nBasePis	:=	0
Local 	nValPis		:=	0
Local 	nAliqPis	:=	0
Local 	nBaseCof	:=	0
Local	nValCof		:=	0
Local	nAliqCof	:=	0
Local   nValorItem	:= 0

DEFAULT lRecursivo	:= .F.
DEFAULT	cCstRecur	:= ""

cCstPis	:=(cAliasSFT)->FT_CSTPIS
cCstCof	:=(cAliasSFT)->FT_CSTCOF
IF lCumulativ .AND. (cAliasSFT)->FT_TNATREC == "4312" .AND. SubStr((cAliasSFT)->FT_CNATREC,1,2) $ "20/30"
	lSt2030 	:= .T.
	aPar:= {}
	aAdd(aPar,(cAliasSFT)->FT_CSTPIS)
	aAdd(aPar,(cAliasSFT)->FT_CSTCOF)
	aAdd(aPar,0)
EndIF

If !lSt2030 .or. lRecursivo
	nValorItem:=IIF(dDataDe >= CTOD("01/07/2012"),(cAliasSFT)->FT_TOTAL,(cAliasSFT)->FT_VALCONT)
EndIF

If lRecursivo
	cCstPis	:=cCstRecur
	cCstCof	:=cCstRecur
	aPar:= {}
	aAdd(aPar,cCstPis)
	aAdd(aPar,cCstCof)
	aAdd(aPar,nValorItem)
EndIF

nPosC180 := aScan (aRegC180, {|aX| aX[5]==AllTrim(cProd)})
If nPosC180 ==0
	aAdd(aRegC180, {})
	nPos := Len(aRegC180)
	nPosRetur := nPos
	aAdd (aRegC180[nPos], "C180")						  			//01 - REG
	aAdd (aRegC180[nPos], "55")										//02 - COD_MOD
	aAdd (aRegC180[nPos], dDataDe)				   					//03 - DT_DOC_INI
	aAdd (aRegC180[nPos], dDataAte)				   					//04 - DT_DOC_FIN
	aAdd (aRegC180[nPos], AllTrim(cProd))							//05 - COD_ITEM
	aAdd (aRegC180[nPos], Iif(Alltrim((cAliasSB1)->B1_POSIPI)=="99",Replicate("9",8),(cAliasSB1)->B1_POSIPI)) 	//06 - COD_NCM
	aAdd (aRegC180[nPos], (cAliasSB1)->B1_EX_NCM)				   	//07 - EX_IPI
	aAdd (aRegC180[nPos], (cAliasSFT)->FT_VALCONT)					//08 - VL_TOT_ITEM

	//C181
	aAdd(aRegC181, {})
	nPos := Len(aRegC181)
	aAdd (aRegC181[nPos], Len(aRegC180))                        	//-Relacao com C180
	aAdd (aRegC181[nPos], "C181")						  			//01 - REG
	aAdd (aRegC181[nPos], cCstPis)									//02 - CST_PIS
	aAdd (aRegC181[nPos], (cAliasSFT)->FT_CFOP)				   	//03 - CFOP
	aAdd (aRegC181[nPos], nValorItem)//04 - VL_ITEM
	aAdd (aRegC181[nPos], (cAliasSFT)->FT_DESCONT)					//05 - VL_DESC

	lPauta:=.F.

	If (cAliasSFT)->FT_VALPIS > 0
		If (lPautaPIS .And. (cAliasSFT)->FT_PAUTPIS > 0) .OR. (cAliasSB1)->B1_VLR_PIS > 0
			aBaseAlqUn	:=	VlrPauta(lCmpNRecFT, lCmpNRecB1, "PIS",cAliasSFT,cAliasSB1,lCmpNRecF4,lPautaPIS)
			nPisPauta 	:= 	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][1] , Iif((cAliasSFT)->FT_PAUTPIS > 0,(cAliasSFT)->FT_PAUTPIS,(cAliasSB1)->B1_VLR_PIS))
			nQtdBPis  	:= 	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][2] , (cAliasSFT)->FT_QUANT)
			nValPis		:=	(cAliasSFT)->FT_VALPIS
			If  (cAliasSFT)->FT_CSTPIS <> "02"
				lPauta		:=	.T.
			EndIf	
		EndIF
	EndIF

	If !lDevolucao
		nBasePis  	:= 	Iif(cCstPis == "05",(cAliasSFT)->FT_BASEPS3,(cAliasSFT)->FT_BASEPIS)
		nAliqPis  	:= 	Iif(cCstPis == "05",(cAliasSFT)->FT_ALIQPS3,(cAliasSFT)->FT_ALIQPIS)
		nValPis		:=	Iif(cCstPis == "05",(cAliasSFT)->FT_VALPS3,(cAliasSFT)->FT_VALPIS)
		MajAliqPis(@nAliqPis,@nValPis,cAliasSFT)
	Elseif nPosDev > 0
		nBasePis  	:= 	(cAliasSFT)->FT_BASEPIS - aDevMsmPer[nPosDev][7]
		nAliqPis  	:= 	Iif(lPisZero,0,(cAliasSFT)->FT_ALIQPIS)
		nValPis		:=	Iif(lPisZero,0,(cAliasSFT)->FT_VALPIS - aDevMsmPer[nPosDev][8])
		nQtdBPis	:=	0
		MajAliqPis(@nAliqPis,@nValPis,cAliasSFT)
	Else
		nBasePis  	:=	0
		nAliqPis  	:=	Iif(lPisZero,0,(cAliasSFT)->FT_ALIQPIS)
		nValPis		:=	0
		nQtdBPis	:=	0
	EndIF

	aAdd (aRegC181[nPos], Iif(lPauta,"",nBasePis))									//06 - VL_BC_PIS
	aAdd (aRegC181[nPos], Iif(lPauta,"",nAliqPis))									//07 - ALIQ_PIS
	aAdd (aRegC181[nPos], Iif(lPauta,nQtdBPis,""))									//08 - QUANT_BC_PIS
	aAdd (aRegC181[nPos], Iif(lPauta,Iif(lPisZero,0,nPisPauta),""))				//09 - ALIQ_PIS_QUANT
	aAdd (aRegC181[nPos], nValPis)													//10 - VL_PIS
	aAdd (aRegC181[nPos], cConta)													//11 - COD_CTA

	If lConsolid
		RegM210(aRegM210,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM220,,,,IIF(dDataDe >= CTOD("01/07/2012"),0,(cAliasSFT)->FT_VALCONT),cAliasSB1,,,,,aPar,,aDevMsmPer,,lSt2030)

		If cCstPis $ "04/05/06/07/08/09"
			If !cCstPis $ "05" //se for CST 04, 06, 07, 08, 09 grava M400 direto
				RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1,,,,IIF(dDataDe >= CTOD("01/07/2012"),0,(cAliasSFT)->FT_VALCONT))
			ElseIF (cAliasSFT)->FT_ALIQPS3 == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
				RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1,,,,IIF(dDataDe >= CTOD("01/07/2012"),0,(cAliasSFT)->FT_VALCONT))
			EndIF
		EndIF
	EndIF

	//C185

	aAdd(aRegC185, {})
	nPos := Len(aRegC185)
	aAdd (aRegC185[nPos], Len(aRegC180))                   		     //-Relacao com C180
	aAdd (aRegC185[nPos], "C185")						  			//01 - REG
	aAdd (aRegC185[nPos], cCstCof)									//02 - CST_PIS
	aAdd (aRegC185[nPos], (cAliasSFT)->FT_CFOP)				   	//03 - CFOP
	aAdd (aRegC185[nPos], nValorItem)				 				//04 - VL_ITEM
	aAdd (aRegC185[nPos], (cAliasSFT)->FT_DESCONT)					//05 - VL_DESC

	lPauta:=.F.

	If (cAliasSFT)->FT_VALCOF > 0
		If (lPautaCOF .And. (cAliasSFT)->FT_PAUTCOF > 0) .OR. (cAliasSB1)->B1_VLR_COF > 0
			aBaseAlqUn	:=	VlrPauta(lCmpNRecFT, lCmpNRecB1, "COF",cAliasSFT,cAliasSB1,lCmpNRecF4,lPautaCOF)
			nCofPauta 	:= 	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][1] , Iif((cAliasSFT)->FT_PAUTCOF > 0,(cAliasSFT)->FT_PAUTCOF,(cAliasSB1)->B1_VLR_COF))
			nQtdBCof  	:= 	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][2] , (cAliasSFT)->FT_QUANT)
			nValCof		:=	(cAliasSFT)->FT_VALCOF
			If  (cAliasSFT)->FT_CSTCOF <> "02"
				lPauta		:=	.T.
			EndIf	
		EndIF
	EndIF

	If !lDevolucao
		nBaseCof  	:= 	Iif(cCstCof=="05",(cAliasSFT)->FT_BASECF3,(cAliasSFT)->FT_BASECOF)
		nAliqCof  	:= 	Iif(cCstCof=="05",(cAliasSFT)->FT_ALIQCF3,(cAliasSFT)->FT_ALIQCOF)
		nValCof		:=	Iif(cCstCof=="05",(cAliasSFT)->FT_VALCF3,(cAliasSFT)->FT_VALCOF)
		MajAliqVal(@nAliqCof,@nValCof,cAliasSFT,lCpoMajAli)
	Elseif nPosDev > 0
		nBaseCof  	:= 	(cAliasSFT)->FT_BASECOF - aDevMsmPer[nPosDev][9]
		nAliqCof  	:= 	Iif(lCofZero,0,(cAliasSFT)->FT_ALIQCOF)
		nValCof		:=	Iif(lCofZero,0,(cAliasSFT)->FT_VALCOF - aDevMsmPer[nPosDev][10])
		nQtdBCof	:=	0
		MajAliqVal(@nAliqCof,@nValCof,cAliasSFT,lCpoMajAli)
	Else
		nBaseCof  	:=	0
		nAliqCof  	:=	Iif(lCofZero,0,(cAliasSFT)->FT_ALIQCOF)
		nValCof		:=	0
		nQtdBCof	:=	0
	EndIF

	aAdd (aRegC185[nPos], Iif(lPauta,"",nBaseCof))									//06 - VL_BC_PIS
	aAdd (aRegC185[nPos], Iif(lPauta,"",nAliqCof))									//07 - ALIQ_PIS
	aAdd (aRegC185[nPos], Iif(lPauta,nQtdBCof,""))									//08 - QUANT_BC_PIS
	aAdd (aRegC185[nPos], Iif(lPauta,Iif(lCofZero,0,nCofPauta),""))				//09 - ALIQ_PIS_QUANT
	aAdd (aRegC185[nPos], nValCof)													//10 - VL_PIS
	aAdd (aRegC185[nPos], cConta)													//11 - COD_CTA

	If lConsolid
		RegM610(aRegM610,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM620,,,,IIF(dDataDe >= CTOD("01/07/2012"),0,(cAliasSFT)->FT_VALCONT),cAliasSB1,,,,,aPar,,aDevMsmPer,,lSt2030)

		If cCstCof $ "04/05/06/07/08/09"
			If !cCstCof $ "05" //se for CST 04, 06, 07, 08, 09 grava M400 direto
				RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1,,,,IIF(dDataDe >= CTOD("01/07/2012"),0,(cAliasSFT)->FT_VALCONT))
			ElseIF (cAliasSFT)->FT_ALIQCF3 == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
				RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1,,,,IIF(dDataDe >= CTOD("01/07/2012"),0,(cAliasSFT)->FT_VALCONT))
			EndIF
		EndIF

	EndiF

Else
	nPosRetur := nPosC180
	If !lRecursivo
		aRegC180[nPosC180][8]+= ((cAliasSFT)->FT_VALCONT)
	EndIF

	//C181
	lPauta:=.F.
	If (cAliasSFT)->FT_VALPIS > 0
		If (lPautaPIS .And. (cAliasSFT)->FT_PAUTPIS > 0) .OR. (cAliasSB1)->B1_VLR_PIS > 0
			aBaseAlqUn	:=	VlrPauta(lCmpNRecFT, lCmpNRecB1, "PIS",cAliasSFT,cAliasSB1,lCmpNRecF4,lPautaPIS)
			nPisPauta 	:= 	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][1] , Iif((cAliasSFT)->FT_PAUTPIS > 0,(cAliasSFT)->FT_PAUTPIS,(cAliasSB1)->B1_VLR_PIS))
			nQtdBPis  	:= 	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][2] , (cAliasSFT)->FT_QUANT)
			nValPis		:=	(cAliasSFT)->FT_VALPIS
			lPauta		:=	.T.
		EndIF
	EndIF

	If !lDevolucao
		nBasePis  	:= 	Iif(cCstPis == "05",(cAliasSFT)->FT_BASEPS3,(cAliasSFT)->FT_BASEPIS)
		nAliqPis  	:= 	Iif(cCstPis == "05",(cAliasSFT)->FT_ALIQPS3,(cAliasSFT)->FT_ALIQPIS)
		nValPis		:=	Iif(cCstPis == "05",(cAliasSFT)->FT_VALPS3,(cAliasSFT)->FT_VALPIS)
		MajAliqPis(@nAliqPis,@nValPis,cAliasSFT)
	Elseif nPosDev > 0
		nBasePis  	:= 	(cAliasSFT)->FT_BASEPIS - aDevMsmPer[nPosDev][7]
		nAliqPis  	:= 	Iif(lPisZero,0,(cAliasSFT)->FT_ALIQPIS)
		nValPis		:=	Iif(lPisZero,0,(cAliasSFT)->FT_VALPIS - aDevMsmPer[nPosDev][8])
		nQtdBPis	:=	0
		MajAliqPis(@nAliqPis,@nValPis,cAliasSFT)
	Else
		nBasePis  	:=	0
		nAliqPis  	:=	Iif(lPisZero,0,(cAliasSFT)->FT_ALIQPIS)
		nValPis		:=	0
		nQtdBPis	:=	0
	EndIF

	If lPauta
		nPosC181 := aScan (aRegC181, {|aX| aX[1]==nPosC180 .AND. aX[3]==cCstPis .AND. aX[4]==(cAliasSFT)->FT_CFOP .AND. cvaltochar(aX[10])==cvaltochar(Iif(lPisZero,0, nPisPauta)) .AND. aX[12]==cConta})
	Else
		nPosC181 := aScan (aRegC181, {|aX| aX[1]==nPosC180 .AND. aX[3]==cCstPis .AND. aX[4]==(cAliasSFT)->FT_CFOP .AND. cvaltochar(aX[8])==cvaltochar(nAliqPis) .AND. aX[12]==cConta})
	EndIF
	If nPosC181 ==0
		aAdd(aRegC181, {})
		nPos := Len(aRegC181)
		aAdd (aRegC181[nPos], nPosC180)                        							//-Relacao com C180
		aAdd (aRegC181[nPos], "C181")						  							//01 - REG
		aAdd (aRegC181[nPos], cCstPis)								 					//02 - CST_PIS
		aAdd (aRegC181[nPos], (cAliasSFT)->FT_CFOP)				   					//03 - CFOP
		aAdd (aRegC181[nPos], nValorItem)												//04 - VL_ITEM
		aAdd (aRegC181[nPos], (cAliasSFT)->FT_DESCONT)									//05 - VL_DESC
		aAdd (aRegC181[nPos], Iif(lPauta,"",nBasePis))									//06 - VL_BC_PIS
		aAdd (aRegC181[nPos], Iif(lPauta,"",nAliqPis))									//07 - ALIQ_PIS
		aAdd (aRegC181[nPos], Iif(lPauta,nQtdBPis,""))									//08 - QUANT_BC_PIS
		aAdd (aRegC181[nPos], Iif(lPauta,Iif(lPisZero,0,nPisPauta),""))				//09 - ALIQ_PIS_QUANT
		aAdd (aRegC181[nPos], nValPis)													//10 - VL_PIS
		aAdd (aRegC181[nPos], cConta)													//11 - COD_CTA

	Else
		aRegC181[nPosC181][5]+= nValorItem								 				//04 - VL_ITEM
		aRegC181[nPosC181][6]+= (cAliasSFT)->FT_DESCONT	            				//05 - VL_DESC
		If lPauta
			aRegC181[nPosC181][9]	+=	nQtdBPis
		Else
			aRegC181[nPosC181][7]	+=	nBasePis
		EndIf

		aRegC181[nPosC181][11]	+=	nValPis
	EndIf
	If lConsolid
		RegM210(aRegM210,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM220,,,@aRegM230,IIF(dDataDe >= CTOD("01/07/2012"),0,(cAliasSFT)->FT_VALCONT),cAliasSB1,,,,,aPar,,aDevMsmPer,,lSt2030)

		If cCstPis $ "04/05/06/07/08/09"
			If !cCstPis $ "05" //se for CST 04, 06, 07, 08, 09 grava M400 direto
				RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1,,,,IIF(dDataDe >= CTOD("01/07/2012"),0,(cAliasSFT)->FT_VALCONT))
			ElseIF (cAliasSFT)->FT_ALIQPS3 == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
				RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1,,,,IIF(dDataDe >= CTOD("01/07/2012"),0,(cAliasSFT)->FT_VALCONT))
			EndIF
		EndIF

	EndIF

	//C185
	lPauta:=.F.
	If (cAliasSFT)->FT_VALCOF > 0
		If (lPautaCOF .And. (cAliasSFT)->FT_PAUTCOF > 0) .OR. (cAliasSB1)->B1_VLR_COF > 0
			aBaseAlqUn	:=	VlrPauta(lCmpNRecFT, lCmpNRecB1, "COF",cAliasSFT,cAliasSB1,lCmpNRecF4,lPautaCOF)
			nCofPauta 	:= 	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][1] , Iif((cAliasSFT)->FT_PAUTCOF > 0,(cAliasSFT)->FT_PAUTCOF,(cAliasSB1)->B1_VLR_COF))
			nQtdBCof  	:= 	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][2] , (cAliasSFT)->FT_QUANT)
			nValCof		:=	(cAliasSFT)->FT_VALCOF
			lPauta		:=	.T.
		EndIF
	EndIF

	If !lDevolucao
		nBaseCof  	:= 	Iif(cCstCof=="05",(cAliasSFT)->FT_BASECF3,(cAliasSFT)->FT_BASECOF)
		nAliqCof  	:= 	Iif(cCstCof=="05",(cAliasSFT)->FT_ALIQCF3,(cAliasSFT)->FT_ALIQCOF)
		nValCof		:=	Iif(cCstCof=="05",(cAliasSFT)->FT_VALCF3,(cAliasSFT)->FT_VALCOF)
		MajAliqVal(@nAliqCof,@nValCof,cAliasSFT,lCpoMajAli)
	Elseif nPosDev > 0
		nBaseCof  	:= 	(cAliasSFT)->FT_BASECOF - aDevMsmPer[nPosDev][9]
		nAliqCof  	:= 	Iif(lCofZero,0,(cAliasSFT)->FT_ALIQCOF)
		nValCof		:=	Iif(lCofZero,0,(cAliasSFT)->FT_VALCOF - aDevMsmPer[nPosDev][10])
		nQtdBCof	:=	0
		MajAliqVal(@nAliqCof,@nValCof,cAliasSFT,lCpoMajAli)
	Else
		nBaseCof  	:=	0
		nAliqCof  	:=	Iif(lCofZero,0,(cAliasSFT)->FT_ALIQCOF)
		nValCof		:=	0
		nQtdBCof	:=	0
	EndIF

	If lPauta
		nPosC185 := aScan (aRegC185, {|aX| aX[1]==nPosC180 .AND.  aX[3]==cCstCof .AND. aX[4]==(cAliasSFT)->FT_CFOP .AND. cVAlToChar(aX[10])==cValToChar(Iif(lCofZero,0,nCofPauta)) .AND. aX[12]==cConta})
	Else
		nPosC185 := aScan (aRegC185, {|aX| aX[1]==nPosC180 .AND.  aX[3]==cCstCof .AND. aX[4]==(cAliasSFT)->FT_CFOP .AND. cVAlToChar(aX[8])==cVAlToChar(nAliqCof) .AND. aX[12]==cConta})
	endIF
	If nPosC185 ==0
		aAdd(aRegC185, {})
		nPos := Len(aRegC185)
		aAdd (aRegC185[nPos], nPosC180)                        									//-Relacao com C180
		aAdd (aRegC185[nPos], "C185")						  									//01 - REG
		aAdd (aRegC185[nPos], cCstCof)											//02 - CST_PIS
		aAdd (aRegC185[nPos], (cAliasSFT)->FT_CFOP)				   							//03 - CFOP
		aAdd (aRegC185[nPos],  nValorItem)			 											//04 - VL_ITEM
		aAdd (aRegC185[nPos], (cAliasSFT)->FT_DESCONT)											//05 - VL_DESC
		aAdd (aRegC185[nPos], Iif(lPauta,"",nBaseCof))											//06 - VL_BC_COF
		aAdd (aRegC185[nPos], Iif(lPauta,"",nAliqCof))											//07 - ALIQ_PIS
		aAdd (aRegC185[nPos], Iif(lPauta,nQtdBCof,""))											//08 - QUANT_BC_PIS
		aAdd (aRegC185[nPos], Iif(lPauta,Iif(lCofZero,0,nCofPauta),""))						//09 - ALIQ_PIS_QUANT
		aAdd (aRegC185[nPos], nValCof)													   		//10 - VL_PIS
		aAdd (aRegC185[nPos], cConta)															//11 - COD_CTA

	Else
		aRegC185[nPosC185][5]+= nValorItem														//04 - VL_ITEM
		aRegC185[nPosC185][6]+= (cAliasSFT)->FT_DESCONT	            						//05 - VL_DESC
		If lPauta
			aRegC185[nPosC185][9]	+=	nQtdBCof												//08 - QUANT_BC_PIS
		Else
			aRegC185[nPosC185][7]	+=	nBaseCof												//06 - VL_BC_PIS
		EndIF
		aRegC185[nPosC185][11]	+=	nValCof														//10 - VL_PIS
	EndIf

	If lConsolid
		RegM610(aRegM610,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM620,,,@aRegM630,IIF(dDataDe >= CTOD("01/07/2012"),0,(cAliasSFT)->FT_VALCONT),cAliasSB1,,,,,aPar,,aDevMsmPer,,lSt2030)

		If cCstCof $ "04/05/06/07/08/09"
			If !cCstCof $ "05" //se for CST 04, 06, 07, 08, 09 grava M400 direto
				RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1,,,,IIF(dDataDe >= CTOD("01/07/2012"),0,(cAliasSFT)->FT_VALCONT))
			ElseIF (cAliasSFT)->FT_ALIQCF3 == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
				RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1,,,,IIF(dDataDe >= CTOD("01/07/2012"),0,(cAliasSFT)->FT_VALCONT))
			EndIF
		EndIF

	EndiF
EndIf

IF lSt2030 .AND. !lRecursivo //Chama novamente a funo para gravar registro
	RegC180(aRegC180,aRegC181,aRegC185,aReg0500,cAliasSFT,dDataDe, dDataAte,cProd,nPosRetur,aWizard,lConsolid, ;
						aRegM210,aRegM610,aRegM400,aRegM410,aRegM800,aRegM810,lCumulativ,lPisZero, lCofZero,aDevolucao,;
						aRegM220,aRegM620,aRegM230,aRegM630,cAliasSB1,aDevMsmPer,nPosDev,lCpoMajAli,.T.,"01")
EndIF


Return


Static Function RegC190(aRegC190,aRegC191,aRegC195,aReg0500,cAliasSFT,dDataDe, dDataAte,cProd,nPosRetur,aPartDoc,lCumulativ,;
						lConsolid,aRegAuxM105,aRegAuxM505,cRegime,cIndApro,aReg0111,cAliasSB1,lDevComp,nPosDevCmp,aDevCpMsmP)

Local 	nPos		:=	0
Local 	nPosC190	:=	0
Local 	nPosC191	:=	0
Local 	nPosC195	:=	0
Local 	nCofPauta 	:=	0
Local 	nPisPauta 	:=	0
Local 	lPauta 		:=	.F.
Local	lPautaPIS	:=	aFieldPos[20]
Local	lPautaCOF	:=	aFieldPos[21]
Local 	cCnpj		:=	""
Local 	cConta 		:=	Reg0500(@aReg0500,(cAliasSFT)->FT_CONTA,,cAliasSFT)
Local 	nQtdBPis	:= 	0
Local 	nQtdBCof	:= 	0
Local 	aBaseAlqUn 	:= 	{}
Local 	cChaveCCZ	:= 	""
local 	nBaCalcPis	:= 	0
local 	nBaCalcCOF	:= 	0
local 	nValPis		:= 	0
local 	nValCOf		:= 	0
Local 	nAliCof		:=	0
Local   nAliPis     :=	0

If aPartDoc[13] == "EX"
  cCnpj := "99999999999999"
Elseif aPartDoc[4] <> ""
  cCnpj := aPartDoc[4]
ElseIf aPartDoc[5] <> ""
  cCnpj := aPartDoc[5]
EndIF

nPosC190 := aScan (aRegC190, {|aX| aX[5]==AllTrim(cProd)})

If nPosC190 ==0
	aAdd(aRegC190, {})
	nPos := Len(aRegC190)
	nPosRetur := nPos
	aAdd (aRegC190[nPos], "C190")						  			//01 - REG
	aAdd (aRegC190[nPos], "55")				   						//02 - COD_MOD
	aAdd (aRegC190[nPos], dDataDe)				   					//03 - DT_DOC_INI
	aAdd (aRegC190[nPos], dDataAte)				   					//04 - DT_DOC_FIN
	aAdd (aRegC190[nPos], AllTrim(cProd))							//05 - COD_ITEM

	aAdd (aRegC190[nPos], (cAliasSB1)->B1_POSIPI)					//06 - COD_NCM
	aAdd (aRegC190[nPos], (cAliasSB1)->B1_EX_NCM)		   			//07 - EX_IPI
	aAdd (aRegC190[nPos], (cAliasSFT)->FT_VALCONT)					//08 - VL_TOT_ITEM

	//C191
	aAdd(aRegC191, {})
	nPos := Len(aRegC191)
	aAdd (aRegC191[nPos], Len(aRegC190))                        //-Relacao com C180
	aAdd (aRegC191[nPos], "C191")						  		//01 - REG
	aAdd (aRegC191[nPos], cCnpj)								//02 - CNPJ_CPF_PART
	aAdd (aRegC191[nPos], (cAliasSFT)->FT_CSTPIS)				//03 - CST_PIS
	aAdd (aRegC191[nPos], (cAliasSFT)->FT_CFOP)				//04 - CFOP
	aAdd (aRegC191[nPos], (cAliasSFT)->FT_TOTAL)				//05 - VL_ITEM
	aAdd (aRegC191[nPos], (cAliasSFT)->FT_DESCONT)				//06 - VL_DESC

	lPauta:=.F.
	If (cAliasSFT)->FT_VALPIS > 0
		If (lPautaPIS .And. (cAliasSFT)->FT_PAUTPIS > 0) .OR. (cAliasSB1)->B1_VLR_PIS > 0
			aBaseAlqUn:=VlrPauta(lCmpNRecFT, lCmpNRecB1, "PIS",cAliasSFT,cAliasSB1,lCmpNRecF4,lPautaPIS)
			nPisPauta := Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][1] , Iif((cAliasSFT)->FT_PAUTPIS > 0,(cAliasSFT)->FT_PAUTPIS,(cAliasSB1)->B1_VLR_PIS))
			nQtdBPis  := Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][2] , (cAliasSFT)->FT_QUANT)
			lPauta:=.T.
		EndIF
	EndIF

	IF lDevComp
		nBaCalcPis	:= (cAliasSFT)->FT_BASEPIS - aDevCpMsmP[nPosDevCmp][7]
		nValPis		:= (cAliasSFT)->FT_VALPIS - aDevCpMsmP[nPosDevCmp][8]
		nQtdBPis	:=0
		IF !lPauta
			nValPis		:= Round((nBaCalcPis * (cAliasSFT)->FT_ALIQPIS)/100 ,2)
		EndIF
	Else
		nBaCalcPis	:= (cAliasSFT)->FT_BASEPIS
		nValPis		:= (cAliasSFT)->FT_VALPIS - IiF(aFieldPos[29],(cAliasSFT)->FT_MVALPIS,0)
	EndIf

	nAliPis := (cAliasSFT)->FT_ALIQPIS - IiF(aFieldPos[28],(cAliasSFT)->FT_MALQPIS,0)

	aAdd (aRegC191[nPos], Iif(lPauta,"",nBaCalcPis))				//07 - VL_BC_PIS
	aAdd (aRegC191[nPos], Iif(lPauta,"",nAliPis	))					//08 - ALIQ_PIS
	aAdd (aRegC191[nPos], Iif(lPauta,nQtdBPis,""))					//09 - QUANT_BC_PIS
	aAdd (aRegC191[nPos], Iif(lPauta,nPisPauta,""))				//10 - ALIQ_PIS_QUANT
	aAdd (aRegC191[nPos], nValPis)				   					//11 - VL_PIS
	aAdd (aRegC191[nPos], cConta )									//12 - COD_CTA

	//C195
	aAdd(aRegC195, {})
	nPos := Len(aRegC195)
	aAdd (aRegC195[nPos], Len(aRegC190))                        	//-Relacao com C180
	aAdd (aRegC195[nPos], "C195")						  			//01 - REG
	aAdd (aRegC195[nPos], cCnpj)									//02 - CNPJ_CPF_PART
	aAdd (aRegC195[nPos], (cAliasSFT)->FT_CSTCOF)					//03 - CST_COFINS
	aAdd (aRegC195[nPos], (cAliasSFT)->FT_CFOP)				   	//04 - CFOP
	aAdd (aRegC195[nPos], (cAliasSFT)->FT_TOTAL)					//05 - VL_ITEM
	aAdd (aRegC195[nPos], (cAliasSFT)->FT_DESCONT)					//06 - VL_DESC


	lPauta:=.F.
	If (cAliasSFT)->FT_VALCOF > 0
		If (lPautaCOF .And. (cAliasSFT)->FT_PAUTCOF > 0) .OR. (cAliasSB1)->B1_VLR_COF > 0
			aBaseAlqUn:=VlrPauta(lCmpNRecFT, lCmpNRecB1, "COF",cAliasSFT,cAliasSB1,lCmpNRecF4,lPautaCOF)
			nCofPauta := Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][1] , Iif((cAliasSFT)->FT_PAUTCOF > 0,(cAliasSFT)->FT_PAUTCOF,(cAliasSB1)->B1_VLR_COF))
			nQtdBCof  := Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][2] , (cAliasSFT)->FT_QUANT)
			lPauta:=.T.
		EndIF
	EndIF

	IF lDevComp
		nBaCalcCof	:= (cAliasSFT)->FT_BASECOF - aDevCpMsmP[nPosDevCmp][9]
		nValCof		:=(cAliasSFT)->FT_VALCOF - aDevCpMsmP[nPosDevCmp][10] - IiF(aFieldPos[16],(cAliasSFT)->FT_MVALCOF,0)
		nQtdBCof	:=0
	Else
		nBaCalcCof	:= (cAliasSFT)->FT_BASECOF
		nValCof		:= (cAliasSFT)->FT_VALCOF - IiF(aFieldPos[16],(cAliasSFT)->FT_MVALCOF,0)
	EndIf

	aAdd (aRegC195[nPos], Iif(lPauta,"", nBaCalcCof))				//07 - VL_BC_COFINS
	aAdd (aRegC195[nPos], Iif(lPauta,"",(cAliasSFT)->FT_ALIQCOF - IiF(aFieldPos[15],(cAliasSFT)->FT_MALQCOF,0)))	//08 - ALIQ_COFINS
	aAdd (aRegC195[nPos], Iif(lPauta,nQtdBCof,""))					//09 - QUANT_BC_COFINS
	aAdd (aRegC195[nPos], Iif(lPauta,nCofPauta,""))				//10 - ALIQ_COFINS_QUANT
	aAdd (aRegC195[nPos], nValCof)				   					//11 - VL_COFINS
	aAdd (aRegC195[nPos], cConta)									//12 - COD_CTA
Else
	aRegC190[nPosC190][8]+= ((cAliasSFT)->FT_VALCONT)              //08 - VL_TOT_ITEM
	nPosRetur := nPosC190
	//C191

	lPauta:=.F.
	If (cAliasSFT)->FT_VALPIS > 0
		If (lPautaPIS .And. (cAliasSFT)->FT_PAUTPIS > 0) .OR. (cAliasSB1)->B1_VLR_PIS > 0
			aBaseAlqUn:=VlrPauta(lCmpNRecFT, lCmpNRecB1, "PIS",cAliasSFT,cAliasSB1,lCmpNRecF4,lPautaPIS)
			nPisPauta := Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][1] , Iif((cAliasSFT)->FT_PAUTPIS > 0,(cAliasSFT)->FT_PAUTPIS,(cAliasSB1)->B1_VLR_PIS))
			nQtdBPis  := Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][2] , (cAliasSFT)->FT_QUANT)
			lPauta:=.T.
		EndIF
	EndIF

	IF lDevComp
		nBaCalcPis	:= (cAliasSFT)->FT_BASEPIS - aDevCpMsmP[nPosDevCmp][7]
		nValPis		:= (cAliasSFT)->FT_VALPIS - aDevCpMsmP[nPosDevCmp][8]
		nQtdBPis	:=0
		IF !lPauta
			nValPis		:= Round((nBaCalcPis * (cAliasSFT)->FT_ALIQPIS)/100 ,2)
		EndIF
	Else
		nBaCalcPis	:= (cAliasSFT)->FT_BASEPIS
		nValPis		:= (cAliasSFT)->FT_VALPIS - IiF(aFieldPos[29],(cAliasSFT)->FT_MVALPIS,0)
	EndIf

	nAliPis := (cAliasSFT)->FT_ALIQPIS - IiF(aFieldPos[28],(cAliasSFT)->FT_MALQPIS,0)

	If lPauta
		nPosC191 := aScan (aRegC191, {|aX| aX[1]==nPosC190 .AND. aX[3]==cCnpj .AND. aX[4]==(cAliasSFT)->FT_CSTPIS .AND. aX[5]==(cAliasSFT)->FT_CFOP .AND. cvaltochar(aX[11])==cvaltochar(nPisPauta) .AND. aX[13]==cConta})
	Else
		nPosC191 := aScan (aRegC191, {|aX| aX[1]==nPosC190 .AND. aX[3]==cCnpj .AND. aX[4]==(cAliasSFT)->FT_CSTPIS .AND. aX[5]==(cAliasSFT)->FT_CFOP .AND. cvaltochar(aX[9])==cvaltochar(nAliPis) .AND. aX[13]==cConta})
	EndIF
	If nPosC191 ==0
		aAdd(aRegC191, {})
		nPos := Len(aRegC191)
		aAdd (aRegC191[nPos], nPosC190)                        			//-Relacao com C180
		aAdd (aRegC191[nPos], "C191")						  			//01 - REG
		aAdd (aRegC191[nPos], cCnpj)									//02 - CNPJ_CPF_PART
		aAdd (aRegC191[nPos], (cAliasSFT)->FT_CSTPIS)					//03 - CST_PIS
		aAdd (aRegC191[nPos], (cAliasSFT)->FT_CFOP)				   	//04 - CFOP
		aAdd (aRegC191[nPos], (cAliasSFT)->FT_TOTAL)					//05 - VL_ITEM
		aAdd (aRegC191[nPos], (cAliasSFT)->FT_DESCONT)					//06 - VL_DESC
		aAdd (aRegC191[nPos], Iif(lPauta,"",nBaCalcPis))				//07 - VL_BC_PIS
		aAdd (aRegC191[nPos], Iif(lPauta,"",nAliPis))					//08 - ALIQ_PIS
		aAdd (aRegC191[nPos], Iif(lPauta,nQtdBPis,""))					//09 - QUANT_BC_PIS
		aAdd (aRegC191[nPos], Iif(lPauta,nPisPauta,""))				//10 - ALIQ_PIS_QUANT
		aAdd (aRegC191[nPos], nValPis)				   					//11 - VL_PIS
		aAdd (aRegC191[nPos], cConta)									//12 - COD_CTA

	Else
		aRegC191[nPosC191][6]+= (cAliasSFT)->FT_TOTAL					//05 - VL_ITEM
		aRegC191[nPosC191][7]+= (cAliasSFT)->FT_DESCONT				//06 - VL_DESC
		If lPauta
			aRegC191[nPosC191][10]+= nQtdBPis							//10 - ALIQ_PIS_QUANT
		Else
			aRegC191[nPosC191][8]+= nBaCalcPis							//07 - VL_BC_PIS
		EndIF
		aRegC191[nPosC191][12]+=nValPis	//11 - VL_PIS
	EndIf

	//C195
	lPauta:=.F.
	If (cAliasSFT)->FT_VALCOF > 0
		If (lPautaCOF .And. (cAliasSFT)->FT_PAUTCOF > 0) .OR. (cAliasSB1)->B1_VLR_COF > 0
			aBaseAlqUn:=VlrPauta(lCmpNRecFT, lCmpNRecB1, "COF",cAliasSFT,cAliasSB1,lCmpNRecF4,lPautaCOF)
			nCofPauta := Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][1] , Iif((cAliasSFT)->FT_PAUTCOF > 0,(cAliasSFT)->FT_PAUTCOF,(cAliasSB1)->B1_VLR_COF))
			nQtdBCof  := Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][2] , (cAliasSFT)->FT_QUANT)
			lPauta:=.T.
		EndIF
	EndIF

	IF lDevComp
		nBaCalcCof	:= (cAliasSFT)->FT_BASECOF - aDevCpMsmP[nPosDevCmp][9]
		nValCof		:=(cAliasSFT)->FT_VALCOF - aDevCpMsmP[nPosDevCmp][10] - IiF(aFieldPos[16],(cAliasSFT)->FT_MVALCOF,0)
		nQtdBCof	:=0
	Else
		nBaCalcCof	:= (cAliasSFT)->FT_BASECOF
		nValCof		:=(cAliasSFT)->FT_VALCOF - IiF(aFieldPos[16],(cAliasSFT)->FT_MVALCOF,0)
	EndIf

	nAliCof := (cAliasSFT)->FT_ALIQCOF - IiF(aFieldPos[15],(cAliasSFT)->FT_MALQCOF,0)

	If lPauta
		nPosC195 := aScan (aRegC195, {|aX| aX[1]==nPosC190 .AND. aX[3]==cCnpj .AND. aX[4]==(cAliasSFT)->FT_CSTCOF .AND. aX[5]==(cAliasSFT)->FT_CFOP .AND. cvaltochar(aX[11])==cvaltochar(nCofPauta) .AND. aX[13]==cConta})
	Else
		nPosC195 := aScan (aRegC195, {|aX| aX[1]==nPosC190 .AND. aX[3]==cCnpj .AND. aX[4]==(cAliasSFT)->FT_CSTCOF .AND. aX[5]==(cAliasSFT)->FT_CFOP .AND. cvaltochar(aX[9])==cvaltochar(nAliCof) .AND. aX[13]==cConta})
	EndIF

	If nPosC195 ==0
		aAdd(aRegC195, {})
		nPos := Len(aRegC195)
		aAdd (aRegC195[nPos], nPosC190)                        			//-Relacao com C180
		aAdd (aRegC195[nPos], "C195")						  			//01 - REG
		aAdd (aRegC195[nPos], cCnpj)									//02 - CNPJ_CPF_PART
		aAdd (aRegC195[nPos], (cAliasSFT)->FT_CSTCOF)					//03 - CST_COFINS
		aAdd (aRegC195[nPos], (cAliasSFT)->FT_CFOP)				   	//04 - CFOP
		aAdd (aRegC195[nPos], (cAliasSFT)->FT_TOTAL)					//05 - VL_ITEM
		aAdd (aRegC195[nPos], (cAliasSFT)->FT_DESCONT)					//06 - VL_DESC
		aAdd (aRegC195[nPos], Iif(lPauta,"", nBaCalcCof))				//07 - VL_BC_COFINS
		aAdd (aRegC195[nPos], Iif(lPauta,"",nAliCof))					//08 - ALIQ_COFINS
		aAdd (aRegC195[nPos], Iif(lPauta,nQtdBCof,""))					//09 - QUANT_BC_COFINS
		aAdd (aRegC195[nPos], Iif(lPauta,nCofPauta,""))				//10 - ALIQ_COFINS_QUANT
		aAdd (aRegC195[nPos], nValCof)				   					//11 - VL_COFINS
		aAdd (aRegC195[nPos], cConta)									//12 - COD_CTA

	Else
		aRegC195[nPosC195][6]+= ((cAliasSFT)->FT_TOTAL)				//05 - VL_ITEM
		aRegC195[nPosC195][7]+= ((cAliasSFT)->FT_DESCONT)	            //06 - VL_DESC
		If lPauta
			aRegC195[nPosC195][10]+= nQtdBCof							//09 - QUANT_BC_COFINS
		Else
			aRegC195[nPosC195][8]+= nBaCalcCof							//07 - VL_BC_COFINS
		EndIF
		aRegC195[nPosC195][12]+= nValCof								//11 - VL_COFINS
	EndIf

EndIf

// Alterao em: 24/05/2011
If lConsolid
	//PIS
	If (cAliasSFT)->FT_CSTPIS $ "50/51/52/53/54/55/56/60/61/62/63/64/65/66"
		AcumM105(aRegAuxM105,cAliasSFT,cRegime,lCumulativ,cIndApro,aReg0111,,,,,cAliasSB1,,aDevCpMsmP,nPosDevCmp)
	EndIF

	//COFINS
	If (cAliasSFT)->FT_CSTCOF $ "50/51/52/53/54/55/56/60/61/62/63/64/65/66"
		AcumM505(aRegAuxM505,cAliasSFT,cRegime,lCumulativ,cIndApro,aReg0111,,,,,cAliasSB1,,aDevCpMsmP,nPosDevCmp)
	EndIF
EndIF
Return


Static Function RegC199(aRegC199,nPosC190,aAverage,cAlsSF,cAliasCD5,cMVEASY,lTop,cAliasSF1,cChvCD5)

	Local	nPos		:= 0
	Local	lAcDraw		:= aFieldPos[37]
	Local	cAcDraw		:= ""
	Local	cDocImp		:= ""
	Local   cHAWB		:= ""
	Local 	cFilCD5		:= xFilial(cAliasCD5)
	Local 	cChvWhl		:= ""

	IF lTop
		cHAWB	:= (cAliasSF1)->F1_HAWB
	Else
		cHAWB	:= (cAlsSF)->F1_HAWB
	EndIF

	//Tratamento para quando houver integracao com o SIGAEIC
	If cMVEASY=="S" .And. Len(aAverage)>0 .And. !Empty(cHAWB)
		If (nPos := aScan (aRegC199, {|aX| aX[1]==nPosC190 .AND. aX[4]==aAverage[1][2][2][2][1]})==0)
			aAdd(aRegC199, {})
			nPos	:=	Len (aRegC199)
			aAdd (aRegC199[nPos], nPosC190)								//Relacionamento com o registro pai
			aAdd (aRegC199[nPos], "C199")								//01 - REG
			aAdd (aRegC199[nPos], aAverage[1][2][1][2][1])			//02 - TP_DOC_IMP
			aAdd (aRegC199[nPos], aAverage[1][2][2][2][1])			//03 - COD_DOC_IMP
			aAdd (aRegC199[nPos], aAverage[1][2][3][2][1])			//04 - PIS_IMP
			aAdd (aRegC199[nPos], aAverage[1][2][4][2][1])			//05 - COF_IMP
			aAdd (aRegC199[nPos], "")									//06 - NUM_ACDRAW
		Endif
	//Se NAO houver integracao com o SIGAEIC, a tabela CD5 jah estah posicionada, 
	//  senao NAO entraria na funcao                                              
	Else
		cChvWhl := cFilCD5+(cAliasCD5)->(CD5_DOC+CD5_SERIE+CD5_FORNEC+CD5_LOJA+CD5_ITEM)
		While !(cAliasCD5)->(Eof()) .AND. (cChvWhl==cChvCD5)

			cAcDraw	:=	Iif(lAcDraw,(cAliasCD5)->CD5_ACDRAW	,"")
			cDocImp	:=	(cAliasCD5)->CD5_DOCIMP

			//Nao podem ser informados para um mesmo documento fiscal, dois ou mais registros  
			// com o mesmo conteudo no campo NUM_DOC_IMP e NUM_ACDRAW                			
			If (nPos := aScan(aRegC199, {|aZ| aZ[1]==nPosC190 .And. aZ[7] == cAcDraw .And. aZ[4] == cDocImp})) == 0
				aAdd(aRegC199, {})
				nPos	:=	Len (aRegC199)
				aAdd (aRegC199[nPos], nPosC190)							//Relacionamento com o registro pai
				aAdd (aRegC199[nPos], "C199")							//01 - REG
				aAdd (aRegC199[nPos], (cAliasCD5)->CD5_TPIMP)			//02 - TP_DOC_IMP
				aAdd (aRegC199[nPos], (cAliasCD5)->CD5_DOCIMP)			//03 - COD_DOC_IMP
				aAdd (aRegC199[nPos], (cAliasCD5)->CD5_VLPIS)			//04 - PIS_IMP
				aAdd (aRegC199[nPos], (cAliasCD5)->CD5_VLCOF)			//05 - COF_IMP
				If lAcDraw
					aAdd (aRegC199[nPos], (cAliasCD5)->CD5_ACDRAW)		//06 - NUM_ACDRAW - LAYOUT 2010
				Else
					aAdd (aRegC199[nPos], "")							//06 - NUM_ACDRAW - LAYOUT 2010
				EndIf
			Else
				aRegC199[nPos][5]	+=	(cAliasCD5)->CD5_VLPIS			//04 - PIS_IMP
				aRegC199[nPos][6]	+=	(cAliasCD5)->CD5_VLCOF			//05 - COF_IMP
			Endif
			(cAliasCD5)->(DbSkip())
			cChvWhl := cFilCD5+(cAliasCD5)->(CD5_DOC+CD5_SERIE+CD5_FORNEC+CD5_LOJA+CD5_ITEM)
		EndDo
	EndIf

Return


Static Function RegC380 (aRegC380,cAliasSFT,dDataDe,dDataAte,cSituaDoc)
	Local	nPos		:=	0
	Local 	lCanc		:= .F.

	If cSituaDoc == "02" //Cancelada
		lCanc := .T.
	Endif

	If Len(aRegC380) ==0
		aAdd(aRegC380, {})
		nPos	:=	Len (aRegC380)
		aAdd (aRegC380[nPos], "C380")										//01 - REG
		aAdd (aRegC380[nPos], "02")				   							//02 - COD_MOD
		aAdd (aRegC380[nPos], dDataDe)										//03 - DT_DOC_INI
		aAdd (aRegC380[nPos], dDataAte)										//04 - DT_DOC_FIN
		aAdd (aRegC380[nPos], Right(AllTrim((cAliasSFT)->FT_NFISCAL),6))	//05 - NUM_DOC_INI
		aAdd (aRegC380[nPos], Right(AllTrim((cAliasSFT)->FT_NFISCAL),6))	//06 - NUM_DOC_FIN
		aAdd (aRegC380[nPos], Iif(lCanc,0, (cAliasSFT)->FT_VALCONT))			//07 - VL_DOC
		aAdd (aRegC380[nPos], IIF(lCanc,(cAliasSFT)->FT_VALCONT,0))			//08 - VL_DOC_CANC
	Else
		If (cAliasSFT)->FT_NFISCAL < aRegC380[1][5]   						//05 - NUM_DOC_INI
			aRegC380[1][5]:= Right(AllTrim((cAliasSFT)->FT_NFISCAL),6)
		EndIf

		If (cAliasSFT)->FT_NFISCAL > aRegC380[1][6]   						//06 - NUM_DOC_FIN
			aRegC380[1][6]:=  Right(AllTrim((cAliasSFT)->FT_NFISCAL),6)
		EndIf
		aRegC380[1][7] +=Iif(lCanc,0, (cAliasSFT)->FT_VALCONT)				//07 - VL_DOC
		aRegC380[1][8] +=IIF(lCanc,(cAliasSFT)->FT_VALCONT,0)				//08 - VL_DOC_CANC

	EndIF
Return


Static Function RegC381(aRegC381,cAliasSFT,cProd,aReg0500,aRegM210,aWizard,aRegM400,aRegM410,lCumulativ,lPisZero,;
						aDevolucao,aRegM220,aRegM230,cAliasSB1)

Local 	nPos		:=	0
Local 	nPosC380 	:=	0
Local 	nPisPauta 	:= 	0
Local 	lPauta	 	:= 	.F.
Local	lPautaPIS	:=	aFieldPos[20]
Local 	cConta 	 	:=	Reg0500(@aReg0500,(cAliasSFT)->FT_CONTA,,cAliasSFT)
Local 	nQtdBPis	:=	0
Local 	cChaveCCZ	:=	""
Local 	aBaseAlqUn 	:=	{}
Local 	nAlqPis		:= 0
Local 	nBasePis	:= 0
Local 	nValPis		:= 0

nAlqPis		:= (cAliasSFT)->FT_ALIQPIS
nBasePis	:= (cAliasSFT)->FT_BASEPIS
nValPis		:= (cAliasSFT)->FT_VALPIS
MajAliqPis(@nAlqPis,@nValPis,cAliasSFT)

lPauta:=.F.
If (cAliasSFT)->FT_VALPIS > 0
	If (lPautaPIS .And. (cAliasSFT)->FT_PAUTPIS > 0) .OR. (cAliasSB1)->B1_VLR_PIS > 0
		aBaseAlqUn:=VlrPauta(lCmpNRecFT, lCmpNRecB1, "PIS",cAliasSFT,cAliasSB1,lCmpNRecF4,lPautaPIS)
		nPisPauta := Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][1] , Iif((cAliasSFT)->FT_PAUTPIS > 0,(cAliasSFT)->FT_PAUTPIS,(cAliasSB1)->B1_VLR_PIS))
		nQtdBPis  := Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][2] , (cAliasSFT)->FT_QUANT)
		lPauta:=.T.
	EndIF
EndIF

If lPauta
	nPosC381 := aScan (aRegC381, {|aX| aX[2]==(cAliasSFT)->FT_CSTPIS .AND. aX[3]==cProd .AND. aX[8]==Iif(lPisZero,0,nPisPauta) .AND. aX[10]==cConta})
Else
	nPosC381 := aScan (aRegC381, {|aX| aX[2]==(cAliasSFT)->FT_CSTPIS .AND. aX[3]==cProd .AND. aX[6]== Iif(lPisZero,0,nAlqPis) .AND. aX[10]==cConta})
EndIf
If nPosC381 ==0
	aAdd(aRegC381, {})
	nPos	:=	Len (aRegC381)
	aAdd (aRegC381[nPos], "C381")														//01 - REG
	aAdd (aRegC381[nPos], (cAliasSFT)->FT_CSTPIS)										//02 - CST_PIS
	aAdd (aRegC381[nPos], cProd)														//03 - COD_ITEM
	aAdd (aRegC381[nPos], (cAliasSFT)->FT_TOTAL)										//04 - VL_ITEM
	aAdd (aRegC381[nPos], Iif(lPauta,"",nBasePis))					   					//05 - VL_BC_PIS
	aAdd (aRegC381[nPos], Iif(lPauta,"", iif(lPisZero,0,nAlqPis)))						//06 - ALIQ_PIS
	aAdd (aRegC381[nPos], Iif(lPauta,nQtdBPis,""))	   									//07 - QUANT_BC_PIS
	aAdd (aRegC381[nPos], Iif(lPauta,Iif(lPisZero,0,nPisPauta),""))					//08 - ALIQ_PIS_QUANT
	aAdd (aRegC381[nPos], Iif(lPisZero,0,nValPis))										//09 - VL_PIS
	aAdd (aRegC381[nPos], cConta)														//10 - COD_CTA


	IF (cAliasSFT)->FT_CSTPIS $ "04/05/06/07/08/09"
		If !(cAliasSFT)->FT_CSTPIS $ "05" //se for CST 04, 06, 07, 08, 09 grava M400 direto
			RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1)
		ElseIF (cAliasSFT)->FT_ALIQPS3 == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
			RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1)
		EndIF
	EndIF

Else
	aRegC381[nPosC381][4]+= ((cAliasSFT)->FT_TOTAL)									//04 - VL_ITEM
	IF lPauta
		aRegC381[nPosC381][7]+= nQtdBPis												//05 - VL_BC_PIS
	Else
		aRegC381[nPosC381][5]+= nBasePis											//05 - VL_BC_PIS
	EndIF
	aRegC381[nPosC381][9]+= Iif(lPisZero,0,nValPis)					//09 - VL_PIS

	IF (cAliasSFT)->FT_CSTPIS $ "04/05/06/07/08/09"
		If !(cAliasSFT)->FT_CSTPIS $ "05" //se for CST 04, 06, 07, 08, 09 grava M400 direto
			RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1)
		ElseIF (cAliasSFT)->FT_ALIQPS3 == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
			RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1)
		EndIF
	EndIF
EndIf

//Processa registro M210 para a contribuio deste item.
RegM210(aRegM210,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM220,,,@aRegM230,,cAliasSB1)

Return


Static Function RegC385 (aRegC385,cAliasSFT,cProd,aReg0500,aRegM610,aWizard,aRegM800,aRegM810,;
						lCumulativ,lCofZero,aDevolucao,aRegM620,aRegM630,cAliasSB1,lCpoMajAli)

Local 	nPos		:= 	0
Local 	nPosC385	:= 	0
Local 	nCofPuata	:= 	0
Local 	lPauta		:=	.F.
Local	lPautaCOF	:=	aFieldPos[21]
Local 	cConta		:=	Reg0500(@aReg0500,(cAliasSFT)->FT_CONTA,,cAliasSFT)
Local 	nQtdBCof	:=	0
Local 	aBaseAlqUn 	:=	{}
Local 	cChaveCCZ	:=	""
Local 	nAlqCof		:= 0
Local	nBaseCof	:= 0
Local 	nValCof		:= 0

nAlqCof		:= (cAliasSFT)->FT_ALIQCOF
nBaseCof  	:= (cAliasSFT)->FT_BASECOF
nValCof		:= (cAliasSFT)->FT_VALCOF
MajAliqVal(@nAlqCof,@nValCof,cAliasSFT,lCpoMajAli)

lPauta:=.F.
If (cAliasSFT)->FT_VALCOF > 0
	If (lPautaCOF .And. (cAliasSFT)->FT_PAUTCOF > 0) .OR. (cAliasSB1)->B1_VLR_COF > 0
		aBaseAlqUn:=VlrPauta(lCmpNRecFT, lCmpNRecB1, "COF",cAliasSFT,cAliasSB1,lCmpNRecF4,lPautaCOF)
		nCofPauta := Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][1] , Iif((cAliasSFT)->FT_PAUTCOF > 0,(cAliasSFT)->FT_PAUTCOF,(cAliasSB1)->B1_VLR_COF))
		nQtdBCof  := Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][2] , (cAliasSFT)->FT_QUANT)
		lPauta:=.T.
	EndIF
EndIF

If lPauta
	nPosC385 := aScan (aRegC385, {|aX| aX[2]==(cAliasSFT)->FT_CSTCOF .AND. aX[3]==cProd .AND. aX[8]==iif(lCofZero,0, nCofPauta) .AND. aX[10]==cConta})
Else
	nPosC385 := aScan (aRegC385, {|aX| aX[2]==(cAliasSFT)->FT_CSTCOF .AND. aX[3]==cProd .AND. aX[6]==Iif(lCofZero,0,nAlqCof) .AND. aX[10]==cConta})
EndIF
If nPosC385 ==0
	aAdd(aRegC385,{})
	nPos	:=	Len (aRegC385)
	aAdd (aRegC385[nPos], "C385")														//01 - REG
	aAdd (aRegC385[nPos], (cAliasSFT)->FT_CSTCOF)										//02 - CST_COFINS
	aAdd (aRegC385[nPos], cProd)														//03 - COD_ITEM
	aAdd (aRegC385[nPos], (cAliasSFT)->FT_TOTAL)										//04 - VL_ITEM
	aAdd (aRegC385[nPos], Iif(lPauta,"", nBaseCof))					   				//05 - VL_BC_COFINS
	aAdd (aRegC385[nPos], Iif(lPauta,"",Iif(lCofZero,0,nAlqCof)))	   					//06 - ALIQ_COFINS
	aAdd (aRegC385[nPos], Iif(lPauta,nQtdBCof,""))	   									//07 - QUANT_BC_COFINS
	aAdd (aRegC385[nPos], Iif(lPauta,Iif(lCofZero,0, nCofPauta),""))					//08 - ALIQ_COFINS_QUANT
	aAdd (aRegC385[nPos], Iif(lCofZero,0,nValCof))										//09 - VL_COFINS
	aAdd (aRegC385[nPos], cConta )														//10 - COD_CTA

	If (cAliasSFT)->FT_CSTCOF $ "04/05/06/07/08/09"
		If !(cAliasSFT)->FT_CSTCOF $ "05" //se for CST 04, 06, 07, 08, 09 grava M400 direto
			RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1)
		ElseIF (cAliasSFT)->FT_ALIQCF3 == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
			RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1)
		EndIF
	EndIF


Else
	aRegC385[nPosC385][4]+= ((cAliasSFT)->FT_TOTAL)									//04 - VL_ITEM

	If lPauta
		aRegC385[nPosC385][7]+=nQtdBCof													//05 - VL_BC_COFINS
	Else
		aRegC385[nPosC385][5]+= nBaseCof							   					//05 - VL_BC_COFINS
	EndIf

	aRegC385[nPosC385][9]+= Iif(lCofZero,0,nValCof)				   					//09 - VL_COFINS

	If (cAliasSFT)->FT_CSTCOF $ "04/05/06/07/08/09"
		If !(cAliasSFT)->FT_CSTCOF $ "05" //se for CST 04, 06, 07, 08, 09 grava M400 direto
			RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1)
		ElseIF (cAliasSFT)->FT_ALIQCF3 == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
			RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1)
		EndIF
	EndIF

EndIf
RegM610(aRegM610,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM620,,,@aRegM630,,cAliasSB1)//Processa registro M610 para a contribuio deste item.

Return


Static Function RegC395 (cAlias,aRegC395,aTotal,aCmpAntSFT,cEspecie,aPartDoc,nRelacDoc, nPaiC,aRegC396)

Local	nPos		:=	0

aAdd(aRegC395, {})
nPos	:=	Len (aRegC395)
aAdd (aRegC395[nPos], "C395")							//01 - REG
aAdd (aRegC395[nPos], cEspecie)							//02 - COD_MOD
aAdd (aRegC395[nPos], aPartDoc[1])						//03 - COD_PART
aAdd (aRegC395[nPos], aCmpAntSFT[2])					//04 - SER
aAdd (aRegC395[nPos], "")								//05 - SUB_SER
aAdd (aRegC395[nPos],Right(AllTrim(aCmpAntSFT[1]),6))	//06 - NUM_DOC
aAdd (aRegC395[nPos], aCmpAntSFT[6])	   				//07 - DT_DOC
aAdd (aRegC395[nPos], aTotal[1])						//08 - VL_DOC

If len(aRegC396) > 0
	PCGrvReg (cAlias, nRelacDoc, aRegC395,,,nPaiC,,,nTamTRBIt)
EndIf

Return


Static Function RegC396 (cAlias,aRegC396,cAliasSFT,cProd,nRelacDoc,nItem,aReg0500,aRegAuxM105,aRegAuxM505,;
						 cRegime,lCumulativ,cIndApro,aReg0111,cAliasSB1)

Local	nPos		:=	0
nPosC396 := aScan (aRegC396, {|aX| aX[02] ==  cProd				   .AND. ;
				 			   	    aX[05] == (cAliasSFT)->FT_CODBCC  .AND. ;
				 			   		aX[06] == (cAliasSFT)->FT_CSTPIS  .AND. ;
							   		aX[08] == (cAliasSFT)->FT_ALIQPIS .AND. ;
							   		aX[10] == (cAliasSFT)->FT_CSTCOF  .AND. ;
							   		aX[12] == (cAliasSFT)->FT_ALIQCOF .AND. ;
							   		aX[14] == Reg0500(@aReg0500,(cAliasSFT)->FT_CONTA,,cAliasSFT)})
If ((cAliasSFT)->FT_VALCOF +(cAliasSFT)->FT_VALPIS) > 0
	If  nPosC396 ==0
		aAdd(aRegC396, {})
		nPos	:=	Len (aRegC396)
		aAdd (aRegC396[nPos], "C396")							   					//01 - REG
		aAdd (aRegC396[nPos], cProd)							   					//02 - COD_ITEM
		aAdd (aRegC396[nPos], (cAliasSFT)->FT_TOTAL)						   		//03 - VL_ITEM
		aAdd (aRegC396[nPos], (cAliasSFT)->FT_DESCONT)								//04 - VL_DESC
		aAdd (aRegC396[nPos], (cAliasSFT)->FT_CODBCC)								//05 - NAT_BC_CRED
		aAdd (aRegC396[nPos], (cAliasSFT)->FT_CSTPIS)		   						//06 - CST_PIS
		aAdd (aRegC396[nPos], (cAliasSFT)->FT_BASEPIS)	   							//07 - VL_BC_PIS
		aAdd (aRegC396[nPos], (cAliasSFT)->FT_ALIQPIS)								//08 - ALIQ_PIS
		aAdd (aRegC396[nPos], (cAliasSFT)->FT_VALPIS)								//09 - VL_PIS
		aAdd (aRegC396[nPos], (cAliasSFT)->FT_CSTCOF)								//10 - CST_COFINS
		aAdd (aRegC396[nPos], (cAliasSFT)->FT_BASECOF)								//11 - VL_BC_COFINS
		aAdd (aRegC396[nPos], (cAliasSFT)->FT_ALIQCOF - IiF(aFieldPos[15],(cAliasSFT)->FT_MALQCOF,0))	//12 - ALIQ_COFINS
		aAdd (aRegC396[nPos], (cAliasSFT)->FT_VALCOF - IiF(aFieldPos[16],(cAliasSFT)->FT_MVALCOF,0))		//13 - VL_COFINS
		aAdd (aRegC396[nPos], Reg0500(@aReg0500,(cAliasSFT)->FT_CONTA,,cAliasSFT))//14 - COD_CTA
	Else
		aRegC396[nPosC396][3]  += (cAliasSFT)->FT_TOTAL
		aRegC396[nPosC396][4]  += (cAliasSFT)->FT_DESCONT
		aRegC396[nPosC396][7]  += (cAliasSFT)->FT_BASEPIS
		aRegC396[nPosC396][9]  += (cAliasSFT)->FT_VALPIS
		aRegC396[nPosC396][11] += (cAliasSFT)->FT_BASECOF
		aRegC396[nPosC396][13] += (cAliasSFT)->FT_VALCOF - IiF(aFieldPos[16],(cAliasSFT)->FT_MVALCOF,0)
	EndIf


	If (cAliasSFT)->FT_CSTPIS $ "50/51/52/53/54/55/56/60/61/62/63/64/65/66"
		AcumM105(aRegAuxM105,cAliasSFT,cRegime,lCumulativ,cIndApro,aReg0111,,,,,cAliasSB1)
	EndIF


	If (cAliasSFT)->FT_CSTCOF $ "50/51/52/53/54/55/56/60/61/62/63/64/65/66"
		AcumM505(aRegAuxM505,cAliasSFT,cRegime,lCumulativ,cIndApro,aReg0111,,,,,cAliasSB1)
	EndiF
EndIf

Return


Static Function RegC400(aRegC400, cIMPFISC, cSERPDV, cPDV,nPos400, nCt400,;
							c400AScan, c400BScan, c400CScan)

Local nPos		:= 0
Local _nAt 		:= Iif( lProcMThr , At(cSERPDV,c400AScan+c400BScan+c400CScan) , Ascan(aRegC400, {|x| x[4] == cSERPDV})   )

//Preenchimento do registro C400                            
//Validacao para nao repetir ECF com o mesmo numero de serie
If _nAt == 0 //Len(aRegC400) == 0 .OR. (Ascan(aRegC400, {|x| x[4] == cSERPDV}) == 0)
	aAdd(aRegC400, {})
	nPos :=	Len (aRegC400)
	nCt400++
	aAdd (aRegC400[nPos], "C400"					)	 	//00 - REG
	aAdd (aRegC400[nPos], "2D"						)	 	//02 - COD_MOD
	aAdd (aRegC400[nPos], Left(cIMPFISC,20)			)	 	//03 - ECF_MOD
	aAdd (aRegC400[nPos], cSERPDV					)	 	//04 - ECF_FAB
	aAdd (aRegC400[nPos], Right(cPDV,3)				)	 	//05 - ECF_CX

	// Grava em String - Evitando aScan
	If lProcMThr
		If Len(c400AScan)<=998
			c400AScan += cSERPDV+"_"+StrZero(nPos,3)+"|"
		ElseIf Len(c400BScan)<=998
			c400BScan += cSERPDV+"_"+StrZero(nPos,3)+"|"
		ElseIf Len(c400CScan)<=998
			c400CScan += cSERPDV+"_"+StrZero(nPos,3)+"|"
		EndIf
	EndIf
EndIf

nPos400 := nCt400

Return


Static Function RegC405(aRegC405, nRegPai, dDtMovto, cCRO,cNUMREDZ, cNUMFIM, nGTFINAL, nVALCON,	 nPos405, nValDesc, c405AScan, nValCanc)

Local nPos		:= 0
Local _nAt		:= Len(aRegC405)    // At(cCRO+DtoS(dDtMovto),c405AScan )
Local nNumFim := 0

DEFAULT nValCanc := 0
DEFAULT c405AScan := "" 

//Preenchimento do registro 405
If _nAt==0 // Len(aRegC405) == 0 .OR. (Ascan(aRegC405, {|x| x[3]+DtoS(x[2]) == cCRO+DtoS(dDtMovto) }) == 0)
	aAdd(aRegC405, {})
	nPos :=	Len (aRegC405)

	aAdd (aRegC405[nPos], "C405"		) 	   	//01 - REG
	aAdd (aRegC405[nPos], dDtMovto		)	 	//02 - DT_DOC
	aAdd (aRegC405[nPos], cCRO   		) 	   	//03 - CRO
	aAdd (aRegC405[nPos], cNUMREDZ		)	 	//04 - CRZ
	nNumFim := val(cNUMFIM)+1
	aAdd (aRegC405[nPos], StrZero(nNumFim,Len(AllTrim(Str(nNumFim))))) 	   	//05 - NUM_COO_FIN
	aAdd (aRegC405[nPos], nGTFINAL		)	 	//06 - GT_FIN
	aAdd (aRegC405[nPos], nVALCON+nValDesc+nValCanc ) 	//07 - VL_BRT

	nPos405 := nPos
Else
	If _nAt == nPos405
	    aRegC405[nPos405][7] += nVALCON+nValDesc
	Endif
    
	nPos405 := _nAt //Val(SubStr(c405AScan,_nAt+12,3))
EndIf

Return


Static Function RegC481(cAliasSFT,aRegC481,aRegC485,nPdv, cDtMovt,nPosPai,aReg0200,aReg0205,aReg0190,dDataDe,dDataAte,cAlias, ;
					    cRegime,aRegM400,aRegM410,aRegM800,aRegM810,aRegM210,aRegM610,aRegC491,aRegC495,lCumulativ,nRelacFil,;
					    aRegM230,aRegM630,aReg0500,nPos490Pai,lConsolid,lTop,aRegC489,aRegC499,aReg1010,aReg1020,lAchouCDG,nMVM996TPR,lA1_TPREG,cMvEstado,;
					    lCmpsSB5,lCmpPisUni,lCmpCofUni,nPos0200,cConta,cProd,lAScan,aDevMsmPer)

Local	nPos		:=	0
Local	nPosC481	:=	0
Local	nPosC485	:=	0
Local   nPosC489    :=  0
Local	nPosC491	:=	0
Local	nPosC495	:=	0
Local   nPosC499    :=  0
Local 	nAlqPis		:= 0
Local 	nAlqCof		:= 0
Local 	nBasePis	:= 0
Local 	nBaseCof	:= 0
Local 	nValPis		:= 0
Local 	nValCof		:= 0
Local   cAliasSB1	:= "SB1"
Local 	cAliasSF4	:= "SF4"
Local   cCampos		:= ""
//Local 	cDescProd	:= ""
Local   aProd		:=  {"","","","","","","","","","",""}
Local 	cFiltro		:= ""
Local   cChaveCCZ	:= ""
Local 	aBaseAlqUn  := {}
Local   nQtdBPis 	:= 0
Local   nQtdBCof 	:= 0
Local 	cCmposSFT	:= ""
Local 	cCmposSB1	:= ""
Local   nPisPauta   := 0

Local  lSPEDPROD	:= aExstBlck[03]  // ExistBlock("SPEDPROD")
Local 	lB1TPREG	:= aFieldPos[22]

Local   cChave      := ''
Local   lAchouCCF	:=.F.
Local   nPosDev     := 0

Default aReg0500 	:= {}
Default nPos0200	:= 0
Default cConta  	:= ""
Default cProd		:= ""
Default lAScan		:= .T.
Default	lCmpPisUni	:= aFieldPos[20]
Default	lCmpCofUni	:= aFieldPos[21]
Default lCmpsSB5	:= SB5->(LastRec())>0 .AND. aFieldPos[17] .AND. aFieldPos[18] .AND. aFieldPos[19]

lDevolucao := (nPosDev := aScan(aDevMsmPer, {|aX| aX[1]==(cAliasSFT)->FT_NFISCAL .AND. aX[3]==(cAliasSFT)->FT_SERIE .AND. aX[4]==(cAliasSFT)->FT_ITEM}))  > 0

//PARA TOP UTILIZO CAMPOS DA QUERY PARA O SB1.
If lTop
	cAliasSB1	:= cAliasSFT
	cAliasSF4	:= cAliasSFT
Else
	SPEDSeek(cAliasSB1,,xFilial("SB1")+(cAliasSFT)->FT_PRODUTO)
	If SPEDSeek("SD2",3,xFilial("SD2")+(cAliasSFT)->(FT_NFISCAL+FT_SERIE+FT_CLIEFOR+FT_LOJA+FT_PRODUTO+FT_ITEM))
		SPEDSeek(cAliasSF4,1,xFilial(cAliasSF4)+SD2->D2_TES)
	EndIf
EndIF

lCofZero 	:= (cAliasSFT)->FT_CSTCOF$"#04#06#07#08#09#"
lPisZero 	:= (cAliasSFT)->FT_CSTPis$"#04#06#07#08#09#"

// So' posiciona se nao for multithread
If !lProcMThr
	cConta 		:= Reg0500(@aReg0500,(cAliasSFT)->FT_CONTA,,cAliasSFT)
	cProd 		:= (cAliasSB1)->B1_COD+Iif(lConcFil,xFilial("SB1"),"")
EndIf

//cDescProd   := (cAliasSB1)->B1_DESC

If lSPEDPROD
	aProd := Execblock("SPEDPROD", .F., .F., {cAliasSFT})
	If Len(aProd)==11
		cProd 		:= Iif(!Empty(aProd[1]),aProd[1],"")
		cDescProd   := Iif(!Empty(aProd[2]),aProd[1],"")
	Else
		aProd := {"","","","","","","","","","",""}
	EndIf
EndIf

//Verifica se nao e' necessario gerar produto
If !lMVGerPrdC
	cProd	:= ""
	cConta 	:= ""
EndIf

lPauta:=.F.
If (cAliasSFT)->FT_VALPIS > 0
	If (lCmpPisUni .And. (cAliasSFT)->FT_PAUTPIS > 0) .OR. Iif(lProcMThr,.F.,(cAliasSB1)->B1_VLR_PIS > 0 )
		aBaseAlqUn:=VlrPauta(lCmpNRecFT, lCmpNRecB1, "PIS",cAliasSFT,cAliasSB1,lCmpNRecF4,lCmpPisUni)
		nPisPauta := Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][1] , Iif((cAliasSFT)->FT_PAUTPIS > 0,(cAliasSFT)->FT_PAUTPIS, Iif(lProcMThr,0,(cAliasSB1)->B1_VLR_PIS)  ))
		nQtdBPis  := Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][2] , (cAliasSFT)->FT_QUANT)
		lPauta:=.T.
	EndIF
EndIF

If (cAliasSFT)->FT_VALCOF > 0
	If (lCmpCofUni .And. (cAliasSFT)->FT_PAUTCOF > 0) .OR. Iif(lProcMThr,.F.,(cAliasSB1)->B1_VLR_COF > 0 )
		aBaseAlqUn:=VlrPauta(lCmpNRecFT, lCmpNRecB1, "COF",cAliasSFT,cAliasSB1,lCmpNRecF4,lCmpCofUni)
		nCofPauta := Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][1] , Iif((cAliasSFT)->FT_PAUTCOF > 0,(cAliasSFT)->FT_PAUTCOF, Iif(lProcMThr,0,(cAliasSB1)->B1_VLR_COF) ))
		nQtdBCof  := Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][2] , (cAliasSFT)->FT_QUANT)
		lPauta:=.T.
	EndIF
EndIF

nAlqPis		:= 0
nAlqCof		:= 0
nBasePis	:= 0
nBaseCof	:= 0
nValPis		:= 0
nValCof		:= 0

nAlqPis		:= (cAliasSFT)->FT_ALIQPIS
nAlqCof		:= (cAliasSFT)->FT_ALIQCOF
If !lDevolucao
	nBasePis	:= (cAliasSFT)->FT_BASEPIS
	nValPis		:= (cAliasSFT)->FT_VALPIS
	nBaseCof  	:= (cAliasSFT)->FT_BASECOF
	nValCof		:= (cAliasSFT)->FT_VALCOF
Else
	nBasePis	:= (cAliasSFT)->FT_BASEPIS - aDevMsmPer[nPosDev][7]
	nValPis		:= (cAliasSFT)->FT_VALPIS - aDevMsmPer[nPosDev][8]
	nBaseCof  	:= (cAliasSFT)->FT_BASECOF - aDevMsmPer[nPosDev][9]
	nValCof		:= (cAliasSFT)->FT_VALCOF - aDevMsmPer[nPosDev][10]
EndIf

//PARA GERA‡ƒO DO REGISTRO DE PROCESSO REFERENCIADO (C489 OU C499)
If lAScan
	cChave := xFilial ("CDG")+(cAliasSFT)->FT_TIPOMOV+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA
	lAchouCDG	:=	CDG->(MsSeek (cChave))
Endif

//SE NƒO FOR CONSOLIDA‡ƒO, IR GERAR REGISTROS C481 E C485.
IF !lConsolid

	If laScan
		If lPauta
			nPosC481 := aScan (aRegC481, {|aX| aX[2]==(cAliasSFT)->FT_CSTPIS .AND. aX[9]==cProd .AND. cvaltochar(aX[7])==cvaltochar(Iif(lPisZero,0,nPisPauta)) .AND. aX[10]==cConta })
		Else
			nPosC481 := aScan (aRegC481, {|aX| aX[2]==(cAliasSFT)->FT_CSTPIS .AND. aX[9]==cProd .AND. cvaltochar(aX[5])==cvaltochar(Iif(lPisZero,0,nAlqPis)) .AND. aX[10]==cConta })	 //_nAtC481 //
		EndIF
	Else
		nPosC481 := 0
	EndIf

	If nPosC481 ==0
		aAdd(aRegC481, {})
		nPos	:=	Len (aRegC481)
		aAdd (aRegC481[nPos], "C481")														//01 - REG
		aAdd (aRegC481[nPos], (cAliasSFT)->FT_CSTPIS)										//02 - CST_PIS
		aAdd (aRegC481[nPos], (cAliasSFT)->FT_TOTAL)										//03 - VL_ITEM
		aAdd (aRegC481[nPos], Iif(lPauta,"",nBasePis))					   					//04 - VL_BC_PIS
		aAdd (aRegC481[nPos], Iif(lPauta,"",Iif(lPisZero,0,nAlqPis)))	   					//05 - ALIQ_PIS
		aAdd (aRegC481[nPos], Iif(lPauta,nQtdBPis,""))	   									//06 - QUANT_BC_PIS
		aAdd (aRegC481[nPos], Iif(lPauta,Iif(lPisZero,0,nPisPauta),""))					//07 - ALIQ_PIS_QUANT
		aAdd (aRegC481[nPos], iif(lPisZero,0,nValPis))										//08 - VL_PIS
		aAdd (aRegC481[nPos], cProd)														//09 - COD_ITEM
		aAdd (aRegC481[nPos], cConta)														//10 - COD_CTA
	Else
		aRegC481[nPosC481][3]+= ((cAliasSFT)->FT_TOTAL)									//03 - VL_ITEM
		If lPauta
			aRegC481[nPosC481][6]+= nQtdBPis												//06 - QUANT_BC_PIS
		Else
			aRegC481[nPosC481][4]+= nBasePis							   					//04 - VL_BC_PIS
		EndIF
		aRegC481[nPosC481][8]+= Iif(lPisZero,0,nValPis)									//08 - VL_PIS
	EndIf

	If lPauta
		nPosC485 := aScan (aRegC485, {|aX| aX[2]==(cAliasSFT)->FT_CSTCOF .AND. aX[09]==cProd .AND. cvaltochar(aX[7])==cvaltochar(Iif(lCofZero,0,nCofPauta)) .AND. aX[10]==cConta })
	Else
		nPosC485 := aScan (aRegC485, {|aX| aX[2]==(cAliasSFT)->FT_CSTCOF .AND. aX[09]==cProd .AND. cvaltochar(aX[5])==cvaltochar(Iif(lCofZero,0,nAlqCof)) .AND. aX[10]==cConta })
	EndIF
	If nPosC485 ==0
		aAdd(aRegC485, {})
		nPos	:=	Len (aRegC485)
		aAdd (aRegC485[nPos], "C485")														//01 - REG
		aAdd (aRegC485[nPos], (cAliasSFT)->FT_CSTCOF)										//02 - CST_COFINS
		aAdd (aRegC485[nPos], (cAliasSFT)->FT_TOTAL)										//03 - VL_ITEM
		aAdd (aRegC485[nPos], Iif(lPauta,"", nBaseCof))									//04 - VL_BC_COFINS
		aAdd (aRegC485[nPos], Iif(lPauta,"",Iif(lCofZero,0,nAlqCof)))						//05 - ALIQ_COFINS
		aAdd (aRegC485[nPos], Iif(lPauta,nQtdBCof,""))	   									//06 - QUANT_BC_COFINS
		aAdd (aRegC485[nPos], Iif(lPauta,Iif(lCofZero,0,nCofPauta),""))					//07 - ALIQ_COFINS_QUANT
		aAdd (aRegC485[nPos], iif(lPisZero,0,nValCof))			  							//08 - VL_COFINS
		aAdd (aRegC485[nPos], cProd)														//09 - COD_ITEM
		aAdd (aRegC485[nPos], cConta)														//10 - COD_CTA
	Else
		//acumula
		aRegC485[nPosC485][3]+= ((cAliasSFT)->FT_TOTAL)									//03 - VL_ITEM
		If lPauta
			aRegC485[nPosC485][6]+= nQtdBCof												//06 - QUANT_BC_COFINS
		Else
			aRegC485[nPosC485][4]+= nBaseCof							   					//04 - VL_BC_COFINS
		EndIF
		aRegC485[nPosC485][8]+= Iif(lCofZero,0,nValCof)			 						//08 - VL_COFINS
	EndIf

	If lAchouCDG
		Do while !CDG->(Eof()) .And. CDG->CDG_FILIAL+CDG->CDG_TPMOV+CDG->CDG_DOC+CDG->CDG_SERIE+CDG->CDG_CLIFOR+CDG->CDG_LOJA==cChave
			// Verifica o tipo do registro, so' grava se for: 1 - Justica Federal / 2 - Secretaria Federal ou 9 - Outros
			If !(AllTrim(CDG->CDG_TPPROC)$"0|2")
				// Verifica se o codigo da info ja esta lancada no C489
				If (nPos := aScan (aRegC489, {|aX| aX[2]==CDG->CDG_PROCES})==0)
					aAdd(aRegC489, {})
					nPos489 := Len(aRegC489)
					aAdd (aRegC489[nPos489], "C489")				//01 - REG
					aAdd (aRegC489[nPos489], CDG->CDG_PROCES)		//02 - NUM_PROC
					aAdd (aRegC489[nPos489], CDG->CDG_TPPROC)		//03 - IND_PROC
					lAchouCCF	:=	CCF->(MsSeek (xFilial ("CCF")+ CDG->CDG_PROCES +CDG->CDG_TPPROC))
					If	lAchouCCF
						If CCF->CCF_TPCOMP == "1" //Complemento do processo referenciado - Judicial
							Reg1010(aReg1010)
						ElseIf CCF->CCF_TPCOMP == "2" //Complemento do processo referenciado - Administrativo
							Reg1020(aReg1020)
						EndIF
					EndIf
				Endif
			EndIF
			CDG->(DbSkip())
		Enddo
	EndIF

EndIF

//SE FOR CONSOLIDA‡ƒO, IR GERAR REGISTROS C491, C495 E C499.
IF lConsolid
	If lPauta
		nPosC491 := aScan (aRegC491, {|aX| aX[3]==cProd .AND. aX[4]==(cAliasSFT)->FT_CSTPIS .AND. aX[5]==(cAliasSFT)->FT_CFOP .AND. cvaltochar(aX[10])==cvaltochar(Iif(lPisZero,0,nPisPauta)) .AND. aX[12]==cConta})
	Else
		nPosC491 := aScan (aRegC491, {|aX| aX[3]==cProd .AND. aX[4]==(cAliasSFT)->FT_CSTPIS .AND. aX[5]==(cAliasSFT)->FT_CFOP .AND. cvaltochar(aX[8])==cvaltochar(Iif(lPisZero,0,nAlqPis)) .AND. aX[12]==cConta})
	EndIF
	If nPosC491 ==0
		aAdd(aRegC491, {})
		nPos := Len(aRegC491)
		aAdd (aRegC491[nPos], nPos490Pai)      		                  						//-Relacao com Pai
		aAdd (aRegC491[nPos], "C491")						  								//01 - REG
		aAdd (aRegC491[nPos], cProd)														//02 - COD_ITEM
		aAdd (aRegC491[nPos], (cAliasSFT)->FT_CSTPIS)										//03 - CST_PIS
		aAdd (aRegC491[nPos], (cAliasSFT)->FT_CFOP)				   						//04 - CFOP
		aAdd (aRegC491[nPos], (cAliasSFT)->FT_TOTAL)										//05 - VL_ITEM
		aAdd (aRegC491[nPos], Iif(lPauta,"",nBasePis))										//06 - VL_BC_PIS
		aAdd (aRegC491[nPos], Iif(lPauta,"",Iif(lPisZero,0,nAlqPis)))						//07 - ALIQ_PIS
		aAdd (aRegC491[nPos], Iif(lPauta,nQtdBPis,""))										//08 - QUANT_BC_PIS
		aAdd (aRegC491[nPos], Iif(lPauta,Iif(lPisZero,0,nPisPauta),""))				   	//09 - ALIQ_PIS_QUANT
		aAdd (aRegC491[nPos], Iif(lPisZero,0,nValPis))				   	   					//10 - VL_PIS
		aAdd (aRegC491[nPos], cConta )														//11 - COD_CTA
	Else
		aRegC491[nPosC491][6]+= ((cAliasSFT)->FT_TOTAL)									//05 - VL_ITEM
		If lPauta
			aRegC491[nPosC491][9]+= nQtdBPis												//08 - QUANT_BC_PIS
		Else
			aRegC491[nPosC491][7]+= nBasePis							   					//06 - VL_BC_PIS
		EndIF
		aRegC491[nPosC491][11]+=Iif(lPisZero,0,nValPis)				   					//10 - VL_PIS
	EndIf

	If lPauta
		nPosC495 := aScan (aRegC495, {|aX| aX[3]==cProd .AND. aX[4]==(cAliasSFT)->FT_CSTCOF .AND. aX[5]==(cAliasSFT)->FT_CFOP .AND. cvaltochar(aX[10])==cvaltochar(Iif(lCofZero,0,nCOfPauta)) .AND. aX[12]==cConta})
	Else
		nPosC495 := aScan (aRegC495, {|aX| aX[3]==cProd .AND. aX[4]==(cAliasSFT)->FT_CSTCOF .AND. aX[5]==(cAliasSFT)->FT_CFOP .AND. cvaltochar(aX[8])==cvaltochar(Iif(lCofZero,0,nAlqCof)) .AND. aX[12]==cConta})
	EndIf
	If nPosC495 ==0
		aAdd(aRegC495, {})
		nPos := Len(aRegC495)
		aAdd (aRegC495[nPos], nPos490Pai)      		                  						//-Relacao com Pai
		aAdd (aRegC495[nPos], "C495")						  								//01 - REG
		aAdd (aRegC495[nPos], cProd)														//02 - COD_ITEM
		aAdd (aRegC495[nPos], (cAliasSFT)->FT_CSTCOF)										//03 - CST_COFINS
		aAdd (aRegC495[nPos], (cAliasSFT)->FT_CFOP)				   						//04 - CFOP
		aAdd (aRegC495[nPos], (cAliasSFT)->FT_TOTAL)										//05 - VL_ITEM
		aAdd (aRegC495[nPos], Iif(lPauta,"", nBaseCof))					 				//06 - VL_BC_COFINS
		aAdd (aRegC495[nPos], Iif(lPauta,"",Iif(lCofZero,0,nAlqCof)))	   					//07 - ALIQ_COFINS
		aAdd (aRegC495[nPos], Iif(lPauta,nQtdBCof,""))										//08 - QUANT_BC_COFINS
		aAdd (aRegC495[nPos], Iif(lPauta,Iif(lCofZero,0,nCofPauta),""))				   	//09 - ALIQ_COFINS_QUANT
		aAdd (aRegC495[nPos], Iif(lCofZero,0,nValCof))			   					   		//10 - VL_COFINS
		aAdd (aRegC495[nPos], cConta)														//11 - COD_CTA
	Else
		aRegC495[nPosC495][6]+= ((cAliasSFT)->FT_TOTAL)									//05 - VL_ITEM
		If lPauta
			aRegC495[nPosC495][9]+= nQtdBCof												//06 - VL_BC_COFINS
		Else
			aRegC495[nPosC495][7]+= nBaseCof			  									//06 - VL_BC_COFINS
		EndIf
		aRegC495[nPosC495][11]+=Iif(lCofZero,0,nValCof)									//10 - VL_COFINS
	EndIf

	If lAchouCDG
		Do while !CDG->(Eof()) .And. CDG->CDG_FILIAL+CDG->CDG_TPMOV+CDG->CDG_DOC+CDG->CDG_SERIE+CDG->CDG_CLIFOR+CDG->CDG_LOJA==cChave
			If (nPos := aScan (aRegC499, {|aX| aX[3]==CDG->CDG_PROCES})==0)
				aAdd(aRegC499, {})
				nPos499 := Len(aRegC499)
				aAdd (aRegC499[nPos499], nPos490Pai)			//Relacionamento com o registro pai
				aAdd (aRegC499[nPos499], "C499")				//01 - REG
				aAdd (aRegC499[nPos499], CDG->CDG_PROCES)		//02 - NUM_PROC
				aAdd (aRegC499[nPos499], CDG->CDG_TPPROC)		//03 - IND_PROC

				lAchouCCF	:=	CCF->(MsSeek (xFilial ("CCF")+ CDG->CDG_PROCES +CDG->CDG_TPPROC))
				If	lAchouCCF
					If CCF->CCF_TPCOMP == "1" //Complemento do processo referenciado - Judicial
						Reg1010(aReg1010)
					ElseIf CCF->CCF_TPCOMP == "2" //Complemento do processo referenciado - Administrativo
						Reg1020(aReg1020)
					EndIF
				EndIf
			Endif
			CDG->(DbSkip())
		Enddo
	EndIf

EndIF

If lMVGerPrdC
	If aScan (aReg0200, {|aX| aX[3]==cProd}) == 0
		nPos0200++
		Reg0200(cAlias,@aReg0200,@aReg0190,dDataDe,dDataAte,aProd,cProd,nRelacFil,@aReg0205,.F.,cAliasSB1,cMvEstado,lCmpsSB5,nPos0200)
		//Reg0200(cAlias,@aReg0200,@aReg0190,dDataDe,dDataAte,aProd,cProd,nRelacFil,@aReg0205,.F.,cAliasSB1,cMvEstado,lCmpsSB5)
	EndIf
EndIf

If lGrBlocoM

	lCumulativ := .F.
	If  cRegime == "3" //Cumulativo e no cumulativo
		IF nMVM996TPR = 1 //TES
			If (cAliasSF4)->F4_TPREG == "2"	//Cumulativo
				lCumulativ := .T.
			ElseIF (cAliasSF4)->F4_TPREG == "3"	//Ambos, neste caso irei no produto para definir qual o regime
				IF lB1TPREG .AND. (caliasSB1)->B1_TPREG == "2" //Cumulativo
					lCumulativ := .T.
				EndIF
			EndIF
		Elseif nMVM996TPR == 2 //PRODUTO
			IF lB1TPREG .AND. (cAliasSB1)->B1_TPREG == "2" //Cumulativo
				lCumulativ := .T.
			EndIF
		Elseif nMVM996TPR == 3 .And. lA1_TPREG //CLIENTE
			If SPEDSeek("SA1",1,xFilial("SA1")+(cAliasSFT)->(FT_CLIEFOR+FT_LOJA))
				IF SA1->A1_TPREG == "2" //Cumulativo
					lCumulativ := .T.
				EndIF
			Endif
		EndIF
	Else
   		lCumulativ := (cRegime=="2")
	EndIf

	//REGISTRO M400 - DETALHAMENTO RECEITAS PIS.
	If (cAliasSFT)->FT_CSTPIS $ "04/05/06/07/08/09"
		If !(cAliasSFT)->FT_CSTPIS $ "05" //se for CST 04, 06, 07, 08, 09 grava M400 direto
			RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1)
		ElseIF (cAliasSFT)->FT_ALIQPS3 == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
			RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1)
		EndIF
	EndIF

	//REGISTRO M210 - CONTRIBUI‡ƒO DE PIS.
	RegM210(aRegM210,cAliasSFT,cRegime,lCumulativ,,,,,aRegM230,,cAliasSB1,,,,,,,aDevMsmPer)

	//REGISTRO M400 - DETALHAMENTO RECEITAS COFINS.
	If (cAliasSFT)->FT_CSTCOF $ "04/05/06/07/08/09"
		If !(cAliasSFT)->FT_CSTCOF $ "05" //se for CST 04, 06, 07, 08, 09 grava M800 direto
			RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1)
		ElseIF (cAliasSFT)->FT_ALIQCF3 == 0 //se for CST 05, verifica se a aliquopta de COFINS esta zerada para gerar M800
			RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1)
		EndIF
	EndIF

	//REGISTRO M210 - CONTRIBUI‡ƒO DE COFINS.
	RegM610(aRegM610,cAliasSFT,cRegime,lCumulativ,,,,,aRegM630,,,,,,,,,aDevMsmPer)
EndIf

Return


Static Function RegC490(aRegC490,dDataDe,dDataAte, cEspecie, nPos490)

Local   nPos        := Len(aRegC490)

If  nPos==0 //(nPos := aScan (aRegC490, {|aX| aX[4]==cEspecie})==0)
	aAdd(aRegC490, {})
	nPos := Len(aRegC490)
	aAdd (aRegC490[nPos], "C490")		//01 - REG
	aAdd (aRegC490[nPos], dDataDe)		//02 - DT_DOC_INI
	aAdd (aRegC490[nPos], dDataAte)		//03 - DT_DOC_FIN
	aAdd (aRegC490[nPos], cEspecie)		//04 - COD_MOD
//Else
//	nPos := aScan(aRegC490, {|aX| aX[4]==cEspecie})
EndIf

nPos490 := nPos

Return


Static Function RegC500(cAlias,aRegC500,aTotal,aCmpAntSFT,aPartdoc,cEspecie,cSituaDoc,nRelacDoc,cCodInfCom,nPaiC)

Local nPos		:=0

aAdd(aRegC500, {})
nPos := Len(aRegC500)
aAdd (aRegC500[nPos], "C500")					//01 - REG
If !cSituaDoc =="02" //CAncelada
	aAdd (aRegC500[nPos], aPartdoc[1])			//02 - COD_PART
Else
	aAdd (aRegC500[nPos], "")					//02 - COD_PART
EndIf
aAdd (aRegC500[nPos], cEspecie)					//03 - CST_MOD
aAdd (aRegC500[nPos], cSituaDoc)				//04 - COD_SIT
aAdd (aRegC500[nPos], aCmpAntSFT[2])			//05 - SER
aAdd (aRegC500[nPos], "")						//06 - SUB
aAdd (aRegC500[nPos], aCmpAntSFT[1])			//07 - NUM_DOC
If  !cSituaDoc =="02" //CAncelada
	aAdd (aRegC500[nPos], aCmpAntSFT[6])			//08 - DT_DOC
	aAdd (aRegC500[nPos], aCmpAntSFT[23])			//09 - DT_ENT
	aAdd (aRegC500[nPos], aTotal[1])				//10 - VL_DOC
	aAdd (aRegC500[nPos], aTotal[3])				//11 - VL_ICMS
	aAdd (aRegC500[nPos], cCodInfCom)				//12 - COD_INF
	aAdd (aRegC500[nPos], aTotal[26])				//13 - VL_PIS
	aAdd (aRegC500[nPos], aTotal[27])				//14 - VL_COFINS
Else
	aAdd (aRegC500[nPos], "")				//08 - DT_DOC
	aAdd (aRegC500[nPos], "")				//09 - DT_ENT
	aAdd (aRegC500[nPos], "")				//10 - VL_DOC
	aAdd (aRegC500[nPos], "")				//11 - VL_ICMS
	aAdd (aRegC500[nPos], "")				//12 - COD_INF
	aAdd (aRegC500[nPos], "")				//13 - VL_PIS
	aAdd (aRegC500[nPos], "")				//14 - VL_COFINS
EndIf


PCGrvReg (cAlias, nRelacDoc, aRegC500,,,nPaiC,,,nTamTRBIt)
Return

/*Programa  RegC501   ºAutor  Erick G. Dias        º Data   20/01/11   º±±
±±ºDesc.      Processamento do registro C501                             º±±
±±ParametrosaRegC501    -> Valores do registro C501.                    ±±
±±          cAliasSFT   -> Alias da tabela SFT.                         ±±
±±          aReg0500    -> informaµes do registro 0500.                ±±
±±          aTotaliza   -> Array com valor de PIS acumulado./totalizado.±±
±±          aRegAuxM105 -> Valores do registro M105.                    ±±
±±          cRegime     -> Indica o regime do contribuinte.             ±±
±±          lCumulativ  -> INdica se operao © Cumulativa.             ±±
±±          cIndApro    -> Indicador de apropriao de cr©dito.         ±±
±±          aReg0111    -> Valores do registro 0111 - Receita.          ±±
±±          cAliasSB1   -> Alias do cadastro de Produto SB1.            ±±*/
Static Function RegC501(aRegC501,cAliasSFT,aReg0500,aTotaliza,aRegAuxM105,cRegime,lCumulativ,cIndApro,aReg0111,cAliasSB1)

Local nPos		:=0
Local nPosC501  :=0
Local cConta	:= Reg0500(@aReg0500,(cAliasSFT)->FT_CONTA,,cAliasSFT)

nPosC501 := aScan (aRegC501, {|aX| aX[2]==(cAliasSFT)->FT_CSTPIS  .AND. aX[6]==(cAliasSFT)->FT_ALIQPIS .AND. aX[8]==cConta})

If nPosC501 ==0
	aAdd(aRegC501, {})
	nPos := Len(aRegC501)
	aAdd (aRegC501[nPos], "C501")								//01 - REG
	aAdd (aRegC501[nPos], (cAliasSFT)->FT_CSTPIS)				//02 - CST_PIS
	aAdd (aRegC501[nPos], (cAliasSFT)->FT_TOTAL)				//03 - VL_ITEM
	aAdd (aRegC501[nPos], (cAliasSFT)->FT_CODBCC)				//04 - NAT_BC_CRED
	aAdd (aRegC501[nPos], (cAliasSFT)->FT_BASEPIS)				//05 - VL_BC_PIS
	aAdd (aRegC501[nPos], (cAliasSFT)->FT_ALIQPIS)				//06 - ALIQ_PIS
	aAdd (aRegC501[nPos], (cAliasSFT)->FT_VALPIS)				//07 - VL_PIS
	aAdd (aRegC501[nPos], cConta )								//08 - COD_CTA

Else
	aRegC501[nPosC501][3]+= (cAliasSFT)->FT_TOTAL				//03 - VL_ITEM
	aRegC501[nPosC501][5]+= (cAliasSFT)->FT_BASEPIS			//05 - VL_BC_PIS
	aRegC501[nPosC501][7]+= (cAliasSFT)->FT_VALPIS				//07 - VL_PIS
EndIf

//Processa o valor de cr©dito de PIS no registro M105.
If (cAliasSFT)->FT_CSTPIS $ "50/51/52/53/54/55/56/60/61/62/63/64/65/66"
	AcumM105(aRegAuxM105,cAliasSFT,cRegime,lCumulativ,cIndApro,aReg0111,,,,,cAliasSB1)
EndIF

aTotaliza[26]+= (cAliasSFT)->FT_VALPIS

Return

/*±±ºPrograma  RegC505   ºAutor  Erick G. Dias        º Data   20/01/11º±±
±±ºDesc.      Processamento do registro C505                             º±±
±±ParametrosaRegC505    -> Valores do registro C505.                    ±±
±±          cAliasSFT   -> Alias da tabela SFT.                         ±±
±±          aReg0500    -> informaµes do registro 0500.                ±±
±±          aTotaliza   -> Array com valor de PIS acumulado./totalizado.±±
±±          aRegAuxM105 -> Valores do registro M105.                    ±±
±±          cRegime     -> Indica o regime do contribuinte.             ±±
±±          lCumulativ  -> INdica se operao © Cumulativa.             ±±
±±          cIndApro    -> Indicador de apropriao de cr©dito.         ±±
±±          aReg0111    -> Valores do registro 0111 - Receita.          ±±
±±          cAliasSB1   -> Alias do cadastro de Produto SB1.            ±±*/
Static Function RegC505(aRegC505,cAliasSFT,aReg0500,aTotaliza,aRegAuxM505,cRegime,lCumulativ,cIndApro,aReg0111,cAliasSB1)

Local nPos		:=0
Local nPosC505  :=0
Local cConta 	:= Reg0500(@aReg0500,(cAliasSFT)->FT_CONTA,,cAliasSFT)

nPosC505 := aScan (aRegC505, {|aX| aX[2]==(cAliasSFT)->FT_CSTCOF  .AND. aX[6]==(cAliasSFT)->FT_ALIQCOF .AND. aX[8]==cConta})

If nPosC505 ==0
	aAdd(aRegC505, {})
	nPos := Len(aRegC505)
	aAdd (aRegC505[nPos], "C505")								//01 - REG
	aAdd (aRegC505[nPos], (cAliasSFT)->FT_CSTCOF)				//02 - CST_COFINS
	aAdd (aRegC505[nPos], (cAliasSFT)->FT_TOTAL)				//03 - VL_ITEM
	aAdd (aRegC505[nPos], (cAliasSFT)->FT_CODBCC)				//04 - NAT_BC_CRED
	aAdd (aRegC505[nPos], (cAliasSFT)->FT_BASECOF)				//05 - VL_BC_COFINS
	aAdd (aRegC505[nPos], (cAliasSFT)->FT_ALIQCOF - IiF(aFieldPos[15],(cAliasSFT)->FT_MALQCOF,0)) //06 - ALIQ_COFINS
	aAdd (aRegC505[nPos], (cAliasSFT)->FT_VALCOF - IiF(aFieldPos[16],(cAliasSFT)->FT_MVALCOF,0))	//07 - VL_COFINS
	aAdd (aRegC505[nPos], cConta )								//08 - COD_CTA

Else
	aRegC505[nPosC505][3]+= (cAliasSFT)->FT_TOTAL				//03 - VL_ITEM
	aRegC505[nPosC505][5]+= (cAliasSFT)->FT_BASECOF	   		//05 - VL_BC_COFINS
	aRegC505[nPosC505][7]+= (cAliasSFT)->FT_VALCOF - IiF(aFieldPos[16],(cAliasSFT)->FT_MVALCOF,0) //07 - VL_COFINS
EndIf

//Processa o valor de cr©dito de COFINS no registro M505.
If (cAliasSFT)->FT_CSTPIS $ "50/51/52/53/54/55/56/60/61/62/63/64/65/66"
	AcumM505(aRegAuxM505,cAliasSFT,cRegime,lCumulativ,cIndApro,aReg0111,,,,,cAliasSB1)
EndIF

aTotaliza[27]+= (cAliasSFT)->FT_VALCOF
Return


/*±±ºPrograma  RegC599   ºAutor  Erick G. Dias        º Data   20/01/11º±±
±±ºDesc.      Processamento do registro C509                             º±±
±±ParametrosaRegC505 -> Informaµes do registro C505                    ±±
±±          aReg1010 -> Informaµes do registro 1010                    ±±
±±          aReg1020 -> Informaµes do registro 1020                    ±±*/
Static Function RegC509 (aRegC509,aReg1010,aReg1020)

Local	aAreaCDG	:=	CDG->(GetArea())
Local	lRet		:=	.T.
Local	nPos509		:=	1
Local   cChave      := ''
Local   nPos        := 0
Local 	lAchouCCF	:= .F.

cChave := CDG->CDG_FILIAL+CDG->CDG_TPMOV+CDG->CDG_DOC+CDG->CDG_SERIE+CDG->CDG_CLIFOR+CDG->CDG_LOJA

Do while !CDG->(Eof()) .And. CDG->CDG_FILIAL+CDG->CDG_TPMOV+CDG->CDG_DOC+CDG->CDG_SERIE+CDG->CDG_CLIFOR+CDG->CDG_LOJA==cChave

	If (nPos := aScan (aRegC509, {|aX| aX[2]==CDG->CDG_PROCES})==0)
		aAdd(aRegC509, {})
		nPos509 := Len(aRegC509)
		aAdd (aRegC509[nPos509], "C509")				//01 - REG
		aAdd (aRegC509[nPos509], CDG->CDG_PROCES)		//02 - NUM_PROC
		aAdd (aRegC509[nPos509], CDG->CDG_TPPROC)		//03 - IND_PROC
		lAchouCCF	:=	CCF->(MsSeek (xFilial ("CCF")+ CDG->CDG_PROCES +CDG->CDG_TPPROC))
		If	lAchouCCF
			If CCF->CCF_TPCOMP == "1" //Complemento do processo referenciado - Judicial
				Reg1010(aReg1010)
			ElseIf CCF->CCF_TPCOMP == "2" //Complemento do processo referenciado - Administrativo
				Reg1020(aReg1020)
			EndIF
		EndIf
	Endif
	CDG->(DbSkip())
Enddo

RestArea(aAreaCDG)

Return (lRet)

/*±±ºPrograma  RegC600   ºAutor  Erick G. Dias        º Data   20/01/11  º±±
±±ºDesc.      Processamento do registro C600                             º±±*/
Static Function RegC600(aRegC600,aRegC601,aRegC605,aTotaliza,cAliasSFT,aCmpAntSFT,cEspecie,aPartDoc,lAchouSFU,;
						lAchouCD3,lAchouCD4,aReg0500,nPosRetur,	aRegM210,aRegM610,aWizard,aRegM400,aRegM410,aRegM800,aRegM810,;
						lCumulativ,cSituaDoc,lPisZero, lCofZero,aDevolucao,aRegM220,aRegM620,aRegM230,aRegM630,cAliasSB1,lSpdP06,;
						lSpdP61,lSpdP65,lCpoMajAli,lCmpDescZF)

Local nPos		:=0
Local nPosC600  :=0
Local nPosC601  :=0
Local nPosC605  :=0
Local nPosa601  :=0
Local nPosa605 := 0
Local cCodCons  :="  "
Local nConskwh	:= 0
Local nValTerc	:= 0
Local cConta	:= Reg0500(@aReg0500,(cAliasSFT)->FT_CONTA,,cAliasSFT)
Local nAlqPis	:= 0
Local nBasePis	:= 0
Local nValPis	:= 0
Local nAlqCof	:= 0
Local nBaseCof	:= 0
Local nValCof	:= 0
Local nCount    := 0
Local a601      := {}
Local a605      := {}
Local aPar601	:= {}
Local aPar605	:= {}
Local aPar210	:= {}
Local aPar610	:= {}
Local a601Tmp := {}
Local a605Tmp := {}

If (cEspecie == "06" .Or. cEspecie == "55") .And. lAchouSFU
	cCodCons 	:= SFU->FU_CLASCON
	nConskwh 	:= SFU->FU_CONSTOT
	nValTerc	:=	SFU->FU_VALTERC
Elseif cEspecie == "28" .And. lAchouCD3
	cCodCons 	:= CD3->CD3_CLASCO
	nValTerc	:= CD3->CD3_VLTERC
Elseif cEspecie == "29" .And. lAchouCD4
	cCodCons 	:= CD4->CD4_CLASCO
	nValTerc	:=CD4->CD4_VLTERC
EndIf

nAlqPis		:= (cAliasSFT)->FT_ALIQPIS
nBasePis	:= (cAliasSFT)->FT_BASEPIS
nValPis		:= (cAliasSFT)->FT_VALPIS
MajAliqPis(@nAlqPis,@nValPis,cAliasSFT)

nAlqCof		:= (cAliasSFT)->FT_ALIQCOF
nBaseCof  	:= (cAliasSFT)->FT_BASECOF
nValCof		:= (cAliasSFT)->FT_VALCOF
MajAliqVal(@nAlqCof,@nValCof,cAliasSFT,lCpoMajAli)


If lAchouSFX
	nVlTerc  := SFX->FX_VALTERC
EndIf

nPosC600 := aScan (aRegC600, {|aX| aX[2]==cEspecie  .AND. aX[3]==aPartdoc[7] .AND. aX[4]==aCmpAntSFT[2] .AND. aX[6]==cCodCons .AND. aX[9]==aCmpAntSFT[6]})
If nPosC600==0
	aAdd(aRegC600, {})
	nPos := Len(aRegC600)
	nPosRetur := nPos
	aAdd (aRegC600[nPos], "C600")					//01 - REG
	aAdd (aRegC600[nPos], cEspecie)					//02 - COD_MOD
	aAdd (aRegC600[nPos], aPartdoc[7])				//03 - COD_MUN
	aAdd (aRegC600[nPos], aCmpAntSFT[2])			//04 - SER
	aAdd (aRegC600[nPos], "")						//05 - SUB
	aAdd (aRegC600[nPos], cCodCons)					//06 - COD_CONS
	aAdd (aRegC600[nPos], "1")						//07 - QTD_CONS
	aAdd (aRegC600[nPos], Iif(cSituaDoc == "02","1","0"))						//08 - QTD_CANC
	aAdd (aRegC600[nPos], aCmpAntSFT[6])			//09 - DT_DOC
	aAdd (aRegC600[nPos], aTotaliza[10])			//10 - VL_DOC
	aAdd (aRegC600[nPos], aTotaliza[9])				//11 - VL_DESC
	aAdd (aRegC600[nPos], CVALTOCHAR(nConskwh))						//12 - CONS
	aAdd (aRegC600[nPos], 0)						//13 - VL_FORN
	aAdd (aRegC600[nPos], 0)						//14 - VL_SERV_NT

	aAdd (aRegC600[nPos], nValTerc)					//15 - VL_TERC
	aAdd (aRegC600[nPos], aTotaliza[13])			//16 - VL_DA
	aAdd (aRegC600[nPos], aTotaliza[2])				//17 - VL_BC_ICMS
	aAdd (aRegC600[nPos], aTotaliza[3])				//18 - VL_ICMS
	aAdd (aRegC600[nPos], aTotaliza[4])				//19 - VL_BC_ICMS_ST
	aAdd (aRegC600[nPos], aTotaliza[5])				//20 - VL_ICMS_ST
	aAdd (aRegC600[nPos], aTotaliza[19]+aTotaliza[28])			//21 - VL_PIS
	aAdd (aRegC600[nPos], aTotaliza[20]+aTotaliza[29])			//22 - VL_COFINS

	//Ponto de entrada SPDPIS06 para alterar informacoes do registro C600
	If lSpdP06
	    aRegC600[nPos] := ExecBlock("SPDPIS06",.F.,.F.,{aRegC600[nPos],cAliasSFT})
	EndIf

	//C601
	aAdd(aRegC601, {})
	nPos := Len(aRegC601)
	aAdd (aRegC601[nPos], Len(aRegC600))                        //-Relacao com C600
	aAdd (aRegC601[nPos], "C601")								//01 - REG
	aAdd (aRegC601[nPos], (cAliasSFT)->FT_CSTPIS)				//02 - CST_PIS
	aAdd (aRegC601[nPos], (cAliasSFT)->FT_TOTAL)				//03 - VL_ITEM
	aAdd (aRegC601[nPos], nBasePis)								//04 - VL_BC_PIS
	aAdd (aRegC601[nPos], Iif(lPisZero,0,nAlqPis))				//05 - ALIQ_PIS
	aAdd (aRegC601[nPos], Iif(lPisZero,0,nValPis))				//06 - VL_PIS
	aAdd (aRegC601[nPos], cConta )								//07 - COD_CTA

	If lSpdP61 	//Ponto de entrada SPDPIS61 para alterar informacoes do registro C601

		a601:= ExecBlock("SPDPIS61",.F.,.F.,{aRegC601[nPos],cAliasSFT})
		For nCount:= 1 To 8
	    	aRegC601[nPos][nCount] := a601[nCount]     //gerar c601

	    	If nCount == 8
	    		aRegC601[nPos][nCount] := Reg0500(@aReg0500,a601[nCount],,cAliasSFT)
	    	EndIf

        Next nCount

		aPar601 := ACLONE(a601)    //gerar o 400

		If aRegC601[nPos][03] $ "04/05/06/07/08/09" //se for CST 04, 06, 07, 08, 09 grava M400 direto
			If !aRegC601[nPos][03] $ "05"
				RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1,,,aPar601,,lSpdP61)
			ElseIF aRegC601[nPos][06] == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
				RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1,,,aPar601,,lSpdP61)
			EndIf
		EndIF

	ElseIf (cAliasSFT)->FT_CSTPIS $ "04/05/06/07/08/09"
		If !(cAliasSFT)->FT_CSTPIS $ "05" //se for CST 04, 06, 07, 08, 09 grava M400 direto
			RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1)
		ElseIF (cAliasSFT)->FT_ALIQPS3 == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
			RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1)
		EndIF
	EndIF

	//C605
	aAdd(aRegC605, {})
	nPos := Len(aRegC605)
	aAdd (aRegC605[nPos], Len(aRegC600))                        //-Relacao com C600
	aAdd (aRegC605[nPos], "C605")								//01 - REG
	aAdd (aRegC605[nPos], (cAliasSFT)->FT_CSTCOF)				//02 - CST_COFINS
	aAdd (aRegC605[nPos], (cAliasSFT)->FT_TOTAL)				//03 - VL_ITEM
	aAdd (aRegC605[nPos], nBaseCof)			   					//04 - VL_BC_COFINS
	aAdd (aRegC605[nPos], Iif(lCofZero,0,nAlqCof))				//05 - ALIQ_COFINS
	aAdd (aRegC605[nPos], Iif(lCofZero,0 ,nValCof))			    //06 - VL_COFINS
	aAdd (aRegC605[nPos], cConta)								//07 - COD_CTA

	//Ponto de entrada SPDPIS65 para alterar informacoes do registro C605
	If lSpdP65

		a605 := ExecBlock("SPDPIS65",.F.,.F.,{aRegC605[nPos],cAliasSFT})

		For nCount := 1 To 8
			aRegC605[nPos][nCount] := a605[nCount]     	// Substitui pelos itens do PE, 1 a 8

			If nCount == 8
				aRegC605[nPos][nCount] := Reg0500(@aReg0500,a605[nCount],,cAliasSFT)
			EndIf
		Next nCount

		For nCount := 9 To 12
			aAdd(aPar605,a605[nCount])           	// Monta aPar com os dados da natureza retornados pelo PE, 9 a 12
		Next nCount

		If aRegC605[nPos][03] $ "04/05/06/07/08/09" //se for CST 04, 06, 07, 08, 09 grava M400 direto
		    If !aRegC605[nPos][03] $ "05"
			  RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1,,,aPar605)
			ElseIF aRegC605[nPos][06] == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
			  RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1,,,aPar605)
			EndIf
		EndIF
	ElseIf  (cAliasSFT)->FT_CSTCOF $ "04/05/06/07/08/09"  //se for CST 04, 06, 07, 08, 09 grava M400 direto
		If !(cAliasSFT)->FT_CSTCOF $ "05"
			RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1)
		ElseIF (cAliasSFT)->FT_ALIQCF3 == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
			RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1)
		EndIF
	EndIF

	If lSpdP61
		aAdd(aPar210,aRegC601[nPos][03])    // CSTPIS
	  	aAdd(aPar210,aRegC601[nPos][06])	// ALIQPIS
	  	aAdd(aPar210,aRegC601[nPos][05])	// BC PIS
	  	aAdd(aPar210,aRegC601[nPos][04])	// VL_TOTAL
  		aAdd(aPar210,aRegC601[nPos][07])    // VL_PIS
	  	RegM210(aRegM210,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM220,.T.,,@aRegM230,,cAliasSB1,,,,,aPar210)
	Else
	  	RegM210(aRegM210,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM220,,,@aRegM230,,cAliasSB1)
	EndIf

	If lSpdP65
		aAdd(aPar610,aRegC605[nPos][03])    // CSTCOF
	  	aAdd(aPar610,aRegC605[nPos][06])	// ALIQCOF
	  	aAdd(aPar610,aRegC605[nPos][05])	// BC COF
	  	aAdd(aPar610,aRegC605[nPos][04])	// VL_TOTAL
  		aAdd(aPar610,aRegC605[nPos][07])    // VL_COF
	  	RegM610(aRegM610,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM620,.T.,,@aRegM630,,cAliasSB1,,,,,aPar610)
	Else
	  	RegM610(aRegM610,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM620,,,@aRegM630,,cAliasSB1)
	EndIf

Else
	nPosRetur := nPosC600
	aRegC600[nPosC600][7]:= cvaltochar(val(aRegC600[nPosC600][7] ) +=1)								//07 - QTD_CONS
	aRegC600[nPosC600][8]:= cvaltochar(val(aRegC600[nPosC600][8]) +Iif(cSituaDoc == "02",1,0)) 		//08 - QTD_CANC
	aRegC600[nPosC600][10]+= (cAliasSFT)->FT_TOTAL + Iif(lCmpDescZF,(cAliasSFT)->FT_DESCZFR,0)		//10 - VL_DOC
	aRegC600[nPosC600][11]+= aTotaliza[9]				   											//11 - VL_DESC
	aRegC600[nPosC600][12]:= cvaltochar(val(aRegC600[nPosC600][12]) + nConskwh)						//12 - CONS
	aRegC600[nPosC600][13]+= 0																		//13 - VL_FORN
	aRegC600[nPosC600][14]+= 0																		//14 - VL_SERV_NT
	aRegC600[nPosC600][15]+= nValTerc																//15 - VL_TERC
	aRegC600[nPosC600][16]+= aTotaliza[13]															//16 - VL_DA
	aRegC600[nPosC600][17]+= (cAliasSFT)->FT_BASEICM												//17 - VL_BC_ICMS
	aRegC600[nPosC600][18]+= (cAliasSFT)->FT_VALICM													//18 - VL_ICMS
	aRegC600[nPosC600][19]+= aTotaliza[4]															//19 - VL_BC_ICMS_ST
	aRegC600[nPosC600][20]+= aTotaliza[5]															//20 - VL_ICMS_ST
	aRegC600[nPosC600][21]+= Iif(lPisZero,0,nValPis)												//21 - VL_PIS
	aRegC600[nPosC600][22]+= Iif(lCofZero,0 ,nValCof)												//22 - VL_COFINS


	//Ponto de entrada SPDPIS06 para alterar informacoes do registro C600
	If lSpdP06
	    aRegC600[nPosC600] := ExecBlock("SPDPIS06",.F.,.F.,{aRegC600[nPosC600],cAliasSFT})
	EndIf

	//C601

	aAdd (a601Tmp, {})
	nPosa601 := Len(a601Tmp)
	aAdd (a601Tmp[nPosa601], Len(aRegC600))                  //00 - Relacao com C600
	aAdd (a601Tmp[nPosa601], "C601")								//01 - REG
	aAdd (a601Tmp[nPosa601], (cAliasSFT)->FT_CSTPIS)				//02 - CST_PIS
	aAdd (a601Tmp[nPosa601], (cAliasSFT)->FT_TOTAL)				//03 - VL_ITEM
	aAdd (a601Tmp[nPosa601], nBasePis)			   					//04 - VL_BC_PIS
	aAdd (a601Tmp[nPosa601], Iif(lPisZero,0,nAlqPis))			//05 - ALIQ_PIS
	aAdd (a601Tmp[nPosa601], Iif(lPisZero,0,nValPis))			//06 - VL_PIS
	aAdd (a601Tmp[nPosa601], cConta )								//07 - COD_CTA

	If lSpdP61 	//Ponto de entrada SPDPIS61 para alterar informacoes do registro C601

		a601 := ExecBlock("SPDPIS61",.F.,.F.,{a601Tmp[nPosa601],cAliasSFT})

		For nCount := 1 To 8
	    	a601Tmp[nPosa601][nCount] := a601[nCount]     //gerar c601

	    	// Gera o 0500 p/ a Conta do PE.
	    	If nCount == 8
	    		a601Tmp[nPosa601][nCount] := Reg0500(@aReg0500,a601[nCount],,cAliasSFT)
	    	EndIf
		Next nCount
	EndIf

	nPosC601 := aScan (aRegC601, {|aX| aX[3]==a601Tmp[nPosa601][3] .AND. aX[6]==a601Tmp[nPosa601][6] .AND.;
										    aX[8]==a601Tmp[nPosa601][8] .AND. aX[1]==a601Tmp[nPosa601][1]})

	If nPosC601 > 0
		aRegC601[nPosC601][4]+= a601Tmp[nPosa601][4]			//03 - VL_ITEM
		aRegC601[nPosC601][5]+= a601Tmp[nPosa601][5]		   	//04 - VL_BC_PIS
		aRegC601[nPosC601][7]+= a601Tmp[nPosa601][7]			//06 - VL_PIS
	Else
		aAdd(aRegC601, {})
		nPos := Len(aRegC601)
		aAdd (aRegC601[nPos], a601Tmp[nPosa601][1])        //00 - Relacao com C600
		aAdd (aRegC601[nPos], a601Tmp[nPosa601][2])			//01 - REG
		aAdd (aRegC601[nPos], a601Tmp[nPosa601][3])			//02 - CST_PIS
		aAdd (aRegC601[nPos], a601Tmp[nPosa601][4])			//03 - VL_ITEM
		aAdd (aRegC601[nPos], a601Tmp[nPosa601][5])			//04 - VL_BC_PIS
		aAdd (aRegC601[nPos], a601Tmp[nPosa601][6])			//05 - ALIQ_PIS
		aAdd (aRegC601[nPos], a601Tmp[nPosa601][7])			//06 - VL_PIS
		aAdd (aRegC601[nPos], a601Tmp[nPosa601][8])			//07 - COD_CTA
	EndIf

	//Ponto de entrada SPDPIS61 para alterar informacoes do registro C601
	If lSpdP61

		If nPosC601 > 0
	   		nPos := nPosC601
 			Else
 				nPos := 1
	   EndIf

		aPar601 := ACLONE(a601)    //gerar o 400

		If aRegC601[nPos][03] $ "04/05/06/07/08/09" //se for CST 04, 06, 07, 08, 09 grava M400 direto
		    If !aRegC601[nPos][03] $ "05"
				RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1,,,aPar601,,lSpdP61)
			ElseIF aRegC601[nPos][06] == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
				RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1,,,aPar601,,lSpdP61)
			EndIf
		EndIF
	ElseIf (cAliasSFT)->FT_CSTPIS $ "04/05/06/07/08/09"
		If !(cAliasSFT)->FT_CSTPIS $ "05" //se for CST 04, 06, 07, 08, 09 grava M400 direto
			RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1)
		ElseIF (cAliasSFT)->FT_ALIQPS3 == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
			RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1)
		EndIF
	EndIF

	//C605

	aAdd(a605Tmp, {})
	nPosa605 := Len(a605Tmp)
	aAdd (a605Tmp[nPosa605], Len(aRegC600))            //00 - Relacao com C600
	aAdd (a605Tmp[nPosa605], "C605")						//01 - REG
	aAdd (a605Tmp[nPosa605], (cAliasSFT)->FT_CSTCOF)		//02 - CST_COFINS
	aAdd (a605Tmp[nPosa605], (cAliasSFT)->FT_TOTAL)		//03 - VL_ITEM
	aAdd (a605Tmp[nPosa605], nBaseCof)			  			//04 - VL_BC_COFINS
	aAdd (a605Tmp[nPosa605], Iif(lCofZero,0,nAlqCof))	//05 - ALIQ_COFINS
	aAdd (a605Tmp[nPosa605], Iif(lCofZero,0,nValCof))	//06 - VL_COFINS
	aAdd (a605Tmp[nPosa605], cConta)						//07 - COD_CTA

	If lSpdP65 	//Ponto de entrada SPDPIS65 para alterar informacoes do registro C605

		a605 := ExecBlock("SPDPIS65",.F.,.F.,{a605Tmp[nPosa605],cAliasSFT})

		For nCount := 1 To 8
	    	a605Tmp[nPosa605][nCount] := a605[nCount]

	    	// Gera o 0500 p/ a Conta do PE.
	    	If nCount == 8
	    		a605Tmp[nPosa605][nCount] := Reg0500(@aReg0500,a605[nCount],,cAliasSFT)
	    	EndIf
		Next nCount

		For nCount := 9 To 12
			aAdd(aPar605,a605[nCount]) // Monta aPar com os dados da natureza retornados pelo PE, 9 a 12
		Next nCount

	EndIf

	//C605
	nPosC605 := aScan (aRegC605, {|aX| aX[3]==a605Tmp[nPosa605][3] .AND. aX[6]==a605Tmp[nPosa605][6] .AND.;
		                             aX[8]==a605Tmp[nPosa605][8] .AND. aX[1]==a605Tmp[nPosa605][1]})

	If nPosC605 > 0
		aRegC605[nPosC605][4]+= a605Tmp[nPosa605][4]		//03 - VL_ITEM
		aRegC605[nPosC605][5]+= a605Tmp[nPosa605][5]		//04 - VL_BC_COFINS
		aRegC605[nPosC605][7]+= a605Tmp[nPosa605][7]		//06 - VL_COFINS
	Else
		aAdd(aRegC605, {})
		nPos := Len(aRegC605)
		aAdd (aRegC605[nPos], a605Tmp[nPosa605][1])     //-Relacao com C600
		aAdd (aRegC605[nPos], a605Tmp[nPosa605][2])		//01 - REG
		aAdd (aRegC605[nPos], a605Tmp[nPosa605][3])		//02 - CST_COFINS
		aAdd (aRegC605[nPos], a605Tmp[nPosa605][4])		//03 - VL_ITEM
		aAdd (aRegC605[nPos], a605Tmp[nPosa605][5])		//04 - VL_BC_COFINS
		aAdd (aRegC605[nPos], a605Tmp[nPosa605][6])		//05 - ALIQ_COFINS
		aAdd (aRegC605[nPos], a605Tmp[nPosa605][7])		//06 - VL_COFINS
		aAdd (aRegC605[nPos], a605Tmp[nPosa605][8])		//07 - COD_CTA
	EndIf

	If lSpdP65

		If nPosC605 > 0
			nPos := nPosC605
		Else
			nPos := 1
		EndIf

		If aRegC605[nPos][03] $ "04/05/06/07/08/09" //se for CST 04, 06, 07, 08, 09 grava M400 direto
			If !aRegC605[nPos][03] $ "05"
				RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1,,,aPar605)
			ElseIF aRegC605[nPos][06] == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
				RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1,,,aPar605)
			EndIf
		EndIF
	ElseIf  (cAliasSFT)->FT_CSTCOF $ "04/05/06/07/08/09"
		If !(cAliasSFT)->FT_CSTCOF $ "05" //se for CST 04, 06, 07, 08, 09 grava M400 direto
			RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1)
		ElseIF (cAliasSFT)->FT_ALIQCF3 == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
			RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1)
		EndIF
	EndIF

	If lSpdP61
		aAdd(aPar210,a601Tmp[nPosa601][03])	// CSTPIS
	  	aAdd(aPar210,a601Tmp[nPosa601][06])	// ALIQPIS
	  	aAdd(aPar210,a601Tmp[nPosa601][05])	// BC PIS
	  	aAdd(aPar210,a601Tmp[nPosa601][04])	// VL_TOTAL
  		  	aAdd(aPar210,a601Tmp[nPosa601][07])	// VL_PIS
	  	RegM210(aRegM210,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM220,.T.,,@aRegM230,,cAliasSB1,,,,,aPar210)
	Else
		RegM210(aRegM210,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM220,,,@aRegM230,,cAliasSB1)
	EndIf

	If lSpdP65
		aAdd(aPar610,a605Tmp[nPosa605][03])	// CSTCOF
	  	aAdd(aPar610,a605Tmp[nPosa605][06])	// ALIQCOF
	  	aAdd(aPar610,a605Tmp[nPosa605][05])	// BC COF
	  	aAdd(aPar610,a605Tmp[nPosa605][04])	// VL_TOTAL
  		  	aAdd(aPar610,a605Tmp[nPosa605][07])	// VL_COF
	  	RegM610(aRegM610,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM620,.T.,,@aRegM630,,cAliasSB1,,,,,aPar610)
	Else
		RegM610(aRegM610,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM620,,,@aRegM630,,cAliasSB1)
	EndIf
EndIf
Return

/*±±ºPrograma  ProcECF   ºAutor  Erick G. Dias       º Data   27/01/11 º±±
±±º                    º       Demetrio De Los Riosº        09/10/12   º±±
±±ºDesc.      Processamento dos registro de ECF                          º±±
±±ParametrosaRegC400   -> Informaµes do registro C400                  ±±
±±          aRegC405   -> Informaµes do registro C405                  ±±
±±          dDataDe    -> Data inicial do per­odo                       ±±
±±          dDataAte   -> Data final do per­odo                         ±±
±±          aRegC481   -> Informaµes do registro C481                  ±±
±±          aRegC485   -> Informaµes do registro C485                  ±±
±±          aReg0200   -> Informaµes do registro 0200                  ±±
±±          aReg0205   -> Informaµes do registro 0205                  ±±
±±          aReg0190   -> Informaµes do registro 0190                  ±±
±±          cAlias     -> Alias da tabela tempor¡ria                    ±±
±±          lRegC010   -> Indica se grava registro C010                 ±±
±±          cRegime    -> Indica qual o regime do contribuinte          ±±
±±          aRegM400   -> Informaµes do registro M400                  ±±
±±          aRegM410   -> Informaµes do registro M410                  ±±
±±          aRegM800   -> Informaµes do registro M800                  ±±
±±          aRegM810   -> Informaµes do registro M810                  ±±
±±          aRegM210   -> Informaµes do registro M210                  ±±
±±          aRegM610   -> Informaµes do registro M610                  ±±
±±          aRegC491   -> Informaµes do registro C491                  ±±
±±          aRegC495   -> Informaµes do registro C495                  ±±
±±          aRegC490   -> Informaµes do registro C490                  ±±
±±          lCumulativ -> Indica se operao © Cumulativa               ±±
±±          aRegM230   -> Informaµes do registro M230                  ±±
±±          aRegM630   -> Informaµes do registro M630                  ±±
±±          aReg0500   -> Informaµes do registro 0500                  ±±
±±          cCGCAnt    -> Cdigo da filial atual                        ±±
±±          lRepCGC    -> Indica se consolida valores por CGC           ±±
±±          lConsolid  -> Se informaµes de ECF sero consolidadas      ±±
±±          nPaiC      -> Relacionamento com registro C010              ±±
±±          lTop       -> Indica se est¡ processando com TOP            ±±
±±          aRegC489   -> Processo Referenciado                         ±±
±±          aRegC499   -> Processo Referenciado Consolidado             ±±
±±          aReg1010   -> Informaµes do registro 1010                  ±±
±±          aReg1020   -> Informaµes do registro 1020                  ±±
±±          nRelacDoc  -> Relacionamento com registro pai               ±±
±±          lAchouCDG  -> Indica se achou tabela CDG                    ±±
±±          aRegC010   -> Array C010                                    ±±
±±          nCt400     -> Variavel de controle C400                     ±±
±±          nMVM996TPR -> Conteudo do parametro MV_M996TPR              ±±
±±          lA1_TPREG  -> FieldPos do campo A1_TPREG                    ±±*/
Static Function ProcECF(aRegC400,aRegC405,dDataDe,dDataAte,aRegC481,aRegC485,aReg0200,aReg0205,aReg0190,cAlias,lRegC010,;
						cRegime,aRegM400,aRegM410,aRegM800,aRegM810,aRegM210,aRegM610,aRegC491,aRegC495,aRegC490,lCumulativ,nRelacFil,;
						aRegM230,aRegM630,aReg0500,cCGCAnt,lRepCGC,lConsolid, nPaiC,lTop,aRegC489,aRegC499,aReg1010,aReg1020,nRelacDoc,;
						lAchouCDG,aRegC010,nCt400,nMVM996TPR,lA1_TPREG,cMvEstado,aDevMsmPer)
Local nPos400 	:=0
Local nPos405 	:=0
Local nPos490	:=0
Local nCt405	:=0
Local nVlBrtLj  :=0
Local cAliasSFT	:= "SFT"
Local cAliasSFI := "SFI"
Local cAliasSLG := "SLG"
Local cSlctSFT	:= ""
Local cCmposSB1	:= ""
Local cFiltro	:= ""
Local cCampos	:= ""
Local cOrderBy	:= ""
Local dDtReduz	:= CtoD("//")
Local cChvPDV	:= ""
Local cPDV		:= ""
Local cChave	:= ""
Local cLGImpFisc	:= ""
Local cLGSerPdv		:= ""
Local cLGPdv		:= ""

Default cCGCAnt	:= ""
Default lRepCGC	:= .F.

lDevolucao	:= .F.

// ==============================================
// Query Principal - ECF
// ==============================================
#IFDEF TOP
    If (TcSrvType ()<>"AS/400")

		cSlctSFT := "SFT.FT_FILIAL,		SFT.FT_TIPOMOV,		SFT.FT_SERIE,		SFT.FT_NFISCAL,		SFT.FT_CLIEFOR,		"
		cSlctSFT +=	"SFT.FT_LOJA,		SFT.FT_ITEM,		SFT.FT_PRODUTO,		SFT.FT_ENTRADA,		SFT.FT_NRLIVRO,		"
		cSlctSFT +=	"SFT.FT_CFOP,		SFT.FT_ESPECIE,		SFT.FT_TIPO,		SFT.FT_EMISSAO,		SFT.FT_DTCANC,		"
	    cSlctSFT += "SFT.FT_FORMUL, 	SFT.FT_ALIQPIS,		SFT.FT_VALPIS,		SFT.FT_ALIQCOF,		SFT.FT_VALCOF,		"
		cSlctSFT += "SFT.FT_VALCONT,	SFT.FT_BASEICM,		SFT.FT_VALICM,		SFT.FT_ISSST,	 	SFT.FT_BASERET,		"
		cSlctSFT += "SFT.FT_ICMSRET,	SFT.FT_VALIPI,		SFT.FT_ISENICM,		SFT.FT_QUANT,		SFT.FT_DESCONT,		"
		cSlctSFT += "SFT.FT_TOTAL,		SFT.FT_FRETE,  		SFT.FT_SEGURO,		SFT.FT_DESPESA,		SFT.FT_OUTRICM,		"
		cSlctSFT += "SFT.FT_BASEIPI,	SFT.FT_ISENIPI,		SFT.FT_OUTRIPI,		SFT.FT_ICMSCOM,		SFT.FT_RECISS,		"
		cSlctSFT += "SFT.FT_BASEIRR,	SFT.FT_ALIQICM,		SFT.FT_ALIQIPI,		SFT.FT_CTIPI,		SFT.FT_POSIPI,		"
		cSlctSFT += "SFT.FT_CLASFIS,	SFT.FT_PRCUNIT,		SFT.FT_CFPS,		SFT.FT_ESTADO,		SFT.FT_CODISS,		"
		cSlctSFT += "SFT.FT_ALIQIRR,	SFT.FT_VALIRR,		SFT.FT_BASEINS,		SFT.FT_VALINS,		SFT.FT_PDV,			"
		cSlctSFT += "SFT.FT_ISSSUB,		SFT.FT_CREDST,		SFT.FT_ISENRET,		SFT.FT_OUTRRET,		SFT.FT_CONTA,		"
		cSlctSFT +=	"SFT.FT_BASEPIS,	SFT.FT_BASECOF,		SFT.FT_VALPS3,		SFT.FT_VALCF3,		SFT.FT_PESO,	    "
		cSlctSFT +=	"SFT.FT_SOLTRIB,	SFT.FT_CHVNFE, 		SFT.FT_CSTPIS,		SFT.FT_CSTCOF,		SFT.FT_INDNTFR, 	"
		cSlctSFT += "SFT.FT_CODBCC,		SFT.FT_ALIQCF3,  	SFT.FT_VALCF3,		SFT.FT_BASEPS3, 	SFT.FT_ALIQPS3, 	"
		cSlctSFT += "SFT.FT_VALPS3,		SFT.FT_BASECF3,"
		cSlctSFT += "SFT.FT_PAUTPIS, "
		cSlctSFT += "SFT.FT_PAUTCOF, "
		cSlctSFT += "SFT.FT_TNATREC, "
		cSlctSFT += "SFT.FT_CNATREC, "
		cSlctSFT += "SFT.FT_GRUPONC, "
		cSlctSFT += "SFT.FT_DTFIMNT, "

		If aFieldPos[15] .And. aFieldPos[16]
			cSlctSFT += "SFT.FT_MVALCOF , SFT.FT_MALQCOF, "
		EndIf


		//CAMPOS DA TABELA SB1 PARA MONTAR A QUERY.
    	cCmposSB1	:=	"SB1.B1_COD,		SB1.B1_DESC,		SB1.B1_VLR_PIS,		SB1.B1_VLR_COF,		SB1.B1_TNATREC,		"
		cCmposSB1	+=  "SB1.B1_CNATREC, 	SB1.B1_GRPNATR, 	SB1.B1_DTFIMNT,		SB1.B1_TIPO,		SB1.B1_CODBAR,		"
		cCmposSB1	+=  "SB1.B1_CODANT, 	SB1.B1_UM, 			SB1.B1_POSIPI,		SB1.B1_EX_NCM,		SB1.B1_CODISS,		"
		cCmposSB1	+=  "SB1.B1_PICM, 		SB1.B1_FECP, 		SB1.B1_DATREF		"
		If aFieldPos[22]
			cCmposSB1 += " , SB1.B1_TPREG  "
		EndIf


		//CAMPOS DA TABELA SFI E SLG               


		cCmposSB1 += " , SFI.FI_PDV, SFI.FI_DTMOVTO, SFI.FI_DESC,  SFI.FI_SERPDV, SFI.FI_VALCON, SFI.FI_ISS, SFI.FI_CRO, SFI.FI_NUMREDZ, SFI.FI_NUMFIM, SFI.FI_GTFINAL, SFI.FI_CANCEL "
		cCmposSB1 += " , SLG.LG_SERPDV, SLG.LG_IMPFISC, SLG.LG_PDV  "
		cCmposSB1 += " , SF4.F4_TPREG  "


    	cSlctSFT	+=	cCmposSB1
    	cSlctSFT	:=	"%"+cSlctSFT+"%"

    	cAliasSFI 	:= cAliasSLG := cAliasSFT	:=	GetNextAlias()
    	lSFI_SLG	:= .T. // Variavel utilizada para controle em DBF - Quando TOP sempre sera .T.

	   cFiltro := "%"
		cCampos := "%"
		If (cNrLivro<>"*")
  			cFiltro += " SFT.FT_NRLIVRO = '" +%Exp:cNrLivro% +"' AND "
     	EndiF
		cFiltro += "%"
		cCampos += "%"

		cOrderBy  := "%ORDER BY SFI.FI_PDV, SFI.FI_DTMOVTO, SFT.FT_NFISCAL,  SFT.FT_SERIE, SFT.FT_ITEM  %"

    	BeginSql Alias cAliasSFT

			COLUMN FT_EMISSAO AS DATE
	    	COLUMN FT_ENTRADA AS DATE
	    	COLUMN FT_DTCANC AS DATE
	    	COLUMN FI_DTMOVTO AS DATE

			SELECT
				%Exp:cSlctSFT%
			FROM
				%Table:SFT% SFT
				JOIN %Table:SFI% SFI ON (SFI.FI_FILIAL=%xFilial:SFI% AND SFI.FI_PDV=SFT.FT_PDV AND SFI.FI_DTMOVTO=SFT.FT_ENTRADA AND SFI.%NotDel%    )
				JOIN %Table:SLG% SLG ON (SLG.LG_FILIAL=%xFilial:SLG% AND SLG.LG_PDV=SFT.FT_PDV AND SLG.%NotDel%    )
				LEFT JOIN %Table:SB1% SB1 ON(SB1.B1_FILIAL=%xFilial:SB1%  AND SB1.B1_COD=SFT.FT_PRODUTO AND SB1.%NotDel%)
				LEFT JOIN %Table:SD2% SD2 ON(SD2.D2_FILIAL=%xFilial:SD2%  AND SD2.D2_DOC=SFT.FT_NFISCAL AND SD2.D2_SERIE=SFT.FT_SERIE AND SD2.D2_CLIENTE=SFT.FT_CLIEFOR AND SD2.D2_LOJA=SFT.FT_LOJA AND SD2.D2_COD=SFT.FT_PRODUTO AND SD2.D2_ITEM=SFT.FT_ITEM AND SD2.%NotDel%)
				LEFT JOIN %Table:SF4% SF4 ON(SF4.F4_FILIAL=%xFilial:SF4%  AND SF4.F4_CODIGO=SD2.D2_TES AND SF4.%NotDel%)

			WHERE
				SFT.FT_FILIAL=%xFilial:SFT% 				AND
				SFT.FT_TIPOMOV  = 'S'   					AND
				SFT.FT_ENTRADA>=%Exp:DToS(dDataDe)% AND
				SFT.FT_ENTRADA<=%Exp:DToS(dDataAte)% AND
				SFT.FT_DTCANC = ' ' AND
				(SFT.FT_ESPECIE='CF' OR SFT.FT_ESPECIE='ECF') AND
				((SFT.FT_BASEPIS > 0 OR SFT.FT_CSTPIS IN ('07','08','09','49' ))  OR (SFT.FT_BASECOF > 0 OR SFT.FT_CSTCOF IN ('07','08','09','49'))) AND
				%Exp:cFiltro%
				SFT.%NotDel%

			%Exp:cOrderBy%

		EndSql
	Else
#ENDIF

		// Abre tabelas
		dbSelectArea(cAliasSFI)
		(cAliasSFI)->(dbSetOrder(1))
		(cAliasSFI)->(dbGoTop())

		dbSelectArea(cAliasSLG)
		(cAliasSLG)->(dbSetOrder(1))
		(cAliasSLG)->(dbGoTop())

		cIndex	:= CriaTrab(NIL,.F.)
	    cFiltro	:= 'FT_FILIAL=="'+xFilial ("SFT")+'"  '
	    cFiltro += ' .AND. FT_TIPOMOV== "S"  '
		cFiltro += ' .AND. DToS(FT_ENTRADA)>="'+DToS(dDataDe)+'" .And. DToS(FT_ENTRADA)<="'+DToS(dDataAte)+'"
		cFiltro += ' .AND. Empty(FT_DTCANC) '
		cFiltro += ' .AND. ( AllTrim(FT_ESPECIE)=="CF" .OR. AllTrim(FT_ESPECIE)=="ECF" ) '
		cFiltro	+= ' .AND. ( ( (FT_BASEPIS > 0 .OR.  FT_BASEPS3 > 0) .OR. FT_CSTPIS$"07#08#09#49" ) .OR. ( (FT_BASECOF > 0  .OR.  FT_BASECF3 > 0) .OR. FT_CSTCOF $"07#08#09#49" ) )'
	    If (cNrLivro<>"*")
 		    cFiltro	+=	' .And. FT_NRLIVRO=="'+cNrLivro+'" '
	   	EndIf

	    IndRegua (cAliasSFT, cIndex, SFT->(IndexKey ()),, cFiltro)
	    nIndex := RetIndex(cAliasSFT)

		#IFNDEF TOP
			DbSetIndex (cIndex+OrdBagExt ())
		#ENDIF

		DbSelectArea(cAliasSFT)
	    DbSetOrder(nIndex+1)
	    (cAliasSFT)->(dbGoTop())

#IFDEF TOP
	Endif
#ENDIF

// Tratamento para arquivo consolidado por filiais
If !lRepCGC
	nCt400 := 0
EndIf

// Processa Registros.
Do While !(cAliasSFT)->(Eof())

	// Zerar variaveis
	If !lConsolid
		aRegC400	:= {}
		aRegC405 	:= {}
		aRegC481 	:= {}
		aRegC485 	:= {}
		aRegC489 	:= {}
		nCt405		:= 1
	EndIf

	// Tratamento DBF
    If !lTop // Posiciona na SFI e SLG corretas
    	lSFI_SLG := (cAliasSFI)->(MsSeek(xFilial(cAliasSFI)+DToS((cAliasSFT)->FT_ENTRADA))) .AND. FindSLG(cAliasSLG,(cAliasSFI)->FI_PDV,(cAliasSFI)->FI_SERPDV,@cLGImpFisc,@cLGSerPdv,@cLGPdv)
	EndIf

    // Variavel criada para atender DBF - Se encontrou SFI e SLG referente ao registro -> Em TOP sera sempre .T.
    If lSFI_SLG

	    cChvPDV :=  (cAliasSFT)->FT_PDV
	    dDtReduz := DtoS((cAliasSFT)->FT_ENTRADA)
		// --------------------------------------------------
		// Laco por PDV
		While !(cAliasSFT)->(Eof()) .AND. cChvPDV==(cAliasSFT)->FT_PDV

			// Variavel criada para atender DBF - Se encontrou SFI e SLG referente ao registro -> Em TOP sera sempre .T.
			If lSFI_SLG

				lRegC010 :=.T.
				If (cCGCAnt<>SM0->M0_CGC) .Or. (!lRepCGC) .Or. (lRepCGC .And. (aScan(aRegC010, {|aX| aX[2] == SM0->M0_CGC}) > 0)) //Tratamento para consolidar Filiais com mesmo CNPJ.
					RegC400 (@aRegC400, Iif(lTop,(cAliasSLG)->LG_IMPFISC,cLGImpFisc), Iif(lTop,(cAliasSLG)->LG_SERPDV,cLGSerPdv) ,Iif(lTop,AllTrim((cAliasSLG)->LG_PDV),cLGPdv),;
							 	@nPos400,@nCt400)
					RegC490 (@aRegC490,dDataDe,dDataAte, "2D",@nPos490)
				EndIf

				// Laco por Reducao Z
				cPDV	:= cChvPDV
				cChave 	:= cPDV+dDtReduz
				While !(cAliasSFT)->(Eof())  .AND.  (cChave==(cPDV+dDtReduz))

			   		nVlBrtLj := ( IIf((cAliasSFT)->FT_VALCONT==(cAliasSFI)->FI_VALCON,(cAliasSFI)->FI_VALCON,(cAliasSFT)->FT_VALCONT) + (cAliasSFI)->FI_ISS ) // Valor Bruto, FI_VALCON (Valor contabil) + FI_ISS (Valor de Servicos)

					RegC405(@aRegC405,nPos400,(cAliasSFI)->FI_DTMOVTO,(cAliasSFI)->FI_CRO,;
							(cAliasSFI)->FI_NUMREDZ,(cAliasSFI)->FI_NUMFIM,(cAliasSFI)->FI_GTFINAL,nVlBrtLj,;
							@nPos405,(cAliasSFT)->FT_DESCONT,,(cAliasSFI)->FI_CANCEL)

					RegC481 (cAliasSFT,aRegC481,aRegC485,(cAliasSFI)->FI_PDV,(cAliasSFI)->FI_DTMOVTO,nPos405,@aReg0200,@aReg0205,@aReg0190,dDataDe,dDataAte,cAlias,;
							cRegime,@aRegM400,@aRegM410,@aRegM800,@aRegM810,@aRegM210,@aRegM610,@aRegC491,@aRegC495,lCumulativ,nRelacFil,;
							@aRegM230,@aRegM630,@aReg0500,nPos490,lConsolid,lTop,@aRegC489,@aRegC499,@aReg1010,@aReg1020,lAchouCDG,nMVM996TPR,lA1_TPREG,cMvEstado,/*lCmpsSB5*/,/*lCmpPisUni*/,/*lCmpCofUni*/,/*nPos0200*/,/*cConta*/,/*cProd*/,/*lAScan*/,aDevMsmPer)

			  		(cAliasSFT)->(dbSkip())

			  		// Atualiza Variaveis para laco. Utilizadas para contemplar funcionalidade em DBF
					cPDV		:= (cAliasSFT)->FT_PDV
					dDtReduz    := DtoS((cAliasSFT)->FT_ENTRADA)
				EndDo

				// GRAVA REDUCAO Z E FILHOS
				If !lConsolid
					// Grava
					nPaiC	:=	Iif(nPaiC==0,1,nPaiC)
					PCGrvReg 	(cAlias, nPos400, aRegC405, nCt405,     ,nPaiC  ,        , .T.,nTamTRBIt)
					PCGrvReg 	(cAlias, nPos400, aRegC481, nCt405,     ,nPaiC  ,        , .T. ,nTamTRBIt)
					PCGrvReg 	(cAlias, nPos400, aRegC485, nCt405,     ,nPaiC  ,        , .T. ,nTamTRBIt)
				    nCt405++
				 	aRegC405 	:= {}
					aRegC481 	:= {}
					aRegC485 	:= {}
				EndIf

				// Tratamento DBF
				If !lTop // Posiciona na SFI e SLG corretas
    		    	lSFI_SLG := (cAliasSFI)->(MsSeek(xFilial(cAliasSFI)+DToS((cAliasSFT)->FT_ENTRADA))) .AND. FindSLG(cAliasSLG,(cAliasSFI)->FI_PDV,(cAliasSFI)->FI_SERPDV,@cLGImpFisc,@cLGSerPdv,@cLGPdv)
		  		EndIf

			Else
				(cAliasSFT)->(dbSkip())
			EndIf

		EndDo

		// GRAVA PDV
		If !lConsolid
			PCGrvReg 	(cAlias, nPos400, aRegC489,(nCt405-1)	, ,nPaiC,, .T.,nTamTRBIt)
			PCGrvReg 	(cAlias, nPos400, aRegC400, 			, ,nPaiC,,,nTamTRBIt)
		EndIf

	Else
		(cAliasSFT)->(dbSkip())
	EndIF // If lSFI_SLG

EndDo

#IFDEF TOP
	If (TcSrvType ()<>"AS/400")
		DbSelectArea (cAliasSFT)
		(cAliasSFT)->(DbCloseArea ())
	Else
#ENDIF
		RetIndex("SFT")
#IFDEF TOP
	EndIf
#ENDIF

Return

/*±±ºPrograma  RegD010   ºAutor  Erick G. Dias        º Data   10/02/11º±±
±±ºDesc.      Processamento do registro D010                             º±±*/
Static Function RegD010(cAlias,aRegD010,nPaiD, lGravaD010)


If aScan (aRegD010, {|aX| AllTrim(aX[2])==AllTrim(SM0->M0_CGC)}) == 0
	aAdd(aRegD010, {})
	nPos	:=	Len (aRegD010)
	aAdd (aRegD010[nPos], "D010") //01-REG
	aAdd (aRegD010[nPos], AllTrim(SM0->M0_CGC)) //02-CNPJ
	nPaiD += 1
	lGravaD010:=.T.
EndIf

Return


/*±±ºPrograma  RegD100   ºAutor  Erick G. Dias       º Data   09/02/11 º±±
±±ºDesc.                                                                 º±±
±±ParametroscAlias     -> Alias da tabela tempor¡ria                    ±±
±±          aRegD100   -> Informaµes do registro D100                  ±±
±±          aTotal     -> Totalizador de valores dos itens da nota      ±±
±±          aCmpAntSFT -> Array camo informaµes da nota fiscal         ±±
±±          aPartdoc   -> Informaµes do participante                   ±±
±±          cEspecie   -> Cdigo do modelo do documento fiscal          ±±
±±          cSituaDoc  -> Situao do documento fiscal                  ±±
±±          cEntSai    -> Indica se operao © sa­da ou entrada         ±±
±±          cIndEmit   -> Indica se operao © emisso prrpia          ±±
±±          nRelacDoc  -> Relacionamento com filial processada          ±±
±±          cOpSemF    -> Operao sem frete                            ±±
±±          cCmpFrete  -> Complemento de frete                          ±±
±±          cChvCte    -> Chave CTE                                     ±±
±±          cCodInfCom -> Cdigo da informao complemtar               ±±
±±          aReg0500   -> Informao do registro 0500                   ±±*/
Static Function RegD100(cAlias,aRegD100,aTotal,aCmpAntSFT,aPartdoc,cEspecie,cSituaDoc,;
						cEntSai,cIndEmit,nRelacDoc,cOpSemF,cCmpFrete,cChvCte,cCodInfCom, aReg0500)

Local cDoctms		:= ""

If IntTms() .And. DT6->(MsSeek(xFilial("DT6")+aCmpAntSFT[22]+aCmpAntSFT[1]+aCmpAntSFT[2])) .And. aCmpAntSFT[3]==DT6->DT6_CLIDEV .And. aCmpAntSFT[4]==DT6->DT6_LOJDEV .And. aCmpAntSFT[6]==DT6->DT6_DATEMI
	Do Case
		Case DT6->DT6_DOCTMS $ "1/2/5/6/9/A/B/C/D/F/G/H/I/J/K/N/O"
			cDoctms := "0" //- CT-e Normal
		Case DT6->DT6_DOCTMS $ "7/8/E/L"
			cDoctms := "1" //- CT-e de Complemento de Valores
		Case DT6->DT6_DOCTMS $ "M"
			cDoctms := "2" //- CT-e de Anulao de Valores
		Case DT6->DT6_DOCTMS $ "P"
			cDoctms := "3" //- CT-e Substituto
	EndCase
Else
    Do Case
	   Case aCmpAntSFT[26]=="N"
	     	cDoctms := "0" //- CT-e Normal
	   Case aCmpAntSFT[26]=="C"
	    	cDoctms := "1" //- CT-e de Complemento de Valores
	   Case aCmpAntSFT[26]=="A"
	    	cDoctms := "2" //- CT-e de Anulao de Valores
	   Case aCmpAntSFT[26]=="S"
	    	cDoctms := "3" //- CT-e Substituto
    EndCase
EndIF

aAdd(aRegD100, {})
nPos := Len(aRegD100)
aAdd (aRegD100[nPos], "D100")														//01 - REG
aAdd (aRegD100[nPos], STR(Val (cEntSai)-1,1))										//02 - IND_OPER
aAdd (aRegD100[nPos], cIndEmit)				 										//03 - IND_EMIT
aAdd (aRegD100[nPos], aPartDoc[1])													//04 - COD_PART
aAdd (aRegD100[nPos], cEspecie)														//05 - COD_MOD
aAdd (aRegD100[nPos], cSituaDoc)													//06 - COD_SIT
aAdd (aRegD100[nPos], aCmpAntSFT[2])												//07 - SER
aAdd (aRegD100[nPos], "")															//08 - SUB
aAdd (aRegD100[nPos], aCmpAntSFT[1])												//09 - NUM_DOC
aAdd (aRegD100[nPos], cChvCte)														//10 - CHV_CTE
aAdd (aRegD100[nPos], aCmpAntSFT[6])												//11 - DT_DOC
aAdd (aRegD100[nPos], aCmpAntSFT[5])												//12 - DT_A_P
aAdd (aRegD100[nPos], cDoctms)														//13 - TP_CT-e
aAdd (aRegD100[nPos], "")															//14 - CHV_CTE_REF
aAdd (aRegD100[nPos], aTotal[1])													//15 - VL_DOC
aAdd (aRegD100[nPos], aTotal[9])													//16 - VL_DESC
If cEntSai=="2" .And. IntTms()
	aAdd (aReg[nPos], IIf (cSituaDoc$"02#03", "", aCmpAntSFT[21]))					//17 - IND_FRT
Else
  	If Len(aCmpAntSFT[21]) > 0 .And.  AllTrim(aCmpAntSFT[21]) <> "9"
  		aAdd (aRegD100[nPos], IIf (cSituaDoc$"02#03", "", aCmpAntSFT[21]) ) 		//17 - IND_FRT
  	ElseIf AllTrim(aCmpAntSFT[9])$cOpSemF .OR. aCmpAntSFT[21]=="9"
		aAdd (aRegD100[nPos], IIf (cSituaDoc$"02#03", "", "9") )		     		//17 - IND_FRT
	ElseIf (&(cCmpFrete)>0)
		aAdd (aRegD100[nPos], IIf (cSituaDoc$"02#03", "", "0") )			 		//17 - IND_FRT
	ElseIf Len(aCmpAntSFT[25])>0 .And.  AllTrim(aCmpAntSFT[25])== "CONHEC. FRETE" 	//17 - IND_FRT
		aAdd (aRegD100[nPos], IIf (cSituaDoc$"02#03", "", "2") )
	Else
		aAdd (aRegD100[nPos], IIf (cSituaDoc$"02#03", "", "1") )			 		//17 - IND_FRT
	EndIf
EndIf

aAdd (aRegD100[nPos], aTotal[1] )													//18 - VL_SERV
aAdd (aRegD100[nPos], aTotal[2] )													//19 - VL_BC_ICMS
aAdd (aRegD100[nPos], aTotal[3] )													//20 - VL_ICMS
aAdd (aRegD100[nPos], aTotal[14] )													//21 - VL_NT
aAdd (aRegD100[nPos], cCodInfCom)													//22 - COD_INF
aAdd (aRegD100[nPos], Reg0500(aReg0500,aCmpAntSFT[19]))							//23 - COD_CTA

Return


/*±±ºPrograma  RegD101   ºAutor  Erick G. Dias       º Data   09/02/11 º±±
±±ºDesc.     Gerao do registro D101-Complemento de PIS                 º±±
±±ParametrosaRegD101    -> Informaµes do registro D101                 ±±
±±          cAliasSFT   -> Alias da tabela SFT.                         ±±
±±          aReg0500    -> Informaµes do registro 0500.                ±±
±±          aRegAuxM105 -> Informaµes do registro M105 Cr©dito de PIS  ±±
±±          cRegime     -> Indica o regime do contribuinte.             ±±
±±          lCumulativ  -> INdica se a operao © Cumulativa.           ±±
±±          cIndApro    -> Indicador de aprorpiao do cr©dito.         ±±
±±          aReg0111    -> Totalizadores da receita registro 0111.      ±±
±±          cAliasSB1   -> Totalizadores da receita registro 0111.      ±±*/
Static Function RegD101(aRegD101,cAliasSFT,aReg0500,aRegAuxM105,cRegime,lCumulativ,cIndApro,aReg0111,cAliasSB1)

Local nPos 		:=0
Local nPosD101 	:=0
Local cIndNat   := "0"
Local cConta	:= Reg0500(@aReg0500,(cAliasSFT)->FT_CONTA,,cAliasSFT)

cIndNat := (cAliasSFT)->FT_INDNTFR


nPosD101 := aScan (aRegD101, {|aX| aX[2]==cIndNat .AND.  aX[4]==(cAliasSFT)->FT_CSTPIS .AND.  ;
								    aX[5]==(cAliasSFT)->FT_CODBCC .AND.  aX[7]==(cAliasSFT)->FT_ALIQPIS .AND. aX[9]==cConta})

IF nPosD101 ==0
	aAdd(aRegD101, {})
	nPos := Len(aRegD101)
	aAdd (aRegD101[nPos], "D101")											//01 - REG
	aAdd (aRegD101[nPos], cIndNat)											//02 - IND_NAT_FRT
	aAdd (aRegD101[nPos], (cAliasSFT)->FT_TOTAL)				 			//03 - VL_ITEM
	aAdd (aRegD101[nPos], (cAliasSFT)->FT_CSTPIS)							//04 - CST_PIS
	aAdd (aRegD101[nPos], (cAliasSFT)->FT_CODBCC)							//05 - NAT_BC_CRED
	aAdd (aRegD101[nPos], (cAliasSFT)->FT_BASEPIS)							//06 - VL_BC_PIS
	aAdd (aRegD101[nPos], (cAliasSFT)->FT_ALIQPIS)							//07 - ALIQ_PIS
	aAdd (aRegD101[nPos], (cAliasSFT)->FT_VALPIS)							//08 - VL_PIS
	aAdd (aRegD101[nPos], cConta)											//09 - COD_CTA

Else
	aRegD101[nPosD101][3]+= (cAliasSFT)->FT_TOTAL					 		//03 - VL_ITEM
	aRegD101[nPosD101][6]+= (cAliasSFT)->FT_BASEPIS				 		//06 - VL_BC_PIS
	aRegD101[nPosD101][8]+= (cAliasSFT)->FT_VALPIS				 			//03 -  VL_PIS
EndIF

If (cAliasSFT)->FT_CSTPIS $ "50/51/52/53/54/55/56/60/61/62/63/64/65/66"
	AcumM105(aRegAuxM105,cAliasSFT,cRegime,lCumulativ,cIndApro,aReg0111,,,,,cAliasSB1)
EndIF

Return

/*±±ºPrograma  RegD105   ºAutor  Erick G. Dias       º Data   09/02/11 º±±
±±ºDesc.     Gerao do registro D105 - complemento COFINS               º±±
±±ParametrosaRegD105    -> Informaµes do registro D101                 ±±
±±          cAliasSFT   -> Alias da tabela SFT.                         ±±
±±          aReg0500    -> Informaµes do registro 0500.                ±±
±±          aRegAuxM505 -> Informaµes do registro M105 Cr©dito de PIS  ±±
±±          cRegime     -> Indica o regime do contribuinte.             ±±
±±          lCumulativ  -> INdica se a operao © Cumulativa.           ±±
±±          cIndApro    -> Indicador de aprorpiao do cr©dito.         ±±
±±          aReg0111    -> Totalizadores da receita registro 0111.      ±±*/
Static Function RegD105 (aRegD105,cAliasSFT,aReg0500,aRegAuxM505,cRegime,lCumulativ,cIndApro,aReg0111,cAliasSB1)

Local nPos 		:=0
Local nPosD105 	:=0
Local cIndNat   := "0"
Local cConta	:= Reg0500(@aReg0500,(cAliasSFT)->FT_CONTA,,cAliasSFT)

cIndNat := (cAliasSFT)->FT_INDNTFR

nPosD105 := aScan (aRegD105, {|aX| aX[2]==cIndNat .AND.  aX[4]==(cAliasSFT)->FT_CSTCOF .AND.;
									aX[5]==(cAliasSFT)->FT_CODBCC .AND.  aX[7]==(cAliasSFT)->FT_ALIQCOF .AND. aX[9]==cConta})

IF nPosD105 ==0
	aAdd(aRegD105, {})
	nPos := Len(aRegD105)
	aAdd (aRegD105[nPos], "D105")											//01 - REG
	aAdd (aRegD105[nPos], cIndNat)											//02 - IND_NAT_FRT
	aAdd (aRegD105[nPos], (cAliasSFT)->FT_TOTAL)				 			//03 - VL_ITEM
	aAdd (aRegD105[nPos], (cAliasSFT)->FT_CSTCOF)							//04 - CST_COFINS
	aAdd (aRegD105[nPos], (cAliasSFT)->FT_CODBCC)							//05 - NAT_BC_CRED
	aAdd (aRegD105[nPos], (cAliasSFT)->FT_BASECOF)							//06 - VL_BC_COFINS
	aAdd (aRegD105[nPos], (cAliasSFT)->FT_ALIQCOF - IiF(aFieldPos[15],(cAliasSFT)->FT_MALQCOF,0))	//07 - ALIQ_COFINS
	aAdd (aRegD105[nPos], (cAliasSFT)->FT_VALCOF - IiF(aFieldPos[16],(cAliasSFT)->FT_MVALCOF,0)) 	//08 - VL_COFINS
	aAdd (aRegD105[nPos], cConta )											//09 - COD_CTA

Else
	aRegD105[nPosD105][3]+= (cAliasSFT)->FT_TOTAL					 		//03 - VL_ITEM
	aRegD105[nPosD105][6]+= (cAliasSFT)->FT_BASECOF				 		//06 - VL_BC_COFINS
	aRegD105[nPosD105][8]+= (cAliasSFT)->FT_VALCOF - IiF(aFieldPos[16],(cAliasSFT)->FT_MVALCOF,0)	//03 -  VL_COFINS
EndIF


//Gerao do cr©dito de COFINS no bloco M.

If (cAliasSFT)->FT_CSTPIS $ "50/51/52/53/54/55/56/60/61/62/63/64/65/66"
	AcumM505(aRegAuxM505,cAliasSFT,cRegime,lCumulativ,cIndApro,aReg0111,,,,,cAliasSB1)
EndIF

Return

/*±±ºPrograma  RegD111   ºAutor  Erick G. Dias       º Data   09/02/11 º±±
±±ºDesc.      Processamento do registro D111                             º±±
±±ParametrosaRegD111   -> Array com informaµes do registro D111        ±±
±±          aReg1010   -> Array com Informaµes do registro 1010.       ±±
±±          aReg1020   -> Array com Informaµes do registro 1020.       ±±*/
Static Function RegD111 (aRegD111,aReg1010,aReg1020)

Local	aAreaCDG	:=	CDG->(GetArea())
Local	lRet		:=	.T.
Local	nPos111		:=	1
Local   cChave      := ''
Local   nPos        := 0
Local 	lAchouCCF	:= .F.

cChave := CDG->CDG_FILIAL+CDG->CDG_TPMOV+CDG->CDG_DOC+CDG->CDG_SERIE+CDG->CDG_CLIFOR+CDG->CDG_LOJA

Do while !CDG->(Eof()) .And. CDG->CDG_FILIAL+CDG->CDG_TPMOV+CDG->CDG_DOC+CDG->CDG_SERIE+CDG->CDG_CLIFOR+CDG->CDG_LOJA==cChave

	If (nPos := aScan (aRegD111, {|aX| aX[2]==CDG->CDG_PROCES})==0)
		aAdd(aRegD111, {})
		nPos111 := Len(aRegD111)
		aAdd (aRegD111[nPos111], "D111")				//01 - REG
		aAdd (aRegD111[nPos111], CDG->CDG_PROCES)		//02 - NUM_PROC
		aAdd (aRegD111[nPos111], CDG->CDG_TPPROC)		//03 - IND_PROC
		lAchouCCF	:=	CCF->(MsSeek (xFilial ("CCF")+ CDG->CDG_PROCES +CDG->CDG_TPPROC))
		If	lAchouCCF
			If CCF->CCF_TPCOMP == "1" //Complemento do processo referenciado - Judicial
				Reg1010(aReg1010)
			ElseIf CCF->CCF_TPCOMP == "2" //Complemento do processo referenciado - Administrativo
				Reg1020(aReg1020)
			EndIF
		EndIf

	Endif
	CDG->(DbSkip())
Enddo

RestArea(aAreaCDG)

Return (lRet)

/*±±ºPrograma  RegD200   ºAutor  Erick G. Dias       º Data   09/02/11 º±±
±±ºDesc.      Processamento dos registros D200,D201 e D205.              º±±
±±ParametrosaRegD200   -> Array com informaµes do registro D200        ±±
±±          aRegD201   -> Array com Informaµes do registro D201        ±±
±±          aRegD205   -> Array com Informaµes do registro D205        ±±
±±          aReg0500   -> Array com Informaµes do registro 0500        ±±
±±          cAliasSFT  -> Alias da tabela SFT.                          ±±
±±          dDataDe    -> Data inicial do per­odo                       ±±
±±          dDataAte   -> Data final do per­odo                         ±±
±±          cEspecie   -> Esp©cie da nota fiscal.                       ±±
±±          cSituaDoc  -> Situao do documento fiscal.                 ±±
±±          nPosRet    -> Posio do array D200                         ±±
±±          aRegM210   -> Valores da contribuio PIS registro M210     ±±
±±          aRegM610   -> Valores da contribuio COFINS registro M610  ±±
±±          aWizard    -> Array com valores da wizard.                  ±±
±±          aRegM400   -> Valores do registro M400                      ±±
±±          aRegM410   -> Valores do registro M410                      ±±
±±          aRegM800   -> Valores do registro M800                      ±±
±±          aRegM810   -> Valores do registro M810                      ±±
±±          lCumulativ -> Indica se operao © Cumulativa               ±±
±±          lPisZero   -> Indica tratamento de al­quota zero de PIS     ±±
±±          lCofZero   -> Indica tratamento de al­quota zero de COFINS  ±±
±±          aDevolucao -> Array com devoluµes do per­odo.              ±±
±±          aRegM220   -> Ajustes de PIS registro M220                  ±±
±±          aRegM620   -> Ajustes de Cofins registroM620                ±±
±±          aRegM230   -> Diferimento de PIS registro M230              ±±
±±          aRegM630   -> Diferimento de COFINS registro M630           ±±
±±          cAliasSB1  -> Alias do cadastro de produtos SB1             ±±*/
Static Function RegD200 (aRegD200,aRegD201,aRegD205,aReg0500,cAliasSFT,dDataDe,dDataAte,cEspecie,cSituaDoc,nPosRet,aRegM210,aRegM610,aWizard,;
						aRegM400,aRegM410,aRegM800,aRegM810,lCumulativ,lPisZero, lCofZero,aDevolucao,aRegM220,aRegM620,aRegM230,aRegM630,cAliasSB1,lCpoMajAli)
Local	nPos		:=	0
Local  	nPosD200	:=  0
Local  	nPosD201	:=  0
Local  	nPosD205	:=  0
Local   cConta		:= Reg0500(@aReg0500,(cAliasSFT)->FT_CONTA,,cAliasSFT)
Local	nAlqPis		:= 0
Local	nValPis		:= 0
Local	nBasePis	:= 0
Local	nAlqCof		:= 0
Local	nBaseCof	:= 0
Local	nValCof		:= 0

nAlqPis		:= (cAliasSFT)->FT_ALIQPIS
nBasePis	:= (cAliasSFT)->FT_BASEPIS
nValPis		:= (cAliasSFT)->FT_VALPIS
MajAliqPis(@nAlqPis,@nValPis,cAliasSFT)


nAlqCof		:= (cAliasSFT)->FT_ALIQCOF
nBaseCof  	:= (cAliasSFT)->FT_BASECOF
nValCof		:= (cAliasSFT)->FT_VALCOF
MajAliqVal(@nAlqCof,@nValCof,cAliasSFT,lCpoMajAli)

nPosD200 := aScan(aRegD200, {|aX| aX[2]==cEspecie .AND.  aX[3]==cSituaDoc .AND.  aX[4]== (cAliasSFT)->FT_SERIE .AND.;
							  	   aX[8]==(cAliasSFT)->FT_CFOP .And. aX[9] == (cAliasSFT)->FT_EMISSAO})
If  nPosD200 ==0
	aAdd(aRegD200, {})
	nPos	:= Len (aRegD200)
	nPosRet := nPos
	aAdd (aRegD200[nPos], "D200")													//01 - REG
	aAdd (aRegD200[nPos], cEspecie)													//02 - COD_MOD
	aAdd (aRegD200[nPos], cSituaDoc)												//03 - COD_SIT
	aAdd (aRegD200[nPos], (cAliasSFT)->FT_SERIE)									//04 - SER
	aAdd (aRegD200[nPos], "")														//05 - SUB
	aAdd (aRegD200[nPos], (cAliasSFT)->FT_NFISCAL)									//06 - NUM_DOC_INI
	aAdd (aRegD200[nPos], (cAliasSFT)->FT_NFISCAL)									//07 - NUM_DOC_FIM
	aAdd (aRegD200[nPos], (cAliasSFT)->FT_CFOP)									//08 - CFOP
	aAdd (aRegD200[nPos], (cAliasSFT)->FT_EMISSAO)		   							//09 - DT_REF
	aAdd (aRegD200[nPos], IIf (!cSituaDoc$"02#03", (cAliasSFT)->FT_VALCONT, "0"))	//10 - VL_DOC
	aAdd (aRegD200[nPos],(cAliasSFT)->FT_DESCONT)									//11 - VL_DESC
	If !cSituaDoc$"02#03"
		//Processa registro D201 com valores de PIS
		aAdd(aRegD201, {})
		nPos := Len(aRegD201)
		aAdd (aRegD201[nPos], Len(aRegD200))                        				//-Relacao com D200
		aAdd (aRegD201[nPos], "D201")												//01 - REG
		aAdd (aRegD201[nPos], (cAliasSFT)->FT_CSTPIS)								//02 - CST_PIS
		aAdd (aRegD201[nPos], (cAliasSFT)->FT_VALCONT)				 				//03 - VL_ITEM
		aAdd (aRegD201[nPos], nBasePis)												//04 - VL_BC_PIS
		aAdd (aRegD201[nPos], Iif(lPisZero,0,nAlqPis))			   					//05 - ALIQ_PIS
		aAdd (aRegD201[nPos], Iif(lPisZero,0,nValPis))			  					//06 - VL_PIS
		aAdd (aRegD201[nPos], cConta )												//07 - COD_CTA
		//Processa registros M400 e filhos para PIS
		IF (cAliasSFT)->FT_CSTPIS $ "04/05/06/07/08/09"
			If !(cAliasSFT)->FT_CSTPIS $ "05" //se for CST 04, 06, 07, 08, 09 grava M400 direto
				RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1,,,,(cAliasSFT)->FT_VALCONT)
			ElseIF (cAliasSFT)->FT_ALIQPS3 == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
				RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1,,,,(cAliasSFT)->FT_VALCONT)
			EndIF
		EndIF
		//Inclui valor de PIS no bloco M
		RegM210(aRegM210,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM220,,,@aRegM230,(cAliasSFT)->FT_VALCONT,cAliasSB1)
		//Processa registro D205 com valores de COFINS
		aAdd(aRegD205, {})
		nPos := Len(aRegD205)
		aAdd (aRegD205[nPos], Len(aRegD200))                        				//-Relacao com D200
		aAdd (aRegD205[nPos], "D205")												//01 - REG
		aAdd (aRegD205[nPos], (cAliasSFT)->FT_CSTCOF)								//02 - CST_COFINS
		aAdd (aRegD205[nPos], (cAliasSFT)->FT_VALCONT)				 				//03 - VL_ITEM
		aAdd (aRegD205[nPos], nBaseCof)							  					//04 - VL_BC_COFINS
		aAdd (aRegD205[nPos], Iif(lCofZero,0,nAlqCof))						 		//05 - ALIQ_COFINS
		aAdd (aRegD205[nPos], Iif(lCofZero,0,nValCof))			   					//06 - VL_COFINS
		aAdd (aRegD205[nPos], cConta )												//07 - COD_CTA
		//Processa registros M800 e filhos para COFINS
		If (cAliasSFT)->FT_CSTCOF $ "04/05/06/07/08/09"
			If !(cAliasSFT)->FT_CSTCOF $ "05" //se for CST 04, 06, 07, 08, 09 grava M400 direto
				RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1,,,,(cAliasSFT)->FT_VALCONT)
			ElseIF (cAliasSFT)->FT_ALIQCF3 == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
				RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1,,,,(cAliasSFT)->FT_VALCONT)
			EndIF
		EndIF
		//Inclui valor de COFINS no bloco M
		RegM610(aRegM610,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM620,,,@aRegM630,(cAliasSFT)->FT_VALCONT,cAliasSB1)
	EndIF
Else
	nPosRet := nPosD200
	aRegD200[nPosD200][10] += IIf (!cSituaDoc$"02#03", (cAliasSFT)->FT_VALCONT, "0")	//10 - VL_DOC
	aRegD200[nPosD200][11] += (cAliasSFT)->FT_DESCONT									//11 - VL_DESC
	If val((cAliasSFT)->FT_NFISCAL) < val(aRegD200[nPosD200][6]) 						//06 - NUM_DOC_INI
		aRegD200[nPosD200][6] := (cAliasSFT)->FT_NFISCAL
	EndIF
	IF val((cAliasSFT)->FT_NFISCAL)> val(aRegD200[nPosD200][7])
		aRegD200[nPosD200][7]:=	 (cAliasSFT)->FT_NFISCAL								//07 - NUM_DOC_FIM
	EndIF
	If !cSituaDoc$"02#03"
		//Processa valor de PIS no registro D201
		nPosD201 := aScan (aRegD201, {|aX| aX[3]==(cAliasSFT)->FT_CSTPIS .AND.  aX[6]==Iif(lPisZero,0,nAlqPis) .AND. ;
										    aX[8]==cConta  .AND.  aX[1]==nPosD200 })
		If nPosD201 == 0
			aAdd(aRegD201, {})
			nPos := Len(aRegD201)
			aAdd (aRegD201[nPos], nPosD200)                        				   		//-Relacao com D200
			aAdd (aRegD201[nPos], "D201")												//01 - REG
			aAdd (aRegD201[nPos], (cAliasSFT)->FT_CSTPIS)								//02 - CST_PIS
			aAdd (aRegD201[nPos], (cAliasSFT)->FT_VALCONT)				 				//03 - VL_ITEM
			aAdd (aRegD201[nPos], nBasePis)		   										//04 - VL_BC_PIS
			aAdd (aRegD201[nPos], Iif(lPisZero,0,nAlqPis))			   					//05 - ALIQ_PIS
			aAdd (aRegD201[nPos], Iif(lPisZero,0,nValPis))			   					//06 - VL_PIS
			aAdd (aRegD201[nPos], cConta)												//07 - COD_CTA
		Else
			aRegD201[nPosD201][4]+= (cAliasSFT)->FT_VALCONT					 			//03 - VL_ITEM
			aRegD201[nPosD201][5]+= nBasePis				 		   					//04 - VL_BC_PIS
			aRegD201[nPosD201][7]+= Iif(lPisZero,0,nValPis)			   				//06 -  VL_PIS
		EndIF
		//Processa registros M400 e filhos para PIS
		IF (cAliasSFT)->FT_CSTPIS $ "04/05/06/07/08/09"
			If !(cAliasSFT)->FT_CSTPIS $ "05" //se for CST 04, 06, 07, 08, 09 grava M400 direto
		  		RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1,,,,(cAliasSFT)->FT_VALCONT)
	   		ElseIF (cAliasSFT)->FT_ALIQPS3 == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
		  		RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1,,,,(cAliasSFT)->FT_VALCONT)
			EndIF
		EndIF
		//INclui valor de PIS no bloco M
		RegM210(aRegM210,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM220,,,@aRegM230,(cAliasSFT)->FT_VALCONT,cAliasSB1)
		//Processa COFINS no registro D205
		nPosD205 := aScan (aRegD205, {|aX| aX[3]==(cAliasSFT)->FT_CSTCOF .AND.  aX[6]==Iif(lCofZero,0,nAlqCof) .AND.;
										    aX[8]==cConta .AND.  aX[1]==nPosD200 })
		If nPosD205 == 0
			aAdd(aRegD205, {})
			nPos := Len(aRegD205)
			aAdd (aRegD205[nPos], nPosD200)                        			//-Relacao com D200
			aAdd (aRegD205[nPos], "D205")									//01 - REG
			aAdd (aRegD205[nPos], (cAliasSFT)->FT_CSTCOF)					//02 - CST_COFINS
			aAdd (aRegD205[nPos], (cAliasSFT)->FT_VALCONT)				 	//03 - VL_ITEM
			aAdd (aRegD205[nPos], nBaseCof)									//04 - VL_BC_COFINS
			aAdd (aRegD205[nPos], Iif(lCofZero,0,nAlqCof))					//05 - ALIQ_COFINS
			aAdd (aRegD205[nPos], IIF(lCofZero,0,nValCof))					//06 - VL_COFINS
			aAdd (aRegD205[nPos], cConta )									//07 - COD_CTA
		Else
			aRegD205[nPosD205][4]+= (cAliasSFT)->FT_VALCONT					//03 - VL_ITEM
			aRegD205[nPosD205][5]+= nBaseCof			   					//04 - VL_BC_COFINS
			aRegD205[nPosD205][7]+= Iif(lCofZero,0,nValCof)   				//06 -  VL_COFINS
		EndIF
		//Processa registro M800 e filhos para COFINS
		If (cAliasSFT)->FT_CSTCOF $ "04/05/06/07/08/09"
			If !(cAliasSFT)->FT_CSTCOF $ "05" //se for CST 04, 06, 07, 08, 09 grava M400 direto
		  		RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1,,,,(cAliasSFT)->FT_VALCONT)
			ElseIF (cAliasSFT)->FT_ALIQCF3 == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
		   		RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1,,,,(cAliasSFT)->FT_VALCONT)
			EndIF
		EndIF
		//Inclui valor de COFINS no bloco M.
		RegM610(aRegM610,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM620,,,@aRegM630,(cAliasSFT)->FT_VALCONT,cAliasSB1)
	EndIF
EndIF

Return

/*±±ºPrograma  RegD300   ºAutor  Erick G. Dias       º Data   10/02/11 º±±
±±ºDesc.      Processamento do registro D300                             º±±
±±ParametrosaRegD300   -> Array com informaµes do registro D300        ±±
±±          cEspecie   -> Esp©cie do documento fiscal.                  ±±
±±          cAliasSFT  -> Alias da tabela SFt                           ±±
±±          dDataAte   -> Data inicial do per­odo                       ±±
±±          aReg0500   -> Informaµes do registro 0500                  ±±
±±          nPosRet    -> Posio de retorno do registro D300           ±±
±±          aRegM210   -> Informaµes de contribuio de PIS M210       ±±
±±          aRegM610   -> Informaµes de contribuio de PIS M210       ±±
±±          aWizard    -> Informaµes da wizard                         ±±
±±          lCumulativ -> Indica se operao © Cumulativa               ±±
±±          lPisZero   -> Indica tratamento de al­quota zero de PIS     ±±
±±          lCofZero   -> Indica tratamento de al­quota zero de COFINS  ±±
±±          aDevolucao -> Array com valores da wizard.                  ±±
±±          aRegM220   -> Valores do registro M220                      ±±
±±          aRegM620   -> Valores do registro M620                      ±±
±±          aRegM230   -> Valores do registro M230                      ±±
±±          aRegM630   -> Valores do registro M630                      ±±
±±          cAliasSB1  -> Alias do cadastro de produtos SB1             ±±*/
Static Function RegD300 (aRegD300,cEspecie,cAliasSFT,dDataAte,aReg0500,nPosRet,aRegM210,aRegM610,aWizard,lCumulativ,lPisZero,;
						 lCofZero,aDevolucao,aRegM220,aRegM620,aRegM230,aRegM630,cAliasSB1,lCpoMajAli,aRegM400,aRegM410,aRegM800,aRegM810,lCmpDescZF)
Local	nPos		:=	0
Local  	nPosD300	:=  0
Local	cConta		:= Reg0500(@aReg0500,(cAliasSFT)->FT_CONTA,,cAliasSFT)
Local	nAlqPis		:= 0
Local	nBasePis		:= 0
Local	nValPis		:= 0
Local	nAlqCof		:= 0
Local	nBaseCof	:= 0
Local	nValCof		:= 0

nAlqPis		:= (cAliasSFT)->FT_ALIQPIS
nBasePis	:= (cAliasSFT)->FT_BASEPIS
nValPis		:= (cAliasSFT)->FT_VALPIS
MajAliqPis(@nAlqPis,@nValPis,cAliasSFT)

nAlqCof		:= (cAliasSFT)->FT_ALIQCOF
nBaseCof  	:= (cAliasSFT)->FT_BASECOF
nValCof		:= (cAliasSFT)->FT_VALCOF
MajAliqVal(@nAlqCof,@nValCof,cAliasSFT,lCpoMajAli)

nPosD300 := aScan (aRegD300, {|aX| aX[2] ==  cEspecie .AND.  aX[3]==(cAliasSFT)->FT_SERIE   .AND. ;
								    aX[7] == (cAliasSFT)->FT_CFOP .AND.  aX[11]==(cAliasSFT)->FT_CSTPIS .AND. ;
								    aX[13]== Iif(lPisZero,0,nAlqPis) .AND. aX[15]==(cAliasSFT)->FT_CSTCOF .AND. ;
								    aX[17]== Iif(lCofZero,0,nAlqCof) .AND.  aX[19]==cConta  .AND. ;
								    aX[8] == (cAliasSFT)->FT_ENTRADA })

If  nPosD300 ==0
	aAdd(aRegD300, {})
	nPos	:=	Len (aRegD300)
	nPosRet := nPos
	aAdd (aRegD300[nPos], "D300")													//01 - REG
	aAdd (aRegD300[nPos], cEspecie)													//02 - COD_MOD
	aAdd (aRegD300[nPos], (cAliasSFT)->FT_SERIE)									//03 - SER
	aAdd (aRegD300[nPos], "")				   										//04 - SUB
	aAdd (aRegD300[nPos],  Right(AllTrim((cAliasSFT)->FT_NFISCAL),6))				//05 - NUM_DOC_INI
	aAdd (aRegD300[nPos],  Right(AllTrim((cAliasSFT)->FT_NFISCAL),6))				//06 - NUM_DOC_FIN
	aAdd (aRegD300[nPos], (cAliasSFT)->FT_CFOP)									//07 - CFOP
	aAdd (aRegD300[nPos], (cAliasSFT)->FT_ENTRADA)									//08 - DT_REF
	aAdd (aRegD300[nPos], (cAliasSFT)->FT_TOTAL)									//09 - VL_DOC
	aAdd (aRegD300[nPos],  (cAliasSFT)->FT_DESCONT)								//10 - VL_DESC
	aAdd (aRegD300[nPos], (cAliasSFT)->FT_CSTPIS)									//11 - CST_PIS
	aAdd (aRegD300[nPos], nBasePis)													//12 - BL_BC_PIS
	aAdd (aRegD300[nPos], Iif(lPisZero,0,nAlqPis))									//13 - ALIQ_PIS
	aAdd (aRegD300[nPos], Iif(lPisZero,0,nValPis))									//14 - VL_PIS
	aAdd (aRegD300[nPos], (cAliasSFT)->FT_CSTCOF)									//15 - CST_COFINS
	aAdd (aRegD300[nPos], nBaseCof)		 											//16 - VL_BC_COFINS
	aAdd (aRegD300[nPos], Iif(lCofZero,0,nAlqCof))									//17 - ALIQ_COFINS
	aAdd (aRegD300[nPos], Iif(lCofZero,0,nValCof))									//18 - VL_COFINS
	aAdd (aRegD300[nPos], cConta )													//19 - COD_CTA

Else
	nPosRet := nPosD300
	aRegD300[nPosD300][9]  += (cAliasSFT)->FT_TOTAL								//09 - VL_DOC
	aRegD300[nPosD300][10] += (cAliasSFT)->FT_DESCONT								//10 - VL_DESC
	aRegD300[nPosD300][12] += nBasePis				   								//12 - BL_BC_PIS
	aRegD300[nPosD300][14] += Iif(lPisZero,0,nValPis)			   					//14 - VL_PIS
	aRegD300[nPosD300][16] += nBaseCof							   					//16 - VL_BC_COFINS
	aRegD300[nPosD300][18] += Iif(lCofZero,0,nValCof)			   					//18 - VL_COFINS

	If val(Right(AllTrim((cAliasSFT)->FT_NFISCAL),6)) < Val(aRegD300[nPosD300][5]) //05 - NUM_DOC_INI
		aRegD300[nPosD300][5] := Right(AllTrim((cAliasSFT)->FT_NFISCAL),6)
	EndIF

	IF val(Right(AllTrim((cAliasSFT)->FT_NFISCAL),6)) > Val(aRegD300[nPosD300][6])
		aRegD300[nPosD300][6]:=	 Right(AllTrim((cAliasSFT)->FT_NFISCAL),6)			 //06 - NUM_DOC_FIM
	EndIF
EndIF

RegM210(aRegM210,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM220,,,@aRegM230,,cAliasSB1)
RegM610(aRegM610,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM620,,,@aRegM630,,cAliasSB1)
If (cAliasSFT)->FT_CSTPIS $ "04/05/06/07/08/09"
	If !(cAliasSFT)->FT_CSTPIS $ "05" //se for CST 04, 06, 07, 08, 09 grava M400 direto
		RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1,,,,IIF(Iif(lCmpDescZF,(cAliasSFT)->FT_DESCZFR,0) > 0 ,(cAliasSFT)->FT_TOTAL	+ (cAliasSFT)->FT_DESCZFR,0))
	ElseIF (cAliasSFT)->FT_ALIQPS3 == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
		RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1,,,,IIF(Iif(lCmpDescZF,(cAliasSFT)->FT_DESCZFR,0) > 0 ,(cAliasSFT)->FT_TOTAL	+ (cAliasSFT)->FT_DESCZFR,0))
	EndIF
EndIF
If (cAliasSFT)->FT_CSTCOF $ "04/05/06/07/08/09"
	If !(cAliasSFT)->FT_CSTCOF $ "05" //se for CST 04, 06, 07, 08, 09 grava M400 direto
		RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1,,,,IIF(Iif(lCmpDescZF,(cAliasSFT)->FT_DESCZFR,0) > 0 ,(cAliasSFT)->FT_TOTAL	+ (cAliasSFT)->FT_DESCZFR,0))
	ElseIF (cAliasSFT)->FT_ALIQCF3 == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
		RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1,,,,IIF(Iif(lCmpDescZF,(cAliasSFT)->FT_DESCZFR,0) > 0 ,(cAliasSFT)->FT_TOTAL	+ (cAliasSFT)->FT_DESCZFR,0))
	EndIF
EndIF


Return

/*±±ºPrograma  RegD500   ºAutor  Erick G. Dias       º Data   09/02/11 º±±
±±ºDesc.     Processamento do registro D500                              º±±
±±ParametroscAlias     -> Alias da tabela tempor¡ria                    ±±
±±          nRelacDoc  -> Relacionamento com itens da nota fiscal       ±±
±±          aRegD500   -> Informaµes do registro D500                  ±±
±±          aCmpAntSFT -> Array camo informaµes da nota fiscal         ±±
±±          cIndEmit   -> Indica se nota © emisso prrpia              ±±
±±          aPartDoc   -> Informaµes do participante                   ±±
±±          cEspecie   -> Cdigo do modelo da nota fiscal               ±±
±±          cSituaDoc  -> Situao do documento fiscal                  ±±
±±          cEntSai    -> Indica se operao de entrada ou sa­da        ±±
±±          aTotaliza  -> Totalizador dos valores do item da nota       ±±
±±          cCodInfCom -> Cdigo da informao complementar             ±±
±±          lAchouSFX  -> Indica se encontrou registro da tabela SFX    ±±
±±          nPaiD      -> Relacionamento com D010                       ±±*/
Static Function RegD500(cAlias,nRelacDoc,aRegD500,aCmpAntSFT,cIndEmit,aPartDoc,cEspecie,cSituaDoc,cEntSai,aTotaliza,cCodInfCom,lAchouSFX,nPaiD)

Local nPos 		:= 0
Local nVlTerc   := 0

aAdd(aRegD500, {})
nPos := Len(aRegD500)
aAdd (aRegD500[nPos], "D500")							//01 - REG
aAdd (aRegD500[nPos], STR(Val (cEntSai)-1,1))			//02 - IND_OPER
aAdd (aRegD500[nPos], cIndEmit)				 			//03 - IND_EMIT
aAdd (aRegD500[nPos], aPartDoc[1])						//04 - COD_PART
aAdd (aRegD500[nPos], cEspecie)							//05 - COD_MOD
aAdd (aRegD500[nPos], cSituaDoc)						//06 - COD_SIT
aAdd (aRegD500[nPos], aCmpAntSFT[2])					//07 - SER
aAdd (aRegD500[nPos], "")								//08 - SUB
aAdd (aRegD500[nPos], aCmpAntSFT[1])					//09 - NUM_DOC

aAdd (aRegD500[nPos], aCmpAntSFT[6])					//10 - DT_DOC
aAdd (aRegD500[nPos], aCmpAntSFT[5])					//11 - DT_A_P
aAdd (aRegD500[nPos], aTotaliza[1])					//12 - VL_DOC
aAdd (aRegD500[nPos], aTotaliza[9])					//13 - VL_DESC

aAdd (aRegD500[nPos], aTotaliza[1])					//14 - VL_SERV
aAdd (aRegD500[nPos], 0)									//15 - VL_SERV_NT

aAdd (aRegD500[nPos], aTotaliza[34])					//16 - VL_TERC
aAdd (aRegD500[nPos], aTotaliza[13]) 	   				//17 - VL_DA

aAdd (aRegD500[nPos], aTotaliza[2]) 					//18 - VL_BC_ICMS
aAdd (aRegD500[nPos], aTotaliza[3]) 					//19 - VL_ICMS
aAdd (aRegD500[nPos], cCodInfCom) 						//20 - COD_INF
aAdd (aRegD500[nPos], aTotaliza[19]) 					//21 - VL_PIS
aAdd (aRegD500[nPos], aTotaliza[20])					//22 - VL_COFINS

PCGrvReg (cAlias, nRelacDoc, aRegD500,,,nPaiD,,,nTamTRBIt)

Return

/*±±ºPrograma  RegD501   ºAutor  Erick G. Dias       º Data   10/02/11 º±±
±±ºDesc.     Processamento do registro D501 - PIS                        º±±
±±ParametrosaRegD501    -> Array com informaµes do registro D501       ±±
±±          cAliasSFT   -> Alias da tabela SFT        .                 ±±
±±          aReg0500    -> Informaµes do registro 0500                 ±±
±±          aTotaliza   -> Valores totalizados da nota fiscal           ±±
±±          aRegAuxM105 -> Valores do registro M105                     ±±
±±          cRegime     -> Regime do contribuinte                       ±±
±±          lCumulativ  -> Indica se operao pe Cumulativa             ±±
±±          cIndApro    -> INdicador de apropriao de ´cr©dito         ±±
±±          aReg0111    -> Total receita bruta registro 0111            ±±
±±          cAliasSB1   -> Alias do cadastro de produtos SB1            ±±*/
Static Function RegD501 (aRegD501,cAliasSFT,aReg0500,aTotaliza,aRegAuxM105,cRegime,lCumulativ,cIndApro,aReg0111,cAliasSB1)

Local nPos 		:=0
Local nPosD501 	:=0
Local cIndNat   := ""
Local cConta 	:= Reg0500(@aReg0500,(cAliasSFT)->FT_CONTA,,cAliasSFT)

nPosD501 := aScan (aRegD501, {|aX| aX[2]==(cAliasSFT)->FT_CSTPIS .AND.  aX[6]==(cAliasSFT)->FT_ALIQPIS .AND.  aX[8]==cConta })

IF nPosD501 ==0
	aAdd(aRegD501, {})
	nPos := Len(aRegD501)
	aAdd (aRegD501[nPos], "D501")											//01 - REG
	aAdd (aRegD501[nPos], (cAliasSFT)->FT_CSTPIS)							//02 - CST_PIS
	aAdd (aRegD501[nPos], (cAliasSFT)->FT_TOTAL)				 			//03 - VL_ITEM
	aAdd (aRegD501[nPos], (cAliasSFT)->FT_CODBCC)							//04 - NAT_BC_CRED
	aAdd (aRegD501[nPos], (cAliasSFT)->FT_BASEPIS)							//05 - VL_BC_PIS
	aAdd (aRegD501[nPos], (cAliasSFT)->FT_ALIQPIS)							//06 - ALIQ_PIS
	aAdd (aRegD501[nPos], (cAliasSFT)->FT_VALPIS)							//07 - VL_PIS
	aAdd (aRegD501[nPos], cConta )											//08 - COD_CTA
Else
	aRegD501[nPosD501][3]+= (cAliasSFT)->FT_TOTAL					 		//03 - VL_ITEM
	aRegD501[nPosD501][5]+= (cAliasSFT)->FT_BASEPIS				 		//05 - VL_BC_PIS
	aRegD501[nPosD501][7]+= (cAliasSFT)->FT_VALPIS				 			//07 -  VL_PIS
EndIF


//Inclui valor de cr©dito de PIS no bloco M

If (cAliasSFT)->FT_CSTPIS $ CCSTCRED
	AcumM105(aRegAuxM105,cAliasSFT,cRegime,lCumulativ,cIndApro,aReg0111,,,,,cAliasSB1)
EndIF

aTotaliza[26]+= (cAliasSFT)->FT_VALPIS
Return

/*±±ºPrograma  RegD505   ºAutor  Erick G. Dias       º Data   09/02/11 º±±*/
Static Function RegD505 (aRegD505,cAliasSFT,aReg0500,aTotaliza,aRegAuxM505,cRegime,lCumulativ,cIndApro,aReg0111,cAliasSB1)

Local nPos 		:=0
Local nPosD505 	:=0
Local cIndNat   := ""
Local cConta	:= Reg0500(@aReg0500,(cAliasSFT)->FT_CONTA,,cAliasSFT)

nPosD505 := aScan (aRegD505, {|aX| aX[2]==(cAliasSFT)->FT_CSTCOF .AND.  aX[6]==(cAliasSFT)->FT_ALIQCOF .AND.  aX[8]==cConta })

IF nPosD505 ==0
	aAdd(aRegD505, {})
	nPos := Len(aRegD505)
	aAdd (aRegD505[nPos], "D505")											//01 - REG
	aAdd (aRegD505[nPos], (cAliasSFT)->FT_CSTCOF)							//02 - CST_COFINS
	aAdd (aRegD505[nPos], (cAliasSFT)->FT_TOTAL)				 			//03 - VL_ITEM
	aAdd (aRegD505[nPos], (cAliasSFT)->FT_CODBCC)							//04 - NAT_BC_CRED
	aAdd (aRegD505[nPos], (cAliasSFT)->FT_BASECOF)							//05 - VL_BC_COFINS
	aAdd (aRegD505[nPos], (cAliasSFT)->FT_ALIQCOF - IiF(aFieldPos[15],(cAliasSFT)->FT_MALQCOF,0))	//06 - ALIQ_COFINS
	aAdd (aRegD505[nPos], (cAliasSFT)->FT_VALCOF - IiF(aFieldPos[16],(cAliasSFT)->FT_MVALCOF,0)) 	//07 - VL_COFINS
	aAdd (aRegD505[nPos], cConta )											//08 - COD_CTA
Else
	aRegD505[nPosD505][3]+= (cAliasSFT)->FT_TOTAL					 		//03 - VL_ITEM
	aRegD505[nPosD505][5]+= (cAliasSFT)->FT_BASECOF				 		//05 - VL_BC_COFINS
	aRegD505[nPosD505][7]+= (cAliasSFT)->FT_VALCOF - IiF(aFieldPos[16],(cAliasSFT)->FT_MVALCOF,0)	//07 -  VL_COFINS
EndIF

//Inclui valor de cr©dito de COFINS no bloco M

If (cAliasSFT)->FT_CSTPIS $ CCSTCRED
	AcumM505(aRegAuxM505,cAliasSFT,cRegime,lCumulativ,cIndApro,aReg0111,,,,,cAliasSB1)
EndIf

aTotaliza[27]+= (cAliasSFT)->FT_VALCOF

Return

/*±±ºPrograma  RegD509   ºAutor  Erick G. Dias       º Data   10/02/11 º±±
±±ºDesc.      Processamento do registro C509                             º±±*/
Static Function RegD509 (aRegD509,aReg1010,aReg1020)

Local	aAreaCDG	:=	CDG->(GetArea())
Local	lRet		:=	.T.
Local	nPos509		:=	1
Local   cChave      := ''
Local   nPos        := 0
Local	lAchouCCF	:= .F.

cChave := CDG->CDG_FILIAL+CDG->CDG_TPMOV+CDG->CDG_DOC+CDG->CDG_SERIE+CDG->CDG_CLIFOR+CDG->CDG_LOJA

Do while !CDG->(Eof()) .And. CDG->CDG_FILIAL+CDG->CDG_TPMOV+CDG->CDG_DOC+CDG->CDG_SERIE+CDG->CDG_CLIFOR+CDG->CDG_LOJA==cChave

	If (nPos := aScan (aRegD509, {|aX| aX[2]==CDG->CDG_PROCES})==0)
		aAdd(aRegD509, {})
		nPos509 := Len(aRegD509)
		aAdd (aRegD509[nPos509], "D509")				//01 - REG
		aAdd (aRegD509[nPos509], CDG->CDG_PROCES)		//02 - NUM_PROC
		aAdd (aRegD509[nPos509], CDG->CDG_TPPROC)		//03 - IND_PROC
		lAchouCCF	:=	CCF->(MsSeek (xFilial ("CCF")+ CDG->CDG_PROCES +CDG->CDG_TPPROC))
		If	lAchouCCF
			If CCF->CCF_TPCOMP == "1" //Complemento do processo referenciado - Judicial
				Reg1010(aReg1010)
			ElseIf CCF->CCF_TPCOMP == "2" //Complemento do processo referenciado - Administrativo
				Reg1020(aReg1020)
			EndIF
		EndIf
	Endif
	CDG->(DbSkip())
Enddo

RestArea(aAreaCDG)

Return (lRet)

/*±±ºPrograma  RegD600   ºAutor  Erick G. Dias       º Data   10/02/11 º±±
±±ºDesc.     Gerao dos registros D600, D601 e D605                     º±±
±±ParametrosaRegD600   -> Informaµes do registro D600                  ±±
±±          aRegD601   -> Informaµes do registro D601                  ±±
±±          aRegD605   -> Informaµes do registro D605                  ±±
±±          aReg0500   -> Informaµes do registro 0500                  ±±
±±          cAliasSFT  -> Alias da tabela SFT.                          ±±
±±          dDataDe    -> Data inicial do per­odo                       ±±
±±          dDataAte   -> Data final do per­odo                         ±±
±±          cEspecie   -> Codigo do modelo documento fiscal             ±±
±±          cSituaDoc  -> Situao do documento fiscal                  ±±
±±          aPartdoc   -> Informaµes do participante                   ±±
±±          nPosRet    -> Posio do array D600                         ±±
±±          aRegM210   -> Informaµes do registro M210                  ±±
±±          aRegM610   -> Informaµes do registro M610                  ±±
±±          aWizard    -> Informaµes da wizard                         ±±
±±          aRegM400   -> Informaµes do registro M400                  ±±
±±          aRegM410   -> Informaµes do registro M410                  ±±
±±          aRegM800   -> Informaµes do registro M800                  ±±
±±          aRegM810   -> Informaµes do registro M810                  ±±
±±          lAchouSFX  -> Indica se encontrou informao da tabela SFX  ±±
±±          aTotaliza  -> Totalizador de valores da nota fiscal         ±±
±±          lCumulativ -> Indica se operao pe Cumulativa              ±±
±±          lPisZero   -> Indica tratamento de al­quota zero PIS        ±±
±±          lCofZero   -> Indica tratamento de al­quota zero COFINS     ±±
±±          aDevolucao -> Array com devoluµes do per­odo               ±±
±±          aRegM220   -> Informaµes do registro M220  		          ±±
±±          aRegM620   -> Informaµes do registro M620                  ±±
±±          aRegM230   -> Informaµes do registro M230                  ±±
±±          aRegM630   -> Informaµes do registro M630                  ±±
±±          cAliasSB1  -> Indica tratamento de al­quota zero de COFINS  ±±*/
Static Function RegD600(aRegD600,aRegD601,aRegD605,aReg0500,cAliasSFT,dDataDe,dDataAte,cEspecie,cSituaDoc,aPartdoc,;
						nPosRet,aRegM210,aRegM610,aWizard,aRegM400,aRegM410,aRegM800,aRegM810,lAchouSFX,aTotaliza,;
						lCumulativ,lPisZero,lCofZero,aDevolucao,aRegM220,aRegM620,aRegM230,aRegM630,cAliasSB1,lSFT,;
						cAliasSD2,cAliasSF4,cAliasSFX)

Local nPos		:= 0
Local nPosD600	:= 0
Local nPosD601	:= 0
Local nPosD605	:= 0
Local cCodClass := ""
Local nNatRec	:= ""
Local nVlTerc	:=0
local cConta	:= ""
Local nAlqPis	:= 0
Local nBasePis	:= 0
Local nValPis	:= 0
Local nAlqCof	:= 0
Local nBaseCof	:= 0
Local nValCof	:= 0
Local cCodMun	:= ""
Local cSerie	:= ""
Local nTotal 	:= 0
Local nDescont	:= 0
Local nValServ	:= 0
Local nValDA	:= 0
Local nBaseIcm	:= 0
Local nValIcm	:= 0
Local nDescPis	:= 0
Local nDescCof	:= 0
Local cCstPis	:= ""
Local cCstCof	:= ""
Local nAliqPs3	:= 0 	//Aliquota de Pis st
Local nAliqCf3	:= 0	//Aliquota de Cofins st
Local lCmpEstRec:= 	aFieldPos[38]
Local lMVESTTELE:=  aParSX6[3]
Local lEstorna	:= .F.
Local aD600M200	:= {}
Local aD600M600	:= {}

DEFAULT lSFT		:= .T.
DEFAULT cAliasSD2	:= ""
DEFAULT lPisZero	:= .F.
DEFAULT lCofZero	:= .F.

IF lSFT
	cConta		:= Reg0500(@aReg0500,(cAliasSFT)->FT_CONTA,,cAliasSFT)
	cCodMun		:= aPartdoc[7]
	cSerie		:= (cAliasSFT)->FT_SERIE
	nTotal 		:= (cAliasSFT)->FT_TOTAL
	nDescont	:= (cAliasSFT)->FT_DESCONT
	nValServ	:= (cAliasSFT)->FT_VALCONT
	nValDA		:= aTotaliza[13]
	nBaseIcm	:= (cAliasSFT)->FT_BASEICM
	nValIcm		:= (cAliasSFT)->FT_VALICM
	If lAchouSFX
		nNatRec  := SFX->FX_TIPOREC
		nVlTerc  := SFX->FX_VALTERC
		If TamSx3("FX_GRPCLAS")[1] == 2 .And. Len(Alltrim(SFX->FX_GRPCLAS)) == 2
			cCodClass	:= SFX->FX_GRPCLAS+SFX->FX_CLASSIF
		Else
			cCodClass	:= Iif("A"$SFX->FX_GRPCLAS,"10","0"+Alltrim(SFX->FX_GRPCLAS))+SFX->FX_CLASSIF
		EndIf
	EndIf

	cAliqPs3    := (cAliasSFT)->FT_ALIQPS3
	cCstPis		:= (cAliasSFT)->FT_CSTPIS
	nAlqPis		:= (cAliasSFT)->FT_ALIQPIS
	nBasePis	:= (cAliasSFT)->FT_BASEPIS
	nValPis		:= (cAliasSFT)->FT_VALPIS
	MajAliqPis(@nAlqPis,@nValPis,cAliasSFT)

	nAliqCf3	:= (cAliasSFT)->FT_ALIQCF3
	cCstCof		:= (cAliasSFT)->FT_CSTCOF
	nAlqCof		:= (cAliasSFT)->FT_ALIQCOF
	nBaseCof  	:= (cAliasSFT)->FT_BASECOF
	nValCof		:= (cAliasSFT)->FT_VALCOF
	MajAliqVal(@nAlqCof,@nValCof,cAliasSFT)

	If SFX->FX_TIPOREC == "0" .AND. lMVESTTELE .AND. lCmpEstRec
		IF SFX->FX_ESTREC <> "2"
			lEstorna	:= .T.
			nDescPis	:= nBasePis
			nDescCof	:= nBaseCof
			nBasePis	:= 0
			nBaseCof	:= 0
			nValPis		:= 0
			nValCof		:= 0
		EndIF
	EndIF

Else

	nNatRec  	:= (cAliasSFX)->FX_TIPOREC
	nVlTerc  	:= (cAliasSFX)->FX_VALTERC
	cCodMun		:= IIF(Len(aPartdoc)>0,aPartdoc[7],"")
	cCstPis		:= (cAliasSF4)->F4_CSTPIS
	cCstCof		:= (cAliasSF4)->F4_CSTCOF
	cConta		:= Reg0500(aReg0500,(cAliasSD2)->D2_CONTA,,)
	cSerie		:= (cAliasSD2)->D2_SERIE
	nValCof		:= (cAliasSD2)->D2_VALIMP5
	nBaseCof  	:= (cAliasSD2)->D2_BASIMP5
	nAlqCof		:= (cAliasSD2)->D2_ALQIMP5
	nValPis		:= (cAliasSD2)->D2_VALIMP6
	nBasePis	:= (cAliasSD2)->D2_BASIMP6
	nAlqPis  	:= (cAliasSD2)->D2_ALQIMP6

	nTotal 		:= (cAliasSD2)->D2_TOTAL
	nDescont	:= (cAliasSD2)->D2_DESC
	nValServ	:= (cAliasSD2)->D2_TOTAL
	nValDA		:=  Iif ((cAliasSD2)->D2_DESPESA-(cAliasSD2)->D2_SEGURO > 0,(cAliasSD2)->D2_DESPESA-(cAliasSD2)->D2_SEGURO,0)
	nBaseIcm	:= (cAliasSD2)->D2_BASEICM
	nValIcm		:= (cAliasSD2)->D2_VALICM

	nNatRec  := (cAliasSFX)->FX_TIPOREC
	nVlTerc  := (cAliasSFX)->FX_VALTERC
	If TamSx3("FX_GRPCLAS")[1] == 2 .And. Len(Alltrim((cAliasSFX)->FX_GRPCLAS)) == 2
		cCodClass	:= (cAliasSFX)->FX_GRPCLAS+(cAliasSFX)->FX_CLASSIF
	Else
		cCodClass	:= Iif("A"$(cAliasSFX)->FX_GRPCLAS,"10","0"+Alltrim((cAliasSFX)->FX_GRPCLAS))+(cAliasSFX)->FX_CLASSIF
	EndIf

	aAdd(aD600M200,cCstPis)
	aAdd(aD600M200,nAlqPis)
	aAdd(aD600M200,nBasePis)
	aAdd(aD600M200,nTotal)
	aAdd(aD600M200,nValPis)
	aAdd(aD600M200,(cAliasSD2)->D2_TNATREC)
	aAdd(aD600M200,(cAliasSD2)->D2_CNATREC)
	aAdd(aD600M200,(cAliasSD2)->D2_GRUPONC)
	aAdd(aD600M200,(cAliasSD2)->D2_DTFIMNT)
	aAdd(aD600M200,cConta)
	aAdd(aD600M600,cCstCof)
	aAdd(aD600M600,nAlqCof)
	aAdd(aD600M600,nBaseCof)
	aAdd(aD600M600,nTotal)
	aAdd(aD600M600,nValCof)
	aAdd(aD600M600,(cAliasSD2)->D2_TNATREC)
	aAdd(aD600M600,(cAliasSD2)->D2_CNATREC)
	aAdd(aD600M600,(cAliasSD2)->D2_GRUPONC)
	aAdd(aD600M600,(cAliasSD2)->D2_DTFIMNT)
	aAdd(aD600M600,cConta)

EndIF

nPosD600 := aScan (aRegD600, {|aX| aX[2]==cEspecie .AND.  aX[3]==cCodMun .AND.  aX[4]==cSerie .AND. aX[6]==nNatRec})
If nPosD600 == 0
	aAdd(aRegD600, {})
	nPos 	:= Len(aRegD600)
	nPosRet := nPos
	aAdd (aRegD600[nPos], "D600")						//01 - REG
	aAdd (aRegD600[nPos], cEspecie)						//02 - COD_MOD
	aAdd (aRegD600[nPos], cCodMun)				 		//03 - COD_MUN
	aAdd (aRegD600[nPos], cSerie)	   					//04 - SER
	aAdd (aRegD600[nPos], "")							//05 - SUB
	aAdd (aRegD600[nPos], nNatRec)						//06 - IND_REC
	aAdd (aRegD600[nPos], "1")							//07 - QTD_CONS
	aAdd (aRegD600[nPos], dDataDe)						//08 - DT_DOC_INI
	aAdd (aRegD600[nPos], dDataATe)						//09 - DT_DOC_FIN
	aAdd (aRegD600[nPos], nTotal)	   					//10 - VL_DOC
	aAdd (aRegD600[nPos], nDescont)						//11 - VL_DESC
	aAdd (aRegD600[nPos], nValServ)						//12 - VL_SERV
	aAdd (aRegD600[nPos], 0)							//13 - VL_SERV_NT
	aAdd (aRegD600[nPos], nVlTerc)						//14 - VL_TERC
	aAdd (aRegD600[nPos], nValDA)		  				//15 - VL_DA
	aAdd (aRegD600[nPos], nBaseIcm)						//16 - VL_BC_ICMS
	aAdd (aRegD600[nPos], nVAlIcm) 	   					//17 - VL_ICMS
	aAdd (aRegD600[nPos], Iif(lPisZero,0,nValPis))		//18 - VL_PIS
	aAdd (aRegD600[nPos], Iif(lCofZero,0,nValCof)) 	//19 - VL_COFINS

	//D601
	aAdd(aRegD601, {})
	nPos := Len(aRegD601)
	aAdd (aRegD601[nPos], Len(aRegD600))                   //-Relacao com D600
	aAdd (aRegD601[nPos], "D601")							//01 - REG
	aAdd (aRegD601[nPos], cCodClass)						//02 - COD_CLASS
	aAdd (aRegD601[nPos], nTotal)							//03 - VL_ITEM
	aAdd (aRegD601[nPos], nDescPis)				 			//04 - VL_DESC
	aAdd (aRegD601[nPos], cCStPis)							//05 - CST_PIS
	aAdd (aRegD601[nPos], nBasePis)							//06 - VL_BC_PIS
	aAdd (aRegD601[nPos], Iif(lPisZero,0,nAlqPis))		   	//07 - ALIQ_PIS
	aAdd (aRegD601[nPos], Iif(lPisZero,0,nValPis))		   	//08 - VL_PIS
	aAdd (aRegD601[nPos], cConta )							//09 - COD_CTA

	IF cCStPis $ "04/05/06/07/08/09"
		If !cCStPis $ "05" //se for CST 04, 06, 07, 08, 09 grava M400 direto
			RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1,,aD600M200)
		ElseIF nAliqPs3 == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
			RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1,,aD600M200)
		EndIF
	EndIF

	RegM210(aRegM210,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM220,(!lSFT),,@aRegM230,,cAliasSB1,,,,,aD600M200,lEstorna,,.T.)

	//D605
	aAdd(aRegD605, {})
	nPos := Len(aRegD605)
	aAdd (aRegD605[nPos], Len(aRegD600))                   	//-Relacao com D600
	aAdd (aRegD605[nPos], "D605")							//01 - REG
	aAdd (aRegD605[nPos], cCodClass)						//02 - COD_CLASS
	aAdd (aRegD605[nPos], nTotal)							//03 - VL_ITEM
	aAdd (aRegD605[nPos], nDescCof)				 			//04 - VL_DESC
	aAdd (aRegD605[nPos], cCStCof)							//05 - CST_COFINS
	aAdd (aRegD605[nPos], nBaseCof)							//06 - VL_BC_COFINS
	aAdd (aRegD605[nPos], Iif(lCofZero,0,nAlqCof))			//07 - ALIQ_COFINS
	aAdd (aRegD605[nPos], Iif(lCofZero,0,nValCof))			//08 - VL_COFINS
	aAdd (aRegD605[nPos], cConta )							//09 - COD_CTA


	If cCStCof $ "04/05/06/07/08/09"
		If !cCStCof $ "05" //se for CST 04, 06, 07, 08, 09 grava M400 direto
			RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1,,aD600M600)
		ElseIF nAliqCf3 == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
			RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1,,aD600M600)
		EndIF
	EndIF


	RegM610(aRegM610,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM620,(!lSFT),,@aRegM630,,cAliasSB1,,,,,aD600M600,lEstorna,,.T.)

Else
	nPosRet := nPosD600
	aRegD600[nPosD600][7] := cvaltochar(val(aRegD600[nPosD600][7] ) +=1)	//07 - QTD_CONS
	aRegD600[nPosD600][10]+= nTotal											//10 - VL_DOC
	aRegD600[nPosD600][11]+= nDescont										//11 - VL_DESC
	aRegD600[nPosD600][12]+= nValServ										//12 - VL_SERV
	aRegD600[nPosD600][14]+= nVlTerc										//14 - VL_TERCC
	aRegD600[nPosD600][15]+= nValDA											//15 - VL_DA
	aRegD600[nPosD600][16]+= nBaseIcm										//16 - VL_BC_ICMS
	aRegD600[nPosD600][17]+= nValIcm 	   									//17 - VL_ICMS
	aRegD600[nPosD600][18]+= Iif(lPisZero,0,nValPis) 						//18 - VL_PIS
	aRegD600[nPosD600][19]+= Iif(lCofZero,0,nValCof) 						//19 - VL_COFINS

	//D601
	nPosD601 := aScan (aRegD601, {|aX| aX[3]==cCodClass .AND.  aX[6]==cCStPis .AND.  aX[8]== Iif(lPisZero,0,nAlqPis) .AND. aX[10]==cConta .AND.  aX[1]==nPosD600 })
	If nPosD601 ==0
		aAdd(aRegD601, {})
		nPos := Len(aRegD601)
		aAdd (aRegD601[nPos], nPosD600 )                   	//-Relacao com D600
		aAdd (aRegD601[nPos], "D601")						//01 - REG
		aAdd (aRegD601[nPos], cCodClass)					//02 - COD_CLASS
		aAdd (aRegD601[nPos], nTotal)						//03 - VL_ITEM
		aAdd (aRegD601[nPos], nDescPis)				 		//04 - VL_DESC
		aAdd (aRegD601[nPos], cCstPis)						//05 - CST_PIS
		aAdd (aRegD601[nPos], nBasePis)						//06 - VL_BC_PIS
		aAdd (aRegD601[nPos], Iif(lPisZero,0,nAlqPis))	   	//07 - ALIQ_PIS
		aAdd (aRegD601[nPos], Iif(lPisZero,0,nValPis))	   	//08 - VL_PIS
		aAdd (aRegD601[nPos], cConta )						//09 - COD_CTA
	Else
		aRegD601[nPosD601][4]+= nTotal					 	//03 - VL_ITEM
		aRegD601[nPosD601][5]+= nDescPis				   	//04 - VL_DESC
		aRegD601[nPosD601][7]+= nBasePis				   	//06 - VL_BC_PIS
		aRegD601[nPosD601][9]+= Iif(lPisZero,0,nValPis)	//08 -  VL_PIS
	EndIF

	RegM210(aRegM210,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM220,(!lSFT),,@aRegM230,,cAliasSB1,,,,,aD600M200,lEstorna,,.T.)

	IF cCstPis $ "04/05/06/07/08/09"
		If !cCstPis $ "05" //se for CST 04, 06, 07, 08, 09 grava M400 direto
			RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1,,aD600M200)
		ElseIF nAliqPs3 == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
			RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1,,aD600M200)
		EndIF
	EndIF

	//D605
	nPosD605 := aScan (aRegD605, {|aX| aX[3]==cCodClass .AND.  aX[6]==cCstCof .AND.  aX[8]== Iif(lCofZero,0,nAlqCof) .AND. aX[10]==cConta .AND.  aX[1]==nPosD600 })
	If nPosD605 ==0
		aAdd(aRegD605, {})
		nPos := Len(aRegD605)
		aAdd (aRegD605[nPos], nPosD600 )                   	//-Relacao com D600
		aAdd (aRegD605[nPos], "D605")						//01 - REG
		aAdd (aRegD605[nPos], cCodClass)					//02 - COD_CLASS
		aAdd (aRegD605[nPos], nTotal)						//03 - VL_ITEM
		aAdd (aRegD605[nPos], nDescCof)				 		//04 - VL_DESC
		aAdd (aRegD605[nPos], cCStCof)						//05 - CST_COFINS
		aAdd (aRegD605[nPos], nBaseCof)					   	//06 - VL_BC_COFINS
		aAdd (aRegD605[nPos], Iif(lCofZero,0,nAlqCof))	  	//07 - ALIQ_COFINS
		aAdd (aRegD605[nPos], Iif(lCofZero,0,nValCof))	   	//08 - VL_COFINS
		aAdd (aRegD605[nPos], cConta )						//09 - COD_CTA
	Else
		aRegD605[nPosD605][4]+= nTotal					 	//03 - VL_ITEM
		aRegD605[nPosD605][5]+= nDescCof				    //04 - VL_DESC
		aRegD605[nPosD605][7]+= nBaseCof				   	//06 - VL_BC_COFINS
		aRegD605[nPosD605][9]+= Iif(lCofZero,0,nValCof)	//08 -  VL_COFINS
	EndIf

	//Inclui detalhamento de PIS nos registros M800 e filhos
	If cCStCof $ "04/05/06/07/08/09"
		If !cCStCof $ "05" //se for CST 04, 06, 07, 08, 09 grava M400 direto
			RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1,,aD600M600)
		ElseIF nAliqCf3 == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
			RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1,,aD600M600)
		EndIF
	EndIF
	//Incluir valor da contribuio da COFINS no bloco M
	RegM610(aRegM610,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM620,(!lSFT),,@aRegM630,,cAliasSB1,,,,,aD600M600,lEstorna,,.T.)
EndIf

Return

/*±±ºPrograma  RegM210   ºAutor  Erick G. Dias       º Data   18/02/11 º±±
±±ºDesc.      Processamento do registro M210                             º±±*/
Static Function RegM210(aRegM210,cAliasSFT,cCodIcTrib,lcumulativ,aDevolucao,aRegM220,lSemNota,aF100,aRegM230,nlVTotal,cAliasSB1,cChaveCCX,cAliasCF8,aD350,aAtvImob,aPar,lEstorno,aDevMsmPer,lD600,lST2030, lPtCalcul, nBcPt, nVlPt)

Local nPos	   		:= 0
Local nPos210		:= 0
Local nAjustAcr 	:= 0
Local nAjustRed 	:= 0
Local nDifer	 	:= 0
Local nDiferAnt		:= 0
Local nPisPauta		:= 0
Local nContApur		:= 0
Local nQtdBPis		:= 0
Local nPosDevol		:= 0
Local nAliqPis		:= 0
Local nBcPis		:= 0
Local nTotalRec		:= 0
Local nValPis		:= 0
Local nCont			:= 0
Local cCondCont		:= ""
Local cCstPis		:= ""
Local cChaveSFT		:= ""
Local cChaveSE1		:= ""
Local cChaveCCZ		:= ""
Local lPauta		:= .F.
Local lPautaPIS		:=	.F.
Local lDif			:= .F.
Local aBaseAlqUn	:= {}


DEFAULT  lEstorno	:= .F.
DEFAULT  lST2030	:= .F.
DEFAULT  aDevolucao	:= {}
DEFAULT  aRegM220 	:= {}
DEFAULT  aRegM230 	:= {}
DEFAULT  aD350		:= {}
DEFAULT  aPar		:= {}
DEFAULT  aF100		:= {}
DEFAULT  aAtvImob   := {}
DEFAULT  lSemNota 	:= .F.
DEFAULT  nlVTotal   := 0
DEFAULT  cAliasSB1	:= "SB1"
DEFAULT  cChaveCCX	:= ""
DEFAULT	 cAliasCF8	:= ""
DEFAULT  aDevMsmPer	:= {}
DEFAULT  lD600		:= .F.
DEFAULT	 lPtCalcul	:= .F.  //Indica se a aliquota e o valor do PIS ja foi calculado por pauta
DEFAULT  nBcPt		:=  0
DEFAULT  nVlPt		:=  0

IF lGrBlocoM
	//Se for pela nota irei utilizar os valores que esto na tabela SFT
	IF !lSemNota

		cCstPis		:= (cAliasSFT)->FT_CSTPIS
		IF (cAliasSFT)->FT_CSTPIS == "05"
			nAliqPis	:= (cAliasSFT)->FT_ALIQPS3
		Else
			nAliqPis	:= (cAliasSFT)->FT_ALIQPIS
		EndIF
		nTotalRec	:= Iif((nlVTotal>0),nlVTotal,(cAliasSFT)->FT_TOTAL)
		If !lDevolucao
			nBcPis		:= Iif((cAliasSFT)->FT_CSTPIS == "05",(cAliasSFT)->FT_BASEPS3,(cAliasSFT)->FT_BASEPIS)
			nValPis		:= Iif((cAliasSFT)->FT_CSTPIS == "05",(cAliasSFT)->FT_VALPS3 ,(cAliasSFT)->FT_VALPIS)
		Else
			nPosDevol := aScan (aDevMsmPer, {|aX| aX[1]==(cAliasSFT)->FT_NFISCAL .AND. aX[2]==(cAliasSFT)->FT_EMISSAO .AND. aX[3]==(cAliasSFT)->FT_SERIE .AND. aX[4]==(cAliasSFT)->FT_ITEM  .AND. aX[5]==(cAliasSFT)->FT_CLIEFOR  .AND. aX[6]==(cAliasSFT)->FT_LOJA })
			If nPosDevol > 0
				nBcPis		:= (cAliasSFT)->FT_BASEPIS - aDevMsmPer[nPosDevol][7]
				nValPis		:= (cAliasSFT)->FT_VALPIS - aDevMsmPer[nPosDevol][8]
			Endif
		EndIF
		IF lEstorno
			nBcPis	:= 0
			nValPis	:= 0
		EndIF

		If lST2030
			cCstPis 	:= aPar[1]
			If cCstPis == "05"
				nBcPis		:= (cAliasSFT)->FT_BASEPS3
				nValPis		:= (cAliasSFT)->FT_VALPS3
			Else
				nBcPis		:= (cAliasSFT)->FT_BASEPIS
				nValPis		:= (cAliasSFT)->FT_VALPIS
			EndIF
			nTotalRec	:= aPar[3]
		EndIF

	ElseIF Len(aF100) >0 // Se nao tiver nota, so os t­tulos lanados manualmente no financeiro, neste caso no utilizo os valores da SFT, e sim os valores da funo que o financeiro disponibilizou.
		cCstPis		:= aF100[7]
		nAliqPis	:= aF100[9]
		nBcPis		:= aF100[8]
		nTotalRec	:= aF100[6]
		nValPis     := aF100[10]
	ElseIF !Empty(cAliasCF8)
		cCstPis		:= (cAliasCF8)->CF8_CSTPIS
		nAliqPis	:= (cAliasCF8)->CF8_ALQPIS
		nBcPis		:= (cAliasCF8)->CF8_BASPIS
		nTotalRec	:= (cAliasCF8)->CF8_VLOPER
		nValPis     := (cAliasCF8)->CF8_VALPIS
	ElseIf Len(aD350)>0
		cCstPis		:= aD350[11]
		nAliqPis	:= aD350[13]
		nBcPis		:= aD350[12]
		nTotalRec	:= aD350[10]
		nValPis		:= aD350[16]
	ElseIf Len(aAtvImob) > 0
		cCstPis		:= aAtvImob[12]
		nAliqPis	:= aAtvImob[14]
		nBcPis		:= aAtvImob[13]
		nTotalRec	:= aAtvImob[11]
		nValPis     := aAtvImob[15]
	ElseIf Len(aPar) > 0
		cCstPis		:= aPar[1]
		nAliqPis	:= aPar[2]
		nBcPis		:= aPar[3]
		nTotalRec	:= aPar[4]
		nValPis     := aPar[5]

		If !lD600
			If len(aPar) > 5
				lPauta		:=aPar[6]
			EndIF

			IF lPauta
				nPisPauta	:= nAliqPis
				nQtdBPis	:= nBcPis
			EndIF
		EndIF
	EndIF

	// Chamada da funcao que retorna o Codigo da Contribuicao.	 |
	cCondCont := SPDCodCont("PIS", lSemNota, cCstPis,nAliqPis,lcumulativ,aAtvImob,cRegime,,aParSX6[5])

	If !lSemNota
		If (cAliasSFT)->FT_PAUTPIS > 0
			If lPtCalcul
	        	nPisPauta	:=  nBcPt
	        	nQtdBPis    :=  nVlPt
				lPauta:=.T.
			ElseIf (cAliasSFT)->FT_PAUTPIS > 0 .OR. (cAliasSB1)->B1_VLR_PIS > 0
				aBaseAlqUn:=VlrPauta(lCmpNRecFT, lCmpNRecB1, "PIS",cAliasSFT,cAliasSB1,lCmpNRecF4,lPautaPIS)
				nPisPauta := Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][1] , Iif((cAliasSFT)->FT_PAUTPIS > 0,(cAliasSFT)->FT_PAUTPIS,(cAliasSB1)->B1_VLR_PIS))
				nQtdBPis  := Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][2] , (cAliasSFT)->FT_QUANT)
				lPauta:=.T.
			EndIF
		EndIF
	EndIF

	If !Empty(cCondCont)
		If lPauta
			nPos210 := aScan (aRegM210, {|aX| aX[2]==cCondCont .AND.  cvaltochar(aX[7])==cvaltochar(nPisPauta) })
		Else
			nPos210 := aScan (aRegM210, {|aX| aX[2]==cCondCont .AND.  cvaltochar(aX[5])==cvaltochar(nAliqPis) })
		EndIF

		If nPos210 == 0

			aAdd(aRegM210, {})
			nPos := Len(aRegM210)

			aAdd (aRegM210[nPos], "M210")			   		//01 - REG
			aAdd (aRegM210[nPos], cCondCont)				//02 - COD_CONT
			aAdd (aRegM210[nPos], nTotalRec)				//03 - VL_REC_BRT
			If lPauta
				nContApur:=nValPis
				aAdd (aRegM210[nPos], "0")			   		//04 - VL_BC_CONT
				aAdd (aRegM210[nPos], "")					//05 - ALIQ_PIS
				aAdd (aRegM210[nPos], nQtdBPis)				//06 - QUANT_BC_PIS
				aAdd (aRegM210[nPos], nPisPauta)			//07 - ALIQ_PIS_QUANT
			Else
				nContApur:=   nValPis
				aAdd (aRegM210[nPos], nBcPis)				//04 - VL_BC_CONT
				aAdd (aRegM210[nPos], nAliqPis)				//05 - ALIQ_PIS
				aAdd (aRegM210[nPos], "")					//06 - QUANT_BC_PIS
				aAdd (aRegM210[nPos], "")					//07 - ALIQ_PIS_QUANT
			EndIF

			aAdd (aRegM210[nPos], nContApur)				//08 - VL_CONT_APUR
			aAdd (aRegM210[nPos], nAjustAcr)				//09 - VL_AJUS_ACRES

			//Neste trecho verifico se existem deduµes de per­odo       
			//anterior para gerao dos registros M220, para abater      
			//o valor de contribuio, com ajuste de reduo.            
			//Fao separado, deduo No Cumulativo e deduo Cumulativa.

			//Contribuio No Cumlativa

			IF cCondCont $ SpdXRetCod(1,{"NC"}) .AND. nDedAPisNC > 0
				For nCont	:= 1 to Len(aDedAPisNC)
					IF aDedAPisNC[nCont][2] > 0
						IF aDedAPisNC[nCont][2] <= ( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt)
							RegM220(@aRegM220,.F.,nPos,aDedAPisNC[nCont][2],"05",,strzero(day(stod(aDedAPisNC[nCont][1])),2)+strzero(month(stod(aDedAPisNC[nCont][1])),2)+strzero(year(stod(aDedAPisNC[nCont][1])),4),"Saldo de Deduo de PIS referªnte ao per­odo anterior, proveniente do registro F700","F700")
							nAjustRed += aDedAPisNC[nCont][2]
							aDedAPisNC[nCont][2]	:= 0
						Else
							RegM220(@aRegM220,.F.,nPos,( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt),"05",,strzero(day(stod(aDedAPisNC[nCont][1])),2)+strzero(month(stod(aDedAPisNC[nCont][1])),2)+strzero(year(stod(aDedAPisNC[nCont][1])),4),"Saldo de Deduo de PIS referªnte ao per­odo anterior, proveniente do registro F700","F700")
							aDedAPisNC[nCont][2]	:= aDedAPisNC[nCont][2] - ( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt)
							nAjustRed += ( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt)
							Exit
						EndIF
					EndIF
				Next nCont

			//Contribuio Cumulativa

			ElseIF cCondCont $ SpdXRetCod(1,{"C"}) .AND. nDedAPisC > 0
				For nCont	:= 1 to Len(aDedAPisC)
					IF aDedAPisC[nCont][2] > 0
						IF aDedAPisC[nCont][2] <= ( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt)
							RegM220(@aRegM220,.F.,nPos,aDedAPisC[nCont][2],"05",,strzero(day(stod(aDedAPisC[nCont][1])),2)+strzero(month(stod(aDedAPisC[nCont][1])),2)+strzero(year(stod(aDedAPisC[nCont][1])),4),"Saldo de Deduo de PIS referªnte ao per­odo anterior, proveniente do registro F700","F700")
							nAjustRed += aDedAPisC[nCont][2]
							aDedAPisC[nCont][2]	:= 0
						Else
							RegM220(@aRegM220,.F.,nPos,( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt),"05",,strzero(day(stod(aDedAPisC[nCont][1])),2)+strzero(month(stod(aDedAPisC[nCont][1])),2)+strzero(year(stod(aDedAPisC[nCont][1])),4),"Saldo de Deduo de PIS referªnte ao per­odo anterior, proveniente do registro F700","F700")
							aDedAPisC[nCont][2]	:= aDedAPisC[nCont][2] - ( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt)
							nAjustRed += ( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt)
							Exit
						EndIF
					EndIF
				Next nCont
			EndiF

			aAdd (aRegM210[nPos], nAjustRed)												//10 - VL_AJUS_REDUC
			aAdd (aRegM210[nPos], nDifer)													//11 - VL_CONT_DIFER
			aAdd (aRegM210[nPos], nDiferAnt)												//12 - VL_CONT_DIFER_ANT
			aAdd (aRegM210[nPos], nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt )	//13 - VL_CONT_PER
		Else

			aRegM210[nPos210][3]+= nTotalRec				 			//03 - VL_ITEM
			If lPauta
				nContApur:=nValPis
				aRegM210[nPos210][6]+= nQtdBPis				 			//06 - QUANT_BC_PIS
			Else
				nContApur:=nValPis
				aRegM210[nPos210][4]+= nBcPis				 			//04 - VL_BC_CONT
			EndIF

			aRegM210[nPos210][8]+= nContApur				 			//08 - VL_CONT_APUR
			aRegM210[nPos210][9]+= nAjustAcr				 			//09 - VL_AJUS_ACRES

			//Neste trecho verifico se existem deduµes de per­odo       
			//anterior para gerao dos registros M220, para abater      
			//o valor de contribuio, com ajuste de reduo.            
			//Fao separado, deduo No Cumulativo e deduo Cumulativa.

			//Contribuio No Cumlativa

			IF cCondCont $ SpdXRetCod(1,{"NC"}) .AND. nDedAPisNC > 0
				For nCont	:= 1 to Len(aDedAPisNC)
					IF aDedAPisNC[nCont][2] > 0
						IF aDedAPisNC[nCont][2] <= ( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt)
							RegM220(@aRegM220,.F.,nPos210,aDedAPisNC[nCont][2],"05",,strzero(day(stod(aDedAPisNC[nCont][1])),2)+strzero(month(stod(aDedAPisNC[nCont][1])),2)+strzero(year(stod(aDedAPisNC[nCont][1])),4),"Saldo de Deduo de PIS referªnte ao per­odo anterior, proveniente do registro F700","F700")
							nAjustRed += aDedAPisNC[nCont][2]
							aDedAPisNC[nCont][2]	:= 0
						Else
							RegM220(@aRegM220,.F.,nPos210,( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt),"05",,strzero(day(stod(aDedAPisNC[nCont][1])),2)+strzero(month(stod(aDedAPisNC[nCont][1])),2)+strzero(year(stod(aDedAPisNC[nCont][1])),4),"Saldo de Deduo de PIS referªnte ao per­odo anterior, proveniente do registro F700","F700")
							aDedAPisNC[nCont][2]	:= aDedAPisNC[nCont][2] - ( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt)
							nAjustRed += ( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt)
							Exit
						EndIF
					EndIF
				Next nCont

			//Contribuio Cumulativa

			ElseIF cCondCont $ SpdXRetCod(1,{"C"}) .AND. nDedAPisC > 0
				For nCont	:= 1 to Len(aDedAPisC)
					IF aDedAPisC[nCont][2] > 0
						IF aDedAPisC[nCont][2] <= ( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt)
							RegM220(@aRegM220,.F.,nPos210,aDedAPisC[nCont][2],"05",,strzero(day(stod(aDedAPisC[nCont][1])),2)+strzero(month(stod(aDedAPisC[nCont][1])),2)+strzero(year(stod(aDedAPisC[nCont][1])),4),"Saldo de Deduo de PIS referªnte ao per­odo anterior, proveniente do registro F700","F700")
							nAjustRed += aDedAPisC[nCont][2]
							aDedAPisC[nCont][2]	:= 0
						Else
							RegM220(@aRegM220,.F.,nPos210,( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt),"05",,strzero(day(stod(aDedAPisC[nCont][1])),2)+strzero(month(stod(aDedAPisC[nCont][1])),2)+strzero(year(stod(aDedAPisC[nCont][1])),4),"Saldo de Deduo de PIS referªnte ao per­odo anterior, proveniente do registro F700","F700")
							aDedAPisC[nCont][2]	:= aDedAPisC[nCont][2] - ( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt)
							nAjustRed += ( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt)
							Exit
						EndIF
					EndIF
				Next nCont
			EndiF

			aRegM210[nPos210][10]+= nAjustRed				 								//10 - VL_AJUS_REDUC
			aRegM210[nPos210][11]+= nDifer				 									//11 - VL_CONT_DIFER
			aRegM210[nPos210][12]+= nDiferAnt				 								//12 - VL_CONT_DIFER_ANT
			aRegM210[nPos210][13]+= nContApur +nAjustAcr - nAjustRed - nDifer + nDiferAnt	//13 - VL_CONT_PER

		EndIF
	EndIF
EndIF
Return

/*±±ºPrograma  RegM200   ºAutor  Erick G. Dias       º Data   18/02/11 º±±
±±ºDesc.      Processamento do registro M200                             º±±*/
Static Function RegM200(cAlias,aRegM200,aRegM210,aReg1300,aRegM220,cRegime,aRegM230,aF600Tmp,aReg1300, cPer, cPerArq, aRegM211,cIndNatJur,cIndTipCoo,nCrPrAlPIS,lProcAnt,aRegM205)

Local nCont			:= 0
Local nCampo2 		:= 0
Local nCampo3		:= 0
Local nCampo4		:= 0
Local nCampo5		:= 0
Local nCampo6		:= 0
Local nCampo7		:= 0
Local nCampo8		:= 0
Local nCampo9		:= 0
Local nCampo10		:= 0
Local nCampo11		:= 0
Local nCampo12		:= 0
Local nCampo13		:= 0
Local nUsarRet		:= 0
Local nVlRetUsad	:= 0
Local nVlrContr		:= 0
Local nCPisRet		:= 0
Local a1300Aux 		:= {}
Local dUltDia 		:= LastDay (DDATAATE) + 1
Local cPerAtu 		:= cvaltochar(strzero(month(dUltDia ),2)) + cvaltochar(year(dUltDia ))
Local lSldAntr       := .T. 

DEFAULT cIndTipCoo	:= ""
DEFAULT aRegM205  := {}
IF lGrBlocoM
    For nCont := 1 to len(aRegM210)

        IF aRegM210[nCont][2] $ SpdXRetCod(1,{"NC"})
            nCampo2 += aRegM210[nCont][13] // VL_CONT_PER
        ElseIf aRegM210[nCont][2] $ SpdXRetCod(1,{"C"})
            nCampo9 += aRegM210[nCont][13] // VL_CONT_PER
        EndIF

    Next nCont

    nCampo3 := aRegM200[1][3] //VL_REC_BRT
    nCampo4 := aRegM200[1][4] //VL_BC_CONT
    nCampo5 := Round(nCampo2 - nCampo3 - nCampo4,2)

    nVlrContr := nCampo5
    RetAntPis(cPerArq,a1300Aux,lProcAnt)
        nCPisRet :=0
        If cRegime <> "2" // Se for exclusivamente cumulativo ser¡ gerado com zero
            For nCont := 1 to Len(a1300Aux)
                If a1300Aux[nCont][5] =="0"
                    nCPisRet :=a1300Aux[nCont][4]
                    If nCPisRet <= nVlrContr
                        If  nVlRetUsad <= nVlrContr
                            nCampo6 += nCPisRet
                            nUsarRet := nCPisRet
                            nVlRetUsad += nUsarRet
                            IIf(lProcAnt, Reg1300(@aReg1300,nUsarRet, cPer,a1300Aux[nCont][1],a1300Aux[nCont][3],a1300Aux[nCont][2],a1300Aux[nCont][5],a1300Aux[nCont][4],nUsarRet,lProcAnt),;
            					          Reg1300(@aReg1300,a1300Aux[nCont][4], cPer,a1300Aux[nCont][1], a1300Aux[nCont][4],a1300Aux[nCont][2],a1300Aux[nCont][5],,, lProcAnt))
                        EndIf
                    Else
                        If nVlRetUsad < nVlrContr
                            nCampo6 += nVlrContr - nVlRetUsad
                            nUsarRet := nVlrContr - nVlRetUsad
                            nVlRetUsad += nUsarRet
                            IIf(lProcAnt, Reg1300(@aReg1300,nUsarRet, cPer,a1300Aux[nCont][1],a1300Aux[nCont][3],a1300Aux[nCont][2],a1300Aux[nCont][5],a1300Aux[nCont][4],nUsarRet,lProcAnt),;
            					          Reg1300(@aReg1300,nUsarRet, cPer,a1300Aux[nCont][1],a1300Aux[nCont][4],a1300Aux[nCont][2],a1300Aux[nCont][5],,,lProcAnt))   //valor fracionado
                        Else
                            IIf(lProcAnt, Reg1300(@aReg1300,0       , cPer,a1300Aux[nCont][1],a1300Aux[nCont][3],a1300Aux[nCont][2],a1300Aux[nCont][5],a1300Aux[nCont][4],0,lProcAnt),;
            					          Reg1300(@aReg1300,0, cPer,a1300Aux[nCont][1],a1300Aux[nCont][4],a1300Aux[nCont][2],a1300Aux[nCont][5],,,lProcAnt) )
                        EndIF
                    EndIf
                EndIF

            Next nCont


            For nCont := 1 to Len(aF600Tmp)
                If nCont>1
                	lProcAnt:=.F.
                Endif
                If aF600Tmp[nCont][7] == "0" // Cumulativo
                    nCPisRet += aF600Tmp[nCont][9] //Pis No cumulativo cumulativo
                    If nCPisRet <= nVlrContr
                        nCampo6 += aF600Tmp[nCont][9]
                        nUsarRet := aF600Tmp[nCont][9]
                        nVlRetUsad += nUsarRet
                        IIf(lProcAnt, Reg1300(@aReg1300,nUsarRet, cPer,aF600Tmp[nCont][2], aF600Tmp[nCont][9],aF600Tmp[nCont][3], aF600Tmp[nCont][7],,nVlRetUsad,lProcAnt),;   //valor integral,;
                                      Reg1300(@aReg1300,aF600Tmp[nCont][9], cPer,aF600Tmp[nCont][2], aF600Tmp[nCont][9],aF600Tmp[nCont][3], aF600Tmp[nCont][7],,,lProcAnt))
                    Else
                        If nVlRetUsad < nVlrContr
                            nCampo6 += nVlrContr - nVlRetUsad
                            nUsarRet := nVlrContr - nVlRetUsad
                            nVlRetUsad += nUsarRet
                            IIf(lProcAnt, Reg1300(@aReg1300,nUsarRet, cPer,aF600Tmp[nCont][2],aF600Tmp[nCont][9],aF600Tmp[nCont][3], aF600Tmp[nCont][7],,nVlRetUsad,lProcAnt),;
                                          Reg1300(@aReg1300,nUsarRet, cPer,aF600Tmp[nCont][2],aF600Tmp[nCont][9],aF600Tmp[nCont][3], aF600Tmp[nCont][7],,,lProcAnt))
                        Else
                            IIf(lProcAnt, Reg1300(@aReg1300,0, cPer,aF600Tmp[nCont][2],aF600Tmp[nCont][9],aF600Tmp[nCont][3], aF600Tmp[nCont][7],,0,lProcAnt),;
                                          Reg1300(@aReg1300,0, cPer,aF600Tmp[nCont][2],aF600Tmp[nCont][9],aF600Tmp[nCont][3], aF600Tmp[nCont][7],,,lProcAnt))
                        EndIF
                    EndIf
                EndIF
            Next nCont
        EndIf

        nCampo8 := nCampo5 - nCampo6

        IF nCampo8 > nCrPrAlPIS     //Tratamento para cr©dito presumido de ¡lcool, conforma nota t©cnica 003/2013
            nCampo7	+= nCrPrAlPIS
            nCampo8	:= nCampo8 - nCrPrAlPIS
        Elseif cRegime <> "2" .AND. nCrPrAlPIS > 0
		//Caso exista valor de cr©dito superior ao valor do d©bito do per­odo, ser¡ transportado para prximo per­odo atrav©s do registro 1100
            CredFutPIS(cPer,"107", nCrPrAlPIS,nCampo8,(nCrPrAlPIS - nCampo8) ,0,cPer)
            nCampo7	:=  nCampo8
            nCampo8	:= 0
        EndIF

	   //Tratamento para deduµes diversas do registro F700 - valores no cumulativos
        IF nCampo8 > nDedPISNC
            nCampo7	+= nDedPISNC
            nCampo8	:= nCampo8 - nDedPISNC
        Elseif cRegime <> "2" .AND. nDedPISNC > 0
            SaldoDed(dDataAte, cPerAtu, "0", nDedPISNC - nCampo8, 0,"D") // Guarda o saldo de deduµes para prximos per­odos.
            nCampo7	+=  nCampo8
            nCampo8	:= 0
        EndIF

        nVlrContr :=  nCampo9 //Fim do tratamento de valores No Cumulativos e In­cio do tratamento de valores Cumulativos
        nCPisRet  :=0
        nVlRetUsad	:= 0
        If cRegime <> "1" // Se for exclusivamente no cumulativo ser¡ gerado com zero

            For nCont := 1 to Len(a1300Aux)
                 lSldAntr := .F. 
                If a1300Aux[nCont][5] =="1"
                    nCPisRet :=a1300Aux[nCont][4]
                    If nCPisRet > 0
                       lSldAntr := .T.
                    EndIf 
                    If nCPisRet <= nVlrContr
                        If	nVlRetUsad <= nVlrContr
                        
                        	nVlrContr := nVlrContr - nCPisRet
                        	nCampo10 += nCPisRet
                            nUsarRet := nCPisRet
                            nVlRetUsad += nUsarRet
                            IIf(lProcAnt,	Reg1300(@aReg1300,nUsarRet, cPer,a1300Aux[nCont][1],a1300Aux[nCont][3],a1300Aux[nCont][2],a1300Aux[nCont][5],a1300Aux[nCont][4],nUsarRet,lProcAnt),;
        						            Reg1300(@aReg1300,a1300Aux[nCont][4], cPer,a1300Aux[nCont][1], a1300Aux[nCont][4],a1300Aux[nCont][2],a1300Aux[nCont][5],,,lProcAnt))
                        EndIf
                    Else
                        If nVlRetUsad < nVlrContr
                            nCampo10 += nVlrContr - nVlRetUsad
                            nUsarRet := nVlrContr - nVlRetUsad
                            nVlRetUsad += nUsarRet
                            IIf(lProcAnt,	Reg1300(@aReg1300,nUsarRet, cPer,a1300Aux[nCont][1],a1300Aux[nCont][3],a1300Aux[nCont][2],a1300Aux[nCont][5],a1300Aux[nCont][4],nUsarRet,lProcAnt),;
        									Reg1300(@aReg1300,nUsarRet, cPer,a1300Aux[nCont][1],a1300Aux[nCont][4],a1300Aux[nCont][2],a1300Aux[nCont][5],,,lProcAnt))

                        Elseif nVlRetUsad + nCPisRet > nVlrContr .And. nVlrContr > 0
        					nCampo10 :=  nCampo9
        					IIf(lProcAnt,	Reg1300(@aReg1300,nUsarRet, cPer,a1300Aux[nCont][1],a1300Aux[nCont][3],a1300Aux[nCont][2],a1300Aux[nCont][5],a1300Aux[nCont][4],nUsarRet,lProcAnt),;
        					            	Reg1300(@aReg1300,a1300Aux[nCont][4], cPer,a1300Aux[nCont][1], a1300Aux[nCont][4],a1300Aux[nCont][2],a1300Aux[nCont][5],,,lProcAnt))
        					nUsarRet :=   nVlrContr
        					nVlrContr := 0
        					a1300Aux[nCont][2] := Soma1(substr(a1300Aux[nCont][2],1,2)) + substr(a1300Aux[nCont][2],3,4)
        					IIf(lProcAnt,	Reg1300(@aReg1300,nUsarRet, cPer,a1300Aux[nCont][1],a1300Aux[nCont][3],a1300Aux[nCont][2],a1300Aux[nCont][5],a1300Aux[nCont][4],nUsarRet,lProcAnt),;
        					            	Reg1300(@aReg1300,nUsarRet, cPer,a1300Aux[nCont][1], a1300Aux[nCont][4],a1300Aux[nCont][2],a1300Aux[nCont][5],,,lProcAnt))
                        Else
                            IIf(lProcAnt, Reg1300(@aReg1300,0       , cPer,a1300Aux[nCont][1],a1300Aux[nCont][3],a1300Aux[nCont][2],a1300Aux[nCont][5],a1300Aux[nCont][4],0,lProcAnt),;
        						Reg1300(@aReg1300,0, cPer,a1300Aux[nCont][1],a1300Aux[nCont][4],a1300Aux[nCont][2],a1300Aux[nCont][5],,,lProcAnt))
                        EndIF
                    EndIf
                EndIF

            Next nCont

            For nCont := 1 to Len(aF600Tmp)
                If nCont>1
                	lProcAnt:=.F.
                Endif

                If aF600Tmp[nCont][7] == "1" // Cumulativo
                    nCPisRet += aF600Tmp[nCont][9] //Pis No cumulativo cumulativo
                    If nCPisRet <= nVlrContr 
                        nVlrContr -=aF600Tmp[nCont][9]
                        nCampo10 += aF600Tmp[nCont][9]
                        nUsarRet := aF600Tmp[nCont][9]
                        nVlRetUsad += nUsarRet
                        IIf(lProcAnt, Reg1300(@aReg1300,nUsarRet, cPer,aF600Tmp[nCont][2], aF600Tmp[nCont][9],aF600Tmp[nCont][3], aF600Tmp[nCont][7],,nVlRetUsad,lProcAnt),;
        					          Reg1300(@aReg1300,aF600Tmp[nCont][9], cPer,aF600Tmp[nCont][2], aF600Tmp[nCont][9],aF600Tmp[nCont][3], aF600Tmp[nCont][7],,,lProcAnt))
                    Else
							If nVlRetUsad < nVlrContr           
							   nCampo10 += nVlrContr - nVlRetUsad
	                        nUsarRet := nVlrContr - nVlRetUsad
	                        nVlRetUsad += nUsarRet
	                        nVlrContr := 0
	                           
                            IIf(lProcAnt, Reg1300(@aReg1300,nUsarRet, cPer,aF600Tmp[nCont][2],aF600Tmp[nCont][9],aF600Tmp[nCont][3], aF600Tmp[nCont][7],,nVlRetUsad,lProcAnt),;
        						          Reg1300(@aReg1300,nUsarRet, cPer,aF600Tmp[nCont][2],aF600Tmp[nCont][9],aF600Tmp[nCont][3], aF600Tmp[nCont][7],,,lProcAnt) )
        					           
							ElseIf nVlrContr <  nCPisRet  .And. lSldAntr
	                            nCampo10  := nCPisRet
	                            nVlRetUsad := aF600Tmp[nCont][9]
	                             
	                            IIf(lProcAnt, Reg1300(@aReg1300,nVlRetUsad, cPer,aF600Tmp[nCont][2],aF600Tmp[nCont][9],aF600Tmp[nCont][3], aF600Tmp[nCont][7],,nVlRetUsad,lProcAnt),;
        							          Reg1300(@aReg1300,nUsarRet, cPer,aF600Tmp[nCont][2],aF600Tmp[nCont][9],aF600Tmp[nCont][3], aF600Tmp[nCont][7],,,lProcAnt) )
                                               
                        Else
                        		IIf(lProcAnt, Reg1300(@aReg1300,0, cPer,aF600Tmp[nCont][2],aF600Tmp[nCont][9],aF600Tmp[nCont][3], aF600Tmp[nCont][7],,0,lProcAnt),;
        						          Reg1300(@aReg1300,0, cPer,aF600Tmp[nCont][2],aF600Tmp[nCont][9],aF600Tmp[nCont][3], aF600Tmp[nCont][7],, ,lProcAnt) )
                        EndIF
                    EndIf
                EndIF
            Next nCont

        EndIf

        nCampo12 := nCampo9 - nCampo10

        IF nCampo12 > nDedPISC
            nCampo11	:= nDedPISC
            nCampo12	:= nCampo12 - nCampo11
        ElseiF cRegime <> "1" .AND. nDedPISC > 0
            SaldoDed(dDataAte, cPerAtu, "1", nDedPISC - nCampo12, 0,"D") // Guarda o saldo de deduµes para prximos per­odos.
            nCampo11	:=  nCampo12
            nCampo12	:= 0
        EndIF

        nCampo13 := nCampo8 + nCampo12

        aRegM200[1][2] := nCampo2				//03 - VL_TOT_CRED_DESC
        aRegM200[1][5] := nCampo5				//05 - VL_TOT_CONT_NC_DEV
        aRegM200[1][6] := nCampo6				//06 - VL_RET_NC
        aRegM200[1][7] := nCampo7				//07 - V_OUT_DED_NC
        aRegM200[1][8] := nCampo8				//08 - VL_CONT_NC_REC
        aRegM200[1][9] := nCampo9				//09 - VL_TOT_CONT_CUM_PER
        aRegM200[1][10]:= nCampo10				//10 - VL_RET_CUM
        aRegM200[1][11]:= nCampo11				//11 - VL_OUT_DED_CUM
        aRegM200[1][12]:= nCampo12				//12 - VL_CONT_CUM_REC
        aRegM200[1][13]:= nCampo13				//13 - VL_TOT_CONT_REC

        //Tratamento para gerar o Registro M205
        If dDataDe >= cToD("01/01/2014") .And. (nCampo8 >0 .Or. nCampo12 > 0)
        	RegM205(@aRegM205,nCampo8,nCampo12,aRegM200)
        EndIf


        GrRegDep (cAlias, aRegM200, aRegM205,,,,,nTamTRBIt)
        GrRegDep (cAlias, aRegM210, aRegM211,,,,,)
        GrRegDep (cAlias, aRegM210, aRegM220,.T.,,,,)
        GrRegDep (cAlias, aRegM210, aRegM230,.T.,,,,)
    EndIF
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} RegM205
Processamento do registro M205

@param  aRegM205  - Array com informaµes do registro M205
	    nValNCum  - Valor da Contribuio No Cumulativa a Recolher/Pagar
		nValCumul - Valor da Contribuio Cumulativa a Recolher/Pagar
		aRegM200  - Array com as informaµes do registro M200

@author Simone dos Santos de Oliveira
@since 25.04.2014
@version 11.80
/*/
//-------------------------------------------------------------------
Static Function RegM205(aRegM205,nValNCum,nValCumul,aRegM200)

Local nPos		  := 0
Local nX		  := 0
Local aMVCODREC:= RetCodRec()

Default nValNCum  := 0
Default nValCumul := 0

For nX:= 1 to len(aRegM200)
	If nValNCum > 0
		aAdd (aRegM205, {})
		nPos :=	Len (aRegM205)
		aAdd (aRegM205[nPos], nX)	   							//01 - REG DO PAI
		aAdd (aRegM205[nPos], "M205")							//02 - REG
		aAdd (aRegM205[nPos], "08")		   						//03 - NUM_CAMPO
		aAdd (aRegM205[nPos], aMVCODREC[2]) 					//04 - COD_REC
		aAdd (aRegM205[nPos], nValNCum)	  						//05 - VL_DEBITO
	EndIf

	If nValCumul > 0
		aAdd (aRegM205, {})
		nPos :=	Len (aRegM205)
		aAdd (aRegM205[nPos], nX)	   							//01 - REG DO PAI
		aAdd (aRegM205[nPos], "M205")							//02 - REG
		aAdd (aRegM205[nPos], "12")		   						//03 - NUM_CAMPO
		aAdd (aRegM205[nPos], aMVCODREC[1]) 					//04 - COD_REC
		aAdd (aRegM205[nPos], nValCumul)						//05 - VL_DEBITO

	EndIf
Next nY
Return


/*±±ºPrograma  RegM610   ºAutor  Erick G. Dias       º Data   18/02/11 º±±
±±ºDesc.      Processamento do registro M610                             º±±*/
Static Function RegM610(aRegM610,cAliasSFT,cCodIcTrib,lcumulativ,aDevolucao,aRegM620,lSemNota,aF100,aRegM630,nlVTotal,cAliasSB1,cChaveCCX,cAliasCF8,aD350,aAtvImob,aPar,lEstorno,aDevMsmPer,lD600,lST2030, lPtCalcul, nBcPt, nVlPt)
Local nPos			:= 0
Local nPos610		:= 0
Local nAjustAcr 	:= 0
Local nAjustRed 	:= 0
Local nDifer	 	:= 0
Local nDiferAnt		:= 0
Local cCondCont		:= ""
Local nContApur		:= 0
Local nCofPauta		:= 0
Local nQtdBCof		:= 0
Local lPauta		:= .F.
Local lPautaCOF		:=	.F.
Local nPosDevol		:= 0
Local cCstCof		:= ""
Local nAliqCof		:= 0
Local nBcCof		:= 0
Local nTotalRec		:= 0
Local lDif			:= .F.
Local cChaveSFT		:= ""
Local cChaveSE1		:= ""
Local nValCof		:= 0
Local aBaseAlqUn	:= {}
Local nCont			:= 0

DEFAULT	 lEstorno	:= .F.
DEFAULT  lST2030	:= .F.
DEFAULT  aDevolucao	:= {}
DEFAULT  aRegM620 	:= {}
DEFAULT  aRegM630 	:= {}
DEFAULT  aD350		:= {}
DEFAULT  aPAr		:= {}
DEFAULT  aF100		:= {}
DEFAULT  aAtvImob	:= {}
DEFAULT  aPar		:= {}
DEFAULT  lSemNota 	:= .F.
DEFAULT  nlVTotal   := 0
DEFAULT  cAliasSB1	:= "SB1"
DEFAULT	 cChaveCCX	:= ""
DEFAULT	 cAliasCF8	:= ""
DEFAULT  aDevMsmPer	:= {}
DEFAULT  lD600		:= .F.
DEFAULT	 lPtCalcul	:= .F.  //Indica se a aliquota e o valor da COFINS ja foi calculado por pauta
DEFAULT  nBcPt		:=  0
DEFAULT  nVlPt		:=  0

IF lGrBlocoM
	//Se for pela nota irei utilizar os valores que esto na tabela SFT
	IF !lSemNota

		cCstCof		:= (cAliasSFT)->FT_CSTCOF
		If (cAliasSFT)->FT_CSTCOF == "05"
			nAliqCof	:= (cAliasSFT)->FT_ALIQCF3
			MajAliqVal(@nAliqCof,,cAliasSFT)
		Else
			nAliqCof	:= (cAliasSFT)->FT_ALIQCOF
			MajAliqVal(@nAliqCof,,cAliasSFT)
		EndIF

		nTotalRec	:= Iif((nlVTotal>0),nlVTotal,(cAliasSFT)->FT_TOTAL)
		If !lDevolucao
			nBcCof		:= Iif((cAliasSFT)->FT_CSTPIS == "05",(cAliasSFT)->FT_BASECF3,(cAliasSFT)->FT_BASECOF)
			nValCof		:= Iif((cAliasSFT)->FT_CSTPIS == "05",(cAliasSFT)->FT_VALCF3,(cAliasSFT)->FT_VALCOF)
		Else
			nPosDevol := aScan (aDevMsmPer, {|aX| aX[1]==(cAliasSFT)->FT_NFISCAL .AND. aX[2]==(cAliasSFT)->FT_EMISSAO .AND. aX[3]==(cAliasSFT)->FT_SERIE .AND. aX[4]==(cAliasSFT)->FT_ITEM  .AND. aX[5]==(cAliasSFT)->FT_CLIEFOR  .AND. aX[6]==(cAliasSFT)->FT_LOJA })
			If nPosDevol > 0
				nBcCof		:= (cAliasSFT)->FT_BASECOF - aDevMsmPer[nPosDevol][9]
				nValCof		:= (cAliasSFT)->FT_VALCOF - aDevMsmPer[nPosDevol][10]
			Endif
		EndIF
		IF lEstorno
			nBcCof		:= 0
			nValCof		:= 0
		EndIF
		IF lST2030
			cCstCof		:= aPar[2]
			nTotalRec	:= aPar[3]


			If cCstCof == "05"
				nBcCof		:= (cAliasSFT)->FT_BASECF3
				nValCof		:= (cAliasSFT)->FT_VALCF3
			Else
				nBcCof		:= (cAliasSFT)->FT_BASECOF
				nValCof		:= (cAliasSFT)->FT_VALCOF
			EndIF

		EndIF
	ElseIF Len(aF100) > 0 // Se nao tiver nota, so os t­tulos lanados manualmente no financeiro, neste caso no utilizo os valores da SFT, e sim os valores da funo que o financeiro disponibilizou.
		cCstCof		:= aF100[11]
		nAliqCOf	:= aF100[13]
		nBcCof		:= aF100[12]
		nTotalRec	:= aF100[6]
		nValCof		:= aF100[14]
	ElseIF !Empty(cAliasCF8)
		cCstCof		:= (cAliasCF8)->CF8_CSTCOF
		nAliqCOf	:= (cAliasCF8)->CF8_ALQCOF
		nBcCof		:= (cAliasCF8)->CF8_BASCOF
		nTotalRec	:= (cAliasCF8)->CF8_VLOPER
		nValCof     := (cAliasCF8)->CF8_VALCOF
	ElseIf Len(aD350)>0
		cCstCof		:= aD350[17]
		nAliqCOf	:= aD350[19]
		nBcCof		:= aD350[18]
		nTotalRec	:= aD350[10]
		nValCof		:= aD350[22]
	ElseIf Len(aAtvImob) > 0
		cCstCof		:= aAtvImob[16]
		nAliqCOf	:= aAtvImob[18]
		nBcCof		:= aAtvImob[17]
		nTotalRec	:= aAtvImob[11]
		nValCof     := aAtvImob[19]
	ElseIf Len(aPar) > 0
		cCstCof		:= aPar[1]
		nAliqCOf	:= aPar[2]
		nBcCof		:= aPar[3]
		nTotalRec	:= aPar[4]
		nValCof     := aPar[5]

		If !lD600
			If len(aPar) > 5
				lPauta		:=aPar[6]
			EndIF

			IF lPauta
				nCofPauta	:= nAliqCOf
				nQtdBCof	:= nBcCof
			EndIF
		EndIF
	EndIF
	//SO ALTERO O VALOR POIS A ALIQUOTA JA VEM CORRETA E PASSADA SEM @
	MajAliqVal(nAliqCof,@nValCof,cAliasSFT)
	// Chamada da funcao que retorna o Codigo da Contribuicao.	 |

	cCondCont := SPDCodCont("COF", lSemNota, cCstCof,nAliqCof,lcumulativ,aAtvImob,cRegime,,aParSX6[5])

	If !lSemNota
		If (cAliasSFT)->FT_PAUTCOF > 0
			If lPtCalcul
	        	nCofPauta	:=  nBcPt
	        	nQtdBCof    :=  nVlPt
				lPauta:=.T.
			ElseIf (cAliasSFT)->FT_PAUTCOF > 0 .OR. (cAliasSB1)->B1_VLR_COF > 0
				aBaseAlqUn:=VlrPauta(lCmpNRecFT, lCmpNRecB1, "COF",cAliasSFT,cAliasSB1,lCmpNRecF4,lPautaCOF)
				nCofPauta := Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][1] , Iif((cAliasSFT)->FT_PAUTCOF > 0,(cAliasSFT)->FT_PAUTCOF,(cAliasSB1)->B1_VLR_COF))
				nQtdBCof  := Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][2] , (cAliasSFT)->FT_QUANT)
				lPauta:=.T.
			EndIF
		EndIF
	EndIF

	If !Empty(cCondCont)
		If lPauta
			nPos610 := aScan (aRegM610, {|aX| aX[2]==cCondCont .AND.  cvaltochar(aX[7])==cvaltochar(nCofPauta) })
		Else
			nPos610 := aScan (aRegM610, {|aX| aX[2]==cCondCont .AND.  cvaltochar(aX[5])==cvaltochar(nAliqCof) })
		EndIF

		If nPos610 == 0
			aAdd(aRegM610, {})
			nPos := Len(aRegM610)
			///
			aAdd (aRegM610[nPos], "M610")			   		//01 - REG
			aAdd (aRegM610[nPos], cCondCont)				//02 - COD_CONT
			aAdd (aRegM610[nPos], nTotalRec)				//03 - VL_REC_BRT
			If lPauta
				aAdd (aRegM610[nPos], 0)									//04 - VL_BC_CONT
				aAdd (aRegM610[nPos], "")									//05 - ALIQ_COFINS
				aAdd (aRegM610[nPos], nQtdBCof)								//06 - QUANT_BC_COFINS
				aAdd (aRegM610[nPos], nCofPauta)								//07 - ALIQ_COFINS_QUANT
				nContApur:=nValCof
			Else
			    aAdd (aRegM610[nPos], nBcCof)				//04 - VL_BC_CONT
				aAdd (aRegM610[nPos], nAliqCof)				//05 - ALIQ_COFINS
				aAdd (aRegM610[nPos], "")									//06 - QUANT_BC_COFINS
				aAdd (aRegM610[nPos], "")									//07 - ALIQ_COFINS_QUANT
				nContApur:=nValCof
			EndIF

			aAdd (aRegM610[nPos], nContApur)				//08 - VL_CONT_APUR
			aAdd (aRegM610[nPos], nAjustAcr)				//09 - VL_AJUS_ACRES

			IF cCondCont $ SpdXRetCod(1,{"NC"}) .AND. nDedACofNC > 0 //Contribuio No Cumlativa

				For nCont	:= 1 to Len(aDedACofNC)
					IF aDedACofNC[nCont][2] > 0
						IF aDedACofNC[nCont][2] <= ( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt)
							RegM620(@aRegM620,.F.,nPos,aDedACofNC[nCont][2],"05",,strzero(day(stod(aDedACofNC[nCont][1])),2)+strzero(month(stod(aDedACofNC[nCont][1])),2)+strzero(year(stod(aDedACofNC[nCont][1])),4),"Saldo de Deduo de Cofins referªnte ao per­odo anterior, proveniente do registro F700","F700")
							nAjustRed += aDedACofNC[nCont][2]
							aDedACofNC[nCont][2]	:= 0
						Else
							RegM620(@aRegM620,.F.,nPos,( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt),"05",,strzero(day(stod(aDedACofNC[nCont][1])),2)+strzero(month(stod(aDedACofNC[nCont][1])),2)+strzero(year(stod(aDedACofNC[nCont][1])),4),"Saldo de Deduo de Cofins referªnte ao per­odo anterior, proveniente do registro F700","F700")
							aDedACofNC[nCont][2]	:= aDedACofNC[nCont][2] - ( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt)
							nAjustRed += ( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt)
							Exit
						EndIF
					EndIF
				Next nCont
			ElseIF cCondCont $ SpdXRetCod(1,{"C"}) .AND. nDedACofC > 0	//Contribuio Cumulativa

				For nCont	:= 1 to Len(aDedACofC)
					IF aDedACofC[nCont][2] > 0
						IF aDedACofC[nCont][2] <= ( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt)
							RegM620(@aRegM620,.F.,nPos,aDedACofC[nCont][2],"05",,strzero(day(stod(aDedACofC[nCont][1])),2)+strzero(month(stod(aDedACofC[nCont][1])),2)+strzero(year(stod(aDedACofC[nCont][1])),4),"Saldo de Deduo de Cofins referªnte ao per­odo anterior, proveniente do registro F700","F700")
							nAjustRed += aDedACofC[nCont][2]
							aDedACofC[nCont][2]	:= 0
						Else
							RegM620(@aRegM620,.F.,nPos,( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt),"05",,strzero(day(stod(aDedACofC[nCont][1])),2)+strzero(month(stod(aDedACofC[nCont][1])),2)+strzero(year(stod(aDedACofC[nCont][1])),4),"Saldo de Deduo de Cofins referªnte ao per­odo anterior, proveniente do registro F700","F700")
							aDedACofC[nCont][2]	:= aDedACofC[nCont][2] - ( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt)
							nAjustRed += ( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt)
							Exit
						EndIF
					EndIF
				Next nCont
			EndiF

			aAdd (aRegM610[nPos], nAjustRed)				//10 - VL_AJUS_REDUC
			aAdd (aRegM610[nPos], nDifer)				//11 - VL_CONT_DIFER
			aAdd (aRegM610[nPos], nDiferAnt)				//12 - VL_CONT_DIFER_ANT
			aAdd (aRegM610[nPos	], nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt  )				//13 - VL_CONT_PER
		Else

			aRegM610[nPos610][3]+= nTotalRec				 			//03 - VL_ITEM
			IF lPauta
				nContApur:=nValCof
				aRegM610[nPos610][6]+= nQtdBCof				 						//06 - QUANT_BC_PIS
			Else
				nContApur:=nValCof
				aRegM610[nPos610][4]+= nBcCof				 		//04 - VL_BC_CONT
			EndIF

			aRegM610[nPos610][8]+= nContApur				 			//08 - VL_CONT_APUR
			aRegM610[nPos610][9]+= nAjustAcr				 			//09 - VL_AJUS_ACRES

			IF cCondCont $ SpdXRetCod(1,{"NC"}) .AND. nDedACofNC > 0 //Contribuio No Cumlativa

				For nCont	:= 1 to Len(aDedACofNC)
					IF aDedACofNC[nCont][2] > 0
						IF aDedACofNC[nCont][2] <= ( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt)
							RegM620(@aRegM620,.F.,nPos610,aDedACofNC[nCont][2],"05",,strzero(day(stod(aDedACofNC[nCont][1])),2)+strzero(month(stod(aDedACofNC[nCont][1])),2)+strzero(year(stod(aDedACofNC[nCont][1])),4),"Saldo de Deduo de Cofins referªnte ao per­odo anterior, proveniente do registro F700","F700")
							nAjustRed += aDedACofNC[nCont][2]
							aDedACofNC[nCont][2]	:= 0
						Else
							RegM620(@aRegM620,.F.,nPos610,( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt),"05",,strzero(day(stod(aDedACofNC[nCont][1])),2)+strzero(month(stod(aDedACofNC[nCont][1])),2)+strzero(year(stod(aDedACofNC[nCont][1])),4),"Saldo de Deduo de Cofins referªnte ao per­odo anterior, proveniente do registro F700","F700")
							aDedACofNC[nCont][2]	:= aDedACofNC[nCont][2] - ( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt)
							nAjustRed += ( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt)
							Exit
						EndIF
					EndIF
				Next nCont
			ElseIF cCondCont $ SpdXRetCod(1,{"C"}) .AND. nDedACofC > 0	//Contribuio Cumulativa

				For nCont	:= 1 to Len(aDedACofC)
					IF aDedACofC[nCont][2] > 0
						IF aDedACofC[nCont][2] <= ( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt)
							RegM620(@aRegM620,.F.,nPos610,aDedACofC[nCont][2],"05",,strzero(day(stod(aDedACofC[nCont][1])),2)+strzero(month(stod(aDedACofC[nCont][1])),2)+strzero(year(stod(aDedACofC[nCont][1])),4),"Saldo de Deduo de Cofins referªnte ao per­odo anterior, proveniente do registro F700","F700")
							nAjustRed += aDedACofC[nCont][2]
							aDedACofC[nCont][2]	:= 0
						Else
							RegM620(@aRegM620,.F.,nPos610,( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt),"05",,strzero(day(stod(aDedACofC[nCont][1])),2)+strzero(month(stod(aDedACofC[nCont][1])),2)+strzero(year(stod(aDedACofC[nCont][1])),4),"Saldo de Deduo de Cofins referªnte ao per­odo anterior, proveniente do registro F700","F700")
							aDedACofC[nCont][2]	:= aDedACofC[nCont][2] - ( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt)
							nAjustRed += ( nContApur + nAjustAcr - nAjustRed - nDifer + nDiferAnt)
							Exit
						EndIF
					EndIF
				Next nCont
			EndiF

			aRegM610[nPos610][10]+= nAjustRed				 			//10 - VL_AJUS_REDUC
			aRegM610[nPos610][11]+= nDifer				 			//11 - VL_CONT_DIFER
			aRegM610[nPos610][12]+= nDiferAnt				 			//12 - VL_CONT_DIFER_ANT
			aRegM610[nPos610][13]+= nContApur +nAjustAcr - nAjustRed - nDifer + nDiferAnt			//13 - VL_CONT_PER
		EndIF
	EndIF
EndIF
Return


/*±±ºPrograma  RegM600   ºAutor  Erick G. Dias       º Data   18/02/11º±±
±±ºDesc.      Processamento do registro M600                            º±±*/
Static Function RegM600(cAlias,aRegM600,aRegM610,aReg1700,aRegM620,cRegime,aRegM630,aF600Tmp,aReg1700, cPer, cPerArq,aRegM611,cIndNatJur,cIndTipCoo,nCrPrAlCOF,lProcAnt,aRegM605)

Local nCont			:=0
Local nCampo2 		:=0
Local nCampo3		:=0
Local nCampo4		:=0
Local nCampo5		:=0
Local nCampo6		:=0
Local nCampo7		:=0
Local nCampo8		:=0
Local nCampo9		:=0
Local nCampo10		:=0
Local nCampo11		:=0
Local nCampo12		:=0
Local nCampo13		:=0

Local nCCofRet 		:= 0
Local nVlrContr 	:=0
Local nVlRetUsad	:=0
Local nUsarRet 		:=0
Local a1700Aux 		:={}
Local dUltDia 		:= LastDay (DDATAATE) + 1
Local cPerAtu 		:= cvaltochar(strzero(month(dUltDia ),2)) + cvaltochar(year(dUltDia ))
Local lSldAntr       := .F.

DEFAULT cIndTipCoo := ""
IF lGrBlocoM
    RetAntCOF(cPerArq,a1700Aux,lProcAnt)

    For nCont := 1 to len(aRegM610)

        IF aRegM610[nCont][2] $ SpdXRetCod(1,{"NC"})
            nCampo2 +=  aRegM610[nCont][13]
        ElseIf aRegM610[nCont][2] $ SpdXRetCod(1,{"C"})
            nCampo9 +=  aRegM610[nCont][13]
        EndIF

    Next nCont

    nCampo3:= aRegM600[1][3]
    nCampo4 := aRegM600[1][4]
    nCampo5 := Round(nCampo2 - nCampo3 - nCampo4,2)
    nVlrContr := nCampo5
    nCCofRet :=0

    If cRegime <> "2" // Se for exclusivamente cumulativo ser¡ gerado com zero
            For nCont := 1 to Len(a1700Aux)
                 If a1700Aux[nCont][5] =="0"
                    nCcofRet :=a1700Aux[nCont][4]
                    
                    If nCcofRet <= nVlrContr
                        If  nVlRetUsad <= nVlrContr
                            nCampo6 += nCcofRet
                            nUsarRet := nCcofRet
                            nVlRetUsad += nUsarRet
                            IIf(lProcAnt, Reg1700(@aReg1700,nUsarRet, cPer,a1700Aux[nCont][1],a1700Aux[nCont][3],a1700Aux[nCont][2],a1700Aux[nCont][5],a1700Aux[nCont][4],nUsarRet,lProcAnt),;
                                          Reg1700(@aReg1700,a1700Aux[nCont][4], cPer,a1700Aux[nCont][1], a1700Aux[nCont][4],a1700Aux[nCont][2],a1700Aux[nCont][5],,,lProcAnt))
                        EndIf
                    Else
                        If nVlRetUsad < nVlrContr
                            nCampo6 += nVlrContr - nVlRetUsad
                            nUsarRet := nVlrContr - nVlRetUsad
                            nVlRetUsad += nUsarRet
                            IIf(lProcAnt, Reg1700(@aReg1700,nUsarRet, cPer,a1700Aux[nCont][1],a1700Aux[nCont][3],a1700Aux[nCont][2],a1700Aux[nCont][5],a1700Aux[nCont][4],nUsarRet,lProcAnt),;
                                Reg1700(@aReg1700,nUsarRet, cPer,a1700Aux[nCont][1],a1700Aux[nCont][4],a1700Aux[nCont][2],a1700Aux[nCont][5],,,lProcAnt))   //valor fracionado
                        Else
                            IIf(lProcAnt, Reg1700(@aReg1700,0       , cPer,a1700Aux[nCont][1],a1700Aux[nCont][3],a1700Aux[nCont][2],a1700Aux[nCont][5],a1700Aux[nCont][4],0,lProcAnt),;
                                Reg1700(@aReg1700,0, cPer,a1700Aux[nCont][1],a1700Aux[nCont][4],a1700Aux[nCont][2],a1700Aux[nCont][5],,,lProcAnt) )
                        EndIF
                    EndIf
                EndIF
            Next nCont


            For nCont := 1 to Len(aF600Tmp)
                If nCont > 1
	                lProcAnt := .F.
                Endif
                If aF600Tmp[nCont][7] == "0" // Cumulativo
                    nCcofRet += aF600Tmp[nCont][10] //cof No cumulativo cumulativo
                    If nCcofRet <= nVlrContr
                        nCampo6 += aF600Tmp[nCont][10]
                        nUsarRet := aF600Tmp[nCont][10]
                        nVlRetUsad += nUsarRet
                        IIf(lProcAnt, Reg1700(@aReg1700,nUsarRet, cPer,aF600Tmp[nCont][2], aF600Tmp[nCont][10],aF600Tmp[nCont][3], aF600Tmp[nCont][7],,nVlRetUsad,lProcAnt),;
                                      Reg1700(@aReg1700,aF600Tmp[nCont][10], cPer,aF600Tmp[nCont][2], aF600Tmp[nCont][10],aF600Tmp[nCont][3], aF600Tmp[nCont][7],,,lProcAnt))
                    Else
                        If nVlRetUsad < nVlrContr
                            nCampo6 += nVlrContr - nVlRetUsad
                            nUsarRet := nVlrContr - nVlRetUsad
                            nVlRetUsad += nUsarRet
                            IIf(lProcAnt, Reg1700(@aReg1700,nUsarRet, cPer,aF600Tmp[nCont][2],aF600Tmp[nCont][10],aF600Tmp[nCont][3], aF600Tmp[nCont][7],,nVlRetUsad,lProcAnt),;
                                          Reg1700(@aReg1700,nUsarRet, cPer,aF600Tmp[nCont][2],aF600Tmp[nCont][10],aF600Tmp[nCont][3], aF600Tmp[nCont][7],,,lProcAnt))
                        Else
                            IIf(lProcAnt, Reg1700(@aReg1700,0, cPer,aF600Tmp[nCont][2],aF600Tmp[nCont][10],aF600Tmp[nCont][3], aF600Tmp[nCont][7],,0,lProcAnt),;
                                          Reg1700(@aReg1700,0, cPer,aF600Tmp[nCont][2],aF600Tmp[nCont][10],aF600Tmp[nCont][3], aF600Tmp[nCont][7],,,lProcAnt))
                        EndIF
                    EndIf
                EndIF
            Next nCont
        EndIf

        nCampo8 := nCampo5 - nCampo6

        IF nCampo8 > nCrPrAlcof     //Tratamento para cr©dito presumido de ¡lcool, conforma nota t©cnica 003/2013
            nCampo7 += nCrPrAlcof
            nCampo8 := nCampo8 - nCrPrAlcof
        Elseif cRegime <> "2" .AND. nCrPrAlcof > 0
        //Caso exista valor de cr©dito superior ao valor do d©bito do per­odo, ser¡ transportado para prximo per­odo atrav©s do registro 1100
            CredFutcof(cPer,"107", nCrPrAlcof,nCampo8,(nCrPrAlcof - nCampo8) ,0,cPer)
            nCampo7 :=  nCampo8
            nCampo8 := 0
        EndIF

    //Tratamento para deduµes diversas do registro F700 - valores no cumulativos
        IF nCampo8 > nDedcofNC
            nCampo7 += nDedcofNC
            nCampo8 := nCampo8 - nDedcofNC
        Elseif cRegime <> "2" .AND. nDedcofNC > 0
            SaldoDed(dDataAte, cPerAtu, "0", 0, nDedcofNC - nCampo8, "D") // Guarda o saldo de deduµes para prximos per­odos.
            nCampo7 +=  nCampo8
            nCampo8 := 0
        EndIF

        nVlrContr :=  nCampo9 //Fim do tratamento de valores No Cumulativos e In­cio do tratamento de valores Cumulativos
        nCcofRet  :=0
        nVlRetUsad  := 0
        If cRegime <> "1" // Se for exclusivamente no cumulativo ser¡ gerado com zero

            For nCont := 1 to Len(a1700Aux)
                lSldAntr := .F.
                If a1700Aux[nCont][5] =="1"
                    nCcofRet :=a1700Aux[nCont][4]
                    If nCcofRet > 0
                       lSldAntr := .T.
                    EndIf
                    If nCcofRet <= nVlrContr
                        If  nVlRetUsad <= nVlrContr
                        	nVlrContr := nVlrContr - nCcofRet
                            nCampo10 += nCcofRet
                            nUsarRet := nCcofRet
                            nVlRetUsad += nUsarRet
                            IIf(lProcAnt, Reg1700(@aReg1700,nUsarRet, cPer,a1700Aux[nCont][1],a1700Aux[nCont][3],a1700Aux[nCont][2],a1700Aux[nCont][5],a1700Aux[nCont][4],nUsarRet,lProcAnt),;
                                Reg1700(@aReg1700,a1700Aux[nCont][4], cPer,a1700Aux[nCont][1], a1700Aux[nCont][4],a1700Aux[nCont][2],a1700Aux[nCont][5],,,lProcAnt))
                        EndIf
                    Else
                        If nVlRetUsad < nVlrContr
                            nCampo10 += nVlrContr - nVlRetUsad
                            nUsarRet := nVlrContr - nVlRetUsad
                            nVlRetUsad += nUsarRet
                            IIf(lProcAnt, Reg1700(@aReg1700,nUsarRet, cPer,a1700Aux[nCont][1],a1700Aux[nCont][3],a1700Aux[nCont][2],a1700Aux[nCont][5],a1700Aux[nCont][4],nUsarRet,lProcAnt),;
                                Reg1700(@aReg1700,nUsarRet, cPer,a1700Aux[nCont][1],a1700Aux[nCont][4],a1700Aux[nCont][2],a1700Aux[nCont][5],,,lProcAnt))
                        ElseIf nVlRetUsad + nCcofRet > nVlrContr
                           	nCampo10  := nCampo9
                           	IIf(lProcAnt,	Reg1700(@aReg1700,nUsarRet, cPer,a1700Aux[nCont][1],a1700Aux[nCont][3],a1700Aux[nCont][2],a1700Aux[nCont][5],a1700Aux[nCont][4],nUsarRet,lProcAnt),;
                             				Reg1700(@aReg1700,nUsarRet, cPer,a1700Aux[nCont][1],a1700Aux[nCont][4],a1700Aux[nCont][2],a1700Aux[nCont][5],,,lProcAnt))
                           	nUsarRet  := nVlrContr
                           	nVlrContr := 0
                           	a1700Aux[nCont][2] := Soma1(substr(a1700Aux[nCont][2],1,2)) + substr(a1700Aux[nCont][2],3,4)
                           	IIf(lProcAnt,	Reg1700(@aReg1700,nUsarRet, cPer,a1700Aux[nCont][1],a1700Aux[nCont][3],a1700Aux[nCont][2],a1700Aux[nCont][5],a1700Aux[nCont][4],nUsarRet,lProcAnt),;
                             				Reg1700(@aReg1700,nUsarRet, cPer,a1700Aux[nCont][1],a1700Aux[nCont][4],a1700Aux[nCont][2],a1700Aux[nCont][5],,,lProcAnt))
                        Else
                            IIf(lProcAnt, Reg1700(@aReg1700,0       , cPer,a1700Aux[nCont][1],a1700Aux[nCont][3],a1700Aux[nCont][2],a1700Aux[nCont][5],a1700Aux[nCont][4],0,lProcAnt),;
                                Reg1700(@aReg1700,0, cPer,a1700Aux[nCont][1],a1700Aux[nCont][4],a1700Aux[nCont][2],a1700Aux[nCont][5],,,lProcAnt))
                        EndIF
                    EndIf
                EndIF

            Next nCont

            For nCont := 1 to Len(aF600Tmp)
                If nCont>1
                	lProcAnt:=.F.
                Endif

                If aF600Tmp[nCont][7] == "1" // Cumulativo
                    nCcofRet += aF600Tmp[nCont][10] //cof No cumulativo cumulativo
                    If nCcofRet <= nVlrContr
                        nCampo10 += aF600Tmp[nCont][10]
                        nUsarRet := aF600Tmp[nCont][10]
                        nVlRetUsad += nUsarRet
                        IIf(lProcAnt, Reg1700(@aReg1700,nUsarRet, cPer,aF600Tmp[nCont][2], aF600Tmp[nCont][10],aF600Tmp[nCont][3], aF600Tmp[nCont][7],,nVlRetUsad,lProcAnt),;
                            Reg1700(@aReg1700,aF600Tmp[nCont][10], cPer,aF600Tmp[nCont][2], aF600Tmp[nCont][10],aF600Tmp[nCont][3], aF600Tmp[nCont][7],,,lProcAnt))
                    Else
                        If nVlRetUsad < nVlrContr 
                           nCampo10 += nVlrContr - nVlRetUsad
                           nUsarRet := nVlrContr - nVlRetUsad
                           nVlRetUsad += nUsarRet
                                
                           IIf(lProcAnt, Reg1700(@aReg1700,nUsarRet, cPer,aF600Tmp[nCont][2],aF600Tmp[nCont][10],aF600Tmp[nCont][3], aF600Tmp[nCont][7],,nVlRetUsad,lProcAnt),;
                                     Reg1700(@aReg1700,nUsarRet, cPer,aF600Tmp[nCont][2],aF600Tmp[nCont][10],aF600Tmp[nCont][3], aF600Tmp[nCont][7],,,lProcAnt) )
                                                      	                             
	                     ElseIf nVlrContr <  nCcofRet .And. lSldAntr
	                            nCampo10  := nCcofRet
	                            nVlRetUsad := aF600Tmp[nCont][10]
	                             
	                            IIf(lProcAnt, Reg1700(@aReg1700,nVlRetUsad, cPer,aF600Tmp[nCont][2],aF600Tmp[nCont][10],aF600Tmp[nCont][3], aF600Tmp[nCont][7],,nVlRetUsad,lProcAnt),;
                             		      Reg1700(@aReg1700,nUsarRet, cPer,aF600Tmp[nCont][2],aF600Tmp[nCont][10],aF600Tmp[nCont][3], aF600Tmp[nCont][7],,,lProcAnt) )
	                                      
                        Else
                            IIf(lProcAnt, Reg1700(@aReg1700,0, cPer,aF600Tmp[nCont][2],aF600Tmp[nCont][10],aF600Tmp[nCont][3], aF600Tmp[nCont][7],,0,lProcAnt),;
                                Reg1700(@aReg1700,0, cPer,aF600Tmp[nCont][2],aF600Tmp[nCont][10],aF600Tmp[nCont][3], aF600Tmp[nCont][7],,,lProcAnt) )
                        EndIF
                    EndIf
                EndIF
            Next nCont

        EndIf
    nCampo12 := nCampo9 - nCampo10


    //Tratamento para deduµes diversas do registro F700 - valores cumulativos
    IF nCampo12 > nDedCOFC
        nCampo11    := nDedCOFC
        nCampo12    := nCampo12 - nCampo11
    Elseif cRegime <> "1" .AND. nDedCOFC > 0
        SaldoDed(dDataAte, cPerAtu, "1", 0,nDedCOFC - nCampo12,"D") // Guarda o saldo de deduµes para prximos per­odos.
        nCampo11    :=  nCampo12
        nCampo12    := 0
    EndIF

    nCampo13 := nCampo8 + nCampo12


    aRegM600[1][2]:= nCampo2                //02 - VL_TOT_CONT_NC_PER
    aRegM600[1][3]:= nCampo3                //03 - VL_TOT_CRED_DESC

    aRegM600[1][5]:= nCampo5                //05 - VL_TOT_CONT_NC_DEV
    aRegM600[1][6]:= nCampo6                //06 - VL_RET_NC
    aRegM600[1][7]:= nCampo7                //07 - V_OUT_DED_NC
    aRegM600[1][8]:= nCampo8                //08 - VL_CONT_NC_REC
    aRegM600[1][9]:= nCampo9                //09 - VL_TOT_CONT_CUM_PER
    aRegM600[1][10]:= nCampo10              //10 - VL_RET_CUM
    aRegM600[1][11]:= nCampo11              //11 - VL_OUT_DED_CUM
    aRegM600[1][12]:= nCampo12              //12 - VL_CONT_CUM_REC
    aRegM600[1][13]:= nCampo13              //13 - VL_TOT_CONT_REC

    //Tratamento para gerar o Registro M605
    If dDataDe >= cToD("01/01/2014") .And. (nCampo8 >0 .Or. nCampo12 > 0)
      	RegM605(@aRegM605,nCampo8,nCampo12,aRegM600)
    EndIf


    GrRegDep (cAlias, aRegM600, aRegM605,,,,,nTamTRBIt)
    GrRegDep (cAlias, aRegM610, aRegM611,,,,,)
    GrRegDep (cAlias, aRegM610, aRegM620,.T.,,,,)
    GrRegDep (cAlias, aRegM610, aRegM630,.T.,,,,)
EndIF

Return


//-------------------------------------------------------------------
/*/{Protheus.doc} RegM605
Processamento do registro M605

@param  aRegM205  - Array com informaµes do registro M605
	    nValNCum  - Valor da Contribuio No Cumulativa a Recolher/Pagar
		nValCumul - Valor da Contribuio Cumulativa a Recolher/Pagar
		aRegM600  - Array com informaµes do registro M600

@author Simone dos Santos de Oliveira
@since 25.04.2014
@version 11.80
/*/
//-------------------------------------------------------------------
Static Function RegM605(aRegM605,nValNCum,nValCumul,aRegM600)

Local nPos		  := 0
Local nX		  := 0
Local aMVCODREC:= RetCodRec()

Default nValNCum  := 0
Default nValCumul := 0

For nX:= 1 to len(aRegM600)
	If nValNCum > 0
		aAdd (aRegM605, {})
		nPos :=	Len (aRegM605)
		aAdd (aRegM605[nPos], nX)	   							//01 - REG DO PAI
		aAdd (aRegM605[nPos], "M605")							//02 - REG
		aAdd (aRegM605[nPos], "08")		   						//03 - NUM_CAMPO
		aAdd (aRegM605[nPos], aMVCODREC[4]) 					//04 - COD_REC
		aAdd (aRegM605[nPos], nValNCum)	  						//05 - VL_DEBITO
	EndIf

	If nValCumul > 0
		aAdd (aRegM605, {})
		nPos :=	Len (aRegM605)
		aAdd (aRegM605[nPos], nX)	   							//01 - REG DO PAI
		aAdd (aRegM605[nPos], "M605")							//02 - REG
		aAdd (aRegM605[nPos], "12")		   						//03 - NUM_CAMPO
		aAdd (aRegM605[nPos], aMVCODREC[3]) 					//04 - COD_REC
		aAdd (aRegM605[nPos], nValCumul)						//05 - VL_DEBITO
	EndIf
Next nX

Return

/*±±ºPrograma  AcumM105  ºAutor  Erick G. Dias       º Data   24/02/11 º±±
±±ºDesc.      Processamento do registro M105                             º±±*/
Static Function AcumM105(aRegM105,cAliasSFT,cRegime,lCumulativ,cIndApro,aReg0111,lSemNota, aF100,cAliasF130,cAliasF120,cAliasSB1,cAliasCF8,aDevCpMsmP,nPosDevCmp,cAliasCF9, aAtvImob)
Local nPos			:= 0
local nPosM105		:= 0
local lImport		:= .F.
Local lPauta		:= .F.
Local lCmpPauta		:=	.F.
Local lAgrIndust		:= .F.
Local nPisPauta		:= 0
Local nQtdBpIS		:= 0
Local cCstPis		:= ""
Local nAliqPis		:= 0
Local nBcPis		:= 0
Local nTotalRec		:= 0
Local cCodBCC		:= ""
Local cDescCred		:= ""
Local lApropDir		:= aParSX6[14]
Local aBaseAlqUn	:= {}
Local cCodNat		:= ""
Local nCont			:= 0
Local cCodCred		:= ""
Local cIndCont		:= ""
Local cALSF23       := ""

DEFAULT lSemNota	:= .F.
DEFAULT aF100		:= {}
DEFAULT cAliasSB1	:= "SB1"
DEFAULT cAliasCF8	:= ""
DEFAULT cAliasCF9	:= ""
DEFAULT cAliasF120		:= ""
DEFAULT cAliasF130		:= ""
DEFAULT aDevCpMsmP		:= {}
DEFAULT aF100           := {}
DEFAULT aAtvImob        := {}
DEFAULT nPosDevCmp		:= 0

IF lGrBlocoM

	IF !empty(cAliasF130) .Or. !empty(cAliasF120) // Processa valores do mdulo do Ativo
		cALSF23 := If(!empty(cAliasF130),cAliasF130,cAliasF120)
	  	If SN1->(dbSeek(xFilial('SN1')+(cALSF23)->BEM+(cALSF23)->ITEM))
       		If SD1->(dbSeek(xFilial('SD1')+(cALSF23)->NOTAFISCAL+(cALSF23)->SERIE+(cALSF23)->FORNECEDOR+(cALSF23)->LOJA +SN1->N1_PRODUTO+SN1->N1_NFITEM))
   		  		If (SubStr (AllTrim (SD1->D1_CF), 1, 1)=="3")
   		        	If aFieldPos[85] .And. (Empty(SN1->N1_CBCPIS) .Or. SN1->N1_CBCPIS == "1")
   		        		nAliqPis := SD1->D1_ALQPIS
   		        	EndIf
   		        	lImport  := If(!empty(cAliasF130),(cAliasF130)->IND_ORIG_C == "1" ,(cAliasF120)->INDORIGCRD == "1" )
   		  		EndIf
   		  	EndIf
   		EndIf
   	EndIf
	//Se for pela nota irei utilizar os valores que esto na tabela SFT
	IF !lSemNota
		lCmpPauta		:=	aFieldPos[20]
		cCstPis		:= (cAliasSFT)->FT_CSTPIS
		nAliqPis	:= (cAliasSFT)->FT_ALIQPIS
		If Len(aDevCpMsmP) > 0 .AND. nPosDevCmp > 0
			nBcPis		:= (cAliasSFT)->FT_BASEPIS - aDevCpMsmP[nPosDevCmp][7]
		Else
			nBcPis		:= (cAliasSFT)->FT_BASEPIS
		EndIf
		nTotalRec	:= (cAliasSFT)->FT_TOTAL
		cCodBCC		:= (cAliasSFT)->FT_CODBCC
	Elseif len(aF100) > 0 // Se nao tiver nota, so os t­tulos lanados manualmente no financeiro, neste caso no utilizo os valores da SFT, e sim os valores da funo que o financeiro disponibilizou.
		cCstPis		:=aF100[7]
		nAliqPis	:=aF100[9]
		nBcPis		:=aF100[8]
		nTotalRec	:=aF100[6]
		cCodBCC		:=aF100[15]
   	ElseIF !empty(cAliasF130) // Processa valores do mdulo do Ativo
   		If  nAliqPis  == 0
   	   		nAliqPis	:= (cAliasF130)->ALIQ_PIS
   	   	EndIf
		cCstPis		:=cvaltochar((cAliasF130)->CST_PIS)
		nBcPis		:=(cAliasF130)->VL_BC_PIS
		nTotalRec	:=(cAliasF130)->VL_OPER_AQ
		cCodBCC		:=cvaltochar((cAliasF130)->NAT_BC_CRE)
	ElseIF !empty(cAliasF120) // Processa valores do mdulo do Ativo
		If  nAliqPis  == 0
   	   		nAliqPis	:=(cAliasF120)->ALIQPIS
   	   	EndIf
		cCstPis	:=(cAliasF120)->CSTPIS
		nBcPis		:=(cAliasF120)->VLRBCPIS
		nTotalRec	:=(cAliasF120)->VRET
		cCodBCC	:=(cAliasF120)->NATBCCRED
	ElseIF !empty(cAliasCF8) // Processa valores que foram cadastrados manualmente pelo usu¡rio para registro F100
		cCstPis		:=(cAliasCF8)->CF8_CSTPIS
		nAliqPis	:=(cAliasCF8)->CF8_ALQPIS
		nBcPis		:=(cAliasCF8)->CF8_BASPIS
		nTotalRec	:=(cAliasCF8)->CF8_VLOPER
		cCodBCC		:=(cAliasCF8)->CF8_CODBCC
	ElseIF !empty(cAliasCF9) // Processa valores referente ao abertura de estoque
		cCstPis		:=(cAliasCF9)->CF9_CSTPIS
		nAliqPis	:=(cAliasCF9)->CF9_ALQPIS
		nBcPis		:=(cAliasCF9)->CF9_BASMES
		cCodBCC		:=(cAliasCF9)->CF9_CODBCC
	ElseIf Len(aAtvImob) > 0  //Atividade Imobiliaria
		If aAtvImob[2] == "F205"
			cCstPis		:=  aAtvImob[8]
			nAliqPis	:=  aAtvImob[9]
			nBcPis		:=  aAtvImob[7]
			cCodBCC		:=  "15"
		Else
			cCstPis		:=  aAtvImob[7]
			nAliqPis	:=  aAtvImob[8]
			nBcPis		:=  aAtvImob[6]
			cCodBCC		:= "16"
		EndIf
	EndIF

	If Empty(cALSF23) //Para o F120 e o F130 nao he necessario calcular o aliquota do Pis pois ja chega correta.
		MajAliqPis(@nAliqPis,,cAliasSFT)
	EndIf

	If (SX5->(MsSeek (xFilial ("SX5")+"MZ"+ cCodBCC)))
		cDescCred	:=	SX5->X5_DESCRI
	Endif

	If !lSemNota
		lImport := Iif(Substr((cAliasSFT)->FT_CFOP,1,1) == "3",.T.,.F.)
		lAgrIndust := Iif(Substr((cAliasSFT)->FT_TNATREC,1,1) $ "439",.T.,.F.)

		If (cAliasSFT)->FT_VALPIS
			If (lCmpPauta .And. (cAliasSFT)->FT_PAUTPIS > 0) .Or. (cAliasSB1)->B1_VLR_PIS > 0
				aBaseAlqUn	:=	VlrPauta(lCmpNRecFT, lCmpNRecB1, "PIS",cAliasSFT,cAliasSB1,lCmpNRecF4,lCmpPauta)
				nPisPauta 	:=	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][1] , Iif((cAliasSFT)->FT_PAUTPIS > 0,(cAliasSFT)->FT_PAUTPIS,(cAliasSB1)->B1_VLR_PIS))
				nQtdBPis  	:=	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][2] , (cAliasSFT)->FT_QUANT)
				cCodNat	  	:=	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][3] , "")
				lPauta		:=	.T.
			EndIF
		EndIF
	EndIF

	IF cCstPis $ "50/51/52/60/61/62"
		nContLimit :=1
	ElseIf cCstPis $ "53/63/54/64/55/65"  //CST que apontam para 2 receitas diferentes
		nContLimit :=2
	Else //Sobram os CSTs 56 e 66, que apontam para 3 receitas diferentes
		nContLimit :=3
	EndIF

	If nAliqPis == 0.65 .OR. nAliqPis == 1.65
		cIndCont := "1"
	Else
    	cIndCont := "2"
	EndIf

	For nCont := 1 to nContLimit
		cCodCred	:= ""
		//Chamada da funcao que retorna o Codigo de Tipo de Credito - Tabela 4.3.6
		cCodCred	:=	SPEDCodCre(	cCstPis,;		// Codigo da Situacao Tributaria - CST
									cCodBCC,;		// Codigo de Base de Calculo do Credito - CODBCC
									lPauta,;		// Operacao com Unidade de Produto - Pauta
									lImport,;		// Operacao de Importacao
									cCodNat,;		// Codigo da Natureza da Receita
									cIndCont,;		// Tipo de Aliquota (Basica/Diferenciada)
									nQtdBPis,;      // Aliquota Unidade de Produto
									nCont,;
									lAgrIndust)	//Operao Agroindustria

		If (nPosM105 := aScan (aRegM105, {|aX| aX[2]==cCodBCC .AND.  aX[3]==cCstPis .AND. ;
											cValToChar(aX[11]) == cValToChar(Iif(lPauta,nPisPauta,nAliqPis) ) .AND. aX[12]== lImport .AND. ;
											aX[13] == cCodNat .And. aX[14] == lPauta .AND. aX[15]==cCodCred })) == 0

			aAdd(aRegM105, {})
			nPos := Len(aRegM105)
			aAdd (aRegM105[nPos], "M105")			//01 - REG
			aAdd (aRegM105[nPos], cCodBCC)			//02 - NAT_BC_CRED
			aAdd (aRegM105[nPos], cCstPis)			//03 - CST_PIS
			If !lPauta
				aAdd (aRegM105[nPos], nBcPis)			//04 - VL_BC_PIS_TOT
				If cRegime $ "3"
					If !lApropDir //Se no for aprorpiao direta
						aAdd (aRegM105[nPos], Round((nBcPis *  aReg0111[1][5]) / aReg0111[1][6],2))			   	   				//05 - VL_BC_PIS_CUM
					Else
						aAdd (aRegM105[nPos], 0)		 	//05 - VL_BC_PIS_CUM
					EndIF
				Else
					aAdd (aRegM105[nPos], 0)		 	//05 - VL_BC_PIS_CUM
				EndIF
			Else
				aAdd (aRegM105[nPos], 0)		 	//04 - VL_BC_PIS_TOT
				aAdd (aRegM105[nPos], 0)		 	//05 - VL_BC_PIS_CUM
			EndIf
			aAdd (aRegM105[nPos], 0)			   	   						//06 - VL_BC_PIS_NC
			aAdd (aRegM105[nPos], 0)			   	   						//07 - VL_BC_PIS
			aAdd (aRegM105[nPos], Iif(lPauta,nQtdBPis,""))					//08 - QUANT_BC_PIS_TOT
			aAdd (aRegM105[nPos], "")			   	   						//09 - QUANT_BC_PIS
			aAdd (aRegM105[nPos], cDescCred)		   	   					//10 - DESC_CRED

			//As posicoes abaixo foram criadas apenas para validar a geracao do registro M105. Nao sao impressas no arquivo magnetico	
			aAdd (aRegM105[nPos], Iif(lPauta,nPisPauta,nAliqPis))			//11 - Aliquota PIS
			aAdd (aRegM105[nPos], lImport)   								//12 - Importacao
			aAdd (aRegM105[nPos], cCodNat)   								//13 - Cdigo da Natureza da Receita
			aAdd (aRegM105[nPos], lPauta)                                  //14 - Pauta
			aAdd (aRegM105[nPos], cCodCred)                                //15 - Codigo do Cr©dito 4.3.6
			aAdd (aRegM105[nPos], nCont)                                   //16 - Nºmero que ser¡ utilizado no momento da gerao do registro M100 rateio dos cr©ditos pelas receitas
		Else
			If lPauta
				aRegM105[nPosM105][8]+= nQtdBPis							//08 - QUANT_BC_PIS_TOT
			Else
				aRegM105[nPosM105][4]+= nBcPis								//04 - VL_BC_PIS_TOT
				If cRegime $ "3" .AND.	!lApropDir //Se no for aprorpiao direta
					aRegM105[nPosM105][5]:=Round((aRegM105[nPosM105][4] *  aReg0111[1][5]) / aReg0111[1][6],2)
				EndIF
			EndIF
		EndIF
	Next nCont
EndIF

Return

/*±±ºPrograma  RegM105   ºAutor  Erick G. Dias       º Data   24/02/11   º±±
±±ºDesc.      Processamento do registro M105                             º±*/
Static Function RegM105(cAlias,aRegM100,aRegM105,aAuxM105,aRegM200,aReg0111,cIndApro,aReg1100,cPer,nTotContrb,aRegM110,aCredPresu,aAjuCred,aVlCrdImob,aAjCredSCP,aAjustMX10,aCFA,aRegM115)

Local nCont			:=	0
Local nCont2		:=	0
Local nContLimit	:= 0
Local nPos			:=	0
Local nPosM100		:=	0
Local cCodCred		:= 	""
Local nBcPis		:=  0
Local nCredDisp 	:=  0
Local nCredDesc		:=  0
Local nTotCred		:=  0
Local nBaseRat		:= 0
Local nPosPerc		:= 0
Local cCnpj			:= ""
Local lPauta		:= .F.
Local nPosM105		:= 0
Local nTotCredUt	:= 0 //Tera o total de credito, para fazer o controle se os creditos so maiores que a contribuio, para levar os creditos para o prximo mªs.
Local nTotCredPx	:= 0 //Tota de cr©dito para proximo perido
Local nCredAtual	:=	0
Local nCredPar		:= 0
Local nCredDif		:= 0
Local nX 			:= 0
Local cIndCont		:= ""
Local aOrdCodCre	:= {}
Local nContOrd		:= 0
Local bOrd			:= {|x,y|x[15]<y[15]}
Local nPosCFA		:= 0
Local aCF5			:= {}

DEFAULT aAjustMX10	:= {}

//Ordeno primeiro com ordem crescente do cdigo de cr©dito
aAuxM105  := Asort(aAuxM105,,,bOrd)

aOrdCodCre:= MontOrdCre()
//Faz Loop no array aAuxM105, que tem os valores referente			
//a PIS acumulados dos diversos registros dos blocos A, C, D e F.	

IF len(aOrdCodCre) > 0
	SpdSort(@aAuxM105,aOrdCodCre,15)
EndIF

For nCont :=1 to Len(aAuxM105)
	If aAuxM105[nCont][11] == 0.65 .OR. aAuxM105[nCont][11] == 1.65
		cIndCont := "1"
	Else
    	cIndCont := "2"
	EndIf

	nBcPis	:=	0
	lPauta 	:=	.F.

	If aAuxM105[nCont][14]
		nBcPis		:=	aAuxM105[nCont][8]
		nCredDisp	:=	Round((nBcPis * aAuxM105[nCont][11]),2)
		lPauta 		:=	.T.
	Else
		nBcPis		:=	aAuxM105[nCont][4] - aAuxM105[nCont][5]
		nCredDisp	:=	Round((nBcPis * aAuxM105[nCont][11])/100,2)
	EndIF

	//CST que indicam somente um tipo de receita	

	If aAuxM105[nCont][3] $ "50/51/52/60/61/62"

		cCodCred	:=	aAuxM105[nCont][15]

		If cCodCred == "109"
			nCredDisp := aVlCrdImob[1]
		EndIf

		If lPauta
			nPosM100 := aScan (aRegM100, {|aX| aX[2]==cCodCred .AND.  cvaltochar(aX[7])==cvaltochar(aAuxM105[nCont][11]) })
		Else
		 	nPosM100 := aScan (aRegM100, {|aX| aX[2]==cCodCred .AND.  cvaltochar(aX[5])==cvaltochar(aAuxM105[nCont][11]) })
		EndIf

		IF nPosM100 == 0
			aAdd(aRegM100, {})
			nPosM100 := Len(aRegM100)
			aAdd (aRegM100[nPosM100], "M100")			   	   		   			//01 - REG
			aAdd (aRegM100[nPosM100], cCodCred)			   	   		   			//02 - COD_CRED
			aAdd (aRegM100[nPosM100], "0")				   	   		   			//03 - IND_CRED_ORI
			aAdd (aRegM100[nPosM100], Iif(lPauta,0,nBcPis))  					//04 - VL_BC_PIS
			aAdd (aRegM100[nPosM100], Iif(lPauta,"",aAuxM105[nCont][11]))		//05 - ALIQ_PIS
			aAdd (aRegM100[nPosM100], Iif(lPauta,nBcPis,""))			   	   	//06 - QUANT_BC_PIS
			aAdd (aRegM100[nPosM100], Iif(lPauta,aAuxM105[nCont][11],""))		//07 - ALIQ_PIS_QUANT
			aAdd (aRegM100[nPosM100], nCredDisp)								//08 - VL_CRED
			aAdd (aRegM100[nPosM100], 0)			   	   		   				//09 - VL_AJUST_ACRED
			aAdd (aRegM100[nPosM100], 0)			   	   		   				//10 - VL_AJUS_REDUC

			nCredDif	:= 0

			For nPosCFA:= 1 to len (aCFA)
				IF aCFA[nPosCFA][1] == "PIS" .AND. aCFA[nPosCFA][2] == cCodCred .AND. aCFA[nPosCFA][3] == cPer
					nCredDif	+= aCFA[nPosCFA][4]
				EndIF
			Next nPosCFA

			aAdd (aRegM100[nPosM100], nCredDif)			   	   		   				//11 - VL_CRED_DIF
			aAdd (aRegM100[nPosM100], nCredDisp-nCredDif)							//12 - VL_CRED_DISP
			nCredDisp := nCredDisp - nCredDif
			aAdd (aRegM100[nPosM100], "0")			   	   		   					//13 - IND_DESC_CRED
			//Se total de credito ate o momento for menou ou igual ao total de contribuio, entao utiliza o credito 
			If (nTotCredUt + nCredDisp) <= nTotContrb
				//Utiliza o valor total do credito no M200

				nCredDesc := nCredDisp
				nTotCredUt += nCredDisp //Acumulo cr©dito utilizado
			Else
				//O valor do cr©dito no periodo © maior do que o valor da contribuio, no ir¡ utilizar o credito, e ser¡ utilizado no proximo per­odo.
				nCredDesc := nTotContrb - nTotCredUt
				nTotCredUt += nCredDesc //Acumulo cr©dito utilizado
				//Gravar na tabela com valor de nCredDisp
			EndIF

			aAdd (aRegM100[nPosM100], nCredDesc)			   	   		   				//14 - VL_CRED_DESC
			aAdd (aRegM100[nPosM100], Round(aRegM100[nPosM100][12] - aRegM100[nPosM100][14],2))			   	   		   		//15 - SLD_CRED

			aRegM100[nPosM100][15] := SPDFCFSldCred(aRegM100[nPosM100][15])
			IF aRegM100[nPosM100][15] > 0
				aRegM100[nPosM100][13] := "1"
			Else
				aRegM100[nPosM100][13] := "0"
			EndIF

		Else
	   		//acumula
	   		If lPauta
				aRegM100[nPosM100][6]+= nBcPis												//06 - QUANT_BC_PIS
	   		Else
	   			aRegM100[nPosM100][4]+= nBcPis												//04 - VL_BC_PIS
	   		EndIF

	   		If cCodCred <> "109"
	   			If lPauta
	   				nCredDisp:=Round( (nBcPis * aAuxM105[nCont][11]), 2 )
	   			Else
		   			nCredDisp:=Round((nBcPis * aAuxM105[nCont][11])/100,2)
		   		EndIf
	   		Else
	   			nCredDisp := 0
	   		EndIf

	   		nCredDesc := nCredDisp

	   		aRegM100[nPosM100][8]+=nCredDisp											//08 - VL_CRED
	   		aRegM100[nPosM100][12]+= nCredDisp											//12 - VL_CRED_DISP

			//Se total de credito ate o momento for menou ou igual ao total de contribuio, entao utiliza o credito
			If (nTotCredUt + nCredDisp) <= nTotContrb
	   			aRegM100[nPosM100][14]+= nCredDesc											//14 - VL_CRED_DESC
	   			nTotCredUt += nCredDesc //Acumulo cr©dito utilizado
	  		Else
	  	   		//O valor do cr©dito no periodo © maior do que o valor da contribuio, no ir¡ utilizar o credito, e ser¡ utilizado no proximo per­odo.
				nCredDesc := nTotContrb - nTotCredUt
				nTotCredUt += nCredDesc //Acumulo cr©dito utilizado
	  	   		aRegM100[nPosM100][14]+= nCredDesc			//14 - VL_CRED_DESC
	  	   		nTotCredPx += nCredDisp - nCredDesc //Guardo o valor de credito que nao foi utilizado neste periodo
	  	   		//Grava na tabela o credito para proximo periodo
	  		EndIF
	   		aRegM100[nPosM100][15]:= Round(aRegM100[nPosM100][12] - aRegM100[nPosM100][14],2)
			aRegM100[nPosM100][15] := SPDFCFSldCred(aRegM100[nPosM100][15])
			IF aRegM100[nPosM100][15] > 0
				aRegM100[nPosM100][13] := "1"
			Else
				aRegM100[nPosM100][13] := "0"
			EndIF

		EndIf

		nPosM105 := aScan (aRegM105, {|aX| aX[1]==nPosM100 .AND.  aX[3]== aAuxM105[nCont][2] .AND.  aX[4]== aAuxM105[nCont][3]})
		IF nPosM105 == 0
			//Adiciona M105
			aAdd(aRegM105, {})
			nPos := Len(aRegM105)
			aAdd (aRegM105[nPos], nPosM100)			   	   		   				//Relacao com M100
			aAdd (aRegM105[nPos], "M105")			   	   		   				//01 - REG
			aAdd (aRegM105[nPos], aAuxM105[nCont][2])			   	   			//02 - NAT_BC_CRED
			aAdd (aRegM105[nPos], aAuxM105[nCont][3])			   	   			//03 - CST_PIS
			aAdd (aRegM105[nPos], aAuxM105[nCont][4])			   	   			//04 - VL_BC_PIS_TOT
			aAdd (aRegM105[nPos], aAuxM105[nCont][5])			   	   			//05 - VL_BC_PIS_CUM
			aAdd (aRegM105[nPos], Iif(lPauta,0,nBcPis))						//06 - VL_BC_PIS_NC
			aAdd (aRegM105[nPos], Iif(lPauta,0,nBcPis))						//07 - VL_BC_PIS
			aAdd (aRegM105[nPos], aAuxM105[nCont][8])			   	   			//08 - QUANT_BC_PIS_TOT
			aAdd (aRegM105[nPos], aAuxM105[nCont][8])			   	   			//09 - QUANT_BC_PIS
			aAdd (aRegM105[nPos], aAuxM105[nCont][10])			   	   			//10 - DESC_CRED
		Else
			aRegM105[nPosM105][5]+=aAuxM105[nCont][4]							//04 - VL_BC_PIS_TOT
			aRegM105[nPosM105][6]+=aAuxM105[nCont][5]    						//05 - VL_BC_PIS_CUM
			aRegM105[nPosM105][7]+=Iif(lPauta,0,nBcPis)   						//06 - VL_BC_PIS_NC
			aRegM105[nPosM105][8]+= Iif(lPauta,0,nBcPis) 						//07 - VL_BC_PIS
			aRegM105[nPosM105][9]+= aAuxM105[nCont][8]    						//08 - QUANT_BC_PIS_TOT
			aRegM105[nPosM105][10]+= aAuxM105[nCont][8]   						//09 - QUANT_BC_PIS
		EndIF
	Else

		//Metodo de Apropriacao proporciaonal a receita bruta...utilizara o registro 0111 para calcular o valor proporcional a cada receita

		//Calcula o valor da base proporcional para a receita, considerando os valores do registro 0111
		nBaseRat :=	Round(BasePisCof(aAuxM105[nCont][16],aReg0111,aAuxM105[nCont][3],nBcPis),2)
		If lPauta
			nCredDisp:=Round((nBaseRat * aAuxM105[nCont][11]),2)
		Else
			nCredDisp:=Round((nBaseRat * aAuxM105[nCont][11])/100,2)
		EndIF

	    cCodCred	:=	aAuxM105[nCont][15]

	    If lPauta
			nPosM100 := aScan (aRegM100, {|aX| aX[2]==cCodCred .AND.  cvaltoChar(aX[7])==CValToChar(aAuxM105[nCont][11]) })
	    Else
	    	nPosM100 := aScan (aRegM100, {|aX| aX[2]==cCodCred .AND.  cValToChar(aX[5])==cValToChar(aAuxM105[nCont][11]) })
	    EndIF
	    IF nPosM100 == 0
			aAdd(aRegM100, {})
			nPosM100 := Len(aRegM100)
			aAdd (aRegM100[nPosM100], "M100")			   	   		   			//01 - REG
			aAdd (aRegM100[nPosM100],cCodCred)			   	   		   			//02 - COD_CRED
			aAdd (aRegM100[nPosM100], "0")				   	   		   			//03 - IND_CRED_ORI
			aAdd (aRegM100[nPosM100], Iif(lPauta,0,nBaseRat))  					//04 - VL_BC_PIS
			aAdd (aRegM100[nPosM100], Iif(lPauta,"",aAuxM105[nCont][11]))		//05 - ALIQ_PIS
			aAdd (aRegM100[nPosM100], Iif(lPauta,nBaseRat,0))			   	   	//06 - QUANT_BC_PIS
			aAdd (aRegM100[nPosM100], Iif(lPauta,aAuxM105[nCont][11],""))		//07 - ALIQ_PIS_QUANT
			aAdd (aRegM100[nPosM100], nCredDisp)								//08 - VL_CRED
			aAdd (aRegM100[nPosM100], 0)			   	   		   				//09 - VL_AJUST_ACRED
			aAdd (aRegM100[nPosM100], 0)			   	   		   				//10 - VL_AJUS_REDUC

			nCredDif	:= 0
			For nPosCFA:= 1 to len (aCFA)
				IF aCFA[nPosCFA][1] == "PIS" .AND. aCFA[nPosCFA][2] == cCodCred .AND. aCFA[nPosCFA][3] == cPer
					nCredDif	+= aCFA[nPosCFA][4]
				EndIF
			Next nPosCFA

			aAdd (aRegM100[nPosM100], nCredDif)			   	   		   				//11 - VL_CRED_DIF
			aAdd (aRegM100[nPosM100], nCredDisp - nCredDif)								//12 - VL_CRED_DISP
			nCredDisp := nCredDisp - nCredDif

			//Se total de credito ate o momento for menou ou igual ao total de contribuio, entao utiliza o credito
			If (nTotCredUt + nCredDisp) <= nTotContrb
				//Utiliza o valor total do credito no M200
				aAdd (aRegM100[nPosM100], "0")			   	   		   			//13 - IND_DESC_CRED
				nCredDesc := nCredDisp
				nTotCredUt += nCredDisp //Acumulo cr©dito utilizado
			Else
				//O valor do cr©dito no periodo © maior do que o valor da contribuio, no ir¡ utilizar o credito, e ser¡ utilizado no proximo per­odo.
				aAdd (aRegM100[nPosM100], "1")			   	   		   			//13 - IND_DESC_CRED
				nCredDesc := nTotContrb - nTotCredUt
				nTotCredUt += nCredDesc //Acumulo cr©dito utilizado
				//Gravar na tabela com valor de nCredDisp

			EndIF
			aAdd (aRegM100[nPosM100], nCredDesc)			   	   		   		//14 - VL_CRED_DESC
			aAdd (aRegM100[nPosM100], Round(aRegM100[nPosM100][12] - aRegM100[nPosM100][14],2))			   	   		//15 - SLD_CRED

			aRegM100[nPosM100][15] := SPDFCFSldCred(aRegM100[nPosM100][15])
			IF aRegM100[nPosM100][15] > 0
				aRegM100[nPosM100][13] := "1"
			Else
				aRegM100[nPosM100][13] := "0"
			EndIF

		Else
			//Acumula
			If lPauta
				aRegM100[nPosM100][6]+= nBaseRat									//04 - VL_BC_PIS
				nCredDisp:=Round((aRegM100[nPosM100][6] * aAuxM105[nCont][11]),2)
			Else
				aRegM100[nPosM100][4]+= nBaseRat									//04 - VL_BC_PIS
				nCredDisp:=Round((aRegM100[nPosM100][4] * aAuxM105[nCont][11])/100,2)
			EndIF

	   		aRegM100[nPosM100][8] := nCredDisp									//08 - VL_CRED

			nCredDisp := nCredDisp - aRegM100[nPosM100][11]

			nCredDesc := nCredDisp
	   		aRegM100[nPosM100][12]:= nCredDisp									//12 - VL_CRED_DISP

	   		nCredAtual	:=	Round((aAuxM105[nCont][11] * nBaseRat)/100,2)
			//Se total de credito ate o momento for menou ou igual ao total de contribuio, entao utiliza o credito
			If (nTotCredUt + nCredDisp) <= nTotContrb
	   			aRegM100[nPosM100][14]:= nCredDesc											//14 - VL_CRED_DESC
	   			nTotCredUt += nCredAtual //Acumulo cr©dito utilizado
	  		Else

	  	   		//O valor do cr©dito no periodo © maior do que o valor da contribuio, no ir¡ utilizar o credito, e ser¡ utilizado no proximo per­odo.
				nCredDesc := nTotContrb - nTotCredUt
				nTotCredUt += nCredDesc //Acumulo cr©dito utilizado
	  	   		aRegM100[nPosM100][14]+= nCredDesc			//14 - VL_CRED_DESC
	  	   		nTotCredPx += nCredAtual - nCredDesc //Guardo o valor de credito que nao foi utilizado neste periodo
	  	   		//Grava na tabela o credito para proximo periodo

	  		EndIF
	   		aRegM100[nPosM100][15]:= Round(aRegM100[nPosM100][12] - aRegM100[nPosM100][14],2)						//15 - SLD_CRED
			aRegM100[nPosM100][15] := SPDFCFSldCred(aRegM100[nPosM100][15])
			IF aRegM100[nPosM100][15] > 0
				aRegM100[nPosM100][13] := "1"
			Else
				aRegM100[nPosM100][13] := "0"
			EndIF

		EndIf

		nPosM105 := aScan (aRegM105, {|aX| aX[1]==nPosM100 .AND.  aX[3]== aAuxM105[nCont][2] .AND.  aX[4]== aAuxM105[nCont][3]  })
		If nPosM105 ==0
			//Adiciona M105
			aAdd(aRegM105, {})
			nPos := Len(aRegM105)
			aAdd (aRegM105[nPos], nPosM100)			   	   		   				//Relacao com M100
			aAdd (aRegM105[nPos], "M105")			   	   		   				//01 - REG
			aAdd (aRegM105[nPos], aAuxM105[nCont][2])			   	   			//02 - NAT_BC_CRED
			aAdd (aRegM105[nPos], aAuxM105[nCont][3])			   	   			//03 - CST_PIS
			aAdd (aRegM105[nPos], aAuxM105[nCont][4])			   	   			//04 - VL_BC_PIS_TOT
			aAdd (aRegM105[nPos], aAuxM105[nCont][5])			   	   			//05 - VL_BC_PIS_CUM
			aAdd (aRegM105[nPos], Iif(lPauta,0,nBcPis))						//06 - VL_BC_PIS_NC
			aAdd (aRegM105[nPos], Iif(lPauta,0,nBaseRat))						//07 - VL_BC_PIS
			aAdd (aRegM105[nPos], aAuxM105[nCont][8])			   	   			//08 - QUANT_BC_PIS_TOT
			aAdd (aRegM105[nPos], Iif(lPauta,nBaseRat,0))			   	   		//09 - QUANT_BC_PIS
			aAdd (aRegM105[nPos], aAuxM105[nCont][10])			   	   			//10 - DESC_CRED
		Else
			aRegM105[nPosM105][5]+=aAuxM105[nCont][4]							//04 - VL_BC_PIS_TOT
			aRegM105[nPosM105][6]+=aAuxM105[nCont][5]    						//05 - VL_BC_PIS_CUM
			aRegM105[nPosM105][7]+=Iif(lPauta,0,nBcPis)   						//06 - VL_BC_PIS_NC
			aRegM105[nPosM105][8]+= Iif(lPauta,0,nBaseRat) 					//07 - VL_BC_PIS
			aRegM105[nPosM105][9]+= aAuxM105[nCont][8]    						//08 - QUANT_BC_PIS_TOT
			aRegM105[nPosM105][10]+= Iif(lPauta,nBaseRat,0)					//09 - QUANT_BC_PIS
		EndIF
	EndIF

Next nCont

//Processa registro M110 e M115
RegM110(@aRegM100,@aRegM110,nTotContrb,cPer,@aCredPresu,@aAjuCred,nTotCredUt,aAjCredSCP,@aAjustMX10,@aCF5)

If lGeraReg
	If Len(aRegM110) > 0 .And. dDatade >=  CTOD("01/05/2014")
		RegM115(@aRegM115,aRegM110,aCF5)
	EndIf
EndIf

For nCont:= 1 To Len(aRegM100)
	aRegM200[1][3] += aRegM100[nCont][14]
Next nCont

Return

/*±±ºPrograma  AcumM505  ºAutor  Erick G. Dias       º Data   24/02/11  º±±
±±ºDesc.      Processamento do registro M105                             º±±*/
Static Function AcumM505(aRegM505,cAliasSFT,cRegime,lCumulativ,cIndApro,aReg0111,lSemNota, aF100,cAliasF130,cAliasF120,cAliasSB1,cAliasCF8,aDevCpMsmP,nPosDevCmp,cAliasCF9, aAtvImob)

Local nPos			:= 0
local nPosM505		:= 0
local lImport		:= .F.
Local nCofPauta		:= 0
Local nQtdBCof		:= 0
Local lPauta		:= .F.
Local lCmpPauta		:=	.F.
Local cCstCof		:= ""
Local nAliqCof		:= 0
Local nBcCof		:= 0
Local nTotalRec		:= 0
Local cCodBCC		:= ""
Local lApropDir		:= aParSX6[14]
Local aBaseAlqUn	:= {}
Local cChaveCCZ		:= ""
Local cCodNat		:= ""
Local nCont			:= 0
Local cCodCred		:= ""
Local cIndCont		:= ""
Local cDescCred		:= ""
Local lAgrIndust	:= .F.
Local cALSF23       := ""

DEFAULT lSemNota	:= .F.
DEFAULT aF100		:= {}
DEFAULT aAtvImob    := {}
DEFAULT cAliasF120	:= ""
DEFAULT cAliasF130	:= ""
DEFAULT cAliasSB1	:= "SB1"
DEFAULT cAliasCF8	:= ""
DEFAULT cAliasCF9	:= ""
DEFAULT aDevCpMsmP	:= {}
DEFAULT nPosDevCmp	:= 0

IF lGrBlocoM
	IF !empty(cAliasF130) .Or. !empty(cAliasF120) // Processa valores do mdulo do Ativo
		cALSF23 := If(!empty(cAliasF130),cAliasF130,cAliasF120)
	  	If SN1->(dbSeek(xFilial('SN1')+(cALSF23)->BEM+(cALSF23)->ITEM))
       		If SD1->(dbSeek(xFilial('SD1')+(cALSF23)->NOTAFISCAL+(cALSF23)->SERIE+(cALSF23)->FORNECEDOR+(cALSF23)->LOJA +SN1->N1_PRODUTO+SN1->N1_NFITEM))
   		  		If (SubStr (AllTrim (SD1->D1_CF), 1, 1)=="3")
   		        	If aFieldPos[85] .And. (Empty(SN1->N1_CBCPIS) .Or. SN1->N1_CBCPIS == "1")
   		        		nAliqCof := SD1->D1_ALQCOF
   		        	EndIf
   		        	lImport  := If(!empty(cAliasF130),(cAliasF130)->IND_ORIG_C == "1" ,(cAliasF120)->INDORIGCRD == "1" )
   		  		EndIf
   		  	EndIf
   		EndIf
   	EndIf

	IF !lSemNota
		lCmpPauta	:=	aFieldPos[21]
		cCstCof		:= (cAliasSFT)->FT_CSTCOF
		nAliqCof	:= (cAliasSFT)->FT_ALIQCOF
		IF Len(aDevCpMsmP) > 0 .AND.  nPosDevCmp > 0
			nBcCof		:= (cAliasSFT)->FT_BASECOF - aDevCpMsmP[nPosDevCmp][9]
		Else
			nBcCof		:= (cAliasSFT)->FT_BASECOF
		EndIF
		nTotalRec	:= (cAliasSFT)->FT_TOTAL
		cCodBCC		:= (cAliasSFT)->FT_CODBCC
	ElseIf Len(aF100) > 0 // Se nao tiver nota, so os t­tulos lanados manualmente no financeiro, neste caso no utilizo os valores da SFT, e sim os valores da funo que o financeiro disponibilizou.
		cCstCof		:= aF100[11]
		nAliqCof	:= aF100[13]
		nBcCof		:= aF100[12]
		nTotalRec	:= aF100[6]
		cCodBCC		:= aF100[15]
	Elseif !empty(cAliasF130)
		If  nAliqCof  == 0
   	   		nAliqCof	:= (cAliasF130)->ALIQ_COFIN
   	   	EndIf
   	   	nBcCof		:= (cAliasF130)->VL_BC_COFIN
		cCstCof		:= cvaltochar((cAliasF130)->CST_COFINS)
		nTotalRec	:= (cAliasF130)->VL_OPER_AQ
		cCodBCC		:= cvaltochar((cAliasF130)->NAT_BC_CRE)
	ElseIF !empty(cAliasF120) // Processa valores do mdulo do Ativo
		If  nAliqCof  == 0
   	   		nAliqCof	:=(cAliasF120)->ALIQCOFINS
   	   	EndIf
		cCstCof	:=(cAliasF120)->CSTCOFINS
		nBcCof		:=(cAliasF120)->VLRBCCOFIN
		nTotalRec	:=(cAliasF120)->VRET
		cCodBCC	:=(cAliasF120)->NATBCCRED
	ElseIF !empty(cAliasCF8) .And. !Empty((cAliasCF8)->CF8_CSTCOF) // Processa valores que foram cadastrados manualmente pelo usu¡rio para registro F100
		cCstCof		:=(cAliasCF8)->CF8_CSTCOF
		nAliqCof	:=(cAliasCF8)->CF8_ALQCOF
		nBcCof		:=(cAliasCF8)->CF8_BASCOF
		nTotalRec	:=(cAliasCF8)->CF8_VLOPER
		cCodBCC		:=(cAliasCF8)->CF8_CODBCC
	ElseIF !empty(cAliasCF9) // Processa valores que foram cadastrados manualmente pelo usu¡rio para registro F100
		cCstCof		:=(cAliasCF9)->CF9_CSTCOF
		nAliqCof	:=(cAliasCF9)->CF9_ALQCOF
		nBcCof		:=(cAliasCF9)->CF9_BASMES
		cCodBCC		:=(cAliasCF9)->CF9_CODBCC
	ElseIf Len(aAtvImob) > 0  //Atividade Imobiliaria
		If aAtvImob[2] == "F205"
			cCstCof		:=  aAtvImob[14]
			nAliqCof	:=  aAtvImob[15]
			nBcCof		:=  aAtvImob[7]
			cCodBCC		:=  "15"
		Else
			cCstCof		:=  aAtvImob[10]
			nAliqCof	:=  aAtvImob[11]
			nBcCof		:=  aAtvImob[6]
			cCodBCC		:= "16"
		EndIf
	EndIF
	If Empty (cALSF23) // Para o F120 e f130 nao eh necessario pois ja vem com o valor de aliquota correto.
		MajAliqVal(@nAliqCof,,cAliasSFT)
	EndIf
	If (SX5->(MsSeek (xFilial ("SX5")+"MZ"+ cCodBCC)))
		cDescCred	:=	SX5->X5_DESCRI
	Endif

	IF !lSemNota
		lImport := Iif(Substr((cAliasSFT)->FT_CFOP,1,1) == "3",.T.,.F.)
		lAgrIndust := Iif(Substr((cAliasSFT)->FT_TNATREC,1,1) $ "439",.T.,.F.)

		If (cAliasSFT)->FT_VALCOF > 0
				If (lCmpPauta .And. (cAliasSFT)->FT_PAUTCOF > 0) .OR. (cAliasSB1)->B1_VLR_COF > 0
				aBaseAlqUn	:=	VlrPauta(lCmpNRecFT, lCmpNRecB1, "COF",cAliasSFT,cAliasSB1,lCmpNRecF4,lCmpPauta)
				nCofPauta 	:= 	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][1] , Iif((cAliasSFT)->FT_PAUTCOF > 0,(cAliasSFT)->FT_PAUTCOF,(cAliasSB1)->B1_VLR_COF))
				nQtdBCof  	:= 	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][2] , (cAliasSFT)->FT_QUANT)
				cCodNat	  	:=	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][3] , "")
				lPauta		:=	.T.
			EndIF
		EndIF
	EndIF

	IF cCstCof $ "50/51/52/60/61/62"
		nContLimit :=1
	ElseIf cCstCof $ "53/63/54/64/55/65"  //CST que apontam para 2 receitas diferentes
		nContLimit :=2
	Else //Sobram os CSTs 56 e 66, que apontam para 3 receitas diferentes
		nContLimit :=3
	EndIF

	If	nAliqCof == 3 .OR. nAliqCof == 7.60
		cIndCont := "1"
	Else
		cIndCont := "2"
	EndIf

	For nCont := 1 to nContLimit

		cCodCred	:= ""
		//Chamada da funcao que retorna o Codigo de Tipo de Credito - Tabela 4.3.6
		cCodCred	:=	SPEDCodCre(	cCstCOf,;		// Codigo da Situacao Tributaria - CST
									cCodBCC,;		// Codigo de Base de Calculo do Credito - CODBCC
									lPauta,;		// Operacao com Unidade de Produto - Pauta
									lImport,;		// Operacao de Importacao
									cCodNat,;		// Codigo da Natureza da Receita
									cIndCont,;		// Tipo de Aliquota (Basica/Diferenciada)
									nQtdBCof,;      // Aliquota Unidade de Produto
									nCont,;
									lAgrIndust)	// Operao AgroIndustria

		If (nPosM505 := aScan (aRegM505, {|aX| aX[2]==cCodBCC .AND.  aX[3]==cCstCof ;
									.AND. cValToChar(aX[11]) == cValToChar(Iif(lPauta,nCofPauta,nAliqCof) ) .AND. aX[12] == lImport .AND.;
									 aX[13] == cCodNat .And. aX[14] == lPauta .AND. aX[15]==cCodCred })) == 0

	   		aAdd(aRegM505, {})
			nPos := Len(aRegM505)
			aAdd (aRegM505[nPos], "M505")			   	   			//01 - REG
			aAdd (aRegM505[nPos], cCodBCC)			//02 - NAT_BC_CRED
			aAdd (aRegM505[nPos], cCstCof)			//03 - CST_COF
			If !lPauta
				aAdd (aRegM505[nPos], nBcCof)			//04 - VL_BC_COF_TOT
				If cRegime $ "3"
					If !lApropDir //Se no for aprorpiao direta
						aAdd (aRegM505[nPos], Round((nBcCof *  aReg0111[1][5]) / aReg0111[1][6],2))			   	   				//05 - VL_BC_COF_CUM
					Else
						aAdd (aRegM505[nPos], 0)		 	//05 - VL_BC_COF_CUM
					EndIF
				Else
					aAdd (aRegM505[nPos], 0)		 	//05 - VL_BC_COF_CUM
				EndIF
			Else
				aAdd (aRegM505[nPos], 0)		 	//04 - VL_BC_COF_TOT
				aAdd (aRegM505[nPos], 0)		 	//05 - VL_BC_COF_CUM
			EndIf
			aAdd (aRegM505[nPos], 0)			   	   										//06 - VL_BC_COF_NC
			aAdd (aRegM505[nPos], 0)			   	   										//07 - VL_BC_COF
			aAdd (aRegM505[nPos], Iif(lPauta,nQtdBCof,""))			   	   					//08 - QUANT_BC_COF_TOT
			aAdd (aRegM505[nPos], "")			   	   										//09 - QUANT_BC_COF
			aAdd (aRegM505[nPos], cDescCred)		   	   									//10 - DESC_CRED

			//As posicoes abaixo foram criadas apenas para validar a geracao do registro M105. Nao sao impressas no arquivo magnetico	
			aAdd (aRegM505[nPos],  Iif(lPauta,nCofPauta,nAliqCof))							//11 - Aliquota COFINS
			aAdd (aRegM505[nPos],  lImport)   												//12 - Importacao
			aAdd (aRegM505[nPos],  cCodNat)   												//13 - Cdigo natureza da receita
			aAdd (aRegM505[nPos],  lPauta)   												//14 - Pauta
			aAdd (aRegM505[nPos],  cCodCred)                                				//15 - Codigo do Cr©dito 4.3.6
			aAdd (aRegM505[nPos],  nCont)                                  					//16 - Nºmero que ser¡ utilizado no momento da gerao do registro M100 rateio dos cr©ditos pelas receitas

		Else
			If lPauta
				aRegM505[nPosM505][8]+= nQtdBCof											//08 - QUANT_BC_COFINS_TOT
			Else
				aRegM505[nPosM505][4]+= nBcCof								//04 - VL_BC_PIS_TOT
				If cRegime $ "3" .AND. !lApropDir //Se no for aprorpiao direta
					aRegM505[nPosM505][5]:=Round((aRegM505[nPosM505][4] *  aReg0111[1][5]) / aReg0111[1][6],2)
				EndIf
			EndIF
		EndIF
	Next nCont
EndIF
Return

/*±±ºPrograma  RegM505   ºAutor  Erick G. Dias       º Data   24/02/11 º±±
±±ºDesc.      Processamento do registro M505                             º±±*/
Static Function RegM505(cAlias,aRegM500,aRegM505,aAuxM505,aRegM600,aReg0111,cIndApro,aReg1500,cPer,nTotContrb,aRegM510,aCredPresu,aAjuCred,aVlCrdImob,aAjCredSCP,aAjustMX10, aCFA,aRegM515)

Local nCont			:=	0
Local nCont2		:=	0
Local nContLimit	:= 0
Local nPos			:=	0
Local nPosM500		:=	0
Local cCodCred		:= 	""
Local nBcPis		:=  0
Local nCredDisp 	:=  0
Local nCredDesc		:=  0
Local nTotCred		:=  0
Local nBaseRat		:= 0
Local nPosPerc		:= 0
Local cCnpj			:= ""
Local lPauta		:= .F.
Local nPosM505		:= 0
Local nTotCredUt	:= 0 //Tera o total de credito, para fazer o controle se os creditos so maiores que a contribuio, para levar os creditos para o prximo mªs.
Local nTotCredPx	:= 0 //Tota de cr©dito para proximo perido
Local nCredAtual	:=	0
Local cIndCont		:= ""
Local aOrdCodCre	:= {}
Local nContOrd		:= 0
Local bOrd			:= {|x,y|x[15]<y[15]}
Local nCredPar		:= 0
Local nCredDif		:= 0
Local nX 			:= 0
Local nPosCFA		:= 0
Local aCF5			:={}

//Ordeno primeiro com ordem crescente do cdigo de cr©dito
aAuxM505  := Asort(aAuxM505,,,bOrd)

aOrdCodCre:= MontOrdCre()

//Faz Loop no array aAuxM505, que tem os valores referente			
//a COF acumulados dos diversos registros dos blocos A, C, D e F.	

IF len(aOrdCodCre) > 0
	SpdSort(@aAuxM505,aOrdCodCre,15)
EndIF

For nCont :=1 to Len(aAuxM505)

	nBcPis:=0
	lPauta := .F.

	If	aAuxM505[nCont][11] == 3 .OR. aAuxM505[nCont][11] == 7.60
		cIndCont := "1"
	Else
		cIndCont := "2"
	EndIf

	If aAuxM505[nCont][14]
		nBcPis		:=	aAuxM505[nCont][8]
		nCredDisp	:=	Round((nBcPis * aAuxM505[nCont][11]),2)
		lPauta 		:=	.T.
	Else
		nBcPis		:=	aAuxM505[nCont][4] - aAuxM505[nCont][5]
		nCredDisp	:=	Round((nBcPis * aAuxM505[nCont][11])/100,2)
	EndIF

    //CST que indicam somente um tipo de receita
	If aAuxM505[nCont][3] $ "50/51/52/60/61/62"

		//Chamada da funcao que retorna o Codigo de Tipo de Credito - Tabela 4.3.6
		cCodCred	:=	aAuxM505[nCont][15]

		If cCodCred == "109"
			nCredDisp := aVlCrdImob[2]
		EndIf

		If lPauta
			nPosM500 := aScan (aRegM500, {|aX| aX[2]==cCodCred .AND.  cValToChar(aX[7])==cValToChar(aAuxM505[nCont][11]) })
		Else
			nPosM500 := aScan (aRegM500, {|aX| aX[2]==cCodCred .AND.  cValToChar(aX[5])==cValToChar(aAuxM505[nCont][11]) })
		EndIF
		IF nPosM500 == 0
			aAdd(aRegM500, {})
			nPosM500 := Len(aRegM500)
			aAdd (aRegM500[nPosM500], "M500")			   	   		   			//01 - REG
			aAdd (aRegM500[nPosM500], cCodCred)			   	   		   			//02 - COD_CRED
			aAdd (aRegM500[nPosM500], "0")				   	   		   			//03 - IND_CRED_ORI
			aAdd (aRegM500[nPosM500], Iif(lPauta,0,nBcPis))  					//04 - VL_BC_PIS
			aAdd (aRegM500[nPosM500], Iif(lPauta,"",aAuxM505[nCont][11]))		//05 - ALIQ_PIS
			aAdd (aRegM500[nPosM500], Iif(lPauta,nBcPis,""))			   	   	//06 - QUANT_BC_PIS
			aAdd (aRegM500[nPosM500], Iif(lPauta,aAuxM505[nCont][11],""))		//07 - ALIQ_PIS_QUANT
			aAdd (aRegM500[nPosM500], nCredDisp)								//08 - VL_CRED
			aAdd (aRegM500[nPosM500], 0)			   	   		   				//09 - VL_AJUST_ACRED
			aAdd (aRegM500[nPosM500], 0)			   	   		   				//10 - VL_AJUS_REDUC

			nCredDif	:= 0

			For nPosCFA:= 1 to len (aCFA)
				IF aCFA[nPosCFA][1] == "COF" .AND. aCFA[nPosCFA][2] == cCodCred .AND. aCFA[nPosCFA][3] == cPer
					nCredDif	+= aCFA[nPosCFA][4]
				EndIF
			Next nPosCFA

			aAdd (aRegM500[nPosM500], nCredDif)			   	   		   				//11 - VL_CRED_DIF
			aAdd (aRegM500[nPosM500], nCredDisp - nCredDif)								//12 - VL_CRED_DISP
			nCredDisp := nCredDisp - nCredDif
			aAdd (aRegM500[nPosM500], "0")			   	   		   			//13 - IND_DESC_CRED
			//Se total de credito ate o momento for menou ou igual ao total de contribuio, entao utiliza o credito
			If (nTotCredUt + nCredDisp) <= nTotContrb
				//Utiliza o valor total do credito no M200
				nCredDesc := nCredDisp
				nTotCredUt += nCredDisp //Acumulo cr©dito utilizado
			Else
				//O valor do cr©dito no periodo © maior do que o valor da contribuio, no ir¡ utilizar o credito, e ser¡ utilizado no proximo per­odo.
				nCredDesc := nTotContrb - nTotCredUt
				nTotCredUt += nCredDesc //Acumulo cr©dito utilizado
				//Gravar na tabela com valor de nCredDisp
			EndIF

			aAdd (aRegM500[nPosM500], nCredDesc)			   	   		   				//14 - VL_CRED_DESC
			aAdd (aRegM500[nPosM500], Round(aRegM500[nPosM500][12] - aRegM500[nPosM500][14],2))			   	   		   		//15 - SLD_CRED
			aRegM500[nPosM500][15] := SPDFCFSldCred(aRegM500[nPosM500][15])
			IF aRegM500[nPosM500][15] > 0
				aRegM500[nPosM500][13]	:= "1"
			Else
				aRegM500[nPosM500][13]	:= "0"
			EndIF

		Else

	   		//acumula
	   		If lPAuta
		   		aRegM500[nPosM500][6]+= nBcPis												//06 - QUANT_BC_PIS
		   	Else
				aRegM500[nPosM500][4]+= nBcPis												//04 - VL_BC_PIS
		   	EndIF

			If cCodCred <> "109"
				If lPauta
					nCredDisp:=Round((nBcPis * aAuxM505[nCont][11]),2)
		   		Else
					nCredDisp:=Round((nBcPis * aAuxM505[nCont][11])/100,2)
				EndIf
	   		Else
		   		nCredDisp:= 0
	   		EndIf

			nCredDesc := nCredDisp

	   		aRegM500[nPosM500][8]+=nCredDisp											//08 - VL_CRED
	   		aRegM500[nPosM500][12]+= nCredDisp											//12 - VL_CRED_DISP

			//Se total de credito ate o momento for menou ou igual ao total de contribuio, entao utiliza o credito
			If (nTotCredUt + nCredDisp) <= nTotContrb
	   			aRegM500[nPosM500][14]+= nCredDesc											//14 - VL_CRED_DESC
	   			nTotCredUt += nCredDesc //Acumulo cr©dito utilizado
	  		Else
	  	   		//O valor do cr©dito no periodo © maior do que o valor da contribuio, no ir¡ utilizar o credito, e ser¡ utilizado no proximo per­odo.
				nCredDesc := nTotContrb - nTotCredUt
				nTotCredUt += nCredDesc //Acumulo cr©dito utilizado
	  	   		aRegM500[nPosM500][14]+= nCredDesc			//14 - VL_CRED_DESC
	  	   		nTotCredPx += nCredDisp - nCredDesc //Guardo o valor de credito que nao foi utilizado neste periodo
	  	   		//Grava na tabela o credito para proximo periodo
	  		EndIF
	   		aRegM500[nPosM500][15]:= Round(aRegM500[nPosM500][12] - aRegM500[nPosM500][14],2)
			aRegM500[nPosM500][15] := SPDFCFSldCred(aRegM500[nPosM500][15])
			IF aRegM500[nPosM500][15] > 0
				aRegM500[nPosM500][13]	:= "1"
			Else
				aRegM500[nPosM500][13]	:= "0"
			EndIF


		EndIf

		nPosM505 := aScan (aRegM505, {|aX| aX[1]==nPosM500 .AND.  aX[3]== aAuxM505[nCont][2] .AND.  aX[4]== aAuxM505[nCont][3]})
		If nPosM505 ==0
			//Adiciona M505
			aAdd(aRegM505, {})
			nPos := Len(aRegM505)
			aAdd (aRegM505[nPos], nPosM500)			   	   		   				//Relacao com M500
			aAdd (aRegM505[nPos], "M505")			   	   		   				//01 - REG
			aAdd (aRegM505[nPos], aAuxM505[nCont][2])			   	   			//02 - NAT_BC_CRED
			aAdd (aRegM505[nPos], aAuxM505[nCont][3])			   	   			//03 - CST_PIS
			aAdd (aRegM505[nPos], aAuxM505[nCont][4])			   	   			//04 - VL_BC_PIS_TOT
			aAdd (aRegM505[nPos], aAuxM505[nCont][5])			   	   			//05 - VL_BC_PIS_CUM
			aAdd (aRegM505[nPos], Iif(lPauta,0,nBcPis))						//06 - VL_BC_PIS_NC
			aAdd (aRegM505[nPos], Iif(lPauta,0,nBcPis))						//07 - VL_BC_PIS
			aAdd (aRegM505[nPos], aAuxM505[nCont][8])			   	   			//08 - QUANT_BC_PIS_TOT
			aAdd (aRegM505[nPos], aAuxM505[nCont][8])			   	   			//09 - QUANT_BC_PIS
			aAdd (aRegM505[nPos], aAuxM505[nCont][10])			   	   			//10 - DESC_CRED
		Else
			//Acumula
			aRegM505[nPosM505][5]+=aAuxM505[nCont][4]							//04 - VL_BC_COFINS_TOT
			aRegM505[nPosM505][6]+=aAuxM505[nCont][5]    						//05 - VL_BC_COFINS_CUM
			aRegM505[nPosM505][7]+=Iif(lPauta,0,nBcPis)   						//06 - VL_BC_COFINS_NC
			aRegM505[nPosM505][8]+= Iif(lPauta,0,nBcPis) 						//07 - VL_BC_COFINS
			aRegM505[nPosM505][9]+= aAuxM505[nCont][8]    						//08 - QUANT_BC_COFINS_TOT
			aRegM505[nPosM505][10]+= aAuxM505[nCont][8]   						//09 - QUANT_BC_COFINS
		EndIF

	Else
		//Calcula o valor da base proporcional para a receita, considerando os valores do registro 0111
		nBaseRat :=	Round(BasePisCof(aAuxM505[nCont][16],aReg0111,aAuxM505[nCont][3],nBcPis),2)
		If lPauta
			nCredDisp:=Round((nBaseRat * aAuxM505[nCont][11]),2)
		Else
			nCredDisp:=Round((nBaseRat * aAuxM505[nCont][11])/100,2)
		EndIF

		cCodCred	:= aAuxM505[nCont][15]

	    If lPauta
			nPosM500 := aScan (aRegM500, {|aX| aX[2]==cCodCred .AND.  cvaltoChar(aX[7])==CValToChar(aAuxM505[nCont][11]) })
	    Else
	    	nPosM500 := aScan (aRegM500, {|aX| aX[2]==cCodCred .AND.  cValToChar(aX[5])==cValToChar(aAuxM505[nCont][11]) })
	    EndIF
	    IF nPosM500 == 0
			aAdd(aRegM500, {})
			nPosM500 := Len(aRegM500)
			aAdd (aRegM500[nPosM500], "M500")			   	   		   			//01 - REG
			aAdd (aRegM500[nPosM500],cCodCred)			   	   		   			//02 - COD_CRED
			aAdd (aRegM500[nPosM500], "0")				   	   		   			//03 - IND_CRED_ORI
			aAdd (aRegM500[nPosM500], Iif(lPauta,0,nBaseRat))  				//04 - VL_BC_PIS
			aAdd (aRegM500[nPosM500], Iif(lPauta,"",aAuxM505[nCont][11]))		//05 - ALIQ_PIS
			aAdd (aRegM500[nPosM500], Iif(lPauta,nBaseRat,0))			   	   	//06 - QUANT_BC_PIS
			aAdd (aRegM500[nPosM500], Iif(lPauta,aAuxM505[nCont][11],""))		//07 - ALIQ_PIS_QUANT
			aAdd (aRegM500[nPosM500], nCredDisp)								//08 - VL_CRED
			aAdd (aRegM500[nPosM500], 0)			   	   		   				//09 - VL_AJUST_ACRED
			aAdd (aRegM500[nPosM500], 0)			   	   		   				//10 - VL_AJUS_REDUC

			nCredDif	:= 0

			For nPosCFA:= 1 to len (aCFA)
				IF aCFA[nPosCFA][1] == "COF" .AND. aCFA[nPosCFA][2] == cCodCred .AND. aCFA[nPosCFA][3] == cPer
					nCredDif	+= aCFA[nPosCFA][4]
				EndIF
			Next nPosCFA

			aAdd (aRegM500[nPosM500], nCredDif)			   	   		   				//11 - VL_CRED_DIF
			aAdd (aRegM500[nPosM500], nCredDisp-nCredDif)								//12 - VL_CRED_DISP
			nCredDisp := nCredDisp - nCredDif
			aAdd (aRegM500[nPosM500], "0")			   	   		   			//13 - IND_DESC_CRED
			//Se total de credito ate o momento for menou ou igual ao total de contribuio, entao utiliza o credito
			If (nTotCredUt + nCredDisp) <= nTotContrb
				//Utiliza o valor total do credito no M200
				nCredDesc := nCredDisp
				nTotCredUt += nCredDisp //Acumulo cr©dito utilizado
			Else
				//O valor do cr©dito no periodo © maior do que o valor da contribuio, no ir¡ utilizar o credito, e ser¡ utilizado no proximo per­odo.
				nCredDesc := nTotContrb - nTotCredUt
				nTotCredUt += nCredDesc //Acumulo cr©dito utilizado
				//Gravar na tabela com valor de nCredDisp
			EndIF

			aAdd (aRegM500[nPosM500], nCredDesc)			   	   		   				//14 - VL_CRED_DESC
			aAdd (aRegM500[nPosM500], Round(aRegM500[nPosM500][12] - aRegM500[nPosM500][14],2))			   	   		   		//15 - SLD_CRED
			
			aRegM500[nPosM500][15] := SPDFCFSldCred(aRegM500[nPosM500][15])
			
			IF aRegM500[nPosM500][15] > 0
				aRegM500[nPosM500][13]	:= "1"
			Else
				aRegM500[nPosM500][13]	:= "0"
			EndIF

		Else
			//Acumular
			If lPauta
				aRegM500[nPosM500][6]+= nBaseRat									//04 - VL_BC_PIS
				nCredDisp:=Round((aRegM500[nPosM500][6] * aAuxM505[nCont][11]),2)
			Else
				aRegM500[nPosM500][4]+= nBaseRat									//04 - VL_BC_PIS
				nCredDisp:=Round((aRegM500[nPosM500][4] * aAuxM505[nCont][11])/100,2)
			EndIF

	   		aRegM500[nPosM500][8] := nCredDisp									//08 - VL_CRED

			nCredDisp := nCredDisp - aRegM500[nPosM500][11]

			nCredDesc := nCredDisp
	   		aRegM500[nPosM500][12]:= nCredDisp									//12 - VL_CRED_DISP

	   		nCredAtual	:=	Round((aAuxM505[nCont][11] * nBaseRat)/100,2)
			//Se total de credito ate o momento for menou ou igual ao total de contribuio, entao utiliza o credito
			If (nTotCredUt + nCredDisp) <= nTotContrb
	   			aRegM500[nPosM500][14]:= nCredDesc											//14 - VL_CRED_DESC
	   			nTotCredUt += nCredAtual //Acumulo cr©dito utilizado
	  		Else
	  	   		//O valor do cr©dito no periodo © maior do que o valor da contribuio, no ir¡ utilizar o credito, e ser¡ utilizado no proximo per­odo.
				nCredDesc := nTotContrb - nTotCredUt
				nTotCredUt += nCredDesc //Acumulo cr©dito utilizado
	  	   		aRegM500[nPosM500][14]+= nCredDesc			//14 - VL_CRED_DESC
	  	   		nTotCredPx += nCredAtual - nCredDesc //Guardo o valor de credito que nao foi utilizado neste periodo
	  	   		//Grava na tabela o credito para proximo periodo
	  		EndIF
	  		
	   		aRegM500[nPosM500][15]:= Round(aRegM500[nPosM500][12] - aRegM500[nPosM500][14],2)
			aRegM500[nPosM500][15] := SPDFCFSldCred(aRegM500[nPosM500][15])
			
			IF aRegM500[nPosM500][15] > 0
				aRegM500[nPosM500][13]	:= "1"
			Else
				aRegM500[nPosM500][13]	:= "0"
			EndIF

		EndIf

		nPosM505 := aScan (aRegM505, {|aX| aX[1]==nPosM500 .AND.  aX[3]== aAuxM505[nCont][2] .AND.  aX[4]== aAuxM505[nCont][3]  })
		If nPosM505 ==0
			//Adiciona M505
			aAdd(aRegM505, {})
			nPos := Len(aRegM505)
			aAdd (aRegM505[nPos], nPosM500)			   	   		   				//Relacao com M500
			aAdd (aRegM505[nPos], "M505")			   	   		   				//01 - REG
			aAdd (aRegM505[nPos], aAuxM505[nCont][2])			   	   			//02 - NAT_BC_CRED
			aAdd (aRegM505[nPos], aAuxM505[nCont][3])			   	   			//03 - CST_PIS
			aAdd (aRegM505[nPos], aAuxM505[nCont][4])			   	   			//04 - VL_BC_PIS_TOT
			aAdd (aRegM505[nPos], aAuxM505[nCont][5])			   	   			//05 - VL_BC_PIS_CUM
			aAdd (aRegM505[nPos], Iif(lPauta,0,nBcPis))						//06 - VL_BC_PIS_NC
			aAdd (aRegM505[nPos], Iif(lPauta,0,nBaseRat))						//07 - VL_BC_PIS
			aAdd (aRegM505[nPos], aAuxM505[nCont][8])			   	   			//08 - QUANT_BC_PIS_TOT
			aAdd (aRegM505[nPos], Iif(lPauta,nBaseRat,0))			   	   		//09 - QUANT_BC_PIS
			aAdd (aRegM505[nPos], aAuxM505[nCont][10])			   	   			//10 - DESC_CRED
		Else
			aRegM505[nPosM505][5]+=aAuxM505[nCont][4]							//04 - VL_BC_PIS_TOT
			aRegM505[nPosM505][6]+=aAuxM505[nCont][5]    						//05 - VL_BC_PIS_CUM
			aRegM505[nPosM505][7]+=Iif(lPauta,0,nBcPis)   						//06 - VL_BC_PIS_NC
			aRegM505[nPosM505][8]+= Iif(lPauta,0,nBaseRat) 					//07 - VL_BC_PIS
			aRegM505[nPosM505][9]+= aAuxM505[nCont][8]    						//08 - QUANT_BC_PIS_TOT
			aRegM505[nPosM505][10]+= Iif(lPauta,nBaseRat,0)					//09 - QUANT_BC_PIS
		EndIF


	EndIF

Next nCont

//Processa registro M510 e M515
RegM510(@aRegM500,@aRegM510,nTotContrb,cPer,@aCredPresu,@aAjuCred,nTotCredUt,aAjCredSCP,@aAjustMX10)

If lGeraReg
	If Len(aRegM510) > 0 .And. dDatade >=  CTOD("01/05/2014")
		RegM515(@aRegM515,aRegM510,aCF5)
	EndIf
EndIf

For nCont:= 1 TO Len(aRegM500)
	aRegM600[1][3] +=aRegM500[nCont][14]
Next nCont

Return

/*±±ºPrograma  IniM200600ºAutor  Erick G. Dias       º Data   25/02/11 º±±
±±ºDesc.      Inicializa os arrays M200 e M600.                          º±±
±±Parametros aRegM200   -> Array com valores para gerao do registro   ±±
±±           				M200.                                         ±±
±±           aRegM600   -> Array com valores para gerao do registro   ±±
±±           				M600.                                         ±±*/
Static Function IniM200600(aRegM200,aRegM600)

Local nPos	:= 0
aAdd(aRegM200, {})
nPos := Len(aRegM200)
aAdd (aRegM200[nPos], "M200")
aAdd (aRegM200[nPos],"")
aAdd (aRegM200[nPos], 0)
aAdd (aRegM200[nPos], 0)
aAdd (aRegM200[nPos], 0)
aAdd (aRegM200[nPos], 0)
aAdd (aRegM200[nPos], 0)
aAdd (aRegM200[nPos], 0)
aAdd (aRegM200[nPos], 0)
aAdd (aRegM200[nPos], 0)
aAdd (aRegM200[nPos], 0)
aAdd (aRegM200[nPos], 0)
aAdd (aRegM200[nPos], 0)

aAdd(aRegM600, {})
nPos := Len(aRegM600)
aAdd (aRegM600[nPos], "M600")
aAdd (aRegM600[nPos], "")
aAdd (aRegM600[nPos], 0)
aAdd (aRegM600[nPos], 0)
aAdd (aRegM600[nPos], 0)
aAdd (aRegM600[nPos], 0)
aAdd (aRegM600[nPos], 0)
aAdd (aRegM600[nPos], 0)
aAdd (aRegM600[nPos], 0)
aAdd (aRegM600[nPos], 0)
aAdd (aRegM600[nPos], 0)
aAdd (aRegM600[nPos], 0)
aAdd (aRegM600[nPos], 0)

Return

/*±±ºPrograma  RegM400   ºAutor  Erick G. Dias       º Data   01/03/11 º±±
±±ºDesc.      Processamento dos registro M400 e M410.                     º±±*/
Static Function RegM400(aRegM400,aRegM410,cAliasSFT,aReg0500, aRegF100,cAliasSB1,cAliasCF8, aParD600, aPar,nReceita, lSpdP61)

Local nPos			:= 0
local nPosM400		:= 0
local nPosM410		:= 0
local lAchouCCZ		:= .F.
Local lExisteCCZ	:= aIndics[05]
Local lExtCpoCCZ	:= lCmpNRecB1
Local cCstPis		:= ""
Local nValCont		:= 0
Local cConta		:= ""
Local cDtFimNt		:= ""
Local lSemNota		:= .F.
Local lCF8			:= .F.
Local lParD600		:= .F.
Local lPar    		:= .F.

Default cAliasSFT	:= ""
Default aRegF100	:={}
Default aReg0500	:={}
Default cAliasSB1	:= "SB1"
Default cAliasCF8	:= ""
Default aParD600	:= {}
Default aPar		:= {}
Default nReceita	:= 0

IF lGrBlocoM
	If Len(aRegF100) > 0 //No possui nota fisca
		lSemNota	:= .T.
	EndIF

	If Len(cAliasCF8) > 0
		lCF8	:= .T.
	EndIF

	If Len(aParD600) > 0
		lParD600	:= .T.
	EndIF

	If Len(aPar) > 0
		lPar	:= .T.
	EndIF

	If lPar //Informaµes com origem na gerao do regime de caixa
		cCstPis		:=  aPar[1]
		nValCont	:=  aPar[2]
		cConta		:=	aPar[3]
		If Valtype(aPar[7]) == "D"
			cDtFimNt	:=	DTOS(aPar[7])
		Elseif lSpdP61
			cDtFimNt	:= DTOS(aPar[12])
		Else
			cDtFimNt	:=	aPar[7]

		Endif
	ElseIf lParD600 //Informaµes com origem em notas de telecomunicao que no possuem livros fiscal, pois servio no foi faturado, por©m deve entrar como receita tribut¡vel de PIS/COFINS.
		cCstPis		:=  aParD600[1]
		nValCont	:=  aParD600[4]
		cConta		:=	aParD600[10]
		If Valtype(aParD600[9]) == "D"
			cDtFimNt	:=	DTOS(aParD600[9])
		Else
			cDtFimNt	:=	aParD600[9]
		Endif
	ElseIf lSemNota //No possui nota fisca
		cCstPis		:=aRegF100[3]
		nValCont	:=aRegF100[2]
	ElseIf lCF8
		cCstPis		:=(cAliasCF8)->CF8_CSTPIS
		nValCont	:=(cAliasCF8)->CF8_VLOPER
	Else
		cCstPis		:=	(cAliasSFT)->FT_CSTPIS
		nValCont	:=	Iif(nReceita > 0,nReceita,(cAliasSFT)->FT_TOTAL)
		cConta		:=	(cAliasSFT)->FT_CONTA
		If Valtype((cAliasSFT)->FT_DTFIMNT) == "D"
			cDtFimNt	:=	DTOS((cAliasSFT)->FT_DTFIMNT)
		Else
			cDtFimNt	:=	(cAliasSFT)->FT_DTFIMNT
		Endif
	EndIF

	If lPar
		If lSpdP61
			If CCZ->(MsSeek(xFilial("CCZ")+ aPar[9] + aPar[10] + aPar[11]  + cDtFimNt))
				lAchouCCZ := .T.
			EndIF
		Else

			If CCZ->(MsSeek(xFilial("CCZ")+ aPar[4] + aPar[5] + aPar[6]  + cDtFimNt))
				lAchouCCZ := .T.
			EndIF
		EndIf
	ElseIf lParD600
		If CCZ->(MsSeek(xFilial("CCZ")+ aParD600[6] + aParD600[7] + aParD600[8]  + cDtFimNt))
			lAchouCCZ := .T.
		EndIF
	ElseIf lCF8
    	If !Empty((cAliasCF8)->CF8_ITEM) .And. CCZ->(MsSeek(xFilial("CCZ")+SB1->B1_TNATREC+SB1->B1_CNATREC+SB1->B1_GRPNATR+DToS(SB1->B1_DTFIMNT)))
			lAchouCCZ := .T.
		Elseif aFieldPos[39] .And. !Empty((cAliasCF8)->CF8_TNATRE) .And. CCZ->(MsSeek(xFilial("CCZ")+(cAliasCF8)->CF8_TNATRE+(cAliasCF8)->CF8_CNATRE+(cAliasCF8)->CF8_GRPNC+DTOS((cAliasCF8)->CF8_DTFIMN)))
			lAchouCCZ := .T.
		EndIF
	ElseIf lExisteCCZ .AND. lExtCpoCCZ .AND. !lSemNota
		If CCZ->(MsSeek(xFilial("CCZ")+ (cAliasSFT)->FT_TNATREC + (cAliasSFT)->FT_CNATREC + (cAliasSFT)->FT_GRUPONC  + cDtFimNt))
			lAchouCCZ := .T.
		ElseIf CCZ->(MsSeek(xFilial("CCZ")+ SB1->B1_TNATREC + SB1->B1_CNATREC + SB1->B1_GRPNATR  + DToS(SB1->B1_DTFIMNT) ))
			lAchouCCZ := .T.
		ElseIf lCmpNRecF4 .And. CCZ->(MsSeek(xFilial("CCZ")+ SF4->F4_TNATREC + SF4->F4_CNATREC + SF4->F4_GRPNATR  + DToS(SF4->F4_DTFIMNT) ))
			lAchouCCZ := .T.
		EndIf
	ElseIF lSemNota
		If CCZ->(MsSeek(xFilial("CCZ")+ aRegF100[18] + aRegF100[19] + aRegF100[20] + Iif(" /" $ aRegF100[21],"",aRegF100[21]))	)
			lAchouCCZ := .T.
		EndIF
	ElseIf lExisteCCZ
		If CCZ->(MsSeek(xFilial("CCZ")+ SB1->B1_TNATREC + SB1->B1_CNATREC ))
			lAchouCCZ := .T.
		ElseIf lCmpNRecF4 .And. CCZ->(MsSeek(xFilial("CCZ")+ SF4->F4_TNATREC + SF4->F4_CNATREC))
			lAchouCCZ := .T.
		EndIf
	EndIF

	nPosM400 := aScan (aRegM400, {|aX| aX[2]==cCstPis })
	If nPosM400 == 0
		aAdd(aRegM400, {})
		nPos := Len(aRegM400)
		aAdd (aRegM400[nPos], "M400")			   	   	   			//01 - REG
		aAdd (aRegM400[nPos], cCstPis)								//02 - CST_PIS
		aAdd (aRegM400[nPos], nValCont)		  						//03 - VL_TOT_REC
		aAdd (aRegM400[nPos], Reg0500(@aReg0500,cConta,,cAliasSFT))	//04 - COD_CTA
		If lAchouCCZ
			aAdd (aRegM400[nPos], CCZ->CCZ_DESC )					//05 - DESC_COMPL
		Else
			aAdd (aRegM400[nPos], "" )								//05 - DESC_COMPL
		EndIF

		If lAchouCCZ
			aAdd (aRegM410, {})
			nPos := Len(aRegM410)
			aAdd (aRegM410[nPos], Len(aRegM400))                  	 	//Relacao com M400
			aAdd (aRegM410[nPos], "M410")			   	   				//01 - REG
			aAdd (aRegM410[nPos], CCZ->CCZ_COD)							//02 - NAT_REC
			aAdd (aRegM410[nPos], nValCont)								//03 - VL_REC
			aAdd (aRegM410[nPos], Reg0500(@aReg0500,cConta,,cAliasSFT))	//04 - COD_CTA
			aAdd (aRegM410[nPos], CCZ->CCZ_DESC)						//05 - DESC_COMPL
		EndIf
	Else
		aRegM400[nPosM400][3]+= nValCont  			//03 - VL_TOT_REC

		IF lAchouCCZ
			nPosM410 := aScan (aRegM410, {|aX| aX[3]==CCZ->CCZ_COD  .AND. ax[1] == nPosM400})
			If nPosM410 == 0
				aAdd (aRegM410, {})
				nPos := Len(aRegM410)
				aAdd (aRegM410[nPos], nPosM400)                    	        //Relacao com M400
				aAdd (aRegM410[nPos], "M410")			   	   	 			//01 - REG
				aAdd (aRegM410[nPos], CCZ->CCZ_COD)							//02 - NAT_REC
				aAdd (aRegM410[nPos], nValCont)		  						//03 - VL_REC
				aAdd (aRegM410[nPos], Reg0500(@aReg0500,cConta,,cAliasSFT)) //04 - COD_CTA
				aAdd (aRegM410[nPos], CCZ->CCZ_DESC)						//05 - DESC_COMPL
			Else
				aRegM410[nPosM410][4]+= nValCont   		//03 - VL_TOT_REC
			EndIf
		EndIF

	EndIF
EndIF

Return

/*±±ºPrograma  RegM800   ºAutor  Erick G. Dias       º Data   01/03/11 º±±
±±ºDesc.      Processamento dos registro M800 e M810.                     º±±*/
static Function RegM800(aRegM800,aRegM810,cAliasSFT,aReg0500, aRegF100,cAliasSB1,cAliasCF8,aParD600,aPar,nReceita)

local nPos			:= 0
local nPosM800		:= 0
local nPosM810		:= 0
Local lExisteCCZ	:= aIndics[05]
local lAchouCCZ		:= .F.
Local lExtCpoCCZ	:= lCmpNRecB1
Local cCstCof		:= ""
Local nValCont		:= 0
Local cConta		:= ""
Local cDtFimNt		:= ""
Local lSemNota		:= .F.
Local lCF8			:= .F.
Local lParD600		:= .F.
Local lPar			:= .F.

Default cAliasSFT	:= ""
Default aRegF100	:={}
Default aReg0500	:={}
Default cAliasSB1	:= "SB1"
Default cAliasCF8	:= ""
Default aParD600	:= {}
Default aPar		:= {}
Default nReceita	:= 0

IF lGrBlocoM
	If Len(aRegF100) > 0 //No possui nota fisca
		lSemNota	:= .T.
	EndIF

	If Len(cAliasCF8) > 0
		lCF8	:= .T.
	EndIF

	If Len(aParD600) > 0
		lParD600	:= .T.
	EndIF

	If Len(aPar) > 0
		lPar	:= .T.
	EndIF

	If lPar
		cCstCOf		:=  aPar[1]
		nValCont	:=  aPar[2]
		cConta		:=	aPar[3]
		If Valtype(aPar[7]) == "D"
			cDtFimNt	:=	DTOS(aPar[7])
		Else
			cDtFimNt	:=	aPar[7]
		Endif
	ElseIf lParD600 //Informaµes com origem em notas de telecomunicao que no possuem livros fiscal, pois servio no foi faturado, por©m deve entrar como receita tribut¡vel de PIS/COFINS.
		cCstCOf		:=  aParD600[1]
		nValCont	:=  aParD600[4]
		cConta		:=	aParD600[10]
		If Valtype(aParD600[9]) == "D"
			cDtFimNt	:=	DTOS(aParD600[9])
		Else
			cDtFimNt	:=	aParD600[9]
		Endif

	ElseIf lSemNota //No possui nota fisca
		cCstCof		:=aRegF100[7]
		nValCont	:=aRegF100[2]
	ElseIf lCF8
		cCstCof		:=(cAliasCF8)->CF8_CSTCOF
		nValCont	:=(cAliasCF8)->CF8_VLOPER
	Else
		cCstCof		:=	(cAliasSFT)->FT_CSTCOF
		nValCont	:=	Iif(nReceita>0,nReceita,(cAliasSFT)->FT_TOTAL)
		cConta		:=	(cAliasSFT)->FT_CONTA

		If Valtype((cAliasSFT)->FT_DTFIMNT) == "D"
			cDtFimNt	:=	DTOS((cAliasSFT)->FT_DTFIMNT)
		Else
			cDtFimNt	:=	(cAliasSFT)->FT_DTFIMNT
		Endif
	EndIF

	If lPar
		If CCZ->(MsSeek(xFilial("CCZ")+ aPar[4] + aPar[5] + aPar[6]  + cDtFimNt))
			lAchouCCZ := .T.
		EndIF
	ElseIf lParD600
		If CCZ->(MsSeek(xFilial("CCZ")+ aParD600[6] + aParD600[7] + aParD600[8]  + cDtFimNt))
			lAchouCCZ := .T.
		EndIF
	ElseIf lCF8
    	If !Empty((cAliasCF8)->CF8_ITEM) .And. CCZ->(MsSeek(xFilial("CCZ")+SB1->B1_TNATREC+SB1->B1_CNATREC+SB1->B1_GRPNATR+DToS(SB1->B1_DTFIMNT)))
			lAchouCCZ := .T.
		Elseif aFieldPos[39] .And. !Empty((cAliasCF8)->CF8_TNATRE) .And. CCZ->(MsSeek(xFilial("CCZ")+(cAliasCF8)->CF8_TNATRE+(cAliasCF8)->CF8_CNATRE+(cAliasCF8)->CF8_GRPNC+DTOS((cAliasCF8)->CF8_DTFIMN)))
			lAchouCCZ := .T.
		EndIF
	ElseIf lExisteCCZ .AND. lExtCpoCCZ .AND. !lSemNota
		If CCZ->(MsSeek(xFilial("CCZ")+ (cAliasSFT)->FT_TNATREC + (cAliasSFT)->FT_CNATREC + (cAliasSFT)->FT_GRUPONC  + cDtFimNt))
			lAchouCCZ := .T.
		ElseIf CCZ->(MsSeek(xFilial("CCZ")+ SB1->B1_TNATREC + SB1->B1_CNATREC + SB1->B1_GRPNATR  + DToS(SB1->B1_DTFIMNT) ))
			lAchouCCZ := .T.
		ElseIf lCmpNRecF4 .And. CCZ->(MsSeek(xFilial("CCZ")+ SF4->F4_TNATREC + SF4->F4_CNATREC + SF4->F4_GRPNATR  + DToS(SF4->F4_DTFIMNT) ))
			lAchouCCZ := .T.
		EndIf
	ElseIF lSemNota
		If CCZ->(MsSeek(xFilial("CCZ")+ aRegF100[18] + aRegF100[19] + aRegF100[20] + IiF(" /" $ aRegF100[21],"",aRegF100[21]))	)
			lAchouCCZ := .T.
		EndIF
	ElseIf lExisteCCZ
		If CCZ->(MsSeek(xFilial("CCZ")+ SB1->B1_TNATREC + SB1->B1_CNATREC ))
			lAchouCCZ := .T.
		ElseIf lCmpNRecF4 .And. CCZ->(MsSeek(xFilial("CCZ")+ SF4->F4_TNATREC + SF4->F4_CNATREC))
			lAchouCCZ := .T.
		EndIf
	EndIF


	nPosM800 := aScan (aRegM800, {|aX| aX[2]==cCstCof })
	If nPosM800 == 0
		aAdd(aRegM800, {})
		nPos := Len(aRegM800)
		aAdd (aRegM800[nPos], "M800")			   	   			//01 - REG
		aAdd (aRegM800[nPos], cCstCof)			//02 - CST_PIS
		aAdd (aRegM800[nPos], nValCont)			//03 - VL_TOT_REC
		aAdd (aRegM800[nPos], Reg0500(@aReg0500,cConta,,cAliasSFT))		//04 - COD_CTA
		If lAchouCCZ
			aAdd (aRegM800[nPos], CCZ->CCZ_DESC )				//05 - DESC_COMPL
		Else
			aAdd (aRegM800[nPos], "" )							//05 - DESC_COMPL
		EndIF

		If lAchouCCZ
			aAdd (aRegM810, {})
			nPos := Len(aRegM810)
			aAdd (aRegM810[nPos], Len(aRegM800))                   //Relacao com M400
			aAdd (aRegM810[nPos], "M810")			   	   			//01 - REG
			aAdd (aRegM810[nPos], CCZ->CCZ_COD)						//02 - NAT_REC
			aAdd (aRegM810[nPos], nValCont)			//03 - VL_REC
			aAdd (aRegM810[nPos], Reg0500(@aReg0500,cConta,,cAliasSFT))	//04 - COD_CTA
			aAdd (aRegM810[nPos], CCZ->CCZ_DESC)					//05 - DESC_COMPL
		EndIf
	Else
		aRegM800[nPosM800][3]+= nValCont   			//03 - VL_TOT_REC

		IF lAchouCCZ
			nPosM810 := aScan (aRegM810, {|aX| aX[3]==CCZ->CCZ_COD  .AND. ax[1] == nPosM800})
			If nPosM810 == 0
				aAdd (aRegM810, {})
				nPos := Len(aRegM810)
				aAdd (aRegM810[nPos], nPosM800)                         //Relacao com M400
				aAdd (aRegM810[nPos], "M810")			   	   			//01 - REG
				aAdd (aRegM810[nPos], CCZ->CCZ_COD)						//02 - NAT_REC
				aAdd (aRegM810[nPos], nValCont)			//03 - VL_REC
				aAdd (aRegM810[nPos], Reg0500(@aReg0500,cConta,,cAliasSFT))//04 - COD_CTA
				aAdd (aRegM810[nPos], CCZ->CCZ_DESC)					//05 - DESC_COMPL
			Else
				aRegM810[nPosM810][4]+= nValCont  		//03 - VL_TOT_REC
			EndIf
		EndIF

	EndIF
EndIF

Return

/*±±ºPrograma  Reg0111   ºAutor  Erick G. Dias       º Data   04/03/11 º±±
±±ºDesc.      Processamento dos registro 0111.                           º±±
±±Parametros aReg0111 -> Array com valores do registro 0111.            ±±
±±           aValor   -> Array com valores da receita bruta do per­odo. ±±
±±           cRegime  -> Indica qual o regime informado na Wizard.      ±±*/
static Function Reg0111(aReg0111,aValor,cRegime,lExtTaf)

Local 	nPos			:= 0
Local   nTMI			:= 0  //Receita tributada no mercado interno
Local   nNTMI			:= 0  //Receita Nao tributada no mercado interno
Local   nRecExp			:= 0  //Receita bruta  - exportacao
Local   nRecCum			:= 0  //Receita bruta cumulativa
Local   nRecTot			:= 0  //Receita bruta total

Default lExtTaf         := .F.

nTMI	:= aValor[1]
nNTMI	:= aValor[2]
nRecExp := aValor[3]

If !cRegime  == "1" // somente acumula se for nao cumulativo e cumulatico, exclusicamente nao cumulativo nao soma este campo
	nRecCum := aValor[4]
EndIf

nRecTot :=nTMI + nNTMI + nRecExp + nRecCum

aAdd (aReg0111, {})
nPos := Len(aReg0111)
aAdd (aReg0111[nPos], Iif( !lExtTaf, "0111", "T001AH") )	//01 - REG

If lExtTaf
	aAdd (aReg0111[nPos], "" )
EndIf

aAdd (aReg0111[nPos], nTMI)							//02 - REC_BRU_NCUM_TRIB_MI
aAdd (aReg0111[nPos], nNTMI)						//03 - REC_BRU_ NCUM_NT_MI
aAdd (aReg0111[nPos], nRecExp)						//04 - REC_BRU_ NCUM_EXP
aAdd (aReg0111[nPos], nRecCum)						//05 - REC_BRU_CUM
aAdd (aReg0111[nPos], nRecTot)						//06 - REC_BRU_TOTAL

Return

/*±±ºPrograma  CSTREC    ºAutor  Erick G. Dias       º Data   04/03/11 º±±
±±ºDesc.      Retorna codigo da tabela 4.3.6.                            º±±
±±Parametros cIndCont -> Indica o tipo de aliquota(basica/diferenciada).±±
±±           cAlqUni -> Aliquota Unidade de Produto.				      ±±
±±           lImport -> Indica tratamento de Importacao.		      	  ±±
±±           nCont   -> Contador do tipo de receita.				      ±±
±±           cCst    -> Indica qual o CST da operacao.				  ±±
±±           cCodBcc -> Cdigo da base do c¡lculo de cr©dito.           ±±
±±           lAgrIndust -> Operao AgroIndustria			           ±±*/
static Function CSTREC(cIndCont,cAlqUni,lImport,nCont,cCst, cCodBcc,lAgrIndust)

Local 	cRetorno 	:= ""
DEFAULT cCodBcc		:= ""

If cCst $ "53|63"
	cRetorno:= Iif(nCont == 1,"1","2")
ElseIf cCst $ "54|64"
	cRetorno:= Iif(nCont == 1,"1","3")
ElseIf cCst $ "55|65"
	cRetorno:= Iif(nCont == 1,"2","3")
ElseIf cCst $ "56|66"
	If nCont == 1
		cRetorno:= "1"
	ElseIf nCont == 2
		cRetorno:= "2"
	ElseIf nCont == 3
		cRetorno:= "3"
	EndIf
EndIf

//Cdigo da base de c¡lculo 18, que trata estoque de abertura.
IF cCodBcc	== "18"
	cRetorno	+=	"04"
//CST de Credito Presumido				
ElseIf cCst $ "60|61|62|63|64|65|66"
	If lAgrIndust
		cRetorno	+=	"06"
	Else
		cRetorno	+=	"07"
	EndIf
//Valor por unidade de produto
Elseif Val( cValToChar(cAlqUni)) > 0
	cRetorno 	+=	"03"
//Aliquota basica
ElseIf cIndCont == "1"
	cRetorno 	+=	Iif(lImport,"08","01")

//Aliquota diferenciada
Else
	cRetorno 	+=	Iif(lImport,"08","02")
EndIf

Return (cRetorno)


static Function BasePisCof(nGrupo,aReg0111,cCST,nBcPis)

Local aPercent  := aParSX6[36]
Local nBaseRat  :=0
Local lApropDir	:= aParSX6[14]

aPercent   := Iif (Len(aPercent) > 1,&(aPercent),aPercent)

If cCST $ "53/63"
	If nGrupo == 1
		IF !lApropDir
			nBaseRat := nBcPis *aReg0111[1][2] /(aReg0111[1][2] + aReg0111[1][3])
		Else
			nBaseRat := nBcPis * (((aPercent[1] * 100) /( aPercent[1] + aPercent[2]))	/100)
		EndIf
	Else
		IF !lApropDir
			nBaseRat := nBcPis * aReg0111[1][3] / (aReg0111[1][2] + aReg0111[1][3])
		Else
			nBaseRat := nBcPis * (((aPercent[2] * 100) /( aPercent[1] + aPercent[2]))	/100)
		EndIf
	EndIf
ElseIf cCST $ "54/64"
	If nGrupo == 1
		IF !lApropDir
			nBaseRat := nBcPis * aReg0111[1][2] /(aReg0111[1][2] + aReg0111[1][4])
		Else
			nBaseRat := nBcPis * (((aPercent[1] * 100) /( aPercent[1] + aPercent[3]))	/100)
		EndIF
	Else
		IF !lApropDir
			nBaseRat := nBcPis * aReg0111[1][4] / (aReg0111[1][2] + aReg0111[1][4])
		Else
			nBaseRat := nBcPis * (((aPercent[3] * 100) /( aPercent[1] + aPercent[3]))	/100)
		EndIF
	EndIf
ElseIf cCST $ "55/65"
	If nGrupo == 1
		IF !lApropDir
			nBaseRat := nBcPis * aReg0111[1][3] /(aReg0111[1][3] + aReg0111[1][4])
		Else
			nBaseRat := nBcPis * (((aPercent[2] * 100) /( aPercent[2] + aPercent[3]))	/100)
		EndIf
	Else
		IF !lApropDir
			nBaseRat := nBcPis * aReg0111[1][4] / (aReg0111[1][3] + aReg0111[1][4])
		Else
			nBaseRat := nBcPis * (((aPercent[3] * 100) /( aPercent[2] + aPercent[3]))	/100)
		EndIF
	EndIf
ElseIf cCST $ "56/66"
	If nGrupo == 1
		IF !lApropDir
			nBaseRat := nBcPis * aReg0111[1][2] /(aReg0111[1][2] + aReg0111[1][3] + aReg0111[1][4])
		Else
			nBaseRat := nBcPis * (aPercent[1] /100)
		EndIF
	Elseif nGrupo == 2
		IF !lApropDir
			nBaseRat := nBcPis * aReg0111[1][3] / (aReg0111[1][2] + aReg0111[1][3] + aReg0111[1][4])
		Else
			nBaseRat := nBcPis * (aPercent[3] /100)
		EndIF
	Else
		IF !lApropDir
			nBaseRat := nBcPis * aReg0111[1][4] / (aReg0111[1][2] + aReg0111[1][3] + aReg0111[1][4])
		Else
			nBaseRat := nBcPis * (aPercent[3] /100)
		EndIF
	EndIf
EndIF

Return (nBaseRat)

/*±±ºPrograma  Reg1010   ºAutor  Erick G. Dias       º Data   07/03/11 º±±
±±ºDesc.      Processamento dos registro 1010.                            º±±*/
static Function Reg1010(aReg1010,a1010PE,cAliasCCF)

Local 	nPos := 0
Local	cNum		:= ""
Local	cIdSeJu		:= ""
Local	cIdVara		:= ""
Local	cNatJu		:= ""
Local	cDescJu		:= ""
Local	dDtSent		:= CToD ("//")
Default a1010PE 	:= {}
Default cAliasCCF	:= ""

IF len(cAliasCCF) == 0
	cNum		:= CCF->CCF_NUMERO
	cIdSeJu		:= CCF->CCF_IDSEJU
	cIdVara		:= CCF->CCF_IDVARA
	cNatJu		:= CCF->CCF_NATJU
	cDescJu		:= CCF->CCF_DESCJU
	dDtSent		:= CCF->CCF_DTSENT
Else
	cNum		:= (cAliasCCF)->CCF_NUMERO
	cIdSeJu		:= (cAliasCCF)->CCF_IDSEJU
	cIdVara		:= (cAliasCCF)->CCF_IDVARA
	cNatJu		:= (cAliasCCF)->CCF_NATJU
	cDescJu		:= (cAliasCCF)->CCF_DESCJU
	dDtSent		:= (cAliasCCF)->CCF_DTSENT
EndIF


If !Empty(a1010PE)

	If (nPos := aScan (aReg1010, {|aX| aX[2]==a1010PE[2] .AND. aX[3]==a1010PE[3]  .AND. aX[4]==a1010PE[4]  .AND. aX[5]==a1010PE[5] .AND. aX[7]==a1010PE[7]})==0)
   		aAdd (aReg1010, {})
		nPos := Len(aReg1010)
   		aReg1010[nPos] := aClone(a1010PE)
	EndIf

Else

	If (nPos := aScan (aReg1010, {|aX| aX[2]==cNum .AND. aX[3]==cIdSeJu  .AND. aX[4]==cIdVara  .AND. aX[5]==cNatJu .AND. aX[7]==dDtSent})==0)

		aAdd (aReg1010, {})
		nPos := Len(aReg1010)
		aAdd (aReg1010[nPos], "1010")			   	   			//01 - REG
		aAdd (aReg1010[nPos], cNum)					//02 - NUM_PROC
		aAdd (aReg1010[nPos], cIdSeJu)					//03 - IND_SEC_JUD
		aAdd (aReg1010[nPos], cIdVara)					//04 - IND_VARA
		aAdd (aReg1010[nPos], cNatJu)					//05 - IND_NAT_ACAO
		aAdd (aReg1010[nPos], cDescJu)					//06 - DESC_DEC_JUD
		aAdd (aReg1010[nPos], dDtSent)   	            //07 - DT_SENT_JUD

	EndIf
EndIf

Return

/*±±ºPrograma  Reg1020   ºAutor  Erick G. Dias       º Data   07/03/11   º±±
±±ºDesc.      Processamento dos registro 1020.                            º±±*/
static Function Reg1020(aReg1020,a1020PE,cAliasCCF)

Local nPos := 0
Local	cNum		:= ""
Local	cNatAC		:= ""
Local	dDtAdm		:= CToD ("//")
Default a1020PE		:= {}
Default cAliasCCF	:= ""

IF len(cAliasCCF) == 0
	cNum		:= CCF->CCF_NUMERO
	cNatAC		:= CCF->CCF_NATAC
	dDtAdm		:= CCF->CCF_DTADM
Else
	cNum		:= (cAliasCCF)->CCF_NUMERO
	cNatAC		:= (cAliasCCF)->CCF_NATAC
	dDtAdm		:= (cAliasCCF)->CCF_DTADM
EndIF

If !Empty(a1020PE)
	If (nPos := aScan (aReg1020, {|aX| aX[2]==a1020PE[2] .AND. aX[3]==a1020PE[3] .AND. aX[4]==a1020PE[4]})==0)
   		aAdd (aReg1020, {})
		nPos := Len(aReg1020)
   		aReg1020[nPos] := aClone(a1020PE)
	EndIf
Else

	If (nPos := aScan (aReg1020, {|aX| aX[2]==cNum .AND. aX[3]==cNatAC .AND. aX[4]==dDtAdm})==0)

		aAdd (aReg1020, {})
		nPos := Len(aReg1020)
		aAdd (aReg1020[nPos], "1020")			   	//01 - REG
		aAdd (aReg1020[nPos], cNum)					//02 - NUM_PROC
		aAdd (aReg1020[nPos], cNatAC)				//03 - IND_NAT_ACAO
		aAdd (aReg1020[nPos], dDtAdm)     	        //04 - DT_DEC_ADM

	EndIf

EndIf

Return

/*±±ºPrograma  RegA120   ºAutor  Erick G. Dias       º Data   11/03/11 º±±
±±ºDesc.      Processamento dos registro A120.                            º±±
±±º           Informao Complementar de Importao.                      º±±
±±Parametros aRegA120  -> Array com valores do registro A120.           ±±
±±           cAliasSFT -> Alias da tabela SFT.                          ±±
±±           cAliasCD5 -> Alias da tabela CD5.                          ±±*/
static Function RegA120(aRegA120,cAliasSFT,cAliasCD5,cChave)
Local	nPos		:=	0
Local	lDTPPIS		:=	aFieldPos[40]
Local	lDTPCOF		:=	aFieldPos[41]
Local	lLOCAL		:=	aFieldPos[42]
Local 	cFilCD5		:= xFilial(cAliasCD5)
Local 	cChvWhl		:= cFilCD5+(cAliasCD5)->(CD5_DOC+CD5_SERIE+CD5_FORNEC+CD5_LOJA)

Default cChave		:= ""

While !(cAliasCD5)->(Eof()) .AND. (cChvWhl==cChave)

	If (cAliasSFT)->FT_ITEM <> (cAliasCD5)->CD5_ITEM

		(cAliasCD5)->(DbSkip())
		cChvWhl		:= cFilCD5+(cAliasCD5)->(CD5_DOC+CD5_SERIE+CD5_FORNEC+CD5_LOJA)
		Loop
	Else
		aAdd(aRegA120, {})
		nPos := Len(aRegA120)
		aAdd (aRegA120[nPos], "A120")						   				//01 - REG
		aAdd (aRegA120[nPos], (cAliasSFT)->FT_VALICM)				   		//02 - VL_TOT_SERV
		aAdd (aRegA120[nPos], (cAliasCD5)->CD5_BSPIS)						//03 - VL_BC_PIS
		aAdd (aRegA120[nPos], (cAliasCD5)->CD5_VLPIS)						//04 - VL_PISIMP

		If lDTPPIS
			aAdd (aRegA120[nPos], (cAliasCD5)->CD5_DTPPIS)					//05 - DT_PAG_PIS
		Else
			aAdd (aRegA120[nPos], "")						   	   			//05 - DT_PAG_PIS
		EndIf

		aAdd (aRegA120[nPos], (cAliasCD5)->CD5_BSCOF)						//06 - VL_BC_CONFINS
		aAdd (aRegA120[nPos], (cAliasCD5)->CD5_VLCOF)						//07 - VL_COFINS_IMP

		If lDTPCOF
			aAdd (aRegA120[nPos], (cAliasCD5)->CD5_DTPCOF)					//08 - DT_PAG_COFINS
		Else
			aAdd (aRegA120[nPos], "")						   				//08 - DT_PAG_COFINS
		EndIF

		If lLOCAL
			aAdd (aRegA120[nPos], (cAliasCD5)->CD5_LOCAL)					//09 - LOC_EXE_SERV
		Else
			aAdd (aRegA120[nPos], "")						   				//09 - LOC_EXE_SERV
		Endif

	Endif

	Exit
End

Return
/*±±ºPrograma  Reg1100   ºAutor  Erick G. Dias       º Data   12/03/11 º±±
±±ºDesc.      Processamento dos registro 1100.                            º±±*/

static Function Reg1100(aReg1100,cPer,cCnpj,cCodCred,nValCred,nValDesc,nTotContrb,nCredUti,cPerAtu,lMesAtual,nCredExt,nPosExt,cRefer,nRessar,nComp,nRessaAnt,nCompAnt,cOriCre,cReserPis)

Local nPos			:= 0
Local nPos1100  	:= 0
Local nTotCpo8		:= 0
Local nTotCpo12		:= 0
Local nTotCpo13		:= 0
Local nTotCpo18		:= 0
Local cMV_BCCR	:= aParSX6[37]
Local cMV_BCCC	:= aParSX6[38]
Local nCpo14		:= 0
Local nCpo15		:= 0
Local nCrdMesAtu	:= 0
Local nCrdMesAnt	:= 0

DEFAULT lMesAtual	:= .F.
DEFAULT nValCred	:= 0
DEFAULT nCredExt	:= 0
DEFAULT nPosExt		:= 0
DEFAULT cRefer		:= ""
DEFAULT nRessar		:= 0
DEFAULT nComp		:= 0
DEFAULT nRessaAnt	:= 0
DEFAULT nCompAnt	:= 0
DEFAULT cOriCre		:= "01"
DEFAULT cReserPis	:= ""

If Empty(cRefer)
   cRefer := cPer
EndIf

If lMesAtual
	nCrdMesAtu	:= nValDesc
Else
	nCrdMesAnt	:= nValDesc
EndIF


If Len(Trim(cOriCre)) == 0
   cOriCre		:= "01"
EndIf


If nValCred > 0 .Or. nCredExt > 0
	nPos1100 := aScan (aReg1100, {|aX| aX[2]==cRefer .AND. ax[3] == cOriCre  .AND. ax[4] == cCnpj .AND. ax[5] == cCodCred})
	nPosExt := nPos1100
	If nPos1100 ==0
		aAdd(aReg1100, {})
		nPos := Len(aReg1100)
		nPosExt := nPos
   		aAdd (aReg1100[nPos], "1100")						   	//01 - REG
		aAdd (aReg1100[nPos], cRefer)				   				//02 - PER_APU_CRED
		aAdd (aReg1100[nPos], cOriCre)						   		//03 - ORIG_CRED
		aAdd (aReg1100[nPos], cCnpj)						   	//04 - CNPJ_SUC
		aAdd (aReg1100[nPos], cCodCred)						   	//05 - COD_CRED
		aAdd (aReg1100[nPos], nValCred)					   		//06 - VL_CRED_APU
		aAdd (aReg1100[nPos], nCredExt)						   	//07 - VL_CRED_EXT_APU
		nTotCpo8 :=nValCred+nCredExt
		aAdd (aReg1100[nPos], nTotCpo8)					   		//08 - VL_TOT_CRED_APU
		aAdd (aReg1100[nPos], nCrdMesAnt)					   		//09 - VL_CRED_DESC_PA_ANT
		aAdd (aReg1100[nPos], Iif(cCodCred$cMV_BCCR,nRessaAnt,""))		//10 - VL_CRED_PER_PA_ANT
		aAdd (aReg1100[nPos], Iif(cCodCred$cMV_BCCC,nCompAnt,""))		//11 - VL_CRED_DCOMP_PA_ANT
		nTotCpo12:= nTotCpo8 - nCrdMesAnt - nRessaAnt - nCompAnt
		aAdd (aReg1100[nPos], nTotCpo12)				   		//12 - SD_CRED_DISP_EFD

		//Se estiver reservado, o credito no ser¡ apropriado 
		If !cReserPis$"1"
			If nTotContrb > 0 .AND. !lMesAtual
				//If nCredUti < nTotContrb
					If  nTotCpo12   <= nTotContrb // Total de credito do mes anterior for menor que a contribuio deste mes, utiliza o credito
						nTotCpo13 :=nTotCpo12	 //Utiliza todo o credito
						nCredUti += nTotCpo13
						nTotContrb -= nTotCpo13
					Else
						nTotCpo13 := nTotCpo12 - nTotContrb
						nTotCpo13 := nTotCpo12 - nTotCpo13
						nCredUti += nTotCpo13
						nTotContrb := 0
					EndIf
	  			//EndIf
				//nCredUti += nTotCpo13
			ElseIF lMesAtual
				nTotCpo13 := nCrdMesAtu
			EndIF 
		Else
			nTotCpo13 := nCrdMesAtu 
		EndIf

		aAdd (aReg1100[nPos], nTotCpo13)						 //13 - VL_CRED_DESC_EFD
		nTotCpo18 := nTotCpo12 - nTotCpo13

		If (nRessar+nComp) <= nTotCpo18
			nTotCpo18 -= (nRessar+nComp)
			nCpo14		:= nRessar
			nCpo15		:= nComp
		Else
			nCpo14		:= 0
			nCpo15		:= 0
		EndIf

		aAdd (aReg1100[nPos], nCpo14)					   		//14 - VL_CRED_PER_EFD
		aAdd (aReg1100[nPos], nCpo15)					   		//15 - VL_CRED_DCOMP_EFD
		aAdd (aReg1100[nPos], 0)						   		//16 - VL_CRED_TRANS
		aAdd (aReg1100[nPos], 0)						   		//17 - VL_CRED_OUT
		aAdd (aReg1100[nPos], nTotCpo18)						//18 - SLD_CRED_FIM

		If nTotCpo18 > 0 .AND. !lMesAtual
			CredFutPIS(cPerAtu,cCodCred, nValCred, nTotCpo13,nTotCpo18,nCredExt,cRefer,nValDesc,nCpo14,nCpo15,nRessaAnt,nCompAnt,aReg1100[nPos][3],aReg1100[nPos][4],cReserPis)
		EndIF
	Else
	    If !lMesAtual
			aReg1100[nPos1100][6]	+= nValCred				   		//06 - VL_CRED_APU
			aReg1100[nPos1100][7]	+= nCredExt					   	//07 - VL_CRED_EXT_APU
			nTotCpo8 :=nValCred+nCredExt
			aReg1100[nPos1100][8]	+= nTotCpo8				   		//08 - VL_TOT_CRED_APU
			aReg1100[nPos1100][9]	+= nCrdMesAnt				   		//09 - VL_CRED_DESC_PA_ANT
			aReg1100[nPos1100][10]	+= Iif(cCodCred$cMV_BCCR,nRessaAnt,"")		//10 - VL_CRED_PER_PA_ANT
			aReg1100[nPos1100][11]	+= Iif(cCodCred$cMV_BCCC,nCompAnt,"")		//11 - VL_CRED_DCOMP_PA_ANT
			nTotCpo12:= nTotCpo8 - nCrdMesAnt - nRessaAnt - nCompAnt
			aReg1100[nPos1100][12]	+= nTotCpo12			   		//12 - SD_CRED_DISP_EFD
			
			//Se estiver reservado, o credito no ser¡ apropriado 
			If !cReserPis$"1"
				If nTotContrb > 0 .AND. !lMesAtual
	//				If nCredUti < nTotContrb
						If  nTotCpo12 <= nTotContrb // Total de credito do mes anterior for menor que a contribuio deste mes, utiliza o credito
							nTotCpo13 :=nTotCpo12	 //Utiliza todo o credito
							nCredUti += nTotCpo13
							nTotContrb -= nTotCpo13
						Else
							nTotCpo13 := nTotCpo12 - nTotContrb
							nTotCpo13 := nTotCpo12 - nTotCpo13
							nCredUti += nTotCpo13
							nTotContrb := 0
						EndIf
	//				EndIF
				ElseIF lMesAtual
					nTotCpo13 := nCrdMesAtu
				EndIF
			Else
				nTotCpo13 := nCrdMesAtu
			EndIf
			aReg1100[nPos1100][13] += nTotCpo13						//13 - VL_CRED_DESC_EFD
			nTotCpo18 := nTotCpo12 - nTotCpo13

			If (nRessar+nComp) <= nTotCpo18
				nTotCpo18 -= (nRessar+nComp)
				nCpo14		:= nRessar
				nCpo15		:= nComp
			Else
				nCpo14		:= 0
				nCpo15		:= 0
			EndIf


			aReg1100[nPos1100][14] += nCpo14				   		//14 - VL_CRED_PER_EFD
			aReg1100[nPos1100][15] += nCpo15				   		//15 - VL_CRED_DCOMP_EFD
			aReg1100[nPos1100][16] += 0						   		//16 - VL_CRED_TRANS
			aReg1100[nPos1100][17] += 0						   		//17 - VL_CRED_OUT

			aReg1100[nPos1100][18] += nTotCpo18
			If nTotCpo18 > 0 .AND. !lMesAtual
				CredFutPIS(cPerAtu,cCodCred,nValCred,aReg1100[nPos1100][13],aReg1100[nPos1100][18],aReg1100[nPos1100][7],cRefer,nValDesc,nCpo14,nCpo15,nRessaAnt,nCompAnt,aReg1100[nPos1100][3],aReg1100[nPos1100][4],cReserPis)
			EndIF
		EndIf
	EndIF

EndIF

Return()

/*±±ºPrograma  Reg1500   ºAutor  Erick G. Dias       º Data   12/03/11 º±±
±±ºDesc.      Processamento dos registro A120.                            º±±*/

static Function Reg1500(aReg1500,cPer,cCnpj,cCodCred,nValCred,nValDesc,nTotContrb,nCredUti,cPerAtu,lMesAtual,nCredExt,nPosExt,cRefer,nRessar,nComp,nRessaAnt,nCompAnt,cOriCre,cReserCof)

Local nPos			:= 0
Local nPos1500  	:= 0
Local nTotCpo8		:= 0
Local nTotCpo12		:= 0
Local nTotCpo13		:= 0
Local nTotCpo18		:= 0
Local cMV_BCCR	:= aParSX6[37]
Local cMV_BCCC	:= aParSX6[38]
Local nCpo14		:= 0
Local nCpo15		:= 0
Local nCrdMesAtu	:= 0
Local nCrdMesAnt	:= 0

DEFAULT lMesAtual	:= .F.
DEFAULT nValCred	:= 0
DEFAULT nCredExt	:= 0
DEFAULT nPosExt		:= 0
DEFAULT cRefer		:= ""
DEFAULT nRessar		:= 0
DEFAULT nComp		:= 0
DEFAULT nRessaAnt	:= 0
DEFAULT nCompAnt	:= 0
DEFAULT cOriCre		:= "01"
DEFAULT cReserCof	:= ""

If Empty(cRefer)
   cRefer := cPer
EndIf

If lMesAtual
	nCrdMesAtu	:= nValDesc
Else
	nCrdMesAnt	:= nValDesc
EndIF

If nValCred > 0 .Or. nCredExt > 0
	nPos1500 := aScan (aReg1500, {|aX| aX[2]==cRefer .AND. ax[3] == cOriCre .AND. ax[4] == cCnpj .AND. ax[5] == cCodCred})
	nPosExt	 := nPos1500
	IF nPos1500 ==0
		aAdd(aReg1500, {})
		nPos := Len(aReg1500)
		nPosExt := nPos
		aAdd (aReg1500[nPos], "1500")						   	//01 - REG
		aAdd (aReg1500[nPos], cRefer)			   				//02 - PER_APU_CRED
		aAdd (aReg1500[nPos], cOriCre)						    //03 - ORIG_CRED
		aAdd (aReg1500[nPos], cCnpj)						   	//04 - CNPJ_SUC
		aAdd (aReg1500[nPos], cCodCred)						   	//05 - COD_CRED
		aAdd (aReg1500[nPos], nValCred)					   		//06 - VL_CRED_APU
		aAdd (aReg1500[nPos], nCredExt)						   	//07 - VL_CRED_EXT_APU
		nTotCpo8 :=nValCred+nCredExt
		aAdd (aReg1500[nPos], nTotCpo8)					   		//08 - VL_TOT_CRED_APU
		aAdd (aReg1500[nPos], nCrdMesAnt)					   		//09 - VL_CRED_DESC_PA_ANT
		aAdd (aReg1500[nPos], Iif(cCodCred$cMV_BCCR,nRessaAnt,""))	//10 - VL_CRED_PER_PA_ANT
		aAdd (aReg1500[nPos], Iif(cCodCred$cMV_BCCC,nCompAnt,""))	//11 - VL_CRED_DCOMP_PA_ANT
		nTotCpo12:= nTotCpo8 - nCrdMesAnt - nRessaAnt - nCompAnt
		aAdd (aReg1500[nPos], nTotCpo12)				   		//12 - SD_CRED_DISP_EFD

		//Se estiver reservado, o credito no ser¡ apropriado 
		If !cReserCof$"1"
			If nTotContrb > 0  .AND. !lMesAtual
	//			IF nCredUti < nTotContrb
					If  nTotCpo12  <= nTotContrb // Total de credito do mes anterior for menor que a contribuio deste mes, utiliza o credito
						nTotCpo13 :=nTotCpo12	 //Utiliza todo o credito
						nCredUti += nTotCpo13
						nTotContrb -= nTotCpo13
					Else
						nTotCpo13 := nTotCpo12 - nTotContrb
						nTotCpo13 := nTotCpo12 - nTotCpo13
						nCredUti += nTotCpo13
						nTotContrb := 0
					EndIf
	//			EndIF
			ElseIF lMesAtual
				nTotCpo13 :=nCrdMesAtu
			EndIF
		Else
			nTotCpo13 :=nCrdMesAtu
		EndIf

		aAdd (aReg1500[nPos], nTotCpo13)						 //13 - VL_CRED_DESC_EFD
        nTotCpo18 := nTotCpo12 - nTotCpo13

		If (nRessar+nComp) <= nTotCpo18
			nTotCpo18 -= (nRessar+nComp)
			nCpo14		:= nRessar
			nCpo15		:= nComp
		Else
			nCpo14		:= 0
			nCpo15		:= 0
		EndIf

		aAdd (aReg1500[nPos], nCpo14)						   		//14 - VL_CRED_PER_EFD
		aAdd (aReg1500[nPos], nCpo15)						   		//15 - VL_CRED_DCOMP_EFD
		aAdd (aReg1500[nPos], 0)						   		//16 - VL_CRED_TRANS
		aAdd (aReg1500[nPos], 0)						   		//17 - VL_CRED_OUT

		aAdd (aReg1500[nPos], nTotCpo18)						//18 - SLD_CRED_FIM
		If nTotCpo18 > 0 .AND. !lMesAtual
			CredFutCof(cPerAtu,cCodCred, nValCred, nTotCpo13,nTotCpo18,nCredExt,cRefer,nValDesc,nCpo14,nCpo15,nRessaAnt,nCompAnt,aReg1500[nPos][3],aReg1500[nPos][4],cReserCof)
		EndIF
	Else
		If !lMesAtual
			aReg1500[nPos1500][6]	+= nValCred				   		//06 - VL_CRED_APU
			aReg1500[nPos1500][7]	+= nCredExt					   	//07 - VL_CRED_EXT_APU
			nTotCpo8 :=nValCred+nCredExt
			aReg1500[nPos1500][8]	+= nTotCpo8				   		//08 - VL_TOT_CRED_APU
			aReg1500[nPos1500][9]	+= nCrdMesAnt				   		//09 - VL_CRED_DESC_PA_ANT
			aReg1500[nPos1500][10]	+= Iif(cCodCred$cMV_BCCR,nRessaAnt,"")	//10 - VL_CRED_PER_PA_ANT
			aReg1500[nPos1500][11]	+= Iif(cCodCred$cMV_BCCC,nCompAnt,"")	//11 - VL_CRED_DCOMP_PA_ANT
			nTotCpo12:= nTotCpo8 - nCrdMesAnt - nRessaAnt - nCompAnt
			aReg1500[nPos1500][12]	+= nTotCpo12			   		//12 - SD_CRED_DISP_EFD
			//Se estiver reservado, o credito no ser¡ apropriado 
			If !cReserCof$"1"
				If nTotContrb > 0 .AND. !lMesAtual
	//				If nCredUti < nTotContrb
						If  nTotCpo12  <= nTotContrb // Total de credito do mes anterior for menor que a contribuio deste mes, utiliza o credito
							nTotCpo13 := nTotCpo12	 //Utiliza todo o credito
							nCredUti += nTotCpo13
							nTotContrb -= nTotCpo13
						Else
							nTotCpo13 := nTotCpo12 - nTotContrb
							nTotCpo13 := nTotCpo12 - nTotCpo13
							nCredUti += nTotCpo13
							nTotContrb := 0
						EndIf
	//				EndIF
				ElseIf lMesAtual
					nTotCpo13 :=nCrdMesAtu
				EndIF
			Else
				nTotCpo13 :=nCrdMesAtu
			EndIf

			aReg1500[nPos1500][13] += nTotCpo13						//13 - VL_CRED_DESC_EFD
			nTotCpo18 := nTotCpo12 - nTotCpo13

			If (nRessar+nComp) <= nTotCpo18
				nTotCpo18 -= (nRessar+nComp)
				nCpo14		:= nRessar
				nCpo15		:= nComp
			Else
				nCpo14		:= 0
				nCpo15		:= 0
			EndIf

			aReg1500[nPos1500][14] += nCpo14				   		//14 - VL_CRED_PER_EFD
			aReg1500[nPos1500][15] += nCpo15				   		//15 - VL_CRED_DCOMP_EFD
			aReg1500[nPos1500][16] += 0						   		//16 - VL_CRED_TRANS
			aReg1500[nPos1500][17] += 0						   		//17 - VL_CRED_OUT

			aReg1500[nPos1500][18] += nTotCpo18
			If nTotCpo18 > 0 .AND. !lMesAtual
				CredFutCof(cPerAtu,cCodCred,nValCred,aReg1500[nPos1500][13],aReg1500[nPos1500][18],aReg1500[nPos1500][7],cRefer,nValDesc,nCpo14,nCpo15,nRessaAnt,nCompAnt,aReg1500[nPos1500][3],aReg1500[nPos1500][4],cReserCof)
			EndIF
		EndIf
	EndIF

EndIF

Return()

/*±±ºPrograma  RegF600   ºAutor  Erick G. Dias       º Data   15/03/11 º±±
±±ºDesc.      Processamento dos registro F600.                            º±±*/
static Function RegF600(aRegF600,aF600Aux,aReg1300,aReg1700,aF600Tmp)

Local nPos			:= 0
Local nPosF600		:= 0
Local nCont			:= 0
Local cRegime		:= ""

For nCont:=1 to Len(aF600Aux)

	cRegime :=""
	If aF600Aux[nCont][5] == "0"
		cRegime := "1"
	ElseIf aF600Aux[nCont][5] == "1"
		cRegime := "0"
	EndIF

	nPosF600 := aScan (aRegF600, {|aX| aX[2]==aF600Aux[nCont][1]  .AND. ax[3] == Substr(aF600Aux[nCont][2],7,2) + Substr(aF600Aux[nCont][2],5,2)  + Substr(aF600Aux[nCont][2],1,4)   .AND. ax[7] == cRegime .AND. ax[8] == aF600Aux[nCont][6]  .AND. ax[11] == aF600Aux[nCont][9]})
	IF nPosF600 ==0
		aAdd(aRegF600, {})
		nPos := Len(aRegF600)
		aAdd (aRegF600[nPos], "F600")						   	//01 - REG
		aAdd (aRegF600[nPos], aF600Aux[nCont][1])				//02 - IND_NAT_RET
		aAdd (aRegF600[nPos],  Substr(aF600Aux[nCont][2],7,2) + Substr(aF600Aux[nCont][2],5,2)  + Substr(aF600Aux[nCont][2],1,4) )				//03 - DT_RET
		aAdd (aRegF600[nPos], aF600Aux[nCont][3])				//04 - VL_BC_RET
		aAdd (aRegF600[nPos], aF600Aux[nCont][4])				//05 - VL_RET
		aAdd (aRegF600[nPos], Iif(Len(aF600Aux[nCont])>11,aF600Aux[nCont][12],"")     )	   		//06 - COD_REC

		aAdd (aRegF600[nPos], cRegime)				//07 - IND_NAT_REC
		aAdd (aRegF600[nPos], aF600Aux[nCont][6])				//08 - CNPJ
		aAdd (aRegF600[nPos], aF600Aux[nCont][7])				//09 - VL_RET_PIS
		aAdd (aRegF600[nPos], aF600Aux[nCont][8])				//10 - VL_RET_COFINS
		aAdd (aRegF600[nPos], aF600Aux[nCont][9])				//11 - IND_REC

		AcumumF600(@aF600Tmp,aF600Aux[nCont])

	Else
		aRegF600[nPosF600][4]  += aF600Aux[nCont][3]			//04 - VL_BC_RET
		aRegF600[nPosF600][5]  += aF600Aux[nCont][4]			//05 - VL_RET
		aRegF600[nPosF600][9]  += aF600Aux[nCont][7]			//09 - VL_RET_PIS
		aRegF600[nPosF600][10] += aF600Aux[nCont][8]			//10 - VL_RET_COFINS

		AcumumF600(@aF600Tmp,aF600Aux[nCont])

	EndIF

Next nCont

Return()

/*±±ºPrograma  Reg1300   ºAutor  Erick G. Dias       º Data   15/03/11 º±±
±±ºDesc.      Processamento dos registro 1300.                            º±±*/
static Function Reg1300(aReg1300, nValUsar,cPer, cNatRet,nValTot, cData, cIndCumu, nValDed, nVlTotPer,lProcAnt)

Local nPos		  := 0
Local nPos1300	  := 0
Local nSldRet	  := 0
Local nVlReDcomp  := 0
Local nTotRet	  := 0
Local nRetRest	:= 0
Local nVlTotRed	  := 0
Default lProcAnt  := .F.
Default nValDed   := nValTot
Default nVlTotPer   := 0

If len(cData) < 8
	cData:= "01"+cData
EndIF
nPos1300 := aScan (aReg1300, {|aX| aX[2]==cNatRet  .AND. ax[3] == Substr(cData,3,2) + Substr(cData,5,4) })
If nPos1300 ==0
	aAdd(aReg1300, {})
	nPos := Len(aReg1300)
	aAdd (aReg1300[nPos], "1300")						   	//01 - REG
	aAdd (aReg1300[nPos], cNatRet)						   	//02 - IND_NAT_RET
	aAdd (aReg1300[nPos], Substr(cData,3,2) + Substr(cData,5,4) )		//03 - PR_REC_RET
	aAdd (aReg1300[nPos], nValTot)						   	//04 - VL_RET_APU
	If lProcAnt
    	nVlTotRed:=nValUsar
    	nSldRet := nValDed - nVlTotRed - nVlReDcomp //nSldRet :=nValTot- nVlTotRed - nVlTotPer - nVlReDcomp
    	aAdd (aReg1300[nPos], nValTot-nSldRet) 			    //05 - VL_RET_DED
    	aAdd (aReg1300[nPos], nRetRest)					    //06 - VL_RET_PER
    	aAdd (aReg1300[nPos], nVlReDcomp)					//07 - VL_RET_DCOMP
    	aAdd (aReg1300[nPos], nSldRet)						//08 - SLD_RET
    	RetFutPIS(aReg1300[nPos][3], cNatRet, nValTot,nSldRet,cIndCumu,cPer,nValUsar,lProcAnt)
    Else
        nVlTotRed:=nValUsar
        nSldRet :=nValTot- nVlTotRed - nVlReDcomp
        aAdd (aReg1300[nPos], nVlTotRed)                    //05 - VL_RET_DED
        aAdd (aReg1300[nPos], nRetRest)                     //06 - VL_RET_PER
        aAdd (aReg1300[nPos], nVlReDcomp)                   //07 - VL_RET_DCOMP
        aAdd (aReg1300[nPos], nSldRet)                      //08 - SLD_RET

        If nSldRet >0 .Or. aReg1300[nPos][4] <> nValTot
            RetFutPIS(aReg1300[nPos][3], cNatRet, nValTot,nSldRet,cIndCumu,cPer,nValUsar,lProcAnt)
        EndIF
    EndIf
Else
    If !lProcAnt
        aReg1300[nPos1300][4] += nValTot
        nVlTotRed :=nValUsar
        aReg1300[nPos1300][5] += nVlTotRed
        aReg1300[nPos1300][6] += nRetRest
        aReg1300[nPos1300][7] += nVlReDcomp
        nSldRet :=aReg1300[nPos1300][4] - aReg1300[nPos1300][5] - aReg1300[nPos1300][6] - aReg1300[nPos1300][7]
        aReg1300[nPos1300][8] := nSldRet

        If nSldRet >0 .Or. aReg1300[nPos1300][4] <> nValTot
            RetFutPIS(aReg1300[nPos1300][3], cNatRet, nValTot,nSldRet,cIndCumu,cPer,nValUsar,lProcAnt)
        EndIF
    EndIf

EndIF

Return()

/*±±ºPrograma  Reg1700   ºAutor  Erick G. Dias       º Data   15/03/11 º±±
±±ºDesc.      Processamento dos registro 1700.                            º±±*/
static Function Reg1700(aReg1700,nValUsar,cPer, cNatRet,nValTot, cData, cIndCumum, nValDed, nVlTotPer,lProcAnt)

Local nPos      :=  0
Local nPos1700  :=  0
Local nSldRet   :=  0
Local nVlReDcomp    :=0
Local nTotRet   :=0
Local nRetRest	:= 0
Local nVlTotRed := 0
Default lProcAnt    := .F.
Default nValDed   := nValTot
Default nVlTotPer   := 0

If len(cData) <8
    cData:= "01"+ cData
EndIF

nPos1700 := aScan (aReg1700, {|aX| aX[2]==cNatRet  .AND. ax[3] == Substr(cData,3,2) + Substr(cData,5,4) })
If nPos1700 ==0
    aAdd(aReg1700, {})
    nPos := Len(aReg1700)
    aAdd (aReg1700[nPos], "1700")                           //01 - REG
    aAdd (aReg1700[nPos], cNatRet)                          //02 - IND_NAT_RET
    aAdd (aReg1700[nPos], Substr(cData,3,2) + Substr(cData,5,4) )                           //03 - PR_REC_RET
    aAdd (aReg1700[nPos], nValTot)                          //04 - VL_RET_APU
    If lProcAnt
        nVlTotRed :=nValUsar
        nSldRet := nValDed - nVlTotRed - nVlReDcomp
        aAdd (aReg1700[nPos], nValTot-nSldRet)                      //05 - VL_RET_DED
        aAdd (aReg1700[nPos], nRetRest)                            //06 - VL_RET_PER
        aAdd (aReg1700[nPos], nVlReDcomp)                           //07 - VL_RET_DCOMP
        aAdd (aReg1700[nPos], nSldRet)                          //08 - SLD_RET
        RetFutCOF(aReg1700[nPos][3], cNatRet, nValTot,nSldRet,cIndCumum,cPer,nValUsar,lProcAnt)
    Else
        nVlTotRed :=nValUsar
        aAdd (aReg1700[nPos], nVlTotRed)                            //05 - VL_RET_DED
        aAdd (aReg1700[nPos], nRetRest)                            //06 - VL_RET_PER
        aAdd (aReg1700[nPos], nVlReDcomp)                           //07 - VL_RET_DCOMP
        nSldRet :=nValTot - nVlTotRed - nVlTotPer - nVlReDcomp
        aAdd (aReg1700[nPos], nSldRet)                          //08 - SLD_RET
        If nSldRet >0 .Or. aReg1700[nPos][4] <> nValTot
            RetFutCOF(aReg1700[nPos][3], cNatRet, nValTot,nSldRet,cIndCumum,cPer,nValUsar,lProcAnt)
        EndIF
    EndIf

Else
    If !lProcAnt
        aReg1700[nPos1700][4] += nValTot
        nVlTotRed:=nValUsar
        aReg1700[nPos1700][5] += nVlTotRed
        aReg1700[nPos1700][6] += nRetRest
        aReg1700[nPos1700][7] += nVlReDcomp
        nSldRet :=aReg1700[nPos1700][4] - aReg1700[nPos1700][5] - aReg1700[nPos1700][6] - aReg1700[nPos1700][7]
        aReg1700[nPos1700][8] := nSldRet

        If nSldRet >0 .Or. aReg1700[nPos1700][4] <> nValTot
            RetFutCOF(aReg1700[nPos1700][3], cNatRet, nValTot,nSldRet,cIndCumum,cPer,nValUsar,lProcAnt)
        EndIF
    EndIf
EndIF

Return()

/*±±ºPrograma  RecBrut   ºAutor  Erick G. Dias       º Data   21/03/11 º±±
±±ºDescrio  Retornar os totais da receita bruta mensal                 º±±*/
static Function RecBrut(dDataDe,dDataAte,cEmpAnt,cFilAte,aWizard,aLisFil,cFilDe,aCFOPs,nMVM996TPR,cRegime,nTotF,lExtTaf,aRecBrtFil,lApropDir)

Local lCache		:= Iif((aIndics==NIL).Or.(aFieldPos==NIL).Or.(aParSX6==NIL).Or.(aExstBlck==NIL),SpdCLCache(),.T.)
Local 	cAliasSFT 	:=	"SFT"
Local 	aRetorno 	:=	{0,0,0,0}
Local 	cFiltro 	:=	""
Local 	cCampos 	:=	""
Local 	aF100Aux	:=	{}
Local   aRetPE      :=  {}
Local 	nPosF100	:=	0
Local 	cNrLivro	:=	""
Local 	cCstNTrib	:=	"04#06#07#08#09#49" //Csts no tribut¡veis
Local 	lExpF100	:=	.F.
Local	lNatF100	:=	.F.
Local 	cNatRecBr	:= aParSX6[39]
Local	aNatRecBr	:=	If(Substr(AllTrim(cNatRecBr),1,1) == "{", &(aParSX6[39]),{})
Local 	lCumulativ	:=	.F.
Local   lSpdRcBrut  :=  .F.
Local	cEspecie	:= ""
Local	aParFil		:=	{}
Local	lAchouCF8	:=	.F.
Local	cAliasCF8	:=	"CF8"
Local 	lCmpEstRec	:= 	aFieldPos[38]
Local	lMVESTTELE	:=  aParSX6[3]
Local	lCF8RecBru 	:= 	aFieldPos[43]
Local   lCalcCF8	:= .F.
Local   aRecTele	:= {}
Local   lEstorno	:= .F.
LOcal 	lB1Tpreg		:=aFieldPos[22]

Default lExtTaf  	:= .F.
DEFAULT aRecBrtFil	:= {}
DEFAULT lApropDir	:= .F.

SpdCLCache()

cNrLivro :=	Iif( !lExtTaf, aWizard[1][3], '*' )

lSpdRcBrut  := aExstBlck[19]


DbSelectArea ("SM0")
SM0->(DbGoTop ())
SM0->(MsSeek (cEmpAnt+cFilDe, .T.))	//Pego a filial mais proxima
Do While !SM0->(Eof ()) .And. ((!"1"$ Iif( !lExtTaf, aWizard[1][6], aWizard[1][5] ) .And. cEmpAnt==SM0->M0_CODIGO .And. FWGETCODFILIAL<=cFilAte) .Or. ("1"$ Iif( !lExtTaf, aWizard[1][6], aWizard[1][5] ) .And. Iif( !lExtTaf, Len(aLisFil)>0, .T. ) .And. cEmpAnt==SM0->M0_CODIGO  ))

	IncProc("Processando valores para registro 0111: "+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL))
	cStatus := STR0004+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL)
	cFilAnt := FWGETCODFILIAL

	//Quando a funcao de chamada por a de emissao do Extrator nao deve ser               
	//realizado o tratamento de filiais, visto que ja estou posicionado na filial correta
	//de processamento                                                                   
	If !lExtTaf
		If Len(aLisFil)>0 //.And. Val(cFilAnt) <= Len(aLisFil)
	        nFilial := Ascan(aLisFil,{|x|Alltrim(x[2])==Alltrim(cFilAnt)})
		   If nFilial > 0
			   If !(aLisFil[  nFilial, 1 ])  //Filial no marcada, vai para proxima
					SM0->( dbSkip() )
					Loop
				EndIf
		   Else
				SM0->( dbSkip() )
				Loop
		   EndIf
		Else
			If "1"  $ aWizard[1][6] //Somente faz skip se a opo de selecionar filiais estiver como Sim.
				 SM0->( dbSkip() )
				 Loop
			EndIf
		EndIf
	EndIf
	If !lApropDir

		//CALCULA RECEITA BRUTA A PARTIR DAS NOTAS FISCAIS (BLOCOS A, C, D)
		DbSelectArea (cAliasSFT)
		(cAliasSFT)->(DbSetOrder (2))
		#IFDEF TOP
		    If (TcSrvType ()<>"AS/400")
		    	cAliasSFT	:=	GetNextAlias()

				cFiltro := "%"

				If (cNrLivro<>"*")
	        		cFiltro += " SFT.FT_NRLIVRO = '" +%Exp:cNrLivro% +"' AND "
	      		EndiF

				cFiltro += "%"
				cCampos := "%"

		    	BeginSql Alias cAliasSFT

					COLUMN FT_EMISSAO AS DATE
			    	COLUMN FT_ENTRADA AS DATE
			    	COLUMN FT_DTCANC AS DATE

					SELECT
						SFT.FT_VALCONT ,SFT.FT_CFOP,SFT.FT_ALIQPIS,SFT.FT_ALIQCOF,SFT.FT_CSTPIS,SFT.FT_CSTCOF, SFT.FT_PRODUTO,
						SFT.FT_NFISCAL,SFT.FT_SERIE,SFT.FT_CLIEFOR,SFT.FT_LOJA,SFT.FT_ITEM,SFT.FT_ESPECIE,SFT.FT_ICMSRET,SFT.FT_VALIPI
						%Exp:cCampos%
					FROM
						%Table:SFT% SFT
					WHERE
						SFT.FT_FILIAL=%xFilial:SFT% AND
						SFT.FT_TIPOMOV = 'S' AND
						SFT.FT_TIPO <> 'D' AND
						SFT.FT_ENTRADA>=%Exp:DToS (dDataDe)% AND
						SFT.FT_ENTRADA<=%Exp:DToS (dDataAte)% AND
						((SFT.FT_CFOP NOT LIKE '000%' AND SFT.FT_CFOP NOT LIKE '999%') OR SFT.FT_TIPO='S') AND
						((SFT.FT_BASEPIS > 0 OR SFT.FT_CSTPIS IN ('07','08','09','49','99'))  OR ( SFT.FT_BASECOF > 0 OR SFT.FT_CSTCOF IN ('07','08','09','49','99'))) AND
						(SFT.FT_DTCANC = ' ' OR SFT.FT_DTCANC > %Exp:DToS (dDataAte)% )  AND
						%Exp:cFiltro%
						SFT.%NotDel%

					ORDER BY SFT.FT_CFOP

				EndSql
			Else
		#ENDIF
			    cIndex	:= CriaTrab(NIL,.F.)
			    cFiltro	:= 'FT_FILIAL=="'+xFilial ("SFT")+'".And.'
			    cFiltro += 'FT_TIPOMOV== "S" .And. '
			    cFiltro += 'FT_TIPO <> "D" .And. '
			   	cFiltro += 'DToS (FT_ENTRADA)>="'+DToS (dDataDe)+'".And.DToS (FT_ENTRADA)<="'+DToS (dDataAte)+'" '
				cFiltro += '.And. (!SubStr (FT_CFOP,1,3)$"999/000" .Or. FT_TIPO=="S") .And.((FT_VALPIS > 0 .OR. FT_CSTPIS $"07#08#09#49#99") .OR. (FT_VALCOF > 0  .OR. FT_CSTCOF $"07#08#09#49#99")) .AND.(FT_DTCANC == " " .OR. DToS (FT_DTCANC)>"'+DToS (dDataDe)+'") .AND. FT_TIPOMOV == "E" '

			    If (cNrLivro<>"*")
				    cFiltro	+=	'.And.FT_NRLIVRO ="'+cNrLivro+'" '
			   	EndIf

			    IndRegua (cAliasSFT, cIndex, SFT->(IndexKey ()),, cFiltro)
			    nIndex := RetIndex(cAliasSFT)

				#IFNDEF TOP
					DbSetIndex (cIndex+OrdBagExt ())
				#ENDIF

				DbSelectArea (cAliasSFT)
			    DbSetOrder (nIndex+1)
		#IFDEF TOP
			Endif
		#ENDIF

		DbSelectArea (cAliasSFT)
		(cAliasSFT)->(DbGoTop ())
		ProcRegua ((cAliasSFT)->(RecCount ()))
		IncProc("Processando Registro 0111")
		Do While !(cAliasSFT)->(Eof ())

		//Verifica se o CFOP eh gerador de receita

		cEspecie	:=	AModNot ((cAliasSFT)->FT_ESPECIE)		//Modelo NF
		lEstorno	:= .F.

		If lMVESTTELE .AND. cEspecie $"21/22"

			lAchouSFX	:=	SFX->(MsSeek (xFilial ("SFX")+"S"+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA+(cAliasSFT)->FT_ITEM+(cAliasSFT)->FT_PRODUTO))
			If lAchouSFX .AND. SFX->FX_TIPOREC == "0" .AND. ((cAliasSFT)->FT_CSTPIS $ "01/02" .OR. (cAliasSFT)->FT_CSTCOF $ "01/02") .AND. lMVESTTELE .AND. lCmpEstRec
				IF SFX->FX_ESTREC <> "2"
					lEstorno	:= .T.
				EndIF
			EndIF
		EndIF

		If ( (cEspecie$"  " .AND. LEN(Alltrim((cAliasSFT)->FT_CFOP))<>4) .Or. ( (AllTrim((cAliasSFT)->FT_CFOP)$aCFOPs[01]) .AND. !(AllTrim((cAliasSFT)->FT_CFOP)$aCFOPs[02]) )) .AND. !lEstorno

				lCumulativ	:= .F.
				IF (cAliasSFT)->FT_ALIQPIS == 0.65 .and. (cAliasSFT)->FT_ALIQCOF == 3
					Do Case
						Case nMVM996TPR == 1
							If SPEDSeek("SD2",3,xFilial("SD2")+(cAliasSFT)->(FT_NFISCAL+FT_SERIE+FT_CLIEFOR+FT_LOJA+FT_PRODUTO+FT_ITEM))
								If SPEDSeek("SF4",1,xFilial("SF4")+SD2->D2_TES)
									If SF4->F4_TPREG == "2"
										lCumulativ := .T.
									ElseIf SF4->F4_TPREG == "3"
										If SPEDSeek("SB1",1,xFilial("SB1")+(cAliasSFT)->FT_PRODUTO) .AND. lB1Tpreg
											If  SB1->B1_TPREG == "2"
												lCumulativ := .T.
											EndIF
										EndIf
									Endif
								Endif
							Endif

						Case nMVM996TPR == 2
							If SPEDSeek("SB1",1,xFilial("SB1")+(cAliasSFT)->FT_PRODUTO) .AND. lB1Tpreg
								If  SB1->B1_TPREG == "2"
									lCumulativ := .T.
								EndIF
							Endif

						Case nMVM996TPR == 3 .And. aFieldPos[12]
							If SPEDSeek("SA1",1,xFilial("SA1")+(cAliasSFT)->(FT_CLIEFOR+FT_LOJA))
								IF SA1->A1_TPREG == "2"
									lCumulativ := .T.
								EndIF
							Endif
					EndCase
				EndIF

				//Acumula valor de receita de Exportacao
				If SubStr((cAliasSFT)->FT_CFOP,1,1) == "7" .OR. (Alltrim((cAliasSFT)->FT_CFOP)$"5501/5502/6501/6502")

					aRetorno[3] += (cAliasSFT)->FT_VALCONT
				//Acumula valor de receita Nao Tributado no Mercado Interno
				ElseIf ((cAliasSFT)->FT_CSTPIS $ cCstNTrib .OR. (cAliasSFT)->FT_CSTCOF $ cCstNTrib) .OR. ;
					  ( ((cAliasSFT)->FT_CSTPIS $ "05" .AND.  (cAliasSFT)->FT_ALIQPIS == 0) .OR.   ((cAliasSFT)->FT_CSTCOF $ "05" .AND.  (cAliasSFT)->FT_ALIQCOF == 0))
					aRetorno[2] += (cAliasSFT)->FT_VALCONT
				//Acumula valor de receita Cumulativa	
				ElseIF (cAliasSFT)->FT_ALIQPIS == 0.65 .and. (cAliasSFT)->FT_ALIQCOF == 3  .AND. lCumulativ
					aRetorno[4] += (cAliasSFT)->FT_VALCONT
				//Acumula valor de receita nao cumulativa
				Else
					aRetorno[1] += ((cAliasSFT)->FT_VALCONT)
				EndIF

			EndIF

			(cAliasSFT)->(DbSkip ())
		EndDo

		#IFDEF TOP
			If (TcSrvType ()<>"AS/400")
				DbSelectArea (cAliasSFT)
				(cAliasSFT)->(DbCloseArea ())
			Else
		#ENDIF
				RetIndex("SFT")
				FErase(cIndex+OrdBagExt ())
		#IFDEF TOP
			EndIf
		#ENDIF
	EndIF
	//CALCULA RECEITA BRUTA A PARTIR DO REGISTRO F100 

	CONOUT( "INI [FinSpdF100] - From [RecBrut]" + Time() )
	aF100Aux := FinSpdF100(Month(dDataDe),Year(dDataDe),,,,"F100")
	CONOUT( "END [FinSpdF100] - From [RecBrut]" + Time() )

	For nPosF100 :=1 to Len(aF100Aux)

		lExpF100	:=	.F.
		lNatF100	:=	.F.

		If Len(aF100Aux[nPosF100]) > 25

			IF aF100Aux[nPosF100][22]$"X"
				lExpF100	:=	.T.
			EndIF

		    If aScan(aNatRecBr, {|x| x == Alltrim(aF100Aux[nPosF100][26])}) > 0
		    	lNatF100	:=	.T.
		    Endif

		Elseif Len(aF100Aux[nPosF100]) > 21

			IF aF100Aux[nPosF100][22]$"X"
				lExpF100	:=	.T.
			EndIF
		EndIf

		//A variavel lNatF100 indica se a natureza utilizada no titulo foi preenchida no parametro MV_RECBNAT
		//O parametro indica as naturezas que serao desconsideradas no processamento do registro 0111		  
		If !lNatF100
			//Verifica se eh cliente de exportacao. Leva para o campo 04 - Rec. Bruta N Cumulativa - EXPORTACAO  
			If lExpF100
				aRetorno[3] += aF100Aux[nPosF100][2]

				// Aqui acumulo o total da receita para a utilizao no bloco P
				nTotF	+=	aF100Aux[nPosF100][2]

			//Acumula valor de receita No Tributado no Mercado Interno
			ElseIf aF100Aux[nPosF100][3] $ "04#06#07#08#09#49#99"	.AND. aF100Aux[nPosF100][15] <> "SE2"

				aRetorno[2] += aF100Aux[nPosF100][2]

				// Aqui acumulo o total da receita para a utilizao no bloco P
				nTotF	+=	aF100Aux[nPosF100][2]

			//Acumula valor de receita Cumulativa
			ElseIf aF100Aux[nPosF100][3] $ "01#02#03#05" .AND. aF100Aux[nPosF100][15] <> "SE2"
				If aF100Aux[nPosF100][5]== 0.65 .and. aF100Aux[nPosF100][9] == 3
					aRetorno[4] += aF100Aux[nPosF100][2]
				Else
					//Acumula valor de receita Nao Cumulativa
					aRetorno[1] += aF100Aux[nPosF100][2]

				EndIF

				// Aqui acumulo o total da receita para a utilizao no bloco P
				nTotF	+=	aF100Aux[nPosF100][2]

			EndIF
		Endif

	Next nCont

	//CALCULA RECEITA BRUTA A PARTIR DA TABELA CF8    
	If aIndics[20]

		aAdd(aParFil,DTOS(dDataDe))
		aAdd(aParFil,DTOS(dDataAte))

		//Funo que ir¡ retornar alias com valores da tabela CF8 referente ao per­odo e filial corrente.
		If (lAchouCF8	:=	SPEDFFiltro(1,"CF8",@cAliasCF8,aParFil))

			ProcRegua ((cAliasCF8)->(RecCount ()))
			Do While !(cAliasCF8)->(Eof ())

				lCalcCF8	:= .T.
				IF lCF8RecBru .AND.(cAliasCF8)->CF8_RECBRU == "2" //No
					lCalcCF8	:= .F.
				EndIF

				IF lCalcCF8
					//Acumula valor de receita No Tributado no Mercado Interno
					If (cAliasCF8)->CF8_INDOPE == "2"
						aRetorno[2] += (cAliasCF8)->CF8_VLOPER

					//Acumula valor de receita Cumulativa
					ElseIF (cAliasCF8)->CF8_TPREG == "1" .AND. (cAliasCF8)->CF8_INDOPE == "1"
						aRetorno[4] += (cAliasCF8)->CF8_VLOPER

					//Acumula valor de receita Nao Cumulativa
					ElseIF (cAliasCF8)->CF8_TPREG== "2" .AND. (cAliasCF8)->CF8_INDOPE == "1"
						aRetorno[1] += (cAliasCF8)->CF8_VLOPER
					EndIF

				EndIF

				// Aqui acumulo o total da receita para utilizao no bloco P
				If Alltrim((cAliasCF8)->CF8_INDOPE)$"1/2"
					nTotF	+= (cAliasCF8)->CF8_VLOPER
				EndIf

				(cAliasCF8)->(DbSkip ())
			EndDo
		Endif
	Endif

	If lAchouCF8
		SPEDFFiltro(2,,cAliasCF8)
	EndIf

	//PE que retorna as receitas Tributadas/Nao Tributadas/Cumulativas para geracao do    
	//registro 0111                                                                       
	If lSpdRcBrut
		aRetPE := ExecBlock("SPDRECBRUT",.F.,.F.)

		If ValType(aRetPE) == "A"
			//Acumula valor de receita Cumulativa
			aRetorno[4] += aRetPE[1]

			//Acumula valor de receita No Tributado no Mercado Interno
			aRetorno[2] += aRetPE[2]

			//Acumula valor de receita Nao Cumulativa
			aRetorno[1] += aRetPE[3]

			// Aqui acumulo o total da receita para a utilizao no bloco P
			nTotF	+=	aRetPE[1]+aRetPE[2]+aRetPE[3]

		EndIf
	EndIf

	IF lMVESTTELE
		aRecTele:=TeleComFut(dDataDe,dDataAte,,,,,,,,,,,,.F.,cRegime)

		IF len(aRecTele) > 0
			//Receita Tributada no mercado interno
			aRetorno[1] +=aRecTele[1]
			//Receita No Tributada no Mercado Interno
			aRetorno[2] +=aRecTele[2]
			//Receita de Exportao
			aRetorno[3] +=aRecTele[3]
			//Receita Cumulativa
			aRetorno[4] +=aRecTele[4]

	   		// Aqui acumulo o total da receita para a utilizao no bloco P
			nTotF	+=	aRecTele[1]+aRecTele[2]+aRecTele[3]+aRecTele[4]
		EndIF
	EndIF

	cAliasSFT	:=	"SFT"
	cAliasCF8	:=  "CF8"
	aAdd(aRecBrtFil,{FWCODFIL(),nTotF})
	nTotF		:= 0
	SM0->(DbSkip ())
EndDo
Return (aRetorno)

/*±±ºPrograma  InfPartDocºAutor  Erick G. Dias       º Data   21/03/11 º±±
±±ºDesc.      Retornar um array com informaµes do participante.         º±±*/
Static Function InfPartDoc (cAlsSA, aReg0150, lGrava0150, dDataDe, dDataAte, nRelacFil)
	Local	lHistTab	:=	aParSX6[1] .And. aIndics[01]
	Local	aA1A2		:=	{}
	Local	cA1A2		:=	SubStr (cAlsSA, 3, 1)
	Local	cCodMun		:=	""
	Local	cCmpCod		:=	cAlsSA+"->A"+cA1A2+"_COD"
	Local	cCmpLoja	:=	cAlsSA+"->A"+cA1A2+"_LOJA"
	Local	cCmpNome	:=	cAlsSA+"->A"+cA1A2+"_NOME"
	Local	cCmpTipo	:=	cAlsSA+"->A"+cA1A2+Iif ("2"$cA1A2, "_TIPO", "_PESSOA")
	Local	cCmpCgc		:=	cAlsSA+"->A"+cA1A2+"_CGC"
	Local	cCmpEst		:=	cAlsSA+"->A"+cA1A2+"_EST"
	Local	cCmpInsc	:=	cAlsSA+"->A"+cA1A2+"_INSCR"
	Local	cCmpCodM	:=	cAlsSA+"->A"+cA1A2+"_COD_MUN"
	Local	cCmpEnd		:=	cAlsSA+"->A"+cA1A2+"_END"
	Local	cCmpBairro	:=	cAlsSA+"->A"+cA1A2+"_BAIRRO"
	Local	cCmpCdPais	:=	cAlsSA+"->A"+cA1A2+"_CODPAIS"
	Local	cCmpSuframa	:=	Iif(&(cAlsSA)->(FieldPos("A"+cA1A2+"_SUFRAMA")) > 0,cAlsSA+"->A"+cA1A2+"_SUFRAMA","")//Codigo Suframa n o existe no Cad.Forn.
	Local 	cCmpInscM	:= 	cAlsSA+"->A"+cA1A2+"_INSCRM"
	Local	nX			:=	0
	Local	aMod		:= {}
	Local	aCodPais	:= {}
	Local	aCGC		:= {}
	Local	aIE			:= {}
	Local	aCodMun		:= {}
	Local	aSuframa	:= {}
	Local	aEnd		:= {}
	Local	aNum		:= {}
	Local	aBairro		:= {}
	Local	aNome		:= {}
	Local	aPart	    := {}

	//
	DEFAULT aReg0150	:=	0
	DEFAULT lGrava0150	:=	.F.
	//

	If cAlsSA == "SA4"
		aAdd (aA1A2, "SA4"+Iif(lConcFil,AllTrim(cFilAnt),"")+SA4->A4_COD)					 						//01	-	COD_PART
		aAdd (aA1A2, SA4->A4_NOME)																			//02	-	NOME
		aAdd (aA1A2, Iif(aFieldPos[44],AllTrim (SA4->A4_CODPAIS),"01058"))					//03	-	COD_PAIS
		aAdd (aA1A2, "")																		  				//04	-	CNPJ
		aAdd (aA1A2, "")																			 			//05	-	CPF
		aAdd (aA1A2, "")																			 			//06	-	IE
		aAdd (aA1A2, "")																			  			//07	-	COD_MUN
		aAdd (aA1A2, "")																			  			//08	-	Inscricao SUFRAMA
		//
		If "01058" $ aA1A2[3]
			If Len (AllTrim (SA4->A4_CGC))>=14
				aA1A2[04] := SPEDConvType(VldIE(SA4->A4_CGC,,.F.))									   		   		//04	-	CNPJ
			ElseIf Len (AllTrim (SA4->A4_CGC))<14
				aA1A2[05] := SPEDConvType(VldIE(SA4->A4_CGC,,.F.))									   				//05	-	CPF
			EndIf

			aA1A2[06] := SPEDConvType(VldIE(SA4->A4_INSEST))											  			//06	-	IE

			If aFieldPos[45]
				If Upper(SA4->A4_EST) == "EX"
					aA1A2[07]	:=	"9999999"																   	//07	-	COD_MUN
				ElseIf Len(Alltrim(SA4->A4_COD_MUN))<=5
					aA1A2[07]	:=	UfCodIBGE(SA4->A4_EST)+Alltrim(SA4->A4_COD_MUN)				  			//07	-	COD_MUN
				Else
					aA1A2[07]	:=	Alltrim(SA4->A4_COD_MUN)													//07	-	COD_MUN
				EndIf
			EndIf

			If aFieldPos[46]
				aA1A2[08] := SPEDConvType(SA4->A4_SUFRAMA)
			EndIf
		Else
			aA1A2[07] := "9999999"
		EndIf
		aAdd (aA1A2, SPEDConvType(MyGetEnd(SA4->A4_END,cAlsSA)[1]))												//09	-	END
		aAdd (aA1A2, Iif (!Empty(MyGetEnd(SA4->A4_END,cAlsSA)[2]),MyGetEnd(SA4->A4_END,cAlsSA)[3],"SN"))		//10	-	NUM
		aAdd (aA1A2, SPEDConvType(MyGetEnd(SA4->A4_END,cAlsSA)[4]))		  										//11	-	COMPL
		aAdd (aA1A2, SPEDConvType(SA4->A4_BAIRRO))											  						//12	-	BAIRRO
		aAdd (aA1A2, SA4->A4_EST)														  						//13	-	UF
		aAdd (aA1A2, "")																  						//14	-	InscMun
	Else
		aAdd (aA1A2, cAlsSA+Iif(lConcFil,AllTrim(cFilAnt),"")+&(cCmpCod)+&(cCmpLoja)) 											  		//01	-	COD_PART

		If lHistTab .And. dDataDe <> NIL
			aMod 	:= MsConHist(cAlsSA,&(cCmpCod),&(cCmpLoja),dDataDe,,,&(cCmpCod))
			cCampo 	:= AllTrim(Substr(cCmpNome,6,10))
			nPos 	:= ASCAN(aMod,{|x|alltrim(x[1])==cCampo })

			If len(aMod) >0 .And. nPos > 0
				If !(Alltrim(&(cCmpNome)) == AllTrim(aMod[nPos][2])) .And. (aMod[nPos][3] > dDataAte)       //se o conteudo gravado for diferente da tabela AIF, levo conteudo da tabela AIF
					aAdd (aNome, aMod[nPos][2])
				EndIF
			EndIF
		EndIf

		If len(aNome) > 0
			aAdd (aA1A2, Alltrim(Substr(aNome[1],1,100)))     	//02		 -	Retorna o nome antes de ser alterado
		Else
			aAdd (aA1A2, Alltrim(Substr(&(cCmpNome),1,100)))  	//02		 -	Retorna o nome se nao houve alterao,ou se foi realizada dentro do mes da operao
		EndIf

		If lHistTab .And. dDataDe <> NIL
			cCampo 	:= AllTrim(Substr(cCmpCdPais,6,10))
			nPos 	:= ASCAN(aMod,{|x|alltrim(x[1])==cCampo })

			If len(aMod) >0 .And. nPos > 0
				If !(Alltrim(&(cCmpCdPais)) == AllTrim(aMod[nPos][2])) .And. (aMod[nPos][3] > dDataAte)
					aAdd(aCodPais,aMod[nPos][2])
				EndIF
			EndIF
		EndIf

		If len(aCodPais) > 0
			aAdd(aA1A2,aCodPais[1])
		Else
			aAdd (aA1A2,Iif((cAlsSA)->(FieldPos(SubStr(cCmpCdPais,6)))>0,&(cCmpCdPais),"01058"))				//03	-	COD_PAIS
		EndIf

		//No cadastro do cliente quem determina se o cliente © uma pessoa fisica ou juridica
		//seria o campo A1_PESSOA, no caso do Fornecedor seria o campo A2_TIPO.
		If cAlsSA=="SA1"
			If lHistTab .And. dDataDe <> NIL
				cCampo 	:= AllTrim(Substr(cCmpCgc,6,10))
				nPos 	:= ASCAN(aMod,{|x|alltrim(x[1])==cCampo })

				If len(aMod) >0 .And. nPos > 0
					If !(Alltrim(&(cCmpCgc)) == AllTrim(aMod[nPos][2])) .And. (aMod[nPos][3] > dDataAte)
						aAdd(aCGC,aMod[nPos][2])
					EndIF
				EndIf
			EndIf
			If len(aCGC) > 0
				aAdd (aA1A2, IIF(&(cAlsSA+"->A"+cA1A2+"_PESSOA")=="J" .And. &(cCmpEst)<>"EX",SPEDConvType(VldIE(aCGC[1],,.F.)),""))   		//04	-	CNPJ
				aAdd (aA1A2, IIF(&(cAlsSA+"->A"+cA1A2+"_PESSOA")=="F" .And. &(cCmpEst)<>"EX",SPEDConvType(VldIE(aCGC[1],,.F.)),""))	   		//05	-	CPF
			Else
				aAdd (aA1A2, IIF(&(cAlsSA+"->A"+cA1A2+"_PESSOA")=="J" .And. &(cCmpEst)<>"EX",SPEDConvType(VldIE(&(cCmpCgc),,.F.)),""))		//04	-	CNPJ
				aAdd (aA1A2, IIF(&(cAlsSA+"->A"+cA1A2+"_PESSOA")=="F" .And. &(cCmpEst)<>"EX",SPEDConvType(VldIE(&(cCmpCgc),,.F.)),""))		//05	-	CPF
			EndIf
		Else
			If lHistTab .And. dDataDe <> NIL
				cCampo 	:= AllTrim(Substr(cCmpCgc,6,10))
				nPos 	:= ASCAN(aMod,{|x|alltrim(x[1])==cCampo })

				If len(aMod) >0 .And. nPos > 0
					If !(Alltrim(&(cCmpCgc)) == AllTrim(aMod[nPos][2])) .And. (aMod[nPos][3] > dDataAte)
						aAdd(aCGC,aMod[nPos][2])
					EndIf
				EndIF
			EndIf

			If len(aCGC) > 0
				aAdd (aA1A2, IIF(&(cAlsSA+"->A"+cA1A2+"_TIPO")=="J",SPEDConvType(VldIE(aCGC[1],,.F.)),""))	 		//04	-	CNPJ
				aAdd (aA1A2, IIF(&(cAlsSA+"->A"+cA1A2+"_TIPO")=="F",SPEDConvType(VldIE(aCGC[1],,.F.)),""))	 		//05	-	CPF
			Else
				aAdd (aA1A2, IIF(&(cAlsSA+"->A"+cA1A2+"_TIPO")=="J",SPEDConvType(VldIE(&(cCmpCgc),,.F.)),""))		//04	-	CNPJ
				aAdd (aA1A2, IIF(&(cAlsSA+"->A"+cA1A2+"_TIPO")=="F",SPEDConvType(VldIE(&(cCmpCgc),,.F.)),""))		//05	-	CPF
			EndIf
		Endif

		If lHistTab .And. dDataDe <> NIL
			cCampo 	:= AllTrim(Substr(cCmpInsc,6,10))
			nPos 	:= ASCAN(aMod,{|x|alltrim(x[1])==cCampo })

			If len(aMod) >0 .And. nPos > 0
				If !(Alltrim(&(cCmpInsc)) == AllTrim(aMod[nPos][2])) .And. (aMod[nPos][3] > dDataAte)
					aAdd(aIE,aMod[nPos][2])
				EndIF
			EndIf
		EndIf

		If len(aIE) > 0
			aAdd(aA1A2, SPEDConvType(VldIE(aIE[1])))
		Else
			aAdd(aA1A2, SPEDConvType(VldIE(&(cCmpInsc))))																//06	-	IE
		EndIF

		If !("01058"$aA1A2[3]) .And. AllTrim(aA1A2[3]) <> ""
			aAdd (aA1A2, "9999999")																			   		//07	-	COD_MUN
		Else
			//Tratamento para o codigo de municipio, se nao possuir o codigo do estado, tenho de colocar
			If lHistTab .And. dDataDe <> NIL
				cCampo 	:= AllTrim(Substr(cCmpCodM,6,10))
				nPos 	:= ASCAN(aMod,{|x|alltrim(x[1])==cCampo })

				If len(aMod) >0 .And. nPos > 0
					If !(Alltrim(&(cCmpCodM)) == AllTrim(aMod[nPos][2])) .And. (aMod[nPos][3] > dDataAte)
						aAdd(aCodMun,aMod[nPos][2])
					EndIF
				EndIf
			EndIf

			If len(aCodMun) > 0
				If Len(Alltrim(aCodMun[1]))<=5
					aAdd (aA1A2, UfCodIBGE(&(cCmpEst))+Alltrim(aCodMun[1]))										//07	-	COD_MUN
					//Se possuir, considero como esta, desde que o estado nao seja "EX"
				Else
					aAdd (aA1A2, Iif (Upper(&(cCmpEst)) == "EX","9999999", aCodMun[1]))							//07	-	COD_MUN
				EndIf
			Else
				If Len(Alltrim(&(cCmpCodM)))<=5
					aAdd (aA1A2, If (Upper(&(cCmpEst)) == "EX","9999999",UfCodIBGE(&(cCmpEst))+Alltrim(&(cCmpCodM))))										//07	-	COD_MUN
					//Se possuir, considero como esta, desde que o estado nao seja "EX"
				Else
					aAdd (aA1A2, Iif (Upper(&(cCmpEst)) == "EX","9999999", &(cCmpCodM)))							//07	-	COD_MUN
				EndIf
			EndIf
		EndIf

		If lHistTab .And. dDataDe <> NIL
			cCampo 	:= AllTrim(Substr(cCmpSuframa,6,10))
			nPos 	:= ASCAN(aMod,{|x|alltrim(x[1])==cCampo })

			If len(aMod) >0 .And. nPos > 0
				If !(Alltrim(&(cCmpSuframa)) == AllTrim(aMod[nPos][2])) .And. (aMod[nPos][3] > dDataAte)
					aAdd(aSuframa,aMod[nPos][2])
				EndIF
			EndIf
		EndIf

		If Len(aSuframa)> 0
			aAdd (aA1A2,aSuframa[1])																				//08	-	SUFRAMA
		Else
			aAdd (aA1A2, SPEDConvType(Iif((cAlsSA)->(FieldPos(SubStr(cCmpSuframa,6)))>0,&(cCmpSuframa),"")))			//08	-	SUFRAMA
		EndIf

		If lHistTab .And. dDataDe <> NIL
			cCampo 	:= AllTrim(Substr(cCmpEnd,6,10))
			nPos 	:= ASCAN(aMod,{|x|alltrim(x[1])==cCampo })

			If len(aMod) >0 .And. nPos > 0
				If !(Alltrim(&(cCmpEnd)) == AllTrim(aMod[nPos][2])) .And. (aMod[nPos][3] > dDataAte)
					aAdd(aEnd,aMod[nPos][2])
				EndIF
			EndIf
		EndIf

		If Len(aEnd)> 0
			aAdd (aA1A2, SPEDConvType(MyGetEnd(aEnd[1],cAlsSA)[1]))													//09	-	END
			aAdd (aA1A2, Iif (!Empty(MyGetEnd(aEnd[1],cAlsSA)[2]),MyGetEnd(aEnd[1],cAlsSA)[3],"SN"))             //10	-	NUM
			aAdd (aA1A2, SPEDConvType(MyGetEnd(aEnd[1],cAlsSA)[4]))													//11    -   COMPL
		Else
			aAdd (aA1A2, SPEDConvType(MyGetEnd(&(cCmpEnd),cAlsSA)[1]))													//09	-	END
			aAdd (aA1A2, Iif (!Empty(MyGetEnd(&(cCmpEnd),cAlsSA)[2]),MyGetEnd(&(cCmpEnd),cAlsSA)[3],"SN"))		//10	-	NUM
			aAdd (aA1A2, SPEDConvType(MyGetEnd(&(cCmpEnd),cAlsSA)[4]))                                                //11    -   COMPL
		EndIf
		//Ponto de entrada para gerar informacoes do endereco e numero.
		If aExstBlck[01]
		 	aPart := ExecBlock("SPDFIS06", .F., .F., {cAlsSA})
			aA1A2[09] := aPart[01]
			aA1A2[10] := aPart[02]
		EndIf

		If lHistTab .And. dDataDe <> NIL
			cCampo 	:= AllTrim(Substr(cCmpBairro,6,10))
			nPos 	:= ASCAN(aMod,{|x|alltrim(x[1])==cCampo })

			If len(aMod) >0 .And. nPos > 0
				If !(Alltrim(&(cCmpBairro)) == AllTrim(aMod[nPos][2])) .And. (aMod[nPos][3] > dDataAte)
					aAdd(aBairro,aMod[nPos][2])
				EndIF
			EndIf
		EndIf

		If Len(aBairro)> 0
			aAdd (aA1A2,aBairro[1])
		Else
			aAdd (aA1A2, SPEDConvType(&(cCmpBairro)))											   						//12	-	BAIRRO
		EndIf
		aAdd (aA1A2, &(cCmpEst))														   					 		//13	-	UF
		aAdd (aA1A2, &(cCmpInscM))																			 		//14	-	InscMun
	EndIf

	//
	If lGrava0150
		If ValType(aReg0150) == "A"
			//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
			//REGISTRO 0150 - TABELA DE CADASTRO DE PARTICIPANTES
			//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
			If (nPos := aScan (aReg0150, {|aX| aX[3]==aA1A2[1]})==0)
				Reg0150 (@aReg0150, aA1A2,nRelacFil)
			EndIf

		EndIf
	EndIf

Return (aA1A2)


Static Function MyGetEnd(cEndereco,cAlias)

Local cCmpEndN	:= SubStr(cAlias,2,2)+"_ENDNOT"
Local cCmpEst	:= SubStr(cAlias,2,2)+"_EST"
Local aRet		:= {"",0,"",""}

//Campo ENDNOT indica que endereco participante mao esta no formato <logradouro>, <numero> <complemento>
//Se tiver com 'S' somente o campo de logradouro sera atualizado (numero sera SN)
If (&(cAlias+"->"+cCmpEst) == "DF") .Or. ((cAlias)->(FieldPos(cCmpEndN)) > 0 .And. &(cAlias+"->"+cCmpEndN) == "1")
	aRet[1] := cEndereco
	aRet[3] := "SN"
Else
	aRet := FisGetEnd(cEndereco,&(cAlias+"->"+cCmpEst))
EndIf

Return aRet

/*‘‹‘‹‘»±±
±±ºPrograma  GrRegDep  ºAutor  Erick G. Dias       º Data   21/03/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Gravao dos registros dependentes                         º±±
±±ˆ¼±*/
Static Function GrRegDep (cAlias, aRegPai, aRegFilho, lRegPaiDup, nRegEcf, lCtdtem, nFlag, nPai, lOrd0150)
	Local	lRet	:=	.T.
	Local	aReg	:=	{}
	Local	nCtd	:=	1
	Local	nZ		:=	0
	Local	nX		:=	0
	Local 	bRblSort:= {|x,y|x[1]<y[1]}
	Local 	bOrd0150:= {|x,y|x[9]<y[9]}
	Local 	nTamReg1:= 0

	DEFAULT lRegPaiDup 	:= .F.
	DEFAULT nRegEcf		:=  0
	DEFAULT lCtdtem		:=	.T.	//Tratamento para quando se tem mais de uma ocorrencia no subnivel. Ex. Registro 1100, 1105 e 1110
	DEFAULT nFlag		:=	0
	DEFAULT lOrd0150	:= .F.

	//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
	// Para o C405 precisa acrescentar a posicao 3 (data) no bloco de ordenacao 
	//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
 	If nRegEcf == 405
		If Len(aRegFilho) > 0 .AND. Len(aRegFilho[1]) > 0
			nTamReg1 := Len(STR(aRegFilho[1][1]))	// Pega a quantidade total de casas para depois acrescentar zeros
		EndIf
		bRblSort:= {|x,y| AllTrim( StrZero(x[1],nTamReg1)+DTOS(x[3])) < AllTrim(StrZero(y[1],nTamReg1)+DTOS(y[3])) }
	ElseIf nRegEcf == 420
		If Len(aRegFilho) > 0 .AND. Len(aRegFilho[1]) > 0
			nTamReg1 := Len(STR(aRegFilho[1][1]))	// Pega a quantidade total de casas para depois acrescentar zeros
		EndIf
		bRblSort:= {|x,y| AllTrim(StrZero(x[1],nTamReg1)+x[3]) < AllTrim(StrZero(y[1],nTamReg1)	+y[3]) }
	EndIf

    If nRegEcf <> 460
		If !lOrd0150
			aRegFilho  := Asort(aRegFilho,,,bRblSort)
		Else
			aRegFilho  := Asort(aRegFilho,,,bOrd0150)
		Endif
	EndIf

	For nZ := 1 To Len (aRegPai)
		If !lRegPaiDup
			PCGrvReg (cAlias, nZ, {aRegPai[nZ]},,nFlag,nPai,,,nTamTRBIt)
		Endif
		If Len(aRegFilho)>=1  .AND. nCtd <= Len(aRegFilho)
			Do While nCtd<=Len (aRegFilho) .And. (aRegFilho[nCtd][1]==nZ)
				aReg	:=	{}

				For nX := 2 To Len (aRegFilho[nCtd])
					aAdd (aReg, aRegFilho[nCtd][nX])
				Next (nX)

				PCGrvReg (cAlias, Iif(lCtdtem,nZ,aRegPai[nZ,1]) , {aReg}, Iif(lCtdtem,nCtd,aRegFilho[nCtd][1]), nFlag,nPai,,,nTamTRBIt)

				nCtd++
			EndDo
		EndIf
	Next (nZ)
Return (lRet)

/* ‘‹‘‹‘»±±
±±ºPrograma  TotContrib ºAutor  Erick G. Dias       º Data   11/04/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Retorna o total de contribuio no-cumulativa (PIS)       º±±
±±ˆ¼±±
*/
Static Function TotContrib (aRegM210, cIndNatJur,aRegM211,cIndTipCoo,cPer)

Local nCont 		:= 0
Local nVvContrib    := 0
Local nBaseM211		:= 0

For nCont := 1 to len(aRegM210)

	If cIndNatJur $ "01-04" // Se foi selecionado sociedade cooperativa na Wizard
		IF  aRegM210[nCont][2] $ "03/53" //Base © por unidade de medida de produto, o valor da base deve ser zero.
			RegM211(0, nCont, @aRegM211,cIndTipCoo,cPer,aRegM210[nCont][2],0)
		Else //Base em percentual, tenho que recalcular os valores, pois em M611 existe valores de exclusµes, que diminuem a base de c¡lculo.
			nBaseM211 := RegM211(aRegM210[nCont][4], nCont, @aRegM211,cIndTipCoo,cPer,aRegM210[nCont][2],aRegM210[nCont][5])
			aRegM210[nCont][4] := nBaseM211
			aRegM210[nCont][8] := Round((aRegM210[nCont][4] * aRegM210[nCont][5]) / 100,2)
			aRegM210[nCont][13] := aRegM210[nCont][8] + aRegM210[nCont][9] - aRegM210[nCont][10] - aRegM210[nCont][11] + aRegM210[nCont][12]
		EndiF
	EndIF

	//Somo somente valores de contribuio No Cumulativa
	IF aRegM210[nCont][2] $ SpdXRetCod(1,{"NC"})
		nVvContrib += aRegM210[nCont][13]
	EndIF
Next nCont

Return(nVvContrib)

/*‰‘‹‘‹‘»±±
±±ºPrograma  TotCntCOF ºAutor  Erick G. Dias       º Data   11/04/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Retorna o total de contribuio no-cumulativa (COFINS)    º±±
±±ˆ¼±*/
Static Function TotCntCOF (aRegM610, cIndNatJur,aRegM611,cIndTipCoo,cPer)

Local nCont 		:= 0
Local nVvContrib    :=0
Local nBaseM611		:= 0

For nCont := 1 to len(aRegM610)

	If cIndNatJur $ "01-04" // Se foi selecionado sociedade cooperativa na Wizard
		IF  aRegM610[nCont][2] $ "03/53" //Base © por unidade de medida de produto, o valor da base deve ser zero.
			RegM611(0, nCont, @aRegM611,cIndTipCoo,cPer, aRegM610[nCont][2],0)
		Else //Base em percentual, tenho que recalcular os valores, pois em M611 existe valores de exclusµes, que diminuem a base de c¡lculo.
			nBaseM611 := RegM611(aRegM610[nCont][4], nCont, @aRegM611,cIndTipCoo,cPer, aRegM610[nCont][2],aRegM610[nCont][5])
			aRegM610[nCont][4] := nBaseM611
			aRegM610[nCont][8] := Round((aRegM610[nCont][4] * aRegM610[nCont][5]) / 100,2)
			aRegM610[nCont][13] := aRegM610[nCont][8] + aRegM610[nCont][9] - aRegM610[nCont][10] - aRegM610[nCont][11] + aRegM610[nCont][12]
		EndIF
	EndIF
    //Somo somente valores de contribuio No Cumulativa
	IF aRegM610[nCont][2] $ SpdXRetCod(1,{"NC"})
		nVvContrib += aRegM610[nCont][13]
	EndIF
Next nCont

Return(nVvContrib)


/*‰‘‹‘‹‘»±±
±±ºPrograma  CredFutPISºAutor  Erick G. Dias       º Data   12/04/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Grava as informaµes dos cr©ditos que sero utilizados nos º±±
±±º    .      prximos per­odos.                                         º±±
±±ˆ¼*/
Static Function CredFutPIS(cPer,cCodCred, nTotCred,nCredUti,CredDisp,nCredExt,cRefer,nUtiAnt,nRessar,nComp,nRessaAnt,nCompAnt,cOri,cCnpj,cReserva)
Local	cAlias	:=	"CCY"
Local   lRefer  := aFieldPos[47] .And. aFieldPos[48] .And. aFieldPos[49]
Local   cChave  := xFilial(cAlias)+cPer+cCodCred
Local	cAno	:= ""
Local	cMes	:= ""
Local   lCG4	:= aIndics[23] .And. aFieldPos[50] .And. aFieldPos[51] .And. aFieldPos[52]	  .And. aFieldPos[53]
Local   lCNPJ   := aFieldPos[54]
Local   lOriCre := aFieldPos[55]
Local	 lResPis	:= aFieldPos[88]
Local   nTamANO  := If(lRefer,TamSx3("CCY_ANO")[1],0)
Local   nTamMES  := If(lRefer,TamSx3("CCY_MES")[1],0)
Local   nTamORIC := If(lOriCre, TamSx3("CCY_ORICRE")[1], 0)
Local   nTamCNPJ := If(lCNPJ,TamSx3("CCY_CNPJ")[1],0)

DEFAULT nCredExt := 0
DEFAULT cRefer   := ""
DEFAULT nUtiAnt	 := 0
DEFAULT nRessar	 := 0
DEFAULT nComp    := 0
DEFAULT nRessaAnt:= 0
DEFAULT nCompAnt := 0
DEFAULT cOri	 := Space(nTamORIC)
DEFAULT cCnpj	 := ""
DEFAULT cReserva	:= ""

If Empty(cCnpj)
	cCnpj	 := Space(nTamCNPJ)
EndIf

cAno	:= Iif(!Empty(cRefer),SubStr(cRefer,3,4),Space(nTamANO))
cMes	:= IIf(!Empty(cRefer),SubStr(cRefer,1,2),Space(nTamMES))
IF cOri <> "02"
	cOri := Space(nTamORIC)
EndIF

If lRefer
   cChave  	:= xFilial(cAlias)+cPer+cAno+cMes+cCodCred
   nUtiAnt	+= nCredUti
EndIf

If lCNPJ
   cChave  	:= xFilial(cAlias)+cPer+cAno+cMes+cOri+cCnpj+cCodCred
EndIF
If aIndics[04]
	dbSelectArea(cAlias)
    IF lCNPJ
		(cAlias)->(DbSetOrder (5))
    ElseIf lRefer
		(cAlias)->(DbSetOrder (3))
	Else
		(cAlias)->(DbSetOrder (1))
	EndIf
	If (cAlias)->( !MsSeek(cChave) )
		RecLock(cAlias,.T.)
		CCY->CCY_FILIAL	:=	xFilial(cAlias)
		CCY->CCY_PERIOD	:=	cPer
		CCY->CCY_COD	:=	cCodCred
		CCY->CCY_TOTCRD := nTotCred
		CCY->CCY_CREDUT := nCredUti
		CCY->CCY_CRDISP := CredDisp
		If aFieldPos[56]
			CCY->CCY_LEXTEM:= nCredExt
		EndIf
		If lCNPJ
			CCY->CCY_CNPJ:= cCnpj
		EndIf

		If lOriCre
			CCY->CCY_ORICRE:= cOri
		EndIf
        If lRefer
			CCY->CCY_ANO  	:= cAno
			CCY->CCY_MES  	:= cMes
			CCY->CCY_UTIANT := nUtiAnt
		EndIf
		If lCG4
			CCY->CCY_COMP 	:= nComp
			CCY->CCY_RESSA	:= nRessar
			CCY->CCY_COANTE	:= nCompAnt
			CCY->CCY_REANTE	:= nRessaAnt
		EndIf
		
		If lResPis
			CCY->CCY_RESCRE:= cReserva
		EndIf
		
		MsUnLock()
		(cAlias)->(FKCommit())
	Else
		//Se encontro registro de credito futuro para esta chave, devo acumular os valores de credito
		RecLock(cAlias,.F.)

		//Total de credito
		CCY->CCY_TOTCRD	+=	nTotCred

		//Credito Utilizado
		CCY->CCY_CREDUT	+=	nCredUti

		//Credito disponivel, que sera utilizado futuramente
		CCY->CCY_CRDISP	+=	CredDisp

		If aFieldPos[56]
			CCY->CCY_LEXTEM	+=	nCredExt
		EndIf

		If lRefer
			CCY->CCY_ANO	:=	cAno
			CCY->CCY_MES	:=	cMes
			CCY->CCY_UTIANT	+=	nUtiAnt
		EndIf

		If lCG4
			CCY->CCY_COMP	+=	nComp
			CCY->CCY_RESSA	+=	nRessar
			CCY->CCY_COANTE	+=	nCompAnt
			CCY->CCY_REANTE	+=	nRessaAnt
		EndIf
		
		If lResPis
			CCY->CCY_RESCRE:= cReserva
		EndIf

		MsUnLock()
		(cAlias)->(FKCommit())
	EndIf

EndIF

Return


/*‰‘‹‘‹‘»±±
±±ºPrograma  CredFutCOFºAutor  Erick G. Dias       º Data   12/04/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Grava as informaµes dos cr©ditos que sero utilizados nos º±±
±±º    .      prximos per­odos.                                         º±±
±±ˆ¼
*/
Static Function CredFutCOF(cPer, cCodCred, nTotCred,nCredUti,CredDisp,nCredExt,cRefer, nUtiAnt ,nRessar,nComp,nRessaAnt,nCompAnt,cOri,cCnpj,cReserva)
Local	cAlias	:=	"CCW"
Local   lRefer  := aFieldPos[57] .And. aFieldPos[58] .And. aFieldPos[59]
Local   cChave  := xFilial(cAlias)+cPer+cCodCred
Local	cAno	:= ""
Local	cMes	:= ""
Local   lCG4	:= aIndics[23] .And. aFieldPos[50] .And. aFieldPos[51] .And. aFieldPos[60] .And. aFieldPos[61]
Local   lCNPJ   := aFieldPos[62]
Local   lOriCre := aFieldPos[63]
Local	 lResCre	:= aFieldPos[89]
Local   nTamANO  := If(lRefer,TamSx3("CCW_ANO")[1],0)
Local   nTamMES  := If(lRefer,TamSx3("CCW_MES")[1],0)
Local   nTamORIC := If(lOriCre,TamSx3("CCW_ORICRE")[1],0)
Local   nTamCNPJ := If(lCNPJ,TamSx3("CCW_CNPJ")[1],0)

DEFAULT nCredExt := 0
DEFAULT cRefer   := ""
DEFAULT nUtiAnt	 := 0
Default nComp	 := 0
Default nRessar	 := 0
Default nCompAnt := 0
Default nRessaAnt:= 0
DEFAULT cOri	 := Space(nTamORIC)
DEFAULT cCnpj	 := ""
DEFAULT cReserva	:= ""

If Empty(cCnpj)
	cCnpj	 := Space(nTamCNPJ)
EndIf

cAno	:= Iif(!Empty(cRefer),SubStr(cRefer,3,4),Space(nTamANO))
cMes	:= IIf(!Empty(cRefer),SubStr(cRefer,1,2),Space(nTamMES))
IF cOri <> "02"
	cOri := Space(nTamORIC)
EndIF

If lRefer
   cChave  := xFilial(cAlias)+cPer+cAno+cMes+cCodCred
   nUtiAnt += nCredUti
EndIf

If lCNPJ
   cChave  	:= xFilial(cAlias)+cPer+cAno+cMes+cOri+cCnpj+cCodCred
EndIF
If aIndics[02] // AliasIndic(cAlias)
	dbSelectArea(cAlias)
    IF lCNPJ
		(cAlias)->(DbSetOrder (5))
    ElseIf lRefer
		(cAlias)->(DbSetOrder (3))
	Else
		(cAlias)->(DbSetOrder (1))
	EndIf
	If (cAlias)->( !MsSeek( cChave ) )
		RecLock(cAlias,.T.)
		CCW->CCW_FILIAL	:=	xFilial(cAlias)
		CCW->CCW_PERIOD	:=	cPer
		CCW->CCW_COD	:=	cCodCred
		CCW->CCW_TOTCRD := 	nTotCred
		CCW->CCW_CREDUT :=	nCredUti
		CCW->CCW_CRDISP :=	CredDisp
		If aFieldPos[64]
			CCW->CCW_LEXTEM	:= nCredExt
		EndIf
		If lCNPJ
			CCW->CCW_CNPJ:= cCnpj
		EndIf

		If lOriCre
			CCW->CCW_ORICRE:= cOri
		EndIf
        If lRefer
			CCW->CCW_ANO	:= cAno
			CCW->CCW_MES	:= cMes
			CCW->CCW_UTIANT := nUtiAnt
		EndIf
		If lCG4
			CCW->CCW_COMP 	:= nComp
			CCW->CCW_RESSA	:= nRessar
			CCW->CCW_COANTE	:= nCompAnt
			CCW->CCW_REANTE	:= nRessaAnt
		EndIf
		
		If lResCre
			CCW->CCW_RESCRE	:= cReserva
		EndIf
		
		
		MsUnLock()
		(cAlias)->(FKCommit())
	Else
		//Se encontro registro de credito futuro para esta chave, devo acumular os valores de credito
		RecLock(cAlias,.F.)

		//Total de credito
		CCW->CCW_TOTCRD	+=	nTotCred

		//Credito Utilizado
		CCW->CCW_CREDUT	+=	nCredUti

		//Credito disponivel, que sera utilizado futuramente
		CCW->CCW_CRDISP	+=	CredDisp

		If aFieldPos[64]
			CCW->CCW_LEXTEM:= nCredExt
		EndIf

		If lRefer
			CCW->CCW_ANO	:=	cAno
			CCW->CCW_MES	:=	cMes
			CCW->CCW_UTIANT	+=	nUtiAnt
		EndIf

		If lCG4
			CCW->CCW_COMP	+=	nComp
			CCW->CCW_RESSA	+=	nRessar
			CCW->CCW_COANTE	+=	nCompAnt
			CCW->CCW_REANTE	+=	nRessaAnt
		EndIf

		If lResCre
			CCW->CCW_RESCRE	:= cReserva
		EndIf
		
		MsUnLock()
		(cAlias)->(FKCommit())
	EndIf

EndIF

Return


/*‰‘‹‘‹‘»±±
±±ºPrograma  RetFutPIS ºAutor  Erick G. Dias       º Data   25/05/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Grava as informaµes de retencoes que sero utilizados nos º±±
±±º    .      prximos per­odos.                                         º±±
±±ˆ¼*/
Static Function RetFutPIS(cPer, cNat, nTotRet,RetDisp, cIndCumu, cPerAtu, nValUsar,lProcAnt)
Local	cAlias	:=	"SFV"

If aIndics[26] // AliasIndic(cAlias)
    (cAlias)->(DbSetOrder (1))
	dbSelectArea(cAlias)

	If !MsSeek(xFilial(cAlias)+cNat+cPer+cIndCumu)
		RecLock(cAlias,.T.)
		SFV->FV_FILIAL	:=	xFilial(cAlias)
		SFV->FV_NATRET	:=	cNat
		SFV->FV_PER	    :=	cPer
		SFV->FV_TOTRET  :=  nTotRet
		SFV->FV_VLDISP  :=  RetDisp
		SFV->FV_TPREG   :=  cIndCumu
		MsUnLock()
		SFV->(FKCommit())
	Else
	   RecLock(cAlias,.F.)
        IIf( lProcAnt, SFV->FV_TOTRET  := nTotRet, SFV->FV_TOTRET  += nTotRet)
        SFV->FV_VLDISP  := RetDisp
        MsUnLock()
        SFV->(FKCommit())
	EndIf
	lChave  := IIF(GetAdvFVal("SFV","FV_MESANO",xFilial(cAlias)+cNat+cIndCumu+cPer+cPerAtu,2) == cPerAtu,.T.,.F.)
	If (nTotRet-RetDisp) > 0 .And. lProcAnt //.AND. cPerAtu <> cPer
    	RecLock(cAlias,.T.)
        SFV->FV_FILIAL  :=  xFilial(cAlias)
        SFV->FV_NATRET  :=  cNat
        SFV->FV_PER     :=  cPer
        SFV->FV_TOTRET  :=  nTotRet
        SFV->FV_VLDISP  :=  RetDisp
        SFV->FV_TPREG   :=  cIndCumu
        SFV->FV_APURPER :=  nValUsar
        SFV->FV_MESANO  :=  cPerAtu
        MsUnLock()
        SFV->(FKCommit())
	Elseif lChave .And. !lProcAnt //.And. (nTotRet-RetDisp) > 0
		(cAlias)->(DbSetOrder (2))
		dbSelectArea(cAlias)
		If MsSeek(xFilial(cAlias)+cNat+cIndCumu+cPer+cPerAtu)
			RecLock(cAlias,.F.)
			SFV->FV_TOTRET  += nTotRet
			SFV->FV_VLDISP  := RetDisp
			SFV->FV_APURPER += nValUsar
			MsUnLock()
			SFV->(FKCommit())
		EndIf
	EndIf
EndIF

Return


/*‰‘‹‘‹‘»±±
±±ºPrograma  RetFutCOF ºAutor  Erick G. Dias       º Data   25/05/11   º±±
±±ºDesc.      Grava as informaµes de retencoes que sero utilizados nos º±±
±±º    .      prximos per­odos.                                         º±±
±±ˆ¼*/
Static Function RetFutCOF(cPer, cNat, nTotRet,RetDisp, cIndCumu, cPerAtu, nValUsar,lProcAnt)
Local   cAlias  :=  "SFW"

If aIndics[27] // AliasIndic(cAlias)
    (cAlias)->(DbSetOrder (1))
    dbSelectArea(cAlias)

    If !MsSeek(xFilial(cAlias)+cNat+cPer+cIndCumu)
        RecLock(cAlias,.T.)
        SFW->FW_FILIAL  :=  xFilial(cAlias)
        SFW->FW_NATRET  :=  cNat
        SFW->FW_PER :=  cPer
        SFW->FW_TOTRET := nTotRet
        SFW->FW_VLDISP := RetDisp
        SFW->FW_TPREG := cIndCumu
        MsUnLock()
        SFW->(FKCommit())
    Else
        RecLock(cAlias,.F.)
        IIf( lProcAnt, SFW->FW_TOTRET := nTotRet, SFW->FW_TOTRET += nTotRet)
        SFW->FW_VLDISP := RetDisp
        MsUnLock()
        SFW->(FKCommit())
    EndIf
    lChave  := IIF(GetAdvFVal("SFW","FW_MESANO",xFilial(cAlias)+cNat+cIndCumu+cPer+cPerAtu,2) == cPerAtu,.T.,.F.)
    If (nTotRet-RetDisp) > 0 .AND. lProcAnt//.AND. cPerAtu <> cPer
            RecLock(cAlias,.T.)
            SFW->FW_FILIAL  :=  xFilial(cAlias)
            SFW->FW_NATRET  :=  cNat
            SFW->FW_PER     :=  cPer
            SFW->FW_TOTRET  :=  nTotRet
            SFW->FW_VLDISP  :=  RetDisp
            SFW->FW_TPREG   :=  cIndCumu
            SFW->FW_APURPER :=  nValUsar
            SFW->FW_MESANO  :=  cPerAtu
            MsUnLock()
            SFW->(FKCommit())
	Elseif lChave .And. !lProcAnt //.And. (nTotRet-RetDisp) > 0
		(cAlias)->(DbSetOrder (2))
		dbSelectArea(cAlias)
		If MsSeek(xFilial(cAlias)+cNat+cIndCumu+cPer+cPerAtu)
			RecLock(cAlias,.F.)
			SFW->FW_TOTRET  += nTotRet
			SFW->FW_VLDISP  := RetDisp
			SFW->FW_APURPER += nValUsar
			MsUnLock()
			SFW->(FKCommit())
		EndIf
    EndIf

EndIF

Return

/*‰‘‹‘‹‘»±±
±±ºPrograma  CredAntPisºAutor  Erick G. Dias       º Data   18/04/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Processa cr©ditos de pis dos meses anteriores.             º±±
±±ˆ¼
*/
Static Function CredAntPis(cPer,aReg1100,nTotContrb,lMesAtual,cCodCred,cCodCredEx)

Local cAliasCCY :="CCY"
Local dPriDia	:=firstday(sTod(cPer))-1
Local cPerAnt := cvaltochar(strzero(month(dPriDia),2)) + cvaltochar(year(dPriDia ))
Local cPerAtu := cvaltochar(strzero(month(sTod(cPer) ) ,2)) + cvaltochar(year(sTod(cPer) ))
Local cCnpj   := ""
Local cOriCre := ""
Local nCredUti		:=0  //Credito Utilizado
Local lRefer    := aFieldPos[47] .And. aFieldPos[48]  .And. aFieldPos[49]
Local cRefer    := ""
Local cOrderBy  := "%ORDER BY CCY.CCY_PERIOD, CCY.CCY_COD%"
Local nUtil		:= 0
Local lCG4		:= aIndics[23] .And. aFieldPos[50] .And. aFieldPos[51] .And. aFieldPos[52]  .And. aFieldPos[53]
Local nRessar	:= 0
Local nComp		:= 0
Local nRessaAnt	:= 0
Local nCompAnt	:= 0
Local cMV_BCCR	:= aParSX6[37]
Local cMV_BCCC	:= aParSX6[38]
Local lCNPJ    := aFieldPos[54]
Local nVlCrd1100 := 0
Local lReserPis  := aFieldPos[88] //Define se utiliza ou no o Cr©dito 
Local cResPis	   := ""

DEFAULT lMesAtual :=.F.
DEFAULT cCodCred  :=""
DEFAULT cCodCredEx := ""
//Se houver algum cdigo em cCodCredEx, so cdigos que no iro se apropriar do cr©dito, somente ir¡ gerar 1100 e transportar seu valor para prximo mªs.

If lMesAtual
	cPerAnt:=cPerAtu
EndIf

DbSelectArea (cAliasCCY)

If lRefer
	(cAliasCCY)->(DbSetOrder (3))
Else
	(cAliasCCY)->(DbSetOrder (1))
EndIf

#IFDEF TOP
    If (TcSrvType ()<>"AS/400")
    	cAliasCCY	:=	GetNextAlias()

    	cFiltro := "%"
       	cCampos := "%"
       	If lMesAtual .And. aFieldPos[56]
    		cFiltro += "CCY.CCY_LEXTEM = 0 AND"
	    	cCampos += ", CCY.CCY_LEXTEM"
    	EndIf
   		//Se houver cdigo em cCodCred ento dever¡ trazer somente os valores de cr©ditos deste cdigo, obedecendo a ordem definida pelo cliente.
   		If Len(cCodCred) > 0
    		cFiltro += "CCY.CCY_COD = '"  +cCodCred+  "' AND "
   		EndIF

        If lRefer
        	cCampos += ", CCY.CCY_UTIANT, CCY.CCY_ANO, CCY.CCY_MES "
        	cOrderBy  := "%ORDER BY CCY.CCY_PERIOD, CCY.CCY_ANO, CCY.CCY_MES , CCY.CCY_COD%"
		EndIf
		IF lCNPJ
        	cCampos += ", CCY.CCY_CNPJ, CCY.CCY_ORICRE"
		EnDIF
		If lCG4 //Valores de ressarcimento e compensao
        	cCampos += ", CCY.CCY_REANTE, CCY.CCY_COANTE, CCY.CCY_RESSA ,CCY.CCY_COMP "
		EndIf
		IF lReserPis //Define se utiliza ou no o Cr©dito neste per­odo
	        	cCampos += ", CCY.CCY_RESCRE"
		EnDIF
		cFiltro += "%"
		cCampos += "%"

    	BeginSql Alias cAliasCCY

			SELECT
				CCY.CCY_PERIOD, CCY.CCY_COD, CCY.CCY_TOTCRD, CCY.CCY_CREDUT, CCY.CCY_CRDISP, CCY.CCY_LEXTEM
				%Exp:cCampos%
			FROM
				%Table:CCY% CCY
			WHERE
				CCY.CCY_FILIAL=%xFilial:CCY% AND
				CCY.CCY_PERIOD  = %Exp:cPerAnt% AND
				CCY.CCY_CRDISP > 0 AND
				%Exp:cFiltro%
				CCY.%NotDel%

			%Exp:cOrderBy%

		EndSql
	Else
#ENDIF
	    cIndex	:= CriaTrab(NIL,.F.)
	    cFiltro	:= 'CCY_FILIAL=="'+xFilial ("CCY")+'".And.'
	   	cFiltro += 'CCY_CRDISP > 0 .AND. CCY_PERIOD =="'+ cPerAnt + '"'
   	   	If lMesAtual .And. aFieldPos[56]
		   	cFiltro += ' .AND. CCY_LEXTEM = 0'
		EndIf
		If Len(cCodCred) > 0
		   	cFiltro += ' .AND. CCY_COD == "' +cCodCred + '"'
    	EndIF
      	    IndRegua (cAliasCCY, cIndex, CCY->(IndexKey ()),, cFiltro)
      	    nIndex := RetIndex(cAliasCCY)

		#IFNDEF TOP
			DbSetIndex (cIndex+OrdBagExt ())
		#ENDIF

		DbSelectArea (cAliasCCY)
	    DbSetOrder (nIndex+1)
#IFDEF TOP
	Endif
#ENDIF

DbSelectArea (cAliasCCY)
(cAliasCCY)->(DbGoTop ())
ProcRegua ((cAliasCCY)->(RecCount ()))
Do While !(cAliasCCY)->(Eof ())
    //Verifico se utilizar¡ ou no o cr©dito neste periodo
	If lReserPis
	    cResPis := (cAliasCCY)->CCY_RESCRE
	EndIf   
    IF !(cAliasCCY)->CCY_COD $ cCodCredEx
	    If lRefer
	        cRefer 	:= (cAliasCCY)->CCY_MES + (cAliasCCY)->CCY_ANO
	        nUtil	:= (cAliasCCY)->CCY_UTIANT
	    Else
	      	cRefer 	:= cPerAnt
	      	nUtil	:= (cAliasCCY)->CCY_CREDUT
	    EndIf
	    If lCG4 .And. !lMesAtual
	    	If CG4->(MsSeek(xFilial("CG4")+"0"+cPerAtu+cRefer+(cAliasCCY)->CCY_COD ))
	    		If ( CG4->CG4_VALORR + CG4->CG4_VALORC ) <= (cAliasCCY)->CCY_CRDISP
		    		If Alltrim((cAliasCCY)->CCY_COD)$cMV_BCCR
		    	   		nRessar := CG4->CG4_VALORR
		    	   	EndIf
		    	   	If Alltrim((cAliasCCY)->CCY_COD)$cMV_BCCC
		    	   		nComp	:= CG4->CG4_VALORC
		    	   	EndIf
		    	EndIf
	    	EndIf
	        nRessaAnt	:= (cAliasCCY)->CCY_REANTE + (cAliasCCY)->CCY_RESSA
	        nCompAnt	:= (cAliasCCY)->CCY_COANTE + (cAliasCCY)->CCY_COMP
	    EndIf
	    IF lCNPJ
			cCnpj	:=(cAliasCCY)->CCY_CNPJ
			cOriCre :=(cAliasCCY)->CCY_ORICRE
			IF Empty(cOriCre)
				cOriCre:= "01"
			EndIF
	    EndIF

	   // Tratamento para que o registro 1100 seja gerado com os valores dos creditos extemporaneos.
	   If (cAliasCCY)->CCY_TOTCRD > 0
	   		nVlCrd1100 := (cAliasCCY)->CCY_TOTCRD
	  	Else
	  		nVlCrd1100 := (cAliasCCY)->CCY_LEXTEM
	  	EndIf

		Reg1100(@aReg1100,cPerAnt,cCnpj,(cAliasCCY)->CCY_COD,nVlCrd1100,nUtil,@Iif(lMesAtual,0,nTotContrb),@nCredUti,cPerAtu,lMesAtual,0,0,cRefer,nRessar,nComp,nRessaAnt,nCompAnt,cOriCre,cResPis)
	EndIF
	(cAliasCCY)->(DbSkip ())
	nRessar		:= 0
	nComp		:= 0
	nRessaAnt	:= 0
	nCompAnt	:= 0
EndDo

#IFDEF TOP
	If (TcSrvType ()<>"AS/400")
		DbSelectArea (cAliasCCY)
		(cAliasCCY)->(DbCloseArea ())
	Else
#ENDIF
		RetIndex("CCY")
#IFDEF TOP
	EndIf
#ENDIF

Return

/*‰‘‹‘‹‘»±±
±±ºPrograma  DescPisAntºAutor  Erick G. Dias       º Data   18/04/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Calcula tota de cr©ditos do mes anterior e abate em M200.  º±±
±±ˆ¼*/
Static Function DescPisAnt(aReg1100,aRegM200)

Local nCont 	:= 0
Local nVlDesc   := 0

For nCont := 1 to len(aReg1100)
	nVlDesc += aReg1100[nCont][13]
Next nCont

aRegM200[1][4] := nVlDesc

Return()


/*‰‘‹‘‹‘»±±
±±ºPrograma  DescCofAntºAutor  Erick G. Dias       º Data   18/04/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Calcula tota de cr©ditos do mes anterior e abate em M600.  º±±
±±ˆ¼*/
Static Function DescCofAnt(aReg1500,aRegM600)

Local nCont 		:= 0
Local nVlDesc    :=0

For nCont := 1 to len(aReg1500)
	nVlDesc += aReg1500[nCont][13]
Next nCont

aRegM600[1][4] := nVlDesc

Return()



/*‰‘‹‘‹‘»±±
±±ºPrograma  CredAntCofºAutor  Erick G. Dias       º Data   18/04/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Processa cr©ditos de cofins dos meses anteriores.          º±±
±±ˆ¼±*/
Static Function CredAntCof(cPer,aReg1500,nTotContrb, lMesAtual,cCodCred,cCodCredEx)

Local cAliasCCW :="CCW"
Local dPriDia	:=firstday(sTod(cPer))-1
Local cPerAnt := cvaltochar(strzero(month(dPriDia),2)) + cvaltochar(year(dPriDia))
Local cPerAtu := cvaltochar(strzero(month(sTod(cPer) ) ,2)) + cvaltochar(year(sTod(cPer) ))
Local cCnpj   := ""
Local cOriCre := ""
Local nCredUti		:=0  //Credito Utilizado
Local lRefer    := aFieldPos[57]	 .And. aFieldPos[58]	 .And. aFieldPos[59]
Local cRefer    := ""
Local cOrderBy  := "%ORDER BY CCW.CCW_PERIOD, CCW.CCW_COD%"
Local nUtil		:= 0
Local lCG4		:= aIndics[23] .And. aFieldPos[50]	.And. aFieldPos[51] .And. aFieldPos[60] .And. aFieldPos[61]
Local nRessar	:= 0
Local nComp		:= 0
Local nRessaAnt	:= 0
Local nCompAnt	:= 0
Local cMV_BCCR	:= aParSX6[37]
Local cMV_BCCC	:= aParSX6[38]
Local lCNPJ    := aFieldPos[62]
Local nVlCrd1500 := 0
Local lReserCof  := aFieldPos[89] //Define se utiliza ou no o Cr©dito 
Local cResCof	   := ""

Default lMesAtual:= .F.
DEFAULT cCodCred  	:=""
DEFAULT cCodCredEx 	:= ""

If lMesAtual
	cPerAnt :=cPerAtu
EndIF

DbSelectArea (cAliasCCW)

If lRefer
	(cAliasCCW)->(DbSetOrder (3))
Else
	(cAliasCCW)->(DbSetOrder (1))
EndIf

#IFDEF TOP
    If (TcSrvType ()<>"AS/400")
    	cAliasCCW	:=	GetNextAlias()

	    cFiltro := "%"
    	cCampos := "%"
       	If lMesAtual .And. aFieldPos[64]
    		cFiltro += "CCW.CCW_LEXTEM = 0 AND"
	    	cCampos += ", CCW.CCW_LEXTEM"
    	EndIf
   		//Se houver cdigo em cCodCred ento dever¡ trazer somente os valores de cr©ditos deste cdigo, obedecendo a ordem definida pelo cliente.
   		If Len(cCodCred) > 0
    		cFiltro += "CCW.CCW_COD = '"  +cCodCred+  "' AND "
   		EndIF
		If lRefer
        	cCampos += ", CCW.CCW_UTIANT, CCW.CCW_ANO, CCW.CCW_MES "
        	// Fao da forma abaixo transformar MMAAAA em AAAAMM para que a ordem fique correta. Exemplo: 11/2012,12/2011,01/2012,02/2012
        	cOrderBy  := "%ORDER BY CCW.CCW_PERIOD, CCW.CCW_ANO, CCW.CCW_MES , CCW.CCW_COD%"
		EndIf
		IF lCNPJ
        	cCampos += ", CCW.CCW_CNPJ, CCW.CCW_ORICRE"
		EnDIF
		If lCG4 //Valores de ressarcimento e compensao
        	cCampos += ", CCW.CCW_REANTE, CCW.CCW_COANTE, CCW.CCW_RESSA ,CCW.CCW_COMP "
		EndIf
		IF lReserCof //Define se utiliza ou no o Cr©dito neste per­odo
	        	cCampos += ", CCW.CCW_RESCRE"
		EnDIF

		cFiltro += "%"
    	cCampos += "%"

    	BeginSql Alias cAliasCCW

			SELECT
				CCW.CCW_PERIOD, CCW.CCW_COD, CCW.CCW_TOTCRD, CCW.CCW_CREDUT, CCW.CCW_CRDISP, CCW_LEXTEM
				%Exp:cCampos%
			FROM
				%Table:CCW% CCW
			WHERE
				CCW.CCW_FILIAL=%xFilial:CCW% AND
				CCW.CCW_PERIOD  = %Exp:cPerAnt% AND
				CCW.CCW_CRDISP > 0 AND
				%Exp:cFiltro%
				CCW.%NotDel%

			%Exp:cOrderBy%

		EndSql
	Else
#ENDIF
	    cIndex	:= CriaTrab(NIL,.F.)
	    cFiltro	:= 'CCW_FILIAL=="'+xFilial ("CCW")+'".And.'
	   	cFiltro += 'CCW_CRDISP > 0 .AND. CCW_PERIOD =="'+ cPerAnt + '"'
	   	If lMesAtual .And. aFieldPos[64]
		   	cFiltro += ' .AND. CCW_LEXTEM = 0'
		EndIf
   		If Len(cCodCred) > 0
		   	cFiltro += ' .AND. CCW_COD == "' +cCodCred + '"'
    	EndIF
	    IndRegua (cAliasCCW, cIndex, CCW->(IndexKey ()),, cFiltro)
	    nIndex := RetIndex(cAliasCCW)

		#IFNDEF TOP
			DbSetIndex (cIndex+OrdBagExt ())
		#ENDIF

		DbSelectArea (cAliasCCW)
	    DbSetOrder (nIndex+1)
#IFDEF TOP
	Endif
#ENDIF

DbSelectArea (cAliasCCW)
(cAliasCCW)->(DbGoTop ())
ProcRegua ((cAliasCCW)->(RecCount ()))
Do While !(cAliasCCW)->(Eof ())
    IF !(cAliasCCW)->CCW_COD $ cCodCredEx
	    //Verifico se utilizar¡ ou no o cr©dito neste periodo
	If lReserCof
		cResCof := (cAliasCCW)->CCW_RESCRE
	EndIf  
	    
	    If lRefer
	        cRefer 	:= (cAliasCCW)->CCW_MES + (cAliasCCW)->CCW_ANO
	        nUtil	:= (cAliasCCW)->CCW_UTIANT
	    Else
	      	cRefer := cPerAnt
	        nUtil	:= (cAliasCCW)->CCW_CREDUT
	    EndIf
	    If lCG4 .And. !lMesAtual
	    	If CG4->(MsSeek(xFilial("CG4")+"1"+cPerAtu+cRefer+(cAliasCCW)->CCW_COD ))
	    		If ( CG4->CG4_VALORR + CG4->CG4_VALORC ) <= (cAliasCCW)->CCW_CRDISP
		    		If Alltrim((cAliasCCW)->CCW_COD)$cMV_BCCR
		    	   		nRessar := CG4->CG4_VALORR
		    	   	EndIf
		    	   	If Alltrim((cAliasCCW)->CCW_COD)$cMV_BCCC
		    	   		nComp	:= CG4->CG4_VALORC
		    	   	EndIf
		    	EndIf
	    	EndIf
	        nRessaAnt	:= (cAliasCCW)->CCW_REANTE + (cAliasCCW)->CCW_RESSA
	        nCompAnt	:= (cAliasCCW)->CCW_COANTE + (cAliasCCW)->CCW_COMP
	    EndIf

	    IF lCNPJ
			cCnpj	:=(cAliasCCW)->CCW_CNPJ
			cOriCre :=(cAliasCCW)->CCW_ORICRE
			IF Empty(cOriCre)
				cOriCre:= "01"
			EndIF
	    EndIF


	   // Tratamento para que o registro 1500 seja gerado com os valores dos creditos extemporaneos.
	   If (cAliasCCW)->CCW_TOTCRD > 0
	   		nVlCrd1500 := (cAliasCCW)->CCW_TOTCRD
	  	Else
	  		nVlCrd1500 := (cAliasCCW)->CCW_LEXTEM
	  	EndIf

		Reg1500(@aReg1500,cPerAnt,cCnpj,(cAliasCCW)->CCW_COD,nVlCrd1500,nUtil,@Iif(lMesAtual,0,nTotContrb),@nCredUti,cPerAtu,lMesAtual,0,0,cRefer,nRessar,nComp,nRessaAnt,nCompAnt,cOriCre,cResCof)
	EndIF
	(cAliasCCW)->(DbSkip ())
	nRessar		:= 0
	nComp		:= 0
	nRessaAnt	:= 0
	nCompAnt	:= 0
EndDo


#IFDEF TOP
	If (TcSrvType ()<>"AS/400")
		DbSelectArea (cAliasCCW)
		(cAliasCCW)->(DbCloseArea ())
	Else
#ENDIF
		RetIndex("CCW")
#IFDEF TOP
	EndIf
#ENDIF

Return

/*‰‘‹‘‹‘»±±
±±ºPrograma  IniCredAntºAutor  Erick G. Dias       º Data   19/04/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Zera os valores das tabelas CCY e CCW, para fazer o        º±±
±±º           processamento dos cr©ditos no M~es corrente.               º±±
±±ˆ¼*/
Static Function IniCredAnt(cPer)

Local cAliasCCY :="CCY"
Local cAliasCCW :="CCW"
Local cPerAtu := cvaltochar(strzero(month(sTod(cPer) ) ,2)) + cvaltochar(year(sTod(cPer) ))
Local LCCYORICRE := aFieldPos[55] .AND.  aFieldPos[63]
Local lDelet	 := .T.

DbSelectArea (cAliasCCW)
(cAliasCCW)->(DbSetOrder (1))
(cAliasCCW)->(DbGoTop ())

ProcRegua ((cAliasCCW)->(RecCount ()))

If (cAliasCCW)->( MsSeek(xFilial("CCW")+cPerAtu) )
	Do While (cAliasCCW)->(!Eof())	.And. (cAliasCCW)->( CCW_FILIAL==xFilial("CCW") .And. CCW_PERIOD==cPerAtu )
		lDelet := .T.
  		IF LCCYORICRE .AND.	(cAliasCCW)->CCW_ORICRE=="02"
			lDelet := .F. //No deletar, pois lanamento na CCY com este cdigo igula a 02 foi digitado pelo usu¡rio
	  	EndIF
		IF lDelet
			RecLock(cAliasCCW,.F.)
			(cAliasCCW)->(dbDelete())
			MsUnLock()
			(cAliasCCW)->(FKCommit())
		EndIF
		(cAliasCCW)->(DbSkip ())
	EndDo
EndIf

DbSelectArea (cAliasCCY)
(cAliasCCY)->(DbSetOrder (1))
(cAliasCCY)->(DbGoTop ())

ProcRegua ((cAliasCCY)->(RecCount ()))

If (cAliasCCY)->( MsSeek(xFilial("CCY")+cPerAtu) )
	Do While !(cAliasCCY)->(Eof ())	.And. (cAliasCCY)->( CCY_FILIAL==xFilial("CCY") .And. CCY_PERIOD==cPerAtu )
		lDelet := .T.
		IF LCCYORICRE .AND.	(cAliasCCY)->CCY_ORICRE=="02"
			lDelet := .F. //No deletar, pois lanamento na CCY com este cdigo igula a 02 foi digitado pelo usu¡rio
		EndIF
		IF lDelet
			RecLock(cAliasCCY,.F.)
			(cAliasCCY)->(dbDelete())
			MsUnLock()
			(cAliasCCY)->(FKCommit())
		EndIF
		(cAliasCCY)->(DbSkip ())
	EndDo
EndIf

Return

/*‰‘‹‘‹‘»±±
±±ºPrograma  IniRetdAntºAutor  Erick G. Dias       º Data   25/05/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Zera os valores das tabelas CCY e CCW, para fazer o        º±±
±±º           processamento dos cr©ditos no M~es corrente.               º±±
±±ˆ¼*/
Static Function IniRetAnt(cPer)

Local cAliasSFV :="SFV"
Local cAliasSFW :="SFW"
Local cAlias	:=	"SFW"
Local aAreaSFV	:= {}
Local aAreaSFW	:= {}
Local cPerAtu := cvaltochar(strzero(month(sTod(cPer) ) ,2)) + cvaltochar(year(sTod(cPer) ))

DbSelectArea (cAliasSFW)
(cAliasSFW)->(DbSetOrder (1))
#IFDEF TOP
    If (TcSrvType ()<>"AS/400")
    	cAliasSFW	:=	GetNextAlias()

	    cFiltro := "%"
    	cCampos := "%"
    	BeginSql Alias cAliasSFW

			SELECT
				SFW.FW_PER, SFW.FW_NATRET, SFW.FW_TOTRET, SFW.FW_VLDISP,SFW.FW_TPREG
				%Exp:cCampos%
			FROM
				%Table:SFW% SFW
			WHERE
				SFW.FW_FILIAL=%xFilial:SFW% AND
				SFW.FW_PER  = %Exp:cPerAtu% AND
				%Exp:cFiltro%
				SFW.%NotDel%
		EndSql
	Else
#ENDIF
	    cIndex	:= CriaTrab(NIL,.F.)
	    cFiltro	:= 'FW_FILIAL=="'+xFilial ("SFW")+'".And.'
	   	cFiltro += 'FW_PER=="'+ cPerAtu +'"'

	    IndRegua (cAliasSFW, cIndex, SFW->(IndexKey ()),, cFiltro)
	    nIndex := RetIndex(cAliasSFW)

		#IFNDEF TOP
			DbSetIndex (cIndex+OrdBagExt ())
		#ENDIF

		DbSelectArea (cAliasSFW)
#IFDEF TOP
	Endif
#ENDIF

DbSelectArea (cAliasSFW)
(cAliasSFW)->(DbGoTop ())
ProcRegua ((cAliasSFW)->(RecCount ()))
dbSelectArea(cAlias)
Do While !(cAliasSFW)->(Eof ())
	aAreaSFW:= SFW->(GetArea())
	If MsSeek(xFilial("SFW")+(cAliasSFW)->FW_NATRET+(cAliasSFW)->FW_PER+(cAliasSFW)->FW_TPREG)
		RecLock(cAlias,.F.)
		SFW->FW_TOTRET := 0
		SFW->FW_VLDISP := 0
		MsUnLock()
		SFW->(FKCommit())
	EndIF
	RestArea(aAreaSFW)
	(cAliasSFW)->(DbSkip ())
EndDo

#IFDEF TOP
	If (TcSrvType ()<>"AS/400")
		DbSelectArea (cAliasSFW)
		(cAliasSFW)->(DbCloseArea ())
	Else
#ENDIF
		RetIndex("SFW")
		FErase(cIndex+OrdBagExt ())
#IFDEF TOP
	EndIf
#ENDIF

//SFV
DbSelectArea (cAliasSFV)
(cAliasSFV)->(DbSetOrder (1))
#IFDEF TOP
    If (TcSrvType ()<>"AS/400")
    	cAliasSFV	:=	GetNextAlias()

	    cFiltro := "%"
    	cCampos := "%"
    	BeginSql Alias cAliasSFV

			SELECT
				SFV.FV_PER, SFV.FV_NATRET, SFV.FV_TOTRET, SFV.FV_VLDISP ,SFV.FV_TPREG
				%Exp:cCampos%
			FROM
				%Table:SFV% SFV
			WHERE
				SFV.FV_FILIAL=%xFilial:SFV% AND
				SFV.FV_PER  = %Exp:cPerAtu% AND
				%Exp:cFiltro%
				SFV.%NotDel%
		EndSql
	Else
#ENDIF
	    cIndex	:= CriaTrab(NIL,.F.)
	    cFiltro	:= 'FV_FILIAL=="'+xFilial ("SFV")+'".And.'
	   	cFiltro += 'FV_PER=="'+ cPerAtu +'"'

	    IndRegua (cAliasSFV, cIndex, SFV->(IndexKey ()),, cFiltro)
	    nIndex := RetIndex(cAliasSFV)

		#IFNDEF TOP
			DbSetIndex (cIndex+OrdBagExt ())
		#ENDIF

		DbSelectArea (cAliasSFV)
#IFDEF TOP
	Endif
#ENDIF


cAlias := "SFV"
DbSelectArea (cAliasSFV)
(cAliasSFV)->(DbGoTop ())
ProcRegua ((cAliasSFV)->(RecCount ()))
dbSelectArea(cAlias)
Do While !(cAliasSFV)->(Eof ())
	aAreaSFV:= SFV->(GetArea())
	If MsSeek(xFilial("SFV")+(cAliasSFV)->FV_NATRET+(cAliasSFV)->FV_PER+(cAliasSFV)->FV_TPREG)
		RecLock(cAlias,.F.)
		SFV->FV_TOTRET := 0
		SFV->FV_VLDISP := 0
		MsUnLock()
		SFV->(FKCommit())
	EndIF
	RestArea(aAreaSFV)
	(cAliasSFV)->(DbSkip ())
EndDo

#IFDEF TOP
	If (TcSrvType ()<>"AS/400")
		DbSelectArea (cAliasSFV)
		(cAliasSFV)->(DbCloseArea ())
	Else
#ENDIF
		RetIndex("SFV")
		FErase(cIndex+OrdBagExt ())
#IFDEF TOP
	EndIf
#ENDIF

Return

/*‘‹‘‹‘»±±
±±ºPrograma  RegM220   ºAutor  Erick G. Dias       º Data   05/05/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Processamento do registro M220                             º±±
±±ˆ¼±*/

Static Function RegM220(aRegM220,lAcrescimo,nPosM210, nValAjuste,nCodAjus,cNumDoc,cData,cDescricao,cOrigem,cDescDevol)

Local nPos 			:= 0
Local nPosM220		:= 0
Local cDescr		:= ""
Local cIndAj		:= ""

DEFAULT cDescricao	:= ""
DEFAULT cData		:= ""
DEFAULT cNumDoc		:= ""
DEFAULT cOrigem		:= ""
DEFAULT cDescDevol	:= ""

//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//Opµes do cOrigem:                                               
//F700 - Quando existe uma deduo diversa cadastrada pelo usu¡rio;
//RI - Quando existe tratamento de Receita Indicada;               
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™

cIndAj		:= iIf(lAcrescimo,"1","0")
If cOrigem == "F700"
	cDescr	:= cDescricao+ " em " + substr(cData,1,2) + "/" + substr(cData,3,2)+ "/" + substr(cData,5,4)
ElseIF cOrigem == "RI"
	cDescr	:= cDescricao
Else
	cDescr	:= cDescDevol //"Devoluo da nota fiscal " + cNumDocOri
EndIF

nPosM220 := aScan (aRegM220, {|aX| aX[1]==nPosM210 .AND. aX[3]==cIndAj .AND. aX[5]==nCodAjus  .AND. aX[6]==cNumDoc  .AND. aX[7]==cDescr })

If nPosM220 == 0

	aAdd(aRegM220, {})
	nPos := Len(aRegM220)

	aAdd (aRegM220[nPos], nPosM210)
	aAdd (aRegM220[nPos], "M220")			   		//01 - REG
	aAdd (aRegM220[nPos], cIndAj)		//02 - IND_AJ
	aAdd (aRegM220[nPos], nValAjuste)				//03 - VL_AJ
	aAdd (aRegM220[nPos], nCodAjus)				    //04 - COD_AJ
	aAdd (aRegM220[nPos], cNumDoc)				    //05 - NUM_DOC
	aAdd (aRegM220[nPos], cDescr) //06 - DESCR_AJ - Descricao utilizada no campo FT_OBSERV, desnecessario posicionar a tabela
	aAdd (aRegM220[nPos], cData) //07 - DT_REF

Else
	aRegM220[nPosM220][4] += nValAjuste
EndIF
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} RegM225
Processamento do registro RegM225

@param  aRegM225  - Array com informaµes do registro RegM225
	    aRegM220  - Array com informaµes do registro M220

@author Simone dos Santos de Oliveira
@since 02.05.2014
@version 11.80
/*/
//-------------------------------------------------------------------
Static Function RegM225(aRegM225,aRegM220)

Local nPos 		:= 0
Local nX  		:= 0

Local cNumDoc   := ""

Default aCF3 := {}

For nX:= 1 to Len(aRegM220)

	cNumDoc := aRegM220[nX][6]

	aAdd(aRegM225, {})
	nPos := Len(aRegM225)
	//Registro M225
	aAdd (aRegM225[nPos], nX)	   					//01 - REG DO PAI
	aAdd (aRegM225[nPos], "M225")					//02 - REG
	aAdd (aRegM225[nPos], aRegM220[nX][4])			//03 - DET_VALOR_AJ
	aAdd (aRegM225[nPos], "")	   					//04 - CST_PIS
	aAdd (aRegM225[nPos], "")		   				//05 - DET_BC_CRED
	aAdd (aRegM225[nPos], "")						//06 - DET_ALIQ
	aAdd (aRegM225[nPos], aRegM220[nX][8])			//07 - DT_OPER_AJ
	aAdd (aRegM225[nPos], aRegM220[nX][7])			//08 - DESC_AJ
	aAdd (aRegM225[nPos], "")						//09 - COD_CTA
	aAdd (aRegM225[nPos], "")						//10 - INFO_COMPL

Next(nX)

Return


/*±±ºPrograma  RegM620   ºAutor  Erick G. Dias       º Data   05/05/11   º±±
±±ºDesc.      Processamento do registro M620                             º±±*/

Static Function RegM620(aRegM620,lAcrescimo,nPosM610, nValAjuste,nCodAjus,cNumDoc,cData,cDescricao,cOrigem,cDescDevol)

Local nPos := 0
Local nPosM620	:= 0
lOCAL cDescr		:= ""
lOCAL cIndAj		:= ""

DEFAULT cDescricao	:= ""
DEFAULT cData			:= ""
DEFAULT cNumDoc		:= ""
DEFAULT cOrigem		:= ""
DEFAULT cDescDevol	:= ""
//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//Opµes do cOrigem:                                               
//F700 - Quando existe uma deduo diversa cadastrada pelo usu¡rio;
//RI - Quando existe tratamento de Receita Indicada;               
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™

cIndAj		:= iIf(lAcrescimo,"1","0")
If cOrigem == "F700"
	cDescr	:= cDescricao+ " em " + substr(cData,1,2) + "/" + substr(cData,3,2)+ "/" + substr(cData,5,4)
ElseIF cOrigem == "RI"
	cDescr	:= cDescricao
Else
	cDescr	:= cDescDevol //"Devoluo da nota fiscal " + cNumDocOri
EndIF
nPosM620 := aScan (aRegM620, {|aX| aX[1]==nPosM610 .AND. aX[3]==cIndAj .AND. aX[5]==nCodAjus  .AND. aX[6]==cNumDoc  .AND. aX[7]==cDescr })

IF nPosM620 == 0

	aAdd(aRegM620, {})
	nPos := Len(aRegM620)
	aAdd (aRegM620[nPos], nPosM610)
	aAdd (aRegM620[nPos], "M620")			   		//01 - REG
	aAdd (aRegM620[nPos], cIndAj)		//02 - IND_AJ
	aAdd (aRegM620[nPos], nValAjuste)				//03 - VL_AJ
	aAdd (aRegM620[nPos], nCodAjus)				    //04 - COD_AJ
	aAdd (aRegM620[nPos], cNumDoc)				    //05 - NUM_DOC
	aAdd (aRegM620[nPos], cDescr) //06 - DESCR_AJ - Descricao utilizada no campo FT_OBSERV, desnecessario posicionar a tabela
	aAdd (aRegM620[nPos], cData) //07 - DT_REF

Else
	aRegM620[nPosM620][4] += nValAjuste
EndIF
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} RegM625
Processamento do registro RegM625

@param  aRegM625  - Array com informaµes do registro RegM625
	    aRegM620  - Array com informaµes do registro M620

@author Simone dos Santos de Oliveira
@since 02.05.2014
@version 11.80
/*/
//-------------------------------------------------------------------
Static Function RegM625(aRegM625,aRegM620)

Local nPos 		:= 0
Local nX  		:= 0

Local cNumDoc   := ""

Default aCF3 := {}

For nX:= 1 to Len(aRegM620)

	cNumDoc := aRegM620[nX][6]

	aAdd(aRegM625, {})
	nPos := Len(aRegM625)
	//Registro M625
	aAdd (aRegM625[nPos], nX)	   					//01 - REG DO PAI
	aAdd (aRegM625[nPos], "M625")					//02 - REG
	aAdd (aRegM625[nPos], aRegM620[nX][4])			//03 - DET_VALOR_AJ
	aAdd (aRegM625[nPos], "")	   					//04 - CST_PIS
	aAdd (aRegM625[nPos], "")		   				//05 - DET_BC_CRED
	aAdd (aRegM625[nPos], "")						//06 - DET_ALIQ
	aAdd (aRegM625[nPos], aRegM620[nX][8])			//07 - DT_OPER_AJ
	aAdd (aRegM625[nPos], aRegM620[nX][7])			//08 - DESC_AJ
	aAdd (aRegM625[nPos], "")						//09 - COD_CTA
	aAdd (aRegM625[nPos], "")						//10 - INFO_COMPL

Next(nX)

Return

/*‰‘‹‘‹‘»±±
±±ºPrograma   RegF100   ºAutor  Erick G. Dias       º Data   10/05/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Processamento do registro F100                             º±±
±±ˆ¼±±
±±Parametros aRegF100  -> Array com valores para gravao do registro   ±±
±±           				F120.                                         ±±
±±           aF100Aux  -> Alias da query com valores de depreciao     ±±
±±           			 	do per­odo.                                   ±±
±±           aRegM210  -> Array com valores para gerao  registro 0500 ±±
±±           			 	Plano de contas.                              ±±
±±           aRegM610  -> Array com valores para gerao  registro 0600 ±±
±±           			    centro de custo.                              ±±
±±           aRegM105  -> Array com valores de cr©ditos de PIS que sero±±
±±           			    gerados no registro M105.                     ±±
±±           aRegM505  -> Array com valores de cr©ditos de Cofins       ±±
±±           			    que sero gerados no registro M505.           ±±
±±           cRegime   -> Indica qual o regime do contribuinte          ±±
±±           			   Cumulativo, no cumulativo ou ambos.           ±±
±±           cIndApro  -> Indica o m©todo de apropriao, se © rateio   ±±
±±           			 	proporcional ou apropriao direta.           ±±
±±           aReg0111  -> Array com valores das receitas brutas do      ±±
±±           			 	per­ido.                                      ±±
±±           aReg0150  -> Array com valores do registro 0150            ±±
±±           dDataDe   -> Data inicial do per­odo                       ±±
±±           dDataAte  -> Data final do per­odo                         ±±
±±           nRelacFil -> Relao com filial processada                 ±±
±±           cFil      -> Cdigo da filial que chamou esta funo.      ±±
±±           aRegM400  -> Informaµes do array M400                     ±±
±±           aRegM410  -> Informaµes do array M410       			  ±±
±±           aRegM800  -> Informaµes do array M800       			  ±±
±±           aRegM810  -> Informaµes do array M810       			  ±±
±±           lSpdP09   -> Indica se o Ponto de entrada SPDPIS09 existe  ±±
±±          aReg0500	 -> Array com informaµes do registro 0500(Plano  ±±
±±                        de contas).                                   ±±
±±          aReg0600	 -> Array com informaµes do registro 0600(Centro ±±
±±                        de Custo.                                     ±±
±±ˆ¼*/
Static Function RegF100(aRegF100,	aF100Aux,	aRegM210,	aRegM610,	aRegM105,;
						aRegM505,	cRegime,	cIndApro,	aReg0111,	aReg0150,;
						dDataDe,	dDataAte,	nRelacFil, 	cFil, 		aRegM400,;
						aRegM410,	aRegM800,	aRegM810,	lSpdP09,	aReg0500,;
						aRegM230,	aRegM630,	aReg0600,	aReg0200,	aReg0190,;
						aReg0205,	lRgCmpCons,	aRegF550,	aRegF560,	aReg1900,;
						aRegF111,	aReg1010,	aReg1020,	aRegF559,	aRegF569,;
						lFilSCP,	aAjCredSCP,	aAjusteR,	aAjusteA,	cRegime,;
						cIndNatJur)


Local cIndOper		:= ""
Local nPos			:= 0
Local nPosF100		:= 0
Local cCodPart		:= ""
Local cLoja			:= ""
Local cAlsSA		:= ""
Local x         	:= 0
Local w         	:= 0
Local y				:= 0
Local cCstCred		:= "50#51#52#53#54#55#56#60#61#62#63#64#65#66"  //CSTs de cr©dito
Local cCstTrib		:= "01#02#03#05"  //CSts tribut¡veis
Local cCstNTrib		:="04#06#07#08#09#49#99" //CSts no tribut¡veis
Local aPartDoc		:= {}
Local aProd			:= {}
Local aPEF100		:= {}
Local aPar0500		:= {}
Local aPar0600		:= {}
Local cIndOrig		:= ""
Local cIndex		:= ""
Local nValLiq 		:= 0
Local nDif			:= 0
Local nSaldo		:= 0
Local nDifer		:= 0
Local cChaveCCX		:= ""
local aAliasB1		:= {}
Local cAliasSB1		:=  "SB1"
Local aPEF100Aux	:=	{}
Local aParFil		:=	{}
Local lAchouCF8		:=	.F.
Local cAliasCF8		:=	"CF8"
Local cDtOperCF8	:=	""
Local lNatRecCF8	:=	aFieldPos[39]
Local lPart		:=	aFieldPos[65]
Local aParF550		:= {}
Local cConta		:= {}
Local cInfComp		:= ""
Local cSituaDoc		:= ""
Local lAchouCCF		:= .F.
Local nPosF550		:= 0
Local nValPis		:= 0
Local nValCof		:= 0
Local nBasPis		:= 0
Local nBasCof		:= 0
Local nVlDesc		:= 0
Local lCumulativ	:=	.F.
Local lPauta      := .F.

DEFAULT lRgCmpCons	:= .F.
DEFAULT aRegF111	:= {}
DEFAULT aReg1010	:= {}
DEFAULT aReg1020	:= {}
DEFAULT cIndNatJur	:= ""

For nPosF100 :=1 to Len(aF100Aux)

	cCodPart	:= aF100Aux[nPosF100][17]
	aPartDoc	:= {}
	cAlsSA		:= ""

	If aF100Aux[nPosF100][3] $ cCstCred
		cIndOper := "0"
	ElseIf aF100Aux[nPosF100][3] $ cCstTrib
		cIndOper := "1"
	ElseIf aF100Aux[nPosF100][3] $ cCstNTrib
		cIndOper := "2"
	EndIF

		
	IF Len(aF100Aux[nPosF100])>=32 .and. aF100Aux[nPosF100][32] == "P"	
			cAlsSA   := "SA2"
	Elseif Len(aF100Aux[nPosF100])>=32 .and. aF100Aux[nPosF100][32] == "R"
			cAlsSA   := "SA1"
	Else
		IF cIndOper == "0" // Movimentao de entrada, irei buscar na SA2 - Fornecedor
			cAlsSA   := "SA2"
		Else // Se for venda, irei buscar cliente na SA1
			cAlsSA   := "SA1"
		EndIF
	Endif
		
		
	IF !lRgCmpCons //Ir¡ gerar F100 somente se for regime de competencia detalhado

		IF !Empty(cCodPart)
			If (cAlsSA)->(MsSeek (xFilial(cAlsSA)+cCodPart))
				aPartDoc	:=	InfPartDoc (cAlsSA,@aReg0150,.F.,dDataDe, dDataAte,nRelacFil)
				If len(aPartDoc) >0
					If  aScan (aReg0150, {|aX| aX[3]==aPartDoc[1]})==0
						Reg0150 (@aReg0150, aPartDoc,nRelacFil)
					EndIf
				EndIf
			EndIf
		EndIf

		cCodPart:= Iif( Len(aPartDoc)>0,aPartDoc[1],"")
		cIndOrig:= Iif( Len(aPartDoc)>0,(Iif(aPartDoc[3]=="01058","0","1")),"")

		aAdd(aRegF100, {})
		nPos := Len(aRegF100)
		aAdd (aRegF100[nPos], "F100")										//01 - REG
		aAdd (aRegF100[nPos], cIndOper)				   						//02 - IND_OPER
		aAdd (aRegF100[nPos], cCodPart)				   						//03 - COD_PART
		aAdd (aRegF100[nPos], "")											//04 - COD_ITEM
		aAdd (aRegF100[nPos], Substr( aF100Aux[nPosF100][1],7,2)  +Substr( aF100Aux[nPosF100][1],5,2) +Substr( aF100Aux[nPosF100][1],1,4))				   		//05 - DT_OPER
		aAdd (aRegF100[nPos], aF100Aux[nPosF100][2])				   		//06 - VL_OPER
		aAdd (aRegF100[nPos], aF100Aux[nPosF100][3])				   		//07 - CST_PIS
		aAdd (aRegF100[nPos], aF100Aux[nPosF100][4])				   		//08 - VL_BC_PIS
		aAdd (aRegF100[nPos], aF100Aux[nPosF100][5])				   		//09 - ALIQ_PIS
		aAdd (aRegF100[nPos], aF100Aux[nPosF100][6])				   		//10 - VL_PIS
		aAdd (aRegF100[nPos], aF100Aux[nPosF100][7])				   		//11 - CST_COFINS
		aAdd (aRegF100[nPos], aF100Aux[nPosF100][8])				   		//12 - VL_BC_COFINS
		aAdd (aRegF100[nPos], aF100Aux[nPosF100][9])				   		//13 - ALIQ_COFINS
		aAdd (aRegF100[nPos], aF100Aux[nPosF100][10])		    		   	//14 - VL_COFINS
		aAdd (aRegF100[nPos], aF100Aux[nPosF100][11])				   		//15 - NAT_BC_CRED
		aAdd (aRegF100[nPos], cIndOrig )							   		//16 - IND_ORIG_CRED
		aAdd (aRegF100[nPos], Iif(Len(aF100Aux[nPosF100])>22 , Reg0500(aReg0500,aF100Aux[nPosF100][23],,,.F.) , "") )	    //17 - COD_CTA
		aAdd (aRegF100[nPos], Iif(Len(aF100Aux[nPosF100])>23 , Reg0600(aReg0600,aF100Aux[nPosF100][24]       ) , "") ) 		//18 - COD_CCUS
		aAdd (aRegF100[nPos], Iif(len(aF100Aux[nPosF100]) >=29,aF100Aux[nPosF100][29],"" ))	//DESC_DOC_OPER

		IF len(aF100Aux[nPosF100]) > 27 .AND. !Empty(aF100Aux[nPosF100][27]) .AND. !Empty(aF100Aux[nPosF100][28])
			aAdd(aRegF111, {})
			nPos	:=	Len (aRegF111)
			aAdd (aRegF111[nPos], Len(aRegF100))
			aAdd (aRegF111[nPos], "F111") 												//01-REG
			aAdd (aRegF111[nPos], aF100Aux[nPosF100][27]) 			   					//02-NUM_PROC
			aAdd (aRegF111[nPos], aF100Aux[nPosF100][28]) 			   					//03-IND_PROC

	        lAchouCCF	:=	CCF->(MsSeek (xFilial ("CCF")+aF100Aux[nPosF100][27]+aF100Aux[nPosF100][28] ))

			If	lAchouCCF
				If CCF->CCF_TPCOMP == "1" //Complemento do processo referenciado - Judicial
					Reg1010(@aReg1010)
				ElseIf CCF->CCF_TPCOMP == "2" //Complemento do processo referenciado - Administrativo
					Reg1020(@aReg1020)
				EndIf
			Endif
		EndIF
	EndIf

    IF lRgCmpCons .AND. cIndOper <> "0"
		//Se houver a posio 30 (flag de cancelado) e no for cancelado ir¡ gerar F500
		//Verifica se existe a posio 30, se existir e estiver igual a .T., ento esta operao © cancelada.
		cSituaDoc:= "00" //Regular
		If len(aF100Aux[nPosF100]) >=30 .AND. aF100Aux[nPosF100][30]
			cSituaDoc:= "02"//cancelado

		EndIF

		IF !cSituaDoc== "02" //Se no for cancelado
			//Aqui no regime de competencia consolodado ser¡ utilizado os mesmos valores que iriam gerar F100, por©m sero gerados no F550/F560 e filhos.
			aParF550	:= {}
			lPauta		:= .F.
			cConta		:= ""
		EndIf

		IF aF100Aux[nPosF100][3] == "03" .OR. aF100Aux[nPosF100][7] == "03"
			lPauta	:= .T.
		EndIF

		nVlDesc	:= 0
		nBasPis	:= aF100Aux[nPosF100][4]
		nValPis	:= aF100Aux[nPosF100][6]
		nBasCof	:= aF100Aux[nPosF100][8]
		nValCof	:= aF100Aux[nPosF100][10]

			//Verifica se existe valor de excluso da base de c¡lculo de PIS e COFINS
		IF Len(aF100Aux[nPosF100])>=31
			nVlDesc	:= aF100Aux[nPosF100][31]
			nBasPis	:= nBasPis - nVlDesc
			nValPis	:= Round(nBasPis*aF100Aux[nPosF100][5]/100,2)
			nBasCof	:= nBasCof - nVlDesc
			nValCof	:= Round(nBasCof*aF100Aux[nPosF100][9]/100,2)
		EndIF

		aAdd(aParF550,Iif (lPauta,"F560","F550"))
		aAdd(aParF550,aF100Aux[nPosF100][2])
		aAdd(aParF550,aF100Aux[nPosF100][3])
		aAdd(aParF550,nVlDesc) 					//Excluso
		aAdd(aParF550,nBasPis) 			   		//Base de C¡lculo do PIS
		aAdd(aParF550,aF100Aux[nPosF100][5]) 	//Al­quota do PIS
		aAdd(aParF550,nValPis)					//Valor do Pis
		aAdd(aParF550,aF100Aux[nPosF100][7])
		aAdd(aParF550,nVlDesc) 			   		//Excluso
		aAdd(aParF550,nBasCof)					//Base de Calculo COFINS
		aAdd(aParF550,aF100Aux[nPosF100][9])   //Al­quota da COFINS
		aAdd(aParF550,nValCof)  				//Valor da Cofins
		aAdd(aParF550,"")
		aAdd(aParF550,"")
		cConta	:= Reg0500(@aReg0500,Iif(Len(aF100Aux[nPosF100])>22 , Reg0500(aReg0500,aF100Aux[nPosF100][23]) , "") )
		aAdd(aParF550, cConta)
		aAdd(aParF550,"")
		aAdd(aParF550,aF100Aux[nPosF100][18])
		aAdd(aParF550,aF100Aux[nPosF100][19])
		aAdd(aParF550,aF100Aux[nPosF100][20])
		aAdd(aParF550,aF100Aux[nPosF100][21])

		//Gera registros F550/F560 e filhos
  		nPosF550	:= 0
  		RegimeComp(@aRegF550,@aRegF560,@aRegM210,@aRegM610,aParF550,lPauta,@aRegM400,@aRegM410,@aRegM800,@aRegM810,.F.,.F.,.F.,;
  					{},{},{},{},{},.T.,,@aRegM230,@aRegM630,,,,,cChaveCCX,@nPosF550)

		IF len(aF100Aux[nPosF100]) > 27 .AND. !Empty(aF100Aux[nPosF100][27]) .AND. !Empty(aF100Aux[nPosF100][28]) .AND. nPosF550 > 0

			If lPauta
				aAdd(aRegF569, {})
				nPos	:=	Len (aRegF569)
				aAdd (aRegF569[nPos], nPosF550) 										//Relao com F560
				aAdd (aRegF569[nPos], "F569") 												//01-REG
				aAdd (aRegF569[nPos], aF100Aux[nPosF100][27]) 			   					//02-NUM_PROC
				aAdd (aRegF569[nPos], aF100Aux[nPosF100][28]) 			   					//03-IND_PROC
			Else
				aAdd(aRegF559, {})
				nPos	:=	Len (aRegF559)
				aAdd (aRegF559[nPos], nPosF550) 										//Relao com F550
				aAdd (aRegF559[nPos], "F559") 												//01-REG
				aAdd (aRegF559[nPos], aF100Aux[nPosF100][27]) 			   					//02-NUM_PROC
				aAdd (aRegF559[nPos], aF100Aux[nPosF100][28]) 			   					//03-IND_PROC
			EndIF

	        lAchouCCF	:=	CCF->(MsSeek (xFilial ("CCF")+aF100Aux[nPosF100][27]+aF100Aux[nPosF100][28] ))

			If	lAchouCCF
				If CCF->CCF_TPCOMP == "1" //Complemento do processo referenciado - Judicial
					Reg1010(@aReg1010)
				ElseIf CCF->CCF_TPCOMP == "2" //Complemento do processo referenciado - Administrativo
					Reg1020(@aReg1020)
				EndIf
			Endif
		EndIF

		cInfComp	:= "Operao "
		If aF100Aux[nPosF100][3] $ "01#02#03#05#04#06#07#08#09#49#99"
			IF aF100Aux[nPosF100][15] == "SE1"
				SE1->(dbGoto( aF100Aux[nPosF100][16]))
				cInfComp 	+="referente o T­tulo :" + SE1->E1_NUM
			ElseIF aF100Aux[nPosF100][15] == "SE5"
				SE5->(dbGoto( aF100Aux[nPosF100][16]))
				cInfComp 	+="referente o T­tulo :" + SE5->E5_NUMERO
			ElseIF aF100Aux[nPosF100][15] == "SEI"
				SEI->(dbGoto( aF100Aux[nPosF100][16]))
				cInfComp 	+="referente a Aplicao :" + SEI->EI_NUMERO
			EndIF
		EndIF
		//Acumula valores no registro 1900
		Reg1900Com (@aReg1900,"99", cConta, cSituaDoc,SM0->M0_CGC,"", aF100Aux[nPosF100][2],aF100Aux[nPosF100][3],aF100Aux[nPosF100][7], "", cInfComp)

	EndIF

    //Verifica cumulatividade
	lCumulativ	:=	Iif ( aF100Aux[nPosF100][14] == "0", .T. , .F. )

	// --- Ajustes para Sociedade em Conta de Participacao ---
	If lFilSCP .And. !(cIndNatJur$"03#04#05")

		//Processamento dos documentos de entrada
		If 	cIndOper == "0"

			//Chamada com opcao 2 -> Gera os ajustes de credito, registros M110 e M510
			SpedXAjSCP(2,aF100Aux[nPosF100],@aAjCredSCP,,lCumulativ,cRegime,dDataAte)

			//Chamada com opcao 3 -> Gera os ajustes de contribuicao dos registros M210 e M610 de SCP (71 e 72)
			//atraves dos ajustes de credito gerados anteriormente
			SpedXAjSCP(3,aF100Aux[nPosF100],@aAjusteR,,lCumulativ,cRegime,dDataAte)
		Endif

		//Processamento dos documentos de saida
		If cIndOper <> "0" .AND. aF100Aux[nPosF100][6] >0 .AND. aF100Aux[nPosF100][10] >0

			//Chamado com opcao 1 -> Gera os ajustes de contribuicao, registro M210 e M610
			SpedXAjSCP(1,aF100Aux[nPosF100],@aAjusteR,@aAjusteA,lCumulativ,cRegime,dDataAte)
		Endif
	Endif

	IF !lRgCmpCons

		If aF100Aux[nPosF100][3] $ cCstCred	//CST de PIS de cr©dito
			AcumM105(aRegM105,,cRegime,lCumulativ,cIndApro,aReg0111,.T., aRegF100[nPos])
		Else //Se no ser¡ CST de Contribuio
			RegM210(aRegM210,,cRegime,lCumulativ,{},{}, .T.,aRegF100[nPos],@aRegM230,,,cChaveCCX)
		EndIF

		If aF100Aux[nPosF100][7] $ cCstCred	//CST de Cofins de cr©dito
			AcumM505(aRegM505,,cRegime,lCumulativ,cIndApro,aReg0111,.T., aRegF100[nPos])
		Else //Se no ser¡ CST de Contribuio
			RegM610(aRegM610,,cRegime,lCumulativ,{},{}, .T.,aRegF100[nPos],@aRegM630,,,cChaveCCX)
		EndIF

		If aF100Aux[nPosF100][3] $ "04#06#07#08#09" .OR. (aF100Aux[nPosF100][3]== "05" .AND. aF100Aux[nPosF100][5] == 0)
			If Len(aRegF100[nPos]) >17
				RegM400(@aRegM400,@aRegM410,,,aF100Aux[nPosF100])
			EndIF
		EndIF

		If aF100Aux[nPosF100][7] $ "04#06#07#08#09" .OR. (aF100Aux[nPosF100][7]== "05" .AND. aF100Aux[nPosF100][9] == 0)
			If Len(aRegF100[nPos]) >17
				RegM800(@aRegM800,@aRegM810,,,aF100Aux[nPosF100])
			EndIF
		EndIF
	EndIF

Next nPosF100
//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//Se existir a tabela CF8, a rotina ir¡ gerar o registro F100 com as informaµes cadastradas manualmente pelo usu¡rio.
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
If aIndics[20]

	aAdd(aParFil,DTOS(dDataDe))
	aAdd(aParFil,DTOS(dDataAte))

	//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
	//Funo que ir¡ retornar alias com valores da tabela CF8 referente ao per­odo e filial corrente.
	//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
	If (lAchouCF8	:=	SPEDFFiltro(1,"CF8",@cAliasCF8,aParFil))

		ProcRegua ((cAliasCF8)->(RecCount ()))
		Do While !(cAliasCF8)->(Eof ())
		    IF !lRgCmpCons

				cCodPart	:= 	""
				aPartDoc	:= 	{}
				cLoja		:= 	""
				cAlsSA		:= 	""
				cProd		:= 	""
				cCodPart 	:=	(cAliasCF8)->CF8_CLIFOR
				cLoja	 	:=	(cAliasCF8)->CF8_LOJA
				cDtOperCF8	:=	""

				//Se o campo CF8_PART existi, ento ele ir¡ definir se buscar cliente ou fornecedro
				If lPart .AND. !Empty((cAliasCF8)->CF8_PART)
					If (cAliasCF8)->CF8_PART == "1"  // Indica Clinente
						cAlsSA   := "SA1"
					Else
						cAlsSA   := "SA2"
					EndIF
				Else
					If (cAliasCF8)->CF8_INDOPE == "0" // Indicar operao com direito a cr©dito, operao de aquisio(entrada)
						cAlsSA   := "SA2"
					Else
						cAlsSA   := "SA1"
					EndIF
				EndIF

				//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
				//Ir¡ gerar registro 0150 para o participante.
				//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
				IF !Empty(cAlsSA)
					If (cAlsSA)->(MsSeek (xFilial(cAlsSA)+cCodPart+cLoja))
						aPartDoc	:=	InfPartDoc (cAlsSA,@aReg0150,.F.,dDataDe, dDataAte,nRelacFil)
						If len(aPartDoc) >0
							If  aScan (aReg0150, {|aX| aX[3]==aPartDoc[1]})==0
								Reg0150 (@aReg0150, aPartDoc,nRelacFil)
							EndIf
						EndIF
					EndIF
				EndIF

				//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
				//Ir¡ gerar registro 0200 para o item .
				//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
				If !Empty((cAliasCF8)->CF8_ITEM)
					cProd	 := (cAliasCF8)->CF8_ITEM+iIF(lConcFil,xFilial("SB1"),"")
					IF aExstBlck[03]
						aProd := Execblock("SPEDPROD", .F., .F., {"CF8","F100"})
						If Len(aProd)==11
							cProd 	:= 	aProd[1]
						Else
							aProd := {"","","","","","","","","","",""}
						EndIf
					EndIF
				Endif

				If !Empty(cProd)
					aAliasB1 := SB1->(GetArea())
					If (cAliasSB1)->(MsSeek (xFilial ("SB1")+(cAliasCF8)->CF8_ITEM))
						If aScan(aReg0200,{|aX| aX[3]==cProd}) == 0
					   		Reg0200("",@aReg0200,@aReg0190,dDataDe,dDataAte,,cProd,,@aReg0205,.F.,cAliasSB1)
					 	EndIf
						//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
						//Ir¡ gerar registro M400 e M800 quando se tratar de Receita no tributada.
						//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
						 If (cAliasCF8)->CF8_INDOPE == "2"
							RegM400(@aRegM400,@aRegM410,,,,cAliasSB1,cAliasCF8)
							RegM800(@aRegM800,@aRegM810,,,,cAliasSB1,cAliasCF8)
						EndIF
					EndIf
					RestArea(aAliasB1)
				Elseif lNatRecCF8 .And. !Empty((cAliasCF8)->CF8_TNATRE) .And. (cAliasCF8)->CF8_INDOPE == "2"
					RegM400(@aRegM400,@aRegM410,,,,cAliasSB1,cAliasCF8)
					RegM800(@aRegM800,@aRegM810,,,,cAliasSB1,cAliasCF8)
				Endif

				cCodPart	:= 	Iif( Len(aPartDoc)>0,aPartDoc[1],"")
				cDtOperCF8	:=	Substr(DTOS((cAliasCF8)->CF8_DTOPER),7,2)+Substr(DTOS((cAliasCF8)->CF8_DTOPER),5,2)+Substr(DTOS((cAliasCF8)->CF8_DTOPER),1,4)
				cDescCF8	:=	Formula((cAliasCF8)->CF8_DESCPR)

				aAdd(aRegF100, {})
				nPos := Len(aRegF100)
				aAdd (aRegF100[nPos], "F100")										//01 - REG
				aAdd (aRegF100[nPos], (cAliasCF8)->CF8_INDOPE)						//02 - IND_OPER
				aAdd (aRegF100[nPos], cCodPart)				   						//03 - COD_PART
				aAdd (aRegF100[nPos], cProd)				   			            //04 - COD_ITEM
				aAdd (aRegF100[nPos], cDtOperCF8)				   					//05 - DT_OPER
				aAdd (aRegF100[nPos], (cAliasCF8)->CF8_VLOPER)						//06 - VL_OPER
				aAdd (aRegF100[nPos], (cAliasCF8)->CF8_CSTPIS)						//07 - CST_PIS
				aAdd (aRegF100[nPos], (cAliasCF8)->CF8_BASPIS)						//08 - VL_BC_PIS
				aAdd (aRegF100[nPos], (cAliasCF8)->CF8_ALQPIS)						//09 - ALIQ_PIS
				aAdd (aRegF100[nPos], (cAliasCF8)->CF8_VALPIS)						//10 - VL_PIS
				aAdd (aRegF100[nPos], (cAliasCF8)->CF8_CSTCOF)				   		//11 - CST_COFINS
				aAdd (aRegF100[nPos], (cAliasCF8)->CF8_BASCOF)				   		//12 - VL_BC_COFINS
				aAdd (aRegF100[nPos], (cAliasCF8)->CF8_ALQCOF)				   		//13 - ALIQ_COFINS
				aAdd (aRegF100[nPos], (cAliasCF8)->CF8_VALCOF)				   		//14 - VL_COFINS
				aAdd (aRegF100[nPos], (cAliasCF8)->CF8_CODBCC)				   		//15 - NAT_BC_CRED
				aAdd (aRegF100[nPos], (cAliasCF8)->CF8_INDORI)				   		//16 - IND_ORIG_CRED
				aAdd (aRegF100[nPos], Reg0500(aReg0500,(cAliasCF8)->CF8_CODCTA,,,.F.))	//17 - COD_CTA
				aAdd (aRegF100[nPos], Reg0600(aReg0600,(cAliasCF8)->CF8_CODCCS))	//18 - COD_CCUS
				aAdd (aRegF100[nPos], Iif(cDescCF8<>Nil,cDescCF8,(cAliasCF8)->CF8_DESCPR))//19 - DESC_DOC_OPER

				If (cAliasCF8)->CF8_CSTPIS $ cCstCred	//CST de PIS de cr©dito
					AcumM105(aRegM105,,cRegime,Iif((cAliasCF8)->CF8_TPREG == "1",.T.,.F.),cIndApro,aReg0111,.T. , {},,,,cAliasCF8)
				Else //Se no ser¡ CST de Contribuio
					RegM210(aRegM210,,cRegime,Iif((cAliasCF8)->CF8_TPREG == "1",.T.,.F.),{},{}, .T.,{},,,,,cAliasCF8)
				EndIF

				If (cAliasCF8)->CF8_CSTCOF $ cCstCred	//CST de Cofins de cr©dito
					AcumM505(aRegM505,,cRegime,Iif((cAliasCF8)->CF8_TPREG == "1",.T.,.F.),cIndApro,aReg0111,.T., {},,,,cAliasCF8)
				Else //Se no ser¡ CST de Contribuio
					RegM610(aRegM610,,cRegime,Iif((cAliasCF8)->CF8_TPREG == "1",.T.,.F.),{},{}, .T.,{},,,,,cAliasCF8)
				EndIF
			ElseIF lRgCmpCons .AND. (cAliasCF8)->CF8_INDOPE <> "0"
				aParF550	:= {}
				lPauta		:= .F.
				cConta		:= ""

				IF (cAliasCF8)->CF8_CSTPIS == "03" .OR. (cAliasCF8)->CF8_CSTCOF == "03"
					lPauta		:= .T.
				EndIF

				aAdd(aParF550,Iif (lPauta,"F560","F550"))
				aAdd(aParF550,(cAliasCF8)->CF8_VLOPER)
				aAdd(aParF550,(cAliasCF8)->CF8_CSTPIS)
				aAdd(aParF550, 0)
				aAdd(aParF550,(cAliasCF8)->CF8_BASPIS)
				aAdd(aParF550,(cAliasCF8)->CF8_ALQPIS)
				aAdd(aParF550,(cAliasCF8)->CF8_VALPIS)
				aAdd(aParF550,(cAliasCF8)->CF8_CSTCOF)
				aAdd(aParF550, 0)
				aAdd(aParF550,(cAliasCF8)->CF8_BASCOF)
				aAdd(aParF550,(cAliasCF8)->CF8_ALQCOF)
				aAdd(aParF550,(cAliasCF8)->CF8_VALCOF)
				aAdd(aParF550, "")
				aAdd(aParF550, "")
				cConta	:=Reg0500(@aReg0500,(cAliasCF8)->CF8_CODCTA)
				aAdd(aParF550,cConta)
				aAdd(aParF550, "")
				aAdd(aParF550,(cAliasCF8)->CF8_TNATRE)
				aAdd(aParF550,(cAliasCF8)->CF8_CNATRE)
				aAdd(aParF550,(cAliasCF8)->CF8_GRPNC)
				aAdd(aParF550,(cAliasCF8)->CF8_DTFIMN)

				//Gera registros F550/F560 e filhos
				RegimeComp(@aRegF550,@aRegF560,@aRegM210,@aRegM610,aParF550,lPauta,@aRegM400,@aRegM410,@aRegM800,@aRegM810,,,,,,,,,.T.)

				//Acumula valores no registro 1900
				Reg1900Com (@aReg1900,"99", cConta, "00",SM0->M0_CGC,"", (cAliasCF8)->CF8_VLOPER,(cAliasCF8)->CF8_CSTPIS,(cAliasCF8)->CF8_CSTCOF,"" ,(cAliasCF8)->CF8_DESCPR)

			EndIF

			(cAliasCF8)->(DbSkip ())
		EndDo
	Endif

	If lAchouCF8
		SPEDFFiltro(2,,cAliasCF8)
	EndIf
EndIF

If lSpdP09

	aPEF100 := ExecBlock("SPDPIS09",.F.,.F.,{cFil,dDataDe,dDataAte})

	For x := 1 To Len(aPEF100)
		IF !lRgCmpCons
			//Zera array dos registros complementares 
			aPartDoc	:=	{}
			aPar0500	:=	{}
			aPEF100Aux	:=	{}
			cCodPart	:=	""
			cLoja		:= 	""
			cAlsSA		:= ""

			aAdd(aRegF100, {})
			nPos := Len(aRegF100)
				
			If Len(aPEF100[x]) >= 49
				cAlsSA	:= 	aPEF100[x][49]
			ElseIF aPEF100[x][2] == "0"
				cAlsSA	:= 	'SA2'
			Else
				cAlsSA	:= 	'SA1'
			EndIF
				
			If cAlsSA == 'SA2'
				dbSelectArea("SA2")
				dbSetOrder(1)
				If MsSeek(xFilial("SA2")+(PadR(aPEF100[x][3],TamSx3("A2_COD")[1]) + PadR(aPEF100[x][20],TamSx3("A2_LOJA")[1]) ))
					cCodPart := SA2->A2_COD
					cLoja	 := SA2->A2_LOJA
				EndIf

			ElseIf cAlsSA == 'SA1'
				dbSelectArea("SA1")
				dbSetOrder(1)
				If MsSeek(xFilial("SA1")+(PadR(aPEF100[x][3],TamSx3("A1_COD")[1]) + PadR(aPEF100[x][20],TamSx3("A1_LOJA")[1]) ))
					cCodPart := SA1->A1_COD
					cLoja	 := SA1->A1_LOJA
				EndIf
			EndIF

			//š„„„„„„„„„„„„„„„„„„„¿
			//Gera Registro 0150 
			//€„„„„„„„„„„„„„„„„„„„™
			If !Empty(cAlsSA) .And. (cAlsSA)->(MsSeek (xFilial(cAlsSA)+cCodPart+cLoja))
				aPartDoc	:=	InfPartDoc (cAlsSA,@aReg0150,.F.,dDataDe, dDataAte,nRelacFil)
				If len(aPartDoc) >0
					If  aScan (aReg0150, {|aX| aX[3]==aPartDoc[1]})==0
						Reg0150 (@aReg0150, aPartDoc,nRelacFil)
					EndIf
				EndIF
			Elseif !Empty(aPEF100[x][3]) .AND.  Len(aPEF100[x]) > 21
				For y := 22 To 33
					Aadd(aPartDoc,	aPEF100[x][y])
				Next y
				If len(aPartDoc) >0
					If  aScan (aReg0150, {|aX| aX[3]==aPartDoc[1]})==0
						Reg0150 (@aReg0150,aPartDoc,nRelacFil)
					EndIf
		   		EndIF
			Endif

			//š„„„„„„„„„„„„„„„„„„„¿
			//Gera Registro 0500 
			//€„„„„„„„„„„„„„„„„„„„™
			If !Empty(aPEF100[x][17]) .And. Len(aPEF100[x]) > 33
				For y := 34 To 41
					Aadd(aPar0500,	aPEF100[x][y])
				Next y
				If Len(aPar0500) > 0
					If aScan (aReg0500, {|aX| aX[6] == aPar0500[5]})==0
						Reg0500(@aReg0500,aPEF100[x][17],aPar0500)
					Endif
				Endif
			Endif

			//š„„„„„„„„„„„„„„„„„„„¿
			//Gera Registro 0600 
			//€„„„„„„„„„„„„„„„„„„„™
			If !Empty(aPEF100[x][18]) .And. Len(aPEF100[x]) >= 48				
				aAdd(aPar0600,{aPEF100[x][46],aPEF100[x][47],aPEF100[x][48]})
				If Len(aPar0600) > 0
					If aScan(aReg0600,{|aX| aX[3] == aPar0600[x][2]})==0
						Reg0600(@aReg0600,aPEF100[x][18],aPar0600[x])
					Endif
				Endif
			Endif
			For w := 1 To 19
				Aadd( aRegF100[nPos], aPEF100[x][w] )
			Next w
			aRegF100[nPos][3] := Iif(!Empty(aRegF100[nPos][3]),aPartDoc[1],aRegF100[nPos][3])

			//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
			//Se for registro de cr©dito (aPEF100[x][2] == "0"), ir¡ acumular valor nos registros M105 e M505
			//Se for valor de contribuio, ir¡ acumular valor nos registros M210 e M610                     
			//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
			If aPEF100[x][2] == "0"
				AcumM105(aRegM105,,cRegime,Iif(aPEF100[x][21] == "0",.T.,.F.),cIndApro,aReg0111,.T., aRegF100[nPos])
				AcumM505(aRegM505,,cRegime,Iif(aPEF100[x][21] == "0",.T.,.F.),cIndApro,aReg0111,.T., aRegF100[nPos])
			Else
				RegM210(aRegM210,,cRegime,Iif(aPEF100[x][21] == "0",.T.,.F.),{},{}, .T.,aRegF100[nPos],)
				RegM610(aRegM610,,cRegime,Iif(aPEF100[x][21] == "0",.T.,.F.),{},{}, .T.,aRegF100[nPos],)

				//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
				//Se possuir retorno nas posicoes 42 a 45, utilizo os codigos para gerar os registros M400, M410, M800 e M810.							
				//O array aPEF100Aux eh montado na mesma estrutura do aF100Aux, para que utilize as mesma posicoes ao gerar os registro M400 e M800.	
				//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
				If Len(aPEF100[x]) > 41
					//PIS
					If (aPEF100[x][7] $ "04|06|07|08|09") .Or. (aPEF100[x][7] $ "05" .And. aPEF100[x][9] == 0)

						aPEF100Aux	:=	{"",aPEF100[x][6],aPEF100[x][7],"","","","","","","","","","","","","","",;
										aPEF100[x][42],aPEF100[x][43],aPEF100[x][44],aPEF100[x][45]}

						RegM400(@aRegM400,@aRegM410,,,aPEF100Aux)
					EndIF
					//COFINS
					If (aPEF100[x][11] $ "04|06|07|08|09") .Or. (aPEF100[x][11] $ "05" .And. aPEF100[x][13] == 0)

						aPEF100Aux	:=	{"",aPEF100[x][6],"","","","",aPEF100[x][11],"","","","","","","","","","",;
										aPEF100[x][42],aPEF100[x][43],aPEF100[x][44],aPEF100[x][45]}

						RegM800(@aRegM800,@aRegM810,,,aPEF100Aux)
					EndIF
				Endif

			EndIF
		ElseIF lRgCmpCons .AND. aPEF100[x][2] <> "0" // se no for operao referente a entrada ir¡ fazer a gerao dos registros F550 e F560

	   		aParF550	:= {}
			lPauta		:= .F.
			cConta		:= ""

			IF aPEF100[x][07]== "03" .OR. aPEF100[x][11] == "03"
				lPauta		:= .T.
			EndIF

			aAdd(aParF550,Iif (lPauta,"F560","F550"))
			aAdd(aParF550, aPEF100[x][06])
			aAdd(aParF550, aPEF100[x][07])
			aAdd(aParF550, 0)
			aAdd(aParF550, aPEF100[x][08])
			aAdd(aParF550, aPEF100[x][09])
			aAdd(aParF550, aPEF100[x][10])
			aAdd(aParF550, aPEF100[x][11])
			aAdd(aParF550, 0)
			aAdd(aParF550, aPEF100[x][12])
			aAdd(aParF550, aPEF100[x][13])
			aAdd(aParF550, aPEF100[x][14])
			aAdd(aParF550, "")
			aAdd(aParF550, "")
			cConta	:= Reg0500(@aReg0500,aPEF100[x][17])
			aAdd(aParF550, cConta )
			aAdd(aParF550, "")
			aAdd(aParF550,aPEF100[x][42])
			aAdd(aParF550,aPEF100[x][43])
			aAdd(aParF550,aPEF100[x][44])
			aAdd(aParF550,aPEF100[x][45])

			//Gera registros F550/F560 e filhos
			RegimeComp(@aRegF550,@aRegF560,@aRegM210,@aRegM610,aParF550,lPauta,@aRegM400,@aRegM410,@aRegM800,@aRegM810)

			//Acumula no registro 1900
			Reg1900Com (@aReg1900,"99", cConta, "00",SM0->M0_CGC,"",aPEF100[x][06],aPEF100[x][07],aPEF100[x][08], ,aPEF100[x][14])
		EndIF

	Next x
Endif

Return


/*‰‘‹‘‹‘»±±
±±ºPrograma  RegI010   ºAutor  Erick G. Dias       º Data   27/01/2014 º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Identificao do Estabelecimento                           º±±
±±ˆ¼*/
Static Function RegI010(cAlias,aRegI010,nPaiI, lGravaI010,IndAtiv)
Local nPos := 0

nPos:= aScan (aRegI010, {|aX| AllTrim(aX[2])==AllTrim(SM0->M0_CGC)})

If nPos	== 0
	aAdd(aRegI010, {})
	nPos	:=	Len (aRegI010)
	aAdd (aRegI010[nPos], "I010") //01-REG
	aAdd (aRegI010[nPos], AllTrim(SM0->M0_CGC)) //02-CNPJ
	aAdd (aRegI010[nPos], IndAtiv) //02-CNPJ
	aAdd (aRegI010[nPos], "") //04 - Informao Complementar
EndIf

nPaiI	:=  nPos

Return

/*‰‘‹‘‹‘»±±
±±ºPrograma  RegF010   ºAutor  Erick G. Dias       º Data   10/05/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Identificao do Estabelecimento                           º±±
±±ˆ¼*/
Static Function RegF010(cAlias,aRegF010,nPaiF, lGravaF010)
Local nPos := 0

If aScan (aRegF010, {|aX| AllTrim(aX[2])==AllTrim(SM0->M0_CGC)}) == 0
	aAdd(aRegF010, {})
	nPos	:=	Len (aRegF010)
	aAdd (aRegF010[nPos], "F010") //01-REG
	aAdd (aRegF010[nPos], AllTrim(SM0->M0_CGC)) //02-CNPJ
	nPaiF += 1
	lGravaF010:=.T.
EndIf

Return

/*‰‘‹‘‹‘»±±
±±ºPrograma  RegF130   ºAutor  Erick G. Dias       º Data   10/05/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Gerao do registro F130 Cr©dito PIS COFINS ATIVO          º±±
±±ˆ¼±±
±±ParametrosaRegF130   -> Informaµes do registro F130                  ±±
±±          cAliasF130 -> Alias da tabela que foi retornada atrav©s     ±±
±±                        da funo AtfRegF130.                         ±±
±±          aReg0500   -> Informaµes do registro 0500                  ±±
±±          aReg0600   -> Informaµes do registro 0600                  ±±
±±          aRegM105   -> Informaµes do registro M105                  ±±
±±          aRegM505   -> Informaµes do registro M505                  ±±
±±          cRegime    -> Indica qual o regime do Contribuinte          ±±
±±          cIndApro   -> Indica a forma de apropriao do cr©dito      ±±
±±          aReg0111   -> Total das receitas bruta registro 0111        ±±
±±ˆ¼*/
Static Function RegF130(aRegF130,cAliasF130,aReg0500,aReg0600,aRegM105,aRegM505,cRegime,cIndApro,aReg0111,aRegF139,aReg1010,aReg1020)
Local nPos 		:= 0
Local lReferen	:= (cAliasF130)->(FieldPos("INDPRO"))>0 .And. (cAliasF130)->(FieldPos("NUMPRO"))>0
Local lAchouCCF	:= .F.
Local lCpoMajAli:= aFieldPos[15] .And. aFieldPos[16]
Local lCofZero	:= .T.
Local nAliqCof	:= 0
Local nValcof	:= 0
Local aAreaSN1	:= SN1->(GetArea())
Local aAreaSD1	:= SD1->(GetArea())
Local nAliqPis  := 0
Local nValPis   := 0


SN1->(dbSetOrder(1))
SD1->(dbSetOrder(1))

Default aRegF139	:= {}

DbSelectArea(cAliasF130)
(cAliasF130)->(DbGoTop())
Do While !(cAliasF130)->(Eof ())

	aAdd(aRegF130, {})
	nPos	:=	Len (aRegF130)
	aAdd (aRegF130[nPos], "F130") 												//01-REG
	aAdd (aRegF130[nPos], (cAliasF130)->NAT_BC_CRE) 							//02-NAT_BC_CRED
	aAdd (aRegF130[nPos], strzero((cAliasF130)->IDENT_BEM,2)) 					//03-IDENT_BEM_IMOB
	aAdd (aRegF130[nPos], cvaltochar((cAliasF130)->IND_ORIG_C)) 				//04-IND_ORIG_CRED
	aAdd (aRegF130[nPos], cvaltochar((cAliasF130)->IND_UTIL_B)) 				//05-IND_UTIL_BEM_IMOB
	aAdd (aRegF130[nPos], cvaltochar(strzero((cAliasF130)->MES_OPER_A,6)))		//06-MES_OPER_AQUIS
	aAdd (aRegF130[nPos], (cAliasF130)->VL_OPER_AQ) 							//07-VL_OPER_AQUIS
	aAdd (aRegF130[nPos], (cAliasF130)->PARC_OPER) 								//08-PARC_OPER_NAO_BC_CRED
	aAdd (aRegF130[nPos], (cAliasF130)->VL_BC_CRED) 							//09-VL_BC_CRED
	aAdd (aRegF130[nPos], cvaltochar((cAliasF130)->IND_NR_PAR)) 				//10-IND_NR_PARC
	aAdd (aRegF130[nPos], cvaltochar((cAliasF130)->CST_PIS)) 					//11-CST_PIS
	aAdd (aRegF130[nPos], (cAliasF130)->VL_BC_PIS) 							//12-VL_BC_PIS

	// Incluso de tratamento para Cofins Majorada - THMRKD
	lCofZero	:= (cAliasF130)->VL_BC_COFIN == 0 .or. (cAliasF130)->ALIQ_COFIN == 0
	nAliqCof  	:= 	Iif(lCofZero, 0, (cAliasF130)->ALIQ_COFIN)
	nValCof		:=	Iif(lCofZero, 0, (cAliasF130)->VL_COFINS)
	nAliqPis    := (cAliasF130)->ALIQ_PIS
	nValPis     := (cAliasF130)->VL_PIS
	// Realiza posicionamento tempor¡rio para o SD1, at© que a equipe ATF seja acionada para criao de campos
	If SN1->(dbSeek(xFilial('SN1')+(cAliasF130)->BEM+(cAliasF130)->ITEM)) .And. (aFieldPos[85] .And. (Empty(SN1->N1_CBCPIS) .Or. SN1->N1_CBCPIS == "1"))
       If SD1->(dbSeek(xFilial('SD1')+(cAliasF130)->NOTAFISCAL+(cAliasF130)->SERIE+(cAliasF130)->FORNECEDOR+(cAliasF130)->LOJA+SN1->N1_PRODUTO+SN1->N1_NFITEM))
   		  If (SubStr (AllTrim (SD1->D1_CF), 1, 1)=="3")
		     MajAliqVal(@nAliqCof,@nValCof,'SD1',lCpoMajAli,.T.)
		     MajAliqPIS(@nAliqPis,@nValPis,'SD1',.T.)
		  Endif
	   Endif
  	Endif
	aAdd (aRegF130[nPos], nAliqPis )			 								//13-ALIQ_PIS
	aAdd (aRegF130[nPos], nValPis )				 								//14-VL_PIS
	aAdd (aRegF130[nPos], cvaltochar((cAliasF130)->CST_COFINS)) 				//15-CST_COFINS
	aAdd (aRegF130[nPos], (cAliasF130)->VL_BC_COFIN) 							//16-VL_BC_COFINS
	aAdd (aRegF130[nPos], nAliqCof ) 											//17-ALIQ_COFINS
	aAdd (aRegF130[nPos], nValCof )				 								//18-VL_COFINS
	aAdd (aRegF130[nPos], Reg0500(aReg0500,(cAliasF130)->COD_CTA)) 			//19-COD_CTA
	aAdd (aRegF130[nPos], Reg0600(aReg0600,(cAliasF130)->COD_CCUS)) 			//20-COD_CCUS
	aAdd (aRegF130[nPos], (cAliasF130)->DESC_BEM_I) 							//21-DESC_BEM_IMOB

	If cvaltochar((cAliasF130)->CST_PIS) $ CCSTCRED
		AcumM105(aRegM105,,cRegime,,cIndApro,aReg0111,.T., {},cAliasF130)
	EndIF

	If cvaltochar((cAliasF130)->CST_COFINS) $ CCSTCRED
		AcumM505(aRegM505,,cRegime,,cIndApro,aReg0111,.T., {},cAliasF130)
	EndIF
	// Verifica o tipo do registro, so' grava se for: 1 - Justica Federal / 3 - Secretaria Federal ou 9 - Outros
 	If lReferen .And. !Empty((cAliasF130)->NUMPRO) .And. !Empty((cAliasF130)->INDPRO) .And. !(Alltrim((cAliasF130)->INDPRO)$"0|2")

		aAdd(aRegF139, {})
		nPos	:=	Len (aRegF139)
		aAdd (aRegF139[nPos], Len(aRegF130)) 										//Relao com F130
		aAdd (aRegF139[nPos], "F139") 												//01-REG
		aAdd (aRegF139[nPos], (cAliasF130)->NUMPRO) 			   					//02-NUM_PROC
		aAdd (aRegF139[nPos], (cAliasF130)->INDPRO) 			   					//03-IND_PROC

        lAchouCCF	:=	CCF->(MsSeek (xFilial ("CCF")+(cAliasF130)->NUMPRO+(cAliasF130)->INDPRO ))

		If	lAchouCCF
			If CCF->CCF_TPCOMP == "1" //Complemento do processo referenciado - Judicial
				Reg1010(aReg1010)
			ElseIf CCF->CCF_TPCOMP == "2" //Complemento do processo referenciado - Administrativo
				Reg1020(aReg1020)
			EndIf
		Endif

	EndIf

	(cAliasF130)->(DbSkip ())

EndDo
FERASE(cAliasF130)
RestArea(aAreaSN1)
RestArea(aAreaSD1)
Return

/*‰‘‹‘‹‘»±±
±±ºPrograma  RegM230   ºAutor   Vitor Felipe       º Data   18/05/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Processamento do registro M230                             º±±
±±ˆ¼±*/
Static Function RegM230(aRegM230,nPosM210,nDifer, lRecIndic, aDiferimen)
Local nPosM230 	:= 0
Local nPos 		:= 0
Local cTpFunc	:= "M230"
Local aM230		:= {}

Local cCnpj			:= ""
Local nVlVenda		:= 0
Local nVlNReceb		:= 0
Local nVlContDif	:= 0
Local cCodCre		:= ""
Local nCredDif		:= 0
Local lGeraDif		:= .F.

DEFAULT lRecIndic	:= .F.
DEFAULT aDiferimen	:= {}

If Len(aM230) > 0
	cCnpj		:=	aM230[1]
	nVlVenda	:=	aM230[2]
	nVlNReceb	:=  aM230[3]
	nVlContDif	:=  aM230[4]
	lGeraDif	:= .T.
ElseIF len(aDiferimen) > 0
	cCnpj		:=	aDiferimen[1]
	nVlVenda	:=	aDiferimen[2]
	nVlNReceb	:=  aDiferimen[3]
	nVlContDif	:=  aDiferimen[4]
	nCredDif	:=  aDiferimen[7]
	cCodCre		:=  aDiferimen[9]
	IF nCredDif > 0 .OR.nVlContDif > 0
		lGeraDif	:= .T.
	EndIF
EndIF

If lGeraDif
	nPosM230 :=  aScan (aRegM230, {|aX| aX[1]== nPosM210 .AND. aX[3]== cCnpj .AND. aX[8] == cCodCre })
	If nPosM230 == 0
		aAdd(aRegM230, {})
		nPos := Len(aRegM230)
		aAdd (aRegM230[nPos], nPosM210)
		aAdd (aRegM230[nPos], "M230")			   	   		//01 - REG
		aAdd (aRegM230[nPos], cCnpj)					   	//02 - CNPJ
		aAdd (aRegM230[nPos], nVlVenda)						//03 - VL_VENDA
		aAdd (aRegM230[nPos], nVlNReceb)				    //04 - VL_NAO_RECEB
		aAdd (aRegM230[nPos], nVlContDif)				    //05 - VL_CONT_DIF
		aAdd (aRegM230[nPos], nCredDif)				        //06 - VL_CRED_DIF
		aAdd (aRegM230[nPos], cCodCre)					 	//07 - COD_CRED
	Else
		aRegM230[nPosM230][4] += nVlVenda					//03 - VL_VENDA
		aRegM230[nPosM230][5] += nVlNReceb				    //04 - VL_NAO_RECEB
		aRegM230[nPosM230][6] += nVlContDif				    //05 - VL_CONT_DIF
		aRegM230[nPosM230][7] += nCredDif				    //06 - VL_CRED_DIF
	EndIf
	nDifer := nVlContDif
EndIf

Return

/*‘‹‘‹‘»±±
±±ºPrograma  RegM630   ºAutor   Vitor Felipe       º Data   18/05/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Processamento do registro M630                             º±±
±±ˆ¼*/
Static Function RegM630(aRegM630,nPosM610,nDifer, lRecIndic, aDiferimen)
Local nPosM630 	:= 0
Local nPos 		:= 0
Local cTpFunc	:= "M630"
Local aM630		:= {}

Local cCnpj			:= ""
Local nVlVenda		:= 0
Local nVlNReceb		:= 0
Local nVlContDif	:= 0
Local cCodCre		:= ""
Local nCredDif		:= 0
Local lGeraDif		:= .F.

DEFAULT lRecIndic	:= .F.
DEFAULT aDiferimen	:= {}

If Len(aM630) > 0
	cCnpj		:=	aM630[1]
	nVlVenda	:=	aM630[2]
	nVlNReceb	:=  aM630[3]
	nVlContDif	:=  aM630[4]
	lGeraDif	:= .T.
ElseIF len(aDiferimen) > 0
	cCnpj		:=	aDiferimen[1]
	nVlVenda	:=	aDiferimen[2]
	nVlNReceb	:=  aDiferimen[3]
	nVlContDif	:=  aDiferimen[5]
	nCredDif	:=  aDiferimen[8]
	cCodCre		:=  aDiferimen[10]
	IF nCredDif > 0 .OR.nVlContDif > 0
		lGeraDif	:= .T.
	EndIF
EndIF

If lGeraDif
	nPosM630 :=  aScan (aRegM630, {|aX| aX[1]== nPosM610 .AND. aX[3]== cCnpj .AND. aX[8]== cCodCre})
	If nPosM630 == 0
		aAdd(aRegM630, {})
		nPos := Len(aRegM630)
		aAdd (aRegM630[nPos], nPosM610)
		aAdd (aRegM630[nPos], "M630")			   	   		//01 - REG
		aAdd (aRegM630[nPos], cCnpj)						//02 - CNPJ
		aAdd (aRegM630[nPos], nVlVenda)						//03 - VL_VENDA
		aAdd (aRegM630[nPos], nVlNReceb)				    //04 - VL_NAO_RECEB
		aAdd (aRegM630[nPos], nVlContDif)				    //05 - VL_CONT_DIF
		aAdd (aRegM630[nPos], nCredDif)				       	//06 - VL_CRED_DIF
		aAdd (aRegM630[nPos], cCodCre)				    	//07 - COD_CRED
	Else
		aRegM630[nPosM630][4] += nVlVenda					//03 - VL_VENDA
		aRegM630[nPosM630][5] += nVlNReceb				    //04 - VL_NAO_RECEB
		aRegM630[nPosM630][6] += nVlContDif				    //05 - VL_CONT_DIF
		aRegM630[nPosM630][7] += nCredDif				    //06 - VL_CRED_DIF
	EndIf
	nDifer := nVlContDif
EndIf
Return


/*‘‹‘‹‘»±±
±±ºPrograma  RegM300   ºAutor   Vitor Felipe       º Data   18/05/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Processamento do registro M300                             º±±
±±ˆ¼*/
Static Function RegM300(aRegM300,lRecIndic,aDiferimen)
Local nPosM300 		:= 0
Local nPos 			:= 0
Local nX			:= 0
Default lRecIndic	:= .F.
Default aDiferimen	:= {}

If Len(aDiferimen) > 0
	nPosM300 :=  aScan (aRegM300, {|aX| aX[2]== aDiferimen[1] .AND. aX[8] == aDiferimen[5]  .AND. aX[4] == aDiferimen[10] .And. aX[7] == aDiferimen[4]})
	If nPosM300 == 0
		aAdd(aRegM300, {})
		nPos := Len(aRegM300)
		aAdd (aRegM300[nPos], "M300")			   		//01 - REG
		aAdd (aRegM300[nPos],aDiferimen[1])				//02 - COD. CONTRIBUICAO
		aAdd (aRegM300[nPos],aDiferimen[2])				//03 - VALOR APURADO
		aAdd (aRegM300[nPos],aDiferimen[10])		    			//04 - NAT. CREDITO DIFERIDO
		aAdd (aRegM300[nPos],aDiferimen[8])		   		//05 - VALRO CRED. DESCONTAR
		aAdd (aRegM300[nPos],aDiferimen[2]-aDiferimen[8])//06 - VALOR CONTRIBUICAO A RECOLHER
		aAdd (aRegM300[nPos],aDiferimen[4])	    		//07 - PERIODO DA APURACAO
		aAdd (aRegM300[nPos],aDiferimen[5])		    	//08 - DATA RECEBIMENTO
	Else
		aRegM300[nPosM300][3] += aDiferimen[2]			 //03 - VALOR APURADO
		aRegM300[nPosM300][5] += aDiferimen[8]			 //06 - VALOR CONTRIBUICAO A RECOLHER
		aRegM300[nPosM300][6] += aDiferimen[2]-aDiferimen[8]//06 - VALOR CONTRIBUICAO A RECOLHER
	EndIf

EndIf

Return

/*‘‹‘‹‘»±±
±±ºPrograma  RegM700   ºAutor   Vitor Felipe       º Data   18/05/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Processamento do registro M700                             º±±
±±ˆ¼*/
Static Function RegM700(aRegM700,lRecIndic,aDiferimen)
Local nPosM700 		:= 0
Local nPos 			:= 0
Local nX			:= 0
Default lRecIndic	:= .F.
Default aDiferimen	:= {}

If Len(aDiferimen) > 0
	nPosM700 :=  aScan (aRegM700, {|aX| aX[2]== aDiferimen[1] .AND. aX[4] == aDiferimen[10] .AND. aX[8] == aDiferimen[5] .And. aX[7] == aDiferimen[4]})
	If nPosM700 == 0
		aAdd(aRegM700, {})
		nPos := Len(aRegM700)
		aAdd (aRegM700[nPos], "M700")			   	//01 - REG
		aAdd (aRegM700[nPos],aDiferimen[1])			//02 - COD. CONTRIBUICAO
		aAdd (aRegM700[nPos],aDiferimen[3])			//03 - VALOR APURADO
		aAdd (aRegM700[nPos],aDiferimen[10])		    		//04 - NAT. CREDITO DIFERIDO
		aAdd (aRegM700[nPos],aDiferimen[9])			//05 - VALRO CRED. DESCONTAR
		aAdd (aRegM700[nPos],aDiferimen[3]-aDiferimen[9])	        //06 - VALOR CONTRIBUICAO A RECOLHER
		aAdd (aRegM700[nPos],aDiferimen[4])	    	//07 - PERIODO DA APURACAO
		aAdd (aRegM700[nPos],aDiferimen[5])	    	//08 - DATA RECEBIMENTO
	Else
		aRegM700[nPosM700][3] += aDiferimen[3]		//03 - VALOR APURADO
		aRegM700[nPosM700][5] += aDiferimen[9]		//06 - VALOR CONTRIBUICAO A RECOLHER
		aRegM700[nPosM700][6] += aDiferimen[3]-aDiferimen[9]		//06 - VALOR CONTRIBUICAO A RECOLHER
	EndIf

EndIf

Return

/*‘‹‘‹‘»±±
±±ºPrograma  CredAntCofºAutor  Erick G. Dias       º Data   18/04/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Processa cr©ditos de cofins dos meses anteriores.          º±±
±±ˆ¼*/
Static Function RetAntPis(cPer,a1300Aux,lProcAnt)

Local cAliasSFV :="SFV"
Local dPriDia	:=firstday(sTod(cPer))-1
Local cPerAnt   := cvaltochar(strzero(month(dPriDia) ,2)) + cvaltochar(year(dPriDia ))
Local cPerAtu   := cvaltochar(strzero(month(sTod(cPer) ) ,2)) + cvaltochar(year(sTod(cPer) ))
Local cVazio    := ""
Local cZero     := Str(0)
Local nCredUti	:=0
Local nPos1300  :=0
Local aAMAtu    :={Substr(cPerAtu,1,2) , Substr(cPerAtu,3,4)}
Local cQuery    := ""

DbSelectArea (cAliasSFV)
(cAliasSFV)->(DbSetOrder (1))

#IFDEF TOP
    If (TcSrvType ()<>"AS/400")
        cAliasSFV   :=  GetNextAlias()

        cQuery := "SELECT "
        cQuery += " * "
        cQuery += " FROM " +RetSqlName("SFV")+ " SFV "
        cQuery += " WHERE "
        cQuery += " SFV.FV_FILIAL = '" + xFilial("SFV") + "'  AND "
        If lProcAnt
            cQuery += " ((SUBSTRING(SFV.FV_PER,1,2) <  '" +aAMAtu[1]+ "' AND SUBSTRING(SFV.FV_PER,3,4) <= '" +aAMAtu[2]+ "' AND"
            cQuery += " SFV.FV_VLDISP > " + cZero + " AND SFV.FV_MESANO = '" +cVazio+ "') OR (SUBSTRING(SFV.FV_PER,1,2)  <= '" +aAMAtu[1]+ "' AND"
            cQuery += " SUBSTRING(SFV.FV_PER,3,4)   <= '" +aAMAtu[2]+ "' )) AND"
        Else
            cQuery += " SFV.FV_PER = '"+ cPerAnt + "' AND SFV.FV_VLDISP > "+ cZero + " AND  "
        EndIf
        cQuery += " SFV.D_E_L_E_T_ = '' "
        cQuery += IIf(lProcAnt, " ORDER BY  SFV.FV_PER, SFV.FV_NATRET, SFV.FV_TOTRET, SFV.FV_VLDISP , SFV.FV_TPREG, SFV.FV_APURPER, SFV.FV_MESANO",;
                        " ORDER BY  SFV.FV_PER, SFV.FV_NATRET, SFV.FV_TOTRET, SFV.FV_VLDISP , SFV.FV_TPREG")

        cQuery  := ChangeQuery(cQuery)
        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSFV,.T.,.T.)
    Else
#ENDIF

    cIndex	:= CriaTrab(NIL,.F.)
    If lProcAnt
        cFiltro	:= " FV_FILIAL == '"+xFilial("SFV")+"' .And."
        cFiltro += " ((SUBSTRING(FV_PER,1,2) <  '" +aAMAtu[1]+ "' .AND. SUBSTRING(FV_PER,3,4) <= '" +aAMAtu[2]+ "' .AND."
        cFiltro += " FV_VLDISP > " + cZero + " .AND. FV_MESANO = '" +cVazio+ "') .OR. (SUBSTRING(FV_PER,1,2)  <= '" +aAMAtu[1]+ "' .AND."
        cFiltro += " SUBSTRING(FV_PER,3,4)   <= '" +aAMAtu[2]+ "' )) "
    Else
        cFiltro := "FV_FILIAL == '"+xFilial ("SFV")+"' .And. FV_PER == '"+ cPerAnt +"' .And. FV_VLDISP > "+ cZero + "   "
    EndIf

    IndRegua (cAliasSFV, cIndex, SFV->(IndexKey ()),, cFiltro)
    nIndex := RetIndex(cAliasSFV)

    DbSelectArea (cAliasSFV)
    DbSetOrder (nIndex)

#IFDEF TOP
    Endif
#ENDIF

DbSelectArea (cAliasSFV)
(cAliasSFV)->(DbGoTop ())
ProcRegua ((cAliasSFV)->(RecCount ()))

If lProcAnt

    Do While !(cAliasSFV)->(Eof ())
        nPos1300 := aScan (a1300Aux, {|aX| aX[1]==(cAliassfv)->FV_NATRET .AND. ax[2] == (cAliassfv)->FV_PER .AND.ax[5] == (cAliassfv)->FV_TPREG })
        If nPos1300 ==0 .AND. !((cAliassfv)->FV_PER = aAMAtu[1]+aAMAtu[2]).AND. Empty((cAliassfv)->FV_MESANO)
            aAdd(a1300Aux, {})
            nPos := Len(a1300Aux)
            aAdd (a1300Aux[nPos], (cAliassfv)->FV_NATRET)	//01
            aAdd (a1300Aux[nPos], (cAliassfv)->FV_PER)		//02
            aAdd (a1300Aux[nPos], (cAliassfv)->FV_TOTRET)	//03
            aAdd (a1300Aux[nPos], (cAliassfv)->FV_VLDISP)	//04
            aAdd (a1300Aux[nPos], (cAliassfv)->FV_TPREG)    //05
            aAdd (a1300Aux[nPos], (cAliassfv)->FV_APURPER)  //06
            aAdd (a1300Aux[nPos], (cAliassfv)->FV_MESANO)	//07
        EndIF

        DbSelectArea("SFV")
        SFV->(DbSetOrder (2))
        SFV->(DbGoTop ())
        If SFV->( MsSeek(xFilial("SFV") + (cAliassfv)->FV_NATRET + (cAliassfv)->FV_TPREG + (cAliassfv)->FV_PER + cPerAtu) )
            Do While SFV->( !Eof()) .AND. SFV->FV_MESANO = cPerAtu .AND. (cAliassfv)->FV_NATRET == SFV->FV_NATRET      .AND. ;
					(cAliassfv)->FV_PER    == SFV->FV_PER         .AND. (cAliassfv)->FV_TPREG  == SFV->FV_TPREG

                If SFV->FV_PER < cPerAtu
                    nPos1300 := aScan (a1300Aux, {|aX| aX[1]==SFV->FV_NATRET .AND. ax[2] == SFV->FV_PER .AND.ax[5] == SFV->FV_TPREG  })
                    IIf( nPos1300 > 0, a1300Aux[nPos1300][4] := UPDSFV(SFV->FV_NATRET,SFV->FV_PER,SFV->FV_TPREG,SFV->FV_APURPER),)
                EndIf

                RecLock("SFV",.F.)
                SFV->(dbDelete())
                MsUnLock()
                SFV->(FKCommit())
                SFV->(DbSkip ())
            EndDo
        EndIf

        (cAliasSFV)->(DbSkip ())
    EndDo

Else

    Do While !(cAliasSFV)->(Eof ())
        nPos1300 := aScan (a1300Aux, {|aX| aX[1]==(cAliassfv)->FV_NATRET .AND. ax[2] == (cAliassfv)->FV_PER .AND.ax[5] == (cAliassfv)->FV_TPREG })
        If nPos1300 ==0
            aAdd(a1300Aux, {})
            nPos := Len(a1300Aux)
            aAdd (a1300Aux[nPos], (cAliassfv)->FV_NATRET)
            aAdd (a1300Aux[nPos], (cAliassfv)->FV_PER)                               //01 - REG
            aAdd (a1300Aux[nPos], (cAliassfv)->FV_TOTRET)
            aAdd (a1300Aux[nPos], (cAliassfv)->FV_VLDISP)
            aAdd (a1300Aux[nPos], (cAliassfv)->FV_TPREG)
        Else
            a1300Aux[nPos1300][3] +=(cAliassfv)->FV_TOTRET
            a1300Aux[nPos1300][4] +=(cAliassfv)->FV_VLDISP
        EndIF
        (cAliasSFV)->(DbSkip ())
    EndDo
EndIf

#IFDEF TOP
    If (TcSrvType ()<>"AS/400")
        DbSelectArea (cAliasSFV)
        (cAliasSFV)->(DbCloseArea ())
    Else
#ENDIF
    RetIndex("SFT")
    #IFDEF TOP
    EndIf
#ENDIF

Return

Static Function UPDSFV(cNatRet,cPer,cTpReg,nApPer)

Local aArea      := SFV->(GetArea())
Local cAlias     := "SFV"
Local nVlDispAtu := 0

If aIndics[26] // AliasIndic(cAlias)
    (cAlias)->(DbSetOrder (1))
    dbSelectArea(cAlias)
    If MsSeek(xFilial(cAlias)+cNatRet+cPer+cTpReg)
       RecLock(cAlias,.F.)
       SFV->FV_VLDISP  += nApPer
       nVlDispAtu      := SFV->FV_VLDISP
       MsUnLock()
       SFV->(FKCommit())
    EndIf
EndIf

RestArea(aArea)

Return nVlDispAtu
/*‘‹‘‹‘»±±
±±ºPrograma  CredAntCofºAutor  Erick G. Dias       º Data   18/04/11   º±±
±±ºDesc.      Processa cr©ditos de cofins dos meses anteriores.          º±±
±±ˆ¼±*/
Static Function RetAntCof(cPer,a1700Aux,lProcAnt)

Local cAliasSFW :="SFW"
Local dPriDia   :=firstday(sTod(cPer))-1
Local cPerAnt   := cvaltochar(strzero(month(dPriDia) ,2)) + cvaltochar(year(dPriDia ))
Local cPerAtu   := cvaltochar(strzero(month(sTod(cPer) ) ,2)) + cvaltochar(year(sTod(cPer) ))
Local cVazio    := ""
Local cZero     := Str(0)
Local nCredUti  :=0
Local nPos1700  :=0
Local aAMAtu    :={Substr(cPerAtu,1,2) , Substr(cPerAtu,3,4)}
Local cQuery    := ""

DbSelectArea (cAliasSFW)
(cAliasSFW)->(DbSetOrder (1))

#IFDEF TOP
    If (TcSrvType ()<>"AS/400")
        cAliasSFW   :=  GetNextAlias()

        cQuery := "SELECT "
        cQuery += " * "
        cQuery += " FROM " +RetSqlName("SFW")+ " SFW "
        cQuery += " WHERE "
        cQuery += " SFW.FW_FILIAL = '" + xFilial("SFW") + "'  AND "
        If lProcAnt
            cQuery += " ((SUBSTRING(SFW.FW_PER,1,2) <  '" +aAMAtu[1]+ "' AND SUBSTRING(SFW.FW_PER,3,4) <= '" +aAMAtu[2]+ "' AND"
            cQuery += " SFW.FW_VLDISP > " + cZero + " AND SFW.FW_MESANO = '" +cVazio+ "') OR (SUBSTRING(SFW.FW_PER,1,2)  <= '" +aAMAtu[1]+ "' AND"
            cQuery += " SUBSTRING(SFW.FW_PER,3,4)   <= '" +aAMAtu[2]+ "' )) AND"
        Else
            cQuery += " SFW.FW_PER = '"+ cPerAnt + "' AND SFW.FW_VLDISP > "+ cZero + " AND  "
        EndIf
        cQuery += " SFW.D_E_L_E_T_ = '' "
        cQuery += IIf( lProcAnt, " ORDER BY  SFW.FW_PER, SFW.FW_NATRET, SFW.FW_TOTRET, SFW.FW_VLDISP , SFW.FW_TPREG, SFW.FW_APURPER, SFW.FW_MESANO",;
                       " ORDER BY  SFW.FW_PER, SFW.FW_NATRET, SFW.FW_TOTRET, SFW.FW_VLDISP , SFW.FW_TPREG")

        cQuery  := ChangeQuery(cQuery)
        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSFW,.T.,.T.)
    Else
#ENDIF

    If lProcAnt
        cIndex  := CriaTrab(NIL,.F.)
        cFiltro := " FW_FILIAL == '"+xFilial("SFW")+"' .And."
        cFiltro += " ((SUBSTRING(FW_PER,1,2) <  '" +aAMAtu[1]+ "' .AND. SUBSTRING(FW_PER,3,4) <= '" +aAMAtu[2]+ "' .AND."
        cFiltro += " FW_VLDISP > " + cZero + " .AND. FW_MESANO = '" +cVazio+ "') .OR. (SUBSTRING(FW_PER,1,2)  <= '" +aAMAtu[1]+ "' .AND."
        cFiltro += " SUBSTRING(FW_PER,3,4)   <= '" +aAMAtu[2]+ "' )) "
    Else
    	cIndex  := CriaTrab(NIL,.F.)
        cFiltro := "FW_FILIAL == '"+xFilial ("SFW")+"' .And. FW_PER == '"+ cPerAnt +"' .And. FW_VLDISP > "+ cZero + "   "
    EndIf

    IndRegua (cAliasSFW, cIndex, SFW->(IndexKey ()),, cFiltro)
    nIndex := RetIndex(cAliasSFW)

    DbSelectArea (cAliasSFW)
    DbSetOrder (nIndex)

#IFDEF TOP
    Endif
#ENDIF

DbSelectArea (cAliasSFW)
(cAliasSFW)->(DbGoTop ())
ProcRegua ((cAliasSFW)->(RecCount ()))

If lProcAnt

    Do While !(cAliasSFW)->(Eof ())
        nPos1700 := aScan (a1700Aux, {|aX| aX[1]==(cAliasSFW)->FW_NATRET .AND. ax[2] == (cAliasSFW)->FW_PER .AND.ax[5] == (cAliasSFW)->FW_TPREG })
        If nPos1700 ==0 .AND. !((cAliasSFW)->FW_PER = aAMAtu[1]+aAMAtu[2]).AND. Empty((cAliasSFW)->FW_MESANO)
            aAdd(a1700Aux, {})
            nPos := Len(a1700Aux)
            aAdd (a1700Aux[nPos], (cAliasSFW)->FW_NATRET)   //01
            aAdd (a1700Aux[nPos], (cAliasSFW)->FW_PER)      //02
            aAdd (a1700Aux[nPos], (cAliasSFW)->FW_TOTRET)   //03
            aAdd (a1700Aux[nPos], (cAliasSFW)->FW_VLDISP)   //04
            aAdd (a1700Aux[nPos], (cAliasSFW)->FW_TPREG)    //05
            aAdd (a1700Aux[nPos], (cAliasSFW)->FW_APURPER)  //06
            aAdd (a1700Aux[nPos], (cAliasSFW)->FW_MESANO)   //07
        EndIF

        DbSelectArea("SFW")
        SFW->(DbSetOrder (2))
        SFW->(DbGoTop ())
        If SFW->( MsSeek(xFilial("SFW") + (cAliasSFW)->FW_NATRET + (cAliasSFW)->FW_TPREG + (cAliasSFW)->FW_PER + cPerAtu) )
            Do While SFW->( !Eof()) .AND. SFW->FW_MESANO = cPerAtu .AND.(cAliasSFW)->FW_NATRET == SFW->FW_NATRET      .AND. ;
                    (cAliasSFW)->FW_PER == SFW->FW_PER .AND. (cAliasSFW)->FW_TPREG  == SFW->FW_TPREG

                If SFW->FW_PER < cPerAtu
                    nPos1700 := aScan (a1700Aux, {|aX| aX[1]==SFW->FW_NATRET .AND. ax[2] == SFW->FW_PER .AND.ax[5] == SFW->FW_TPREG  })
                    IIf( nPos1700 > 0,a1700Aux[nPos1700][4] := UPDSFW(SFW->FW_NATRET,SFW->FW_PER,SFW->FW_TPREG,SFW->FW_APURPER),)
                EndIf

                RecLock("SFW",.F.)
                SFW->(dbDelete())
                MsUnLock()
                SFW->(FKCommit())
                SFW->(DbSkip ())
            EndDo
        EndIf

        (cAliasSFW)->(DbSkip ())
    EndDo

Else

    Do While !(cAliasSFW)->(Eof ())
        nPos1700 := aScan (a1700Aux, {|aX| aX[1]==(cAliasSFW)->FW_NATRET .AND. ax[2] == (cAliasSFW)->FW_PER .AND.ax[5] == (cAliasSFW)->FW_TPREG })
        If nPos1700 ==0
            aAdd(a1700Aux, {})
            nPos := Len(a1700Aux)
            aAdd (a1700Aux[nPos], (cAliasSFW)->FW_NATRET)
            aAdd (a1700Aux[nPos], (cAliasSFW)->FW_PER)                               //01 - REG
            aAdd (a1700Aux[nPos], (cAliasSFW)->FW_TOTRET)
            aAdd (a1700Aux[nPos], (cAliasSFW)->FW_VLDISP)
            aAdd (a1700Aux[nPos], (cAliasSFW)->FW_TPREG)
        Else
            a1700Aux[nPos1700][3] +=(cAliasSFW)->FW_TOTRET
            a1700Aux[nPos1700][4] +=(cAliasSFW)->FW_VLDISP
        EndIF
        (cAliasSFW)->(DbSkip ())
    EndDo
EndIf

#IFDEF TOP
    If (TcSrvType ()<>"AS/400")
        DbSelectArea (cAliasSFW)
        (cAliasSFW)->(DbCloseArea ())
    Else
#ENDIF
    RetIndex("SFT")
    #IFDEF TOP
    EndIf
#ENDIF

Return

Static Function UPDSFW(cNatRet,cPer,cTpReg,nApPer)

Local aArea      := SFW->(GetArea())
Local cAlias     := "SFW"
Local nVlDispAtu := 0

If aIndics[27] // AliasIndic(cAlias)
    (cAlias)->(DbSetOrder (1))
    dbSelectArea(cAlias)
    If MsSeek(xFilial(cAlias)+cNatRet+cPer+cTpReg)
       RecLock(cAlias,.F.)
       SFW->FW_VLDISP  += nApPer
       nVlDispAtu      := SFW->FW_VLDISP
       MsUnLock()
       SFW->(FKCommit())
    EndIf
EndIf

RestArea(aArea)

Return nVlDispAtu

/*‘‹‘‹‘»±±
±±ºPrograma  RegM220   ºAutor  Erick G. Dias       º Data   28/07/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Processamento do registro 0206                             º±±
±±ˆ¼±±
±±ParametrosaReg0206  -> Array com informaµes do registro 0206         ±±
±±          cAliasSFT -> Alias da tabela SFT                            ±±
±±          nPai      -> Rela com registro pai                        ±±
±±          cChvPai   -> Chave do registro pai                          ±±
±±          cAlias    -> Alias da tabela tempor¡ria                     ±±
±±ˆ¼±*/
Static Function Reg0206(aReg0206,cAliasSFT, nPai, cChvPai, cAlias)

Local nPos := 0
Local a0206 := {}

If aScan (aReg0206, {|aX| aX[2] == AllTrim(CD6->CD6_CODANP) .And. aX[3] == nPai .And. aX[4] == cChvPai}) == 0
	aAdd(aReg0206, {})
	nPos := Len(aReg0206)
	aAdd (aReg0206[nPos], "0206")			   		 //01 - REG
	aAdd (aReg0206[nPos], AllTrim(CD6->CD6_CODANP)) //02 - COD_COMB
	aAdd (aReg0206[nPos], nPai)						 //03 - Filial
	aAdd (aReg0206[nPos], cChvPai)					 //04 - Chave 0200

 	aAdd(a0206, {})
 	nPos := Len(a0206)
 	aAdd (a0206[nPos], "0206")			   			 //01 - REG
 	aAdd (a0206[nPos], AllTrim(CD6->CD6_CODANP))	 //02 - COD_COMB

	PCGrvReg (cAlias,,a0206,,,nPai, cChvPai,,,nTamTRBIt)
EndIF

Return

/*‘‹‘‹‘»±±
±±ºPrograma  BaseAlqUniºAutor  Erick G. Dias       º Data   04/08/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Processamento da al­quota de Pauta de Pis Cofins por Qtde  º±±
±±Œ˜¹±±
±±ºRetorno    aRetorno = Array contendo informacoes de Pauta. 		      º±±
±±ˆ¼±*/
Static Function BaseAlqUni(nValor, cChaveCCZ, cContr, nAliquota, nBase, nSegUndPis, nSegUndCof)

Local		nBaseQuant	:= 0
Local 		nAliqRec	:= 0
Local 		aRet		:= {}
Local 		cCodNat	:= ""
Local 		lSegUndPau	:= SuperGetMv( "MV_PISCOFP" , .F. , .T. ,  )
Default	nAliquota	:= 0
Default	nBase		:= 0
Default 	nSegUndPis	:= 0
Default	nSegUndCof	:= 0

//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//Ir¡ buscar a al­quota conforme cdigo da natureza informado, para assim fazer    		
//a converso e encontar a quantidade referente a unidade de medida estabelecido pel RFB.  
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
IF CCZ->(msSeek(xFilial("CCZ")+cChaveCCZ))

	If cContr == "PIS"
		nAliqRec := CCZ->CCZ_ALQPIS
	Else
		nAliqRec := CCZ->CCZ_ALQCOF
	EndIF

	cCodNat := IIF( SubStr(CCZ->CCZ_COD,1,1) $ "7#8", SubStr(CCZ->CCZ_COD,1,1), "")
	
 	IF nAliqRec > 0
		IF !lSegUndPau
			nBaseQuant	:= NoRound((nAliquota/nAliqRec) * nBase,3)
		ElseIf cContr == "PIS"
			nBaseQuant	:= nSegUndPis
		Else
			nBaseQuant	:= nSegUndCof
		EndIf
		
		aAdd(aRet, {})
		nPos := Len(aRet)
		aAdd (aRet[nPos],nAliqRec) 		//Base de c¡lculo em quantidade
		aAdd (aRet[nPos],nBaseQuant)	//Al­quota em unidade de medida de produto.
		aAdd (aRet[nPos],cCodNat)		//Cdigo da Natureza da Receita.
	EndIF
EndIF

Return aRet

/*‘‹‘‹‘»±±
±±ºPrograma  RetChvCCZ ºAutor  Demetrio De Los Riosº Data   13/10/2011 º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Retorna a chave correta da tabela CCZ para buscar as aliq. º±±
±±º           pauta de PIS e COFINS. Busca a chv do reg. considerando a  º±±
±±º           data de emissao da SFT                                     º±±
±±Œ˜¹±±
±±ºUso        SPEDPISCOF                                                 º±±
±±Œ˜¹±±
±±ºRetorno    Chave da CCZ = TABELA + CODIGO + GRUPO + DATA              º±±
±±ˆ¼*/
Static Function RetChvCCZ(clTab,clCod,clGrupo,dlDtEnt)

Local 	aArea		:= GetArea()
Local	aCCZArea    := CCZ->(GetArea())
Local 	cCCZAlias	:= "CCZ"
Local 	cChvCCz 	:= Space(Len(CCZ->(CCZ_TABELA+CCZ_COD+CCZ_GRUPO+DtoS(CCZ_DTFIM))))
Local 	dLastDt		:= CtoD("//")
Local 	clIndex		:= ""
Local 	clFiltro	:= ""
Local 	nlIndex		:= 0
Default	clTab		:= ""
Default	clCod		:= ""
Default	clGrupo		:= ""
Default dlDtEnt		:= CtoD("//")

dbSelectArea(cCCZAlias)
(cCCZAlias)->(DbSetOrder(1))

#IFDEF TOP
	If (TcSrvType ()<>"AS/400")

    	cCCZAlias	:= GetNextAlias()

    	BeginSql Alias cCCZAlias

    		COLUMN CCZ_DTFIM AS DATE

    		SELECT
    			  CCZ.CCZ_TABELA
    			, CCZ.CCZ_COD
    			, CCZ.CCZ_GRUPO
    			, CCZ.CCZ_DTFIM
    		FROM
    			%Table:CCZ% CCZ
    		WHERE
    			CCZ.%NotDel%
    			AND CCZ.CCZ_FILIAL	= %xFilial:CCZ%
    			AND CCZ.CCZ_TABELA 	= %Exp:clTab%
    			AND CCZ.CCZ_COD		= %Exp:clCod%
    			AND CCZ.CCZ_GRUPO 	= %Exp:clGrupo%
    		ORDER BY
    			CCZ.CCZ_DTFIM
    	EndSql

	Else
#ENDIF

clIndex		:= CriaTrab(NIL,.F.)
clFiltro    := " CCZ_FILIAL=='"+ xFilial("CCZ") + "' "
clFiltro    += " .AND. CCZ_TABELA=='"	+ clTab		+"' "
clFiltro    += " .AND. CCZ_COD=='"		+ clCod		+"' "
clFiltro    += " .AND. CCZ_GRUPO=='"	+ clGrupo	+"' "

IndRegua(cCCZAlias,clIndex,CCZ->(IndexKey()),,clFiltro)
nlIndex := RetIndex(cCCZAlias)

#IFNDEF TOP
	dbSetIndex(clIndex+OrdBagExt())
#ENDIF

dbSelectArea(cCCZAlias)
dbSetOrder(nlIndex+1)

#IFDEF TOP
	Endif
#ENDIF

While (cCCZAlias)->(!Eof())
	If !Empty((cCCZAlias)->CCZ_DTFIM)
    	If (dlDtEnt<=(cCCZAlias)->CCZ_DTFIM) .AND. ( Empty(dLastDt) .OR. (dlDtEnt>dLastDt))
 			cChvCCz := ((cCCZAlias)->CCZ_TABELA+CCZ_COD+CCZ_GRUPO+DtoS(CCZ_DTFIM))
    	EndIf
    	dLastDt := (cCCZAlias)->CCZ_DTFIM
	Else
		cChvCCz := ((cCCZAlias)->CCZ_TABELA+CCZ_COD+CCZ_GRUPO+DtoS(CCZ_DTFIM))
	EndIf
	(cCCZAlias)->(dbSkip())
EndDo


CCZ->(RestArea(aCCZArea))
RestArea(aArea)

#IFDEF TOP
	If (TcSrvType ()<>"AS/400")
		DbSelectArea (cCCZAlias)
		(cCCZAlias)->(DbCloseArea ())
	Else
#ENDIF
		RetIndex(cCCZAlias)
		FErase(clIndex+OrdBagExt())
#IFDEF TOP
	EndIf
#ENDIF

Return cChvCCz

/*‘‹‘‹‘»±±
±±ºPrograma  VlrPauta  ºAutor  Erick G. Dias       º Data   09/09/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Processamento dos valores de aliquota e qtd por pauta.     º±±
±±Œ˜¹±±
±±ºRetorno    aRetorno = Array contendo informacoes de Pauta. 		      º±±
±±ˆ¼±*/
static Function VlrPauta(lCmpNRecFT, lCmpNRecB1, cContrib,cAliasSFT,cAliasSB1,lCmpNRecF4,lCmpPauta)

Local 	cChaveCCZ	:=	""
Local 	aBaseAlqUn	:=	{}
Local 	aRetorno	:=	{}
Local 	nPos		:=	0
Local	nAliquota	:=	0
Local	nBase		:=	0
Local 	clTab		:=	""
Local 	clCod		:=	""
Local 	clGrupo	:=	""
Local 	dlDtEnt	:=	CtoD("  /  /    ")

//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//Utiliza campos criados da natureza da receita na tabela SFT 
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
IF lCmpNRecFT

	cChaveCCZ := RetChvCCZ( (cAliasSFT)->FT_TNATREC , (cAliasSFT)->FT_CNATREC , (cAliasSFT)->FT_GRUPONC, (cAliasSFT)->FT_ENTRADA  )

	If !Empty(cChaveCCZ)

		IF cContrib == "PIS"
			nAliquota	:=	Iif(lCmpPauta, (cAliasSFT)->FT_PAUTPIS, (cAliasSB1)->B1_VLR_PIS)
			nBase		:=	(cAliasSFT)->FT_QUANT
			aBaseAlqUn 	:=	BaseAlqUni((cAliasSFT)->FT_VALPIS, cChaveCCZ, cContrib, nAliquota, nBase, (cAliasSFT)->FT_BASEPIS)

		ElseIF cContrib == "COF"
			nAliquota	:=	Iif(lCmpPauta, (cAliasSFT)->FT_PAUTCOF, (cAliasSB1)->B1_VLR_COF)
			nBase		:=	(cAliasSFT)->FT_QUANT
			aBaseAlqUn 	:=	BaseAlqUni((cAliasSFT)->FT_VALCOF, cChaveCCZ, cContrib, nAliquota, nBase, , (cAliasSFT)->FT_BASECOF)
		EndIF

	EndIf
	IF len(aBaseAlqUn) > 0
		aAdd(aRetorno, {})
		nPos := Len(aRetorno)
		aAdd (aRetorno[nPos],aBaseAlqUn[1][1]) 	//Base de c¡lculo em quantidade
		aAdd (aRetorno[nPos],aBaseAlqUn[1][2])	 	//Al­quota em unidade de medida de produto.
		aAdd (aRetorno[nPos],aBaseAlqUn[1][3])	 	//Cdigo da Natureza da Receita.
	EndIF
EndIF

//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//Se nao conseguiu buscar valores atraves da SFT, ira buscar atraves do produto.   
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
If Len(aRetorno) == 0

	If lCmpNRecB1 .And. !Empty(SB1->B1_TNATREC) .And. !Empty(SB1->B1_CNATREC)
		clTab	:= SB1->B1_TNATREC
		clCod	:= SB1->B1_CNATREC
		clGrupo	:= SB1->B1_GRPNATR
		dlDtEnt	:= (cAliasSFT)->FT_ENTRADA

	ElseIf  lCmpNRecF4 .And. !Empty(SF4->F4_TNATREC) .And. !Empty(SF4->F4_CNATREC)
		clTab	:= SF4->F4_TNATREC
		clCod	:= SF4->F4_CNATREC
		clGrupo	:= SF4->F4_GRPNATR
		dlDtEnt	:= (cAliasSFT)->FT_ENTRADA
	EndIf

	cChaveCCZ := RetChvCCZ(clTab,clCod,clGrupo,dlDtEnt)

	IF cContrib == "PIS"
		nAliquota	:=	Iif(lCmpPauta, (cAliasSFT)->FT_PAUTPIS, (cAliasSB1)->B1_VLR_PIS)
		nBase		:=	(cAliasSFT)->FT_QUANT
		aBaseAlqUn 	:=	BaseAlqUni((cAliasSFT)->FT_VALPIS, cChaveCCZ, cContrib, nAliquota, nBase, (cAliasSFT)->FT_BASEPIS)

	ElseIF cContrib == "COF"
		nAliquota	:=	Iif(lCmpPauta, (cAliasSFT)->FT_PAUTCOF, (cAliasSB1)->B1_VLR_COF)
		nBase		:=	(cAliasSFT)->FT_QUANT
		aBaseAlqUn 	:=	BaseAlqUni((cAliasSFT)->FT_VALCOF, cChaveCCZ, cContrib, nAliquota, nBase, , (cAliasSFT)->FT_BASECOF)
	EndIF

	IF Len(aBaseAlqUn) > 0
		aAdd(aRetorno, {})
		nPos := Len(aRetorno)
		aAdd (aRetorno[nPos],aBaseAlqUn[1][1]) 	//Base de c¡lculo em quantidade
		aAdd (aRetorno[nPos],aBaseAlqUn[1][2])	 	//Al­quota em unidade de medida de produto.
		aAdd (aRetorno[nPos],aBaseAlqUn[1][3])	 	//Cdigo da Natureza da Receita.
	EndIF
EndIF

//Se no conseguiu buscar al­quotas nem pela SFT e nem pelo produto, ento ir¡ considerar al­quota convertida da STF   
If Len(aRetorno) == 0
	aAdd(aRetorno, {})
	nPos := Len(aRetorno)

	IF cContrib == "PIS"
		aAdd (aRetorno[nPos],(cAliasSFT)->FT_PAUTPIS) 	//Base de c¡lculo em quantidade

	ElseIF cContrib == "COF"
		aAdd (aRetorno[nPos],(cAliasSFT)->FT_PAUTCOF) 	//Base de c¡lculo em quantidade
	EndIF

	aAdd (aRetorno[nPos],(cAliasSFT)->FT_QUANT)	 	//Al­quota em unidade de medida de produto.
	aAdd (aRetorno[nPos],"")	 						//Cdigo da Natureza da Receita.
EndIF

Return aRetorno

/*‰‘‹‘‹‘»±±
±±ºPrograma  Reg0208   ºAutor  Erick G. Dias       º Data   14/09/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Processamento do registro 0208.                            º±±
±±ˆ¼*/
Static Function Reg0208(cCodPro,nChvPai,cAlias,nPai,aReg0200,lCmpsSB5)

Local nPos	   := 0
Local aReg0208 := {}
DbSelectArea("SB5")
SB5->(DbSetOrder(1))

If lCmpsSB5 .AND. MsSeek(xFilial("SB5")+ALLTRIM(cCodPro)) .AND. !Empty(AllTrim(SB5->B5_TABINC)) // SB5->(FieldPos("B5_TABINC"))>0 .AND. SB5->(FieldPos("B5_CODGRU"))>0 .AND. SB5->(FieldPos("B5_MARCA"))>0
		aAdd(aReg0208, {})
		nPos := Len(aReg0208)
		aAdd (aReg0208[nPos], "0208")			//01 - REG
		aAdd (aReg0208[nPos], SB5->B5_TABINC)	//02 - COD_TAB
		aAdd (aReg0208[nPos], SB5->B5_CODGRU)	//03 - COD_GRU
		aAdd (aReg0208[nPos], SB5->B5_MARCA)	//04 - MARCA_COM
		PCGrvReg (cAlias,,aReg0208,,,nPai,nChvPai,,nTamTRBIt)
EndIF

Return

/*‘‹‘‹‘»±±
±±ºPrograma  RegM211   ºAutor  Erick G. Dias       º Data   28/09/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Processamento do registro M211.                            º±±
±±ˆ¼*/
Static Function RegM211(nBasePerc, nPaiM210,aRegM211,cIndTipCoo, cPer , cCodCont,nAlq )

Local nPos			:=0
Local nBaseAnt		:=0
Local nBaseExGer	:=0
Local nBaseExCoo	:=0
Local nVlBase		:=0
Local cAlias		:= "CE9"

DEFAULT cIndTipCoo := ""
DEFAULT nBasePerc	:= 0
DEFAULT nAlq	:= 0


nBaseAnt := nBasePerc

If aIndics[13] //AliasIndic(cAlias)
	dbSelectArea(cAlias)
	CE9->(DbSetOrder (2))

	If MsSeek(xFilial(cAlias)+cPer+cCodCont+cvaltochar(nAlq))
		nBaseExGer:= Iif(aFieldPos[66],CE9->CE9_EXGPIS,0)
		nBaseExCoo:= Iif(aFieldPos[67],CE9->CE9_EXEPIS,0)
	EndIF
EndIF

aAdd(aRegM211, {})
nPos := Len(aRegM211)
aAdd (aRegM211[nPos], nPaiM210)		//01 - REG
aAdd (aRegM211[nPos], "M211")		//01 - REG
aAdd (aRegM211[nPos],cIndTipCoo )	//02 - IND_TIP_COOP
aAdd (aRegM211[nPos],nBaseAnt )		//03 - VL_BC_CONT_ANT_EXC_COOP
aAdd (aRegM211[nPos],nBaseExGer )	//04 - VL_EXC_COOP_GER
aAdd (aRegM211[nPos],nBaseExCoo )	//05 - VL_EXC_ESP_COOP

If nBaseAnt > 0
	nVlBase := nBaseAnt - nBaseExGer - nBaseExCoo
EndIF

aAdd (aRegM211[nPos],nVlBase )	//06 - VL_BC_CONT

Return nVlBase


/*‘‹‘‹‘»±±
±±ºPrograma  RegM611   ºAutor  Erick G. Dias       º Data   28/09/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Processamento do registro M611.                            º±±
±±ˆ¼*/
Static Function RegM611(nBasePerc, nPaiM610, aRegM611,cIndTipCoo ,cPer, cCodCont, nAlq )

Local nPos			:=0
Local nBaseAnt		:=0
Local nBaseExGer	:=0
Local nBaseExCoo	:=0
Local nVlBase		:=0
Local cAlias		:= "CE9"

DEFAULT cIndTipCoo 	:= ""
DEFAULT nBasePerc	:= 0
DEFAULT nAlq	:= 0

nBaseAnt := nBasePerc

If aIndics[13] //AliasIndic(cAlias)
	dbSelectArea(cAlias)
	CE9->(DbSetOrder (3))
	If MsSeek(xFilial(cAlias)+cPer+cCodCont+cvaltochar(nAlq))
		nBaseExGer:= Iif(aFieldPos[68],CE9->CE9_EXGCOF,0)
		nBaseExCoo:= Iif(aFieldPos[69],CE9->CE9_EXECOF,0)
	EndIF
EndIF


aAdd(aRegM611, {})
nPos := Len(aRegM611)
aAdd (aRegM611[nPos], nPaiM610)	//01 - REG
aAdd (aRegM611[nPos], "M611")	//01 - REG
aAdd (aRegM611[nPos],cIndTipCoo )	//02 - IND_TIP_COOP
aAdd (aRegM611[nPos],nBaseAnt )	//03 - VL_BC_CONT_ANT_EXC_COOP
aAdd (aRegM611[nPos],nBaseExGer )	//04 - VL_EXC_COOP_GER
aAdd (aRegM611[nPos],nBaseExCoo )	//05 - VL_EXC_ESP_COOP

If nBaseAnt > 0
	nVlBase := nBaseAnt - nBaseExGer - nBaseExCoo
EndIF

aAdd (aRegM611[nPos],nVlBase )	//06 - VL_BC_CONT

Return nVlBase

/*‘‹‘‹‘»±±
±±ºPrograma  GravaC100   ºAutor  Erick G. Dias       º Data   28/09/11 º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.       Processamento para verificar se existe algum item com     º±±
±±ºDesc.       Cr©dito de PIS e Cofins.                                  º±*/
Static Function GravaC100(cChaveSFT,cEntSai,aCFOPs)

Local	lGravaC100	:=	.F.
Local	lMVNFCompl  :=	aParSX6[48]
Local	cCFOP		:=	""
Local  lSPEDCSC := GetNewPar("MV_SPEDCSC",.F.)

DbSelectArea ("SFT")
dbSetOrder(1)

If SFT->(msSeek(cChaveSFT))

	Do While !SFT->(Eof ()) .And.	cChaveSFT==SFT->FT_FILIAL+SFT->FT_TIPOMOV+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA

		cCFOP	:=	Alltrim(SFT->FT_CFOP)

		//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
		//Para as notas fiscais de entrada, verifica se o CST se enquadra nas regras para gerar o registro C100 
		//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
		If cEntSai == "1"
			IF SFT->FT_CSTPIS $ "50#51#52#53#54#55#56#60#61#62#63#64#65#66" .OR. SFT->FT_CSTCOF $ "50#51#52#53#54#55#56#60#61#62#63#64#65#66"
				lGravaC100 := .T.
				Exit
			ElseIF (SFT->FT_CSTPIS $ "98#99" .OR. SFT->FT_CSTCOF $ "98#99") .AND. SFT->FT_TIPO == "D"
				lGravaC100 := .T.
				Exit
			ElseIF lSPEDCSC .AND. (SFT->FT_CSTPIS $ "70#71#72#73#74#75" .OR. SFT->FT_CSTCOF $ "70#71#72#73#74#75")
				lGravaC100 := .T.
				Exit
			EndIf
		Else
		//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
		//Para as notas fiscais de saida, verifica se algum item da nota nao esta no parametro MV_CFEREC,	 
		//que indica um CFOP nao considerado como receita. Se algum item se enquadra nessa regra, toda a nf 
		//deve ser gerada, ou seja, registro C100 e todos os itens C170.									 
		//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
			If (cCFOP$aCFOPs[01] .Or. cCFOP$aCFOPs[03])  .AND. !(cCFOP$aCFOPs[02])
				If SFT->FT_TIPO$"IP" .AND. !lMVNFCompl
					lGravaC100	:= .F. 
				Else
					lGravaC100	:=	.T.
				EndIf
				Exit
			Endif
		Endif

		SFT->(dbSkip())
	EndDo

EndIF

Return lGravaC100

/*‘‹‘‹‘»±±
±±ºPrograma  RegF700   ºAutor  Erick G. Dias       º Data   26/10/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Processamento do registro F700.                            º±±
±±º           Busca valores de deduµes informadas pelo usu¡rio na tabelaº±±
±±º           CF2, para fazer deduo na apurao no bloco M.            º±±
±±ˆ¼±±
±±ParametroscPeriodo -> Per­odo para buscar as deduµes                 ±±
±±          aRegF700 -> Array com informaµes do registro F700          ±±
±±          lTabCF2  -> Indica se a tabela CF2 existe no dicionario     ±±
±±ˆ¼*/
Static Function RegF700(cPeriodo,aRegF700,lTabCF2,nCrPrAlPIS,nCrPrAlCOF)
Local	cAliasCF2	:=	"CF2"
Local	nPos		:=	0
Local	lAchouCF2	:=	.F.
Local lCF2CMPDED	:= aFieldPos[70]
Local	aParCF2		:=	{Iif(cRegime=="1","0",Iif(cRegime=="2","1","")),;
						 cPeriodo}

If lTabCF2
	If (lAchouCF2	:=	SPEDFFiltro(1,"CF2",@cAliasCF2,aParCF2))

		While !(cAliasCF2)->(Eof())

			If (nPos := aScan(aRegF700,{|aX| aX[2]==(cAliasCF2)->CF2_ORIDED .And. aX[3]==(cAliasCF2)->CF2_INDNAT .And. aX[7]==(cAliasCF2)->CF2_CNPJ})) == 0
				aAdd(aRegF700, {})
				nPos := Len(aRegF700)
				aAdd (aRegF700[nPos], "F700")						//01 - REG
				aAdd (aRegF700[nPos],(cAliasCF2)->CF2_ORIDED)		//02 - IND_ORI_DED
				aAdd (aRegF700[nPos],(cAliasCF2)->CF2_INDNAT)		//03 - IND_NAT_DED
				aAdd (aRegF700[nPos],(cAliasCF2)->CF2_DEDPIS)		//04 - VL_DED_PIS
				aAdd (aRegF700[nPos],(cAliasCF2)->CF2_DEDCOF)		//05 - VL_DED_COFINS
				aAdd (aRegF700[nPos],(cAliasCF2)->CF2_BASE)		//06 - VL_BC_OPER
				aAdd (aRegF700[nPos],(cAliasCF2)->CF2_CNPJ)		//07 - CNPJ
				aAdd (aRegF700[nPos],(cAliasCF2)->CF2_INFORM)		//08 - INF_COMP
			Else
				aRegF700[nPos][4] += (cAliasCF2)->CF2_DEDPIS
				aRegF700[nPos][5] += (cAliasCF2)->CF2_DEDCOF
				aRegF700[nPos][6] += (cAliasCF2)->CF2_BASE
			Endif

			IF lCF2CMPDED .AND. (cAliasCF2)->CF2_CMPDED == "1" .AND. (cAliasCF2)->CF2_INDNAT == "0"
				nCrPrAlPIS		+= (cAliasCF2)->CF2_DEDPIS
				nCrPrAlCOF		+= (cAliasCF2)->CF2_DEDCOF
			ElseIf (cAliasCF2)->CF2_INDNAT == "0" // Deduo de Natureza No Cumulativa
				nDedPISNC	+= (cAliasCF2)->CF2_DEDPIS
				nDedCOFNC	+= (cAliasCF2)->CF2_DEDCOF
			Else // Deduo de Natureza Cumulativa
				nDedPISC	+= (cAliasCF2)->CF2_DEDPIS
				nDedCOFC	+= (cAliasCF2)->CF2_DEDCOF
			Endif

			(cAliasCF2)->(DbSkip ())
		EndDo
	Endif
EndIf

If lAchouCF2
	SPEDFFiltro(2,,cAliasCF2)
Endif

Return
/*‘‹‘‹‘»±±
±±ºPrograma  DeDAnt    ºAutor  Erick G. Dias       º Data   28/10/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Busca valores de credores de PIS e Cofins de per­odos      º±±
±±º           anteriores, que esto gravados na tabela CF3. Poder¡ ter   º±±
±±º           origem atra´ves de devoluo de venda(CF3_ORIGEM == E), ou º±±
±±º           origem atra´ves de deduo do registro F700(CF3_ORIGEM = D)º±±
±±Œ˜¹±±
±±Parametros cPer   -> Per­odo de gerao do arquivo.                   ±±
±±ˆ¼*/
Static Function DeDAnt(cPer,aDevAntPer,aAjustMX10)
Local cAliasCF3 	:=	"CF3"
Local cPerAtu 		:=	cvaltochar(strzero(month(sTod(cPer) ) ,2)) + cvaltochar(year(sTod(cPer) ))
Local nPos			:=	0
Local lCmpCF3		:=	aFieldPos[32] .AND. aFieldPos[33]
Local lAchouCF3		:=	.F.
Local aParCF3		:=	{}
Local cCodCre		:= ""

DEFAULT aAjustMX10	:= {}

IF aIndics[15]

	aAdd(aParCF3,lCmpCF3)
	aAdd(aParCF3,cPerAtu)

    If (lAchouCF3 := SPEDFFiltro(1,"CF3",@cAliasCF3,aParCF3))

    	Do While !(cAliasCF3)->(Eof ())
    		//š„„„„„„„„„¿
			//Deducoes 
			//€„„„„„„„„„™
			If (cAliasCF3)->CF3_ORIGEM == "D"
				//š„„„„„„„„„„„„„„„„„„„„„„„„„„¿
				//Deducoes - Nao Cumulativo 
				//€„„„„„„„„„„„„„„„„„„„„„„„„„„™
				If (cAliasCF3)->CF3_REGIME == "0"
					//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
					//Soma os valores de PIS e COFINS para efetuar as Deducoes   
					//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
					nDedAPisNC +=  (cAliasCF3)->CF3_VLRPIS
					nDedACofNC +=  (cAliasCF3)->CF3_VLRCOF

					If (nPos := aScan (aDedAPisNC, {|aX| aX[1]==DTOS((cAliasCF3)->CF3_PERORI)})) == 0
						aAdd(aDedAPisNC, {})
						nPos := Len(aDedAPisNC)
						aAdd (aDedAPisNC[nPos], DTOS((cAliasCF3)->CF3_PERORI))				//01 - Periodo de origem
						aAdd (aDedAPisNC[nPos], (cAliasCF3)->CF3_VLRPIS)			   		//02 - Valor de PIS
					Else
						aDedAPisNC[nPos][2] 	+= (cAliasCF3)->CF3_VLRPIS
					EndIf

					If (nPos := aScan (aDedACofNC, {|aX| aX[1]==DTOS((cAliasCF3)->CF3_PERORI)})) == 0
						aAdd(aDedACofNC, {})
						nPos := Len(aDedACofNC)
						aAdd (aDedACofNC[nPos], DTOS((cAliasCF3)->CF3_PERORI))				//01 - Periodo de origem
						aAdd (aDedACofNC[nPos], (cAliasCF3)->CF3_VLRCOF)			   		//02 - Valor de COFINS
					Else
						aDedACofNC[nPos][2] 	+= (cAliasCF3)->CF3_VLRCOF
					EndIf
				//š„„„„„„„„„„„„„„„„„„„„„„¿
				//Deducoes - Cumulativo 
				//€„„„„„„„„„„„„„„„„„„„„„„™
				Else
					//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
					//Soma os valores de PIS e COFINS para efetuar as Deducoes   
					//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
					nDedAPisC +=  (cAliasCF3)->CF3_VLRPIS
					nDedACofC +=  (cAliasCF3)->CF3_VLRCOF

					If (nPos := aScan (aDedAPisC, {|aX| aX[1]==DTOS((cAliasCF3)->CF3_PERORI)})) == 0
						aAdd(aDedAPisC, {})
						nPos := Len(aDedAPisC)
						aAdd (aDedAPisC[nPos], DTOS((cAliasCF3)->CF3_PERORI))				//01 - Periodo de origem
						aAdd (aDedAPisC[nPos], (cAliasCF3)->CF3_VLRPIS)			   		//02 - Valor de PIS
					Else
						aDedAPisC[nPos][2] 	+= (cAliasCF3)->CF3_VLRPIS
					EndIf


					If (nPos := aScan (aDedACofC, {|aX| aX[1]==DTOS((cAliasCF3)->CF3_PERORI)})) == 0
						aAdd(aDedACofC, {})
						nPos := Len(aDedACofC)
						aAdd (aDedACofC[nPos], DTOS((cAliasCF3)->CF3_PERORI))				//01 - Periodo de origem
						aAdd (aDedACofC[nPos], (cAliasCF3)->CF3_VLRCOF)			   		//02 - Valor de Cofins
					Else
						aDedACofC[nPos][2] 	+= (cAliasCF3)->CF3_VLRCOF
					EndIf
				Endif

			ElseIF(cAliasCF3)->CF3_ORIGEM == "E" .AND. lCmpCF3 .AND. cRegime <> "1" // Devoluo
				aAdd(aDevAntPer, {})
				nPos	:=	Len (aDevAntPer)
				aAdd (aDevAntPer[nPos], (cAliasCF3)->CF3_NFDEV)
				aAdd (aDevAntPer[nPos], (cAliasCF3)->CF3_PERORI)
				aAdd (aDevAntPer[nPos], (cAliasCF3)->CF3_VLRPIS)
				aAdd (aDevAntPer[nPos], (cAliasCF3)->CF3_VLRCOF)
				aAdd (aDevAntPer[nPos], (cAliasCF3)->CF3_NFORI)
				aAdd (aDevAntPer[nPos], "") // Posicao 06 - Apenas para igualar tamanho do vetor da Devolucao onde a nota original © de per­odo anterior
			ElseIF (cAliasCF3)->CF3_ORIGEM == "A"
				aAdd(aAjustMX10, {})
				nPos	:=	Len (aAjustMX10)
				aAdd (aAjustMX10[nPos], (cAliasCF3)->CF3_PERORI)
				aAdd (aAjustMX10[nPos], (cAliasCF3)->CF3_VLRPIS)
				aAdd (aAjustMX10[nPos], (cAliasCF3)->CF3_VLRCOF)
				//Buscar origem na CF5 e pegar o cdigo do cr©dito
				cCodCre := CF5CodCre((cAliasCF3)->CF3_NFORI)
				aAdd (aAjustMX10[nPos], cCodCre) //Criar campos para o cdigo do cr©dito, para utilizao nos pr´xoimos per­odos
				aAdd (aAjustMX10[nPos], (cAliasCF3)->CF3_NFORI)
				aAdd (aAjustMX10[nPos], (cAliasCF3)->CF3_ORIGEM)
			ElseIF (cAliasCF3)->CF3_ORIGEM == "C"
				aAdd(aAjustMX10, {})
				nPos	:=	Len (aAjustMX10)
				aAdd (aAjustMX10[nPos], (cAliasCF3)->CF3_PERORI)
				aAdd (aAjustMX10[nPos], (cAliasCF3)->CF3_VLRPIS)
				aAdd (aAjustMX10[nPos], (cAliasCF3)->CF3_VLRCOF)
				aAdd (aAjustMX10[nPos], (cAliasCF3)->CF3_NFDEV)
				aAdd (aAjustMX10[nPos], (cAliasCF3)->CF3_NFORI)
				aAdd (aAjustMX10[nPos], (cAliasCF3)->CF3_ORIGEM)
			EndIF

			(cAliasCF3)->(DbSkip ())
		EndDo
	Endif
EndIF

If lAchouCF3
	SPEDFFiltro(2,,cAliasCF3)
Endif

Return

/*‘‹‘‹‘»±±
±±ºPrograma  IniDeddAntºAutor  Erick G. Dias       º Data   28/10/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Ir¡ zerar os valores do mªs atual, para que possa ser      º±±
±±º           preenchido com valores atuais no final da gerao do       º±±
±±º           arquivo.                                                   º±±
±±ˆ¼*/
Static Function IniDeddAnt(cPer)

Local cAliasCF3 :="CF3"
Local aAreaCF3	:={}
Local cAlias	:= "CF3"
Local dUltDia	:= LastDay (DDATAATE) + 1
Local cPerAtu	:=	cvaltochar(strzero(month(dUltDia ) ,2)) + cvaltochar(year(dUltDia ))
Local cPerOri   := ""
Local cChave	:= ""

IF aIndics[15]

	DbSelectArea (cAliasCF3)
	(cAliasCF3)->(DbSetOrder (1))
	#IFDEF TOP
	    If (TcSrvType ()<>"AS/400")
	    	cAliasCF3	:=	GetNextAlias()

		    cFiltro := "%"
	    	cCampos := "%"
	    	BeginSql Alias cAliasCF3

				SELECT
					CF3.CF3_PERORI,CF3.CF3_PERUTI, CF3.CF3_REGIME, CF3.CF3_VLRPIS, CF3.CF3_VLRCOF, CF3.CF3_ORIGEM, CF3.CF3_NFORI, CF3.CF3_NFDEV
					%Exp:cCampos%
				FROM
					%Table:CF3% CF3
				WHERE
					CF3.CF3_FILIAL=%xFilial:CF3% AND
					CF3.CF3_ORIGEM IN ('D','E','A','C') AND
					CF3.CF3_PERUTI  = %Exp:cPerAtu% AND
					%Exp:cFiltro%
					CF3.%NotDel%
			EndSql
		Else
	#ENDIF
		    cIndex	:= CriaTrab(NIL,.F.)
		    cFiltro	:= 'CF3_FILIAL=="'+xFilial ("CF3")+'".And.'
		    cFiltro	:= '(CF3_ORIGEM== "D#E#A#C") .And.'
		   	cFiltro += 'CF3_PERUTI =="'+ cPerAtu +'"'

		    IndRegua (cAliasCF3, cIndex, CF3->(IndexKey ()),, cFiltro)
		    nIndex := RetIndex(cAliasCF3)

			#IFNDEF TOP
				DbSetIndex (cIndex+OrdBagExt ())
			#ENDIF

			DbSelectArea (cAliasCF3)
		    DbSetOrder (nIndex+1)
	#IFDEF TOP
		Endif
	#ENDIF

	DbSelectArea (cAliasCF3)
	(cAliasCF3)->(DbGoTop ())
	ProcRegua ((cAliasCF3)->(RecCount ()))
	dbSelectArea(cAlias)
	DbSetOrder(1)
	Do While !(cAliasCF3)->(Eof ())
		aAreaCF3 :=CF3->(GetArea())
		If Valtype((cAliasCF3)->CF3_PERORI) == "D"
			cPerOri := DTOS((cAliasCF3)->CF3_PERORI)
		Else
			cPerOri := (cAliasCF3)->CF3_PERORI
		Endif
		
		IF (cAliasCF3)->CF3_ORIGEM == "D"
			cChave	:= xFilial("CF3")+cPerOri+(cAliasCF3)->CF3_PERUTI+(cAliasCF3)->CF3_REGIME+(cAliasCF3)->CF3_ORIGEM
		ElseIF (cAliasCF3)->CF3_ORIGEM $ "E/A/C"
			cChave  := xFilial("CF3")+cPerOri+(cAliasCF3)->CF3_PERUTI+(cAliasCF3)->CF3_REGIME+(cAliasCF3)->CF3_ORIGEM+(cAliasCF3)->CF3_NFORI+(cAliasCF3)->CF3_NFDEV
		EndIF
		
		If MsSeek(cChave)
			RecLock(cAlias,.F.)
			CF3->CF3_VLRPIS := 0
			CF3->CF3_VLRCOF := 0
			MsUnLock()
			CF3->(FKCommit())
		EndIF
		RestArea(aAreaCF3)
		(cAliasCF3)->(DbSkip ())
	EndDo

	#IFDEF TOP
		If (TcSrvType ()<>"AS/400")
			DbSelectArea (cAliasCF3)
			(cAliasCF3)->(DbCloseArea ())
		Else
	#ENDIF
			RetIndex("CF3")
			FErase(cIndex+OrdBagExt ())
	#IFDEF TOP
		EndIf
	#ENDIF
EndIF

Return


/*‘‹‘‹‘»±±
±±ºPrograma  SaldoDed  ºAutor  Erick G. Dias       º Data   12/04/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Grava na tabela CF3 os valores de saldo de deduµes para   º±±
±±º    .      os prximos per­odos.                                      º±±
±±ˆ¼*/
Static Function SaldoDed(dPerOri, cPerUti, cRegime, nValPis, nValCof, cOrigem, cNumOri, cNumDev )

Local	cAlias	:=	"CF3"
Local cChave	:= ""

DEFAULT cNumOri := ""
DEFAULT cNumDev := ""

IF cOrigem == "D"
	cChave	:= xFilial(cAlias)+dTos(dPerOri)+cPerUti+cRegime+cOrigem
ElseIF cOrigem $ "E/A/C"
	cChave  := xFilial(cAlias)+dTos(dPerOri)+cPerUti+cRegime+cOrigem+PADR(cNumOri,TamSx3('CF3_NFORI')[1])+PADR(cNumDev,TamSx3('CF3_NFDEV')[1])
EndIF

If aIndics[15]  .AND. !Empty(cChave)
	dbSelectArea(cAlias)
	DbSetOrder(1)
	If !MsSeek(cChave)
		RecLock(cAlias,.T.)
		CF3->CF3_FILIAL	:=	xFilial(cAlias)
		CF3->CF3_PERORI	:=	dPerOri
		CF3->CF3_REGIME	:=	cRegime
		CF3->CF3_PERUTI	:=	cPerUti
		CF3->CF3_VLRPIS 	:=  nValPis
		CF3->CF3_VLRCOF 	:=	nValCof
		CF3->CF3_ORIGEM 	:=	cOrigem
		CF3->CF3_NFORI 	:=	cNumOri
		CF3->CF3_NFDEV 	:=	cNumDev
		MsUnLock()
		CF3->(FKCommit())
	Else
		RecLock(cAlias,.F.)
		CF3->CF3_VLRPIS 	+= nValPis
		CF3->CF3_VLRCOF 	+= nValCof
		MsUnLock()
		CF3->(FKCommit())
	EndIf

EndIF

Return


/*‘‹‘‹‘»±±
±±ºPrograma  AbateDev  ºAutor  Erick G. Dias       º Data   08/11/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Abate vamoes de ajustes das devoluµes de per­odos         º±±
±±º    .      anteriores.                                                º±±
±±ˆ¼*/
Static Function AbateDev(aRegM210,aRegM220,aRegM610,aRegM620,aDevolucao,aDevAntPer)

Local nCont		:= 0
Local nContAux	:= 0
Local nReducao	:= 0
Local cDescDevol := ""

For nCont	:=1 to Len(aRegM210)
	//š„„„„„„„„„„„„„„„„„„„„„¿
	//Regime Cumulativo	
	//€„„„„„„„„„„„„„„„„„„„„„™
	IF aRegM210[nCont][2] $  SpdXRetCod(1,{"C"})
		For nContAux := 1 To Len(aDevAntPer)
			//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
			//Se tiver valor de PIS para abater e se for do Regime Cumulativo	
			//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
			If 	(aDevAntPer[nContAux][3]>0) .And.  ( Empty(aDevAntPer[nContAux][6]) .OR. aDevAntPer[nContAux][6]=="2" )

				If Len(aDevAntPer[nContAux]) >= 11
					cDescDevol := "Dev. venda ref. doc.:" + AllTrim(aDevAntPer[nContAux][5]) + "," +;
					             "s©rie:" + AllTrim(aDevAntPer[nContAux][11]) + "," +;
					             "item:" + AllTrim(aDevAntPer[nContAux][9]) + "," +;
					             "filial:" + AllTrim(aDevAntPer[nContAux][10]) + "," +;
					             "Doc. Dev:" + AllTrim(aDevAntPer[nContAux][1]) + "," +;
					             "s©rie:" + AllTrim(aDevAntPer[nContAux][8]) + ;
					             IIf(Len(aDevAntPer[nContAux]) >= 12, ",item:" + AllTrim(aDevAntPer[nContAux][12]), "")
				EndIf

				IF aDevAntPer[nContAux][3] < aRegm210[nCont][13]
					nReducao :=aDevAntPer[nContAux][3]
					RegM220(@aRegM220,.F.,nCont, nReducao,"06",aDevAntPer[nContAux][1],aDevAntPer[nContAux][2],,,cDescDevol)
					aRegM210[nCont][10]	+= nReducao // Joga no total de ajuste de reduo
					aRegM210[nCont][13]:= aRegM210[nCont][13] - nReducao
					aDevAntPer[nContAux][3]	:= 0
				ELse
					nReducao	:= aRegm210[nCont][13]
					RegM220(@aRegM220,.F.,nCont, nReducao ,"06",aDevAntPer[nContAux][1],aDevAntPer[nContAux][2],,,cDescDevol)
					aRegM210[nCont][10]	+= nReducao // Joga no total de ajuste de reduo
					aRegM210[nCont][13]:= aRegM210[nCont][13] - nReducao
					aDevAntPer[nContAux][3]	:= aDevAntPer[nContAux][3] - nReducao
					Exit
				EndIf
			EndIf
		Next nContAux
	//š„„„„„„„„„„„„„„„„„„„„„¿
	//Regime Nao-Cumulativo
	//€„„„„„„„„„„„„„„„„„„„„„™
	Elseif aRegM210[nCont][2] $ SpdXRetCod(1,{"NC"})
		For nContAux := 1 To Len(aDevAntPer)
			//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
			//Se tiver valor de PIS para abater e se for do Regime Nao-Cumulativo	
			//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
			If (aDevAntPer[nContAux][3] > 0) .And.  (aDevAntPer[nContAux][6]=="1")

				If Len(aDevAntPer[nContAux]) >= 11
					cDescDevol := "Dev. venda ref. doc.:" + AllTrim(aDevAntPer[nContAux][5]) + "," +;
					             "s©rie:" + AllTrim(aDevAntPer[nContAux][11]) + "," +;
					             "item:" + AllTrim(aDevAntPer[nContAux][9]) + "," +;
					             "filial:" + AllTrim(aDevAntPer[nContAux][10]) + "," +;
					             "Doc. Dev:" + AllTrim(aDevAntPer[nContAux][1]) + "," +;
					             "s©rie:" + AllTrim(aDevAntPer[nContAux][8]) + ;
					             IIf(Len(aDevAntPer[nContAux]) >= 12, ",item:" + AllTrim(aDevAntPer[nContAux][12]), "")
				EndIf

				IF aDevAntPer[nContAux][3] < aRegm210[nCont][13]
					nReducao :=aDevAntPer[nContAux][3]
					RegM220(@aRegM220,.F.,nCont, nReducao,"06",aDevAntPer[nContAux][1],aDevAntPer[nContAux][2],,,cDescDevol)
					aRegM210[nCont][10]	+= nReducao // Joga no total de ajuste de reduo
					aRegM210[nCont][13]:= aRegM210[nCont][13] - nReducao
					aDevAntPer[nContAux][3]	:= 0
				ELse
					nReducao	:= aRegm210[nCont][13]
					RegM220(@aRegM220,.F.,nCont, nReducao ,"06",aDevAntPer[nContAux][1],aDevAntPer[nContAux][2],,,cDescDevol)
					aRegM210[nCont][10]	+= nReducao // Joga no total de ajuste de reduo
					aRegM210[nCont][13]:= aRegM210[nCont][13] - nReducao
					aDevAntPer[nContAux][3]	:= aDevAntPer[nContAux][3] - nReducao
					Exit
				EndIf
			EndIf
		Next nContAux
	Endif
Next nCont

For nCont	:=1 to Len(aRegM610)
	//š„„„„„„„„„„„„„„„„„„„„„¿
	//Regime Cumulativo	
	//€„„„„„„„„„„„„„„„„„„„„„™
	IF aRegM610[nCont][2] $  SpdXRetCod(1,{"C"})
		For nContAux := 1 To Len(aDevAntPer)
			//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
			//Se tiver valor de COF para abater e se for do Regime Cumulativo	
			//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
			If (aDevAntPer[nContAux][4]>0) .And.  (Empty(aDevAntPer[nContAux][6]) .OR. aDevAntPer[nContAux][6]=="2")

				If Len(aDevAntPer[nContAux]) >= 11
					cDescDevol := "Dev. venda ref. doc.:" + AllTrim(aDevAntPer[nContAux][5]) + "," +;
					             "s©rie:" + AllTrim(aDevAntPer[nContAux][11]) + "," +;
					             "item:" + AllTrim(aDevAntPer[nContAux][9]) + "," +;
					             "filial:" + AllTrim(aDevAntPer[nContAux][10]) + "," +;
					             "Doc. Dev:" + AllTrim(aDevAntPer[nContAux][1]) + "," +;
					             "s©rie:" + AllTrim(aDevAntPer[nContAux][8]) + ;
					             IIf(Len(aDevAntPer[nContAux]) >= 12, ",item:" + AllTrim(aDevAntPer[nContAux][12]), "")
				EndIf

				IF aDevAntPer[nContAux][4] < aRegm610[nCont][13]
					nReducao :=aDevAntPer[nContAux][4]
					RegM620(@aRegM620,.F.,nCont,nReducao,"06",aDevAntPer[nContAux][1],aDevAntPer[nContAux][2],,,cDescDevol)
					aRegM610[nCont][10]	+= nReducao // Joga no total de ajuste de reduo
					aRegM610[nCont][13]:= aRegM610[nCont][13] - nReducao
					aDevAntPer[nContAux][4]	:= 0
				ELse
					nReducao	:= aRegm610[nCont][13]
					RegM620(@aRegM620,.F.,nCont, nReducao ,"06",aDevAntPer[nContAux][1],aDevAntPer[nContAux][2],,,cDescDevol)
					aRegM610[nCont][10]	+= nReducao // Joga no total de ajuste de reduo
					aRegM610[nCont][13]:= aRegM610[nCont][13] - nReducao
					aDevAntPer[nContAux][4]	:= aDevAntPer[nContAux][4] - nReducao
					//Grava para periodo futuro
					Exit
				EndIf
			EndIf
		Next nContAux
	Elseif aRegM610[nCont][2] $ SpdXRetCod(1,{"NC"})
		For nContAux := 1 To Len(aDevAntPer)
			//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
			//Se tiver valor de COF para abater e se for do Regime Nao-Cumulativo	
			//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
			If (aDevAntPer[nContAux][4] > 0) .And. (aDevAntPer[nContAux][6]=="1")

				If Len(aDevAntPer[nContAux]) >= 11
					cDescDevol := "Dev. venda ref. doc.:" + AllTrim(aDevAntPer[nContAux][5]) + "," +;
					             "s©rie:" + AllTrim(aDevAntPer[nContAux][11]) + "," +;
					             "item:" + AllTrim(aDevAntPer[nContAux][9]) + "," +;
					             "filial:" + AllTrim(aDevAntPer[nContAux][10]) + "," +;
					             "Doc. Dev:" + AllTrim(aDevAntPer[nContAux][1]) + "," +;
					             "s©rie:" + AllTrim(aDevAntPer[nContAux][8]) + ;
					             IIf(Len(aDevAntPer[nContAux]) >= 12, ",item:" + AllTrim(aDevAntPer[nContAux][12]), "")
				EndIf

				IF aDevAntPer[nContAux][4] < aRegM610[nCont][13]
					nReducao :=aDevAntPer[nContAux][4]
					RegM620(@aRegM620,.F.,nCont, nReducao,"06",aDevAntPer[nContAux][1],aDevAntPer[nContAux][2],,,cDescDevol)
					aRegM610[nCont][10]	+= nReducao // Joga no total de ajuste de reduo
					aRegM610[nCont][13]:= aRegM610[nCont][13] - nReducao
					aDevAntPer[nContAux][4]	:= 0
				ELse
					nReducao	:= aRegM610[nCont][13]
					RegM620(@aRegM620,.F.,nCont, nReducao ,"06",aDevAntPer[nContAux][1],aDevAntPer[nContAux][2],,,cDescDevol)
					aRegM610[nCont][10]	+= nReducao // Joga no total de ajuste de reduo
					aRegM610[nCont][13]:= aRegM610[nCont][13] - nReducao
					aDevAntPer[nContAux][4]	:= aDevAntPer[nContAux][4] - nReducao
					Exit
				EndIf
			EndIf
		Next nContAux
	Endif
Next nCont

Return

 /*‘‹‘‹‘»±±
±±ºPrograma  GX20Canc  ºAutor   Vitor Felipe       º Data   03/11/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.     Abate dos Registros M210 e M610 os valores de notas fiscais º±±
±±º           Canceladas em periodos anteriores gerando os ajustes nos   º±±
±±º           Registros M220 e M620.									  º±±
±±ºRetorno    ->Array com as NF canceladas do per­odo.                   º±±
±±ˆ¼*/
Static function GX20Canc(aRegM210,aRegM220,aRegM610,aRegM620,cRegime,dDataDe)

Local 	nX 			:= 	0
Local 	nY 			:= 	0
Local 	nPos 		:= 	0
Local 	cIndAj		:= 	"0"
Local 	nCodAjus	:= 	"06"
Local 	cDescr		:= 	"NOTA FISCAL CANCELADA"
Local 	cData		:= 	""
Local 	lTot		:= 	.F.
Local 	lPuta		:=	.F.
Local 	cAltDt		:= 	SubStr(DTos(dDataDe),5,2)+SubStr(Dtos(dDataDe),1,4)

dbSelectArea("CF4")
dbSetOrder(1)

For nX := 1 to Len(aRegM210)
	//Canceladas
	Do While !CF4->(Eof ())
		If CF4->CF4_VALPIS <> CF4->CF4_ORIPIS .And. CF4->CF4_DTALT == cAltDt
			RecLock ("CF4",.F.)
				CF4->CF4_VALPIS := CF4->CF4_ORIPIS
			MsUnLock ()
		EndIf

		//Se o tipo da posicao 05 do array for caracter, indica que se trata de um registro de Pauta
		If ValType(aRegM210[nX][5]) == "C"
			lPauta	:=	.T.
		Else
			lPauta	:=	.F.
		Endif

		// Valor do Ajuste + Diferenca + Cod. Contribuicao + Aliq. PIS ou Aliq. PIS Pauta.
		If cAltDt >= CF4->CF4_DTALT .And. CF4->CF4_VALPIS > 0 .And. aRegM210[nX][2] == CF4->CF4_CONPIS .And.;
		 Iif(lPauta,aRegM210[nX][7]==CF4->CF4_PATPIS,aRegM210[nX][5]==CF4->CF4_ALIPIS)

			If aRegM210[nX][13] >= CF4->CF4_VALPIS
				aRegM210[nX][10] += CF4->CF4_VALPIS
				lTot := .T.
			ElseIf aRegM210[nX][13] < CF4->CF4_VALPIS
				aRegM210[nX][10] += aRegM210[nX][13]
				lTot := .F.
			EndIf
			//Gravacao do Registro M220 e Aglutina Valores com Chave Semelhante.
			If (nPosM220 := aScan (aRegM220, {|aX| aX[1]== nX .AND. aX[3]==cIndAj .AND. aX[5]==nCodAjus  .AND. aX[6]== CF4->CF4_NOTA .AND. aX[7]==cDescr })) == 0
				aAdd(aRegM220, {})
				nPos := Len(aRegM220)
				cData:= SubStr(Dtos(CF4->CF4_DATAE),7,2)+SubStr(Dtos(CF4->CF4_DATAE),5,2)+SubStr(Dtos(CF4->CF4_DATAE),1,4)
				aAdd (aRegM220[nPos], nX)			   									//01 - REG DO PAI
				aAdd (aRegM220[nPos], "M220")											//02 - REG
				aAdd (aRegM220[nPos], cIndAj)											//03 - IND_AJ
				aAdd (aRegM220[nPos], Iif(lTot,CF4->CF4_VALPIS,aRegM210[nX][13]))	//04 - VL_AJ
				aAdd (aRegM220[nPos], nCodAjus)			   								//05 - COD_AJ
				aAdd (aRegM220[nPos], CF4->CF4_NOTA)	   								//06 - NUM_DOC
				aAdd (aRegM220[nPos], cDescr)			 								//07 - DESCR_AJ
				aAdd (aRegM220[nPos], cData)											//08 - DT_REF
			Else
				aRegM220[nPosM220][4] += Iif(lTot,CF4->CF4_VALPIS,aRegM210[nX][13])
			EndIf
			If lTot
				aRegM210[nX][13] -= CF4->CF4_VALPIS
				RecLock ("CF4",.F.)
					CF4->CF4_ORIPIS	:= CF4->CF4_VALPIS
					If CF4_VALCOF == 0
						CF4->CF4_DTALT	:= cAltDt
					EndIf
					CF4->CF4_VALPIS 	:= 0
				MsUnLock ()
			Else
				RecLock ("CF4",.F.)
					CF4->CF4_ORIPIS	:= CF4->CF4_VALPIS
					If CF4_VALCOF == 0
						CF4->CF4_DTALT	:= cAltDt
					EndIf
					CF4->CF4_VALPIS	-= aRegM210[nX][13]
				MsUnLock ()
				aRegM210[nX][13] := 0
			EndIf
		EndIf
		CF4->(DbSkip ())
	Enddo
	CF4->(dbGotop())
Next(nX)

//š„„„„„„„„„„„„„„„„„„„„¿
// Valores para COFINS
//€„„„„„„„„„„„„„„„„„„„„™
lTot		:= .F.
nDifer		:= 0
CF4->(dbGotop())

For nX := 1 to Len(aRegM610)
	//Canceladas
	Do While !CF4->(Eof ())
		If CF4->CF4_VALCOF <> CF4->CF4_ORICOF .And. CF4->CF4_DTALT == cAltDt
			RecLock ("CF4",.F.)
				CF4->CF4_VALCOF := CF4->CF4_ORICOF
			MsUnLock ()
		EndIf

		//Se o tipo da posicao 05 do array for caracter, indica que se trata de um registro de Pauta
		If ValType(aRegM610[nX][5]) == "C"
			lPauta	:=	.T.
		Else
			lPauta	:=	.F.
		Endif

		// Valor do Ajuste + Diferenca + Cod. Contribuicao + Aliq. PIS ou Aliq. PIS Pauta.
		If cAltDt >= CF4->CF4_DTALT .And. CF4->CF4_VALCOF > 0 .And. aRegM610[nX][2] == CF4->CF4_CONCOF .And.;
		 Iif(lPauta,aRegM610[nX][7]==CF4->CF4_PATCOF,aRegM610[nX][5]==CF4->CF4_ALICOF)
			If aRegM610[nX][13] >= CF4->CF4_VALCOF
				aRegM610[nX][10] += CF4->CF4_VALCOF
				lTot := .T.
			ElseIf aRegM610[nX][13] < CF4->CF4_VALCOF
				aRegM610[nX][10] += aRegM610[nX][13]
				lTot := .F.
			EndIf
			//Gravacao do Registro M620 e Aglutina Valores com Chave Semelhante.
			If (nPosM620 := aScan (aRegM620, {|aX| aX[1]== nX .AND. aX[3]==cIndAj .AND. aX[5]==nCodAjus  .AND. aX[6]== CF4->CF4_NOTA .AND. aX[7]==cDescr })) == 0
				aAdd(aRegM620, {})
				nPos := Len(aRegM620)
				cData:= SubStr(Dtos(CF4->CF4_DATAE),7,2)+SubStr(Dtos(CF4->CF4_DATAE),5,2)+SubStr(Dtos(CF4->CF4_DATAE),1,4)
				aAdd (aRegM620[nPos], nX)			   									//01 - REG DO PAI
				aAdd (aRegM620[nPos], "M620")											//02 - REG
				aAdd (aRegM620[nPos], cIndAj)											//03 - IND_AJ
				aAdd (aRegM620[nPos], Iif(lTot,CF4->CF4_VALCOF,aRegM610[nX][13]))	//04 - VL_AJ
				aAdd (aRegM620[nPos], nCodAjus)			   								//05 - COD_AJ
				aAdd (aRegM620[nPos], CF4->CF4_NOTA)	   								//06 - NUM_DOC
				aAdd (aRegM620[nPos], cDescr)			 								//07 - DESCR_AJ
				aAdd (aRegM620[nPos], cData)											//08 - DT_REF
			Else
				aRegM620[nPosM620][4] += Iif(lTot,CF4->CF4_VALCOF,aRegM610[nX][13])
			EndIf
			If lTot
				aRegM610[nX][13] -= CF4->CF4_VALCOF
				RecLock ("CF4",.F.)
					CF4->CF4_ORICOF	:= CF4->CF4_VALCOF
					CF4->CF4_DTALT	:= cAltDt
					CF4->CF4_VALCOF 	:= 0
				MsUnLock ()
			Else
				RecLock ("CF4",.F.)
					CF4->CF4_ORICOF	:= CF4->CF4_VALCOF
					CF4->CF4_DTALT	:= cAltDt
					CF4->CF4_VALCOF 	-= aRegM610[nX][13]
				MsUnLock ()
				aRegM610[nX][13] := 0
			EndIf
		EndIf
		CF4->(DbSkip ())
	Enddo
	CF4->(dbGotop())
Next(nX)

Return
 /*‘‹‘‹‘»±±
±±ºPrograma  RegM110   ºAutor   Vitor Felipe       º Data   11/11/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Geracao do Registro M110 - Ajuste do Credito de PIS/PASEP  º±±
±±º           Apurado.                                                   º±±
±±º           Registros M100 e M110.                                     º±±
±±Œ˜¹±±
±±ºRetorno    ->Array com as NF canceladas do per­odo.                   º±±
±±ˆ¼*/
Static Function RegM110(aRegM100,aRegM110,nTotContrb,cPer,aCredPresu,aAjuDev,nTotCredUt,aAjCredSCP,aAjustMX10,aCF5)

Local nPos		:= 0
Local cData		:= CTod("  /  /    ")
Local nX		:= 0
Local nContDev	:= 0
Local cVlAjuste := 0
Local lCF5		:= aIndics[17]
Local lAchouCF5	:=	.F.
Local lInfM115	:=	aFieldPos[78] .And. aFieldPos[79] .And. aFieldPos[80] .And. aFieldPos[81] .And. aFieldPos[82]
Local cAliasCF5	:=	"CF5"
Local aParFil	:=	{}
Local aCredUtil	:=	{}
Local nVAjuCF5	:= 	0
Local nContrAPag:=	0
Local nCountSCP	:=	0
Local nVlrAjSCP	:=	0
Local dUltDia 	:= LastDay (DDATAATE) + 1
Local cPeruti	:= cvaltochar(strzero(month(dUltDia ),2)) + cvaltochar(year(dUltDia ))
Local lExtM100 := .F.
Local lGeraM110 := .T.
Local cDescrAj := ""

DEFAULT aCredPresu	:= {}
DEFAULT aAjuDev		:= {}
DEfAULT aAjustMX10	:= {}
DEfAULT aCF5		:= {}

If lCF5
	dbSelectArea("CF5")
	dbSetOrder(1)
EndIF
//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//Faco o calculo para verificar quanto de Contribuicao ainda tenho para pagar.
//Subtraio o valor de credito utilizado do total da contribuicao.			   
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
nContrAPag	:=	nTotContrb - nTotCredUt

For nX = 1 to Len(aRegM100)

	// --- Ajustes para Sociedade em Conta de Participacao ---
	For nCountSCP := 1 To Len(aAjCredSCP)

		//Se possuo valor para ajustar credito
		If aAjCredSCP[nCountSCP][3] > 0

			//Zero variavel que ira controalr os valores de ajuste
			nVlrAjSCP	:=	0

			//Se o valor de ajuste eh menor ou igual ao valor que ainda possuo de credito em M100, utilizo todo o ajuste
			If aAjCredSCP[nCountSCP][3] <= aRegM100[nx][12]

				nVlrAjSCP					:=	aAjCredSCP[nCountSCP][3]
				aAjCredSCP[nCountSCP][3]	:=	0

			//Se o valor de ajuste superar o valor de credito, utilizo apenas o que tenho de credito e mantenho
			//o resto (Valor de ajuste - Valor de credito) no array de ajustes
			Elseif aRegM100[nx][12] > 0

				nVlrAjSCP					:=	aRegM100[nx][12]
				aAjCredSCP[nCountSCP][3]	-=	aRegM100[nx][12]
			Endif

		    If nVlrAjSCP > 0
			    //Crio registro M110 de ajuste
				aAdd(aRegM110, {})
				nPos := Len(aRegM110)
				aAdd (aRegM110[nPos], nX)							//01 - REG DO PAI
				aAdd (aRegM110[nPos], "M110")						//02 - REG
				aAdd (aRegM110[nPos], aAjCredSCP[nCountSCP][2])	//03 - IND_AJ
				aAdd (aRegM110[nPos], nVlrAjSCP)					//04 - VL_AJ
				aAdd (aRegM110[nPos], aAjCredSCP[nCountSCP][5])	//05 - COD_AJ
				aAdd (aRegM110[nPos], "")							//06 - NUM_DOC
				aAdd (aRegM110[nPos], aAjCredSCP[nCountSCP][6])	//07 - DESCR_AJ
				aAdd (aRegM110[nPos], aAjCredSCP[nCountSCP][7])	//08 - DT_REF

				//Somo o valor de ajuste ao campo 10 do registro M100 - VL_AJUS_REDUC
				aRegM100[nx][10]	+=	nVlrAjSCP

				//Faco os calculos para atribuicao do campo 12 do registro M100 - VL_CRED_DISP
				aRegM100[nx][12]	:=	aRegM100[nx][8] + aRegM100[nx][9] - aRegM100[nx][10] - aRegM100[nx][11]
			Endif
			//Se nao possuo mais valor de credito disponivel para este registro M100, nao utilizo mais ajustes
			If aRegM100[nx][12] <= 0

				Exit
        	Endif
    	Endif
    Next nCountSCP

	If Len(aAjuDev) > 0

		nContrAPag += aRegM100[nx][14]
		//nContrAPag += aRegM100[nx][12]
	EndIF

	For nContDev := 1 to Len(aAjuDev)

		If Len(aAjuDev[nContDev]) >= 14
			// aAjuDev[nContDev][14] -> Codigo de tipo de credito da NF de origem.
			// Verificando se existe um M100 com o mesmo tipo de credito do ajuste.
			lExtM100 := aScan(aRegM100,{|aX| AllTrim(aX[2]) == aAjuDev[nContDev][14]}) > 0

			// Se existe um M100 c/ o mesmo tipo de credito do ajuste, devo gerar o M110 para o pai correto.
			// Caso contrario, continua gerando para o primeiro M100 c/ credito disponivel.
			If lExtM100
				lGeraM110 := aRegM100[nx][2] == aAjuDev[nContDev][14]
			Else
				lGeraM110 := .T.
			EndIf
		Else
			lGeraM110 := .T.
		EndIf

	 	If lGeraM110
			If !aAjuDev[nContDev][12] .AND. aAjuDev[nContDev][7] > 0
				cVlAjuste	:= 0
				If aAjuDev[nContDev][7] <= aRegM100[nx][12]
					cVlAjuste	:=	aAjuDev[nContDev][7]
					aAjuDev[nContDev][7]	:=	0

				ElseIF aRegM100[nx][12] > 0
					If aAjuDev[nContDev][7] > aRegM100[nx][12]
						aAjuDev[nContDev][7]	-=	aRegM100[nx][12]
						cVlAjuste := aRegM100[nx][12]
					Else
						cVlAjuste := aRegM100[nx][8]
					EndIf
				EndIF

				//Somente ira adicionar M110 se houver valor de reducao.
				If cVlAjuste > 0
					aAdd(aRegM110, {})
					nPos := Len(aRegM110)
					//Registro M110
					aAdd (aRegM110[nPos], nX)	   					//01 - REG DO PAI
					aAdd (aRegM110[nPos], "M110")					//02 - REG
					aAdd (aRegM110[nPos], "0")						//03 - IND_AJ
					aAdd (aRegM110[nPos], cVlAjuste)				//04 - VL_AJ
					aAdd (aRegM110[nPos], "06")		   				//05 - COD_AJ
					aAdd (aRegM110[nPos], aAjuDev[nContDev][4])	//06 - NUM_DOC

					cDescrAj := "Dev. comp. ref. doc.:" + AllTrim(aAjuDev[nContDev][4]) + ;
					           ",s©rie:" + AllTrim(aAjuDev[nContDev][5]) + ;
					           ",item:" + AllTrim(aAjuDev[nContDev][11]) + ;
					           ",filial:" + IIf(Len(aAjuDev[nContDev]) >= 17,AllTrim(aAjuDev[nContDev][17]),"") + ;
					           ",Doc. Dev.:" + AllTrim(aAjuDev[nContDev][10]) + ;
					           IIf(Len(aAjuDev[nContDev]) >= 16, ",s©rie:" + AllTrim(aAjuDev[nContDev][16]),"") + ;
					           IIf(Len(aAjuDev[nContDev]) >= 18, ",item:" + AllTrim(aAjuDev[nContDev][18]),"")

					aAdd (aRegM110[nPos], cDescrAj) //07 - DESCR_AJ

					aAdd (aRegM110[nPos], aAjuDev[nContDev][1])	//08 - DT_REF
					aRegM100[nx][10]  +=  cVlAjuste
					aRegM100[nx][12] := aRegM100[nx][8] + aRegM100[nx][9] - aRegM100[nx][10] - aRegM100[nx][11]
					aAjuDev[nContDev][12]:= !aAjuDev[nContDev][12]

				EndIF
	        EndIf

			If aAjuDev[nContDev][7] > aRegM100[nx][12]
	        //Verifica se utilizou todo ajuste de reduo, caso contr¡rio ir¡ gravar na CF3 o valor restante para prximo mªs:
	 	        SaldoDed(aAjuDev[nContDev][1], cPeruti , "0", aAjuDev[nContDev][7], 0, "C", aAjuDev[nContDev][4], aRegM100[nx][2] )
			EndIF
		EndIf
	Next nContDev

	// --- Verifica utilizacao do credito em relacao a contribuicao ---
	If Len(aAjCredSCP) > 0 .OR. Len(aAjuDev) > 0
	  If aRegM100[nx][12] <= nContrAPag
	     aRegM100[nx][13] 	:= "0"
		 aRegM100[nx][14] 	:= aRegM100[nx][12]
		 nContrAPag := nContrAPag - aRegM100[nx][12]
	  Else
	     aRegM100[nx][13] 	:= "1"
		 aRegM100[nx][14] 	:= nContrAPag
		 nContrAPag := 0
	  Endif

	  aRegM100[nx][15]	:= aRegM100[nx][12] - aRegM100[nx][14]
	EndIf

	If Len(aCredPresu) > 0 .AND. aCredPresu[1] > 0 .And. aRegM100[nx][12] > 0 .And. aRegM100[nx][2] == "306"

		aAdd(aRegM110, {})
		nPos := Len(aRegM110)
		//Registro M110
		aAdd (aRegM110[nPos], nX)			   			//01 - REG DO PAI
		aAdd (aRegM110[nPos], "M110")					//02 - REG
		aAdd (aRegM110[nPos], aCredPresu[3])			//03 - IND_AJ
		aAdd (aRegM110[nPos], aCredPresu[1])			//04 - VL_AJ
		aAdd (aRegM110[nPos], aCredPresu[4])			//05 - COD_AJ
		aAdd (aRegM110[nPos], aCredPresu[5])			//06 - NUM_DOC
		aAdd (aRegM110[nPos], aCredPresu[6])			//07 - DESCR_AJ
		aAdd (aRegM110[nPos], aCredPresu[7])			//08 - DT_REF
		aRegM100[nx][9]	+= aCredPresu[1]
		aRegM100[nx][12]	:= aRegM100[nx][8] + aRegM100[nx][9] - aRegM100[nx][10] - aRegM100[nx][11]
		If aRegM100[nx][12] <= nContrAPag
			aRegM100[nx][13] := "0"
			aRegM100[nx][14] := aRegM100[nx][12]
		Else
			aRegM100[nx][13] := "1"
			aRegM100[nx][14] := aRegM100[nx][8] + nContrAPag
		EndIf
		aRegM100[nx][15]	:= aRegM100[nx][12] - aRegM100[nx][14]

		aCredPresu[1]:=0
		If aCredPresu[3]=="1"
			nContrAPag	:=	Iif(nContrAPag - aCredPresu[1] < 0, 0, nContrAPag - aCredPresu[1])
		Endif
	EndIf

	If lCF5
		aParFil	:=	{}
		aAdd(aParFil,DTOS(dDataDe))
		aAdd(aParFil,DTOS(dDataAte))
		aAdd(aParFil,aRegM100[nX][2])
		aAdd(aParFil,"0")

		If (lAchouCF5	:=	SPEDFFiltro(1,"CF5",@cAliasCF5,aParFil))
			nContrAPag += aRegM100[nx][14]

			//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
			//A partir do resultado da SPEDFFiltro (retorna os registros da tabela CF5 referente ao codigo da tabela 4.3.6 e periodo)					
			//verifico se o mesmo ja foi utilizado, pois apos gravar o array aRegM110, incluo o ajuste no array aCredUtil que funciona como um flag	
			//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
			While !(cAliasCF5)->(EOF()) .And.;
				aScan(aCredUtil,{|x| x[1]==(cAliasCF5)->CF5_CODIGO}) == 0

				//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
				//Se for um ajuste de acrescimo, sempre ira utilizar. Se for de reducao, verifico se possui credito no M100 
				//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
				If ((cAliasCF5)->CF5_INDAJU = "1") .Or. ((cAliasCF5)->CF5_INDAJU = "0" .And. aRegM100[nx][12] > 0)

					If ValType((cAliasCF5)->CF5_DTREF) == "D"
						cData	:=	SubStr(Dtos((cAliasCF5)->CF5_DTREF),7,2)+SubStr(Dtos((cAliasCF5)->CF5_DTREF),5,2)+SubStr(Dtos((cAliasCF5)->CF5_DTREF),1,4)
					Else
						cData	:=	SubStr((cAliasCF5)->CF5_DTREF,7,2)+SubStr((cAliasCF5)->CF5_DTREF,5,2)+SubStr((cAliasCF5)->CF5_DTREF,1,4)
					Endif

					nVAjuCF5 := Iif((cAliasCF5)->CF5_INDAJU=="0",Iif((cAliasCF5)->CF5_VALAJU > aRegM100[nx][12] , aRegM100[nx][12] , (cAliasCF5)->CF5_VALAJU ),(cAliasCF5)->CF5_VALAJU)

					aAdd(aRegM110, {})
					nPos := Len(aRegM110)
					aAdd (aRegM110[nPos], nX)			   						//01 - REG DO PAI
					aAdd (aRegM110[nPos], "M110")								//02 - REG
					aAdd (aRegM110[nPos], (cAliasCF5)->CF5_INDAJU)				//03 - IND_AJ
					aAdd (aRegM110[nPos], nVAjuCF5 )							//04 - VL_AJ
					aAdd (aRegM110[nPos], (cAliasCF5)->CF5_CODAJU)			   	//05 - COD_AJ
					aAdd (aRegM110[nPos], AllTrim((cAliasCF5)->CF5_NUMDOC))	//06 - NUM_DOC
					aAdd (aRegM110[nPos], AllTrim((cAliasCF5)->CF5_DESAJU))	//07 - DESCR_AJ
					aAdd (aRegM110[nPos], cData)								//08 - DT_REF

					If (cAliasCF5)->CF5_INDAJU = "1"
						aRegM100[nx][9]		+= nVAjuCF5
					Else
						aRegM100[nx][10]	+= nVAjuCF5
					EndIf
					aRegM100[nx][12]	:= aRegM100[nx][8] + aRegM100[nx][9] - aRegM100[nx][10] - aRegM100[nx][11]

                    //Verifica se utilizou todo ajuste de reduo, caso contr¡rio ir¡ gravar na CF3 o valor restante para prximo mªs:
                    If (cAliasCF5)->CF5_VALAJU > aRegM100[nx][12]
	                    SaldoDed((cAliasCF5)->CF5_DTREF, cPeruti , "0", (cAliasCF5)->CF5_VALAJU - nVAjuCF5, 0, "A", (cAliasCF5)->CF5_CODIGO, "" )
					EndIF

					//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
					//Gravo no array aCredUtil os ajustes de creditos que ja foram utilizados para o registro M100 pai. 
					//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
					aAdd(aCredUtil,{(cAliasCF5)->CF5_CODIGO})

					//Gravo no array aCF5 as informaµes necess¡rias para gerar o registro M115
					If lInfM115
						aAdd(aCF5,{AllTrim((cAliasCF5)->CF5_NUMDOC),;
								   AllTrim((cAliasCF5)->CF5_CST),;
								   (cAliasCF5)->CF5_BSCALC,;
								   (cAliasCF5)->CF5_ALIQ,;
								   (cAliasCF5)->CF5_CODCTA ,;
								   (cAliasCF5)->CF5_INFCOM})
					EndIf
				Endif
				(cAliasCF5)->(dbSkip())
			EndDo

			//Ir¡ atualizar os valores dos cr©ditos
			If aRegM100[nx][12] <= nContrAPag
				aRegM100[nx][13] 	:= "0"
				aRegM100[nx][14] 	:= aRegM100[nx][12]
				nContrAPag := nContrAPag - aRegM100[nx][12]
			Else
				aRegM100[nx][13] 	:= "1"
				aRegM100[nx][14] 	:= nContrAPag
				nContrAPag := 0
			EndIf
			aRegM100[nx][15]	:= aRegM100[nx][12] - aRegM100[nx][14]
			SPEDFFiltro(2,,cAliasCF5)

		Endif
	EndIF

	//Buscar CF3 de ajustes de cr©dito de reduo de per­odo anterior para M110 para este cdigo

	For nContDev := 1 to Len(aAjustMX10)

		cVlAjuste := 0
		//Se for o mesmo cdigo de cr©dito
		If AllTrim(aAjustMX10[nContDev][4]) == aRegM100[nX][2]

			If aAjustMX10[nContDev][2] <= aRegM100[nx][12]
				cVlAjuste	:=	aAjustMX10[nContDev][2]
				aAjustMX10[nContDev][2]	:=	0

			ElseIF aRegM100[nx][12] > 0
				If aAjustMX10[nContDev][2] > aRegM100[nx][12]
					aAjustMX10[nContDev][2]	-=	aRegM100[nx][12]
					cVlAjuste := aRegM100[nx][12]
				Else
					cVlAjuste := aRegM100[nx][8]
				EndIf
			EndIF

			//Somente ira adicionar M110 se houver valor de reducao.
			If cVlAjuste > 0
				aAdd(aRegM110, {})
				nPos := Len(aRegM110)
				//Registro M110
				aAdd (aRegM110[nPos], nX)	   					//01 - REG DO PAI
				aAdd (aRegM110[nPos], "M110")					//02 - REG
				aAdd (aRegM110[nPos], "0")						//03 - IND_AJ
				aAdd (aRegM110[nPos], cVlAjuste)				//04 - VL_AJ
				aAdd (aRegM110[nPos], "06")		   				//05 - COD_AJ
				aAdd (aRegM110[nPos], "")	//06 - NUM_DOC
				IF aAjustMX10[nContDev][6] == "A"
					aAdd (aRegM110[nPos], "Estorno referente a ajuste de reduo de cr©dito do per­odo: " + SubStr(Dtos(aAjustMX10[nContDev][1]),7,2)+SubStr(Dtos(aAjustMX10[nContDev][1]),5,2)+SubStr(Dtos(aAjustMX10[nContDev][1]),1,4))	//07 - DESCR_AJ
				Else
					aAdd (aRegM110[nPos], "Estorno referente a devoluo, documento fiscal: " +  aAjustMX10[nContDev][5])	//07 - DESCR_AJ
				EndIF
				aAdd (aRegM110[nPos], aAjustMX10[nContDev][1])	//08 - DT_REF
				aRegM100[nx][10]  +=  cVlAjuste
				aRegM100[nx][12] := aRegM100[nx][8] + aRegM100[nx][9] - aRegM100[nx][10] - aRegM100[nx][11]
			EndIF
		EndIF
	Next nContDev

	IF Len(aAjustMX10) > 0

		//Ir¡ atualizar os valores dos cr©ditos
		If aRegM100[nx][12] <= nContrAPag
			aRegM100[nx][13] 	:= "0"
			aRegM100[nx][14] 	:= aRegM100[nx][12]
			nContrAPag := nContrAPag - aRegM100[nx][12]
		Else
			aRegM100[nx][13] 	:= "1"
			aRegM100[nx][14] 	:= nContrAPag
			nContrAPag := 0
		EndIf
		aRegM100[nx][15]	:= aRegM100[nx][12] - aRegM100[nx][14]
	EndIF

	//Verifico se o registro M100 possui credito a ser transportado para o periodo seguinte
	If aRegM100[nX][15] > 0
		CredFutPIS(cPer,aRegM100[nX][2], Round(aRegM100[nX][12],2), Round(aRegM100[nX][14],2),aRegM100[nX][15],0,cPer)
    EndIf

Next(nX)
If lCF5
	CF5->(dbClosearea())
EndIF

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} RegM115
Processamento do registro M115
@param  aRegM115  - Array com informaµes do registro M115
	    aRegM110  - Array com informaµes do registro M110
	    aCFA      - Array com informaµes para preenchimento dos campos
no obrigatrios

@author Simone dos Santos de Oliveira
/*/
//-------------------------------------------------------------------
Static Function RegM115(aRegM115,aRegM110,aCF5)

Local nPos 	:= 0
Local nX  		:= 0
Local nPosCf5	:= 0
Local cNumDoc   := ""

Default aCF5 := {}

For nX:= 1 to Len(aRegM110)

	cNumDoc := aRegM110[nX][6]

	aAdd(aRegM115, {})
	nPos := Len(aRegM115)
	//Registro M115
	aAdd (aRegM115[nPos], nX)	   					//01 - REG DO PAI
	aAdd (aRegM115[nPos], "M115")					//02 - REG
	aAdd (aRegM115[nPos], aRegM110[nX][4])			//03 - DET_VALOR_AJ
	aAdd (aRegM115[nPos], "")	   					//04 - CST_PIS
	aAdd (aRegM115[nPos], "")		   				//05 - DET_BC_CRED
	aAdd (aRegM115[nPos], "")						//06 - DET_ALIQ
	aAdd (aRegM115[nPos], aRegM110[nX][8])			//07 - DT_OPER_AJ
	aAdd (aRegM115[nPos], aRegM110[nX][7])			//08 - DESC_AJ
	aAdd (aRegM115[nPos], "")						//09 - COD_CTA
	aAdd (aRegM115[nPos], "")						//10 - INFO_COMPL

	If !Empty(cNumDoc) .And. len(aCF5) > 0
		nPosCf5:= aScan(aCF5,{|x| x[1]==cNumDoc})
		If nPosaCf5 > 0
			aRegM115[nPos][4] := aCF5[nPosCf5][2]	//04 - CST_PIS
			aRegM115[nPos][5] := aCF5[nPosCf5][3]	//05 - DET_BC_CRED
			aRegM115[nPos][6] := aCF5[nPosCf5][4]	//06 - DET_ALIQ
			aRegM115[nPos][9] := aCF5[nPosCf5][5]	//09 - COD_CTA
			aRegM115[nPos][10]:= aCF5[nPosCf5][6]	//10 - INFO_COMPL
		EndIf
	EndIf

Next(nX)

Return

 /*±±ºPrograma  RegM510   ºAutor   Vitor Felipe       º Data   11/11/11º±±
±±ºDesc.      Geracao do Registro M510 - Ajuste do Credito de COFINS     º±±
±±º           Apurado.                                                   º±±
±±º           Registros M500 e M510.                                     º±±
±±ºRetorno    ->Array com as NF canceladas do per­odo.                   º±±*/
Static Function RegM510(aRegM500,aRegM510,nTotContrb,cPer,aCredPresu,aAjuDev,nTotCredUt,aAjCredSCP,aAjustMX10, aCF5)

local nPos	:= 0
Local cData	:= CTod("  /  /    ")
Local nX		:= 0
Local nContDev	:= 0
Local cVlAjuste := 0
Local lCF5		:= aIndics[17]
Local lInfM515	:= aFieldPos[78] .And. aFieldPos[79] .And. aFieldPos[80] .And. aFieldPos[81] .And. aFieldPos[82]
Local lAchouCF5	:=	.F.
Local cAliasCF5	:=	"CF5"
Local aParFil	:=	{}
Local aCredUtil	:=	{}
Local nVAjuCF5	:= 0
Local nContrAPag	:=	0
Local nCountSCP	:=	0
Local nVlrAjSCP	:=	0
Local dUltDia 	:= LastDay (DDATAATE) + 1
Local cPeruti	:= cvaltochar(strzero(month(dUltDia ),2)) + cvaltochar(year(dUltDia ))
Local lExtM500 := .F.
Local lGeraM510 := .T.
Local cDescrAj := ""

Default aCF5 := {}

IF lCf5
	dbSelectArea("CF5")
	dbSetOrder(1)
EndIF
//Faco o calculo para verificar quanto de Contribuicao ainda tenho para pagar.
//Subtraio o valor de credito utilizado do total da contribuicao.			   

nContrAPag	:=	nTotContrb - nTotCredUt

For nX = 1 to Len(aRegM500)

	// --- Ajustes para Sociedade em Conta de Participacao ---
	For nCountSCP := 1 To Len(aAjCredSCP)

		//Se possuo valor para ajustar credito
		If aAjCredSCP[nCountSCP][4] > 0

			//Zero variavel que ira controalr os valores de ajuste
			nVlrAjSCP	:=	0

			//Se o valor de ajuste eh menor ou igual ao valor que ainda possuo de credito em M100, utilizo todo o ajuste
			If aAjCredSCP[nCountSCP][4] <= aRegM500[nx][12]

				nVlrAjSCP					:=	aAjCredSCP[nCountSCP][4]
				aAjCredSCP[nCountSCP][4]	:=	0

			//Se o valor de ajuste superar o valor de credito, utilizo apenas o que tenho de credito e mantenho
			//o resto (Valor de ajuste - Valor de credito) no array de ajustes
			Elseif aRegM500[nx][12] > 0

				nVlrAjSCP					:=	aRegM500[nx][12]
				aAjCredSCP[nCountSCP][4]	-=	aRegM500[nx][12]
			Endif

		    If nVlrAjSCP > 0
			    //Crio registro M110 de ajuste
				aAdd(aRegM510, {})
				nPos := Len(aRegM510)
				aAdd (aRegM510[nPos], nX)							//01 - REG DO PAI
				aAdd (aRegM510[nPos], "M510")						//02 - REG
				aAdd (aRegM510[nPos], aAjCredSCP[nCountSCP][2])	//03 - IND_AJ
				aAdd (aRegM510[nPos], nVlrAjSCP)					//04 - VL_AJ
				aAdd (aRegM510[nPos], aAjCredSCP[nCountSCP][5])	//05 - COD_AJ
				aAdd (aRegM510[nPos], "")							//06 - NUM_DOC
				aAdd (aRegM510[nPos], aAjCredSCP[nCountSCP][6])	//07 - DESCR_AJ
				aAdd (aRegM510[nPos], aAjCredSCP[nCountSCP][7])	//08 - DT_REF

				//Somo o valor de ajuste ao campo 10 do registro M100 - VL_AJUS_REDUC
				aRegM500[nx][10]	+=	nVlrAjSCP

				//Faco os calculos para atribuicao do campo 12 do registro M100 - VL_CRED_DISP
				aRegM500[nx][12]	:=	aRegM500[nx][8] + aRegM500[nx][9] - aRegM500[nx][10] - aRegM500[nx][11]
			Endif

			//Se nao possuo mais valor de credito disponivel para este registro M100, nao utilizo mais ajustes
			If aRegM500[nx][12] <= 0
				Exit
        	Endif
    	Endif
    Next nCountSCP

	If Len(aAjuDev) > 0

		nContrAPag += aRegM500[nx][14]
		//nContrAPag += aRegM500[nx][12]
	EndIF

	For nContDev := 1 to Len(aAjuDev)

		If Len(aAjuDev[nContDev]) >= 15
			// aAjuDev[nContDev][15] -> Codigo de tipo de credito da NF de origem.
			// Verificando se existe um M500 com o mesmo tipo de credito do ajuste.
			lExtM500 := aScan(aRegM500,{|aX| AllTrim(aX[2]) == aAjuDev[nContDev][15]}) > 0

			// Se existe um M500 c/ o mesmo tipo de credito do ajuste, devo gerar o M510 para o pai correto.
			// Caso contrario, continua gerando para o primeiro M500 c/ credito disponivel.
			If lExtM500
				lGeraM510 := aRegM500[nx][2] == aAjuDev[nContDev][15]
			Else
				lGeraM510 := .T.
			EndIf
		Else
			lGeraM510 := .T.
		EndIf

		If lGeraM510
			If !aAjuDev[nContDev][13] .AND. aAjuDev[nContDev][9] > 0
				cVlAjuste	:= 0
				If aAjuDev[nContDev][9] <= aRegM500[nx][12]
					cVlAjuste	:=	aAjuDev[nContDev][9]
					aAjuDev[nContDev][9]	:= 0

				ElseIF aRegM500[nx][12] > 0
					If aAjuDev[nContDev][9] > aRegM500[nx][12]
						aAjuDev[nContDev][9]	-=  aRegM500[nx][12]
						cVlAjuste := aRegM500[nx][12]
					Else
						cVlAjuste := aRegM500[nx][8]
					EndIf
				EndIF
				//Somente ir¡ adicionar M510 se houver valor de reduo.
				If cVlAjuste > 0
					aAdd(aRegM510, {})
					nPos := Len(aRegM510)
					//Registro M510
					aAdd (aRegM510[nPos], nX)	   					//01 - REG DO PAI
					aAdd (aRegM510[nPos], "M510")					//02 - REG
					aAdd (aRegM510[nPos], "0")						//03 - IND_AJ
					aAdd (aRegM510[nPos], cVlAjuste)				//04 - VL_AJ
					aAdd (aRegM510[nPos], "06")		   				//05 - COD_AJ
					aAdd (aRegM510[nPos], aAjuDev[nContDev][4])	//06 - NUM_DOC

					cDescrAj := "Dev. comp. ref. doc.:" + AllTrim(aAjuDev[nContDev][4]) + ;
					           ",s©rie:"+ AllTrim(aAjuDev[nContDev][5]) + ;
					           ",item:" + AllTrim(aAjuDev[nContDev][11]) +  ;
					           ",filial:" + IIf(Len(aAjuDev[nContDev]) >= 17,AllTrim(aAjuDev[nContDev][17]),"") + ;
					           ",Doc. Dev.:" + AllTrim(aAjuDev[nContDev][10]) + ;
					           IIf(Len(aAjuDev[nContDev]) >= 16, ",s©rie:" + AllTrim(aAjuDev[nContDev][16]), "") + ;
					           IIf(Len(aAjuDev[nContDev]) >= 18, ",item:" + AllTrim(aAjuDev[nContDev][18]), "")

					aAdd (aRegM510[nPos], cDescrAj)	 //07 - DESCR_AJ

					aAdd (aRegM510[nPos], aAjuDev[nContDev][1])	//08 - DT_REF
					aRegM500[nx][10]  +=  cVlAjuste
					aRegM500[nx][12] := aRegM500[nx][8] + aRegM500[nx][9] - aRegM500[nx][10] - aRegM500[nx][11]
					aAjuDev[nContDev][13]:= !aAjuDev[nContDev][13]

				EndIF
	        EndIf

			If aAjuDev[nContDev][9] > aRegM500[nx][12]
	        //Verifica se utilizou todo ajuste de reduo, caso contr¡rio ir¡ gravar na CF3 o valor restante para prximo mªs:
	 	        SaldoDed(aAjuDev[nContDev][1], cPeruti , "0", 0, aAjuDev[nContDev][9], "C", aAjuDev[nContDev][4], aRegM500[nx][2])
			EndIF
		EndIf

	Next nContDev

	// --- Verifica utilizacao do credito em relacao a contribuicao ---
	If Len(aAjCredSCP) > 0 .OR. Len(aAjuDev) > 0
 	  If aRegM500[nx][12] <= nContrAPag
	   	 aRegM500[nx][13] 	:= "0"
		 aRegM500[nx][14] 	:= aRegM500[nx][12]
		 nContrAPag := nContrAPag - aRegM500[nx][12]
	  Else
		 aRegM500[nx][13] 	:= "1"
		 aRegM500[nx][14] 	:= nContrAPag
		 nContrAPag := 0
	  Endif
	  aRegM500[nx][15]	:= aRegM500[nx][12] - aRegM500[nx][14]
	EndIf

	IF Len(aCredPresu) >0 .AND. aCredPresu[2] > 0.And. aRegM500[nx][12] > 0  .And. aRegM500[nx][2] == "306"

		aAdd(aRegM510, {})
		nPos := Len(aRegM510)
		//Registro M510
		aAdd (aRegM510[nPos], nX)			   			//01 - REG DO PAI
		aAdd (aRegM510[nPos], "M510")					//02 - REG
		aAdd (aRegM510[nPos], aCredPresu[3])			//03 - IND_AJ
		aAdd (aRegM510[nPos], aCredPresu[2])			//04 - VL_AJ
		aAdd (aRegM510[nPos], aCredPresu[4])			//05 - COD_AJ
		aAdd (aRegM510[nPos], aCredPresu[5])			//06 - NUM_DOC
		aAdd (aRegM510[nPos], aCredPresu[6])			//07 - DESCR_AJ
		aAdd (aRegM510[nPos], aCredPresu[7])			//08 - DT_REF
		aRegM500[nx][9]	+= aCredPresu[2]
		aRegM500[nx][12]	:= aRegM500[nx][8] + aRegM500[nx][9] - aRegM500[nx][10] - aRegM500[nx][11]
		If aRegM500[nx][12] <= nContrAPag
			aRegM500[nx][13] := "0"
			aRegM500[nx][14] := aRegM500[nx][12]
		Else
			aRegM500[nx][13] := "1"
			aRegM500[nx][14] := aRegM500[nx][8] + nContrAPag
		EndIf
		aRegM500[nx][15]	:= aRegM500[nx][12] - aRegM500[nx][14]

		aCredPresu[2]:=0
		If aCredPresu[3]=="1"
			nContrAPag	:=	Iif(nContrAPag - aCredPresu[2] < 0, 0, nContrAPag - aCredPresu[2])
		Endif
	EndIf

	If lCF5
		aParFil	:=	{}
		aAdd(aParFil,DTOS(dDataDe))
		aAdd(aParFil,DTOS(dDataAte))
		aAdd(aParFil,aRegM500[nX][2])
		aAdd(aParFil,"1")

		If (lAchouCF5	:=	SPEDFFiltro(1,"CF5",@cAliasCF5,aParFil))

			nContrAPag += aRegM500[nx][14]

			//A partir do resultado da SPEDFFiltro (retorna os registros da tabela CF5 referente ao codigo da tabela 4.3.6 e periodo)					
			//verifico se o mesmo ja foi utilizado, pois apos gravar o array aRegM510, incluo o ajuste no array aCredUtil que funciona como um flag	
			While !(cAliasCF5)->(EOF()) .And.;
			aScan(aCredUtil,{|x| x[1]==(cAliasCF5)->CF5_INDAJU .And. x[2]==(cAliasCF5)->CF5_CODAJU .And. x[3]==(cAliasCF5)->CF5_DTREF .And. x[4]==(cAliasCF5)->CF5_DESAJU .And. x[5]==AllTrim((cAliasCF5)->CF5_NUMDOC)}) == 0

				//Se for um ajuste de acrescimo, sempre ira utilizar. Se for de reducao, verifico se possui credito no M500 
				If ((cAliasCF5)->CF5_INDAJU = "1") .Or. ((cAliasCF5)->CF5_INDAJU = "0" .And. aRegM500[nx][12] > 0)


					If ValType((cAliasCF5)->CF5_DTREF) == "D"
						cData	:=	SubStr(Dtos((cAliasCF5)->CF5_DTREF),7,2)+SubStr(Dtos((cAliasCF5)->CF5_DTREF),5,2)+SubStr(Dtos((cAliasCF5)->CF5_DTREF),1,4)
					Else
						cData	:=	SubStr((cAliasCF5)->CF5_DTREF,7,2)+SubStr((cAliasCF5)->CF5_DTREF,5,2)+SubStr((cAliasCF5)->CF5_DTREF,1,4)
					Endif

					nVAjuCF5 := Iif((cAliasCF5)->CF5_INDAJU=="0",Iif((cAliasCF5)->CF5_VALAJU > aRegM500[nx][12] , aRegM500[nx][12] , (cAliasCF5)->CF5_VALAJU ),(cAliasCF5)->CF5_VALAJU)

					aAdd(aRegM510, {})
					nPos := Len(aRegM510)
					aAdd (aRegM510[nPos], nX)			   						//01 - REG DO PAI
					aAdd (aRegM510[nPos], "M510")								//02 - REG
					aAdd (aRegM510[nPos], (cAliasCF5)->CF5_INDAJU)				//03 - IND_AJ
					aAdd (aRegM510[nPos], nVAjuCF5)	   							//04 - VL_AJ
					aAdd (aRegM510[nPos], (cAliasCF5)->CF5_CODAJU)			   	//05 - COD_AJ
					aAdd (aRegM510[nPos], AllTrim((cAliasCF5)->CF5_NUMDOC))	//06 - NUM_DOC
					aAdd (aRegM510[nPos], AllTrim((cAliasCF5)->CF5_DESAJU))	//07 - DESCR_AJ
					aAdd (aRegM510[nPos], cData)								//08 - DT_REF

					If (cAliasCF5)->CF5_INDAJU = "1"
						aRegM500[nx][9]		+= nVAjuCF5
					Else
						aRegM500[nx][10]	+= nVAjuCF5
					EndIf

					aRegM500[nx][12]	:= aRegM500[nx][8] + aRegM500[nx][9] - aRegM500[nx][10] - aRegM500[nx][11]
                    //Verifica se utilizou todo ajuste de reduo, caso contr¡rio ir¡ gravar na CF3 o valor restante para prximo mªs:
                    If (cAliasCF5)->CF5_VALAJU > aRegM500[nx][12]
	                    SaldoDed((cAliasCF5)->CF5_DTREF, cPeruti , "0",0, (cAliasCF5)->CF5_VALAJU - nVAjuCF5, "A", "", "" )
					EndIF
					//Gravo no array aCredUtil os ajustes de creditos que ja foram utilizados para o registro M500 pai. 
					aAdd(aCredUtil,{(cAliasCF5)->CF5_INDAJU,;
									(cAliasCF5)->CF5_CODAJU,;
									(cAliasCF5)->CF5_DTREF ,;
									(cAliasCF5)->CF5_DESAJU,;
									AllTrim((cAliasCF5)->CF5_NUMDOC) })

					//Gravo no array aCF5 as informaµes necess¡rias para gerar o registro M515
					If lInfM515
						aAdd(aCF5,{AllTrim((cAliasCF5)->CF5_NUMDOC),;
								   AllTrim((cAliasCF5)->CF5_CST),;
								   (cAliasCF5)->CF5_BSCALC,;
								   (cAliasCF5)->CF5_ALIQ,;
								   (cAliasCF5)->CF5_CODCTA ,;
								   (cAliasCF5)->CF5_INFCOM })
					EndIf
				Endif
				(cAliasCF5)->(dbSkip())
			EndDo
			//Ir¡ atualizar os valores dos cr©ditos
			If aRegM500[nx][12] <= nContrAPag
				aRegM500[nx][13] 	:= "0"
				aRegM500[nx][14] 	:= aRegM500[nx][12]
				nContrAPag := nContrAPag - aRegM500[nx][12]
			Else
				aRegM500[nx][13] 	:= "1"
				aRegM500[nx][14] 	:= nContrAPag
				nContrAPag := 0
			EndIf

			aRegM500[nx][15]	:= aRegM500[nx][12] - aRegM500[nx][14]
			SPEDFFiltro(2,,cAliasCF5)
		Endif
	EndIF

	//Buscar CF3 de ajustes de cr©dito de reduo de per­odo anterior para M510 para este cdigo

	For nContDev := 1 to Len(aAjustMX10)

		cVlAjuste := 0
		//Se for o mesmo cdigo de cr©dito
		If AllTrim(aAjustMX10[nContDev][4]) == aRegM500[nX][2]

			If aAjustMX10[nContDev][3] <= aRegM500[nx][12]
				cVlAjuste	:=	aAjustMX10[nContDev][3]
				aAjustMX10[nContDev][3]	:=	0

			ElseIF aRegM500[nx][12] > 0
				If aAjustMX10[nContDev][3] > aRegM500[nx][12]
					aAjustMX10[nContDev][3]	-=	aRegM500[nx][12]
					cVlAjuste := aRegM500[nx][12]
				Else
					cVlAjuste := aRegM500[nx][8]
				EndIf
			EndIF

			//Somente ira adicionar M510 se houver valor de reducao.
			If cVlAjuste > 0
				aAdd(aRegM510, {})
				nPos := Len(aRegM510)
				//Registro M510
				aAdd (aRegM510[nPos], nX)	   					//01 - REG DO PAI
				aAdd (aRegM510[nPos], "M510")					//02 - REG
				aAdd (aRegM510[nPos], "0")						//03 - IND_AJ
				aAdd (aRegM510[nPos], cVlAjuste)				//04 - VL_AJ
				aAdd (aRegM510[nPos], "06")		   				//05 - COD_AJ
				aAdd (aRegM510[nPos], "")	//06 - NUM_DOC
				IF aAjustMX10[nContDev][6] == "A"
					aAdd (aRegM510[nPos], "Estorno referente a ajuste de reduo de cr©dito do per­odo: " + SubStr(Dtos(aAjustMX10[nContDev][1]),7,2)+SubStr(Dtos(aAjustMX10[nContDev][1]),5,2)+SubStr(Dtos(aAjustMX10[nContDev][1]),1,4))	//07 - DESCR_AJ
				Else
					aAdd (aRegM510[nPos], "Estorno referente a devoluo, documento fiscal: " + aAjustMX10[nContDev][5])	//07 - DESCR_AJ
				EndIF
				aAdd (aRegM510[nPos], aAjustMX10[nContDev][1])	//08 - DT_REF
				aRegM500[nx][10]  +=  cVlAjuste
				aRegM500[nx][12] := aRegM500[nx][8] + aRegM500[nx][9] - aRegM500[nx][10] - aRegM500[nx][11]
			EndIF
		EndIF
	Next nContDev
	If  Len(aAjustMX10) > 0
		//Ir¡ atualizar os valores dos cr©ditos
		If aRegM500[nx][12] <= nContrAPag
			aRegM500[nx][13] 	:= "0"
			aRegM500[nx][14] 	:= aRegM500[nx][12]
			nContrAPag := nContrAPag - aRegM500[nx][12]
		Else
			aRegM500[nx][13] 	:= "1"
			aRegM500[nx][14] 	:= nContrAPag
			nContrAPag := 0
		EndIf

		aRegM500[nx][15]	:= aRegM500[nx][12] - aRegM500[nx][14]
	EndIF

	//Verifico se o registro M500 possui credito a ser transportado para o periodo seguinte
	If aRegM500[nX][15] > 0
		CredFutCOF(cPer,aRegM500[nX][2], Round(aRegM500[nX][12],2), Round(aRegM500[nX][14],2),aRegM500[nX][15],0,cPer)
	EndIf

Next(nX)
IF lCf5
	CF5->(dbClosearea())
EndIF

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} RegM515
Processamento do registro M515

@param  aRegM515  - Array com informaµes do registro M515
	    aRegM510  - Array com informaµes do registro M510
	    aCFA      - Array com informaµes para preenchimento dos campos
no obrigatrios

@author Simone dos Santos de Oliveira
/*/
//-------------------------------------------------------------------
Static Function RegM515(aRegM515,aRegM510,aCF5)

Local nPos 		:= 0
Local nX  		:= 0
Local nPosCf5	:= 0
Local cNumDoc   := ""

Default aCF5 := {}

For nX:= 1 to Len(aRegM510)

	cNumDoc := aRegM510[nX][6]

	aAdd(aRegM515, {})
	nPos := Len(aRegM515)
	//Registro M515
	aAdd (aRegM515[nPos], nX)	   					//01 - REG DO PAI
	aAdd (aRegM515[nPos], "M515")					//02 - REG
	aAdd (aRegM515[nPos], aRegM510[nX][4])			//03 - DET_VALOR_AJ
	aAdd (aRegM515[nPos], "")	   					//04 - CST_PIS
	aAdd (aRegM515[nPos], "")		   				//05 - DET_BC_CRED
	aAdd (aRegM515[nPos], "")						//06 - DET_ALIQ
	aAdd (aRegM515[nPos], aRegM510[nX][8])			//07 - DT_OPER_AJ
	aAdd (aRegM515[nPos], aRegM510[nX][7])			//08 - DESC_AJ
	aAdd (aRegM515[nPos], "")						//09 - COD_CTA
	aAdd (aRegM515[nPos], "")						//10 - INFO_COMPL

	If !Empty(cNumDoc) .And. len(aCF5) > 0
		nPosCf5:= aScan(aCF5,{|x| x[1]==cNumDoc})
		If nPosaCf5 > 0
			aRegM515[nPos][4] := aCF5[nPosCf5][2]	//04 - CST_PIS
			aRegM515[nPos][5] := aCF5[nPosCf5][3]	//05 - DET_BC_CRED
			aRegM515[nPos][6] := aCF5[nPosCf5][4]	//06 - DET_ALIQ
			aRegM515[nPos][9] := aCF5[nPosCf5][5]	//09 - COD_CTA
			aRegM515[nPos][10]:= aCF5[nPosCf5][6]	//10 - INFO_COMPL
		EndIf
	EndIf

Next(nX)
Return

/*‘‹‘‹‘»±±
±±ºPrograma  RegF120   ºAutor  Erick G. Dias       º Data   14/11/11   º±±
±±ºDesc.      Processamento do F120/base na depreciao, gerado a        º±±
±±º           partir da funo DEPRECATIUVO, do ATFXFUN.                 º±±
±±Parametros aRegF120   -> Array com valores para gravao do registro  ±±
±±           				F120.                                         ±±
±±           cAliasF120 -> Alias da query com valores de depreciao    ±±
±±           				do per­odo.                                   ±±
±±           aReg0500 -> Array com valores para gerao do registro 0500±±
±±           				Plano de contas.                              ±±
±±           aReg0600 -> Array com valores para gerao do registro 0600±±
±±           			   centro de custo.                               ±±
±±           aRegM105 -> Array com valores de cr©ditos de PIS que sero ±±
±±           			   gerados no registro M105.                      ±±
±±           aRegM505 -> Array com valores de cr©ditos de Cofins        ±±
±±           			   que sero gerados no registro M505.            ±±
±±           cRegime -> Indica qual o regime do contribuinte            ±±
±±           			  Cumulativo, no cumulativo ou ambos.            ±±
±±           cIndApro -> Indica o m©todo de apropriao, se © rateio    ±±
±±           				proporcional ou apropriao direta.           ±±
±±           aReg0111 -> Array com valores das receitas brutas do       ±±
±±           				per­ido.                                      ±±*/
Static Function RegF120(aRegF120,cAliasF120,aReg0500,aReg0600,aRegM105,aRegM505,cRegime,cIndApro,aReg0111,aRegF129,aReg1010,aReg1020)
Local nPos 		:= 0
Local cCSTCRED	:= "50/51/52/53/54/55/56/60/61/62/63/64/65/66"  //CSTs que do direito a cr©dito, e que so considerados para M100 e M500.
Local lReferen	:= (cAliasF120)->(FieldPos("INDPRO"))>0 .And. (cAliasF120)->(FieldPos("NUMPRO"))>0
Local lVlrBcExc	:= (cAliasF120)->(FieldPos("VLRBCEXC"))>0
Local lAchouCCF	:= .F.
Local lCpoMajAli:= aFieldPos[15] .And. aFieldPos[16]
Local nAliqCof	:= 0
Local nValcof	:= 0
Local nAliqPis  := 0
Local nValPis   := 0

Default aRegF129	:= {}

SN1->(dbSetOrder(1))
SD1->(dbSetOrder(1))

DbSelectArea(cAliasF120)
(cAliasF120)->(DbGoTop())
Do While !(cAliasF120)->(Eof ())

	If cvaltochar((cAliasF120)->CSTPIS) $ cCSTCRED .Or. cvaltochar((cAliasF120)->CSTCOFINS) $ cCSTCRED

		aAdd(aRegF120, {})
		nPos	:=	Len (aRegF120)
		aAdd (aRegF120[nPos], "F120") 												//01-REG
		aAdd (aRegF120[nPos], (cAliasF120)->NATBCCRED) 							//02-NAT_BC_CRED
		aAdd (aRegF120[nPos], (cAliasF120)->INDBEMIMOB) 							//03-IDENT_BEM_IMOB
		aAdd (aRegF120[nPos], (cAliasF120)->INDORIGCRD) 							//04-IND_ORIG_CRED
		aAdd (aRegF120[nPos], (cAliasF120)->INDUTILBEM) 							//05-IND_UTIL_BEM_IMOB
		aAdd (aRegF120[nPos], (cAliasF120)->VRET) 									//06-VL_OPER_DEP
		aAdd (aRegF120[nPos],  Iif(lVlrBcExc,(cAliasF120)->VLRBCEXC,0)) 		 	//07-PARC_OPER_NAO_BC_CRED
		aAdd (aRegF120[nPos], (cAliasF120)->CSTPIS) 								//08-CST_PIS

		nAliqCof  	:= 	(cAliasF120)->ALIQCOFINS
		nValCof		:=	(cAliasF120)->VLRCOFINS
		nAliqPis    :=	(cAliasF120)->ALIQPIS
		nValPis     :=	(cAliasF120)->VLRPIS
		If SN1->(dbSeek(xFilial('SN1')+(cAliasF120)->BEM+(cAliasF120)->ITEM)) .And. (aFieldPos[85] .And. (Empty(SN1->N1_CBCPIS) .Or. SN1->N1_CBCPIS == "1"))
       		If SD1->(dbSeek(xFilial('SD1')+(cAliasF120)->NOTAFISCAL+(cAliasF120)->SERIE+(cAliasF120)->FORNECEDOR+(cAliasF120)->LOJA+SN1->N1_PRODUTO+SN1->N1_NFITEM))
   		  		If (SubStr (AllTrim (SD1->D1_CF), 1, 1)=="3")
		     		MajAliqVal(@nAliqCof,@nValCof,'SD1',lCpoMajAli,.T.)
		     		MajAliqPIS(@nAliqPis,@nValPis,'SD1',.T.)
		  		Endif
	   		Endif
  		Endif
		aAdd (aRegF120[nPos], (cAliasF120)->VLRBCPIS) 								//09-VL_BC_PIS
		aAdd (aRegF120[nPos], nAliqPis)				 								//10-ALIQ_PIS
		aAdd (aRegF120[nPos], nValPis)				 								//11-VL_PIS
		aAdd (aRegF120[nPos], (cAliasF120)->CSTCOFINS) 							//12-CST_COFINS
		aAdd (aRegF120[nPos], (cAliasF120)->VLRBCCOFIN) 							//13-VL_BC_COFINS
		aAdd (aRegF120[nPos], nAliqCof)					 							//14-ALIQ_COFINS
		aAdd (aRegF120[nPos], nValCof)					 							//15-VL_COFINS
		aAdd (aRegF120[nPos], Reg0500(aReg0500,(cAliasF120)->CODCONTA)) 			//16-COD_CTA
		aAdd (aRegF120[nPos], Reg0600(aReg0600,(cAliasF120)->CODCCUSTO)) 			//17-COD_CCUS
		aAdd (aRegF120[nPos], (cAliasF120)->DESCBEMIMO) 							//18-DESC_ BEM_IMOB

	 	//Acumula valor de cr©dito no registro M100 e filhos
		If cvaltochar((cAliasF120)->CSTPIS) $ cCSTCRED
			AcumM105(aRegM105,,cRegime,,cIndApro,aReg0111,.T., {},,cAliasF120)
		EndIF
	 	//Acumula valor de cr©dito no registro M500 e filhos
		If cvaltochar((cAliasF120)->CSTCOFINS) $ cCSTCRED
			AcumM505(aRegM505,,cRegime,,cIndApro,aReg0111,.T., {},,cAliasF120)
		EndIF
		// Verifica o tipo do registro, so' grava se for: 1 - Justica Federal / 3 - Secretaria Federal ou 9 - Outros
		If lReferen .And. !Empty((cAliasF120)->NUMPRO) .And. !Empty((cAliasF120)->INDPRO) .And. !(Alltrim((cAliasF120)->INDPRO)$"0|2")

			aAdd(aRegF129, {})
			nPos	:=	Len (aRegF129)
			aAdd (aRegF129[nPos], Len(aRegF120)) 										//Relao com F120
			aAdd (aRegF129[nPos], "F129") 												//01-REG
			aAdd (aRegF129[nPos], (cAliasF120)->NUMPRO) 			   					//02-NUM_PROC
			aAdd (aRegF129[nPos], (cAliasF120)->INDPRO) 			   					//03-IND_PROC

	        lAchouCCF	:=	CCF->(MsSeek (xFilial ("CCF")+(cAliasF120)->NUMPRO+(cAliasF120)->INDPRO ))

			If	lAchouCCF
				If CCF->CCF_TPCOMP == "1" //Complemento do processo referenciado - Judicial
					Reg1010(aReg1010)
				ElseIf CCF->CCF_TPCOMP == "2" //Complemento do processo referenciado - Administrativo
					Reg1020(aReg1020)
				EndIf
			Endif
		EndIf
	Endif
	(cAliasF120)->(DbSkip ())
EndDo

Return

/*‘‹‘‹‘»±±
±±ºPrograma  GravaNFEnt   ºAutor  Caio Oliveira       º Data   04/01/12 º±±
±±ºDesc.       Processamento para verificar se existe algum item com     º±±
±±ºDesc.       Cr©dito de PIS e Cofins.                                  º±±*/
Static Function GravaNFEnt(cAliasSFT, lTop)

Local lGravaNFE	:=	.F.
Local cChaveSFT		:=	(cAliasSFT)->FT_FILIAL+(cAliasSFT)->FT_TIPOMOV+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA
Local cAliasEnt		:=	"SFT"

If lTop

	DbSelectArea (cAliasEnt)
	(cAliasEnt)->(DbSetOrder (1))


    cAliasEnt	:=	GetNextAlias()

   	BeginSql Alias cAliasEnt

		SELECT
			COUNT(SFT.FT_NFISCAL) FT_COUNT
		FROM
			%Table:SFT% SFT
			LEFT JOIN %Table:SD1% SD1 ON(SD1.D1_FILIAL=%xFilial:SD1%  AND SD1.D1_DOC=SFT.FT_NFISCAL AND SD1.D1_SERIE=SFT.FT_SERIE AND SD1.D1_FORNECE=SFT.FT_CLIEFOR AND SD1.D1_LOJA=SFT.FT_LOJA AND SD1.D1_COD=SFT.FT_PRODUTO AND SD1.D1_ITEM=SFT.FT_ITEM AND SD1.%NotDel%)
			LEFT JOIN %Table:SF4% SF4 ON(SF4.F4_FILIAL=%xFilial:SF4%  AND SF4.F4_CODIGO=SD1.D1_TES  AND SF4.%NotDel%)
		WHERE
			SFT.FT_FILIAL	= %Exp:(cAliasSFT)->FT_FILIAL% AND
			SFT.FT_TIPOMOV  = %Exp:(cAliasSFT)->FT_TIPOMOV% AND
			SFT.FT_SERIE    = %Exp:(cAliasSFT)->FT_SERIE% AND
			SFT.FT_NFISCAL  = %Exp:(cAliasSFT)->FT_NFISCAL% AND
			SFT.FT_CLIEFOR  = %Exp:(cAliasSFT)->FT_CLIEFOR% AND
			SFT.FT_LOJA     = %Exp:(cAliasSFT)->FT_LOJA% AND
			SF4.F4_PISCOF <>'4' AND
			SFT.%NotDel%
	EndSql

	DbSelectArea (cAliasEnt)
	(cAliasEnt)->(DbGoTop ())

	If (cAliasEnt)->FT_COUNT > 0
		lGravaNFE := .T.
	EndIf

	(cAliasEnt)->( DbCloseArea() )

Else
	DbSelectArea ("SFT")
	dbSetOrder(1)
	If SFT->(msSeek(cChaveSFT))

		Do While !SFT->(Eof ()) .And.	cChaveSFT==SFT->FT_FILIAL+SFT->FT_TIPOMOV+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA

			If SD1->(MsSeek (xFilial("SD1")+SFT->FT_NFISCAL+SFT->FT_SERIE+SFT->FT_CLIEFOR+SFT->FT_LOJA+SFT->FT_PRODUTO+SFT->FT_ITEM))

	         	If SF4->(MsSeek (xFilial("SF4")+SD1->D1_TES))
					If SF4->F4_PISCOF !="4"
						lGravaNFE := .T.
						Exit
	                EndIf
			    EndIf

			EndIf
			SFT->(dbSkip())
		EndDo

	EndIF

EndIf

Return lGravaNFE

/*‘‹‘‹‘»±±
±±ºPrograma  Reg1101   ºAutor  Vitor Felipe        º Data   02/01/2012 º±±
±±ºDesc.     Processamento dos registro 1101 e 1102.                     º±±
±±º„„„„„„„„„„…„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„º±±
±±ºParametros aReg1100->Array com valores para gravao do registro 1100.º±±
±±º			  aReg1101->Array com valores para gravao do registro 1101.  º±±
±±º			  aReg1102->Array com valores para gravao do registro 1102.  º±±
±±º			  nTotContrb->Total de Contribuicao.						        º±±
±±º			  cPer-> Periodo de Apuracao.								        º±±
±±º			  lMesAtual -> Logico de processamento Mes Atual.			    º±±*/
static Function Reg1101(aReg1100,aReg1101,aReg1102,nTotContrb,cPer,lMesAtual,cAlias,aReg0140Ex)

Local cAliasCF6 := "CF6"
Local nPos		:= 0
Local nPos02	:= 0
Local dPriDia	:= firstday(sTod(cPer))-1
Local cPerAnt 	:= cvaltochar(strzero(month(dPriDia),2)) + cvaltochar(year(dPriDia ))
Local cPerAtu 	:= cvaltochar(strzero(month(sTod(cPer) ) ,2)) + cvaltochar(year(sTod(cPer) ))
Local cCnpj 	:= ""
Local cFilCF	:=	""
Local nCredUti	:= 0  //Credito Utilizado
Local cChavePa	:= ""
Local cCodCred	:= ""
Local nPosExt	:= 0
Local nPosFil	:=	0
Local cCusto	:= ""
Local cConta	:= ""
Local cCNPJExt	:=	""
Local aParFil	:=	{}
Local lAchouCF6	:=	.F.
Local cFil0150  := ""

aAdd(aParFil,DTOS(dDataDe))
aAdd(aParFil,DTOS(dDataAte))

If (lAchouCF6	:=	SPEDFFiltro(1,"CF6",@cAliasCF6,aParFil))

	Do While !(cAliasCF6)->(Eof ())
		If (cAliasCF6)->CF6_VALPIS > 0

			IF aFieldPos[71]
				If (nPosFil := aScan(aReg0140Ex,{|x| x[4] == (cAliasCF6)->CF6_CNPJ})) > 0
					cFilCF		:=	aReg0140Ex[nPosFil][2]
					cFil0150  :=  aReg0140Ex[nPosFil][1]
					cCNPJExt	:=	(cAliasCF6)->CF6_CNPJ
				Elseif Len(aReg0140Ex) > 0
					cFilCF		:=	aReg0140Ex[1][2]
					cFil0150  := aReg0140Ex[1][1]
					cCNPJExt	:=	aReg0140Ex[1][4]
				Else
					cFilCF		:=	Alltrim(SM0->M0_CODFIL)
					cCNPJExt	:=	SM0->M0_CGC
				Endif
			Else
				If Len(aReg0140Ex) > 0
					cFilCF		:=	aReg0140Ex[1][2]
					cFil0150  :=  aReg0140Ex[1][1]
					cCNPJExt	:=	aReg0140Ex[1][4]
				Else
					cFilCF		:=	Alltrim(SM0->M0_CODFIL)
					cCNPJExt	:=	SM0->M0_CGC
				Endif
			Endif
			cChavePa	:= ""
			cCusto 		:= ""
			cConta		:= ""
			If !Empty((cAliasCF6)->CF6_TIPONF) .AND. !Empty((cAliasCF6)->CF6_CLIFOR) .AND. !Empty((cAliasCF6)->CF6_LOJA)
				cChavePa := Iif(Alltrim((cAliasCF6)->CF6_TIPONF) == "0","SA2","SA1")+cFil0150+(cAliasCF6)->CF6_CLIFOR+(cAliasCF6)->CF6_LOJA
			EndIf
			cCodCred := (cAliasCF6)->CF6_CODCRE
			IF !Empty((cAliasCF6)->CF6_CODCCS)
				cCusto	 := (cAliasCF6)->CF6_CODCCS + xFilial("CTT")
			EndIF
			IF !Empty((cAliasCF6)->CF6_CODCTA)
				cConta	 := (cAliasCF6)->CF6_CODCTA + xFilial("CT1")
			EndIF

			Reg1100(@aReg1100,cPerAnt,cCnpj,(cAliasCF6)->CF6_CODCRE,0,0,@nTotContrb,@nCredUti,cPerAtu,lMesAtual,(cAliasCF6)->CF6_VALPIS,@nPosExt,cPerAnt)

			aAdd(aReg1101, {})
			nPos := Len(aReg1101)
			aAdd(aReg1101[nPos], nPosExt)							//00 - Relacionamento com o Pai.
			aAdd(aReg1101[nPos], "1101")							//01 - REG
			aAdd(aReg1101[nPos], cChavePa)							//02 - COD_PART
			aAdd(aReg1101[nPos],(cAliasCF6)->CF6_ITEM+cFilCF)//03 - COD_ITEM
			aAdd(aReg1101[nPos], AModNot((cAliasCF6)->CF6_CODMOD)) //04 - COD_MOD
			aAdd(aReg1101[nPos],(cAliasCF6)->CF6_SERIE)   			//05 - SERIE
			aAdd(aReg1101[nPos], "")					  			//06 - SUB_SER
			aAdd(aReg1101[nPos],(cAliasCF6)->CF6_NUMDOC)  			//07 - NUM_DOC
			aAdd(aReg1101[nPos],(cAliasCF6)->CF6_DTOPER)  			//08 - DT_OPER
			aAdd(aReg1101[nPos], AllTrim((cAliasCF6)->CF6_CHVNFE)) //09 - CHV_NFE
			aAdd(aReg1101[nPos],(cAliasCF6)->CF6_VLOPER)			//10 - VL_OPER
			aAdd(aReg1101[nPos],(cAliasCF6)->CF6_CFOP)	   			//11 - CFOP
			aAdd(aReg1101[nPos],(cAliasCF6)->CF6_NATBCC)  			//12 - NAT_BC_CRED
			aAdd(aReg1101[nPos],(cAliasCF6)->CF6_ORICRE)  			//13 - IND_ORIG_CRED
			aAdd(aReg1101[nPos],(cAliasCF6)->CF6_CSTPIS)  			//14 - CST_PIS
			aAdd(aReg1101[nPos],(cAliasCF6)->CF6_BASPIS)  			//15 - VL_BC_PIS
			aAdd(aReg1101[nPos],(cAliasCF6)->CF6_ALQPIS)  			//16 - ALIQ_PIS
			aAdd(aReg1101[nPos],(cAliasCF6)->CF6_VALPIS)  			//17 - VL_PIS
			aAdd(aReg1101[nPos], cConta)							//18 - COD_CTA
			aAdd(aReg1101[nPos], cCusto)				  			//19 - COD_CCUS
			aAdd(aReg1101[nPos], AllTrim((cAliasCF6)->CF6_DESCCO))	//20 - DESC_COMPL
			aAdd(aReg1101[nPos],(cAliasCF6)->CF6_PERESC)  			//21 - PER_ESCRIT
			aAdd(aReg1101[nPos], cCNPJExt)  							//22 - CNPJ
			//Grava detalhamento do Registro 1102 apenas para os CST's 53, 54, 55, 56, 63, 64, 65 ou 66 (Mais de uma receita).  
			If (cAliasCF6)->CF6_CSTPIS $ "53|54|55|56|63|64|65|66"
				aAdd(aReg1102,{nPos,"1102","","",""})					   		//01 - REG
			    nPos02 := Len(aReg1102)
			    Do Case
					Case SubStr(cCodCred,1,1) = "1" //Receita Tributada no Mercado Interno.
						If ValType(aReg1102[nPos02][3])=="C"
					   		aReg1102[nPos02][3] := (cAliasCF6)->CF6_VALPIS		//02 - VL_CRED_PIS_TRIB_MI
					 	ElseIF ValType(aReg1502[nPos02][3])=="N"
                        	aReg1102[nPos02][3] += (cAliasCF6)->CF6_VALPIS		//02 - VL_CRED_PIS_TRIB_MI
					 	EndIf
					Case SubStr(cCodCred,1,1) = "2" //Receita Nao Tributada no Mercado Interno.
						If ValType(aReg1102[nPos02][4])=="C"
					   		aReg1102[nPos02][4] := (cAliasCF6)->CF6_VALPIS		//03 - VL_CRED_PIS_NT_MI
					 	ElseIF ValType(aReg1502[nPos02][3])=="N"
                        	aReg1102[nPos02][4] += (cAliasCF6)->CF6_VALPIS		//03 - VL_CRED_PIS_NT_MI
					 	EndIf
					Case SubStr(cCodCred,1,1) = "3" //Receita de Exportao.
						If ValType(aReg1102[nPos02][5])=="C"
					   		aReg1102[nPos02][5] := 	(cAliasCF6)->CF6_VALPIS		//04 - VL_CRED_PIS_EXP
					 	ElseIF ValType(aReg1502[nPos02][3])=="N"
                        	aReg1102[nPos02][5] += 	(cAliasCF6)->CF6_VALPIS		//04 - VL_CRED_PIS_EXP
					 	EndIf
				EndCase
			EndIf
	    EndIf
		(cAliasCF6)->(dbSkip())
	EndDo
Endif

If lAchouCF6
	SPEDFFiltro(2,,cAliasCF6)
EndIf

Return

/*‘‹‘‹‘»±±
±±ºPrograma  Reg1501   ºAutor  Vitor Felipe        º Data   02/01/2012 º±±
±±ºDesc.     Processamento dos registro 1501 e 1502.                     º±±
±±ºParametros aReg1500->Array com valores para gravao do registro 1500.º±±
±±º			  aReg1501->Array com valores para gravao do registro 1501. º±±
±±º			  aReg1502->Array com valores para gravao do registro 1502. º±±
±±º			  nTotContrb->Total de Contribuicao.						       º±±
±±º			  cPer-> Periodo de Apuracao.								       º±±
±±º			  lMesAtual -> Logico de processamento Mes Atual.			   º±±*/
static Function Reg1501(aReg1500,aReg1501,aReg1502,nTotContrb,cPer,lMesAtual,cAlias,aReg0140Ex)

Local cAliasCF6 := "CF6"
Local nPos		:= 0
Local nPos02	:= 0
Local dPriDia	:= firstday(sTod(cPer))-1
Local cPerAnt 	:= cvaltochar(strzero(month(dPriDia),2)) + cvaltochar(year(dPriDia ))
Local cPerAtu 	:= cvaltochar(strzero(month(sTod(cPer) ) ,2)) + cvaltochar(year(sTod(cPer) ))
Local cCnpj 	:= ""
Local cFilCF	:=	""
Local nCredUti	:= 0  //Credito Utilizado
Local cChavePa	:= ""
Local cCodCred	:= ""
Local nPosExt	:= 0
Local nPosFil	:=	0
Local cCusto	:= ""
Local cConta	:= ""
Local cCNPJExt	:=	""
Local aParFil	:=	{}
Local lAchouCF6	:=	.F.
Local cFil0150  := ""

aAdd(aParFil,DTOS(dDataDe))
aAdd(aParFil,DTOS(dDataAte))

If (lAchouCF6	:=	SPEDFFiltro(1,"CF6",@cAliasCF6,aParFil))

	Do While !(cAliasCF6)->(Eof ())
		If (cAliasCF6)->CF6_VALCOF > 0

			IF aFieldPos[71]
				If (nPosFil := aScan(aReg0140Ex,{|x| x[4] == (cAliasCF6)->CF6_CNPJ})) > 0
					cFilCF		:=	aReg0140Ex[nPosFil][2]
					cFil0150  :=  aReg0140Ex[nPosFil][1]
					cCNPJExt	:=	(cAliasCF6)->CF6_CNPJ
				Elseif Len(aReg0140Ex) > 0
					cFilCF		:=	aReg0140Ex[1][2]
					cFil0150  :=  aReg0140Ex[1][1]
					cCNPJExt	:=	aReg0140Ex[1][4]
				Else
					cFilCF		:=	SM0->M0_CODFIL
					cCNPJExt	:=	SM0->M0_CGC
				Endif
			Else
				If Len(aReg0140Ex) > 0
					cFilCF		:=	aReg0140Ex[1][2]
					cFil0150  :=  aReg0140Ex[1][1]
					cCNPJExt	:=	aReg0140Ex[1][4]
				Else
					cFilCF		:=	SM0->M0_CODFIL
					cCNPJExt	:=	SM0->M0_CGC
				Endif
			Endif

			cChavePa	:= ""
			cCusto 		:= ""
			cConta		:= ""

			If !Empty((cAliasCF6)->CF6_TIPONF) .AND. !Empty((cAliasCF6)->CF6_CLIFOR) .AND. !Empty((cAliasCF6)->CF6_LOJA)
				cChavePa := Iif(Alltrim((cAliasCF6)->CF6_TIPONF) == "0","SA2","SA1")+cFil0150+(cAliasCF6)->CF6_CLIFOR+(cAliasCF6)->CF6_LOJA
			EndIf
			cCodCred := (cAliasCF6)->CF6_CODCRE
			If !Empty((cAliasCF6)->CF6_CODCCS)
				cCusto	 := (cAliasCF6)->CF6_CODCCS + xFilial("CTT")
			EndIF
			IF !Empty((cAliasCF6)->CF6_CODCTA)
				cConta	 := (cAliasCF6)->CF6_CODCTA + xFilial("CT1")
			EndIF

			Reg1500(@aReg1500,cPerAnt,cCnpj,(cAliasCF6)->CF6_CODCRE,0,0,@nTotContrb,@nCredUti,cPerAtu,lMesAtual,(cAliasCF6)->CF6_VALCOF,@nPosExt,cPerAnt)

			aAdd(aReg1501, {})
			nPos := Len(aReg1501)
			aAdd(aReg1501[nPos], nPosExt)							//00 - Relacionamento com o Pai.
			aAdd(aReg1501[nPos], "1501")							//01 - REG
			aAdd(aReg1501[nPos], cChavePa)							//02 - COD_PART
			aAdd(aReg1501[nPos],(cAliasCF6)->CF6_ITEM+cFilCF)//03 - COD_ITEM
			aAdd(aReg1501[nPos], AModNot((cAliasCF6)->CF6_CODMOD))	//04 - COD_MOD
			aAdd(aReg1501[nPos],(cAliasCF6)->CF6_SERIE)   			//05 - SERIE
			aAdd(aReg1501[nPos], "")					  			//06 - SUB_SER
			aAdd(aReg1501[nPos],(cAliasCF6)->CF6_NUMDOC)  			//07 - NUM_DOC
			aAdd(aReg1501[nPos],(cAliasCF6)->CF6_DTOPER)  			//08 - DT_OPER
			aAdd(aReg1501[nPos], AllTrim((cAliasCF6)->CF6_CHVNFE))	//09 - CHV_NFE
			aAdd(aReg1501[nPos],(cAliasCF6)->CF6_VLOPER)			//10 - VL_OPER
			aAdd(aReg1501[nPos],(cAliasCF6)->CF6_CFOP)	   			//11 - CFOP
			aAdd(aReg1501[nPos],(cAliasCF6)->CF6_NATBCC)  			//12 - NAT_BC_CRED
			aAdd(aReg1501[nPos],(cAliasCF6)->CF6_ORICRE)  			//13 - IND_ORIG_CRED
			aAdd(aReg1501[nPos],(cAliasCF6)->CF6_CSTCOF)  			//14 - CST_COF
			aAdd(aReg1501[nPos],(cAliasCF6)->CF6_BASCOF)  			//15 - VL_BC_COF
			aAdd(aReg1501[nPos],(cAliasCF6)->CF6_ALQCOF)  			//16 - ALIQ_COF
			aAdd(aReg1501[nPos],(cAliasCF6)->CF6_VALCOF)  			//17 - VL_COF
			aAdd(aReg1501[nPos], cConta)				  			//18 - COD_CTA
			aAdd(aReg1501[nPos], cCusto)  							//19 - COD_CCUS
			aAdd(aReg1501[nPos], AllTrim((cAliasCF6)->CF6_DESCCO))	//20 - DESC_COMPL
			aAdd(aReg1501[nPos],(cAliasCF6)->CF6_PERESC)  			//21 - PER_ESCRIT
			aAdd(aReg1501[nPos], cCNPJExt)			  					//22 - CNPJ
			//Grava detalhamento do Registro 1502 apenas para os CST's 53, 54, 55, 56, 63, 64, 65 ou 66 (Mais de uma receita).  
			If (cAliasCF6)->CF6_CSTCOF $ "53|54|55|56|63|64|65|66"
				aAdd(aReg1502,{nPos,"1502","","",""})							//01 - REG
			    nPos02 := Len(aReg1502)
			    Do Case
					Case SubStr(cCodCred,1,1) = "1" //Receita Tributada no Mercado Interno.
						If ValType(aReg1502[nPos02][3])=="C"
					   		aReg1502[nPos02][3] := (cAliasCF6)->CF6_VALCOF		//02 - VL_CRED_PIS_TRIB_MI
					 	ElseIF ValType(aReg1502[nPos02][3])=="N"
                        	aReg1502[nPos02][3] += (cAliasCF6)->CF6_VALCOF		//02 - VL_CRED_PIS_TRIB_MI
					 	EndIf
					Case SubStr(cCodCred,1,1) = "2" //Receita Nao Tributada no Mercado Interno.
						If ValType(aReg1502[nPos02][4])=="C"
					   		aReg1502[nPos02][4] := (cAliasCF6)->CF6_VALCOF		//03 - VL_CRED_PIS_NT_MI
					 	ElseIF ValType(aReg1502[nPos02][4])=="N"
                        	aReg1502[nPos02][4] += (cAliasCF6)->CF6_VALCOF		//03 - VL_CRED_PIS_NT_MI
					 	EndIf
					Case SubStr(cCodCred,1,1) = "3" //Receita de Exportao.
						If ValType(aReg1502[nPos02][5])=="C"
					   		aReg1502[nPos02][5] := 	(cAliasCF6)->CF6_VALCOF		//04 - VL_CRED_PIS_EXP
					 	ElseIF ValType(aReg1502[nPos02][4])=="N"
                        	aReg1502[nPos02][5] += 	(cAliasCF6)->CF6_VALCOF		//04 - VL_CRED_PIS_EXP
					 	EndIf
				EndCase
			EndIf
	    EndIf
	    (cAliasCF6)->(dbSkip())
	EndDo
Endif

If lAchouCF6
	SPEDFFiltro(2,,cAliasCF6)
EndIf

Return

/*‰‘‹‘‹‘»±±
±±ºPrograma  |RegExtR   ºAutor  Vitor Felipe        º Data   02/01/2012 º±±
±±ºDesc.     Processamento da Tabela CF6 - Creditos Extemporaneos.       º±±
±±ºParametros aReg0150 -> Array com o Registro 0150.					    º±±
±±º			  aReg0200 -> Array com o Registro 0200.					       º±±
±±º			  aReg0500 -> Array com o Registro 0500.					       º±±
±±º			  aReg0600 -> Array com o Registro 0600.					       º±±
±±º			  aReg0190 -> Array com o Registro 0190.					       º±±
±±º			  aReg0205 -> Array com o Registro 0205.					       º±±
±±º			  aReg0140 -> Array com o Registro 0140.					       º±±*/
static Function RegExtR(aReg0150,aReg0200,aReg0500,aReg0600,aReg0190,aReg0205,aReg0140)

Local cAliasCF6 := "CF6"
Local cChavePa	:= ""
Local cProd		:= ""
Local cAliasSB1	:= "SB1"
Local aPar		:= {}
Local aParFil	:= {}
Local aAliasPa	:= {}
Local aAliasB1  := {}
Local lAchouCF6	:=	.F.
Local cFilCF	:= ""
Local cCNPJExt	:= ""
Local lCF6CNPJ  := aFieldPos[71]

aAdd(aParFil,DTOS(dDataDe))
aAdd(aParFil,DTOS(dDataAte))

If (lAchouCF6	:=	SPEDFFiltro(1,"CF6",@cAliasCF6,aParFil))

	Do While !(cAliasCF6)->(Eof ())
		If (cAliasCF6)->CF6_VALPIS > 0 .Or. (cAliasCF6)->CF6_VALCOF > 0
			IF lCF6CNPJ
				If (nPosFil := aScan(aReg0140,{|x| x[4] == (cAliasCF6)->CF6_CNPJ})) > 0
					cFilCF		:=	aReg0140[nPosFil][2]
				Elseif Len(aReg0140) > 0
					cFilCF		:=	aReg0140[1][2]
				Else
					cFilCF		:=	SM0->M0_CODFIL
				Endif
			Else
				If Len(aReg0140) > 0
					cFilCF		:=	aReg0140[1][2]
				Else
					cFilCF		:=	SM0->M0_CODFIL
				Endif
			Endif
			If !Empty((cAliasCF6)->CF6_TIPONF) .AND. !Empty((cAliasCF6)->CF6_CLIFOR) .AND. !Empty((cAliasCF6)->CF6_LOJA)
				cChavePa := Iif(Alltrim((cAliasCF6)->CF6_TIPONF) == "0","SA2","SA1")+Iif(lConcFil,cFilCF,"")+(cAliasCF6)->CF6_CLIFOR+(cAliasCF6)->CF6_LOJA
			EndIf

			cProd	 := (cAliasCF6)->CF6_ITEM+xFilial("SB1")
			//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
			//Grava Registros complementares:		
			//	0150 - Cliente ou Fornecedor		
			//	0200 - Produto						
			//	0500 - Conta Contabil				
			//	0600 - Centros de Custo				
			//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
			If !Empty(cChavePa)
				cAlias := Iif(Alltrim((cAliasCF6)->CF6_TIPONF) == "0","SA2","SA1")
				aAliasPa := (cAlias)->(GetArea())
				If (cAlias)->(MsSeek(xFilial(cAlias)+(cAliasCF6)->CF6_CLIFOR+(cAliasCF6)->CF6_LOJA))
					If aScan(aReg0150,{|aX| aX[3]==cChavePa}) == 0
						aPar :=	InfPartDoc(cAlias,@aReg0150,.T.,dDataDe,dDataAte)
					EndIf
				EndIf
				RestArea(aAliasPa)
			EndIf
			If !Empty(cProd)
				aAliasB1 := SB1->(GetArea())
				If (cAliasSB1)->(MsSeek (xFilial ("SB1")+cProd))
					If aScan(aReg0200,{|aX| aX[3]==cProd}) == 0
				   		Reg0200("",@aReg0200,@aReg0190,dDataDe,dDataAte,,cProd,,@aReg0205,.F.,cAliasSB1)
				 	EndIf
				EndIf
				RestArea(aAliasB1)
			EndIf
			If !Empty((cAliasCF6)->CF6_CODCTA)
				Reg0500(@aReg0500,(cAliasCF6)->CF6_CODCTA)
			EndIf
			If !Empty((cAliasCF6)->CF6_CODCCS)
				Reg0600(@aReg0600,(cAliasCF6)->CF6_CODCCS)
			EndIf
	    EndIf
	    (cAliasCF6)->(dbSkip())
	EndDo
Endif

If lAchouCF6
	SPEDFFiltro(2,,cAliasCF6)
EndIf

Return
/*‘‹‘‹‘»±±
±±ºPrograma  TotReceitaºAutor  Erick G. Dias       º Data   21/03/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDescrio  Retornar os totais da receita bruta mensal                 º±±
±±Parametros dDataDe   -> Data inicial de gerao do arquivo            ±±
±±           dDataAte  -> Data final de gerao do arquivo.             ±±
±±           cEmpAnt   -> Cdigo com empresa corrente.                  ±±
±±           cFilAte   -> Cdigo da primeira filial selecionada pelo    ±±
±±                        Usu¡rio na Wizard.                            ±±
±±           aWizard   -> Array com informaµes da Wizard.              ±±
±±           aLisFil   -> Array com filiais selecionadas pelo usu¡rio.  ±±
±±                        na wizard.                                    ±±
±±           cFilDe   -> Cdigo da ºltima filial selecionada pelo       ±±
±±                        Usu¡rio na Wizard.                            ±±
±±           aCFOPs   -> Array com CFOPs que geram receita.             ±±
±±           lTop     -> Indica se est¡ processando em TOP.             ±±
±±ˆ¼*/

Static Function TotReceita(dDataDe,dDataAte,cEmpAnt,cFilAte,aWizard,aLisFil,cFilDe,aCFOPs,lTop)

Local cAliasSFT 	:= "SFT"
Local cAliasSB1 	:= "SB1"
Local aRetorno 		:= {0,0}
Local cFiltro 		:= ""
Local cCampos 		:= ""
Local cNrLivro		:= aWizard[1][3]
Local cNcm			:= "0201/0202/02061000/020620/020621/020629/02102000/05069000/05100010/1502001"
Local cEspecie		:= ""

DbSelectArea ("SM0")
SM0->(DbGoTop ())
SM0->(MsSeek (cEmpAnt+cFilDe, .T.))	//Pego a filial mais proxima

Do While !SM0->(Eof ()) .And. ((!"1"$aWizard[1][6] .And. cEmpAnt==SM0->M0_CODIGO .And. FWGETCODFILIAL<=cFilAte) .Or. ("1"$aWizard[1][6] .And. Len(aLisFil)>0 .And. cEmpAnt==SM0->M0_CODIGO  ))

	IncProc("Processando Rececitas eportao: "+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL))
	cStatus := STR0004+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL)
	cFilAnt := FWGETCODFILIAL
	If Len(aLisFil)>0 //.And. Val(cFilAnt) <= Len(aLisFil)
        nFilial := Ascan(aLisFil,{|x|x[2]==cFilAnt})
	   If nFilial > 0
		   If !(aLisFil[  nFilial, 1 ])  //Filial no marcada, vai para proxima
				SM0->( dbSkip() )
				Loop
			EndIf
	   Else
			SM0->( dbSkip() )
			Loop
	   EndIf
	Else
		If "1"  $ aWizard[1][6] //Somente faz skip se a opo de selecionar filiais estiver como Sim.
			 SM0->( dbSkip() )
			 Loop
		EndIf
	EndIf

	//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„V¿
	//Ir¡ trazer valores de receitas para totalizar percentual de receita de exportao, para calcular cr©dito presumido.
	//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„V™
	DbSelectArea (cAliasSFT)
	(cAliasSFT)->(DbSetOrder (2))
	#IFDEF TOP
	    If (TcSrvType ()<>"AS/400")
	    	cAliasSFT	:=	GetNextAlias()

			cFiltro := "%"

			If (cNrLivro<>"*")
        		cFiltro += " SFT.FT_NRLIVRO = '" +%Exp:cNrLivro% +"' AND "
      		EndiF

			cFiltro += "%"
			cCampos := "%"

	    	BeginSql Alias cAliasSFT

				COLUMN FT_EMISSAO AS DATE
		    	COLUMN FT_ENTRADA AS DATE
		    	COLUMN FT_DTCANC AS DATE

				SELECT
					SUM(SFT.FT_VALCONT) FT_VALCONT , SFT.FT_ESPECIE, SFT.FT_CFOP , SFT.FT_PRODUTO, SB1.B1_POSIPI
					%Exp:cCampos%
				FROM
					%Table:SFT% SFT
					LEFT JOIN %Table:SB1% SB1 ON(SB1.B1_FILIAL=%xFilial:SB1%  AND SB1.B1_COD=SFT.FT_PRODUTO AND SB1.%NotDel%)
				WHERE
					SFT.FT_FILIAL=%xFilial:SFT% AND
					SFT.FT_TIPOMOV = 'S' AND
					SFT.FT_ENTRADA>=%Exp:DToS (dDataDe)% AND
					SFT.FT_ENTRADA<=%Exp:DToS (dDataAte)% AND
					(SFT.FT_DTCANC = ' ' OR SFT.FT_DTCANC > %Exp:DToS (dDataAte)% )  AND
					SFT.FT_TIPO <> 'D' AND
					%Exp:cFiltro%
					SFT.%NotDel%

				GROUP BY SFT.FT_ESPECIE, SFT.FT_CFOP, SFT.FT_PRODUTO, SB1.B1_POSIPI

				ORDER BY SFT.FT_CFOP

			EndSql
		Else
	#ENDIF
		    cIndex	:= CriaTrab(NIL,.F.)
		    cFiltro	:= 'FT_FILIAL=="'+xFilial ("SFT")+'".And.'
		    cFiltro += 'FT_TIPOMOV== "S" .And. '
		   	cFiltro += 'DToS (FT_ENTRADA)>="'+DToS (dDataDe)+'".And.DToS (FT_ENTRADA)<="'+DToS (dDataAte)+'" '
			cFiltro += ' .AND.(FT_DTCANC == " " .OR. DToS (FT_DTCANC)>"'+DToS (dDataDe)+'") .AND. FT_TIPO <> "D" '

		    If (cNrLivro<>"*")
			    cFiltro	+=	'.And.FT_NRLIVRO ="'+cNrLivro+'" '
		   	EndIf

		    IndRegua (cAliasSFT, cIndex, SFT->(IndexKey ()),, cFiltro)
		    nIndex := RetIndex(cAliasSFT)

			#IFNDEF TOP
				DbSetIndex (cIndex+OrdBagExt ())
			#ENDIF

			DbSelectArea (cAliasSFT)
		    DbSetOrder (nIndex+1)
	#IFDEF TOP
		Endif
	#ENDIF

	DbSelectArea (cAliasSFT)
	(cAliasSFT)->(DbGoTop ())
	ProcRegua ((cAliasSFT)->(RecCount ()))

	If lTop
		cAliasSB1 := cAliasSFT
	EndIF

	Do While !(cAliasSFT)->(Eof ())

		IF !lTop
			(cAliasSB1)->(msSeek(xFilial("SB1")+(cAliasSFT)->FT_PRODUTO))
		EndIF

		cEspecie	:=	AModNot ((cAliasSFT)->FT_ESPECIE)		//Modelo NF

		If cEspecie$"  " .Or. ( (AllTrim((cAliasSFT)->FT_CFOP)$aCFOPs[01])	.AND. !(AllTrim((cAliasSFT)->FT_CFOP)$aCFOPs[02]) ) // Verifica se o CFOP © gerador de receita

			If SubStr((cAliasSFT)->FT_CFOP,1,1) == "7" .AND. SPEDNcmCAg((cAliasSB1)->B1_POSIPI )
				//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
				//Acuula valor de receita exportao
				//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
				aRetorno[1] += (cAliasSFT)->FT_VALCONT
			EndIF
				//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
				//Acumula valor de receita total
				//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
			aRetorno[2] += (cAliasSFT)->FT_VALCONT
		EndIF

		(cAliasSFT)->(DbSkip ())
	EndDo

	#IFDEF TOP
		If (TcSrvType ()<>"AS/400")
			DbSelectArea (cAliasSFT)
			(cAliasSFT)->(DbCloseArea ())
		Else
	#ENDIF
			RetIndex("SFT")
			FErase(cIndex+OrdBagExt ())
	#IFDEF TOP
		EndIf
	#ENDIF

	cAliasSFT	:=	"SFT"
	SM0->(DbSkip ())
EndDo
Return (aRetorno)


/*‘‹‘‹‘»±±
±±ºPrograma  TotEntGadoºAutor  Erick G. Dias       º Data   21/03/11   º±±
±±Œ˜ŠŠ¹±±
±±ºDescrio  Retornar os totais da receita bruta mensal                 º±±
±±Parametros dDataDe   -> Data inicial de gerao do arquivo            ±±
±±           dDataAte  -> Data final de gerao do arquivo.             ±±
±±           cEmpAnt   -> Cdigo com empresa corrente.                  ±±
±±           cFilAte   -> Cdigo da primeira filial selecionada pelo    ±±
±±                        Usu¡rio na Wizard.                            ±±
±±           aWizard   -> Array com informaµes da Wizard.              ±±
±±           aLisFil   -> Array com filiais selecionadas pelo usu¡rio.  ±±
±±                        na wizard.                                    ±±
±±           cFilDe   -> Cdigo da ºltima filial selecionada pelo       ±±
±±                        Usu¡rio na Wizard.                            ±±
±±           aCFOPs   -> Array com CFOPs que geram receita.             ±±
±±           lTop     -> indica se est¡ procesasndo em TOP.             ±±
±±ˆ¼*/

Static Function TotEntGado(dDataDe,dDataAte,cEmpAnt,cFilAte,aWizard,aLisFil,cFilDe,aCFOPs,lTop)

Local cAliasSFT 	:= "SFT"
Local cAliasSB1 	:= "SB1"
Local aRetorno 		:= {0,0}
Local cFiltro 		:= ""
Local cCampos 		:= ""
Local cNrLivro		:= aWizard[1][3]
Local cEspecie		:= ""

DbSelectArea ("SM0")
SM0->(DbGoTop ())
SM0->(MsSeek (cEmpAnt+cFilDe, .T.))	//Pego a filial mais proxima

Do While !SM0->(Eof ()) .And. ((!"1"$aWizard[1][6] .And. cEmpAnt==SM0->M0_CODIGO .And. FWGETCODFILIAL<=cFilAte) .Or. ("1"$aWizard[1][6] .And. Len(aLisFil)>0 .And. cEmpAnt==SM0->M0_CODIGO  ))

	cFilAnt := FWGETCODFILIAL
	If Len(aLisFil)>0 //.And. Val(cFilAnt) <= Len(aLisFil)
        nFilial := Ascan(aLisFil,{|x|x[2]==cFilAnt})
	   If nFilial > 0
		   If !(aLisFil[  nFilial, 1 ])  //Filial no marcada, vai para proxima
				SM0->( dbSkip() )
				Loop
			EndIf
	   Else
			SM0->( dbSkip() )
			Loop
	   EndIf
	Else
		If "1"  $ aWizard[1][6] //Somente faz skip se a opo de selecionar filiais estiver como Sim.
			 SM0->( dbSkip() )
			 Loop
		EndIf
	EndIf

	//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
	//A querry ir¡ trazer o valor de compra de gado para montar a base de c¡lculo, para gerar valor de cr©dito presumido.
	//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
	DbSelectArea (cAliasSFT)
	(cAliasSFT)->(DbSetOrder (2))
	#IFDEF TOP
	    If (TcSrvType ()<>"AS/400")
	    	cAliasSFT	:=	GetNextAlias()

			cFiltro := "%"

			If (cNrLivro<>"*")
        		cFiltro += " SFT.FT_NRLIVRO = '" +%Exp:cNrLivro% +"' AND "
      		EndiF

			cFiltro += "%"
			cCampos := "%"

	    	BeginSql Alias cAliasSFT

				COLUMN FT_EMISSAO AS DATE
		    	COLUMN FT_ENTRADA AS DATE
		    	COLUMN FT_DTCANC AS DATE

				SELECT
					SUM(SFT.FT_VALCONT) FT_VALCONT ,SFT.FT_PRODUTO, SB1.B1_POSIPI
					%Exp:cCampos%
				FROM
					%Table:SFT% SFT
					LEFT JOIN %Table:SB1% SB1 ON(SB1.B1_FILIAL=%xFilial:SB1%  AND SB1.B1_COD=SFT.FT_PRODUTO AND SB1.%NotDel%)
				WHERE
					SFT.FT_FILIAL=%xFilial:SFT% AND
					SFT.FT_TIPOMOV = 'E' AND
					SFT.FT_ENTRADA>=%Exp:DToS (dDataDe)% AND
					SFT.FT_ENTRADA<=%Exp:DToS (dDataAte)% AND
					(SFT.FT_DTCANC = ' ' OR SFT.FT_DTCANC > %Exp:DToS (dDataAte)% )  AND
					SB1.B1_POSIPI LIKE '0102%' AND
					%Exp:cFiltro%
					SFT.%NotDel%

				GROUP BY SB1.B1_POSIPI ,SFT.FT_PRODUTO, SB1.B1_POSIPI

				ORDER BY SB1.B1_POSIPI

			EndSql
		Else
	#ENDIF
		    cIndex	:= CriaTrab(NIL,.F.)
		    cFiltro	:= 'FT_FILIAL=="'+xFilial ("SFT")+'".And.'
		    cFiltro += 'FT_TIPOMOV== "E" .And. '
		   	cFiltro += 'DToS (FT_ENTRADA)>="'+DToS (dDataDe)+'".And.DToS (FT_ENTRADA)<="'+DToS (dDataAte)+'" '
			cFiltro += ' .AND.(FT_DTCANC == " " .OR. DToS (FT_DTCANC)>"'+DToS (dDataDe)+'") '

		    If (cNrLivro<>"*")
			    cFiltro	+=	'.And.FT_NRLIVRO ="'+cNrLivro+'" '
		   	EndIf

		    IndRegua (cAliasSFT, cIndex, SFT->(IndexKey ()),, cFiltro)
		    nIndex := RetIndex(cAliasSFT)

			#IFNDEF TOP
				DbSetIndex (cIndex+OrdBagExt ())
			#ENDIF

			DbSelectArea (cAliasSFT)
		    DbSetOrder (nIndex+1)
	#IFDEF TOP
		Endif
	#ENDIF

	DbSelectArea (cAliasSFT)
	(cAliasSFT)->(DbGoTop ())
	ProcRegua ((cAliasSFT)->(RecCount ()))

	Do While !(cAliasSFT)->(Eof ())

		IF lTop
			//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
			//Acumula valor de compra de gado, pois o NCM j¡ foi filtrado na query
			//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
			aRetorno[1] += (cAliasSFT)->FT_VALCONT
		Else
			//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
			//Aqui tem que buscar o produto para verificar o NCM, para saber se ir¡ ou no acumular o valor da compra de gado.
			//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
			(cAliasSB1)->(msSeek(xFilial("SB1")+(cAliasSFT)->FT_PRODUTO))
			IF "0102" $ (cAliasSB1)->B1_POSIPI
				aRetorno[1] += (cAliasSFT)->FT_VALCONT
			EndIF
		EndIF

		(cAliasSFT)->(DbSkip ())
	EndDo

	#IFDEF TOP
		If (TcSrvType ()<>"AS/400")
			DbSelectArea (cAliasSFT)
			(cAliasSFT)->(DbCloseArea ())
		Else
	#ENDIF
			RetIndex("SFT")
			FErase(cIndex+OrdBagExt ())
	#IFDEF TOP
		EndIf
	#ENDIF

	cAliasSFT	:=	"SFT"
	SM0->(DbSkip ())
ENdDo
Return (aRetorno)

/*‘‹‘‹‘»±±
±±ºPrograma  CredPreGadºAutor  Erick G. Dias       º Data   08/03/12   º±±
±±Œ˜ŠŠ¹±±
±±ºDescrio  Faz o c¡lculo do cr©dito presumido conforme lei 12.058/2009º±±
±±º           Ir¡ itilizar o percentual de exportao, total do valor    º±±
±±º           de compras de gado, e utilizar al­quotas do par¢metro      º±±
±±º           MV_ACPPCAG conforme legislao.                            º±±
±±Œ˜¹±±
±±Parametros aVlrRec    -> Valores totalizados da receita.              ±±
±±           aVlrCompra -> Valores tatalizados de compra de gado.       ±±
±±           dDataAte   -> Data final de gerao do arquivo.            ±±
±±ˆ¼*/

Static Function CredPreGad(aVlrRec,aVlrCompra,dDataAte)

Local nAlqPis		:= 0
Local nAlqCof		:= 0
Local nValPis		:= 0
Local nValCof		:= 0
Local nPerExport	:= 0
Local nBaseCalc		:= 0
Local aRetorno		:= {0,0,"","","","",""}
Local cCodAjust		:= aParSX6[40]
Local cNumProc		:= aParSX6[41]
local cDescr		:= cNumProc
Local aAl­quota  	:= aParSX6[42]

aAl­quota   		:= Iif (Len(aAl­quota) > 1,&(aAl­quota),aAl­quota)
nAlqPis				:= aAl­quota[1]
nAlqCof				:= aAl­quota[2]

//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//Faz regra de 3 para descobrir o percentual de exportao
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
nPerExport	:= (aVlrRec[1] *100) / aVlrRec[2]

//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//Aplica o percentual no total de compra de gado, para saber qual a base de c¡lculo
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
nBaseCalc	:= (aVlrCompra[1] * nPerExport) /100


//C¡lculo dos valores de cr©ditos.

nValPis		:= Round((nBaseCalc * nAlqPis ) /100,2)
nValCof 	:= Round((nBaseCalc * nAlqCof ) /100,2)

aRetorno[1] := nValPis  		//Valor de cr©dito de PIS
aRetorno[2] := nValCof  	 	//Valor de cr©dito de Cofins
aRetorno[3] := "1" 				//Indicador de ajuste de acr©scimo
aRetorno[4] := cCodAjust	 	//Cdigo do Ajuste
aRetorno[5] := cNumProc 		//Nºmero do processo
aRetorno[6] := cDescr    		//Descrio
aRetorno[7] := dDataAte  		//Data

Return (aRetorno)

/*‘‹‘‹‘»±±
±±ºPrograma  AjusConDifºAutor  Erick G. Dias       º Data   13/02/12   º±±
±±Œ˜ŠŠ¹±±
±±ºDescrio Esta funo ir¡ buscar da tabela CF7 os valores de ajustes  º±±
±±º          de contribuio(seja de acr©scimo ou reduo), valores      º±±
±±º          de diferimento do per­odo atual e de per­odo anterior.	  º±±
±±Œ˜¹±±
±±ParametroscPer     -> Per­odo que ser¡ considerado para processamento ±±
±±          aAjusteA -> Array com valores de acr©scimo de contribuio  ±±
±±          aAjusteR -> Array com valores de Reduo de contribuio    ±±
±±          aDifer   -> Array com valores de diferimento do per­odo     ±±
±±          aDiferAnt-> Array com valores de diferimento de per­odo     ±±
±±                      anterior.                                       ±±
±±ˆ¼*/
Static Function AjusConDif(cPer,aAjusteA,aAjusteR,aDifer,aDiferAnt,dDataAte,cFilDe,cFilAte,cEmpAnt,aWizard,aLisFil)

Local cAliasCF7		:= "CF7"
Local nPos			:= 0
Local cSlctCF7		:= ""
Local alAreaM0		:= SM0->(GetArea())

DbSelectArea ("SM0")
SM0->(DbGoTop ())
SM0->(MsSeek (cEmpAnt+cFilDe, .T.))	//Pego a filial mais proxima

Do While !SM0->(Eof ()) .And. ((!"1"$aWizard[1][6] .And. cEmpAnt==SM0->M0_CODIGO .And. FWGETCODFILIAL<=cFilAte) .Or. ("1"$aWizard[1][6] .And. Len(aLisFil)>0 .And. cEmpAnt==SM0->M0_CODIGO  ))

	cFilAnt := FWGETCODFILIAL
	If Len(aLisFil)>0 //.And. Val(cFilAnt) <= Len(aLisFil)
        nFilial := Ascan(aLisFil,{|x|x[2]==cFilAnt})
	   If nFilial > 0
		   If !(aLisFil[  nFilial, 1 ])  //Filial no marcada, vai para proxima
				SM0->( dbSkip() )
				Loop
			EndIf
	   Else
			SM0->( dbSkip() )
			Loop
	   EndIf
	Else
		If "1"  $ aWizard[1][6] //Somente faz skip se a opo de selecionar filiais estiver como Sim.
			 SM0->( dbSkip() )
			 Loop
		EndIf
	EndIf

	DbSelectArea (cAliasCF7)
	(cAliasCF7)->(DbSetOrder (1))
	#IFDEF TOP
	    If (TcSrvType ()<>"AS/400")

			//CAMPOS DA TABELA CF7 PARA MONTAR A QUERY.

			cSlctCF7 := "CF7.CF7_PER,		CF7.CF7_PROJET,		CF7.CF7_DESCPR,		CF7.CF7_CLIE,		CF7.CF7_LOJA,		"
			cSlctCF7 +=	"CF7.CF7_CNPJC,		CF7.CF7_TPCLIE,		CF7.CF7_RECIND,		CF7.CF7_FAT,		CF7.CF7_RECEB,		"
			cSlctCF7 +=	"CF7.CF7_BCAJUS,	CF7.CF7_BCDIFE,		CF7.CF7_BCDFAN,		CF7.CF7_TPAJUS,		CF7.CF7_CODCON,		"
		    cSlctCF7 += "CF7.CF7_CODAJU, 	CF7.CF7_ALQPIS,		CF7.CF7_AJUPIS,		CF7.CF7_ALQCOF,		CF7.CF7_AJUCOF,		"
			cSlctCF7 += "CF7.CF7_PISDIF,	CF7.CF7_COFDIF,		CF7.CF7_DFPISA,		CF7.CF7_DFCOFA,	 	CF7.CF7_DTPAG		"
	    	cSlctCF7	:=	"%"+cSlctCF7+"%"

	    	cAliasCF7	:=	GetNextAlias()
		    cFiltro := "%"
			cCampos := "%"
			cFiltro += "%"
			cCampos += "%"

	    	BeginSql Alias cAliasCF7

				SELECT
					%Exp:cSlctCF7%
				FROM
					%Table:CF7% CF7
				WHERE
					CF7.CF7_FILIAL=%xFilial:CF7% AND
					CF7.CF7_PER  = %Exp:cPer% AND
					%Exp:cFiltro%
					CF7.%NotDel%
			EndSql
		Else
	#ENDIF
		    cIndex	:= CriaTrab(NIL,.F.)
		    cFiltro	:= 'CF7_FILIAL=="'+xFilial ("CF7")+'".And.'
		   	cFiltro += 'CF7_PER =="'+ cPer + '"'

		    IndRegua (cAliasCF7, cIndex, CF7->(IndexKey ()),, cFiltro)
		    nIndex := RetIndex(cAliasCF7)

			#IFNDEF TOP
				DbSetIndex (cIndex+OrdBagExt ())
			#ENDIF

			DbSelectArea (cAliasCF7)
		    DbSetOrder (nIndex+1)
	#IFDEF TOP
		Endif
	#ENDIF

	DbSelectArea (cAliasCF7)
	(cAliasCF7)->(DbGoTop ())
	ProcRegua ((cAliasCF7)->(RecCount ()))

	//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
	//Ir¡ buscar valores de ajustes referentes a construo Civil, medio.
	//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
	Do While !(cAliasCF7)->(Eof ())
		//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
		//Se existir valor de ajuste da contribuio ir¡ preencher array com valores de ajustes.
		//Estes valores sero gerados nos registros M220 e M620.                                
		//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
		If (cAliasCF7)->CF7_TPAJUS == "1" .AND. ((cAliasCF7)->CF7_AJUPIS >0 .OR. (cAliasCF7)->CF7_AJUCOF > 0	)
			//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
			//Ajuste de acr©scimo da contribuio
			//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
			aAdd(aAjusteA, {})
			nPos := Len(aAjusteA)
			aAdd (aAjusteA[nPos],(cAliasCF7)->CF7_CODCON)	//Cdigo de contribuio, para amarrar com registro pai M210
			aAdd (aAjusteA[nPos],(cAliasCF7)->CF7_AJUPIS)	//Valor do ajuste de PIS
			aAdd (aAjusteA[nPos],(cAliasCF7)->CF7_AJUCOF)   //Valor do ajuste de COFINS
			aAdd (aAjusteA[nPos],(cAliasCF7)->CF7_CODAJU)   //Cdigo do ajuste, que consta na tabela 4.3.8
			aAdd (aAjusteA[nPos],(cAliasCF7)->CF7_PROJET)   //Nºmero do documento ou processo
			aAdd (aAjusteA[nPos],(cAliasCF7)->CF7_DESCPR)   //Descrio do ajuste
			aAdd (aAjusteA[nPos], dDataAte)   				//Data da referªncia
			aAdd (aAjusteA[nPos], (cAliasCF7)->CF7_ALQPIS)	//Al­quota de PIS
			aAdd (aAjusteA[nPos], (cAliasCF7)->CF7_ALQCOF) //Al­quota de COFINS
			//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
			//Ajuste de reduo da contribuio
			//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
		ElseIf (cAliasCF7)->CF7_TPAJUS == "0" .AND. ((cAliasCF7)->CF7_AJUPIS > 0 .OR. (cAliasCF7)->CF7_AJUCOF > 0	)
			aAdd(aAjusteR, {})
			nPos := Len(aAjusteR)
			aAdd (aAjusteR[nPos],(cAliasCF7)->CF7_CODCON)	//Cdigo de contribuio, para amarrar com registro pai M210
			aAdd (aAjusteR[nPos],(cAliasCF7)->CF7_AJUPIS)	//Valor do ajuste de PIS
			aAdd (aAjusteR[nPos],(cAliasCF7)->CF7_AJUCOF)   //Valor do ajuste de COFINS
			aAdd (aAjusteR[nPos],(cAliasCF7)->CF7_CODAJU)   //Cdigo do ajuste, que consta na tabela 4.3.8
			aAdd (aAjusteR[nPos],(cAliasCF7)->CF7_PROJET)   //Nºmero do documento ou processo
			aAdd (aAjusteR[nPos],(cAliasCF7)->CF7_DESCPR)   //Descrio do ajuste
			aAdd (aAjusteR[nPos], dDataAte)  				 //Data da referªncia
			aAdd (aAjusteR[nPos], (cAliasCF7)->CF7_ALQPIS)	//Al­quota de PIS
			aAdd (aAjusteR[nPos], (cAliasCF7)->CF7_ALQCOF) //Al­quota de COFINS
		EndIF

		//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
		//Verifica se existe valor de diferimento de PIS e COFINS para o per­odo atual
		//Estes valores sero gerados nos registros M230 e M630.                      
		//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
		If (cAliasCF7)->CF7_PISDIF > 0 .OR. (cAliasCF7)->CF7_COFDIF > 0
			aAdd(aDifer, {})
			nPos := Len(aDifer)
			aAdd (aDifer[nPos],(cAliasCF7)->CF7_CNPJC)     //CNPJ do cliente rgo pºblico.
			aAdd (aDifer[nPos],(cAliasCF7)->CF7_RECIND)	//Valor total de venda no per­odo.
			aAdd (aDifer[nPos],(cAliasCF7)->CF7_BCDIFE)	//Valor total no recebido no per­odo.
			aAdd (aDifer[nPos],(cAliasCF7)->CF7_PISDIF)   //Valor de PIS diferido.
			aAdd (aDifer[nPos],(cAliasCF7)->CF7_COFDIF)   //Valor da Cofins diferido.
			aAdd (aDifer[nPos],(cAliasCF7)->CF7_CODCON)   //Cdigo da Contribuio.
			aAdd (aDifer[nPos], 0)
			aAdd (aDifer[nPos], 0)
			aAdd (aDifer[nPos], 0)
			aAdd (aDifer[nPos], "")
		EndIF

		//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
		//Verifica se existem valores de diferimento de PIS e COFINS de per­odo anteriores.
		//Estes valores sero gerados nos registros M300 e M700.                           
		//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
		If (cAliasCF7)->CF7_DFPISA > 0 .OR. (cAliasCF7)->CF7_DFCOFA > 0
			aAdd(aDiferAnt, {})
			nPos := Len(aDiferAnt)
			aAdd (aDiferAnt[nPos],(cAliasCF7)->CF7_CODCON)   //Cdigo da Contribuio.
			aAdd (aDiferAnt[nPos],(cAliasCF7)->CF7_DFPISA)   //Valor de PIS diferido.
			aAdd (aDiferAnt[nPos],(cAliasCF7)->CF7_DFCOFA)   //Valor de COFINS diferido.
			aAdd (aDiferAnt[nPos],cPer)  					 //Per­odo de apurao.
			aAdd (aDiferAnt[nPos],SubStr((cAliasCF7)->CF7_DTPAG,7,2)+SubStr((cAliasCF7)->CF7_DTPAG,5,2)+SubStr((cAliasCF7)->CF7_DTPAG,1,4))   //Data de recebimento.
			aAdd (aDiferAnt[nPos], (cAliasCF7)->CF7_ALQPIS)	//Al­quota de PIS
			aAdd (aDiferAnt[nPos], (cAliasCF7)->CF7_ALQCOF) //Al­quota de COFINS
			aAdd (aDiferAnt[nPos], 0)
			aAdd (aDiferAnt[nPos], 0)
			aAdd (aDiferAnt[nPos], "")
		EndIF

		(cAliasCF7)->(DbSkip ())
	EndDo

  	#IFDEF TOP
		If (TcSrvType ()<>"AS/400")
			DbSelectArea (cAliasCF7)
			(cAliasCF7)->(DbCloseArea ())
		Else
	#ENDIF
			RetIndex("CF7")
			FErase(cIndex+OrdBagExt ())
	#IFDEF TOP
		EndIf
	#ENDIF

	cAliasCF7	:=	"CF7"
	SM0->(DbSkip ())
ENdDo
SM0->(RestArea(alAreaM0))
cFilAnt := FWGETCODFILIAL
Return

/*‘‹‘‹‘»±±
±±ºPrograma  AjustAcresºAutor  Erick G. Dias       º Data   14/02/12   º±±
±±Œ˜ŠŠ¹±±
±±ºDescrio Ir¡ fazer o ajuste de acr©scimo da contribuio de PIS e    º±±
±±º          COFINS que tem origem do tratamento de Receita indicada.    º±±
±±Œ˜¹±±
±±ParametrosaAjusteA -> Array com valores de ajustes que tem origem     ±±
±±                      de tratamento de Receita Indicada.              ±±
±±          aRegM210 -> Valores de contribuio de PIS.                 ±±
±±          aRegM220 -> Valores de ajustes de PIS.                      ±±
±±          aRegM610 -> Valores de contribuio de COFINS.              ±±
±±          aRegM620 -> Valores de ajustes de COFINS.                   ±±
±±ˆ¼*/

Static Function AjustAcres(aAjusteA,aRegM210,aRegM220,aRegM610,aRegM620,dDataAte)

Local nPosMx10	:=0
Local nPosMx20	:=0
Local nPos		:=0

//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//Posiµes do Array aAjusteA:                                       
//01-Cdigo de contribuio, para amarrar com registro pai M210/M610
//02-Valor do ajuste de PIS                                         
//03-Valor do ajuste de COFINS                                      
//04-Cdigo do ajuste, que consta na tabela 4.3.8                   
//05-Nºmero do documento ou processo                                
//06-Descrio do ajuste                                            
//07-Data da referªncia                                             
//08-Al­quota de PIS.                                               
//09-Al­quota de COFINS.                                            
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™

For nPos :=1 to Len(aAjusteA)

	//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
	//Tratamento para fazer o ajuste de acr©scimo de PIS
	//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
	nPosMx10 := aScan (aRegM210, {|aX| aX[2]== aAjusteA[nPos][1] .AND. aX[5]== aAjusteA[nPos][8]})

	//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
	//Se encontrar registro pai M210 com mesmo cdigo de contribuio faz o ajuste de acr©scimo
	//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
	If nPosMx10 > 0
    	aRegM210[nPosMx10][9]	+= aAjusteA[nPos][2]
		aRegM210[nPosMx10][13]	+= aAjusteA[nPos][2]
	Else

		//Se no houver M210 ir¡ criar manualmente.

		nPosMx10:=AdicMX10(@aRegM210,aAjusteA[nPos],.T.,"AJU")
	EndIF

	//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
	//Gera registro M220 com indicador de acr©scimo
	//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
 	RegM220(@aRegM220,.T.,nPosMx10,aAjusteA[nPos][2],aAjusteA[nPos][4],aAjusteA[nPos][5],dDataAte	, aAjusteA[nPos][6], "RI", aAjusteA[nPos][5])

	//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
	//Tratamento para fazer o ajuste de acr©scimo de COFINS
	//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
	nPosMx10 := aScan (aRegM610, {|aX| aX[2]== aAjusteA[nPos][1] .AND. aX[5]== aAjusteA[nPos][9]})
	//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
	//Se encontrar registro pai M610 com mesmo cdigo de contribuio faz o ajuste de acr©scimo
	//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
	If nPosMx10 > 0
    	aRegM610[nPosMx10][9]	+= aAjusteA[nPos][3]
		aRegM610[nPosMx10][13]	+= aAjusteA[nPos][3]
	Else

		//Se no houver M210 ir¡ criar manualmente.

		nPosMx10:=	AdicMX10(@aRegM610,aAjusteA[nPos],.F.,"AJU")
	EndIF

	//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
	//Gera registro M220 com indicador de acr©scimo
	//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
	RegM620(@aRegM620,.T.,nPosMx10,aAjusteA[nPos][3],aAjusteA[nPos][4],aAjusteA[nPos][5],dDataAte	, aAjusteA[nPos][6], "RI", aAjusteA[nPos][5])
Next nPos
Return

/*±±ºPrograma  AjustReducºAutor  Erick G. Dias       º Data   14/02/12  º±±
±±ºDescrio Ir¡ fazer o ajuste de acr©scimo da contribuio de PIS e    º±±
±±º          COFINS que tem origem do tratamento de Receita indicada.    º±±
±±ParametrosaAjusteA -> Array com valores de ajustes que tem origem     ±±
±±                      de tratamento de Receita Indicada.              ±±
±±          aRegM210 -> Valores de contribuio de PIS.                 ±±
±±          aRegM220 -> Valores de ajustes de PIS.                      ±±
±±          aRegM610 -> Valores de contribuio de COFINS.              ±±
±±          aRegM620 -> Valores de ajustes de COFINS.                   ±±
±±ˆ¼*/

Static Function AjustReduc(aAjusteR,aRegM210,aRegM220,aRegM610,aRegM620,dDataAte)

Local nPosMx10	:=0
Local nPosMx20	:=0
Local nPos		:=0

//Posiµes do Array aAjusteA:                                       
//01-Cdigo de contribuio, para amarrar com registro pai M210/M610
//02-Valor do ajuste de PIS                                         
//03-Valor do ajuste de COFINS                                      
//04-Cdigo do ajuste, que consta na tabela 4.3.8                   
//05-Nºmero do documento ou processo                                
//06-Descrio do ajuste                                            
//07-Data da referªncia                                             
//08-Al­quota de PIS.                                               
//09-Al­quota de COFINS.                                            
//10-Filial origem do ajuste (utilizado em casos especificos)		 

For nPos :=1 to Len(aAjusteR)

	//Tratamento para fazer o ajuste de acr©scimo de PIS
	nPosMx10 := aScan (aRegM210, {|aX| aX[2]== aAjusteR[nPos][1]})

	//Se encontrar registro pai M210 com mesmo cdigo de contribuio faz o ajuste de acr©scimo
	If nPosMx10 > 0
    	aRegM210[nPosMx10][10]	+= aAjusteR[nPos][2]
		aRegM210[nPosMx10][13]	-= aAjusteR[nPos][2]

		//Gera registro M220 com indicador de acr©scimo
		RegM220(@aRegM220,.F.,nPosMx10,aAjusteR[nPos][2],aAjusteR[nPos][4],aAjusteR[nPos][5],dDataAte,aAjusteR[nPos][6],"RI",aAjusteR[nPos][5])
	EndIF

	//Tratamento para fazer o ajuste de acr©scimo de COFINS
		nPosMx10 := aScan (aRegM610, {|aX| aX[2]== aAjusteR[nPos][1]})
	//Se encontrar registro pai M610 com mesmo cdigo de contribuio faz o ajuste de acr©scimo

	If nPosMx10 > 0
    	aRegM610[nPosMx10][10]	+= aAjusteR[nPos][3]
		aRegM610[nPosMx10][13]	-= aAjusteR[nPos][3]

		//Gera registro M220 com indicador de acr©scimo
		RegM620(@aRegM620,.F.,nPosMx10,aAjusteR[nPos][3],aAjusteR[nPos][4],aAjusteR[nPos][5],dDataAte,aAjusteR[nPos][6],"RI",aAjusteR[nPos][5])
	EndIF
Next nPos
Return

/*‘‹‘‹‘»±±
±±ºPrograma  AjustReducºAutor  Erick G. Dias       º Data   14/02/12   º±±
±±Œ˜ŠŠ¹±±
±±ºDescrio Ir¡ processar os valores de diferimento que tiveram         º±±
±±º          origem atrav©s da rotina de Receita Indicada, tabela CF7.   º±±
±±Œ˜¹±±
±±ParametrosaDifer   -> Array caom valore de Diferimento no per­odo.    ±±
±±          aRegM210 -> Valores de contribuio de PIS.                 ±±
±±          aRegM230 -> Valores de diferimento de PIS                   ±±
±±          aRegM610 -> Valores de contribuio de COFINS.              ±±
±±          aRegM630 -> Valores de diferimento de COFINS.               ±±
±±          dDataAte -> Data final do per­odo.                          ±±
±±ˆ¼*/

Static Function AjustDifer(aDifer,aRegM210,aRegM230,aRegM610,aRegM630,dDataAte)

Local nPosMx10	:=0
Local nPosMx30	:=0
Local nPos		:=0

//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//Posiµes do Array aDifer:              
//01-CNPJ do cliente rgo pºblico       
//02-Valor total de venda no per­odo     
//03-Valor total no recebido no per­odo 
//04-Valor de PIS diferido               
//05-Valor da Cofins diferido            
//06-Cdigo da Contribuio              
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™

For nPos :=1 to Len(aDifer)

	//Tratamento para atualizar valor de diferimento de PIS.|
	nPosMx10 := aScan (aRegM210, {|aX| aX[2]== aDifer[nPos][6]})

	//Se encontrar registro pai M210 com mesmo cdigo de contribuio faz o ajuste de acr©scimo
	If nPosMx10 > 0
    	aRegM210[nPosMx10][11]	+= aDifer[nPos][4]
		aRegM210[nPosMx10][13]	-= aDifer[nPos][4]
	EndIF

	//Gera o registro referente a PIS diferido.
	RegM230(@aRegM230,nPosMx10,0, .T., aDifer[nPos])

	//Tratamento para fazer o ajuste de acr©scimo de COFINS
	nPosMx10 := aScan (aRegM610, {|aX| aX[2]== aDifer[nPos][6]})

	//Tratamento para atualizar valor de diferimento de COFINS no registro M610|
	If nPosMx10 > 0
    	aRegM610[nPosMx10][11]	+= aDifer[nPos][5]
		aRegM610[nPosMx10][13]	-= aDifer[nPos][5]
	EndIF
	//Gera o registro referente a COFINS diferido.
	RegM630(@aRegM630,nPosMx10,0, .T., aDifer[nPos])
Next nPos
Return

/*‘‹‘‹‘»±±
±±ºPrograma  AjDiferAntºAutor  Erick G. Dias       º Data   14/02/12   º±±
±±ºDescrio Ir¡ processar os valores de diferimento que tiveram         º±±
±±º          origem atrav©s da rotina de Receita Indicada, tabela CF7.   º±±
±±ParametrosaDifer   -> Array caom valore de Diferimento no per­odo.    ±±
±±          aRegM210 -> Valores de contribuio de PIS.                 ±±
±±          aRegM230 -> Valores de diferimento de PIS                   ±±
±±          aRegM610 -> Valores de contribuio de COFINS.              ±±
±±          aRegM630 -> Valores de diferimento de COFINS.               ±±
±±          dDataAte -> Data final do per­odo.                          ±±
±±ˆ¼*/

Static Function AjDiferAnt(aDiferAnt,aRegM210,aRegM300,aRegM610,aRegM700,dDataAte,aAjusteR)

Local nPosMx10	:=0
Local nPosMx20	:=0
Local nPos		:=0


//Posiµes do Array aDiferAnt:    
//01-Cdigo da Contribuio       
//02-Valor de PIS diferido        
//03-Valor de COFINS diferido     
//04-Per­odo de apurao          
//05-Data de recebimento.         
//06-Al­quota de PIS.             
//07-Al­quota de COFINS.          

For nPos :=1 to Len(aDiferAnt)

	//Tratamento de PIS
	nPosMx10 := aScan (aRegM210, {|aX| aX[2]== aDiferAnt[nPos][1] .AND. aX[5]== aDiferAnt[nPos][6]})
	//Acumula valor de diferimento de PIS de per­odo anterior no registro M210
	If nPosMx10 > 0
    	aRegM210[nPosMx10][12]	+= aDiferAnt[nPos][2]-aDiferAnt[nPos][8]
		aRegM210[nPosMx10][13]	+= aDiferAnt[nPos][2]-aDiferAnt[nPos][8]
	Else

		//Se no houver M210 ir¡ criar manualmente.

		AdicMX10(@aRegM210,aDiferAnt[nPos],.T.,"DIF")

		If aDiferAnt[nPos][1] $ "71/72"
			aAdd(aAjusteR, {})
			nPosMx20 := Len(aAjusteR)
			aAdd (aAjusteR[nPosMx20],aDiferAnt[nPos][1])		//Cdigo de contribuio, para amarrar com registro pai M210
			aAdd (aAjusteR[nPosMx20],0)							//Valor do ajuste de PIS
			aAdd (aAjusteR[nPosMx20],0)   						//Valor do ajuste de COFINS
			aAdd (aAjusteR[nPosMx20],"06")   					//Cdigo do ajuste, que consta na tabela 4.3.8
			aAdd (aAjusteR[nPosMx20],"")   						//Nºmero do documento ou processo
			aAdd (aAjusteR[nPosMx20],"Registro de ajuste referente valores diferidos em per­odos anteriores de SCP")   //Descrio do ajuste
			aAdd (aAjusteR[nPosMx20], dDataAte)  		   //Data da referªncia
			aAdd (aAjusteR[nPosMx20], aDiferAnt[nPos][6]) //Al­quota de PIS
			aAdd (aAjusteR[nPosMx20], aDiferAnt[nPos][7]) //Al­quota de COFINS
		EndIF

	EndIF

	//Gera registro M300 com valor de diferimento de PIS de per­odo anterior
	RegM300(@aRegM300,.T., aDiferAnt[nPos])

	//Tratamento de COFINS
	nPosMx10 := aScan (aRegM610, {|aX| aX[2]== aDiferAnt[nPos][1] .AND. aX[5]== aDiferAnt[nPos][7]})

	//Acumula valor de diferimento de PIS de per­odo anterior no registro M610
	If nPosMx10 > 0
    	aRegM610[nPosMx10][12]	+= aDiferAnt[nPos][3]-aDiferAnt[nPos][9]
		aRegM610[nPosMx10][13]	+= aDiferAnt[nPos][3]-aDiferAnt[nPos][9]
	Else

		//Se no houver M610 ir¡ criar manualmente.
		AdicMX10(@aRegM610,aDiferAnt[nPos],.F.,"DIF")
	EndIF

	//Gera registro M700 com valor de diferimento de COFINS de per­odo anterior
	RegM700(@aRegM700,.T.,aDiferAnt[nPos])

Next nPos

Return

/*‘‹‘‹‘»±±
±±ºPrograma  AdicMX10  ºAutor  Erick G. Dias       º Data   15/02/12   º±±
±±Œ˜ŠŠ¹±±
±±ºDescrio Adiciona M210 ou M610 quando no existe com origem de NF    º±±
±±º          para que no fique um M220 ou M300 sem registro pai.        º±±
±±ParametrosaRegmX10  -> Array com valores de M210 ou M610.             ±±
±±          aAjusteA  -> Array com valores de M220 ou M300.             ±±
±±          lPis      -> Indica se o valor © de PIS ou COFINS.          ±±
±±          cOrigem   -> Origem, se © ajuste ou diferimento.            ±±
±±ˆ¼*/

Static Function AdicMX10(aRegmX10,aAjusteA,lPis,cOrigem)

Local nPos 		:= 0
Local nAlq		:= 0
Local nAju		:= 0
Local nDifAnt	:= 0


//Posiµes quando se tratar ajuste de acr©scimo
//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//Posiµes do Array aAjusteA:                                       
//01-Cdigo de contribuio, para amarrar com registro pai M210/M610
//02-Valor do ajuste de PIS                                         
//03-Valor do ajuste de COFINS                                      
//04-Cdigo do ajuste, que consta na tabela 4.3.8                   
//05-Nºmero do documento ou processo                                
//06-Descrio do ajuste                                            
//07-Data da referªncia                                             
//08-Al­quota de PIS.                                               
//09-Al­quota de COFINS.                                            
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™

//Posiµes quando se tratar de diferimento de per­odo anterior.

//Posiµes do Array aDiferAnt:    
//01-Cdigo da Contribuio       
//02-Valor de PIS diferido        
//03-Valor de COFINS diferido     
//04-Per­odo de apurao          
//05-Data de recebimento.         
//06-Al­quota de PIS.             
//07-Al­quota de COFINS..         

//Valores de ajustes (M220 ou M620)
IF cOrigem == "AJU"

	If lPis
		nAlq	:= aAjusteA[8]
		nAju	:= aAjusteA[2]
	Else
		nAlq	:= aAjusteA[9]
		nAju	:= aAjusteA[3]
	EndIF


//Valores de diferimento anterior.

ElseIF cOrigem == "DIF"

	If lPis
		nAlq	:= aAjusteA[6]
		nDifAnt	:= aAjusteA[2]-aAjusteA[8]
	Else
		nAlq	:= aAjusteA[7]
		nDifAnt	:= aAjusteA[3]-aAjusteA[9]
	EndIF

EndIF

//Adiciona manualmente M210 ou M610, pois nesta situao no houve movimentao de nota fiscal.
aAdd(aRegmX10, {})
nPos := Len(aRegmX10)
aAdd (aRegmX10[nPos], Iif(lPis, "M210","M610"))	//01 - REG
aAdd (aRegmX10[nPos], aAjusteA[1])					//02 - COD_CONT
aAdd (aRegmX10[nPos], 0)							//03 - VL_REC_BRT
aAdd (aRegmX10[nPos], 0)							//04 - VL_BC_CONT
aAdd (aRegmX10[nPos], nAlq)					   		//05 - ALIQ_PIS
aAdd (aRegmX10[nPos], "")							//06 - QUANT_BC_PIS
aAdd (aRegmX10[nPos], "")							//07 - ALIQ_PIS_QUANT
aAdd (aRegmX10[nPos], 0)							//08 - VL_CONT_APUR
aAdd (aRegmX10[nPos], nAju)							//09 - VL_AJUS_ACRES
aAdd (aRegmX10[nPos], 0)							//10 - VL_AJUS_REDUC
aAdd (aRegmX10[nPos], 0)							//11 - VL_CONT_DIFER
aAdd (aRegmX10[nPos], nDifAnt)						//12 - VL_CONT_DIFER_ANT
aAdd (aRegmX10[nPos], nAju + nDifAnt)				//13 - VL_CONT_PER

Return (nPos)

/*‘‹‘‹‘»±±
±±ºPrograma  RedFinMX20ºAutor  Luccas Curcio       º Data   08/03/12   º±±
±±Œ˜ŠŠ¹±±
±±ºDescrio  Ira buscar informacoes do Financeiro atraves da funcao     º±±
±±º           FinSpdM220() para gerar os ajustes necessarios 			  º±±
±±ParametrosaRegM210 -> Array com conteudo do registro M210		 	  ±±
±±          aRegM220 -> Array com conteudo do registro M220		 	  ±±
±±          aRegM610 -> Array com conteudo do registro M610		 	  ±±
±±          aRegM620 -> Array com conteudo do registro M620		 	  ±±
±±          dDataDe -> Data Inicial do per­odo de gerao do arquivo 	  ±±
±±          dDataAte -> Data Final do per­odo de gerao do arquivo 	  ±±
±±          lCumulativ -> Indica o tipo do regime					 	  ±±
±±ˆ¼*/
Static Function RedFinMX20(aRegM210,aRegM220,aRegM610,aRegM620,dDataDe,dDataAte,lCumulativ)

Local	aTitulo		:=	{}
Local	aAjuste		:=	{}
Local	nX			:=	0
Local	cCondCont	:=	""

//Alimenta o array aTitulo com o conteudo retornado da funcao do Financeiro
aTitulo	:=	FinSpdM220(Month(dDataDe),Year(dDataDe))

For nX := 1 To Len(aTitulo)

	If aTitulo[nX][6] > 0 .Or. aTitulo[nX][7] > 0

		cCondCont	:=	SPDCodCont("",.T., aTitulo[nX][8],aTitulo[nX][10],lCumulativ,,cRegime,,aParSX6[5])

		aAdd (aAjuste, {})
		aAdd (aAjuste[1],cCondCont)			//01-Codigo de contribuicao, para amarrar com registro pai M210/M610
		aAdd (aAjuste[1],aTitulo[nX][6])	//02-Valor do ajuste de PIS
		aAdd (aAjuste[1],aTitulo[nX][7])	//03-Valor do ajuste de COFINS
		aAdd (aAjuste[1],aTitulo[nX][2])	//04-Codigo do ajuste, que consta na tabela 4.3.8
		aAdd (aAjuste[1],aTitulo[nX][3])	//05-Numero do documento ou processo
		aAdd (aAjuste[1],aTitulo[nX][4])	//06-Descricao do ajuste
		aAdd (aAjuste[1],aTitulo[nX][5])	//07-Data da referencia
		aAdd (aAjuste[1],aTitulo[nX][10])	//08-Aliquota de PIS
		aAdd (aAjuste[1],aTitulo[nX][11])	//09-Aliquota de COFINS

		//Chamada da funcao AjustReduc, para criacao ou aglutinacao dos registros MX10 e MX20 necessarios
		AjustReduc(aAjuste,@aRegM210,@aRegM220,@aRegM610,@aRegM620,dDataAte)

	Endif

	aAjuste	:=	{}

Next nX

Return


/*‰‘‹‘‹‘»±±
±±ºPrograma  RegF150    ºAutor  Erick G. Dias       º Data   27/02/12   º±±
±±Œ˜ŠŠ¹±±
±±ºDescrio  Ir¡ buscar informaµes da tabela CF8, que foram inclu­das  º±±
±±º           manualmente pelo usu¡rio, e sero gerados no registro F100 º±±
±±Œ˜¹±±
±±ParametrosdDataDe -> Data Inicial do per­odo de gerao do arquivo 	  ±±
±±          dDataAte-> Data Final de gerao do arquivo.             	  ±±
±±ˆ¼*/
static Function RegF150(dDataDe,aRegF150,aReg0500,aRegM105,aRegM505,cRegime,cIndApro,aReg0111, lExtTaf )

Local cAliasCF9		:= "CF9"
Local cSlctCF9		:= ""
Local dDtIng		:= firstday(dDataDe)
Local nCont			:= 0
Local nQtdMesAnt	:= 12
local aFieldDt		:= {}
local nPosF150		:= 0
local cConta		:= ""

Default lExtTaf := .F.

For nCont := 1 to nQtdMesAnt
	dDtIng	:=firstday(dDtIng)-1
Next nCont

dDtIng	:=firstday(dDtIng)
dMesIng := month(dDtIng)

//Se for chamada por funcao externa tenho que carregar as Statics do Sped Pis Cofins
If lExtTaf
	SpdCLCache()
EndIf

DbSelectArea (cAliasCF9)
(cAliasCF9)->(DbSetOrder (1))
#IFDEF TOP
    If (TcSrvType ()<>"AS/400")

		//CAMPOS DA TABELA CF9 PARA MONTAR A QUERY.

		cSlctCF9 := "CF9.CF9_CODBCC,	CF9.CF9_PERING,		CF9.CF9_VLTEST,		CF9.CF9_SCRED ,		CF9.CF9_BASCAL,		"
		cSlctCF9 +=	"CF9.CF9_BASMES,	CF9.CF9_CSTPIS,		CF9.CF9_ALQPIS,		CF9.CF9_VALPIS,		CF9.CF9_CSTCOF,		"
		cSlctCF9 +=	"CF9.CF9_ALQCOF,	CF9.CF9_VALCOF,		CF9.CF9_DESCPR,		CF9.CF9_CODCTA"

    	cSlctCF9	:=	"%"+cSlctCF9+"%"

    	aAdd(aFieldDt,"CF9_PERING")

    	cAliasCF9	:=	GetNextAlias()
	    cFiltro := "%"
		cCampos := "%"
		cFiltro += "%"
		cCampos += "%"

    	BeginSql Alias cAliasCF9

			SELECT
				%Exp:cSlctCF9%
			FROM
				%Table:CF9% CF9
			WHERE
				CF9.CF9_FILIAL=%xFilial:CF9% AND
				CF9.CF9_PERING>%Exp:DToS (dDtIng)% AND
				%Exp:cFiltro%
				CF9.%NotDel%
		EndSql

		TcSetField(cAliasCF9,"CF9_PERING","D",8,0)

	Else
#ENDIF
	    cIndex	:= CriaTrab(NIL,.F.)
	    cFiltro	:= 'CF9_FILIAL=="'+xFilial ("CF9")+'".And.'
	   	cFiltro += 'DToS (CF9_PERING)>="'+DToS (dDtIng)+'" '
	    IndRegua (cAliasCF9, cIndex, CF9->(IndexKey ()),, cFiltro)
	    nIndex := RetIndex(cAliasCF9)

		#IFNDEF TOP
			DbSetIndex (cIndex+OrdBagExt ())
		#ENDIF

		DbSelectArea (cAliasCF9)
	    DbSetOrder (nIndex+1)
#IFDEF TOP
	Endif
#ENDIF

DbSelectArea (cAliasCF9)

(cAliasCF9)->(DbGoTop ())
ProcRegua ((cAliasCF9)->(RecCount ()))
Do While !(cAliasCF9)->(Eof ())
	If Month((cAliasCF9)->CF9_PERING) == dMesIng .And. Year(dDataDe) > Year((cAliasCF9)->CF9_PERING)  //no considera o 13 mes.
		(cAliasCF9)->(dbSkip())
		loop
	endif
	cConta	:= Reg0500(aReg0500,(cAliasCF9)->CF9_CODCTA, "")

	If !lExtTaf
		nPosF150 := aScan (aRegF150, {|aX| aX[2]==(cAliasCF9)->CF9_CODBCC .AND. aX[7]==(cAliasCF9)->CF9_CSTPIS .AND. aX[8]==(cAliasCF9)->CF9_ALQPIS .AND. aX[10]==(cAliasCF9)->CF9_CSTCOF .AND. aX[11]==(cAliasCF9)->CF9_ALQCOF .AND.  aX[14]==cConta })
	Else
		nPosF150 := aScan (aRegF150, {|aX| aX[2]==(cAliasCF9)->CF9_CODBCC .And. aX[7]==(cAliasCF9)->CF9_CSTPIS .And.;
											aX[8]==(cAliasCF9)->CF9_ALQPIS .And. aX[10]==(cAliasCF9)->CF9_CSTCOF .And.;
											aX[11]==(cAliasCF9)->CF9_ALQCOF .And. aX[14]==cConta .And.  aX[15] == (cAliasCF9)->CF9_PERING })
	EndIf

	If nPosF150 == 0
		aAdd(aRegF150, {})
		nPos := Len(aRegF150)
		aAdd (aRegF150[nPos], "F150")						//01 - REG
		aAdd (aRegF150[nPos],(cAliasCF9)->CF9_CODBCC )		//02 - NAT_BC_CRED
		aAdd (aRegF150[nPos],(cAliasCF9)->CF9_VLTEST )		//03 - VL_TOT_EST
		aAdd (aRegF150[nPos],(cAliasCF9)->CF9_SCRED )		//04 - EST_IMP
		aAdd (aRegF150[nPos],(cAliasCF9)->CF9_BASCAL)		//05 - VL_BC_EST
		aAdd (aRegF150[nPos],(cAliasCF9)->CF9_BASMES )		//06 - VL_BC_MEN_EST
		aAdd (aRegF150[nPos],(cAliasCF9)->CF9_CSTPIS )		//07 - CST_PIS
		aAdd (aRegF150[nPos],(cAliasCF9)->CF9_ALQPIS )		//08 - ALIQ_PIS
		aAdd (aRegF150[nPos],(cAliasCF9)->CF9_VALPIS )		//09 - VL_CREDPIS
		aAdd (aRegF150[nPos],(cAliasCF9)->CF9_CSTCOF )		//10 - CST_COFINS
		aAdd (aRegF150[nPos],(cAliasCF9)->CF9_ALQCOF )		//11 - ALIQ_COFINS
		aAdd (aRegF150[nPos],(cAliasCF9)->CF9_VALCOF )		//12 - VL_CRED_COFINS
		aAdd (aRegF150[nPos],(cAliasCF9)->CF9_DESCPR )		//13 - DESCR_EST
		aAdd (aRegF150[nPos],cConta )		//14 - COD_CTA


		If lExtTaf
			aAdd( aRegF150[nPos], (cAliasCF9)->CF9_PERING )
		EndIf
	Else
		aRegF150[nPosF150][3] += (cAliasCF9)->CF9_SCRED 	//03 - VL_TOT_EST
		aRegF150[nPosF150][4] += (cAliasCF9)->CF9_SCRED 	//04 - EST_IMP
		aRegF150[nPosF150][5] += (cAliasCF9)->CF9_BASCAL	//05 - VL_BC_EST
		aRegF150[nPosF150][6] += (cAliasCF9)->CF9_BASMES 	//06 - VL_BC_MEN_EST
		aRegF150[nPosF150][9] += (cAliasCF9)->CF9_VALPIS 	//09 - VL_CREDPIS
		aRegF150[nPosF150][12] += (cAliasCF9)->CF9_VALCOF	//12 - VL_CRED_COFINS
	EndIF

	If !lExtTaf
		//Acumula valores de cr©dito de PIS no bloco M
		AcumM105(aRegM105,,cRegime,.F.,cIndApro,aReg0111,.T.,,,,,,,,cAliasCF9)
		//Acumula valores de cr©dito de COFINS no bloco M
		AcumM505(aRegM505,,cRegime,.F.,cIndApro,aReg0111,.T.,,,,,,,,cAliasCF9)
	EndIf
	(cAliasCF9)->(DbSkip ())
EndDo
#IFDEF TOP
	If (TcSrvType ()<>"AS/400")
		DbSelectArea (cAliasCF9)
		(cAliasCF9)->(DbCloseArea ())
	Else
#ENDIF
		RetIndex("CF9")
#IFDEF TOP
	EndIf
#ENDIF
Return (cAliasCF9)

/*‘‹‘‹‘»±±
±±ºPrograma  RegP010   ºAutor  Caio M. de Oliveira  º Data   18/04/11  º±±
±±ºDesc.      Processamento do registro P010                             º±±
±±ˆ¼*/
Static Function RegP010(aRegP010,nPaiP)

Local nPos := 0

//If aScan (aRegP010, {|aX| AllTrim(aX[2])==AllTrim(SM0->M0_CGC)}) == 0
	aAdd(aRegP010, {})
	nPos	:=	Len (aRegP010)
	aAdd (aRegP010[nPos],"P010") //01-REG
	aAdd (aRegP010[nPos], AllTrim(SM0->M0_CGC)) //02-CNPJ
	nPaiP += 1
//EndIf
Return

 /*‘‹‘‹‘»±±
±±ºPrograma  RegP100   ºAutor  Caio M. de Oliveira  º Data   18/04/11  º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Processamento do registro P100                             º±±
±±ˆ¼*/
static Function RegP100(aRegP100, aRegP200, aReg0145, lBlocoPRH, cAliasP, nRelacFil, nPaiP, cSPCBPSE, cPCodServ, cPCodDem, nTotF,nTotPrev, nTotAt,  lExtTaf, cRegTaf, dDataDeExt, dDataAtExt,aRecBrtFil )

Local nPos 		:= 0
Local nAliq		:= 0
Local nContrib	:= 0
Local cCodRec	:= ""
Local nTotal	:= 0
Local nPosP100	:= 0
Local lGravou	:= .F.
Local nCF8		:= 0    
Local nX        := 0

Default aRegP100	:= {}
Default nTotF		:= 0
Default lExtTaf     := .F.
Default cRegTaf     := "P100"
Default dDataDeExt  :=	CToD ("//")
Default dDataAtExt  :=	CToD ("//")

//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//Tratamento para que quando a funcao estiver sendo chamada pelo 
//extrator seja considerada a data de passada nos parametros     
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
If !Empty( dDataAtExt )
	dDataAte := dDataAtExt
EndIf

If !Empty( dDataDeExt )
	dDataDe := dDataDeExt
EndIf

(cAliasP)->(DbGoTop())
Do While !(cAliasP)->(Eof ())
	If !Empty((cAliasP)->CODATV)

		nAliq		:= 0
		nContrib	:= 0
	    lGravou		:= .T.

		If lBlocoPRH
			nTotal		:= (cAliasP)->TOTAL
			nAliq		:= (cAliasP)->ALIQ
			nContrib	:= (cAliasP)->TOTCONTR
		Else
			nCF8 := aScan(aRecBrtFil,{|x| x[1] == FWCODFIL() .And. x[2] > 0})
			nTotal		:= (cAliasP)->TOTAL+IIF(nCF8 > 0,aRecBrtFil[nCF8,2], 0)
			nAliq		:= SpedPCCG1((cAliasP)->CODATV,dDataAte)
			nContrib	:= (cAliasP)->TCDEVEXP*(nAliq/100)
		EndIf

		nPosP100 := aScan (aRegP100, {|aX| AllTrim(aX[5])==AllTrim((cAliasP)->CODATV) })

		If nPosP100 == 0

			aAdd(aRegP100, {})
			nPos	:=	Len (aRegP100)
			aAdd (aRegP100[nPos], iif( !lExtTaf , "P100" , cRegTAF ) )								//01-REG
			aAdd (aRegP100[nPos], dDataDe	) 							//02-DT_INI
			aAdd (aRegP100[nPos], dDataAte	) 							//03-DT_FIN
			aAdd (aRegP100[nPos], nTotal    )  							//04-VL_REC_TOT_EST
			aAdd (aRegP100[nPos], AllTrim((cAliasP)->CODATV) )			//05-COD_ATIV_ECON
			aAdd (aRegP100[nPos], (cAliasP)->TOTCODAT)					//06-VL_REC_ATIV_ESTAB
			aAdd (aRegP100[nPos], (cAliasP)->(TOTCODAT - TCDEVEXP)) 	//07-VL_EXC
			aAdd (aRegP100[nPos], (cAliasP)->TCDEVEXP)				 	//08-VL_BC_CONT
			aAdd (aRegP100[nPos], nAliq    	) 							//09-ALIQ_CONT
			aAdd (aRegP100[nPos], nContrib	) 							//10-VL_CONT_APU
			aAdd (aRegP100[nPos], "") 									//11-COD_CTA
			aAdd (aRegP100[nPos], "") 									//12-INFO_COMPL

	    Else
			aRegP100[nPosP100][04]	+= nTotal							//04-VL_REC_TOT_EST
		    aRegP100[nPosP100][06]	+= (cAliasP)->TOTCODAT				//06-VL_REC_ATIV_ESTAB
		    aRegP100[nPosP100][07]	+= (cAliasP)->(TOTCODAT - TCDEVEXP)//07-VL_EXC
		    aRegP100[nPosP100][08]	+= (cAliasP)->TCDEVEXP				//08-VL_BC_CONT
		    aRegP100[nPosP100][10]	+= nContrib							//10-VL_CONT_APU

	    EndIf

	    If (cAliasP)->CODATV$cSPCBPSE      		// cdigo © relativo a prestaao de servio
			cCodRec := cPCodServ
		Else								 	// Demais casos
			cCodRec := cPCodDem
		EndIf

		nTotAt   += (cAliasP)->TOTCODAT

		RegP200(@aRegP200, nContrib, cCodRec)
  	EndIf
	(cAliasP)->(DbSkip ())
EndDo
nTotPrev += nTotal 

//Se esses campos estiverem com valor negativo Zero o valor.
For nX := 1 to Len(aRegP100)
	If aRegP100[nX][8] < 0 
		aRegP100[nX][8] := 0
	EndIf
	If aRegP100[nX][10] < 0
		aRegP100[nX][10] := 0
	EndIf	
Next nX     

For nX := 1 to Len(aRegP200)
	If aRegP200[nX][3] < 0
		aRegP200[nX][3] := 0
	EndIf
	If aRegP200[nX][6] < 0 
		aRegP200[nX][6] := 0
	EndIf
Next nX

Return lGravou

 /*‘‹‘‹‘»±±
±±ºPrograma  RegP200   ºAutor  Caio M. de Oliveira  º Data   18/04/11  º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Processamento do registro P200                             º±±
±±ˆ¼*/
Static Function RegP200(aRegP200, nContrib, cCodRec)

Local nPos 		:= 0
Local nPosP200	:= 0
Local cMesAno	:= Alltrim(StrZero(Month(dDataDe),2))+Alltrim(Str(Year(dDataDe)))

Default cCodRec	:= ""
Default aRegP200	:= {}
Default nContrib	:= 0

nPosP200 := aScan (aRegP200, {|aX| AllTrim(aX[7])==AllTrim(cCodRec)})
If nPosP200 == 0
	aAdd(aRegP200, {})
	nPos	:=	Len (aRegP200)
	aAdd (aRegP200[nPos],"P200"			)		//01-REG
	aAdd (aRegP200[nPos], cMesAno 		)		//02-CNPJ
	aAdd (aRegP200[nPos], nContrib		) 		//03-CNPJ
	aAdd (aRegP200[nPos], 0				)		//04-CNPJ
	aAdd (aRegP200[nPos], 0				)		//05-CNPJ
	aAdd (aRegP200[nPos], nContrib		) 		//06-CNPJ
	aAdd (aRegP200[nPos], cCodRec		)		//07-CNPJ

Else
	aRegP200[nPosP200][03] +=	nContrib
	aRegP200[nPosP200][06] +=	nContrib
EndIf
Return

 /*‘‹‘‹‘»±±
±±ºPrograma  Reg0145   ºAutor  Caio M. de Oliveira  º Data   18/04/11  º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Processamento do registro 0145                             º±±
±±ˆ¼*/
Static Function Reg0145(aReg0145, nTotal, nTotAt, nTotPrev, cCodIncT)

Local nPos 		:= 0
Local nDemais	:= 0
Local cIndic	:= "1"

Default aReg0145	:={}
Default nTotal		:= 0
Default nTotAt		:= 0
Default nTotPrev	:= 0

nDemais := nTotPrev-nTotAt

If cCodIncT  <> ""
   cIndic := cCodIncT
Else
	If nDemais > 0
	   cIndic	:= "2"
	Endif
Endif


If Len(aReg0145)==0
	aAdd (aReg0145, {})
	nPos	:=	Len (aReg0145)
	aAdd (aReg0145[nPos], 1) 			//relao com o pai 0140
	aAdd (aReg0145[nPos], "0145" ) 		//01-REG
	aAdd (aReg0145[nPos], cIndic ) 		//02-COD_INC_TRIB
	aAdd (aReg0145[nPos], nTotPrev ) 	//03-VL_REC_TOT
	aAdd (aReg0145[nPos], nTotAt ) 		//04-VL_REC_ATIV
	aAdd (aReg0145[nPos], nDemais) 		//05-VL_REC_DEMAIS_ATIV
	aAdd (aReg0145[nPos], ""     ) 		//06-INFO_COMPL
Else
	aReg0145[1][4] 	:= nTotPrev + nTotal	//03-VL_REC_TOT
	aReg0145[1][5]	:= nTotAt				//04-VL_REC_ATIV
	aReg0145[1][6]	:= nDemais				//05-VL_REC_DEMAIS_ATIV

	If aReg0145[1][6] > 0 .AND. Empty(cCodIncT)//05-VL_REC_DEMAIS_ATIV
		aReg0145[1][3]	:= "2"				//02-COD_INC_TRIB
	EndIf

EndIf

Return

/*‘‹‘‹‘»±±
±±ºPrograma  |RegF200   ºAutor  Rodrigo Aguilar     º Data   13/04/2012 º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Processamento do registro F200                             º±±
±±ˆ¼±±
±±Parametros aF200Aux  -> Array com valores para gravao do registro   ±±
±±           				F200                                          ±±
±±           aRegF200  -> Array que deve ser alimentado para se gerar o ±±
±±           				registro F200                                 ±±
±±           aRegM210  -> Necessario para chamada da Funcao RegM210()   ±±
±±           aRegM610  -> Necessario para chamada da Funcao RegM610()   ±±
±±ˆ¼*/
Static Function RegF200(aF200Aux,aRegF200,aRegM210,aRegM610)

Local nY           := 0
Local lCumulativ   := .F.

Default aF200Aux := {}

If Len(aF200Aux) > 0

	aAdd(aRegF200, {})
	nPos := Len(aRegF200)

	For nY:=1 To Len(aF200Aux)-1
		aAdd (aRegF200[nPos], aF200Aux[nY])
	Next

	If aF200Aux[Len(aF200Aux)] == "0" //Regime Cumulativo
		lCumulativ := .T.
	EndIf

	RegM210(aRegM210,,,lCumulativ,,,.T.,,,,,,,,aRegF200[nPos])
	RegM610(aRegM610,,,lCumulativ,,,.T.,,,,,,,,aRegF200[nPos])

EndIf

Return

/*‘‹‘‹‘»±±
±±ºPrograma  |RegF205   ºAutor  Rodrigo Aguilar     º Data   13/04/2012 º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Processamento do registro F200                             º±±
±±ˆ¼±±
±±Parametros aF205Aux  -> Array com valores para gravao do registro   ±±
±±           				F205                                          ±±
±±           aRegF205  -> Array que deve ser alimentado para se gerar o ±±
±±           				registro F205                                 ±±
±±           aRegAuxM105 -> Necessario para chamada da Funcao AcumM105()±±
±±           aRegAuxM505 -> Necessario para chamada da Funcao AcumM505()±±
±±           aVlCrdImob  -> Acumula valores para geracao do M100/M500   ±±
±±           aReg0111    -> Necessario para chamada daS FuncesAcumM105()±±
±±           		          e AcumM505()						          ±±
±±ˆ*/
Static Function RegF205(aF205Aux,aRegF205,aRegAuxM105,aRegAuxM505,aVlCrdImob,aReg0111)

Local nY       := 0

Default aF205Aux := {}
Default aReg0111 := {}

If Len(aF205Aux) > 0

	aAdd(aRegF205, {})
	nPos := Len(aRegF205)

	For nY:=1 To Len(aF205Aux)
		aAdd (aRegF205[nPos], aF205Aux[nY])
	Next

	aVlCrdImob[1] += aRegF205[nPos][12]
	aVlCrdImob[2] += aRegF205[nPos][18]

	AcumM105(aRegAuxM105,,cRegime,,,aReg0111,.T.,,,,,,,,,aRegF205[nPos])
	AcumM505(aRegAuxM505,,cRegime,,,aReg0111,.T.,,,,,,,,,aRegF205[nPos])

EndIf

Return

/*‘‹‘‹‘»±±
±±ºPrograma  |RegF210   ºAutor  Rodrigo Aguilar     º Data   13/04/2012 º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Processamento do registro F200                             º±±
±±ˆ¼±±
±±Parametros aF210Aux  -> Array com valores para gravao do registro   ±±
±±           				F210                                          ±±
±±           aRegF210  -> Array que deve ser alimentado para se gerar o ±±
±±           				registro F210                                 ±±
±±           nPosF200    -> Referencia do arquivo F200 que esta sendo   ±±
±±           	              processado                                  ±±
±±           aRegAuxM105 -> Necessario para chamada da Funcao AcumM105()±±
±±           aRegAuxM505 -> Necessario para chamada da Funcao AcumM505()±±
±±           aVlCrdImob  -> Acumula valores para geracao do M100/M500   ±±
±±           aReg0111    -> Necessario para chamada daS FuncesAcumM105()±±
±±           		          e AcumM505()						          ±±
±±ˆ¼*/
Static Function RegF210(aF210Aux,aRegF210,nPosF200,aRegAuxM105,aRegAuxM505,aVlCrdImob,aReg0111)

Local nY := 0
Local nK := 0
Local nPost := 0
Local nPos := 0

Default aF210Aux := {}
Default aReg0111 := {}
Default nPosF200 := 1

nPost := aScan(aF210Aux,{|x| x[1] == nPosF200})

If Len(aF210Aux) > 0 .AND. nPost > 0

For nY:=nPost To Len(aF210Aux)
	If ValType(aF210Aux[nY])=="A" .AND. Len(aF210Aux[nY]) > 11 .AND. aF210Aux[nY][1] == nPosF200 .AND. aF210Aux[nY][2] == "F210"
		aAdd(aRegF210, {})
		nPos := Len(aRegF210)
		For nK:=1 To Len(aF210Aux[nY])
			aAdd (aRegF210[nPos], aF210Aux[nY][nK])
		Next
		aVlCrdImob[1] += aRegF210[nPos][9]
		aVlCrdImob[2] += aRegF210[nPos][12]
		AcumM105(aRegAuxM105,,cRegime,,,aReg0111,.T.,,,,,,,,,aRegF210[nPos])
		AcumM505(aRegAuxM505,,cRegime,,,aReg0111,.T.,,,,,,,,,aRegF210[nPos])
	EndIf
Next
EndIf

Return


 /*‘‹‘‹‘»±±
±±ºPrograma  GrvNFCan  ºAutor   Luccas Curcio      º Data   04/05/2012 º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Procura Notas Fiscais canceladas de periodos anteriores ao º±±
±±º           do processamento do SPED.                                  º±±
±±º           O conteudo gravado na tabela CF4 sera utilziado para gerar º±±
±±º           os ajustes nos registro M220 (PIS) e M620 (COFINS).        º±±
±±Œ˜¹±±
±±ºParametros dDataDe -> Data inicial                                    º±±
±±º           dDataAte -> Data final                                     º±±
±±º           lCumulativ -> Indicador de Cumulatividade.                 º±±
±±º           cRegime -> Tipo do Regime                                  º±±
±±º           cNrLivro -> Numero do Livro                                º±±
±±º           nMVM996TPR -> Conteudo do Parametro MV_M996TPR             º±±
±±º           lTop -> Indica se eh Top ou DBF                            º±±
±±Œ˜¹±±
±±ºRetorno    lRet->Indica se houve incluso ou alteracao na tabela CF4 eº±±
±±º                 consequentemente deve ser gerado um ajuste no bloco Mº±±
±±ˆ¼*/
Static function GrvNFCan(dDataDe,dDataAte,lCumulativ,cRegime,cNrLivro,nMVM996TPR,lTop)

Local	aParFil		:=	{}
Local	aAreaSD2	:=	{}
Local	aAreaSB1	:=	{}
Local	aAreaSF4	:=	{}
Local	aAreaSA1	:=	{}
Local	cAlsSFT		:=	"SFT"
Local 	cCdCtPis	:= 	""
Local 	cCdCtCof	:= 	""
Local 	cDtAlt		:= 	SubStr(DTos(dDataDe),5,2)+SubStr(Dtos(dDataDe),1,4)
Local	cChvSFT		:=	""
Local	lRet 		:=	.F.
Local	lAchouSFT	:=	.F.
LOcal 	lB1Tpreg		:= aFieldPos[22]
Local   dDtCanc		:=	Firstday(dDataDe)
Local   nX			:=	0
Local 	nQtdMesAnt	:=	aParSX6[43]
Local	dCorte		:= 	aParSX6[44]


//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//Verifica o conteudo do parametro MV_NMCSPC que indica a quantidade de meses anteriores  		
//ao do processamento que serao verificados para gerar os ajustes de notas fiscais canceladas.	
//O padrao do parametro sao 12 meses.		   													
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
For nX := 1 to nQtdMesAnt
	dDtCanc	:= Firstday(dDtCanc)-1
Next nX
dDtCanc	:= Firstday(dDtCanc)

//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
//Preenche o array aParFil que sera utilizado na montagem da query da tabela SFT, atraves da funcao SPEDFFiltro (SPEDXFUN) 
//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
aAdd(aParFil,DTOS(dDataDe))
aAdd(aParFil,DTOS(dDataAte))
aAdd(aParFil,DTOS(dDtCanc))
aAdd(aParFil,cRegime)
aAdd(aParFil,cNrLivro)
aAdd(aParFil,nMVM996TPR)
aAdd(aParFil,"S")

If (lAchouSFT	:=	SPEDFFiltro(1,"SFT2",@cAlsSFT,aParFil))

	Do While !(cAlsSFT)->(Eof ())

    	// No ser¡ mais necess¡rio realizar ajustes para o modelo 55 pois como o prazo
    	// para cancelamento © de apenas 24 horas aps a emisso, no havero notas canceladas de per­odos
    	// anteriores, apenas sendo poss­vel um cancelamento no dia 1º do mªs de uma nota emitida no ºltimo dia
    	// do mªs anterior, por©m a funo SPEDSITDOC foi alterada para no alterar a situao desse documento,
    	// assim a nota j¡ foi enviada como cancelada, no sendo necess¡rio gerar ajuste.
    	If Alltrim(AModNot((cAlsSFT)->FT_ESPECIE))=="55" .And. (cAlsSFT)->FT_DTCANC>=dCorte
    		(cAlsSFT)->(DbSkip())
    		Loop
    	EndIf

		cChvSFT	:=	(cAlsSFT)->(FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_ITEM)

        If cRegime == "3"
			//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
			//Se o ambiente nao for TOP, preciso posicionar as tabelas que indicam o tipo do regime.									
			//Para isso, devo verificar o parametro MV_M996TPR que mostra qual cadastro ira indicar o regime.							
			//Se for 1 devo olhar a TES, posiciono as tabelas SD2 e SF4 e caso esteja configurado 3-Ambos, posiciono o produto SB1.	
			//Se for 2 devo olhar diretamento no cadastro do produto. Se for 3, devo olhar o cadastro de cliente SA1.					
			//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
			If !lTop

				aAreaSD2	:=	SD2->(GetArea())
				aAreaSB1	:=	SB1->(GetArea())
				aAreaSF4	:=	SF4->(GetArea())
				aAreaSA1	:=	SA1->(GetArea())

				If nMVM996TPR == 1
					If SPEDSeek("SD2",3,xFilial("SD2")+(cAlsSFT)->(FT_NFISCAL+FT_SERIE+FT_CLIEFOR+FT_LOJA+FT_PRODUTO+FT_ITEM))
						If SPEDSeek("SF4",1,xFilial("SF4")+SD2->D2_TES)
							If SF4->F4_TPREG=="2"
								lCumulativ	:=	.T.
							ElseIf SF4->F4_TPREG=="1"
								lCumulativ	:=	.F.
							ElseIf SF4->F4_TPREG == "3"
								If SPEDSeek("SB1",1,xFilial("SB1")+(cAlsSFT)->FT_PRODUTO) .AND. lB1Tpreg
									If SB1->B1_TPREG=="2"
										lCumulativ	:=	.T.
									Elseif SB1->B1_TPREG=="1"
										lCumulativ	:=	.F.
									EndIf
								Endif
							EndIf
						Endif
					Endif

				Elseif nMVM996TPR == 2
					If SPEDSeek("SB1",1,xFilial("SB1")+(cAlsSFT)->FT_PRODUTO) .AND. lB1Tpreg
						If  SB1->B1_TPREG=="2"
							lCumulativ	:=	.T.
						ElseIf SB1->B1_TPREG=="1"
							lCumulativ	:=	.F.
						EndIf
					Endif

				Elseif nMVM996TPR == 3 .And. aFieldPos[12]
					If SPEDSeek("SA1",1,xFilial("SA1")+(cAlsSFT)->(FT_CLIEFOR+FT_LOJA))
						If SA1->A1_TPREG=="2"
							lCumulativ	:=	.T.
						Elseif SA1->A1_TPREG=="1"
							lCumulativ	:=	.F.
						EndIf
					Endif
				Endif
			//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
			//Se o ambiente for TOP, a verificacao no parametro MV_M996TPR ja foi feita no SPEDFFiltro(), e atraves do LEFT JOIN trouxe
			//os campos necessarios para saber a qual regime se trata a nota fiscal.						   							
			//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
			Else
				If nMVM996TPR == 1
					If ((cAlsSFT)->F4_TPREG=="2") .Or. ((cAlsSFT)->F4_TPREG=="3" .And. lB1Tpreg .AND. (cAlsSFT)->B1_TPREG=="2")
						lCumulativ	:=	.T.
					Elseif ((cAlsSFT)->F4_TPREG=="1") .Or. ((cAlsSFT)->F4_TPREG=="3" .And. lB1Tpreg .AND. (cAlsSFT)->B1_TPREG=="1")
				    	lCumulativ	:=	.F.
				 	Endif

				Elseif nMVM996TPR == 2 .AND. lB1Tpreg
					If (cAlsSFT)->B1_TPREG=="2"
						lCumulativ	:=	.T.
					Elseif (cAlsSFT)->B1_TPREG=="1"
						lCumulativ	:=	.F.
					Endif

				Elseif nMVM996TPR == 3 .And. aFieldPos[12]
					If (cAlsSFT)->A1_TPREG=="2"
						lCumulativ	:=	.T.
					Elseif (cAlsSFT)->A1_TPREG=="1"
						lCumulativ	:=	.F.
					Endif
				Endif
			Endif
		Else
			lCumulativ	:=	Iif(cRegime=="1",.F.,.T.)
		Endif

		dbSelectArea("CF4")
		dbSetOrder(1)

		If !CF4->(MsSeek(xFilial("CF4")+cChvSFT))

			cCdCtPis 			:= SPDCodCont("PIS",.F.,(cAlsSFT)->FT_CSTPIS,Iif((cAlsSFT)->FT_CSTPIS=="05",(cAlsSFT)->FT_ALIQPS3,(cAlsSFT)->FT_ALIQPIS),lCumulativ,,cRegime,,aParSX6[5])
			cCdCtCof 			:= SPDCodCont("COF",.F.,(cAlsSFT)->FT_CSTCOF,Iif((cAlsSFT)->FT_CSTCOF=="05",(cAlsSFT)->FT_ALIQCF3,(cAlsSFT)->FT_ALIQCOF),lCumulativ,,cRegime,,aParSX6[5])

			RecLock ("CF4", .T.)
			CF4->CF4_FILIAL		:= xFilial("CF4")
			CF4->CF4_NOTA 		:=(cAlsSFT)->FT_NFISCAL 									// 01- NOTA FISCAL
			CF4->CF4_SERIE 		:=(cAlsSFT)->FT_SERIE  										// 02- SERIE DA NOTA FISCAL
			CF4->CF4_ITEM 		:=(cAlsSFT)->FT_ITEM  										// 03- ITEM DA NOTA FISCAL
			CF4->CF4_CLIFOR 	:=(cAlsSFT)->FT_CLIEFOR  									// 04- CLIENTE OU FORNECEDOR
			CF4->CF4_LOJA 		:=(cAlsSFT)->FT_LOJA	  									// 05- LOJA
			CF4->CF4_TIPMOV 	:=(cAlsSFT)->FT_TIPOMOV  									// 06- TIPO DE MOVIMENTO
			CF4->CF4_VALPIS 	:=(cAlsSFT)->FT_VALPIS								  		// 07- VALOR DO PIS
			CF4->CF4_ALIPIS 	:=(cAlsSFT)->FT_ALIQPIS  									// 08- ALIQUOTA DO PIS
			CF4->CF4_BASPIS 	:=(cAlsSFT)->FT_BASEPIS  									// 09- BASE DE CALCULO DO PIS
			CF4->CF4_VALCOF 	:=(cAlsSFT)->FT_VALCOF - IiF(aFieldPos[16],(cAlsSFT)->FT_MVALCOF,0)		// 10- VALOR COFINS
			CF4->CF4_ALICOF 	:=(cAlsSFT)->FT_ALIQCOF - IiF(aFieldPos[15],(cAlsSFT)->FT_MALQCOF,0)	// 11- ALIQUOTA COFINS
			CF4->CF4_BASCOF 	:=(cAlsSFT)->FT_BASECOF  									// 12- BASE COFINS
			CF4->CF4_DATAE 		:=(cAlsSFT)->FT_ENTRADA  									// 13- DATA DE ENTRADA
			CF4->CF4_CFOP 		:=(cAlsSFT)->FT_CFOP	  									// 14- CFOP DA NOTA FISCAL
			CF4->CF4_CSTPIS 	:=(cAlsSFT)->FT_CSTPIS  									// 15- SIT. TRIBUTARIA PIS
			CF4->CF4_CSTCOF 	:=(cAlsSFT)->FT_CSTCOF 							 			// 16- SIT. TRIBUTARIA COFINS
			CF4->CF4_CONPIS 	:= cCdCtPis													// 17- COD. CONTRIBUICAO PIS
			CF4->CF4_CONCOF 	:= cCdCtCof													// 18- COD. CONTRIBUICAO COFINS
			CF4->CF4_PATPIS 	:=Iif((cAlsSFT)->FT_PAUTPIS==0,0,(cAlsSFT)->FT_PAUTPIS) 	// 19- VALOR PAUTA PIS
			CF4->CF4_PATCOF 	:=Iif((cAlsSFT)->FT_PAUTCOF==0,0,(cAlsSFT)->FT_PAUTCOF)	// 20- VALOR PAUTA COFINS
			CF4->CF4_ORIPIS		:=(cAlsSFT)->FT_VALPIS 										// 21- VALOR DO PIS ORIGINAL
			CF4->CF4_ORICOF		:=(cAlsSFT)->FT_VALCOF 										// 22- VALOR DO PIS ORIGINAL
			CF4->CF4_DTALT 		:= cDtAlt
			MsUnLock ()
			lRet := .T.
		Else
			RecLock ("CF4", .F.)
			CF4->CF4_VALPIS		:=(cAlsSFT)->FT_VALPIS 										// 01- VALOR DO PIS
			CF4->CF4_ORIPIS		:=(cAlsSFT)->FT_VALPIS 										// 02- VALOR DO PIS ORIGINAL
			CF4->CF4_VALCOF		:=(cAlsSFT)->FT_VALCOF										// 03- VALOR COFINS
			CF4->CF4_ORICOF		:=(cAlsSFT)->FT_VALCOF 										// 04- VALOR DO PIS ORIGINAL
			CF4->CF4_DTALT		:= cDtAlt
			MsUnLock ()
			lRet := .T.
		EndIf
		(cAlsSFT)->(DbSkip ())
	Enddo
	If !lTop .AND. cRegime == "3"
		RestArea(aAreaSD2)
		RestArea(aAreaSB1)
		RestArea(aAreaSF4)
		RestArea(aAreaSA1)
	Endif
Endif

//š„„„„„„„„„„„„„„„„„„„„¿
//Fecho a query da SFT
//€„„„„„„„„„„„„„„„„„„„„™
If lAchouSFT
	SPEDFFiltro(2,,cAlsSFT)
EndIf

DbSelectArea("CF4")
CF4->(DbCloseArea ())

Return(lRet)
static Function TeleComFut(dDataDe,dDataAte,aRegD600,aRegD601,aRegD605,aReg0500,aRegM210,aRegM610,aWizard,aRegM400,aRegM410,;
							aRegM800,aRegM810,lGeraD600,cRegime,lExtTaf)

Local cSlct			:= ""
Local cSlctSD2		:= ""
Local cSlctSF2		:= ""
Local cSlctSF4		:= ""
Local cSlctSFX		:= ""
Local cJoinSD2		:= ""
Local cJoinSF4		:= ""
Local cJoin			:= ""
Local cEspecie		:= ""
Local cFiltro		:= ""
Local cAliasSD2		:= "SD2"
Local cAliasSF2		:= "SF2"
Local cAliasSF4		:= "SF4"
Local cAliasSFX		:= "SFX"
Local cAliasSB1		:= "SB1"
Local nPosD600		:= 0
Local aFieldDt		:= {}
Local aPartDoc		:= {}
Local lAchouSFX	:= .F.
LOcal lB1Tpreg		:= aFieldPos[22]
Local cAliasSA1	:= "SA1"
Local lCumulativ	:= .F.
Local aReg0111		:= {0,0,0,0}
Local cCfoTele		:= aParSX6[45]

DEFAULT lGeraD600	:= .F.
Default lExtTAF     := .F.

#IFDEF TOP
	If TcSrvType() <> "AS/400"
		lTop 	:= .T.
	Endif
#ENDIF

DbSelectArea (cAliasSD2)
(cAliasSD2)->(DbSetOrder (3))
#IFDEF TOP
    If (TcSrvType ()<>"AS/400")

		//Campos da tabela SF2
		cSlctSF2:= "SF2.F2_ESPECIE,		SF2.F2_SERIE,		SF2.F2_TIPO, 		SF2.F2_CLIENTE,		SF2.F2_LOJA "

		If lB1Tpreg
			cSlctSF2+= ", 	SB1.B1_TPREG "
		EndIF

		//Campos da tabela SD2
		cSlctSD2 := ",SD2.D2_CONTA,		SD2.D2_SERIE,		SD2.D2_VALIMP5,		SD2.D2_BASIMP5 ,	SD2.D2_ALQIMP5,		"
		cSlctSD2 +=	"SD2.D2_VALIMP6,	SD2.D2_BASIMP6,		SD2.D2_ALQIMP6,		SD2.D2_DTFIMNT,		SD2.D2_DESC,		"
		cSlctSD2 +=	"SD2.D2_TNATREC,	SD2.D2_CNATREC,		SD2.D2_GRUPONC,		SD2.D2_TOTAL,		SD2.D2_DESPESA,		"
		cSlctSD2 +=	"SD2.D2_SEGURO,		SD2.D2_BASEICM,		SD2.D2_VALICM,		SD2.D2_CLIENTE,		SD2.D2_LOJA,	SD2.D2_CF"

    	//Campos da TES
    	cSlctSf4:= ",SF4.F4_CSTPIS, 	SF4.F4_CSTCOF, 		SF4.F4_TPREG "

		//Campos do complemento de telecomunicacao
		cSlctSFX:= ",SFX.FX_TIPOREC, 	SFX.FX_VALTERC,		SFX.FX_GRPCLAS,		SFX.FX_GRPCLAS,		SFX.FX_CLASSIF "

		//Join com SD2, SF4 e SFX
		cJoinSD2	:=	"LEFT JOIN "+RetSqlName("SD2")+" SD2 ON(SD2.D2_FILIAL='"+xFilial("SD2")+"' AND SD2.D2_DOC=SF2.F2_DOC AND SD2.D2_SERIE=SF2.F2_SERIE AND SD2.D2_CLIENTE=SF2.F2_CLIENTE AND SD2.D2_LOJA=SF2.F2_LOJA AND  SD2.D_E_L_E_T_=' ') "
		cJoinSF4	:=	"LEFT JOIN "+RetSqlName("SF4")+" SF4 ON(SF4.F4_FILIAL='"+xFilial("SF4")+"' AND SF4.F4_CODIGO=SD2.D2_TES AND SF4.D_E_L_E_T_=' ') "
		cJoinSFX	:=	"LEFT JOIN "+RetSqlName("SFX")+" SFX ON(SFX.FX_FILIAL='"+xFilial("SFX")+"' AND SFX.FX_TIPOMOV = 'S' AND SFX.FX_SERIE = SD2.D2_SERIE AND SFX.FX_DOC = SD2.D2_DOC AND SFX.FX_CLIFOR = SD2.D2_CLIENTE AND SFX.FX_LOJA = SD2.D2_LOJA AND SFX.FX_ITEM = SD2.D2_ITEM  AND SFX.D_E_L_E_T_=' ') "

		cJoin	:=  cJoinSD2 + cJoinSF4 + cJoinSFX
		cJoin := "%" + cJoin + "%"

		cSlct := cSlctSF2+cSlctSD2+cSlctSf4+cSlctSFX

		cSlct := "%" + cSlct + "%"

		cFiltro 	:= "%"
		cFiltro		+= "(SF2.F2_ESPECIE = 'NFSC' OR SF2.F2_ESPECIE = 'NTSC' or SF2.F2_ESPECIE = 'NTST') AND SFX.FX_TIPOREC = '6' AND "
		cFiltro		+= "SF4.F4_LFICM = 'N' and  SF4.F4_LFIPI = 'N' and  SF4.F4_ISS = 'N'"
		cFiltro 	+= "%"

    	aAdd(aFieldDt,"D2_DTFIMNT")
    	aAdd(aFieldDt,"D2_ENTRADA")

    	cAliasSF2	:=	GetNextAlias()

    	BeginSql Alias cAliasSF2

			SELECT
				%Exp:cSlct%
			FROM
				%Table:SF2% SF2
				%Exp:cJoin%
				LEFT JOIN %Table:SB1% SB1 ON(SB1.B1_FILIAL=%xFilial:SB1%  AND SB1.B1_COD=SD2.D2_COD AND SB1.%NotDel%)
			WHERE

				SF2.F2_FILIAL=%xFilial:SF2% AND
				SF2.F2_EMISSAO>=%Exp:DToS (dDataDe)% AND
				SF2.F2_EMISSAO<=%Exp:DToS (dDataAte)% AND
				%Exp:cFiltro% AND
				SF2.%NotDel%
		EndSql
	Else
#ENDIF
   	    cIndex	:= CriaTrab(NIL,.F.)
	    cFiltro	:= 'F2_FILIAL=="'+xFilial ("SF2")+'".And.'
	    cFiltro += 'DToS (F2_EMISSAO)>="'+DToS (dDataDe)+'".And.DToS (F2_EMISSAO)<="'+DToS (dDataAte)+'" '
	    cFiltro += '.AND. (F2_ESPECIE = "NFSC" .OR. F2_ESPECIE = "NTSC" .OR. F2_ESPECIE = "NTST")'
	    IndRegua (cAliasSF2, cIndex, SF2->(IndexKey ()),, cFiltro)
	    nIndex := RetIndex(cAliasSF2)

		#IFNDEF TOP
			DbSetIndex (cIndex+OrdBagExt ())
		#ENDIF

		DbSelectArea (cAliasSF2)
	    DbSetOrder (nIndex+1)
#IFDEF TOP
	Endif
#ENDIF

IF lTop
	cAliasSD2	:= cAliasSF2
	cAliasSF4	:= cAliasSF2
	cAliasSFX	:= cAliasSF2
	cAliasSB1	:= cAliasSF2
EndIF

DbSelectArea (cAliasSF2)
(cAliasSF2)->(DbGoTop ())
ProcRegua ((cAliasSF2)->(RecCount ()))
Do While !(cAliasSF2)->(Eof ())
	cEspecie	:=	AModNot ((cAliasSF2)->F2_ESPECIE)
	IF lTop
		If AllTrim((cAliasSD2)->D2_CF) $ cCfoTele

			(cAliasSA1)->(MsSeek (xFilial ("SA1")+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA))
			aPartDoc	:=	InfPartDoc (cAliasSA1, {},.F.,dDataDe, dDataAte)

			If cRegime == "1" //Nao cumulativo
				lCumulativ := .F.
			ElseIf cRegime == "2"  //Cumulativo
				lCumulativ := .T.
			ElseIf cRegime == "3" //Cumulativo e no cumulativo
				lCumulativ	:= Iif(SPEDRegime(cRegime,cAliasSF4,caliasSB1,cAliasSA1)=="C",.T.,.F.)
			EndIF

			If lGeraD600
				RegD600(@aRegD600,@aRegD601,@aRegD605,@aReg0500,,dDataDe,dDataAte,cEspecie,,aPartDoc,;
						@nPosD600,@aRegM210,@aRegM610,aWizard,@aRegM400,@aRegM410,@aRegM800,@aRegM810,,,;
						lCumulativ,,,,,,,,,.F.,cAliasSD2,cAliasSF4,cAliasSFX)
			Else
				If !lExtTAF
					IF lCumulativ
						aReg0111[4]	+= (cAliasSD2)->D2_TOTAL
					ElseIf Substr((cAliasSD2)->D2_LOJA,1,1) == "7"
						aReg0111[3]	+= (cAliasSD2)->D2_TOTAL
					ElseIf (cAliasSF4)->F4_CSTPIS $ "01/02" .OR. (cAliasSF4)->F4_CSTCOF $ "01/02"
						aReg0111[1]	+= (cAliasSD2)->D2_TOTAL
					Else
						aReg0111[2]	+= (cAliasSD2)->D2_TOTAL
					EndIF
				Else
					//Para o TAF devem ser levadas todas as informacoes independente do regime adotado                                             
					aReg0111[1]	+= (cAliasSD2)->D2_TOTAL
					aReg0111[2]	+= (cAliasSD2)->D2_TOTAL
					aReg0111[3]	+= (cAliasSD2)->D2_TOTAL
					aReg0111[4]	+= (cAliasSD2)->D2_TOTAL
				EndIf
			EndIF
		EndIF
	Else

		//Preciso fazer seek para encontrar SD2, SF4, SA1 e SFX Chave para percorrer os itens da mesma nota
		cChaveD2		:=	xFilial("SD2")+(cAliasSF2)->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)
		IF (cAliasSD2)->(MsSeek (cChaveD2))
			While !(cAliasSD2)->(Eof()) .And. cChaveD2 == 	xFilial("SD2")+(cAliasSD2)->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) .AND. AllTrim((cAliasSD2)->D2_CF) $ cCfoTele
				lAchouSFX	:= .F.
				lAchouSF4	:= .F.
				lAchouSFX:=	(cAliasSFX)->(MsSeek (xFilial ("SFX")+ "S"+(cAliasSD2)->D2_SERIE+(cAliasSD2)->D2_DOC+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA+PadR((cAliasSD2)->D2_ITEM,TamSx3("FX_ITEM")[1])+(cAliasSD2)->D2_COD))
				IF lAchouSFX
					lAchouSF4:= (cAliasSF4)->(MsSeek (xFilial ("SF4")+ (cAliasSD2)->D2_TES))
					SPEDSeek("SB1",,xFilial("SB1")+(cAliasSD2)->D2_COD)
					IF lAchouSF4
						(cAliasSA1)->(MsSeek (xFilial (cAliasSA1)+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA))
						aPartDoc	:=	InfPartDoc (cAliasSA1, {},.F.,dDataDe, dDataAte)
						If (cAliasSFX)->FX_TIPOREC == "6" .AND.  (cAliasSF4)->F4_LFICM = "N" .AND.(cAliasSF4)->F4_LFIPI = "N" .AND. (cAliasSF4)->F4_ISS = "N"

							If cRegime == "1" //Nao cumulativo
								lCumulativ := .F.
							ElseIf cRegime == "2"  //Cumulativo
								lCumulativ := .T.
							ElseIf cRegime == "3" //Cumulativo e no cumulativo
								lCumulativ	:= Iif(SPEDRegime(cRegime,cAliasSF4,caliasSB1,cAliasSA1)=="C",.T.,.F.)
							EndIF

							IF lGeraD600
								RegD600(@aRegD600,@aRegD601,@aRegD605,@aReg0500,,dDataDe,dDataAte,cEspecie,,aPartDoc,;
										@nPosD600,@aRegM210,@aRegM610,aWizard,@aRegM400,@aRegM410,@aRegM800,@aRegM810,,,;
										lCumulativ,,,,,,,,,.F.,cAliasSD2,cAliasSF4,cAliasSFX)
							Else
								IF lCumulativ
									aReg0111[4]	+= (cAliasSD2)->D2_TOTAL
								ElseIf Substr((cAliasSD2)->D2_LOJA,1,1) == "7"
									aReg0111[3]	+= (cAliasSD2)->D2_TOTAL
								ElseIf (cAliasSF4)->F4_CSTPIS $ "01/02" .OR. (cAliasSF4)->F4_CSTCOF $ "01/02"
									aReg0111[1]	+= (cAliasSD2)->D2_TOTAL
								Else
									aReg0111[2]	+= (cAliasSD2)->D2_TOTAL
								EndIF
							EndIF
						EndIF
					EndiF

				EndIF
				(cAliasSD2)->(dbSkip())
			End
		EndIF
	EndIF

	(cAliasSF2)->(dbSkip())
EndDo
#IFDEF TOP
	If (TcSrvType ()<>"AS/400")
		DbSelectArea (cAliasSF2)
		(cAliasSF2)->(DbCloseArea ())
	Else
#ENDIF
		RetIndex("SF2")
#IFDEF TOP
	EndIf
#ENDIF
Return (aReg0111)


/*‘‹‘‹‘»±±
±±ºPrograma  RegF500   ºAutor  Erick G. Dias       º Data   19/06/2012 º±±
±±ºDesc.     Funo para gerao do registro F500.                		  º±±
±±Œ˜¹±±
±±ºParametros aRegF500 -> Array com valores do registro F500             º±±
±±º           aValor   -> Array com os valores para que seja gerado      º±±
±±º                       registro F510                                  º±±
±±º           nPosRetorn -> Array com o totalizador das receitas.        º±±
±±ˆ¼*/
Static Function RegF500 (aRegF500,aValor,nPosRetorn)

Local nPos			:= 0
Local nPosF500		:= 0
Local aParF525		:= {}

nPosF500 := aScan (aRegF500, {|aX| aX[3]==aValor[3] .AND. aX[6]==aValor[6] .AND. aX[8]==aValor[8] .AND. ;
								    aX[11]==aValor[11].AND. aX[13]==aValor[13] .AND. aX[14]==aValor[14] .AND.;
								    aX[15]==aValor[15] .AND. aX[16]==aValor[16]})

//Se no existir ainda registro F500 com combinao de CST de PIS/COFINS, 
//Al­quota de PIS/COFINS,Cdigo do Modelo, CFOP Conta COnt¡bil e          
// Informao complementar insere novo F500, se no acumula valores.      

If nPosF500 == 0
	aAdd(aRegF500, {})
	nPos := Len(aRegF500)
	aAdd (aRegF500[nPos], aValor[1])		//01-Registro
	aAdd (aRegF500[nPos], aValor[2])   		//02-VL_REC_CAIXA
	aAdd (aRegF500[nPos], aValor[3])   		//03-CST_PIS
	aAdd (aRegF500[nPos], aValor[4])   		//04-VL_DESC_PIS
	aAdd (aRegF500[nPos], aValor[5])   		//05-VL_BC_PIS
	aAdd (aRegF500[nPos], aValor[6])   		//06-ALIQ_PIS
	aAdd (aRegF500[nPos], aValor[7])   		//07-VL_PIS
	aAdd (aRegF500[nPos], aValor[8])   		//08-CST_COFINS
	aAdd (aRegF500[nPos], aValor[9])   		//09-VL_DESC_COFINS
	aAdd (aRegF500[nPos], aValor[10])  		//10-VL_BC_COFINS
	aAdd (aRegF500[nPos], aValor[11])  		//11-ALIQ_COFINS
	aAdd (aRegF500[nPos], aValor[12])  		//12-VL_COFINS
	aAdd (aRegF500[nPos], aValor[13])  		//13-COD_MOD
	aAdd (aRegF500[nPos], aValor[14]) 		//14-CFOP
	aAdd (aRegF500[nPos], aValor[15])  		//15-COD_CTA
	aAdd (aRegF500[nPos], aValor[16])  		//16-INF_COMPL
	nPosRetorn	:= nPos
Else
	aRegF500[nPosF500][2]	+=	aValor[2]	//02-VL_REC_CAIXA
	aRegF500[nPosF500][4]	+=	aValor[4]	//04-VL_DESC_PIS
	aRegF500[nPosF500][5]	+=	aValor[5]	//05-VL_BC_PIS
	aRegF500[nPosF500][7]	+=	aValor[7]	//07-VL_PIS
	aRegF500[nPosF500][9]	+=	aValor[9] 	//09-VL_DESC_COFINS
	aRegF500[nPosF500][10]	+=	aValor[10]	//10-VL_BC_COFINS
	aRegF500[nPosF500][12]	+=	aValor[12]	//12-VL_COFINS
	nPosRetorn	:= nPosF500
EndIf
Return

/*‘‹‘‹‘»±±
±±ºPrograma  RegF510    ºAutor  Erick G. Dias       º Data   19/06/2012 º±±
±±ºDesc.     Funo para gerao do registro F510.                		  º±±
±±Œ˜¹±±
±±ºParametros aRegF510 -> Array com valores do registro F510             º±±
±±º           aValor   -> Array com os valores para que seja gerado      º±±
±±º                       registro F510                                  º±±
±±º           nPosRetorn -> Array com o totalizador das receitas.          º±±
±±ˆ¼*/
Static Function RegF510 (aRegF510,aValor,nPosRetorn)

Local nPos			:= 0
Local nPosF510		:= 0


nPosF510 := aScan (aRegF510, {|aX| aX[3]==aValor[3] .AND. aX[6]==aValor[6] .AND. aX[8]==aValor[8] .AND. ;
								    aX[11]==aValor[11].AND. aX[13]==aValor[13] .AND. aX[14]==aValor[14] .AND.;
								    aX[15]==aValor[15] .AND. aX[16]==aValor[16]})

If nPosF510 == 0
	aAdd(aRegF510, {})
	nPos := Len(aRegF510)
	aAdd (aRegF510[nPos], aValor[1])		//01-Registro
	aAdd (aRegF510[nPos], aValor[2])   		//02-VL_REC_CAIXA
	aAdd (aRegF510[nPos], aValor[3])   		//03-CST_PIS
	aAdd (aRegF510[nPos], aValor[4])   		//04-VL_DESC_PIS
	aAdd (aRegF510[nPos], aValor[5])   		//05-VL_BC_PIS
	aAdd (aRegF510[nPos], aValor[6])   		//06-ALIQ_PIS
	aAdd (aRegF510[nPos], aValor[7])   		//07-VL_PIS
	aAdd (aRegF510[nPos], aValor[8])   		//08-CST_COFINS
	aAdd (aRegF510[nPos], aValor[9])   		//09-VL_DESC_COFINS
	aAdd (aRegF510[nPos], aValor[10])  		//10-VL_BC_COFINS
	aAdd (aRegF510[nPos], aValor[11])  		//11-ALIQ_COFINS
	aAdd (aRegF510[nPos], aValor[12])  		//12-VL_COFINS
	aAdd (aRegF510[nPos], aValor[13])  		//13-COD_MOD
	aAdd (aRegF510[nPos], aValor[14]) 		//14-CFOP
	aAdd (aRegF510[nPos], aValor[15])  		//15-COD_CTA
	aAdd (aRegF510[nPos], aValor[16])  		//16-INF_COMPL
	nPosRetorn := nPos
Else
	aRegF510[nPosF510][2]	+=	aValor[2]	//02-VL_REC_CAIXA
	aRegF510[nPosF510][4]	+=	aValor[4]	//04-VL_DESC_PIS
	aRegF510[nPosF510][5]	+=	aValor[5]	//05-VL_BC_PIS
	aRegF510[nPosF510][7]	+=	aValor[7]	//07-VL_PIS
	aRegF510[nPosF510][9]	+=	aValor[9] 	//09-VL_DESC_COFINS
	aRegF510[nPosF510][10]	+=	aValor[10]	//10-VL_BC_COFINS
	aRegF510[nPosF510][12]	+=	aValor[12]	//12-VL_COFINS
	nPosRetorn := nPosF510
EndIf
Return

/*‘‹‘‹‘»±±
±±ºPrograma  RegF525   ºAutor  Erick G. Dias       º Data   19/06/2012 º±±
±±ºDesc.     Funo para gerao do registro F525.                		  º±±
±±Œ˜¹±±
±±ºParametros aRegF525 -> Array com valores do registro F525             º±±
±±º           aValor   -> Array com os valores para que seja gerado      º±±
±±º                       registro F525                                  º±±
±±º           aTotRec ->  Array com o totalizador das receitas.          º±±
±±ˆ¼*/
Static Function RegF525 (aRegF525,aValor, aTotRec)

Local nPos			:= 0
Local nPosF525		:= 0

//Totaliza a Receita conforme o indicador de composio da receita
Do Case
	Case aValor[3] == "01" //CNPJ do cliente
		aTotRec[1]	+=	aValor[2]

	Case aValor[3] == "03" 	//Numero do titulo/duplicata
		aTotRec[3]	+=	aValor[2]

	Case aValor[3] == "04" //Numero do documento fiscal
		aTotRec[4]	+=	aValor[2]

	Case aValor[3] == "05" //Produto/Servico
		aTotRec[5]	+=	aValor[2]

	Case aValor[3] == "99" //Juros de aplicao Financeira
		aTotRec[7]	+=	aValor[2]
EndCase

nPosF525 := aScan (aRegF525, {|aX| aX[3]==aValor[3] .AND. aX[4]==aValor[4] .AND. aX[5]==aValor[5] .AND. ;
								    aX[6]==aValor[6].AND. aX[8]==aValor[8] .AND. aX[9]==aValor[9] .AND.;
								    aX[10]==aValor[10] .AND. aX[11]==aValor[11]})

If nPosF525 == 0

	aAdd(aRegF525, {})
	nPos := Len(aRegF525)
	aAdd (aRegF525[nPos], aValor[1])		//01-Registro
	aAdd (aRegF525[nPos], 0)		   		//02-VL_REC
	aAdd (aRegF525[nPos], aValor[3])   		//03-IND_REC
	aAdd (aRegF525[nPos], aValor[4])   		//04-CNPJ_CPF
	aAdd (aRegF525[nPos], aValor[5])   		//05-NUM_DOC
	aAdd (aRegF525[nPos], aValor[6])   		//06-COD_ITEM
	aAdd (aRegF525[nPos], aValor[7])   		//07-VL_REC_DET
	aAdd (aRegF525[nPos], aValor[8])   		//08-CST_PIS
	aAdd (aRegF525[nPos], aValor[9])   		//09-CST_COFINS
	aAdd (aRegF525[nPos], aValor[10])  		//10-INFO_COMPL
	aAdd (aRegF525[nPos], aValor[11])  		//11-COD_CTA
Else
	aRegF525[nPosF525][7]	+=	aValor[7]	//07-VL_REC_DET
EndIf
Return

/*‘‹‘‹‘»±±
±±ºPrograma  RegimeCaixºAutor  Erick G. Dias       º Data   19/06/2012 º±±
±±ºDesc.     Funo para gerao dos valores de PIS e COFINS para 		  º±±
±±º          contribuinte enquadrado como Lucro Presumido optante pela   º±±
±±º          apurao de Regime de Caixa. Para esta gerao no SPED	  º±±
±±º          ser¡ baseado nos retornos de recebimentos do per­odo  	  º±±
±±º          retornado pelo Financeiro.                            	  º±±
±±Œ˜¹±±
±±ºParametros cAliasF500 -> Alias do retorno do financeiro - baixas      º±±
±±º           aRegF500 -> Array com valores do registro F500             º±±
±±º           aRegF510 -> Array com valores do registro F510             º±±
±±º           aRegF525 -> Array com valores do registro F525             º±±
±±º           aReg0500 -> Array com valores do registro 0500             º±±
±±º           aTotF525 -> Array com valores do registro F525             º±±
±±º           aRegM400 -> Array com valores do registro M400             º±±
±±º           aRegM410 -> Array com valores do registro M410             º±±
±±º           aRegM800 -> Array com valores do registro M800             º±±
±±º           aRegM810 -> Array com valores do registro M810             º±±
±±º           cIndCompRe -> Indicador da composio da receita           º±±
±±º           lTop -> Indica se base © TOP                               º±±
±±º           cAlias -> Alias do arquivo de trabalho do arquivo magn©ticoº±±
±±º           aReg0200 -> Array com valores do registro 0200             º±±
±±º           aReg0190 -> Array com valores do registro 0190             º±±
±±º           dDataDe -> Data inicial do per­odo de gerao do arquivo   º±±
±±º           dDataAte -> Data final do per­odo de gerao do arquivo    º±±
±±º           nRelacFil -> Relao com a filial processada               º±±
±±º           aReg0205 -> Array com valores do registro 0205             º±±
±±º           aRegF509 -> Array com valores do registro F509             º±±
±±º           aRegF519 -> Array com valores do registro F519             º±±
±±º           aReg1010 -> Array com valores do registro 1010             º±±
±±º           aReg1020 -> Array com valores do registro 1020             º±±
±±ˆ¼*/
Static Function RegimeCaix(cAliasF500,aRegF500,aRegF510,aRegF525,aReg0500,aTotF525,;
							aRegM400,aRegM410,aRegM800,aRegM810,cIndCompRe,lTop,cAlias,;
							aReg0200,aReg0190,dDataDe,dDataAte,nRelacFil,aReg0205,aRegF509,;
							aRegF519,aReg1010,aReg1020)

Local aParF500		:=	{}
Local aParFil		:=	{}
Local aParNaoTri	:=	{}
Local aBaseAlqUn	:=	{}
Local aParF525		:=	{}
Local aParCDG		:=	{}
Local aProd			:=  {}

Local lPauta		:=	.F.
Local lAchouCCF		:=	.F.
Local lAchouSA1		:=	.F.
Local lAchouSB1		:=	.F.
Local lAchouSF2		:=	.F.
Local cAliasSF2		:=	"SF2"
Local lAchouCDG		:=	.F.
Local lGera10xx		:=	.F.
Local lProcFin		:= (cAliasF500)->(FieldPos("NUMPRO")) > 0 .AND.(cAliasF500)->(FieldPos("INDPRO")) > 0
Local lCmpVrDes		:=	(cAliasF500)->(FieldPos("VRDESCON")) > 0

Local cAliasSFT		:=	"SFT"
Local cAliasSA1		:=	"SA1"
Local cAliasSB1		:=	"SB1"
Local cAliasCDG		:=	"CDG"
Local cAliasCCF		:=	"CDG"
Local cCnpj			:=	""
Local cDocFiscal	:=	""
Local cProduto		:=	""
Local cInfCompl		:= ""

Local nPerReceb		:=	0
Local nPosF500		:=	0
Local nPosF510		:=	0
Local nBasePIS		:=	0
Local nBaseCOF		:=	0
Local nAlqPIS		:=	0
Local nAlqCOF		:=	0
Local nPos			:= 0
Local nVlDescBC	:= 0

IF !(cAliasF500)->ORIFIN
	//Se (cAliasF500)->ORIFIN igual a .F. indica que o titulo possui vinculo com documento fiscal
	aParFil	:=	{}
	aAdd(aParFil,(cAliasF500)->EMISSAO)
	aAdd(aParFil,(cAliasF500)->SERIE)
	aAdd(aParFil,(cAliasF500)->NUMERO)
	aAdd(aParFil,(cAliasF500)->CLIENTE)
	aAdd(aParFil,(cAliasF500)->LOJA)
	aAdd(aParFil,cNrLivro)
	aAdd(aParFil,cIndCompRe)

	//Considera o percentual de baixa enviado pelo financeiro
	nPerReceb	:= (cAliasF500)->PERC / 100
    IF nPerReceb > 0 
		//Ir¡ buscar os itens da nota fiscal referente a baixa que o Financeiro enviou
		If SPEDFFiltro(1,"SFT3",@cAliasSFT,aParFil)

			Do While !(cAliasSFT)->( EOF())

				If lTop
					cAliasSA1	:= 	cAliasSFT
					cAliasSB1	:= 	cAliasSFT
					cAliasSF2	:= 	cAliasSFT
					lAchouSA1	:=	.T.
					lAchouSB1	:=	.T.
					lAchouSF2	:= .T.
				ElseIF cIndCompRe == "01"
					lAchouSA1 	:= SPEDSeek("SA1",1,xFilial("SA1")+(cAliasSFT)->(FT_CLIEFOR+FT_LOJA))
				ElseIF cIndCompRe == "05"
					lAchouSB1 	:= SPEDSeek("SB1",1,xFilial("SB1")+(cAliasSFT)->FT_PRODUTO)
				EndIF

				If !lTop
					lAchouSF2:=SPEDSeek("SF2",1,xFilial ("SF2")+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA)
				EndIF

				aParF500   		:=	{"",0,"",0,0,0,0,0,0,0,0,0,"","","",""}
				aParF500[1]		:=	"F500"
				lPauta			:=	.F.
				nBasePIS		:=	0
				nBaseCOF		:=	0
				nAlqPIS			:=	0
				nAlqCOF			:=	0
				nQtdDev			:=  0

				If lAchouSF2
					nPerReceb	:=  (cAliasF500)->VALOR /(cAliasSF2)->F2_VALBRUT
				EndIF

				//Verifica se operao © com pauta de PIS e COFINS
				If (cAliasSFT)->FT_PAUTPIS > 0 .OR. (cAliasSFT)->FT_PAUTCOF > 0
					lPauta 		:= .T.
					aParF500[1]	:= "F510"
				EndIF

				IF lPauta
					aBaseAlqUn	:= {}
					//Ir¡ converter al­quota em unidade de medida conforme cdigo da tabela 4.3.11 informado
					//E ir¡ preencher as variaveis com valores da al­quota em unidade de medida             
					aBaseAlqUn	:=	VlrPauta(lCmpNRecFT, lCmpNRecB1, "PIS",cAliasSFT,cAliasSB1,.F.,.F.)
					nAlqPIS 	:= 	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][1] , (cAliasSFT)->FT_PAUTPIS)
					nBasePIS  	:= 	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][2] , (cAliasSFT)->FT_QUANT)

					aBaseAlqUn	:=	VlrPauta(lCmpNRecFT, lCmpNRecB1, "COF",cAliasSFT,cAliasSB1,.F.,.F.)
					nAlqCOF 	:= 	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][1] , (cAliasSFT)->FT_PAUTCOF)
					nBaseCOF  	:= 	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][2] , (cAliasSFT)->FT_QUANT)
				Else
					//Preenche as variaveis com valores de al­quota em percentual
					nBasePIS	:= (cAliasSFT)->FT_BASEPIS
					nBaseCOF	:= (cAliasSFT)->FT_BASECOF
					nAlqPIS		:= (cAliasSFT)->FT_ALIQPIS
					nAlqCOF		:= (cAliasSFT)->FT_ALIQCOF
				EndIF

				//VALOR DE DESCONTO DA BASE DE PIS
				nVlDescBC := Iif(lCmpVrDes, (cAliasF500)->VRDESCON, 0)  

    			//Monta array gen©rico para gerar registro F500 ou F510
				aParF500[2]	:=	(cAliasSFT)->FT_VALCONT * nPerReceb//VALOR RECEBIDO
				aParF500[3]	:=	(cAliasSFT)->FT_CSTPIS                 		//CST DE PIS
				aParF500[4]	:=	nVlDescBC + ((cAliasSFT)->FT_VALIPI * nPerReceb) //Valor do desconto / excluso da base de c¡lculo
				aParF500[5]	:=	(nBasePIS * nPerReceb) - nVlDescBC //BASE DE PIS PELO PERCENTUAL RECEBIDO
				aParF500[6]	:=	nAlqPIS 				               		//ALQUOTA DE PIS
				aParF500[7]	:=	0											//VALOR DE PIS  ////Round(aParF500[5] * aParF500[6] /100,2)
				aParF500[8]	:=	(cAliasSFT)->FT_CSTCOF                 		//CST DA CONFINS
				aParF500[9]	:= nVlDescBC + ((cAliasSFT)->FT_VALIPI * nPerReceb) //Valor do desconto / excluso da base de c¡lculo	
				aParF500[10]	:=	(nBaseCOF * nPerReceb) - nVlDescBC //VALOR DA BASE DE CLCULO DA COFINS
				aParF500[11]	:=	nAlqCOF       					      		//ALQUOTA DA COFINS
				aParF500[12]	:=	0											//VALOR DA COFINS ///Round(aParF500[10] * aParF500[11] /100,2)
				aParF500[13]	:=	AModNot ((cAliasSFT)->FT_ESPECIE)        	//C“DIGO DO MODELO DO DOCUMENTO
				aParF500[14]	:=	(cAliasSFT)->FT_CFOP                     	//CFOP
				aParF500[15]	:=	Reg0500(@aReg0500,(cAliasSFT)->FT_CONTA)	//CONTA ANALITICA
				aParF500[16]	:=	""                                       	//INFORMA‡ƒO COMPLEMENTAR

				If lPauta
					//Para valores de Pauta ser¡ gerado registro F510
					RegF510(@aRegF510,aParF500,@nPosF510)
				Else
					//Para valores em percentuais ir¡ gerar registro F500
					RegF500(@aRegF500,aParF500,@nPosF500)
				EndIF
				aParF525 	:={}
				cCnpj  		:= ""
				cDocFiscal	:= ""
				cProduto	:= ""

				Do Case
					//Opo para agrupar valores de receitas do registro F525 pelo CNPJ do cliente
					Case cIndCompRe == "01"
						cCnpj	:= Iif(lAchouSA1,(cAliasSA1)->A1_CGC,"") //CNPJ do cliente
					//Opo para agrupar valores de receitas do registro F525 pelo numero do titulo
					Case cIndCompRe == "03"
						cDocFiscal	:= (cAliasF500)->NUMERO //Nºmero do t­tulo
					//Opo para agrupar valores de receitas do registro F525 pelo numero do documento fiscal
					Case cIndCompRe == "04"
						cDocFiscal	:= (cAliasSFT)->FT_NFISCAL //Documento Fiscal
					//Opo para agrupar valores de receitas do registro F525 pelo cdigo do produto/servio
					Case cIndCompRe == "05"
						If lAchouSB1
							cProduto:=(cAliasSB1)->B1_COD+Iif(lConcFil,xFilial("SB1"),"")
							IF aExstBlck[03]
								aProd := Execblock("SPEDPROD", .F., .F., {"SB1","F500"})
								If Len(aProd)==11
									cProduto 	:= 	aProd[1]
								Else
									aProd := {"","","","","","","","","","",""}
								EndIf
							EndIF
							//Nesta opo deve gerar registro 0200 com cdigo do produto/servio
							If aScan (aReg0200, {|aX| aX[3]==cProduto}) == 0
								Reg0200(cAlias,@aReg0200,@aReg0190,dDataDe,dDataAte,,cProduto,nRelacFil,@aReg0205,((cAliasSFT)->FT_TIPO == "S"),cAliasSB1)
							EndIf
						EndIF
				EndCase

				//Preenche array para gerao do registro F525
				Aadd(aParF525,"F525")
				Aadd(aParF525,aParF500[2])
				Aadd(aParF525,cIndCompRe)
				Aadd(aParF525,cCnpj)
				Aadd(aParF525,cDocFiscal)
				Aadd(aParF525,cProduto)
				Aadd(aParF525,aParF500[2])
				Aadd(aParF525,(cAliasSFT)->FT_CSTPIS)
				Aadd(aParF525,(cAliasSFT)->FT_CSTCOF)
				Aadd(aParF525,"")
				Aadd(aParF525, aParF500[15])
				//Gerao do registro F525
				RegF525 (@aRegF525,aParF525,@aTotF525)

				//Tratamento para gerao dos registros M400/M410 para receitas no tributaveis
				IF (cAliasSFT)->FT_CSTPIS $ "04/06/07/08/09" .OR. ((cAliasSFT)->FT_CSTPIS == "05" .AND. (cAliasSFT)->FT_ALIQPS3 == 0)
					aParNaoTri	:= {}
					aAdd(aParNaoTri,(cAliasSFT)->FT_CSTPIS)
					aAdd(aParNaoTri,aParF500[2])
					aAdd(aParNaoTri,aParF500[15])
					aAdd(aParNaoTri,(cAliasSFT)->FT_TNATREC)
					aAdd(aParNaoTri,(cAliasSFT)->FT_CNATREC)
					aAdd(aParNaoTri,(cAliasSFT)->FT_GRUPONC)
					aAdd(aParNaoTri,(cAliasSFT)->FT_DTFIMNT)
					RegM400(@aRegM400,@aRegM410,,@aReg0500,,,,,aParNaoTri)
				EndIF

				//Tratamento para gerao dos registros M800/M810 para receitas no tributaveis
				IF (cAliasSFT)->FT_CSTCOF $ "04/06/07/08/09" .OR. ((cAliasSFT)->FT_CSTCOF == "05" .AND. (cAliasSFT)->FT_ALIQCF3 == 0)
					aParNaoTri	:= {}
					aAdd(aParNaoTri,(cAliasSFT)->FT_CSTCOF)
					aAdd(aParNaoTri,aParF500[2])
					aAdd(aParNaoTri,aParF500[15])
					aAdd(aParNaoTri,(cAliasSFT)->FT_TNATREC)
					aAdd(aParNaoTri,(cAliasSFT)->FT_CNATREC)
					aAdd(aParNaoTri,(cAliasSFT)->FT_GRUPONC)
					aAdd(aParNaoTri,(cAliasSFT)->FT_DTFIMNT)
					RegM800(@aRegM800,@aRegM810,,@aReg0500,,,,,aParNaoTri)
				EndIF

				//Preenche array para pesquisar os processos referenciados vinculados a nota fiscal
				aAdd(aParCDG,(cAliasSFT)->FT_TIPOMOV)
				aAdd(aParCDG,(cAliasSFT)->FT_NFISCAL)
				aAdd(aParCDG,(cAliasSFT)->FT_SERIE)
				aAdd(aParCDG,(cAliasSFT)->FT_CLIEFOR)
				aAdd(aParCDG,(cAliasSFT)->FT_LOJA)

				IF SPEDFFiltro(1,"CDG2",@cAliasCDG,aParCDG)

					Do while !(cAliasCDG)->(EOF())

						If lTop
							cAliasCCF	:=cAliasCDG
							lAchouCCF	:= .T.
						Else
						 	lAchouCCF 	:= SPEDSeek("CCF",,xFilial("CCF")+ (cAliasCDG)->CDG_PROCES +(cAliasCDG)->CDG_TPPROC)
						EndIF

						If lPauta
							//Para valores de pauta ir¡ gerar Processo referenciado no registro F519
							RegF519 (@aRegF519,@aReg1010,@aReg1020,cAliasCDG,cAliasCCF,nPosF510,lAchouCCF)
						Else
							//Para valores de percentuais ir¡ gerar Processo referenciado no registro F509
							RegF509 (@aRegF509,@aReg1010,@aReg1020,cAliasCDG,cAliasCCF,nPosF500,lAchouCCF)
						EndIF

						(cAliasCDG)->(DBSKIP())
					EndDo
				EndIF
				//Fecha alias do processo referenciado
				SPEDFFiltro(2,,cAliasCDG)

				(cAliasSFT)->( DBSKIP())
			EndDo
			//Fecha alias dos itens da nota fiscal
			SPEDFFiltro(2,,cAliasSFT)
		EndIF
	EndIF
Else
	//Se (cAliasF500)->ORIFIN igual a .T. indica que o titulo nao possui vinculo com documento fiscal

	//Se tiver valor no campo VRDESC, foi baixa que no caracteriza um recebimento.

	IF (cAliasF500)->VRDESC == 0
		aParF500	:=	{"",0,"",0,0,0,0,0,0,0,0,0,"","","",""}
		aParF500[1]	:= "F500"

		//Para os t­tulos sem documento fiscal, ser¡ considerado como valor de pauta quando possuir CST 03
		If (cAliasF500)->CSTPIS == "03" .OR. (cAliasF500)->CSTPIS == "03"
			lPauta 		:= .T.
			aParF500[1]	:= "F510"
		EndIF

		//Preenche Array para gerao dos registros F500 ou F510
		aParF500[2]		:=	(cAliasF500)->VALOR 						//VALOR RECEBIDO
		aParF500[3]		:=	(cAliasF500)->CSTPIS       					//CST DE PIS
		aParF500[4]		:=	Iif(lCmpVrDes,(cAliasF500)->VRDESCON,0)	//VALOR DE DESCONTO DA BASE DE PIS
		aParF500[5]		:=	(cAliasF500)->BASEPIS - aParF500[4]		//BASE DE PIS PELO PERCENTUAL RECEBIDO
		aParF500[6]		:=	(cAliasF500)->ALIQPIS       				//ALQUOTA DE PIS
		aParF500[7]		:=	0//(cAliasF500)->VRPIS         				//VALOR DE PIS
		aParF500[8]		:=	(cAliasF500)->CSTCOF        				//CST DA CONFINS
		aParF500[9]		:=	Iif(lCmpVrDes,(cAliasF500)->VRDESCON,0)	//VALOR DE DESCONTO DA BASE DE CLCULO DA COFINS
		aParF500[10]	:=	(cAliasF500)->BASECOF - aParF500[9]   		//VALOR DA BASE DE CLCULO DA COFINS
		aParF500[11]	:=	(cAliasF500)->ALIQCOF       				//ALQUOTA DA COFINS
		aParF500[12]	:=	0//(cAliasF500)->VRCOFINS					//VALOR DA COFINS
		aParF500[13]	:=	""        									//C“DIGO DO MODELO DO DOCUMENTO
		aParF500[14]	:=	""                     						//CFOP
		aParF500[15]	:=	Reg0500(@aReg0500,(cAliasF500)->CONTA)		//CONTA ANALITICA
		aParF500[16]	:=	""                                       	//INFORMA‡ƒO COMPLEMENTAR

		If lPauta
		//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
		//Se for valore de paura ir¡ gerar registro F510
		//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
			RegF510(@aRegF510,aParF500,@nPosF510)
		Else
			//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
			//Se for valore de percentual ir¡ gerar registro F500
			//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
			RegF500(@aRegF500,aParF500,@nPosF500)
			aParF525 	:={}
			cCnpj  		:= ""
			cDocFiscal	:= ""
			cInfCompl	:= ""

			//Se for SEI irei gerar campo 3 com conteºdi 99 e  gerar informao complementar de juros de aplicao Financeira
			IF (cAliasF500)->TABELA=="SEI" .AND. cIndCompRe <>"03"
				cIndCompRe:= "99"
			EndIF

			Do Case
				//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
				//Opo para agrupar valores de receitas do registro F525 pelo CNPJ do cliente, ir¡ considerar cliente do titulo
				//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
				Case cIndCompRe == "01"
					If SPEDSeek("SA1",1,xFilial("SA1")+(cAliasF500)->CHVCLIENTE)
						cCnpj	:= SA1->A1_CGC
					EndIF
				//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„
				//Se for escolhido outra opo de agrupar receita, como o t­tulo no possui valor de documento fiscal
				//e nao possuit um produto, por padro ser¡ agrupado com opo 03 numero da duplicata                
				//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„
				Case cIndCompRe $ "03#04#05"
					cDocFiscal	:= (cAliasF500)->NUMERO //Nºmero do t­tulo
					cIndCompRe	:= "03"
				//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
				//Para 99 ir¡ gerar com aplicao Financeira
				//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
				Case cIndCompRe $ "99"
					cInfCompl:="Juros Referente Aplicao Financeira - (Banco + Agªncia + Conta) :  " + (cAliasF500)->CHVCLIENTE
			EndCase
			//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
			//Quando gerar um registro F500 dever¡ ser gerado um registro F525
			//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
			Aadd(aParF525,"F525")
			Aadd(aParF525,aParF500[2])
			Aadd(aParF525,cIndCompRe)
			Aadd(aParF525,cCnpj)
			Aadd(aParF525,cDocFiscal)
			Aadd(aParF525,cProduto)
			Aadd(aParF525,aParF500[2])
			Aadd(aParF525,(cAliasF500)->CSTPIS)
			Aadd(aParF525,(cAliasF500)->CSTCOF )
			Aadd(aParF525,cInfCompl)
			Aadd(aParF525, aParF500[15])
			//š„„„„„„„„„„„„„„„„„„„„„„„„¿
			//Gerao do registro F525
			//€„„„„„„„„„„„„„„„„„„„„„„„„™
			RegF525 (@aRegF525,aParF525,@aTotF525)
		EndIF

		//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
		//Tratamento para gerao dos registros M400/M410 para receitas no tributaveis
		//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
		IF (cAliasF500)->CSTPIS $ "04/06/07/08/09" .OR. ((cAliasF500)->CSTPIS == "05" .AND. (cAliasF500)->ALIQPIS == 0)
			aParNaoTri	:= {}
			aAdd(aParNaoTri,(cAliasF500)->CSTPIS)
			aAdd(aParNaoTri,aParF500[2])
			aAdd(aParNaoTri,aParF500[15])
			aAdd(aParNaoTri,(cAliasF500)->ED_TABCCZ)
			aAdd(aParNaoTri,(cAliasF500)->ED_CODCCZ)
			aAdd(aParNaoTri,(cAliasF500)->ED_GRUCCZ)
			aAdd(aParNaoTri,(cAliasF500)->ED_DTFCCZ)
			RegM400(@aRegM400,@aRegM410,,@aReg0500,,,,,aParNaoTri)
		EndIF

		//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
		//Tratamento para gerao dos registros M800/M810 para receitas no tributaveis
		//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
		IF (cAliasF500)->CSTCOF  $ "04/06/07/08/09" .OR. ((cAliasF500)->CSTCOF  == "05" .AND. (cAliasF500)->ALIQCF3 == 0)
			aParNaoTri	:= {}
			aAdd(aParNaoTri,(cAliasF500)->CSTCOF )
			aAdd(aParNaoTri,aParF500[2])
			aAdd(aParNaoTri,aParF500[15])
			aAdd(aParNaoTri,(cAliasF500)->ED_TABCCZ)
			aAdd(aParNaoTri,(cAliasF500)->ED_CODCCZ)
			aAdd(aParNaoTri,(cAliasF500)->ED_GRUCCZ)
			aAdd(aParNaoTri,(cAliasF500)->ED_DTFCCZ)
			RegM800(@aRegM800,@aRegM810,,@aReg0500,,,,,aParNaoTri)
		EndIF

		IF lProcFin .AND. !Empty((cAliasF500)->NUMPRO) .AND. !Empty((cAliasF500)->INDPRO)
			lGera1000	:=.F.
			If lPauta .AND.	(nPos := aScan (aRegF519, {|aX| aX[1]==nPosF510 .AND. aX[3]==(cAliasF500)->NUMPRO})==0)
				aAdd(aRegF519, {})
				nPos	:=	Len (aRegF519)
				aAdd (aRegF519[nPos], nPosF510) 											//Relao com F510
				aAdd (aRegF519[nPos], "F519") 												//01-REG
				aAdd (aRegF519[nPos], (cAliasF500)->NUMPRO) 			   					//02-NUM_PROC
				aAdd (aRegF519[nPos], (cAliasF500)->INDPRO) 			   					//03-IND_PROC
				lGera1000 := .T.

			ElseIF (nPos := aScan (aRegF509, {|aX| aX[1]==nPosF500 .AND. aX[3]==(cAliasF500)->NUMPRO})==0)
				aAdd(aRegF509, {})
				nPos	:=	Len (aRegF509)
				aAdd (aRegF509[nPos], nPosF500) 											//Relao com F500
				aAdd (aRegF509[nPos], "F509") 												//01-REG
				aAdd (aRegF509[nPos], (cAliasF500)->NUMPRO) 			   					//02-NUM_PROC
				aAdd (aRegF509[nPos], (cAliasF500)->INDPRO) 			   					//03-IND_PROC
				lGera1000 := .T.
			EndIF

	        If lGera1000
		        lAchouCCF	:=	CCF->(MsSeek (xFilial ("CCF")+(cAliasF500)->NUMPRO+(cAliasF500)->INDPRO ))
				If	lAchouCCF
					If CCF->CCF_TPCOMP == "1" //Complemento do processo referenciado - Judicial
						Reg1010(@aReg1010)
					ElseIf CCF->CCF_TPCOMP == "2" //Complemento do processo referenciado - Administrativo
						Reg1020(@aReg1020)
					EndIf
				Endif
			EndIF
		EndIF
	EndIF
EndIF
Return

/*‘‹‘‹‘»±±
±±ºPrograma  AtuF525   ºAutor  Erick G. Dias       º Data   22/06/2012 º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.     Funo para agrupar os valores de receita no registro		  º±±
±±º          F525 conforme indicador do campo IND_REC              	  º±±
±±Œ˜¹±±
±±ºParametros aRegF525 -> Array com informaµes do registro F519         º±±
±±º           aTotF525 -> Array com informaµes do registro 1010         º±±
±±ˆ¼*/
Static Function AtuF525(aRegF525, aTotF525)

Local nCont	:= 0

For nCont	:= 1 to Len(aRegF525)

	Do Case
		//Agrupado por CNPJ do cliente
		Case aRegF525[nCont][3] == "01"
			aRegF525[nCont][2]	:=	aTotF525[1]
		//Agrupado por t­tulo/duplicata
		Case aRegF525[nCont][3] == "03"
			aRegF525[nCont][2]	:=	aTotF525[3]
		//Agrupado por documento fiscal
		Case aRegF525[nCont][3] == "04"
			aRegF525[nCont][2]	:=	aTotF525[4]
		//Agrupado por produto/servio
		Case aRegF525[nCont][3] == "05"
			aRegF525[nCont][2]	:=	aTotF525[5]
		//Agrupado por Banco+agencia+conta (Juros de aplicao Financeira)
		Case aRegF525[nCont][3] == "99"
			aRegF525[nCont][2]	:=	aTotF525[7]
	EndCase
Next nCont
Return

/*‘‹‘‹‘»±±
±±ºPrograma  RegF509   ºAutor  Erick G. Dias       º Data   22/06/2012 º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.     Gerao do Processo referenciado registro F509       		  º±±
±±Œ˜¹±±
±±ºParametros aRegF509 -> Array com informaµes do registro F509         º±±
±±º           aReg1010 -> Array com informaµes do registro 1010         º±±
±±º           aReg1020 -> Array com informaµes do registro 1020         º±±
±±º           cAliasCDG ->Alias da tabela CDG                            º±±
±±º           cAliasCCF ->Alias da tabela CCF                            º±±
±±º           nPosF510 -> Posio de relacionamento do registro F500 pai º±±
±±º           lAchouCCF -> Indica se encontrou informaµes na tabela CCF º±±
±±ˆ*/
Static Function RegF509 (aRegF509,aReg1010,aReg1020,cAliasCDG,cAliasCCF,nPosF500,lAchouCCF)

Local   nPos        := 0

If (nPos := aScan (aRegF509, {|aX| aX[1]==nPosF500 .AND. aX[3]==(cAliasCDG)->CDG_PROCES})==0)
	aAdd(aRegF509, {})
	nPos := Len(aRegF509)
	aAdd (aRegF509[nPos], nPosF500)						//Relacionamento com o registro pai
	aAdd (aRegF509[nPos], "F509")						//01 - REG
	aAdd (aRegF509[nPos], (cAliasCDG)->CDG_PROCES)		//02 - NUM_PROC
	aAdd (aRegF509[nPos], (cAliasCDG)->CDG_TPPROC)		//03 - IND_PROC

    If lAchouCCF
		If (cAliasCCF)->CCF_TPCOMP == "1" //Complemento do processo referenciado - Judicial
			Reg1010(aReg1010,,cAliasCCF)
		ElseIf (cAliasCCF)->CCF_TPCOMP == "2" //Complemento do processo referenciado - Administrativo
			Reg1020(aReg1020,,cAliasCCF)
		EndIF
	EndIf
Endif
Return

/*‘‹‘‹‘»±±
±±ºPrograma  RegF519   ºAutor  Erick G. Dias       º Data   22/06/2012 º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.     Gerao do Processo referenciado registro F519       		  º±±
±±Œ˜¹±±
±±ºParametros aRegF519 -> Array com informaµes do registro F519         º±±
±±º           aReg1010 -> Array com informaµes do registro 1010         º±±
±±º           aReg1020 -> Array com informaµes do registro 1020         º±±
±±º           cAliasCDG ->Alias da tabela CDG                            º±±
±±º           cAliasCCF ->Alias da tabela CCF                            º±±
±±º           nPosF510 -> Posio de relacionamento do registro F500 pai º±±
±±º           lAchouCCF -> Indica se encontrou informaµes na tabela CCF º±±
±±ˆ*/
Static Function RegF519 (aRegF519,aReg1010,aReg1020,cAliasCDG,cAliasCCF,nPosF510,lAchouCCF)

Local   nPos        := 0

If (nPos := aScan (aRegF519, {|aX| aX[1]==nPosF510 .AND.  aX[3]==(cAliasCDG)->CDG_PROCES})==0)
	aAdd(aRegF519, {})
	nPos := Len(aRegF519)
	aAdd (aRegF519[nPos], nPosF510)						//Relacionamento com o registro pai
	aAdd (aRegF519[nPos], "F519")						//01 - REG
	aAdd (aRegF519[nPos], (cAliasCDG)->CDG_PROCES)		//02 - NUM_PROC
	aAdd (aRegF519[nPos], (cAliasCDG)->CDG_TPPROC)		//03 - IND_PROC

	If lAchouCCF
		If (cAliasCCF)->CCF_TPCOMP == "1" //Complemento do processo referenciado - Judicial
			Reg1010(aReg1010,,cAliasCCF)
		ElseIf (cAliasCCF)->CCF_TPCOMP == "2" //Complemento do processo referenciado - Administrativo
			Reg1020(aReg1020,,cAliasCCF)
		EndIF
	EndIF
Endif
Return

/*‘‹‘‹‘»±±
±±ºPrograma  Reg1900   ºAutor  Erick G. Dias       º Data   26/06/2012 º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.     Gerao do Processo referenciado registro 1900       		  º±±
±±Œ˜¹±±
±±ºParametros aReg1900 -> Array com informaµes do registro 1900         º±±
±±ºParametros cCnpj 	-> CNPJ do estabelecimento no registro 0140       º±±
±±ºParametros dDataDe  -> Data inicial da gerao do arquivo.            º±±
±±ºParametros dDataAte -> Data final da gerao do arquivo.              º±±
±±ºParametros cNrLivro -> Cdigo do Livro                                º±±
±±ºParametros aReg0500 -> Array com informaµes do registro 0500         º±±
±±ˆ¼*/
Static Function Reg1900(aReg1900,cCnpj,dDataDe,dDataAte,cNrLivro,aReg0500,aWizard,aCFOPs)

Local nPos			:= 0
Local nPos1900		:= 0
Local aParF525		:= {}
Local cAliasSFT		:= "SFT"
Local cFiltro		:= ""
Local cCampos		:= ""
Local cEspecie		:= ""
Local cConta		:= ""
local nQuant		:= 0
Local aF100Aux		:= {}
Local nPosF100		:= 0
Local cNumTit		:= ""
Local cInfComp		:= ""
Local aRetImob		:= {}
Local nCont			:= 0
Local nPosNf		:= 0
Local aRegNf		:= {}
Local cChave1900 := ""

DbSelectArea ("DT6")
DT6->(DbSetOrder (1))

DbSelectArea (cAliasSFT)
(cAliasSFT)->(DbSetOrder (2))
#IFDEF TOP
    If (TcSrvType ()<>"AS/400")
    	cAliasSFT	:=	GetNextAlias()

		cFiltro := "%"

		If (cNrLivro<>"*")
       		cFiltro += " SFT.FT_NRLIVRO = '" +%Exp:cNrLivro% +"' AND "
  		EndiF

		cFiltro += "%"
		cCampos := "%"

    	BeginSql Alias cAliasSFT

			COLUMN FT_EMISSAO AS DATE
	    	COLUMN FT_ENTRADA AS DATE
	    	COLUMN FT_DTCANC AS DATE

			SELECT
				SFT.FT_FILIAL, SFT.FT_VALCONT ,SFT.FT_CFOP,SFT.FT_CSTPIS,SFT.FT_CSTCOF, SFT.FT_SERIE,SFT.FT_CONTA,SFT.FT_ESPECIE,SFT.FT_DTCANC,SFT.FT_NFISCAL,SFT.FT_CLIEFOR,;
				SFT.FT_LOJA,SFT.FT_PRODUTO,SFT.FT_ITEM,SFT.FT_TIPO,SFT.FT_TIPOMOV,SFT.FT_RGESPST,SFT.FT_PDV,SFT.FT_ENTRADA
				%Exp:cCampos%
			FROM
				%Table:SFT% SFT
			WHERE
				SFT.FT_FILIAL=%xFilial:SFT% AND
				SFT.FT_TIPOMOV = 'S' AND
				SFT.FT_TIPO <> 'D' AND
				SFT.FT_ENTRADA>=%Exp:DToS (dDataDe)% AND
				SFT.FT_ENTRADA<=%Exp:DToS (dDataAte)% AND
				((SFT.FT_CFOP NOT LIKE '000%' AND SFT.FT_CFOP NOT LIKE '999%') OR SFT.FT_TIPO='S') AND
				((SFT.FT_BASEPIS > 0 OR SFT.FT_CSTPIS IN ('07','08','09','49','99'))  OR ( SFT.FT_BASECOF > 0 OR SFT.FT_CSTCOF IN ('07','08','09','49','99'))) AND
				%Exp:cFiltro%
				SFT.%NotDel%

			ORDER BY SFT.FT_ESPECIE

		EndSql
	Else
#ENDIF
	    cIndex	:= CriaTrab(NIL,.F.)
	    cFiltro	:= 'FT_FILIAL=="'+xFilial ("SFT")+'".And.'
	    cFiltro += 'FT_TIPOMOV== "S" .And. '
	    cFiltro += 'FT_TIPO <> "D" .And. '
	   	cFiltro += 'DToS (FT_ENTRADA)>="'+DToS (dDataDe)+'".And.DToS (FT_ENTRADA)<="'+DToS (dDataAte)+'" '
		cFiltro += '.And. (!SubStr (FT_CFOP,1,3)$"999/000" .Or. FT_TIPO=="S") .And.((FT_BASEPIS > 0 .OR. FT_CSTPIS $"07#08#09#49#99") .OR. (FT_BASECOF > 0  .OR. FT_CSTCOF $"07#08#09#49#99"))'

	    If (cNrLivro<>"*")
		    cFiltro	+=	'.And.FT_NRLIVRO ="'+cNrLivro+'" '
	   	EndIf

	    IndRegua (cAliasSFT, cIndex, SFT->(IndexKey ()),, cFiltro)
	    nIndex := RetIndex(cAliasSFT)

		#IFNDEF TOP
			DbSetIndex (cIndex+OrdBagExt ())
		#ENDIF

		DbSelectArea (cAliasSFT)
	    DbSetOrder (nIndex+1)
#IFDEF TOP
	Endif
#ENDIF

DbSelectArea (cAliasSFT)
(cAliasSFT)->(DbGoTop ())
ProcRegua ((cAliasSFT)->(RecCount ()))
Do While !(cAliasSFT)->(Eof ())
   	// Tratamento para cupons fiscais gerados pelo SIGALOJA
   	If !Empty((cAliasSFT)->FT_PDV) .AND. AllTrim((cAliasSFT)->FT_ESPECIE)$"CF/ECF"
		cEspecie := "2D"
	Else
		cEspecie :=	AModNot((cAliasSFT)->FT_ESPECIE)
	EndIf

	cCfop	:= AllTrim((cAliasSFT)->FT_CFOP)

	//verificar os CFOPs de receita para poder gerar os registros.
	If (cCfop$aCFOPs[01] .Or. cCfop$aCFOPs[03]) .AND. !(cCfop$aCFOPs[02])

		cEspecie	:=	Iif(Empty(cEspecie),"98",cEspecie)
		cConta		:=	Reg0500(@aReg0500,(cAliasSFT)->FT_CONTA)
		cSituaDoc	:=	SPEDSitDoc (,cAliasSFT,,,dDataDe,dDataAte) //verificar SF3 - pendente

		If !cSituaDoc $ "05"

			//Para o registro 1900 se a situao do documento no for normal ou cancelada dever¡ ser igual a 99 - Outros
			If ! cSituaDoc $ "00/02"
				cSituaDoc := "99"
			EndIf

			cChave1900 := cCnpj + cEspecie + (cAliasSFT)->FT_SERIE + cSituaDoc + (cAliasSFT)->FT_CSTPIS + (cAliasSFT)->FT_CSTCOF + (cAliasSFT)->FT_CFOP + cConta

			// Importante: Qualquer alteracao na chave do registro 1900 deve ser feita tambem na variavel cChave1900 p/ que a contagem de documentos fique correta.
			nPos1900 := aScan (aReg1900, {|aX| aX[2]==cCnpj .AND. aX[3]==cEspecie .AND. aX[4]==(cAliasSFT)->FT_SERIE .AND. aX[6]==cSituaDoc .AND. aX[9]==(cAliasSFT)->FT_CSTPIS .AND. ;
							    aX[10]==(cAliasSFT)->FT_CSTCOF.AND. aX[11]==(cAliasSFT)->FT_CFOP .AND. aX[13]==cConta})

			If nPos1900 == 0
				aAdd(aReg1900, {})
				nPos := Len(aReg1900)
				aAdd (aReg1900[nPos], "1900")						//01-Registro
				aAdd (aReg1900[nPos], cCnpj)   						//02-CNPJ
				aAdd (aReg1900[nPos], cEspecie)   					//03-COD_MOD
				aAdd (aReg1900[nPos], (cAliasSFT)->FT_SERIE)		//04-SER
				aAdd (aReg1900[nPos], "")   						//05-SUB_SER
				aAdd (aReg1900[nPos], cSituaDoc)   					//06-COD_SIT
				aAdd (aReg1900[nPos], (cAliasSFT)->FT_VALCONT)  	//07-VL_TOT_REC
				aAdd (aReg1900[nPos], "1")   						//08-QUANT_DOC
				aAdd (aReg1900[nPos], (cAliasSFT)->FT_CSTPIS)   	//09-CST_PIS
				aAdd (aReg1900[nPos], (cAliasSFT)->FT_CSTCOF)  		//10-CST_COFINS
				aAdd (aReg1900[nPos], (cAliasSFT)->FT_CFOP)  		//11-CFOP
				aAdd (aReg1900[nPos], "")  							//12-INF_COMPL
				aAdd (aReg1900[nPos], cConta)  						//13-COD_CTA

				nPosNf	:= aScan(aRegNf, {|aX| aX[1] == (cAliasSFT)->FT_NFISCAL .AND. aX[2] == (cAliasSFT)->FT_SERIE .AND. aX[3] == (cAliasSFT)->FT_ESPECIE  .AND. aX[4] == (cAliasSFT)->FT_CLIEFOR .AND. aX[5] == cChave1900 } )
				IF nPosNf == 0
					aAdd(aRegNf, {})
					nPosNf := Len(aRegNf)
					aAdd (aRegNf[nPosNf], (cAliasSFT)->FT_NFISCAL)
					aAdd (aRegNf[nPosNf], (cAliasSFT)->FT_SERIE)
					aAdd (aRegNf[nPosNf], (cAliasSFT)->FT_ESPECIE)
					aAdd (aRegNf[nPosNf], (cAliasSFT)->FT_CLIEFOR)
					aAdd (aRegNf[nPosNf], cChave1900)
				EndIF
			Else
				aReg1900[nPos1900][7]	+= (cAliasSFT)->FT_VALCONT	//07-VL_TOT_REC
				//Verifica se o documento fiscal j¡ foi utilizado no registro 1900, © necess¡rio array auxiliar pois no registro 1900 no existe campo para nºmero da nota fiscal
				nPosNf	:= aScan(aRegNf, {|aX| aX[1] == (cAliasSFT)->FT_NFISCAL .AND. aX[2] == (cAliasSFT)->FT_SERIE .AND. aX[3] == (cAliasSFT)->FT_ESPECIE  .AND. aX[4] == (cAliasSFT)->FT_CLIEFOR .AND. aX[5] == cChave1900 } )
				IF nPosNf == 0
				    aReg1900[nPos1900][8]	:=	cvaltochar(val(aReg1900[nPos1900][8]) +=1) //08-QUANT_DOC
		  		    aAdd(aRegNf, {})
					nPosNf := Len(aRegNf)
					aAdd (aRegNf[nPosNf], (cAliasSFT)->FT_NFISCAL)
					aAdd (aRegNf[nPosNf], (cAliasSFT)->FT_SERIE)
					aAdd (aRegNf[nPosNf], (cAliasSFT)->FT_ESPECIE)
					aAdd (aRegNf[nPosNf], (cAliasSFT)->FT_CLIEFOR)
					aAdd (aRegNf[nPosNf], cChave1900)
				EndIf
			EndIf
		EndIf
	Endif
	(cAliasSFT)->(DbSkip())
Enddo

aF100Aux := FinSpdF100(Month(dDataDe),Year(dDataDe),,,,"1900")

DbSelectArea ("DT6")
DT6->(DbSetOrder (10))

For nPosF100 :=1 to Len(aF100Aux)

	If aF100Aux[nPosF100][3] $ "01#02#03#05#04#06#07#08#09#49#99"

		cNumTit := ""
		IF aF100Aux[nPosF100][15] == "SE1"
			SE1->(dbGoto( aF100Aux[nPosF100][16]))
			If IntTms () .AND. DT6->(MsSeek (xFilial("DT6")+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_TIPO))
				cNumTit := "referente o CTe : " + DT6->DT6_DOC
			Else
				cNumTit 	:="referente o T­tulo :" + SE1->E1_NUM
    		EndIF
		ElseIF aF100Aux[nPosF100][15] == "SE5"
			SE5->(dbGoto( aF100Aux[nPosF100][16]))
			cNumTit 	:="referente o T­tulo :" + SE5->E5_NUMERO
		ElseIF aF100Aux[nPosF100][15] == "SEI"
			SEI->(dbGoto( aF100Aux[nPosF100][16]))
			cNumTit 	:="referente a Aplicao :" + SEI->EI_NUMERO
		EndIF
		cInfComp	:= "Operao " + cNumTit

		cSituaDoc:= "00"
		//Verifica se existe a posio 30, se existir e estiver igual a .T., ento esta operao © cancelada.
		If len(aF100Aux[nPosF100]) >=30 .AND. aF100Aux[nPosF100][30]
			cSituaDoc:= "02"
		EndIF

		nPos1900 := aScan (aReg1900, {|aX| aX[2]==cCnpj .AND. aX[3]=="99" .AND. aX[4]=="" .AND. aX[6]==cSituaDoc .AND. aX[9]==aF100Aux[nPosF100][3].AND. ;
			    			aX[10]==aF100Aux[nPosF100][7].AND. aX[11]=="" .AND. aX[12]==cInfComp .AND. aX[13]==cConta})

		If nPos1900 == 0
			aAdd(aReg1900, {})
			nPos := Len(aReg1900)
			aAdd (aReg1900[nPos], "1900")						//01-Registro
			aAdd (aReg1900[nPos], cCnpj)   						//02-CNPJ
			aAdd (aReg1900[nPos], "99")   						//03-COD_MOD
			aAdd (aReg1900[nPos], "")							//04-SER
			aAdd (aReg1900[nPos], "")   						//05-SUB_SER
			aAdd (aReg1900[nPos], cSituaDoc)   					//06-COD_SIT
			aAdd (aReg1900[nPos], aF100Aux[nPosF100][2])   		//07-VL_TOT_REC
			aAdd (aReg1900[nPos], "1")   						//08-QUANT_DOC
			aAdd (aReg1900[nPos], aF100Aux[nPosF100][3])   		//09-CST_PIS
			aAdd (aReg1900[nPos], aF100Aux[nPosF100][7])	  	//10-CST_COFINS
			aAdd (aReg1900[nPos], "")  	   						//11-CFOP
			aAdd (aReg1900[nPos], cInfComp)						//12-INF_COMPL
			aAdd (aReg1900[nPos], cConta)  						//13-COD_CTA
		Else
			aReg1900[nPos1900][7]	+= aF100Aux[nPosF100][2]	//07-VL_TOT_REC
			aReg1900[nPos1900][8]	:=	cvaltochar(val(aReg1900[nPos1900][8]) +=1) //08-QUANT_DOC
		EndIf
	EndIF
Next nPosF100

If aExstBlck[10]
    aRetImob := ExecBlock("SPDPCIMOB",.F.,.F.,{aWizard})

	For nCont := 1 to Len(aRetImob[1])
		If Len(aRetImob)>0 .And. ValType(aRetImob[1]) == "A"
	        cInfComp	:= aRetImob[1][nCont][22]
			cConta		:= ""

			nPos1900 := aScan (aReg1900, {|aX| aX[2]==cCnpj .AND. aX[3]=="99" .AND. aX[4]=="" .AND. aX[6]=="99" .AND. aX[9]==aRetImob[1][nCont][12] .AND. ;
				    			  aX[10]==aRetImob[1][nCont][16].AND. aX[11]=="" .AND. aX[12]==cInfComp .AND. aX[13]==cConta})

			If nPos1900 == 0
				aAdd(aReg1900, {})
				nPos := Len(aReg1900)
				aAdd (aReg1900[nPos], "1900")						//01-Registro
				aAdd (aReg1900[nPos], cCnpj)   						//02-CNPJ
				aAdd (aReg1900[nPos], "99")   						//03-COD_MOD
				aAdd (aReg1900[nPos], "")							//04-SER
				aAdd (aReg1900[nPos], "")   						//05-SUB_SER
				aAdd (aReg1900[nPos], "99")		   					//06-COD_SIT
				aAdd (aReg1900[nPos], aRetImob[1][nCont][11])   	//07-VL_TOT_REC
				aAdd (aReg1900[nPos], "1")   						//08-QUANT_DOC
				aAdd (aReg1900[nPos], aRetImob[1][nCont][12])   	//09-CST_PIS
				aAdd (aReg1900[nPos], aRetImob[1][nCont][16])	  	//10-CST_COFINS
				aAdd (aReg1900[nPos], "")  	   						//11-CFOP
				aAdd (aReg1900[nPos], cInfComp)						//12-INF_COMPL
				aAdd (aReg1900[nPos], cConta)  						//13-COD_CTA
			Else
				aReg1900[nPos1900][7]	+= aRetImob[1][nCont][11]	//07-VL_TOT_REC
				aReg1900[nPos1900][8]	:=	cvaltochar(val(aReg1900[nPos1900][8]) +=1) //08-QUANT_DOC
	        EndIf
		Endif
	Next nCont
EndIF

Return

/*‘‹‘‹‘»±±
±±ºPrograma  RegF550   ºAutor  Erick G. Dias       º Data   02/07/2012 º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.     Funo para gerao do registro F550.                		  º±±
±±Œ˜¹±±
±±ºParametros aRegF500 -> Array com valores do registro F550             º±±
±±º           aValor   -> Array com os valores para que seja gerado      º±±
±±º                       registro F510                                  º±±
±±º           nPosRetorn -> Array com o totalizador das receitas.        º±±
±±ˆ¼*/
Static Function RegF550(aRegF550,aValor,nPosRetorn)

Local nPos			:= 0
Local nPosF550		:= 0
Local aPar			:= 0

nPosF550 := aScan (aRegF550, {|aX| aX[3]==aValor[3] .AND. aX[6]==aValor[6] .AND. aX[8]==aValor[8] .AND. ;
								    aX[11]==aValor[11].AND. aX[13]==aValor[13] .AND. aX[14]==aValor[14] .AND.;
								    aX[15]==aValor[15] .AND. aX[16]==aValor[16]})


If nPosF550 == 0
	aAdd(aRegF550, {})
	nPos := Len(aRegF550)
	aAdd (aRegF550[nPos], aValor[1])		//01-Registro
	aAdd (aRegF550[nPos], aValor[2])   		//02-VL_REC_COMP
	aAdd (aRegF550[nPos], aValor[3])   		//03-CST_PIS
	aAdd (aRegF550[nPos], aValor[4])   		//04-VL_DESC_PIS
	aAdd (aRegF550[nPos], aValor[5])   		//05-VL_BC_PIS
	aAdd (aRegF550[nPos], aValor[6])   		//06-ALIQ_PIS
	aAdd (aRegF550[nPos], aValor[7])   		//07-VL_PIS
	aAdd (aRegF550[nPos], aValor[8])   		//08-CST_COFINS
	aAdd (aRegF550[nPos], aValor[9])   		//09-VL_DESC_COFINS
	aAdd (aRegF550[nPos], aValor[10])  		//10-VL_BC_COFINS
	aAdd (aRegF550[nPos], aValor[11])  		//11-ALIQ_COFINS
	aAdd (aRegF550[nPos], aValor[12])  		//12-VL_COFINS
	aAdd (aRegF550[nPos], aValor[13])  		//13-COD_MOD
	aAdd (aRegF550[nPos], aValor[14]) 		//14-CFOP
	aAdd (aRegF550[nPos], aValor[15])  		//15-COD_CTA
	aAdd (aRegF550[nPos], aValor[16])  		//16-INF_COMPL
	nPosRetorn	:= nPos
Else
	aRegF550[nPosF550][2]	+=	aValor[2]	//02-VL_REC_COMP
	aRegF550[nPosF550][4]	+=	aValor[4]	//04-VL_DESC_PIS
	aRegF550[nPosF550][5]	+=	aValor[5]	//05-VL_BC_PIS
	aRegF550[nPosF550][7]	+=	aValor[7]	//07-VL_PIS
	aRegF550[nPosF550][9]	+=	aValor[9] 	//09-VL_DESC_COFINS
	aRegF550[nPosF550][10]	+=	aValor[10]	//10-VL_BC_COFINS
	aRegF550[nPosF550][12]	+=	aValor[12]	//12-VL_COFINS
	nPosRetorn	:= nPosF550
EndIf
Return

/*‘‹‘‹‘»±±
±±ºPrograma  RegF560    ºAutor  Erick G. Dias       º Data   02/07/2012 º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.     Funo para gerao do registro F560.                		  º±±
±±Œ˜¹±±
±±ºParametros aRegF510 -> Array com valores do registro F560             º±±
±±º           aValor   -> Array com os valores para que seja gerado      º±±
±±º                       registro F510                                  º±±
±±º           nPosRetorn -> Array com o totalizador das receitas.          º±±
±±ˆ¼*/
Static Function RegF560 (aRegF560,aValor,nPosRetorn)

Local nPos			:= 0
Local nPosF560		:= 0
Local aPar			:= {}

nPosF560 := aScan (aRegF560, {|aX| aX[3]==aValor[3] .AND. aX[6]==aValor[6] .AND. aX[8]==aValor[8] .AND. ;
								    aX[11]==aValor[11].AND. aX[13]==aValor[13] .AND. aX[14]==aValor[14] .AND.;
								    aX[15]==aValor[15] .AND. aX[16]==aValor[16]})

If nPosF560 == 0
	aAdd(aRegF560, {})
	nPos := Len(aRegF560)
	aAdd (aRegF560[nPos], aValor[1])		//01-Registro
	aAdd (aRegF560[nPos], aValor[2])   		//02-VL_REC_COMP
	aAdd (aRegF560[nPos], aValor[3])   		//03-CST_PIS
	aAdd (aRegF560[nPos], aValor[4])   		//04-VL_DESC_PIS
	aAdd (aRegF560[nPos], aValor[5])   		//05-VL_BC_PIS
	aAdd (aRegF560[nPos], aValor[6])   		//06-ALIQ_PIS
	aAdd (aRegF560[nPos], aValor[7])   		//07-VL_PIS
	aAdd (aRegF560[nPos], aValor[8])   		//08-CST_COFINS
	aAdd (aRegF560[nPos], aValor[9])   		//09-VL_DESC_COFINS
	aAdd (aRegF560[nPos], aValor[10])  		//10-VL_BC_COFINS
	aAdd (aRegF560[nPos], aValor[11])  		//11-ALIQ_COFINS
	aAdd (aRegF560[nPos], aValor[12])  		//12-VL_COFINS
	aAdd (aRegF560[nPos], aValor[13])  		//13-COD_MOD
	aAdd (aRegF560[nPos], aValor[14]) 		//14-CFOP
	aAdd (aRegF560[nPos], aValor[15])  		//15-COD_CTA
	aAdd (aRegF560[nPos], aValor[16])  		//16-INF_COMPL
	nPosRetorn := nPos
Else
	aRegF560[nPosF560][2]	+=	aValor[2]	//02-VL_REC_COMP
	aRegF560[nPosF560][4]	+=	aValor[4]	//04-VL_DESC_PIS
	aRegF560[nPosF560][5]	+=	aValor[5]	//05-VL_BC_PIS
	aRegF560[nPosF560][7]	+=	aValor[7]	//07-VL_PIS
	aRegF560[nPosF560][9]	+=	aValor[9] 	//09-VL_DESC_COFINS
	aRegF560[nPosF560][10]	+=	aValor[10]	//10-VL_BC_COFINS
	aRegF560[nPosF560][12]	+=	aValor[12]	//12-VL_COFINS
	nPosRetorn := nPosF560
EndIf
Return

/*‘‹‘‹‘»±±
±±ºPrograma  RegF559   ºAutor  Erick G. Dias       º Data   22/06/2012 º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.     Gerao do Processo referenciado registro F559       		  º±±
±±Œ˜¹±±
±±ºParametros aRegF509 -> Array com informaµes do registro F559         º±±
±±º           aReg1010 -> Array com informaµes do registro 1010         º±±
±±º           aReg1020 -> Array com informaµes do registro 1020         º±±
±±º           cAliasCDG ->Alias da tabela CDG                            º±±
±±º           cAliasCCF ->Alias da tabela CCF                            º±±
±±º           nPosF510 -> Posio de relacionamento do registro F550 pai º±±
±±º           lAchouCCF -> Indica se encontrou informaµes na tabela CCF º±±
±±ˆ*/
Static Function RegF559 (aRegF559,aReg1010,aReg1020,cAliasCDG,cAliasCCF,nPosF550,lAchouCCF)

Local   nPos        := 0

If (nPos := aScan (aRegF559, {|aX| aX[1]==nPosF550 .AND. aX[3]==(cAliasCDG)->CDG_PROCES})==0)
	aAdd(aRegF559, {})
	nPos := Len(aRegF559)
	aAdd (aRegF559[nPos], nPosF550)						//Relacionamento com o registro pai
	aAdd (aRegF559[nPos], "F559")						//01 - REG
	aAdd (aRegF559[nPos], (cAliasCDG)->CDG_PROCES)		//02 - NUM_PROC
	aAdd (aRegF559[nPos], (cAliasCDG)->CDG_TPPROC)		//03 - IND_PROC

    If lAchouCCF
		If (cAliasCCF)->CCF_TPCOMP == "1" //Complemento do processo referenciado - Judicial
			Reg1010(aReg1010,,cAliasCCF)
		ElseIf (cAliasCCF)->CCF_TPCOMP == "2" //Complemento do processo referenciado - Administrativo
			Reg1020(aReg1020,,cAliasCCF)
		EndIF
	EndIf
Endif
Return


/*‘‹‘‹‘»±±
±±ºPrograma  RegF569   ºAutor  Erick G. Dias       º Data   02/07/2012 º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.     Gerao do Processo referenciado registro F569       		  º±±
±±Œ˜¹±±
±±ºParametros aRegF519 -> Array com informaµes do registro F569         º±±
±±º           aReg1010 -> Array com informaµes do registro 1010         º±±
±±º           aReg1020 -> Array com informaµes do registro 1020         º±±
±±º           cAliasCDG ->Alias da tabela CDG                            º±±
±±º           cAliasCCF ->Alias da tabela CCF                            º±±
±±º           nPosF510 -> Posio de relacionamento do registro F560 pai º±±
±±º           lAchouCCF -> Indica se encontrou informaµes na tabela CCF º±±
±±ˆ¼*/
Static Function RegF569 (aRegF569,aReg1010,aReg1020,cAliasCDG,cAliasCCF,nPosF560,lAchouCCF)

Local   nPos        := 0

If (nPos := aScan (aRegF569, {|aX| aX[1]==nPosF560 .AND.  aX[3]==(cAliasCDG)->CDG_PROCES})==0)
	aAdd(aRegF569, {})
	nPos := Len(aRegF569)
	aAdd (aRegF569[nPos], nPosF560)						//Relacionamento com o registro pai
	aAdd (aRegF569[nPos], "F569")						//01 - REG
	aAdd (aRegF569[nPos], (cAliasCDG)->CDG_PROCES)		//02 - NUM_PROC
	aAdd (aRegF569[nPos], (cAliasCDG)->CDG_TPPROC)		//03 - IND_PROC

	If lAchouCCF
		If (cAliasCCF)->CCF_TPCOMP == "1" //Complemento do processo referenciado - Judicial
			Reg1010(aReg1010,,cAliasCCF)
		ElseIf (cAliasCCF)->CCF_TPCOMP == "2" //Complemento do processo referenciado - Administrativo
			Reg1020(aReg1020,,cAliasCCF)
		EndIF
	EndIF
Endif
Return

/*‘‹‘‹‘»±±
±±ºPrograma  RegimeCompºAutor  Erick G. Dias       º Data   02/07/2012 º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.     Gerao dos registros referente ao regime de competencia    º±±
±±º          consolidada.                                                º±±
±±Œ˜¹±±
±±ºParametros aRegF550 -> Array com informaµes do registro F550         º±±
±±º           aRegF560 -> Array com informaµes do registro F560         º±±
±±º           aRegM210 -> Array com informaµes do registro M210         º±±
±±º           aRegM610 -> Array com informaµes do registro M610         º±±
±±º           aPar     -> Array para gerao dos registros F550/F560     º±±
±±º           lPauta   -> Indica se © operao com paura.                º±±
±±º           aRegM400 -> Array com informaµes do registro M400         º±±
±±º           aRegM410 -> Array com informaµes do registro M410         º±±
±±º           aRegM800 -> Array com informaµes do registro M800         º±±
±±º           aRegM810 -> Array com informaµes do registro M810         º±±
±±º           lAchouCDG ->Indica se encontrou informao na tabela CDG   º±±
±±º           cAliasCDG ->Alias da tabela CDG                            º±±
±±º           lTop    -> Indica se est¡ gerando em base top.             º±±
±±º           aRegF559 -> Array com informaµes do registro F559         º±±
±±º           aRegF569 -> Array com informaµes do registro F569         º±±
±±º           aReg1010 -> Array com informaµes do registro 1010         º±±
±±º           aReg1020 -> Array com informaµes do registro 1020         º±±
±±º           aReg0500 -> Array com informaµes do registro 0500         º±±
±±º           lSemNota -> Indica se operao no possui vinculo com      º±±
±±º                       Documento fiscal.                              º±±
±±º           cAliasSFT -> Alias da tabela SFT                           º±±
±±º           aRegM230 -> Array com informaµes do registro M230         º±±
±±º           aRegM630 -> Array com informaµes do registro M630         º±±
±±º           aRegM220 -> Array com informaµes do registro M220         º±±
±±º           aRegM620 -> Array com informaµes do registro M620         º±±
±±º           aDevolucao -> Array com valores da devoluo de venda.     º±±
±±º           aDevMsmPer ->Array com valores da devoluo de venda do    º±±
±±º                        mesmo per­odo.                                º±±
±±º           cChaveCCX -> Chave para gerao de diferimento             º±±
±±º           nPosF500 -> Posio que foi gerado registro F550/F560      º±±
±±ˆ¼*/
Static Function RegimeComp(aRegF550,aRegF560,aRegM210,aRegM610,aPar,lPauta,aRegM400,aRegM410,aRegM800,aRegM810,lAchouCDG,cAliasCDG,lTop,;
						aRegF559,aRegF569,aReg1010,aReg1020,aReg0500,lSemNota,cAliasSFT,aRegM230,aRegM630,aRegM220,aRegM620,aDevolucao,;
						aDevMsmPer,cChaveCCX,nPosF500,nRecAuf)

Local nPosRetorn	:= 0
Local aParNaoTri	:= {}
Local cAliasCCF		:= ""
Local lAchouCCF		:= .F.
Local aParM200		:= {}
Local aParM600		:= {}

Default aPar		:= {}
Default lPauta		:= .F.
Default lAchouCDG	:= .F.
Default cAliasCDG	:= ""
Default lSemNota	:= .F.
Default cAliasSFT	:= ""
Default aRegM230	:= {}
Default aRegM630	:= {}
Default cChaveCCX	:= ""
Default nRecAuf := 0

If Len(aPar) > 0
	If lPauta
		//Para valores em percentuais ir¡ gerar registro F560
		RegF560(@aRegF560,aPar,@nPosRetorn)
	Else
		//Para valores de Pauta ser¡ gerado registro F550
		RegF550(@aRegF550,aPar,@nPosRetorn)
	EndIF
	nPosF500	:= nPosRetorn
	If lSemNota
		//Preenche array para gerao do registro M200 e filhos
		aParM200		:= {}
		aAdd(aParM200,aPar[3])  	//CST DE PIS
		aAdd(aParM200,aPar[6])  	//ALQUOTA DE PIS
		aAdd(aParM200,aPar[5]) 		//BASE DE CLCULO DE PIS
		aAdd(aParM200,aPar[2]) 		//TOTAL DA RECEITA
		aAdd(aParM200,aPar[7])		//VALOR DE PIS
		aAdd(aParM200,lPauta)		//Se trata valores de PAUTA

		//Gerao do registro M200 e filhos
		RegM210(@aRegM210,,,.T.,,,.T.,,@aRegM230,,,cChaveCCX,,,,aParM200,.F.)

		//Gerao do registro M600 e filhos
		aParM600		:= {}
		aAdd(aParM600,aPar[8])  	//CST DE COFINS
		aAdd(aParM600,aPar[11])  	//ALQUOTA DE COFINS
		aAdd(aParM600,aPar[10]) 	//BASE DE CLCULO DE COFINS
		aAdd(aParM600,aPar[2]) 		//TOTAL DA RECEITA
		aAdd(aParM600,aPar[12])		//VALOR DA COFINS
		aAdd(aParM600,lPauta)		//Se trata valores de PAUTA

		//Gerao do registro M600 e filhos
		RegM610(@aRegM610,,,.T.,,,.T.,,@aRegM630,,,cChaveCCX,,,,aParM600,.F.)

	Else
		RegM210(@aRegM210,cAliasSFT,,.T.,aDevolucao,@aRegM220,.F.,,@aRegM230,nRecAuf,,,,,,,.F.,aDevMsmPer)
		RegM610(@aRegM610,cAliasSFT,,.T.,aDevolucao,@aRegM620,.F.,,@aRegM630,nRecAuf,,,,,,,.F.,aDevMsmPer)
	EndIF

	//Tratamento para gerao dos registros M400/M410 para receitas no tributaveis
	IF aPar[3] $ "04/06/07/08/09" //.OR. (aPar[3] == "05" .AND. aPar[6] == 0)---//Retirada gerao do RegM400, devido a erro no validador.
		aParNaoTri	:= {}														//Pois o validador no esta entendendo que se trata de uma
		aAdd(aParNaoTri,aPar[3])												//operao tributada a aliquota zero.
		aAdd(aParNaoTri,aPar[2])
		aAdd(aParNaoTri,aPar[15])
		aAdd(aParNaoTri,aPar[17])
		aAdd(aParNaoTri,aPar[18])
		aAdd(aParNaoTri,aPar[19])
		aAdd(aParNaoTri,aPar[20])
		RegM400(@aRegM400,@aRegM410,,@aReg0500,,,,,aParNaoTri)
	EndIF

	//Tratamento para gerao dos registros M800/M810 para receitas no tributaveis
	IF aPar[8] $ "04/06/07/08/09" //.OR. (aPar[8] == "05" .AND. aPar[11] == 0)---//Retirada gerao do RegM800, devido a erro no validador.
		aParNaoTri	:= {}                                                        //Pois o validador no esta entendendo que se trata de uma
		aAdd(aParNaoTri,aPar[8])                                                 //operao tributada a aliquota zero.
		aAdd(aParNaoTri,aPar[2])
		aAdd(aParNaoTri,aPar[15])
		aAdd(aParNaoTri,aPar[17])
		aAdd(aParNaoTri,aPar[18])
		aAdd(aParNaoTri,aPar[19])
		aAdd(aParNaoTri,aPar[20])
		RegM800(@aRegM800,@aRegM810,,@aReg0500,,,,,aParNaoTri)
	EndIF

	IF lAchouCDG
		Do while !(cAliasCDG)->(EOF())

			If lTop
				cAliasCCF	:=cAliasCDG
				lAchouCCF	:= .T.
			Else
			 	lAchouCCF 	:= SPEDSeek("CCF",,xFilial("CCF")+ (cAliasCDG)->CDG_PROCES +(cAliasCDG)->CDG_TPPROC)
			EndIF

			If lPauta
				//Para valores de pauta ir¡ gerar Processo referenciado no registro F569
				RegF569 (@aRegF569,@aReg1010,@aReg1020,cAliasCDG,cAliasCCF,nPosRetorn,lAchouCCF)
			Else
				//Para valores de percentuais ir¡ gerar Processo referenciado no registro F559
				RegF559 (@aRegF559,@aReg1010,@aReg1020,cAliasCDG,cAliasCCF,nPosRetorn,lAchouCCF)
			EndIF

			(cAliasCDG)->(DBSKIP())
		EndDo
	EndIF

EndIF
Return


/*‘‹‘‹‘»±±
±±ºPrograma  Reg1900ComºAutor  Erick G. Dias        º Data  12/07/12	  º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.     Processamento do registro 1900 para regime de competencia   º±±
±±º          Consolidada.                                                º±±
±±ˆ¼±±*/
Static Function Reg1900Com (aReg1900, cEspecie, cConta, cSituaDoc,cCnpj,cSer, nValCont,cCstPis, cCstCoF, cCFOP, cInfComp, aRegNf, cAliasSFT)

Local nPos1900	:= 0
Local nPos		:= 0
Local cCOD_SIT  := Iif(!cSituaDoc $ "00/02","99",cSituaDoc)
Local nPosNf := 0
Local cChave1900 := ""

DEFAULT aRegNf := {}
DEFAULT cAliasSFT := ""

If !cSituaDoc == "05"

	cChave1900 := cCnpj + cEspecie + cSer + cCOD_SIT + cCstPis + cCstCof + cCFOP + cInfComp + cConta

	// Importante: Qualquer alteracao na chave do registro 1900 deve ser feita tambem na variavel cChave1900 p/ que a contagem de documentos fique correta.
	nPos1900 := aScan (aReg1900, {|aX| aX[2]==cCnpj .AND. aX[3]==cEspecie .AND. aX[4]==cSer .AND. aX[6]==cCOD_SIT .AND. aX[9]==cCstPis .AND. ;
					    aX[10]==cCstCoF .AND. aX[11]==cCFOP .AND. aX[12]==cInfComp .AND. aX[13]==cConta})

	If nPos1900 == 0
		aAdd(aReg1900, {})
		nPos := Len(aReg1900)
		aAdd (aReg1900[nPos], "1900")						//01-Registro
		aAdd (aReg1900[nPos], cCnpj)   						//02-CNPJ
		aAdd (aReg1900[nPos], cEspecie) //03-COD_MOD
		aAdd (aReg1900[nPos], cSer)	  						//04-SER
		aAdd (aReg1900[nPos], "")   						//05-SUB_SER
		aAdd (aReg1900[nPos], cCOD_SIT) //06-COD_SIT
		aAdd (aReg1900[nPos], nValCont)   					//07-VL_TOT_REC
		aAdd (aReg1900[nPos], "1")   						//08-QUANT_DOC
		aAdd (aReg1900[nPos], cCstPis)   					//09-CST_PIS
		aAdd (aReg1900[nPos], cCstCoF)   					//10-CST_COFINS
		aAdd (aReg1900[nPos], cCFOP)  	  					//11-CFOP
		aAdd (aReg1900[nPos], cInfComp)						//12-INF_COMPL
		aAdd (aReg1900[nPos], cConta)  						//13-COD_CTA

		// Necessario verificar se o cAliasSFT foi passado, pois a SFT no est¡ dispon­vel em todas as chamadas do Reg1900Com.
		// Validacao para que seja exibido no campo 08 a quantidade de DOCUMENTOS, e no de itens.
		If cAliasSFT <> ""
			nPosNf	:= aScan(aRegNf, {|aX| aX[1] == (cAliasSFT)->FT_NFISCAL .AND. aX[2] == (cAliasSFT)->FT_SERIE .AND. aX[3] == (cAliasSFT)->FT_ESPECIE  .AND. aX[4] == (cAliasSFT)->FT_CLIEFOR .AND. aX[5] == cChave1900})

			If nPosNf == 0
				aAdd(aRegNf, {})
				nPosNf := Len(aRegNf)
				aAdd (aRegNf[nPosNf], (cAliasSFT)->FT_NFISCAL)
				aAdd (aRegNf[nPosNf], (cAliasSFT)->FT_SERIE)
				aAdd (aRegNf[nPosNf], (cAliasSFT)->FT_ESPECIE)
				aAdd (aRegNf[nPosNf], (cAliasSFT)->FT_CLIEFOR)
				aAdd (aRegNf[nPosNf], cChave1900)
			EndIf
		EndIf
	Else
		aReg1900[nPos1900][7]	+= nValCont					//07-VL_TOT_REC

		If cAliasSFT <> ""
			nPosNf	:= aScan(aRegNf, {|aX| aX[1] == (cAliasSFT)->FT_NFISCAL .AND. aX[2] == (cAliasSFT)->FT_SERIE .AND. aX[3] == (cAliasSFT)->FT_ESPECIE  .AND. aX[4] == (cAliasSFT)->FT_CLIEFOR .AND. aX[5] == cChave1900 } )

			If nPosNf == 0

				aReg1900[nPos1900][8]	:=	cvaltochar(val(aReg1900[nPos1900][8]) +=1) //08-QUANT_DOC

				aAdd(aRegNf, {})
				nPosNf := Len(aRegNf)
				aAdd (aRegNf[nPosNf], (cAliasSFT)->FT_NFISCAL)
				aAdd (aRegNf[nPosNf], (cAliasSFT)->FT_SERIE)
				aAdd (aRegNf[nPosNf], (cAliasSFT)->FT_ESPECIE)
				aAdd (aRegNf[nPosNf], (cAliasSFT)->FT_CLIEFOR)
				aAdd (aRegNf[nPosNf], cChave1900)
			EndIf
		Else
			aReg1900[nPos1900][8]	:=	cvaltochar(val(aReg1900[nPos1900][8]) +=1) //08-QUANT_DOC
		EndIf
	EndIf
EndIf
Return

/*‰‘‹‘‹‘»±±
±±ºPrograma  ProceReferºAutor  Erick G. Dias       º Data   12/07/2012 º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.     Processamento do registro referente a processo referenciado º±±
±±ˆ¼±±*/
static Function ProceRefer(aRegX, nPosPai,aReg1010,aReg1020,cRegistro)

Local	aAreaCDG	:=	CDG->(GetArea())
Local	lRet		:=	.T.
Local	nPosX		:=	1
Local   cChave      := ''
Local   nPos        := 0
Local   lAchouCCF	:=.F.

cChave := CDG->CDG_FILIAL+CDG->CDG_TPMOV+CDG->CDG_DOC+CDG->CDG_SERIE+CDG->CDG_CLIFOR+CDG->CDG_LOJA

Do while !CDG->(Eof()) .And. CDG->CDG_FILIAL+CDG->CDG_TPMOV+CDG->CDG_DOC+CDG->CDG_SERIE+CDG->CDG_CLIFOR+CDG->CDG_LOJA==cChave
	If ((nPos:=aScan(aRegX,{|aX| ax[1] == nPosPai .AND. aX[3]==CDG->CDG_PROCES}))==0)
		aAdd(aRegX, {})
		nPosX := Len(aRegX)
		aAdd (aRegX[nPosX], nPosPai)				//Relacionamento com o registro pai
		aAdd (aRegX[nPosX], cRegistro)				//01 - REG
		aAdd (aRegX[nPosX], CDG->CDG_PROCES)		//02 - NUM_PROC
		aAdd (aRegX[nPosX], CDG->CDG_TPPROC)		//03 - IND_PROC

		lAchouCCF	:=	CCF->(MsSeek (xFilial ("CCF")+ CDG->CDG_PROCES +CDG->CDG_TPPROC))
		If	lAchouCCF
			If CCF->CCF_TPCOMP == "1" //Complemento do processo referenciado - Judicial
				Reg1010(aReg1010)
			ElseIf CCF->CCF_TPCOMP == "2" //Complemento do processo referenciado - Administrativo
				Reg1020(aReg1020)
			EndIF
		EndIf
	Else // Posiciona sempre no ultimo processo referenciado
 		aRegX[nPos,1] := nPosPai
	Endif
	CDG->(DbSkip())
Enddo

RestArea(aAreaCDG)

Return (lRet)
/*‘‹‘‹‘»±±
±±ºPrograma  MsgJobSPC ºAutor  Gustavo G. Rueda    º Data   28/06/2012 º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Funcao generica para gerar counout no server no caso de    º±±
±±º            execucao via JOB                                          º±±
±±ˆ¼*/
Static Function MsgJobSPC( cMsg )
	ConOut( "SPEDPISCOF.PRW: " + DToS( Date() ) + "-" + Time() + "-" + OemToAnsi(cMsg))
Return

/*‘‹‘‹‘»±±
±±ºPrograma  MajAliqValºAutor  Vitor Felipe        º Data   24/05/2012 º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Funcao que retira o Valor e Aliquotas Majorados do COFINS  º±±
±±º           das operacoes de entrada este valor nao direito a credito  º±±
±±º			   e nao eh levado ao SPED 			      				  º±±
±±ˆ¼*/

static Function MajAliqVal(nAliqCof,nValCof,cAliasM,lCpoMajAli,lPosSD1)

Default nAliqCof 	:= 0
Default nValCof 	:= 0
Default cAliasM	 	:= "SFT"
Default lPosSD1		:= .F.
Default lCpoMajAli 	:= aFieldPos[15] .And. aFieldPos[16]

If lCpoMajAli .and. !lPosSD1
	If nAliqCof > 0 .And. (cAliasM)->FT_MALQCOF > 0 .And. nAliqCof >= (cAliasM)->FT_MALQCOF
		nAliqCof -= (cAliasM)->FT_MALQCOF
	EndIf
	If nValCof > 0 .And. (cAliasM)->FT_MVALCOF > 0 .And. nValCof >= (cAliasM)->FT_MVALCOF
		nValCof	-= (cAliasM)->FT_MVALCOF
	EndIf
ElseIf lCpoMajAli .and. lPosSD1
	If nAliqCof > (cAliasM)->D1_ALQCOF
		nValCof	 := (nValCof / nAliqCof) * 100
		nAliqCof := (cAliasM)->D1_ALQCOF
		nValCof	 := nValCof * ( nAliqCof/100 )
	EndIf
EndIf

Return

/*‘‹‘‹‘»±±
±±ºPrograma  MajAliqPISºAutor  Wemerson Randolfo  º Data   02/07/2013 º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Funcao que retira o Valor e Aliquotas Majorados do PIS    º±±
±±º            da operacoes de entrada este valor nao direito a credito º±±
±±º			   e nao eh levado ao SPED    							       	 º±±
±±ˆ¼*/

static Function MajAliqPIS(nAliqPis,nValPis,cAliasSFT,lPosSD1)

Local lCpoMajAli 	:= aFieldPos[28] .And. aFieldPos[29]

Default nAliqPis 	:= 0
Default nValPis 	:= 0
Default cAliasSFT   := "SFT"
Default lPosSD1		:= .F.

If lCpoMajAli .and. !lPosSD1
	If nAliqPis > 0 .And. (cAliasSFT)->FT_MALQPIS > 0 .And. nAliqPis >= (cAliasSFT)->FT_MALQPIS
		nAliqPis -= (cAliasSFT)->FT_MALQPIS
	EndIf
	If nValPis > 0 .And. (cAliasSFT)->FT_MVALPIS > 0 .And. nValPis >= (cAliasSFT)->FT_MVALPIS
		nValPis	-= (cAliasSFT)->FT_MVALPIS
	EndIf
ElseIf lCpoMajAli .and. lPosSD1
	If nAliqPis > (cAliasSFT)->D1_ALQPIS
		nValPis	 := (nValPis / nAliqPis) * 100
		nAliqPis := (cAliasSFT)->D1_ALQPIS
		nValPis	 := nValPis * ( nAliqPis/100 )
	EndIf
EndIf

Return



/*‘‹‘‹‘»±±
±±ºPrograma  IniCF4    ºAutor  TOTVS SA            º Data   28/06/2012 º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Funcao para limpar a tabela CF4 antes do processamento do  º±±
±±º            per­odo                                                   º±±
±±Œ˜¹±±
±±ºParametros cMsg -> Mensagem a ser impressa                            º±±
±±Œ˜¹±±
±±ºRetorno    Nil                                                        º±±
±±Œ˜¹±±
±±ºUso        SPEDPISCOF                                                 º±±
±±ˆ¼*/
Static Function IniCF4(cDtAlt)

If !Empty(cDtAlt)
	dbSelectArea("SIX")
	SIX->(DbSetOrder(1))
	If SIX->(MsSeek("CF42"))
		DbSelectArea ("CF4")
		CF4->(DbSetOrder (2))
		CF4->(DbGoTop ())
		If CF4->( MsSeek(xFilial("CF4")+cDtAlt) )
			Do While CF4->( !Eof() .And. CF4_FILIAL==xFilial("CF4") .And. CF4_DTALT==cDtAlt )
				RecLock("CF4",.F.)
				CF4->(dbDelete())
				MsUnLock()
				CF4->(FKCommit())
				CF4->(DbSkip ())
			EndDo
		EndIf
	EndIf
EndIf

Return

/*‘‹‘‹‘»±±
±±ºPrograma  ProcDifer ºAutor  Luccas Curcio       º Data   10/09/2012 º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Funcao que processa os valores de Diferimento a partir     º±±
±±º            da execucao do Pre-processamento do SPED                  º±±
±±ˆ¼*/
Static Function ProcDifer(dDataDe,aDifer,aDiferAnt)
Local	cAlsCFA		:=	"CFA"
Local	cAlsCFB		:=	"CFB"
Local	cPeriod		:=	Substr(DTOS(dDataDe),5,2)+Substr(DTOS(dDataDe),1,4)
Local	cDtPgto		:=	""
Local   cCodCrdPis	:= ""
Local   cCodCrdCof	:= ""
Local	lAchouCFA	:=	.F.
Local	lAchouCFB	:=	.F.
Local	aTpContr	:=	{"PIS","COF"}
Local	nPos		:=	0
Local	nX			:=	0

For nX := 1 To Len(aTpContr)

	If (lAchouCFA := SPEDFFiltro(1,"CFA",@cAlsCFA,{cPeriod,aTpContr[nX]}))

		Do While !(cAlsCFA)->(Eof())

			//š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
			//Posicoes do Array aDifer:              
			//01-CNPJ do cliente Orgao publico       
			//02-Valor total de venda no periodo     
			//03-Valor total nao recebido no periodo 
			//04-Valor de PIS diferido               
			//05-Valor da Cofins diferido            
			//06-Codigo da Contribuicao              
			//07-Valor do Cr©dito de PIS Diferido    
			//08-Valor do Cr©dito de COF Diferido    
			//09-Codigo BAse Cred PIS                
			//10-Codigo BAse Cred COF                
			//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™

			cCodCrdPis := Iif(aTpContr[nX]=="PIS",(cAlsCFA)->CFA_CODCRE,"")
			cCodCrdCof := Iif(aTpContr[nX]=="COF",(cAlsCFA)->CFA_CODCRE,"")

			If (nPos := aScan(aDifer,{|x| x[1]+x[6]+[9]+[10] == (cAlsCFA)->(CFA_CNPJ+CFA_CODCON)+cCodCrdPis+cCodCrdCof})) > 0

			    //š„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„¿
				//Apenas somo os valores Totais quando for PIS, pois senao ira duplicar esses valores.	
				//€„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„„™
				If aTpContr[nX] == "PIS"
					aDifer[nPos][2]	+=	(cAlsCFA)->CFA_TOTVEN
					aDifer[nPos][3]	+=	(cAlsCFA)->CFA_VLNREC
					aDifer[nPos][4]	+=	(cAlsCFA)->CFA_CONDIF
					aDifer[nPos][7]	+=	(cAlsCFA)->CFA_CREDIF
				Else
					aDifer[nPos][5]	+=	(cAlsCFA)->CFA_CONDIF
					aDifer[nPos][8]	+=	(cAlsCFA)->CFA_CREDIF
				Endif
			Else
				aAdd(aDifer, {})
				nPos := Len(aDifer)
				aAdd (aDifer[nPos],(cAlsCFA)->CFA_CNPJ)								//CNPJ do cliente rgo pºblico.
				aAdd (aDifer[nPos],(cAlsCFA)->CFA_TOTVEN)								//Valor total de venda no per­odo.
				aAdd (aDifer[nPos],(cAlsCFA)->CFA_VLNREC)								//Valor total no recebido no per­odo.
				aAdd (aDifer[nPos],Iif(aTpContr[nX]=="PIS",(cAlsCFA)->CFA_CONDIF,0))	//Valor de PIS diferido.
				aAdd (aDifer[nPos],Iif(aTpContr[nX]=="COF",(cAlsCFA)->CFA_CONDIF,0))	//Valor da Cofins diferido.
				aAdd (aDifer[nPos],(cAlsCFA)->CFA_CODCON)								//Cdigo da Contribuio.

				aAdd (aDifer[nPos],Iif(aTpContr[nX]=="PIS",(cAlsCFA)->CFA_CREDIF,0))								//Valor do Cr©dito de PIS Diferido
				aAdd (aDifer[nPos],Iif(aTpContr[nX]=="COF",(cAlsCFA)->CFA_CREDIF,0))								//Valor do Cr©dito de COF Diferido
				aAdd (aDifer[nPos],Iif(aTpContr[nX]=="PIS",(cAlsCFA)->CFA_CODCRE,""))								//Codigo BAse Cred PIS
				aAdd (aDifer[nPos],Iif(aTpContr[nX]=="COF",(cAlsCFA)->CFA_CODCRE,""))								//Codigo BAse Cred COF
			Endif

			(cAlsCFA)->(DbSkip())
		Enddo
	Endif

	If lAchouCFA
		SPEDFFiltro(2,,cAlsCFA)
	Endif

	If (lAchouCFB := SPEDFFiltro(1,"CFB",@cAlsCFB,{cPeriod,aTpContr[nX]}))

		Do While !(cAlsCFB)->(Eof())

			cDtPgto	:=	SubStr((cAlsCFB)->CFB_DTPGTO,7,2)+SubStr((cAlsCFB)->CFB_DTPGTO,5,2)+SubStr((cAlsCFB)->CFB_DTPGTO,1,4)


			//Posiµes do Array aDiferAnt:    
			//01-Cdigo da Contribuio       
			//02-Valor de PIS diferido        
			//03-Valor de COFINS diferido     
			//04-Per­odo de apurao          
			//05-Data de recebimento.         
			//06-Al­quota de PIS.             
			//07-Al­quota de COFINS.          
			//08-Cr©dito do PIS.              
			//09-Credito de COFINS.           
			//10-Natureza do Credito          

			If aTpContr[nX] == "PIS"
	        	nPos := aScan(aDiferAnt,{	|x| x[1]+x[4]==(cAlsCFB)->(CFB_CODCON+CFB_PERDIF) .And.;
	        								 x[5]==cDtPgto .AND. x[10]==(cAlsCFB)->CFB_NATCRE})
	  		Else
	  			nPos := aScan(aDiferAnt,{	|x| x[1]+x[4]==(cAlsCFB)->(CFB_CODCON+CFB_PERDIF) .And.;
	        								 x[5]==cDtPgto .AND. x[10]==(cAlsCFB)->CFB_NATCRE})
	    	Endif

	    	If nPos > 0

	    		If aTpContr[nX] == "PIS"
	    			aDiferAnt[nPos][2]	+=	(cAlsCFB)->CFB_CONREC
	    			aDiferAnt[nPos][8]	+=	(cAlsCFB)->CFB_CREDES

	    			If Empty(aDiferAnt[nPos][7])
	    				aDiferAnt[nPos][7]	:=	(cAlsCFB)->CFB_ALIQ
	    			Endif

	    		Else
	    			aDiferAnt[nPos][3]	+=	(cAlsCFB)->CFB_CONREC
	    			aDiferAnt[nPos][9]	+=	(cAlsCFB)->CFB_CREDES

	    			If Empty(aDiferAnt[nPos][7])
	    				aDiferAnt[nPos][7]	:=	(cAlsCFB)->CFB_ALIQ
	    			Endif

	    		Endif
	    	Else
	    		aAdd(aDiferAnt, {})
				nPos := Len(aDiferAnt)
				aAdd (aDiferAnt[nPos],(cAlsCFB)->CFB_CODCON)   							//Cdigo da Contribuio.
				aAdd (aDiferAnt[nPos],Iif(aTpContr[nX]=="PIS",(cAlsCFB)->CFB_CONREC,0))	//Valor de PIS recolhido.
				aAdd (aDiferAnt[nPos],Iif(aTpContr[nX]=="COF",(cAlsCFB)->CFB_CONREC,0))	//Valor de COFINS recolhido.
				aAdd (aDiferAnt[nPos],(cAlsCFB)->CFB_PERDIF)								//Per­odo de diferimento.
				aAdd (aDiferAnt[nPos],cDtPgto)												//Data de recebimento.
				aAdd (aDiferAnt[nPos],Iif(aTpContr[nX]=="PIS",(cAlsCFB)->CFB_ALIQ,0))		//Al­quota de PIS
				aAdd (aDiferAnt[nPos],Iif(aTpContr[nX]=="COF",(cAlsCFB)->CFB_ALIQ,0))		//Al­quota de COFINS
				aAdd (aDiferAnt[nPos],Iif(aTpContr[nX]=="PIS",(cAlsCFB)->CFB_CREDES,0))	//Cred Desc Pis
				aAdd (aDiferAnt[nPos],Iif(aTpContr[nX]=="COF",(cAlsCFB)->CFB_CREDES,0))	//Cred Desc Cof
				aAdd (aDiferAnt[nPos],(cAlsCFB)->CFB_NATCRE)								//Natureza do Credito
			Endif

			IF aDiferAnt[nPos][2] < aDiferAnt[nPos][8]
				aDiferAnt[nPos][8]:= aDiferAnt[nPos][2]
			EndiF

			IF aDiferAnt[nPos][3] < aDiferAnt[nPos][9]
				aDiferAnt[nPos][9]:= aDiferAnt[nPos][3]
			EndiF

			(cAlsCFB)->(DbSkip())
		Enddo
	Endif

	If lAchouCFB
		SPEDFFiltro(2,,cAlsCFB)
	Endif
Next nX

Return


/*‘‹‘‹‘»±±
±±ºPrograma  AcumumF600Microsiga                    º Data   11/08/12   º±±
±±Œ˜ŠŠ¹±±
*/
Static Function AcumumF600(aF600Tmp,aF600Aux)

Local nPosF600 := 0
Local nPos     := 0
Local cRegime := ""

cRegime:= ""
If aF600Aux[5] == "0"
	cRegime := "1"
ElseIf aF600Aux[5] == "1"
	cRegime := "0"
EndIF

nPosF600 := aScan (aF600Tmp, {|aX| aX[2]==aF600Aux[1]  .AND. ax[3] == Substr(aF600Aux[2],7,2) + Substr(aF600Aux[2],5,2)  + Substr(aF600Aux[2],1,4)   .AND. ax[7] == cRegime .AND. ax[8] == aF600Aux[6]  .AND. ax[11] == aF600Aux[9]})
IF nPosF600 ==0
	aAdd(aF600Tmp, {})
	nPos := Len(aF600Tmp)
	aAdd (aF600Tmp[nPos], "F600")						   	//01 - REG
	aAdd (aF600Tmp[nPos], aF600Aux[1])				//02 - IND_NAT_RET
	aAdd (aF600Tmp[nPos],  Substr(aF600Aux[2],7,2) + Substr(aF600Aux[2],5,2)  + Substr(aF600Aux[2],1,4) )				//03 - DT_RET
	aAdd (aF600Tmp[nPos], aF600Aux[3])				//04 - VL_BC_RET
	aAdd (aF600Tmp[nPos], aF600Aux[4])				//05 - VL_RET
	aAdd (aF600Tmp[nPos], "")						   		//06 - COD_REC
	aAdd (aF600Tmp[nPos], cRegime)				//07 - IND_NAT_REC
	aAdd (aF600Tmp[nPos], aF600Aux[6])				//08 - CNPJ
	aAdd (aF600Tmp[nPos], aF600Aux[7])				//09 - VL_RET_PIS
	aAdd (aF600Tmp[nPos], aF600Aux[8])				//10 - VL_RET_COFINS
	aAdd (aF600Tmp[nPos], aF600Aux[9])				//11 - IND_REC
Else
	aF600Tmp[nPosF600][9]  += aF600Aux[7]			//09 - VL_RET_PIS
	aF600Tmp[nPosF600][10] += aF600Aux[8]			//10 - VL_RET_COFINS
	aF600Tmp[nPosF600][5]  += aF600Aux[4]			//05 - VL_RET
EndIF

Return

/*‘‹‘‹‘»±±
±±ºPrograma  FGetIndicsºAutor  Demetrio De Los Riosº Data   09/19/12   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.     Executa todos os AliasIndic utilizados na rotina afim de    º±±
±±º          criar um cache de informacoes e assim melhor performance    º±±
±±Œ˜¹±±
±±ºUso        SPEDPISCOF                                                 º±±
±±ˆ¼±±
*/
Static Function FGetIndics()
Local aRet := {	    AliasIndic("AIF"),;	//01
					AliasIndic("CCW"),;	//02
					AliasIndic("CCX"),; //03
				 	AliasIndic("CCY"),; //04
				 	AliasIndic("CCZ"),; //05
				 	AliasIndic("CD3"),; //06
				 	AliasIndic("CD4"),; //07
				 	AliasIndic("CD5"),; //08
				 	AliasIndic("CD6"),; //09
				 	AliasIndic("CDG"),; //10
				 	AliasIndic("CDN"),; //11
				 	AliasIndic("CDT"),; //12
				 	AliasIndic("CE9"),; //13
				 	AliasIndic("CF2"),; //14
				 	AliasIndic("CF3"),; //15
				 	AliasIndic("CF4"),; //16
				 	AliasIndic("CF5"),; //17
				 	AliasIndic("CF6"),; //18
				 	AliasIndic("CF7"),; //19
				 	AliasIndic("CF8"),; //20
				 	AliasIndic("CF9"),; //21
				 	AliasIndic("CG1"),; //22
				 	AliasIndic("CG4"),; //23
				 	AliasIndic("CVB"),; //24
				 	AliasIndic("SFU"),; //25
				 	AliasIndic("SFV"),; //26
				 	AliasIndic("SFW"),; //27
				 	AliasIndic("SFX"),; //28
				 	AliasIndic("CFA"),; //29
				 	AliasIndic("CFB"),; //30
				 	AliasIndic("CD1"),;	//31
				 	AliasIndic("CKN"),;	//32
					AliasIndic("CDC")}	//33
Return aRet

/*‘‹‘‹‘»±±
±±ºPrograma  SPEDPISCOFºAutor  Demetrio De Los Riosº Data   09/19/12   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.     Executa todos os ExistBlock utilizados na rotina afim de    º±±
±±º          criar um cache de informacoes e assim melhor performance    º±±
±±Œ˜¹±±
*/
Static Function FGetExstBlck()

Local aRet := { ExistBlock("SPDFIS06"),;	// 01
				ExistBlock("SPDFIS02"),;	// 02
				ExistBlock("SPEDPROD"),;	// 03
				ExistBlock("SPDPIS09"),;	// 04
				ExistBlock("SPDPISTR"),;	// 05
				ExistBlock("SPDPIS06"),;	// 06
				ExistBlock("SPDPCANT"),;	// 07
				ExistBlock("SPDPISIC"),;	// 08
				ExistBlock("SPDIMP"),;		// 09
				ExistBlock("SPDPCIMOB"),;	// 10
				ExistBlock("SPDPC1800"),;	// 11
				ExistBlock("SPDPCD"),; 		// 12
				ExistBlock("SPDFIS001"),;	// 13
				ExistBlock("SPDPIS07"),;	// 14
				ExistBlock("SPDPIS05"),;	// 15
				ExistBlock("SPDPIS08"),;	// 16
				ExistBlock("SPDFIS04"),;	// 17
				ExistBlock("SPDFIS03"),;	// 18
				ExistBlock("SPDRECBRUT"),;	// 19
				ExistBlock("SPDPC0140"),;	// 20
				ExistBlock("SPDPIS61"),;	// 21
				ExistBlock("SPDPIS65"),;	// 22
				ExistBlock("SPEDCP210"),;	// 23
				ExistBlock("SPED0150")}	// 24
Return aRet
/*‘‹‘‹‘»±±
±±ºPrograma  SPEDPISCOFºAutor  Demetrio De Los Riosº Data   09/19/12   º±±
±±Œ˜ŠŠ¹±±
±±ºDesc.      Funcao criada para carregar (cache) das informacoes de     º±±
±±º           AliasIndic (FGetIndics) e ExistBlocks (FGetExstBlock)      º±±
±±Œ˜¹±±
*/
Static Function SpdCLCache()
// Alimenta array STATIC

aIndics		:= FGetIndics()
aExstBlck		:= FGetExstBlck()
aFieldPos		:= FGetCpo()
aParSX6		:= FGetSx6()
Return .T.

Static Function FGetSx6()
Local aRet	:= {}
Local nX	:= 0

Local aParam 	:= {	{"MV_HISTTAB",	.F.	   		} ,;	//   01
						{"MV_CF3ENTR",	.T.    		} ,; 	//	 02
						{"MV_ESTTELE",	.F.    		} ,; 	//	 03
						{"MV_RESF3FT",	.F.    		} ,; 	//	 04
						{"MV_SPEDAZ",		.F.    		} ,; 	//	 05
						{"MV_SKPENC",		.F.    		} ,; 	//	 06
						{"MV_SPEDCSC",	.F.    		} ,; 	//	 07
						{"MV_CPPCAGR",	.F.    		} ,; 	//	 08
						{"MV_SPCBPRH",	.F.    		} ,; 	//	 09
						{"MV_SPCBPSE",	""    		} ,; 	//	 10
						{"MV_SPEDNAT",	.F.    		} ,; 	//	 11
						{"MV_M996TPR",	1    		} ,; 	//	 12
						{"MV_VALEXCL",	.F.    		} ,; 	//	 13
						{"MV_RATPROP",	.F.    		} ,; 	//	 14
						{"MV_STUF",		""    		} ,; 	//	 15
						{"MV_STUFS",		""    		} ,; 	//	 16
						{"MV_EASY",		""    		} ,; 	//	 17
						{"MV_SPDGRNF",	.F.    		} ,; 	//	 18
						{"MV_1DUPREF",	""    		} ,; 	//	 19
						{"MV_2DUPREF",	""    		} ,; 	//	 20
						{"MV_SPDCGPP",	.T.    		} ,; 	//	 21
						{"MV_GRBLOCM",	.T.    		} ,; 	//	 22
						{"MV_USACF7",		.F.    		} ,; 	//	 23
						{"MV_SPDCSEG",	""    		} ,; 	//	 24
						{"MV_SPDCQTH",	0    		} ,; 	//	 25
						{"MV_SPDCGPC",	.T.    		} ,; 	//	 26
						{"MV_COFLSPD",	.T.    		} ,; 	//	 27
						{"MV_ESTADO",		""    		} ,; 	//	 28
						{"MV_FILSCP",		.F.    		} ,; 	//	 29
						{"MV_STNIEUF",	""    		} ,; 	//	 30
						{"MV_ICMPAD",		18    		} ,; 	//	 31
						{"MV_DESBASC",	"1"    		} ,; 	//	 32
						{"MV_C140TIT",	""    		} ,; 	//	 33
						{"MV_CONTZF",		.F.    		} ,; 	//	 34
						{"MV_STFRETE",	.F.    		} ,; 	//	 35
						{"MV_PERCAPD",	{{0,0,0}}	} ,; 	//	 36
						{"MV_CODTPCR",	"201#202#203#204#208#301#302#303#304#307#308"	} ,; 	//	 37
						{"MV_CODTPCC",	"301#302#303#304#308"	} ,; 	//	 38
						{"MV_RECBNAT",	"{}"    		} ,; 	//	 39
						{"MV_CAJCPPC",	"03"    		} ,; 	//	 40
						{"MV_DAPCCPA",	"Cr©dito presumido conforme lei 12.058/2009 e IN Instruo Normativa RFB nº 977, de 14 de dezembro de 2009"    		} ,; 	//	 41
						{"MV_ACPPCAG",	{{0.8520,3.8}}    		} ,; 	//	 42
						{"MV_NMCSPC",		12    		} ,; 	//	 43
						{"MV_SPDAJCA",	CTOD("01/01/2011")    		} ,; 	//	 44
						{"MV_CFOTELE",	.F.    		},;		//45
						{"MV_BLOCPMT",    .F.       },;		//46
						{"MV_CODREC",  "{'810902','691201','217201','585601'}" },;		//47
						{"MV_NFCOMPL", .T.			}}			//	 48

For nX:=1 to Len(aParam)
	aAdd(aRet , GetNewPar((aParam[nX,1]),aParam[nX,2])  )
Next nX

Return aRet

Static Function FGetCpo()

Local nX		:= 0
Local aAlias	:= {}
Local aRet	:= {}
Local aCpo := {{"SF2","F2_NFCUPOM"},;		//01
					{"SF1","F1_TPCTE"},;		//02
					{"SFT","FT_NATOPER"},;	//03
					{"SFT","FT_VRETPIS"},;	//04
					{"SFT","FT_VRETCOF"},;	//05
					{"SD2","D2_VALPIS"},;	//06
					{"SD2","D2_VALCOF"},;	//07
					{"SFT","FT_DESCICM"},;	//08
					{"SFT","FT_DESCZFR"},;	//09
					{"SFT","FT_CHVNFE"},;	//10
					{"CDT","CDT_INDFRT"},;	//11
					{"SA1","A1_TPREG"},;		//12
					{"SFT","FT_CODNFE"},;	//13
					{"SF1","F1_TPFRETE"},;	//14
					{"SFT","FT_MALQCOF"},;	//15
					{"SFT","FT_MVALCOF"},;	//16
					{"SB5","B5_TABINC"},;	//17
					{"SB5","B5_CODGRU"},;	//18
					{"SB5","B5_MARCA"},;		//19
					{"SFT","FT_PAUTPIS"},;	//20
					{"SFT","FT_PAUTCOF"},;	//21
					{"SB1","B1_TPREG"},;		//22
					{"SLG","LG_SERPDV"},;	//23
					{"SFT","FT_RGESPST"},;	//24
					{"SFT","FT_PAUTIPI"},;	//25
					{"SFT","FT_AGREG"},;		//26
					{"SFT","FT_NFELETR"},;	//27
					{"SFT","FT_MALQPIS"},;	//28
					{"SFT","FT_MVALPIS"},;	//29
					{"SFT","FT_NATOPER"},;	//30
					{"SB1","B1_TPREG"},;		//31
					{"CF3","CF3_NFORI"},;	//32
					{"CF3","CF3_NFDEV"},;	//33
					{"CVB","CVB_CPF"},;		//34
					{"CVB","CVB_CODMUN"},;	//35
					{"SF4","F4_MOVFIS"},;	//36
					{"CD5","CD5_ACDRAW"},;	//37
					{"SFX","FX_ESTREC"},;	//38
					{"CF8","CF8_TNATRE"},;	//39
					{"CD5","CD5_DTPPIS"},;	//40
					{"CD5","CD5_DTPCOF"},;	//41
					{"CD5","CD5_LOCAL"},;	//42
					{"CF8","CF8_RECBRU"},;	//43
					{"SA4","A4_CODPAIS"},;	//44
					{"SS4","A4_COD_MUN"},;	//45
					{"SA4","A4_SUFRAMA"},;	//46
					{"CCY","CCY_ANO"},;		//47
					{"CCY","CCY_MES"},;		//48
					{"CCY","CCY_UTIANT"},;	//49
					{"CG4","CG4_COD"},;		//50
					{"CG4","CG4_PER"},;		//51
					{"CCY","CCY_REANTE"},;	//52
					{"CCY","CCY_COANTE"},;	//53
					{"CCY","CCY_CNPJ"},;		//54
					{"CCY","CCY_ORICRE"},;	//55
					{"CCY","CCY_LEXTEM"},;	//56
					{"CCW","CCW_ANO"},;		//57
					{"CCW","CCW_MES"},;		//58
					{"CCW","CCW_UTIANT"},;	//59
					{"CCW","CCW_REANTE"},;	//60
					{"CCW","CCW_COANTE"},;	//61
					{"CCW","CCW_CNPJ"},;		//62
					{"CCW","CCW_ORICRE"},;	//63
					{"CCW","CCW_LEXTEM"},;	//64
					{"CF8","CF8_PART"},;		//65
					{"CE9","CE9_EXGPIS"},;	//66
					{"CE9","CE9_EXEPIS"},;	//67
					{"CE9","CE9_EXGCOF"},;	//68
					{"CE9","CE9_EXECOF"},;	//69
					{"CF2","CF2_CMPDED"},;	//70
					{"CF6","CF6_CNPJ"},;	//71
					{"SFT","FT_INDNTFR"},; //72
					{"SFV","FV_FILIAL"},; //73
					{"SFV","FV_APURPER"},; //74
					{"SFV","FV_MESANO"},;  //75
					{"SFW","FW_FILIAL"},;   // 76
					{"SFT","FT_CODBCC"},;	 //77
					{"CF5","CF5_BSCALC"},;	 //78
					{"CF5","CF5_ALIQ"},;	 //79
					{"CF5","CF5_CODCTA"},;	 //80
					{"CF5","CF5_INFCOM"},;	 //81
					{"CF5","CF5_CST"},;	 	//82
					{"SF1","F1_MENNOTA"},;	 //83
					{"SF2","F2_MENNOTA"},; // 84
					{"SN1","N1_CBCPIS"},;	//85
					{"CDT","CDT_SITEXT"},;	//86
					{"CDT","CDT_DTAREC"},;	//87
					{"CCY","CCY_RESCRE"},;	//88
					{"CCW","CCW_RESCRE"}}	//89

For nX := 1 to Len(aCpo)
	nPos := aScan( aAlias , {|x| x[1] == aCpo[nX,01] } )
	If nPos == 0
		aAdd( aAlias , { aCpo[nX,01] , AliasIndic(aCpo[nX,01]) } )
		nPos := Len(aAlias)
    EndIf
	aAdd(aRet , IIf( aAlias[nPos,02] .And. (aCpo[nX,01])->(FieldPos(aCpo[nX,02])) > 0 , .T. , .F. ) )
Next nX

Return aRet

//-------------------------------------------------------------------
/*/Funo SpdSort
Ir¡ ordenar o array auxiliar dos valores do registro M105/M505 seguindo a ordem dos cdigos
de cr©ditos conforme ordem informada pelo cliente.
/*/
//-------------------------------------------------------------------
Static Function SpdSort(aRegPri,aRegOrd,nPosPri)

Local nCont1 := 0
Local nCont2 := 0
Local aRegTemp	:= {}
Local cOrd	:= ""

For nCont1:= 1 to len(aRegOrd)
	For nCont2:= 1 to len(aRegPri)
		If aRegPri[nCont2][nPosPri] == aRegOrd[nCont1]
			aAdd(aRegTemp, aRegPri[nCont2])
			cOrd := cOrd+aRegOrd[nCont1]+"/"
		EndIF
	Next nCont2

Next nCont1

For nCont2:= 1 to len(aRegPri)
	If !aRegPri[nCont2][nPosPri] $ cOrd
		aAdd(aRegTemp, aRegPri[nCont2])
	EndIF
Next nCont2

aRegPri :=aRegTemp

Return

//-------------------------------------------------------------------
/*/Funo PCCredAnt
Ir¡ Processar os valores de cr©ditos de per­odos anteriores de PIS e COFINS, considerando
a ordem dos cdigos de cr©dito da tabela 4.3.6.
/*/
//-------------------------------------------------------------------
Static Function PCCredAnt(cPer,aReg1100,aReg1500,nTotContrb,cTributo)

Local nCont			:= 0
Local aOrdCodCre	:= {}
Local cOrdCodCre	:= ""

aOrdCodCre:= MontOrdCre()

IF cTributo == "PIS"

	//Primeiro ir¡ buscar os cr©ditos conforme a ordem informada pelo cliente.
	For nCont:=1 to len(aOrdCodCre)
		//Chama CredAntPis para processar registro 1100 dos valores de cr©ditos de per­odos anteriores na ordem informado pelo cliente
		CredAntPis(cPer,@aReg1100,@nTotContrb,.F.,aOrdCodCre[nCont])

		//Guardo os cdigos de cr©ditos processados para poder excluir posteriormente
		cOrdCodCre += aOrdCodCre[nCont]+ "/"
	Next nCont

	//Chama CredAntPis para processar os valores de cr©ditos de per­odos anteriores dos demais cdigos que no foram informados pelo cliente.
	//Se algum cdigos no foi informado ento no ir¡ se creditar de valores atrelados a estes cdigos.
	CredAntPis(cPer,@aReg1100,@nTotContrb,.F.,"",cOrdCodCre)
ElseIF cTributo == "COF"
	//Primeiro ir¡ buscar os cr©ditos conforme a ordem informada pelo cliente.
	For nCont:=1 to len(aOrdCodCre)
		//Chama CredAntPis para processar registro 1100 dos valores de cr©ditos de per­odos anteriores na ordem informado pelo cliente
		CredAntCof(cPer,@aReg1500,@nTotContrb,.F.,aOrdCodCre[nCont])

		//Guardo os cdigos de cr©ditos processados para poder excluir posteriormente
		cOrdCodCre += aOrdCodCre[nCont]+ "/"
	Next nCont

	//Chama CredAntPis para processar os valores de cr©ditos de per­odos anteriores dos demais cdigos que no foram informados pelo cliente.
	//Se algum cdigos no foi informado ento no ir¡ se creditar de valores atrelados a estes cdigos.
	CredAntCof(cPer,@aReg1500,@nTotContrb,.F.,"",cOrdCodCre)
EndIF

Return
//-------------------------------------------------------------------
/*/Funo FindSLG
No processamento dos registros de cupom fiscal em DBF, esta funo
ir¡ buscar a SLG correpondente a SFI processada.
/*/
//-------------------------------------------------------------------
Static Function FindSLG(cAliasSLG,cPdv,cSerPDV,cLGImpFisc,cLGSerPdv,cLGPdv)

Local lRet			:= .F.
Local cFiltro		:= ""
Local cIndex		:= ""
Local nIndex		:=	0
DEFAULT cAliasSLG	:= "SLG"

dbSelectArea(cAliasSLG)
(cAliasSLG)->(dbSetOrder(1))
(cAliasSLG)->(dbGoTop())

cIndex	:= CriaTrab(NIL,.F.)
cFiltro	:= 'LG_FILIAL=="'+xFilial ("SLG")+'"'
cFiltro += ' .AND. LG_PDV == "'+cPdv+ '"'
cFiltro += ' .AND. LG_SERPDV=="'+cSerPDV+'"'

IndRegua (cAliasSLG, cIndex, SLG->(IndexKey ()),,cFiltro)
nIndex := RetIndex(cAliasSLG)

#IFNDEF TOP
	DbSetIndex(cIndex+OrdBagExt ())
#ENDIF

DbSelectArea(cAliasSLG)
DbSetOrder(nIndex+1)
(cAliasSLG)->(dbGoTop())

If !(cAliasSLG)->(Eof ())
    cLGImpFisc	:= (cAliasSLG)->LG_IMPFISC
	cLGSerPdv	:= (cAliasSLG)->LG_SERPDV
	cLGPdv		:= AllTrim((cAliasSLG)->LG_PDV)
	lRet := .T.
EndIF

RetIndex(cAliasSLG)
Return lRet

/*‘‹‘‹‘»
ºPrograma  NwRecBrut ºAutor  Erick G. Dias       º Data   21/03/11   º
Œ˜ŠŠ¹
ºDescrio  Retornar os totais da receita bruta mensal                 º
ˆ¼
*/
static Function NwRecBrut(dDataDe,dDataAte,cEmpAnt,cFilAte,aWizard,aLisFil,cFilDe,aCFOPs,nMVM996TPR,cRegime,nTotF,lTop,lExtTaf)

Local 	cAliasSFT 	:=	"SFT"
Local 	aRetorno 	:=	{0,0,0,0}
Local 	cFiltro 	:=	" "
Local 	cCampos 	:=	" "
Local 	aF100Aux	:=	{}
Local   aRetPE      :=  {}
Local 	nPosF100	:=	0
Local 	cNrLivro	:=	" "
Local 	cCstNTrib	:=	"04#06#07#08#09#49" //Csts no tribut¡veis
Local 	lExpF100	:=	.F.
Local	lNatF100	:=	.F.
Local	aNatRecBr	:=	&(GetNewPar("MV_RECBNAT","{}"))
Local 	lCumulativ	:=	.F.
Local   lSpdRcBrut  := 	.F.
Local	cEspecie	:= 	" "
Local	aParFil		:=	{}
Local	lAchouCF8	:=	.F.
Local	cAliasCF8	:=	"CF8"
Local 	lCmpEstRec	:= 	SFX->(FieldPos("FX_ESTREC"))>0
Local	lMVESTTELE	:= 	GetNewPar("MV_ESTTELE", .F.)
Local   aRecTele	:= 	{}
Local   lEstorno	:= 	.F.
Local 	cGroupBy	:= 	" "
Local 	cCpmAux		:= 	" "
Local 	cFilExec	:= 	""
Local 	cJoinSFX	:= 	" "
Local	lCF8RecBru 	:= 	CF8->(FieldPos("CF8_RECBRU"))>0
Local 	lB1Tpreg		:= SB1->(FieldPos("B1_TPREG"))>0
Local   lCalcCF8	:= .F.
Local 	aSM0Area	:= SM0->(GetArea())
Local 	lCF8		:= .F.

Default lExtTaf     := .F.

cNrLivro	:=	If (lExtTaf,"*",aWizard[1][3])
lSpdRcBrut  := 	If (lExtTaf,.F.,aExstBlck[19])

DbSelectArea ("SM0")
SM0->(DbGoTop ())
SM0->(MsSeek (cEmpAnt+cFilDe, .T.))	//Pego a filial mais proxima

//------------------------------------------------------------------>
//CALCULA RECEITA BRUTA A PARTIR DAS NOTAS FISCAIS (BLOCOS A, C, D)
//------------------------------------------------------------------>
Do While !SM0->(Eof ()) .And. ((!"1"$aWizard[1][6] .And. cEmpAnt==SM0->M0_CODIGO .And. FWGETCODFILIAL<=cFilAte) .Or. ("1"$aWizard[1][6] .And. Len(aLisFil)>0 .And. cEmpAnt==SM0->M0_CODIGO  ))

	IncProc("Processando valores para registro 0111: "+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL))
	cStatus := STR0004+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL)
	cFilAnt := FWGETCODFILIAL

	// Verificacao se a Filial sera processada
	If Len(aLisFil)>0 //.And. Val(cFilAnt) <= Len(aLisFil)
        nFilial := Ascan(aLisFil,{|x|Alltrim(x[2])==Alltrim(cFilAnt)})
	   If nFilial > 0
		   If !(aLisFil[  nFilial, 1 ])  //Filial no marcada, vai para proxima
				SM0->( dbSkip() )
				Loop
			EndIf
	   Else
			SM0->( dbSkip() )
			Loop
	   EndIf
	Else
		If "1"  $ aWizard[1][6] //Somente faz skip se a opo de selecionar filiais estiver como Sim.
			 SM0->( dbSkip() )
			 Loop
		EndIf
	EndIf

	// Guardo Filial para query Principal (TOP)
	cFilExec += (cFilAnt+"/")

	If !lTop

		cIndex	:= CriaTrab(NIL,.F.)
		cFiltro	:= 'FT_FILIAL=="'+xFilial ("SFT")+'".And.'
		cFiltro += 'FT_TIPOMOV== "S" .And. '
		cFiltro += 'FT_TIPO <> "D" .And. '
		cFiltro += 'DToS (FT_ENTRADA)>="'+DToS (dDataDe)+'".And.DToS (FT_ENTRADA)<="'+DToS (dDataAte)+'" '
		cFiltro += '.And. (!SubStr (FT_CFOP,1,3)$"999/000" .Or. FT_TIPO=="S") .And.((FT_VALPIS > 0 .OR. FT_CSTPIS $"07#08#09#49#99") .OR. (FT_VALCOF > 0  .OR. FT_CSTCOF $"07#08#09#49#99")) .AND.(FT_DTCANC == " " .OR. DToS (FT_DTCANC)>"'+DToS (dDataDe)+'") .AND. FT_TIPOMOV == "E" '

		If (cNrLivro<>"*")
			cFiltro	+=	'.And.FT_NRLIVRO ="'+cNrLivro+'" '
		EndIf

		IndRegua (cAliasSFT, cIndex, SFT->(IndexKey ()),, cFiltro)
		nIndex := RetIndex(cAliasSFT)
		DbSetIndex (cIndex+OrdBagExt ())
		DbSelectArea (cAliasSFT)
	    DbSetOrder (nIndex+1)

		DbSelectArea (cAliasSFT)
		(cAliasSFT)->(DbGoTop ())
		ProcRegua ((cAliasSFT)->(RecCount ()))
		IncProc("Processando Registro 0111")
		Do While !(cAliasSFT)->(Eof ())

			cEspecie	:=	AModNot ((cAliasSFT)->FT_ESPECIE)		//Modelo NF
			lEstorno	:= .F.

			// SE PRESTA SERVICO TELECOMUNICACAO - Pesquisa o complemento
			If lMVESTTELE .AND. cEspecie $"21/22"
				lAchouSFX	:=	SFX->(MsSeek (xFilial ("SFX")+"S"+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA+(cAliasSFT)->FT_ITEM+(cAliasSFT)->FT_PRODUTO))
				If lAchouSFX .AND. SFX->FX_TIPOREC == "0" .AND. ((cAliasSFT)->FT_CSTPIS $ "01/02" .OR. (cAliasSFT)->FT_CSTCOF $ "01/02") .AND. lMVESTTELE .AND. lCmpEstRec
					IF SFX->FX_ESTREC <> "2"
						lEstorno	:= .T.
					EndIF
				EndIF
			EndIF

			//--------------------------------------------------
			// Verifica se o CFOP eh gerador de receita
			//--------------------------------------------------
			If (cEspecie$"  " .Or. ( (AllTrim((cAliasSFT)->FT_CFOP)$aCFOPs[01]) .AND. !(AllTrim((cAliasSFT)->FT_CFOP)$aCFOPs[02]) )) .AND. !lEstorno

				lCumulativ	:= .F.

				// Esse tratamento foi feito para caso que a aliquota seja 0,65 / 3,00 porem o regime possa ser Nao Cumulativo
				IF (cAliasSFT)->FT_ALIQPIS == 0.65 .and. (cAliasSFT)->FT_ALIQCOF == 3
					Do Case

						// TES
						Case nMVM996TPR == 1
							If SPEDSeek("SD2",3,xFilial("SD2")+(cAliasSFT)->(FT_NFISCAL+FT_SERIE+FT_CLIEFOR+FT_LOJA+FT_PRODUTO+FT_ITEM))
								If SPEDSeek("SF4",1,xFilial("SF4")+SD2->D2_TES)
									If SF4->F4_TPREG == "2"
										lCumulativ := .T.
									ElseIf SF4->F4_TPREG == "3"
										If SPEDSeek("SB1",1,xFilial("SB1")+(cAliasSFT)->FT_PRODUTO) .AND. lB1Tpreg
											If SB1->B1_TPREG == "2"
												lCumulativ := .T.
											EndIF
										EndIf
									Endif
								Endif
							Endif

						// Produto
						Case nMVM996TPR == 2
							If SPEDSeek("SB1",1,xFilial("SB1")+(cAliasSFT)->FT_PRODUTO) .AND. lB1Tpreg
								If SB1->B1_TPREG == "2"
									lCumulativ := .T.
								EndIF
							Endif

						// Cliente
						Case nMVM996TPR == 3 .And. SA1->(FieldPos("A1_TPREG")) > 0
							If SPEDSeek("SA1",1,xFilial("SA1")+(cAliasSFT)->(FT_CLIEFOR+FT_LOJA))
								IF SA1->A1_TPREG == "2"
									lCumulativ := .T.
								EndIF
							Endif
					EndCase
				EndIF

				//------------------------------------------------------------
				// Acumula valor de receita de Exportacao
				If SubStr((cAliasSFT)->FT_CFOP,1,1) == "7" .OR. (Alltrim((cAliasSFT)->FT_CFOP)$"5501/5502/6501/6502")

					aRetorno[3] += (cAliasSFT)->FT_VALCONT

				//------------------------------------------------------------
				// Acumula valor de receita Nao Tributado no Mercado Interno
				ElseIf ((cAliasSFT)->FT_CSTPIS $ cCstNTrib .OR. (cAliasSFT)->FT_CSTCOF $ cCstNTrib) .OR. ;
					  ( ((cAliasSFT)->FT_CSTPIS $ "05" .AND.  (cAliasSFT)->FT_ALIQPIS == 0) .OR.   ((cAliasSFT)->FT_CSTCOF $ "05" .AND.  (cAliasSFT)->FT_ALIQCOF == 0))
					aRetorno[2] += (cAliasSFT)->FT_VALCONT

				//------------------------------------------------------------
				// Acumula valor de receita Cumulativa
				ElseIF (cAliasSFT)->FT_ALIQPIS == 0.65 .and. (cAliasSFT)->FT_ALIQCOF == 3  .AND. lCumulativ
					aRetorno[4] += (cAliasSFT)->FT_VALCONT

				//------------------------------------------------------------
				// Acumula valor de receita nao cumulativa
				Else
					aRetorno[1] += ((cAliasSFT)->FT_VALCONT - (cAliasSFT)->FT_ICMSRET - (cAliasSFT)->FT_VALIPI)
				EndIF

			EndIF

			(cAliasSFT)->(DbSkip ())
		EndDo

		#IFDEF TOP
			If (TcSrvType ()<>"AS/400")
				DbSelectArea (cAliasSFT)
				(cAliasSFT)->(DbCloseArea ())
			Else
		#ENDIF
				RetIndex("SFT")
				FErase(cIndex+OrdBagExt ())
		#IFDEF TOP
			EndIf
		#ENDIF

	EndIf  // If !lTop

	aF100Aux := FinSpdF100(Month(dDataDe),Year(dDataDe),,,,"F100")

	For nPosF100 :=1 to Len(aF100Aux)

		lExpF100	:=	.F.
		lNatF100	:=	.F.

		If Len(aF100Aux[nPosF100]) > 25

			IF aF100Aux[nPosF100][22]$"X"
				lExpF100	:=	.T.
			EndIF

		    If aScan(aNatRecBr, {|x| x == Alltrim(aF100Aux[nPosF100][26])}) > 0
		    	lNatF100	:=	.T.
		    Endif

		Elseif Len(aF100Aux[nPosF100]) > 21

			IF aF100Aux[nPosF100][22]$"X"
				lExpF100	:=	.T.
			EndIF
		EndIf

		//A variavel lNatF100 indica se a natureza utilizada no titulo foi preenchida no parametro MV_RECBNAT
		//O parametro indica as naturezas que serao desconsideradas no processamento do registro 0111		  
		If !lNatF100
			//Verifica se eh cliente de exportacao. Leva para o campo 04 - Rec. Bruta N Cumulativa - EXPORTACAO  
			If lExpF100
				aRetorno[3] += aF100Aux[nPosF100][2]
				// Aqui acumulo o total da receita para a utilizao no bloco P
				nTotF	+=	aF100Aux[nPosF100][2]

			//Acumula valor de receita No Tributado no Mercado Interno
			ElseIf aF100Aux[nPosF100][3] $ "04#06#07#08#09#49#99"	.AND. aF100Aux[nPosF100][15] <> "SE2"

				aRetorno[2] += aF100Aux[nPosF100][2]

				// Aqui acumulo o total da receita para a utilizao no bloco P
				nTotF	+=	aF100Aux[nPosF100][2]

			//Acumula valor de receita Cumulativa
			ElseIf aF100Aux[nPosF100][3] $ "01#02#03#05" .AND. aF100Aux[nPosF100][15] <> "SE2"
				If aF100Aux[nPosF100][5]== 0.65 .and. aF100Aux[nPosF100][9] == 3
					aRetorno[4] += aF100Aux[nPosF100][2]
				Else
					//Acumula valor de receita Nao Cumulativa
					aRetorno[1] += aF100Aux[nPosF100][2]

				EndIF

				// Aqui acumulo o total da receita para a utilizao no bloco P
				nTotF	+=	aF100Aux[nPosF100][2]

			EndIF
		Endif

	Next nCont

	If !lExtTaf
		lCF8 := If(aIndics[20] , .T., .F.)
	Else
		lCF8 := If(AliasIndic("AIF") , .T., .F.)
	EndIf

	// CALCULA RECEITA BRUTA A PARTIR DA TABELA CF8
	If lCF8 //.AND. (cAliasCF8)->(LastRec(cAliasCF8))

		aAdd(aParFil,DTOS(dDataDe))
		aAdd(aParFil,DTOS(dDataAte))

		//Funo que ir¡ retornar alias com valores da tabela CF8 referente ao per­odo e filial corrente.
		If (lAchouCF8	:=	SPEDFFiltro(1,"CF8",@cAliasCF8,aParFil))

			ProcRegua ((cAliasCF8)->(RecCount ()))
			Do While !(cAliasCF8)->(Eof ())

				lCalcCF8	:= .T.
				IF lCF8RecBru .AND.(cAliasCF8)->CF8_RECBRU == "2"
					lCalcCF8	:= .F.
				EndIF
				IF lCalcCF8
					//Acumula valor de receita No Tributado no Mercado Interno
					If (cAliasCF8)->CF8_INDOPE == "2"
						aRetorno[2] += (cAliasCF8)->CF8_VLOPER

					//Acumula valor de receita Cumulativa
					ElseIF (cAliasCF8)->CF8_TPREG == "1" .AND. (cAliasCF8)->CF8_INDOPE == "1"
						aRetorno[4] += (cAliasCF8)->CF8_VLOPER

					//Acumula valor de receita Nao Cumulativa
					ElseIF (cAliasCF8)->CF8_TPREG== "2" .AND. (cAliasCF8)->CF8_INDOPE == "1"
						aRetorno[1] += (cAliasCF8)->CF8_VLOPER
					EndIF
				EndIF

				// Aqui acumulo o total da receita para utilizao no bloco P
				If Alltrim((cAliasCF8)->CF8_INDOPE)$"1/2"
					nTotF	+= (cAliasCF8)->CF8_VLOPER
				EndIf

				(cAliasCF8)->(DbSkip ())
			EndDo
		Endif
	Endif

	If lAchouCF8
		SPEDFFiltro(2,,cAliasCF8)
	EndIf

	//PE que retorna as receitas Tributadas/Nao Tributadas/Cumulativas para geracao do registro 0111                                                                   
	If lSpdRcBrut
		aRetPE := ExecBlock("SPDRECBRUT",.F.,.F.)

		If ValType(aRetPE) == "A"
			//Acumula valor de receita Cumulativa
			aRetorno[4] += aRetPE[1]
			//Acumula valor de receita No Tributado no Mercado Interno
			aRetorno[2] += aRetPE[2]
			//Acumula valor de receita Nao Cumulativa
			aRetorno[1] += aRetPE[3]
			// Aqui acumulo o total da receita para a utilizao no bloco P
			nTotF	+=	aRetPE[1]+aRetPE[2]+aRetPE[3]

		EndIf
	EndIf

	IF lMVESTTELE
		aRecTele:=TeleComFut(dDataDe,dDataAte,,,,,,,,,,,,.F.,cRegime)

		IF len(aRecTele) > 0
			//Receita Tributada no mercado interno
			aRetorno[1] +=aRecTele[1]
			//Receita No Tributada no Mercado Interno
			aRetorno[2] +=aRecTele[2]
			//Receita de Exportao
			aRetorno[3] +=aRecTele[3]
			//Receita Cumulativa
			aRetorno[4] +=aRecTele[4]
	   		//Aqui acumulo o total da receita para a utilizao no bloco P
			nTotF	+=	aRecTele[1]+aRecTele[2]+aRecTele[3]+aRecTele[4]
		EndIF
	EndIF

	cAliasSFT	:=	"SFT"
	cAliasCF8	:=  "CF8"
	SM0->(DbSkip ())
ENdDo  			                           '

SM0->(RestArea(aSM0Area))

// Afim de obter melhor performance, apos rodar todas as filiais faz apenas 1 uma query com IN nas filiais selecionadas
If lTop

	IncProc("Verificando valor das receitas do per­odo")
	// Trata filiais selecionadas para utlizacao das mesmas no IN da query
    cFilExec	:= FormatIn(cFilExec,"/")
    cFilExec	:= SubStr(cFilExec,3,Len(cFilExec)-7)

	cAliasSFT	:=	GetNextAlias()
	cFiltro 	:= "%"
	cCampos 	:= "%"

	If (cNrLivro<>"*")
 		cFiltro += " SFT.FT_NRLIVRO = '" +%Exp:cNrLivro% +"' AND "
   	EndiF

	// Group By quando regime nao cumulativo e nao for servico de telecomunicacao
	//cRegime := "1"
	If cRegime=="1" .AND. !lMVESTTELE

		// Campos
		cCpmAux		:= " SFT.FT_FILIAL,SFT.FT_CFOP,SFT.FT_ALIQPIS,SFT.FT_ALIQCOF,SFT.FT_CSTPIS,SFT.FT_CSTCOF, SFT.FT_ESPECIE "
		cCampos		+= cCpmAux

		// Group By
		cGroupBy	:= "% GROUP BY " + cCpmAux

		// Campos de valores / soma
		cCampos		+= " , SUM(SFT.FT_VALCONT) FT_VALCONT , SUM(SFT.FT_ICMSRET) FT_ICMSRET , SUM(SFT.FT_VALIPI) FT_VALIPI "

	// Caso o regime seja CUMULATIVO/AMBOS OU Seja prestacao de telecomunicacao MV_ESTTELE
	// Nao e' possivel agrupar por CFOP + ALIQ + CST, pois eh necessario obter inf. especificao do ITEM
	Else
		// Campos SFT
		cCpmAux		:= " 	SFT.FT_FILIAL,SFT.FT_VALCONT ,SFT.FT_CFOP,SFT.FT_ALIQPIS,SFT.FT_ALIQCOF,SFT.FT_CSTPIS,SFT.FT_CSTCOF, SFT.FT_PRODUTO, "
		cCpmAux		+= "	SFT.FT_NFISCAL,SFT.FT_SERIE,SFT.FT_CLIEFOR,SFT.FT_LOJA,SFT.FT_ITEM,SFT.FT_ESPECIE,SFT.FT_ICMSRET,SFT.FT_VALIPI "

		// Campos SFX
  		If lMVESTTELE
	  		cCpmAux		+= " 	, FX_TIPOREC "
	  		If lCmpEstRec
	  			cCpmAux		+= " , SFX.FX_ESTREC "
	  		EndIf
	  		cJoinSFX 	:= "LEFT JOIN "+RetSqlName("SFX")+" SFX ON(SFX.FX_FILIAL IN ('"+cFilExec+"')  AND  SFX.FX_TIPOMOV='S' AND SFX.FX_SERIE=SFT.FT_SERIE AND SFX.FX_DOC=SFT.FT_NFISCAL AND SFX.FX_CLIFOR=SFT.FT_CLIEFOR AND SFX.FX_LOJA=SFT.FT_LOJA AND SFX.FX_ITEM=SFT.FT_ITEM AND SFX.FX_COD=SFT.FT_PRODUTO AND SFX.D_E_L_E_T_=' ') "
	  	EndIf

		cCampos		+= cCpmAux
		cGroupBy 	:= "" // "GROUP BY " cCampos

	EndIf

	cFiltro 	+= "%"
	cCampos 	+= "%"
	cGroupBy    += "%"
	cJoinSFX 	:= "%" + cJoinSFX + "%"
	BeginSql Alias cAliasSFT

		SELECT
			%Exp:cCampos%
		FROM
			%Table:SFT% SFT
			%Exp:cJoinSFX%
		WHERE
			SFT.FT_FILIAL IN (%Exp:cFilExec%) AND 
			SFT.FT_TIPOMOV = 'S' AND
			SFT.FT_TIPO <> 'D' AND
			SFT.FT_ENTRADA>=%Exp:DToS (dDataDe)% AND
			SFT.FT_ENTRADA<=%Exp:DToS (dDataAte)% AND
			((SFT.FT_CFOP NOT LIKE '000%' AND SFT.FT_CFOP NOT LIKE '999%') OR SFT.FT_TIPO='S') AND
			((SFT.FT_BASEPIS > 0 OR SFT.FT_CSTPIS IN ('07','08','09','49','99'))  OR ( SFT.FT_BASECOF > 0 OR SFT.FT_CSTCOF IN ('07','08','09','49','99'))  OR SFT.FT_CFOP LIKE '7%') AND
			(SFT.FT_DTCANC = ' ' OR SFT.FT_DTCANC > %Exp:DToS (dDataAte)% )  AND
			%Exp:cFiltro%
			SFT.%NotDel%
	 	%Exp:cGroupBy%
		ORDER BY SFT.FT_CFOP
	EndSql

	DbSelectArea (cAliasSFT)
	(cAliasSFT)->(DbGoTop ())
	ProcRegua ((cAliasSFT)->(RecCount()))
	IncProc("Processando Registro 0111")
 	Do While !(cAliasSFT)->(Eof ())

		cEspecie	:=	AModNot ((cAliasSFT)->FT_ESPECIE)		//Modelo NF
		lEstorno	:= .F.

  		// SE PRESTA SERVICO TELECOMUNICACAO - COMPLEMENTO
  		If lMVESTTELE .AND. (cEspecie$"21/22") .AND. (cAliasSFT)->FX_TIPOREC=="0" .AND. ((cAliasSFT)->FT_CSTPIS $ "01/02" .OR. (cAliasSFT)->FT_CSTCOF $ "01/02") ;
  			.AND. lCmpEstRec .AND. (cAliasSFT)->FX_ESTREC <> "2"
  			lEstorno	:= .T.
  		EndIF

   		If (cEspecie$"  " .Or. ( (AllTrim((cAliasSFT)->FT_CFOP)$aCFOPs[01]) .AND. !(AllTrim((cAliasSFT)->FT_CFOP)$aCFOPs[02]) )) .AND. !lEstorno

			lCumulativ	:= .F.

			// Exclusivamente CUMULATIVO/AMBOS
			// So faco tais verificacoes caso o regime processado nao seja Exclusivamente Nao Cumulativo
			If cRegime=="3"
				If (cAliasSFT)->FT_ALIQPIS == 0.65 .and. (cAliasSFT)->FT_ALIQCOF == 3
					Do Case
						Case nMVM996TPR == 1
							If SPEDSeek("SD2",3,(cAliasSFT)->FT_FILIAL+(cAliasSFT)->(FT_NFISCAL+FT_SERIE+FT_CLIEFOR+FT_LOJA+FT_PRODUTO+FT_ITEM))
								If SPEDSeek("SF4",1,(cAliasSFT)->FT_FILIAL+SD2->D2_TES)
									If SF4->F4_TPREG == "2"
										lCumulativ := .T.
									ElseIf SF4->F4_TPREG == "3"
										If SPEDSeek("SB1",1,(cAliasSFT)->FT_FILIAL+(cAliasSFT)->FT_PRODUTO) .AND. lB1Tpreg
											If SB1->B1_TPREG == "2"
												lCumulativ := .T.
											EndIF
										EndIf
									Endif
								Endif
							Endif

						Case nMVM996TPR == 2
							If SPEDSeek("SB1",1,(cAliasSFT)->FT_FILIAL+(cAliasSFT)->FT_PRODUTO) .AND. lB1Tpreg
								If SB1->B1_TPREG == "2"
									lCumulativ := .T.
								EndIF
							Endif

						Case nMVM996TPR == 3 .And. SA1->(FieldPos("A1_TPREG")) > 0
							If SPEDSeek("SA1",1,(cAliasSFT)->FT_FILIAL+(cAliasSFT)->(FT_CLIEFOR+FT_LOJA))
								IF SA1->A1_TPREG == "2"
									lCumulativ := .T.
								EndIF
							Endif
					EndCase
				EndIF
			EndIf

			If SubStr((cAliasSFT)->FT_CFOP,1,1) == "7" .OR. (Alltrim((cAliasSFT)->FT_CFOP)$"5501/5502/6501/6502")

				aRetorno[3] += (cAliasSFT)->FT_VALCONT

			ElseIf ((cAliasSFT)->FT_CSTPIS $ cCstNTrib .OR. (cAliasSFT)->FT_CSTCOF $ cCstNTrib) .OR. ;
				  ( ((cAliasSFT)->FT_CSTPIS $ "05" .AND.  (cAliasSFT)->FT_ALIQPIS == 0) .OR.   ((cAliasSFT)->FT_CSTCOF $ "05" .AND.  (cAliasSFT)->FT_ALIQCOF == 0))
				aRetorno[2] += (cAliasSFT)->FT_VALCONT

			ElseIF (cAliasSFT)->FT_ALIQPIS == 0.65 .and. (cAliasSFT)->FT_ALIQCOF == 3  .AND. lCumulativ
				aRetorno[4] += (cAliasSFT)->FT_VALCONT

			Else
				aRetorno[1] += ((cAliasSFT)->FT_VALCONT)
			EndIF

		EndIF

		(cAliasSFT)->(DbSkip ())
	EndDo

	#IFDEF TOP
		If (TcSrvType ()<>"AS/400")
			DbSelectArea (cAliasSFT)
			(cAliasSFT)->(DbCloseArea ())
		Else
	#ENDIF
			RetIndex("SFT")
			FErase(cIndex+OrdBagExt ())
	#IFDEF TOP
		EndIf
	#ENDIF

EndIf
Return (aRetorno)

/*NwPCProcECF*/
Static Function NwPCProcECF(aRegC400,aRegC405,dDataDe,dDataAte,aRegC481,aRegC485,aReg0200,aReg0205,aReg0190,cAlias,lRegC010,;
					   		cRegime,aRegM400,aRegM410,aRegM800,aRegM810,aRegM210,aRegM610,aRegC491,aRegC495,aRegC490,lCumulativ,nRelacFil,;
							aRegM230,aRegM630,aReg0500,cCGCAnt,lRepCGC,lConsolid, nPaiC,lTop,aRegC489,aRegC499,aReg1010,aReg1020,nRelacDoc,;
							lAchouCDG,aRegC010,nCt400,nMVM996TPR,lA1_TPREG,cMvEstado,lCmpsSB5,lCpoPtPis,lCpoPtCof,nPos0200,cSemaphore)
Local nPos400 	:=0
Local nPos405 	:=0
Local nPos490	:=0
Local nCt405	:=0
Local nCt481	:=0
Local nCt485	:=0
Local nVlBrtLj  :=0
Local cAliasSFT	:= "SFT"
Local cAliasSFI := "SFI"
Local cAliasSLG := "SLG"
Local cAliasSB1	:= "SB1"
Local cAliasSF4	:= "SF4"
Local cSlctSFT	:= ""
Local cCmposSB1	:= ""
Local cFiltro	:= ""
Local cCampos	:= ""
Local cOrderBy	:= ""
Local dDtReduz	:= CtoD("//")
Local cChvPDV	:= ""
Local cPDV		:= ""
Local cChave	:= ""
Local cFilSB1	:= xFilial("SB1")
Local cChvC48X	:= ""
Local cConta	:= ""
Local cProd		:= ""
Local cJoinSD2	:= ""
Local cJoinSF4	:= ""
Local cJoinSB1	:= ""
Local cJoinAll	:= ""
// Variaveis de controle para retirada do aScan
Local c400AScan := ""
Local c400BScan := ""
Local c400CScan := ""

Local c405AScan := ""
Local c405BScan := ""
Local c405CScan := ""

Local c481AScan := ""
Local c481BScan := ""
Local c481CScan := ""
Local c481DScan := ""
Local _nAtC481	:= 0

Local c485AScan := ""
Local c485BScan := ""
Local c485CScan := ""
Local c485DScan := ""
Local _nAtC485	:= 0

Local 	nTamCodB1		:= TamSX3("B1_COD")[1]
Local 	nTamFilB1		:= Len(xFilial("SB1"))
Local 	nTamConta		:= TamSX3("CT1_CONTA")[1]+Len(xFilial("CT1"))
Local   nTamCSTPis		:= TamSX3("FT_CSTPIS")[1]
Local   nTamCSTCof		:= TamSX3("FT_CSTPIS")[1]
Local   nTamAlqP		:= TamSX3("FT_ALIQPIS")[1]
Local   nTamAlqC		:= TamSX3("FT_ALIQCOF")[1]
Local 	nCorteChv 		:= ""
Local 	aJobAux			:=	{}
Local 	cJobFile		:= ""
Local 	nX				:= ""
Local	nHd1			:= 0

Local 	lAScan			:= .T. //.T. //CDG->(LastRec())>0
Local 	nI				:= 0
Local	lExitFor		:= .F.



Default cCGCAnt	:= ""
Default lRepCGC	:= .F.


lDevolucao	:= .F.

// ==============================================
// Query Principal - ECF
#IFDEF TOP
    If (TcSrvType ()<>"AS/400")

		//CAMPOS DA TABELA SFT PARA MONTAR A QUERY.
		If !lAScan .AND. !lGrBlocoM .AND. !lConsolid

			cSlctSFT 	:= " SFT.FT_FILIAL, SFT.FT_PDV,  SFT.FT_ENTRADA,  SFT.FT_CSTPIS, SFT.FT_ALIQPIS, SFT.FT_VALPIS, SFT.FT_BASEPIS, SFT.FT_CSTCOF, SFT.FT_ALIQCOF, SFT.FT_VALCOF, SFT.FT_BASECOF "
			cSlctSFT	+= " , SFT.FT_PAUTPIS, SFT.FT_PAUTCOF "


			cCmposSB1	:=	" , SB1.B1_COD,		SB1.B1_DESC,		SB1.B1_VLR_PIS,		SB1.B1_VLR_COF,		SB1.B1_TNATREC,		"
			cCmposSB1	+=  " SB1.B1_CNATREC, 	SB1.B1_GRPNATR, 	SB1.B1_DTFIMNT,		SB1.B1_TIPO,		SB1.B1_CODBAR,		"
			cCmposSB1	+=  " SB1.B1_CODANT, 	SB1.B1_UM, 			SB1.B1_POSIPI,		SB1.B1_EX_NCM,		SB1.B1_CODISS,		"
			cCmposSB1	+=  " SB1.B1_PICM, 		SB1.B1_FECP, 		SB1.B1_DATREF		"
			If SB1->(FieldPos("B1_TPREG"))>0
				cCmposSB1 += " , SB1.B1_TPREG  "
			EndIf

			cCmposSB1 	+= " , SFI.FI_PDV, SFI.FI_DTMOVTO, SFI.FI_DESC,  SFI.FI_SERPDV, SFI.FI_CRO, SFI.FI_NUMREDZ, SFI.FI_NUMFIM, SFI.FI_GTFINAL "
			cCmposSB1 	+= " , SLG.LG_SERPDV, SLG.LG_IMPFISC, SLG.LG_PDV  "

			cCpoGroup	:= (cSlctSFT+cCmposSB1)

			cCmposSB1	+= " , SUM(SFT.FT_TOTAL) AS FT_TOTAL , SUM(SFT.FT_BASEPIS) AS FT_BASEPIS , SUM(SFT.FT_VALPIS) AS FT_VALPIS "
			cCmposSB1	+= " , SUM(SFT.FT_BASECOF) AS FT_BASECOF , SUM(SFT.FT_VALCOF) AS FT_VALCOF "
			cCmposSB1	+= " , SUM(SFI.FI_VALCON) AS FI_VALCON , SUM(SFI.FI_ISS) AS FI_ISS  "

			cCpoGroup	:= " GROUP BY " + (cCpoGroup)

		Else

			lAScan  := .T.

			cCpoGroup	:= " "

			cSlctSFT := "SFT.FT_FILIAL,		SFT.FT_TIPOMOV,		SFT.FT_SERIE,		SFT.FT_NFISCAL,		SFT.FT_CLIEFOR,		"
			cSlctSFT +=	"SFT.FT_LOJA,		SFT.FT_ITEM,		SFT.FT_PRODUTO,		SFT.FT_ENTRADA,		SFT.FT_NRLIVRO,		"
			cSlctSFT +=	"SFT.FT_CFOP,		SFT.FT_ESPECIE,		SFT.FT_TIPO,		SFT.FT_EMISSAO,		SFT.FT_DTCANC,		"
		    cSlctSFT += "SFT.FT_FORMUL, 	SFT.FT_ALIQPIS,		SFT.FT_VALPIS,		SFT.FT_ALIQCOF,		SFT.FT_VALCOF,		"
			cSlctSFT += "SFT.FT_VALCONT,	SFT.FT_BASEICM,		SFT.FT_VALICM,		SFT.FT_ISSST,	 	SFT.FT_BASERET,		"
			cSlctSFT += "SFT.FT_ICMSRET,	SFT.FT_VALIPI,		SFT.FT_ISENICM,		SFT.FT_QUANT,		SFT.FT_DESCONT,		"
			cSlctSFT += "SFT.FT_TOTAL,		SFT.FT_FRETE,  		SFT.FT_SEGURO,		SFT.FT_DESPESA,		SFT.FT_OUTRICM,		"
			cSlctSFT += "SFT.FT_BASEIPI,	SFT.FT_ISENIPI,		SFT.FT_OUTRIPI,		SFT.FT_ICMSCOM,		SFT.FT_RECISS,		"
			cSlctSFT += "SFT.FT_BASEIRR,	SFT.FT_ALIQICM,		SFT.FT_ALIQIPI,		SFT.FT_CTIPI,		SFT.FT_POSIPI,		"
			cSlctSFT += "SFT.FT_CLASFIS,	SFT.FT_PRCUNIT,		SFT.FT_CFPS,		SFT.FT_ESTADO,		SFT.FT_CODISS,		"
			cSlctSFT += "SFT.FT_ALIQIRR,	SFT.FT_VALIRR,		SFT.FT_BASEINS,		SFT.FT_VALINS,		SFT.FT_PDV,			"
			cSlctSFT += "SFT.FT_ISSSUB,		SFT.FT_CREDST,		SFT.FT_ISENRET,		SFT.FT_OUTRRET,		SFT.FT_CONTA,		"
			cSlctSFT +=	"SFT.FT_BASEPIS,	SFT.FT_BASECOF,		SFT.FT_VALPS3,		SFT.FT_VALCF3,		SFT.FT_PESO,	    "
			cSlctSFT +=	"SFT.FT_SOLTRIB,	SFT.FT_CHVNFE, 		SFT.FT_CSTPIS,		SFT.FT_CSTCOF,		SFT.FT_INDNTFR, 	"
			cSlctSFT += "SFT.FT_CODBCC,		SFT.FT_ALIQCF3,  	SFT.FT_VALCF3,		SFT.FT_BASEPS3, 	SFT.FT_ALIQPS3, 	"
			cSlctSFT += "SFT.FT_VALPS3,		SFT.FT_BASECF3,"

			cSlctSFT += "SFT.FT_PAUTCOF, "

			cSlctSFT += "SFT.FT_TNATREC, "
			cSlctSFT += "SFT.FT_CNATREC, "
			cSlctSFT += "SFT.FT_GRUPONC, "
			cSlctSFT += "SFT.FT_DTFIMNT, "

			If aFieldPos[15] .And. aFieldPos[16]
				cSlctSFT += "SFT.FT_MVALCOF , SFT.FT_MALQCOF, "
			EndIf

			cSlctSFT += "SFT.FT_PAUTPIS, "

			//CAMPOS DA TABELA SB1 PARA MONTAR A QUERY.
			cJoinSB1	:= ""
			If lMVGerPrdC
		    	cCmposSB1	:=	"SB1.B1_COD,		SB1.B1_DESC,		SB1.B1_VLR_PIS,		SB1.B1_VLR_COF,		SB1.B1_TNATREC,		"
				cCmposSB1	+=  "SB1.B1_CNATREC, 	SB1.B1_GRPNATR, 	SB1.B1_DTFIMNT,		SB1.B1_TIPO,		SB1.B1_CODBAR,		"
				cCmposSB1	+=  "SB1.B1_CODANT, 	SB1.B1_UM, 			SB1.B1_POSIPI,		SB1.B1_EX_NCM,		SB1.B1_CODISS,		"
				cCmposSB1	+=  "SB1.B1_PICM, 		SB1.B1_FECP, 		SB1.B1_DATREF		"
				If aFieldPos[22]
					cCmposSB1 += " , SB1.B1_TPREG  "
				EndIf
				cJoinSB1 := " LEFT JOIN "+RetSqlName("SB1")+" SB1 ON(SB1.B1_FILIAL='"+xFilial("SB1")+"' AND SB1.B1_COD=SFT.FT_PRODUTO AND   SB1.D_E_L_E_T_='') "
			EndIf

			//CAMPOS DA TABELA SFI E SLG               
			cCmposSB1 += Iif(lMVGerPrdC, "," , " " )
			cCmposSB1 += "   SFI.FI_PDV, SFI.FI_DTMOVTO, SFI.FI_DESC,  SFI.FI_SERPDV, SFI.FI_VALCON, SFI.FI_ISS, SFI.FI_CRO, SFI.FI_NUMREDZ, SFI.FI_NUMFIM, SFI.FI_GTFINAL, SFI.FI_CANCEL "
			cCmposSB1 += " , SLG.LG_SERPDV, SLG.LG_IMPFISC, SLG.LG_PDV  "

		EndIf

		//cCmposSB1 += " , SF4.F4_TPREG  "
		// JOIN - SD2 e SF4
		// somente faz JOIN com SD2 para chgar ate' SF4 quando gerar bloco M
		If lGrBlocoM .AND. cRegime=="3"
			// Campo SF4
			cCmposSB1 += " , SF4.F4_TPREG  "
			// JOIN SD2
			cJoinSD2	:=	" LEFT JOIN "+RetSqlName("SD2")+" SD2 ON(SD2.D2_FILIAL='"+xFilial("SD2")+"' AND SD2.D2_DOC=SFT.FT_NFISCAL AND SD2.D2_SERIE=SFT.FT_SERIE AND SD2.D2_CLIENTE=SFT.FT_CLIEFOR AND SD2.D2_LOJA=SFT.FT_LOJA AND SD2.D2_COD=SFT.FT_PRODUTO AND SD2.D2_ITEM=SFT.FT_ITEM AND SD2.D_E_L_E_T_='') "
			// JOIN SF4
			cJoinSF4	:=	" LEFT JOIN "+RetSqlName("SF4")+" SF4 ON(SF4.F4_FILIAL='"+xFilial("SF4")+"' AND SF4.F4_CODIGO=SD2.D2_TES AND   SF4.D_E_L_E_T_='') "
		EndIf

		cJoinAll := "%"
		cJoinAll += cJoinSB1
		cJoinAll += cJoinSD2
		cJoinAll += cJoinSF4
		cJoinAll += "%"

		//CONCATENO TODOS OS CAMPOS PARA FAZER A QUERY.
    	cSlctSFT	+=	cCmposSB1
    	cSlctSFT	:=	"%"+cSlctSFT+"%"

    	cAliasSFI 	:= cAliasSLG := cAliasSFT	:=	GetNextAlias()
    	lSFI_SLG	:= .T. // Variavel utilizada para controle em DBF - Quando TOP sempre sera .T.

	    cFiltro := "%"
		cCampos := "%"
		If (cNrLivro<>"*")
  			cFiltro += " SFT.FT_NRLIVRO = '" +%Exp:cNrLivro% +"' AND "
     	EndiF
		cFiltro += "%"
		cCampos += "%"

		cOrderBy  := "% " + cCpoGroup +  " ORDER BY SFI.FI_PDV, SFI.FI_DTMOVTO " + Iif(lAScan , ", SFT.FT_NFISCAL, SFT.FT_SERIE, SFT.FT_ITEM " , " ") + "  %"

    	BeginSql Alias cAliasSFT

			COLUMN FT_EMISSAO AS DATE
	    	COLUMN FT_ENTRADA AS DATE
	    	COLUMN FT_DTCANC AS DATE
	    	COLUMN FI_DTMOVTO AS DATE

			SELECT
				%Exp:cSlctSFT%
			FROM
				%Table:SFT% SFT
				JOIN %Table:SFI% SFI ON (SFI.FI_FILIAL=%xFilial:SFI% AND SFI.FI_PDV=SFT.FT_PDV AND SFI.FI_DTMOVTO=SFT.FT_ENTRADA AND SFI.%NotDel%    )
				JOIN %Table:SLG% SLG ON (SLG.LG_FILIAL=%xFilial:SLG% AND SLG.LG_PDV=SFT.FT_PDV AND SLG.%NotDel%    )
				%Exp:cJoinAll%
			WHERE
				SFT.FT_FILIAL=%xFilial:SFT% 				AND
				SFT.FT_TIPOMOV  = 'S'   					AND
				SFT.FT_ENTRADA>=%Exp:DToS(dDataDe)% AND
				SFT.FT_ENTRADA<=%Exp:DToS(dDataAte)% AND
				SFT.FT_ESPECIE IN ('CF','ECF') AND
				((SFT.FT_BASEPIS > 0 OR SFT.FT_CSTPIS IN ('07','08','09','49' ))  OR (SFT.FT_BASECOF > 0 OR SFT.FT_CSTCOF IN ('07','08','09','49'))) AND
				SFT.FT_DTCANC = ' ' AND
				%Exp:cFiltro%
				SFT.%NotDel%

			%Exp:cOrderBy%

		EndSql

	Else
#ENDIF

		// Abre tabelas
		dbSelectArea(cAliasSFI)
		(cAliasSFI)->(dbSetOrder(1))
		(cAliasSFI)->(dbGoTop())

		dbSelectArea(cAliasSLG)
		(cAliasSLG)->(dbSetOrder(1))
		(cAliasSLG)->(dbGoTop())

		cIndex	:= CriaTrab(NIL,.F.)
	    cFiltro	:= 'FT_FILIAL=="'+xFilial ("SFT")+'"  '
	    cFiltro += ' .AND. FT_TIPOMOV== "S"  '
		cFiltro += ' .AND. DToS(FT_ENTRADA)>="'+DToS(dDataDe)+'" .And. DToS(FT_ENTRADA)<="'+DToS(dDataAte)+'"
		cFiltro += ' .AND. Empty(FT_DTCANC) '
		cFiltro += ' .AND. ( AllTrim(FT_ESPECIE)=="CF" .OR. AllTrim(FT_ESPECIE)=="ECF" ) '
		cFiltro	+= ' .AND. ( ( (FT_BASEPIS > 0 .OR.  FT_BASEPS3 > 0) .OR. FT_CSTPIS$"07#08#09#49" ) .OR. ( (FT_BASECOF > 0  .OR.  FT_BASECF3 > 0) .OR. FT_CSTCOF $"07#08#09#49" ) )'
	    If (cNrLivro<>"*")
 		    cFiltro	+=	' .And. FT_NRLIVRO=="'+cNrLivro+'" '
	   	EndIf

	    IndRegua (cAliasSFT, cIndex, SFT->(IndexKey ()),, cFiltro)
	    nIndex := RetIndex(cAliasSFT)

		#IFNDEF TOP
			DbSetIndex (cIndex+OrdBagExt ())
		#ENDIF

		DbSelectArea(cAliasSFT)
	    DbSetOrder(nIndex+1)
	    (cAliasSFT)->(dbGoTop())

#IFDEF TOP
	Endif
#ENDIF

If !lRepCGC
	nCt400 := 0
EndIf

If lTop
	cAliasSB1	:= cAliasSFT
	cAliasSF4	:= cAliasSFT
EndIf

Do While !(cAliasSFT)->(Eof())

	// Tratamento retirado da query - colocado dentro do laco Se base de PIS ou COF for zerada e nao for CST de aliq. zero, SKIP no registro.
	If ( ((cAliasSFT)->FT_BASEPIS==0 .AND. !(cAliasSFT)->FT_CSTPIS$"07|08|09|48" ) .OR. ((cAliasSFT)->FT_BASECOF==0 .AND. !(cAliasSFT)->FT_CSTCOF$"07|08|09|48" )  )
		(cAliasSFT)->(dbSkip())
		Loop
	EndIf

	// Zerar variaveis
	If !lConsolid
		aRegC400	:= {}
		aRegC405 	:= {}
		aRegC481 	:= {}
		aRegC485 	:= {}
		aRegC489 	:= {}
		nCt405		:= 1
		nCt481		:= 0
		nCt485		:= 0
		c400AScan := ""
 		c400BScan := ""
		c400CScan := ""
	EndIf


	// Tratamento DBF
    If !lTop // Posiciona na SFI e SLG corretas
    	lSFI_SLG := (cAliasSFI)->(MsSeek(xFilial(cAliasSFI)+DToS((cAliasSFT)->FT_ENTRADA))) .AND. (cAliasSLG)->(MsSeek(xFilial(cAliasSLG)+ (cAliasSFI)->FI_PDV))
	EndIf

    // Variavel criada para atender DBF - Se encontrou SFI e SLG referente ao registro -> Em TOP sera sempre .T.
    If lSFI_SLG

	    cChvPDV :=  (cAliasSFT)->FT_PDV
	    dDtReduz := DtoS((cAliasSFT)->FT_ENTRADA)

		// Laco por PDV
		While !(cAliasSFT)->(Eof()) .AND. cChvPDV==(cAliasSFT)->FT_PDV

			// Variavel criada para atender DBF - Se encontrou SFI e SLG referente ao registro -> Em TOP sera sempre .T.
			If lSFI_SLG

				lRegC010 :=.T.
				If (cCGCAnt<>SM0->M0_CGC) .Or. (!lRepCGC) .Or. (lRepCGC .And. (aScan(aRegC010, {|aX| aX[2] == SM0->M0_CGC}) > 0)) //Tratamento para consolidar Filiais com mesmo CNPJ.

					RegC400 (@aRegC400, (cAliasSLG)->LG_IMPFISC, (cAliasSLG)->LG_SERPDV, AllTrim((cAliasSLG)->LG_PDV),;
							 	@nPos400,@nCt400, @c400AScan, @c400BScan, @c400CScan)
					RegC490 (@aRegC490,dDataDe,dDataAte, "2D",@nPos490)
				EndIf


				// Laco por Reducao Z
				cPDV	:= cChvPDV
				cChave 	:= cPDV+dDtReduz
				While !(cAliasSFT)->(Eof())  .AND.  (cChave==(cPDV+dDtReduz))

					// Tratamento para DBF
					If !lTop
						SPEDSeek(cAliasSB1,,xFilial("SB1")+(cAliasSFT)->FT_PRODUTO)
						If SPEDSeek("SD2",3,xFilial("SD2")+(cAliasSFT)->(FT_NFISCAL+FT_SERIE+FT_CLIEFOR+FT_LOJA+FT_PRODUTO+FT_ITEM))
							SPEDSeek(cAliasSF4,1,xFilial(cAliasSF4)+SD2->D2_TES)
						EndIf
					EndIf

//			   		nVlBrtLj := ( (cAliasSFI)->FI_VALCON + (cAliasSFI)->FI_ISS ) // Valor Bruto, FI_VALCON (Valor contabil) + FI_ISS (Valor de Servicos)
					nVlBrtLj := ( IIf((cAliasSFT)->FT_VALCONT==(cAliasSFI)->FI_VALCON,(cAliasSFI)->FI_VALCON,(cAliasSFT)->FT_VALCONT) + (cAliasSFI)->FI_ISS ) // Valor Bruto, FI_VALCON (Valor contabil) + FI_ISS (Valor de Servicos)
					RegC405(@aRegC405	,nPos400,(cAliasSFI)->FI_DTMOVTO,(cAliasSFI)->FI_CRO,;
							(cAliasSFI)->FI_NUMREDZ,(cAliasSFI)->FI_NUMFIM,(cAliasSFI)->FI_GTFINAL,nVlBrtLj,;
							@nPos405,(cAliasSFT)->FT_DESCONT,@c405AScan,(cAliasSFI)->FI_CANCEL)

					If lMVGerPrdC
						cConta 		:= Reg0500(@aReg0500,(cAliasSFT)->FT_CONTA,,cAliasSFT)
						cProd 		:= (cAliasSB1)->B1_COD+Iif(lConcFil,cFilSB1,"")
					EndIf

					RegC481(cAliasSFT,aRegC481,aRegC485,(cAliasSFI)->FI_PDV,(cAliasSFI)->FI_DTMOVTO,nPos405,@aReg0200,@aReg0205,@aReg0190,dDataDe,dDataAte,cAlias,;
							cRegime,@aRegM400,@aRegM410,@aRegM800,@aRegM810,@aRegM210,@aRegM610,@aRegC491,@aRegC495,lCumulativ,nRelacFil,;
							@aRegM230,@aRegM630,@aReg0500,nPos490,lConsolid,lTop,@aRegC489,@aRegC499,@aReg1010,@aReg1020,lAchouCDG,nMVM996TPR,lA1_TPREG,cMvEstado,;
							lCmpsSB5,lCpoPtPis,lCpoPtCof,@nPos0200,cConta,cProd,lAScan)

			  		(cAliasSFT)->(dbSkip())

			  		// Atualiza Variaveis para laco. Utilizadas para contemplar funcionalidade em DBF
					cPDV		:= (cAliasSFT)->FT_PDV
					dDtReduz    := DtoS((cAliasSFT)->FT_ENTRADA)
				EndDo

				// GRAVA REDUCAO Z E FILHOS
				If !lConsolid
					// Informacoes do semaforo //Comentado - NewThread
					cJobFile	:=	CriaTrab( Nil , .F. )+ "_EFC_" + ".job"

					// Adiciona o nome do arquivo de Job no array aJobAux // Comentado - NewThread
					aAdd( aJobAux , cJobFile )

					// Grava
					nPaiC	:=	Iif(nPaiC==0,1,nPaiC)

					// Chama Thread -
					lExitFor := .F.
  					For nI:=1 To 50

						If lExitFor
							Exit
						EndIF
						

					While .T.

						If ( IPCGo( cSemaphore,  FWGrpCompany(),FWCodFil(),cAlias,cNomeTRB,,,,,nPaiC,,nPos400,aRegC405,nCt405,aRegC481,aRegC485,n_SPCRecno,cJobFile,cJobAux ) )

							lExitFor := .T.
							Exit
						Else

							Sleep(1000)
						EndIf

					EndDo
						

					Next nI
					// Assume novo valor do Recno
					n_SPCRecno := (n_SPCRecno + Len(aRegC405) + Len(aRegC481) + Len(aRegC485) )

				    nCt405++
 				 	aRegC405 	:= {}
					aRegC481 	:= {}
					aRegC485 	:= {}
					nCt481		:= 0
					nCt485		:= 0

				EndIf

				// Tratamento DBF
				If !lTop // Posiciona na SFI e SLG corretas
		    		lSFI_SLG := (cAliasSFI)->(MsSeek(xFilial(cAliasSFI)+DToS((cAliasSFT)->FT_ENTRADA))) .AND. (cAliasSLG)->(MsSeek(xFilial(cAliasSLG)+ (cAliasSFI)->FI_PDV))
		  		EndIf
			Else
				(cAliasSFT)->(dbSkip())
			EndIf
		EndDo
		// GRAVA PDV
		If !lConsolid
			PCGrvReg 	(cAlias, nPos400, aRegC489,(nCt405-1)	, ,nPaiC,, .T.)
			PCGrvReg 	(cAlias, nPos400, aRegC400, 			, ,nPaiC)
		EndIf

	Else
		(cAliasSFT)->(dbSkip())
	EndIF // If lSFI_SLG

EndDo

For nX := 1 To Len( aJobAux )
	// Informacoes do semaforo
	cJobFile	:=	aJobAux[ nX ]
	While .T.
		If !File( cJobFile )


			Exit
		Else

		EndIf
		Sleep(2500)
	End
Next nX

#IFDEF TOP
	If (TcSrvType ()<>"AS/400")
		DbSelectArea (cAliasSFT)
		(cAliasSFT)->(DbCloseArea ())
	Else
#ENDIF
		RetIndex("SFT")
#IFDEF TOP
	EndIf
#ENDIF


Return

Static Function CF5CodCre (cCodCre)

Local cRet := ""
Local cFiltro		:= ""
Local cIndex		:= ""
Local nIndex		:=	0
Local cAliasCF5		:= "CF5"

dbSelectArea(cAliasCF5)
(cAliasCF5)->(dbSetOrder(1))
(cAliasCF5)->(dbGoTop())

cIndex	:= CriaTrab(NIL,.F.)
cFiltro	:= 'CF5_FILIAL=="'+xFilial ("CF5")+'"'
cFiltro += ' .AND. CF5_CODIGO == "'+Alltrim(cCodCre)+ '"'

IndRegua (cAliasCF5, cIndex, CF5->(IndexKey ()),,cFiltro)
nIndex := RetIndex(cAliasCF5)

#IFNDEF TOP
	DbSetIndex(cIndex+OrdBagExt ())
#ENDIF

DbSelectArea(cAliasCF5)
DbSetOrder(nIndex+1)
(cAliasCF5)->(dbGoTop())

If !(cAliasCF5)->(Eof ())
	cRet		:= (cAliasCF5)->CF5_CODCRE
EndIF

RetIndex(cAliasCF5)

Return cRet

Static Function RegP210 (aRegP210,aRegP200, aRegPE210)

Local nPos	:= 0
Local nP200	:= 0
Local nP210	:= 0
Local nAjRed:= 0
Local nAjAcr:= 0
Local cInd		:= ""
Local nVlAj		:= 0
Local cCodAj	:= ""
Local cNumDoc	:= ""
Local cDescrAj	:= ""
Local cDtRef	:= ""

//Roda registro pai P200
For nP200:= 1 To Len(aRegP200)

	//Roda registro Filho P210
	For nP210 := 1 to Len(aRegPE210)

		//Verifica se o cdigo da receita do registro pai © igual ao registro filho
		If 	aRegP200[nP200][7] == aRegPE210[nP210][7]

			cInd		:= aRegPE210[nP210][1]
			nVlAj		:= aRegPE210[nP210][2]
			cCodAj		:= aRegPE210[nP210][3]
			cNumDoc		:= aRegPE210[nP210][4]
			cDescrAj	:= aRegPE210[nP210][5]
			cDtRef		:= aRegPE210[nP210][6]

			If cInd== "0"
				nAjRed+= nVlAj
			ElseIF cInd == "1"
				nAjAcr+= nVlAj
			EndIF

			aAdd(aRegP210, {})
			nPos	:=	Len (aRegP210)
			aAdd (aRegP210[nPos],nP200)		//Relao com registro Pai
			aAdd (aRegP210[nPos],"P210")	//01 - Reg
			aAdd (aRegP210[nPos],cInd)		//02 - IND_AJ
			aAdd (aRegP210[nPos],nVlAj)		//03 - VL_AJ
			aAdd (aRegP210[nPos],cCodAj)	//04 - COD_AJ
			aAdd (aRegP210[nPos],cNumDoc)	//05 - NUM_DOC
			aAdd (aRegP210[nPos],cDescrAj)	//06 - DESCR_AJ
			aAdd (aRegP210[nPos],cDtRef)	//07 - DT_REF

		EndIF

	Next nP210

	//Atualiza registro P200 com valores de ajustes do P210
    aRegP200[nP200][4]:=nAjRed
    aRegP200[nP200][5]:=nAjAcr
	aRegP200[nP200][6]	:= aRegP200[nP200][3] - aRegP200[nP200][4] + aRegP200[nP200][5]

Next nP200
Return
//-------------------------------------------------------------------
/*/{Protheus.doc} BlocoI
Funo que finaliza os valores do registro I100 e grava estas informaµes
no bloco M.

@param  aRegI100  - Array com informaµes do registro I100
		  aRegM210  - Array com informaµes do registro M210
		  aRegM610  - Array com informaµes do registro M260
@author Erick G Dias
/*/
//-------------------------------------------------------------------
Static Function ApurBlocI(aRegI100,aRegM210,aRegM610)

Local nX		:= 0
Local aPar	:= {}

For nX	:= 1 to Len(aRegI100)

	aRegI100[nX][7] := aRegI100[nX][3] - aRegI100[nX][5] - aRegI100[nX][6]	 //Receita - Deduo gen©rica - Deduo Espec­fica
	aRegI100[nX][10] := aRegI100[nX][7]

	If aRegI100[nX][4] $ "01/02/03"
		//Valor do PIS
		aRegI100[nX][9]:= Round((aRegI100[nX][7] * aRegI100[nX][8]) / 100,2)
		//Valor da COFINS
		aRegI100[nX][12]:= Round((aRegI100[nX][10] * aRegI100[nX][11]) / 100,2)
	EndIF

	aPar		:= {}
	aAdd(aPar,aRegI100[nX][4]) 	//CST DE PIS
	aAdd(aPar,aRegI100[nX][8]) 	//ALQUOTA DE PIS
	aAdd(aPar,aRegI100[nX][7]) 	//BASE DE CLCULO DE PIS
	aAdd(aPar,aRegI100[nX][3]) 	//TOTAL DA RECEITA
	aAdd(aPar,aRegI100[nX][9])	//VALOR DE PIS
	aAdd(aPar,.F.)  				//Indica se © operao com pauta
	//Gerao do registro M200 e filhos
	RegM210(@aRegM210,,,.T.,,,.T.,,,,,,,,,aPar,.F.)

	aPar		:= {}
	aAdd(aPar,aRegI100[nX][4]) 	//CST DE PIS
	aAdd(aPar,aRegI100[nX][11])	//ALQUOTA DE COFINS
	aAdd(aPar,aRegI100[nX][10]) 	//BASE DE CLCULO DE COFINS
	aAdd(aPar,aRegI100[nX][3]) 	//TOTAL DA RECEITA
	aAdd(aPar,aRegI100[nX][12])	//VALOR DE PIS
	aAdd(aPar,.F.)  				//Indica se © operao com pauta
	//Gerao do registro M600 e filhos
	RegM610(@aRegM610,,,.T.,,,.T.,,,,,,,,,aPar,.F.)

Next nX

Return

static Function ThreadP(lBlocoPRH,dDataDe,cEmp,cFil,cAliasP,cJobPAux,cAliasPE,cNomeTRB)
Local	aStruct	:= {}
Local cAlias		:= "REGP"
Local bError         := { |e| oError := e , Break(e) }
Local bErrorBlock    := ErrorBlock( bError )
Local oError
Local lErro	:= .F.

RpcSetType(3)
RpcSetEnv(cEmp,cFil)

BEGIN SEQUENCE
	TRY
		If lBlocoPRH // Indica se buco as informaµes diretamente do RH
			cAliasP:= fS033Sped(Alltrim(StrZero(Month(dDataDe),2))+Alltrim(Str(Year(dDataDe))) )
		Else		//Caso contr¡rio devo buscar as informaµes do Faturamento e aplicar a al­quota da tabela CG1 (5.1.1)
			cAliasP:= RhInssPat(Alltrim(StrZero(Month(dDataDe),2))+Alltrim(Str(Year(dDataDe))))
		EndIf

		aStruct :=  (cAliasP)->(dbStruct())

		PCCriaTab( cNomeTRB , cAlias, aStruct,iIF(lBlocoPRH,aStruct[2][1] ,aStruct[7][1]))
		Append From (cAliasP)

  	CATCH e as IdxException
  		ConOut( ProcName() + " " + Str(ProcLine()) + " " + e:cErrorText )
  END TRY
RECOVER

lErro	:= .T. //Ir¡ passar por este trecho se ocorrer algum erro
ConOut( ProcName() + " " + Str(ProcLine()) + " Erro na gerao do bloco P - " +SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL) + " - "   + oError:Description )

END SEQUENCE
ErrorBlock( bErrorBlock )

IF lErro
	PutGlbValue( cJobPAux , '2' )//Ocorreu algum erro
Else
	PutGlbValue( cJobPAux , '1' )//Finalizado sem erro
EndIF
GlbUnLock()

RpcClearEnv()
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} RetCodRec
Funo que retorna o cdigo da receita a ser utilizado nos registros
M205 e M605.
@author Simone dos Santos de Oliveira
/*/
//-------------------------------------------------------------------
Static Function RetCodRec()
Local cMVCODREC:= aParSX6[47]
Local aRetCod:= {}

If !Empty(cMVCODREC) .And. Left(cMVCODREC,1)=="{" .And. SubStr(cMVCODREC,Len(cMVCODREC),1)=="}" .And. Len(&(cMVCODREC))==4
	aRetCod	:=	&(cMVCODREC)
Else
	aRetCod	:=	{'810902','691201','217201','585601'}
EndIf
Return aRetCod

//-------------------------------------------------------------------
/*/{Protheus.doc} RegC175
REGISTRO ANALTICO DO DOCUMENTO (C“DIGO 65)
@author Simone dos Santos de Oliveira
/*/
//-------------------------------------------------------------------
Static Function RegC175(cAlias,nRelac, aRegC175,aRegC100, cAliasSFT, aClasFis, aRegM210,aRegM610,aReg0500,lPisZero,lCofZero,cAliasSB1,cAliasSF4,aDevMsmPer,nPosDev,lPautaPIS,lPautaCOF,;
							aWizard,lCumulativ,aDevolucao,aRegM220,aRegM230,lCmpDescZF,aRegM620,aRegM630,aRegM400,aRegM410,aRegM800,aRegM810)
							
Local  aBaseAlqUn	:= {}
Local  cConta		:= ""
Local	lMVcontZF  :=	aParSX6[34]
Local 	nPos		:= 0
Local	nPosC175	:= 0
Local	nPisPauta 	:= 	0
Local	nQtdBPis  	:= 	0
Local	nBasePis 	:= 	0
Local	nAliqPis  	:= 	0
Local	nValPis	:=	0
Local	nCofPauta 	:= 	0
Local	nQtdBCof  	:= 	0
Local	nBaseCof  	:= 	0
Local	nAliqCof  	:= 	0
Local	nValCof	:=	0
Local  lPauta		:= .F.

Default	lPautaPIS	:=	aFieldPos[20]
Default	lPautaCOF	:=	aFieldPos[21]
	

	//Preenchimento Conta Anal­tica Cont¡bil
	cConta := Reg0500(@aReg0500,(cAliasSFT)->FT_CONTA,,cAliasSFT)
	
	//Verifico se © CST de pauta. No verifico COFINS, pois se o PIS © pauta COFINS tamb©m dever¡ ser
	If (cAliasSFT)->FT_CSTPIS == '03'
		lPauta	:= .T.
	EndIF
	
	//Ir¡ preencher valores de pauta se PIS for tributado a al­quota por unidade de medida de produto
		//Caso no for por pauta, ir¡ gerar C175 com valores de percentual	
		If (((cAliasSFT)->FT_VALPIS > 0 .Or. (cAliasSFT)->FT_BASEPIS > 0 .OR. (cAliasSFT)->FT_ALIQPIS >0) .OR. ;
		     ((cAliasSFT)->FT_VALPS3 > 0 .Or. (cAliasSFT)->FT_BASEPS3 > 0 .OR. (cAliasSFT)->FT_ALIQPS3 >0))
			If (lPautaPIS .And. (cAliasSFT)->FT_PAUTPIS > 0) .OR. (cAliasSB1)->B1_VLR_PIS > 0
				aBaseAlqUn	:=	VlrPauta(lCmpNRecFT, lCmpNRecB1, "PIS",cAliasSFT,cAliasSB1,lCmpNRecF4,lPautaPIS)
				nPisPauta 	:= 	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][1] , (cAliasSFT)->FT_PAUTPIS)
				nQtdBPis  	:= 	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][2] , (cAliasSFT)->FT_QUANT)
	
				IF nPosDev >0
					nValPis		:=	(cAliasSFT)->FT_VALPIS - aDevMsmPer[nPosDev][8]
				Else
					nValPis		:=	(cAliasSFT)->FT_VALPIS
				EndIF
			Else
				If !lDevolucao
					IF (cAliasSFT)->FT_CSTPIS == "05"
						nBasePis  	:= 	(cAliasSFT)->FT_BASEPS3
						nAliqPis  	:= 	Iif(lPisZero,0,(cAliasSFT)->FT_ALIQPS3)
						nValPis		:=	Iif(lPisZero,0,(cAliasSFT)->FT_VALPS3)
					Else
						nBasePis  	:= 	(cAliasSFT)->FT_BASEPIS
						nAliqPis  	:= 	Iif(lPisZero,0,(cAliasSFT)->FT_ALIQPIS)
						nValPis		:=	Iif(lPisZero,0,(cAliasSFT)->FT_VALPIS)
					EndIF
				Elseif nPosDev > 0
					nBasePis  	:= 	(cAliasSFT)->FT_BASEPIS - aDevMsmPer[nPosDev][7]
					nAliqPis  	:= 	Iif(lPisZero,0,(cAliasSFT)->FT_ALIQPIS)
					nValPis		:=	Iif(lPisZero,0,(cAliasSFT)->FT_VALPIS - aDevMsmPer[nPosDev][8])
				Else
					nBasePis  	:=	0
					nAliqPis  	:=	Iif(lPisZero,0,(cAliasSFT)->FT_ALIQPIS)
					nValPis		:=	0
				EndIF
			EndIF
		Endif
		

		//Ir¡ preencher valores de pauta se COFINS for tributado a al­quota por unidade de medida de produto Caso no for por pauta, ir¡ gerar C175 com valores de percentual
		If (((cAliasSFT)->FT_VALCOF > 0 .Or. (cAliasSFT)->FT_BASECOF > 0 .OR. (cAliasSFT)->FT_ALIQCOF >0) .OR. ;
		     ((cAliasSFT)->FT_VALCF3 > 0 .Or. (cAliasSFT)->FT_BASECF3 > 0 .OR. (cAliasSFT)->FT_ALIQCF3 >0))
	
			If (lPautaCOF .And. (cAliasSFT)->FT_PAUTCOF > 0) .OR. (cAliasSB1)->B1_VLR_COF > 0
				aBaseAlqUn	:=	VlrPauta(lCmpNRecFT, lCmpNRecB1, "COF",cAliasSFT,cAliasSB1,lCmpNRecF4,lPautaCOF)
				nCofPauta 	:= 	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][1] , (cAliasSFT)->FT_PAUTCOF)
				nQtdBCof  	:= 	Iif( Len(aBaseAlqUn) >0, aBaseAlqUn[1][2] , (cAliasSFT)->FT_QUANT)
	
				IF nPosDev >0
					nValCof		:=	(cAliasSFT)->FT_VALCOF - aDevMsmPer[nPosDev][10]
				Else
					nValCof		:=	(cAliasSFT)->FT_VALCOF
				EndIF
	
			Else
				If !lDevolucao
					IF (cAliasSFT)->FT_CSTCOF == "05"
						nBaseCof  	:= 	(cAliasSFT)->FT_BASECF3
						nAliqCof  	:= 	Iif(lCofZero,0,(cAliasSFT)->FT_ALIQCF3)
						nValCof		:=	Iif(lCofZero,0,(cAliasSFT)->FT_VALCF3)
					Else
						nBaseCof  	:= 	(cAliasSFT)->FT_BASECOF
						nAliqCof  	:= 	Iif(lCofZero,0,(cAliasSFT)->FT_ALIQCOF)
						nValCof		:=	Iif(lCofZero,0,(cAliasSFT)->FT_VALCOF)
					EndIF
				Elseif nPosDev > 0
					nBaseCof  	:= 	(cAliasSFT)->FT_BASECOF - aDevMsmPer[nPosDev][9]
					nAliqCof  	:= 	Iif(lCofZero,0,(cAliasSFT)->FT_ALIQCOF)
					nValCof		:=	Iif(lCofZero,0,(cAliasSFT)->FT_VALCOF - aDevMsmPer[nPosDev][10])
				Else
					nBaseCof  	:=	0
					nAliqCof  	:=	Iif(lCofZero,0,(cAliasSFT)->FT_ALIQCOF)
					nValCof		:=	0
				EndIF
			EndIF
		EndIF

	nPosC175 := aScan(aRegC175, {|aX| aX[2]==(cAliasSFT)->FT_CFOP .And. ;							//CFOP
										   aX[5]==(cAliasSFT)->FT_CSTPIS .And. ;						//CST de PIS
										   Iif(lPauta,aX[9]== nPisPauta,aX[7]==nAliqPis).And. ;		//Verifica al­quota de PIS, pode ser pauta ou al­quota percentual
										   Iif(lPauta,aX[15]==nCofPauta,aX[13]==nAliqCof) .AND.;     //Verifica al­quota de COFINS, pode ser pauta ou al­quota percentual 
										   aX[11]==(cAliasSFT)->FT_CSTCOF  })							//CST de COFINS
										   
	
	If nPosC175 == 0
		aAdd(aRegC175, {})
		nPos	:=	Len(aRegC175)
		aAdd (aRegC175[nPos], "C175")	 	   						//01 - REG
		aAdd (aRegC175[nPos], (cAliasSFT)->FT_CFOP )				//02 - CFOP 
		aAdd (aRegC175[nPos], (cAliasSFT)->FT_TOTAL + Iif(lCmpDescZF,(cAliasSFT)->FT_DESCZFR,0))	//03 - VL_OPR
		aAdd (aRegC175[nPos], (cAliasSFT)->FT_DESCONT)			//04 - VL_DESC 
		aAdd (aRegC175[nPos], (cAliasSFT)->FT_CSTPIS)		 		//05 - CST_PIS 
		aAdd (aRegC175[nPos], Iif(lPauta,"",0))					//06 - VL_BC_PIS
		aAdd (aRegC175[nPos], Iif(lPauta,"",0))	 		  		//07 - ALIQ_PIS
		aAdd (aRegC175[nPos], Iif(lPauta,0,""))					//08 - QUANT_BC_PIS 
		aAdd (aRegC175[nPos], Iif(lPauta,0,""))					//09 - ALIQ_PIS_QUANT 
		aAdd (aRegC175[nPos], 0)  			  						//10 - VL_PIS
		aAdd (aRegC175[nPos], (cAliasSFT)->FT_CSTCOF)	 			//11 - CST_COFINS 
		aAdd (aRegC175[nPos], Iif(lPauta,"",0))					//12 - VL_BC_COFINS 
		aAdd (aRegC175[nPos], Iif(lPauta,"",0))					//13 - ALIQ_COFINS 
		aAdd (aRegC175[nPos], Iif(lPauta,0,""))					//14 - QUANT_BC_COFINS 
		aAdd (aRegC175[nPos], Iif(lPauta,0,""))					//15 - ALIQ_COFINS_QUANT
		aAdd (aRegC175[nPos], 0)	 									//16 - VL_COFINS 
		aAdd (aRegC175[nPos], cConta)	 							//17 - COD_CTA
		aAdd (aRegC175[nPos], "")	 								//18 - INFO_COMPL		
		
		If !lPauta		
			aRegC175[nPos][07] := Iif(nAliqPis>0 .Or. lPisZero,nAliqPis,0)		//07 - ALIQ_PIS
		EndIF
		
		If nQtdBPis > 0
			IF !lDevolucao
				aRegC175[nPos][08] += nQtdBPis					 					//08 - QUANT_BC_PIS				
			Else
				aRegC175[nPos][08] += 0					 							//08 - QUANT_BC_PIS			
			EndIF
		Else
		    IF lMVcontZF .And. (cAliasSFT)->FT_DESCZFR > 0 .And. (cAliasSFT)->FT_ALIQCOF == 0 .And. (cAliasSFT)->FT_ALIQPIS == 0 .And. (cAliasSFT)->FT_TIPOMOV == "S"
				nBasePis:= (cAliasSFT)->FT_VALCONT
			EndIf			
			aRegC175[nPos][06] += nBasePis											//06 - VL_BC_PIS
		EndIF
		
		If lPauta
			aRegC175[nPos][09] += Iif(lPisZero,0,nPisPauta) 						//09 - ALIQ_PIS - Reais		
		EndIf

		aRegC175[nPos][10] += nValPis												//10 - VL_PIS
		
		IF !lPauta
			aRegC175[nPos][13] := IIf(nAliqCof	>0 .Or. lCofZero,nAliqCof,0)		//13 - ALIQ_COFIN
		EndIF

		If nQtdBCof > 0
			IF !lDevolucao
				aRegC175[nPos][14] += nQtdBCof 					 					//14 - QUANT_BC_COFINS				
			Else
				aRegC175[nPos][14] += 0 					 							//14 - QUANT_BC_COFINS			
			EndIF
		Else
			IF lMVcontZF .And. (cAliasSFT)->FT_DESCZFR > 0 .And. (cAliasSFT)->FT_ALIQCOF == 0 .And. (cAliasSFT)->FT_ALIQPIS == 0 .And. (cAliasSFT)->FT_TIPOMOV == "S"
				nBaseCof:= (cAliasSFT)->FT_VALCONT
			EndIf			
			aRegC175[nPos][12] += nBaseCof 											//12 - VL_BC_COFINS
		EndIF

		If lPauta
	    	aRegC175[nPos][15] += Iif(lCofZero,0,nCofPauta) 						//15 - ALIQ_COFINS - Reais	  
	  	EndIf

		aRegC175[nPos][16] += Iif(lCofZero,0,nValCof)								//16 - VL_COFINS
		
	Else
			
		aRegC175[nPosC175][03] += (cAliasSFT)->FT_VALCONT			//03 - VL_OPR
		aRegC175[nPosC175][04] += (cAliasSFT)->FT_DESCONT			//04 - VL_DESC 
		
		If nQtdBPis > 0
			IF !lDevolucao
				aRegC175[nPosC175][08] += nQtdBPis					 					//08 - QUANT_BC_PIS				
			Else
				aRegC175[nPosC175][08] += 0					 							//08 - QUANT_BC_PIS				
			EndIF
		Else
		    IF lMVcontZF .And. (cAliasSFT)->FT_DESCZFR > 0 .And. (cAliasSFT)->FT_ALIQCOF == 0 .And. (cAliasSFT)->FT_ALIQPIS == 0 .And. (cAliasSFT)->FT_TIPOMOV == "S"
				nBasePis:= (cAliasSFT)->FT_VALCONT
			EndIf		
			aRegC175[nPosC175][06] += nBasePis											//06 - VL_BC_PIS
		EndIF
		
		aRegC175[nPosC175][10] += nValPis												//10 - VL_PIS
		
		
		If nQtdBCof > 0
			IF !lDevolucao
				aRegC175[nPosC175][14] += nQtdBCof 					 					//14 - QUANT_BC_COFINS			
			Else
				aRegC175[nPosC175][14] += 0 					 							//14 - QUANT_BC_COFINS			
			EndIF
		Else
			IF lMVcontZF .And. (cAliasSFT)->FT_DESCZFR > 0 .And. (cAliasSFT)->FT_ALIQCOF == 0 .And. (cAliasSFT)->FT_ALIQPIS == 0 .And. (cAliasSFT)->FT_TIPOMOV == "S"
				nBaseCof:= (cAliasSFT)->FT_VALCONT
			EndIf		
			aRegC175[nPosC175][12] += nBaseCof 											//12 - VL_BC_COFINS
		EndIF


		aRegC175[nPosC175][16] += Iif(lCofZero,0,nValCof)								//16 - VL_COFINS
		
	EndIf

	//Processa registro M210 para a contribuio deste item.
	RegM210(aRegM210,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM220,,,@aRegM230,,cAliasSB1)
	//Processa registro M610 para a contribuio deste item.
	RegM610(aRegM610,cAliasSFT,aWizard[4][1],lCumulativ,aDevolucao,@aRegM620,,,@aRegM630,,cAliasSB1)
	
	//PIS
	If (cAliasSFT)->FT_CSTPIS $ "04/05/06/07/08/09"
		If !(cAliasSFT)->FT_CSTPIS $ "05" //se for CST 04, 06, 07, 08, 09 grava M400 direto
			RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1,,,,IIF(Iif(lCmpDescZF,(cAliasSFT)->FT_DESCZFR,0) > 0 ,(cAliasSFT)->FT_TOTAL	+ (cAliasSFT)->FT_DESCZFR,0))
		ElseIF (cAliasSFT)->FT_ALIQPS3 == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
			RegM400(aRegM400,aRegM410,cAliasSFT,@aReg0500,,cAliasSB1,,,,IIF(Iif(lCmpDescZF,(cAliasSFT)->FT_DESCZFR,0) > 0 ,(cAliasSFT)->FT_TOTAL	+ (cAliasSFT)->FT_DESCZFR,0))
		EndIF
	EndIF
	//COFINS
	If (cAliasSFT)->FT_CSTCOF $ "04/05/06/07/08/09"
		If !(cAliasSFT)->FT_CSTCOF $ "05" //se for CST 04, 06, 07, 08, 09 grava M400 direto
			RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1,,,,IIF(Iif(lCmpDescZF,(cAliasSFT)->FT_DESCZFR,0) > 0 ,(cAliasSFT)->FT_TOTAL	+ (cAliasSFT)->FT_DESCZFR,0))
		ElseIF (cAliasSFT)->FT_ALIQCF3 == 0 //se for CST 05, verifica se a aliquopta de PIS esta zerada para gerar M400
			RegM800(aRegM800,aRegM810,cAliasSFT,@aReg0500,,cAliasSB1,,,,IIF(Iif(lCmpDescZF,(cAliasSFT)->FT_DESCZFR,0) > 0 ,(cAliasSFT)->FT_TOTAL	+ (cAliasSFT)->FT_DESCZFR,0))
		EndIF
	EndIF

Return


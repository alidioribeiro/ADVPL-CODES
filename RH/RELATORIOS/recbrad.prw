#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#DEFINE CRLF CHR( 13 )+CHR( 10 )

/*                                                                                                                             
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ RECBRAD  ณ Autor ณ R.H. 			        ณ Data ณ 14.03.95 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Emissao do Recibos de Pagamento Eletronico BCO BRADESCO    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ GPER030( void )                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Generico                                                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณOswaldo L ณ 22/09/17 ณ DRHPAG-1559 ณ Gerar Holerite no layout Bradesco ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function RecBrad()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Variaveis Locais ( Basicas )                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cString:="SRA"        // alias do arquivo principal ( Base )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Variaveis Locais ( Programa )                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local nExtra, cIndCond, cIndRc
Local Baseaux := "S", cDemit := "N"

PRIVATE cMesAnoRef

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis utilizadas no programa atraves da funcao    ณ
//ณ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ณ
//ณ identificando as variaveis publicas do sistema utilizadas no codigo ณ
//ณ Incluido pelo assistente de conversao do AP5 IDE                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetPrvt( "CSTRING, BASEAUX" )
SetPrvt( "CDEMIT, ARETURN, NOMEPROG, ALINHA, NLASTKEY, CPERG" )
SetPrvt( "CSEM_DE, CSEM_ATE, ALANCA, APROVE, ADESCO, ABASES" )
SetPrvt( "AINFO, ACODFOL, LI, TITULO, WNREL" )
SetPrvt( "DDATAREF, ESC, SEMANA, CFILDE, CFILATE" )
SetPrvt( "CCCDE, CCCATE, CMATDE, CMATATE, CNOMDE, CNOMATE" )
SetPrvt( "CHAPADE, CHAPAATE, MENSAG1, MENSAG2, MENSAG3, CSITUACAO" )
SetPrvt( "CCATEGORIA, CBASEAUX, CMESANOREF, TAMANHO, LIMITE, AORDBAG" )
SetPrvt( "CMESARQREF, CARQMOV, CALIASMOV, CACESSASR1, CACESSASRA, CACESSASRC" )
SetPrvt( "CACESSASRD, LATUAL, CARQNTX, CINDCOND, ADRIVER, CCOMPAC" )
SetPrvt( "CNORMAL, CINICIO, CFIM, TOTVENC, TOTDESC, FLAG" )
SetPrvt( "CHAVE, DESC_FIL, DESC_END, DESC_CC, DESC_FUNC, DESC_MSG1" )
SetPrvt( "DESC_MSG2, DESC_MSG3, CFILIALANT, CFUNCAOANT, CCCANT, VEZ" )
SetPrvt( "ORDEMZ, NATELIM, NBASEFGTS, NFGTS, NBASEIR, NBASEIRFE" )
SetPrvt( "ORDEM_REL, DESC_CGC, NCONTA, NCONTR, NCONTRT, NLINHAS" )
SetPrvt( "CDET, NCOL, NTERMINA, NCONT, NCONT1, NVALIDOS, NSEQ_, CREG, LCONTINUA" )
SetPrvt( "NVALSAL, DESC_BCO, CCHAVESEM, DESC_PAGA, NPOS, CARRAY, NHDL, CNOMEARQ, NSEQ_" )
SetPrvt( "CDEPTODE, CDEPTOATE", "CROTEIRO", "CPERIODO", "SEMANA", "CPROCESSO", "CTIPOROT", "DDATAPAG", "CCNPJ" )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Variaveis Private( Basicas )                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private nomeprog :="RECBRAD"
Private aLinha   := { }, nLastKey := 0
Private cPerg    := "RECBRA"
Private cSem_De  := "  /  /    "
Private cSem_Ate := "  /  /    "
Private nAteLim , nBaseFgts , nFgts , nBaseIr , nBaseIrFe

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Variaveis Private( Programa )                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private aLanca := {}
Private aProve := {}
Private aDesco := {}
Private aBases := {}
Private aInfo  := {}
Private aCodFol:= {}
Private li     := 0
Private nHdl   := 0
PRIVATE nSeq_  := 0
Private Titulo := "GERAวรO DE ARQUIVO BRADESCO P/RECIBOS DE PAGAMENTOS"
Private GERAOK
Private aPerAberto	:= {}
Private aPerFechado	:= {}
Private cMes 	:= ''
Private cAno 	:= ''

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica as perguntas selecionadas                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
VerPerg()
pergunte( cPerg, .F. )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@ 000,000 TO 250,500 DIALOG GERAOK TITLE OemToAnsi("Gera็ใo Holerite Eletronico - Bco Bradesco")

@ 030,010 SAY OemtoAnsi('Este programa fara a gera็ใo do arquivo magnetico para envio ')
@ 040,010 SAY OemtoAnsi('ao Banco Bradesco para disponibiliza็ใo do Holerite Eletronico ')

@ 104,162 BMPBUTTON TYPE 5 ACTION Pergunte(cPerg,.T.)
@ 104,190 BMPBUTTON TYPE 2 ACTION Close(GERAOK)
@ 104,218 BMPBUTTON TYPE 1 ACTION GERRImp1()

ACTIVATE DIALOG GERAOK CENTERED


Return


Static Function GERRImp1()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Carregando variaveis mv_par?? para Variaveis do Sistema.     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cProcesso  := mv_par01	//Processo
cRoteiro   := mv_par02 	//Emitir Recibos(Roteiro)
cPeriodo   := mv_par03 	//Periodo
Semana     := mv_par04 	//Numero da Semana

//Carregar os periodos abertos (aPerAberto) e/ou 
// os periodos fechados (aPerFechado), dependendo 
// do periodo (ou intervalo de periodos) selecionado
RetPerAbertFech(cProcesso	,; // Processo selecionado na Pergunte.
				cRoteiro	,; // Roteiro selecionado na Pergunte.
				cPeriodo	,; // Periodo selecionado na Pergunte.
				Semana		,; // Numero de Pagamento selecionado na Pergunte.
				NIL			,; // Periodo Ate - Passar "NIL", pois neste relatorio eh escolhido apenas um periodo.
				NIL			,; // Numero de Pagamento Ate - Passar "NIL", pois neste relatorio eh escolhido apenas um numero de pagamento.
				@aPerAberto	,; // Retorna array com os Periodos e NrPagtos Abertos
				@aPerFechado ) // Retorna array com os Periodos e NrPagtos Fechados
				
// Retorna o mes e o ano do periodo selecionado na pergunte.
AnoMesPer(	cProcesso	,; // Processo selecionado na Pergunte.
			cRoteiro	,; // Roteiro selecionado na Pergunte.
			cPeriodo	,; // Periodo selecionado na Pergunte.
			@cMes		,; // Retorna o Mes do Processo + Roteiro + Periodo selecionado
			@cAno		,; // Retorna o Ano do Processo + Roteiro + Periodo selecionado     
			Semana		 ) // Retorna a Semana do Processo + Roteiro + Periodo selecionado
			
dDataRef := CTOD("01/" + cMes + "/" + cAno)

cFilDe     := mv_par05
cFilAte    := mv_par06
cCcDe      := mv_par07
cCcAte     := mv_par08
cMatDe     := mv_par09
cMatAte    := mv_par10
cNomDe     := mv_par11
cNomAte    := mv_par12
cSituacao  := mv_par13
cCategoria := mv_par14
lTipoRem   := mv_par15
cNomeArq   := mv_par16
cNum       := ''
lEhIncBDN  := ( MV_PAR17 == 1 )
cMesAnoRef := StrZero( Month( dDataRef ), 2 ) + StrZero( Year( dDataRef ), 4 )
cCodRec    := ''
Mensag1    := mv_par20
Mensag2    := mv_par21
Mensag3    := mv_par22
cDeptoDe   := mv_par23
cDeptoAte  := mv_par24
cCNPJ	   := mv_par25

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTabela de Tipo de Recibo no HPAGณ
//ณ                                ณ
//ณ001 Pagamento Mensal            ณ
//ณ002 Pagamento 1a quizena        ณ
//ณ003 Adiantamento                ณ
//ณ004 Ferias                      ณ
//ณ005 13 Salario                  ณ
//ณ006 Aluguel                     ณ
//ณ007 Participacao Nos Lucros     ณ
//ณ008 Folha de Pagamento Especial ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cTipoRot  :=  PosAlias("SRY",cRoteiro,SRA->RA_FILIAL,"RY_TIPO")
dDataPag  :=  PosAlias("RCH",(cProcesso+cPeriodo+Semana+cRoteiro),SRA->RA_FILIAL,"RCH_DTPAGO")

If cTipoRot == '1'
	cCodRec := '001'
ElseIf cTipoRot == '2'
	cCodRec := '003'
ElseIf cTipoRot == '3'
	cCodRec := '004'
ElseIf cTipoRot == '5' .or. cTipoRot == '6' 
	cCodRec := '005'
ElseIf cTipoRot == 'F'
	cCodRec := '007'
Else
	cCodRec := '008'
EndIf

Processa({|| GERRImp() },"Processando...")

//Gerar Arquivo
If nHdl > 0
	If fClose( nHdl )
		
		If nSeq_ <> 0
				If lEhIncBDN
					Aviso( 'AVISO', 'Gerado o arquivo ' + AllTrim( AllTrim( cNomeArq ) ) + CRLF + CRLF + ;
					'Guarde o n๚mero do lote deste arquivo para eventual substitui็ใo junto ao BDN: ' + cNum , {'OK'}, 3 )
				EndIf
			
		Else
			If fErase( cNomeArq ) == 0
				If lContinua
					Aviso( 'AVISO', 'Nใo existem registros a serem gravados. A gera็ใo do arquivo ' + AllTrim( AllTrim( cNomeArq ) ) + ' foi abortada ...', {'OK'} )
				EndIf
			Else
				MsgAlert( 'Ocorreram problemas na tentativa de dele็ใo do arquivo '+AllTrim( cNomeArq )+'.' )
			EndIf
		EndIf
	Else
		MsgAlert( 'Ocorreram problemas no fechamento do arquivo '+AllTrim( cNomeArq )+'.' )
	EndIf
EndIf

Close(GERAOK)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ GERRIMP  ณ Autor ณ R.H. - Ze Maria       ณ Data ณ 14.03.95 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Processamento Para emissao do Recibo                       ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ R030IMP( lEnd, Wnrel, cString )                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Generico                                                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GERRImp()//( lEnd, WnRel, cString, cMesAnoRef )
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Variaveis Locais ( Basicas )                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local lIgual                 //Vari vel de retorno na comparaao do SRC
Local cArqNew                //Vari vel de retorno caso SRC # SX3
Local aOrdBag     := {}
Local cArqMov     := ""
Local aCodBenef   := {}
Local aTInss	  := {}
Local nReg
Private nQtdComp   := 0
Private nTotRLote  := 0
Private cQuebraLin := Chr( 13 ) + Chr( 10 )  // Caracteres de Salto de Linha
cAcessaSR1  := &("{ || " + ChkRH("GPER030","SR1","2") + "}")
cAcessaSRA  := &("{ || " + ChkRH("GPER030","SRA","2") + "}")
cAcessaSRC  := &("{ || " + ChkRH("GPER030","SRC","2") + "}")
cAcessaSRD  := &("{ || " + ChkRH("GPER030","SRD","2") + "}")

// Registro Header da Empresa - TIPO 0
aTipo0 := {}
//              Descricao                                Ini  Fim   Tipo  Tam Dec  Conteudo
aAdd( aTipo0, { 'TIPO DE REGISTRO                     ', 001, 001,   'N',   1,  0, '"0"' } )
aAdd( aTipo0, { 'DESCRIวรO DO ARQUIVO                 ', 002, 021,   'C',  20,  0, '"REMESSA HPAG EMPRESA"' } )
aAdd( aTipo0, { 'CำDIGO DA EMPRESA                    ', 022, 030,   'N',   9,  0, 'StrZero(Val( MV_PAR19 ),9)' } )
aAdd( aTipo0, { 'NฺMERO DO LOTE                       ', 031, 039,   'N',   9,  0, 'cNum' } )
aAdd( aTipo0, { 'NฺMERO DO CNPJ OU CPF DA EMPRESA     ', 040, 048,   'N',   9,  0, '"0"+left(cCNPJ,8)' } )
aAdd( aTipo0, { 'FILIAL DO CNPJ OU CPF DA EMPRESA     ', 049, 052,   'N',   4,  0, 'substr(cCNPJ,9,4)' } )
aAdd( aTipo0, { 'DอGITO DE CONTROLE                   ', 053, 054,   'N',   2,  0, 'substr(cCNPJ,13,2)' } )
aAdd( aTipo0, { 'DATA DO MOVIMENTO ( DDMMSSAA )       ', 055, 062,   'N',   8,  0, 'GravaData( dDataRef, .F., 5 )  ' } )
aAdd( aTipo0, { 'REFERสNCIA DA OPERAวรO DO LOTE       ', 063, 063,   'C',   1,  0, 'IIF( MV_PAR17==1, "I", "S" )' } )
aAdd( aTipo0, { 'CำDIGO DE LANวAMENTO DO PRODUTO      ', 064, 068,   'C',   5,  0, '"00777"' } )
aAdd( aTipo0, { 'FILLER                               ', 069, 223,   'C', 155,  0, '  ' } )
aAdd( aTipo0, { 'INDICADOR DE REMESSA                 ', 224, 224,   'C',   1,  0, 'If(lTipoRem==1,"T"," ")' } ) 
aAdd( aTipo0, { 'RESERVADO                            ', 225, 233,   'C',   9,  0, '  ' } )
aAdd( aTipo0, { 'RESERVADO                            ', 234, 245,   'C',  12,  0, '  ' } )
aAdd( aTipo0, { 'SEQUENCIAL DO ARQUIVO                ', 246, 250,   'N',   5,  0, 'nSeq_' } )

// Registro Header do Comprovante - TIPO 1
aTipo1 := {}
//              Descricao                                Ini  Fim   Tipo  Tam Dec  Conteudo
aAdd( aTipo1, { 'TIPO DE REGSITRO                     ', 001, 001,   'N',   1,  0, '"1"' } )
aAdd( aTipo1, { 'REFERสNCIA DA OPERAวรO COMPROVANTE   ', 002, 002,   'C',   1,  0, '"I"' } )
aAdd( aTipo1, { 'TIPO DE COMPROVANTE                  ', 003, 005,   'N',   3,  0, 'cCodRec' } )
aAdd( aTipo1, { 'MสS\ANO DE REF. COMPROVANTE (MMAAAA) ', 006, 011,   'N',   6,  0, 'SubStr( GravaData( dDataRef, .F., 5 ), 3, 6 )' } )
aAdd( aTipo1, { 'DATA LIBERAวรO COMPROVANTE(DDMMAAAA) ', 012, 019,   'N',   8,  0, 'GravaData( DataValida( dDataRef ), .F., 5 )' } )
aAdd( aTipo1, { 'BANCO DO FUNCIONARIO                 ', 020, 023,   'N',   4,  0, '0237' } ) //'Subs( SRA->RA_BCDEPSA, 1, 3 )' } )
aAdd( aTipo1, { 'NฺMERO DA AGสNCIA DO FUNCIONมRIO     ', 024, 028,   'N',   5,  0, 'Subs( SRA->RA_BCDEPSA, 4, 4 )' } )
aAdd( aTipo1, { 'NฺMERO DA CONTA DO FUNCIONมRIO       ', 029, 041,   'N',  13,  0, 'cCtaFunc' } )
aAdd( aTipo1, { 'FILLER                               ', 042, 042,   'C',   1,  0, ''           } )
aAdd( aTipo1, { 'DอGITO DA CONTA DO FUNCIONมRIO       ', 043, 043,   'C',   1,  0, 'cDgCtaFunc' } )
aAdd( aTipo1, { 'NฺMERO DO CPF DO FUNCIONมRIO         ', 044, 054,   'N',  11,  0, 'SRA->RA_CIC' } )
aAdd( aTipo1, { 'NฺMERO DO PIS\PASEP DO FUNCIONมRIO   ', 055, 068,   'C',  14,  0, 'Transform( SRA->RA_PIS, "@R 999.999.999/99")' } )
aAdd( aTipo1, { 'NฺMERO DO RG DO FUNCIONมRIO          ', 069, 081,   'C',  13,  0, 'SRA->RA_RG' } )
aAdd( aTipo1, { 'NฺMERO DA CTPS DO FUNCIONมRIO        ', 082, 090,   'C',   9,  0, 'cNumCP' } )
aAdd( aTipo1, { 'NOME DO FUNCIONมRIO                  ', 091, 120,   'C',  30,  0, 'SRA->RA_NOME' } )
aAdd( aTipo1, { 'NฺMERO DE MATRอCULA DO FUNCIONมRIO   ', 121, 132,   'C',  12,  0, 'SRA->RA_MAT' } )
aAdd( aTipo1, { 'FUNวรO DO FUNCIONมRIO                ', 133, 172,   'C',  40,  0, 'GetAdvFVal( "SRJ", "RJ_DESC", xFilial( "SRJ" )+SRA->RA_CODFUNC, 1, "" )' } )
aAdd( aTipo1, { 'DATA ADMISSรO FUNCIONมRIO (DDMMAAAA) ', 173, 180,   'C',   8,  0, 'GravaData( SRA->RA_ADMISSA, .F., 5 )' } )
aAdd( aTipo1, { 'FILLER                               ', 181, 233,   'C',  53,  0, '  ' } )
aAdd( aTipo1, { 'RESERVADO                            ', 234, 245,   'C',  12,  0, '  ' } )
aAdd( aTipo1, { 'SEQUENCIAL DO ARQUIVO                ', 246, 250,   'N',   5,  0, 'nSeq_' } )

// Registro Detalhes do Comprovante - TIPO 2
aTipo2 := {}
//              Descricao                                Ini  Fim   Tipo  Tam Dec  Conteudo
aAdd( aTipo2, { 'TIPO DE REGISTRO                     ', 001, 001,   'N',   1,  0, '"2"' } )
aAdd( aTipo2, { 'CำDIGO DE LANวAMENTO                 ', 002, 005,   'C',   4,  0, 'cCodLan' } )
aAdd( aTipo2, { 'DESCRIวรO DE LANวAMENTO              ', 006, 025,   'C',  20,  0, 'cDescLan' } )
aAdd( aTipo2, { 'VALOR DO LANวAMENTO                  ', 026, 037,   'N',  12,  2, 'nValLan' } )
aAdd( aTipo2, { 'IDENTIFICADOR DE LANวAMENTO          ', 038, 038,   'N',   1,  0, 'cIdLan' } )
aAdd( aTipo2, { 'FILLER                               ', 039, 236,   'C', 198,  0, '  ' } )
aAdd( aTipo2, { 'RESERVADO                            ', 237, 245,   'C',   9,  0, '  ' } )
aAdd( aTipo2, { 'SEQUENCIAL DO ARQUIVO                ', 246, 250,   'N',   5,  0, 'nSeq_' } )

// Registro Mensagem do Comprovante - TIPO 3
aTipo3 := {}
//              Descricao                                Ini  Fim   Tipo  Tam Dec  Conteudo
aAdd( aTipo3, { 'TIPO DE REGISTRO                     ', 001, 001,   'N',   1,  0, '"3"' } )
aAdd( aTipo3, { 'MENSAGEM DO COMPROVANTE              ', 002, 041,   'C',  40,  0, 'cMsg' } )
aAdd( aTipo3, { 'FILLER                               ', 042, 236,   'C', 195,  0, '  ' } )
aAdd( aTipo3, { 'RESERVADO                            ', 237, 245,   'C',   9,  0, '  ' } )
aAdd( aTipo3, { 'SEQUENCIAL DO ARQUIVO                ', 246, 250,   'N',   5,  0, 'nSeq_' } )

// Registro Trailler do Comprovante TIPO 4
aTipo4 := {}
//              Descricao                                Ini  Fim   Tipo  Tam Dec  Conteudo
aAdd( aTipo4, { 'TIPO DE REGISTRO                     ', 001, 001,   'N',   1,  0, '"4"' } )
aAdd( aTipo4, { 'DATA PAGAMENTO (DDMMAAAA)            ', 002, 009,   'C',   8,  0, 'GravaData( dDataPag, .F., 5 )' } )
aAdd( aTipo4, { 'QTDE DEPENDENTES PARA IRRF           ', 010, 011,   'C',   2,  0, 'StrZero(Val(Sra->Ra_Depir),2)  ' } )
aAdd( aTipo4, { 'QTDE DEPENDENTES PARA IRRF           '/*salario familia*/, 012, 013,   'C',   2,  0, 'StrZero(Val(Sra->Ra_Depir),2)  ' } )
aAdd( aTipo4, { 'QTDE HORAS TRAB NA SEMANA            ', 014, 015,   'C',   2,  0, 'StrZero(Sra->Ra_HrSeman,2)  ' } )
aAdd( aTipo4, { 'SALARIO CONTRATUAL                   ', 016, 027,   'N',  12,  2, 'Sra->Ra_Salario' } )
aAdd( aTipo4, { 'QTDE FALTAS PERIODO FERIAS           ', 028, 029,   'C',   2,  0, '"00"' } )
aAdd( aTipo4, { 'INDICADOR DE IMPRESSAO BANCARIA      ', 030, 030,   'C',   1,  0, '"S"' } )
aAdd( aTipo4, { 'DATA INICIO PERIODO AQUISITIVO       ', 031, 038,   'C',   8,  0, '"00000000"' } )
aAdd( aTipo4, { 'DATA FINAL  PERIODO AQUISITIVO       ', 039, 046,   'C',   8,  0, '"00000000"' } )
aAdd( aTipo4, { 'DATA INICIO GOZO DE FERIAS           ', 047, 054,   'C',   8,  0, '"00000000"' } )
aAdd( aTipo4, { 'DATA FINAL GOZO DE FERIAS            ', 055, 062,   'C',   8,  0, '"00000000"' } )
aAdd( aTipo4, { 'VALOR BASE INSS                      ', 063, 074,   'N',  12,  2, 'If(cTipoRot<>"6",nAteLim,Space(12)) ' } )
aAdd( aTipo4, { 'VALOR BASE INSS 13                   ', 075, 086,   'N',  12,  2, 'If(cTipoRot=="6",nAteLim,Space(12) )' } )
aAdd( aTipo4, { 'VALOR BASE IRRF SALARIO              ', 087, 098,   'N',  12,  2, 'If(cTipoRot<>"6",nBaseIr,Space(12) )' } )
aAdd( aTipo4, { 'VALOR BASE IRRF 13                   ', 099, 110,   'N',  12,  2, 'If(cTipoRot=="6",nBaseIr,Space(12) )' } )
aAdd( aTipo4, { 'VALOR BASE IRRF FERIAS               ', 111, 122,   'N',  12,  2, '  ' } )
aAdd( aTipo4, { 'VALOR BASE IRRF PPR                  ', 123, 134,   'N',  12,  2, '  ' } )
aAdd( aTipo4, { 'VALOR BASE FGTS                      ', 135, 146,   'N',  12,  2, 'nBaseFgts' } )
aAdd( aTipo4, { 'VALOR DO FGTS                        ', 147, 158,   'N',  12,  2, 'nFgts' } )
aAdd( aTipo4, { 'FILLER                               ', 159, 236,   'C',  78,  0, '  ' } )
aAdd( aTipo4, { 'RESERVADO                            ', 237, 245,   'C',   9,  0, '  ' } )
aAdd( aTipo4, { 'SEQUENCIAL DO ARQUIVO                ', 246, 250,   'N',   5,  0, 'nSeq_' } )
                         
// Registro Trailler do Comprovante TIPO 5
aTipo5 := {}
//              Descricao                                Ini  Fim   Tipo  Tam Dec  Conteudo
aAdd( aTipo5, { 'TIPO DE REGISTRO                     ', 001, 001,   'N',   1,  0, '"5"' } )
aAdd( aTipo5, { 'TOTAL DE LANวAMENTOS DO COMPROVANTE  ', 002, 006,   'N',   5,  0, 'nQtdComp' } )
aAdd( aTipo5, { 'FILLER                               ', 007, 236,   'C', 230,  0, '  ' } )
aAdd( aTipo5, { 'RESERVADO                            ', 237, 245,   'C',   9,  0, '  ' } )
aAdd( aTipo5, { 'SEQUENCIAL DO ARQUIVO                ', 246, 250,   'N',   5,  0, 'nSeq_' } )

// Registro Trailler da Empresa - TIPO 9
aTipo9 := {}
//              Descricao                                Ini  Fim   Tipo  Tam Dec  Conteudo
aAdd( aTipo9, { 'TIPO DE REGISTRO                     ', 001, 001,   'N',   1,  0, '"9"' } )
aAdd( aTipo9, { 'TOTAL DE REGISTROS DO LOTE           ', 002, 006,   'N',   5,  0, 'nTotRLote' } )
aAdd( aTipo9, { 'FILLER                               ', 007, 236,   'C', 230,  0, '  ' } )
aAdd( aTipo9, { 'RESERVADO                            ', 237, 245,   'C',   9,  0, '  ' } )
aAdd( aTipo9, { 'SEQUENCIAL DO ARQUIVO                ', 246, 250,   'N',   5,  0, 'nSeq_' } )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria o arquivo texto                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//Verifica se Arquivo Existe
If File( cNomeArq )
	If ( nAviso := Aviso( 'AVISO', 'Deseja substituir o ' + AllTrim( cNomeArq ) + ' existente ?', {'Sim', 'Nใo'} ) ) == 1
		//Deleta Arquivo
		If fErase( cNomeArq ) <> 0
			MsgAlert( 'Ocorreram problemas na tentativa de dele็ใo do arquivo '+AllTrim( cNomeArq )+'.' )
			Return NIL
		EndIf
	Else
		Return NIL
	EndIf
EndIf

//Verifica se Nome de Arquivo em Branco
If Empty( cNomeArq )
	MsgAlert( 'Nome do Arquivo nos Parametros em Branco.', 'Aten็ใo!' )
	Return NIL
Else
	//Cria Arquivo
	nHdl := fCreate( cNomeArq )
	nSeq_ := 0
	lContinua := .T.
	
	//Verifica Criacao do Arquivo
	If nHdl == -1
		MsgAlert( 'O arquivo '+AllTrim( cNomeArq )+' nใo pode ser criado! Verifique os parametros.', 'Aten็ใo!' )
		Return NIL
	EndIf
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Selecionando a Ordem de impressao escolhida no parametro.    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea( "SRA" )
dbSetOrder( 1 )
dbGoTop()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Selecionando o Primeiro Registro e montando Filtro.          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSeek( cFilDe + cMatDe, .T. )
cInicio := "SRA->RA_FILIAL + SRA->RA_MAT"
cFim    := cFilAte + cMatAte

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Carrega Regua Processamento                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cAliasTMP := "QNRO"
BeginSql alias cAliasTMP
	SELECT COUNT(*) as NROREG
	FROM %table:SRA% SRA
	WHERE      SRA.RA_FILIAL BETWEEN %exp:cFilDe%   AND %exp:cFilAte% 
		   AND SRA.RA_MAT    BETWEEN %exp:cMatDe%   AND %exp:cMatAte%
		   AND SRA.RA_CC     BETWEEN %exp:cCCDe%    AND %exp:cCCAte% 
		   AND SRA.RA_DEPTO  BETWEEN %exp:cDeptoDe% AND %exp:cDeptoAte% 
		   AND SRA.%notDel%
EndSql                
	
nRegProc := (cAliasTMP)->(NROREG)

( cAliasTMP )->( dbCloseArea() )	

ProcRegua(nRegProc)	// Total de elementos da regua

dbSelectArea("SRA")

TOTVENC:= TOTDESC:= FLAG:= CHAVE := 0

Desc_Fil := Desc_End := DESC_CC:= DESC_FUNC:= ""
DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space( 01 )
cFilialAnt := space(FWGETTAMFILIAL)
cFuncaoAnt := "    "
cCcAnt     := Space( 9 )
Vez        := 0
OrdemZ     := 0

GeraBDN0()

dbSelectArea( "SRA" )
While SRA->(!EOF()) .AND. &cInicio <= cFim
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Movimenta Regua Processamento                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	  IncProc() // Anda a regua
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Consiste Parametrizacao do Intervalo de Impressao            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	IF	( SRA->RA_NOME < cNomDe )  .OR. ( SRA->Ra_NOME > cNomAte )    .OR. ;
		( SRA->RA_MAT < cMatDe )   .OR. ( SRA->Ra_MAT > cMatAte )     .OR. ;
		( SRA->RA_CC < cCcDe )     .OR. ( SRA->RA_CC > cCcAte )      .Or. ;
		( SRA->RA_DEPTO < cDeptoDe ) .OR. ( SRA->RA_DEPTO > cDeptoAte )
		SRA->( dbSkip( 1 ) )
		Loop
	EndIf
	
	// Se o funcionario nao tiver conta no Bradesco nao envia
	If Subs( SRA->RA_BCDEPSAL, 1, 3 ) <> '237'
		SRA->( dbSkip() )
		Loop
	EndIf
	
	aLanca:={}         // Zera Lancamentos
	aProve:={}         // Zera Lancamentos
	aDesco:={}         // Zera Lancamentos
	aBases:={}         // Zera Lancamentos
	//aVerbHrs:={}
	nAteLim := nBaseFgts := nFgts := nBaseIr := nBaseIrFe := 0.00
	
	Ordem_rel := 1     // Ordem dos Recibos
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica Data Demissao         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cSitFunc := SRA->RA_SITFOLH
	dDtPesqAf:= CTOD("01/" + Left(cMesAnoRef,2) + "/" + Right(cMesAnoRef,4),"DDMMYY")
	If cSitFunc == "D" .And. (!Empty(SRA->RA_DEMISSA) .And. MesAno(SRA->RA_DEMISSA) > MesAno(dDtPesqAf))
		cSitFunc := " "
	Endif	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Consiste situacao e categoria dos funcionarios			     |
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If !( cSitFunc $ cSituacao ) .OR.  ! ( SRA->RA_CATFUNC $ cCategoria )
			SRA->(dbSkip())
			Loop
		Endif
		If cSitFunc $ "D" .And. Mesano(SRA->RA_DEMISSA) # Mesano(dDataRef)
			SRA->(dbSkip())
			Loop
		Endif
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Consiste controle de acessos e filiais validas				 |
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	    If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
			SRA->(dbSkip())
	       Loop
    	EndIf
	
	If SRA->RA_CODFUNC #cFuncaoAnt           // Descricao da Funcao
		DescFun( Sra->Ra_Codfunc, Sra->Ra_Filial )
		cFuncaoAnt:= Sra->Ra_CodFunc
	EndIf
	
	If SRA->RA_CC #cCcAnt                   // Centro de Custo
		DescCC( Sra->Ra_Cc, Sra->Ra_Filial )
		cCcAnt:=SRA->RA_CC
	EndIf
	
	//-Busca o Salario Base do Funcionario
	nSalario := fBuscaSal(dDataRef,,,.F.)
	dbSelectArea( "SRA" )
	If nSalario == 0
		nSalario := SRA->RA_SALARIO
	EndIf

	If SRA->RA_Filial #cFilialAnt
		If ! Fp_CodFol( @aCodFol, Sra->Ra_Filial ) .OR. ! fInfo( @aInfo, Sra->Ra_Filial )
			Exit
		EndIf
		Desc_Fil := aInfo[3]
		Desc_End := aInfo[4]                // Dados da Filial
		Desc_CGC := aInfo[8]
		
		DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space( 01 )
		
		// MENSAGENS
		If !Empty(MENSAG1)        
			nPosMsg1		:= fPosTab("S036",Alltrim(MENSAG1), "==", 4)
			If nPosMsg1 > 0 
				DESC_MSG1	:= fTabela("S036",nPosMsg1,5)
			EndIf
		Endif   
		
		If !Empty(MENSAG2)        
			nPosMsg2		:= fPosTab("S036",Alltrim(MENSAG2), "==", 4)
			If nPosMsg2 > 0 
				DESC_MSG2	:= fTabela("S036",nPosMsg2,5)
			EndIf  
		EndIf
			
		If !Empty(MENSAG3)        
			nPosMsg3		:= fPosTab("S036",Alltrim(MENSAG3), "==", 4)
			If nPosMsg3 > 0 
				DESC_MSG3	:= fTabela("S036",nPosMsg3,5)
			EndIf
		EndIf
		
		dbSelectArea( "SRA" )
				
		cFilialAnt := SRA->RA_FILIAL
		
	EndIf
	
	Totvenc := Totdesc := 0
	
	//Retorna as verbas do funcionario, de acordo com os periodos selecionados
	aVerbasFunc	:= RetornaVerbasFunc(	SRA->RA_FILIAL					,; // Filial do funcionario corrente
										SRA->RA_MAT	  					,; // Matricula do funcionario corrente
										NIL								,; // 
										cRoteiro	  					,; // Roteiro selecionado na pergunte
										NIL			  					,; // Array com as verbas que deverใo ser listadas. Se NIL retorna todas as verbas.
										aPerAberto	  					,; // Array com os Periodos e Numero de pagamento abertos
										aPerFechado	 	 				 ) // Array com os Periodos e Numero de pagamento fechados
	
	If cRoteiro <> "EXT"
		For nReg := 1 to Len(aVerbasFunc)
			If (Len(aPerAberto) > 0 .AND. !Eval(cAcessaSRC)) .OR. (Len(aPerFechado) > 0 .AND. !Eval(cAcessaSRD)) .Or.;
			   ( aVerbasFunc[nReg,7] <= 0 )
				dbSkip()
				Loop
			EndIf
			
			If cPaisLoc $ "ANG*PER" .AND. cBaseAux = "N"
				if PosSrv( aVerbasFunc[nReg,3] , SRA->RA_FILIAL , "RV_TIPOCOD" ) $ "34"
					dbSkip()
		   			Loop
				Endif
			Endif
			
			If PosSrv( aVerbasFunc[nReg,3] , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
				If cPaisLoc == "PAR" .and. Eval(cNroHoras) = 30
					LocGHabRea(Ctod("01/"+SubStr(DTOC(dDataRef),4)), Ctod(StrZero(F_ULTDIA(dDataRef),2)+"/"+Strzero(Month(dDataRef),2)+"/"+right(str(Year(dDataRef)),2),"ddmmyy"),@nHoras)
				Else
					nHoras := aVerbasFunc[nReg,6]	//-Eval(cNroHoras)
				Endif
				fSomaPdRec("P",aVerbasFunc[nReg,3],nHoras,aVerbasFunc[nReg,7])
				TOTVENC += aVerbasFunc[nReg,7]
			
				If cPaisLoc == "BOL"       //soma Horas Extras para localizacao Bolivia
					If PosSrv(aVerbasFunc[nReg,3], SRA->RA_FILIAL, "RV_HE") == "S"
						nHraExtra:= nHraExtra + aVerbasFunc[nReg,6]
					Endif                                          
					//Soma a verba de Horas Trabalhadas no Domingo id 0779
					
					If (aVerbasFunc[nReg,3] == aCodFol[779,1])  
						nPagoDom:= nPagoDom + aVerbasFunc[nReg,6]
					Endif                                        
				Endif 
				
			Elseif SRV->RV_TIPOCOD == "2"
				fSomaPdRec("D",aVerbasFunc[nReg,3],aVerbasFunc[nReg,6],aVerbasFunc[nReg,7])
				TOTDESC += aVerbasFunc[nReg,7]
			
			Elseif SRV->RV_TIPOCOD $ "3/4"
				//No Paraguai imprimir somente o valor liquido
				If cPaisLoc <> "PAR" .Or. (aVerbasFunc[nReg,3] == aCodFol[047,1])
					fSomaPdRec("B",aVerbasFunc[nReg,3],aVerbasFunc[nReg,6],aVerbasFunc[nReg,7])
				Endif
			Endif
			
			If (aVerbasFunc[nReg,3] $ aCodFol[10,1]+'*'+aCodFol[15,1]+'*'+aCodFol[27,1])
				nBaseIr += aVerbasFunc[nReg,7]
			
			ElseIf (aVerbasFunc[nReg,3] $ aCodFol[13,1]+'*'+aCodFol[19,1])
				nAteLim += aVerbasFunc[nReg,7]
            
            // BASE FGTS SAL, 13.SAL E DIF DISSIDIO E DIF DISSIDIO 13
			Elseif aVerbasFunc[nReg,3] $ aCodFol[108,1]+'*'+aCodFol[17,1]+'*'+ aCodFol[337,1]+'*'+aCodFol[398,1]
				nBaseFgts += aVerbasFunc[nReg,7]
            
            // VALOR FGTS SAL, 13.SAL E DIF DISSIDIO E DIF.DISSIDIO 13
			Elseif aVerbasFunc[nReg,3] $ aCodFol[109,1]+'*'+aCodFol[18,1]+'*'+aCodFol[339,1]+'*'+aCodFol[400,1]
				nFgts += aVerbasFunc[nReg,7]
			
			Elseif (aVerbasFunc[nReg,3] == aCodFol[16,1])
				nBaseIrFe += aVerbasFunc[nReg,7]
			Endif
		Next nReg

	Elseif cRoteiro == "EXT"
		dbSelectArea("SR1")
		dbSetOrder(1)
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
			While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT ==	SR1->R1_FILIAL + SR1->R1_MAT
				If Semana # "99"			
					If SR1->R1_SEMANA # Semana
						dbSkip()
						Loop
					Endif
				Endif					
			    If !Eval(cAcessaSR1)
			       dbSkip()
			       Loop
			    EndIf
				If PosSrv( SR1->R1_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					fSomaPdRec("P",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
					TOTVENC = TOTVENC + SR1->R1_VALOR
				Elseif SRV->RV_TIPOCOD == "2"
					fSomaPdRec("D",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
					TOTDESC = TOTDESC + SR1->R1_VALOR
				Elseif SRV->RV_TIPOCOD $ "3/4"
					fSomaPdRec("B",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
				Endif
				dbskip()
			Enddo
		Endif
	Endif
	
	dbSelectArea( "SRA" )
	
	If TOTVENC = 0 .AND. TOTDESC = 0
		dbSkip()
		Loop
	EndIf
	
	GeraBDN1()
	GeraBDN2()
	GeraBDN3()
	GeraBDN4()
	GeraBDN5()
	
	dbSelectArea("SRA")
	SRA->( dbSkip() )
	TOTDESC := TOTVENC := 0

EndDo

GeraBDN9()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Termino do relatorio                                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea( "SRA" )
SET FILTER TO
RetIndex( "SRA" )

If !( Type( "cArqNtx" ) == "U" )
	fErase( cArqNtx + OrdBagExt() )
EndIf

Set Device To Screen

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณ  GravaReg    ณ Autor ณ Jose Carlos       ณ Data ณ 15.09.99 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Grava Registro                                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ GravaReg                                                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ GeraRec                                                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณProgramador ณ Data   ณ BOPS ณ  Motivo da Alteracao                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ            ณ        ณ      ณ                                          ณฑฑ
ฑฑณ            ณ        ณ      ณ                                          ณฑฑ
ฑฑณ            ณ        ณ      ณ                                          ณฑฑ
ฑฑณ            ณ        ณ      ณ                                          ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ/*/
Static Function GravaReg

If fWrite( nHdl, cReg, Len( cReg ) ) <> Len( cReg )
	If !MsgYesNo( 'Ocorreu um erro na gravao do arquivo '+AllTrim( cNomeArq )+'.   Continua?', 'Ateno!' )
		lContinua := .F.
		Return NIL
	EndIf
EndIf

Return NIL



//Fim do Programa


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ GeraBDN0 บAutor  ณ Ernani Forastieri  บ Data ณ  25/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao de Registro Tipo 0 para hollerith eletronico BDN   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraBDN0()
cNum := GetMV( 'ES_SEQBDN',, 'NAOEXISTE' )

If cNum == 'NAOEXISTE'
	RecLock("SX6",.t.)
	SX6->X6_VAR 	:= 'ES_SEQBDN'
	SX6->X6_TIPO 	:= 'C'
	SX6->X6_DESCRIC := 'Ultimo Sequencial do Arquivo BDN referente'
	SX6->X6_DESC1 	:= 'ao recibo de pagamento eletronico.'
	SX6->X6_CONTEUD := '000000000'
	SX6->X6_PROPRI 	:= 'U'
	SX6->(MsUnLock())
	cNum := '000000000'
EndIf
	

If lEhIncBDN
	cNum  := Soma1( cNum )
Else

	cNum  := MV_PAR18
EndIf
nSeq_++

FWrite( nHdl, GeraLinhas( aTipo0 ) )
nTotRLote++

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ GeraBDN1 บAutor  ณ Ernani Forastieri  บ Data ณ  25/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao de Registro Tipo 1 para hollerith eletronico BDN   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraBDN1()
Local   cAux       := ''
Private cCtaFunc   := ''
Private cDgCtaFunc := ''
Private cNumCP     := ''

cAux       := AllTrim( SRA->RA_CTDEPSA )
cCtaFunc   := SubStr( cAux, 1, Len( cAux  ) - 1 )
cDgCtaFunc := SubStr( cAux, Len( cAux ), 1 )
cNumCP     := StrZero( Val( SRA->RA_NUMCP ), 6 ) + IIF(!Empty(SRA->RA_UFCP), "-" + SRA->RA_UFCP, "" )

nSeq_++
FWrite( nHdl, GeraLinhas( aTipo1 ) )
nTotRLote++

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ GeraBDN2 บAutor  ณ Ernani Forastieri  บ Data ณ  25/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao de Registro Tipo 2 para hollerith eletronico BDN   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ    		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraBDN2()
Local   nI       := 1
Local   aVerbas  := {}
Local   nPos     := 0
Local   nLiquido := 0
Local   lGravou  := .F.
Local   nJ       := 0

Private cCodLan  := ''
Private cDescLan := ''
Private nValLan  := 0
Private cIdLan   := ''

nQtdComp         := 0

For nI := 1 To 2
	aVerbas := IIf( nI == 1, aClone( aProve ), aClone( aDesco ) )
	nTot    := 0
	
	For nJ := 1 To Len( aVerbas )
		nSeq_++
		cCodLan    := SubStr( aVerbas[nJ][1], 1, 3 )
		cDescLan   := SubStr( aVerbas[nJ][1], 5 )
		nValLan    := aVerbas[nJ][3]
		cIdLan     := IIf( nI == 1, 1, 3 )
		
		lGravou := .T.
		FWrite( nHdl, GeraLinhas( aTipo2 ) )
		nQtdComp++
		nTotRLote++
	Next
	
	// Total
	If  nI == 1
		cCodLan    := 'TCR'
		cDescLan   := 'TOTAL CREDITOS'
		cIdLan     := 2
		nValLan    := TOTVENC
	Else
		cCodLan    := 'TDB'
		cDescLan   := 'TOTAL DEBITOS'
		cIdLan     := 4
		nValLan    := TOTDESC
	EndIf
	
	nSeq_++
	FWrite( nHdl, GeraLinhas( aTipo2 ) )
	nQtdComp++
	nTotRLote++
	
Next

If lGravou
	
	cCodLan    := 'LIQ'
	cDescLan   := 'TOTAL LIQUIDO'
	nValLan    := TOTVENC-TOTDESC
	If nValLan < 0
		cIdLan     := 6
		cDescLan   := 'TOTAL LIQUIDO NEGAT.'
		nValLan := nValLan*-1
	Else
		cIdLan     := 5
		cDescLan   := 'TOTAL LIQUIDO'
	EndIf
	
	If ( nPos := aScan( aBases, { |x| SubStr( x[1], 1, 3 ) == cCodLan } ) ) > 0
		nValLan := aBases[nPos][3]
	EndIf
	
	nSeq_++
	FWrite( nHdl, GeraLinhas( aTipo2 ) )
	nQtdComp++
	nTotRLote++
EndIf

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ GeraBDN3 บAutor  ณ Ernani Forastieri  บ Data ณ  25/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao de Registro Tipo 3 para hollerith eletronico BDN   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraBDN3()
Local   nI       := 1
Local   cCpo     := 'Desc_Msg'
Local   nMesAniv := 0
Local   cMsgVrb  := ''
Private cMsg     := ''

nMesAniv = IIf( Month( dDataRef ) + 1 > 12, 01, Month( dDataRef ) )
IF nMesAniv = Month( SRA->RA_NASC )
	cMsg := "F E L I Z   A N I V E R S A R I O  ! !"
	nSeq_++
	FWrite( nHdl, GeraLinhas( aTipo3 ) )
	nQtdComp++
	nTotRLote++
EndIf

For nI := 1 To 3
	cMsg := AllTrim( &( cCpo+Str( nI, 1 ) ) )
	
	If !Empty( cMsg )
		nSeq_++
		FWrite( nHdl, GeraLinhas( aTipo3 ) )
		nQtdComp++
		nTotRLote++
	EndIf
	
Next


// Verbas de Horas
/*
COD T   QTDE  COD T   QTDE  COD T   QTDE
999 H 999,99/ 999 H 999,99/ 999 H 999,99


If nQtdVerb > 0
	// Mensagem 5
	If     nQtdVerb == 1
		cMsg := 'COD T   QTDE                            '
	ElseIf nQtdVerb == 2
		cMsg := 'COD T   QTDE  COD T   QTDE              '
	Else
		cMsg := 'COD T   QTDE  COD T   QTDE  COD T   QTDE'
	EndIf
	
	nSeq_++
	FWrite( nHdl, GeraLinhas( aTipo3 ) )
	nQtdComp++
	nTotRLote++
	                       	
	cMsgVrb := ''  
	//aEval( aVerbHrs, {|x,y|	cMsgVrb += IIf( y == 1, '', '/ ' ) + x[1] + ' H ' + Transform( x[2], '@E 999.99' ) } )

	// Mensagem 6
	cMsg := PADR( SubStr( cMsgVrb, 1, 40 ), 40 )
	If !Empty( cMsg )
		nSeq_++
		FWrite( nHdl, GeraLinhas( aTipo3 ) )
		nQtdComp++
		nTotRLote++
	EndIf
	
	// Mensagem 7
	cMsg := PADR( SubStr( cMsgVrb, 43, 40 ), 40 )
	If !Empty( cMsg )
		nSeq_++
		FWrite( nHdl, GeraLinhas( aTipo3 ) )
		nQtdComp++
		nTotRLote++
	EndIf
	
EndIf
*/
Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ GeraBDN4 บAutor  ณ Ernani Forastieri  บ Data ณ  25/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao de Registro Tipo 4 para hollerith eletronico BDN   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿'฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraBDN4()
nSeq_++
FWrite( nHdl, GeraLinhas( aTipo4 ) )
nQtdComp++
nTotRLote++
Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ GeraBDN5 บAutor  ณ Ernani Forastieri  บ Data ณ  25/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao de Registro Tipo 5 para hollerith eletronico BDN   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraBDN5()
nSeq_++
FWrite( nHdl, GeraLinhas( aTipo5 ) )
nTotRLote++
Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ GeraBDN9 บAutor  ณ Ernani Forastieri  บ Data ณ  25/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao de Registro Tipo 9 para hollerith eletronico BDN   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraBDN9()
nSeq_++
nTotRLote++
FWrite( nHdl, GeraLinhas( aTipo9 ) )

If lEhIncBDN
	PutMV( 'ES_SEQBDN', cNum  )
EndIf


Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณGeralinhasบAutor  ณ Ernani Forastieri  บ Data ณ  25/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao de linhas de texto                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraLinhas( aTipo )
Local cLinha     := ''
Local nTamMaxLin := 250
Local nI         := 0

For nI := 1 To Len( aTipo )
	bAux      := &( '{ || ' + aTipo[nI][7] + ' } ' )
	
	cTipo     := aTipo[nI][4]
	nTamanho  := aTipo[nI][5]
	nDecimal  := aTipo[nI][6]
	
	uConteudo := EVal( bAux )
	uConteudo := IIf( ValType( uConteudo ) == 'U' , '', EverChar( uConteudo ) )
	
	If     cTipo == 'C'
		uConteudo := PADR( SubStr( AllTrim( uConteudo ), 1, nTamanho ), nTamanho )
		
	ElseIf cTipo == 'N'
		uConteudo := StrZero( Val( uConteudo ) * (10^nDecimal) , nTamanho )
		
	EndIf
	
	cLinha += uConteudo
	
Next

cLinha += Replicate( ' ', nTamMaxLin - Len( cLinha ) ) + cQuebraLin

Return cLinha                                           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ EVERCHAR บAutor  ณ Ernani Forastieri  บ Data ณ  13/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao auxiliar para transformar um campo de qualquer tipo บฑฑ
ฑฑบ          ณ em caracter                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EverChar( uCpoConver )

Local cRet  := NIL
Local cTipo := ''

cTipo := ValType( uCpoConver )

If     cTipo == 'C'                    // Tipo Caracter
	cRet := uCpoConver
	
ElseIf cTipo == 'N'                    // Tipo Numerico
	cRet := AllTrim( Str( uCpoConver ) )
	
ElseIf cTipo == 'L'                    // Tipo Logico
	cRet := IIf( uCpoConver, '.T.', '.F.' )
	
ElseIf cTipo == 'D'                    // Tipo Data
	cRet := DToC( uCpoConver )
	
ElseIf cTipo == 'M'                    // Tipo Memo
	cRet := 'MEMO'
	
ElseIf cTipo == 'A'                    // Tipo Array
	cRet := 'ARRAY[' + AllTrim( Str( Len( uCpoConver ) ) ) + ']'
	
ElseIf cTipo == 'U'                    // Indefinido
	cRet := 'NIL'
	
EndIf

Return(cRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณ VerPerg      ณ Autor ณ                   ณ Data ณ 15.06.98 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Verifica as perguntas, Incluindo-as caso no existam       ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function VerPerg()

LOCAL aArea    	:= GetArea()
LOCAL aAreaDic 	:= SX1->( GetArea() )
LOCAL aEstrut  	:= {}
LOCAL aStruDic 	:= SX1->( dbStruct() )
LOCAL aDados	:= {}
LOCAL nXa       := 0
LOCAL nXb       := 0
LOCAL nXc		:= 0
LOCAL nTam1    	:= Len( SX1->X1_GRUPO )
LOCAL nTam2    	:= Len( SX1->X1_ORDEM )
LOCAL lAtuHelp 	:= .F.            
LOCAL aHelp		:= {}	

aEstrut := { 'X1_GRUPO'  , 'X1_ORDEM'  , 'X1_PERGUNT', 'X1_PERSPA' , 'X1_PERENG' , 'X1_VARIAVL', 'X1_TIPO'   , ;
             'X1_TAMANHO', 'X1_DECIMAL', 'X1_PRESEL' , 'X1_GSC'    , 'X1_VALID'  , 'X1_VAR01'  , 'X1_DEF01'  , ;
             'X1_DEFSPA1', 'X1_DEFENG1', 'X1_CNT01'  , 'X1_VAR02'  , 'X1_DEF02'  , 'X1_DEFSPA2', 'X1_DEFENG2', ;
             'X1_CNT02'  , 'X1_VAR03'  , 'X1_DEF03'  , 'X1_DEFSPA3', 'X1_DEFENG3', 'X1_CNT03'  , 'X1_VAR04'  , ;
             'X1_DEF04'  , 'X1_DEFSPA4', 'X1_DEFENG4', 'X1_CNT04'  , 'X1_VAR05'  , 'X1_DEF05'  , 'X1_DEFSPA5', ;
             'X1_DEFENG5', 'X1_CNT05'  , 'X1_F3'     , 'X1_PYME'   , 'X1_GRPSXG' , 'X1_HELP'   , 'X1_PICTURE', ;
             'X1_IDFIL'   }

 
aAdd( aDados, {cPerg, "01", "Processo ?"			 , "ฟProceso ?"			 , "Process ?"			 , "mv_ch1", "C", 5						, 0, 0, "G", "Gpr040Valid(mv_par01)"									, "mv_par01", ""		, ""		, ""		, "", "", ""			, ""			, ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "RCJ"		, "", ""	, ""} )
aAdd( aDados, {cPerg, "02", "Roteiro ?"				 , "ฟProcedimiento ?"	 , "Script ?"			 , "mv_ch2", "C", 3						, 0, 0, "G", "f030Roteiro() .and. Gpr040Roteiro()"						, "mv_par02", ""		, ""		, ""		, "", "", ""			, ""			, ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""		, "", ""	, ""} )
aAdd( aDados, {cPerg, "03", "Periodo ?"				 , "ฟPeriodo ?"			 , "Period ?"			 , "mv_ch3", "C", 6						, 0, 0, "G", "Gpr040Valid(mv_par01 + mv_par02 + mv_par03)"				, "mv_par03", ""		, ""		, ""		, "", "", ""			, ""			, ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "RCH"		, "", ""	, ""} )
aAdd( aDados, {cPerg, "04", "Numero de Pagamento ?"	 , "ฟNumero de pago ?"	 , "Payment Number ?"	 , "mv_ch4", "C", 2						, 0, 0, "G", "Gpr040Valid(mv_par01 + mv_par02 + mv_par03 + mv_par04)"	, "mv_par04", ""		, ""		, ""		, "", "", ""			, ""			, ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""		, "", ""	, ""} )
aAdd( aDados, {cPerg, "05", "Filial De ?"			 , "ฟDe Filial?"		 , "From Branch ?"		 , "mv_ch5", "C", TamSx3("RA_FILIAL")[1], 0, 0, "G", ""															, "mv_par05", ""		, ""		, ""		, "", "", ""			, ""			, ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "XM0"		, "", "033"	, ""} )
aAdd( aDados, {cPerg, "06", "Filial At้ ?"			 , "ฟA Filial?"			 , "To Branch ?"		 , "mv_ch6", "C", TamSx3("RA_FILIAL")[1], 0, 0, "G", "naovazio"													, "mv_par06", ""		, ""		, ""		, "", "", ""			, ""			, ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "XM0"		, "", "033"	, ""} )
aAdd( aDados, {cPerg, "07", "Centro de Custo De ?"	 , "ฟDe Centro de Costo?", "From Cost Center ?"	 , "mv_ch7", "C", TamSx3("CTT_CUSTO")[1], 0, 0, "G", ""															, "mv_par07", ""		, ""		, ""		, "", "", ""			, ""			, ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "CTT"		, "", "004"	, ""} )
aAdd( aDados, {cPerg, "08", "Centro de Custo At้ ?"	 , "ฟA  Centro de Costo?", "To Cost Center ?"	 , "mv_ch8", "C", TamSx3("CTT_CUSTO")[1], 0, 0, "G", "naovazio"													, "mv_par08", ""		, ""		, ""		, "", "", ""			, ""			, ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "CTT"		, "", "004"	, ""} )
aAdd( aDados, {cPerg, "09", "Matricula De ?"		 , "ฟDe Matricula?"		 , "From Registration ?" , "mv_ch9", "C", 6						, 0, 0, "G", ""															, "mv_par09", ""		, ""		, ""		, "", "", ""			, ""			, ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SRA"		, "", ""	, ""} )
aAdd( aDados, {cPerg, "10", "Matricula At้ ?"		 , "ฟA  Matricula?"		 , "To Registration ?"	 , "mv_cha", "C", 6						, 0, 0, "G", "naovazio"													, "mv_par10", ""		, ""		, ""		, "", "", ""			, ""			, ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SRA"		, "", ""	, ""} )
aAdd( aDados, {cPerg, "11", "Nome De ?"				 , "ฟDe Nombre?"		 , "From Name ?"		 , "mv_chb", "C", 30					, 0, 0, "G", ""															, "mv_par11", ""		, ""		, ""		, "", "", ""			, ""			, ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""		, "", ""	, ""} )
aAdd( aDados, {cPerg, "12", "Nome At้ ?"			 , "ฟA  Nombre?"		 , "To Name ?"			 , "mv_chc", "C", 30					, 0, 0, "G", "naovazio"													, "mv_par12", ""		, ""		, ""		, "", "", ""			, ""			, ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""		, "", ""	, ""} )
aAdd( aDados, {cPerg, "13", "Situa็๖es a Imp. ?"	 , "ฟSituaciones a Imp.?", "Situations to Print?", "mv_chd", "C", 5						, 0, 0, "G", "fSituacao"												, "mv_par13", ""		, ""		, ""		, "", "", ""			, ""			, ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""		, "", ""	, ""} )
aAdd( aDados, {cPerg, "14", "Categorias a Imp. ?"	 , "ฟCategorias a Imp.?" , "Categories to Print?", "mv_che", "C", 15					, 0, 0, "G", "fCategoria"												, "mv_par14", ""		, ""		, ""		, "", "", ""			, ""			, ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""		, "", ""	, ""} )
aAdd( aDados, {cPerg, "15", "Tipo de Remessa ?"		 , "Tipo de Remessa ?"	 , "Tipo de Remessa ?"	 , "mv_chf", "N", 1						, 0, 0, "C", ""															, "mv_par15", "Teste"	, "Teste"	, "Teste"	, "", "", "Producao"	, "Producao"	, "Producao"	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""		, "", ""	, ""} )
aAdd( aDados, {cPerg, "16", "Arquivo de Saida ?"	 , "Arquivo de Saida ?"	 , "Arquivo de Saida?"	 , "mv_chg", "C", 60					, 0, 0, "G", ""															, "mv_par16", ""		, ""		, ""		, "", "", ""			, ""			, ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""		, "", ""	, ""} )
aAdd( aDados, {cPerg, "17", "Operacao p/ BDN?"		 , "ฟOperacion p/ BDN?"	 , "BDN Operation ?"	 , "mv_chh", "N", 1						, 0, 0, "C", ""															, "mv_par17", "Inclusao", "Inclusao", "Inclusao", "", "", "Substituicao", "Substituicao", "Substituicao", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""		, "", ""	, ""} )
aAdd( aDados, {cPerg, "18", "Num.Lote Orig.p/Subs.?" , "Num.Lote Orig.p/Sub?", "Num.Lote Orig.p/Sub?", "mv_chi", "C", 9						, 0, 0, "G", ""															, "mv_par18", ""		, ""		, ""		, "", "", ""			, ""			, ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""		, "", ""	, ""} )
aAdd( aDados, {cPerg, "19", "Cod. Empresa no BDN ?"	 , "Cod. Empresa no BDN?", "Cod. Empresa no BDN?", "mv_chj", "C", 9						, 0, 0, "G", ""															, "mv_par19", ""		, ""		, ""		, "", "", ""			, ""			, ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""		, "", ""	, ""} )
aAdd( aDados, {cPerg, "20", "Mensagem 1 ?"			 , "ฟMensaje 1?"		 , "Message 1 ?"		 , "mv_chk", "C", 1						, 0, 0, "G", ""															, "mv_par20", ""		, ""		, ""		, "", "", ""			, ""			, ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "S036"	, "", ""	, ""} )
aAdd( aDados, {cPerg, "21", "Mensagem 2 ?"			 , "ฟMensaje 2?"		 , "Message 2 ?"		 , "mv_chl", "C", 1						, 0, 0, "G", ""															, "mv_par21", ""		, ""		, ""		, "", "", ""			, ""			, ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "S036"	, "", ""	, ""} )
aAdd( aDados, {cPerg, "22", "Mensagem 3 ?"			 , "ฟMensaje 3?"		 , "Message 3 ?"		 , "mv_chm", "C", 1						, 0, 0, "G", ""															, "mv_par22", ""		, ""		, ""		, "", "", ""			, ""			, ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "S036"	, "", ""	, ""} )
aAdd( aDados, {cPerg, "23", "Depto De ?"			 , "Depto De ?"			 , "Depto De ?"			 , "mv_chn", "C", TamSx3("RA_DEPTO")[1]	, 0, 0, "G", ""															, "mv_par23", ""		, ""		, ""		, "", "", ""			, ""			, ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SQB"		, "", "025"	, ""} )
aAdd( aDados, {cPerg, "24", "Depto Ate ?"			 , "Depto Ate ?"		 , "Depto Ate ?"		 , "mv_cho", "C", TamSx3("RA_DEPTO")[1]	, 0, 0, "G", "naovazio"													, "mv_par24", ""		, ""		, ""		, "", "", ""			, ""			, ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SQB"		, "", "025"	, ""} )
aAdd( aDados, {cPerg, "25", "CNPJ na Empresa no BDN?", "CNPJ na Empresa no BDN ?", "CNPJ na Empresa no BDN ?", "mv_chp", "C", 14			, 0, 0, "G", "naovazio"													, "mv_par25", ""		, ""		, ""		, "", "", ""			, ""			, ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""		, "", ""	, ""} )

// Atualizando dicionแrio
//
dbSelectArea( 'SX1' )
SX1->( dbSetOrder( 1 ) )

For nXa := 1 To Len( aDados )
	If !SX1->( dbSeek( PadR( aDados[nXa][1], nTam1 ) + PadR( aDados[nXa][2], nTam2 ) ) )
		lAtuHelp:= .T.
		RecLock( 'SX1', .T. )
		For nXb := 1 To Len( aDados[nXa] )
			If aScan( aStruDic, { |aX| PadR( aX[1], 10 ) == PadR( aEstrut[nXb], 10 ) } ) > 0
				SX1->( FieldPut( FieldPos( aEstrut[nXb] ), aDados[nXa][nXb] ) )
			EndIf
		Next nXb
		MsUnLock()
	EndIf
Next nXa

// Atualiza Helps
IF lAtuHelp        
//	AADD(aHelp, {'01',{'Informe ou selecione o processo.'},{''},{''}})
		
	For nXc:=1 to Len(aHelp)
		PutHelp( 'P.'+cPerg+aHelp[nXc][1]+'.', aHelp[nXc][2], aHelp[nXc][3], aHelp[nXc][4], .T. )
	Next nXc 	
EndIf	

RestArea( aAreaDic )
RestArea( aArea )   

Return

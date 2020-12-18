#include "FINC021NJ.CH"
#include "PROTHEUS.CH"
#include "MSGRAPHI.CH"

#DEFINE USADO CHR(0)+CHR(0)+CHR(1)
#DEFINE DATAFLUXO					1
#DEFINE ENTRADAS					2
#DEFINE SAIDAS						3
#DEFINE SALDODIA					4
#DEFINE VARIACAODIA				5
#DEFINE ENTRADASACUMULADAS		6
#DEFINE SAIDASACUMULADAS 		7
#DEFINE SALDOACUMULADO 			8 
#DEFINE VARIACAOACUMULADA		9 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FINC021	³ Autor ³ Claudio D. de Souza   ³ Data ³ 04/05/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Fluxo de Caixa 											  			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FINC021()												  				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Gen‚rico 												  				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function NSFinc021()
Local	nCaixas     := 0,; // Total em caixa
		nBancos	   := 0,; // Total em bancos
		oDlg			,;
		oGet01		,;
		oGetFilDe   ,;
		lReceber	  := .T.,;
		lPagar     := .T.,;
		lComissoes := .T.,;
		lPedVenda  := .F.,;
		lPedCompra := .T.,;
		lAplicacoes:= .F.,;
		lSaldoBanc := .F.,;
		lAnalitico := .T.,;
		lConsFil   := .F.,;
		lConsDtBase:= .F.,;
		lTitAtraso := .F.,;
		cTipoSaldo 			,;
		cFilDe     := "  ",;
		cFilAte    := "ZZ",;
		nMoeda     := 1   ,;
		aMoedas	  := {}  ,;
		cMoeda			   ,;				
		cPeriodo          ,;
		nPeriodos  := 10  ,;
		nOpcA      := 0   ,;
		cAlias := Alias() ,;
		lTitFuturo := .F.,;
		lCtrc		  := .F.,;
		nLin, ;
		lLimCred 	:= .T. ,;  // Considera Limite de crédito bancário
		nLimCred		:= 0 			// Limite de credito bancario
		
Local aBancos := {},;
		aAplic  := {},;		
		aCmbPer,;
		cFilterSe1,;
		cFilterSe2

Local cBancoCx := GetMV("MV_CARTEIR")
Local nHandle, cLog := Space(69), nOffSet := 0
Local aTipoSaldo
Local oPedidos
Local cPedidos := "3"
Local aPedidos := { STR0224, STR0225, STR0226 } // "1-Liberados", "2-Bloqueados", "3-Ambos"
Local nX := 0
Local lPesqUsu

PRIVATE cErros 	:= ""		//Utilizada na funcao que interpreta a formula de reajuste do pedido de compra
PRIVATE aBackSC7 	:= {}		//Utilizada na visualizacao do pedido de compra (Mata120)

aCmbPer := {STR0001,; //"01 Diario"
		      STR0002,; //"07 Semanal"
				STR0003,; //"10 Decendial"
			  	STR0004,; //"15 Quinzenal"
			  	STR0005 } //"30 Mensal"

aTipoSaldo := {	STR0217,; // "1-Normal      
						STR0218,; // "2-Conciliado
						STR0219 } // "3-Não Conciliado
				  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa array com as moedas existentes.	Para montar o combo de moedas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			  
aMoedas := GetMoedas()
ASort(aMoedas) 

// Carrega as opcoes gravadas para o usuario
If File("NSFINC021.PAR")
//If File("FINC021.PAR")
	nHandle := fOpen("NSFINC021.PAR",2)
	If (lPesqUsu := PesqUsu(nHandle,@cLog,@nOffSet)) // Pesquisa o usuario atual
		lReceber 	:= Substr(cLog,21,1)=="S"
		lPagar		:= Substr(cLog,22,1)=="S"
		lComissoes	:= Substr(cLog,23,1)=="S"
		lPedVenda	:= Substr(cLog,24,1)=="S"
		lPedCompra  := Substr(cLog,25,1)=="S"
		lAplicacoes := Substr(cLog,26,1)=="S"
		lTitAtraso	:= Substr(cLog,27,1)=="S"
		lConsFil		:= Substr(cLog,28,1)=="S"
		If lConsFil
			cFilDe		:= Substr(cLog,29,2)
			cFilAte		:= Substr(cLog,31,2)
		Endif	
		cPeriodo		:= Substr(cLog,33,12)
		nPeriodos   := Val(Substr(cLog,45,4))
		cMoeda 		:= Substr(cLog,49,15)
		lAnalitico 	:= Substr(cLog,64,1)=="S"
		lConsDtBase	:= Substr(cLog,65,1)=="S"
		cTipoSaldo	:= aTipoSaldo[If(Val(Substr(cLog,66,1)) > 0,Val(Substr(cLog,66,1)),1)]
		lTitFuturo	:= Substr(cLog,67,1)=="S"
		lCtrc			:= Substr(cLog,68,1)=="S"
		cPedidos		:= Substr(cLog,69,1)
	Endif
Endif	
fClose(nHandle)

If Empty(cPedidos)
	cPedidos := "3"
Endif

cPedidos := aPedidos[Val(cPedidos)]

/***Dias a considerar para o calculo bancário*/
nDias:=0
if !Empty(cPeriodo) .and. Len(cPeriodo)>2
	nDias  := Val(Left(cPeriodo,2))*nPeriodos // Calcula quantos dias
EndIf	
If nDias <= 0
   nDias := 1
EndIf

// Gera os registros para todas as datas do periodo, inclusive a database
DatIni:=dDataBase-nDias
If DatIni<Ctod("31/03/2010")
	DatIni:=Ctod("31/03/2010")
EndIF
/******************************************************************/

// Gera os registros para todas as datas do periodo, inclusive a database


DEFINE MSDIALOG oDlg TITLE STR0006 FROM 0,0 TO If(IntTms(),365,345),450 OF oMainWnd PIXEL FONT oMainWnd:oFont //"Selecione opçoes do Fluxo de Caixa"
@ 05, 05 CHECKBOX oGet01 VAR lReceber    PROMPT STR0007 FONT oDlg:oFont PIXEL OF oDlg SIZE 80,9 //"Titulos a Receber"
@ 18, 05 CHECKBOX oGet01 VAR lPagar      PROMPT STR0008 FONT oDlg:oFont PIXEL OF oDlg SIZE 80,9 //"Titulos a Pagar"

//@ 31, 05 CHECKBOX oGet01 VAR lComissoes  PROMPT STR0009 FONT oDlg:oFont PIXEL OF oDlg SIZE 80,9 //"Comissões" abi
//@ 44, 05 CHECKBOX oGet01 VAR lPedVenda   PROMPT STR0010 FONT oDlg:oFont PIXEL OF oDlg SIZE 80,9 //"Pedido de Venda" abi
//@ 57, 05 CHECKBOX oGet01 VAR lPedCompra  PROMPT STR0011 FONT oDlg:oFont PIXEL OF oDlg SIZE 80,9 ; //"Pedido de Compra" abi
//ON CLICK oPedidos:SetFocus()
			
//@ 57, 90 SAY STR0227 FONT oDlg:oFont PIXEL OF oDlg  // "Pedidos" abi
//@ 56,125 COMBOBOX oPedidos VAR cPedidos ITEMS aPedidos SIZE 60, 54 FONT oDlg:oFont PIXEL OF oDlg WHEN lPedCompra abi
If !__lPyme
	//@ 70, 05 CHECKBOX oGet01 VAR lAplicacoes PROMPT STR0012 FONT oDlg:oFont PIXEL OF oDlg SIZE 80,9 //"Aplicacoes/Emprestimos" abi
	@ 31, 05 CHECKBOX oGet01 VAR lAplicacoes PROMPT STR0012 FONT oDlg:oFont PIXEL OF oDlg SIZE 80,9 //"Aplicacoes/Emprestimos" a
Endif			
//@ 83, 05 CHECKBOX oGet01 VAR lSaldoBanc  PROMPT STR0013  FONT oDlg:oFont PIXEL OF oDlg SIZE 80,9; //"Saldos Bancarios" abi
@ 44, 05 CHECKBOX oGet01 VAR lSaldoBanc  PROMPT STR0013  FONT oDlg:oFont PIXEL OF oDlg SIZE 80,9; //"Saldos Bancarios" 
         ON CLICK (oGetTpSaldo:SetFocus(),If( lSaldoBanc,(nMoeda := Val(Left(cMoeda,2)), aBancos := Bancos( lConsFil, nMoeda, @nBancos, @nCaixas,cFilDe,cFilAte,cTipoSaldo,.F.,,@lLimCred)), NIL ))
@44, 80  SAY STR0216 FONT oDlg:oFont PIXEL OF oDlg // "Tipo de Saldo"
@44, 125 COMBOBOX oGetTpSaldo VAR cTipoSaldo ITEMS aTipoSaldo SIZE 60, 54 FONT oDlg:oFont PIXEL OF oDlg WHEN lSaldoBanc;
			ON CHANGE (If( lSaldoBanc, (nMoeda := Val(Left(cMoeda,2)), aBancos := Bancos( lConsFil, nMoeda, @nBancos, @nCaixas,cFilDe,cFilAte,cTipoSaldo,.T.,aBancos,@lLimCred)), NIL ))
         
//@ 96, 05 CHECKBOX oGet01 VAR lTitAtraso  PROMPT STR0014 FONT oDlg:oFont PIXEL OF oDlg SIZE 80,9 //"Titulos em Atraso" abi
@ 57, 05 CHECKBOX oGet01 VAR lTitAtraso  PROMPT STR0014 FONT oDlg:oFont PIXEL OF oDlg SIZE 80,9 //"Titulos em Atraso"
//@ 96, 80 CHECKBOX oGet01 VAR lTitFuturo PROMPT STR0220 FONT oDlg:oFont PIXEL OF oDlg SIZE 80,9	//"Titulos com Emissão Futura" abi
nLin := 96
If IntTms()
	nLin := 109
	@ 109, 05 CHECKBOX oGet01 VAR lCtrc  PROMPT "Doctos. de Transporte" FONT oDlg:oFont PIXEL OF oDlg SIZE 80,9
Endif                          

/*abi
@nLin+16, 00 TO nLin + 17, 340 OF oDlg PIXEL 
@nLin+25, 05 CHECKBOX oGet01 VAR lConsFil PROMPT STR0017 FONT oDlg:oFont PIXEL OF oDlg SIZE 50,9 ON CLICK oGetFilDe:SetFocus() //"Considera filiais"
@nLin+25, 80 SAY STR0018 FONT oDlg:oFont PIXEL OF oDlg //"Filial de"
@nLin+25,110 MSGET oGetFilDe VAR cFilDe FONT oDlg:oFont PIXEL SIZE 10, 9 OF oDlg PICTURE "!!" WHEN lConsFil F3 "SM0"
@nLin+25,140 SAY STR0019 FONT oDlg:oFont PIXEL OF oDlg //"Ate"
@nLin+25,160 MSGET oGet01 VAR cFilAte FONT oDlg:oFont PIXEL SIZE 10, 9 OF oDlg PICTURE "!!" WHEN lConsFil F3 "SM0"
abi*/                               
lAnalitico:=.T.
@nLin+38, 05 SAY STR0020    FONT oDlg:oFont PIXEL OF oDlg //"Periodicidade"
@nLin+38, 50 COMBOBOX oGet01 VAR cPeriodo ITEMS aCmbPer FONT oDlg:oFont PIXEL OF oDlg SIZE 50,54
@nLin+38,100 SAY STR0021 FONT oDlg:oFont PIXEL OF oDlg  //"Quantos periodos"
@nLin+38,150 MSGET  oGet01 VAR nPeriodos   FONT oDlg:oFont PIXEL SIZE 30, 09 OF oDlg PICTURE "9999"

@nLin+51, 05 SAY STR0022 FONT oDlg:oFont PIXEL OF oDlg //"Moeda"
@nLin+51, 50 COMBOBOX oGet01 VAR cMoeda ITEMS aMoedas SIZE 60, 54 FONT oDlg:oFont PIXEL OF oDlg


//@nLin+51, 120 CHECKBOX oGet01 VAR lAnalitico PROMPT STR0023 FONT oDlg:oFont PIXEL OF oDlg SIZE 70,9 //"Processa analitico"
lConsDtBase:=.T.
//@nLin+64, 05 CHECKBOX oGet01 VAR lConsDtBase PROMPT STR0215 FONT oDlg:oFont PIXEL OF oDlg SIZE 70,9 // "Considera Data Base"

DEFINE SBUTTON FROM 05,190 TYPE 17 ENABLE OF oDlg ACTION Fc021Filtro(@cFilterSe1,@cFilterSe2)
DEFINE SBUTTON FROM 20,190 TYPE  1 ENABLE OF oDlg ACTION (nOpcA := 1, oDlg:End())
DEFINE SBUTTON FROM 35,190 TYPE  2 ENABLE OF oDlg ACTION (nOpcA := 0, oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED
		
If nOpcA == 1
	If File("NSFINC021.PAR")
		nHandle := fOpen("NSFINC021.PAR",2)
	Else
		nHandle := fCreate("NSFINC021.PAR")
	Endif
	If !lPesqUsu
		fSeek(nHandle,nOffSet,0) // Posiciona na linha a ser gravada
	Else
		fSeek(nHandle,nOffSet-(Len(cLog)+2),0) // Posiciona na linha a ser gravada
	Endif	
	cLog := Pad(Left(cUsuario,19),20)
	cLog += If(lReceber,"S","N")
	cLog += If(lPagar,"S","N")
	cLog += If(lComissoes,"S","N")
	cLog += If(lPedVenda,"S","N")
	cLog += If(lPedCompra,"S","N")
	cLog += If(lAplicacoes,"S","N")
	cLog += If(lTitAtraso,"S","N")
	cLog += If(lConsFil,"S","N")
	cLog += cFilDe+cFilAte
	cLog += Pad(cPeriodo,12)
	cLog += Str(nPeriodos,4)
	cLog += Pad(cMoeda,15)
	cLog += If(lAnalitico,"S","N")
	cLog += If(lConsDtBase,"S","N")
	cLog += Left(cTipoSaldo,1)
	cLog += If(lTitFuturo,"S","N")
	cLog += If(lCtrc,"S","N")
	cLog += Left(cPedidos,1)
	fWrite(nHandle,cLog+Chr(13)+Chr(10))
	fClose(nHandle)
	
	// Recalcula o saldo em Bancos/Caixas de acordo com a moeda escolhida
	nMoeda	:= Val(Left(cMoeda,2))
	nBancos	:= 0
	nCaixas	:= 0
	nLimCred := 0

	//Somar saldos bancarios e limites de credito bancario
	For nX := 1 to Len(aBancos)
		If aBancos[nX,1]  //	Se Considera banco nos saldos bancarios
			aBancos[nX][6] := Transform(xMoeda(Fc021Val(aBancos[nX][6]),aBancos[nX][7],nMoeda),"@E 999,999,999.99")
			aBancos[nX][8] := Transform(xMoeda(Fc021Val(aBancos[nX][8]),aBancos[nX][7],nMoeda),"@E 999,999,999.99")
			If Left(aBancos[nX][2],2)=="CX" .Or. Left(aBancos[nX][2],3) $ cBancoCx
				nCaixas +=	Fc021Val(aBancos[nX][6])
			Else
			  	nBancos +=	Fc021Val(aBancos[nX][6])
				If lLimCred
				  	nLimCred+=	Fc021Val(aBancos[nX][8])
				Endif
			Endif
		Endif
	Next		

		Processa({|lEnd| Fc021Proc(lEnd,cMoeda,cPeriodo,nPeriodos,cFilDe,cFilAte,lReceber,;
										 lPagar,lComissoes,lPedVenda,lPedCompra,lAplicacoes,;
										 lSaldoBanc,lAnalitico,lConsFil,lTitAtraso,;
										 nCaixas,nBancos,aBancos,aAplic,cFilterSe1,cFilterSe2,;
										 lConsDtBase,lTitFuturo, lCtrc, cPedidos, nLimCred , lLimCred)})
Endif
If !Empty(cAlias)
   DbSelectArea(cAlias)
Endif

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fc021Proc ³ Autor ³ Claudio D. de Souza   ³ Data ³ 17/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Processa Fluxo de Caixa                			  			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Fc021Proc												  				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Financeiro												  				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static FUNCTION Fc021Proc(lEnd,cMoeda,cPeriodo,nPeriodos,cFilDe,cFilAte,lReceber,lPagar,;
						 lComissoes,lPedVenda,lPedCompra,lAplicacoes,lSaldoBanc,;
						 lAnalitico,lConsFil,lTitAtraso,nCaixas,nBancos,;
						 aBancos,aAplic,cFilterSe1,cFilterSe2,lConsDtBase,lTitFuturo,;
						 lCtrc, cPedidos,nLimCred, lLimCred)
						 
Local aArqTmp    ,; // Nome do arquivo temporario e alias criado aleatoriamente
		aArqCo     ,; // Nome do arquivo temporario e alias para comissões
		cSavFil    ,; // Salva a Filial atual
		aCalc      ,; // Calculo de aplicacao
		aAreaSM0 := SM0->(GetArea())   ,; // Salva a area do SM0
		dDataTrab  ,; // Data de trabalho
		nAplicacao  := 0,; // Valor da aplicacao
		nEmprestimo := 0,; // Valor do emprestimo
		nDias          ,;
		nX			      ,;	  // Contador de loop for...next
		nAtrReceber := 0 ,;
		nAtrPagar   := 0 ,;
		aTmpAnaEmp,;
		aTmpAnaApl,;
		aTmpAnaCtrc[2],;
		cAliasEmp,;
		cAliasApl,;
		oDlg
		
Local oGet02,;
		cAliasPc,;
		cAliasAR,;
		cAliasAP,;
		cAliasTit,;
		cArqAnaPc,;
		cAliasChq,;
		aTotais := {{},{},{},{},{},{},{},{}, {}},;
		aPeriodo := {},;
		aFluxo   := {},;
		oPanel,;
		oFluxo,;
		nAscan,;
		nRecSeh,;
		cAplCotas := GetMv("MV_APLCAL4")
		
LOCAL aSize, aObjects := {}, aInfo, aPosObj, nTotRegs := 0

Local aTit := {{"01",STR0177 },{"07",STR0178},{"10",STR0179},{"15",STR0180},{"30",STR0181}},; //"Dia"###"Semana"###"Decendio"###"Quinzena"###"Mes"
		cTit
Local lLibCheq := GetMv("MV_LIBCHEQ")=="N" // Para controlar os cheques pendentes de
														  // liberacao.

Local j := 0

Local nValBancos := 0 

aCols := {} //	Declara a Cols Aqui, pois sera utilizada na rotina de simulacao
				//	e seu conteudo deve permanecer o mesmo toda vez que o usuario clicar
				//	no botao simulacao.
aHeader := {}

// Utilizada na simulacao
aHeader := {}
Aadd( aHeader, { STR0024	, "_SI_DATA"  , "", 8, 0, ".T.", USADO, "D",, "V" } ) //"Data"
Aadd( aHeader, { STR0025	, "_SI_TIPO"  , "!", 1, 0, "Fc021Tipo()", USADO, "C",, "V" } ) //"Receita/Despesa"
Aadd( aHeader, { STR0026	, "_SI_VALOR" , "@E 999,999,999.99", 15, 2, ".T.", USADO, "N",, "V" } ) //"Valor"
Aadd( aHeader, { STR0027	, "_SI_HISTOR", "@!", 40, 0, ".T.", USADO, "C",, "V" } ) //"Historico"
Aadd( aHeader, { STR0199 	, "_SI_VALANT", "@E 999,999,999.99", 15, 2, ".T.", USADO, "N",, "V" } ) //"Valor"

// Pega o titulo da primeira coluna de acordo com o periodo selecionado
cTit := aTit[Ascan(aTit,{|e|e[1]==Left(cPeriodo,2)})][2]

nMoeda := Val(Left(cMoeda,2))
nDias  := Val(Left(cPeriodo,2))*nPeriodos // Calcula quantos dias
If nDias <= 0
   nDias := 1
EndIf

// Gera os registros para todas as datas do periodo, inclusive a database
DatIni:=dDataBase-nDias
If DatIni<Ctod("31/03/2010")
	DatIni:=Ctod("31/03/2010")
EndIF

For nX := 1 To nDias+1

//	(dDataTrab := dDataBase+nX-1) Alteração para o Realizado Aglair  até a data baser
//	DatIni:=DatIni+nx-1
    dDataTrab:=DatIni
    TemFluxoData(dDataTrab,aFluxo)
	TemFluxoData(dDataTrab,aPeriodo)
    DatIni+=1
Next
// Monta os periodos na matriz para ser utilizada na simulacao e na projecao
MontaPeriodo(aPeriodo,cPeriodo)

// Inicia o total de registros a srem processados para incrementar a regua
If lReceber
	nTotRegs += SE1->(RecCount())
Endif
If lPagar 
	nTotRegs +=  SE2->(RecCount())
Endif
If lComissoes 
	nTotRegs += SE3->(RecCount())
Endif
If lPedVenda 
	nTotRegs += SC6->(RecCount())
Endif
If lPedCompra
	nTotRegs += SC7->(RecCount())
Endif
If lAplicacoes 
	nTotRegs += SEH->(RecCount())
Endif
If lSaldoBanc
	nTotRegs += SE8->(RecCount())
Endif

ProcRegua(nTotRegs)
	
If lAplicacoes
	If lAnalitico
	   aTmpAnaEmp := CriaTmpAna(1) // Cria o arquivo temporario analitico de emprestimos
	   cAliasEmp  := aTmpAnaEmp[1]
	   aTmpAnaApl := CriaTmpAna(2) // Cria o arquivo temporario analitico de aplicacoes
	   cAliasApl  := aTmpAnaApl[1]
   Endif
   DatIni:=dDataBase-nDias+1 
  
	For j:=1 To nDias
		dDataTrab := DatIni+j-1
		cSavFil := cFilAnt
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atribui valores as variaveis ref a filiais                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !lConsFil
		   cFilDe  := cFilAnt
			cFilAte := cFilAnt
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica a Disponibilidade Financeira                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SM0")
		dbSetOrder(1)
		dbSeek(cEmpAnt+cFilDe,.T.)
		While SM0->(!Eof()) .And. SM0->M0_CODIGO == cEmpAnt .And. SM0->M0_CODFIL <= cFilAte
			cFilAnt := SM0->M0_CODFIL
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se existe Emprestimo a ser resgatado no dia ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SEH")
			dbSetOrder(2)
			dbSeek(xFilial("SEH")+"A",.T.)
			nRecSeh := Recno()
			While ( !Eof() .And. SEH->EH_FILIAL == xFilial("SEH") .And. SEH->EH_STATUS == "A" )
				If SEH->EH_APLEMP == "EMP" 
					If ( Empty(SEH->EH_DATARES) .And. J==1 ) .Or.;
						( SEH->EH_DATARES == dDataTrab )
						dA181DtApr := dDataTrab
						nA181VlMoed:= RecMoeda(dA181DtApr,SEH->EH_MOEDA)
						nA181SPCP2	:= 0
						nA181SPLP2	:= 0
						nA181SPCP1	:= 0
						nA181SPLP1	:= 0
						nA181SJUR2	:= 0
						nA181SJUR1	:= 0
						nA181SVCLP	:= 0
						nA181SVCCP	:= 0
						nA181SVCJR	:= 0
						nA181VPLP1 	:= 0
						nA181VPCP1 	:= 0
						nA181VJUR1 	:= 0
						nA181VVCLP 	:= 0
						nA181VVCCP 	:= 0
						nA181VVCJR 	:= 0
						nA181VPLP2 	:= 0
						nA181VlDeb  := 0
	
						aCalculo	  := Fa171Calc(dDataTrab,SEH->EH_SALDO,.F.)
						nA181SPCP2 := Round(SEH->EH_SALDO * SEH->EH_PERCPLP/100 , TamSX3("EH_SALDO")[2])
						nA181SPLP2 := SEH->EH_SALDO - nA181SPCP2
						nA181SPLP1 := SEH->EH_VLCRUZ
						nA181SPCP1 := Round(SEH->EH_VLCRUZ * SEH->EH_PERCPLP/100,TamSX3("EH_SALDO")[2])
						nA181SPLP1 := SEH->EH_VLCRUZ - nA181SPCP1
						nA181SJUR2 := aCalculo[1,2]
						nA181SJUR1 := aCalculo[2,2]
						nA181SVCLP := aCalculo[2,3]
						nA181SVCCP := aCalculo[2,4]
						nA181SVCJR := aCalculo[2,5]
						nA181VlIRF := 0
						nA181VLDES := 0
						nA181VLGAP := 0
						nA181STOT1 := nA181SPLP1+nA181SPCP1+nA181SJUR1+nA181SVCLP+nA181SVCCP+nA181SVCJR
						nA181STOT2 := nA181SPLP2+nA181SPCP2+nA181SJUR2
						nA181VPLP1 := nA181SPLP1
						nA181VPCP1 := nA181SPCP1
						nA181VPLP2 := nA181SPLP2
						nA181VPCP2 := nA181SPCP2
						nA181VJUR1 := nA181SJUR1
						nA181VJUR2 := nA181SJUR2
						nA181VVCLP := nA181SVCLP
						nA181VVCCP := nA181SVCCP
						nA181VVCJR := nA181SVCJR
						nA181VTOT1 := nA181STOT1
						nA181VTOT2 := nA181STOT2
						
						Fa181Valor(,"DA181DTAPR") // Atualiza as variaveis PRIVATES do calculo do emprestimo
						nEmprestimo := xMoeda(nA181VlDeb,1,nMoeda,dDataTrab)
						// Verifica se esta no periodo solicitado
						nAscan := Ascan(aPeriodo, {|e| e[1] == dDataTrab})
						If nAscan > 0
							aFluxo[nAscan][SAIDAS] += nEmprestimo
						Endif	
						If lAnalitico .And. nEmprestimo > 0
							// Pesquisa na matriz de totais, os totais de contas a pagar
							nAscan := Ascan( aTotais[6], {|e| e[1] == dDataTrab})
							If nAscan == 0
								Aadd( aTotais[6], {dDataTrab,nEmprestimo})
							Else	
								aTotais[6][nAscan][2] += nEmprestimo // Contabiliza os totais de emprestimos 
							Endif
							// Verifica se esta no periodo solicitado
							nAscan := Ascan(aPeriodo, {|e| e[1] == dDataTrab})
							If nAscan > 0
								RecLock(cAliasEmp,.T.)
								(cAliasEmp)->DataX	:= dDataTrab
								(cAliasEmp)->Periodo	:= aPeriodo[nAscan][2]
								(cAliasEmp)->NUMERO	:= SEH->EH_NUMERO
								(cAliasEmp)->BANCO	:= SEH->EH_BANCO
								(cAliasEmp)->AGENCIA	:= SEH->EH_AGENCIA
								(cAliasEmp)->CONTA	:= SEH->EH_CONTA
								(cAliasEmp)->EMISSAO	:= SEH->EH_DATA
								(cAliasEmp)->SALDO	:= nEmprestimo
								(cAliasEmp)->APELIDO	:= "SEH"
								(cAliasEmp)->CHAVE	:= xFilial("SEH")+SEH->EH_NUMERO+SEH->EH_REVISAO
								MsUnlock()
							Endif
						Endif	
					Endif
				EndIf
				dbSelectArea("SEH")
				dbSkip()
			EndDo
			DbGoTo(nRecSeh) // Para evitar outro SEEK
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se existe Aplicacoes a serem resgatadas no dia ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			While ( !Eof() .And. SEH->EH_FILIAL == xFilial("SEH") .And. SEH->EH_STATUS == "A" )
				If SEH->EH_APLEMP == "APL"
			  		If (Empty(SEH->EH_DATARES) .And. J==1) .Or.;
			  			(SEH->EH_DATARES == dDataTrab)
						nAplicacao := xMoeda(SEH->EH_SALDO,1,nMoeda,dDataTrab)
					Else
						nAplicacao := 0
					EndIf
					DbSelectArea("SE9")
					DbSetOrder(1)
					DbSeek(xFilial()+SEH->EH_CONTRAT+SEH->EH_BCOCONT+SEH->EH_AGECONT)
					DbSelectArea("SEH")
					If (Empty(SEH->EH_DATARES) .And. J==1) .Or.;
						(SEH->EH_DATARES == dDataTrab)
						If !SEH->EH_TIPO $ cAplCotas
							aCalc :=	Fa171Calc(dDataTrab)
						Else
							aCalc := {0,0,0,0,0,0}
							DbSelectArea("SE0")
							MsSeek(xFilial("SE0")+SE9->(E9_BANCO+E9_AGENCIA+E9_CONTA+E9_NUMERO))
							Aadd(aAplic,{	SEH->EH_CONTRAT,SEH->EH_BCOCONT,SEH->EH_AGECONT,;
												Transform(SEH->EH_SALDO,"@E 999,999,999.99"),;
												Transform(SE9->E9_VLRCOTA,PesqPict("SE9","E9_VLRCOTA",18)),;
												SE0->E0_VALOR})
							DbSelectArea("SEH")					
							nAscan := Ascan(aAplic, {|e|	e[1] == SEH->EH_CONTRAT .And.;
																   e[2] == SEH->EH_BCOCONT .And.;
																   e[3] == SEH->EH_AGECONT})
							If nAscan > 0																	   
								aCalc	:=	Fa171Calc(dDataTrab,SEH->EH_SLDCOTA,,,,SEH->EH_VLRCOTA,aAplic[nAscan][6],(SEH->EH_SLDCOTA * aAplic[nAscan][6]))
							Endif	
						EndIf
						nAplicacao += xMoeda((aCalc[5]-aCalc[2]-aCalc[3]-aCalc[4]),;
												    1,nMoeda,dDataTrab)
					EndIf
					// Verifica se esta no periodo solicitado
					nAscan := Ascan(aPeriodo, {|e| e[1] == dDataTrab})
					If nAscan > 0
						aFluxo[nAscan][ENTRADAS] += nAplicacao
					Endif	
					If lAnalitico .And. nAplicacao > 0
						// Pesquisa na matriz de totais, os totais de contas a pagar
						nAscan := Ascan( aTotais[7], {|e| e[1] == dDataTrab})
						If nAscan == 0
							Aadd( aTotais[7], {dDataTrab,nAplicacao})
						Else	
							aTotais[7][nAscan][2] += nAplicacao // Contabiliza os totais de Aplicacoes
						Endif
						// Verifica se esta no periodo solicitado
						nAscan := Ascan(aPeriodo, {|e| e[1] == dDataTrab})
						If nAscan > 0
							RecLock(cAliasApl,.T.)
							(cAliasApl)->DataX	:= dDataTrab
							(cAliasApl)->Periodo	:= aPeriodo[nAscan][2]
							(cAliasApl)->NUMERO	:= SEH->EH_NUMERO
							(cAliasApl)->BANCO	:= SEH->EH_BANCO
							(cAliasApl)->AGENCIA	:= SEH->EH_AGENCIA
							(cAliasApl)->CONTA	:= SEH->EH_CONTA
							(cAliasApl)->EMISSAO	:= SEH->EH_DATA
							(cAliasApl)->SALDO	:= nAplicacao
							(cAliasApl)->APELIDO	:= "SEH"
							(cAliasApl)->CHAVE	:= xFilial("SEH")+SEH->EH_NUMERO+SEH->EH_REVISAO
							MsUnlock()
						Endif
					Endif
				Endif
				dbSelectArea("SEH")
				dbSkip()
			EndDo
			If Empty(xFilial("SEH"))
				Exit
			Endif
			dbSelectArea("SEH")
			dbSetOrder(1)
			dbSelectArea("SM0")
			dbSkip()
		EndDo
		cFilAnt := cSavFil
		SM0->(RestArea(aAreaSM0))
	Next	
Endif	
aArqTmp := Array(4)
If lLibCheq // Verifica cheques nao liberados
	cSavFil := cFilAnt
	If lAnalitico
	   aTmpAnaChq := CriaTmpAna(6) // Cria o arquivo temporario analitico de emprestimos
	   cAliasChq  := aTmpAnachq[1]
   Endif
	While SM0->(!Eof()) .And. SM0->M0_CODIGO == cEmpAnt .And. SM0->M0_CODFIL <= cFilAte
		cFilAnt := SM0->M0_CODFIL
		cFiltro := "EF_FILIAL='"+xFilial("SEF")+"'.And."
//ABI	cFiltro += "EF_NUM<>'"+Space(Len(SEF->EF_NUM))+"'.And."
        cFiltro +=" EF_NUM='' .and. " 
		cFiltro += "!EF_IMPRESS$'AC'.And."
		cFiltro += "EF_LIBER<>'S'.And."
		cFiltro += "EF_CART<>'R'"
		dbSelectArea("SEF")
		cIndTmp := CriaTrab(,.F.)
		IndRegua("SEF",cIndTmp,"EF_FILIAL+DTOS(EF_DATA)+EF_LIBER",,cFiltro)
		nIndSEF := RetIndex("SEF")
		nIndSEF++
		#IFNDEF TOP
			dbSetIndex(cIndTmp+ordBagExt())
		#ENDIF
		DbSetOrder(nIndSef)
		#IFNDEF TOP
			DbGoTop()
		#ENDIF	
       DatIni:=dDataBase-nDias+1 
//	   datIni:=DatIni+nx-1
//	   dDataTrab:=DatIni

//		While Sef->(!Eof()) .And. SEF->EF_DATA<=dDataBase+nDias-1 .And. SEF->EF_LIBER$" N" .And. SEF->EF_FILIAL == xFilial("SEF") alteração feita pela Aglair
		While Sef->(!Eof()) .And. SEF->EF_DATA<=dDataBase .And. SEF->EF_LIBER$" N" .And. SEF->EF_FILIAL == xFilial("SEF")

			// Verifica se esta no periodo solicitado
//			If SEF->EF_DATA < dDataBase // Se o cheque nao foi liberado e estiver anterior a data inicial Alterado pela Aglair
												 // do fluxo de caixa, assume a data base para exibir este cheque.
 	      If SEF->EF_DATA >=DatIni
				nAscan := 1
			Else
				nAscan := Ascan(aPeriodo, {|e| e[1] == SEF->EF_DATA})
			Endif	
			If nAscan > 0
				// Se não for cheque sobre titulos, assume como saida de caixa
				If !AllTrim(SEF->EF_ORIGEM) $ "FINA390TIT"
					aFluxo[nAscan][SAIDAS] += SEF->EF_VALOR
				EndIf
				If lAnalitico
					RecLock(cAliasChq,.T.)
//					(cAliasChq)->DataX	:= If(SEF->EF_DATA < dDataBase,dDataBase,SEF->EF_DATA) alterado pela Aglair
					(cAliasChq)->DataX	:= If(SEF->EF_DATA < DatIni,DatIni,SEF->EF_DATA) 
					(cAliasChq)->Periodo	:= aPeriodo[nAscan][2]
					(cAliasChq)->NUMERO	:= SEF->EF_NUM
					(cAliasChq)->BANCO	:= SEF->EF_BANCO
					(cAliasChq)->AGENCIA	:= SEF->EF_AGENCIA
					(cAliasChq)->CONTA	:= SEF->EF_CONTA
					(cAliasChq)->SALDO	:= SEF->EF_VALOR
					(cAliasChq)->APELIDO	:= "SEF"
					(cAliasChq)->CHAVE	:= xFilial("SEF")+SEF->(EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM)
	

//					If SEF->EF_DATA < dDataBase // Se o cheque nao foi liberado e estiver anterior a data inicial alt.Aglair
					If SEF->EF_DATA < DatIni
														 // do fluxo de caixa, assume a data base para exibir este cheque.
						nAscan := 1
					Else	
						nAscan := Ascan( aTotais[8], {|e| e[1] == SEF->EF_DATA})
					Endif	
					If nAscan == 0 .Or. Len(aTotais[8]) == 0
//						Aadd( aTotais[8], {If(SEF->EF_DATA < dDataBase,dDataBase,SEF->EF_DATA),SEF->EF_VALOR}) alt.pela Aglair
						Aadd( aTotais[8], {If(SEF->EF_DATA < DatIni,DatIni,SEF->EF_DATA),SEF->EF_VALOR})
					Else	
						aTotais[8][nAscan][2] += SEF->EF_VALOR // Contabiliza os totais de cheques pendentes
					Endif
				Endif	
			Endif
			DbSelectArea("SEF")
			DbSkip()
		End
		dbSelectArea("SEF")
		dbClearFil()
		RetIndex("SEF")
		If !Empty(cIndTmp)
			FErase (cIndTmp+OrdBagExt())
		Endif
		dbSetOrder(1)
		dbSelectArea("SM0")
    	If Empty(xFilial("SEF"))
	   	Exit
	   Endif
		dbSkip()
	EndDo
	cFilAnt := cSavFil
	SM0->(RestArea(aAreaSM0))
Endif
			
If lReceber
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Processa os titulos a receber                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aArqTmp := GeraTmp("SE1",7,dDataBase-nDias,lConsFil,cFilDe,cFilAte,lAnalitico,aFluxo,,,nMoeda,aTotais,aPeriodo,cFilterSe1,lConsDtBase,lTitFuturo)
 Endif	
If lPagar
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Processa os titulos a pagar  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aArqTmp := GeraTmp("SE2",3,dDataBase-nDias,lConsFil,cFilDe,cFilAte,lAnalitico,aFluxo,If(aArqTmp!=Nil,aArqTmp[1],Nil),If(aArqTmp!=Nil,aArqTmp[3],Nil),nMoeda,aTotais,aPeriodo,cFilterSe2,lConsDtBase,lTitFuturo)
Endif        
If lAnalitico  //*Vencidos pela Aglair 
   /*Titulos a receber vencidos ***/
	aTmpAna := CriaTmpAna(8) // Cria o arquivo temporario analitico
	cAliasAr:= aTmpAna[1]
	a=aTmpAna[2]

	   /**Titulos a Receber ***/
	cQuery := " SELECT SE1010.*,E1_FILIAL,E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA AS CHAVE," 
	cQuery += " SA1010.A1_NOME AS E1_NCLIENTE " 
	//		  	cQuery := " SELECT E1_PREFIXO,E1_NUM "
	
	cQuery += " FROM SE1010,SA1010 "
	cQuery += " WHERE "
	cQuery += " A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND "
	cQuery += " E1_VENCREA <= '"+Dtos(dDataBase-1)+"' AND "
	cQuery += " E1_SALDO > 0 AND "
	cQuery += " E1_SITUACA NOT IN ('2','7') AND SE1010.D_E_L_E_T_='' AND SA1010.D_E_L_E_T_='' AND "
    cQuery += " E1_TIPO  NOT IN ('NCC','NDF','IR-','CS-','CF-','PI-','AB-','IR-','IN-','IS-','PI-','CF-','CS-','FU-','FE-') "
    cQuery += " ORDER BY E1_VENCREA "
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)                      
	DbSelectArea("TRB")
	DbGotop()
    TotARec:=0

	While !Eof()

		DbSelectArea(cAliasAR)
		RecLock(cAliasAR,.t.)
        (CAliasAR)->VENCTO:=STod(TRB->E1_VENCREA)
		(cAliasAR)->FILIAL:=TRB->E1_FILIAL	
		(cAliasAR)->E1_PREFIXO:=TRB->E1_PREFIXO
		(cAliasAR)->E1_NUM:=TRB->E1_NUM
		(cAliasAR)->E1_CLIENTE:=TRB->E1_CLIENTE
		(cAliasAR)->E1_LOJA:=TRB->E1_LOJA
		(cAliasAR)->E1_PARCELA:=TRB->E1_PARCELA
		(cAliasAR)->E1_TIPO:=TRB->E1_TIPO
		(cAliasAR)->E1_SITUAC:=TRB->E1_SITUACA
		(cAliasAR)->E1_PORTADO:=TRB->E1_PORTADO
		(cAliasAR)->E1_AGEDEP:=TRB->E1_AGEDEP
		(cAliasAR)->E1_CONTA:=TRB->E1_CONTA
		(cAliasAR)->E1_NCLI:=TRB->E1_NCLIENTE
		(cAliasAR)->E1_VALOR:=TRB->E1_SALDO
		(cAliasAR)->CHAVE:=TRB->CHAVE

		//lTxMoeda := SM2->(MsSeek(DataValida(STod(TRB->E1_VENCREA),.T.))) .And. SM2->&("M2_MOEDA"+Alltrim(Str(nMoeda))) != 0

		nSaldoTit := xMoeda(TRB->E1_SALDO+;
						    TRB->E1_SDACRES -;
		  			 	   	TRB->E1_SDDECRE ,;
						    TRB->E1_MOEDA 	,;
			 			  nMoeda              	,;
			 			  dDatabase) 


		(cAliasAR)->E1_VALOR:=nSaldoTit
	    TotArec+=nSaldoTit
	    MsUnlock()
		DbSelectArea("TRB")
		DbSkip()              			
	End                     
    /**Totalizando todos os itens a receber**/
    AuxD:=dDataBase-nDias
    For i:=1 to nDias 
	    nAscan := Ascan( aTotais[3], {|e| e[1] == STod(TRB->E1_VENCREA)})
		If nAscan == 0
			Aadd( aTotais[3], {AuxD,TotArec})
		Endif 	                     
		AuxD++ 
    Next 
	
    /**Totalizando todos os itens a receber**/
    DbSelectArea("TRB")
	DbCloseArea() 
    /*Titulos a Pagar vencidos**/
	aTmpAna := CriaTmpAna(9) // Cria o arquivo temporario analitico
	cAliasAP:= aTmpAna[1]

	   /**Titulos a Pgar ***/
	cQuery := " SELECT SE2010.*,E2_FILIAL,E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA AS CHAVE," 
	cQuery += " SA2010.A2_NOME AS E2_NFORN " 
	//		  	cQuery := " SELECT E1_PREFIXO,E1_NUM "
	
	cQuery += " FROM SE2010,SA2010 "
	cQuery += " WHERE "
	cQuery += " A2_COD=E2_FORNECE AND A2_LOJA=E2_LOJA AND "
	cQuery += " E2_VENCREA <= '"+Dtos(dDataBase-1)+"' AND "
	cQuery += " E2_SALDO > 0 AND "
	cQuery += " SE2010.D_E_L_E_T_='' AND SA2010.D_E_L_E_T_='' and "
    cQuery += " E2_TIPO  NOT IN ('NCC','NDF','IR-','CS-','CF-','PI-','AB-','IR-','IN-','IS-','PI-','CF-','CS-','FU-','FE-') "
    cQuery += " ORDER BY E2_VENCREA "
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)                      
	DbSelectArea("TRB")
	DbGotop()
    TotAPag:=0
	While !Eof()
		DbSelectArea(cAliasAP)
		RecLock(cAliasAP,.t.)
        (CAliasAP)->VENCTO:=STod(TRB->E2_VENCREA)
		(cAliasAP)->FILIAL:=TRB->E2_FILIAL	
		(cAliasAP)->E2_PREFIXO:=TRB->E2_PREFIXO
		(cAliasAP)->E2_NUM:=TRB->E2_NUM
		(cAliasAP)->E2_FORNECE:=TRB->E2_FORNECE
		(cAliasAP)->E2_LOJA:=TRB->E2_LOJA
		(cAliasAP)->E2_PARCELA:=TRB->E2_PARCELA
		(cAliasAP)->E2_TIPO:=TRB->E2_TIPO
//		(cAliasAP)->E2_SITUAC:=TRB->E2_SITUACA
		(cAliasAP)->E2_PORTADO:=TRB->E2_PORTADO
		(cAliasAP)->E2_NAGENCI:=TRB->E2_NAGENCI
		(cAliasAP)->E2_NCONTA:=TRB->E2_NCONTA
		(cAliasAP)->E2_NFORN:=TRB->E2_NFORN

		nSaldoTit := xMoeda(TRB->E2_SALDO+;
						    TRB->E2_SDACRES -;
		  			 	   	TRB->E2_SDDECRE ,;
						    TRB->E2_MOEDA 	,;
			 			  nMoeda              	,;
			 			  dDatabase) 

		(cAliasAP)->E2_VALOR:=nSaldoTit
		(cAliasAP)->CHAVE:=TRB->CHAVE
		TotAPag+=nSaldoTit 
	    MsUnlock()
		DbSelectArea("TRB")
		DbSkip()
	End 

    AuxD:=dDataBase-nDias
    For i:=1 to nDias 
	    nAscan := Ascan( aTotais[4], {|e| e[1] == STod(TRB->E2_VENCREA)})
		If nAscan == 0
			Aadd( aTotais[4], {AuxD,TotAPag})
		Endif
		AuxD++ 
    Next 
    /**Totalizando todos os itens a receber**/
    
    
    DbSelectArea("TRB")
	DbCloseArea() 


EndIf 


If lPedCompra
	// Variaveis utilizadas pela rotina Fc020Compra()
	aCompras  := {}
	adCompras := {}
	MV_PAR03 := If( lConsFil, 2, 1 )
	MV_PAR02 := nMoeda
	
	// Analitico
	If lAnalitico
		aTmpAna := CriaTmpAna(3) // Cria o arquivo temporario analitico
		cAliasPc:= aTmpAna[1]
		cArqAnaPc:=aTmpAna[2]
     Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Processa os pedidos de compra³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Fc020Compra(cAliasPc,aTotais,.T.,nMoeda,aPeriodo,cFilDe, cFilAte, cPedidos)
	For nX := 1 To Len(aCompras)
		IncProc(STR0028) //"Processando Pedidos de compras"
		// Verifica se esta no periodo solicitado
		nAscan := Ascan(aPeriodo, {|e| e[1] == aCompras[nX][1]})
		// Se a data do pedido ja venceu, insere na primeira data do fluxo
		If aCompras[nX][1] < aPeriodo[1][1]
			aCompras[nX][1] := aPeriodo[1][1]
			nAscan := 1
		Endif	
		If nAscan > 0
			aFluxo[nAscan][SAIDAS] += aCompras[nX][2]
		Endif	
	Next
Endif	
If lCtrc 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Processa os titulos a Doctos. de Transporte										³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   aTmpAnaCtrc := CriaTmpAna(7) // Cria o arquivo temporario analitico de Doctos. de Transporte
	Fc021Ctrc(aTmpAnaCtrc[1],dDataBase+nDias-1,lConsFil,cFilDe,cFilAte,lAnalitico,aFluxo,nMoeda,aTotais,aPeriodo)
Endif	
lPedVenda:=.T.
If lPedVenda
	// Variaveis utilizadas pela rotina Fc020Compra()
	aVendas  := {}
	adVendas := {}
	MV_PAR03 := If( lConsFil, 2, 1 )
	MV_PAR02 := nMoeda
	// Analitico
	If lAnalitico
		aTmpAna := CriaTmpAna(4)// Cria o arquivo temporario analitico
		cAliasPv:= aTmpAna[1]
		cArqAnaPv:=aTmpAna[2]
     Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Processa os pedidos de venda ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Fc020Venda(,cAliasPv,aTotais,.T.,nMoeda,aPeriodo,cFilDe, cFilAte)
	For nX := 1 To Len(aVendas)
		IncProc(STR0029) //"Processando Pedidos de vendas"
		nAscan := Ascan(aPeriodo, {|e| e[1] == aVendas[nX][1]})
		// Se a data do pedido ja venceu, insere na primeira data do fluxo
		If aVendas[nX][1] < aPeriodo[1][1]
			aVendas[nX][1] := aPeriodo[1][1]
			nAscan := 1
		Endif	
		If nAscan > 0
			aFluxo[nAscan][ENTRADAS] += aVendas[nX][2]
		Endif	
	Next
Endif
aArqCo := Array(4)
If lComissoes
	aArqCo := Fc021Comis(dDataBase+nDias-1,lConsFil,cFilDe,cFilAte,aFluxo,nMoeda,lAnalitico,aTotais,aPeriodo)
Endif
If aArqTmp == Nil .And. aArqco == Nil
	IW_MSGBOX(STR0030,STR0198,"STOP") //"E necessario escolher ao menos um tipo"
Else
	aRotina :=	{ {"","", 0 , 1},; 
				 	  {STR0031,"", 0 , 2},; // "Visualizar"
				 	  {"","", 0 , 3},; 
				 	  {"","", 0 , 4},; 
				 	  {"","", 0 , 5},; 
				 	  {"","", 0 , 3} } 
	If lTitAtraso
		If lReceber
			nAtrReceber := Fc021Vencidos("SE1",lConsFil,cFilDe,cFilAte,nMoeda,cFilterSe1)
		Endif
		If lPagar	
			nAtrPagar   := Fc021Vencidos("SE2",lConsFil,cFilDe,cFilAte,nMoeda,cFilterSe2)
		Endif
		If lComissoes	
			nAtrPagar   += Fc021Vencidos("SE3",lConsFil,cFilDe,cFilAte,nMoeda)
		Endif	
	Endif	
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ordena aFluxo pela data³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
	aFluxo := aSort(aFluxo,,,{|x,y| x[1] < y[1]})
	aEval(aTotais, {|e| aSort(e,,, {|x,y| x[1] < y[1] })}) // Ordena pela data de cada sub-total
	Consolida(aFluxo,aTotais,cPeriodo)
	CalcSaldo(aFluxo,nBancos,nCaixas,nAtrReceber,nAtrPagar,nLimCred)
	nValBancos := nBancos + nLimCred	
	
	aSize := MsAdvSize()
	aadd( aObjects, {  30,  70, .T., .T.} )
	aadd( aObjects, {  20, 180, .T., .T., .T. } )
	aInfo := { aSize[1],aSize[2],aSize[3],aSize[4], 0, 0 }
	aPosObj := MsObjSize( aInfo, aObjects )
	DEFINE MSDIALOG oDlg TITLE STR0032 + STR0197 + Capital(SubStr(cMoeda,3)) FROM aSize[7],0 TO aSize[6],aSize[5] PIXEL OF oMainWnd //"Fluxo de Caixa" //"Fluxo de Caixa" //" em "

	oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,50,50,.T.,.T. )
	oPanel:Align := CONTROL_ALIGN_TOP

	@  0,  1 TO 48,396 OF oPanel PIXEL
	@  6,  6 TO 44,152 PROMPT STR0033 OF oPanel PIXEL //"Titulos Atrasados"
	@  6,156 TO 44,311 PROMPT STR0034 OF oPanel PIXEL //"Saldos"
	@ 16, 11 SAY STR0035   OF oPanel PIXEL //"A Pagar"
	@ 29, 11 SAY STR0036 OF oPanel PIXEL //"A Receber"
	@ 16,162 SAY STR0037  OF oPanel PIXEL //"Em &Caixa"
	@ 29,162 SAY STR0038 OF oPanel PIXEL //"Em &Bancos"
	@ 14, 73 MSGET nAtrPagar   SIZE 76,10 OF oPanel WHEN .F. PICTURE TM(nAtrPagar,21,TamSX3("E2_SALDO")[2]) PIXEL
	@ 29, 73 MSGET nAtrReceber SIZE 76,10 OF oPanel WHEN .F. PICTURE TM(nAtrPagar,21,TamSX3("E1_SALDO")[2]) PIXEL
	@ 14,231 MSGET oGet01 VAR nCaixas     SIZE 76,10 OF oPanel WHEN .T. VALID { || If(oGet01:lModified,;
																				 (CalcSaldo(aFluxo,nValBancos,nCaixas,nAtrReceber,nAtrPagar,0),oFluxo:Refresh(.T.)), Nil), .T. } PICTURE "@E 999,999,999.99" PIXEL
	@ 29,231 MSGET oGet02 VAR nValBancos  SIZE 76,10 OF oPanel WHEN .T. VALID { || If(oGet02:lModified,;
																				 (CalcSaldo(aFluxo,nValBancos,nCaixas,nAtrReceber,nAtrPagar,0),nBancos:=nValbancos,oFluxo:Refresh(.T.)),Nil), .T. } PICTURE "@E 999,999,999.99" PIXEL
	
	//@ 06,315 BUTTON STR0039 SIZE 32, 13 OF oPanel PIXEL ACTION Grafico(oDlg,aFluxo,nMoeda,cTit) //"&Grafico"
	@ 06,315 BUTTON STR0039 SIZE 32, 13 OF oPanel PIXEL ACTION Grafico(oDlg,aFluxo,nMoeda,cTit+" - Saldo/100000") //"&Grafico"

	@ 06,351 BUTTON STR0040 SIZE 32, 13 OF oPanel PIXEL ACTION oDlg:End() //"&Sair"
	@ 19,315 BUTTON STR0041 SIZE 32, 13 OF oPanel PIXEL ACTION Fc021Simul(aFluxo,oFluxo,nBancos,nCaixas,nAtrReceber,nAtrPagar,nMoeda,nDias,aPeriodo,nLimCred) //"Si&mulação"
	@ 19,351 BUTTON STR0042 SIZE 32, 13 OF oPanel PIXEL ACTION Fc021ImpFlx(aBancos,lSaldoBanc,nCaixas,nBancos,nAtrPagar,nAtrReceber,aFluxo,cTit,cMoeda,lLimCred) //"&Relatório"
	@ 32,315 BUTTON STR0189 SIZE 68, 13 OF oPanel PIXEL ACTION Fc021Excel(aFluxo,nBancos,nCaixas,nAtrReceber,nAtrPagar)  //"&Exportar para Excel"
	
	@ aPosObj[2,1]-63, aPosObj[2,2] LISTBOX oFluxo FIELDS ;
		HEADER cTit   ,; //"Dia","Semana","Decendio","Quinzena","Mes"
				 STR0043,; //"Entradas"
				 STR0044,; //"Saidas"
				 STR0045,; //"Saldo do Dia"
				 STR0046,; //"Var.Dia"
				 STR0047,; //"Entr.Acumul."
				 STR0048,; //"Saida Acumul."
				 STR0049,; //"Saldo Acumul."
				 STR0050 SIZE aPosObj[2,3],aPosObj[2,4]+259; //"Var. Acumul."
		COLSIZES If(Left(cPeriodo,2)="01",30,45),;
	      GetTextWidth(0,"BBBBBBB"),;
			GetTextWidth(0,"BBBBBBB"),;
			GetTextWidth(0,"BBBBBBB"),;
			GetTextWidth(0,"BBBB"),;
			GetTextWidth(0,"BBBBBBBBB"),;
			GetTextWidth(0,"BBBBBBBBB"),;
			GetTextWidth(0,"BBBBBBBBB"),;
			GetTextWidth(0,"BBBB");
	  	OF oDlg ON DBLCLICK (If(lAnalitico, FluxoAna(aArqTmp[2], aArqTmp[4], cAliasPc, cAliasPv, aArqCo[4],cAliasEmp,cAliasApl,aTmpAnaCtrc[1],aFluxo[oFluxo:nAt][DATAFLUXO],aFluxo,aTotais,nBancos,nCaixas,nAtrReceber,nAtrPagar,aPeriodo,cAliasChq,oFluxo,nLimCred,cAliasAR,cAliasAP), IW_MsgBox(STR0051 + STR0023,STR0198,"STOP"))) PIXEL //"Não foi selecionado Processa analitico! Impossivel consultar." 
  	//F oDlg ON DBLCLICK (If(lAnalitico, FluxoAna(aArqTmp[2], aArqTmp[4], cAliasPc, cAliasPv, aArqCo[4],cAliasEmp,cAliasApl,aTmpAnaCtrc[1],aFluxo[oFluxo:nAt][DATAFLUXO],aFluxo,aTotais,nBancos,nCaixas,nAtrReceber,nAtrPagar,aPeriodo,cAliasChq,oFluxo,nLimCred), IW_MsgBox(STR0051 + STR0023,STR0198,"STOP"))) PIXEL //"Não foi selecionado Processa analitico! Impossivel consultar."

//	  	OF oDlg ON DBLCLICK (If(lAnalitico, FluxoAna(aArqTmp[2], aArqTmp[4], cAliasPc, cAliasPv, aArqCo[4],cAliasEmp,cAliasApl,aTmpAnaCtrc[1],aFluxo[oFluxo:nAt][DATAFLUXO],aFluxo,aTotais,nBancos,nCaixas,nAtrReceber,nAtrPagar,aPeriodo,cAliasChq,oFluxo,nLimCred), IW_MsgBox(STR0051 + STR0023,STR0198,"STOP"))) PIXEL //"Não foi selecionado Processa analitico! Impossivel consultar."
	  //	OF oDlg ON DBLCLICK (If(lAnalitico, FluxoAna(aArqTmp[2], aArqTmp[4], cAliasPc, cAliasPv, aArqCo[4],cAliasEmp,cAliasApl,aTmpAnaCtrc[1],aFluxo[oFluxo:nAt][DATAFLUXO],aFluxo,aTotais,nBancos,nCaixas,nAtrReceber,nAtrPagar,aPeriodo,cAliasChq,oFluxo,nLimCred), IW_MsgBox(STR0051 + STR0023,STR0198,"STOP"))) PIXEL //"Não foi selecionado Processa analitico! Impossivel consultar."	
	oFluxo:SetArray(aFluxo)
	oFluxo:bLine := { || {xPadC(Transform(aFluxo[oFluxo:nAt,DATAFLUXO],""),45),;
							  	  Transform(aFluxo[oFluxo:nAt,ENTRADAS				]	,"@e 9999,999,999.99"),;
								  Transform(aFluxo[oFluxo:nAt,SAIDAS				]	,"@e 9999,999,999.99"),;
								  Transform(aFluxo[oFluxo:nAt,SALDODIA				]	,"@e 999,999,999,999.99"),;
								  Transform(aFluxo[oFluxo:nAt,VARIACAODIA			]	,"@r 9999999.99%"),;
								  Transform(aFluxo[oFluxo:nAt,ENTRADASACUMULADAS]	,"@e 99999,999,999,999.99"),;
								  Transform(aFluxo[oFluxo:nAt,SAIDASACUMULADAS	]	,"@e 99999,999,999,999.99"),;
								  Transform(aFluxo[oFluxo:nAt,SALDOACUMULADO		]	,"@e 999,999,999,999,999.99"),;
								  Transform(aFluxo[oFluxo:nAt,VARIACAOACUMULADA	]	,"@r 9999999.99%")}}
	oFluxo:bRClicked       := { |o,nX,nY| oMenu:Activate(nX,nY,oFluxo) }								  
	oFluxo:oWnd:bRClicked  := { |o,nX,nY| oMenu:Activate(nX,nY,oFluxo) }
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define os itens do Menu PopUp                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MENU oMenu POPUP 
		MENUITEM STR0039	Action Grafico(oDlg,aFluxo,nMoeda,cTit) //"&Grafico"
		MENUITEM STR0041  Action Fc021Simul(aFluxo,oFluxo,nBancos,nCaixas,nAtrReceber,nAtrPagar,nMoeda,nDias,aPeriodo,nLimCred) //"Si&mulação"
		MENUITEM STR0042 	Action Fc021ImpFlx(aBancos,lSaldoBanc,nCaixas,nBancos,nAtrPagar,nAtrReceber,aFluxo,cTit,cMoeda,lLimCred) //"&Relatório"
		MENUITEM STR0052 	Action (If(lAnalitico, FluxoAna(aArqTmp[2], aArqTmp[4], cAliasPc, cAliasPv, aArqCo[4],cAliasEmp,cAliasApl,aTmpAnaCtrc[1],aFluxo[oFluxo:nAt][DATAFLUXO],aFluxo,aTotais,nBancos,nCaixas,nAtrReceber,nAtrPagar,aPeriodo,cAliasChq,oFluxo,nLimCred,cAliasAR,cAliasAP), IW_MSGBOX(STR0051 + STR0023,STR0198,"STOP"))) //"Visualiza etapa" //"Fluxo Analitico"###"Não foi selecionado Processa analitico! Impossivel consultar."
		MENUITEM STR0053  Action Fc021Excel(aFluxo,nBancos,nCaixas,nAtrReceber,nAtrPagar) // "Exportar para Excel"
	ENDMENU

	oFluxo:Align := CONTROL_ALIGN_ALLCLIENT
	
	ACTIVATE MSDIALOG oDlg 
	
	If cAliasPc != Nil
		(cAliasPc)->(DbCloseArea())
		fErase(cArqAnaPc+GetDbExtension())
	Endif	
	If cAliasPv != Nil
		(cAliasPv)->(DbCloseArea())
		fErase(cArqAnaPv+GetDbExtension())
	Endif	
   If aArqTmp[2] != Nil .And. Select(aArqTmp[2]) > 0
		(aArqTmp[2])->(DbCloseArea())
     	fErase(aArqTmp[1]+GetDbExtension())
		fErase(aArqTmp[1]+OrdBagExt())
		(aArqTmp[4])->(DbCloseArea())
     	fErase(aArqTmp[3]+GetDbExtension())
		fErase(aArqTmp[3]+OrdBagExt())
	Endif	
	If aArqCo != Nil
		// Apaga o arquivo sintético de comissões
		If aArqCo[2] != Nil .And. Select(aArqCo[2]) > 0
			(aArqCo[2])->(DbCloseArea())
			fErase(aArqCo[1]+GetDbExtension())
			fErase(aArqCo[1]+OrdBagExt())
		Endif	
		// Apaga o arquivo analitico gerado para comissões
		If aArqCo[4] != Nil .And. Select(aArqCo[4]) > 0
			(aArqCo[4])->(DbCloseArea())
     		fErase(aArqCo[3]+GetDbExtension())
			fErase(aArqCo[3]+OrdBagExt())
		Endif
	Endif    
	If cAliasAR != Nil 
		(cAliasAR)->(DbCloseArea())
		//fErase(aTmpAnaEmp[2]+GetDbExtension())
	EndIf 
	If cAliasAP != Nil 
		(cAliasAP)->(DbCloseArea())
		//fErase(aTmpAnaEmp[2]+GetDbExtension())
	EndIf 

	If cAliasEmp != Nil
		(cAliasEmp)->(DbCloseArea())
		fErase(aTmpAnaEmp[2]+GetDbExtension())
	Endif	
	If cAliasApl != Nil
		(cAliasApl)->(DbCloseArea())
		fErase(aTmpanaApl[2]+GetDbExtension())
	Endif	
	If cAliasChq != Nil
		(cAliasChq)->(DbCloseArea())
		fErase(aTmpAnaChq[2]+GetDbExtension())
	Endif	
	If aTmpAnaCtrc[1] != Nil
		(aTmpAnaCtrc[1])->(DbCloseArea())
		fErase(aTmpAnaCtrc[2]+GetDbExtension())
	Endif
Endif
   
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³GeraTmp   ºAutor  ³Claudio D. de Souza º Data ³  30/08/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera dados no arquivo temporario, a partir do arquivo de   º±±
±±º          ³ titulos a receber ou do arquivo de titulos a pagar         º±±
±±º          ³ Parametros:                                                º±±
±±º          ³ cAlias     -> Alias do arquivo (SE1/SE2)                   º±±
±±º          ³ nOrdem     -> Ordem de Vencto.                             º±±
±±º          ³ dUltData   -> Ultima data do periodo                       º±±
±±º          ³ lConsFil   -> Considera filiais                            º±±
±±º          ³ cFilDe     -> Filial inicial                               º±±
±±º          ³ cFilAte    -> Filial final                                 º±±
±±º          ³ lAnalitico -> Gera dados analiticos                        º±±
±±º          ³ aFluxo     -> Matriz que contera os dados do fluxo         º±±
±±º          ³ cArqAnaP   -> Nome do arquivo temporario Analitico CP      º±±
±±º          ³ cArqAnaR   -> Nome do arquivo temporario Analitico CR      º±±
±±º          ³ nMoeda     -> Codigo da Moeda                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINC021                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static  Function GeraArqTVenc
Local aStru:={}



AADD(aStru,{ "FILIAL", "C", 2, 0})
AADD(aStru,{ "E1_PREFIXO", "C", 3, 0})
AADD(aStru,{ "E1_NUM", "C", 9, 0})
AADD(aStru,{ "E1_PARCELA", "C", 1, 0})
AADD(aStru,{ "E1_TIPO", "C", 3, 0})
AADD(aStru,{ "E1_CLIENTE", "C", 6, 0})
AADD(aStru,{ "E1_LOJA", "C", 2, 0})
AADD(aStru,{ "E1_NCLI", "C", 40, 0})
AADD(aStru,{ "E1_SALDO", "N",16,4})
AADD(aStru,{ "E1_SITUAC", "C", 1, 0})
AADD(aStru,{ "E1_PORTADO" , "C", 3, 0})
AADD(aStru,{ "E1_AGEDEP", "C", 5, 0})
AADD(aStru,{ "E1_CONTA", "C", 10, 0})
AADD(aStru,{ "E1_VALOR", "N", 10, 0})
AADD(aStru,{ "CHAVE ", "C", 24, 0})

//   AADD(aStru,{ "E1_CONTA", "D", 8, 0})
TR1 := CriaTrab(aStru, .T.)
USE (TR1) ALIAS TR1 NEW      
   
  
   /**Titulos a Receber ***/
cQuery := " SELECT SE1010.*,E1_FILIAL,E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA AS CHAVE," 
cQuery += " SA1010.A1_NOME AS E1_NCLIENTE " 
//		  	cQuery := " SELECT E1_PREFIXO,E1_NUM "

cQuery += " FROM SE1010,SA1010 "
cQuery += " WHERE "
cQuery += " A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND "
cQuery += " E1_VENCREA <= '"+Dtos(dDataBase-1)+"' AND "
cQuery += " E1_SALDO > 0 AND "
cQuery +=  " E1_SITUACA NOT IN ('2','7') AND SE1010.D_E_L_E_T_='' AND SA1010.D_E_L_E_T_=''"
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)                      
DbSelectArea("TRB")
DbGotop()
While !Eof()
	RecLock("TR1",.t.)
	TR1->FILIAL:=TRB->E1_FILIAL	
	TR1->E1_PREFIXO:=TRB->E1_PREFIXO
	TR1->E1_NUM:=TRB->E1_NUM
	TR1->E1_PARCELA:=TRB->E1_PARCELA
	TR1->E1_TIPO:=TRB->E1_TIPO
	TR1->E1_SITUAC:=TRB->E1_SITUACA
	TR1->E1_PORTADO:=TRB->E1_PORTADO
	TR1->E1_AGEDEP:=TRB->E1_AGEDEP
	TR1->E1_CONTA:=TRB->E1_CONTA
	TR1->E1_NCLI:=TRB->E1_NCLIENTE
	TR1->CHAVE:=TRB->CHAVE
    MsUnlock()
	DbSelectArea("TRB")
	DbSkip()
End 
       
  
Return  &TR1

/***********************************************************************************************************/



STATIC FUNCTION GeraTmp(cAlias,nOrdem,dIniData,lConsFil,cFilDe,cFilAte,lAnalitico,;
							   aFluxo,cArqAnaP,cArqAnaR,nMoeda,aTotais,aPeriodo,cFilterUser,;
							   lConsDtBase,lTitFuturo)
LOCAL cAliasAnaP,;
		cAliasAnaR,;
		cAliasAna ,;
		cAliasTrb ,;
		nSaldoTit ,;
		aCposAna  ,;
		aCposSin  ,;
		cFiltro   ,;
		dDataTrab ,;
		cIndTmp	 ,;
		cCampo    := Right(cAlias,2),;
		nCampSin  := If(Upper(cAlias)=="SE1", ENTRADAS, SAIDAS),;
		cCliFor       ,;
		nAscan        ,;
		cAbatim 	 := MV_CRNEG+"/"+MV_CPNEG+"/"+MVIRABT+"/"+MVCSABT+"/"+MVCFABT+"/"+MVPIABT+"/"+MVABATIM
		
Local aSx3Box 	:= RetSx3Box( Posicione("SX3", 2, "E1_SITUACA", "X3CBox()" ),,, 1 )		
Local cAliasCF  := ""
Local nCiclos	:=	0
Local nAscanPA 	:=	0
Local nX		:=	0
Local lFc021Fil := ExistBlock("FC021FIL")
Local dDataVcOri := Ctod("//")
Local nDesconto
Local lTxMoeda
#IFDEF TOP
	Local cQuery
	Local aStru	  
#ENDIF

cAlias   := Upper(cAlias)

cAliasAnaP := "cArqAnaP"  // Alias do arquivo analitico
cAliasAnaR := "cArqAnaR"  // Alias do arquivo analitico
cAliasAna  := If(cAlias=="SE1","cArqAnaR","cArqAnaP")

if DiniData<Ctod("31/03/2010")
	DIniData:=Ctod("31/03/2010")

Endif
DFim:=DDataBase

// Analitico
If lAnalitico .And. (cArqAnaP == Nil .Or. cArqAnaR == Nil)
	aCposAna := {}
	Aadd( aCposAna, { "Periodo", "C",  20, 0 } )
	Aadd( aCposAna, { "DATAX"  , "D" , 08, 0} )
	Aadd( aCposAna, { "FILIAL"	, "C", TamSx3(cCampo+"_FILIAL")[1], 0 } )
	Aadd( aCposAna, { "PREFIXO", "C", TamSx3(cCampo+"_PREFIXO")[1], 0 } )
	Aadd( aCposAna, { "NUM"    , "C", TamSx3(cCampo+"_NUM")[1], 0 } )
	Aadd( aCposAna, { "PARCELA", "C", TamSx3(cCampo+"_PARCELA")[1], 0 } )
	Aadd( aCposAna, { "TIPO"   , "C", TamSx3(cCampo+"_TIPO")[1], 0 } )
	Aadd( aCposAna, { "CLIFOR" , "C", TamSx3("E5_CLIFOR")[1], 0 } )
	Aadd( aCposAna, { "NomCliFor", "C", TamSx3("A1_NOME")[1], 0 } )
	Aadd( aCposAna, { "LOJA"   , "C", TamSx3(cCampo+"_LOJA")[1], 0 } )
	Aadd( aCposAna, { "SALDO"  , "N", Max(TamSx3("E1_SALDO")[1]  ,;
					  TamSx3("E2_SALDO")[1]) , TamSx3("E1_SALDO")[2] } )
	If cAlias == "SE1"
		Aadd( aCposAna, { "SITUACAO", "C", 20, 0 } )
		Aadd( aCposAna, { "PORTADO", "C", TamSx3(cCampo+"_PORTADO")[1], 0 } )
		Aadd( aCposAna, { "AGEDEP", "C", TamSx3(cCampo+"_AGEDEP")[1], 0 } )
		Aadd( aCposAna, { "CONTA", "C", TamSx3(cCampo+"_CONTA")[1], 0 } )		
	Endif
	
	Aadd( aCposAna, { "CHAVE"  , "C", 40, 0 } )
	Aadd( aCposAna, { "Apelido", "C", 10, 0 } )    
//	Aadd( aCposAna, { "Historico", "C", 10, 0 } )    inc. aglair
   // Ponto de entrada para criar campos no arquivo temporario
	If ExistBlock("FC021CPO")
		aCposA := ExecBlock("FC021CPO",.F.,.F.,{aCposAna})
		For nX := 1 to len(aCposA)		
 			aAdd(aCposAna,aCposA[nX])
	 	Next
	EndIf
	Aadd( aCposAna, { "CampoNulo", "C", 1, 0 } )
	Aadd( aCposAna, { "Flag"     , "L", 1, 0 } )
	Aadd( aCposAna, { "Historico", "C", 40, 0 } )    
	cArqAnaP := CriaTrab(aCposAna,.T.) // Nome do arquivo temporario
	cArqAnaR := CriaTrab(aCposAna,.T.) // Nome do arquivo temporario
	dbUseArea(.T.,__LocalDriver,cArqAnaP,cAliasAnaP,.F.)
	dbUseArea(.T.,__LocalDriver,cArqAnaR,cAliasAnaR,.F.)
   IndRegua ( cAliasAnaP,cArqAnaP,"Dtos(DataX)",,,STR0054) //"Selecionando Registros..."
	IndRegua ( cAliasAnaR,cArqAnaR,"Dtos(DataX)",,,STR0054) //"Selecionando Registros..."
Endif

aCposSin:={{"DATAX"   , "D" , 08, 0},;
		      {"ENTR"    , "N" , 17, 2},;
			   {"SAID"    , "N" , 17, 2},;
			   {"SALDO"   , "N" , 17, 2},;
			   {"ENTRAC"  , "N" , 17, 2},;
			   {"SAIDAC"  , "N" , 17, 2},;
			   {"SALDOAC" , "N" , 17, 2},;
			   {"VARIACAO", "N" ,  9, 2},;
			   {"VARIACAC", "N" ,  9, 2},;
			   {"FLAG"    , "L" , 1, 0 }}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lConsFil
   cFilDe  := xFilial(cAlias)
	cFilAte := xFilial(cAlias)
Endif	
#IFDEF TOP
	If TcSrvType() != "AS/400"
		aStru     := (cAlias)->(dbStruct())
		cAbatim   := FormatIn(cAbatim,"/")
		cAliasTrb := "NSFINC021"
		cQuery := ""
		aEval(aStru,{|x| cQuery += ","+AllTrim(x[1])})
        /*Alteração para pegar apartir da movimentações bancárias */
		cQuery:=" SELECT  "
		cQuery+=" E5_BANCO AS "+cCampo+"_PORTADOR,  "
		cQuery+=" E5_AGENCIA AS "+cCampo+"_AGEDEP, "
		cQuery+=" E5_CONTA   AS "+cCampo+"_CONTA, "
		cQuery+=" E5_DATA    AS "+cCampo+"_EMISSAO, "
		cQuery+=" E5_DATA    AS "+cCampo+"_BAIXA, "
		cQuery+=" E5_PREFIXO AS "+cCampo+"_PREFIXO," 
		cQuery+=" E5_HISTOR  AS HISTOR, "
//		cQuery+=" E5_NUMERO  AS "+cCampo+"_NUM,"

        cQuery+=" CASE WHEN (E5_TIPODOC='ES' AND substring(Ltrim(E5_KEY),1,1)<>' ') OR E5_TIPO='PA'  THEN SUBSTRING(E5_KEY,4,9) Else E5_NUMERO End AS "+cCampo+"_NUM," 

		cQuery+=" E5_PARCELA AS "+cCampo+"_PARCELA,"
//		cQuery+=" E5_TIPO    AS "+cCampo+"_TIPO,"

//        cQuery+=" CASE WHEN (E5_TIPODOC='ES' AND substring(Ltrim(E5_KEY),1,1)<>' ') OR E5_TIPODOC='PA'  THEN E5_TIPODOC Else E5_TIPO End AS  "+cCampo+"_TIPO,"

        cQuery+="E5_TIPO AS "+cCampo+"_TIPO," 

		cQuery+=" E5_SITUACA AS "+cCampo+"_SITUACA,"
		cQuery+=" E5_NATUREZ  AS "+cCampo+"_NATUREZ,"   
		cQuery+=" E5_DATA     AS "+cCampo+"_VENCTO, "
        If cAlias == "SE1"
			cQuery+=" E5_CLIFOR  AS "+cCampo+"_CLIENTE,"
		Else 	
			cQuery+=" E5_CLIFOR  AS "+cCampo+"_FORNECE,"
		
		EndIF	
		cQuery+=" E5_FILIAL   AS "+cCampo+"_FILIAL,"
		cQuery+=" E5_DATA    AS "+cCampo+"_VENCREA,"
		cQuery+=" E5_LOJA    AS "+cCampo+"_LOJA,"
		cQuery+=" E5_VALOR   AS	"+cCampo+"_SALDO," 
        cQuery+=" CASE WHEN (E5_TIPODOC='ES' AND substring(Ltrim(E5_KEY),1,1)<>' ') OR E5_TIPO<>'ES'  THEN E5_VALOR Else 0 End as "+cCampo+"_SALDO,"  
      
//        cQuery+=" case (E5_TIPO='ES' AND substring(Ltrim(E5_KEY),1,1)) OR E5_TIPO<>'ES' THEN E5_VALOR ELSE 0 END AS	"+cCampo+"_SALDO," 
		cQuery+=" 0          AS	"+cCampo+"_SDACRES,"
		cQuery+=" E5_MOEDA   AS "+cCampo+"_MOEDA,"
		cQuery+=" E5_TXMOEDA  AS "+cCampo+"_TXMOEDA,  "
		cQuery+=" 0  	   AS "+cCampo+"_SDDECRE ,  "
//        cQuery+=" SE5010.R_E_C_N_O_ TITRECNO  "
        cQuery+=" 0 TITRECNO  "
        cQuery+=" from SE5010 "
        cQuery+=" WHERE E5_DATA<='"+Dtos(DFim)+"' AND D_E_L_E_T_='' AND  "
        cQuery+=" E5_DATA>='"+Dtos(dIniData)+"'  "	
		If cAlias == "SE1"

			cQuery+=" AND E5_RECPAG='R' "
		Else 	                         
			cQuery+=" AND E5_RECPAG='P' "
		EndIf        
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTrb,.T.,.T.)
		aEval(aStru, {|e| If(e[2]!= "C", TCSetField(cAliasTrb, e[1], e[2],e[3],e[4]),Nil)})
	Else	
#ENDIF	
		cFiltro := cCampo + "_FILIAL>='"+cFilDe+"'.And."
		cFiltro += cCampo + "_FILIAL<='"+cFilAte+"'.And."
		cFiltro += "Dtos(" + cCampo + "_VENCREA)<='"+Dtos(DFim)+"'.And."
		cFiltro += "Dtos(" + cCampo + "_VENCREA)>='"+Dtos(dIniData)+"'.And."
		// Nao considerar titulos emitidos apos a data base, para compatiblizacao
		// com FINR140.
		If cAlias == "SE1"
			If !lTitFuturo  //Nao considerar titulos com emissao posterior a database
				cFiltro += "(DTOS(E1_EMISSAO) <= '"+Dtos(dIniData) +"' .Or. E1_TIPO $ '" + MVRECANT+"').And."
			Endif
		Else
			If !lTitFuturo  //Nao considerar titulos com emissao posterior a database
				cFiltro += "(DTOS(E2_EMIS1) <= '"+Dtos(dIniData) +"' .Or. E2_TIPO $ '" + MVPAGANT+"').And."
			Endif	
		Endif	
		If !lConsDtBase
			cFiltro += cCampo + "_SALDO>0.And."
		Endif	
		cFiltro += cCampo + "_FLUXO<>'N'"
	
		dbSelectArea(cAlias)
		dbSetOrder(nOrdem)
		cIndTmp := CriaTrab(,.F.)
		IndRegua(cAlias,cIndTmp,IndexKey(),,cFiltro)
		dbGotop()
		cAliasTrb := cAlias
#IFDEF TOP
	Endif
#ENDIF
While (cAliasTrb)->(!Eof()) //IndRegua
	IncProc(STR0055 + If(cAlias=="SE1", STR0056, STR0057)) //"Processando titulos a "###"Receber"###"Pagar"
	dDataTrab := (cAliasTrb)->&(cCampo+"_VENCREA")
	// Considera a retencao bancaria, caso o titulo esteja em banco
	If cAlias == "SE1" .And. !((cAliasTrb)->E1_SITUACA $ "0FG")

		dDataVcOri := (cAliasTrb)->&(cCampo+"_VENCTO")

		//Verifico se o proximo dia util apos o vencimento eh igual ao vencto real do titulo
		//Se for igual e o titulo estiver em cobranca, aplico os dias de retencao do banco
		//Se for diferente e o titulo estiver em cobranca, quer dizer que ja foram aplicados os dias de retencao
		//logo nao aplico novamente.
		If DTOS(DataValida(dDataVcOri)) == DTOS(dDataTrab)
			SA6->(MsSeek(xFilial("SA6")+(cAliasTrb)->(E1_PORTADO+E1_AGEDEP+E1_CONTA)))
			For nX := 1 To SA6->A6_RETENCA
				dDataTrab := DataValida(dDataTrab+1,.T.)
			Next
		Endif
	Endif	
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se a data de vencto. nao ultrapassar a ultima data da consulta ³
	//³ e nao for um adiantamento                                      |  
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If dDataTrab <= DFim .And.;
		(!(cAliasTrb)->&(cCampo+"_TIPO") $ MVRECANT+IIf(!cPaisLoc $"ARG|CHI",MVPAGANT,"") .OR. ;
		 ((cAliasTrb)->&(cCampo+"_TIPO") $ MVRECANT+IIf(!cPaisLoc $"ARG|CHI",MVPAGANT,"") .And. ;
		 (cAliasTrb)->&(cCampo+"_EMISSAO")>dDataBase)) // Se for um adiantamento, considera se for emissao futura, 
																       // pois ele ainda nao estara no saldo bancario
		#IFDEF TOP
			// Posiciona SE1 ou SE2 se for TOP e nao AS400, pois o filtro de usuario e
			// feito sobre o arquivo original.
			If TcSrvType() != "AS/400"
				DbSelectArea(cAlias)
				MsGoto((cAliasTrb)->TITRECNO)
			Endif
		#ENDIF
		DbSelectArea(cAlias)
		If lFc021Fil
			cFilterUser := ExecBlock("FC021FIL", .F., .F., {cAlias} )
		Endif
		// Se nao existir filtro de usuario, ou se o filtro retornar uma expressao
		// valida para o registro atual do titulo, entao processsa o registro.
		
		//dIniData
		If Empty(cFilterUser) .Or. (&cFilterUser)
			If (cAliasTrb)->&(cCampo+"_BAIXA") > dDataBase .And. lConsDtBase 
				nSaldoTit := SaldoTit(	(cAliasTrb)->&(cCampo+"_PREFIXO"),;
												(cAliasTrb)->&(cCampo+"_NUM"),;
												(cAliasTrb)->&(cCampo+"_PARCELA"),;
												(cAliasTrb)->&(cCampo+"_TIPO"),;
												(cAliasTrb)->&(cCampo+"_NATUREZA"),;
												If(cAlias="SE1","R","P"),;
												(cAliasTrb)->&(cCampo+IF(cAlias="SE1","_CLIENTE","_FORNECE")),;
												nMoeda,(cAliasTrb)->&(cCampo+"_VENCREA"),;
												dDataBase,(cAliasTrb)->&(cCampo+"_LOJA"),,If(cPaisLoc=="BRA",(cAliasTrb)->&(cCampo+"_TXMOEDA"),0))
			Else
				// Verifica se existe a taxa na data do vencimento do titulo, se nao existir, utiliza a taxa da database
				lTxMoeda := SM2->(MsSeek(DataValida(dDataTrab,.T.))) .And. SM2->&("M2_MOEDA"+Alltrim(Str(nMoeda))) != 0
				nSaldoTit := xMoeda((cAliasTrb)->&(cCampo+"_SALDO")		+;
									   (cAliasTrb)->&(cCampo+"_SDACRES")	-;
							 	   	(cAliasTrb)->&(cCampo+"_SDDECRE")  ,;
									   (cAliasTrb)->&(cCampo+"_MOEDA")		,;
									  nMoeda                            	,;
							    	  If(lTxMoeda,DataValida(dDataTrab,.T.),dIniData),,If(cPaisLoc=="BRA",(cAliasTrb)->&(cCampo+"_TXMOEDA"),0))
			EndIf							    	  
			If cAlias == "SE1"
				nDesconto := FaDescFin(cAliasTrb,dDataBase,nSaldoTit,1)
				nSaldoTit -= nDesconto
			Endif
			If Abs(nSaldoTit) > 0.0001
				// Verifica a situacao, somente se nao for Contas a Receber.
				If cAlias == "SE2" .Or.;
					((cAliasTrb)->e1_situaca != "2" .And. (cAliasTrb)->e1_situaca != "7")
					// Pesquisa a data na matriz com os dados a serem exibidos na tela do fluxo
					nCiclos	:=	1
					nAscan := TemFluxoData(dDataTrab,aFluxo)
					If (cAliasTrb)->&(cCampo+"_TIPO") $ cAbatim+MVRECANT+MVPAGANT // .Or. (cAlias == "SE2" .And. (cAliasTrb)->E2_TIPO  $ MVRECANT+MVPAGANT )
						aFluxo[nAscan][nCampSin] -= nSaldoTit
					Else
						aFluxo[nAscan][nCampSin] += nSaldoTit
					EndIf
					//Movimento Bancario gerado pelo PA (na data de emissao do PA)
					If cAlias == "SE2" .And. (cAliasTrb)->E2_TIPO  == MVPAGANT .And.;
						(cAliasTrb)->E2_EMISSAO >= dDataBase .And. (!cPaisLoc $"ARG|CHI" .And. Empty(E2_ORDPAGO))
						nAscanPA := TemFluxoData((cAliasTrb)->E2_EMISSAO,aFluxo)   
						aFluxo[nAscanPA][nCampSin] += nSaldoTit
						nCiclos	:=	If(SuperGetMv("MV_PAFUTFL",.T.,.T.), 2, 1)
					Endif
					If lAnalitico // Analitico
						For nX := 1 To nCiclos
							cCliFor := (cAliasTrb)->&(cCampo+If(Upper(cAlias)=="SE1","_CLIENTE","_FORNECE"))
							// Posiciona no cliente ou fornecedor para buscar o nome
							DbSelectArea(StrTran(cAlias,"E","A"))
							DbSetOrder(1)
							MsSeek(xFilial(StrTran(cAlias,"E","A"))+cCliFor+(cAliasTrb)->&(cCampo+"_LOJA"))
							DbSelectArea(cAliasTrb)
							RecLock(cAliasAna,.T.)
							If nX == 1		
								nAscan := Ascan(aPeriodo, {|e| e[1] == dDataTrab})
								(cAliasAna)->DataX   := dDataTrab
								(cAliasAna)->Periodo := aPeriodo[nAscan][2]
							Else
								nAscan := Ascan(aPeriodo, {|e| e[1] == (cAliasTrb)->E2_EMISSAO})
								(cAliasAna)->DataX   := (cAliasTrb)->E2_EMISSAO
								(cAliasAna)->Periodo := aPeriodo[nAscanPA][2]
							Endif
							(cAliasAna)->FILIAL	 := (cAliasTrb)->&(cCampo+"_FILIAL")
							(cAliasAna)->PREFIXO := (cAliasTrb)->&(cCampo+"_PREFIXO")
							(cAliasAna)->NUM     := (cAliasTrb)->&(cCampo+"_NUM")
							(cAliasAna)->PARCELA := (cAliasTrb)->&(cCampo+"_PARCELA")
							(cAliasAna)->TIPO    := (cAliasTrb)->&(cCampo+"_TIPO")
							(cAliasAna)->HISTORICO := (cAliasTrb)->HISTOR
							(cAliasAna)->CLIFOR  := cCliFor
							cAliasCF := StrTran(cAlias,"E","A")
							// Se o cadastro de clientes/fornecedores estiver compartilhado,
							// obtem o nome do clientes/fornecedor do cadastro
							If Empty(xFilial(cAliasCF))
								(cAliasAna)->NOMCLIFOR := (cAliasCF)->&(Right(cAliasCF,2)+"_NOME")
							Else
								(cAliasAna)->NOMCLIFOR := If(cAlias=="SE1", SE1->E1_NOMCLI, SE2->E2_NOMFOR)
							Endif	
							(cAliasAna)->LOJA    := (cAliasTrb)->&(cCampo+"_LOJA")
							cIdentific :=	(cAliasTrb)->&(cCampo+"_FILIAL")+;
												(cAliasTrb)->&(cCampo+"_PREFIXO") +;
												(cAliasTrb)->&(cCampo+"_NUM")     +;
												(cAliasTrb)->&(cCampo+"_PARCELA") +;
												(cAliasTrb)->&(cCampo+"_TIPO")    +;
												(cAliasTrb)->&(cCampo+If(Upper(cAlias)=="SE1","_CLIENTE","_FORNECE"))+;
												(cAliasTrb)->&(cCampo+"_LOJA")
							(cAliasAna)->Chave      := cIdentific
							(cAliasAna)->Apelido    := cAlias  
							
							If (cAliasTrb)->&(cCampo+"_TIPO") $ MVRECANT+MVPAGANT .And. nX == 1		.And. SuperGetMv("MV_PAFUTFL",.T.,.T.)
								(cAliasAna)->SALDO      := nSaldoTit * -1 
							Else
								(cAliasAna)->SALDO      := nSaldoTit 
							Endif	
								
	
							If cAlias == "SE1"
								nAscan := Ascan( aSx3Box, { |e| e[2] = (cAlias)->E1_SITUACA } )
								If nAscan > 0
									(cAliasAna)->Situacao  := AllTrim( aSx3Box[nAscan][3] )	// Descricao da situacao.
								Endif	
								(cAliasAna)->PORTADO	:= (cAliasTrb)->&(cCampo+"_PORTADO")
								(cAliasAna)->AGEDEP	 	:= (cAliasTrb)->&(cCampo+"_AGEDEP")
								(cAliasAna)->CONTA    	:= (cAliasTrb)->&(cCampo+"_CONTA")								
							Endif
	
							MsUnlock()
							//Ponto de entrada para atualizar o valor dos novos campos inclusos no arquivo tmp 							
							If ExistBlock("FC021ATRB")
								ExecBlock("FC021ATRB",.F.,.F.,{cAliasAna,cAliasTrb,cCampo})
							EndIf								
							// Pesquisa na matriz de totais, os totais de contas a pagar ou a receber
							// da data de trabalho.
							nAscan := Ascan( aTotais[If(cAlias=="SE1",2,1)], {|e| e[1] == (cAliasAna)->DataX})
							If nAscan == 0
								If (cAliasTrb)->&(cCampo+"_TIPO") $ cAbatim 
									Aadd( aTotais[If(cAlias=="SE1",2,1)], {(cAliasAna)->DataX,(cAliasAna)->SALDO*-1})
								Else
									Aadd( aTotais[If(cAlias=="SE1",2,1)], {(cAliasAna)->DataX,(cAliasAna)->SALDO})
								Endif						
							Else	
								If (cAliasTrb)->&(cCampo+"_TIPO") $ cAbatim 
									aTotais[If(cAlias=="SE1",2,1)][nAscan][2] -= (cAliasAna)->SALDO // Contabiliza os totais de titulos 
								Else
									aTotais[If(cAlias=="SE1",2,1)][nAscan][2] += (cAliasAna)->SALDO // Contabiliza os totais de titulos 
								EndIf
							Endif	
						Next
					Endif	
				EndIf
			EndIf
		Endif	
	Endif
	DbSelectArea(cAliasTrb)
	(cAliasTrb)->(dbSkip())
Enddo
#IFDEF TOP
	If TcSrvType() != "AS/400"
		dbSelectArea(cAliasTrb)
		dbCloseArea()
		dbSelectArea(cAlias)
	Else
#ENDIF
		dbSelectArea(cAlias)
		dbClearFil()
		RetIndex(cAlias)
		If !Empty(cIndTmp)
			FErase (cIndTmp+OrdBagExt())
		Endif
		dbSetOrder(1)
#IFDEF TOP
	Endif
#ENDIF		
    

Return { cArqAnaP, cAliasAnaP, cArqAnaR, cAliasAnaR }


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³CalcSaldo ºAutor  ³Claudio D. de Souza º Data ³  30/08/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calcular o saldo no arquivo temporario                      º±±
±±º          ³Parametros:                                                 º±±
±±º          ³aFluxo      -> Matriz contendo os dados do fluxo            º±±
±±º          ³nBancos     -> Saldo em bancos                              º±±
±±º          ³nCaixas     -> Saldo em caixas                              º±±
±±º          ³nAtrReceber -> Valor dos titulos atrasados a Receber        º±±
±±º          ³nAtrPagar   -> Valor dos titulos atrasados a Pagar          º±±
±±º          ³Retorno:                                                    º±±
±±º          ³Nenhum                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Finc021                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CalcSaldo(aFluxo, nBancos, nCaixas, nAtrReceber, nAtrPagar,nLimCred)
Local nEntrAnt  := 0,;
	  nSaidAnt  := 0,;
	  aArea     := GetArea()
Local nX := 0
		
// Calcula o saldo inicial
aFluxo[1][SALDOACUMULADO] := (nBancos + nCaixas + nLimCred + nAtrReceber - nAtrPagar)
nSaldoAc := aFluxo[1][SALDOACUMULADO]
ProcRegua(Len(aFluxo))
For nX := 1 to Len(aFluxo)

	IncProc(STR0058)  //"Calculando saldos"
	// Calcula o saldo da data
	// Inclusão feita pela Aglair para ajustar as entrada ABI 1.000.000.000*/
    /*******************************************************************/
    
    
	aFluxo[nX][SALDODIA] := aFluxo[nX][ENTRADAS]-aFluxo[nX][SAIDAS]
	// Inclusão feita pela Aglair para ajustar as entrada ABI
	// Calcula a variacao do dia
	aFluxo[nX][VARIACAODIA] := (aFluxo[nX][SAIDAS]/aFluxo[nX][ENTRADAS]) * 100
	
	// Calcula os creditos acumulados ate a data
	aFluxo[nX][ENTRADASACUMULADAS] := (nEntrAnt + aFluxo[nX][ENTRADAS])
	nEntrAnt := aFluxo[nX][ENTRADASACUMULADAS]
	
	// Calcula os debitos acumulados ate a data
	aFluxo[nX][SAIDASACUMULADAS] := (nSaidAnt + aFluxo[nX][SAIDAS])
	nSaidAnt := aFluxo[nX][SAIDASACUMULADAS]
	
	// Calcula o saldo acumulado ate a data
	aFluxo[nX][SALDOACUMULADO] := (aFluxo[nX][ENTRADAS]-aFluxo[nX][SAIDAS])+nSaldoAc
	nSaldoAc := aFluxo[nX][SALDOACUMULADO]
	
	// Calcula a variacao acumulada
	aFluxo[nX][VARIACAOACUMULADA] := (aFluxo[nX][SAIDASACUMULADAS]/aFluxo[nX][ENTRADASACUMULADAS])*100

	// Inclusão feita pela Aglair para ajustar as entrada ABI 1.000.000.000*/
    aFluxo[nX][SAIDASACUMULADAS]:= aFluxo[nX][SAIDASACUMULADAS]
	aFluxo[nX][ENTRADASACUMULADAS]:=aFluxo[nX][ENTRADASACUMULADAS]
    /*******************************************************************/
    aFluxo[nX][SALDOACUMULADO] := aFluxo[nX][SALDOACUMULADO]/1000000
		
Next

RestArea(aArea)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Consolida ºAutor  ³Claudio D. de Souza º Data ³  15/10/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calcular o saldo no arquivo temporario                      º±±
±±º          ³Parametros:                                                 º±±
±±º          ³aArray      -> Matriz contendo os dados do fluxo            º±±
±±º          ³cPeriodos   -> Codigos dos periodos								  º±±
±±º          ³07 - Semanal                                                º±±
±±º          ³10 - Decendial                                              º±±
±±º          ³15 - Quinzenal                                              º±±
±±º          ³30 - Mensal                                                 º±±
±±º          ³Retorno:                                                    º±±
±±º          ³Nenhum                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Finc021                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Consolida(aArray,aTotais,cPeriodos)
Local nX,;
		nY,;
		nZ,;
		nPeriodo := Val(Left(cPeriodos,2)),;
		nResto		  	,;
		aCopia := {}	,;
		nEntradas := 0	,;
		nSaidas	 := 0	,;
		nSoma     := 0	,;
		dDataTrab		,;
		cPer           ,;
		aCopiaTot := {}

If nPeriodo != 1		
	aEval(aTotais, {|e|Aadd(aCopiaTot, {})}) // Inicializa aCopiaTot com Array em todos os elementos
Else
	// Transforma a Data para Caracter pois assim sera usada nas rotinas sequintes
	aEval(aArray, {|e| e[DATAFLUXO] := Dtoc(e[DATAFLUXO])})
	For nX := 1 To Len(aTotais)
		For nY := 1 To Len(aTotais[nX])
			aTotais[nX][nY][1] := Dtoc(aTotais[nX][nY][1])
		Next
	Next
Endif	
If nPeriodo != 1
	For nX := 1 TO Len(aArray)
		dDataTrab := aArray[nX][DATAFLUXO]
		Do Case
		Case nPeriodo == 7  // Semanal
			// Verifica quantos dias faltam para a proxima semana
			nResto := 6
			If Dow(dDataTrab) != 1
				nResto := 7-Dow(dDataTrab)
			EndIf
		Case nPeriodo == 10 // Decendial
			nResto := 9
			// Verifica quantos dias faltam para o proximo decendio
			If Day(dDataTrab) < 10
				nResto := 10-Day(dDataTrab)
			ElseIf Day(dDataTrab) > 10 .And. Day(dDataTrab) < 20
				nResto := 20-Day(dDataTrab)
			ElseIf Day(dDataTrab) > 20
				nResto := LastDay(dDataTrab)-dDataTrab // Processa até o ultimo dia do mes
			Endif
		Case nPeriodo == 15 // Quinzenal
			nResto := 14
			// Verifica quantos dias faltam para a proxima quinzena
			If Day(dDataTrab) < 15
				nResto := 15-Day(dDataTrab)
			Else	
				nResto := LastDay(dDataTrab)-dDataTrab // Processa até o ultimo dia do mes
			Endif
		Case nPeriodo == 30 // Mensal
			// Verifica quantos dias faltam para o proximo mes
			nResto := LastDay(dDataTrab)-dDataTrab
		EndCase
		For nY := nX To (nResto+nX)
			If nY > Len(aArray)
				Exit
			Endif
			nEntradas += aArray[nY][ENTRADAS]
			nSaidas 	 += aArray[nY][SAIDAS]
		Next
		nX := (nY-1)
		If nPeriodo != 1
			cPer := Dtoc(dDataTrab) + STR0182 + Dtoc(aArray[nX][DATAFLUXO]) //" a "
		Endif	
		Aadd(aCopia, {cPer,nEntradas, nSaidas,0,0,0,0,0,0})
		// Consolida aTotais
		For nY := 1 To Len(aTotais)
			For nZ := 1 to Len(aTotais[nY])
				// Se os totais tiverem dentro das datas do periodo, acumula os valores
				If aTotais[nY][nZ][1] >= dDataTrab .And. aTotais[nY][nZ][1] <= aArray[nX][DATAFLUXO]
					nSoma += aTotais[nY][nZ][2]
				ElseIf aTotais[nY][nZ][1] > aArray[nX][DATAFLUXO]
					// Senao forca a saida por nao ser amis necessario processar, para nao
					// perder tempo.
					Exit
				Endif
			Next
			If nSoma > 0
				Aadd(aCopiaTot[nY], {cPer, nSoma})
			Endif	
			nSoma := 0
		Next
		nEntradas := nSaidas := 0
	Next
	aArray  := aClone(aCopia)
	aTotais := aClone(aCopiaTot)
Endif
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³MontaPerioºAutor  ³Claudio D. de Souza º Data ³  18/10/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Montar os periodos na matriz de periodos para ser utilizada º±±
±±º          ³na simulacao e na projecao do fluxo								  º±±
±±º          ³Parametros:                                                 º±±
±±º          ³aArray      -> Matriz contendo as datas do periodo          º±±
±±º          ³cPeriodos   -> Codigos dos periodos								  º±±
±±º          ³07 - Semanal                                                º±±
±±º          ³10 - Decendial                                              º±±
±±º          ³15 - Quinzenal                                              º±±
±±º          ³30 - Mensal                                                 º±±
±±º          ³Retorno:                                                    º±±
±±º          ³Nenhum                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Finc021                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MontaPeriodo(aArray,cPeriodos)
Local nX,;
		nY,;
		nInicio := 0,;
		nFim,;
		nPeriodo := Val(Left(cPeriodos,2)),;
		nResto		  	,;
		aCopia := {}	,;
		dDataTrab		,;
		cPer           
		
For nX := 1 TO Len(aArray)
	dDataTrab := aArray[nX][DATAFLUXO]
	Do Case
	Case nPeriodo == 1  // Diario
		nResto := 0
		cPer := Dtoc(dDataTrab)
	Case nPeriodo == 7  // Semanal
		// Verifica quantos dias faltam para a proxima semana
		nResto := 6
		If Dow(dDataTrab) != 1
			nResto := 7-Dow(dDataTrab)
		EndIf
	Case nPeriodo == 10 // Decendial
		nResto := 9
		// Verifica quantos dias faltam para o proximo decendio
		If Day(dDataTrab) < 10
			nResto := 10-Day(dDataTrab)
		ElseIf Day(dDataTrab) > 10 .And. Day(dDataTrab) < 20
			nResto := 20-Day(dDataTrab)
		ElseIf Day(dDataTrab) > 20
			nResto := LastDay(dDataTrab)-dDataTrab // Processa até o ultimo dia do mes
		Endif
	Case nPeriodo == 15 // Quinzenal
		nResto := 14
		// Verifica quantos dias faltam para a proxima quinzena
		If Day(dDataTrab) < 15
			nResto := 15-Day(dDataTrab)
		Else	
			nResto := LastDay(dDataTrab)-dDataTrab // Processa até o ultimo dia do mes
		Endif
	Case nPeriodo == 30 // Mensal
		// Verifica quantos dias faltam para o proximo mes
		nResto := LastDay(dDataTrab)-dDataTrab
	EndCase
	nInicio := nX
	nFim    := (nResto+nX)
	nFim    := If(nFim <= Len(aArray),nFim,Len(aArray))
	nX 	  := nFim
	If nPeriodo != 1
		cPer := Dtoc(dDataTrab)+ STR0182 + Dtoc(aArray[nX][DATAFLUXO]) //" a "
	Endif	
	For nY := nInicio To nFim
		If aArray[nY][1] <= aArray[nX][DATAFLUXO]
			Aadd(aCopia,{aArray[nY][1],cPer})
		Else
			Exit	
		Endif
	Next
Next
aArray  := aClone(aCopia)
Return		

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GetMoedas ºAutor  ³Claudio D. de Souza º Data ³  30/08/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Obter as moedas utilizadas pelo sistema                    º±±
±±º          ³ Parametros:                                                º±±
±±º          ³ Nenhum                                                     º±±
±±º          ³ Retorno:                                                   º±±
±±º          ³ aRet[n] = Codigo da moeda + Descricao                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Finc021                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetMoedas
Local aRet     := {}       ,;
		aArea    := GetArea(),;
		aAreaSx6 := Sx6->(GetArea()),;
		cFilSx6

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa array com as moedas existentes.						  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GetMv("MV_MOEDA1")
cFilSx6 := SX6->X6_FIL
While Substr(SX6->X6_VAR,1,8) == "MV_MOEDA" .And. ;
		SX6->(!Eof()) .And. SX6->X6_FIL == cFilSx6
	If Substr(SX6->X6_VAR,9,1) != "P" .And. Substr(SX6->X6_VAR,9,2) != "CM" // Desconsiderar plural e MV_MOEDACM
		Aadd( aRet, StrZero(Val(Substr(SX6->X6_VAR,9,2)),2) + " " + GetMv(SX6->X6_VAR) )
	Endif
	SX6->(DbSkip())
EndDo

Sx6->(RestArea(aAreaSx6))
RestArea(aArea)

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GetBancos ºAutor  ³Claudio D. de Souza º Data ³  30/08/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Obter os bancos do SA6                                     º±±
±±º          ³ Parametros:                                                º±±
±±º          ³ lConsFil    -> Considera filiais                           º±±
±±º          ³ nMoeda      -> Codigo da moeda                             º±±
±±º          ³ Retorno:                                                   º±±
±±º          ³ aRet[n] = .F.,Banco,Agencia,Conta,Nome,Saldo               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Finc021                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetBancos( lConsFil, nMoeda, cFilDe, cFilAte, cTipoSaldo, lRecalcula, aBancos )
Local aRet     := {},;
		aArea    := GetArea(),;
		aAreaSa6 := Sa6->(GetArea()),;
		aAreaSe8 := Se8->(GetArea()),;
		cTrbBanco                   ,;
		cTrbAgencia                 ,;
		cTrbConta                   ,;
		cTrbNome                    ,;
		dTrbData                    ,;
		nTrbSaldo                   ,;
		lSldBco    := .F.           ,;
		cIndSE8  := ""					 ,;
		cSavFil  := cFilAnt			 ,;
		aAreaSm0 :=	SM0->(GetArea()),;
		nAscan							,;
		nSalReco := 0

Local nMoedaBco 

If aBancos != Nil
	aRet := aClone(aBancos)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lConsFil
   cFilDe  := cFilAnt
	cFilAte := cFilAnt
Endif


dbSelectArea("SM0")
dbSeek(cEmpAnt+cFilDe,.T.)

While !Eof() .and. M0_CODIGO == cEmpAnt .and. M0_CODFIL <= cFilAte
	cFilAnt := SM0->M0_CODFIL

	DbSelectArea("SA6")
	MsSeek( xFilial("SA6") )
	
	While SA6->(!Eof()) .And. A6_FILIAL == xFilial("SA6")
		If SA6->A6_FLUXCAI $ "S "
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica banco a banco a disponibilidade imediata				  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SE8")
			cTrbBanco  := SA6->A6_COD
			cTrbAgencia:= SA6->A6_AGENCIA
			cTrbConta  := SA6->A6_NUMCON
			cTrbNome   := SA6->A6_NREDUZ
			nMoedaBco  := If( cPaisLoc="BRA",1,Max(SA6->A6_MOEDA,1))
			lSldBco    := .F.
			nRecSE8 := SE8->(RECNO())
//			If ! MsSeek(xFilial("SE8")+SA6->(A6_COD+A6_AGENCIA+A6_NUMCON+DTOS(dDataBase)),.T.) Alterado para pegar o saldo retroativo Aglair 18/05/2010
			DtIni:=DatIni-1
			If ! MsSeek(xFilial("SE8")+SA6->(A6_COD+A6_AGENCIA+A6_NUMCON+DTOS(DtIni)),.T.)
				dbSkip(-1)
				dTrbData := SE8->E8_DTSALAT
				While !Bof() 										.And.;
						SA6->(A6_COD+A6_AGENCIA+A6_NUMCON) ==	;
						SE8->(E8_BANCO+E8_AGENCIA+E8_CONTA)	.And.;
						xFilial("SE8") == SE8->E8_FILIAL		.And.;
						SE8->E8_DTSALAT == dTrbData
					dbSkip( -1 )
					lSldBco := .T.
				End				
				If ( lSldBco )
					If SE8->(Bof())
						dbGoTo(nRecSE8)
					Else
						dbSkip()
					Endif
				EndIf
			EndIf
			While !Eof()										.And.;
					SA6->(A6_COD+A6_AGENCIA+A6_NUMCON) == ;
					SE8->(E8_BANCO+E8_AGENCIA+E8_CONTA)	.And.;
	            xFilial("SE8") == SE8->E8_FILIAL		.And.;
				SE8->E8_DTSALAT <= DtIni
//	            SE8->E8_DTSALAT <= dDataBase
	            
				If Left(cTipoSaldo,1)=="1" // Somente saldo normal
					nTrbSaldo := xMoeda(SE8->E8_SALATUA,nMoedaBco,nMoeda)
				ElseIf Left(cTipoSaldo,1)=="2" // Somente os conciliados
					nTrbSaldo := xMoeda(SE8->E8_SALRECO,nMoedaBco,nMoeda)
				Elseif Left(cTipoSaldo,1)=="3" // Nao conciliados
					nTrbSaldo := xMoeda(SE8->E8_SALATUA-SE8->E8_SALRECO,nMoedaBco,nMoeda)
				Endif	

				// Pesquisa banco+agencia+conta, para nao exibir saldos duplicados.
				nAscan := Ascan(aRet, {|e| e[2]+e[3]+e[4] == cTrbBanco+cTrbAgencia+cTrbConta})
				If nAscan > 0
					aRet[nAscan][6] := If(	lRecalcula,;
													Transform(nTrbSaldo,PesqPict("SE8","E8_SALATUA")),;
													Transform(Fc021Val(aRet[nAscan][6])+ nTrbSaldo,PesqPict("SE8","E8_SALATUA")))
					aRet[nAscan][8] := If(	lRecalcula,Transform(xMoeda(SA6->A6_LIMCRED,nMoedaBco,nMoeda),PesqPict("SE8","E8_SALATUA")),;
													Transform(Fc021Val(aRet[nAscan][8])+ xMoeda(SA6->A6_LIMCRED,nMoedaBco,nMoeda),PesqPict("SE8","E8_SALATUA")))
				Else
					Aadd(aRet,{.F.,cTrbBanco,cTrbAgencia,cTrbConta,cTrbNome,Transform(nTrbSaldo,PesqPict("SE8","E8_SALATUA")),nMoeda,Transform(xMoeda(SA6->A6_LIMCRED,nMoedaBco,nMoeda),PesqPict("SE8","E8_SALATUA"))})
				Endif	
				DbSkip()
			EndDo
		Endif
		dbSelectArea("SA6")
		dbSkip()
	End
	If Empty(xFilial("SA6")) .And.;
		Empty(xFilial("SE8"))
		Exit
	Endif
	dbSelectArea("SM0")
	dbSkip()
EndDo

cFilAnt := cSavFil
SM0->(RestArea(aAreaSM0))

If ( !Empty(cIndSE8) )
	dbSelectArea("SE8")
	RetIndex("SE8")
	dbClearFilter()	
	Ferase(cIndSE8+OrdBagExt())
EndIf

Sa6->(RestArea(aAreaSa6))
Se8->(RestArea(aAreaSe8))
RestArea(aArea)

Return aRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Bancos    ºAutor  ³Claudio D. de Souza º Data ³  30/08/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exibe os bancos para selecao dos saldos                    º±±
±±º          ³ Parametros:                                                º±±
±±º          ³ lConsFil    -> Considera filiais                           º±±
±±º          ³ nMoeda      -> Codigo da moeda                             º±±
±±º          ³ nBancos     -> Saldo em bancos (por referencia)            º±±
±±º          ³ nCaixas     -> Saldo em caixas (por referencia)            º±±
±±º          ³ Retorno:                                                   º±±
±±º          ³ aRet[n] = .F.,Banco,Agencia,Conta,Nome,Saldo               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Finc021                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Bancos( lConsFil, nMoeda, nBancos, nCaixas, cFilDe, cFilAte, cTipoSaldo, lRecalcula, aBancos, lLimCred )
Local oDlgBanc
Local oOk := LoadBitmap( GetResources(), "LBOK" )
Local oNo := LoadBitmap( GetResources(), "LBNO" )
Local cBancoCx := GetMV("MV_CARTEIR")
Local oGet01, lInverter, oGet02
Local aRet

DEFAULT lLimCred := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa array com os bancos existentes.						  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			  
// Se ainda não passou pela rotina, inicializa a matriz de bancos, senao
// exibe a matriz carregada anteriormente, pois esta funcao eh chamada em dois
// momentos: Quando o usuario marca se deseja saldos bancarios e quando seleciona o tipo
// de saldo a ser considerado. Quando selecionado o tipo de saldo, nao se deve carregar os bancos
// novamente para nao perder a marcacao efetuada enteriormente pelo usuario, apenas recalcula o saldo pelo
// novo tipo.
aRet := GetBancos(lConsFil, nMoeda, cFilDe, cFilAte, cTipoSaldo, lRecalcula, aBancos)
If Len(aRet) == 0                                                                
	IW_MSGBOX(STR0059,STR0198,"STOP") //"Nao existem saldos bancarios"
Else
	ASort(aRet,,, { |x,y| x[2]+x[3]+x[4] < y[2]+y[3]+y[4] } ) // Ordena pelo codigo do banco
		
	DEFINE MSDIALOG oDlgBanc TITLE STR0060 From 5,5 To 20,84 OF oMainWnd //"Selecione os bancos"
	@	 .8, .5 LISTBOX oBancos FIELDS HEADER "",STR0061,STR0062,STR0063,STR0064,STR0065,STR0203 FIELDSIZES 14,25,31,31,60,40,40 SIZE 270, 100 OF oDlgBanc //"Banco"###"Agencia"###"Conta"###"Nome"###"Saldo"
	@   .6,  4 CHECKBOX oGet01 VAR lInverter PROMPT STR0066 FONT oDlgBanc:oFont PIXEL OF oDlgBanc SIZE 50,9 ON CLICK (oGet01:cCaption := If( lInverter, STR0067, STR0068)+STR0069, oGet01:Refresh(), aEval(aRet, {|e| e[1] := lInverter}), oBancos:Refresh()) //"Marcar todos"###"Desmarcar"###"Marcar"###" todos"
	@   .6, 115 CHECKBOX oGet02 VAR lLimCred PROMPT STR0228 FONT oDlgBanc:oFont PIXEL OF oDlgBanc SIZE 50,9 // "Considera Limite de Crédito"

	oBancos:SetArray(aRet)
	oBancos:bLine      := {|| {If(aRet[oBancos:nAt,1],oOk,oNo),;
										    aRet[oBancos:nAt,2],;
				  						    aRet[oBancos:nAt,3],;
										    aRet[oBancos:nAt,4],;
										    aRet[oBancos:nAt,5],;
							   			 aRet[oBancos:nAt,6],;
										    aRet[oBancos:nAt,8]}}
							   
	oBancos:bLDblClick := {|| aRet[oBancos:nAt][1] := !aRet[oBancos:nAt][1], oBancos:DrawSelect()}
	DEFINE SBUTTON FROM 10, 280 TYPE 1 ACTION oDlgBanc:End() ENABLE OF oDlgBanc
	ACTIVATE MSDIALOG oDlgBanc
	
	// Calcula o saldo em Bancos/Caixas
	aEval( aRet, { |e| If( e[1], If( Left(e[2],2)=="CX" .Or. Left(e[2],3) $ cBancoCx,;
										nCaixas +=	Fc021Val(e[6]),;
									  	nBancos +=	Fc021Val(e[6])),Nil)})
Endif
	
Return aRet
                                                               
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Fc021ComisºAutor  ³Claudio D. de Souza º Data ³  30/08/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera dados no arquivo temporario, a partir do arquivo de   º±±
±±º          ³ comissoes																  º±±
±±º          ³ Parametros:                                                º±±
±±º          ³ dUltData   -> Ultima data do periodo                       º±±
±±º          ³ lConsFil   -> Considera filiais                            º±±
±±º          ³ cFilDe     -> Filial inicial                               º±±
±±º          ³ cFilAte    -> Filial final                                 º±±
±±º          ³ aFluxo     -> Matriz que contera os dados do fluxo         º±±
±±º          ³ nMoeda     -> Codigo da Moeda                              º±±
±±º          ³ lAnalitico -> Gera dados analiticos                        º±±
±±º          ³ Retorno:                                                   º±±
±±º          ³ aRet[1] =                                                  º±±
±±º          ³ cArqAnaCo -> Nome do arquivo analitico                     º±±
±±º          ³ cAliasCo  -> Alias do arquivo analitico                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Finc021                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION Fc021Comis(dUltData,lConsFil,cFilDe,cFilAte,aFluxo,nMoeda,;
									lAnalitico,aTotais,aPeriodo)
LOCAL cAliasCo  ,;
		cArqAnaCo ,;
		aCposAna  ,;
		aCposSin  ,;
		cAliasTrb ,;
		nSaldoTit ,;
		cFiltro   ,;
		dDataTrab ,;
		cIndTmp	 ,;
		nAscan
		
#IFDEF TOP
	Local	cQuery
	Local	aStru
#ENDIF

// Analitico
If lAnalitico
	aCposAna := {}
	Aadd( aCposAna, { "Periodo" , "C",  20, 0 } )
	Aadd( aCposAna, { "DATAX"   , "D", 08, 0} )
	Aadd( aCposAna, { "FILIAL"  , "C", TamSx3("E3_FILIAL")[1], 0 } )
	Aadd( aCposAna, { "PREFIXO" , "C", TamSx3("E3_PREFIXO")[1], 0 } )
	Aadd( aCposAna, { "NUMERO"  , "C", TamSx3("E3_NUM")[1], 0 } )
	Aadd( aCposAna, { "PARCELA" , "C", TamSx3("E3_PARCELA")[1], 0 } )
	Aadd( aCposAna, { "VEND"    , "C", TamSx3("E3_VEND")[1], 0 } )
	Aadd( aCposAna, { "NOMEVEND", "C", TamSx3("A3_NOME")[1], 0 } )
	Aadd( aCposAna, { "SALDO"   , "N", Max(TamSx3("E1_SALDO")[1]  ,;
					 					             TamSx3("E2_SALDO")[1]) , TamSx3("E1_SALDO")[2] } )
	Aadd( aCposAna, { "CHAVE"   , "C", 40, 0 } )
	Aadd( aCposAna, { "Apelido" , "C", 10, 0 } )
		
	cAliasCo := "cArqAnaCo"  // Alias do arquivo analitico
			
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera arquivo de Trabalho      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cArqAnaCo := CriaTrab(aCposAna,.T.) // Nome do arquivo temporario
	dbUseArea(.T.,__LocalDriver,cArqAnaCo,cAliasCo,.F.)
   IndRegua ( cAliasCo,cArqAnaCo,"Dtos(DataX)",,,STR0054)  //"Selecionando Registros..." //"Selecionando Registros..."
Endif		

aCposSin:={{"DATAX"   , "D" , 08, 0},;
		    	{"ENTR"    , "N" , 17, 2},;
			 	{"SAID"    , "N" , 17, 2},;
			 	{"SALDO"   , "N" , 17, 2},;
			 	{"ENTRAC"  , "N" , 17, 2},;
			 	{"SAIDAC"  , "N" , 17, 2},;
			 	{"SALDOAC" , "N" , 17, 2},;
			 	{"VARIACAO", "N" ,  9, 2},;
			 	{"VARIACAC", "N" ,  9, 2},;
			 	{"FLAG"    , "L" ,  1, 0 }}
			 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lConsFil
   cFilDe  := xFilial("SE3")
   cFilAte := xFilial("SE3")
Endif

#IFDEF TOP
	If TcSrvType() != "AS/400" 
		aStru     := SE3->(dbStruct())
		cAliasTrb := "NSFINC021"
	
		cQuery := "SELECT * "
		cQuery += "FROM "+RetSqlName("SE3")+ " SE3 "
		cQuery += "WHERE "
		cQuery += "SE3.E3_FILIAL>='"+cFilDe+"' AND "
		cQuery += "SE3.E3_FILIAL<='"+cFilAte+"' AND "
		cQuery += "SE3.E3_VENCTO >= '"+Dtos(dDataBase)+"' AND "
		cQuery += "SE3.E3_VENCTO <= '"+Dtos(dUltData)+"' AND "
		cQuery += "SE3.E3_DATA = ' ' AND "
		cQuery += "SE3.D_E_L_E_T_=' ' "
	
		cQuery := ChangeQuery(cQuery)
	
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTrb,.T.,.T.)
		aEval(aStru, {|e| If(e[2]!= "C", TCSetField(cAliasTrb, e[1], e[2],e[3],e[4]),Nil)})
	Else	
#ENDIF
		cFiltro := "E3_FILIAL>='"+cFilDe+"'.And."
		cFiltro += "E3_FILIAL<='"+cFilAte+"'.And."
		cFiltro += "Dtos(E3_VENCTO)>='"+Dtos(dDataBase)+"'.And."
		cFiltro += "Dtos(E3_VENCTO)<='"+Dtos(dUltData)+"'.And."
		cFiltro += "Dtos(E3_DATA)='"+Dtos(Ctod(""))+"'"
	
		dbSelectArea("SE3")
		cIndTmp := CriaTrab(,.F.)
		IndRegua("SE3",cIndTmp,IndexKey(),,cFiltro)
		dbGotop()
		cAliasTrb := "SE3"
#IFDEF TOP
	Endif
#ENDIF
While (cAliasTrb)->(!Eof()) //IndRegua
	IncProc(STR0087) //"Processando Comissäes"
	dDataTrab := DataValida((cAliasTrb)->E3_VENCTO,.T.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se a data de vencto. nao ultrapassar a ultima data do relatorio³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If dDataTrab <= dUltData
		nSaldoTit := xMoeda((cAliasTrb)->E3_COMIS,1,nMoeda)
		If Abs(nSaldoTit) > 0.0001
			// Pesquisa a data na matriz com os dados a serem exibidos na tela do fluxo
			nAscan := Ascan(aPeriodo, {|e| e[1] == dDataTrab})
			// Verifica se esta no periodo solicitado
			If nAscan > 0
				aFluxo[nAscan][SAIDAS] += nSaldoTit
			Endif	
			If lAnalitico .And. nAscan > 0
				RecLock(cAliasCo,.T.)
				(cAliasCo)->Datax		:= dDataTrab
				(cAliasCo)->Periodo	:= aPeriodo[nAscan][2]
				(cAliasCo)->FILIAL	:= (cAliasTrb)->E3_FILIAL
				(cAliasCo)->PREFIXO	:= (cAliasTrb)->E3_PREFIXO
				(cAliasCo)->NUMERO	:= (cAliasTrb)->E3_NUM
				(cAliasCo)->PARCELA	:= (cAliasTrb)->E3_PARCELA
				(cAliasCo)->VEND		:= (cAliasTrb)->E3_VEND
				DbSelectArea("SA3")
				dbSetOrder(1)
				MsSeek(xFilial("SA3")+(cAliasTrb)->E3_VEND)
				DbSelectArea(cAliasTrb)
				(cAliasCo)->NOMEVEND:= SA3->A3_NOME
				cIdentific :=	xFilial("SE3")+;
								   (cAliasTrb)->E3_PREFIXO +;
								   (cAliasTrb)->E3_NUM     +;
								   (cAliasTrb)->E3_PARCELA +;
								   (cAliasTrb)->E3_SEQ
				(cAliasCo)->Chave     := cIdentific
				(cAliasCo)->SALDO     := nSaldoTit
				(cAliasCo)->Apelido   := "SE3"
				MsUnlock()
				// Pesquisa na matriz de totais, os totais de contas a pagar ou a receber
				// da data de trabalho.
				nAscan := Ascan( aTotais[5], {|e| e[1] == dDataTrab})
				If nAscan == 0
					Aadd( aTotais[5], {dDataTrab,nSaldoTit})
				Else	
					aTotais[5][nAscan][2] += nSaldoTit // Contabiliza os totais de comissões
				Endif	
			Endif
		EndIf
	Endif
	(cAliasTrb)->(dbSkip())
Enddo
#IFDEF TOP
	If TcSrvType() != "AS/400" 
		dbSelectArea(cAliasTrb)
		dbCloseArea()
		dbSelectArea("SE3")
	Else
#ENDIF		
		dbSelectArea("SE3")
		dbClearFil()
		RetIndex("SE3")
		If !Empty(cIndTmp)
			FErase (cIndTmp+OrdBagExt())
		Endif
		dbSetOrder(1)
#IFDEF TOP
	Endif
#ENDIF

Return { ,, cArqAnaCo, cAliasCo }

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Fc021VenciºAutor  ³Claudio D. de Souza º Data ³  30/08/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDesc.     ³ Calcula os titulos vencidos do SE1/SE2                     º±±
±±º          ³ Parametros:                                                º±±
±±º          ³ cAlias   -> Alias do arquivo de titulos SE1 ou SE2         º±±
±±º          ³ lConsFil -> Considera filiais                              º±±
±±º          ³ cFilDe   -> Filial inicial                                 º±±
±±º          ³ cFilAte  -> Filial final                                   º±±
±±º          ³ nMoeda   -> Codigo da moeda                                º±±
±±º          ³ Retorno:                                                   º±±
±±º          ³ nRet -> Valor total dos titulos vencidos                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Finc021                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fc021Vencidos(cAlias, lConsFil, cFilDe, cFilAte,nMoeda,cFilterUser)
Local nRet := 0

Local	cFiltro  
Local	cAliasTmp 
Local	cAliasTrb 
Local	cCampo := Right(cAlias,2)
Local	nOrdem   
Local	nSaldo 
Local	aArea  := GetArea()
Local	aArea1 := (cAlias)->(GetArea())
Local lFc021Fil := ExistBlock("FC021FIL")

#IFDEF TOP
	Local	cQuery   
#ENDIF

DEFAULT cFilterUser := ""

nOrdem     := If( cAlias == "SE1", 7, 3 )
DbSelectArea(cAlias)
DbSetOrder(nOrdem)

If !lConsFil
   cFilDe  := xFilial(cAlias)
   cFilAte := xFilial(cAlias)
Endif			

cAliasTmp := "cArqTmp" // Alias do arquivo

#IFDEF TOP
	If TcSrvType() != "AS/400" 
		aStru     := (cAlias)->(dbStruct())
		cAliasTrb := "VENCIDOS"
		
		If cAlias == "SE3" // Comissoes
			cQuery := "SELECT * "
			cQuery += "FROM "+RetSqlName("SE3")+ " SE3 "
			cQuery += "WHERE "
			cQuery += "SE3.E3_FILIAL>='"+cFilDe+"' AND "
			cQuery += "SE3.E3_FILIAL<='"+cFilAte+"' AND "
			cQuery += "SE3.E3_VENCTO <= '"+Dtos(dDataBase-1)+"' AND "
			cQuery += "SE3.E3_DATA = ' ' AND "
			cQuery += "SE3.D_E_L_E_T_=' ' "
		Else
			cQuery := "SELECT * "
			cQuery += "FROM "+RetSqlName(cAlias) + " " + cAlias + " "
			cQuery += "WHERE "
			cQuery += cAlias + "." + cCampo + "_FILIAL>='"+cFilDe+"' AND "
			cQuery += cAlias + "." + cCampo + "_FILIAL<='"+cFilAte+"' AND "
			cQuery += cAlias + "." + cCampo + "_VENCREA <= '"+Dtos(dDataBase-1)+"' AND "
			cQuery += cAlias + "." + cCampo + "_SALDO > 0 AND "
			cQuery += cAlias + "." + cCampo + "_FLUXO <> 'N' AND "
			If cAlias == "SE1"
				cQuery += cAlias + "." + cCampo + "_SITUACA NOT IN ('2','7') AND "
			Endif
			cQuery += cAlias + ".D_E_L_E_T_=' ' AND "
			cQuery += cAlias+"."+cCampo+ "_TIPO  NOT IN ('NCC','NDF','IR-','CS-','CF-','PI-','AB-','IR-','IN-','IS-','PI-','CF-','CS-','FU-','FE-') "
		Endif	
	
		cQuery := ChangeQuery(cQuery)
	
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTrb,.T.,.T.)
		aEval(aStru, {|e| If(e[2]!= "C", TCSetField(cAliasTrb, e[1], e[2],e[3],e[4]),Nil)})
	Else	
#ENDIF
		If cAlias == "SE3"
			cFiltro := "E3_FILIAL>='"+cFilDe+"'.And."
			cFiltro += "E3_FILIAL<='"+cFilAte+"'.And."
			cFiltro += "Dtos(E3_VENCTO)<='"+Dtos(dDataBase-1)+"'.And."
			cFiltro += "Dtos(E3_DATA)='"+Dtos(Ctod(""))+"'"
		Else
			cFiltro := cCampo + "_FILIAL>='"+cFilDe+"'.And."
			cFiltro += cCampo + "_FILIAL<='"+cFilAte+"'.And."
			cFiltro += "Dtos("+cCampo+"_VENCREA)<='"+Dtos(dDataBase-1)+"'.And."
			cFiltro += cCampo+"_SALDO > 0.And."
			If cAlias == "SE1"
				cFiltro += ".Not. "+ cCampo + "_SITUACA $ '27'.And."
			Endif
	//		cFiltro += cCampo+"_FLUXO != 'N'" IDEPENDENTE DO FLUXO O DADOS TEM QUE APARECER
		Endif	
			
		dbSelectArea(cAlias)
		cIndTmp := CriaTrab(,.F.)
		IndRegua(cAlias,cIndTmp,IndexKey(),,cFiltro)
		dbGotop()
		cAliasTrb := cAlias
#IFDEF TOP
	Endif
#ENDIF		

While (cAliasTrb)->(!Eof()) //IndRegua
	IncProc(STR0074 + If(cAlias=="SE1", STR0056,STR0057)) //"Processando titulos vencidos a "###"Receber"###"Pagar"

	If lFc021Fil
		cFilterUser := ExecBlock("FC021FIL", .F., .F., {cAlias} )
	EndIf
	If cAlias == "SE3"
		nRet += xMoeda((cAliasTrb)->E3_COMIS,1,nMoeda)
	Else
		// Se nao existir filtro de usuario, ou se o filtro retornar uma expressao
		// valida para o registro atual do titulo, entao processsa o registro.
		
		If	(Empty(cFilterUser) .Or. (&cFilterUser))
			/*TESTE AGLAIR DE CONVERSÃO
			nSaldo:=xMoeda((cAliasTrb)->&(cCampo+"_SALDO")+;
								((cAliasTrb)->&(cCampo+"_SDACRES")-;
								(cAliasTrb)->&(cCampo+"_SDDECRE")),;
								(cAliasTrb)->&(cCampo+"_MOEDA")  ,;
								nMoeda,,,;
								If(cPaisLoc=="BRA",(cAliasTrb)->&(cCampo+"_TXMOEDA"),0))
            ************************************/
           		nSaldo := xMoeda((cAliasTrb)->&(cCampo+"_SALDO")+;
								((cAliasTrb)->&(cCampo+"_SDACRES")-;
								(cAliasTrb)->&(cCampo+"_SDDECRE")),;
								(cAliasTrb)->&(cCampo+"_MOEDA")  ,;
							  nMoeda              	,;
			 			     dDatabase) 


					nRet += nSaldo
            /*TESTE AGLAIR
			If cPaisLoc <> "BRA"
				If (cAliasTrb)->&(cCampo+"_TIPO") $ MV_CRNEG+"/"+MV_CPNEG+"/"+MVIRABT+"/"+MVCSABT+"/"+MVCFABT+"/"+MVPIABT+"/"+MVABATIM+"/"+MVRECANT+"/"+MVPAGANT
					nRet -= nSaldo
				Else
					nRet += nSaldo
				Endif
			ElseIf !(cAliasTrb)->&(cCampo+"_TIPO") $ MVRECANT+MVPAGANT			 
				If (cAliasTrb)->&(cCampo+"_TIPO") $ MV_CRNEG+"/"+MV_CPNEG+"/"+MVIRABT+"/"+MVCSABT+"/"+MVCFABT+"/"+MVPIABT+"/"+MVABATIM
					nRet -= nSaldo
				Else
					nRet += nSaldo
				Endif
			Endif
		    */
		Endif             
		
	Endif	
	(cAliasTrb)->(dbSkip())
Enddo
#IFDEF TOP
	If TcSrvType() != "AS/400"
		dbSelectArea(cAliasTrb)
		dbCloseArea()
		dbSelectArea(cAlias)
	Else
#ENDIF
		dbSelectArea(cAlias)
		dbClearFil()
		RetIndex(cAlias)
		If !Empty(cIndTmp)
			FErase (cIndTmp+OrdBagExt())
		Endif
		dbSetOrder(1)
#IFDEF TOP
	Endif
#ENDIF	
RestArea(aArea)
(cAlias)->(RestArea(aArea1))

Return nRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³FluxoAna  ºAutor  ³Claudio D. de Souza º Data ³  30/08/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exibe o fluxo analitico, ou seja, os dados que compem os   º±±
±±º          ³ valores do fluxo sintetico                                 º±±
±±º          ³ Parametros:                                                º±±
±±º          ³ cArqAnaP   -> Nome do arquivo temporario CP                º±±
±±º          ³ cAliasP    -> Alias do arquivo temporario CP               º±±
±±º          ³ cArqAnaR   -> Nome do arquivo temporario CR                º±±
±±º          ³ cAliasR    -> Alias do arquivo temporario CR               º±±
±±º          ³ cAliasPc   -> Alias do arquivo temporario Pedido de compra º±±
±±º          ³ cAliasPv   -> Alias do arquivo temporario Pedido de Venda  º±±
±±º          ³ cAliasEmp  -> Alias do arquivo temporario Emprestimos      º±±
±±º          ³ cAliasCo   -> Alias do arquivo temporario Comissões        º±±
±±º          ³ dData      -> Data a exibir                                º±±
±±º          ³ aTotais    -> Matriz de totais por folder/data             º±±
[±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Finc021                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static FUNCTION FluxoAna(cAliasP,cAliasR,cAliasPc,cAliasPv,cAliasCo,cAliasEmp,;
								 cAliasApl,cAliasCtrc,cPeriodo,aFluxo,aTotais,nBancos,nCaixas,nAtrReceber,;
								 nAtrPagar,aPeriodo,cAliasChq,oFluxo,nLimCred,cAliasAR,cAliasAP)
Local aArea    := GetArea(),;
		aOldHeader	:= aClone(aHeader),;
		aOldaCols	:= aClone(aCols),;
		aOldaRotina	:= aClone(aRotina),;
		oGetDb1 ,;
		oGetDb2 ,;
		oGetDb3 ,;
		oGetDb4 ,;
		oGetDb5 ,;
		oGetDb6 ,;			
		oGetDb7 ,;
		oGetDb8 ,;
		oGetDb9 ,;
		oFolder ,;
		aHeader1,;
		aHeader2,;
		aHeader3,;
		aHeader4,;
		aHeader5,;
		aHeader6,;
		aHeader7,;
		aHeader8,;
		aHeader9,;
		nAscan  ,;
		oSayTotal,;
		oGetTotal,;
		nTotal := 0
LOCAL oDlg,oBold, aGetDb, aAlias
LOCAL aSize, aObjects := {}, aInfo, aPosObj
LOCAL cFiltro := "Alltrim(Periodo)=='"+Alltrim(Transform(cPeriodo,""))+"'" // Filtro para a GetDb
Local nX := 0
Local aButton := {	{"SIMULACAO",	{|| If(ValType(aGetDb[oFolder:nOption])=="O" .And. !Empty((aAlias[oFolder:nOption])->DataX),(Fc021Proj(oDlg,aFluxo,aAlias,oFolder,aGetDb,aTotais,nBancos,nCaixas,nAtrReceber,nAtrPagar,@nTotal,aPeriodo,nLimCred),aGetDb[oFolder:nOption]:oBrowse:Refresh()), .T.) }, STR0171},;
						 	{"ANALITICO",	{|| If(ValType(oFolder:aDialogs[oFolder:nOption])=="O"  .And.;
														 ValType(oFolder:aDialogs[oFolder:nOption]:Cargo) == "A" .And.;
											    		 ValType(oFolder:aDialogs[oFolder:nOption]:Cargo[2]) == "B", Eval(oFolder:aDialogs[oFolder:nOption]:Cargo[2]), .T.)},STR0172}}

DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD

aSize := MsAdvSize()
aadd( aObjects, { 100, 100, .T., .T., .T. } )  
aInfo := { aSize[1],aSize[2],aSize[3],aSize[4],3,3 } 
aPosObj := MsObjSize( aInfo, aObjects )  

DEFINE MSDIALOG oDlg FROM aSize[7],0 TO aSize[6],aSize[5] TITLE OemToAnsi(STR0075 + cPeriodo) PIXEL of oMainWnd //"Detalhes do Dia" //"Detalhes do dia "
//@ aPosObj[1,1],aPosObj[1,2] FOLDER oFolder SIZE aPosObj[1,3],aPosObj[1,4]-15 OF oDlg PROMPTS STR0035,STR0036,STR0231,STR0232 PIXEL //"A Pagar"###"A Receber"###"Pedido de Compra"###"Pedido de Venda"###"Comissões"###"Emprestimos"###"Aplicações"###"Cheques pendentes" AGLAIR 
@ aPosObj[1,1],aPosObj[1,2] FOLDER oFolder SIZE aPosObj[1,3],aPosObj[1,4]-15 OF oDlg PROMPTS STR0234,STR0235,STR0231,STR0232 PIXEL //"A Pagar"###"A Receber"###"Pedido de Compra"###"Pedido de Venda"###"Comissões"###"Emprestimos"###"Aplicações"###"Cheques pendentes" AGLAIR 
//@ aPosObj[1,1],aPosObj[1,2] FOLDER oFolder SIZE aPosObj[1,3],aPosObj[1,4]-15 OF oDlg PROMPTS STR0035,STR0036,"Titulos Vencidos a Receber","Titulos Vencidos a Pagar"  PIXEL 28/04/2010 ABI
oFolder:bSetOption:={|nAtu| Fc021ChFol(nAtu,oFolder:nOption,oFolder,oDlg,aTotais,oSayTotal,oGetTotal, @nTotal,cPeriodo,aGetDb, aAlias,aHeader1,aHeader2,aHeader3,aHeader4)} 
//oFolder:bSetOption:={|nAtu| Fc021ChFol(nAtu,oFolder:nOption,oFolder,oDlg,aTotais,oSayTotal,oGetTotal, @nTotal,cPeriodo,aGetDb, aAlias,aHeader1,aHeader2,aHeader3,aHeader4)}

nAscan := Ascan( aTotais[oFolder:nOption], {|e|Transform(e[1],"") = cPeriodo})
If nAscan > 0
	nTotal := aTotais[oFolder:nOption][nAscan][2]
Endif

@ aPosObj[1,4]+4, aPosObj[1,2]+  1   SAY oSayTotal VAR STR0236 PIXEL OF oDlg FONT oBold //"Total de titulos a Pagar"
@ aPosObj[1,4]+4, aPosObj[1,2]+100 MSGET oGetTotal VAR nTotal PICTURE "@E 999,999,999,999.99" WHEN .F. PIXEL OF oDlg SIZE 60,10 FONT oBold

If cAliasP != Nil .And. Select(cAliasP) > 0
	DbSelectArea(cAliasP)
	Set Filter To &cFiltro
	DbGoTop()
	aHeader := {}
	Aadd( aHeader, { STR0200, "Filial"   , "", Len((cAliasP)->Filial), 0, ".F.", USADO, "C",, "V" } ) //"Filial"
	Aadd( aHeader, { STR0079, "Prefixo"   , "", Len((cAliasP)->Prefixo), 0, ".F.", USADO, "C",, "V" } ) //"Prefixo"
	Aadd( aHeader, { STR0080, "Num"       , "", Len((cAliasP)->Num)    , 0, ".F.", USADO, "C",, "V" } ) //"Numero"
	Aadd( aHeader, { STR0081, "Parcela"   , "", Len((cAliasP)->Parcela), 0, ".F.", USADO, "C",, "V" } ) //"Parc"
	Aadd( aHeader, { STR0082, "Tipo"      , "", Len((cAliasP)->Tipo)   , 0, ".F.", USADO, "C",, "V" } ) //"Tipo"
	Aadd( aHeader, { STR0083, "CliFor"    , "", Len((cAliasP)->CliFor) , 0, ".F.", USADO, "C",, "V" } ) //"Fornecedor"
	Aadd( aHeader, { STR0064, "NomCliFor" , "", Len((cAliasP)->NomCliFor), 0, ".F.", USADO, "C",, "V" } ) //"Nome"
	Aadd( aHeader, { STR0084, "Loja"      , "", Len((cAliasP)->Loja)   , 0, ".F.", USADO, "C",, "V" } ) //"Loja"
	Aadd( aHeader, { STR0026, "Saldo"     , "@e 999,999,999.99", 15, 2, ".T.", USADO, "N",, "V" } ) //"Valor"

   // Ponto entrada para incluir novas colunas no aHeader
	If ExistBlock("FC021HEAD")
		aHdNew := ExecBlock("FC021HEAD",.F.,.F.,{aHeader})
		For nX := 1 to len(aHdNew)		
 			aAdd(aHeader,aHdNew[nX])
	 	Next
	EndIf
	Aadd( aHeader, { "Historico", "Historico" , "", 50, 0, ".F.", USADO, "C",, "V" } ) //"Incluido pela Aglair"
	Aadd( aHeader, { ""     , "CampoNulo" , "", 1, 0, ".T.", USADO, "C",, "V" } )
	aHeader1 := aClone(aHeader)
	oGetDb1 := (cAliasP)->(MsGetDb():New(1,2,aPosObj[1,4]-30,aPosObj[1,3]-5,2,,,,.F.,,,.F.,,cAliasP,"AllwaysTrue",,,oFolder:aDialogs[1],.F.,.T.))
	oGetDb1:oBrowse:lHScroll := .F.
	oGetDb1:oBrowse:lDisablePaint := .T.
	oFolder:aDialogs[1]:Cargo := {"P",{||Fc021Visual("SE2",(cAliasP)->Chave,STR0234)}} //"Contas a Pagar"
Endif
If cAliasR != Nil .And. Select(cAliasR) > 0
	DbSelectArea(cAliasR)
	Set Filter To &cFiltro
	DbGoTop()
	aHeader := {}
	Aadd( aHeader, { STR0200, "Filial"    , "", Len((cAliasR)->Filial), 0, ".F.", USADO, "C",, "V" } ) //"Filial"
	Aadd( aHeader, { STR0079, "Prefixo"   , "", Len((cAliasR)->Prefixo), 0, ".F.", USADO, "C",, "V" } ) //"Prefixo"
	Aadd( aHeader, { STR0080, "Num"       , "", Len((cAliasR)->Num)    , 0, ".F.", USADO, "C",, "V" } ) //"Numero"
	Aadd( aHeader, { STR0081, "Parcela"   , "", Len((cAliasR)->Parcela), 0, ".F.", USADO, "C",, "V" } ) //"Parc"
	Aadd( aHeader, { STR0082, "Tipo"      , "", Len((cAliasR)->Tipo)   , 0, ".F.", USADO, "C",, "V" } ) //"Tipo"
	Aadd( aHeader, { STR0088, "CliFor"    , "", Len((cAliasR)->CliFor) , 0, ".F.", USADO, "C",, "V" } ) //"Cliente"
	Aadd( aHeader, { STR0064, "NomCliFor" , "", Len((cAliasR)->NomCliFor), 0, ".F.", USADO, "C",, "V" } ) //"Nome"
	Aadd( aHeader, { STR0084, "Loja"      , "", Len((cAliasR)->Loja)   , 0, ".F.", USADO, "C",, "V" } ) //"Loja"
	Aadd( aHeader, { STR0026, "Saldo"     , "@e 999,999,999.99", 15, 2, ".T.", USADO, "N",, "V" } ) //"Valor"
	// Se o campo de situacao existir no rquivo temporario.
	If (cAliasR)->(FieldPos("Situacao")) > 0
		Aadd( aHeader, { "Situacao", "Situacao", "", Len((cAliasR)->Situacao), 0, ".F.", USADO, "C",, "V" } ) // "Situacao"
	Endif	                                                    
	If (cAliasR)->(FieldPos("Portado")) > 0
		Aadd( aHeader, { STR0061 ,"Portado"	, "", Len((cAliasR)->Portado) ,0 , ".F.", USADO, "C",, "V"} )
	EndIf
	If (cAliasR)->(FieldPos("AgeDep")) > 0
		Aadd( aHeader, { STR0062 ,"AgeDep"	, "", Len((cAliasR)->AgeDep)  ,0 , ".F.", USADO, "C",, "V"} )
	EndIf
	If (cAliasR)->(FieldPos("AgeDep")) > 0
		Aadd( aHeader, { STR0063 ,"Conta"	, "", Len((cAliasR)->Conta)   ,0 , ".F.", USADO, "C",, "V"} )		
	EndIf
	   // Ponto entrada para incluir novas colunas no aHeader
	If ExistBlock("FC021HEAD")
		aHdNew := ExecBlock("FC021HEAD",.F.,.F.,{aHeader})
		For nX := 1 to len(aHdNew)		
 			aAdd(aHeader,aHdNew[nX])
	 	Next
	EndIf
	Aadd( aHeader, { "Historico", "Historico" , "", 50, 0, ".F.", USADO, "C",, "V" } ) //"Incluido pela Aglair"
	Aadd( aHeader, { ""     , "CampoNulo" , "", 1, 0, ".T.", USADO, "C",, "V" } )

	aHeader2 := aClone(aHeader)
	oGetDb2 := (cAliasR)->(MsGetDb():New(1,2,aPosObj[1,4]-30,aPosObj[1,3]-5,2,,,,.F.,,,.F.,,cAliasR,"AllwaysTrue",,,oFolder:aDialogs[2],.F.,.T.))
	oGetDb2:oBrowse:lHScroll := .F.
	oGetDb2:oBrowse:lDisablePaint := .T.
	oFolder:aDialogs[2]:Cargo := {"R",{||Fc021Visual("SE1",(cAliasR)->Chave,"Contas a Receber")}} //STR0235)}} //"Contas a Receber"
Endif	
If cAliasAR != Nil .And. Select(cAliasAR) > 0
	DbSelectArea(cAliasAR)         
	//Set Filter To &cFiltro
	DbGoTop()
	aHeader := {}
	Aadd( aHeader, { STR0229, "VENCTO "    , "",             8, 0, ".F.", USADO, "D",, "V" } ) //"Filial"
	Aadd( aHeader, { STR0079, "E1_PREFIXO"   , "", Len((cAliasAR)->E1_PREFIXO), 0, ".F.", USADO, "C",, "V" } ) //"Prefixo"
	Aadd( aHeader, { STR0080, "E1_NUM"       , "", Len((cAliasAR)->E1_NUM)    , 0, ".F.", USADO, "C",, "V" } ) //"Numero"
	Aadd( aHeader, { STR0081, "E1_PARCELA"   , "", Len((cAliasAR)->E1_PARCELA), 0, ".F.", USADO, "C",, "V" } ) //"Parc"
	Aadd( aHeader, { STR0082, "E1_TIPO"      , "", 3   , 0, ".F.", USADO, "C",, "V" } ) //"Tipo"
//	Aadd( aHeader, { STR0082, "Tipo"      , "", Len((cAliasAR)->Tipo)   , 0, ".F.", USADO, "C",, "V" } ) //"Tipo"
	Aadd( aHeader, { STR0088, "E1_CLIENTE"    , "", Len((cAliasAR)->E1_CLIENTE) , 0, ".F.", USADO, "C",, "V" } ) //"Cliente"
//	Aadd( aHeader, { STR0064, "E1_LOJA" , "", Len((cAliasAR)->E1_LOJA), 0, ".F.", USADO, "C",, "V" } ) //"Nome"
	Aadd( aHeader, { STR0084, "E1_LOJA" , "", Len((cAliasAR)->E1_LOJA), 0, ".F.", USADO, "C",, "V" } ) //"Nome"
	Aadd( aHeader, { STR0064, "E1_NCLI"      , "", Len((cAliasAR)->E1_NCLI )   , 0, ".F.", USADO, "C",, "V" } ) //"Loja"
	Aadd( aHeader, { STR0026, "E1_VALOR"     , "@e 999,999,999.99", 15, 2, ".T.", USADO, "N",, "V" } ) //"Valor"
    
		// Se o campo de situacao existir no rquivo temporario.
	If (cAliasAR)->(FieldPos("E1_SITUAC")) > 0
		Aadd( aHeader, { "Situacao", "Situacao", "", Len((cAliasAR)->E1_SITUAC), 0, ".F.", USADO, "C",, "V" } ) // "Situacao"
	Endif	                                                    
	If (cAliasAR)->(FieldPos("E1_PORTADO")) > 0
		Aadd( aHeader, { STR0061 ,"Portado"	, "", Len((cAliasAR)->E1_PORTADO) ,0 , ".F.", USADO, "C",, "V"} )
	EndIf
	If (cAliasAR)->(FieldPos("E1_AGEDEP")) > 0
		Aadd( aHeader, { STR0062 ,"AgeDep"	, "", Len((cAliasAR)->E1_AGEDEP)  ,0 , ".F.", USADO, "C",, "V"} )
	EndIf
	If (cAliasAR)->(FieldPos("E1_CONTA")) > 0
		Aadd( aHeader, { STR0063 ,"Conta"	, "", Len((cAliasAR)->E1_CONTA)   ,0 , ".F.", USADO, "C",, "V"} )		
	EndIf
     
	 	   // Ponto entrada para incluir novas colunas no aHeader
	If ExistBlock("FC021HEAD")
		aHdNew := ExecBlock("FC021HEAD",.F.,.F.,{aHeader})
		For nX := 1 to len(aHdNew)		
 			aAdd(aHeader,aHdNew[nX])
	 	Next
	EndIf
	//Aadd( aHeader, { "Historico", "Historico" , "", 50, 0, ".F.", USADO, "C",, "V" } ) //"Incluido pela Aglair"
	Aadd( aHeader, { ""     , "CampoNulo" , "", 1, 0, ".T.", USADO, "C",, "V" } )

	aHeader3 := aClone(aHeader)
	oGetDb3 := (cAliasAR)->(MsGetDb():New(1,2,aPosObj[1,4]-30,aPosObj[1,3]-5,2,,,,.F.,,,.F.,,cAliasAR,"AllwaysTrue",,,oFolder:aDialogs[3],.F.,.T.))
	oGetDb3:oBrowse:lHScroll := .F.
	oGetDb3:oBrowse:lDisablePaint := .T.
 //	oFolder:aDialogs[3]:Cargo := {"P",{||Fc021Visual("SE1",(cAliasAR)->Chave,STR0093)}} //"Contas a receber "

Endif	

If cAliasAP != Nil .And. Select(cAliasAP) > 0
	DbSelectArea(cAliasAR)         
	//Set Filter To &cFiltro
	DbGoTop()
	aHeader := {}
	Aadd( aHeader, { STR0229, "VENCTO "    , "",             8, 0, ".F.", USADO, "D",, "V" } ) //"Filial"
	Aadd( aHeader, { STR0079, "E2_PREFIXO"   , "", Len((cAliasAP)->E2_PREFIXO), 0, ".F.", USADO, "C",, "V" } ) //"Prefixo"
	Aadd( aHeader, { STR0080, "E2_NUM"       , "", Len((cAliasAP)->E2_NUM)    , 0, ".F.", USADO, "C",, "V" } ) //"Numero"
	Aadd( aHeader, { STR0081, "E2_PARCELA"   , "", Len((cAliasAP)->E2_PARCELA), 0, ".F.", USADO, "C",, "V" } ) //"Parc"
	Aadd( aHeader, { STR0082, "E2_TIPO"      , "", 3   , 0, ".F.", USADO, "C",, "V" } ) //"Tipo"
//	Aadd( aHeader, { STR0082, "Tipo"      , "", Len((cAliasAR)->Tipo)   , 0, ".F.", USADO, "C",, "V" } ) //"Tipo"
	Aadd( aHeader, { STR0088, "E2_FORNECE"    , "", Len((cAliasAP)->E2_FORNECE) , 0, ".F.", USADO, "C",, "V" } ) //"Cliente"
//	Aadd( aHeader, { STR0064, "E1_LOJA" , "", Len((cAliasAR)->E1_LOJA), 0, ".F.", USADO, "C",, "V" } ) //"Nome"
	Aadd( aHeader, { STR0084, "E2_LOJA" , "", Len((cAliasAP)->E2_LOJA), 0, ".F.", USADO, "C",, "V" } ) //"Nome"
	Aadd( aHeader, { STR0064, "E2_NFORN"      , "", Len((cAliasAP)->E2_NFORN )   , 0, ".F.", USADO, "C",, "V" } ) //"Loja"
	Aadd( aHeader, { STR0026, "E2_VALOR"     , "@e 999,999,999.99", 15, 2, ".T.", USADO, "N",, "V" } ) //"Valor"
    
		// Se o campo de situacao existir no rquivo temporario.
//	If (cAliasAR)->(FieldPos("E2_SITUAC")) > 0
//		Aadd( aHeader, { "Situacao", "Situacao", "", Len((cAliasAP)->E2_SITUAC), 0, ".F.", USADO, "C",, "V" } ) // "Situacao"
//	Endif	                                                    
	If (cAliasAP)->(FieldPos("E2_PORTADO")) > 0
		Aadd( aHeader, { STR0061 ,"Portado"	, "", Len((cAliasAP)->E2_PORTADO) ,0 , ".F.", USADO, "C",, "V"} )
	EndIf
	If (cAliasAP)->(FieldPos("E2_NAGENCI")) > 0
		Aadd( aHeader, { STR0062 ,"AgeDep"	, "", Len((cAliasAP)->E2_NAGENCI)  ,0 , ".F.", USADO, "C",, "V"} )
	EndIf
	If (cAliasAP)->(FieldPos("E2_NCONTA")) > 0
		Aadd( aHeader, { STR0063 ,"Conta"	, "", Len((cAliasAP)->E2_NCONTA)   ,0 , ".F.", USADO, "C",, "V"} )		
	EndIf
     
	 	   // Ponto entrada para incluir novas colunas no aHeader
	If ExistBlock("FC021HEAD")
		aHdNew := ExecBlock("FC021HEAD",.F.,.F.,{aHeader})
		For nX := 1 to len(aHdNew)		
 			aAdd(aHeader,aHdNew[nX])
	 	Next
	EndIf
	//Aadd( aHeader, { "Historico", "Historico" , "", 50, 0, ".F.", USADO, "C",, "V" } ) //"Incluido pela Aglair"
	Aadd( aHeader, { ""     , "CampoNulo" , "", 1, 0, ".T.", USADO, "C",, "V" } )

	aHeader4 := aClone(aHeader)
	oGetDb4 := (cAliasAP)->(MsGetDb():New(1,2,aPosObj[1,4]-30,aPosObj[1,3]-5,2,,,,.F.,,,.F.,,cAliasAP,"AllwaysTrue",,,oFolder:aDialogs[4],.F.,.T.))
	oGetDb4:oBrowse:lHScroll := .F.
	oGetDb4:oBrowse:lDisablePaint := .T.
 //	oFolder:aDialogs[3]:Cargo := {"P",{||Fc021Visual("SE1",(cAliasAR)->Chave,STR0093)}} //"Contas a receber "

Endif	


/*
If cAliasPc != Nil .And. Select(cAliasPc) > 0
	DbSelectArea(cAliasPc)
	Set Filter To &cFiltro
	DbGoTop()
	aHeader := {}
	Aadd( aHeader, { STR0080, "Numero"    , "", Len((cAliasPc)->numero)   , 0, ".F.", USADO, "C",, "V" } ) //"Numero"
	Aadd( aHeader, { STR0090, "Emissao"   , "",              8, 0, ".F.", USADO, "D",, "V" } ) //"Emissao"
	Aadd( aHeader, { STR0083, "Clifor"    , "", Len((cAliasPc)->CliFor)   , 0, ".F.", USADO, "C",, "V" } ) //"Fornecedor"
	Aadd( aHeader, { STR0064, "NomCliFor" , "", Len((cAliasPc)->NomCliFor), 0, ".F.", USADO, "C",, "V" } ) //"Nome"
	Aadd( aHeader, { STR0082, "Tipo"      , "", TamSx3("C7_TIPO")[1], 0, ".F.", USADO, "N",, "V" } ) //"Tipo"
	Aadd( aHeader, { STR0091, "Item"      , "", Len((cAliasPc)->Item)     , 0, ".F.", USADO, "C",, "V" } ) //"Item"
	Aadd( aHeader, { STR0092, "Produto"   , "", Len((cAliasPc)->Produto)  , 0, ".F.", USADO, "C",, "V" } ) //"Produto"
	Aadd( aHeader, { STR0026, "Saldo"     , "@e 999,999,999.99", 15, 2, ".T.", USADO, "N",, "V" } ) //"Valor"
	Aadd( aHeader, { ""     , "CampoNulo" , "", 1, 0, ".T.", USADO, "C",, "V" } )
	aHeader3 := aClone(aHeader)
	oGetDb3 := (cAliasPc)->(MsGetDb():New(1,2,aPosObj[1,4]-30,aPosObj[1,3]-5,2,,,,.F.,,,.F.,,cAliasPc,"AllwaysTrue",,,oFolder:aDialogs[3],.F.,.T.))
	oGetDb3:oBrowse:lHScroll := .F.
	oGetDb3:oBrowse:lDisablePaint := .T.
	oFolder:aDialogs[3]:Cargo := {"P",{||Fc021Visual("SC7",(cAliasPc)->Chave,STR0093)}} //"Pedidos de Compras"
Endif
*pEDIDO DE COMPRA RETIRADO PELA AGLAIR 
If cAliasPv != Nil .And. Select(cAliasPv) > 0	
	DbSelectArea(cAliasPv)
	Set Filter To &cFiltro
	DbGoTop()
	aHeader := {}
	Aadd( aHeader, { STR0080, "Numero"    , "", Len((cAliasPv)->Numero) , 0, ".F.", USADO, "C",, "V" } ) //"Numero"
	Aadd( aHeader, { STR0082, "Tipo"      , "", Len((cAliasPv)->Tipo)   , 0, ".F.", USADO, "C",, "V" } ) //"Tipo"
	Aadd( aHeader, { STR0090, "Emissao"   , "",  			  8, 0, ".F.", USADO, "C",, "V" } ) //"Emissao"
	Aadd( aHeader, { STR0088, "CliFor"    , "", Len((cAliasPv)->CliFor) , 0, ".F.", USADO, "C",, "V" } ) //"Cliente"
	Aadd( aHeader, { STR0064, "NomCliFor" , "", Len((cAliasPv)->NomCliFor), 0, ".F.", USADO, "C",, "V" } ) //"Nome"
	Aadd( aHeader, { STR0094, "LojaCli" , "", Len((cAliasPv)->LojaCli) , 0, ".F.", USADO, "C",, "V" } ) //"Loja Cliente"
	Aadd( aHeader, { STR0095, "LojaEnt" , "", Len((cAliasPv)->LojaEnt) , 0, ".F.", USADO, "C",, "V" } ) //"Loja Entrega"
	Aadd( aHeader, { STR0026, "Saldo"     , "@e 999,999,999.99", 15, 2, ".T.", USADO, "N",, "V" } ) //"Valor"
	Aadd( aHeader, { ""     , "CampoNulo" , "", 1, 0, ".T.", USADO, "C",, "V" } )
	aHeader4 := aClone(aHeader)
	oGetDb4 := (cAliasPv)->(MsGetDb():New(1,2,aPosObj[1,4]-30,aPosObj[1,3]-5,2,,,,.F.,,,.F.,,cAliasPv,"AllwaysTrue",,,oFolder:aDialogs[4],.F.,.T.))
	oGetDb4:oBrowse:lHScroll := .F.
	oGetDb4:oBrowse:lDisablePaint := .T.
	oFolder:aDialogs[4]:Cargo := {"R",{||Fc021Visual("SC5",(cAliasPv)->Chave,STR0096)}} //"Pedidos de Venda"
Endif
If cAliasCo != Nil .And. Select(cAliasCo) > 0
	DbSelectArea(cAliasCo)
	Set Filter To &cFiltro
	DbGoTop()
	aHeader := {}
	Aadd( aHeader, { STR0200, "Filial"  , "", Len((cAliasCo)->Filial) , 0, ".F.", USADO, "C",, "V" } ) //"Filial"
	Aadd( aHeader, { STR0079, "Prefixo"  , "", Len((cAliasCo)->prefixo) , 0, ".F.", USADO, "C",, "V" } ) //"Prefixo"
	Aadd( aHeader, { STR0080, "Numero"   , "", Len((cAliasCo)->numero)  , 0, ".F.", USADO, "C",, "V" } ) //"Numero"
	Aadd( aHeader, { STR0097, "Parcela"  , "", Len((cAliasCo)->Parcela) , 0, ".F.", USADO, "C",, "V" } ) //"Parcela"
	Aadd( aHeader, { STR0098, "Vend"     , "", Len((cAliasCo)->Vend)    , 0, ".F.", USADO, "C",, "V" } ) //"Vendedor"
	Aadd( aHeader, { STR0064, "NomeVend" , "", Len((cAliasCo)->NomeVend), 0, ".F.", USADO, "C",, "V" } ) //"Nome"
	Aadd( aHeader, { STR0026, "Saldo"    , "@e 999,999,999.99", 15, 2, ".T.", USADO, "N",, "V" } ) //"Valor"
	Aadd( aHeader, { ""     , "CampoNulo", "", 1, 0, ".T.", USADO, "C",, "V" } )
	aHeader5 := aClone(aHeader)
	oGetDb5 := (cAliasCo)->(MsGetDb():New(1,2,aPosObj[1,4]-30,aPosObj[1,3]-5,2,,,,.F.,,,.F.,,cAliasCo,"AllwaysTrue",,,oFolder:aDialogs[5],.F.,.T.))
	oGetDb5:oBrowse:lHScroll := .F.
	oGetDb5:oBrowse:lDisablePaint := .T.
	oFolder:aDialogs[5]:Cargo := {"P",{||Fc021Visual("SE3",(cAliasCo)->Chave,STR0009)}} //"Comissões"
Endif
If cAliasEmp != Nil .And. Select(cAliasEmp) > 0
	DbSelectArea(cAliasEmp)
	Set Filter To &cFiltro
	DbGoTop()
	aHeader := {}
	Aadd( aHeader, { STR0080, "Numero"    , "", Len((cAliasEmp)->numero) , 0, ".F.", USADO, "C",, "V" } ) //"Numero"
	Aadd( aHeader, { STR0061, "Banco"     , "", Len((cAliasEmp)->Banco)  , 0, ".F.", USADO, "C",, "V" } ) //"Banco"
	Aadd( aHeader, { STR0062, "Agencia"   , "", Len((cAliasEmp)->Agencia), 0, ".F.", USADO, "C",, "V" } ) //"Agencia"
	Aadd( aHeader, { STR0063, "Conta"     , "", Len((cAliasEmp)->Conta)  , 0, ".F.", USADO, "C",, "V" } ) //"Conta"
	Aadd( aHeader, { STR0090, "Emissao"   , "", 8,0, ".F.", USADO, "D",, "V" } ) //"Emissao"
	Aadd( aHeader, { STR0026, "Saldo"     , "@e 999,999,999.99", 15, 2, ".T.", USADO, "N",, "V" } ) //"Valor"
	Aadd( aHeader, { ""     , "CampoNulo" , "", 1, 0, ".T.", USADO, "C",, "V" } )
	aHeader6 := aClone(aHeader)
	oGetDb6  := (cAliasEmp)->(MsGetDb():New(1,2,aPosObj[1,4]-30,aPosObj[1,3]-5,2,,,,.T.,{},,.T.,,cAliasEmp,"AllwaysTrue",,,oFolder:aDialogs[6],.F.,.T.))
	oGetDb6:oBrowse:lHScroll := .F.
	oGetDb6:oBrowse:lDisablePaint := .T.
	oFolder:aDialogs[6]:Cargo := {"P",{||Fc021Visual("SEH",(cAliasEmp)->Chave,STR0076)}} //"Emprestimos"
Endif
If cAliasApl != Nil .And. Select(cAliasApl) > 0
	DbSelectArea(cAliasApl)
	Set Filter To &cFiltro
	DbGoTop()
	aHeader := {}
	Aadd( aHeader, { STR0080, "Numero"    , "", Len((cAliasApl)->numero) , 0, ".F.", USADO, "C",, "V" } ) //"Numero"
	Aadd( aHeader, { STR0061, "Banco"     , "", Len((cAliasApl)->Banco)  , 0, ".F.", USADO, "C",, "V" } ) //"Banco"
	Aadd( aHeader, { STR0062, "Agencia"   , "", Len((cAliasApl)->Agencia), 0, ".F.", USADO, "C",, "V" } ) //"Agencia"
	Aadd( aHeader, { STR0063, "Conta"     , "", Len((cAliasApl)->Conta)  , 0, ".F.", USADO, "C",, "V" } ) //"Conta"
	Aadd( aHeader, { STR0090, "Emissao"   , "", 8,0, ".F.", USADO, "D",, "V" } ) //"Emissao"
	Aadd( aHeader, { STR0026, "Saldo"     , "@e 999,999,999.99", 15, 2, ".T.", USADO, "N",, "V" } ) //"Valor"
	Aadd( aHeader, { ""     , "CampoNulo" , "", 1, 0, ".T.", USADO, "C",, "V" } )
	aHeader7 := aClone(aHeader)
	oGetDb7  := (cAliasApl)->(MsGetDb():New(1,2,aPosObj[1,4]-30,aPosObj[1,3]-5,2,,,,.T.,{},,.T.,,cAliasApl,"AllwaysTrue",,,oFolder:aDialogs[7],.F.,.T.))
	oGetDb7:oBrowse:lHScroll := .F.
	oGetDb7:oBrowse:lDisablePaint := .T.
	oFolder:aDialogs[7]:Cargo := {"R",{||Fc021Visual("SEH",(cAliasApl)->Chave,STR0077)}} //"Aplicações"
Endif
If cAliasChq != Nil .And. Select(cAliasChq) > 0
	DbSelectArea(cAliasChq)
	Set Filter To &cFiltro
	DbGoTop()
	aHeader := {}
	Aadd( aHeader, { STR0080, "Numero"    , "", Len((cAliasChq)->numero) , 0, ".F.", USADO, "C",, "V" } ) //"Numero"
	Aadd( aHeader, { STR0061, "Banco"     , "", Len((cAliasChq)->Banco)  , 0, ".F.", USADO, "C",, "V" } ) //"Banco"
	Aadd( aHeader, { STR0062, "Agencia"   , "", Len((cAliasChq)->Agencia), 0, ".F.", USADO, "C",, "V" } ) //"Agencia"
	Aadd( aHeader, { STR0063, "Conta"     , "", Len((cAliasChq)->Conta)  , 0, ".F.", USADO, "C",, "V" } ) //"Conta"
	Aadd( aHeader, { STR0090, "Emissao"   , "", 8,0, ".F.", USADO, "D",, "V" } ) //"Emissao"
	Aadd( aHeader, { STR0026, "Saldo"     , "@e 999,999,999.99", 15, 2, ".T.", USADO, "N",, "V" } ) //"Valor"
	Aadd( aHeader, { ""     , "CampoNulo" , "", 1, 0, ".T.", USADO, "C",, "V" } )
	aHeader8 := aClone(aHeader)
	oGetDb8  := (cAliasChq)->(MsGetDb():New(1,2,aPosObj[1,4]-30,aPosObj[1,3]-5,2,,,,.T.,{},,.T.,,cAliasChq,"AllwaysTrue",,,oFolder:aDialogs[8],.F.,.T.))
	oGetDb8:oBrowse:lHScroll := .F.
	oGetDb8:oBrowse:lDisablePaint := .T.
	oFolder:aDialogs[8]:Cargo := {"P",{||Fc021Visual("SEF",(cAliasChq)->Chave,STR0195)}}
Endif
If cAliasCtrc != Nil .And. Select(cAliasCtrc) > 0
	DbSelectArea(cAliasCtrc)
	Set Filter To &cFiltro
	DbGoTop()
	aHeader := {}
	Aadd( aHeader, { "Fil. Deb."	, "FILDEB"  , "", Len((cAliasCtrc)->FILDEB) , 0, ".F.", USADO, "C",, "V" } )
	Aadd( aHeader, { "Fil. Doc"	, "FILDOC"  , "", Len((cAliasCtrc)->FILDOC) , 0, ".F.", USADO, "C",, "V" } )
	Aadd( aHeader, { "Docto."		, "DOC"     , "", Len((cAliasCtrc)->DOC)  , 0, ".F.", USADO, "C",, "V" } )
	Aadd( aHeader, { "Serie"		, "SERIE"   , "", Len((cAliasCtrc)->SERIE), 0, ".F.", USADO, "C",, "V" } )
	Aadd( aHeader, { "Emissão"		, "EMISSAO" , "", 8,0, ".F.", USADO, "D",, "V" } )
	Aadd( aHeader, { "Valor"		, "SALDO"   , "@e 999,999,999.99", 15, 2, ".T.", USADO, "N",, "V" } )
	Aadd( aHeader, { ""     , "CampoNulo" , "", 1, 0, ".T.", USADO, "C",, "V" } )
	aHeader9 := aClone(aHeader)
	oGetDb9  := (cAliasCtrc)->(MsGetDb():New(1,2,aPosObj[1,4]-30,aPosObj[1,3]-5,2,,,,.T.,{},,.T.,,cAliasCtrc,"AllwaysTrue",,,oFolder:aDialogs[9],.F.,.T.))
	oGetDb9:oBrowse:lHScroll := .F.
	oGetDb9:oBrowse:lDisablePaint := .T.
	oFolder:aDialogs[9]:Cargo := {"R",{||Fc021Visual("DT6",(cAliasCtrc)->Chave,"Docto. de Transporte")}} 
Endif
 28/04/2010 aglair */
//aGetDb := {oGetDb1,oGetDb2,oGetDb3,oGetdb4,oGetDb5,oGetDb6,oGetDb7,oGetDb8, oGetDb9 } ABI
//aAlias := {cAliasP,cAliasR,cAliasPc,cAliasPv,cAliasCo,cAliasEmp,cAliasApl,cAliasChq, cAliasCtrc}  ABI
  
aGetDb := {oGetDb1,oGetDb2,oGetDb3,oGetdb4} 
aAlias := {cAliasP,cAliasR,cAliasAR,cAliasAP} 


// Posiciona no primeiro folder valido
For nX := 1 To Len(aAlias)
	Do Case
	Case nX == 1 .And. ValType(aHeader1) == "A"
		aHeader := aClone(aHeader1)
		DbSelectArea(aAlias[nX])
		Exit
	Case nX == 2 .And. ValType(aHeader2) == "A"
		aHeader := aClone(aHeader2)
		DbSelectArea(aAlias[nX])
		Exit
	Case nX == 3 .And. ValType(aHeader3) == "A"
		aHeader := aClone(aHeader3)
		DbSelectArea(aAlias[nX])
		Exit
	Case nX == 4 .And. ValType(aHeader4) == "A"
		aHeader := aClone(aHeader4)
		DbSelectArea(aAlias[nX])
		Exit
	Case nX == 5 .And. ValType(aHeader5) == "A"
		aHeader := aClone(aHeader5)
		DbSelectArea(aAlias[nX])
		Exit
	Case nX == 6 .And. ValType(aHeader6) == "A"
		aHeader := aClone(aHeader6)
		DbSelectArea(aAlias[nX])
		Exit
	Case nX == 7 .And. ValType(aHeader7) == "A"
		aHeader := aClone(aHeader7)
		DbSelectArea(aAlias[nX])
		Exit	
	Case nX == 7 .And. ValType(aHeader8) == "A"
		aHeader := aClone(aHeader8)
		DbSelectArea(aAlias[nX])
	EndCase
Next

ACTIVATE MSDIALOG oDlg ON INIT (aEval(aGetDb, {|e| If(ValType(e)=="0",(e:oBrowse:lDisablePaint := .F., e:oBrowse:Refresh(.T.)),Nil)}),;
									  	  EnchoiceBar(oDlg, {|| oDlg:End() }, {|| oDlg:End()},,aButton),;
										  oFolder:SetOption(2))

// Limpa os filtros dos arquivos temporarios
For nX := 1 To Len(aAlias)
	If aAlias[nX] != Nil .And. Select(aAlias[nX]) > 0
		DbSelectArea(aAlias[nX])
		(aAlias[nX])->(DbClearFil())
	EndIf
Next

RestArea(aArea)
aHeader	:= aClone(aOldHeader)
aCols		:= aClone(aOldaCols)
aRotina	:= aClone(aOldaRotina)
oFluxo:Refresh()
               
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Fc020visua³ Autor ³ Claudio d. de Souza   ³ Data ³ 21/08/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Mostra Detalhe do t¡tulo da tela anal¡tica					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³Fc020Visual(cAlias,cChave) 										  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso	    ³ Gen‚rico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fc021Visual(cAlias,cChave,cTitulo)
Local aArea      := GetArea(),;
		aOldHeader	:= aClone(aHeader),;
		aOldaCols	:= aClone(aCols),;
		aOldaRotina	:= aClone(aRotina),;
		cFilOld     := cFilAnt

If !Empty(cChave)
	cFilAnt := Left(cChave,2)
	dbSelectArea(cAlias)
	dbSetOrder( 1 )
	dbseek( xFilial(cAlias)+SubStr(cChave,3))
	If !(cAlias)->( Eof() )
		cCadastro := OemToAnsi(cTitulo)
		Do Case
		Case cAlias == "SC7"
			MatA120(SC7->C7_TIPO,,,2)
		Case cAlias == "SC5"
			aRotina   := {{ "","AxPesqui", 0 , 1},;	
							   { "","A410Visual", 0 , 2} }
			a410Visual(cAlias,RECNO(),2)
		OtherWise
			AxVisual(cAlias,Recno(),2)
		EndCase
	Endif
	RestArea(aArea)
	aHeader	:= aClone(aOldHeader)
	aCols		:= aClone(aOldaCols)
	aRotina	:= aClone(aOldaRotina)
	cFilant  := cFilOld
Endif	

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Grafico   ºAutor  ³Claudio D. de Souza º Data ³  30/08/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Selecionar o tipo da serie de dados e o tipo de grafico    º±±
±±º          ³ Parametros:                                                º±±
±±º          ³ oDlg   -> Objeto dialog onde sera exibido a tela do graficoº±±
±±º          ³ cAlias -> Alias do arquivo temporario que sera processado  º±±
±±º          ³ nMoeda -> Codigo da moeda                                  º±±
±±º          ³ cTit   -> Titulo do eixo X                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Finc021                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Grafico(oDlg,aFluxo,nMoeda,cTit)
Local oDlgSer
Local oSer
Local oVisual
Local cCbx := STR0099 //"Linha"
Local cVisual := STR0100 //"Projeção do Saldo"
Local nCbx := 1
Local aCbx := { STR0099, STR0101, STR0102, STR0103, STR0104, STR0105,; //"Linha"###"Área"###"Pontos"###"Barras"###"Piramid"###"Cilindro"
					 STR0106, STR0107, STR0108,; //"Barras Horizontal"###"Piramid Horizontal"###"Cilindro Horizontal"
					 STR0109, STR0110, STR0111, STR0112, STR0113, STR0114 } //"Pizza"###"Forma"###"Linha rápida"###"Flexas"###"GANTT"###"Bolha"
Local aVisual := { STR0115, STR0100 } //"Receitas x Despesas"###"Projeção do Saldo"
Local nVisual := 2

DEFINE MSDIALOG oDlgSer TITLE STR0116 FROM 0,0 TO 100,280 PIXEL OF oDlg //"Tipo do gráfico"

@ 008, 005 SAY STR0117 PIXEL OF oDlgSer //"Escolha o tipo de série:"
@ 008, 063 MSCOMBOBOX oSer VAR cCbx ITEMS aCbx SIZE 077, 120 OF oDlgSer PIXEL ON CHANGE nCbx := oSer:nAt
@ 022, 005 SAY STR0118 PIXEL OF oDlgSer //"Tipo de Visualização   :"
@ 022, 063 MSCOMBOBOX oVisual VAR cVisual ITEMS aVisual SIZE 077, 120 OF oDlgSer PIXEL ON CHANGE nVisual := oVisual:nAt
@ 035, 045 BUTTON "&Ok"  SIZE 30,12 OF oDlgSer PIXEL ACTION (MontaGrafico(aFluxo,nCbx,nVisual,nMoeda,cTit),oDlgSer:End())
@ 035, 075 BUTTON STR0040 SIZE 30,12 OF oDlgSer PIXEL ACTION oDlgSer:End() //"&Sair"

ACTIVATE MSDIALOG oDlgSer CENTER

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³MontaGraf ºAutor  ³Claudio D. de Souza º Data ³  30/08/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa os dados necessarios para montagem do grafico e   º±±
±±º          ³ exibe o grafico.                                           º±±
±±º          ³ cAlias  -> Alias do arquivo temporario que sera processado º±±
±±º          ³ nCbx    -> Codigo da serie de dados que sera utilizada peloº±±
±±º          ³            objeto grafico                                  º±±
±±º          ³ nVisual -> Tipo de visualizacao 1-Contas a pagar x Ctas Recº±±
±±º          ³                                 2-Projecao do saldo        º±±
±±º          ³ nMoeda  -> Codigo da moeda                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Finc021                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MontaGrafico(aFluxo,nCbx,nVisual,nMoeda,cTit)
Local oDlg
Local obmp
Local oBold
Local oGraphic
Local nSerie     := 0
Local nSerie2    := 0
Local aArea      := GetArea()
Local aTabela
Local nX := 0
Local oPanel
Local aSize
Local lFlatMode := If(FindFunction("FLATMODE"),FlatMode(),SetMDIChild())
Local lVideo    := .F.

//Verifica se a resolução de vídeo é menor que 1024x768
If oMainWnd:nClientWidth < 1000
	lVideo := .T.
EndIf

aTabela		:= {{	cTit   ,; //"Dia","Semana","Decendio","Quinzena","Mes"
		 			   STR0043,; //"Entradas"
		 				STR0044,; //"Saidas"
		 				STR0045,; //"Saldo do Dia"
		 				STR0046,; //"Var.Dia"
		 				STR0047,; //"Entr.Acumul."
		 				STR0048,; //"Saida Acumul."
		 				STR0049,; //"Saldo Acumul."
		 				STR0050}}
For nX := 1 To Len(aFluxo)
	Aadd(aTabela,{	Pad(Transform(aFluxo[nX,DATAFLUXO],""),17),;
					 	Transform(aFluxo[nX,ENTRADAS				]	,"@e 99,999,999,999.99"),;
						Transform(aFluxo[nX,SAIDAS		  		   ]	,"@e 99,999,999,999.99"),;
						Transform(aFluxo[nX,SALDODIA				]	,"@e 99,999,999,999.99"),;
						Transform(aFluxo[nX,VARIACAODIA			]	,"@r 9999999999999.99%"),;
						Transform(aFluxo[nX,ENTRADASACUMULADAS]	,"@e 99,999,999,999.99"),;
						Transform(aFluxo[nX,SAIDASACUMULADAS	]	,"@e 99,999,999,999.99"),;
						Transform(aFluxo[nX,SALDOACUMULADO		]	,"@e 99,999,999,999.99"),;
						Transform(aFluxo[nX,VARIACAOACUMULADA	]	,"@r 9999999999999.99%")})
Next		 				

aSize := MSADVSIZE()	

DEFINE MSDIALOG oDlg FROM aSize[7],0 TO aSize[6],aSize[5] PIXEL TITLE STR0119 //"Representação gráfica do Fluxo de Caixa"
oDlg:lMaximized := .T.

DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD

// Layout da janela
@ 000, 000 BITMAP oBmp RESNAME "ProjetoAP" oF oDlg SIZE 50, 270 NOBORDER WHEN .F. PIXEL

@ 010, 055 MSGRAPHIC oGraphic SIZE 450, 230 OF oDlg PIXEL

oGraphic:SetTitle(STR0120 + If( nVisual == 1, STR0115, STR0121),"",CLR_HBLUE,3,.F.)
oGraphic:SetMargins( 2, 6, 6, 6 )
oGraphic:bRClicked := {|o,x,y| oMenu:Activate(x,y,oGraphic) } // Posição x,y em relação a Dialog 

MENU oMenu POPUP
	MENUITEM STR0188 Action ConsDadGraf(aTabela) //"Consulta dados do grafico"
ENDMENU

// Habilita a legenda, apenas se houver mais de uma serie de dados.
oGraphic:SetLegenProp( GRP_SCRTOP, CLR_YELLOW, GRP_SERIES, .F.)
nSerie  := oGraphic:CreateSerie(nCbx,,2)

oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,,,25,25,.T.,.T. )

// Adiciona mais uma série de dados, conforme o tipo do grafico
If nVisual == 1 // Contas a Pagar x Contas a Receber
   nSerie2 := oGraphic:CreateSerie(nCbx,,2)
   @ 005, 30 SAY STR0122 OF oPanel COLOR CLR_HBLUE FONT oBold PIXEL //"Receitas"
   @ 013, 30 SAY STR0123 OF oPanel COLOR CLR_HRED  FONT oBold PIXEL //"Despesas"
Endif   

oPanel:Align := CONTROL_ALIGN_BOTTOM

If nSerie != GRP_CREATE_ERR .And. nSerie2 != GRP_CREATE_ERR 
	aEval(aFluxo,{|e|If(nVisual==1,(oGraphic:Add(nSerie ,e[ENTRADASACUMULADAS],Transform(e[DATAFLUXO],""),CLR_HBLUE),;
										  	   oGraphic:Add(nSerie2,e[SAIDASACUMULADAS]  ,Transform(e[DATAFLUXO],""),CLR_HRED)),;
										  		oGraphic:Add(nSerie ,e[SALDOACUMULADO]    ,Transform(e[DATAFLUXO],""),If(e[SALDOACUMULADO]<0,CLR_HRED,CLR_HBLUE)))})
Else
	IW_MSGBOX(STR0124,STR0198,"STOP") //"Não foi possível criar a série."
Endif
                             
oGraphic:SetGradient( GDBOTTOMTOP, CLR_HGRAY, CLR_WHITE )
oGraphic:SetTitle( GetMv("MV_SIMB"+Alltrim(Str(nMoeda,2))),"", CLR_HRED , A_LEFTJUST , GRP_TITLE )
oGraphic:SetTitle( "", cTit, CLR_GREEN, A_RIGHTJUS , GRP_FOOT  ) //"Datas"

@ 005, If(!lVideo,300,200) BUTTON o3D PROMPT "&2D" SIZE 40,14 OF oPanel PIXEL ACTION (oGraphic:l3D := !oGraphic:l3D, o3d:cCaption := If(oGraphic:l3D, "&2D", "&3D"))
@ 005, If(!lVideo,350,250) BUTTON STR0126   SIZE 40,14 OF oPanel PIXEL ACTION GrafSavBmp( oGraphic ) //"&Salva BMP"

If !__lPyme
	@ 005, If(!lVideo,400,300) BUTTON STR0187 SIZE 40,14 OF oPanel PIXEL ACTION PmsGrafMail(oGraphic,STR0119,{STR0120 + If( nVisual == 1, STR0115, STR0121)},aTabela,1) // E-Mail
Endif
@ 005, If(!lVideo,450,350) BUTTON STR0040 SIZE 40,14 OF oPanel PIXEL ACTION oDlg:End() //"&Sair"

If lVideo
	oGraphic:Align := CONTROL_ALIGN_ALLCLIENT
EndIf

ACTIVATE MSDIALOG oDlg CENTER
RestArea(aArea)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Fc021ImpFlx³ Autor ³ Claudio Donizete 	  ³ Data ³ 23/08/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime o Fluxo de Caixa											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso	    ³ FINC021																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fc021ImpFlx(aBancos,lSaldoBanc,nCaixas,nBancos,nAtrPagar,;
									 nAtrReceber,aFluxo,cTit,cMoeda,lLimCred)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis 														  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1 :=OemToAnsi(STR0132) //"Este programa ir  imprimir o Fluxo de Caixa."s //"Este programa imprimirá o Fluxo de Caixa."
Local cDesc2 :=""
Local cDesc3 :=""
Local lRetImp := .T.

Private aReturn:={STR0133,1,STR0134,1,2,1,"",1} //"Zebrado"###"Administracao" //"Zebrado"###"Administracao"
Private cabec1,cabec2,nLastKey:=0,titulo,wnrel,tamanho:="P"
Private nomeprog :="NSFINC021"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos												  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Titulo:= STR0032 + STR0197 + Capital(SubStr(cMoeda,3)) // "Fluxo de Caixa em " //" em "
cabec1:= Pad(cTit, IIf(cTit == "HI", 18, 24))+STR0135 //"Data             " + "A Pagar       A Receber      Disponivel"
cabec2:= ""

//Altera o tamanho do formulario
tamanho := IIf(cTit == "HI", "P", "M")

//Ponto de entrada pela Microsiga
If ExistBlock("FC021TIT")
	ExecBlock("FC021TIT",.F.,.F.,Titulo)
Endif
 
// Ponto de entrada para possibilitar ou nao a impressao
If ExistBlock("FC021IMP")
	lRetImp:=ExecBlock("FC021IMP",.F.,.F.)
Endif


wnrel:="NSFINC021"            //Nome Default do relatorio em Disco
If lRetImp
	wnrel:=SetPrint("SE1",wnrel,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,Tamanho,,.F.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn)
	
	If nLastKey == 27
		Return
	Endif
	
	RptStatus({|lEnd| Fc021ImpOk(@lEnd,wnRel,aBancos,lSaldoBanc,nCaixas,nBancos,nAtrPagar,nAtrReceber,aFluxo,lLimCred,cTit)},Titulo)
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Fc021ImpOk ³ Autor ³ Claudio Donizete 	  ³ Data ³ 23/08/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime o Fluxo de Caixa.											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso	    ³ FINC021																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fc021ImpOk(lEnd,wnRel,aBancos,lSaldoBanc,nCaixas,nBancos,nAtrPagar,nAtrReceber,aFluxo,lLimCred,cTit)
Local nX := 0
Local nTotReceitas := 0
Local nTotDespesas := 0
Local nDisponivel  := 0
Local nLimCrdBco	 := 0
Local nLimCrdCx	 := 0
Local aArea := GetArea()
Local cBancoCx := GetMV("MV_CARTEIR")

DEFAULT lLimCred := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt  := Space(10)
cbcont := 00
li  := 80
m_pag  := 01

SetRegua(Len(aFluxo)+Len(aBancos))

If lSaldoBanc
	If Len(aBancos) > 0
		If ( li > 58 )
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		EndIf
		@ ++li, 0 PSAY	STR0201 //"Banco                      Agencia           Conta                    Saldo"
		//"Banco"###"Agencia"###"Conta"###"Nome"
	Endif
	For nX := 1 To Len(aBancos)
		IncRegua()
		// Se imprime saldos bancarios e o saldo eh maior que zero, imprime
		If aBancos[nX][1] .And. (Fc021Val(aBancos[nX,6]) != 0)
			
			If ( li > 58 )
				@ ++li, 0 PSAY	STR0201 //"Banco                      Agencia           Conta                    Saldo"
		                 //12345678901234567890123456789012345678901234567890123456789012345678901234567890
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			EndIf
			li++
			@li, 0 PSAY	Pad(aBancos[nX,2]+"-"+aBancos[nX,5],13)+;
							PadL(aBancos[nX,3],11)+PadL(aBancos[nX,4],14)
			@li,44 PSAY aBancos[nX,6]
			If lLimCred
				@li,66 PSAY aBancos[nX,8]  //Limite de crédito
			Endif
			If lLimCred
				If (Left(aBancos[nX][2],2)=="CX" .Or. Left(aBancos[nX][2],3) $ cBancoCx)
					nLimCrdCx  += Fc021Val(aBancos[nX][8])
				Else	
					nLimCrdBco += Fc021Val(aBancos[nX][8])
				Endif	
			Endif
		EndIf
	Next
	If ( li > 55 )
		li := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
	EndIf
	If ( nBancos+nCaixas != 0 )
		@++li,00 PSay Repl("-",80)
	Endif	
	If ( nBAncos != 0)
		li++
		@li, 0 PSAY STR0136 //"Total em Bancos : "
		@li,40 PSAY nBancos	 Picture tm(nBancos,18)
		If lLimCred .and. ( nLimCrdBco != 0)
			@li,62 PSAY nLimCrdBco Picture tm(nLimCrdBco,18)
		Endif
	EndIf
	If ( nCaixas != 0 )
		li++
		@li, 0 PSAY STR0137 //"Total em Caixa : "
		@li,40 PSAY nCaixas	 Picture tm(nCaixas,18)
		If lLimCred .and. ( nLimCrdCx != 0)
			@li,62 PSAY nLimCrdCx Picture tm(nLimCrdCx,18)
		Endif
	EndIf
	If ( nBancos+nCaixas != 0 )
		li++
		@li, 0 PSAY STR0138 //"Total Disponivel : "
		@li,40 PSAY nBancos+nCaixas	Picture tm(nBancos+nCaixas,18)
		If lLimCred .and. nLimCrdBco+nLimCrdCx != 0
			@li,62 PSAY nLimCrdBco+nLimCrdCx	Picture tm(nLimCrdBco+nLimCrdCx,18)
		Endif	
	EndIf
	@++li,00 PSay Repl("-",80)
EndIf

nDisponivel := (nBancos+nCaixas+nLimCrdBco+nLimCrdCx)
nDisponivel += (nAtrReceber - nAtrPagar)

li++
For nX := 1 TO Len(aFluxo)
	IF lEnd
		@PROW()+1,001 PSAY STR0139 //"CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	EndIF

	IncRegua()

	If li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
	End

	nDisponivel -= aFluxo[nX][SAIDAS]
	nDisponivel += aFluxo[nX][ENTRADAS]

	If aFluxo[nX][SAIDAS]+aFluxo[nX][ENTRADAS] != 0
		@li,00 PSay Left(aFluxo[nX][DATAFLUXO],19)
		@Prow(),PCOL()+1 PSay aFluxo[nX][ENTRADAS]  picture TM(aFluxo[nX][ENTRADAS],18)
		@Prow(),PCOL()+1 PSay aFluxo[nX][SAIDAS]    picture TM(aFluxo[nX][SAIDAS],18)		
		@Prow(),PCOL()+1 Psay (aFluxo[nX][SAIDAS]/aFluxo[nX][ENTRADAS])*100 Picture "@E 99999.99%"
		@Prow(),PCOL()+1 PSay nDisponivel  picture TM(nDisponivel,18)
		li ++
	Endif

	nTotDespesas += aFluxo[nX][SAIDAS]
	nTotReceitas += aFluxo[nX][ENTRADAS]

Next

If li+9 > 55
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
End

@li++,00 PSay Repl("-",IIf(cTit == "HI", 80, 86))
@li++,00 PSay STR0186 + Transform(nAtrReceber,"@E 999,999,999,999.99") //"Total de Atrasados a Receber : "
@li++,00 PSay STR0140 + Transform(nAtrPagar,"@E 999,999,999,999.99") //"Total de Atrasados a Pagar   : "
@li++,00 PSay STR0202 + Transform(nLimCrdBco+nLimCrdCx+nBancos+nCaixas,"@E 999,999,999,999.99") //"Saldo             : "
@li++,00 PSay STR0141 + Transform(nBancos+nCaixas,"@E 999,999,999,999.99") //"Disponibilidade   : "
@li++,00 PSay STR0142 + Transform(nTotReceitas,"@E 999,999,999,999.99") //"Total A Receber   : "
@li++,00 PSay STR0143 + Transform(nTotDespesas,"@E 999,999,999,999.99") //"Total A Pagar     : "
@li++,00 PSay STR0144 + Transform(nDisponivel,"@E 999,999,999,999.99") //"Saldo             : "
@li++,00 PSay Repl("-",IIf(cTit == "HI", 80, 86))

roda(cbcont,cbtxt)

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()
RestArea(aArea)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Fc021SimulºAutor  ³Claudio D. de Souza º Data ³  30/08/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Simulacao do fluxo de caixa                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Finc021                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fc021Simul(aFluxo,oFluxo,nBancos,nCaixas,nAtrReceber,nAtrPagar,;
									nMoeda,nDias,aPeriodo,nLimCred)
Local oGet					 ,;
		aArea := GetArea(),;
		aOldHeader := aClone(aHeader),;
		oDlg              ,;
		nOpca					,;
		lNaoTemSimul	   ,;
		nIndPer				,;
		nAscan
Local aCopiaCols	:= {}
Local nX := 0		
LocaL	aButSimul := {	{"PRINT03", {|| Fc021ImpSi()}, STR0210,STR0211},; //"Imprime Simulação"###"Imprimir"
							{"SALVAR",{||Fc021GrvSim(aFluxo,oFluxo,nBancos,nCaixas,nAtrReceber,nAtrPagar,nMoeda)},STR0145,STR0212},; //"Grava Simulação"
						  	{"ALTERA",{||Fc021RstSim(aFluxo,oFluxo,nBancos,nCaixas,nAtrReceber,nAtrPagar,nMoeda,lNaoTemSimul,nDias,aPeriodo,nLimCred)},STR0146,STR0213}} //"Restaura Simulação"
		
lNaoTemSimul := (aCols == Nil .Or. Empty(aCols) .Or. Empty(aCols[1][3]))
// Cria aCols caso nao exista, ou esteja vazia e nao permite a opcao de
// nova simulacao pois os valores da simulacao atual sao abatidos do Fluxo.
If lNaoTemSimul
	LimpaACols()
Else
	Aadd(aButSimul,{"EDIT"  ,{||Fc021NovSim(aFluxo,oFluxo,nBancos,nCaixas,nAtrReceber,nAtrPagar,aPeriodo,nLimCred)},STR0151,STR0151}) //"Nova"
Endif	

aSort(aCols,,,{|x,y| DTOS(x[1]) < DTOS(y[1])})

DEFINE MSDIALOG oDlg TITLE STR0147 From 9,0 To 28,93 OF oMainWnd //"Fluxo de Caixa - Simulação"
oGet := MSGetDados():New(12,2,140,370,3,{||Fc021LinOk(aPeriodo)},,,.T.,{"_SI_DATA","_SI_TIPO","_SI_VALOR","_SI_HISTOR"},,,99999)
oGet:oBrowse:lHScroll := .F.

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,;
														 {||nOpca:=1,If(oGet:TudoOk(),oDlg:End(),nOpca := 0)},;
														 {||nOpca:=0,oDlg:End()},,;
														 aButSimul) CENTER

If nOpca == 1
	For nX := 1 To Len(aCols)
		// Se a linha nao estiver deletada
		If !aCols[nX][Len(aCols[nX])] .And. !Empty(aCols[nX][3])
			// Pesquisa a Data da Simulacao
			nIndPer := Ascan(aPeriodo,{|e| e[1] == aCols[nX][1]})
			If nIndPer > 0
				nAscan := Ascan(aFluxo,	{|e| aPeriodo[nIndPer][2] $ e[DATAFLUXO]})
				// Valor diferente, significa alteracao ou nova entrada/saida na simulacao
				If aCols[nX][5] != aCols[nX][3] 
					If aCols[nX][2] == "R"
						aFluxo[nAscan][ENTRADAS] -= aCols[nX][5] // Tira o valor antigo
						aFluxo[nAscan][ENTRADAS] += aCols[nX][3] // Guarda o novo valor
					Else
						aFluxo[nAscan][SAIDAS]   -= aCols[nX][5] // Tira o valor antigo
						aFluxo[nAscan][SAIDAS]   += aCols[nX][3] // Guarda o novo valor
					Endif	
 					aCols[nX][5] := aCols[nX][3] // Guarda o novo valor em valor antigo
				Endif
			Endif	
			Aadd(aCopiaCols,aCols[nX]) // Copia as linhas nao deletadas de aCols
		ElseIf aCols[nX][Len(aCols[nX])] // Linha deletada, exclui lancamento
			// Pesquisa a Data da Simulacao
			nIndPer := Ascan(aPeriodo,{|e| e[1] == aCols[nX][1]})
			If nIndPer > 0
				nAscan := Ascan(aFluxo,	{|e| aPeriodo[nIndPer][2] $ e[DATAFLUXO]})
				If aCols[nX][2] == "R"
					aFluxo[nAscan][ENTRADAS] -= aCols[nX][5] // Tira o valor antigo
				Else
					aFluxo[nAscan][SAIDAS]   -= aCols[nX][5] // Tira o valor antigo
				Endif	
			Endif	
		EndIf
	Next
	aCols := aClone(aCopiaCols) // Copia as linhas nao deletadas para aCols
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Recalcula o saldo ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
	CalcSaldo(aFluxo,nBancos,nCaixas,nAtrReceber,nAtrPagar,nLimCred)
	oFluxo:Refresh()
Endif

// Restaura ambiente
RestArea(aArea)
aHeader := aClone(aOldHeader)
		
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Fc021LinOkºAutor  ³Claudio D. de Souza º Data ³  11/10/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida a linha da GetDados da Simulacao                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Finc021                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fc021LinOk(aPeriodo)
Local lRet := .F.

Do Case
Case !aCols[n][Len(aCols[1])] .And. (Empty(aCols[n][1]) .Or. aCols[n][1] < dDataBase)
	IW_MsgBox(STR0148 + DTOC(dDataBase),STR0198, "STOP") //"E necessario informar uma data maior ou igual a "
Case !aCols[n][Len(aCols[1])] .And. !aCols[n][2] $ "RD"
	IW_MsgBox(STR0149,STR0198, "STOP")	 //"E necessario informar um tipo válido de simulação (R=Receita ou D=Despesa)"
Case !aCols[n][Len(aCols[1])] .And. aCols[n][3] <= 0
	IW_MsgBox(STR0150,STR0198, "STOP") //"E necessario informar um valor maior que zero"
Case !aCols[n][Len(aCols[1])] .And. (Ascan(aPeriodo,	{|e| e[1] == aCols[n][1]}) == 0)
	IW_MsgBox(STR0183 + DTOC(aPeriodo[Len(aPeriodo)][1]),STR0198, "STOP") //"E necessario informar uma data menor ou igual a "
OtherWise
	lRet := .T.
EndCase
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Fc021GrvSim³ Autor ³ Claudio D. de Souza  ³ Data ³ 11/10/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Salva 	simula‡äes em disco. 				       		     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso	    ³ FINC021																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fc021GrvSim(aFluxo,oFluxo,nBancos,nCaixas,nAtrReceber,nAtrPagar,nMoeda)

LOCAL cArquivo := space(8)
LOCAL nX := 0
LOCAL nHdl	:= 0
LOCAL cDate := SET(_SET_DATEFORMAT)

If !Empty(aCols[1,3])

	cArquivo := cGetFile(STR0152, STR0153) //"Simulação | *.SIM"###"Informe o arquivo de simulação"
	
	If !Empty( cArquivo ) .and. Left( Alltrim( cArquivo ) ,1) # "*"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³	Verifica se o arquivo j  existe e pergunta se   ³
		//³	quer sobrepor. 										   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cArquivo := Alltrim( cArquivo )
	
		If Upper(Right(cArquivo,4)) # ".SIM"
			cArquivo += ".SIM"
		Endif
	
		IF File(cArquivo)
			IF !MsgYesNo( STR0154 + cArquivo + "?" , STR0155 ) //"Sobregrava "###"Arquivo J  Existe !" //"Sobregravar "###"Arquivo já existe!"
				Return Nil
			Endif
		Endif
		nHdl:=fCreate(cArquivo)
		If nHdl == -1
			IW_MSGBOX(STR0156 + Str(fError(),2),STR0198,"STOP") //"Erro na criação do arquivo - Erro DOS Nº"
		Else	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ao se gravar o arquivo de simula‡Æo, desligo a op‡Æo de ano³
			//³	com 4 digitos para que uma simula‡Æo possa ser restaurada³
			//³	por qualquer usu rio, utilizando ele 2 ou 4 digitos/ano  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SET(_SET_DATEFORMAT, "DD/MM/YY")
			For nX := 1 to Len( aCols )
				If !aCols[nX][Len(aCols[1])] // Se a Linha nao estiver deletada
					cCampo := dtoc(acols[nX,1]) + Str(aCols[nX,3],15,2) + ;
								 aCols[nX,2] + aCols[nX,4] + Str(nMoeda,1,0)
					fWrite( nHdl,cCampo+CHR(13)+CHR(10),Len(cCampo)+2 )
				Endif	
			Next
			fClose(nHdl)
			SET(_SET_DATEFORMAT,cDate)
		Endif	
	Endif
Endif
	
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Fc021RstSim³ Autor ³ Claudio D. de Souza  ³ Data ³ 11/10/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Restaura 	simula‡äes do disco. 								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso	    ³ FINC021																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fc021RstSim(aFluxo,oFluxo,nBancos,nCaixas,nAtrReceber,nAtrPagar,;
									 nMoeda,lGravado,nDias,aPeriodo,nLimCred)
Local cFile 	:= ""
Local xBuffer  := ""
Local nX 		:= 0
Local nY  		:= 0
Local dData 	:= Ctod("")
Local nValor	:= 0
Local cTipo 	:= ""
Local cHistor  := ""
Local nLen

cFile := cGetFile(STR0152, STR0157) //"Simulação | *.SIM"###"Selecione o arquivo de simulação"
If !Empty(cFile) .and. File( cFile )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  Se j  houver uma simula‡…o em mem¢ria, pergunta se ³
	//³  haver  sobreposi‡Æo.									     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF !Empty(aCols[1,3])
		IF MsgYesNo( STR0158, STR0159) //"Salva simulação existente"###"Existe simulação"
			Fc021GrvSim(aFluxo,oFluxo,nBancos,nCaixas,nAtrReceber,nAtrPagar,nMoeda)
		Endif
		If lGravado
			For nX := 1 to Len(aCols)
				If !aCols[nX][Len(aCols[1])] // Se a linha nao estiver deletada
					For nY := 1 to Len(aPeriodo)
						If aPeriodo[nY,1] == aCols[nX,1]
							IF Left(aCols[nX,2],1) == "D"
								aFluxo[nY][SAIDAS]   -= aCols[nX,3]
							Else
								aFluxo[nY][ENTRADAS] -= aCols[nX,3]
							EndIf
						Endif
					Next
				Endif	
			Next
		Endif	
	Endif
	LimpaAcols()
	nHdl:=fOpen(cFile,0+64)
	nLidos:=0
	fSeek(nHdl,0,0)
	nTamArq:=fSeek(nHdl,0,2)
	FSEEK(nHdl,0,0)
	nLen := 70
	xBuffer:=Space(nLen)
	fRead(nHdl,@xBuffer,nLen)
	// Indica arquivo de simulacao no formato antigo, antes de ser aumentado o
	// tamanho do campo valor
	If At("/",SubStr(xBuffer,9)) == 55 
		nLen := 60
	Else
		nLen := 67	
	Endif
	FSEEK(nHdl,0,0) // Reposiciona no inicio do arquivo off-set 0,0
	While nLidos < nTamArq
		xBuffer:=Space(nLen)
		fRead(nHdl,@xBuffer,nLen)
		dData 	:= ctod( Subst( xBuffer,01,08),"ddmmyy" )
		nValor	:= val( Subst( xBuffer,09,If(nLen=60,10,15)) )
		cTipo 	:= Subst( xBuffer,If(nLen==60,19,24),01 )
		cHistor  := Subst( xBuffer,If(nLen==60,20,25),40 )
		cSimMoeda:= Subst( xBuffer,If(nLen==60,60,65),01 )

		If (dData >= dDataBase .And. dData <= dDataBase+nDias-1)
			If Len(aCols) == 1
				If Empty(aCols[1,3])
					nPointer := 1
				Else
					LimpaACols(.F.)
					nPointer := 2
				Endif
			Else
				LimpaACols(.F.)
				nPointer := Len(aCols)
			Endif
			aCols[nPointer,1] := dData
			aCols[nPointer,2] := cTipo
			aCols[nPointer,3] := xMoeda(nValor,Int(Val(cSimMoeda)),nMoeda)
			aCols[nPointer,4] := cHistor
		EndIf	
		nLidos += nLen
	EndDo
	fClose(nHdl)
	// Ordena por data
	aSort(aCols,,,{|x,y| DTOS(x[1]) < DTOS(y[1])})
	// Recalcula o saldo
	CalcSaldo(aFluxo,nBancos,nCaixas,nAtrReceber,nAtrPagar,nLimCred)
	oFluxo:Refresh(.f.)
Endif


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Fc021NovSim³ Autor ³ Claudio D. de Souza  ³ Data ³ 10/10/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Reseta simulacoes da mem¢ria. 				   				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso	    ³ FINC021																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fc021NovSim(aFluxo,oFluxo,nBancos,nCaixas,nAtrReceber,nAtrPagar,;
									 aPeriodo,nLimCred)
Local nX    := 0
Local nAscan:= 0
Local nIndPer

If !Empty(aCols[1,3])
	IF MsgYesNo(STR0160,	STR0161) //"Confirma ?"###"Nova Simula‡„o" //"Confirma?"###"Nova Simulação"
		For nX := 1 to Len(aCols)
			If !aCols[nX][Len(aCols[1])] .And. !Empty(aCols[nX][5]) // Se a linha nao estiver deletada
				nIndPer := Ascan(aPeriodo,{|e| e[1] == aCols[nX][1]})
				If nIndPer > 0
					nAscan := Ascan(aFluxo,	{|e| aPeriodo[nIndPer][2] $ e[DATAFLUXO]})
					IF aCols[nX][2] == "R"
						aFluxo[nAscan][ENTRADAS] -= aCols[nX][5]
					Else
						aFluxo[nAscan][SAIDAS] -= aCols[nX][5]
					End
				Endif	
			Endif	
		Next
		LimpaAcols()
		CalcSaldo(aFluxo,nBancos,nCaixas,nAtrReceber,nAtrPagar,nLimCred)
		oFluxo:Refresh(.f.)
	Endif
Endif	
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³TemFluxoDat³ Autor ³ Claudio D. de Souza  ³ Data ³ 10/10/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se existe dados para a data na matriz de periodos ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso	    ³ FINC021																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TemFluxoData(dData, aFluxo)
Local nAscan
	nAscan := Ascan(aFluxo, {|e|e[DATAFLUXO]==dData})
	If nAscan == 0
		Aadd(aFluxo, {dData,0,0,0,0,0,0,0,0})
		nAscan := Len(aFluxo)
	Endif
Return nAscan

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³LimpaACols ³ Autor ³ Claudio D. de Souza  ³ Data ³ 10/10/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Limpa a variavel aCols                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso	    ³ FINC021																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LimpaAcols(lZera)
Local nLenaCols
DEFAULT lZera := .T. // Indica se deve zerar a matriz

	If lZera
		aCols := {}
	Endif	
	Aadd(aCols,Array(Len(aHeader)+1))
	nLenaCols := Len(aCols)
	Aeval(aHeader, { |e,nX|	If(e[8] == "D", aCols[nLenaCols][nX] := dDataBase,;
									If(e[8] == "N", aCols[nLenaCols][nX] := 0       ,;
									If(e[8] == "C" .And. !Empty(e[1])       ,;
								   	    aCols[nLenaCols][nX] := Space(e[4])           ,;
										aCols[nLenaCols][nX] := "")))})
	aCols[nLenaCols][Len(aCols[1])] := .F. // Indica que a linha nao esta deletada
	
Return Nil
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Fc021ChFol³ Autor ³Claudio D. de Souza    ³ Data ³03.09.2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de Tratamento dos Folders da consulta analitica Fluxo³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fc021ChFol(nFldDst,nFldAtu,oFolder,oDlg,aTotais,oSayTotal,oGetTotal,;
									nTotal,cPeriodo,aGetDb,aAlias,aHeader1,aHeader2,aHeader3,;
									aHeader4,aHeader5,aHeader6,aHeader7,aHeader8,aHeader9)
Local lRetorno:= .T.
Local oBold
Local nAscan

DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD

// Se o Folder Destino puder ser exibido, seleciona o arquivo
If aAlias[nFldDst] != Nil .And. Select(aAlias[nFldDst]) > 0
	DbSelectArea(aAlias[nFldDst])
	DbGoTop()
Else
	lRetorno := .F. // Desabilita o Folder
EndIf
If lRetorno
	IF ValType(aGetDb[nFldAtu]) == "O"
		aGetDb[nFldAtu]:oBrowse:lDisablePaint := .T.
	Endif	
	Do Case
		Case ( nFldDst == 1 )
			aHeader := aClone(aHeader1)
			oSayTotal:cCaption := STR0236 //"Total de Titulos a Pagar"
		Case ( nFldDst == 2 )
			aHeader := aClone(aHeader2)
			oSayTotal:cCaption := STR0162 //"Total de Titulos a Receber"
		Case ( nFldDst == 3 )
			aHeader := aClone(aHeader3)
			oSayTotal:cCaption := STR0230//"Total de Titulos a receber vencidos "
		Case ( nFldDst == 4 )
			aHeader := aClone(aHeader4)
			oSayTotal:cCaption := STR0233 //"Total de Titulos a pagar Vencudos"
		Case ( nFldDst == 5 )
			aHeader := aClone(aHeader5)
			oSayTotal:cCaption := STR0165 //"Total de Comissões"
		Case ( nFldDst == 6 )
			aHeader := aClone(aHeader6)
			oSayTotal:cCaption := STR0166 //"Total de Empréstimos"
		Case ( nFldDst == 7 )
			aHeader := aClone(aHeader7)
			oSayTotal:cCaption := STR0167 //"Total de Aplicações"
		Case ( nFldDst == 8 )
			aHeader := aClone(aHeader8)
			oSayTotal:cCaption := STR0196 // "Total de cheques pendentes"
		Case ( nFldDst == 9 )
			aHeader := aClone(aHeader9)
			oSayTotal:cCaption := "Total de Doctos. Transporte"				
	EndCase
	nAscan := Ascan( aTotais[nFldDst], {|e|Transform(e[1],"") = cPeriodo})
	nTotal := 0
	If nAscan > 0
		nTotal := aTotais[nFldDst][nAscan][2]
	Endif	
	oGetTotal:Refresh()
	oSayTotal:Refresh()
	If ValType(aGetDb[nFldDst]) == "O"
		aGetDb[nFldDst]:oBrowse:lDisablePaint := .F.
		aGetDb[nFldDst]:oBrowse:Refresh(.T.)
	Endif	
Endif	
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Fc021Edit ºAutor  ³Claudio D. de Souza º Data ³  04/09/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Permite a alteracao da data do credito/debito de um titulo º±±
±±º          ³ simulando a entrada/saida em nova data                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Finc021                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fc021Proj(oDlg,aFluxo,aAliasAna,oFolder,aGetDb,aTotais,nBancos,;
								  nCaixas,nAtrReceber,nAtrPagar,nTotal,aPeriodo,nLimCred)
Local oDlgProj, nOpcA
LOCAL oBold
LOCAL cCarteira := oFolder:aDialogs[oFolder:nOption]:Cargo[1]
LOCAL nCampSin  := If(cCarteira=="R", ENTRADAS, SAIDAS)
LOCAL dDataProj := (aAliasAna[oFolder:nOption])->DataX
LOCAL aArea 	 := GetArea()
LOCAL nAscan, nIndPerAtu, nIndPerProj
LOCAL nValor    := (aAliasAna[oFolder:nOption])->Saldo

dbSelectArea(aAliasAna[oFolder:nOption])

DEFINE MSDIALOG oDlgProj FROM 0,0 TO 140,304 TITLE STR0174 Of oMainWnd PIXEL  //"Fluxo de Caixa - Projeção"
DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
@ 0, 0 BITMAP oBmp RESNAME "PROJETOAP" oF oDlgProj SIZE 35,155 NOBORDER WHEN .F. PIXEL
@ 11 ,35  TO 13 ,400 LABEL '' OF oDlgProj PIXEL
@ 3  ,37  SAY STR0175 Of oDlgProj PIXEL SIZE 35 ,9 FONT oBold //"Projeção de fluxo de caixa"
@ 19,050 SAY STR0026 			  OF oDlgProj PIXEL //"Valor"
@ 19,090 MSGET nValor WHEN .F. OF oDlgProj SIZE 60,9 PIXEL PICTURE "@E 999,999,999.99"
@ 29,050 SAY STR0184 		  OF oDlgProj PIXEL //"Data Atual"
@ 29,110 MSGET DataX WHEN .F.  OF oDlgProj SIZE 40,9 PIXEL
@ 39,050 SAY STR0176 	  OF oDlgProj PIXEL //"Projetar Para"
@ 39,110 MSGET dDataProj		  OF oDlgProj SIZE 40,9 PIXEL VALID dDataProj != (aAliasAna[oFolder:nOption])->DataX

DEFINE SBUTTON FROM 55,52 TYPE 1 ENABLE OF oDlgProj ACTION (nOpcA := 1, oDlgProj:End())
DEFINE SBUTTON FROM 55,90 TYPE 2 ENABLE OF oDlgProj ACTION (nOpcA := 0, oDlgProj:End())

ACTIVATE MSDIALOG oDlgProj CENTERED

If nOpcA == 1
	If ExistBlock("FC021PROJ")
		ExecBlock("FC021PROJ", .F. ,.F., { (aAliasAna[oFolder:nOption])->Apelido, (aAliasAna[oFolder:nOption])->CHAVE, dDataProj } )
	Endif
	// Pesquisa a data na matriz de referencia de periodos para localizar o fluxo pelo periodo
	// e nao pela data, se projetou para uma data dentro do periodo do Fluxo, atualiza as
	// informacoes na matriz de Fluxo, Totais e no arquivo temporario de fluxo analitico
	nIndPerAtu := Ascan(aPeriodo, {|e| e[1] == (aAliasAna[oFolder:nOption])->DataX})
	nIndPerProj:= Ascan(aPeriodo, {|e| e[1] == dDataProj})
	If nIndPerAtu > 0 .And. nIndPerProj > 0
		aGetDb[oFolder:nOption]:oBrowse:lDisablePaint := .T.
		// Subtrai da data atual
		nAscan := Ascan(aFluxo,	{|e| aPeriodo[nIndPerAtu][2] $ e[DATAFLUXO]})
		If nAscan > 0
			aFluxo[nAscan][nCampSin] -= nValor
		Endif	
		// Subtrai a matriz de totais do fluxo analitico tambem
		nAscan := Ascan(aTotais[oFolder:nOption], {|e|aPeriodo[nIndPerAtu][2] $ e[DATAFLUXO]})
		If nAscan > 0
			aTotais[oFolder:nOption][nAscan][2] -= nValor
			nTotal -= nValor
		Endif
		// Transfere o valor para a nova data
		nAscan := Ascan(aFluxo,	{|e| aPeriodo[nIndPerProj][2] $ e[DATAFLUXO]})
		If nAscan > 0
			aFluxo[nAscan][nCampSin] += nValor
		Endif	
		nAscan := Ascan( aTotais[oFolder:nOption], {|e|aPeriodo[nIndPerProj][2] $ e[DATAFLUXO]})
		If nAscan > 0
			aTotais[oFolder:nOption][nAscan][2] += nValor
		Endif
		DbSelectArea(aAliasAna[oFolder:nOption])
		nOrder := IndexOrd()
		DbSetOrder(0)
		RecLock(aAliasAna[oFolder:nOption], .F.)
		// Transfere o fluxo analitico para o novo periodo/Data
		(aAliasAna[oFolder:nOption])->DataX   := dDataProj				 
		(aAliasAna[oFolder:nOption])->Periodo := aPeriodo[nIndPerProj][2]
		MsUnlock()
		DbSetOrder(nOrder)
		CalcSaldo(aFluxo,nBancos,nCaixas,nAtrReceber,nAtrPagar,nLimCred)
		aGetDb[oFolder:nOption]:oBrowse:lDisablePaint := .F.
		aGetDb[oFolder:nOption]:ForceRefresh()
	Else
		IW_MSGBOX(STR0185,STR0198,"STOP") //"Nao eh possivel projetar para uma data fora do periodo do fluxo de caixa"
	Endif
	/*
	If oDlg != Nil
   	aEval(oDlg:aControls, {|e| If(ValType(e) == "O", e:Refresh(), Nil) } )
	Endif
	*/
Endif
RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CriaTmpAnaºAutor  ³Claudio D. de Souza º Data ³  08/10/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Criar os arquivos analiticos do Fluxo de Caixa             º±±
±±º          ³ Parametro:                                                 º±±
±±º          ³ nArquivo   Numero do arquivo que sera criado               º±±
±±º          ³ Retorno:                                                   º±±
±±º          ³ aRet                                                       º±±
±±º          ³ aRet[1] - Alias do arquivo temporario							  º±±
±±º          ³ aRet[2] - Nome do arquivo temporario                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINC021                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION CriaTmpAna(nArquivo)
LOCAL aCposAna,;
		cAliasAna,;
		cArqAna ,;
		cChave

cChave := "Dtos(DataX)+Numero"

Do Case
Case nArquivo == 1 // Emprestimos
	aCposAna := {}
	Aadd( aCposAna, { "Periodo" , "C",  20, 0 } )
	Aadd( aCposAna, { "DATAX"   , "D", 08, 0} )
	Aadd( aCposAna, { "NUMERO"  , "C", TamSx3("EH_NUMERO")[1], 0 } )
	Aadd( aCposAna, { "BANCO"   , "C", TamSx3("EH_BANCO")[1], 0 } )
	Aadd( aCposAna, { "AGENCIA" , "C", TamSx3("EH_AGENCIA")[1], 0 } )
	Aadd( aCposAna, { "CONTA"   , "C", TamSx3("EH_CONTA")[1], 0 } )
	Aadd( aCposAna, { "EMISSAO" , "D",  8, 0 } )
	Aadd( aCposAna, { "SALDO"   , "N", TamSx3("EH_SALDO")[1], TamSx3("EH_SALDO")[2]})
	Aadd( aCposAna, { "CHAVE"   , "C", 40, 0 } )
	Aadd( aCposAna, { "Apelido" , "C", 10, 0 } )
		
	cAliasAna := "cArqAnaEmp"  // Alias do arquivo analitico
Case nArquivo == 2 // Aplicacoes
	aCposAna := {}
	Aadd( aCposAna, { "Periodo" , "C",  20, 0 } )
	Aadd( aCposAna, { "DATAX"   , "D", 08, 0} )
	Aadd( aCposAna, { "NUMERO"  , "C", TamSx3("EH_NUMERO")[1], 0 } )
	Aadd( aCposAna, { "BANCO"   , "C", TamSx3("EH_BANCO")[1], 0 } )
	Aadd( aCposAna, { "AGENCIA" , "C", TamSx3("EH_AGENCIA")[1], 0 } )
	Aadd( aCposAna, { "CONTA"   , "C", TamSx3("EH_CONTA")[1], 0 } )
	Aadd( aCposAna, { "EMISSAO" , "D",  8, 0 } )
	Aadd( aCposAna, { "SALDO"   , "N", TamSx3("EH_SALDO")[1], TamSx3("EH_SALDO")[2]})
	Aadd( aCposAna, { "CHAVE"   , "C", 40, 0 } )
	Aadd( aCposAna, { "Apelido" , "C", 10, 0 } )
		
	cAliasAna := "cArqAnaApl"  // Alias do arquivo analitico
Case nArquivo == 3 // Pedidos de compras
	aCposAna := {}
	Aadd( aCposAna, { "Periodo", "C",  20, 0 } )
	Aadd( aCposAna, { "DATAX"  , "D", 08, 0} )
	Aadd( aCposAna, { "NUMERO" , "C", TamSx3("C7_NUM")[1], 0 } )
	Aadd( aCposAna, { "EMISSAO", "D",  8, 0 } )
	Aadd( aCposAna, { "CLIFOR" , "C", TamSx3("E5_CLIFOR")[1], 0 } )
	Aadd( aCposAna, { "TIPO"   , "N", TamSx3("C7_TIPO")[1], 0 } )
	Aadd( aCposAna, { "ITEM"   , "C", TamSx3("C7_ITEM")[1], 0 } )
	Aadd( aCposAna, { "NomCliFor", "C", TamSx3("A1_NOME")[1], 0 } )
	Aadd( aCposAna, { "PRODUTO", "C", TamSx3("C7_PRODUTO")[1], 0 } )
	Aadd( aCposAna, { "SALDO"  , "N", Max(TamSx3("E1_SALDO")[1]  ,;
				 					            	TamSx3("E2_SALDO")[1]) , TamSx3("E1_SALDO")[2] } )
	Aadd( aCposAna, { "CHAVE"  , "C", 40, 0 } )
	Aadd( aCposAna, { "Apelido", "C", 10, 0 } )
	cAliasAna := "cArqAnaPc"  // Alias do arquivo analitico
Case nArquivo == 4 // Pedidos de vendas
	aCposAna := {}
	Aadd( aCposAna, { "Periodo", "C",  20, 0 } )
	Aadd( aCposAna, { "DATAX"  , "D", 08, 0} )
	Aadd( aCposAna, { "NUMERO" , "C", TamSx3("C5_NUM")[1], 0 } )
	Aadd( aCposAna, { "EMISSAO", "D",  8, 0 } )
	Aadd( aCposAna, { "CLIFOR" , "C", TamSx3("E5_CLIFOR")[1], 0 } )
	Aadd( aCposAna, { "TIPO"   , "C", TamSx3("C5_TIPO")[1], 0 } )
	Aadd( aCposAna, { "NomCliFor", "C", TamSx3("A1_NOME")[1], 0 } )
	Aadd( aCposAna, { "LOJAENT", "C", TamSx3("C5_LOJAENT")[1], 0 } )
	Aadd( aCposAna, { "LOJACLI", "C", TamSx3("C5_LOJAENT")[1], 0 } )
	Aadd( aCposAna, { "SALDO"  , "N", Max(TamSx3("E1_SALDO")[1]  ,;
					 					            TamSx3("E2_SALDO")[1]) , TamSx3("E1_SALDO")[2] } )
	Aadd( aCposAna, { "CHAVE"  , "C", 40, 0 } )
	Aadd( aCposAna, { "Apelido", "C", 10, 0 } )
		
	cAliasAna := "cArqAnaPv"  // Alias do arquivo analitico
Case nArquivo == 6 // Cheques pendentes
	aCposAna := {}
	Aadd( aCposAna, { "Periodo" , "C",  20, 0 } )
	Aadd( aCposAna, { "DATAX"   , "D", 08, 0} )
	Aadd( aCposAna, { "NUMERO"  , "C", TamSx3("EF_NUM")[1], 0 } )
	Aadd( aCposAna, { "BANCO"   , "C", TamSx3("EF_BANCO")[1], 0 } )
	Aadd( aCposAna, { "AGENCIA" , "C", TamSx3("EF_AGENCIA")[1], 0 } )
	Aadd( aCposAna, { "CONTA"   , "C", TamSx3("EF_CONTA")[1], 0 } )
	Aadd( aCposAna, { "SALDO"   , "N", TamSx3("EF_VALOR")[1], TamSx3("EF_VALOR")[2]})
	Aadd( aCposAna, { "CHAVE"   , "C", 40, 0 } )
	Aadd( aCposAna, { "Apelido" , "C", 10, 0 } )
		
	cAliasAna := "cArqAnaChq"  // Alias do arquivo analitico	
Case nArquivo == 7 // Doctos. Transporte
	aCposAna := {}
	Aadd( aCposAna, { "Periodo" , "C",  20, 0 } )
	Aadd( aCposAna, { "DATAX"   , "D", 08, 0} )
	Aadd( aCposAna, { "FILDEB"  , "C", TamSx3("DT6_FILDEB")[1], 0 } )
	Aadd( aCposAna, { "FILDOC"  , "C", TamSx3("DT6_FILDOC")[1], 0 } )
	Aadd( aCposAna, { "DOC"   , "C", TamSx3("DT6_DOC")[1], 0 } )
	Aadd( aCposAna, { "SERIE" , "C", TamSx3("DT6_SERIE")[1], 0 } )
	Aadd( aCposAna, { "EMISSAO" , "D",  8, 0 } )
	Aadd( aCposAna, { "SALDO"   , "N", TamSx3("DT6_VALTOT")[1], TamSx3("DT6_VALTOT")[2]})
	Aadd( aCposAna, { "CHAVE"   , "C", 40, 0 } )
	Aadd( aCposAna, { "Apelido" , "C", 10, 0 } )
		
	cAliasAna := "cArqAnaCtrc"  // Alias do arquivo analitico
	cChave := "Dtos(DataX)+FILDOC+DOC+SERIE"
Case nArquivo == 8
//criação do arquivo de titulos vencidos
	aCposAna := {}
	AADD( aCposAna,{ "FILIAL", "C", 2, 0})
	Aadd( aCposAna, { "VENCTO" , "D",  8, 0 } )
	AADD( aCposAna,{ "E1_PREFIXO", "C", 3, 0})
	AADD( aCposAna,{ "E1_NUM", "C", 9, 0})
	AADD( aCposAna,{ "E1_PARCELA", "C", 1, 0})
	AADD( aCposAna,{ "E1_TIPO", "C", 3, 0})
	AADD( aCposAna,{ "E1_CLIENTE", "C", 6, 0})
	AADD( aCposAna,{ "E1_LOJA", "C", 2, 0})
	AADD( aCposAna,{ "E1_NCLI", "C", 40, 0})
	AADD( aCposAna,{ "E1_SALDO", "N",16,4})
	AADD( aCposAna,{ "E1_SITUAC", "C", 1, 0})
	AADD( aCposAna,{ "E1_PORTADO" , "C", 3, 0})
	AADD( aCposAna,{ "E1_AGEDEP", "C", 5, 0})
	AADD( aCposAna,{ "E1_CONTA", "C", 10, 0})
	AADD( aCposAna,{ "E1_VALOR", "N", TamSx3("E1_SALDO")[1], TamSx3("E1_SALDO")[2]})
	AADD( aCposAna,{ "CHAVE ", "C", 24, 0})
	cAliasAna:="cArqTitV"
Case nArquivo == 9
//criação do arquivo de titulos vencidos A PAGAR
	aCposAna := {}
	AADD( aCposAna,{ "FILIAL", "C", 2, 0})
	Aadd( aCposAna, { "VENCTO" , "D",  8, 0 } )
	AADD( aCposAna,{ "E2_PREFIXO", "C", 3, 0})
	AADD( aCposAna,{ "E2_NUM", "C", 9, 0})
	AADD( aCposAna,{ "E2_PARCELA", "C", 1, 0})
	AADD( aCposAna,{ "E2_TIPO", "C", 3, 0})
	AADD( aCposAna,{ "E2_FORNECE", "C", 6, 0})
	AADD( aCposAna,{ "E2_LOJA", "C", 2, 0})
	AADD( aCposAna,{ "E2_NFORN", "C", 40, 0})
	AADD( aCposAna,{ "E2_SALDO", "N",16,4})
//	AADD( aCposAna,{ "E2_SITUAC", "C", 1, 0})
	AADD( aCposAna,{ "E2_PORTADO" , "C", 3, 0})
	AADD( aCposAna,{ "E2_NAGENCI", "C", 5, 0})
	AADD( aCposAna,{ "E2_NCONTA", "C", 10, 0})
	AADD( aCposAna,{ "E2_VALOR", "N", TamSx3("E1_SALDO")[1], TamSx3("E1_SALDO")[2]})
	AADD( aCposAna,{ "CHAVE ", "C", 24, 0})
	cAliasAna:="cArqTitAP"

EndCase			
Aadd( aCposAna, { "CampoNulo", "C", 1, 0 } )
Aadd( aCposAna, { "Flag"     , "L", 1, 0 } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera arquivo de Trabalho      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqAna := CriaTrab(aCposAna,.T.) // Nome do arquivo temporario
dbUseArea(.T.,__LocalDriver,cArqAna,cAliasAna,.F.)
if nArquivo < 8 
	IndRegua ( cAliasAna,cArqAna,cChave,,,STR0054) //"Selecionando Registros..."
EndIF 		   
Return {cAliasAna,cArqAna}

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Fc021Tipo ºAutor  ³Wagner Mobile Costa º Data ³  06/12/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Valida se o tipo indicado na simulacao eh Receita/Despesa  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINC021                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fc021Tipo

Local lRet := .T.

If ! M->_SI_TIPO $ "RD"
	IW_MsgBox(STR0149,STR0198,"STOP") //"E necessario informar um tipo válido de simulação (R=Receita ou D=Despesa)"
	lRet := .F.	
Endif

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³Fc021Excel ³ Autor ³ Claudio D. de Souza  ³ Data ³ 06-05-2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Exporta a planilha de trabalho para o Excel.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³FINC021                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fc021Excel(aFluxo,nBancos,nCaixas,nAtrReceber,nAtrPagar)
Processa( { || Fc021ProcEx(aFluxo,nBancos,nCaixas,nAtrReceber,nAtrPagar) } )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³Fc021ProcEx³ Autor ³ Claudio D. de Souza  ³ Data ³ 25-04-2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Processa a exportacao da planilha de trabalho para o Excel.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³FINC021                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fc021ProcEx(aFluxo,nBancos,nCaixas,nAtrReceber,nAtrPagar)
LOCAL cDirDocs   := MsDocPath() 
Local aStru		:= {}
Local cArquivo := CriaTrab(,.F.)
Local cPath		:= AllTrim(GetTempPath())
Local oExcelApp
Local nHandle
Local cCrLf 	:= Chr(13) + Chr(10)
Local nX
	
aStru := {	{STR0229	, "C", 30, 0},;
			 	{STR0043, "N", 17, 2},;
			 	{STR0044	, "N", 17, 2},;
			 	{STR0045	, "N", 17, 2},;
			 	{STR0046	, "N", 17, 2},;
			 	{STR0047	, "N", 17, 2},;
			 	{STR0048	, "N", 17, 2},;
			 	{STR0049	, "N", 17, 2},;
			 	{STR0050	, "N", 17, 2}}

ProcRegua(Len(aFluxo)+2)

nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

If nHandle > 0
	
	// Grava o cabecalho do arquivo
	IncProc(STR0221) // "Aguarde! Gerando arquivo de integração com Excel..."
	aEval(aStru, {|e, nX| fWrite(nHandle, e[1] + If(nX < Len(aStru), ";", "") ) } )
	fWrite(nHandle, cCrLf ) // Pula linha
	
	For nX := 1 to Len(aFluxo)
		IncProc(STR0221) // "Aguarde! Gerando arquivo de integração com Excel..."
		fWrite(nHandle, Transform(aFluxo[nX,DATAFLUXO],"") + ";" )
		fWrite(nHandle, Transform(aFluxo[nX,ENTRADAS], "@E 999,999,999,999.99" )	+ ";" )
		fWrite(nHandle, Transform(aFluxo[nX,SAIDAS], "@E 999,999,999,999.99" ) + ";" )
		fWrite(nHandle, Transform(aFluxo[nX,SALDODIA], "@E 999,999,999,999.99" ) + ";" )
		fWrite(nHandle, Transform(aFluxo[nX,VARIACAODIA] / 100, "@E 999,999.999" ) + ";" )
		fWrite(nHandle, Transform(aFluxo[nX,ENTRADASACUMULADAS], "@E 999,999,999,999.99" ) + ";" )
		fWrite(nHandle, Transform(aFluxo[nX,SAIDASACUMULADAS], "@E 999,999,999,999.99" ) + ";" )
		fWrite(nHandle, Transform(aFluxo[nX,SALDOACUMULADO], "@E 999,999,999,999.99" ) + ";" )
		fWrite(nHandle, Transform(aFluxo[nX,VARIACAOACUMULADA] / 100, "@E 999,999.999" ) + ";" )
		fWrite(nHandle, cCrLf ) // Pula linha
	Next
	
	IncProc(STR0222) //"Aguarde! Abrindo o arquivo..." 
	
	fClose(nHandle)
	CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )
	
	If ! ApOleClient( 'MsExcel' ) 
		MsgAlert( STR0190 ) //'MsExcel nao instalado'
		Return
	EndIf
	
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
Else
	MsgAlert( STR0223 ) // "Falha na criação do arquivo"
Endif	

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Fc021Filtro³ Autor ³ Claudio D. de Souza  ³ Data ³ 18/06/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Obtem o filtro do usuario para os dados do SE1 e do SE2.	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso	    ³ FINC021																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fc021Filtro(cFilterSe1,cFilterSe2)
Local nOpc := 1
Local oDLg, cAlias

DEFINE MSDIALOG oDlg FROM 90,11 TO 260,321 TITLE STR0191 PIXEL

@ 10,13 TO 53, 142 LABEL STR0192 OF oDlg	PIXEL
@ 24,27 RADIO nOpc PROMPT STR0193,STR0194 SIZE  60,9 OF oDlg PIXEL

DEFINE SBUTTON FROM 60, 85 TYPE 1 ENABLE OF oDlg ACTION (cAlias := If(nOpc=1,"SE1","SE2"), dbSelectArea(cAlias), If(nOpc=1,cFilterSe1,cFilterSe2) := BuildExpr(cAlias,oDlg ),oDlg:End())
DEFINE SBUTTON FROM 60,115 TYPE 2 ENABLE OF oDlg ACTION (oDlg:End())

ACTIVATE MSDIALOG oDlg

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³PesqUsu   ºAutor  ³Claudio D. de Souza º Data ³  18/11/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Pesquisa usuario no arquivo de param. da rotina            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Finc021                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PesqUsu(nHandle,cLog,nOffSet)
Local lAchou := .F.
While fReadLn(nHandle,@cLog,100)
	nOffSet := fSeek(nHandle,0,1) // Retorna o offset atual (posicao do arquivo)
	If Left(cLog,20)==Pad(Left(cUsuario,19),20)
		lAchou := .T.
		Exit
	Endif
EndDo

Return lAchou


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Fc021ImpSi ³ Autor ³ Claudio D. de Souza  ³ Data ³ 16/09/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime a Simula‡ao da mem¢ria.									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso	    ³ FINC021																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fc021ImpSi()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis 														³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1 := STR0204 //"Este programa irá imprimir a simulação atualmente em"
Local cDesc2 := STR0205 //"uso."
Local cDesc3 := ""
Local cString:= "SE1"

PRIVATE nomeprog :="NSFINC021"
PRIVATE cabec1,cabec2,nLastKey:=0,titulo,wnrel,tamanho:="P"
PRIVATE aReturn:={STR0133,1,STR0134,1,2,1,"",1} //"Zebrado"###"Administracao"


If Empty( aCols[1,2] ) // Valor em branco
	Return Nil
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos													³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo:= STR0206 //"Simulação do Fluxo de Caixa"
cabec1:= STR0207 //"Data                   Valor  Tipo   Histórico"
cabec2:= ""

wnrel:="NSFINC021"           //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| Fc021ISiOk(@lEnd,wnRel,cString)},Titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Fc021ImpSiOk³ Autor ³ Claudio D. de Souza  ³ Data ³ 18/01/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime a Simula‡ao da mem¢ria.			  				     		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso	    ³ FINC020																	   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/              
Static Function Fc021ISiOk(lEnd,wnRel,cString )
Local nLaco := 0
Local nTotReceitas := 0
Local nTotDespesas := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt  := Space(10)
cbcont := 00
li 	 := 80
m_pag  := 01


SetRegua( Len( aCols ) )

For nLaco := 1 to Len( aCols )

	IF lEnd
		@PROW()+1,001 PSAY STR0139 //"CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	EndIF

	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
	EndIF

	IncRegua()

	@li,00 PSay aCols[ nLaco,1 ]
	@Prow(),Pcol() + 2	PSay aCols[ nLaco,3 ] Picture TM(aCols[ nLaco,2 ],18)
	@Prow(), 		  31 	PSay aCols[ nLaco,2 ]
	@Prow(),			  37	PSay aCols[ nLaco,4 ]
	li ++

	If Left( aCols[nLaco,2] , 1 ) == "R"
		nTotReceitas += aCols[ nLaco,3 ]
	Else
		nTotDespesas += aCols[ nLaco,3 ]
	Endif
Next

IF li+4 > 58
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
EndIF

@li++,00 PSay Repl("-",80)
@li++,00 PSay STR0208 //"Total de Receitas : "
@Prow(),PCol()+2 PSay nTotReceitas Picture TM(nTotReceitas,18)
@li++,00 PSay STR0209 //"Total de Despesas : "
@prow(),PCol()+2 PSay nTotDespesas Picture TM(nTotDespesas,18)
@li++,00 PSay Repl("-",80)

roda(cbcont,cbtxt)

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return Nil

       
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Fc021Val   ³ Autor ³ Leonardo Gentile     ³ Data ³ 02/08/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna o valor do argumento passado considerando a picture ³±±
±±³          ³ no formato AMERICAN (9,999.99) ou DEFAULT (9.999,99)        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso	     ³ FINC021													   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/              
Static Function Fc021Val( cTexto)
Local nValor
Local cDec, cMil

cTexto 	:= AllTrim( cTexto)
cDec := Subs( cTexto, Len(cTexto)-2, 1)
cMil := If( cDec=".",",",".")

nValor := Val( StrTran( StrTran( cTexto, cMil, ""), cDec, ".") )

Return nValor

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Fc021Ctrc  ³ Autor ³ Claudio D. de Souza	³ Data ³ 11/01/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Processa os documentos de transporte a serem exibidos no    ³±±
±±³          ³ fluxo                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso	     ³ FINC021													   				³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fc021Ctrc(cAliasCtrc,dUltData,lConsFil,cFilDe,cFilAte,lAnalitico,aFluxo,nMoeda,aTotais,aPeriodo)
Local nValDoc
Local cIdentific
Local nAscan
	 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lConsFil
   cFilDe  := xFilial("DT6")
   cFilAte := xFilial("DT6")
Endif

#IFDEF TOP
	If TcSrvType() != "AS/400" 
		aStru     := DT6->(dbStruct())
		cAliasTrb := "NSFINC021"
	
		cQuery := "SELECT * "
		cQuery += "FROM "+RetSqlName("DT6")+ " DT6 "
		cQuery += "WHERE "
		cQuery += "DT6.DT6_FILIAL>='"+cFilDe+"' AND "
		cQuery += "DT6.DT6_FILIAL<='"+cFilAte+"' AND "
		// Doctos. nao faturados
		cQuery += "DT6.DT6_PREFIX='"+Space(Len(DT6->DT6_PREFIX))+"' AND "
		cQuery += "DT6.DT6_NUM='"+Space(Len(DT6->DT6_NUM))+"' AND "
		cQuery += "DT6.DT6_TIPO='"+Space(Len(DT6->DT6_TIPO))+"' AND "
		cQuery += "DT6.DT6_MOEDA=" + AllTrim(Str(nMoeda,2,0)) + " AND "
		cQuery += "DT6.DT6_VENCTO >= '"+Dtos(dDataBase)+"' AND "
		cQuery += "DT6.DT6_VENCTO <= '"+Dtos(dUltData)+"' AND "
		cQuery += "DT6.D_E_L_E_T_=' ' "
	
		cQuery := ChangeQuery(cQuery)
	
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTrb,.T.,.T.)
		aEval(aStru, {|e| If(e[2]!= "C", TCSetField(cAliasTrb, e[1], e[2],e[3],e[4]),Nil)})
	Else	
#ENDIF
		cFiltro := "DT6_FILIAL>='"+cFilDe+"'.And. "
		cFiltro += "DT6_FILIAL<='"+cFilAte+"'.And. "
		cFiltro += "Empty(DT6_PREFIXO) .And. "
		cFiltro += "Empty(DT6_NUM) .And. "
		cFiltro += "Empty(DT6_TIPO) .And. "
		cFiltro += "DT6_MOEDA = " + AllTrim(Str(nMoeda,2,0)) + " .And. "
		cFiltro += "Dtos(DT6_VENCTO)>='"+Dtos(dDataBase)+"'.And."
		cFiltro += "Dtos(DT6_VENCTO)<='"+Dtos(dUltData)+"'"
		dbSelectArea("DT6")
		cIndTmp := CriaTrab(,.F.)
		IndRegua("DT6",cIndTmp,IndexKey(),,cFiltro)
		dbGotop()
		cAliasTrb := "DT6"
#IFDEF TOP
	Endif
#ENDIF
While (cAliasTrb)->(!Eof()) //IndRegua
	IncProc("Processando Doctos. de Transporte")
	dDataTrab := DataValida((cAliasTrb)->DT6_VENCTO,.T.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se a data de vencto. nao ultrapassar a ultima data do relatorio³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If dDataTrab <= dUltData
		nValDoc := xMoeda((cAliasTrb)->DT6_VALTOT,DT6_MOEDA,nMoeda)
		If Abs(nValDoc) > 0.0001
			// Pesquisa a data na matriz com os dados a serem exibidos na tela do fluxo
			nAscan := Ascan(aPeriodo, {|e| e[1] == dDataTrab})
			// Verifica se esta no periodo solicitado
			If nAscan > 0
				aFluxo[nAscan][ENTRADAS] += nValDoc
			Endif	
			If lAnalitico .And. nAscan > 0
				RecLock(cAliasCtrc,.T.)
				(cAliasCtrc)->Datax		:= dDataTrab
				(cAliasCtrc)->Periodo	:= aPeriodo[nAscan][2]
				(cAliasCtrc)->FILDEB		:= (cAliasTrb)->DT6_FILDEB
				(cAliasCtrc)->FILDOC		:= (cAliasTrb)->DT6_FILDOC
				(cAliasCtrc)->DOC			:= (cAliasTrb)->DT6_DOC
				(cAliasCtrc)->SERIE		:= (cAliasTrb)->DT6_SERIE
				(cAliasCtrc)->EMISSAO	:= (cAliasTrb)->DT6_DATEMI
				cIdentific :=	xFilial("DT6")+;
								   (cAliasTrb)->DT6_FILDOC	+;
								   (cAliasTrb)->DT6_DOC		+;
								   (cAliasTrb)->DT6_SERIE
				(cAliasCtrc)->Chave     := cIdentific
				(cAliasCtrc)->SALDO     := nValDoc
				(cAliasCtrc)->Apelido   := "DT6"
				MsUnlock()
				// Pesquisa na matriz de totais, os totais de contas a pagar ou a receber
				// da data de trabalho.
				nAscan := Ascan( aTotais[9], {|e| e[1] == dDataTrab})
				If nAscan == 0
					Aadd( aTotais[9], {dDataTrab,nValDoc})
				Else	
					aTotais[9][nAscan][2] += nValDoc // Contabiliza os totais de Doctos.
				Endif	
			Endif
		EndIf
	Endif
	(cAliasTrb)->(dbSkip())
Enddo
#IFDEF TOP
	If TcSrvType() != "AS/400" 
		dbSelectArea(cAliasTrb)
		dbCloseArea()
		dbSelectArea("DT6")
	Else
#ENDIF		
		dbSelectArea("DT6")
		dbClearFil()
		RetIndex("DT6")
		If !Empty(cIndTmp)
			FErase (cIndTmp+OrdBagExt())
		Endif
		dbSetOrder(1)
#IFDEF TOP
	Endif
#ENDIF

Return Nil

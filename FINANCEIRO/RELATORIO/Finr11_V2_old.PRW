#include "rwmake.ch"
#INCLUDE "Protheus.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

User Function Finr11v2()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CDIRDOCS,CBTXT,CBCONT,CABEC1,CABEC2,TITULO,CSTRING,_N" )
SetPrvt("WNREL,CDESC1,CDESC2,CDESC3,TAMANHO,LIMITE,LI" )
SetPrvt("AORD,LCONTINUA,LEND,_NTOT2,NOMEPROG,_ATX,_NI" )
SetPrvt("NLASTKEY,CPERG,M_PAG,NTIPO,_NTOT,ARETURN,_CCC")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FINR11   ³ Autor ³ Marcelo Silveira      ³ Data ³ 10.11.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Títulos.                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ rdmake FINR11 x                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

CbTxt     := ""
CbCont    := ""
cabec1    := ""
cabec2    := ""
wnrel     := ""
titulo    := PADC("Relação de Titulos",27)
cDesc1    := PADC("Este programa ira emitir a Relação de Titulos,",48)
cDesc2    := PADC("de acordo com os valores informados em parâmetros.",51)
cDesc3    := ""
tamanho   := "G"
limite    := 216
cString   := "SE2"
aOrd      := {"Fornecedor","Vencimento","Natureza"} //-- Ordem
lContinua := .T.
lEnd      := .F.
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nomeprog  := "FINR11_V2"
nLastKey  := 0
cPerg     := "FINR11"
_aTx      := {}
_nTot     := 0
_nSubVarc := 0
_nTot2    := 0
_nTot3    := 0
_nTot4    := 0
_n        := 0
_cHist    := Space(20)

//ValidPerg(cPerg)
Pergunte("FINR11",.F.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01             // Do Numero                           ³
//³ mv_par02             // Ate o Numero                        ³
//³ mv_par03             // Do Prefixo                          ³
//³ mv_par04             // Ate o Prefixo                       ³
//³ mv_par05             // Do Vencimento                       ³
//³ mv_par06             // Ate o Vencimento                    ³
//³ mv_par07             // Do Fornecedor                       ³
//³ mv_par08             // Ate o Fornecedor                    ³
//³ mv_par09             // Da Natureza                         ³
//³ mv_par10             // Ate a Natureza                      ³
//³ mv_par11             // Imprime Tipos?                      ³
//³ mv_par12             // Imprime Titulos liquidados (S/N)    ³
//³ mv_par13             // Do Movimento                        ³
//³ mv_par14             // Até o Movimento                     ³
//³ mv_par15             // Da Movimento                        ³

//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


wnrel  := "FINR11_V2"

wnrel  := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)

If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem := aReturn[8]
cbtxt  := Space(10)
cbcont := 00
li     := 80
m_pag  := 01
//cMoeda := GetMv("MV_MOEDA1")
//cCpoTx := "m_pag"
//If mv_par13 > 1
//	cMoeda := GetMv("MV_MOEDA"+StrZero(mv_par13,1))
//	cCpoTx := "M2_MOEDA"+StrZero(mv_par13,1)
//EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo := "Relação de Títulos"//+Alltrim(cMoeda)

Cabec1:="Pasta       DI         Invoice                                       Codigo  Nome      C.C.   Prf/Num/Par      Tipo|---Natureza---| Digit.      Vencto    Data    Valor do Titulo         Saldo MO  Tx.        Variação"
Cabec2:="                         			                                                          |  Cod    Sigla|           Original    Baixa                          Título     Cambial       (R$)"


//         111     NIPPON SEIKI CO. LTD.                     221    2  -000001209    NF   968         18/02/11  02/06/11  02/06/11  02/06/11 99.999.999,99 99.999.999,99 99.999.999,99   -672,23      0,00 99.999.999,99
//         999999  XXXXXXXXXXXXXXXXXXXX  XXXXX  999-999999-99  XXX  xxxxxxxxxx  99/99/99  99/99/99  99/99/99  99/99/99  9,999,999.99  9,999,999.99  9,999,999.99  xxxxxxxxxxxxxxxxxxxx  999.99  9,999.99  9,999,999.99
//         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//         000000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990

If nLastKey == 27
	Return
Endif


nTipo  := IIF(aReturn[4]==1,15,18)

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento da Nota Fiscal                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

#IFDEF WINDOWS
	RptStatus({|| RptDetail()})
	Return
	Static Function RptDetail()
#ENDIF
Local cDirDocs  := MsDocPath() //Path para arquivo TMPorario. Se nao existir,
Local cPath	    := AllTrim(GetTempPath()) 
Local oExcelApp

//--------------------------------------------------------------------
//  CRIANDO TABELA TEMPORARIA PARA EXPORTAR P/ EXCELL
//--------------------------------------------------------------------
aCampos:={} 

AADD(aCampos, {"PASTA"      ,"C",10,0 })
AADD(aCampos, {"DI"         ,"C",10,0 })
AADD(aCampos, {"INVOICE"    ,"C",15,0 })
AADD(aCampos, {"CODFORN"    ,"C",06,0 })
AADD(aCampos, {"FORNECEDOR" ,"C",40,0 })
AADD(aCampos, {"CC"         ,"C",09,0 })
AADD(aCampos, {"PREFIXO"    ,"C",03,0 })
AADD(aCampos, {"NUM"        ,"C",09,0 })
AADD(aCampos, {"PARCELA"    ,"C",01,0 })
AADD(aCampos, {"TIPO"       ,"C",03,0 })
AADD(aCampos, {"CODNAT"     ,"C",10,0 })
AADD(aCampos, {"NATUREZA"   ,"C",20,0 })
AADD(aCampos, {"DIGIT"      ,"D",08,0 })
AADD(aCampos, {"VENCTO"     ,"D",08,0 })
AADD(aCampos, {"VENCTIT"    ,"D",08,0 })
AADD(aCampos, {"VALORTIT"   ,"N",14,2 })
AADD(aCampos, {"SALDOTIT"   ,"N",14,2 })
AADD(aCampos, {"MOEDA"      ,"N",02,0 })
AADD(aCampos, {"TAXA"       ,"N",13,6 })
AADD(aCampos, {"VARCAMB"    ,"N",14,2 })

cArq := Criatrab( ,.F.)
dbCreate(cDirDocs+"\"+cArq,aCampos,"DBFCDXADS")             //Cria o arquivo no caminho especificado
dbUseArea(.T.,"DBFCDXADS",cDirDocs+"\"+cArq,"TRX",.F.,.F.) //Seleciona o arquivo para uso.

//--------------------------------------------------------------------

dbSelectArea('SE2')
                                                                                  
CondW:=.T.
if Mv_par20=1
	dbSetOrder(5)
Else
	dbSetOrder(7)
Endif

//dbSelectArea('SE2')Aglair 10/02/10
//dbSetOrder(5)Aglair

//dbSeek(xFilial('SE2')+dtos(mv_par18),.T.)

//mv_par06:=dDataBase /*Desconsiderar o parâmetro de data até conf. solicitação da JSox. Alteração  feita pela Aglair 11/12/09 */

//teste contab1
cQuery:=" select E2_LOJA,E2_MULTA,E2_JUROS,E2_BAIXA,E2_SALDO,E2_VALLIQ,E2_VALOR,E2_PREFIXO,E2_FORNECE, "
cQuery+=" E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_NATUREZ,E2_EMIS1, "
cQuery+=" E2_VENCTO,E2_VENCREA,E2_DESCONT,E2_MOEDA,E2_TXORIG,"
cQuery+=" E2_INVOICE, E2_XDOCFOR, ISNULL(Z0H_NUMDI, '') AS  Z0H_NUMDI, "
cQuery+=" E2_NUM,E2_MOEDA,ISNULL(D1_DI,'') AS DI,ISNULL(ZB_PASTA,'') AS PASTA,ISNULL(ZB_TX,0) AS TAXA, E2_TXMOEDA, D1_DTDIGIT AS DTDIGI "

cQuery+=" from SE2010 AS A (NOLOCK)"
cQuery+=" left  join SD1010 AS B (NOLOCK) on B.D_E_L_E_T_='' AND (E2_FORNECE+E2_LOJA+E2_NUM+E2_PREFIXO=D1_FORNECE+D1_LOJA+D1_DOC+D1_SERIE) "
cQuery+=" left  join SZB010 AS C (NOLOCK) on C.D_E_L_E_T_='' AND (D1_PEDIDO+D1_DI=ZB_PEDIDO+ZB_DI) "

cQuery+=" left  join ( SELECT DISTINCT Z0J_PROC, Z0J_INV, Z0H_NUMDI   "
cQuery+=               " FROM Z0J010 as Z0J (NOLOCK)                   "
cQuery+=              " INNER JOIN Z0H010 AS Z0H (NOLOCK) ON Z0H.D_E_L_E_T_ = '' AND Z0H_PROC= Z0J_PROC "
cQuery+=              " WHERE Z0J.D_E_L_E_T_ = '' "  
cQuery+=           " ) AS AUX ON E2_NUM = Z0J_PROC AND E2_XDOCFOR = Z0J_INV "


cQuery+=" WHERE "
cQuery+=" A.D_E_L_E_T_='' AND "
//cQuery+=" B.D_E_L_E_T_='' AND "
//cQuery+=" C.D_E_L_E_T_='' AND "
cQuery+=" A.E2_NUM>='"+mv_par01+"' and A.E2_NUM<='"+mv_par02+"' AND "
cQuery+=" A.E2_EMIS1>='"+dtos(mv_par18)+"' AND"
cQuery+="  A.E2_EMIS1<='"+dtos(mv_par19)+"' AND"
CQuery+="  ((A.E2_MOVIMEN>='"+dtos(mv_par13)+"' AND"
CQuery+="  A.E2_MOVIMEN<='"+dtos(mv_par14)+"' ) OR E2_MOVIMEN='') AND "
cQuery+="  A.E2_NATUREZ >='"+mv_par09+"' AND E2_NATUREZ <='"+mv_par10+"' AND"
cQuery+="  A.E2_FORNECE >='"+mv_par07+"' AND E2_FORNECE <='"+mv_par08+"' AND"
cQuery+="  A.E2_VENCREA>='"+dtos(mv_par05)+"' AND A.E2_VENCREA<='"+dtos(mv_par06)+"' "
cQuery+=" GROUP BY E2_LOJA,E2_MULTA,E2_JUROS,E2_BAIXA,E2_SALDO,E2_VALLIQ,E2_VALOR,E2_PREFIXO,E2_FORNECE, "
cQuery+="  E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_NATUREZ,E2_EMIS1, "
cQuery+=" E2_VENCTO,E2_VENCREA,E2_DESCONT,E2_MOEDA,E2_TXORIG,E2_TXMOEDA,"
cQuery+=" E2_INVOICE, E2_XDOCFOR, E2_NUM,E2_MOEDA,ISNULL(D1_DI,''), ISNULL(Z0H_NUMDI, ''),ISNULL(ZB_PASTA,'') ,ISNULL(ZB_TX,0),D1_DTDIGIT "

TCQUERY cQuery NEW ALIAS "ZZZ"
//	Memowrit("MUV_1.SQL",cQry)
SetRegua(RecCount())

While !Eof() .and. lContinua
	
	#IFNDEF WINDOWS
		If LastKey() == 286
			lEnd := .T.
		End
	#ENDIF
	
	If lEnd
		@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	Endif
	DbSelectArea("ZZZ")
	
	Est:=Posicione("SA2",1,xFilial("SA2")+E2_FORNECE+E2_LOJA,"A2_EST")
	If (mv_par16=2 .and. Est<>"EX") .or. (mv_par16=1 .and. Est=="EX")
		IncRegua()
		dbSkip()
		Loop
	Endif
	
	
	/***********************************************/
	
	If (!(Alltrim(E2_TIPO) $ mv_par11) .and. !Empty(mv_par11))
		IncRegua()
		dbSkip()
		Loop
	EndIf
	
	
	
	//  	If (mv_par15==2 .and. !(E2_TIPO $ "PA")) Corrigido pela Aglair
	If (mv_par15==2 .and. Alltrim(E2_TIPO) $ "PA")
		IncRegua()
		dbSkip()
		Loop
	EndIf
	nValor := ZZZ->E2_VALOR
	//teste If !Empty(E2_BAIXA) .And. (E2_VALOR > E2_VALLIQ - (E2_ACRESC+E2_MULTA) + (E2_DECRESC+E2_DESCONT)) .And. E2_SALDO == 0 .And. E2_MOEDA==1 .AND.  DDataBase>SE2->E2_BAIXA  /*.and. DDataBase>SE2->E2_BAIXA AGLAIR */
	//teste    If E2_VALOR > E2_VALLIQ  // Jorge: 01/12/2006
	//teste	       nValor := E2_VALLIQ   // Jorge: 01/12/2006
	//teste    Else                     // Jorge: 01/12/2006
	//teste	   nValor := E2_VALOR - E2_VALLIQ
	//teste	End                      // Jorge: 01/12/2006
	//teste Else
	//teste	nValor := Iif(E2_MOEDA==1,E2_VALOR,E2_VALLIQ)
	//testeEndIf
	
	_cHist   := Space(20)
	_nMoed2  := 0
	_lRet    := .T.
	_nVbx    := 0
	_nVBCM    :=0
	_nVrCamb :=0
	SaldoBLiq:= 0
	SaldTit  := 0 /*Variavel para armazenar o saldo do título a pagar. Aglair */
	
	dbSelectarea("SE5")
	dbSetOrder(7)
	If dbSeek(xFilial("SE5")+ZZZ->E2_PREFIXO+ZZZ->E2_NUM+ZZZ->E2_PARCELA+ZZZ->E2_TIPO+ZZZ->E2_FORNECE)
		//
		aStruSE5 := SE5->(dbStruct())
		//
		cQuery := " SELECT * "
		cQuery += " FROM "+RetSqlName("SE5")+" "
		cQuery += " WHERE D_E_L_E_T_<>'*' "
		cQuery += " AND E5_FILIAL = '"+xFilial("SE5")+"'"
		cQuery += " AND E5_PREFIXO = '"+ZZZ->E2_PREFIXO+"'"
		cQuery += " AND E5_NUMERO = '"+ZZZ->E2_NUM+"'"
		cQuery += " AND E5_PARCELA = '"+ZZZ->E2_PARCELA+"'"
		cQuery += " AND E5_TIPO = '"+ZZZ->E2_TIPO+"'"
		cQuery += " AND E5_CLIFOR = '"+ZZZ->E2_FORNECE+"'"
		cQuery += " ORDER BY E5_SEQ DESC "		
		TCQuery cQuery Alias "SE5TMP" NEW
		dbSelectArea("SE5TMP")
		dbgotop()
		//
		For nX := 1 To Len(aStruSE5)
			If ( aStruSE5[nX][2] <> "C" ) .And. FieldPos(aStruSE5[nX][1]) > 0
				TcSetField("SE5TMP",aStruSE5[nX][1],aStruSE5[nX][2],aStruSE5[nX][3],aStruSE5[nX][4])
			EndIf
		Next nX                       
		//
		cSeq  := E5_SEQ		
		cCond := ZZZ->E2_PREFIXO+ZZZ->E2_NUM+ZZZ->E2_PARCELA+ZZZ->E2_TIPO+ZZZ->E2_FORNECE
		EncB:=.F.
		Do While !Eof() .And. cCond == E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR .AND. E5_SEQ == cSeq

			If Alltrim(E5_TIPODOC)$'JR/MT/DC' //CM Retira os títulos de juros pois os mesmo estão contabilizados dentro do títulos
				dbSkip()
				Loop
			Endif
			
			If (dtos(E5_DATA) < DTOS(mv_par13) .or. dtos(E5_DATA) > dtos(mv_par14))
				dbSkip()
				Loop
			EndIf
			
			If 	Alltrim(E5_TIPODOC) $ ('BA') .And. mv_par17 < ctod(ZZZ->E2_BAIXA) // ZZZ->E2_BAIXA Alterado Em: 07/11/12 - Jorge
				SaldTit += E5_VALOR /*Variavel para armazenar o saldo do título a pagar. Aglair */
				EncB:=.T.
			Endif
			
			_cHIst := SubStr(E5_HISTOR,1,20)
			_lRet  := .F.
			
			If  !(mv_par17<SE5->E5_DATA)// .and. Alltrim(E5_TIPODOC) $ 'JR'
				If Alltrim(E5_TIPODOC) $ 'ES/PA/NDF' //.or. E5_SITUACA='C'
					// _nVbx  -= iif(ZZZ->E2_MOEDA==1, E5_VALOR,E5_VALOR/E5_TXMOEDA)
					// _nVbCM -= E5_VLCORRE
					// _nVrCamb-=iif(ZZZ->E2_MOEDA<>1, (E5_VLMOED2*E5_TXMOEDA)-(E5_VLMOED2*ZZZ->E2_TXORIG) ,0)
					
				ElseIf Alltrim(E5_TIPODOC) $ "BA/VL" .AND. E5_SITUACA==' '
					_nVbx  += iif(ZZZ->E2_MOEDA==1, E5_VALOR, E5_VALOR/E5_TXMOEDA)
					_nVbCM +=E5_VLCORRE
					_nVrCamb+=iif(ZZZ->E2_MOEDA<>1, (E5_VLMOED2*E5_TXMOEDA)-(E5_VLMOED2*ZZZ->E2_TXORIG) ,0)
					
				ENDIF
			EndIf
			if  (mv_par17<SE5->E5_DATA)  // .and. Alltrim(E5_TIPODOC)$ 'BA/VL'
				SaldoBLiq += E5_VALOR
			Endif
			dbSkip()
		EndDo
		//
		SE5TMP->(dbclosearea())
		//
		If _lRet
			dbSelectArea("ZZZ")
			IncRegua()
			dbSkip()
			Loop
		EndIf
		//
	EndIf
	
	dbSelectArea("SM2")
	If dbSeek(SE5->E5_DATA) .And. _nMoed2 == 0
		_nMoed2 := Iif(ZZZ->E2_MOEDA == 1,nValor,ZZZ->E2_VALLIQ ) / M2_MOEDA2
	EndIf
	
	dbSelectArea("ZZZ")
	//   _nVbx:= _nVbx-(E2_DESCONT)+ E2_MULTA+E2_JUROS //ORIGINAL (E2_MULTA+E2_ACRESC)// E2_MULTA
	NomeFor:=Posicione("SA2",1,xFilial("SA2")+E2_FORNECE+E2_LOJA,"A2_NOME")
	//    DtBaixa:=Dtoc(Stod(ZZZ->E2_BAIXA))
	DtBaixa:=ZZZ->E2_BAIXA
	//	SaldTit:=SE2->E2_SALDO DIA 0/02/10
	//    if EncB //.and. SaldTit>0
	
	If !(ZZZ->E2_MOEDA==1)
		// SaldTit := (ZZZ->E2_VALOR - (_nVbx-_nVbCM )/E2_TXORIG )
	Else
		SaldTit :=ZZZ->E2_VALOR-_nVbx
	EndIF
	
	
	//    Else
	//		SaldTit:=SE2->E2_VALOR
	//	Endif
	//		_nVbx:=SaldTit-SaldoBLiq
	_nVbx:=_nVbx-SaldoBLiq
	if _nVbx<0
		_nVbx:=0
	Endif
	
	If ZZZ->E2_BAIXA>Dtos(mv_par17)
		DtBaixa=STod(" ")     //CORRIGIR COM O PARAMETRO
		//TESTE	 	 SaldTit:=SE2->E2_VALOR-SaldTit
	Endif
	
	
	//	Else
	
	
	
	/*teste 19/01/10*/
	//   If !( (mv_par12==1 .and. (!Empty(Dtbaixa) .or. Dtbaixa>mv_par17) ) .or.  (mv_par12 == 2 .and. EMPTY(DtBaixa))  )
	if   (mv_par12==1 .and.  Empty(Dtbaixa) ) .or. (mv_par12==2 .and. !Empty(DtBaixa)) .or. (mv_par12=3)
		SigNat:=posicione("SED",1,xFilial("SED")+E2_NATUREZ,"ED_SIGNAS")
		AcreTit:=E2_MULTA+E2_JUROS//Aglair juros e diferente de multa
		DtBaixa:=Dtoc(Stod(ZZZ->E2_BAIXA))
		
		
		aAdd(_aTx,{E2_FORNECE,;      		                	// 01
		E2_PREFIXO,;                   			// 02
		E2_NUM,;                       			// 03
		E2_PARCELA,;                   			// 04
		E2_TIPO,;                      			// 05
		Substring(Alltrim(E2_NATUREZ),1,4),;       // 06 Natureza com 4 caracteres conf. a Helaine do financeiro  02/05/2012
		Stod(DTDIGI),; //  Dtoc(Stod(E2_EMIS1)),;  // 07
		Dtoc(Stod(E2_VENCTO)),;                    // 08
		Dtos(Stod(E2_VENCREA)),;                   // 09
		nValor,;								    // 10
		NomeFor,;                    			    // 11
		SaldTit ,;                                 // 12 E2_SALDO,;  // 12 Aglair
		'',;                       			    // 13
		AcreTit,;  							    // 14
		E2_DESCONT,;							    // 15
		DtBaixa,;                                  // 16  E2_BAIXA,;  // 16 Aglair
		0,;                     		            // 17
		0,;                    		            // 18
		SaldTit,; //Iif(E2_MOEDA==2,E2_VALOR,_nMoed2),;	    // 19
		_nVbx,; 								    // 20
		padr(IIF( !Empty(E2_XDOCFOR), Alltrim(E2_XDOCFOR), E2_INVOICE ), len(E2_INVOICE)) ,;                               // 21 Invoice
		Padr(IIF( !Empty(Z0H_NUMDI) , Alltrim(Z0H_NUMDI ), DI         ), Len(DI        )) ,;                               // 22 DI
		PASTA,;									// 23 PASTA
		IIF( TAXA > 0, TAXA , E2_TXMOEDA ) ,;                               // 24 TAXA
		E2_MOEDA,;									// 25 MOEDA
		SigNat, ; 									// 26 SIGLA DA NATUREZA
		_nVrCamb})									// 27 VARIACAO CAMBIAL
		
	Endif
	
	IncRegua()
	dbSkip()
	
EndDo

DbSelectArea("ZZZ")
DbCloseArea()

If Len(_aTx) == 0
	MsgStop("Não Há Dados Gerados Para Esse Relatório. Verifique os Parametros.")
	DbSelectArea("TRX")
 	DbcloseArea("TRX")
	Return
EndIf
//aOrd := {"Fornecedor","Vencimento","Natureza"} //-- Ordem

If nOrdem==1
	asort(_aTx,,,{|x,y| x[11]+x[2]+x[3]+x[4] < y[11]+y[2]+y[3]+y[4]})
	_cCond  := "_aTx[_nI][11]==_xVar"
	_xCond  := "_aTx[_nI][11]"
	_cTitle := "Total do Fornecedor..."
ElseIf nOrdem==2
	//	asort(_aTx,,,{|x,y| dtos(x[9])+x[1]+x[2]+x[3] < dtos(y[9])+y[1]+y[2]+y[3] })
	asort(_aTx,,,{|x,y| x[9]+x[1]+x[2]+x[3] < y[9]+y[1]+y[2]+y[3] })
	_cCond:="_aTx[_nI][09]==_xVar"
	_xCond:="_aTx[_nI][09]"
	_cTitle := "Total do Vencimento..."
Else
	asort(_aTx,,,{|x,y| x[6]+x[1]+x[2]+x[3] < y[6]+y[1]+y[2]+y[3]})
	_cCond:="_aTx[_nI][06]==_xVar"
	_xCond:="_aTx[_nI][06]"
	_cTitle := "Total da Natureza..."
EndIf

SetRegua(Len(_aTx))

_nI:=1
While _nI <= Len(_aTx) .and. lContinua
	
	IncRegua()
	
	#IFNDEF WINDOWS
		If LastKey() == 286
			lEnd := .T.
		End
	#ENDIF
	
	If lEnd
		@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	Endif
	
	If Alltrim(_aTx[_nI][01]) < ALLTRIM(mv_par07) .or. Alltrim(_aTx[_nI][01]) > ALLTRIM(mv_par08)
		IncRegua()
		_nI++
		_n++
		Loop
	EndIf
	
	_xVar     := &_xCond
	_nSubTot  := 0
	_nSubTot2 := 0
	_nSubTot3 := 0
	_nSubTot4 := 0
	_SubVarC:=0
	//	_nCont    := 0
	While _nI <= Len(_aTx) .and. &_cCond
		
		_cCC := Space(9)
		
		dbSelectArea("SD1")
		dbSetOrder(1)
		If dbSeek(xFilial("SD1")+_aTx[_nI][03]+_aTx[_nI][02]+_aTx[_nI][01])
			_cCC := D1_CC
		EndIf
		//
		//		_nSaldo := iif(Empty(_aTx[_nI][16]),_aTx[_nI][12]+(_aTx[_nI][14]+_aTx[_nI][17])+(_aTx[_nI][15]+_aTx[_nI][18]),_aTx[_nI][12]) AGLAIR
		_nSaldo := iif(Empty(_aTx[_nI][16]),_aTx[_nI][12]+(_aTx[_nI][14])+(_aTx[_nI][15]),_aTx[_nI][12])
		//	@ li, PCOL()+6 PSAY _aTx[_nI][23]  //Pasta
		//		@ li, PCOL()+3 PSAY _aTx[_nI][22]   //Di
		//		@ li, PCOL()+3 PSAY _aTx[_nI][21]   //Invoice
		@ li, 000 PSAY _aTx[_nI][23]  //Pasta
		@ li, PCOL()+2 PSAY _aTx[_nI][22]   //Di
		@ li, PCOL()+2 PSAY _aTx[_nI][21]   //Invoice
		
		@ li, PCOL()+2      PSAY _aTx[_nI][01] //Fornecedor
		@ li, PCOL()+2 PSAY Substr(_aTx[_nI][11],1,10) // Nome do fornecesdor
		@ li, PCOL()+1 PSAY '|'+SubStr(_cCC,1,4) //cCustos
		@ li, PCOL()+1 PSAY _aTx[_nI][02]+Iif(!Empty(_aTx[_nI][02]),"-"," ")+_aTx[_nI][03]+Iif(!Empty(_aTx[_nI][04]),"-"," ")+_aTx[_nI][04] //Prefixo/Numero/Parcela
		@ li, PCOL()+2 PSAY _aTx[_nI][05] //Tipo
		@ li, PCOL()+2 PSAY U_GERAESP(_aTx[_nI][06],5) //Natureza
		@ li, PCOL()+2 PSAY _aTx[_nI][26] //Siglas da Natureza
		@ li, PCOL()+2   PSAY _aTx[_nI][07] //Data de Digitação
		//		@ li, PCOL()+2 PSAY _aTx[_nI][08] //Vencto Original
		@ li, PCOL()+2 PSAY Subs(_aTx[_nI][09],7,2)+"/"+Subs(_aTx[_nI][09],5,2)+"/"+Subs(_aTx[_nI][09],1,4) //Vencto Real
		@ li, PCOL()+2 PSAY _aTx[_nI][16] //Data Baixa
		//		If !(AllTrim(_aTx[_nI][05]) $ "NDF/PA/CP") //PA
		nSaldoTITX := 0
		If !(AllTrim(_aTx[_nI][05]) $ "NDF/PA") //PA
			@ li, PCOL()+2 PSAY Transform(_aTx[_nI][10]					,"@E 99,999,999.99") //Valor do titulo
			@ li, PCOL()+3 PSAY Transform(_aTx[_nI][12]					,"@E 99,999,999.99") //Valor moeda estrangeira
		Else
			@ li, PCOL()+2 PSAY Transform(_aTx[_nI][10]*-1				,"@E 9,999,999.99") //Valor do titulo
			@ li, PCOL()+3 PSAY Transform(_aTx[_nI][12]*-1				,"@E 9,999,999.99")	//Valor moeda estrangeira
			
		End
		@ li, PCOL()+2 PSAY	_aTx[_nI][25]
		
		//Campos adicionados
		//		@ li, PCOL()+2 PSAY Transform((_aTx[_nI][14]+_aTx[_nI][17]	,"@E 999.99") Aglair  Multa+Acréscimo
		//		@ li, PCOL()+3 PSAY _aTx[_nI][13]
		//		@ li, PCOL()+2 PSAY Transform((_aTx[_nI][15]+_aTx[_nI][18])	,"@E 9,999.99") Aglair Desconto+Descrescimo
		@ li, PCOL() PSAY Transform(_aTx[_nI][24],"@E 99.99999") //Taxa
		@ li, PCOL()+2 PSAY Transform(_aTx[_nI][27],"@E 9,999,999.99") //Variação Cambial
		
		Coef:=1
		
		
		If (AllTrim(_aTx[_nI][05]) $ "NDF/PA")
			Coef:=-1
		End
		/*Totalizadores*/
		_nSubTot  += _aTx[_nI][10] *Coef
		_nSubTot2 += _aTx[_nI][12]*Coef
		_nSubTot3 += _aTx[_nI][19]*Coef
		_nSubTot4 += _aTx[_nI][20]*Coef
		_SubVarC  += _aTx[_nI][27]*Coef
		
		
		//------ Preenche o Arquivo Temporario para Gerar a Planilha
		RecLock("TRX",.T.)
		TRX->PASTA		:= _aTx[_nI][23] 
		TRX->DI			:= _aTx[_nI][22] 
		TRX->INVOICE	:= _aTx[_nI][21] 
		TRX->CODFORN	:= _aTx[_nI][01]
		TRX->FORNECEDOR	:= _aTx[_nI][11]
		TRX->CC			:= _cCC
		TRX->PREFIXO	:= _aTx[_nI][02]
		TRX->NUM		:= _aTx[_nI][03]
		TRX->PARCELA	:= _aTx[_nI][04]
		TRX->TIPO		:= _aTx[_nI][05]
		TRX->CODNAT		:= U_GERAESP(_aTx[_nI][06],5)
		TRX->NATUREZA	:= _aTx[_nI][26]
		TRX->DIGIT		:= _aTx[_nI][07]
		TRX->VENCTO		:= CTOD(_aTx[_nI][08])
		TRX->VENCTIT	:= CTOD(Subs(_aTx[_nI][09],7,2)+"/"+Subs(_aTx[_nI][09],5,2)+"/"+Subs(_aTx[_nI][09],1,4))
		TRX->VALORTIT	:= _aTx[_nI][10] 
		TRX->SALDOTIT	:= _aTx[_nI][19] 
		TRX->MOEDA		:= _aTx[_nI][25]
		TRX->TAXA		:= _aTx[_nI][24]
		TRX->VARCAMB	:= _aTx[_nI][27]
		Msunlock()
		//----------------------------------------------------------
		
    	Li++
		_nI++
		//		_nCont++
		If li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		End

		
	EndDo
	
	//	If _nCont > 0
	@ li, 001      PSAY Replicate("-",limite)
	Li++
	@ li, 001 PSAY _cTitle
	@ li, 162 PSAY Transform( _nSubTot  , "@E 999,999,999.99" )
	@ li, 178 PSAY Transform( _nSubTot3 , "@E 999,999,999.99" )
	@ li, 203 PSAY Transform( _SubVarC ,  "@E 999,999,999.99" )
	Li += 2
	
	_nTot  += _nSubTot
	_nTot2 += _nSubTot2
	_nTot3 += _nSubTot3
	_nTot4 += _nSubTot4
	_nSubVarc += _SubVarC
	//	EndIf
	
	
EndDo

Li ++
@ li, 001 PSAY "Numero de Titulos:" + StrZero( Len(_aTx) - _n , 3 )
@ li, 162 PSAY Transform( _nTot  , "@E 999,999,999.99" )
@ li, 178 PSAY Transform( _nTot3 , "@E 999,999,999.99" )
@ li, 203 PSAY Transform( _nSubVarC ,  "@E 999,999,999.99" )
If li !=80
	roda(cbcont,cbtxt)
End

Set Device To Screen

If aReturn[5] == 1
	Set Printer to
	dbCommitAll()
	OurSpool(wnrel)
End

MS_FLUSH()

//----- Gera o Arquivo Excell
SExcel:=Msgbox("Confirma geração dos dados em Excel","Planilha","YESNO")
If  SExcel
      cDirDocs  :="\RELATO\"
      cPath="C:\RELATORIO_SIGA\"
	  cNome := "RELACAO_DE_TITULOS DE "+DTOS(MV_PAR13)+" A "+DTOS(MV_PAR14)+".xls"
	  
  	  dbSelectArea("TRX")
	  COPY TO &(cDirDocs+cNome) VIA "DBFCDXADS"
      CpyS2T( cDirDocs+cNome , cPath , .T. ) //cDirDocs+"\"+cArq+".DBF"  
      fErase(cDirDocs+cNome)
      If ! ApOleClient( 'MsExcel' )        //Verifica se o Excel esta instalado
         MsgStop( 'MsExcel nao instalado' ) 
    	 DbSelectArea("TRX")
		 DbcloseArea("TRX")
	     Return
      EndIf

      oExcelApp := MsExcel():New()     // Cria um objeto para o uso do Excel
      oExcelApp:WorkBooks:Open(cPath+cNome) // Atribui à propriedade WorkBooks do Excel
  												    // o Arquivo criado com as informacoes acumuladas do SRC 
      oExcelApp:SetVisible(.T.)   // Abre o Excel com o arquivo criado exibido na Primeira planilha.
   
      MSGBOX("Foi gerado o Arquivo "+cNOME,"Informacao","INFO")
     
Endif  
DbSelectArea("TRX")
DbcloseArea("TRX")
//---------------------------

Return

Static Function ValidPerg(cPerg)
_cAreaV := GetArea()

dbSelectArea("SX1")
dbSetOrder(1)

aRegs := {}

aAdd(aRegs, {cPerg, "01","Do Numero                  ?","","","mv_ch1","C",09,0,0,"G","","mv_par01","    	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "02","Ate o Numero               ?","","","mv_ch2","C",09,0,0,"G","","mv_par02","   	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "03","Do Prefixo                 ?","","","mv_ch3","C",03,0,0,"G","","mv_par03","   	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "04","Ate Prefixo                ?","","","mv_ch4","C",03,0,0,"G","","mv_par04","   	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "05","Do Vencimento              ?","","","mv_ch5","D",08,0,0,"G","","mv_par05","   	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "06","Ao o Vencimento            ?","","","mv_ch6","D",08,0,0,"G","","mv_par06","   	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "07","Do Fornecedor              ?","","","mv_ch7","C",06,0,0,"G","","mv_par07","   	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","SA2","","",""})
aAdd(aRegs, {cPerg, "08","Ate Fornecedor             ?","","","mv_ch8","C",06,0,0,"G","","mv_par08","  		  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","SA2","","",""})
aAdd(aRegs, {cPerg, "09","Da Natureza                ?","","","mv_ch9","C",10,0,0,"G","","mv_par09","   	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","SED","","",""})
aAdd(aRegs, {cPerg, "10","Ate a Natureza             ?","","","mv_ch0","C",10,0,0,"G","","mv_par10","   	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","SED","","",""})
aAdd(aRegs, {cPerg, "11","Imprime Tipos              ?","","","mv_cha","C",15,0,0,"G","","mv_par11","   	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "12","Imprime Titulos            ?","","","mv_chb","N",01,0,0,"C","","mv_par12","Em Aberto","","","","","Pagos    ","","","","","Ambos    ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "13","Da Data do Movimento       ?","","","mv_chc","D",08,0,0,"G","","mv_par13","   	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "14","À Data do Movimento        ?","","","mv_chd","D",08,0,0,"G","","mv_par14","   	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "15","Considera PA               ?","","","mv_che","N",01,0,0,"C","","mv_par15","Sim      ","","","","","Nao      ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "16","Tipo de Fornecedor        ?","","","mv_chf","N",01,0,0,"C","","mv_par16","Nacional ","","","","","Importado","","","","","Ambos","         ","","","","","         ","","","","","         ","","","","   ","","",""})


For i:=1 to Len(aRegs)
	If !dbSeek(PadR(cPerg,10)+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	EndIf
Next

Return

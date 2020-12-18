#include "RWMAKE.ch"
#include "TBICONN.ch"
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³rdmake	 ³ xEtqProd ³ Autor ³ : Paulo Rogerio                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de impressao de etiquetas para identificação de     ³±±
±±³          ³ produto. Específico Nippon.                     			  ³±±
±±³          ³                                                 			  ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function xEtqProd()
Private _cPerg:="REST99"
Private _aRegs:={}

Private vpParNopDe := ""
Private vpParNopAte:= ""
Private vpParEmiDe := ""
Private vpParEmiAte:= ""
Private vpParPorta := ""
Private vpParDrvWin:= .F.



//-----------|Grupo|Ord|Pergta                 |Pergunta              |Pergunta              |Variavel|Tip|Ta|D|P|GSC|Va             |Var01     |Def Port       |De|De|Cn|Va|Def Port2     |De|De|Cn|Va|Def Port3     |De|De|Cn|Va|Def Port4  |De|De|Cn|Va|Def Port5  |De|De|Cn|F3   |P |GRP
//-----------|     |em |Portug                 |Espanhol              |Ingles                |        |   |ma|e|r|   |li             |          |               |f |f |te|r |              |f |f |te|r |              |f |f |te|r |           |f |f |te|r |           |f |f |te|     |Y |SXG
//-----------|     |   |                       |                      |                      |        |   |nh|c|e|   |d              |          |               |Es|En|01|2 |              |Es|En|02|3 |              |Es|En|03|4 |           |Es|En|05|5 |           |Es|En|05|     |M |
AAdd(_aRegs,{_cPerg,"01","OP de              ?","OP de              ?","OP de              ?","mv_ch1","C",11,0,0,"G",""             ,"mv_par01",""             ,"","","","",""            ,"","","","",""            ,"","","","",""         ,"","","","",""         ,"","","","SC2" ,"",""})
AAdd(_aRegs,{_cPerg,"02","OP ate             ?","OP ate             ?","OP ate             ?","mv_ch2","C",11,0,0,"G",""             ,"mv_par02",""             ,"","","","",""            ,"","","","",""            ,"","","","",""         ,"","","","",""         ,"","","","SC2" ,"",""})
AAdd(_aRegs,{_cPerg,"03","Apontamento de     ?","Apontamento de     ?","Apontamento de     ?","mv_ch3","D",08,0,0,"G",""             ,"mv_par03",""             ,"","","","",""            ,"","","","",""            ,"","","","",""         ,"","","","",""         ,"","","",""    ,"",""})
AAdd(_aRegs,{_cPerg,"04","Apontamento ate    ?","Apontamento ate    ?","Apontamento ate    ?","mv_ch4","D",08,0,0,"G",""             ,"mv_par04",""             ,"","","","",""            ,"","","","",""            ,"","","","",""         ,"","","","",""         ,"","","",""    ,"",""})
AAdd(_aRegs,{_cPerg,"05","Porta de Impressao ?","Porta de Impressao ?","Porta de Impressao ?","mv_ch5","N",01,0,0,"C",""             ,"mv_par05","COM1"         ,"","","","","COM2"        ,"","","","","LPT1"        ,"","","","",""         ,"","","","",""         ,"","","",""    ,"",""})
AAdd(_aRegs,{_cPerg,"06","Utilizar Driver    ?","Utilizar Driver    ?","Utilizar Driver    ?","mv_ch6","N",01,0,0,"C",""             ,"mv_par08","Windows"      ,"","","","","Impressora"  ,"","","","",""            ,"","","","",""         ,"","","","",""         ,"","","",""    ,"",""})

U_FSX1FUNC(_aRegs, _cPerg)

IF ! Pergunte(_cPerg, .T.) 
	Return
Endif      

vpParNopDe := mv_par01
vpParNopAte:= mv_par02
vpParEmiDe := mv_par03
vpParEmiAte:= mv_par04
vpParPorta := IF(mv_par05 == 1, "COM1:", IF(mv_par05 == 2, "COM2:", "LPT1"))
vpParDrvWin:= IF(mv_par06 == 1, .T., .F.)

//  RptStatus({|lEnd| xImpAvul(@lEnd)},"Imprimindo Etiqueta. Click em <Cancel> para imterromper.")
RptStatus({|lEnd| xImpEtiq(@lEnd)},"Imprimindo Etiqueta. Click em <Cancel> para imterromper.")

Return



// ******************************************
// - Rotina de impressão da etiquetas para
// identificação de produtos.
// ******************************************
Static Function xImpEtiq()
Local nX
Local cPorta           
Local cQuery
Local nCont := 0
Local nTotEtq :=0 
Local nTotRec := 0
Local aLotes := {}
Local cRastro := ""
Local nTotEtq := 0
Local cHrInicio:=""
Local cArquivo := ""    
Local vlQtdEtq := 0
Local vlMsgErro := ""

	IF ! File("\Zebra\EtqProd.txt")
		Alert("O arquivo de configuração da etiqueta, \Zebra\EtqProd.txt, não foi encontrado!")
		Return
	Endif
	
    cArquivo := MemoRead("\Zebra\EtqProd.txt")

For nCont := 1 to 2
	dbSelectArea("SD3")
	cQuery := "SELECT D3_OP, D3_COD, D3_LOTECTL, D3_EMISSAO, D3_UM, Sum(D3_QUANT) as XX_QTOTAL"+chr(10)
	cQuery += "  FROM SD3"+SM0->M0_CODIGO+"0" +chr(10)
	cQuery += " WHERE D_E_L_E_T_ <> '*'" +chr(10)
	cQuery += "   AND D3_OP  BETWEEN '"+vpParNopDe+"' AND '"+vpParNopAte+"'"+chr(10)
	cQuery += "   AND D3_EMISSAO BETWEEN '"+dtos(vpParEmiDe)+"' AND '"+dtos(vpParEmiAte)+"'"+chr(10)
	cQuery += "   AND D3_FILIAL = '"+xFilial("SD3")+"'"+chr(10)
	cQuery += "   AND D3_ESTORNO <> 'S'"+chr(10)
	cQuery += "   AND D3_CF = 'PRO'"+chr(10)
	cQuery += "GROUP BY D3_OP, D3_COD, D3_LOTECTL, D3_EMISSAO, D3_UM"+chr(10)
	cQuery += " ORDER BY D3_OP, D3_COD, D3_LOTECTL"+chr(10)
	
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMP", .F.)

	DbSelectArea("TMP")
	DbGoTop() 
	
	IF nCont == 1   
		// Conta o total de rergistros
		Do While ! eof()       
			nTotRec++
			dbSkip()
		Enddo
		dbCloseArea()
	Else
		Exit
	Endif
Next

nCont := 0
cPorta := vpParPorta
IF vpParPorta <> "LPT1"
	cPorta := vpParPorta+"9600,n,8,1"
Endif

MSCBPRINTER("S4M",cPorta,,,.f.,,,,,,vpParDrvWin)

cHrInicio := Time()
vlQtdPCx :=0

SetRegua(nTotRec)
DbSelectArea("TMP")
Do While ! eof()       
	IncRegua()

	// Posiciona o Produto.
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+TMP->D3_COD)
	
	vlMsgErro := ""
	IF ! Found()   
		vlMsgErro += "Produto não Cadastrado." + chr(10)
	Endif

	// Posiciona o Complemento do Produto.
	dbSelectArea("SB5")
	dbSetOrder(1)
	dbSeek(xFilial("SB5")+TMP->D3_COD)
	IF ! Found()   
		vlMsgErro += "Complemento do Produto não Cadastrado." + chr(10)
	Endif

	// Posiciona a Ordem de Produção.
	dbSelectArea("SC2")
	dbSetOrder(6) //C2_FILIAL, C2_NUM, C2_ITEM, C2_SEQUEN, C2_PRODUTO, C2_ITEMGRD, R_E_C_N_O_, D_E_L_E_T_
	dbSeek(xFilial("SC2")+SUBS(TMP->D3_OP,1,11)+TMP->D3_COD, .T.)

	//==========================================================================================
	// A busca no SA7 é feita pelo código do produto e não pelo cliente, por que, por definição,
	// a Nippon não comercializar o mesmo produto para mais de um cliente e além disso, as OPs
	// geradas por ela não estão relacionadas a pedidos de venda.
	//==========================================================================================
	dbSelectArea("SA7")
	dbSetOrder(2) //A7_FILIAL, A7_PRODUTO, A7_CLIENTE, A7_LOJA, R_E_C_N_O_, D_E_L_E_T_
	dbSeek(xFilial("SA7")+TMP->D3_COD, .T.)
	IF ! Found()   
		vlMsgErro += "Codigo do Cliente para o Produto, não Cadastrado." + chr(10)
	Endif

	vlQtdEtq := (TMP->XX_QTOTAL/SB5->B5_EAN141)
    vlQtdEtq := IF(Int(vlQtdEtq) <> vlQtdEtq, Int(vlQtdEtq) + 1, vlQtdEtq)
	
	IF Empty(vlMsgErro)
    	xImprime(cPorta, cArquivo, vlQtdEtq)
 	Else 
 		Alert("Não Foi possível gerar etiqueta para o Produto:"+TMP->D3_COD+chr(13)+chr(13)+"Motivo:"+vlMsgErro)
 	Endif

   	nTotEtq++

	DbSelectArea("TMP")
	dbskip()
Enddo	
dbCloseArea()

// Finaliza a conexão com a impressora.
MSCBClosePrinter()

Alert("Iniciou as "+cHrInicio+" - Terminou as "+Time())
Alert("Termino de Impressão! Total de Etiquetas Impressas: "+Strzero(nTotEtq,5))
Return



// *********************************************
// Função que verifica se a porta de impressão
// escolhida foi aberta.
// *********************************************
Static Function xChkPort(_cPorta, _cSettings)
Local nHandle := fopenPort(_cPorta,_cSettings,2)
Local lRet := .F.
If nHandle <> -1 // Porta foi aberta.
        lRet := .T.
Endif
Return(lRet)



/*
Funcao.....: xImprime()
Autor......: Paulo Rogerio
Data.......: 28/10/2007
Descric....: Efetua a impressão de etiquetas de volume.
*/
Static Function xImprime(vlPorta, vlLayout, vlQtde)
Local vlTexto := ""

// Ajusta e executa a impressão das etiquetas de volume.
	vlTexto := vlLayout
	vlTexto := Strtran(vlTexto, "@QTDE"      , Alltrim(Str(vlQtde)))
	vlTexto := Strtran(vlTexto, "@B1_DESC"   , Alltrim(SUBS(SB1->B1_DESC,1,30)))
	vlTexto := Strtran(vlTexto, "@B1_COD"    , Alltrim(SB1->B1_COD))
	vlTexto := Strtran(vlTexto, "@A7_CODCLI" , Alltrim(SA7->A7_CODCLI))
	vlTexto := Strtran(vlTexto, "@D3_LOTECTL", Alltrim(TMP->D3_LOTECTL))
	vlTexto := Strtran(vlTexto, "@D3_EMISSAO", dtoc(stod(TMP->D3_EMISSAO)))
	vlTexto := Strtran(vlTexto, "@B5_XCOR"   , UPPER(Alltrim(Posicione("SX5",1,xFilial("SX5")+"CR"+SB5->B5_XCOR,"X5_DESCRI"))))
	vlTexto := Strtran(vlTexto, "@B5_EAN141" , Alltrim(Str(SB5->B5_EAN141))+" "+SB1->B1_UM+"s")

	vlTexto := Strtran(vlTexto, "@B1_CODBAR" , Alltrim(SB1->B1_CODBAR))
	vlTexto := Strtran(vlTexto, "@D3_LOTE_OP", Subs(Alltrim(TMP->D3_LOTECTL),1,6))

	MSCBBEGIN( 1, 6 )
	MSCBWRITE(vlTexto)
	MSCBEND()

//Alert(vlTexto)

Return(.t.)

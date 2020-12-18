#include "rwmake.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

User Function MATR25_AS()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,CBCONT,CABEC1,CABEC2,WNREL,TITULO")
SetPrvt("CDESC1,CDESC2,CDESC3,TAMANHO,LIMITE,CSTRING")
SetPrvt("AORD,LCONTINUA,CUM,LEND,ARETURN,NOMEPROG")
SetPrvt("NLASTKEY,CPERG,")
SetPrvt("LI,M_PAG,NTIPO,CARQNTX,CINDCOND,XGERQTD")
SetPrvt("XGERVAL,XGERIPI,XCODIGO,ThMaq,TmMaq,TtMaq")
SetPrvt("XTOTIPI,TPerda,xPerdas,_aInd")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MATR25V2 ³ Autor ³ Jefferson Moreira     ³ Data ³ 11.08.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Resumo de Perdas na Producao por Produto                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ rdmake MATR25V2                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo    := "Relação de Perdas na Produção ( Por Produto ) "
cDesc1    := "Este programa tem com objetivo, imprimir a Relacao de Perdas por"
cDesc2    := "Produto, no período especificado."
cDesc3    := ""
tamanho   := "G"
limite    := 220
cString   := "SZ6"
aOrd      := {} //-- Ordem
lContinua := .T.
cUM       := ""
lEnd      := .F.
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "MATR25_V2"
nLastKey  := 0
cPerg     := "MATR21"
xPerdas   := {}
_aInd     := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

pergunte("MATR21",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01             // Do Recurso                          ³
//³ mv_par02             // Ate o Recurso                       ³
//³ mv_par03             // Da Data                             ³
//³ mv_par04             // Ate a Data                          ³
//³ mv_par05             // Do C.de Custo                       ³
//³ mv_par06             // Ate o C.de Custo                    ³
//³ mv_par07             // Do Produto                          ³
//³ mv_par08             // Ao Produto                          ³
//³ mv_par09             // Imprime Totais (Sim / Nao)          ³
//³ mv_par10             // Custo Mao de Obra (Sim / Nao)       ³
//³ mv_par11             // Media p/ Calc. Custo                ³
//³ mv_par12             // Quanato ao Relatorio (Anal/Sint)    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel  := "MATR25V2"
//wnrel  := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,)
wnrel  := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,)

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
aPerda := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If mv_par12 == 1
	cabec1 := "Produto          Descricao                                           TP  Grpo  Qtd.Pro  Ordem de Prod.  Motivo da perda                      Quant 		    C   U   S   T   O   S  "
	cabec2 := "Periodo: "+dtoc(mv_par03)+" a "+dtoc(mv_par04)+"                                                                                                                          Unitario      Total CC     Descrição           Responsavel "
Else
	cabec1 := "Produto          Descricao                                           TP  Grpo  Qtd.Pro  Motivo da perda                      Quant 		    C   U   S   T   O   S  "
	cabec2 := "Periodo: "+dtoc(mv_par03)+" a "+dtoc(mv_par04)+"                                                                                                           Unitario      Total CC     Descrição             Responsavel "
End
//         XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XX  xxxx  999.999  99 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 999.999 9.999,999999 999.999,99 999999  xxxxxxxxxxxxxxxxxxxx
//         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123465789012345678901234567890123456789010123456789012345678901
//         0000000000111111111122222222223333333333444444444455555555556666666666777777777788888888899999999990000000000111111111122222222223333333333444444444455

If nLastKey == 27
	Return
Endif

nTipo  := IIF(aReturn[4]==1,15,18)

// cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)

#IFDEF WINDOWS
	Processa({|| ExeMatr22()},"Consultando o Banco de Dados... Por favor aguarde...")
	
	RptStatus({|| DetMatr22()},"Gerando Relatorio... Aguarde Alguns Instantes...")
	
	//	Processa( {|| ExeMatr22()})
	//	RptStatus({|| DetMatr22(aPerda)})
	Return
#ENDIF

Static Function ExeMatr22()
Local aDados:={}
Private ACusto:={}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento do Relatorio                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQuery := ""
cQuery := "SELECT ZZ6_DOC, ZZ6_PRODUT, B1_DESC, B1_TIPO, B1_GRUPO, ZZ6_CODMOT, ZZ6_MOTIVO, ZZ6_OP, ZZ6_CC, ZZ6_NOMEAU, SUM(ZZ6_QUANT) AS ZZ6_QUANT "
cQuery +=    "FROM " + RetSqlName("ZZ6") + " ZZ6 "
cQuery += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON ZZ6_PRODUT = B1_COD AND SB1.D_E_L_E_T_='' "
cQuery += "INNER JOIN " + RetSqlName("SC2") + " SC2 ON ZZ6_OP  = C2_NUM+C2_ITEM+C2_SEQUEN AND SC2.D_E_L_E_T_='' "
cQuery += " WHERE  "
//cQuery += " Z6_RECURSO BETWEEN  '" +      MV_PAR01  +"' AND '"+      MV_PAR02  +"' AND "
cQuery +=       "ZZ6_DATA    BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' AND "
cQuery +=       "ZZ6_CC     BETWEEN  '" +      MV_PAR05  + "' AND '" +      MV_PAR06  + "' AND "
cQuery +=       "ZZ6_PRODUT BETWEEN  '" +      MV_PAR07  + "' AND '" +      MV_PAR08  + "' AND "
cQuery +=       "C2_TPOP <> 'T' "
cQuery += "GROUP BY ZZ6_DOC, ZZ6_PRODUT ,B1_DESC,B1_TIPO,B1_GRUPO, ZZ6_CODMOT, ZZ6_MOTIVO, ZZ6_OP, ZZ6_CC, ZZ6_NOMEAU "
cQuery += "ORDER BY ZZ6_PRODUT, ZZ6_CODMOT"

cQuery := ChangeQuery(cQuery)

TCQUERY cQuery Alias TEMP New

/******Criando tabela temporaria****************/
cDirDocs  :="\RELATO\"
aCampos:={}
ACusto:={}

AADD(aCampos, {"CODPRO   " ,"C",15,0})
AADD(aCampos, {"DESCPRO   " ,"C",50,0})
AADD(aCampos, {"TIPOPRO   " ,"C",10,0})
AADD(aCampos, {"GRPPRO   " ,"C",10,0})
AADD(aCampos, {"CCUSTO   " ,"C",09,0})
AADD(aCampos, {"CCDESC   " ,"C",40,0})
AADD(aCampos, {"NROP      " ,"C",15,0})
AADD(aCampos, {"QTDPRO   " ,"N",14,2})
AADD(aCampos, {"QSCRAPC  " ,"N",14,2})
AADD(aCampos, {"CODDEF    " ,"C",6,0})
AADD(aCampos, {"DESCDEF    " ,"C",30,0})
AADD(aCampos, {"CCUNIT   " ,"N",20,6})
AADD(aCampos, {"CCTOTAL  " ,"N",20,6})
AADD(aCampos, {"RESP    " ,"C",50,0})

cArq := Criatrab( ,.F.)
dbCreate(cDirDocs+"\"+cArq,aCampos,"DBFCDXADS")             //Cria o arquivo no caminho especificado
dbUseArea(.T.,"DBFCDXADS",cDirDocs+"\"+cArq,"TRX",.F.,.F.) //Seleciona o arquivo para uso.


DbSElectArea("TEMP")

DbGotop()
cMov:=0
While !TEMP->(Eof())
	cMov := CustoOp(TEMP->ZZ6_OP,TEMP->ZZ6_PRODUT)
	DbSelectArea("TEMP")
	xValPer := TEMP->ZZ6_QUANT * CMOV // ALTERADO PELA AGLAIR 09/08
	PosC    := aScan(aDados,{|x|x[1]==TEMP->ZZ6_PRODUT})
	xDescCC := Posicione("CTT",1,xFilial("CTT")+ZZ6_CC,"CTT_DESC01")
	PosP    := aScan(aPerda,{|x|x[1]==ZZ6_PRODUT .and. x[7]==ZZ6_MOTIVO})
	aadd(aPerda,{ZZ6_PRODUT,;                  //[1]
	B1_DESC,;                 //[2]
	B1_TIPO,;                 //[3]
	B1_GRUPO,;                //[4]
	nil,;                     //[5]
	ZZ6_CODMOT,;               //[6]
	ZZ6_MOTIVO,;               //[7]
	ZZ6_QUANT,;                //[8]
	CMOV,;                    //[9] B2_CM1 ALTERADO PELO CUSTO DA MOVIMENTACAO
	xValPer,;                 //[10]
	SubStr(ZZ6_CC,1,6),;       //[11]
	SubStr(xDescCC,1,20),;    //[12]
	ZZ6_OP,; //[13]
	ZZ6_NOMEAU})                   //[14] Responsavel
	
	TEMP->(DBSKIP())
	
Enddo

dbSelectArea("TEMP")
dbClearFil(NIL)
dbCloseArea("TEMP")
dbCloseArea()
dbCloseArea("TRX")

Return()

/**************************************************************/
/*Calculo do custo médio apartir das movimentações do periodo**/
/**************************************************************/

Static Function CustoOP(NrOp,Cod)
Local Pos:=0

Pos:=AScan(ACusto,{|x|Alltrim(x[1]==NrOp)})
if Pos<>0
	CMov:=ACusto[Pos][2]
Else
	Aadd(aCusto,{NrOp,0})
EndIf

DbSelectArea("SD3")
DbSetOrder(1)

Chave := xFilial("SD3")+NrOp+space(13-Len(NrOp))+Cod
CustoTotal := 0
QtdTotal   := 0
Cmov       := 0

dbSelectArea("SD3")

If DbSeek(Chave) .and. Pos=0
	While !Eof()
		If (Alltrim(NrOp)=Alltrim(SD3->D3_OP)) .and. ALLTRIM(SD3->D3_COD)=ALLTRIM(Cod) .and. D3_TM='400'
			CustoTotal+=SD3->D3_CUSTO1
			QtdTotal+=SD3->D3_QUANT
		ElseIf !(Alltrim(NrOp)=Alltrim(SD3->D3_OP))
			Exit
			//Cast( SUM(D3_CUSTO1)/SUM(D3_QUANT)  as Numeric(7,2) )
		EndIF
		DbSelectArea("SD3")
		DbSkip()
	EndDo
Endif

If CustoTotal>0 .and. QtdTotal>0 .and. Pos=0
	CMOV:=CustoTotal/QtdTotal
	ACusto[Len(Acusto)][2]:=cMov
EndIF

Return cMOV
//
//
//
Static Function DetMatr22()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Impressao do Relatorio                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(Len(aPerda))

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
//TotSG:=0
xCond   := .t.
xDescri := ""
i := 1
TotSG:=0
TotCCG:=0

While i <= Len(aPerda)
	IncRegua()
	_Prod  := aPerda[i][01]
	_DProd := aPerda[i][02]
	_TProd := aPerda[i][03]
	_GProd := aPerda[i][04]
	_Resp  := aPerda[i][14]
	
	n_Quant   := 0
	n_Custo   := 0
	n_QtdOri  := aPerda[i][11]
	c_Produto := aPerda[i][01]
	xQuantPro := GetOri(aPerda[i][01])
	
	_QtdProd := Transform(xQuantPro,"@E 999,999")
	
	
	@ li,000      PSAY aPerda[i][01]    // Produto
	@ li,PCOL()+2 PSAY aPerda[i][02]    // Descricao
	@ li,PCOL()+2 PSAY aPerda[i][03]    // Tipo
	@ li,PCOL()+2 PSAY aPerda[i][04]    // Grupo
	@ li,PCOL()+2 PSAY Transform(xQuantPro,"@E 999,999")//Transform(_aInd[nPos][02],"@E 999,999") QtdProd
	
	nPsc := PCOL()
	Vz := 1
	
	While i <= Len(aPerda) .And. c_Produto == aPerda[i][01]
		
		IncRegua()
		
		xCond := .f.
		_CodMov := aPerda[i][06]
		_DesMov := aPerda[i][07]
		_cCUSTO := aPerda[i][11]
		_CCDESC := aPerda[i][12]
		_OP     := aPerda[i][13]
		_Resp  := aPerda[i][14]
		
		If Mv_par12 = 1
			@ li,nPsc+2   PSAY aPerda[i][13]												// Op
			@ li,Pcol()+2 PSAY aPerda[i][06]												// Cod Motivo
			@ li,PCOL()+2 PSAY aPerda[i][07]												// Des Motivo
			@ li,PCOL()+1 PSAY Transform(aPerda[i][08],     "@E 999,999")	            // Quantidade
			@ li,PCOL()+1 PSAY Transform(aPerda[i][09],"@E 9,999.999999")	            // Custo Unit
			@ li,PCOL()+1 PSAY Transform(aPerda[i][10],  "@E 999,999.9999")	            // Custo Total  AUMENTO DA CASA DECIMAL 04/12/13
			@ li,PCOL()+1 PSAY aPerda[i][11]												// Cod CCusto
			@ li,PCOL()+1 PSAY aPerda[i][12]
			@ li,PCOL()+1 PSAY "|"+aPerda[i][14] //responsavel
			n_Custo += aPerda[i][10]
			n_Quant += aPerda[i][08]												// Des CCusto
			li ++
		Else  // Sintetico
			c_Perda  := aPerda[i][06]
			c_DesMot := aPerda[i][07]
			xTotMovQ := 0
			xTotMovC := 0
			While i <= Len(aPerda) .And. c_Produto == aPerda[i][01] .And. c_Perda == aPerda[i][06]
				xTotMovQ += aPerda[i][08]
				xTotMovC += aPerda[i][10]
				n_Custo += aPerda[i][10]
				n_Quant += aPerda[i][08]
				i++
			EndDo
			@ li,nPsc+2   PSAY c_Perda   										// Cod Motivo
			@ li,PCOL()+2 PSAY c_DesMot											// Des Motivo
			@ li,PCOL()+1 PSAY Transform(xTotMovQ,         "@E 999,9999")	        // Quantidade
			@ li,PCOL()+1 PSAY Transform(xTotMovC/xTotMovQ,"@E 9,999.999999")	// Custo Unit
			@ li,PCOL()+1 PSAY Transform(xTotMovC,         "@E 999,999.999")	    // Custo Total
			@ li,PCOL()+1 PSAY _cCUSTO											// Cod CCusto
			@ li,PCOL()+1 PSAY _CCDESC											// Des CCusto
			@ li,PCOL()+1 PSAY "|"+_Resp 								// Responsavel
			li ++
		EndIf
		
		If li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		End
		
		/********************************************************************************************************/
		/**Gravação da tabela temporaria               ******************************************************/
		
		dBselectArea("TRX")
		RecLock("TRX",.T.)
		TRX->CODPRO  :=	_Prod
		TRX->DESCPRO := _DProd
		TRX->TIPOPRO := _TProd
		TRX->GRPPRO  := _GProd
		TRX->CCUSTO  := _cCUSTO
		TRX->CCDESC  := _CCDESC
		TRX->RESP    :=_Resp
		If Vz == 1
			TRX->QTDPRO := xQuantPro
			Vz++
		Endif
		TRX->QSCRAPC := Iif(Mv_par12==1,aPerda[i][08],xTotMovQ)
		TRX->CODDEF  := Iif(Mv_par12==1,aPerda[i][06],_CodMov)
		TRX->DESCDEF := Iif(Mv_par12==1,aPerda[i][07],_DesMov)
		TRX->CCUNIT  := Iif(Mv_par12==1,aPerda[i][09],xTotMovC/xTotMovQ)
		TRX->CCTOTAL := Iif(Mv_par12==1,aPerda[i][10],xTotMovC)
		TRX->NROP    := Iif(Mv_par12==1,aPerda[i][13],_OP)
		/*			TRX->TIPO   := Iif(xDocs[xI][01]=="S","SCRAP     ",Iif(xDocs[xI][01]=="R","FORNECEDOR","DEVOLUCAO "))
		TRX->_LOCAL := Iif(xDocs[xI][12]=="231","INJECAO PLASTICA",Iif(xDocs[xI][12]=="221","IMPRESSAO","MONTAGEM "))
		TRX->LOTECTL := xDocs[xI][15]*/
		MsunLock()
		/*******************************************************************************************************/
		If Mv_par12 == 1
			i++
		End
	EndDo
	
	@ li,017 PSAY "Total de Perdas do Produto "
	@ li,Iif(mv_par12==1,099,99-16)  PSAY Transform(100*n_Quant/xQuantPro , "@E 999.999%")	// Quantidade
	@ li,Iif(mv_par12==1,139,139-16) PSAY Transform(n_Quant              , "@E 999,999")	// Quantidade
	@ li,Iif(mv_par12==1,159,159-15) PSAY Transform(n_Custo , "@E 999,999.9999")	// Custo Total
	/***Totalizador das perdas  *****/
	TotSG+=n_Quant
	TotCCG+=n_Custo
	
	/*********************************************************************************************************************************/
	/*Incluindo Sub-Totais na tabela temporária ******************************************************************************/
	dBselectArea("TRX")
	RecLock("TRX",.T.)
	TRX->CODPRO  :=	"SUB-TOTAL"
	TRX->DESCPRO:=	_Prod
	TRX->CCUSTO:=_cCUSTO
	TRX->CCDESC:= _CCDESC
	TRX->QSCRAPC	:=n_Quant
	TRX->CCTOTAL:=n_Custo
	MsunLock()
	
	///*********************************************************************************************************************************/
	
	
	li++
	@ LI,000 PSAY Replicate("-",Limite)
	li++
	if xCond
		i++
	End
EndDo
/*Incluindo totalizacao na tabela temporaria*/
IF TotSG>0
	dBselectArea("TRX")
	RecLock("TRX",.T.)
	TRX->CODPRO  :=	"TOTAL GERAL"
	TRX->QSCRAPC	:= TOTSG
	TRX->CCTOTAL:=TotCCG
	MsunLock()
Endif
/**/

IF li != 80
	roda(cbcont,cbtxt,tamanho)
EndIF

Set Device To Screen

If aReturn[5] == 1
	Set Printer to
	dbCommitAll()
	ourspool(wnrel)
Endif
SExcel:=Msgbox("Deseja gerar o relatorio em Excel","Relatorio","YESNO")
If  SExcel
	cDirDocs  :="\RELATO\"
	cPath="C:\RELATORIO_SIGA\"
	cNome := "MATR25V2.XLS"
	If  File (cPath+CNome)
		//	      	MsgBox("Exclua o arquivo "+CPath+CNome+", se não for feito o arquivo não será re-gerado ","Atenção", "ALERT")
	Endif
	dbSelectArea("TRX")
	COPY TO &(cDirDocs+cNome) VIA "DBFCDXADS"
	CpyS2T( cDirDocs+cNome , cPath ) //cDirDocs+"\"+cArq+".DBF"
	fErase(cDirDocs+cNome)
	If ! ApOleClient( 'MsExcel' )        //Verifica se o Excel esta instalado
		MsgStop( 'MsExcel nao instalado' )
		//           MSGBOX("Foi gerado o Arquivo 'CLIENTES.XLS'","Informacao","INFO")
		Return
	EndIf
	
	oExcelApp := MsExcel():New()     // Cria um objeto para o uso do Excel
	oExcelApp:WorkBooks:Open(cPath+"\"+cNome) // Atribui à propriedade WorkBooks do Excel
	// o Arquivo criado com as informacoes acumuladas do SRC
	oExcelApp:SetVisible(.T.)   // Abre o Excel com o arquivo criado exibido na Primeira planilha.
	
	MSGBOX("Foi gerado o Arquivo 'MATR25V2.XLS'","Informacao","INFO")
	
Endif
DbSelectArea("TRX")
DbCloseArea("TRX")



MS_FLUSH()

Return
//
//
//
Static Function GetOri(xCodPro)

cQuery := "SELECT SUM(D3_QUANT)+ SUM(D3_PERDA) AS PROD "
cQuery +=    "FROM " + RetSqlName("SD3") + " SD3 "
cQuery += "WHERE "
cQuery +=    "D3_TM  = '400' "
cQuery +=    "AND D3_COD = '" + xCodPro +"' "
cQuery +=    "AND D3_EMISSAO BETWEEN '" + DTOS(MV_PAR03)+ " ' AND '" + DTOS(MV_PAR04)+ "' "
cQuery +=    "AND D3_ESTORNO <> 'S' "
cQuery +=    "AND SD3.D_E_L_E_T_ = '' "
cQuery := ChangeQuery(cQuery)

TCQUERY cQuery Alias PROD New

DbSElectArea("PROD")
xQtdProd := PROD

dbClearFil(NIL)
dbCloseArea("TEMP")
dbCloseArea()
Return(xQtdProd)
#include "rwmake.ch"

#DEFINE ITEMNUMBER 	1
#DEFINE SUPP 			2
#DEFINE USER 			3
#DEFINE ITEMNAME 		4
#DEFINE ODNO 			5
#DEFINE DATEINDICATED 	6
#DEFINE QTYINDICATED 	7






User Function EDI004()

SetPrvt("NOPCA,ODLG,CMENS,CGRV,CGRVF1,CGRVD1")
SetPrvt("CTYPE,CARQUIVO,ACPO,CTRB,CSTRING,CDESC1")
SetPrvt("CDESC2,CDESC3,TAMANHO,ARETURN,NOMEPROG,LCONTINUA")
SetPrvt("ALINHA,NLASTKEY,LEND,TITULO,CABEC1,CABEC2")
SetPrvt("CCANCEL,LI,M_PAG,WNREL,TVALPAG,TVALCOB")
SetPrvt("TVALOUT,XTITPAG,XTITCOB,XTITOUT,NTIPO,XVALDOC")
SetPrvt("XVALPAG,")


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Fun‡…o    ³ EDI003   ³ Autor ³Remerson Yoshiyuki Mogi³ Data ³ 04.05.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Importacao de arquivo kanban HONDA                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteracoes³ * Jorge Em: 26/05/2009                                     ³±±
±±³          ³ Solicitacao Honda - Foi incluido na Ordem de Expedicao, o  ³±±
±±³          ³ Campo CK_Entrega (Local de Entrega)                        ³±±
±±³          ³ * Jorge Em: 28/05/2009                                     ³±±
±±³          ³ Substituida forma de identificacao da posicao do _aCols,   ³±±
±±³          ³ do Numero informado, pelo ASCAN do vetor _aHeader.         ³±±
±±³          ³ * Jorge Em: 14/09/2009                                     ³±±
±±³          ³ Separacao da "ORDEM DE EXPEDICAO", sempre que o Cliente    ³±±
±±³          ³ solicitar o "LOCAL DE ENTREGA" diferente em um mesmo       ³±±
±±³          ³ Pedido de Compra (kanban).                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Função    ³ EDI004   ³ Autor ³Wagner da Gama Corrêa  ³ Data ³ 07.11.17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Importacao de arquivo kanban YAMAHA                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±

/*/

nOpca  := 0
oDlg   := ""
cMens  := ""
cGrv   := ""
cGrvF1 := ""
cGrvD1 := ""
cGrv   := ""

@ 96, 013 TO 310, 592 DIALOG oDlg TITLE "Importacao de arquivo de orçamento do kanban - YAMAHA"
@ 18, 006 TO 066, 287
@ 29, 015 SAY OemToAnsi("Este programa tem como objetivo Importar os dados do arquivo (Kanban da Yamaha).")

@ 80, 160 BUTTON "Importar" SIZE 034, 011 ACTION A010I()
@ 80, 220 BMPBUTTON TYPE 2 ACTION A010Fim()
ACTIVATE DIALOG oDlg
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Fun‡…o    ³A010I     ³ Autor ³Remerson Yoshiyuki Mogi³ Data ³ 01.11.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Selecionar o arquivo de Importacao de dados                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A010I()
Private aFile := {}

nOpca    := 0
cType    := "Kanban da Yamaha | *.TXT"
cArquivo := cGetFile(cType, OemToAnsi("Selecione arquivo "+Subs(cType,1,17)))

If !Empty( cArquivo )
	If File( cArquivo)
		nOpca := 1
	Else
		MsgAlert("Arquivo nao encontrado")
	Endif
Endif

If nOpca == 1
	Processa({|| ProcImp(cArquivo) })
EndIf
Close(oDlg)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ProcImp  ³ Autor ³Remerson Yoshiyuki Mogi³ Data ³ 03.05.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processamento de Importacao dos Dados                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ProcImp(cArquivo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo de Trabalho.                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*aCpo := {}

aADD(aCpo, {"TR_CODITE", "C", 14, 0}) // 10
aADD(aCpo, {"TR_SUPP",   "C", 04, 0}) // 11
aADD(aCpo, {"TR_USER",   "C", 04, 0}) // 12
aADD(aCpo, {"TR_ODNO",   "C", 08, 0}) // 13
aADD(aCpo, {"TR_DTENTR", "C", 08, 0}) // 18
aADD(aCpo, {"TR_QTDTOT", "C", 07, 0}) // 20

cTRB := CriaTrab( aCpo, .T.)
dbUseArea(.T.,, cTRB, "TRB", .T., .F.)

APPEND FROM &(cArquivo) SDF // DELIMITED
TRB->(dbgotop())*/
fwLerArq(cArquivo)

A020I() // Impressao do Relatorio.


Return

/*
+---------------------------------------------------------------------------
±±³Funcao    | A020I     ³ Autor ³Remerson Yoshiyuki Mogi³ Data ³ 01.11.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Impressao da saida dos produtos a ser faturado.             ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function A020I()

cString   := "TRB"
cDesc1    := OemToAnsi("Este programa tem como objetivo, demostrar a utiliza‡Æo ")
cDesc2    := OemToAnsi("das ferramentas de impressÆo do Interpretador xBase.      ")
cDesc3    := ""
tamanho   := "M"
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "EDI004"
lContinua := .T.
aLinha    := { }
nLastKey  := 0
lEnd      := .f.
titulo    := "                              K A N B A N   D A   Y A M A H A                                      "
cabec1    := "                                                        |            P R E V I S Ã O               "
cabec2    := " Codigo NSB       Descrição                       Modelo|  Nro Ped  Cod  DT. Ent   Hora  Qtd/Prod TP Linha  Fl   Setor Destino Local Entrega"
//             123456789012345  123456789012345678901234567890  123456  12345678  123  DD/MM/AA  HH:MM  234.567 99 123456 1234 123456789012  123456789012
//            01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//                      1         2         3         4         5         6         7         8         9        10        11         12        13
cCancel := "***** CANCELADO PELO OPERADOR *****"

li     := 80
m_pag  := 01

wnrel := "EDI004" // Nome Default do relatorio em Disco
SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|| RptDetail() })

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Fun‡„o    ³RptDetail ³ Autor ³Jefferson Moreira      ³ Data ³ 03.05.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Impressao do corpo do relatorio                             ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RptDetail()

vProd:={}

xNovoPlano := .T.
xGravaDB   := .T.
xCodProNSB := ""

cPedido := 0
xItem   := 0
aInfPed := {}
nTipo   := IIF(aReturn[4]==1,15,18)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)

SetRegua(Len(aFile))

cPedido := ""
//cPedido:=GetSX8Num("SCJ","CJ_NUM")
//ConfirmSX8()

lExiste := .T.
Do While lExiste
	cPedido:=GetSX8Num("SCJ","CJ_NUM")
	confirmsx8()
	If Empty(POSICIONE('SCJ', 1,  xFilial('SCJ')+ cPedido, 'CJ_NUM'))
		lExiste := .F.
	Endif
Enddo

dbSelectArea("SCJ")

SA1->(dbSetOrder(1))
SA1->(DbSeek(xFilial("SA1") + "002" ))                 //Clinte Honda

aadd(aCabec,{"CJ_FILIAL" 	,xFilial("SCJ"),Nil})
aadd(aCabec,{"CJ_NUM"		,cPedido,Nil})
aadd(aCabec,{"CJ_TIPO"		,"N",Nil})
aadd(aCabec,{"CJ_CLIENTE"	,SA1->A1_COD,Nil})
aadd(aCabec,{"CJ_LOJAENT"	,SA1->A1_LOJA,Nil})
aadd(aCabec,{"CJ_LOJA"		,SA1->A1_LOJA,Nil})
aadd(aCabec,{"CJ_MOEDA"		,1,Nil})
aadd(aCabec,{"CJ_TIPLIB"	,"1",Nil})
aadd(aCabec,{"CJ_CLIENT"	,SA1->A1_COD,Nil})
aadd(aCabec,{"CJ_CONDPAG"	,SA1->A1_COND,Nil})
aadd(aCabec,{"CJ_TABELA"	,SA1->A1_TABELA,Nil})
aadd(aCabec,{"CJ_STATUS"	,"A",Nil})
aadd(aCabec,{"CJ_EMISSAO"	,dDataBase,Nil})
aadd(aCabec,{"CJ_TPCARGA"	,"1",Nil})

For nX:=1 To Len(aFile)
	
	IncRegua()
	
	If lContinua
		
		#IFNDEF WINDOWS
			If LastKey() == 286
				lEnd := .t.
			End
		#ENDIF
		
		If lEnd
			@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
			lContinua := .F.
			Exit
		Endif
		
		xCodProCli := Alltrim(Transform(aFile[nX,ITEMNUMBER],"@E999-99999-99-99-99"))+"-"+aFile[nX,SUPP]+"-"+aFile[nX,USER]
		xNumPed    := aFile[nX,ODNO]           // Nro pedido do cliente
		xDtEnt     := StoD(aFile[nX,DATEINDICATED])           // Data de entrega do pedido
		xQtd       := VAL(aFile[nX,QTYINDICATED])
		//
		// Procura o codigo da NIPPON SEIKI
		//
		
		SA7->(DbSetOrder(4))
		If SA7->(DbSeek(xFilial("SA7") + xCodProCli  ))              // CODPRODCLI+CLIENTE
			xCodProNSB    := A7_PRODUTO                      // Codigo do Produto NSB
			xDesCliProNSB := AllTrim(A7_DESCCLI)+"  "+AllTrim(A7_PRODUTO)  // Descrição do Produto no Pedido
			
			SB1->(DbSetOrder(1))
			SB1->(DBSEEK(XFILIAL("SB1") + xCodProNSB))
			
			SF4->(DBSETORDER(1))
			SF4->(DBSEEK(XFILIAL("SF4") + SB1->B1_TS))            //FILIAL+CODIGO(TES)
			
			DA1->(dbSetOrder(1))                                   //FILIAL + TABELA + PRODUTO
			DA1->(DBSEEK(XFILIAL("DA1") + SA1->A1_TABELA +  SB1->B1_COD))
						
			aLinha := {}
			aadd(aLinha,{"CK_NUM"		,xFilial("SCK"),Nil})
			aadd(aLinha,{"CK_NUM"		,cPedido,Nil})
			aadd(aLinha,{"CK_ITEM"		,StrZero(nX,2),Nil})
			aadd(aLinha,{"CK_PRODUTO"	,SB1->B1_COD,Nil})
			aadd(aLinha,{"CK_UM"		,SB1->B1_UM,Nil})
			aadd(aLinha,{"CK_QTDVEN"	,xQtd,Nil})
			aadd(aLinha,{"CK_PRUNIT"	,xPrcVen,Nil})
			aadd(aLinha,{"CK_PRCVEN"	,xPrcVen,Nil})
			aadd(aLinha,{"CK_VALOR"		,xQtd*xPrcVen,Nil})
			aadd(aLinha,{"CK_TES"		,SB1->B1_TS,Nil})
			aadd(aLinha,{"CK_CLASFIS"	,Substr(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB,Nil})
			aadd(aLinha,{"CK_DESCRI"	,SB1->B1_DESCRI,Nil})
			aadd(aLinha,{"CK_PEDCLI"	,xNumPed,Nil})
			aadd(aLinha,{"CK_LOCAL"   	,SB1->B1_LOCPAD,Nil})
			aadd(aLinha,{"CK_ENTREG"	,DtoC(xDtEnt),Nil})
			aadd(aLinha,{"CK_SETOR" 	,"YAMAHA",Nil})
			aadd(aLinha,{"CK_ENTREGA"   ,"YMDA",Nil})
			aadd(aLinha,{"CK_LOCALIZ"   ,"EXPEDICAO",Nil})
			aadd(aLinha,{"CK_HORA"		,"0900",Nil})
			aadd(aLinha,{"CK_FILVEN" 	,"01",Nil})
			aadd(aLinha,{"CK_FILENT" 	,"01",Nil})
			aadd(aLinha,{"CK_CLIENTE"	,"028",Nil})
			aadd(aLinha,{"CK_LOJA"   	,"01",Nil})
			aadd(aItens,aLinha)
		Else
			msgstop("Produto Não Cadastrado..." + xCodProCli)
		End
	EndIf
Next nX


//asort(vProd,,,{|x,y| x[05] + x[06] < y[05] + y[06]})

For i:=1 to len(vProd)
	
	
	@ li,001      PSAY SUBS(vProd[i][1],1,15)
	@ li,PCOL()+2 PSAY SUBS(xDesProNSB,1,30)
	@ li,PCOL()+2 PSAY SUBS(xModelo,1,6)
	
	@ li,PCOL()+2 PSAY vProd[i][3]
	@ li,PCOL()+2 PSAY vProd[i][5]
	@ li,PCOL()+2 PSAY SUBS(vProd[i][4],1,2)+"/"+SUBS(vProd[i][4],3,2)+"/"+SUBS(vProd[i][4],7,2)
	
	@ li,083      PSAY SUBS( vProd[i][6],1,2)+":"+SUBS( vProd[i][6],3,2)
	@ li,PCOL()+2 PSAY TRANSFORM(vProd[i][7],"@E 999,999")
	@ li,PCOL()+1 PSAY vProd[i][11]
	@ li,PCOL()+1 PSAY vProd[i][8]
	@ li,PCOL()+1 PSAY SUBS(vProd[i][9],8,5)//@ li,PCOL()+1 PSAY SUBS(vProd[i][9],8,4) Alterado para atender o xml da Honda do siga
	@ li,PCOL()+1 PSAY SUBS(vProd[i][10],1,20)
	@ li,PCOL()+1 PSAY SUBS(vProd[i][12],1,20)
	li++
	
	If vProd[i][5] # vProd[IIF(i>1,i-1,1)][5] .or. vProd[i][6] # vProd[IIF(i>1,i-1,1)][6] .or. i==1
		
		
	EndIf
	
	
	// ************************************** IMPORTANTE **********************************//
	//                     NAO ESQUECER DE ALTERAR O PROGRAMA NSACDG03                     //
	// ************************************** IMPORTANTE **********************************//
	
	//SCK->CK_TPOP   := "F"
	//SCK->CK_CLI    := "002"
	//SCK->CK_CLASFIS:= xSitTrb
	AADD(aInfPed,{CK_NUM,CK_ITEM,CK_HORA,CK_LOCAL,CK_LINHA,CK_SETOR,CK_TPEDIDO,CK_ENTREGA})
	xItem++
	
Next

Roda(0,"","M")
Set Filter To

dbCloseArea()
fErase( cTRB )
dbClearFil(NIL)
dbCloseArea("TRB")
dbCloseArea()

If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return


**********************************
Static Function A010Fim()
**********************************
Close(oDlg)

Return




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MTA416PV ³ Autor ³Jefferson Mpreira      ³ Data ³ 04.06.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualizacao do pedido conforme orcamento de venda          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ AP8 Efetivacao do Orcamento de Venda                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteracoes³ * Jorge Em: 26/05/2009                                     ³±±
±±³          ³ Solicitacao Honda - Foi incluido na Ordem de Expedicao, o  ³±±
±±³          ³ Campo CK_Entrega (Local de Entrega)                        ³±±
±±³          ³ * Jorge Em: 28/05/2009                                     ³±±
±±³          ³ Substituida forma de identificacao da posicao do _aCols,   ³±±
±±³          ³ do Numero informado, pelo ASCAN do vetor _aHeader.         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

**********************************
User Function 2MTA416PV()
**********************************

xNum  := SUBS(_aCols[Len(_aCols)][41],1,6)
xItem := SUBS(_aCols[Len(_aCols)][41],7,2)

dbSelectArea('SCK')
dbSetOrder(1)
If dbSeek(xFilial("SCK") + xNum + xItem )
	
	dbSelectArea("SA7") //Tabela: Produto X Cliente
	dbSetOrder(2)
	If dbSeek(xFilial("SA7") + SCK->CK_PRODUTO + SCK->CK_CLIENTE + SCK->CK_LOJA)
		xDesCliProNSB := AllTrim(A7_DESCCLI) + "  " + IIF( SCK->CK_TES $ "520", ALLTRIM( A7_CODASTE), ALLTRIM(A7_CODCLI) )
	Else
		xDesCliProNSB := SCK->CK_DESCRI // Descrição do Produto da NSB
	End
	
	dbSelectArea('SCK')
	_aCols[Len(_aCols)][ASCAN(_aHeader, {|x| Alltrim(x[2]) == "C6_LINHA"	   })] := CK_LINHA
	_aCols[Len(_aCols)][ASCAN(_aHeader, {|x| Alltrim(x[2]) == "C6_HORA"	   })] := CK_HORA
	_aCols[Len(_aCols)][ASCAN(_aHeader, {|x| Alltrim(x[2]) == "C6_TPEDIDO"  })] := CK_TPEDIDO
	_aCols[Len(_aCols)][ASCAN(_aHeader, {|x| Alltrim(x[2]) == "C6_SETOR"	   })] := CK_SETOR
	_aCols[Len(_aCols)][ASCAN(_aHeader, {|x| Alltrim(x[2]) == "C6_DESCRI"   })] := xDesCliProNSB + " LOTE: "+ ALLTRIM(CK_LOTECTL) + " PED: " + CK_PEDCLI
	_aCols[Len(_aCols)][ASCAN(_aHeader, {|x| Alltrim(x[2]) == "C6_ENTREGA"  })] := CK_ENTREGA
	_aCols[Len(_aCols)][ASCAN(_aHeader, {|x| Alltrim(x[2]) == "C6_LOTECTL"  })] := CK_LOTECTL
	_aCols[Len(_aCols)][ASCAN(_aHeader, {|x| Alltrim(x[2]) == "C6_LOCALIZ"  })] := CK_LOCALIZ
	_aCols[Len(_aCols)][ASCAN(_aHeader, {|x| Alltrim(x[2]) == "C6_FILIALP"  })] := CK_FILIALP //Incluido para atender a Honda dia 10/06
	//
	M->C5_VOLUME1 += _aCols[Len(_aCols)][ASCAN(_aHeader, {|x| Alltrim(x[2]) == "C6_QTDVEN" })]
	//
	If Empty(M->C5_ESPECI1) .AND. ( Alltrim(M->C5_CLIENTE) == "028" .OR. Alltrim(M->C5_CLIENTE) == "002" )
		M->C5_ESPECI1   := "GRANEL"
	Endif
	If Empty(M->C5_MENNOTA)
		M->C5_MENNOTA := "FAVOR CHECAR O No. DO LACRE: "
	Endif
	//
Endif
dbCloseArea('SCK')
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ fwLerArq   ¦ Autor ¦ Arlindo Neto         ¦ Data ¦ 06/11/2017 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Função para leitura dos arquivos de arquivos .csv             ¦¦¦
¦¦¦           ¦                                          		    		  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function fwLerArq(cArq)

Local cLinha := ""
Local cSubLin:= ""
Local aLinha := {}
Local nFile  := 0

If File(cArq)
	FT_FUse(cArq)
	FT_FGOTOP()
	While !FT_FEOF()
		cLinha := FT_FReadLN()
		cLinha := StrTran(cLinha, ",", ".")
		For nI := 1 to Len(cLinha)+1
			If SubStr(cLinha,nI,1)=Chr(59) .Or. SubStr(cLinha,nI,2)=Chr(13)+Chr(10) .Or. (Len(cLinha)+1=nI) .Or.;
				SubStr(cLinha,nI,1)=Chr(9)  .Or. SubStr(cLinha,nI,1)=Chr(11)
				
				If Len(cSubLin)=0
					cSubLin := " "
				EndIf
				
				aAdd(aLinha,cSubLin)
				cSubLin := ""
			else
				cSubLin += SubStr(cLinha,nI,1)
			EndIF
		Next nI
		aAdd(aFile,array(Len(aLinha)))
		aFile[Len(aFile)] := aClone(aLinha)
		aLinha := {}
		FT_FSKIP()
	Enddo
	nFile:=Len(aFile)
	FT_FUSE()
EndIf

Return aFile

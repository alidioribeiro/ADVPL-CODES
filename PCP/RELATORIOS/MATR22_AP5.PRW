#include "rwmake.ch"

User Function Matr22()

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
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ	ÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR22   ³ Autor ³ Jorge Silveira        ³ Data ³ 06.04.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ocorrencias de Horas Paradas, por Recurso.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ rdmake MATR22 -x                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 

############################################################################
## Modificado Por : Jefferson Moreira                   Data: 15/02/06 #####
############################################################################
## Mudança : Foi colocado o campo da assinatura do Diret./Gerencia para ####
## baixo do campo da assinatura do Processo ################################
############################################################################

/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


titulo    := "Relacao de Perdas por OP."
cDesc1    := "Este programa tem com objetivo, imprimir a Relacao de Perdas por Ordem"
cDesc2    := "de Produção, no período especificado."
cDesc3    := ""
tamanho   := "P"
limite    := 80
cString   := "SZ6"
aOrd      := {} //-- Ordem
lContinua := .T.
cUM       := ""
lEnd      := .F.
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "MATR22"
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
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel  := "MATR22"
wnrel  := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,)

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cabec1 := "Data      Motivo da perda                 Quant  Indice      C  U  S  T  O  S"
cabec2 := "                                                            Unitario      Total"
//         99/99/99  99 xxxxxxxxxxxxxxxxxxxxxxxxxxxx 9.999 999.99% 9.999,999999 999.999,99
//         01234567890123456789012345678901234567890123456789012345678901234567890123456789
//                   1111111111222222222233333333334444444444555555555566666666667777777777

If nLastKey == 27
	Return
Endif

nTipo  := IIF(aReturn[4]==1,15,18)

// cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)

#IFDEF WINDOWS
	Processa( {|| ExeMatr22()})
	RptStatus({|| DetMatr22()})
	Return
#ENDIF

Static Function ExeMatr22()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento da Nota Fiscal                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cbtxt  := Space(10)
cbcont := 00
_xI    := 1

dbSelectArea("SZ6")
cArqNtx  := CriaTrab(NIL,.f.)
cIndCond := 'Z6_Filial+Z6_Recurso+DTOS(Z6_Emissao)+Z6_Turno+Z6_Cod'
IndRegua('SZ6',cArqNtx,cIndCond,,,'Selecionando Registros...')
dbSeek(xFilial("SZ6")+mv_par01,.T.)
ProcRegua(RecCount())

While !Eof() .And. Z6_Recurso<=mv_par02 .And. xFilial()==Z6_FILIAL .And. lContinua
	
	IncProc("Selecionando registros...") 
	
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
	
	If Z6_Emissao < mv_par03 .or. Z6_Emissao > mv_par04
		dbSkip()
		Loop
	EndIf
	
	dbSelectArea("SH1")    
	dbSetOrder(1)
	dbSeek(xFilial("SH1")+SZ6->Z6_RECURSO)
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+SZ6->Z6_COD)
	
	dbSelectArea("SC2")
	dbSetOrder(1)
	dbSeek(xFilial("SC2")+SZ6->Z6_OP)
	
	dbSelectArea("SD3") 
	dbSetOrder(2)
	dbSeek(xFilial("SD3")+SZ6->Z6_DOC+SZ6->Z6_COD)
	
	dbSelectArea("SI3")
	dbSetOrder(1)
	dbSeek(xFilial("SI3")+SD3->D3_CC)
	
	dbSelectArea("SZ6")
	
	If SD3->D3_ESTORNO == "S"
		dbSkip()                             
		Loop
	EndIf
	
//	If SD3->D3_CC < mv_par05 .or. SD3->D3_CC > mv_par06
    If SC2->C2_CC < mv_par05 .or. SC2->C2_CC > mv_par06
		dbSkip()                             
		Loop
	EndIf
	
	If SZ6->Z6_ESTORNO == "S"
		dbSkip()                             
		Loop
	EndIf
		
	aadd(xPerdas,{Z6_Recurso,;            // 1
	Z6_Emissao,;                          // 2
	Z6_Turno,;                            // 3
	Z6_Doc,;                              // 4
	Z6_Op,;                               // 5
	Z6_Cod,;                              // 6
	SB1->B1_Desc,;                        // 7
	SubStr(SD3->D3_CC,1,6),;              // 8
	SubStr(SI3->I3_DESC,1,20),;           // 9
	Z6_CodMot,;                           // 10
	Z6_Motivo,;                           // 11
	Z6_Quant })                           // 12
	
	dbSkip()
	
EndDo

aSort(xPerdas,,,{|x,y| x[5]+x[10] < y[5]+Y[10] })

While _xI <= Len(xPerdas)
	
	tPerda := 0
	xOp    := xPerdas[_xI][5]
	
	While _xI<=Len(xPerdas) .And. AllTrim(xOp) == AllTrim(xPerdas[_xI][5])
		
		tPerda += xPerdas[_xI][12]
		_xI++
		
	EndDo
	
	aAdd(_aInd,{xOp,tPerda})
	
EndDo

Return

*********************************
Static Function DetMatr22()
*********************************

SetRegua(Len(xPerdas))

xCond   := ""
xDescri := ""
xSeq    := 1

While xSeq <= Len(xPerdas)
	
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+xPerdas[xSeq][6])
	
	dbSelectArea("SC2")
	dbSetOrder(1)
	dbSeek(xFilial("SC2")+xPerdas[xSeq][5])
	
	dbSelectArea("SI3")
	dbSetOrder(1)
	dbSeek(xFilial("SI3")+SC2->C2_CC)
	
	tCusto := 0
	xOp    := xPerdas[xSeq][5]
	nPos   := Ascan(_aInd,{|x|x[1]==xPerdas[xSeq][5]})
	_nInd  := 100*_aInd[nPos][2]/SC2->C2_QUANT
	
	@ li,000      PSAY "Produto : "         + xPerdas[xSeq][6]+"  "+xPerdas[xSeq][7] 				; li ++
	@ li,000      PSAY "Data: "             + DTOC(SC2->C2_DATPRI)
	@ li,PCOL()+2 PSAY "OP: "               + xPerdas[xSeq][5]
	@ li,PCOL()+2 PSAY "Quant.: "           + Transform(SC2->C2_QUANT  ,"@E 999,999")
	@ li,PCOL()+2 PSAY "Entregue: "         + Transform(SC2->C2_QUJE   ,"@E 999,999")  				; li ++
	@ li,000      PSAY "Processo: "         + SubStr(SC2->C2_CC,1,4)+"  "+SubStr(SI3->I3_DESC,1,27)
	@ li,PCOL()+2 PSAY "Índice de Perdas: " + Transform(_nInd          ,"@E 999.99%" ) 				; li ++
	@ li,000      PSAY Replicate("-",limite)								 						; li ++
	
	
	While xSeq <= Len(xPerdas) .And. AllTrim(xOp) == AllTrim(xPerdas[xSeq][5])
		
		IncRegua()
		
		dbSelectArea("SD3")
		dbSetOrder(1)
		dbSeek(xFilial("SD3")+xPerdas[xSeq][5]+"  " + xPerdas[xSeq][6])
		
		xCus_Uni := (D3_Custo1 / D3_Quant)
		xCus_Tot := (xCus_Uni  * xPerdas[xSeq][12])
		tCusto   += xCus_Tot
		If Empty(Alltrim(xPerdas[xSeq][10]))
			xSeq ++
			Loop
		EndIf
		@ li,000      PSAY xPerdas[xSeq][2]													//      Dat. Movimento
		@ li,PCOL()+2 PSAY xPerdas[xSeq][10]												//      Cod.Motivo
		@ li,PCOL()+1 PSAY SubStr(xPerdas[xSeq][11],1,28)									//      Desc.Motivo
		@ li,PCOL()+1 PSAY Transform(xPerdas[xSeq][12],"@E 9,999")							//      Quantidade
		@ li,PCOL()+1 PSAY Transform(100*xPerdas[xSeq][12]/_aInd[nPos][2],"@E 999.99%")     //      Porcentagem
		@ li,PCOL()+1 PSAY Transform(xCus_Uni  ,"@E 9,999.999999")
		@ li,PCOL()+1 PSAY Transform(xCus_Tot  ,"@E 999,999.99"  )
		
		li   ++
		xSeq ++
		
		If li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		End
	EndDo
	
	li ++
	
	@ li,000 PSAY "Total de Perdas da OP "
	@ li,040 PSAY Transform(_aInd[nPos][2], "@E 999,999"    )
	@ li,069 PSAY Transform(tCusto        , "@E 999,999.99" )
	
	li ++
	
	@ li,000 PSAY Replicate("-",limite)
	
	li += 3
	
//	@ li,000 PSAY " Processo                    Almoxarifado                  C.Q.                " ; li += 2
//	@ li,000 PSAY " Data:___/___/___            Data:___/___/___              Data:___/___/___    " ; li += 3
//	@ li,000 PSAY " ___________________         ______________________        ___________________ " ; li ++
//	@ li,000 PSAY "     Assinatura                    Assinatura                  Assinatura      " ; li += 3  
	@ li,000 PSAY " Processo                    Almoxarifado                  " ; li += 2
	@ li,000 PSAY " Data:___/___/___            Data:___/___/___              " ; li += 3
	@ li,000 PSAY " ___________________         ______________________        " ; li ++
	@ li,000 PSAY "     Assinatura                    Assinatura              " ; li += 3  
		
	@ li,000 PSAY " Diret./Gerencia     " ; li += 2
	@ li,000 PSAY " Data:___/___/___    " ; li += 3
	@ li,000 PSAY " ____________________" ; li ++
	@ li,000 PSAY "     Assinatura      " ; li += 2
	
EndDo

IF li != 80
	roda(cbcont,cbtxt,tamanho)
EndIF

Set Device To Screen

dbSelectArea('SZ6')
RetIndex('SZ6')

If !(Type('ArqNtx') == 'U')
	fErase(cArqNtx)
Endif

If aReturn[5] == 1
	Set Printer to
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return
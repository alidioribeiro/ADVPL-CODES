#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
#INCLUDE "Protheus.ch"
#include "ap5mail.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

*****************************
User Function ValidSaldD4()
*****************************

//**********************************************************************
//* VALIDAวีES DO APONTAMENTO DE PERDAS CAMPOS DE PRODUTO E QUANTIDADE *   16/01/05 - Marcelo Iannuzzi
//**********************************************************************
//********************************
//*VALIDAวรO da Quantidade no SBC*
//********************************

Local nRecno   := Recno()
Local cAlias   := Alias()
Local cProduto := aCols[n,1]
Local lPode    := .T.

/*/
If Alltrim(SC2->C2_CC)=="231"
Return (lPode)
EndIf

dbSelectArea("SD4")
dbSetOrder(2)
dbSeek(xFilial()+PADR(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,tamsx3("D4_OP")[1]," ")+cProduto)
If M->BC_QUANT < D4_QUANT
Return(lPode)
EndIf

If aCols[n,4]<>"D"
If M->BC_QUANT > CALCEST(cProduto,"10",DDATABASE)[1]
MsgStop("Quantidade Superior เ quantidade Requisitada!"+chr(13)+"Informe quantidade vแlida.")
lPode:=.F.
EndIf
EndIf

/*/

If M->BC_QUANT > CALCEST(cProduto,"10",DDATABASE+1)[1]
	MsgStop("Sem Saldo para data Base.")
	lPode:=.F.
EndIf
dbSelectArea(cAlias)
dbGoto(nRecno)

Return(lPode)


******************************
User Function ValidProdD4()
******************************

//*****************************
//*VALIDAวรO Do Produto no SBC*
//*****************************

Local cArea    := GetArea()
Local cProduto := M->BC_PRODUTO
Local cPa      := SC2->C2_PRODUTO
Local lPode    := .T.
Local aStru    := GetStru(cPa)
Local nPos     := aScan(aStru,{|x| x[3]==cProduto})
If nPos==0
	MsgStop("Produto nใo pertence a Estrutura!")
	lPode := .F.
	RestArea(cArea)
	Return(lPode)
EndIf
If !Empty(SC2->C2_DATRF)
	MsgStop("OP Encerrada!")
	lPode := .F.
EndIf
RestArea(cArea)
Return(lPode)

***************************
User Function ValCPCod()
***************************

//***************************************************************************************
//*   Valida็ao dos campos de OP e Produto das requisi็oes automaticas Arquivo SCP      *
//***************************************************************************************

Local lRet   := .T.
Local a_Area := GetArea()
Local aStru  := {}
Local nPos   := 0
Local cComp  := ""
If Alltrim(FunName())<>"MATA105"
	Return(lRet)
EndIf
cComp := aCols[n][2]
If Empty(cComp) .or. Empty(aCols[n][6])
	Return(lRet)
EndIf

dbSelectArea("SC2")
dbSetOrder(1)
dbSeek(xFilial("SC2")+aCols[n][6])
cPa   := C2_PRODUTO
aStru := GetStru(cPa)
nPos  := aScan(aStru,{|x| x[3]==cComp})
If nPos==0
	MsgStop("Produto nใo pertence a Estrutura!")
	lRet := .F.
EndIf
RestArea(a_Area)
Return(lRet)


**********************************
User Function ValidCC()
**********************************

//***************************************************************************************
//*   Valida็ao do C. de Custo nas Movimenta็๕es de Perda de Produ็ใo                   *
//***************************************************************************************
IF !Empty(aCols[n][5])
	IF trim(aCols[n][5])$"211\231\221\241" .and. !Pertence("S")
		MsgStop("C.de Custos 211, 221 ou 231 usados somente para SCRAP.")
	ELSEIF trim(aCols[n][5])$"616" .and. !Pertence("R")
		MsgStop("C.de Custo 616 usado somente para REFUGO.")
	ELSEif trim(aCols[n][5])$"612"
		MsgStop("C.de Custo 612 usado somente para Devolucoes de Materiais.")
	EndIf
EndIf
Return(.T.)

**********************************
User Function ValidCC1()
**********************************

//***************************************************************************************
//*   Valida็ao do C. de Custo nas Movimenta็๕es de Perda de Produ็ใo                   *
//***************************************************************************************
IF !Empty(aCols[n][4])
	lSai := .t.
	
	Do case
		case trim(aCols[n][4])=="S" .and. !alltrim(M->BC_APLIC) $"211\231\221\241"
			// Alert("Voc๊ s๓ pode informar para tipo Scrap os CC 211,221,231 ou 241")
			Alert("Para Scrap de materiais, o C.Custo correto ้: 211,221,231 ou 241.")
			Alert("Voc๊ esta informando um C.Custo diferentede de 211,221,231 ou 241.")
			// lSai := .f.
		case trim(aCols[n][4])=="R" .and. !alltrim(M->BC_APLIC) $"616"
			//  Alert("Voc๊ s๓ pode informar para tipo Refugo o CC 616")
			Alert("Para Refugo de materiais, o C.Custo correto ้ 616.")
			Alert("Voc๊ estแ informando um C.Custo diferente de 616.")
			// lSai := .f.
		case trim(aCols[n][4])=="D" .and. !alltrim(M->BC_APLIC) $"612"
			Alert("Voc๊ s๓ pode informar para tipo Devolu็ใo o CC 612")
			lSai := .f.
	Endcase
	
EndIf
Return(lSai)


**********************************
User Function ValidDT()
**********************************

//***************************************************************************************
//*   Realiza verificacao das Datas de Validacao dos Fornecedores.                      *
//***************************************************************************************

Local nRecno   := Recno()
Local cAlias   := Alias()
Local cFornec  := M->CA120FORN
Local lPode    := .T.

dbSelectArea("SZL")
dbSetorder(1)
If dbSeek(xFilial("SZL")+cFornec)
	While !Eof() .And. ZL_CodFor == cFornec
		If ZL_DatVal < dDataBase
			MsgAlert("Fornecedor com validade vencida. "+ZL_CodVal+" "+dtoc(ZL_DatVal))
			lPode := .F.
		End
		dbSkip()
	End
End

dbSelectArea(cAlias)
dbGoto(nRecno)

Return(lPode)



*********************************
Static Function GetStru(cProd)
*********************************

dbSelectArea("SG1")
dbSetOrder(1)
dbSeek(xfilial()+cProd)
aStr  := {}
aPai  := {}
aTmp  := {}
cPai  := SG1->G1_COD
nPos  := Recno()
nPos2 := 0
Z     := 0

While cPai == SG1->G1_COD .and. !Eof()
	nPos   := Recno()
	cFilho := SG1->G1_COMP
	
	If dDataBase >= SG1->G1_INI .and. dDataBase <= SG1->G1_FIM
		If dbSeek(xFilial()+cFilho)
			nPos2  := Recno()
			Go nPos
			aAdd(aStr,{StrZero((z+1),2,0),cPai,SG1->G1_COMP,SG1->G1_QUANT*Iif(z>0,aPai[z][3],1),SG1->G1_TRT,SG1->G1_LOCPRO})
			nQuant := SG1->G1_QUANT
			Go nPos2
			aAdd(aPai,{nPos,cPai,nQuant*Iif(Z>0,aPai[z][3],1)})
			Z      := Len(aPai)
			cPai   := SG1->G1_COD
		Else
			Go nPos
			aAdd(aStr,{StrZero((z+1),2,0),SG1->G1_COD,SG1->G1_COMP,SG1->G1_QUANT*Iif(z>0,aPai[z][3],1),SG1->G1_TRT,SG1->G1_LOCPRO})
			dbSkip()
		EndIf
	Else
		go nPos
		dbSkip()
	EndIf
	
	While cPai<>SG1->G1_COD .and. z>0
		Go aPai[Z][1]
		cPai   := aPai[Z][2]
		dbSkip()
		aTmp   := {}
		For w:=1 to (z-1)
			aadd(atmp,aPai[w])
		Next
		aPai   := {}
		For w:=1 to (z-1)
			aadd(aPai,aTmp[w])
		Next
		Z      := Len(aPai)
	EndDo
EndDo
Return(aStr)



//********************
//*       FIM        *
//********************

//**********************************************************************
//* VALIDAวีES DO APONTAMENTO DE PERDAS E PRE-REQUISIวAO               *   20/01/05 - Marcelo Iannuzzi
//**********************************************************************
/*

**************************
User Function m185grv()
**************************

//*****************************************
//apos a grava็ใo da pr้-requisi็ใo no SD3*
//*****************************************

Local _cArea:=GetArea()
If Empty(SD3->D3_OP) .or. SD3->D3_TM <> "600"
Return
EndIf

dbSelectArea("SD4")
dbSetOrder(1)
If dbSeek(xFilial("SD4")+SD3->D3_COD+PADR(SD3->D3_OPNSB,tamsx3("D4_OP")[1]))
RecLock("SD4",.F.)
SD4->D4_SLDEXT  +=SD3->D3_QUANT
Else
RecLock("SD4",.T.)
SD4->D4_FILIAL  := xFilial("SD4")
SD4->D4_COD     := SD3->D3_COD
SD4->D4_LOCAL   := "10"
SD4->D4_OP      := SD3->D3_OP
SD4->D4_DATA    := SD3->D3_EMISSAO
SD4->D4_TRT     := "1"
SD4->D4_SLDEXT  := SD3->D3_QUANT
EndIf
MsUnlock()


RestArea(_cArea)
                                    
Return*/                            


USER FUNCTION SBCIncl()   
Local _cArea  := GetArea()
Private xOP   := SBC->BC_OP
Private aProd := {}

iF funname()=="MATA685"
U_WFE02(xFilial("SBC")+SBC->BC_OP+SBC->BC_NUMSEQ  )   
ENDIF 

RestArea(_cArea)
Return



***************************
User Function MT685ATU()
***************************

//*******************************************
//*Inclusao dos apontamentos de perda do SBC*
//*******************************************

Local _cArea  := GetArea()

Local _nX     := 0
Local a_Preq  := {}
Local Doc :=""
Local nPos    := 0
aProd   := {}
xOP     := SBC->BC_OP
xNumSeq := SBC->BC_NUMSEQ
xSeqSD3 := SBC->BC_SEQSD3

_Chave := xFilial("SBC")+SBC->BC_OP+SBC->BC_NUMSEQ

//
//
//Acha o n๚mero do documento gerado no SBC atraves da chave
Doc:=Posicione("SD3",3,xFilial("SBC")+SBC->BC_PRODUTO+SBC->BC_LOCAL+SBC->BC_SEQSD3,"D3_DOC")
//D3_FILIAL, D3_COD, D3_LOCAL, D3_NUMSEQ, D3_CF, R_E_C_N_O_, D_E_L_E_T_
//
//Rotina que joga o movimento de perda para o custos  
If !(Alltrim(Upper(GETMV("MV_CTRLTRF"))) $ "ST")
	If !Empty(Doc)
		cQuery := " UPDATE   "//--SELECT D3_NUMSEQ,BC_SEQSD3,D3_OP,D3_CC,C2_CC,*
		cQuery += " "+RetSqlName("SD3")+" " //" SD3010  "
		cQuery += " SET  "
		cQuery += " D3_OP=BC_OP, "
		cQuery += " D3_CC=C2_CC "
		cQuery += " FROM "+RetSqlName("SBC")+", "+RetSqlName("SC2")+" "
		cQuery += " WHERE  "
		cQuery += " D3_TM='999'  "          //Tipo 999 saida da OP da estrutura
		cQuery += " AND BC_TIPO='S' "        //Scrap
		cQuery += " AND BC_OP=C2_NUM+C2_ITEM+C2_SEQUEN " //FILTRA A OP
		cQuery += " AND BC_PRODUTO<>C2_PRODUTO "
		cQuery += " AND D3_FILIAL=BC_FILIAL " // ---Filial
		cQuery += " AND D3_FILIAL=C2_FILIAL "
		cQuery += " AND C2_FILIAL='"+xFilial("SC2")+"' "
		cQuery += " AND "+RetSqlName("SBC")+".D_E_L_E_T_='' "
		cQuery += " AND "+RetSqlName("SD3")+".D_E_L_E_T_='' "
		cQuery += " AND "+RetSqlName("SC2")+".D_E_L_E_T_='' "
		cQuery += " AND D3_NUMSEQ=BC_SEQSD3 "
		cQuery += " AND D3_XAPLIC=BC_APLIC "
		cQuery += " AND D3_DOC='"+Doc+"' "
		TCSQLEXEC(cQuery)
	EndIf
Endif

dbSelectArea("SC2")
dbSetOrder(1)
dbSeek(xFilial("SC2")+ SubStr(SBC->BC_OP,1,tamsx3("C2_NUM")[1]+tamsx3("C2_ITEM")[1]+tamsx3("C2_SEQUEN")[1]))     

//_Chave := xFilial("SC2")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN


If Alltrim(SBC->BC_RECURSO)<>Alltrim(SC2->C2_RECURSO)
	
	If MsgYesNo("Recurso informado na perda ("+IIf(Alltrim(SBC->BC_RECURSO)=="","em branco",Alltrim(SBC->BC_RECURSO))+") diferente do recurso da OP ("+Alltrim(SC2->C2_RECURSO)+"). Deseja que o apontamento seja corrigido?")
		_nRecno := SBC->(RECNO())
		//
		dbSelectArea("SBC")
		dbSetOrder(1)
		dbSeek(xFilial("SBC")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
		While !Eof() .and. Alltrim(BC_OP) == Alltrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
			RecLock("SBC",.F.)
			SBC->BC_RECURSO := SC2->C2_RECURSO
			MsUnLock()
			dbSkip()
		EndDo
		//
		SBC->(dbgoto(_nRecno))
	EndIf
	
EndIf

//U_WFE02(_Chave)    // INCLUIDO DIA 14/07/06

//RestArea(_cArea)
//If xTipoDev == "D"
//	Return
//EndIf

//**********************************************
//*Gera Pre-Requisi็ao Apos Apotamento de Perda*
//**********************************************

For _nX:=1 to len(aCols)
	if aCols[_nX][04]<>"D"
		
		dbSelectArea("SD4")
		dbSetOrder(1)
		If dbSeek(xFilial("SD4")+aCols[_nX][01]+xOP)
			Reclock("SD4",.F.)
			SD4->D4_SLDEXT-=aCols[_nX][08]
			If SD4->D4_SLDEXT<0
				SD4->D4_SLDEXT:=0
			EndIf
			SD4->(MsUnLock())
		EndIf
		//	MSGSTOP("GERA REQUISICAO := "+aCols[_nX][13])
		If aCols[_nX][13]="S"
			nPos := Iif(Len(a_Preq)>0 , aScan(a_Preq,{|x| x[1]=aCols[_nX][1]}) , 0)
			If nPos ==0
				aAdd(a_Preq,{aCols[_nX][1],aCols[_nX][8],aCols[_nX][9]})
				//			MSGSTOP("ALIMENTANDO VETOR COM := "+aCols[_nX][1]+"-"+aCols[_nX][8]+"-"+aCols[_nX][9])
			Else
				a_Preq[nPos][2] += aCols[_nX][8]
				a_Preq[nPos][3] := aCols[_nX][9]
			EndIf
		EndIf
	Endif
Next
if len(a_Preq)>0
	
	dbSelectArea("SCP")
	dbSetOrder(1)
	dbGoBottom()
	//nReq := StrZero(Val(CP_NUM)+1,6)
	
	// cNumSCP:=GetSX8Num("SCP")
	cNumSCP:=GetSXENum("SCP")
	
	//Replace CP_NUM with cNumSCP
	ConfirmSX8()
	
	xDataRSol:=  GetRmtDate()
	xHoraRSol:=  GetRmtTime()
	
	MSGSTOP("Requisi็ใo Gerada... Nบ: "+Transform(cNumSCP,"@E 999999"))
	
	For _nX:=1 to len(a_Preq)
		dbSelectArea("SB1")
		dbSetorder(1)
		dbSeek(xFilial("SB1")+a_Preq[_nX][1])
		dbSelectArea("SCP")
		RecLock("SCP",.T.)
		CP_FILIAL  := "01"
		CP_NUM     := cNumSCP//nReq
		CP_ITEM    := StrZero(_nX,2)
		CP_PRODUTO := a_Preq[_nX][1]
		CP_DESCRI  := SB1->B1_DESC
		CP_UM      := SB1->B1_UM
		CP_QUANT   := a_Preq[_nX][2]
		CP_OP      := xOP
		CP_OBS     := "AUTO"
		CP_DATPRF  := a_Preq[_nX][3]
		CP_LOCAL   := "01"
		CP_CC      := SC2->C2_CC
		CP_EMISSAO := a_Preq[_nX][3]
		CP_SOLICIT := cUserName
		CP_DTRS    := xDataRSol
		CP_HORA    := Transform(xHoraRSol,"@R !!!!!" )
		MsUnLock()
	Next
	
Endif
RestArea(_cArea)
Return

**************************
User Function SBCEXCL()
**************************

//*******************************************
//*exclusao dos apontamentos de perda do SBC*
//*******************************************

Local _cArea:=GetArea()
Private aProd:={}
For w:=1 to Len(aCols)
	If aCols[w][1]=="S"
		If SBC->BC_TIPO<>"D"
			dbSelectArea("SD4")
			dbSetOrder(1)
			If dbSeek(xFilial("SD4")+SBC->BC_PRODUTO+PADR(SBC->BC_OP,tamsx3("D4_OP")[1]))
				Reclock("SD4",.F.)
				SD4->D4_SLDEXT+=aCols[w][9]
				SD4->(MsUnLock())
			EndIf
		Endif
		//***Monta o workflow para o aviso de Estorno da Perdas*****/
		dbSelectArea("SBC")
		cProd := Posicione("SB1",1,xFilial("SB1")+SBC->BC_PRODUTO,"B1_DESC")
		xObs  := Posicione("SZC",1,xFilial("SZC")+SBC->BC_MOTIVO ,"ZC_TIPODEF")
		xData := Subs(Dtos(BC_DATA),7,2) + "/" + Subs(Dtos(BC_DATA),5,2)+ "/" + Subs(Dtos(BC_DATA),3,2)
		xQuant:= Transform(BC_QUANT,"@E 99999.999999")
		xObs_ := IIF(Empty(BC_OBS),xObs,BC_OBS)
		
		AAdd(aProd,{BC_OP ,;        // [1]Nบ da OP
					BC_PRODUTO,;    // [2] Produto
					BC_TIPO,;       // [3] Tipo da movimenta็ใo
					BC_APLIC,;      // [4] Centro de Custo
					BC_MOTIVO,;     // [5] Motivo da perda
					xQuant,;        // [6] Quantidade
					BC_RECURSO,;    // [7] Recurso
					BC_LOTECTL,;    // [8] Lote
					BC_LOCORIG,;    // [9] Local de origem
					BC_LOCAL,;    	// [10]Local de destino
					xObs_,;    		// [11]Descri็ใo do motivo
					cProd,;    		// [12]Descri็ใo do produto
					cUserName})     // [13]Usuario
		
	Endif
	RestArea(_cArea)
Next
If Len(aProd)>0
	U_WFE28()
EndIf

Return
//
//*****************************************************************************************************************************/
//*****************************************************************************************************************************/
//*****************************************************************************************************************************/
//*****************************************************************************************************************************/
//********************
//*       FIM        *
//********************
//
***************************
User Function DatOpVal()
***************************

//***************************************************************************************
//*Valida็ao dos campos de OP e Data do SD3 para mes de apontamento igual ao da OP (SC2)*
//***************************************************************************************

Local lRet   := .T.
Local a_Area := GetArea()

If ! Alltrim(FunName()) $ "MATA250/MATA241/MATA105/MATA261/U_TMATA241/TMATA241"
	Return(lRet)
EndIf


If Alltrim(FunName()) == "MATA250"  // Apontamento de Produ็ใo
	
	If Empty(M->D3_OP)
		Return(lRet)
	EndIf
	
	dbSelectArea("SC2")
	dbSetOrder(1)
	dbSeek(xFilial("SC2")+M->D3_OP)
	If Month(SC2->C2_DATPRF)<>Month(M->D3_EMISSAO)
		MsgStop("M๊s do apontamento diferente do m๊s da ordem de produ็ใo. Altere a data.")
		lRet:=.F.
	ElseIf ddatabase - M->D3_EMISSAO > 1
		MsgStop("S๓ ้ Permitido alterar a Data de Movimenta็ใo do Estoque em apenas 1(um) dia.")
		lRet:=.F.
	ElseIf M->D3_EMISSAO > ddatabase
		MsgStop("Data de Movimenta็ใo Maior que a Data Base do Sistema. Informe uma data valida.")
		lRet:=.F.
	End
	
ElseIf Alltrim(FunName()) $ "MATA241/U_TMATA241/TMATA241"  // Transferencias Mod.2
	
	If ddatabase - DA241DATA > 1
		MsgStop("S๓ ้ Permitido alterar a Data de Movimenta็ใo do Estoque em apenas 1(um) dia.")
		lRet:=.F.
	ElseIf DA241DATA > ddatabase
		MsgStop("Data de Movimenta็ใo Maior que a Data Base do Sistema. Informe uma data valida.")
		lRet:=.F.
	End
	
ElseIf Alltrim(FunName()) == "MATA261"  //  Movimentos Internos Mod.2
	
	If ddatabase - DA261DATA > 1
		MsgStop("S๓ ้ Permitido alterar a Data de Movimenta็ใo do Estoque em apenas 1(um) dia.")
		lRet:=.F.
	ElseIf DA261DATA > ddatabase
		MsgStop("Data de Movimenta็ใo Maior que a Data Base do Sistema. Informe uma data valida.")
		lRet:=.F.
	End
	
ElseIf Alltrim(FunName()) == "MATA105"  // Solicita็๕es ao Armazens
	
	If ddatabase - DA105DATA > 1
		MsgStop("S๓ ้ Permitido alterar a Data de Movimenta็ใo do Estoque em apenas 1(um) dia.")
		lRet:=.F.
	ElseIf DA105DATA > ddatabase
		MsgStop("Data de Movimenta็ใo Maior que a Data Base do Sistema. Informe uma data valida.")
		lRet:=.F.
	End
	
End


RestArea(a_Area)

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT241TOK  บMod:   ณJefferson Moreira   บ Data ณ  03/03/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de Entrada que Limpa o Campo D3_OP e                  บฑฑ
ฑฑบ          ณGrava Essa OP no Campo D3_OPNSB                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*************************
User Function MT241TOK
*************************
Local i := 0
Local c_OP:=""
Local _cArea:=GetArea()
dbSelectArea("SB1")
dbSetOrder(1)
dbSelectArea("SD4")
dbSetOrder(1)
//**********************************************************************************
//*Ponto de Entrada para Limpar o Campo da OP dos movimentos Internos (Requisi็๕es)*
//*E agora alimentas o campo D4_SLDEXT para verificar o saldo de MP por OP         *
//**********************************************************************************
//

//
// ***************** IMPLEMENTAวรO P/ BLOQUEAR MOVIMENTO DE ITEM DESBALACEADO *****************
// EM: 30/10/2014 BY ALEX ALMEIDA
// ********************************************************************************************
//
For nX := 1 to Len(aCols)
	If !(aCols[nX][len(aHeader)+1])
			
		nPosProd    := ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_COD"     }) //
		nPosLocal   := ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_LOCAL"   }) //
		nPosLocaliz := ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_LOCALIZ" }) //
		nPosLotectl := ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_LOTECTL" }) //
		nPosNumlote := ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_NUMLOTE" }) //
		nPosOp      := ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_OP"      }) //
		nPosQuant   := ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_QUANT"   }) //
		nPosQBFifo  := ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_QBFIFO"  }) //
		nPosMotQBF  := ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_QBFIFOM" }) //
		nPosMotOBS  := ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_QBOBSER" }) //
		//
		cProduto  := aCols[nX,nPosProd]
		cLocalOri := aCols[nX,nPosLocal]
		cLocaliz  := aCols[nX,nPosLocaliz]
		cLotectl  := aCols[nX,nPosLotectl]
		cNumLote  := aCols[nX,nPosNumLote]
		cOP       := aCols[nX,nPosOp]
		nQuant    := aCols[nX,nPosQuant]
		cQbFifo   := aCols[nX,nPosQBFifo]
		cMotQbf   := aCols[nX,nPosMotQBF]
		cMotObs   := aCols[nX,nPosMotObs]
		//
		ContLote:=Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_RASTRO")
		//
		//MSGINFO(Upper(Alltrim(GETMV("MV_CHKB8BF"))))
		If ContLote <> 'N' .and. Upper(Alltrim(GETMV("MV_CHKB8BF"))) == "S"
			If u_CheckB8BF(cProduto, cLocalOri)
				//
				msgStop("Linha "+Alltrim(Str(nX))+" o saldo do item "+cProduto+"-"+cLocalOri+" Kardex x Lote x Endere็o encontra-se desbalanceado para que a movimenta็ใo seja realizada ้ necessแrio balancear o saldo do item!","MT241TOK - Bloqueio")
				//
				aCols[nX,nPosLotectl] := Space(tamsx3("D3_LOTECTL")[1])
				aCols[nX,nPosQBFifo]  := Space(tamsx3("D3_QBFIFO")[1]	)
				aCols[nX,nPosMotQBF]  := Space(tamsx3("D3_QBFIFOM")[1])
				aCols[nX,nPosMotOBS]  := Space(tamsx3("D3_QBOBSER")[1])
				aCols[nX][len(aHeader)+1] := .T.
				lRet := .F.
				//Return(lRet)
				//
			Endif
		Endif
	Endif
Next
//
// ***************** IMPLEMENTAวรO P/ BLOQUEAR MOVIMENTO DE ITEM DESBALACEADO *****************
// EM: 30/10/2014 BY ALEX ALMEIDA
// ********************************************************************************************
//
//
//VTALERT("MT241TOK")
//VTALERT(Alltrim(FunName()))
//
If Alltrim(FunName()) $ "MATA185/MATA241/U_TMATA241/TMATA241"
	For i := 1 to Len(aCols)
		c_OP := aCols[i][ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_OPNSB" })]      //aCols[i][ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_OP" })]    // aCols[i][1]
		aCols[i][ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_OP"	   })] := " "               //aCols[i][1] := " "  //Limpa Campo do D3_OP
		if Alltrim(FunName()) $ "MATA241/U_TMATA241/TMATA241"
			aCols[i][38] := c_OP  // Grava็ใo do Campo D3_OPNSB
			aCols[i][35]:= GetRmtDate()        // Grava็ใo da Data Real da Movimenta็ใo    (Jefferson Moreira Dt.: 03.03.07)
			aCols[i][36]:= Transform(GetRmtTime(),"@R !!!!!") // Grava็ใo da Hora da Movimenta็ใo (Jefferson Moreira Dt.: 03.03.07)
			aCols[i][37]:= "PL"
		Else
			//aCols[i][len(aCols[i])-3] := c_OP  // Grava็ใo do Campo D3_OPNSB
			aCols[i][ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_OPNSB"	   })] := c_OP
		Endif
		//If !Empty(c_OP) .and. cTM $ "600/620" //!Empty(aCols[i][len(aCols[i])-1]) .and. cTM $ "600/620"
		If !Empty(c_OP) .and. cTM $ "600/620" //!Empty(aCols[i][len(aCols[i])-1]) .and. cTM $ "600/620"
			dbSelectArea("SB1")
			dbSeek(xFilial("SB1")+ aCols[i][ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_COD"	 })] ) //aCols[i][2])
			If B1_SLDPL=="S"
				dbSelectArea("SD4")
				//If dbSeek(xFilial("SD4")+aCols[i][2] + c_OP ) //PADR(aCols[i][len(aCols[i])-1],tamsx3("D4_OP")[1]))
				If dbSeek(xFilial("SD4")+ aCols[i][ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_COD"	 })] + c_OP ) //PADR(aCols[i][len(aCols[i])-1],tamsx3("D4_OP")[1]))
					RecLock("SD4",.F.)
					SD4->D4_SLDEXT  += aCols[i][ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_QUANT"	 })] //aCols[i][4]
				Else
					RecLock("SD4",.T.)
					SD4->D4_FILIAL    := xFilial("SD4")
					SD4->D4_COD      := aCols[i][ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_COD"	 })] //aCols[i][2]
					SD4->D4_LOCAL  := "10"
					SD4->D4_OP        := c_OP //aCols[i][len(aCols[i])-1]
					SD4->D4_DATA    := dA241Data
					SD4->D4_TRT       := "1"
					SD4->D4_SLDEXT := aCols[i][ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_QUANT"	 })] //aCols[i][4]
				EndIf
				SD4->(MsUnlock())
			EndIf
		EndIf
	Next
	/*
	For j:=1 to Len(aCols)   6
	dbSelectArea("SD4")
	dbSeek(xFilial("SD4")+aCols[i][2] + c_OP )
	Next
	*/
	//
	// ******************** IMPLEMENTAวรO P/ OBRIGATORIEDADE DO FIFO ******************************
	// EM: 19/08/2013 BY ALEX ALMEIDA
	// ********************************************************************************************
	// GRAVAR A OCORRENCIA DO FIFO NA CONFIRMACAO DO MOVIMENTO INTERNO MOD.2
	//
	lQbFifo := .F.
	For i := 1 to Len(aCols)
		//
		If !(aCols[i][len(aHeader)+1])
			cProduto  := aCols[i,ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_COD"     })]
			cLocalOri := aCols[i,ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_LOCAL"   })]
			cLocaliz  := aCols[i,ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_LOCALIZ" })]
			cLotectl  := aCols[i,ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_LOTECTL" })]
			cNumLote  := aCols[i,ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_NUMLOTE" })]
			cOP       := aCols[i,ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_OP"      })]
			cOpNsb    := aCols[i,ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_OPNSB"   })]
			nQuant    := aCols[i,ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_QUANT"   })]
			cQbFifoM  := aCols[i,ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_QBFIFOM" })]
			cQbObser  := aCols[i,ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_QBOBSER" })]
			//
			If Empty(cOp) .and. !Empty(cOpNsb)
				cOp := cOpNsb
			Endif
			//
			If Empty(Alltrim(cOp))
				cOp:= ""
			EndIf
			If aCols[i][ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_QBFIFO" })]  == "S"
				Alert(cOp)
				U_LogQuebraFifo(cProduto, cLocalOri, cLocaliz, cLotectl, cNumLote, nQuant, cDocumento, "", "", cQbFifoM, "SD3", cOp, cQbObser)
				lQbFifo := .T.
			Endif
		Endif
		//
	Next
	//
	If lQbFifo
		msginfo("O Log quebra de FIFO foi atualizado!","Aten็ใo!")
	Endif
	//
	// ******************** IMPLEMENTAวรO P/ OBRIGATORIEDADE DO FIFO ******************************
	// EM: 19/08/2013 BY ALEX ALMEIDA
	// ********************************************************************************************
EndIf

RestArea(_cArea)
Return(.T.)

//
//
***********************
User Function MT241EST
***********************
Local cFilial := xFilial("SD3")
Local lExecuta := .F.

dbSelectArea("SD4")
dbSetOrder(1)
dbSelectArea("SD3")
dbSetOrder(2)
dbSeek(cFilial+cDocumento+aCols[1][2])
While !Eof() .and. cDocumento == D3_DOC
	If D3_ESTORNO == "S" .and. D3_TM $ "600/620"
		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+SD3->D3_COD)
		If B1_SLDPL=="S"
			dbSelectArea("SD4")
			If dbSeek(cFilial+SD3->D3_COD+SD3->D3_OPNSB)
				RecLock("SD4",.F.)
				SD4->D4_SLDEXT  -= SD3->D3_QUANT
				MsUnlock()
			EndIf
		EndIf
	EndIf
	dbSelectArea("SD3")
	dbSkip()
EndDo
//
//
// ******************** IMPLEMENTAวรO P/ OBRIGATORIEDADE DO FIFO ******************************
// EM: 19/08/2013 BY ALEX ALMEIDA
// ********************************************************************************************
// EXCLUIR AS OCORRENCIAS DE FIFO QUANDO FOR ESTORNADA A LEITURA DE ETIQUETAS.
//

lQuery 	 := .T.
aStruZZ3 := ZZ3->(dbStruct())
cQuery  :=  " SELECT * "
cQuery  +=  " FROM " + RETSQLNAME("ZZ3") + " "
cQuery  +=  " WHERE ZZ3_FILIAL = '"+ xFilial("ZZ3") +"' "
cQuery  +=  "   AND D_E_L_E_T_ <> '*' "
cQuery  +=  "   AND ZZ3_ETIQ   = '"+ cDocumento +"'"
cQuery  +=  "   AND ZZ3_ORIGEM = 'SD3' "
cQuery  +=  "   AND ZZ3_DTAUT  = '' "
cQuery  +=  "   AND ZZ3_HRAUT  = '' "
cQuery  +=  "   AND ZZ3_CODAUT = '' "
//cQuery  := ChangeQuery(cQuery)
//
If Select("ZZ3TMP") <> 0
	ZZ3TMP->(dbCloseArea())
Endif
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"ZZ3TMP",.T.,.T.)
For nX := 1 To Len(aStruZZ3)
	If ( aStruZZ3[nX][2] <> "C" ) .And. FieldPos(aStruZZ3[nX][1]) > 0
		TcSetField("ZZ3TMP",aStruZZ3[nX][1],aStruZZ3[nX][2],aStruZZ3[nX][3],aStruZZ3[nX][4])
	EndIf
Next nX
//
nRegs := 0
dbSelectArea("ZZ3TMP")
dbGoTop()
Do While !Eof()
	nRegs ++
	dbSkip()
Enddo
//
If nRegs > 0
	cQuery  :=  " UPDATE " + RETSQLNAME("ZZ3") + " "
	cQuery  +=  " SET D_E_L_E_T_ = '*' "      
//	cQuery  +=  " FROM " + RETSQLNAME("ZZ3") + " "	
	cQuery  +=  " WHERE ZZ3_FILIAL = '"+ xFilial("ZZ3") +"' "
	cQuery  +=  "   AND D_E_L_E_T_ <> '*' "
	cQuery  +=  "   AND ZZ3_ETIQ   = '"+ cDocumento +"'"
	cQuery  +=  "   AND ZZ3_ORIGEM = 'SD3' "
	cQuery  +=  "   AND ZZ3_DTAUT  = '' "
	cQuery  +=  "   AND ZZ3_HRAUT  = '' "
	cQuery  +=  "   AND ZZ3_CODAUT = '' "
	TcSqlExec(cQuery)
	//
	MSGINFO("Ocorrencias de quebra de FIFO foram excluidas!")
Endif
//
ZZ3TMP->(dbCloseArea())
//
//
// ******************** IMPLEMENTAวรO P/ OBRIGATORIEDADE DO FIFO ******************************
// EM: 19/08/2013 BY ALEX ALMEIDA
// ********************************************************************************************
//
//
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMAT241DO บAutor  ณJefferson Moreira   บ Data ณ  03/03/07    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo se o usuario pode ou nใo alterar o documento     บฑฑ
ฑฑบ          ณ no Interno Mod 2                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP811                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

***********************
User Function MTA241DO
***********************

Return .f.


***********************
User Function MT250TOK
***********************
Local _Area := GetArea()
Local lRet  := .T.
Local nSald := 0
dbSelectArea("SD4")
dbSetOrder(2)
dbSeek(xFilial("SD4")+M->D3_OP,.T.)

While !Eof() .and. D4_OP==M->D3_OP
	cProduto := D4_COD
	nQtdeori := 0
	nSldExt  := 0
	While !Eof() .and. D4_OP==M->D3_OP .and. cProduto == D4_COD
		nQtdeori += D4_QTDEORI
		nSldExt  += D4_SLDEXT
		dbSkip()
	EndDo
	dbSelectArea("SB1")
	dbSeek(xFilial("SB1")+cProduto)
	cDesc := B1_DESC
	dbSelectArea("SD4")
	If SB1->B1_SLDPL=="S"
		nSald := (nQTDEORI / SC2->C2_QUANT * M->D3_QUANT)
		If nSald > nSLDEXT
			//lRet := .F.  Retorno retirado devido a problemas no saldo
			lRet := .t.
			//			msgstop("Saldo Insuficiente: "+cProduto+' '+cDesc+Transform(nSald,"@E 999,999.999999"))  // Jorge Em: 24/11/2006
			Exit
		EndIf
	EndIf
EndDo
If !lRet
	MsgStop("Saldo Insuficiente para esta OP.")
EndIf

Return(lRet)

***********************
User Function SD3250E()      // PONTO DE ENTRADA DE ESTORNO DO MOVIMENTO SD3 - PRODUวAO
***********************
Local _cArea := GetArea()
Local _cDoc  := SD3->D3_DOC
Local _cOPNSB:= SD3->D3_OP

//MSGSTOP("ESTORNO DE PRODUวรO","TI")

dbSelectArea("SZ6")
If dbSeek(xFilial("SZ6")+_cDoc)
	While !Eof() .and. _cDoc == SZ6->Z6_DOC
		RecLock("SZ6")
		SZ6->Z6_ESTORNO := "S"
		MsUnLock()
		dbSkip()
	EndDo
EndIf
dbSelectArea("SZ7")
If dbSeek(xFilial("SZ7")+_cDoc)
	While !Eof() .and. _cDoc == SZ7->Z7_DOC
		RecLock("SZ7")
		SZ7->Z7_ESTORNO := "S"
		MsUnLock()
		dbSkip()
	EndDo
EndIf
//
dbSelectArea("SZ8")
dbSetOrder(1)
If dbSeek(xFilial("SZ8")+_cDoc)
	While !Eof() .and. _cDoc == SZ8->Z8_DOC
		RecLock("SZ8")
		SZ8->Z8_ESTORNO := "S"
		MsUnLock()
		dbSkip()
	EndDo
EndIf
/*Estornar os Saldos do SD5 e SB8*/

//
dbSelectArea("SD4")
dbSetOrder(2)
dbSeek(xFilial("SD4")+SD3->D3_OP,.T.)
While !Eof() .and. D4_OP==SD3->D3_OP
	dbSelectArea("SB1")
	dbSeek(xFilial("SB1")+SD4->D4_COD)
	dbSelectArea("SD4")
	If SB1->B1_SLDPL=="S"
		nSald := (D4_QTDEORI/SC2->C2_QUANT)*SD3->D3_QUANT
		RecLock("SD4",.F.)
		SD4->D4_SLDEXT  += nSald
		SD4->(MsUnlock())
	EndIf
	dbSkip()
EndDo
//Boli - 30/11/07
aArea   := GetArea()
vlMsgErro := ""

IF SC2->C2_XQTDAPO > 0
	dbSelectArea("SC2")
	Reclock("SC2", .F.)
	SC2->C2_XQTDAPO := SC2->C2_XQTDAPO - M->D3_QUANT
	
	MsUnlock()
Endif

RestArea(aArea)

//
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  | MTA105OK บAutor  ณJefferson Moreira   บ Data ณ  06/08/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Copiar o numero da op da SA para o campo CP_OPNSB          บฑฑ
ฑฑบ          ณ e apagar o campo CP_OP                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
User Function MTA105OK

Local lRet   := .T.
Local a_Area := GetArea()

For i := 1 to Len(aCols)
aCols[i][25]  := aCols[i][6]
//	aCols[i][6]   := " "   // Limpa Campo do CP_OP

Next

RestArea(a_Area)
Return(lRet)
*/

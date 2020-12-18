#include "rwmake.ch"
#include "topconn.ch"
#Include "Protheus.ch" 
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"  


/* Ponto de entrada para validar 
   as linha do acols do pedido de venda */


User Function M410LIOK
Local PrecTab:=0,PPrVenda:=0,PPrUnit:=0
Local lRet:=.T.
Local TesVenda:="504,510,511,512,513,514,594,520,522,597,691,613,700,711,712,714,611,551"
//
DbSelectArea("DA1")
DbSetOrder(1)
If DbSeek(xFilial("DA1")+C5_TABELA+aCols[n][2])
	PrecTab:=DA1->DA1_PRCVEN
EndIf
//
PPrVenda  := ASCAN(aHeader, {|x| Alltrim(x[2]) == "C6_PRCVEN" })//Preço Unitário
PPrUnit   := ASCAN(aHeader, {|x| Alltrim(x[2]) == "C6_PRUNIT" })//Preço de Lista
PValor    := ASCAN(aHeader, {|x| Alltrim(x[2]) == "C6_VALOR"  })//Valor
PQtdVenda := ASCAN(aHeader, {|x| Alltrim(x[2]) == "C6_QTDVEN" })//Valor
PTes      := ASCAN(aHeader, {|x| Alltrim(x[2]) == "C6_TES"    })//Valor
//      
/*/
If !(aCols[n][PTes] $ TesVenda)
	//Não precisa validar
	Return lRet	
Endif          
/*/
//
If PrecTab==0 .and. !Empty(C5_TABELA)
	Alert("Tabela informada não possui o produto."+chr(10)+chr(13)+" É obrigatório a inclusão do produto na tabela." )
	lRet:=.F.
	Return(lRet)
EndIf
//
If aCols[n][PPrVenda]<>PrecTab  .and. !Empty(C5_TABELA)
	Alert("Preço unitário foi alterado de "+Alltrim(Transform(aCols[n][PPrVenda],"@ 9.999,999"))+" para "+Alltrim(Transform(PrecTab,"@ 9.999,999")))
	aCols[n][PPrVenda]:=PrecTab //Correção do preco da tabela
	aCols[n][PPrUnit]:=PrecTab  //Preço da Lista
//	aCols[n][PValor]:=aCols[n][PPrVenda]*aCols[n][PQtdVenda]
EndIf
//
// TRATAMENTO PARA IMPEDIR MOV. DE ITENS COM SALDO DESBALANCEADO
// EM: 17/03/2015
//
nPosProd  := ASCAN(aHeader, {|x| Alltrim(x[2]) == "C6_PRODUTO" }) //
nPosLocal := ASCAN(aHeader, {|x| Alltrim(x[2]) == "C6_LOCAL"   }) //
_cCodOrig := aCols[n,nPosProd]
_cLocOrig := aCols[n,nPosLocal]
//	
ContLote  := Posicione("SB1",1,xFilial("SB1")+_cCodOrig,"B1_RASTRO")
If ContLote <> 'N' .and. Upper(Alltrim(GETMV("MV_CHKB8BF"))) == "S"
	If u_CheckB8BF(_cCodOrig, _cLocOrig)
		//
		msgStop("Linha "+Alltrim(Str(n))+" o saldo do item origem "+_cCodOrig+"-"+_cLocOrig+" Kardex x Lote x Endereço encontra-se desbalanceado para que a movimentação seja realizada é necessário balancear o saldo do item!","M410LIOK - Bloqueio")
		//
		aCols[n][len(aHeader)+1] := .T.
		lRet := .F.
		Return(lRet)
		//
	Endif
Endif
//
// TRATAMENTO PARA IMPEDIR MOV. DE ITENS COM SALDO DESBALANCEADO
// EM: 17/03/2015
//

//
// ******************** IMPLEMENTAÇÃO P/ OBRIGATORIEDADE DO FIFO ******************************
// EM: 19/08/2013 BY ALEX ALMEIDA
// ********************************************************************************************
//
cQuery := " SELECT * "
cQuery += " FROM "+RetSqlName("SCK")+" "
cQuery += " WHERE D_E_L_E_T_<>'*' AND CK_NUMPV = '"+M->C5_NUM+"' "
TCQUERY cQuery NEW ALIAS "SCKTMP"
SCKTMP->(dbgotop())
nItemSCK := 0
Do While SCKTMP->(!Eof())
	nItemSCK ++
	SCKTMP->(dbSkip())
Enddo
SCKTMP->(dbCloseArea())
//
If !(aCols[n][len(aHeader)+1]) .and. nItemSCK == 0
	//
	//msgstop("M410LIOK - "+M->C5_NUM)
	//
	nPosProd    := ASCAN(aHeader, {|x| Alltrim(x[2]) == "C6_PRODUTO" }) //
	nPosLocal   := ASCAN(aHeader, {|x| Alltrim(x[2]) == "C6_LOCAL"   }) //
	nPosLocaliz := ASCAN(aHeader, {|x| Alltrim(x[2]) == "C6_LOCALIZ" }) //
	nPosLotectl := ASCAN(aHeader, {|x| Alltrim(x[2]) == "C6_LOTECTL" }) //
	nPosNumlote := ASCAN(aHeader, {|x| Alltrim(x[2]) == "C6_NUMLOTE" }) //
	nPosQuant   := ASCAN(aHeader, {|x| Alltrim(x[2]) == "C6_QTDVEN"  }) //
	nPosQBFifo  := ASCAN(aHeader, {|x| Alltrim(x[2]) == "C6_QBFIFO"  }) //
	nPosMotQBF  := ASCAN(aHeader, {|x| Alltrim(x[2]) == "C6_QBFIFOM" }) //
	nPosMotOBS  := ASCAN(aHeader, {|x| Alltrim(x[2]) == "C6_QBOBSER" }) //	
	//
	cProduto  := aCols[n,nPosProd]
	cLocalOri := aCols[n,nPosLocal]
	cLocaliz  := aCols[n,nPosLocaliz]
	cLotectl  := aCols[n,nPosLotectl]
	cNumLote  := aCols[n,nPosNumLote]
	nQuant    := aCols[n,nPosQuant]
	cQbFifo   := aCols[n,nPosQBFifo]
	cMotQbf   := aCols[n,nPosMotQBF]
	cMotOBS   := aCols[n,nPosMotOBS]	
	//
	ContLote:=Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_RASTRO")
	//
	If ContLote <> 'N' .and. Alltrim(cLocaliz) <> Alltrim(GETMV("MV_ENDSEP"))
		//
		aSaldoFifo := {}
		PegaSaldoFifo()
		//
		If LoteLido()
			If !Empty(cMotQBF) .AND. !aCols[n][len(aHeader)+1]
				aCols[n,nPosQBFifo] := "S"
				aCols[n,nPosMotQBF] := cMotQBF
				aCols[n,nPosMotOBS] := cMotOBS				
			Endif
		Endif
		//
	Endif	
EndIF
//
// ******************** IMPLEMENTAÇÃO P/ OBRIGATORIEDADE DO FIFO ******************************
// EM: 19/08/2013 BY ALEX ALMEIDA
// ********************************************************************************************
//                              
Return lRet
//
//
// ******************** IMPLEMENTAÇÃO P/ OBRIGATORIEDADE DO FIFO ******************************
// EM: 19/08/2013 BY ALEX ALMEIDA
// ********************************************************************************************
//                              
Static Function LoteLido()
Local lRet := .F.
Local _nL 

aLoteLido  := {}
nLoteAtual := 0
For _nL := 1 to Len(aCols)
	If !(aCols[_nL][len(aHeader)+1])
		If (nPos:=Ascan( aLoteLido, { |x| x[1] == aCols[_nL,nPosLotectl] })) == 0
			aadd(aLoteLido, {aCols[_nL,nPosLotectl], aCols[_nL,nPosQuant]} )
		Else
			aLoteLido[nPos,2] += aCols[_nL,nPosQuant]
		Endif                         
	Endif
Next
//
//Verifica o quant. lida do lote x saldo disponivel
For _nL := 1 to Len(aSaldoFifo)
	If (nPos := Ascan( aLoteLido, { |x| x[1] == aSaldoFifo[_nL,1] })) > 0
		aSaldoFifo[_nL,3] := aLoteLido[nPos,2]
	Endif
Next
//
lQbFifo := .F.
_nL := 1
Do While _nL <= Len(aSaldoFifo)
	If (aSaldoFifo[_nL,2]-aSaldoFifo[_nL,3] > 0 .OR. aSaldoFifo[_nL,2]==aSaldoFifo[_nL,3]) .and. Alltrim(aCols[n,nPosLotectl]) == Alltrim(aSaldoFifo[_nL,1])
		EXIT                                                                                                        

	ElseIf (aSaldoFifo[_nL,2] - aSaldoFifo[_nL,3]) > 0                                	

		If aCols[n,nPosLotectl] <> aSaldoFifo[_nL,1] .and. GetMv("MV_AFIFO") .and.	aCols[n,nPosQBFifo]<>"S" // .OR. Empty(aCols[n,nPosMotQBF]))
			
			cMensagem := 'Lote FIFO: '+aSaldoFifo[_nL,1]+' possui saldo de '+Alltrim(Str(aSaldoFifo[_nL,2] - aSaldoFifo[_nL,3]))+' '
			cMensagem += "("+POSICIONE("SB1",1,xFilial("SB1")+cProduto,"B1_UM")+"). "
			cMensagem += "Deseja quebrar a sequencia de FIFO ? "
			
			lQbFifo :=  msgyesno(cMensagem, "Atenção")
			
			If !lQbFifo
				aCols[n,nPosLotectl] := Space(tamsx3("D3_LOTECTL")[1])
				aCols[n,nPosQBFifo]  := Space(tamsx3("D3_QBFIFO")[1]	)
				aCols[n,nPosMotQBF]  := Space(tamsx3("D3_QBFIFOM")[1])
				aCols[n,nPosMotOBS]  := Space(tamsx3("D3_QBOBSER")[1])				
				aCols[n][len(aHeader)+1] := .T.
				Return(lQbFifo)
			Else
				MotQbFifo()
				If Empty(cMotQBF)
					aCols[n,nPosLotectl] := Space(tamsx3("D3_LOTECTL")[1])
					aCols[n,nPosQBFifo]  := Space(tamsx3("D3_QBFIFO")[1] )
					aCols[n,nPosMotQBF ] := Space(tamsx3("D3_QBFIFOM")[1])
					aCols[n,nPosMotOBS ] := Space(tamsx3("D3_QBOBSER")[1])					
					aCols[n][len(aHeader)+1] := .T.
				Endif
				Exit
			Endif
		Endif
		
	Endif
	_nL ++
Enddo
Return(lQbFifo)
//
//
//
// ******************** IMPLEMENTAÇÃO P/ OBRIGATORIEDADE DO FIFO ******************************
// EM: 19/08/2013 BY ALEX ALMEIDA
// ********************************************************************************************
//
Static Function PegaSaldoFifo()
//
If Select("SBFTMP") <> 0
	SBFTMP->(dbCloseArea())
Endif
//
If POSICIONE("SB1",1,xFilial("SB1")+ cProduto,"B1_TIPO") $ "PA"
	cQuery := " SELECT C2_EMISSAO AS DT_ENT, BF_PRODUTO, BF_LOTECTL, SUM(BF_QUANT) AS BF_SALDO, SUM(BF_EMPENHO) AS BF_EMPENHO "
	cQuery += " FROM "+ RETSQLNAME("SBF")+" A INNER JOIN "+ RETSQLNAME("SC2")+" B ON (BF_LOTECTL=C2_NUM+C2_ITEM+RIGHT(C2_SEQUEN,2)) "
	cQuery += " WHERE A.D_E_L_E_T_ <>'*' AND  B.D_E_L_E_T_ <>'*'"
	cQuery += " AND BF_FILIAL ='"+xFilial("SBF")+"'"
	cQuery += " AND C2_FILIAL ='"+xFilial("SC2")+"'"
	cQuery += " AND BF_PRODUTO='"+cProduto+"'"
	cQuery += " AND C2_PRODUTO='"+cProduto+"'"
	cQuery += " AND BF_LOCAL='"+cLocalOri+"'"
	cQuery += " AND BF_QUANT > 0 "
	cQuery += " AND BF_LOCALIZ <> '"+Alltrim(GETMV("MV_ENDSEP"))+"' "
	cQuery += " GROUP BY C2_EMISSAO, BF_PRODUTO, BF_LOTECTL "
	cQuery += " ORDER BY C2_EMISSAO, BF_PRODUTO, BF_LOTECTL "
Else

Endif
cQuery := ChangeQuery(cQuery)
TCQUERY cQuery Alias SBFTMP New
//
aSaldoFifo := {}
dbSelectArea("SBFTMP")
dbgotop()
Do While SBFTMP->(!Eof())
	If SBFTMP->BF_EMPENHO > 0
		msginfo('FF 1. O Lote: '+ SBFTMP->BF_LOTECTL + ' possui empenho de '+Alltrim(Str(SBFTMP->BF_EMPENHO))+', isso compromete o saldo do Lote!', 'AVISO')//, .T., 4000)
	Endif
	//
	If (nPos:=ascan( aSaldoFifo, { |x| x[1] == SBFTMP->BF_LOTECTL })) == 0
		aadd(aSaldoFifo, { SBFTMP->BF_LOTECTL, SBFTMP->BF_SALDO - SBFTMP->BF_EMPENHO, 0, SBFTMP->DT_ENT } )
	Else
		aSaldoFifo[nPos,2] += SBFTMP->BF_SALDO - SBFTMP->BF_EMPENHO
	Endif
	SBFTMP->(dbSkip())
Enddo
SBFTMP->(dbClosearea())
//
Return
//
//
//				
//
// ******************** IMPLEMENTAÇÃO P/ OBRIGATORIEDADE DO FIFO ******************************
// EM: 19/08/2013 BY ALEX ALMEIDA
// ********************************************************************************************
//                              
Static Function MotQBFifo()
Local cMotivo  := Space(06)
Local lSair    := .F.
Local lRet     := .F.
Local cCont    := Space(01)
//
Private oDlgAut
Private cNomeUsu := cUserName
Private oNomeUsu := Nil
Private cMotDesc := Space(30)
Private oMotDesc := Nil
Private cObservacao := Space(120)
Private oObservacao := Nil
//
DEFINE MSDIALOG oDlgAut FROM 05,10 TO 250,600 TITLE Alltrim(OemToAnsi('Quebra de FIFO')) Pixel //430,531 
//
@ 20,015 say   'Motivo:' SIZE 020,10 PIXEL OF oDlgAut
@ 20,045 MSget cMotivo   picture '@!' valid  naovazio(cMotivo) .and. Eval({||ExistCpo("ZZ2",cMotivo),;
                                                                     cMotDesc:=POSICIONE("ZZ2",1,xFilial("ZZ2")+cMotivo,"ZZ2_DESCRI"),;
                                                                     oMotDesc:Refresh()})  F3 'ZZ2'  SIZE 020,10  PIXEL of oDlgAut
@ 20,090 say   oMotDesc  Var cMotDesc SIZE 160,10 PIXEL OF oDlgAut COLOR CLR_BLUE
//
@ 40,015 say   'Observ.:'               SIZE 020,10 PIXEL OF oDlgAut
@ 40,045 MSget cObservacao picture '@!' valid  naovazio(cObservacao) .and. Alltrim(cObservacao) != "."  SIZE 250,10  PIXEL of oDlgAut
//
@ 70,100 BUTTON "Confirmar" SIZE 40,15 ACTION MsAguarde({|| cMotQBF:=cMotivo, cMotOBS:=cObservacao, Close(oDlgAut)},'Processando...') PIXEL OF oDlgAut
@ 70,150 BUTTON "Sair"      SIZE 40,15 ACTION MsAguarde({|| Close(oDlgAut)},'Processando...') PIXEL OF oDlgAut
ACTIVATE MSDIALOG oDlgAut CENTERED
//
Return
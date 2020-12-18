#include "rwmake.ch"
#Include "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPETIQS  บAutor  ณJefferson Moreira   บ Data ณ  05/12/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Esse programa tem o objetivo de imprimir as etiquetas com  บฑฑ
ฑฑบ          ณ o codigo de barra dos itens de NF saida conforme parametrosบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SigaFat                                                    บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAlteracoesณ * Jorge Em: 26/05/2009                                     ณฑฑ
ฑฑณ          ณ Solicitacao Honda - O Layout foi ajustado conforme solici- ณฑฑ
ฑฑณ          ณ cao do Cliente.                                            ณฑฑ
ฑฑณ          ณ 01 - O Numero da N.Fiscal aumentou para 9 digitos.         ณฑฑ
ฑฑณ          ณ 02 - Foi Incluido o Local da Entrega.                      ณฑฑ
ฑฑณ          ณ Na Query, foi incluido o Campo C6_Entrega e foi incluido o ณฑฑ
ฑฑณ          ณ campo Serie da Nota Fiscal no Filtro.                      ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function IMPV2ETIQS()

Private oDlg := Nil
Private IdEtiq:=""
Pergunte("IMPETIQS ",.F.)

//Da Nota Fiscal ?    mv_par01
//Ate a Nota Fiscal ? mv_par02
//Da Serie ?          mv_par03
//Tipo Opera็ใo ?     mv_par04

@ 96,42 TO 323,505 DIALOG oDlg TITLE "Etiquetas de Saida"
@ 8,10 TO 84,222
//@ 94,133 BMPBUTTON TYPE 5 ACTION Pergunte("NFSIGW")
@ 94,133 BMPBUTTON TYPE 5 ACTION Pergunte("IMPETIQS")
@ 94,163 BMPBUTTON TYPE 1 ACTION ImpEtqSaida()
@ 94,193 BMPBUTTON TYPE 2 ACTION Close(oDlg)
@ 23,14 SAY "Esse programa tem o objetivo de imprimir as etiquetas com"
@ 33,14 SAY "o codigo de barra dos itens de NF saida conforme parametros"
@ 43,14 SAY "especificado pelo usuแrio."
@ 53,14 SAY ""
ACTIVATE DIALOG oDlg

Return nil

Static Function ImpEtqSaida()

cQuery := " Select "
cQuery += " C6_NUM,C6_PEDCLI,C6_LOTECTL,C6_TPEDIDO,C6_LINHA,F2_DOC,F2_SERIE,A7_PRODUTO,A7_CODCLI,A7_DESCCLI,C6_UM,A1_NREDUZ,C6_ENTREG,C6_HORA,C6_SETOR,SUM(C6_QTDVEN)AS C6_QTDVEN,C6_CLI,C6_LOJA,C6_ENTREGA,A7_CODASTE,F2_TES "
cQuery += " From SF2010 "
cQuery += " INNER JOIN SC6010 ON F2_DOC = C6_NOTA    AND F2_SERIE = C6_SERIE"
cQuery += " INNER JOIN SA1010 ON C6_CLI = A1_COD     AND C6_LOJA  = A1_LOJA"
cQuery += " INNER JOIN SA7010 ON C6_CLI = A7_CLIENTE AND C6_LOJA  = A7_LOJA  AND C6_PRODUTO = A7_PRODUTO"

cQuery += " WHERE "
cQuery += " SF2010. D_E_L_E_T_ <> '*'  AND "
cQuery += " SC6010. D_E_L_E_T_ <> '*'  AND "
cQuery += " SA1010. D_E_L_E_T_ <> '*'  AND "
cQuery += " SA7010. D_E_L_E_T_ <> '*'  AND "
cQuery += " F2_DOC >='" + mv_par01 +"' AND "
cQuery += " F2_DOC <='" + mv_par02 +"' AND "
cQuery += " F2_SERIE ='" + mv_par03 +"'

cQuery += " GROUP BY "
cQuery += " C6_NUM,C6_PEDCLI,C6_LOTECTL,C6_TPEDIDO,C6_LINHA,F2_DOC,F2_SERIE,A7_PRODUTO,A7_CODCLI,A7_DESCCLI,C6_UM,A1_NREDUZ,C6_ENTREG,C6_HORA,C6_SETOR,C6_CLI,C6_LOJA, C6_ENTREGA,A7_CODASTE,F2_TES "

cQuery += " Order By "
cQuery += " F2_DOC ASC "


cQuery := ChangeQuery(cQuery)

TCQUERY cQuery Alias TAA New


dbSelectArea("TAA")
dbGoTop()

While !EOF()
	
	_CodCli:=  Alltrim(C6_CLI)
	/*Caso a op็ใo for re-impressao da Yamaha*/
	if _CodCli="028" .and. mv_par05=3
		if TAA->C6_LOTECTL<>mv_par05
			DbSelectArea("TAA")
			DbSkip()
			Loop
		Endif             
	EndIf
	//cQuery += " C6_NUM,C6_PEDCLI,C6_LOTECTL,C6_TPEDIDO,C6_LINHA,F2_DOC,F2_SERIE,A7_PRODUTO,
	//A7_CODCLI,A7_DESCCLI,C6_UM,A1_NREDUZ,C6_ENTREG,C6_HORA,C6_SETOR,SUM(C6_QTDVEN)AS C6_QTDVEN,C6_CLI,
	//C6_LOJA,C6_ENTREGA,A7_CODASTE,F2_TES "
    //
	// incluido por alex em 26/06/2013
	If Empty(C6_LOTECTL)
	   msgStop("O Produto: "+A7_PRODUTO+" nao possui lote informado no pedido de vendas. Para imprimir a etiqueta deve ser informado o LOTE!","Aten็ใo")
	   Exit
	Endif
	/************************************************/
	_CodCli:=  Alltrim(C6_CLI)
	_NumPed := Iif(_CodCli="002",Subs(C6_PEDCLI,1,8),C6_NUM)
	_TpPed  := Subs(C6_TPEDIDO,1,2)
	// _ItemNf:=D2_ITEM
	_Lote:=C6_LOTECTL
	_LinPed := Subs(C6_LINHA,1,6)
	// _NumNF  := StrZero(Val(F2_DOC),9)
	_NumNF  := Subs(F2_DOC,1,9)
	_SerNF  := Subs(F2_SERIE,1,3) //Subs(F2_SERIE,1,1)+Subs(F2_SERIE,3,1) 06.03.07
	_Serie  := Subs(F2_SERIE,1,3)
	_CodPro := Subs(A7_CODCLI,1,20) + Space(5)
	_DesPro := Subs(A7_DESCCLI,1,25)
	_zQuant := C6_QTDVEN
	_jQuant := C6_QTDVEN
	_Um     := Subs(C6_UM,1,2)
	_Emp    := Subs(A1_NREDUZ,1,4)
	_DtEnt  := Subs(C6_ENTREG,7,2) + "/" + Subs(C6_ENTREG,5,2)+ "/" + Subs(C6_ENTREG,3,2)
	_HrEnt  := Subs(C6_HORA,1,2)+":"+Subs(C6_HORA,3,4)
	_Setor  := C6_SETOR
	_LocEntrega := C6_ENTREGA
	_CodNS  := A7_PRODUTO
	_Lotes  := Array(1,20)
	_xLotes := 1
	_Clien  := C6_CLI
	_Loja   := C6_LOJA
	
	For x:=1 to 20
		_Lotes[1][x] := ""
	Next
	
	dbSelectArea("SD2")
	dbSetOrder(3)
	
	dbSeek(xFilial("SD2") + _NumNF + _Serie + _Clien + _Loja + _CodNS)
	/*Informa็ใo para Honda***/
	WHILE D2_COD == _CodNS
		if _CodCli="002" .and. _xLotes<11
			_Lotes[1][_xLotes] := D2_LOTECTL
			_xLotes++
		Else
			If Empty(SD2->D2_IDEETIQ)
				CodEtiq:=Getmv("MV_IDEETIQ")
				RecLock("SD2",.F.)
				SD2->D2_IDEETIQ:=Strzero(CodEtiq,6)
				MsUnLock()
				CodEtiq:=CodEtiq+1
				Putmv("MV_IDEETIQ",CodEtiq)
			EndIF
			
			
		Endif
		/*************************************************************************************/
		DbSelectArea("SD2")
		dbSkip()
	Enddo
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1") + _CodNS)
	
	If _CodCli="002" //Entrega da Honda ้ por carrinho
		_xQuant := B1_QE * 24
	Else
		_xQuant := B1_QE //Yamaha ้ por embalagem
	EndIf
	
	
	_xVol := Int(_zQuant /_xQuant)
	
	If _xVol <> _zQuant /_xQuant
		_xVol += 1
	Endif
	///Se Cliente for Yamanha pega o sequencial gerado para no campo D2_ITE
	If _CodCli="028"
		DbSelectArea("SD2")
		chave:=xFilial("SD2")+ _NumNF + _Serie + _Clien + _Loja + _CodNS
		if DbSeek(xFilial("SD2")+_NumNF + _Serie + _Clien + _Loja + _CodNS)
			While Chave==xFilial("SD2")+D2_DOC + D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD
				If _Lote==D2_LOTECTL
					IdEtiq:=SD2->D2_IDEETIQ
				EndIf
				DbSelectArea("SD2")
				DbSkip()
			EndDo
		EndIf
	EndIF
	
	dbSelectArea("TAA")
	For _Ent:= 1 to _xVol
		
		If _Ent <> _xVol
			_Quant1 := Transform (_xQuant ,"@E 999999999.999")
			
		Elseif _xVol == 1
			_Quant1 := Transform (_zQuant ,"@E 999999999.999")
			
		Else
			If _CodCli='002'
				_Quant1 := Transform (_jQuant ,"@E 999999999.999")
			EndIf
			
		Endif
		
		if _Ent=_xVol  .and. _CodCli='028'  //Condi็ใ3681o para a Yamaha
			if (_zQuant/Val(_Quant1))-Int(_zQuant/Val(_Quant1))>0
				_Quant1:=(_zQuant/Val(_Quant1)-Int(_zQuant/Val(_Quant1)))*val(_Quant1)
				_Quant1:=  Transform (_Quant1 ,"@E 999999999.999")
			Else
				_Quant1 := Transform (_jQuant ,"@E 999999999.999")
			EndIf
			
		EndIf
		_jQuant -= _xQuant
		_Quant  := RetNum_(Val(_Quant1),12,3)
		/*cb5setimp(cLocImp, .T.)*/
		
		If _CodCli="002" //Layout da Honda
			//Alert("Pedido:" +_NumPed +",  Quantidade:" +_Quant1)
			EtiqHonda()
			MSCBCLOSEPRINTER()
		Elseif _CodCli='028'
			if !Empty(IdEtiq)
				cLocImp:=mv_par07
				cb5setimp(cLocImp, .T.)
				//	   		MSCBCHKStatus(.F.)
				EtiqYamaha()
				MSCBCLOSEPRINTER()
			Else
				Alert('Identifica็ใo de Etiqueta nใo encontrado. Verifique o LOTE!')
			EndIF
		Endif
		
	Next
	//Impressใo diferenciada para Yamaha
	TAA->(dbSkip())
EndDo


If !(Type('ArqNtx') == 'U')
	fErase(cArqNtx)
Endif


dbClearFil(NIL)
DbSelectArea("TAA")
dbCloseArea()

Return
/*************************************************************************************/
Static Function EtiqHonda()
MSCBPRINTER("Z4M","LPT1",,,)
MSCBCHKStatus(.F.)
MSCBBEGIN(1,6)
MSCBWrite("^XA~TA000~JSN^LT0^MMT^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,4^MD0^JUS^LRN^CI0^XZ^XA^LL1807^PW933")
MSCBWrite("^FT68,1094^A0B,17,19^FH\^FDNRO. PEDIDO^FS")
MSCBWrite("^FT66,344^A0B,17,21^FH\^FDNOTA FISCAL^FS")
MSCBWrite("^FT76,1757^A0B,17,21^FH\^FDFORNECEDOR^FS")
MSCBWrite("^FT139,1752^A0B,58,57^FH\^FDNIPPON SEIKI^FS")
//MSCBWrite("^FT132,347^A0B,58,57^FH\^FD"+StrZero(Val(_NumNF),9)+"-"+_SerNF+"^FS")
MSCBWrite("^FT132,414^A0B,58,57^FH\^FD"+StrZero(Val(_NumNF),9)+"-"+Left(_SerNF,2)+"^FS")
MSCBWrite("^FO648,28^GB0,1755,3^FS")
MSCBWrite("^FO909,25^GB0,1767,6^FS")
MSCBWrite("^FO781,33^GB0,1755,5^FS")
MSCBWrite("^FO308,27^GB0,1755,5^FS")
MSCBWrite("^FO46,26^GB0,1771,5^FS")
MSCBWrite("^FT385,1704^A0B,58,57^FH\^FD"+ _CodPro+"^FS")
MSCBWrite("^BY3,3,138^FT286,1298^BCB,,N,N")
MSCBWrite("^FD>:"+ _NumPed+_TpPed+_LinPed+StrZero(Val(_NumNF),9)+Left(_SerNF,2)+ "^FS")
MSCBWrite("^BY3,3,133^FT532,1615^BCB,,N,N")
MSCBWrite("^FD>:"+  _CodPro+_Quant+_Um  + "^FS")
MSCBWrite("^FT334,1761^A0B,17,16^FH\^FDITEM^FS")
MSCBWrite("^FT571,1768^A0B,17,16^FH\^FDDESCRI\80\C7O DO ITEM^FS")
MSCBWrite("^FT628,1764^A0B,50,50^FH\^FD"+ _DesPro +"^FS")
MSCBWrite("^FT564,886^A0B,17,16^FH\^FDQUANTIDADE^FS")
MSCBWrite("^FT631,888^A0B,58,57^FH\^FD"+ _Quant1 +"^FS")
MSCBWrite("^FT567,340^A0B,17,16^FH\^FDUN^FS")
MSCBWrite("^FT627,308^A0B,58,57^FH\^FD"+ _Um +"^FS")
MSCBWrite("^FT750,1698^A0B,58,57^FH\^FD"+ _Emp  + "^FS")
MSCBWrite("^FT678,1761^A0B,17,16^FH\^FDEMPRESA^FS")
MSCBWrite("^FT755,1415^A0B,58,57^FH\^FD"+ _DtEnt +"^FS")
MSCBWrite("^FT681,1444^A0B,17,16^FH\^FDDATA DE ENTREGA^FS")
MSCBWrite("^FT681,1052^A0B,17,21^FH\^FDHORA DE ENTREGA^FS")
MSCBWrite("^FT755,995^A0B,58,57^FH\^FD"+ _HrEnt +"^FS")
MSCBWrite("^FT752,587^A0B,58,57^FH\^FD"+ _Setor +"^FS")
MSCBWrite("^FT683,614^A0B,17,24^FH\^FDSETOR^FS")
MSCBWrite("^FT882,1761^A0B,58,57^FH\^FD"+ Strzero(_Ent,3) + "/"+ Strzero(_xVol,3) +"^FS")
MSCBWrite("^FT813,1771^A0B,17,19^FH\^FDQTD/VOL^FS")
MSCBWrite("^FT818,1440^A0B,17,16^FH\^FDOUTROS^FS")
MSCBWrite("^FO780,694^GB133,0,3^FS")
MSCBWrite("^FO655,695^GB133,0,3^FS")
MSCBWrite("^FO652,1070^GB132,0,2^FS")
MSCBWrite("^FO658,1463^GB249,0,3^FS")
MSCBWrite("^FT139,1102^A0B,58,57^FH\^FD" +_NumPed+"-"+_TpPed+"-"+_LinPed+ "^FS")
MSCBWrite("^FO47,23^GB863,0,5^FS")
MSCBWrite("^FO46,1792^GB868,0,4^FS")
//   MSCBWrite("^FT843,1380^A0B,42,40^FH\^FD Lote(s): ^FS")
MSCBWrite("^FT843,1229^A0B,42,40^FH\^FD"+ _Lotes[1][1] + "^FS")
MSCBWrite("^FT842,998^A0B,42,40^FH\^FD" + _Lotes[1][2] + "^FS")
MSCBWrite("^FT842,761^A0B,42,40^FH\^FD" + _Lotes[1][3] + "^FS")
MSCBWrite("^FT840,528^A0B,42,40^FH\^FD" + _Lotes[1][4] + "^FS")
MSCBWrite("^FT842,293^A0B,42,40^FH\^FD" + _Lotes[1][5] + "^FS")
MSCBWrite("^FT894,1228^A0B,42,40^FH\^FD"+ _Lotes[1][6] + "^FS")
MSCBWrite("^FT887,588^A0B,58,57^FH\^FD" +_LocEntrega+"^FS")
MSCBWrite("^FT818,617^A0B,17,16^FH\^FDLOCAL DE ENTREGA^FS")
MSCBWrite("^PQ1,0,1,Y^XZ")
MSCBEND()
MSCBCLOSEPRINTER()

Return
/*************************************************************************************/
/*******************************************************************************************/
Static Function EtiqYamaha()
//If SD2->D2_TES='520'
//	_CodPro := Subs(A7_CODASTE,1,20) + Space(5)
//EndIf
//
If F2_TES='520'
	_CodProA := Subs(A7_CODASTE,1,20) + Space(5)
Else
	_CodProA := Subs(A7_CODCLI,1,20) + Space(5)
EndIf
//
VarCod:=StrTran(SubStr(_CodProA,1,18),"-","")
//Lote:=Substr(TYA->CB0_OP,1,4)+Substr(TYA->CB0_OP,7,2)
Lote:=_Lote
VARNF:=StrZero(Val(_NumNF),9)+'-'+Left(_SerNF,2)
VARSUP:="5249"
VARUSER:="9219"
VARLPN:=VarSup+IdEtiq+StrZero(_Ent,5)
VarCod:=StrTran(SubStr(_CodProA,1,18),"-","")
CodBar2:=Alltrim(VarCod)+"-"+VarSup+"-"+Varuser
VARQTD:=aLLTRIM(Transform(_Quant1 ,"@E 999999999"))
VAREXC:="Lote Orig:"+Lote
VARNOM:=aLLTRIM(_DesPro)
codbar3:=VARQTD
//
//Comandos para impressao da etiqueta
//	MSCBPRINTER("Z4M","LPT1",,,)
//	MSCBCHKStatus(.F.)
//	MSCBBEGIN(1,6)
MSCBBEGIN(1,5)
MSCBWrite("~DG000.GRF,89856,104,")
MSCBWrite(",:::::::::::::::::::::H07FpGF8,03FpIF800FpJFE01FpKF03FpKF8:3FC0pG03F87F0pH01FC7E0pI0FCFE0pI0FCFC0pI0FC::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::7C0pI0FC7E0pI0FC3E0pI0F83FpKF8::1FpKF00FpJFE003FpIF80^XA")
MSCBWrite("^PW874")
MSCBWrite("^FT32,864^XG000.GRF,1,1^FS")
MSCBWrite("^FO35,733^GB825,0,5^FS")
MSCBWrite("^FO33,617^GB823,0,5^FS")
MSCBWrite("^FO34,515^GB825,0,5^FS")
MSCBWrite("^FO41,374^GB817,0,5^FS")
MSCBWrite("^FO39,269^GB818,0,7^FS")
MSCBWrite("^FO32,153^GB823,0,5^FS")
MSCBWrite("^FO277,620^GB0,114,5^FS")
MSCBWrite("^FO350,269^GB0,105,5^FS")
MSCBWrite("^FO532,514^GB0,223,4^FS")
MSCBWrite("^FO606,270^GB0,106,5^FS")
MSCBWrite("^FT631,314^A0N,29,28^FH\^FDUSER:^FS")
MSCBWrite("^FT362,306^A0N,29,28^FH\^FDSUPLIER:^FS")
MSCBWrite("^FT630,365^A0N,42,40^FH\^FD"+VARUSER+"^FS")
MSCBWrite("^FT362,362^A0N,42,40^FH\^FD"+VARSUP+"^FS")
MSCBWrite("^FT68,365^A0N,42,40^FH\^FD"+VARCOD+"^FS")
MSCBWrite("^FT109,267^A0N,29,38^FH\^FD"+VARLPN+"^FS")
MSCBWrite("^FT81,857^A0N,29,28^FH\^FD"+VARQTD+"^FS")
MSCBWrite("^FT60,138^A0N,42,40^FH\^FD"+VARLPN+"^FS")
MSCBWrite("^FT536,610^A0N,42,40^FH\^FDNIPPON SEIKI ^FS")
MSCBWrite("^FT540,550^A0N,29,28^FH\^FDFORNECEDOR:^FS")
MSCBWrite("^FT540,700^A0N,33,33^FH\^FD"+VAREXC+"^FS")
MSCBWrite("^FT296,706^A0N,33,33^FH\^FD"+VARNF+"^FS")
MSCBWrite("^FT40,699^A0N,33,33^FH\^FD"+VARQTD+"^FS")
MSCBWrite("^FT42,658^A0N,29,28^FH\^FDQTDE:^FS")
MSCBWrite("^FT538,645^A0N,21,19^FH\^FDUSO EXCLUSIVO DO FORNECEDOR:^FS")
MSCBWrite("^FT299,655^A0N,29,28^FH\^FDNF/INVOICE:^FS")
MSCBWrite("^FT42,608^A0N,42,40^FH\^FD"+VARNOM+"^FS")
MSCBWrite("^FT42,554^A0N,29,28^FH\^FDNOME:^FS")
MSCBWrite("^FT42,312^A0N,29,28^FH\^FDC\E3DIGO:^FS")
MSCBWrite("^BY3,3,76^FT85,830^BCN,,N,N")
MSCBWrite("^FD>:"+VARQTD+"^FS")
MSCBWrite("^FT38,83^A0N,29,28^FH\^FDLPN:^FS")
MSCBWrite("^BY2,3,66^FT69,467^BCN,,N,N")
MSCBWrite("^FD>:"+CODBAR2+"^FS")
MSCBWrite("^BY2,3,76^FT109,241^BCN,,N,N")
MSCBWrite("^FD>:"+VARLPN+"^FS")
MSCBWrite("^FT66,503^A0N,29,28^FH\^FD"+CODBAR2+"^FS")
MSCBWrite("^PQ1,0,1,Y^XZ")
MSCBWrite("^XA^ID000.GRF^FS^XZ")
mscbinfoeti("Yamaha","70X100")
MSCBEND()
//	MSCBCLOSEPRINTER()
Return
/*************************************************************************************/
//
//
//
Static Function RetNum_(nCampo,nTam,nDec)
Local cRet

cRet := StrZero(nCampo * If(nDec==Nil,1,10**nDec),nTam)

Return(cRet)

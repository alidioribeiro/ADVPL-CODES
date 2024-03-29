#include "rwmake.ch"
#Include "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IMPETIQS  �Autor  �Jefferson Moreira   � Data �  05/12/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Esse programa tem o objetivo de imprimir as etiquetas com  ���
���          � o codigo de barra dos itens de NF saida conforme parametros���
�������������������������������������������������������������������������͹��
���Uso       � SigaFat                                                    ���
�������������������������������������������������������������������������Ĵ��
���Alteracoes� * Jorge Em: 26/05/2009                                     ���
���          � Solicitacao Honda - O Layout foi ajustado conforme solici- ���
���          � cao do Cliente.                                            ���
���          � 01 - O Numero da N.Fiscal aumentou para 9 digitos.         ���
���          � 02 - Foi Incluido o Local da Entrega.                      ���
���          � Na Query, foi incluido o Campo C6_Entrega e foi incluido o ���
���          � campo Serie da Nota Fiscal no Filtro.                      ���
���          � M�rcio Macedo: 26/11/2012                                  ���
���          � Altera��o do layout Honda conforme solicita��o.            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function IMPV3ETIQS()

	Private oDlg := Nil
	Private IdEtiq:=""
	Pergunte("IMPETIQS ",.F.)

	//Da Nota Fiscal ?    mv_par01
	//Ate a Nota Fiscal ? mv_par02
	//Da Serie ?          mv_par03
	//Tipo Opera��o ?     mv_par04

	@ 96,42 TO 323,505 DIALOG oDlg TITLE "Etiquetas de Saida"
	@ 8,10 TO 84,222
	//@ 94,133 BMPBUTTON TYPE 5 ACTION Pergunte("NFSIGW")
	@ 94,133 BMPBUTTON TYPE 5 ACTION Pergunte("IMPETIQS")
	@ 94,163 BMPBUTTON TYPE 1 ACTION ImpEtqSaida()
	@ 94,193 BMPBUTTON TYPE 2 ACTION Close(oDlg)
	@ 23,14 SAY "Esse programa tem o objetivo de imprimir as etiquetas com"
	@ 33,14 SAY "o codigo de barra dos itens de NF saida conforme parametros"
	@ 43,14 SAY "especificado pelo usu�rio."
	@ 53,14 SAY ""
	ACTIVATE DIALOG oDlg

Return nil

Static Function ImpEtqSaida()

	cQuery := " Select "
	//cQuery += " C6_NUM,C6_PEDCLI,C6_LOTECTL,C6_TPEDIDO,C6_LINHA,F2_DOC,F2_SERIE,A7_PRODUTO,A7_CODCLI,A7_DESCCLI,C6_UM,A1_NREDUZ,C6_ENTREG,C6_HORA,C6_SETOR,SUM(C6_QTDVEN)AS C6_QTDVEN,C6_CLI,C6_LOJA,C6_ENTREGA,A7_CODASTE,F2_TES "
	cQuery += " '' C6_LOTECTL,C6_NUM,C6_PEDCLI,C6_TPEDIDO,C6_LINHA,F2_DOC,F2_SERIE,A7_PRODUTO,A7_CODCLI,A7_DESCCLI,C6_UM,A1_NREDUZ,C6_ENTREG,C6_HORA,C6_SETOR,SUM(C6_QTDVEN)AS C6_QTDVEN,C6_CLI,C6_LOJA,C6_ENTREGA,A7_CODASTE,F2_TES,F2_CLIENTE "
	cQuery += " From " + RetSqlName("SF2") + " SF2 "
	cQuery += " INNER JOIN " + RetSqlName("SC6") + " SC6 ON F2_DOC = C6_NOTA    AND F2_SERIE = C6_SERIE"
	cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 ON C6_CLI = A1_COD     AND C6_LOJA  = A1_LOJA"
	cQuery += " INNER JOIN " + RetSqlName("SA7") + " SA7 ON C6_CLI = A7_CLIENTE AND C6_LOJA  = A7_LOJA  AND C6_PRODUTO = A7_PRODUTO"
	cQuery += " WHERE "
	cQuery += " SF2.D_E_L_E_T_ = ''  AND "
	cQuery += " SC6.D_E_L_E_T_ = ''  AND "
	cQuery += " SA1.D_E_L_E_T_ = ''  AND "
	cQuery += " SA7.D_E_L_E_T_ = ''  AND "
	cQuery += " F2_DOC >='" + mv_par01 +"' AND "
	cQuery += " F2_DOC <='" + mv_par02 +"' AND "
	cQuery += " F2_SERIE ='" + mv_par03 +"'
	//cQuery += " AND C6_PRODUTO ='HP1089011N0CE00'

	cQuery += " GROUP BY "
	// cQuery += " C6_NUM,C6_PEDCLI,C6_LOTECTL,C6_TPEDIDO,C6_LINHA,F2_DOC,F2_SERIE,A7_PRODUTO,A7_CODCLI,A7_DESCCLI,C6_UM,A1_NREDUZ,C6_ENTREG,C6_HORA,C6_SETOR,C6_CLI,C6_LOJA, C6_ENTREGA,A7_CODASTE,F2_TES "
	cQuery += " C6_NUM,C6_PEDCLI,C6_TPEDIDO,C6_LINHA,F2_DOC,F2_SERIE,A7_PRODUTO,A7_CODCLI,A7_DESCCLI,C6_UM,A1_NREDUZ,C6_ENTREG,C6_HORA,C6_SETOR,C6_CLI,C6_LOJA, C6_ENTREGA,A7_CODASTE,F2_TES,F2_CLIENTE "

	cQuery += " Order By "
	cQuery += " F2_DOC ASC "


	cQuery := ChangeQuery(cQuery)

	TCQUERY cQuery Alias TAA New

	_NumNF  := Subs(TAA->F2_DOC,1,9)
	_SerNF  := Subs(TAA->F2_SERIE,1,3) //Subs(F2_SERIE,1,1)+Subs(F2_SERIE,3,1) 06.03.07
	_Serie  := Subs(TAA->F2_SERIE,1,3)

	TAA->(dbGoTop())
	PA1->(DbSetOrder(1))
	If PA1->(DbSeek(xFilial("PA1")+_NumNF+Substr(_Serie,1,2)+TAA->C6_CLI+TAA->C6_LOJA))
		While !PA1->(Eof()) .And. PA1->(PA1_FILIAL+PA1_DOC+PA1_SERIE+PA1_CLIENT+PA1_LOJA);
		==PA1->(xFilial("PA1")+_NumNF+Substr(_Serie,1,2)+TAA->C6_CLI+TAA->C6_LOJA)
			RecLock("PA1",.F.)
			dbDelete()
			MsUnlock()
			/*If Alltrim(PA1->PA1_STATUS)!="S"
			aAdd(aPsvs,{PA1->(Recno())})
			EndIf*/
			PA1->(DbSkip())
		EndDo
	EndIf

	While !TAA->(EOF())

		_CodCli:=  Alltrim(TAA->C6_CLI)
	/*Caso a op��o for re-impressao da Yamaha*/
		if _CodCli="028" .and. mv_par05=3
			// Comentado por M�rcio Macedo
			//if TAA->C6_LOTECTL<>mv_par05
			TAA->(DbSkip())
			Loop
			//Endif

		EndIf
		/************************************************/
		_CodCli:=  Alltrim(TAA->C6_CLI)
		_NumPed := Iif(_CodCli="002",Subs(TAA->C6_PEDCLI,1,8),TAA->C6_NUM)
		_TpPed  := Subs(TAA->C6_TPEDIDO,1,2)
		// _ItemNf:=D2_ITEM
		_Lote	:= TAA->C6_LOTECTL
		_LinPed := Subs(TAA->C6_LINHA,1,6)
		// _NumNF  := StrZero(Val(F2_DOC),9)
		_NumNF  := Subs(TAA->F2_DOC,1,9)
		_SerNF  := Subs(TAA->F2_SERIE,1,3) //Subs(F2_SERIE,1,1)+Subs(F2_SERIE,3,1) 06.03.07
		_Serie  := Subs(TAA->F2_SERIE,1,3)
		_CodPro := Subs(TAA->A7_CODCLI,1,25) 
		_DesPro := Subs(TAA->A7_DESCCLI,1,25)
		_zQuant := TAA->C6_QTDVEN
		_jQuant := TAA->C6_QTDVEN
		_Um     := Subs(TAA->C6_UM,1,2)
		_Emp    := Subs(TAA->A1_NREDUZ,1,4)
		_DtEnt  := Subs(TAA->C6_ENTREG,7,2) + "/" + Subs(TAA->C6_ENTREG,5,2)+ "/" + Subs(TAA->C6_ENTREG,3,2)
		_HrEnt  := Subs(TAA->C6_HORA,1,2)+":"+Subs(TAA->C6_HORA,3,4)
		_Setor  := TAA->C6_SETOR
		_LocEntrega := TAA->C6_ENTREGA
		_CodNS  := TAA->A7_PRODUTO
		_Lotes  := Array(1,20)
		_xLotes := 1
		_Clien  := TAA->C6_CLI
		_Loja   := TAA->C6_LOJA

		For x:=1 to 20
			_Lotes[1][x] := ""
		Next

		SD2->(DbSetOrder(3))  
		SD2->(DBGOTOP())

		If SD2->(dbSeek(xFilial("SD2") + _NumNF + _Serie + _Clien + _Loja + _CodNS))
			/*Informa��o para Honda***/
			While SD2->D2_COD == _CodNS
				if _CodCli="002"
					If _xLotes<11
						_Lotes[1][_xLotes] := SD2->D2_LOTECTL
						_xLotes++
					EndIf
				Else
					If Empty(SD2->D2_IDEETIQ)
						CodEtiq:=Getmv("MV_IDEETIQ")
						RecLock("SD2",.F.)
						SD2->D2_IDEETIQ:=Strzero(CodEtiq,6)
						MsUnLock()
						CodEtiq:=CodEtiq+1
						Putmv("MV_IDEETIQ",CodEtiq)
					EndIf
				Endif
				/*************************************************************************************/
				SD2->(dbSkip())
			Enddo

			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1") + _CodNS))

            If _CodCli="002" //Entrega da Honda � por carrinho
	             	_xQuant := SB1->B1_QEPSV * SB1->B1_MULTPSV
	         Else
		            _xQuant := SB1->B1_QEPSV //Yamaha � por embalagem
           	EndIf


			_xVol := Int(_zQuant /_xQuant)                       

			If _xVol <= 0
				msgStop("Favor verificar a quantidade por embalagem do produto: "+_CodNS+". A etiqueta deste produto n�o sera impressa!","IMPETIQV3")
			Endif

			If _xVol <> _zQuant /_xQuant
				_xVol += 1
			Endif
			///Se Cliente for Yamanha pega o sequencial gerado para no campo D2_ITE
			If _CodCli="028"
				DbSelectArea("SD2")
				SD2->(DbSetOrder(3))
				chave:=xFilial("SD2")+ _NumNF + _Serie + _Clien + _Loja + _CodNS
				if SD2->(DbSeek(xFilial("SD2")+_NumNF + _Serie + _Clien + _Loja + _CodNS))
					While Chave==xFilial("SD2")+SD2->(D2_DOC + D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD)
						If _Lote==SD2->D2_LOTECTL
							IdEtiq:=SD2->D2_IDEETIQ
						EndIf
						SD2->(DbSkip())
					EndDo
				EndIf
			EndIF

			dbSelectArea("TAA")
			For _Ent:= 1 to _xVol

				If _Ent <> _xVol
					_Quant1 := Alltrim(Transform (_xQuant ,"@E 999999999.999"))

				Elseif _xVol == 1
					_Quant1 := Alltrim(Transform (_zQuant ,"@E 999999999.999"))

				Else
					If _CodCli='002'
						_Quant1 := AllTrim(Transform (_jQuant ,"@E 999999999.999"))
					EndIf

			Endif

				if _Ent=_xVol  .and. _CodCli='028'  //Condi��3681o para a Yamaha
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
					u_FGeraPSV(_NumNF,_Serie,_Clien,_Loja,_CodNS,dDataBase,Val(_Quant1),_NumPed,CtoD(_DtEnt),_HrEnt,_Setor,_LinPed,_NumPed+_TpPed+_LinPed+StrZero(Val(_NumNF),9)+Left(_SerNF,2)+_CodPro+_Quant+_Um ,_TpPed)
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
						Alert('Identifica��o de Etiqueta n�o encontrado.Avise o TI.')
					EndIF
				Endif

			Next
			//Impress�o diferenciada para Yamaha
		EndIf
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
	MSCBBEGIN(1,5)
	MSCBWrite("^XA~TA000~JSN^LT0^MMT^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,4^MD0^JUS^LRN^CI0^XZ^XA^LL1807^PW933")
	MSCBWrite("^FT46,1094^A0B,17,19^FH\^FDNRO. PEDIDO^FS")
	MSCBWrite("^FT51,426^A0B,17,21^FH\^FDNOTA FISCAL^FS")
	MSCBWrite("^FT46,1773^A0B,17,21^FH\^FDFORNECEDOR^FS")
	MSCBWrite("^FT98,1770^A0B,58,57^FH\^FDNIPPON SEIKI^FS")
	MSCBWrite("^FT903,1149^A0B,33,36^FH\^FD"+StrZero(Val(_NumNF),9)+"-"+Left(_SerNF,2)+"^FS")
	MSCBWrite("^FT103,429^A0B,58,57^FH\^FD"+StrZero(Val(_NumNF),9)+"-"+Left(_SerNF,2)+"^FS")
	MSCBWrite("^FO674,26^GB0,1755,3^FS")
	MSCBWrite("^FO557,26^GB0,1755,3^FS")
	MSCBWrite("^FO248,31^GB0,1756,3^FS")
	MSCBWrite("^FT726,1691^A0B,33,36^FH\^FD"+ _CodPro+"^FS")
	MSCBWrite("^FT301,1707^A0B,58,57^FH\^FD"+ _CodPro+"^FS")
	MSCBWrite("^BY3,5,136^FT868,1785^BCB,,N,N")
	MSCBWrite("^FD"+ _NumPed+_TpPed+_LinPed+StrZero(Val(_NumNF),9)+Left(_SerNF,2)+ "^FS")
	MSCBWrite("^BY3,5,137^FT244,1785^BCB,,N,N")
	MSCBWrite("^FD"+ _NumPed+_TpPed+_LinPed+StrZero(Val(_NumNF),9)+Left(_SerNF,2)+ "^FS")
	MSCBWrite("^BY3,5,133^FT448,1785^BCB,,N,N")
	MSCBWrite("^FD"+  _CodPro+_Quant+_Um  + "^FS") 
	MSCBWrite("^FT719,1743^A0B,17,16^FH\^FDITEM^FS")
	MSCBWrite("^FT271,1772^A0B,17,16^FH\^FDITEM^FS")
	MSCBWrite("^FT475,1772^A0B,17,16^FH\^FDDESCRI\80\C7O DO ITEM^FS")
	MSCBWrite("^FT531,1772^A0B,50,50^FH\^FD"+ _DesPro +"^FS")
	MSCBWrite("^FT468,873^A0B,17,16^FH\^FDQUANTIDADE^FS")
	MSCBWrite("^FT535,876^A0B,58,57^FH\^FD"+ _Quant1 +"^FS")
	MSCBWrite("^FT470,488^A0B,17,16^FH\^FDUN^FS")
	MSCBWrite("^FT530,489^A0B,58,57^FH\^FD"+ _Um +"^FS")
	MSCBWrite("^FT643,1768^A0B,50,50^FH\^FD"+ _Emp  + "^FS")
	MSCBWrite("^FT895,1251^A0B,17,16^FH\^FDNOTA FISCAL^FS")
	MSCBWrite("^FT894,1734^A0B,17,16^FH\^FDNRO.PEDIDO^FS")
	MSCBWrite("^FT582,1769^A0B,17,16^FH\^FDEMPRESA^FS")
	MSCBWrite("^FT643,1636^A0B,50,50^FH\^FD"+ _DtEnt +"^FS")
	MSCBWrite("^FT582,1635^A0B,17,16^FH\^FDDATA DE ENTREGA^FS")
	MSCBWrite("^FT582,1413^A0B,17,21^FH\^FDHORA DE ENTREGA^FS")
	MSCBWrite("^FT643,1393^A0B,50,50^FH\^FD"+ _HrEnt +"^FS")
	MSCBWrite("^FT643,876^A0B,50,50^FH\^FD" +_LocEntrega+"^FS")
	MSCBWrite("^FT643,1217^A0B,50,50^FH\^FD"+ _Setor +"^FS")
	MSCBWrite("^FT582,871^A0B,17,24^FH\^FDLOCAL DE ENTREGA^FS")
	MSCBWrite("^FT582,1219^A0B,17,24^FH\^FDSETOR^FS")
	MSCBWrite("^FT843,253^A0B,117,115^FH\^FDPSV^FS")
	MSCBWrite("^FT527,135^A0B,58,57^FH\^FDPSV^FS")
	MSCBWrite("^FT530,345^A0B,58,57^FH\^FD"+ Strzero(_Ent,3) + "/"+ Strzero(_xVol,3) +"^FS")
	MSCBWrite("^FT467,346^A0B,17,19^FH\^FDQTD/VOL^FS")
	MSCBWrite("^FT582,458^A0B,17,16^FH\^FDOUTROS^FS")
	MSCBWrite("^FO564,466^GB109,0,2^FS")
	MSCBWrite("^FO564,1236^GB108,0,3^FS")
	MSCBWrite("^FO564,882^GB108,0,3^FS")
	MSCBWrite("^FO564,1417^GB108,0,2^FS")
	MSCBWrite("^FT903,1636^A0B,33,36^FH\^FD" +_NumPed+"-"+_TpPed+"-"+_LinPed+ "^FS")
	MSCBWrite("^FO563,1647^GB111,0,2^FS")
	MSCBWrite("^FT98,1102^A0B,58,57^FH\^FD" +_NumPed+"-"+_TpPed+"-"+_LinPed+ "^FS")
	MSCBWrite("^FT668,235^A0B,42,40^FH\^FD"+ _Lotes[1][4] + "^FS")
	MSCBWrite("^FT668,461^A0B,42,40^FH\^FD"+ _Lotes[1][3] + "^FS")
	MSCBWrite("^FT629,461^A0B,42,40^FH\^FD"+ _Lotes[1][1] + "^FS")
	MSCBWrite("^FT628,235^A0B,42,40^FH\^FD"+ _Lotes[1][2] + "^FS")
	MSCBWrite("^FT592,387^A0B,42,40^FH\^FDLotes :^FS")

	MSCBWrite("^PQ1,0,1,Y^XZ")

	MSCBEND()
	MSCBCLOSEPRINTER()

Return

/*************************************************************************************/
/*
Static Function EtiqHonda()
	MSCBPRINTER("Z4M","LPT1",,,)
	MSCBCHKStatus(.F.)
	MSCBBEGIN(1,6)
	MSCBWrite("^XA~TA000~JSN^LT0^MMT^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,4^MD0^JUS^LRN^CI0^XZ^XA^LL1807^PW933")

	MSCBWrite("^FT19,1094^A0B,17,19^FH\^FDNRO. PEDIDO^FS")
	MSCBWrite("^FT19,344^A0B,17,21^FH\^FDNOTA FISCAL^FS")
	MSCBWrite("^FT19,1773^A0B,17,21^FH\^FDFORNECEDOR^FS")
	MSCBWrite("^FT71,1770^A0B,58,57^FH\^FDNIPPON SEIKI^FS")
	MSCBWrite("^FT693,1030^A0B,33,36^FH\^FD"+StrZero(Val(_NumNF),9)+"-"+Left(_SerNF,2)+"^FS")
	MSCBWrite("^FT72,347^A0B,58,57^FH\^FD"+StrZero(Val(_NumNF),9)+"-"+Left(_SerNF,2)+"^FS")
	MSCBWrite("^FO656,28^GB0,1755,3^FS")
	MSCBWrite("^FO544,28^GB0,1755,2^FS")
	MSCBWrite("^FO225,27^GB0,1755,3^FS")
	MSCBWrite("^FT873,1112^A0B,33,36^FH\^FD"+ _CodPro+"^FS")
	MSCBWrite("^FT288,1704^A0B,58,57^FH\^FD"+ _CodPro+"^FS")
	MSCBWrite("^BY3,3,136^FT841,1612^BCB,,N,N")
	MSCBWrite("^FD>:"+ _NumPed+_TpPed+_LinPed+StrZero(Val(_NumNF),9)+Left(_SerNF,2)+ "^FS")
	MSCBWrite("^BY3,3,137^FT217,1741^BCB,,N,N")
	MSCBWrite("^FD>:"+ _NumPed+_TpPed+_LinPed+StrZero(Val(_NumNF),9)+Left(_SerNF,2)+ "^FS")
	MSCBWrite("^BY3,3,133^FT432,1741^BCB,,N,N")
	MSCBWrite("^FD>:"+  _CodPro+_Quant+_Um  + "^FS")
	MSCBWrite("^FT866,1164^A0B,17,16^FH\^FDITEM^FS")
	MSCBWrite("^FT244,1772^A0B,17,16^FH\^FDITEM^FS")
	MSCBWrite("^FT463,1770^A0B,17,16^FH\^FDDESCRI\80\C7O DO ITEM^FS")
	MSCBWrite("^FT520,1770^A0B,50,50^FH\^FD"+ _DesPro +"^FS")
	MSCBWrite("^FT457,789^A0B,17,16^FH\^FDQUANTIDADE^FS")
	MSCBWrite("^FT524,791^A0B,58,57^FH\^FD"+ _Quant1 +"^FS")
	MSCBWrite("^FT459,403^A0B,17,16^FH\^FDUN^FS")
	MSCBWrite("^FT519,405^A0B,58,57^FH\^FD"+ _Um +"^FS")
	MSCBWrite("^FT625,1771^A0B,50,50^FH\^FD"+ _Emp  + "^FS")
	MSCBWrite("^FT686,1133^A0B,17,16^FH\^FDNOTA FISCAL^FS")
	MSCBWrite("^FT684,1615^A0B,17,16^FH\^FDNRO.PEDIDO^FS")
	MSCBWrite("^FT564,1771^A0B,17,16^FH\^FDEMPRESA^FS")
	MSCBWrite("^FT625,1638^A0B,50,50^FH\^FD"+ _DtEnt +"^FS")
	MSCBWrite("^FT564,1638^A0B,17,16^FH\^FDDATA DE ENTREGA^FS")
	MSCBWrite("^FT564,1415^A0B,17,21^FH\^FDHORA DE ENTREGA^FS")
	MSCBWrite("^FT625,1396^A0B,50,50^FH\^FD"+ _HrEnt +"^FS")
	MSCBWrite("^FT625,879^A0B,50,50^FH\^FD" +_LocEntrega+"^FS")
	MSCBWrite("^FT625,1219^A0B,50,50^FH\^FD"+ _Setor +"^FS")
	MSCBWrite("^FT564,873^A0B,17,24^FH\^FDLOCAL DE ENTREGA^FS")
	MSCBWrite("^FT564,1222^A0B,17,24^FH\^FDSETOR^FS")
	MSCBWrite("^FT519,261^A0B,58,57^FH\^FD"+ Strzero(_Ent,3) + "/"+ Strzero(_xVol,3) +"^FS")
	MSCBWrite("^FT456,261^A0B,17,19^FH\^FDQTD/VOL^FS")
	MSCBWrite("^FT564,460^A0B,17,16^FH\^FDOUTROS^FS")
	MSCBWrite("^FO546,468^GB109,0,3^FS")
	MSCBWrite("^FO546,1239^GB108,0,2^FS")
	MSCBWrite("^FO546,885^GB108,0,2^FS")
	MSCBWrite("^FO546,1419^GB108,0,2^FS")
	MSCBWrite("^FT694,1518^A0B,33,36^FH\^FD" +_NumPed+"-"+_TpPed+"-"+_LinPed+ "^FS")
	MSCBWrite("^FO546,1649^GB110,0,3^FS")
	MSCBWrite("^FT72,1102^A0B,58,57^FH\^FD" +_NumPed+"-"+_TpPed+"-"+_LinPed+ "^FS")
	MSCBWrite("^FT650,237^A0B,42,40^FH\^FD"+ _Lotes[1][1] + "^FS")
	MSCBWrite("^FT651,463^A0B,42,40^FH\^FD"+ _Lotes[1][2] + "^FS")
	MSCBWrite("^FT610,463^A0B,42,40^FH\^FD"+ _Lotes[1][3] + "^FS")
	MSCBWrite("^FT610,237^A0B,42,40^FH\^FD"+ _Lotes[1][4] + "^FS")
	MSCBWrite("^FT574,390^A0B,42,40^FH\^FDLotes :^FS")

	MSCBWrite("^PQ1,0,1,Y^XZ")

	MSCBEND()
	MSCBCLOSEPRINTER()

Return*/

/*************************************************************************************/
/*******************************************************************************************/
Static Function EtiqYamaha()
	//If SD2->D2_TES='520'
	//	_CodPro := Subs(A7_CODASTE,1,20) + Space(5)
	//EndIf


	If F2_TES='520'
		_CodProA := Subs(A7_CODASTE,1,20) + Space(5)
	Else
		_CodProA := Subs(A7_CODCLI,1,20) + Space(5)
	EndIf

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


Static Function RetNum_(nCampo,nTam,nDec)
	Local cRet

	cRet := StrZero(nCampo * If(nDec==Nil,1,10**nDec),nTam)

Return(cRet)

User Function FGeraPsv(_NumNF,_Serie,_Clien,_Loja,_CodNS,dDataBase,_Quant1,_NumPed,_DtEnt,_HrEnt,_Setor,_LinPed,cCodBar,_TpPed)

	BEGIN TRANSACTION 
		RecLock("PA1",.T.)

		PA1->PA1_FILIAL := xFilial("PA1")
		PA1->PA1_DOC    := _NumNF
		PA1->PA1_SERIE  := _Serie
		PA1->PA1_CLIENTE:= _Clien
		PA1->PA1_LOJA   := _Loja
		PA1->PA1_PRODUT := _CodNS
		PA1->PA1_EMISSAO:= dDataBase
		PA1->PA1_QTD    := _Quant1
		PA1->PA1_PEDCLI := _NumPed 
		PA1->PA1_ENTREG := _DtEnt
		PA1->PA1_HORA   := _HrEnt
		PA1->PA1_SETOR  := _Setor
		PA1->PA1_LINHA  := _LinPed
		If PA1->(FieldPos("PA1_TPPED"))>0 
			PA1->PA1_TPPED  := _TpPed
		EndIf
		PA1->PA1_CODBAR := cCodBar

		PA1->(MsUnlock())
	END TRANSACTION 

Return 
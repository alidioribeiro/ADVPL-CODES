#include "protheus.ch"
#include "topconn.ch"
#include "apvt100.ch"

Static __nSem:=0
//MT416A PERGUNTA DO ORÇCAMENTO


User Function ACDG03()
Local aTela      := vtsave()
Local nOpcao     := 0
Local cOPOrigem  := space(10)
Local bkey24
Local nZ         := 0

// Verifica se utiliza controle de transacao.
Private lTTS       := iif(getmv('MV_TTS') == 'S', .T., .F.)
Private aOP        := {}
Private aSCK := {}
Private aSCKLOTE := {}
Private aTmpEtiq := {}
Private aTmpLote := {}
Private	aSaldoFifo := {}
Private aEtiqueta := {}
Private cProduto   := space(tamsx3('B1_COD')[1])
Private cDescProd  := space(tamsx3('B1_DESC')[1])
Private cLote      := space(tamsx3('D3_LOTECTL')[1])
Private nQE        := 0
Private nQuantProd := 0
Private nQuantLida := 0
Private nQuantEtiq := 0
Private cOP := Space(11)
Private cLocal := space(tamsx3('C2_LOCAL')[1])
Private cEtiqueta := Space(10)
Private cEndOri := Space(tamsx3('DB_LOCALIZ')[1])
Private cEndDes := Space(tamsx3('DB_LOCALIZ')[1])
Private cDescEnd  := Space(tamsx3('BE_DESCRIC')[1])
Private cDoc := Space(tamsx3('DA_DOC')[1])
Private cNumSeq := Space(tamsx3('DA_NUMSEQ')[1])
Private cItem := Space(tamsx3('DB_ITEM')[1])
Private cNumOrc := Space(tamsx3('CJ_NUM')[1])
Private cCont := Space(01)
Private cCont2 := Space(01)
Private lVtYesno := .F.
Private nX := 0
Private lPorLote := .F.
Private lSair := .F.
Private lProximo := .F.
Private lSaldo := .T.
//
//vtalert("MICRO ALEX S:")
//
bKey24 := VTSetKey(24,{|| Proximo()}, "Proximo Produto")   // CTRL+X //"Estorno"
//
//
//vtalert("teste")
//
While .t.
	vtclear
	//
	aOP        := {}
	aSCK := {}
	aSCKLOTE := {}
	aEtiqueta := {}
	cProduto   := space(tamsx3('B1_COD')[1])
	cDescProd  := space(tamsx3('B1_DESC')[1])
	cLote      := space(tamsx3('D3_LOTECTL')[1])
	nQE        := 0
	nQuantProd := 0
	nQuantLida := 0
	nQuantEtiq := 0
	cOP := Space(11)
	cLocal := space(tamsx3('C2_LOCAL')[1])
	cEtiqueta := Space(10)
	cEndOri := Space(tamsx3('DB_LOCALIZ')[1])
	cEndDes := Space(tamsx3('DB_LOCALIZ')[1])
	cDescEnd  := Space(tamsx3('BE_DESCRIC')[1])
	cDoc := Space(tamsx3('DA_DOC')[1])
	cNumSeq := Space(tamsx3('DA_NUMSEQ')[1])
	cItem := Space(tamsx3('DB_ITEM')[1])
	cNumOrc := Space(tamsx3('CJ_NUM')[1])
	cCont := Space(01)
	cCont2 := Space(01)
	lVtYesNo := .F.
	lPorLote := .F.
	lSair := .F.
	lSaldo := .T.
	//	vtclear
	vtreverso(.T.)
	@ 00,02 vtsay 'Ordem Separação NSB'
	vtreverso(.F.)
	//
	//
	@ 01,00 vtsay 'Ord.Exp:'
	@ 02,00 vtget cNumOrc picture '@!' valid  !empty(cNumOrc) .and. ValidOrc(cNumOrc)  f3 'SCJ'
	//@ 02,00 vtsay 'Ender. Origem:'
	//@ 03,00 vtget cEndOri   picture '@!' valid  ValidEndereco(cLocal, cEndOri) f3 'SBE' //when .F.
	//@ 04,00 vtsay 'Ender. Destino:'
	//@ 05,00 vtget cEndDes   picture '@!' valid  ValidEndereco(cLocal, cEndDes) .and. cEndOri <> cEndDes F3 'SBE' //when .F.
	vtread
	If VtLastKey() == 27
		Exit
	Endif
	vtclear
	nX := 1
	While  nX <= Len(aSCK)
		cProduto := aSCK[nX,1]
		cDescProd := ALLTRIM(Posicione('SB1', 1, xfilial('SB1') +aSCK[nX,1] , 'B1_MODELO' )) + ' PED.: ' + aSCK[nX,7]
		nQuantProd := aSCK[nX,6]
		cLocal := aSCK[nX,2]
		//
		//aadd( aSCK, {CK_PRODUTO, CK_LOCAL, CK_LOCALIZ, CK_LOTECTL, CK_NUMLOTE, CK_QTDVEN, CK_PEDCLI, CK_ITEM, 0} )
		vtgetrefresh('cProduto')
		vtgetrefresh('cDescProd')
		vtgetrefresh('nQuantProd')
		//
		@ 00,00 vtsay 'Prd: '
		@ 00,04 vtget cProduto   picture '@!' when .F.
		@ 01,00 vtsay 'Mod: '
		@ 01,00 vtget cDescProd  picture '@!' when .F.
		@ 02,00 vtsay 'Qtd.Orc.:'
		@ 02,10 vtget nQuantProd picture '@E 999,999.99' when .F.
		//
		cCont := Space(01)
		cEtiqueta := Space(10)
		nQuantLida := 0
		nQuantEtiq := 0
		aTmpEtiq := {}
		aTmpLote := {}
		If Select("CB0TMP") <> 0
			CB0TMP->(dbCloseArea())
		Endif
		cQuery := " SELECT * "
		cQuery += " FROM "+ RETSQLNAME("CB0")+"	"
		cQuery += " WHERE D_E_L_E_T_<>'*' AND CB0_NUMORC= '"+cNumOrc+"' " //AND CB0_PEDCLI='"+Alltrim(aSCK[nX,7])+"' "
		cQuery += " AND CB0_CODPRO='"+Alltrim(aSCK[nX,1])+"' AND CB0_LOCAL='"+Alltrim(aSCK[nX,2])+"'"
		cQuery += " ORDER BY CB0_CODPRO, CB0_PEDCLI, CB0_CODETI "
		cQuery := ChangeQuery(cQuery)
		TCQUERY cQuery Alias CB0TMP New
		dbSelectArea("CB0TMP")
		dbgotoP()
		Do While CB0TMP->(!Eof())
			//aadd(aTmpEtiq, { cProduto+ cLocal+ cLote+ cPedCli, cEtiqueta, cProduto, cLote, cSLote, cNumSerie, nQtd, cLocal, cPedCli})
			//                                                        01          02          03        04         05          06        07         08          09  10
			aadd(aTmpEtiq, { CB0_CODPRO+ CB0_LOCAL+ CB0_LOTE+ CB0_PEDCLI, CB0_CODETI, CB0_CODPRO, CB0_LOTE, CB0_SLOTE, CB0_NUMSER, CB0_QTDE, CB0_LOCAL, CB0_PEDCLI, "" })
			If (nPos := Ascan( aTmpLote, { |x| x[1] == CB0_LOCAL+ CB0_LOTE } ) ) == 0
				aadd( aTmpLote, { CB0_LOCAL+ CB0_LOTE, CB0_QTDE } )
			Else
				aTmpLote[nPos, 2] += CB0_QTDE
			Endif
			If CB0_CODPRO+CB0_PEDCLI == aSCK[nX,1]+aSCK[nX,7] // para evitar problema qdo existe o mesmo codigo e ped. de cliente diferentes
			   nQuantLida += CB0_QTDE
			Endif
			nQuantEtiq ++
			dbSkip()
		Enddo
		CB0TMP->(dbCloseArea())
		//
		nSaldo := 0
		FOR nZ := 1 to Len(aTmpLote)
			// INDICE 1 SBF CHAVE: BF_FILIAL+BF_LOCAL+BF_LOCALIZ+BF_PRODUTO+BF_NUMSERI+BF_LOTECTL+BF_NUMLOTE
			//aadd( aSCK, {CK_PRODUTO, CK_LOCAL, CK_LOCALIZ, CK_LOTECTL, CK_NUMLOTE, CK_QTDVEN, CK_PEDCLI, CK_ITEM, CK_NUMSERI} )
			nSaldo := POSICIONE('SBF', 1, xfilial('SBF') + aSCK[nX,2]+ aSCK[nX,3]+ aSCK[nX,1]+ aSCK[nX,9]+ Substr(aTmpLote[nZ,1],3,10) , 'BF_QUANT')
			If aTmpLote[nZ,2] > nSaldo
				vtalert('1. Saldo do lote.: '+ aTmpLote[nZ,1] +' / '+ ALLTRIM(STR(nSaldo)) +' é insuficiente  !', 'AVISO') // , .T., 2000)
				lSaldo := .F.
			Endif
		NEXT
		//
		// CUSTOMIZAÇÃO FIFO
		If !Empty(cNumOrc)
			aSaldoFifo := {}
			If POSICIONE("SB1",1,xFilial("SB1")+ CB0->CB0_CODPRO,"B1_TIPO") $ "PI/PA"
		   		PegaSaldoFifo()                                                 
			EndIf
		Endif
		// CUSTOMIZAÇÃO FIFO
		//
		lSair := .F.
		While  nX <= Len(aSCK)  .And. nQuantLida < nQuantProd .And. !lSair
			cEtiqueta := Space(10)
			@ 03,00 vtsay 'Qtd.:'
			@ 03,10 vtget nQuantLida picture '@E 999,999.99' when .F.
			@ 05,00 vtsay 'Etiqueta:'
			@ 05,10 vtget cEtiqueta   picture '@!' valid  !Empty(cEtiqueta) .and. ValidEtiqueta()  //, cLocal, cEndOri, cEndDes, cProduto) //f3 'SBE' //when .F.
			@ 06,00 vtsay 'Qtd.Etq:'
			@ 06,10 vtget nQuantEtiq picture '@E 999,999.99' when .F.
			vtread
			If VtLastKey() == 27
				cCont := Space(01)
				aTela := VTSave()
				VTClear()
				cMensagem := ""
				If lProximo
					cMensagem := "Deseja passar para o proximo produto ?"
					cCont := '1'
				Else
					cMensagem := "Deseja sair da rotina ?"
				Endif
				lVtYesno := VTYesNo(cMensagem,"Aviso" ,.T.)
				If lVtYesNo
					If Len(aTmpEtiq) > 0
						While !lSair
							@ 03,00 vtsay ' Salvar  etiquetas   '
							@ 04,00 vtsay ' lidas? (1=S/0=N)   '
							@ 05,10 vtget cCont 	Picture '9' 	valid cCont $ "01" when !lProximo //fConfirma(@cCont)
							vtread
							If cCont $ "01"
								If cCont == "1"
									For nZ := 1 to Len(aTmpEtiq)
										dbSelectArea("CB0")
										CB0->(dbSeek(xFilial("CB0")+ aTmpEtiq[nZ,2]))
										//If Empty(CB0->CB0_NUMORC) //.Or. Empty(CB0->CB0_PEDCLI)
										RecLock("CB0", .F.)
										CB0->CB0_NUMORC := cNumOrc
										CB0->CB0_PEDCLI := aTmpEtiq[nZ,9]  //aSCK[nX,7]
										CB0->CB0_USUARI := Posicione('CB1', 2, xfilial('CB1') + __cuserid, 'CB1_CODOPE')
										CB0->CB0_DTLEIT := dDatabase
										CB0->CB0_HRLEIT := time()
										MsUnlock()
										//Endif
										//
										// incluido por alex em 04/09/13 FIFO
										If aTmpEtiq[nZ,10] == "S"
											U_LogQuebraFifo(CB0->CB0_CODPRO, CB0->CB0_LOCAL, CB0->CB0_LOCALI, CB0->CB0_LOTE, CB0->CB0_SLOTE, CB0->CB0_QTDE, CB0->CB0_CODETI, "", "", "", "EXP", cNumOrc)
										Endif
									Next
								Endif
								Exit
							Endif
						Enddo
					Endif
					aTmpEtiq := {}
					vtRestore(,,,,aTela)
					lSair := .T.
				Else
					vtRestore(,,,,aTela)
					lSair := .F.
					lProximo := .F.
				Endif
			EndIf
		Enddo
		If !lProximo
			If  nQuantLida == nQuantProd .and. Len(aTmpEtiq) > 0 // atualizar as etiquetas quando atingir a quantidade do orçamento.
				//vtalert(str(nx))
				For nZ := 1 to Len(aTmpEtiq)
					If (nPos := Ascan( aEtiqueta, { |x| x[2] == aTmpEtiq[nZ,2] } ) ) == 0
						aadd(aEtiqueta, aTmpEtiq[nZ])
					Endif
					CB0->(dbSeek(xFilial("CB0")+ aTmpEtiq[nZ,2]))
					//If Empty(CB0->CB0_NUMORC) .OR. Empty(CB0->CB0_PEDCLI)
					RecLock("CB0", .F.)
					CB0->CB0_NUMORC := cNumOrc
					CB0->CB0_PEDCLI := aTmpEtiq[nZ,9] //aSCK[nX,7]
					CB0->CB0_USUARI := Posicione('CB1', 2, xfilial('CB1') + __cuserid, 'CB1_CODOPE')
					CB0->CB0_DTLEIT := dDatabase
					CB0->CB0_HRLEIT := time()
					MsUnlock()
					//Endif
					// incluido por alex em 04/09/13 FIFO
					If aTmpEtiq[nZ,10] == "S"
						U_LogQuebraFifo(CB0->CB0_CODPRO, CB0->CB0_LOCAL, CB0->CB0_LOCALI, CB0->CB0_LOTE, CB0->CB0_SLOTE, CB0->CB0_QTDE, CB0->CB0_CODETI, "", "", "", "EXP", cNumOrc)
					Endif
				Next
			Else
				Exit
			Endif
		Else
			lProximo := .F.
			//If nX == Len(aSCK)
			//	nX :=  0
			//Endif
		Endif
		nX ++
		If nX > Len(aSCK)
			//aadd(aTmpEtiq, { cProduto+ cLocal+ cLote+ cPedCli, cEtiqueta, cProduto, cLote, cSLote, cNumSerie, nQtd, cLocal, cPedCli})
			aEtiqueta := ASORT(aEtiqueta,,, { |x, y| x[3]+x[9] < y[3]+y[9] })   //Ordena o vetor por produto + local+ lote+ PEDCLI
			//			vtalert(str(len(aetiqueta)))
			nY := 1
			_Save := VTSAVE()
			VTClear()
			VTaLERT('Analisando leitura por item ...',"TOTALIZANDO", .T., 1000)  //'Aguarde...'
			Do While nY <= LEN(aSCK)
				If (nPos := Ascan( aEtiqueta, { |x| x[3]+x[9] == aSCK[nY,1]+aSCK[nY,7] } ) ) > 0
					_Qtde := 0
					_Produto := aEtiqueta[nPos,3]
					_PedCli  := aEtiqueta[nPos,9]
					Do While nPos <= Len(aEtiqueta) .and. _Produto == aEtiqueta[nPos,3] .and. _PedCli == aEtiqueta[nPos,9]
						_Qtde += aEtiqueta[nPos,7]
						nPos++
					Enddo
					If _Qtde < aSCK[nY,6]
						VTAlert("Existem itens com leitura incompleta!","Aviso", .T.,3000 )
						nX := 1
						//lSair := .F.
						Exit
					Endif
				Else
					VTAlert("Existem itens faltando leitura!","Aviso" ,.T.,3000)
					nX := 1
					//lSair := .F.
					Exit
				Endif
				nY++
			Enddo
			vtRestore(,,,, _Save)
		Endif
	Enddo
	If  nX > Len(aSCK)  .and. lSaldo
		cCont2 := Space(01)
		aTela := VTSave()
		VTClear()
		While .T.
			@ 03,00 vtsay ' Confirma a transfe '
			@ 04,00 vtsay ' rencia? (1=S/0=N) '
			@ 05,10 vtget cCont2 	Picture '9' 	valid cCont2 $ "01" //fConfirma(@cCont)
			vtread
			If cCont2 $ "1/0"
				Exit
			Endif
		Enddo
		vtRestore(,,,, aTela)
		If	cCont2 == "1" //VTYesNo("Confirma a transferencia?","Aviso" ,.T.) //"Confirma transferencia?"###"Aviso"
			vtbeep(2)
			if lTTS
				If CheckFifo()
					begin transaction
					Transferencia()  // transfere entre endereços
					dbcommitall()
					end transaction
				Endif
			else
				If CheckFifo()
					Transferencia()
					dbcommitall()
				Endif
			endif
			vtkeyboard(chr(0))
			vtclearbuffer()
		Else
			VTKeyboard(chr(20))
			vtalert('Abandonando separacao por escolha do usuario!!', 'AVISO', .T., 2000)
		Endif
		Exit
	Else
		If lVtYesNo
			vtalert('Abandonando separacao por escolha do usuario!!', 'AVISO', .T., 2000)
		Else
			vtalert('Abandonando separacao, inconsistencia na ordem de expedicao!!', 'AVISO', .T., 2000)
		Endif
		Exit
	Endif
Enddo
vtsetkey(24,bkey24)
Return
//
//
Static Function Transferencia()
Local nField
Local aSave
Local nX
Local aTransf:={}
Local dValid
Local cDoc       := ""
Local aNumSeqSD3 := {}
Local nPos   := 0
lOCAL cDoc	 := NextNumero("SD3",2,"D3_DOC",.T.) //GetSxENum("SD3","D3_DOC",1)
Local aNewTrans := {}
Local aNewLine  := {}
Local nxNewOpc  := 3
Private aTotal  := {}
Private aMov    := {}
Private nModulo := 4

aSave := VTSAVE()
VTClear()
VTalert('Totalizando lote(s) ...','Movimentação',.t.,2000)  //'Aguarde...'
//                                                                   1               2             3            4         5           6              7         8          9
//aadd(aTmpEtiq, { cProduto+ cLocal+ cLote+ cPedCli, cEtiqueta, cProduto, cLote, cSLote, cNumSerie, nQtd, cLocal, cPedCli })
aEtiqueta := ASORT(aEtiqueta,,, { |x, y| x[1] < y[1] })   //Ordena o vetor por produto + lote
For nX := 1 to Len(aEtiqueta)
	nPos   := Ascan(aTotal, {|x| x[1] == aEtiqueta[nX,1]})
	If nPos  == 0
		aadd( aTotal, { aEtiqueta[nX,1], aEtiqueta[nX,2], aEtiqueta[nX,3], aEtiqueta[nX,4], aEtiqueta[nX,5], aEtiqueta[nX,6],aEtiqueta[nX,7],aEtiqueta[nX,8],aEtiqueta[nX,9] } )
	Else
		aTotal[nPos,7] += aEtiqueta[nX,7]
	Endif
Next
//
For nX := 1 to Len(aEtiqueta)
	nPos := Ascan(aMov, {|x| left(x[1],27) == left(aEtiqueta[nX,1],27) })
	If nPos  == 0
		aadd( aMov, { left(aEtiqueta[nX,1],27), "", aEtiqueta[nX,3], aEtiqueta[nX,4], "", "", aEtiqueta[nX,7], aEtiqueta[nX,8], "" } )
	Else
		aMov[nPos,7] += aEtiqueta[nX,7]
	Endif
Next
//
lMsErroAuto := .F.
lMsHelpAuto := .T.
aTransf := Array(Len(aMov)+1)
aTransf[1] := {"",dDataBase}
aAdd(aNewTrans , {cDoc,dDataBase})
//
For nX := 1 to Len(aMov)
	nSCK := Ascan(aSCK, {|x| x[1] == aMov[nX,3]})
	//
	nSaldo := 0
	lSaldo := .T.
	//	aadd(aTmpEtiq, { cProduto+ cLote+ cSLote, cEtiqueta, cProduto, cLote, cSLote, cNumSerie, nQtd})
	nSaldo := POSICIONE('SBF', 1, xfilial('SBF') + aSCK[nSCK,2]+ aSCK[nSCK,3]+ aSCK[nSCK,1]+ aSCK[nSCK,9]+ aMov[nX,4] , 'BF_QUANT')
	If aMov[nX,7] > nSaldo
		VTALERT( aMov[nX,3]+" "+ aMov[nX,4]+" / "+ALLTRIM(STR(nSaldo))+ " não possui saldo suficiente! ","ERRO")   //,.T.,2000,3) //"Falha na gravacao da transferencia"###"ERRO"
		lSaldo := .F.
	Endif
	If !lSaldo
		VTALERT("Abandonando a separacao por falta de saldo!!!!","AVISO")
		Return(.F.)
	Endif
	//
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+aMov[nX,3]+aMov[nX,4]))
	If SB1->B1_RASTRO   == "L"   //Rastro(aLista[nI,1])
		dValid := Posicione('SB8', 3, xfilial('SB8') +aSCK[nSCK,1]+aSCK[nSCK,2]+aMov[nX,4]+ALLTRIM(aMov[nX,5]) , 'B8_DTVALID')  //SB8->B8_DTVALID
	Else
		dValid := dDatabase + SB1->B1_PRVALID
	EndIf
	// aadd( aSCK, {CK_PRODUTO, CK_LOCAL, CK_LOCALIZ, CK_LOTECTL, CK_NUMLOTE, CK_QTDVENI})
	//	aadd(aTmpEtiq, { cProduto+ cLocal+ cLote+ cSLote, cEtiqueta, cProduto, cLote, cSLote, cNumSerie, nQtd})
	/* olda style 
	aTransf[nX+1] := {	SB1->B1_COD,;   //1
	SB1->B1_DESC,;                       //2
	SB1->B1_UM,;                            //3
	aSCK[nSCK ,2],;  	//aLista[nI,3],;  //armazen origem //4
	aSCK[nSCK ,3],;	//aLista[nI,4],;  // endereco origem     //5
	SB1->B1_COD,;                                               //6
	SB1->B1_DESC,;                                                 //7
	SB1->B1_UM,;                                                   //8
	aSCK[nSCK ,2],; 	 //cArmDes,;                               //9
	GETMV("MV_ENDSEP"),; //cEndDes,;     //Endereco de destino     //10
	aMov[nX,6],;  	     //aLista[nI,7],; 	//NUMSER                //11
	aMov[nX,4],;		 //aLista[nI,5],;   //Lote                 //12
	aMov[nX,5],;		 //aLista[nI,6],;	//Sublote              //13
	dValid,;                                                       //14
	criavar("D3_POTENCI"),;                                        //15
	aMov[nX,7],; 		     //aLista[nI,2],;  // QTDE             //16
	criavar("D3_QTSEGUM"),;                                        //17
	criavar("D3_ESTORNO"),;                                        //18
	criavar("D3_NUMSEQ"),;                                         //19
	aMov[nX,4],; 		     //aLista[nI,5],;                      //20
	dValid ,;                                                      //21
	criavar("D3_ITEMGRD"),;
	criavar("D3_IDDCF"),;
	criavar("D3_OBSERVA"),;
	criavar("D3_CODSAF") }  //Item Grade                          //22
	*/
	
	// Reformulado  Adson e Alidio 03/03/2020
	aNewLine := {}
	aadd(aNewLine,{"ITEM"      ,'00'+cvaltochar(nX), Nil})
	aadd(aNewLine,{"D3_COD"    , SB1->B1_COD       , Nil}) //Cod Produto origem 
	aadd(aNewLine,{"D3_DESCRI" , SB1->B1_DESC      , Nil}) //descr produto origem 
	aadd(aNewLine,{"D3_UM"     , SB1->B1_UM        , Nil}) //unidade medida origem 
	aadd(aNewLine,{"D3_LOCAL"  , aSCK[nSCK ,2]     , Nil}) //armazem origem 
	aadd(aNewLine,{"D3_LOCALIZ", aSCK[nSCK ,3]     , Nil}) //Informar endereço origem 6
	
	aadd(aNewLine,{"D3_COD"    , SB1->B1_COD       , Nil}) //cod produto destino 
	aadd(aNewLine,{"D3_DESCRI" , SB1->B1_DESC      , Nil}) //descr produto destino 
	aadd(aNewLine,{"D3_UM"     , SB1->B1_UM        , Nil}) //unidade medida destino 
	aadd(aNewLine,{"D3_LOCAL"  , aSCK[nSCK ,2]     , Nil}) //armazem destino 
	aadd(aNewLine,{"D3_LOCALIZ", GETMV("MV_ENDSEP"), Nil}) //Informar endereço destino 11

	aadd(aNewLine,{"D3_NUMSERI", aMov[nX,6]        , Nil}) //Numero serie
	aadd(aNewLine,{"D3_LOTECTL", aMov[nX,4] 	   , Nil}) //Lote Origem
	aadd(aNewLine,{"D3_NUMLOTE", aMov[nX,5] 	   , Nil}) //sublote origem
	aadd(aNewLine,{"D3_DTVALID", dValid			   , Nil}) //data validade 
	aadd(aNewLine,{"D3_POTENCI", 0   			   , Nil}) // Potencia
	aadd(aNewLine,{"D3_QUANT"  , aMov[nX,7]		   , Nil}) //Quantidade  17
	aadd(aNewLine,{"D3_QTSEGUM", 0				   , Nil}) //Seg unidade medida
	aadd(aNewLine,{"D3_ESTORNO", ""				   , Nil}) //Estorno 
	aadd(aNewLine,{"D3_NUMSEQ" , ""				   , Nil}) // Numero sequencia D3_NUMSEQ 20

	aadd(aNewLine,{"D3_LOTECTL", aMov[nX,4]		   , Nil}) //Lote destino
	//aadd(aNewLine,{"D3_NUMLOTE", aMov[nX,5]		   , Nil}) //sublote destino  //Aqui que comeram bola
	aadd(aNewLine,{"D3_DTVALID", dValid  		   , Nil}) //validade lote destino
	aadd(aNewLine,{"D3_OBSERVA", ''                , Nil}) //Observacao
	aadd(aNewLine,{"D3_ITEMGRD", ""				   , Nil}) //Item Grade 

	//aadd(aNewLine,{"D3_CODLAN" , ""				   , Nil}) //cat83 prod origem
	//aadd(aNewLine,{"D3_CODLAN" , ""				   , Nil}) //cat83 prod destino  26

	aAdd(aNewTrans,aNewLine) //adiciona linha de transferencia


Next
//
Begin Transaction
//
//MSExecAuto( {|x| MATA261(x)}, aTransf ) chamada bugada
MSExecAuto({|x| mata261(x)},aNewTrans,3)
//
If lMsErroAuto
	VTALERT("Falha na gravacao da transferencia","ERRO",.T.,2000,3) //"Falha na gravacao da transferencia"###"ERRO"
	DisarmTransaction()
	//Break
EndIf
End Transaction
//
If	lMsErroAuto
	VTDispFile(NomeAutoLog(),.t.)
Endif
//
//If lMsErroAuto
//	VTDispFile(NomeAutoLog(),.t.)
//Endif
//
If !lMsErroAuto
	nQtdItens := 0
	nRecSCK := 0
	dbSelectArea("SCK")
	dbSetorder(1)
	dbSeek(xFilial("SCK")+ cNumOrc)
	nRecSCK := RECNO()
	While !Eof() .and. CK_FILIAL+CK_NUM == xFilial("SCK")+cNumOrc
		nQtdItens ++
		dbSkip()
	Enddo
	//
	VTCLEAR()
	VTMSG('Atualizando ordem de expedição ...' ,1)
	If Len(aTotal) == nQtdItens
		dbgoto(nRecSCK)
		While !Eof() .and. CK_FILIAL+CK_NUM == xFilial("SCK")+cNumOrc
			nPos := Ascan( aTotal, {|x| x[3] == CK_PRODUTO})
			RecLock("SCK",.F.)
			CK_LOTECTL := aTotal[nPos,4]
			CK_NUMLOTE := aTotal[nPos,5]
			CK_LOCALIZ := GETMV("MV_ENDSEP")
			MsUnlock()
			dbSkip()
		Enddo
	Else
		//VTMSG("Atualizando itens do orçamento!")
		aCabSCK := {}
		aRegSCK := {}
		nQtdFields := SCK->(FCOUNT())
		For nField := 1 to nQtdFields
			aadd(aCabSCK, FIELDNAME(nField) )
		Next
		//
		dbgoto(nRecSCK)
		While !Eof() .and. CK_FILIAL+CK_NUM == xFilial("SCK")+cNumOrc
			aadd(aRegSCK, array(nQtdFields) )
			For nField := 1 to nQtdFields
				aRegSCK[Len(aRegSCK), nField] := FIELDGET(nField)
			Next
			dbSkip()
		Enddo
		//
		nPosProd   := ASCAN( aCabSCK, "CK_PRODUTO")
		nPosPedCli := ASCAN( aCabSCK, "CK_PEDCLI")
		nItem := 1
		nX := 1
		dbgoto(nRecSCK)
		FOR nX := 1 to Len(aTotal)
			_cProduto := aTotal[nX,3]
			_cPedCli := aTotal[nX,9]
			nLinProd := ASCAN(aRegSCK, {|x| x[nPosProd]+x[nPosPedCli] == _cProduto+_cPedCli })
			//
			RecLock("SCK",	IIF(nX <= nQtdItens, .F., .T.) 	)
			CK_FILIAL 	:= XFILIAL("SCK")
			CK_ITEM 	:= STRZERO(nItem,2)
			CK_PRODUTO 	:= _cProduto
			CK_UM 		:=  Posicione('SB1', 1, xfilial('SB1') + _cProduto , 'B1_UM')
			CK_QTDVEN 	:= aTotal[nX,7]
			CK_PRCVEN 	:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_PRCVEN") ]
			CK_VALOR 	:= aTotal[nX,7] * aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_PRCVEN") ] //aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_VALOR") ]
			CK_TES 		:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_TES") ]
			CK_LOCAL 	:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_LOCAL") ]
			CK_CLIENTE 	:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_CLIENTE") ]
			CK_LOJA 	:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_LOJA") ]
			CK_DESCONT 	:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_DESCONT") ]
			CK_VALDESC 	:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_VALDESC") ]
			CK_PEDCLI 	:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_PEDCLI") ]
			CK_NUM 		:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_NUM") ]
			CK_DESCRI 	:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_DESCRI") ]
			CK_PRUNIT 	:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_PRUNIT") ]
			CK_NUMPV 	:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_NUMPV") ]
			CK_NUMOP 	:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_NUMOP") ]
			CK_COTCLI 	:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_COTCLI") ]
			CK_ENTREG 	:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_ENTREG") ]
			CK_ITECLI 	:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_ITECLI") ]
			CK_OBS		:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_OBS") ]
			CK_OPC 		:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_OPC") ]
			CK_CLASFIS 	:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_CLASFIS") ]
			//CK_OPER 	:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_OPER") ]
			CK_FILVEN 	:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_FILVEN") ]
			CK_FILENT 	:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_FILENT") ]
			CK_CONTRAT 	:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_CONTRAT") ]
			CK_ITEMCON 	:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_ITEMCON") ]
			CK_PROJPMS 	:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_PROJPMS") ]
			CK_EDTPMS 	:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_EDTPMS") ]
			CK_TASKPMS 	:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_TASKPMS") ]
			CK_HORA		:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_HORA") ]
			CK_LINHA 	:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_LINHA") ]
			CK_SETOR	:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_SETOR") ]
			CK_TPEDIDO 	:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_TPEDIDO") ]
			CK_ENTREGA 	:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_ENTREGA") ]	 //GRAVAR LOCAL ENTREGGA
			
			//INCLUIDO EM 01/08/13 p/ gravar a FILIALP DA HONDA mediante reclamação do cliente.
			CK_FILIALP 	:= aRegSCK[ nLinProd, ASCAN(aCabSCK, "CK_FILIALP") ]
			
			CK_NUMSERI 	:= aTotal[nX,6]
			CK_LOTECTL 	:= aTotal[nX,4]
			CK_NUMLOTE 	:= aTotal[nX,5]
			CK_LOCALIZ 	:= GETMV('MV_ENDSEP')
			MsUnlock()
			nItem ++
			If nX <= nQtdItens
				dbSkip()
			Endif
		NEXT
	Endif
	//
	dbSelectArea("SCJ")
	dbSetorder(1)
	dbSeek(xFilial("SCJ")+ cNumOrc)
	RecLock("SCJ", .F.)
	//CJ_STATUS := "A"
	SCJ->CJ_ACDSTAT := "F"
	MsUnlock()
	//
	dbSelectArea("CB0")
	dbSetorder(1)
	For nX := 1 to len(aEtiqueta)
		If dbSeek(xFilial("CB0")+aEtiqueta[nX,2])
			RecLock("CB0",.F.)
			CB0_CLI 		:= Posicione('SCJ', 1, xfilial('SCJ') + cNumOrc  , 'CJ_CLIENTE')
			CB0_LOJACL 	    := Posicione('SCJ', 1, xfilial('SCJ') + cNumOrc  , 'CJ_LOJA')
			CB0->CB0_USUARI := Posicione('CB1', 2, xfilial('CB1') + __cuserid, 'CB1_CODOPE')
			//CB0->CB0_DTAPON := dDatabase
			//CB0->CB0_HRAPON := time()
			CB0->CB0_DTPROC := dDatabase
			CB0->CB0_HRPROC := time()
			CB0->CB0_NUMORC := cNumOrc
			CB0->CB0_LOCALI	:= GETMV('MV_ENDSEP')
			MsUnlock()
		Endif
	Next
Endif
Return(.T.)
//
//
Static Function ValidOrc(cQR)
Local lRet         := .T.
Local nX := 0
//
dbSelectArea("SCJ")
dbSetOrder(1)
If dbSeek(xFilial('SCJ')+ cQr)
	If SCJ->CJ_STATUS $ "AB" .AND. SCJ->CJ_ACDSTAT $ " S"
		dbSelectArea("SCK")
		dbSetOrder(1)
		If dbSeek(xFilial('SCK')+ cQr)
			Do While !Eof() .and. CK_FILIAL+CK_NUM == xFilial('SCK')+ cQr
				aadd( aSCK, {CK_PRODUTO, CK_LOCAL, CK_LOCALIZ, CK_LOTECTL, CK_NUMLOTE, CK_QTDVEN, CK_PEDCLI, CK_ITEM, CK_NUMSERI} )
				If !Empty(CK_LOTECTL)
					lPorLote := .T.
				Endif
				dbSkip()
			Enddo
			If  Len(aSCK) > 0
				aSCK := ASORT(aSCK,,, { |x, y| x[1]+x[7] < y[1]+y[7]  })   //Ordena o vetor por produto +
			Else
				vtbeep(2)
				vtalert('Inconsistencia nos itens da ordem de expedicao!', 'AVISO', .T., 2000)
				lRet := .F.
			Endif
		Else
			vtbeep(2)
			vtalert('Inconsistencia nos itens da ordem de expedicao!', 'AVISO', .T., 2000)
			lRet := .F.
		Endif
	Else
		vtbeep(2)
		vtalert('Ordem de expedicao nao possui ordem de separacao!', 'AVISO', .T., 2000)
		lRet := .F.
	Endif
Else
	vtbeep(2)
	vtalert('Ordem de expedicao nao encontrada!', 'AVISO', .T., 2000)
	lRet := .F.
Endif
Return lRet
//
//
Static Function ValidEndereco(_Local, _Endereco)
Local lRet         := .T.

if  !Empty(cProduto)
	cDescEnd := Posicione('SBE', 1, xfilial('SBE')+ _Local+ _Endereco, 'BE_DESCRIC')
	vtgetrefresh('cDescEnd')
Else
	vtalert('Endereco nao encontrado!', 'AVISO', .T., 2000)
	lRet := .F.
Endif
return lRet
//
//
Static Function Proximo()
If nX <= Len(aSCK)
	If nX == Len(aSCK)
		vtalert("Produto é o último!","AVISO", .t., 2000)
		nX := 0
	Endif
	lProximo := .T.
	VTKeyBoard(chr(27))
Endif
Return
//
//
Static Function ValidEtiqueta()
Local lRet := .F.
Local nQtd :=  0
Local cQr  := cEtiqueta
Local lAchou := .F.
Local _nL
//
dbSelectArea("CB0")
lAchou := dbSeek(xFilial("CB0")+ cQR )
//
If !lAchou
	vtalert('Etiqueta não existe!', 'AVISO', .T., 2000)
	Return(lRet)
Endif
If  (nPos := Ascan(aTmpEtiq, { |x| Alltrim(x[2]) == Alltrim(cQr) }) ) >0  .OR. !Empty(CB0->CB0_NUMORC)
	vtalert('Etiqueta já foi lida!', 'AVISO', .T., 2000)
	Return(lRet)
Endif
If Alltrim(cProduto) <> Alltrim(CB0->CB0_CODPRO)  //Alltrim(Posicione('CB0', 1, xfilial('CB0') + cQR , 'CB0_CODPRO'))
	vtalert('Etiqueta nao pertence a esse produto!', 'AVISO', .T., 2000)
	Return(lRet)
Endif
If nQuantProd == nQuantLida
	vtalert('Quantidade lida já completou a quantidade da ordem de expedicao', .T., 2000)
	Return(lRet)
Endif
If Alltrim(cLocal) <> Alltrim(Posicione('CB0', 1, xfilial('CB0') + cQR , 'CB0_LOCAL'))
	vtalert('Local da etiqueta lida é diferente do local do produto atual !', 'AVISO', .T., 2000)
	Return(lRet)
Endif
//aadd( aSCK, {CK_PRODUTO, CK_LOCAL, CK_LOCALIZ, CK_LOTECTL, CK_NUMLOTE, CK_QTDVEN})
If lPorLote .And. ( nPos := Ascan( aSCK, { |x| Alltrim(x[4]) == Alltrim(Posicione('CB0', 1, xfilial('CB0') + cQR , 'CB0_LOTE'))  } )  ) == 0
	vtalert('Etiqueta nao pertence a nenhum dos lotes contidos nesta ordem de expedicao !', 'AVISO', .T., 2000)
	Return(lRet)
Endif
//aadd( aSCK, {CK_PRODUTO, CK_LOCAL, CK_LOCALIZ, CK_LOTECTL, CK_NUMLOTE, CK_QTDVEN, CK_PEDCLI, CK_ITEM, XCK_NUMSERI} )
If (nPos:=Ascan( aTmpLote, { |x| x[1] == CB0_LOCAL+CB0_LOTE })) >0 .AND. ( aTmpLote[nPos,2] + CB0_QTDE > POSICIONE('SBF', 1, xfilial('SBF') + aSCK[nX,2]+ aSCK[nX,3]+ aSCK[nX,1]+ aSCK[nX,9]+ Substr(aTmpLote[nPos,1],3,10) , 'BF_QUANT') )
	vtalert('2.1 Saldo lote: '+ CB0_LOCAL+ CB0_LOTE +' / '+ ALLTRIM(STR(POSICIONE('SBF', 1, xfilial('SBF') + aSCK[nX,2]+ aSCK[nX,3]+ aSCK[nX,1]+ aSCK[nX,9]+ Substr(aTmpLote[nPos,1],3,10) , 'BF_QUANT'))) +' é insuficiente!', 'AVISO' , .T., 3000)
	Return(lRet)
Endif
If ( nPos := Ascan( aTmpLote, { |x| x[1] == CB0_LOCAL+ CB0_LOTE } )  )  == 0 .AND. CB0_QTDE > POSICIONE('SBF', 1, xfilial('SBF') + aSCK[nX,2]+ aSCK[nX,3]+ aSCK[nX,1]+ aSCK[nX,9]+ CB0_LOTE, 'BF_QUANT')
	vtalert('2.2 Saldo lote: '+ CB0_LOCAL+ CB0_LOTE +' / ' + ALLTRIM(STR(POSICIONE('SBF', 1, xfilial('SBF') + aSCK[nX,2]+ aSCK[nX,3]+ aSCK[nX,1]+ aSCK[nX,9]+ CB0_LOTE , 'BF_QUANT'))) +' é insuficiente!', 'AVISO', .T., 3000)
	Return(lRet)
Endif
If (nPos:=Ascan( aTmpLote, { |x| x[1] == CB0_LOCAL+CB0_LOTE }))> 0 .AND. ( aTmpLote[nPos,2] + CB0_QTDE > (POSICIONE('SBF', 1, xfilial('SBF') + aSCK[nX,2]+ aSCK[nX,3]+ aSCK[nX,1]+ aSCK[nX,9]+ Substr(aTmpLote[nPos,1],3,10) , 'BF_QUANT')-POSICIONE('SDD', 3, xfilial('SDD') + CB0_CODPRO+ CB0_LOTE, 'DD_SALDO') ) )
	vtalert('4.1 Saldo lote BLQ: '+ CB0_LOCAL+ CB0_LOTE +' / '+ ALLTRIM(STR(POSICIONE('SBF', 1, xfilial('SBF') + aSCK[nX,2]+ aSCK[nX,3]+ aSCK[nX,1]+ aSCK[nX,9]+ Substr(aTmpLote[nPos,1],3,10) , 'BF_QUANT'))) +' é insuficiente!', 'AVISO' , .T., 3000)
	Return(lRet)
Endif
If ( nPos := Ascan( aTmpLote, { |x| x[1] == CB0_LOCAL+ CB0_LOTE })) == 0 .AND. CB0_QTDE > ( POSICIONE('SBF', 1, xfilial('SBF') + aSCK[nX,2]+ aSCK[nX,3]+ aSCK[nX,1]+ aSCK[nX,9]+ CB0_LOTE, 'BF_QUANT') - POSICIONE('SDD', 3, xfilial('SDD') + CB0_CODPRO+ CB0_LOTE, 'DD_SALDO'))
	vtalert('4.2 Saldo lote BLQ: '+ CB0_LOCAL+ CB0_LOTE +' / ' + ALLTRIM(STR(POSICIONE('SBF', 1, xfilial('SBF') + aSCK[nX,2]+ aSCK[nX,3]+ aSCK[nX,1]+ aSCK[nX,9]+ CB0_LOTE , 'BF_QUANT'))) +' é insuficiente!', 'AVISO', .T., 3000)
	Return(lRet)
Endif
//
// Check empenho SB8
// Por Alex Almeida Em: 06/05/2013
// aadd( aSCK, {CK_PRODUTO, CK_LOCAL, CK_LOCALIZ, CK_LOTECTL, CK_NUMLOTE, CK_QTDVEN, CK_PEDCLI, CK_ITEM, XCK_NUMSERI} )
// Static Function SB8Empenho(_cLocal, _cProduto, _cLotectl, _nQtde)
//             LOCAL       PRODUTO      LOTECTL      QTDE
//
If ( nPos := Ascan( aTmpLote, { |x| x[1] == CB0_LOCAL+CB0_LOTE })) > 0
	If !SB8Empenho(aSCK[nX,2], aSCK[nX,1], Substr(aTmpLote[nPos,1],3,10), aTmpLote[nPos,2] + CB0_QTDE)
		Return(lRet)
	Endif
Else
	If !SB8Empenho(CB0_LOCAL, CB0_CODPRO, CB0_LOTE, CB0_QTDE)
		Return(lRet)
	Endif
Endif
/*
If POSICIONE('SDD', 3, xfilial('SDD') + CB0_CODPRO+ CB0_LOTE, 'DD_SALDO') > 0 .and. Posicione('SDD', 3, xfilial('SDD') + CB0_CODPRO+ CB0_LOTE, 'DD_SALDO')
vtalert('Lote bloqueado!', 'AVISO', .T., 2000)
Return(lRet)
Endif
*/
//aadd(aTmpEtiq, { cProduto+ cLocal+ cLote+ cPedCli, cEtiqueta, cProduto, cLote, cSLote, cNumSerie, nQtd, cLocal, cPedCli})
//aadd(aTmpEtiq, { CB0_CODPRO+ CB0_LOCAL+ CB0_LOTE+ CB0_PEDCLI, cEtiqueta, CB0_CODPRO, CB0_LOTE, CB0_SLOTE, CB0_NUMSER, CB0_QTDE, CB0_LOCAL, aSCK[nX,7] })
//
//
// ******************** IMPLEMENTAÇÃO P/ OBRIGATORIEDADE DO FIFO ******************************
// EM: 19/08/2013 BY ALEX ALMEIDA
// ********************************************************************************************
aLoteLido  := {}
nLoteAtual := 0
For _nL := 1 to Len(aTmpLote)
	If (nPos:=Ascan( aLoteLido, { |x| x[1] == Substr(aTmpLote[_nL,1],3,10) })) == 0
		aadd(aLoteLido, {Substr(aTmpLote[_nL,1],3,10), aTmpLote[_nL,2]} )
	Else
		aLoteLido[nPos,2] += aTmpLote[_nL,2]
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
cQbFifo := Space(01)
_nL := 1
Do While _nL <= Len(aSaldoFifo)
	
	If (aSaldoFifo[_nL,2]-aSaldoFifo[_nL,3] > 0 .OR. aSaldoFifo[_nL,2]==aSaldoFifo[_nL,3]) .and. Alltrim(CB0->CB0_LOTE) == Alltrim(aSaldoFifo[_nL,1])
		EXIT
		
	ElseIf aSaldoFifo[_nL,2]-aSaldoFifo[_nL,3] > 0
		
		If CB0->CB0_LOTE <> aSaldoFifo[_nL,1] .and. GetMv("MV_AFIFO") //aLoteFifo, { SB8TMP->B8_LOTECTL, SB8TMP->B8_SALDO - SB8TMP->B8_EMPENHO, SB8TMP->D1_DTDIGIT } )
			aTela:=VtSave()
			VtClear
			@ 03,00 vtsay 'Lote FIFO:'+aSaldoFifo[_nL,1]
			@ 04,00 vtsay 'possui saldo: '+Alltrim(Str(aSaldoFifo[_nL,2] - aSaldoFifo[_nL,3]))+' '+POSICIONE("SB1",1,xFilial("SB1")+CB0->CB0_CODPRO,"B1_UM")
			@ 05,00 vtsay "Quebra a seq. FIFO ? "
			@ 06,00 vtsay " (1=S/0=N) "
			@ 06,13 vtget cQbFifo Picture '9' valid cQbFifo $ "01" //when !lProximo //fConfirma(@cQbFifo)
			vtread
			vtClear
			vtrestore(,,,,aTela)
			If cQbFifo == "0"
				Return(lRet)
			Else
				Exit
			Endif
		Endif
	Endif
	_nL ++
Enddo
//
// ******************** IMPLEMENTAÇÃO P/ OBRIGATORIEDADE DO FIFO ******************************
// EM: 19/08/2013 BY ALEX ALMEIDA
// ********************************************************************************************
//
aadd(aTmpEtiq, { CB0_CODPRO+ CB0_LOCAL+ CB0_LOTE+ aSCK[nX,7], cEtiqueta, CB0_CODPRO, CB0_LOTE, CB0_SLOTE, CB0_NUMSER, CB0_QTDE, CB0_LOCAL, aSCK[nX,7], iif(cQbFifo=="1","S","") })
If ( nPos := Ascan( aTmpLote, { |x| x[1] == CB0_LOCAL+CB0_LOTE } ) ) == 0
	aadd(aTmpLote, { CB0_LOCAL+CB0_LOTE, CB0_QTDE } )
Else
	aTmpLote[nPos,2] += CB0_QTDE
Endif
nQuantLida += CB0_QTDE
nQuantEtiq ++
//
vtgetrefresh('nQuantLida')
vtgetrefresh('nQuantEtiq')
//
lRet := .T.
Return lRet
//
//
User Function ACDG03A()
Local aTela      := vtsave()
Local nOpcao     := 0
Local cOPOrigem  := space(10)
Local bkey24
Local nX := 0
Local x 

// Verifica se utiliza controle de transacao.
Private lTTS       := iif(getmv('MV_TTS') == 'S', .T., .F.)
Private cNumOrc := Space(tamsx3('CJ_NUM')[1])
//
Do While .t.
	vtclear
	//
	cNumOrc := Space(tamsx3('CJ_NUM')[1])
	//
	vtreverso(.T.)
	@ 00,02 vtsay 'Ord.Exp. - Estornar Leituras'
	vtreverso(.F.)
	//
	@ 01,00 vtsay 'Ord.Exp:'
	@ 02,00 vtget cNumOrc picture '@!' valid  !empty(cNumOrc) .and. ValidOrc2(cNumOrc)  f3 'SCJ'
	vtread
	If VtLastKey() == 27
		Exit
	Endif
	//
	lQuery 	  := .T.
	aStruCB0  := CB0->(dbStruct())
	cQuery  :=  " SELECT * "
	cQuery  +=  " FROM "+ RETSQLNAME("CB0") + " "
	cQuery  +=  " WHERE CB0_NUMORC = '"+ cNumOrc +"' "
	cQuery  +=  "       AND CB0_DTLEIT <> '' "
	cQuery  +=  "       AND CB0_HRLEIT <> '' "
	cQuery  +=  "       AND CB0_DTPROC  = '' "
	cQuery  +=  "       AND CB0_HRPROC  = '' "
	cQuery  +=  "       AND CB0_ORIGEM = 'SD3' "
	cQuery  +=  "       AND CB0_FILIAL = '"+ XFILIAL("CB0") +"' "
	cQuery  +=  "       AND D_E_L_E_T_ <> '*' "
	cQuery  := ChangeQuery(cQuery)
	//
	If Select("CB0TMP") <> 0
		CB0TMP->(dbCloseArea())
	Endif
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CB0TMP",.T.,.T.)
	For nX := 1 To Len(aStruCB0)
		If ( aStruCB0[nX][2] <> "C" ) .And. FieldPos(aStruCB0[nX][1]) > 0
			TcSetField("CB0TMP",aStruCB0[nX][1],aStruCB0[nX][2],aStruCB0[nX][3],aStruCB0[nX][4])
		EndIf
	Next nX
	//      
	aTmpEtiq := {}
	nRegs := 0
	dbSelectArea("CB0TMP")
	dbGoTop()
	Do While !Eof()
	    aadd(aTmpEtiq, CB0TMP->CB0_CODETI )
		nRegs ++
		dbSkip()
	Enddo
	If nRegs == 0
		VTALERT("Nao existem etiquetas para estorno!","Aviso",.T.,3000,2)
		VTKeyBoard(chr(20))
	Else
		If VTYesNo("Deseja limpar as leituras desta Ord. Exp.?","Aviso" ,.T.)
			
			cListEtiq := ""
			For x := 1 to Len(aTmpEtiq)
				cListEtiq += aTmpEtiq[x] + iif(x<>Len(aTmpEtiq),",","")
			Next
			//
			cListEtiq := fContidoSQL(cListEtiq)			
			//
			cQuery  :=  " UPDATE " + RETSQLNAME("CB0") + " "
			cQuery  +=  " SET CB0_NUMORC = '', CB0_DTLEIT = '', CB0_HRLEIT=''  "
			cQuery  +=  " WHERE CB0_NUMORC = '" + cNumOrc + "' "
			cQuery  +=  "   AND CB0_DTLEIT <> '' "
			cQuery  +=  "   AND CB0_HRLEIT <> '' "
			cQuery  +=  "   AND CB0_DTPROC = '' "
			cQuery  +=  "   AND CB0_HRPROC = '' "
			cQuery  +=  "   AND CB0_ORIGEM = 'SD3' "
			cQuery  +=  "   AND CB0_FILIAL = '"+ XFILIAL("CB0") +"' "
			cQuery  +=  "   AND D_E_L_E_T_ <> '*' "
			TcSqlExec(cQuery)
			TcSqlExec("Commit")     
			
			//
			// ******************** IMPLEMENTAÇÃO P/ OBRIGATORIEDADE DO FIFO ******************************
			// EM: 19/08/2013 BY ALEX ALMEIDA
			// ********************************************************************************************
			// EXCLUIR AS OCORRENCIAS DE FIFO QUANDO FOR ESTORNADA A LEITURA DE ETIQUETAS.
			//                             
			cQuery  :=  " UPDATE " + RETSQLNAME("ZZ3") + " "
			cQuery  +=  " SET D_E_L_E_T_ = '*' "
			cQuery  +=  " WHERE ZZ3_FILIAL = '"+ xFilial("ZZ3") +"' "
			cQuery  +=  "   AND D_E_L_E_T_ <> '*' "
			cQuery  +=  "   AND ZZ3_ETIQ IN (" + cListEtiq      + ") "
			cQuery  +=  "   AND ZZ3_ORIGEM = 'EXP' "
			cQuery  +=  "   AND ZZ3_DTAUT  = '' "
			cQuery  +=  "   AND ZZ3_HRAUT  = '' "
			cQuery  +=  "   AND ZZ3_CODAUT = '' "
			TcSqlExec(cQuery)               
			//
			// ******************** IMPLEMENTAÇÃO P/ OBRIGATORIEDADE DO FIFO ******************************
			// EM: 19/08/2013 BY ALEX ALMEIDA
			// ********************************************************************************************
			//                              			
		Endif
	Endif
	CB0TMP->(dbCloseArea())
Enddo
Return
//
//
Static Function ValidOrc2(cQR)
Local lRet := .T.
//
dbSelectArea("SCJ")
dbSetOrder(1)
If !dbSeek(xFilial('SCJ')+ cQr)
	vtbeep(2)
	vtalert('Ordem de expedicao nao encontrada!', 'AVISO', .T., 2000)
	lRet := .F.
Endif
Return lRet

/*
FUNÇÃO INCLUIDA POR ALEX EM 06/05/13 PARA VERIFICAR LOTES COM EMPENHO
E VALIDAR COM MENSAGEM PARA O USUÁRIO.
*/
Static Function SB8Empenho(_cLocal, _cProduto, _cLotectl, _nQtde)
Local lRet     := .T.
Local aStruSB8 := {}
Local nRegs    := 0
Local nX := 0

//VTALERT("MSG:"+_cLocal+" / "+_cProduto+" / "+_cLotectl+" / "+Alltrim(STR(_nQtde))+"!","Aviso",.T.,5000,2)

aStruSB8 := SB8->(dbStruct())
cQuery  :=  " SELECT SUM(B8_SALDO) AS B8_SALDO, SUM(B8_EMPENHO) AS B8_EMPENHO "
cQuery  +=  " FROM "+ RETSQLNAME("SB8") +" "
cQuery  +=  " WHERE D_E_L_E_T_ <> '*' "
cQuery  +=  "   AND B8_FILIAL  = '"+ XFILIAL("SB8") +"' "
cQuery  +=  "   AND B8_LOCAL   = '"+ _cLocal   +"' "
cQuery  +=  "  	AND B8_PRODUTO = '"+ _cProduto +"' "
cQuery  +=  "   AND B8_LOTECTL = '"+ _cLotectl +"' "
cQuery  +=  "   AND B8_SALDO   > 0 "
cQuery  := ChangeQuery(cQuery)
//
If Select("SB8TMP") <> 0
	SB8TMP->(dbCloseArea())
Endif
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SB8TMP",.T.,.T.)
For nX := 1 To Len(aStruSB8)
	If ( aStruSB8[nX][2] <> "C" ) .And. FieldPos(aStruSB8[nX][1]) > 0
		TcSetField("SB8TMP",aStruSB8[nX][1],aStruSB8[nX][2],aStruSB8[nX][3],aStruSB8[nX][4])
	EndIf
Next nX
//
nRegs := 0
dbSelectArea("SB8TMP")
dbGoTop()
Do While !Eof()
	nRegs ++
	dbSkip()
Enddo
dbGoTop()
If nRegs == 0
	VTALERT("5.1 Lote:"+_cLotectl+" sem regsitros de saldo no KARDEX POR LOTE!","Aviso",.T.,3000,2)
	lRet := .F.
	//VTKeyBoard(chr(20))
Else
	If SB8TMP->B8_SALDO <=  0
		VTALERT("5.3 Lote:"+_cLotectl+" sem saldo!","Aviso",.T.,3000,2)
		lRet := .F.
	ElseIf (SB8TMP->B8_SALDO - SB8TMP->B8_EMPENHO) == 0
		VTALERT("5.4 Lote:"+_cLotectl+" com saldo "+Alltrim(Transform(SB8TMP->B8_EMPENHO,"@E 999,999.99"))+" totalmente empenhado!","Aviso",.T.,4000,2)
		lRet := .F.
	ElseIf (SB8TMP->B8_SALDO - SB8TMP->B8_EMPENHO) > 0 .AND. _nQtde > (SB8TMP->B8_SALDO - SB8TMP->B8_EMPENHO)
		VTALERT("5.5 Lote:"+_cLotectl+" com saldo "+Alltrim(Transform(SB8TMP->B8_EMPENHO,"@E 999,999.99"))+" parcialmente empenhado!","Aviso",.T.,4000,2)
		lRet := .F.
	Endif
Endif
//
SB8TMP->(dbCloseArea())
dbSelectArea("CB0")
//
Return(lRet)
//
//
//
Static Function PegaSaldoFifo()
// ******************** IMPLEMENTAÇÃO P/ OBRIGATORIEDADE DO FIFO ******************************//
// EM: 19/08/2013 BY ALEX ALMEIDA
//
If Select("SBFTMP") <> 0
	SBFTMP->(dbCloseArea())
Endif                    



	cQuery := " SELECT C2_EMISSAO AS DT_ENT, BF_PRODUTO, BF_LOTECTL, SUM(BF_QUANT) AS BF_SALDO, SUM(BF_EMPENHO) AS BF_EMPENHO "
	cQuery += " FROM "+ RETSQLNAME("SBF")+" A INNER JOIN "+ RETSQLNAME("SC2")+" B ON (BF_LOTECTL=C2_NUM+C2_ITEM+RIGHT(C2_SEQUEN,2)) "
	cQuery += " WHERE A.D_E_L_E_T_ <>'*' AND  B.D_E_L_E_T_ <>'*'"
	cQuery += " AND BF_FILIAL ='"+xFilial("SBF")+"'"
	cQuery += " AND C2_FILIAL ='"+xFilial("SC2")+"'"
	cQuery += " AND BF_PRODUTO='"+cProduto+"'"
	cQuery += " AND C2_PRODUTO='"+cProduto+"'"
	cQuery += " AND BF_LOCAL='"+cLocal+"'"
	cQuery += " AND BF_QUANT > 0 "
	cQuery += " GROUP BY C2_EMISSAO, BF_PRODUTO, BF_LOTECTL "
	cQuery += " ORDER BY C2_EMISSAO, BF_PRODUTO, BF_LOTECTL "



cQuery  := ChangeQuery(cQuery)
//
//L
//Else
	
//Endif
cQuery := ChangeQuery(cQuery)
TCQUERY cQuery Alias SBFTMP New
//
aSaldoFifo := {}
dbSelectArea("SBFTMP")
dbgotop()
Do While SBFTMP->(!Eof())
	If SBFTMP->BF_EMPENHO > 0
		vtalert('FF 1. O Lote: '+ SBFTMP->BF_LOTECTL + ' possui empenho de '+Alltrim(Str(SBFTMP->BF_EMPENHO))+', isso compromete o saldo do Lote!', 'AVISO')//, .T., 4000)
	Endif
	//
	If (nPos:=ascan( aSaldoFifo, { |x| x[1] == SBFTMP->BF_LOTECTL })) == 0
		aadd(aSaldoFifo, { SBFTMP->BF_LOTECTL, SBFTMP->BF_SALDO - SBFTMP->BF_EMPENHO, 0, SBFTMP->DT_ENT } )
	Else
		aSaldoFifo[nPos,2] += SBFTMP->BF_SALDO - SBFTMP->BF_EMPENHO
	Endif
	//
	SBFTMP->(dbSkip())
Enddo
SBFTMP->(dbClosearea())
//
// ******************** IMPLEMENTAÇÃO P/ OBRIGATORIEDADE DO FIFO ******************************//
Return
//
//
//
Static Function CheckFifo()
Local lRet := .T.
Local nX := 0

cEtqList := ""
cLotList := ""
For nX := 1 to Len(aEtiqueta)
	cEtqList += aEtiqueta[nX,2]+iif(nX<Len(aEtiqueta),",","")
	cLotList += aEtiqueta[nX,4]+iif(nX<Len(aEtiqueta),",","")
Next
//
cQuery := ""
cQuery += " SELECT * "
cQuery += " FROM "+RetSqlName("ZZ3")+" A "
cQuery += " WHERE A.D_E_L_E_T_<>'*' "
cQuery += " AND ZZ3_FILIAL = '"+xFilial("ZZ3")+"'"
cQuery += " AND ZZ3_ETIQ   IN ("+fContidoSQL(cEtqList)+") "
//cQuery += " AND ZZ3_LOCAL  = '"+aEtiqueta[nX,8]+"' "
//cQuery += " AND ZZ3_LOCALI = '"+aEtiqueta[nX,9]+"' "
cQuery += " AND ZZ3_LOTECT IN ("+fContidoSQL(cLotList)+") "
cQuery += " AND ZZ3_CODAUT = '' "
cQuery += " AND ZZ3_DTAUT  = '' "
cQuery += " AND ZZ3_CODMOT = '' "
//
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"ZZ3QRY",.T.,.T.)
dbgotop()
nRegZZ3 := 0
Do While !Eof()
	nRegZZ3 ++
	dbSkip()
Enddo
If nRegZZ3 > 0
	lRet := .F.
	VTAlert('Existem lotes com quebra de FIFO nao autorizada!','Aviso')
	VTAlert('Transferencia nao realizada!','Aviso')
Endif
//
ZZ3QRY->(dbclosearea())
//
Return(lRet)
//
//
Static Function fContidoSQL(pTexto)
Local cTexto:=""
cTexto:=StrTran(AllTrim(PTexto),".","")
cTexto:="'"+StrTran(cTexto,",","','")+"'"
Return(cTexto)
//
//
User Function ACDG03B()
Local aTela      := vtsave()
Local nOpcao     := 0
Local cOPOrigem  := space(10)
Local bkey24
Local nX := 0
Local x 

// Verifica se utiliza controle de transacao.
Private lTTS       := iif(getmv('MV_TTS') == 'S', .T., .F.)
Private aTmpEtiq   := {}
Private cNumOrc    := Space(tamsx3('CJ_NUM')[1])
Private nQuantLida := 0
Private nQuantEtiq := 0
Private cEtiqueta  := Space(tamsx3('CB0_CODETI')[1])
Private lSair := .F.
Private lFinaliza := .F.
//
//
bKey26 := VTSetKey(26,{|| ACDG03Z()}, "Finaliza" )            // CTRL+Z //"Finaliza"
//
Do While .t.
	vtclear
	//
	cNumOrc := Space(tamsx3('CJ_NUM')[1])
	//
	vtreverso(.T.)
	@ 00,02 vtsay 'Ord.Exp. - Limpa Etiq.'
	vtreverso(.F.)
	//
	@ 01,00 vtsay 'Ord.Exp:'
	@ 02,00 vtget cNumOrc picture '@!' valid  !empty(cNumOrc) .and. ValidOrc2(cNumOrc)  f3 'SCJ'
	vtread
	If VtLastKey() == 27
		Exit
	Endif
	//
	Do While .T.
		//
		cEtiqueta := Space(tamsx3('CB0_CODETI')[1])
		@ 03,00 vtsay 'Qtd.:'
		@ 03,10 vtget nQuantLida picture '@E 999,999.99' when .F.
		@ 05,00 vtsay 'Etiqueta:'
		@ 05,10 vtget cEtiqueta   picture '@!' valid  !Empty(cEtiqueta) .and. ValidEtiq2()  //, cLocal, cEndOri, cEndDes, cProduto) //f3 'SBE' //when .F.
		@ 06,00 vtsay 'Qtd.Etq:'
		@ 06,10 vtget nQuantEtiq picture '@E 999,999.99' when .F.
		vtread
		If VtLastKey() == 27
			If !lFinaliza
				cMensagem := "Deseja sair da rotina ?"
				lVtYesno := VTYesNo(cMensagem,"Aviso" ,.T.)
				If lVtYesNo
					Exit
				Endif
			Else
				Exit
			Endif
		Endif
	Enddo
	//
	If Len(aTmpEtiq) == 0
		If lFinaliza
			VTALERT("Nao existem etiquetas para limpar!","Aviso",.T.,3000,2)
			VTKeyBoard(chr(20))
		Endif
	Else
		If lFinaliza
			cListEtiq := ""
			For x := 1 to Len(aTmpEtiq)
				cListEtiq += aTmpEtiq[x] + iif(x<>Len(aTmpEtiq),",","")
			Next
			//
			cListEtiq := fContidoSQL(cListEtiq)
			//
			If VTYesNo("Deseja limpar as leituras desta Ord. Exp.?","Aviso" ,.T.)
				cQuery  :=  " UPDATE " + RETSQLNAME("CB0") + " "
				cQuery  +=  " SET CB0_NUMORC='', CB0_PEDCLI='', CB0_USUARI='', CB0_DTLEIT='', CB0_HRLEIT=''  "
				cQuery  +=  " WHERE CB0_NUMORC = '" + cNumOrc        + "' "
				cQuery  +=  "   AND CB0_CODETI IN (" + cListEtiq      + ") "
				cQuery  +=  "   AND CB0_FILIAL = '" + xFilial("CB0") + "' "
				cQuery  +=  "   AND D_E_L_E_T_ <> '*' "
				//VTALERT(CQUERY)
				TcSqlExec(cQuery)
				TcSqlExec("Commit")
				//
				ACDG03LOG(cNumOrc, aTmpEtiq)  // LOG DE ATUALIZACAO
				//
			Endif
			aTmpEtiq := {}
			nQuantLida := 0
			nQuantEtiq := 0
			vtgetrefresh('nQuantLida')
			vtgetrefresh('nQuantEtiq')
		Endif
	Endif
Enddo
vtsetkey(26,bkey26)
vtRestore(,,,,aTela)
Return
//
//
//
Static Function ValidEtiq2()
Local lRet := .F.
Local nQtd :=  0
Local cQr  := cEtiqueta
Local lAchou := .F.
//
dbSelectArea("CB0")
lAchou := dbSeek(xFilial("CB0")+ cQR )
//
If !lAchou
	vtalert('Etiqueta não existe!', 'AVISO', .T., 2000)
	Return(lRet)
Endif
//
If  (nPos := Ascan(aTmpEtiq, { |x| Alltrim(x) == Alltrim(cQr) }) ) > 0
	vtalert('Etiqueta já foi lida!', 'AVISO', .T., 2000)
	Return(lRet)
Endif
//
If 	CB0_NUMORC <> cNumOrc
	vtalert('Etiqueta nao pertence a ordem de expedicao!', 'AVISO', .T., 2000)
	Return(lRet)
Endif
//
If 	Alltrim(CB0_LOCALI) <> Alltrim(GETMV("MV_ENDSEP"))
	vtalert('Etiqueta nao esta em separacao!', 'AVISO', .T., 2000)
	Return(lRet)
Endif
//
aadd(aTmpEtiq, cEtiqueta )
//
nQuantLida += CB0_QTDE
nQuantEtiq ++
//
vtgetrefresh('nQuantLida')
vtgetrefresh('nQuantEtiq')
//
lRet := .T.
Return(lRet)
//
//
Static Function ACDG03Z()
If VTYesNo("Deseja estornar as etiquetas ?","Aviso" ,.T.)
	lFinaliza := .T.
	VTKeyBoard(chr(27)) //+chr(83))
Endif
Return
//
//
//
Static Function ACDG03LOG(_cNumOrc, aTmpEtiq)
Local nItens
cArqTxt := Alltrim(_cNumOrc)+"_Log.txt"
nHdl:= msfCreate(cArqTxt,0)
IF nHdl == -1
	//Help(" ",1,"","NAOARQUIVO","Não foi possivel criar arquivo",1,0)
	vtalert("Nao foi possivel criar LOG!")
Else
	cLinha := " " + CHR(13)+CHR(10)
	cLinha += "Log - Estorno de Etiquetas"+" " + CHR(13)+CHR(10)
	cLinha += "Data:    "+dToc(dDatabase)+" " + CHR(13)+CHR(10)
	cLinha += "Hora:    "+Time()         +" " + CHR(13)+CHR(10)
	cLinha += "Usuario: "+cUserName      +" " + CHR(13)+CHR(10)
	cLinha += "========================================================================"+ CHR(13)+CHR(10)
	//
	FWrite(nHdl,cLinha)
	//
	For nItens := 1 to Len(aTmpEtiq)
		cLinha := "Ord.Exp.: "+_cNumOrc+" Etiqueta: "+ aTmpEtiq[nItens] + CHR(13)+CHR(10)
		FWrite(nHdl,cLinha)
	Next
	fClose(nHdl)
	//
Endif
lRet := .F.
Return(lRet)

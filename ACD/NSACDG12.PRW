#include "protheus.ch"
#include "topconn.ch"
#include "apvt100.ch"

Static __nSem:=0

User Function ACDG12()
Local aTela      := vtsave()
Local nOpcao     := 0
Local cOPOrigem  := space(10)
Local bkey24
Local nZ := 0 

// Verifica se utiliza controle de transacao.
Private lTTS       := iif(getmv('MV_TTS') == 'S', .T., .F.)
Private aOP        := {}
Private aSD4 := {}
Private aSCKLOTE := {}
Private aTmpEtiq := {}
Private aTmpLote := {}
Private	aSaldoFifo := {}
Private aEtiqueta := {}
Private cProduto   := space(tamsx3('B1_COD')[1])
Private cDescProd  := space(tamsx3('B1_DESC')[1])
Private cLote      := space(tamsx3('D3_LOTECTL')[1])
Private cNumLote      := space(tamsx3('D3_LOTECTL')[1])
Private nQE        := 0
Private nQuantProd := 0
Private nQuantLida := 0
Private nQuantEtiq := 0
Private cOP := Space(11)
Private cLocal := space(tamsx3('C2_LOCAL')[1])
Private cEtiqueta := Space(10)
Private cLocalOri := space(tamsx3('C2_LOCAL')[1])
Private cEndOri := Space(tamsx3('DB_LOCALIZ')[1])
Private cEndDes := Space(tamsx3('DB_LOCALIZ')[1])
Private cDescEnd  := Space(tamsx3('BE_DESCRIC')[1])
Private cDoc := Space(tamsx3('DA_DOC')[1])
Private cNumSeq := Space(tamsx3('DA_NUMSEQ')[1])
Private cItem := Space(tamsx3('DB_ITEM')[1])
Private cNumOrd := Space(11) //tamsx3('D4_OP')[1])
Private cCont := Space(01)
Private cCont2 := Space(01)
Private nX := 0
Private lPorLote := .F.
Private lSair := .F.
Private lProximo := .F.
Private lSaldo := .T.
Private lTrocaEnd := .F.
Private lLeituraParcial  := .F.
//
bKey05 := VTSetKey(5,{|| TrocaEnd()}, "Troca Endereco")    // CTRL+E //"Troca Endereco"
bKey24 := VTSetKey(24,{|| Proximo()}, "Proximo Produto")     // CTRL+X //"Estorno"
bKey25 := VTSetKey(25,{|| U_ACDG06E()}, "Quebra Etiqueta")   // CTRL+Y //"Quebrar Etiqueta"
//bKey25 := VTSetKey(25,{|| T_ACDV210()}, "Quebra Etiqueta")   // CTRL+Y //"Quebrar Etiqueta"
bKey26 := VTSetKey(26,{|| ACDG12Z()}, "Finaliza" )            // CTRL+Z //"Finaliza"
//
While .t.
	vtclear
	//
	aOP        := {}
	aSD4 := {}
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
	cNumOrd := Space(11) //tamsx3('CJ_NUM')[1])
	cCont := Space(01)
	cCont2 := Space(01)
	lPorLote := .F.
	lSair := .F.
	lSaldo := .T.
	lTrocaEnd := .F.
	lLeituraParcial := .F.
	//
	vtreverso(.T.)
	@ 00,02 vtsay 'Pick List - MAT'
	vtreverso(.F.)
	//
	@ 01,00 vtsay 'Ord.Prd:'
	@ 02,00 vtget cNumOrd picture '@!' valid  !empty(cNumOrd) .and. ValidOrd(cNumOrd)  f3 'SC2'
	vtread
	If VtLastKey() == 27
		Exit
	Endif
	vtclear
	nX := 1
	While  nX <= Len(aSD4)
		cProduto   := aSD4[nX,1]
		cDescProd  := ALLTRIM(Posicione('SB1', 1, xfilial('SB1') +aSD4[nX,1] , 'B1_DESC' ))
		nQuantProd := aSD4[nX,4] //QTD. ORIGINAL
		//
		//aadd( aSCK, {CK_PRODUTO, CK_LOCAL, CK_LOCALIZ, CK_LOTECTL, CK_NUMLOTE, CK_QTDVEN, CK_PEDCLI, CK_ITEM, 0} )
		vtgetrefresh('cProduto')
		vtgetrefresh('cDescProd')
		vtgetrefresh('nQuantProd')
		//
		@ 00,00 vtsay 'Item: '
		@ 00,05 vtget cProduto   picture '@!' when .F.
		@ 01,00 vtsay 'Desc: '
		@ 01,00 vtget cDescProd  picture '@!' when .F.
		@ 02,00 vtsay 'Qtd.Ord.:'
		@ 02,10 vtget nQuantProd picture '@E 999,999' when .F.
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
		cQuery += " WHERE D_E_L_E_T_<>'*' AND CB0_OP= '"+cNumOrd+"' " //AND CB0_PEDCLI='"+Alltrim(aSCK[nX,7])+"' "
		cQuery += " AND CB0_CODPRO='"+Alltrim(aSD4[nX,1])+"' "
		cQuery += " AND CB0_LOCORI<>'' AND CB0_DTLEIT<>'' AND CB0_HRLEIT<>'' "
		cQuery += " ORDER BY CB0_CODPRO, CB0_CODETI "
		cQuery := ChangeQuery(cQuery)
		TCQUERY cQuery Alias CB0TMP New
		dbSelectArea("CB0TMP")
		dbgotop()
		Do While CB0TMP->(!Eof())
			//               01                                                                   02          03          04        05         06          07        08         09          10          11          12 qb fifo
			aadd(aTmpEtiq, { CB0_CODPRO+ CB0_LOCORI+ CB0_LOCALI+ CB0_NUMSER+ CB0_LOTE+ CB0_SLOTE, CB0_CODETI, CB0_CODPRO, CB0_LOTE, CB0_SLOTE, CB0_NUMSER, CB0_QTDE, CB0_LOCAL, CB0_LOCALI, CB0_DTPROC, CB0_HRPROC, "" })
			If Empty(CB0_DTPROC) .and. Empty(CB0_HRPROC)
				If (nPos := Ascan( aTmpLote, { |x| x[1] == CB0_LOCORI+ CB0_LOCALI+  CB0_LOTE } ) ) == 0
					aadd( aTmpLote, { CB0_LOCORI+ CB0_LOCALI+ CB0_LOTE, CB0_QTDE } )
				Else
					aTmpLote[nPos, 2] += CB0_QTDE
				Endif
			Endif
			nQuantLida += CB0_QTDE
			nQuantEtiq ++
			dbSkip()
		Enddo
		CB0TMP->(dbCloseArea())
		//
		nSaldo := 0
		FOR nZ := 1 to Len(aTmpLote)
			// INDICE 1 SBF CHAVE: BF_FILIAL+BF_LOCAL+BF_LOCALIZ+BF_PRODUTO+BF_NUMSERI+BF_LOTECTL+BF_NUMLOTE
			//aadd( aSCK, {CK_PRODUTO, CK_LOCAL, CK_LOCALIZ, CK_LOTECTL, CK_NUMLOTE, CK_QTDVEN, CK_PEDCLI, CK_ITEM, CK_NUMSERI} )
			nSaldo := POSICIONE('SBF', 1, xFilial('SBF')+ substr(aTmpLote[nZ,1],01,17)+aSD4[nX,1]+Space(20)+substr(aTmpLote[nZ,1],18,10)  , 'BF_QUANT')
			If aTmpLote[nZ,2] > nSaldo
				vtalert('1. Saldo do lote.: '+ substr(aTmpLote[nZ,1],01,17)+aSD4[nX,1]+Space(20)+substr(aTmpLote[nZ,1],18,10) +' / '+ ALLTRIM(STR(nSaldo)) +' � insuficiente  !', 'AVISO') // , .T., 2000)
				lSaldo := .F.
			Endif
		NEXT
		//
		aTela := VTSave()
		lSair := .F.
		While  nX <= Len(aSD4)  .And. nQuantLida < nQuantProd .And. !lSair .And. !lProximo
			
			@ 03,00 vtsay 'Qtd.:'
			@ 03,10 vtget nQuantLida picture '@E 999,999' when .F.
			//
			@ 04,00 vtsay 'End.: '
			@ 04,05 vtget cLocalOri picture '@!' valid !Empty(cLocalOri) .and. existcpo('SBE', cLocalOri)
			@ 04,07 vtsay '.'
			@ 04,08 vtget cEndOri picture '@!' valid iif(!Empty(cEndOri),ValidEnd(),.T.) F3 "SBE"
			vtread
			If VtLastKey() == 27 .and. !lSair
				cCont := Space(01)
				aTelaPerg := VTSave()
				VTClear()
				//
				cMensagem := ""
				If lProximo
					cMensagem := "Deseja passar para o proximo produto ?"
					cCont := '1'
				Else
					cMensagem := "Deseja sair da rotina ?"
				Endif
				//
				If VTYesNo(cMensagem,"Aviso" ,.T.)
					If Len(aTmpEtiq) > 0
						While !lSair
							@ 03,00 vtsay ' Salvar  etiquetas   '
							@ 04,00 vtsay ' lidas? (1=S/0=N)   '
							@ 05,10 vtget cCont 	Picture '9' valid cCont $ "01" when !lProximo //fConfirma(@cCont)
							vtread
							If cCont $ "01"
								If cCont == "1"
									For nZ := 1 to Len(aTmpEtiq)
										dbSelectArea("CB0")
										CB0->(dbSeek(xFilial("CB0")+ aTmpEtiq[nZ,2]))
										If Empty(CB0->CB0_DTPROC) .AND. Empty(CB0->CB0_HRPROC) .AND. Alltrim(CB0->CB0_LOCALI) <> Alltrim(GETMV("MV_ENDSEP2"))
											RecLock("CB0", .F.)
											CB0->CB0_OP     := cNumOrd
											CB0->CB0_LOCORI := cLocalOri
											CB0->CB0_LOCALI := cEndOri
											CB0->CB0_USUARI := CB1->CB1_CODOPE
											CB0->CB0_DTLEIT := dDatabase
											CB0->CB0_HRLEIT := Time()
											MsUnlock()
										Endif
										//
										If aTmpEtiq[nZ,12] == "S"
											U_LogQuebraFifo(CB0->CB0_CODPRO, CB0->CB0_LOCAL, CB0->CB0_LOCALI, CB0->CB0_LOTE, CB0->CB0_SLOTE, CB0->CB0_QTDE, CB0->CB0_CODETI, "", "", "", "CB0", CB0->CB0_OP)
										Endif
										//
									Next
								Endif
								aTmpEtiq := {}
								//vtRestore(,,,,aTela)
								lSair := .T.
								Exit
							Else
								//Alterado by alex em 29/08/2013
								//aTmpEtiq := {}
								//vtRestore(,,,,aTela)
								//lSair := .T.
								//Exit
							Endif
						Enddo
						//aTmpEtiq := {}
						//vtRestore(,,,,aTela)
						//lSair := .T.
					Else
						cCont := Space(01)
						//VTClear()
						While !lSair .and. !lProximo
							@ 03,00 vtsay 'Abandonar? (1=S/0=N)'
							@ 04,00 vtsay '                    '
							@ 05,10 vtget cCont 	Picture '9' valid cCont $ "01" when !lProximo //fConfirma(@cCont)
							vtread
							If cCont $ "01"
								If cCont == "1"
									lSair := .T.
									aTmpEtiq := {}
								Endif
								Exit
							Endif
						Enddo
						vtRestore(,,,,aTela)
						If cCont == "0"
							cLocalOri := space(tamsx3('C2_LOCAL')[1])
							cEndOri := Space(tamsx3('DB_LOCALIZ')[1])
							vtgetrefresh('cLocalOri')
							vtgetrefresh('cEndOri')
							Loop
						Endif
					Endif
				Else
					vtRestore(,,,,aTelaPerg)
					//lSair := .F.
					//lProximo := .F.
				Endif
			Else
				If Empty(cLocalOri) .or. Empty(cEndOri)
					vtalert('Informar o local e o endere�o!', 'AVISO' , .T., 2000)
					Loop
				Endif
			Endif
			//
			// CUSTOMIZA��O FIFO
			If !Empty(cLocalOri) .and. !Empty(cEndOri)
				aSaldoFifo := {}
				PegaSaldoFifo()
			Endif
			// CUSTOMIZA��O FIFO
			//
			aTelaEnd := VTSave()
			lTrocaEnd := .F.
			//While  nX <= Len(aSD4)  .And. nQuantLida < nQuantProd .And. !lSair .And. !lTrocaEnd .and. VtLastkey() <> 27
			Do While  nX <= Len(aSD4)  .And. nQuantLida < nQuantProd .And. !lSair .And. !lProximo .and. !lTrocaEnd		//.And. VtLastkey() <> 27
				cEtiqueta := Space(10)
				//
				@ 03,10 vtget nQuantLida picture '@E 999,999' when .F.
				@ 05,00 vtsay 'Etiqueta:'
				//@ 05,10 vtget cEtiqueta picture '@!' valid  !lTrocaEnd .and. !Empty(cEtiqueta) .and. ValidEtiqueta()  //, cLocal, cEndOri, cEndDes, cProduto) //f3 'SBE' //when .F.
				@ 05,10 vtget cEtiqueta picture '@!' valid  !Empty(cEtiqueta) .and. ValidEtiqueta()  //, cLocal, cEndOri, cEndDes, cProduto) //f3 'SBE' //when .F.
				@ 06,00 vtsay 'Qtd.Etq:'
				@ 06,10 vtget nQuantEtiq picture '@E 999,999' when .F.
				vtread
				//If VtLastkey() == 27
				//	Exit
				//	Endif
				//Enddo
				If VtLastKey() == 27 .and. !lSair
					cCont := Space(01)
					aTelaEtq := VTSave()
					VTClear()
					cMensagem := ""
					If lProximo
						cMensagem := "Deseja passar para o proximo produto ?"
						cCont := '1'
					ElseIf lTrocaEnd
						cMensagem := "Deseja trocar o endereco ?"
					Else
						cMensagem := "Deseja sair da rotina ?"
					Endif
					If VTYesNo(cMensagem,"Aviso" ,.T.)
						If Len(aTmpEtiq) > 0
							While !lSair
								@ 03,00 vtsay ' Salvar  etiquetas   '
								@ 04,00 vtsay ' lidas? (1=S/0=N)   '
								@ 05,10 vtget cCont 	Picture '9' 	valid cCont $ "01" when !lProximo //fConfirma(@cCont)
								vtread
								If VTLastkey() == 27
									//aTmpEtiq := {}
									//vtRestore(,,,,aTela)
									//lSair := .T.
									Exit
								Endif
								If cCont $ "01"
									If cCont == "1"
										For nZ := 1 to Len(aTmpEtiq)
											dbSelectArea("CB0")
											CB0->(dbSeek(xFilial("CB0")+ aTmpEtiq[nZ,2]))
											If Empty(CB0->CB0_DTPROC) .AND. Empty(CB0->CB0_HRPROC) .AND. Alltrim(CB0->CB0_LOCALI) <> Alltrim(GETMV("MV_ENDSEP2"))
												RecLock("CB0", .F.)
												CB0->CB0_OP     := cNumOrd
												CB0->CB0_LOCORI := cLocalOri
												CB0->CB0_LOCALI := cEndOri
												CB0->CB0_USUARI := CB1->CB1_CODOPE
												CB0->CB0_DTLEIT := dDatabase
												CB0->CB0_HRLEIT := Time()
												MsUnlock()
											Endif
											If aTmpEtiq[nZ,12] == "S"
												U_LogQuebraFifo(CB0->CB0_CODPRO, CB0->CB0_LOCAL, CB0->CB0_LOCALI, CB0->CB0_LOTE, CB0->CB0_SLOTE, CB0->CB0_QTDE, CB0->CB0_CODETI, "", "", "", "CB0", CB0->CB0_OP)
											Endif
										Next
									Endif
									//aTmpEtiq := {}
									//vtRestore(,,,,aTela)
									lSair := .T.
									Exit
								Endif
							Enddo
						Endif
					Else
						vtRestore(,,,,aTelaEtq)
						lSair := .F.
						lProximo := .F.
						lTrocaEnd := .F.
					Endif
				Else
					//hoje
				EndIf
				vtgetrefresh('nQuantLida')
				vtgetrefresh('nQuantEtiq')
			Enddo
			// Incluido em 04/09/13
			If lTrocaEnd
				lTrocaEnd := .F.
				lSair := .F.
				vtRestore(,,,,aTelaEnd)
				cLocalOri := space(tamsx3('C2_LOCAL')[1])
				cEndOri := Space(tamsx3('DB_LOCALIZ')[1])
				vtgetrefresh('cLocalOri')
				vtgetrefresh('cEndOri')
			Endif
		Enddo
		If !lProximo
			//If  nQuantLida == nQuantProd .and. Len(aTmpEtiq) > 0 // atualizar as etiquetas quando atingir a quantidade do or�amento.
			If  (nQuantLida == nQuantProd .and. Len(aTmpEtiq) > 0) .or. (lSair .and. Len(aTmpEtiq) > 0)
				//vtalert(str(nx))
				//vtmsg('Atualizando endereco de etiquetas lidas')
				For nZ := 1 to Len(aTmpEtiq)
					If (nPos := Ascan( aEtiqueta, { |x| x[2] == aTmpEtiq[nZ,2] } ) ) == 0
						aadd(aEtiqueta, aTmpEtiq[nZ])
					Endif
					CB0->(dbSeek(xFilial("CB0")+ aTmpEtiq[nZ,2]))
					If Empty(CB0->CB0_DTPROC) .AND. Empty(CB0->CB0_HRPROC) .AND. Alltrim(CB0->CB0_LOCALI) <> Alltrim(GETMV("MV_ENDSEP2"))
						RecLock("CB0", .F.)
						CB0->CB0_OP := cNumOrd
						CB0->CB0_LOCORI := aTmpEtiq[nZ,8]
						CB0->CB0_LOCALI := aTmpEtiq[nZ,9]
						CB0->CB0_USUARI := CB1->CB1_CODOPE
						CB0->CB0_DTLEIT := dDatabase
						CB0->CB0_HRLEIT := Time()
						MsUnlock()
					Endif
					If aTmpEtiq[nZ,12] == "S"
						U_LogQuebraFifo(CB0->CB0_CODPRO, CB0->CB0_LOCAL, CB0->CB0_LOCALI, CB0->CB0_LOTE, CB0->CB0_SLOTE, CB0->CB0_QTDE, CB0->CB0_CODETI, "", "", "", "CB0", CB0->CB0_OP)
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
		//
		nX ++
		lLeituraParcial := .F.
		//VTALERT(STR(NX))
		If nX > Len(aSD4)
			//aadd( aSD4, {D4_COD, D4_LOCAL, D4_DATA, D4_QTDEORI, D4_QUANT, D4_LOTECTL,D4_NUMLOTE} )
			//aadd(aTmpEtiq, { cProduto+ cLocal+ cLote+ cPedCli, cEtiqueta, cProduto, cLote, cSLote, cNumSerie, nQtd, cLocal, cPedCli})
			//                                                                                                                                                          1           2                         3               4                     5                      6                7                    8              9
			//aadd(aTmpEtiq, { CB0_CODPRO+ CB0_LOCORI+ CB0_LOCALI+ CB0_NUMSER+ CB0_LOTE+ CB0_SLOTE, CB0_CODETI, CB0_CODPRO, CB0_LOTE, CB0_SLOTE, CB0_NUMSER, CB0_QTDE, CB0_LOCAL, CB0_LOCALI })
			aEtiqueta := ASORT(aEtiqueta,,, { |x, y| x[3]+x[8]+x[9] < y[3]+x[8]+y[9] })   //Ordena o vetor por produto + local+ lote+ LOCALI
			//			vtalert(str(len(aetiqueta)))
			nY := 1
			_Save := VTSAVE()
			VTClear()
			VTaLERT('Analisando leitura por item ...',"TOTALIZANDO", .T., 1000)  //'Aguarde...'
			Do While nY <= LEN(aSD4)
				If (nPos := Ascan( aEtiqueta, { |x| x[3] == aSD4[nY,1] } ) ) > 0
					_Qtde := 0
					_Produto := aEtiqueta[nPos,3]
					Do While nPos <= Len(aEtiqueta) .and. _Produto == aEtiqueta[nPos,3] //.and. _PedCli == aEtiqueta[nPos,9]
						_Qtde += aEtiqueta[nPos,7]
						nPos++
					Enddo
					If _Qtde < aSD4[nY,4] //aSD4[nY,5]
						VTAlert("Existem itens com leitura incompleta!","Aviso", .T.,3000 )
						//nX := 1
						//lSair := .F.
						lLeituraParcial := .T.
						Exit
					Endif
				Else
					VTAlert("Existem itens faltando leitura!","Aviso" ,.T.,3000)
					//nX := 1
					//lSair := .F.
					lLeituraParcial := .T.
					Exit
				Endif
				nY++
			Enddo
			vtRestore(,,,, _Save)
		Endif
	Enddo
	//
	If lLeituraParcial
		If VTYesNo("Itens com leitura incompleta ou faltando! Deseja Prosseguir ?","Aviso" ,.T.)
			lLeituraParcial := .F.
		Endif
	Endif
	//
	If  nX > Len(aSD4) .and. lSaldo .and. !lLeituraParcial
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
					Transferencia()  // transfere entre endere�os
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
			vtalert('Abandonando separacao!!', 'AVISO', .T., 3000)
		Endif
		Exit
	Else
		vtalert('Abandonando separacao!!', 'AVISO', .T., 3000)
		Exit
	Endif
Enddo
vtsetkey(5,bkey05)
vtsetkey(24,bkey24)
vtsetkey(25,bkey25)
vtsetkey(26,bkey26)
Return
//
//
Static Function Transferencia()
Local aSave
Local nX
Local aTransf:={}
Local dValid
Local cDoc       := ""
Local aNumSeqSD3 := {}
Local nPos   := 0
Local aEtiqBkp := {}
Private aTotal := {}
Private aMov := {}
Private nModulo := 4

aSave := VTSAVE()
VTClear()
VTalert('Totalizando lote(s) ...','Movimenta��o',.t.,2000)  //'Aguarde...'
//
//aadd(aTmpEtiq, { cProduto+ cLocal+ cLote+ cPedCli, cEtiqueta, cProduto, cLote, cSLote, cNumSerie, nQtd, cLocal, cPedCli })
//                 1                                                                    2           3           4         5          6           7         8          9
//aadd(aTmpEtiq, { CB0_CODPRO+ CB0_LOCORI+ CB0_LOCALI+ CB0_NUMSER+ CB0_LOTE+ CB0_SLOTE, CB0_CODETI, CB0_CODPRO, CB0_LOTE, CB0_SLOTE, CB0_NUMSER, CB0_QTDE, CB0_LOCAL, CB0_LOCALI })
aEtiqueta := ASORT(aEtiqueta,,, { |x, y| x[1] < y[1] })   //Ordena o vetor por produto + lote
For nX := 1 to Len(aEtiqueta)
	CB0->(dbSeek(xFilial("CB0")+ aEtiqueta[nX,2]))
	If Empty(CB0->CB0_DTPROC) .AND. Empty(CB0->CB0_HRPROC) .AND. Alltrim(CB0->CB0_LOCALI) <> Alltrim(GETMV("MV_ENDSEP2"))
		nPos := Ascan(aTotal, {|x| x[1] == aEtiqueta[nX,1]})
		If nPos  == 0
			aadd( aTotal, { aEtiqueta[nX,1], aEtiqueta[nX,2], aEtiqueta[nX,3], aEtiqueta[nX,4], aEtiqueta[nX,5], aEtiqueta[nX,6], aEtiqueta[nX,7], aEtiqueta[nX,8], aEtiqueta[nX,9] } )
		Else
			aTotal[nPos,7] += aEtiqueta[nX,7]
		Endif
	Endif
Next
//
If Len(aTotal) == 0
	VTClear()
	VTalert('Nao foram detectadas novas leituras','Aviso',.t.,2000)  //'Aguarde...'
	Return(.F.)
Endif
//
/*
For nX := 1 to Len(aEtiqueta)
nPos := Ascan(aMov, {|x| x[1] == aEtiqueta[nX,1] })
If nPos  == 0
aadd( aMov, { aEtiqueta[nX,1], "", aEtiqueta[nX,3], aEtiqueta[nX,4], "", "", aEtiqueta[nX,7], aEtiqueta[nX,8], "" } )
Else
aMov[nPos,7] += aEtiqueta[nX,7]
Endif
Next
*/
aEtiqBkp  := aEtiqueta
aEtiqueta := aTotal
//
lMsErroAuto := .F.
lMsHelpAuto := .T.
aTransf := Array(Len(aEtiqueta)+1)
aTransf[1] := {"",dDataBase}
//
// ***************** IMPLEMENTA��O P/ BLOQUEAR MOV. DE ITEM DESBALANCEADO *********************
// EM: 10/11/2014 BY ALEX ALMEIDA
// ********************************************************************************************
//
For nX := 1 to Len(aEtiqueta)
	//
	_cCodOrig := aEtiqueta[nX,3]
	_cLocOrig := aEtiqueta[nX,8]
	//
	ContLote  := Posicione("SB1",1,xFilial("SB1")+_cCodOrig,"B1_RASTRO")
	If ContLote <> 'N' .and. Upper(Alltrim(GETMV("MV_CHKB8BF"))) == "S"
		If u_CheckB8BF(_cCodOrig, _cLocOrig)
			//
			VTALERT("Item "+Alltrim(Str(nX))+" o saldo do item origem "+_cCodOrig+"-"+_cLocOrig+" Kardex x Lote x Endere�o encontra-se desbalanceado para que a movimenta��o seja realizada � necess�rio balancear o saldo do item!","NSACDG06 - Bloqueio")
			//
		Endif
	Endif
Next
//
// ***************** IMPLEMENTA��O P/ BLOQUEAR MOV. DE ITEM DESBALANCEADO *********************
// EM: 10/11/2014 BY ALEX ALMEIDA
// ********************************************************************************************
//
For nX := 1 to Len(aEtiqueta)
	//nSD4 := Ascan(aSD4, {|x| x[1] == aMov[nX,3]})
	//
	nSaldo := 0
	lSaldo := .T.
	//	aadd(aTmpEtiq, { cProduto+ cLote+ cSLote, cEtiqueta, cProduto, cLote, cSLote, cNumSerie, nQtd})
	// FILIAL + LOCAL + LOCALIZACAO + PRODUTO + NUMSERI + LOTECTL + NUMLOTE
	//                                                                                                                                                    1               2                          3               4                  5                      6                        7              8                9
	//aadd(aTmpEtiq, { CB0_CODPRO+ CB0_LOCORI+ CB0_LOCALI+ CB0_NUMSER+ CB0_LOTE+ CB0_SLOTE, CB0_CODETI, CB0_CODPRO, CB0_LOTE, CB0_SLOTE, CB0_NUMSER, CB0_QTDE, CB0_LOCAL, CB0_LOCALI })
	nSaldo := POSICIONE('SBF', 1, xfilial('SBF') + aEtiqueta[nX,8]+ aEtiqueta[nX,9]+ aEtiqueta[nX,3]+ aEtiqueta[nX,6]+ aEtiqueta[nX,4] , 'BF_QUANT')
	If aEtiqueta[nX,7] > nSaldo
		VTALERT( aEtiqueta[nX,1]+" / "+ALLTRIM(STR(nSaldo))+ " n�o possui saldo suficiente no endereco: " +aEtiqueta[nX,8]+ aEtiqueta[nX,9] ,"ERRO")   //,.T.,2000,3) //"Falha na gravacao da transferencia"###"ERRO"
		lSaldo := .F.
	Endif
	If !lSaldo
		VTALERT("Abandonando a separacao por falta de saldo!!!!","AVISO")
		Return(.F.)
	Endif
	//
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+aEtiqueta[nX,3]))
	If SB1->B1_RASTRO   == "L"   //Rastro(aLista[nI,1])
		//FILIAL + PRODUTO + LOCAL + LOTECTL + NUMLOTE + DT VALID
		dValid := Posicione('SB8', 3, xfilial('SB8') +aEtiqueta[nX,3]+ aEtiqueta[nX,8]+ aEtiqueta[nX,4]+ aEtiqueta[nX,5] , 'B8_DTVALID')  //SB8->B8_DTVALID
	Else
		dValid := dDatabase + SB1->B1_PRVALID
	EndIf
	// aadd( aSCK, {CK_PRODUTO, CK_LOCAL, CK_LOCALIZ, CK_LOTECTL, CK_NUMLOTE, CK_QTDVENI})
	//	aadd(aTmpEtiq, { cProduto+ cLocal+ cLote+ cSLote, cEtiqueta, cProduto, cLote, cSLote, cNumSerie, nQtd})
	//                                                                                                                                                    1               2                          3               4                  5                      6                        7              8                9
	//aadd(aTmpEtiq, { CB0_CODPRO+ CB0_LOCORI+ CB0_LOCALI+ CB0_NUMSER+ CB0_LOTE+ CB0_SLOTE, CB0_CODETI, CB0_CODPRO, CB0_LOTE, CB0_SLOTE, CB0_NUMSER, CB0_QTDE, CB0_LOCAL, CB0_LOCALI })
	//VTALERT(aEtiqueta[nX,8]+aEtiqueta[nX,9]+"/"+aEtiqueta[nX,8]+GETMV("MV_ENDSEP2")+"/"+aEtiqueta[nX,1]+"/"+str(aEtiqueta[nX,7]))
	//VTALERT(aEtiqueta[nX,8]+aEtiqueta[nX,9]+"/"+aEtiqueta[nX,8]+GETMV("MV_ENDSEP2")+"/"+aEtiqueta[nX,2]+"/"+str(aEtiqueta[nX,7]))
	
	aTransf[nX+1] := {	SB1->B1_COD,;
	SB1->B1_DESC,;
	SB1->B1_UM,;
	aEtiqueta[nX,8],;  //aSCK[nSCK ,2],;  	//aLista[nI,3],;  //armazen origem
	aEtiqueta[nX,9],;  //aSCK[nSCK ,3],;	//aLista[nI,4],;  // endereco origem
	SB1->B1_COD,;
	SB1->B1_DESC,;
	SB1->B1_UM,;
	aEtiqueta[nX,8],;  //aSCK[nSCK ,2],; 		//cArmDes,;
	GETMV("MV_ENDSEP2"),; 			//cEndDes,;  //Endereco de destino
	aEtiqueta[nX,6],;  //aMov[nX,6],;  	     //aLista[nI,7],;    	//NUMSER
	aEtiqueta[nX,4],;  //aMov[nX,4],;		 //aLista[nI,5],;       //lote
	aEtiqueta[nX,5],;  //aMov[nX,5],;		 //aLista[nI,6],;	    //sublote
	dValid,;
	criavar("D3_POTENCI"),;
	aEtiqueta[nX,7],;  //aMov[nX,7],; 		            //aLista[nI,2],;  // QTDE
	criavar("D3_QTSEGUM"),;
	criavar("D3_ESTORNO"),;
	criavar("D3_NUMSEQ"),;
	aEtiqueta[nX,4],;  //aMov[nX,5],; 		//aLista[nI,5],;
	dValid,;
	criavar("D3_ITEMGRD"),;
	criavar("D3_OBSERVA") }

/*
criavar("D3_ITEMGRD"),;
	criavar("D3_IDDCF"),;
	criavar("D3_OBSERVA"),;
	criavar("D3_CODSAF") }
*/


Next
//
Begin Transaction
MSExecAuto( {|x| MATA261(x)}, aTransf )
//
If lMsErroAuto
	VTALERT("Falha na gravacao da transferencia","ERRO",.T.,2000,3) //"Falha na gravacao da transferencia"###"ERRO"
	DisarmTransaction()
	Break
EndIf
End Transaction
//
If	lMsErroAuto
	VTDispFile(NomeAutoLog(),.t.)
Endif
//
//If	lMsErroAuto
//	VTDispFile(NomeAutoLog(),.t.)
//endif
//

aEtiqueta := aEtiqBkp

If !lMsErroAuto
	//
	VTCLEAR()
	VTMSG('Atualizando inf. etiquetas ...' ,1)
	//
	dbSelectArea("CB0")
	dbSetorder(1)
	For nX := 1 to len(aEtiqueta)
		If dbSeek(xFilial("CB0")+aEtiqueta[nX,2])
			If Empty(CB0->CB0_DTPROC) .AND. Empty(CB0->CB0_HRPROC) .AND. Alltrim(CB0->CB0_LOCALI) <> Alltrim(GETMV("MV_ENDSEP2"))
				RecLock("CB0",.F.)
				CB0->CB0_OP     := cNumOrd
				CB0->CB0_LOCORI := aEtiqueta[nX,8]
				CB0->CB0_LOCALI := GETMV("MV_ENDSEP2")
				CB0->CB0_USUARI := CB1->CB1_CODOPE
				CB0->CB0_DTPROC := DDATABASE
				CB0->CB0_HRPROC := TIME()
				//CB0_NUMORC 	:= cNumOrc
				MsUnlock()
			Endif
		Endif
	Next
Endif
Return(.T.)
//
//
Static Function ValidOrd(cQR)
Local lRet         := .T.
Local nX := 0
Local aZonas := {}
Local aTmpSD34 := {}
Local nRet := 0
//
//
//vtalert(__cuserid, 'AVISO', .T., 2000)
dbSelectArea('CB1')
dbsetorder(2)
dbSeek(xFilial("CB1")+__cUserId)
cCodOpe := CB1_CODOPE
//
//cGrupo := "MPI "
//
dbSelectArea("SZV")
dbsetorder(1)
dbSeek(xFilial()+ cCodOpe)
aZonas := {}
Do While !Eof() .and. ZV_CODUSU == cCodOpe
	aadd( aZonas, ZV_CODZON)
	dbSkip()
Enddo
//
dbSelectArea("SB1")
dbsetorder(1)
//
dbSelectarea("DCH")
dbsetorder(1)
//
dbSelectArea("SC2")
dbSetOrder(1)
If dbSeek(xFilial('SC2')+ cQr)
	//
	If Empty(SC2->C2_DATRF)
		//
		dbSelectArea("SD4")
		dbSetOrder(2)
		If dbSeek(xFilial('SD4')+ cQr)
			Do While !Eof() .and. D4_FILIAL+substr(D4_OP,1,11) == xFilial('SD4')+ cQr
				//
				cCodItem := SD4->D4_COD
				dbselectarea("SB1")
				If dbSeek(xFilial()+ cCodItem) .and. SB1->B1_SLDPL=='S'
					dbSelectarea("DCH")
					dbsetorder(1)
					If dbSeek(xFilial()+cCodItem)
						nRet := 0
						aTmpSD4 := {}
						Do While !Eof() .and. DCH_FILIAL+DCH_CODPRO == xFilial()+cCodItem .and. nRet == 0
							nRet := ascan( aZonas, DCH_CODZON )
							If nRet > 0
								aadd( aTmpSD4, {SD4->D4_COD, SD4->D4_LOCAL, SD4->D4_DATA, SD4->D4_QTDEORI, SD4->D4_QUANT, SD4->D4_LOTECTL, SD4->D4_NUMLOTE} )
							Endif
							dbSkip()
						Enddo
						If Len(aTmpSD4) > 0
							aadd( aSD4, aTmpSD4[1] )
						Else
							//vtalert('Item '+SD4->D4_COD+' n�o pertence a ZONA deste usuario !', 'AVISO') // , .T., 2000)
						Endif
					Else
						vtalert('Item '+SD4->D4_COD+' n�o possui ZONA cadastrada !', 'AVISO') // , .T., 2000)
					Endif
				Endif
				//
				dbselectarea("SD4")
				dbSkip()
			Enddo
			If  Len(aSD4) > 0
				aSD4 := ASORT(aSD4,,, { |x, y| x[1] < y[1] })   //Ordena o vetor por produto +
			Else
				vtbeep(2)
				vtalert('Nao foram encontrados itens no empenho desta O.P.! para a Zona deste operador!', 'AVISO', .T., 3000)
				lRet := .F.
			Endif
		Else
			vtbeep(2)
			vtalert('N�o foi achado lista de empenho da O.P.'+ cQR +'!', 'AVISO', .T., 3000)
			lRet := .F.
		Endif
	Else
		vtbeep(2)
		vtalert('Ordem de produ��o j� encerrada '+ cQR +'!', 'AVISO', .T., 3000)
		lRet := .F.
	Endif
Else
	vtbeep(2)
	vtalert('Ordem de produ��o n�o encontrada '+ cQR +'!', 'AVISO', .T., 3000)
	lRet := .F.
Endif
Return lRet
//
//
Static Function ValidEndereco(_Local, _Endereco)
Local lRet         := .T.
//
If  !Empty(cProduto)
	cDescEnd := Posicione('SBE', 1, xfilial('SBE')+ _Local+ _Endereco, 'BE_DESCRIC')
	vtgetrefresh('cDescEnd')
Else
	vtalert('Endereco nao encontrado!', 'AVISO', .T., 3000)
	lRet := .F.
Endif
return lRet
//
//
Static Function Proximo()
If nX <= Len(aSD4)
	If nX == Len(aSD4)
		vtalert("Produto � o �ltimo!","AVISO", .t., 2000)
		nX := 0
	Endif
	lProximo := .T.
	VTKeyBoard(chr(27))
Endif
Return
//
//
Static Function ValidEtiqueta()
Local lRet         := .F.
Local nQtd			:=  0
Local cQr := cEtiqueta
Local lAchou := .F.
Local _nL := 0 

//
dbSelectArea("CB0")
lAchou := dbSeek(xFilial("CB0")+ cQR )
//
If !lAchou
	vtalert('Etiqueta n�o existe!', 'AVISO', .T., 2000)
	Return(lRet)
Endif
If  (nPos := Ascan(aTmpEtiq, { |x| Alltrim(x[2]) == Alltrim(cQr) }) ) >0  //.OR. !Empty(CB0->CB0_OP)
	vtalert('Etiqueta j� foi lida!', 'AVISO', .T., 2000)
	Return(lRet)
Endif
If Alltrim(cProduto) <> Alltrim(CB0->CB0_CODPRO)  //Alltrim(Posicione('CB0', 1, xfilial('CB0') + cQR , 'CB0_CODPRO'))
	vtalert('Etiqueta nao pertence a esse produto!', 'AVISO', .T., 2000)
	Return(lRet)
Endif
/*
//Inclui a valida��o do FIFO /////
//Inclus�o feita as  25/09/2012 - Aglair Brito Ishii
//aadd(aTmpLote, { cLocalOri+ cEndOri+CB0_LOTE, CB0_QTDE } )
LoteFIFO:=u_ChecaLote(cProduto,cLocalOri)  //Fun��o que retorna o lote do FIFO
NrLoteFifo:=substr(LoteFiFo,1,4)+' '+substr(LoteFiFo,5,6)
NrLoteAtu:=substr(CB0->CB0_LOTE,1,4)+' '+substr(CB0->CB0_LOTE,5,6)

dbSelectArea("CB0")
If GetMv("MV_AFIFO") .and. Alltrim(CB0->CB0_LOTE)#Alltrim(LoteFifo)    //Se a Mensagem de alerta do Fifo deve aparecer no coletor
If (nPos:=Ascan( aTmpLote, { |x| substr(x[1],1,2)+substr(x[1],17,6)  == cLocalOri+LoteFIFO })) = 0
//if !Empty (aTmpLote)
//	    	vtalert("O Lote a ser mov. pelo FIFO � "+LoteFifo+". Informe o lote correto!!",'AVISO',.T.,3000)
aTela:=VtSave()
VtClear
@ 03,00 vtsay 'O lote da vez � '+NrLoteFifo
@ 04,00 vtsay ' e o inf.'+NrloteAtu
//	@ 03,00 vtsay LoteFifo+' e o inf.'+CB0->CB0_LOTE
@ 05,00 vtsay " Conf. quebra do FIFO? (1=S/0=N)"
//@ 04,00 vtsay '                    '
@ 06,10 vtget cCont 	Picture '9' valid cCont $ "01" //when !lProximo //fConfirma(@cCont)
vtread
vtClear
vtrestore(,,,,aTela)
If cCont = "0"
Return(lRet)
Endif

//  EndIf
EndIf
Endif
////////////////////////////////////
*/

If nQuantProd == nQuantLida
	vtalert('Quantidade lida j� completou a quantidade da ordem de produ��o', .T., 2000)
	Return(lRet)
Endif
/*
If Alltrim(cLocal) <> Alltrim(Posicione('CB0', 1, xfilial('CB0') + cQR , 'CB0_LOCAL'))
vtalert('Local da etiqueta lida � diferente do local do produto atual !', 'AVISO', .T., 2000)
Return(lRet)
Endif
*/
//aadd( aSCK, {CK_PRODUTO, CK_LOCAL, CK_LOCALIZ, CK_LOTECTL, CK_NUMLOTE, CK_QTDVEN})
/*
If lPorLote .And. ( nPos := Ascan( aSCK, { |x| Alltrim(x[4]) == Alltrim(Posicione('CB0', 1, xfilial('CB0') + cQR , 'CB0_LOTE'))  } )  ) == 0
vtalert('Etiqueta nao pertence a nenhum dos lotes contidos nesta ordem de expedicao !', 'AVISO', .T., 2000)
Return(lRet)
Endif
*/
//aadd( aSCK, {CK_PRODUTO, CK_LOCAL, CK_LOCALIZ, CK_LOTECTL, CK_NUMLOTE, CK_QTDVEN, CK_PEDCLI, CK_ITEM, XCK_NUMSERI} )
//INDICE = BF_FILIAL+BF_LOCAL+BF_LOCALIZ+BF_PRODUTO+BF_NUMSERI+BF_LOTECTL+BF_NUMLOTE
If (nPos:=Ascan( aTmpLote, { |x| x[1] == cLocalOri+ cEndOri+ CB0_LOTE })) >0 .AND. ( aTmpLote[nPos,2] + CB0_QTDE > POSICIONE('SBF', 1, xfilial('SBF') + cLocalOri+ cEndOri+ CB0_CODPRO+CB0_NUMSER+CB0_LOTE+CB0_SLOTE , 'BF_QUANT') )
	vtalert('2. Saldo lote: '+ cLocalOri+'/'+cEndOri+'/'+ CB0_LOTE +' / '+ ALLTRIM(STR(POSICIONE('SBF', 1, xfilial('SBF') + cLocalOri+ cEndOri+ CB0_CODPRO+CB0_NUMSER+CB0_LOTE+CB0_SLOTE , 'BF_QUANT'))) +' � insuficiente!', 'AVISO' , .T., 2000)
	Return(lRet)
Endif
If ( nPos := Ascan( aTmpLote, { |x| x[1] == cLocalOri+ cEndOri+ CB0_LOTE } )  )  == 0 .AND. CB0_QTDE > POSICIONE('SBF', 1, xfilial('SBF') + cLocalOri+ cEndOri+CB0_CODPRO+CB0_NUMSER+CB0_LOTE+CB0_SLOTE, 'BF_QUANT')
	vtalert('3. Saldo lote: '+ cLocalOri+"/"+cEndOri+"/"+CB0_LOTE +' / '+ ALLTRIM(STR(POSICIONE('SBF', 1, xfilial('SBF') + cLocalOri+ cEndOri+CB0_CODPRO+CB0_NUMSER+CB0_LOTE+CB0_SLOTE , 'BF_QUANT'))) +' � insuficiente!', 'AVISO', .T., 2000)
	Return(lRet)
Endif
If (nPos:=Ascan( aTmpLote, { |x| x[1] == cLocalOri+ cEndOri+ CB0_LOTE })) ==0 .AND. ( CB0_QTDE > nQuantProd )
	vtalert('4. Qtde da etiqueta ultrapassa qtde solicitada, providenciar quebra de etiqueta!', 'AVISO' , .T., 3000)
	Return(lRet)
Endif
If (nPos:=Ascan( aTmpLote, { |x| x[1] == cLocalOri+ cEndOri+ CB0_LOTE })) >0 .AND. ( aTmpLote[nPos,2] + CB0_QTDE > nQuantProd )
	vtalert('5. Qtde da etiqueta ultrapassa qtde solicitada, providenciar quebra de etiqueta!', 'AVISO' , .T., 3000)
	Return(lRet)
Endif
If !Empty(Posicione('SDD', 3, xfilial('SDD') + CB0_CODPRO+ CB0_LOTE, 'DD_QUANT'))
	vtalert('Lote bloqueado!', 'AVISO', .T., 2000)
	Return(lRet)
Endif
//
//
// ******************** IMPLEMENTA��O P/ OBRIGATORIEDADE DO FIFO ******************************
// EM: 19/08/2013 BY ALEX ALMEIDA
// ********************************************************************************************
aLoteLido  := {}
nLoteAtual := 0
For _nL := 1 to Len(aTmpLote)
	If (nPos:=Ascan( aLoteLido, { |x| x[1] == Substr(aTmpLote[_nL,1],18,10) })) == 0
		aadd(aLoteLido, {Substr(aTmpLote[_nL,1],18,10), aTmpLote[_nL,2]} )
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
// ******************** IMPLEMENTA��O P/ OBRIGATORIEDADE DO FIFO ******************************
// EM: 19/08/2013 BY ALEX ALMEIDA
// ********************************************************************************************
//
//aadd(aTmpEtiq, { CB0_CODPRO+ cLocalOri+ cEndOri+ CB0_NUMSER+ CB0_LOTE+ CB0_SLOTE, cEtiqueta, CB0_CODPRO, CB0_LOTE, CB0_SLOTE, CB0_NUMSER, CB0_QTDE, CB0_LOCAL, CB0_LOCALI })
//aadd(aTmpEtiq, { CB0_CODPRO+ CB0_LOCORI+ CB0_LOCALI+ CB0_NUMSER+ CB0_LOTE+ CB0_SLOTE, CB0_CODETI, CB0_CODPRO, CB0_LOTE, CB0_SLOTE, CB0_NUMSER, CB0_QTDE, CB0_LOCAL, CB0_LOCALI })
aadd(aTmpEtiq, { CB0_CODPRO+ cLocalOri+ cEndOri+ CB0_NUMSER+ CB0_LOTE+ CB0_SLOTE, cEtiqueta, CB0_CODPRO, CB0_LOTE, CB0_SLOTE, CB0_NUMSER, CB0_QTDE, cLocalOri, cEndOri, CTOD("  /  /  "), "", iif(cQbFifo=="1","S","") })  //CB0_LOCAL, CB0_LOCALI })
If ( nPos := Ascan( aTmpLote, { |x| x[1] == cLocalOri+ cEndOri+ CB0_LOTE } ) ) == 0
	aadd(aTmpLote, { cLocalOri+ cEndOri+CB0_LOTE, CB0_QTDE } )
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
Static Function ValidEnd()
Local lReturn := .t.


SBE->(dbSetOrder(1))
If !(SBE->(dbSeek(xFilial("SBE")+cLocalOri+cEndOri)))
	//cLocalOri := space(tamsx3('C2_LOCAL')[1])
	cEndOri := Space(tamsx3('DB_LOCALIZ')[1])
	//
	vtgetrefresh('cLocalOri')
	vtgetrefresh('cEndOri')
	//vtkeyboard(chr(0))
	//vtclearbuffer()
	//VTKeyboard(chr(5))
	vtalert('Endereco n�o encontrado!', 'AVISO', .T., 3000)
	lReturn := .F.
Endif
//
If lReturn .and. cProduto <> Posicione('SBF', 1, xfilial('SBF')+ cLocalOri+ cEndOri+ cProduto, 'BF_PRODUTO')
	//cLocalOri := space(tamsx3('C2_LOCAL')[1])
	cEndOri := Space(tamsx3('DB_LOCALIZ')[1])
	vtgetrefresh('cLocalOri')
	vtgetrefresh('cEndOri')
	vtalert('Endereco n�o possui o produto solicitado!', 'AVISO', .T., 3000)
	//vtkeyboard(chr(0))
	//vtclearbuffer()
	//VTKeyboard(chr(5))
	lReturn := .F.
Endif
//
Return(lReturn)


Static Function TrocaEnd()
lTrocaEnd := .T.  //!lTrocaEnd
VTKeyBoard(chr(27))
Return
//
//
User Function ACDG12C()
Local aTela      := vtsave()
Local nOpcao     := 0
Local cOPOrigem  := space(10)
Local bkey24
Local nX := 0 
Local x := 0 

// Verifica se utiliza controle de transacao.
Private lTTS       := iif(getmv('MV_TTS') == 'S', .T., .F.)
Private aSD4       := {}
Private	cNumOrd    := Space(11)
//
Do While .t.
	vtclear
	//
	aSD4       := {}
	cNumOrd    := Space(11)
	//
	vtreverso(.T.)
	@ 00,02 vtsay 'Estorna Leitura'
	vtreverso(.F.)
	//
	@ 01,00 vtsay 'Ord.Prd:'
	@ 02,00 vtget cNumOrd picture '@!' valid  !empty(cNumOrd) .and. ValidOrd(cNumOrd)  f3 'SC2'
	vtread
	If VtLastKey() == 27
		Exit
	Endif
	//
	//aadd( aTmpSD4, {SD4->D4_COD, SD4->D4_LOCAL, SD4->D4_DATA, SD4->D4_QTDEORI, SD4->D4_QUANT, SD4->D4_LOTECTL, SD4->D4_NUMLOTE} )
	lQuery 	  := .T.
	aStruCB0  := CB0->(dbStruct())
	cQuery    := "SELECT * "
	cQuery    += " FROM "+ RetSqlName("CB0")+" "
	cQuery    += " WHERE CB0_OP = '" + cNumOrd + "' "
	cQuery    += "       AND CB0_DTPROC = '' "
	cQuery    += "       AND CB0_HRPROC = '' "
	cQuery    += "       AND CB0_DTAPON = '' "
	cQuery    += "       AND CB0_HRAPON = '' "
	//cQuery    += "       AND CB0_ORIGEM <> 'SD3' "
	cQuery    += "       AND CB0_LOCALI <> '"+Alltrim(GETMV("MV_ENDSEP2"))+"' "	//incluido em 13/11/13 para evitar limpar etiq. em separacao.
	cQuery    += "       AND CB0_FILIAL = '"+ XFILIAL("CB0") +"' "
	cQuery    += "       AND D_E_L_E_T_ <> '*' "
	cQuery    := ChangeQuery(cQuery)
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
		VTALERT("Nao existem etiquetas para estorno OU est�o em separa��o!","Aviso",.T.,3000,2)
		VTKeyBoard(chr(20))
	Else
		If VTYesNo("Deseja limpar as leituras desta O.P.?","Aviso" ,.T.)
			//
			cListEtiq := ""
			For x := 1 to Len(aTmpEtiq)
				cListEtiq += aTmpEtiq[x] + iif(x<>Len(aTmpEtiq),",","")
			Next
			//
			cListEtiq := fContidoSQL(cListEtiq)
			//
			For nX := 1 to len(aSD4)
				//vtalert(aSD4[nX,1])
				cQuery  :=  " UPDATE " + RETSQLNAME("CB0") + " "
				cQuery  +=  " SET CB0_DTLEIT='', CB0_HRLEIT='', CB0_OP='', CB0_LOCORI='', CB0_LOCALI='' "
				cQuery  +=  " WHERE CB0_OP = '" + cNumOrd + "' "
				cQuery  +=  "   AND CB0_CODPRO = '"+aSD4[nX,1]+"' "
				cQuery  +=  "   AND CB0_DTPROC = '' "
				cQuery  +=  "   AND CB0_HRPROC = '' "
				cQuery  +=  "   AND CB0_DTAPON = '' "
				cQuery  +=  "   AND CB0_HRAPON = '' "
				cQuery  +=  "   AND CB0_LOCALI <> '"+Alltrim(GETMV("MV_ENDSEP2"))+"' "	//incluido em 13/11/13 para evitar limpar etiq. em separacao.
				//cQuery  +=  "       AND CB0_ORIGEM <> 'SD3' "
				cQuery  +=  "   AND CB0_FILIAL = '"+ XFILIAL("CB0") +"' "
				cQuery  +=  "   AND D_E_L_E_T_ <> '*' "
				TcSqlExec(cQuery)
				//TcSqlExec("Commit")
				//
			Next
			/* BY ALEX INCLUIDO PARA LIMPAR A QUEBRA DE FIFO			*/
			cQuery  :=  " UPDATE " + RETSQLNAME("ZZ3") + " "
			cQuery  +=  " SET D_E_L_E_T_ = '*' "
			cQuery  +=  " WHERE ZZ3_FILIAL = '"+ xFilial("ZZ3") +"' "
			cQuery  +=  "   AND D_E_L_E_T_ <> '*' "
			cQuery  +=  "   AND ZZ3_OP = '" + cNumOrd + "' "
			cQuery  +=  "   AND ZZ3_ETIQ IN (" + cListEtiq + ") "
			cQuery  +=  "   AND ZZ3_ORIGEM = 'CB0' "
			cQuery  +=  "   AND ZZ3_DTAUT  = '' "
			cQuery  +=  "   AND ZZ3_HRAUT  = '' "
			cQuery  +=  "   AND ZZ3_CODAUT = '' "
			TcSqlExec(cQuery)
			//
			/*
			ZZ3->(dbsetorder(2))
			dbSelectArea("CB0TMP")
			dbGoTop()
			Do While CB0TMP->(!Eof())
			If ZZ3->(dbSeek(xFilial("ZZ3")+ CB0TMP->CB0_CODETI))
			RecLock("ZZ3", .F.)
			ZZ3->(dbdelete())
			ZZ3->(MsUnlock())
			Endif
			CB0TMP->(dbSkip())
			Enddo
			ZZ3->(dbsetorder(1))
			*/
		Endif
	Endif
	CB0TMP->(dbCloseArea())
Enddo
Return
//
//
Static Function ACDG12Z()
If VTYesNo("Deseja movimentar parcial o Pick-List?","Aviso" ,.T.)
	lSair := .T.
	nX := Len(aSD4) + 1
	VTKeyBoard(chr(27)) //+chr(83))
Endif
Return
//
//
Static Function PegaSaldoFifo()
// ******************** IMPLEMENTA��O P/ OBRIGATORIEDADE DO FIFO ******************************//
// EM: 19/08/2013 BY ALEX ALMEIDA
//
If Select("SBFTMP") <> 0
	SBFTMP->(dbCloseArea())
Endif
//
If POSICIONE("SB1",1,xFilial("SB1")+ cProduto,"B1_TIPO") $ "PI/PA"
	cQuery := " SELECT C2_EMISSAO AS DT_ENT, BF_PRODUTO, BF_LOTECTL, SUM(BF_QUANT) AS BF_SALDO, SUM(BF_EMPENHO) AS BF_EMPENHO "
	cQuery += " FROM "+ RETSQLNAME("SBF")+" A INNER JOIN "+ RETSQLNAME("SC2")+" B ON (BF_LOTECTL=C2_NUM+C2_ITEM+RIGHT(C2_SEQUEN,2)) "
	cQuery += " WHERE A.D_E_L_E_T_ <>'*' AND  B.D_E_L_E_T_ <>'*'"
	cQuery += " AND BF_FILIAL ='"+xFilial("SBF")+"'"
	cQuery += " AND C2_FILIAL ='"+xFilial("SC2")+"'"
	cQuery += " AND BF_PRODUTO='"+cProduto+"'"
	cQuery += " AND C2_PRODUTO='"+cProduto+"'"
	cQuery += " AND BF_LOCAL='"+cLocalOri+"'"
	cQuery += " AND BF_QUANT > 0 "
	cQuery += " AND BF_LOCALIZ <> '"+Alltrim(GETMV("MV_ENDSEP2"))+"' "
	cQuery += " GROUP BY C2_EMISSAO, BF_PRODUTO, BF_LOTECTL "
	cQuery += " ORDER BY C2_EMISSAO, BF_PRODUTO, BF_LOTECTL "
Else
	cQuery := " SELECT D1_DTDIGIT AS DT_ENT, BF_PRODUTO, BF_LOTECTL, SUM(BF_QUANT) AS BF_SALDO, SUM(BF_EMPENHO) AS BF_EMPENHO "
	cQuery += " FROM "+ RETSQLNAME("SBF")+" A INNER JOIN "+ RETSQLNAME("SD1")+" B ON (BF_LOTECTL=D1_LOTECTL) "
	cQuery += " WHERE A.D_E_L_E_T_ <>'*' AND  B.D_E_L_E_T_ <>'*'"
	cQuery += " AND BF_FILIAL ='"+xFilial("SBF")+"'"
	cQuery += " AND D1_FILIAL ='"+xFilial("SD1")+"'"
	cQuery += " AND BF_PRODUTO='"+cProduto+"'"
	cQuery += " AND D1_COD='"+cProduto+"'"
	cQuery += " AND BF_LOCAL='"+cLocalOri+"'"
	cQuery += " AND BF_QUANT > 0 "
	cQuery += " AND BF_LOCALIZ <> '"+Alltrim(GETMV("MV_ENDSEP2"))+"' "
	cQuery += " GROUP BY D1_DTDIGIT, BF_PRODUTO, BF_LOTECTL "
	cQuery += " ORDER BY D1_DTDIGIT, BF_PRODUTO, BF_LOTECTL "
Endif
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
	SBFTMP->(dbSkip())
Enddo
SBFTMP->(dbClosearea())
//
// ******************** IMPLEMENTA��O P/ OBRIGATORIEDADE DO FIFO ******************************//
Return


Static Function CheckFifo()
Local lRet := .T.
Local nX := 0

cEtqList := ""
cLotList := ""
For nX := 1 to Len(aEtiqueta)
	cEtqList += aEtiqueta[nX,2]+iif(nX<Len(aEtiqueta),",","")
	cLotList += aEtiqueta[nX,4]+iif(nX<Len(aEtiqueta),",","")
Next

cQuery := ""
cQuery += " SELECT * "
cQuery += " FROM "+RetSqlName("ZZ3")+" A "
cQuery += " WHERE A.D_E_L_E_T_<>'*' "
cQuery += " AND ZZ3_FILIAL = '"+xFilial("ZZ3")+"'"
cQuery += " AND ZZ3_ETIQ IN ("+fContidoSQL(cEtqList)+") "
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

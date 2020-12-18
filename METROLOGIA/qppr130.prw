#INCLUDE "QPPR130.CH"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ QPPR130  ³ Autor ³ Robson Ramiro A. Olive³ Data ³ 19.06.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³FMEA de Processo                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QPPR130(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PPAP                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Robson Ramiro³12.09.01³      ³ Inclusao dos dados na moldura          ³±±
±±³ Robson Ramiro³18.04.02³14725 ³ Melhorias na impressao, evitando a     ³±±
±±³              ³        ³      ³ duplicado do codigo da operacao        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Function QPPR130(lBrow,cPecaAuto,cJPEG)

Local oPrint
Local lPergunte := .F.

Private cPecaRev 	:= ""
Private cStartPath 	:= GetSrvProfString("Startpath","")
Private	lQLGREL		:= GetMv("MV_QLGREL")

Default lBrow 		:= .F.
Default cPecaAuto	:= ""
Default cJPEG       := "" 

If Right(cStartPath,1) <> "\"
	cStartPath += "\"
Endif

If !Empty(cPecaAuto)
	cPecaRev := cPecaAuto
Endif

oPrint := TMSPrinter():New(STR0001) //"FMEA de Processo"

oPrint:SetLandscape()

If GetMV("MV_QVEFMEA",.T.,"3") == "4" //FMEA 4a. EDICAO...
	QPPR380(@oPrint,lBrow,cPecaAuto,cJPEG,lPergunte)
Else
	If Empty(cPecaAuto)
		If AllTrim(FunName()) == "QPPA130" .or. AllTrim(FunName()) == "QPPA131"
			cPecaRev := Iif(!lBrow, M->QK7_PECA + M->QK7_REV, QK7->QK7_PECA + QK7->QK7_REV)
		Else
			lPergunte := Pergunte("PPR130",.T.)
	
			If lPergunte
				cPecaRev := mv_par01 + mv_par02	
			Else
				Return Nil
			Endif
		Endif
	Endif
	
	DbSelectArea("QK1")
	DbSetOrder(1)
	DbSeek(xFilial()+cPecaRev)
	
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1") + QK1->QK1_CODCLI + QK1->QK1_LOJCLI)
	
	DbSelectArea("QK7") 
	DbSetOrder(1)
	If DbSeek(xFilial()+cPecaRev)
	
		If Empty(cPecaAuto)
			MsgRun(STR0002,"",{|| CursorWait(), MontaRel(oPrint) ,CursorArrow()}) //"Gerando Visualizacao, Aguarde..."
		Else
			MontaRel(oPrint)
		Endif
	
		If lPergunte .and. mv_par03 == 1 .or. !Empty(cPecaAuto)
			If !Empty(cJPEG)
	   			oPrint:SaveAllAsJPEG(cStartPath+cJPEG,1120,840,140)
	        Else
				oPrint:Print()
			EndIF
		Else
			oPrint:Preview()  		// Visualiza antes de imprimir
		Endif
	Endif
Endif
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MontaRel ³ Autor ³ Robson Ramiro A. Olive³ Data ³ 19.06.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³FMEA de Processo                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MotaRel(ExpO1)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto oPrint                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QPPR130                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MontaRel(oPrint)

Local i 	:= 1, nCont := 0
Local x 	:= 0, lin, nPos
Local aTxt, nx
Local cTexto
Local cOpe
Local cItem		:= ""
Local cItemAnt	:= ""
Local nNPRMAX	:= GetMv("MV_NPRMAX")
Local axTextos  := {}
Local nxCont    := 0, nLinha := 0
Local lUsaQAL	:= AliasInDic("QAL")
	
Private oFont16, oFont08, oFont10, oFontCou07, oFontCou08, oFontNPR

oFont16		:= TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)
oFont08		:= TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
oFont10		:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFontCou08	:= TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)
oFontCou07	:= TFont():New("Courier New",07,07,,.F.,,,,.T.,.F.)
oFontNPR	:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)

Cabecalho(oPrint,i)  	// Funcao que monta o cabecalho
lin := 790

DbSelectArea("QK8")
DbSetOrder(1)
DbSeek(xFilial()+cPecaRev)

Do While !Eof() .and. QK8->QK8_PECA+QK8->QK8_REV == cPecaRev

	nCont++ 

	aTxt := {}	// Array que armazena os campos memos
	
	lin += 40

	If lin > 2240
		nCont := 1
		i++
		oPrint:EndPage() 		// Finaliza a pagina
		Cabecalho(oPrint,i)  	// Funcao que monta o cabecalho
		lin := 790
		lin += 40
	Endif

	oPrint:Say(lin,0995,QK8->QK8_SEVER,oFontCou07)

	PPAPBMP(QK8->QK8_CLASS+".BMP", cStartPath)
	oPrint:SayBitmap(lin,1029, QK8->QK8_CLASS+".BMP",40,40)

	oPrint:Say(lin,1395,QK8->QK8_OCORR,oFontCou07)
	oPrint:Say(lin,1755,QK8->QK8_DETEC,oFontCou07)

	If Val(QK8->QK8_NPR) >= nNPRMAX
		oPrint:Say(lin,1795,QK8->QK8_NPR,oFontNPR)
	Else
		oPrint:Say(lin,1795,QK8->QK8_NPR,oFontCou07)
	Endif
    
    If !lUsaQAL
	oPrint:Say(lin,2195,Subs(QK8->QK8_RESP,1,25),oFontCou08)
	oPrint:Say(lin+30,2195,DtoC(QK8->QK8_PRAZO),oFontCou08)
	Endif

	oPrint:Say(lin,2815,QK8->QK8_RSEVER,oFontCou07)
	oPrint:Say(lin,2855,QK8->QK8_ROCORR,oFontCou07)
	oPrint:Say(lin,2895,QK8->QK8_RDETEC,oFontCou07)

	If Val(QK8->QK8_RNPR) >= nNPRMAX
		oPrint:Say(lin,2931,QK8->QK8_RNPR,oFontNPR)
	Else
		oPrint:Say(lin,2931,QK8->QK8_RNPR,oFontCou07)
	Endif

	If !Empty(QK8->QK8_CHAVE1)
		DbSelectArea("QKO")
		DbSetOrder(1)
		
		
If !lUsaQAL  
				cOpe := ""
	
		If	DbSeek(xFilial("QKO")+"QPPA130A" + QK8->QK8_CHAVE1) // Item Funcao
			Do While !Eof() .and. xFilial("QKO") == QKO->QKO_FILIAL .and. ;
						QKO->QKO_CHAVE == QK8->QK8_CHAVE1 .and.;
						QKO->QKO_ESPEC == "QPPA130A"

				If !Empty(QKO->QKO_TEXTO)


					If Len(aTxt) <> 0
						nPos := aScan( aTxt, { |x| x[1] == QKO->QKO_SEQ })
					Else
						nPos := 0
					Endif
					
					If !Empty(QK8->QK8_NOPE)
						If cOpe <> QK8->QK8_NOPE
							cTexto := QK8->QK8_NOPE + " :"

							aAdd( aTxt,{ "000", cTexto , Space(17), Space(17),;
										Space(17), Space(8), Space(8), Space(17), Space(17) })
											
							cTexto := Subs(QKO->QKO_TEXTO,1,17)
						Else
							cTexto := Subs(QKO->QKO_TEXTO,1,17)
						Endif
					Else
						cTexto := Subs(QKO->QKO_TEXTO,1,17)
					Endif

      				If nPos == 0
						aAdd( aTxt,{	QKO->QKO_SEQ, cTexto , Space(17), Space(17),;
										Space(17), Space(8), Space(8), Space(17), Space(17) })
      				Else
						aTxt[nPos,2] := cTexto
      				Endif
				Endif

				cOpe := QK8->QK8_NOPE
				
				DbSkip()
			Enddo
		Endif		
Else
		axTextos := {}
		//Recupera texto da chave

		cxTextos := QO_Rectxt(QK8->QK8_CHAVE1,"QPPA130A",1,17,"QKO",axTextos)
		cxTextos := QADIVFRA( QExclEnter(cxTextos), 17)
		axTextos := JustificaTXT(cxTextos,17,.F.,.T.)  

        nLinha := 1
		For nxCont := 1 To Len(axTextos)

			If Len(aTxt) <> 0
				nPos := aScan( aTxt, { |x| x[1] == STRZERO(nLinha,3) })
			Else
				nPos := 0
			Endif

   			If nPos == 0
				aAdd( aTxt,{	STRZERO(nLinha,3), axTextos[nxCont], Space(17), Space(17), Space(17),;
								Space(8),Space(8), Space(17),Space(17), Space(17) })
   			Else
				aTxt[nPos,2] := axTextos[nxCont]
   			Endif

            nLinha++ 
        Next
        
Endif
        
		axTextos := {}
		//Recupera texto da chave
        If lUsaQAL
			cxTextos := QO_Rectxt(QK8->QK8_CHAVE1,"QPPA130B",1,17,"QKO",axTextos)
			cxTextos := QADIVFRA( QExclEnter(cxTextos), 17)
			axTextos := JustificaTXT(cxTextos,17,.F.,.T.)  
		Else
			axTextos := JustificaTXT(QO_Rectxt(QK8->QK8_CHAVE1,"QPPA130B",1,17,"QKO",axTextos),17,.F.,.T.)
		Endif

        nLinha := 1
		For nxCont := 1 To Len(axTextos)

			If Len(aTxt) <> 0
				nPos := aScan( aTxt, { |x| x[1] == STRZERO(nLinha,3) })
			Else
				nPos := 0
			Endif

   			If nPos == 0
				aAdd( aTxt,{	STRZERO(nLinha,3), Space(17),axTextos[nxCont], Space(17), Space(17),;
								Space(8),Space(8), Space(17),Space(17), Space(17) })
   			Else
				aTxt[nPos,3] := axTextos[nxCont]
   			Endif

            nLinha++ 
        Next

		axTextos := {}
		//Recupera texto da chave
        
		If lUsaQAL
			cxTextos := QO_Rectxt(QK8->QK8_CHAVE1,"QPPA130C",1,17,"QKO",axTextos)
			cxTextos := QADIVFRA( QExclEnter(cxTextos), 17)
			axTextos := JustificaTXT(cxTextos,17,.F.,.T.)  
		Else
			axTextos := JustificaTXT(QO_Rectxt(QK8->QK8_CHAVE1,"QPPA130C",1,17,"QKO",axTextos),17,.F.,.T.)
		Endif

        nLinha := 1
		For nxCont := 1 To Len(axTextos) // Efeito de Falha Potencial

			If Len(aTxt) <> 0
				nPos := aScan( aTxt, { |x| x[1] == STRZERO(nLinha,3) })
			Else
				nPos := 0
			Endif

   			If nPos == 0
				aAdd( aTxt,{	STRZERO(nLinha,3), Space(17), Space(17), axTextos[nxCont], Space(17),;
								Space(8),Space(8), Space(17), Space(17), Space(17) })
   			Else
				aTxt[nPos,4] := axTextos[nxCont]
   			Endif

            nLinha++ 
        Next
        
		axTextos := {}
		//Recupera texto da chave	
		If lUsaQAL
			cxTextos := QO_Rectxt(QK8->QK8_CHAVE1,"QPPA130D",1,17,"QKO",axTextos)
			cxTextos := QADIVFRA( QExclEnter(cxTextos), 17)
			axTextos := JustificaTXT(cxTextos,17,.F.,.T.)  
		Else
			axTextos := JustificaTXT(QO_Rectxt(QK8->QK8_CHAVE1,"QPPA130D",1,17,"QKO",axTextos),17,.F.,.T.)
		Endif

        nLinha := 1
		For nxCont := 1 To Len(axTextos) // Causa/Mecanismo Potencial da Falha

			If Len(aTxt) <> 0
				nPos := aScan( aTxt, { |x| x[1] == STRZERO(nLinha,3) })
			Else
				nPos := 0
			Endif

   			If nPos == 0
				aAdd( aTxt,{	STRZERO(nLinha,3), Space(17),Space(17), Space(17), axTextos[nxCont],;
								Space(8),Space(8), Space(17),Space(17), Space(17) })
   			Else
				aTxt[nPos,5] := axTextos[nxCont]
   			Endif

            nLinha++ 
        Next
        
		axTextos := {}
		//Recupera texto da chave
       	If lUsaQAL
			cxTextos := QO_Rectxt(QK8->QK8_CHAVE1,"QPPA130E",1,8,"QKO",axTextos)
			cxTextos := QADIVFRA( QExclEnter(cxTextos), 8)
			axTextos := JustificaTXT(cxTextos,8,.F.,.T.)  
		Else
			axTextos := JustificaTXT(QO_Rectxt(QK8->QK8_CHAVE1,"QPPA130E",1,8,"QKO",axTextos),8,.F.,.T.)
		Endif

        nLinha := 1
		For nxCont := 1 To Len(axTextos) // Controles atuais do processo

			If Len(aTxt) <> 0
				nPos := aScan( aTxt, { |x| x[1] == STRZERO(nLinha,3) })
			Else
				nPos := 0
			Endif

   			If nPos == 0
				aAdd( aTxt,{	STRZERO(nLinha,3), Space(17), Space(17), Space(17), Space(17),;
								axTextos[nxCont], Space(8), Space(17), Space(17), Space(17) })
   			Else
				aTxt[nPos,6] := axTextos[nxCont]
   			Endif

            nLinha++ 
        Next

		axTextos := {}
		//Recupera texto da chave
		If lUsaQAL
			cxTextos := QO_Rectxt(QK8->QK8_CHAVE1,"QPPA130H",1,8,"QKO",axTextos)
			cxTextos := QADIVFRA( QExclEnter(cxTextos), 8)
			axTextos := JustificaTXT(cxTextos,8,.F.,.T.)  
		Else
			axTextos := JustificaTXT(QO_Rectxt(QK8->QK8_CHAVE1,"QPPA130H",1,8,"QKO",axTextos),8,.F.,.T.)
		Endif

        nLinha := 1
		For nxCont := 1 To Len(axTextos) // Controles atuais do projeto Deteccao

			If Len(aTxt) <> 0
				nPos := aScan( aTxt, { |x| x[1] == STRZERO(nLinha,3) })
			Else
				nPos := 0
			Endif

   			If nPos == 0
				aAdd( aTxt,{	STRZERO(nLinha,3), Space(17), Space(17), Space(17), Space(17),;
								Space(8), axTextos[nxCont], Space(17), Space(17), Space(17) })
   			Else
				aTxt[nPos,7] := axTextos[nxCont]
   			Endif

            nLinha++ 
        Next

		axTextos := {}
		//Recupera texto da chave
		If lUsaQAL
			cxTextos := QO_Rectxt(QK8->QK8_CHAVE1,"QPPA130F",1,17,"QKO",axTextos)
			cxTextos := QADIVFRA( QExclEnter(cxTextos), 17)
			axTextos := JustificaTXT(cxTextos,17,.F.,.T.)  
		Else
			axTextos := JustificaTXT(QO_Rectxt(QK8->QK8_CHAVE1,"QPPA130F",1,17,"QKO",axTextos),17,.F.,.T.)
		Endif

        nLinha := 1
		For nxCont := 1 To Len(axTextos) // Acoes Recomendadas

			If Len(aTxt) <> 0
				nPos := aScan( aTxt, { |x| x[1] == STRZERO(nLinha,3) })
			Else
				nPos := 0
			Endif

   			If nPos == 0
				aAdd( aTxt,{	STRZERO(nLinha,3), Space(17), Space(17), Space(17), Space(17),;
								Space(8),Space(8), axTextos[nxCont], Space(17), Space(17) })
   			Else
				aTxt[nPos,8] := axTextos[nxCont]
   			Endif

            nLinha++ 
        Next

		axTextos := {}
		//Recupera texto da chave
		If lUsaQAL
			cxTextos := QO_Rectxt(QK8->QK8_CHAVE1,"QPPA130G",1,17,"QKO",axTextos)
			cxTextos := QADIVFRA( QExclEnter(cxTextos), 17)
			axTextos := JustificaTXT(cxTextos,17,.F.,.T.)  
		Else
			axTextos := JustificaTXT(QO_Rectxt(QK8->QK8_CHAVE1,"QPPA130G",1,17,"QKO",axTextos),17,.F.,.T.)
		Endif

        nLinha := 1
		For nxCont := 1 To Len(axTextos) // Acoes Tomadas
			If Len(aTxt) <> 0
				nPos := aScan( aTxt, { |x| x[1] == STRZERO(nLinha,3) })
			Else
				nPos := 0
			Endif

   			If nPos == 0
				aAdd( aTxt,{	STRZERO(nLinha,3), Space(17), Space(17), Space(17), Space(17),;
								Space(8), Space(8), Space(17), axTextos[nxCont], Space(17) })
   			Else
				aTxt[nPos,9] := axTextos[nxCont]
   			Endif

            nLinha++ 
        Next

If lUsaQAL
		axTextos := {}     
		//Recupera texto da chave
		cxTextos := QK8->QK8_RESP						// Responsavel
		cxTextos := QADIVFRA( QExclEnter(cxTextos), 17)
		axTextos := JustificaTXT(cxTextos,17,.F.,.T.)
		aAdd(axTextos,DtoC(QK8->QK8_PRAZO))				// // Acrescenta a data PRAZO na ultima linha desta coluna  
	 
	    nLinha := 1
		For nxCont := 1 To Len(axTextos)		
			If !Empty(QK8->QK8_RESP)
	
				If Len(aTxt) <> 0
					nPos := aScan( aTxt, { |x| x[1] == STRZERO(nLinha,3) })
				Else
					nPos := 0
				Endif
	
	      		If nPos == 0  
					aAdd( aTxt,{	STRZERO(nLinha,3), Space(17),Space(17), Space(17),Space(17),;
									Space(8),Space(8), Space(17),Space(17), axTextos[nxCont] })

	   			Else
		   			aTxt[nPos,10] := axTextos[nxCont]
	   			Endif
			Endif
	        nLinha++ 
		Next
Endif

	Endif


	If Len(aTxt) > 0
		cItem := aTxt[1,2]
	Endif

	If nCont > 1
		If Empty(cItemAnt) .and. !Empty(cItem)
			oPrint:Line( lin, 30, lin, 3000 )   	// horizontal
			lin += 20
		Elseif !Empty(cItemAnt) .and. !Empty(cItem)
			oPrint:Line( lin, 30, lin, 3000 )   	// horizontal
			lin += 20
		Endif
	Endif

	If Len(aTxt) > 0
		For nx := 1 To Len(aTxt)
			oPrint:Say(lin,0050,aTxt[nx,2],oFontCou07)
			oPrint:Say(lin,0360,aTxt[nx,3],oFontCou07)
			oPrint:Say(lin,0680,aTxt[nx,4],oFontCou07)
			oPrint:Say(lin,1080,aTxt[nx,5],oFontCou07)
			oPrint:Say(lin,1440,aTxt[nx,6],oFontCou07)
			oPrint:Say(lin,1600,aTxt[nx,7],oFontCou07)
			oPrint:Say(lin,1880,aTxt[nx,8],oFontCou07)
			oPrint:Say(lin,2510,aTxt[nx,9],oFontCou07)
			If lUsaQAL
			oPrint:Say(lin,2195,aTxt[nx,10],oFontCou07)
			Endif

			lin += 40

			If lin > 2240
				i++
				oPrint:EndPage() 		// Finaliza a pagina
				Cabecalho(oPrint,i) 	// Funcao que monta o cabecalho
				lin := 790
				lin += 40
			Endif
		Next nx
	Endif

	If Len(aTxt) > 0
		cItemAnt := cItem
	Endif

	DbSelectArea("QK8")
	DbSkip()

Enddo

lin += 20
oPrint:Line( lin, 30, lin, 3000 )   	// horizontal

Return Nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Cabecalho³ Autor ³ Robson Ramiro A. Olive³ Data ³ 19.06.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³FMEA de Processo                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Cabecalho(ExpO1,ExpN1)                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto oPrint                                      ³±±
±±³          ³ ExpN1 = Contador de paginas                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QPPR130                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Cabecalho(oPrint,i)

Local cFileLogo  := "LGRL"+SM0->M0_CODIGO+FWCodFil()+".BMP" // Empresa+Filial
Local nWeight, nWidth

Do Case
	Case QK1->QK1_TPLOGO == "1" 
		cLogoPad	:= "BIG3.BMP"
		nWeight		:= 370
		nWidth		:= 70
	Case QK1->QK1_TPLOGO == "2" 
		cLogoPad 	:= "CHRYSLER.BMP"
		nWeight		:= 370
		nWidth		:= 70
	Case QK1->QK1_TPLOGO == "3" 
		cLogoPad 	:= "FORD.BMP"
		nWeight		:= 160
		nWidth		:= 80
	Case QK1->QK1_TPLOGO == "4" 
		cLogoPad := "GM.BMP"
		nWeight		:= 80
		nWidth		:= 80
	Case QK1->QK1_TPLOGO == "5" 
		cLogoPad 	:= ""
		nWeight		:= 0
		nWidth		:= 0
	OtherWise
		cLogoPad	:= "BIG3.BMP"
		nWeight		:= 370 
		nWidth		:= 70
Endcase

If !File(cFileLogo)
	cFileLogo := "LGRL" + SM0->M0_CODIGO+".BMP" // Empresa
Endif

oPrint:StartPage() 		// Inicia uma nova pagina

If lQLGREL
	PPAPBMP(cLogoPad, cStartPath)
	oPrint:SayBitmap(80,0080, cLogoPad,nWeight,nWidth)
Endif

oPrint:SayBitmap(05,0005, cFileLogo,328,82)             // Tem que estar abaixo do RootPath
oPrint:SayBitmap(05,2800, "Logo.bmp",237,58) 

oPrint:Say(050,1400,STR0001,oFont16 ) //"FMEA DE PROCESSO"

// Box Cabecalho
oPrint:Box( 160, 30, 560, 3000 )

// Construcao da Grade
oPrint:Line( 240, 30, 240, 3000 )   	// horizontal
oPrint:Line( 320, 30, 320, 3000 )   	// horizontal
oPrint:Line( 400, 30, 400, 3000 )   	// horizontal
oPrint:Line( 480, 30, 480, 3000 )   	// horizontal

oPrint:Line( 160, 1020, 400, 1020 )   	// vertical
oPrint:Line( 160, 0510, 240, 0510 )   	// vertical

oPrint:Line( 160, 2010, 560, 2010 )   	// vertical
oPrint:Line( 160, 2800, 240, 2800 )   	// vertical
                                                   
oPrint:Line( 400, 2800, 560, 2800 )   	// vertical

oPrint:Line( 480, 2405, 560, 2405 )   	// vertical

// Descricao cabecalho
oPrint:Say(170,0040,STR0003,oFont08) //"Numero da Peca(Cliente)"
oPrint:Say(200,0040,Subs(QK1->QK1_PCCLI,1,26),oFontCou08)

oPrint:Say(170,0520,STR0004,oFont08) //"Rev/Data do Desenho"
oPrint:Say(200,0520,AllTrim(QK1->QK1_REVDES)+" "+DtoC(QK1->QK1_DTRDES),oFontCou08)

oPrint:Say(170,1030,STR0005,oFont08) //"Nome da Peca"
oPrint:Say(200,1030,Subs(QK1->QK1_DESC,1,50),oFontCou08)

oPrint:Say(170,2020,STR0006,oFont08) //"Numero da FMEA"
oPrint:Say(200,2020,QK7->QK7_FMEA,oFontCou08)

oPrint:Say(170,2810,STR0007,oFont08) //"Pagina"
oPrint:Say(200,2810,StrZero(i,3),oFontCou08)

oPrint:Say(250,0040,STR0008,oFont08) //"Preparado Por"
oPrint:Say(280,0040,QK7->QK7_PREPOR,oFontCou08)

oPrint:Say(250,1030,STR0009,oFont08) //"Responsavel pelo Processo"
oPrint:Say(280,1030,QK7->QK7_RESPON,oFontCou08)

oPrint:Say(250,2020,STR0010,oFont08)       //"Cliente"
oPrint:Say(280,2020,SA1->A1_NOME,oFontCou08)

oPrint:Say(330,0040,STR0011,oFont08) //"Fornecedor"
oPrint:Say(360,0040,SM0->M0_NOMECOM,oFontCou08)

oPrint:Say(330,1030,STR0012,oFont08) //"Identificacao do Produto"
oPrint:Say(360,1030,QK7->QK7_IDPROD,oFontCou08)

oPrint:Say(330,2020,STR0013,oFont08) //"Numero/Rev Peca(Fornecedor)"
oPrint:Say(360,2020,AllTrim(QK7->QK7_PECA)+" "+QK7->QK7_REV,oFontCou08)

oPrint:Say(410,0040,STR0014,oFont08) //"Equipe"
oPrint:Say(440,0040,QK7->QK7_EQUIPE,oFontCou08)

oPrint:Say(410,2020,STR0015,oFont08) //"Aprovado Por"
oPrint:Say(440,2020,QK7->QK7_APRPOR,oFontCou08)

oPrint:Say(410,2810,STR0016,oFont08) //"Data"
oPrint:Say(440,2810,DtoC(QK7->QK7_DATA),oFontCou08)
                                    
oPrint:Say(490,0040,STR0017,oFont08) //"Observacoes"
If Len(AllTrim(QK7->QK7_OBS)) <= 100
	oPrint:Say(520,0040,QK7->QK7_OBS,oFontCou08)
Else
	oPrint:Say(490,0230,Subs(QK7->QK7_OBS,1,100),oFontCou08)
	oPrint:Say(520,0040,Subs(QK7->QK7_OBS,101),oFontCou08)
Endif

oPrint:Say(490,2020,STR0018,oFont08) //"Data Inicio"
oPrint:Say(520,2020,DtoC(QK7->QK7_DTINI),oFontCou08)

oPrint:Say(490,2415,STR0019,oFont08) //"Data Rev"
oPrint:Say(520,2415,DtoC(QK7->QK7_DTREV),oFontCou08)

oPrint:Say(490,2810,STR0020,oFont08) //"Data Chave"
oPrint:Say(520,2810,DtoC(QK7->QK7_DTCHAV),oFontCou08)

// Box itens
oPrint:Box( 580, 30, 2260, 3000 )
oPrint:Line( 820, 30, 820, 3000 )   	// horizontal

// Construcao da grade itens
oPrint:Line( 580, 0350, 2260, 0350 )   	// vertical
oPrint:Line( 580, 0670, 2260, 0670 )   	// vertical

oPrint:Line( 580, 0990, 2260, 0990 )   	// vertical
oPrint:Line( 580, 1025, 2260, 1025 )   	// vertical
oPrint:Line( 580, 1070, 2260, 1070 )   	// vertical
                                                   
oPrint:Line( 580, 1390, 2260, 1390 )   	// vertical
oPrint:Line( 580, 1430, 2260, 1430 )   	// vertical
oPrint:Line( 580, 1590, 2260, 1590 )   	// vertical

oPrint:Line( 580, 1750, 2260, 1750 )   	// vertical
oPrint:Line( 580, 1790, 2260, 1790 )   	// vertical
oPrint:Line( 580, 1870, 2260, 1870 )   	// vertical
                                                   
oPrint:Line( 580, 2190, 2260, 2190 )   	// vertical
oPrint:Line( 580, 2490, 2260, 2490 )   	// vertical
                                                   
oPrint:Line( 630, 2490, 0630, 3000 )   	// horizontal
oPrint:Line( 630, 2810, 2260, 2810 )   	// vertical
oPrint:Line( 630, 2850, 2260, 2850 )   	// vertical
oPrint:Line( 630, 2890, 2260, 2890 )   	// vertical
oPrint:Line( 630, 2930, 2260, 2930 )   	// vertical

// Descricao itens
oPrint:Say(660,100,STR0021,oFont08) //"Funcao /"
oPrint:Say(700,100,STR0022,oFont08) //"Requisitos"

oPrint:Say(640,400,STR0023,oFont08) //"Modo de  "
oPrint:Say(680,400,STR0024,oFont08) //" Falha   "
oPrint:Say(720,400,STR0025,oFont08) //"Potencial"

oPrint:Say(640,720,STR0026,oFont08) //" Efeito  "
oPrint:Say(680,720,STR0025,oFont08) //"Potencial"
oPrint:Say(720,720,STR0027,oFont08) //"da Falha "

oPrint:Say(620,997,STR0040,oFont08) // "S"
oPrint:Say(645,997,STR0041,oFont08) // "E"
oPrint:Say(670,997,STR0042,oFont08) // "V"
oPrint:Say(695,997,STR0043,oFont08) // "E"
oPrint:Say(720,997,STR0044,oFont08) // "R"

oPrint:Say(620,1034,STR0058,oFont08) // "C"
oPrint:Say(645,1034,STR0059,oFont08) // "L"
oPrint:Say(670,1034,STR0060,oFont08) // "A" 
oPrint:Say(695,1034,STR0061,oFont08) // "S"
oPrint:Say(720,1034,STR0062,oFont08) // "S"

oPrint:Say(640,1100,STR0028,oFont08) //"Causa / Mecanismo"
oPrint:Say(680,1100,STR0029,oFont08) //"    Potencial    "
oPrint:Say(720,1100,STR0030,oFont08) //"     da Falha    "

oPrint:Say(620,1395,STR0045,oFont08) // "O"
oPrint:Say(645,1395,STR0046,oFont08) // "C"
oPrint:Say(670,1395,STR0047,oFont08) // "O"
oPrint:Say(695,1395,STR0048,oFont08) // "R"
oPrint:Say(720,1395,STR0049,oFont08) // "R"

oPrint:Say(640,1450,STR0031,oFont08) //"Controles"
oPrint:Say(680,1450,STR0032,oFont08) //"Atuais do"
oPrint:Say(720,1450,STR0033,oFont08) //" Projeto "
oPrint:Say(760,1450,STR0063,oFont08) //"Prevencao"

oPrint:Say(640,1610,STR0031,oFont08) //"Controles"
oPrint:Say(680,1610,STR0032,oFont08) //"Atuais do"
oPrint:Say(720,1610,STR0033,oFont08) //" Projeto "
oPrint:Say(760,1610,STR0064,oFont08) //"Deteccao"


oPrint:Say(620,1760,STR0050,oFont08) // "D"
oPrint:Say(645,1760,STR0051,oFont08) // "E"
oPrint:Say(670,1760,STR0052,oFont08) // "T"
oPrint:Say(695,1760,STR0053,oFont08) // "E"
oPrint:Say(720,1760,STR0054,oFont08) // "C"

oPrint:Say(645,1810,STR0055,oFont08) // "N"
oPrint:Say(670,1810,STR0056,oFont08) // "P"
oPrint:Say(695,1810,STR0057,oFont08) // "R"

oPrint:Say(660,1900,STR0034,oFont08) //"     Acoes  "
oPrint:Say(700,1900,STR0035,oFont08) //"Recomendadas"

oPrint:Say(660,2250,STR0036,oFont08) //"Responsavel"
oPrint:Say(700,2250,STR0037,oFont08) //"     Prazo "

oPrint:Say(700,2550,STR0038,oFont08) //"Acoes Tomadas"

oPrint:Say(590,2610,STR0039,oFont08) //"Resultado das Acoes"

oPrint:Say(640,2825,STR0040,oFont08) // "S"
oPrint:Say(665,2825,STR0041,oFont08) // "E"
oPrint:Say(690,2825,STR0042,oFont08) // "V"
oPrint:Say(715,2825,STR0043,oFont08) // "E"
oPrint:Say(740,2825,STR0044,oFont08) // "R"
                                 
oPrint:Say(640,2865,STR0045,oFont08) // "O"
oPrint:Say(665,2865,STR0046,oFont08) // "C"
oPrint:Say(690,2865,STR0047,oFont08) // "O"
oPrint:Say(715,2865,STR0048,oFont08) // "R"
oPrint:Say(740,2865,STR0049,oFont08) // "R"

oPrint:Say(640,2897,STR0050,oFont08) // "D"
oPrint:Say(665,2897,STR0051,oFont08) // "E"
oPrint:Say(690,2897,STR0052,oFont08) // "T"
oPrint:Say(715,2897,STR0053,oFont08) // "E"
oPrint:Say(740,2897,STR0054,oFont08) // "C"

oPrint:Say(665,2950,STR0055,oFont08) // "N"
oPrint:Say(690,2950,STR0056,oFont08) // "P"
oPrint:Say(715,2950,STR0057,oFont08) // "R"
               
Return Nil

//-------------------------------------------------------. 
// Declaração das bibliotecas utilizadas no programa      |
//-------------------------------------------------------' 
#include "protheus.ch"
                                                           
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ MTA700MNU  ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 12/12/13   ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada com a finalidade de incluir uma rotina para  ¦¦¦ 
¦¦¦           ¦ ser chamada no acoes relacionadas da Previsao de Vendas       ¦¦¦ 
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MTA700MNU()

	//-------------------------------------------------------. 
	// Adiciona a nova rotina no acoes relacionadas           |
	//-------------------------------------------------------' 	
	AADD(aRotina,{"Importar Plano","U_fwImport()"	, 0 , 3,0,Nil})
	
//-------------------------------------------------------. 
// Retorno da função principal                            |
//-------------------------------------------------------' 
Return Nil                     

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ fwImport   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 12/12/13   ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina para importacao dos dados de arquivo csv para a tabela ¦¦¦ 
¦¦¦           ¦ do plano de vendas (SC4) - Tela Inicial.                      ¦¦¦ 
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function fwImport()
 //-------------------------------------------------------. 
 // Declaração das variaveis locais da função              |
 //-------------------------------------------------------' 
 Local   cCaminho := Space(100)
 Local   nRadio   := 1
 Local   nPosPrd  := 0, nPosDoc := 0, nPosQtd := 0, nPosDat := 0 , nPosVlr := 0
 Local   lRet     := .F.
 Local   aImport  := {}
 Local   nOpc     := 0
 Local   dDatPrev := CriaVar("C4_DATA")
 Local   cDocPMP  := CriaVar("C4_DOC",.T.)                  
 
 //-------------------------------------------------------. 
 // Declaração das variaveis privadas da função            |
 //-------------------------------------------------------' 
 Private nTotReg := 0 //Total de registros lidos

	//-------------------------------------------------------. 
	// Estrutura de repeticao que verifica se estã tudo       |
	// validado antes de fechar a tela de parametrização.     |
	//-------------------------------------------------------' 
	While !lRet

		//-------------------------------------------------------. 
		// Inicialização das vãriaveis de controle                |
		//-------------------------------------------------------' 
		nOpc := 0
		lRet := .F.

		//-------------------------------------------------------. 
		// Inicialização da tela de parametrização da Importacao  |
		//-------------------------------------------------------' 
		DEFINE MSDIALOG oDlg TITLE "Importação de Plano de Vendas" From 0,0 To 25,50 //Importacao de PMP's
			//-------------------------------------------------------. 
			// Tratamento dos objetos referentes a escolha do arquivo |
			//-------------------------------------------------------' 
			oSayArq := tSay():New(05,07,{|| "Informe o local onde se encontra o arquivo para importação:"},oDlg,,,,,,.T.,,,200,80) //Informe o local onde se encontra o arquivo para importação:
			oGetArq := TGet():New(15,05,{|u| If(PCount()>0,cCaminho:=u,cCaminho)},oDlg,150,10,'@!',,,,,,,.T.,,,,,,,,,,'cCaminho') 
			oBtnArq := tButton():New(15,160,"&Abrir...",oDlg,{|| cCaminho := fwDlgArq(cCaminho)},30,12,,,,.T.) //&Abrir...
			
			//-------------------------------------------------------. 
			// Tratamento objetos referentes ao Layout de importacao  |
			// Escolha das colunas de quantidade e produto no arquivo |
			//-------------------------------------------------------' 
			oSayLay := tSay():New(37,07,{|| "Informe a posição das colunas no arquivo que será importado que correspondem aos campos abaixo:"},oDlg,,,,,,.T.,,,150,80)
			oSayPrd := tSay():New(62,07,{|| RetTitle("HC_PRODUTO")},oDlg,,,,,,.T.,CLR_BLUE,,200,80)
			oGetPrd := TGet():New(60,45,{|u| If(PCount()>0,nPosPrd:=u,nPosPrd)},oDlg,10,10,'99',,,,,,,.T.,,,,,,,,,,"nPosPrd") 
			oSayQtd := tSay():New(77,07,{|| RetTitle("HC_QUANT")},oDlg,,,,,,.T.,CLR_BLUE,,200,80)
			oGetQtd := TGet():New(75,45,{|u| If(PCount()>0,nPosQtd:=u,nPosQtd)},oDlg,10,10,'99',,,,,,,.T.,,,,,,,,,,"nPosQtd") 
			oSayVlr := tSay():New(62,77,{|| RetTitle("C4_VALOR")},oDlg,,,,,,.T.,CLR_BLUE,,200,80)
			oGetVlr := TGet():New(60,115,{|u| If(PCount()>0,nPosVlr:=u,nPosVlr)},oDlg,10,10,'99',,,,,,,.T.,,,,,,,,,,"nPosVlr")			
			
			//-------------------------------------------------------. 
			// Tratamento objetos referentes ao Layout de importacao  |
			// Escolha se a data e o domento serao importados do CSV  |
			// ou informados manualmente na tela de parametros.       |
			//-------------------------------------------------------' 
			oSayLay := tSay():New(92,07,{|| "Dados que irão compor o Plano de Vendas:"},oDlg,,,,,,.T.,,,150,80)
			oSayImp := tSay():New(140,100,{|| "Coluna"},oDlg,,,,,,.T.,,,150,80)		
			oRadio  := tRadMenu():New(105,07,{"Por Digitação","Por Importação"},,oDlg,,,,,,,,60,20,,,,.T.)
			oRadio:bSetGet := {|u|Iif(PCount()==0,nRadio,nRadio:=u)}
			oRadio:bChange := {|| CntrGets(nRadio)}
		
			//-------------------------------------------------------. 
			// Tratamento objetos referentes ao Layout de importacao  |
			// Escolha das colunas de data e documento no arquivo CSV |
			//-------------------------------------------------------' 
			oSayDat  := tSay():New(132,007,{||  RetTitle("HC_DATA")},oDlg,,,,,,.T.,CLR_BLUE,,200,80)
			oGetDat1 := TGet():New(130,045,{|u| If(PCount()>0,dDatPrev:=u,dDatPrev)},oDlg,40,10,PesqPict("SC4","C4_DATA"),,,,,,,.T.,,,,,,,,,,"dDatPrev") 
			oGetDat2 := TGet():New(130,140,{|u| If(PCount()>0,nPosDat:=u,nPosDat)},oDlg,10,10,"99",,,,,,,.T.,,,,,,,,,,"nPosDat") 
			oSayDoc  := tSay():New(147,007,{||  RetTitle("HC_DOC")},oDlg,,,,,,.T.,,,200,80)
			oGetDoc1 := TGet():New(145,045,{|u| If(PCount()>0,cDocPMP:=u,cDocPMP)},oDlg,40,10,PesqPict("SC4","C4_DOC"),,,,,,,.T.,,,,,,,,,,"cDocPMP") 
			oGetDoc2 := TGet():New(145,140,{|u| If(PCount()>0,nPosDoc:=u,nPosDoc)},oDlg,10,10,"99",,,,,,,.T.,,,,,,,,,,"nPosDoc") 

			//-------------------------------------------------------. 
			// Tratamento objetos referentes ao Layout de importacao  |
			// Habilita/Desabilita a escolha das colunas Data e Doc   |
			//-------------------------------------------------------' 			
			If nRadio == 1
				oGetDat2:Disable()
				oGetDoc2:Disable()
			Else
				oGetDat1:Disable()
				oGetDoc1:Disable()
			EndIf
			
			//-------------------------------------------------------. 
			// Tratamento objetos referentes ao Layout de importacao  |
			// Botoes para confirmar ou cancelar a importacao do CSV  |
			//-------------------------------------------------------' 			
			oBtnImp := tButton():New(170,050,"Importar",oDlg,{|| nOpc:=1,oDlg:End()},40,12,,,,.T.) //Importar
			oBtnCan := tButton():New(170,110,"Cancelar",oDlg,{|| nOpc:=0,oDlg:End()},40,12,,,,.T.) //Cancelar

		//-------------------------------------------------------. 
		// Ativa a tela de parametrizacao da rotina de Importacao |
		//-------------------------------------------------------' 					
		ACTIVATE MSDIALOG oDlg CENTERED
	
		//-------------------------------------------------------. 
		// Verifica se foi pressionado o botao de confirmar.      |
		//-------------------------------------------------------'
		If nOpc == 1
			//-------------------------------------------------------. 
			// Valida se foi escolhido algum arquivo                  |
			//-------------------------------------------------------'	
			If Empty(cCaminho)
					MsgInfo("Favor informar o arquivo a ser importado!","Atenção")
					lRet := .F.
				//-------------------------------------------------------. 
				// Valida se o arquivo escolhido existe.                  |
				//-------------------------------------------------------'					
				ElseIf !File(cCaminho)
					MsgInfo("O arquivo selecionado para a importação não foi encontrado!","Atenção")
					lRet := .F.
				//-------------------------------------------------------. 
				// Arquivo validado!                                      |
				//-------------------------------------------------------'					
				Else
					lRet := .T.
			EndIf
	
			//-------------------------------------------------------. 
			// Verifica se todas as colunas foram informadas.         |
			//-------------------------------------------------------'	
			If lRet .And. (Empty(nPosPrd) .Or. Empty(nPosQtd) .Or. If(nRadio==1,Empty(dDatPrev),Empty(nPosDat)))
				MsgInfo("Os campos destacados em azul são de preenchimento obrigatório!","Atenção")
				lRet := .F.
			EndIf
		Else
			lRet := .T.
		EndIf
		
		//-------------------------------------------------------. 
		// Apos validacao inicia a leitua do arquivo.             |
		//-------------------------------------------------------'	
		If lRet .And. nOpc == 1
			//-------------------------------------------------------. 
			// Processa a leitura do arquivo csv.                     |
			//-------------------------------------------------------'	
			Processa({|| aImport := fwLerArq(cCaminho,nPosPrd,nPosQtd,nPosDat,nPosDoc,nRadio,nPosVlr)},"Processando...","Aguarde Processando a leitura do arquivo...") //Aguarde Processando a leitura do arquivo...

			//-------------------------------------------------------. 
			// Verifica a consistencia dos dados do arquivo.          |
			//-------------------------------------------------------'	
			If Len(aImport) == 0 .Or. Empty(dDatPrev)
				MsgInfo("Arquivo vazio ou data não informada!","Atenção")
			ElseIf MsgYesNo("Serão importados " +AllTrim(Str(Len(aImport))) +" registro(s) de " +AllTrim(Str(nTotReg)) +"registro(s) lido(s). Confirma?") //Serão importados registro(s) de registro(s) lido(s). Confirma?
				//-------------------------------------------------------. 
				// Processa a gravação das previsoes de venda conforme CSV|
				//-------------------------------------------------------'	
				Processa({|| aImport := fwGrvSC4(aImport,dDatPrev,cDocPMP,nRadio)},"Processando...","Gravando previsões de vendas...")
			EndIf
		
		EndIf	

	End
	
Return lRet                         

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ fwDlgArq   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 12/12/13   ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Abre dialog para selecao de arquivo CSV.                      ¦¦¦ 
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function fwDlgArq(cArquivo)

	//-------------------------------------------------------. 
	// Configura os tipos do arquivo que será importado.      |
	//-------------------------------------------------------'	
	cType 	 := "Arquivo" +" (*.csv) |*.csv|"
	cArquivo := cGetFile(cType, "Selecione o arquivo para a Importação")
	
	//-------------------------------------------------------. 
	// valida tamanho do arquivo csv.                         |
	//-------------------------------------------------------'	
	If !Empty(cArquivo)
		cArquivo += Space(100-Len(cArquivo))
	Else                                                                   
		cArquivo := Space(100)
	EndIf
	
Return cArquivo

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ fwLerArq   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 12/12/13   ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Processa a leitura do arquivo CSV.            			      ¦¦¦ 
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦ Parametros¦ cArquivo  : Caminho do arquivo a ser lido.					  ¦¦¦
¦¦¦ 		  ¦ nPosPrd   : Coluna que contem o produto.					  ¦¦¦
¦¦¦ 		  ¦ nPosQtd   : Coluna que contem o quantidade.					  ¦¦¦
¦¦¦ 		  ¦ nPosDatl  : Linha localizada a data.					  	  ¦¦¦
¦¦¦ 		  ¦ nPosDatc  : Coluna localizada a data.					  	  ¦¦¦
¦¦¦ 		  ¦ nPosDocl  : Linha localizado o documento.					  ¦¦¦
¦¦¦ 		  ¦ nPosDocc  : Coluna localizado o documento.					  ¦¦¦
¦¦¦ 		  ¦ dDataPrev : Data da previsao informada pelo usuario.		  ¦¦¦
¦¦¦ 		  ¦ cDocPMP   : Documento informado pelo usuario.		  		  ¦¦¦
¦¦¦ 		  ¦ nDigImp   : Se 1, por digitacao. Se 2 por importacao 		  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦ Retorno   ¦ aImport: Array com os registros a serem gravados.		      ¦¦¦ 
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function fwLerArq(cArquivo,nPosPrd,nPosQtd,nPosDat,nPosDoc,nDigImp,nPosVlr)
 //-------------------------------------------------------. 
 // Declaração das variáveis locais.                       |
 //-------------------------------------------------------'	
 Local cLinha  := ""
 Local cTrecho := ""
 Local nHdl    := 0
 Local cProd   := ""
 Local nQtde   := 0
 Local nVlrs   := 0 
 Local aImport := {}
 Local nX      := 0
 Local cDoc    := ""
 Local uRetPe  := Nil
 

	//-------------------------------------------------------. 
	// Abre o arquivo para manipulacao dos dados.             |
	//-------------------------------------------------------'	
	nHdl    := FT_FUSE(cArquivo)
	
	//-------------------------------------------------------. 
	// Retorna o numeros de registros totais.                 |
	//-------------------------------------------------------'	
	nTotReg := FT_FLASTREC()
	
	//-------------------------------------------------------. 
	// Posiona o ponteiro para o inicio do arquivo.           |
	//-------------------------------------------------------'	
	FT_FGOTOP()

	//-------------------------------------------------------. 
	// Inicia regua de processamento com o total de registros |
	//-------------------------------------------------------'	
	ProcRegua(nTotReg)
	
	//-------------------------------------------------------. 
	// Loop para percorrer todos os registros do arquivo      |
	//-------------------------------------------------------'	
	While !FT_FEOF()
		//-------------------------------------------------------. 
		// Inicialização das variaveis auxiliares.                |
		//-------------------------------------------------------'	
		cProd  := CriaVar("C4_PRODUTO",.F.)
		nQtde  := CriaVar("C4_QUANT"  ,.F.)  
		nVlrs  := CriaVar("C4_VALOR"  ,.F.)
		cDoc   := CriaVar("C4_DOC"    ,.T.)
		dData  := dDataBase		
		nX     := 0

		//-------------------------------------------------------. 
		// Realiza leitura na linha do arquivo.                   |
		//-------------------------------------------------------'	
		cLinha := FT_FREADLN()    
		
		//-------------------------------------------------------. 
		// Loop para percorrer a linha inteira.                   |
		//-------------------------------------------------------'	
		While !Empty(cLinha)
			//-------------------------------------------------------. 
			// Incremento na variavel de controle de campos.          |
			//-------------------------------------------------------'	
			nX++                                             
			
			//-------------------------------------------------------. 
			// Forma o trecho de acordo com o caracter ';' (csv)      |
			//-------------------------------------------------------'	
			cTrecho := If(At(";",cLinha)>0,Substr(cLinha,1,At(";",cLinha)-1),cLinha)
			cLinha  := If(At(";",cLinha)>0,Substr(cLinha,  At(";",cLinha)+1),"")
			
			//-------------------------------------------------------. 
			// Verifica pela coluna qual campo sera preenchido        |
			//-------------------------------------------------------'	
			Do Case
				Case nDigImp == 2 .And. nPosDoc == nX
					cDoc := Padr(cTrecho,TamSX3("C4_DOC")[1])
				Case nDigImp == 2 .And. nPosDat == nX
					dData := CToD(cTrecho)
				Case nPosPrd == nX
					cProd := Padr(cTrecho,TamSX3("C4_PRODUTO")[1])
				Case nPosQtd == nX
					If cPaisLoc # "EUA"
						cTrecho := StrTran(cTrecho,".","")
						cTrecho := StrTran(cTrecho,",",".")
					EndIf
					nQtde := Val(cTrecho) 
				Case nPosVlr == nX
					If cPaisLoc # "EUA"
						cTrecho := StrTran(cTrecho,".","")
						cTrecho := StrTran(cTrecho,",",".")
					EndIf
					nVlrs := Val(cTrecho)					
			EndCase
		End          
		
		//-------------------------------------------------------. 
		// Posiciona no cadastro de produto para validacao        |
		//-------------------------------------------------------'	
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek(xFilial("SB1")+cProd) .And. !Empty(nQtde)	
			//-------------------------------------------------------. 
			// Inclui registro para a importacao da Prev. de Venda    |
			//-------------------------------------------------------'	
			aAdd(aImport, {cProd,nQtde,dData,cDoc,SB1->B1_OPC,uRetPe, SB1->B1_LOCPAD, nVlrs})
		EndIf	
		
		//-------------------------------------------------------. 
		// Inclui barra na regua de processamento.                |
		//-------------------------------------------------------'	
		IncProc()
	
		//-------------------------------------------------------. 
		// Pula para o proximo registro do arquivo.               |
		//-------------------------------------------------------'	
		FT_FSKIP()
	End
	FT_FUSE()
	
Return aImport

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ fwGrvSC4   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 12/12/13   ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ FuncaoProcessa a gravacao do SC4 a partir do arquivo CSV.     ¦¦¦ 
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function fwGrvSC4(aImport,dDatPrev,cDocPMP,nDigImp)
 Local nX := 0
 	
	//-------------------------------------------------------. 
	// Seleciona a tabela de previsao de vendas.              |
	//-------------------------------------------------------'	
	dbSelectArea("SC4")                               
	
	//-------------------------------------------------------. 
	// Inicia regua de processamento com o total de registros |
	//-------------------------------------------------------'	
	ProcRegua(Len(aImport))
	
	//-------------------------------------------------------. 
	// Inicia uma transação segura no banco de dados.         |
	//-------------------------------------------------------'	
	Begin Transaction

		//-------------------------------------------------------. 
		// Loop para percorrer os dados a serem importados.       |
		//-------------------------------------------------------'	
		For nX := 1 To Len(aImport)
	
			//-------------------------------------------------------. 
			// Abri um novo registro para gravação da prev. de venda  |
			//-------------------------------------------------------'	
			RecLock("SC4",.T.)
				Replace C4_FILIAL  With xFilial("SC4")
				Replace C4_PRODUTO With aImport[nX,1]
				Replace C4_QUANT   With aImport[nX,2]
				Replace C4_DATA    With If(nDigImp==1,dDatPrev,aImport[nX,3])
				Replace C4_DOC     With If(nDigImp==1,cDocPMP,aImport[nX,4])
				Replace C4_OPC     With aImport[nX,5]
				Replace C4_LOCAL   With aImport[nX,7] 
				Replace C4_VALOR   With aImport[nX,8]  
				Replace C4_GERACAO With "A"				
			//-------------------------------------------------------. 
			// Finaliza e confirma a gravação da previsão de venda    |
			//-------------------------------------------------------'	
			MsUnLock()			
			IncProc()
		Next nX
	End Transaction               
	
	MsgInfo("Importação concluída!","Previsao de vendas")
	
Return                                                                                

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ CntrGets   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 12/12/13   ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Funcao para controlar exibicao de paineis.                    ¦¦¦ 
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CntrGets(nOpcao)
	//-------------------------------------------------------. 
	// Verifica se a data e o documento sera por importação   |
	// ou por digitação de acordo o radio buttom              |
	//-------------------------------------------------------'	
	If nOpcao == 1
		//-------------------------------------------------------. 
		// Habilita dados referente a importação.                 |
		//-------------------------------------------------------'	
		oGetDat1:Enable()
		oGetDoc1:Enable()
		oGetDat2:Disable()
		oGetDoc2:Disable()
	Else
		//-------------------------------------------------------. 
		// Habilita dados referente a digitação.                  |
		//-------------------------------------------------------'	
		oGetDat1:Disable()
		oGetDoc1:Disable()
		oGetDat2:Enable()
		oGetDoc2:Enable()
	EndIf
	
Return Nil 

/*********************************************************************************** 
*       AA        LL         LL         EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   *
*      AAAA       LL         LL         EE         CC        KK    KK   SS         *
*     AA  AA      LL         LL         EE        CC         KK  KK     SS         *
*    AA    AA     LL         LL         EEEEEEEE  CC         KKKK        SSSSSSS   *
*   AAAAAAAAAA    LL         LL         EE        CC         KK  KK            SS  *
*  AA        AA   LL         LL         EE         CC        KK    KK          SS  *
* AA          AA  LLLLLLLLL  LLLLLLLLL  EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   * 
************************************************************************************
*         I want to change the world, but nobody gives me the source code!         * 
************************************************************************************/ 
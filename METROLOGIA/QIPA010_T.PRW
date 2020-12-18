#Include "QIPA010.CH"                                        
#Include "PROTHEUS.CH"

#Define _ROT 1 //Roteiro
#Define _OPE 2 //Operacao
#Define _RAS 3 //Rastreabilidade 
#Define _TXT 4 //Observacoes da Operacao                                                                                 
#Define _ENS 5 //Ensaio
#Define _INS 6 //Instrumentos
#Define _NCO 7 //Nao-conformidades
#Define _PAE 8 //Plano de Amostragem por Ensaio

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QIPA010   ³ Autor ³ Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa de atualizacao das Especificacoes de Produtos     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ SIGAQIP													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³STR 	     ³ Ultimo utilizado -> STR0000                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			   ³        ³	   ³										  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QIPA010()
//Local cAlias   := " "            
Local aRetorno := {}

Private cCadastro 
Private lProduto
Private lAPS   
Private lFase3   := IIF(QP6->(FieldPos("QP6_SITREV"))<>0,.T.,.F.)   
Private lDuplDoc := .T.  
Private lIncF4   :=.F.
Private cPrioriR := GetMv("MV_QIPOPEP",.F.,"2") //Prioriza dados do Roteiro/Operacoes de 1 = Materiais / 2 - Quality
Private lCarRot := .T. // Indica se devera carregar o array de roteiros/operacoes 

Private __cENSAIO := " "

AjustaSX3()
AjustaSXB()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de Especificacoes				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aRetorno := QPA010Tipo() //Define se a Especificacao sera por Grupo ou Produto     

If !aRetorno[1]
	Return (NIL)
Else
	lProduto := aRetorno[2]	
EndIf 

If lProduto
	QIPA012()
Else
	QIPA011()
EndIf

dbClearFilter()

Return(NIL)                                 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QPA010Grv ³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Atualiza os dados referentes a Especificacao do Produto    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QPA010Grv(cAlias,nOpc)			 			              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPN1 = Alias											  ³±±
±±³			 ³ EXPN1 = Opcao do aRotina									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ 		 = Nulo												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function  QPA010Grv(cAlias,nOpc)
Local cRevisao := " "
Local aAreaQP6 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Especificacao por Produto									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
If lProduto                      

	If (nOpc == 3 .Or. nOpc == 4) //Inclusao ou Alteracao

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o SB1 (Cadastro de Produtos); 						 ³
		//³ o QP6 deve ser posicionado no momento.						 ³ 
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		QP010AtuSB1(__cPRODUTO)        
			     
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de Entrada Final da Alteracao da Especificacao - JNJ   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If __lQPATUSB1
			ExecBlock("QPATUSB1",.F.,.F.,{nOpc})
		EndIf	           
		
	EndIf
		                                
	//Atualizacao dos dados referentes a Especificacao do Produto 
	QPAAtuEsp(__cPRODUTO,__cREVISAO,,nOpc)
		
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Especificacao por Grupo de Produtos							 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
                                         
	//Atualiza Especificacao por Grupo de Produtos
	QPAAtuEsp(__cPRODUTO,__cREVISAO,.T.,nOpc)

	//Salva a Area do QP6
	aAreaQP6 := QP6->(GetArea())
        
	//Atualiza os Produtos relacionados ao Grupo
	QPA->(dbSetOrder(1))
	QPA->(dbSeek(xFilial("QPA")+__cGRPPROD))
	While QPA->(!Eof()) .And. QPA->QPA_FILIAL==xFilial("QPA") .And.;
		QPA->QPA_GRUPO == __cGRPPROD
		cRevisao := QA_UltRvQ(QPA->QPA_PRODUT,,,.T.)
		       
		QP6->(dbSetorder(1))
		QP6->(dbSeek(xFilial("QP6")+QPA->QPA_PRODUT+Inverte(cRevisao)))
		If QP6->(!Eof())
			RecLock("QP6",.F.)
			QP6->QP6_CODREC := __cROTEIRO
			MsUnLock()	
	
			QPAAtuEsp(QPA->QPA_PRODUT,cRevisao,,nOpc)
			
		EndIf    
		QPA->(dbSkip())					
	EndDo        

	//Restaura a Area do QP6
	RestArea(aAreaQP6)
		
EndIf        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza os dados referentes a Especificacao do Produto      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RecLock(cAlias,If(nOpc==3,.T.,.F.))
If (nOpc == 5)	
	(cAlias)->(dbDelete())
	MsUnLock()                
EndIf

If (nOpc == 3) //Inclusao
	If lProduto
		QP6->QP6_FILIAL := xFilial("QP6")
		QP6->QP6_CADR   := cUserName
		QP6->QP6_DTCAD  := dDataBase 
	Else     
		QQC->QQC_GRUPO  := M->QQC_GRUPO 
		QQC->QQC_REVI   := M->QQC_REVI   
		QQC->QQC_DTINI  := M->QQC_DTINI  
		QQC->QQC_CODREC := M->QQC_CODREC                           
	EndIf
EndIf                                    
    
If (nOpc == 3 .Or. nOpc == 4) //Inclusao ou Alteracao
	SX3->(dbSetorder(1))
	SX3->(dbSeek(cAlias))
	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == cAlias
		If X3Uso(SX3->X3_USADO)                                      
			If SX3->X3_CONTEXT <> "V"
				If !(AllTrim(SX3->X3_CAMPO) $ "QQC_GRUPOßQQC_REVIßQQC_DTINIßQQC_CODREVßQQC_REVINV")
					FieldPut(FieldPos(AllTrim(SX3->X3_CAMPO)),&("M->"+SX3->X3_CAMPO))
				EndIf	
			EndIf                         
	    EndIf
	    SX3->(dbSkip())
	EndDo
EndIf

If (nOpc == 3) //Grava a Revisao invertida do Produto ou Grupo
	If lProduto
		QP6->QP6_REVINV := Inverte(QP6->QP6_REVI)
	Else
		QQC->QQC_REVINV := Inverte(QQC->QQC_REVI)
	EndIf
EndIf
MsUnLock()   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava Revisao Invertida especificacao por produto			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (nOpc == 3) .and. !lProduto //Inclusao
	//Grava a Revisao Invertida da Especificacao por Grupo
	RecLock(cAlias,.F.)
	QQC->QQC_REVINV := Inverte(QQC->QQC_REVI)
	MsUnlock()               
EndIf                                           	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava o Historico da Especificacao do Produto ou Grupo		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lProduto
	If (nOpc == 3) .Or. (nOpc == 4) //Inclusao/Alteracao
		MsMM(QP6_HISTOR,,,M->QP6_MEMO1,1,,,"QP6","QP6_HISTOR")

	ElseIf (nOpc == 5)	//Exclusao
		MSMM(QP6_HISTOR,,,,2)
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada especifico para o cliente JNJ				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
If __lQP010J11
	ExecBlock('QP010J11',.F.,.F.)
EndIf
	
Return(NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QPAAtuEsp ³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Atualiza os dados referentes ao Roteiro de Operacoes		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QPAAtuEsp(cProduto,cRevisao,cRoteiro,lGrupo,nOpc)	      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPC1 = Codigo do Produto								  ³±±
±±³			 ³ EXPC2 = Revisao do Produto								  ³±±
±±³			 ³ EXPL1 = Indica se a Especificacao e por Grupo 			  ³±±
±±³			 ³ EXPN1 = Opcao do aRotina									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QPAAtuEsp(cProduto,cRevisao,lGrupo,nOpc)
Local aAreaAnt   := GetArea()
Local nRot       := 0
Local nOper      := 0
Local nEns       := 0
Local nIns       := 0
Local nNco       := 0
Local nRas       := 0
Local nPAE       := 0
Local nPosDelOpe := 0
Local nPosDelEns := 0         
Local nPosDelIns := 0
Local nPosDelRas := 0
Local nPosDelPAE := 0 
Local cRoteiro   := " "
Local cOperacao  := " "
Local cEnsaio    := " "
Local cNorma     := " " 
Local nCpo       := 0
Local cAlias     := " "
Local cConteudo  := " "
Local nDec       := 0
Local nLIE       := 0
Local nLSE       := 0
Local cVlrLIE    := " "
Local cVlrLSE    := " "
Local aTexto     := {}
Local cTxtOpe    := " "
Local cChave     := " "
Local aAreaQQK   := {}      
Local cRvDoc     := ""
                           
lGrupo := If(lGrupo==NIL,.F.,lGrupo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizacao das Operacoes 									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nRot := 1 to Len(aEspecificacao) 
	
	//Armazena a Roteiro corrente
	cRoteiro := aEspecificacao[nRot,_ROT]
	
	If !Empty(cRoteiro) //Verifica se existe Roteiro Vazio
	                  
		For nOper := 1 to Len(aEspecificacao[nRot,_OPE])
		
			If nOper > Len(aEspecificacao[nRot,_ENS])  
				Exit
			EndIF
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualizacao das Operacoes									 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			//Armazena a Operacao corrente
			cOperacao := aEspecificacao[nRot,_OPE,nOper,nPosOper]
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ponto especifico para gravacao da Atualizacao				 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If __lQPA010R
				If __cROTEIRO == "01" .And. cOperacao == "01"
					ExecBlock("QPA010R",.F.,.F.,{ALTERA})
				EndIf
			EndIf
			
			If !Empty(aEspecificacao[nRot,_OPE,nOper,nPosOper])
				
				nPosDelOpe := Len(aEspecificacao[nRot,_OPE,nOper]) //Indica se esta deletado
				
				QQK->(dbSetOrder(1))
				QQK->(dbSeek(xFilial("QQK")+cProduto+cRevisao+cRoteiro+aEspecificacao[nRot,_OPE,nOper,nPosOper]))
				
				If !aEspecificacao[nRot,_OPE,nOper,nPosDelOpe] .And. nOpc <> 5 //Exclusao
					
					If QQK->(!Eof())
						RecLock("QQK",.F.)
					Else
						RecLock("QQK",.T.)
						QQK->QQK_FILIAL := xFilial("QQK")
						QQK->QQK_CODIGO	:= cRoteiro
						QQK->QQK_OPERAC	:= cOperacao
						QQK->QQK_PRODUT := cProduto
						QQK->QQK_REVIPR	:= cRevisao
					EndIf
					
					For nCpo := 1 to Len(aHeaderQQK)
						If aHeaderQQK[nCpo,10] <> "V" .And.;
							AllTrim(aHeaderQQK[nCpo,2]) <> "QQK_OPERAC"  //nao considera o campo Operacao, pois o mesmo faz poarte da chave
							QQK->(FieldPut(FieldPos(AllTrim(aHeaderQQK[nCpo,2])),;
							aEspecificacao[nRot,_OPE,nOper,nCpo]))
						EndIf
					Next nCpo                      
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza o Identificador do Roteiro Secundario				 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (__cROTEIRO <> cRoteiro)
						QQK->QQK_ROTALT := cRoteiro
					EndIf
					MsUnLock() 
					FKCOMMIT()
					
					//Atualiza a Chave de Ligacao da Operacao
					If Empty(QQK->QQK_CHAVE)
						aAreaQQK := QQK->(GetArea())
						dbSelectArea("QQK")
						dbSetOrder(2)
						cChave := QA_SXESXF("QQK","QQK_CHAVE",,2)
						ConfirmSX8()
						RestArea(aAreaQQK)
						
						RecLock("QQK",.F.)
						QQK->QQK_CHAVE := cChave
						MsUnLock()
						aEspecificacao[nRot,_OPE,nOper,nPosChav] := cChave
					EndIf
				EndIf
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualizacao do Texto associado a Operacao                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(aEspecificacao[nRot,_OPE,nOper,nPosChav]) //Se a chave nao estiver vazia
				If QQK->(!Deleted())
					cTxtOpe := aEspecificacao[nRot,_TXT,nOper]
					aTexto  := {{1,cTxtOpe}}
					
					//Atualiza o Texto relacionado a Operacao
					QA_GrvTXT(aEspecificacao[nRot,_OPE,nOper,nPosChav],cEspecie,1,aTexto)  
				Else
					//Exclui o Texto relacionado a Operacao
					QA_DelTXT(aEspecificacao[nRot,_OPE,nOper,nPosChav],cEspecie)
					
				EndIf
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualizacao dos Ensaios										 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nEns := 1 to Len(aEspecificacao[nRot,_ENS,nOper])
				
				//Armazena o Ensaio corrente
				cEnsaio := aEspecificacao[nRot,_ENS,nOper,nEns,nPosEns]
				
				//Armazena a Norma de Inspecao utilizada no Plano de Amostragem
				cNorma := aEspecificacao[nRot,_ENS,nOper,nEns,nPosPlA]
				cNorma := If(!Empty(cNorma),QA_Plano(cNorma),cNorma)
				
				//Verifica se o Ensaio esta em branco
				If !Empty(aEspecificacao[nRot,_ENS,nOper,nEns,nPosEns])
					
					nPosDelEns := Len(aEspecificacao[nRot,_ENS,nOper,nEns]) //Indica se esta deletado
					
					QP1->(dbSetOrder(1))
					QP1->(dbSeek(xFilial("QP1")+aEspecificacao[nRot,_ENS,nOper,nEns,nPosEns]))
					If QP1->QP1_TPCART <> "X" //Mensuraveis
						cAlias    := "QP7"
						cConteudo := "QP8_TEXTOßQQK_OPERGR"
					Else //Texto
						cAlias    := "QP8"
						cConteudo := "QP7_UNIMEDßQP7_NOMINAßQP7_AFIßQP7_AFSßQP7_LICßQP7_LSCßQP7_MINMAXßQQK_OPERGR"
					EndIf
					
					(cAlias)->(dbSetOrder(1))
					(cAlias)->(dbSeek(xFilial(cAlias)+cProduto+cRevisao+cRoteiro+cOperacao+aEspecificacao[nRot,_ENS,nOper,nEns,nPosEns]))
					
					//Verifica se o Ensaio nao esta marcado para exclusao
					If !aEspecificacao[nRot,_ENS,nOper,nEns,nPosDelEns] .And. nOpc <> 5 //Exclusao
						
						If (cAlias)->(!Eof())
							RecLock(cAlias,.F.)
						Else
							If !Empty(aEspecificacao[nRot,_ENS,nOper,nEns,nPosDoc])
								cRvDoc := QA_UltRvDc(aEspecificacao[nRot,_ENS,nOper,nEns,nPosDoc],dDataBase,.f.,.f.)
							EndIF						
							RecLock(cAlias,.T.)
							(cAlias)->&(cAlias+"_FILIAL") := xFilial(cAlias)
							(cAlias)->&(cAlias+"_PRODUT") := cProduto
							(cAlias)->&(cAlias+"_REVI")   := cRevisao
							(cAlias)->&(cAlias+"_CODREC") := cRoteiro
							(cAlias)->&(cAlias+"_OPERAC") := cOperacao    
							(cAlias)->&(cAlias+"_RVDOC")  := cRvDoc
						EndIf
						
						For nCpo := 1 to Len(aHeaderQP7)
							If aHeaderQP7[nCpo,10] <> "V"
								If !(AllTrim(aHeaderQP7[nCpo,2]) $ cConteudo)
									(cAlias)->(FieldPut(FieldPos(cAlias+SubStr(AllTrim(aHeaderQP7[nCpo,2]),4)),;
									aEspecificacao[nRot,_ENS,nOper,nEns,nCpo]))
								EndIf
							EndIf
						Next nCpo
						MsUnLock()   
						FKCOMMIT()
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Calcula e atualiza o LIE e LSE							     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If cAlias == "QP7"  
						
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Efetua e Atualiza o Calculo em polegadas					 ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If At(":",AllTrim(QP7->QP7_NOMINA)) > 0
							   	If QP7_MINMAX $ "1.2"   //Minimo ou Minimo e Maximo
									cVlrLIE := CalcHora(aEspecificacao[nRot,_ENS,nOper,nEns,nPosNom],aEspecificacao[nRot,_ENS,nOper,nEns,nPosAFI],"I")
								EndIf
		       		            If QP7_MINMAX $ "1.3"   //Maximo ou Minimo e Maximo
									cVlrLSE := CalcHora(aEspecificacao[nRot,_ENS,nOper,nEns,nPosNom],aEspecificacao[nRot,_ENS,nOper,nEns,nPosAFS],"S")
								EndIF
							ElseIf At('i',AllTrim(QP7->QP7_NOMINA)) > 0
							   	If QP7_MINMAX $ "1.2"   //Minimo ou Minimo e Maximo
									cVlrLIE := qCalPol({aEspecificacao[nRot,_ENS,nOper,nEns,nPosNom],aEspecificacao[nRot,_ENS,nOper,nEns,nPosAFI]},1,QP7->QP7_LIE)
								EndIF
		       		            If QP7_MINMAX $ "1.3"   //Maximo ou Minimo e Maximo
									cVlrLSE := qCalPol({aEspecificacao[nRot,_ENS,nOper,nEns,nPosNom],aEspecificacao[nRot,_ENS,nOper,nEns,nPosAFS]},1,QP7->QP7_LSE)
								EndIf
							Else
							   	If QP7_MINMAX $ "1.2"   //Minimo ou Minimo e Maximo
									nLIE    := SuperVal(aEspecificacao[nRot,_ENS,nOper,nEns,nPosNom])+SuperVal(aEspecificacao[nRot,_ENS,nOper,nEns,nPosAFI])
								EndIF
		       		            If QP7_MINMAX $ "1.3"   //Maximo ou Minimo e Maximo
									nLSE    := SuperVal(aEspecificacao[nRot,_ENS,nOper,nEns,nPosNom])+SuperVal(aEspecificacao[nRot,_ENS,nOper,nEns,nPosAFS])
								EndIf
								If cPaisLoc <> "MEX"
			                       nDec := If(","$AllTrim(QP7->QP7_NOMINA),Len(AllTrim(QP7->QP7_NOMINA))-At(",",AllTrim(QP7->QP7_NOMINA)),0)  	
								   cVlrLIE := AllTrim(StrTran(Str(nLIE,TamSX3("QP7_LIE")[1],nDec),".",","))
								   cVlrLSE := AllTrim(StrTran(Str(nLSE,TamSX3("QP7_LSE")[1],nDec),".",","))
							    Else
							       nDec := If("."$AllTrim(QP7->QP7_NOMINA),Len(AllTrim(QP7->QP7_NOMINA))-At(".",AllTrim(QP7->QP7_NOMINA)),0)  	
								   cVlrLIE := AllTrim(StrTran(Str(nLIE,TamSX3("QP7_LIE")[1],nDec),",","."))
								   cVlrLSE := AllTrim(StrTran(Str(nLSE,TamSX3("QP7_LSE")[1],nDec),",","."))
							    Endif
							EndIf						
							RecLock("QP7",.F.)
							QP7->QP7_LIE := cVlrLIE
							QP7->QP7_LSE := cVlrLSE
							MsUnlock()
							
						EndIf
					Else
						If (cAlias)->(!Eof())
							RecLock(cAlias,.F.)
							dbDelete()
							MsUnLock()
						EndIf
						
					EndIf
					
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza a Familia de Instrumentos							 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				For nIns := 1 to Len(aEspecificacao[nRot,_INS,nOper,nEns])
					
					If !Empty(aEspecificacao[nRot,_INS,nOper,nEns,nIns,nPosInstr])
						
						nPosDelIns := Len(aEspecificacao[nRot,_INS,nOper,nEns,nIns]) //Indica se esta deletado
						
						QQ1->(dbSetOrder(3))
						QQ1->(dbSeek(xFilial("QQ1")+cProduto+cRevisao+cRoteiro+cOperacao+cEnsaio+aEspecificacao[nRot,_INS,nOper,nEns,nIns,nPosInstr]))
						
						If !aEspecificacao[nRot,_INS,nOper,nEns,nIns,nPosDelIns] .And. nOpc <> 5 //Exclusao
							
							If QQ1->(!Eof())
								RecLock("QQ1",.F.)
							Else
								RecLock("QQ1",.T.)
								QQ1->QQ1_FILIAL	:= xFilial("QQ1")
								QQ1->QQ1_PRODUT	:= cProduto
								QQ1->QQ1_REVI	:= cRevisao
								QQ1->QQ1_ROTEIR	:= cRoteiro
								QQ1->QQ1_OPERAC	:= cOperacao
								QQ1->QQ1_ENSAIO	:= cEnsaio
								QQ1->QQ1_INSTR	:= aEspecificacao[nRot,_INS,nOper,nEns,nIns,nPosInstr]
							EndIf
							QQ1->QQ1_DESCR := aEspecificacao[nRot,_INS,nOper,nEns,nIns,nPosDescr]
							MsUnLock()
							
						Else
							If QQ1->(!Eof())
								RecLock("QQ1",.F.)
								dbDelete()
								MsUnLock()
							EndIf
							
						EndIf
						
					EndIf
					
				Next nIns
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza as Nao-Conformidades associadas					 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				For nNco := 1 to Len(aEspecificacao[nRot,_NCO,nOper,nEns])
					
					If !Empty(aEspecificacao[nRot,_NCO,nOper,nEns,nNco,nPosNc])
						
						nPosDelNco := Len(aEspecificacao[nRot,_NCO,nOper,nEns,nNco]) //Indica se esta deletado
						
						QP9->(dbSetOrder(3))
						QP9->(dbSeek(xFilial("QP9")+cProduto+cRevisao+cRoteiro+cOperacao+cEnsaio+aEspecificacao[nRot,_NCO,nOper,nEns,nNco,nPosNc]))
						
						If !aEspecificacao[nRot,_NCO,nOper,nEns,nNco,nPosDelNco]	 .And. nOpc <> 5 //Exclusao
							If QP9->(!Eof())
								RecLock("QP9",.F.)
							Else
								RecLock("QP9",.T.)
								QP9->QP9_FILIAL	:= xFilial("QP9")
								QP9->QP9_PRODUT	:= cProduto
								QP9->QP9_REVI	:= cRevisao
								QP9->QP9_ROTEIR	:= cRoteiro
								QP9->QP9_OPERAC	:= cOperacao
								QP9->QP9_ENSAIO	:= cEnsaio
								QP9->QP9_NAOCON := aEspecificacao[nRot,_NCO,nOper,nEns,nNco,nPosNc]
							EndIf
							QP9->QP9_CLASSE := aEspecificacao[nRot,_NCO,nOper,nEns,nNco,nPosCla]
							MsUnLock()
							
						Else
							If QP9->(!Eof())
								RecLock("QP9",.F.)
								dbDelete()
								MsUnLock()
							EndIf
							
						EndIf
						
					EndIf
					
				Next nNco
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza o Plano de Amostragem por Ensaio					 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				For nPAE := 1 to Len(aEspecificacao[nRot,_PAE,nOper,nEns])
					
					nPosDelPAE := Len(aEspecificacao[nRot,_PAE,nOper,nEns,nPAE]) //Indica se esta deletado
					
					QQH->(dbSetOrder(1))
					QQH->(dbSeek(xFilial("QQH")+cProduto+cRevisao+cRoteiro+cOperacao+cEnsaio))
					
					If !aEspecificacao[nRot,_PAE,nOper,nEns,nPAE,nPosDelPAE] .And. nOpc <> 5 //Exclusao
						
						If !Empty(aEspecificacao[nRot,_PAE,nOper,nEns,nPAE,nPosNQA]) .Or. Alltrim(aEspecificacao[nRot,_PAE,nOper,nEns,nPAE,nPosAmo])=="TX"
							If QQH->(!Eof())
								RecLock("QQH",.F.)
							Else
								RecLock("QQH",.T.)
								QQH->QQH_FILIAL	:= xFilial("QQH")
								QQH->QQH_PRODUT	:= cProduto
								QQH->QQH_REVI	:= cRevisao
								QQH->QQH_CODREC	:= cRoteiro
								QQH->QQH_OPERAC	:= cOperacao
								QQH->QQH_ENSAIO	:= cEnsaio
							EndIf
							QQH->QQH_PLANO  := aEspecificacao[nRot,_PAE,nOper,nEns,nPAE,nPosPlano]
							QQH->QQH_NQA    := aEspecificacao[nRot,_PAE,nOper,nEns,nPAE,nPosNQA]
							QQH->QQH_NIVAMO := aEspecificacao[nRot,_PAE,nOper,nEns,nPAE,nPosNivel]
							If QQH->QQH_PLANO == "INTERN"
								QQH->QQH_AMOST := "PI"
							Else
								QQH->QQH_AMOST  := aEspecificacao[nRot,_PAE,nOper,nEns,nPAE,nPosAmo]
							Endif
							If QQH->QQH_PLANO="TEXTO"
								QQH->QQH_DESCRI := aEspecificacao[nRot,_ENS,nOper,nEns,nPosDPl]
							EndIF
							MsUnLock()
						EndIf
						
					Else
						If QQH->(!Eof())
							RecLock("QQH",.F.)
							dbDelete()
							MsUnLock()
						EndIf
					EndIf
					
				Next nPAE
				
			Next nEns
			
			//Exclusao do roteiro de operações
			If !Empty(aEspecificacao[nRot,_OPE,nOper,nPosOper])
				
				nPosDelOpe := Len(aEspecificacao[nRot,_OPE,nOper]) //Indica se esta deletado
				
				QQK->(dbSetOrder(1))
				QQK->(dbSeek(xFilial("QQK")+cProduto+cRevisao+cRoteiro+aEspecificacao[nRot,_OPE,nOper,nPosOper]))
				
				If aEspecificacao[nRot,_OPE,nOper,nPosDelOpe] .Or. nOpc == 5 //Exclusao
					                       
					//Verifica se ira excluir tambem a operação da tabela SG2
					If lDelSG2					
						dbSelectArea("SG2")
						dbSetOrder(1)
						If dbSeek(xFilial("SG2")+cProduto+cRoteiro+aEspecificacao[nRot,_OPE,nOper,nPosOper])
							RecLock("SG2",.F.)                                   
							dbDelete()
							MsUnLock()						
						EndIF
					EndIF
										
					If QQK->(!Eof())
						dbSelectArea("QQK")
						RecLock("QQK",.F.)                                   
						dbDelete()
						MsUnLock()
					EndIf
				EndIF
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualizacao da Rastreabilidade								 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nRas := 1 to Len(aEspecificacao[nRot,_RAS,nOper])
				
				If !Empty(aEspecificacao[nRot,_RAS,nOper,nRas,nPosRastr])
					
					nPosDelRas := Len(aEspecificacao[nRot,_RAS,nOper,nRas]) //Indica se esta deletado
					
					QQ2->(dbSetorder(1))
					QQ2->(dbSeek(xFilial("QQ2")+cProduto+cRevisao+cRoteiro+cOperacao+aEspecificacao[nRot,_RAS,nOper,nRas,nPosRastr]))
					
					If !aEspecificacao[nRot,_RAS,nOper,nRas,nPosDelRas] .And. nOpc <> 5 //Exclusao
						
						If QQ2->(!Eof())
							RecLock("QQ2",.F.)
						Else
							RecLock("QQ2",.T.)
							QQ2->QQ2_FILIAL := xFilial("QQ2")
							QQ2->QQ2_CODIGO	:= cProduto
							QQ2->QQ2_REVI	:= cRevisao
							QQ2->QQ2_ROTEIR	:= cRoteiro
							QQ2->QQ2_OPERAC	:= cOperacao
						EndIf
						
						For nCpo := 1 to Len(aHeaderQQ2)
							If aHeaderQQ2[nCpo,10] <> "V"
								QQ2->(FieldPut(FieldPos(AllTrim(aHeaderQQ2[nCpo,2])),;
								aEspecificacao[nRot,_RAS,nOper,nRas,nCpo]))
							EndIf
						Next nCpo
						MsUnLock()
						
					Else
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Ponto de Entrada para exclusao do QQ2 (especifico JNJ)		 ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If __lQP010DEL
							ExecBlock("QP010DEL",.F.,.F.,{cProduto,cRevisao,cRoteiro,.F.})
						Else
							If QQ2->(!Eof())
								RecLock("QQ2",.F.)
								dbDelete()
								MsUnLock()
							EndIf
						EndIf
						
					EndIf
					
				EndIf
				
			Next nRas
			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ P.E. para Atualizacao da Especificacao						 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If __lQP010GRV
				ExecBlock("QP010GRV",.F.,.F.,{cProduto,cRevisao,cRoteiro,cOperacao})
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ P.E. para exclusao do QQ2, apos excluir a operacao corrente  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If QQK->(deleted())
				If __lQP010OPE
					ExecBlock("QP010OPE",.F.,.F.,{cProduto,cRoteiro,cOperacao,cRevisao})
				EndIf
			EndIf
			
		Next nOper
	
	EndIf
	
Next nRot
                  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Integracao QIP x PCP										 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
QAtuMatQIP(cProduto,cRevisao,cRoteiro,"QIP",If(nOpc==5,.T.,.F.),cPrioriR)

RestArea(aAreaAnt)
Return(NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QPA010FilEsp³Autor³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Preenche o vetor aESPECIFICACAO com os dados referentes a  ³±±
±±³			 ³ Especificacao do Produto.								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QPA010FilEsp(cProduto,cRevisao,cRoteiro)					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPC1 = Codigo do Produto								  ³±±
±±³			 ³ EXPC2 = Revisao do Produto								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NULO														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QPA010FilEsp(cProduto,cRevisao,cRotPri)
Local nX
Local nY  
Local nW          
Local aEspAux  := {}
Local cEspecie := "QIPA010 "             //Texto do Produto  
Local cRoteiro := ""
Local nTamLin  := TamSX3("QA2_TEXTO")[1]
Local aTexto   := {}
Local cChave   := " "  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Preenche o vetor aESPECIFICACAO com os roteiros de operacoes ³
//³ vinculados a Especificacao do Produto.						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

QQK->(dbSetOrder(1))
If QQK->(dbSeek(xFilial("QQK")+cProduto+cRevisao))
	While QQK->(!EOF()) .and. QQK->QQK_PRODUT+QQK->QQK_REVIPR == cProduto+cRevisao
		
		If  Ascan(aEspecificacao,{|x|Alltrim(x[1])==QQK->QQK_CODIGO})==0
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³                   Estrutura do Vetor aESPECIFICACAO                    ³
			//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
			//³      Elemento      ³                     Descricao                     ³
			//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
			//³  [01,ROT]          ³ Roteiro de Operacoes						       ³
			//³  [02,OPE]          ³ Operacoes									       ³
			//³  [03,OPE,TXT]      ³ Texto do Produto por Operacao					   ³
			//³  [04,OPE,RAS]      ³ Rastreabilidade das Operacoes					   ³
			//³  [05,OPE,ENS]      ³ Ensaios associados aos Roteiros                   ³
			//³  [06,OPE,ENS,INS]  ³ Familia de Instrumentos				           ³
			//³  [07,OPE,ENS,NCO]  ³ Nao-Conformidades associadas aos Ensaios	 	   ³
			//³  [08,OPE,ENS,PAE]  ³ Plano de Amostragem por Ensaios				   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			AADD(aEspecificacao,{QQK->QQK_CODIGO,{},{},{},{},{},{},{}})
			AADD(aRoteiros,{QQK->QQK_CODIGO,IIF(QQK->QQK_CODIGO==cRotPri,STR0039,STR0040),.F.})  //"Roteiro Primario"###"Roteiro Secundario"
			
		EndIf
		QQK->(dbSkip())
	EndDo
Else
	AADD(aEspecificacao,{Space(02),{},{},{},{},{},{},{}})
	AADD(aRoteiros,{Space(02),Space(100),.F.})
EndIf

For nW:=1 To Len(aEspecificacao)
	
	cRoteiro := aEspecificacao[nW,_ROT]
	aEspecificacao[nW,_OPE] := QPA010FilCol(aHeaderQQK,"QQK",1,"QQK_PRODUT+QQK_REVIPR+QQK_CODIGO",cProduto+cRevisao+cRoteiro)
		
	For nX := 1 to Len(aEspecificacao[nW,_OPE])
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria as subdimensoes utilizadas na Especificacao do Produto  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Aadd(aEspecificacao[nW,_ENS],{}) //Ensaios
		Aadd(aEspecificacao[nW,_RAS],{}) //Rastreabilidade
		Aadd(aEspecificacao[nW,_TXT],{}) //Observacao da Operacao
		Aadd(aEspecificacao[nW,_INS],{}) //Familias de Instrumentos associadas aos Ensaios
		Aadd(aEspecificacao[nW,_NCO],{}) //Nao-Conformidades associadas aos Ensaios
		Aadd(aEspecificacao[nW,_PAE],{}) //Plano de Amostragem
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Preenche o vetor aESPECIFICACAO com os ensaios vinculados    ³
		//³ aos Roteiros de Operacoes.									 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aEspAux := {}
		
		//Carrega o Rastreamento associado a Operacao
		aEspecificacao[nW,_RAS,Len(aEspecificacao[nW,_RAS])] := QPA010FilCol(aHeaderQQ2,"QQ2",1,;
		"QQ2_CODIGO+QQ2_REVI+QQ2_ROTEIR+QQ2_OPERAC",cProduto+cRevisao+cRoteiro+aEspecificacao[nW,_OPE,nX,nPosOper],)
		
		//Carrega o Texto da Observacao da Operacao
		cChave := aEspecificacao[nW,_OPE,nX,nPosChav]
		aEspecificacao[nW,_TXT,nX] := If(!Empty(cChave),QA_RecTXT(cChave,cEspecie,00,nTamLin,"QA2",aTexto)," ")
		
		//Ensaios Mensuraveis
		QPA010FilCol(aHeaderQP7,"QP7",1,"QP7_PRODUT+QP7_REVI+QP7_CODREC+QP7_OPERAC",cProduto+cRevisao+cRoteiro+aEspecificacao[nW,_OPE,nX,nPosOper],@aEspAux)
		
		//Ensaios Textos
		QPA010FilCol(aHeaderQP7,"QP8",1,"QP8_PRODUT+QP8_REVI+QP8_CODREC+QP8_OPERAC",cProduto+cRevisao+cRoteiro+aEspecificacao[nW,_OPE,nX,nPosOper],@aEspAux)
		
		//Cria as dimensoes para os Ensaios Mensuraveis e/ou Textos
		Aeval(aEspAux,{|x,y|If(!Empty(aEspAux[y,1]) .or. Len(aEspAux)==1,Aadd(aEspecificacao[nW,_ENS,Len(aEspecificacao[nW,_ENS])],aClone(aEspAux[y])),.f.)})
		aEspAux := aClone(aEspecificacao[nW,_ENS,Len(aEspecificacao[nW,_ENS])])
		
		//Ordena os Ensaios por Laboratorio+Sequencia
		aSort(aEspecificacao[nW,_ENS,nX],,,{|x,y|x[nPosLab]+x[nPosSeq]<y[nPosLab]+y[nPosSeq]})
		
		//Cria as dimensoes para as Familias de Instrumentos associadas aos ensaios
		aEspecificacao[nW,_INS,Len(aEspecificacao[nW,_INS])] := aClone(Array(Len(aEspAux)))
		
		//Cria as dimensoes para as Nao-conformidades associadas aos ensaios
		aEspecificacao[nW,_NCO,Len(aEspecificacao[nW,_NCO])] := aClone(Array(Len(aEspAux)))
		
		//Cria as dimensoes para o Plano de Amostragem associado ao Ensaio
		aEspecificacao[nW,_PAE,Len(aEspecificacao[nW,_PAE])] := aClone(Array(Len(aEspAux)))
		
		//Carrega as Familias de Instrumentos associados aos Ensaios
		Aeval(aEspecificacao[nW,_INS,Len(aEspecificacao[nW,_INS])],{|x,y|aEspAux:={},;
		QPA010FilCol(aHeaderQQ1,"QQ1",3,"QQ1_PRODUT+QQ1_REVI+QQ1_ROTEIR+QQ1_OPERAC+QQ1_ENSAIO",;
		cProduto+cRevisao+cRoteiro+aEspecificacao[nW,_OPE,nX,nPosOper]+aEspecificacao[nW,_ENS,nX,y,nPosEns],;
		@aEspAux),aEspecificacao[nW,_INS,Len(aEspecificacao[nW,_INS]),y]:=aClone(aEspAux)})
		
		//Carrega as Nao-conformidades associadas aos Ensaios
		Aeval(aEspecificacao[nW,_NCO,Len(aEspecificacao[nW,_NCO])],{|x,y|aEspAux:={},;
		QPA010FilCol(aHeaderQP9,"QP9",3,"QP9_PRODUT+QP9_REVI+QP9_ROTEIR+QP9_OPERAC+QP9_ENSAIO",;
		cProduto+cRevisao+cRoteiro+aEspecificacao[nW,_OPE,nX,nPosOper]+aEspecificacao[nW,_ENS,nX,y,nPosEns],;
		@aEspAux),aEspecificacao[nW,_NCO,Len(aEspecificacao[nW,_NCO]),y]:=aClone(aEspAux)})
		
		//Carrega os Planos de Amostragens associados aos Ensaios
		Aeval(aEspecificacao[nW,_PAE,Len(aEspecificacao[nW,_PAE])],{|x,y|aEspAux:={},;
		QPA010FilCol(aHeaderQQH,"QQH",1,"QQH_PRODUT+QQH_REVI+QQH_CODREC+QQH_OPERAC+QQH_ENSAIO",;
		cProduto+cRevisao+cRoteiro+aEspecificacao[nW,_OPE,nX,nPosOper]+aEspecificacao[nW,_ENS,nX,y,nPosEns],;
		@aEspAux),aEspecificacao[nW,_PAE,Len(aEspecificacao[nW,_PAE]),y]:=aClone(aEspAux)})
		
	Next nX
Next nW

nRoteiro  := 1   //Posicao do Roteiro corrente para a dimensao vazia.
nOperacao := 1   //Posicao da Operacao corrente para a dimensao vazia.
nEnsaio   := 1   //Posicao do Ensaio corrente para a dimensao vazia. 

Return(NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QPA010FilCol³Autor³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Preenche o aCols a partir dos arquivos utilizados na Espe- ³±±
±±³			 ³ cificacao do Produto.									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QPA010FilCol(aHeader,cAlias,nOrder,cCondicao,;			  ³±±
±±³			 ³ 				cPesquisa,aColsAux)	  						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPC1 = aHeader 											  ³±±
±±³			 ³ EXPC2 = Alias a ser pesquisado						      ³±±
±±³			 ³ EXPC3 = Ordem da chave de pesquisa 						  ³±±
±±³			 ³ EXPC4 = Condicao para os campos 							  ³±±
±±³			 ³ EXPC5 = Condicao para a pesquisa							  ³±±
±±³			 ³ EXPA1 = aCols a ser preenchido							  ³±±
±±³			 ³ EXPL1 = Indica se retorna o aCols Vazio					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ EXPA1 =	Copia do aCols									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QPA010FilCol(aHeader,cAlias,nOrder,cCondicao,cPesquisa,aColsAux,lVazio)
Local nX
Local nDec     	:= 0
Local nUsado   	:= Len(aHeader)

Default aColsAux := {} //Define o tipo da variavel, caso o valor seja nulo

If !lVazio
	dbSelectArea(cAlias)
	dbSetorder(nOrder)
	MsSeek(xFilial(cAlias)+cPesquisa)
	While !Eof() .And. xFilial(cAlias)==&(cAlias+"_FILIAL") .And. &cCondicao==cPesquisa
	
		//Preenche o aCols com as Informacoes dos Campos
	    Aadd(aColsAux,Array(nUsado+1))
	    
	    For nX := 1 to Len(aHeader) 
	
		    If aHeader[nX,10] <> "V"
				If IsHeadRec(aHeader[nX,2])
					aColsAux[Len(aColsAux),nX] := IIf(lQuery,&(cAlias+'->'+cAlias+'RECNO'),&cAlias->(RecNo()))
			    ElseIf Right(aHeader[nX,2],7) == "_ALI_WT"
			    	aColsAux[Len(aColsAux),nX] := cAlias
		    	ElseIf AllTrim(aHeader[nX,2]) == "QQK_OPERGR" 
					aColsAux[Len(aColsAux),nX] := If(lProduto,"N","S")
				//Caso seja Ensaio Texto, os campos abaixo, nao serao considerados					
				ElseIf Alltrim(aHeader[nX,2]) $ "QP7_UNIMEDßQP7_NOMINAßQP7_AFIßQP7_AFSßQP7_LICßQP7_LSCßQP7_MINMAX" .And. cAlias == "QP8"
					aColsAux[Len(aColsAux),nX] := CriaVar(aHeader[nX,2],.T.)
				//Caso Seja Ensaio Mensuravel, o campo abaixo nao sera considerado
				ElseIf AllTrim(aHeader[nX,2]) == "QP8_TEXTO" .And. cAlias == "QP7" 
					aColsAux[Len(aColsAux),nX] := CriaVar(aHeader[nX,2],.T.)
				Else
			        aColsAux[Len(aColsAux),nX] := &(FieldName(FieldPos(cAlias+SubStr(AllTrim(aHeader[nX,2]),4))))    
	        	EndIf
			Else   
				If IsHeadRec(aHeader[nX,2])
					aColsAux[Len(aColsAux),nX] := IIf(lQuery,&(cAlias+'->'+cAlias+'RECNO'),&(cAlias)->(RecNo()))
			    ElseIf Right(aHeader[nX,2],7) == "_ALI_WT"
			    	aColsAux[Len(aColsAux),nX] := cAlias
		    	ElseIf AllTrim(aHeader[nX,2]) == "QP7_DESENS"   
					aColsAux[Len(aColsAux),nX] := Qip010Dens(&(cAlias+"_ENSAIO")) 
				ElseIf AllTrim(aHeader[nX,2]) == "QP7_DESLAB"
					aColsAux[Len(aColsAux),nX] := If(!Empty(aColsAux[Len(aColsAux),nPosLab]),AllTrim(Tabela("Q2",aColsAux[Len(aColsAux),nPosLab])),CriaVar(cAlias+"_DESLAB"))
				ElseIf AllTrim(aHeader[nX,2]) == "QP7_DESNIV"
					aColsAux[Len(aColsAux),nX] := If(!Empty(aColsAux[Len(aColsAux),nPosNiv]),AllTrim(Tabela("Q6",aColsAux[Len(aColsAux),nPosNiv])),CriaVar(cAlias+"_DESNIV"))
				ElseIf AllTrim(aHeader[nX,2]) == "QP7_DUNMED"
					aColsAux[Len(aColsAux),nX] := QA_DESUM(aColsAux[Len(aColsAux),nPosUM],.T.)
				Else	
					aColsAux[Len(aColsAux),nX] := CriaVar(AllTrim(aHeader[nX,2]),.T.)
				EndIf	
		    EndIf 
		    
	    Next nX
	    
		If cAlias == "QP7"
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calcula os Valores dos Afastamentos Inferiores e Superiores  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If At(":",AllTrim(QP7_NOMINA)) > 0
				If QP7_MINMAX $ "1ß2" //Controla Minimo/Maximo ou so Minimo	
					aColsAux[Len(aColsAux),nPosAFI]	:= CalcHora(QP7_NOMINA,QP7->QP7_LIE,"I")
				EndIf                                    
				
				If QP7_MINMAX $ "1ß3" //Controla Minimo/Maximo ou so Maximo	
					aColsAux[Len(aColsAux),nPosAFS]  := CalcHora(QP7_LSE,QP7_NOMINA,"I")
				EndIf

			ElseIf At('i',AllTrim(QP7_NOMINA)) > 0 //Efetua o calculo em Polegadas
				If QP7->QP7_MINMAX $ "1ß2" //Controla Minimo e Maximo ou somente Minimo 
					aColsAux[Len(aColsAux),nPosAFI] := qCalPol({QP7_LIE,QP7_NOMINA},2,aColsAux[Len(aColsAux),nPosAFI])
				EndIf
				
				If QP7->QP7_MINMAX $ "1ß3" //Controla Minimo e Maximo ou somente maximo
					aColsAux[Len(aColsAux),nPosAFS] := qCalpol({QP7_LSE,QP7_NOMINA},2,aColsAux[Len(aColsAux),nPosAFS])
				EndIf

			Else
			    If cPaisLoc <> "MEX"
				nDec := If("," $ AllTrim(QP7->QP7_NOMINA),Len(AllTrim(QP7->QP7_NOMINA))-At(",",AllTrim(QP7->QP7_NOMINA)),0)
				Else
				nDec := If("." $ AllTrim(QP7->QP7_NOMINA),Len(AllTrim(QP7->QP7_NOMINA))-At(".",AllTrim(QP7->QP7_NOMINA)),0)
				Endif	
				//Controla Minimo/Maximo ou so Minimo
				If QP7_MINMAX $ "1ß2"   
					aColsAux[Len(aColsAux),nPosAFI] := Str(SuperVal(QP7_LIE)-SuperVal(QP7->QP7_NOMINA),TamSx3("QP7_AFI")[1],nDec)
					If cPaisLoc <> "MEX"
					aColsAux[Len(aColsAux),nPosAFI] := StrTran(aColsAux[Len(aColsAux),nPosAFI],".",",")+If(At('i',Alltrim(QP7_NOMINA))<>0,'i','')
				    Endif
				EndIf                                	
				//Controla Minimo/Maximo ou so Maximo
				If QP7_MINMAX $ "1ß3"   
					aColsAux[Len(aColsAux),nPosAFS] := Str(SuperVal(QP7_LSE)-SuperVal(QP7->QP7_NOMINA),TamSx3("QP7_AFS")[1],nDec)
					If cPaisLoc <> "MEX"
					aColsAux[Len(aColsAux),nPosAFS] := StrTran(aColsAux[Len(aColsAux),nPosAFS],".",",")+If(At('i',Alltrim(QP7_NOMINA))<>0,'i','')
				    Endif
				EndIf
				
			EndIf
			
	    EndIf
	    
	    //Carrega a descricao da Familia de Instrumentos
		If cAlias == "QQ1"
			If lIntQMT
				aColsAux[Len(aColsAux),nPosDescr] := QIP010dIns(QQ1_INSTR) //QQ1_DESCR
			EndIf

		EndIf

		//Carrega as descricoes referentes a nao-conformidade e classe 
		If cAlias == "QP9"
			aColsAux[Len(aColsAux),nPosDNC] := QIPXDNCO(QP9->QP9_NAOCON) //QP9_DESNCO
			aColsAux[Len(aColsAux),nPosDCl] := A010DCLA(QP9->QP9_CLASSE) //QP9_DESCLA  
		
		EndIf

		//Carrega as descricoes referentes a Rastreabilidade
		If cAlias == "QQ2"
			aColsAux[Len(aColsAux),nPosDesc] := A010DPROD(QQ2->QQ2_PRODUT) //QQ2_DESC
			aColsAux[Len(aColsAux),nPosTipo] := QIPXTIPO(QQ2->QQ2_PRODUT)  //QQ2_TIPO 

		EndIf

		aColsAux[Len(aColsAux),nUsado+1] := .F.    
		(cAlias)->(dbSkip())                                               
				
	EndDo          
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o aCols Vazio, caso nao haja dados para edicao          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aColsAux)==0
    Aadd(aColsAux,Array(nUsado+1))
	Aeval(aHeader,{|x,y| Iif(IsHeadRec(aHeader[y,2]),;
								aColsAux[Len(aColsAux),y] := 0,;
								Iif(Right(aHeader[y,2],7) == "_ALI_WT",;
							    	aColsAux[Len(aColsAux),y] := cAlias,;
							    	aColsAux[Len(aColsAux),y]:=CriaVar(AllTrim(aHeader[y,2]))))})
	aColsAux[Len(aColsAux),nUsado+1] := .F.    
EndIf

Return(aColsAux)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QPA010HeadEsp³Autor³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Cria o aHeader especifico, utilizado nos Ensaios vincula-  ³±±
±±³			 ³ dos ao Roteiro de Operacoes.								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QPA010HeadEsp(aHeader)									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPC1 = aHeader 											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ EXPA1 =	Copia do aHeader								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QPA010HeadEsp(aHeader)
Local nPosLSC := 0
Local nPosCer := 0                 
Local nPosAFI := 0
Local nPosAFS := 0

nPosLSC := Ascan(aHeader,{|x|AllTrim(x[2])=="QP7_LSC"})

Aadd(aHeader,{})
Ains(aHeader,nPosLSC+1)

dbSelectArea("SX3")
dbSetOrder(2)
If dbSeek("QP8_TEXTO")
	aHeader[nPosLSC+1] := {AllTrim(X3Titulo()),X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_F3,X3_CONTEXT}
EndIf	

nPosCer := Ascan(aHeader,{|x|AllTrim(x[2])=="QP7_CERTIF"})

//Acrescenta um posicao no ultimo elemento
AADD(aHeader,{})
Ains(aHeader,nPosCer+1)
             
If dbSeek("QQK_OPERGR")
	aHeader[nPosCer+1] := {AllTrim(X3Titulo()),X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT}
EndIf	

nPosAFI := Ascan(aHeader,{|x|AllTrim(x[2])=="QP7_AFI"})
aHeader[nPosAFI,6] := "QIP010VlNo()"

nPosAFS := Ascan(aHeader,{|x|AllTrim(x[2])=="QP7_AFS"}) 
aHeader[nPosAFS,6] := "QIP010VlNo()"

Return(aHeader)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QP10ENLIOK³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao da Linha na Edicao dos Ensaios					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP10ENLIOK()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP10ENLIOK(o)

Local lRetorno	:=.T.
Local lTipo		:= .F.
Local nUsado    := Len(oGetEns:aHeader)+1
Local nAchou    := 0
Local cCarta	:= " "
Local cTpCarta	:= " "
Local nQtdEns   := 0 
Local cForAux   := " "
Local cVar		:= " "
Local cProcura	:= " " 
Local nLIE		:= 0
Local nLSE		:= 0
                                            
//Chave para pesquisa
cProcura := oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns]
                                          
If !oGetEns:aCols[oGetEns:oBrowse:nAt,nUsado] //Caso nao esteja deletado

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a formatacao das Pictures dos campos: AFI, AFS,  ³
	//³ LIC e LSC, estao iguais ao Valor Nominal.					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	QP1->(dbSetOrder(1))
	QP1->(dbSeek(xFilial("QP1")+oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns])) //Ensaio
	If QP1->QP1_TPCART == "D"

		If !qVrfCalPol(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosNom])
			Help(" ",,1,"QA010INVLD",STR0015+" NOM",1) //"Valor invalido no campo "
			lRetorno := .F.
		EndIf         

		If !qVrfCalPol(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosAFI])
			Help(" ",,1,"QA010INVLD",STR0015+" AFI",1) //"Valor invalido no campo "
			lRetorno := .F.
		EndIf         
	      
		If !qVrfCalPol(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosAFS])
			Help(" ",,1,"QA010INVLD",STR0015+" AFS",1) //"Valor invalido no campo "
			lRetorno := .F.
	    EndIf
    
    	If !qVrfCalPol(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosLIC])
			Help(" ",,1,"QA010INVLD",STR0015+" LIC",1) //"Valor invalido no campo "
			lRetorno := .F.
    	EndIf
                            
	    If !qVrfCalPol(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosLSC])
			Help(" ",,1,"QA010INVLD",STR0015+" LSC",1) //"Valor invalido no campo "
			lRetorno := .F.
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o Ensaio esta com os campos informados			 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !oGetEns:aCols[oGetEns:oBrowse:nAt,nUsado] .And. lRetorno
			If Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns])  .Or.; 
				Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosObr]) .Or.;
				Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosCer]) .Or.; 
				Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosLab]) .Or.;
				Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosUM])  .Or.; 
				Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosMin]) .Or.;
				Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosNom])
				Help(" ",1,"QA_CPOOBR")
				lRetorno := .F.
			EndIf
		EndIf
		
	ElseIf 	QP1->QP1_TPCART <> 'X'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o Ensaio esta com os campos informados			 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !oGetEns:aCols[oGetEns:oBrowse:nAt,nUsado] .And. lRetorno
			If Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns])  .Or.;
				Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosObr]) .Or.;
				Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosCer]) .Or.;
				Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosLab]) 
				
				//Se a Operação naum for obrigatoria, naum validar o Ensaio.
				If oGetOper:aCols[oGetOper:oBrowse:nAt,nPosOpeObr] <> "N" .or. oGetEns:oBrowse:nAt > 1
					Help(" ",1,"QA_CPOOBR")
					lRetorno := .F.
				EndIF
				
			EndIf
		EndIf
	EndIf       
	
	If lRetorno
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o Ensaio ja existe							     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nAchou := Ascan(oGetEns:aCols,{|x| x[nPosEns] == cProcura .And. !(x[Len(oGetEns:aCols[oGetEns:oBrowse:nAt])])})
		
		If nAchou > 0 .And. nAchou <> oGetEns:oBrowse:nAt .And. ! Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosLab])
			Help(" ",1,"A010EXIENP")
			lRetorno := .F.
		EndIf
		
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o Ensaio esta cadastrado.						 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRetorno
		If ! Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns])
			If ! ExistCpo("QP1",oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns])
				lRetorno := .F.
			EndIf
		EndIf
	EndIf
	
	If lRetorno
		QP1->(dbSetOrder(1))
		QP1->(dbSeek(xFilial("QP1")+oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns]))
		cCarta 	 := QP1->QP1_CARTA
		cTpCarta := QP1->QP1_TPCART
		nQtdEns  := QP1->QP1_QTDE
	EndIf 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Validacao dos Ensaios calculados							 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If QP1->QP1_TIPO == "C"
		lTipo := .T.
	EndIf
	
	cForAux  := oGetEns:aCols[oGetEns:oBrowse:nAt,nPosFor]
	
	If Empty(cForAux) .AND. lTipo 
		Help(" ",1,"QA_CPOOBR")
		lRetorno := .F.
	Else
		lRetorno := QP010ValCalc(lRetorno, cForAux, lTipo, cTpCarta, nPosEns, cCarta, nQtdEns)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a Unidade de Medida esta cadastrada				 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRetorno
		If !Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns]) .And. cTpCarta <> 'X'
			If Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosUM])
				Help(" ",1,"QA_CPOOBR")
				lRetorno := .F.
			Else
				If !ExistCpo("SAH",oGetEns:aCols[oGetEns:oBrowse:nAt,nPosUM])
					lRetorno := .F.
				EndIf
			EndIf
		EndIf
	EndIf
	
	If lRetorno
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o Valor Nominal e valido				   	     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ! Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns]) .And. cTpCarta == "D"
			If Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosNom])
				Help(" ",1,"QA_CPOOBR")
				lRetorno := .F.
			Else
				cVar := oGetEns:aCols[oGetEns:oBrowse:nAt,nPosNom]
				If ! QA_VerNum2(@cVar)
					HELP(" ",1,"A010LSCINV")
					lRetorno := .F.
				EndIf
				oGetEns:aCols[oGetEns:oBrowse:nAt,nPosNom] := cVar
			EndIf
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o LIE e menor ou igual ao LSE					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRetorno .And. !Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns]) .And.;
		cTpCarta <> 'X' .And. oGetEns:aCols[oGetEns:oBrowse:nAt,nPosMin] == "1" //Controla valores minimo e maximo
		
		nLIE := SuperVal(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosNom])+SuperVal(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosAFI])
		nLSE := SuperVal(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosNom])+SuperVal(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosAFS])
		
		If nLIE > nLSE
			HELP(" ",1,"A010LSEINV")
			lRetorno := .F.
		EndIf
		
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o LIC e menor ou igual ao LSC     				 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRetorno .And. ! Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns]) .And.;
		cTpCarta <> 'X' .And. oGetEns:aCols[oGetEns:oBrowse:nAt,nPosMin] == "1"  //Controla valores minimo e maximo
		
		If SuperVal(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosLIC]) > SuperVal(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosLSC]) //LIC > LSC
			HELP(" ",1,"A010LSCINV")
			lRetorno := .F.
		EndIf
		
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o Texto do Ensaio esta cadastrado				 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRetorno
		If !Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns]) .And. cTpCarta == 'X'
			If Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosTxt])
				Help(" ",1,"QA_CPOOBR")
				lRetorno := .F.
			EndIf
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o Laboratorio esta informado					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRetorno .And. ! Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns]) .And.;
 		Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosLab])
		Help(" ",1,"QA_CPOOBR")
		lRetorno := .F.
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o Laboratorio esta informado					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRetorno
		If ! Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns]) .And.; 
			!Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosLab])
			If !ExistCpo("SX5",'Q2'+oGetEns:aCols[oGetEns:oBrowse:nAt,nPosLab])
				lRetorno := .F.
			EndIf
		EndIf
	EndIf
EndIf           

Return(lRetorno)
  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QP10ENTUOK³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao de todos Ensaios								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP10ENTUOK()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP10ENTUOK(o)
Local lRetorno := .T.  
Local nEns	   := 0
Local nOldPos  := oGetEns:oBrowse:nAt

For nEns := 1 to Len(oGetEns:aCols) 
	oGetEns:oBrowse:nAt := nEns
	
	If !QP10ENLIOK(o)
		lRetorno := .f.
		Exit
	EndIf

Next nEns

oGetEns:oBrowse:nAt := nOldPos

Return(lRetorno)
                                                                         
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QP10NCLIOK³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao da Linha na Edicao das Nao-Conformidades         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP10NCLIOK()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP10NCLIOK(o)
Local aAreaAnt  := GetArea()
Local lRetorno	:= .T.
Local nUsado	:= Len(oGetNCs:aHeader)
Local cVar		:= " "
Local cProcura := oGetNCs:aCols[oGetNCs:oBrowse:nAt,nPosNc] //Chave para pesquisa

If !oGetNCs:aCols[oGetNCs:oBrowse:nAt,nUsado+1]

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o campo da Nao-Conformidade esta preenchida		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !oGetNCs:aCols[oGetNCs:oBrowse:nAt,nUsado+1] .And. lRetorno
		If Empty(oGetNCs:aCols[oGetNCs:oBrowse:nAt,nPosNC])
			lRetorno := .F.			
		EndIf
	EndIf

	If lRetorno

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a Nao-Conformidade existe						 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nAchou := Ascan(oGetNCs:aCols,{|x|x[nPosNC]==cProcura .And. !(x[Len(oGetNCs:aCols[oGetNCs:oBrowse:nAt])])})
		If nAchou > 0 .And. nAchou <> oGetNCs:oBrowse:nAt .And. !Empty(oGetNCs:aCols[oGetNCs:oBrowse:nAt,nPosCla])
			Help(" ",1,"A010EXINCE")
			lRetorno:=.F.
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a Nao-Conformidade esta cadastrada				 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRetorno
		If ! Empty(oGetNCs:aCols[oGetNCs:oBrowse:nAt,nPosNC])
			If !ExistCpo("SAG",oGetNCs:aCols[oGetNCs:oBrowse:nAt,nPosNC])
				lRetorno := .F.
			EndIf
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a Classe da Nao-Conformidade esta cadastrada	 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRetorno
		If ! Empty(oGetNCs:aCols[oGetNCs:oBrowse:nAt,nPosNC]) .And. ! Empty(oGetNCs:aCols[oGetNCs:oBrowse:nAt,nPosCla])
			If ! ExistCpo("QEE",oGetNCs:aCols[oGetNCs:oBrowse:nAt,nPosCla])
				lRetorno := .F.
			EndIf
		EndIf
	EndIf
EndIf
RestArea(aAreaAnt)

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QP10NCTUOK³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao de todas as Nao-Conformidades        			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP10NCTUOK()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP10NCTUOK(o)
Local lRetorno := .T.
Local nNco	   := 0
Local nPosNco  := 0

nPosNco := oGetNCs:oBrowse:nAt

For nNco := 1 to Len(oGetNCs:aCols)
	oGetNCs:oBrowse:nAt := nNco
	If !QP10NCLIOK(o)
		lRetorno := .F.
		Exit
	EndIf
Next nNco

oGetNCs:oBrowse:nAt := nPosNco

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QP10INSLIOK³ Autor ³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao da linha da Familia de Instrumentos			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP10INSLIOK()											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP10INSLIOK(o)
Local lRetorno := .T.
Local aAreaAnt := GetArea()
Local nUsado   := Len(oGetIns:aHeader)
Local nIns     := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se a Familia editada ja esta asssociada ao Ensaio	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !(oGetIns:aCols[oGetIns:oBrowse:nAt,nUsado+1])

	If Empty(oGetIns:aCols[oGetIns:oBrowse:nAt,nPosInstr]) .Or. Empty(oGetIns:aCols[oGetIns:oBrowse:nAt,nPosDescr])
		lRetorno := .F.
	EndIf
	
	For nIns := 1 To Len(oGetIns:aCols)
	
		If !oGetIns:aCols[nIns,nUsado+1]
			If nIns <> oGetIns:oBrowse:nAt .And. oGetIns:aCols[oGetIns:oBrowse:nAt,nPosInstr] == oGetIns:aCols[nIns,nPosInstr]
				Help(" ",1,"JAGRAVADO")
				lRetorno := .F.
				Exit
			EndIf
			
		EndIf
	Next nIns
	
EndIf

RestArea(aAreaAnt)
Return(lRetorno)
                         
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QP10INSTUOK³ Autor ³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao de todas as Familia de Instrumentos			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP10INSTUOK()											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP10INSTUOK(o)
Local lRetorno := .T.
Local nIns	   := 0
Local nPosIns  := 0
                                   
nPosIns := oGetIns:oBrowse:nAt
For nIns := 1 to Len(oGetIns:aCols)
	oGetIns:oBrowse:nAt := nIns
	If !QP10INSLIOK(o)
		lRetorno := .F.
		Exit
	EndIf
Next nIns

oGetIns:oBrowse:nAt := nPosIns

Return(lRetorno)                   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QP10RSLIOK³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao da linha da Rastreabilidade                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP10RSLIOK()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function QP10RSLIOK(o, lGrupo)
Local nX
Local lRetorno := .T. 

Default lGrupo := .F.

If !oGetRas:aCols[oGetRas:oBrowse:nAt,Len(aCols[oGetRas:oBrowse:nAt])]
	If Empty(oGetRas:aCols[oGetRas:oBrowse:nAt,nPosRastr])
		lRetorno :=.F.
	EndIf
	
	If lRetorno
		For nX := 1 To Len(oGetRas:aCols)
			If !oGetRas:aCols[nX,Len(oGetRas:aCols[nX])]
				If nX <> oGetRas:oBrowse:nAt .And. oGetRas:aCols[oGetRas:oBrowse:nAt,nPosRastr] ==;
					oGetRas:aCols[nX,nPosRastr]
					Help(" ",1,"JAGRAVADO")
					lRetorno := .F.
					Exit
				EndIf
				
			EndIf
		Next nX
	EndIf
	
	If lRetorno .AND. !lGrupo
		If lFase3
			If oGetRas:aCols[oGetRas:oBrowse:nAt,nPosRastr] == M->QP6_PRODUT
				MsgAlert(OemToAnsi(STR0018),OemToAnsi(STR0019))	 //"O produto informado para a rastreabilidade, j  existe." ### "Aten‡„o"
				lRetorno := .F.
			EndIf
		Else
			If oGetRas:aCols[oGetRas:oBrowse:nAt,nPosRastr] == __cPRODUTO
				MsgAlert(OemToAnsi(STR0018),OemToAnsi(STR0019))	 //"O produto informado para a rastreabilidade, j  existe." ### "Aten‡„o"
				lRetorno := .F.
			EndIf
		EndIF
	EndIf
EndIf   


Return(lRetorno)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QP10RSTUOK³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao de todas as linhas da Rastreabilidade            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP10RSTUOK()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function QP10RSTUOK(o, lGrupo)
Local nRast    := 0
Local lRetorno := .T.   

Default lGrupo := .F.

nPosRast := oGetRas:oBrowse:nAt

For nRast := 1 to Len(oGetRas:aCols)

	oGetRas:oBrowse:nAt := nRast

	If !QP10RSLIOK(o, lGrupo)
		lRetorno := .F.
		Exit
	EndIf
	
Next nRast     

oGetRas:oBrowse:nAt := nPosRast

Return(lRetorno)          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QP10OPLIOK³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Critica da linha digitada na Operacao 					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP10OPLIOK()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP10OPLIOK(o)
Local nX 		 := 0
Local nZ 		 := 0
Local nW 		 := 0 
Local lRetorno   := .T.
Local cNewCod    := ""

For nX := 1 To Len(oGetOper:aHeader)

	If Empty(oGetOper:aCols[oGetOper:oBrowse:nAt,nX]) .And. !(oGetOper:aCols[oGetOper:oBrowse:nAt,Len(oGetOper:aHeader)+1])

		If AllTrim(oGetOper:aHeader[nX,2]) == "QQK_TEMPAD"
			Help(" ",1,"A630SEMTMP")
			lRetorno := .F.
			Exit
		EndIf
		
		If AllTrim(oGetOper:aHeader[nX,2]) == "QQK_OPERAC" .Or. (AllTrim(aHeader[nx,2]) == "QQK_RECURSO" .And. !lAPS)
			Help(" ",1,"A630VZ")
			lRetorno := .F.
			Exit
		EndIf
		
		If AllTrim(oGetOper:aHeader[nX,2]) == "QQK_TEMPSO"
			If nTipoSobre > 0
				If !Empty(oGetOper:aCols[oGetOper:oBrowse:nAt,nTipoSobre])
					Help(" ",1,"A630TIPSOB")
					lRetorno := .F.
				EndIf
			EndIf      
		EndIf
		
		If AllTrim(oGetOper:aHeader[nX,2]) == "QQK_TPSOBR"
			If nTempSobre > 0
				If !Empty(oGetOper:aCols[oGetOper:oBrowse:nAt,nTempSobre])
					Help(" ",1,"A630TMPSOB")
					lRetorno := .F.
				EndIf
			EndIf
		EndIf  
		
		If AllTrim(oGetOper:aHeader[nx,2]) == "QQK_TEMPDE"
			If nTipoDes > 0
				If !Empty(aCols[oGetOper:oBrowse:nAt,nTipoDes])
					Help(" ",1,"A630TIPDES")
					lRetorno := .F.
				EndIf
			EndIf
		EndIf
		
		If AllTrim(aHeader[nx,2]) == "QQK_TPDESD"
			If nTempDes > 0
				If !Empty(aCols[oGetOper:oBrowse:nAt,nTempDes])
					Help(" ",1,"A630TMPDES")
					lRetorno := .F.
				EndIf
			EndIf
		EndIf       
		
	ElseIf !(oGetOper:aCols[oGetOper:oBrowse:nAt,Len(oGetOper:aHeader)+1])
	
		If AllTrim(oGetOper:aHeader[nx,2]) == "QQK_OPERAC"
			cNewCod  := oGetOper:aCols[oGetOper:oBrowse:nAt,nX]
			nZ       := Len(oGetOper:aCols[oGetOper:oBrowse:nAt])
			lDeleted := aCols[oGetOper:oBrowse:nAt,nZ]
			
			If !lDeleted
				For nW :=1 to Len(oGetOper:aCols)
					If oGetOper:aCols[nW,nX] == cNewCod .And. oGetOper:oBrowse:nAt <> nW .And. oGetOper:aCols[nW,nZ] == .F.
						Help(" ",1,"A630OPERJA")
						lRetorno := .F.
						Exit			
					EndIf
				Next nW
			EndIf
		EndIf
	EndIf
Next nx       

      
//***VERIFICAR O TRATAMENTO
/*
If lRetorno .And. lAps
	lRetorno := A630DoGrupo(.T.)
Endif
*/         
  
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QP10OPTUOK³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Critica de todas as linhas digitadas na Operacao 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP10OPTUOK()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP10OPTUOK(o)
Local nX       := 0
Local lRetorno := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o ultimo elemento do vetor esta vazio			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nMaxArray := Len(oGetOper:aCols)

For nX := 1 to Len(oGetOper:aHeader)
	If Empty(oGetOper:aCols[nMaxArray,nX])
		  If AllTrim(oGetOper:aHeader[nX,2])=="QQK_OPERAC" .Or. (!lAPS .And. AllTrim(oGetOper:aHeader[nX,2])=="QQK_RECURS")
			nMaxArray--
			Exit
		EndIf
	EndIf 
Next nX

If nMaxArray > 0
	lRetorno := .F.
EndIf           

Return(lRetorno)

/*                      
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QIP010ENOK³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao dos campos editados na Enchoice do QP6			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QIP010ENOK()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP10ROTUOK()

Local nY       := 0
Local nDel     := Len(oGetRot:aHeader)+1 
Local lRotPri  := .F.
Local lRet     := .T.
Local lEncRot  := .F.
Local nDelOper := Len(oGetOper:aHeader)+1
Local lEncOper := .F.   
Local cRoteiro := IIf(lProduto,M->QP6_CODREC,M->QQC_CODREC) 
Local nDeOpra  := Len(oGetEns:aHeader)+1 

For nY:=1 to Len(oGetOper:aCols)
	IF !oGetOper:aCols[nY,nDelOper] .and. !Empty(oGetOper:aCols[nY,1])
		lEncOper := .T. 
		Exit
    EndIf
Next nY  

                 
If lEncOper
	For nY:=1 to Len(oGetRot:aCols)
		IF !oGetRot:aCols[nY,nDel]
			lEncRot  := .T.
			If Empty(oGetRot:aCols[nY,1])
				Help(" ",1,"QP010NROTE",,,1)
				lRet := .F.
			Else
				If oGetRot:aCols[nY,1] == cRoteiro  .OR. oGetRot:aCols[nY,2] == STR0039
					lRotPri := .T.
				EndIF
			EndIF
		EndIF
	Next nY
	
	If !lRotPri .And. lEncRot
		Help(" ",1,"QP010NROPR",,,1)
		lRet := .F.
	Else
		If Len(oGetEns:aCols) >= 1
			For nY := 1 To Len(oGetEns:aCols)   
				If !oGetEns:aCols[nY,nDeOpra] //Caso nao esteja deletado...
					If nPosLab > 0 .and. nPosSeq > 0  
						If Empty(oGetEns:aCols[nY,nPosLab]) 
							MessageDlg(STR0047,,1) //"Nao foi informado laboratorio(s) para o(s) ensaio(s) - Opcao Ensaio"
							Return .f.
						Else
						    If Empty(oGetEns:aCols[nY,nPosSeq]) 
								MessageDlg(STR0048,,1) //"Nao foi informado Sequencia de Laboratorio para o(s) ensaio(s) - Opcao Ensaio"
								Return .f.	    				
						    Endif
						Endif
					Endif
					If nPosTxt > 0 .And. nPosEns > 0
						If QIP010TEXTO(oGetEns:aCols[nY])
							MessageDlg(OemToAnsi(STR0053),,1) //"Nao foi informado o campo Texto para o(s) ensaio(s) - Tipo Texto"
							lRet := .F.
				        Endif
					Endif
				Endif	
			Next nY                  
		Endif
	EndIF
EndIf

Return(lRet)
/*                      
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QIP010ENOK³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao dos campos editados na Enchoice do QP6			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QIP010ENOK()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QIP010ENOK()
Local lRetorno := .T.          

If Inclui
	lRetorno := QP010PRREV() //Verifica se a chave esta duplicada
EndIf

If lProduto
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica Fator Conversao Un. Medida 1 p/ Un. Amostragem 1	 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(M->QP6_UNMED1) .And. M->QP6_UNMED1 <> M->QP6_UNAMO1 .And.;
		(Empty(M->QP6_FATCO1) .Or. Empty(M->QP6_TIPCO1))
		Help( " ", 1, "Q_010FAOBR" )	//"Fator Conversao/Tipo Conversor sao Obrigatorios quando as Un Medida e Amostr. sao diferentes"
		lRetorno := .F.
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica Fator Conversao Un. Medida 2 p/ Un. Amostragem 2    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(M->QP6_UNMED2) .And. M->QP6_UNMED2 <> M->QP6_UNAMO2 .And.;
		(Empty(M->QP6_FATCO2) .Or. Empty(M->QP6_TIPCO2))
		Help( " ", 1, "QA_CPOOBR" )
		lRetorno := .F.
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se Un. Medida 1 = Un. Amost. 1, limpa Fat. Conv. 1			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If M->QP6_UNMED1 == M->QP6_UNAMO1 .And. !Empty(M->QP6_FATCO1)
		M->QP6_FATCO1 := Space(Len(M->QP6_FATCO1))
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se Un. Medida 1 = Un. Amost. 1, limpa Tipo Conv. 1			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If M->QP6_UNMED1 == M->QP6_UNAMO1 .And. !Empty(M->QP6_TIPCO1)
		M->QP6_TIPCO1 := Space(Len(M->QP6_TIPCO1))
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se limpar Un. Medida 2, limpa Fat. Conv. 2 tambem 			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(M->QP6_UNMED2) .And. Empty(M->QP6_UNAMO2) .And. !Empty(M->QP6_FATCO2) .Or.;
		M->QP6_UNMED2 == M->QP6_UNAMO2 .And. !Empty(M->QP6_FATCO2)
		M->QP6_FATCO2 := Space(Len(M->QP6_FATCO2))
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se limpar Un. Medida 2, limpa Tipo Conv. 2 tambem 			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(M->QP6_UNMED2) .And. Empty(M->QP6_UNAMO2) .And. !Empty(M->QP6_TIPCO2) .Or.;
		M->QP6_UNMED2 == M->QP6_UNAMO2 .And. !Empty(M->QP6_TIPCO2)
		M->QP6_TIPCO2 := Space(len(M->QP6_TIPCO2))
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste o Tipo de Shelf-life               				 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRetorno .And. M->QP6_SHLF > 0 .And. Empty(M->QP6_TPSLIF)
		MessageDlg(OemToAnsi(STR0020),,1) //"O campo Tipo de Shelf-Life deve ser informado quando preenchido o campo Shelf-Life."
		lRetorno := .F.
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste o Shelf-life por Ano               				 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRetorno .And. M->QP6_TPSLIF == "4" .And. M->QP6_SHLF > 99
		MessageDlg(OemToAnsi(STR0021),,1)	//"Shelf-Life n„o pode ser maior que 99 anos."
		lRetorno := .F.
	EndIf    
	
	If lRetorno
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste Fator de Conversão com o tipo de conversão.			 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(M->QP6_TIPCO1) .And. SuperVal(M->QP6_FATCO1) == 0
			MessageDlg(OemToAnsi(STR0036),,1) 
			lRetorno := .F.
		EndIf
	EndIf    
	
	If lFase3
 		//Verifica se os campos obrigatorios referentes as Operacoes foram preenchidos
		If lRetorno 
			If !(lRetorno := oGetOper:TudoOk())
				Help(" ",1,"QA_CPOOBR")				
			Else
				If Empty(M->QP6_CODREC)
					Help(" ",1,"QP6_CODREC")
					lRetorno := .F. 
				EndIf
			EndIf
		EndIf                           
		//P.E. utilizado na confirmacao da Especificacao
		If lQIP010JR
			lRetorno := ExecBlock("QIP010JR",.F.,.F.)
		EndIf
    EndIf

EndIf

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QIP010VINI³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida o campo Data de Inicio de Vigencia 				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QIP010VINI()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ X3_VALID do campo QP6_DTINI e B1_DTINI 					  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QIP010VINI(cProduto,cRevi,dVigencia)
Local lRetorno := .T.
Local aAreaAnt   
    
Qp010VarMem() //Atualiza as variaveis de memoria   

If lFase3
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a Data Inicio Vigencia da revisao anterior			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Val(cRevi) > 0
		dbSelectArea("QP6")
		dbSetOrder(1)
		aAreaAnt := GetArea()
		
		If !dbSeek(xFilial("QP6")+cProduto+Inverte(cRevi))
			dbSeek(xFilial("QP6")+cProduto)
			While !Eof() .And. (QP6_FILIAL+QP6_PRODUT) == (xFilial("QP6")+cProduto)
				If QP6_REVI < cRevi
					Exit
				EndIf
				dbSkip()
			Enddo
		Else
			dbskip()
		EndIf
		
		If !Eof() .And. (QP6_FILIAL+QP6_PRODUT) == (xFilial("QP6")+cProduto)
			If QP6_DTINI > dVigencia
				HELP(" ",1,"A010REVANT",,DTOC(QP6_DTINI),2,1) //Rev. anterior e' valida a partir de
				lRetorno := .F.
			EndIf
		EndIf
		RestArea(aAreaAnt)
		
	EndIf
	
Else
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a Data Inicio Vigencia da revisao anterior			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Val(cRevi) > 0
		dbSelectArea(__cALIAS)
		dbSetOrder(1)
		aAreaAnt := GetArea()
		
		If !dbSeek(xFilial(__cALIAS)+cProduto+Inverte(cRevi))
			dbSeek(xFilial(__cALIAS)+cProduto)
			While !Eof() .And. __cFILIAL+__cPRODUTO == xFilial(__cALIAS)+cProduto
				If __cREVISAO < cRevi
					Exit
				EndIf
				dbSkip()
			Enddo
		Else
			dbskip()
		EndIf
		
		If !Eof() .And. __cFILIAL+__cPRODUTO == xFilial(__cALIAS)+cProduto
			If __dREVISAO > dVigencia
				HELP(" ",1,"A010REVANT",,DTOC(__dREVISAO),2,1) //Rev. anterior e' valida a partir de
				lRetorno := .F.
			EndIf
		EndIf
		RestArea(aAreaAnt)
		
	EndIf
EndIf

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QIP010VLPR³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao do Campo Produto       					      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QIP010VLPR()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QIP010VLPR()
Local lRetorno :=.T.

Qp010VarMem() //Atualiza as variaveis de memoria                        

//Verifica qual a base de dados o usuário esta utilizando.                                                              
If lFase3
	
	//Verifica se o produto possui SG2 sem QQK (estava com parametro desligado)
	If IntQIP()  //Verifica se possui integração com materiais.
		lCarRot := .T.
		SG2->(dbSetOrder(1))
		If SG2->(dbSeek(xFilial("SG2")+M->QP6_PRODUT))
			QQK->(dbSetOrder(1))
			If !QQK->(dbSeek(xFilial("QQK")+M->QP6_PRODUT))
				If cPrioriR == '1'      
					QPATUQQK(M->QP6_PRODUT)
				ElseIf MsgYesNo(STR0044) //"A tabela de roteiros do modulo de Inspecao de Processos (QQK) esta desatualizada em relação ao cadastro de Operacões (SG2) , deseja atualiza-la agora ?"
					QPATUQQK(M->QP6_PRODUT)
				Else
					lCarRot := .F.
				EndIf
			EndIf
		EndIf
	EndIf
	
	If !Empty(M->QP6_REVI)
		
		//Verifica a existencia do Produto/Grupo+Revisao
		dbSelectArea("QP6")
		dbSetOrder(1)
		If dbSeek(xFilial("QP6")+M->QP6_PRODUT+Inverte(M->QP6_REVI))
			Help(" ",1,"JAGRAVADO")
			lRetorno := .F.
		Else
			SB1->(dbSetOrder(1))
			If SB1->(dbSeek(xFilial("SB1")+__cProduto))
				M->QP6_DESCPO := SB1->B1_DESC //Descricao do Produto
			EndIf
		EndIf
	EndIf 

	If IntQIP()  //Verifica se possui integração com materiais.
		QP010FilRot(__cProduto,IIF(Empty(M->QP6_REVI),"00",M->QP6_REVI),"  ")
	EndIf
Else
	
	//Verifica se o produto possui SG2 sem QQK (estava com parametro desligado)
	If IntQIP()  //Verifica se possui integração com materiais.
		lCarRot := .T.
		SG2->(dbSetOrder(1))
		If SG2->(dbSeek(xFilial("SG2")+__cGRPPROD))
			QQK->(dbSetOrder(1))
			If !QQK->(dbSeek(xFilial("QQK")+__cGRPPROD))
				If cPrioriR == '1'      
					QPATUQQK(__cGRPPROD)
				ElseIf MsgYesNo(STR0044) //"A tabela de roteiros do modulo de Inspecao de Processos (QQK) esta desatualizada em relação ao cadastro de Operacões (SG2) , deseja atualiza-la agora ?"
					QPATUQQK(__cGRPPROD)
				Else
					lCarRot := .F.
				EndIf
			EndIf
		EndIf
	EndIf
	
	If !Empty(__cREVISAO)
		
		//Verifica a existencia do Produto/Grupo+Revisao
		dbSelectArea(__cALIAS)
		dbSetOrder(1)
		If dbSeek(xFilial(__cALIAS)+__cGRPPROD+Inverte(__cREVISAO))
			If lProduto
				Help(" ",1,"JAGRAVADO")
			Else
				Help(" ",1,"QP010EXIGP")
			EndIf
			lRetorno := .F.
		Else
			If lProduto
				SB1->(dbSetOrder(1))
				If SB1->(dbSeek(xFilial("SB1")+__cPRODUTO))
					M->QP6_DESCPO := SB1->B1_DESC //Descricao do Produto
				EndIf
				
			Else
				//Verifica se existe produto associado ao grupo informado
				dbSelectArea("QPA")
				dbSetOrder(1)
				If !dbSeek(xFilial("QPA")+__cGRPPROD)
					Help(" ",1,"QP010NPRGP") //Grupo nao tem produto associado, devera incluir produto ao grupo de produto
					lRetorno := .F.
				EndIf
				
				//Verifica a existencia do Grupo de Produtos
				If lRetorno
					QP3->(dbSetorder(1))
					If QP3->(!dbSeek(xfilial("QP3")+__cGRPPROD))
						Help(" ",1,"QP010NOGRP") //Nao existe o Grupo de Produtos informado
						lRetorno := .F.
					Else
						M->QQC_DESCRI := QP3->QP3_DESCRI //Descricao do Grupo
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndIF

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QIP010VLEN³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao do Campo Ensaio								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QIP010VLEN()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QIP010VLEN()
Local lRetorno := .T.
Local cVar	   := &(ReadVar()) 
Local nEns	   := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se mudou o Ensaio (Alterou o campo ja' digitado)    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns]) .And. !Empty(cVar) .And. oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns] <> cVar
	Help(" ",1,"A010ALTCHA")   //Campo nao pode ser alterado
	lRetorno := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o Ensaio esta' cadastrado          				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRetorno
	oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns] := M->QP7_ENSAIO
	If !Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns])
		If !ExistCpo("QP1",oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns])
			lRetorno := .F.
		EndIf
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o Ensaio ja' existe                				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRetorno
	For nEns := 1 to Len(oGetEns:aCols)
	
		//Caso exista o codigo do Ensaio
		If cVar == oGetEns:aCols[nEns,nPosEns] .And. nEns <> oGetEns:oBrowse:nAt
			If !oGetEns:aCols[nEns,Len(oGetEns:aCols[nEns])]
				Help(" ",1,"A010EXIENS")
				oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns] := CriaVar("QP7_ENSAIO")
				oGetEns:aCols[oGetEns:oBrowse:nAt,nPosDEn] := CriaVar("QP7_DESENS")
				M->QP7_ENSAIO	 := oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns]
				
				If !Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosLab])
					lRetorno := .F.
				EndIf
			EndIf
		EndIf
	Next nEns
EndIf

If lRetorno
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Preenche a Descricao do Ensaio								 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns])
		If QP1->(dbSeek(xFilial("QP1")+oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns])) //Ensaio posicionado na getdados
			oGetEns:aCols[oGetEns:oBrowse:nAt,nPosDEn] := QP1->QP1_DESCPO
			oGetEns:aCols[oGetEns:oBrowse:nAt,nPosMet] := QP1->QP1_METODO
			If oGetEns:lEditLine
				aCols[oGetEns:oBrowse:nAt,nPosDEn] := QP1->QP1_DESCPO
				aCols[oGetEns:oBrowse:nAt,nPosMet] := QP1->QP1_METODO			
			EndIf
		EndIf
	EndIf
EndIf

Return(lRetorno)
               
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QIP010VLUM³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao do Campo Unidade de Medida						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QIP010VLUM()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QIP010VLUM()
Local lRetorno := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se a Unidade de Medida esta cadastrada				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetEns:aCols[oGetEns:oBrowse:nAt,nPosUM] := M->QP7_UNIMED
If ! ExistCpo("SAH",oGetEns:aCols[oGetEns:oBrowse:nAt,nPosUM])
	lRetorno := .F.
EndIf
Return(lRetorno)
                               
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QIP010VLTI³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao do Campo Familia dos Instrumentos				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QIP010VLTI()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QIP010VLTI()
Local lRetorno := .T.

If lIntQMT
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o Tipo de Instrumento esta cadastrado			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetEns:aCols[oGetEns:oBrowse:nAt,nPosTipIn] := M->QP7_TIPO
	If ExistCpo("QM1",oGetEns:aCols[oGetEns:oBrowse:nAt,nPosTipIn])
		oGetEns:aCols[oGetEns:oBrowse:nAt,nPosDescr] := QM1->QM1_DESCR
	Else
		lRetorno := .F.
	EndIf
EndIf
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QIP010VLLA³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao do Campo Laboratorio							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QIP010VLLA()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Qip010VLLA()
Local lRetorno := .T.
Local cDescLab := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o Laboratorio  esta' cadastrado        			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetEns:aCols[oGetEns:oBrowse:nAt,nPosLab] := M->QP7_LABOR
If ! ExistCpo("SX5","Q2"+oGetEns:aCols[oGetEns:oBrowse:nAt,nPosLab])
	lRetorno := .F.
EndIf

If lRetorno
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza a Descricao do Laboratorio							 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cDescLab := Tabela("Q2",oGetEns:aCols[oGetEns:oBrowse:nAt,nPosLab])
	aCols[oGetEns:oBrowse:nAt,nPosLab+1] := cDescLab
	M->QP7_DESLAB := cDescLab
	If oGetEns:lEditLine
		oGetEns:aCols[oGetEns:oBrowse:nAt,nPosLab+1] := cDescLab
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a sequencia dos ensaios                 	    		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Qip010Seq()

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QIP010VLNI³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao do Campo Nivel (Caracteristica)				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QIP010VLNI()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QIP010VLNI()
Local lRetorno := .T.
Local nI       := 0
Local cVar     := &(ReadVar()) 
Local cDescCar := ""

If !Empty(cVar)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a Caracteristica esta' cadastrada       		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetEns:aCols[oGetEns:oBrowse:nAt,nPosNiv] := M->QP7_NIVEL
	If !ExistCpo("SX5","Q6"+oGetEns:aCols[oGetEns:oBrowse:nAt,nPosNiv])
		lRetorno := .F.
	EndIf
	
	If lRetorno
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza a Descricao da Caracteristica						 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cDescCar := Tabela("Q6",oGetEns:aCols[oGetEns:oBrowse:nAt,nPosNiv])
		oGetEns:aCols[oGetEns:oBrowse:nAt,nPosNiv+1] := cDescCar
		M->QP7_DESNIV := cDescCar		
		If oGetEns:lEditLine
			aCols[oGetEns:oBrowse:nAt,nPosNiv+1] := cDescCar
		EndIf		
	EndIf
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza a Descricao da Caracteristica						 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cDescCar := Space(TamSX3("QP7_DESNIV")[1])
	oGetEns:aCols[oGetEns:oBrowse:nAt,nPosNiv+1] := cDescCar
	M->QP7_DESNIV := cDescCar
EndIf

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QIP010VLNO³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao do Campo Nominal								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QIP010VLNO()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QIP010VLNO()
Local lRetorno := .T.
Local cVar     := " " 
Local cCampo   := ReadVar()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o valor digitado e' um numero valido    		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cVar := &cCampo
If Valtype(cVar) == "N"
	cVar := AllTrim(Str(cVar))
EndIf

QP1->(dbSeek( xFilial("QP1")+aCols[N,nPosEns]))
If QP1->QP1_TPCART == "T"
	If !A010VTempo(@cVar)
		HELP(" ",1,"QA_NUMINV")
		lRetorno := .F.
	Else
		If cCampo == "M->QP7_AFI" .Or. cCampo == "M->QP7_AFS" 
			cVar := StrZero(Val(Substr(cVar,At(':',cVar)-2,2)),2)+":"+StrZero(Val(Substr(cVar,At(':',cVar)+1,2)),2) 
		EndIf
	EndIf	
Else
	If !QA_VerNum2(@cVar)
		HELP(" ",1,"QA_NUMINV")
		lRetorno := .F.
	EndIf
EndIf            

If cCampo == "M->QP7_NOMINA"
	oGetEns:aCols[oGetEns:oBrowse:nAt,nPosNom] := cVar
	If oGetEns:lEditLine
		aCols[oGetEns:oBrowse:nAt,nPosNom] := cVar
	EndIf
ElseIf cCampo == "M->QP7_AFI"
	oGetEns:aCols[oGetEns:oBrowse:nAt,nPosAFI] := cVar
	If oGetEns:lEditLine
		aCols[oGetEns:oBrowse:nAt,nPosAFI] := cVar
	EndIf
ElseIf cCampo == "M->QP7_AFS"
	oGetEns:aCols[oGetEns:oBrowse:nAt,nPosAFS] := cVar
	If oGetEns:lEditLine
		aCols[oGetEns:oBrowse:nAt,nPosAFS] := cVar
	EndIf
EndIf

&(cCampo) := cVar

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QIP010VLSEQ³ Autor ³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida campo SEQLAB - informando a sequencia dos ensaios	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QIP010VLSEQ()											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QIP010VLSEQ(cSeq)
Return(lOrdLab:=.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QIP010VLNC³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao do Campo Nao-Conformidade						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QIP010VLNC()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QIP010VLNC()
Local lRetorno	:= .T.
Local cVar		:= &(ReadVar()) 
Local nC		:= 0                   
Local nI        := 0
                                
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se mudou a NC (Alterou o campo ja' digitado)        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(oGetNCs:aCols[oGetNCs:oBrowse:nAt,nPosNC]) .And. !Empty(cVar) .And. oGetNCs:aCols[oGetNCs:oBrowse:nAt,nPosNC] <> cVar
	Help(" ",1,"A010ALTCHA") //Campo nao pode ser alterado
	lRetorno := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se a NC ja' existe                    				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRetorno
	For nI := 1 to Len(oGetNCs:aCols)
		If cVar == oGetNCs:aCols[nI,nPosNC] .And. nI <> oGetNCs:oBrowse:nAt 
			Help(" ",1,"A020EXINCE")
			lRetorno := .F.
		EndIf
	Next nI
EndIf

If lRetorno
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a NC esta' cadastrada no SAG        			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !ExistCpo("SAG",cVar)
		oGetNCs:aCols[oGetNCs:oBrowse:nAt,nPosNC] := Space(TamSX3("QP9_NAOCON")[1])
		lRetorno := .F.
	EndIf
EndIf

If lRetorno
	If QP2->(dbSeek(xFilial("QP2")+oGetNCs:aCols[oGetNCs:oBrowse:nAt,nPosEns]))
		If !QP2->(dbSeek(xFilial("QP2")+oGetNCs:aCols[oGetNCs:oBrowse:nAt,nPosEns]+cVar))
			Help(" ",1,"A210NCOENS") //"NC nao associada ao Ensaio"
			lRetorno := .F.
		Else
			//Sugere a Classe da NC
			oGetNCs:aCols[oGetNCs:oBrowse:nAt,nPosCla] := QP2->QP2_CLASSE
		EndIf
	EndIf
EndIf

//Sugere a Classe da NC
If lRetorno .And. Empty(oGetNCs:aCols[oGetNCs:oBrowse:nAt,nPosCla])
	SAG->(dbSeek(xFilial("SAG")+cVar))
	oGetNCs:aCols[oGetNCs:oBrowse:nAt,nPosCla] := SAG->AG_CLASSE
EndIf

If lRetorno
	//Preenche a Descricao da NC
	oGetNCs:aCols[oGetNCs:oBrowse:nAt,nPosDNC] := QipxDNCo(cVar)
	
	//Preenche a Descricao da Classe
	oGetNCs:aCols[oGetNCs:oBrowse:nAt,nPosDCl] := A010DCla(oGetNCs:aCols[oGetNCs:oBrowse:nAt,nPosCla])

	//Atualiza a posicao da Nao-Conformidade
	oGetNCs:aCols[oGetNCs:oBrowse:nAt,nPosNC] := cVar
EndIf

Return(lRetorno)              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³Q010VLDAMO³ Autor ³Marcos Cesar			³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida a amostra informada de acordo com a Norma escolhida  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Q010VLDAMO()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Q010VLDAMO(cCampo)
Local cNorma   := " "
Local lRetorno := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica qual a norma escolhida pelo usuario.                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNorma := QA_Plano(cTipoPlan)

//Valida a amostra de acordo com a Norma escolhida
If cCampo == "QQH_AMOST"
	If cTipoPlan == "B"
		lRetorno := ExistCpo("SX5","QJ"+M->QQH_AMOST)
	Else
		lRetorno := ExistCpo("SX5","Q5"+M->QQH_AMOST)
	EndIf
ElseIf cCampo == "QQH_NIVAMO"
	lRetorno := ExistCpo("QQB",cNorma+M->QQH_NIVAMO,2)
ElseIf cCampo == "QQH_NQA"
	If cTipoPlan == "B"
		lRetorno := ExistCpo("SX5","Q0"+M->QQH_NQA)
	Else
		lRetorno := ExistCpo("SX5","Q1"+M->QQH_NQA)
	EndIf
EndIf
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ QP010VLSI³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida campo Situacao da Producao para controle Skip-Lote  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP010VLSI()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 - X3_VALID QP6_SITPRD                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP010VLSI(cSituacao)
Local lRetorno := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se a Situacao est  cadastrada                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !ExistCpo("QPG",cSituacao)
	lRetorno := .F.
EndIf                   

If !(QPG->QPG_CATEG $("1,2"))
	M->QP6_SKPLOT := Space(TamSX3("QP6_SKPLOT")[1])
	M->QP6_DESCLT := Space(TamSX3("QP6_DESCLT")[1]) 	
EndIf		

Return(lRetorno)
    
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ QP010VLTL³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida o campo Tempo Limite					 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP010VLTL()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP010VlTL(cTempoLim)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o Skip-Lote definido                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(M->QP6_SKPLOT)
	QPF->(dbSetOrder(1))
	QPF->(dbSeek(xFilial("QPF")+M->QP6_SKPLOT))
	If QPF->QPF_UNSKLT == "2"	//Skip-Lote por Dia
		
		If M->QP6_TMPLIM <= (QPF->QPF_QTDE/30)	//Tempo Lim. ‚ em meses e skip-lote em dias
			
			// Somente avisa, deixa continuar no processo.
			Help(" ",1,"A100TLMAIO") //"Tempo limite deveria ser maior que o Skip-Lote"
		EndIf
	EndIf
EndIf
Return(.T.)
                               
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QP010PRREV³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida dos campos CHAVES									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP010PRREV()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QP010PRREV()
Local lRetorno := .T.
Return(lRetorno)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QP010VldRot ³ Autor³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Validacao do Roteiro de Operacoes						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP010VldRot()											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function QP010VldRot()
Local lRetorno := .T.
Local aAreaSG2 := SG2->(GetArea()) 
Local cRoteiro := &(ReadVar()) 

Qp010VarMem() //Atualiza as variaveis de memoria                        

If !INCLUI
	Return(lRetorno)     
EndIf

If !Empty(cRoteiro)
	If SG2->(dbSeek(xFilial("SG2")+__cGRPPROD+cRoteiro))
		//Preenche o Roteiro de Operacoes com o Produto Similar selecionado
		QP010FilRot(M->QP6_PRODUT,M->QP6_REVI,cRoteiro,INCLUI)	
	EndIf
EndIf

If lRetorno
	lRetorno := QIP010GARO(.F.)
EndIf

RestArea(aAreaSG2)

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QIP010SEQ	³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao do campo QP7_SEQLAB							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP010PRREV()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Qip010Seq()
Local nX     := 0
Local cLabor := oGetEns:aCols[oGetEns:oBrowse:nAt,nPosLab]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Informa a Sequencia dos Ensaios cadastrados					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetEns:aCols[oGetEns:oBrowse:nAt,nPosSeq] := "01"

If Len(oGetEns:aCols) <> 1
	For nX := 1 To Len(oGetEns:aCols)
		If nX <> oGetEns:oBrowse:nAt .And. !oGetEns:aCols[nX,Len(oGetEns:aCols[nX])]
			If cLabor == oGetEns:aCols[nX,nPosLab]
				aCols[oGetEns:oBrowse:nAt,nPosSeq] := StrZero(Val(aCols[oGetEns:oBrowse:nAt,nPosSeq])+1,2)
			EndIf
		EndIf
	Next
EndIf
Return(.T.)                  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³A010VTEMPO³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se o valor digitado e' um numero valido           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ A010VTempo(@EXPC1) 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 													  ³±±
±±³			 ³ Observaoces: Aceita numeros, sinal negativo e ',' ou '.'   ³±±
±±³			 ³		 		como separador de casa decimal.				  ³±±
±±³			 ³ 				Devolve o numero sempre com a picture com ',' ³±±
±±³			 ³ 				como separador de casa decimal. 			  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A010VTEMPO(cValor)
Local nTam	   := Len(AllTrim(cValor))
Local cSubs	   := " "
Local lRetorno := .T.
Local nI	   := 1
Local nCHR	   := 0

If (nTam > 6) .Or. AllTrim(Str(At(":",cValor))) $ "1ß2ß5ß6"
	lRetorno := .F.
EndIf

While nI <= nTam .And. lRetorno
	cSubs := Subs(Alltrim(cValor),nI,1)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste se e' numero, ponto, virgula, sinal negativo ou     ³
	//³ dois pontos ( para tratamento de hora )                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Asc(cSubs) <> 58 .And. (Asc(cSubs) < 48 .Or. Asc(cSubs) > 57) .and. !Empty(cSubs)
		lRetorno := .F.
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica a ocorrencia do ponto e virgula:				 	 ³
		//³ Nao aceita mais de 1 ponto, mais de 1 virgula, mais ponto e  ³
		//³ virgula, ou 2 pontos ao mesmo tempo							 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Asc(cSubs) == 58
			If Empty(nCHR)
				nCHR := nI
			Else
				lRetorno := .F.
			EndIf
		EndIf
	EndIf
	nI++           
Enddo

If Empty(nCHR)
	lRetorno := .F.
EndIf
Return(lRetorno)               

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³QPA010Tempo³ Autor ³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao dos Campos de Tempo							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QPA010Tempo()	 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QPA010Tempo()
Local nX         := 0
Local nVal       := &(ReadVar())
Local cCampo     := ReadVar()
Local cTipo      := SuperGetMV("MV_TPHR")
Local nPrecisao  := SuperGetMV("MV_PRECISA")
Local nDec       := 0
Local lValid     := .F.
Local lRetorno   := .T.

nDec      := (nVal-Int(nVal))*100
nPrecisao := 60/nPrecisao

If cCampo == "M->QQK_TEMPSO"
	lValid := GDFieldGet("QQK_TPSOBR") == "3"
ElseIf cCampo == "M->QQK_TEMPDE"
	lValid := GDFieldGet("QQK_TPDESD") == "2"
ElseIf cCampo == "M->QQK_TEMPAD"
	lValid := .T.
EndIf	

If nDec >= 60 .And. cTipo == "N" .And. lValid
	Help(" ",1,"NAOMINUTO")
	lRetorno := .F.
EndIf

If lRetorno
	If cCampo $ "M->QQK_TEMPADßM->QQK_SETUP"
	
		If cTipo == "N"
		
			If nVal < 1
			
				If cCampo == "M->QQK_TEMPAD"
					nDec += (oGetOper:aCols[oGetOper:oBrowse:nAt,nPosSetUp]-Int(oGetOper:aCols[oGetOper:oBrowse:nAt,nPosSetUp]))*100
				ElseIf cCampo == "M->QQK_SETUP"
					nDec += (oGetOper:aCols[oGetOper:oBrowse:nAt,nPosTemPad]-Int(oGetOper:aCols[oGetOper:oBrowse:nAt,nPosTemPad]))*100
				EndIf
				
				If NoRound(nDec,2) < NoRound(nPrecisao,2)
					Help(" ",1,"MENORPREC")
					
					If cCampo == "M->QQK_TEMPAD"
						oGetOper:aCols[oGetOper:oBrowse:nAt,nPosTemPad] := nVal
					ElseIf cCampo == "M->QQK_SETUP"
						oGetOper:aCols[oGetOper:oBrowse:nAt,nPosSetUp] := nVal
					EndIf       
					
					If (oGetOper:aCols[oGetOper:oBrowse:nAt,nPosTpOper]) == "2" .Or. (oGetOper:aCols[oGetOper:oBrowse:nAt,nPosTpOper]) == "3"
						lRetorno := .F.
					EndIf          
					
				EndIf
			EndIf   
			
		ElseIf cTipo == "C"
		
			If nVal < 1
				nDec := (nVal-Int(nVal))*60
				
				If cCampo == "M->QQK_TEMPAD"
					nDec += (oGetOper:aCols[oGetOper:oBrowse:nAt,nPosSetUp]-Int(oGetOper:aCols[oGetOper:oBrowse:nAt,nPosSetUp]))*60
				ElseIf cCampo == "M->QQK_SETUP"
					nDec += (oGetOper:aCols[oGetOper:oBrowse:nAt,nPosTemPad]-Int(oGetOper:aCols[oGetOper:oBrowse:nAt,nPosTemPad]))*60
				EndIf
				
				If NoRound(nDec,2) < NoRound(nPrecisao,2)
					Help(" ",1,"MENORPREC")
					If cCampo == "M->QQK_TEMPAD"
						oGetOper:aCols[oGetOper:oBrowse:nAt,nPosTemPad] := nVal
					ElseIf cCampo == "M->QQK_SETUP"
						oGetOper:aCols[oGetOper:oBrowse:nAt,nPosSetUp] := nVal
					EndIf                     
					
					If (oGetOper:aCols[oGetOper:oBrowse:nAt,nPosTpOper]) == "2" .Or. (oGetOper:aCols[oGetOper:oBrowse:nAt,nPosTpOper]) == "3"
						lRetorno := .F.
					EndIf              
					
				EndIf
			EndIf
		EndIf
	EndIf
EndIf

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³QPA010APS  ³ Autor ³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida recurso quando usado PREACTOR                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QPA010APS()		 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QPA010APS()
Local lRetorno := lAPS

If Atail(oGetOper:aCols[oGetOper:oBrowse:nAt])
	lRetorno := .T.
EndIf          

If lRetorno
	SH1->(dbClearFilter()) //compatibiliza com o Roteiro de Operacoes (MATA630)
	lRetorno := QPA010Grupo()
EndIf

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³QPA010Grupo³ Autor ³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Checa se o Recurso esta no grupo de Recursos               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QPA010Grupo(lChecaGrupo)									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QPA010Grupo(lChecaGrupo)
Local cRecurso := " "
Local cGrupRec := " "
Local lRetorno := .T.

lChecaGrupo := If(lChecaGrupo==NIL,.F.,lChecaGrupo)

If !lAPS .Or. Atail(oGetOper:aCols[oGetOper:oBrowse:nAt])
	Return(lRetorno)
Endif              

cRecurso := If(ReadVar()=="M->QQK_RECURS",M->QQK_RECURSO,oGetOper:aCols[oGetOper:oBrowse:nAt,nPosRecurso])
cGrupRec := If(ReadVar()=="M->QQK_GRUPRE",M->QQK_GRUPREC,oGetOper:aCols[oGetOper:oBrowse:nAt,nPosGruRec])

If lChecaGrupo .And. Empty(cGrupRec)  
	Help(" ",1,"OBRIGAT2",,RetTitle("QQK_GRUPRE"),04,01)
	lRetorno := .F.
EndIf
         
If lRetorno
	If !Empty(cRecurso) .And. !Empty(cGrupRec)
		If !cRecurso $ QPA010RecGru(cGrupRec)
	
			Aviso(RetTitle("QQK_RECURS"),STR0031,{"OK"}) //"O Recurso nao faz parte do grupo de recursos selecionado"
			lRetorno := .F.
		EndIf
	ElseIf !Empty(cRecurso) .And. Empty(cGrupRec) .And. ReadVar()=="M->QQK_RECURSO"
		lRetorno := .F.
	EndIf      
EndIf
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³QPA010RecGru³Autor ³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Checa se o Recurso esta no grupo de Recursos               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QPA010RecGru() 											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QPA010RecGru(cGrupRec)
Local aAreaSG6  := SG6->(GetArea())
Local cProGru   := IIF(lFase3,cGrupRec,__cGRPPROD)
Local cSeek     := xFilial("SG6")+cProGru
Local cRecursos := ""  

SG6->(dbSetOrder(1))
SG6->(dbSeek(cSeek))
While SG6->(!Eof()) .And. SG6->(G6_FILIAL+G6_GRUPO)==cSeek
	cRecursos += If(Empty(cRecursos),"","; ")+SG6->G6_RECURSO
	SG6->(dbSkip())
EndDo
RestArea(aAreaSG6)
Return(cRecursos)	
                    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³QPA010Recur ³Autor ³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida campo de Recurso j  Cadastrado como Alternativo.	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QPA010Recur()		 									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//***REVISAR ESTA ROTINA***///
Function QPA010Recur()             
Local lRetorno := .T.
Local cNewCod  := " "
Local cAlias   := " " 
Local nX       := 0
Local nRec     := 0
Local nRec2    := 0

cAlias := Alias()
cNewCod := &(ReadVar())

Return(.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa qual ‚ a Posi‡„o do Rec. Alt. e do tipo na GETDADOS Secund ria.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nx:= 1 To Len(aHeadRec)
	IF Trim(aHeadRec[nx][2]) == "H3_RECALTE"
		nRec:=Nx
	ElseIf Trim(aHeadRec[nx][2]) == "H3_TIPO"
		nRec2:=Nx
	EndIf
Next nx

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se Recurso Principal j  foi cadastrado como Alternativo.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aColsRec) >= n
	For nx:= 1 To Len(aColsRec[n])
		If aColsRec[n][nx][nRec] == cNewCod
			If aColsRec[n][nx][nRec2] == "A"
				Help(" ",1,"A630JAA")
			ElseIf aColsRec[n][nx][nRec2] == "S"
				Help(" ",1,"A630JAS")
			EndIf
			lRet:=.F.
			Exit
		EndIf
	Next nx
EndIf
Return(lRetorno)   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³QPA010Ferram³Autor ³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida campo de Ferramenta (QQK_FERRAM)					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QPA010Recur()		 									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//***REVISAR ESTA ROTINA***///
Function QPA010Ferram()
Local cNewCod
Local cAlias
Local nX
Local nFer
Local lRet:=.T.

cAlias  := Alias()
cNewCod := &(ReadVar())
Return lRet

If Empty(cNewCod)
	Return lRet
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa qual ‚ a Posi‡„o da Ferramenta na GetDados Secund ria.	   	    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nx:= 1 To Len(aHeadFer)
	If Trim(aHeadFer[nx][2]) == "H3_FERRAM"
		nFer:=nx
		Exit
	EndIf
Next nx

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se esta Ferramenta j  foi cadastrada. 				  	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aColsFer) >= n
	For nx:= 1 To Len(aColsFer[n])
		If aColsFer[n][nx][nFer] == cNewCod
			Help(" ",1,"A630FERJA")
			lRet:=.F.
			Exit
		EndIf
	Next nx
EndIf
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³QPA010TPLIN ³Autor ³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida‡„o do Campo QQK_TPLINH.							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QPA010TPLIN()		 									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QPA010TpLin()
Local lRetorno := .T.
Local nX       := 0
Local cTipo    := &(ReadVar())
Local cLinha   := " "

If cTipo == "D"

	If oGetOper:oBrowse:nAt <> 1
		For nX := 1 to Len(aHeaderQQK)
			If AllTrim(aHeaderQQK[nX,2]) == "QQK_LINHAP"
				cLinha := oGetOper:aCols[oGetOper:oBrowse:nAt-1,nX]
				Exit
			EndIf
		Next nX
	EndIf

	If Empty(cLinha)
		Help(" ",1,"A630TPLIND")
		lRetorno := .F.
	Else
		oGetOper:aCols[oGetOper:oBrowse:nAt,nX] := cLinha
	EndIf

ElseIf cTipo $ "OP"

	For nX :=1 to Len(aHeaderQQK)
		If AllTrim(aHeaderQQK[nX,2]) == "QQK_LINHAP"
			cLinha := oGetOper:aCols[oGetOper:oBrowse:nAt,nX]
			Exit
		EndIf
	Next nX

	If Empty(cLinha)
		Help(" ",1,"A630TPLINO")
		lRetorno := .F.
	EndIf

EndIf

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QIP010WHRV³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Define a clausula When para a Revisao					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QIP010WHRV()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QIP010WHRV()
Local lRetorno := .T.
                       
If !lFase3
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Caso nao exista Revisao disponivel, a mesma sera sugerida co ³
	//³ mo "01".													 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(__cREVISAO)
		Qp010VarMem() //Atualiza as variaveis de memoria
	EndIf	
EndIF

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QIP010WHUM³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Define a clausula When para a Unidade de Medida e Amostragem³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QIP010WHUM()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QIP010WHUM()                  		
Local lRetorno := .T.
Local lTemMed  := .F.

If !Inclui
	If lFase3
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Nao permite alteracao na Unidade de Medida e/ou Amostragem,  ³
		//³ Caso exista medicoes definidas.								 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lTemMed := QPA010VerMed(M->QP6_PRODUT,M->QP6_REVI)
		If lTemMed
			lRetorno := .F.
		EndIf
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Nao permite alteracao na Unidade de Medida e/ou Amostragem,  ³
		//³ Caso exista medicoes definidas.								 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lTemMed := QPA010VerMed(__cPRODUTO,__cREVISAO)
		If lTemMed
			lRetorno := .F.
		EndIf
	EndIf
EndIf

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QIP010WHVA³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Define a clausula When para os campos referentes a Ensaios  ³±±
±±³			 ³Mensuraveis (carta <> TXT).								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QIP010WHVA()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QIP010WHVA()
Local lRetorno := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a Carta utilizada no Ensaio.						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
QP1->(dbSeek(xFilial("QP1")+oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns]))	
If QP1->QP1_TPCART == "X"
	lRetorno := .F.
EndIf
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QIP010WHLI³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Define a clausula When para os campos referentes aos Limi- ³±±
±±³			 ³ tes: (LIE, LSE, LIC e LSC)								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QIP010WHLI()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QIP010WHLI(cCpoLim)
Local lRetorno := .T.     
Local cCampo   := ReadVar()

If cCampo <> NIL
	If cCampo == "M->QP7_AFI"
		oGetEns:aCols[oGetEns:oBrowse:nAt,nPosAFI] := StrTran(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosAFI],'"',' ')
		oGetEns:aCols[oGetEns:oBrowse:nAt,nPosAFI] := StrTran(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosAFI],"'",' ')
	ElseIf cCampo == "M->QP7_AFS"
		oGetEns:aCols[oGetEns:oBrowse:nAt,nPosAFS] := StrTran(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosAFS],'"',' ')
		oGetEns:aCols[oGetEns:oBrowse:nAt,nPosAFS] := StrTran(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosAFS],"'",' ')
	ElseIf cCampo == "M->QP7_LIC"
		oGetEns:aCols[oGetEns:oBrowse:nAt,nPosLIC] := StrTran(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosLIC],'"',' ')
		oGetEns:aCols[oGetEns:oBrowse:nAt,nPosLIC] := StrTran(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosLIC],"'",' ')
	ElseIf cCampo == "M->QP7_LSC"
		oGetEns:aCols[oGetEns:oBrowse:nAt,nPosLSC] := StrTran(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosLSC],'"',' ')
		oGetEns:aCols[oGetEns:oBrowse:nAt,nPosLSC] := StrTran(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosLSC],"'",' ')
	EndIf
EndIf                        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a Carta utilizada no Ensaio.						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
QP1->(dbSeek( xFilial("QP1")+oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns]))   
If QP1->QP1_TPCART == 'X'
	lRetorno := .F.
EndIf

If lRetorno
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Realiza o controle dos campos: QP7_AFI e QP7_AFS, atraves do ³
	//³ QP7_MINMAX.													 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lRetorno :=	If((oGetEns:aCols[oGetEns:oBrowse:nAt,nPosMin]=='2' .And. cCpoLim=='MAX') .Or.;
		(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosMin]=='3' .And. cCpoLim=='MIN'),.F.,.T.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o Valor Nominal foi informado					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosNom])	
		HELP(" ",1,"A010NOMVAZ")
		lRetorno := .F.
	EndIf       
	
EndIf
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QIP010WHTX³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Define a clausula When para os campos utilizados em Ensaios³±±
±±³			 ³ do Tipo TXT.												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QIP010WHTX()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QIP010WHTX()
Local lRetorno := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a Carta utilizada no Ensaio.						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
QP1->(dbSeek( xFilial("QP1")+oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns]))  
If QP1->QP1_TPCART <> 'X'
	lRetorno := .F.
EndIf
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QIP010WHIN³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Define a clausula When a Data Inicio da Vigencia           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QIP010WHIN()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QIP010WHIN(lVar)
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ A010WHFOR ³ Autor ³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Acionamento do Cadastro de Formulas						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QIP010WHFOR()											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A010WhFor()
Local aEnsaio := {}
Local nC      := 0
Local nUsado  := Len(oGetEns:aHeader)+1
Local cFormul := ""

If !Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns]) .And. !oGetEns:aCols[oGetEns:oBrowse:nAt,nUsado] .And. !Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosLab])

	If	QP1->(dbSeek(xFilial("QP1")+oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns]))
	
		If QP1->QP1_TIPO == "C"
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Tipo de Carta <> 'X' (Texto)	 							 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If QP1->QP1_TPCART $ "DßT"	//Dimensional ou Tempo
				For nC := 1 To Len(oGetEns:aCols)
					If nC <> oGetEns:oBrowse:nAt
						If !oGetEns:aCols[nC,Len(oGetEns:aHeader)+1]
							If oGetEns:aCols[oGetEns:oBrowse:nAt,nPosLab] == oGetEns:aCols[nC,nPosLab]
								If QP1->(dbSeek(xFilial("QP1")+oGetEns:aCols[nC,nPosEns]))
								
									If QP1->QP1_TPCART == "T"	//Dimensional ou Tempo
										Aadd(aEnsaio,QP1->QP1_ENSAIO)
									ElseIf 	QP1->QP1_TPCART == "D"
										If QP1->QP1_CARTA $ "XBRßXBSßXMRßINDßHIS"
											Aadd(aEnsaio,QP1->QP1_ENSAIO)
										EndIf
									EndIf
									
								EndIf
							EndIf
						EndIf
					EndIf
				Next nC
				
				If Len(aEnsaio) > 0
					cFormul := QAFORMULA(aEnsaio,oGetEns:aCols[oGetEns:oBrowse:nAt,nPosFor])
					M->QP7_FORMUL := cFormul
					oGetEns:aCols[oGetEns:oBrowse:nAt,nPosFor] := cFormul
					If oGetEns:lEditLine
						aCols[oGetEns:oBrowse:nAt,nPosFor] := cFormul
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndIf

Return(.F.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QIP010WFC1 ³ Autor ³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Define o When para o Fator de Conversao (Unidade Amostra 1)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QIP010WFC1()											      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QIP010WFC1()
Local lRetorno := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se as Unidades de Medida e Amostragem sao iguais	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If M->QP6_UNMED1 == M->QP6_UNAMO1
	lRetorno := .F.
EndIf
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QIP010WFC2 ³ Autor ³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Define o When para o Fator de Conversao (Unidade Amostra 2)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QIP010WFC2()											      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QIP010WFC2()
Local lRetorno := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se as Unidades de Medida e Amostragem sao iguais	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If M->QP6_UNMED2 == M->QP6_UNAMO2
	lRetorno := .F.
EndIf
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³A010VLFL   ³ Autor ³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Define a Clausula WHEN para o Fluxograma Geral			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ A010VLFL()											      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A010VLFL(cVar)
Local lRetorno := .T.
If !QQ3->(dbSeek(xFilial("QQ3")+cVar))
	lRetorno := .F.
EndIf
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³A010VLTP   ³ Autor ³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Define a Clausula WHEN para o Tipo						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ A010VLTP()											      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A010VLTP(cVar)
Local lRetorno := .T.

SX5->(dbSetOrder(1))
If !SX5->(dbSeek(xFilial("SX5")+"02"+cVar))
	Help(" ",1,"MA01002")
	lRetorno := .F.
EndIf             

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³A010INICPO ³ Autor ³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina p/ iniciar campos a partir do Instrumento Informado.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ A010INICPO()											      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A010IniCpo(cInstrumento)
Local lRetorno  := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o Instrumento foi alterado						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(oGetIns:aCols[oGetIns:oBrowse:nAt,nPosInstr]) .And. !Empty(cInstrumento) .And.;
	oGetIns:aCols[oGetIns:oBrowse:nAt,nPosInstr] <> cInstrumento
	Help(" ",1,"A010ALTCHA") //Campo nao pode ser alterado
	lRetorno := .F.
EndIf

If lRetorno
	dbSelectArea("QM1")
	dbSetOrder(1)
	If dbSeek(xFilial("QM1")+cInstrumento)
		oGetIns:aCols[oGetIns:oBrowse:nAt,nPosDescr] := QM1_DESCR
	Else
		If GetMV('MV_QIPQMT') == 'S' //Se estiver integrado com SIGAQMT.
			MsgInfo(OemToAnsi(STR0022),OemToAnsi(STR0019)) //"A Fam¡lia informada nao est  cadastrada" ### "Aten‡„o"
			lRetorno := .F.
		EndIf
	EndIf
EndIf

If lRetorno                
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o Instrumento										 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetIns:aCols[oGetIns:oBrowse:nAt,nPosInstr] := cInstrumento
	
EndIf

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³A010INIDESC³ Autor ³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina p/ iniciar campos a partir do Produto.			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ A010INIDES()											      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A010INIDESC(cProduto)
Local lRetorno := .T.
    
//Obtem a Descricao do Produto
SB1->(dbSetOrder(1))
If SB1->(dbSeek(xFilial("SB1")+cProduto))
	oGetRas:aCols[oGetRas:oBrowse:nAt,nPosDesc] := SB1->B1_DESC
	oGetRas:aCols[oGetRas:oBrowse:nAt,nPosTipo] := SB1->B1_TIPO
Else
	MsgInfo(OemToAnsi(STR0022),OemToAnsi(STR0019)) //"O Produto informado nÆo est  cadastrada."###"Aten‡„o"
	lRetorno := .F.
EndIf

//Verifica se o produto informado foi alterado
If lRetorno                
	If !Empty(cProduto) .And. !Empty(oGetRas:aCols[oGetRas:oBrowse:nAt,nPosRastr]) .And. cProduto <> oGetRas:aCols[oGetRas:oBrowse:nAt,nPosRastr]
		Help(" ",1,"A010ALTCHA") //Campo nÆo pode ser alterado
		lRetorno := .F.
	EndIf
EndIf           

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ QP010OPER ³ Autor ³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica a edicao do campo Operacao 						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP010OPER()											      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 - X3_WHEN - QQK_OPERAC 							  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP010OPER() 
Local lRetorno := If(Empty(oGetOper:aCols[oGetOper:oBrowse:nAt,nPosOper]),.T.,.F.)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QPA010Tipo³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Seleciona o Tipo de Especificacao						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QPA010Tipo()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³       = Nulo 											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ EXPL1 = .T. = Especificacao por Produto					  ³±±
±±³			 ³ 		   .F. = Especificacao por Grupo					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QPA010Tipo()
Local oDlg
Local oRadio
Local nOpc		:= 0
Local nRadio	:= 1
Local lOk       := .F.

DEFINE MSDIALOG oDlg FROM	35,37 TO 140,300 TITLE OemToAnsi(STR0032) PIXEL	//"Ensaios"

@ 005,005 TO 040,080 OF oDlg PIXEL
@ 013,011 RADIO oRadio VAR nRadio 3D SIZE 050,011 PROMPT OemToAnsi(STR0033), OemToAnsi(STR0034) OF oDlg PIXEL //"Produto" ### "Grupo"

DEFINE SBUTTON FROM 011, 090 TYPE 1 ENABLE OF oDlg Action (lOk:=.T.,oDlg:End())
DEFINE SBUTTON FROM 024, 090 TYPE 2 ENABLE OF oDlg Action (lOk:=.F.,oDlg:End())

ACTIVATE MSDIALOG oDlg Centered

lProduto := If(nRadio==1,.T.,.F.)

Return({lOk,lProduto})

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP010AtuSB1³ Autor ³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Atualiza o Cadastro de Produtos (SB1), a partir das Especi-³±±
±±³			 ³ ficacoes do Produto. 									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP010AtuSB1()											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³       = Nulo 											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³       = Nulo 											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP010AtuSB1(cProduto)
Local aAreaAnt := GetArea()
Local aArea	   := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao utilizada para verificar a ultima versao dos fontes      ³
//³ SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!							        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
    Final("Atualizar SIGACUS.PRW !!!")
Endif
IF !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
    Final("Atualizar SIGACUSA.PRX !!!")
Endif
IF !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
    Final("Atualizar SIGACUSB.PRX !!!")
Endif

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+cProduto)
If Eof()
	RecLock("SB1",.T.)
	SB1->B1_FILIAL := xFilial("SB1")
	SB1->B1_COD    := M->QP6_PRODUT
	SB1->B1_DESC   := AllTrim(M->QP6_DESCPO)
	SB1->B1_UM     := M->QP6_UNMED1
	SB1->B1_LOCPAD := "01" //asssume o local padrao
	SB1->B1_TIPO   := M->QP6_TIPO
	SB1->B1_TIPOCQ := "Q"
	MsUnLock() 
	If RetArqProd(M->QP6_PRODUT)
		aArea := GetArea()
		dbSelectArea("SBZ")
		RecLock("SBZ",.T.)
		SBZ->BZ_FILIAL := xFilial("SBZ")
		SBZ->BZ_COD    := M->QP6_PRODUT
		SBZ->BZ_LOCPAD := "01"
		If SBZ->(FieldPos("BZ_TIPOCQ")) > 0
			SBZ->BZ_TIPOCQ := "Q"
		EndIf	
		MsUnlock()
		SBZ->(FKCOMMIT())
		RestArea(aArea)
	Endif
Else                
	RecLock("SB1",.F.)
	SB1->B1_UM := M->QP6_UNMED1
	MsUnLock()
EndIf
SB1->(FKCOMMIT())
RestArea(aAreaAnt)

Return(NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QPA010VerMed³ Autor ³Paulo Emidio de Barros³Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Verifica a existencia de medicoes cadastradas com a revi-  ³±±
±±³			 ³ sao a ser manipulada.									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QPA010VerMed(cProduto,cRevisao)							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPC1 = Codigo do Produto								  ³±±
±±³			 ³ EXPC2 = Revisao do Produto								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ EXPL1 = .T. possui medicoes								  ³±±
±±³			 ³ 		 = .F. nao possui medicoes							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QPA010VerMed(cProduto,cRevisao)
Local lRetorno := .F.
Local aAreaAnt := GetArea()
Local aFiliais := {}
Local nY       := 0
Local cFilQP6  := xFilial("QP6")

If (FWModeAccess("QPR") == "E")//!Empty(xFilial("QPR"))
	aFiliais := QA_RetFilEmp(SM0->M0_CODIGO) //Retorna as Filiais associadas a Empresa Atual
Else 
	AADD(aFiliais,{Space(FwSizeFilial()),Space(FwSizeFilial()),Space(FwSizeFilial()),Space(FwSizeFilial()),Space(FwSizeFilial())})
EndIF                                                     

//Inserir o tratamento para verificar as Ordens de Producoes
dbSelectArea("QPR")
dbSetOrder(5)
For nY:=1 to Len(aFiliais)  
    If aFiliais[nY,2]==cFilQP6 .or. (FWModeAccess("QP6") == "C")//Empty(cFilQP6)
		If dbSeek(aFiliais[nY,2]+cProduto+cRevisao)
			//*verificar se existe a Ordem de Producao*
			Help(" ",1,"QPA010ESPE",,STR0035) //"A Especificacao possui Medicoes cadastradas"
			lRetorno := .F.
		EndIf
	EndIf
	If lRetorno
		Exit
	EndIf	
Next nY

RestArea(aAreaAnt)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QIP010GAPR ³ Autor ³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Preenche a Descricao do Produto a partir do SB1			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QIP010GAPR(EXPN1)									      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPN1 = 1 - Descricao do Produto							  ³±±
±±³			 ³ 		   2 - Arquivo de Bitmap							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 - Gatilho do campo QP6_PRODUT     				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QIP010GAPR(nOpc)
Local cRetorno  := " "        
Local lFoundSB1    
Local cProduto  := IIF(lFase3,M->QP6_PRODUT,__cPRODUTO)
                                     
//Posiciona no cadastro de Produtos e testa a existencia do mesmo
SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial("SB1")+cProduto))

lFoundSB1 := SB1->(!Eof())

If nOpc == 1 //Atualiza Descricao do Produto
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Caso o Produto nao exista no QP6, pesquisa no SB1			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	QP6->(dbSetorder(1))
	QP6->(dbSeek(xFilial("QP6")+cProduto))
	If QP6->(!Eof())
		cRetorno := QP6->QP6_DESCPO
	Else
		cRetorno := If(lFoundSB1,PadR(AllTrim(SB1->B1_DESC),TamSX3("B1_DESC")[1]),M->QP6_DESCPO)
	EndIf
	
ElseIf nOpc == 2 //BitMap
	cRetorno := If(lFoundSB1,SB1->B1_BITMAP,M->QP6_BITMAP)
	
ElseIf nOpc == 3 //Tipo do Produto
	cRetorno := If(lFoundSB1,SB1->B1_TIPO,M->QP6_TIPO)
	
ElseIf nOpc == 4 //Unidade de Medida 1
	cRetorno := If(lFoundSB1,SB1->B1_UM,M->QP6_UNMED1)
	
ElseIf nOpc == 5 //Unidade de Medida 2
	cRetorno := If(lFoundSB1,SB1->B1_SEGUM,M->QP6_UNMED2)
	
ElseIf nOpc == 6 //Controle da Revisao
	
	cRetorno := QA_UltRevEsp(cProduto,dDatabase,.F.,.T.,"QIP")
	If Empty(cRetorno)
		cRetorno := "00"
	Else
		cRetorno := Soma1(cRetorno)
		
		While .T.
			If lFase3
				If !FreeForUse("QP6",xFilial("QP6")+M->QP6_PRODUT+cRetorno)
					cRetorno := Soma1(cRetorno)
				Else
					Exit
				EndIf
			Else
				If !FreeForUse(__cALIAS,__cFILIAL+__cPRODUTO+cRetorno)
					cRetorno := Soma1(cRetorno)
				Else
					Exit
				EndIf
			EndIf
		EndDo
		
	EndIf
EndIf

Return(cRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao	 ³ A010DERV	   ³Autor³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Preenche a descricao do Produto a partir da Revisao		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ A010DERV()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 - Gatilho executado a partir QP6_REVI       		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QIP010DERV()
QP6->(dbSetorder(1)) 
If lFase3
	QP6->(dbseek(xFilial("QP6")+M->QP6_PRODUT+Inverte(M->QP6_REVI)))
Else
	QP6->(dbseek(xFilial("QP6")+__cPRODUTO+Inverte(__cREVISAO)))
EndIf
Return(QP6->QP6_DESCPO)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao	 ³ QIP010DENS  ³Autor³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Preenche a descricao do Ensaio							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QIP010DENS()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 - Gatilho executado a partir QP6_REVI       		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QIP010DENS(cEnsaio)
QP1->(dbSetOrder(1))
QP1->(dbSeek(xFilial("QP1")+cEnsaio)) 
Return(QP1->QP1_DESCPO)
                            
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao	 ³ QIP010DENS  ³Autor³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Preenche a descricao do Ensaio							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QIP010DENS()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 - Gatilho executado a partir QP6_REVI       		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QIP010GARO(lVldlin)

Local nY		:= 0
Local lRet		:= .T.
Local lVldGetRot:= If(ReadVar() == "M->QP6_CODREC" .Or. ReadVar() == "M->QQC_CODREC",.F.,.T.)
Local cRot		:= &(ReadVar())
Local cRotMem

Default lVldlin:= .T.
//Verifica se esta com roteiro repetido
If lVldLin
For nY:=1 to Len(oGetRot:aCols)
	If  oGetRot:aCols[nY,1]== cRot .and. oGetRot:oBrowse:nAT<>nY .and. !oGetRot:aCols[nY,3]
		MsgAlert(STR0041+ cRot +STR0042) //"O Roteiro " ### " ja foi cadastrado para esse produto."
		lRet := .F.
		Exit
	EndIF       
Next nY                                                       
Endif                                                       

If lRet
	If lProduto 
		cRotMem := M->QP6_CODREC
	Else	
		cRotMem := M->QQC_CODREC
	EndIF
	If lVldGetRot
		aCols[oGetRot:oBrowse:nAT,1] := cRot
	EndIf
	If lVldLin
		If cRot == cRotMem
			If lVldGetRot
				aCols[oGetRot:oBrowse:nAT,2] := STR0039 //"Roteiro Primario"
			EndIf
			oGetRot:aCols[oGetRot:oBrowse:nAT,2] := STR0039 //"Roteiro Primario"
			oGetRot:Refresh()
		Else
			If lVldGetRot
				aCols[oGetRot:oBrowse:nAT,2] := STR0040 //"Roteiro Secundario"
			EndIf
			oGetRot:aCols[oGetRot:oBrowse:nAT,2] := STR0040 //"Roteiro Secundario"
			oGetRot:Refresh()
		EndIF	
	Else
    	For nY:=1 to Len(oGetRot:aCols) 
    		If oGetRot:aCols[nY,1]== cRot
    			If lVldGetRot
	    			aCols[oGetRot:oBrowse:nAT,2] := STR0039 //"Roteiro Primario"
    			EndIf
    			oGetRot:aCols[nY,2] := STR0039 //"Roteiro Primario"
				oGetRot:Refresh() 
			Else
				If lVldGetRot
					aCols[oGetRot:oBrowse:nAT,2] := STR0040 //"Roteiro Secundario"
				EndIf
			  	oGetRot:aCols[nY,2] := STR0040 //"Roteiro Secundario"
				oGetRot:Refresh() 
			Endif
    	
    	Next nY
	EndIF	
EndIF                                                     

Return(lRet)
                
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Q010F3Amos³ Autor ³ Marcos Cesar          ³ Data ³30.07.2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Verifica qual a consulta que deve ser utilizada no campo    ³±±
±±³          ³QQH_AMOST.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ExpC1 := Q010F3Amos()                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Codigo da Consulta.                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Q010F3AMOS()
Local lRetorno := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ De acordo com os dados encontrados dispara uma consulta F3   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lRetorno := If(cTipoPlan=="B",ConPad1(,,,"QQC",,,.F.),ConPad1(,,,"QQD",,,.F.))

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³QA010TpAmo³ Autor ³ Marcos Cesar          ³ Data ³31.07.2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna o codigo da norma escolhida pelo usuario.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ExpC1 := QA010TpAmo()                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC1 = O codigo da Norma.                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QA010TPAMO()
Local cNorma := " "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica qual a norma escolhida pelo usuario.                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNorma := QA_Plano(cTipoPlan)

Return(cNorma)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Q010F3NQA ³ Autor ³ Marcos Cesar          ³ Data ³31.07.2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Verifica qual a consulta que deve ser utilizada no campo    ³±±
±±³          ³QQH_NQA.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ExpC1 := Q010F3NQA()                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Codigo da Consulta.                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Q010F3NQA()
Local lRetorno := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ De acordo com os dados encontrados dispara uma consulta F3		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTipoPlan == "B"
	lRetorno := ConPad1(,,,"QQI",,,.F.)
Else
	lRetorno := ConPad1(,,,"QQJ",,,.F.)
EndIf
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QIP010PIC ³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Formata a Picture de um Campo							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QIP010PIC(cCampo)										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QIP010PIC(cCampo)
Local cPicture := " "
Local nRecSX3  := 0
Local nTam	   := 0
Local nDec	   := 0

nRecSX3 := SX3->(Recno())
nTam    := TamSx3(cCampo)[1]
SX3->(dbGoTo(nRecSX3))

If Alltrim(FunName()) <> "LERDA" .And. Alltrim(FunName()) <> "EDAPP"

	nDec := QA_NumDec(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosNom]) //Valor de Referencia
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o Tipo do Ensaio									 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If At('i',oGetEns:aCols[oGetEns:oBrowse:nAt,nPosNom] ) == 0
	
		QP1->(dbSeek(xFilial("QP1")+oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns])) //Ensaio
		If QP1->QP1_TPCART == "T" //Tempo
			cPicture := "@N 99:99"
		Else
			cPicture := QA_PICT(cCampo,oGetEns:aCols[oGetEns:oBrowse:nAt,nPosNom]) //Nominal
		EndIf
	Else
	   	cPicture := '@N'+'%C'
	EndIf
	
Endif
Return(cPicture)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QIP010F3NC³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Monta consulta de NCs via SXB especifica                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QIP010F3NC()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Qip010F3Nc()
Local lRetorno := .F.
Local lOk      := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a existencia da Nao-Conformidade associada ao ensaio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
QP2->(dbSetOrder(1))
If QP2->(dbSeek(xFilial("QP2")+oGetNCs:aCols[oGetNCs:oBrowse:nAt,nPosEns]))
	lOk := .T.
EndIf

lRetorno := If(lOk,ConPad1(,,,"NC4"),ConPad1(,,,"SAG"))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso a consulta F3 tenha sido executada fora do SAG, posicio ³
//³ na no SAG, pois o retorno da consulta ‚ o campo AG_NAOCON    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lOk                    
	SAG->(dbSetOrder(1))
	SAG->(dbSeek( xFilial("SAG")+QP2->QP2_NAOCON))
EndIf          

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³A010DPROD ³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna a Descricao do Produto							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ A010DPROD()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A010DPROD(cProduto)
SB1->(dbSelectArea(1))
SB1->(dbSeek(xFilial("SB1")+cProduto))
Return(SB1->B1_DESC)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QIP010DINS³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna a descricao do Instrumento                  		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QIP010DINS()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QIP010DINS(cInstrumento)
QM1->(dbSelectArea(1))
QM1->(dbSeek(xFilial("QM1")+cInstrumento))
Return(QM1->QM1_DESCR)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ A010PL   ³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se o Tipo do Plano de Amostragem, e igual ao se-  ³±±
±±³			 ³ lecionado no campo.										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ A010PL()													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A010PL()
Local lRetorno := .T.
Local cPlanoAm := ""

If !oGetEns:lEditLine
	cPlanoAm := oGetEns:aCols[oGetEns:oBrowse:nAt,nPosPlA]
Else
	cPlanoAm := aCols[oGetEns:oBrowse:nAt,nPosPlA]
EndIf

If cPlanoAm <> "T" //Informativo Texto
	lRetorno := .F.
EndIf          

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QIPR060FIL³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Consulta F3 para as tabelas filtrando pelo NQA padrao ou   ³±±
±±³          ³ NQA - Zero Defeito.                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QIPR060FIL()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                           
Function QIPR060FIL()
Local lRetorno := .T.

If oGetIns:aCols[oGetIns:oBrowse:nAt,nPosPla] == "Z"
	lRetorno := Conpad1(,,,"QZ")
Else
	lRetorno := Conpad1(,,,"Q1")
EndIf

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³A010TPLAM ³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Especificacao do Tipo de Amostragem selecionado			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ A010TPLAM()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A010TPlam(cTipo)
Local lRetorno := .T.  
Local nPosDel  := 0
                       
If !Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns])

	If cTipo $ 'NßZßB' //NBR5426,Zero Defeito,NBR5429	
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste o tipo de Carta utilizado em ensaios com a NNR-5429 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cTipo == "B"
			QP1->(dbSetorder(1))
			QP1->(dbSeek(xFilial("QP1")+oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns]))
			If QP1->(!Eof())	
				If (Alltrim(QP1->QP1_CARTA) $ ("TXT/U/P")) .Or. (QP1->QP1_TPCART $ "TßX")
					Help(" ",1,"QP10CARINV",,,1)  //"O Tipo da Carta associada ao Ensaio e invalida"
					lRetorno := .F.
			    EndIf
			EndIf
		EndIf
			
		lRetorno := If(lRetorno,A010PlAmo(cTipo),lRetorno)  
				
	ElseIf cTipo == 'I' //Internos
		lRetorno := A010PlInt()  
				
	ElseIf cTipo == "T" //Texto 
	  	oGetEns:aCols[oGetEns:oBrowse:nAt,nPosDPl] := Space(TamSX3("QP7_DESPLA")[1])
		If oGetEns:lEditLine
			aCols[oGetEns:oBrowse:nAt,nPosDPl] := Space(TamSX3("QP7_DESPLA")[1])
		EndIf
	Else              
   		oGetEns:aCols[oGetEns:oBrowse:nAt,nPosPlA] := Space(TamSX3("QP7_PLAMO")[1])
		oGetEns:aCols[oGetEns:oBrowse:nAt,nPosDPl] := Space(TamSX3("QP7_DESPLA")[1])
		If oGetEns:lEditLine
	   		aCols[oGetEns:oBrowse:nAt,nPosPlA] := Space(TamSX3("QP7_PLAMO")[1])
			aCols[oGetEns:oBrowse:nAt,nPosDPl] := Space(TamSX3("QP7_DESPLA")[1])
		EndIf
				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Marca o Plano de Amostragem como deletado, para que seja pos-³
		//³ sivel a exclusao do mesmo, se definido anteriormente.	     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPosDel := Len(aEspecificacao[oGetRot:oBrowse:nAt,_PAE,oGetOper:oBrowse:nAt,oGetEns:oBrowse:nAt,1])
		aEspecificacao[oGetRot:oBrowse:nAt,_PAE,oGetOper:oBrowse:nAt,oGetEns:oBrowse:nAt,1,nPosDel] := .T.
	EndIf			    
		
EndIf

Return(lRetorno)       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³A010DPLAM ³ Autor ³Cleber Souza           ³ Data ³28/08/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Especificacao da Descricao da Amostragem					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ A010DPLAM()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A010DPLAM()

//Salva informações do Plano de Amostragem do tipo Texto
If Alltrim(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosPlA]) == "T"
	aEspecificacao[oGetRot:oBrowse:nAt,_PAE,oGetOper:oBrowse:nAt,oGetEns:oBrowse:nAt,1,nPosPlano]  := "TEXTO"
	aEspecificacao[oGetRot:oBrowse:nAt,_PAE,oGetOper:oBrowse:nAt,oGetEns:oBrowse:nAt,1,nPosNivel]  := "01"          //Nivel
	aEspecificacao[oGetRot:oBrowse:nAt,_PAE,oGetOper:oBrowse:nAt,oGetEns:oBrowse:nAt,1,nPosAmo]    := "TX"          //Amostragem
	aEspecificacao[oGetRot:oBrowse:nAt,_PAE,oGetoper:oBrowse:nAt,oGetEns:oBrowse:nAt,1,nPosDscPAE] := oGetEns:aCols[oGetEns:oBrowse:nAt,nPosDPl] //Descricao do Plano
EndIF

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³A010DSLT  ³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna a descricao do Skip-Lote							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ A010DSLT()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 - Gatilho do campo QP6_SKPLOT    			      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A010DSLT(cSkipLote)
Local cRetorno := " "
QPF->(dbSetorder(1))
QPF->(dbSeek(xFilial("QPF")+cSkipLote))
If QPF->(!Eof())
	cRetorno := QPF->QPF_DESCRI
EndIf
Return(cRetorno)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³A010DSSTP ³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna a descricao da Classe da Situacao do Produto       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ A010DSLT()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 - Gatilho do campo QP6_SITPRD    			      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A010DSSTP(cSituacao)
Local cRetorno := " "
QPG->(dbSetOrder(1))
QPG->(dbSeek(xFilial("QPG")+cSituacao))
If QPG->(!Eof())
	cRetorno := QPG->QPG_NIVEL
EndIf
Return(cRetorno)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QIP010DEEN³ Autor ³						³ Data ³  /  /2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Exclusao das Amarracoes referentes ao Produto x Revisao x  ³±±
±±³			 ³ Ensaio (Funcao obsoleta, ano sera utilizada nesta rotina)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QIP010DEEN()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 												      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Qip010Deen(cChave)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Exclui amarracao no QPR -> Medicoes do Produto/Revisao/Ensaio ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea('QPR') 
dbSetOrder(5)
dbSeek(xFilial("QPR")+cChave)
While QPR_FILIAL+QPR_PRODUT+QPR_REVI+QPR_ENSAIO == xFilial("QPR")+cChave .And. !Eof()
	RecLock("QPR",.F.,.T.)
	dbDelete()
	MsUnlock()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria chave de ligacao da medicao com os outros arquivos 	 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cChvMed := QA_CvKey(xFilial("QPR")+QPR->QPR_PRODUT+QPR->QPR_REVI+;
	Dtos(QPR->QPR_DTENTR)+QPR->QPR_LOTE+QPR->QPR_LABOR+QPR->QPR_ENSAIO+;
	Dtos(QPR->QPR_DTMEDI)+QPR->QPR_HRMEDI+Str(QPR->QPR_AMOSTR,1),"QPR",1)
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exclui tambem do QPS -> Valores das medicoes (Ens. Mens.)    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea('QPS')
	dbSeek( xFilial("QPS")+cChvMed )
	While QPS_FILIAL+QPS_CODMED == xFilial("QPS")+cChvMed .And. !Eof()
		RecLock("QPS",.F.,.T.)
		dbDelete()
		MsUnlock()
		dbSkip()
	Enddo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exclui tambem do QPQ -> Valores das medicoes (Ens. Texto)    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea('QPQ')
	dbSeek( xFilial("QPQ")+cChvMed )
	While QPQ_FILIAL+QPQ_CODMED == xFilial("QPQ")+cChvMed .And. !Eof()
		RecLock("QPQ",.F.,.T.)
		dbDelete()
		MsUnlock()
		dbSkip()
	Enddo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exclui tambem do QPT -> Instrumentos das medicoes		   	 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea('QPT')
	dbSeek( xFilial("QPT")+cChvMed )
	While QPT_FILIAL+QPT_CODMED == xFilial("QPT")+cChvMed .And. !Eof()
		RecLock("QPT",.F.,.T.)
		dbDelete()
		MsUnlock()
		dbSkip()
	Enddo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exclui tambem do QPU -> NCs das med. do Produto/Revisao	     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea('QPU')  // NCs das Medicoes
	dbSeek( xFilial("QPU")+cChvMed )
	While QPU_FILIAL+QPU_CODMED == xFilial("QPU")+cChvMed .And. ! Eof()
		RecLock("QPU",.F.,.T.)
		dbDelete()
		MsUnlock()          
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui tambem no QA2 -> Cronicas das NCs				   	 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		QA_DelTxt(xFilial("QPU")+QPU->QPU_CODMED+QPU->QPU_NAOCON,"QIPA210 ")
		dbSkip()
		
	Enddo
	dbSkip()
Enddo
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³A010PLAMO ³ Autor ³Paulo Emidio de Barros ³ Data ³  /  /2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Define o Plano de Amostragem para o Ensaio				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ A010PLAMO()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 												      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A010PlAmo(cTipo)
Local lRetorno := .T.
Local oDlg           
Local cNQA     := ""
Local cNivel   := ""
Local cAmo     := ""
Local nOpcA	   := 0
Local bOk      := {||nOpcA := 1,cNQA:=M->QQH_NQA,cNivel:=M->QQH_NIVAMO,cAmo:=M->QQH_AMOST,oDlg:End()}
Local bCancel  := {||nOpcA := 0,oDlg:End()}            
Local aVisual  := {}
Local aAltera  := {}
Local nNQA     := 0
Local nNivAmo  := 0
Local nAmost   := 0
Local nOpcPAE  := 4
	                              
Private cCadastro := OemToAnsi(STR0023) //"Plano de Amostragem"
Private aGets     := {} 
Private aTela     := {}                            
Private cTipoPlan := cTipo //Indica o Tipo do Plano de Amostragem selecionado
                               
If cTipo <> oGetEns:aCols[oGetEns:oBrowse:nAt,nPosPlA]
	nOpcPAE := 3
EndIf
                                                 
If cTipo == "Z" 
	aAltera := {"QQH_NQA"}
	aVisual := aClone(aAltera)
	   
ElseIf cTipo == "T" //Plano Texto	
	aAltera := {"QQH_NQA","QQH_DESCRI"}
	aVisual := aClone(aAltera)	

Else	
	aAltera := {"QQH_AMOST","QQH_NIVAMO","QQH_NQA"}
	aVisual := aClone(aAltera)
EndIf

DEFINE MSDIALOG oDlg TITLE cCadastro From 100,050 to 290,500 OF GetWndDefault() PIXEL

RegToMemory("QQH",If(nOpcPAE==3,.T.,.F.),.F.)            
EnChoice("QQH",,nOpcPAE,,,,aVisual,{014,002,094.5,223.5},aAltera,,,,)   
                                             		
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel) VALID .T.

If nOpcA == 1
   
	If (cTipo=="N") .Or. (cTipo=="B") //NBR-5426 ou NBR-5429
		aEspecificacao[oGetRot:oBrowse:nAt,_PAE,oGetOper:oBrowse:nAt,oGetEns:oBrowse:nAt,1,nPosPlano] := QA_Plano(cTipo)    
		aEspecificacao[oGetRot:oBrowse:nAt,_PAE,oGetOper:oBrowse:nAt,oGetEns:oBrowse:nAt,1,nPosNQA]   := cNQA    
		aEspecificacao[oGetRot:oBrowse:nAt,_PAE,oGetOper:oBrowse:nAt,oGetEns:oBrowse:nAt,1,nPosNivel] := cNivel 
		aEspecificacao[oGetRot:oBrowse:nAt,_PAE,oGetOper:oBrowse:nAt,oGetEns:oBrowse:nAt,1,nPosAmo]   := cAmo
		oGetEns:aCols[oGetEns:oBrowse:nAt,nPosDPl] := TitSX3("QQH_NQA")[1]+" "+M->QQH_NQA+" "+TitSX3('QQH_NIVAMO')[1]+" "+M->QQH_NIVAMO+" "+TitSX3("QQH_AMOST")[1]+" "+M->QQH_AMOST //Descricao do Plano de Amostragem
		aCols[n,nPosDPl] := TitSX3("QQH_NQA")[1]+" "+M->QQH_NQA+" "+TitSX3('QQH_NIVAMO')[1]+" "+M->QQH_NIVAMO+" "+TitSX3("QQH_AMOST")[1]+" "+M->QQH_AMOST

	ElseIf (cTipo=="Z") //Zero Defeito

    	aEspecificacao[oGetRot:oBrowse:nAt,_PAE,oGetOper:oBrowse:nAt,oGetEns:oBrowse:nAt,1,nPosNQA]   := M->QQH_NQA  //NQA
		aEspecificacao[oGetRot:oBrowse:nAt,_PAE,oGetOper:oBrowse:nAt,oGetEns:oBrowse:nAt,1,nPosNivel] := "01"        //Nivel
		aEspecificacao[oGetRot:oBrowse:nAt,_PAE,oGetOper:oBrowse:nAt,oGetEns:oBrowse:nAt,1,nPosAmo]   := "QS"        //Amostragem
		oGetEns:aCols[oGetEns:oBrowse:nAt,nPosDPl] := TitSX3("QQH_NQA")[1]	+" "+cNQA+Space(35)
		aCols[n,nPosDPl] := TitSX3("QQH_NQA")[1]+" "+cNQA+Space(35)
	EndIf
	
EndIf 

lRetorno := If(nOpcA==1,.T.,.F.)

Return(lRetorno)                                           
                
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³A010PLINT ³ Autor ³Paulo Emidio de Barros ³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Define o vetor para o Plano de Amostragem Interno		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ A010PLINT()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 												      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A010PLINT()
Local oDlg
Local nOpcA := 0

Private aListQQB := {}
Private aListQA7 := {}
Private oListQQB
Private oListQA7

QQB->(dbSetOrder(2))
QQB->(dbSeek(xFilial("QQB")+"INTERN"))
If QQB->(!Eof())
	While QQB->(!Eof()) .And. xFilial('QQB') == QQB->QQB_FILIAL .And. QQB->QQB_PLANO == "INTERN"
		Aadd(aListQQB,{QQB->QQB_CODIGO,QQB->QQB_DESCRI})
		QQB->(dbSkip())
	EndDo
Else
	MsgAlert(OemToAnsi(STR0024),OemToAnsi(STR0019))	//"NÆo existe plano de amostragem espec¡fico. Cadastre-o primeiramente."###"Aten‡„o"
	oGetEns:aCols[oGetEns:oBrowse:nAt,nPosPla]	:= Space(TamSX3("QP7_PLAMO")[1])
	Return(.F.)
EndIf
                                                           	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ativa o ListBox com as Opcoes para o Plano Interno			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg FROM 000,000 TO 023.2,080 TITLE OemToAnsi(STR0023) OF oMainWnd //"Plano de Amostragem"
@ 005,003 TO 155,314 LABEL OemToAnsi(STR0025) OF oDlg PIXEL //"Tipos de Planos de Amostragens"

@ 015,006 LISTBOX oListQQB FIELDS HEADER TitSX3('QQB_CODIGO')[1],TitSX3('QQB_DESCRI')[1] SIZE 305,133 PIXEL ALIAS "QQB"
oListQQB:SetArray(aListQQB)
oListQQB:bLine := {||{aListQQB[oListQQB:nAt,1],aListQQB[oListQQB:nAt,2]}}
	
DEFINE SBUTTON FROM 158,250 TYPE 1 ACTION (nOpcA := 1,(QPA010PLIn(),oDlg:End())) ENABLE OF oDlg
DEFINE SBUTTON FROM 158,280 TYPE 2 ACTION (nOpcA := 2,oDlg:End())                 ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTERED 

Return(If(nOpcA==1,.T.,.F.))
                                                            
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QPA010PLIn³ Autor ³Paulo Emidio de Barros ³ Data ³08/06/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Atualiza o vetor aEspecificacao com o Plano Interno	      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QPA010PLIN()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 												      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function QPA010PLIn()
aEspecificacao[oGetRot:oBrowse:nAt,_PAE,oGetOper:oBrowse:nAt,oGetEns:oBrowse:nAt,1,nPosPlano] := QA_Plano("I")    
aEspecificacao[oGetRot:oBrowse:nAt,_PAE,oGetOper:oBrowse:nAt,oGetEns:oBrowse:nAt,1,nPosNQA]   := "ESP"+aListQQB[oListQQB:nAt,1]
aEspecificacao[oGetRot:oBrowse:nAt,_PAE,oGetOper:oBrowse:nAt,oGetEns:oBrowse:nAt,1,nPosNivel] := aListQQB[oListQQB:nAt,1] 
aEspecificacao[oGetRot:oBrowse:nAt,_PAE,oGetOper:oBrowse:nAt,oGetEns:oBrowse:nAt,1,nPosAmo]   := CriaVar("QQH_AMOST")  
	
oGetEns:aCols[oGetEns:oBrowse:nAt,nPosDPl] := STR0026+aListQQB[oListQQB:nAt,1]+" - "+aListQQB[oListQQB:nAt,2] //"Plano : "
Return(NIL)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QPA010INIOPE³ Autor³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Inicializador padrao da Operacao							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QPA010IniOpe()											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function QPA010IniOpe()
Local nTam := TamSX3("QQK_OPERAC")[1]
Local cSeq := "  "
Local nPos

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso o objeto das Operacoes nao seja criado, envia a numera- ³
//³ cao do aEspecificacao.										 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aEspecificacao) > 0 .And. Type("oGetRot") <> "U"
	If ValType(oGetOper) == "U" 
		cSeq := Soma1(StrZero(Len(aEspecificacao[oGetRot:oBrowse:nAt,_OPE]),nTam),nTam)
	Else   
		IF Empty(oGetRot:aCols[oGetRot:oBrowse:nAt,1])
			If nRoteiro > 1
				cSeq :=  aEspecificacao[nRoteiro-1,_OPE,1,1]
			EndIF	                             
		Else	                                   
			nPos := If(Len(oGetOper:aCols)==1,1,Len(oGetOper:aCols)-1)
			cSeq := Soma1(oGetOper:aCols[nPos,nPosOper],nTam)
		EndIF
	EndIf
EndIF	
Return(cSeq)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QPFilRoteiro³ Autor³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Filtra o SG2 por chave unica								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QPFilRoteiro()											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function QPFilRoteiro()  

Local lRet 

If Alltrim(FunName()) <> "LERDA" .And. Alltrim(FunName()) <> "EDAPP" .And. !Empty(__cPRODUTO)
	If lProduto
		lRet := M->QP6_PRODUT==SG2->G2_PRODUTO .And. UniqueKey("G2_CODIGO","SG2")
	Else
		lRet := .T.
	EndIf
Else
	lRet := .T.
EndIf
                                                
Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QpRetOperacao³Autor³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorno do Roteiro de Operacoes na Consulta Padrao QQK01   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QpRetOperacao()    										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function QpRetOperacao()    
Local lRetorno          

If Type("__cPRODUTO") == "U"
	__cPRODUTO := CriaVar("QP6_PRODUTO")
Endif        
AjustaSXB()

If Alltrim(FunName()) <> "LERDA" .And. Alltrim(FunName()) <> "EDAPP"
	SG2->(dbSetOrder(1))
	If !SG2->(dbSeek(xFilial("SG2")+__cPRODUTO))
		lRetorno := ConPad1(,,,"QQK",,,.F.)
	Else
		lRetorno := ConPad1(,,,"SG2",,,.F.)
	EndIf		                                                    
Else 
	lRetorno := ConPad1(,,,"QQK",,,.F.)
EndIf
	
Return(lRetorno)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QP010VarMem ³ Autor³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Atualiza as Variaveis utilizadas na Especificacao por Gru- ³±±
±±³			 ³ po ou Produtos.											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP010VarMem()											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function QP010VarMem()

If lProduto
	__cGRPPROD := M->QP6_PRODUT 
	__cPRODUTO := M->QP6_PRODUT 
	__cREVISAO := M->QP6_REVI
	__dREVISAO := M->QP6_DTINI
	__cROTEIRO := M->QP6_CODREC
Else
	__cGRPPROD := M->QQC_GRUPO
	__cPRODUTO := PadR(M->QQC_GRUPO,TamSX3("QP6_PRODUT")[1]) //Compatibiliza o tamanho para a pesquisa do Grupo
	__cREVISAO := M->QQC_REVI
	__dREVISAO := M->QQC_DTINI
	__cROTEIRO := M->QQC_CODREC
EndIf
               
Return(.T.)
                
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³A010WhSKP   ³ Autor³Cleber Souza          ³ Data ³20/02/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ When do Campo Skip Lote.									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ A010WhSKP()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A010WhSKP()

Local lRetorno := .t.

If !Empty(M->QP6_SITPRD)
	dbSelectArea("QPG")
	dbSetOrder(1)
	dbSeek(xFilial("QPG")+M->QP6_SITPRD)
	If QPG->QPG_CATEG $("1,2")
		lRetorno := .t.
	Else
		lRetorno := .f.
	EndIf		
EndIF

Return(lRetorno) 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QP010Ordena ³ Autor³Paulo Emidio de Barros³ Data ³24/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ordena os Ensaios por Laboratorio+Sequencia				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP010Ordena()					 						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function QP010Ordena()
Local cLabAtu 
Local cSeqAtu 
Local cEnsAtu 
Local nPos
                  
//Verifica se a coluna editada e referente ao campo: QP7_SEQLAB
If (oGetEns:oBrowse:nColPos-1) == nPosSeq 

	//Se houver apenas uma linha cadastrada nao executa a ordenacao
	If Len(oGetEns:aCols) > 1                                                      
	
    	//Salva as informacoes referentes a Laboratorio, Sequencia e Ensaio
		cLabAtu := oGetEns:aCols[oGetEns:oBrowse:nAt,nPosLab]
		cSeqAtu := oGetEns:aCols[oGetEns:oBrowse:nAt,nPosSeq] 
		cEnsAtu := oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns]

		//Ordena os Ensaios por Laboratorio+Sequencia
		aSort(oGetEns:aCols,,,{|x,y|x[nPosLab]+x[nPosSeq]<y[nPosLab]+y[nPosSeq]})
       
		//Verifica a posicao do campo editado no aCols
		nPos := Ascan(oGetEns:aCols,{|x|x[nPosLab]==cLabAtu .And. x[nPosSeq]==cSeqAtu .And. x[nPosEns]==cEnsAtu})
		nPos := If(nPos>0,nPos,1) 
		
        oGetEns:oBrowse:nAt := nPos //posiciona novamente no campo editado
		oGetEns:oBrowse:Refresh()

		lOrdLab := .F.	//Retorna a condicao do flag para ordenacao 
		
	EndIf
	
EndIf

Return(NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao	 ³FolderChange ³Autor³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua o controle na navegacao dos Folders 				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FolderChange(EXPC1)		 							      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function FolderChange(cChange) 

Local lDelRot
Local lDelOpe 
Local lDelEns

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Realiza o controle da edicao dos dados nos folders correntes ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
If At("7",cChange) > 0 //Roteiro

	If nRoteiro <> oGetRot:oBrowse:nAt 
		//Salva os dados editados
		FolderSave("1234567")
	EndIF  
	
	//Verifica se esta deletado ou nao para bloquear\desbloquear objetos 
	lDelRot := oGetRot:aCols[oGetRot:oBrowse:nAt,Len(oGetRot:aCols[oGetRot:oBrowse:nAt])]

	oGetOper:oBrowse:lReadOnly := lDelRot
	oGetOper:oBrowse:Refresh()

	oGetRas:oBrowse:lReadOnly := lDelRot
	oGetRas:oBrowse:Refresh()

	oGetEns:oBrowse:lReadOnly := lDelRot
	oGetEns:oBrowse:Refresh()

	oGetIns:oBrowse:lReadOnly := lDelRot
	oGetIns:oBrowse:Refresh()

	oGetNCs:oBrowse:lReadOnly := lDelRot
	oGetNCs:oBrowse:Refresh()   
	
	oTexto:lReadOnly  := lDelRot
	oTexto:Refresh()
	
	If Len(oGetRot:aCols) > Len(aEspecificacao)           

		//Define a posicao do Roteiro Atual
		nRoteiro := oGetRot:oBrowse:nAt
	
		AADD(aEspecificacao,{Space(02),{},{},{},{},{},{},{}})
	
		//Adiciona um elemento vazio as Operacoes
		aEspecificacao[nRoteiro,_OPE]:= QPA010FilCol(aHeaderQQK,"QQK",1,"","",,.T.)

		//Adiciona um elemento vazio a Nao-conformidades     
		Aadd(aEspecificacao[nRoteiro,_RAS],QPA010FilCol(aHeaderQQ2,"QQ2",1,"","",,.T.))
               
		//Adiciona um elemento vazio para a Observacao da Operacao
		Aadd(aEspecificacao[nRoteiro,_TXT],Space(TamSX3("QA2_TEXTO")[1]))

    	//Adiciona um elemento vazio aos Ensaios    
		Aadd(aEspecificacao[nRoteiro,_ENS],QPA010FilCol(aHeaderQP7,"QP7",1,"","",,.T.))
			
	    //Adiciona um elemento vazio a Familia de Instrumentos
		Aadd(aEspecificacao[nRoteiro,_INS],{QPA010FilCol(aHeaderQQ1,"QQ1",1,"","",,.T.)})
		
		//Adiciona um elemento	 vazio a Nao-conformidades     
		Aadd(aEspecificacao[nRoteiro,_NCO],{QPA010FilCol(aHeaderQP9,"QP9",1,"","",,.T.)})

		//Adiciona um elemento vazio para o Plano de Amostragem
		Aadd(aEspecificacao[nRoteiro,_PAE],{QPA010FilCol(aHeaderQQH,"QQH",1,"","",,.T.)}) 
		
		//Define a posicao da Operacao Atual
		nOperacao := 1

		//Define a posicao do Ensaio Atual
		nEnsaio := 1 
		
	ElseIf Len(oGetRot:aCols) < Len(aEspecificacao)  

		//Deleta Operação     
		aDel(aEspecificacao[nRoteiro,_OPE],Len(aEspecificacao[nRoteiro,_OPE]))
		aSize(aEspecificacao[nRoteiro,_OPE],Len(aEspecificacao[nRoteiro,_OPE])-1)

		//Deleta Rastreabilidade
		aDel(aEspecificacao[nRoteiro,_RAS],Len(aEspecificacao[nRoteiro,_RAS]))
		aSize(aEspecificacao[nRoteiro,_RAS],Len(aEspecificacao[nRoteiro,_RAS])-1)
               
		//Deleta Texto
		aDel(aEspecificacao[nRoteiro,_TXT],Len(aEspecificacao[nRoteiro,_TXT]))
		aSize(aEspecificacao[nRoteiro,_TXT],Len(aEspecificacao[nRoteiro,_TXT])-1)

    	//Deleta Ensaio
		aDel(aEspecificacao[nRoteiro,_ENS],Len(aEspecificacao[nRoteiro,_ENS])) 
		aSize(aEspecificacao[nRoteiro,_ENS],Len(aEspecificacao[nRoteiro,_ENS])-1)
			
	    //Deleta Instrumento
		aDel(aEspecificacao[nRoteiro,_INS],Len(aEspecificacao[nRoteiro,_INS]))
		aSize(aEspecificacao[nRoteiro,_INS],Len(aEspecificacao[nRoteiro,_INS])-1)
		
		//Deleta  Nao-conformidades     
		aDel(aEspecificacao[nRoteiro,_NCO],Len(aEspecificacao[nRoteiro,_NCO]))
		aSize(aEspecificacao[nRoteiro,_NCO],Len(aEspecificacao[nRoteiro,_NCO])-1)

		//Deleta  Plano de Amostragem
		aDel(aEspecificacao[nRoteiro,_PAE],Len(aEspecificacao[nRoteiro,_PAE]))
		aSize(aEspecificacao[nRoteiro,_PAE],Len(aEspecificacao[nRoteiro,_PAE])-1)  
		
		//Deleta Roteiro     
		aDel(aEspecificacao,nRoteiro)
		aSize(aEspecificacao,nRoteiro-1)

		//Define a posicao do Roteiro Atual
		nRoteiro := oGetRot:oBrowse:nAt

		//Define a posicao da Operacao Atual
		nOperacao := 1

		//Define a posicao do Ensaio Atual
		nEnsaio := 1
		
	Else   
	
		//Define a posicao do Roteiro Atual
		nRoteiro := oGetRot:oBrowse:nAt
		
		//Define a posicao da Operacao Atual
		nOperacao := 1

		//Define a posicao do Ensaio Atual
		nEnsaio := 1 
		
	EndIf
	
	FolderRest("1234567",.T.)	 //Restaura as associacoes referentes a Operacao Corrente
	
EndIF

If At("1",cChange) > 0 //Operacao 
	
	If nOperacao <> oGetOper:oBrowse:nAt 
		//Salva os dados editados
		FolderSave("123456")
	EndIF     
	
	//Verifica se esta deletado ou nao para bloquear\desbloquear objetos 
	lDelOpe := oGetOper:aCols[oGetOper:oBrowse:nAt,Len(oGetOper:aCols[oGetOper:oBrowse:nAt])]
	
	oGetRas:oBrowse:lReadOnly := lDelOpe
	oGetRas:oBrowse:Refresh()

	oGetEns:oBrowse:lReadOnly := lDelOpe
	oGetEns:oBrowse:Refresh()
                                                     
	oGetIns:oBrowse:lReadOnly := lDelOpe
	oGetIns:oBrowse:Refresh()

	oGetNCs:oBrowse:lReadOnly := lDelOpe
	oGetNCs:oBrowse:Refresh() 

	oTexto:lReadOnly  := lDelOpe
	oTexto:Refresh()

	//Define a posicao da Operacao Atual
	nOperacao := oGetOper:oBrowse:nAt

	If Len(oGetOper:aCols) > Len(aEspecificacao[nRoteiro,_ENS])  
	
		//Adiciona um elemento vazio a Nao-conformidades     
		Aadd(aEspecificacao[nRoteiro,_RAS],QPA010FilCol(aHeaderQQ2,"QQ2",1,"","",,.T.))
               
		//Adiciona um elemento vazio para a Observacao da Operacao
		Aadd(aEspecificacao[nRoteiro,_TXT],Space(TamSX3("QA2_TEXTO")[1]))

    	//Adiciona um elemento vazio aos Ensaios    
		Aadd(aEspecificacao[nRoteiro,_ENS],QPA010FilCol(aHeaderQP7,"QP7",1,"","",,.T.))
			
	    //Adiciona um elemento vazio a Familia de Instrumentos
		Aadd(aEspecificacao[nRoteiro,_INS],{QPA010FilCol(aHeaderQQ1,"QQ1",1,"","",,.T.)})
		
		//Adiciona um elemento	 vazio a Nao-conformidades     
		Aadd(aEspecificacao[nRoteiro,_NCO],{QPA010FilCol(aHeaderQP9,"QP9",1,"","",,.T.)})

		//Adiciona um elemento vazio para o Plano de Amostragem
		Aadd(aEspecificacao[nRoteiro,_PAE],{QPA010FilCol(aHeaderQQH,"QQH",1,"","",,.T.)})
		
		//Define a posicao do Ensaio Atual
		nEnsaio := 1
		
	ElseIf Len(oGetOper:aCols) < Len(aEspecificacao[nRoteiro,_ENS])  

		//Adiciona um elemento vazio a Nao-conformidades     
		aDel(aEspecificacao[nRoteiro,_RAS],Len(aEspecificacao[nRoteiro,_RAS]))
		aSize(aEspecificacao[nRoteiro,_RAS],Len(aEspecificacao[nRoteiro,_RAS])-1)
               
		//Adiciona um elemento vazio para a Observacao da Operacao
		aDel(aEspecificacao[nRoteiro,_TXT],Len(aEspecificacao[nRoteiro,_TXT]))
		aSize(aEspecificacao[nRoteiro,_TXT],Len(aEspecificacao[nRoteiro,_TXT])-1)

    	//Adiciona um elemento vazio aos Ensaios    
		aDel(aEspecificacao[nRoteiro,_ENS],Len(aEspecificacao[nRoteiro,_ENS])) 
		aSize(aEspecificacao[nRoteiro,_ENS],Len(aEspecificacao[nRoteiro,_ENS])-1)
			
	    //Adiciona um elemento vazio a Familia de Instrumentos
		aDel(aEspecificacao[nRoteiro,_INS],Len(aEspecificacao[nRoteiro,_INS]))
		aSize(aEspecificacao[nRoteiro,_INS],Len(aEspecificacao[nRoteiro,_INS])-1)
		
		//Adiciona um elemento	 vazio a Nao-conformidades     
		aDel(aEspecificacao[nRoteiro,_NCO],Len(aEspecificacao[nRoteiro,_NCO]))
		aSize(aEspecificacao[nRoteiro,_NCO],Len(aEspecificacao[nRoteiro,_NCO])-1)

		//Adiciona um elemento vazio para o Plano de Amostragem
		aDel(aEspecificacao[nRoteiro,_PAE],Len(aEspecificacao[nRoteiro,_PAE]))
		aSize(aEspecificacao[nRoteiro,_PAE],Len(aEspecificacao[nRoteiro,_PAE])-1)
		
		//Define a posicao do Ensaio Atual
		nEnsaio := 1
		
	Else
		//Define a posicao do Ensaio Atual
		nEnsaio := 1 
		
	EndIf
	
	FolderRest("234567",.T.)	 //Restaura as associacoes referentes a Operacao Corrente
	
EndIf

If At("4",cChange) > 0 //Ensaios
	                                 
	//Salva os dados editados para a Operacao corrente
	If oGetEns:oBrowse:nAt <> nEnsaio
		FolderSave("456")	
	EndIf  
	
	//Verifica se esta deletado ou nao para bloquear\desbloquear objetos 
	lDelEns := oGetEns:aCols[oGetEns:oBrowse:nAt,Len(oGetEns:aCols[oGetEns:oBrowse:nAt])]
                                                     
	oGetIns:oBrowse:lReadOnly := lDelEns
	oGetIns:oBrowse:Refresh()

	oGetNCs:oBrowse:lReadOnly := lDelEns
	oGetNCs:oBrowse:Refresh()  
	
	oTexto:lReadOnly  := lDelEns
	oTexto:Refresh()

	//Define a posicao do Ensaio Atual na Operacao 
	nEnsaio := oGetEns:oBrowse:nAt 
	
	//Adiciona um elemento vazio a Familia de Instrumentos
	If Len(oGetEns:aCols) > Len(aEspecificacao[nRoteiro,_INS,nOperacao])
		While Len(oGetEns:aCols) > Len(aEspecificacao[nRoteiro,_INS,nOperacao])
			Aadd(aEspecificacao[nRoteiro,_INS,nOperacao],QPA010FilCol(aHeaderQQ1,"QQ1",1,"","",,.T.))
		Enddo
	ElseIf Len(oGetEns:aCols) < Len(aEspecificacao[nRoteiro,_INS,nOperacao])		
		aDel(aEspecificacao[nRoteiro,_INS,nOperacao],Len(aEspecificacao[nRoteiro,_INS,nOperacao]))
		aSize(aEspecificacao[nRoteiro,_INS,nOperacao],Len(aEspecificacao[nRoteiro,_INS,nOperacao])-1)	
		
	EndIf
		
	//Adiciona um elemento vazio a Nao-conformidades     
	If Len(oGetEns:aCols) > Len(aEspecificacao[nRoteiro,_NCO,nOperacao])
	    While Len(oGetEns:aCols) > Len(aEspecificacao[nRoteiro,_NCO,nOperacao])
			Aadd(aEspecificacao[nRoteiro,_NCO,nOperacao],QPA010FilCol(aHeaderQP9,"QP9",1,"","",,.T.))
		Enddo
		
	ElseIf Len(oGetEns:aCols) < Len(aEspecificacao[nRoteiro,_NCO,nOperacao])
		aDel(aEspecificacao[nRoteiro,_NCO,nOperacao],Len(aEspecificacao[nRoteiro,_NCO,nOperacao]))	         
		aSize(aEspecificacao[nRoteiro,_NCO,nOperacao],Len(aEspecificacao[nRoteiro,_NCO,nOperacao])-1)	
		
	EndIf                 
	
	//Adiciona um elemento vazio para o Plano de Amostragem
	If Len(oGetEns:aCols) > Len(aEspecificacao[nRoteiro,_PAE,nOperacao])
	    While Len(oGetEns:aCols) > Len(aEspecificacao[nRoteiro,_PAE,nOperacao])
			Aadd(aEspecificacao[nRoteiro,_PAE,nOperacao],QPA010FilCol(aHeaderQQH,"QQH",1,"","",,.T.))
		Enddo		
	ElseIf Len(oGetEns:aCols) < Len(aEspecificacao[nRoteiro,_PAE,nOperacao])
		aDel(aEspecificacao[nRoteiro,_PAE,nOperacao],Len(aEspecificacao[nRoteiro,_PAE,nOperacao]))
		aSize(aEspecificacao[nRoteiro,_PAE,nOperacao],Len(aEspecificacao[nRoteiro,_PAE,nOperacao])-1)
		
	EndIf

	FolderRest("567",.T.)  //Restaura as associacoes referentes ao Ensaio
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variavel utlizada para definir a posicao do Ensaio atual na  ³
//³ consulta F3 para as Nao-Conformidades associadas ao Ensaio.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
__cENSAIO := oGetEns:aCols[nEnsaio,nPosEns]

Return(NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao	 ³ FolderSave  ³Autor³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Salva a edicao de dados nos respectivos Folders			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FolderSave(EXPC1)		 							      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function FolderSave(cSave) 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva os dados editados nos folders correntes 				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
If At("1",cSave) > 0 //Operacao
	aEspecificacao[nRoteiro,_OPE] := aClone(oGetOper:aCols)
EndIf	
		
If At("2",cSave) > 0 //Rastreabilidade
	aEspecificacao[nRoteiro,_RAS,nOperacao] := aClone(oGetRas:aCols)
EndIf	

If At("3",cSave) > 0 //Observacao da Operacao
	aEspecificacao[nRoteiro,_TXT,nOperacao] := cTexto
EndIf	

If At("4",cSave) > 0  //Ensaios
	aEspecificacao[nRoteiro,_ENS,nOperacao] := aClone(oGetEns:aCols)
EndIf	
		
If At("5",cSave) > 0 //Familia de Instrumentos
	aEspecificacao[nRoteiro,_INS,nOperacao,nEnsaio] := aClone(oGetIns:aCols)
EndIf		
		
If At("6",cSave) > 0 //Nao-conformidades
	aEspecificacao[nRoteiro,_NCO,nOperacao,nEnsaio] := aClone(oGetNCs:aCols)
EndIf               

If At("7",cSave) > 0 //Roteiro
	aRoteiros := aClone(oGetRot:aCols) 
	If nRoteiro <= Len(oGetRot:aCols)
		aEspecificacao[nRoteiro,_ROT] := oGetRot:aCols[nRoteiro,1]
	EndIF
EndIf               

Return(NIL)                                  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao	 ³ FolderRest  ³Autor³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Restaura os dados para edicao nos respectivos Folders	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FolderRest(EXPC1,EXPL1)	 							      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function FolderRest(cRestaura,lRefresh)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva os dados editados nos folders correntes 				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
If At("1",cRestaura) > 0 //Operacao
	oGetOper:aCols := aClone(aEspecificacao[nRoteiro,_OPE])
	If lRefresh
		oGetOper:oBrowse:nAt := 1
		oGetOper:oBrowse:Refresh()
	EndIf 
EndIf	
		
If At("2",cRestaura) > 0 //Rastreabilidade
	oGetRas:aCols := aClone(aEspecificacao[nRoteiro,_RAS,nOperacao])
	If lRefresh
		oGetRas:oBrowse:nAt := 1
		oGetRas:oBrowse:Refresh()
	EndIf	
EndIf	

If At("3",cRestaura) > 0 //Observacao da Operacao
	cTexto := aEspecificacao[nRoteiro,_TXT,nOperacao]
	If lRefresh
		oTexto:Refresh()
	EndIf	
EndIf	

If At("4",cRestaura) > 0  //Ensaios
	oGetEns:aCols := aClone(aEspecificacao[nRoteiro,_ENS,nOperacao])
	If lRefresh
		oGetEns:oBrowse:nAt := 1
		oGetEns:oBrowse:Refresh()
	EndIf	
EndIf	

If At("5",cRestaura) > 0 //Familia de Instrumentos
	oGetIns:aCols := aClone(aEspecificacao[nRoteiro,_INS,nOperacao,nEnsaio])
	If lRefresh            
		oGetIns:oBrowse:nAt := 1
		oGetIns:oBrowse:Refresh()
	EndIf
EndIf		
		
If At("6",cRestaura) > 0 //Nao-conformidades
	oGetNCs:aCols := aClone(aEspecificacao[nRoteiro,_NCO,nOperacao,nEnsaio])
	If lRefresh
		oGetNCs:oBrowse:nAt := 1
	 	oGetNCs:oBrowse:Refresh()
	EndIf
EndIf               

If At("7",cRestaura) > 0 //Roteiros
	oGetRot:aCols := aClone(aRoteiros)
	If lRefresh
	 	oGetRot:oBrowse:Refresh()
	EndIf
EndIf               

Return(NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao	 ³ FolderDelete³Autor³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Controla a exclusao de dados nos respectivos Folders		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FolderDelete(EXPC1)		 							      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function FolderDelete(cDelete)
Local lDelRot
Local lDelOpe 
Local lDelEns
Local nPosDel := 0
Local nOpe    := 0
Local nEns    := 0
Local lRet    := .T.
Local nY      := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a Operacao Corrente								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
If At("7",cDelete) > 0 
                                             
	lDelRot := oGetRot:aCols[oGetRot:oBrowse:nAt,Len(oGetRot:aCols[oGetRot:oBrowse:nAt])]

	If !lDelRot
		//Verifica se esta com roteiro repetido
		For nY:=1 to Len(oGetRot:aCols)
			If  oGetRot:aCols[nY,1]== oGetRot:aCols[oGetRot:oBrowse:nAt,1] .and. oGetRot:oBrowse:nAT<>nY .and. !oGetRot:aCols[nY,3]
				MsgAlert(STR0041+ oGetRot:aCols[oGetRot:oBrowse:nAt,1] +STR0042) //"O Roteiro " ### " ja foi cadastrado para esse produto."
				lRet := .F.
				Exit
			EndIF       
		Next nY   
    EndIF
    
    If lRet

		Aeval(oGetOper:aCols,{|x,y|oGetOper:aCols[y,Len(oGetOper:aCols[y])]:=lDelRot}) //Operacao  
		oGetOper:oBrowse:lReadOnly := lDelRot
		oGetOper:oBrowse:Refresh()

   		Aeval(oGetRas:aCols,{|x,y|oGetRas:aCols[y,Len(oGetRas:aCols[y])]:=lDelRot}) //Rastreabilidade
		oGetRas:oBrowse:lReadOnly := lDelRot
		oGetRas:oBrowse:Refresh()
   	
		Aeval(oGetEns:aCols,{|x,y|oGetEns:aCols[y,Len(oGetEns:aCols[y])]:=lDelRot}) //Ensaios
		oGetEns:oBrowse:lReadOnly := lDelRot
		oGetEns:oBrowse:Refresh()

   		Aeval(oGetIns:aCols,{|x,y|oGetIns:aCols[y,Len(oGetIns:aCols[y])]:=lDelRot}) //Familia de Instrumentos
		oGetIns:oBrowse:lReadOnly := lDelRot
		oGetIns:oBrowse:Refresh()

		Aeval(oGetNCs:aCols,{|x,y|oGetNCs:aCols[y,Len(oGetNCs:aCols[y])]:=lDelRot}) //Nao-conformidades
		oGetNCs:oBrowse:lReadOnly := lDelRot
		oGetNCs:oBrowse:Refresh() 
	
		oTexto:lReadOnly  := lDelRot
		oTexto:Refresh()
	Else 
		oGetRot:aCols[oGetRot:oBrowse:nAt,3] := .T.   
		oGetRot:Refresh()
	EndIF	

EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a Operacao Corrente								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
If At("1",cDelete) > 0 

	//Verifica se o roteiro esta deletado antes de excluir ou nao os outros itens
	lDelRot := oGetRot:aCols[oGetRot:oBrowse:nAt,Len(oGetRot:aCols[oGetRot:oBrowse:nAt])]

	If !lDelRot
		lDelOpe := oGetOper:aCols[oGetOper:oBrowse:nAt,Len(oGetOper:aCols[oGetOper:oBrowse:nAt])]

  		Aeval(oGetRas:aCols,{|x,y|oGetRas:aCols[y,Len(oGetRas:aCols[y])]:=lDelOpe}) //Rastreabilidade
		oGetRas:oBrowse:lReadOnly := lDelOpe
   		oGetRas:oBrowse:Refresh()

   		Aeval(oGetEns:aCols,{|x,y|oGetEns:aCols[y,Len(oGetEns:aCols[y])]:=lDelOpe}) //Ensaios
		oGetEns:oBrowse:lReadOnly := lDelOpe
   		oGetEns:oBrowse:Refresh()

  		Aeval(oGetIns:aCols,{|x,y|oGetIns:aCols[y,Len(oGetIns:aCols[y])]:=lDelOpe}) //Familia de Instrumentos
		oGetIns:oBrowse:lReadOnly := lDelOpe
   		oGetIns:oBrowse:Refresh()

   		Aeval(oGetNCs:aCols,{|x,y|oGetNCs:aCols[y,Len(oGetNCs:aCols[y])]:=lDelOpe}) //Nao-conformidades
		oGetNCs:oBrowse:lReadOnly := lDelOpe
   		oGetNCs:oBrowse:Refresh() 
   		
   		oTexto:lReadOnly  := lDelOpe
		oTexto:Refresh()
	
	Else
		Aeval(oGetOper:aCols,{|x,y|oGetOper:aCols[y,Len(oGetOper:aCols[y])]:=lDelRot}) //Operacao
		oGetOper:oBrowse:Refresh()
	EndIF    

EndIF

If At("1",cDelete) > 0 .or. At("7",cDelete) > 0

	lDelOpe := oGetOper:aCols[oGetOper:oBrowse:nAt,Len(oGetOper:aCols[oGetOper:oBrowse:nAt])]
	
	//Familia de Instrumentos salva no aEspecificacoes										 
	For nOpe := 1 to Len(aEspecificacao[nRoteiro,_INS,oGetOper:oBrowse:nAt])	
		For nEns := 1 to Len(aEspecificacao[nRoteiro,_INS,oGetOper:oBrowse:nAt,nOpe])  
			nPosDel := Len(aEspecificacao[nRoteiro,_INS,oGetOper:oBrowse:nAt,nOpe,nEns])
			aEspecificacao[nRoteiro,_INS,oGetOper:oBrowse:nAt,nOpe,nEns,nPosDel] := lDelOpe
	    Next nEns
	Next nOpe	                  

	//Nao-Conformidades salva no aEspecificacoes
	For nOpe := 1 to Len(aEspecificacao[nRoteiro,_NCO,oGetOper:oBrowse:nAt])	
		For nEns := 1 to Len(aEspecificacao[nRoteiro,_NCO,oGetOper:oBrowse:nAt,nOpe])  
			nPosDel := Len(aEspecificacao[nRoteiro,_NCO,oGetOper:oBrowse:nAt,nOpe,nEns])
			aEspecificacao[nRoteiro,_NCO,oGetOper:oBrowse:nAt,nOpe,nEns,nPosDel] := lDelOpe		
	    Next nEns
	Next nOpe	                  

	//Planos de Amostragens por Ensaios salvos no aEspecificacoes
	For nOpe := 1 to Len(aEspecificacao[nRoteiro,_PAE,oGetOper:oBrowse:nAt])	
		For nEns := 1 to Len(aEspecificacao[nRoteiro,_PAE,oGetOper:oBrowse:nAt,nOpe])  
			nPosDel := Len(aEspecificacao[nRoteiro,_PAE,oGetOper:oBrowse:nAt,nOpe,nEns])
			aEspecificacao[nRoteiro,_PAE,oGetOper:oBrowse:nAt,nOpe,nEns,nPosDel] := lDelOpe
	    Next nEns
	Next nOpe	                  

EndIf
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o Ensaio corrente     								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
If At("4",cDelete) > 0  

	lDelOpe := oGetOper:aCols[oGetOper:oBrowse:nAt,Len(oGetOper:aCols[oGetOper:oBrowse:nAt])]
	
	If !lDelOpe
		lDelEns := oGetEns:aCols[oGetEns:oBrowse:nAt,Len(oGetEns:aCols[oGetEns:oBrowse:nAt])]
		
	    //Familia de Instrumentos editada na GetDados
		Aeval(oGetIns:aCols,{|x,y|oGetIns:aCols[y,Len(oGetIns:aCols[y])]:=lDelEns})
		oGetIns:oBrowse:lReadOnly := lDelEns
   		oGetIns:oBrowse:Refresh()
	                                             
		//Nao-Conformidades editada na GetDados	
		Aeval(oGetNCs:aCols,{|x,y|oGetNCs:aCols[y,Len(oGetNCs:aCols[y])]:=lDelEns})
		oGetNCs:oBrowse:lReadOnly := lDelEns
   		oGetNCs:oBrowse:Refresh()  
   		
		oTexto:lReadOnly  := lDelEns
		oTexto:Refresh()
		                             
		//Familia de Instrumentos salva no aEspecificacoes										 
		For nEns := 1 to Len(aEspecificacao[nRoteiro,_INS,oGetOper:oBrowse:nAt,oGetEns:oBrowse:nAt])  
			nPosDel := Len(aEspecificacao[nRoteiro,_INS,oGetOper:oBrowse:nAt,oGetEns:oBrowse:nAt,nEns])	
			If nEns <> oGetEns:oBrowse:nAt 
				aEspecificacao[nRoteiro,_INS,oGetOper:oBrowse:nAt,oGetEns:oBrowse:nAt,nEns,nPosDel] := lDelEns		
			EndIf		
   		Next nEns

		//Nao-Conformidades salva no aEspecificacoes
		For nEns := 1 to Len(aEspecificacao[nRoteiro,_NCO,oGetOper:oBrowse:nAt,oGetEns:oBrowse:nAt])  
			nPosDel := Len(aEspecificacao[nRoteiro,_NCO,oGetOper:oBrowse:nAt,oGetEns:oBrowse:nAt,nEns])
			If nEns <> oGetEns:oBrowse:nAt
				aEspecificacao[nRoteiro,_NCO,oGetOper:oBrowse:nAt,oGetEns:oBrowse:nAt,nEns,nPosDel] := lDelEns		
			EndIf	
   	    Next nEns
                      
		//Planos de Amostragens por Ensaios salvos no aEspecificacoes
		For nEns := 1 to Len(aEspecificacao[nRoteiro,_PAE,oGetOper:oBrowse:nAt,oGetEns:oBrowse:nAt])  
			nPosDel := Len(aEspecificacao[nRoteiro,_PAE,oGetOper:oBrowse:nAt,oGetEns:oBrowse:nAt,nEns])
			If nEns <> oGetEns:oBrowse:nAt	
				aEspecificacao[nRoteiro,_PAE,oGetOper:oBrowse:nAt,oGetEns:oBrowse:nAt,nEns,nPosDel] := lDelEns		
			EndIf	
	    Next nEns
	Else
   		Aeval(oGetEns:aCols,{|x,y|oGetEns:aCols[y,Len(oGetEns:aCols[y])]:=lDelOpe}) //Ensaios
		oGetEns:oBrowse:Refresh()
	EndIf
	
EndIf

Return(NIL)                                   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³FolderValid ³ Autor³Paulo Emidio de Barros³ Data ³12/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Controla a edicao dos dados relacionadas a Operacao edita- ³±±
±±³			 ³ da pelo Usuario.										   	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FolderValid(EXPC1)										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function FolderValid(cNivFld,lValido)               

Local lEdita   := .T.
Local lLap     := .F.   
Local cProduto := IIF(lFase3,IIf(lProduto,M->QP6_PRODUT,M->QQC_GRUPO),__cGRPPROD)

If Inclui .Or. Altera
	If At("7",cNivFld) > 0 //Consiste o cabecalho dos Roteiros
		If Empty(oGetRot:aCols[nRoteiro,1])
			Help(" ",1,"QP010NROTE",,,1) //O Roteiro de Operacoes nao foi informado
   			lLap := If(lLap,lLap,.T.)                                               
			oGetRot:oBrowse:Refresh()
			oGetRot:oBrowse:SetFocus()
		EndIf
	EndIF
		
	If At("0",cNivFld) > 0 //Consiste o cabecalho da Especificacao
		If !Obrigatorio(aGets,aTela) //Verifica se todos os campos da Especificacao foram preenchidos
			oEncEsp:SetFocus()    
			lLap := If(lLap,lLap,.T.)
		Else               
			If lProduto //Verifica se o produto informado pertence a algum Grupo
				QPA->(dbSetOrder(2))
				QPA->(dbSeek(xFilial("QPA")+cProduto))
				If QPA->(!Eof())   
					If lFase3 
						If !lProduto
							Help(" ",1,"QP010PROGR",,,1) //Para realizar manutencao na especificacao selecionada, a mesma dever ser atraves do Grupo de Produtos.
							oEncEsp:SetFocus()  
							lLap := If(lLap,lLap,.T.)
						EndIf
					Else
						Help(" ",1,"QP010PROGR",,,1) //Para realizar manutencao na especificacao selecionada, a mesma dever ser atraves do Grupo de Produtos.
						oEncEsp:SetFocus()  
						lLap := If(lLap,lLap,.T.)
					EndIF
				EndIf      
				If !lLap .And. Empty(M->QP6_CODREC)
					Help(" ",1,"QP010NROTE",,,1) //O Roteiro de Operacoes nao foi informado
					oEncEsp:SetFocus()  
					lLap := If(lLap,lLap,.T.)
				EndIf
			Else
				If Empty(M->QQC_CODREC)
					Help(" ",1,"QP010NROTE",,,1) //O Roteiro de Operacoes nao foi informado	
					oEncEsp:SetFocus()  
					lLap := If(lLap,lLap,.T.)
				EndIf	
			EndIf
		EndIf
	
		If cNivFld == "0"
			If ValType(lValido) == "L" .And. !lValido
				oGetEns:oBrowse:SetFocus()
			EndIf
		EndIf 
	
	EndIf

	If !lLap .And. At("1",cNivFld) > 0 //Consiste as Operacoes
		If Empty(oGetOper:aCols[oGetOper:oBrowse:nAt,nPosOper])     .Or.;
			Empty(oGetOper:aCols[oGetOper:oBrowse:nAt,nPosRecurso]) .Or.;
			Empty(oGetOper:aCols[oGetOper:oBrowse:nAt,nPosDescri])  .Or.;
			Empty(oGetOper:aCols[oGetOper:oBrowse:nAt,nPosTemPad])  .Or.;
			Empty(oGetOper:aCols[oGetOper:oBrowse:nAt,nPosTpOper])  .Or.;
			Empty(oGetOper:aCols[oGetOper:oBrowse:nAt,nPosOpeObr])  .Or.;
			Empty(oGetOper:aCols[oGetOper:oBrowse:nAt,nPosSeqObr])  .Or.;
			Empty(oGetOper:aCols[oGetOper:oBrowse:nAt,nPosLauObr])
			
			Help(" ",1,"QP010NOPER",,,1) //Nao sera possivel associar os ensaios associados a esta operacao.
			oGetOper:oBrowse:Refresh()
			oGetOper:oBrowse:SetFocus()
			lLap := If(lLap,lLap,.T.)
		EndIf
	EndIf           

	If !lLap .And. At("4",cNivFld) > 0 //Consiste os Ensaios
	
		If !Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns])
			QP1->(dbSetOrder(1))
			QP1->(dbSetOrder(1))
			If QP1->(dbSeek(xFilial("QP1")+oGetEns:aCols[oGetEns:oBrowse:nAt,nPosEns]))
		
				If Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosLab]) .Or.;
					Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosSeq]).Or.;
					Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosObr])
		  			lEdita := .F.
				Else 
					If QP1->QP1_TPCART <> "X" //Mensuraveis
						If Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosUM])   .Or.;
							Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosMin]) .Or.;    
							Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosNom])
				  			lEdita := .F.
						Else	                                               
							If oGetEns:aCols[oGetEns:oBrowse:nAt,nPosMin] == "2" //Minimo
								If Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosAFI])
						  			lEdita := .F.
								EndIf             
							ElseIf oGetEns:aCols[oGetEns:oBrowse:nAt,nPosMin] == "3" //Maximo
								If Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosAFS])
						  			lEdita := .F.
					            EndIf
							Else //Minimo e Maximo
								If Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosAFI]) .Or.;
									Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosAFS])
						  			lEdita := .F.
					            EndIf
							EndIf
						EndIf	                        
					Else //Texto
						If Empty(oGetEns:aCols[oGetEns:oBrowse:nAt,nPosTxt])
				  			lEdita := .F.
						EndIf
					EndIf	
			    EndIf
			EndIf
		Else
			lEdita := .F.
		EndIf
		
		If !lEdita
			Help(" ",1,"QP010NOENS",,,1) //Nao sera possivel a associacao de Instrumentos e/ou Nao-Conformidades ao Ensaio corrente.                         
			oGetEns:oBrowse:Refresh()
			oGetEns:oBrowse:SetFocus()
		EndIf
	
	EndIf
EndIf
Return(NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP010VlRA ³ Autor ³ Paulo Emidio de Barros³ Data ³28/04/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Validacao do Roteiro Auxiliar							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 - Apenas Fase3									  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP010VlRA()

Local cRoteiro := &(ReadVar()) 
Local cProduto := IIf(lProduto,M->QP6_CODSIM,M->QQC_CODSIM) 
Local cRevi    := IIf(lProduto,M->QP6_REVI,M->QQC_REVI)
Local cAlias   := Alias()
Local lRetorno := .T.  

If !INCLUI
	Return(lRetorno)     
EndIf

If !Empty(cRoteiro)
	If !Empty(cProduto)
		SG2->(dbSeek(xFilial("SG2")+cProduto+cRoteiro))
		If SG2->(Eof())
			Help(" ",1,"A630ROTNAE")
			lRetorno := .F.
		EndIf
	Else
		If !SG2->(Eof()) .And. xFilial("SG2")==SG2->G2_FILIAL
			If lProduto
				M->QP6_CODSIM := SG2->G2_PRODUTO
			Else
				M->QQC_CODSIM := SG2->G2_PRODUTO
			EndIF
			cProduto := SG2->G2_PRODUTO    
		EndIf
	EndIf
EndIf                

//Preenche o Roteiro de Operacoes com o Produto Similar selecionado
If lRetorno .AND. !Empty(cRoteiro)
	QP010FilRot(cProduto,QA_UltRevEsp(cProduto,,,.T.,"QIP"),cRoteiro)	
EndIf

dbSelectArea(cAlias)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ QP010VlPA ³ Autor ³Paulo Emidio de Barros³ Data ³28/04/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Validacao do Produto Auxiliar							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010	 - Apenas Fase3									  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP010VlPA()
Local cProduto := &(ReadVar()) 
Local cRotSim  := IIf(lProduto,M->QP6_ROTSIM,M->QQC_ROTSIM)
Local cRevi    := IIf(lProduto,M->QP6_REVI,M->QQC_REVI)
Local cAlias   := Alias()
Local lRetorno := .T.

If !INCLUI
	Return(lRetorno)     
EndIf

If !Empty(cProduto)
	If !Empty(cRotSim)
		SG2->(dbSeek(xFilial("SG2")+cProduto+cRotSim))
		If SG2->(Eof())
			Help(" ",1,"A630ROTNAE")
			lRetorno := .F.  
		EndIf
	EndIf
EndIf

//Preenche o Roteiro de Operacoes com o Produto Similar selecionado
If lRetorno
	QP010FilRot(cProduto,QA_UltRevEsp(cProduto,,,.T.,"QIP"),cRotSim)	
EndIf 

dbSelectArea(cAlias)
Return(lRetorno)     

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QP010FilRot ³ Autor³Paulo Emidio de Barros³ Data ³20/02/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Preenche as Operacoes a partir de um Roteiro selecionado na³±±
±±³			 ³ inclusao da Especificacao.								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP010FilRot(cProduto,cRevisao,cRoteiro) 					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 - Apenas Fase 3									  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function QP010FilRot(cProduto,cRevisao,cRoteiro,lInc,lF4)
Local aColsAux  := {}  
Local aAreaSG2  := SG2->(GetArea())
Local lRetorno  := .T.
Local nX        := 0
Local nY        := 0
Local cCampo    := " "
Local nReg      := 0
Local nPos      := 0
Local cRotMem   := 0 
Local lCpo      
Local lIncRot 
Local cPesqSG2      
Local nRot      := 0
Local cEspecie  := "QIPA010 "             //Texto do Produto  
Local nTamLin   := TamSX3("QA2_TEXTO")[1]
Local aTexto    := {}
Local cChave    := " "  
Local aCpoUsu   := {}  
Local cSeeks    := ""  
Local nSaveSX8  := GetSX8Len()
Local y
Default  lInc := .F.                                    
Default  lF4  := .F.	

If Empty(cProduto)
	Return(lRetorno)
EndIF

If Inclui .or. lIncF4    

	SX3->(dbSetorder(1))
	SX3->(dbSeek("SG2"))
	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SG2"
		If X3Uso(SX3->X3_USADO) .and. SX3->X3_PROPRI == "U"                                      
			If SX3->X3_CONTEXT <> "V"
		    	AADD(aCpoUsu,SX3->X3_CAMPO)
			EndIf                         
	    EndIf
	    SX3->(dbSkip())
	EndDo 
	
	If !Empty(cRoteiro) .and. (ALLTRIM(READVAR())== "M->QQC_ROTSIM" .or. ALLTRIM(READVAR()) == "M->QP6_ROTSIM" .or. (Empty(oGetRot:aCols[oGetRot:nAT,1])).and. lF4)
		cSeek := Alltrim(cProduto+cRoteiro)
	Else
		cSeek := cProduto
	Endif
		
	SG2->(dbSetOrder(1))
	SG2->(dbSeek(xFilial("SG2")+cSeek))
	If SG2->(!Eof()) .AND. lCarRot
		If !lInc
		    aEspecificacao := {}  
			aRoteiros      := {} 
		EndIF
		cPesqSG2 := IF(ALLTRIM(READVAR())== "M->QQC_ROTSIM" .or. ALLTRIM(READVAR()) == "M->QP6_ROTSIM" .or. (Empty(oGetRot:aCols[oGetRot:nAT,1]).and. lF4) ,(Alltrim(SG2->(G2_PRODUTO+G2_CODIGO))),ALLTRIM((SG2->(G2_PRODUTO))))
		While SG2->G2_FILIAL==xFilial("SG2") .And. cPesqSG2== IF( (ALLTRIM(READVAR())== "M->QP6_CODREC" .or. ALLTRIM(READVAR())== "M->QQC_ROTSIM" .or. ALLTRIM(READVAR()) == "M->QP6_ROTSIM") .or. (Empty(oGetRot:aCols[oGetRot:nAT,1]) .and. lF4) ,(Alltrim(cProduto+cRoteiro)),(Alltrim(cProduto)))
		    Aadd(aColsAux,{})
		    nReg++
		    
		  	For nX := 1 To Len(aHeaderQQK)
			    cCampo := AllTrim(aHeaderQQK[nX,2]) 
			    lCpo   := .F.
			    
				If(cCampo=="QQK_CODIGO",( Aadd(aColsAux[nReg],SG2->G2_CODIGO  ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_PRODUT",( Aadd(aColsAux[nReg],SG2->G2_PRODUTO ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_OPERAC",( Aadd(aColsAux[nReg],SG2->G2_OPERAC  ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_RECURS",( Aadd(aColsAux[nReg],SG2->G2_RECURSO ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_FERRAM",( Aadd(aColsAux[nReg],SG2->G2_FERRAM  ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_LINHAP",( Aadd(aColsAux[nReg],SG2->G2_LINHAPR ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_TPLINH",( Aadd(aColsAux[nReg],SG2->G2_TPLINHA ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_DESCRI",( Aadd(aColsAux[nReg],SG2->G2_DESCRI  ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_MAOOBR",( Aadd(aColsAux[nReg],SG2->G2_MAOOBRA ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_SETUP" ,( Aadd(aColsAux[nReg],SG2->G2_SETUP   ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_FORMST",( Aadd(aColsAux[nReg],SG2->G2_FORMSTP ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_LOTEPA",( Aadd(aColsAux[nReg],SG2->G2_LOTEPAD ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_TEMPAD",( Aadd(aColsAux[nReg],SG2->G2_TEMPAD  ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_TPOPER",( Aadd(aColsAux[nReg],SG2->G2_TPOPER  ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_TPSOBR",( Aadd(aColsAux[nReg],SG2->G2_TPSOBRE ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_TEMPSO",( Aadd(aColsAux[nReg],SG2->G2_TEMPSOB ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_TPDESD",( Aadd(aColsAux[nReg],SG2->G2_TPDESD  ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_TEMPDE",( Aadd(aColsAux[nReg],SG2->G2_TEMPDES ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_DESPRO",( Aadd(aColsAux[nReg],SG2->G2_DESPROP ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_CTRAB" ,( Aadd(aColsAux[nReg],SG2->G2_CTRAB   ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_OPE_OB",( Aadd(aColsAux[nReg],SG2->G2_OPE_OBR ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_SEQ_OB",( Aadd(aColsAux[nReg],SG2->G2_SEQ_OBR ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_LAU_OB",( Aadd(aColsAux[nReg],SG2->G2_LAU_OBR ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_REVIPR",( Aadd(aColsAux[nReg],SG2->G2_REVIPRD ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_CHAVE" ,( Aadd(aColsAux[nReg],SG2->G2_CHAVE   ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_ROTALT",( Aadd(aColsAux[nReg],SG2->G2_ROTALT  ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_OPERGR",( Aadd(aColsAux[nReg],SG2->G2_OPERGRP ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_GRSETU",( Aadd(aColsAux[nReg],SG2->G2_GRSETUP ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_GRUPRE",( Aadd(aColsAux[nReg],SG2->G2_GRUPREC ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_NIVMON",( Aadd(aColsAux[nReg],SG2->G2_NIVMONT ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_CHAVMO",( Aadd(aColsAux[nReg],SG2->G2_CHAVMON ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_TMAXPR",( Aadd(aColsAux[nReg],SG2->G2_TMAXPRO ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_TPINTE",( Aadd(aColsAux[nReg],SG2->G2_TPINTER ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_MAXINC",( Aadd(aColsAux[nReg],SG2->G2_MAXINCR ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_FOLMIN",( Aadd(aColsAux[nReg],SG2->G2_FOLMIN  ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_HOROTI",( Aadd(aColsAux[nReg],SG2->G2_HOROTIM ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_GRUPO" ,( Aadd(aColsAux[nReg],CriaVar("QQK_GRUPO",.T.)),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_ALI_WT",( Aadd(aColsAux[nReg],QQK->(Alias()) ),lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				If(cCampo=="QQK_REC_WT",( Aadd(aColsAux[nReg],0 )              ,lCpo:=If(!lCpo,.T.,lCpo) ),NIL)
				        
				//Verifica a necessidade do Inicializador padrao
				If lCpo
					nPos := Len(aColsAux[nReg])             
					If Empty(aColsAux[nReg,nPos]) 
						If ExistIni(cCampo)
							aColsAux[nReg,nPos] := InitPad(cCampo)
						EndIf
					EndIf  
				Else
					For nY:=1 to Len(aCpoUsu)
				   		lCpoUsu := .F.
						If Alltrim(Substr(cCampo,5,6))==Alltrim(Substr(aCpoUsu[nY],4,6)) 
							Aadd(aColsAux[nReg],&("SG2->"+aCpoUsu[nY])) 
							nPos := Len(aColsAux[nReg])             
							If Empty(aColsAux[nReg,nPos]) 
								If ExistIni(cCampo)
									aColsAux[nReg,nPos] := InitPad(cCampo)
								EndIf
							EndIf  
					    EndIf
					Next nY
				EndIf				
		    Next nX
			
		    Aadd(aColsAux[nReg],.F.)
		    
		    //Verifica se esta com roteiro repetido
		    lIncRot := .T.
			For nY:=1 to Len(aRoteiros) 
				IF !aRoteiros[nY,3]  //Verifica se o roteiro não esta deletado.
					If !lIncF4
						If  aRoteiros[nY,1]== SG2->G2_CODIGO
							lIncRot := .F.
							Exit
						EndIF       
		    		Else
						If  aRoteiros[nY,1]== mv_par03
							lIncRot := .F.
							Exit
						EndIF       
		    		EndIF
				EndIF
			Next nY                                                       

			If lIncRot   
				If lProduto 
					cRotMem := M->QP6_CODREC
				Else	
					cRotMem := M->QQC_CODREC
				EndIF
				
				If !lInc
					If SG2->G2_CODIGO == cRotMem                                          
						AADD(aEspecificacao,{SG2->G2_CODIGO,{},{},{},{},{},{},{}})
						AADD(aRoteiros,{SG2->G2_CODIGO,STR0039,.F.}) //"Roteiro Primario"
					Else
						AADD(aEspecificacao,{SG2->G2_CODIGO,{},{},{},{},{},{},{}})
						AADD(aRoteiros,{SG2->G2_CODIGO,STR0040,.F.}) //"Roteiro Secundario"
					EndIF	
			    Else
			    	aEspecificacao[nRoteiro,_ROT] := SG2->G2_CODIGO
					aRoteiros[nRoteiro,1]         := SG2->G2_CODIGO
					aRoteiros[nRoteiro,2]         := IIF(SG2->G2_CODIGO == cRotMem,STR0039,STR0040)
                EndIF

			EndIF 
		    
		    SG2->(dbSkip())   
		    cPesqSG2 := IIf( (ALLTRIM(READVAR()) == "M->QP6_CODREC" .Or. ALLTRIM(READVAR()) == "M->QQC_ROTSIM" .Or. ALLTRIM(READVAR()) == "M->QP6_ROTSIM") .Or. (Empty(oGetRot:aCols[oGetRot:nAT,1]) .And. lF4),(ALLTRIM(SG2->(G2_PRODUTO+G2_CODIGO))),Alltrim(SG2->(G2_PRODUTO)))
		    
			If SG2->(EOF()) .or. SG2->G2_PRODUTO+SG2->G2_CODIGO<>cProduto+aEspecificacao[Len(aEspecificacao),_ROT] 
			    nRot := Len(aEspecificacao)
				aEspecificacao[nRot,_OPE] := aColsAux 
				                                                      
				For nX:=1 to Len(aColsAux)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Cria as subdimensoes utilizadas na Especificacao do Produto  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !lInc .or. (lInc .and. nX>1)
	 					Aadd(aEspecificacao[nRot,_ENS],{}) //Ensaios
   						Aadd(aEspecificacao[nRot,_RAS],{}) //Rastreabilidade
						Aadd(aEspecificacao[nRot,_TXT],{}) //Observacao da Operacao
 						Aadd(aEspecificacao[nRot,_INS],{}) //Familias de Instrumentos associadas aos Ensaios
 						Aadd(aEspecificacao[nRot,_NCO],{}) //Nao-Conformidades associadas aos Ensaios
						Aadd(aEspecificacao[nRot,_PAE],{}) //Plano de Amostragem	
					EndIf
						
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 					//³ Preenche o vetor aESPECIFICACAO com os ensaios vinculados    ³
					//³ aos Roteiros de Operacoes.									 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			   		aEspAux := {}
		
					//Carrega o Rastreamento associado a Operacao
					aEspecificacao[nRot,_RAS,Len(aEspecificacao[nRot,_RAS])] := QPA010FilCol(aHeaderQQ2,"QQ2",1,;
					"QQ2_CODIGO+QQ2_REVI+QQ2_ROTEIR+QQ2_OPERAC",cProduto+cRevisao+aEspecificacao[nRot,_ROT]+aEspecificacao[nRot,_OPE,nX,nPosOper],)
					
					//Carrega o Texto da Observacao da Operacao
					cChave := aEspecificacao[nRot,_OPE,nX,nPosChav]
					aEspecificacao[nRot,_TXT,nX] := If(!Empty(cChave),QA_RecTXT(cChave,cEspecie,00,nTamLin,"QA2",aTexto)," ")
					
					//Altera para um numero de chave propria. 
					aEspecificacao[nRot,_OPE,nX,nPosChav] := QA_SXESXF("QQK","QQK_CHAVE",,2)
					While ( GetSX8Len() > nSaveSx8 )
						ConfirmSX8()
					EndDo
						
					//Ensaios Mensuraveis
					QPA010FilCol(aHeaderQP7,"QP7",1,"QP7_PRODUT+QP7_REVI+QP7_CODREC+QP7_OPERAC",cProduto+cRevisao+aEspecificacao[nRot,_ROT]+aEspecificacao[nRot,_OPE,nX,nPosOper],@aEspAux,.F.)
					
					If Empty(AllTrim(aEspAux[1][1]))
				   		aEspAux := {}
					Endif
					//Ensaios Textos
					QPA010FilCol(aHeaderQP7,"QP8",1,"QP8_PRODUT+QP8_REVI+QP8_CODREC+QP8_OPERAC",cProduto+cRevisao+aEspecificacao[nRot,_ROT]+aEspecificacao[nRot,_OPE,nX,nPosOper],@aEspAux,.F.)
					
					If !lIncF4
						//Cria as dimensoes para os Ensaios Mensuraveis e/ou Textos
						Aeval(aEspAux,{|x,y|If(!Empty(aEspAux[y,1]) .or. Len(aEspAux)==1,Aadd(aEspecificacao[nRot,_ENS,Len(aEspecificacao[nRot,_ENS])],aClone(aEspAux[y])),.f.)})
						aEspAux := aClone(aEspecificacao[nRot,_ENS,Len(aEspecificacao[nRot,_ENS])])
				    Else 
					    aEspecificacao[nRot,_ENS,Len(aEspecificacao[nRot,_ENS])] := aClone(aEspAux)
				    EndIF
				
					//Ordena os Ensaios por Laboratorio+Sequencia
					aSort(aEspecificacao[nRot,_ENS,nX],,,{|x,y|x[nPosLab]+x[nPosSeq]<y[nPosLab]+y[nPosSeq]})
					
					//Cria as dimensoes para as Familias de Instrumentos associadas aos ensaios
					aEspecificacao[nRot,_INS,Len(aEspecificacao[nRot,_INS])] := aClone(Array(Len(aEspAux)))
					
					//Cria as dimensoes para as Nao-conformidades associadas aos ensaios
					aEspecificacao[nRot,_NCO,Len(aEspecificacao[nRot,_NCO])] := aClone(Array(Len(aEspAux)))
					
					//Cria as dimensoes para o Plano de Amostragem associado ao Ensaio
					aEspecificacao[nRot,_PAE,Len(aEspecificacao[nRot,_PAE])] := aClone(Array(Len(aEspAux)))
					
					//Carrega as Familias de Instrumentos associados aos Ensaios  
					For y:=1 to len(aEspecificacao[nRot,_INS,nx])  
						aEspAux:={}
						QPA010FilCol(aHeaderQQ1,"QQ1",3,"QQ1_PRODUT+QQ1_REVI+QQ1_ROTEIR+QQ1_OPERAC+QQ1_ENSAIO",cProduto+cRevisao+aEspecificacao[nRot,_ROT]+aEspecificacao[nRot,_OPE,nX,nPosOper]+aEspecificacao[nRot,_ENS,nX,y,nPosEns],@aEspAux)
						aEspecificacao[nRot,_INS,nx,y]:=aClone(aEspAux)
					next y   //DEVIDO A ESPECIFICAÇÃO POR GRUPO NÃO PODE SER USADO AEVAL
					
					/*Aeval(aEspecificacao[nRot,_INS,Len(aEspecificacao[nRot,_INS,nx])],{|x,y|aEspAux:={},;
					QPA010FilCol(aHeaderQQ1,"QQ1",3,"QQ1_PRODUT+QQ1_REVI+QQ1_ROTEIR+QQ1_OPERAC+QQ1_ENSAIO",;
					cProduto+cRevisao+aEspecificacao[nRot,_ROT]+aEspecificacao[nRot,_OPE,nX,nPosOper]+aEspecificacao[nRot,_ENS,nX,y,nPosEns],;
					@aEspAux),aEspecificacao[nRot,_INS,Len(aEspecificacao[nRot,_INS]),y]:=aClone(aEspAux)}) */
				
					//Carrega as Nao-conformidades associadas aos Ensaios 
					For y:= 1 to Len(aEspecificacao[nRot,_NCO,nx])  
						aEspAux:={}
				   		QPA010FilCol(aHeaderQP9,"QP9",3,"QP9_PRODUT+QP9_REVI+QP9_ROTEIR+QP9_OPERAC+QP9_ENSAIO",cProduto+cRevisao+aEspecificacao[nRot,_ROT]+aEspecificacao[nRot,_OPE,nX,nPosOper]+aEspecificacao[nRot,_ENS,nX,y,nPosEns],@aEspAux)
				   		aEspecificacao[nRot,_NCO,nx,y]:=aClone(aEspAux)
				  	next y   ////DEVIDO A ESPECIFICAÇÃO POR GRUPO NÃO PODE SER USADO AEVAL   
				  	
					/*Aeval(aEspecificacao[nRot,_NCO,Len(aEspecificacao[nRot,_NCO,nx])],{|x,y|aEspAux:={},;
					QPA010FilCol(aHeaderQP9,"QP9",3,"QP9_PRODUT+QP9_REVI+QP9_ROTEIR+QP9_OPERAC+QP9_ENSAIO",;
					cProduto+cRevisao+aEspecificacao[nRot,_ROT]+aEspecificacao[nRot,_OPE,nX,nPosOper]+aEspecificacao[nRot,_ENS,nX,y,nPosEns],;
					@aEspAux),aEspecificacao[nRot,_NCO,Len(aEspecificacao[nRot,_NCO]),y]:=aClone(aEspAux)})*/
					
					//Carrega os Planos de Amostragens associados aos Ensaios
					For y:= 1 to Len(aEspecificacao[nRot,_PAE,nx]) 
						aEspAux:={}
						QPA010FilCol(aHeaderQQH,"QQH",1,"QQH_PRODUT+QQH_REVI+QQH_CODREC+QQH_OPERAC+QQH_ENSAIO",cProduto+cRevisao+aEspecificacao[nRot,_ROT]+aEspecificacao[nRot,_OPE,nX,nPosOper]+aEspecificacao[nRot,_ENS,nX,y,nPosEns],@aEspAux)
						aEspecificacao[nRot,_PAE,nx,y]:=aClone(aEspAux)
					Next y ////DEVIDO A ESPECIFICAÇÃO POR GRUPO NÃO PODE SER USADO AEVAL 
					
					/*Aeval(aEspecificacao[nRot,_PAE,Len(aEspecificacao[nRot,_PAE,nx])],{|x,y|aEspAux:={},;
					QPA010FilCol(aHeaderQQH,"QQH",1,"QQH_PRODUT+QQH_REVI+QQH_CODREC+QQH_OPERAC+QQH_ENSAIO",;
					cProduto+cRevisao+aEspecificacao[nRot,_ROT]+aEspecificacao[nRot,_OPE,nX,nPosOper]+aEspecificacao[nRot,_ENS,nX,y,nPosEns],;
					@aEspAux),aEspecificacao[nRot,_PAE,Len(aEspecificacao[nRot,_PAE]),y]:=aClone(aEspAux)})*/
						
				Next nX               

				aColsAux := {}   
				nReg     := 0
		    EndIF
		    
	    EndDo

		//Carrega os Roteiros Selecionados
		oGetRot:aCols := aClone(aRoteiros)
		oGetRot:oBrowse:Refresh()

		//Carrega as Operacoes com o Roteiro selecionado
		oGetOper:aCols := aClone(aEspecificacao[IIF(!lInc,1,oGetRot:oBrowse:nAt),_OPE])
		oGetOper:oBrowse:Refresh()
		
  		Aeval(aEspecificacao[IIF(!lInc,1,oGetRot:oBrowse:nAt),_OPE],{|x,y|nOperacao:=y,oGetOper:oBrowse:nAt:=y,FolderChange("1")})
	
		If !lInc
			oGetRot:oBrowse:nAt := 1
			nRoteiro := oGetRot:oBrowse:nAt
		EndIf        

		oGetOper:oBrowse:nAt := 1
		nOperacao := oGetOper:oBrowse:nAt   
		
		FolderRest("1234567",.T.)
		
	EndIf
	RestArea(aAreaSG2)

EndIf
ogetIns:obrowse:refresh()

Return(lRetorno)                               

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³QP010F3NC ³ Autor ³ Cleber Souza          ³ Data ³23/06/04  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta consulta de NCs via SXB especifica                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Consulta especifica                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³QIPA010 - Apenas Fase3                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP010F3NC()
Local lOkQP2   := .F.
Local lRetorno := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe NC associada ao ensaio - QP2 			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
QP2->(dbSetOrder(1))
If QP2->(dbSeek( xFilial("QP2")+oGetEns:aCols[nEnsaio,nPosEns]))
	lOkQP2 := .T.
	__cENSAIO := oGetEns:aCols[nEnsaio,nPosEns]
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ De acordo com os dados encontrados dispara uma consulta F3	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lOkQP2
	lRetorno := ConPad1(,,,"NCP",,,.F.)
Else
	lRetorno := ConPad1(,,,"SAG",,,.F.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso a consulta F3 tenha sido executada fora do SAG, posi-    ³
//³ ciona no SAG , pois o retorno da consulta ‚ o campo AG_NAOCON ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lOkQP2
	SAG->(dbSetOrder(1))
	SAG->(dbSeek( xFilial("SAG")+QP2->QP2_NAOCON ))
EndIf
Return(lRetorno)  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³ QPA010VDup³ Autor ³Paulo Emidio de Barros³ Data ³28/05/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Validacao do Produto+Revisao a ser criada na duplicacao    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QPA010VDup()											      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ 														      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 - Apenas Fase3									  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QPA010VDup()
Local lRetorno := .T.
Local aAreaQP6 := QP6->(GetArea())
 
If Empty(mv_par01) .Or. Empty(mv_par02)
	Help(" ",1,"QIPNDUPESP") //Nao sera possivel duplicar a Especificacao do Produto.      
	lRetorno := .F.           
Else
	QP6->(dbSetOrder(1))
	QP6->(dbSeek(xFilial("QP6")+mv_par01+Inverte(mv_par02)))
	If QP6->(!Eof())
		Help(" ",1,"QIPNDREVES") //Nao sera possivel a duplicacao do Produto+Revisao informado nos parametros.
		lRetorno := .F.
	EndIf
EndIf
                                 
RestArea(aAreaQP6)

//Atualiza Descrição do Produto
If lRetorno
	mv_par05 := QP6->QP6_DESCPO
EndIF

Return(lRetorno)    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³ QPATUROTF4³ Autor ³Cleber Souza          ³ Data ³01/11/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ F4 para inclusao do roteiro de outro produto.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QPA010VDup()											      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ 														      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 - Apenas Fase3									  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QPATUROTF4() 

Local nDel    := Len(oGetRot:aHeader)+1
Local aArea   := GetArea()   
Local nRecQP6 := QP6->(Recno())
Local cRotMem := ""

If lProduto 
	cRotMem := M->QP6_CODREC
Else	
	cRotMem := M->QQC_CODREC
EndIF
     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa a rotina de inclusao do roteiro apenas quando estiver ³
//³posicionado sobre a variavel do codigo do roteiro.            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(oGetRot:aCols[oGetRot:nAT,1]) .Or. oGetRot:aCols[oGetRot:nAT,nDel]
	Return()
EndIf	

lIncF4 := .T.

If Pergunte("Q010F4",.T.)
	If QP010VlNwR()
		QP010FilRot(mv_Par01,QA_UltRevEsp(mv_Par01,dDataBase,.F.,,"QIP"),mv_par02,.T.,.T.)   
		M->ROT_CODREC := mv_par03
		oGetRot:aCols[oGetRot:nAT,1]  := mv_par03
		oGetRot:aCols[oGetRot:nAT,2]  := IIF(mv_par03 == cRotMem,STR0039,STR0040)
	   	aEspecificacao[nRoteiro,_ROT] := mv_par03
		aRoteiros[nRoteiro,1]         := mv_par03
		aRoteiros[nRoteiro,2]         := IIF(mv_par03 == cRotMem,STR0039,STR0040)
		oGetRot:ForceRefresh(.T.)
		oGetRot:oBrowse:nAT := Len(oGetRot:aCols)
		oGetRot:oBrowse:Refresh()
	Endif
EndIf

lIncF4 := .F.  
QP6->(dbGoTo(nRecQP6))
RestArea(aArea)

Return  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QPFilQQK    ³ Autor³Cleber Labio Souza    ³ Data ³03/11/05  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Filtra o QQK com a revisao vigente						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QPFilQQK()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function QPFilQQK()  
            
Local lRet     := .T.
Local cUltRv   := QA_UltRevEsp(QQK->QQK_PRODUT,dDataBase,.F.,,"QIP")

If QQK->QQK_REVIPR#cUltRv
	lRet := .F.
EndIF	

Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QP010VlNwR  ³ Autor³Cleber Labio Souza    ³ Data ³03/11/05  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Valida o novo roteiro informado na rotina F4.			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP010VlNwR()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function QP010VlNwR() 

Local nDel  := Len(oGetRot:aHeader)+1 
Local lRet  := .T. 
Local nY    := 0
	            
If !Empty(mv_par03)
	For nY:=1 to Len(oGetRot:aCols) 
		If !oGetRot:aCols[nY,nDel]
			If  oGetRot:aCols[nY,1]== mv_par03
				MsgAlert(STR0041+ mv_par03 +STR0042) //"O Roteiro " ### " ja foi cadastrado para esse produto."
				lRet := .F.
				Exit
			EndIF       
		EndIf
	Next nY      
Else
	lRet := .F.
Endif

Return(lRet)  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³ QP10ValIns³ Autor ³Cleber Souza          ³ Data ³04/08/06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Verifica se é obrigatorio informar instrumento para o ensaio±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP10ValIns()											      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ EXPL1 - Retorno Logico indicando se o cadastro esta correto³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA010 								  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP10ValIns()
            
Local lRet       := .T.
Local lInsOb	 := GetMv("MV_QPINSOB")=="S"
Local nRot		 := 0
Local nOpe		 := 0
Local nEns       := 0
Local nIns       := 0
Local nPosDelIns := 0      
Local nPosDelEns := 0                                          
Local nPosDelOpe := 0                                          
Local lEncIns    := .F.
Local cEns       := ""

If lInsOb
	For nRot:=1 to Len(aEspecificacao)
		For nOpe:=1 to Len(aEspecificacao[nRot,_OPE])
			nPosDelOpe := Len(aEspecificacao[nRot,_OPE,nOpe]) //Indica se esta deletado	(Operacao)
			If !aEspecificacao[nRot,_OPE,nOpe,nPosDelOpe]
				For nEns:=1 to Len(aEspecificacao[nRot,_ENS,nOpe])
					lEncIns    := .F.
					nPosDelEns := Len(aEspecificacao[nRot,_ENS,nOpe,nEns]) //Indica se esta deletado (Ensaio)
					If !aEspecificacao[nRot,_ENS,nOpe,nEns,nPosDelEns]
						For nIns:=1 to Len(aEspecificacao[nRot,_INS,nOpe,nEns])
							nPosDelIns := Len(aEspecificacao[nRot,_INS,nOpe,nEns,nIns]) //Indica se esta deletado
							If !aEspecificacao[nRot,_INS,nOpe,nEns,nIns,nPosDelIns] .And.;
							   !Empty(aEspecificacao[nRot,_INS,nOpe,nEns,nIns,nPosInstr])
								lEncIns :=.T.
								Exit
							EndIf
							If QPCTIPO(aEspecificacao[nRot,_ENS,nOpe,nEns,nPosEns]) == "C"
								lEncIns :=.T.
								Exit
							Endif
						Next nIns
						If !lEncIns
							lRet := .F.
							cEns += IIF(!Empty(cEns),", ","")+Alltrim(aEspecificacao[nRot,_ENS,nOpe,nEns,nPosEns])
						EndIf
					EndIF
				Next nEns
			EndIF
		Next nOpe
	Next bRot
EndIf    
                                                     

If !lRet
	MsgAlert(STR0049+CHR(13)+CHR(10)+;	//"É obrigatorio informar familia de intrumento para os ensaios informados na especificação. "
			 STR0050 + cEns + STR0051) //"O(s) ensaio(s) "###" não possue(m) familia de intrumento informado"				
EndIF

Return(lRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³AjustaSX3 ³ Autor ³Rafael S. Bernardi     ³      ³10/10/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Corrige o campo plano de amostragem da tabela QF4-QF4_TIPAMO³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ QIEA331													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³ 										  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function AjustaSX3()

Local aArea  := GetArea()
Local nOrder := SX3->(IndexOrd())

DBSelectArea("SX3")
DBSetOrder(2)
IF DBSeek("QP7_PLAMO")
	RecLock("SX3", .F.)
	SX3->X3_CBOXENG := "N=NBR5426;I=Internal;T=Text;Z=No Defect;B=NBR5429"
	MsUnlock()
EndIF

SX3->(dbSetOrder(nOrder))
RestArea(aArea)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP10FillG ³ Autor ³Cicero Odilio Cruz            ³30/01/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Montagem generica do aHeader com fillget					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ QIP														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³ 										  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP10FillG(cAlias, nOpcx, cWhile, cSeek, aCols)
Default nOpcx   := 3
Default cWhile  := ''
Default cSeek 	:= ''
Default aCols   := {}

FillGetDados(	nOpcx,; 								// numero correspondente à operação a ser executada, exemplo: 3 - inclusão, 4 alteração e etc;
               	cAlias,;       							// area a ser utilizada;
               	1,;      								// nOrdem - ordem correspondente a chave de índice para preencher o  acols;
               	Iif((nOpcx == 3),'',&cSeek),;  		// chave utilizada no posicionamento da área para preencher o acols; 
               	{|| &cWhile},; 	// bloco contendo a expressão a ser comparada com cSeekKey na condição  do While. 
               	{|| .T.},;  							// uSeekFor
               	,;  						 			// aNoFields - array contendo os campos que não estarao no aHeader;
               	,;  									// aYesFields - array contendo somente os campos que estarao no aHeader;
               	.F.,;      								// se verdadeiro, exibe apenas os campos de usuário;
                '',;      								// cQuery - query a ser executada para preencher o acols;
               	,;    				   					// bloco contendo funcao especifica para preencher o aCols; 
               	Iif((nOpcx == 3),.T.,.F.),;  			// lEmpty 
               	,; 										// aHeaderAux
               	,; 		   								// aColsAux
               	,; 										// bAfterCols
               	,; 										// bBeforeCols
               	,; 										// bAfterHeader
               	'') 									// cAliasQry

Return aHeader

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QIPA010   ºAutor  ³Renata Cavalcante   º Data ³  09/20/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Ajusta da Consulta Padrão QP1, inclusão                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ajuste da Consulta Padrão QP1, inclusão                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

Static Function AjustaSXB()
Local aArea := GetArea()
Local nI    := 0   
Local aPesq := {}

dbSelectArea("SXB")
dbSetOrder(1)

If SXB->(DbSeek("QP1   " + "3"))
	IF SXB->XB_CONTEM <> "#Q020INCENS()"
		RecLock("SXB",.F.)
		SXB->XB_CONTEM	:= "#Q020INCENS()" 
		MsUnlock()
	Endif
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Consulta Operacoes                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aPesq,{"QQK", "7", "03", " " , " "                   ," "                   ," "                ,"QQK->(dbGoTop())"  })

If !dbSeek(PadR("QQK",6)+"7")
	For nI := 1 To Len(aPesq)
		RecLock("SXB",.T.)
		SXB->XB_ALIAS	:= aPesq[nI,1]
		SXB->XB_TIPO	:= aPesq[nI,2]
		SXB->XB_SEQ 	:= aPesq[nI,3]
		SXB->XB_COLUNA	:= aPesq[nI,4]
		SXB->XB_DESCRI	:= aPesq[nI,5]
		SXB->XB_DESCSPA	:= aPesq[nI,6]
		SXB->XB_DESCENG	:= aPesq[nI,7]
		SXB->XB_CONTEM	:= aPesq[nI,8]
		MsUnlock()
	Next
EndIf

RestArea(aArea)  

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QIP010TEXTO³ Autor ³ Sergio S. Fuzinaka    ³ Data ³ 02.10.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Validacao do campo Texto (Ensaio Tipo Texto)                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³QIP010TEXTO()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³QIPA010                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function QIP010TEXTO(aColsEns)

Local aArea		:= GetArea()
Local aAreaQP1	:= QP1->(GetArea())
Local lRet 		:= .F.

If QP1->(dbSeek(xFilial("QP1")+aColsEns[nPosEns]))
	If QP1->QP1_TPCART == "X" .And. Empty(aColsEns[nPosTxt])
		lRet := .T.
	Endif
Endif	

RestArea(aAreaQP1)
RestArea(aArea)

Return( lRet )      


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³QIP010TEXTO³ Autor ³ Sandra Ribeiro Cladio ³ Data ³ 07.01.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Validacao dos das fórmulas dos ensaios calculados            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³QP010ValCalc()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³QIPA010                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Function QP010ValCalc(lRetorno, cForAux, lTipo, cTpCarta, nPosEns, cCarta, nQtdEns, lMsg)

Local cFormula	:= " " 
Local cEnsAux	:= " "
Local aEnsCal   := {}
Local nCont1	:= 0
Local nCont2	:= 0
Local nCont3	:= 0
Local nCont4    := 0
Local nPar1		:= 0
Local nPar2		:= 0
Local nPosForm	:= 0 
Local nY		:= 0
Local nW		:= 0
Local nTamForm	:= TamSx3("QP7_FORMUL")[1]		// Tamanho do campo formula

Default lRetorno := .T.
Default lTipo	 := .T.
Default cForAux  := " " 
Default cTpcarta := " " 
Default nPosEns	 := 0   
Default lMsg     := .T.

If lTipo
	If nTamForm >= Len(cForAux)

		cFormula := cForAux
	    
	    For nY := 1 to Len(cForAux)
	    	nPosForm := At("#",cForAux)
	    	If nPosForm == 0
	    		Exit
	    	EndIF	            
	    	
	    	QP1->(dbSetOrder(1))
			QP1->(dbSeek(xFilial("QP1")+SubStr(cForAux,nPosForm+1,8)))
			
			//Verificação de o numero de cerquilhas está correto
			cEnsAux := SubStr(cForAux,nPosForm,10)
			If Len(cEnsAux) > 0
				nCont1 := At("#",cEnsAux)
				cEnsAux := Stuff(cEnsAux,nCont1,1,"")
				nCont2 := RAt("#",cEnsAux)
				If (nCont1 == 0 .OR. nCont2 == 0 .OR. nCont1 == nCont2)
					If lMsg 
						Alert(STR0055)  //"A fórmula cadastrada está incorreta."
					EndIf
					Return .F.
				Endif
			EndIf
			 
			If Len(cEnsAux) > 0
	    		//Verificação se o numero de parenteses abertos e igual ao numero de parenteses fechados
	    		nCont3 := At("(",cFormula)
	    		If nCont3 > 0
	    			nPar1++
	    			cFormula := Stuff(cFormula,nCont3,1,"")
	    		EndIf
	    		
	    		nCont4 := At(")",cFormula)
	    		If nCont4 > 0
	    			nPar2++
	    			cFormula := Stuff(cFormula,nCont4,1,"")
	    		EndIf 
	    		
	    		If nPar1 <> nPar2
	    			If lMsg
	    				Alert(STR0055)   //"A fórmula cadastrada está incorreta."
	    			EndIf
	    			Return .F.
	    		EndIf		    		
	    	EndIf        
	    	
	    	Aadd(aEnsCal,{SubStr(cForAux,nPosForm+1,8),QP1->QP1_CARTA,QP1->QP1_QTDE})
	    	cForAux := Stuff(cForAux,1,nPosForm+10,Space(nPosForm+10))
	    	nY      := (nPosForm+10)
	    	nCont1 := nCont2 := nCont3 := nCont4
	    Next nY
	
		For nY := 1 to Len(aEnsCal)
			lRetorno := .F.
	   		For nW := 1 to Len(oGetEns:aCols)
	       	   	If oGetEns:aCols[nW,nPosEns] == aEnsCal[nY,1] .And. !oGetEns:aCols[nW,Len(oGetEns:aCols[nW])]
	       			If cCarta <> aEnsCal[nY,2] .or. nQtdEns <> aEnsCal[nY,3]
						HELP(" ",1,"Q010ERRENS",,STR0016+CHR(13)+CHR(10)+STR0017+oGetEns:aCols[nW,nPosEns],1,30)  //"Tipo de Carta e/ou numero de " #### "medicoes incorretos no ensaio calculado "
						lRetorno := .F.
						Exit
					Else
	       	 			lRetorno := .T.
	        	   		Exit
					EndIf		
	    		EndIf		
	    	Next nW
	   	Next nY 
	    		
		If !lRetorno
			Help(" ",1,"QA_CPOOBR")
		EndIf
		           
		//Verifica ensaios calculados do tipo tempo.
		If lRetorno .AND. cTpCarta=="T"
		   If "ABS" $ Alltrim(UPPER(cForAux)) .OR. "SQRT" $ Alltrim(UPPER(cForAux)) .OR. "AVG" $ Alltrim(UPPER(cForAux))
				MsgAlert(STR0045) //"Nao utilizar Média e Desvio Padrao nas formulas para ensaios calculados do tipo tempo."
				lRetorno := .F.
		   EndIF
		EndIf
	Else
		MsgAlert(STR0056 + cValToChar(nTamForm) + STR0057) // O tamanho da formula e superior a XXX caracteres.
		lRetorno := .F.
	EndIf
EndIf   

Return lRetorno   

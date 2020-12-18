#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"

#DEFINE IMP_SPOOL 2

#DEFINE VBOX      080
#DEFINE VSPACE    008
#DEFINE HSPACE    010
#DEFINE SAYVSPACE 008
#DEFINE SAYHSPACE 008
#DEFINE HMARGEM   030
#DEFINE VMARGEM   030
#DEFINE MAXITEM   010                                                // M�ximo de produtos para a primeira p�gina
#DEFINE MAXITEMP2 044                                                // M�ximo de produtos para a pagina 2 (caso nao utilize a op��o de impressao em verso)
#DEFINE MAXITEMP3 015                                                // M�ximo de produtos para a pagina 2 (caso utilize a op��o de impressao em verso) - Tratamento implementado para atender a legislacao que determina que a segunda pagina de ocupar 50%.
#DEFINE MAXITEMP4 022                                                // M�ximo de produtos para a pagina 2 (caso contenha main info cpl que suporta a primeira pagina)
#DEFINE MAXITEMC  012                                                // M�xima de caracteres por linha de produtos/servi�os
#DEFINE MAXMENLIN 130                                                // M�ximo de caracteres por linha de dados adicionais
#DEFINE MAXMSG    006                                                // M�ximo de dados adicionais na primeira p�gina
#DEFINE MAXMSG2   019                                                // M�ximo de dados adicionais na segunda p�gina
#DEFINE MAXBOXH   800                                                // Tamanho maximo do box Horizontal
#DEFINE MAXBOXV   600
#DEFINE INIBOXH   -10
#DEFINE MAXMENL   080                                                // M�ximo de caracteres por linha de dados adicionais
#DEFINE MAXVALORC 009                                                // M�ximo de caracteres por linha de valores num�ricos

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �PrtNfeSef � Autor � Eduardo Riera         � Data �16.11.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rdmake de exemplo para impress�o da DANFE no formato Retrato���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function DANFE_P1(	cIdEnt	, cVal1		, cVal2, oDanfe,;
						oSetup	, lIsLoja	)

Local aArea     := GetArea() 
Local lExistNfe := .F.
Local lRet		:= .T.

Default lIsLoja	:= .F.	// indica se foi chamado de alguma rotina do SIGALOJA

Private nConsNeg := 0.4 // Constante para concertar o c�lculo retornado pelo GetTextWidth para fontes em negrito.
Private nConsTex := 0.38 // Constante para concertar o c�lculo retornado pelo GetTextWidth.

oDanfe:SetResolution(78) // Tamanho estipulado para a Danfe
oDanfe:SetLandscape()
oDanfe:SetPaperSize(DMPAPER_A4)
oDanfe:SetMargin(60,60,60,60)
oDanfe:lServer := oSetup:GetProperty(PD_DESTINATION)==AMB_SERVER
// ----------------------------------------------
// Define saida de impress�o
// ---------------------------------------------
If oSetup:GetProperty(PD_PRINTTYPE) == IMP_SPOOL
	oDanfe:nDevice := IMP_SPOOL
	// ----------------------------------------------
	// Salva impressora selecionada
	// ----------------------------------------------
	fwWriteProfString(GetPrinterSession(),"DEFAULT", oSetup:aOptions[PD_VALUETYPE], .T.)
	oDanfe:cPrinter := oSetup:aOptions[PD_VALUETYPE]
ElseIf oSetup:GetProperty(PD_PRINTTYPE) == IMP_PDF
	oDanfe:nDevice := IMP_PDF
	// ----------------------------------------------
	// Define para salvar o PDF
	// ----------------------------------------------
	oDanfe:cPathPDF := oSetup:aOptions[PD_VALUETYPE]
Endif

Private PixelX := odanfe:nLogPixelX()
Private PixelY := odanfe:nLogPixelY()

RPTStatus( {|lEnd| DANFEProc(@oDanfe, @lEnd, cIDEnt, Nil, Nil, @lExistNFe, lIsLoja)}, "Imprimindo DANFE..." )	

If lExistNFe
	oDanfe:Preview()	//Visualiza antes de imprimir
Else
	If !lIsLoja
		Aviso("DANFE","Nenhuma NF-e a ser impressa nos parametros utilizados.",{"OK"},3)
	EndIf
EndIf

//Se SIGALOJA, o objeto oDANFE � destruido onde foi instanciado
If lIsLoja
	lRet := lExistNFe
Else
	FreeObj(oDANFE)
	oDANFE := Nil
EndIf

RestArea(aArea)

Return lRet

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �DANFEProc � Autor � Eduardo Riera         � Data �16.11.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rdmake de exemplo para impress�o da DANFE no formato Retrato���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto grafico de impressao                    (OPC) ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function DanfeProc(	oDanfe	, lEnd		, cIdEnt	, cVal1,;
							cVal2	, lExistNfe	, lIsLoja	)

Local aArea      := GetArea()
Local aAreaSF3   := {}
Local aNotas     := {}
Local aXML       := {}
Local aAutoriza  := {}
Local cNaoAut    := ""

Local cAliasSF3  := "SF3"
Local cWhere     := ""
Local cAviso     := ""
Local cErro      := ""
Local cCodRetSF3 := ""
Local cMsgSF3    := ""
Local cCodRetNFE := ""
Local cAutoriza  := ""
Local cModalidade:= ""
Local cChaveSFT  := ""
Local cAliasSFT  := "SFT"
Local cCondicao	 := ""
Local cIndex	 := ""
Local cChave	 := ""
Local cCampos := ""
Local lFirst  := .T.

Local lSdoc  := TamSx3("F3_SERIE")[1] == 14
Local cFrom 	:= ""
Local cSerie := ""

Local lQuery     := .F.

Local nX         := 0
Local nI		 := 0

Local oNfe
Local nLenNotas
Local lImpDir	:=GetNewPar("MV_IMPDIR",.F.)
Local nLenarray	 := 0
Local nCursor	 := 0
Local lBreak	 := .F.
Local aGrvSF3    := {}
Local lDanfeSimpl
Local lUsaColab	:=  UsaColaboracao("1") 
Local lMVGfe	:= GetNewPar( "MV_INTGFE", .F. ) // Se tem integra��o com o GFE
Local lContinua := .T.

Default lIsLoja	:= .F.

If lIsLoja
	//Se SIGALOJA, define as perguntas que sao feitas no Pergunte NFSIGW
	MV_PAR01 := SF2->F2_DOC 
	MV_PAR02 := SF2->F2_DOC
	MV_PAR03 := SF2->F2_SERIE
	MV_PAR04 := 1	//NF de Saida
	MV_PAR05 := 1	//Frente e Verso - 1:Sim
	MV_PAR06 := 2	//DANFE simplificado - 2:Nao
Else
	lContinua := Pergunte("NFSIGW",.T.)  .AND. ( (!Empty(MV_PAR06) .AND. MV_PAR06 == 2) .OR. Empty(MV_PAR06) )
EndIf

If lContinua

	MV_PAR01 := AllTrim(MV_PAR01)
	If !lImpDir
		dbSelectArea("SF3")
		dbSetOrder(5)
		#IFDEF TOP

			If MV_PAR04==1

			 	If lSdoc                                         
					cCampos += ", SF3.F3_SDOC" 
					cSerie := Padr(MV_PAR03,TamSx3("F3_SDOC")[1])
					cWhere := "%SubString(SF3.F3_CFO,1,1) < '5' AND SF3.F3_FORMUL='S' AND SF3.F3_SDOC = '"+ cSerie + "' AND SF3.F3_ESPECIE = 'SPED'" 			
				Else
					cSerie := Padr(MV_PAR03,TamSx3("F3_SERIE")[1])
					cWhere := "%SubString(SF3.F3_CFO,1,1) < '5' AND SF3.F3_FORMUL='S' AND SF3.F3_SERIE = '"+ cSerie + "' AND SF3.F3_ESPECIE = 'SPED'" 
				Endif

			ElseIf MV_PAR04==2
	
			 	If lSdoc                                         
					cCampos += ", SF3.F3_SDOC" 
					cSerie := Padr(MV_PAR03,TamSx3("F3_SDOC")[1])
					cWhere := "%SubString(SF3.F3_CFO,1,1) >= '5' AND SF3.F3_SDOC = '"+ cSerie + "' AND SF3.F3_ESPECIE = 'SPED'"		
				Else
					cSerie := Padr(MV_PAR03,TamSx3("F3_SERIE")[1])
					cWhere := "%SubString(SF3.F3_CFO,1,1) >= '5' AND SF3.F3_SERIE = '"+ cSerie + "' AND SF3.F3_ESPECIE = 'SPED'" 
				Endif	
			Else
			
				If lSdoc                                         
					cCampos += ", SF3.F3_SDOC" 
					cSerie := Padr(MV_PAR03,TamSx3("F3_SDOC")[1])
					cWhere := "%SF3.F3_SDOC = '"+ cSerie + "' AND SF3.F3_ESPECIE = 'SPED'" 		
				Else
					cSerie := Padr(MV_PAR03,TamSx3("F3_SERIE")[1])
					cWhere := "%SF3.F3_SERIE = '"+ cSerie + "' AND SF3.F3_ESPECIE = 'SPED'" 
				Endif	
			
			EndIf
          	If lSdoc 
				If !Empty(MV_PAR07) .Or. !Empty(MV_PAR08)
					cWhere += " AND (SF3.F3_EMISSAO >= '"+ SubStr(DTOS(MV_PAR07),1,4) + SubStr(DTOS(MV_PAR07),5,2) + SubStr(DTOS(MV_PAR07),7,2) + "' AND SF3.F3_EMISSAO <= '"+ SubStr(DTOS(MV_PAR08),1,4) + SubStr(DTOS(MV_PAR08),5,2) + SubStr(DTOS(MV_PAR08),7,2) + "')"
				EndIF
			EndIF
			
			cWhere += "%"
			
			cAliasSF3 := GetNextAlias()
			lQuery    := .T.

			//�����������������������������������������������������������������Ŀ
			//�Campos que serao adicionados a query somente se existirem na base�
			//�������������������������������������������������������������������
			If Empty(cCampos)
				cCampos := "%%"
			Else       
				cCampos := "% " + cCampos + " %"
			Endif 

			BeginSql Alias cAliasSF3
				
				COLUMN F3_ENTRADA AS DATE
				COLUMN F3_DTCANC AS DATE
				
				SELECT	F3_FILIAL,F3_ENTRADA,F3_NFELETR,F3_CFO,F3_FORMUL,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_LOJA,F3_ESPECIE,F3_DTCANC
				%Exp:cCampos%
				FROM %Table:SF3% SF3
				WHERE
				SF3.F3_FILIAL = %xFilial:SF3% AND
					SF3.F3_SERIE = %Exp:MV_PAR03% AND
				SF3.F3_NFISCAL >= %Exp:MV_PAR01% AND
				SF3.F3_NFISCAL <= %Exp:MV_PAR02% AND
				%Exp:cWhere% AND
				SF3.F3_DTCANC = %Exp:Space(8)% AND
				SF3.%notdel%
				ORDER BY F3_NFISCAL
			EndSql
			
		#ELSE
			cIndex    		:= CriaTrab(NIL, .F.)
			cChave			:= IndexKey(6)
			cCondicao 		:= 'F3_FILIAL == "' + xFilial("SF3") + '" .And. '
			cCondicao 		+= 'SF3->F3_SERIE =="'+ MV_PAR03+'" .And. '
			cCondicao 		+= 'SF3->F3_NFISCAL >="'+ MV_PAR01+'" .And. '
			cCondicao		+= 'SF3->F3_NFISCAL <="'+ MV_PAR02+'" .And. '
			cCondicao		+= 'SF3->F3_ESPECIE = "SPED" .And. '
			cCondicao		+= 'Empty(SF3->F3_DTCANC)'
			IndRegua(cAliasSF3, cIndex, cChave, , cCondicao)
			nIndex := RetIndex(cAliasSF3)
		            DBSetIndex(cIndex + OrdBagExt())
		            DBSetOrder(nIndex + 1)
			DBGoTop()
		#ENDIF
		If MV_PAR04==1
			cWhere := "SubStr(F3_CFO,1,1) < '5' .AND. F3_FORMUL=='S'"
		Elseif MV_PAR04==2
			cWhere := "SubStr(F3_CFO,1,1) >= '5'"
		Else
			cWhere := ".T."
		EndIf
		
		If lSdoc
			cSerId := (cAliasSF3)->F3_SDOC
		Else
			cSerId := (cAliasSF3)->F3_SERIE
		EndIf
		
		While !Eof() .And. xFilial("SF3") == (cAliasSF3)->F3_FILIAL .And.;
			cSerId == MV_PAR03 .And.;
			(cAliasSF3)->F3_NFISCAL >= MV_PAR01 .And.;
			(cAliasSF3)->F3_NFISCAL <= MV_PAR02
			
			dbSelectArea(cAliasSF3)
			If  Empty((cAliasSF3)->F3_DTCANC) .And. &cWhere //.And. AModNot((cAliasSF3)->F3_ESPECIE)=="55"
				
				If (SubStr((cAliasSF3)->F3_CFO,1,1)>="5" .Or. (cAliasSF3)->F3_FORMUL=="S") .And. aScan(aNotas,{|x| x[4]+x[5]+x[6]+x[7]==(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA})==0
					
					aadd(aNotas,{})
					aadd(Atail(aNotas),.F.)
					aadd(Atail(aNotas),IIF((cAliasSF3)->F3_CFO<"5","E","S"))
					aadd(Atail(aNotas),(cAliasSF3)->F3_ENTRADA)
					aadd(Atail(aNotas),(cAliasSF3)->F3_SERIE)
					aadd(Atail(aNotas),(cAliasSF3)->F3_NFISCAL)
					aadd(Atail(aNotas),(cAliasSF3)->F3_CLIEFOR)
					aadd(Atail(aNotas),(cAliasSF3)->F3_LOJA)
					
				EndIf
			EndIf
			
			dbSelectArea(cAliasSF3)
			dbSkip()

			If lSdoc
				cSerId := (cAliasSF3)->F3_SDOC
			Else
				cSerId := (cAliasSF3)->F3_SERIE
			EndIf

			If lEnd
				Exit
			EndIf
			If Len(aNotas) >= 50 .Or. 	(cAliasSF3)->(Eof())
				aAreaSF3 := (cAliasSF3)->(GetArea())
				if lUsaColab
					//Tratamento do TOTVS Colabora��o
					aXml := GetXMLColab(aNotas,@cModalidade,lUsaColab)
				else
					aXml := GetXML(cIdEnt,aNotas,@cModalidade)
				endif	

				nLenNotas := Len(aNotas)
				For nX := 1 To nLenNotas
					If !Empty(aXML[nX][2])
						If !Empty(aXml[nX])
							cAutoriza		:= aXML[nX][1]
							cCodAutDPEC	:= aXML[nX][5]
							cCodRetNFE		:= aXML[nX][9]
							cCodRetSF3		:= iif ( Empty (cCodAutDPEC),cCodRetNFE,cCodAutDPEC )
							cMsgSF3		:= iif ( aXML[nX][10]<> Nil ,aXML[nX][10],"")
						Else
							cAutoriza		:= ""
							cCodAutDPEC	:= ""
							cCodRetNFE		:= ""
							cCodRetSF3		:= ""
							cMsgSF3		:= ""
							
						EndIf
						If (!Empty(cAutoriza) .Or. !Empty(cCodAutDPEC) .Or. Alltrim(aXML[nX][8])$"2,5") .And. !cCodRetNFE $ RetCodDene()
							If aNotas[nX][02]=="E"
								DBClearFilter()
								dbSelectArea("SF1")
								dbSetOrder(1)
								If MsSeek(xFilial("SF1")+aNotas[nX][05]+aNotas[nX][04]+aNotas[nX][06]+aNotas[nX][07]) .And. SF1->(FieldPos("F1_FIMP")) <> 0 .And. Alltrim(aXML[nX][8])$"1,3,4,6,7" .or. ( Alltrim(aXML[nX][8]) $ "2,5"  .And. !Empty(cAutoriza) )
									RecLock("SF1")
									If !SF1->F1_FIMP$"D"
										SF1->F1_FIMP := "S"
									EndIf
									If SF1->(FieldPos("F1_CHVNFE"))>0
										SF1->F1_CHVNFE := SubStr(NfeIdSPED(aXML[nX][2],"Id"),4)
									EndIf
									If SF1->(FieldPos("F1_HAUTNFE")) > 0 .and. SF1->(FieldPos("F1_DAUTNFE")) > 0 //grava a data e hora de autoriza��o da NFe
										SF1->F1_HAUTNFE := IIF(!Empty(aXML[nX][6]),SUBSTR(aXML[nX][6],1,5),"")
				   						SF1->F1_DAUTNFE	:= IIF(!Empty(aXML[nX][7]),aXML[nX][7],SToD("  /  /    "))
									EndIf
									MsUnlock()
								EndIf
							Else
								dbSelectArea("SF2")
								dbSetOrder(1)
								If MsSeek(xFilial("SF2")+aNotas[nX][05]+aNotas[nX][04]+aNotas[nX][06]+aNotas[nX][07]) .And. Alltrim(aXML[nX][8])$"1,3,4,6,7".Or. ( Alltrim(aXML[nX][8]) $ "2,5"  .And. !Empty(cAutoriza) )
									RecLock("SF2")
									If !SF2->F2_FIMP$"D"
										SF2->F2_FIMP := "S"
									EndIf
									If SF2->(FieldPos("F2_CHVNFE"))>0
										SF2->F2_CHVNFE := SubStr(NfeIdSPED(aXML[nX][2],"Id"),4)
									EndIf
									If SF2->(FieldPos("F2_HAUTNFE")) > 0 .and. SF2->(FieldPos("F2_DAUTNFE")) > 0 //grava a data e hota de autoriza��o da NFe
										SF2->F2_HAUTNFE := IIF(!Empty(aXML[nX][6]),SUBSTR(aXML[nX][6],1,5),"")
				   						SF2->F2_DAUTNFE	:= IIF(!Empty(aXML[nX][7]),aXML[nX][7],SToD("  /  /    "))
									EndIf
									MsUnlock()
								// Grava quando a nota for Transferencia entre filiais 
								IF SF2->(FieldPos("F2_FILDEST"))> 0 .And. SF2->(FieldPos("F2_FORDES"))> 0 .And.SF2->(FieldPos("F2_LOJADES"))> 0 .And.SF2->(FieldPos("F2_FORMDES"))> 0 .And. !EMPTY (SF2->F2_FORDES)  
							       SF1->(dbSetOrder(1))
							    	If SF1->(MsSeek(SF2->F2_FILDEST+SF2->F2_DOC+SF2->f2_SERIE+SF2->F2_FORDES+SF2->F2_LOJADES+SF2->F2_FORMDES))
							    		If EMPTY(SF1->F1_CHVNFE)	
								    		RecLock("SF1",.F.)
									    		SF1->F1_CHVNFE := SubStr(NfeIdSPED(aXML[nX][2],"Id"),4)
								    		MsUnlock()
								    	EndIf	
							    	Endif					    
							    EndiF
								ElseIF MsSeek(xFilial("SF2")+aNotas[nX][05]+aNotas[nX][04]+aNotas[nX][06]+aNotas[nX][07]) .And. Alltrim(aXML[nX][8])$"1,3,4,6".Or. ( Alltrim(aXML[nX][8]) $ "2,5"  .And. cModalidade == "7"  ) //Contingencia FSDA
									RecLock("SF2")
									SF2->F2_CHVNFE := SubStr(NfeIdSPED(aXML[nX][2],"Id"),4)
									MsUnlock()
								EndIf
								
								// Atualiza��o dos campos da Tabela GFE
								if FindFunction("GFECHVNFE") .and. lMVGfe  // Integra��o com o GFE 
										
									dbSelectArea("SA1")
									dbSetOrder(1)
									If SA1->(MsSeek(xFilial("SA1")+ SF2->F2_CLIENTE + SF2->F2_LOJA,.T.))
										
										GFECHVNFE(xFilial("SF2"),SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_TIPO,SA1->A1_CGC,SA1->A1_COD,SA1->A1_LOJA,SF2->F2_CHVNFE,SF2->F2_FIMP)
										
									endif
								endif 

								If ExistFunc("STFMMd5NS") //Fun��o do Controle de Lojas - Legisla��o PAF-ECF
									STFMMd5NS()
								EndIf
							EndIf
							dbSelectArea("SFT")
							dbSetOrder(1)
							If SFT->(FieldPos("FT_CHVNFE"))>0
								cChaveSFT	:=	(xFilial("SFT")+aNotas[nX][02]+aNotas[nX][04]+aNotas[nX][05]+aNotas[nX][06]+aNotas[nX][07])
								If MsSeek(cChaveSFT)
									Do While !(cAliasSFT)->(Eof ()) .And.;
										cChaveSFT==(cAliasSFT)->FT_FILIAL+(cAliasSFT)->FT_TIPOMOV+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA 
										If (cAliasSFT)->FT_TIPOMOV $"S" .Or. ((cAliasSFT)->FT_TIPOMOV $"E" .And. (cAliasSFT)->FT_FORMUL=='S')
											RecLock("SFT")
											SFT->FT_CHVNFE := SubStr(NfeIdSPED(aXML[nX][2],"Id"),4)
											MsUnLock()
											//Array criado para gravar o SF3 no final, pois a tabela SF3 pode estah em processamento quando se trata de DBF ou AS/400.
											If aScan(aGrvSF3,{|aX|aX[1]+aX[2]+aX[3]+aX[4]+aX[5]==(cAliasSFT)->(FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_IDENTF3)})==0
												aAdd(aGrvSF3, {(cAliasSFT)->FT_SERIE,(cAliasSFT)->FT_NFISCAL,(cAliasSFT)->FT_CLIEFOR,(cAliasSFT)->FT_LOJA,(cAliasSFT)->FT_IDENTF3,(cAliasSFT)->FT_CHVNFE,cAutoriza,cCodRetSF3,cMsgSF3})
											EndIf										
										EndiF
										DbSkip()
									EndDo
								EndIf
							EndIf 
							// Grava quando a nota for Transferencia entre filiais  
							IF SF1->(!EOF()) .And. SF2->(FieldPos("F2_FILDEST"))> 0 .And. SF2->(FieldPos("F2_FORDES"))> 0 .And.SF2->(FieldPos("F2_LOJADES"))> 0 .And.SF2->(FieldPos("F2_FORMDES"))> 0 .And. !EMPTY (SF2->F2_FORDES)  
							  	SFT->(dbSetOrder(1))
								cChaveSFT := SF1->F1_FILIAL+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA
								If SFT->(MsSeek(cChaveSFT))
									Do While cChaveSFT == SFT->FT_FILIAL+"E"+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA .And. !SFT->(Eof())
										RecLock("SFT")
										SFT->FT_CHVNFE := SubStr(NfeIdSPED(aXML[nX][2],"Id"),4)
										MsUnLock()
										//Array criado para gravar o SF3 no final, pois a tabela SF3 pode estah em processamento quando se trata de DBF ou AS/400.
										If aScan(aGrvSF3,{|aX|aX[1]+aX[2]+aX[3]+aX[4]+aX[5]==(cAliasSFT)->(FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_IDENTF3)})==0
											aAdd(aGrvSF3, {(cAliasSFT)->FT_SERIE,(cAliasSFT)->FT_NFISCAL,(cAliasSFT)->FT_CLIEFOR,(cAliasSFT)->FT_LOJA,(cAliasSFT)->FT_IDENTF3,(cAliasSFT)->FT_CHVNFE,cAutoriza,cCodRetSF3,cMsgSF3})
										EndIf
										SFT->(dbSkip())
							    	EndDo
								EndIf
							EndIf
							
							cAviso := ""
							cErro  := ""
							oNfe := XmlParser(aXML[nX][2],"_",@cAviso,@cErro)
							oNfeDPEC := XmlParser(aXML[nX][4],"_",@cAviso,@cErro)
							If Empty(cAviso) .And. Empty(cErro)
								ImpDet(@oDanfe,oNFe,cAutoriza,cModalidade,oNfeDPEC,cCodAutDPEC,aXml[nX][6],aXml[nX][7],aNotas[nX])
								lExistNfe := .T.
							EndIf
							oNfe     := nil
							oNfeDPEC := nil

						ElseIf lIsLoja							
							/*	Se o Codigo de Retorno da SEFAZ estiver preenchido e for maior que 200,
								entao houve rejeicao por parte da SEFAZ	*/
							If !Empty(aXML[nX][9]) .AND. Val(aXML[nX][9]) > 200 
								RecLock("SF2",.F.)
								Replace SF2->F2_FIMP with "N"
								SF2->( MsUnlock() )

								cNaoAut := "A impress�o do DANFE referente a Nota/S�rie " + SF2->F2_DOC + "/" + SF2->F2_SERIE + " n�o ser� realizada pelo motivo abaixo:"
								cNaoAut += CRLF + "[" + aXML[nX][9] + ' - ' + aXML[nX][10] + "]"
								cNaoAut += CRLF + "Se poss�vel, fa�a o ajuste e retransmita a NF-e."
										
								Aviso( "SPED", cNaoAut, {"Continuar"}, 3 )
							EndIf	

						Else
							cNaoAut += aNotas[nX][04]+aNotas[nX][05]+CRLF
						EndIf
					EndIf
					
				Next nX
				aNotas := {}
				
				RestArea(aAreaSF3)
				DelClassIntF()
			EndIf
		EndDo
		
		If !lQuery
			DBClearFilter()
			Ferase(cIndex+OrdBagExt())
		EndIf
		
		If !lIsLoja .AND. !Empty(cNaoAut)
			Aviso("SPED","As seguintes notas n�o foram autorizadas: "+CRLF+CRLF+cNaoAut,{"Ok"},3)
		EndIf

	ElseIf  lImpDir
		//�����������������������������������������������������������Ŀ
		//�Tratamento para quando o parametro MV_IMPDIR esteja        �
		//�Habilitado, neste caso n�o ser� feita a impress�o conforme �
		//�Registros no SF3, e sim buscando XML diretamente do        �
		//�webService, e caso exista ser� impresso.                   �
		//�������������������������������������������������������������
		nLenarray := Val(MV_PAR02) - Val(Alltrim(MV_PAR01))
		nCursor   := Val(MV_PAR01)

		While  !lBreak  .And. nLenarray >= 0

			If lFirst			
				If MV_PAR04==1
				
					cxFilial := xFilial("SF1")
					cFrom	:=	"%"+RetSqlName("SF1")+" SF1 %"
	
				 	If lSdoc 
				 		cCampos += "%SF1.F1_FILIAL FILIAL, SF1.F1_DOC DOC, SF1.F1_SERIE SERIE, SF1.F1_SDOC SDOC%"                                         
						cSerie := Padr(MV_PAR03,TamSx3("F1_SDOC")[1])
						cWhere := "%SF1.D_E_L_E_T_= '' AND SF1.F1_FILIAL ='"+xFilial("SF1")+"' AND SF1.F1_DOC <='"+MV_PAR02+ "' AND SF1.F1_DOC >='" + MV_PAR01 + "' AND SF1.F1_SDOC ='"+ cSerie + "' AND SF1.F1_ESPECIE = 'SPED' ORDER BY SF1.F1_DOC%"			
					Else
						cCampos += "%SF1.F1_FILIAL FILIAL, SF1.F1_DOC DOC, SF1.F1_SERIE SERIE%"
						cSerie := Padr(MV_PAR03,TamSx3("F2_SERIE")[1])
						cWhere := "%SF1.D_E_L_E_T_= '' AND SF1.F1_FILIAL ='"+xFilial("SF1")+"' AND SF1.F1_DOC <='"+MV_PAR02+ "' AND SF1.F1_DOC >='" + MV_PAR01 + "' AND SF1.F1_SERIE ='"+ cSerie + "' AND SF1.F1_ESPECIE = 'SPED' ORDER BY SF1.F1_DOC%"
					Endif
	
				ElseIf MV_PAR04==2
					
					cxFilial := xFilial("SF2")	
					cFrom	:=	"%"+RetSqlName("SF2")+" SF2 %"
	
				 	If lSdoc  
				 		cCampos += "%SF2.F2_FILIAL FILIAL, SF2.F2_DOC DOC, SF2.F2_SERIE SERIE, SF2.F2_SDOC SDOC%"                                        
						cSerie := Padr(MV_PAR03,TamSx3("F2_SDOC")[1])
						cWhere := "%SF2.D_E_L_E_T_= '' AND SF2.F2_FILIAL ='"+xFilial("SF2")+"' AND SF2.F2_DOC <='"+MV_PAR02+ "' AND SF2.F2_DOC >='" + MV_PAR01 + "' AND SF2.F2_SDOC ='"+ cSerie + "' AND SF2.F2_ESPECIE = 'SPED' ORDER BY SF2.F2_DOC%"			
					Else
						cCampos += "%SF2.F2_FILIAL FILIAL, SF2.F2_DOC DOC, SF2.F2_SERIE SERIE%" 
						cSerie := Padr(MV_PAR03,TamSx3("F2_SERIE")[1])
						cWhere := "%SF2.D_E_L_E_T_= '' AND SF2.F2_FILIAL ='"+xFilial("SF2")+"' AND SF2.F2_DOC <='"+MV_PAR02+ "' AND SF2.F2_DOC >='" + MV_PAR01 + "' AND SF2.F2_SERIE ='"+ cSerie + "' AND SF2.F2_ESPECIE = 'SPED' ORDER BY SF2.F2_DOC%"			
					Endif
				
				EndIf
			EndIf	
			cAliasSFX := GetNextAlias()
			lQuery    := .T.
			lFirst    := .F.

			BeginSql Alias cAliasSFX			
				SELECT	
				%Exp:cCampos%
				FROM 
				%Exp:cFrom%
				WHERE
				%Exp:cWhere%
			EndSql

			If lSdoc
				cSerId := (cAliasSFX)->SDOC
			Else
				cSerId := (cAliasSFX)->SERIE
			EndIf
		
			While !Eof() .And. !lBreak .And. ;
				cxFilial == (cAliasSFX)->FILIAL .And.;
				cSerId == MV_PAR03 .And.;
				(cAliasSFX)->DOC >= MV_PAR01 .And.;
				(cAliasSFX)->DOC <= MV_PAR02
										
				aNotas := {}
				For nx:=1 To 20
					aadd(aNotas,{})
					aAdd(Atail(aNotas),.F.)
					aadd(Atail(aNotas),IIF(MV_PAR04==1,"E","S"))
					aAdd(Atail(aNotas),"")
					aadd(Atail(aNotas),(cAliasSFX)->SERIE)
					aAdd(Atail(aNotas),(cAliasSFX)->DOC)
					aadd(Atail(aNotas),"")
					aadd(Atail(aNotas),"")
					If nCursor==Val(MV_PAR02) .or. (cAliasSFX)->(Eof ())
						lBreak :=.T.
						nx:=20
					EndIF
					nCursor++
					( cAliasSFX )->( DbSkip() )
				Next nX

				dbSelectArea(cAliasSFX)
				
				If lSdoc
					cSerId := (cAliasSFX)->SDOC
				Else
					cSerId := (cAliasSFX)->SERIE
				EndIf
			
				aXml:={}
				if lUsaColab
					//Tratamento do TOTVS Colabora��o
					aXml := GetXMLColab(aNotas,@cModalidade,lUsaColab)
				else		
					aXml := GetXML(cIdEnt,aNotas,@cModalidade)
				endif
				
				nLenNotas := Len(aNotas)
				For nx :=1 To nLenNotas
					dbSelectArea("SFT")
					dbSetOrder(1)
					cChaveSFT	:=	(xFilial("SFT")+aNotas[nX][02]+aNotas[nX][04]+aNotas[nX][05])
					MsSeek(cChaveSFT)				
					If !Empty(aXML[nX][2]) .And. Empty((cAliasSFT)->FT_DTCANC) .AND. (AllTrim((cAliasSFT)->FT_ESPECIE)== 'SPED') .Or. (lImpDir .And. !Empty(aXML[nX][2]))//Realizada tal altera��o para que seja verificado antes da impress�o se a NF-e est� cancelada ou e do modelo sped
						If !Empty(aXml[nX])
							cAutoriza		:= aXML[nX][1]
							cCodAutDPEC	:= aXML[nX][5]
							cCodRetNFE		:= aXML[nX][9]
							cCodRetSF3		:= iif ( Empty (cCodAutDPEC),cCodRetNFE,cCodAutDPEC )
							cMsgSF3		:= iif ( aXML[nX][10]<> Nil ,aXML[nX][10],"")
						Else
							cAutoriza		:= ""
							cCodAutDPEC	:= ""
							cCodRetNFE		:= ""
							cCodRetSF3		:= ""
							cMsgSF3		:= ""
						EndIf
						cAviso := ""
						cErro  := ""
						oNfe := XmlParser(aXML[nX][2],"_",@cAviso,@cErro)
						oNfeDPEC := XmlParser(aXML[nX][4],"_",@cAviso,@cErro)
						//(se possui protocolo ou protocolo dpec ou a modalidade de transmissao for 2 ou 5) E codigo retorno nao esta na lista
						If (!Empty(cAutoriza) .Or. !Empty(cCodAutDPEC) .Or. Alltrim(aXML[nX][8])$"2,5") .And. !cCodRetNFE $ RetCodDene()
							If aNotas[nX][02]=="E" .And. MV_PAR04==1 .And. (oNfe:_NFE:_INFNFE:_IDE:_TPNF:TEXT=="0")
								dbSelectArea("SF1")
								dbSetOrder(1)
								If MsSeek(xFilial("SF1")+aNotas[nX][05]+aNotas[nX][04]) .And. SF1->(FieldPos("F1_FIMP"))<>0 .And. Alltrim(aXML[nX][8])$"1,3,4,6" .or. ( Alltrim(aXML[nX][8]) $ "2,5"  .And. !Empty(cAutoriza) )
									Do While !Eof() .And. SF1->F1_DOC==aNotas[nX][05] .And. SF1->F1_SERIE==aNotas[nX][04]
										If SF1->F1_FORMUL=='S'
											RecLock("SF1")
											If !SF1->F1_FIMP$"D"
												SF1->F1_FIMP := "S"
											EndIf
											If SF1->(FieldPos("F1_CHVNFE"))>0
												SF1->F1_CHVNFE := SubStr(NfeIdSPED(aXML[nX][2],"Id"),4)
											EndIf
											If SF1->(FieldPos("F1_HAUTNFE")) > 0 .and. SF1->(FieldPos("F1_DAUTNFE")) > 0 //grava a data e hora de autoriza��o da NFe
												SF1->F1_HAUTNFE := IIF(!Empty(aXML[nX][6]),SUBSTR(aXML[nX][6],1,5),"")
					   							SF1->F1_DAUTNFE	:= IIF(!Empty(aXML[nX][7]),aXML[nX][7],SToD("  /  /    "))
											EndIf
											MsUnlock()
										EndIf
										DbSkip()
									EndDo
								EndIf
								// Atualiza��o dos campos da Tabela GFE
								if FindFunction("GFECHVNFE") .and. lMVGfe  // Integra��o com o GFE 
										
									dbSelectArea("SA2")
									dbSetOrder(1)
									If SA2->(MsSeek(xFilial("SA2")+ SF1->F1_FORNECE + SF1->F1_LOJA,.T.))
										
										GFECHVNFE(xFilial("SF1"),SF1->F1_SERIE,SF1->F1_DOC,SF1->F1_TIPO,SA2->A2_CGC,SA2->A2_COD,SA2->A2_LOJA,SF1->F1_CHVNFE,SF1->F1_FIMP)
										
									endif
								endif
							ElseIf aNotas[nX][02]=="S" .And. MV_PAR04==2 .And. (oNfe:_NFE:_INFNFE:_IDE:_TPNF:TEXT=="1")
								dbSelectArea("SF2")
								dbSetOrder(1)
								If MsSeek(xFilial("SF2")+PADR(aNotas[nX][05],TAMSX3("F2_DOC")[1])+aNotas[nX][04]) .And. Alltrim(aXML[nX][8])$"1,3,4,6,7" .Or. ( Alltrim(aXML[nX][8]) $ "2,5"  .And. !Empty(cAutoriza) )
									RecLock("SF2")
									If !SF2->F2_FIMP$"D"
										SF2->F2_FIMP := "S"
									EndIf
									If SF2->(FieldPos("F2_CHVNFE"))>0
										SF2->F2_CHVNFE := SubStr(NfeIdSPED(aXML[nX][2],"Id"),4)
									EndIf
									If SF2->(FieldPos("F2_HAUTNFE")) > 0 .and. SF2->(FieldPos("F2_DAUTNFE")) > 0 //grava a data e hota de autoriza��o da NFe
										SF2->F2_HAUTNFE := IIF(!Empty(aXML[nX][6]),SUBSTR(aXML[nX][6],1,5),"")
				   						SF2->F2_DAUTNFE	:= IIF(!Empty(aXML[nX][7]),aXML[nX][7],SToD("  /  /    "))
									EndIf								
									MsUnlock()
									// Grava quando a nota for Transferencia entre filiais 
									IF SF2->(FieldPos("F2_FILDEST"))> 0 .And. SF2->(FieldPos("F2_FORDES"))> 0 .And.SF2->(FieldPos("F2_LOJADES"))> 0 .And.SF2->(FieldPos("F2_FORMDES"))> 0 .And. !EMPTY (SF2->F2_FORDES)  
								       SF1->(dbSetOrder(1))
								    	If SF1->(MsSeek(SF2->F2_FILDEST+SF2->F2_DOC+SF2->f2_SERIE+SF2->F2_FORDES+SF2->F2_LOJADES+SF2->F2_FORMDES))
								    		If EMPTY(SF1->F1_CHVNFE)	
									    		RecLock("SF1",.F.)			
									    		SF1->F1_CHVNFE := SF2->F2_CHVNFE
									    		MsUnlock()
									    	EndIf	
								    	Endif					    
								    EndiF
								EndIf
								
								// Atualiza��o dos campos da Tabela GFE
								if FindFunction("GFECHVNFE") .and. lMVGfe  // Integra��o com o GFE 
										
									dbSelectArea("SA1")
									dbSetOrder(1)
									If SA1->(MsSeek(xFilial("SA1")+ SF2->F2_CLIENTE + SF2->F2_LOJA,.T.))
										
										GFECHVNFE(xFilial("SF2"),SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_TIPO,SA1->A1_CGC,SA1->A1_COD,SA1->A1_LOJA,SF2->F2_CHVNFE,SF2->F2_FIMP)
										
									endif
								endif
							
								If ExistFunc("STFMMd5NS") //Fun��o do Controle de Lojas - Legisla��o PAF-ECF
									STFMMd5NS()
								EndIf
							EndIf
							dbSelectArea("SFT")
							dbSetOrder(1)
							If SFT->(FieldPos("FT_CHVNFE"))>0
								cChaveSFT	:=	(xFilial("SFT")+aNotas[nX][02]+aNotas[nX][04]+padr(aNotas[nX][05],TamSx3("FT_NFISCAL")[1],""))
								IF MsSeek(cChaveSFT)
									Do While !(cAliasSFT)->(Eof ()) .And.;
										cChaveSFT==(cAliasSFT)->FT_FILIAL+(cAliasSFT)->FT_TIPOMOV+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_NFISCAL
										If (cAliasSFT)->FT_TIPOMOV $"S" .Or. ((cAliasSFT)->FT_TIPOMOV $"E" .And. (cAliasSFT)->FT_FORMUL=='S')
											RecLock("SFT")
											SFT->FT_CHVNFE := SubStr(NfeIdSPED(aXML[nX][2],"Id"),4)
											MsUnLock()
											//Array criado para gravar o SF3 no final, pois a tabela SF3 pode estah em processamento quando se trata de DBF ou AS/400.
											If aScan(aGrvSF3,{|aX|aX[1]+aX[2]+aX[3]+aX[4]+aX[5]==(cAliasSFT)->(FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_IDENTF3)})==0
												aAdd(aGrvSF3, {(cAliasSFT)->FT_SERIE,(cAliasSFT)->FT_NFISCAL,(cAliasSFT)->FT_CLIEFOR,(cAliasSFT)->FT_LOJA,(cAliasSFT)->FT_IDENTF3,(cAliasSFT)->FT_CHVNFE,cAutoriza,cCodRetSF3,cMsgSF3})
											EndIf
										EndIf
										DbSkip()
									EndDo
								Endif
							EndIf
							// Grava quando a nota for Transferencia entre filiais 
							IF SF1->(!EOF()) .And. SF2->(FieldPos("F2_FILDEST"))> 0 .And. SF2->(FieldPos("F2_FORDES"))> 0 .And.SF2->(FieldPos("F2_LOJADES"))> 0 .And.SF2->(FieldPos("F2_FORMDES"))> 0 .And. !EMPTY (SF2->F2_FORDES)  
							  	SFT->(dbSetOrder(1))
								cChave := SF1->F1_FILIAL+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA
								If SFT->(MsSeek(SF1->F1_FILIAL+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA,.T.))
									Do While cChave == SFT->FT_FILIAL+"E"+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA .And. !SFT->(Eof())
											SFT->FT_CHVNFE := SubStr(NfeIdSPED(aXML[nX][2],"Id"),4)
											MsUnLock()
											//Array criado para gravar o SF3 no final, pois a tabela SF3 pode estah em processamento quando se trata de DBF ou AS/400.
											If aScan(aGrvSF3,{|aX|aX[1]+aX[2]+aX[3]+aX[4]+aX[5]==(cAliasSFT)->(FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_IDENTF3)})==0
												aAdd(aGrvSF3, {(cAliasSFT)->FT_SERIE,(cAliasSFT)->FT_NFISCAL,(cAliasSFT)->FT_CLIEFOR,(cAliasSFT)->FT_LOJA,(cAliasSFT)->FT_IDENTF3,(cAliasSFT)->FT_CHVNFE,cAutoriza,cCodRetSF3,cMsgSF3})
											EndIf
										MsUnLock()
										SFT->(dbSkip())
							    	EndDo
								EndIf
							EndIf
							//-------------------------------
							If Empty(cAviso) .And. Empty(cErro) .And. MV_PAR04==1 .And. (oNfe:_NFE:_INFNFE:_IDE:_TPNF:TEXT=="0")
								ImpDet(@oDanfe,oNFe,cAutoriza,cModalidade,oNfeDPEC,cCodAutDPEC,aXml[nX][6],aXml[nX][7],aNotas[nX])
								lExistNfe := .T.							
							ElseIf Empty(cAviso) .And. Empty(cErro) .And. MV_PAR04==2 .And. (oNfe:_NFE:_INFNFE:_IDE:_TPNF:TEXT=="1")
								ImpDet(@oDanfe,oNFe,cAutoriza,cModalidade,oNfeDPEC,cCodAutDPEC,aXml[nX][6],aXml[nX][7],aNotas[nX])
								lExistNfe := .T.
							EndIf
	
						ElseIf lIsLoja							
							/*	Se o Codigo de Retorno da SEFAZ estiver preenchido e for maior que 200,
								entao houve rejeicao por parte da SEFAZ	*/
							If !Empty(aXML[nX][9]) .AND. Val(aXML[nX][9]) > 200 
								RecLock("SF2",.F.)
								Replace SF2->F2_FIMP with "N"
								SF2->( MsUnlock() )
	
								cNaoAut := "A impress�o do DANFE referente a Nota/S�rie " + SF2->F2_DOC + "/" + SF2->F2_SERIE + " n�o ser� realizada pelo motivo abaixo:"
								cNaoAut += CRLF + "[" + aXML[nX][9] + ' - ' + aXML[nX][10] + "]."
								cNaoAut += CRLF + "Se poss�vel, fa�a o ajuste e retransmita a NF-e."
										
								Aviso( "SPED", cNaoAut, {"Continuar"}, 3 )
							EndIf
	
						Else
							cNaoAut += aNotas[nX][04]+aNotas[nX][05]+CRLF
						EndIf
					EndIf
	
					oNfe     := nil
					oNfeDPEC := nil
					delClassIntF()				
				Next nx
			EndDo
		EndDo

		If !lIsLoja .AND. !Empty(cNaoAut)
			Aviso("SPED","As seguintes notas n�o foram autorizadas: "+CRLF+CRLF+cNaoAut,{"Ok"},3)
		EndIf
    EndIf
    
ElseIf ( !Empty( MV_PAR06 ) .and. MV_PAR06 == 1 )
	Aviso("DANFE","Impress�o de DANFE Simplificada, dispon�vel somente em formato retrato.",{"OK"},3)	    
EndIf
If Len(aGrvSF3)>0 .And. SF3->(FieldPos("F3_CHVNFE"))>0
	SF3->( dbSetOrder( 5 ))
	For nI := 1 To Len(aGrvSF3)
		If SF3->(MsSeek(xFilial("SF3")+aGrvSF3[nI,1]+aGrvSF3[nI,2]+aGrvSF3[nI,3]+aGrvSF3[nI,4]+aGrvSF3[nI,5])) .And. Empty(SF3->F3_CHVNFE);
				.and. (Val(SF3->F3_CFO) >= 5000 .Or. SF3->F3_FORMUL=='S')
			RecLock("SF3",.F.)
			SF3->F3_CHVNFE := aGrvSF3[nI,6] // Chave da nota
			SF3->F3_PROTOC := aGrvSF3[nI,7] // Protocolo
			SF3->F3_CODRSEF:= aGrvSF3[nI,8] // Codigo de retorno Sefaz
			SF3->F3_DESCRET:= aGrvSF3[nI,9] // Mensagem de retorno Sefaz
			SF3->F3_CODRET := iif (SF3->(FieldPos("F3_CODRET"))>0,"M",)
			MsUnLock()
		EndIf
	Next nI
EndIf
RestArea(aArea)
Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Program   � ImpDet   � Autor � Eduardo Riera         � Data �16.11.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Controle de Fluxo do Relatorio.                             ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto grafico de impressao                    (OPC) ���
���          �ExpC2: String com o XML da NFe                              ���
���          �ExpC3: Codigo de Autorizacao do fiscal                (OPC) ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ImpDet(oDanfe,oNfe,cCodAutSef,cModalidade,oNfeDPEC,cCodAutDPEC,cDtHrRecCab,dDtReceb,aNota)

PRIVATE oFont10N   := TFontEx():New(oDanfe,"Times New Roman",08,08,.T.,.T.,.F.)// 1
PRIVATE oFont07N   := TFontEx():New(oDanfe,"Times New Roman",07,07,.T.,.T.,.F.)// 2
PRIVATE oFont07    := TFontEx():New(oDanfe,"Times New Roman",07,07,.F.,.T.,.F.)// 3
PRIVATE oFont08    := TFontEx():New(oDanfe,"Times New Roman",07,07,.F.,.T.,.F.)// 4
PRIVATE oFont08N   := TFontEx():New(oDanfe,"Times New Roman",06,06,.T.,.T.,.F.)// 5
PRIVATE oFont09N   := TFontEx():New(oDanfe,"Times New Roman",08,08,.T.,.T.,.F.)// 6
PRIVATE oFont09    := TFontEx():New(oDanfe,"Times New Roman",08,08,.F.,.T.,.F.)// 7
PRIVATE oFont10    := TFontEx():New(oDanfe,"Times New Roman",10,10,.F.,.T.,.F.)// 8
PRIVATE oFont11    := TFontEx():New(oDanfe,"Times New Roman",10,10,.F.,.T.,.F.)// 9
PRIVATE oFont12    := TFontEx():New(oDanfe,"Times New Roman",11,11,.F.,.T.,.F.)// 10
PRIVATE oFont11N   := TFontEx():New(oDanfe,"Times New Roman",10,10,.T.,.T.,.F.)// 11
PRIVATE oFont18N   := TFontEx():New(oDanfe,"Times New Roman",17,17,.T.,.T.,.F.)// 12 
PRIVATE OFONT12N   := TFontEx():New(oDanfe,"Times New Roman",11,11,.T.,.T.,.F.)// 12 
PRIVATE lUsaColab	  :=  UsaColaboracao("1")

PrtDanfe(@oDanfe,oNfe,cCodAutSef,cModalidade,oNfeDPEC,cCodAutDPEC,cDtHrRecCab,dDtReceb,aNota)

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �PrtDanfe  � Autor �Eduardo Riera          � Data �16.11.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Impressao do formulario DANFE grafico conforme laytout no   ���
���          �formato retrato                                             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � PrtDanfe()                                                 ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto grafico de impressao                          ���
���          �ExpO2: Objeto da NFe                                        ���
���          �ExpC3: Codigo de Autorizacao do fiscal                (OPC) ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PrtDanfe(oDanfe,oNFE,cCodAutSef,cModalidade,oNfeDPEC,cCodAutDPEC,cDtHrRecCab,dDtReceb,aNota)


Local aAuxCabec     := {} // Array que conter� as strings de cabe�alho das colunas de produtos/servi�os.
Local aTamanho      := {}
Local aTamCol       := {} // Array que conter� o tamanho das colunas dos produtos/servi�os.
Local aSimpNac		:= {}  
Local aSitTrib      := {}
Local aSitSN        := {}
Local aTransp       := {}
Local aDest         := {}
Local aHrEnt        := {}
Local aFaturas      := {}
Local aItens        := {}
Local aISSQN        := {}
Local aTotais       := {}
Local aAux          := {}
Local aUF           := {}
Local aMensagem     := {}
Local aEspVol       := {}
Local aEspecie      := {}
Local aIndImp       := {}
Local aIndAux       := {}
Local aLote         := {}
                           
Local nHPage        := 0
Local nVPage        := 0
Local nPosV         := 0
Local nPosVOld      := 0
Local nPosH         := 0
Local nPosHOld      := 0
Local nAuxH         := 0
Local nAuxH2        := 0
Local nAuxV         := 0
Local nSnBaseIcm	 := 0
Local nSnValIcm    := 0
Local nDetImp		 := 0
Local nS			 := 0
Local nX            := 0
Local nY            := 0
Local nL            := 0
Local nJ            := 0
Local nW            := 0
Local nTamanho      := 0
Local nFolha        := 1
Local nFolhas       := 0
Local nItem         := 0
Local nMensagem     := 0
Local nBaseICM      := 0
Local nValICM       := 0
Local nBaseICMST    := 0
Local nValICMST     := 0
Local nValIPI       := 0
Local nPICM         := 0
Local nPIPI         := 0
Local nFaturas      := 0
Local nVTotal       := 0
Local nDesc         := 0
Local nQtd          := 0
Local nVUnit        := 0
Local nVolume	    := 0
Local nLenFatura
Local nLenVol
Local nLenDet
Local nLenSit
Local nLenItens     := 0
Local nLenMensagens := 0
Local nLen          := 0
Local nColuna       := 0
Local nLinSum       := 0
Local nE            := 0
Local nMaxCod       := 10
Local nMaxDes       := MAXITEMC
//Local nPerDesc      := 0
Local nVUniLiq      := 0
Local nVTotLiq      := 0
Local nZ            := 0

Local cAux          := ""
Local cSitTrib      := ""
Local cUF           := ""
Local cChaveCont    := ""
Local cLogo         := FisxLogo("1")
Local cMVCODREG     := Alltrim( SuperGetMV("MV_CODREG", ," ") )
Local cGuarda       := "" 
Local cEsp          := ""
local cEndDest      := ""
Local cXJust		:= ""
Local cDhCont		:= ""

Local lPreview      := .F.
Local lFlag         := .T.
Local lImpAnfav     := GetNewPar("MV_IMPANF",.F.) 
Local lImpInfAd     := GetNewPar("MV_IMPADIC",.F.)
Local lConverte     := GetNewPar("MV_CONVERT",.F.)
Local lImpSimpN		:= GetNewPar("MV_IMPSIMP",.F.)
Local lMv_ItDesc    := Iif( GetNewPar("MV_ITDESC","N")=="S", .T., .F. )
Local lNFori2       := .T.
Local lCompleECF    := .F.
Local lEntIpiDev   	:= GetNewPar("MV_EIPIDEV",.F.) /*Apenas para nota de entrada de Devolu��o de ipi. .T.-S�ra destacado no cabe�alho + inf.compl/.F.-Ser� destacado apenas em inf.compl*/

Local lPontilhado 	:= .F.
Local aAuxCom 		:= {}    	
Local cUnCom		:= ""
Local nQtdCom		:= 0
Local nVUnitCom		:= 0

// RCIMS de MG
Local lUf_MG		:= ( SuperGetMv("MV_ESTADO") $ "MG" )	// Criado esta variavel para atender o RICMS de MG para totalizar por CFOP
Local nSequencia	:= 0
Local nSubTotal		:= 0
Local cCfop			:= ""
Local cCfopAnt		:= ""
Local aItensAux     := {}
Local aArray		:= {}

Default cDtHrRecCab := ""
Default dDtReceb    := CToD("")

Private aInfNf      := {}

Private oDPEC       := oNfeDPEC
Private oNF         := oNFe:_NFe
Private oEmitente   := oNF:_InfNfe:_Emit
Private oIdent      := oNF:_InfNfe:_IDE
Private oDestino    := oNF:_InfNfe:_Dest
Private oTotal      := oNF:_InfNfe:_Total
Private oTransp     := oNF:_InfNfe:_Transp
Private oDet        := oNF:_InfNfe:_Det
Private oFatura     := IIf(Type("oNF:_InfNfe:_Cobr")=="U",Nil,oNF:_InfNfe:_Cobr)
Private oImposto

Private nPrivate    := 0
Private nPrivate2   := 0
Private nXAux	    := 0

Private lArt488MG   := .F.
Private lArt274SP   := .F.  

oBrush              := TBrush():New( , CLR_BLACK )

nFaturas := IIf(oFatura<>Nil,IIf(ValType(oNF:_InfNfe:_Cobr:_Dup)=="A",Len(oNF:_InfNfe:_Cobr:_Dup),1),0)
oDet := IIf(ValType(oDet)=="O",{oDet},oDet)
//������������������������������������������������������������������������Ŀ
//�Carrega as variaveis de impressao                                       �
//��������������������������������������������������������������������������
aadd(aSitTrib,"00")
aadd(aSitTrib,"10")
aadd(aSitTrib,"20")
aadd(aSitTrib,"30")
aadd(aSitTrib,"40")
aadd(aSitTrib,"41")
aadd(aSitTrib,"50")
aadd(aSitTrib,"51")
aadd(aSitTrib,"60")
aadd(aSitTrib,"70")
aadd(aSitTrib,"90")
aadd(aSitTrib,"PART")
aadd(aSitSN,"101")
aadd(aSitSN,"102")
aadd(aSitSN,"201")
aadd(aSitSN,"202")
aadd(aSitSN,"500")
aadd(aSitSN,"900")
//������������������������������������������������������������������������Ŀ
//�Quadro Destinatario                                                     �
//��������������������������������������������������������������������������

cEndDest := NoChar(oDestino:_EnderDest:_Xlgr:Text,lConverte)
If  " SN" $ (UPPER (oDestino:_EnderDest:_Xlgr:Text)) .Or. ",SN" $ (UPPER (oDestino:_EnderDest:_Xlgr:Text)) .Or. ;
    "S/N" $ (UPPER (oDestino:_EnderDest:_Xlgr:Text)) 
   
            cEndDest += IIf(Type("oDestino:_EnderDest:_xcpl")=="U","",", " + NoChar(oDestino:_EnderDest:_xcpl:Text,lConverte))
Else
            cEndDest += +","+NoChar(oDestino:_EnderDest:_NRO:Text,lConverte) + IIf(Type("oDestino:_EnderDest:_xcpl")=="U","",", "+ NoChar(oDestino:_EnderDest:_xcpl:Text,lConverte))
Endif   

aDest := {cEndDest,;
NoChar(oDestino:_EnderDest:_XBairro:Text,lConverte),;
IIF(Type("oDestino:_EnderDest:_Cep")=="U","",Transform(oDestino:_EnderDest:_Cep:Text,"@r 99999-999")),;
IIF(oNF:_INFNFE:_VERSAO:TEXT >= "3.10",IIF(Type("oIdent:_DHSaiEnt")=="U","",oIdent:_DHSaiEnt:Text),IIF(Type("oIdent:_DSaiEnt")=="U","",oIdent:_DSaiEnt:Text)),;
oDestino:_EnderDest:_XMun:Text,;
IIF(Type("oDestino:_EnderDest:_fone")=="U","",oDestino:_EnderDest:_fone:Text),;
oDestino:_EnderDest:_UF:Text,;
IIF(Type("oDestino:_IE")=="U","",oDestino:_IE:Text),;
""}

If oNF:_INFNFE:_VERSAO:TEXT >= "3.10"
	aadd(aHrEnt,IIF(Type("oIdent:_dhSaiEnt")=="U","",SubStr(oIdent:_dhSaiEnt:TEXT,12,8)))
Else
	If Type("oIdent:_DSaiEnt")<>"U" .And. Type("oIdent:_HSaiEnt:Text")<>"U"
		aAdd(aHrEnt,oIdent:_HSaiEnt:Text)
	Else
		aAdd(aHrEnt,"")
	EndIf	
EndIf
//������������������������������������������������������������������������Ŀ
//�Calculo do Imposto                                                      �
//��������������������������������������������������������������������������
aTotais := {"","","","","","","","","","",""}
aTotais[01] := Transform(Val(oTotal:_ICMSTOT:_vBC:TEXT),		"@e 9,999,999,999,999.99")
aTotais[02] := Transform(Val(oTotal:_ICMSTOT:_vICMS:TEXT),		"@e 999,999,999,999.99")
aTotais[03] := Transform(Val(oTotal:_ICMSTOT:_vBCST:TEXT),		"@e 9,999,999,999,999.99")
aTotais[04] := Transform(Val(oTotal:_ICMSTOT:_vST:TEXT),		"@e 999,999,999,999.99")
aTotais[05] := Transform(Val(oTotal:_ICMSTOT:_vProd:TEXT),		"@e 9,999,999,999,999.99")
aTotais[06] := Transform(Val(oTotal:_ICMSTOT:_vFrete:TEXT),		"@e 999,999,999,999.99")
aTotais[07] := Transform(Val(oTotal:_ICMSTOT:_vSeg:TEXT), 		"@e 999,999,999,999.99")
aTotais[08] := Transform(Val(oTotal:_ICMSTOT:_vDesc:TEXT),		"@e 999,999,999,999.99")
aTotais[09] := Transform(Val(oTotal:_ICMSTOT:_vOutro:TEXT),		"@e 999,999,999,999.99")

If ( MV_PAR04 == 1 )
	dbSelectArea("SF1")
	dbSetOrder(1)
	If MsSeek(xFilial("SF1")+aNota[5]+aNota[4]+aNota[6]+aNota[7]) .And. SF1->(FieldPos("F1_FIMP"))<>0
		If SF1->F1_TIPO <> "D"
		  	aTotais[10] := 	Transform(Val(oTotal:_ICMSTOT:_vIPI:TEXT),"@e 9,999,999,999,999.99")
		ElseIf SF1->F1_TIPO == "D" .and. lEntIpiDev
			aTotais[10] := 	Transform(Val(oTotal:_ICMSTOT:_vIPI:TEXT),"@e 9,999,999,999,999.99")
		Else	
			aTotais[10] := ""
		EndIf        
		MsUnlock()
		DbSkip()
	EndIf
Else
	aTotais[10] := 	Transform(Val(oTotal:_ICMSTOT:_vIPI:TEXT),"@e 9,999,999,999,999.99")
EndIf

aTotais[11] := 	Transform(Val(oTotal:_ICMSTOT:_vNF:TEXT),		"@e 9,999,999,999,999.99")

//�������������������������������������������������������������������������������������������������������Ŀ
//�Impress�o da Base de Calculo e ICMS nos campo Proprios do ICMS quando optante pelo Simples Nacional    �
//���������������������������������������������������������������������������������������������������������
 
If lImpSimpN   

	nDetImp := Len(oDet)
	nS := nDetImp 
	aSimpNac := {"",""}

	    if Type("oDet["+Alltrim(Str(nS))+"]:_IMPOSTO:_ICMS:_ICMSSN101:_VCREDICMSSN:TEXT") <> "U"
	    	SF3->(dbSetOrder(5))
	
			if SF3->(MsSeek(xFilial("SF3")+aNota[4]+aNota[5]))
				while SF3->(!eof()) .and. ( SF3->F3_SERIE + SF3->F3_NFISCAL  == aNota[4] + aNota[5] )
					nSnBaseIcm += (SF3->F3_BASEICM)
					nSnValIcm  += (SF3->F3_VALICM)
					SF3->(dbSkip())
				end 
		   	endif
		    		    	
	    elseif Type("oDet["+Alltrim(Str(nS))+"]:_IMPOSTO:_ICMS:_ICMSSN900:_VCREDICMSSN:TEXT") <> "U"
			nS:= 0	    
	    	For nS := 1 To nDetImp 
	 			nSnBaseIcm += Val(oDet[nS]:_IMPOSTO:_ICMS:_ICMSSN900:_VBC:TEXT)
				nSnValIcm  += Val(oDet[nS]:_IMPOSTO:_ICMS:_ICMSSN900:_VCREDICMSSN:TEXT)
			Next nS
			
	    endif
    	    
	   	aSimpNac[01] := Transform((nSnBaseIcm),"@e 9,999,999,999,999.99")
		aSimpNac[02] := Transform((nSnValIcm),"@e 9,999,999,999,999.99")
    
EndIf

//������������������������������������������������������������������������Ŀ
//�Quadro Faturas                                                          �
//��������������������������������������������������������������������������
If nFaturas > 0
	For nX := 1 To 3
		aAux := {}
		For nY := 1 To Min(9, nFaturas)
			Do Case
				Case nX == 1
					If nFaturas > 1
						AAdd(aAux, AllTrim(oFatura:_Dup[nY]:_nDup:TEXT))
					Else
						AAdd(aAux, AllTrim(oFatura:_Dup:_nDup:TEXT))
					EndIf
				Case nX == 2
					If nFaturas > 1
						AAdd(aAux, AllTrim(ConvDate(oFatura:_Dup[nY]:_dVenc:TEXT)))
					Else
						AAdd(aAux, AllTrim(ConvDate(oFatura:_Dup:_dVenc:TEXT)))
					EndIf
				Case nX == 3
					If nFaturas > 1
						AAdd(aAux, AllTrim(TransForm(Val(oFatura:_Dup[nY]:_vDup:TEXT), "@E 9999,999,999.99")))
					Else
						AAdd(aAux, AllTrim(TransForm(Val(oFatura:_Dup:_vDup:TEXT), "@E 9999,999,999.99")))
					EndIf
			EndCase
		Next nY
		If nY <= 9
			For nY := 1 To 9
				AAdd(aAux, Space(20))
			Next nY
		EndIf
		AAdd(aFaturas, aAux)
	Next nX
EndIf

//������������������������������������������������������������������������Ŀ
//�Quadro transportadora                                                   �
//��������������������������������������������������������������������������
aTransp := {"","0","","","","","","","","","","","","","",""}

If Type("oTransp:_ModFrete")<>"U"
	aTransp[02] := IIF(Type("oTransp:_ModFrete:TEXT")<>"U",oTransp:_ModFrete:TEXT,"0")
EndIf
If Type("oTransp:_Transporta")<>"U"
	aTransp[01] := IIf(Type("oTransp:_Transporta:_xNome:TEXT")<>"U",NoChar(oTransp:_Transporta:_xNome:TEXT,lConverte),"")
	//	aTransp[02] := IIF(Type("oTransp:_ModFrete:TEXT")<>"U",oTransp:_ModFrete:TEXT,"0")
	aTransp[03] := IIf(Type("oTransp:_VeicTransp:_RNTC")=="U","",oTransp:_VeicTransp:_RNTC:TEXT)
	aTransp[04] := IIf(Type("oTransp:_VeicTransp:_Placa:TEXT")<>"U",oTransp:_VeicTransp:_Placa:TEXT,"")
	aTransp[05] := IIf(Type("oTransp:_VeicTransp:_UF:TEXT")<>"U",oTransp:_VeicTransp:_UF:TEXT,"")
	If Type("oTransp:_Transporta:_CNPJ:TEXT")<>"U"
		aTransp[06] := Transform(oTransp:_Transporta:_CNPJ:TEXT,"@r 99.999.999/9999-99")
	ElseIf Type("oTransp:_Transporta:_CPF:TEXT")<>"U"
		aTransp[06] := Transform(oTransp:_Transporta:_CPF:TEXT,"@r 999.999.999-99")
	EndIf
	aTransp[07] := IIf(Type("oTransp:_Transporta:_xEnder:TEXT")<>"U",NoChar(oTransp:_Transporta:_xEnder:TEXT,lConverte),"")
	aTransp[08] := IIf(Type("oTransp:_Transporta:_xMun:TEXT")<>"U",oTransp:_Transporta:_xMun:TEXT,"")
	aTransp[09] := IIf(Type("oTransp:_Transporta:_UF:TEXT")<>"U",oTransp:_Transporta:_UF:TEXT,"")
	aTransp[10] := IIf(Type("oTransp:_Transporta:_IE:TEXT")<>"U",oTransp:_Transporta:_IE:TEXT,"")
ElseIf Type("oTransp:_VEICTRANSP")<>"U"
	aTransp[03] := IIf(Type("oTransp:_VeicTransp:_RNTC")=="U","",oTransp:_VeicTransp:_RNTC:TEXT)
	aTransp[04] := IIf(Type("oTransp:_VeicTransp:_Placa:TEXT")<>"U",oTransp:_VeicTransp:_Placa:TEXT,"")
	aTransp[05] := IIf(Type("oTransp:_VeicTransp:_UF:TEXT")<>"U",oTransp:_VeicTransp:_UF:TEXT,"")
EndIf
If Type("oTransp:_Vol")<>"U"
	If ValType(oTransp:_Vol) == "A"
		nX := nPrivate
		nLenVol := Len(oTransp:_Vol)
		For nX := 1 to nLenVol
			nXAux := nX
			nVolume += IIF(!Type("oTransp:_Vol[nXAux]:_QVOL:TEXT")=="U",Val(oTransp:_Vol[nXAux]:_QVOL:TEXT),0)
		Next nX
		aTransp[11]	:= AllTrim(str(nVolume))
		aTransp[12]	:= IIf(Type("oTransp:_Vol:_Esp")=="U","Diversos","")
		aTransp[13] := IIf(Type("oTransp:_Vol:_Marca")=="U","",NoChar(oTransp:_Vol:_Marca:TEXT,lConverte))
		aTransp[14] := IIf(Type("oTransp:_Vol:_nVol:TEXT")<>"U",oTransp:_Vol:_nVol:TEXT,"")
		If  Type("oTransp:_Vol[1]:_PesoB") <>"U"
			nPesoB := Val(oTransp:_Vol[1]:_PesoB:TEXT)
			aTransp[15] := AllTrim(str(nPesoB))
		EndIf
		If Type("oTransp:_Vol[1]:_PesoL") <>"U"
			nPesoL := Val(oTransp:_Vol[1]:_PesoL:TEXT)
			aTransp[16] := AllTrim(str(nPesoL))
		EndIf
	Else
		aTransp[11] := IIf(Type("oTransp:_Vol:_qVol:TEXT")<>"U",oTransp:_Vol:_qVol:TEXT,"")
		aTransp[12] := IIf(Type("oTransp:_Vol:_Esp")=="U","",oTransp:_Vol:_Esp:TEXT)
		aTransp[13] := IIf(Type("oTransp:_Vol:_Marca")=="U","",NoChar(oTransp:_Vol:_Marca:TEXT,lConverte))
		aTransp[14] := IIf(Type("oTransp:_Vol:_nVol:TEXT")<>"U",oTransp:_Vol:_nVol:TEXT,"")
		aTransp[15] := IIf(Type("oTransp:_Vol:_PesoB:TEXT")<>"U",oTransp:_Vol:_PesoB:TEXT,"")
		aTransp[16] := IIf(Type("oTransp:_Vol:_PesoL:TEXT")<>"U",oTransp:_Vol:_PesoL:TEXT,"")
	EndIf
	aTransp[15] := strTRan(aTransp[15],".",",")
	aTransp[16] := strTRan(aTransp[16],".",",")
EndIf


//������������������������������������������������������������������������Ŀ
//�Volumes / Especie Nota de Saida                                         �
//�������������������������������������������������������������������������� 
If(MV_PAR04==2) .And. Empty(aTransp[12])
	If (SF2->(FieldPos("F2_ESPECI1")) <>0 .And. !Empty( SF2->(FieldGet(FieldPos( "F2_ESPECI1" )))  )) .Or.;
	   (SF2->(FieldPos("F2_ESPECI2")) <>0 .And. !Empty( SF2->(FieldGet(FieldPos( "F2_ESPECI2" )))  )) .Or.;
	   (SF2->(FieldPos("F2_ESPECI3")) <>0 .And. !Empty( SF2->(FieldGet(FieldPos( "F2_ESPECI3" )))  )) .Or.; 
	   (SF2->(FieldPos("F2_ESPECI4")) <>0 .And. !Empty( SF2->(FieldGet(FieldPos( "F2_ESPECI4" )))  ))

	   	aEspecie := {}   
		aadd(aEspecie,SF2->F2_ESPECI1)
		aadd(aEspecie,SF2->F2_ESPECI2)
		aadd(aEspecie,SF2->F2_ESPECI3)
		aadd(aEspecie,SF2->F2_ESPECI4)
        
		cEsp := ""
		nx 	 := 0 
		For nE := 1 To Len(aEspecie)
			If !Empty(aEspecie[nE])
				nx ++   
				cEsp := aEspecie[nE]
			EndIf
		Next 
		
		cGuarda := ""
		If nx > 1
			cGuarda := "Diversos"
		Else
			cGuarda := cEsp
		EndIf
		
		If !Empty(cGuarda)
		  	aadd(aEspVol,{cGuarda,Iif(SF2->F2_PLIQUI>0,str(SF2->F2_PLIQUI),""),Iif(SF2->F2_PBRUTO>0, str(SF2->F2_PBRUTO),"")})
		Else
			/*
			//������������������������������������������������������������������1
			//�Aqui seguindo a mesma regra da cria��o da TAG de Volumes no xml  �
			//� caso n�o esteja preenchida nenhuma das especies de Volume n�o se�
			//� envia as informa��es de volume.                   				�
			//������������������������������������������������������������������1
			*/
			aadd(aEspVol,{cGuarda,"",""}) 
		Endif 
	Else
		aadd(aEspVol,{cGuarda,"",""})
	EndIf
EndIf
//������������������������������������������������������������������������Ŀ
//�Especie Nota de Entrada                                                 �
//��������������������������������������������������������������������������
If(MV_PAR04==1) .And. Empty(aTransp[12])   
	dbSelectArea("SF1")
	dbSetOrder(1)
	If MsSeek(xFilial("SF1")+aNota[5]+aNota[4]+aNota[6]+aNota[7])
     
		If (SF1->(FieldPos("F1_ESPECI1")) <>0 .And. !Empty( SF1->(FieldGet(FieldPos( "F1_ESPECI1" )))  )) .Or.;
			(SF1->(FieldPos("F1_ESPECI2")) <>0 .And. !Empty( SF1->(FieldGet(FieldPos( "F1_ESPECI2" )))  )) .Or.;
			(SF1->(FieldPos("F1_ESPECI3")) <>0 .And. !Empty( SF1->(FieldGet(FieldPos( "F1_ESPECI3" )))  )) .Or.;
			(SF1->(FieldPos("F1_ESPECI4")) <>0 .And. !Empty( SF1->(FieldGet(FieldPos( "F1_ESPECI4" )))  ))
			
			aEspecie := {}
			aadd(aEspecie,SF1->F1_ESPECI1)
			aadd(aEspecie,SF1->F1_ESPECI2)
			aadd(aEspecie,SF1->F1_ESPECI3)
			aadd(aEspecie,SF1->F1_ESPECI4)
			
			cEsp := ""
			nx 	 := 0
			For nE := 1 To Len(aEspecie)
				If !Empty(aEspecie[nE])
					nx ++
					cEsp := aEspecie[nE]
				EndIf
			Next
			
			cGuarda := ""
			If nx > 1
				cGuarda := "Diversos"
			Else
				cGuarda := cEsp
			EndIf
			
			If  !Empty(cGuarda)
				aadd(aEspVol,{cGuarda,Iif(SF1->F1_PLIQUI>0,str(SF1->F1_PLIQUI),""),Iif(SF1->F1_PBRUTO>0, str(SF1->F1_PBRUTO),"")})
			Else
				/*
				//������������������������������������������������������������������1
				//�Aqui seguindo a mesma regra da cria��o da TAG de Volumes no xml  �
				//� caso n�o esteja preenchida nenhuma das especies de Volume n�o se�
				//� envia as informa��es de volume.                   				�
				//������������������������������������������������������������������1
				*/
				aadd(aEspVol,{cGuarda,"",""})
			Endif
		Else
			aadd(aEspVol,{cGuarda,"",""})
		EndIf
		
		MsUnlock()
		DbSkip()		
	EndIf
EndIf

//�������������Ŀ
//�Tipo do frete�
//���������������
dbSelectArea("SD2")
dbSetOrder(3)
MsSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
dbSelectArea("SC5")
dbSetOrder(1)
MsSeek(xFilial("SC5")+SD2->D2_PEDIDO)
dbSelectArea("SF3")
dbSetOrder(4)
MsSeek(xFilial("SF3")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE)

lArt488MG := Iif(SF4->(FIELDPOS("F4_CRLEIT"))>0,Iif(SF4->F4_CRLEIT == "1",.T.,.F.),.F.)
lArt274SP := Iif(SF4->(FIELDPOS("F4_ART274"))>0,Iif(SF4->F4_ART274 $ "1S",.T.,.F.),.F.) 

If Type("oTransp:_ModFrete") <> "U"
	cModFrete := oTransp:_ModFrete:TEXT
Else
	cModFrete := "1"
EndIf

//������������������������������������������������������������������������Ŀ
//�Quadro Dados do Produto / Servi�o                                       �
//��������������������������������������������������������������������������
nLenDet := Len(oDet)
If lMv_ItDesc
	For nX := 1 To nLenDet
		Aadd(aIndAux, {nX, SubStr(NoChar(oDet[nX]:_Prod:_xProd:TEXT,lConverte),1,MAXITEMC)})
	Next
	
	aIndAux := aSort(aIndAux,,, { |x, y| x[2] < y[2] })
	
	For nX := 1 To nLenDet
		Aadd(aIndImp, aIndAux[nX][1] )
	Next
EndIf


For nZ := 1 To nLenDet
	If lMv_ItDesc
		nX := aIndImp[nZ]
	Else
		nX := nZ
	EndIf
	nPrivate := nX

    If lArt488MG .And. lUf_MG
        nVTotal  := 0
        nVUnit   := 0 
    Else
	    nVTotal  := Val(oDet[nX]:_Prod:_vProd:TEXT)//-Val(IIF(Type("oDet[nPrivate]:_Prod:_vDesc")=="U","",oDet[nX]:_Prod:_vDesc:TEXT))
	    nVUnit   := Val(oDet[nX]:_Prod:_vUnTrib:TEXT)
	EndIf
	nQtd     := Val(oDet[nX]:_Prod:_qTrib:TEXT)

	If Type("oDet[nPrivate]:_Prod:_vDesc:TEXT")<>"U"
		nDesc := Val( oDet[nX]:_Prod:_vDesc:TEXT )
	Else
		nDesc := 0
	EndIf
    
//	nPerDesc	:= ((nDesc*100)/nVTotal)
	nVUniLiq	:= nVUnit-(nDesc/nQtd)
	nVTotLiq	:= nVTotal-nDesc

	nBaseICM	:= 0
	nValICM  	:= 0
	nBaseICMST	:= 0
	nValICMST	:= 0
	nValIPI  	:= 0
	nPICM    	:= 0
	nPIPI    	:= 0
	oImposto 	:= oDet[nX]                
	cSitTrib 	:= ""
	lPontilhado	:= .F.	
	If Type("oImposto:_Imposto")<>"U"
		If Type("oImposto:_Imposto:_ICMS")<>"U"
			nLenSit := Len(aSitTrib)
			For nY := 1 To nLenSit
				nPrivate2 := nY
				If Type("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2])<>"U"
					If Type("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_VBC:TEXT")<>"U"
						nBaseICM := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_VBC:TEXT"))
						nValICM  := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_vICMS:TEXT"))
						nPICM    := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_PICMS:TEXT")) 
					ElseIf Type("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_MOTDESICMS") <> "U" .And. Type("oImposto:_PROD:_VDESC:TEXT") <> "U"   //SINIEF 25/12, efeitos a partir de 20.12.12 
						If oNF:_INFNFE:_VERSAO:TEXT >= "3.10" .and. &("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_CST:TEXT") <> "40"
							If AllTrim(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_motDesICMS:TEXT")) == "7" .And. &("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_CST:TEXT") == "30"
								nValICM  := 0
							Else
								nValICM  := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_vICMSDESON:TEXT")) 
							EndIf
						Elseif &("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_CST:TEXT") <> "40"
							If AllTrim(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_motDesICMS:TEXT")) == "7" .And. &("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_CST:TEXT") == "30"
								nValICM  := 0
							Else
								nValICM  := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_vICMS:TEXT"))
							EndIf
						EndIf
					EndIf
					cSitTrib := &("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_ORIG:TEXT")
					cSitTrib += &("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_CST:TEXT")
					If Type("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_VBCST:TEXT")<>"U" .And. Type("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_vICMSST:TEXT")<>"U"
						nBaseICMST := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_VBCST:TEXT"))
						nValICMST  := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_vICMSST:TEXT"))
					EndIf
				EndIf												
			Next nY			
		
			//Tratamento para o ICMS para optantes pelo Simples Nacional
			If Type("oEmitente:_CRT") <> "U" .And. oEmitente:_CRT:TEXT == "1"
				nLenSit := Len(aSitSN)
				For nY := 1 To nLenSit
					nPrivate2 := nY
					If Type("oImposto:_Imposto:_ICMS:_ICMSSN"+aSitSN[nPrivate2])<>"U"
						If Type("oImposto:_Imposto:_ICMS:_ICMSSN"+aSitSN[nPrivate2]+":_VBC:TEXT")<>"U"
							nBaseICM := Val(&("oImposto:_Imposto:_ICMS:_ICMSSN"+aSitSN[nY]+":_VBC:TEXT"))
							nValICM  := Val(&("oImposto:_Imposto:_ICMS:_ICMSSN"+aSitSN[nY]+":_vICMS:TEXT"))
							nPICM    := Val(&("oImposto:_Imposto:_ICMS:_ICMSSN"+aSitSN[nY]+":_PICMS:TEXT"))                   
						EndIf
						cSitTrib := &("oImposto:_Imposto:_ICMS:_ICMSSN"+aSitSN[nY]+":_ORIG:TEXT")
						cSitTrib += &("oImposto:_Imposto:_ICMS:_ICMSSN"+aSitSN[nY]+":_CSOSN:TEXT")				
					EndIf
				Next nY	
			EndIf
		EndIf
		If Type("oImposto:_Imposto:_IPI")<>"U"
			If Type("oImposto:_Imposto:_IPI:_IPITrib:_vIPI:TEXT")<>"U"
				nValIPI := Val(oImposto:_Imposto:_IPI:_IPITrib:_vIPI:TEXT)
			EndIf
			If Type("oImposto:_Imposto:_IPI:_IPITrib:_pIPI:TEXT")<>"U"
				nPIPI   := Val(oImposto:_Imposto:_IPI:_IPITrib:_pIPI:TEXT)
			EndIf
		EndIf
	EndIf
    
	nMaxCod := MaxCod(oDet[nX]:_Prod:_cProd:TEXT, 40)
	
	// Tratamento para quebrar os digitos dos valores
	aAux := {}
	AADD(aAux, AllTrim(TransForm(nQtd,TM(nQtd,TamSX3("D2_QUANT")[1],TamSX3("D2_QUANT")[2]))))
	AADD(aAux, AllTrim(TransForm(nVUnit,TM(nVUnit,TamSX3("D2_PRCVEN")[1],TamSX3("D2_PRCVEN")[2]))))
	AADD(aAux, AllTrim(TransForm(nVTotal,TM(nVTotal,TamSX3("D2_TOTAL")[1],TamSX3("D2_TOTAL")[2]))))
	AADD(aAux, AllTrim(TransForm(nDesc,TM(nDesc,TamSX3("D2_DESCON")[1],TamSX3("D2_DESCON")[2]))))
	AADD(aAux, AllTrim(TransForm(nVUniLiq,TM(nVUniLiq,TamSX3("D2_PRCVEN")[1],4))))
	AADD(aAux, AllTrim(TransForm(nVTotLiq,TM(nVTotLiq,TamSX3("D2_TOTAL")[1],TamSX3("D2_TOTAL")[2]))))
	AADD(aAux, AllTrim(TransForm(nBaseICM,TM(nBaseICM,TamSX3("D2_BASEICM")[1],TamSX3("D2_BASEICM")[2]))))
	AADD(aAux, AllTrim(TransForm(nBaseICMST,TM(nBaseICMST,TamSX3("D2_BASEICM")[1],TamSX3("D2_BASEICM")[2]))))
	AADD(aAux, AllTrim(TransForm(nValICM,TM(nValICM,TamSX3("D2_VALICM")[1],TamSX3("D2_VALICM")[2]))))
	AADD(aAux, AllTrim(TransForm(nValICMST,TM(nValICMST,TamSX3("D2_VALICM")[1],TamSX3("D2_VALICM")[2]))))
	AADD(aAux, AllTrim(TransForm(nValIPI,TM(nValIPI,TamSX3("D2_VALIPI")[1],TamSX3("D2_BASEIPI")[2]))))
	
	aadd(aItens,{;
		SubStr(oDet[nX]:_Prod:_cProd:TEXT,1,nMaxCod),;
		SubStr(NoChar(oDet[nX]:_Prod:_xProd:TEXT,lConverte),1,nMaxDes),;
		IIF(Type("oDet[nPrivate]:_Prod:_NCM")=="U","",oDet[nX]:_Prod:_NCM:TEXT),;
		cSitTrib,;
		oDet[nX]:_Prod:_CFOP:TEXT,;
		oDet[nX]:_Prod:_utrib:TEXT,;
		SubStr(aAux[1], 1, PosQuebrVal(aAux[1])),;
		SubStr(aAux[2], 1, PosQuebrVal(aAux[2])),;
		SubStr(aAux[3], 1, PosQuebrVal(aAux[3])),;
		SubStr(aAux[4], 1, PosQuebrVal(aAux[4])),;
		SubStr(aAux[5], 1, PosQuebrVal(aAux[5])),;
		SubStr(aAux[6], 1, PosQuebrVal(aAux[6])),;
		SubStr(aAux[7], 1, PosQuebrVal(aAux[7])),;
		SubStr(aAux[8], 1, PosQuebrVal(aAux[8])),;
		SubStr(aAux[9], 1, PosQuebrVal(aAux[9])),;
		SubStr(aAux[10], 1, PosQuebrVal(aAux[10])),;
		SubStr(aAux[11], 1, PosQuebrVal(aAux[11])),;
		AllTrim(TransForm(nPICM,"@r 99.99%")),;
		AllTrim(TransForm(nPIPI,"@r 99.99%"));
	})

	If lUf_MG
		aadd(aItensAux,{;
			SubStr(oDet[nX]:_Prod:_cProd:TEXT,1,nMaxCod),;
			SubStr(NoChar(oDet[nX]:_Prod:_xProd:TEXT,lConverte),1,nMaxDes),;
			IIF(Type("oDet[nPrivate]:_Prod:_NCM")=="U","",oDet[nX]:_Prod:_NCM:TEXT),;
			cSitTrib,;
			oDet[nX]:_Prod:_CFOP:TEXT,;
			oDet[nX]:_Prod:_utrib:TEXT,;
			SubStr(aAux[1], 1, PosQuebrVal(aAux[1])),;
			SubStr(aAux[2], 1, PosQuebrVal(aAux[2])),;
			SubStr(aAux[3], 1, PosQuebrVal(aAux[3])),;
			SubStr(aAux[4], 1, PosQuebrVal(aAux[4])),;
			SubStr(aAux[5], 1, PosQuebrVal(aAux[5])),;
			SubStr(aAux[6], 1, PosQuebrVal(aAux[6])),;
			SubStr(aAux[7], 1, PosQuebrVal(aAux[7])),;
			SubStr(aAux[8], 1, PosQuebrVal(aAux[8])),;
			SubStr(aAux[9], 1, PosQuebrVal(aAux[9])),;
			SubStr(aAux[10], 1, PosQuebrVal(aAux[10])),;
			SubStr(aAux[11], 1, PosQuebrVal(aAux[11])),;
			AllTrim(TransForm(nPICM,"@r 99.99%")),;
			AllTrim(TransForm(nPIPI,"@r 99.99%")),;
			StrZero( ++nSequencia, 4 ),;
			nVTotal;
		})
	Endif
	// Tramento quando houver diferen�a entre as unidades uCom e uTrib ( SEFAZ MT )
	If ( oDet[nX]:_Prod:_uTrib:TEXT <> oDet[nX]:_Prod:_uCom:TEXT )

	    lPontilhado := IIf( nLenDet > 1, .T., lPontilhado )
    	
		cUnCom		:= oDet[nX]:_Prod:_uCom:TEXT
		nQtdCom		:= Val(oDet[nX]:_Prod:_qCom:TEXT)
	   	nVUnitCom	:= Val(oDet[nX]:_Prod:_vUnCom:TEXT)

		aAuxCom := {}
		AADD(aAuxCom, AllTrim(TransForm(nQtdCom,TM(nQtdCom,TamSX3("D2_QUANT")[1],TamSX3("D2_QUANT")[2]))))
		AADD(aAuxCom, AllTrim(TransForm(nVUnitCom,TM(nVUnitCom,TamSX3("D2_PRCVEN")[1],TamSX3("D2_PRCVEN")[2]))))
   	
		aadd(aItens,{;
			"",;
			"",;
			"",;
			"",;
			"",;
			cUnCom,;
			SubStr(aAuxCom[1], 1, PosQuebrVal(aAuxCom[1])),;
			SubStr(aAuxCom[2], 1, PosQuebrVal(aAuxCom[2])),;
			"",;
			"",;
			"",;
			"",;
			"",;
			"",;
			"",;
			"",;
			"",;									
			"",;
			"";
		})

	Endif
	
	cAuxItem := AllTrim(SubStr(oDet[nX]:_Prod:_cProd:TEXT,nMaxCod+1))
	cAux     := AllTrim(SubStr(NoChar(oDet[nX]:_Prod:_xProd:TEXT,lConverte),(nMaxDes + 1)))	
	aAux[1]  := SubStr(aAux[1], PosQuebrVal(aAux[1]) + 1)
	aAux[2]  := SubStr(aAux[2], PosQuebrVal(aAux[2]) + 1)
	aAux[3]  := SubStr(aAux[3], PosQuebrVal(aAux[3]) + 1)
	aAux[4]  := SubStr(aAux[4], PosQuebrVal(aAux[4]) + 1)
	aAux[5]  := SubStr(aAux[5], PosQuebrVal(aAux[5]) + 1)
	aAux[6]  := SubStr(aAux[6], PosQuebrVal(aAux[6]) + 1)
	aAux[7]  := SubStr(aAux[7], PosQuebrVal(aAux[7]) + 1)
	aAux[8]  := SubStr(aAux[8], PosQuebrVal(aAux[8]) + 1)
	aAux[9]  := SubStr(aAux[9], PosQuebrVal(aAux[9]) + 1)
	aAux[10] := SubStr(aAux[10], PosQuebrVal(aAux[10]) + 1)
	aAux[11] := SubStr(aAux[11], PosQuebrVal(aAux[11]) + 1)
	
	While !Empty(cAux) .Or. !Empty(cAuxItem) .Or. !Empty(aAux[1]) .Or. !Empty(aAux[2]) .Or. !Empty(aAux[3]) .Or. !Empty(aAux[4]);
	       .Or. !Empty(aAux[5]) .Or. !Empty(aAux[6]) .Or. !Empty(aAux[7]) .Or. !Empty(aAux[8]) .Or. !Empty(aAux[9]) .Or. !Empty(aAux[10]);
	       .Or. !Empty(aAux[11])
		nMaxCod := MaxCod(cAuxItem, 40)
		
		aadd(aItens,{;
			SubStr(cAuxItem,1,nMaxCod),;
			SubStr(cAux,1,nMaxDes),;
			"",;
			"",;
			"",;
			"",;
			SubStr(aAux[1], 1, PosQuebrVal(aAux[1])),;
			SubStr(aAux[2], 1, PosQuebrVal(aAux[2])),;
			SubStr(aAux[3], 1, PosQuebrVal(aAux[3])),;
			SubStr(aAux[4], 1, PosQuebrVal(aAux[4])),;
			SubStr(aAux[5], 1, PosQuebrVal(aAux[5])),;
			SubStr(aAux[6], 1, PosQuebrVal(aAux[6])),;
			SubStr(aAux[7], 1, PosQuebrVal(aAux[7])),;
			SubStr(aAux[8], 1, PosQuebrVal(aAux[8])),;
			SubStr(aAux[9], 1, PosQuebrVal(aAux[9])),;
			SubStr(aAux[10], 1, PosQuebrVal(aAux[10])),;
			SubStr(aAux[11], 1, PosQuebrVal(aAux[11])),;		
			"",;
			"";
		})

		If lUf_MG
			aadd(aItensAux,{;
				SubStr(cAuxItem,1,nMaxCod),;
				SubStr(cAux,1,nMaxDes),;
				"",;
				"",;
				oDet[nX]:_Prod:_CFOP:TEXT,;
				"",;
				SubStr(aAux[1], 1, PosQuebrVal(aAux[1])),;
				SubStr(aAux[2], 1, PosQuebrVal(aAux[2])),;
				SubStr(aAux[3], 1, PosQuebrVal(aAux[3])),;
				SubStr(aAux[4], 1, PosQuebrVal(aAux[4])),;
				SubStr(aAux[5], 1, PosQuebrVal(aAux[5])),;
				SubStr(aAux[6], 1, PosQuebrVal(aAux[6])),;
				SubStr(aAux[7], 1, PosQuebrVal(aAux[7])),;
				SubStr(aAux[8], 1, PosQuebrVal(aAux[8])),;
				SubStr(aAux[9], 1, PosQuebrVal(aAux[9])),;
				SubStr(aAux[10], 1, PosQuebrVal(aAux[10])),;
				SubStr(aAux[11], 1, PosQuebrVal(aAux[11])),;		
				"",;
				"",;
				StrZero( ++nSequencia, 4 ),;
				0;
			})
		Endif
		
		cAux        := SubStr(cAux,(nMaxDes + 1)) 
		cAuxItem    := SubStr(cAuxItem,nMaxCod+1)
		aAux[1]     := SubStr(aAux[1], PosQuebrVal(aAux[1]) + 1)
		aAux[2]     := SubStr(aAux[2], PosQuebrVal(aAux[2]) + 1)
		aAux[3]     := SubStr(aAux[3], PosQuebrVal(aAux[3]) + 1)
		aAux[4]     := SubStr(aAux[4], PosQuebrVal(aAux[4]) + 1)
		aAux[5]     := SubStr(aAux[5], PosQuebrVal(aAux[5]) + 1)
		aAux[6]     := SubStr(aAux[6], PosQuebrVal(aAux[6]) + 1)
		aAux[7]     := SubStr(aAux[7], PosQuebrVal(aAux[7]) + 1)
		aAux[8]     := SubStr(aAux[8], PosQuebrVal(aAux[8]) + 1)
		aAux[9]     := SubStr(aAux[9], PosQuebrVal(aAux[9]) + 1)
		aAux[10]    := SubStr(aAux[10], PosQuebrVal(aAux[10]) + 1)
		aAux[11]    := SubStr(aAux[11], PosQuebrVal(aAux[11]) + 1)
	    lPontilhado := .T.	
	    
	EndDo
	
	If (Type("oNf:_infnfe:_det[nPrivate]:_Infadprod:TEXT") <> "U" .Or. Type("oNf:_infnfe:_det:_Infadprod:TEXT") <> "U") .And. ( lImpAnfav  .Or. lImpInfAd )
		If at("<", AllTrim(SubStr(oDet[nX]:_Infadprod:TEXT,1))) <> 0
			cAux := stripTags(AllTrim(SubStr(oDet[nX]:_Infadprod:TEXT,1)), .T.) + " "
			cAux += stripTags(AllTrim(SubStr(oDet[nX]:_Infadprod:TEXT,1)), .F.)
		else
			cAux := stripTags(AllTrim(SubStr(oDet[nX]:_Infadprod:TEXT,1)), .T.)
		endIf

		
		While !Empty(cAux)
			aadd(aItens,{;
				"",;
				SubStr(cAux, 1, nMaxDes),;
				"",;
				"",;
				"",;
				"",;
				"",;
				"",;
				"",;
				"",;
				"",;
				"",;
				"",;
				"",;
				"",;
				"",;
				"",;
				"",;
				"";
			})

			If lUf_MG
				aadd(aItensAux,{;
					"",;
					SubStr(cAux, 1, nMaxDes),;
					"",;
					"",;
					oDet[nX]:_Prod:_CFOP:TEXT,;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					StrZero( ++nSequencia, 4 ),;
					0;
				})
			Endif
			cAux 		:= SubStr(cAux,(nMaxDes + 1))
			lPontilhado := .T.	
		EndDo
	EndIf

	If lPontilhado
		aadd(aItens,{;
			"-",;
			"-",;
			"-",;
			"-",;
			"-",;
			"-",;
			"-",;
			"-",;
			"-",;
			"-",;
			"-",;
			"-",;
			"-",;
			"-",;
			"-",;
			"-",;
			"-",;
			"-",;
			"-"; 
		})
		If lUf_MG
			aadd(aItensAux,{;
				"-",;
				"-",;
				"-",;
				"-",;
				oDet[nX]:_Prod:_CFOP:TEXT,;
				"-",;
				"-",;
				"-",;
				"-",;
				"-",;
				"-",;
				"-",;
				"-",;
				"-",;
				"-",;
				"-",;
				"-",;
				"-",;
				"-",; 
				StrZero( ++nSequencia, 4 ),;
				0;
			})		
		Endif
	EndIf

Next nZ

//----------------------------------------------------------------------------------
// Tratamento somente para o estado de MG, para totalizar por CFOP conforme RICMS-MG
//----------------------------------------------------------------------------------
If lUf_MG  

	If 	Len( aItensAux ) > 0

		aItensAux	:= aSort( aItensAux,,, { |x,y| x[5]+x[20] < y[5]+y[20] } )

		nSubTotal	:= 0

		aItens		:= {}
	  
		cCfop		:= aItensAux[1,5]
		cCfopAnt	:= aItensAux[1,5]			
		
		For nX := 1 To Len( aItensAux )

			aArray		:= ARRAY(19)
			
			aArray[01]	:= aItensAux[nX,01]
			aArray[02]	:= aItensAux[nX,02]
			aArray[03]	:= aItensAux[nX,03]
			aArray[04]	:= aItensAux[nX,04]
			
			If Empty( aItensAux[nX,03] ) .Or. aItensAux[nX,03] == "-"
				aArray[05] := ""
			Else
				aArray[05] := aItensAux[nX,05]
			Endif

			aArray[06]	:= aItensAux[nX,06]
			aArray[07]	:= aItensAux[nX,07]
			aArray[08]	:= aItensAux[nX,08]
			aArray[09]	:= aItensAux[nX,09]
			aArray[10]	:= aItensAux[nX,10]
			aArray[11]	:= aItensAux[nX,11]
			aArray[12]	:= aItensAux[nX,12]
			aArray[13]	:= aItensAux[nX,13]
			aArray[14]	:= aItensAux[nX,14]
			aArray[15]	:= aItensAux[nX,15]
			aArray[16]	:= aItensAux[nX,16]
			aArray[17]	:= aItensAux[nX,17]
			aArray[18]	:= aItensAux[nX,18]
			aArray[19]	:= aItensAux[nX,19]

			If aItensAux[nX,5] == cCfop

				aadd( aItens, {; 
					aArray[01],;
					aArray[02],;
					aArray[03],;
					aArray[04],;
					aArray[05],;
					aArray[06],;
					aArray[07],;
					aArray[08],;
					aArray[09],;
					aArray[10],;
					aArray[11],;
					aArray[12],;
					aArray[13],;
					aArray[14],;
					aArray[15],;
					aArray[16],;
					aArray[17],;
					aArray[18],;
					aArray[19];
				} )

				nSubTotal += aItensAux[nX,21]

			Else
				
				aadd(aItens,{;
					"",;
					"SUB-TOTAL",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					AllTrim(TransForm(nSubTotal,TM(nSubTotal,TamSX3("D2_TOTAL")[1],TamSX3("D2_TOTAL")[2]))),;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"";
				})

				aadd(aItens,{;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"";
				})
				
				cCfop 		:= aItensAux[nX,05]
				nSubTotal 	:= aItensAux[nX,21]

				aadd( aItens, {; 
					aArray[01],;
					aArray[02],;
					aArray[03],;
					aArray[04],;
					aArray[05],;
					aArray[06],;
					aArray[07],;
					aArray[08],;
					aArray[09],;
					aArray[10],;
					aArray[11],;
					aArray[12],;
					aArray[13],;
					aArray[14],;
					aArray[15],;
					aArray[16],;
					aArray[17],;
					aArray[18],;
					aArray[19];
				} )

			Endif
			
		Next nX
		
		If cCfopAnt <> cCfop .And. nSubTotal > 0

			aadd(aItens,{;
				"",;
				"SUB-TOTAL",;
				"",;
				"",;
				"",;
				"",;
				"",;
				"",;
				AllTrim(TransForm(nSubTotal,TM(nSubTotal,TamSX3("D2_TOTAL")[1],TamSX3("D2_TOTAL")[2]))),;
				"",;
				"",;
				"",;
				"",;
				"",;
				"",;
				"",;
				"",;
				"",;
				"";
			})		
		
		Endif
		
	Endif
	
Endif

//������������������������������������������������������������������������Ŀ
//�Quadro ISSQN                                                            �
//��������������������������������������������������������������������������
aISSQN := {"","","",""}
If Type("oEmitente:_IM:TEXT")<>"U"
	aISSQN[1] := oEmitente:_IM:TEXT
EndIf
If Type("oTotal:_ISSQNtot")<>"U"
	aISSQN[2] := Transform(Val(oTotal:_ISSQNtot:_vServ:TEXT),"@e 999,999,999.99")
	aISSQN[3] := Transform(Val(oTotal:_ISSQNtot:_vBC:TEXT),"@e 999,999,999.99")
	If Type("oTotal:_ISSQNtot:_vISS:TEXT") <> "U"
		aISSQN[4] := Transform(Val(oTotal:_ISSQNtot:_vISS:TEXT),"@e 999,999,999.99")
	EndIf
EndIf

If Type("oIdent:_DHCONT:TEXT")<>"U"
	cDhCont:= oIdent:_DHCONT:TEXT
EndIf
If Type("oIdent:_XJUST:TEXT")<>"U"
	cXJust:=oIdent:_XJUST:TEXT
EndIf
//������������������������������������������������������������������������Ŀ
//�Quadro de informacoes complementares                                    �
//��������������������������������������������������������������������������
aMensagem := {}
If Type("oIdent:_tpAmb:TEXT")<>"U" .And. oIdent:_tpAmb:TEXT=="2"
	cAux := "DANFE emitida no ambiente de homologa��o - SEM VALOR FISCAL"
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
EndIf 

If Type("oNF:_InfNfe:_infAdic:_infAdFisco:TEXT")<>"U"
	cAux := oNF:_InfNfe:_infAdic:_infAdFisco:TEXT
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
EndIf

If !Empty(cCodAutSef) .AND. oIdent:_tpEmis:TEXT<>"4"
	cAux := "Protocolo: "+cCodAutSef
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
ElseIf !Empty(cCodAutSef) .AND. oIdent:_tpEmis:TEXT=="4" .AND. cModalidade $ "1"
	cAux := "Protocolo: "+cCodAutSef
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
	cAux := "DANFE emitida anteriormente em conting�ncia DPEC"
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
EndIf

If !Empty(cCodAutDPEC) .And. oIdent:_tpEmis:TEXT=="4"
	cAux := "N�mero de Registro DPEC: "+cCodAutDPEC
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
EndIf

If (Type("oIdent:_tpEmis:TEXT")<>"U" .And. !oIdent:_tpEmis:TEXT$"1,4")
	cAux := "DANFE emitida em conting�ncia"
	If !Empty(cXJust) .and. !Empty(cDhCont) .and. oIdent:_tpEmis:TEXT$"6,7"// SVC-AN e SVC-RS Deve ser impresso o xjust e dhcont
		cAux += " Motivo da ado��o da conting�ncia: "+cXJust+ " Data e hora de in�cio de utiliza��o: "+cDhCont
	EndIf
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
ElseIf (!Empty(cModalidade) .And. !cModalidade $ "1,4,5") .And. Empty(cCodAutSef)
	cAux := "DANFE emitida em conting�ncia devido a problemas t�cnicos - ser� necess�ria a substitui��o."
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
ElseIf (!Empty(cModalidade) .And. cModalidade $ "5" .And. oIdent:_tpEmis:TEXT=="4")
	cAux := "DANFE impresso em conting�ncia"
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
	cAux := "DPEC regularmento recebido pela Receita Federal do Brasil."
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
ElseIf (Type("oIdent:_tpEmis:TEXT")<>"U" .And. oIdent:_tpEmis:TEXT$"5")
	cAux := "DANFE emitida em conting�ncia FS-DA"
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
EndIf

If Type("oNF:_InfNfe:_infAdic:_infCpl:TEXT")<>"U"
	If at("<", oNF:_InfNfe:_infAdic:_InfCpl:TEXT) <> 0
		cAux := stripTags(oNF:_InfNfe:_infAdic:_InfCpl:TEXT, .T.) + " "
		cAux += stripTags(oNF:_InfNfe:_infAdic:_InfCpl:TEXT, .F.)
	else
		cAux := stripTags(oNF:_InfNfe:_infAdic:_InfCpl:TEXT, .T.)
	endIf
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
EndIf
/*
dbSelectArea("SF1")
dbSetOrder(1)
If MsSeek(xFilial("SF1")+aNota[5]+aNota[4]+aNota[6]+aNota[7]) .And. SF1->(FieldPos("F1_FIMP"))<>0
	If SF1->F1_TIPO == "D"
		If Type("oNF:_InfNfe:_Total:_icmsTot:_VIPI:TEXT")<>"U"
			cAux := "Valor do Ipi : " + oNF:_InfNfe:_Total:_icmsTot:_VIPI:TEXT
			While !Empty(cAux)
				aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
				cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
			EndDo
		EndIf      
	EndIf
	MsUnlock()
	DbSkip()
EndIf
*/
If lArt274SP .And. SuperGetMv("MV_ESTADO")$"SP"
	If Type("oNF:_INFNFE:_TOTAL:_ICMSTOT:_VBCST:TEXT") <> "U"
		If oNF:_INFNFE:_TOTAL:_ICMSTOT:_VBCST:TEXT <> "0"
			cAux := "Imposto recolhido por Substitui��o - Art 274 do RICMS"
			If oNF:_INFNFE:_DEST:_ENDERDEST:_UF:TEXT == "SP"
				cAux += ": "
				aLote := RastroNFOr(SD2->D2_DOC,SD2->D2_SERIE,SD2->D2_CLIENTE,SD2->D2_LOJA)
				For nX := 1 To Len(aLote)
					nBaseICM := aLote[nX][33]
					nValICM  := aLote[nX][38]
					cAux += Alltrim(aLote[nX][3]) + " - BCST: " + AllTrim(TransForm(nBaseICM,TM(nBaseICM,TamSX3("D1_BRICMS")[1],TamSX3("D1_BRICMS")[2]))) + " e ICMSST: " + ;
									AllTrim(TransForm(nValICM,TM(nValICM,TamSX3("D1_ICMSRET")[1],TamSX3("D1_ICMSRET")[2]))) + "/ " 
				Next nX                      
			Endif
			While !Empty(cAux)
				aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
				cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
			EndDo
		Endif
	Endif
Endif 

                                                           
If MV_PAR04 == 2
	//impressao do valor do desconto calculdo conforme decreto 43.080/02 RICMS-MG
	nRecSF3 := SF3->(Recno())
	SF3->(dbSetOrder(4))
	SF3->(MsSeek(xFilial("SF3")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE))
	While !SF3->(Eof()) .And. SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE == SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE
	    If SF3->(FieldPos("F3_DS43080"))<>0 .And. SF3->F3_DS43080 > 0
			cAux := "Base de calc.reduzida conf.Art.43, Anexo IV, Parte 1, Item 3 do RICMS-MG. Valor da deducao ICMS R$ " 
			cAux += Alltrim(Transform(SF3->F3_DS43080,"@e 9,999,999,999,999.99")) + " ref.reducao de base de calculo"  
			While !Empty(cAux)
				aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
				cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
			EndDo
	    EndIf
	    SF3->(dbSkip())
	EndDo
	SF3->(dbGoTo(nRecSF3))
ElseIf MV_PAR04 == 1
    //impressao do valor do desconto calculdo conforme decreto 43.080/02 RICMS-MG
	dbSelectArea("SF1")
	dbSetOrder(1)
	IF MsSeek(xFilial("SF1")+aNota[5]+aNota[4]+aNota[6]+aNota[7])
		dbSelectArea("SF3")
		dbSetOrder(4)
		If MsSeek(xFilial("SF3")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE)	                                                                                                                                      		
			If SF3->(FieldPos("F3_DS43080"))<>0 .And. SF3->F3_DS43080 > 0
				cAux := "Base de calc.reduzida conf.Art.43, Anexo IV, Parte 1, Item 3 do RICMS-MG. Valor da deducao ICMS R$ " 
				cAux += Alltrim(Transform(SF3->F3_DS43080,"@ze 9,999,999,999,999.99")) + " ref.reducao de base de calculo"  
				While !Empty(cAux)
					aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
					cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
				EndDo                                                                                                                                                               
		    EndIf                                                                                                                                  	
		EndIf  
	EndIf
EndIF

If Type("oNF:_INFNFE:_IDE:_NFREF")<>"U"
	If Type("oNF:_INFNFE:_IDE:_NFREF") == "A"
		aInfNf := oNF:_INFNFE:_IDE:_NFREF
	Else
		aInfNf := {oNF:_INFNFE:_IDE:_NFREF}
	EndIf
	
	For nX := 1 to Len(aMensagem)
		If "ORIGINAL"$ Upper(aMensagem[nX])
			lNFori2 := .F.
		EndIf
	Next Nx
	
	cAux1 := ""
	cAux2 := ""
	For Nx := 1 to Len(aInfNf)
		If Type("aInfNf["+Str(nX)+"]:_REFNFE:TEXT")<>"U" .And. !AllTrim(aInfNf[nx]:_REFNFE:TEXT)$cAux1
			If !"CHAVE"$Upper(cAux1)
				If "65" $ substr (aInfNf[nx]:_REFNFE:TEXT,21,2)
					cAux1 += "Chave de acesso da NFC-E referenciada: "
				Else
				cAux1 += "Chave de acesso da NF-E referenciada: "
				Endif
			EndIf
			cAux1 += aInfNf[nx]:_REFNFE:TEXT+","
		ElseIf Type("aInfNf["+Str(nX)+"]:_REFNF:_NNF:TEXT")<>"U" .And. !AllTrim(aInfNf[nx]:_REFNF:_NNF:TEXT)$cAux2 .And. lNFori2 
			If !"ORIGINAL"$Upper(cAux2)
				cAux2 += " Numero da nota original: "
			EndIf
			cAux2 += aInfNf[nx]:_REFNF:_NNF:TEXT+","
		EndIf
	Next
	
	cAux	:=	""
	If !Empty(cAux1)
		cAux1	:=	Left(cAux1,Len(cAux1)-1)
		cAux 	+= cAux1
	EndIf
	If !Empty(cAux2)
		cAux2	:=	Left(cAux2,Len(cAux2)-1)
		cAux 	+= 	Iif(!Empty(cAux),CRLF,"")+cAux2
	EndIf
	
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
EndIf

//������������������������������������������������������������������������Ŀ
//�Quadro "RESERVADO AO FISCO"                                             �
//��������������������������������������������������������������������������

aResFisco := {}
nBaseIcm  := 0

If GetNewPar("MV_BCREFIS",.F.) .And. SuperGetMv("MV_ESTADO")$"PR"
	If Val(&("oTotal:_ICMSTOT:_VBCST:TEXT")) <> 0
		cAux := "Substitui��o Tribut�ria: Art. 471, II e �1� do RICMS/PR: "
   		nLenDet := Len(oDet)
   		For nX := 1 To nLenDet
	   		oImposto := oDet[nX]
	   		If Type("oImposto:_Imposto")<>"U"
		 		If Type("oImposto:_Imposto:_ICMS")<>"U"
		 			nLenSit := Len(aSitTrib)
		 			For nY := 1 To nLenSit
		 				nPrivate2 := nY
		 				If Type("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2])<>"U"
		 					If Type("oImposto:_IMPOSTO:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_VBCST:TEXT")<>"U"
		 		   				nBaseIcm := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_VBCST:TEXT"))
		 						cAux +=  oDet[nX]:_PROD:_CPROD:TEXT + ": BCICMS-ST R$" + AllTrim(TransForm(nBaseICM,TM(nBaseICM,TamSX3("D2_BASEICM")[1],TamSX3("D2_BASEICM")[2]))) + " / "	
   		 	  				Endif
   		 	 			Endif
   					Next nY
   	   			Endif
   	 		Endif
   	  	Next nX
	Endif
	While !Empty(cAux)   
		aadd(aResFisco,SubStr(cAux,1,64))
  		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENL) > 1, 63, MAXMENL) +2)
   	EndDo	
Endif  
        
//������������������������������������������������������������������������Ŀ
//�Calculo do numero de folhas                                             �
//��������������������������������������������������������������������������
nFolhas	  := 1
nLenItens := Len(aItens) - MAXITEM // Todos os produtos/servi�os excluindo a primeira p�gina
nMsgCompl := Len(aMensagem) - MAXMSG // Todas as mensagens complementares excluindo a primeira p�gina
lFlag     := .T.
While lFlag
	// Caso existam produtos/servi�os e mensagens complementares a serem escritas
	If nLenItens > 0 .And. nMsgCompl > 0
		nFolhas++
		nLenItens -= MAXITEMP4
		nMsgCompl := 0
	// Caso existam apenas mensagens complementares a serem escritas
	ElseIf nLenItens <= 0 .And. nMsgCompl > 0
		nFolhas++
		nMsgCompl := 0
	// Caso existam apenas produtos/servi�os a serem escritos
	ElseIf nLenItens > 0 .And. nMsgCompl <= 0
		nFolhas++
		nLenItens -= MAXITEMP2
	// Se n�o tiver mais nada a ser escrito fecha a contagem
	Else
		lFlag := .F.
	EndIf
EndDo

//������������������������������������������������������������������������Ŀ
//�Inicializacao do objeto grafico                                         �
//��������������������������������������������������������������������������
If oDanfe == Nil
	
	lPreview := .T.
	oDanfe 	:= FWMSPrinter():New("DANFE", IMP_SPOOL)
	oDanfe:SetLandscape()
	oDanfe:Setup()
EndIf

//������������������������������������������������������������������������Ŀ
//�Preenchimento do Array de UF                                            �
//��������������������������������������������������������������������������
aadd(aUF,{"RO","11"})
aadd(aUF,{"AC","12"})
aadd(aUF,{"AM","13"})
aadd(aUF,{"RR","14"})
aadd(aUF,{"PA","15"})
aadd(aUF,{"AP","16"})
aadd(aUF,{"TO","17"})
aadd(aUF,{"MA","21"})
aadd(aUF,{"PI","22"})
aadd(aUF,{"CE","23"})
aadd(aUF,{"RN","24"})
aadd(aUF,{"PB","25"})
aadd(aUF,{"PE","26"})
aadd(aUF,{"AL","27"})
aadd(aUF,{"MG","31"})
aadd(aUF,{"ES","32"})
aadd(aUF,{"RJ","33"})
aadd(aUF,{"SP","35"})
aadd(aUF,{"PR","41"})
aadd(aUF,{"SC","42"})
aadd(aUF,{"RS","43"})
aadd(aUF,{"MS","50"})
aadd(aUF,{"MT","51"})
aadd(aUF,{"GO","52"})
aadd(aUF,{"DF","53"})
aadd(aUF,{"SE","28"})
aadd(aUF,{"BA","29"})
aadd(aUF,{"EX","99"})


//������������������������������������������������������������������������Ŀ
//�Inicializacao da pagina do objeto grafico                               �
//��������������������������������������������������������������������������
oDanfe:StartPage()
nHPage := oDanfe:nHorzRes()
nHPage *= (300/PixelX)
nHPage -= HMARGEM
nVPage := oDanfe:nVertRes()
nVPage *= (300/PixelY)
nVPage -= VBOX
nLine  := -42  
nBaseTxt := 180
nBaseCol := 70
/* Comando Say Utilizados
Say( nRow, nCol, cText, oFont, nWidth, cClrText, nAngle )
*/

DanfeCab(oDanfe,nPosV,oNFe,oIdent,oEmitente,nFolha,nFolhas,cCodAutSef,oNfeDPEC,cCodAutDPEC,cDtHrRecCab,dDtReceb,@nLine,@nBaseCol,@nBaseTxt,aUf)

//������������������������������������������������������������������������Ŀ
//�Quadro destinat�rio/remetente                                           �
//��������������������������������������������������������������������������
Do Case
	Case Type("oDestino:_CNPJ")=="O"
		cAux := TransForm(oDestino:_CNPJ:TEXT,"@r 99.999.999/9999-99")
	Case Type("oDestino:_CPF")=="O"
		cAux := TransForm(oDestino:_CPF:TEXT,"@r 999.999.999-99")
	OtherWise
		cAux := Space(14)
EndCase

nLine -= 8
//oDanfe:Box(nLine+197,nBaseCol,nLine+270,nBaseCol+30)
oDanfe:FillRect({nLine+198,nBaseCol,nLine+269,nBaseCol+30},oBrush)
oDanfe:Say(nLine+265,nBaseTxt+1,"DESTINATARIO /",oFont08N:oFont, , CLR_WHITE, 270 )
oDanfe:Say(nLine+260,nBaseTxt+11,"REMETENTE"     ,oFont08N:oFont, ,CLR_WHITE , 270 )

nBaseTxt += 30 
//oDanfe:Say(nLine+195,nBaseTxt,"DESTINATARIO/REMETENTE",oFont08N:oFont)
oDanfe:Box(nLine+197,nBaseCol+30,nLine+222,542)
oDanfe:Say(nLine+205,nBaseTxt, "NOME/RAZ�O SOCIAL",oFont08N:oFont)
oDanfe:Say(nLine+215,nBaseTxt,NoChar(oDestino:_XNome:TEXT,lConverte),oFont08:oFont)
oDanfe:Box(nLine+197,542,nLine+222,MAXBOXH-40)
oDanfe:Box(nLine+197.5,542.5,nLine+220.5,MAXBOXH-41.5)//BOX NEGRITO
oDanfe:Say(nLine+205,552,"CNPJ/CPF",oFont08N:oFont)
oDanfe:Say(nLine+215,552,cAux,oFont08:oFont)

oDanfe:Box(nLine+222,nBaseCol+30,nLine+247,402)
oDanfe:Say(nLine+230,nBaseTxt,"ENDERE�O",oFont08N:oFont)
oDanfe:Say(nLine+240,nBaseTxt,aDest[01],oFont08:oFont)
oDanfe:Box(nLine+222,402,nLine+247,602)
oDanfe:Say(nLine+230,412,"BAIRRO/DISTRITO",oFont08N:oFont)
oDanfe:Say(nLine+240,412,aDest[02],oFont08:oFont)
oDanfe:Box(nLine+222,602,nLine+247,MAXBOXH-40)
oDanfe:Say(nLine+230,612,"CEP",oFont08N:oFont)
oDanfe:Say(nLine+240,612,aDest[03],oFont08:oFont)

oDanfe:Box(nLine+247,nBaseCol+30,nLine+270,302)
oDanfe:Say(nLine+255,nBaseTxt,"MUNICIPIO",oFont08N:oFont)
oDanfe:Say(nLine+265,nBaseTxt,aDest[05],oFont08:oFont)
oDanfe:Box(nLine+247,302,nLine+270,502)
oDanfe:Say(nLine+255,312,"FONE/FAX",oFont08N:oFont)
oDanfe:Say(nLine+265,312,aDest[06],oFont08:oFont)
oDanfe:Box(nLine+247,502,nLine+270,542)
oDanfe:Say(nLine+255,512,"UF",oFont08N:oFont)
oDanfe:Say(nLine+265,512,aDest[07],oFont08:oFont)
oDanfe:Box(nLine+247,542,nLine+270,MAXBOXH-40)
oDanfe:Box(nLine+247.5,542.5,nLine+268.5,MAXBOXH-41.5)//BOX NEGRITO
oDanfe:Say(nLine+255,552,"INSCRI��O ESTADUAL",oFont08N:oFont)
oDanfe:Say(nLine+265,552,aDest[08],oFont08:oFont)

//nBaseTxt := 790 

oDanfe:Box(nLine+197,MAXBOXH-40,nLine+222,MAXBOXH+70)
oDanfe:Say(nLine+205,MAXBOXH-30,"DATA DE EMISS�O",oFont08N:oFont)
oDanfe:Say(nLine+215,MAXBOXH-30,Iif(oNF:_INFNFE:_VERSAO:TEXT >= "3.10",ConvDate(oIdent:_DHEmi:TEXT),ConvDate(oIdent:_DEmi:TEXT)),oFont08:oFont)
oDanfe:Box(nLine+222,MAXBOXH-40,nLine+247,MAXBOXH+70)
oDanfe:Say(nLine+230,MAXBOXH-30,"DATA ENTRADA/SA�DA",oFont08N:oFont)
oDanfe:Say(nLine+240,MAXBOXH-30,Iif( Empty(aDest[4]),"",ConvDate(aDest[4]) ),oFont08:oFont)
oDanfe:Box(nLine+247,MAXBOXH-40,nLine+272,MAXBOXH+70)
oDanfe:Say(nLine+255,MAXBOXH-30,"HORA ENTRADA/SA�DA",oFont08N:oFont)
oDanfe:Say(nLine+265,MAXBOXH-30,aHrEnt[01],oFont08:oFont)



//������������������������������������������������������������������������Ŀ
//�Quadro fatura                                                           �
//��������������������������������������������������������������������������
aAux := {{{},{},{},{},{},{},{},{},{}}}
nY := 0
For nX := 1 To Len(aFaturas)
	nY++
	aadd(Atail(aAux)[nY],aFaturas[nX][1])
	nY++
	aadd(Atail(aAux)[nY],aFaturas[nX][2])
	nY++
	aadd(Atail(aAux)[nY],aFaturas[nX][3])
	nY++
	aadd(Atail(aAux)[nY],aFaturas[nX][4])
	nY++
	aadd(Atail(aAux)[nY],aFaturas[nX][5])
	nY++
	aadd(Atail(aAux)[nY],aFaturas[nX][6])
	nY++
	aadd(Atail(aAux)[nY],aFaturas[nX][7])
	nY++
	aadd(Atail(aAux)[nY],aFaturas[nX][8])
	nY++
	aadd(Atail(aAux)[nY],aFaturas[nX][9])
	If nY >= 9
		nY := 0
	EndIf
Next nX
              
//������������������������������������������������������������������������Ŀ
//�Fatura / Duplicata                                                      �
//��������������������������������������������������������������������������
//nLine -= 3
nLine -= 5
nBaseTxt -= 30 
//oDanfe:Box(nLine+275,nBaseCol,nLine+310,nBaseCol+30)
oDanfe:FillRect({nLine+276,nBaseCol,nLine+309,nBaseCol+30},oBrush)

oDanfe:Say(nLine+305,nBaseTxt+7,"FATURA",oFont08N:oFont, ,CLR_WHITE , 270 )
nBaseTxt += 30 

nPos1Col := 0
nPos2Col := 0
For Nx := 1 to 8
	oDanfe:Box(nLine+275,nBaseCol+30+nPos1Col,nLine+310,nBaseCol+115.1+nPos2Col)
	nPos1Col += 84.1
	nPos2Col += 84.1
Next
//Ultimo Box
oDanfe:Box(nLine+275,nBaseCol+30+nPos1Col,nLine+310,MAXBOXH+70)


nColuna := nBaseCol+36
If Len(aFaturas) >0
	For nY := 1 To 9
		oDanfe:Say(nLine+287,nColuna,aAux[1][ny][1],oFont08:oFont)
		oDanfe:Say(nLine+296,nColuna,aAux[1][ny][2],oFont08:oFont)
		oDanfe:Say(nLine+305,nColuna,aAux[1][ny][3],oFont08:oFont)
		nColuna:= nColuna+84.1
	Next nY
Endif

//nLine -= 15
nLine -= 18
//������������������������������������������������������������������������Ŀ
//�Calculo do imposto                                                      �
//��������������������������������������������������������������������������
nBaseTxt -= 30 
//oDanfe:Box(nLine+328,nBaseCol,nLine+376,nBaseCol+30)
oDanfe:FillRect({nLine+329,nBaseCol,nLine+375,nBaseCol+30},oBrush)
oDanfe:Say(nLine+372,nBaseTxt,"CALCULO",oFont08N:oFont, ,CLR_WHITE , 270 )
oDanfe:Say(nLine+360,nBaseTxt+7,"DO",oFont08N:oFont, , CLR_WHITE, 270 )
oDanfe:Say(nLine+370,nBaseTxt+14,"IMPOSTO",oFont08N:oFont, , CLR_WHITE, 270 )
nBaseTxt += 30 

oDanfe:Box(nLine+328,nBaseCol+30,nLine+353,262)
oDanfe:Say(nLine+336,nBaseTxt,"BASE DE CALCULO DO ICMS",oFont08N:oFont)
If cMVCODREG $ "3" 
	oDanfe:Say(nLine+346,nBaseTxt,aTotais[01],oFont08:oFont)
ElseIf lImpSimpN
	oDanfe:Say(nLine+346,nBaseTxt,aSimpNac[01],oFont08:oFont)	
Endif
oDanfe:Box(nLine+328,262,nLine+353,402)
oDanfe:Say(nLine+336,272,"VALOR DO ICMS",oFont08N:oFont)
If cMVCODREG $ "3" 
	oDanfe:Say(nLine+346,272,aTotais[02],oFont08:oFont)
ElseIf lImpSimpN
	oDanfe:Say(nLine+346,272,aSimpNac[02],oFont08:oFont)
Endif
oDanfe:Box(nLine+328,402,nLine+353,557)
oDanfe:Say(nLine+336,412,"BASE DE CALCULO DO ICMS ST",oFont08N:oFont)
oDanfe:Say(nLine+346,412,aTotais[03],oFont08:oFont)
oDanfe:Box(nLine+328,557,nLine+353,697)
oDanfe:Say(nLine+336,567,"VALOR DO ICMS SUBSTITUI��O",oFont08N:oFont)
oDanfe:Say(nLine+346,567,aTotais[04],oFont08:oFont)
oDanfe:Box(nLine+328,697,nLine+353,MAXBOXH+70)
oDanfe:Say(nLine+336,707,"VALOR TOTAL DOS PRODUTOS",oFont08N:oFont)
oDanfe:Say(nLine+346,707,aTotais[05],oFont08:oFont)


oDanfe:Box(nLine+353,nBaseCol+30,nLine+378,232)
oDanfe:Say(nLine+361,nBaseTxt,"VALOR DO FRETE",oFont08N:oFont)
oDanfe:Say(nLine+371,nBaseTxt,aTotais[06],oFont08:oFont)
oDanfe:Box(nLine+353,232,nLine+378,352)
oDanfe:Say(nLine+361,242,"VALOR DO SEGURO",oFont08N:oFont)
oDanfe:Say(nLine+371,242,aTotais[07],oFont08:oFont)
oDanfe:Box(nLine+353,352,nLine+378,452)
oDanfe:Say(nLine+361,362,"DESCONTO",oFont08N:oFont)
oDanfe:Say(nLine+371,362,aTotais[08],oFont08:oFont)
oDanfe:Box(nLine+353,452,nLine+378,592)
oDanfe:Say(nLine+361,462,"OUTRAS DESPESAS ACESS�RIAS",oFont08N:oFont)
oDanfe:Say(nLine+371,462,aTotais[09],oFont08:oFont)
oDanfe:Box(nLine+353,592,nLine+378,712)
oDanfe:Say(nLine+361,602,"VALOR TOTAL DO IPI",oFont08N:oFont)
oDanfe:Say(nLine+371,602,aTotais[10],oFont08:oFont)
oDanfe:Box(nLine+353,712,nLine+378,MAXBOXH+70)
oDanfe:Say(nLine+361,722,"VALOR TOTAL DA NOTA",oFont08N:oFont)
oDanfe:Say(nLine+371,722,aTotais[11],oFont08:oFont)

nLine -= 3
//������������������������������������������������������������������������Ŀ
//�Transportador/Volumes transportados                                     �
//��������������������������������������������������������������������������
nBaseTxt -= 30 
//oDanfe:Box(nLine+379,nBaseCol,nLine+452,nBaseCol+30)
oDanfe:FillRect({nLine+380,nBaseCol,nLine+451,nBaseCol+30},oBrush)
oDanfe:Say(nLine+446,nBaseTxt   ,"TRANSPORTADOR/" ,oFont08N:oFont, , CLR_WHITE, 270 )
oDanfe:Say(nLine+438,nBaseTxt+7 ,"VOLUMES"        ,oFont08N:oFont, , CLR_WHITE, 270 )
oDanfe:Say(nLine+448,nBaseTxt+14,"TRANSPORTADOS"  ,oFont08N:oFont, , CLR_WHITE, 270 )
nBaseTxt += 30 

oDanfe:Box(nLine+379,nBaseCol+30,nLine+404,402)
oDanfe:Say(nLine+387,nBaseTxt,"RAZ�O SOCIAL",oFont08N:oFont)
oDanfe:Say(nLine+397,nBaseTxt,aTransp[01],oFont08:oFont)
oDanfe:Box(nLine+379,402,nLine+404,482)
oDanfe:Say(nLine+387,412,"FRETE POR CONTA",oFont08N:oFont)
If cModFrete =="0"
	oDanfe:Say(nLine+397,412,"0-EMITENTE",oFont08:oFont)
ElseIf cModFrete =="1"
	oDanfe:Say(nLine+397,412,"1-DEST/REM",oFont08:oFont)
ElseIf cModFrete =="2"
	oDanfe:Say(nLine+397,412,"2-TERCEIROS",oFont08:oFont)
ElseIf cModFrete =="9"
	oDanfe:Say(nLine+397,412,"9-SEM FRETE",oFont08:oFont)
Else
	oDanfe:Say(nLine+397,412,"",oFont08:oFont)
Endif
oDanfe:Box(nLine+379,482,nLine+404,562)
oDanfe:Say(nLine+387,492,"C�DIGO ANTT",oFont08N:oFont)
oDanfe:Say(nLine+397,492,aTransp[03],oFont08:oFont)
oDanfe:Box(nLine+379,562,nLine+404,652)
oDanfe:Say(nLine+387,572,"PLACA DO VE�CULO",oFont08N:oFont)
oDanfe:Say(nLine+397,572,aTransp[04],oFont08:oFont)
oDanfe:Box(nLine+379,652,nLine+404,702)
oDanfe:Say(nLine+387,662,"UF",oFont08N:oFont)
oDanfe:Say(nLine+397,662,aTransp[05],oFont08:oFont)
oDanfe:Box(nLine+379,702,nLine+404,MAXBOXH+70)
oDanfe:Say(nLine+387,712,"CNPJ/CPF",oFont08N:oFont)
oDanfe:Say(nLine+397,712,aTransp[06],oFont08:oFont)

oDanfe:Box(nLine+404,nBaseCol+30,nLine+429,402)
oDanfe:Say(nLine+412,nBaseTxt,"ENDERE�O",oFont08N:oFont)
oDanfe:Say(nLine+422,nBaseTxt,aTransp[07],oFont08:oFont)
oDanfe:Box(nLine+404,402,nLine+429,652)
oDanfe:Say(nLine+412,412,"MUNICIPIO",oFont08N:oFont)
oDanfe:Say(nLine+422,412,aTransp[08],oFont08:oFont)
oDanfe:Box(nLine+404,652,nLine+429,702)
oDanfe:Say(nLine+412,662,"UF",oFont08N:oFont)
oDanfe:Say(nLine+422,662,aTransp[09],oFont08:oFont)
oDanfe:Box(nLine+404,702,nLine+429,MAXBOXH+70)
oDanfe:Say(nLine+412,712,"INSCRI��O ESTADUAL",oFont08N:oFont)
oDanfe:Say(nLine+422,712,aTransp[10],oFont08:oFont)

oDanfe:Box(nLine+429,nBaseCol+30,nLine+454,232)
oDanfe:Say(nLine+437,nBaseTxt,"QUANTIDADE",oFont08N:oFont)
oDanfe:Say(nLine+447,nBaseTxt,aTransp[11],oFont08:oFont)
oDanfe:Box(nLine+429,232,nLine+454,352)
oDanfe:Say(nLine+437,242,"ESPECIE",oFont08N:oFont)
oDanfe:Say(nLine+447,242,Iif(!Empty(aTransp[12]),aTransp[12],Iif(Len(aEspVol)>0,aEspVol[1][1],"")),oFont08:oFont)
//oDanfe:Say(nLine+447,242,aEspVol[1][1],oFont08:oFont)
oDanfe:Box(nLine+429,352,nLine+454,472)
oDanfe:Say(nLine+437,362,"MARCA",oFont08N:oFont)
oDanfe:Say(nLine+447,362,aTransp[13],oFont08:oFont)
oDanfe:Box(nLine+429,472,nLine+454,592)
oDanfe:Say(nLine+437,482,"NUMERA��O",oFont08N:oFont)
oDanfe:Say(nLine+447,482,aTransp[14],oFont08:oFont)
oDanfe:Box(nLine+429,592,nLine+454,712)
oDanfe:Say(nLine+437,602,"PESO BRUTO",oFont08N:oFont)
oDanfe:Say(nLine+447,602,Iif(!Empty(aTransp[15]),aTransp[15],Iif(Len(aEspVol)>0 .And. Val(aEspVol[1][3])>0,Transform(Val(aEspVol[1][3]),"@E 999999.9999"),"")),oFont08:oFont)
//oDanfe:Say(nLine+447,602,Iif (!Empty(aEspVol[1][3]),Transform(val(aEspVol[1][3]),"@E 999999.9999"),""),oFont08:oFont)
oDanfe:Box(nLine+429,712,nLine+454,MAXBOXH+70)
oDanfe:Say(nLine+437,722,"PESO LIQUIDO",oFont08N:oFont)
oDanfe:Say(nLine+447,722,Iif(!Empty(aTransp[16]),aTransp[16],Iif(Len(aEspVol)>0 .And. Val(aEspVol[1][2])>0,Transform(Val(aEspVol[1][2]),"@E 999999.9999"),"")),oFont08:oFont)
//oDanfe:Say(nLine+447,722,aTransp[16],oFont08:oFont)

//������������������������������������������������������������������������Ŀ
//�Calculo do ISSQN                                                        �
//��������������������������������������������������������������������������

nBaseTxt -= 30 
//oDanfe:Box(nLine+573,nBaseCol,nLine+597,nBaseCol+30)
oDanfe:FillRect({nLine+574,nBaseCol,nLine+596,nBaseCol+30},oBrush)
//oDanfe:Box(nLine+574,nBaseCol+1,nLine+596,nBaseCol+29)
oDanfe:Say(nLine+596,nBaseTxt+7,"ISSQN",oFont08N:oFont, , CLR_WHITE, 270 )
nBaseTxt += 30 

oDanfe:Box(nLine+573,nBaseCol+30,nLine+597,302)
oDanfe:Say(nLine+581,nBaseTxt,"INSCRI��O MUNICIPAL",oFont08N:oFont)
oDanfe:Say(nLine+591,nBaseTxt,aISSQN[1],oFont08:oFont)
oDanfe:Box(nLine+573,302,nLine+597,502)
oDanfe:Say(nLine+581,312,"VALOR TOTAL DOS SERVI�OS",oFont08N:oFont)
oDanfe:Say(nLine+591,312,aISSQN[2],oFont08:oFont)
oDanfe:Box(nLine+573,502,nLine+597,702)
oDanfe:Say(nLine+581,512,"BASE DE C�LCULO DO ISSQN",oFont08N:oFont)
oDanfe:Say(nLine+591,512,aISSQN[3],oFont08:oFont)
oDanfe:Box(nLine+573,702,nLine+597,MAXBOXH+70)
oDanfe:Say(nLine+581,712,"VALOR DO ISSQN",oFont08N:oFont)
oDanfe:Say(nLine+591,712,aISSQN[4],oFont08:oFont)


//������������������������������������������������������������������������Ŀ
//�Dados Adicionais                                                        �
//��������������������������������������������������������������������������
nPosMsg := 0
DanfeInfC(oDanfe,aMensagem,@nBaseTxt,@nBaseCol,@nLine,@nPosMsg,nFolha)

//������������������������������������������������������������������������Ŀ
//�Dados do produto ou servico                                             �
//��������������������������������������������������������������������������
aAux := {{{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}}}
nY := 0
nLenItens := Len(aItens)

For nX :=1 To nLenItens
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][01])
	nY++
	aadd(Atail(aAux)[nY],NoChar(aItens[nX][02],lConverte))
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][03])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][04])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][05])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][06])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][07])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][08])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][09])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][10])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][11])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][12])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][13])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][14])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][15])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][16])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][17])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][18])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][19])
	If nY >= 19
		nY := 0
	EndIf
Next nX
For nX := 1 To nLenItens
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")

	If nY >= 19
		nY := 0
	EndIf
	
Next nX

// Popula o array de cabe�alho das colunas de produtos/servi�os.
aAuxCabec := {;
	"COD. PROD",;
	"DESCR PROD",;
	"NCM/SH",;
	IIf( cMVCODREG == "1", "CSOSN","CST" ),;
	"CFOP",;
	"UN",;
	"QUANT.",;
	"V.UNITARIO",;
	"VLR TOTAL",;
	"VLR DESC",;
	"V.UNI LIQ",;
	"TOTAL LIQ",;
	"BC.ICMS",;
	"BC.ICMS ST",;
	"VLR ICMS",;
	"VLR ICMS ST",;
	"VALOR IPI",;
	"ICMS",;
	"IPI";
}

// Retorna o tamanho das colunas baseado em seu conteudo
aTamCol := RetTamCol(aAuxCabec, aAux, oDanfe, oFont08N:oFont, oFont07:oFont)

aColProd := {}
DanfeIT(oDanfe, @nLine, @nBaseCol, @nBaseTxt, nFolha, nFolhas, @aColProd, aMensagem, nPosMsg, aTamCol)

lPag1 := .T.
lPag2 := .F.
lPagX := .F.
lInfoAd:= .F.

nFolha++
nLinha    :=nLine+478
nL:=0  

For nY := 1 To nLenItens
	nL++
	If lPag1
		If nL > MAXITEM .And. nFolha == 2
			oDanfe:EndPage()
			oDanfe:StartPage()
			nLinha    	:=	181

			DanfeCab(oDanfe,nPosV,oNFe,oIdent,oEmitente,nFolha,nFolhas,cCodAutSef,oNfeDPEC,cCodAutDPEC,cDtHrRecCab,dDtReceb,@nLine,@nBaseCol,@nBaseTxt,aUf)			
			DanfeIT(oDanfe, @nLine, @nBaseCol, @nBaseTxt, nFolha, nFolhas, @aColProd, aMensagem, nPosMsg, aTamCol)
			If nPosMsg > 0
				DanfeInfC(oDanfe,aMensagem,@nBaseTxt,@nBaseCol,@nLine,@nPosMsg,nFolha)
				lInfoAd := .T.
			EndIf	
			nL :=0
			lPag1 := .F.
			lPag2 := .T.
			nLinha := 169
		Endif           
	Endif

	If lPag2  .And. lInfoAd
		If	nL > MAXITEMP4
			nFolha++
			oDanfe:EndPage()
			oDanfe:StartPage()
			nColLim		:=	Iif(!(nfolha-1)%2==0 .And. MV_PAR05==1,435,865)
			nLinha    	:=	181
			
			DanfeCab(oDanfe,nPosV,oNFe,oIdent,oEmitente,nFolha,nFolhas,cCodAutSef,oNfeDPEC,cCodAutDPEC,cDtHrRecCab,dDtReceb,@nLine,@nBaseCol,@nBaseTxt,aUf)			
			DanfeIT(oDanfe, @nLine, @nBaseCol, @nBaseTxt, nFolha, nFolhas, @aColProd, aMensagem, nPosMsg, aTamCol)  
			nLinha := 169
	
			nL:=0
			lPag2 := .F.
			lPagX := .T.      
			lInfoAd:= .F.
		EndIf
	Else
		If	nL >= MAXITEMP2
			nFolha++
			oDanfe:EndPage()
			oDanfe:StartPage()
			nColLim		:=	Iif(!(nfolha-1)%2==0 .And. MV_PAR05==1,435,865)
			nLinha    	:=	181
			
			DanfeCab(oDanfe,nPosV,oNFe,oIdent,oEmitente,nFolha,nFolhas,cCodAutSef,oNfeDPEC,cCodAutDPEC,cDtHrRecCab,dDtReceb,@nLine,@nBaseCol,@nBaseTxt,aUf)			
			DanfeIT(oDanfe, @nLine, @nBaseCol, @nBaseTxt, nFolha, nFolhas, @aColProd, aMensagem, nPosMsg, aTamCol)
			nLinha := 169
	
			nL:=0		
		EndIf
	EndIf
	
	If aAux[1][1][nY] == "-"
		oDanfe:Say(nLinha, aColProd[1][1] + 2, Replicate("- ", 192), oFont07:oFont)
	Else
		oDanfe:Say(nLinha, aColProd[1][1] + 2, aAux[1][1][nY], oFont07:oFont)
		oDanfe:Say(nLinha, aColProd[2][1] + 2, aAux[1][2][nY], oFont07:oFont)
		oDanfe:Say(nLinha, aColProd[3][1] + 2, aAux[1][3][nY], oFont07:oFont)
		oDanfe:Say(nLinha, aColProd[4][1] + 2, aAux[1][4][nY], oFont07:oFont)
		oDanfe:Say(nLinha, aColProd[5][1] + 2, aAux[1][5][nY], oFont07:oFont)
		oDanfe:Say(nLinha, aColProd[6][1] + 2, aAux[1][6][nY], oFont07:oFont)
		nAuxH2 :=  len(aAux[1][7][nY]) + (aColProd[7][1] + ((aColProd[7][2] - aColProd[7][1]) - RetTamTex(aAux[1][7][nY], oFont07:oFont, oDanfe)))
		oDanfe:Say(nLinha, nAuxH2, aAux[1][7][nY], oFont07:oFont)
		
		nAuxH2 := len(aAux[1][8][nY]) + (aColProd[8][1] + ((aColProd[8][2] - aColProd[8][1]) - RetTamTex(aAux[1][8][nY], oFont07:oFont, oDanfe)))
		oDanfe:Say(nLinha, nAuxH2, aAux[1][8][nY], oFont07:oFont)
		
		nAuxH2 := len(aAux[1][9][nY]) + (aColProd[9][1] + ((aColProd[9][2] - aColProd[9][1]) - RetTamTex(aAux[1][9][nY], oFont07:oFont, oDanfe)))
		oDanfe:Say(nLinha, nAuxH2, aAux[1][9][nY], oFont07:oFont)
		
		nAuxH2 := len(aAux[1][10][nY]) + (aColProd[10][1] + ((aColProd[10][2] - aColProd[10][1]) - RetTamTex(aAux[1][10][nY], oFont07:oFont, oDanfe)))
		oDanfe:Say(nLinha, nAuxH2, aAux[1][10][nY], oFont07:oFont)
		
		nAuxH2 := len(aAux[1][11][nY]) + (aColProd[11][1] + ((aColProd[11][2] - aColProd[11][1]) - RetTamTex(aAux[1][11][nY], oFont07:oFont, oDanfe)))
		oDanfe:Say(nLinha, nAuxH2, aAux[1][11][nY], oFont07:oFont)
		
		nAuxH2 := len(aAux[1][12][nY]) + (aColProd[12][1] + ((aColProd[12][2] - aColProd[12][1]) - RetTamTex(aAux[1][12][nY], oFont07:oFont, oDanfe)))
		oDanfe:Say(nLinha, nAuxH2, aAux[1][12][nY], oFont07:oFont)
		
		nAuxH2 := len(aAux[1][13][nY]) + (aColProd[13][1] + ((aColProd[13][2] - aColProd[13][1]) - RetTamTex(aAux[1][13][nY], oFont07:oFont, oDanfe)))
		oDanfe:Say(nLinha, nAuxH2, aAux[1][13][nY], oFont07:oFont)
		
		nAuxH2 := len(aAux[1][14][nY]) + (aColProd[14][1] + ((aColProd[14][2] - aColProd[14][1]) - RetTamTex(aAux[1][14][nY], oFont07:oFont, oDanfe)))
		oDanfe:Say(nLinha, nAuxH2, aAux[1][14][nY], oFont07:oFont)
		
		nAuxH2 := len(aAux[1][15][nY]) + (aColProd[15][1] + ((aColProd[15][2] - aColProd[15][1]) - RetTamTex(aAux[1][15][nY], oFont07:oFont, oDanfe)))
		oDanfe:Say(nLinha, nAuxH2, aAux[1][15][nY], oFont07:oFont)
		
		nAuxH2 := len(aAux[1][16][nY]) + (aColProd[16][1] + ((aColProd[16][2] - aColProd[16][1]) - RetTamTex(aAux[1][16][nY], oFont07:oFont, oDanfe)))
		oDanfe:Say(nLinha, nAuxH2, aAux[1][16][nY], oFont07:oFont)
		
		nAuxH2 := len(aAux[1][17][nY]) + (aColProd[17][1] + ((aColProd[17][2] - aColProd[17][1]) - RetTamTex(aAux[1][17][nY], oFont07:oFont, oDanfe)))
		oDanfe:Say(nLinha, nAuxH2, aAux[1][17][nY], oFont07:oFont)
		
		nAuxH2 := len(aAux[1][18][nY]) + (aColProd[18][1] + ((aColProd[18][2] - aColProd[18][1]) - RetTamTex(aAux[1][18][nY], oFont07:oFont, oDanfe)))
		oDanfe:Say(nLinha, nAuxH2, aAux[1][18][nY], oFont07:oFont)
		
		nAuxH2 := len(aAux[1][19][nY]) + (aColProd[19][1] + ((aColProd[19][2] - aColProd[19][1]) - RetTamTex(aAux[1][19][nY], oFont07:oFont, oDanfe)))
		oDanfe:Say(nLinha, nAuxH2, aAux[1][19][nY], oFont07:oFont)
	EndIf
	
	nLinha := nLinha + 10 
Next nY 
If nL <= MAXITEM .And. Len(aMensagem) > MAXMSG .And. nFolha == 2 .And. nLenItens <= MAXMSG
	oDanfe:EndPage()
	oDanfe:StartPage()
	nLinha    	:=	181                
	DanfeCab(oDanfe,nPosV,oNFe,oIdent,oEmitente,nFolha,nFolhas,cCodAutSef,oNfeDPEC,cCodAutDPEC,cDtHrRecCab,dDtReceb,@nLine,@nBaseCol,@nBaseTxt,aUf)
	DanfeIT(oDanfe, @nLine, @nBaseCol, @nBaseTxt, nFolha, nFolhas, @aColProd, aMensagem, nPosMsg, aTamCol)
	If nPosMsg > 0
		DanfeInfC(oDanfe,aMensagem,@nBaseTxt,@nBaseCol,@nLine,@nPosMsg,nFolha)
	EndIf
elseif nPosMsg > 0 
	oDanfe:EndPage()
	oDanfe:StartPage()
	nLinha    	:=	181                
	DanfeCab(oDanfe,nPosV,oNFe,oIdent,oEmitente,nFolha,nFolhas,cCodAutSef,oNfeDPEC,cCodAutDPEC,cDtHrRecCab,dDtReceb,@nLine,@nBaseCol,@nBaseTxt,aUf)
	
	DanfeInfC(oDanfe,aMensagem,@nBaseTxt,@nBaseCol,@nLine,@nPosMsg,nFolha,.T.)
Endif

//������������������������������������������������������������������������Ŀ
//�Finaliza a Impress�o                                                    �
//��������������������������������������������������������������������������
If lPreview
	//	oDanfe:Preview()
EndIf

oDanfe:EndPage()

Return(.T.)

                                                              
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � DanfeCab  � Autor � Roberto Souza        � Data � 13/08/10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Definicao do Cabecalho do documento.                       ���
���			 �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � FAT/FIS                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function DanfeCab(oDanfe,nPosV,oNFe,oIdent,oEmitente,nFolha,nFolhas,cCodAutSef,oNfeDPEC,cCodAutDPEC,cDtHrRecCab,dDtReceb,nLine,nBaseCol,nBaseTxt,aUf)

Local aTamanho   := {}
//Local aUF		 := {}
Local nHPage     := 0
Local nVPage     := 0
Local nPosVOld   := 0
Local nPosH      := 0
Local nPosHOld   := 0
Local nAuxV      := 0
Local nAuxH      := 0
Local cChaveCont := ""
Local cDataEmi   := ""
Local cDigito    := ""
Local cTPEmis    := ""
Local cValIcm    := ""
Local cICMSp     := ""
Local cICMSs     := ""
Local cUF		 := ""
Local cCNPJCPF	 := ""
Local cLogo      := FisxLogo("1")
Local lConverte  := GetNewPar("MV_CONVERT",.F.)
Local lMv_Logod := If( GetNewPar("MV_LOGOD", "N" ) == "S", .T., .F. )
Local cLogoD	:= ""

Local cDescLogo		:= ""
Local cGrpCompany	:= ""
Local cCodEmpGrp	:= ""
Local cUnitGrp		:= ""
Local cFilGrp		:= ""

Private oDPEC    := oNfeDPEC


Default cCodAutSef := ""
Default cCodAutDPEC:= ""
Default cDtHrRecCab:= ""
Default dDtReceb   := CToD("")

nLine    := -42
nBaseCol := 70

// PICOTE DO RECIBO
//oDanfe:Say(MAXBOXV, INIBOXH+80, Replicate("- ",500), oFont08N:oFont, , , 270 )
oDanfe:Say(000, INIBOXH+74, Replicate("- ",150), oFont08N:oFont, , , 90 )

oDanfe:Box(nLine+135, INIBOXH+10, MAXBOXV, INIBOXH+35)
If Len(oEmitente:_xNome:Text) >= 50
	oDanfe:Say(MAXBOXV-10, INIBOXH+20, "RECEBEMOS DE "+NoChar(oEmitente:_xNome:Text,lConverte), oFont07:oFont, , , 270 )
	oDanfe:Say(MAXBOXV-10, INIBOXH+30, "OS PRODUTOS CONSTANTES DA NOTA FISCAL INDICADA AO LADO", oFont07:oFont, , , 270 )
Else
	oDanfe:Say(MAXBOXV-10, INIBOXH+20, "RECEBEMOS DE "+NoChar(oEmitente:_xNome:Text,lConverte)+" OS PRODUTOS CONSTANTES DA NOTA FISCAL INDICADA AO LADO", oFont07:oFont, , , 270 )
EndIf
	
oDanfe:Box(nLine+500,INIBOXH+35,MAXBOXV,INIBOXH+70)
oDanfe:Say(MAXBOXV-10, INIBOXH+45, "DATA DE RECEBIMENTO", oFont07N:oFont, , , 270)

oDanfe:Box(nLine+135,INIBOXH+35,nLine+500,INIBOXH+70)
oDanfe:Say(MAXBOXV-150, INIBOXH+45, "IDENTIFICA��O E ASSINATURA DO RECEBEDOR", oFont07N:oFont, , , 270)

oDanfe:Box(nLine+042, INIBOXH+10, nLine+135, INIBOXH+70)
oDanfe:Say(MAXBOXV-550, INIBOXH+20, "NF-e", oFont08N:oFont, , , 270)
oDanfe:Say(MAXBOXV-520, INIBOXH+35, "N� "+StrZero(Val(oIdent:_NNf:Text),9), oFont08:oFont, , , 270)
oDanfe:Say(MAXBOXV-520, INIBOXH+45, "S�RIE "+SubStr(oIdent:_Serie:Text,1,3), oFont08:oFont, , , 270)


//������������������������������������������������������������������������Ŀ
//�Quadro 1 IDENTIFICACAO DO EMITENTE                                      �
//��������������������������������������������������������������������������

nBaseTxt := 180
oDanfe:Box(nLine+042,nBaseCol,nLine+139,450)
oDanfe:Say(nLine+057,nBaseTxt, "Identifica��o do emitente",oFont12N:oFont)
If len(oEmitente:_xNome:Text)>43
	oDanfe:Say(nLine+070,nBaseTxt,SubStr(NoChar(oEmitente:_xNome:Text,lConverte),1,45), oFont12N:oFont )
	oDanfe:Say(nLine+080,nBaseTxt,SubStr(NoChar(oEmitente:_xNome:Text,lConverte),46,45), oFont12N:oFont )
Else
	oDanfe:Say(nLine+070,nBaseTxt, NoChar(oEmitente:_xNome:Text,lConverte),oFont12N:oFont)
Endif
If len(oEmitente:_xNome:Text)>45
	oDanfe:Say(nLine+090,nBaseTxt, NoChar(oEmitente:_EnderEmit:_xLgr:Text,lConverte)+", "+oEmitente:_EnderEmit:_Nro:Text,oFont08N:oFont)
Else
	oDanfe:Say(nLine+080,nBaseTxt, NoChar(oEmitente:_EnderEmit:_xLgr:Text,lConverte)+", "+oEmitente:_EnderEmit:_Nro:Text,oFont08N:oFont)
Endif
If len(oEmitente:_xNome:Text)>45
	If Type("oEmitente:_EnderEmit:_xCpl") <> "U"
		oDanfe:Say(nLine+100,nBaseTxt, "Complemento: " + NoChar(oEmitente:_EnderEmit:_xCpl:TEXT,lConverte),oFont08N:oFont)
		oDanfe:Say(nLine+110,nBaseTxt, NoChar(oEmitente:_EnderEmit:_xBairro:Text,lConverte)+" Cep:"+TransForm(IIF(Type("oEmitente:_EnderEmit:_Cep")=="U","",oEmitente:_EnderEmit:_Cep:Text),"@r 99999-999"),oFont08N:oFont)
		oDanfe:Say(nLine+120,nBaseTxt, oEmitente:_EnderEmit:_xMun:Text+"/"+oEmitente:_EnderEmit:_UF:Text,oFont08N:oFont)
		oDanfe:Say(nLine+130,nBaseTxt, "Fone: "+IIf(Type("oEmitente:_EnderEmit:_Fone")=="U","",oEmitente:_EnderEmit:_Fone:Text),oFont08N:oFont)
	Else
		oDanfe:Say(nLine+100,nBaseTxt, NoChar(oEmitente:_EnderEmit:_xBairro:Text,lConverte)+" Cep:"+TransForm(IIF(Type("oEmitente:_EnderEmit:_Cep")=="U","",oEmitente:_EnderEmit:_Cep:Text),"@r 99999-999"),oFont08N:oFont)
		oDanfe:Say(nLine+110,nBaseTxt, oEmitente:_EnderEmit:_xMun:Text+"/"+oEmitente:_EnderEmit:_UF:Text,oFont08N:oFont)
		oDanfe:Say(nLine+120,nBaseTxt, "Fone: "+IIf(Type("oEmitente:_EnderEmit:_Fone")=="U","",oEmitente:_EnderEmit:_Fone:Text),oFont08N:oFont)
	EndIf
	
Else
	If Type("oEmitente:_EnderEmit:_xCpl") <> "U"
		oDanfe:Say(nLine+090,nBaseTxt, "Complemento: " + NoChar(oEmitente:_EnderEmit:_xCpl:TEXT,lConverte),oFont08N:oFont)
		oDanfe:Say(nLine+100,nBaseTxt, NoChar(oEmitente:_EnderEmit:_xBairro:Text,lConverte)+" Cep:"+TransForm(IIF(Type("oEmitente:_EnderEmit:_Cep")=="U","",oEmitente:_EnderEmit:_Cep:Text),"@r 99999-999"),oFont08N:oFont)
		oDanfe:Say(nLine+110,nBaseTxt, oEmitente:_EnderEmit:_xMun:Text+"/"+oEmitente:_EnderEmit:_UF:Text,oFont08N:oFont)
		oDanfe:Say(nLine+120,nBaseTxt, "Fone: "+IIf(Type("oEmitente:_EnderEmit:_Fone")=="U","",oEmitente:_EnderEmit:_Fone:Text),oFont08N:oFont)
	Else
		oDanfe:Say(nLine+090,nBaseTxt, NoChar(oEmitente:_EnderEmit:_xBairro:Text,lConverte)+" Cep:"+TransForm(IIF(Type("oEmitente:_EnderEmit:_Cep")=="U","",oEmitente:_EnderEmit:_Cep:Text),"@r 99999-999"),oFont08N:oFont)
		oDanfe:Say(nLine+100,nBaseTxt, oEmitente:_EnderEmit:_xMun:Text+"/"+oEmitente:_EnderEmit:_UF:Text,oFont08N:oFont)
		oDanfe:Say(nLine+110,nBaseTxt, "Fone: "+IIf(Type("oEmitente:_EnderEmit:_Fone")=="U","",oEmitente:_EnderEmit:_Fone:Text),oFont08N:oFont)
	EndIf
Endif


//������������������������������������������������������������������������Ŀ
//�Quadro 2                                                                �
//��������������������������������������������������������������������������

nBaseTxt := 460
oDanfe:Box(nLine+042,450,nLine+139,602)
oDanfe:Say(nLine+055,nBaseTxt+35, "DANFE",oFont18N:oFont)
oDanfe:Say(nLine+065,nBaseTxt+10, "DOCUMENTO AUXILIAR DA",oFont10:oFont)
oDanfe:Say(nLine+075,nBaseTxt+10, "NOTA FISCAL ELETR�NICA",oFont10:oFont)
oDanfe:Say(nLine+085,nBaseTxt+15, "0-ENTRADA",oFont10:oFont)
oDanfe:Say(nLine+095,nBaseTxt+15, "1-SA�DA"  ,oFont10:oFont)
oDanfe:Box(nLine+078,nBaseTxt+70,nLine+092,nBaseTxt+85)
oDanfe:Say(nLine+088,nBaseTxt+75, oIdent:_TpNf:Text,oFont10N:oFont)
oDanfe:Say(nLine+110,nBaseTxt,"N. "+StrZero(Val(oIdent:_NNf:Text),9),oFont10N:oFont)
oDanfe:Say(nLine+120,nBaseTxt,"S�RIE "+SubStr(oIdent:_Serie:Text,1,3),oFont10N:oFont)
oDanfe:Say(nLine+130,nBaseTxt,"FOLHA "+StrZero(nFolha,2)+"/"+StrZero(nFolhas,2),oFont10N:oFont)

nHPage := oDanfe:nHorzRes()
nHPage *= (300/PixelX)
nHPage -= HMARGEM
nVPage := oDanfe:nVertRes()
nVPage *= (300/PixelY)
nVPage -= VBOX

//������������������������������������������������������������������������Ŀ
//�Logotipo                                     �
//��������������������������������������������������������������������������
If lMv_Logod
	cGrpCompany	:= AllTrim(FWGrpCompany())
	cCodEmpGrp	:= AllTrim(FWCodEmp())
	cUnitGrp	:= AllTrim(FWUnitBusiness())
	cFilGrp		:= AllTrim(FWFilial())

	If !Empty(cUnitGrp)
		cDescLogo	:= cGrpCompany + cCodEmpGrp + cUnitGrp + cFilGrp
	Else
		cDescLogo	:= cEmpAnt + cFilAnt
	EndIf

	cLogoD := GetSrvProfString("Startpath","") + "DANFE" + cDescLogo + ".BMP"
	If !File(cLogoD)
		cLogoD	:= GetSrvProfString("Startpath","") + "DANFE" + cEmpAnt + ".BMP"
		If !File(cLogoD)
			lMv_Logod := .F.
		EndIf
	EndIf	
EndIf

If nfolha>=1
	If lMv_Logod
		oDanfe:SayBitmap(005,075,cLogoD,095,096)
	Else
		oDanfe:SayBitmap(005,075,cLogo,095,096)
	EndIf
Endif

//������������������������������������������������������������������������Ŀ
//�Codigo de barra                                                         �
//��������������������������������������������������������������������������

nBaseTxt := 612
oDanfe:Box(nLine+042,602,nLine+088,MAXBOXH+70)
oDanfe:Box(nLine+075,602,nLine+077,MAXBOXH+70)
oDanfe:Box(nLine+077,602,nLine+110,MAXBOXH+70)
oDanfe:Box(nLine+105,602,nLine+139,MAXBOXH+70)
oDanfe:Say(nLine+097,nBaseTxt,TransForm(SubStr(oNF:_InfNfe:_ID:Text,4),"@r 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999"),oFont10N:oFont)


If nFolha >= 1
	oDanfe:Say(nLine+087,nBaseTxt,"CHAVE DE ACESSO DA NF-E",oFont09N:oFont)
	nFontSize := 28
	oDanfe:Code128C(nLine+072,nBaseTxt,SubStr(oNF:_InfNfe:_ID:Text,4), nFontSize )
EndIf

If !Empty(cCodAutDPEC) .And. (oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"4" .And. !lUsaColab
	cDataEmi := Iif(oNF:_INFNFE:_VERSAO:TEXT >= "3.10",Substr(oNFe:_NFE:_INFNFE:_IDE:_DHEMI:Text,9,2),Substr(oNFe:_NFE:_INFNFE:_IDE:_DEMI:Text,9,2))
	cTPEmis  := "4"
	If Type("oDPEC:_ENVDPEC:_INFDPEC:_RESNFE") <> "U"
		cUF      := aUF[aScan(aUF,{|x| x[1] == oDPEC:_ENVDPEC:_INFDPEC:_RESNFE:_UF:Text})][02]
		cValIcm := StrZero(Val(StrTran(oDPEC:_ENVDPEC:_INFDPEC:_RESNFE:_VNF:TEXT,".","")),14)
		cICMSp := iif(Val(oDPEC:_ENVDPEC:_INFDPEC:_RESNFE:_VICMS:TEXT)>0,"1","2")
		cICMSs := iif(Val(oDPEC:_ENVDPEC:_INFDPEC:_RESNFE:_VST:TEXT)>0,"1","2")
	ElseIf type ("oDPEC:_EVENTO:_INFEVENTO:_DETEVENTO:_DEST") <> "U" //EPEC NFE
		If Type ("oDPEC:_EVENTO:_INFEVENTO:_DETEVENTO:_DEST:_UF:TEXT") <> "U"
			cUF := aUF[aScan(aUF,{|x| x[1] == oDPEC:_EVENTO:_INFEVENTO:_DETEVENTO:_DEST:_UF:TEXT})][02]			
		EndIf
		If Type ("oDPEC:_EVENTO:_INFEVENTO:_DETEVENTO:_DEST:_VNF:TEXT") <> "U"
			cValIcm := StrZero(Val(StrTran(oDPEC:_EVENTO:_INFEVENTO:_DETEVENTO:_DEST:_VNF:TEXT,".","")),14)
		EndIf
		If 	Type ("oDPEC:_EVENTO:_INFEVENTO:_DETEVENTO:_DEST:_VICMS:TEXT") <> "U"
			cICMSp:= IIf(Val(oDPEC:_EVENTO:_INFEVENTO:_DETEVENTO:_DEST:_VICMS:TEXT) > 0,"1","2")
		EndIf
		If 	Type ("oDPEC:_EVENTO:_INFEVENTO:_DETEVENTO:_DEST:_VST:TEXT") <> "U"
			cICMSs := IIf(Val(oDPEC:_EVENTO:_INFEVENTO:_DETEVENTO:_DEST:_VST:TEXT )> 0,"1","2")
		EndIf	
	EndIf
ElseIF (oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"25" .Or. ( (oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"4" .And. lUsaColab .And. !Empty(cCodAutDPEC) )
	cUF      := aUF[aScan(aUF,{|x| x[1] == oNFe:_NFE:_INFNFE:_DEST:_ENDERDEST:_UF:Text})][02]
	cDataEmi := Iif(oNF:_INFNFE:_VERSAO:TEXT >= "3.10",Substr(oNFe:_NFE:_INFNFE:_IDE:_DHEMI:Text,9,2),Substr(oNFe:_NFE:_INFNFE:_IDE:_DEMI:Text,9,2))
	cTPEmis  := oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT
	cValIcm  := StrZero(Val(StrTran(oNFe:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:TEXT,".","")),14)
	cICMSp   := iif(Val(oNFe:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VICMS:TEXT)>0,"1","2")
	cICMSs   :=iif(Val(oNFe:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VST:TEXT)>0,"1","2")
EndIf
If !Empty(cUF) .And. !Empty(cDataEmi) .And. !Empty(cTPEmis) .And. !Empty(cValIcm) .And. !Empty(cICMSp) .And. !Empty(cICMSs)
	If Type("oNF:_InfNfe:_DEST:_CNPJ:Text")<>"U"
		cCNPJCPF := oNF:_InfNfe:_DEST:_CNPJ:Text
		If cUf == "99"
			cCNPJCPF := STRZERO(val(cCNPJCPF),14)
		EndIf
	ElseIf Type("oNF:_INFNFE:_DEST:_CPF:Text")<>"U"
		cCNPJCPF := oNF:_INFNFE:_DEST:_CPF:Text
		cCNPJCPF := STRZERO(val(cCNPJCPF),14)
	Else
		cCNPJCPF := ""
	EndIf
	cChaveCont += cUF+cTPEmis+cCNPJCPF+cValIcm+cICMSp+cICMSs+cDataEmi
	cChaveCont := cChaveCont+Modulo11(cChaveCont)
EndIf

If Empty(cChaveCont)
	oDanfe:Say(nLine+117,nBaseTxt,"Consulta de autenticidade no portal nacional da NF-e",oFont10:oFont)
	oDanfe:Say(nLine+127,nBaseTxt,"www.nfe.fazenda.gov.br/portal ou no site da SEFAZ Autorizada",oFont10:oFont)
Endif

If  !Empty(cCodAutDPEC)
	oDanfe:Say(nLine+117,nBaseTxt,"Consulta de autenticidade no portal nacional da NF-e",oFont10:oFont)
	oDanfe:Say(nLine+127,nBaseTxt,"www.nfe.fazenda.gov.br/portal ou no site da SEFAZ Autorizada",oFont10:oFont)
Endif


// inicio do segundo codigo de barras ref. a transmissao CONTIGENCIA OFF LINE
If !Empty(cChaveCont) .And. Empty(cCodAutDPEC) .And. !(Val(SubStr(oNF:_INFNFE:_IDE:_SERIE:TEXT,1,3)) >= 900)
	If nFolha == 1
		If !Empty(cChaveCont)
			nFontSize := 28
			oDanfe:Code128C(nLine+135,nBaseTxt,cChaveCont, nFontSize )
		EndIf
	Else
		If !Empty(cChaveCont)
			nFontSize := 28
			oDanfe:Code128C(nLine+135,nBaseTxt,cChaveCont, nFontSize )
		EndIf
	EndIf
EndIf



//������������������������������������������������������������������������Ŀ
//�Quadro 4   NATUREZA DA OPERACAO /  DADOS NFE / DPEC                     �
//��������������������������������������������������������������������������
nBaseTxt := nBaseCol + 10
oDanfe:Box(nLine+139,nBaseCol,nLine+164,602)
oDanfe:Box(nLine+139,602,nLine+164,MAXBOXH+70)

oDanfe:Say(nLine+148,nBaseTxt,"NATUREZA DA OPERA��O",oFont08N:oFont)
oDanfe:Say(nLine+158,nBaseTxt,oIdent:_NATOP:TEXT,oFont08:oFont)
If(!Empty(cCodAutDPEC))
	oDanfe:Say(nLine+148,610,"N�MERO DE REGISTRO DPEC",oFont08N:oFont)
	
Endif
If(((Val(SubStr(oNF:_INFNFE:_IDE:_SERIE:TEXT,1,3)) >= 900).And.(oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"2") .Or. (oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"1|6|7")
	oDanfe:Say(nLine+148,610,"PROTOCOLO DE AUTORIZA��O DE USO",oFont08N:oFont)
Endif
If((oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"25")
	oDanfe:Say(nLine+148,610,"DADOS DA NF-E",oFont08N:oFont)
Endif
oDanfe:Say(nLine+158,610,IIF(!Empty(cCodAutDPEC),cCodAutDPEC+" "+AllTrim(IIF(!Empty(dDtReceb),ConvDate(DTOS(dDtReceb)),Iif(oNF:_INFNFE:_VERSAO:TEXT >= "3.10",ConvDate(oNF:_InfNfe:_IDE:_DHEMI:Text),ConvDate(oNF:_InfNfe:_IDE:_DEMI:Text))))+" "+AllTrim(cDtHrRecCab),IIF(!Empty(cCodAutSef) .And. ((Val(SubStr(oNF:_INFNFE:_IDE:_SERIE:TEXT,1,3)) >= 900).And.(oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"2") .Or. (oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"1|6|7",cCodAutSef+" "+AllTrim(IIF(!Empty(dDtReceb),ConvDate(DTOS(dDtReceb)),Iif(oNF:_INFNFE:_VERSAO:TEXT >= "3.10",ConvDate(oNF:_InfNfe:_IDE:_DHEMI:Text),ConvDate(oNF:_InfNfe:_IDE:_DEMI:Text))))+" "+AllTrim(cDtHrRecCab),TransForm(cChaveCont,"@r 9999 9999 9999 9999 9999 9999 9999 9999 9999"))),oFont08:oFont)
nFolha++


//������������������������������������������������������������������������Ŀ
//�Quadro 5                                                                �
//��������������������������������������������������������������������������
oDanfe:Box(nLine+164,nBaseCol,nLine+189,350)
oDanfe:Box(nLine+164,350,nLine+189,602)
oDanfe:Box(nLine+164,602,nLine+189,MAXBOXH+70)
oDanfe:Say(nLine+172,nBaseTxt,"INSCRI��O ESTADUAL",oFont08N:oFont)
oDanfe:Say(nLine+180,nBaseTxt,IIf(Type("oEmitente:_IE:TEXT")<>"U",oEmitente:_IE:TEXT,""),oFont08:oFont)
oDanfe:Say(nLine+172,360,"INSC.ESTADUAL DO SUBST.TRIB.",oFont08N:oFont)
oDanfe:Say(nLine+180,362,IIf(Type("oEmitente:_IEST:TEXT")<>"U",oEmitente:_IEST:TEXT,""),oFont08:oFont)
oDanfe:Say(nLine+172,612,"CNPJ",oFont08N:oFont)
oDanfe:Say(nLine+180,612,TransForm(oEmitente:_CNPJ:TEXT,IIf(Len(oEmitente:_CNPJ:TEXT)<>14,"@r 999.999.999-99","@r 99.999.999/9999-99")),oFont08:oFont)

Return()

Static Function GetXML(cIdEnt,aIdNFe,cModalidade)  

Local aRetorno		:= {}
Local aDados		:= {}

Local cURL			:= PadR(GetNewPar("MV_SPEDURL","http://localhost:8080/sped"),250)
Local cModel		:= "55"


Local nZ			:= 0
Local nCount		:= 0

Local oWS

If Empty(cModalidade)    

	oWS := WsSpedCfgNFe():New()
	oWS:cUSERTOKEN := "TOTVS"
	oWS:cID_ENT    := cIdEnt
	oWS:nModalidade:= 0
	oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
	oWS:cModelo    := cModel 
	
	If oWS:CFGModalidade()
		cModalidade    := SubStr(oWS:cCfgModalidadeResult,1,1)
	Else
		cModalidade    := ""
	EndIf  
	
EndIf  
         
oWs := nil

For nZ := 1 To len(aIdNfe) 

    nCount++

	aDados := executeRetorna( aIdNfe[nZ], cIdEnt )
	
	if ( nCount == 10 )
		delClassIntF()
		nCount := 0
	endif
	
	aAdd(aRetorno,aDados)
	
Next nZ

Return(aRetorno)


Static Function ConvDate(cData)
Local dData
cData  := StrTran(cData,"-","")
dData  := Stod(cData)
Return PadR(StrZero(Day(dData),2)+ "/" + StrZero(Month(dData),2)+ "/" + StrZero(Year(dData),4),15)
  

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DANFE     �Autor  �Marcos Taranta      � Data �  10/01/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Pega uma posi��o (nTam) na string cString, e retorna o      ���
���          �caractere de espa�o anterior.                               ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function EspacoAt(cString, nTam)

Local nRetorno := 0
Local nX       := 0

/**
* Caso a posi��o (nTam) for maior que o tamanho da string, ou for um valor
* inv�lido, retorna 0.
*/
If nTam > Len(cString) .Or. nTam < 1
	nRetorno := 0
	Return nRetorno
EndIf

/**
* Procura pelo caractere de espa�o anterior a posi��o e retorna a posi��o
* dele.
*/
nX := nTam
While nX > 1
	If Substr(cString, nX, 1) == " "
		nRetorno := nX
		Return nRetorno
	EndIf
	
	nX--
EndDo

/**
* Caso n�o encontre nenhum caractere de espa�o, � retornado 0.
*/
nRetorno := 0

Return nRetorno

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � DanfeIT   � Autor � Roberto Souza        � Data � 13/08/10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Definicao do Box de Itens.                                 ���
���			 �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � FAT/FIS                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function DanfeIT(oDanfe, nLine, nBaseCol, nBaseTxt, nFolha, nFolhas, aColProd, aMensagem, nPosMsg, aTamCol)

Local nAux  := 0
Local nAux2 := 0
Local nX    := 0
Local cMVCODREG	:= Alltrim( SuperGetMV("MV_CODREG", ," ") )

oBrush := TBrush():New( , CLR_BLACK )
If nFolha == 1
	nLine -= 2
	
	nBaseTxt -= 30
	oDanfe:FillRect({nLine+455,nBaseCol,nLine+574,nBaseCol+30},oBrush)
	
	oDanfe:Say(nLine+568,nBaseTxt+7,"DADOS DO PRODUTO / SERVI�O",oFont08N:oFont, ,CLR_WHITE , 270 )
	nBaseTxt += 30 
	aColProd := {}
	nAux     := nBaseCol + 30
	AADD(aColProd, {nAux, nAux + aTamCol[1]}) //"COD. PROD"
	nAux += aTamCol[1]
	AADD(aColProd, {nAux, nAux + aTamCol[2]}) // "DESCRI��O DO PRODUTOS/SERVI�OS"
	nAux += aTamCol[2]
	AADD(aColProd, {nAux, nAux + aTamCol[3]}) // "NCM/SH"
	nAux += aTamCol[3]
	AADD(aColProd, {nAux, nAux + aTamCol[4]}) // "CST"
	nAux += aTamCol[4]
	AADD(aColProd, {nAux, nAux + aTamCol[5]}) // "CFOP"
	nAux += aTamCol[5]
	AADD(aColProd, {nAux, nAux + aTamCol[6]}) // "UN"
	nAux += aTamCol[6]
	AADD(aColProd, {nAux, nAux + aTamCol[7]}) // "QUANT."
	nAux += aTamCol[7]
	AADD(aColProd, {nAux, nAux + aTamCol[8]}) // "V.UNITARIO"
	nAux += aTamCol[8]
	AADD(aColProd, {nAux, nAux + aTamCol[9]}) // "VLR TOTAL"
	nAux += aTamCol[9]
//	AADD(aColProd, {nAux, nAux + aTamCol[10]}) // "PER DESC"
 //	nAux += aTamCol[10]
	AADD(aColProd, {nAux, nAux + aTamCol[10]}) // "VLR DESC"
	nAux += aTamCol[10]
	AADD(aColProd, {nAux, nAux + aTamCol[11]}) // "VLR LIQ"
	nAux += aTamCol[11]
	AADD(aColProd, {nAux, nAux + aTamCol[12]}) // "TOT LIQ"
	nAux += aTamCol[12]
	AADD(aColProd, {nAux, nAux + aTamCol[13]}) // "BC.ICMS"
	nAux += aTamCol[13]
	AADD(aColProd, {nAux, nAux + aTamCol[14]}) // "BC.ICMS ST"
	nAux += aTamCol[14]
	AADD(aColProd, {nAux, nAux + aTamCol[15]}) // "VLR ICMS"
	nAux += aTamCol[15]
	AADD(aColProd, {nAux, nAux + aTamCol[16]}) // "VLR ICMS ST"
	nAux += aTamCol[16]
	AADD(aColProd, {nAux, nAux + aTamCol[17]}) // "VALOR IPI"
	nAux += aTamCol[17]
	AADD(aColProd, {nAux, nAux + aTamCol[18]}) // "ICMS"
	nAux += aTamCol[18]
	AADD(aColProd, {nAux, nAux + aTamCol[19]}) // "IPI"
	
	oDanfe:Box(nLine+454,nBaseCol+31,nLine+574,MAXBOXH+70)
	nAux := nBaseCol + 30
	oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[1])
	oDanfe:Say(nLine+462, nAux + 2,"COD. PROD", oFont08N:oFont)
	nAux += aTamCol[1]
	oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[2])
	oDanfe:Say(nLine+462, nAux + 2,"DESCR PROD", oFont08N:oFont)
	nAux += aTamCol[2]
	oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[3])
	oDanfe:Say(nLine+462, nAux + 2,"NCM/SH", oFont08N:oFont)
	nAux += aTamCol[3]
	oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[4])
	If cMVCODREG == "1"
		oDanfe:Say(nLine+462, nAux + 2,"CSOSN", oFont08N:oFont)
	Else
		oDanfe:Say(nLine+462, nAux + 2,"CST", oFont08N:oFont)
	Endif
	nAux += aTamCol[4]
	oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[5])
	oDanfe:Say(nLine+462, nAux + 2,"CFOP", oFont08N:oFont)
	nAux += aTamCol[5]
	oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[6])
	oDanfe:Say(nLine+462, nAux + 2,"UN", oFont08N:oFont)
	nAux += aTamCol[6]
	oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[7])
	oDanfe:Say(nLine+462, nAux + 2,"QUANT.", oFont08N:oFont)
	nAux += aTamCol[7]
	oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[8])
	oDanfe:Say(nLine+462, nAux + 2,"V.UNITARIO", oFont08N:oFont)
	nAux += aTamCol[8]
	oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[9])
	oDanfe:Say(nLine+462, nAux + 2,"VLR TOTAL", oFont08N:oFont)
	nAux += aTamCol[9]
//	oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[10])
  //	oDanfe:Say(nLine+462, nAux + 2,"DESC", oFont08N:oFont)
//	nAux += aTamCol[10]
	oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[10])
	oDanfe:Say(nLine+462, nAux + 2,"VLR DESC", oFont08N:oFont)
	nAux += aTamCol[10]
	oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[11])
	oDanfe:Say(nLine+462, nAux + 2,"V.UNI LIQ", oFont08N:oFont)
	nAux += aTamCol[11]
	oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[12])
	oDanfe:Say(nLine+462, nAux + 2,"TOTAL LIQ", oFont08N:oFont)
	nAux += aTamCol[12]
	oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[13])
	oDanfe:Say(nLine+462, nAux + 2,"BC.ICMS", oFont08N:oFont)
	nAux += aTamCol[13]
	oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[14])
	oDanfe:Say(nLine+462, nAux + 2,"BC.ICMS ST", oFont08N:oFont)
	nAux += aTamCol[14]
	oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[15])
	oDanfe:Say(nLine+462, nAux + 2,"VLR ICMS", oFont08N:oFont)
	nAux += aTamCol[15]
	oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[16])
	oDanfe:Say(nLine+462, nAux + 2,"VLR ICMS ST", oFont08N:oFont)
	nAux += aTamCol[16]
	oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[17])
	oDanfe:Say(nLine+462, nAux + 2,"VALOR IPI", oFont08N:oFont)
	nAux  += aTamCol[17]
	nAux2 := nAux
	oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[18])
	oDanfe:Say(nLine+468, nAux + 2,"ICMS", oFont08N:oFont)
	nAux += aTamCol[18]
	oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[19])
	oDanfe:Say(nLine+468, nAux + 2,"IPI", oFont08N:oFont)
	oDanfe:Box(nLine+454, nAux2, nLine+461, nAux2 + aTamCol[18] + aTamCol[19])
	oDanfe:Say(nLine+460, nAux2 + 2,"ALIQUOTA", oFont08N:oFont)
	
	For Nx :=1 to Len(aColProd)
		oDanfe:Box(nLine+469,aColProd[nX][1],nLine+575,aColProd[nX][2])	
	Next
Else
                                  
	If nPosMsg > 0
		nLine -= 265
	
	//	nBaseTxt -= 30 
	//	oDanfe:Box(nLine+454,nBaseCol,MAXBOXV,nBaseCol+30)
		oDanfe:FillRect({nLine+455,nBaseCol,397,nBaseCol+30},oBrush)
		oDanfe:Say(360,nBaseTxt+7,"DADOS DO PRODUTO / SERVI�O",oFont08N:oFont, , CLR_WHITE, 270 )
		nBaseTxt += 30 
		aColProd := {}
		nAux     := nBaseCol + 30
		AADD(aColProd, {nAux, nAux + aTamCol[1]}) //"COD. PROD"
		nAux += aTamCol[1]
		AADD(aColProd, {nAux, nAux + aTamCol[2]}) // "DESCRI��O DO PRODUTOS/SERVI�OS"
		nAux += aTamCol[2]
		AADD(aColProd, {nAux, nAux + aTamCol[3]}) // "NCM/SH"
		nAux += aTamCol[3]
		AADD(aColProd, {nAux, nAux + aTamCol[4]}) // "CST"
		nAux += aTamCol[4]
		AADD(aColProd, {nAux, nAux + aTamCol[5]}) // "CFOP"
		nAux += aTamCol[5]
		AADD(aColProd, {nAux, nAux + aTamCol[6]}) // "UN"
		nAux += aTamCol[6]
		AADD(aColProd, {nAux, nAux + aTamCol[7]}) // "QUANT."
		nAux += aTamCol[7]
		AADD(aColProd, {nAux, nAux + aTamCol[8]}) // "V.UNITARIO"
		nAux += aTamCol[8]
		AADD(aColProd, {nAux, nAux + aTamCol[9]}) // "VLR TOTAL"
		nAux += aTamCol[9]
		//AADD(aColProd, {nAux, nAux + aTamCol[10]}) // "PER DESC"
		//nAux += aTamCol[10]
		AADD(aColProd, {nAux, nAux + aTamCol[10]}) // "VLR DESC"
		nAux += aTamCol[10]
		AADD(aColProd, {nAux, nAux + aTamCol[11]}) // "VLR LIQ"
		nAux += aTamCol[11]
		AADD(aColProd, {nAux, nAux + aTamCol[12]}) // "TOT LIQ"
		nAux += aTamCol[12]
		AADD(aColProd, {nAux, nAux + aTamCol[13]}) // "BC.ICMS"
		nAux += aTamCol[13]
		AADD(aColProd, {nAux, nAux + aTamCol[14]}) // "BC.ICMS ST"
		nAux += aTamCol[14]
		AADD(aColProd, {nAux, nAux + aTamCol[15]}) // "VLR ICMS"
		nAux += aTamCol[15]
		AADD(aColProd, {nAux, nAux + aTamCol[16]}) // "VLR ICMS ST"
		nAux += aTamCol[16]
		AADD(aColProd, {nAux, nAux + aTamCol[17]}) // "VALOR IPI"
		nAux += aTamCol[17]
		AADD(aColProd, {nAux, nAux + aTamCol[18]}) // "ICMS"
		nAux += aTamCol[18]
		AADD(aColProd, {nAux, nAux + aTamCol[19]}) // "IPI"
	
		oDanfe:Box(nLine+454,nBaseCol+31,398,MAXBOXH+70)
		nAux := nBaseCol + 30
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[1])
		oDanfe:Say(nLine+462, nAux + 2,"COD. PROD", oFont08N:oFont)
		nAux += aTamCol[1]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[2])
		oDanfe:Say(nLine+462, nAux + 2,"DESCR PROD", oFont08N:oFont)
		nAux += aTamCol[2]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[3])
		oDanfe:Say(nLine+462, nAux + 2,"NCM/SH", oFont08N:oFont)
		nAux += aTamCol[3]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[4])

		If cMVCODREG == "1"
			oDanfe:Say(nLine+462, nAux + 2,"CSOSN", oFont08N:oFont)
		Else
			oDanfe:Say(nLine+462, nAux + 2,"CST", oFont08N:oFont)
		Endif
		nAux += aTamCol[4]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[5])
		oDanfe:Say(nLine+462, nAux + 2,"CFOP", oFont08N:oFont)
		nAux += aTamCol[5]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[6])
		oDanfe:Say(nLine+462, nAux + 2,"UN", oFont08N:oFont)
		nAux += aTamCol[6]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[7])
		oDanfe:Say(nLine+462, nAux + 2,"QUANT.", oFont08N:oFont)
		nAux += aTamCol[7]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[8])
		oDanfe:Say(nLine+462, nAux + 2,"V.UNITARIO", oFont08N:oFont)
		nAux += aTamCol[8]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[9])
		oDanfe:Say(nLine+462, nAux + 2,"VLR TOTAL", oFont08N:oFont)
		nAux += aTamCol[9]
//		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[10])
//		oDanfe:Say(nLine+462, nAux + 2,"DESC", oFont08N:oFont)
//		nAux += aTamCol[10]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[10])
		oDanfe:Say(nLine+462, nAux + 2,"VLR DESC", oFont08N:oFont)
		nAux += aTamCol[10]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[11])
		oDanfe:Say(nLine+462, nAux + 2,"V.UNI LIQ", oFont08N:oFont)
		nAux += aTamCol[11]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[12])
		oDanfe:Say(nLine+462, nAux + 2,"TOTAL LIQ", oFont08N:oFont)
		nAux += aTamCol[12]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[13])
		oDanfe:Say(nLine+462, nAux + 2,"BC.ICMS", oFont08N:oFont)
		nAux += aTamCol[13]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[14])
		oDanfe:Say(nLine+462, nAux + 2,"BC.ICMS ST", oFont08N:oFont)
		nAux += aTamCol[14]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[15])
		oDanfe:Say(nLine+462, nAux + 2,"VLR ICMS", oFont08N:oFont)
		nAux += aTamCol[15]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[16])
		oDanfe:Say(nLine+462, nAux + 2,"VLR ICMS ST", oFont08N:oFont)
		nAux += aTamCol[16]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[17])
		oDanfe:Say(nLine+462, nAux + 2,"VALOR IPI", oFont08N:oFont)
		nAux  += aTamCol[17]
		nAux2 := nAux
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[18])
		oDanfe:Say(nLine+468, nAux + 2,"ICMS", oFont08N:oFont)
		nAux += aTamCol[18]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[19])
		oDanfe:Say(nLine+468, nAux + 2,"IPI", oFont08N:oFont)
		oDanfe:Box(nLine+454, nAux2, nLine+461, nAux2 + aTamCol[18] + aTamCol[19])
		oDanfe:Say(nLine+460, nAux2 + 2,"ALIQUOTA", oFont08N:oFont)
		
		For Nx :=1 to Len(aColProd)
			oDanfe:Box(nLine+469,aColProd[nx][1],398,aColProd[nx][2])	
		Next
		nLine -= 257

	Else 
	
		nLine -= 265
	
	//	nBaseTxt -= 30 
	//	oDanfe:Box(nLine+454,nBaseCol,MAXBOXV,nBaseCol+30)
		oDanfe:FillRect({nLine+455,nBaseCol,MAXBOXV-1,nBaseCol+30},oBrush)
		oDanfe:Say(nLine+768,nBaseTxt+7,"DADOS DO PRODUTO / SERVI�O",oFont08N:oFont, , CLR_WHITE, 270 )
		nBaseTxt += 30 
		aColProd := {}
		nAux     := nBaseCol + 30
		AADD(aColProd, {nAux, nAux + aTamCol[1]}) //"COD. PROD"
		nAux += aTamCol[1]
		AADD(aColProd, {nAux, nAux + aTamCol[2]}) // "DESCRI��O DO PRODUTOS/SERVI�OS"
		nAux += aTamCol[2]
		AADD(aColProd, {nAux, nAux + aTamCol[3]}) // "NCM/SH"
		nAux += aTamCol[3]
		AADD(aColProd, {nAux, nAux + aTamCol[4]}) // "CST"
		nAux += aTamCol[4]
		AADD(aColProd, {nAux, nAux + aTamCol[5]}) // "CFOP"
		nAux += aTamCol[5]
		AADD(aColProd, {nAux, nAux + aTamCol[6]}) // "UN"
		nAux += aTamCol[6]
		AADD(aColProd, {nAux, nAux + aTamCol[7]}) // "QUANT."
		nAux += aTamCol[7]
		AADD(aColProd, {nAux, nAux + aTamCol[8]}) // "V.UNITARIO"
		nAux += aTamCol[8]
		AADD(aColProd, {nAux, nAux + aTamCol[9]}) // "VLR TOTAL"
		nAux += aTamCol[9]
		//AADD(aColProd, {nAux, nAux + aTamCol[10]}) // "PER DESC"
		//nAux += aTamCol[10]
		AADD(aColProd, {nAux, nAux + aTamCol[10]}) // "VLR DESC"
		nAux += aTamCol[10]
		AADD(aColProd, {nAux, nAux + aTamCol[11]}) // "VLR LIQ"
		nAux += aTamCol[11]
		AADD(aColProd, {nAux, nAux + aTamCol[12]}) // "TOT LIQ"
		nAux += aTamCol[12]
		AADD(aColProd, {nAux, nAux + aTamCol[13]}) // "BC.ICMS"
		nAux += aTamCol[13]
		AADD(aColProd, {nAux, nAux + aTamCol[14]}) // "BC.ICMS ST"
		nAux += aTamCol[14]
		AADD(aColProd, {nAux, nAux + aTamCol[15]}) // "VLR ICMS"
		nAux += aTamCol[15]
		AADD(aColProd, {nAux, nAux + aTamCol[16]}) // "VLR ICMS ST"
		nAux += aTamCol[16]
		AADD(aColProd, {nAux, nAux + aTamCol[17]}) // "VALOR IPI"
		nAux += aTamCol[17]
		AADD(aColProd, {nAux, nAux + aTamCol[18]}) // "ICMS"
		nAux += aTamCol[18]
		AADD(aColProd, {nAux, nAux + aTamCol[19]}) // "IPI"
	   
		oDanfe:Box(nLine+454,nBaseCol+31,nLine+675,MAXBOXH+70)
	
		nAux := nBaseCol + 30
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[1])
		oDanfe:Say(nLine+462, nAux + 2,"COD. PROD", oFont08N:oFont)
		nAux += aTamCol[1]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[2])
		oDanfe:Say(nLine+462, nAux + 2,"DESCR PROD", oFont08N:oFont)
		nAux += aTamCol[2]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[3])
		oDanfe:Say(nLine+462, nAux + 2,"NCM/SH", oFont08N:oFont)
		nAux += aTamCol[3]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[4])

		If cMVCODREG == "1"
			oDanfe:Say(nLine+462, nAux + 2,"CSOSN", oFont08N:oFont)
		Else
			oDanfe:Say(nLine+462, nAux + 2,"CST", oFont08N:oFont)
		Endif
		nAux += aTamCol[4]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[5])
		oDanfe:Say(nLine+462, nAux + 2,"CFOP", oFont08N:oFont)
		nAux += aTamCol[5]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[6])
		oDanfe:Say(nLine+462, nAux + 2,"UN", oFont08N:oFont)
		nAux += aTamCol[6]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[7])
		oDanfe:Say(nLine+462, nAux + 2,"QUANT.", oFont08N:oFont)
		nAux += aTamCol[7]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[8])
		oDanfe:Say(nLine+462, nAux + 2,"V.UNITARIO", oFont08N:oFont)
		nAux += aTamCol[8]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[9])
		oDanfe:Say(nLine+462, nAux + 2,"VLR TOTAL", oFont08N:oFont)
		nAux += aTamCol[9]
		//oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[10])
		//oDanfe:Say(nLine+462, nAux + 2,"DESC", oFont08N:oFont)
		//nAux += aTamCol[10]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[10])
		oDanfe:Say(nLine+462, nAux + 2,"VLR DESC", oFont08N:oFont)
		nAux += aTamCol[10]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[11])
		oDanfe:Say(nLine+462, nAux + 2,"V.UNI LIQ", oFont08N:oFont)
		nAux += aTamCol[11]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[12])
		oDanfe:Say(nLine+462, nAux + 2,"TOTAL LIQ", oFont08N:oFont)
		nAux += aTamCol[12]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[13])
		oDanfe:Say(nLine+462, nAux + 2,"BC.ICMS", oFont08N:oFont)
		nAux += aTamCol[13]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[14])
		oDanfe:Say(nLine+462, nAux + 2,"BC.ICMS ST", oFont08N:oFont)
		nAux += aTamCol[14]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[15])
		oDanfe:Say(nLine+462, nAux + 2,"VLR ICMS", oFont08N:oFont)
		nAux += aTamCol[15]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[16])
		oDanfe:Say(nLine+462, nAux + 2,"VLR ICMS ST", oFont08N:oFont)
		nAux += aTamCol[16]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[17])
		oDanfe:Say(nLine+462, nAux + 2,"VALOR IPI", oFont08N:oFont)
		nAux  += aTamCol[17]
		nAux2 := nAux
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[18])
		oDanfe:Say(nLine+468, nAux + 2,"ICMS", oFont08N:oFont)
		nAux += aTamCol[18]
		oDanfe:Box(nLine+454, nAux, nLine+469, nAux + aTamCol[19])
		oDanfe:Say(nLine+468, nAux + 2,"IPI", oFont08N:oFont)
		oDanfe:Box(nLine+454, nAux2, nLine+461, nAux2 + aTamCol[18] + aTamCol[19])
		oDanfe:Say(nLine+460, nAux2 + 2,"ALIQUOTA", oFont08N:oFont)
				
		For Nx :=1 to Len(aColProd)
			oDanfe:Box(nLine+469,aColProd[nx][1],MAXBOXV,aColProd[nx][2])	
		Next
		nLine -= 257	
		
	EndIf	

EndIf


Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � DanfeInfC � Autor � Roberto Souza        � Data � 13/08/10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Definicao do Box de Informa��es complementares.            ���
���			 �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � FAT/FIS                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function DanfeInfC(oDanfe,aMensagem,nBaseTxt,nBaseCol,nLine,nPosMsg, nFolha,lComplemento )

local cLogoTotvs := "Powered_by_TOTVS.bmp"
local cStartPath := GetSrvProfString("Startpath","")
Local Nx:= 0
Local Nw:= 0
local nPosAdicionais := 0
default lComplemento := .F.
oBrush := TBrush():New( , CLR_BLACK )

If nFolha ==1

	nBaseTxt -= 30 
	//oDanfe:Box(nLine+597,nBaseCol,MAXBOXV,nBaseCol+30)
	oDanfe:FillRect({nLine+598,nBaseCol,MAXBOXV-1,nBaseCol+30},oBrush)
	oBrush:End()
	
	oDanfe:Say(MAXBOXV-25,nBaseTxt+1,"DADOS",oFont08N:oFont, , CLR_WHITE, 270 )
	oDanfe:Say(MAXBOXV-13,nBaseTxt+11,"ADICIONAIS"    ,oFont08N:oFont, ,CLR_WHITE , 270 )
	nBaseTxt += 30 
	
	oDanfe:Box(nLine+597,nBaseCol+30,MAXBOXV,622)
	oDanfe:Say(nLine+606,nBaseTxt,"INFORMA��ES COMPLEMENTARES",oFont08N:oFont)
	
	
	nLenMensagens:= Len(aMensagem)
	nLin:= nLine+618
	
	For nX := 1 To Min(nLenMensagens, MAXMSG)
		oDanfe:Say(nLin,nBaseTxt,aMensagem[nX],oFont07:oFont)
		nLin:= nLin+10
	Next nX
	
	If Nx <= nLenMensagens 
		nPosMsg := Nx
	EndIf 
	
	oDanfe:Box(nLine+597,622,MAXBOXV,MAXBOXH+70)
	oDanfe:Say(nLine+606,632,"RESERVADO AO FISCO",oFont08N:oFont)

	//������������������������������������������������������������������������Ŀ
	//�Logotipo Rodape
	//��������������������������������������������������������������������������												
	if file(cLogoTotvs) .or. Resource2File ( cLogoTotvs, cStartPath+cLogoTotvs )
		oDanfe:SayBitmap(MAXBOXV+1,752,cLogoTotvs,120,20)
	endif	
	nLenMensagens:= Len(aResFisco)
	nLin:= nLine+618   
	For nX := 1 To Min(nLenMensagens, MAXMSG)
  		oDanfe:Say(nLin,632,aResFisco[nX],oFont08:oFont)
  		nLin:= nLin+10
	Next

ElseIf nFolha == 2

	if lComplemento
		nLine -= 208
		nBaseTxt +=30 
		nPosAdicionais := MAXBOXV-239 
	else	
		nLine :=  0
		nPosAdicionais := MAXBOXV-25
	endif	
	
	nBaseTxt -= 30 
	oDanfe:Box(nLine+597,nBaseCol,MAXBOXV,nBaseCol+30)
	oDanfe:FillRect({nLine+398,nBaseCol,MAXBOXV-1,nBaseCol+30},oBrush)
	oBrush:End()
	
	oDanfe:Say(nPosAdicionais,nBaseTxt+1,"DADOS",oFont08N:oFont, ,CLR_WHITE,270)
	oDanfe:Say(nPosAdicionais+12,nBaseTxt+11,"ADICIONAIS"    ,oFont08N:oFont, ,CLR_WHITE , 270 )
	nBaseTxt += 30 
	
	oDanfe:Box(nLine+397,nBaseCol+30,MAXBOXV,622)
	if lComplemento
		nBaseTxt += 30
	endif
	oDanfe:Say(nLine+406,nBaseTxt,"INFORMA��ES COMPLEMENTARES",oFont08N:oFont)
	
	
	nLenMensagens:= Len(aMensagem)
	nLin:= nLine+416
	
	For nX := nPosMsg To nLenMensagens
		oDanfe:Say(nLin,nBaseTxt,aMensagem[nX],oFont07:oFont)
		nLin:= nLin+10
		Nw++
		If Nw >= MAXMSG2
			Exit
		EndIf	
	Next nX
	
	nPosMsg := 0
	
	oDanfe:Box(nLine+397,622,MAXBOXV,MAXBOXH+70)
	oDanfe:Say(nLine+406,632,"RESERVADO AO FISCO",oFont08N:oFont)

	//������������������������������������������������������������������������Ŀ
	//�Logotipo Rodape
	//��������������������������������������������������������������������������												
	if file(cLogoTotvs) .or. Resource2File ( cLogoTotvs, cStartPath+cLogoTotvs )
		oDanfe:SayBitmap(MAXBOXV+1,752,cLogoTotvs,120,20)
	endif	
EndIf	
Return() 

 /*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DANFE     �Autor  �Fabio Santana	     � Data �  04/10/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Converte caracteres espceiais						          ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

STATIC FUNCTION NoChar(cString,lConverte) 

Default lConverte := .F.

If lConverte
	cString := (StrTran(cString,"&lt;","<"))  
	cString := (StrTran(cString,"&gt;",">"))
	cString := (StrTran(cString,"&amp;","&"))
	cString := (StrTran(cString,"&quot;",'"'))
	cString := (StrTran(cString,"&#39;","'"))
EndIf	
		
Return(cString)	


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DANFEIII  �Autor  �Microsiga           � Data �  12/17/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION MaxCod(cString,nTamanho)

//�������������������������������������������������������������Ŀ
//�Tratamento para saber quantos caracteres ir�o caber na linha �
//� visto que letras ocupam mais espa�o do que os n�meros.      �
//���������������������������������������������������������������

Local nMax	:= 0
Local nY   	:= 0
Default nTamanho := 40

For nMax := 1 to Len(cString)
	If IsAlpha(SubStr(cString,nMax,1)) .And. SubStr(cString,nMax,1) $ "MOQW"  // Caracteres que ocupam mais espa�o em pixels
		nY += 7
	Else
		nY += 5
	EndIf
	
	If nY > nTamanho   // � o m�ximo de espa�o para uma coluna
		nMax--
		Exit		
	EndIf
Next

Return nMax

//-----------------------------------------------------------------------
/*/{Protheus.doc} RetTamCol
Retorna um array do mesmo tamanho do array de entrada, contendo as
medidas dos maiores textos para c�lculo de colunas.

@author Marcos Taranta
@since 24/05/2011
@version 1.0 

@param  aCabec     Array contendo as strings de cabe�alho das colunas
        aValores   Array contendo os valores que ser�o populados nas
                   colunas.
        oPrinter   Objeto de impress�o instanciado para utilizar o m�todo
                   nativo de c�lculo de tamanho de texto.
        oFontCabec Objeto da fonte que ser� utilizada no cabe�alho.
        oFont      Objeto da fonte que ser� utilizada na impress�o.

@return aTamCol  Array contendo os tamanhos das colunas baseados nos
                 valores.
/*/
//-----------------------------------------------------------------------
Static Function RetTamCol(aCabec, aValores, oPrinter, oFontCabec, oFont)
	
	Local aTamCol    := {}
	Local nAux       := 0

	Local nX         := 0
	Local nY         := 0
	Local oFontSize  := FWFontSize():new()
	
	For nX := 1 To Len(aCabec)
		
		AADD(aTamCol, {})
		//aTamCol[nX] := Round(oPrinter:GetTextWidth(aCabec[nX], oFontCabec) * nConsNeg + 2, 0)
		aTamCol[nX] := oFontSize:getTextWidth( alltrim(aCabec[nX]), oFontCabec:Name, oFontCabec:nWidth, oFontCabec:Bold, oFontCabec:Italic )
	Next nX
	
	For nX := 1 To Len(aValores[1])
		
		nAux := 0
		
		For nY := 1 To Len(aValores[1][nX])
			
			If (oPrinter:GetTextWidth(aValores[1][nX][nY], oFont) * nConsTex + 2) > nAux
				//nAux := Round(oPrinter:GetTextWidth(aValores[1][nX][nY], oFont) * nConsTex + 2, 0)
				nAux := oFontSize:getTextWidth( Alltrim(aValores[1][nX][nY]), oFontCabec:Name, oFontCabec:nWidth, oFontCabec:Bold, oFontCabec:Italic )+ 7
			EndIf
			
		Next nY
		
		If aTamCol[nX] < nAux
			aTamCol[nX] := nAux
		EndIf
		
	Next nX
	
	// Workaround para o m�todo FWMSPrinter:GetTextWidth() na coluna UN
	aTamCol[6] += 5
	
	// Checa se os campos completam a p�gina, sen�o joga o resto na coluna da
	//   descri��o de produtos/servi�os
	nAux := 0
	For nX := 1 To Len(aTamCol)
		
		nAux += aTamCol[nX]
		
	Next nX
	If nAux < MAXBOXH
		aTamCol[2] += MAXBOXH - 30 - nAux
	EndIf
   	If nAux > MAXBOXH               
		aTamCol[2] -= nAux - MAXBOXH - 30
	EndIf

Return aTamCol

//-----------------------------------------------------------------------
/*/{Protheus.doc} RetTamTex
Retorna o tamanho em pixels de uma string. (Workaround para o GetTextWidth)

@author Marcos Taranta
@since 24/05/2011
@version 1.0 

@param  cTexto   Texto a ser medido.
        oFont    Objeto instanciado da fonte a ser utilizada.
        oPrinter Objeto de impress�o instanciado.

@return nTamanho Tamanho em pixels da string.
/*/
//-----------------------------------------------------------------------
Static Function RetTamTex(cTexto, oFont, oPrinter)
	
	Local nTamanho := 0
	//Local oFontSize:= FWFontSize():new()
	Local cAux := ""
		
	Local cValor := "0123456789"
	Local cVirgPonto := ",."
	Local cPerc := "%"	
	Local nX := 0
	
	//nTamanho := oPrinter:GetTextWidth(cTexto, oFont)
	//nTamanho := oFontSize:getTextWidth( cTexto, oFont:Name, oFont:nWidth, oFont:Bold, oFont:Italic )
	/*O calculo abaixo � o mesmo realizado pela oFontSize:getTextWidth
	Retorna 5 para numeros (0123456789), 2 para virgula e ponto (, .) e 7 para percentual (%)
	O ajuste foi realizado para diminuir o tempo na impress�o de um danfe com muitos itens*/
	For nX:= 1 to len(cTexto)
		cAux:= Substr(cTexto,nX,1)
		If cAux $ cValor
			nTamanho += 5
		ElseIf cAux $ cVirgPonto
			nTamanho += 2
		ElseIf cAux $ cPerc
			nTamanho += 7
		EndIf		
	Next nX
	
	nTamanho := Round(nTamanho, 0)
	
Return nTamanho

//-----------------------------------------------------------------------
/*/{Protheus.doc} PosQuebrVal
Retorna a posi��o onde um valor deve ser quebrado

@author Marcos Taranta
@since 27/05/2011
@version 1.0 

@param  cTexto Texto a ser medido.

@return nPos   Posi��o aonde o valor deve ser quebrado.
/*/
//-----------------------------------------------------------------------
Static Function PosQuebrVal(cTexto)
	
	Local nPos := 0
	
	If Empty(cTexto)
		Return 0
	EndIf
	
	If Len(cTexto) <= MAXVALORC
		Return Len(cTexto)
	EndIf
	
	If SubStr(cTexto, MAXVALORC, 1) $ ",."
		nPos := MAXVALORC - 2
	Else
		nPos := MAXVALORC
	EndIf
	
Return nPos
//-----------------------------------------------------------------------
/*/{Protheus.doc} executeRetorna
Executa o retorna de notas

@author Henrique Brugugnoli
@since 17/01/2013
@version 1.0 

@param  cID ID da nota que sera retornado

@return aRetorno   Array com os dados da nota
/*/
//-----------------------------------------------------------------------
static function executeRetorna( aNfe, cIdEnt, lUsacolab )

Local aExecute		:= {}  
Local aFalta		:= {}
Local aResposta		:= {}
Local aRetorno		:= {}
Local aDados		:= {} 
Local aIdNfe		:= {}

Local cAviso		:= "" 
Local cDHRecbto		:= ""
Local cDtHrRec		:= ""
Local cDtHrRec1		:= ""
Local cErro			:= "" 
Local cModTrans		:= ""
Local cProtDPEC		:= ""
Local cProtocolo	:= ""
Local cRetDPEC		:= ""
Local cRetorno		:= ""
Local cCodRetNFE	:= ""
Local cMsgNFE		:=	""
Local cURL			:= PadR(GetNewPar("MV_SPEDURL","http://localhost:8080/sped"),250)
Local cModel		:= "55"

Local dDtRecib		:= CToD("")

Local lFlag			:= .T.

Local nDtHrRec1		:= 0
Local nL			:= 0
Local nX			:= 0
Local nY			:= 0
Local nZ			:= 1
Local nCount		:= 0
Local nLenNFe
Local nLenWS

Local oWS

Private oDHRecbto
Private oNFeRet
Private oDoc

default lUsacolab	:= .F.
aAdd(aIdNfe,aNfe)

if !lUsacolab

	oWS:= WSNFeSBRA():New()
	oWS:cUSERTOKEN        := "TOTVS"
	oWS:cID_ENT           := cIdEnt
	oWS:nDIASPARAEXCLUSAO := 0
	oWS:_URL 			  := AllTrim(cURL)+"/NFeSBRA.apw"
	oWS:oWSNFEID          := NFESBRA_NFES2():New()
	oWS:oWSNFEID:oWSNotas := NFESBRA_ARRAYOFNFESID2():New()  
	
	aadd(aRetorno,{"","",aIdNfe[nZ][4]+aIdNfe[nZ][5],"","","",CToD(""),"","",""})
	
	aadd(oWS:oWSNFEID:oWSNotas:oWSNFESID2,NFESBRA_NFESID2():New())
	Atail(oWS:oWSNFEID:oWSNotas:oWSNFESID2):cID := aIdNfe[nZ][4]+aIdNfe[nZ][5]
	
	If oWS:RETORNANOTASNX()
		If Len(oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5) > 0
			For nX := 1 To Len(oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5)
				cRetorno        := oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:oWSNFE:CXML
				cProtocolo      := oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:oWSNFE:CPROTOCOLO								
				cDHRecbto  		:= oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:oWSNFE:CXMLPROT
				oNFeRet			:= XmlParser(cRetorno,"_",@cAviso,@cErro)
				cModTrans		  := IIf(Type("oNFeRet:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT") <> "U",IIf (!Empty("oNFeRet:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT"),oNFeRet:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT,1),1)
				If ValType(oWs:OWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:OWSDPEC)=="O"
					cRetDPEC        := oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:oWSDPEC:CXML
					cProtDPEC       := oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:oWSDPEC:CPROTOCOLO
				EndIf
				
	
				//Tratamento para gravar a hora da transmissao da NFe
				If !Empty(cProtocolo)
					oDHRecbto		:= XmlParser(cDHRecbto,"","","")
					cDtHrRec		:= IIf(Type("oDHRecbto:_ProtNFE:_INFPROT:_DHRECBTO:TEXT")<>"U",oDHRecbto:_ProtNFE:_INFPROT:_DHRECBTO:TEXT,"")
					nDtHrRec1		:= RAT("T",cDtHrRec)
					
					If nDtHrRec1 <> 0
						cDtHrRec1   :=	SubStr(cDtHrRec,nDtHrRec1+1)
						dDtRecib	:=	SToD(StrTran(SubStr(cDtHrRec,1,AT("T",cDtHrRec)-1),"-",""))
					EndIf
					
					AtuSF2Hora(cDtHrRec1,aIdNFe[nZ][5]+aIdNFe[nZ][4]+aIdNFe[nZ][6]+aIdNFe[nZ][7])
					
				EndIf
	
				nY := aScan(aIdNfe,{|x| x[4]+x[5] == SubStr(oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:CID,1,Len(x[4]+x[5]))})
	
				oWS:cIdInicial    := aIdNfe[nZ][4]+aIdNfe[nZ][5]
				oWS:cIdFinal      := aIdNfe[nZ][4]+aIdNfe[nZ][5]
				If oWS:MONITORFAIXA()
					cCodRetNFE := oWS:oWsMonitorFaixaResult:OWSMONITORNFE[1]:OWSERRO:OWSLOTENFE[len(oWS:oWsMonitorFaixaResult:OWSMONITORNFE[1]:OWSERRO:OWSLOTENFE)]:CCODRETNFE
					cMsgNFE	:= oWS:oWsMonitorFaixaResult:OWSMONITORNFE[1]:OWSERRO:OWSLOTENFE[len(oWS:oWsMonitorFaixaResult:OWSMONITORNFE[1]:OWSERRO:OWSLOTENFE)]:CMSGRETNFE
				EndIf
	
				If nY > 0
					aRetorno[nY][1] := cProtocolo
					aRetorno[nY][2] := cRetorno
					aRetorno[nY][4] := cRetDPEC
					aRetorno[nY][5] := cProtDPEC
					aRetorno[nY][6] := cDtHrRec1
					aRetorno[nY][7] := dDtRecib
					aRetorno[nY][8] := cModTrans
					aRetorno[nY][9] := cCodRetNFE
					aRetorno[nY][10]:= cMsgNFE
					
					//aadd(aResposta,aIdNfe[nY])
				EndIf
				cRetDPEC := ""
				cProtDPEC:= ""
			Next nX
			/*For nX := 1 To Len(aIdNfe)
				If aScan(aResposta,{|x| x[4] == aIdNfe[nX,04] .And. x[5] == aIdNfe[nX,05] })==0
				
					conout("Falta")
					conout(aIdNfe[nX][4]+" - "+aIdNfe[nX][5])
					aadd(aFalta,aIdNfe[nX])
				EndIf
			Next nX
			If Len(aFalta)>0
				aExecute := GetXML(cIdEnt,aFalta,@cModalidade)
			Else
				aExecute := {}
			EndIf*/
			/*For nX := 1 To Len(aExecute)
				nY := aScan(aRetorno,{|x| x[3] == aExecute[nX][03]})
				If nY == 0
					aadd(aRetorno,{aExecute[nX][01],aExecute[nX][02],aExecute[nX][03]})
				Else
					aRetorno[nY][01] := aExecute[nX][01]
					aRetorno[nY][02] := aExecute[nX][02]
				EndIf
			Next nX*/
		EndIf
	Else
		Aviso("DANFE",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3)
	EndIf 
else
	oDoc 			:= ColaboracaoDocumentos():new()		
	oDoc:cModelo	:= "NFE"
	oDoc:cTipoMov	:= "1"									
	oDoc:cIDERP	:= aIdNfe[nZ][4]+aIdNfe[nZ][5]+FwGrpCompany()+FwCodFil()
	
	aadd(aRetorno,{"","",aIdNfe[nZ][4]+aIdNfe[nZ][5],"","","",CToD(""),"","",""})
	
	if odoc:consultar()
		aDados := ColDadosNf(1)
		
		if !Empty(oDoc:cXMLRet)
			cRetorno	:= oDoc:cXMLRet 
		else
			cRetorno	:= oDoc:cXml
		endif
		
		aDadosXml := ColDadosXMl(cRetorno, aDados, @cErro, @cAviso)
		if '<obsCont xCampo="nRegDPEC">' $ cRetorno
			aDadosXml[9] := SubStr(cRetorno,At('<obsCont xCampo="nRegDPEC"><xTexto>',cRetorno)+35,15)
		endif	
		
		cProtocolo		:= aDadosXml[3]		
		cModTrans		:= IIF(Empty(aDadosXml[5]),aDadosXml[7],aDadosXml[5])
		cCodRetNFE	:= aDadosXml[1]
		cMsgNFE 	:= aDadosXml[2]			
		
		//Dados do DEPEC
		If !Empty( aDadosXml[9] )
			cRetDPEC        := cRetorno
			cProtDPEC       := aDadosXml[9] 
		EndIf
		
		//Tratamento para gravar a hora da transmissao da NFe
		If !Empty(cProtocolo)
			cDtHrRec		:= aDadosXml[4]
			nDtHrRec1		:= RAT("T",cDtHrRec)
			
			If nDtHrRec1 <> 0
				cDtHrRec1   :=	SubStr(cDtHrRec,nDtHrRec1+1)
				dDtRecib	:=	SToD(StrTran(SubStr(cDtHrRec,1,AT("T",cDtHrRec)-1),"-",""))
			EndIf
			
			AtuSF2Hora(cDtHrRec1,aIdNFe[nZ][5]+aIdNFe[nZ][4]+aIdNFe[nZ][6]+aIdNFe[nZ][7])
			
		EndIf
		//Altero o cRetorno para o XML padr�o que foi enviado.
		cRetorno := oDoc:cXml

		aRetorno[1][1] := cProtocolo
		aRetorno[1][2] := cRetorno
		aRetorno[1][4] := cRetDPEC
		aRetorno[1][5] := cProtDPEC
		aRetorno[1][6] := cDtHrRec1
		aRetorno[1][7] := dDtRecib
		aRetorno[1][8] := cModTrans
		aRetorno[1][9] := cCodRetNFE
		aRetorno[1][10]:= cMsgNFE
								
		cRetDPEC := ""
		cProtDPEC:= ""		
				
	endif
endif

oWS       := Nil
oDHRecbto := Nil
oNFeRet   := Nil

return aRetorno[len(aRetorno)]
static function getXMLColab(aIdNFe,cModalidade,lUsaColab)

local nZ			:= 0
local nCount		:= 0

local cIdEnt 		:= "000000"

local aDados		:= {}
local aRetorno	:= {}



If Empty(cModalidade)
	cModalidade := ColGetPar( "MV_MODALID", "1" )	
EndIf  
         

For nZ := 1 To len(aIdNfe) 

	nCount++

	aDados := executeRetorna( aIdNfe[nZ], cIdEnt, lUsaColab )
	
	if ( nCount == 10 )
		delClassIntF()
		nCount := 0
	endif
	
	aAdd(aRetorno,aDados)
	
Next nZ

Return(aRetorno)

static function atuSf2Hora( cDtHrRec,cSeek )

local aArea := GetArea()
 
dbSelectArea("SF2")
dbSetOrder(1)
If MsSeek(xFilial("SF2")+cSeek)
	If SF2->(FieldPos("F2_HORA"))<>0 .And. Empty(SF2->F2_HORA)
		RecLock("SF2")
		SF2->F2_HORA := cDtHrRec
		MsUnlock()
	EndIf
EndIf
dbSelectArea("SF1")
dbSetOrder(1)
If MsSeek(xFilial("SF1")+cSeek)
	If SF1->(FieldPos("F1_HORA"))<>0 .And. Empty(SF1->F1_HORA)
		RecLock("SF1")
		SF1->F1_HORA := cDtHrRec
		MsUnlock()
	EndIf
EndIf

RestArea(aArea)

return nil

//-----------------------------------------------------------------------
/*/{Protheus.doc} ColDadosNf
Devolve os dados com a informa��o desejada conforme par�metro nInf.
 
@author 	Rafel Iaquinto
@since 		30/07/2014
@version 	11.9
 
@param	nInf, inteiro, Codigo da informa��o desejada:<br>1 - Normal<br>2 - Cancelametno<br>3 - Inutiliza��o						

@return aRetorno Array com as posi��es do XML desejado, sempre deve retornar a mesma quantidade de posi��es.
/*/
//-----------------------------------------------------------------------
static function ColDadosNf(nInf)

local aDados	:= {}

	do case
		case nInf == 1
			//Informa�oes da NF-e
			aadd(aDados,"NFEPROC|PROTNFE|INFPROT|CSTAT") //1 - Codigo Status documento 
			aadd(aDados,"NFEPROC|PROTNFE|INFPROT|XMOTIVO") //2 - Motivo do status
			aadd(aDados,"NFEPROC|PROTNFE|INFPROT|NPROT")	//3 - Protocolo Autporizacao		
			aadd(aDados,"NFEPROC|PROTNFE|INFPROT|DHRECBTO")	//4 - Data e hora de recebimento					
			aadd(aDados,"NFEPROC|NFE|INFNFE|IDE|TPEMIS") //5 - Tipo de Emissao
			aadd(aDados,"NFEPROC|NFE|INFNFE|IDE|TPAMB") //6 - Ambiente de transmiss�o		
			aadd(aDados,"NFE|INFNFE|IDE|TPEMIS") //7 - Tipo de Emissao - Caso nao tenha retorno
			aadd(aDados,"NFE|INFNFE|IDE|TPAMB") //8 - Ambiente de transmiss�o -  Caso nao tenha retorno			
			aadd(aDados,"NFEPROC|RETDEPEC|INFDPECREG|NREGDPEC") //9 - Numero de autoriza��o DPEC
			aadd(aDados,"NFEPROC|PROTNFE|INFPROT|CHNFE") //10 - Chave da autorizacao
		
		case nInf == 2	
			//Informacoes do cancelamento - evento
			aadd(aDados,"PROCEVENTONFE|RETEVENTO|INFEVENTO|CSTAT") //1 - Codigo Status documento 
			aadd(aDados,"PROCEVENTONFE|RETEVENTO|INFEVENTO|XMOTIVO") //2 - Motivo do status
			aadd(aDados,"PROCEVENTONFE|RETEVENTO|INFEVENTO|NPROT")	//3 - Protocolo Autporizacao		
			aadd(aDados,"PROCEVENTONFE|RETEVENTO|INFEVENTO|DHREGEVENTO")	//4 - Data e hora de recebimento					
			aadd(aDados,"") //5 - Tipo de Emissao
			aadd(aDados,"PROCEVENTONFE|RETEVENTO|INFEVENTO|TPAMB") //6 - Ambiente de transmiss�o		
			aadd(aDados,"") //7 - Tipo de Emissao - Caso nao tenha retorno
			aadd(aDados,"ENVEVENTO|EVENTO|INFEVENTO|TPAMB") //8 - Ambiente de transmiss�o -  Caso nao tenha retorno												
			aadd(aDados,"") //9 - Numero de autoriza��o DPEC
			aadd(aDados,"") //10 - Chave da autorizacao
		
		case nInf == 3	
			//Informa��es da Inutiliza��o
			aadd(aDados,"PROCINUTNFE|RETINUTNFE|INFINUT|CSTAT") //1 - Codigo Status documento 
			aadd(aDados,"PROCINUTNFE|RETINUTNFE|INFINUT|XMOTIVO") //2 - Motivo do status
			aadd(aDados,"PROCINUTNFE|RETINUTNFE|INFINUT|NPROT")	//3 - Protocolo Autporizacao		
			aadd(aDados,"PROCINUTNFE|RETINUTNFE|INFINUT|DHRECBTO")	//4 - Data e hora de recebimento					
			aadd(aDados,"") //5 - Tipo de Emissao
			aadd(aDados,"PROCINUTNFE|RETINUTNFE|INFINUT|TPAMB") //6 - Ambiente de transmiss�o		
			aadd(aDados,"") //7 - Tipo de Emissao - Caso nao tenha retorno
			aadd(aDados,"INUTNFE|INFINUT|TPAMB	") //8 - Ambiente de transmiss�o -  Caso nao tenha retorno												
			aadd(aDados,"") //9 - Numero de autoriza��o DPEC
			aadd(aDados,"") //10 - Chave da autorizacao
	end
	
return(aDados)

static function UsaColaboracao(cModelo)
Local lUsa := .F.

If FindFunction("ColUsaColab")
	lUsa := ColUsaColab(cModelo)
endif
return (lUsa)


//-----------------------------------------------------------------------
/*/{Protheus.doc} DANFE_VI
Funcao utilizada para verificar a ultima versao do fonte DANFEIII.PRW aplicado no rpo do cliente, assim verificando
a necessidade de uma atualizacao neste fonte.
 
@author 	Eduardo Silva
@since 		25/08/2014
@version 	11.9
 
@param	Retornar a ultima data do RPO que esta no cliente. Pois o cliente n�o esta utilizando o DANFEII com isto esta 
		sendo informado a mensagem que o RdMake n�o est� compilado. 						

@return nRet
/*/
//-----------------------------------------------------------------------

User Function DANFE_VI

Local nRet := 20140825 // 25 de Abril de 2014 # Eduardo Silva ## Cliente n�o tem o DANFEII compilado no RPO ajuste para n�o dar erro

Return nRet

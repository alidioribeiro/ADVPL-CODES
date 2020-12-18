#INCLUDE "QDOR041.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Report.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QDOR041   ºAutor  ³Leandro Sabino      º Data ³  30/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio Lista Mestra Completa de Documentos              º±±
±±º          ³ (Versao Relatorio Personalizavel)                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                            
Static Function QDOR041()
Local oReport                                              
Local cPerg:= "XQDR04"

If FindFunction("TRepInUse") .And. TRepInUse()
	DbSelectArea("SX1")
	If DbSeek("XQDR04" + "07")
		While ! SX1->(Eof()) .And. SX1->X1_GRUPO = cPerg .And. SX1->X1_ORDEM >= "07"
			RecLock("SX1", .F.)
			DbDelete()
			MsUnLock()
			DbSkip()
		Enddo
	Endif
	DbSelectArea("QDH")
	
	Pergunte("XQDR04",.F.) 
    oReport := ReportDef()
    oReport:PrintDialog()
Else
	QDOR041R3()	// Executa versão anterior do fonte
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ReportDef()   ³ Autor ³ Leandro Sabino   ³ Data ³ 30/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Montar a secao				                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ReportDef()				                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QDOR041                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()
Local cTitulo := STR0001 // "LISTA MESTRA COMPLETA DE DOCUMENTOS"
Local cDesc1  := STR0002 // "Este programa ir  imprimir uma rela‡„o dos documentos, seus "
Local cDesc2  := STR0003 // "elaboradores, revisores, aprovadores e homologadores, "
Local cDesc3  := STR0004 // "de acordo com os parƒmetros definidos pelo usu rio."
Local aUsrMat  	:= QA_USUARIO()
Local cMatDep  	:= aUsrMat[4]
Local cMatFil  	:= aUsrMat[2]
Local cFilFunc 	:= xFilial("QAC")
Local cAliasQry := "QD8"
Local oSection1 

DEFINE REPORT oReport NAME "QDOR041" TITLE cTitulo PARAMETER "XQDR04" ACTION {|oReport| PrintReport(oReport)} DESCRIPTION (cDesc1+cDesc2+cDesc3)
oReport:SetLandscape(.T.)

DEFINE SECTION oSection1 OF oReport TABLES "QDH" TITLE OemToAnsi(STR0017)
DEFINE CELL NAME "cDOCTO"       OF oSection1 ALIAS "  "  TITLE TiTSX3("QDH_DOCTO")[1]  AUTO SIZE
DEFINE CELL NAME "cRV"          OF oSection1 ALIAS "  "  TITLE TiTSX3("QDH_RV")[1]     AUTO SIZE
DEFINE CELL NAME "cTITULO"      OF oSection1 ALIAS "  "  TITLE TiTSX3("QDH_TITULO")[1] AUTO SIZE
DEFINE CELL NAME "cElaborador"  OF oSection1 ALIAS "  "  TITLE OemToAnsi(STR0013)  SIZE 15 //"Elaboradores"
DEFINE CELL NAME "cRevisor"     OF oSection1 ALIAS "  "  TITLE OemToAnsi(STR0014)  SIZE 15 //"Revisores"
DEFINE CELL NAME "cAprovador"   OF oSection1 ALIAS "  "  TITLE OemToAnsi(STR0015)  SIZE 14 //"Aprovadores"
DEFINE CELL NAME "cHomologador" OF oSection1 ALIAS "  "  TITLE OemToAnsi(STR0016)  SIZE 15 //"Homologadores"
DEFINE CELL NAME "cDTVIG"       OF oSection1 ALIAS "QDH" TITLE TiTSX3("QDH_DTVIG")[1] SIZE 10
	
Return oReport

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ PrintReport   ³ Autor ³ Leandro Sabino   ³ Data ³ 30/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Imprimir os campos do relatorio                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PrintReport(ExpO1)  	     	                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto oPrint                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QDOR020                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                  
Static Function PrintReport(oReport) 
Local oSection1 := oReport:Section(1)
Local aElaboradores := {}
Local aAprovadores  := {}
Local aDigitadores  := {}
Local aRevisores	:= {}
Local aHomologadores:= {}
Local cFiltro       := ""
Local nTam1         := 0
Local nTam2         := 0
Local nTamMax       := 0
Local nI            := 0


DbSelectArea("QDH")
DbSetOrder(1)

DbSelectArea("QD0")
DbSetOrder(1)

DbSelectArea("QDG")
DbSetOrder(1)

cFiltro:= 'QDH_FILIAL == "'+xFilial("QDH")+'"
cFiltro+= ' .AND. QDH_STATUS == "L  "'
cFiltro+= ' .AND. QDH_CANCEL <> "S" .AND. QDH_OBSOL <> "S"'
cFiltro+= ' .AND. QDH_CODTP >= "'+mv_par01+'" .AND. QDH_CODTP <= "'+mv_par02+'"'
cFiltro+= ' .AND. QDH_DOCTO >= "'+mv_par03+'" .AND. QDH_DOCTO <= "'+mv_par04+'"'
If mv_par05	== 2
	cFiltro+='.AND. QDH->QDH_DTOIE == "I"'
Elseif mv_par05 == 3
	cFiltro+='.AND. QDH->QDH_DTOIE == "E"'
EndIf

oSection1:SetFilter(cFiltro)

QDH->(dbGoTop())

While !oReport:Cancel() .And. QDH->(!Eof()) .And. QDH->QDH_FILIAL == xFilial( "QDH" )
    
	aDigitadores	:={}	
	aElaboradores	:={}
	aRevisores		:={}
	aAprovadores	:={}
	aHomologadores	:={}

    oSection1:Init()

	If QD0->(DbSeek(xFilial("QD0")+QDH->QDH_DOCTO+QDH->QDH_RV))
		While QD0->(!Eof()) .And. QD0->QD0_FILIAL+QD0->QD0_DOCTO+QD0->QD0_RV == xFilial("QD0")+QDH->QDH_DOCTO+QDH->QDH_RV
			If QD0->QD0_AUT == "E"
				nAcho:= ASCAN(aElaboradores,{|x| x[1] == QD0->QD0_FILMAT .And. x[2] == QD0->QD0_MAT})
				If nAcho == 0
					AADD(aElaboradores,{QD0->QD0_FILMAT,QD0->QD0_MAT})
				EndIf
			Endif
			If QD0->QD0_AUT == "R"
				nAcho:= ASCAN(aRevisores,{|x| x[1] == QD0->QD0_FILMAT .And. x[2] == QD0->QD0_MAT})
				If nAcho == 0
					AADD(aRevisores,{QD0->QD0_FILMAT,QD0->QD0_MAT})
				EndIf
			Endif
			If QD0->QD0_AUT == "A"
				nAcho:= ASCAN(aAprovadores,{|x| x[1] == QD0->QD0_FILMAT .And. x[2] == QD0->QD0_MAT})
				If nAcho == 0
					AADD(aAprovadores,{QD0->QD0_FILMAT,QD0->QD0_MAT})
				EndIf
			Endif
			If QD0->QD0_AUT == "H"
				nAcho:= ASCAN(aHomologadores,{|x| x[1] == QD0->QD0_FILMAT .And. x[2] == QD0->QD0_MAT})
				If nAcho == 0
					AADD(aHomologadores,{QD0->QD0_FILMAT,QD0->QD0_MAT})
				EndIf
			EndIf
			QD0->(DbSkip())
		EndDo
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tamanho maximo do La‡o (For-Next)               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTam1:=Max(Len(aElaboradores),Len(aRevisores))
	nTam2:=Max(Len(aAprovadores),Len(aHomologadores))
	nTamMax:=Max(nTam1,nTam2)
   	
   	For nI:= 1 To nTamMax

		If nI = 1
			oSection1:Cell("cDOCTO"):SetValue(QDH->QDH_DOCTO)
			oSection1:Cell("cRV"):SetValue(QDH->QDH_RV)
			oSection1:Cell("cTITULO"):SetValue(QDH->QDH_TITULO)
			If !Empty(QDH->QDH_DTVIG) 
				oSection1:Cell("cDTVIG"):SetValue(QDH->QDH_DTVIG)
			Else		
				oSection1:Cell("cDOCTO"):SetValue("")
			EndIf
		Else
			oSection1:Cell("cDOCTO"):SetValue("")		
			oSection1:Cell("cRV"):SetValue("")				
			oSection1:Cell("cDTVIG"):SetValue("") 
			oSection1:Cell("cTITULO"):SetValue("")
		Endif
			
		If Len( aElaboradores ) >= nI
			oSection1:Cell("cElaborador"):SetValue(QA_NUSR(aElaboradores[nI,1],aElaboradores[nI,2],.T.,"A"))
		Else
			oSection1:Cell("cElaborador"):SetValue("")	
		EndIf		
			
		If Len( aRevisores ) >= nI
			oSection1:Cell("cRevisor"):SetValue(QA_NUSR(aRevisores[nI,1],aRevisores[nI,2],.T.,"A"))
		Else
			oSection1:Cell("cRevisor"):SetValue("")
		EndIf
	
		If Len( aAprovadores ) >= nI
			oSection1:Cell("cAprovador"):SetValue(QA_NUSR(aAprovadores[nI,1],aAprovadores[nI,2],.T.,"A"))
		Else
			oSection1:Cell("cAprovador"):SetValue("")
		EndIf
	
		If Len(aHomologadores) >= nI
			oSection1:Cell("cHomologador"):SetValue(QA_NUSR(aHomologadores[nI,1],aHomologadores[nI,2],.T.,"A"))
		Else	
			oSection1:Cell("cHomologador"):SetValue("")
		EndIf      

	   	oSection1:PrintLine() 
	Next nI
	
   	QDH->(DbSkip())

EndDo

oSection1:Finish()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve as ordens originais dos arquivos                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("QDH")
Set Filter to


Return NIL


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ QDOR041R3³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 13/07/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Relatorio Lista Mestra de Documentos                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QDOR041()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ Siga Quality ( Controle de Documentos )                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³   Data   ³  BOPS  ³ Programador ³Alteracao                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ 23/01/01 ³  7625  ³ Aldo        ³ Desconsiderar Doctos Cancelados.    ³±±
±±³ 28/06/01 ³  5258  ³Eduardo Souza³Incluido a pergunta n21 para filtrar ³±±
±±³          ³        ³             ³ doc. interno e externo e Alterado a ³±±
±±³          ³        ³             ³ perg. n02 para filtrar doctos com os³±±
±±³          ³        ³             ³ param.(Vigente/Obsoleto/Canc./Todos)³±±
±±³ 03/07/01 ³  xxxx  ³ Aldo        ³ Otimizacao do filtro e impressao dos³±±
±±³          ³        ³             ³ Usuarios Elaboradores.              ³±±
±±³ 18/02/02 ³  META  ³ Eduardo S.  ³ Alterado para Listar somente Doctos ³±±
±±³          ³        ³             ³ Vigentes.                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function QDOR041R3()

Local	cTitulo := OemToAnsi(STR0001) // "LISTA MESTRA COMPLETA DE DOCUMENTOS"
Local	cDesc1  := OemToAnsi(STR0002) // "Este programa ir  imprimir uma rela‡„o dos documentos, seus "
Local	cDesc2  := OemToAnsi(STR0003) // "elaboradores, revisores, aprovadores e homologadores, "
Local	cDesc3  := OemToAnsi(STR0004) // "de acordo com os parƒmetros definidos pelo usu rio."
Local	cString := "QDH" 
Local	wnrel   := "QDOR041"
Local	Tamanho := "G"

Private cPerg   := "XQDR04"
Private aReturn := {OemToAnsi(STR0005),1,OemToAnsi(STR0006),1,2,1,"",1} // "Zebrado"###"Administra‡„o"
Private nLastKey:= 0
Private INCLUI  := .f. // Colocada para utilizar as funcoes

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                               ³
//³ mv_par01	// De  Tipo de Documento                                ³
//³ mv_par02	// Ate Tipo de Documento                                ³
//³ mv_par03	// De  Documento                                        ³
//³ mv_par04	// Ate Documento                                        ³
//³ mv_par05	// Documento (Ambos/Interno/Externo)                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SX1")
If DbSeek(cPerg + "07")
	While ! SX1->(Eof()) .And. SX1->X1_GRUPO = cPerg .And. SX1->X1_ORDEM >= "07"
		RecLock("SX1", .F.)
		DbDelete()
		MsUnLock()
		DbSkip()
	Enddo
Endif
DbSelectArea("QDH")

Pergunte(cPerg,.f.)

wnrel :=SetPrint(cString,wnrel,cPerg,ctitulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| QDOR041Imp(@lEnd,cTitulo,wnRel,Tamanho)},cTitulo)

Return .t.

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³QDOR041Imp³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 13/07/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Envia para funcao que faz a impressao do relatorio.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QDOR041Imp(ExpL1,ExpC1,ExpC2,ExpC3)                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1 - Cancela Relatorio                                  ³±±
±±³          ³ ExpC1 - Titulo do Relatorio                                ³±±
±±³          ³ ExpC2 - Nome do Relatorio                                  ³±±
±±³          ³ ExpC3 - Tamanho do Relatorio                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QDOR041                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function QDOR041Imp(lEnd,cTitulo,wnRel,Tamanho)

Local	cCabec1       := ""
Local	cCabec2       := ""
Local	cbtxt         := Space(10)
Local	nTipo         := GetMV("MV_COMP")
Local	cbcont        := 0
Local	nTam1         := 0
Local	nTam2         := 0
Local	nTamMax       := 0
Local nI            := 0
Local	nAcho         := 0
Local aDigitadores  := {}
Local aElaboradores := {}
Local aRevisores	  := {}
Local	aAprovadores  := {}
Local	aHomologadores:= {}
Local cIndex1	     := ""
Local cFiltro	     := ""
Local	cKey		     := ""

Private Limite	:= 220

cCabec1 := OemToAnsi(STR0010)+OemToAnsi(STR0011)+OemToAnsi(STR0012)
           // "DOCUMENTO         REV  TITULO                                                                                                "
           // "ELABORADORES     REVISORES        APROVADORES      "
           // "HOMOLOGADORES    STATUS        VIGENCIA"
cCabec2:= " "
li     := 60
m_pag  := 1

QD0->(DbSetOrder(1))
QDG->(DbSetOrder(1))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice Condicional nos arquivos utilizados ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cIndex1 := CriaTrab( Nil, .F. )

QDH->(DbSetOrder(1))
cKey:=IndexKey()

cFiltro:= 'QDH_FILIAL == "'+xFilial("QDH")+'"
cFiltro+= ' .AND. QDH_STATUS == "L  "'
cFiltro+= ' .AND. QDH_CANCEL <> "S" .AND. QDH_OBSOL <> "S"'
cFiltro+= ' .AND. QDH_CODTP >= "'+mv_par01+'" .AND. QDH_CODTP <= "'+mv_par02+'"'
cFiltro+= ' .AND. QDH_DOCTO >= "'+mv_par03+'" .AND. QDH_DOCTO <= "'+mv_par04+'"'
If mv_par05	== 2
	cFiltro+='.AND. QDH->QDH_DTOIE == "I"'
Elseif mv_par05 == 3
	cFiltro+='.AND. QDH->QDH_DTOIE == "E"'
EndIf

If ! Empty(aReturn[7])	// Filtro de Usuario
	cFiltro += " .And. (" + aReturn[7] + ")"
Endif

IndRegua("QDH",cIndex1,cKey,,cFiltro,OemToAnsi(STR0007)) // "Selecionando Registros.."
DbSeek(xFilial("QDH"))
SetRegua(LastRec()) // Total de Elementos da Regua

While QDH->(!EOF()) .And. QDH->QDH_FILIAL == xFilial( "QDH" )
	IncRegua()
	aDigitadores	:={}	
	aElaboradores	:={}
	aRevisores		:={}
	aAprovadores	:={}
	aHomologadores	:={}
	If QD0->(DbSeek(xFilial("QD0")+QDH->QDH_DOCTO+QDH->QDH_RV))
		While QD0->(!Eof()) .And. QD0->QD0_FILIAL+QD0->QD0_DOCTO+QD0->QD0_RV == xFilial("QD0")+QDH->QDH_DOCTO+QDH->QDH_RV
			If QD0->QD0_AUT == "E"
				nAcho:= ASCAN(aElaboradores,{|x| x[1] == QD0->QD0_FILMAT .And. x[2] == QD0->QD0_MAT})
				If nAcho == 0
					AADD(aElaboradores,{QD0->QD0_FILMAT,QD0->QD0_MAT})
				EndIf
			ElseIf QD0->QD0_AUT == "R"
				nAcho:= ASCAN(aRevisores,{|x| x[1] == QD0->QD0_FILMAT .And. x[2] == QD0->QD0_MAT})
				If nAcho == 0
					AADD(aRevisores,{QD0->QD0_FILMAT,QD0->QD0_MAT})
				EndIf
			ElseIf QD0->QD0_AUT == "A"
				nAcho:= ASCAN(aAprovadores,{|x| x[1] == QD0->QD0_FILMAT .And. x[2] == QD0->QD0_MAT})
				If nAcho == 0
					AADD(aAprovadores,{QD0->QD0_FILMAT,QD0->QD0_MAT})
				EndIf
			ElseIf QD0->QD0_AUT == "H"
				nAcho:= ASCAN(aHomologadores,{|x| x[1] == QD0->QD0_FILMAT .And. x[2] == QD0->QD0_MAT})
				If nAcho == 0
					AADD(aHomologadores,{QD0->QD0_FILMAT,QD0->QD0_MAT})
				EndIf
			EndIf
			QD0->(DbSkip())
		EndDo
	EndIf
	
	If lEnd
		Li++
		@ PROW()+1,001 PSAY OemToAnsi(STR0008) // "CANCELADO PELO OPERADOR"
		Exit
	EndIf
		
	If Li > 58
		Cabec(cTitulo,cCabec1,cCabec2,wnrel,Tamanho,nTipo)
	EndIf
		
	@ Li,000 PSay Substr(Alltrim(QDH->QDH_DOCTO),1,16)
	@ Li,018 PSay Substr(Alltrim(QDH->QDH_RV),1,3)
	@ Li,023 PSay Substr(Alltrim(QDH->QDH_TITULO),1,100)
	
	If Len( aElaboradores ) >= 1
		@ Li,125	PSay Substr(QA_NUSR(aElaboradores[1,1],aElaboradores[1,2],.T.,"A"),1,15)
	EndIf		

	
	If Len( aRevisores ) >= 1
		@ Li,142	PSay Substr(QA_NUSR(aRevisores[1,1],aRevisores[1,2],.T.,"A" ),1,15)
	EndIf

	If Len( aAprovadores ) >= 1
		@ Li,159	PSay Substr(QA_NUSR(aAprovadores[1,1],aAprovadores[1,2],.T.,"A"),1,15)
	EndIf

	If Len(aHomologadores) >= 1
		@ Li,176	PSay Substr(QA_NUSR(aHomologadores[1,1],aHomologadores[1,2],.T.,"A"),1,15)
	EndIf
	
	@ Li,193 PSay QDH->QDH_DTVIG
	Li++

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tamanho maximo do La‡o (For-Next)               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTam1:=Max(Len(aElaboradores),Len(aRevisores))
	nTam2:=Max(Len(aAprovadores),Len(aHomologadores))
	nTamMax:=Max(nTam1,nTam2)

	For nI:= 2 To nTamMax
		If lEnd
			li++
			@ PROW()+1,001 PSAY OemToAnsi(STR0008) // "CANCELADO PELO OPERADOR"
			Exit
		EndIf
		
		IF Li > 58
			Cabec(cTitulo,cCabec1,cCabec2,wnrel,Tamanho,nTipo)
		EndIF
		If nI <= Len(aElaboradores)
			@ Li,125	PSay Substr(QA_NUSR(aElaboradores[nI,1],aElaboradores[nI,2],.T.,"A"),1,15)
		EndIf		
			
		If nI <= Len(aRevisores)
			@ Li,142	PSay Substr(QA_NUSR(aRevisores[nI,1],aRevisores[nI,2],.T.,"A"),1,15)
		EndIf
		If nI <= Len(aAprovadores)
			@ Li,159	PSay Substr(QA_NUSR(aAprovadores[nI,1],aAprovadores[nI,2],.T.,"A"),1,15)
		EndIf
		If nI <= Len(aHomologadores)
			@ Li,176	PSay Substr(QA_NUSR(aHomologadores[nI,1],aHomologadores[nI,2],.T.,"A"),1,15)
		EndIf
		Li++
	Next nI
	QDH->(DbSkip())
EndDo

If Li != 60
	Roda(cbcont,cbtxt,tamanho)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve as ordens originais dos arquivos                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("QDH")
Set Filter to

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga indices de trabalho                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cIndex1 += OrdBagExt()
Delete File &(cIndex1)

Set Device To Screen

If aReturn[5] = 1
	Set Printer TO 
	dbCommitAll()
	Ourspool(wnrel)
Endif

MS_FLUSH()

Return (.T.)
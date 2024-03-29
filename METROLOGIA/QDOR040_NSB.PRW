#INCLUDE "QDOR040.CH"  
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Report.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �QDOR040   �Autor  �Leandro Sabino      � Data �  29/06/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Relatorio Lista Mestra Resumida de Documentos              ���
���          � (Versao Relatorio Personalizavel)                          ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/*                                            
User Function D4RNSB()
Local oReport

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
	
	Pergunte("XQDR04",.F.) 
    oReport := ReportDef()
    oReport:PrintDialog()
Else
	QDOR040R3()	// Executa vers�o anterior do fonte
EndIf

Return
*/
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � ReportDef()   � Autor � Leandro Sabino   � Data � 29/06/06 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Montar a secao				                              ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ReportDef()				                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � QDOR040                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()
Local cTitulo := OemToAnsi(STR0001)	//"LISTA MESTRA RESUMIDA DE DOCUMENTOS"
Local cDesc1  := OemToAnsi(STR0002)//"Este programa ir� imprimir uma rela��o dos documentos, seus "
Local cDesc2  := OemToAnsi(STR0003)	//"elaboradores, revisores, aprovadores e homologadores, "
Local cDesc3  := OemToAnsi(STR0004)//"de acordo com os parametros definidos pelo usu�rio."
Local aUsrMat  	:= QA_USUARIO()
Local cMatDep  	:= aUsrMat[4]
Local cMatFil  	:= aUsrMat[2]
Local cFilFunc 	:= xFilial("QAC")
Local cAliasQry := "QD8"
Local oSection1 

DEFINE REPORT oReport NAME "XQDR04" TITLE cTitulo PARAMETER "XQDR04" ACTION {|oReport| PrintReport(oReport)} DESCRIPTION (cDesc1+cDesc2+cDesc3)
oReport:SetPortrait()

DEFINE SECTION oSection1 OF oReport TITLE STR0015 TABLES "QDH" // "Documentos"
DEFINE CELL NAME "cDOCTO"      OF oSection1 ALIAS "  "  TITLE TiTSX3("QDH_DOCTO")[1]  AUTO SIZE
DEFINE CELL NAME "cRV"         OF oSection1 ALIAS "  "  TITLE TiTSX3("QDH_RV")[1]     AUTO SIZE
DEFINE CELL NAME "cTITULO"     OF oSection1 ALIAS "  "  TITLE TiTSX3("QDH_TITULO")[1] AUTO SIZE
DEFINE CELL NAME "cElaborador" OF oSection1 ALIAS "  "  TITLE OemToAnsi(STR0012)  SIZE 15 //"Elaboradores"
DEFINE CELL NAME "cRevisor"    OF oSection1 ALIAS "  "  TITLE OemToAnsi(STR0013)  SIZE 15 //"Revisores"
DEFINE CELL NAME "cAprovador"  OF oSection1 ALIAS "  "  TITLE OemToAnsi(STR0014)  SIZE 15 //"Aprovadores"
DEFINE CELL NAME "cDTVIG"      OF oSection1 ALIAS "QDH" TITLE TiTSX3("QDH_DTVIG")[1] SIZE 10
			
Return oReport

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � PrintReport   � Autor � Leandro Sabino   � Data � 26/06/06 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Imprimir os campos do relatorio                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � PrintReport(ExpO1)  	     	                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpO1 = Objeto oPrint                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � QDOR020                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/                  
Static Function PrintReport(oReport) 
Local oSection1 := oReport:Section(1)
Local aElaboradores := {}
Local aAprovadores  := {}
Local aRevisores    := {}
Local cFiltro       := ""
Local nI            := 0

DbSelectArea("QDH")
DbSetOrder(1)

DbSelectArea("QD0")
DbSetOrder(1)

DbSelectArea("QDG")
DbSetOrder(1)

MakeAdvplExpr("XQDR04")

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

While !oReport:Cancel() .And. QDH->(!Eof())
    
 	aElaboradores:={}
	aAprovadores :={}
	aRevisores   :={}

    oSection1:Init()

	If QD0->(DbSeek(xFilial("QD0")+QDH->QDH_DOCTO+QDH->QDH_RV))
		While !Eof() .And. QD0->QD0_FILIAL+QD0->QD0_DOCTO+QD0->QD0_RV == xFilial("QD0")+QDH->QDH_DOCTO+QDH->QDH_RV
			If QD0->QD0_AUT == "E"
				nAcho:= ASCAN(aElaboradores,{|x| x[1] == QD0->QD0_FILMAT .And. x[2] == QD0->QD0_MAT})
				If nAcho == 0
					AADD(aElaboradores,{QD0->QD0_FILMAT,QD0->QD0_MAT})
				EndIf
			ElseIf QD0->QD0_AUT == "R"
				nAcho:=ASCAN(aRevisores,{|x| x[1] == QD0->QD0_FILMAT .And. x[2] == QD0->QD0_MAT})
				If nAcho == 0
					AADD(aRevisores,{QD0->QD0_FILMAT,QD0->QD0_MAT})
				EndIf
			ElseIf QD0->QD0_AUT == "A"
				nAcho:= ASCAN(aAprovadores,{|x| x[1] == QD0->QD0_FILMAT .And. x[2] == QD0->QD0_MAT})
				If nAcho == 0
					AADD(aAprovadores,{QD0->QD0_FILMAT,QD0->QD0_MAT})
				EndIf
			EndIf
			QD0->(DbSkip()) 
		EndDo
    EndIf
	
	//�������������������������������������������������Ŀ
	//� Tamanho maximo do La�o (For-Next)               �
	//���������������������������������������������������
	nTam1  := Max(Len(aElaboradores),Len(aRevisores))
	nTamMax:= Max(nTam1,Len(aAprovadores))

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
			oSection1:Cell("cElaborador"):SetValue(QA_NUSR(aElaboradores[nI,1],aElaboradores[nI,2],.T.,"A" ))
		Else
			oSection1:Cell("cElaborador"):SetValue(Space(15))	
		EndIf		

		If Len( aRevisores ) >= nI
			oSection1:Cell("cRevisor"):SetValue(QA_NUSR(aRevisores[nI,1],aRevisores[nI,2],.T.,"A"))
		Else
			oSection1:Cell("cRevisor"):SetValue(Space(15))	
		EndIf		

		If Len( aAprovadores ) >= nI
			oSection1:Cell("cAprovador"):SetValue(QA_NUSR(aAprovadores[nI,1],aAprovadores[nI,2],.T.,"A"))
		Else
			oSection1:Cell("cAprovador"):SetValue(Space(15))	
		EndIf		

	   	oSection1:PrintLine() 
	Next nI
	QDH->(DbSkip())
EndDo

oSection1:Finish()

//��������������������������������������������������������������Ŀ
//� Devolve as ordens originais dos arquivos                     �
//����������������������������������������������������������������
RetIndex("QDH")
Set Filter to

Return NIL


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � QDOR040R3� Autor � Rodrigo de A. Sartorio� Data � 13/07/98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio Lista Mestra de Documentos                       ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � QDOR040()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Uso		 � Siga Quality ( Controle de Documentos )                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���   Data   �  BOPS  � Programador �Alteracao                            ���
�������������������������������������������������������������������������Ĵ��
��� 18/02/02 �  META  � Eduardo S.  � Alterado para Listar somente Doctos ���
���          �        �             � Vigentes.                           ���
��� 21/08/02 � 59354  � Eduardo S.  � Acertado para listar corretamente da���
���          �        �             � tas com 4 digitos.                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/

User Function D4RNSB()

Local	cTitulo := OemToAnsi(STR0001)	//"LISTA MESTRA RESUMIDA DE DOCUMENTOS"
Local	cDesc1  := OemToAnsi(STR0002)   //"Este programa ir� imprimir uma rela��o dos documentos, seus "
Local	cDesc2  := OemToAnsi(STR0003)	//"elaboradores, revisores, aprovadores e homologadores, "
Local	cDesc3  := OemToAnsi(STR0004)  //"de acordo com os parametros definidos pelo usu�rio."
Local   cString := "QDH" 
Local	wnrel   := "XQDR04"
Local	Tamanho := "M"

Private cPerg    := "XQDR04"
Private aReturn  := { OemToAnsi(STR0005),1,OemToAnsi(STR0006), 1, 2, 1, "",1 } //"Zebrado"###"Administra��o"
Private nLastKey := 0
Private INCLUI 	 := .f. // Colocada para utilizar as funcoes

//��������������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                                 �
//����������������������������������������������������������������������
//��������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                               �
//� mv_par01	// De  Tipo de Documento                                �
//� mv_par02	// Ate Tipo de Documento                                �
//� mv_par03	// De  Documento                                        �
//� mv_par04	// Ate Documento                                        �
//� mv_par05	// Documento (Ambos/Interno/Externo)                    �
//����������������������������������������������������������������������

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
cTitulo:=cTitulo+"  "+mv_par06
wnrel := SetPrint(cString,wnrel,cPerg,ctitulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd|QDOR040Imp(@lEnd,ctitulo,wnRel,tamanho )},cTitulo)

Return .T.
*/
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �QDOR040Imp � Autor � Rodrigo de A. Sartorio� Data � 13/07/98���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Envia para funcao que faz a impressao do relatorio.        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � QDOR040Imp(ExpL1,ExpC1,ExpC2,ExpC3)                        ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpL1 - Cancela Relatorio                                  ���
���          � ExpC1 - Titulo do Relatorio                                ���
���          � ExpC2 - Nome do Relatorio                                  ���
���          � ExpC3 - Tamanho do Relatorio                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function QDOR040Imp(lEnd,ctitulo,wnRel,Tamanho)

Local	cCabec1      := ""
Local	cCabec2      := ""
Local	cbtxt        := Space(10)
Local	nTipo        := GetMV("MV_COMP")
Local	cbcont       := 0
Local	nTamMax      := 0
Local	nI           := 0
Local	nAcho        := 0
Local aElaboradores:= {}
Local aAprovadores := {}
Local aRevisores   := {}
Local cIndex1      := ""
Local cFiltro      := ""
Local	cKey         := ""
Local nTam1        := 0

Private Limite:= 132

cCabec1:= OemToAnsi(STR0010)+OemToAnsi(STR0011) // "DOCUMENTO        REV TITULO                                                " ### "ELABORADORES    REVISORES       APROVADORES     VIGENCIA"
cCabec2:= " "
Li     := 60
m_pag  := 1

QD0->(DbSetOrder(1))
QDG->(DbSetOrder(1))

//�������������������������������������������������Ŀ
//� Cria Indice Condicional nos arquivos utilizados �
//���������������������������������������������������
cIndex1 := CriaTrab( Nil, .F. )

QDH->(DbSetOrder(1))
cKey:= IndexKey()

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

IndRegua("QDH",cIndex1,cKey,,cFiltro,OemToAnsi(STR0007))	//"Selecionando Registros.."

DbSeek(xFilial("QDH"))
SetRegua(LastRec()) // Total de Elementos da Regua

While !Eof() .And. QDH->QDH_FILIAL == xFilial( "QDH" )
	IncRegua()
	aElaboradores:={}
	aAprovadores :={}
	aRevisores   :={}

	If QD0->(DbSeek(xFilial("QD0")+QDH->QDH_DOCTO+QDH->QDH_RV))
		While !Eof() .And. QD0->QD0_FILIAL+QD0->QD0_DOCTO+QD0->QD0_RV == xFilial("QD0")+QDH->QDH_DOCTO+QDH->QDH_RV
			If QD0->QD0_AUT == "E"
				nAcho:= ASCAN(aElaboradores,{|x| x[1] == QD0->QD0_FILMAT .And. x[2] == QD0->QD0_MAT})
				If nAcho == 0
					AADD(aElaboradores,{QD0->QD0_FILMAT,QD0->QD0_MAT})
				EndIf
			ElseIf QD0->QD0_AUT == "R"
				nAcho:=ASCAN(aRevisores,{|x| x[1] == QD0->QD0_FILMAT .And. x[2] == QD0->QD0_MAT})
				If nAcho == 0
					AADD(aRevisores,{QD0->QD0_FILMAT,QD0->QD0_MAT})
				EndIf
			ElseIf QD0->QD0_AUT == "A"
				nAcho:= ASCAN(aAprovadores,{|x| x[1] == QD0->QD0_FILMAT .And. x[2] == QD0->QD0_MAT})
				If nAcho == 0
					AADD(aAprovadores,{QD0->QD0_FILMAT,QD0->QD0_MAT})
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
		
	@ Li,000 PSay SubStr(Alltrim(QDH->QDH_DOCTO),1,16)
	@ Li,017 PSay Substr(Alltrim(QDH->QDH_RV),1,3)
	@ Li,021 PSay Substr(Alltrim(QDH->QDH_TITULO),1,53)
	//�������������������������������������������������Ŀ
	//� Lista a linha 1 com a data de vigencia          �
	//���������������������������������������������������
	If Len( aElaboradores ) >= 1
		@ Li,075	PSay Substr(QA_NUSR(aElaboradores[1,1],aElaboradores[1,2],.T.,"A" ),1,15)
	EndIf		
	If Len( aRevisores ) >= 1
		@ Li,091	PSay Substr(QA_NUSR(aRevisores[1,1],aRevisores[1,2],.T.,"A"),1,15)
	EndIf
	If Len( aAprovadores ) >= 1
		@ Li,107	PSay Substr(QA_NUSR(aAprovadores[1,1],aAprovadores[1,2],.T.,"A"),1,15)
	EndIf
	@ Li,123 PSay QDH->QDH_DTVIG
	Li++

	//�������������������������������������������������Ŀ
	//� Tamanho maximo do La�o (For-Next)               �
	//���������������������������������������������������
	nTam1  := Max(Len(aElaboradores),Len(aRevisores))
	nTamMax:= Max(nTam1,Len(aAprovadores))

	For nI:= 2 To nTamMax
		If lEnd
			Li++
			@ PROW()+1,001 PSAY OemToAnsi(STR0008) // "CANCELADO PELO OPERADOR"
			Exit
		EndIf                                                   
		If Li > 58
			Cabec(cTitulo,cCabec1,cCabec2,wnrel,Tamanho,nTipo)
		EndIF
		If nI <= Len(aElaboradores)
			@ Li,075	PSay Substr(QA_NUSR(aElaboradores[nI,1],aElaboradores[nI,2],.T.,"A"),1,15)
		EndIf		
		If nI <= Len(aRevisores)
			@ Li,091	PSay Substr(QA_NUSR(aRevisores[nI,1],aRevisores[nI,2],.T.,"A" ),1,15)
		EndIf
		If nI <= Len(aAprovadores)
			@ Li,107	PSay Substr(QA_NUSR(aAprovadores[nI,1],aAprovadores[nI,2],.T.,"A"),1,15)
		EndIf
		Li++
	Next nI
	QDH->(DbSkip())
EndDo

IF Li != 60
	Roda(cbcont,cbtxt,tamanho)
EndIf

//��������������������������������������������������������������Ŀ
//� Devolve as ordens originais dos arquivos                     �
//����������������������������������������������������������������
RetIndex("QDH")
Set Filter to

//��������������������������������������������������������������Ŀ
//� Apaga indices de trabalho                                    �
//����������������������������������������������������������������
cIndex1 += OrdBagExt()
Delete File &(cIndex1)

Set Device To Screen

If aReturn[5] = 1
	Set Printer TO 
	DbCommitAll()
	Ourspool(wnrel)
Endif

MS_FLUSH()

Return (.T.)
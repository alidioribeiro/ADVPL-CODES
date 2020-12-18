#INCLUDE "MATR850.CH"
#include 'protheus.ch'
#include 'parmtype.ch'
/*/{Protheus.doc} PCPRA01
@author Wagner Correa
@since 23/05/2017
@version 1.0

@type function
/*/
User Function PCPRA01
	Local oReport

	If FindFunction("TRepInUse") .And. TRepInUse()
		oReport:= ReportDef()
		oReport:PrintDialog()
	Else
		Return
		//PCPRA01R3()
	EndIf

Return
/*/
�����������������������������������������������������������������������������
���Programa  �ReportDef � Autor �Marcos V. Ferreira     � Data �08/06/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR850			                                            ���
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()
	Local nTamOp  := TamSX3('D3_OP')[1]+2
	Local nTamProd:= TamSX3('C2_PRODUTO')[1]
	Local nTamSld := TamSX3('C2_QUANT')[1]
	Local cPictQtd:= PesqPictQt("C2_QUANT")
	Local aOrdem  := {STR0003,STR0004,STR0005}
	Local oReport
	Local oOp  
	Local cAliasSC2 := ""
	#IFDEF TOP
	If !TcSrvType() == "AS/400"
		cAliasSC2 := GetNextAlias() 
	Else
		cAliasSC2 := "SC2"  
	EndIf
	#ELSE
	cAliasSC2 := "SC2"
	#ENDIF

	//������������������������������������������������������������������������Ŀ
	//�Criacao do componente de impressao                                      �
	//�                                                                        �
	//�TReport():New                                                           �
	//�ExpC1 : Nome do relatorio                                               �
	//�ExpC2 : Titulo                                                          �
	//�ExpC3 : Pergunte                                                        �
	//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
	//�ExpC5 : Descricao                                                       �
	//�                                                                        �
	//��������������������������������������������������������������������������
	oReport:= TReport():New("MATR850",STR0001,"MTR850", {|oReport| ReportPrint(oReport,@cAliasSC2)},STR0002) //"Este programa ira imprimir a Rela��o das Ordens de Produ��o."
	If nTamProd > 15
		oReport:SetLandscape() 
	EndIf
	//��������������������������������������������������������������Ŀ
	//� Verifica as perguntas selecionadas                           �
	//����������������������������������������������������������������
	//��������������������������������������������������������������Ŀ
	//� Variaveis utilizadas para parametros                         �
	//� mv_par01        	// Da OP                                 �
	//� mv_par02        	// Ate a OP                              �
	//� mv_par03        	// Do Produto                            �
	//� mv_par04        	// Ate o Produto                         �
	//� mv_par05        	// Do Centro de Custo                    �
	//� mv_par06        	// Ate o Centro de Custo                 �
	//� mv_par07        	// Da data                               �
	//� mv_par08        	// Ate a data                            �
	//� mv_par09        	// 1-EM ABERTO 2-ENCERRADAS  3-TODAS     �
	//� mv_par10        	// 1-SACRAMENTADAS 2-SUSPENSA 3-TODAS    �
	//� mv_par11            // Impr. OP's Firmes, Previstas ou Ambas �
	//����������������������������������������������������������������
	Pergunte(oReport:uParam,.F.)
	//������������������������������������������������������������������������Ŀ
	//�Criacao da secao utilizada pelo relatorio                               �
	//�                                                                        �
	//�TRSection():New                                                         �
	//�ExpO1 : Objeto TReport que a secao pertence                             �
	//�ExpC2 : Descricao da se�ao                                              �
	//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
	//�        sera considerada como principal para a se��o.                   �
	//�ExpA4 : Array com as Ordens do relat�rio                                �
	//�ExpL5 : Carrega campos do SX3 como celulas                              �
	//�        Default : False                                                 �
	//�ExpL6 : Carrega ordens do Sindex                                        �
	//�        Default : False                                                 �
	//��������������������������������������������������������������������������

	//��������������������������������������������������������������Ŀ
	//� Sessao 1 (oOp)                                               �
	//����������������������������������������������������������������
	oOp := TRSection():New(oReport,STR0030,{"SC2","SB1"},aOrdem) //"Ordens de Produ��o"
	oOp:SetTotalInLine(.F.)  

	TRCell():New(oOp,'OP'			 ,'SC2',"NUMERO",          /*Picture*/	,nTamOp		              , /*lPixel*/, {|| (cAliasSC2)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD) } )
	TRCell():New(oOp,'C2_PRODUTO'	 ,'SC2',"PRODUTO",         /*Picture*/	,TamSX3('C2_PRODUTO')[1]+4, /*lPixel*/, /*{|| code-block de impressao }*/ )
	TRCell():New(oOp,'B1_DESC'		 ,'SB1',"DESCRI��O",       /*Picture*/	,/*Tamanho*/,               /*lPixel*/, /*{|| code-block de impressao }*/ )
	TRCell():New(oOp,'C2_CC'		 ,'SC2',"CENTRO CUSTO",    /*Picture*/	,/*Tamanho*/,               /*lPixel*/, /*{|| code-block de impressao }*/ )
	TRCell():New(oOp,'C2_EMISSAO'	 ,'SC2',"EMISS�O",         /*Picture*/	,TamSX3('C2_EMISSAO')[1]+4, /*lPixel*/, /*{|| code-block de impressao }*/ )
	TRCell():New(oOp,'C2_DATPRF'	 ,'SC2',"DT.PREVISTA",     /*Picture*/	,TamSX3('C2_DATPRF')[1]+4 , /*lPixel*/, /*{|| code-block de impressao }*/ )
	TRCell():New(oOp,'C2_DATRF'	 ,'SC2',"DT. REAL",        /*Picture*/	,TamSX3('C2_DATRF')[1]+4  , /*lPixel*/, /*{|| code-block de impressao }*/ )
	TRCell():New(oOp,'C2_QUANT'	 ,'SC2',"QUANT. ORIGINAL", /*Picture*/	,/*Tamanho*/,               /*lPixel*/, /*{|| code-block de impressao }*/ )
	TRCell():New(oOp,'SALDO'		 ,'SC2',"SALDO A ENTREGAR",cPictQtd		,nTamSld	,                  /*lPixel*/, {|| IIf(Empty((cAliasSC2)->C2_DATRF),aSC2Sld(cAliasSC2),0) } )
	TRCell():New(oOp,'PERDA'		 ,'SC2',"PERDA"           ,cPictQtd		,nTamSld	,                  /*lPixel*/, {|| R850BusPerd( (cAliasSC2)->(C2_NUM+C2_ITEM+C2_SEQUEN) ) } )
	TRCell():New(oOp,'REALIZADO'   ,'SC2',"REALIZADO"       ,cPictQtd		,nTamSld	,                  /*lPixel*/, {|| (cAliasSC2)->(C2_QUANT) - IIf(Empty((cAliasSC2)->C2_DATRF),aSC2Sld(cAliasSC2),0) - R850BusPerd( (cAliasSC2)->(C2_NUM+C2_ITEM+C2_SEQUEN) ) } )
	If ! __lPyme
		TRCell():New(oOp,'C2_STATUS','SC2',"STATUS",          /*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
		TRCell():New(oOp,'C2_TPOP'	 ,'SC2',"TIPO",            /*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	EndIf

	oOp:SetHeaderPage()

Return(oReport)

/*/
�����������������������������������������������������������������������������
���Programa  �ReportPrint � Autor �Marcos V. Ferreira   � Data �08/06/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportPrint devera ser criada para todos  ���
���          �os relatorios que poderao ser agendados pelo usuario.       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR850			                                            ���
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,cAliasSC2)
	Local oOp 	    := oReport:Section(1)
	Local nOrdem    := oOp:GetOrder()
	Local cFilterUsr:= ""
	Local oBreak
	#IFDEF TOP
	Local cWhere01:="",cWhere02:="",cWhere03:=""
	Local cSpace     := Space(TamSx3("C2_DATRF")[1])
	Local aStrucSC2  := SC2->(dbStruct())
	Local cSelectUsr := ""
	Local cSelect    := ""
	Local aFieldUsr  := {}
	Local nCnt       := 0
	Local nPos       := 0 
	Local lAS400	 := TcSrvType() == "AS/400"
	#ELSE
	Local cFiltro  := ""
	Local cStatus  := ""
	#ENDIF

	//��������������������������������������������������������������Ŀ
	//� Acerta o titulo do relatorio                                 �
	//����������������������������������������������������������������
	oReport:SetTitle(oReport:Title()+IIf(nOrdem==1,STR0008,IIf(nOrdem==2,STR0009,STR0010))) //" - Por O.P."###" - Por Produto"###" - Por Centro de Custo"

	//��������������������������������������������������������������Ŀ
	//� Definicao da linha de SubTotal                               |
	//����������������������������������������������������������������
	If nOrdem == 2
		oBreak := TRBreak():New(oOp,oOp:Cell("C2_PRODUTO"),STR0014,.F.)
	EndIf	

	If nOrdem == 2
		TRFunction():New(oOp:Cell('C2_QUANT'	),NIL,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
		TRFunction():New(oOp:Cell('SALDO'		),NIL,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Inicializa variavel para controle do filtro                  �
	//����������������������������������������������������������������
	#IFDEF TOP
	If !lAS400 ///SE NAO FOR AS/400
		dbSelectArea("SC2")
		dbSetOrder(nOrdem)

		//�������������������������������������������������������������������Ŀ
		//�Esta rotina foi escrita para adicionar no select os campos         �
		//�adicionados pelo usuario.                                          �
		//���������������������������������������������������������������������	   	
		cSelectUsr := "%"
		cSelect := "C2_FILIAL,C2_PRODUTO,C2_NUM,C2_ITEM,C2_SEQUEN,C2_ITEMGRD,C2_DATRF,C2_CC,C2_EMISSAO,C2_DATPRF,C2_QUANT,"
		cSelect += "C2_QUJE,C2_PERDA,C2_STATUS,C2_TPOP,SC2.R_E_C_N_O_ SC2RECNO" 
		aFieldUsr:= R850UsrSC2(oOP)
		For nCnt:=1 To Len(aFieldUsr)
			If ( nPos:=Ascan(aStrucSC2,{|x| AllTrim(x[1])==aFieldUsr[nCnt]}) ) > 0
				If aStrucSC2[nPos,2] <> "M"  
					If !aStrucSC2[nPos,1] $ cSelectUsr .And. !aStrucSC2[nPos,1] $ cSelect
						cSelectUsr += ","+aStrucSC2[nPos,1] 
					Endif 	
				EndIf
			EndIf 			       	
		Next
		cSelectUsr += "%"

		//��������������������������������������������������������������Ŀ
		//� Condicao Where para C2_STATUS                                �
		//����������������������������������������������������������������
		cWhere01 := "%"
		If mv_par10 == 1
			cWhere01 += "'S'"
		ElseIf mv_par10 == 2
			cWhere01 += "'U'"
		ElseIf mv_par10 == 3
			cWhere01 += "'S','U','D','N',' '"
		EndIf
		cWhere01 += "%"
		//��������������������������������������������������������������Ŀ
		//� Condicao Where para C2_TPOP                                  �
		//����������������������������������������������������������������
		cWhere02 := "%"
		If mv_par11 == 1
			cWhere02 += "'F'"
		ElseIf mv_par11 == 2
			cWhere02 += "'P'"
		ElseIf mv_par11 == 3
			cWhere02 += "'F','P'"
		EndIf	
		cWhere02 += "%"

		//����������������������������������������������������������������������������Ŀ
		//� Condicao Where para filtrar a condicao da OP(Em Aberto / Encerrada / Todas)�
		//������������������������������������������������������������������������������
		cWhere03 := "%"
		If mv_par09 == 1
			cWhere03 += " SC2.C2_DATRF =  '"+cSpace+"' AND "
		ElseIf mv_par09 == 2
			cWhere03 += " SC2.C2_DATRF <> '"+cSpace+"' AND "
		EndIf	

		cFilterUsr := oOP:GetSqlExp("SC2")
		If !Empty(cFilterUsr)
			cWhere03 := cWhere03 + " (" + cFilterUsr + ")" + " AND "
		Endif
		cFilterUsr := oOP:GetSqlExp("SB1")
		If !Empty(cFilterUsr)
			cWhere03 := cWhere03 + " (" + cFilterUsr + ")" + " AND "
		Endif
		cWhere03 += "%"

		//������������������������������������������������������������������������Ŀ
		//�Transforma parametros Range em expressao SQL                            �
		//��������������������������������������������������������������������������
		MakeSqlExpr(oReport:uParam)

		//������������������������������������������������������������������������Ŀ
		//�Inicio do Embedded SQL                                                  �
		//��������������������������������������������������������������������������
		BeginSql Alias cAliasSC2

		Column C2_DATPRF  as Date
		Column C2_DATRF   as Date
		Column C2_EMISSAO as Date		

		SELECT C2_FILIAL,C2_PRODUTO,C2_NUM,C2_ITEM,C2_SEQUEN,C2_ITEMGRD,C2_DATRF,C2_CC,
		C2_EMISSAO,C2_DATPRF,C2_QUANT,C2_QUJE,C2_PERDA,C2_STATUS,C2_TPOP,
		SC2.R_E_C_N_O_ SC2RECNO
		%Exp:cSelectUsr%

		FROM %table:SC2% SC2, %table:SB1% SB1

		WHERE  SC2.C2_FILIAL    = %xFilial:SC2%  AND
		SB1.B1_FILIAL    = %xFilial:SB1%  AND
		SC2.C2_PRODUTO   = SB1.B1_COD  AND
		SC2.C2_NUM||SC2.C2_ITEM||SC2.C2_SEQUEN||SC2.C2_ITEMGRD >= %Exp:mv_par01% AND
		SC2.C2_NUM||SC2.C2_ITEM||SC2.C2_SEQUEN||SC2.C2_ITEMGRD <= %Exp:mv_par02% AND
		SC2.C2_PRODUTO  >= %Exp:mv_par03% AND SC2.C2_PRODUTO <= %Exp:mv_par04% AND
		SC2.C2_CC       >= %Exp:mv_par05% AND SC2.C2_CC      <= %Exp:mv_par06% AND
		SC2.C2_EMISSAO  >= %Exp:mv_par07% AND SC2.C2_EMISSAO <= %Exp:mv_par08% AND
		SC2.C2_STATUS IN (%Exp:cWhere01%) AND SC2.C2_TPOP IN (%Exp:cWhere02%)  AND
		%Exp:cWhere03%
		SC2.%NotDel% AND
		SB1.%NotDel%

		ORDER BY %Order:SC2%

		EndSql

		oReport:Section(1):EndQuery()

		//��������������������������������������������������������������Ŀ
		//� Abertura do arquivo de trabalho                              |
		//����������������������������������������������������������������
		dbSelectArea(cAliasSC2)
	Else
		#ENDIF

		dbSelectArea("SC2")
		dbSetOrder(nOrdem)

		//������������������������������������������������������������������������Ŀ
		//�Transforma parametros Range em expressao SQL                            �
		//��������������������������������������������������������������������������
		MakeAdvplExpr(oReport:uParam)

		If mv_par10 == 1
			cStatus := "S"
		ElseIf mv_par10 == 2
			cStatus := "U"
		ElseIf mv_par10 == 3
			cStatus := "SUDN "
		EndIf	
		cFiltro	:= "SC2->C2_FILIAL == '"+xFilial("SC2")+"' "

		cFiltro += ".And. C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD >= '"+mv_par01+"' "
		cFiltro += ".And. C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD <= '"+mv_par02+"' "	
		cFiltro += ".And. C2_PRODUTO >= '"+mv_par03+"' "
		cFiltro += ".And. C2_PRODUTO <= '"+mv_par04+"' "
		cFiltro += ".And. C2_CC >= '"+mv_par05+"' "
		cFiltro += ".And. C2_CC <= '"+mv_par06+"' "
		cFiltro += ".And. DTOS(C2_EMISSAO) >= '"+DTOS(mv_par07)+"' "
		cFiltro += ".And. DTOS(C2_EMISSAO) <= '"+DTOS(mv_par08)+"' "
		cFiltro += ".And. C2_STATUS $ '"+cStatus+"' "
		If mv_par09 == 1  // O.P.s EM ABERTO
			cFiltro += ".And. Empty(C2_DATRF)"
		ElseIf mv_par09 == 2 //O.P.S ENCERRADAS
			cFiltro += ".And. !Empty(C2_DATRF)"
		EndIf

		cFilterUsr := oOP:GetAdvplExp("SC2")
		If !Empty(cFilterUsr)
			cFiltro := cFiltro + " .And. " + cFilterUsr
		Endif	

		oReport:Section(1):SetFilter(cFiltro,IndexKey())
		#IFDEF TOP
	EndIf
	#ENDIF

	TRPosition():New(oOp,"SB1",1,{|| xFilial("SB1") + (cAliasSC2)->C2_PRODUTO})
	oOp:SetLineCondition({|| MtrAValOP(mv_par11,'SC2',cAliasSC2) })

	//�����������������������Ŀ
	//�Impressao do Relatorio �
	//�������������������������
	oOp:Print()

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR850R3� Autor � Paulo Boschetti       � Data � 13.08.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relacao Das Ordens de Producao                              ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � MATR850(void)                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Edson   M.  �19/01/98�XXXXXX� Inclusao do Campo C2_SLDOP.              ���
���Edson   M.  �02/02/98�XXXXXX� Subst. do Campo C2_SLDOP p/ Funcao.      ���
���Rodrigo Sart�24/03/98�08929A� Inclusao da Coluna Termino Real da OP.   ���
���Rodrigo Sart�05/10/98�15995A� Acerto na filtragem das filiais          ���
���Rodrigo Sart�03/11/98�XXXXXX� Acerto p/ Bug Ano 2000                   ���
���Fernando J. �07/02/99�META  �Imprimir OP's Firmes, Previstas ou Ambas. ���
���Cesar       �31/03/99�XXXXXX�Manutencao na SetPrint()                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PCPRA01R3()
	Local titulo 	 := "Relacao Das Ordens de Producao"
	Local cString	 := "SC2"
	Local wnrel		 := "MATR850"
	Local cDesc		 := "Este programa ira imprimir a Rela��o das Ordens de Produ��o."
	Local aOrd    	 := {"Por O.P.       ", "Por Produto    ", "Por C. de Custo"}
	Local tamanho	 := "G"
	Local lRet      := .T.
	Private aReturn := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
	Private cPerg   := "MTR850"
	Private nLastKey:= 0

	Pergunte("MTR850",.F.)

	//��������������������������������������������������������������Ŀ
	//� Variaveis utilizadas para parametros                         �
	//� mv_par01        	// Da OP                                    �
	//� mv_par02        	// Ate a OP                                 �
	//� mv_par03        	// Do Produto                               �
	//� mv_par04        	// Ate o Produto                            �
	//� mv_par05        	// Do Centro de Custo                       �
	//� mv_par06        	// Ate o Centro de Custo                    �
	//� mv_par07        	// Da data                                  �
	//� mv_par08        	// Ate a data                               �
	//� mv_par09        	// 1-EM ABERTO 2-ENCERRADAS  3-TODAS        �
	//� mv_par10        	// 1-SACRAMENTADAS 2-SUSPENSA 3-TODAS       �
	//� mv_par11         // Impr. OP's Firmes, Previstas ou Ambas    �
	//��������������������������������������������������������������Ŀ
	//� Envia controle para a funcao SETPRINT                        �
	//����������������������������������������������������������������

	wnrel := SetPrint(cString, wnrel, cPerg, @titulo, cDesc, "", "", .F., aOrd, , Tamanho)

	If aReturn[4] == 1
		Tamanho := "M"
	EndIf
	If nLastKey == 27
		Set Filter To
		lRet := .F.
	EndIf

	If lRet
		SetDefault(aReturn,cString)
	EndIf

	If lRet .And. nLastKey == 27
		Set Filter To
		lRet := .F.
	EndIf

	If lRet
		RptStatus({|lEnd| R850Imp(@lEnd,wnRel,titulo,tamanho)},titulo)
	EndIf
Return NIL

/*
�����������������������������������������������������������������������������
���Fun��o    � R850Imp  � Autor � Waldemiro L. Lustosa  � Data � 13.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relat�rio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR850			                                            ���
�����������������������������������������������������������������������������
*/
Static Function R850Imp(lEnd,wnRel,titulo,tamanho)

	Local CbTxt
	Local CbCont,cabec1,cabec2
	Local limite   := If(aReturn[4] == 1,132,180)
	Local nomeprog := "MATR850"
	Local nTipo    := 0
	Local cProduto := Space(Len(SC2->C2_PRODUTO))
	Local cStatus, nOrdem, cSeek
	Local cTotal   := "", nTotOri := 0, nTotSaldo := 0 // Totalizar qdo ordem for por produto
	Local cQuery   := "", cIndex := CriaTrab("",.F.),nIndex:=0
	Local lQuery   := .F.
	Local aStruSC2 := {}
	Local cAliasSC2:= "SC2"
	Local cTPOP    := ""
	Local lTipo    := .F.
	#IFDEF TOP
	Local nX 
	Local lAS400	 := TcSrvType() == "AS/400"
	#ENDIF

	//��������������������������������������������������������������Ŀ
	//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
	//����������������������������������������������������������������
	cbtxt  := Space(10)
	cbcont := 0
	li     := 80
	m_pag  := 1

	nTipo  := IIf(aReturn[4]==1,15,18)
	nOrdem := aReturn[8]
	lTipo  := IIf(aReturn[4]==1,.T.,.F.)

	//��������������������������������������������������������������Ŀ
	//� Monta os Cabecalhos                                          �
	//����������������������������������������������������������������


	_c11 := "NUMERO         P R O D U T O                                 CENTRO  EMISSAO  ENTREGA  ENTREGA         PERDA   QUANTIDADE        SALDO A ST TP"
	_c12 := "                                                           DE CUSTO          PREVISTA     REAL                   ORIGINAL       ENTREGAR"

	// 	   1234567890123  123456789012345  1234567890123456789012345678901234567890  1234567890  1234567890  1234567890  1234567890  1234567890  123456789012345  123456789012345       1  1
	//       00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111222222222222222222222
	//       00000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999000000000011111111112
	//       01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890


	_c21 := "NUMERO         P R O D U T O                                                  CENTRO    EMISSAO      ENTREGA     ENTREGA       PERDA     QUANTIDADE          SALDO A      ST TP"
	_c22 := "                                                                            DE CUSTO                PREVISTA        REAL                    ORIGINAL         ENTREGAR"	

	// 	   1234567890123  123456789012345  1234567890123456789012345678901234567890  1234567890  1234567890  1234567890  1234567890  1234567890 123456789012345  123456789012345       1  1
	//       00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111222222222222222222222
	//       00000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999000000000011111111112
	//       01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890


	_c31 := "NUMERO         P R O D U T O                                 CENTRO  EMISSAO  ENTREGA  ENTREGA     QUANTIDADE        SALDO A      "
	_c12 := "                                                           DE CUSTO          PREVISTA     REAL       ORIGINAL       ENTREGAR"

	_c41 := "NUMERO         P R O D U T O                                                  CENTRO    EMISSAO      ENTREGA     ENTREGA       QUANTIDADE          SALDO A      "
	_c22 := "                                                                            DE CUSTO                PREVISTA        REAL         ORIGINAL         ENTREGAR"

	titulo += IIf(nOrdem==1," - Por O.P.", IIf(nOrdem==2, " - Por Produto", " - Por Centro de Custo"))
	cabec1 := If(!__lPyme, IIf(lTipo, _c11, _c21), IIf(lTipo, _c31, _c41))
	// "NUMERO         P R O D U T O                                                  CENTRO    EMISSAO      ENTREGA     ENTREGA       QUANTIDADE          SALDO A      ST TP"
	// "                                                                            DE CUSTO                PREVISTA        REAL         ORIGINAL         ENTREGAR"

	_c12 := "                                                           DE CUSTO          PREVISTA     REAL       ORIGINAL       ENTREGAR"
	_c22 := "                                                                            DE CUSTO                PREVISTA        REAL         ORIGINAL         ENTREGAR"
	cabec2 := IIf(lTipo, _c12, _c22)	

	//	1234567890123  123456789012345  1234567890123456789012345678901234567890  1234567890  1234567890  1234567890  1234567890  123456789012345  123456789012345       1  1
	// 00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111222222222222222222222
	// 00000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999000000000011111111112
	// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

	// 1a Linha Posicoes:000/015/032/074/086/098/110/122/139/161/164

	dbSelectArea("SC2")
	dbSetOrder( nOrdem )

	//��������������������������������������������������������������Ŀ
	//� Inicializa variavel para controle do filtro                  �
	//����������������������������������������������������������������
	#IFDEF TOP 
	If !lAS400 ///SE NAO FOR AS/400
		If mv_par10 == 1
			cStatus := "'S'"
		ElseIf mv_par10 == 2
			cStatus := "'U'"
		ElseIf mv_par10 == 3
			cStatus := "'S','U','D','N',' '"
		EndIf
		If mv_par11 == 1
			cTPOP := "'F'"
		ElseIf mv_par11 == 2
			cTPOP := "'P'"
		ElseIf mv_par11 == 3
			cTPOP := "'F','P'"
		EndIf	
		lQuery 	  := .T.
		aStruSC2  := SC2->(dbStruct())
		cAliasSC2 := "R850IMP"
		cQuery    := "SELECT SC2.C2_FILIAL,SC2.C2_PRODUTO,SC2.C2_NUM,SC2.C2_ITEM,SC2.C2_SEQUEN,SC2.C2_ITEMGRD, "
		cQuery    += "SC2.C2_DATRF,SC2.C2_CC,SC2.C2_EMISSAO,SC2.C2_DATPRF,SC2.C2_QUANT,SC2.C2_QUJE,SC2.C2_PERDA, "
		cQuery    += "SC2.C2_STATUS,SC2.C2_TPOP, "
		cQuery    += "SC2.R_E_C_N_O_ SC2RECNO "
		cQuery    += "FROM "
		cQuery    += RetSqlName("SC2")+" SC2 "
		cQuery    += "WHERE "
		cQuery    += "SC2.C2_FILIAL = '"+xFilial("SC2")+"' AND "

		//��������������������������������������������������������������Ŀ
		//� Condicao para filtrar OP's                           		 �
		//����������������������������������������������������������������
		cQuery 	  += "SC2.C2_NUM||SC2.C2_ITEM||SC2.C2_SEQUEN||SC2.C2_ITEMGRD >= '"+mv_par01+"' AND "
		cQuery 	  += "SC2.C2_NUM||SC2.C2_ITEM||SC2.C2_SEQUEN||SC2.C2_ITEMGRD <= '"+mv_par02+"' AND "

		cQuery    += "SC2.C2_PRODUTO >= '"+mv_par03+"' And SC2.C2_PRODUTO <= '"+mv_par04+"' And "
		cQuery    += "SC2.C2_CC  >= '"+mv_par05+"' And SC2.C2_CC  <= '"+mv_par06+"' And "
		cQuery    += "SC2.C2_EMISSAO  >= '"+DtoS(mv_par07)+"' And SC2.C2_EMISSAO  <= '"+DtoS(mv_par08)+"' And "
		cQuery    += "SC2.C2_STATUS IN ("+cStatus+") And "
		cQuery    += "SC2.C2_TPOP IN ("+cTPOP+") And "
		cQuery    += "SC2.D_E_L_E_T_ = ' ' "

		cQuery    += "ORDER BY "+SqlOrder(SC2->(IndexKey()))

		cQuery    := ChangeQuery(cQuery)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC2,.T.,.T.)

		For nX := 1 To Len(aStruSC2)
			If ( aStruSC2[nX][2] <> "C" ) .And. FieldPos(aStruSC2[nX][1]) > 0
				TcSetField(cAliasSC2,aStruSC2[nX][1],aStruSC2[nX][2],aStruSC2[nX][3],aStruSC2[nX][4])
			EndIf
		Next nX
	Else
		#ENDIF 
		If mv_par10 == 1
			cStatus := "S"
		ElseIf mv_par10 == 2
			cStatus := "U"
		ElseIf mv_par10 == 3
			cStatus := "SUDN "
		EndIf	
		cQuery 	:= "C2_FILIAL=='"+xFilial("SC2")+"'"
		cQuery  += ".And. C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD >= '"+mv_par01+"' "
		cQuery  += ".And. C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD <= '"+mv_par02+"' "	
		cQuery  += ".And.C2_PRODUTO>='"+mv_par03+"'.And.C2_PRODUTO<='"+mv_par04+"'"
		cQuery  += ".And.C2_STATUS$'"+cStatus+"'
		cQuery  += ".And.C2_CC>='"+mv_par05+"'.And.C2_CC<='"+mv_par06+"'"
		cQuery  += ".And.DtoS(C2_EMISSAO)>='"+DtoS(mv_par07)+"'.And.DtoS(C2_EMISSAO)<='"+DtoS(mv_par08)+"'"
		dbSelectArea("SC2")
		dbSetOrder(1)
		dbSetFilter({|| &cQuery},cQuery)
		cAliasSC2 := "SC2"
		#IFDEF TOP
	EndIF
	#ENDIF

	SetRegua(RecCount())		// Total de Elementos da regua
	dbGoTop()
	While !Eof()
		IncRegua()
		If lEnd
			@ Prow()+1,001 PSay STR0013	//	"CANCELADO PELO OPERADOR"
			Exit
		EndIf

		If C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD < xFilial('SC2')+mv_par01 .or. C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD > xFilial('SC2')+mv_par02
			dbSkip()
			Loop
		EndIf

		If mv_par09 == 1  // O.P.s EM ABERTO
			If !Empty(C2_DATRF)
				dbSkip()
				Loop
			EndIf
		ElseIf mv_par09 == 2 //O.P.S ENCERRADAS
			If Empty(C2_DATRF)
				dbSkip()
				Loop
			EndIf
		EndIf

		//-- Valida se a OP deve ser Impressa ou n�o
		#IFDEF TOP
		If	! Empty(aReturn[7])
			SC2->(MsGoTo((cAliasSC2)->SC2RECNO))
			If SC2->( ! &(aReturn[7]) )
				(cAliasSC2)->(DbSkip())
				Loop
			EndIf
		EndIf			
		#ELSE
		If !MtrAValOP(mv_par11, 'SC2')
			dbSkip()
			Loop
		EndIf
		//�������������������Ŀ
		//� Filtro do Usuario �
		//���������������������
		If !Empty(aReturn[7])
			If !&(aReturn[7])
				dbSkip()
				Loop
			EndIf
		EndIf
		#ENDIF	


		//��������������������������������������������������������������Ŀ
		//� Termina filtragem e grava variavel p/ totalizacao            �
		//����������������������������������������������������������������
		cTotal  := IIf(nOrdem==2,xFilial("SC2")+C2_PRODUTO,xFilial("SC2"))
		nTotOri := nTotSaldo:=0
		Do While !Eof() .And. cTotal == IIf(nOrdem==2,C2_FILIAL+C2_PRODUTO,C2_FILIAL)
			IncRegua()

			If C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD < xFilial('SC2')+mv_par01 .or. C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD > xFilial('SC2')+mv_par02
				dbSkip()
				Loop
			EndIf

			If mv_par09 == 1  // O.P.s EM ABERTO
				If !Empty(C2_DATRF)
					dbSkip()
					Loop
				EndIf
			Elseif mv_par09 == 2 //O.P.S ENCERRADAS
				If Empty(C2_DATRF)
					dbSkip()
					Loop
				EndIf
			EndIf

			//-- Valida se a OP deve ser Impressa ou n�o
			#IFDEF TOP
			If	! Empty(aReturn[7])
				SC2->(MsGoTo((cAliasSC2)->SC2RECNO))
				If SC2->( ! &(aReturn[7]) )
					(cAliasSC2)->(DbSkip())
					Loop
				EndIf
			EndIf
			#ELSE
			If !MtrAValOP(mv_par11, 'SC2')
				dbSkip()
				Loop
			EndIf
			//�������������������Ŀ
			//� Filtro do Usuario �
			//���������������������
			If !Empty(aReturn[7])
				If !&(aReturn[7])
					dbSkip()
					Loop
				EndIf
			EndIf
			#ENDIF


			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+(cAliasSC2)->C2_PRODUTO))

			If li > 58
				Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			EndIf

			// 1a Linha Posicoes:000/015/032/074/086/098/110/122/139/161/164
			@Li ,000 PSay C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD
			@Li ,015 PSay C2_PRODUTO
			If lTipo
				@Li ,032 PSay SubStr(SB1->B1_DESC,1,25)
				@Li ,058 PSay C2_CC
				@Li ,068 PSay C2_EMISSAO
				@Li ,077 PSay C2_DATPRF
				@Li ,086 PSay C2_DATRF
				@Li ,097 PSay C2_QUANT Picture PesqPictQt("C2_QUANT",15)
				@Li ,112 PSay IIf(Empty(C2_DATRF),aSC2Sld(cAliasSC2),0) Picture PesqPictQt("C2_QUANT",15)
			Else
				@Li ,032 PSay SubStr(SB1->B1_DESC,1,40)
				@Li ,074 PSay C2_CC
				@Li ,086 PSay C2_EMISSAO
				@Li ,099 PSay C2_DATPRF
				@Li ,111 PSay C2_DATRF
				@Li ,125 PSay C2_QUANT Picture PesqPictQt("C2_QUANT",15)
				@Li ,142 PSay IIf(Empty(C2_DATRF),aSC2Sld(cAliasSC2),0) Picture PesqPictQt("C2_QUANT",15)
			EndIf
			If ! __lPyme
				IF lTipo
					@Li ,126 PSay C2_STATUS
					@Li ,129 PSay C2_TPOP
				Else
					@Li ,161 PSay C2_STATUS
					@Li ,164 PSay C2_TPOP
				EndIf
			EndIf
			Li++
			If nOrdem # 2 .And. !lTipo
				@Li ,  0 PSay __PrtThinLine()
				Li++
			Else
				nTotOri	 += C2_QUANT
				nTotSaldo+= IIf(Empty(C2_DATRF),aSC2Sld(cAliasSC2),0)
			EndIf
			dbSkip()
		EndDo
		If nOrdem == 2
			Li++
			@Li ,000 PSay STR0014	//"Total ---->"
			@Li ,015 PSay Substr(cTotal,3)
			If lTipo
				@Li ,097 PSay nTotOri	Picture PesqPictQt("C2_QUANT",15)
				@Li ,112 PSay nTotSaldo	Picture PesqPictQt("C2_QUANT",15)
				Li++
				@Li ,  0 PSay __PrtThinLine()
			Else
				@Li ,125 PSay nTotOri	Picture PesqPictQt("C2_QUANT",15)
				@Li ,142 PSay nTotSaldo	Picture PesqPictQt("C2_QUANT",15)
				Li++
				@Li ,  0 PSay __PrtThinLine()
			EndIf
			Li++
		EndIf
	EndDo

	#IFDEF TOP
	If lAS400
		SC2->(dbClearFilter())
	EndIf
	#ELSE
	SC2->(dbClearFilter())
	#ENDIF

	If Li != 80
		Roda(cbcont,cbtxt)
	EndIf

	If lQuery
		dbSelectArea(cAliasSC2)
		dbCloseArea()
	EndIf

	dbSelectArea("SC2")
	Set Filter To
	dbSetOrder(1)

	If File(cIndex+OrdBagExt())
		Ferase(cIndex+OrdBagExt())
	EndIf

	If aReturn[5] == 1
		Set Printer To
		OurSpool(wnrel)
	EndIf

	MS_FLUSH()
Return NIL

/*/
+-------------------------------------------------------------------------+
|   Programa  | R850UsrSC2| Autor |Felipe Nunes de Toledo | Data |08/10/07|
|-------------------------------------------------------------------------|
|   Descricao | Retorna celulas informadas pelo usu�rio que deveram       |
|             | compor a select na tabela SC2                             |
|-------------------------------------------------------------------------|
|   Uso       | MATR850			                                            |
+-------------------------------------------------------------------------+
/*/
Static Function R850UsrSC2(oObj)

	Local aFieldUsr := {}
	Local nCntFor   := 0

	For nCntFor:=1 To Len(oObj:ACell)
		If oObj:Acell[nCntFor]:lUserField
			If "C2_" == Left(oObj:Acell[nCntFor]:cName,3)
				Aadd(aFieldUsr, Alltrim(oObj:Acell[nCntFor]:cName))
			EndIf
		EndIf
	Next nCntFor

Return aFieldUsr
/*/
+-------------------------------------------------------------------------+
|   Programa  | R850BusPerd| Autor | Wagner da Gama Correa| Data |08/10/07|
|-------------------------------------------------------------------------|
|   Descricao | Busca quantidade apontada como perda da OP                |
|             |                                                           |
|-------------------------------------------------------------------------|
|   Uso       | MATR850			                                            |
+-------------------------------------------------------------------------+
/*/
Static Function R850BusPerd(_cOp)

	Local _nQuant := 0
	Local _cArea
	
	_cArea := GetArea()

	_cQuery := ""
	_cQuery += "SELECT SUM(ZZ6_QUANT) QUANT " 
	_cQuery += "FROM " + RetSqlName("ZZ6") + " ZZ6 "
	_cQuery += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_='' AND B1_COD=ZZ6_PRODUT AND B1_TIPO IN ('PA','PI') "
	_cQuery += "WHERE ZZ6.D_E_L_E_T_='' "
	//_cQuery += "AND ZZ6_DATA BETWEEN '" + DtoS(mv_par07) + "' AND '" + Dtos(mv_par08) + "' "
	_cQuery += "AND ZZ6_OP='" + _cOp + "' "

	dbUseArea(.T., "TOPCONN", TcGenQry(,, _cQuery ), "TMOP", .T., .T.)

	dbSelectArea("TMOP")
	dbGoTop()
	_nQuant += QUANT
	dbCloseArea("TMOP")

	_cQuery := ""
	_cQuery += "SELECT SUM(BC_QUANT) QUANT " 
	_cQuery += "FROM " + RetSqlName("SBC") + " SBC "
	_cQuery += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_='' AND B1_COD=BC_PRODUTO AND B1_TIPO IN ('PA','PI') "
	_cQuery += "WHERE SBC.D_E_L_E_T_='' "
	//_cQuery += "AND ZZ6_DATA BETWEEN '" + DtoS(mv_par07) + "' AND '" + Dtos(mv_par08) + "' "
	_cQuery += "AND BC_OP='" + _cOp + "' "

	dbUseArea(.T., "TOPCONN", TcGenQry(,, _cQuery ), "TMOP", .T., .T.)

	dbSelectArea("TMOP")
	dbGoTop()
	_nQuant += QUANT
	dbCloseArea("TMOP")


	RestArea(_cArea)

Return _nQuant
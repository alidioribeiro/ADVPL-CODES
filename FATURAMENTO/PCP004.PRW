#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*_______________________________________________________________________________
� Fun��o    � PCP004     � Autor � M�rcio Macedo            � Data � 24/09/2013 �
+-----------+------------+-------+--------------------------+------+------------+
S� Descri��o � Leitura do Kanban de Vendas Yamaha- formato TXT				    �
�������������������������������������������������������������������������������*/
User Function PCP004()

Private cDirArq := ""
Private lPDiv := .F. // Se para processamento na primeiro divergencia encontrada
Private oObjDlg
//Private cPerg   := "PCP004"

//ValidPerg(cPerg)
//Pergunte(cPerg,.F.)

@ 200,1 TO 380,380 DIALOG oObjDlg TITLE "Leitura do Kanban Yamaha"
@ 02,005 TO 090,190
@ 10,010 Say "Este programa ir� ler o arquivo de importa��o de Kanban e"
@ 18,010 Say "gravar os dados nas tabelas do sistema."
//@ 65,098 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg)
@ 65,128 BMPBUTTON TYPE 01 ACTION PCP004a()
@ 65,158 BMPBUTTON TYPE 02 ACTION Close(oObjDlg)
Activate Dialog oObjDlg Centered

Return Nil

************************************************************************************************************************************************

Static Function PCP004a()

Private cArqTXT := ""
Private lDiverg := .f.							// Existem Diver�ncias?
Private dDatGet, dDatIni, dDatFim
Private _cNomeArq := "DIVERGENCIA_KANBAN.XLS"


cType    := "Kanban da Yamaha | *.TXT"
cArqTXT := cGetFile(cType, OemToAnsi("Selecione arquivo "+Subs(cType,1,17)))

nPos := RAt( "\", cArqTXT )
if nPos > 0 
	cDirArq := SUBSTR(cArqTXT, 1, nPos-1)
Endif

If !File(cArqTXT)
	MSGBOX("Arquivo " + cArqTXT + " n�o encontrado!")
	Return nil
End If

Close(oObjDlg)

MsgRun("Prepara��o das tabelas tempor�rias", "Aguarde...", {|| PCP004b() })

Processa( {|| PCP004c() }, "Lendo Kanban..." )

If lDiverg
	DIV->(dbCloseArea())
	TMP->(dbCloseArea())
	Head->(dbCloseArea())
	Return Nil
End If

Processa( {|| PCP004d() }, "Validando registros..." )

If lDiverg
	MSGBOX("Ocorreram Diverg�ncias durante valida��o dos dados. Favor consultar tabela " + _cNomeArq)
	DIV->(dbCloseArea())
	TMP->(dbCloseArea())
	Head->(dbCloseArea())
    //PCP004h() //RS 08/08/2018 - Adicionado para abrir o arquivo de divergencia em excel
	Return Nil
End If

Processa( {|| PCP004e() }, "Gravando Kanban..." )
                                                                          
DIV->(dbCloseArea())
TMP->(dbCloseArea())
Head->(dbCloseArea())

MSGBOX("Kanban cadastrado com sucesso!")

//Processa({|| PCP004g() }, "Gerando planilha Excel...")


Return Nil

************************************************************************************************************************************************

Static Function PCP004b

Local nIndArq := 0
Local aArqDiv := {}
Local cArqDiv := _cNomeArq
Local aArqTmp := {}
Local cArqTmp := "PCPE04"
Local cIndHEA := CriaTrab(Nil ,.f.)

// Arquivo de Inconsist�ncias

If File(cArqDiv)
	Erase(cArqDiv)
End If

Aadd(aArqDiv, {"DIVERG", "C", 100, 0})                                             

DbCreate(cArqDiv, aArqDiv, "CTREECDX")

//Use (cArqDiv) Alias DIV New Exclusive    
DBUseArea(.f.,'CTREECDX',cArqDiv,"DIV", .f.)

// Arquivo tempor�rio para receber o TXT

Aadd(aArqTmp, {"PRODCLI", "C", 14, 0})		// CODIGO PRODUTO CLIENTE
Aadd(aArqTmp, {"DESC"   , "C", 50, 0})		// DESCRICAO PRODUTO
Aadd(aArqTmp, {"UM"     , "C", 02, 0})		// UNIDADE 
Aadd(aArqTmp, {"ID"     , "C", 05, 0})		// ID
Aadd(aArqTmp, {"DTSAIDA", "D", 08, 0})		// DT ENTREGA
Aadd(aArqTmp, {"QTD"    , "N", 08, 0})		// QUANTIDADE
Aadd(aArqTmp, {"CODMIT" , "C", 15, 0})		// CODIGO SIGA

dbCreate(cArqTmp,aArqTmp)                	//Cria o arquivo no caminho especificado
Use (cArqTmp) Alias TMP New Exclusive VIA 'CTREECDX'
IndRegua("TMP",cIndHEA,"Dtos(DTSAIDA)+PRODCLI")

// Prepara��o da tabela DBF de Cabe�alho da planilha Excel
fErase(cArqTmp+"H.DBF")

aArqTmp := {}

aAdd( aArqTmp, {"TIPO"   , "C", 01, 0})
aAdd( aArqTmp, {"DATINI" , "D", 08, 0})
aAdd( aArqTmp, {"PEDCLI" , "C", 04, 0})
aAdd( aArqTmp, {"QTDREG" , "N", 08, 0})

dbCreate(cArqTmp+"H",aArqTmp)
Use (cArqTmp+"H") Alias HEAD New Exclusive VIA 'CTREECDX'

Return Nil

************************************************************************************************************************************************

Static Function PCP004c

Private nHdlTXT := FOpen(cArqTXT, 0)				// Abertura do TXT somente leitura
Private nTamTXT := 0

If nHdlTXT <= 0
	lDiverg := .t.
	MSGBOX("Ocorreu falha na abertura do TXT!"+Str(fError()))
	Return Nil
End If

nTamTXT := FSEEK(nHdlTXT,0,2)							// Calcular tamanho do TXT
FSEEK(nHdlTXT,0,0)										// Posicionar no in�cio do TXT

// Leitura do Cabe�alho do arquivo TXT

cTipReg := LerCmpTXT(nHdlTXT, 01)
cDatIni := LerCmpTXT(nHdlTXT, 10)
cPEDCLI	:= LerCmpTXT(nHdlTXT, 04)
LerCmpTXT(nHdlTXT)

dDatIni := Stod(Substr(cDatIni, 7, 4)+Substr(cDatIni, 4, 2)+Substr(cDatIni, 1, 2))

RecLock("HEAD",.T.)
Head->Tipo   := "I"				// Par�metros Iniciais
Head->DatIni := dDatIni
Head->PEDCLI    := cPEDCLI

// Leitura dos itens do arquivo TXT

While .t.

	cTipReg := LerCmpTXT(nHdlTXT, 01)
	
	If cTipReg <> "2"					// N�o � linha de detalhe
		Exit
	End if

	cPRODCLI := LerCmpTXT(nHdlTXT, 14) //CODIGO DO PRODUTO CLIENTE
	cDESC    := LerCmpTXT(nHdlTXT, 50) // DESCRICAO
	cUM      := LerCmpTXT(nHdlTXT, 02) //UNIDADE
	cID      := LerCmpTXT(nHdlTXT, 05) //ID
	cDTSAIDA := LerCmpTXT(nHdlTXT, 10)//DT ENTREGA
	cQTD     := LerCmpTXT(nHdlTXT, 10)// QUANTIDADE
	
	RecLock("TMP", .t.)
   
	  TMP->PRODCLI := cPRODCLI
	  TMP->DESC    := cDESC
	  TMP->UM      := cUM
	  TMP->ID      := cID
	  TMP->DTSAIDA := Stod(Substr(cDTSAIDA, 7, 4)+Substr(cDTSAIDA, 4, 2)+Substr(cDTSAIDA, 1, 2))
	  TMP->QTD     := VAL(cQTD)
	 
	TMP->(MsUnLock())	
   
   LerCmpTXT(nHdlTXT)
   
End

Return Nil

************************************************************************************************************************************************

Static Function PCP004d

Local lFlag := .f.

TMP->(DbGoTop())

While !TMP->(Eof())
    
    
     /*
	cQuery := "Select *"
	cQuery += " From " + RetSqlName("SA7")
	cQuery += " Where D_E_L_E_T_ = ''"
	cQuery += " And A7_FILIAL = '" + SA7->(xFilial()) + "'"
	cQuery += " And A7_CODCLI = '" + Trim(TMP->PRODCLI) + "'"  
	 */
	
	cQuery := "SELECT B1_COD, A7_PRODUTO, B1_DESC, B1_CODNBB, A7_CODCLI, B1_MSBLQL "
	cQuery += " FROM "+RetSqlName("SB1")+" A, "+RetSqlName("SA7")+" B "
	cQuery += " WHERE A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*' "
	cQuery += " AND A7_CLIENTE = '028' "
	cQuery += " AND B1_MSBLQL <> '1' "
	cQuery += " AND REPLACE(B1_CODNBB,'-','') = '" + Trim(TMP->PRODCLI) + "' "
	cQuery += " AND B1_COD = A7_PRODUTO "
	
	TCQUERY cQuery NEW ALIAS "QR1"
	
	If QR1->(Eof())

		RecLock("DIV", .t.)
		DIV->Diverg := "Item [" + Trim(TMP->PRODCLI) + "] n�o encontrado no cadastrado de Produtos!"
		lDiverg := .t. //RS 30/08/2018 - DEVE PARAR QUANDO GERAR DIVERGENCIA

		If lPDiv
			QR1->(DbCloseArea())
			Return Nil
		End If
		
	Else
		TMP->CODMIT := QR1->A7_PRODUTO
	End If

	QR1->(DbCloseArea())
	
		
	TMP->(DbSkip())

End

Return Nil

************************************************************************************************************************************************

Static Function PCP004e

Local cQuery := ""
Local cItem  := "01"
Local cIteIni, cIteFim
local cDel := " "
Local cDatq := " " 
Local cTesRet := " "

TMP->(DbGoTop())

DBSELECTAREA("SA1")                             //Capturando dados do cliente
dbSetOrder(1)
DBSEEK(XFILIAL("SA1") + "028" )                 //Clinte Yamaha
xTabela := A1_TABELA
xTipoCli:= A1_TIPO
xCondPg := A1_COND
xTransp := A1_TRANSP
                 
DBSELECTAREA("DA0")                             //Capturando a tabela do cliente
dbSetOrder(1)
DBSEEK(XFILIAL("DA0") + xTabela )                                                   
                 
DBSELECTAREA("DA1")                             //Capturando os valores da tabela 
dbSetOrder(1)                                   //FILIAL + TABELA + PRODUTO

While !TMP->(EOF())
			
	cPedido := ""
	lExiste := .T.
	Do While lExiste
		cPedido:=GetSX8Num("SCJ","CJ_NUM")
		confirmsx8()      
		If Empty(POSICIONE('SCJ', 1,  xFilial('SCJ')+ cPedido, 'CJ_NUM'))
			lExiste := .F.
		Endif
	Enddo           
	            
	dbSelectArea("SCJ") 
	                          
	RecLock("SCJ",.T.)
      SCJ->CJ_FILIAL := xFilial("SCJ")
      SCJ->CJ_NUM    := cPedido
      SCJ->CJ_TIPO   := "N"
      SCJ->CJ_CLIENTE:= "028"
      //SCJ->CJ_TIPOCLI:= xTipoCli
      SCJ->CJ_LOJAENT:= "01"
      SCJ->CJ_LOJA   := "01"
      SCJ->CJ_MOEDA  := 1
      //SCJ->CJ_ESPECI1:= "GRANEL"
      SCJ->CJ_TIPLIB := "1"
      SCJ->CJ_CLIENT := "028"
      SCJ->CJ_CONDPAG:= xCondPg
      //SCJ->CJ_TRANSP := xTransp
      SCJ->CJ_TABELA := xTabela
      //SCJ->CJ_MENNOTA:= "FAVOR CHECAR O Nro. DO LACRE 000 ."                   
      SCJ->CJ_STATUS := 'A'
      SCJ->CJ_EMISSAO:= TMP->DTSAIDA  // Mesma data de entrega do item // dDataBase
      SCJ->CJ_TPCARGA:= '1'
	SCJ->(MsUnlock())

	ConfirmSx8()
	

	cIteIni := cItem
	
	dDtTMP := TMP->DTSAIDA 
	
	While !TMP->(Eof()) .And. dDtTMP = TMP->DTSAIDA 
	
		xProd := TMP->CodMit
		SB1->(dbSeek(xFilial()+xProd))		
		SF4->(dbSeek(xFilial()+SB1->B1_TS))
		DA1->(dbSeek(xFilial()+xTabela + xProd ))
		
		xUm        := SB1->B1_UM                                  //Unidade de medida
        xDesProNSB := SB1->B1_DESC                                //Descri��o do produto
        xModelo    := SB1->B1_MODELO                              //Pre�o unitario         
        xLocal     := SB1->B1_LOCPAD                              //Armazem
        
        DA1->( DBSEEK(XFILIAL("DA1") + xTabela +  xProd) )
        xPrcVen := DA1->DA1_PRCVEN
          
		xCFiscal:= Subs(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB
                             
		RecLock("SCK",.T.)
                SCK->CK_FILIAL := xFilial("SCK")
                SCK->CK_NUM    := cPedido
                SCK->CK_PRODUTO:= xProd
                SCK->CK_UM     := xUm
                SCK->CK_QTDVEN := TMP->QTD                           
                SCK->CK_PRCVEN := xPrcVen
                SCK->CK_VALOR  := TMP->QTD*xPrcVen                          
                SCK->CK_PRUNIT := xPrcVen                           
                SCK->CK_TES    := SB1->B1_TS
                SCK->CK_CLASFIS:= xCFiscal
                SCK->CK_DESCRI := SB1->B1_DESC
                SCK->CK_ITEM   := cItem //strzero(xItem,2)
				SCK->CK_PEDCLI := TMP->ID
                SCK->CK_ENTREG := TMP->DTSAIDA
                SCK->CK_HORA   := '0000'                                                                          
                SCK->CK_LOCAL  := xLocal
                SCK->CK_LINHA  := ''
                SCK->CK_SETOR  := 'YMDA'
                SCK->CK_TPEDIDO:= ''
                SCK->CK_FILVEN := '01'
                SCK->CK_FILENT := '01'
                SCK->CK_CLIENTE:= '028'
                SCK->CK_LOJA   := '01'
                SCK->CK_ENTREGA:= 'YAMAHA'
                SCK->CK_LOCALIZ:= "EXPEDICAO"
                //SCK->CK_FILIALP:= SUBS(vProd[i][9],8,5)//Inclus�o para atender a Honda dia 10/2011
                
        MsUnlock()
         
	    cIteFim := cItem
		cItem   := Soma1(cItem, 2)
	
		TMP->(dbSkip())	
	Enddo                     
	
	cItem  := "01"
	
Enddo

Return Nil

************************************************************************************************************************************************
Static Function PCP004h()        
   Local _cDir := Alltrim(cDirArq)
   CpyS2T( "\SYSTEM\"+_cNomeArq, _cDir, .F. ) /// Copia atabela para a unidade C do usuario
   fErase(_cNomeArq) /// Remove o arquivo do servidor  
   oExcelApp := MsExcel():New()										// Cria um objeto para o uso do Excel
   oExcelApp:WorkBooks:Open(_cDir +"\"+_cNomeArq)	// Atribui � propriedade WorkBooks do Excel
   oExcelApp:SetVisible(.T.)											// Abre o Excel com o arquivo criado exibido na Primeira planilha.
Return
************************************************************************************************************************************************

Static Function LerCmpTXT(nHldTXT, nNumCar)

Local cTexto := ""

If nNumCar == Nil					// Posicionar no final da linha

	cTexto := Space(1)

	While .t.

		FREAD(nHdlTXT,@cTexto,1)
		
		If cTexto == Chr(10) .Or. cTexto == Chr(13)
			FREAD(nHdlTXT,@cTexto,1)
			Return Nil
		End If
		
	End

End If

cTexto := Space(nNumCar)

FREAD(nHdlTXT,@cTexto,nNumCar)

Return cTexto

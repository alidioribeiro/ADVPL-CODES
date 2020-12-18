#Include 'Protheus.ch'
#Include 'Apvt100.ch'
/*
 .------------------------------------------------------------------------------------------.
|   Programa   |   NSACDG13   |   Autor   |   ALEX - GIT         |   Data   |   12/05/2010   |
|--------------------------------------------------------------------------------------------|
|   Descri��o  |   Rotina para Apontamento de Producao via Coletor de Dados.                 |
|--------------------------------------------------------------------------------------------|
|   Uso        |   NSB - ACD                                                                 |
|--------------------------------------------------------------------------------------------|
|   Altera��o  |   Descri��o                                                                 |
|--------------------------------------------------------------------------------------------|
|   18/04/2011 |   Jorge - Inclusao do Apontamento de Perdas e Horas Paradas.                |
|   11/08/2017 |   Wagner - Considerar par�metro MV_XAPLCPAD, que indica quais PI's n�o se-  |
|              |   r�o apontados no armazem definido no par�mtro MV_ACDARPI                  |
 '------------------------------------------------------------------------------------------'
*/

User Function ACDG13()

Local aTela      := vtsave()
Local nOpcao     := 0

//
// Verifica se utiliza controle de transacao.
//

Private lTTS         := IIF( GetMV('MV_TTS') == 'S', .T., .F.)
Private cProduto     := Space( TamSX3('B1_COD')[1])
Private cDescProd    := Space( TamSX3('B1_DESC')[1])
Private cLote        := Space( TamSX3('D3_LOTECTL')[1])
Private nQE          := 0
Private nQuantProd   := 0
Private nQuantPerd   := 0
Private nQuantLida   := 0
Private nQuantEtiq   := 0
Private cOP          := Space(11)
Private cUM          := Space(tamsx3('C2_UM')[1])
Private cCC          := Space(tamsx3('C2_CC')[1])
Private cRecurso     := Space(tamsx3('C2_RECURSO')[1])
Private cLocal       := Space(tamsx3('C2_LOCAL')[1])
Private cLocalizacao := Space(tamsx3('B1_ENDPAD')[1])
Private cEtiqueta    := Space(10)
Private aTmpEtiq     := {}                       
Private lSair        := .F.   
Private lPrimera     := .T.
Private bKey26       := VTSetKey(26, {|| ACDG13Z()}, "Finaliza" )  // CTRL+Z
//
//
//
While .T.
	
	While !lSair
		VTClear
		cEtiqueta  := Space(10)
		//
		VTReverso(.T.)
		
		@ 00,02 vtSay 'Apontamento de O.P.'
		
		VTReverso(.F.)
		//
		@ 01,00 VTSay 'OP: '
		@ 01,04 VTGet cOP PICTURE '@!' WHEN .F.
		
		@ 02,00 VTSay 'Prd: '
		@ 02,04 VTGet cProduto PICTURE '@!' WHEN .F.
		
		@ 03,00 VTSay 'Sld.:'
		@ 03,05 VTGet nQuantProd picture '@E 999,999.99' when .F.
		
		@ 04,00 VTSay 'Qtd.:'
		@ 04,05 VTget nQuantLida picture '@E 999,999.99' when .F.
		
		@ 05,00 VTSay 'Etq.:'
		@ 05,05 VTGet nQuantEtiq picture '@E 999,999.99' when .F.
		
		@ 06,00 VTSay 'Numero da Etiqueta.:'
		@ 07,00 VTGet cEtiqueta PICTURE '@!' VALID !Empty(cEtiqueta) .and. ValidEtiqueta(cEtiqueta) F3 'CB0'
		VTRead

		If VtLastKey() == 27
			EXIT
		EndIf

	End
	//
	If  VTLastKey() == 27 .and. !lSair
		If VTYesno("Deseja sair da rotina ?","Pergunta",.t.)
			EXIT
		Endif
	ElseIf vtYesNo("Confirma o apontamento ?","Pergunta",.t.)
		If !Empty(cOP)
			
			// JORGE EM:18/04/2011
			nQuantPerd := 0
			If VTYesNo("Cadastrar Perdas?","Aviso" ,.T.)
				VTClear
				VTReverso(.T.)
				@ 00,02 VTSay 'Apontamento de Perda.'
				vtReverso(.F.)
				
				@ 01,00 VTSay 'Perda: '
				@ 01,06 VTGet nQuantPerd picture '@E 999,999.99' // when .F.
				VTRead
				
				If VtLastKey() == 27
					Exit
				EndIf
			Endif
			//
			vtBeep(2)
			//
			If lTTS
				BEGIN Transaction
				Aponta()
				dbCommitAll()
				END Transaction
			Else
				Aponta()
				dbCommitAll()
			Endif
			
			VTKeyBoard(chr(0))
			VTClearBuffer()
			//
			aTmpEtiq   := {}
			cEtiqueta  := Space(10)
			cOP        := Space(11)
			cProduto   := Space( TamSX3('B1_COD')[1])
			cDescProd  := Space( TamSX3('B1_DESC')[1])
			nQuantProd := 0
			nQuantPerd := 0
			nQuantLida := 0
			nQuantEtiq := 0
			lSair      := .F.
			//
		Else
			lSair := .F.
			VTAlert('Atencao: Apontamento Nao Realizado! ', 'Aviso', .T., 2000)
			VTBeep(2)
		Endif
		//
		VTGetRefresh('cEtiqueta')
		VTGetRefresh('cOP')
		VTGetRefresh('cProduto')
		VTGetRefresh('cDescProd')
		VTGetRefresh('nQuantProd')
		VTGetRefresh('nQuantPerd')
		VTGetRefresh('nQuantLida')
		VTGetRefresh('nQuantEtiq')
	Else
		lSair := .F.
	Endif
End

Return
//
// Apontamento de Produ��o
//
Static Function APONTA()

Local aMata250   := {}
Local nSeq       := 0
Local nModuloOld := 0
Local dDtValid   := 0
Local cNumSeq    := ''
Local cTM        := GetMV('MV_TMPAD') // Tipo de movimenta��o para o apontamento de produ��o.
Local nX := 0 

Private cDocD3      := ""
Private cNumSeqD3   := ""
Private cLoteCtlD3  := ""
Private cNumLoteD3  := ""
Private lMsErroAuto	:= .F.
Private	lMsHelpAuto	:= .T.
Private	aEtiqImp    := {}

//
// Apontamento de OP e cria��o de etiquetas.
//

dDtValid := Posicione('SB1', 1, xFilial('SB1') + cProduto, 'B1_PRVALID')
cUM      := Posicione('SB1', 1, xFilial('SB1') + cProduto, 'B1_UM')

lExiste := .T.

While lExiste
	cDocD3 := GetSx8Num('SD3','D3_DOC')
	ConfirmSX8()
	If Empty(Posicione('SD3', 2, xFilial('SD3') + cDocD3, 'D3_EMISSAO'))
	   lExiste := .F.
	Endif
End
//
// Posiciona na Ordem de Produ��o.
//
dbselectarea('SC2')
dbsetorder(1)
dbseek(xFilial('SC2') + cOP)
//
// Apontamento de produ��o.
//
aMata250 := {{'D3_TM'     , cTM         , NIL},;
             {'D3_COD'    , cProduto	, NIL},;
   	         {'D3_UM'     , cUM         , NIL},;
       	     {'D3_OP'     , cOP         , NIL},;
             {'D3_LOCAL'  , cLocal      , NIL},;
   	         {'D3_EMISSAO', dDataBase   , NIL},;
       	     {'D3_DOC'    , cDocD3      , NIL},;
             {'D3_QUANT'  , nQuantLida  , NIL},;
             {'D3_PERDA'  , nQuantPerd  , NIL},;
   	         {'D3_CC'     , cCC         , NIL},; 
   	         {'D3_LOTECTL', SUBS(ALLTRIM(cOP),1,8)+"01" , NIL},;       // Alidio em 10/09/2019
   	         {'D3_RECURSO', cRecurso    , NIL} }

If Rastro(SC2->C2_PRODUTO)
	aAdd( aMata250, {'D3_DTVALID', dDataBase + dDtValid, NIL})
EndIf
             
VTMsg("Realizando Apontamento. Aguarde...")

nModuloOld  := nModulo
nModulo     := 4

MSExecAuto({|x| mata250(x)}, aMata250)

nModulo     := nModuloOld

If lMSErroAuto
	If IsTelnet()
		VTDispFile(NomeAutoLog(),.t.)
	Else
		TerDispFile(NomeAutoLog())
	Endif
	return ! lMSErroAuto
Else  
    //                        
    cProduto := SC2->C2_PRODUTO
    //
    If !Empty(SC2->C2_DATRF) .and. AllTrim(SC2->C2_CC) $ "211/221/231/717/241/251"
	    RecLock("SC2", .F.)
	    SC2->C2_DATRF := CTOD("  /  /  ")
	    SC2->(MsUnlock())
        vtAlert('A OP '+cOp+' sera reaberta para apontamento de perda!', 'Aviso', .T., 2000)
	    vtBeep(2)     	              
    Endif
    //
	SD3->( dbsetorder(2))
	SD3->( dbSeek(xFilial("SD3") + cDocD3 + cProduto) )

	cNumSeqD3  := SD3->D3_NUMSEQ
	cLoteCtlD3 := SD3->D3_LOTECTL
	cNumLoteD3 := SD3->D3_NUMLOTE

	CB0->( dbSetorder(1) )
	For nX := 1 to Len(aTmpEtiq)
	
	   	If CB0->(dbSeek(xFilial("CB0")+ aTmpEtiq[nX,2]))

			RecLock("CB0",.F.)
			CB0->CB0_NFENT  := cDocD3
			CB0->CB0_NUMSEQ := cNumSeqD3
			CB0->CB0_DTAPON := dDatabase
			CB0->CB0_HRAPON := Time()	   	                                
			//
			// Wagner - 16/08/2017 - Apontar no local definido em C2_LOCAL, quando o almoxarifado da ordem estiver em MV_XAPLOCP
			//
			If Posicione( "SB1", 1, xFilial("SB1") + cProduto, "B1_TIPO") == "PI" .and. SC2->C2_LOCAL<>AllTrim( GetMV("MV_LOCPROC")) .and. GetMV("MV_ACDAPPI") == "S" .and.;
				!(AllTrim(SC2->C2_LOCAL) $ AllTrim(GetMV("MV_XAPLOCP")) )
				CB0->CB0_LOCAL := AllTrim( GetMV("MV_ACDARPI") )
				cLocal := AllTrim( GetMV("MV_ACDARPI") )
			Endif
			
			CB0->CB0_LOCORI := cLocal
			CB0->CB0_LOCALI := cLocalizacao
			CB0->CB0_USUARI := POSICIONE('CB1', 2, xfilial('CB1') + __cuserid, 'CB1_CODOPE')
			MsUnlock()
	  	EndIf
	Next      
	//
	// Incluido pela Aglair para ajustar o processo da Inje��o Plastica
	//
	If !Empty( cLocalizacao )
		VTMsg("Realizando o Enderecamento ...")
	    Endereca()
	EndIf 
	//
	vtalert('Documento de Producao: '+cDocD3+' ', 'Aviso', .T., 2000)
	//
EndIf
//
//
//
vtclear
aOP        := {}
aEtiqImp   := {}
nQE        := 0
nQuantProd := 0
cProduto   := space(tamsx3('C2_PRODUTO')[1])
cDescProd  := space(tamsx3('B1_DESC')[1])
cLote      := space(tamsx3('D3_LOTECTL')[1])

Return

//
//
Static Function Endereca() 
Local nModuloOld := 0
Local aCab   := {}
Local aItens := {}
Local aItensSDB := {}
Local aParam := {}
//
Private lMsErroAuto	:= .F.
Private lMsHelpAuto	:= .T.

aCab:= {{"DA_PRODUTO"	, cProduto 			,NIL},; 
		{"DA_NUMSEQ"	, cNumSeqD3        	,NIL},;
		{"DA_LOCAL"		, cLocal            ,NIL},;
		{"DA_DOC"	    , cDocD3           	,NIL},;
		{"DA_LOTECTL"   , cLoteCtlD3	 	,NIL},; 
		{"DA_NUMLOTE"   , cNumLoteD3	 	,NIL}	}


aItens:= {	{"DB_ITEM"	  , "0001"         	,NIL},;
	        {"DB_ESTORNO" , " "	            ,Nil},;                   
			{"DB_LOCALIZ" , cLocalizacao	,NIL},; 
			{"DB_DATA"	  , dDatabase		,NIL},;
			{"DB_QUANT"	  , nQuantLida		,NIL} } 

aadd( aItensSDB, aItens)
	

nModuloOld  := nModulo
nModulo     := 4
//	
Begin Transaction
	MSExecAuto({|x,y| mata265(x,y)}, aCab, aItensSDB, 3)  //3 Distribui

	If lMsErroAuto
		DisarmTransaction()
		Break
	EndIf 
End Transaction	
//
If lMSErroAuto
   VTDispFile(NomeAutoLog(),.t.)
Endif			
nModulo     := nModuloOld
Return(lMSErroAuto)
//
//
//
Static Function fConfirma(cCont)
Local lRet	:= .t.

If Upper(cCont) != '1' .AND. Upper(cCont) != '0'
	lRet := .F.
Endif
Return(lRet)
//
//
Static Function ValidEtiqueta(cQR)
Local lRet  := .F.
//
//                  
dbSelectarea("CB0")                  
dbsetorder(1)
If !CB0->(dbSeek(xFilial("CB0")+ cQR ))
    vtalert('Etiqueta n�o existe!', 'AVISO', .T., 2000)
	Return(lRet)
Else                      
    If !Empty(CB0->CB0_USUARI) .AND. !Empty(CB0->CB0_DTAPON) .AND. !Empty(CB0->CB0_HRAPON) .AND. !Empty(CB0->CB0_NUMSEQ) .AND. !Empty(CB0->CB0_LOCORI)
	    vtalert('Etiqueta nao disponivel p/ apontamento!', 'AVISO', .T., 3000)   
		Return(lRet)    
    Endif
    //
    If !Empty(CB0->CB0_DTAPON) .AND. !Empty(CB0->CB0_HRAPON) .AND. !Empty(CB0->CB0_LOCORI)
	    vtalert('Etiqueta ja Apontamenta!', 'AVISO', .T., 3000)   
		Return(lRet)    
    Endif    
    //
	If Empty(cOp)
		cOp := CB0->CB0_OP
		//
		SC2->(dbsetorder(1))
		If !SC2->(dbSeek(xFilial("SC2")+ cOP))
		    vtAlert('OP n�o Encontrada!', 'AVISO', .T., 3000)   
		    cOp := Space(11)
			Return(lRet)
		Else   
			If (SC2->C2_QUANT - (SC2->C2_QUJE+SC2->C2_PERDA) ) == 0
			   	vtAlert('OP j� produzida completamente!', 'AVISO', .T., 3000)
			    cOp := Space(11)
				Return(lRet)
			Endif	   
			If !Empty(SC2->C2_DATRF)
			   vtAlert('OP j� encerrada!', 'AVISO', .T., 3000)
			    cOp := Space(11)			   
			   Return(lRet)
			Endif    
			//
        	cLocalizacao := Posicione('SB1', 1, xFilial('SB1')+ SC2->C2_PRODUTO, 'B1_ENDPAD')			
            //
	        If Empty( cLocalizacao )
            	vtAlert('O produto sem End. Pad. E necessario Cadastrar.', 'AVISO', .T., 3000)
			    cOp := Space(11)			   
			    Return(lRet)
			Endif			
            //
            //
        	cProduto     := SC2->C2_PRODUTO
        	cDescProd    := Posicione('SB1', 1, xfilial('SB1')+ cProduto, 'B1_DESC')
        	nQuantProd   := SC2->C2_QUANT - (SC2->C2_QUJE+SC2->C2_PERDA)
        	nQuantPerd   := SC2->C2_PERDA	        	
            //
        	/* CUSTOMIZADO ALEX P/ ATENDER APONT. ARMAZEM INTERMEDIARIO	*/
        	SB1->(dbSetorder(1))
        	SB1->(dbSeek(xFilial("SB1")+cProduto) )
        	If SB1->B1_TIPO == "PI" .AND. SC2->C2_LOCAL <> GETMV("MV_LOCPROC") .AND. GETMV("MV_ACDAPPI") == "S" .and. !(AllTrim(SC2->C2_LOCAL) $ AllTrim(GetMV("MV_XAPLOCP")) )
          	   cLocal    := Alltrim(GETMV("MV_ACDARPI"))  
          	   //
          	   SB2->(dbSetOrder(1))
          	   If !SB2->(dbSeek(xFilial("SB2")+cProduto+cLocal))
          	   		RecLock("SB2", .T.)
          	   		SB2->B2_FILIAL := xFilial("SB2") 
          	   		SB2->B2_COD    := cProduto
          	   		SB2->B2_LOCAL  := cLocal
          	   		SB2->(MsUnlock())
          	   Endif
        	Else                            	
          	   cLocal    := SC2->C2_LOCAL
        	Endif                                                                   
        	//
           	If Posicione("SB1", 1, xFilial("SB1") + cProduto, "B1_TIPO") == "PI" .and. SC2->C2_LOCAL <> GetMV("MV_LOCPROC") .and. GetMV("MV_ACDAPPI") == "S" .and. !(AllTrim(SC2->C2_LOCAL) $ AllTrim(GetMV("MV_XAPLOCP")) ) .and.;
			   AllTrim( Posicione("SBE", 1, xFilial("SBE") + cLocal + cLocalizacao, "BE_LOCALIZ")) <> AllTrim( cLocalizacao )

               vtAlert('O endereco padrao do produto nao cadastrado no armazem intermediario!', 'AVISO', .T., 3000)
			   cOp := Space(11)			   

			   Return( lRet )
			Endif
			//        	
        	/* CUSTOMIZADO ALEX P/ ATENDER APONT. ARMAZEM INTERMEDIARIO	*/        	
        	//
        	cRecurso     := SC2->C2_RECURSO
        	cCC          := SC2->C2_CC
        	//
	       	vtGetRefresh('cOP')
			vtGetRefresh('cProduto')
			vtGetRefresh('cDescProd')
			vtGetRefresh('nQuantProd')
			vtGetRefresh('nQuantPerd')
    	Endif    
    //Else
	Endif
	//
	If  (nPos := aScan(aTmpEtiq, { |x| AllTrim(x[2]) == AllTrim(cQr) }) ) > 0
		vtAlert('Etiqueta j� foi lida!', 'AVISO', .T., 2000) 
		//AEval( aTmpEtiq, { |aTmpEtiq| vtAlert(Alltrim(aTmpEtiq[2])) } )
		Return(lRet)
	Endif  
	//
	If Posicione('SC2', 1, xFilial('SC2') + cOp, 'C2_PRODUTO') <> CB0->CB0_CODPRO
		vtAlert('Etiqueta nao pertence a esse produto!', 'AVISO', .T., 2000)
		Return(lRet)
	Endif 
	//
	If Posicione('SC2', 1, xfilial('SC2')+ cOp, 'C2_LOCAL') <> CB0->CB0_LOCAL .and. CB0->CB0_LOCAL <> Alltrim(GETMV("MV_ACDARPI"))
		vtAlert('Local da etiqueta lida � diferente do local do produto atual !', 'AVISO', .T., 2000)
		Return(lRet)
	Endif

	If nQuantProd < CB0->CB0_QTDE + nQuantLida
		vtAlert('Quantidade lida � maior que a quantidade pendente da OP', 'AVISO', .T., 2000)
		Return(lRet)
	Endif  
	
	If !lPrimera
		aadd(aTmpEtiq, { CB0_CODPRO+ CB0_LOCAL+ CB0_LOCALI+ CB0_NUMSER+ CB0_LOTE+ CB0_SLOTE, cQr, CB0_CODPRO, CB0_LOTE, CB0_SLOTE, CB0_NUMSER, CB0_QTDE, CB0_LOCAL, CB0_LOCALI })	
	 	nQuantLida += CB0_QTDE
		nQuantEtiq ++
	Endif     
	
	lPrimera := .F.

	//                     
	cEtiqueta := space(10)
	vtGetRefresh('nQuantLida')
	vtGetRefresh('nQuantEtiq')
	vtGetRefresh('cEtiqueta')	
	//
Endif
Return lRet
//
//
//
Static Function LerNumSeq()

Local aStruSD3  := SD3->(dbStruct())
Local cAliasSD3 := "TMPSD3"
Local nX        := 0
Local aParam    := { "", ""}
//
cQuery := " SELECT SD3.*, SDA.* "
cQuery +=   " FROM " + RetSqlName('SD3') + " SD3 "
cQuery += " INNER JOIN "+ RetSqlName('SDA') + " SDA  ON (D3_DOC+D3_NUMSEQ+D3_LOTECTL+D3_COD=DA_DOC+DA_NUMSEQ+DA_LOTECTL+DA_PRODUTO) "
cQuery += " WHERE "
cQuery +=   " SD3.D3_FILIAL  = '" + xFilial("SD3") + "' AND "
cQuery +=   " SD3.D3_DOC     = '" + cDocD3         + "' AND "
cQuery +=   " SD3.D3_OP      = '" + cOp            + "' AND "
cQuery +=   " SD3.D3_COD     = '" + cProduto       + "' AND "
cQuery +=   " SD3.D_E_L_E_T_ = ' ' AND "
cQuery +=   " SDA.DA_FILIAL  = '" + xFilial("SDA") + "' AND "
cQuery +=   " SDA.D_E_L_E_T_ = ' ' AND "            
cQuery +=   " SDA.DA_SALDO > 0 "            
cQuery +=   " ORDER BY D3_COD "
cQuery := ChangeQuery(cQuery)

If Select("TMPSD3") > 0
   TMPSD3->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD3,.T.,.T.)
For nX := 1 To Len(aStruSD3)
	If ( aStruSD3[nX][2] <> "C" ) .and. FieldPos(aStruSD3[nX][1]) > 0
		TcSetField(cAliasSD3, aStruSD3[nX][1], aStruSD3[nX][2], aStruSD3[nX][3], aStruSD3[nX][4])
	EndIf
Next nX
//
aParam[1] := TMPSD3->DA_LOTECTL
aParam[2] := TMPSD3->DA_NUMSEQ
TMPSD3->(dbCloseArea())

Return(aParam)
//
//
//
Static Function ACDG13Z()

If VTYesNo("Deseja realizar o apontamento?","Aviso" ,.T.)
	lSair := .T.
	vtKeyBoard( Chr(27) )
Endif

Return
//
//
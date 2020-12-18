#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PCPR13    º Autor ³ Rogerio S. Cavalcante º Data ³  06/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Avaliacao de Produtos PA, quanto ao Planejado, Produzido e    º±±
±±º          ³ Vendido                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7 IDE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PCPR13()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := "Avaliacao de Producao Mensal"
	Local cPict          := ""
	Local titulo         := "Controle Diario de Producao"
	Local nLin           := 80
	Local Cabec1         := ""
	Local Cabec2         := ""
	Local imprime        := .T.
	Local aOrd           := {}           
	Private cPerg        := "PCPR13"
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 220
	Private tamanho      := "G"
	Private nomeprog     := "PCPR13" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "PCPR13" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cString      := "SC2"
	Private aMov         := {"P","R","S"}                        
    Private c_Cods       := ""
	dbSelectArea("SB1")
	dbSetOrder(1)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ValidPerg(cPerg)
	pergunte(cPerg,.F.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                        ³
	//³ mv_par01             // Data Ref. (MMAAAAA)                 ³
	//³ mv_par02             // Do Produto                          ³ 
	//³ mv_par03             // Ate o Produto                       ³
	//³ mv_par04             // Do Recurso                          ³ 
	//³ mv_par05             // Ate o Recurso                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
	 	 Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
  	 Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)
	nAno  := Val(subs(mv_par01,3,4))
	aMes    := {}
	aadd(aMes,{"Janeiro"  ,"31"})
	aadd(aMes,iif(Mod(nAno,4) = 0 ,{"Fevereiro","29"},{"Fevereiro","28"}))
	aadd(aMes,{"Março"    ,"31"})
	aadd(aMes,{"Abril"    ,"30"})
	aadd(aMes,{"Maio"     ,"31"})
	aadd(aMes,{"Junho"    ,"30"})
	aadd(aMes,{"Julho"    ,"31"})
	aadd(aMes,{"Agosto"   ,"31"})
	aadd(aMes,{"Setembro" ,"30"})
	aadd(aMes,{"Outubro"  ,"31"})
	aadd(aMes,{"Novembro" ,"30"})
	aadd(aMes,{"Dezembro" ,"31"})
	aTRB := {}              
	aTam := TAMSX3("B1_FILIAL")
	aAdd( aTRB , { "RB_FILIAL"   , "C" , aTam[1], aTam[2] })
	aTam := TAMSX3("B1_COD")
	aAdd( aTRB , { "RB_COD"      , "C" , aTam[1], aTam[2] })
 	aAdd( aTRB , { "RB_OPER"     , "C" ,   1    , 0       }) 
    aTam  := TAMSX3("D3_CUSTO1")	 	
    aAdd( aTRB , { "RB_SALINI" , "N" , aTam[1] , aTam[2] })  
    aTam  := TAMSX3("D3_QUANT")	                                               
    nMes    := Val( substr(mv_par01,1,2) )
    nAno    := Val( substr(mv_par01,3,4) )
    cDiaIni := "01"
    cDiaFin := aMes[nMes, 2]
    nDiaFin := Val(cDiaFin)
    aDias   := {}
    For nX := 1 to nDiaFin
        cDia := Alltrim(Strzero(nX,2))
    	aAdd(aTRB,{ "RB_DIA"+cDia , "N" , aTam[1] , aTam[2] })  
    Next  	                
    aTam  := TAMSX3("D3_CUSTO1")	 	
    aAdd( aTRB , { "RB_TOTAL"  , "N" , aTam[1] , aTam[2] })  
	cArqTRB := CriaTrab(aTRB,.T.)                            
	cIndTRB := CriaTrab(Nil,.F.)                             
	Use &(cArqTRB) alias TRB new 
    IndRegua("TRB",cIndTRB,"RB_FILIAL+RB_COD+RB_OPER",,,"Gerando indice temporario...")
	Processa ({|lEnd| RunProc(@lEnd)}, "Aguarde...","Processando Movimentacoes dos Produto", .F. )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    Titulo := "Controle Diaria de Producao. Mes de "+aMes[nMes][1]
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	DbSelectArea("TRB")
	DbCloseArea()     
    FErase(cIndTRB)
	Ferase("PCPR13.DBF")
    FRename(cArqTRB+".DBF","PCPR13.DBF")
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNPROC   º Autor ³ Rogerio S. Cavalcante   º Data ³  06/02/04  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Processamento de Planejamento, Producao e Vendas dos Produtos  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunProc(lEnd)
  c_Cods  := ""
  dDatIni := Ctod( cDiaIni+"/"+StrZero(nMes,2)+"/"+StrZero(nAno,4) )
  dDatFin := Ctod( cDiaFin+"/"+StrZero(nMes,2)+"/"+StrZero(nAno,4) )
  // Processamento Planejamento de Producao - SC2
  dbSelectArea("SC2")
  cArqSC2 := CriaTrab(NIL,.F. )
  cKeySC2 := "C2_Filial+DTOS(C2_EMISSAO)+C2_PRODUTO"
  IndRegua("SC2",cArqSC2,cKeySC2,,,"Selecionando Registros...")
  dbselectarea("SC2")  
  DbGotop()
  dbSeek(xFilial("SC2")+dtos(dDatIni),.T.)
  While !SC2->(EOF()) .and. xFilial("SC2")=SC2->C2_Filial .and. Dtos(SC2->C2_EMISSAO) <= Dtos(dDatFin)
  
        IncProc("Processando Producao Planejada - Dia: " +DtOC(SC2->C2_EMISSAO))
        
        if !(mv_par02 <= SC2->C2_PRODUTO .and. SC2->C2_PRODUTO <= mv_par03)
           dbskip()
           loop
        endif
        
        if !(mv_par04 <= SC2->C2_RECURSO .and. SC2->C2_RECURSO <= mv_par05) .and. !Empty(SC2->C2_RECURSO)
           If !(ALLTRIM(SC2->C2_PRODUTO) $ c_Cods)
              c_Cods += SC2->C2_PRODUTO+"\"
           EndIf
        endif
        
        if !(Posicione("SB1",1,xFilial("SC2")+SC2->C2_PRODUTO,"B1_TIPO")) $ 'PA/PI' //.or. Alltrim(SD3->D3_TM) != "400" .or. SD3->D3_ESTORNO = "S"
           dbskip()
           loop    
        endif
        
        nDia := day(SC2->C2_EMISSAO)
        if aScan(aDias,nDia) = 0
           aAdd(aDias,nDia)
        endif
        cCampo := "RB_DIA"+strzero(nDia,2)
        DbSelectArea("TRB")
        if !DbSeek(xFilial()+SC2->C2_PRODUTO+aMov[1])
           RecLock("TRB",.T.)
            RB_FILIAL   := xFilial() 
            RB_COD      := SC2->C2_PRODUTO
            RB_OPER     := aMov[1]
            &(cCampo)   := SC2->C2_QUANT
        else                 
           RecLock("TRB",.F.)
            &(cCampo) := &(cCampo) + SC2->C2_QUANT 
        endif   
        RB_TOTAL    := RB_TOTAL + SC2->C2_QUANT
        MsUnlock()
        DbSelectArea("SC2")
        DbSkip()
  End
  Ferase(cArqSC2)
  
  // Processamento de Producao Realizado - SD3
  dbSelectArea("SD3")
  dbSetOrder(6)
  DbSeek(xFilial("SD3")+Dtos(dDatIni),.T.)
  While !SD3->(EOF()) .and. xFilial("SD3")=SD3->D3_Filial .and. Dtos(SD3->D3_EMISSAO) <= Dtos(dDatFin)
  
        IncProc("Processando Producao Realizada - Dia " +DtOC(SD3->D3_EMISSAO))
        
        if !(mv_par02 <= SD3->D3_COD .and. SD3->D3_COD<= mv_par03)
           dbskip()
           loop
        endif
        
/*        if !(Alltrim(SD3->D3_TIPO) $ 'PA/PI') .Or. SD3->D3_ESTORNO = "S"
           dbskip()
           loop    
        endif*/
/* TESTE         
        if !(Alltrim(SD3->D3_TM)$"400/499") .Or. !(SD3->D3_Local $ "01/10/20")
           dbskip()
           loop    
        endif    
        */
       if !(Alltrim(SD3->D3_TM)$"400") .Or. SD3->D3_ESTORNO = "S"
           dbskip()
           loop    
        endif    

        
        nDia := day(SD3->D3_EMISSAO)
        if Ascan(aDias,nDia) = 0
           aadd(aDias,nDia)
        endif
        cCampo := "RB_DIA"+strzero(nDia,2)
        DbSelectArea("TRB")
        if !DbSeek(xFilial()+SD3->D3_COD+aMov[2])
           RecLock("TRB",.T.)
            RB_FILIAL   := xFilial() 
            RB_COD      := SD3->D3_COD
            RB_OPER     := aMov[2]
            &(cCampo)   := SD3->D3_QUANT           
        else                 
           RecLock("TRB",.F.)
            &(cCampo) := &(cCampo) + SD3->D3_QUANT
        endif   
        RB_TOTAL    := RB_TOTAL + SD3->D3_QUANT           
        MsUnlock()
        DbSelectArea("SD3")
        DbSkip()
  End 
           
  // Processamento de Vendas - SD2 
  dbSelectArea("SD2")
  dbSetOrder(5)
  DbSeek(xFilial("SD2")+Dtos(dDatIni),.T.)
  While !SD2->(EOF()) .and. xFilial("SD2")=SD2->D2_Filial .and. Dtos(SD2->D2_EMISSAO) <= Dtos(dDatFin)
        IncProc("Processando Vendas - Dia: " +DtoC(SD2->D2_EMISSAO))
        if !(mv_par02 <= SD2->D2_COD .and. SD2->D2_COD <= mv_par03)
           dbskip()
           loop
        endif
        
        if Alltrim(SD2->D2_TP) != 'PA' 
           dbskip()
           loop    
        endif

        
        If !(Alltrim(SD2->D2_TES) $ '511/519/534/510/512/712/711')
           dbSkip()
           loop
        endif  
        
        nDia := day(SD2->D2_EMISSAO)
        if Ascan(aDias,nDia) = 0
           aadd(aDias,nDia)
        endif
        cCampo := "RB_DIA"+strzero(nDia,2)
        DbSelectArea("TRB")
        if !DbSeek(xFilial()+SD2->D2_COD+aMov[3])
           RecLock("TRB",.T.)
            RB_FILIAL   := xFilial() 
            RB_COD      := SD2->D2_COD
            RB_OPER     := aMov[3]
            &(cCampo)   := SD2->D2_QUANT
        else                 
           RecLock("TRB",.F.)
            &(cCampo) := &(cCampo) + SD2->D2_QUANT
        endif   
        RB_TOTAL    := RB_TOTAL + SD2->D2_QUANT
        MsUnlock()
        DbSelectArea("SD2")
        DbSkip()
  End          
  
  // Requisicao p/ Processo (PI) - SD3 
  dbSelectArea("SD3")
  dbSetOrder(6)
  DbSeek(xFilial("SD3")+Dtos(dDatIni),.T.)
  While !SD3->(EOF()) .and. xFilial("SD3")=SD3->D3_Filial .and. Dtos(SD3->D3_EMISSAO) <= Dtos(dDatFin)
  
        IncProc("Requisicao p/ Processo - Dia: " +DtoC(SD3->D3_EMISSAO))
        
        DbSelectArea("SB1")
        DbSeek(xFilial()+SD3->D3_COD)
        
        dbSelectArea("SD3")
        if !(mv_par02 <= SD3->D3_COD .and. SD3->D3_COD <= mv_par03)
           dbskip()
           loop
        endif 
//        if Alltrim(SD3->D3_TIPO) != 'PI' .Or. SD3->D3_ESTORNO == "S" .Or. !(AllTrim(SD3->D3_CF)$'RE2/RE3/RE4/RE0')  Alt. devido a necessidade das perdas irem para o custo
        Cond:=.T.
        if Alltrim(SD3->D3_TIPO) != 'PI' .Or. SD3->D3_ESTORNO == "S" .Or. ! (AllTrim(SD3->D3_CF)$'RE2/RE3/RE4/RE5/RE0') //.or. (SD3->D3_CF='RE5' .and. SD3->D3_GRUPO='GGF'   )))
	      	dbskip()
    	    loop    
          //Incluido para tratar o RE5 
        endif 
        
        If Sb1->b1_locpad <> "10" .and. AllTrim(SD3->D3_CF)$'RE2'        
           dbskip()
           loop    
        endif 
        
        nDia := day(SD3->D3_EMISSAO)
         
        if Ascan(aDias,nDia) = 0
           aadd(aDias,nDia)
        endif
        
        cCampo := "RB_DIA"+strzero(nDia,2)
        DbSelectArea("TRB")
        if !DbSeek(xFilial()+SD3->D3_COD+aMov[3])
           RecLock("TRB",.T.)
            RB_FILIAL   := xFilial() 
            RB_COD      := SD3->D3_COD
            RB_OPER     := aMov[3]
            &(cCampo)   := SD3->D3_QUANT
        else                 
           RecLock("TRB",.F.)
            &(cCampo) := &(cCampo) + SD3->D3_QUANT
        endif   
        RB_TOTAL    := RB_TOTAL + SD3->D3_QUANT
        MsUnlock()
        
        DbSelectArea("SD3")
        DbSkip()
  End          

  DbSelectArea("TRB")	 
  
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP7 IDE            º Data ³  06/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
  Local nOrdem
  private cCabec := ""
  aSort(aDias)
  for xI:=1 to len(aDias)
     cCabec := cCabec +"|   "+StrZero(aDias[xI],2)
  next                  
  Cabec1 := "Modelo / Dias de Producao:        " + cCabec+ "|  TOTAL| SLD FIM"
  Cabec2 := ""
  dDatIni := Ctod(StrZero(aDias[1],2)+"/"+StrZero(nMes,2)+"/"+StrZero(nAno,4) )
  dbSelectArea("TRB")
  dbGoTop()
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ SETREGUA -> Indica quantos registros serao processados para a regua ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  SetRegua(RecCount())
  While !EOF()
       Incregua()
   	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³ Verifica o cancelamento pelo usuario...                             ³
  	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   If lAbortPrint
  	      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
    	  Exit
	   Endif
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  	   //³ Impressao do cabecalho do relatorio. . .                            ³
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  	   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
    	  Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
          nLin := 8
	   Endif  
	   
	   If (ALLTRIM(TRB->RB_COD) $ c_Cods)
           dbSkip()
           loop
       EndIf

	   cCod   := TRB->RB_COD  
       nRecNo := TRB->(RecNo())
       nQFim  := 0 
       nQVend := 0
       nQProd := 0
       for nX := 1 to Len(aMov) 
			
			DbSelectArea("SB1")
        	DbSeek(xFilial()+cCOD)
        
           xTipo  := B1_TIPO
           xLocal := B1_LOCPAD //If(AllTrim(xTipo)=="PA","20","01")
           lCab   := .F.
           nCol   := 36
           if nX = 1 
              @ nLin, 000 PSAY cCod + "  Tipo: "+xTipo
   		   elseif nX = 2
        	  @ nLin, 000 PSAY SubStr(B1_DESC,1,30)
           elseif nX = 3                         
              nQIni := CalcEst(cCod,xLocal,dDatIni)[1]
              @ nLin, 000 PSAY "SALDO INICIAL:  " + Transform(nQini,"@E 999,999")
           endif
           @ nLin, 32 PSAY aMov[nX] 
           DbSelectArea("TRB")
           DbGotop()
           if DbSeek(xFilial()+cCod+ aMov[nX])
              for nY := 1 to Len(aDias)
                  nQuant := &( "RB_DIA"+StrZero(aDias[nY],2))
                  @ nLin,nCol PSAY if(nQuant > 0 ,Transform (nQuant,"@E 9,999"),"   ") 
                  nCol := nCol + 6
              next  
              if nX = 2 
                 nQProd := RB_TOTAL
              elseif nX = 3 
                 nQVend := RB_TOTAL
              endif   
              @ nLin,nCol PSAY if(RB_TOTAL>0,Transform(RB_TOTAL,"@E 999,999"), "    ")
              Reclock("TRB",.F.)
               RB_SALINI := CalcEst(cCod,xLocal,dDatIni)[1]
              MsUnlock()
           else
              nCol := nCol + ( 6 * Len(aDias) )
           endif
           if nX = 3          
              nCol := nCol + 8
              nQFim := (nQIni + nQProd) - nQVend
              @ nLin,nCol PSAY Transform(nQFim,"@E 999,999")
           endif  
           nLin++ 
	       If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	    	  lCab := .T.
     	 	  Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      nLin := 8
	  	   Endif  
       next            
       if !lCab
	      @ nLin,0 PSAY Replicate("-",Limite)
	      nLin++
	   endif    
       DbGoto(nRecNo)
       While !EOF() .and. cCod = TRB->RB_COD 
             Incregua()
             DbSkip()
       end    
  EndDo
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Finaliza a execucao do relatorio...                                 ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  SET DEVICE TO SCREEN
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Se impressao em disco, chama o gerenciador de impressao...          ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If aReturn[5]==1
  	 dbCommitAll()
     SET PRINTER TO
  	 OurSpool(wnrel)
  Endif
  MS_FLUSH()
Return
//////////////////////////////////////
User Function VPCPR13()
   private lRet := .F.
   if (Substr(mv_par01,1,2) $ "01'02'03'04'05'06'07'08'09'10'11'12") 
      lRet := .T.
   endif
Return(lRet)
/////////////////////////////
Static Function ValidPerg(cPerg)
   _sAlias := Alias()
   DbSelectArea("SX1")
   DbSetOrder(1)
   aRegs :={} //Grupo|Ordem| Pegunt               | perspa | pereng | VariaVL  | tipo| Tamanho|Decimal| Presel| GSC | Valid         |   var01   | Def01 | DefSPA1 | DefEng1 | CNT01 | var02 | Def02 | DefSPA2 | DefEng2 | CNT02 | var03 | Def03 | DefSPA3 | DefEng3 | CNT03 | var04 | Def04 | DefSPA4 | DefEng4 | CNT04 | var05 | Def05 | DefSPA5 | DefEng5 | CNT05 | F3    | GRPSX5 |
   aAdd(aRegs,{ cPerg,"01" , "Data Ref.(MMAAAA) ?",   ""   ,  ""    , "mv_ch1" , "C" ,   06   ,   0   ,   0   , "G" , "u_VPCPR13()" , "mv_par01", "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
   aAdd(aRegs,{ cPerg,"02" , "Do Produto        ?",   ""   ,  ""    , "mv_ch2" , "C" ,   15   ,   0   ,   0   , "G" , "          "  , "mv_par02", "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "SB1" , "    " })
   aAdd(aRegs,{ cPerg,"03" , "Ate Produto       ?",   ""   ,  ""    , "mv_ch3" , "C" ,   15   ,   0   ,   0   , "G" , "naoVazio()"  , "mv_par03", "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "SB1" , "    " })
   aAdd(aRegs,{ cPerg,"04" , "Do Recurso        ?",   ""   ,  ""    , "mv_ch4" , "C" ,   06   ,   0   ,   0   , "G" , "          "  , "mv_par04", "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "SH1" , "    " })
   aAdd(aRegs,{ cPerg,"05" , "Ate Recurso       ?",   ""   ,  ""    , "mv_ch5" , "C" ,   06   ,   0   ,   0   , "G" , "naoVazio()"  , "mv_par05", "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "SH1" , "    " })
   For i:=1 to Len(aRegs)
  	   If !DbSeek(PadR(cPerg,10)+aRegs[i,2])
	  	  RecLock("SX1",.T.)
		   For j:=1 to FCount()
		  	  If j <= Len(aRegs[i])
				 FieldPut(j,aRegs[i,j])      
			  Endif
		   Next
		  MsUnlock()
	   Endif
   Next
   dbSelectArea(_sAlias)
Return
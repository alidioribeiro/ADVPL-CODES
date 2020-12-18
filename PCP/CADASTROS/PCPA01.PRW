#include "rwmake.ch"
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)
STATIC __l250FLD

User Function PCPA01(aRotAuto)          
	Local lPyme    := Iif(Type("__lPyme") <> "U",__lPyme,.F.), uX, nI
    Local oDlg     := nil                                  
    LOCAL aAC      := { OemToAnsi("Abandona"),OemToAnsi("Confirma")}   
    Private cAlias := "SD3" 
	Private aNeed  := {}
    Private bCampo := {|nField| FieldName(nField) }        
    private nOpcao := 0 
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica a permissao do programa em relacao aos modulos      Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If AMIIn(4,10,25,97,98)
	   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	   //Ё Variaveis utilizadas no sistema.                             Ё
	   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	   PRIVATE lProdAut := GetMv("MV_PRODAUT")
   	   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	   //Ё Variaveis utilizadas no Apontamento de Refugo por Motivo     Ё
	   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	   PRIVATE lSavePerda:=.F.
	   PRIVATE aPerda  := {},aHdPerda := {}
	   PRIVATE nPosQuant,nPosMot,nPosDesc,nPosTipo,nPosCod,nPosLoc,nPosLote
	   PRIVATE lEnvCQProd := .F.
	   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	   //Ё Pega a variavel que identifica se o calculo do custo e' :    Ё
	   //Ё               O = On-Line                                    Ё
	   //Ё               M = Mensal                                     Ё
	   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	   PRIVATE cCusMed := GetMv("mv_CusMed")

	   Private l250Auto := ( aRotAuto <> NIL ), l240Auto := .f.

   	   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	   //Ё Verifica se o custo medio e' calculado On-Line               Ё
	   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	   If cCusMed == "O"
	      PRIVATE nHdlPrv // Endereco do arquivo de contra prova dos lanctos cont.
    	  PRIVATE lCriaHeader := .T. // Para criar o header do arquivo Contra Prova
	      PRIVATE cLoteEst  // Numero do lote para lancamentos do estoque
	      //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	      //Ё Posiciona numero do Lote para Lancamentos do Faturamento     Ё
	      //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
    	  dbSelectArea("SX5")
	      dbSeek(xFilial()+"09EST")
    	  cLoteEst:=IIF(Found(),Trim(X5Descri()),"EST ")
	      PRIVATE nTotal := 0  // Total dos lancamentos contabeis
    	  PRIVATE cArquivo  // Nome do arquivo contra prova
	   EndIf
	   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	   //Ё Esta variavel indica se utiliza segunda unidade de medida    Ё
	   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	   PRIVATE lUsaSegUm
	   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	   //Ё Estas variaveis indicam para as funcoes de validacao qual    Ё
	   //Ё programa as esta' chamando                                   Ё
	   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	   PRIVATE l240:=.F.,l250 :=.T.,l241:=.F.,l242:=.F.,l261:=.F.,l185:=.F.,l650:=.F.,l680:=.F.,l681:=.F.
	   PRIVATE dDataFec:=GETMV("MV_ULMES")
	   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	   //Ё Define Array contendo as Rotinas a executar do programa      Ё
	   //Ё ----------- Elementos contidos por dimensao ------------     Ё
	   //Ё 1. Nome a aparecer no cabecalho                              Ё
	   //Ё 2. Nome da Rotina associada                                  Ё
	   //Ё 3. Usado pela rotina                                         Ё
	   //Ё 4. Tipo de Transa┤└o a ser efetuada                          Ё
	   //Ё    1 - Pesquisa e Posiciona em um Banco de Dados             Ё
	   //Ё    2 - Simplesmente Mostra os Campos                         Ё
	   //Ё    3 - Inclui registros no Bancos de Dados                   Ё
	   //Ё    4 - Altera o registro corrente                            Ё
	   //Ё    5 - Estorna registro selecionado gerando devolucoes       Ё
	   //Ё        automaticas                                           Ё
	   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	   PRIVATE aRotina := { {"Pesquisar"  ,"AxPesqui"   , 0 , 1},;   
    	                    {"Visualizar" ,"A250Visual" , 0 , 2},;      
    	                    {"Incluir"    ,"U_A250Inclui" , 0 , 3}}   
					        //{"Incluir"    ,"UA250Inclui" , 0 , 3},;   
						    //{"Estornar"   ,"A250Estorn" , 0 , 5},;   
						    //{"enceRrar"   ,"A250Encer"  , 0 , 5} }   
	   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	   //Ё Verifica se trabalha com segunda unidade de medida           Ё
	   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	   lUsaSegUm := .T.
	   dbSelectArea("SX3")
	   dbSetOrder(2)
	   dbSeek("B1_SEGUM")
	   If !X3USO(X3_USADO)
    	  dbSeek("B2_QTSEGUM")
	      If !X3USO(X3_USADO)
    	     lUsaSegUm := .F.
	      EndIf
	   EndIf
	   dbSetOrder(1)
	   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	   //Ё Array contendo os campos aceitos no MATXATU                  Ё
	   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	   PRIVATE aAcho:={}
	   private aTitulo:= {"","","","","","","","","","",""}  
       private aF3    := {"","","","","","","","","","",""}  	   
       private aValid := {"","","","","","","","","","",""} 
       AADD(aAcho,"D3_OP")
	   AADD(aAcho,"D3_EMISSAO")
	   AADD(aAcho,"D3_RECURSO")	   
	   AADD(aAcho,"D3_TURNO")
	   AADD(aAcho,"D3_PERDA")
	   AADD(aAcho,"D3_MOTPER")
	   AADD(aAcho,"D3_MOTHP")
	   AADD(aAcho,"D3_MOTRET")
	   AADD(aAcho,"D3_COD")
	   For nX:=1 to Len(aAcho)
	       DbSelectArea("SX3")
	       DbSetOrder(2)
	       if DbSeek(aAcho[nX])
          	  aTitulo[nX]:= TRIM(x3_titulo)
        	  aF3[nX]:= TRIM(x3_f3)                         
        	  aValid[nX] := (x3_valid)
           endif	  
	   Next 
	   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	   //Ё Define o cabecalho da tela de atualizacoes                   Ё
	   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	   PRIVATE cCadastro :=OemToAnsi("Perdas de Produ┤■es")  
	   If l250Auto
	      PRIVATE aColsGrade:= {}
	      PRIVATE aHeadGrade:= {}
	      PRIVATE aHeader     := {}
	      PRIVATE acols     := {}
	      PRIVATE lGrade    := GetMv("MV_GRADE")
	      PRIVATE aColsPT   := {}
	      PRIVATE aQtdPerda := {}
	      PRIVATE cLocCQOrig:= ""
    	  If MsRotAuto(3,aRotAuto,"SD3")
	         Return
    	  EndIf
	   EndIf
      Pergunte("MTA250",.F.)	   
	  DbSelectArea("SD3")
	  DbSetOrder(1)
	  For nX := 1 To FCount()
	 	  M->&(Eval(bCampo,nX)) := CriaVar(FieldName(nX),.T.)
	  Next nX
	   lmonta:= .t.  
	   nOpc:=3
	   nReg := SD3->(Recno())                                                         
	  While .T.                                   
	     M->D3_TM := "400"
	     M->D3_CF := "PR0" 
	     aTam := TAMSX3("D3_COD")
		 M->D3_COD     := Space(aTam[1])
	     aTam := TAMSX3("D3_OP")
		 M->D3_OP      := Space(aTam[1])
	     aTam := TAMSX3("D3_DOC")
	     M->D3_DOC     := Space(aTam[1])
	     aTam := TAMSX3("D3_RECURSO")
	     M->D3_RECURSO := Space(aTam[1])
	     aTam := TAMSX3("D3_TURNO")
	     M->D3_TURNO   := Space(aTam[1]) 
	     M->D3_EMISSAO := dDataBase
	     M->D3_PERDA   := 0    
	     M->D3_MOTPER  := "N"
	     M->D3_MOTHP   := "N"
	     M->D3_MOTRET  := "N"
	     M->d3_partot  := "" 

	     DEFINE MSDIALOG oDlg TITLE cCadastro FROM 000,000 TO 400,500 OF oMainWnd PIXEL      
	
		 @ 017,005 SAY aTitulo[1]                        
		 if !Empty(aF3[1])
   	        @ 016,040 GET M->D3_OP SIZE 50,10 f3 (aF3[1]) PICTURE x3Picture("D3_OP") valid(VOP())
   	     else
   	        @ 016,040 GET M->D3_OP SIZE 50,10 PICTURE x3Picture("D3_OP") valid(VOP())   
   	     endif  
        
         @ 017,120 SAY aTitulo[2]
   		 if !Empty(aF3[2])
     		 @ 016,155 GET M->D3_EMISSAO SIZE 50,10 f3 (aF3[2]) PICTURE x3Picture("D3_EMISSAO") //Valid (&(aValid[3])) 
     	 else
        	 @ 016,155 GET M->D3_EMISSAO SIZE 50,10 PICTURE x3Picture("D3_EMISSAO") //Valid (&(aValid[3])) 
     	 endif	 
   
         @ 032,005 SAY aTitulo[3]
   		 if !Empty(aF3[3])
    		 @ 031,040 GET M->D3_RECURSO SIZE 50,10 f3 (aF3[3]) PICTURE x3Picture("D3_RECURSO")
   		 else
            @ 031,040 GET M->D3_RECURSO SIZE 50,10 PICTURE x3Picture("D3_RECURSO")    
	     endif                   

         @ 032,120 SAY aTitulo[4]
  	     if !Empty(aF3[4])
             @ 031,155 GET M->D3_TURNO SIZE 50,10  f3 (aF3[4]) PICTURE x3Picture("D3_TURNO")
         else
             @ 031,155 GET M->D3_TURNO SIZE 50,10 PICTURE x3Picture("D3_TURNO")    
         endif    
    
         @ 047,005 SAY aTitulo[5]
         if !Empty(aF3[5])
	        @ 046,040 GET M->D3_PERDA  SIZE 50,10 f3 (aF3[5]) PICTURE x3Picture("D3_PERDA") //Valid(VQtdPerda())    
	     else   
            @ 046,040 GET M->D3_PERDA  SIZE 50,10 PICTURE x3Picture("D3_PERDA")    //Valid(VQtdPerda())
         endif                                                  
         
	     @ 047,120 SAY aTitulo[6]
         @ 046,155 GET M->D3_MOTPER SIZE 10,10 PICTURE x3Picture("D3_MOTPER") Valid(VMotPer(.T.))
	
   	      @ 062,005 SAY aTitulo[7]
    	  @ 061,040 GET M->D3_MOTHP SIZE 10,10 PICTURE x3Picture("D3_MOTHP") Valid(VMotHP(.T.))
  
	      @ 062,120 SAY aTitulo[8]
    	  @ 061,155 GET M->D3_MOTRET  SIZE 10,10 PICTURE x3Picture("D3_MOTRET") Valid(VMotRet(.T.))

	      @ 077,005 SAY aTitulo[9]
	      @ 076,040 GET M->D3_COD  SIZE 55,10 PICTURE x3picture("D3_COD") when .F.

         ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||Confirmar(oDlg,nReg),nOpcao:=1},{||nOpcao := 0,Close(oDlg)}) 
         
	     Ferase("SZ6TMP.DBF")
	     Ferase("SZ7TMP.DBF")
	     Ferase("SZ8TMP.DBF")
	     
	     if(nOpcao ==0)
    	   exit 
	     endif  
	     
	  end
    endif
Return

*****************************************                                             
Static Function Confirmar(oDlg,nRecNo)
*****************************************
  if  VMotPer(.F.) .and. VMotHP(.F.) .and. VMotRet(.F.) //.and. VTudoOK()
     Close(oDlg) 
     //GravSZ()
  endif
Return              

*****************************************
Static Function GravSZ()
*****************************************
   If File("SZ6TMP.DBF") .and. (M->D3_motper = "S")
      Use SZ6TMP alias TRBSZ6           
      DbSelectArea("TRBSZ6")
	  DbGotop()
      While !TRBSZ6->(EOF())
        DbSelectArea("SZ6")
	    DbSetOrder(1)
       	RecLock("SZ6",.T.) 
         SZ6->Z6_Filial  := TRBSZ6->Z6_FILIAL
    	 SZ6->Z6_Emissao := TRBSZ6->Z6_Emissao
   	     SZ6->Z6_Doc     := TRBSZ6->Z6_Doc
    	 SZ6->Z6_Cod     := TRBSZ6->Z6_Cod
   	     SZ6->Z6_OP      := TRBSZ6->Z6_OP
         SZ6->Z6_Recurso := TRBSZ6->Z6_Recurso
	     SZ6->Z6_Turno   := TRBSZ6->Z6_Turno
   		 SZ6->Z6_CodMot  := TRBSZ6->Z6_CodMot
       	 SZ6->Z6_Motivo  := TRBSZ6->Z6_Motivo
	     SZ6->Z6_Quant   := TRBSZ6->Z6_Quant
    	MsUnLock()
        TRBSZ6->(DbSkip())
	  End
      DbSelectArea("TRBSZ6")
      DbCloseArea()       
   endif
   Ferase("SZ6TMP.DBF")
   //Motivo de Horas Paradas
   If File("SZ7TMP.DBF")  .and. (M->D3_mothp = "S")
	  Use SZ7TMP alias TRBSZ7           
      DbSelectArea("TRBSZ7")
	  DbGotop()
      While !TRBSZ7->(EOF())
         DbSelectArea("SZ7")
         DbSetOrder(1)
         RecLock("SZ7",.T.)
	      SZ7->Z7_Filial  := TRBSZ7->Z7_Filial
	      SZ7->Z7_Emissao := TRBSZ7->Z7_EMISSAO
          SZ7->Z7_Doc     := TRBSZ7->Z7_Doc
	      SZ7->Z7_Cod     := TRBSZ7->Z7_Cod
          SZ7->Z7_OP      := TRBSZ7->Z7_OP
          SZ7->Z7_Recurso := TRBSZ7->Z7_Recurso
	      SZ7->Z7_Turno   := TRBSZ7->Z7_Turno
    	  SZ7->Z7_CodMot  := TRBSZ7->Z7_CodMot
          SZ7->Z7_Motivo  := TRBSZ7->Z7_Motivo
	      SZ7->Z7_HIni    := TRBSZ7->Z7_HIni
    	  SZ7->Z7_HFin    := TRBSZ7->Z7_HFin
          SZ7->Z7_TDec    := TRBSZ7->Z7_TDec 
    	 MsUnLock()
         TRBSZ7->(DbSkip())
      End
      DbSelectArea("TRBSZ7")
   	  DbCloseArea()
   endif                  
   Ferase("SZ7TMP.DBF")    
   //Motivo de Retrabalhos
   If File("SZ8TMP.DBF") .and. (M->d3_motret = "S")
	  Use SZ8TMP alias TRBSZ8           
      DbSelectArea("TRBSZ8")
	  DbGotop()
      While !TRBSZ8->(EOF())
        DbSelectArea("SZ8")
        DbSetOrder(1)
        RecLock("SZ8",.T.)
	     SZ8->Z8_Filial  := TRBSZ8->Z8_Filial
	     SZ8->Z8_Emissao := TRBSZ8->Z8_EMISSAO
    	 SZ8->Z8_Doc     := TRBSZ8->Z8_Doc
	     SZ8->Z8_Cod     := TRBSZ8->Z8_Cod
    	 SZ8->Z8_OP      := TRBSZ8->Z8_OP
         SZ8->Z8_Recurso := TRBSZ8->Z8_Recurso
	     SZ8->Z8_Turno   := TRBSZ8->Z8_Turno
    	 SZ8->Z8_CodMot  := TRBSZ8->Z8_CodMot
         SZ8->Z8_Motivo  := TRBSZ8->Z8_Motivo
         SZ8->Z8_Quant   := TRBSZ8->Z8_Quant
    	MsUnLock()
        TRBSZ8->(DbSkip())
	  End
      DbSelectArea("TRBSZ8")
   	  DbCloseArea()
   endif
   Ferase("SZ8TMP.DBF")  
Return

********************************
Static Function VOP()
********************************
	local nEndereco,nEnd1,nEnd2,nTam,nDec
	LOCAL aAreaSD3:= GetArea(),aAreaSD2:="", cAliasOld
	LOCAL nTamOp
	LOCAL cNumOp
	LOCAL lReferencia  := .F.
	LOCAL lBaixa       := .F.
	LOCAL lRet         := .T.

	cNumOP := M->D3_OP
	If l250
	   lRet := a250VldOP()
	   If !lRet
    	  Return .F.
	   EndIf
	   nTamOp   := Len(Alltrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD))
	   cNumOp   := If( Len(Alltrim(M->D3_OP))==nTamOp.Or.(!Empty(M->D3_COD) .And. !MatGrdPrrf(M->D3_COD)),M->D3_OP,Alltrim(M->D3_OP))
	   lReferencia := MatGrdPrrf(M->D3_COD)
	EndIf

	dbSelectArea("SC2")
	dbSetOrder(1)
	dbSeek(xFilial()+cNumOp)
	If EOF()
	   If !l185
    	  M->D3_COD := "  "
	   EndIf
	   Return .F.
	ElseIf SC2->C2_TPOP == "P"
	   If !l185
	      M->D3_COD := "  "
	   EndIf
	   Help(" ",1,"NOPPREVIST")
	   Return .F.
	Endif
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica se o produto digitado e' uma referencia de Grade     Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If !lReferencia
	   If !Empty(SC2->C2_DATRF) .And. !l240 .and. !l241 .And. !l185
    	  M->D3_COD := "  "
	      Help(" ",1,"A250ENCERR")
    	  Return .F.
	   EndIf
	Else
	   //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	   //Ё Varre os itens da grade, para verificar se todos os itens ja foram ou nao produzidosЁ
	   //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	   Do While !EOF() .And. C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+If(Len(Alltrim(M->D3_OP))==nTamOp,C2_ITEMGRD,"")  == xFilial()+Alltrim(M->D3_OP)
	      If !Empty(SC2->C2_DATRF)
    	     dbSkip()
    	     loop
	      Else
	         lBaixa := .T.
    	     Exit
	      EndIf
	   EndDo
	   If !lBaixa
    	  If !l185
	         M->D3_COD := "  "
    	  EndIf
	      Help(" ",1,"A250ENCERR")
    	  Return .F.
	   EndIf
	EndIf

	If l240 .OR. l241
	   If !EMPTY(C2_DATRF)
    	  Help(" ",1,"MA240OPENC")
	      Return .F.
	   Else
    	  If l240
        	 If Empty(M->D3_LOCAL)
	            M->D3_LOCAL := C2_LOCAL
    	     EndIf
	      ElseIf l241
	         If Empty(aCols[n,nPosLocal])
    	        aCols[n,nPosLocal]:=C2_LOCAL
	         EndIf
    	  EndIf
	      Return .T.
	   EndIf
	EndIf

	M->D3_UM := C2_UM
	If Len(Alltrim(M->D3_OP)) == nTamOp
	   M->D3_COD := C2_PRODUTO
	EndIf

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Imprime a descricao do produto para conferencia                Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cOldArea:=Alias()
	nOldOrdem:=IndexOrd()
	nOldNum:=Recno()

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Se for produto referencia, nao deve preencher os campos abaixo Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	dbSelectArea("SB1")
	dbSeek(xFilial()+M->D3_COD)
	If Len(Alltrim(M->D3_OP)) == nTamOp
	   M->D3_DESCRI := B1_DESC
	   If Rastro(M->D3_COD)
    	  M->D3_DTVALID  := dDataBase + B1_PRVALID
	   EndIf
	Else
	   M->D3_DESCRI := " "
	EndIf

	dbSelectArea(cOldArea)
	dbSetOrder(nOldOrdem)
	dbGoto(nOldNum)

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Caso utilize coletor de dados nao preenche valor               Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If Type("l250Auto") == "U" .Or. (Type("l250Auto") == "L" .And. !l250Auto) .And. Len(Alltrim(M->D3_OP)) == nTamOp
	   M->D3_QUANT := C2_QUANT - C2_QUJE - C2_PERDA
  	   xQuant := M->D3_QUANT
	EndIf
	If M->D3_QUANT < 0
   	   M->D3_QUANT := 0
	   xQuant := 0
	EndIf
	M->D3_CC := C2_CC

	dbSelectArea("SB1")
	dbSeek(xFilial()+M->D3_COD)
	M->D3_LOCAL := SC2->C2_LOCAL
	M->D3_CONTA := B1_CONTA
	M->D3_GRUPO := B1_GRUPO
	M->D3_TIPO  := B1_TIPO
    M->D3_SEGUM := B1_SEGUM
	//здддддддддддддддддддддддддддддддддд©
	//ЁCaso for rotina automatica        Ё
	//юдддддддддддддддддддддддддддддддддды
    RestArea(aAreaSD3)
Return .T.

*****************************************
Static Function VMotPer(lAtiva)
*****************************************
   Private lRet := .T.
   if(Alltrim(M->D3_MOTPER) =="S") .and. lAtiva                    
     U_MotPer() 
   endif
   if(!(Alltrim(M->D3_MOTPER) $ "S'N"))
     lRet := .F.
     MsgStop("Informacao deve ser (S ou N)")
   endif
Return(lRet)        

*****************************************
Static Function VMotHP(lAtiva)
*****************************************
   private lRet := .T.
   if(Alltrim(M->D3_MOTHP) =="S") .and. lAtiva
      u_MOTHP()
   endif    
   if(!(Alltrim(M->D3_MOTHP) $ "S'N"))            
     MsgStop("Informacao deve ser (S ou N)")
     lRet := .F.
   endif
Return(lRet)                                    

*****************************************
Static Function VMotRet(lAtiva) 
*****************************************
   private lRet := .T.
   if(Alltrim(M->D3_MOTRET) =="S").and. lAtiva
      u_MOTRET()
   endif    
   if(!(Alltrim(M->D3_MOTRET) $ "S'N"))
     MsgStop("Informacao deve ser (S ou N)")
     lRet := .F.
   endif
Return(lRet)                                    

*****************************************
Static function VTudoOK()
*****************************************
  private lRet := .T.
  private nTotPerda := 0
  if(M->d3_perda > 0 .and. M->d3_motper ="N") 
    lRet := .F.
    alert("Perda maior que zero(0), deve informar: Sim para o Mot.Perda")
  elseif File("SZ6TMP.DBF") .and. lRet
     Use SZ6TMP alias TRX
     DbSelectArea("TRX")
     DbGotop()
     While !TRX->(EOF())
        nTotPerda += TRX->Z6_QUANT
        DbSkip()
     End  
     DbSelectArea("TRX")
     DbCloseArea()
  endif
  if(nTotPerda # M->D3_PERDA) .and. (M->D3_PERDA > 0) .and. lRet     
     lRet := .F.
     alert("A Perda informada "+Alltrim(str(M->D3_PERDA))+" e diferente da perda justificada!")
  endif
return(lRet)
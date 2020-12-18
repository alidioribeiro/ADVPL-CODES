//#include "rwmake.ch"
#include "Protheus.ch"
User Function PCPA02()       
    Local aSay      := {}
	Local aButton   := {}
	Local nOpc      := 0
	Local cTitulo   := "Apontamento de OPs"
	Local cDesc1    := "Este programa processa o SH6 - Movimentacao da Producao e gera o apontamento"
	Local cDesc2    := "das OPs."           
	private cPerg   := "PCPA02" 
	private cAlias  := "SH6"
        private cArqSH6 := ""
	private cChave  := "H6_FILIAL+H6_OP+DTOS(H6_DTAPONT)+H6_PRODUTO+H6_KAMBAN" 
	private cFiltro := "xFilial('SH6')==H6_FILIAL .and. DTOS(H6_DTAPONT)>=DTOS(mv_par01)"+;
	                   ".and. DTOS(H6_DTAPONT)<=DTOS(mv_par02) .and. H6_EFETIVA!='S'"
    private cTexto  := "Selecionando Registros..."  
    private nIndice := 0
    private lReg    := .F.
	ValidPerg(cPerg)
	Pergunte(cPerg,.F.)
	aAdd( aSay, cDesc1 )
	aAdd( aSay, cDesc2 )
	aAdd( aButton, { 1, .T., {|x| nOpc := 1, FechaBatch() }} )
	aAdd( aButton, { 2, .T., {|x| nOpc := 2, FechaBatch() }} )
	aAdd( aButton, { 5, .T., {||  Pergunte(cPerg,.T. )    }} )
	FormBatch( cTitulo, aSay, aButton )
	If nOpc <> 1
	   Return Nil
	Endif        

    //+-----------------------------------
	//| Cria um nome de arquivo temporario
	//+-----------------------------------
	cArqSH6  := CriaTrab(Nil,.F.)
	//+--------------------------------
	//| Cria indice e filtro temporario
	//+--------------------------------
	DbSelectArea(cAlias)
	IndRegua(cAlias,cArqSH6,cChave,,cFiltro,cTexto)
	nIndice := RetIndex()
	nIndice := nIndice + 1
	dbSelectArea(cAlias)
	#IFNDEF TOP
	   dbSetIndex(cArqSH6+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndice)
	dbGoTop()
   	Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...","Processando Movimentacoes de Producao", .F. )
   	if !lReg 
   	   MsgInfo("Nao ha registro para este periodo")
   	endif
    DbSelectArea("SH6")
    fErase(cArqSH6)
    dbSelectArea('SH6')
    RetIndex('SH6')
Return Nil
/////////////////////////////////////
//
////////////////////////////////////
Static Function RunProc(lEnd) 
    private aTam       := TAMSX3("D3_COD")
    private cDocto     := Space(aTam[1])
    private cNumSeq    := ""
	private cIdent     := ""
	private aEstrut    := {}
	private aGrava     := {} 
	private aReg       := {}
	private cOcorr     := {"","",""}
	private cText      := "" 
    DbSelectArea(cAlias)
  	dbSetOrder(nIndice)
   	dbGoTop()  
   	ProcRegua(RecCount())
    While !(cAlias)->(Eof()) 
        lReg := .T.
	    IncProc("Processando a OP: "+Alltrim(SH6->H6_OP)+", Kamban: "+Alltrim(SH6->H6_KAMBAN))            
        DbSelectArea("SC2")
        DbSetOrder(1)
        DbSeek(xFilial("SC2")+Substr(SH6->H6_OP,1,8))
        dbSelectArea("SB1")
        dbSetOrder(1)
        dbSeek(xFilial("SB1")+SC2->C2_Produto)
        qTPoney:= SB1->B1_QTPONEY
        nQOP := SH6->H6_QTDPROD+SH6->H6_QTDPERD
        if( nQOP <= qTPoney) .and. (SH6->H6_DATAINI < SH6->H6_DTAPONT)
		    nEstru   := 0                              
    	    aEstrut  := Estrut(SH6->H6_PRODUTO,(SH6->H6_QTDPROD+SH6->H6_QTDPERD))
	        aGrava   := {} // Componente,Quantidade
    	    For nX := 1 to Len(aEstrut)
        	    if  SH6->H6_PRODUTO == aEstrut[nX,2]
            	    aAdd(aGrava,{aEstrut[nX,3],aEstrut[nX,4]})
	            endif
    	    Next                       
        	DbSelectarea(cAlias)
	        RecLock("SH6",.F.)
		      H6_EFETIVA := 'S'
	    	MsUnlock() 
		    GravSC2() //Atualiza a Ordem de Producao 
    	    GravSD3() //Gera Movimentacao do produto
        	GravSD4() //Baixa os Empenhos e Atualiza o Estoque
	        GravSB2() //Atualiza Estoque          
    	else               
     	    Do Case                          
     	       Case (qTPoney = 0)
     	            cOcorr[1] += "OP: "+Alltrim(SH6->H6_OP)+", Kamban: "+Alltrim(SH6->H6_KAMBAN)+CHR(13)
               Case (nQOP > qTPoney) 
                    cOcorr[2]  += "OP: "+Alltrim(SH6->H6_OP)+", Kamban: "+Alltrim(SH6->H6_KAMBAN)+CHR(13)
               Case (SH6->H6_DATAINI > SH6->H6_DTAPONT)
                    cOcorr[3] += "OP: "+Alltrim(SH6->H6_OP)+", Kamban: "+Alltrim(SH6->H6_KAMBAN)+CHR(13)
            EndCase        
    	endif
    	DbSelectarea(cAlias)
       	(cAlias)->(DbSkip())
	End 
	if !Empty(cOcorr[1])
	   cText += "Capac. Poney nao cadastrada" + CHR(13) +cOcorr[1] + CHR(13)
	endif   
    if !Empty(cOcorr[2])
	   cText += "Capac. Poney nao Suporta Producao" + CHR(13) +cOcorr[2] + CHR(13)
	endif   
    if !Empty(cOcorr[3])
	   cText += "Verifique a Data Inicial X Data Apontamento"+ CHR(13) + cOcorr[3] + CHR(13)  
	endif          
	if !Empty(cText)            
	    oDlg  := Nil
    	oMemo := Nil
    	oSay  := Nil
    	oFont := TFont():New("Times New Roman",,14,.F.)
	   	DEFINE MSDIALOG oDlg FROM 0,0 TO 400,400 PIXEL TITLE "Aviso"
			oSay:= tSay():New(10,10,{||"VERIFICAR A OBSERVACAO(H6_OBSERVA)"},oDlg,,oFont,,,,.T.,,,150,180)
			oMemo:= tMultiget():New(20,10,{|u|if(Pcount()>0,cText:=u,cText)},oDlg,180,150,,.T.,,,,.T.,,,,,,.F.,,,,.F.,.T.)
			@ 180,140 BUTTON oBtn PROMPT "Fechar" OF oDlg PIXEL ACTION oDlg:End()
			ACTIVATE MSDIALOG oDlg CENTERED
  endif
Return .T.       
//////////////////////////////
Static Function GravSD3()
     private nTam   := 0 
	 dbSelectArea("SD3")
	 nTam := Len(alltrim(D3_OP)) 
     aAreaSD3:=GetArea()
     dbSetOrder(2)
     If dbSeek(xFilial()+Padr(SH6->H6_OP,Len(cDocto)))
        cDocto := NextNumero("SD3",2,"D3_DOC",.T.)
     Else
        cDocto := Padr(SH6->H6_OP,Len(cDocto))
     EndIf                                    
     RestArea(aAreaSD3)
     DbSelectArea("SC2")
     DbSetOrder(6)
     DbSeek(xFilial("SC2")+Substr(SH6->H6_OP,1,nTam)+SH6->H6_PRODUTO)     
     DbSelectArea("SB1")
     DbSetOrder(1)
     DbSeek(xFilial("SB1")+SH6->H6_PRODUTO)
     DbSelectArea("SB2")
     DbSetOrder(1)
     DbSeek(xFilial("SB2")+SH6->H6_PRODUTO+iif(SB1->B1_TIPO = "PA","01","10"))
     DbSelectArea("SD3")
     DbSetOrder(12)
     if !DbSeek(xFilial("SD3")+SH6->H6_OP+DTOS(SH6->H6_DTAPONT)+SH6->H6_PRODUTO+"400") 
        //Caso nao esteja no Arquivo de Movimentacao - SD3
        RecLock("SD3",.T.)
        SD3->D3_FILIAL   := xFilial("SD3")
        SD3->D3_OP       := SH6->H6_OP
        SD3->D3_COD      := SH6->H6_PRODUTO
        SD3->D3_TM       := "400"
        SD3->D3_EMISSAO  := SH6->H6_DTAPONT
        SD3->D3_QUANT    := SH6->H6_QTDPROD
        SD3->D3_PERDA    := SH6->H6_QTDPERD
        SD3->D3_DOC      := cDocto 
        SD3->D3_CC       := SB1->B1_CC
        SD3->D3_UM       := SB1->B1_UM
        SD3->D3_GRUPO    := SB1->B1_GRUPO
        SD3->D3_TIPO     := SB1->B1_TIPO
        SD3->D3_SEGUM    := SB1->B1_SEGUM
        SD3->D3_CONTA    := SB1->B1_CONTA
        SD3->D3_LOCAL    := iif(SD3->D3_TIPO = "PA","01","10")
        SD3->D3_CF       := "PR0"
        SD3->D3_CHAVE    := SubStr(SD3->D3_CF,2,1)+IIF(SD3->D3_CF=="DE4","9","0")
        SD3->D3_QTSEGUM  := ConvUm(SH6->H6_PRODUTO,SH6->H6_QTDPROD,0,2)
        SD3->D3_CUSTO1   := (SB2->B2_CM1 * SD3->D3_QUANT)
        SD3->D3_PARCTOT  := iif(QtdComp(SC2->C2_QUANT) > (QtdComp(SC2->C2_QUJE)+QtdComp(SC2->C2_PERDA)+QtdComp(SH6->H6_QTDPROD)),"P","T")
        //SD3->D3_NUMLOTE  := //IIF(Rastro(SC2->C2_PRODUTO),aCols[nComps,5],CriaVar("SD3->D3_NUMLOTE"))
        //SD3->D3_LOTECTL  := //IIF(Rastro(SC2->C2_PRODUTO),aCols[nComps,6],CriaVar("SD3->D3_LOTECTL"))
        //SD3->D3_DTVALID  := //IIF(Rastro(SC2->C2_PRODUTO),aCols[nComps,7],CriaVar("SD3->D3_DTVALID"))
        SD3->D3_ORIGEM  := "PCPA02"
        MsUnlock()     
        DbSelectArea("SD3")
        DbSetOrder(1)
      	DbSeek(xFilial(cAlias)+SH6->H6_OP)
        Do While !EOF() .And. SD3->D3_FILIAL+SD3->D3_OP == xFilial()+SH6->H6_OP
		   If SD3->D3_TM > "500" .Or. SD3->D3_DOC != cDocto .Or. Substr(D3_CF,1,2) == "DE"
		      dbSkip()
		      loop
		   EndIf
  		   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		   //� Pega o proximo numero sequencial de movimento      �
		   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		   cNumSeq := ProxNum()
		   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		   //� Variavel que faz amarracao entre OP Pai e OPS filhas .       �
		   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		   cIdent  := ProxNum()
		   RecLock('SD3',.F.)
			 D3_CF      := If(D3_CF#'PR1','PR0',D3_CF)
			 D3_CHAVE   := SubStr(D3_CF,2,1)+IF(D3_CF=='DE4','9','0')
			 D3_NUMSEQ  := cNumseq
			 D3_USUARIO := SubStr(cUsuario,7,15)
			 D3_IDENT   := cIdent
		   MsUnlock()
		   DbSelectArea("SD3")
		   DbSkip()
	    End                                  
     else
        //Caso ja esteja no Arquivo de Movimentacao - SD3
 		RecLock("SD3",.F.)
        SD3->D3_QUANT    := SD3->D3_QUANT   + SH6->H6_QTDPROD
        SD3->D3_PERDA    := SD3->D3_PERDA   + SH6->H6_QTDPERD
        SD3->D3_QTSEGUM  := SD3->D3_QTSEGUM + ConvUm(SH6->H6_PRODUTO,SH6->H6_QTDPROD,0,2)
        SD3->D3_CUSTO1   := (SB2->B2_CM1 * SD3->D3_QUANT)
        SD3->D3_PARCTOT  := iif(QtdComp(SC2->C2_QUANT) > (QtdComp(SC2->C2_QUJE)+QtdComp(SC2->C2_PERDA)+QtdComp(SH6->H6_QTDPROD)),"P","T")
        //SD3->D3_NUMLOTE  := //IIF(Rastro(SC2->C2_PRODUTO),aCols[nComps,5],CriaVar("SD3->D3_NUMLOTE"))
        //SD3->D3_LOTECTL  := //IIF(Rastro(SC2->C2_PRODUTO),aCols[nComps,6],CriaVar("SD3->D3_LOTECTL"))
        //SD3->D3_DTVALID  := //IIF(Rastro(SC2->C2_PRODUTO),aCols[nComps,7],CriaVar("SD3->D3_DTVALID"))
        MsUnlock()     
     endif   
     //////////////////////////////                             
     For nX := 1 to Len(aGrava)               
        if aGrava[nX,2] > 0
  	       DbSelectArea("SB1")
           DbSetOrder(1)
	       DbSeek(xFilial("SB1")+aGrava[nX,1])
      	   DbSelectArea("SB2")
           DbSetOrder(1)
           DbSeek(xFilial("SB2")+aGrava[nX,1]+"10")
	       DbSelectArea("SD3")
	  	   DbSetOrder(12)
      	   if DbSeek(xFilial("SD3")+SH6->H6_OP+DTOS(SH6->H6_DTAPONT)+aGrava[nX,1]+"999") 
              RecLock("SD3",.F.)
              SD3->D3_QUANT    := SD3->D3_QUANT   + aGrava[nX,2]
              SD3->D3_QTSEGUM  := SD3->D3_QTSEGUM + ConvUm(aGrava[nX,1],aGrava[nX,2],0,2)
              SD3->D3_CUSTO1   := (SB2->B2_CM1 * SD3->D3_QUANT)
              //SD3->D3_PARCTOT  := iif(QtdComp(SC2->C2_QUANT) > (QtdComp(SC2->C2_QUJE)+QtdComp(SH6->H6_QTDPROD)),"P","T")
              //SD3->D3_NUMLOTE  := //IIF(Rastro(SC2->C2_PRODUTO),aCols[nComps,5],CriaVar("SD3->D3_NUMLOTE"))
   	          //SD3->D3_LOTECTL  := //IIF(Rastro(SC2->C2_PRODUTO),aCols[nComps,6],CriaVar("SD3->D3_LOTECTL"))
        	  //SD3->D3_DTVALID  := //IIF(Rastro(SC2->C2_PRODUTO),aCols[nComps,7],CriaVar("SD3->D3_DTVALID"))
              MsUnlock()     
      	   else
              RecLock("SD3",.T.)
              SD3->D3_FILIAL   := xFilial("SD3")
              SD3->D3_OP       := SH6->H6_OP
              SD3->D3_COD      := aGrava[nX,1]
              SD3->D3_TM       := "999"
              SD3->D3_EMISSAO  := SH6->H6_DTAPONT
              SD3->D3_QUANT    := aGrava[nX,2]
              SD3->D3_DOC      := cDocto 
              SD3->D3_CC       := SB1->B1_CC
              SD3->D3_UM       := SB1->B1_UM
              SD3->D3_GRUPO    := SB1->B1_GRUPO
              SD3->D3_TIPO     := SB1->B1_TIPO
              SD3->D3_SEGUM    := SB1->B1_SEGUM
              SD3->D3_CONTA    := SB1->B1_CONTA
              SD3->D3_LOCAL    := "10"
              SD3->D3_CF       := iif(SD3->D3_TIPO = "PI","RE1","RE2")
              SD3->D3_CHAVE    := SubStr(SD3->D3_CF,2,1)+IIF(SD3->D3_CF=="DE4","9","0")
              SD3->D3_QTSEGUM  := ConvUm(aGrava[nX,1],aGrava[nX,2],0,2)
              SD3->D3_CUSTO1   := (SB2->B2_CM1 * SD3->D3_QUANT)
 			  SD3->D3_CHAVE    := SubStr(D3_CF,2,1)+IF(D3_CF=='DE4','9','0')
			  SD3->D3_NUMSEQ   := cNumseq
			  SD3->D3_USUARIO  := SubStr(cUsuario,7,15)
			  SD3->D3_IDENT    := cIdent
              //SD3->D3_PARCTOT  := iif(QtdComp(SC2->C2_QUANT) > (QtdComp(SC2->C2_QUJE)+QtdComp(SH6->H6_QTDPROD)),"P","T")
              //SD3->D3_NUMLOTE  := //IIF(Rastro(SC2->C2_PRODUTO),aCols[nComps,5],CriaVar("SD3->D3_NUMLOTE"))
   	          //SD3->D3_LOTECTL  := //IIF(Rastro(SC2->C2_PRODUTO),aCols[nComps,6],CriaVar("SD3->D3_LOTECTL"))
        	  //SD3->D3_DTVALID  := //IIF(Rastro(SC2->C2_PRODUTO),aCols[nComps,7],CriaVar("SD3->D3_DTVALID"))
  	          SD3->D3_ORIGEM  := "PCPA02"
              MsUnlock()     
           endif   
        endif
     Next
Return                                                 
////////////////////////////////
 Static Function GravSC2()
    private nTam  := Len(Alltrim(SH6->H6_OP))
    DBSelectArea("SC2")
    DbSetOrder(6)
    If DbSeek(xFilial("SC2")+Substr(SH6->H6_OP,1,nTam)+SH6->H6_PRODUTO)     //DbSeek(xFilial("SC2")+H6_OP)
        RecLock("SC2",.F.)
    	 C2_QUJE       := C2_QUJE  + SH6->H6_QTDPROD
    	 C2_PERDA      := C2_PERDA + SH6->H6_QTDPERD
     	 C2_DATPRF := iif(QtdComp(SC2->C2_QUANT) > QtdComp(SC2->C2_QUJE),CTOD("  /  /  "),dDataBase)
		MsUnlock()
    Endif
Return
///////////////////////////////
 Static Function GravSD4() 
        for nX := 1 to Len(aGrava)
            DbSelectArea("SD4")
          	DbSetOrder(2)
          	if DbSeek(xFilial("SD4")+SH6->H6_OP+aGrava[nX,1])
          	   RecLock("SD4",.F.)
    	        D4_QUANT   := D4_QUANT   - aGrava[nX,2]
    	     	D4_QTSEGUM := D4_QTSEGUM - ConvUm(aGrava[nX,1],aGrava[nX,2],0,2)  
        	   msUnlock() 
        	endif 	  
	    next
Return                             
////////////////////////////
//
///////////////////////////
Static Function GravSB2()
     aAdd(aGrava,{SH6->H6_PRODUTO,SH6->H6_QTDPROD})
     for nX := 1 to Len(aGrava)
         DbSelectArea("SB1")
         DbSetOrder(1)
         DbSeek(xFilial("SB1")+aGrava[nX,1])
         cLoc  := iif(SB1->B1_TIPO = "PA","01","10")
	     dbSelectArea("SB2")
    	 dbSetOrder(1)
	     dbSeek(xFilial("SB2")+aGrava[nX,1]+cLoc)
    	 If Eof()
        	CriaSB2(aGrava[nX,1],cLoc)
	     EndIf                          
    	 RecLock("SB2",.F.)           
           B2_QATU    := iif(SH6->H6_PRODUTO = aGrava[nX,1] , B2_QATU    + aGrava[nX,2] , B2_QATU - aGrava[nX,2] )
           B2_SALPEDI := iif(SH6->H6_PRODUTO = aGrava[nX,1] , B2_SALPEDI - aGrava[nX,2] , B2_SALPEDI             )
           B2_VATU1   := (B2_QATU * B2_CM1)
         MsUnlock()
     Next	 
Return
/////////////////////////////
Static Function ValidPerg(cPerg)
   _sAlias := Alias()
   DbSelectArea("SX1")
   DbSetOrder(1)
   aRegs :={} //Grupo|Ordem| Pegunt            | perspa | pereng | VariaVL  | tipo| Tamanho|Decimal| Presel| GSC | Valid        |   var01   | Def01 | DefSPA1 | DefEng1 | CNT01 | var02 | Def02 | DefSPA2 | DefEng2 | CNT02 | var03 | Def03 | DefSPA3 | DefEng3 | CNT03 | var04 | Def04 | DefSPA4 | DefEng4 | CNT04 | var05 | Def05 | DefSPA5 | DefEng5 | CNT05 | F3    | GRPSX5 |
   aAdd(aRegs,{ cPerg,"01" , "Data De        ?",   ""   ,  ""    , "mv_ch1" , "D" ,   08   ,   0   ,   0   , "G" , "naoVazio()" , "mv_par01", "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
   aAdd(aRegs,{ cPerg,"02" , "Data Ate       ?",   ""   ,  ""    , "mv_ch2" , "D" ,   08   ,   0   ,   0   , "G" , "naoVazio()" , "mv_par02", "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
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

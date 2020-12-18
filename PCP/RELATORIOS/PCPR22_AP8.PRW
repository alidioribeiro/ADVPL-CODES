#INCLUDE "RWMAKE.CH"      //MSCBSAYBAR(038,006,Alltrim(N1_CODBAR),"N","1",8,.F.,.F.,,,3,2,,,,)
                         // MSCBSAYBAR(038,006,Alltrim(N1_CODBAR),"N","C",8.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)

USER FUNCTION PCPR22()

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё DECLARACAO DE VARIAVEIS UTILIZADAS NO PROGRAMA ATRAVES DA FUNCAO    Ё
//Ё SETPRVT, QUE CRIARA SOMENTE AS VARIAVEIS DEFINIDAS PELO USUARIO,    Ё
//Ё IDENTIFICANDO AS VARIAVEIS PUBLICAS DO SISTEMA UTILIZADAS NO CODIGO Ё
//Ё INCLUIDO PELO ASSISTENTE DE CONVERSAO DO AP5 IDE                    Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

SETPRVT("CBTXT,CBCONT,CABEC1,CABEC2,WNREL,TITULO")
SETPRVT("CDESC1,CDESC2,CDESC3,TAMANHO,LIMITE,XSAIDA")
SETPRVT("AORD,LCONTINUA,CUM,LEND,ARETURN,NOMEPROG")
SETPRVT("NLASTKEY,CPERG,XCPI,GQUANT,GF_MPN,GF_MPI")
SETPRVT("XCOMP,XDATA,XDATFCH,XMES,XCOMPRA,XDATFIN")
SETPRVT("CDATINI,CDATFIN,XDATINI,XSALPED,CSTRING")
SETPRVT("XMRP,XCOMPRA,APDTS,XGERMES,dValIni,dValFin") 

		
/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFUN┤┘O    Ё PCPR22   Ё AUTOR Ё Remerson Mogi         Ё DATA Ё 06.04.06 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDESCRI┤┘O Ё RELATORIO DAS SAIDAS DIARIAS, INFORMANDO AO USER A QTD     Ё╠╠
╠╠Ё          Ё E O ULTIMO PLANO.                                          Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁSINTAXE   Ё RDMAKE PCPR20 -X                                           Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁPARAMETROSЁ                                                            Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё USO      Ё                                                            Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё DEFINE VARIAVEIS                                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

TITULO    := PADC("MRP - NECESSIDADES DA ESTRUTURA.",74)
CDESC1    := PADC("ESTE PROGRAMA TEM COM OBJETIVO, GERAR AS NECESSIDADES DE MATERIAS",74)
CDESC2    := PADC("CONFORME PREVISAO DE VENDAS, CONFORME A ESTRUTURA DE PRODUTOS",74)
CDESC3    := PADC("DENTRO DO PERIODO ESPECIFICADO NOS PARAMETROS.",74)
TAMANHO   := "G"
LIMITE    := 220
CSTRING   := "SC4"
AORD      := {} //-- ORDEM
LCONTINUA := .T.
CUM       := ""
LEND      := .F.
ARETURN   := { "ZEBRADO", 1,"ADMINISTRACAO", 2, 2, 1, "",1 }
NOMEPROG  := "PCPR22"
NLASTKEY  := 0
CPERG     := "PCPR00"
CMES      := {}
CDIA      := {}
AMSG      := {}
CSMAN     := {}
XDIAS     := {}
xEmpresa  := SM0->M0_CODIGO 
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё VERIFICA AS PERGUNTAS SELECIONADAS                          Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

PERGUNTE(CPERG,.F.)

AADD(CMES,{"JAN","31","08"})
AADD(CMES,{"FEV","28","09"})
AADD(CMES,{"MAR","31","10"})
AADD(CMES,{"ABR","30","11"})
AADD(CMES,{"MAI","31","12"})
AADD(CMES,{"JUN","30","01"})
AADD(CMES,{"JUL","31","02"})
AADD(CMES,{"AGO","31","03"})
AADD(CMES,{"SET","30","04"})
AADD(CMES,{"OUT","31","05"})
AADD(CMES,{"NOV","30","06"})
AADD(CMES,{"DEZ","31","07"})   

AADD(CSMAN,{"Sun","DOM"})
AADD(CSMAN,{"Mon","SEG"})
AADD(CSMAN,{"Tue","TER"})
AADD(CSMAN,{"Wed","QUA"})
AADD(CSMAN,{"Thu","QUI"})
AADD(CSMAN,{"Fri","SEX"})
AADD(CSMAN,{"Sat","SAB"})


//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё VARIAVEIS UTILIZADAS PARA PARAMETROS                        Ё
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё MV_PAR01  D  8   // PERIODO INCIAL (DDMMAAAA)               Ё
//Ё MV_PAR02  D  8   // PERIODO FINAL (DDMMAAAA)                Ё
//Ё MV_PAR03  N 15   // DO PRODUTO                              Ё
//Ё MV_PAR04  N 15   // ATE O PRODUTO                           Ё
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё ENVIA CONTROLE PARA A FUNCAO SETPRINT                       Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

WNREL := "PCPR22"
WNREL := SETPRINT(CSTRING,WNREL,CPERG,@TITULO,CDESC1,CDESC2,CDESC3,.F.,,)

IF NLASTKEY==27
	RETURN
ENDIF

SETDEFAULT(ARETURN,CSTRING)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё VARIAVEIS UTILIZADAS PARA IMPRESSAO DO CABECALHO E RODAPE  Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

CBTXT   := SPACE(10)
CBCONT  := 00
LI      := 80
M_PAG   := 01
CCABEC1 := "   "
CCABEC2 := "   "  
if xEmpresa == "01"
AMSG:= {"PLANO      ",;
        "SAIDAS     "}
else
AMSG:= {"PEDIDO     ",;
        "QUANTADE   "}
end

XQUANT  := 0
CDIAINI := DAY   (MV_PAR01)
CDIAFIN := DAY   (MV_PAR02)
CMESINI := MONTH (MV_PAR01)
CMESFIN := MONTH (MV_PAR02)
CANOINI := YEAR  (MV_PAR01)
CANOFIN := YEAR  (MV_PAR02)
CDATINI := MV_PAR01  
CDATFIN := MV_PAR02 


IF CDIAINI > CDIAFIN
	MSGSTOP("PERIODO INICIAL MAIOR QUE PERIODO FINAL...")
	RETURN
ELSEIF CDIAINI == CDIAFIN 	
	XQUANT := (CDIAFIN - CDIAINI) + 1 
ELSEIF CDIAINI < CDIAFIN 
	XQUANT := (CDIAFIN - CDIAINI) + 1
    IF XQUANT > 31
       MSGSTOP("ULTRAPASSOU 30 DIAS, PORFAVOR ESCOLHA PERIODO MENOR...")
	   RETURN
	ENDIF
ENDIF

// --------------------------------------------
// MONTA CABECALHO PARA IMPRESSAO DE RELATORIO.
// --------------------------------------------
DBSELECTAREA("SC4")
DBSETORDER(2)
DBSEEK(XFILIAL("SC4") + DTOS(CDATINI), .T.)
xPassa :=.T.
XCOL   := 022
XPOS   := {}
XMESES := {}
XDIA   := {}
XDSM   := {}

//  
FOR XINI:= CDIAINI to CDIAFIN

	XDATE:=STRZERO(XINI,2)+"/"+STRZERO(MONTH(mv_par01),2)+"/"+STRZERO(YEAR(mv_par01),4) 
	
	IF DOW(CTOD(XDATE)) == 1                //Elimina os domingos 
	   XQUANT:=XQUANT-1
	   xPassa:=.F.	   
	ENDIF
	   
	IF xPassa
	   IF ASCAN(XDIAS, XINI) == 0               //Verifica se o dia ja foi add no vector
	      AADD(XDIAS ,XINI)                     //Add dia no vector
		  AADD(XPOS  ,XCOL)                     //Add posiГЦo
		  
		  nPos := ASCAN(CSMAN,{|X| X[1] == SUBS(CDOW(CTOD(XDATE)),1,3)   }) //Verifica em que posiГЮo do vector
		          	                                                        //contem um determinado dia da semana.
		  CCABEC1  += " "+STRZERO(XINI,2)+"-"+SUBS(CSMAN[nPos][2],1,7)
		  XCOL     += 16				
	   ENDIF	  
	ENDIF
	xPassa:=.T.	
Next           
CCABEC1  += "   Total"
// 
     
XMRP    := {}
XCOMPRA := {}
APDTS   := {}
XGERMES := {}
GQMES   := 0
GVMES   := 0
GFMES   := 0
AIMP    := ARRAY(XQUANT,5)

FOR XI := 1 TO XQUANT
	XM      := STRZERO(XI,2)
	CQUANT  := "GQMES"+XM
	NMES    := "VMES" + STRZERO(IIF( CDIAINI+XI-1 > 12, CDIAINI+XI-13, CDIAINI+XI-1 ),2)
	&CQUANT := 0            
	&NMES   := XI
	FOR N:=1 TO 5
		AIMP[XI][N] := 0
	NEXT
NEXT 

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё DEFINICAO DOS CABECALHOS                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

TITULO := "MRP - PLANILHA DE ENTREGA DIARIA"
CABEC1 := "PLANO.:"+CMES[MONTH(MV_PAR01)][1]
CABEC2 := "PERIODO "+CCABEC1
//         XXXXXXXXXXXXXXX XXXXXxxxxxxxxxxXXXXXxxxxxxxxxx  9,999
//         12345678901234567890123456789012345678
//                 10        20        30

IF NLASTKEY == 27
	RETURN
ENDIF

	PROCESSA({|| RPTDETAIL()})
	RPTSTATUS({|| PIMPRIME()})
RETURN  
	

STATIC FUNCTION RPTDETAIL()

DBSELECTAREA("SC4")
DBSETORDER(1)
DBSEEK(XFILIAL("SC4") + MV_PAR03, .T.)

PROCREGUA(RECCOUNT())

WHILE !EOF() .AND. C4_PRODUTO <= MV_PAR04 .AND. LCONTINUA

	IF LASTKEY() == 286
		LEND := .T.
	END

	IF LEND
		@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
		LCONTINUA := .F.
		EXIT
	ENDIF
	
	IF C4_DATA < CDATINI .OR. C4_DATA > CDATFIN // teste
	//	IF C4_DATA = CDATINI .OR. C4_DATA = CDATFIN 
		   DBSKIP()                               
		   LOOP
	 //	ENDIF   
	END	

	XPRODUTO := C4_PRODUTO
	XPASSA   := .T.
	xDoc:=SC4->C4_DOC
	WHILE !EOF() .AND. XPRODUTO == C4_PRODUTO
		
		INCPROC()
		
		IF C4_DATA < CDATINI .OR. C4_DATA > CDATFIN
			DBSKIP()
			LOOP
		END  
		
	    if xEmpresa == "01"   
	       nPos := ASCAN(XMRP,{|X| X[1] == xProduto .AND. DAY(SC4->C4_DATA) == X[4] })
		   IF nPos == 0 				    
			  aAdd(XMRP, {xProduto,;		    // 01 COMPONENTE
		                  SC4->C4_QUANT,;		// 02 QUANTIDADE				           
			              SC4->C4_DATA,;	    // 03 DATA
			              DAY(SC4->C4_DATA),;	// 04 DIA
	                      SC4->C4_DOC })        // 05 PLANO 
		   ELSEIf xDoc >= XMRP[nPos][5]
			XMRP[nPos][1] := xProduto	        // 01 COMPONENTE
		    XMRP[nPos][2] := SC4->C4_QUANT	    // 02 QUANTIDADE				           
			XMRP[nPos][3] := SC4->C4_DATA       // 03 DATA
			XMRP[nPos][4] := DAY(SC4->C4_DATA)  // 04 DIA
			XMRP[nPos][5] := SC4->C4_DOC        // 05 PLANO 
		   
		   ENDIF 
				
		   IF ASCAN(APDTS,xProduto)==0
		      AADD(APDTS,xProduto) 
		   ENDIF	
		Else
		   nPos := ASCAN(XMRP,{|X| X[1] == xProduto .AND. DAY(SC4->C4_DATA) == X[4] })
		   IF nPos == 0 				    
			  aAdd(XMRP, {xProduto,;		    // 01 COMPONENTE
		                  SC4->C4_QUANT,;		// 02 QUANTIDADE				           
			              SC4->C4_DATA,;	    // 03 DATA
			              DAY(SC4->C4_DATA),;	// 04 DIA
	                      SC4->C4_DOC })        // 05 PLANO 
	                      //msgstop("Add..."+xProduto+"-"+str(DAY(SC4->C4_DATA))+"-"+SC4->C4_DOC)
		   ELSE
			//XMRP[nPos][1] := xProduto	        // 01 COMPONENTE
		    XMRP[nPos][2] += SC4->C4_QUANT	    // 02 QUANTIDADE
			//XMRP[nPos][3] := SC4->C4_DATA       // 03 DATA
			//XMRP[nPos][4] := DAY(SC4->C4_DATA)  // 04 DIA
		    //XMRP[nPos][5] := SC4->C4_DOC        // 05 PLANO 
		    //msgstop("Edit..."+XMRP[nPos][1]+"-"+str(XMRP[nPos][4])+"-"+XMRP[nPos][5])
		   Endif 
		   	IF ASCAN(APDTS,xProduto)==0
		      AADD(APDTS,xProduto) 
		    endif	   
		End	
		DBSKIP()		
		xDoc:=	SC4->C4_DOC
	ENDDO
	
ENDDO

RETURN

Static Function pImprime()

nTIPO := Iif(aReturn[4]==1,15,18)
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
aSort(aPdts)
SetRegua(Len(aPdts))
I     := 1
   
For I :=1 to Len(aPdts)
	xTot:=0
	IncRegua()
	dbSelectArea("SB1")  // CADASTRO DE PRODUTO
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+aPdts[I])
	nInex := B1_PERSEG

	c_Comp     := aPdts[I]
	
	//Verificando as Saidas
	For N := 1 TO xQuant
		nPos := aScan(xMRP    ,{|X| X[1] == c_comp .and. X[4] == XDIAS[N]})
		aImp[N][2] := IIF(nPos<>0, xMRP[nPos][5]   , "000")   //DOC
		aImp[N][3] := IIF(nPos<>0, xMRP[nPos][2]   , 0)       //Saidas 
		xTot       := xTot + aImp[N][3]
	Next	
    //Procura o codigo da NIPPON SEIKI
    DBSELECTAREA("SA7")                                //TABELA PRODUTO POR CLIENTE
    DBSETORDER(2)
    IF DBSEEK(XFILIAL("SA7") + aPdts[I])               //CODPRODCLI+CLIENTE    
	   //msgstop("Cod Cli:."+SA7->A7_CODCLI)
	else
	    //msgstop("Nao Encontrou..."+aPdts[I])
	Endif
	@ LI,000 PSAY "PRODUTO: NS:." + aPdts[I]        		+ " HDA:." + ;	// COMPONENTE 
	SA7->A7_CODCLI			                                + "   " + ;	// CODIGO DO CLIENTE
	SubStr(SB1->B1_DESC,1,40)			                            	// DESCRICAO
	
	Li+=2
	
	For N:=1 to 2
		For M:=1 to xQuant
			If M==1
				@ LI,000      PSAY aMsg[N]				
			EndIf					
			@ LI,PCOL()+2   PSAY IIF(N==1,"  "+SUBS(aImp[M][2],4,3) ,Transform(aImp[M][3],"@E 9,999"))  
		//  @ LI,PCOL()+2   PSAY IIF(N==1,SUBS(aImp[M][2],4,5) ,Transform(aImp[M][3],"@E 9,999")) 		
		Next
		@ LI,PCOL()+2 PSAY IIF(N==1,"  ",Transform(xTot,"@E 99,999"))
		LI++
	Next
	
	@ LI,000 PSAY Replicate("-",Limite)
	Li += 1
	
	If Li > 65
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	End
Next                                                                                                


Set Device To Screen

If ARETURN[5] == 1
	Set Printer To
	DBCOMMITALL()
	OurSpool(WNREL)
EndIf
MS_FLUSH()
Return
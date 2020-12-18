#INCLUDE "RWMAKE.CH"

USER FUNCTION PCPR30()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ DECLARACAO DE VARIAVEIS UTILIZADAS NO PROGRAMA ATRAVES DA FUNCAO    ³
//³ SETPRVT, QUE CRIARA SOMENTE AS VARIAVEIS DEFINIDAS PELO USUARIO,    ³
//³ IDENTIFICANDO AS VARIAVEIS PUBLICAS DO SISTEMA UTILIZADAS NO CODIGO ³
//³ INCLUIDO PELO ASSISTENTE DE CONVERSAO DO AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SETPRVT("CBTXT,CBCONT,CABEC1,CABEC2,WNREL,TITULO")
SETPRVT("CDESC1,CDESC2,CDESC3,TAMANHO,LIMITE,XSAIDA")
SETPRVT("AORD,LCONTINUA,CUM,LEND,ARETURN,NOMEPROG")
SETPRVT("NLASTKEY,CPERG,XCPI,GQUANT,GF_MPN,GF_MPI")
SETPRVT("XCOMP,XDATA,XDATFCH,XMES,XCOMPRA,XDATFIN")
SETPRVT("CDATINI,CDATFIN,XDATINI,XSALPED,CSTRING")
SETPRVT("XMRP,XCOMPRA,APDTS,XGERMES,dValIni,dValFin") 
SETPRVT("xSaldAnt,cSaldAnt,xItem")

		
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³FUNCAO    ³ PCPR20   ³ AUTOR ³ JORGE SILVEIRA        ³ DATA ³ 15.09.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI‡…O ³ NECESSIDADES DA ESTRUTURA. GERACAO DAS ORDENS DE PRODUCAO. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE   ³ RDMAKE PCPR30 -X                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³PARAMETROS³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ USO      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ DEFINE VARIAVEIS                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

TITULO    := PADC("MRP - GERA ORDENS DE PRODUCAO",74)
CDESC1    := PADC("ESTE PROGRAMA TEM COM OBJETIVO, GERAR AS NECESSIDADES DE MATERIAS",74)
CDESC2    := PADC("A SEREM PRODUZIDOS, CORFORME PLANEJAMENTOO NAS PREVISOES DE VENDA.",74)
CDESC3    := PADC("OBS.: AS ORDENS DE PRODUCAO SERAO GERADAS COM TIPO PREVISTAS.",74)
TAMANHO   := "G"
LIMITE    := 220
CSTRING   := "SC4"
AORD      := {} //-- ORDEM
LCONTINUA := .T.
CUM       := ""
LEND      := .F.
ARETURN   := { "ZEBRADO", 1,"ADMINISTRACAO", 2, 2, 1, "",1 }
NOMEPROG  := "PCPR30"
NLASTKEY  := 0
CPERG     := "PCPR02"
CMES      := {}
AMSG      := {} 
ANUM      := {}
xItem     := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VERIFICA AS PERGUNTAS SELECIONADAS                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

PERGUNTE(CPERG,.F.)

nAno  := Val(subs(mv_par01,3,4))
AADD(CMES,{"JAN","31","08"})
AADD(CMES,iif(Mod(nAno,4) = 0 ,{"FEV","29","09"},{"FEV","28","09"}))
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


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VARIAVEIS UTILIZADAS PARA PARAMETROS                        ³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MV_PAR01  C  6   // PERIODO INCIAL (MMAAAA)                 ³
//³ MV_PAR02  C  6   // PERIODO FINAL (MMAAAA)                  ³
//³ MV_PAR03  N 15   // DO PRODUTO                              ³
//³ MV_PAR04  N 15   // ATE O PRODUTO                           ³
//³ MV_PAR05  N  1   // ORIGEM (EM MANAUS/OUTRO ESTADO/IMPORTADO³
//³ MV_PAR06  N  1   // DO GRUPO DE MATERIAIS                   ³
//³ MV_PAR07  N  1   // ATE O GRUPO DE MATERIAIS                ³
//³ MV_PAR08  N  1   // SALDO: ATUAL/MENSAL/INVENTARIADO        ³
//³ MV_PAR09  N  1   // DO TIPO DE MATERIAIS                    ³
//³ MV_PAR10  N  1   // ATE O TIPO DE MATERIAIS                 ³
//³ MV_PAR11  N  1   // CONSIDERA ESTOQUE DE SEGURANÇA (S/N)    ³
//³ MV_PAR12  N  1   // CONSIDERA MATERIAL EM TRANSITO (S/N)    ³
//³ MV_PAR13  N  1   // APENAS NECESSIDADE (S/N)                ³
//³ MV_PAR14  N  1   // QUANTO AO IDIOMA (PORTUGUES/INGLES)     ³
//³ MV_PAR15  N  1   // GERA PLANILHA COM AS NECESSIDADES (S/N) ³
//³ MV_PAR16  N  1   // GERA SOLICITACAO DE COMPRAS       (S/N) ³
//³ MV_PAR17  N  1   // CONSIDERA PEDIDOS EM ATRAZO       (S/N) ³
//³ MV_PAR18  D  8   // PERIODO DE PESQUISA PED. ATRAZADOS      ³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ENVIA CONTROLE PARA A FUNCAO SETPRINT                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

WNREL := "PCPR20"
WNREL := SETPRINT(CSTRING,WNREL,CPERG,@TITULO,CDESC1,CDESC2,CDESC3,.F.,,)

IF NLASTKEY==27
	RETURN
ENDIF

SETDEFAULT(ARETURN,CSTRING)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VARIAVEIS UTILIZADAS PARA IMPRESSAO DO CABECALHO E RODAPE  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

CBTXT   := SPACE(10)
CBCONT  := 00
LI      := 80
M_PAG   := 01
CCABEC  := "   "

AMSG:= {"SALDO EM ESTOQUE    ",;
		iif(mv_par12==1,"ENTRADAS            ","ENTRADAS (N.C.)     "),;
		"SAIDAS ESTRUTURA    ",;
		iif(mv_par17==2,"SALDO               ","SALDO\PED. ATRAZO   "),;
		"NECESSIDADE         "}

AMSG1:= {"COMPRAS          US$",;
	  	 "SAIDAS ESTRUTURA US$",;
	     "SALDO            US$"}
aTotUS:={}

XQUANT  := 0
CDIAINI := "01"
CMESINI := VAL(SUBS(MV_PAR01,1,2))
CMESFIN := VAL(SUBS(MV_PAR02,1,2))
CANOINI := VAL(SUBS(MV_PAR01,3,4))
CANOFIN := VAL(SUBS(MV_PAR02,3,4))
CDIAFIN := CMES[CMESFIN][02]
CDATINI := CTOD( CDIAINI+"/"+STRZERO(CMESINI,2)+"/"+STRZERO(CANOINI,4) )
CDATFIN := CTOD( CDIAFIN+"/"+STRZERO(CMESFIN,2)+"/"+STRZERO(CANOFIN,4) )
cDtPedA := DTOS(mv_par18)

IF CDATINI > CDATFIN
	MSGSTOP("PERIODO INICIAL MAIOR QUE PERIODO FINAL...")
	RETURN
ELSEIF CMESINI > 12 .OR. CMESFIN > 12
	MSGSTOP("MES INVALIDO...")
	RETURN
ELSEIF CMESINI == CMESFIN .AND. CANOINI == CANOFIN
	XQUANT := 1
ELSEIF CMESINI < CMESFIN .AND. CANOINI == CANOFIN
	XQUANT := CMESFIN - CMESINI + 1
ELSEIF CMESINI > CMESFIN .AND. CANOINI < CANOFIN
	XQUANT := 13 - (CMESINI - CMESFIN)
END


// --------------------------------------------
// MONTA CABECALHO PARA IMPRESSAO DE RELATORIO.
// --------------------------------------------
DBSELECTAREA("SHC")
DBSETORDER(1)
DBSEEK(XFILIAL("SHC") + DTOS(CDATINI), .T.)

XCOL   := 022
XPOS   := {}
XMESES := {}
XINI   := CDATINI//HC_DATA

WHILE XINI <= CDATFIN
	IF ASCAN( XMESES, MONTH(XINI)) == 0
		AADD(XMESES ,MONTH(XINI) )
		AADD(XPOS   ,XCOL )
		CCABEC  += CMES[MONTH(XINI)][1]+"/"+STRZERO(YEAR(XINI),4)+IIF(MV_PAR15==1,"    ","        ")
		XCOL    += IIF(MV_PAR15==1,12,16)
	ENDIF
	XINI ++
ENDDO

XMRP    := {}
XCOMPRA := {}
APDTS   := {}
cSaldAnt:= {}
AcrPer  := ARRAY(XQUANT) // Jorge: 20/09/06
tmNeces := ARRAY(XQUANT) // Jorge: 20/09/06
XGERMES := {}
GQMES   := 0
GVMES   := 0
GFMES   := 0
AIMP    := ARRAY(XQUANT,5)

FOR XI := 1 TO XQUANT // --> Nr. de Meses
	XM      := STRZERO(XI,2)
	CQUANT  := "GQMES"+XM
	NMES    := "VMES" + STRZERO(IIF( CMESINI+XI-1 > 12, CMESINI+XI-13, CMESINI+XI-1 ),2)
	&CQUANT := 0
	&NMES   := XI
	FOR N:=1 TO 5
		AIMP[XI][N] := 0
	NEXT
	AcrPer[XI]  := 0  // Jorge: 20/09/06
	tmNeces[XI] := 0  // Jorge: 20/09/06
NEXT
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ DEFINICAO DOS CABECALHOS                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Mv_Par15 == 1
   TITULO := "MRP - NEED OF MATERIALS"
   CABEC1 := "PRODUCT          DESCRIPTION                              "+CCABEC+   "       Total"
   CABEC2 := ""
   //         999999999999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999.999,99  999.999.999,99
   //         12345678901234567890123456789012345678
   //                 10        20        30
Else
   TITULO := "MRP - NECESSIDADE DE MATERIAIS"
   CABEC1 := "PERIODO                  "+CCABEC
   CABEC2 := ""
   //         XXXXXXXXXXXXXXXXXXXX  999,999,999
   //         12345678901234567890123456789012345678
   //                 10        20        30
End   

IF NLASTKEY == 27
	RETURN
ENDIF

#IFDEF WINDOWS
	PROCESSA({|| RPTDETAIL()})
	RPTSTATUS({|| PIMPRIME()})
	RETURN
	STATIC FUNCTION RPTDETAIL()
#ENDIF

DBSELECTAREA("SHC")
DBSETORDER(4) //(2)
DBSEEK(XFILIAL("SHC") + MV_PAR03, .T.)
PROCREGUA(RECCOUNT())

WHILE !EOF() .AND. HC_PRODUTO <= MV_PAR04 .AND. LCONTINUA
	
	#IFNDEF WINDOWS
		IF LASTKEY() == 286
			LEND := .T.
		END
	#ENDIF
	
	IF LEND
		@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
		LCONTINUA := .F.
		EXIT
	ENDIF
	
	IF HC_DATA < CDATINI .OR. HC_DATA > CDATFIN    // EM: 12/06/2007
		DBSKIP()
		LOOP
 	END
	
	XPRODUTO := HC_PRODUTO
	XPASSA   := .T.
	
	WHILE !EOF() .AND. XPRODUTO == HC_PRODUTO // .And. HC_DATA <= CDATFIN // EM: 12/06/2007
			
		INCPROC("Processando: "+HC_PRODUTO+" Data: "+dtoc(hc_data)) 
	   
		IF HC_DATA < CDATINI .OR. HC_DATA > CDATFIN
			DBSKIP()
			LOOP
		END 
				
		IF HC_NUMPLAN <> "01" // Verifica o Plano p/ Calculo do MRP.
			DBSKIP()
			LOOP
		END
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SHC->HC_PRODUTO)
		XDESC   := SUBS(B1_DESC,1,40)
		XTIPO   := B1_TIPO
		XUM     := B1_UM
		CPRD    := XPRODUTO
		xOPC    := AllTrim(SB1->B1_OPC)
		ASTRU   := {}
		NESTRU  := 0
		I       := 0
		dValIni := ctod("01/"+SubStr(dtos(SHC->HC_DATA),5,2)+"/"+SubStr(dtos(SHC->HC_DATA),1,4))
		dValFin := ctod(cMes[month(SHC->HC_DATA)][2]+"/"+SubStr(dtos(SHC->HC_DATA),5,2)+"/"+SubStr(dtos(SHC->HC_DATA),1,4))
		ASTRU   := GetStru(CPRD)  // OBTEM A ESTRUTURA
		FOR I:=1 TO LEN(ASTRU)    // MONTA ESTRUTURA DE PRODUTO.
			
			CCOMP  := ASTRU[I,3]
			CQNEC  := 0
			
			DBSELECTAREA("SG1")  // ESTRUTURA DE PRODUTO
			DBSETORDER(1)
			DBSEEK(XFILIAL("SG1")+ASTRU[I,2]+ASTRU[I,3]+ASTRU[I,5])
			
			DBSELECTAREA("SB1")  // CADASTRO DE PRODUTO
			DBSETORDER(1)
			DBSEEK(XFILIAL("SB1")+CCOMP)
			
		    IF !Empty(SG1->G1_GroPc) .And. !(Alltrim(SG1->G1_GroPc)+Alltrim(SG1->G1_Opc) $ xOpc) // Jorge: 29/05/07 (Opcionais Padrao)
			 //   Verificar Saldo dos Opcionais
			    xPassa := .F.
			END
			
			IF B1_GRUPO < MV_PAR06 .OR. B1_GRUPO > MV_PAR07 .OR.;
			   B1_MRP # "S" .OR. B1_TIPO < MV_PAR09 .OR. B1_TIPO > MV_PAR10 .OR. SG1->G1_FIXVAR<>"V"
			   xPassa := .F.
			END
			
			IF (dValIni < SG1->G1_INI .or. dValFin > SG1->G1_FIM)
				xPassa := .F.
			END
			
			cQNec := ASTRU[I,4] * SHC->HC_QUANT
			
			IF cQnec > 0 .and. xPassa
				nPos := ASCAN(XMRP,{|X| X[1] == CCOMP .AND. MONTH(SHC->HC_DATA) == X[4] })
				IF nPos == 0
					aAdd(XMRP, {cComp,;			            // 01 COMPONENTE
					            cQNec,;						// 02 QUANTIDADE
					            SHC->HC_DATA,;				// 03 DATA
					            MONTH(SHC->HC_DATA) })		// 04 MES
				ELSE
					XMRP[NPOS][02] += CQNEC
				ENDIF
				IF ASCAN(APDTS,CCOMP)==0
					AADD(APDTS,CCOMP)
					If mv_par12==1
						SALPED()
					EndIf
				ENDIF
				
			END
			xPassa := .T.
		NEXT
		
		DBSELECTAREA("SHC")
		DBSKIP()
		
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
	
	IncRegua()
	dbSelectArea("SB1")  // CADASTRO DE PRODUTO
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+aPdts[I])
	xIndPer := 1 + SB1->B1_INDPER /(100 - SB1->B1_INDPER)  // Jorge: 19/09/06
    If MV_PAR11==1
		nInex := B1_PERSEG
	Else
		nInex := 0
	EndIf
	
	If mv_par08 == 1   // SALDO ATUAL
		dbSelectArea("SB2")
		dbSetOrder(1)
		IF dbSeek(xFilial("SB2")+SB1->B1_COD) //+"01")		
		   nPos:=ASCAN(cSaldAnt,B2_COD)
		   aImp[1][1] := iif(ASCAN(cSaldAnt,B2_COD)<>0,cSaldAnt[ASCAN(cSaldAnt,B2_COD)][2],0)  // Jorge Em: 06.02.2007
		   if nPos <> 0
		   While !Eof() .And. SB1->B1_COD==B2_COD
		      If B2_Local $ "01-98"
		         aImp[1][1] := aImp[1][1] + B2_QATU
		         dbSkip()
		      End   
		   EndDo
		   End
		Else
		   aImp[1][1] := 0   
		End
	Else                 // SALDO MOVIMENTO. (FINAL)
    	dbSelectArea("SB2")
		dbSetOrder(1)
		xEst01  := CalcEst(SB1->B1_COD,"01",dDataBase)[1] // Jorge Em: 01.02.2007
		xEst98  := CalcEst(SB1->B1_COD,"98",dDataBase)[1] // Jorge Em: 01.02.2007
		aImp[1][1] := xEst01 + xEst98 // + cSaldAnt[nPos][2]  // Jorge Em: 06.02.2007
		
	EndIf
	c_Comp     := aPdts[I]
	
	For N := 1 TO xQuant
	    AcrPer[N] := 0
	    nPos := aScan(xCompra ,{|X| X[1] == c_Comp .and. X[4] == xMeses[N]})
		aImp[N][2] := IIF(nPos<>0, xCompra[nPos][2], 0)
		nPos := aScan(xMRP    ,{|X| X[1] == c_comp .and. X[4] == xMeses[N]})
		aImp[N][3] := IIF(nPos<>0, xMRP[nPos][2]   , 0)
		If aImp[N][3] > 0 // Jorge: 20/09/06
	 	   AcrPer[N] := (aImp[N][3] * xIndPer - aImp[N][3]) 
	 	End   
	Next
	nTNec := 0
	For N := 1 to xQuant
		nPrev := 0
		For y:=1 to Int(nInex)
			If N+y <= Len(aImp)
				nPrev += aImp[N+y][3]
			EndIf
		Next
		y := Int(nInex)+1
		If N+y <= Len(aImp)
			nPrev += aImp[N+y][3]*Mod(nInex,1)
		EndIf

		aImp[N][4] := aImp[N][1] + aImp[N][2] - aImp[N][3] - AcrPer[N] //remerson 04/01/07
		/*Compras em atraso 07/01/07*/
		IF mv_par17==1 
		   if N==1
		      cPos:=ascan(csaldant,{|X| X[1] == c_Comp})
		      aImp[N][4] += csaldant[cPos][2]
		   end
		END
		/*Compras em atraso 07/01/07*/		
		nImp3      := nPrev 
	    aImp[N][5] := Iif(nImp3-aImp[N][4]<=0,0,(nImp3-aImp[N][4]) + AcrPer[N] )
	    If SB1->B1_LE > 0
	       aImp[N][5] := Iif(Mod(aImp[N][5],SB1->B1_LE)==0,aImp[N][5],INT((aImp[N][5]/SB1->B1_LE)+1)*SB1->B1_LE)   // Jorge: 19/09/06
	    End
		nTNec      += aImp[N][5]
		
		If N<xQuant
			aImp[N+1][1]  := aImp[N][4] + aImp[N][5]
		EndIf
	Next
	If nTNec==0 .and. mv_par13==1
		Loop
	EndIf
	
	If MV_Par15==1 // Gera Planinha somente com as necessidades.
	   
	   @ LI,000      PSAY aPdts[I]        			 			     	// COMPONENTE
	   if mv_par14==1
	      @ LI,PCOL()+2 PSAY SubStr(SB1->B1_DESC,1,40)			     	// DESCRICAO PORTUGUES
	   Else
	      @ LI,PCOL()+2 PSAY SubStr(SB1->B1_DESC_EN,1,40)			   	// DESCRICAO INGLES
	   End
	   xTotNec := 0
	   //xSeqItem:= 1 
   	   _undMed:= subs(Posicione("SB1",1,xFilial("SB1")+aPdts[I],"B1_UM"),1,2)  
       xCol:=PCOL()  
       
	   For M:=1 to xQuant
	    
		   @ LI,PCOL()+2 PSAY IIF(AllTrim(_undMed)$"KG/L/",Transform(aImp[M][5],"@E 99,999.999"),Transform(aImp[M][5],"@E 99,999,999"))
		   tmNeces[M] := tmNeces[M] + aImp[M][5]
		   xTotNec := xTotNec + aImp[M][5]		 
		   
		   IF mv_par16 == 1 .And. M==5 .And. aImp[M][5] > 0 // Jorge Em: 05/09/07
		     // U_geraSolCompra(M,xQuant,aPdts[I]) //Rmogi - GERAÇÃO AUTOMATICA DE SOLICITAÇÃO DE COMPRAS - 10/01/07
		     xItem += 1
		     geraSolCompra(M,aImp[M][5],aPdts[I],xItem) // Jorge Em: 05/09/07
           End
	   Next
	   
	   @ LI,PCOL()+2 PSAY IIF(AllTrim(_undMed)$"KG/L/",Transform(xTotNec,"@E 99,999,999.999"),Transform(xTotNec,"@E 99,999,999,999"))
       li++                                                                 //999.999.999,99
       
       If Li > 60
		  Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   EndIf

	Else
  	   @ LI,000      PSAY "PRODUTO: " + aPdts[I]        			 				// COMPONENTE
	   @ LI,PCOL()+3 PSAY SubStr(SB1->B1_DESC,1,40)				    				// DESCRICAO PORTUGUES
	   if mv_par14==2
	      @ LI,PCOL()+3 PSAY SubStr(SB1->B1_DESC_EN,1,30)			           		// DESCRICAO INGLES
	   end
	   
	   cPos:=ascan(cSaldAnt,{|X| X[1] == aPdts[I]})
	   
	   @ LI,PCOL()+3 PSAY "UM: "       + SB1->B1_UM 								// UM
	   @ LI,PCOL()+3 PSAY "TIPO: "     + SB1->B1_TIPO 		    					// TIPO
	   @ LI,PCOL()+3 PSAY "GRUPO: "    + SubStr(SB1->B1_GRUPO,1,3)					// GRUPO
	   @ LI,PCOL()+3 PSAY "SEGURANÇA:" + Transform(nInex         , "@e 99.99")	 	// ESTOQUE SEGURANÇA
       @ LI,PCOL()+3 PSAY "IND.PERDA:" + Transform(SB1->B1_INDPER, "@e 99.99%")	 	// INDICE DE PERDA
       @ LI,PCOL()+3 PSAY "LOTE ECONOM:" + Transform(SB1->B1_LE,"@e 999,999")	    // LOTE ECONOMICO
       IF cSaldAnt[cPos][2] > 0  
       @ LI,PCOL()+3 PSAY "PED. ATRAZO:" + Transform(cSaldAnt[cPos][2],"@e 999,999")// Saldos de Compras
       End
	   Li+=2
       _undMed:= subs(Posicione("SB1",1,xFilial("SB1")+aPdts[I],"B1_UM"),1,2)  	   	                 	                 
	   
	   IF Mv_Par15 == 3
       
       A     :=0                                                                    
       xPrPro:=U_QuanProd(aPdts[I]) /*captura o proco do produto de acordo com a tabela 001*/       
       For N:=5 to 1 step -1 
	       For M:=1 to xQuant
	           If M==1  .and. (N==5 .or. N==3  .or. N==1) 
	           Do case 
	              case N == 5
	                   A:=1
	              case N == 3
	                   A:=2
	              case N == 1  
	                   A:=3
	           end case
			      @ LI,000  PSAY aMsg1[A]
			   End	       	   
		       /*TESTE PARA O PLANEJAMENTO DE DO MPI*/                      
	           if N==5 .or. N==3  .or. N==1 	                 
	              if N==1 
	                 xSaldo:=(aImp[M][1]+aImp[M][5]+aImp[M][2])-aImp[M][3]  
                     xSaldo*=xPrPro
                     @ LI,PCOL()+2 PSAY Transform(xSaldo,"@E 999,999,999.99")
                  elseIf N==5
                     xPreco:=(aImp[M][5]+aImp[M][2])*xPrPro     
		             @ LI,PCOL()+2 PSAY Transform(xPreco,"@E 999,999,999.99")                  
                  else                     
                     xPreco:=aImp[M][N]*xPrPro     
		             @ LI,PCOL()+2 PSAY Transform(xPreco,"@E 999,999,999.99")
		          end		     
		          
		          nPos := aScan(aTotUS,{|X| M == X[4] })	              
	              If nPos == 0
		             aAdd(aTotUS,{  xPreco,;						// 01 QTD COMPRA 
		                               0.0,;						// 02 QTD SAIDA
		                               0.0,;						// 03 QTD SALDO
		                                 M})						// 04 MES
	              else
	                 Do Case 
	                    Case N==5
	                    aTotUS[nPos][1]+=xPreco   			     	// 01 QTD COMPRA                 
	                    Case N==3
	                    aTotUS[nPos][2]+=xPreco   		        	// 02 QTD SAIDA                   
	                    Case N==1
 		                aTotUS[nPos][3]+=xSaldo	   			    	// 03 QTD SALDO                 
	                 EndCase		                          
	              EndIf
		          
		          IF mv_par16 == 1 .and. N==5
		             msgstop("Relatorio não gera Solicitação de Compra")
		             //U_geraSolCompra(M,xQuant,aPdts[I]) //Rmogi - GERAÇÃO AUTOMATICA DE SOLICITAÇÃO DE COMPRAS - 10/01/07
                  End           
               else
                  Exit
               end               
               xPreco:=0.0
               xSaldo:=0.0
               /*TESTE PARA O PLANEJAMENTO DE MPI*/   
	       Next
           If N==5 .or. N==3 .or. N==1
              li++
           End
       Next       	   
	   @ LI,000 PSAY Replicate("-",Limite)
	   Li += 1
	   If Li > 65
		  Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   EndIf
	   
	   Else
	   For N:=1 to 5
		   For M:=1 to xQuant
		       If M==1
			      @ LI,000  PSAY aMsg[N]
			   End
		   	   @ LI,PCOL()+2 PSAY IIF(AllTrim(_undMed)$"KG/L/",Transform(aImp[M][N],"@E 99,999,999.999"),Transform(aImp[M][N],"@E 99,999,999,999"))
		   	   IF M == 5 .And. mv_par16 == 1 .And. aImp[M][N] > 0 // Jorge Em: 05/09/07
		   	      xItem += 1
		          geraSolCompra(M,aImp[M][N],aPdts[I],xItem) // Jorge Em: 05/09/07
               End
		   Next
		   li++
	   Next
	
	   @ LI,000 PSAY Replicate("-",Limite)
	   Li += 1
	   
	   If Li > 58
		  Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   EndIf
	   end
	EndIf   
	   
Next

If MV_Par15==1 // Gera Planinha somente com as necessidades.
   li++
   @ LI,000      PSAY "Total Geral    "+space(42)
   xGerNec := 0   
   For M:=1 to xQuant
	   @ LI,PCOL()+1 PSAY Transform(tmNeces[M],"@E 999,999,999")
	   xGerNec := xGerNec + tmNeces[M]
   Next
   @ LI,PCOL()+2 PSAY Transform(xGerNec,"@E 99,999,999,999")
   li++
elseif MV_Par15==3   //aTotUS:={}
   If len(aTotUS)<>0
   Li++
   @ LI,000      PSAY "Total Geral    "+space(42)
   Li+=2
   For N:=1 to 3
	   For M:=1 to xQuant
	       If M==1
		      @ LI,000  PSAY aMsg1[N]
		   End 
	   	   @ LI,PCOL()+2 PSAY Transform(aTotUS[M][N],"@E 999,999,999.99")
	   Next
	   li++
   Next
   Else
   msgstop("Produto não gerou necessidade")
   End
End     

Set Device To Screen

If ARETURN[5] == 1
	Set Printer To
	DBCOMMITALL()
	OurSpool(WNREL)
EndIf
MS_FLUSH()
Return

************************************
Static Function Salped()
************************************

dbSelectArea('SC7')
dbSetOrder(7)

// ----- Jorge Em: 06/02/2007
xSaldAnt := 0
dbSeek(xFilial('SC7') + cComp)
While !Eof() .And. cComp == C7_PRODUTO
      If C7_DATPRF >= cDatIni .And. C7_DATPRF <= cDatIni
         xSaldAnt += (C7_QUANT - C7_QUJE)
      End   
      dbSkip()
EndDo
aadd(cSaldAnt,{cComp,xSaldAnt})
// ------Jorge Em: 06/02/2007 */

xSalped := 0
xSaida  := 0

While !Eof() .and. cComp == C7_PRODUTO .and. C7_DATPRF <= cDatFin

	xMesComp := MONTH(C7_DATPRF)
    xCompMes := 0
	While !Eof() .and. cComp == C7_PRODUTO .and. C7_DATPRF <= cDatFin .and. xMesComp == Month(C7_DATPRF)
		
		xCompMes += (C7_QUANT - C7_QUJE)
		
		dbSkip()
	EndDo     
	
	nPos := aScan(xCompra,{|X| X[1] == cComp .And. xMescomp == X[4] })
	
	If nPos == 0
		aAdd(xCompra, {cComp,;	                        // 01 COMPONENTE
		               xCompMes,;						// 02 QUANTIDADE
		               C7_DATPRF,;						// 03 DATA
		               xMescomp})						// 04 MES
	EndIf
	
EndDo

Return()


******************************
Static Function GetStru(cProd)
******************************

dbSelectArea("SG1")
dbSetOrder(1)
dbSeek(xfilial()+cProd)
aStr  := {}
aPai  := {}
aTmp  := {}
cPai  := SG1->G1_COD
nPos  := Recno()
nPos2 := 0
Z     := 0

While !Eof() .And. cPai == SG1->G1_COD
	nPos   := Recno()
	cFilho := SG1->G1_COMP
	IF SG1->G1_FIXVAR == "F"
	   dbSkip()
	   LOOP
	END
	If dValIni >= SG1->G1_INI .and. dValFin <= SG1->G1_FIM
		If dbSeek(xfilial()+cFilho)
			nPos2  := Recno()
			Go nPos
			aAdd(aStr,{StrZero((z+1),2,0),cPai,SG1->G1_COMP,SG1->G1_QUANT*Iif(z>0,aPai[z][3],1),SG1->G1_TRT})
			nQuant := SG1->G1_QUANT
			Go nPos2
			aAdd(aPai,{nPos,cPai,nQuant*Iif(Z>0,aPai[z][3],1)})
			Z      := Len(aPai)
			cPai   := SG1->G1_COD
		Else
			Go nPos
			aAdd(aStr,{StrZero((z+1),2,0),SG1->G1_COD,SG1->G1_COMP,SG1->G1_QUANT*Iif(z>0,aPai[z][3],1),SG1->G1_TRT})
			dbSkip()	
		EndIf
	Else
		go nPos
		dbSkip()
	EndIf
	While cPai<>SG1->G1_COD .and. z>0
		Go aPai[Z][1]
		cPai   := aPai[Z][2]
		dbSkip()
		aTmp   := {}
		For w:=1 to (z-1)
			aadd(atmp,aPai[w])
		Next
		aPai   := {}
		For w:=1 to (z-1)
			aadd(aPai,aTmp[w])
		Next
		Z      := Len(aPai)
	EndDo
EndDo
Return(aStr) 


static FUNCTION GeraSolCompra(mesRef,xNecess,Prod,cItem)   

     _grupo:= subs(Posicione("SB1",1,xFilial("SB1")+Prod,"B1_GRUPO"),1,3)
     
     IF _grupo == "MPI"      
        nPos := aScan(ANUM ,{|X| X[2] == mesRef})
        IF nPos == 0 
           _nextNum:=GetSX8Num("SC1") //Indice do ultimo registro
           ConfirmSX8()             
        
           AADD(ANUM,{CMES[mesRef][1],mesRef,_nextNum,1})
           item:=1       
        ELSE
           _nextNum := ANUM[nPos][3]                              
           item:=ANUM[nPos][4]       
        END    
	 
        dDatPrf    := "01"+"/"+ALLTRIM(STRZERO(mesRef+4,2))+"/"+ALLTRIM(STR(YEAR(DDATABASE),4))                              
        dDatPrf    := CTOD(dDatPrf)
        dDatEms    := "01"+"/"+ALLTRIM(STRZERO(mesRef,2))+"/"+ALLTRIM(STR(YEAR(DDATABASE),4))                 
        dDatEms    := dDataBase // CTOD(dDatEms)
        dDatPrf    := CTOD("01/01/08")
        RecLock("SC1",.T.)               
                 SC1->C1_Filial  := xFilial("SC1") 
                 SC1->C1_NUM     := _nextNum  
                 SC1->C1_ITEM    := strzero(citem,4) 
                 SC1->C1_PRODUTO := Prod 
                 SC1->C1_UM      := SUBS(AllTrim(Posicione("SB1",1,xFilial("SB1")+Prod,"B1_UM")),1,2)    
                 SC1->C1_QUANT   := xNecess // aImp[mesRef+4][5] 
                 SC1->C1_DATPRF  := dDatPrf
                 SC1->C1_LOCAL   := SUBS(AllTrim(Posicione("SB1",1,xFilial("SB1")+Prod,"B1_LOCPAD")),1,2)    
                 //SC1->C1_OBS     := "GERACAO AUTO. SOL. COMPRAS" 
                 SC1->C1_CC      := SUBS(AllTrim(Posicione("SB1",1,xFilial("SB1")+Prod,"B1_CC")),1,3)    
                 SC1->C1_EMISSAO := dDatEms 
                 SC1->C1_DESCRI  := SUBS(AllTrim(Posicione("SB1",1,xFilial("SB1")+Prod,"B1_DESC_EN")),1,30)    
                 SC1->C1_SOLICIT := SUBSTR(CUSUARIO,7,15)
                 SC1->C1_ORIGEM  := "MPR" + STRZERO(month(dDataBase),2)                     
        dbUnlock()
	 END
Return 
     
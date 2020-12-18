#INCLUDE "RWMAKE.CH"

USER FUNCTION MRPNSSP()

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
SETPRVT("xSaldAnt,cSaldAnt,xItem,xGrOpc,xOpc")

		
/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFUNCAO    Ё MRPNSSP  Ё AUTOR Ё JORGE SILVEIRA        Ё DATA Ё 15.07.99 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDESCRI┤┘O Ё NECESSIDADES DA ESTRUTURA.                                 Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁSINTAXE   Ё RDMAKE MRPNSSP -X                                          Ё╠╠
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
CDESC2    := PADC("PRIMAS, BASEADO NO PLANO MESTRE DE PRODUCAO, CONFORME A ESTRUTURA",74)
CDESC3    := PADC("DE PRODUTOS DENTRO DO PERIODO ESPECIFICADO NOS PARAMETROS.",74)
TAMANHO   := "G"
LIMITE    := 220
CSTRING   := "SHC"
AORD      := {} //-- ORDEM
LCONTINUA := .T.
CUM       := ""
LEND      := .F.
ARETURN   := { "ZEBRADO", 1,"ADMINISTRACAO", 2, 2, 1, "",1 }
NOMEPROG  := "PCPR20A"
NLASTKEY  := 0
CPERG     := "PCPR02"
CMES      := {}
AMSG      := {} 
ANUM      := {}
xItem     := 0
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё VERIFICA AS PERGUNTAS SELECIONADAS                          Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

PERGUNTE(CPERG,.F.)

nAno  := Val(subs(mv_par01,3,4))
AADD(CMES,{"JAN","31","08"})
AADD(CMES,iif(Mod(nAno,4)=0,{"FEV","29","09"},{"FEV","28","09"}))
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

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё VARIAVEIS UTILIZADAS PARA PARAMETROS                        Ё
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё MV_PAR01  C  6   // Periodo Inicial (MMAAAA)                Ё
//Ё MV_PAR02  C  6   // Periodo Final (MMAAAA)                  Ё
//Ё MV_PAR03  N 15   // Do Produto                              Ё
//Ё MV_PAR04  N 15   // Ate o Produto                           Ё
//Ё MV_PAR05  N  1   // Origem (Manaus/Fora do Estado/ImportacaoЁ
//Ё MV_PAR06  N  1   // Do Grupo                                Ё
//Ё MV_PAR07  N  1   // Ate o Grupo                             Ё
//Ё MV_PAR08  N  1   // Considerar Saldo: (Atual/Fechamento)    Ё
//Ё MV_PAR09  N  1   // Do Tipo                                 Ё
//Ё MV_PAR10  N  1   // Ate o Tipo                              Ё
//Ё MV_PAR11  N  1   // Considera Estoque de SeguranГa (S/N)    Ё
//Ё MV_PAR12  N  1   // Considera Material em Transito (S/N)    Ё
//Ё MV_PAR13  N  1   // Considera Apenas Necessidade (S/N)      Ё
//Ё MV_PAR14  N  1   // Quanto ao Idioma (Portugues/InglЙs)     Ё
//Ё MV_PAR15  N  1   // Gera Planilha com as Necessidades (S/N) Ё
//Ё MV_PAR16  N  1   // Gera Solicitacao de Ccompra       (S/N) Ё
//Ё MV_PAR17  N  1   // Considera Pedidos em Atrazo       (S/N) Ё
//Ё MV_PAR18  D  8   // Inicio p/ Pesquisa Ped. Atrazados       Ё
//Ё MV_PAR19  N  1   // Considera Saldo Em Prosseso       (S/N) Ё
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё ENVIA CONTROLE PARA A FUNCAO SETPRINT                       Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

WNREL := "MRPNSSP"
WNREL := SETPRINT(CSTRING,WNREL,CPERG,@TITULO,CDESC1,CDESC2,CDESC3,.F.,,)

IF NLASTKEY==27
	RETURN
ENDIF

SETDEFAULT(ARETURN,CSTRING)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё VARIAVEIS UTILIZADAS PARA IMPRESSAO DO CABECALHO E RODAPE  Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

/*
IF MV_PAR05 == 3
//  MSGSTOP("OPГЦO DE MRP PARA IMPORTAГЦO, EM FASE DE DESENVOLVIMENTO PELO TI.")
//  RETURN
END
*/

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

/*Rmogi 10/02/2007 */
AMSG1:= {"COMPRAS          US$",;
	  	 "SAIDAS ESTRUTURA US$",;
	     "SALDO            US$"}
aTotUS:={}

/**/		
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
//IF ((CMESINI-CMESFIN) < 7 .AND. CANOINI < CANOFIN) .OR.((CMESFIN - CMESINI) >= 6 .AND. CANOINI == CANOFIN)
//   MSGSTOP("PERIODO ESTIPULADO, ULTRAPASA 6 MESES...")
//   RETURN

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
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё DEFINICAO DOS CABECALHOS                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

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
	Processa({|| RptDetail()})
	RptStatus({|| pImprime()})
	Return
	Static Function RptDetail()
#ENDIF

dbSelectArea("SHC")
dbSetOrder(4)
dbSeek(xFilial("SHC") + MV_PAR03 + dtos(cDatIni),.T.)
ProcRegua(RecCount())

While !Eof() .And. HC_Produto <= MV_Par04 .And. lContinua
	
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
	
	If HC_Data < cDatIni .Or. HC_Data > cDatFin
	   dbSkip()
	   Loop
	End 
	
	XPRODUTO := HC_PRODUTO
	XPASSA   := .T.
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+xPRODUTO)
    xOpc := AllTrim(B1_Opc)
    
	dbSelectArea("SHC")
	While !Eof() .And. xProduto == HC_Produto .And. HC_Data <= cDatFin // EM: 12/06/2007
			
		INCPROC("Processando: "+HC_PRODUTO+" Data: "+dtoc(hc_data)) 
	   
		//IF HC_DATA < CDATINI .OR. HC_DATA > CDATFIN
		//	DBSKIP()
		//	LOOP
		//END 
				
		IF HC_NUMPLAN <> "01" // Verifica o Plano p/ Calculo do MRP.
			DBSKIP()
			LOOP
		END
		
	    CPRD    := HC_PRODUTO
		ASTRU   := {}
		NESTRU  := 0
		I       := 0
		dValIni := ctod("01/"+SubStr(dtos(SHC->HC_DATA),5,2)+"/"+SubStr(dtos(SHC->HC_DATA),1,4))
		dValFin := ctod(cMes[month(SHC->HC_DATA)][2]+"/"+SubStr(dtos(SHC->HC_DATA),5,2)+"/"+SubStr(dtos(SHC->HC_DATA),1,4))
		ASTRU   := GetStru(CPRD)  // OBTEM A ESTRUTURA
		For I:=1 To Len(ASTRU)    // MONTA ESTRUTURA DE PRODUTO.
			
			CCOMP  := ASTRU[I,3]
			CQNEC  := 0
			
			dbSelectArea("SG1")  // ESTRUTURA DE PRODUTO
			dbSetOrder(1)
			dbSeek(XFILIAL("SG1")+ASTRU[I,2]+ASTRU[I,3]+ASTRU[I,5])
			
			dbSelectArea("SB1")  // CADASTRO DE PRODUTO
			dbSetOrder(1)
			dbSeek(XFILIAL("SB1")+CCOMP)
			
			If B1_GRUPO < MV_PAR06 .OR. B1_GRUPO > MV_PAR07 .OR.;
			   B1_MRP # "S" .OR. B1_TIPO < MV_PAR09 .OR. B1_TIPO > MV_PAR10 .OR. SG1->G1_FIXVAR<>"V"
			   xPassa := .F.
			End

		    // Jorge: 28/09/07 (Opcionais Padrao: Verifica Saldo dos Opcionais)
		    If !Empty(SG1->G1_GroPc) .And. !(Alltrim(SG1->G1_GroPc)+Alltrim(SG1->G1_Opc) $ xOpc);
		                             .And. Right(Alltrim(SG1->G1_GrOpc),1) == "0"  // Jorge Em: 05/01/2007
			   xPassa := .F.
			End
			// 2008          2006           2009       2006
			IF (dValIni < SG1->G1_INI .Or. dValFin > SG1->G1_FIM)
				xPassa := .F.
			END
			
	//		If ASTRU[I,3] == "053101264900001"
	//		   msgstop(ASTRU[I,2]+" "+ASTRU[I,3]+" Inicio: "+dtoc(SG1->G1_INI)+" Fim: "+dtoc(SG1->G1_FIM) )
	//		End   
			
			cQNec := ASTRU[I,4] * SHC->HC_Quant
			
			If cQnec > 0 .and. xPassa
				nPos := ASCAN(XMRP,{|X| X[1] == CCOMP .AND. MONTH(SHC->HC_DATA) == X[4] })
				If nPos == 0
					aadd(XMRP, {cComp,;			            // 01 COMPONENTE
					            cQNec,;						// 02 QUANTIDADE
					            SHC->HC_DATA,;				// 03 DATA
					            Month(SHC->HC_DATA) })		// 04 MES
				Else
					XMRP[NPOS][02] += CQNEC
				End  
			    nPos := aScan(APDTS,{ |X| X[1] == CCOMP })
			    If nPos==0
					aadd(APDTS,{CCOMP,;                    // Cod. do Componente
					            SG1->G1_GrOpc,;            // Grupo de Opcionais
			                    SG1->G1_Opc,;              // Item Opcional
			                    SG1->G1_Cod,;              // Item Opcional
			                    xOpc })                    // Opcional Default (SB1)
					If mv_par12==1
						SALPED()
					End  
				End  
				
			End
			xPassa := .T.
		Next
		
		dbSelectArea("SHC")
		dbSkip()
		
	EndDo
EndDo

Return

***********************************
Static Function pImprime()         
***********************************

nTipo := Iif(aReturn[4]==1,15,18)
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
//aSort(aPdts)
aSort(aPdts,,,{|x,y| x[1] < y[1]})
SetRegua(Len(aPdts))
I := 1
For I:=1 to Len(aPdts)
	
	IncRegua()
	
	dbSelectArea("SB1")  // CADASTRO DE PRODUTO
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+aPdts[I][1])
	xIndPer := 1 + SB1->B1_INDPER /(100 - SB1->B1_INDPER)  // Jorge: 19/09/06 (Formula fornecida pelo Edy-PCP)
    If MV_PAR11==1
		nInex := B1_PERSEG
	Else
		nInex := 0
	EndIf
	
	xGrOpc  := {}
	xTotOpc := 0
	If mv_par08 == 1   // SALDO ATUAL
	   // Jorge: 28/09/07 (Opcionais Padrao: Verifica Saldo dos Opcionais)
	   If Len(AllTrim(aPdts[I][2]))#0 .And. Alltrim(aPdts[I][2])+Alltrim(aPdts[I][3]) $ aPdts[I][5] //xOpc
		  dbSelectArea("SGA")
		  dbSetOrder(1)
		  dbSeek(xFilial("SGA")+AllTrim(aPdts[I][2]))
		  While !Eof() .And. AllTrim(aPdts[I][2]) == GA_GrOpc
		  
		   	    dbSelectArea("SB2")
	            dbSetOrder(1)
	            dbSeek(xFilial("SB2")+AllTrim(SGA->GA_DescOpc))
	            
	            dbSelectArea("SGA")
	            If aPdts[I][3] # GA_Opc
			       aadd(xGrOpc,{aPdts[I][2],;              // Grupo de Opcionais
			                    GA_Opc,;                   // Item do grupo de Opcionais
			                    AllTrim(GA_DescOpc),;      // Codigo do Produto 
			                    GA_DescGrp,;               // Descricao do Grupo de Opcionais
			                    SB2->B2_qAtu })            // Saldo em Estoque
			       xTotOpc := xTotOpc + SB2->B2_qAtu
			    End
			    dbSkip()              
	      EndDo                   
	   End
	   dbSelectArea("SB2")
	   dbSetOrder(1)
	   If dbSeek(xFilial("SB2")+SB1->B1_COD) //+"01")		
		  nPos := ASCAN(cSaldAnt,B2_COD)
		  aImp[1][1] := iif(nPos<>0,cSaldAnt[ASCAN(cSaldAnt,B2_COD)][2],0)+Iif(SubStr(aPdts[I][2],3,1)=="0",xTotOpc,0)  // Jorge Em: 06.02.2007
		  If nPos <> 0
		     While !Eof() .And. SB1->B1_COD==B2_COD
		           If B2_Local $ If(Mv_Par19==1,"01-10-70-98","01-70-98") // Jorge Em: 20/03/2008
		              aImp[1][1] := aImp[1][1] + B2_QATU
		           End
		           dbSkip()
		     EndDo
		  Else
		     While !Eof() .And. SB1->B1_COD==B2_COD
		           If B2_Local $ If(Mv_Par19==1,"01-10-70-98","01-70-98") // Jorge Em: 20/03/2008
		              aImp[1][1] := aImp[1][1] + B2_QATU
		           End
		           dbSkip()
		     EndDo
		  End
	   Else
		   aImp[1][1] := Iif(SubStr(aPdts[I][2],3,1)=="0",xTotOpc,0)
	   End
	Else  // SALDO MOVIMENTO. 
	   If Len(AllTrim(aPdts[I][2]))#0 .And. Alltrim(aPdts[I][2])+Alltrim(aPdts[I][3]) $ aPdts[I][5] // xOpc
		  dbSelectArea("SGA")
		  dbSetOrder(1)
		  dbSeek(xFilial("SGA")+AllTrim(aPdts[I][2]))
		  While !Eof() .And. AllTrim(aPdts[I][2]) == GA_GrOpc
		  	    dbSelectArea("SB2")
	            dbSetOrder(1)
	            xEst01  := CalcEst(AllTrim(SGA->GA_DescOpc),"01",dDataBase)[1] // Jorge Em: 01.02.2007
	            If Mv_Par19 == 1
	               xEst10  := CalcEst(AllTrim(SGA->GA_DescOpc),"10",dDataBase)[1] // Jorge Em: 20.03.2008
	            Else
	               xEst10  := 0
	            End
	            If SB1->B1_Tipo # "MP"
	               xEst70  := CalcEst(AllTrim(SGA->GA_DescOpc),"70",dDataBase)[1] // Jorge Em: 20.03.2008
	            Else
   	               xEst70  := 0
	            End   
	            xEst98  := CalcEst(AllTrim(SGA->GA_DescOpc),"98",dDataBase)[1] // Jorge Em: 01.02.2007
	            dbSelectArea("SGA")
	            If aPdts[I][3] # GA_Opc
			       aadd(xGrOpc,{aPdts[I][2],;              // Grupo de Opcionais
			                    GA_Opc,;                   // Item do grupo de Opcionais
			                    AllTrim(GA_DescOpc),;      // Codigo do Produto 
			                    GA_DescGrp,;               // Descricao do Grupo de Opcionais
			                    xEst01+xEst98 })           // Saldo em Estoque
			       xTotOpc := xTotOpc + (xEst01+xEst10+xEst70+xEst98)
			    End
			    dbSkip()              
	      EndDo                   
	   End
       dbSelectArea("SB2")
	   dbSetOrder(1)
	   xEst01  := CalcEst(SB1->B1_COD,"01",dDataBase)[1] // Jorge Em: 01.02.2007
	   If Mv_Par19 == 1
	      xEst10  := CalcEst(SB1->B1_COD,"10",dDataBase)[1] // Jorge Em: 20.03.2008
	   Else
	      xEst10  := 0
	   End   
	   If SB1->B1_Tipo # "MP"
	      xEst70  := CalcEst(SB1->B1_COD,"70",dDataBase)[1] // Jorge Em: 20.03.2008
	   Else
	      xEst70  := 0
	   End   
	   xEst98  := CalcEst(SB1->B1_COD,"98",dDataBase)[1] // Jorge Em: 01.02.2007
	   aImp[1][1] := xEst01 + xEst10 + xEst70 + xEst98 + Iif(SubStr(aPdts[I][2],3,1)=="0",xTotOpc,0) // Jorge Em: 06.02.2007
	EndIf
	c_Comp := aPdts[I][1]
	
	For N := 1 TO xQuant // (Total de meses a serem impressos)
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
	For N := 1 to xQuant // (Total de meses a serem impressos)
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
		nImp3 := nPrev  // Iif(nPrev<>0,nPrev,Iif(N<xQuant,AIMP[N+1][3],0))
	    aImp[N][5] := Iif(nImp3-aImp[N][4]<=0,0,(nImp3-aImp[N][4]) + AcrPer[N] ) // * xIndPer )  // Jorge: 19/09/06
	    If SB1->B1_LE > 0
	       aImp[N][5] := Iif(Mod(aImp[N][5],SB1->B1_LE)==0,aImp[N][5],INT((aImp[N][5]/SB1->B1_LE)+1)*SB1->B1_LE)   // Jorge: 19/09/06
	    End
		nTNec += aImp[N][5]
		
		If N < xQuant
			aImp[N+1][1]  := aImp[N][4] + aImp[N][5]
		EndIf
	Next
	If nTNec==0 .and. mv_par13==1
		Loop
	EndIf
	
	If MV_Par15==1 // Gera Planinha somente com as necessidades.
	   
	   @ LI,000      PSAY aPdts[I][1]        			 			     	// COMPONENTE
	   if mv_par14==1
	      @ LI,PCOL()+2 PSAY SubStr(SB1->B1_DESC,1,40)			     	// DESCRICAO PORTUGUES
	   Else
	      @ LI,PCOL()+2 PSAY SubStr(SB1->B1_DESC_EN,1,40)			   	// DESCRICAO INGLES
	   End
	   xTotNec := 0
	   //xSeqItem:= 1 
   	   _undMed:= subs(Posicione("SB1",1,xFilial("SB1")+aPdts[I][1],"B1_UM"),1,2)  
       xCol:=PCOL()  
       
	   For M:=1 to xQuant
//		   @ LI,PCOL()+2 PSAY IIF(AllTrim(_undMed)$"KG/L/",Transform(aImp[M][5],"@E 99,999.999"),Transform(aImp[M][5],"@E 99,999,999"))
           @ LI,PCOL()+2 PSAY Transform(aImp[M][5],"9999999999")
		   tmNeces[M] := tmNeces[M] + aImp[M][5]   
		   xTotNec := xTotNec + aImp[M][5]		 
	   Next
	   
//	   @ LI,PCOL()+2 PSAY IIF(AllTrim(_undMed)$"KG/L/",Transform(xTotNec,"@E 99,999,999.999"),Transform(xTotNec,"@E 99,999,999,999"))
       @ LI,PCOL()+2 PSAY Transform(xTotNec,"@E 9999999999999")
       li++                                               
       
       If Li > 60
		  Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   EndIf
	Else
  	   @ LI,000      PSAY "PRODUTO: " + aPdts[I][1]        			 				// COMPONENTE
	   @ LI,PCOL()+3 PSAY SubStr(SB1->B1_DESC,1,40)				    				// DESCRICAO PORTUGUES
	   if mv_par14==2
	      @ LI,PCOL()+3 PSAY SubStr(SB1->B1_DESC_EN,1,30)			           		// DESCRICAO INGLES
	   end
	   
	   cPos:=ascan(cSaldAnt,{|X| X[1] == aPdts[I][1]})
	   
	   @ LI,PCOL()+3 PSAY "UM: "       + SB1->B1_UM 								// UM
	   @ LI,PCOL()+3 PSAY "TIPO: "     + SB1->B1_TIPO 		    					// TIPO
	   @ LI,PCOL()+3 PSAY "GRUPO: "    + SubStr(SB1->B1_GRUPO,1,3)					// GRUPO
	   @ LI,PCOL()+3 PSAY "SEGURANгA:" + Transform(nInex         , "@e 99.99")	 	// ESTOQUE SEGURANгA
       @ LI,PCOL()+3 PSAY "IND.PERDA:" + Transform(SB1->B1_INDPER, "@e 99.99%")	 	// INDICE DE PERDA
       @ LI,PCOL()+3 PSAY "LOTE ECONOM:" + Transform(SB1->B1_LE,"@e 999,999")	    // LOTE ECONOMICO
       IF cSaldAnt[cPos][2] > 0  
          @ LI,PCOL()+3 PSAY "PED. ATRAZO:" + Transform(cSaldAnt[cPos][2],"@e 999,999")// Saldos de Compras
       End
	   Li+=2
       _undMed:= subs(Posicione("SB1",1,xFilial("SB1")+aPdts[I][1],"B1_UM"),1,2)  	   	                 	                 
	   
	   IF Mv_Par15 == 3 // Resumo das necessidades na Moeda Estrangeira.
          A :=0                                                                    
          xPrPro := U_QuanProd(aPdts[I][1]) /*captura o proco do produto de acordo com a tabela 001*/       
          For N:=5 to 1 step -1 
	          For M:=1 to xQuant
	              If M==1  .And. (N==5 .or. N==3  .or. N==1) 
	                 Do case 
	                    case N == 5
	                      A:=1
	                    case N == 3
	                      A:=2
	                    case N == 1  
	                      A:=3
	                 End case
			         @ LI,000  PSAY aMsg1[A]
			      End	       	   
		          /*TESTE PARA O PLANEJAMENTO DE DO MPI*/                      
	              If N==5 .Or. N==3  .Or. N==1 	                 
	                 If N==1 
	                    xSaldo := (aImp[M][1]+aImp[M][5]+aImp[M][2])-aImp[M][3]  
                        xSaldo *= xPrPro
                        @ LI,PCOL()+2 PSAY Transform(xSaldo,"@E 999,999,999.99")
                     ElseIf N==5
                        xPreco:=(aImp[M][5]+aImp[M][2])*xPrPro     
		                @ LI,PCOL()+2 PSAY Transform(xPreco,"@E 999,999,999.99")                  
                     Else                     
                        xPreco:=aImp[M][N]*xPrPro     
		                @ LI,PCOL()+2 PSAY Transform(xPreco,"@E 999,999,999.99")
		                //tmNeces[M] := tmNeces[M] + aImp[M][5]
		                //xTotNec := xTotNec + aImp[M][5]
		             End		     
		          
		             nPos := aScan(aTotUS,{|X| M == X[4] })	              
	                 If nPos == 0
		                aAdd(aTotUS,{  xPreco,;						// 01 QTD COMPRA 
		                               0.0,;						// 02 QTD SAIDA
		                               0.0,;						// 03 QTD SALDO
		                                 M})						// 04 MES
	                 Else
	                    Do Case 
	                       Case N==5
	                          aTotUS[nPos][1]+=xPreco   			     	// 01 QTD COMPRA                 
	                       Case N==3
	                          aTotUS[nPos][2]+=xPreco   		        	// 02 QTD SAIDA                   
	                       Case N==1
 		                      aTotUS[nPos][3]+=xSaldo	   			    	// 03 QTD SALDO                 
	                    EndCase		                          
	                 EndIf
                  Else
                     Exit
                  End               
                  xPreco := 0.0
                  xSaldo := 0.0
                  /*TESTE PARA O PLANEJAMENTO DE DO MPI*/   
	          Next
              If N==5 .or. N==3 .or. N==1
                 li++
                 //@ LI,xCol PSAY ""
              End
          Next       	   
	      @ LI,000 PSAY Replicate("-",Limite)
	      Li += 1
	      If Li > 65
		     Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      EndIf
	   Else // Mv_Par15 == 2
	      For N:=1 to 5
		      For M:=1 to xQuant
		          If M==1
			         @ LI,000  PSAY aMsg[N]
			      End
		   	      @ LI,PCOL()+2 PSAY IIF(AllTrim(_undMed)$"KG/L/",Transform(aImp[M][N],"@E 99,999,999.999"),Transform(aImp[M][N],"@E 99,999,999,999"))
		   	      IF N==5 .And. M == 5 .And. mv_par16 == 1 .And. aImp[M][N] > 0 // Jorge Em: 05/09/07
		   	         xItem += 1
		             U_gerSolCompNsSP(M,aImp[M][N],aPdts[I][1],xItem) // Jorge Em: 05/09/07
                  End
		      Next
		      li++
	      Next
	      //------------------------------------------//
	      // Demonstrativo do Grupo de Opcionais.     //
	      //------------------------------------------//
	      If Len(xGrOpc) > 0
	        @ li, 000 PSAY ">>> LISTA DOS ITENS OPCIONAIS: "
	        Li += 1
	        @ li, 000 PSAY "Gru  Item  Produto          UM DescriГЦo                       Sld.Estoque            Total"
	        Li += 1
	        @ LI,000 PSAY Replicate("-",92)
	        Li += 1
	        For xI:=1 to Len(xGrOpc)
	            @ li, 000      PSAY xGrOpc[xI][1]             // Grupo de Opcionais
			    @ li, PCol()+2 PSAY xGrOpc[xI][2]             // Item do grupo de Opcionais
			    @ li, PCol()+2 PSAY xGrOpc[xI][3]             // Codigo do Produto 
			    @ li, PCol()+2 PSAY xGrOpc[xI][4]             // Descricao do Grupo de Opcionais
			    @ li, PCol()+2 PSAY IIF(AllTrim(_undMed)$"KG/L/",Transform(xGrOpc[xI][5],"@E 99,999,999.999"),Transform(xGrOpc[xI][5],"@E 99,999,999,999")) // Saldo em Estoque
			    If xI == Len(xGrOpc)
			       @ li, PCol()+2 PSAY  IIF(AllTrim(_undMed)$"KG/L/",Transform(xTotOpc,"@E 999,999,999.999"),Transform(xTotOpc,"@E 999,999,999,999"))
			    End
                Li += 1
            Next
	      End
	     
	      @ LI,000 PSAY Replicate("-",Limite)
	      Li += 1
	   
	      If Li > 58
		    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      EndIf
	   End
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
Elseif MV_Par15==3   //aTotUS:={}
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
      msgstop("Produto nЦo gerou necessidade")
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
Static Function SalPed()
************************************

dbSelectArea('SC7')
dbSetOrder(7)
xSaldAnt := 0
dbSeek(xFilial('SC7') + cComp + dtos(mv_par18),.T.)
While !Eof() .And. cComp == C7_Produto .And. C7_DatPrf < cDatIni   // Jorge Em: 05/05/08
      If Mv_par17 == 1
         xSaldAnt += (C7_QUANT - C7_QUJE)
      End   
      dbSkip()
EndDo
aadd(cSaldAnt,{cComp,xSaldAnt})

xSalped := 0
xSaida  := 0

While !Eof() .And. cComp == C7_PRODUTO .and. C7_DATPRF <= cDatFin

	xMesComp := MONTH(C7_DATPRF)
    xCompMes := 0
	While !Eof() .and. cComp == C7_PRODUTO .and. C7_DATPRF <= cDatFin .and. xMesComp == Month(C7_DATPRF)
		
		xCompMes += (C7_QUANT - C7_QUJE)
//		xSalped  += (C7_QUANT - C7_QUJE)
		
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

/*
************************
STATIC FUNCTION RECEBE()
************************

XDATFIN := CTOD("01"+"/"+STRZERO(MONTH(CDATINI),2)+"/"+STRZERO(CANOINI,4))
DBSELECTAREA('SD1')
DBSETORDER(7)
DBSEEK(XFILIAL('SD1')+XCOMP+'01'+DTOS(XDATFIN),.T.)
XSAIDA := 0

WHILE !EOF() .AND. XCOMP == D1_COD .AND. D1_DTDIGIT <= DDATABASE
XSAIDA  := XSAIDA  + D1_QUANT
DBSKIP()
ENDDO

RETURN(XSAIDA)

Static Function sStrut(cPa,nQtd,cCond)
IF SG1->G1_COD+SG1->G1_COMP+SG1->G1_TRT==cCond
Return(nQtd)
EndIf
DBSELECTAREA("SG1")  // ESTRUTURA DE PRODUTO
DBSETORDER(1)
If DBSEEK(XFILIAL("SG1")+cPa)
If SG1->G1_COD+SG1->G1_COMP==Left(cCond,30)
Return(nQtd)
EndIf
nQtd *= G1_QUANT
While cPa  == G1_COD
If G1_COD+G1_COMP+G1_TRT<>cCond
nQtd := sStrut(G1_COMP,nQtd,cCond)
Else
Exit
EndIf
dbSkip()
EndDo
Else
nQtd := SHC->HC_QUANT
EndIf
Return(nQtd)
*/

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

/*
USER FUNCTION geraSolCompra(mesRef,mesPrev,Prod)   

     MSGSTOP(Prod+" Mes Ref.: "+STRZERO(mesRef,2)+" / Mes.Prev.: "+STRZERO(mesPrev,2))
  
     If mesRef < month(dDatabase) // Rmogi - 13/06/07
        Return
     End  
     
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
	 
	    IF (mesRef+4) < mesPrev
	       If aImp[mesRef+4][5] > 0  
	       
              dDatPrf    := "01"+"/"+ALLTRIM(STRZERO(mesRef+4,2))+"/"+ALLTRIM(STR(YEAR(DDATABASE),4))                              
              dDatPrf    := CTOD(dDatPrf)
              dDatEms    := "01"+"/"+ALLTRIM(STRZERO(mesRef,2))+"/"+ALLTRIM(STR(YEAR(DDATABASE),4))                 
              dDatEms    := CTOD(dDatEms)
              RecLock("SC1",.T.)               
                 SC1->C1_Filial  := xFilial("SC1") 
                 SC1->C1_NUM     := _nextNum  
                 SC1->C1_ITEM    := strzero(item,4) 
                 SC1->C1_PRODUTO := Prod 
                 SC1->C1_UM      := SUBS(AllTrim(Posicione("SB1",1,xFilial("SB1")+Prod,"B1_UM")),1,2)    
                 SC1->C1_QUANT   := aImp[mesRef+4][5] 
                 SC1->C1_DATPRF  := dDatPrf
                 SC1->C1_LOCAL   := SUBS(AllTrim(Posicione("SB1",1,xFilial("SB1")+Prod,"B1_LOCPAD")),1,2)    
                 //SC1->C1_OBS     := "GERACAO AUTO. SOL. COMPRAS" 
                 SC1->C1_CC      := SUBS(AllTrim(Posicione("SB1",1,xFilial("SB1")+Prod,"B1_CC")),1,3)    
                 SC1->C1_EMISSAO := dDatEms 
                 SC1->C1_DESCRI  := SUBS(AllTrim(Posicione("SB1",1,xFilial("SB1")+Prod,"B1_DESC_EN")),1,30)    
                 SC1->C1_SOLICIT := SUBSTR(CUSUARIO,7,15)
                 SC1->C1_ORIGEM  := "MPR" + STRZERO(mesRef,2)                     
         SC1->(MsUnlock())
              IIF(nPos==0,ANUM[mesRef][4]+=1,ANUM[nPos][4]+=1)       
		   End
	    End
 	 END
Return */ 

USER FUNCTION GerSolCompNSSP(mesRef,xNecess,Prod,cItem)   

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
                 SC1->C1_ITEM    := strzero(cItem,4) 
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
		         SC1->(MsUnlock())
     //   IIF(nPos==0,ANUM[mesRef][4]+=1,ANUM[nPos][4]+=1)       
	 END
Return 
     
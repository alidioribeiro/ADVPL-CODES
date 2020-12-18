#include "rwmake.ch"
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Matr29LM()

SetPrvt("CBTXT,CBCONT,CABEC1,CABEC2,WNREL,TITULO")
SetPrvt("CDESC1,CDESC2,CDESC3,TAMANHO,LIMITE,CSTRING")
SetPrvt("AORD,LCONTINUA,CUM,LEND,ARETURN,NOMEPROG")
SetPrvt("NLASTKEY,CPERG,LI,M_PAG,NTIPO,CARQNTX")
SetPrvt("dDatRef1,dDatRef2")
SetPrvt("xPerdas")
SetPrvt("aPerdas") 
SetPrvt("nDevo,xPerdas") 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MATR29LM_AP8ºAutor  ³Microsiga           º Data ³  05/18/06 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio Gerencial de Produçao da Linha de Montagem       º±±
±±º          ³ Apresentando o PPM(Perda da Produção por Milhão            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo    := "Relatorio Gerencial de Producao"
cDesc1    := "Este programa tem com objetivo, imprimir o Indicador de PPM no Processo NSB,"
cDesc2    := "Linha de Producao, no periodo especificado."
cDesc3    := ""
tamanho   := "G"
limite    := 220
cString   := "SD3"
aOrd      := {"Sintetico Geral(Por Pecurso)","Analitico","Anal.-Ind.Ñ Conf.","Sintetico PA"} //{"Recurso","C.de Custo","Produto"} //-- Ordem
lContinua := .T.
cUM       := ""
lEnd      := .F.
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "Matr29LM"
nLastKey  := 0
cPerg     := "MATR21"
xPerdas   := {}
aPerdas   := {}
aOP       := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

pergunte("MATR21",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01             // Do Recurso                          ³
//³ mv_par02             // Ate o Recurso                       ³
//³ mv_par03             // Da Data                             ³
//³ mv_par04             // Ate a Data                          ³
//³ mv_par05             // Do C.de Custo                       ³
//³ mv_par06             // Ate o C.de Custo                    ³
//³ mv_par07             // Do Produto                          ³
//³ mv_par08             // Ate o Produto                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel  := "Matr29LM"
wnrel  := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,)

If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem := aReturn[8]
cbtxt  := Space(10)
cbcont := 00
li     := 80
m_pag  := 01


cabec2 := "De "+dtoc(mv_par03)+" a "+dtoc(mv_par04)+" "
titulo := "Indicador de PPM no Processo NSB. (Por Recurso)"
cabec1 := "Produto         Modelo    Estr  Produc Produc X      Per Motivo de Perda      Quant Ind.   PPM   %       Custo Ind.    "
cabec2 += 						"     (E) Real(P)   Estr(P*E)    da                            Perd         PPM           Prod.  "
//         999999999999999 XXXXXXXXXX 999 999.999 999.999.999 9.999 XXXXXXXXXXXXXXXXXXXX 9,999 9,99 9.999 9,999 9.999,99 999.99 
//         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//                   1111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222222223333333333

If nLastKey == 27
	Return
Endif

nTipo  := IIF(aReturn[4]==1,15,18)

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)

#IFDEF WINDOWS
	Processa( {|| ExeMatr29LM()})
	RptStatus({|| DetMatr29LM()})
	Return
#ENDIF

Static Function ExeMatr29LM()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nAno     := Year(mv_par04)
aMes     := {}
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

cbtxt    := Space(10)
cbcont   := 00 
xPassa   :=.F.

dDatRef1 := mv_par03    ///ctod("01/"+substr(dtos(mv_par03),5,2)+"/"+substr(dtos(mv_par03),1,4))
dDatRef2 := mv_par04    ///ctod(aMes[Month(mv_par04)][2]+"/"+substr(dtos(mv_par04),5,2)+"/"+substr(dtos(mv_par04),1,4))

dbSelectArea("SD3")
cArqSD3  := CriaTrab(NIL,.F. )

cKeySD3  := "D3_Filial+D3_Recurso+D3_Cod+DTOS(D3_Emissao)" // IndexKey()

cFilSD3  := "D3_FILIAL='"+xFilial("SD3")+"'.And.D3_RECURSO>='"+MV_PAR01+"'.And.D3_RECURSO<='"+MV_PAR02+"' "
cFilSD3  += ".And.DTOS(D3_EMISSAO)>='"+DTOS(MV_PAR03)+"'.And.DTOS(D3_EMISSAO)<='"+DTOS(MV_PAR04)+"' " 
cFilSD3  += ".And.D3_CC>='"+MV_PAR05+"'.And. D3_CC<='"+MV_PAR06+"' "
cFilSD3  += ".And.D3_TM=='400' .AND. D3_ESTORNO <> 'S' "
//teste aglair
cFilSD3  += " .And. D3_COD>='"+mv_par07+"' .and. D3_COD<='"+mv_par08+"' " 
/*fim teste aglair */
IndRegua("SD3",cArqSD3,cKeySD3,,cFilSD3,"Selecionando Registros...")
dbSelectArea("SD3")

ProcRegua(RecCount())
dbGoTop()

While !Eof() .And. D3_Recurso<=mv_par02 .And. xFilial()==D3_FILIAL .And. lContinua
	
	IncProc()
	
	#IFNDEF WINDOWS
		If LastKey() == 286
			lEnd := .t.
		End
	#ENDIF
	
	If lEnd
		@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	Endif
	
	If D3_Emissao < mv_par03 .or. D3_Emissao > mv_par04
		IncProc()
		dbSkip()
		Loop
	End
	
	dbSelectArea("SH1")// Recursos
	dbSetOrder(1)
	dbSeek(xFilial("SH1")+SD3->D3_Recurso)
	
	dbSelectArea("SB1")//produtos
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+SD3->D3_Cod)
	Astec:=Right(Alltrim(SB1->B1_COD),1)
		
	If nOrdem==4  .and.  Astec == "Z"              
	   dbSelectArea("SD3")
	   dbSkip()
	   loop
	End	
	dbSelectArea("SI3")//Centro de Custo
	dbSetOrder(1)
	dbSeek(xFilial("SI3")+SD3->D3_CC)
	
	dbSelectArea("SC2")//Ordem de Produção
	dbSetOrder(1)
	dbSeek(xFilial("SC2")+SD3->D3_OP)
	
	dbSelectArea("SD3")
	
	If D3_CC < mv_par05 .or. D3_CC > mv_par06 .Or.;
	   D3_Cod < mv_par07 .or. D3_Cod > mv_par08
		dbSkip()
		Loop
	End
	
	aadd(xPerdas,  {D3_Recurso,;                          //  1
					D3_Emissao,;                          //  2
					SubStr(D3_CC,1,6),;                   //  3   8
					SB1->B1_Modelo,;                      //  4   3
					D3_Cod,;                              //  5   6
					SubStr(SB1->B1_Desc,1,30),;           //  6   7
					D3_Quant,;                            //  7  10
					D3_Custo1,;                           //  8  11
					D3_Doc,;                              //  9   4
					D3_Op,;                               // 10   5
					SubStr(SI3->I3_DESC,1,20) })          // 11   9
	
	nPosOP := aScan(aOP,{|x| x[1]==D3_Op })
	
	If nPosOP == 0
		aadd(aOP,     {D3_Op,; // 1 - OP
		              D3_Cod,; // 2 - PRODUTO
		      SB1->B1_Modelo}) // 3 -
	Endif			         	 
	
	dbSkip()
	
Enddo
//Alimenta o vetor de perdas
For i:=1 to len(aOP)
    setQtdPerdas(aOP[i][1])
Next

dbSelectArea("SD3")
Set Filter To

RetIndex('SD3')

If !(Type('ArqNtx') == 'U')
	fErase(cArqNtx)
Endif


Return


Static Function DetMatr29LM()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Impressao                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SD3")//Mov. Interna
dbSetOrder(1)
dbSelectArea("SC2")//Ordem de Produção 
dbSetOrder(1)
dbSelectArea("SB1")//Produto
dbSetOrder(1)
dbSelectArea("SG1")//Estrutura
dbSetOrder(1)

cFilial := xFilial("SB1")

//Recurso + Modelo + Produto
aSort(xPerdas,,,{|x,y| x[1]+x[4]+x[5] < y[1]+y[4]+y[5] })

SetRegua(Len(xPerdas))

xSeq    := 1
xDescri := "" 
xPassa:=.F. 

totGePerda:=0
totGeProd :=0	    
totGePE   :=0
totGePPM  :=0  
totGeCusto:=0

While xSeq <= Len(xPerdas)
    totPerda:=0
    totPE   :=0
    totProd :=0   
    totPPM  :=0  
    totCusto:=0
	    
	xRecurso := xPerdas[xSeq][1]
	dbSelectArea("SH1")//Recurso
	dbSetOrder(1)
	dbSeek(xFilial("SH1")+xPerdas[xSeq][1])
	xDescri := H1_Descri
	@ li,000      PSAY "Recurso: "+xRecurso
	@ li,pCol()+2 PSAY xDescri
	
	li +=2
	
    //Percorre os Recursos
	While xSeq <= Len(xPerdas) .And. xRecurso==xPerdas[xSeq][1]
		xProdMod:=xPerdas[xSeq][4]
		xProduto:=xPerdas[xSeq][5]
		xProdDes:=xPerdas[xSeq][6]
		
		dbSelectArea("SB1")
		dbSeek(cFilial+xProduto)
	    //Produção total
	    xProduc  :=0
	    
	    xPerda   :=0 
	    xCustoP  :=0
	    nPerd    :=0 
	    arPerda  :={}	    
	    aIndNConf:={}
  
	    nQtdEstr:= getQtdEstr (xProduto)
	    arPerda := getQtdPerda(xRecurso,xProdMod,xProduto)
        For i:=1 to len(arPerda)
            nPerd+=arPerda[i][4]         
        Next	      
	      If nOrdem==2 .or. nOrdem==3 
	         getIMPIndNConforme(nPerd)
	      End   
	    //Percorre o produto
	    While xSeq <= Len(xPerdas) .And. xProdMod==xPerdas[xSeq][4]	.And.xProduto==xPerdas[xSeq][5] .and. xRecurso==xPerdas[xSeq][1]		  // xRecurso==xPerdas[xSeq][1]Condição incluida pelaoa aglair    
		      
		      nQtdProd:=xPerdas[xSeq][7]
		      xOP     :=xPerdas[xSeq][10]
		      
		      xProduc+=nQtdProd 
	          xSeq++
	    Enddo	     
	        
        //For i:=1 to len(arPerda)
        //    nPerd+=arPerda[i][4]         
        //Next
        If li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		End
		@ li,000      PSAY xProduto           								// Codigo do Produto     
        @ li,PCOL()+1 PSAY SUBS(xProdMod,1,10)	                            // Modelo do Produto          		
		@ li,PCOL()+1 PSAY Transform(nQtdEstr             ,"@E 999")	    // Qtd de Componentes 
        @ li,PCOL()+1 PSAY Transform(xProduc              ,"@E 999,999")    // Qtd Produzida
        ProdEstr := xProduc*nQtdEstr		
        @ li,PCOL()+1 PSAY Transform(ProdEstr             ,"@E 999,999,999")// Prod X Estrutura		        
        @ li,PCOL()+1 PSAY Transform(nPerd                ,"@E 9,999")      // Perdas		        
        //Ordenando -> Recurso + Codigo do Produto + Qtd      
                             //+ Modelo
        aSort(arPerda,,,{|x,y| x[6]+x[5]+StrZero(x[4],4) > y[6]+y[5]+StrZero(y[4],4) })                		
		nPos := PCOL()
		If Len(arPerda)>=1	.and. xProdMod==arPerda[1][5]    ///.and. xRecurso==xPerdas[xSeq][1] cond. incluida pela Aglair
			@ li,nPos  +1 PSAY arPerda[1][2]                            	// Motivo Perda
			@ li,PCOL()+1 PSAY SubStr(arPerda[1][3],1,20)               	// Descriçao Perda
			@ li,PCOL()+1 PSAY Transform(arPerda[1][4]       ,"@E 999")	    // Quantidade Perda
			@ li,PCOL()+1 PSAY Transform(arPerda[1][4]/nPerd ,"@E 9.99" )	// Indice Perda
			//@ li,PCOL()+1 PSAY aPerdas[1][1]
		    xPassa:=.T.
		EndIf		
		xPPM :=0
		xPPM := nPerd/ProdEstr
		xPPM := xPPM*1000000
                
		@ li,iif(!xPassa,090,PCOL()+1) PSAY Transform(xPPM ,"@E 9,999")	    // PPM
		@ li,PCOL()+1 PSAY Transform(xPPM/10000            ,"@E 9.999")	    // %		
		@ li,PCOL()+1 PSAY Transform(xCustoP               ,"@E 9,999.99")	// Producao Acumulada
						
	    totProd +=xProduc
		totPE   +=ProdEstr
		totPerda+=nPerd		
		totCusto+=xCustoP
		For i:=2 to 3
			If i==2
				Li++
				@ li,000  PSAY SubStr(xProdDes,01,15)					// Descricao do Produto
			Else
				Li++
				@ li,000  PSAY SubStr(xProdDes,16,30)					// Descricao do Produto
			EndIf
			If i<=Len(arPerda) .and. xProdMod==arPerda[i][5] .and. xPassa  //.and. xRecurso==xPerdas[xSeq][1] //.and. xRecurso==xPerdas[xSeq][1] Incluida pela Aglair 
				@ li,nPos  +1 PSAY arPerda[i][2]							// Motivo Perda
				@ li,PCOL()+1 PSAY SubStr(arPerda[i][3],1,20)				// Descriçao Perda
				@ li,PCOL()+1 PSAY Transform(arPerda[i][4]      ,"@E 999")  // Quantidade Perda
				@ li,PCOL()+1 PSAY Transform(arPerda[i][4]/nPerd,"@E 9.99") // Indice Perda
				//@ li,PCOL()+1 PSAY aPerdas[i][1]				
			EndIf                               
			//xPassa:=.F.
			//If i<=Len(aHopar)
			//	@ li,nPos2 +1 PSAY aHopar[i][3]								// Codigo Horas paradas
			//	@ li,PCOL()+1 PSAY SubStr(aHopar[i][4],1,20)				// Motivo Horas paradas
			//	@ li,PCOL()+1 PSAY Transform(aHopar[i][5]      ,"@E 99.99")	// Quantidade Perda
			//	@ li,PCOL()+1 PSAY Transform(aHopar[i][5]/nHopar,"@E 9.99")	// Indice Perda
			//EndIf
		Next
		xPassa:=.F.
		@ li,000 PSAY replicate("_",Limite)
		li+=2
		
		If li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		End
		
		If xSeq  > Len(xPerdas)
			exit
		End
		//@ li,000 PSAY replicate("-",Limite)
	EndDo 
	
	totPPM := totPerda/totPE
	totRPPM := totPPM*1000000
        
	totGeProd +=totProd
	totGePE   +=totPE
	totGePerda+=totPerda     
    totGeCusto+=totCusto
    
    //li++
    @ li,000      PSAY "T O T A L    " +  xRecurso
    //@ li,027      PSAY "   "
	@ li,031      PSAY Transform(totProd      ,"@E 999,999"    )
	@ li,PCOL()+1 PSAY Transform(totPE        ,"@E 999,999,999")
    @ li,PCOL()+1 PSAY Transform(totPerda     ,"@E 9,999")	
	@ li,090      PSAY Transform(totRPPM      ,"@E 9,999")	    // PPM
	@ li,PCOL()+1 PSAY Transform(totRPPM/10000,"@E 9.999")	    // %		
	@ li,PCOL()+1 PSAY Transform(totCusto     ,"@E 9,999.99")	// Custo	
	li ++
	@ li,000 PSAY Replicate("-",Limite)
	li ++

EndDo
 

totGePPM  := totGePerda/totGePE
totRGePPM := totGePPM*1000000 

    //li++
    @ li,000      PSAY "T O T A L    G E R A L"  
    //@ li,027      PSAY Transform(totGeEstr     ,"@E 999"        )
	@ li,031      PSAY Transform(totGeProd      ,"@E 999,999"    )
	@ li,PCOL()+1 PSAY Transform(totGePE        ,"@E 999,999,999")
    @ li,PCOL()+1 PSAY Transform(totGePerda     ,"@E 9,999")	
	@ li,090      PSAY Transform(totRGePPM      ,"@E 9,999")	    // PPM
	@ li,PCOL()+1 PSAY Transform(totRGePPM/10000,"@E 9.999")	    // %		
	@ li,PCOL()+1 PSAY Transform(totGeCusto     ,"@E 9,999.99")	// Custo	
	li ++
	@ li,000 PSAY Replicate("-",Limite)
	li ++
IF li != 80
	roda(cbcont,cbtxt,tamanho)
EndIf

Set Device To Screen

If aReturn[5] == 1
	Set Printer to
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return

//-----------------------------------------------------------
//        FUNÇÕES DE APOIO AO PROGRAMA PRINCIPAL
//-----------------------------------------------------------


/****
* FUNÇÃO RETORNA A QUANTIDADE DE COMPONENTES UM DETERMINADO PRODUTO, APENAS PARA AS PEÇAS CONTAVEIS
* @PARAMETER ->  STRING cProduto PRODUTO
* @RETURN    ->  INTEGER         QUANTIDADE QUE UM DETERNINADO PRODUTO USA NA SUA ESTRUTURA.
*****/
Static Function GetQtdEstr(cProduto)
	    
	    dbSelectArea("SG1") 
		dbSetOrder(1)
	
		dbSeek(xFilial("SG1")+cProduto)
		
		cComp    := ""                         
		nQtdComp := 0
		While !Eof() .and. G1_COD == cProduto 
			  If dDataBase >= SG1->G1_INI .and. dDataBase <= SG1->G1_FIM    
		      	 If G1_QUANT >= 1
		            nQtdComp += G1_QUANT
		         EndIf
		      ENDIF
		      dbSkip()      		
		EndDo
Return nQtdComp

/****
* FUNÇÃO ALIMENTA O VETOR DE PERDAS PARA CADA OP
* @PARAMETER ->  STRING cOP
* 
*****/

Static Function setQtdPerdas(cOP)
	    
dbSelectArea("SBC")//Perdas por OP 
dbSetOrder(1)
dbSeek(xFilial("SBC")+cOP)

While !Eof() .and. cOP==BC_OP

	//dbSelectArea("SC2")//Ordem de produção
	//dbSetOrder(1)
	//dbSeek(xFilial("SC2")+SBC->BC_OP)
		
	dbSelectArea("SB1")//Produto
	dbSeek(xFilial("SB1")+SBC->BC_PRODUTO)
	
    xComp   :=SBC->BC_PRODUTO
    xModelo := B1_MODELO
        	
	dbSelectArea("SBC")

	If BC_APLIC < mv_par05 .Or. BC_APLIC > mv_par06
		dbSkip()
		Loop
	end

        	
	dbSelectArea("SBC")
    /*Incluso pela Aglair para filtrar apenas as perdas do período***/
	If BC_DTRM < mv_par03 .Or. BC_DTRM > mv_par04
		dbSkip()
		Loop
	end
	
	
	
	If BC_RECURSO < mv_par01 .Or. BC_RECURSO > mv_par02
		dbSkip()
		Loop
	end
	
	If BC_MOTIVO == "119"
		dbSkip()
		Loop
	end
	     
	If BC_TIPO # "S"
	   dbSkip()
	   loop
	EndIf
		
    dbSelectArea("SZC")//Motivos de perdas 
    dbSetOrder(1)
    dbSeek(xFilial("SZC")+SBC->BC_MOTIVO)
    
    cDescMot:=ZC_TIPODEF
    
    dbSelectArea("SBC")     

	aadd(aPerdas,   {BC_PRODUTO,;       //1 - PRODUTO
	                  BC_MOTIVO,;       //2 - MOTIVO
                       cDescMot,;       //3 - DESCRIÇÃO DO MOT.
	                   BC_QUANT,;       //4 - QUANTIDADE PERD.
	                    xModelo,;       //5 - Modelo
	                 BC_RECURSO,;       //6 - RECURSO 
	                        cOP,;       //7 - OP	                      
	             SBC->BC_SEQSD3,;       //8 - Seguencia D3
	                SBC->BC_OBS,;       //9 - Observação para motivo 99
	              SBC->BC_APLIC})       //10- C.Custo que ocorreu a falha
	dbSkip()
EndDo
Return 


/****
* FUNÇÃO OBTEM AS PERDAS DE UMA DETERNINADA MODELO
* @PARAMETER ->  STRING cModelo,STRING cRecur 
* @RETURN    ->  VECTOR PERDAS DO PRODUTO NA OP.
*****/
Static Function getQtdPerda(cRecur,cModelo,cProd)
fCusto  :=0 
fPerda  :={}
impDbug :=.T.
//Recurso + modelo + op + motivo + qtd
aSort(aPerdas,,,{|x,y| x[6]+x[5]+x[7]+x[2]+STRZERO(x[4],2) > y[6]+y[5]+y[7]+y[2]+STRZERO(y[4],2) })
For i:=1 to len(aPerdas)  
    fComp   :=aPerdas[i][1]
    fRecurso:=aPerdas[i][6]
    fModelo :=aPerdas[i][5]
    
    fQtd    :=aPerdas[i][4]
    fOP     :=aPerdas[i][7]
        
    nPos   := aScan(aOP,{|x| x[1]==fOP})
    xModelo:= aOP[nPos][3]
    fProd  := aOP[nPos][2] 
    
	dbSelectArea("SH1")//Recurso
	dbSetOrder(1)
	dbSeek(xFilial("SH1")+ fRecurso)
	
	cCC := aPerdas[i][10]
	fCC := H1_CCUSTO
   
    if alltrim(cProd) # alltrim(fProd)
       loop
    End    
    if alltrim(cRecur) # alltrim(fRecurso)
       loop
    End

    if alltrim(cCC) # alltrim(fCC)
       loop
    End    
    
    dbSelectArea("SG1") 
	dbSetOrder(2)	
	dbSeek(xFilial("SG1")+fComp)
    fProcesso:=G1_LOCPRO
    
    dbSelectArea("SB1") 
	dbSetOrder(1)	
	dbSeek(xFilial("SB1")+fComp)
    fDesComp:=B1_DESC
    //O defeito do produto foi indentificado no centro de custo 211
    //mas ocorreu em outro processo... 
    //If fProcesso # "04"
    //   loop
    //End    
          
If nOrdem==2    
    If impDbug 
@ li,002 psay "** P E R D A S **************************************************************************************************************************************";Li++
@ li,002 psay "Componente      Descrição                      Modelo          OP           CC Mt Descrição                      Qtd Cust.Un   Custo Observação          "
             //XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXX XXX 99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999 9,99.99 9,99.99 XXXXXXXXXXXXXXXXXXXX
    impDbug :=.f.
    li++
    End
end    
    If LTRIM(fModelo) # LTRIM(xModelo) .and. cProd # aOP[nPos][2]
       loop
    Else
       //Busca o custo da peça
       dbSelectArea("SD3")//Movimentação
	   dbSetOrder(4)
	   dbSeek(xFilial("SD3")+aPerdas[i][8])
       fCusto :=D3_CUSTO1       
       xCustoP+=fCusto
If nOrdem==2      
       //Imprime os componentes 
       @ li,002      psay  SUBS(aPerdas[i][1]   ,1,15)  //"** Componente:" 
       @ li,PCOL()+1 psay  SUBS(fDesComp        ,1,30)  //"** Descri....:"  
       @ li,PCOL()+1 psay  SUBS(aPerdas[i][5]   ,1,15)  //"** Modelo....:" 
       @ li,PCOL()+1 psay  SUBS(fOP             ,1,11)  //"** OP........:"
       @ li,PCOL()+1 psay  SUBS(aPerdas[i][10]  ,1,3 )   //"** Centro de Custo"   
       @ li,PCOL()+1 psay  SUBS(aPerdas[i][2]   ,1,02)  //"** Motivo....:" 
       @ li,PCOL()+1 psay  SUBS(aPerdas[i][3]   ,1,30)  //"** DEscriç...:"     
       @ li,PCOL()+1 psay  Transform(aPerdas[i][4]      ,"@E 999")    //"** Qtd.......:" 
       @ li,PCOL()+1 PSAY Transform(fCusto/aPerdas[i][4],"@E 9,99.99")//"** Custo unit:"
       @ li,PCOL()+1 PSAY Transform(fCusto              ,"@E 9,99.99")//"** Custo.....:"
       @ li,PCOL()+1 PSAY IIF(aPerdas[i][2]=="99",aPerdas[i][9]," ")  //Observação
       Li++ 
       
       If li > 58
	      cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
	      impDbug :=.T.
	   End   
end	      	  
IF nOrdem==2 .or. nOrdem==3 
       //Indice de não Confomidades
          nPos :=aScan(aIndNConf,{|x| x[1]==aPerdas[i][1] .and. x[3]==aPerdas[i][5] .and. x[4]==aPerdas[i][2]})
       IF nPos == 0
		  aadd(aIndNConf, {aPerdas[i][1],;       //1 - COMPONENTE
		                        fDesComp,;       //2 - DESCRIÇÃO DO COMP.
                           aPerdas[i][5],;       //3 - MODELO
                           aPerdas[i][2],;       //4 - MOTIVO
                           aPerdas[i][3],;       //5 - DESCRIÇÃO DO MOT.                           
	 	                   aPerdas[i][4],;       //6 - QUANTIDADE       
	 	                             fOP})       //7 - OP
	   ELSE
	     aIndNConf[nPos][6]+=aPerdas[i][4]
	   ENDIF 
END	  
	  
	  nPos := aScan(fPerda,{|x| x[2]==aPerdas[i][2] .and. x[5]==xModelo})
	  		
	  If nPos==0
		  aadd(fPerda,    {aPerdas[i][1],;       //1 - PRODUTO
		                   aPerdas[i][2],;       //2 - MOTIVO
                           aPerdas[i][3],;       //3 - DESCRIÇÃO DO MOT.
		                   aPerdas[i][4],;       //4 - QUANTIDADE PERD.
	 	                         xModelo,;       //5 - Modelo
	                       aPerdas[i][6]})       //6 - RECURSO
	  else
		  fPerda[nPos][4] += aPerdas[i][4]
	  Endif	                     
    Endif
next
If nOrdem==2 
   //li+=1          
end
Return fPerda 

Static Function GetHora(nSeg)
Local nMin:=0
Local nHra:=0
Local bCnd:=.F.
While !bCnd
	If nSeg >= 60	
	   nSeg -= 60
	   nMin++
	   If nMin=60
	      nHra++
	      nMin:=0
	   End
	   bCnd:=.T.
	End                     
	bCnd:=!bCnd
EndDo
Return 	STRZERO(nHra,2) +":" +STRZERO(nMin,2) 


Static Function getIMPIndNConforme(nQtdPerda)
If len(aIndNConf) >= 1
   @ li,004 psay "** INDICE DE NÃO CONFORMIDADE *******************************************************";li++
   @ li,004 psay "Componente      Descrição                      Modelo          Qtd Mt Descrição       Ind"
                //XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXX 99 XXXXXXXXXXXXXXX 9,99
   //Quantidade + Componente
   Li++ 
   aSort(aIndNConf,,,{|x,y| StrZero(x[6],3)+ x[1] > StrZero(y[6],3)+y[1] }) 
   qtd:=0
   For i:=1 to IIF(len(aIndNConf)>5,5,len(aIndNConf))
       //Imprime os componentes 
       @ li,004      psay  SUBS(aIndNConf[i][1],1,15)  //"** Componente:" 
       @ li,PCOL()+1 psay  SUBS(aIndNConf[i][2],1,30)  //"** Descri....:"  
       @ li,PCOL()+1 psay  SUBS(aIndNConf[i][3],1,15)  //"** Modelo....:"
       @ li,PCOL()+1 psay  Transform(aIndNConf[i][6],"@E 999")//"** Qtd.......:"      
       @ li,PCOL()+1 psay  SUBS(aIndNConf[i][4],1,02)  //"** Motivo....:" 
       @ li,PCOL()+1 psay  SUBS(aIndNConf[i][5],1,15)  //"** Descriç...:" 
       @ li,PCOL()+1 psay  Transform(aIndNConf[i][6]/nQtdPerda,"@E 9.99")  //Indice de perda 
       qtd+=aIndNConf[i][6]
       Li++ 
   Next 
   If len(aIndNConf)>5
      @ li,004      psay  "OUTROS         "                               //"** Componente:" 
      @ li,067      psay  Transform(nQtdPerda-qtd            ,"@E 999")   //"** Descri....:"
      @ li,090      psay  Transform((nQtdPerda-qtd)/nQtdPerda,"@E 9.99")  //"** Descri....:" 
   End        
     Li++ 
end
Return   

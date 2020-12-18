#include "rwmake.ch"
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function FCOST()

SetPrvt("CBTXT,CBCONT,CABEC1,CABEC2,WNREL,TITULO")
SetPrvt("CDESC1,CDESC2,CDESC3,TAMANHO,LIMITE,CSTRING")
SetPrvt("AORD,LCONTINUA,CUM,LEND,ARETURN,NOMEPROG")
SetPrvt("NLASTKEY,CPERG,LI,M_PAG,NTIPO,CARQNTX")

SetPrvt("dDatRef1,dDatRef2")

SetPrvt("xPerdas")
SetPrvt("aPerdas") 
SetPrvt("nDevo,xPerdas,nAno") 



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo    := "Relatorio Gerencial dos Planos para Redução - FCOST"
cDesc1    := "Este programa tem com objetivo, Capturar e imprimir os produtos "
cDesc2    := "com maior custo de perda no processo NSB, nos C.Custo 211, 221 "
cDesc3    := "e 231.No periodo especificado."
tamanho   := "G"
limite    := 220
cString   := "SD3"
aOrd      := {}//{"Visualizar","Atualizar"} //-- Ordem
lContinua := .T.
cUM       := ""
lEnd      := .F.
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "FCOST"
nLastKey  := 0
cPerg     := "PCPR10"
nAno:=0
xPerdas   := {}
aPerdas   := {}
aOP       := {}
fCost     := {} 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

pergunte("PCPR10",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01             // Da Data                             ³
//³ mv_par02             // Ate a Data                          ³
//³ mv_par03             // Qnto a Impressão                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel  := "FCOST"
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


cabec2 := "De "+dtoc(mv_par01)+" a "+dtoc(mv_par02)+" "
titulo := "Plano para Redução FCOST. (Capturar Produtos)"
cabec1 := "Produto         Modelo     Cod    Custo    Causa         "
cabec2 += 						"                     Inicial       "
//         999999999999999 XXXXXXXXXX MMCCCP 9.999,99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 
//         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//                   1111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222222223333333333

If nLastKey == 27
	Return
Endif

nTipo  := IIF(aReturn[4]==1,15,18)

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)

#IFDEF WINDOWS
	Processa( {|| ExeFcost()})
	RptStatus({|| DetFcost()})
	Return
#ENDIF

Static Function ExeFcost()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nAno     := Year(mv_par01)
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

dDatRef1 := ctod("01/"+substr(dtos(mv_par01),5,2)+"/"+substr(dtos(mv_par01),1,4))
dDatRef2 := ctod(aMes[Month(mv_par02)][2]+"/"+substr(dtos(mv_par02),5,2)+"/"+substr(dtos(mv_par02),1,4))

dbSelectArea("SD3")
cArqSD3  := CriaTrab(NIL,.F. )

cArqSD3  := CriaTrab(NIL,.F. )

cKeySD3  := "D3_Filial+D3_Recurso+D3_Cod+DTOS(D3_Emissao)" // IndexKey()

cFilSD3  := "D3_FILIAL='"+xFilial("SD3")+"'.And.D3_RECURSO>='NS1-1'.And.D3_RECURSO<='NS1-1'"
cFilSD3  += ".And.DTOS(D3_EMISSAO)>='"+DTOS(MV_PAR01)+"'.And.DTOS(D3_EMISSAO)<='"+DTOS(MV_PAR02)+"'" 
cFilSD3  += ".And.D3_CC>='211'"
cFilSD3  += ".And.D3_TM=='400'"


IndRegua("SD3",cArqSD3,cKeySD3,,cFilSD3,"Selecionando Registros do Processo 211...")
dbSelectArea("SD3")

ProcRegua(RecCount())
dbGoTop()

While !Eof() .And. xFilial()==D3_FILIAL .And. lContinua
	
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
	
	If D3_Emissao < mv_par01 .or. D3_Emissao > mv_par02
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
	If nOrdem==4  .and. Astec == "Z"
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
   
		aadd(xPerdas,  {D3_Recurso,;                      //  1
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
		      SB1->B1_Modelo}) // 3 - MODELO
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


Static Function DetFcost()

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
	      //If nOrdem==2 .or. nOrdem==3 
	         getIMPIndNConforme(nPerd)
	      //End   
	    //Percorre o produto
	    While xSeq <= Len(xPerdas) .And. xProdMod==xPerdas[xSeq][4]	.And.xProduto==xPerdas[xSeq][5]		      
		      
		      nQtdProd:=xPerdas[xSeq][7]
		      xOP     :=xPerdas[xSeq][10]
		      
		      xProduc+=nQtdProd 
	          xSeq++
	    Enddo	     
	    //getFCost()    
        //For i:=1 to len(arPerda)
        //    nPerd+=arPerda[i][4]         
        //Next
        If li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		End
		//@ li,000      PSAY xProduto           								// Codigo do Produto     
        //@ li,PCOL()+1 PSAY SUBS(xProdMod,1,10)	                            // Modelo do Produto          		
		//@ li,PCOL()+1 PSAY Transform(nQtdEstr             ,"@E 999")	    // Qtd de Componentes 
        //@ li,PCOL()+1 PSAY Transform(xProduc              ,"@E 999,999")    // Qtd Produzida
        ProdEstr := xProduc*nQtdEstr		
        //@ li,PCOL()+1 PSAY Transform(ProdEstr             ,"@E 999,999,999")// Prod X Estrutura		        
        //@ li,PCOL()+1 PSAY Transform(nPerd                ,"@E 9,999")      // Perdas		        
        //Ordenando -> Recurso + Codigo do Produto + Qtd      
                             //+ Modelo
        aSort(arPerda,,,{|x,y| x[6]+x[5]+StrZero(x[4],4) > y[6]+y[5]+StrZero(y[4],4) })                		
		nPos := PCOL()
		If Len(arPerda)>=1	.and. xProdMod==arPerda[1][5] 	    
			//@ li,nPos  +1 PSAY arPerda[1][2]                            	// Motivo Perda
			//@ li,PCOL()+1 PSAY SubStr(arPerda[1][3],1,20)               	// Descriçao Perda
			//@ li,PCOL()+1 PSAY Transform(arPerda[1][4]       ,"@E 999")	    // Quantidade Perda
			//@ li,PCOL()+1 PSAY Transform(arPerda[1][4]/nPerd ,"@E 9.99" )	// Indice Perda
			//@ li,PCOL()+1 PSAY aPerdas[1][1]
		    xPassa:=.T.
		EndIf		
		xPPM :=0
		xPPM := nPerd/ProdEstr
		xPPM := xPPM*1000000
                
		//@ li,iif(!xPassa,090,PCOL()+1) PSAY Transform(xPPM ,"@E 9,999")	    // PPM
		//@ li,PCOL()+1 PSAY Transform(xPPM/10000            ,"@E 9.999")	    // %		
		//@ li,PCOL()+1 PSAY Transform(xCustoP               ,"@E 9,999.99")	// Producao Acumulada
						
	    totProd +=xProduc
		totPE   +=ProdEstr
		totPerda+=nPerd		
		totCusto+=xCustoP
		For i:=2 to 3
			If i==2
				Li++
				//@ li,000  PSAY SubStr(xProdDes,01,15)					// Descricao do Produto
			Else
				Li++
				//@ li,000  PSAY SubStr(xProdDes,16,30)					// Descricao do Produto
			EndIf
			If i<=Len(arPerda) .and. xProdMod==arPerda[i][5] .and. xPassa
				//@ li,nPos  +1 PSAY arPerda[i][2]							// Motivo Perda
				//@ li,PCOL()+1 PSAY SubStr(arPerda[i][3],1,20)				// Descriçao Perda
				//@ li,PCOL()+1 PSAY Transform(arPerda[i][4]      ,"@E 999")  // Quantidade Perda
				//@ li,PCOL()+1 PSAY Transform(arPerda[i][4]/nPerd,"@E 9.99") // Indice Perda
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
    //@ li,000      PSAY "T O T A L    " +  xRecurso
    //@ li,027      PSAY "   "
	//@ li,031      PSAY Transform(totProd     ,"@E 999,999"    )
	//@ li,PCOL()+1 PSAY Transform(totPE       ,"@E 999,999,999")
    //@ li,PCOL()+1 PSAY Transform(totPerda    ,"@E 9,999")	
	//@ li,090      PSAY Transform(totRPPM      ,"@E 9,999")	    // PPM
	//@ li,PCOL()+1 PSAY Transform(totRPPM/10000,"@E 9.999")	    // %		
	//@ li,PCOL()+1 PSAY Transform(totCusto    ,"@E 9,999.99")	// Custo	
	//li ++
	//@ li,000 PSAY Replicate("-",Limite)
	//li ++

EndDo
 

totGePPM := totGePerda/totGePE
totRGePPM := totGePPM*1000000 

    //li++
    //@ li,000      PSAY "T O T A L    G E R A L"  
    //@ li,027      PSAY Transform(totGeEstr     ,"@E 999"        )
	//@ li,031      PSAY Transform(totGeProd     ,"@E 999,999"    )
	//@ li,PCOL()+1 PSAY Transform(totGePE       ,"@E 999,999,999")
    //@ li,PCOL()+1 PSAY Transform(totGePerda    ,"@E 9,999")	
	//@ li,090      PSAY Transform(totRGePPM     ,"@E 9,999")	    // PPM
	//@ li,PCOL()+1 PSAY Transform(totRGePPM/10000,"@E 9.999")	    // %		
	//@ li,PCOL()+1 PSAY Transform(totGeCusto    ,"@E 9,999.99")	// Custo	
	//li ++
	//@ li,000 PSAY Replicate("-",Limite)
	//li ++

getFCost() 

IF li != 80
	roda(cbcont,cbtxt,tamanho)
EndIf

Set Device To Screen

If aReturn[5] == 1
	Set Printer to
	dbCommitAll()
	ourspool(wnrel)
Endif
ExeFcost221()    
ExeFcost231()
MS_FLUSH()
//U_WFE05()

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

	dbSelectArea("SC2")//Ordem de produção
	dbSetOrder(1)
	dbSeek(xFilial("SC2")+SBC->BC_OP)
		
	dbSelectArea("SB1")//Produto
	dbSeek(xFilial("SB1")+SBC->BC_PRODUTO)
	
    xComp:=SBC->BC_PRODUTO
    xModelo := B1_MODELO
        	
	dbSelectArea("SBC")
	     
	If BC_TIPO == "D"
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
	                SBC->BC_OBS,;       //9 - OBJ
	              SBC->BC_APLIC,;      //10 - CCusto  
	              SBC->BC_TIPO})       //11 - Tipo de Perda
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
    fProd  :=aOP[nPos][2] 
    
    if alltrim(cProd) # alltrim(fProd)
       loop
    End    
    if alltrim(cRecur) # alltrim(fRecurso)
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
    If fProcesso # "04"
       loop
    End      
//If nOrdem==2    
    If impDbug 
@ li,002 psay "** P E R D A S ***************************************************************************************************************************************";Li++
@ li,002 psay "Componente      Descrição                      Modelo          OP          Mt Descrição                      Qtd Cust.Un   Custo Observação           CC  TPerda"
             //XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXX 99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999 9,99.99 9,99.99 XXXXXXXXXXXXXXXXXXXX XXX X
    impDbug :=.f.
    li++
    End
//end    
    If LTRIM(fModelo) # LTRIM(xModelo) .and. cProd # aOP[nPos][2]
       loop
    Else
       //Busca o custo da peça
       dbSelectArea("SD3")//Movimentação
	   dbSetOrder(4)
	   dbSeek(xFilial("SD3")+aPerdas[i][8])
       fCusto :=D3_CUSTO1       
       xCustoP+=fCusto
//If nOrdem==2      
       //Imprime os componentes 
       @ li,002      psay SUBS(aPerdas[i][1]   ,1,15)  //"** Componente:" 
       @ li,PCOL()+1 psay SUBS(fDesComp        ,1,30)  //"** Descri....:"  
       @ li,PCOL()+1 psay SUBS(aPerdas[i][5]   ,1,15)  //"** Modelo....:" 
       @ li,PCOL()+1 psay SUBS(fOP             ,1,11)  //"** OP........:" 
       @ li,PCOL()+1 psay SUBS(aPerdas[i][2]   ,1,02)  //"** Motivo....:" 
       @ li,PCOL()+1 psay SUBS(aPerdas[i][3]   ,1,30)  //"** DEscriç...:"
       @ li,PCOL()+1 psay Transform(aPerdas[i][4]       ,"@E 999")    //"** Qtd.......:" 
       @ li,PCOL()+1 PSAY Transform(fCusto/aPerdas[i][4],"@E 9,99.99")//"** Custo unit:"
       @ li,PCOL()+1 PSAY Transform(fCusto              ,"@E 9,99.99")//"** Custo.....:"
       @ li,PCOL()+1 psay IIf(aPerdas[i][2]=="99",SUBS(aPerdas[i][9],1,20),"")//"** Obs....:"  
       @ li,PCOL()+1 psay SUBS(aPerdas[i][10]   ,1,3)  //CCusto  
       @ li,PCOL()+1 psay SUBS(aPerdas[i][11]   ,1,1)  //TPerda   
       Li++ 
       
       If li > 58
	      cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
	      impDbug :=.T.
	   End   
//end	      	  

       //Indice de não Confomidades 
          //Componente + Modelo + motivo  
          nPos :=aScan(aIndNConf,{|x| x[1]==aPerdas[i][1] .and. x[3]==aPerdas[i][5] .and. x[4]==aPerdas[i][2] .and. x[9]== aPerdas[i][10]})
       IF nPos == 0
		  aadd(aIndNConf, {aPerdas[i][1],;       //1 - COMPONENTE
		                        fDesComp,;       //2 - DESCRIÇÃO DO COMP.
                           aPerdas[i][5],;       //3 - MODELO
                           aPerdas[i][2],;       //4 - MOTIVO
                           aPerdas[i][3],;       //5 - DESCRIÇÃO DO MOT.                           
	 	                   aPerdas[i][4],;       //6 - QUANTIDADE       
	 	                             fOP,;       //7 - OP
	 	                          fCusto,;       //8 - Custo
	 	                  aPerdas[i][10],;       //9 - CCusto 
	 	                  aPerdas[i][11]})       //10 - TPerda 
	   ELSE
	     aIndNConf[nPos][6]+=aPerdas[i][4]
	     aIndNConf[nPos][8]+=fCusto
	   ENDIF 
	  
	  
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
//If nOrdem==2 
   //li+=1          
//end
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
   @ li,004 psay "Componente      Descrição                      Modelo          Qtd Mt Descrição            Custo CC  TPerda"
                //XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXX 99 XXXXXXXXXXXXXXX 999.999,99 XXX X
   //Quantidade + Componente
   Li++ 
   //aSort(aIndNConf,,,{|x,y| StrZero(x[6],3)+ x[1] > StrZero(y[6],3)+y[1] })  
   aSort(aIndNConf,,,{|x,y| x[9]+StrZero(x[8],8)+ x[1] > y[9]+StrZero(y[8],8)+y[1] }) 
   qtd  :=0
   //custo:=0
   For i:=1 to len(aIndNConf)//IIF(len(aIndNConf)>8,8,len(aIndNConf))
       //Imprime os componentes 
       @ li,004      psay  SUBS(aIndNConf[i][1],1,15)  //"** Componente:" 
       @ li,PCOL()+1 psay  SUBS(aIndNConf[i][2],1,30)  //"** Descri....:"  
       @ li,PCOL()+1 psay  SUBS(aIndNConf[i][3],1,15)  //"** Modelo....:"
       @ li,PCOL()+1 psay  Transform(aIndNConf[i][6],"@E 999")//"** Qtd.......:"      
       @ li,PCOL()+1 psay  SUBS(aIndNConf[i][4],1,02)  //"** Motivo....:" 
       @ li,PCOL()+1 psay  SUBS(aIndNConf[i][5],1,15)  //"** Descriç...:" 
       //@ li,PCOL()+1 psay  Transform(aIndNConf[i][6]/nQtdPerda,"@E 9.99")  //Indice de perda 
       @ li,PCOL()+1 psay  Transform(aIndNConf[i][8],"@E 999,999.99")      //Custo  
       @ li,PCOL()+1 psay  SUBS(aIndNConf[i][9],1,3)  //CCusto 
       @ li,PCOL()+1 psay  SUBS(aIndNConf[i][10],1,1) //TPerda 
       //Adicionar
       //                      Componente            +   Modelo                +   Motivo                +   CCusto   
       dbSelectArea("SB1")
	   dbSeek(cFilial+aIndNConf[i][1])
       
       nPos :=aScan(fCost,{|x| x[1]==aPerdas[i][1] .and. x[3]==aPerdas[i][5] .and. x[4]==aPerdas[i][2] .and. x[9]== aPerdas[i][10]})
       IF nPos == 0
		  aadd(fCost,     {aIndNConf[i][1],;       //1 - COMPONENTE
		                   aIndNConf[i][2],;       //2 - DESCRIÇÃO DO COMP.
                           aIndNConf[i][3],;       //3 - MODELO
                           aIndNConf[i][4],;       //4 - MOTIVO
                           aIndNConf[i][5],;       //5 - DESCRIÇÃO DO MOT.                           
	 	                   aIndNConf[i][6],;       //6 - QUANTIDADE       
	 	                   aIndNConf[i][7],;       //7 - OP
	 	                   aIndNConf[i][8],;       //8 - Custo
	 	                   aIndNConf[i][9],;       //9 - CCusto  
	 	                  aIndNConf[i][10],;       //9 - TPerda 
	 	                      SB1->B1_GRUPO})       //10 - Tipo 
	   ELSE
	     fCost[nPos][6]+=aIndNConf[i][6]
	     fCost[nPos][8]+=aIndNConf[i][8]
	   ENDIF 
       //
       qtd  +=aIndNConf[i][6]
       //custo+=aIndNConf[i][8]
       Li++
       If li > 58
	      cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
          @ li,004 psay "** INDICE DE NÃO CONFORMIDADE *******************************************************";li++
          @ li,004 psay "Componente      Descrição                      Modelo          Qtd Mt Descrição            Custo CC  TPerda"
                       //XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXX 99 XXXXXXXXXXXXXXX 999.999,99 XXX X
          Li++ 	      	      
	   End    
   Next 
   /*
   If len(aIndNConf)>8
      @ li,004      psay  "OUTROS         "                               //"** Componente:" 
      @ li,067      psay  Transform(nQtdPerda-qtd            ,"@E 999")   //"** Descri....:"
      @ li,090      psay  Transform((nQtdPerda-qtd)/nQtdPerda,"@E 9.99")  //"** Descri....:" 
   End */            
     Li++ 
end
Return      


Static Function getFCost()
If len(fCost) >= 1
   @ li,004 psay "** INDICE DE NÃO CONFORMIDADE POR CUSTO *******************************************************";li++
   @ li,004 psay "Componente      Descrição                      Modelo          Qtd Mt Descrição            Custo CC  TPerda"
                //XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXX 99 XXXXXXXXXXXXXXX 999.999,99 XXX X
   //Quantidade + Componente
   Li++  
   aSort(fCost,,,{|x,y| x[9]+StrZero(x[8],8)+ x[1] > y[9]+StrZero(y[8],8)+y[1] }) 
   i:=1 
   x:=1
   antCC:=""
   WHILE i <= len(fCost)
       fCC:=SUBS(fCost[i][9],1,3)
       
       while i <= len(fCost) .and. fCC == SUBS(fCost[i][9],1,3)          
          if x <= 8
             @ li,004      psay  SUBS(fCost[i][1],1,15)  //"** Componente:" 
             @ li,PCOL()+1 psay  SUBS(fCost[i][2],1,30)  //"** Descri....:"  
             @ li,PCOL()+1 psay  SUBS(fCost[i][3],1,15)  //"** Modelo....:"
             @ li,PCOL()+1 psay  Transform(fCost[i][6],"@E 999")//"** Qtd.......:"      
             @ li,PCOL()+1 psay  SUBS(fCost[i][4],1,02)  //"** Motivo....:" 
             @ li,PCOL()+1 psay  SUBS(fCost[i][5],1,15)  //"** Descriç...:" 
             //@ li,PCOL()+1 psay  Transform(aIndNConf[i][6]/nQtdPerda,"@E 9.99")  //Indice de perda 
             @ li,PCOL()+1 psay  Transform(fCost[i][8],"@E 999,999.99")      //Custo  
             @ li,PCOL()+1 psay  SUBS(fCost[i][9],1,3)  //CCusto     
             @ li,PCOL()+1 psay  SUBS(fCost[i][10],1,1)  //TPerda 
             @ li,PCOL()+1 psay  SUBS(fCost[i][11],1,5)  //Tipo         
             //ADD 
             
             dbSelectArea("SZE") 	        
             RecLock("SZE",.T.)
               SZE->ZE_FILIAL := xFilial("SZE")             //1-Filial
               SZE->ZE_COD    := substr(dtos(mv_par01),5,2)+substr(strzero(nAno,4),3,2) //2-Mes Referente + Ano Referente
               SZE->ZE_PROD   := fCost[i][1]                //3-Codigo do Produto
               SZE->ZE_PRDESC := fCost[i][2]                //4-Descrição
               SZE->ZE_QUANT  := fCost[i][6]                //5-quantidade               
               SZE->ZE_CUSTO  := fCost[i][8]                //6-Custo
               SZE->ZE_CAUSAI := fCost[i][5]                //7-Causa Inicial
               SZE->ZE_CC     := fCost[i][9]                //8-Centro de custo
               SZE->ZE_PROC   := "211"                      //9-Processo
               SZE->ZE_TIPOP  := SUBS(fCost[i][10],1,1)     //10-Tipo de Perda  
	 	       SZE->(MsUnlock())
             //Edit     
             Li++
       If li > 58
	      cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
          @ li,004 psay "** INDICE DE NÃO CONFORMIDADE POR CUSTO *******************************************************";li++
          @ li,004 psay "Componente      Descrição                      Modelo          Qtd Mt Descrição            Custo CC  TPerda"
                       //XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXX 99 XXXXXXXXXXXXXXX 999.999,99 XXX X
          //Quantidade + Componente
          Li++  	      	      
	   End              
          end
          x++
          i++
       Enddo
       x:=1      
       Li++
       If li > 58
	      cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
          @ li,004 psay "** INDICE DE NÃO CONFORMIDADE POR CUSTO *******************************************************";li++
          @ li,004 psay "Componente      Descrição                      Modelo          Qtd Mt Descrição            Custo CC  TPerda"
                       //XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXX 99 XXXXXXXXXXXXXXX 999.999,99 XXX X
          //Quantidade + Componente
          Li++  	      	      
	   End    
   ENDDO        
   Li++ 
end
Return   


//********************************
//**  FCOST - PROCESSO (221)
//******************************** 

Static Function ExeFcost221()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

xPerdas  :={}
aOP221   :={}
aDOC     :={}                                                                                                                                                     
conout("Iniciando o filtro...")
dbSelectArea("SD3")
cArqSD32  := CriaTrab(NIL,.F. )

cArqSD32  := CriaTrab(NIL,.F. )

cKeySD32  := "D3_Filial+D3_Recurso+D3_Cod+DTOS(D3_Emissao)" // IndexKey()

cFilSD32  := "D3_FILIAL='"+xFilial("SD3")+"'.And.D3_RECURSO>='IMPR01'.And.D3_RECURSO<='IMPR01'"
cFilSD32  += ".And.DTOS(D3_EMISSAO)>='"+DTOS(MV_PAR01)+"'.And.DTOS(D3_EMISSAO)<='"+DTOS(MV_PAR02)+"'" 
cFilSD32  += ".And.D3_CC>='221'"
cFilSD32  += ".And.D3_TM=='400'"


IndRegua("SD3",cArqSD32,cKeySD32,,cFilSD32,"Selecionando Registros do Processo 221...")
dbSelectArea("SD3")
conout("Finalizou o filtro...")
ProcRegua(RecCount())
dbGoTop()

While !Eof() .And. xFilial()==D3_FILIAL .And. lContinua
	
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
	
	If D3_Emissao < mv_par01 .or. D3_Emissao > mv_par02
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

	dbSelectArea("SI3")//Centro de Custo
	dbSetOrder(1)
	dbSeek(xFilial("SI3")+SD3->D3_CC)
	
	dbSelectArea("SC2")//Ordem de Produção
	dbSetOrder(1)
	dbSeek(xFilial("SC2")+SD3->D3_OP)

	dbSelectArea("SD3")
		aadd(xPerdas,{D3_Recurso,;                          //  1
					  D3_Emissao,;                          //  2
					  SubStr(D3_CC,1,6),;                   //  3   8
					  SB1->B1_Modelo,;                      //  4   3
					  D3_Cod,;                              //  5   6
					  SubStr(SB1->B1_Desc,1,30),;           //  6   7
					  D3_Quant,;                            //  7  10
					  D3_Custo1,;                           //  8  11
					  D3_Doc,;                              //  9   4
					  D3_Op,;                               // 10   5
					  D3_Perda })                           // 11   9
	
	nPosOP := aScan(aOP221,{|x| x[1]==D3_Op })
	
	If nPosOP == 0
		aadd(aOP221,  {D3_Op,; // 1 - OP
		              D3_Cod,; // 2 - PRODUTO
		      SB1->B1_Modelo}) // 3 - MODELO
	Endif  

	nPosDOc := aScan(aDOC,{|x| x[1]==D3_DOC })
	
	If nPosDOc == 0
		aadd(aDOC,   {D3_DOC,; // 1 - OP
		              D3_Cod}) // 2 - PRODUTO
	Endif			         	 				         	 
	
	dbSkip()	
Enddo       

//Alimenta o vetor de perdas
//For i:=1 to len(aOP)
//    setQtdPerdas(aOP[i][1])
//Next

dbSelectArea("SD3")
Set Filter To

RetIndex('SD3')

If !(Type('ArqNtx') == 'U')
	fErase(cArqNtx)
Endif

//
SetRegua(Len(xPerdas))
xSeq    := 1
xPassa:=.F.

aPerdaP:={} 

While xSeq <= Len(xPerdas)   
	xRecurso := xPerdas[xSeq][1]
	dbSelectArea("SH1")//Recurso
	dbSetOrder(1)
	dbSeek(xFilial("SH1")+xPerdas[xSeq][1])
	xDescri := H1_Descri
    //Percorre os Recursos
	While xSeq <= Len(xPerdas) .And. xRecurso==xPerdas[xSeq][1]
		xProdMod:=xPerdas[xSeq][4]
		xProduto:=xPerdas[xSeq][5]
		xProdDes:=xPerdas[xSeq][6]
		
		dbSelectArea("SB1")
		dbSeek(cFilial+xProduto)        
	    //Percorre o produto
	    While xSeq <= Len(xPerdas) .And. xProdMod==xPerdas[xSeq][4]	.And.xProduto==xPerdas[xSeq][5]
		      nQtdPerd:=xPerdas[xSeq][11]
		      xOP     :=xPerdas[xSeq][10]		        
		      //
		      xPrecoUnt:=xPerdas[xSeq][8]/(nQtdPerd+xPerdas[xSeq][7])
		      //conout(xProduto)
		      //conout(xPrecoUnt)
		      //conout(xop)		      
		      getMotPerdaProc("221",xPerdas[xSeq][9],xPrecoUnt)
	          xSeq++
	    Enddo  
		
		If xSeq  > Len(xPerdas)
			exit
		End
	
	EndDo 

EndDo  

aSort(aPerdaP,,,{|x,y| StrZero(x[6],5)+ x[1] > StrZero(y[6],5)+y[1] })
For i:=1 to 8//len(aPerdaP)
    cDescProd:=Posicione("SB1",1,xFilial("SB1")+aPerdaP[i][1],"B1_DESC")
    dbSelectArea("SZE") 	        
    RecLock("SZE",.T.)
       SZE->ZE_FILIAL := xFilial("SZE")             //1-Filial
       SZE->ZE_COD    := substr(dtos(mv_par01),5,2)+substr(strzero(nAno,4),3,2)//+substr(dtos(mv_par01),3,2) //2-Mes Referente + Ano Referente
       SZE->ZE_PROD   := aPerdaP[i][1]              //3-Codigo do Produto
       SZE->ZE_PRDESC := cDescProd                  //4-Descrição do Produto
       SZE->ZE_QUANT  := aPerdaP[i][4]              //5-Quantidade       
       SZE->ZE_CUSTO  := aPerdaP[i][6]              //6-Custo
       SZE->ZE_CAUSAI := aPerdaP[i][3]              //7-Causa Inicial
       SZE->ZE_CC     := "221"                      //8-Centro de custo
       SZE->ZE_PROC   := "221"                      //9-Processo
       SZE->ZE_TIPOP  := "P"                        //10-Tipo de Perda  
       SZE->(MsUnlock())
    //ADD   
Next      
   faRefugo:={}
   if len(faRefugo)>=1
   aSort(faRefugo,,,{|x,y| x[11]+StrZero(x[8],5)+ x[1] > y[11]+StrZero(y[8],5)+y[1] })
   cprodAnt:=" "
   prox:=1
   //for i:=1 to IIF(len(faRefugo)<8,len(faRefugo),8)
   for i:=1 to len(faRefugo)
       conout("Cadastrar Tipo->"+faRefugo[i][11]+" Prod->"+faRefugo[i][1])
       conout(faRefugo[i][8])
       if prox < 9 
          cDescP221:=Posicione("SB1",1,xFilial("SB1")+ faRefugo[i][1],"B1_DESC")
          cadastroSZ6(.T., substr(dtos(mv_par01),5,2), faRefugo[i][1], cDescP231,faRefugo[i][4] ,faRefugo[i][8], faRefugo[i][3], faRefugo[i][10], "221", faRefugo[i][11])          
       elseIf faRefugo[i][1]==cprodAnt //.and. faRefugo[i][3]==cMotAnt
          prox:=1
       end
       prox++
       cprodAnt:=faRefugo[i][1]
       cMotAnt :=faRefugo[i][3]
   next                
   end
Return  


/****
* FUNÇÃO OBTEM AS PERDAS DE UMA DETERNINADA MODELO
* @PARAMETER ->  STRING cCustoProc,STRING cDOC 
* @RETURN    ->  VECTOR PERDAS DO PRODUTO NO PROCESSO.
*****/
Static Function getMotPerdaSZ6(cCustoProc,cDOC,nPrcUnt)
    dbSelectArea("SZ6") 
	dbSetOrder(1)	
	If dbSeek(xFilial("SZ6")+cDOC)
       DO WHILE cDOC==Z6_DOC
                        //Codigo do produto + codigo do motivo
          nPos := aScan(aPerdaP,{|x| x[1]==Z6_COD .and. x[2]==Z6_CODMOT })
	  	   	
	      If nPos==0
		     aadd(aPerdaP,   {Z6_COD,;       //1 - PRODUTO
		                   Z6_CODMOT,;       //2 - MOTIVO
                           Z6_MOTIVO,;       //3 - DESCRIÇÃO DO MOT.
		                    Z6_QUANT,;       //4 - QUANTIDADE PERD.
	 	                  Z6_RECURSO,;       //5 - RECURSO
	                nPrcUnt*Z6_QUANT})       //6 - CUSTO
	      else
		     aPerdaP[nPos][4] += Z6_QUANT
		     aPerdaP[nPos][6] += (nPrcUnt*Z6_QUANT)	
	IF aPerdaP[nPos][1]=="B50106665900103" .AND. aPerdaP[nPos][2]=="03" 	      
	conout("--EDIT-----------------------")
	conout("Doc  -> " +cDOC)
	conout("Prod -> " +aPerdaP[nPos][1])
	conout("Perda-> " +strzero(Z6_QUANT          ,5))
	conout("CustU-> " +Transform(nPrcUnt         ,"@E 99.99"))
	conout("Custo-> " +Transform(nPrcUnt*Z6_QUANT,"@E 99.99"))	
	conout("CustT-> " +Transform(aPerdaP[nPos][6],"@E 999.99"))		
	end	     	     
	      Endif
	      IF Z6_COD=="B50106665900103" .AND. Z6_CODMOT=="03" .and. npos==0
	conout("-New-------------------------")
	conout("Doc  -> " +cDOC)
	conout("Prod -> " +Z6_COD)
	conout("Perda-> " +strzero(Z6_QUANT          ,5))
	conout("CustU-> " +Transform(nPrcUnt         ,"@E 99.99"))
	conout("Custo-> " +Transform(nPrcUnt*Z6_QUANT,"@E 99.99"))
	//conout("CustT-> " +Transform(nPrcUnt*Z6_QUANT,"@E 99.99"))	      
	      END	        
       	  dbSkip()
       ENDDO    
    EndIf
Return   

/****
* FUNÇÃO OBTEM OS REGUGOS(PERDAS) POR OP NO PROCESSO 221/231
* @PARAMETER ->  STRING cCustoProc,STRING cOP. 
* @RETURN    ->  VECTOR DE REFUGOS NO PROCESSO.
*****/

Static Function getRefugoSZ6(cCustoProc,cOP)

//conout("Função perdas por OP")
//conout("Op..."+cOP)

dbSelectArea("SBC")//Perdas por OP
dbSetOrder(1)
if dbSeek(xFilial("SBC")+cOP) 
  //conout("Encontrou a OP...")
  While !Eof() .and. cOP==BC_OP
  	
	dbSelectArea("SB1")//Produto
	dbSeek(xFilial("SB1")+SBC->BC_PRODUTO)
	
    xComp  :=SBC->BC_PRODUTO
    fcDes  := B1_DESC
    xModelo:=""
    //conout("Componente..."+xComp)    	
	
	//Custo
	dbSelectArea("SD3")//Movimentação Interna
	dbSetOrder(4)                               
	dbSeek(xFilial("SD3")+SBC->BC_SEQSD3) 
	fnCusto:=D3_CUSTO1
	//conout("Custo...")
	//conout(fnCusto)	
	//Conout("Tipo..."+SBC->BC_TIPO)     
	//If BC_TIPO == "D"
	//   dbSkip()
	//   loop
	//EndIf
		
    dbSelectArea("SZC")//Motivos de perdas 
    dbSetOrder(1)
    dbSeek(xFilial("SZC")+SBC->BC_MOTIVO)
    
    cDescMot:=ZC_TIPODEF
    
    dbSelectArea("SBC")     
    
    nPos := aScan(faRefugo,{|x| x[1]==BC_PRODUTO .and. x[2]==BC_MOTIVO })  
    If nPos==0
	   aadd(faRefugo,  {BC_PRODUTO,;       //1 - PRODUTO
	                     BC_MOTIVO,;       //2 - MOTIVO
                          cDescMot,;       //3 - DESCRIÇÃO DO MOT.
	                      BC_QUANT,;       //4 - QUANTIDADE PERD.
	                       xModelo,;       //5 - Modelo
	                    BC_RECURSO,;       //6 - RECURSO 
	                           cOP,;       //7 - OP	                      
   	                       fnCusto,;       //8 - Custo da Perda
	                   SBC->BC_OBS,;       //9 - OBJ
	                 SBC->BC_APLIC,;       //10 - CCusto   
	                  SBC->BC_TIPO})       //11 - Tipo de Perda
	else
		     faRefugo[nPos][4] += BC_QUANT
		     faRefugo[nPos][8] += fnCusto	
	Endif
		
	dbSkip()
  EndDo 
Endif
Return   

//    
/****
* FUNÇÃO CADASTRA NA TABELA SZE - FCOST
* @PARAMETER ->  bADD, cCod, cProd, cDescP, nCusto, cCausaI, cCC, cCCProc, cTipoP. 
* @RETURN    ->  True
*****/
Static Function cadastroSZ6(bADD, cCod, cProd, cDescP,nQntd, nCusto, cCausaI, cCC, cCCProc, cTipoP)
    if !bADD    
       flag:=.T.
    else
       flag:=.F.
    end
    
    dbSelectArea("SZE") 	        
    RecLock("SZE",flag)
       SZE->ZE_FILIAL := xFilial("SZE") //1-Filial
       SZE->ZE_COD    := cCod + substr(strzero(nAno,4),3,2)          //+substr(dtos(mv_par01),3,2) //2-Mes Referente + Ano Referente
       SZE->ZE_PROD   := cProd          //3-Codigo do Produto
       SZE->ZE_PRDESC := cDescP         //4-Descrição do Produto
       SZE->ZE_QUANT  := nQntd          //5-Custo       
       SZE->ZE_CUSTO  := nCusto         //6-Custo
       SZE->ZE_CAUSAI := cCausaI        //7-Causa Inicial
       SZE->ZE_CC     := cCC            //8-Centro de custo
       SZE->ZE_PROC   := cCCProc        //9-Processo 
       SZE->ZE_TIPOP  := cTipoP         //10-Tipo de Perda        
       SZE->(MsUnlock())
return
//
//********************************
//**  FCOST - PROCESSO (231)
//******************************** 
Static Function ExeFcost231()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

xPerdas  :={}
aOP231   :={}
aDOC     :={}                                                                                                                                                     
conout("Iniciando o filtro 231...")
dbSelectArea("SD3")
cArqSD33  := CriaTrab(NIL,.F. )

cArqSD33  := CriaTrab(NIL,.F. )

cKeySD33  := "D3_Filial+D3_Recurso+D3_Cod+DTOS(D3_Emissao)" // IndexKey()

cFilSD33  := "D3_FILIAL='"+xFilial("SD3")+"'.And.D3_RECURSO>='INJP-1'.And.D3_RECURSO<='INJP-3'"
cFilSD33  += ".And.DTOS(D3_EMISSAO)>='"+DTOS(MV_PAR01)+"'.And.DTOS(D3_EMISSAO)<='"+DTOS(MV_PAR02)+"'" 
cFilSD33  += ".And.D3_CC>='231'"
cFilSD33  += ".And.D3_TM=='400'"


IndRegua("SD3",cArqSD33,cKeySD33,,cFilSD33,"Selecionando Registros do Processo 231...")
dbSelectArea("SD3")
conout("Finalizou o filtro 231...")
ProcRegua(RecCount())
dbGoTop()

While !Eof() .And. xFilial()==D3_FILIAL .And. lContinua
	
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
	
	If D3_Emissao < mv_par01 .or. D3_Emissao > mv_par02
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

	dbSelectArea("SI3")//Centro de Custo
	dbSetOrder(1)
	dbSeek(xFilial("SI3")+SD3->D3_CC)
	
	dbSelectArea("SC2")//Ordem de Produção
	dbSetOrder(1)
	dbSeek(xFilial("SC2")+SD3->D3_OP)

	dbSelectArea("SD3") 

		aadd(xPerdas,{D3_Recurso,;                          //  1
					  D3_Emissao,;                          //  2
					  SubStr(D3_CC,1,6),;                   //  3   8
					  SB1->B1_Modelo,;                      //  4   3
					  D3_Cod,;                              //  5   6
					  SubStr(SB1->B1_Desc,1,30),;           //  6   7
					  D3_Quant,;                            //  7  10
					  D3_Custo1,;                           //  8  11
					  D3_Doc,;                              //  9   4
					  D3_Op,;                               // 10   5
					  D3_Perda })                           // 11   9
	
	nPosOP := aScan(aOP231,{|x| x[1]==D3_Op })
	
	If nPosOP == 0
		aadd(aOP231,  {D3_Op,; // 1 - OP
		              D3_Cod,; // 2 - PRODUTO
		      SB1->B1_Modelo}) // 3 - MODELO
	Endif  

	nPosDOc := aScan(aDOC,{|x| x[1]==D3_DOC })
	
	If nPosDOc == 0
		aadd(aDOC,   {D3_DOC,; // 1 - OP
		              D3_Cod}) // 2 - PRODUTO
	Endif			         	 				         	 
	
	dbSkip()	
Enddo       

//Alimenta o vetor de perdas
//For i:=1 to len(aOP)
//    setQtdPerdas(aOP[i][1])
//Next

dbSelectArea("SD3")
Set Filter To

RetIndex('SD3')

If !(Type('ArqNtx') == 'U')
	fErase(cArqNtx)
Endif

//
SetRegua(Len(xPerdas))
xSeq    := 1
xPassa:=.F.

aPerdaP:={} 

While xSeq <= Len(xPerdas)   
	xRecurso := xPerdas[xSeq][1]
	dbSelectArea("SH1")//Recurso
	dbSetOrder(1)
	dbSeek(xFilial("SH1")+xPerdas[xSeq][1])
	xDescri := H1_Descri
    //Percorre os Recursos
	While xSeq <= Len(xPerdas) .And. xRecurso==xPerdas[xSeq][1]
		xProdMod:=xPerdas[xSeq][4]
		xProduto:=xPerdas[xSeq][5]
		xProdDes:=xPerdas[xSeq][6]
		
		dbSelectArea("SB1")
		dbSeek(cFilial+xProduto)        
	    //Percorre o produto
	    While xSeq <= Len(xPerdas) .And. xProdMod==xPerdas[xSeq][4]	.And.xProduto==xPerdas[xSeq][5]		      
		      
		      nQtdPerd:=xPerdas[xSeq][11]
		      xOP     :=xPerdas[xSeq][10]		        
		      //
		      xPrecoUnt:=xPerdas[xSeq][8]/(nQtdPerd+xPerdas[xSeq][7])
		      //conout(xProduto)
		      //conout(xPrecoUnt)
		      //conout(xop)		      
		      getMotPerdaProc("231",xPerdas[xSeq][9],xPrecoUnt)
	          xSeq++
	    Enddo  
		
		If xSeq  > Len(xPerdas)
			exit
		End
	
	EndDo 

EndDo  

aSort(aPerdaP,,,{|x,y| StrZero(x[6],5)+ x[1] > StrZero(y[6],5)+y[1] })
For i:=1 to 8//len(aPerdaP)
    cDescProd:=Posicione("SB1",1,xFilial("SB1")+aPerdaP[i][1],"B1_DESC")
    dbSelectArea("SZE") 	        
    RecLock("SZE",.T.)
       SZE->ZE_FILIAL := xFilial("SZE")             //1-Filial
       SZE->ZE_COD    := substr(dtos(mv_par01),5,2)+substr(strzero(nAno,4),3,2)//+substr(dtos(mv_par01),3,2) //2-Mes Referente + Ano Referente
       SZE->ZE_PROD   := aPerdaP[i][1]              //3-Codigo do Produto
       SZE->ZE_PRDESC := cDescProd                  //4-Descrição do Produto
       SZE->ZE_QUANT  := aPerdaP[i][4]              //5-Quantidade       
       SZE->ZE_CUSTO  := aPerdaP[i][6]              //5-Custo
       SZE->ZE_CAUSAI := aPerdaP[i][3]              //6-Causa Inicial
       SZE->ZE_CC     := "231"                      //7-Centro de custo
       SZE->ZE_PROC   := "231"                      //8-Processo 
       SZE->ZE_TIPOP  := "P"                        //9-Tipo de Perda        
       SZE->(MsUnlock())
    //ADD   
Next

   faRefugo:={}
   conout("Entrou na OP231")
   for i:=1 to len(aOP231)
       //conout(" ")
       //conout(i)
       conout("OP..."+aOP231[i][1])
       //conout("---------------")
       getRefugoSZ6("231",aOP231[i][1])
   next
   
   if len(faRefugo)>0
   aSort(faRefugo,,,{|x,y| x[11]+StrZero(x[8],5)+ x[1] > y[11]+StrZero(y[8],5)+y[1] })
   cprodAnt:=" "
   prox:=1
   //for i:=1 to IIF(len(faRefugo)<8,len(faRefugo),8)
   for i:=1 to len(faRefugo)
       conout("Cadastrar Tipo->"+faRefugo[i][11]+" Prod->"+faRefugo[i][1])
       conout(faRefugo[i][8])
       if prox < 9 
          cDescP231:=Posicione("SB1",1,xFilial("SB1")+ faRefugo[i][1],"B1_DESC")
          cadastroSZ6(.T., substr(dtos(mv_par01),5,2), faRefugo[i][1], cDescP231,faRefugo[i][4], faRefugo[i][8], faRefugo[i][3], faRefugo[i][10], "231", faRefugo[i][11])
       elseIf faRefugo[i][1]==cprodAnt //.and. faRefugo[i][3]==cMotAnt
          prox:=1
       end
       prox++
       cprodAnt:=faRefugo[i][1]
       cMotAnt :=faRefugo[i][3]
   next                
   end
Return  


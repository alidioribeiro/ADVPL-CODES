#include "rwmake.ch"
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Matr29()

SetPrvt("CBTXT,CBCONT,CABEC1,CABEC2,WNREL,TITULO")
SetPrvt("CDESC1,CDESC2,CDESC3,TAMANHO,LIMITE,CSTRING")
SetPrvt("AORD,LCONTINUA,CUM,LEND,ARETURN,NOMEPROG")
SetPrvt("NLASTKEY,CPERG,XGERVO,XGERVP,XGERSA,_CFLAG")
SetPrvt("LI,M_PAG,NTIPO,CARQNTX,CINDCOND,XGERQTD")
SetPrvt("XGERVAL,XGERIPI,XCODIGO,aPerdas,nDevo")
SetPrvt("XTOTIPI,xPerdas") 
SetPrvt("dDatRef1,dDatRef2")

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MATR29   ³ Autor ³ Remerson Mogi         ³ Data ³21/04/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ NIPPON SEIKI     ³Contato ³ rmogi@nippon-seikibr.com.br    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio Gerencial de Produçao Injecao Plastica           ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±         
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Rmogi        ³05/05/07³      ³Incluir no Parametro Totais [Sim] resumo³±± 
±±³              ³        ³      ³por recurso e [Nao] Detalhado por turno.³±±
±±³              ³04/05/07³      ³                                        ³±±
±±³              ³        ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo    := "Relatorio Gerencial de Producao"
cDesc1    := "Este programa tem com objetivo, imprimir a Relacao dos Apontamentos de Producao,"
cDesc2    := "por Recurso ou Linha de Producao, no periodo especificado."
cDesc3    := ""
tamanho   := "G"
limite    := 220
cString   := "SD3"
aOrd      := {} //{"Recurso","C.de Custo","Produto"} //-- Ordem
lContinua := .T.
cUM       := ""
lEnd      := .F.
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "MATR29"
nLastKey  := 0
cPerg     := "MATR21"
xPerdas   := {}
aPerdas   := {}
aTotais   := {}
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
//³ mv_par09             // Imprimir Totais                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel  := "MATR29"
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cabec2 := "De "+dtoc(mv_par03)+" a "+dtoc(mv_par04)
titulo := "Apontamentos de Producao. (Por Recurso)"
cabec1 := "Produto           Plano  Produc      % Producao   Shots    Prod CL Perda Motivo de Perda         Quant  Ind      % Consum  Borra      % Devol      %  Horas  Total Motivo de Horas Paradas Horas  Ind  % Tot % Efic Prdtvd"
cabec2 += 						"  Acm Boa  Progr    Total             Boa                                              Perda     MP         Borra uçoes  Devol Produt Parada                               Para Parada   pc/h  pc/hh"
//         999999999999999 999,999 999,999 999.99  999,999 999,999 999,999 99 9,999 99 XXXXXXXXXXXXXXXXXXXX 9,999 9,99 999.99 999.99 9.9999 999.99 99.99 999.99 999.99 999.99 99 XXXXXXXXXXXXXXXXXXXX 99.99 9.99 999.99 999.99 999.99
//         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//                   1111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222222223333333333

If nLastKey == 27
	Return
Endif

nTipo  := IIF(aReturn[4]==1,15,18)

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
#IFDEF WINDOWS
	Processa( {|| ExeMatr23()})
	RptStatus({|| DetMatr23()})
	Return
#ENDIF

Static Function ExeMatr23()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento da Nota Fiscal                       ³
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
dDatRef1 := ctod("01/"+substr(dtos(mv_par03),5,2)+"/"+substr(dtos(mv_par03),1,4))
dDatRef2 := ctod(aMes[Month(mv_par04)][2]+"/"+substr(dtos(mv_par04),5,2)+"/"+substr(dtos(mv_par04),1,4))
dbSelectArea("SD3")
cArqSD3  := CriaTrab(NIL,.F. )
cKeySD3  := "D3_Filial+D3_Recurso+D3_Cod+DTOS(D3_Emissao)+D3_Turno" // IndexKey()
cFilSD3  := "D3_FILIAL='"+xFilial("SD3")+"'.And.D3_RECURSO>='"+MV_PAR01+"'.And.D3_RECURSO<='"+MV_PAR02+"'"
cFilSD3  += ".And.DTOS(D3_EMISSAO)>='"+DTOS(MV_PAR03)+"'.And.DTOS(D3_EMISSAO)<='"+DTOS(MV_PAR04)+"'"
cFilSD3  += ".And.D3_TM=='400'.And.D3_ESTORNO # 'S'"

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
	
	dbSelectArea("SH1")
	dbSetOrder(1)
	dbSeek(xFilial("SH1")+SD3->D3_Recurso)
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+SD3->D3_Cod)
	
	dbSelectArea("SI3")
	dbSetOrder(1)
	dbSeek(xFilial("SI3")+SD3->D3_CC)
	
	dbSelectArea("SC2")
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
					D3_Turno,;                            //  4   3
					D3_Cod,;                              //  5   6
					SubStr(SB1->B1_Desc,1,30),;           //  6   7
					D3_Quant,;                            //  7  10
					D3_Perda,;                            //  8  11
					D3_Doc,;                              //  9   4
					D3_Op,;                               // 10   5
					SubStr(SI3->I3_DESC,1,20),;           // 11   9
	                SB1->B1_Ciclo })                      // 12
	dbSkip()
	
Enddo

dbSelectArea("SD3")
Set Filter To

RetIndex('SD3')

If !(Type('ArqNtx') == 'U')
	fErase(cArqNtx)
Endif


Return


Static Function DetMatr23()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Impressao                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SD3")
dbSetOrder(1)
dbSelectArea("SC2") 
dbSetOrder(1)
dbSelectArea("SB1")
dbSetOrder(1)
dbSelectArea("SG1")
dbSetOrder(1)
cFilial := xFilial("SB1")

//aSort(xPerdas,,,{|x,y| x[1]+x[4]+x[5] < y[1]+y[4]+y[5] })
If mv_par09 == 1
    aSort(xPerdas,,,{|x,y| x[1]+x[5] < y[1]+y[5] })
	_cCond  := "xRecurso==xPerdas[xSeq][1]"
Else
	aSort(xPerdas,,,{|x,y| x[1]+x[4]+x[5] < y[1]+y[4]+y[5] })
	_cCond  := "xRecurso==xPerdas[xSeq][1] .And. xTurno==xPerdas[xSeq][4]"
EndIf

SetRegua(Len(xPerdas))

xSeq    := 1
xDescri := ""
xTurno  := ""
xDesPro := ""
While xSeq <= Len(xPerdas)
	
	xRecurso := xPerdas[xSeq][1]
	xTurno   := xPerdas[xSeq][4] 
	xDesPro  := xPerdas[xSeq][6] 
	
	dbSelectArea("SH1")
	dbSetOrder(1)
	dbSeek(xFilial("SH1")+xPerdas[xSeq][1])
	xDescri := H1_Descri
	
	//nMod    := Posicione("SB1", 1, xFilial("SB1") + cCodigo, "B1_MAOOBRA") //H1_MAOOBRA //B1_MAOOBRA
	//nCiclo  := iif(xPerdas[xSeq][12]<>0,xPerdas[xSeq][12],1)//H1_CICLO
	
	@ li,000      PSAY "Recurso: "+xRecurso
	@ li,pCol()+2 PSAY xDescri
	If mv_par09 == 2
	   @ li,pCol()+2 PSAY "Turno: " + xTurno 
	end
	li +=2	

	While xSeq <= Len(xPerdas) .And. &_cCond //xRecurso==xPerdas[xSeq][1] .And. xTurno==xPerdas[xSeq][4]
		
		cProd   := xPerdas[xSeq][5]

		nCiclo  := iif(xPerdas[xSeq][12]<>0,xPerdas[xSeq][12],1)            
		
		dbSelectArea("SB1")
		dbSeek(cFilial+cProd)
				
		dbSelectArea("SG1")
		dbSetOrder(1)
		dbSeek(cFilial+cProd)
		
		cCodBo := ""
		While !Eof() .and. G1_COD == cProd
			If G1_MPPRINC=="S"
				cCodBo := G1_COMP
				Exit
			EndIf
			dbSkip()
		EndDo
		teste:={}
		nCavid  := iif(SB1->B1_QTPONEY<>0,SB1->B1_QTPONEY,1)
		cProd   := xPerdas[xSeq][5]
		aPerdas := {}
		aHopar  := {}
		aDias   := {}
		nProd   := 0
		nPerd   := 0
		nHopar  := 0
		nHoprd  := 0
		nCons   := 0
		nBorr   := 0
		nDevo   := 0
		nPlan   := 0
		nTotPro := 0   
		GetDevol(cProd)
		GetPlan (cProd)
		GetTotP (cProd)
		
		While xSeq <= Len(xPerdas) .And. &_cCond /*xRecurso==xPerdas[xSeq][1]*/ .and. cProd == xPerdas[xSeq][5]
			IncRegua()
			
			acmPerda(xPerdas[xSeq][9])
			acmHopar(xPerdas[xSeq][9])
			nPos := Iif(Len(aDias)<>0,aScan(aDias,xPerdas[xSeq][10]),0)
			If nPos==0
				aAdd(aDias,xPerdas[xSeq][10])
				//dbSelectArea("SC2")
				//dbSeek(cFilial+Alltrim(xPerdas[xSeq][10]))
				nHoprd ++ //C2_TMPDISP
			EndIf
			If cCodBo<>""
				acmMPrima(cCodBo,xPerdas[xSeq][10])
			EndIf
			nProd += xPerdas[xSeq][7]
			nPerd += xPerdas[xSeq][8]
			xSeq ++			
		EndDo
		
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+cProd)
		
		@ li,000      PSAY cProd           									// Codigo do Produto
		@ li,PCOL()+1 PSAY Transform(nPlan                 ,"@E 9999,999")	// Plano de Producao
		@ li,PCOL()   PSAY Transform(nTotPro               ,"@E 999,999")	// Producao Acumulada
		@ li,PCOL()+1 PSAY Transform(100*nTotPro/nPlan     ,"@E 999.9")+" "	// %Producao Acumulada
		@ li,PCOL()+2 PSAY Transform(nProd+nPerd           ,"@E 999,999")	// Producao mais Perda
		@ li,PCOL()+1 PSAY Transform((nProd+nPerd)/nCavid  ,"@E 999,999")	// Shots
		@ li,PCOL()+1 PSAY Transform(nProd                 ,"@E 999,999")	// Producao Boa
		@ li,PCOL()+1 PSAY Transform(nCiclo                ,"@E 99"     )	// Ciclo--Mao de Obra
		@ li,PCOL()+1 PSAY Transform(nPerd                 ,"@E 9,999"  )	// Perda
		nPos := PCOL()
		If Len(aPerdas)>=1
			aSort(aPerdas,,,{|x,y| StrZero(x[5],4) > StrZero(y[5],4) })
			@ li,nPos  +1 PSAY aPerdas[1][3]                            	// Motivo Perda
			@ li,PCOL()+1 PSAY SubStr(aPerdas[1][4],1,19)               	// Descriçao Perda  20
			@ li,PCOL()+1 PSAY Transform(aPerdas[1][5]       ,"@E 9,999")	// Quantidade Perda
			@ li,PCOL()+1 PSAY Transform(100*aPerdas[1][5]/nPerd ,"@E 999" )	// Indice Perda
		EndIf
		nHoprd:=(nHoprd*8)	
		@ li,nPos+36  PSAY Transform(100*nPerd/(nProd+nPerd),"@E 999.9")    //+" "	// Porcetangem Perda Total
		@ li,PCOL()+1 PSAY Transform(nCons                  ,"@E 9,999.99")	// Consumo MP Principal
		@ li,PCOL()+1 PSAY Transform(nBorr                  ,"@E 9.9999")	// Perda MP Principal
		@ li,PCOL()+1 PSAY Transform(100*nBorr/nCons        ,"@E 999.9")+" "	// Indice Perda MP Principal
		@ li,PCOL()+1 PSAY Transform(nDevo                  ,"@E 9,999" )	// Devoluçoes de Cliente
        ///////////
        lp:=li+1
        cp:=PCOL()
        ///////////
		@ li,PCOL()+1 PSAY Transform(100*nDevo/nProd        ,"@E 9999.9")	// Indice Devoluçoes de Cliente
		@ li,PCOL()+1 PSAY Transform(nHoprd-nHopar          ,"@E 999.99")  	// Total de Horas Produtivas
		@ li,PCOL()+1 PSAY Transform(nHopar                 ,"@E 999.99")	// Total de Horas Paradas
		nPos2:=PCOL()
		If Len(aHopar)>=1
			aSort(aHopar ,,,{|x,y| StrZero(x[5],4) > StrZero(y[5],4) })
			@ li,nPos2 +1 PSAY aHopar[1][3]									// Codigo Horas paradas
			@ li,PCOL()+1 PSAY SubStr(aHopar[1][4],1,20)					// Motivo Horas paradas
			@ li,PCOL()+1 PSAY Transform(aHopar[1][5]        ,"@E 99.99")	// Horas Improdutivas
			@ li,PCOL()+1 PSAY Transform(100*aHopar[1][5]/nHopar ,"@E 999" )// Indice Horas Improdutivas
		EndIf
		@ li,nPos2 +36 PSAY Transform(100*nHopar/nHoprd     ,"@E 9999.9")	// Porcentagem Total Horas Paradas
		nPrdtv := (nProd/(nHoprd-nHopar))
		nEfic  := 100*nPrdtv/((3600/nCiclo)*nCavid)
		@ li,PCOL()+1 PSAY Transform(nEfic                  ,"@E 9999.9")	// Eficiencia
		nMod    := Posicione("SB1", 1, xFilial("SB1") + cProd, "B1_MAOOBRA")
		@ li,PCOL()+1 PSAY Transform(nPrdtv/nMod            ,"@E 9999.9")	// Produtividade
				
		// Alteracao para incluir Total da Producao Rmogi - 05/05/07
		xPos := aScan(aTotais,{|x| x[1]==cProd})
		
		If xPos == 0 
		   xDesPro  := Posicione("SB1",1,xFilial("SB1")+ cProd,"B1_DESC") 	
/*		aadd(aTotais,{cProd               ,;                //  1  Codigo do Produto
					 xDesPro              ,;                //  2  Descricao do Produto
					 nProd+nPerd          ,;                //  3  Produção Total
					 (nProd+nPerd)/nCavid ,;                //  4  Shots
					 nProd                ,;                //  5  Produção Boa
					 nPerd                ,;                //  6  Perdas
					 nHoprd               ,;                //  7  Horas Produtivas
					 nHoprd-nHopar        ,;                //  8  Horas Improdutivas
					 nHopar               ,;                //  9  Horas Paradas
					 0})                                    //  10  Horas Paradas
  */
     	aadd(aTotais,{cProd               ,;                //  1  Codigo do Produto
					 xDesPro              ,;                //  2  Descricao do Produto
					 nProd+nPerd          ,;                //  3  Produção Total
					 (nProd+nPerd)/nCavid ,;                //  4  Shots
					 nProd                ,;                //  5  Produção Boa
					 nPerd                ,;                //  6  Perdas
					 0                    ,;                //  7 Retrabalho
					 nHoprd               ,;                //  8  Horas Produtivas
					 nHoprd-nHopar        ,;                //  9  Horas Improdutivas
					 nHopar               })                //  10  Horas Paradas
  					 
        Else
            
            aTotais[xPos][3]+=nProd+nPerd 
            aTotais[xPos][4]+=(nProd+nPerd)/nCavid
            aTotais[xPos][5]+=nProd
            aTotais[xPos][6]+=nPerd
            aTotais[xPos][8]+=nHoprd
            aTotais[xPos][9]+=nHoprd-nHopar
            aTotais[xPos][10]+=nHopar          
            
        EndIf				
		//
		
//		For i:=2 to 3 comentado pela Aglair
		For i:=2 to len(aPerdas)
			If i==2
				Li++
				@ li,000  PSAY SubStr(SB1->B1_DESC,01,15)					// Descricao do Produto
			Else
				Li++
				@ li,000  PSAY SubStr(SB1->B1_DESC,16,30)					// Descricao do Produto
			EndIf
			If i<=Len(aPerdas)
				@ li,nPos  +1 PSAY aPerdas[i][3]							// Motivo Perda
				@ li,PCOL()+1 PSAY SubStr(aPerdas[i][4],1,19)				// Descriçao Perda
				@ li,PCOL()+1 PSAY Transform(aPerdas[i][5]      ,"@E 9,999")// Quantidade Perda
				@ li,PCOL()+1 PSAY Transform(100*aPerdas[i][5]/nPerd,"@E 999") // Indice Perda
			EndIf
			If i<=Len(aHopar)
				@ li,nPos2 +2 PSAY aHopar[i][3]								// Codigo Horas paradas
				@ li,PCOL()+1 PSAY SubStr(aHopar[i][4],1,20)				// Motivo Horas paradas
				@ li,PCOL()+1 PSAY Transform(aHopar[i][5]      ,"@E 99.99")	// Quantidade Hras paradas
				@ li,PCOL()+1 PSAY Transform(100*aHopar[i][5]/nHopar,"@E 999")	// Indice Horas paradas
			EndIf
			/*
			if i==3
		    for t:=1 to len(teste)
           	    @ li,cp-14 PSAY teste[t][1]
                @ li,cp    PSAY teste[t][2]
                li++
                If li > 60
			       cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		        End
            next
            end
		    */    
		Next

		li+=2
		
		If li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		End
		
		If xSeq  > Len(xPerdas)
			exit
		End
		
	EndDo

	@ li,000 PSAY Replicate("-",Limite)
	li ++
	
EndDo

// Alteracao para incluir Total da Producao Rmogi - 05/05/07

aTotais3 := 0
aTotais4 := 0
aTotais5 := 0
aTotais6 := 0
aTotais7 := 0
aTotais8 := 0
aTotais9 := 0
aTotais10 := 0
For i:=1 to len(aTotais) 

    If i==1
       @ li  ,000      PSAY "Codigo           Descricao                      Producao     Shot Prod.Boa  Prod.NG    Retrab.   Tot.Hrs  Hrs.Prod   Hrs.Par"
       @ li+1,000      PSAY "-------------------------------------------------------------------------------------------------------------------------------"
       //                    123456789012345bb123456789012345678901234567890bb999,999bb999,999bb999,999bb999,999bb9,999.99bb9,999.99bb9,999.99
       //                    12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
       //                             1         2         3         4         5         6         7         8         9        10
       li+=2
    End                   
    aTotais[i][7]:=GetTotRet(aTotais[i][1]) 
    aTotais[i][6]:=aTotais[i][6]- aTotais[i][7] //As peças Ng - as quantidades retrabalhadas no periodo  
    @ li,000      PSAY aTotais[i][1]
    @ li,PCOL()+2 PSAY SUBSTRING(aTotais[i][2],1,30)
    @ li,PCOL()+2 PSAY Transform(aTotais[i][3]     ,"@E 999,999")
    @ li,PCOL()+2 PSAY Transform(aTotais[i][4]     ,"@E 999,999")
    @ li,PCOL()+2 PSAY Transform(aTotais[i][5]     ,"@E 999,999")
    @ li,PCOL()+2 PSAY Transform(aTotais[i][6]     ,"@E 999,999")
    @ li,PCOL()+2 PSAY Transform(aTotais[i][7]     ,"@E 999,999")
    @ li,PCOL()+2 PSAY Transform(aTotais[i][8]     ,"@E 9,999.99")
    @ li,PCOL()+2 PSAY Transform(aTotais[i][9]     ,"@E 9,999.99")
    @ li,PCOL()+2 PSAY Transform(aTotais[i][10]     ,"@E 9,999.99")
    li++ 
    
    aTotais3 := aTotais3 + aTotais[i][3]
    aTotais4 := aTotais4 + aTotais[i][4]
    aTotais5 := aTotais5 + aTotais[i][5]
    aTotais6 := aTotais6 + aTotais[i][6]
    aTotais7 := aTotais7 + aTotais[i][7]
    aTotais8 := aTotais8 + aTotais[i][8]
    aTotais9 := aTotais9 + aTotais[i][9]
    aTotais10 := aTotais10 + aTotais[i][10]
       
Next
@ li,000      PSAY "------------------------------------------------------------------------------------------------------------------------------------" ; li++    
@ li,000      PSAY "Total Geral"
@ li,049      PSAY Transform(aTotais3 ,"@E 999,999")
@ li,PCOL()+2 PSAY Transform(aTotais4 ,"@E 999,999")
@ li,PCOL()+2 PSAY Transform(aTotais5 ,"@E 999,999")
@ li,PCOL()+2 PSAY Transform(aTotais6 ,"@E 999,999")
@ li,PCOL()+2 PSAY Transform(aTotais7 ,"@E 999,999")
@ li,PCOL()+2 PSAY Transform(aTotais8 ,"@E 9,999.99")
@ li,PCOL()+2 PSAY Transform(aTotais9 ,"@E 9,999.99")
@ li,PCOL()+2 PSAY Transform(aTotais10 ,"@E 9,999.99")
li++    

//

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

Static Function acmPerda(cDoc)

dbSelectArea("SZ6")
dbSeek(xFilial("SZ6")+cDoc)
nPos := 0
While !Eof() .and. cDoc==Z6_DOC
	If Z6_ESTORNO=="S"
		dbSkip()
		Loop
	EndIf
	If Len(aPerdas)<>0
		nPos := aScan(aPerdas,{|x| x[1]+x[2]+x[3]==Z6_RECURSO+Z6_COD+Z6_CODMOT})
	EndIf
	If nPos == 0
		aadd(aPerdas, {Z6_RECURSO,Z6_COD,Z6_CODMOT,Z6_MOTIVO,Z6_QUANT})
	Else
		aPerdas[nPos][5] += Z6_QUANT
	EndIf
	dbSkip()
EndDo

Return


Static Function acmMPrima(cCodBo,cOP)

dbSelectArea("SD3")
dbSeek(xFilial("SD3")+cOP+cCodBo)
While !Eof() .and.  cOP==D3_OP .and. D3_COD=cCodBo
	If D3_ESTORNO == "S"
		dbSkip()
		Loop
	EndIf
	nCons += D3_QUANT
	dbSkip()
EndDo

dbSelectArea("SBC")
dbSeek(xFilial("SBC")+cOP)
While !Eof() .and.  cOP==BC_OP
	If BC_PRODUTO == cCodBo
		nBorr += BC_QUANT
	EndIf
	dbSkip()
EndDo
Return

Static Function GetDevol(cProd)
aPai := {}
aOp  := {}
dbSelectArea("SG1")
dbSetOrder(2)
dbSeek(xFilial("SG1")+cProd)
aAdd(aPai,cProd)
While !Eof() .and. cProd == G1_COMP
	If dDataBase >= SG1->G1_INI .and. dDataBase <= SG1->G1_FIM
		aAdd(aPai,G1_COD)
		//
		cProd_PI:=G1_COD
		xRecno=recno()
		if dbSeek(xFilial("SG1")+cProd_PI)
		   While !Eof() .and. cProd_PI == G1_COMP
		   	      If dDataBase >= SG1->G1_INI .and. dDataBase <= SG1->G1_FIM
		             cProd_PA:=G1_COD
		             aAdd(aPai,cProd_PA)
		   	      End
		   	      dbSkip()
           EndDo		   
		end
	    dbGoto(xRecno)
	    //
	EndIf
	dbSkip()
EndDo
dbSelectArea("SC2")
dbSetOrder(2)
For i:=1 to Len(aPai)
	dbSeek(xFilial("SC2")+aPai[i]+dtos(mv_par03),.T.)
	While !Eof() .and. dtos(C2_DATPRF)<=dtos(mv_par04) .and. aPai[i] == C2_PRODUTO
        nPosOp := aScan(aOp, C2_NUM+C2_ITEM+C2_SEQUEN+"  " )       			   		
		if nPosOp==0
		   aAdd(aOp,C2_NUM+C2_ITEM+C2_SEQUEN+"  ")
		end
		dbSkip()
	EndDo
Next
For i:=1 to len(aOp)
	dbSelectArea("SBC")
	xop:=aOp[i]
	IF dbSeek(xFilial("SBC")+aOp[i])               
	   While !Eof() .and. aOp[i]==BC_OP
		   If dtos(BC_DTRM)>=dtos(mv_par03) .and. dtos(BC_DTRM)<=dtos(mv_par04) //.and. cProd==BC_PRODUTO	
			   nPosProd := aScan(aPai, BC_PRODUTO )       			   
			   If BC_APLIC>=mv_par05 .and. BC_APLIC<=mv_par06 .and. nPosProd<>0		
				   aAdd(teste,{BC_OP,BC_QUANT})//				   
				   nDevo += BC_QUANT             
				   //msgstop("OP..." + xop) 
				   //msgstop(BC_QUANT     )   
				   //msgstop(nDevo        )
			   EndIf
		   EndIf
		   dbSkip()
	   EndDo
	ENDif
Next
Return

/*
Static Function GetDevol(cProd)
aPai := {}
aOp  := {}
dbSelectArea("SG1")
dbSetOrder(2)
dbSeek(xFilial("SG1")+cProd)
While !Eof() .and. cProd == G1_COMP
	If dDataBase >= SG1->G1_INI .and. dDataBase <= SG1->G1_FIM
		aAdd(aPai,G1_COD)
	EndIf
	dbSkip()
EndDo
dbSelectArea("SC2")
dbSetOrder(2)
For i:=1 to Len(aPai)
	dbSeek(xFilial("SC2")+aPai[i]+dtos(mv_par03),.T.)
	While !Eof() .and. dtos(C2_DATPRF)<=dtos(mv_par04) .and. aPai[i] == C2_PRODUTO
		aAdd(aOp,C2_NUM+C2_ITEM+C2_SEQUEN+"  ")
		dbSkip()
	EndDo
Next
For i:=1 to len(aOp)
	dbSelectArea("SBC")
	dbSeek(xFilial("SBC")+aOp[i])
	While !Eof() .and. aOp[i]==BC_OP
		If dtos(BC_DATA)>=dtos(mv_par03) .and. dtos(BC_DATA)<=dtos(mv_par04) .and. cProd==BC_PRODUTO
			If BC_APLIC>=mv_par05 .and. BC_APLIC<=mv_par06
				nDevo += BC_QUANT
			EndIf
		EndIf
		dbSkip()
	EndDo
Next
Return
*/


Static Function acmHopar(cDoc)
dbSelectArea("SZ7")
dbSeek(xFilial("SZ7")+cDoc)
nPos := 0
While !Eof() .and. cDoc==Z7_DOC
	If Z7_ESTORNO=="S"
		dbSkip()
		Loop
	EndIf
	If Len(aHopar)<>0
		nPos := aScan(aHopar,{|x| x[1]+x[2]+x[3]==Z7_RECURSO+Z7_COD+Z7_CODMOT})
	EndIf
	nVal := Val(SubStr(Z7_TDEC,1,2))+(Val(SubStr(Z7_TDEC,3,2))/60)
	If nPos==0
		aadd(aHopar, {Z7_RECURSO,;      // 1 RECURSO	
		                  Z7_COD,;      // 2 PRODUTO
		               Z7_CODMOT,;      // 3 COD. MOTIVO
		               Z7_MOTIVO,;      // 4 DESC.MOTIVO
		                    nVal})      // 5 TEMPO PARADO
	                          
	Else
		aHopar[nPos][5] += nVal
	EndIf
	//Transformando o tempo para horas
	nHopar += Val(SubStr(Z7_TDEC,1,2))+(Val(SubStr(Z7_TDEC,3,2))/60)
	dbSkip()
EndDo

Return

Static Function GetPlan(cProd)
Local aPai   := {}
Local lCnd   := .F.
Local lpdt   := .F.
Local nQtPai := 1

/*Solução Temporaria*/
If cProd == "B5010666590BLN1"

aAdd(aPai,{"HP0582001A0C006",.F.,"PA",1*nQtPai})  
aAdd(aPai,{"HP0582001A0CC06",.F.,"PA",1*nQtPai})
aAdd(aPai,{"HP0582001A0CO08",.F.,"PA",1*nQtPai})
aAdd(aPai,{"HP0582001N0FM0Z",.F.,"PA",1*nQtPai})
aAdd(aPai,{"HP0582002A0C003",.F.,"PA",1*nQtPai})
aAdd(aPai,{"HP0582002A0CC03",.F.,"PA",1*nQtPai})
aAdd(aPai,{"HP0582002A0CO05",.F.,"PA",1*nQtPai})
aAdd(aPai,{"HP0582011A0CO00",.F.,"PA",1*nQtPai})
aAdd(aPai,{"HP0582011A0CO0A",.F.,"PA",1*nQtPai})

ELSE
//

While !lCnd
	dbSelectArea("SG1")
	dbSetOrder(2)
	dbSeek(xFilial("SG1")+cProd)
	While !Eof() .and. cProd == G1_COMP
		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+SG1->G1_COD)
		If B1_TIPO <> "PA" .or. lpdt
			lCnd := .T.
		EndIf
		dbSelectArea("SG1")
		nPos := ASCAN(aPai,{|X| X[1] == G1_COD })
		If dDataBase >= SG1->G1_INI .and. dDataBase <= SG1->G1_FIM .and. nPos == 0			
			aAdd(aPai,{G1_COD,IIF(SB1->B1_TIPO <> "PA",.T.,.F.),SB1->B1_TIPO,G1_QUANT*nQtPai})
		EndIf
		dbSkip()
	EndDo
	If lCnd
//	    MSGSTOP(Len(aPai))
		For i:=1 to Len(aPai)
//		    MSGSTOP(aPai[i][2])
			If aPai[i][2]
				cProd      := aPai[i][1]
				nQtPai     := aPai[i][4]
				aPai[i][2] := .F.
				lpdt       := .T.				
				Exit
			ElseIf i=Len(aPai)			    
			    lCnd := .F.
			EndIf
		Next
	    
	    If Len(aPai)==0
	       lCnd := .f.
	    Endif
	 
	EndIf
	lCnd := !lCnd
EndDo
END/*SOLUÇÃO TEMPORARIA*/
For i:=1 to Len(aPai)
	If aPai[i][3]=="PA"
		dbSelectArea("SHC")
		dbSetOrder(2)
		dbSeek(xFilial("SHC")+aPai[i][1],.T.)
		While !Eof() .and. aPai[i][1] == HC_PRODUTO
			If HC_DATA < dDatRef1 .OR. HC_DATA > dDatRef2
				dbSkip()
				Loop
			End
			nPlan += HC_QUANT*aPai[i][4]
			dbSkip()
		EndDo
	EndIf
Next
Return

Static Function GetTotP(cProd)
dbSelectArea("SC2") 
dbSetOrder(2)
dbSeek(xFilial("SC2")+cProd+dtos(dDatRef1),.T.)
While !Eof() .and. cProd==C2_PRODUTO .and. dDatRef2>=C2_DATPRF
	If C2_RECURSO==xRecurso
		nTotPro += C2_QUJE//+C2_PERDA
	EndIf
	dbSkip()
EndDo
Return  

Static Function GetTotRet(cProd)
Local TotRet:=0
dbSelectArea("SC2") 
dbSetOrder(2)
dbSeek(xFilial("SC2")+cProd+dtos(mv_par03),.T.)
While !Eof() .and. cProd==C2_PRODUTO .and. mv_par04>=C2_DATPRF
	If C2_TPOP = 'R' 
		TotRet += C2_QUJE//+C2_PERDA
	EndIf
	dbSkip()
EndDo
Return  TotRet



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
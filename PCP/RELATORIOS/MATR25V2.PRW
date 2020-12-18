#include "rwmake.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

User Function Matr25V2()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,CBCONT,CABEC1,CABEC2,WNREL,TITULO")
SetPrvt("CDESC1,CDESC2,CDESC3,TAMANHO,LIMITE,CSTRING")
SetPrvt("AORD,LCONTINUA,CUM,LEND,ARETURN,NOMEPROG")
SetPrvt("NLASTKEY,CPERG,")
SetPrvt("LI,M_PAG,NTIPO,CARQNTX,CINDCOND,XGERQTD")
SetPrvt("XGERVAL,XGERIPI,XCODIGO,ThMaq,TmMaq,TtMaq")
SetPrvt("XTOTIPI,TPerda,xPerdas,_aInd")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MATR25V2 ³ Autor ³ Jefferson Moreira     ³ Data ³ 11.08.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Resumo de Perdas na Producao por Produto                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ rdmake MATR25V2                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo    := "Relação de Perdas na Produção ( Por Produto ) "
cDesc1    := "Este programa tem com objetivo, imprimir a Relacao de Perdas por"
cDesc2    := "Produto, no período especificado."
cDesc3    := ""
tamanho   := "G"
limite    := 220
cString   := "SZ6"
aOrd      := {} //-- Ordem
lContinua := .T.
cUM       := ""
lEnd      := .F.
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "MATR25_V2"
nLastKey  := 0
cPerg     := "MATR21"
xPerdas   := {}
_aInd     := {}

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
//³ mv_par08             // Ao Produto                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel  := "MATR25V2"
wnrel  := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,)            
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
aPerda := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cabec1 := "Produto          Descricao                                           TP  Grpo  Qtd.Pro  Motivo da perda                      Quant     C   U   S   T   O   S  "
cabec2 := "Periodo: "+dtoc(mv_par03)+" a "+dtoc(mv_par04)+"                                                                                                           Unitario      Total CC     Descrição"
//         XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XX  xxxx  999.999  99 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 999.999 9.999,999999 999.999,99 999999  xxxxxxxxxxxxxxxxxxxx
//         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123465789012345678901234567890123456789010123456789012345678901
//         0000000000111111111122222222223333333333444444444455555555556666666666777777777788888888899999999990000000000111111111122222222223333333333444444444455

If nLastKey == 27
	Return
Endif

nTipo  := IIF(aReturn[4]==1,15,18)

// cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)

#IFDEF WINDOWS
    Processa({|| ExeMatr22()},"Consultando o Banco de Dados... Por favor aguarde...")
	
	RptStatus({|| DetMatr22()},"Gerando Relatorio... Aguarde Alguns Instantes...")
	
   //	Processa( {|| ExeMatr22()})
  //	RptStatus({|| DetMatr22(aPerda)})
	Return
#ENDIF

Static Function ExeMatr22()
Local aDados:={}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento do Relatorio                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 
 cQuery := ""
 cQuery := " SELECT Z6_COD,B1_DESC,B1_TIPO,B1_GRUPO,Z6_CODMOT,Z6_MOTIVO,D3_CC,Z6_RESP,D3_OP, "
 cQuery += " D3_CUSTO1/D3_QUANT AS CMOV,SUM(Z6_QUANT) AS Z6_QUANT "
 cQuery += " FROM SZ6010 "
 cQuery += " INNER JOIN SD3010 ON Z6_OP=D3_OP AND Z6_COD = D3_COD AND Z6_DOC=D3_DOC "
 cQuery += " INNER JOIN SB1010 ON Z6_COD = B1_COD "
 cQuery += " INNER JOIN SB2010 ON Z6_COD = B2_COD AND D3_LOCAL = B2_LOCAL "
 cQuery += " INNER JOIN SC2010 ON Z6_OP  = C2_NUM+C2_ITEM+C2_SEQUEN "
 cQuery += " WHERE  "
 cQuery += " Z6_RECURSO BETWEEN  '"+      MV_PAR01  +"' AND '"+      MV_PAR02  +"' AND "
 cQuery += " Z6_EMISSAO BETWEEN  '"+ DTOS(MV_PAR03) +"' AND '"+ DTOS(MV_PAR04) +"' AND "
 cQuery += " D3_CC      BETWEEN  '"+      MV_PAR05  +"' AND '"+      MV_PAR06  +"' AND "
 cQuery += " Z6_COD     BETWEEN  '"+      MV_PAR07  +"' AND '"+      MV_PAR08  +"' AND "
 cQuery += " Z6_ESTORNO <> 'S' AND "
 cQuery += " D3_ESTORNO <> 'S' AND "
 cQuery += " C2_TPOP <> 'T'    AND "
 cQuery += " SZ6010.D_E_L_E_T_ <> '*' AND "
 cQuery += " SD3010.D_E_L_E_T_ <> '*' AND "
 cQuery += " SB1010.D_E_L_E_T_ <> '*' AND "
 cQuery += " SB2010.D_E_L_E_T_ <> '*' AND "
 cQuery += " SC2010.D_E_L_E_T_ <> '*'      
 cQuery += " GROUP BY Z6_COD,B1_DESC,B1_TIPO,B1_GRUPO,Z6_CODMOT,Z6_MOTIVO,D3_CC,Z6_RESP,D3_CUSTO1/D3_QUANT, D3_OP "
 cQuery += " ORDER BY Z6_COD,Z6_CODMOT "
 
 cQuery := ChangeQuery(cQuery)

 TCQUERY cQuery Alias TEMP New  


 //	Gera o Custo Médio dos Produtos

 DbSElectArea("TEMP")                                                      
 
 DbGotop() 


 While !TEMP->(Eof())   
    
//    xValPer  := Z6_QUANT*B2_CM1 ALTERADO PELA AGLAIR 09/08
    PosC:=aScan(aDados,{|x|x[1]==Z6_COD})
//    xValPer  := Z6_QUANT*aDados[PosC][4]  //Custo Médio apartir da movimentações
    xValPer:= Z6_QUANT*CMOV
    xDescCC  := Posicione("CTT",1,xFilial("CTT")+D3_CC,"CTT_DESC01")
	AAdd(aPerda,{Z6_COD,;       //[1]
		            B1_DESC,;       //[2]
		            B1_TIPO,;       //[3]
		           B1_GRUPO,;       //[4]
		                nil,;       //[5]
		          Z6_CODMOT,;       //[6]  
				  Z6_MOTIVO,;       //[7]
				   Z6_QUANT,;       //[8]
	 				 cMov,;       //[9] B2_CM1 ALTERADO PELO CUSTO DA MOVIMENTACAO
					xValPer,;       //[10]
		  SubStr(D3_CC,1,6),;       //[11]
 		  SubStr(xDescCC,1,20),; //12
 	 		  D3_OP,; //[13] - OP
 	 		  Z6_RESP})       //[14]-RESP PERDA

    TEMP->(DBSKIP())
    
 Enddo
 dbSelectArea("TEMP")
 dbClearFil(NIL)
 dbCloseArea("TEMP")
 dbCloseArea() 
 
Return()
/**************************************************************/
/*Calculo do custo médio apartir das movimentações do periodo**/
/**************************************************************/
Static Function CustoMed()
Local aDados:={}

//aDados // 1.Produto
         // 2.Quantidade
         // 3.Custo total
         // 4.Custo unitário
DbSelectArea("TEMP") 
DbGotop()
While !Eof()
	PosI:=aScan(aDados,{|x|x[1],TEMP->Z6_COD}) 
	If PosI=0
		aadd(aDados,{TEMP->Z6_COD,TEMP->D3_QUANT,(TEMP->D3_QUANT*TEMP->CMOV),0})
	Else
		aDados[PosI][2]	+= TEMP->D3_QUANT
		aDados[PosI][3]	+= (TEMP->D3_QUANT*TEMP->CMOV)
	Endif 
	DbSkip()
End
For i:=1 to len(aDados)	
	aDados[i][4]:=aDados[i][3]/aDados[i][2]
Next
Return aDados

/***************************************************************/
Static Function DetMatr22()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Impressao do Relatorio                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(Len(aPerda))

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)

xCond   := .t.
xDescri := ""
i := 1

while i <= Len(aPerda)
	IncRegua()
	n_Quant   := 0
	n_Custo   := 0
	n_QtdOri  := aPerda[i][11]
	c_Produto := aPerda[i][01]
	xQuantPro := GetOri(aPerda[i][01])
	
	@ li,000      PSAY aPerda[i][01]
	@ li,PCOL()+2 PSAY aPerda[i][02]
	@ li,PCOL()+2 PSAY aPerda[i][03]
	@ li,PCOL()+2 PSAY aPerda[i][04]
	@ li,PCOL()+2 PSAY Transform(xQuantPro,"@E 999,999")//Transform(_aInd[nPos][02],"@E 999,999")
	
	nPsc:=PCOL()
		
	While i <= Len(aPerda) .And. c_Produto == aPerda[i][01]
		
		IncRegua()
		xCond := .f.
		n_Custo += aPerda[i][10]
		n_Quant += aPerda[i][08]
		@ li,nPsc+2   PSAY aPerda[i][13]												//Op
		@ li,Pcol+2   PSAY aPerda[i][06]												// Cod Motivo
		@ li,PCOL()+2 PSAY aPerda[i][07]												// Des Motivo
		@ li,PCOL()+1 PSAY Transform(aPerda[i][08]                  ,     "@E 999,999")	// Quantidade
	//	@ li,PCOL()+1 PSAY Transform(xPerdas[xSeq][09]/xPerdas[xSeq][10],"@E 9,999.999999")	// Custo Unit
 	    @ li,PCOL()+1 PSAY Transform(aPerda[i][09],"@E 9,999.999999")	                // Custo Unit
		@ li,PCOL()+1 PSAY Transform(aPerda[i][10],  "@E 999,999.99")	                // Custo Total
		@ li,PCOL()+1 PSAY aPerda[i][11]												// Cod CCusto
		@ li,PCOL()+1 PSAY aPerda[i][12]												// Des CCusto
		@ li,PCOL()+1 PSAY aPerda[i][14]												// Des CCusto
		li ++
	
		 If li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		 End
		
		i++
	EndDo
	
	@ li,017 PSAY "Total de Perdas do Produto "
	@ li,079 PSAY Transform(100*n_Quant/xQuantPro , "@E 999.99%")	// Quantidade
	@ li,123 PSAY Transform(n_Quant              , "@E 999,999")	// Quantidade
	@ li,144 PSAY Transform(n_Custo , "@E 999,999.99")	// Custo Total

	li++
	@ LI,000 PSAY Replicate("-",Limite)
	li++
	if xCond
	   i++
	End
EndDo

IF li != 80
	roda(cbcont,cbtxt,tamanho)
EndIF

Set Device To Screen

If aReturn[5] == 1
	Set Printer to
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return
                       
Static Function GetOri(xCodPro)

cQuery := " SELECT SUM(D3_QUANT)+ SUM(D3_PERDA) as PROD " 
cQuery += " FROM SD3010 "
cQuery += " WHERE "
cQuery += "  D3_TM  = '400' AND "
cQuery += "  D3_COD = '" + xCodPro +"' AND " 
cQuery += "  D3_EMISSAO BETWEEN '" + DTOS(MV_PAR03)+ " ' AND '" + DTOS(MV_PAR04)+ "'AND "
cQuery += "  D3_ESTORNO <> 'S' AND "
cQuery += "  SD3010.D_E_L_E_T_ <> '*' "
cQuery := ChangeQuery(cQuery)

TCQUERY cQuery Alias PROD New

DbSElectArea("PROD") 
 xQtdProd := PROD

 dbClearFil(NIL)
 dbCloseArea("TEMP")
 dbCloseArea() 
Return(xQtdProd)

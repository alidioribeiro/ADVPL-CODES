#Include "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  | FATR06   บ Autor ณ Jorge Silveira     บ Data ณ  19/06/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Posi็ใo de Estoque Produtos HONDA, a partir da Ordens de   บฑฑ
ฑฑบ          ณ Expedicao                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ PCP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function Fatr06


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "O objetivo deste relatorio, ้ apresentar o Saldo dos"
Local cDesc2         := "Produtos da HONDA, considerado as quantidades solicitadas"
Local cDesc3         := "na Ordem de Expedicao."
Local cPict          := ""
Local titulo         := "Posicao de Estoque"
Local nLin           := 81
//Local Cabec1         := "Codigo	                         Descricao                                                                    Ordem de Expedicao      Saldo        Ind%     Previsao de Vendas------- "
//Local Cabec2         := "Cliente                                                                                                          Data        Quant.       Est.                 Data        Quant    Saldo" 

            //           11111111112222222222333333333344444  111111111122222  1111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000  99/99/99  999.999  999.999  99,999.99%  XXX  99/99/99  999.999
            //           0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
            //           1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
//Private tamanho      := "M"
Private nomeprog     := "FATR06" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR06" // Coloque aqui o nome do arquivo usado para impressao em disco
//Private Cabec1I :="Codigo           Descri็ใo                                          Ordem de Expedicao-------------        Ind%          Previsao de Vendas-----------------"
//Private Cabec2I :="NSB                                                               Data 	       Quant     Est                      Data          Quant    Saldo       "
Private Cabec1 := "Codigo                               Descri็ใo                                                                     Ordem de Expedicao    (A)Qtde   (B)Saldo  (A+B)Saldo       Ind% Previsao de Vendas--------- "
Private Cabec2 := "NSB                                                                                                                 Data 	   Quant   Faturada    Teorico      Fisico                 Data    Quant    Saldo "
                 //NSB                                                                                                                 Data 	   Quant   Faturada    Teorico      Fisico                 Data    Quant    Saldo "
                 //XXXXXXXXXXXXXXXxxxxxxxxxxxxxxxxxxxx  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXxxxxxxxxxxxxxxxxxxxxxxxxx  99/99/99  9,999,999  9,999,999  9,999,999  99,999,999  9,999.99%  99/99/99  999,999  999,999
Private cString := ""
Private cPerg := "FATR06"                

Pergunte(cPerg, .F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)
If mv_par01 == 1
   Cabec2 := "    NSB                                                                                                             Data 	   Quant   Faturada    Teorico      Fisico               Data    Quant    Saldo "
Else
   Cabec2 := "    CLIENTE                                                                                                         Data 	   Quant   Faturada    Teorico      Fisico               Data    Quant    Saldo "
Endif

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  20/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local DocPrev:=""

cQuery := " SELECT CK_PRODUTO,B1_DESC,A7_CODCLI,A7_DESCCLI,CK_ENTREG,SUM(CK_QTDVEN) AS QUANT, B2_QATU,(B2_QATU/SUM(CK_QTDVEN)*100) AS IND "
cQuery += " FROM SCK010 "
cQuery += " INNER JOIN SA7010 ON CK_PRODUTO = A7_PRODUTO AND A7_CLIENTE = '002' "
cQuery += " INNER JOIN SB2010 ON CK_PRODUTO = B2_COD AND CK_LOCAL = B2_LOCAL "
cQuery += " INNER JOIN SB1010 ON CK_PRODUTO=B1_COD "
cQuery += " WHERE CK_ENTREG = '"+Dtos(dDataBase)+"' AND "
cQuery += "       CK_CLIENTE = '002' AND "
cQuery += "       CK_LINHA <> ' 'AND "
cQuery += "       SCK010. D_E_L_E_T_ <> '*' AND "
cQuery += "       SA7010. D_E_L_E_T_ <> '*' AND "
cQuery += "       SB1010. D_E_L_E_T_ <> '*' "
cQuery += " GROUP BY CK_PRODUTO,B1_DESC,A7_CODCLI,A7_DESCCLI,CK_ENTREG,B2_QATU "

cQuery := ChangeQuery(cQuery)
TCQUERY cQuery Alias TCK New 

cQuery:=" select max(C4_DOC) as DOC from SC4010 WHERE C4_DATA='"+Dtos(dDataBase)+"' AND D_E_L_E_T_='' "
TCQUERY cQuery Alias TRB New       
dbSelectArea("TRB")
dbgotop()
If TRB->(!Eof())
	DocPrev:=TRB->DOC
Endif
TRB->(DbCloseArea())
//
//
dbSelectArea("TCK")
SetRegua(RecCount())
//
dbGoTop()
Do While TCK->(!EOF())

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   xProd := TCK->A7_CODCLI
   xDesc := TCK->A7_DESCCLI
   xOrigem := 'CLIENTE'
   if mv_par01 == 1
	  //Cabec1 := Cabec1I
	  //Cabec2 := Cabec2I
	  xProd  := TCK->CK_PRODUTO
	  xDesc  := TCK->B1_DESC   
	  xOrigem := 'NSB    '
   Endif 

   If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9
   Endif
      
    xData := Subs(TCK->CK_ENTREG,7,2) + "/" + Subs(TCK->CK_ENTREG,5,2)+ "/" + Subs(TCK->CK_ENTREG,3,2)

	nQtdeFat := 0
	dbSelectArea("SC6")
	dbSetOrder(2)
	dbSeek(xfilial("SC6")+TCK->CK_PRODUTO)
	While !Eof() .And. SC6->C6_FILIAL == xfilial("SC6") .And. SC6->C6_PRODUTO == TCK->CK_PRODUTO
		If SC6->C6_NOTA <> '' .And.  SC6->C6_ENTREG == dDataBase
			nQtdeFat += SC6->C6_QTDVEN
		Endif
		dbskip()
	Enddo

	dbSelectArea("TCK")
                                         
   nSldTeorico  := TCK->B2_QATU
   nSldFisico   := TCK->B2_QATU + nQtdeFat

   @ nLin,000      PSAY PadR(SUBSTRING(xProd,1,35) ,35)
   //xProd:=CK_PRODUTO
   //@ nLin,PCOL()+2 PSAY CK_PRODUTO 
   @ nLin,PCOL()+2  PSAY PadR(SUBSTRING(xDesc,1,75),75)
   @ nLin,PCOL()+2  PSAY xData                  
   @ nLin,PCOL()+2  PSAY Transform(TCK->QUANT    ,"@E 9,999,999")
   @ nLin,PCOL()+2  PSAY Transform(nQtdeFat      ,"@E 9,999,999")   
   @ nLin,PCOL()+2  PSAY Transform(nSldTeorico   ,"@E 9,999,999")
   @ nLin,PCOL()+2  PSAY Transform(nSldFisico    ,"@E 9,999,999")	   
   @ nLin,PCOL()+2  PSAY Transform(TCK->IND      ,"@E 99,999.99")+ "%"
   //
   xSaldo  := TCK->B2_QATU
   xQuant  := TCK->QUANT
   //   QtdCob  := TCK->B2_QATU-TCK->QUANT
   QtdCob  := nSldTeorico 
   UltData := dDataBase
   //
   dbSelectArea("SC4")   
   //dbSetOrder(3)   //01
   dbSetOrder(1)   //01   
   dbSeek(xfilial("SC4")+TCK->CK_PRODUTO+dTos(UltData)) 
   //
   If QtdCob>0
   
	   Do While SC4->(!Eof()) .And. SC4->C4_FILIAL+SC4->C4_PRODUTO == xfilial("SC4")+TCK->CK_PRODUTO
	    
	      If SC4->C4_DOC # DocPrev .or. SC4->C4_QUANT == 0 .or. SC4->C4_DATA <= dDataBase
	         dbskip()
		     Loop
	      EndIf
	      
   //       If QtdCob#TCK->B2_QATU-TCK->QUANT
          
 //         	 nLin++	
			 If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			    nLin := 9
			 Endif		
//          EndIf
          //
		  //UltData := SC4->C4_DATA
	      QtdCob -= SC4->C4_QUANT
          Col := 179 //IIf(mv_par01==1,139,179)
          //
          
	     @ nLin,COL      PSAY Left(Dtoc(SC4->C4_DATA),6)+Right(Dtoc(SC4->C4_DATA),2)
         @ nLin,PCOL()+2 PSAY Transform(C4_QUANT,"@E 999,999")
         @ nLin,PCOL()+2 PSAY Transform(QtdCob  ,"@E 999,999")
//         @ nLin,PCOL()+2 PSAY Transform(IND,"@E 99,999.99")+ "%"
          nLin ++
	      If QtdCob <= 0
	      	 Exit
	      EndIf               
	      
	      dbSelectArea("SC4")
	      dbskip()
	   Enddo 
   EndIf	   
   //
   dbSelectArea("TCK")
   nlin++
   @nlin,000 PSAY replicate("_",210)
   nLin++ // := nLin + 1 // Avanca a linha de impressao 
   //
   TCK->(DBSKIP()) // Avanca o ponteiro do registro no arquivo
Enddo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbClearFil(NIL)
dbCloseArea()

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

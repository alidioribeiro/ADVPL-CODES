#include "rwmake.ch"
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF
                                 
User Function EICR02()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,CBCONT,CABEC1,CABEC2,WNREL,TITULO")
SetPrvt("CDESC1,CDESC2,CDESC3,TAMANHO,LIMITE,CSTRING")
SetPrvt("AORD,LCONTINUA,CUM,LEND,ARETURN,NOMEPROG")
SetPrvt("NLASTKEY,CPERG,LI,M_PAG,NTIPO,CARQNTX")
SetPrvt("CINDCOND,XDOC,XTOTAL,XMOEDA,xDataBL")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 07/03/02 ==> 	#DEFINE PSAY SAY
#ENDIF
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ EICR02   ³ Autor ³ Jorge Silveira        ³ Data ³ 20.08.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Demonstrativo das Despezas com Importacao - NSSP.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ rdmake ESTR21 -W                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo    := PADC("Despesas com Importação.",74)
cDesc1    := PADC("Este programa tem como objetivo, apresentar um",74)
cDesc2    := PADC("Demonstrativo com as Despezas de Importação,",74)
cDesc3    := PADC("Por Documento de Entrada.",74)
tamanho   := "G"
limite    := 220
cString   := "SD1"
aOrd      := {} //-- Ordem
lContinua := .T.
cUM       := ""
lEnd      := .F.
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nomeprog  := "EICR02"
nLastKey  := 0
cPerg     := "ESTR21"
xCusto    := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

pergunte("ESTR21",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01             // Da DI                               ³
//³ mv_par02             // Ate a DI                            ³ 
//³ mv_par03             // Da Invoice                          ³
//³ mv_par04             // Ate a Invoice                       ³ 
//³ mv_par05             // Da Emissao                          ³ 
//³ mv_par06             // Ate a Emissao                       ³
//³ mv_par07             // Salta Pag. p/Invoice                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel  := "EICR02"
wnrel  := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,)

If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt  := Space(10)
cbcont := 00
li     := 80
m_pag  := 01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo := "Custo de Importacao. (Analitico)"
cabec1 := "Codigo          Descricao                      NCM             Quant      Moeda Estrangeira      Valor em Reais (R$)      Frete    Seguro        II  Siscomex      Desp      Custo   I M P O S T O  A  R E C U P E R A R  " 
cabec2 := "                                                                         Unitario      Total      Unitario      Total                                             Aduan      Total       IPI       PIS    COFINS      ICMS"
//         999999999999999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 9999999999 999.999,99 999.999,99 999.999,99 999.999,99 999.999,99 99.999,99 99.999,99 99.999,99 99.999,99 99.999,99 9.999.999,99 99.999,99 99.999,99 99.999,99 99.999,99 99.999,99 99.999,99
//         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                   11111111112222222222333333333344444444445555555555666666666677777777778         9        10        11        12        13        14        15        16        17        18        19        20        21        22

If nLastKey == 27
   Return
Endif


nTipo  := IIF(aReturn[4]==1,15,18)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)

 #IFDEF WINDOWS
      Processa( {|| RunProc() } )
      RptStatus({|| RptDetail()})
      Return
 #ENDIF
 
 ********************************
 Static Function RunProc()
 ********************************
 xSeq := 0
 dbSelectArea("SD1")
 cArqNtx  := CriaTrab(NIL,.f.)
 cIndCond := 'D1_Filial + D1_DI + D1_Invoice + D1_Cod + D1_Doc'
 IndRegua('SD1',cArqNtx,cIndCond,,,'Selecionando Registros...')

 dbSeek(xFilial("SD1") + mv_par01,.T.)
 ProcRegua(Reccount())

 While !Eof() .And. D1_DI <= mv_par02 .And. lContinua

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
       
       If D1_TES $ "300/301/302/313/398" // If AllTrim(D1_Cod) == "DESP001"
           dbSkip()
           Loop
       EndIf

       If D1_Invoice < MV_PAR03 .OR. D1_Invoice > MV_PAR04
           dbSkip()
           Loop
       EndIf

       If D1_EMISSAO < MV_PAR05 .OR. D1_EMISSAO > MV_PAR06
           dbSkip()
           Loop
       EndIf


       dbSelectArea("SZB")
       dbSetOrder(1)
       dbSeek(xFilial("SZB")+SD1->D1_INVOICE)

       dbSelectArea("SF1")
       dbSetOrder(1)
       dbSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA)
       
       dbSelectArea("SE4")
       dbSetOrder(1)
       dbSeek(xFilial("SE4")+SF1->F1_COND)

       dbSelectArea("SC7")
       dbSetOrder(1)
       dbSeek(xFilial("SC7")+SZB->ZB_PEDIDO)
             
       dbSelectArea("SD1")
       
       gReal    := 0
       gDolar   := 0
       gTotII   := 0 
       gTotSisc := 0 
       gTotIPI  := 0 
       gTotPIS  := 0 
       gTotCof  := 0 
       gTotICM  := 0 
       gDesp    := 0
       gTotal   := 0
       gFrete   := 0
       gSeguro  := 0

       xDI      := D1_DI
       xInvoice := D1_Invoice
       xEmissao := DTOC(SZB->ZB_DATAINV) // DTOC(D1_EMISSAO)
       xTaxa    := TRANSFORM(SC7->C7_TXMOEDA,"@E 999.9999999")
       xMoeda   := Iif(SC7->C7_MOEDA==2,"DOLAR","IENE ")
       xBL      := D1_BL
       xDataBL  := SZB->ZB_DATABL
       xDescri  := ALLTRIM(SE4->E4_DESCRI)
              
       While !Eof() .And. xDI == D1_DI
       
            dbSelectArea("SZB") // jorge Em 05.03.2007
            dbSetOrder(1)// jorge Em 05.03.2007
            dbSeek(xFilial("SZB")+SD1->D1_INVOICE)// jorge Em 05.03.2007
       
            dbSelectArea("SD1") // jorge Em 05.03.2007
       
            tReal  := 0
            tDolar := 0
            tDesp  := 0
            tTotal := 0
            tFrete := 0
            tSeguro:= 0
            xInvoice := D1_Invoice
            xEmissao := DTOC(SZB->ZB_DATAINV) // DTOC(D1_EMISSAO)
            While !Eof() .And. xDI == D1_DI .And. xInvoice == D1_Invoice
            
                  If D1_TES $ "300/301/302/313/398" // If AllTrim(D1_Cod) == "DESP001"
                     dbSkip()
                     Loop
                  EndIf
                       
                  aadd(xCusto,{"",;   // 01  DI
                               "",;   // 02  INVOICE
                               "",;   // 03  EMISSAO
                               0,;    // 04  TAXA
                               "",;   // 05  NR. BL
                               "",;   // 06  DESCR. PRODUTO
                               "",;   // 07  N. FISCAL
                               "",;   // 08  CODIGO PRODUTO
                               "",;   // 09  DESCRICAO CLIENTE
                               "",;   // 10  NCM
                               0,;    // 11  QUANTIDADE
                               0,;    // 12  PRECO
                               0,;    // 13  CUSTO
                               0,;    // 14  UNITARIO
                               0,;    // 15
                               0,;    // 16
                               0,;    // 17
                               0,;    // 18
                               0,;    // 19
                               "",;   // 20
                               0,;    // 21  II
                               0,;    // 22  SISCOMEX
                               0,;    // 23  IPI
                               0,;    // 24  PIS
                               0,;    // 25  COFINS
                               0})    // 26  ICMS
                  xSeq := Len(xCusto)
                  xCusto[xSeq][1] := xDI
                  xCusto[xSeq][2] := xInvoice
                  xCusto[xSeq][3] := xEMISSAO
                  xCusto[xSeq][4] := xTaxa
                  xCusto[xSeq][5] := xBL
                  xCusto[xSeq][6] := xDESCRI
                                    
                  xCod     := D1_Cod
                  tProd    := 0
                  tProdSV  := 0
                  xTotII   := 0 
                  xTotSisc := 0 
                  xTotIPI  := 0 
                  xTotPIS  := 0 
                  xTotCof  := 0 
                  xTotICM  := 0 
                  xTotDesp := 0 
                  xTotFret := 0
                  xTotSegu := 0
                  xTotGera := 0
             
                  // Calculo das despesas 
                  //---------------------------
                  While !Eof() .And. xDI == D1_DI .And. xInvoice == D1_Invoice .And. xCod == D1_Cod
                        
                        IncProc()
                        
                        If D1_TES $ "300/301/302/313/398" //If AllTrim(D1_Cod) == "DESP001"
                           dbSkip()
                           Loop
                        EndIf
       
                        dbSelectArea("SB1")
                        dbSetOrder(1)
                        dbSeek(xFilial("SB1")+SD1->D1_COD)
                  
                        dbSelectArea("SF1")
                        dbSetOrder(1)
                        dbSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA)
       
                        dbSelectArea("SC7")
                        dbSetOrder(1)
                        dbSeek(xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC)
             
                        dbSelectArea("SF4")
                        dbSetOrder(1)
                        dbSeek(xFilial("SF4")+SD1->D1_TES)
             
                        dbSelectArea("SA5")
                        dbSetOrder(2)
                        dbSeek(xFilial("SA5")+SD1->D1_COD+SD1->D1_FORNECE)
                        
                        dbSelectArea("SD1")
                        If D1_Quant > 0
                           //xTotDol := (D1_QUANT * SC7->C7_PRECO)  // Total em Dolar 
                           xTotDol := SC7->C7_TOTAL  // Jorge Em: 24/10/2007
                           xTotRea := D1_Total                    // Total em Dolar
                           xCusto[xSeq][7]  := D1_SERIE+" "+D1_DOC
                           xCusto[xSeq][8]  := D1_COD
                           xCusto[xSeq][9]  := SubStr(SA5->A5_DESCLIE,1,30)
                           xCusto[xSeq][10] := SB1->B1_POSIPI
                           xCusto[xSeq][11] := xCusto[xSeq][11] + D1_QUANT
                           xCusto[xSeq][12] := SC7->C7_PRECO
                           xCusto[xSeq][13] := xCusto[xSeq][13] + xTotDol 
                           xCusto[xSeq][14] := D1_VUNIT
                           xCusto[xSeq][15] := xCusto[xSeq][15] + D1_Total
                           xCusto[xSeq][21] := xCusto[xSeq][21] + D1_II
                           xCusto[xSeq][22] := xCusto[xSeq][22] + D1_DESPESA
                           xCusto[xSeq][23] := xCusto[xSeq][23] + D1_VALIPI
                           xCusto[xSeq][24] := xCusto[xSeq][24] + D1_VALIMP6
                           xCusto[xSeq][25] := xCusto[xSeq][25] + D1_VALIMP5
                           xCusto[xSeq][26] := xCusto[xSeq][26] + D1_VALICM
                            
                           tDolar := tDolar + xTotDol                 // Total da invoice em Dolar
                           gDolar := gDolar + xTotDol
                           tReal  := tReal  + D1_Total                // Total da invoice em Real
                           gReal  := gReal  + D1_Total
                           
                           xTotII   := xTotII   + D1_II
                           xTotSisc := xTotSisc + D1_Despesa
                           xTotIPI  := xTotIPI  + D1_ValIPI
                           xTotPIS  := xTotPIS  + D1_ValImp6
                           xTotCof  := xTotCOF  + D1_ValImp5
                           xTotICM  := xTotICM  + D1_ValICM
 
                           If SF4->F4_Duplic == "S"
                              tProd  := tProd  + D1_Total                // Total da Nota Original
                           End   
                        Else      
                           dbSelectArea("SF1")
                           dbSetOrder(1)
                           dbSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA)
       
                           dbSelectArea("SD1")
             
                           If AllTrim(D1_Fornece) == "604059"              // Seguros
                              xTotSegu := xTotSegu + D1_Total
                           ElseIf AllTrim(SF1->F1_Especie) == "NFST"    // Frete
                              xTotFret := xTotFret + D1_Total
                           Else                                         // Despesas aduaneiras
                              xTotDesp := xTotDesp + D1_Total
                           End   
                        End
                        
                        dbSkip()
                        
                  EndDo
             
                  xTotGera := (xTotFret + xTotSegu + xTotII + xTotSisc + xTotDesp + tProd)
                  
                  xCusto[xSeq][16] := xTotFret
                  xCusto[xSeq][17] := xTotSegu
                  xCusto[xSeq][18] := xTotDesp
                  xCusto[xSeq][19] := xTotGera
      
            EndDo
       Enddo
 EndDo      
 
 Return

 *********************************
 Static Function RptDetail()
 *********************************
 cbtxt  := Space(10)
 cbcont := 00

 aSort(xCusto,,,{|x,y| x[1]+x[2]+x[7]+x[8] < y[1]+y[2]+y[7]+y[8]} )
 SetRegua(Len(xCusto))
 xSeq := 1
 While xSeq<=Len(xCusto)

       IncRegua()
                             
       gDolar   := 0   // Totalizadores da DI
       gReal    := 0
       gFrete   := 0
       gSeguro  := 0
       gTotII   := 0 
       gTotSisc := 0 
       gTotIPI  := 0 
       gTotPIS  := 0 
       gTotCof  := 0 
       gTotICM  := 0 
       gDesp    := 0
       gTotal   := 0

       xDI    := xCusto[xSeq][1]
              
//       @ li,000 PSAY "DI No.: "+TRANSFORM(xDI,"@R !!/!!!!!!!-!")
//       li := li + 2               

       While xSeq<=Len(xCusto) .And. xDI==xCusto[xSeq][1]
                                      
            xInvoice := xCusto[xSeq][2]

            @ li,000 PSAY "DI No.: "+TRANSFORM(xDI,"@R !!/!!!!!!!-!")+;
                          "   INVOICE No.: "+xCusto[xSeq][2]+;
                          "   DATA: "+ xCusto[xSeq][3]+;
                          "   TAXA "+xMoeda+": " + xCusto[xSeq][4]+;
                          "   B/L No.: "+xCusto[xSeq][5]+; // +"   COND.PGTO.: "+xCusto[xSeq][6]
                          "   DATA DA B/L.: "+dtoc(xDataBL)
            li := li + 2 
                           
            tDolar   := 0 // Totalizadores da Invoice
            tReal    := 0
            tFrete   := 0
            tSeguro  := 0
            tTotII   := 0 
            tTotSisc := 0 
            tTotIPI  := 0 
            tTotPIS  := 0 
            tTotCof  := 0 
            tTotICM  := 0 
            tDesp    := 0
            tTotal   := 0
            
            While xSeq<=Len(xCusto) .And. xDI==xCusto[xSeq][1] .And. xInvoice==xCusto[xSeq][2]
            
                  xDoc     := xCusto[xSeq][7]
                  dDolar   := 0 // Totalizadores do Documento
                  dReal    := 0
                  dFrete   := 0
                  dSeguro  := 0
                  dTotII   := 0 
                  dTotSisc := 0 
                  dTotIPI  := 0 
                  dTotPIS  := 0 
                  dTotCof  := 0 
                  dTotICM  := 0 
                  dDesp    := 0
                  dTotal   := 0
                  
                  dbSelectArea("SD1")
                  dbSetOrder(1)
                  dbSeek(xFilial("SD1")+SubStr(xDoc,5,6)+SubStr(xDoc,1,3))
                  
                  dbSelectArea("SZB")
                  dbSetOrder(2)
                  dbSeek(xFilial("SZB")+SD1->D1_PEDIDO)
                  xConPag := Zb_ConPagt
                                                                                                               
                  @ li,000 PSAY "N.Fiscal: "+xDoc+"       Cond. Pagamento: "+Zb_ConPagt
                  li := li + 2
                  While xSeq<=Len(xCusto) .And. xDI==xCusto[xSeq][1] .And. xInvoice==xCusto[xSeq][2] .And. xDoc==xCusto[xSeq][7]
                  
                       // @ li,000      PSAY xCusto[xSeq][7]
                        @ li,000      PSAY xCusto[xSeq][8]
                        @ li,PCOL()+1 PSAY xCusto[xSeq][9]
                        @ li,PCOL()+1 PSAY xCusto[xSeq][10]
                        @ li,PCOL()+1 PSAY Transform(xCusto[xSeq][11],"@E 999,999.99")            // Quantidade
                        @ li,PCOL()+1 PSAY Transform(xCusto[xSeq][12],"@E 999,999.9999")          // Val.Unit U$
                        @ li,PCOL()+1 PSAY Transform(xCusto[xSeq][13],"@E 999,999.99")            // Total U$
                        @ li,PCOL()+1 PSAY Transform(xCusto[xSeq][14],"@E 999,999.99999")         // Val.Unit R$
                        @ li,PCOL()+1 PSAY Transform(xCusto[xSeq][15],"@E 999,999.99")            // Total R$
                        @ li,PCOL()+1 PSAY Transform(xCusto[xSeq][16],"@E 99,999.99")             // Frete
                        @ li,PCOL()+1 PSAY Transform(xCusto[xSeq][17],"@E 99,999.99")             // Seguro
                        @ li,PCOL()+1 PSAY Transform(xCusto[xSeq][21],"@E 99,999.99")             // II                                                                                 
                        @ li,PCOL()+1 PSAY Transform(xCusto[xSeq][22],"@E 99,999.99")             // Siscomex 
                        @ li,PCOL()+1 PSAY Transform(xCusto[xSeq][18],"@E 99,999.99")             // Desp. Aduaneiras
                        @ li,PCOL()+1 PSAY Transform(xCusto[xSeq][19],"@E 999,999.99")            // Total Geral
                        @ li,PCOL()+1 PSAY Transform(xCusto[xSeq][23],"@E 99,999.99")             // IPI
                        @ li,PCOL()+1 PSAY Transform(xCusto[xSeq][24],"@E 99,999.99")             // PIS
                        @ li,PCOL()+1 PSAY Transform(xCusto[xSeq][25],"@E 99,999.99")             // COFINS
                        @ li,PCOL()+1 PSAY Transform(xCusto[xSeq][26],"@E 99,999.99")             // ICMS

                        dDolar  := dDolar   + xCusto[xSeq][13]  // Totalizadores do Documento
                        dReal   := dReal    + xCusto[xSeq][15]
                        dFrete  := dFrete   + xCusto[xSeq][16]
                        dSeguro := dSeguro  + xCusto[xSeq][17]
                        dTotII  := dTotII   + xCusto[xSeq][21]
       					dTotSisc:= dTotSisc + xCusto[xSeq][22]
       					dTotIPI := dTotIPI  + xCusto[xSeq][23]
				        dTotPIS := dTotPIS  + xCusto[xSeq][24] 
				        dTotCof := dTotCOF  + xCusto[xSeq][25]
					    dTotICM := dTotICM  + xCusto[xSeq][26]
                        dDesp   := dDesp    + xCusto[xSeq][18]
                        dTotal  := dTotal   + xCusto[xSeq][19]
                   
                        li := li + 1 
                        xSeq := xSeq + 1
                        
                        If li > 58
                           cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
                        End 
 
                  EndDo 
                  tDolar   := tDolar   + dDolar    // Totalizadores da Invoice
                  tReal    := tReal    + dReal
                  tFrete   := tFrete   + dFrete
                  tSeguro  := tSeguro  + dSeguro
                  tTotII   := tTotII   + dTotII
                  tTotSisc := tTotSisc + dTotSisc 
                  tTotIPI  := tTotIPI  + dTotIPI 
                  tTotPIS  := tTotPIS  + dTotPIS 
                  tTotCof  := tTotCof  + dTotCof 
                  tTotICM  := tTotICM  + dTotICM 
                  tDesp    := tDesp    + dDesp
                  tTotal   := tTotal   + dTotal
                                    
                  li := li + 1 
                  @ li, 020      PSAY "Total da N.Fiscal......... "+Right(xDoc,6)
                  @ li, 082      PSAY Transform(dDolar,  "@E 999,999.99") 
                  @ li, 107      PSAY Transform(dReal,   "@E 999,999.99")
                  @ li, PCOL()+1 PSAY Transform(dFrete,  "@E 99,999.99")       
                  @ li, PCOL()+1 PSAY Transform(dSeguro, "@E 99,999.99")
                  @ li, PCOL()+1 PSAY Transform(dTotII,  "@E 99,999.99")
                  @ li, PCOL()+1 PSAY Transform(dTotSisc,"@E 99,999.99")
                  @ li, PCOL()+1 PSAY Transform(dDesp,   "@E 99,999.99")
                  @ li, PCOL()+1 PSAY Transform(dTotal,  "@E 999,999.99")
                  @ li, PCOL()+1 PSAY Transform(dTotIPI, "@E 99,999.99")
                  @ li, PCOL()+1 PSAY Transform(dTotPIS, "@E 99,999.99")
                  @ li, PCOL()+1 PSAY Transform(dTotCOF, "@E 99,999.99")
                  @ li, PCOL()+1 PSAY Transform(dTotICM, "@E 99,999.99")
                  li := li + 2
            EndDo
            gDolar   := gDolar + tDolar    // Totalizadores da Invoice
            gReal    := gReal  + tReal
            gFrete   := gFrete + tFrete
            gSeguro  := gSeguro+ tSeguro
            gTotII   := gTotII + tTotII
            gTotSisc := gTotSisc + tTotSisc 
            gTotIPI  := gTotIPI + tTotIPI 
            gTotPIS  := gTotPIS + tTotPIS 
            gTotCof  := gTotCof + tTotCof 
            gTotICM  := gTotICM + tTotICM 
            gDesp    := gDesp  + tDesp
            gTotal   := gTotal + tTotal

            @ li, 020      PSAY "Total da Invoice.......... " + xInvoice
            @ li, 082      PSAY Transform(tDolar,  "@E 999,999.99") 
            @ li, 107      PSAY Transform(tReal,   "@E 999,999.99")
            @ li, PCOL()+1 PSAY Transform(tFrete,  "@E 99,999.99")       
            @ li, PCOL()+1 PSAY Transform(tSeguro, "@E 99,999.99")
            @ li, PCOL()+1 PSAY Transform(tTotII,  "@E 99,999.99")
            @ li, PCOL()+1 PSAY Transform(tTotSisc,"@E 99,999.99")
            @ li, PCOL()+1 PSAY Transform(tDesp,   "@E 99,999.99")
            @ li, PCOL()+1 PSAY Transform(tTotal,  "@E 999,999.99")
            @ li, PCOL()+1 PSAY Transform(tTotIPI, "@E 99,999.99")
            @ li, PCOL()+1 PSAY Transform(tTotPIS, "@E 99,999.99")
            @ li, PCOL()+1 PSAY Transform(tTotCOF, "@E 99,999.99")
            @ li, PCOL()+1 PSAY Transform(tTotICM, "@E 99,999.99")
            li := li + 2
       Enddo
       @ li, 020      PSAY  "Total da DI............... " + TRANSFORM(xDI,"@R !!/!!!!!!!-!")
       @ li, 082      PSAY Transform(gDolar,  "@E 999,999.99") 
       @ li, 107      PSAY Transform(gReal,   "@E 999,999.99")
       @ li, PCOL()+1 PSAY Transform(gFrete,  "@E 99,999.99")       
       @ li, PCOL()+1 PSAY Transform(gSeguro, "@E 99,999.99")
       @ li, PCOL()+1 PSAY Transform(gTotII,  "@E 99,999.99")
       @ li, PCOL()+1 PSAY Transform(gTotSisc,"@E 99,999.99")
       @ li, PCOL()+1 PSAY Transform(gDesp,   "@E 99,999.99")
       @ li, PCOL()+1 PSAY Transform(gTotal,  "@E 999,999.99")
       @ li, PCOL()+1 PSAY Transform(gTotIPI, "@E 99,999.99")
       @ li, PCOL()+1 PSAY Transform(gTotPIS, "@E 99,999.99")
       @ li, PCOL()+1 PSAY Transform(gTotCOF, "@E 99,999.99")
       @ li, PCOL()+1 PSAY Transform(gTotICM, "@E 99,999.99")
EndDo      

 IF li != 80
       roda(cbcont,cbtxt,tamanho)
 EndIF

 Set Device To Screen

 dbSelectArea('SB1')
 RetIndex('SB1')

 dbSelectArea('SD1')
 RetIndex('SD1')

 If !(Type('ArqNtx') == 'U')
	fErase(cArqNtx)
 Endif
 
 If aReturn[5] == 1
    Set Printer to
    dbCommitAll()
    ourspool(wnrel)
 Endif
 MS_FLUSH()      
 Return


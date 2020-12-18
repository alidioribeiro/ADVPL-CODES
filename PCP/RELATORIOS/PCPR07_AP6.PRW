#include "rwmake.ch"
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function PCPR07()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,CBCONT,CABEC1,CABEC2,WNREL,TITULO")
SetPrvt("CDESC1,CDESC2,CDESC3,TAMANHO,LIMITE,CSTRING")
SetPrvt("AORD,LCONTINUA,CUM,LEND,ARETURN,NOMEPROG")
SetPrvt("NLASTKEY,CPERG,XCPI,GQUANT,GF_MPN,GF_MPI")
SetPrvt("xComp,xData,xDatFch,xMes,xCompra,xDatFin,xDatIni,xSalPed,xSaida")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PCPR02   ³ Autor ³ Jorge Silveira        ³ Data ³ 15.07.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Geracao do MRP.                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ rdmake PCPR02 -X                                           ³±±
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

titulo    := PADC("Insuficiência de Saldo.",22)
cDesc1    := PADC("Este programa tem com objetivo Verificar o saldo em processo de insumos",73)
cDesc2    := PADC("Conforme as OPs diárias Geradas apartir do Plano de Produção (SHC).",69)
cDesc3    := PADC("Pimeiramente, gera apartir da apenas a previsão das OP's (Relatório).",71)
tamanho   := "M"
limite    := 132
cString   := "SHC"
aOrd      := {} //-- Ordem
lContinua := .T.
cUM       := ""
lEnd      := .F.
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }           
nomeprog  := "PCPR07"
nLastKey  := 0
cPerg     := "PCPR05"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                             ³
//³                                                             ³
//³                                                             ³
//³                                                             ³
//³                                                             ³
//³                                                             ³
//³                                                             ³
//³                                                             ³
//³                                                             ³ 
//³                                                             ³ 
//³                                                             ³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel  := "PCPR07"
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
cCabec  := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo := "Lançamento das OP's"
cabec1 := "Produto          Descrição                      Setor              OP         Quant"
cabec2 := "                                                           Qtd Proces       Tot OPs"
//         xxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxxxx  xxxxxxxxxxx
//         12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
//                 10        20        30        40        50        60        70        80        90        100

If nLastKey == 27
   Return
Endif
 #IFDEF WINDOWS
      RptStatus({|| RptDetail()})
      Return
      Static Function RptDetail()
 #ENDIF

 nTipo  := IIF(aReturn[4]==1,15,18) 
 cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
 xSHC := {}
 dbSelectArea("SHC")
 dbSetOrder(2)
 dbSeek(xFilial("SHC") + mv_par01 + DTOS(mv_par03), .T.)
 SetRegua(RecCount())
 
 while !Eof() .And. HC_Produto <= mv_par02 .And. lContinua
       IncRegua()
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
       If HC_NUMPLAN <> mv_par05
          dbSkip()
          Loop     
       Endif
       If HC_PERIODO <> "D"
          dbSkip()
          Loop     
       Endif
       If HC_Data < mv_par03 .Or. HC_Data > mv_par04
          dbSkip()
          Loop     
       Endif
       
      dbSelectArea("SB1")
      dbSetOrder(1)
      dbSeek(xFilial("SB1")+SHC->HC_Produto)
      aadd(xSHC,{SHC->hc_produto,SHC->hc_quant,SHC->hc_data,B1_GRUPO})          
      dbSelectArea("SHC")
      dbSkip() 
 ENDDO
 asort(xSHC,,,{|x,y| x[4]+x[1]+dtos(x[3]) < y[4]+y[1]+dtos(x[3])})      
 xN   := MV_PAR06
 xInc:=1
 aCRP :={}
 While xInc<=len(xSHC) 
 	   xProduto := xSHC[xInc][01]
       dbSelectArea("SG1")  // Estrutura de Produto
       dbSetOrder(1)
       if !dbSeek(xFilial("SG1")+xProduto)
          xInc:= xInc + 1
          loop
       endif                   
       While xProduto == xSHC[xInc][01] .And. xInc <= len(xSHC) .And. lContinua
             xData := xSHC[xInc][03]
             While  xProduto == xSHC[xInc][01] .And. xData == xSHC[xInc][03] .And. xInc <= len(xSHC)
                   IncRegua()
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
                   dbSelectArea("SB1")
                   dbSetOrder(1)
                   dbSeek(xFilial("SB1")+xSHC[xInc][01])
                   xTipo := B1_Tipo
                   dbSelectArea("SG2")  // Estrutura de Produto
                   dbSetOrder(1)
                   dbSeek(xFilial("SG2")+xSHC[xInc][01])
                   cPrd    := xProduto
                   aStru   := {}
                   nEstru  := 0
                   i       := 0
                   aStru   := Estrut(cPrd)  // Obtem a estrutura
                   xSeq    := 1
                   xNumero :=substr(dtos(xSHC[xInc][03]),5,2)+substr(dtos(xSHC[xInc][03]),7,2)+substr(xN,5,2)
                   xItem   :=substr(dtos(xSHC[xInc][03]),3,2)
                   GravaSD4()
                   For i:=1 to Len(aStru)  // Monta Estrutura de Produto.
                       cComp  := aStru[i,3]
                       dbSelectArea("SG1")  // Estrutura de Produto
                       dbSetOrder(1)
                       dbSeek(xFilial("SG1")+aStru[i,2]+aStru[i,3])
                       dbSelectArea("SB1")  // Cadastro de Produto
                       dbSetOrder(1)
                       dbSeek(xFilial("SB1")+cComp)
                       xTipo := B1_Tipo
                       If ( MV_PAR03 >= SG1->G1_Ini .And. MV_PAR04 <= SG1->G1_Fim) .And. ( SB1->B1_Tipo $ "PI" )
                                dbSelectArea("SG2")  // Estrutura de Produto
                                dbSetOrder(1)
                                dbSeek(xFilial("SG2")+aStru[i,3])
                                xSeq := xSeq + 1
                                GravaSD4()
                       EndIf
                   Next
                   xInc := xInc + 1 
                   If xInc > len(xSHC)
                      exit
                   endif   
            Enddo
            xN := strzero(VAl(xN) + 1,6)
            If xInc > len(xSHC)
               exit
            endif
       Enddo      
       If xInc > len(xSHC)
          exit
       endif
 EndDo
 asort(aCRP,,,{|x,y| x[2]+x[1] < y[2]+y[1]})  
 xInc := 1
 lCond := .F.
 while xInc <= len(aCRP).And. lContinua
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
         sLinha:= aCRP[xInc][02]+" "+aCRP[xInc][03]+"  "+aCRP[xInc][06]+"  "
         cComp  := aCRP[xInc][2]
         nSaldo := aCRP[xInc][5]
         nOP  := 0
         xOPs := {}           
         while xInc <= len(aCRP) .and. cComp == aCRP[xInc][2]
               aadd(xOPs,{aCRP[xInc][01],aCRP[xInc][04]})
               nOP := nOP + aCRP[xInc][04]
               xInc := xInc + 1 
               if xInc > len(aCRP)
                  exit
               endif 
               If li > 55
                  cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
               EndIf   
         EndDo
         If nOP > nSaldo
            lCond:=.T.
            @ li,000 PSAY sLinha
            xPos := PCOL()
            for xI:=1 to len(xOPs)
                @ li,xPos      PSAY xOPs[xI][01]                           // OP
                xPos2 := PCOL()
                @ li,PCOL()+5 PSAY transform(xOPs[xI][02],"@E 99,999.99")// Quantidade
                li := li + 1
            next
            xOPs:={}
            @ li,xPos2+2  PSAY "------------"
            li := li + 1 
            @ li,xPos2-12 PSAY transform(nSaldo,"@E 9,999,999.99")     
            @ li,xPos2+2  PSAY transform(nOP,   "@E 9,999,999.99") 
            li := li + 2
         endif         
         If li > 55
            cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
         EndIf
 EndDo
 
 dbSelectArea("SX6")
 dbSetOrder(1)
 DbSeek("01"+"MV_GERAOP" )
 RecLock("SX6",.F.)
 If lCond
    X6_CONTEUD := ".F."
    X6_CONTENG := ".F."
    X6_CONTSPA := ".F."
 ELSE
    X6_CONTEUD := ".T."
    X6_CONTENG := ".T."
    X6_CONTSPA := ".T."
 EndIf
 msUnlock()    
 
 
 
 Set Device To Screen

 dbSelectArea('SHC')
 RetIndex('SHC')

 If aReturn[5] == 1
    Set Printer to
    dbCommitAll()
    ourspool(wnrel)
 Endif
 MS_FLUSH()      
 Return 
 
 **************************
 Static Function GravaSD4()
 **************************
        dbSelectArea("SG1")  // Estrutura de Produto
        dbSetOrder(1)
        dbSeek(xFilial("SG1")+iif(xTipo=="PI",cComp,xProduto))
        xCodigo := G1_cod 
        nVal:= 0
        While  xCodigo == G1_cod
               xQuant := SG1->G1_QUANT * xSHC[xInc][02] + SG1->G1_QUANT*xSHC[xInc][02]*(SG1->G1_PERDA/100)   
       		   dbSelectArea("SB1") 
               dbSetOrder(1)
               dbSeek(xFilial("SB1")+SG1->G1_comp)
               
       		   dbSelectArea("SB2") 
               dbSetOrder(1)
               dbSeek(xFilial("SB2")+SG1->G1_comp+"10")
                 Do Case
                    Case SG1->G1_LOCPRO=="01"    //  FUNDICAO
                         xSetor := "Fundicao"
                    Case SG1->G1_LOCPRO=="02"    //  USINAGEM
                         xSetor := "Usinagem"
                    Case SG1->G1_LOCPRO=="03"    //  PINTURA
                         xSetor := "Pintura "
                    Case SG1->G1_LOCPRO=="  ".OR.SG1->G1_LOCPRO=="04"  //  MONTAGEM
                         xSetor := "Montagem"
                 EndCase
               if SB1->B1_TIPO == "MP" .And. ( MV_PAR03 >= SG1->G1_Ini .And. MV_PAR04 <= SG1->G1_Fim)
                  aadd(aCRP,{xNumero+xItem+strzero(xSeq,3),;              // Numero        01
                  			 SG1->G1_comp,;                               // Produto       02
                      		 SubStr(SB1->B1_Desc,1,30),;                  // Descriçao     03
							 xQuant,;                                     // Quantidade    04
                             B2_QATU,;                                    // Saldo         05
                             xSetor,;                                     // Setor         06
                             nVal} )                                      // nOP
               endif
      		   dbSelectArea("SG1")
      		   dbskip()
      	EndDo	   
 Return()
 
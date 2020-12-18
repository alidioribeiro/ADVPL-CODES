#include "rwmake.ch"
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function PCPR05()

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
±±³Fun‡…o    ³ PCPR05   ³ Autor ³ Jorge Silveira        ³ Data ³ 15.07.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Geracao das Ordens de Producao Automaticas.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ rdmake PCPR05 -X                                           ³±±
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

titulo    := PADC("Geracao de OP's.",20)
cDesc1    := PADC("Este programa tem com objetivo, gerar Ordens de Producao (SC2)",62)
cDesc2    := PADC("conforme as Previsoes de Vendas informadas no (SC4).",35)
cDesc3    := PADC("Primeiramente, gera apenas a previsao das OP's (Relatorio).",58)
tamanho   := "M"
limite    := 132
cString   := "SC4"
aOrd      := {} //-- Ordem
lContinua := .T.
cUM       := ""
lEnd      := .F.
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }           
nomeprog  := "PCPR05"
nLastKey  := 0
cPerg     := "PCPR05"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01  N 15   // Do Produto                              ³
//³ mv_par02  N 15   // Ate o Produto                           ³
//³ MV_PAR03  D  8   // Da Data                                 ³
//³ MV_PAR04  D  8   // Ate a Data                              ³
//³ MV_PAR05  C  6   // Numero do Plano                         ³
//³ MV_PAR06  C  6   // Nr. OP Inicial                          ³
//³ MV_PAR07  N  1   // Grava OP (Sim/Nao)                      ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel  := "PCPR05"
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
//         OP             Produto        Quantidade  Descrição                       Tp  Grp.  Data      CC  TURNO RECURSO HR_I  HR_F Operação
cabec1 := "OP             Produto        Quantidade  Descrição                       Tp  Grp.  Data      CC    Operação"
cabec2 := ""
//         9999999999999  xxxxxxxxxxxxxxx   999,999  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xx  xxxx  99/99/99  xxxx  xxxxxxxxxxxxxxx
//         12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                 10        20        30        40        50        60        70        80        90        100       110      120       130       140        150       160       170       180       190       200       210       220       230       240       250       260

If nLastKey == 27
   Return
Endif

 #IFDEF WINDOWS
      RptStatus({|| RptDetail()})
      Return
      Static Function RptDetail()
 #ENDIF
 
 lCond := GetMv("MV_GERAOP")
 nTipo  := IIF(aReturn[4]==1,15,18) 
 cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
 xOPS := {}
 dbSelectArea("SC4")
 dbSetOrder(3)
 dbSeek(xFilial("SC4") + mv_par01 + DTOS(mv_par03), .T.)
 SetRegua(RecCount())
 
 While !Eof() .And. C4_Produto <= mv_par02 .And. lContinua
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
       
       If C4_Doc <> mv_par05
          dbSkip()
          Loop     
       End
       
       If C4_Data < mv_par03 .Or. C4_Data > mv_par04
          dbSkip()
          Loop     
       End
       
      dbSelectArea("SB1")
      dbSetOrder(1)
      dbSeek(xFilial("SB1")+SC4->C4_Produto)
      
      dbSelectArea("SC4")
      xQuant   := 0
      xData    := SC4->C4_Data
      xProduto := SC4->C4_Produto
      
      While !Eof() .And. xProduto == SC4->C4_Produto  .And. xData == SC4->C4_Data
             xQuant := xQuant + SC4->C4_Quant
             dbSkip()
      EndDo 
      
      If xQuant > 0
         aadd(xOPS,{xProduto,xQuant,xData,SB1->B1_GRUPO})
      End   
       
 EndDo
 
 asort(xOPS,,,{|x,y| x[4]+x[1]+dtos(x[3]) < y[4]+y[1]+dtos(y[3])})      
 
 xN   := MV_PAR06
 xInc := 1
 While xInc <= len(xOPS) 
       
       xProduto := xOPS[xInc][01]
       dbSelectArea("SG1")  // Estrutura de Produto
       dbSetOrder(1)
       
       If !dbSeek(xFilial("SG1")+xProduto)
          xInc := xInc + 1
          loop
       End                   
          
       While xProduto == xOPS[xInc][01] .And. xInc <= len(xOPS) .And. lContinua
                  
             xData := xOPS[xInc][03]
             While xInc <= len(xOPS) .And. xProduto == xOPS[xInc][01] .And. xData == xOPS[xInc][03]
                  
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
                   dbSeek(xFilial("SB1")+xOPS[xInc][01])
                   xDesc  := Subs(B1_Desc,1,30)
                   xTipo  := B1_Tipo
                   xUm    := B1_Um
                   xGrupo := B1_Grupo
                   xCC    := B1_CC
                   xLocal := B1_locPad
                   
                   dbSelectArea("SG2")  // Estrutura de Produto
                   dbSetOrder(1)
                   dbSeek(xFilial("SG2")+xOPS[xInc][01])
                   cPrd    := xProduto
                   aStru   := {}
                   nEstru  := 0
                   i       := 0
                   aStru   := Estrut(cPrd)  // Obtem a estrutura
                   xSeq    := 1
                   // Criacao do Nr. da OP: MMDDNRAA001
                   xNumero := substr(dtos(xOPS[xInc][03]),5,2)+substr(dtos(xOPS[xInc][03]),7,2)+substr(xN,5,2)
                   xItem   := substr(dtos(xOPS[xInc][03]),3,2)
                   li := li + 2
                   @ li,000      PSAY xNumero                                // Numero
                   @ li,PCOL()   PSAY "-"+xItem+"-"         	             // Item
                   @ li,PCOL()   PSAY strzero(xSeq,3)             	         // Sequencia
                   @ li,PCOL()+2 PSAY xProduto                               // PA
                   @ li,PCOL()+3 PSAY TRANSFORM(xOPS[xInc][02],"@E 999,999") // Quantidade
                   @ li,PCOL()+2 PSAY xDesc                                  // Descriçao
                   @ li,PCOL()+2 PSAY xTipo                                  // Tipo
                   @ li,PCOL()+2 PSAY xGrupo                                 // Grupo
                   @ li,PCOL()+2 PSAY (xOPS[xInc][03])              	     // Data
                   @ li,PCOL()+2 PSAY xCC                                    // CC
                   @ li,PCOL()+2 PSAY SubStr(SG2->G2_Descri,1,30) 	         // Operaçao
                   
                   If mv_par07 == 1 .And. lCond
                      GravaSC2() // Tab. de Ordem de Produção
                      GravaSD4() // Empelhos
                   EndIf   
                                                                                 
                   li := li + 1             
                   For i:=1 to Len(aStru)  // Monta Estrutura de Produto.
                       cComp  := aStru[i,3]
                       cQnec  := 0
                       xSetor := ""
                       dbSelectArea("SG1")  // Estrutura de Produto
                       dbSetOrder(1)
                       dbSeek(xFilial("SG1")+aStru[i,2]+aStru[i,3])
                       
                       dbSelectArea("SB1")  // Cadastro de Produto
                       dbSetOrder(1)
                       dbSeek(xFilial("SB1")+cComp)
                       xUm   := B1_Um
                       //xGrupo:= B1_Grupo
                       xCC   := B1_CC
                       xTipo := B1_Tipo
                       xLocal:= B1_locPad
                       cQnec := ( aStru[i,4] * xOPS[xInc][02] + aStru[i,4] * xOPS[xInc][02] * (SG1->G1_PERDA/100) )
                                                                                                                        
                       If ( MV_PAR03 >= SG1->G1_Ini .And. MV_PAR04 <= SG1->G1_Fim) .And. ( SB1->B1_Tipo $ "PI" ) .And. cQnec > 0
                                dbSelectArea("SG2")  // Estrutura de Produto
                                dbSetOrder(1)
                                dbSeek(xFilial("SG2")+aStru[i,3])
                                xSeq := xSeq + 1
                                @ li,000      PSAY xNumero                       // Numero da O.P.
                                @ li,PCOL()   PSAY "-"+xItem+"-"                 // Item
                                @ li,PCOL()   PSAY strzero(xSeq,3)               // Sequencia
                                @ li,PCOL()+2 PSAY cComp                         // Componente
                                @ li,PCOL()+3 PSAY Transform(cQnec,"@E 999,999") // Quantidade
                                @ li,PCOL()+2 PSAY SubStr(SB1->B1_Desc,1,30)     // Descriçao
                                @ li,PCOL()+2 PSAY SB1->B1_Tipo                  // Tipo
                                @ li,PCOL()+2 PSAY SB1->B1_Grupo                 // Grupo
                                @ li,PCOL()+2 PSAY (xOPS[xInc][03])              // Data 
                                @ li,PCOL()+2 PSAY SB1->B1_CC                    // CC
                                @ li,PCOL()+2 PSAY (SG2->G2_Descri)              // Operaçao
                                li := li + 1
                                If (mv_par07 == 1) .And. lCond
                                   GravaSC2()
                                   GravaSD4()
                                EndIf   
                                If li > 55
                                   cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
                                EndIf     
                       EndIf
                      
                   Next
                        
                   xInc := xInc + 1 
                   
                   If xInc > len(xOPS)
                      exit
                   End   
             Enddo
             xN := strzero(VAl(xN) + 1,6)
             If xInc > len(xOPS)
                exit
             End
       Enddo      
      If xInc > len(xOPS)
         exit
      End
 EndDo  

 Set Device To Screen

 dbSelectArea('SC4')
 RetIndex('SC4')
 
 If (mv_par07 == 1) .And. !lCond
    MsgStop("OPs Não Geradas em funcao de Insuficiência de Saldos no Processo para conclusao das mesmas.")
 End 
 
 If aReturn[5] == 1
    Set Printer to
    dbCommitAll()
    ourspool(wnrel)
 End
 MS_FLUSH()      
 Return 
 
 **************************
 Static Function GravaSC2()
 **************************
       
        DBSelectArea("SC2")
        DbSetOrder(1)
        if !DbSeek(xFilial("SC2")+xNumero + xItem + strzero(xSeq,3))
    	     RecLock("SC2",.T.)
      	     C2_FILIAL := "01"
             C2_NUM    := xNumero
    	     C2_ITEM   := xItem
             C2_SEQUEN := strzero(xSeq,3)
        	 C2_PRODUTO:= iif(xTipo=="PI",cComp,xProduto)
        	 C2_LOCAL  := iif(xTipo=="PI","10","01")
       		 C2_CC     := xCC
       		 C2_QUANT  := iif(xTipo=="PI",cQnec,xOPS[xInc][02])
        	 C2_UM     := xUM
        	 C2_DATPRI := xOPS[xInc][03]
        	 C2_DATPRF := xOPS[xInc][03]
        	 C2_EMISSAO:= DDATABASE
        	 C2_PRIOR  := "500"
        	 C2_DESTINA:= iif(xTipo=="PI","E","")
        	 C2_SEQPAI := iif(xTipo=="PI",strzero(xSeq-1,3),"")
        	 C2_TPOP   := "F"
        	 msUnlock()
        	 GravaSB2(C2_PRODUTO,C2_PRODUTO,xTipo,C2_QUANT) 
        endif	 
 Return()
 
 **************************
 Static Function GravaSD4()
 **************************
        dbSelectArea("SG1")  // Estrutura de Produto
        dbSetOrder(1)
        dbSeek(xFilial("SG1")+iif(xTipo=="PI",cComp,xProduto))
        xCodigo := G1_cod
        While  !SG1->(EOF()) .and. xCodigo == G1_cod
               if (MV_PAR03 >= SG1->G1_Ini .And. MV_PAR04 <= SG1->G1_Fim)      
                  DBSelectArea("SD4")
                  DbSetOrder(1) 
                  if !DbSeek(xFilial("SD4")+xNumero+xItem+strzero(xSeq,3)+SG1->G1_comp)
                      //nQuant := SG1->G1_QUANT * xOPS[xInc][02] + SG1->G1_QUANT*xOPS[xInc][02]*(SG1->G1_PERDA/100) Alterado 07/03/2016 Nilton Cardoso
                      nQuant := SG1->G1_QUANT*xOPS[xInc][02]*(SG1->G1_PERDA/100)
		                  RecLock("SD4",.T.)
    		              D4_FILIAL := "01"
        		    	  D4_COD    := SG1->G1_comp
		        	      D4_LOCAL  := "10"
    		      	      D4_OP     := xNumero+xItem+strzero(xSeq,3) 
        		   	      D4_DATA   := xOPS[xInc][03]
		            	  D4_QTDEORI:= nQuant
    		     	      D4_QUANT  := nQuant
        		     	  D4_OPORIG :=iif(xTipo=="PI",xNumero+xItem+strzero(xSeq,3),"")
      		  		      msUnlock()
      		  		      GravaSB2(SG1->G1_comp,"10",xTipo,nQuant) 
      		  		  endif    
      	       endif   
      		     dbSelectArea("SG1")
      		     dbskip()
      	EndDo	   
      	
 Return () 
 
**************************
Static Function GravaSB2(cProd,cLoc,cTipo,nQuant)
**************************
     DbSelectArea("SB2")
     DbSetorder(1)
     if !DbSeek(xFilial("SB2")+cProd+cLoc)
       	CriaSB2(cProd,cLoc)               
     Endif  	
     RecLock("SB2",.F.)
     B2_SALPEDI := B2_SALPEDI + nQuant
     B2_QEMP    := iif(xTipo ="PA",B2_QEMP,B2_QEMP+nQuant)  
     MsUnlock()
Return

#include "rwmake.ch"
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function PCPR02()

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

titulo    := PADC("MRP - Necessidades de Materiais.",74)
cDesc1    := PADC("Este programa tem com objetivo, gerar as necessidades das Materias",74)
cDesc2    := PADC("Primas, conforme Plano Mestre de Producao.",74)
cDesc3    := PADC("O Saldo em estoque é calculado até a data base.",74)
tamanho   := "G"
limite    := 220
cString   := "SHC"
aOrd      := {} //-- Ordem
lContinua := .T.
cUM       := ""
lEnd      := .F.
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nomeprog  := "PCPR02"
nLastKey  := 0
cPerg     := "PCPR02"
cMes    := {}
aadd(cMes,{"Jan","31","08"})
aadd(cMes,{"Fev","28","09"})
aadd(cMes,{"Mar","31","10"})
aadd(cMes,{"Abr","30","11"})
aadd(cMes,{"Mai","31","12"})
aadd(cMes,{"Jun","30","01"})
aadd(cMes,{"Jul","31","02"})
aadd(cMes,{"Ago","31","03"})
aadd(cMes,{"Set","30","04"})
aadd(cMes,{"Out","31","05"})
aadd(cMes,{"Nov","30","06"})
aadd(cMes,{"Dez","31","07"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01  C  6   // Periodo Incial (mmaaaa)                 ³
//³ mv_par02  C  6   // Periodo Final (mmaaaa)                  ³
//³ mv_par03  N 15   // Do Produto                              ³
//³ mv_par04  N 15   // Ate o Produto                           ³
//³ MV_PAR05  N  1   // Origem Insumos (Em Manaus/Outro Estado/Importado   ³
//³ MV_PAR06  N  1   // Do Grupo de Materiais                   ³
//³ MV_PAR07  N  1   // Até o Grupo de Materiais                ³
//³ MV_PAR08  N  1   // Saldo: Atual/Mensal/Inventariado        ³
//³ MV_PAR09  N  1   // Salta Pagina (Sim/Nao)                  ³ 
//³ MV_PAR10  N  1   // Gera Solcitacao Automatica (Sim/Nao) Obs. Somente Nacionais 
//³ MV_PAR11  N  1   // Considera Estoque PA (Sim/Nao)          ³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel  := "PCPR02"
wnrel  := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,)

If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Mv_par05 == 3
 //  MsgStop("Opção de MRP para Importação, em fase de desenvolvimento pelo TI.")
 //  Return
End

cbtxt  := Space(10)
cbcont := 00
li     := 80
m_pag  := 01
cCabec  := ""
xQuant  := 0
cDiaIni := "01"
cMesIni := Val(subs(mv_par01,1,2))
cMesFin := Val(subs(mv_par02,1,2))
cAnoIni := Val(subs(mv_par01,3,4))
cDiaFin := cMes[cMesFin][02]
cAnoFin := Val(subs(mv_par02,3,4))
cDatIni := Ctod( cDiaIni+"/"+StrZero(cMesIni,2)+"/"+StrZero(cAnoIni,4) )
cDatFin := Ctod( cDiaFin+"/"+StrZero(cMesFin,2)+"/"+StrZero(cAnoFin,4) )

If ((cMesIni-cMesFin) < 7 .And. cAnoIni < cAnoFin) .Or.((cMesFin - cMesIni) >= 6 .And. cAnoIni == cAnoFin) 
   MsgStop("Periodo Estipulado, Ultrapasa 6 meses...")
   Return
ElseIf cMesIni > cMesFin .And. cAnoIni >= cAnoFin
   MsgStop("Periodo Inicial maior que Periodo Final...")
   Return
ElseIf cMesIni > 12 .or. cMesFin > 12
   MsgStop("Mes Invalido...")
   Return
ElseIf cMesIni == cMesFin .And. cAnoIni == cAnoFin
   xQuant := 1
ElseIf cMesIni < cMesFin .And. cAnoIni == cAnoFin
   xQuant := cMesFin - cMesIni + 1
ElseIf cMesIni > cMesFin .And. cAnoIni < cAnoFin
   xQuant := 13 - (cMesIni - cMesFin)
End
If mv_par08 ==1
   cSaldo :=" Mensal"
elseif mv_par08 ==2
   cSaldo :="  Atual"
elseif mv_par08 ==3
   cSaldo :="Invent."
endif
  
dbSelectArea("SX6")
dbSetOrder(1)
DbSeek("01"+"MV_ULMES" ) 
xDatFch := CTOD(SX6->X6_CONTEUD)

// --------------------------------------------
// Monta cabecalho para impressao de relatorio.
// --------------------------------------------

dbSelectArea("SHC")
dbSetOrder(1)
dbSeek(xFilial("SHC") + dtos(cDatIni), .T.)

xCOL   := 055
xPOS   := {}
xMESES := {}
xIni   := HC_Data
While xIni <= cDatFin
    If Ascan( xMESES, MONTH(xIni)) == 0
       aadd(xMESES ,MONTH(xIni) )
       aadd(xPOS   ,xCOL )
       cCabec  := cCabec + cMes[MONTH(xIni)][1]+"/"+StrZero(year(xIni),4)+"     "
       xCOL := xCOL + 13
    Endif
    xIni := xIni + 1
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo := "MRP - Necessidade de Materiais"
cabec1 := "Codigo          Descricao                                Tp Grp Um Setor        "+cCabec+"        E  S  T  O  Q  U  E                      Compras Mes"
cabec2 := "                                                                               "+space(len(cCabec))+"Seguranca      "+cSaldo+"     Transito  Recebimento     "+cMes[IIF(MONTH(HC_Data)+1>12,MONTH(HC_Data)-11,MONTH(HC_Data)+1)][1]+"/"+StrZero(IIF(MONTH(HC_Data)+1>12,year(HC_Data)+1,year(HC_Data)),4)
//         999999999999999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xx xxx xx xxxxxxxx  999,999,999           999,999,999  999,999,999  999,999,999       999999999999
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

 xGerMes := {} 
 gQMES := 0
 gVMES := 0
 gFMES := 0
        
 For xI := 1 to xQuant
     xM := StrZero(xI,2)
     cQuant := "gQmes"+xM
     nMes   := "vMes"+StrZero(iif(cMesIni+xI-1>12,cMesIni+xI-13,cMesIni+xI-1),2) 
     &cQuant:= 0
     &nMes  := xI 
//     MSGSTOP(nMes+"="+strZERO(&nMes,2))          //teste
 Next    

 nTipo  := IIF(aReturn[4]==1,15,18) 
 cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)

 dbSelectArea("SHC")
 dbSetOrder(2)
 dbSeek(xFilial("SHC") + mv_par03, .T.)
 SetRegua(RecCount())
         
 xMRP := {}
 While !Eof() .And. HC_Produto <= mv_par04 .And. lContinua
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
       
       If HC_Data <= cDatIni .Or. HC_Data > cDatFin
          dbSkip()
          Loop     
       End
       
       nMes := "vMes"+StrZero(month(SHC->HC_Data),2)
       If substr(mv_par09,&nMes,1) # SHC->HC_Periodo  
          // dbSkip()
          // Loop 
       End
     
       xProduto := HC_Produto
       xPassa   := .T.
       
       While !Eof() .And. xProduto == HC_Produto
       
             If HC_Data < cDatIni .Or. HC_Data > cDatFin
                dbSkip()
                Loop     
             End
             nMes := "vMes"+strzero(month(SHC->HC_Data),2)
             if substr(mv_par09,&nMes,1)#SHC->HC_Periodo  
               // dbSkip()
               // Loop
             End
     
             If HC_NumPlan <> "01"
	            dbSkip()
	            Loop     
	         End

             dbSelectArea("SB1")
             dbSetOrder(1)
             dbSeek(xFilial("SB1")+SHC->HC_Produto)
             xDesc := Subs(B1_Desc,1,40)
             xTipo := B1_Tipo
             xUm   := B1_Um
             
             cPrd    := xProduto
             aStru   := {}
             nEstru  := 0
             i       := 0
             aStru   := Estrut(cPrd)  // Obtem a estrutura

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
                 
                 /*
                 If     mv_par05==1 .And. mv_par05#3 .And. B1_Manaus # "S" 
                           xPassa := .F.
                 ElseIf mv_par05==2 .And. mv_par05#3 .And. B1_Manaus == "S" 
                           xPassa := .F. 
                 ElseIf mv_par05==3 .And. mv_par05#3 .And. B1_Manaus == "S" 
                           xPassa := .F. 
                 End */
                    
                 If B1_Grupo < mv_par06 .Or. B1_Grupo > mv_par07
                    xPassa := .F. 
                 End   
                 
                 If B1_MRP # "S"
                    xPassa := .F. 
                 End
                 
                 Do Case
                    Case SG1->G1_LOCPRO=="01"    //  FUNDICAO
                         xSetor := "Inj.Plas"
                    Case SG1->G1_LOCPRO=="02"    //  USINAGEM
                         xSetor := "Usinagem"
                    Case SG1->G1_LOCPRO=="03"    //  PINTURA
                         xSetor := "Impress."
                    Case SG1->G1_LOCPRO=="  ".OR.SG1->G1_LOCPRO=="04"  //  MONTAGEM
                         xSetor := "Montagem"
                    OtherWise
                         xSetor := "Externo "
                 EndCase
                 
                 If ( cDatIni >= SG1->G1_Ini .And. cDatFin <= SG1->G1_Fim) .And.;
                    ( SB1->B1_Tipo $ "MP" ) .And. xPassa
                    
                     cQnec := aStru[i,4] * SHC->HC_Quant
                   
                        aadd(xMRP, {xProduto,;                   // 01 Produto
                                    cComp,;                      // 02 Componente
                                    Substr(SB1->B1_desc,1,40),;  // 03 Descricao
                                    SB1->B1_Tipo,;               // 04 Tipo
                                    Substr(SB1->B1_Grupo,1,3),;  // 05 Grupo
                                    SB1->B1_Um,;                 // 06 Unidade Medida
                                    xSetor,;                     // 07 Setor
                                    cQnec,;                      // 08 Quantidade
                                    SHC->HC_Data })              // 09 Data
                 EndIf
                 xPassa   := .T.
             
             Next
              
             dbSelectArea("SHC")
             dbSkip()

       Enddo      
 
 Enddo  
 
 asort(xMRP,,,{|x,y| x[2]+dtos(x[9]) < y[2]+dtos(y[9]) })
 
 i:=1
 While i <= len(xMRP)
 
       If     mv_par08 == 1
          dbSelectArea("SB9")  // Saldos Iniciais
          dbSetOrder(1)
          dbSeek(xFilial("SB9")+xMRP[i][02]+"01"+dtos(xDatFch))
          xSaldo := SB9->B9_QINI
       ElseIf mv_par08 == 2
          dbSelectArea("SB2")  // Saldos Iniciais     
          dbSetOrder(1)
          dbSeek(xFilial("SB2")+xMRP[i][02]+"01")
          xSaldo := B2_QATU
       ElseIf mv_par08 == 3
          dbSelectArea("SZ9")  // Saldos Iniciais
          dbSetOrder(2)
          dbSeek(xFilial("SZ9")+"01"+xMRP[i][02])
          xSaldo := Z9_TERCONT
       EndIf       
     
       dbSelectArea("SB1")  // Cadastro de Produto
       dbSetOrder(1)
       dbSeek(xFilial("SB1")+xMRP[i][02])
      
       dbSelectArea("SB2")  // Transito
       dbSetOrder(1)
       dbSeek(xFilial("SB2")+xMRP[i][02]+"01")
 
       @ li,000      PSAY xMRP[i][02]   // Componente
       @ li,PCOL()+1 PSAY xMRP[i][03]   // Descricao
       @ li,PCOL()+1 PSAY xMRP[i][04]   // Tipo
       @ li,PCOL()+1 PSAY xMRP[i][05]   // Grupo
       @ li,PCOL()+1 PSAY xMRP[i][06]   // Um
       @ li,PCOL()+1 PSAY xMRP[i][07]   // Setor 
 
       xComp   := xMRP[i][02] // Componente
       xPmes   := 1
       xCompra := 0
       xTotPMes:= 0
       xPs     := PCOL() + 2
       While xComp == xMRP[i][02]
     
             xData := Month(xMRP[i][09]) // Data
             xTotProd := 0
           
             While xComp==xMRP[i][02] .And. xData==Month(xMRP[i][09])
                   xTotProd := xTotProd + xMRP[i][08]
                   nMes := "vMes"+strzero(Month(xMRP[i][09]),2)
                   xPos  := &nMes - 1
                   i := i + 1
                   If i > len(xMRP)
                      exit
                   EndIf
     		 EndDo
        
             If xPmes == 2 .And. i <= len(xMRP)
                SalPed()
                Recebe()
             EndIf
 
             If xPmes <= iif(mv_par05==1,2,3) .And. i <= len(xMRP)
                xTotPMes := xTotPMes + xTotProd
             EndIf
             xPmes := xPmes + 1
             @ li,xPs + (xPos*13) PSAY transform(xTotProd,"@E 999,999,999")   // TESTE
                                                                        
             If i > len(xMRP)
                exit
             EndIf
           
       EndDo 
       xCompra := (xTotPMes+SB1->B1_ESTSEG-xSaldo-xSalPed-xSaida)
    // Verifica Lote Minino de Compra.
       If xCompra > 0 .And. xCompra < SB1->B1_LM
          xCompra := SB1->B1_LM
       endif
     
       @ li,len(cCabec)+77 PSAY Transform(SB1->B1_ESTSEG,"@E 999,999,999")
       @ li,PCOL()+2       PSAY Transform(xSaldo,        "@E 999,999,999")
       @ li,PCOL()+2       PSAY Transform(xSalPed,       "@E 999,999,999")
       @ li,PCOL()+2       PSAY Transform(xSaida,        "@E 999,999,999")
       @ li,PCOL()+2       PSAY Transform(If(xCompra>0,xCompra,0),"@E 999,999,999")
        
   	   li := li + 1
 	 
       If li > 55
          cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
       End
	 
 EndDo
   
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
 
 ************************************
 Static Function SalPed()
 ************************************
 
        If Month(xMRP[i][09]) > 6
           xDatIni := Ctod( "01/"+cMes[Month(cDatIni)][03]+"/"+StrZero(cAnoIni,4) )
        Else
           xDatIni := Ctod( "01/"+cMes[Month(cDatIni)][03]+"/"+StrZero(cAnoIni-1,4))
        End
        
        
        dbSelectArea('SC7')
        dbSetOrder(7)
        dbSeek(xFilial('SC7')+xComp+dtos(xDatIni),.T.)
        xSalPed := 0
        xSaida  := 0
        xDatFin :=Ctod(cMes[Month(cDatIni)][02]+"/"+StrZero(Month(cDatIni),2)+"/"+StrZero(cAnoIni,4))
 
        While !Eof() .And. xComp == C7_Produto .And. C7_Datprf <= xDatFin
              xSalPed := xSalPed + (C7_Quant - C7_Quje)
              dbSkip()
        Enddo
       
 Return(xSalPed)
 
 Static Function Recebe()
        
        xDatFin :=Ctod("01"+"/"+StrZero(Month(cDatIni),2)+"/"+StrZero(cAnoIni,4))
        dbSelectArea('SD1')
        dbSetOrder(7)
        dbSeek(xFilial('SD1')+xComp+'01'+dtos(xDatFin),.T.)
        xSaida := 0 
        
        While xComp == D1_COD .And. D1_DTDIGIT <= DDatabase
              xSaida  := xSaida  + D1_QUANT
              DBSkip()
        EndDo
        
 Return(xSaida)

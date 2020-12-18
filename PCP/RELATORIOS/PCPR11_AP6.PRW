#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 07/03/02
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function PCPR11a()        // incluido pelo assistente de conversao do AP5 IDE em 07/03/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,CBCONT,CABEC1,CABEC2,WNREL,TITULO")
SetPrvt("CDESC1,CDESC2,CDESC3,TAMANHO,LIMITE,CSTRING")
SetPrvt("AORD,LCONTINUA,LEND,ARETURN,NOMEPROG,NLASTKEY")
SetPrvt("CPERG,CMES,LI,M_PAG,CCABEC,XQUANT")
SetPrvt("CDIAINI,CMESINI,CMESFIN,CANOINI,CDIAFIN,CANOFIN")
SetPrvt("CDATINI,CDATFIN,XCOL,XPOS,XDIAS,XINI")
SetPrvt("NTIPO,XGERMES,GQMES,GVMES,GFMES,GQMES01")
SetPrvt("GQMES02,GQMES03,GQMES04,GQMES05,GQMES06,GQMES07")
SetPrvt("GQMES08,GQMES09,GQMES10,GQMES11,GQMES12,XTOTMES")
SetPrvt("XAMES,XQMES,XVMES,XFMES,XTOTQ,XTOTV")
SetPrvt("XTOTF,XI,XM,CVAR,XMEDQ,XMEDV")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 07/03/02 ==> 	#DEFINE PSAY SAY
#ENDIF
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ COMR01   ³ Autor ³ Jorge Silveira        ³ Data ³ 22.10.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Compras de Materiais, Mes a Mes.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ rdmake COMR01 -x                                           ³±±
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
 
titulo    := PADC("Acompanhamento da Producao.",74)
cDesc1    := PADC("Este Programa tem como objetivo, emitir de demonstrar a Producao",74)
cDesc2    := PADC("diaria X Pranejamento de Producao no Mes especificado em Parametros.",74)
cDesc3    := ""
tamanho   := "G"
limite    := 220
cString   := "SH6"
aOrd      := {} //-- Ordem
lContinua := .T.
lEnd      := .F.
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nomeprog  := "PCPR11"
nLastKey  := 0
cPerg     := "PCPR11"

cMes    := {}
aadd(cMes,{"Janeiro"  ,"31"})
aadd(cMes,{"Fevereiro","28"})
aadd(cMes,{"Março"    ,"31"})
aadd(cMes,{"Abril"    ,"30"})
aadd(cMes,{"Maio"     ,"31"})
aadd(cMes,{"Junho"    ,"30"})
aadd(cMes,{"Julho"    ,"31"})
aadd(cMes,{"Agosto"   ,"31"})
aadd(cMes,{"Setembro" ,"30"})
aadd(cMes,{"Outuro"   ,"31"})
aadd(cMes,{"Novembro" ,"30"})
aadd(cMes,{"Dezembro" ,"31"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

pergunte("PCPR11",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01             // Periodo Incial (mmaaaa)             ³
//³ mv_par02             // Periodo Final (mmaaaa)              ³ 
//³ mv_par03             // Do Produto                          ³ 
//³ mv_par04             // Ate o Produto                       ³
//³ mv_par05             // Do Tipo                             ³ 
//³ mv_par06             // Ate o Tipo                          ³
//³ mv_par07             // Do Grupo                            ³ 
//³ mv_par08             // Ate o Grupo                         ³
//³ mv_par09             // Impr.Produto S/Mov. (Sim/Nao)       ³
//³ mv_par10             // Origem (Nacional/Importado/Local)   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel  := "PCPR11"

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
xQuant  := 0
cDiaIni := "01"
nMes := Val(subs(mv_par01,1,2))
cAno := Val(subs(mv_par01,3,4))
cDiaFin := cMes[nMes][02]
cDatIni := Ctod( cDiaIni+"/"+StrZero(nMes,2)+"/"+StrZero(cAno,4) )
cDatFin := Ctod( cDiaFin+"/"+StrZero(nMes,2)+"/"+StrZero(cAno,4) )
xQuant:=VAL(cDiaFin)
If  nMes > 12
   MsgStop("Mes Invalido...")
   Return
End

// --------------------------------------------
// Monta cabecalho para impressao de relatorio.
// --------------------------------------------
xDIAS  := {}
xIni := cDatIni

If MV_PAR02==1
   xSetor:="ACABAMENTO"
ELSEIF MV_PAR02==2
   xSetor:="USINAGEM"
ELSEIF MV_PAR02==3
   xSetor:="PINTURA"
ELSEIF MV_PAR02==4
   xSetor:="MONTAGEM"
ENDIF   

If nLastKey == 27
   Return
Endif

#IFDEF WINDOWS
      RptStatus({|| RptDetail()})
      Return
      Static Function RptDetail()
#ENDIF

 For xI := 1 to xQuant
     xM := StrZero(xI,2)
     cQuant  := "gQmes"+xM
     cValor  := "gQval"+xM
     &cQuant := 0
     &cValor := 0
 Next    
 
 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 //³ Inicio do Processamento da Nota Fiscal                       ³
 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 
 dbSelectArea("SC2")
 cArqSC2 := CriaTrab(NIL,.F. )
 cKeySC2 := "C2_Filial+DTOS(C2_DATPRI)+C2_PRODUTO"
 IndRegua("SC2",cArqSC2,cKeySC2,,,"Selecionando Registros...")
 dbselectarea("SC2")
 dbSeek(xFilial("SC2")+dtos(cDatIni),.T.)
 SetRegua(RecCount())
 xRAP  :={}
 xCabec:={}
 xSH6  :={}
 While !eOF() .AND. C2_DATPRI <= cDatFin
       IncRegua()
       xDATA := C2_DATPRI
       WHILE !eOF() .AND. xDATA == C2_DATPRI
             xPlan:=0
             xProduto := SC2->C2_PRODUTO
             xOP:=SC2->C2_NUM+SC2->C2_ITEM
             While !eof() .AND. xDATA == C2_DATPRI .and. xProduto == SC2->C2_PRODUTO
                   xPlan:=xPlan+SC2->C2_QUANT
                   DBSKIP()
             EndDo
             
             dbSelectArea("SG2")
             dbSetorder(1)
             If DBSEEK(xFILIAL("SG2")+xProduto)
                If xSETOR==ALLTRIM(SG2->G2_DESCRI)
                   AADD(xRAP,{xData,xProduto,xPlan,xOP})
                   If ascan(xCabec,strzero(day(xDATA),2))==0
                      aadd(xCabec,strzero(day(xDATA),2)) 
                   EndIf 
                EndIf
             EndIf
             dbSelectArea("SC2")  // Eu
       EndDo
   
 EndDo
 
 DBSELECTAREA("SH6")
 cArqSH6 := CriaTrab(NIL,.F. )
 cKeySH6 := "H6_Filial+DTOS(H6_DTAPONT)+H6_PRODUTO"
 IndRegua("SH6",cArqSH6,cKeySH6,,,"Selecionando Registros...")
 dbselectarea("SH6")
 dbSeek(xFilial("SH6")+dtos(cDatIni),.T.)
 xI:=1
 While !Eof() .And. H6_DTAPONT <= cDatFin
       xPRD:= 0
       xNC := 0
       xPRODUTO:=H6_PRODUTO
       xDATA:=H6_DTAPONT
       WHILE !Eof() .And. xDATA==H6_DTAPONT .AND. xProduto==H6_PRODUTO
              xPRD := xPRD + H6_QTDPROD
              xNC  := xNC  + H6_QTDPERD
              DBSKIP()
       ENDDO
       dbSelectArea("SG2")
       dbSetorder(1)
       
       
         
       
       IF !dbSeek(xFilial("SG2")+xProduto)
          MSGSTOP("PRODUTO: "+xPRODUTO+" SEM ROTEIRO DE OPERAÇAO")
          DBSKIP()
          LOOP
       Else   
          If xSetor == AllTrim(SG2->G2_DESCRI)
             AADD(xSH6,{xData,xProduto,xPRD+xNC})
             If ascan(xCabec,strzero(day(xDATA),2))==0
                aadd(xCabec,strzero(day(xDATA),2)) 
             EndIf 
          EndIf
       ENDIF
       DBSELECTAREA("SH6")  
 ENDDO
 asort(xRAP,,,{|x,y| x[2]+dtos(x[1]) < y[2]+dtos(y[1]) })
 asort(xSH6,,,{|x,y| x[2]+dtos(x[1]) < y[2]+dtos(y[1]) })
 cCabec:= ""
 xCOL   :=38 
 xPOS   := {}
 for xI:=1 to len(xCabec)
     cCabec := cCabec +"|    "+xCabec[xI]
     aadd(xPOS,{xCOL,xCabec[xI]})
     xCol:= xCol+7
 next   
 
 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 //³ Definicao dos cabecalhos                                     ³
 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

 titulo := "Produção diaria do mes de "+cMes[nMes][01]+" - "+xSetor
 cabec1 := "Modelo / Dias de Producao:          " + cCabec+ "|     TOTAL"
 cabec2 := ""
         // 123456789012345678901234567890
         
 nTipo  := IIF(aReturn[4]==1,15,18)                           // Eu
 cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)           // Eu
   
 xI:=1
 While xI <= len(xRAP) .And. lContinua
       IncRegua()
       If mv_par03 <= xRAP[xI][2] .or. mv_par04 >= xRAP[xI][2]
          dbSelectArea("SB1")
          dbSeek(xFILIAL("SB1")+xRAP[xI][2])
   
          dbSelectArea("SC2")
          dbSetorder(1)
          dbSeek(xFILIAL("SC2")+xRAP[xI][4]+"001")
    
          @ li,000  PSAY ALLTRIM(C2_PRODUTO)+" ("+ALLTRIM(SB1->B1_COD)+")"
          @ li,032  PSAY "P"
          xJ:=xI
          xProd := xRAP[xI][2]
          xPL:=0
          while xI <= len(xRAP) .And. xProd==xRAP[xI][2] 
                xDia := DAY(xRAP[xI][1])
                NP:=ascan(xPos,{|x| x[2]==strzero(xDia,2)})
                @ li,xPos[nP][1] PSAY Transform(xRAP[xI][3],"@E 9,999") 
                xPL := xPL + xRAP[xI][3]
                xM     := STRZERO(xDIA,2)
                cQuant := "gQmes" + xM
                &cQuant:= &cQuant + xRAP[xI][3]
                xI := xI + 1
                IF xI > len(xRAP)
                   EXIT
                ENDIF    
          Enddo
          
          @ li,xCOL+3 PSAY Transform(xPL,"@E 99,999")
          LI:=LI+1
          @ li,000  PSAY SUBS(SB1->B1_DESC,1,30)
          @ li,032  PSAY "R"
          xRE:=0
          xProd := xRAP[xJ][2]
          if ascan(xSH6,{|x| x[2]==xPROD})<>0
             xJ:=ascan(xSH6,{|x| x[2]==xPROD})
             While xJ <= len(xSH6) .And. xProd==xSH6[xJ][2] 
                xDia := DAY(xSH6[xJ][1])
                NP:=ascan(xPos,{|x| x[2]==strzero(xDia,2)})
                @ li,xPos[nP][1] PSAY Transform(xSH6[xJ][3],"@E 9,999") 
                xRE := xRE + xSH6[xJ][3]
                xM     := STRZERO(xDIA,2)
                cValor  := "gQval" + xM
                &cValor:= &cValor + xSH6[xJ][3]
                xJ := xJ + 1
                IF xJ > len(xSH6)
                   EXIT
                ENDIF    
             Enddo
          endif 
          @ li,xCOL+3 PSAY Transform(xRE,"@E 99,999")
          li := li + 1
          @ li,000 PSAY REPLICATE("-",LIMITE)
          li := li + 1
 
          If li > 55
             cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
          End
       Endif
       
       IF xI > len(xRAP)
          EXIT
       ENDIF
       
 Enddo

 li := li + 1
 
 @ li,000 PSAY "TOTAIS:"
 li := li + 1
 @ li,000 PSAY "PREVISTO:"
 nTotQ := 0
 For xI:= 1 to LEN(xPos) 
     xM := xPOS[xI][2]
     cQuant := "gQmes"+ xM
     nTotQ  :=  nTotQ + &cQuant
     IF &cQuant<>0
        @ li,xPos[xI][1]-1 PSAY Transform( &cQuant ,"@E 99,999")
     ENDIF   
 Next
 @ li,xCOL+2 PSAY Transform( nTotQ ,"@E 999,999")
 li:=li+1
 @ li,000 PSAY "REAL:"
 nTotV  := 0
 For xI:= 1 to LEN(xPos)
     xM := xPOS[xI][2]
     cValor := "gQval" + xM
     nTotV  :=  nTotV  + &cValor
     IF &cValor<>0
        @ li,xPos[xI][1]-1 PSAY Transform( &cValor ,"@E 99,999")
     ENDIF   
 Next
 @ li,xCOL+2 PSAY Transform( nTotV ,"@E 999,999") 

 IF li != 80
       roda(cbcont,cbtxt,tamanho)
 EndIF

 Set Device To Screen
 If !(Type('ArqNtx') == 'U')
	fErase(cArqSH6)
 Endif
If !(Type('ArqNtx') == 'U')
	fErase(cArqSC2)
 Endif

 dbSelectArea('SH6')
 RetIndex('SH6')
 DbSelectArea('SC2')                
 RetIndex('SC2')                     

 If aReturn[5] == 1
    Set Printer to
    dbCommitAll()
    ourspool(wnrel)
 Endif
 MS_FLUSH()      
 Return


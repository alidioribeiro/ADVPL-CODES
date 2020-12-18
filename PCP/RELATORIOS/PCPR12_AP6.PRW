#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 07/03/02
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function PCPR12()        // incluido pelo assistente de conversao do AP5 IDE em 07/03/02

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
/*
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
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 
titulo    := PADC("Análise de Produção Diária.",27)
cDesc1    := PADC("Este Programa tem como objetivo verificar o andamento da produção",65)
cDesc2    := PADC("Diariamente, Conforme especificações em Parâmetros.",50)
cDesc3    := ""
tamanho   := "M"
limite    := 120
cString   := "SH6"
aOrd      := {} //-- Ordem
lContinua := .T.
lEnd      := .F.
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nomeprog  := "PCPR12"
nLastKey  := 0
cPerg     := "PCPR12"

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

pergunte("PCPR12",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ mv_par01             // Do Produto                          ³ 
//³ mv_par02             // Ate o Produto                       ³
//³ mv_par03             // Data de Referencia                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel  := "PCPR12"

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

 cData:=right(dtos(mv_par03),2)+" de "+cMes[month(mv_par03)][1]+" de "+left(dtos(mv_par03),4)   
 titulo:="Acompanhamento da Produção"
 cabec1:="Data de referência: "+cData
 cabec2 := "Código          Descrição                      Grp   Plano   Hora   FUN   USI   PIN   MON"
         // XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX xxxx 99.999  99:99 9.999 9.999 9.999 9.999
         // 123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

 nTipo  := IIF(aReturn[4]==1,15,18)                           
 cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)              

If nLastKey == 27
   Return
Endif
 
#IFDEF WINDOWS
      RptStatus({|| RptDetail()})
      Return
      Static Function RptDetail()
#ENDIF
 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 //³ Inicio do Processamento da Nota Fiscal                       ³
 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 
 dbSelectArea("SH6")
 cArqSH6 := CriaTrab(NIL,.F. )
 cKeySH6 := "H6_Filial+DTOS(H6_DTAPONT)+H6_PRODUTO+H6_HORAFIN"
 cFilSH6 := "H6_FILIAL='"+xFilial("SH6")+"' .AND. DTOS(H6_DTAPONT)=='"+DTOS(MV_PAR03)+"'"
 IndRegua("SH6",cArqSH6,cKeySH6,,cFilSH6,"Selecionando Registros...")
 dbselectarea("SH6")
 dbGOTOP()
 
 dbSelectArea("SC2")  
 dbSetorder(1)
 dbSeek(xFILIAL("SC2")+SubStr(SH6->H6_OP,1,8)+"001")
 
 SetRegua(RecCount())
 xRAP  :={}
 xCabec:={}
 While !eOF()
       IncRegua()
 
       If Empty(SH6->H6_DTApont)
          dbSkip()
          Loop
       EndIf   
       dbSelectArea("SC2")  
       dbSeek(xFILIAL("SC2")+SubStr(SH6->H6_OP,1,8)+"001")
       xPRD   := SC2->C2_PRODUTO
       IF xPrd < mv_par01 .or. xPrd > mv_par02
          DBSELECTAREA("SH6")
          DBSKIP()
          loop
       endif   
       dbSelectArea("SG2")  
       IF dbSeek(xFILIAL("SG2")+SH6->H6_produto)
          xQuant:=SH6->H6_qtdprod+SH6->H6_qtdperd
          IF ALLTRIM(SG2->G2_DESCRI)=="ACABAMENTO"             
             AADD(xRAP,{xPrd,"01",xQUANT,SH6->H6_HORAFIN})
          ELSEIF ALLTRIM(SG2->G2_DESCRI)=="USINAGEM"                   
             AADD(xRAP,{xPrd,"02",xQUANT,SH6->H6_HORAFIN})
          ELSEIF ALLTRIM(SG2->G2_DESCRI)=="PINTURA"                   
             AADD(xRAP,{xPrd,"03",xQUANT,SH6->H6_HORAFIN})
          ELSEIF ALLTRIM(SG2->G2_DESCRI)=="MONTAGEM"                   
             AADD(xRAP,{xPrd,"04",xQUANT,SH6->H6_HORAFIN})
          ENDIF
       ENDIF         
       DBSELECTAREA("SH6")
       DBSKIP()
 EndDo
 asort(xRAP,,,{|x,y| x[1]+x[2]+x[4] < y[1]+y[2]+y[4] })
 If len(xRAP)==0
    msgstop("Não há dados gerados para esse relatório. Verifique os parâmetros.")
    return
 endif   
 
 xI:=1
 dbSelectArea("SC2")  
 dbSetorder(2)
 dbSeek(xFILIAL("SC2")+xRAP[xI][1]+DTOS(MV_PAR03))
 dbSelectArea("SB1")  
 dbSetorder(1)
 dbSeek(xFILIAL("SB1")+xRAP[xI][1])
 WHILE xI<=LEN(xRAP)
     
      dbSelectArea("SC2")  
      IF dbSeek(xFILIAL("SC2")+xRAP[xI][1]+DTOS(MV_PAR03))
          xNEC:=C2_QUANT
      ELSE
          xNEC:=0
      ENDIF
      dbSelectArea("SB1")  
      dbSeek(xFILIAL("SB1")+xRAP[xI][1])
      @ li,000       PSAY B1_COD
      @ li,PCOL()+1  PSAY substr(B1_DESC,1,30)
      @ li,PCOL()+1  PSAY B1_grupo
      @ li,PCOL()+1  PSAY TRANSFORM(xNEC,"@E 99,999")
      xPos:=PCOL()+2
      xFUN08:=0
      xFUN11:=0
      xFUN16:=0
      xUSI08:=0
      xUSI11:=0
      xUSI16:=0
      xPIN08:=0
      xPIN11:=0
      xPIN16:=0
      xMON08:=0
      xMON11:=0
      xMON16:=0
      xPROD:=xRAP[xI][1]
      WHILE xRAP[xI][1]==xPROD
            do case
            case xRAP[xI][2]=="01"
               
                        IF xRAP[xI][4]<="08:00" 
                             xFUN08:=xFUN08+xRAP[xI][3]
                        ENDIF
                        IF xRAP[xI][4]<="11:00"
                             xFUN11:=xFUN11+xRAP[xI][3]
                        ENDIF
                        IF xRAP[xI][4]<="16:00"
                             xFUN16:=xFUN16+xRAP[xI][3]
                        ENDIF
                    
                     xI := xI + 1 
      
                     if xI>len(xRAP)
                        exit
                     endif   
            case xRAP[xI][2]=="02" 
               
                        IF xRAP[xI][4]<="08:00"
                             xUSI08:=xUSI08+xRAP[xI][3]
                        END
                        IF xRAP[xI][4]<="11:00"
                             xUSI11:=xUSI11+xRAP[xI][3]
                        END
                        IF xRAP[xI][4]<="16:00"
                             xUSI16:=xUSI16+xRAP[xI][3]
                        END
                     
                     xI := xI + 1 
                     if xI>len(xRAP)
                        exit
                     endif
            case xRAP[xI][2]=="03"
               
                        IF xRAP[xI][4]<="08:00"
                             xPIN08:=xPIN08+xRAP[xI][3]
                        END
                        IF xRAP[xI][4]<="11:00"
                             xPIN11:=xPIN11+xRAP[xI][3]
                        END
                        IF xRAP[xI][4]<="16:00"
                             xPIN16:=xPIN16+xRAP[xI][3]
                        END
                     xI := xI + 1 
                     if xI>len(xRAP)
                        exit
                     endif
                           
            case xRAP[xI][2]=="04"
               
                        IF xRAP[xI][4]<="08:00"
                             xMON08:=xMON08+xRAP[xI][3]
                        END
                        IF xRAP[xI][4]<="11:00"
                             xMON11:=xMON11+xRAP[xI][3]
                        END
                        IF xRAP[xI][4]<="16:00"
                             xMON16:=xMON16+xRAP[xI][3]
                        END
                     xI := xI + 1 
                     if xI>len(xRAP)
                        exit
                     endif
            ENDCASE
           
            if xI>len(xRAP)
               exit
            endif
            if xI>len(xRAP)
               exit
            endif
      enddo

      @ li,xPos  PSAY "08:00"      
      @ li,xPos+6  PSAY TRANSFORM(xFUN08,"@E 9,999")+" "+TRANSFORM(xUSI08,"@E 9,999");
      +" "+TRANSFORM(xPIN08,"@E 9,999")+" "+TRANSFORM(xMON08,"@E 9,999")
      li := li + 1
      @ li,xPos  PSAY "11:00"
      @ li,xPos+6  PSAY TRANSFORM(xFUN11,"@E 9,999")+" "+TRANSFORM(xUSI11,"@E 9,999");
      +" "+TRANSFORM(xPIN11,"@E 9,999")+" "+TRANSFORM(xMON11,"@E 9,999")
      li := li + 1
      @ li,xPos  PSAY "16:00"
      @ li,xPos+6  PSAY TRANSFORM(xFUN16,"@E 9,999")+" "+TRANSFORM(xUSI16,"@E 9,999");
      +" "+TRANSFORM(xPIN16,"@E 9,999")+" "+TRANSFORM(xMON16,"@E 9,999")
      li := li + 2
      If li > 55
         cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
      End 
      if xI>len(xRAP)
         exit
      endif
 enddo   
 
 IF li != 80
       roda(cbcont,cbtxt,tamanho)
 EndIF

 Set Device To Screen
 If !(Type('ArqSH6') == 'U')
	fErase(cArqSH6)
 Endif


 dbSelectArea('SH6')
 RetIndex('SH6')

 If aReturn[5] == 1
    Set Printer to
    dbCommitAll()
    ourspool(wnrel)
 Endif
 MS_FLUSH()      
 Return


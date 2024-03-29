#include "rwmake.ch"
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function PCPR10()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("CBTXT,CBCONT,CABEC1,CABEC2,WNREL,TITULO")
SetPrvt("CDESC1,CDESC2,CDESC3,TAMANHO,LIMITE,CSTRING")
SetPrvt("AORD,LCONTINUA,CUM,LEND,ARETURN,NOMEPROG")
SetPrvt("NLASTKEY,CPERG,XGERVO,XGERVP,XGERSA,_CFLAG")
SetPrvt("LI,M_PAG,NTIPO,CARQNTX,CINDCOND,	XGERQTD")
SetPrvt("XGERVAL,XGERIPI,XCODIGO,ThMaq,TmMaq,TtMaq")
SetPrvt("XTOTIPI,TPerda,GPerda,xPerdas,TProd,GProd")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 08/03/02 ==> 	#DEFINE PSAY SAY
#ENDIF
/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � MATR24   � Autor � Jorge Silveira        � Data � 06.04.00 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Relacao dos Apontamentos da Producao.                      낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � rdmake MATR24 -x                                           낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      �                                                            낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Define Variaveis                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

titulo    := "Apontamento da Procucao"
cDesc1    := "Este programa tem com objetivo, imprimir a Relacao dos Apontamentos de Producao,"
cDesc2    := "por Recurso ou Linha de Producao, no periodo especificado."
cDesc3    := ""
tamanho   := "M"
limite    := 132
cString   := "SC2"
aOrd      := {} //-- Ordem
lContinua := .T.
cUM       := ""
lEnd      := .F.
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "PCPR10"
nLastKey  := 0
cPerg     := "PCPR10"
xGerVo    := 0
xGerVp    := 0
xGerSa    := 0
xPerdas   := {}
_cFlag    :=.t.

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Verifica as perguntas selecionadas                          �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

pergunte("PCPR10",.F.)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Variaveis utilizadas para parametros                        �
//� mv_par01             // Da Data                             �
//� mv_par02             // Ate a Data                          �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Envia controle para a funcao SETPRINT                       �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

wnrel  := "PCPR10"
wnrel  := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,)

If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cbcont := 00
li     := 80
m_pag  := 01

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Definicao dos cabecalhos                                     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

titulo := "Relacao dos Apontamentos de Producao."
cabec1 := "DATA      OP           CODIGO           DESCRI플O                      NECESSID       SETOR PRODUCAO    PERDA  INDICE"
cabec2 := "Entre: "+dtoc(mv_par01)+" e "+dtoc(mv_par02)
//         99/99/99  99999999999  xxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  999.999  XXXXXXXXXX  999.999  999.999  999.99  
//         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//                   1111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222222223333333333

If nLastKey == 27
   Return
Endif

nTipo  := IIF(aReturn[4]==1,15,18)

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)

#IFDEF WINDOWS
      RptStatus({|| DetMatr23()})
      Return
#ENDIF
           

 
Static Function DetMatr23()
 
 //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
 //� Inicio da Impressao                                          �
 //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
xMeta   :=0
xQuant_A:=0
xNC_A   :=0
xQuant_U:=0
xNC_U   :=0      
xQuant_P:=0
xNC_P   :=0   
xQuant_M:=0
xNC_M   :=0
  
 dbSelectArea("SH6")
 cArqSC2 := CriaTrab(NIL,.F. )
 //cKeySC2 := "H6_Filial+DTOS(H6_DATAINI)+H6_OP+H6_KAMBAN" // IndexKey()
 cKeySC2 := "H6_Filial+DTOS(H6_DATAINI)+H6_OP+H6_KAMBAN"
 IndRegua("SH6",cArqSC2,cKeySC2,,,"Selecionando Registros...")
 //nIndex1 := RetIndex("SC2")
   
 dbselectarea("SH6")
 DBSEEK(xFilial("SH6")+dtos(mv_par01))

 SetRegua(RecCount())
 
 While !eOF() .AND. H6_DATAINI <= MV_PAR02
       
       IncRegua()
       
       If Empty(H6_DATAINI)
          dbSkip()
          Loop
       EndIf   
       
       dbSelectArea("SC2")  
       dbSetorder(1)
       If !dbSeek(xFilial("SC2")+SubStr(SH6->H6_OP,1,8)+"001")
           MSGSTOP("OP NR. "+SubStr(SH6->H6_OP,1,8)+"001 Nao Cadastrada no SC2. Verifique...")
           DBSELECTAREA("SH6")
           dbSkip()
           Loop
       End    
       
       dbSelectArea("SB1")
       dbSetorder(1)
       dbSeek(xFILIAL("SB1")+SC2->C2_PRODUTO)
       cDesc := SubStr(SB1->B1_DESC,1,30)
       nPoney:= B1_QTPoney  
       dbSelectArea("SH6")  
       
       @ li,000      PSAY H6_DATAINI
       @ li,PCOL()+2 PSAY SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN    
       @ li,PCOL()+2 PSAY SC2->C2_PRODUTO
       @ li,PCOL()+2 PSAY cDesc
       @ li,PCOL()+2 PSAY TRANSFORM(SC2->C2_QUANT, "@E 999,999")
       xPos := PCOL()+2
          
       While !eof() .and. SUBSTR(H6_OP,1,6) == SC2->C2_NUM 
             
             DBSELECTAREA("SC2")  
             DBSEEK(xFILIAL("SC2")+SH6->H6_OP)
             xOP   := SH6->H6_OP
             xProd := SC2->C2_PRODUTO 
             xQuant:= 0
             xNC   := 0
             
             IF nPoney <> 0 
                nTcar  := SC2->C2_QUANT/nPoney
             ELSE
                nTcar  := 1
             endif
             if mod(nTcar,1)<>0
                nTcar:= int(nTcar)+1
             EndIf   
             xCar:=0
             DBSELECTAREA("SH6")
             
             While !eof() .and. xOP == SH6->H6_OP
                   If mv_par03==1
                      @ li,XpOS + 8 PSAY H6_Kamban
                      @ li,PCOL()+2 PSAY TRANSFORM(SH6->H6_qtdprod, "@E 999,999") 
                      @ li,PCOL()+2 PSAY TRANSFORM(SH6->H6_QTDPERD, "@E 999,999")
                      li:=li+1
                   endif
                   xQuant  := xQuant+SH6->H6_qtdprod
                   xNC     := xNC+SH6->H6_QTDPERD
                   xCar    := xCar+1
                   DBSKIP()
             ENDDO
             dbSelectArea("SG2")
             dbSetorder(1)
             IF DBSEEK(xFILIAL("SG2")+xProd)
                IF ALLTRIM(SG2->G2_DESCRI)<>"INJETORA"
                   @ li,XpOS     PSAY SUBSTR(SG2->G2_DESCRI,1,10)
                   @ li,PCOL()+2 PSAY TRANSFORM(xQuant, "@E 999,999")
                   @ li,PCOL()+2 PSAY TRANSFORM(xNC, "@E 999,999")
                   @ li,PCOL()+2 PSAY TRANSFORM((xNC+xQuant)/SC2->C2_QUANT*100, "@E 999.99")
                   @ li,PCOL()+2 PSAY strzero(xCar,2)+"/"+strzero(nTcar,2)
                   li := li + 1
                ENDIF
                IF ALLTRIM(SG2->G2_DESCRI)=="ACABAMENTO"             
                   xQuant_A:= xQuant_A+ xQuant
                   xNC_A   := xNC_A   + xNC
                ELSEIF ALLTRIM(SG2->G2_DESCRI)=="USINAGEM"                   
                   xQuant_U:= xQuant_U+ xQuant
                   xNC_U   := xNC_U   + xNC     
                ELSEIF ALLTRIM(SG2->G2_DESCRI)=="PINTURA"                   
                   xQuant_P:= xQuant_P+ xQuant
                   xNC_P   := xNC_P   + xNC 
                ELSEIF ALLTRIM(SG2->G2_DESCRI)=="MONTAGEM"                   
                   xQuant_M:= xQuant_M+ xQuant
                   xNC_M   := xNC_M   + xNC
                ENDIF
             ELSE
               MSGSTOP("O Produto de c�digo: "+xProd+" Nao Possui roteiro de opera豫o cadastrado. Verifique...") 
             ENDIF       
             dbselectarea("SH6") 
       ENDDO
       Li := li + 1
       xMeta := xMeta + SC2->C2_QUANT
                    
       If li > 70
          cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
       End
 EndDo                                  	
 
 xInA:= (xQuant_A+xNC_A)/xMeta*100
 xInU:= (xQuant_U+xNC_U)/xMeta*100
 xInP:= (xQuant_P+xNC_P)/xMeta*100
 xInM:= (xQuant_M+xNC_M)/xMeta*100
 cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
 li:=li+2
 @ li,000      PSAY "RESUMO DO PERIODO:"
 li:=li+1
 @ li,000      PSAY " "
 li:=li+1
 @ li,000      PSAY "SETOR                |      P R O D U � � O      |       INDICE"             
 li:=li+1
 @ li,000      PSAY "                     |Planejado Produzido   Perda|           "
 li:=li+1
 @ li,000      PSAY "ACABAMENTO            "+TRANSFORM(xMeta,"@E 9,999,999")+" "+TRANSFORM(xQuant_A,"@E 9,999,999")+" "+TRANSFORM(xNC_A,"@E 999,999")+space(7)+TRANSFORM(xInA,"@E 999.99%")
 li:=li+1
 @ li,000      PSAY "USINAGEM              "+TRANSFORM(xMeta,"@E 9,999,999")+" "+TRANSFORM(xQuant_U,"@E 9,999,999")+" "+TRANSFORM(xNC_U,"@E 999,999")+space(7)+TRANSFORM(xInU,"@E 999.99%")
 li:=li+1
 @ li,000      PSAY "PINTURA               "+TRANSFORM(xMeta,"@E 9,999,999")+" "+TRANSFORM(xQuant_P,"@E 9,999,999")+" "+TRANSFORM(xNC_P,"@E 999,999")+space(7)+TRANSFORM(xInP,"@E 999.99%")
 li:=li+1                                                                                                                                                                    
 @ li,000      PSAY "MONTAGEM              "+TRANSFORM(xMeta,"@E 9,999,999")+" "+TRANSFORM(xQuant_M,"@E 9,999,999")+" "+TRANSFORM(xNC_M,"@E 999,999")+space(7)+TRANSFORM(xInM,"@E 999.99%")
 IF li != 80
       roda(cbcont,cbtxt,tamanho)
 EndIF

 Set Device To Screen 
 Set Filter To 

 dbSelectArea('SH6')
 RetIndex('SH6')

 If !(Type('ArqSC2') == 'U')
    fErase(cArqSC2)
 Endif
                                                                                                
 If aReturn[5] == 1
    Set Printer to
    dbCommitAll()
    ourspool(wnrel)
 Endif
 MS_FLUSH()
 
Return


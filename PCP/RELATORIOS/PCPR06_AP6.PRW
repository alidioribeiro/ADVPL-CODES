#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 08/03/02

User Function PCPR06()        // incluido pelo assistente de conversao do AP5 IDE em 08/03/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CSTRING,_CPERG,CARQTXT,NHDLARQ")
SetPrvt("_CGRAVA,XMODELO,XLINHA,XI,XQTD")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Fatr03   ³ Autor ³ JORGE SILVEIRA        ³ Data ³ 22.11.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Geracao de arquivo texto com faturamento no periodo.       ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

cString := "SC2"
_cPerg  := "PCPR06"
Pergunte(_cPerg,.T.)

@ 96,42 TO 323,505 DIALOG oDlg5 TITLE "Arquivo de Exportação das OP's."
@ 8,10 TO 84,222
@ 91,139 BMPBUTTON TYPE 5 ACTION Pergunte("PCPR06")
@ 91,168 BMPBUTTON TYPE 1 ACTION OkProc()
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
@ 23,14 SAY "Este programa tem como objetivo, gerar arquivo em modo texto"
@ 33,14 SAY "ao LUCAS 9000, para controle de Produção."
@ 43,14 SAY ""
@ 53,14 SAY ""
ACTIVATE DIALOG oDlg5

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³OkProc    ³ Autor ³ JORGE SILVEIRA        ³ Data ³ 27.10.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Confirma o Processamento                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
PARAMETROS:
mv_par01   A Partir da Data
mv_par02   Ate a Data
mv_par03   Nome do Arquivo

*/
Static Function OkProc()

cArqTxt := AllTrim(mv_par05)+".TXT" 

If !Empty(cArqTxt)
   Close(oDlg5)
   Processa( { || RunProc() }, "Geracao de Arquivo Texto.")
Else
   MsgAlert("Arquivo Texto Nao Especificado.")
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RunProc   ³ Autor ³ JORGE SILVEIRA        ³ Data ³ 27.10.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Executa o Processamento                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RunProc()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria os Arquivos Texto.                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbselectarea("SZA")
dbclosearea()
//use \DADOSADV\sza010 alias "SZA" EXCLUSIVE
IF AbreExcl("SZA")
   Zap
ELSE
MSGSTOP("Este programa requer acesso exclusivo ao módulo do PCP.")
return
ENDIF   
cErro  := ""
bErro  := .F.
cErroP := ""
bErroP := .F.
nHdlArq := FCreate(cArqTxt)
dbSelectArea("SC2")
cArqNtx  := CriaTrab(NIL,.f.)
cIndCond := 'C2_Filial + DTOS(C2_DATPRI)+C2_NUM+C2_ITEM+C2_SEQUEN'
IndRegua('SC2',cArqNtx,cIndCond,,,)
dbSeek(xFilial("SC2")+DTOS(MV_PAR01), .T.)
While !Eof() .And. C2_DATPRI <= mv_par02

      IncProc()
      IF C2_NUM < MV_PAR03 .OR. C2_NUM > MV_PAR04
         DBSKIP()
         LOOP
      ENDIF   
      
      dbSelectArea("SG2")
      dbSetOrder(1)
      dbSeek(xFilial("SG2")+SC2->C2_PRODUTO) 

      dbSelectArea("SB1")
      dbSetOrder(1)
      dbSeek(xFilial("SB1")+SC2->C2_PRODUTO)
      
      If SC2->C2_SEQUEN=="001"
         IF B1_QTPONEY <> 0 
            nQuant := SC2->C2_QUANT/B1_QTPONEY
            qTPoney:= B1_QTPONEY
         ELSE
            nQuant := 1
            qTPoney:= SC2->C2_QUANT
            cErroP := cErro+alltrim(SC2->C2_PRODUTO)+", "
            bErroP := .T.
         endif
         if mod(nQuant,1)<>0
            nQuant:= int(nQuant)+1
         EndIf
      Endif
      IF ALLTRIM(SG2->G2_DESCRI)<>""
         IF ALLTRIM(SG2->G2_DESCRI)<>"INJETORA"
            FOR I:=1 TO nQuant
                _cGrava   := ""
                dData := Substr(DTOS(SC2->C2_DATPRI),7,2)+Substr(DTOS(SC2->C2_DATPRI),5,2)+Substr(DTOS(SC2->C2_DATPRI),1,4)
                _cGrava := ""
                _cGrava := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+strzero(I,2) 
                _cGrava := _cGrava + SUBSTR(SB1->B1_DESC,1,32) 
                _cGrava := _cGrava + SUBSTR(SG2->G2_DESCRI,1,9)
                _cGrava := _cGrava + dData
                _cGrava := _cGrava + Chr(13) + Chr(10)           // Caracteres de Fim de Linha
                FWrite(nHdlArq,_cGrava,Len(_cGrava))
                dbselectarea("SZA")
                reclock("SZA",.T.)
                SZA->ZA_OPNUM := SC2->C2_NUM
                SZA->ZA_ITEM  := SC2->C2_ITEM
                SZA->ZA_SEQUEN:= SC2->C2_SEQUEN
                SZA->ZA_KAMBAN:= strzero(I,2)
                SZA->ZA_QTKAMB:= int(qTPoney)
                SZA->ZA_PROD  := SC2->C2_PRODUTO
                SZA->ZA_DESCRI:= SUBSTR(SB1->B1_DESC,1,32) 
                SZA->ZA_CCUSTO:= SUBSTR(SG2->G2_DESCRI,1,9)
                SZA->ZA_DATA  := SC2->C2_DATPRI
                SZA->ZA_QUANT := nQuant
                msunlock()
            Next
         Endif   
      ELSE
         cErro:=cErro+ALLTRIM(SC2->C2_PRODUTO)+", "
         bErro:=.T.
      ENDIF
      dbSelectArea("SC2")
      dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha o Arquivo Texto.                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  FClose(nHdlArq)  
  
  If !(Type('ArqNtx') == 'U')
	fErase(cArqNtx)
  Endif
  dbSelectArea('SC2')
  RetIndex('SC2')
  MsgBox ("Arquivo "+cArqTxt+" gerado com sucesso!","Informaçäo","INFO")
  If bErro
     MsgStop("O(s) produto(s) "+cErro+"não possui(em) roteiro de operação cadastrado. Caso não seja corrigido, a impressam das fichas estará comprometida. Corriga e gere novamente o arquivo.")
  Endif   
  If bErroP
     MsgStop("O(s) produto(s) "+cErroP+"não possui(em) Quatidade de peças por poney. Caso não seja corrigido, a impressam das fichas estará comprometida. Corriga e gere novamente o arquivo.")
  Endif   
  
   dbselectarea("SZA")
   dbCloseArea()

Return
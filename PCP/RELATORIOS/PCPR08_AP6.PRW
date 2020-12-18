#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

User Function PCPR08()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NOPCA,ODLG,CMENS,CGRV,CGRVF1,CGRVD1")
SetPrvt("XOCORR,CTYPE,CARQUIVO,ACPO,CTRB,CSTRING")
SetPrvt("CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN,NOMEPROG")
SetPrvt("LCONTINUA,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,LI,M_PAG,WNREL,TVALDOC")
SetPrvt("TVALPAG,TTOTAL,NTIPO,XVALDOC,XVALPAG,XPOS")
SetPrvt("XTIPMOV,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPPAG   ³ Autor ³Jorge Silveira da Silva³ Data ³ 12.10.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Importacao de arquivo de retorno. (Pagto a Fornecedores)   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

nOpca  := 0
oDlg   := ""
cMens  := ""
cGrv   := ""
cGrvF1 := ""
cGrvD1 := ""


@ 96,13 To 310,592 DIALOG oDlg TITLE "Leitura do Arquivo Retorno - Movimento de Produção."
@ 18, 6 To 66, 287
@ 29, 15 SAY OemToAnsi("Este programa tem como objetivo Importar dados dos arquivos selecionados.")
@ 80, 160 BUTTON "Importar"  SIZE 34, 11 ACTION PG010I()// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> @ 80, 160 BUTTON "Importar"  SIZE 34, 11 ACTION Execute(PG010I)
@ 80, 220 BMPBUTTON TYPE 2 ACTION PG010Fim()// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> @ 80, 220 BMPBUTTON TYPE 2 ACTION Execute(PG010Fim)
ACTIVATE DIALOG oDlg
Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PG010I   ³ Autor ³Jorge Silveira da Silva³ Data ³ 12.10.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Importacao de dados                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function PG010I()

nOpca    := 0
cType    := "Importacao Lucas9000 | *.TXT"
cArquivo := cGetFile(cType, OemToAnsi("Selecione arquivo "+Subs(cType,1,7)))

If !Empty( cArquivo )
    If File( cArquivo) 
             nOpca := 1
    Else  
             MsgAlert("Arquivo nao encontrado")
    Endif
Endif

If nOpca == 1
   Processa({|| ProcImp()})
EndIf
Close(oDlg)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ProcImp   ³ Autor ³Jorge Silveira da Silva³ Data ³ 12.10.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processamento de Importacao dos Dados                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ProcImp()

// PARAMETRO
// mv_par01  N   1    ->  Hora do apontamento.  

//pergunte("PCPR08",.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo de Trabalho.                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  aCpo := {}
  AADD(aCpo,{"TR_OP"    ,"C",011,0})
  AADD(aCpo,{"TR_SEQ"   ,"C",002,0})  // 02
  AADD(aCpo,{"TR_DESC"  ,"C",032,0})  
  AADD(aCpo,{"TR_SETOR" ,"C",009,0})
  AADD(aCpo,{"TR_DATA"  ,"C",008,0})  // 05
  AADD(aCpo,{"TR_QUANT" ,"C",011,0})
  AADD(aCpo,{"TR_NC"    ,"C",011,0})  // 08
  AADD(aCpo,{"TR_DTAPON","C",008,0})  // 08
  AADD(aCpo,{"TR_HORA"  ,"C",006,0})  // 08
  cTRB   := CriaTrab(aCpo,.T.)
  dbUseArea(.T.,,cTRB,"TRB",.T.,.F.)
 // IndRegua( "TRB", cTRB, "TR_DOC",,,"Criando Indice ..." )
  Append From &(cArquivo) SDF // DELIMITED

  PG020I()  // Impressao do Relatorio.

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ PG020I  ³ Autor ³ Jorge Silveira da Silva³ Data ³ 12.10.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Impressao do Arq. de Retorno ( Cartao Salario ).            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function PG020I
Static Function PG020I()
cString :="TRB"
cDesc1  := OemToAnsi("Este programa tem como objetivo, demostrar as ocorrencias")
cDesc2  := OemToAnsi("apresentadas no Arquivo de Retorno da Produçao.")
cDesc3  := ""
tamanho := "M"
aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog:= "PCPR08"
lContinua := .T.
aLinha    := { }
nLastKey  := 0
lEnd := .f.
titulo      :="Ocorrencias de Produçao Por OP."
cabec1      :="Arquivo: "+cArquivo
cabec2      :="Número:     Seq  Produto                           Setor      Data     Quant.     NC   Hora"
            // 99999999999  99  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxxxxx  99/99/99  9.999  9.999  99:99
            // 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
            //           1         2         3         4         5         6         7         8         9        10        11        12        13         14        15        16
cCancel := "***** CANCELADO PELO OPERADOR *****"

li     := 80
m_pag  := 01

wnrel:="PCPR08"            //Nome Default do relatorio em Disco
SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To 
    Return
Endif

RptStatus({|| RptDetail() })// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> RptStatus({|| Execute(RptDetail) })
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RptDetail ³ Autor ³Jorge Silveira da Silva³ Data ³ 12.10.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Impressao do corpo do relatorio                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function RptDetail
Static Function RptDetail()

tValDoc := 0
tValPag := 0
tTotal  := 0

nTipo  := IIF(aReturn[4]==1,15,18)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)

dbSelectArea("TRB")
SET FILTER TO val(TR_QUANT)+val(TR_NC) <> 0
SetRegua(RecCount())
dbGoTop()
While !EOF() .And. lContinua

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
      
      dbselectarea("SC2")
      DBSETORDER(01)
      if !DBSEEK(xFilial("SC2")+TRB->TR_OP)
         msgstop("OP: "+TRB->TR_OP+" nao cadastrada no SC2")
         dbselectarea("TRB")
         DBSKIP()
         LOOP
      ENDIF   
   
      dbselectarea("SH6")
      DBSETORDER(4)
      IF !DBSEEK(xFilial("SH6")+TRB->TR_OP+"  "+TRB->TR_SEQ)
             dbselectarea("SH6")
             reclock("SH6",.T.)
             SH6->H6_FILIAL := "01"
             SH6->H6_OP     := TRB->TR_OP
             SH6->H6_KAMBAN := TRB->TR_SEQ
             SH6->H6_PRODUTO:= SC2->C2_PRODUTO
             SH6->H6_DATAINI:= SC2->C2_DATPRI
             SH6->H6_DATAFIN:= ctod(left(TRB->TR_DTAPON,2)+"/"+SUBS(TRB->TR_DTAPON,3,2)+"/"+right(TRB->TR_DTAPON,4))
             SH6->H6_HORAFIN:= subs(TRB->TR_HORA,1,2)+":"+subs(TRB->TR_HORA,3,2)
             SH6->H6_QTDPROD:= VAL(TRB->TR_QUANT)
             SH6->H6_QTDPERD:= VAL(TRB->TR_NC)
             SH6->H6_DTAPONT:= ctod(left(TRB->TR_DTAPON,2)+"/"+SUBS(TRB->TR_DTAPON,3,2)+"/"+right(TRB->TR_DTAPON,4))
             SH6->H6_DTVALID:= dDataBase
             SH6->H6_DTPROD := ctod(left(TRB->TR_DATA,2)+"/"+SUBS(TRB->TR_DATA,3,2)+"/"+right(TRB->TR_DATA,4))
             msunlock()
             dbselectarea("SC2")
             if SC2->C2_KAMBAN < TRB->TR_SEQ
                reclock("SC2",.F.)
                SC2->C2_KAMBAN := TRB->TR_SEQ
                MSUNLOCK()
             endif
             @ li,000      PSAY TRB->TR_OP
             @ li,PCOL()+2 PSAY TRB->TR_SEQ
             @ li,PCOL()+2 PSAY TRB->TR_DESC
             @ li,PCOL()+2 PSAY TRB->TR_SETOR
             @ li,PCOL()+2 PSAY ctod(left(TRB->TR_DTAPON,2)+"/"+SUBS(TRB->TR_DTAPON,3,2)+"/"+right(TRB->TR_DTAPON,4))
             @ li,PCOL()+2 PSAY TRANSFORM(val(TRB->TR_QUANT),"@E 9,999")
             @ li,PCOL()+2 PSAY TRANSFORM(val(TRB->TR_NC),"@E 9,999")
             @ li,PCOL()+2 PSAY subs(TRB->TR_HORA,1,2)+":"+subs(TRB->TR_HORA,3,2)
             li := li + 1
      ENDIF
      DBSELECTAREA("TRB")   


      If li > 55
         cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
      End

      dbSkip()
Enddo

Roda(0,"","M")
Set Filter To

dbSelectArea("TRB")
dbCloseArea()
fErase( cTRB )
// Ferase( cTRB+OrdBagExt() )

If aReturn[5] == 1
    Set Printer To
    Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PG010Fim ³ Autor ³Jorge Silveira da Silva³ Data ³ 12.10.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de finalizacao da rotina                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function PG010Fim
Static Function PG010Fim()
Close(oDlg)
Return

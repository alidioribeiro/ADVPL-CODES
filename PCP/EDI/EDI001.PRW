#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

User Function EDI001()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NOPCA,ODLG,CMENS,CGRV,CGRVF1,CGRVD1")
SetPrvt("CTYPE,CARQUIVO,ACPO,CTRB,CSTRING,CDESC1")
SetPrvt("CDESC2,CDESC3,TAMANHO,ARETURN,NOMEPROG,LCONTINUA")
SetPrvt("ALINHA,NLASTKEY,LEND,TITULO,CABEC1,CABEC2")
SetPrvt("CCANCEL,LI,M_PAG,WNREL,TVALPAG,TVALCOB")
SetPrvt("TVALOUT,XTITPAG,XTITCOB,XTITOUT,NTIPO,XVALDOC")
SetPrvt("XVALPAG,")                                          

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ EDI001   ³ Autor ³Remerson Yoshiyuki Mogi³ Data ³ 13.02.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ :.Importacao de arquivo de previsao. (HONDA)               ³±±
±±³          ³ alimentando o sistema com os dados da previsão de vendas.  ³±±
±±³          ³                                                             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ver 1.1   ³ :.Alimentar o sistema qndo a data se repetir mas o plano   ³±±
±±³   20.0206³ for modificada, para que fique registrado o historico.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ver 1.2   ³ :.Alterar o registro qndo a data e plano se repetir mas a  ³±±
±±³  01.03.06³ quantidade for modificada.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ver 1.3   ³ :.Somar os produtos "HP0487001A0C000" e "HP0582002A0C003"  ³±±
±±³  03.04.06³ com previsao de venda para o mesmo dia                     ³±±
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
cGrv   := ""

@ 96,13 To 310,592 DIALOG oDlg TITLE "Importacao de arquivo de previsao - HONDA"
@ 18, 6 To 66, 287
@ 29, 15 SAY OemToAnsi("Este programa tem como objetivo Importar dados dos arquivos de previão da Honda.")
@ 80, 160 BUTTON "Importar"  SIZE 34, 11 ACTION A010I()
@ 80, 220 BMPBUTTON TYPE 2 ACTION A010Fim()           
ACTIVATE DIALOG oDlg
Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A010I     ³ Autor ³Remerson Yoshiyuki Mogi³ Data ³ 13/02.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Importacao de dados                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

Static Function A010I()

nOpca    := 0
cType    := "Previsão da Honda | *.TXT"
cArquivo := cGetFile(cType, OemToAnsi("Selecione arquivo "+Subs(cType,1,17)))

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
±±³Fun‡…o    ³ProcImp  ³ Autor ³Remerson Yoshiyuki Mogi³ Data ³ 13/02.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processamento de Importacao dos Dados                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function ProcImp
Static Function ProcImp()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo de Trabalho.                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  aCpo := {}
  
  AADD(aCpo,{"TR_TIPO"    ,"C",01,0})  // 09
  AADD(aCpo,{"TR_CODITE"  ,"C",25,0})  // 10
  AADD(aCpo,{"TR_DESITE"  ,"C",30,0})  // 11
  AADD(aCpo,{"TR_CODSEP"  ,"C",25,0})  // 12
  AADD(aCpo,{"TR_DTSEP"   ,"C",08,0})  // 13
  AADD(aCpo,{"TR_CODFIL"  ,"C",12,0})  // 14
  AADD(aCpo,{"TR_DESSET"  ,"C",30,0})  // 15
  AADD(aCpo,{"TR_QTDTOT"  ,"C",07,0})  // 16
      
  For i:=1 to 43
    AADD(aCpo,{"TR_DATA" + STRZERO(I,2) ,"C",8,0})
    AADD(aCpo,{"TR_PLANO"+ STRZERO(I,2) ,"C",3,0})
    AADD(aCpo,{"TR_QTD"  + STRZERO(I,2) ,"C",7,0})
  Next

  cTRB   := CriaTrab(aCpo,.T.)
  dbUseArea(.T.,,cTRB,"TRB",.T.,.F.)

  //IndRegua( "TRB", cTRB, "TR_DOC",,,"Criando Indice ..." )
  Append From &(cArquivo) SDF // DELIMITED

  A020I()  // Impressao do Relatorio.

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A020I     ³ Autor ³Remerson Yoshiyuki Mogi³ Data ³ 13/02.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Impressao do Arquivo de previsao de vendas.                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

Static Function A020I()

cString := "TRB"
cDesc1  := OemToAnsi("Este programa tem como objetivo, demostrar a utiliza‡Æo ")
cDesc2  := OemToAnsi("das ferramentas de impressÆo do Interpretador xBase.      ")
cDesc3  := "" 
aord    := {"Imprimir","Atualizar"}
tamanho := "M"
aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog:= "EDI001"
lContinua := .T.
aLinha    := { }
nLastKey  := 0
lEnd := .f.
titulo      :="Proposta de Previsão da Honda"
cabec1      :="                                                                      |        P R E V I S Ã O                  " 
cabec2      :=" Codigo Honda          Codigo NSB       Descrição                     | Qtd Total  Data         Qtd/Prod   Plano"               
            //  12345678901234567890  123456789012345  123456789012345678901234567890  1.234.567  DD/MM/AAAA  1.234.567  123456
            // 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
            //           1         2         3         4         5         6         7         8         9        10        11
cCancel := "***** CANCELADO PELO OPERADOR *****"

li     := 80
m_pag  := 01

wnrel:="EDI001"                //Nome Default do relatorio em Disco
SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,aord,,tamanho)

If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

RptStatus({|| RptDetail() })
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RptDetail ³ Autor ³Remerson Yoshiyuki Mogi³ Data ³ 13/02.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Impressao do corpo do relatorio                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

*******************************
Static Function RptDetail()
*******************************
CMES      :={}

AADD(CMES,{"JAN","31"})
AADD(CMES,{"FEV","28"})
AADD(CMES,{"MAR","31"})
AADD(CMES,{"ABR","30"})
AADD(CMES,{"MAI","31"})
AADD(CMES,{"JUN","30"})
AADD(CMES,{"JUL","31"})
AADD(CMES,{"AGO","31"})
AADD(CMES,{"SET","30"})
AADD(CMES,{"OUT","31"})
AADD(CMES,{"NOV","30"})
AADD(CMES,{"DEZ","31"})

//*****************************
//*  DECLARAÇÃO DE VARIAVEIS
//*****************************

vPlanoVD:={}  

xCodProNSB:=""

cHP4:=1
cHP5:=1 
cHP6:=1
cHP7:=1 // Em: 23/01/07
cHP8:=1 // Em: 23/01/07
cHP9:=1 // Em: 23/01/07

nTipo  := IIF(aReturn[4]==1,15,18)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
nOrdem := aReturn[8]
dbSelectArea("TRB")
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
            
         If TR_TIPO == "2"  

            xCodProCli:=SUBS(TR_CODITE,1,20)
            xDescSet  :=SUBS(TR_DESSET,1,30)           
            //Procura o codigo da NIPPON SEIKI
            DBSELECTAREA("SA7")                                //TABELA PRODUTO POR CLIENTE
            DBSETORDER(4) //3
            IF DBSEEK(XFILIAL("SA7") + xCodProCli)             //CODPRODCLI+CLIENTE            
               xCodProNSB:=A7_PRODUTO                          //Codigo NSB             	          	            	            
               DBSELECTAREA("SB1")
               DBSETORDER(1)
               DBSEEK(XFILIAL("SB1") + xCodProNSB)
               xDesProNSB:=SUBS(B1_DESC,1,30)
            ELSE  
               msgstop("Produto Não Cadastrado..." + xCodProCli+"   Cadastre o Produto e Refaça a Atualização")
               return
            END
            DBSELECTAREA("TRB")                 
            //END-Procura o codigo da NIPPON SEIKI
                        
            @ li,001      PSAY SUBS(TR_CODITE,1,20) 
            @ li,PCOL()+2 PSAY SUBS(xCodProNSB,1,15) 
            @ li,PCOL()+2 PSAY xDesProNSB
            @ li,PCOL()+2 PSAY TRANSFORM(VAL(TR_QTDTOT),"@E 9,999,999")          
                      
            For i:=1 to 43
              	xDATA :="TR_DATA" + STRZERO(I,2)
                xPLANO:="TR_PLANO"+ STRZERO(I,2)
                xQTD  :="TR_QTD"  + STRZERO(I,2)
                      
                If &xDATA == "00000000" //.OR. &xQTD=="0000000"
                   loop
                Else
                   @ li,083      PSAY SUBS(&xDATA,1,2)+"/"+SUBS(&xDATA,3,2)+"/"+SUBS(&xDATA,5,4)
                   @ li,PCOL()+2 PSAY TRANSFORM(VAL(&xQTD),"@E 9,999,999") //&xQTD
                
                   dtPrev    := CTOD(SUBS(&xDATA,1,2)+"/"+SUBS(&xDATA,3,2)+"/"+SUBS(&xDATA,5,4))
                   xContPlano:= &xPLANO
                   xQtd      := VAL(&xQTD)
                   xPlano    := CMES[MONTH(dtPrev)][1]+xContPlano                             
                   @ li,PCOL()+2 PSAY xPlano
                   //                      Codigo do Produto + Data + Plano
                   nPos := ASCAN(vPlanoVD,{|X| X[1] == xCodProNSB .AND. dtPrev == X[3] .AND. xPlano==X[5]})
		           IF nPos == 0 				    
			          aAdd(vPlanoVD,{xCodProNSB,;		// 01 COMPONENTE
		                                   xQtd,;		// 02 QUANTIDADE				           
			                             dtPrev,;	    // 03 DATA
			                        DAY(dtPrev),;	    // 04 DIA
			                            xPlano })       // 05 PLANO 
		           ELSE
		               Do case
		                  case xCodProNSB == "HP0487001A0C000" .and. cHP4==2
		                       vPlanoVD[nPos][2]+=xQtd          // 02 QUANTIDADE
		                  case xCodProNSB == "HP0582002A0C003" .and. cHP5==2
		                       vPlanoVD[nPos][2]+=xQtd          // 02 QUANTIDADE 
		                  case xCodProNSB == "HP0640001N0FU00" .and. cHP6==2
		                       vPlanoVD[nPos][2]+=xQtd          // 02 QUANTIDADE
		                  case xCodProNSB == "HP0637002A0CO01" .and. cHP7==2
		                       vPlanoVD[nPos][2]+=xQtd          // 02 QUANTIDADE
		                  case xCodProNSB == "HP0487001A0CO06" .and. cHP8==2
		                       vPlanoVD[nPos][2]+=xQtd          // 02 QUANTIDADE
   		                  case xCodProNSB == "HP0703001A0SX04" .and. cHP9==2
		                       vPlanoVD[nPos][2]+=xQtd          // 02 QUANTIDADE
		                  case xQtd       != vPlanoVD[nPos][2] .and. xQtd!=0
		                       vPlanoVD[nPos][2]:=xQtd          // 02 QUANTIDADE 
		               End case
		   		   ENDIF
                   //
                   If li > 65
                      cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
                   End 
                   
                   li++
                Endif
            Next
         End             
         li := li + 1
         
      If li > 65
         cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
      End
      
      If     xCodProNSB == "HP0487001A0C000" 
         cHP4++
      elseIf xCodProNSB == "HP0582002A0C003"
         cHP5++ 
      elseIf xCodProNSB == "HP0640001N0FU00"
         cHP6++         
      elseIf xCodProNSB == "HP0637002A0CO01"
         cHP7++
	  elseIf xCodProNSB == "HP0487001A0CO06"
	     cHP8++
      elseIf xCodProNSB == "HP0703001A0SX04"
         cHP9++
      End
         
      dbSkip()
End
If nOrdem==2         
//asort(vPlanoVD,,,{|x,y| x[01] + DTOS(x[03]) < y[01] + DTOS(y[03])})
For i:=1 to len(vPlanoVD)
   dbSelectArea("SC4")
   DBSETORDER(2)
   IF DBSEEK(XFILIAL("SC4") + dtos(vPlanoVD[i][3]) + vPlanoVD[i][1] + vPlanoVD[i][5])                  
      //Edit
      RecLock("SC4",.F.)
         SC4->C4_FILIAL := xFilial("SC4")
         SC4->C4_PRODUTO:= vPlanoVD[i][1]
         SC4->C4_QUANT  := vPlanoVD[i][2]         
         SC4->C4_DATA   := vPlanoVD[i][3]
         SC4->C4_DOC    := vPlanoVD[i][5] 
         SC4->(MsUnlock())
      //Edit     
   Else
      //ADD REGISTRO
      RecLock("SC4",.T.)
         SC4->C4_FILIAL := xFilial("SC4")
         SC4->C4_PRODUTO:= vPlanoVD[i][1]
         SC4->C4_LOCAL  := "20"
         SC4->C4_DOC    := vPlanoVD[i][5]
         SC4->C4_QUANT  := vPlanoVD[i][2]  
         SC4->C4_VALOR  := 0
         SC4->C4_DATA   := vPlanoVD[i][3]
         SC4->C4_OBS    := ""
         SC4->C4_GERACAO:= ""
         SC4->C4_NUMOP  := ""
         SC4->C4_NIVEL  := ""
         SC4->C4_OPC    := ""
      MsUnlock()                      
      //ADD REGISTRO                 
   End    
next
end
DBSELECTAREA("TRB")

Roda(0,"","M")
Set Filter To

dbCloseArea()
fErase( cTRB )

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
±±³Fun‡…o    ³ A010Fim  ³ Autor ³Remerson Yoshiyuki Mogi³ Data ³ 13/02.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de finalizacao da rotina                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

**********************************
Static Function A010Fim()
**********************************
Close(oDlg)

Return

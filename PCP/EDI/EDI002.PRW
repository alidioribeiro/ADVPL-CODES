#include "rwmake.ch"       

User Function EDI002()     

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
±±³Fun‡…o    ³ EDI002   ³ Autor ³Remerson Yoshiyuki Mogi³ Data ³ 01.11.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Importacao de arquivo kamban ver 2 Novo layout. (HONDA)    ³±±
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

@ 96,13 To 310,592 DIALOG oDlg TITLE "Importacao de arquivo de kanban - HONDA"
@ 18, 6 To 66, 287
@ 29, 15 SAY OemToAnsi("Este programa tem como objetivo Importar os dados do arquivo (Kanban da Honda).")
@ 80, 160 BUTTON "Importar"  SIZE 34, 11 ACTION A010I()
@ 80, 220 BMPBUTTON TYPE 2 ACTION A010Fim()           
ACTIVATE DIALOG oDlg
Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A010I     ³ Autor ³Remerson Yoshiyuki Mogi³ Data ³ 01.11.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Selecionar o arquivo de Importacao de dados                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A010I()

nOpca    := 0
cType    := "Kanban da Honda | *.TXT"
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
±±³Fun‡…o    ³ ProcImp  ³ Autor ³Remerson Yoshiyuki Mogi³ Data ³ 01.11.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processamento de Importacao dos Dados                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

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
  AADD(aCpo,{"TR_TPOPED"  ,"C",02,0})  // 16
  AADD(aCpo,{"TR_NROPED"  ,"C",08,0})  // 17
  AADD(aCpo,{"TR_DTENTR"  ,"C",08,0})  // 18
  AADD(aCpo,{"TR_CODVIG"  ,"C",03,0})  // 19
  AADD(aCpo,{"TR_QTDTOT"  ,"C",07,0})  // 20
      
  For i:=1 to 24
    AADD(aCpo,{"TR_HRENT" + STRZERO(I,2) ,"C",4,0})
    AADD(aCpo,{"TR_QTD"   + STRZERO(I,2) ,"C",7,0})
    AADD(aCpo,{"TR_LINHA" + STRZERO(I,2) ,"C",6,0})  
  Next

  cTRB   := CriaTrab(aCpo,.T.)
  dbUseArea(.T.,,cTRB,"TRB",.T.,.F.)
  
  
  Append From &(cArquivo) SDF // DELIMITED
  
  A020I()  // Impressao do Relatorio.

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A020I     ³ Autor ³Remerson Yoshiyuki Mogi³ Data ³ 01.11.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Impressao da saida dos produtos a ser faturado.             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
  
// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function A020I
Static Function A020I()
cString :="TRB"
cDesc1  := OemToAnsi("Este programa tem como objetivo, demostrar a utiliza‡Æo ")
cDesc2  := OemToAnsi("das ferramentas de impressÆo do Interpretador xBase.      ")
cDesc3  := ""
tamanho := "M"
aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog:="EDI002"
lContinua := .T.
aLinha    := { }
nLastKey  := 0
lEnd := .f.
titulo      :="                              K A N B A N   D A  H O N D A                                 "
cabec1      :="                                                        |            P R E V I S Ã O               " 
cabec2      :=" Codigo NSB       Descrição                       Modelo|  Nro Ped  Cod  DT. Ent   Hora  Qtd/Prod TP Linha  Fl   Setor"               
            //  123456789012345  123456789012345678901234567890  123456  12345678  123  DD/MM/AA  HH:MM  234.567 99 123456 1234 123456
            // 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
            //           1         2         3         4         5         6         7         8         9        10        11
cCancel := "***** CANCELADO PELO OPERADOR *****"

li     := 80
m_pag  := 01

wnrel:="EDI002"            //Nome Default do relatorio em Disco
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
vProd:={}

xNovoPlano:=.T.
xGravaDB  :=.T.

xCodProNSB:="" 

cPedido :=0
xItem:=0

nTipo  := IIF(aReturn[4]==1,15,18)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)


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
      
      xCodFilial:=TR_CODFIL
      xDesSetor :=TR_DESSET
      xTpPedido :=TR_TPOPED
      xCodProCli:=SUBS(TR_CODITE,1,20)
      xNumPed   :=TR_NROPED                              //Nro pedido do cliente
      xDtEnt    :=TR_DTENTR                              //Data de entrega do pedido
                 
      //Procura o codigo da NIPPON SEIKI
      DBSELECTAREA("SA7")                                //TABELA PRODUTO POR CLIENTE
      DBSETORDER(4) //3
      IF DBSEEK(XFILIAL("SA7") + xCodProCli)             //CODPRODCLI+CLIENTE            
         xCodProNSB   :=A7_PRODUTO                       //Codigo do Produto NSB             	          	            	            
         xDesCliProNSB:=A7_DESCCLI                       //Descrição do Produto no Pedido 

         DBSELECTAREA("SB1")
         DBSETORDER(1)
         DBSEEK(XFILIAL("SB1") + xCodProNSB)
         xTes   :=B1_TS                                  //Tipo de Saida
              
         DBSELECTAREA("TRB")                 
      //END-Procura o codigo da NIPPON SEIKI
                      
         For i:=1 to 24
             xHORA :="TR_HRENT" + STRZERO(I,2)              
             xQTD  :="TR_QTD"   + STRZERO(I,2)              
             xLIN  :="TR_LINHA" + STRZERO(I,2)
                      
             If &xHORA == "0000" .OR. VAL(&xQTD)==0
                loop
                               
             Else  
                xHrEntreg :=&xHORA                       //Hora de entrega do pedido
                xQtd      :=VAL(&xQTD)                   //Qtd do pedido de um determinado item e hora.    

                aAdd(vProd,{xCodProNSB,;	   	         // 01 CODIGO DO PRODUTO
                         xDesCliProNSB,;                 // 02 Descrição do produto
			                   xNumPed,;	             // 03 Nro pedido do cliente
			                    xDtEnt,;                 // 04 Data de entrega do pedido
			                      xTes,;                 // 05 Tipo de Saida do produto
			                 xHrEntreg,;                 // 06 Hora de entrega do pedido
			                      xQtd,;                 // 07 Numero do Item                     
			                     &xlin,;                 // 08 Linha
			                xCodFilial,;                 // 09 Filial
                             xDesSetor,;                 // 10 Setor
                             xTpPedido})                 // 11 Tp pedido
             End     
         Next                 

      ELSE  
         msgstop("Produto Não Cadastrado..." + xCodProCli)
      END                            
      End         
      dbSkip()
End

asort(vProd,,,{|x,y| x[05] + x[06] < y[05] + y[06]})

For i:=1 to len(vProd)                  

         xProd:=vProd[i][1]
         //Capturando os dados dos itens
         DBSELECTAREA("SB1")
         DBSETORDER(1)
         DBSEEK(XFILIAL("SB1") + xProd)         
         xUm    :=B1_UM                                  //Unidade de medida
         xDesProNSB:=B1_DESC                             //Descrição do produto
         xModelo:=B1_MODELO                              //Preço unitario         
         xLocal :=B1_LOCPAD                              //Armazem
         
         DBSELECTAREA("SF4")                             //TABELA PRODUTO POR CLIENTE
         DBSETORDER(1)
         DBSEEK(XFILIAL("SF4") + vProd[i][5])            //FILIAL+CODIGO(TES)
         xCFiscal:= F4_CF
         
         //Capturando os dados dos itens
         DBSELECTAREA("SA1")                             //Capturando dados do cliente
         dbSetOrder(1)
         DBSEEK(XFILIAL("SA1") + "002" )                 //Clinte Honda                                       
         xTabela := A1_TABELA
         xTipoCli:= A1_TIPO
         xCondPg := A1_COND
         xTransp := A1_TRANSP
                 
         DBSELECTAREA("DA0")                             //Capturando a tabela do cliente
         dbSetOrder(1)
         DBSEEK(XFILIAL("DA0") + xTabela )                                                   
                 
         DBSELECTAREA("DA1")                             //Capturando os valores da tabela 
         dbSetOrder(1)                                   //FILIAL + TABELA + PRODUTO
         DBSEEK(XFILIAL("DA1") + xTabela +  xProd)                                                   
         xPrcVen := DA1_PRCVEN         
         //End-Capturando os dados dos itens       

         //Impressão dos itens do pedido              
         @ li,001      PSAY SUBS(vProd[i][1],1,15) 
         @ li,PCOL()+2 PSAY SUBS(xDesProNSB,1,30) 
         @ li,PCOL()+2 PSAY SUBS(xModelo,1,6)        
         
         @ li,PCOL()+2 PSAY vProd[i][3]                  
         @ li,PCOL()+2 PSAY vProd[i][5]
         @ li,PCOL()+2 PSAY SUBS(vProd[i][4],1,2)+"/"+SUBS(vProd[i][4],3,2)+"/"+SUBS(vProd[i][4],7,2)
                  
         @ li,083      PSAY SUBS( vProd[i][6],1,2)+":"+SUBS( vProd[i][6],3,2)         
         @ li,PCOL()+2 PSAY TRANSFORM(vProd[i][7],"@E 999,999") 
         @ li,PCOL()+1 PSAY vProd[i][11] 
         @ li,PCOL()+1 PSAY vProd[i][8]
         @ li,PCOL()+1 PSAY SUBS(vProd[i][9],8,4)
         @ li,PCOL()+1 PSAY SUBS(vProd[i][10],1,20)          
         li++
         
         If vProd[i][5] # vProd[IIF(i>1,i-1,1)][5] .or. vProd[i][6] # vProd[IIF(i>1,i-1,1)][6] .or. i==1        
         
            //NovoProduto
            cPedido:=GetSX8Num("SC5")                       //Indice do ultimo registro
            ConfirmSX8()                                    //Atualizando o registro
            
            dbSelectArea("SC5") 
            dbSetOrder(1)         
            DBSEEK(XFILIAL("SC5") + cPedido) 
            
            xItem:=1                        
            //Tabela Pedidos de Venda
            RecLock("SC5",.T.)
                   SC5->C5_FILIAL := xFilial("SC5")
                   SC5->C5_NUM    := cPedido
                   SC5->C5_TIPO   := "N"
                   SC5->C5_CLIENTE:= "002"
                   SC5->C5_TIPOCLI:= xTipoCli
                   SC5->C5_LOJAENT:= "01"
                   SC5->C5_LOJACLI:= "01"
                   SC5->C5_MOEDA  := 1
                   SC5->C5_ESPECI1:= "GRANEL"
                   SC5->C5_TIPLIB := "1"
                   SC5->C5_CLIENT := "002"
                   SC5->C5_CONDPAG:= xCondPg
                   SC5->C5_TRANSP := xTransp
                   SC5->C5_TABELA := xTabela
                   SC5->C5_MENNOTA:= "FAVOR CHECAR O Nro. DO LACRE 000 ."                   

                   SC5->C5_EMISSAO:= dDataBase
            MsUnlock()         
         end         
       
         //Novo Item
         DBSELECTAREA("SC6")
         dbSetOrder(1)
         DBSEEK(XFILIAL("SC6") + vProd[i][3]  )                                                   
         RecLock("SC6",.T.)
                    SC6->C6_FILIAL := xFilial("SC6")
                    SC6->C6_NUM    := cPedido
                    SC6->C6_PRODUTO:= xProd
                    SC6->C6_UM     := xUm
                    SC6->C6_QTDVEN := vProd[i][7]                           
                    SC6->C6_PRCVEN := xPrcVen
                    SC6->C6_VALOR  := vProd[i][7]*xPrcVen                          
                    SC6->C6_PRUNIT := xPrcVen                           
                    SC6->C6_TES    := vProd[i][5]
                    SC6->C6_CF     := xCFiscal
                    SC6->C6_DESCRI := vProd[i][2]
                    SC6->C6_ITEM   := strzero(xItem,2)
                    SC6->C6_PEDCLI := vProd[i][3]
                    SC6->C6_ENTREG := CTOD(SUBS(vProd[i][4],1,2)+"/"+SUBS(vProd[i][4],3,2)+"/"+SUBS(vProd[i][4],7,2))
                    SC6->C6_HORA   := vProd[i][6]                                                                          
                    SC6->C6_LOCAL  := xLocal
                    SC6->C6_LINHA  := vProd[i][8]
                    SC6->C6_SETOR  := vProd[i][10]
                    SC6->C6_TPEDIDO:= vProd[i][11]
                    SC6->C6_TPOP   := "F"
                    SC6->C6_CLI    := "002"
                    
                    //SC6->C6_CLASFIS    := xSitTrb
			        SC6->(MsUnlock())
                             
         xItem++         
                                 
Next

Roda(0,"","M")
Set Filter To

dbCloseArea()
fErase( cTRB )
dbClearFil(NIL)
dbCloseArea("TRB")
dbCloseArea()

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

